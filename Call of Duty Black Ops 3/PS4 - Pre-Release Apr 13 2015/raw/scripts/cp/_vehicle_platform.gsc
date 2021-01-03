/*
 * Created by ScriptDevelop.
 * User: Henry Schmitt
 * Date: 10/15/2014
 * Time: 6:00 PM
 * 
 */

#using scripts\codescripts\struct;

#using scripts\shared\fx_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       


#namespace vehicle_platform;



/* ****************************************************************************
 * 	Vehicle Platform base class
 * ****************************************************************************/

class cVehiclePlatform
{
	// triggers
	var m_t_rumble; // rumble trigger (rumble will play for players within the trigger)

	// entities
	var m_a_e_platform_pieces; // ents that make up the platform
	var m_e_platform;	// the main platform ent
	var m_e_weakpoint;
	var m_veh_platform; // the invisible vehicle driving the platform
	var m_e_sound_point; // point to play looping/ambient sound off of
	var m_t_damage; // damage trigger - detect if hit by a rocket, for triggering death

	var m_nd_start; // starting node for path
	
	// funcs ( call custom vfx/sfx from custom funcs passed in on init )
	var m_func_start;
	var m_func_stop;
	var m_arg;
	
	// state / stats
	var m_n_default_speed; // default movement speed
	var m_str_platform_name;
	var m_has_been_destroyed; // use to ensure that we don't start the shop moving if someone blows up its weak spot
	
	// elevator starts when all players are inside
	function init( str_platform_name, str_node_name ) // args: name of the platform itself (script_model), name of a vehicle node to place the platform at
	{
		m_str_platform_name = str_platform_name;
		m_has_been_destroyed = false;
		
		// GET VEHICLE
		m_veh_platform = GetEnt( m_str_platform_name + "_vehicle", "targetname" );
		m_veh_platform.team = "spectator";
		m_veh_platform.takedamage = false;
		m_veh_platform SetMovingPlatformEnabled( true );
		Assert( isdefined( m_veh_platform ), "This vehicle does not exist: " + m_str_platform_name + "_vehicle" );
		
		// GET PLATFORM
		m_a_e_platform_pieces = GetEntArray( m_str_platform_name, "targetname" );
		foreach( platform_piece in m_a_e_platform_pieces )
		{
			platform_piece EnableLinkTo();
			platform_piece LinkTo( m_veh_platform );

			if( platform_piece.classname == "script_brushmodel" )
			{
			// platforms are assumed to have only 1 script_brushmodel member			
				Assert( !IsDefined( m_e_platform ), "More than one script_brushmodel member found for " + m_str_platform_name );
				m_e_platform = platform_piece;
			}
		}
		Assert( isdefined( m_e_platform ), "Main platform not found for: " + m_str_platform_name );
		m_e_platform SetMovingPlatformEnabled( true );

		// SPAWN & LINK SOUND POINT
		m_e_sound_point = Spawn( "script_origin", m_e_platform.origin );
		m_e_sound_point LinkTo( m_e_platform );
		
		// GET DAMAGE TRIGGER, IF EXISTS
		m_e_weakpoint = GetEnt( m_str_platform_name + "_weakpoint" , "targetname" );
		if( IsDefined( m_e_weakpoint ) )
		{
			m_e_weakpoint EnableLinkTo();
			m_e_weakpoint LinkTo( m_e_platform );
			self thread damage_watcher();
		}
		
		// ATTACH PLATFORM TO VEHICLE SPLINE
		self attach_to_vehicle_node( str_node_name );
		
		// GET TRIGGERS
		// get all triggers targeting the platform
		ent_targeting_platform = GetEntArray( str_platform_name, "target" );
		foreach( ent_targeting_platform in ent_targeting_platform )
		{
			if ( ent_targeting_platform.classname == "script_model" || ent_targeting_platform.classname == "script_brushmodel" )
			{
				switch_trigger = GetEnt( ent_targeting_platform.targetname, "target" );
				self thread trigger_think( switch_trigger );
			}
			else
			{
				self thread trigger_think( ent_targeting_platform );
			}
		}

		// get all ent that the platform targets
		a_e_platform_targets = GetEntArray( m_e_platform.target, "targetname" );
		a_s_platform_targets = struct::get_array( m_e_platform.target, "targetname" );
		platform_targets = ArrayCombine( a_e_platform_targets, a_s_platform_targets, true, false );
// TODO: does this need to be an assert? 
//		Assert( platform_targets.size > 0, "This platform does not have any targets: " + m_e_platform.origin );
		
		foreach( platform_target in platform_targets )
		{
			if( !isdefined( platform_target.script_noteworthy ) )
			{
				continue;
			}
			
			switch( platform_target.script_noteworthy )
			{
				case "audio_point":
					self thread looping_sounds( platform_target, "start_" + m_str_platform_name + "_klaxon", "stop_" + m_str_platform_name + "_klaxon" );
					break;
				case "elevator_door":
					self thread setup_elevator_doors( platform_target );
					break;
				case "elevator_klaxon_speaker":
					self thread looping_sounds( platform_target, "vehicle_platform_" + m_str_platform_name + "_move", "stop_" + m_str_platform_name + "_movement_sound" );
					break;
			}
		}
	}
	
	function set_external_functions( func_start, func_stop, arg )
	{
		m_func_start = func_start;
		m_func_stop = func_stop;
		m_arg = arg;
	}
	
	function get_platform_vehicle()
	{
		return m_veh_platform;
	}
	
	function set_node_start( str_node_name )
	{
		nd_start = GetVehicleNode( str_node_name, "targetname" );
		Assert( isdefined( m_nd_start ), "This vehicle node does not exist: " + str_node_name );
		
		m_nd_start = nd_start;
	}

	function damage_watcher( )
	{
		m_e_weakpoint SetCanDamage( true );
		m_e_weakpoint.health = 100;
		
		m_e_weakpoint waittill( "death" );
		
		m_has_been_destroyed = true;
		
		self thread fx::play( "mobile_shop_fall_explosion", m_veh_platform.origin, ( 0, 0, 0 )  );
		wait 0.3;	// timing
		self thread fx::play( "mobile_shop_fall_explosion", m_veh_platform.origin - ( 0, 200, 0 ) , ( 0, 0, 0 )  );
		m_e_weakpoint Hide();

		a_ai = GetAIArray( m_str_platform_name, "groupname" );
		foreach( ai in a_ai )
		{
			ai Kill();
		}
		
		m_veh_platform vehicle::pause_path();
		
		// play falling fxanim here
	}
	
	function trigger_think( e_trigger )
	{
		e_trigger endon( "death" );
		level endon( m_str_platform_name + "_disabled" );
		
		nd_start_old = m_nd_start;
		
		// can be triggered repeatedly
		while ( true )
		{
			e_trigger trigger::wait_till();
			
			// start the platform motion klaxon alarm
			level notify( "start_" + m_str_platform_name + "_klaxon" );
			level notify( "close_" + m_str_platform_name + "_doors" );
			
			if( IsDefined( e_trigger.script_wait ) )
			{
				wait e_trigger.script_wait;
			}
			else
			{
				wait 2;
			}
			
			if ( m_nd_start != nd_start_old )
			{
				b_new_start = true;
			}
			
			m_e_sound_point playSound( "veh_" + m_str_platform_name + "_start" );
			m_e_sound_point playloopsound ("veh_" + m_str_platform_name + "_loop", .5 );
			//m_e_sound_point playSound( "veh_" + m_str_platform_name + "_direction_change");
			
			// start the platform moving
			self thread start_platform( b_new_start );
			
			m_veh_platform waittill( "reached_end_node" );
			
			m_e_sound_point PlaySound( "veh_" + m_str_platform_name + "_stop");
			m_e_sound_point StopLoopSound( .5 );
			
			stop_platform();
		}
	}
	
	function attach_to_vehicle_node( str_node_name )
	{
		// GET VEHICLE SPLINE
		m_nd_start = GetVehicleNode( str_node_name, "targetname" );
		Assert( isdefined( m_nd_start ), "This vehicle node does not exist: " + str_node_name );
		// PLACE PLATFORM IN INITIAL POSITION
		m_veh_platform vehicle::get_on_path( m_nd_start );
	}
	
	// set the elevator speed
	function set_speed( n_new_speed, n_accel_time )
	{
		m_veh_platform vehicle::set_speed( n_new_speed, n_accel_time );
	}
	
	function start_platform( b_new_start )
	{	
		if( m_has_been_destroyed )
		{
			return;
		}
		
		// start vehicle moving		
		if ( ( isdefined( b_new_start ) && b_new_start ) )
		{
			m_veh_platform vehicle::get_on_and_go_path( m_nd_start );
		}
		else
		{
			m_veh_platform vehicle::go_path();
		}
		
		level notify( "vehicle_platform_" + m_str_platform_name + "_move" ); // notify to activate fx
		
		// call custom start_fx func
		// the custom fx functions are threaded on the platform script_model, so it's easy to play attached fx
		if( isdefined( m_func_start ) )
		{
			if( isdefined( m_arg ) )
			{
				m_e_platform thread [[ m_func_start ]]( m_arg );
			}
			else
			{
				m_e_platform thread [[ m_func_start ]]();
			}
		}
	}
	
	function stop_platform()
	{
		level notify( "vehicle_platform_" + m_str_platform_name + "_stop" ); // notify things in level that the platform has stopped
		level notify( "stop_" + m_str_platform_name + "_movement_sound" );

		// turn off klaxons
		level notify( "stop_" + m_str_platform_name + "_klaxon" );
		// open doors
		level notify( "open_" + m_str_platform_name + "_doors" );				
		
		// play any metal screeching / groaning sounds if assigned
		if ( isdefined( self.script_sound ) )
		{
			m_e_sound_point PlaySound( level.scr_sound[ self.script_sound ] );
		}
		
		//m_e_sound_point PlaySound( "veh_" + m_str_platform_name + "_stop");
		//m_e_sound_point StopLoopSound( .5 );
				
		if ( isdefined( level.scr_sound ) && IsDefined( level.scr_sound[ "elevator_end" ] ) )
		{
			m_e_sound_point PlaySound( level.scr_sound[ "elevator_end" ] );
		}
	
		// call custom stop_fx func
		// the custom fx functions are threaded on the platform script_model, so it's easy to play attached fx
		if( isdefined( m_func_stop ) )
		{
			if( isdefined( m_arg ) )
			{
				m_e_platform thread [[ m_func_stop ]]( m_arg );
			}
			else
			{
				m_e_platform thread [[ m_func_stop ]]();
			}
		}
	}
	
	// play any looping sounds if its defined by self.script_sound
	// self = the entity to play the sound at its origin
	function looping_sounds( s_audio_point, notify_play, notify_stop )
	{
		level waittill( notify_play );
	
		if ( isdefined( s_audio_point.script_sound ) )
		{
			s_audio_point thread sound::loop_in_space( level.scr_sound[ s_audio_point.script_sound ], s_audio_point.origin, notify_stop );
		}
	}
	
	function setup_elevator_doors( platform_target )
	{
		open_struct = struct::get( platform_target.target, "targetname" );
		Assert( isdefined( open_struct ), "This door does not target a script_struct for its OPEN POSITION: " + platform_target.origin );
		Assert( isdefined( open_struct.target ), "This door's OPEN POSITION struct does not target a CLOSED POSITION struct: " + platform_target.origin );
		closed_struct = struct::get( open_struct.target, "targetname" );
		Assert( isdefined( closed_struct ), "This door does not have a script_struct for its CLOSED POSITION: " + platform_target.origin );
		
		n_opening_time = (isdefined(open_struct.script_float)?open_struct.script_float:1);
		n_closing_time = (isdefined(closed_struct.script_float)?closed_struct.script_float:1);
		
		stay_closed = false;
		if( IsDefined( closed_struct.script_noteworthy ) && closed_struct.script_noteworthy == "stay_closed" )
		{
			stay_closed = true;
		}
		
		platform_target.origin = open_struct.origin;
		platform_target.angles = open_struct.angles;
		v_move_to_close = closed_struct.origin - platform_target.origin;
		v_angles_to_close = closed_struct.angles - platform_target.angles;
		v_move_to_open = platform_target.origin - closed_struct.origin;
		v_angles_to_open = platform_target.angles - closed_struct.angles;
		
		self thread move_elevator_doors( platform_target, "close_", v_move_to_close, v_angles_to_close, n_closing_time );
		if( !stay_closed )
		{
			self thread move_elevator_doors( platform_target, "open_", v_move_to_open, v_angles_to_open, n_opening_time );
		}
	}
	
	// self = the door
	function move_elevator_doors( platform_target, direction, v_moveto, v_angles, n_time )
	{
		level endon( m_str_platform_name + "_disabled" );
		
		platform_target LinkTo( m_e_platform );
		
		while ( 1 )
		{
			level waittill( direction + m_str_platform_name + "_doors" );
			platform_target Unlink();
			platform_target moveto( platform_target.origin + v_moveto, n_time );
			platform_target RotateTo( platform_target.angles + v_angles, n_time );
			wait n_time;
			platform_target LinkTo( m_e_platform );
		}
	}
}

