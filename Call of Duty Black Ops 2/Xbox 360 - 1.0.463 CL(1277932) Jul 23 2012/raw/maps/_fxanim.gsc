#include maps\_utility;
#include common_scripts\Utility;
#include maps\_anim;

/*
	*********************************
	**********FXANIM SET UP**********
	

*/

#define FXANIM_IS_MODEL(_self) ( IsDefined( _self.classname ) && ( _self.classname == "script_model" ) )
#define FXANIM_IS_HIDDEN(_self) (IS_TRUE( _self.fxanim_hide ) )

// ----------------------------------------------------------------------------------------------------
// ---- FXANIM_INIT - called from _load.gsc ----
// ----------------------------------------------------------------------------------------------------
fxanim_init()
{
	a_fxanims = GetEntArray( "fxanim", "script_noteworthy" );
	
	foreach( m_fxanim in a_fxanims )
	{
		m_fxanim DisableClientLinkTo();
		
		// if parent model exists, run child thread (child will link to self.fxanim_parent)
		if ( IsDefined( m_fxanim.fxanim_parent ) )
		{
			m_fxanim thread _fxanim_link_child_model();
		}
		else 
		{
			m_fxanim thread _fxanim_setup_parent();
		}
	}
	
	level notify( "_fxanim_parents_initialized" );
}

_fxanim_setup_parent()  // self = script_model
{	
	struct_or_ent = self; // will be script_model in case it isn't converted to a struct
	
	// if fxanim should start in a hidden state, copy KVPs to struct and delete original ent
	if ( FXANIM_IS_HIDDEN( self ) )
	{
		struct_or_ent = SpawnStruct();
		self _fxanim_copy_kvps( struct_or_ent );  // copy relevant KVPs from ent to struct to reduce ent count
		self Delete();
	}	
	
	struct_or_ent thread _fxanim_think();
}

// ----------------------------------------------------------------------------------------------------
// ---- KVP-Based FXANIM System ----
// ----------------------------------------------------------------------------------------------------
#using_animtree("fxanim_props");

_fxanim_think()  // self = script model OR script struct
{	
	self endon( "fxanim_delete" );

	self _fxanim_wait();		// if defined, wait until the animation is told to start
	
	m_fxanim = self;  // default case: self is a script model
	
	// if ent was converted to struct, restore the ent info and animate that instead
	b_is_struct = FXANIM_IS_HIDDEN( self );
	
	if ( b_is_struct )
	{
		m_fxanim = Spawn( "script_model", self.origin );
		self _fxanim_copy_kvps( m_fxanim );	 // internally calls SetModel
	}
	
	self notify( "fxanim_start" );  // send notify out after structs are restored to ents
	
	if ( b_is_struct )
	{
		self structdelete();
	}
	
	b_is_struct = undefined;
	
	// all structs should be converted to models at this point for animation; don't thread to use existing endon
	m_fxanim _fxanim_play_anim_sequence();
}

// plays all animations on a fxanim ent in sequence based on KVPs
_fxanim_play_anim_sequence()  // self = script model
{
	self UseAnimTree( #animtree );	
	
	n_anim_count = self _fxanim_get_anim_count();	
	
	for ( n_current_anim = 0; n_current_anim < n_anim_count; n_current_anim++ )
	{
		str_scene = self _fxanim_get_scene_name( n_current_anim );
		
		if( !self _fxanim_modifier( str_scene ) )	// check if the scene is actually a modifier (hide/delete/etc)
		{
			str_scene = _fxanim_prep_if_looping( str_scene, n_current_anim );	// change scene name if gdt has "Looping" checked
			self thread _preprocess_notetracks( str_scene, "fxanim_props" );
			
			self _fxanim_animate( str_scene );
			self _fxanim_play_fx();
		}
		
		self _fxanim_change_anim( n_current_anim );
	}	
}


// ----------------------------------------------------------------------------------------------------
// FXANIM Hiding/Showing
// ----------------------------------------------------------------------------------------------------

// Instead of defining a scene to play, the fxanim model can be modified (deleted, hidden, etc).  
// Check the scene to see if a modifier is specified instead of a scene
_fxanim_modifier( str_scene )
{
	switch ( str_scene )
	{
		case "delete":		
			self Delete();
			break;
		case "hide":
			self _fxanim_hide_tag_modifier();
			break;
		default:
			return false;
			break;
	}
	
	return true;
}

// Hide a specified joint on the fxanim after the animations have completed
_fxanim_hide_tag_modifier()
{
	Assert( IsDefined( self.fxanim_tag ), "FXAnim at " + self.origin + " has an fxanim_scene of hide, but no fxanim_tag specified." );
	
	self HidePart( self.fxanim_tag );
	self notify( "fxanim hiding tag" );
}

// ----------------------------------------------------------------------------------------------------
// FXANIM Wait Functions
// ----------------------------------------------------------------------------------------------------

// Delay playing the animation based on the set kvps.
// self = model the fxanim will be played on
_fxanim_wait()
{
	self endon( "fxanim_delete" );
	
	// wait for level notify first
	if ( IsDefined( self.fxanim_waittill_1 ) )
	{
		if ( IsDefined( self.fxanim_waittill_1 ) )
		{
			_fxanim_change_anim( -1 );
		}
	}	
	
	// wait for flag second
	if ( IsDefined( self.fxanim_waittill_flag ) )
	{
		flag_wait( self.fxanim_waittill_flag );	
	}
	
	// use wait timers last (wait, wait_min/wait_max)
	if ( IsDefined( self.fxanim_wait ) )
	{
		wait self.fxanim_wait;
	}
	else if ( IsDefined( self.fxanim_wait_min ) && IsDefined( self.fxanim_wait_max ) )
	{
		n_wait_time = RandomFloatRange( self.fxanim_wait_min, self.fxanim_wait_max );
		wait n_wait_time;
	}
	
	
}



// blocking function that waits for various input before playing the next animation
// self = model the fxanim will be played on
_fxanim_change_anim( n_fxanim_id )			// fxanim_change_on( str_change_on, is_loop )
{
	if(!IsDefined(n_fxanim_id) || n_fxanim_id != -1 ) //GLOCKE: optimization to not have duplicate endons depending on call chain
	{
		self endon( "fxanim_delete" );
	}
	
	str_waittill = undefined;
	
	if( n_fxanim_id == -1 && IsDefined( self.fxanim_waittill_1 ) )	// -1, no anim (fxanim_waittill_1 waits before the first anim plays)
	{
		str_waittill = self.fxanim_waittill_1;	
	}	
	else if ( n_fxanim_id == 0 && IsDefined( self.fxanim_waittill_2 ) )
	{
		str_waittill = self.fxanim_waittill_2;	
	}
	else if( n_fxanim_id == 1 && IsDefined( self.fxanim_waittill_3 ) )
	{
		str_waittill = self.fxanim_waittill_3;	
	}
	
	if( !IsDefined( str_waittill ) && n_fxanim_id != -1 )
	{
		self _fxanim_wait_for_anim_to_end( n_fxanim_id );
	}
	else 
	{	
		a_changer = StrTok( str_waittill, "_" );
		
		if( a_changer[0] == "damage" )					// Damage Checks
		{
			is_ready_to_change = false;
			while( !is_ready_to_change )
			{
				self SetCanDamage( true );
				self.health = 9999; // TJanssen - code needs .health and SetCanDamage = true to get "damage" notify; using arbitrarily high number
				//self waittill( "damage", n_dmg, e_attacker, v_dir, v_point, str_mod );
				self waittill( "damage", undefined, undefined, undefined, undefined, str_mod ); //-- GLOCKE: optimization of 4 vars per thread
				
				if( a_changer.size > 1 )
				{	
					switch ( str_mod )
					{
						case "MOD_PISTOL_BULLET":		// no break
						case "MOD_RIFLE_BULLET":
							if( IsInArray( a_changer, "bullet" ) )
							{
								is_ready_to_change = true;
							}
							break;
							
						case "MOD_MELEE":				// no break
						case "MOD_BAYONET":
							if( IsInArray( a_changer, "melee" ) )
							{
								is_ready_to_change = true;
							}
							break;
							
						case "MOD_PROJECTILE":			// potentially no break
							if( IsInArray( a_changer, "projectile" ) )
							{
								is_ready_to_change = true;	
							}
							else if( !IsInArray( a_changer, "explosive" ) )
							{
								break;	
							}
							
						case "MOD_GRENADE":				// no break
						case "MOD_EXPLOSIVE":	
							if( IsInArray( a_changer, "explosive" ) )
							{
								is_ready_to_change = true;
							}
							break;
							
						case "MOD_PROJECTILE_SPLASH":	// no break
						case "MOD_GRENADE_SPLASH":
							if( IsInArray( a_changer, "splash" ) )
							{
								is_ready_to_change = true;
							}
							break;
							
						default:
							break;					
					}			
				}
				else
				{
					is_ready_to_change = true;	
				}
			}
		}
		else											// Wait for level notify
		{
			a_changer = undefined; //-- GLOCKE:  cleanup vars
			level waittill( str_waittill );	
		}	
	}
}



// Wait for the current anim to end
// self is the model animating 
_fxanim_wait_for_anim_to_end( n_fxanim_id )
{
	self endon( "fxanim_delete" );
	
	str_scene = _fxanim_get_scene_name( n_fxanim_id );
	
	if( IsSubStr( str_scene, "_loop" ) )
	{
		self waittillmatch( "looping anim", "end" );
	}
	else 
	{
		self waittillmatch( "single anim", "end" );
	}	
}


// ----------------------------------------------------------------------------------------------------
// FXANIM Anim Functions
// ----------------------------------------------------------------------------------------------------

// Animate the fxanim model
// self = model the fxanim will be played on
_fxanim_animate( str_scene )
{
	// find align entity/struct, if one exists
	e_align = undefined;
	
	if ( IsDefined( self.fxanim_align ) )
	{
		e_align = GetEnt( self.fxanim_align, "targetname" );
		if ( !IsDefined( e_align ) )
		{
			e_align = get_struct( self.fxanim_align );
		}
	}
	
	if ( IsDefined( e_align ) && !IsDefined( e_align.angles ) )
	{
		e_align.angles = (0, 0, 0);
	}
		
	// Animate
	if ( IsSubStr( str_scene, "_loop" ) )
	{
		if ( IsDefined( e_align ) )
		{
			e_align thread anim_loop_aligned( self, str_scene, undefined, "stop_loop", "fxanim_props" );
		}
		else
		{
			self thread anim_loop( self, str_scene, "stop_loop", "fxanim_props" );
		}
	}
	else
	{
		if ( IsDefined( e_align ) )
		{
			e_align thread anim_single_aligned( self, str_scene, undefined, "fxanim_props" );
		}
		else
		{
			self thread anim_single( self, str_scene, "fxanim_props" );
		}
	}	
}
	
	

// ----------------------------------------------------------------------------------------------------
// FXANIM Utility Functions
// ----------------------------------------------------------------------------------------------------

_fxanim_play_fx()
{
	if( IsDefined( self.fxanim_fx_1 ) )
	{
		Assert( IsDefined( self.fxanim_fx_1_tag ), "KVP fxanim_fx_1_tag must be set on fxanim at " + self.origin );
		PlayFXOnTag( GetFX( self.fxanim_fx_1 ), self, self.fxanim_fx_1_tag );
	}
	
	if( IsDefined( self.fxanim_fx_2 ) )
	{
		Assert( IsDefined( self.fxanim_fx_2_tag ), "KVP fxanim_fx_2_tag must be set on fxanim at " + self.origin );
		PlayFXOnTag( GetFX( self.fxanim_fx_2 ), self, self.fxanim_fx_2_tag );
	}
	
	if( IsDefined( self.fxanim_fx_3 ) )
	{
		Assert( IsDefined( self.fxanim_fx_3_tag ), "KVP fxanim_fx_3_tag must be set on fxanim at " + self.origin );
		PlayFXOnTag( GetFX( self.fxanim_fx_3 ), self, self.fxanim_fx_3_tag );
	}
	
	if( IsDefined( self.fxanim_fx_4 ) )
	{
		Assert( IsDefined( self.fxanim_fx_4_tag ), "KVP fxanim_fx_4_tag must be set on fxanim at " + self.origin );
		PlayFXOnTag( GetFX( self.fxanim_fx_4 ), self, self.fxanim_fx_4_tag );
	}
	
	if( IsDefined( self.fxanim_fx_5 ) )
	{
		Assert( IsDefined( self.fxanim_fx_5_tag ), "KVP fxanim_fx_5_tag must be set on fxanim at " + self.origin );
		PlayFXOnTag( GetFX( self.fxanim_fx_5 ), self, self.fxanim_fx_5_tag );
	}	
}



// ----------------------------------------------------------------------------------------------------
// FXANIM Utility Functions
// ----------------------------------------------------------------------------------------------------

// Count the number of anims assigned to this model and returns the number
// self = model the fxanim will be played on
_fxanim_get_anim_count()
{
	Assert( IsDefined( self.fxanim_scene_1 ), "fxanim at position " + self.origin + " needs at least one scene defined.  Use the KVP fxanim_scene_1" );
	
	n_fx_count = 0;
	if ( !IsDefined( self.fxanim_scene_2 ) )
	{
		n_fx_count = 1;	
	}
	else if ( !IsDefined( self.fxanim_scene_3 ) )
	{
		n_fx_count = 2;
	}
	else
	{
		n_fx_count = 3;	
	}
	
	return n_fx_count;
}



_fxanim_get_scene_name( n_anim_id )
{
	str_scene_name = undefined;
	
	switch ( n_anim_id )
	{
		case 0:
			str_scene_name = self.fxanim_scene_1;
			break;
		case 1:
			str_scene_name = self.fxanim_scene_2;
			break;
		case 2:
			str_scene_name = self.fxanim_scene_3;
			break;
	}
	
	return str_scene_name;
}



// get the scenename for the fxanim based on the id (based on fxanim_scene_1, fxanim_scene_2, etc)
// self = model the fxanim will be played on
_fxanim_prep_if_looping( str_scene_name, n_anim_id )
{	
	// change how anim is stored if it is a loop
	is_anim_loop = IsAnimLooping( level.scr_anim["fxanim_props"][str_scene_name] );		
	if( is_anim_loop )
	{	
		level.scr_anim["fxanim_props"][str_scene_name + "_loop"][0] = level.scr_anim["fxanim_props"][str_scene_name];
		str_scene_name += "_loop";
		
		// change the kvp so we can reference it later
		switch ( n_anim_id )
		{
			case 0:
				self.fxanim_scene_1 = str_scene_name;
				break;
			case 1:
				self.fxanim_scene_2 = str_scene_name;
				break;
			case 2:
				self.fxanim_scene_3 = str_scene_name;
				break;
		}		
	}		
	
	return str_scene_name;
}



// checks if the animation is looping or not
// self = model the fxanim will be played on
_fxanim_is_anim_looping( fxanim_scene )
{
	is_anim_loop = IsAnimLooping( level.scr_anim["fxanim_props"][fxanim_scene] );
	
	return is_anim_loop;
}


// ----------------------------------------------------------------------------------------------------
// FXANIM Model Link Functions
// ----------------------------------------------------------------------------------------------------
_fxanim_link_child_model()  // self = script model
{
	Assert( IsDefined( self.fxanim_tag ), "Model at origin " + self.origin + " needs an fxanim_tag defined, to show which tag the model will link to" );
	
	level waittill( "_fxanim_parents_initialized" );  // wait until all fxanim ents have been processed so we grab the correct parent
	
	// IMPORTANT - obj_parent can be script struct OR script model
	obj_parent = _fxanim_get_parent_object( self.fxanim_parent );
	b_parent_is_model = FXANIM_IS_MODEL( obj_parent );
	str_model_parent = obj_parent _fxanim_get_parent_model_name( b_parent_is_model );
	b_hide_child = IsDefined( self.fxanim_hide );  // self may be deleted by the time we evaluate this
	
	obj_parent endon( "fxanim_delete" );
	
	waittill_asset_loaded( "xmodel", str_model_parent );
	str_model_parent = undefined; // only need this once
	b_should_hide_tag = ( IsDefined( obj_parent.fxanim_tag ) && obj_parent.fxanim_tag == self.fxanim_tag );
	
	// if we can use Attach to save ents, we need to store this information in case the fxanim model parent needs hiding
	b_can_attach = obj_parent _fxanim_can_attach_model();
	
	// try to attach to parent
	if ( b_can_attach )
	{
		str_model_child = self.model;
		str_tag = self.fxanim_tag;
		obj_parent _fxanim_add_attached_model();  // store count so we can check when other models want to attach
		self Delete();
		
		if ( b_parent_is_model ) // don't attach if parent is struct
		{
			obj_parent Attach( str_model_child, str_tag );
		}
	}
	else if ( ( !b_can_attach ) && b_parent_is_model ) // don't try to link to a struct if over attachment limit. Note that child models are normally kept under the world prior to running
	{
		self LinkTo( obj_parent, self.fxanim_tag );
	}
	
	// should child model hide before parent fxanim starts?
	if ( b_hide_child )
	{
		if ( b_can_attach )
		{
			if ( b_parent_is_model )
			{
				obj_parent Detach( str_model_child, str_tag );
			}
		}
		else 
		{
			self Hide();
		}
		
		obj_parent waittill( "fxanim_start" );
	
		// bring model back now that anim is playing; ent should always exist by now
		if ( !b_parent_is_model )
		{
			obj_parent = get_ent( obj_parent.targetname, "targetname" );  // .targetname will always be on parent models
		}		
		
		if ( b_can_attach )
		{			
			obj_parent Attach( str_model_child, str_tag );
		}
		else 
		{
			if ( !b_parent_is_model )  // was never linked since parent was struct; link now instead
			{
				self LinkTo( obj_parent, self.fxanim_tag );	
			}
			
			self Show();
		}
	}
	else // children visible
	{
		obj_parent waittill( "fxanim_start" );
				
		// bring model back now that anim is playing; ent should always exist by now
		if ( !b_parent_is_model )
		{
			obj_parent = get_ent( obj_parent.targetname, "targetname" );  // .targetname will always be on parent models
		}
		
		if ( b_can_attach )
		{
			if ( !b_parent_is_model )  // don't try to attach again to existing models; will create runtime error
			{
				obj_parent Attach( str_model_child, str_tag );
			}
		}
		else
		{
			self LinkTo( obj_parent, self.fxanim_tag );	
		}
	}
	
	if ( b_should_hide_tag )	// fxanim_tag will be defined if it has a joint to hide
	{
		obj_parent waittill( "fxanim hiding tag" );
		
		// clean up model if it was never hidden 
		if ( IsDefined( self ) )
		{
			self Delete();
		}
	}
}

_fxanim_get_parent_model_name( b_parent_is_model )
{
	if ( b_parent_is_model )
	{
		str_model = self.model;
	}
	else 
	{
		// parent is struct: .model is read only so it can't be set on them directly; this is set up in _fxanim_copy_kvps()
		str_model = self.model_name;
	}
	
	return str_model;
}

// get the parent script_model or struct for a child script model
_fxanim_get_parent_object( str_targetname )  // self = linked object (script model)
{
	parent_object = get_ent( str_targetname, "targetname" );
	
	if ( !IsDefined( parent_object ) )
	{
		parent_object = get_struct( str_targetname, "targetname" );	
	}
	
	Assert( IsDefined( parent_object ), "Model at origin " + self.origin + " does not have a proper parent.  Make sure the fxanim_parent matches the targetname of the fxanim" );
	
	return parent_object;
}

_fxanim_can_attach_model()  // self = script_model
{
	const MAX_ATTACHMENTS = 4; // limit imposed by code as of 4/20/2012
	
	if ( !IsDefined( self.n_child_models ) )
	{
		self.n_child_models = 0;
	}
	
	return ( self.n_child_models < MAX_ATTACHMENTS );
}

_fxanim_add_attached_model()
{
	self.n_child_models++;
}

/*==============================================================
SELF: level
PURPOSE: Set up notetrack handling for some things to be handled
automatically with notetrack keywords
RETURNS: NA
CREATOR: BrianB (09/15/2011)
===============================================================*/
_preprocess_notetracks( str_scene, str_animname )
{
	animation = get_anim( str_scene, str_animname );
	
	waittill_asset_loaded( "xanim", string( animation ) );
	notetracks = GetNotetracksInDelta( animation, .5, 9999 );
	
	foreach ( info in notetracks )
	{
		str_notetrack = info[1];
		str_notetrack_no_comment = StrTok( str_notetrack, "#" )[0];	// strip out comment
		a_tokens = StrTok( str_notetrack_no_comment, " " );
		
		switch ( a_tokens[0] )
		{
			case "exploder":
				
				n_exploder = Int( a_tokens[1] );
				addNotetrack_exploder( str_animname, str_notetrack, n_exploder, str_scene );
				
				break;
				
			case "stop_exploder":
				
				n_exploder = Int( a_tokens[1] );
				addNotetrack_exploder( str_animname, str_notetrack, n_exploder, str_scene );
				
				break;
		}
	}
	
	notetracks = undefined;  //jpark - cleanup vars
	a_tokens = undefined;
	info = undefined;
}

struct_add_to_level_array( s_target, str_key )
{
	// we only care about targetname and script_noteworthy in the level.struct_class_names array, so only look at those
	if ( str_key == "targetname" )
	{
		Assert( IsDefined( s_target.targetname ), "targetname parameter missing from struct " );
		_struct_add_to_level_array_internal( "targetname", s_target.targetname, s_target );
	}
	else if ( str_key ==  "script_noteworthy" )
	{
		Assert( IsDefined( s_target.script_noteworthy ), "script_noteworthy parameter missing from struct" );
		_struct_add_to_level_array_internal( "script_noteworthy", s_target.script_noteworthy, s_target );
	}		
	else 
	{
		AssertMsg( str_key + " is not a supported str_key for struct_add_to_level_array. Available options: targetname, script_noteworthy." );
	}
}

_struct_add_to_level_array_internal( str_key, str_value, s_target )
{
	// initialize if it doesn't already exist
	if ( !IsDefined( level.struct_class_names[ str_key ][ str_value ] ) )
	{
		level.struct_class_names[ str_key ][ str_value ] = [];
	}
		
	// add to array for lookup
	level.struct_class_names[ str_key ][ str_value ][ level.struct_class_names[ str_key ][ str_value ].size ] = s_target;  		
}

// copies fxanim-specific KVPs from one object to another; i.e. ent -> struct, or struct -> ent
_fxanim_copy_kvps( target )  // self = ent or struct containing fxanim specific KVPs
{
	// ----- general KVPs -----
	if ( IsDefined( self.script_noteworthy ) )
	{
		target.script_noteworthy = self.script_noteworthy;
		
		// add manually since SpawnStruct doesn't do this by default, and we need getstruct to find it	
		if ( !FXANIM_IS_MODEL( target ) )
		{
			struct_add_to_level_array( target, "script_noteworthy" );
		}		
	}
	
	if ( IsDefined( self.targetname ) )
	{
		target.targetname = self.targetname;

		// add manually since SpawnStruct doesn't do this by default, and we need getstruct to find it	
		if ( !FXANIM_IS_MODEL( target ) )
		{
			struct_add_to_level_array( target, "targetname" );
		}		
	}
	
	// script_string used for safe deletion of fxanim objects
	if ( IsDefined( self.script_string ) )
	{
		target.script_string = self.script_string;
	}
	
	if ( IsDefined( self.origin ) )
	{
		target.origin = self.origin;
	}
	
	if ( IsDefined( self.angles ) )
	{
		target.angles = self.angles;
	}
	
	if ( IsDefined( self.model ) )
	{
		// .model is a read-only field as dictated by code, so .model needs to be stored elsewhere (.model_name)
		target.model_name = self.model;
	}
	
	// .model_name is a value that should only be used by this function; used for transferring struct .model into to new script_model
	if ( IsDefined( self.model_name ) )
	{
		if ( IsDefined( target.classname ) && ( target.classname == "script_model" ) )
		{
			target SetModel( self.model_name );
		}
	}
	
	// ----- fxanim specific KVPs -----
	
	// a_fxanim_child_models - this is kept on parent models with several attached/linked children
	if ( IsDefined( self.a_fxanim_child_models ) )
	{
		target.a_fxanim_child_models = self.a_fxanim_child_models;
	}
	
	// fxanim_scene_1
	if ( IsDefined( self.fxanim_scene_1 ) )
	{
		target.fxanim_scene_1 = self.fxanim_scene_1;
	}
	
	// fxanim_scene_2
	if ( IsDefined( self.fxanim_scene_2 ) )
	{
		target.fxanim_scene_2 = self.fxanim_scene_2;
	}
	
	// fxanim_scene_3
	if ( IsDefined( self.fxanim_scene_3 ) )
	{
		target.fxanim_scene_3 = self.fxanim_scene_3;
	}
	
	// fxanim_waittill
	if ( IsDefined( self.fxanim_waittill ) )
	{
		target.fxanim_waittill = self.fxanim_waittill;
	}
	
	// fxanim_waittill_1
	if ( IsDefined( self.fxanim_waittill_1 ) )
	{
		target.fxanim_waittill_1 = self.fxanim_waittill_1;
	}
	
	// fxanim_waittill_2
	if ( IsDefined( self.fxanim_waittill_2 ) )
	{
		target.fxanim_waittill_2 = self.fxanim_waittill_2;
	}
	
	// fxanim_Waittill_3
	if ( IsDefined( self.fxanim_waittill_3 ) )
	{
		target.fxanim_waittill_3 = self.fxanim_waittill_3;
	}
	
	// fxanim_waittill_flag
	if ( IsDefined( self.fxanim_waittill_flag ) )
	{
		target.fxanim_waittill_flag = self.fxanim_waittill_flag;
	}
	
	// fxanim_fx_1
	if ( IsDefined( self.fxanim_fx_1 ) )
	{
		target.fxanim_fx_1 = self.fxanim_fx_1;
	}
	
	// fxanim_fx_2
	if ( IsDefined( self.fxanim_fx_2 ) )
	{
		target.fxanim_fx_2 = self.fxanim_fx_2;
	}
	
	// fxanim_fx_3
	if ( IsDefined( self.fxanim_fx_3 ) )
	{
		target.fxanim_fx_3 = self.fxanim_fx_3;
	}
	
	// fxanim_fx_4
	if ( IsDefined( self.fxanim_fx_4 ) )
	{
		target.fxanim_fx_4 = self.fxanim_fx_4;
	}
	
	// fxanim_fx_5
	if ( IsDefined( self.fxanim_fx_5 ) )
	{
		target.fxanim_fx_5 = self.fxanim_fx_5;
	}
	
	// fxanim_fx_1_tag
	if ( IsDefined( self.fxanim_fx_1_tag ) )
	{
		target.fxanim_fx_1_tag = self.fxanim_fx_1_tag;
	}
	
	// fxanim_fx_2_tag
	if ( IsDefined( self.fxanim_fx_2_tag ) )
	{
		target.fxanim_fx_2_tag = self.fxanim_fx_2_tag;
	}
	
	// fxanim_fx_3_tag
	if ( IsDefined( self.fxanim_fx_3_tag ) )
	{
		target.fxanim_fx_3_tag = self.fxanim_fx_3_tag;
	}
	
	// fxanim_fx_4_tag
	if ( IsDefined( self.fxanim_fx_4_tag ) )
	{
		target.fxanim_fx_4_tag = self.fxanim_fx_4_tag;
	}
	
	// fxanim_fx_5_tag
	if ( IsDefined( self.fxanim_5_tag ) )
	{
		target.fxanim_fx_5_tag = self.fxanim_fx_5_tag;
	}
	
	// fxanim_parent 
	if ( IsDefined( self.fxanim_parent ) )
	{
		target.fxanim_parent = self.fxanim_parent;
	}
	
	// fxanim_tag
	if ( IsDefined( self.fxanim_tag ) )
	{
		target.fxanim_tag = self.fxanim_tag;
	}
	
	// fxanim_speed
	if ( IsDefined( self.fxanim_speed ) )
	{
		target.fxanim_speed = self.fxanim_speed;
	}
	
	// fxanim_align
	if ( IsDefined( self.fxanim_align ) )
	{
		target.fxanim_align = self.fxanim_align;
	}
	
	// fxanim_wait
	if ( IsDefined( self.fxanim_wait ) )
	{
		target.fxanim_wait = self.fxanim_wait;
	}
	
	// fxanim_wait_min
	if ( IsDefined( self.fxanim_wait_min ) )
	{
		target.fxanim_wait_min = self.fxanim_wait_min;
	}
	
	// fxanim_wait_max
	if ( IsDefined( self.fxanim_wait_max ) )
	{
		target.fxanim_wait_max = self.fxanim_wait_max;
	}
	
	// fxanim_hide
	if ( IsDefined( self.fxanim_hide ) )
	{
		target.fxanim_hide = self.fxanim_hide;
	}
	
	// fxanim_scene_1_loop
	if ( IsDefined( self.fxanim_scene_1_loop ) )
	{
		target.fxanim_scene_1_loop = self.fxanim_scene_1_loop;
	}
	
	// fxanim_scene_2_loop
	if ( IsDefined( self.fxanim_scene_2_loop ) )
	{
		target.fxanim_scene_2_loop = self.fxanim_scene_2_loop;
	}
	
	// fxanim_scene_3_loop
	if ( IsDefined( self.fxanim_3_loop ) )
	{
		target.fxanim_3_loop = self.fxanim_3_loop;
	}
	
	// fxanim_fx
	if ( IsDefined( self.fxanim_fx ) )
	{
		target.fxanim_fx = self.fxanim_fx;
	}
}

/@
"Name: fxanim_delete( <str_script_string>, [b_assert_if_missing] )"
"Summary: deletes fxanim objects (entities or structs) safely, and kills all threads running on them"
"Module: FXAnim"
"MandatoryArg: <str_script_string> script_string KVP on the fxanim object to be deleted. Make sure this exists on parent and child"
"OptionalArg: [b_assert_if_missing] optional assert if fxanim_delete finds no objects with specified KVP. Defaults to false."
"Example: fxanim_delete( "intro_fxanims", true );"
"SPMP: singleplayer"
@/
fxanim_delete( str_script_string, b_assert_if_missing = false )
{
	Assert( IsDefined( str_script_string ), "str_script_string is a required argument for fxanim_delete" );
	
	// get all fxanim models and structs
	a_fxanims = ArrayCombine(  GetEntArray( "fxanim", "script_noteworthy" ), getstructarray( "fxanim", "script_noteworthy" ), false, false );
	
	n_delete_counter = 0;
	
	// get all parented objects
	foreach( object in a_fxanims )
	{
		if ( IsDefined( object.script_string ) && ( object.script_string == str_script_string ) )
		{
			n_delete_counter++; 
			object notify( "fxanim_delete" );  // kill any threads associated with this object
			if ( FXANIM_IS_MODEL( object ) )
			{
				object Delete();
			}
			else // object = struct
			{
				object structdelete();
			}
		}
	}
	
	if ( b_assert_if_missing )
	{
		Assert( ( n_delete_counter > 0 ), "fxanim_delete could not find any fxanim objects with script_string " + str_script_string );
	}
}
