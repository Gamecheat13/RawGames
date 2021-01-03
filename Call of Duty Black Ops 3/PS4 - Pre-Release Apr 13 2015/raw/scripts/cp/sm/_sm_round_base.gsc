#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;

#using scripts\cp\sm\_sm_bonus;
#using scripts\cp\sm\_sm_devgui;
#using scripts\cp\sm\_sm_ui;
#using scripts\cp\sm\_sm_wave_mgr;
#using scripts\cp\sm\_sm_zone_mgr;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       

                                                                   	       	     	          	      	                                                                                            	                                                           	                                  

#precache( "eventstring", "countdown_end" );
#precache( "eventstring", "countdown_set" );
#precache( "eventstring", "countdown_start" );
#precache( "eventstring", "show_text_notification_image" );
#precache( "eventstring", "wave_end" );
#precache( "eventstring", "wave_start" );

#precache( "string", "10" );
#precache( "string", "9" );
#precache( "string", "8" );
#precache( "string", "7" );
#precache( "string", "6" );
#precache( "string", "5" );
#precache( "string", "4" );
#precache( "string", "3" );
#precache( "string", "2" );
#precache( "string", "1" );

#precache( "string", "SM_ROUND_1" );
#precache( "string", "SM_ROUND_2" );
#precache( "string", "SM_ROUND_3" );
#precache( "string", "SM_ROUND_4" );
#precache( "string", "SM_ROUND_5" );
#precache( "string", "SM_ROUND_6" );
#precache( "string", "SM_ROUND_7" );
#precache( "string", "SM_ROUND_8" );
#precache( "string", "SM_ROUND_9" );
#precache( "string", "SM_ROUND_10" );

#precache( "string", "SM_OBJ_SURVIVAL" );
#precache( "string", "SM_ROUND_NEXT" );
#precache( "string", "SM_ROUND_COMPLETE" );



	
class cSideMissionRoundBase
{
	var m_str_round_start;  // text displayed when round begins
	var m_str_round_complete;  // text displayed when round ends
	var m_str_round_number;  // round number string (handled automatically)
	var m_str_dock_text;  // optional dock text to show during a round
	var m_n_round_number;  // round number value (handled automatically)
	var m_n_show_time;  // how long round objective text is displayed on round start and round end
	var m_b_show_countdown;  // should a countdown timer begin this round?
	var m_b_can_be_bonus_round;  // should this be a bonus round?
	var m_func_custom_lua_round_start;
	var m_func_start;
	var m_func_end;
	
	constructor()
	{
		m_str_round_number = &"";  // Start splash screen text: top line. Displays round number automatically.
		
		m_str_round_start = &"";  // Start splash screen text: bottom line. May be replaced by specific objective
		
		m_str_round_complete = &"SM_ROUND_COMPLETE";  // End splash screen text: bottom line. May be replaced by specific objective		
		
		m_n_show_time = 3;  // time objective splash screen remains on screen
	
		m_b_can_be_bonus_round = false;
		
		m_b_show_countdown = true; 
		
		self flag::init( "round_started" );
		self flag::init( "round_finished" );
	}
	
	destructor()
	{
		
	}
	
	// Important: get_sm_struct should be used for all round-related structs placed in the map. Don't use struct::get!
	// targetname = sm_struct
	// script_noteworthy = <location> - match location specific structs with this KVP
	// script_string = <identifier> - 
	function get_sm_struct( str_script_string, str_location )
	{
		a_structs = struct::get_array( "sm_struct", "targetname" );
		
		a_structs_found = [];
		
		foreach ( struct in a_structs )
		{
			Assert( IsDefined( struct.script_string ), "script_string KVP is missing on sm_struct at " + struct.origin + "! This is required to identify the struct's purpose." );
			
			if ( struct.script_string == str_script_string )
			{
				if ( !IsDefined( str_location ) || ( str_location === struct.script_noteworthy ) )
				{				
					if ( !isdefined( a_structs_found ) ) a_structs_found = []; else if ( !IsArray( a_structs_found ) ) a_structs_found = array( a_structs_found ); a_structs_found[a_structs_found.size]=struct;;
				}
			}
		}
		
		Assert( ( a_structs.size > 0 ), "get_sm_struct() found no sm_structs with script_string = '" + str_script_string + "'!" );
		
		return a_structs_found;
	}
	
	// This function is called directly from _sm_objective_manager
	function round_start()
	{		
		self flag::clear( "round_started" );
		self flag::clear( "round_finished" );
		
		if ( m_b_show_countdown )
		{
			foreach ( player in level.players )
			{
				player thread show_countdown_on_hud();
			}
			
			wait 10;
		}
		
		if ( IsDefined( m_func_start ) )
		{
			self thread [[ m_func_start ]]();
		}		
		
		level notify( "sm_round_start", m_str_round_number );

		foreach ( player in level.players )
		{
			if ( IsDefined( m_func_custom_lua_round_start ) )
			{
				self [[ m_func_custom_lua_round_start ]]( player );
			}
			else 
			{
				// top stays on screen, bottom fades out
				player LUINotifyEvent( &"wave_start", 4, m_str_round_number, PackRGBA( 1.0, 1.0, 1.0, 1.0 ), m_str_round_start, PackRGBA( 1.0, 1.0, 1.0, 1.0 ) );
				
			}
				//TUEY CHANGE TO SFX
				player playsound( "uin_menu_waveStart" );
		}
		wait m_n_show_time;
		
		if ( IsDefined( m_str_dock_text ) )
		{
			sm_ui::dock_text_show( m_str_dock_text );
			sm_ui::dock_text_set( m_str_dock_text );
		}
		
		self flag::set( "round_started" );
	}
	
	// This function is called directly from _sm_objective_manager
	function round_end()
	{
		self flag::set( "round_finished" );
		
		if ( IsDefined( m_str_dock_text ) )
		{
			sm_ui::dock_text_remove();
		}
		
		if ( IsDefined( m_func_end ) )
		{
			self thread [[ m_func_end ]]();
		}
		
		level notify( "sm_round_end", m_str_round_number );
	
		foreach ( player in level.players )
		{
			player LUINotifyEvent( &"wave_end", 4, m_str_round_number, PackRGBA( 1.0, 1.0, 1.0, 1.0 ), m_str_round_complete, PackRGBA( 1.0, 1.0, 1.0, 1.0 ) );
		}
		
		//TUEY CHANGE TO SFX
		player playsound( "uin_menu_on_waveEnd" );
	
		wait m_n_show_time;
	}
	
	function on_end_game( success )
	{
	}
	
	function wait_till_round_started()
	{
		self flag::wait_till( "round_started" );
	}
	
	function wait_till_round_finished()
	{
		self flag::wait_till( "round_finished" );
	}
	
	function set_bonus_possibility( b_can_have_bonus )
	{
		m_b_can_be_bonus_round = b_can_have_bonus;
	}	
	
	function set_show_countdown( b_do_countdown )
	{
		m_b_show_countdown = b_do_countdown;
	}
	
	function set_round_number( n_round_number )
	{
		// we don't have a way of using a variable round number yet, so hard-code these strings for now
		a_round_numbers = Array( 	&"", 
		                        	&"SM_ROUND_1",
		                        	&"SM_ROUND_2",
		                        	&"SM_ROUND_3",
		                        	&"SM_ROUND_4",
		                        	&"SM_ROUND_5",
		                        	&"SM_ROUND_6",
		                        	&"SM_ROUND_7",
		                        	&"SM_ROUND_8",
		                        	&"SM_ROUND_9",
		                        	&"SM_ROUND_10" );
		
		m_str_round_number = a_round_numbers[ n_round_number ];
		m_n_round_number = n_round_number;
	}
	
	// This function is called directly from _sm_objective_manager, and needs to be overwritten by parent objective
	function main()
	{
		// this function should be overwritten by parent class
		AssertMsg( "cSideMissionRoundBase: main function not overwritten by parent class. The main function is run directly from the objective manager." );
	}
	
	function spawn_enemy_wave()
	{
		wave_mgr::start_wave_spawning( m_n_round_number );
		level thread wave_mgr::pause_when_wave_spawning_finished();			
	}
	
	function wave_spawning_group_size( n_size )
	{
		wave_mgr::set_group_size( n_size );
	}
	
	function wave_spawning_enable( b_infinite = false )
	{
		wave_mgr::start_wave_spawning( m_n_round_number, b_infinite );
	}
	
	function wave_spawning_pause()
	{
		level thread wave_mgr::pause_when_wave_spawning_finished();	
	}
	
	function wave_spawning_stop()
	{
		wave_mgr::stop_wave_spawning();
	}
	
	//	Pass in a string or array of strings of the enemy types you do not want to spawn during the current wave
	function wave_remove_enemy_type( a_str_enemy_list )
	{
		wave_mgr::remove_enemy_type_from_wave( a_str_enemy_list );
	}
	
	function wait_for_all_enemies_to_be_killed()
	{		
		b_displaying_enemies_on_radar = false;
		n_prev_count = wave_mgr::get_wave_enemy_count();
		do 
		{
			wait 0.25;
			
			n_enemy_count = wave_mgr::get_wave_enemy_count();
			
			if ( n_enemy_count != n_prev_count )
			{
				if ( n_enemy_count <= get_enemy_count_for_radar() )
				{
					if ( !b_displaying_enemies_on_radar )
					{
						sm_ui::enemy_message_set( &"SM_OBJ_SURVIVAL", n_enemy_count );
						b_displaying_enemies_on_radar = true;
						
						SetTeamSatellite( "allies", 1 );  // enemies displayed on mini-map
						
						play_vo_to_all_players( "vox_mop_up" );
					}
					
					sm_ui::enemy_message_update( n_enemy_count );
				}
				
				n_prev_count = n_enemy_count;
			}
		}
		while ( n_enemy_count > 0 );
		
		sm_bonus::cash_in();
		
		sm_ui::enemy_message_update( 0 );
		
		SetTeamSatellite( "allies", 0 );  // no more enemies on mini-map
		
		wait 1;  // allow counter to remain on screen briefly
		
		sm_ui::enemy_message_remove();
	}
	
	function get_enemy_count_for_radar()
	{
		return 5;
	}
	
	function objective_add_to_pause_menu( str_objective_text, entity )
	{
		n_obj_id = gameobjects::get_next_obj_id();
		objective_add( n_obj_id, "active", entity, str_objective_text );
		
		return n_obj_id;
	}	
	
	function objective_complete( n_obj_id )
	{
		Objective_State( n_obj_id, "done" );
	}
	
	function set_objective_spawning_at_position( v_position )
	{
		str_zone = zone_mgr::get_zone_from_position( v_position );
		
		Assert( IsDefined( str_zone ), "cSideMissionRoundBase: set_objective_spawning_at_position couldn't find a valid zone at position " + v_position );
		
		zone_mgr::set_objective_zone( str_zone );
		
		zone_mgr::set_mode( "objective_unoccupied" );
	}
	
	function show_countdown_on_hud()  // self = player
	{
		self endon( "death" );
		
		a_countdown_strings = Array( &"1", &"2", &"3", &"4", &"5", &"6", &"7", &"8", &"9", &"10" );  // index = index text + 1 -> a_countdown_strings[ 0 ] = &"1"
		
		Assert( ( a_countdown_strings.size <= 10 ), "show_countdown_on_hud() needs to register additional strings for countdown. There are " + a_countdown_strings.size + " registered, but timer needs " + 10 );
		
		self LUINotifyEvent( &"countdown_start", 4, &"SM_ROUND_NEXT", PackRGBA( 1.0, 1.0, 1.0, 1.0 ), a_countdown_strings[ a_countdown_strings.size - 1 ], PackRGBA( 1.0, 1.0, 1.0, 1.0 ) );
		
		for ( i = a_countdown_strings.size - 2; i >= 0; i-- )  // we've already displayed highest index, so use next highest
		{
			wait 1;
			
			self LUINotifyEvent( &"countdown_set", 4, &"SM_ROUND_NEXT", PackRGBA( 1.0, 1.0, 1.0, 1.0 ), a_countdown_strings[ i ], PackRGBA( 1.0, 1.0, 1.0, 1.0 ) );
			self playsound ("mpl_ui_timer_countdown");
		}
		
		wait 1;
		
		
		self LUINotifyEvent( &"countdown_end", 0 );		
	}
	
	function play_vo_to_all_players( str_vo )
	{
		foreach( e_player in level.players )
		{
			e_player PlaySoundToPlayer( str_vo, e_player );
		}
	}
	
	// This function is called directly from _sm_objective_manager through dev tools. Use this to complete any objectives or set variables required for progression.
	// This may be overwritten for particular behavior specific to one round (examples: beacon, objective)
	function dev_clean_up_round()
	{
		stop_wave_spawning_and_kill_all_enemies();
	}	
	
	function stop_wave_spawning_and_kill_all_enemies()
	{
		/#
		sm_devgui::stop_wave_spawning_and_kill_remaining_enemies();
		#/
	}
}
