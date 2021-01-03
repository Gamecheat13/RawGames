#using scripts\shared\array_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_scoreevents;

#using scripts\cp\gametypes\_globallogic;

#using scripts\cp\sm\_sm_round_base;
#using scripts\cp\sm\_sm_round_objective_sabotage;
#using scripts\cp\sm\_sm_round_objective_secure_goods;
#using scripts\cp\sm\_sm_round_objective_uplink;
#using scripts\cp\sm\_sm_round_beacon;
#using scripts\cp\sm\_sm_ui;
#using scripts\cp\sm\_sm_zone_mgr;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                   	       	     	          	      	                                                                                            	                                                           	                                  

#precache( "eventstring", "hide_notification_dock_timer" );
#precache( "eventstring", "set_notification_dock_timer" );
#precache( "eventstring", "show_notification_dock_timer" );

#precache( "string", "SM_ROUND_OBJECTIVE_START" );
#precache( "string", "SM_ROUND_OBJECTIVE_DONE" );
#precache( "string", "SM_OBJ_TIME_REMAINING" );
#precache( "string", "SM_OBJ_TIMER_FAILED" );

#namespace sm_round_objective;

function autoexec __init__sytem__() {     system::register("sm_round_objectives",&__init__,undefined,undefined);    }

function __init__()
{
	objective_init( "unobtainium", &sm_round_objective_secure_goods::main, false );  // taking out of rotation due to DT#7154 (progression break) - TJanssen 5/16/2014
	objective_init( "uplink", &sm_round_objective_uplink::main );
	objective_init( "sabotage", &sm_round_objective_sabotage::main );
}
	
function main()
{
	return new cSideMissionRoundObjective();
}

// TODO: add function that ensures at least one objective is valid to run in round manager

function defend_object_add( object )
{
	_init_defend_objects();
	
	if ( !IsInArray( level._defend_objects.a_objects, object ) )
	{
		if ( !isdefined( level._defend_objects.a_objects ) ) level._defend_objects.a_objects = []; else if ( !IsArray( level._defend_objects.a_objects ) ) level._defend_objects.a_objects = array( level._defend_objects.a_objects ); level._defend_objects.a_objects[level._defend_objects.a_objects.size]=object;;
	}
}

function defend_object_remove( object )
{
	_init_defend_objects();
	
	if ( IsInArray( level._defend_objects.a_objects, object ) )
	{
		ArrayRemoveValue( level._defend_objects.a_objects, object, false );
	}		
}

function defend_object_get_array()
{
	_init_defend_objects();

	return level._defend_objects.a_objects;		
}

function defend_object_get_count()
{
	return defend_object_get_array().size;
}

function set_max_defenders( n_count )
{
	_init_defend_objects();
	
	level._defend_objects.n_defenders_max = n_count;
}

function _init_defend_objects()
{
	if ( !IsDefined( level._defend_objects ) )
	{
		level._defend_objects = SpawnStruct();
	}
	
	if ( !IsDefined( level._defend_objects.a_objects ) )
	{
		level._defend_objects.a_objects = [];
	}
	
	if ( !IsDefined( level._defend_objects.n_defenders_max ) )
	{
		level._defend_objects.n_defenders_max = 3;
	}
	
	if ( !IsDefined( level._defend_objects.a_invalid_ai_types ) )
	{
		level._defend_objects.a_invalid_ai_types = Array( "sniper", "sapper", "demo", "hunter", "quadtank" );
	}
}

function objective_enable( str_type, b_is_enabled = true )
{
	Assert( IsDefined( level.sm_valid_objectives ), "Side Mission objectives have not yet been initialized. Call objective_enable after load::main" );
	
	// make sure we're trying to use a valid objective
	a_keys = GetArrayKeys( level.sm_valid_objectives );
	str_list = "";
	
	for ( i = 0; i < a_keys.size; i++ )
	{
		str_list += "\n" + a_keys[ i ];
	}
	
	Assert( IsDefined( level.sm_valid_objectives[ str_type ] ), str_type + " is not a valid Side Mission objective type! List of valid objectives: " + str_list );

	// enable the objective for use
	level.sm_valid_objectives[ str_type ].is_enabled = b_is_enabled;
}

function objective_init( str_objective, func_objective, b_enabled = true )
{
	if ( !IsDefined( level.sm_valid_objectives ) )
	{
		level.sm_valid_objectives = [];
	}
	
	Assert( !IsDefined( level.sm_valid_objectives[ str_objective ] ), str_objective + " has already been initialized by _sm_round_objective! This only needs to happen once." );
	
	s_temp = SpawnStruct();
	
	s_temp.is_enabled = b_enabled;
	s_temp.func_objective = func_objective;
	s_temp.has_run_this_game = false;
	
	level.sm_valid_objectives[ str_objective ] = s_temp;

	/#
		AddDebugCommand( "devgui_cmd \"SideMission/Round/Force Objective/" + str_objective + "\" \"set sidemission_force_next_objective " + str_objective + "\"\n" ); 
	#/	
}

class cSideMissionRoundObjective : cSideMissionRoundBase
{
	var m_str_objective_type;
	var m_str_objective_text;  // specific objectives should overwrite this
	var m_str_icon;  // specific objectives should overwrite this
	var m_str_vox_intro;  // specific objective VO to play when objective text appears
	var m_o_objective_round;
	var m_hide_beacon_icons_during_objective;

	constructor()
	{
		m_str_round_start = &"SM_ROUND_OBJECTIVE_START";
		
		m_hide_beacon_icons_during_objective = true;
		
		// specific objectives should overwrite these; needs initialization so SRE doesn't occur if undefined
		m_str_objective_text = &"SM_OBJ_DEFAULT_DESCRIPTION";
		m_str_icon = &"";	
		
		self flag::init( "objective_started" );
		self flag::init( "objective_complete" );
	}
	
	destructor()
	{
		//regardless of new objective zone management, reset to beacon at the end of the objective round
		e_active_beacon = sm_round_beacon::get_active_beacon();
				
		if ( IsDefined( e_active_beacon ) )
		{
			str_zone = zone_mgr::get_zone_from_position( e_active_beacon.origin );
		
			zone_mgr::set_objective_zone( str_zone );
		
			zone_mgr::set_mode( "objective_unoccupied" );
		}
	}
	
	function main_objective()
	{
		Assert( "main_objective() not overwritten in cSideMissionRoundObjective. This is where the main logic for the objective should run." );
	}
	
	function main()
	{
		m_str_objective_type = get_objective_type();
		
		wave_remove_enemy_type( array( "sapper", "demo", "wasp" ) );
		wave_spawning_group_size( 1 );
	
		// start spawning indefinitely
		wave_spawning_enable( true );
		
		// objective round runs to completion
		run_objective_round( m_str_objective_type );
		
		level notify ("snd_obj_rd_start");
		
		// stop all further spawning
		wave_spawning_stop();
		
		// round completes when remaining enemies are killed
		wait_for_all_enemies_to_be_killed();
		
		level notify ("snd_obj_rd_end");		
	}
	
	function get_objective_type()
	{		
		// pick a new objective in random order
		a_valid_objectives = get_unused_objectives();
		
		// if we've run all objectives already, reset list and start search over
		if ( a_valid_objectives.size == 0 )
		{
			reset_objective_list();
			
			a_valid_objectives = get_unused_objectives();
		}
		
		// make sure we have a valid objective
		Assert( a_valid_objectives.size, "cSideMissionRoundObjective found no objective types supported for this map! Add these with sm_round_objective::objective_enable()!" );
		
		str_objective = array::random( a_valid_objectives );
		
		// optionally force the objective type
		/#  
			str_forced_objective = GetDvarString( "sidemission_force_next_objective" );
			if ( IsDefined( str_forced_objective ) && IsDefined( level.sm_valid_objectives[ str_forced_objective ] ) )
			{
				str_objective = str_forced_objective;
				
				// clear dvar so we don't use the same objective for the rest of the game
				SetDvar( "sidemission_force_next_objective", "" ); 
			}
		#/

		// track if level has run this objective this game
		level.sm_valid_objectives[ str_objective ].has_run_this_game = true;
			
		return str_objective;
	}
	
	function get_unused_objectives()
	{
		a_unused_objectives = [];
		
		foreach ( str_objective in GetArrayKeys( level.sm_valid_objectives ) )
		{
			if ( !level.sm_valid_objectives[ str_objective ].has_run_this_game && level.sm_valid_objectives[ str_objective ].is_enabled )
			{
				if ( !isdefined( a_unused_objectives ) ) a_unused_objectives = []; else if ( !IsArray( a_unused_objectives ) ) a_unused_objectives = array( a_unused_objectives ); a_unused_objectives[a_unused_objectives.size]=str_objective;;
			}
		}
		
		return a_unused_objectives;
	}
	
	function reset_objective_list()
	{
		foreach ( str_objective in GetArrayKeys( level.sm_valid_objectives ) )
		{
			level.sm_valid_objectives[ str_objective ].has_run_this_game = false;
		}		
	}
	
	function show_objective_goal()
	{
		sm_ui::show_text_notification_with_image( m_str_objective_text, undefined, undefined, undefined, m_str_icon );
		
		if ( IsDefined( m_str_vox_intro ) )
		{
			play_vo_to_all_players( m_str_vox_intro );
		}
		
		wait m_n_show_time;
		
		sm_ui::dock_text_show( m_str_objective_text );
	}
	
	function run_objective_round( str_type )
	{				
		sm_round_objective::_init_defend_objects();
		
		m_o_objective_round = [[ level.sm_valid_objectives[ str_type ].func_objective ]]();
		
		if ( m_o_objective_round.m_hide_beacon_icons_during_objective )
		{
			sm_round_beacon::active_beacon_icons_hide();
		}		
		
		[[m_o_objective_round]]->show_objective_goal();
		
		self flag::set( "objective_started" );
		
		[[m_o_objective_round]]->main_objective();
		
		m_o_objective_round notify( "sm_objective_complete" );
		
		sm_ui::dock_text_remove();
		
		if ( m_o_objective_round.m_hide_beacon_icons_during_objective ) 
		{
			sm_round_beacon::active_beacon_icons_show();
		}		
		
		m_o_objective_round = undefined;
		
		self flag::set( "objective_complete" );
	}
	
	function set_objective_timer_with_images( n_time, str_vox_reminder, str_image_1, str_image_2, str_image_3, str_fail_image )
	{		
		foreach ( player in level.players )
		{
			player LUINotifyEvent( &"show_notification_dock_timer", 5, _get_dock_timer_time( n_time ), PackRGBA( 0.92549, 0.10980, 0.14118, 1.0 ), str_image_1, str_image_2, str_image_3 );
		}
		
		self thread _fail_mission_when_time_expires( n_time, str_vox_reminder, &"SM_OBJ_TIMER_FAILED", str_fail_image );
	}
	
	function _get_dock_timer_time( n_time )
	{
		return ( GetTime() + ( n_time * 1000 ) );  // timer takes current server time plus countdown timer in ms
	}
	
	function _fail_mission_when_time_expires( n_time, str_vox_reminder, str_fail_notification, str_fail_image )
	{
		self endon( "sm_objective_complete" );
		
		if ( isdefined( str_vox_reminder ) )
		{
			self thread _vo_timer_reminder( n_time, str_vox_reminder );
		}
		
		self thread remove_timer_on_objective_complete();
		
		wait n_time;
		
		play_vo_to_all_players( "vox_out_of_time" );
		
		self thread globallogic::endGame( level.enemy_ai_team, str_fail_notification, str_fail_image );

		self notify( "sm_objective_complete" );
	}
	
	function _vo_timer_reminder( n_time, str_vox_reminder )
	{
		self endon( "sm_objective_complete" );
		
		wait ( n_time * 0.3 );  // play when time is 30% gone
		
		if ( IsDefined( str_vox_reminder ) )
		{
			play_vo_to_all_players( str_vox_reminder );
		}
		
		wait ( n_time * 0.3 );  // play when time is 60% gone
		
		play_vo_to_all_players( "vox_run_out_of_time" );
	}

	
	function remove_timer_on_objective_complete()
	{
		self waittill( "sm_objective_complete" );
		
		foreach ( player in level.players )
		{
			player LUINotifyEvent( &"hide_notification_dock_timer", 0 );
		}
	}
	
	function dev_clean_up_round()
	{
		// make sure objective round has been initialized first
		while ( !self flag::get( "objective_complete" ) && !self flag::get( "objective_started" ) )
		{
			{wait(.05);};
		}
		
		// this class object is referenced directly from the round manager. We want to use the objective round-specific cleanup function
		if ( IsDefined( m_o_objective_round ) )
		{
			[[m_o_objective_round]]->dev_clean_up_round();
		}
		
		stop_wave_spawning_and_kill_all_enemies();
	}
}

