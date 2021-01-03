#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;

#using scripts\cp\gametypes\_globallogic;

#using scripts\cp\sidemissions\_sm_type_base;
#using scripts\cp\sidemissions\_sm_ui;
#using scripts\cp\sidemissions\_sm_zone_mgr;
#using scripts\cp\sidemissions\_sm_initial_spawns;
#using scripts\cp\sidemissions\_sm_manager;
#using scripts\cp\sidemissions\_sm_wave_mgr;
#using scripts\cp\sidemissions\_sm_ui_worldspace;

#using scripts\cp\_util;
#using scripts\cp\_scoreevents;
#using scripts\cp\_pda_hack;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       










	


	












	

	


	
#precache( "material", "waypoint_targetneutral" );
#precache( "material", "T7_hud_prompt_pickup_64" );
#precache( "material", "waypoint_hack" );
#precache( "material", "T7_hud_waypoints_arrow" );
#precache( "material", "t7_hud_waypoints_a" );
#precache( "material", "t7_hud_waypoints_b" );
#precache( "material", "t7_hud_waypoints_c" );
#precache( "material", "t7_hud_waypoints_a" );
#precache( "material", "t7_hud_waypoints_b" );
#precache( "material", "t7_hud_waypoints_c" );
#precache( "material", "T7_hud_agent_small" );
#precache( "fx", "explosions/fx_exp_generic_lg" );
#precache( "fx", "fire/fx_fire_flare_red" );
#precache( "string", "SM_TYPE_SABOTAGE_OUTPOST_LABEL" );
#precache( "string", "SM_TYPE_SABOTAGE_EXFIL_INTRO_SPLASH1" );
#precache( "string", "SM_TYPE_SABOTAGE_EXFIL_INTRO_SPLASH2" );
#precache( "string", "SM_TYPE_SABOTAGE_EXFIL" );
#precache( "string", "SM_TYPE_SABOTAGE_EXFIL_INTRO_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_EXFIL_MAIN_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_EXFIL_OUTRO_SPLASH1" );
#precache( "string", "SM_TYPE_SABOTAGE_EXFIL_OUTRO_SPLASH2" );
#precache( "string", "SM_TYPE_SABOTAGE_FIND_SCIENTIST_INTRO_SPLASH1" );
#precache( "string", "SM_TYPE_SABOTAGE_FIND_SCIENTIST_INTRO_SPLASH2" );
#precache( "string", "SM_TYPE_SABOTAGE_FIND_SCIENTIST" );
#precache( "string", "SM_TYPE_SABOTAGE_FIND_SCIENTIST_INTRO_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_FIND_SCIENTIST_OUTRO_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_FIND_SCIENTIST_PROGRESS_VO1" );
#precache( "string", "SM_TYPE_SABOTAGE_FIND_SCIENTIST_PROGRESS_VO2" );
#precache( "string", "SM_TYPE_SABOTAGE_FIND_SCIENTIST_OUTRO_SPLASH1" );
#precache( "string", "SM_TYPE_SABOTAGE_FIND_SCIENTIST_OUTRO_SPLASH2" );
#precache( "string", "SM_TYPE_SABOTAGE_FIND_SCIENTIST_HUD1" );
#precache( "string", "SM_TYPE_SABOTAGE_FIND_SCIENTIST_HUD2" );
#precache( "string", "SM_TYPE_SABOTAGE_PICK_UP_AGENT" );
#precache( "string", "SM_TYPE_SABOTAGE_KILL_SCIENTIST_INTRO_SPLASH1" );
#precache( "string", "SM_TYPE_SABOTAGE_KILL_SCIENTIST_INTRO_SPLASH2" );
#precache( "string", "SM_TYPE_SABOTAGE_KILL_SCIENTIST" );
#precache( "string", "SM_TYPE_SABOTAGE_KILL_SCIENTIST_INTRO_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_KILL_SCIENTIST_OUTRO_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_KILL_SCIENTIST_OUTRO_SPLASH1" );
#precache( "string", "SM_TYPE_SABOTAGE_KILL_SCIENTIST_OUTRO_SPLASH2" );
#precache( "string", "SM_TYPE_SABOTAGE_KILL_SCIENTIST_SOFT_FAIL_VO1" );
#precache( "string", "SM_TYPE_SABOTAGE_KILL_SCIENTIST_FAILING_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_KILL_SCIENTIST_HARD_FAIL_VO1" );
#precache( "string", "SM_TYPE_SABOTAGE_INPUT_CODE_LEFT" );
#precache( "string", "SM_TYPE_SABOTAGE_INPUT_CODE_RIGHT" );
#precache( "string", "SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES_INTRO_SPLASH1" );
#precache( "string", "SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES_INTRO_SPLASH2" );
#precache( "string", "SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES" );
#precache( "string", "SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES_INTRO_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES_OUTRO_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES_OUTRO_SPLASH1" );
#precache( "string", "SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES_OUTRO_SPLASH2" );
#precache( "string", "SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST_INTRO_SPLASH1" );
#precache( "string", "SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST_INTRO_SPLASH2" );
#precache( "string", "SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST" );
#precache( "string", "SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST_INTRO_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST_OUTRO_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST_OUTRO_SPLASH1" );
#precache( "string", "SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST_OUTRO_SPLASH2" );
#precache( "string", "SM_TYPE_SABOTAGE_SIDEMISSION_CACHE_DEACTIVATE_C4_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_SIDEMISSION_CACHE_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_SIDEMISSION_HUNTER_VO2" );
#precache( "string", "SM_TYPE_SABOTAGE_SIDEMISSION_HUNTER_VO3" );
#precache( "string", "SM_TYPE_SABOTAGE_SIDEMISSION_START_SPLASH" );
#precache( "string", "SM_TYPE_SABOTAGE_SIDEMISSION_HUNTER_VO1" );
#precache( "string", "SM_TYPE_SABOTAGE_SIDEMISSION_START_VO" );
#precache( "string", "SM_TYPE_SABOTAGE_INPUT_CODE" );
#precache( "string", "SM_TYPE_SABOTAGE_HAS_AGENT" );
#precache( "string", "SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES_WARN_VO1" );

#precache( "string", "SM_TYPE_SABOTAGE_PAUSED" );
#precache( "string", "SM_TYPE_SABOTAGE_CACHE_A" );
#precache( "string", "SM_TYPE_SABOTAGE_CACHE_B" );
#precache( "string", "SM_TYPE_SABOTAGE_CACHE_C" );
#precache( "string", "SM_TYPE_SABOTAGE_PAUSE_A" );
#precache( "string", "SM_TYPE_SABOTAGE_PAUSE_B" );
#precache( "string", "SM_TYPE_SABOTAGE_PAUSE_C" );
#precache( "string", "SM_TYPE_SABOTAGE_DEFUSE_A" );
#precache( "string", "SM_TYPE_SABOTAGE_DEFUSE_B" );
#precache( "string", "SM_TYPE_SABOTAGE_DEFUSE_C" );
#precache( "string", "SM_TYPE_SABOTAGE_SD_INPUT_X" );
#precache( "string", "SM_TYPE_SABOTAGE_SD_INPUT_Y" );
#precache( "string", "SM_TYPE_SABOTAGE_ONE_DOWN" );

function autoexec __init__sytem__() {     system::register("sm_type_sabotage",&__init__,undefined,undefined);    }
	
function __init__()
{
	level._effect[ "sm_sabotage_explosion" ] = "explosions/fx_exp_generic_lg";		
	level._effect["zoneEdgeMarker"] = "fire/fx_fire_flare_red"; 
	
	clientfield::register( "world", "sm_sabotage_inv_agent", 1, 3, "int" );
}
	
class cSabotageCaches : cSideMissionBase
{
	var m_n_cache_count;
	var m_a_caches;
	var m_m_terminal;
	var m_a_hud_objs;
	var m_a_waypoint_destroy;
	var m_a_waypoint_defend;
	var m_a_cur_spots;
	var m_n_parent_obj_id;

	constructor()
	{						

	}
	
	destructor()
	{
		clean_up();
	}
	
	function clean_up()
	{
		level notify ( "sabotage_cleanup_started" );
	}

	function init()
	{				
		if ( !IsDefined( level.a_sabotage_cache_structs ) )
		{
			level.a_sabotage_cache_structs = cSideMissionBase::get_structs_for_sm_element( "sabotage_cache" );
			assert( level.a_sabotage_cache_structs.size, "cSabotageCaches - no sabotage_cache structs found!" );
			
			level.a_sabotage_cache_structs = array::randomize( level.a_sabotage_cache_structs );
			level._sabotage_cur_cache = 0;
			
			set_zone_mode();
		}
	}	
	
	function set_zone_mode()
	{
		zone_mgr::set_mode( "player_unoccupied" );	
	}	
	
	function start_sidemission()
	{
		sidemission_type_base::clear_jumpto();

		sm_manager::add_objective(new cObjSabotageFindScientist());
		sm_manager::add_objective(new cObjSabotageObtainAgent());
		sm_manager::add_objective(new cObjSabotageNeutralizeCaches());
		sm_manager::add_objective(new cObjSabotageExfil());		
		
		level waittill("prematch_over");	//Wait till timer has passed
		
		thread manage_ai();
		
		// HACK: bug in UI that requires you to wait.
		level flag::wait_till( "all_players_spawned" );	
		level flag::wait_till( "zones_initialized" );
		
		wait 2.0;
		
		sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_SIDEMISSION_START_VO", "vox_ct_neutralize_biocache" );
		
		wait 3.0;
		
		sm_ui::splash_text( &"SM_TYPE_SABOTAGE_SIDEMISSION_START_SPLASH" );
		
		wait 4.0;
		
		sm_manager::start_objectives();
		sm_manager::waittill_complete();
		
		wait 2.0;
		
		sidemission_success();
	}
	
	function manage_ai()
	{
		wait 5; // wait for all the infil guys to spawn in
		thread onWaveAISpawn();	
		
		a_ai = array::remove_dead( GetAITeamArray( "axis" ) );
		foreach ( e_ai in a_ai )
		{
			if ( !e_ai flag::exists( "approach_players_thread" ) )
			{
				e_ai flag::init( "approach_players_thread" );
			}
			
			if ( !e_ai flag::exists( "rushing_cache" ) )
			{
				e_ai flag::init( "rushing_cache" );
			}
		}	
		
		thread hunter_logic();
	}

	function onWaveAISpawn()
	{
		level endon ( "sabotage_cleanup_started" );
		
		while ( true )
		{
			level waittill ( "wave_mgr_ai_spawned", e_ai );
			e_ai flag::init( "rushing_cache", false );
		}
	}	
	
	function hunter_logic()
	{
		level waittill ( "sabotage_timer_start", m_cache );
		sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_SIDEMISSION_HUNTER_VO1" );
		wait 60;
		sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_SIDEMISSION_HUNTER_VO2" );
		wait 55;
		sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_SIDEMISSION_HUNTER_VO3" );
		wait 5;
		
		sp_hunter = GetEnt( "sm_sabotage_hunter", "targetname" );
		vh_hunter = sp_hunter spawner::spawn();
		vh_hunter vehicle_ai::start_scripted( false );
		nd_path = GetVehicleNode( "sm_sabotage_hunter_enter", "targetname" );
		vh_hunter vehicle::get_on_and_go_path( nd_path );
		vh_hunter waittill ( "goal" );
	
		vh_hunter vehicle_ai::stop_scripted();			
	}
}



//--------------------------------------------------------------------------------------------------------
// Search Camps for Scientist

class cObjSabotageFindScientist : cSidemissionObjective
{
	function level_init()
	{
		level flag::init( "sm_sabotage_scientist_found" );
		level.ai_carrier = code_carrier_spawn();	
				
		add_intro_vo( &"SM_TYPE_SABOTAGE_FIND_SCIENTIST_INTRO_VO", "vox_htp_locate_scientist" );
		add_intro_splash( &"SM_TYPE_SABOTAGE_FIND_SCIENTIST_INTRO_SPLASH1", &"SM_TYPE_SABOTAGE_FIND_SCIENTIST_INTRO_SPLASH2" );
		
		add_outro_vo( &"SM_TYPE_SABOTAGE_KILL_SCIENTIST_OUTRO_VO", "vox_htp_retrieve_agent" );
		add_outro_splash( &"SM_TYPE_SABOTAGE_KILL_SCIENTIST_OUTRO_SPLASH1", &"SM_TYPE_SABOTAGE_KILL_SCIENTIST_OUTRO_SPLASH2" );
		
		add_pause_objective( &"SM_TYPE_SABOTAGE_FIND_SCIENTIST" );

		thread code_carrier_run_logic();
	}
	
	function main()
	{
		thread camp_location_waypoints();
		
		wait(1);	//TODO need flag for awareness initialization done
//		while( IsAlive( level.ai_carrier) && !level.ai_carrier ai::is_awareness_combat() )
//		{
//			util::wait_network_frame();
//		}		
		
		thread scientist_early_death_watcher( level.ai_carrier );
		level flag::wait_till( "sm_sabotage_scientist_found" );
		
		thread found_scientist_vo();
		
		if ( IsDefined( level.ai_carrier ) && IsAlive( level.ai_carrier ) )
		{
			level.ai_carrier waittill ( "death" );
		}		
	}		
	
	function scientist_early_death_watcher( ai_carrier )
	{
		ai_carrier waittill ( "death" );
		level flag::set( "sm_sabotage_scientist_found" );
	}
	
	function found_scientist_vo()
	{
		if ( IsDefined( level.ai_carrier ) && IsAlive( level.ai_carrier ) )
		{
			sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_FIND_SCIENTIST_OUTRO_VO", "vox_htp_thats_him" );	
		}
		
		wait 3;
		
		if ( IsDefined( level.ai_carrier ) && IsAlive( level.ai_carrier ) )
		{
			sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_KILL_SCIENTIST_INTRO_VO", "vox_htp_kill_scientist" );	
		}
	}
	
	function camp_location_waypoints()
	{
		a_spawn_locs = struct::get_array( "sm_sabotage_scientist_spawn", "targetname" );
		foreach ( s_spawn_loc in a_spawn_locs )
		{	
			thread camp_location_waypoint_think( s_spawn_loc );	
		}	

		thread camp_location_hud_manager();
	}
	
	function camp_location_waypoint_think( s_spot, str_waypoint = "waypoint_targetneutral" )
	{
		m_spot = spawn( "script_model", s_spot.origin );
		m_spot SetModel( "tag_origin" );
		m_spot.angles = (0,0,0);
		
		sm_ui::icon_add( m_spot, "location" );
		
		if ( ( isdefined( s_spot.code_carrier_loc ) && s_spot.code_carrier_loc ) )
		{
			level flag::wait_till( "sm_sabotage_scientist_found" );
			sm_ui::icon_remove( m_spot );	
			
			level notify( "sm_sabotage_scientist_found" );
			level notify( "sm_respawn_spectators" );
			
			return;
		}
		
		while ( !level flag::get( "sm_sabotage_scientist_found" ) && !has_player_found_camp( m_spot ) )
		{
			wait 1;
		}
		
		level notify ( "sm_sabotage_camp_found" );
		sm_ui::icon_remove( m_spot );
		
		if ( !level flag::get( "sm_sabotage_scientist_found" ) )
		{
			// Progress VO
			if ( RandomInt( 2 ) )
			{
				sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_FIND_SCIENTIST_PROGRESS_VO1", "vox_htp_no_scientist" );
			}
			else
			{
				sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_FIND_SCIENTIST_PROGRESS_VO2", "vox_htp_search_perimeter" );
			}			
		}
	}
	
	function has_player_found_camp( m_spot )
	{
		foreach ( player in level.players )
		{
			if ( DistanceSquared( player.origin, m_spot.origin ) < (1024*1024) && player util::is_looking_at( m_spot, 0.8, true ) )
			{
				return true;
			}
		}
		
		return false;
	}
	
	function camp_location_hud_manager()
	{
		level endon ( "sm_sabotage_scientist_found" );
		
		a_spawn_locs = struct::get_array( "sm_sabotage_scientist_spawn", "targetname" );
		n_camps_left = a_spawn_locs.size;
		
		n_hud_objective = sm_ui::hud_objective_register( &"SM_TYPE_SABOTAGE_OUTPOST_LABEL" );
		sm_ui::hud_objective_set( n_hud_objective, 0 );
		
		level thread camp_location_hud_remove_watch( n_hud_objective );
		
		while ( true )
		{
			level waittill ( "sm_sabotage_camp_found" );
			n_camps_left--;
			sm_ui::hud_objective_update( n_hud_objective, 4 - n_camps_left );
		}
	}
	
	function camp_location_hud_remove_watch( n_hud_objective )
	{
		level waittill ( "sm_sabotage_scientist_found" );
		sm_ui::hud_objective_remove( n_hud_objective );
	}
	
	function code_carrier_spawn()
	{
		sp_spawner = GetEnt( "sm_sabotage_code_carrier", "targetname" );
		
		a_spawn_locs = struct::get_array( "sm_sabotage_scientist_spawn", "targetname" );		
		s_spawn_loc = array::random( a_spawn_locs );
		if ( !IsDefined( s_spawn_loc.angles ) )
		{
			s_spawn_loc.angles = (0,0,0);
		}
		
		ai = sp_spawner spawner::spawn();
		ai ForceTeleport( s_spawn_loc.origin, s_spawn_loc.angles );
		// ai ai::update_start_position( s_spawn_loc.origin, s_spawn_loc.angles );
		ai SetGoal( s_spawn_loc.origin );
//		ai thread util::magic_bullet_shield();	// temp on to test running, turns off 3 seconds after starting to run
		
		thread update_drop_position_on_death( ai );
		
		s_spawn_loc.code_carrier_loc = true;
		
		thread sidemission_type_base::set_jumpto( s_spawn_loc.origin, "Sabotage/Scientist" );
		
		return ai;
	}
	
	function update_drop_position_on_death( ai_carrier )
	{
		ai_carrier waittill ( "death" );
		
		// if ai_carrier is undefined then do not set the access code location to undefined
		if ( isdefined( ai_carrier ) && isdefined( ai_carrier.origin ) )
		{
			level.v_access_code_loc = ai_carrier.origin;
		}
	}		
	
function code_carrier_run_logic()
	{
		wait 1; // allow the ai_carrier to spawn in from another function
		ai_code_carrier = level.ai_carrier;
		ai_code_carrier endon ( "death" );	
		ai_code_carrier.ignoreall = true;
		
		can_see_player = false;
		while( /* !ai_code_carrier ai::is_awareness_combat() || */ !can_see_player )	
		{
			foreach ( player in level.players )
			{
				if ( player util::is_looking_at( ai_code_carrier GetTagOrigin("tag_eye"), 0.7, true ) )
				{
					can_see_player = true;
				}
			}
			
			util::wait_network_frame();
		}	

		level flag::set( "sm_sabotage_scientist_found" );		
		
		// ai_code_carrier ai::force_awareness_to_combat();
		ai_code_carrier.ignoreall = true;		
		sm_ui::icon_add( ai_code_carrier, "kill" );
//		_hud_waypoint_create( ai_code_carrier, STR_CACHE_WAYPOINT, 72 );		
		
		thread temp_code_carrier_turn_off_bullet_shield( ai_code_carrier );
		
		while ( true )
		{
			util::wait_network_frame();
			
			v_average_spot = code_carrier_find_average_player_pos( ai_code_carrier );
			if ( !IsDefined( v_average_spot ) )
			{
				continue;
			}
			
			v_pos = code_carrier_get_run_to_spot( ai_code_carrier, v_average_spot );
			
			if ( !IsDefined( v_pos ) )
			{
				continue;
			}
			
			ai_code_carrier.goalradius = 64;
			is_valid = ai_code_carrier SetGoal( v_pos );
			
			n_endtime = GetTime() + 1000;
			while ( Distance2dSquared( ai_code_carrier.origin, v_pos ) > ( 128 * 128 ) && GetTime() < n_endtime )
			{
//				thread _debug_draw_code_carrier_path( ai_code_carrier, v_pos );
				util::wait_network_frame();
			}
		}
	}
	
	function code_carrier_find_average_player_pos( ai_code_carrier )
	{
		n_combined_x = 0;	
		n_combined_y = 0;
		n_combined_z = 0;
		n_combined_weight = 0;
		n_players_in_range = 0;
		
		foreach ( player in level.players )
		{
			n_dist = DistanceSquared( player.origin, ai_code_carrier.origin );
			
			if ( n_dist > (1536 * 1536 ) )
			{
				continue;	
			}
			
			n_players_in_range++;
			n_weight = (abs( n_dist - (1536 * 1536 ) ) / (1536 * 1536 )); // the weight to apply - the closer, the higher the weight
			
			n_combined_x += ( player.origin[0] * n_weight );
			n_combined_y += ( player.origin[1] * n_weight );
			n_combined_z += ( player.origin[2] * n_weight );
			n_combined_weight += n_weight;			
			
/#
//			IPrintLn( player.name + ": " + n_weight );
#/
		}
		
		if ( n_combined_weight )	// there could be no players within distance
		{
			v_average_spot = ( n_combined_x / n_combined_weight,
		    	              n_combined_y / n_combined_weight,
		    	              n_combined_z / n_combined_weight );		
		}
		else
		{
			code_carrier_escaping( ai_code_carrier );
		}
		
		return v_average_spot;
	}
	
	function code_carrier_escaping( ai_code_carrier )
	{
		n_hud_objective = sm_ui::hud_objective_register( &"SM_TYPE_SABOTAGE_KILL_SCIENTIST_FAILING_VO" );
		sm_ui::hud_objective_set( n_hud_objective );				
		sm_ui::hud_objective_add_timer( n_hud_objective, 5 );
		
		sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_KILL_SCIENTIST_SOFT_FAIL_VO1", "vox_htp_getting_away" );
		
		is_player_close = false;
		while ( !is_player_close )
		{
			if ( !sm_ui::hud_objective_timer_get_time( n_hud_objective ) )	// check if timer has hit 0
			{
				sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_KILL_SCIENTIST_HARD_FAIL_VO1", "vox_htp_lost_target" );
				wait 3;
				cSidemissionObjective::mission_fail();
			}
			
			foreach ( player in level.players )
			{
				n_dist = DistanceSquared( player.origin, ai_code_carrier.origin );
				
				if ( n_dist < (1536 * 1536 ) )
				{
					is_player_close = true;	
				}
			}
			
			util::wait_network_frame();
		}
		
		sm_ui::hud_objective_remove( n_hud_objective );
	}		
	
	function code_carrier_get_run_to_spot( ai_code_carrier, v_average_spot )
	{
		// get the vector away from the average player position
		v_away = VectorNormalize( ai_code_carrier.origin - v_average_spot );
		
		// get the vector to the left, right, and forward
		v_right = VectorNormalize( VectorCross( v_away, (0,0,1) ) );
		v_left = v_right * -1;
		v_forward = v_away *-1;
		
		//TODO: clean this up, sort right/left based on which is further from players
		a_directions = array( v_away, v_right, v_left, v_forward );
				
		for ( i = 0; i < a_directions.size; i++ )
		{
			v_pos = code_carrier_get_spot_from_vector( ai_code_Carrier, a_directions[i] );
			if ( IsDefined( v_pos ) )
			{
				break;	
			}
		}
		
		return v_pos;
	}
	
	function code_carrier_get_spot_from_vector( ai_code_carrier, v_direction )
	{
		v_run_dir = VectorScale( v_direction, 512 );
		v_spot = ai_code_carrier.origin + v_run_dir;
		v_pos = GetClosestPointOnNavMesh( v_spot, 512, 64 );		
		
		return v_pos;
	}
	
	function temp_code_carrier_turn_off_bullet_shield( ai )
	{
		wait 3;
		
//		ai util::stop_magic_bullet_shield();
	}
	
	function _debug_draw_code_carrier_path( ai_code_carrier, v_spot )
	{
/#
		ai_code_carrier endon ( "goal" );
		
		line( ai_code_carrier GetTagOrigin(  "tag_eye" ), v_spot, ( 0, 1, 0 ), 1, 1 );
			
//		ai_code_carrier.hud_waypoint.x = ai_code_carrier.origin[0];
//		ai_code_carrier.hud_waypoint.y = ai_code_carrier.origin[1];
//		ai_code_carrier.hud_waypoint.z = ai_code_carrier.origin[2] + 72;
#/
	}
	
	function _debug_draw_code_carrier_choice( start_pos, end_pos, dot )
	{
/#
//		for ( i = 0; i < 20; i++ )
//		{
			line( start_pos, end_pos, ( 1, 0, 0 ), 1, 1, 100 );
			print3d( end_pos, dot, ( 1, 0, 0 ), 1, 1, 100 );
//			util::wait_network_frame();
//		}
#/			
	}		
}



//--------------------------------------------------------------------------------------------------------
// Obtain the Neutralizing Agent

class cObjSabotageObtainAgent : cSideMissionObjective
{
	function level_init() 
	{	
		level.v_access_code_loc = (0,0,0); // default location
		
		add_intro_vo( &"SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST_INTRO_VO", "vox_htp_recover_agent" );
		add_intro_splash( &"SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST_INTRO_SPLASH1", &"SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST_INTRO_SPLASH2" );
		
		add_outro_vo( &"SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST_OUTRO_VO", "vox_htp_well_done" );
		add_outro_splash( &"SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST_OUTRO_SPLASH1", &"SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST_OUTRO_SPLASH2" );
		
		add_pause_objective( &"SM_TYPE_SABOTAGE_OBTAIN_SCIENTIST" );
	}
	
	function main()
	{
		// TODO: clean up, currently stolen from HVT
		m_code_trig = spawn( "trigger_radius_use", level.v_access_code_loc + (0,0,16), 0, 64, 128 );
		m_code_trig TriggerIgnoreTeam();
		m_code_trig SetCursorHint( "HINT_NOICON" );
		m_code_trig SetHintString( &"SM_TYPE_SABOTAGE_PICK_UP_AGENT" );
		
		m_code_trig.waypoint = sm_ui::create_objective_waypoint( "T7_hud_prompt_pickup_64", m_code_trig.origin, 0);
		m_code_trig.waypoint SetWayPoint( true, "T7_hud_prompt_pickup_64", true, false );
		thread neutralizing_agent_marker_think( m_code_trig );
		
		thread sidemission_type_base::set_jumpto( m_code_trig.origin, "Sabotage/Agent Pickup" );
		
		m_code_trig waittill( "trigger", player );
		m_code_trig SetHintString( "" );
		
		sm_ui::inventory_pickup( "sm_sabotage_inv_agent", player );
		
		m_code_trig.waypoint Destroy();
		
		player temp_player_lock_in_place( m_code_trig );
		
		m_progress_bar = player hud::createPrimaryProgressBar();
		m_progress_bar do_bar_update( 3 );		
		
		level notify ( "sm_sabotage_agent_picked_up" );
		
		m_code_trig Delete();
		player temp_player_lock_in_place_remove();
		give_player_neutralizing_agent( player );
		
		level notify( "sm_respawn_spectators" );
	}
	
	function neutralizing_agent_marker_think( m_code_trig )
	{
		m_agent_marker = spawn( "script_model", m_code_trig.origin );
		m_agent_marker.angles = (0,0,0);
		m_agent_marker SetModel( "tag_origin" );
		
		sm_ui::icon_add( m_agent_marker );
		
		level waittill ( "sm_sabotage_agent_picked_up" );
		
		sm_ui::icon_remove( m_agent_marker );
	}
	
	// borrowed from _sm_type_secure_goods.gsc
	function temp_player_lock_in_place( trigger )  // self = player
	{
		const DISTANCE_PROJECTION = 50;
		
//		v_lock_position = ( trigger.origin + VectorNormalize( AnglesToForward( trigger.angles ) ) * DISTANCE_PROJECTION );
//		v_lock_position_ground = BulletTrace( v_lock_position, v_lock_position - ( 0, 0, 100 ), false, undefined )[ "position" ];
//		v_lock_angles = FLAT_ANGLES( VectorToAngles( VectorScale( AnglesToForward( trigger.angles ), -1 ) ) );  // face the trigger (circuit breaker panel)
		
		self.circuit_breaker_lock_ent = Spawn( "script_origin", self.origin );
		self.circuit_breaker_lock_ent.angles = self.angles;
		
		self PlayerLinkTo( self.circuit_breaker_lock_ent, undefined, 0, 0, 0, 0, 0 );  // don't allow player to look around during this sequence
		
		self DisableWeapons();
	}
	
	function temp_player_lock_in_place_remove()  // self = player
	{
		if ( IsDefined( self ) && IsDefined( self.circuit_breaker_lock_ent ) )
		{
			self Unlink();
			
			self.circuit_breaker_lock_ent Delete();
			
			self EnableWeapons();
		}
	}	
	
	// self = progressbar hud
	function do_bar_update( n_duration )
	{
		self endon( "kill_bar" );

		self hud::updateBar( 0.01, 1 / n_duration );
		
		wait n_duration;
		
		self hud::destroyElem();;
	}	
	
	function give_player_neutralizing_agent( agent_player )
	{
		agent_player.sabotage_has_agent = true;
/*		
		agent_player.sabotage_agent_hudelem = newclienthudelem( agent_player );
			
		agent_player.sabotage_agent_hudelem.alignX = "right";
		agent_player.sabotage_agent_hudelem.alignY = "bottom";
		agent_player.sabotage_agent_hudelem.horzAlign = "right";
		agent_player.sabotage_agent_hudelem.vertAlign = "bottom";
		agent_player.sabotage_agent_hudelem.hidewheninmenu = true;
		agent_player.sabotage_agent_hudelem.y = -75;
		agent_player.sabotage_agent_hudelem.x = -25;
		
		agent_player.sabotage_agent_hudelem SetShader( HUD_ICON_AGENT, 32, 32 );
		
		foreach ( player in level.players )
		{
			player.sabotage_agent_holder_hudelem = [];
			player.sabotage_agent_holder_hudelem[0] = neutralizing_agent_hudelem_create( player, 155, 0 );
			player.sabotage_agent_holder_hudelem[1] = neutralizing_agent_hudelem_create( player, 152, 20);
			player.sabotage_agent_holder_hudelem[2] = neutralizing_agent_hudelem_create( player, 162, 20 );
			
			player.sabotage_agent_holder_hudelem[0] SetShader( HUD_ICON_AGENT, 16, 16 );
			player.sabotage_agent_holder_hudelem[1] SetText( agent_player.name );
			player.sabotage_agent_holder_hudelem[2] SetText( &"SM_TYPE_SABOTAGE_HAS_AGENT" );
		} */
	}	
	
	function neutralizing_agent_hudelem_create( player, x, y )
	{
		hudelem = NewClientHudElem( player );
		hudelem.alignX = "left";
		hudelem.alignY = "top";
		hudelem.horzAlign = "left";
		hudelem.vertAlign = "top";
		hudelem.hidewheninmenu = true;		
		hudelem.x = y;
		hudelem.y = x;			
		hudelem.fontscale = 1;
		
		return hudelem;
	}
}



//--------------------------------------------------------------------------------------------------------
// Neutralize the Bio-Weapon Caches

class cObjSabotageNeutralizeCaches : cSideMissionObjective
{
	var m_a_caches;
	var m_a_waypoint_destroy;
	var m_a_waypoint_defend;
	var m_a_cache_title;
	var m_a_cache_defuse_title;
	var m_a_pause_title;
	
	constructor()
	{						
		m_a_waypoint_destroy = [];
		m_a_waypoint_destroy["A"] = "t7_hud_waypoints_a";
		m_a_waypoint_destroy["B"] = "t7_hud_waypoints_b";
		m_a_waypoint_destroy["C"] = "t7_hud_waypoints_c";
		
		m_a_waypoint_defend = [];
		m_a_waypoint_defend["A"] = "t7_hud_waypoints_a";
		m_a_waypoint_defend["B"] = "t7_hud_waypoints_b";
		m_a_waypoint_defend["C"] = "t7_hud_waypoints_c";
		
		m_a_cache_title = [];
		m_a_cache_title["A"] = &"SM_TYPE_SABOTAGE_TIMER_A";
		m_a_cache_title["B"] = &"SM_TYPE_SABOTAGE_TIMER_B";
		m_a_cache_title["C"] = &"SM_TYPE_SABOTAGE_TIMER_C";
		
		m_a_pause_title = [];
		m_a_pause_title["A"] = &"SM_TYPE_SABOTAGE_PAUSE_A";
		m_a_pause_title["B"] = &"SM_TYPE_SABOTAGE_PAUSE_B";
		m_a_pause_title["C"] = &"SM_TYPE_SABOTAGE_PAUSE_C";

		
		m_a_cache_defuse_title = [];
		m_a_cache_defuse_title["A"] = &"SM_TYPE_SABOTAGE_DEFUSE_A";
		m_a_cache_defuse_title["B"] = &"SM_TYPE_SABOTAGE_DEFUSE_B";
		m_a_cache_defuse_title["C"] = &"SM_TYPE_SABOTAGE_DEFUSE_C";
		
		m_a_hud_objs = [];
		m_a_caches = [];
	}	
	
	function level_init()
	{		
		add_intro_vo( &"SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES_INTRO_VO", "vox_htp_use_agent" );
		add_intro_splash( &"SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES_INTRO_SPLASH1", &"SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES_INTRO_SPLASH2" );
		add_outro_splash( &"SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES_OUTRO_SPLASH1", &"SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES_OUTRO_SPLASH2" );
		
		add_pause_objective( &"SM_TYPE_SABOTAGE_NEUTRALIZE_CACHES" );
		
		thread cache_ai_think();
		
		m_n_cache_count = 2;
		str_alphabet = "ABC";
		
		for( i = 0; i < 2; i++ )
		{
			m_a_caches[i] = spawn_cache( level.a_sabotage_cache_structs[i], str_alphabet[i] );
		}		
	}
	
	function main()
	{
		zone_mgr::set_mode( "objective_unoccupied" );	

		foreach ( m_cache in m_a_caches )
		{
			thread start_cache_logic( m_cache );	
			
			thread sidemission_type_base::set_jumpto( m_cache.origin, "Sabotage/Cache" );
		}	
		
		// Start Wave Spawner
		wave_mgr::start_wave_spawning( 3 );	
		
		thread warlord_entrance_watch();
		
		level waittill ( "all_caches_destroyed" );		
		level notify( "sm_respawn_spectators" );
	}
	
	function warlord_entrance_watch()
	{
		while ( _get_caches_with_c4().size < m_a_caches.size )	// _get_caches_with_c4 only returns non-destroyed caches with c4
		{
			util::wait_network_frame();
		}
		
//		wave_mgr::add_enemy_type_info( "warlord",		3,	0.1 ); // uncomment once this is working
	}
	
	function spawn_cache( s_spawn_struct, str_letter )
	{
		m_cache = spawn( "script_model", s_spawn_struct.origin );
		m_cache.angles = s_spawn_struct.angles;
		m_cache SetModel( "p7_int_bio_cache" );
			
		// Set up the use trigger
		v_forward = VectorNormalize( AnglesToForward( m_cache.angles ) );
		v_trigger_origin = m_cache.origin + ( v_forward * 20 ) + (0,0,32);
		m_cache.use_trig = spawn( "trigger_radius_use", v_trigger_origin, 0, 16, 100 );
		m_cache.use_trig TriggerIgnoreTeam();
		m_cache.use_trig SetCursorHint( "HINT_NOICON" );
		m_cache.use_trig SetHintString( "" );				
		
		m_cache flag::init( "can_defuse" );
		
		m_cache._site_letter = str_letter;
		m_cache.use_trig.targetname = "cache_trig_" + str_letter;		
		
		return m_cache;
	}	
	
	function cache_ai_think()
	{
		while ( true )
		{
			level waittill ( "wave_mgr_ai_spawned", e_ai );
			
			if ( _get_caches_with_c4().size )
			{
				a_caches = _get_caches_with_c4(); 
				a_caches = ArraySort( a_caches, e_ai.origin );
				thread _cache_ai_rush( e_ai, a_caches[0] );
			}
		}
	}
	
	
	
	
	
	
	//
	// TODO: change from waypoints to the new UI design
	function _hud_waypoint_create( m_model, str_shader = "waypoint_targetneutral", n_offset = 64 )
	{	
		str_icon = m_a_waypoint_destroy[ m_model._site_letter ];
		
		sm_ui::icon_add( m_model, "interact", str_icon );
		m_model reset_objective_color();
		
		cache_worldspace( m_model, str_icon );
		m_model thread cache_waypoint( str_icon );
		
//		m_model.hud_waypoint = sm_ui::create_objective_waypoint( str_shader, m_model.origin, n_offset);
	}	
	
	// stolen from _sm_type_secure_goods
	function reset_objective_color()  // self = ent with objective icon on it
	{
		// HACK: _gameobjects and _sm_ui can reuse the same objective icon, which causes the incorrect color to show up after objective is released. Manually set color here:
		// TODO: notify code that when an objective is released, it should reset the color to default automatically -TJanssen 3/27/2014
		if ( IsDefined( self.sm_minimap_icon ) )
		{
			objective_SetColor( self.sm_minimap_icon, 1.0, 1.0, 1.0 );  // white
		}	
	}	
	
	function _cache_waypoint_set_destroy( m_cache )
	{
		str_message = &"SM_TYPE_SABOTAGE_ICON_BIO_CACHE_USE";
		_cache_waypoint_set( m_cache, str_message );		
	}
	
	function _cache_waypoint_set_defend( m_cache )
	{
		str_message = &"SM_TYPE_SABOTAGE_ICON_BIO_CACHE_NEUTRALIZING";
		_cache_waypoint_set( m_cache, str_message );
	}
	
	function _cache_waypoint_set( m_cache, str_message )
	{
		if ( IsDefined( m_cache.sm_minimap_icon ) )
		{
//			m_cache.hud_waypoint Destroy();
//			sm_ui::icon_remove( m_cache );
		}
		
		[[m_cache.o_3d_message]]->update_line( m_cache.n_3d_message_line2, str_message, 1.0 );
	}
	
	function cache_worldspace( m_cache, str_icon )
	{
		m_cache.o_3d_message = new cFakeWorldspaceMessage();
		[[m_cache.o_3d_message]]->init( m_cache.origin + ( 0, 0, 72 ), 512, str_icon, -64 );
		[[m_cache.o_3d_message]]->set_parent( m_cache );
		m_cache.o_3d_message.m_n_range_inner = 72;

		m_cache.n_3d_message_line1 = [[m_cache.o_3d_message]]->add_line( &"SM_TYPE_SABOTAGE_ICON_BIO_CACHE", 2.0, true );
		m_cache.n_3d_message_line2 = [[m_cache.o_3d_message]]->add_line( &"SM_TYPE_SABOTAGE_ICON_BIO_CACHE_LOCKED", 1.5, true, &cache_worldspace_line2_think );
	}

	function cache_worldspace_line2_think( e_player, s_elem )
	{
		if ( !( s_elem.state === "agent_active" ) && ( isdefined( e_player.sm_cache_started ) && e_player.sm_cache_started ) &&
		   	Distance2DSquared( e_player.origin, s_elem.origin ) < (256 * 256) ) 
		{
			s_elem SetText(&"SM_TYPE_SABOTAGE_ICON_BIO_CACHE_NEUTRALIZING");
			e_player.sm_cache_started = undefined;
			s_elem.state = "agent_active";
		}
		else if ( !( s_elem.state === "agent_held" ) && ( isdefined( e_player.sabotage_has_agent ) && e_player.sabotage_has_agent ) )
		{
			s_elem SetText(&"SM_TYPE_SABOTAGE_ICON_BIO_CACHE_USE");
			s_elem.state = "agent_held";		
		}
		else if ( !( isdefined( e_player.sabotage_has_agent ) && e_player.sabotage_has_agent ) )
		{
			s_elem SetText(&"SM_TYPE_SABOTAGE_ICON_BIO_CACHE_LOCKED");
			s_elem.state = "agent_required";				
		}
	}

	// Stolen from _sm_ammo_cache.gsc until a proper solution exists
	function cache_waypoint( str_icon )
	{
		a_player_hud_elements = [];

		while ( !( isdefined( self.is_destroyed ) && self.is_destroyed ) )
		{
			foreach ( player in level.players )
			{
				if ( DistanceSquared( player.origin, self.origin ) > ( 72 * 72 ) )
				{
					if ( !IsDefined( a_player_hud_elements[ player.entnum ] ) )
					{
						hud_ammo_cache = NewClientHudElem( player );
						hud_ammo_cache.x = self.origin[ 0 ];
						hud_ammo_cache.y = self.origin[ 1 ];
						hud_ammo_cache.z = self.origin[ 2 ] + 40;
						hud_ammo_cache.alpha = 0.61;
						hud_ammo_cache.archived = true;
						hud_ammo_cache SetShader( str_icon, 7, 7);
						hud_ammo_cache SetWaypoint( true, str_icon ) ;

						a_player_hud_elements[ player.entnum ] = hud_ammo_cache;
					}
				}
				else
				{
					if ( IsDefined( a_player_hud_elements[ player.entnum ] ) )
					{
						a_player_hud_elements[ player.entnum ] Destroy();
					}
				}
			}

			util::wait_network_frame();
		}
		
		foreach ( player in level.players )
		{
			if ( IsDefined( a_player_hud_elements[ player.entnum ] ) )
			{
				a_player_hud_elements[ player.entnum ] Destroy();
			}			
		}
	}


	
	
	
	
	// end TODO -------------------------------------
	//
	
	function start_cache_logic( m_cache )
	{
		// Set the objective zones now that the codes are obtained
		m_cache.str_zone = zone_mgr::get_zone_from_position( m_cache.origin+(0,0,32), TRUE );
		zone_mgr::set_objective_zone( m_cache.str_zone );
		
		_hud_waypoint_create( m_cache );
		
		_cache_input_code( m_cache );
		_cache_self_destruct_countdown( m_cache );
		_cache_explode( m_cache );
		
		level notify ( "raid_cache_updated_objective" );

		zone_mgr::clear_objective_zone( m_cache.str_zone );		
		sm_ui::hud_objective_remove( m_cache.n_hud_objective );
		sm_ui::icon_remove( m_cache );
		
		wait 2;
		
		m_cache.b_exploded = true;
		
		// See if we have exploded all the caches.
		n_done = 0;
		foreach ( m_cache in m_a_caches )
		{
			if ( ( isdefined( m_cache.b_exploded ) && m_cache.b_exploded ) )
			{
				n_done++;
			}
		}
		
		if ( n_done == m_a_caches.size )
		{
			sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_SIDEMISSION_CACHE_VO", "vox_htp_both_biocaches" );
			level notify( "all_caches_destroyed" );
		} else {
			sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_ONE_DOWN", "vox_htp_one_biocache" );
		}
		
		level notify( "sm_respawn_spectators" );
	}	
	
	function _cache_self_destruct_countdown( m_cache )
	{
		_cache_waypoint_set_defend( m_cache );
		
		m_cache.n_hud_objective = sm_ui::hud_objective_register( m_a_cache_title[m_cache._site_letter] );
		sm_ui::hud_objective_update( m_cache.n_hud_objective, 90 );			
		
		thread _cache_countdown_timer( m_cache, 90 );			
	
		level notify ( "sabotage_timer_start", m_cache );
		
		str_bomb_state = "none";
		while ( str_bomb_state != "bomb_detonated" )
		{			
			if ( str_bomb_state == "bomb_defused" ) 
			{
				cSideMissionBase::wait_for_interact( m_cache.use_trig, "Press and Hold ^3[{+activate}]^7 to restart Self-Destruct", 5, undefined, undefined, undefined, "plant" );
				_cache_waypoint_set_defend( m_cache );
				sm_ui::hud_objective_pause_timer( m_cache.n_hud_objective, false );
			}
			
			thread _cache_attempt_deactivate( m_cache );
			thread _cache_rush_on_plant( m_cache );
			
			str_bomb_state = m_cache util::waittill_any_return( "bomb_defused", "bomb_detonated" );
			if ( str_bomb_state == "bomb_defused" ) 
			{
				sm_ui::hud_objective_pause_timer( m_cache.n_hud_objective, true, &"SM_TYPE_SABOTAGE_PAUSED" );
				
				_cache_waypoint_set_destroy( m_cache );
			}
			else 
			{
				sm_ui::hud_objective_remove_timer( m_cache.n_hud_objective );
			}
			
			m_cache notify ( "timer_stopped" );
			m_cache flag::clear( "can_defuse" );
		}		
	}
	
	function _cache_input_code( m_cache )
	{
		n_hud_objective = sm_ui::hud_objective_register( m_a_cache_title[m_cache._site_letter] );
		sm_ui::hud_objective_set( n_hud_objective, 90 );			
		
		_cache_waypoint_set_destroy( m_cache );
		
		_wait_for_input_code( m_cache.use_trig );
	}
	
	function _wait_for_input_code( t_use_trig )
	{		
		is_complete = false;
		
		while ( !is_complete )
		{
//			t_use_trig SetHintString( &"SM_TYPE_SABOTAGE_INPUT_CODE" );
			t_use_trig waittill ( "trigger", e_triggerer );
			
			if ( !( isdefined( e_triggerer.sabotage_has_agent ) && e_triggerer.sabotage_has_agent ) )	// player must have the neutralizing agent to interact
			{
				util::wait_network_frame();
				continue;
			}
			
			t_use_trig SetHintString( "" );
			e_triggerer DisableWeapons();
			
			m_linkto = util::spawn_model( "tag_origin", e_triggerer.origin, e_triggerer.angles );
			e_triggerer PlayerLinkTo( m_linkto, undefined, 0, 0, 0, 0, 0 );  // don't allow player to look around during this sequence
			
//			e_triggerer util::freeze_player_controls( true );
			
			hud_elem = e_triggerer sm_ui::_create_client_hud_elem( "center", "middle", "center", "middle", 0, 64, 1.5, (1.0,1.0,1.0) );
			
			thread _input_code_logic( e_triggerer, hud_elem );
			thread _input_code_exit( e_triggerer );			
			
			level waittill ( "input_code_done", is_complete );
			
			hud_elem Destroy();
			e_triggerer EnableWeapons();
			e_triggerer Unlink();
			m_linkto delete();
//			e_triggerer util::freeze_player_controls( false );
		}
	}
	
	function _input_code_logic( e_player, hud_elem )
	{
		level endon ( "input_code_done" );
		
		a_input = [];
		
		a_input[0] = SpawnStruct();
		a_input[0].func = &UseButtonPressed;
		a_input[0].string = &"SM_TYPE_SABOTAGE_SD_INPUT_X";
		
		a_input[1] = SpawnStruct();
		a_input[1].func = &ChangeSeatButtonPressed;
		a_input[1].string = &"SM_TYPE_SABOTAGE_SD_INPUT_Y";
	
		s_last_input = array::random(a_input);
		
		for ( i = 0; i < 2; i++ )
		{
			hud_elem SetText( &"SM_TYPE_SABOTAGE_INPUT_CODE_LEFT" );
			wait_for_left_stick_input( e_player, "left" );
			hud_elem SetText( &"SM_TYPE_SABOTAGE_INPUT_CODE_RIGHT" );
			wait_for_left_stick_input( e_player, "right" );
		}
		
		for ( i = 0; i < 3; i++ )
		{
			s_input = array::random( a_input );
			
			while ( s_input == s_last_input ) // make sure the key changes each time
			{
				s_input = array::random( a_input );
			}
				
			hud_elem SetText( s_input.string );
			
			while ( !e_player [[ s_input.func ]]() )
			{
				util::wait_network_frame();
			}
			
			hud_elem.alpha = 0.0;
			wait 0.5;
			hud_elem.alpha = 1.0;
			
			s_last_input = s_input;
		}
		
		level notify( "input_code_done", true );
	}
	
	function _input_code_exit( e_player )
	{
		level endon ( "input_code_done" );
		
		while ( !e_player StanceButtonPressed() )
		{
			util::wait_network_frame();
		}
		
		wait 0.25;
		
		level notify( "input_code_done", false );
	}
	
	function wait_for_left_stick_input( player, str_dir )
	{
		player endon( "death" );
		player endon( "entering_last_stand" );
		
		const LEFT_MAGNITUDE = -0.5;
		const RIGHT_MAGNITUDE = 0.5;
		
		n_frames_held = 0;
		
		while ( n_frames_held < ( .5 * 20 ) )
		{
			v_stick = player GetNormalizedMovement();
			n_left = v_stick[ 1 ];
			
			if ( (str_dir == "left" && n_left < LEFT_MAGNITUDE ) || (str_dir == "right" && n_left > RIGHT_MAGNITUDE ) )
			{
				if ( n_frames_held == 0 )
				{
					m_progress_bar = player hud::createPrimaryProgressBar();
					m_progress_bar thread do_bar_update( .5 );						
				}
				
				n_frames_held++;
			}
			else 
			{
				n_frames_held = 0;
				
				if ( IsDefined( m_progress_bar ) )
				{
					m_progress_bar destroy_progress_bar();
				}
			}
			
			{wait(.05);};
		}
		
		if ( IsDefined( m_progress_bar ) )
		{
			m_progress_bar destroy_progress_bar();
		}
	}	
	
	function do_bar_update( n_duration )
	{
		self endon( "kill_bar" );

		self hud::updateBar( 0.01, 1 / n_duration );
		
		wait n_duration;
		
		self hud::destroyElem();;
	}	

	function destroy_progress_bar()  // self = hud elem
	{
		if ( IsDefined( self ) )
		{
			self notify( "kill_bar" );
			self hud::destroyElem();				
		}
	}	
	
	function _cache_countdown_timer( m_cache, n_timer_length )
	{
		sm_ui::hud_objective_add_timer( m_cache.n_hud_objective, n_timer_length );
		m_cache sm_ui::hud_objective_timer_wait( m_cache.n_hud_objective );
		
		m_cache notify ( "bomb_detonated" );
	}
	
	function _cache_deactivate_c4_notify_players( m_cache )
	{
		foreach ( player in level.players )
		{
			player.deactivate_hud[m_cache._site_letter] = player sm_ui::_create_client_hud_elem( "center", "middle", "center", "middle", 0, -100, 2, (1.0,1.0,1.0) );
			player.deactivate_hud[m_cache._site_letter] SetText( m_a_pause_title[m_cache._site_letter] );
		}
		
		wait 3;
		
		foreach ( player in level.players )
		{
			if ( IsDefined( player.deactivate_hud[m_cache._site_letter] ) )
			{
				player.deactivate_hud[m_cache._site_letter] Destroy();
			}
		}
	}
	
	function _cache_explode( m_cache )
	{
		PlayFX( level._effect[ "sm_sabotage_explosion" ], m_cache.origin );
		m_cache playsound( "wpn_grenade_explode" );
		m_cache SetModel( "p_glo_bomb_stack_d" );
		m_cache.is_destroyed = true;
		level notify ( "raid_cache_destroyed" );		
	}	
	
	function _get_caches_with_c4()
	{
		a_planted_caches = [];
		foreach ( m_cache in m_a_caches )
		{
			if ( m_cache flag::get( "can_defuse" ) )
			{
				if ( !isdefined( a_planted_caches ) ) a_planted_caches = []; else if ( !IsArray( a_planted_caches ) ) a_planted_caches = array( a_planted_caches ); a_planted_caches[a_planted_caches.size]=m_cache;;
			}
		}
		
		return a_planted_caches;
	}
	
	function _cache_ai_rush_check()
	{
		if ( _get_caches_with_c4().size )
		{
			a_ai = array::remove_dead( level.wave_mgr.a_ai_wave_enemies );	
			
			foreach ( e_ai in a_ai )
			{
				a_caches = _get_caches_with_c4(); 
				a_caches = ArraySort( a_caches, e_ai.origin );
				thread _cache_ai_rush( e_ai, a_caches[0] );				
			}
		}			
	}
	
	function _cache_rush_on_plant( m_cache )
	{
		a_ai = array::remove_dead( level.wave_mgr.a_ai_wave_enemies );
	
		foreach ( ai in a_ai )
		{
			if ( ( isdefined( ai.rushing_cache ) && ai.rushing_cache ) )
			{
				if ( IsDefined( ai.cache_goalpos ) && DistanceSquared( ai.origin, m_cache.origin) < DistanceSquared( ai.origin, ai.cache_goalpos ) ) // go to the new place if it is closer
				{
					ai notify ( "stop_my_rush" );
					thread _cache_ai_rush( ai, m_cache );
				}
			}	
			else
			{
				thread _cache_ai_rush( ai, m_cache );
			}			
		}
	}
	
	function _cache_ai_rush( e_ai, m_cache )
	{
		e_ai endon ( "death" );
		e_ai endon ( "defuser" );
		e_ai endon ( "stop_my_rush" );
		m_cache endon ( "timer_stopped" );
		
		old_goalradius = e_ai.goalradius;
		
		e_ai flag::clear( "approach_players_thread" );
		e_ai.rushing_cache = true;
		
		thread _cache_ai_rush_reset( e_ai, m_cache, old_goalradius );
		
		wait 1;
		
		str_zone = zone_mgr::get_zone_from_position( m_cache.origin+(0,0,32), TRUE );
		volume = level.zones[ str_zone ].volumes[0];
		
//		e_ai SetGoal( volume );
//		e_ai SetGoal( m_cache.origin + (0,0,32 ) );
	}
	
	function _cache_ai_rush_reset( e_ai, m_cache, old_goalradius )
	{
		e_ai endon ( "death" );
		
		m_cache waittill( "timer_stopped" );
		
		e_ai ClearGoalVolume();
		e_ai.rushing_cache = false;
		e_ai flag::set( "approach_players_thread" );
	}
	
	function _cache_attempt_deactivate( m_cache )
	{
		m_cache endon ( "timer_stopped" );
		
		m_cache flag::set( "can_defuse" );
		
		while ( true )
		{
			a_nearby_ai = [];
			
			while ( !a_nearby_ai.size )
			{
				a_ai = array::remove_dead( level.wave_mgr.a_ai_wave_enemies );
				a_nearby_ai = ArraySort( a_ai, m_cache.use_trig.origin, true, 1, 1536 );
				
				wait 1;
			}
			
			e_ai = a_nearby_ai[0];
			if ( IsAlive( e_ai ) )	// double check, AI may have died during the wait above
			{
				_cache_deactivate_c4( e_ai, m_cache );
//				m_cache.hud_waypoint.color = (1,1,1);
			}
		}
	}
	
	function _cache_deactivate_c4( e_ai, m_cache )
	{
		e_ai endon ( "death" );
				
		e_ai flag::clear( "approach_players_thread" );
		e_ai.rushing_cache = true;
		
		e_ai notify ( "defuser" );
		e_ai.defuser = true;
		
		old_goalradius = e_ai.goalradius;
		
		thread _cache_ai_rush_reset( e_ai, m_cache, old_goalradius );
		
		// Find the defuse point.
		v_forward = VectorNormalize( AnglesToForward( m_cache.angles ) );
		v_defuse_origin = m_cache.origin + ( v_forward * 48 ) + (0,0,8);
		v_face_bomb = VectorToAngles( m_cache.origin - v_defuse_origin );
		
		while ( Distance2dSquared( e_ai.origin, v_defuse_origin ) > ( 8 * 8 ) )
		{
			e_ai.goalradius = 8;
			is_valid = e_ai SetGoal( v_defuse_origin );
			e_ai waittill ( "goal" );
		}
		
		if ( sm_ui::hud_objective_timer_get_time( m_cache.n_hud_objective ) <= 6 ) // don't start defusing if it is about to blow up
		{
			return;
		}
		
		e_ai ai::set_ignoreall( true );
		e_ai Teleport( e_ai.origin, v_face_bomb );
		e_ai thread scene::play( "raid_sabotage_defuse", e_ai );
		
		is_defused = _cache_defuse( e_ai, m_cache );
		
		if ( isAlive( e_ai ) )
		{
			e_ai thread scene::stop();
			e_ai.goalradius = old_goalradius;
			e_ai ai::set_ignoreall( false );
			e_ai.defuser = undefined;
		}
			
		if ( ( isdefined( is_defused ) && is_defused ))
		{
			thread _cache_deactivate_c4_notify_players( m_cache );
			m_cache notify ( "bomb_defused" );
			m_cache PlaySoundToTeam( "uin_rank_demotion", "allies" );
			sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_SIDEMISSION_CACHE_DEACTIVATE_C4_VO", "vox_they_defused_charge" );
		}
		else
		{
			_cache_waypoint_set_defend( m_cache );
		}
		
		if ( isAlive ( e_ai ) && !( isdefined( is_defused ) && is_defused ) )
		{
			wait 2;	// pause so the AI doesn't IMMEDIATELY start defusing again	
		}
		
		thread _cache_ai_rush_check();
	}	
	
	function _cache_defuse( e_ai, m_cache )
	{
		e_ai endon ( "defuser_damage_threshhold" );
		e_ai endon ( "death" );
		
		str_vox = "vox_htp_" + m_cache._site_letter + "halted";
		sm_ui::temp_vo( m_a_cache_defuse_title[m_cache._site_letter], str_vox );
		
		thread _cache_defuse_watch_damage_threshhold( e_ai );
		
		for ( i = 0; i < (8 * 2); i++ ) // *2 due to the wait being 0.5 instead a full second
		{
//			if ( i % 2 )
//			{
//				m_cache.hud_waypoint.color = (1,1,1);
//			}
//			else
//			{
//				m_cache.hud_waypoint.color = (1,0,0);
//			}
			
			wait 0.2;			
		}		
		
		return true;
	}
	
	function _cache_defuse_watch_damage_threshhold( e_ai )
	{
		e_ai endon ( "death" );
		
		n_threshhold = math::clamp( e_ai.health - (e_ai.maxhealth * 0.25 ), 0, e_ai.maxhealth ); // threshhold is 25% of max health (under his current health)
		
		while ( e_ai.health > n_threshhold )
		{
			e_ai waittill ( "damage" );
		}
		
		e_ai notify ( "defuser_damage_threshhold" );
	}	
}



//--------------------------------------------------------------------------------------------------------
// Exfil

class cObjSabotageExfil : cSideMissionObjective
{
	var m_vh_vtol;
	
	function level_init() 
	{ 
		m_vh_vtol = vehicle::simple_spawn_single( "sm_sabotage_exfil" );
		m_vh_vtol vehicle::toggle_sounds(0);
		m_vh_vtol.ignoreme = true;
		
		add_intro_vo( &"SM_TYPE_SABOTAGE_EXFIL_INTRO_VO", "vox_htp_exfil_vtol" );
		add_intro_splash( &"SM_TYPE_SABOTAGE_EXFIL_INTRO_SPLASH1", &"SM_TYPE_SABOTAGE_EXFIL_INTRO_SPLASH2" );
		add_outro_splash( &"SM_TYPE_SABOTAGE_EXFIL_OUTRO_SPLASH1", &"SM_TYPE_SABOTAGE_EXFIL_OUTRO_SPLASH2" );
		
		add_pause_objective( &"SM_TYPE_SABOTAGE_EXFIL" );
	}
	
	function main()
	{
		thread _watch_vulnerability( m_vh_vtol );
//		sm_ui::temp_vo( &"SM_TYPE_SABOTAGE_EXFIL_MAIN_VO" );
		
		m_vh_vtol vehicle::toggle_sounds(1);
		
		thread extract_enemy_ai_think();
		thread extract_show_zone();
		thread extract_vtol_attackers();
		
		thread sidemission_type_base::set_jumpto( m_vh_vtol.origin, "Sabotage/Exfil" );
		
		extract_wait_until_reached();
			
		foreach( e_player in level.players )
		{
			e_player.e_vh_link = util::spawn_model( "tag_origin", e_player.origin, e_player.angles );
			e_player PlayerLinkToDelta( e_player.e_vh_link, "tag_origin", 0.0, 360, 360 );
			e_player.e_vh_link LinkTo( m_vh_vtol );
			//e_player PlayerLinkToDelta(m_vh_vtol, "tag_guy" + (i + 1) );
		}
		
		m_vh_vtol thread vehicle::get_on_and_go_path( "sm_sabotage_exfil_spline" );
	}

	function _watch_vulnerability( vh )
	{
		vh.ignoreme = false;
		
//		_update_vehicle_health_info( vh );
	}
	
	// TODO: Finish showing health, need to enable health in GDT
	function _update_vehicle_health_info( vh )
	{
		while( vh.health > 0 )
		{
			
			wait .05;
		}
	}
	
	function extract_enemy_ai_think()
	{
		s_extract = struct::get( "sm_sabotage_extract", "targetname" );
//		str_zone = zone_mgr::get_zone_from_position( s_extract.origin+(0,0,32), TRUE );
		
		// immediately send half the AI to the extract area
		a_ai = array::remove_dead( level.wave_mgr.a_ai_wave_enemies );
		foreach ( e_ai in a_ai )
		{
			if ( e_ai GetEntityNumber() % 2 )
			{
				e_ai.goalradius = 512;
				e_ai SetGoal( s_extract.origin );
//				volume = level.zones[ str_zone ].volumes[ RandomInt(level.zones[ str_zone ].volumes.size) ];
//				e_ai SetGoal( volume );
			}
		}
	}
	
	function extract_show_zone()
	{
		s_hardpoint = struct::get( "exfil_vtol_obj_point", "targetname" );
		
		level clientfield::set( "hardpoint", 1 );
		
		hud_waypoint = sm_ui::create_objective_waypoint( "T7_hud_waypoints_arrow", s_hardpoint.origin, 72 );
		m_exfil = spawn ( "script_model", s_hardpoint.origin );
		m_exfil SetModel( "tag_origin" );
		sm_ui::icon_add( m_exfil, "location" );
 //       hud_waypoint SetWayPoint( true, WAYPOINT_EXTRACT, true, false );

		level waittill ( "extraction_phase_ended" );
		
		hud_waypoint Destroy();
		
		level clientfield::set( "hardpoint", 0 );
	}		
	
	function extract_vtol_attackers()
	{
		a_t_exfil_attack = GetEntArray( "exfil_attack_event_trig", "targetname" );
		foreach( t in a_t_exfil_attack )
		{
			thread exfil_attack_spawn( t );
		}
	}
	
	function exfil_attack_spawn( t )
	{
		t waittill( "trigger" ); 
		
		a_ai_attackers = spawner::simple_spawn( t.target );
		
		foreach( ai in a_ai_attackers )
		{
			vol_arch_zone = GetEnt( ai.target, "targetname" ); // Here becasue I might want to have different defend areas
			// Alert event
		}
	}
	
	function extract_wait_until_reached()
	{
		const N_EXFIL_SAFE_TIME = 3;
		
		s_extract = struct::get( "sm_sabotage_extract", "targetname" );
		t_exfil = GetEnt( "exfil_zone_trig", "targetname" );
		
		// Set the extract zone as an objective zone
		str_zone = zone_mgr::get_zone_from_position( s_extract.origin+(0,0,32), TRUE );
		zone_mgr::set_objective_zone( str_zone );	
		
		// Wait for all players to be inside.
		n_time_inside = 0.0;
		while ( true )
		{
			{wait(.05);};
			
			b_any_outside = false;
			foreach( e_player in level.players )
			{
				e_player.inside_exfil_trig = false;
				if ( e_player.sessionstate == "spectator" )
				{
					// doesn't count as being outside, since there's no saving them.
				}
				else if ( e_player laststand::player_is_in_laststand() )
				{
					b_any_outside = true;
				}
				else
				{
					e_player.inside_exfil_trig = e_player IsTouching( t_exfil );
					if ( !e_player.inside_exfil_trig )
					{
						b_any_outside = true;
					}
				}
			}
			
			if ( !b_any_outside )
			{
				n_time_inside += 0.05;
			} else {
				
				n_time_inside = 0.0;
			}
			
			// Show/hide the appropriate elements.
			foreach( e_player in level.players )
			{
				b_show_elem = b_any_outside && e_player.inside_exfil_trig;
				if ( b_show_elem && !isdefined( e_player.wait_elem ) )
				{
					e_player.wait_elem = e_player sm_ui::_create_client_hud_elem( "center", "middle", "center", "middle", 0, 0, 3.0, (1.0, 1.0, 1.0) );
					e_player.wait_elem SetText( "Waiting for Other Players" );
				} else if ( !b_show_elem && isdefined( e_player.wait_elem ) )
				{
					e_player.wait_elem Destroy();
				}
			}
			
			// Must be safely inside for 3 seconds.
			if (n_time_inside >= 3.0)
			{
				break;
			}
		}
			
		level notify ( "extraction_phase_ended" );
	}
}

