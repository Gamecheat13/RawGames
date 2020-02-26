#include maps\_utility;
#include common_scripts\Utility;
#include maps\_anim;

/*
	*********************************
	**********FXANIM SET UP**********
	

*/



// ----------------------------------------------------------------------------------------------------
// ---- FXANIM_INIT - called from _load.gsc ----
// ----------------------------------------------------------------------------------------------------
fxanim_init()
{
	wait 1;
	
	a_fxanims = GetEntArray( "fxanim", "script_noteworthy" );
	
	foreach( m_fxanim in a_fxanims )
	{
		if ( IsDefined( m_fxanim.fxanim_parent ) )
		{
			m_fxanim thread _fxanim_model_link();
		}
		else 
		{
			m_fxanim thread _fxanim_think();
		}
	}
}



// ----------------------------------------------------------------------------------------------------
// ---- KVP-Based FXANIM System ----
// ----------------------------------------------------------------------------------------------------
#using_animtree("fxanim_props");

_fxanim_think()	
{	
	self thread _fxanim_hide();
	self _fxanim_wait();		// if defined, wait until the animation is told to start
	
	self UseAnimTree( #animtree );	
	
	n_anim_count = self _fxanim_get_anim_count();
	
	self notify( "fxanim_start" );
	
	for ( n_current_anim = 0; n_current_anim < n_anim_count; n_current_anim++ )
	{
		str_scene = self _fxanim_get_scene_name( n_current_anim );
		_preprocess_notetracks( str_scene, "fxanim_props" );
		
		self _fxanim_animate( str_scene );
		self _fxanim_play_fx();
		self _fxanim_change_anim( n_current_anim );
	}
}



// ----------------------------------------------------------------------------------------------------
// FXANIM Hiding/Showing
// ----------------------------------------------------------------------------------------------------

// If fxanim_hide is set, hide the model until the animation begins
// self = model the fxanim will be played on
_fxanim_hide()
{
	if ( IsDefined( self.fxanim_hide ) && self.fxanim_hide )
	{
		self Hide();
		self waittill( "fxanim_start" );
		self Show();
	}	
}



// ----------------------------------------------------------------------------------------------------
// FXANIM Wait Functions
// ----------------------------------------------------------------------------------------------------

// Delay playing the animation based on the set kvps.
// self = model the fxanim will be played on
_fxanim_wait()
{
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
				self waittill( "damage", n_dmg, e_attacker, v_dir, v_point, str_mod );
				
				if( a_changer.size > 1 )
				{	
					switch ( str_mod )
					{
						case "MOD_PISTOL_BULLET":		// no break
						case "MOD_RIFLE_BULLET":
							if( is_in_array( a_changer, "bullet" ) )
							{
								is_ready_to_change = true;
							}
							break;
							
						case "MOD_MELEE":				// no break
						case "MOD_BAYONET":
							if( is_in_array( a_changer, "melee" ) )
							{
								is_ready_to_change = true;
							}
							break;
							
						case "MOD_PROJECTILE":			// potentially no break
							if( is_in_array( a_changer, "projectile" ) )
							{
								is_ready_to_change = true;	
							}
							else if( !is_in_array( a_changer, "explosive" ) )
							{
								break;	
							}
							
						case "MOD_GRENADE":				// no break
						case "MOD_EXPLOSIVE":	
							if( is_in_array( a_changer, "explosive" ) )
							{
								is_ready_to_change = true;
							}
							break;
							
						case "MOD_PROJECTILE_SPLASH":	// no break
						case "MOD_GRENADE_SPLASH":
							if( is_in_array( a_changer, "splash" ) )
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
			level waittill( str_waittill );	
		}	
	}
}



// Wait for the current anim to end
// self is the model animating 
_fxanim_wait_for_anim_to_end( n_fxanim_id )
{
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



// get the scenename for the fxanim based on the id (based on fxanim_scene_1, fxanim_scene_2, etc)
// self = model the fxanim will be played on
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
	
	// change how anim is stored if it is a loop
	is_anim_loop = IsAnimLooping( level.scr_anim["fxanim_props"][str_scene_name] );		
	if( is_anim_loop )
	{	
		level.scr_anim["fxanim_props"][str_scene_name + "_loop"][0] = level.scr_anim["fxanim_props"][str_scene_name];
		str_scene_name += "_loop";
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
_fxanim_model_link()
{
	Assert( IsDefined( self.fxanim_tag ), "Model at origin " + self.origin + " needs an fxanim_tag defined, to show which tag the model will link to" );
	
	m_parent = GetEnt( self.fxanim_parent, "targetname" );
	
	Assert( IsDefined( m_parent ), "Model at origin " + self.origin + " does not have a proper parent.  Make sure the fxanim_parent matches the targetname of the fxanim" );
	
	self.origin = m_parent GetTagOrigin( self.fxanim_tag );
	self.angles = m_parent GetTagAngles( self.fxanim_tag );		
	
	self LinkTo( m_parent, self.fxanim_tag );
	
	if ( IsDefined( self.fxanim_hide ) )
	{
		self Hide();
		
		m_parent waittill( "fxanim_start" );
		self Show();
	}
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
				if ( does_exploder_exist( n_exploder ) )
				{
					addNotetrack_exploder( str_animname, str_notetrack, n_exploder, str_scene );
				}
				
				break;
				
			case "stop_exploder":
				
				n_exploder = Int( a_tokens[1] );
				if ( does_exploder_exist( n_exploder ) )
				{
					addNotetrack_exploder( str_animname, str_notetrack, n_exploder, str_scene );
				}
				
				break;
		}
	}
}
