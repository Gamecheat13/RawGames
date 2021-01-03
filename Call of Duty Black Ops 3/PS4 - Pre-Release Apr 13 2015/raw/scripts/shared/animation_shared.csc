#using scripts\shared\ai_shared;
#using scripts\shared\animation_debug_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                             	   	

#namespace animation;
	 
function autoexec __init__sytem__() {     system::register("animation",&__init__,undefined,undefined);    }

function __init__()
{
	setup_notetracks();
}

/@
"Name: first_frame( <animation>, [v_origin_or_ent], [v_angles_or_tag] )"
"Summary: Puts the animating models or AI or vehicles into the first frame of the animation"
"Module: Animation"
"CallOn: The entity to animate."
"MandatoryArg: <animation> The animation to first-frame."
"OptionalArg: [v_origin_or_ent] The origin or entity to align the animation to."
"OptionalArg: [v_angles_or_tag] Option tag to align the animation to."
"Example: ai animation::first_frame( "rappel_animation" );"
@/
function first_frame( animation, v_origin_or_ent, v_angles_or_tag )
{
	self thread play( animation, v_origin_or_ent, v_angles_or_tag, 0 );
}

/@
"Name: last_frame( <animation>, [v_origin_or_ent], [v_angles_or_tag] )"
"Summary: Puts the animating models or AI or vehicles into the last frame of the animation"
"Module: Animation"
"CallOn: The entity to animate."
"MandatoryArg: <animation> The animation to last-frame."
"OptionalArg: [v_origin_or_ent] The origin or entity to align the animation to."
"OptionalArg: [v_angles_or_tag] Option tag to align the animation to."
"Example: ai animation::last_frame( "rappel_animation" );"
@/
function last_frame( animation, v_origin_or_ent, v_angles_or_tag )
{
	self thread play( animation, v_origin_or_ent, v_angles_or_tag, 0, 0, 0, 0, 1 );
}

/@
"Name: play( <animation>, [v_origin_or_ent], [v_angles_or_tag], [n_rate], [n_blend_in], [n_blend_out], [n_lerp] )"
"Summary: Plays an animation"
"Module: Animation"
"CallOn: The entity to animate."
"MandatoryArg: <animation> The animation to play."
"OptionalArg: [v_origin_or_ent] The origin or entity to align the animation to."
"OptionalArg: [v_angles_or_tag] Option tag to align the animation to."
"OptionalArg: [n_rate] Rate scalar for animation speed (.5 for half speed, 4 for super speed)."
"OptionalArg: [n_blend_in] Blend In Time."
"OptionalArg: [n_blend_out] Blend Out Time."
"OptionalArg: [n_lerp] Lerp position over time to smooth out animation."
"OptionalArg: [n_start_time] Time to start the animation at [0-1]."
"Example: ai animation::play( "rappel_animation" );"
"SPMP: singleplayer"
@/
function play( animation, v_origin_or_ent, v_angles_or_tag, n_rate = 1, n_blend_in = .2, n_blend_out = .2, n_lerp = 0, n_start_time = 0 )
{
	self endon( "death" );
	self thread _play( animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp, n_start_time );
	self waittill( "scriptedanim" );
}

function _play( animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp, n_start_time )
{
	self endon( "death" );
	
	self notify( "new_scripted_anim" );
	self endon( "new_scripted_anim" );
	
	flagsys::set_val( "firstframe", n_rate == 0 );
	flagsys::set( "scripted_anim_this_frame" );
	flagsys::set( "scriptedanim" );
	
	if(!isdefined(v_origin_or_ent))v_origin_or_ent=self;
		
	b_link = false;
	
	// Check to see if the entity has an anim rate override set
	if ( isdefined( self.n_script_anim_rate ) )
	{
		n_rate = self.n_script_anim_rate;
	}
	
	if ( IsVec( v_origin_or_ent ) && IsVec( v_angles_or_tag ) )
	{
		self AnimScripted( animation, v_origin_or_ent, v_angles_or_tag, animation, "normal", undefined, n_rate, n_blend_in, n_lerp, n_start_time );
	}
	else
	{
		if ( IsString( v_angles_or_tag ) )
		{
			Assert( isdefined( v_origin_or_ent.model ), "Cannot align animation '" + animation + "' to tag '" + v_angles_or_tag + "' because the animation is not aligned to a model." );
			
			// LinkTo was not working correctly with animation and always positioning the object as if it was linked to the tag_origin
			// Moving the object to the tag position fixes this.
			//self teleport( animation, v_origin_or_ent, v_angles_or_tag );
			
			v_pos = v_origin_or_ent GetTagOrigin( v_angles_or_tag );
			v_ang = v_origin_or_ent GetTagAngles( v_angles_or_tag );
			
			if ( IsActor( self ) )
			{
				self ForceTeleport( v_pos, v_ang );
			}
			else
			{
				self.origin = v_pos;
				self.angles = v_ang;
			}
			
			
			b_link = true;
			
			self LinkTo( v_origin_or_ent, v_angles_or_tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
			self AnimScripted( animation, self.origin, self.angles, animation, "normal", undefined, n_rate, n_blend_in, n_lerp, n_start_time );
		}
		else
		{		
			v_angles = ( isdefined( v_origin_or_ent.angles ) ? v_origin_or_ent.angles : ( 0, 0, 0 ) );
			self AnimScripted( animation, v_origin_or_ent.origin, v_angles, animation, "normal", undefined, n_rate, n_blend_in, n_lerp, n_start_time );
		}
	}
	
	if ( !b_link )
	{
		self Unlink();
	}
	
	if ( IsPlayer( self ) )
	{
		set_player_clamps();
	}
	
	/#
		self thread anim_info_render_thread( animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp );
	#/
	
	if ( !IsAnimLooping( animation ) && ( n_blend_out > 0 ) && ( n_rate > 0 ) && ( n_start_time < 1 ) )
	{
		self thread _blend_out( animation, n_blend_out, n_rate, n_start_time );
	}
	
	self thread handle_notetracks( animation );
	
	self waittillmatch( animation, "end" );
	
	if ( b_link )
	{
		self Unlink();
	}
	
	flagsys::clear( "scriptedanim" );
	flagsys::clear( "firstframe" );
	
	waittillframeend;
	
	flagsys::clear( "scripted_anim_this_frame" );
}

function _blend_out( animation, n_blend, n_rate, n_start_time )
{
	self endon( "death" );
	self endon( "end" );
	self endon( "scriptedanim" );
	self endon( "new_scripted_anim" );
	
	n_len = GetAnimLength( animation );	
	n_len = ( n_len - ( n_len * n_start_time ) ); // get the length we need to wait from the desired start time fraction	
	n_server_length = Floor( n_len / .05 ) * .05; // clamp to full server frames.
	
	n_wait = ( n_server_length - n_blend ) * ( 1 / n_rate );
		
	if ( n_wait > 0 )
	{
		wait n_wait;
		self StopAnimScripted( n_blend );
	}
}

function _get_align_ent( e_align )
{
	e = self;
	if ( isdefined( e_align ) )
	{
		e = e_align;
	}
	
	if(!isdefined(e.angles))e.angles=( 0, 0, 0 );
	return e;
}

function _get_align_pos( v_origin_or_ent, v_angles_or_tag )
{
	if(!isdefined(v_origin_or_ent))v_origin_or_ent=self.origin;
	if(!isdefined(v_angles_or_tag))v_angles_or_tag=(isdefined(self.angles)?self.angles:( 0, 0, 0 ));
	
	s = SpawnStruct();
	
	if ( IsVec( v_origin_or_ent ) )
	{
		Assert( IsVec( v_angles_or_tag ), "Angles must be a vector if origin is." );
		
		s.origin = v_origin_or_ent;
		s.angles = v_angles_or_tag;
	}
	else
	{
		e_align = _get_align_ent( v_origin_or_ent );
					
		if ( IsString( v_angles_or_tag ) )
		{
			s.origin = e_align GetTagOrigin( v_angles_or_tag );
			s.angles = e_align GetTagAngles( v_angles_or_tag );
		}
		else
		{
			s.origin = e_align.origin;
			s.angles = e_align.angles;
		}
	}
	
	if(!isdefined(s.angles))s.angles=( 0, 0, 0 );
	
	return s;
}

/@
"Name: teleport( <ents>, <scene>, <str_tag>, <animname_override> )"
"Summary: Makes an AI move to the position to start an animation."
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <ents> entities that will move."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <str_tag> The str_tag to animate relative to (must exist in the entity this function is called on)."
"OptionalArg: <animname_override> Animname to use instead of ent.animname"
"Example: node teleport( boat, "float_by_the_dock" );"
"SPMP: singleplayer"
@/
function teleport( animation, v_origin_or_ent, v_angles_or_tag )
{
	s = _get_align_pos( v_origin_or_ent, v_angles_or_tag );
	v_pos = GetStartOrigin( s.origin, s.angles, animation );
	v_ang = GetStartAngles( s.origin, s.angles, animation );

	if ( IsActor( self ) )
	{
		self ForceTeleport( v_pos, v_ang );
	}
	else
	{
		self.origin = v_pos;
		self.angles = v_ang;
	}
}



function reach( animation, v_origin_or_ent, v_angles_or_tag, b_disable_arrivals = false )
{
	self endon( "death" );
	s_tracker = SpawnStruct();
	self thread _reach( s_tracker, animation, v_origin_or_ent, v_angles_or_tag, b_disable_arrivals );
	s_tracker waittill( "done" );
}

function _reach( s_tracker, animation, v_origin_or_ent, v_angles_or_tag, b_disable_arrivals = false )
{
	self endon( "death" );
	
	self notify( "stop_going_to_node" );	
	self notify( "new_anim_reach" );
	
	flagsys::wait_till_clear( "anim_reach" ); // let any previous force goal thread cleanup first
    flagsys::set( "anim_reach" );
	
	s = _get_align_pos( v_origin_or_ent, v_angles_or_tag );
	goal = GetStartOrigin( s.origin, s.angles, animation );
	
	n_delta = DistanceSquared( goal, self.origin );
	if ( n_delta > 4 * 4 )
	{
		if ( b_disable_arrivals )
		{
			if ( self ai::has_behavior_attribute( "disablearrivals" ) )
			{
				self ai::set_behavior_attribute( "disablearrivals", true );
			}
		
			// SUMEET TODO - investigate deceleration 
			self.stopanimdistsq = 0.0001; // turns off deceleration
		}
	
		// Rogue controlled robots don't respect force_goal, handle through the rogue_control_force_goal attribute.
		if ( (isdefined(self.archetype) && ( self.archetype == "robot" )) )
		{
			self ai::set_behavior_attribute( "rogue_control_force_goal", goal );
		}
	
		self thread ai::force_goal( goal, 15, true, undefined, true, true );
		
		self util::waittill_any( "goal", "new_anim_reach", "new_scripted_anim", "stop_scripted_anim" );
		
		if ( self ai::has_behavior_attribute( "disablearrivals" ) )
		{
			self ai::set_behavior_attribute( "disablearrivals", false );
			self.stopanimdistsq = 0;	// reset to zero (turns on deceleration)
		}
	}
	else
	{
		waittillframeend;  //  if we skip the reach, we need to wait here to let other script wait for notifies
	}
	
	flagsys::clear( "anim_reach" );
	s_tracker notify( "done" );
	self notify( "reach_done" );
}

/@
"Name: set_death_anim( <animation>, [v_origin_or_ent], [v_angles_or_tag], [n_rate], [n_blend_in], [n_blend_out], [n_lerp] )"
"Summary: Plays an animation on death. Only use on AI."
"Module: Animation"
"CallOn: The entity to animate."
"MandatoryArg: <animation> The animation to play."
"OptionalArg: [v_origin_or_ent] The origin or entity to align the animation to."
"OptionalArg: [v_angles_or_tag] Option tag to align the animation to."
"OptionalArg: [n_rate] Rate scalar for animation speed (.5 for half speed, 4 for super speed)."
"OptionalArg: [n_blend_in] Blend In Time."
"OptionalArg: [n_blend_out] Blend Out Time."
"OptionalArg: [n_lerp] Lerp position over time to smooth out animation."
"Example:ai animation::set_death_anim( "death_animation" );"
"SPMP: singleplayer"
@/
function set_death_anim( animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp )
{
	self notify( "new_death_anim" );
	if ( isdefined( animation ) )
	{
		self thread _do_death_anim( animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp );
	}
}

function _do_death_anim( animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp )
{
	self endon( "new_death_anim" );
	
	self.skipdeath = true;
	self waittill( "death" );
	
	if ( isdefined( self ) && !self IsRagdoll() )
	{
		self play( animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp );
	}
}

function set_player_clamps()
{
	if ( ( isdefined( self.player_anim_look_enabled ) && self.player_anim_look_enabled ) )
	{
		self SetViewClamp(
			self.player_anim_clamp_right,
			self.player_anim_clamp_left,
			self.player_anim_clamp_top,
			self.player_anim_clamp_bottom
		);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Notetrack Handling
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




	
function add_notetrack_func( funcname, func )
{
	if(!isdefined(level._animnotifyfuncs))level._animnotifyfuncs=[];

	Assert( !isdefined( level._animnotifyfuncs[ funcname ] ), "Notetrack function already exists." );
	
	level._animnotifyfuncs[ funcname ] = func;
}

function add_global_notetrack_handler( str_note, func, pass_notify_params, ... )
{
	if(!isdefined(level._animnotetrackhandlers))level._animnotetrackhandlers=[];
	if(!isdefined(level._animnotetrackhandlers[ str_note ]))level._animnotetrackhandlers[ str_note ]=[];
	
	if ( !isdefined( level._animnotetrackhandlers[ str_note ] ) ) level._animnotetrackhandlers[ str_note ] = []; else if ( !IsArray( level._animnotetrackhandlers[ str_note ] ) ) level._animnotetrackhandlers[ str_note ] = array( level._animnotetrackhandlers[ str_note ] ); level._animnotetrackhandlers[ str_note ][level._animnotetrackhandlers[ str_note ].size]=array( func, pass_notify_params, vararg );;
}

function call_notetrack_handler( str_note, param1, param2 )
{
	if ( isdefined( level._animnotetrackhandlers[ str_note ] ) )
	{
		foreach ( handler in level._animnotetrackhandlers[ str_note ] )
		{
			func = handler[0];
			passNotifyParams = handler[1];
			args = handler[2];
			
			if( passNotifyParams )
			{
				self [[ func ]]( param1, param2 );
			}
			else 			
			{
				switch ( args.size )
				{
					case 6:
						self [[ func ]]( args[0], args[1], args[2], args[3], args[4], args[5] );
						break;
					case 5:
						self [[ func ]]( args[0], args[1], args[2], args[3], args[4] );
						break;
					case 4:
						self [[ func ]]( args[0], args[1], args[2], args[3] );
						break;
					case 3:
						self [[ func ]]( args[0], args[1], args[2] );
						break;
					case 2:
						self [[ func ]]( args[0], args[1] );
						break;
					case 1:
						self [[ func ]]( args[0] );
						break;
					case 0:
						self [[ func ]]();
						break;
					default: AssertMsg( "Too many args passed to notetrack handler." );
				}
			}
		}
	}
}

function setup_notetracks()
{
	add_notetrack_func( "flag::set",	&flag::set );
	add_notetrack_func( "flag::clear",	&flag::clear );
	
	clientfield::register( "scriptmover", "cracks_on", 1, GetMinBitCountForNum( 4 ), "int" );
	clientfield::register( "scriptmover", "cracks_off", 1, GetMinBitCountForNum( 4 ), "int" );
	
	add_global_notetrack_handler( "red_cracks_on",		&cracks_on,			false, "red" );
	add_global_notetrack_handler( "green_cracks_on",	&cracks_on,			false, "green" );
	add_global_notetrack_handler( "blue_cracks_on",		&cracks_on,			false, "blue" );
	add_global_notetrack_handler( "all_cracks_on",		&cracks_on,			false, "all" );
	
	add_global_notetrack_handler( "red_cracks_off",		&cracks_off,		false, "red" );
	add_global_notetrack_handler( "green_cracks_off",	&cracks_off,		false, "green" );
	add_global_notetrack_handler( "blue_cracks_off",	&cracks_off,		false, "blue" );
	add_global_notetrack_handler( "all_cracks_off",		&cracks_off,		false, "all" );
	
	add_global_notetrack_handler( "headlook_on",		&enable_headlook,	false, true );
	add_global_notetrack_handler( "headlook_off",		&enable_headlook,	false, false );
	
	add_global_notetrack_handler( "attach weapon", 		&attach_weapon,		true );
	add_global_notetrack_handler( "detach weapon", 		&detach_weapon,		true );	
	add_global_notetrack_handler( "fire", 				&fire_weapon, 		false );
}

function handle_notetracks( animation )
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( animation, str_note, param1, param2 );
		
		if ( isdefined( str_note ) )
		{		
			if ( str_note != "end" && str_note != "loop_end" )
			{
				self thread call_notetrack_handler( str_note, param1, param2 );
			}
			else
			{
				return;
			}
		}
	}
}

function cracks_on( str_type )
{
	switch ( str_type )
	{
		case "red":
			clientfield::set( "cracks_on", 1 );
			break;
		case "blue":
			clientfield::set( "cracks_on", 2 );
			break;
		case "green":
			clientfield::set( "cracks_on", 3 );
			break;
		case "all":
			clientfield::set( "cracks_on", 4 );
			break;
	}
}

function cracks_off( str_type )
{
	switch ( str_type )
	{
		case "red":
			clientfield::set( "cracks_off", 1 );
			break;
		case "blue":
			clientfield::set( "cracks_off", 2 );
			break;
		case "green":
			clientfield::set( "cracks_off", 3 );
			break;
		case "all":
			clientfield::set( "cracks_off", 4 );
			break;
	}
}

function enable_headlook( b_on = true )
{
	if ( IsActor( self ) )
	{
		if ( b_on )
		{
			self LookAtEntity( level.players[0] );
		}
		else
		{
			self LookAtEntity();
		}
	}
}

function is_valid_weapon( weaponObject )
{
	return ( isdefined( weaponObject ) && ( weaponObject != level.weaponNone ) );
}

function attach_weapon( weaponObject, tag = "tag_weapon_right" )
{
	if ( IsActor( self ) )
	{
		if ( is_valid_weapon( weaponObject ) )
		{
			// tag is un-used for actors, may be we can find a use for it in future
			// we assume that he will always use the right hand while animating with a weapon
			ai::gun_switchto( weaponObject.name, "right" );	
		}
		else
		{
			ai::gun_recall();
		}
	}
	else
	{
		if ( !is_valid_weapon( weaponObject ) )
		{
			weaponObject = self.last_item;
		}
		
		if ( is_valid_weapon( weaponObject ) )
		{	
			if ( self.item != level.weaponNone )
			{
				detach_weapon();
			}
			
			assert( isdefined( weaponObject.worldModel ) );
			
			self Attach( weaponObject.worldModel, tag );
			self SetEntityWeapon( weaponObject );
			
			self.gun_removed = undefined;
			self.last_item = weaponObject;
		}
	}
}
	
function detach_weapon( weaponObject, tag = "tag_weapon_right"  )
{
	if ( IsActor( self ) )
	{
		// tag is un-used, may be we can find a use for it in future
		ai::gun_remove();
	}
	else
	{
		if ( !is_valid_weapon( weaponObject ) )
		{
			weaponObject = self.item;
		}
		
		if ( is_valid_weapon( weaponObject ) )
		{		
			self Detach( weaponObject.worldModel, tag );
			self SetEntityWeapon( level.weaponNone );
		}
		
		self.gun_removed = true;
	}
}

function fire_weapon()
{
	if( !IsAI( self ) )
	{
		if( self.item != level.weaponNone )
		{			
			startPos	= self GetTagOrigin( "tag_flash" );
			endPos 		= startPos + VectorScale( AnglesToForward( self GetTagAngles( "tag_flash" ) ), 100 );
			
			// The reason we use .item here instead of .weapon is because, weapon is not part of the 
			// entity fields but rather entity specific fields such as actor fields and such.
			MagicBullet( self.item, startPos, endPos, self );		
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// !Notetrack Handling
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
