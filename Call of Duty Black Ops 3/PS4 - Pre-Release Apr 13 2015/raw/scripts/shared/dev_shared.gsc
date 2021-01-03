#using scripts\codescripts\struct;

#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace doors;




class cDoor
{
	var m_s_bundle;							// Bundle with info regarding the door.
	var m_str_targetname;
	var m_str_target;
	var m_str_script_flag;
	
	var m_e_door;							// Door Ent

	var m_e_trigger;						// Trigger Ent
	var	m_e_trigger_player;					// Player who opens the door
	var m_n_trigger_height;
	
	var m_n_hack_pct;						// percentage of the current hack completed.
	var m_b_hacking;						// true if hacking is currently taking place.
	
	var m_e_hint_trigger;

	var m_v_open_pos;						// Door open and close positions (for slide doors)
	var m_v_close_pos;
	
	var m_n_door_connect_paths;				// Does door connect paths?

	var m_b_is_open;						// Is the door open?

	// Overrides that can be set in script
	var m_override_swing_angle;

	var m_door_open_delay_time;				// Ability to delat the door opening
	
	constructor()
	{
		m_n_trigger_height = 80;			// Default trigger height
		m_override_swing_angle = undefined;
		m_door_open_delay_time = 0;
		m_e_trigger_player = undefined;
	}

	destructor()
	{
		if( IsDefined(m_e_trigger) )
		{
			m_e_trigger delete();
		}
	}

	function init_xmodel( str_xmodel, connect_paths, v_origin, v_angles )
	{
		if( !IsDefined(str_xmodel) )
		{
			str_xmodel = "script_origin";
			//ASSERTMSG( "No model found in Door Script Bundle" );
			//return;
		}

		m_e_door = spawn( "script_model", v_origin, 1 );
		m_e_door setModel( str_xmodel );
		m_e_door.angles = v_angles;
		
		if(connect_paths)
		{
			m_e_door DisconnectPaths();
		}			
	}
	
	function get_hack_pos()
	{
		v_trigger_offset = m_s_bundle.v_trigger_offset;
	
		v_pos = calculate_offset_position( m_e_door.origin, m_e_door.angles, v_trigger_offset );
		v_pos = ( v_pos[0], v_pos[1], v_pos[2]+50 );		// Its a look at trigger, so move the base of the trigger off the ground
		
		if ( IsDefined( m_str_target ) )
		{
			e_target = GetEnt( m_str_target, "targetname" );
			if ( IsDefined( e_target ) )
			{
				return e_target.origin;
			}
		}
		
		return v_pos;
	}
	
	function get_hack_angles()
	{
		v_angles = m_e_door.angles;
		
		if ( IsDefined( m_str_target ) )
		{
			e_target = GetEnt( m_str_target, "targetname" );
			if ( IsDefined( e_target ) )
			{
				return e_target.angles;
			}
		}
		
		return v_angles;
	}
	
	function init_hint_trigger()
	{
		// Only certain types of doors have this trigger.
		//
		if ( m_s_bundle.door_unlock_method == "default" && !( isdefined( m_s_bundle.door_trigger_at_target ) && m_s_bundle.door_trigger_at_target ) )
		{
			return;
		}
		
		// Keys don't use a hint trigger.
		//
		if ( m_s_bundle.door_unlock_method == "key" )
		{
			return;
		}
		
		v_offset = m_s_bundle.v_trigger_offset;
		n_radius = m_s_bundle.door_trigger_radius;
		
		v_pos = calculate_offset_position( m_e_door.origin, m_e_door.angles, v_offset );
		
		// Its a look at trigger, so move the base of the trigger off the ground
		v_pos = ( v_pos[0], v_pos[1], v_pos[2]+50 );

		e_trig = spawn( "trigger_radius_use", v_pos, 0, n_radius, m_n_trigger_height );
		e_trig TriggerIgnoreTeam();

		e_trig SetVisibleToAll();
		e_trig SetTeamForTrigger( "none" );
		e_trig UseTriggerRequireLookAt();

		e_trig SetCursorHint( "HINT_NOICON" );
		
		m_e_hint_trigger = e_trig;
		
		thread process_hint_trigger_message();
	}

	function lock()
	{
		self flag::set( "locked" );
		update_use_message();
	}
	
	function unlock()
	{
		self flag::clear( "locked" );
	}
	
	function open()
	{
		self flag::set( "open" );
	}
	
	function close_internal()
	{
		self flag::clear( "open" );
		set_script_flags( false );
		
		self flag::set( "animating" );
		
		if( ( isdefined( m_s_bundle.b_loop_sound ) && m_s_bundle.b_loop_sound ) )
		{
			m_e_door playsound( m_s_bundle.door_start_sound );
			sndEnt = spawn( "script_origin", m_e_door.origin );
			sndEnt linkto( m_e_door );
			sndEnt playloopsound( m_s_bundle.door_loop_sound, 1 );
		}
		else if ( IsDefined(m_s_bundle.door_stop_sound) && m_s_bundle.door_stop_sound != "" )
		{
			m_e_door playsound( m_s_bundle.door_stop_sound );
		}

		// Close Door
		if( m_s_bundle.door_open_method == "slide" )
		{
			m_e_door MoveTo( m_v_close_pos, m_s_bundle.door_open_time );
		}
		else if( m_s_bundle.door_open_method == "swing" )
		{
			angle = GetSwingAngle();
			v_angle = ( m_e_door.angles[0], m_e_door.angles[1]-angle, m_e_door.angles[2] );
			m_e_door RotateTo( v_angle, m_s_bundle.door_open_time );
		}
		// TODO: Animated - Closing

		wait( m_s_bundle.door_open_time );

		if( ( isdefined( m_n_door_connect_paths ) && m_n_door_connect_paths ) )
		{
			m_e_door DisconnectPaths();
		}
		
		if( ( isdefined( m_s_bundle.b_loop_sound ) && m_s_bundle.b_loop_sound ) )
		{
			sndEnt delete();
			m_e_door playsound( m_s_bundle.door_stop_sound );
		}
		
		flag::clear( "animating" );
		
		update_use_message();
	}
	
	function close()
	{
		self flag::clear( "open" );
	}
	
	function open_internal()
	{		
		self flag::set( "animating" );

		m_e_door notify( "door_opening" );
		
		// Play the opening sound.
		if ( IsDefined(m_s_bundle.door_start_sound) && m_s_bundle.door_start_sound != "" )
		{
			m_e_door playsound( m_s_bundle.door_start_sound );
		}
		
		// Play the looping door "open" sound.
		if( ( isdefined( m_s_bundle.b_loop_sound ) && m_s_bundle.b_loop_sound ) )
		{
			sndEnt = spawn( "script_origin", m_e_door.origin );
			sndEnt linkto( m_e_door );
			sndEnt playloopsound( m_s_bundle.door_loop_sound, 1 );
		}

		if( m_s_bundle.door_open_method == "slide" )
		{
			m_e_door MoveTo( m_v_open_pos, m_s_bundle.door_open_time );
		}
		else if( m_s_bundle.door_open_method == "swing" )
		{
			angle = GetSwingAngle();
			v_angle = ( m_e_door.angles[0], m_e_door.angles[1]+angle, m_e_door.angles[2] );
			m_e_door RotateTo( v_angle, m_s_bundle.door_open_time );
		}
		
		if( ( isdefined( m_n_door_connect_paths ) && m_n_door_connect_paths ) )
		{
			m_e_door ConnectPaths();
		}

		wait( m_s_bundle.door_open_time );
		
		if( ( isdefined( m_s_bundle.b_loop_sound ) && m_s_bundle.b_loop_sound ) )
		{
			sndEnt delete();
		}
		
		if ( IsDefined(m_s_bundle.door_stop_sound) && m_s_bundle.door_stop_sound != "" )
		{
			m_e_door playsound( m_s_bundle.door_stop_sound );
		}
		
		flag::clear( "animating" );
		set_script_flags( true );
		
		update_use_message();
	}
	
	function update_use_message()
	{		
		if ( !( isdefined( m_s_bundle.door_use_trigger ) && m_s_bundle.door_use_trigger ) )
		{
			return;
		}
		
		if ( self flag::get("open") )
		{
			if ( !( isdefined( m_s_bundle.door_closes ) && m_s_bundle.door_closes ) )
			{
				m_e_trigger SetHintString( "" );
			} 
			else 
			{
				m_e_trigger SetHintString( "Hold ^3[{+activate}]^7 to close door" );
			}
		} 
		else 
		{
			// TODO - Localize the string, &"HINT_DOOR"
			if( IsDefined(m_s_bundle.door_open_message) && (m_s_bundle.door_open_message != "") )
			{
				m_e_trigger SetHintString( m_s_bundle.door_open_message );
			}
			else if (( isdefined( m_s_bundle.door_use_hold ) && m_s_bundle.door_use_hold ))
			{
				m_e_trigger SetHintString( "Hold ^3[{+activate}]^7 to hold door open" );
			}
			else if (m_s_bundle.door_unlock_method == "key") 
			{
				m_e_trigger SetHintString( "Hold ^3[{+activate}]^7 to open door [cost: 1 key]" );
			}
			else if( self flag::get( "locked" ) )
			{
				m_e_trigger SetHintString( "Door Locked" );
			}
			else
			{
				m_e_trigger SetHintString( "Hold ^3[{+activate}]^7 to open door" );
			}
		}
	}
	
	function run_lock_fx()
	{		
		if ( !IsDefined(m_s_bundle.door_locked_fx) && !IsDefined(m_s_bundle.door_unlocked_fx) )
		{
			return;
		}
		
		e_fx = undefined;
		v_pos = get_hack_pos();
		v_angles = get_hack_angles();
		
		while ( true )
		{
			self flag::wait_till( "locked" );
			
			if ( isdefined( e_fx ) )
			{
				e_fx delete();
				e_fx = undefined;
			}
			
			if ( IsDefined(m_s_bundle.door_locked_fx) )
			{
				e_fx = Spawn( "script_model", v_pos );
				e_fx SetModel( "tag_origin" );
				e_fx.angles = v_angles;
				PlayFXOnTag( m_s_bundle.door_locked_fx, e_fx, "tag_origin" );
			}
			
			self flag::wait_till_clear( "locked" );
			
			if ( isdefined( e_fx ) )
			{
				e_fx delete();
				e_fx = undefined;
			}
			
			if ( IsDefined(m_s_bundle.door_unlocked_fx) )
			{
				e_fx = Spawn( "script_model", v_pos );
				e_fx SetModel( "tag_origin" );
				e_fx.angles = v_angles;
				PlayFXOnTag( m_s_bundle.door_unlocked_fx, e_fx, "tag_origin" );
			}
		}
	}
	
	function process_hint_trigger_message()
	{
		str_hint = "";
		if ( ( isdefined( m_s_bundle.door_trigger_at_target ) && m_s_bundle.door_trigger_at_target ) )
		{
			str_hint = "This door is controlled elsewhere";
		} 
		else if (m_s_bundle.door_unlock_method == "hack") 
		{
			str_hint = "This door is electronically locked";
		}
		
		while ( true )
		{
			m_e_hint_trigger SetHintString(str_hint);
			
			if ( ( isdefined( m_s_bundle.door_trigger_at_target ) && m_s_bundle.door_trigger_at_target ) )
			{
				self flag::wait_till( "open" );
			} 
			else 
			{
				self flag::wait_till_clear( "locked" );
			}
			
			m_e_hint_trigger SetHintString("");
			
			if ( ( isdefined( m_s_bundle.door_trigger_at_target ) && m_s_bundle.door_trigger_at_target ) )
			{
				self flag::wait_till_clear( "open" );
			} 
			else 
			{
				self flag::wait_till( "locked" );
			}
		}
	}

	function init_trigger( v_offset, n_radius )
	{		
		v_pos = calculate_offset_position( m_e_door.origin, m_e_door.angles, v_offset );
		
		// Its a look at trigger, so move the base of the trigger off the ground
		v_pos = ( v_pos[0], v_pos[1], v_pos[2]+50 );
		
		if ( ( isdefined( m_s_bundle.door_trigger_at_target ) && m_s_bundle.door_trigger_at_target ) )
		{
			e_target = GetEnt( m_str_target, "targetname" );
			if ( IsDefined( e_target ) )
			{
				v_pos = e_target.origin;
			}
		}

		// Does the trigger need a USE prompt?		
		if( ( isdefined( m_s_bundle.door_use_trigger ) && m_s_bundle.door_use_trigger ) )
		{
			m_e_trigger = spawn( "trigger_radius_use", v_pos, 0, n_radius, m_n_trigger_height );
			m_e_trigger TriggerIgnoreTeam();

			m_e_trigger SetVisibleToAll();
			m_e_trigger SetTeamForTrigger( "none" );
			m_e_trigger UseTriggerRequireLookAt();

			m_e_trigger SetCursorHint( "HINT_NOICON" );
		}
		else
		{
			m_e_trigger = spawn( "trigger_radius", v_pos, 0, n_radius, m_n_trigger_height );
		}
	}

	function set_script_flags( b_set )
	{
		if ( IsDefined( m_str_script_flag ) )
		{
			a_flags = StrTok(m_str_script_flag, ",");
			foreach( str_flag in a_flags )
			{
				if ( b_set )
				{
					level flag::set(str_flag);
				} 
				else 
				{
					level flag::clear(str_flag);
				}
			}
		}
	}
	
	function init_movement( n_slide_up, n_slide_amount )
	{
		if( m_s_bundle.door_open_method == "slide" )
		{
			// Setup the open and close offsets
			if( n_slide_up )
			{
				v_offset = ( 0, 0, n_slide_amount );
			}
			else
			{
				v_offset = ( n_slide_amount, 0, 0 );
			}

			m_v_open_pos = calculate_offset_position( m_e_door.origin, m_e_door.angles, v_offset );
			m_v_close_pos = m_e_door.origin;
		}
	}

	function set_door_paths( n_door_connect_paths )
	{
		m_n_door_connect_paths = n_door_connect_paths;
	}

	// TODO (Slone): There's no reason to pass these variables in.  The info is available via the bundle.
	//
	function calculate_offset_position( v_origin, v_angles, v_offset )
	{
		v_pos = v_origin;

		if( v_offset[0] )
		{
			v_side = anglestoforward( v_angles );		// X Axis = Forward
			v_pos = v_pos + (v_offset[0] * v_side);
		}
		if( v_offset[1] )
		{
			v_dir = anglestoright( v_angles );
			v_pos = v_pos + (v_offset[1] * v_dir);
		}
		if( v_offset[2] )
		{
			v_up = anglestoup( v_angles );
			v_pos = v_pos + (v_offset[2] * v_up);
		}
		
		return( v_pos );
	}

	// Override the doors swing angle
	function set_swing_angle( angle )
	{
		m_override_swing_angle = angle;
	}

	function GetSwingAngle()
	{
		if( IsDefined(m_override_swing_angle) )
		{
			angle = m_override_swing_angle;
		}
		else
		{
			angle = m_s_bundle.door_swing_angle;
		}
		return( angle );
	}

	function SetDoorOpenDelay( delay_time )
	{
		m_door_open_delay_time = delay_time;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////// Utility /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

function autoexec __init__sytem__() {     system::register("doors",&__init__,undefined,undefined);    }

function __init__()
{	
	a_doors = struct::get_array( "scriptbundle_doors", "classname" );		// "_doors" auto generates from the TYPE field in the bundle
	foreach ( s_instance in a_doors )
	{
		c_door = s_instance init();
		if (isdefined(c_door) )
		{
			s_instance.c_door = c_door;
		}
	}
}


//*****************************************************************************
//*****************************************************************************

// self = door bundle instance (The Script Script Instance, holds position, angles, targetname etc..)
function init()
{	
	if( !IsDefined(self.angles) )
	{	
		self.angles = (0, 0 ,0 );
	}
		
	s_door_bundle = level.scriptbundles[ "doors" ][ self.scriptbundlename ];
		
	return setup_door_scriptbundle( s_door_bundle, self );
}


//*****************************************************************************
//*****************************************************************************

function setup_door_scriptbundle( s_door_bundle, s_door_instance )
{
	c_door = new cDoor();
	
	c_door flag::init( "locked", false );
	c_door flag::init( "open", false );
	c_door flag::init( "animating", false );

	c_door.m_s_bundle = s_door_bundle;
	c_door.m_str_targetname = s_door_instance.targetname;
	c_door.m_str_target = s_door_instance.target;
	c_door.m_str_script_flag = s_door_instance.script_flag;

	//*************************
	// Get the Door Bundle Data
	//*************************
	
	if ( c_door.m_s_bundle.door_unlock_method == "key" )
	{		
		if ( IsDefined( c_door.m_s_bundle.door_key_model ) )
		{
			level.door_key_model = c_door.m_s_bundle.door_key_model;
		}
		
		if ( IsDefined( c_door.m_s_bundle.door_key_icon ) )
		{
			level.door_key_icon = c_door.m_s_bundle.door_key_icon;
		}
		
		if ( IsDefined( c_door.m_s_bundle.door_key_fx ) )
		{
			level.door_key_fx = c_door.m_s_bundle.door_key_fx;
		}
	}
	
	if ( c_door.m_s_bundle.door_unlock_method == "hack" && !( isdefined( level.door_hack_precached ) && level.door_hack_precached ) )
	{
		level.door_hack_precached = true;
	}

	str_door_xmodel = c_door.m_s_bundle.model;
	
	// Trigger Offset
	if( IsDefined(c_door.m_s_bundle.door_triggerOffsetX) )
	{
		n_xOffset = c_door.m_s_bundle.door_triggerOffsetX;
	}
	else
	{
		n_xOffset = 0;
	}
	if( IsDefined(c_door.m_s_bundle.door_triggerOffsetY) )
	{
		n_yOffset = c_door.m_s_bundle.door_triggerOffsetY;
	}
	else
	{
		n_yOffset = 0;
	}
	if( IsDefined(c_door.m_s_bundle.door_triggerOffsetZ) )
	{
		n_zOffset = c_door.m_s_bundle.door_triggerOffsetZ;
	}
	else
	{
		n_zOffset = 0;
	}

	v_trigger_offset = ( n_xOffset, n_yOffset, n_zOffset );
	c_door.m_s_bundle.v_trigger_offset = v_trigger_offset;			// Store this for later use.

	n_trigger_radius = c_door.m_s_bundle.door_trigger_radius;
	if( ( isdefined( c_door.m_s_bundle.door_slide_horizontal ) && c_door.m_s_bundle.door_slide_horizontal ) )
	{
		n_slide_up = 0;
	}
	else
	{
		n_slide_up = 1;
	}
	n_open_time = c_door.m_s_bundle.door_open_time;
	n_slide_amount = c_door.m_s_bundle.door_slide_open_units;

	if( !IsDefined(c_door.m_s_bundle.door_swing_angle) )
	{
		c_door.m_s_bundle.door_swing_angle = 0;
	}

	if( ( isdefined( c_door.m_s_bundle.door_closes ) && c_door.m_s_bundle.door_closes ) )
	{
		n_door_closes = 1;
	}
	else
	{
		n_door_closes = 0;
	}

	if( ( isdefined( c_door.m_s_bundle.door_connect_paths ) && c_door.m_s_bundle.door_connect_paths ) )
	{
		n_door_connect_paths = 1;
	}
	else
	{
		n_door_connect_paths = 0;
	}
	
	if ( ( isdefined( c_door.m_s_bundle.door_start_open ) && c_door.m_s_bundle.door_start_open ) )
	{
		c_door flag::set( "open" );
	}
	
	if ( IsDefined( c_door.m_str_script_flag ) )
	{
		a_flags = StrTok(c_door.m_str_script_flag, ",");
		foreach( str_flag in a_flags )
		{
			level flag::init( str_flag );
		}
	}

	// Setup the Door
	[[ c_door ]]->init_xmodel( str_door_xmodel, n_door_connect_paths, s_door_instance.origin, s_door_instance.angles);

	// Setup the trigger - Just using radius triggers for now
	[[ c_door ]]->init_trigger( v_trigger_offset, n_trigger_radius, c_door.m_s_bundle );
	
	// Initialize the trigger to give hints regarding how to open the door.
	//
	[[ c_door ]]->init_hint_trigger();
	
	// Initialize any fx associated with this door being (or not being) locked.
	thread [[ c_door ]]->run_lock_fx();
	
	// Setup door movement
	[[ c_door ]]->init_movement( n_slide_up, n_slide_amount );

	if ( !IsDefined(c_door.m_s_bundle.door_open_time) )
	{
		c_door.m_s_bundle.door_open_time = 0.4;
	}

	[[ c_door ]]->set_door_paths( n_door_connect_paths );
	
	// Setup door sounds
	c_door.m_s_bundle.b_loop_sound = IsDefined( c_door.m_s_bundle.door_loop_sound ) && c_door.m_s_bundle.door_loop_sound != "";

	// Door update routine
	level thread door_update( c_door );
	
	return c_door;
}


//*****************************************************************************
//*****************************************************************************

function door_open_update( c_door )
{
	str_unlock_method = "default";
	if ( IsDefined( c_door.m_s_bundle.door_unlock_method ) )
	{
		str_unlock_method = c_door.m_s_bundle.door_unlock_method;
	}
	
	b_auto_close = (( isdefined( c_door.m_s_bundle.door_closes ) && c_door.m_s_bundle.door_closes ) && !( isdefined( c_door.m_s_bundle.door_use_trigger ) && c_door.m_s_bundle.door_use_trigger ));
	b_hold_open = ( isdefined( c_door.m_s_bundle.door_use_hold ) && c_door.m_s_bundle.door_use_hold );
	b_manual_close = ( isdefined( c_door.m_s_bundle.door_use_trigger ) && c_door.m_s_bundle.door_use_trigger ) && ( isdefined( c_door.m_s_bundle.door_closes ) && c_door.m_s_bundle.door_closes );
	
	// Wait for the player to hit the door trigger, unless it's already set to be open.
	while ( true )
	{
		c_door.m_e_trigger waittill( "trigger", e_who );
		c_door.m_e_trigger_player = e_who;

		if ( !(c_door flag::get( "open" )) )
		{
			if ( !(c_door flag::get( "locked" ) ))
		    {
				if ( b_hold_open || b_auto_close )
				{
					[[c_door]]->open();
					
					if ( b_hold_open )
					{
						e_who player_freeze_in_place( true );
						e_who DisableWeapons();
						e_who DisableOffhandWeapons();
					}
					
					door_wait_until_clear( c_door, e_who );
					[[c_door]]->close();
					
					if ( b_hold_open )
					{
						{wait(.05);};
						c_door flag::wait_till_clear( "animating" );
						e_who player_freeze_in_place( false );
						e_who EnableWeapons();
						e_who EnableOffhandWeapons();
					}
					
				} else if ( str_unlock_method == "key" )
				{
					if ( e_who player_has_key( "door" ) )
					{
						e_who player_take_key( "door" );
						[[c_door]]->open();
					} else {
						IPrintLnBold( "You need a key." );
					}
				} else {
					[[c_door]]->open();
				}
		    }
		} else if ( b_manual_close )
		{
			[[c_door]]->close();
		}
	}
}

function door_update( c_door )
{
//	c_door.m_e_trigger thread door_debug_line( c_door.m_e_trigger.origin );

	str_unlock_method = "default";
	if ( IsDefined( c_door.m_s_bundle.door_unlock_method ) )
	{
		str_unlock_method = c_door.m_s_bundle.door_unlock_method;
	}
	
	// "Key" doors aren't *really* unlocked.
	if ( ( isdefined( c_door.m_s_bundle.door_locked ) && c_door.m_s_bundle.door_locked ) && str_unlock_method != "key" )
	{
		c_door flag::set( "locked" );
		
		if (IsDefined(c_door.m_str_targetname))
		{
			thread door_update_lock_scripted( c_door );
		}
	}
	
	thread door_open_update( c_door );

	[[c_door]]->update_use_message();

	while( 1 )
	{		
		// Wait for the door to unlock.
		//
		if( c_door flag::get( "locked" ) )
		{
			c_door flag::wait_till_clear( "locked" );
		}
		
		c_door flag::wait_till( "open" );

		// Check for a delay opening the door
		if( c_door.m_door_open_delay_time > 0 )
		{
			c_door.m_e_door notify( "door_waiting_to_open", c_door.m_e_trigger_player );
			wait( c_door.m_door_open_delay_time );
		}

		[[c_door]]->open_internal();
		
		c_door flag::wait_till_clear( "open" );
		
		[[c_door]]->close_internal();
		
		// If the door stays open, tidyup and exit
		if( !( isdefined( c_door.m_s_bundle.door_closes ) && c_door.m_s_bundle.door_closes ) )
		{
			break;
		}

		{wait(.05);};
	}

	// Cleanup
	c_door.m_e_trigger delete();
	c_door.m_e_trigger = undefined;
}

function door_update_lock_scripted( c_door )
{
	door_str = c_door.m_str_targetname;
	c_door.m_e_trigger.targetname = (door_str + "_trig");
	
	while ( true )
	{
		c_door.m_e_trigger waittill( "unlocked" );
		[[c_door]]->unlock();
	}
}

function player_freeze_in_place( b_do_freeze )
{
	if ( !b_do_freeze )
	{
		if ( IsDefined(self.freeze_origin) )
		{
			self Unlink();
			self.freeze_origin Delete();
			self.freeze_origin = undefined;
		}
	} else {
		if ( !IsDefined(self.freeze_origin) )
		{
			self.freeze_origin = Spawn( "script_model", self.origin );
			self.freeze_origin SetModel( "tag_origin" );
			self.freeze_origin.angles = self.angles;
			self PlayerLinkToDelta(self.freeze_origin, "tag_origin", 1.0, 45.0, 45.0, 45.0, 45.0 );
		}
	}
}

//*****************************************************************************
// Waits for a trigger to be clear of all ENTS for X time
//*****************************************************************************

// self = trigger
function trigger_wait_until_clear( c_door )
{
	self endon( "death" );

	last_trigger_time = gettime();
	self.ents_in_trigger = true;

	str_kill_trigger_notify = "trigger_now_clear";
	self thread trigger_check_for_ents_touching( str_kill_trigger_notify );

	while( 1 )
	{
		time = gettime();

		// If there are still ents in the trigger, reset the time counter
		if( self.ents_in_trigger == true )
		{
			self.ents_in_trigger = false;
			last_trigger_time = time;
		}

		// Have we waited long enough for all ents to the		
		dt = ( time - last_trigger_time ) / 1000;
		if( dt >= 0.3 )
		{
			break;
		}

		{wait(.05);};
	}

	self notify( str_kill_trigger_notify );
}

// Waits until the user releases the X button, or until they leave the area.
//
// self == interaction trigger
//
function door_wait_until_user_release( c_door, e_triggerer, str_kill_on_door_notify )
{
	if ( IsDefined( str_kill_on_door_notify ) )
	{
		c_door endon( str_kill_on_door_notify );
	}
	
	// Brief grace period.
	wait 0.25;
	
	max_dist_sq = c_door.m_s_bundle.door_trigger_radius * c_door.m_s_bundle.door_trigger_radius;
	b_pressed = true;
	n_dist = 0.0;
	
	do {
		{wait(.05);};
		b_pressed = e_triggerer UseButtonPressed();
		n_dist = DistanceSquared(e_triggerer.origin, self.origin);
	}
	while ( b_pressed && n_dist < max_dist_sq );
}

//*****************************************************************************
// Waits for door to be clear of all ENTS for X time
//*****************************************************************************
function door_wait_until_clear( c_door, e_triggerer )
{
	e_trigger = c_door.m_e_trigger;
	e_temp_trigger = undefined;
	
	// If the trigger is not at the door, we need to create a trigger at the door
	// for temporary purposes.
	if ( ( isdefined( c_door.m_s_bundle.door_trigger_at_target ) && c_door.m_s_bundle.door_trigger_at_target ) )
	{		
		e_door = c_door.m_e_door;
		v_trigger_offset = c_door.m_s_bundle.v_trigger_offset;
		v_pos = [[c_door]]->calculate_offset_position( e_door.origin, e_door.angles, v_trigger_offset );
		n_radius = c_door.m_s_bundle.door_trigger_radius;
		n_height = c_door.m_n_trigger_height;
		
		// Spawn a trigger
		e_temp_trigger = spawn( "trigger_radius", v_pos, 0, n_radius, n_height );
		e_trigger = e_temp_trigger;
	}
	
	// Player must hold down the button to keep the door open.
	if ( IsPlayer( e_triggerer ) && ( isdefined( c_door.m_s_bundle.door_use_hold ) && c_door.m_s_bundle.door_use_hold ) )
	{
		c_door.m_e_trigger door_wait_until_user_release( c_door, e_triggerer );
	}
	
	// Wait for trigger to be clear of any entity
	e_trigger trigger_wait_until_clear( c_door );
	
	if ( IsDefined( e_temp_trigger ) )
	{
		e_temp_trigger Delete();
	}
}


//*****************************************************************************
// Waits for a trigger to be free of all ents
//*****************************************************************************

// self = trigger
function trigger_check_for_ents_touching( str_kill_trigger_notify )
{
	self endon( "death" );
	self endon( str_kill_trigger_notify );

	while( 1 )
	{
		self waittill( "trigger", e_who );
		self.ents_in_trigger = true;
	}
}


//*****************************************************************************
//*****************************************************************************

// self = door trigger
function door_debug_line( v_origin )
{
	self endon( "death" );

	while( 1 )
	{
		v_start = v_origin;
		v_end = v_start + ( 0, 0, 1000 );
		v_col = ( 0, 0, 1 );

/#
		line( v_start, v_end, (0,0,1) );
#/

		wait( 0.1 );
	}
}

function player_has_key( str_key_type )
{
	if ( !IsDefined( self.collectible_keys ) )
	{
		return false;
	}
	
	if ( !IsDefined( self.collectible_keys[str_key_type] ) )
	{
		return false;
	}
	
	return self.collectible_keys[str_key_type].num_keys > 0;
}

function player_take_key( str_key_type )
{
	if (!player_has_key( str_key_type ) )
	{
		return;
	}
	
	self.collectible_keys[str_key_type].num_keys--;
	if ( self.collectible_keys[str_key_type].num_keys <= 0 && IsDefined( self.collectible_keys[str_key_type].hudelem ) )
	{
		self.collectible_keys[str_key_type].hudelem Destroy();
		self.collectible_keys[str_key_type].hudelem = undefined;
	}
}

function rotate_key_forever()
{
	self endon( "death" );
	while ( true )
	{
		self RotateYaw( 180, 3.0 );
		wait 2.5;
	}
}

function key_process_timeout( n_timeout_sec, e_trigger, e_model )
{
	e_trigger endon( "death" );
	
	const blinking_time = 5.0;
	if ( n_timeout_sec < blinking_time )
	{
		n_timeout_sec = blinking_time + 1.0;
	}
	
	wait n_timeout_sec - blinking_time;
	
	n_stepsize = 0.5;
	b_on = true;
	for ( f = 0.0; f < blinking_time; f += n_stepsize )
	{
		if ( b_on )
		{
			e_model Hide();
		} else {
			e_model Show();
		}
		b_on = !b_on;
		wait n_stepsize;
		
		// Blinking gets faster over time.
		if ( n_stepsize > 0.15 )
		{
			n_stepsize *= 0.9;
		}
	}
	
	level notify( "key_drop_timeout" );
	
	e_model Delete();
	e_trigger Delete();
}

function give_ai_key_internal( n_timeout_sec, str_key_type )
{
	v_pos = self.origin;
	
	e_model = spawn("script_model", v_pos + (0,0,80) );
	e_model.angles = (10,0,10);
	e_model SetModel( level.door_key_model );
	
	if ( IsDefined( level.door_key_fx ) )
	{
		PlayFXOnTag( level.door_key_fx, e_model, "tag_origin" );
	}
	
	while( IsAlive( self ) )
	{
		e_model MoveTo( self.origin + (0,0,80), 0.2 );
		e_model RotateYaw( 30, 0.2 );
		wait 0.1;
	}
	
	e_model MoveZ( -60, 1.0 );
	wait 1.0;
	
	e_model thread rotate_key_forever();
	
	e_trigger = spawn( "trigger_radius", e_model.origin, 0, 25.0, 100.0 );
	
	if ( isdefined( n_timeout_sec ) )
	{
		level thread key_process_timeout( n_timeout_sec, e_trigger, e_model );
	}
	
	e_trigger endon( "death" );
	
	while ( true )
	{
		e_trigger waittill( "trigger", e_who );
		if ( IsPlayer( e_who ) )
		{
			e_who give_player_key( str_key_type );
			break;
		}
	}
	
	e_model Delete();
	e_trigger Delete();
}

function give_ai_key( n_timeout_sec = undefined, str_key_type = "door" )
{
	assert( isdefined( level.door_key_model ), "Attempting to give ai a key, but no key model is associated with any door in this level." );
	
	self thread give_ai_key_internal( n_timeout_sec, str_key_type );
}

function give_player_key( str_key_type = "door" )
{
	assert( isdefined( level.door_key_icon ), "Attempting to give player a key, but no key icon is associated with any door in this level." );
	
	if ( !IsDefined( self.collectible_keys ) )
	{
		self.collectible_keys = [];
	}
	
	if ( !IsDefined( self.collectible_keys[str_key_type] ) )
	{
		self.collectible_keys[str_key_type] = SpawnStruct();
		self.collectible_keys[str_key_type].num_keys = 0;
		self.collectible_keys[str_key_type].type = str_key_type;
	}
	
	hudelem = self.collectible_keys[str_key_type].hudelem;
	if ( !isdefined( hudelem ) )
	{
		hudelem = newclienthudelem( self );
	}
	
	hudelem.alignX = "right";
	hudelem.alignY = "bottom";
	hudelem.horzAlign = "right";
	hudelem.vertAlign = "bottom";
	hudelem.hidewheninmenu = true;
	hudelem.hideWhenInDemo = true;
	hudelem.y = -75;
	hudelem.x = -25;
	
	hudelem SetShader( level.door_key_icon, 16, 16 );
	
	self.collectible_keys[str_key_type].hudelem = hudelem;
	
	self.collectible_keys[str_key_type].num_keys++;
}

function unlock_all( b_do_open = true )
{
	a_s_inst_list = struct::get_array( "scriptbundle_doors", "classname" );
	foreach( s_inst in a_s_inst_list )
	{
		c_door = s_inst.c_door;
		if ( isdefined( c_door ) )
		{
			[[c_door]]->unlock();
		
			if ( b_do_open )
			{
				[[c_door]]->open();
			}
		}
	}
}

function unlock( str_name, str_name_type = "targetname", b_do_open = true )
{
	a_s_inst_list = struct::get_array( str_name, str_name_type );
	foreach( s_inst in a_s_inst_list )
	{
		if ( isdefined( s_inst.c_door ) )
		{
			[[s_inst.c_door]]->unlock();
			
			if ( b_do_open )
			{
				[[s_inst.c_door]]->open();
			}
		}
	}
}
