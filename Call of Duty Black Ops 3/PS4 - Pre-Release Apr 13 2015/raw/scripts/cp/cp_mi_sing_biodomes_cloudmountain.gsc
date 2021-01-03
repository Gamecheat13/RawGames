#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

#using scripts\shared\ai\archetype_warlord_interface;

#using scripts\cp\cp_mi_sing_biodomes_fighttothedome;
#using scripts\cp\cp_mi_sing_biodomes_warehouse;
#using scripts\cp\cp_mi_sing_biodomes_util;

#using scripts\shared\ai\robot_phalanx;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	           	              	           	                                                                                                                                                                                                                                                                                             

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_dialog;
#using scripts\cp\_hacking;
#using scripts\cp\_laststand;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_squad_control;
#using scripts\cp\_cic_turret;
#using scripts\cp\_pallas_turret;
#using scripts\cp\_objectives; 

    	   	                                                                                                                                                                                                                                                                                                                                                                                                                                               




 //should match the number of cases in cp_mi_sing_biodomes.csc server_interact_cam()

#precache( "string", "CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_OPENING_DOOR" );
#precache( "triggerstring", "CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_ACCESS_TERMINAL" );
#precache( "string", "CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_CUTTING_HAND" );
#precache( "triggerstring", "CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_CUT_THAT_HAND" );
#precache( "string", "CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_HENDRICKS_WAS_KILLED" );
#precache( "triggerstring" , "CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_CYCLE_CAM" );
//#precache( "objective", "cp_level_biodomes_defend_server_room" ); 
//#precache( "objective", "cp_level_biodomes_find_xiulan" );
//#precache( "objective", "cp_level_biodomes_find_xiulan_waypoint" );

function cloudmountain_main()
{
	level thread cloudmountain_breadcrumbs();
	level thread cloudmountain_elevators();
	level thread catwalk_supertree_spawns();
		
	level thread spawn_phalanx( "phalanx1" , "phanalx_wedge" , 3 );
	level thread spawn_phalanx( "phalanx2" , "phalanx_diagonal_right" , 2 );
	level thread spawn_phalanx( "phalanx3" , "phalanx_diagonal_left" , 2 );
	level thread phalanx_shot_at_check();
	level thread phalanx_scatter_check();
	level thread cloud_mountain_reinforcements();
	
	spawner::add_spawn_function_group( "rambo" , "script_noteworthy" , &rambo_robots );
	spawner::add_spawn_function_group( "rusher" , "script_noteworthy" , &rusher_robots );
	spawner::add_spawn_function_group( "ledge_robot" , "script_noteworthy" , &gib_ledge_robot );
	spawner::add_spawn_function_group( "hunter_flybys", "script_noteworthy", &hunter_flyby_cloud_mountain );
	spawner::add_spawn_function_group( "cloud_mountain_reinforcements", "script_noteworthy", &cloud_mountain_reinforcements_spawn );
	spawner::add_spawn_function_group( "cloud_mountain_retreaters", "script_noteworthy", &cloud_mountain_retreaters_spawn );
	spawner::add_spawn_function_group( "level_3_surprised_enemies", "script_noteworthy", &cloud_mountain_level_3_surprised );
	spawner::add_spawn_function_group( "pod_spawners", "script_noteworthy", &robot_pod_spawn );
	
	level.ai_hendricks colors::enable();
	level.ai_hendricks.goalradius = 400;
	
	nd_hendricks = GetNode( "hendricks_cloudmountain" , "targetname" );
	level.ai_hendricks notify( "stop_following" );
	
	level.ai_hendricks SetGoal( nd_hendricks, true );

	level thread cp_mi_sing_biodomes_warehouse::glass_break( "trig_cloudmountain_glass1" );
	level thread cp_mi_sing_biodomes_warehouse::glass_break( "trig_cloudmountain_glass2" );
	level thread cp_mi_sing_biodomes_warehouse::glass_break( "trig_cloudmountain_glass3" );
	
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "warehouse_left_group1_ai" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "warehouse_right_group1_ai" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "warehouse_right_group2_ai" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "warehouse_back_door_group_ai" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "warehouse_enemy_group3_ai" );
	
	catwalk_goal_control();
	
	level thread vo_cloud_mountain_intro();
	
	level thread exhibit_audio( "A" );
	level thread exhibit_audio( "B" );
	level thread exhibit_audio( "C" );
	level thread exhibit_audio( "D" );
	level thread exhibit_audio( "E" );
	
	trigger::wait_till( "trig_turret_hallway_enemy_spawns" );
	skipto::objective_completed( "objective_cloudmountain" );
}

function vo_cloud_mountain_intro()
{
	level dialog::remote( "kane_server_room_s_locate_0" ); //Server room’s located on the top floor.
	
	level.ai_hendricks dialog::say( "hend_guess_we_re_going_up_0" ); //"Guess we’re going up...(beat) Spread out."
	
	level dialog::remote( "kane_hostiles_moving_on_y_0" ); //Hostiles moving on your position.
	
	trigger::wait_till( "level_2_catwalk_spawns" );
	
	level dialog::player_say( "plyr_third_floor_where_n_0" ); //Okay. Where now, Kane?
	
	level dialog::remote( "kane_server_room_directly_0" ); //Server Room directly above.
	
	level dialog::remote( "kane_you_need_to_hustle_0", 5 ); //You need to hustle - we’ve got Xiulan cornered - she’ll use the only bargaining chip she has - the information on those data drives.
}

function precache()
{
	// DO ALL PRECACHING HERE
}

//Cloud mountain
function objective_cloudmountain_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_cloudmountain_init" );
	
	objectives::set( "cp_level_biodomes_servers" );
	
	if ( b_starting )
	{
		cp_mi_sing_biodomes_util::init_hendricks( str_objective );
		level flag::set( "back_door_opened" );
		GetEnt( "back_door_collision", "targetname" ) Delete();
	}
	
	level thread cloudmountain_main();
}

function objective_cloudmountain_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_cloudmountain_done" );
	
	e_window = GetEnt( "server_window" , "targetname" );
	e_window DisconnectPaths();
	
	GetEnt( "window_dmg_1" , "targetname" ) hide();
	GetEnt( "window_dmg_2" , "targetname" ) hide();
}

//============================================================
// co-op gameplay options

function on_player_spawned()
{
	
}

function exhibit_audio( str_ident )
{
	level endon( "turret_hallway_clear" );
	
	t_exhibit = GetEnt( "trig_exhibit_" + str_ident , "targetname" );
	
	while ( true )
	{
		t_exhibit trigger::wait_till();
		
		switch ( str_ident )
		{
			case "A" :
				t_exhibit dialog::say( "Welcome to the Cloud Forest wildlife exhibit. Please take a moment to read the rules of conduct." , 0 , true );
				break;
				
			case "B" :
				t_exhibit dialog::say( "Hundreds of different animal species make their home among the flora of Cloud Forests across Southeast Asia." , 0 , true );
				break;
			
			case "C" :
				t_exhibit dialog::say( "Amphibians such as this Spotted Tree Frog are particularly well suited to the unique climate found here." , 0 , true );
				break;
				
			case "D" :
				t_exhibit dialog::say( "Tree Shrews are descended from one of the earliest known mammals on earth. They forage in the dense undergrowth at all hours of the day." , 0 , true );
				break;
				
			case "E" :
				t_exhibit dialog::say( "Up ahead is the overlook and elevator access to the Cloud Walk. Watch your step! Walkways are slippery when wet." , 0 , true );
				break;
		}
		
		wait 15; //don't trigger audio again for a while after it finishes playing
	}
}

function rambo_robots() //self = ai, run as spawn func
{
	self ai::set_behavior_attribute( "move_mode", "rambo" );
}

//self = ai
function rusher_robots()
{
	self ai::set_behavior_attribute( "move_mode", "rusher" );
}

function catwalk_supertree_spawns()
{
	trigger::wait_till( "level_2_catwalk_spawns" , "targetname" );
	
	e_door = GetEnt( "dome_side_door" , "targetname" );
	
	e_door ConnectPaths();
	
	e_door MoveZ( 100 , 2 );
	
	e_door waittill( "movedone" );
	
	level flag::wait_till( "supertree_door_close" ); //set on trigger in radiant when no AI are within it
	
	e_door MoveZ( -100 , 2 );
}

function spawn_phalanx( str_phalanx , type , num )
{	
	level endon( "phalanx_done" );
	
	if ( level.players.size == 1 )
	{
		num -= 1;
	}
	
	v_start = struct::get( str_phalanx + "_start" ).origin;
	v_end = struct::get( str_phalanx + "_end" ).origin;
	v_smoke = struct::get( "phalanx_smoke" ).origin;
	
	//hide the robot entrance
	level fx::play( "smoke_grenade" , v_smoke );
	
	phalanx = new RobotPhalanx();
	[[ phalanx ]]->Initialize( type, v_start, v_end, 1 , num );
	
	phalanx robotphalanx::HaltFire();
	
	level flag::wait_till( "phalanx_stop" ); //set on triggers in radiant
	
	phalanx robotphalanx::HaltAdvance();
	
	level flag::wait_till( "phalanx_go" ); //set on triggers in radiant
	
	phalanx robotphalanx::ResumeAdvance();
	
	wait 1; //wait a moment for phalanx to stand up and get moving before letting them fire
	
	e_clip = GetEnt( "phalanx_sight_clip" , "targetname" ); //this clip prevents allied AI from firing at the phalanx too early
	
	if ( isdefined( e_clip ) )
	{
		e_clip Delete();
	}
	
	phalanx robotphalanx::ResumeFire();
	
	while ( isdefined( phalanx ) && phalanx.scattered_ == false )
	{
		wait .25;
	}

	level notify( "phalanx_scattered" );
}	

function phalanx_scatter_check()
{
	i = 0;
	
	while ( i < 3 )
	{
		level waittill( "phalanx_scattered" );
		i++;
	}
	
	t_spawns = GetEnt( "trig_level_1_spawns" , "targetname" );
	
	if ( isdefined( t_spawns ) )
	{
		t_spawns trigger::use();
		level notify( "phalanx_done" );
	}
}

function phalanx_shot_at_check()
{
	trigger::wait_till( "trig_phalanx_shot_at" , "targetname" ); //this is a damage trigger which doesn't have the nice flag functionality
	level flag::set( "phalanx_go" );
}

//self is the robot that gets thrown off by hendricks in cin_bio_07_02_climb_vign_throw
function gib_ledge_robot()
{
	self endon( "death" );
	
	self waittill( "break_apart" );
	
	self thread ai::set_behavior_attribute( "force_crawler", "gib_legs" );
}

//self is a hunter
function hunter_flyby_cloud_mountain()
{
	self endon( "death" );
	
	self ai::set_ignoreme( true );
	
	nd_start = GetVehicleNode( self.target, "targetname" );
	
	if ( isdefined( nd_start ) )
	{
		//spawn support wasps for hunter, associated with hunter
		a_wasps = spawner::simple_spawn( self.script_string );
		foreach ( wasp in a_wasps )
		{
			wasp ai::set_ignoreme( true );
			wasp LinkTo( self );
		}
		
		self vehicle_ai::start_scripted();
		self vehicle::get_on_and_go_path( nd_start );
		self util::waittill_notify_or_timeout( "reached_end_node", 45 );
		
		foreach ( wasp in a_wasps )
		{
			if ( IsAlive( wasp ) )
			{
				wasp Delete();
			}
		}
		
		self cp_mi_sing_biodomes_util::wait_to_delete( 300 );
	}
}

//self is an AI
function cloud_mountain_reinforcements_spawn()
{
	self endon( "death" );
	
	//delete any previously left over guys once player has gotten to the last set of spawns
	trigger::wait_till( "trig_level_3_catwalk_wasp_spawns" );
	
	self cp_mi_sing_biodomes_util::wait_to_delete( 500 );
}

//self is an AI
function cloud_mountain_retreaters_spawn()
{
	self endon( "death" );
	
	nd_goal = GetNode( self.target, "targetname" );
	
	if ( isdefined( nd_goal ) )
	{
		self SetGoal( nd_goal, true );
		self waittill( "goal" );		
	}
	
	self Delete();
}

//self is an AI
function cloud_mountain_level_3_surprised()
{
	self endon( "death" );
	
	//start off in idle
	self.goalradius = 4;
	self ai::set_ignoreall( true );
	
	//wait until player hits trigger nearby
	trigger::wait_till( "trig_lookat_level_3_surprised" );
	
	//AI plays a reaction animation and runs to goal
	wait RandomFloatRange( 0.25, 1 );
	
	self scene::play( "cin_gen_vign_confusion_02", self );
	
	t_goal = GetEnt( "trig_level_3_catwalks_goal", "targetname" );
	
	if( isdefined( t_goal ) )
	{
		self SetGoal( t_goal );
		self waittill( "goal" );
	}
	
	self ai::set_ignoreall( false );
	self.goalradius = 1024;
}

//self is an AI that is meant to spawn from inside of a robot pod
//AI spawner needs to target a script_model p7_fxanim_cp_sgen_charging_station_doors_break_mod
//have a script_string of look_right or look_left, and a script_noteworthy of pod_spawners
function robot_pod_spawn()
{
	self endon( "death" );
	
	self thread cleanup_pod_robots();
	
	e_pod = GetEnt( self.target, "targetname" );
	
	e_pod thread scene::init( "p7_fxanim_cp_sgen_charging_station_break_02_bundle", e_pod );
	
	//immediately put robot into the pod pose, 01-03 looks to the right, 04-06 looks to the left
	str_scene = "cin_sgen_16_01_charging_station_aie_awaken_robot01";
	if ( self.script_string === "look_right" )
	{
		str_scene = "cin_sgen_16_01_charging_station_aie_awaken_robot0" + RandomIntRange( 1, 4 );
	}
	else
	{
		str_scene = "cin_sgen_16_01_charging_station_aie_awaken_robot0" + RandomIntRange( 4, 7 );
	}
	
	self thread scene::init( str_scene, self );
	
	//wait for any player to see me
	while ( true )
	{
		b_player_sees_me = false;
		
		foreach( player in level.players )
		{
			n_distance_sq = Distance2DSquared( self.origin, player.origin );
			
			if( ( player util::is_player_looking_at( self.origin ) && n_distance_sq < 600 * 600) || n_distance_sq < 300 * 300 )
			{
				b_player_sees_me = true;
				break;
			}
		}
		
		if ( b_player_sees_me )
		{
			break;
		}
		
		wait 0.05;
	}
	
	//break pod, and play animation of robot stepping out
	self thread scene::play( str_scene, self );
	self waittill( "breakglass" );
	e_pod thread scene::play( "p7_fxanim_cp_sgen_charging_station_break_02_bundle", e_pod );
	
	//move to goal
	nd_best = self FindBestCoverNode();
	
	if ( isdefined( nd_best ) )
	{
		self SetGoal( nd_best );
	}
}

//self is an AI
function cleanup_pod_robots()
{
	self endon( "death" );
	
	level waittill( "cleanup_pod_robots" );
	
	self Delete();
}

function cloudmountain_elevators()
{
	trigger::wait_till( "trig_cloudmountain_elevators" );
	
	spawner::simple_spawn( "cloudmountain_elevator_enemy" , &elevator_spawning , "cloudmountain" );
}

function cloudmountain_breadcrumbs()
{
	objectives::set( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_cloudmountain01" ) );
	objectives::complete( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_warehouse" ) );
	
	trigger::wait_till( "trig_level_2_enemy_spawns_1" );
	objectives::set( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_cloudmountain02" ) );
	objectives::complete( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_cloudmountain01" ) );	

	trigger::wait_till( "trig_breadcrumb_cloudmountain_03" );
	objectives::set( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_cloudmountain03" ) );
	objectives::complete( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_cloudmountain02" ) );		
	
	trigger::wait_till( "trig_breadcrumb_cloudmountain_end" );
	objectives::set( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_cloudmountain_end" ) );
	objectives::complete( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_cloudmountain03" ) );	
}

function catwalk_goal_control() //sets all catwalk spawners to a lower goal radius so they don't try to reach nodes off the catwalk
{
	a_catwalk_spawners = GetSpawnerArray( "catwalk" , "script_noteworthy" );
	
	for ( i = 0; i < a_catwalk_spawners.size; i++ )
	{
		a_catwalk_spawners[i] spawner::add_spawn_function( &catwalk_goal_radius );
	}
}

function catwalk_goal_radius()
{
	self.goalradius = 400;
}

function disable_cloudmountain_triggers()
{
	a_spawn_triggers = GetEntArray( "cloudmountain_spawn_trigger" , "script_noteworthy" );
	
	foreach ( trigger in a_spawn_triggers )
	{
		trigger Delete(); //cleanup cloudmountain spawn triggers
	}
}

function cloud_mountain_reinforcements()
{
	trigger::wait_till( "trig_cloud_mountain_reinforcements" );
	
	if ( !level flag::get( "back_door_opened" ) )
	{
		cp_mi_sing_biodomes_warehouse::warehouse_door_open();
	}
	
	spawn_manager::enable( "sm_cloud_mountain_reinforcements" );
	spawn_manager::enable( "sm_cloud_mountain_reinforcements_wasps" );
	spawn_manager::enable( "sm_cloud_mountain_retreaters" );
	
	wait 3; //let previous enemies fill in a bit before hunter starts flying in background
	
	spawner::simple_spawn_single( "sp_hunter_cloud_mountain_flyby3" );
}

//============================================================================================================
// Turret Hallway
//============================================================================================================
function objective_turret_hallway_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "turret_hallway_init" );

	objectives::complete( "cp_level_biodomes_cloud_mountain_waypoint" , struct::get( "breadcrumb_cloudmountain_end" ) );
	
	if ( b_starting )
	{
		cp_mi_sing_biodomes_util::init_hendricks( str_objective );
		
		level.ai_hendricks notify( "stop_following" );
		level.ai_hendricks colors::enable();
		
		disable_cloudmountain_triggers();
	}
	
	level thread turret_hallway_phalanx();
	level thread turret_hallway_lights();
	level thread turret_hallway_keyline();
	//level thread cp_mi_sing_biodomes::add_turret_hallway_action();
	
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "level_1_enemy_spawns_ai" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "level_2_robot_spawns_ai" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "level_2_enemy_spawns_1_ai" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "level_2_enemy_spawns_2_ai" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "level_2_enemy_spawns_3_ai" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "level_2_catwalk_spawns_ai" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "level_3_enemy_spawns_ai" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "level_3_catwalk_spawns_ai" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( "level_3_catwalk_reinforcements_ai" );
	
	if ( level.a_ai_squad.size > 0 )
	{
		level thread squad_control_final_orders();
	}
	else
	{
		level dialog::remote( "kane_take_cover_0", 3 ); //We sure could have used those bots right now - You gotta find cover!
		level.ai_hendricks thread dialog::say( "hend_thanks_for_the_updat_0" ); //Thanks for the update, Kane.
	}
		
	spawner::waittill_ai_group_cleared( "hallway_turret_group" );
	
	level flag::set( "turret_hall_clear" );
	
	foreach ( player in level.players )
	{
		if ( player laststand::player_is_in_laststand() )
		{
			player laststand::auto_revive( player, false );
		}
	}
	
	skipto::objective_completed( "objective_turret_hallway" );
}

function turret_hallway_phalanx()
{
	level flag::wait_till( "turret_hallway_phalanx" ); //flag set on trigger in radiant
	
	v_start = struct::get( "turret_hallway_phalanx_start" ).origin;
	v_end = struct::get( "turret_hallway_phalanx_end" ).origin;
	
	n_phalanx = 2;
	
	//bump up phalanx size back to "normal" if any robots are available
	if ( level.a_ai_squad.size > 0 )
	{
		n_phalanx = 3;
	}
	
	phalanx = new RobotPhalanx();
	[[ phalanx ]]->Initialize( "phalanx_diagonal_left", v_start, v_end, 1 , n_phalanx );
}

function turret_hallway_lights() //scripting for light exploder handled here
{
	exploder::exploder( "turret_light" );
	
	trigger::wait_till( "trig_turret_lights_damaged" , "targetname" );
	
	exploder::kill_exploder( "turret_light" );
	
	exploder::exploder( "fx_turrethallway_turret_smk" );
	
	scene::play( "p7_fxanim_gp_floodlight_01_bundle" );
}

function objective_turret_hallway_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "turret_hallway_done" );
	
	GetEnt( "trig_turret_hallway_enemy_spawns" , "targetname" ) Delete();
	GetEnt( "trig_turret_hallway_defender_spawns" , "targetname" ) Delete();
}

//============================================================================================================
// Xiulan Vignette
//============================================================================================================
function objective_xiulan_vignette_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "xiulan_vignette_init" );
	
	cp_mi_sing_biodomes_util::enable_traversals( false , "server_room_window_mantle" , "script_noteworthy" ); //disables traversals through the server room window
	
	if ( b_starting )
	{
		cp_mi_sing_biodomes_util::init_hendricks( str_objective );
		
		disable_cloudmountain_triggers();
	}
	
	level.ai_hendricks colors::disable();
	
	//Get Hendricks into position for next scene after console is hacked
	level thread scene::init( "scene_server_chase", "targetname" );
	
	level thread setup_server_room_door_use_object();
	
	level thread server_room_crack_big_window();
	
	level thread vo_xiulan_intro();
}

function vo_xiulan_intro()
{
	level.ai_hendricks dialog::say( "hend_eyes_on_goh_xiulan_0" ); //Eyes on Goh Xiulan -- she’s already inside.
	
	level dialog::remote( "kane_shit_she_s_uploadi_0" ); //We have a problem - She’s uploading the information on the data drives - once that intel is out, it won’t be long before it reaches the CDP.
	
	level dialog::remote( "kane_interface_with_that_0" ); //Interface with that panel. We need to shut her down - now!
}

function squad_control_final_orders() //called in turret hallway init
{
	trigger::wait_till( "trig_turret_hallway_defender_spawns" , "targetname" );
	
	foreach( player in level.players )
	{
		player notify( "end_squad_control" );  //this is the end for squad control
	}	
	
	for ( i = 0; i < level.a_ai_squad.size; i++ )
	{
		level.a_ai_squad[i] util::stop_magic_bullet_shield();
		level.a_ai_squad[i] ai::set_behavior_attribute( "move_mode" , "normal" );
		level.a_ai_squad[i] ai::set_behavior_attribute( "sprint", true );
		level.a_ai_squad[i] SetGoal( GetEnt( "staging_area" , "targetname" ) );
		level.a_ai_squad[i] thread robot_suicide();
	}
}

function robot_suicide() //self=squad control robot
{
	self endon( "death" );
	
	level flag::wait_till( "turret_hall_clear" );
	
	wait RandomFloatRange( 0.5, 1.5 ); //don't have them die all at once
	
	//TODO add special animation of robot deactivation?
	self Kill();
}

function look_down_hallway() //self = robot ai from squad
{
	self endon( "death" );
	self waittill( "goal" );

	v_look = struct::get( "hallway_look_target" ).origin;
	
	self orientmode( "face direction" , self.origin - v_look );
	
	self waittill( "enemy" );
	self orientmode( "face enemy" );
}

function server_room_vignette()
{
	level notify( "cleanup_pod_robots" );
	
	t_hand = GetEnt( "trig_cut_hand" , "targetname" );
	t_hand TriggerEnable( false );
	
	//GetEnt( "xiulan" , "targetname" ) spawner::add_spawn_function( &xiulan_init );

	level thread scene::play( "scene_server_chase", "targetname" );
	
	//objectives::complete( "cp_level_biodomes_find_xiulan" );
	//objectives::complete( "cp_level_biodomes_find_xiulan_waypoint" , struct::get( "breadcrumb_server_room" ) );	

	level waittill( "xiulan_subdued_notetrack" ); //notetrack set in ch_bio_09_01_accessdrives_vign_slam_callover_hendricks.xanim
	
	level thread setup_hand_use_object();
	
	t_hand TriggerEnable( true );
	t_hand waittill( "trigger", player );
	
	level scene::stop( "scene_server_chase", "targetname" );
	
	level thread scene::play( "scene_hand_cut_player", "targetname", player );
	level thread scene::play( "scene_hand_cut_xiulan", "targetname" );
	level scene::play( "scene_hand_cut", "targetname" );
	level scene::play( "cin_bio_09_02_accessdrives_1st_sever_end_loop" );
}

function xiulan_init()
{
	self.ignoreme = true; //so allied AI doesn't attack her during vignettes
}

function setup_server_room_door_use_object()
{
	v_offset = ( 0, 0, 0 );
	t_door_use_object = GetEnt( "trig_server_room_door_use_object" , "targetname" );
	t_door_use_object SetCursorHint( "HINT_NOICON" );
	t_door_use_object Show();
	t_door_use_object thread hacking::init_hack_trigger( 3 );
	
	visuals_door_use_object[0] = spawn( "script_model", t_door_use_object.origin );
	
	e_door_use_object = gameobjects::create_use_object( "allies" , t_door_use_object , visuals_door_use_object , v_offset , undefined );
	
	//TODO can be updated/removed whenever new HUD icon stuff is finshed
	// Setup use object params
	//e_door_use_object gameobjects::allow_use( "any" );
	//e_door_use_object gameobjects::set_use_time( 2.0 );
	//e_door_use_object gameobjects::set_use_text( &"CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_OPENING_DOOR" );
	e_door_use_object gameobjects::set_use_hint_text( &"CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_ACCESS_TERMINAL" );
	e_door_use_object gameobjects::set_visible_team( "any" );
	e_door_use_object gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_hack_64" );	
	
	player = t_door_use_object hacking::trigger_wait();
	
	PlaySoundAtPosition ("evt_hack_panel", ( 1119, 13712, 1116 ));
	
	e_door_use_object gameobjects::disable_object();
	
	e_server_room_door = GetEnt( "server_room_door_clip" , "targetname" );
	e_server_room_door playsound ("evt_hack_door_open");
	e_server_room_door playloopsound ("evt_hack_door_loop");	
	
	level thread scene::play( "scene_player_hack", "targetname", player ); 
	
	level waittill( "start_slam" );  //notetrack set in pb_bio_09_01_accessdrives_1st_slam_player.xanim
	
	level thread server_room_vignette(); //starts the scene of hendricks chasing xiulan
	
	level waittill( "door_anim_done" ); //notetrack set in o_bio_09_01_accessdrives_vign_slam_intro_door.xanim

	
	e_server_room_door stoploopsound (.5);
	e_server_room_door playsound ("evt_hack_door_end");	
	
	e_server_room_door ConnectPaths();
	e_server_room_door Delete();	
	
	GetEnt( "server_room_door" , "targetname" ) Hide();
}

function server_room_door_open( team, player, success )  //self = gameobject
{
	if ( ( isdefined( success ) && success ) )
	{
		self gameobjects::disable_object();
		
		level thread server_room_vignette();
		
//		foreach ( player in level.players )
//		{
//			player clientfield::set_to_player( "server_extra_cam", 1 );
//		}
		
		e_server_room_door = GetEnt( "server_room_door" , "targetname" );
		e_server_room_door MoveZ( 100, 2 );
		e_server_room_door ConnectPaths();
		
		e_server_room_door waittill( "movedone" );
		e_server_room_door Delete();
	}
}

function setup_hand_use_object()
{
	v_offset = ( 0, 0, 0 );
	t_hand = GetEnt( "trig_cut_hand" , "targetname" );
	t_hand SetCursorHint( "HINT_NOICON" );
	
	visuals_hand[0] = struct::get( "server_room_xiulan" , "targetname" );
	
	e_hand = gameobjects::create_use_object( "allies" , t_hand , visuals_hand , v_offset , undefined );
	
	// Setup use object params
	e_hand gameobjects::allow_use( "any" );
	e_hand gameobjects::set_use_time( 0.05 );						
	e_hand gameobjects::set_use_text( &"CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_CUTTING_HAND" );
	e_hand gameobjects::set_use_hint_text( &"CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_CUT_THAT_HAND" );
	e_hand gameobjects::set_visible_team( "any" );
	e_hand gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_push_64" );
	
	// Setup use object callbacks
	e_hand.onEndUse = &hand_cut_done;		
}

function hand_cut_done( team, player, success )
{
	self gameobjects::disable_object();
	
	level flag::set( "hand_cut" );
	
	//TODO move this to when Hendricks actually walks over in the scene
	level thread hendricks_server_control_room_door_open( true );
	
	level waittill( "hand_cut_notetrack" );
	
	wait 1; //brief pause for pacing
	
	skipto::objective_completed( "objective_xiulan_vignette" );
}

//opens closes server room door that Hendricks goes into
function hendricks_server_control_room_door_open( b_open )
{
	e_server_control_room_door = GetEnt( "server_control_room_door", "targetname" );
	
	if ( b_open )
	{
		e_server_control_room_door MoveY( 50, 0.5 );
	}
	else
	{
		e_server_control_room_door MoveY( -50, 0.5 );
	}
}

function objective_xiulan_vignette_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "xiulan_vignette_done" );
	
	objectives::complete( "cp_level_biodomes_servers" );
	
	e_server_room_door = GetEnt( "server_room_door" , "targetname" );
	if ( isdefined( e_server_room_door ) )
	{
		e_server_room_door ConnectPaths();
		e_server_room_door Delete();
	}
	
	e_server_room_door_clip = GetEnt( "server_room_door_clip" , "targetname" );
	if ( isdefined( e_server_room_door_clip ) )
	{
		e_server_room_door_clip ConnectPaths();
		e_server_room_door_clip Delete();
	}	
	
	GetEnt( "trig_server_room_door_use_object" , "targetname" ) Delete();
	GetEnt( "trig_cut_hand" , "targetname" ) Delete();
}

//============================================================================================================
// Server Room Defend
//============================================================================================================

function objective_server_room_defend_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "server_room_defend_init" );
	
	GetEnt( "server_koolaid" , "targetname" ) DisconnectPaths();
	
	if ( b_starting )
	{
		cp_mi_sing_biodomes_util::init_hendricks( str_objective );
		
		disable_cloudmountain_triggers();
		level hendricks_server_control_room_door_open( true );
		level thread server_room_crack_big_window();
		
		level flag::wait_till( "all_players_spawned" );
	}
	
	objectives::set( "cp_level_biodomes_repel", level.ai_hendricks );
	
	level thread hendricks_works_the_computer(); //TODO This should be moved into the if statement above, once the scene animation puts hendricks in the right place
	
	//objectives::set( "cp_level_biodomes_defend_server_room", level.ai_hendricks );
	
	level thread vo_server_room_intro();
	
	level thread track_window_damage();
	level thread server_room_failure_check();
	level thread top_floor_flag();
	level.ai_hendricks thread server_room_hendricks_dies();
	
	server_room_spawning(); //handles the whole combat event
	
	//automatically revive any players that were in last stand, since defend event is over now
	foreach ( player in level.players )
	{
		if ( player laststand::player_is_in_laststand() )
		{
			player laststand::auto_revive( player, false );
		}
	}
	
	skipto::objective_completed( "objective_server_room_defend" );
	
	GetEnt( "trig_interact_cam1" , "targetname" ) Delete();
	GetEnt( "trig_interact_cam2" , "targetname" ) Delete();
}

function vo_server_room_intro()
{	
	level dialog::remote( "kane_okay_hendricks_in_0" ); //Okay - Hendricks, interface with the console - The information on the data drives is heavily encrypted - I need to use your brain to act as a conduit.
	
	level.ai_hendricks dialog::say( "hend_say_what_0" ); //Say what??
	
	level dialog::remote( "kane_trust_me_okay_we_n_0" ); //"Trust me, okay? We need to stop that upload and extract everything from those drives...(beat) The quickest way is for your brain to process it via your DNI."
	
	level.ai_hendricks dialog::say( "hend_you_d_better_be_righ_0" ); //You’d better not mess up my brain - Kane.
	
	level dialog::remote( "kane_i_am_but_hendrick_0", 1 ); //"I won't (beat) You may not like what you see..."
	
}

//============================================================================================================
// Server Room Failure Thread (if players leave server room area)
//============================================================================================================
function server_room_failure_check()
{
	level endon( "server_defend_done" );
	
	t_server_room = GetEnt( "trig_server_room" , "targetname" );

	while ( isdefined( level.ai_hendricks) )
	{	
		if ( isdefined( level.ai_hendricks.attacker) && ( util::any_player_is_touching( t_server_room , "allies" ) == false ) )
		{
			/# IPrintLnBold( "HENDRICKS NEEDS YOUR HELP!" ); #/ //this should be a VO line from Hendricks	
			wait 5;
		
			if ( isdefined( level.ai_hendricks.attacker) && ( util::any_player_is_touching( t_server_room , "allies" ) == false ) )
			{
				level dialog::player_say( "plyr_hendricks_you_okay_1" ); //Hendricks! You okay?

				/# IPrintLnBold( "NO SERIOUSLY, GO HELP HENDRICKS!" ); #/ //this should be a VO line from Hendricks
				wait 5;
				
				if ( isdefined( level.ai_hendricks.attacker) && ( util::any_player_is_touching( t_server_room , "allies" ) == false ) )
				{
					level notify( "server_room_fail" );

					/# IPrintLnBold( &"CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_HENDRICKS_WAS_KILLED" ); #/
					wait 2; //wait so above text can be seen	
				
					util::missionfailedwrapper_nodeath( &"CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_HENDRICKS_WAS_KILLED" ); //TODO: fail hint not appearing for some reason.
				}
			}
		}
		wait 1;
	}
}

//self is hendricks, thread accounts for situations where Hendricks can actually die due to magic bullet shield being turned off in track_window_damage()
function server_room_hendricks_dies()
{
	level endon( "server_defend_done" );
	
	self waittill( "death" );
	
	level notify( "server_room_fail" );
	
/# 
	util::screen_fade_out( 2 );
	util::screen_message_create( &"CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_HENDRICKS_WAS_KILLED" );
	util::screen_message_delete( 2 ); 
#/
	//TODO: below fail hint not appearing for some reason.	Above script is placeholder.
	util::missionfailedwrapper_nodeath( &"CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_HENDRICKS_WAS_KILLED" ); 
}

function camera_feed( str_cam )  //valid entries for str_cam are "hallway", "hendricks", "window", "vtol", "top_floor"
{
	switch ( str_cam ) 
	{
	case "start": 
		foreach ( player in level.players )
		{
			player clientfield::set_to_player( "server_extra_cam", 1 );
		}
		break;	
	
	case "hallway": 
		foreach ( player in level.players )
		{
			player clientfield::set_to_player( "server_extra_cam", 2 );
		}
		break;
		
	case "window": 
		foreach ( player in level.players )
		{
			player clientfield::set_to_player( "server_extra_cam", 3 );
		}
		break;
		
	case "top_floor": 
		foreach ( player in level.players )
		{
			player clientfield::set_to_player( "server_extra_cam", 4 );
		}
		break;	
		
	case "vtol":
		foreach ( player in level.players )
		{
			player clientfield::set_to_player( "server_extra_cam", 5 );
		}
		break;		
	}
}

function setup_interact_cam( n_trigger ) //called during beginning of server_room_spawning
{
	v_offset = ( 0, 0, 0 );
	
	t_interact = GetEnt( "trig_interact_cam" + n_trigger , "targetname" );
	t_interact SetCursorHint( "HINT_NOICON" );
	t_interact Show();
	
	visuals_interact[0] = t_interact;
	
	e_interact = gameobjects::create_use_object( "allies" , t_interact , visuals_interact , v_offset , undefined );
	
	// Setup use object params
	e_interact gameobjects::allow_use( "any" );
	e_interact gameobjects::set_use_time( 0.05 );						
	e_interact gameobjects::set_use_hint_text( &"CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_CYCLE_CAM" );
	e_interact gameobjects::set_visible_team( "any" );
	
	// Setup use object callbacks
	e_interact.onEndUse = &use_interact_cam;	

	level thread interact_cam_control();
}

function use_interact_cam( team, player, success )
{
	level notify( "cycle_cam" );
}

function interact_cam_control()
{
	level endon( "server_defend_done" );
	
	n_cam_state = 0;
	
	while ( true )
	{
		foreach ( player in level.players )
		{
			player clientfield::set_to_player( "server_interact_cam", n_cam_state );
		}
	
		level waittill( "cycle_cam" );
		
		if ( n_cam_state >= 4 )
		{
			n_cam_state = 0;
		}
		else
		{
			n_cam_state += 1;
		}
	}
}

function server_room_crack_big_window()
{
	level endon( "stop_cracked_window" );
	
	trigger::wait_till( "trig_big_window_damage" ); //swap in the cracked window after AI has shot at it for a bit
	
	GetEnt( "big_window_dmg_1", "targetname" ) Show();
	GetEnt( "big_window_pristine", "targetname" ) Delete();
}

function server_room_spawning()
{
	level.a_window_targets = [];
	level.a_window_targets[0] = GetEnt( "server_room_window_target0" , "targetname" );
	level.a_window_targets[1] = GetEnt( "server_room_window_target1" , "targetname" );
	level.a_window_targets[2] = GetEnt( "server_room_window_target2" , "targetname" );
	level.a_window_targets[3] = GetEnt( "server_room_window_target3" , "targetname" );
	
	a_nodes = GetNodeArray( "swat_node" , "script_noteworthy" );
	
	foreach ( node in a_nodes )
	{
		SetEnableNode( node , false );
	}
	
	spawner::add_spawn_function_group( "window_shooter" , "script_noteworthy" , &shoot_at_window );
	spawner::add_spawn_function_group( "server_room_enemy_elevator1" , "targetname" , &elevator_spawning , "server_room" );
	spawner::add_spawn_function_group( "server_room_enemy_elevator2" , "targetname" , &elevator_backup , "server_room" );
	spawner::add_spawn_function_group( "server_room_enemy_swat1" , "targetname" , &swat_team_ai );
	
	/# IPrintLnBold( "Data Drive transfer initiated." ); #/
	
	level dialog::remote( "kane_i_m_syncing_your_hud_0" ); //I’m syncing your HUD with the security system. You’ll be able to assess incoming threats.
	
	level thread camera_feed( "start" );
	level thread setup_interact_cam( 1 );
	level thread setup_interact_cam( 2 );
	level thread setup_interact_cam( 3 );
		
	wait 2; //pause for pacing
	
	//START window attack ==============================================================================
	spawner::simple_spawn( "server_room_enemy_window" ); //spawns 4 AI
	
	if ( level.players.size > 1)
	{
		spawner::simple_spawn( "server_room_enemy_window_add" ); //spawns 1 AI
	}
	
	if ( level.players.size > 3)
	{
		spawner::simple_spawn( "server_room_enemy_window_add" ); //spawns 1 AI
	}
	//=================================================================================================
	
	level.ai_hendricks dialog::say( "I'm seeing movement outside." );
	level.ai_hendricks thread dialog::say( "Here's the camera feed, keep an eye on them." );
	
	level thread camera_feed( "window" );
	
	//WAVE 1 - Top Floor===============================================================================
	spawner::simple_spawn( "server_room_enemy_top_floor" , &top_floor_door ); //spawns 2 AI

	level util::waittill_notify_or_timeout( "top_floor_breached" , 10 );
	
	spawner::simple_spawn( "server_room_enemy_top_floor_wave2" , &top_floor_door ); //spawns 2 AI
	//=================================================================================================
	
	if ( level flag::get( "top_floor_breached" ) )
	{
		level thread camera_feed( "top_floor" );
		
		level.ai_hendricks notify( "cancel speaking" );
		
		wait 0.05; //need this for cancel speaking to work
		
		level.ai_hendricks thread dialog::say( "Shit, nevermind - got a breach upstairs!" );
	}
	
	if ( level.players.size < 3 )
	{
		wave_wait( 0 , 45 , "top_floor" );
	}
	else
	{
		wave_wait( 2 , 10 , "top_floor" );
	}
	
	/# IPrintLnBold( "Data Drive transfer 20 percent complete." ); #/
		
	//spawn in some background enemies
	spawn_manager::enable( "sm_server_room_background" );
	
	//WAVE 2 - VTOL====================================================================================	
	spawner::simple_spawn( "server_room_vtol" , &vtol_init );
	//=================================================================================================
	
	level waittill( "zipline_spawning_done" );
		
	if ( level.players.size > 2 )
	{
		//shorter timer between waves for 3-4 players
		wave_wait( 3 , 10 , "window" , "top_floor" );
	}
	else
	{
		wave_wait( 3 , 45 , "window" , "top_floor" );
	}
	
	/# IPrintLnBold( "Data Drive transfer 40 percent complete." ); #/
	
	//WAVE 3 - Hallway ================================================================================
	spawner::simple_spawn( "server_room_enemy_elevator1" );
	
	if ( level.players.size > 2 )
	{
		spawner::simple_spawn( "server_room_enemy_elevator2" );
		
		wait 0.5; //slight delay to prevent too many spawning at same time
		
		spawner::simple_spawn( "server_room_enemy_top_floor_wave2" , &set_goal_server_room );
	}
	
	level thread swat_team_control();	//this spawns the hallway human squad
	//=================================================================================================
	
	level thread camera_feed( "hallway" );
	
	level.ai_hendricks dialog::say( "Look - more trouble brewing in the hallway." );
	
	level.ai_hendricks thread dialog::say( "Hold them off!" );
	
	if ( level.players.size > 2 )
	{
		wave_wait( 3 , 45 , "hallway", "top_floor" );
	}
	else
	{
		wave_wait( 4 , 30 , "hallway" );
	}
	
	/# IPrintLnBold( "Data Drive transfer 60 percent complete." ); #/
	
	//WAVE 4 - Hallway & Top Floor ==================================================================
	spawner::simple_spawn( "server_room_enemy_elevator1" );
	
	if ( level.players.size > 2 )
	{
		spawner::simple_spawn( "server_room_enemy_elevator2" );
		
		wait 2; //don't spawn them all at the same time
		
		spawner::simple_spawn( "server_room_enemy_window" );
	}
	
	wave_wait( 2 , 5 , "hallway" ); //short wait before throwing top floor AI at you
	
	if ( level.players.size > 1 )
	{ 	
		spawner::simple_spawn( "server_room_enemy_top_floor" , &set_goal_server_room );
	}
	
	if ( level.players.size > 2 )
	{ 
		spawner::simple_spawn( "server_room_enemy_top_floor_wave2" , &set_goal_server_room );
	}
	//=================================================================================================
	
	//show the enemies spawning on the top floor a few seconds later
	level thread util::delay( 5, undefined, &camera_feed, "top_floor" );
	
	wave_wait( 0 , 35 , "top_floor" , "hallway", "window" );
	
	/# IPrintLnBold( "Data Drive transfer 80 percent complete." ); #/
		
	wait 3; //extra wait here to build suspense before warlord spawning
	
	//WARLORD =========================================================================================
	warlord_entrance();
	
	wait 3; //pause for pacing, let player fight warlord solo a bit
	
	spawner::simple_spawn( "server_room_enemy_warlord_team" ); //spawns 4 AI to go through Warlord breach	
	
	wave_wait( 2 , 2 , "warlord" ); //brief wait before more spawns, check ai count just in case they get wiped quicker than that 
	
	spawner::simple_spawn( "server_room_enemy_warlord_team" ); //spawns 4 AI to go through Warlord breach
	
	if ( level.players.size > 1 )
	{ 
		spawner::simple_spawn( "server_room_enemy_top_floor" , &top_floor_door );
	}
	
	if ( level.players.size > 2 )
	{ 
		level thread camera_feed( "hallway" );
		
		spawner::simple_spawn( "server_room_enemy_top_floor_wave2" , &top_floor_door );
		
		wait 0.25; //allow a bit of time to pass so they aren't spawned on same frame
		
		spawner::simple_spawn( "server_room_enemy_hallway_final" );
		
		//use smoke again to hide entrance
		a_hallway_guys = GetEntArray( "server_room_enemy_hallway_final_ai", "targetname" );
		level thread toss_smoke_grenade( a_hallway_guys, "smoke_grenade_final_hallway1_start" );
		
		wait 2;
		
		a_hallway_guys = GetEntArray( "server_room_enemy_hallway_final_ai", "targetname" );
		level thread toss_smoke_grenade( a_hallway_guys, "smoke_grenade_final_hallway2_start" );
	}	
	//=================================================================================================
		
	wave_wait( 2 , 60 , "warlord" , "top_floor", "hallway_final" ); //checks for alive warlord breach team, top floor AI, and last group from hallway before advancing objective
	
	if ( isAlive( level.ai_warlord ) )
	{
		level.ai_warlord waittill( "death" ); //make sure warlord dies in order to complete objective
		level.ai_warlord WarlordInterface::ClearAllPreferedPoints();
	}
	
	wait 2; //pause for pacing
	
	/# IPrintLnBold( "Data Drive transfer 100 percent complete!" ); #/
		
	level notify( "server_defend_done" );
}

function toss_smoke_grenade( a_enemies, str_grenade_start_struct )
{
	w_smoke_grenade = GetWeapon( "willy_pete_nd" ); //TODO this doesn't seem to show up as a valid smoke grenade?

	// Initial toss
	s_throw_start = struct::get( str_grenade_start_struct, "targetname" );
	s_throw_end = struct::get( s_throw_start.target, "targetname" );
	v_throw = VectorNormalize(s_throw_end.origin - s_throw_start.origin) * 200;
	
	//any AI is needed to make use of MagicGrenadeType call. Just find the first guy in an array
	foreach ( ai in a_enemies )
	{
		if ( IsAlive( ai ) && IsWeapon( w_smoke_grenade ) )
		{
			//HACK MagicGrenadeType doesn't look that great right now, use effect still
			//ai MagicGrenadeType( w_smoke_grenade, s_throw_start.origin, v_throw, 1 );
			s_throw_end fx::play( "smoke_grenade" , s_throw_end.origin );
			break;
		}
		else
		{
			//if for some reason the real grenade doesn't work on the first try, just play an effect instead
			s_throw_end fx::play( "smoke_grenade" , s_throw_end.origin );
			break;
		}
	}
}

function wave_wait( n_new_wave_threshold , n_timer , str_ai_group1 , str_ai_group2, str_ai_group3 ) //waits until specified ai groups have a specific number of ai remaining, or until the timer runs out
{
	wait 1; //allows AI to spawn before tracking starts
	
	if ( isdefined( str_ai_group3 ) )
	{
		while ( ( n_timer > 0 ) && ( spawner::get_ai_group_sentient_count( str_ai_group1 ) + spawner::get_ai_group_sentient_count( str_ai_group2 ) + spawner::get_ai_group_sentient_count( str_ai_group3 )) > n_new_wave_threshold )
		{
			wait 1;
			n_timer = n_timer - 1;
		}
	}
	else if ( isdefined( str_ai_group2 ) )
	{
		while ( ( n_timer > 0 ) && ( spawner::get_ai_group_sentient_count( str_ai_group1 ) + spawner::get_ai_group_sentient_count( str_ai_group2 ) ) > n_new_wave_threshold )
		{
			wait 1;
			n_timer = n_timer - 1;
		}
	}
	else
	{
		while ( ( n_timer > 0 ) && ( spawner::get_ai_group_sentient_count( str_ai_group1 ) > n_new_wave_threshold ) )
		{
			wait 1;
			n_timer = n_timer - 1;
		}		
	}
	
	wait 3; //pause for pacing
}

function warlord_entrance() //function for warlord busting open server room wall. TODO: Need actual asset support and stuff. Right now he just spawns out of nowhere because I can't control his behavior in script.
{
	s_smash = struct::get( "warlord_smash", "targetname" ); //playing camera shake from this
	
	level.ai_warlord = spawner::simple_spawn_single( "server_room_warlord" , &warlord_spawn );
	
	level thread scene::play( "p7_fxanim_cp_biodomes_warlord_breach_01_bundle" );
	
	Earthquake( 0.25, 0.75, s_smash.origin, 800 );
	
	foreach ( player in level.players ) 
	{
		player PlayRumbleOnEntity( "damage_light" );
	}
	
	level waittill( "warlord_hit2" ); //notetrack in animation
	
	Earthquake( 0.5, 1, s_smash.origin, 900 );
	
	foreach ( player in level.players ) 
	{
		player PlayRumbleOnEntity( "damage_heavy" );
	}	
	
	level waittill( "warlord_hit3" ); //notetrack in animation
	
	Earthquake( 1, 1, s_smash.origin, 1000 );
	
	foreach ( player in level.players )
	{
		player PlayRumbleOnEntity( "damage_heavy" );
	}

	e_warlord_entrance = GetEnt( "server_koolaid" , "targetname" );	
	e_warlord_entrance ConnectPaths();
	e_warlord_entrance Delete();

	if ( IsAlive( level.ai_warlord ) )
	{
		level scene::play( "cin_bio_10_01_serverroom_aie_warlord_entrance", level.ai_warlord );
		
		level.ai_warlord notify( "warlord_go" );
		
		level.ai_hendricks thread dialog::say( "hend_warlord_0" ); //WARLORD!
	}
}

function warlord_spawn()
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	
	self waittill( "warlord_go" ); //wait for earthquakes to play, placeholder for wall punching animation
	
	self ai::set_ignoreall( false );
	
	wait 2; //post up in primary position for a few seconds before moving around the room
	
	nd_initial = GetNode( "node_warlord_server_room_initial", "script_noteworthy" );
	self SetGoal( nd_initial, true );
	
	a_warlord_nodes = GetNodeArray( "node_warlord_server_room_preferred", "targetname" );
	
	foreach ( node in a_warlord_nodes )
	{
		self WarlordInterface::AddPreferedPoint( node.origin, 5000, 10000 );
	}	
}

//============================================================================================================
// Server Room Failure Thread (if window protecting Hendricks takes too much damage)
//============================================================================================================
function track_window_damage() //handles damage and removal of control room window
{
	level endon( "server_defend_done" );
	level.ai_hendricks endon( "death" );
	
	n_window_damage_states = 3;
	
	for ( i = 1 ; i <= n_window_damage_states ; i++ )
	{ 
		trigger::wait_till( "trig_window_damage" );	

		if ( i == 1 )
		{
			GetEnt( "window_pristine" , "targetname" ) hide();
			GetEnt( "window_dmg_1" , "targetname" ) show();
			snd_damage = getent ( "window_dmg_1", "targetname" );
			snd_damage playsound ("evt_window_damage_1");
			
			level.ai_hendricks thread dialog::say( "They're trying to shoot through this glass. Don't let 'em." , 1 );
		}
		
		if ( i == 2 )
		{
			GetEnt( "window_dmg_1" , "targetname" )  hide();
			GetEnt( "window_dmg_2" , "targetname" ) show(); 
			snd_damage = getent ( "window_dmg_2", "targetname" );
			snd_damage playsound ("evt_window_damage_2");
			
			level.ai_hendricks thread dialog::say("This glass won't hold forever. Push them back!", 2 );	//That window's not gonna hold forever - Watch yourself!
		}
			
		if ( i == n_window_damage_states )	//remove window when final damage state triggered
		{
			level thread clientfield::set( "control_room_window_break", 1 ); //plays the window break anim
			
			delete_all_window_states();
				
			GetEnt( "trig_window_damage" , "targetname" ) Delete();
			GetEnt( "control_room_window_clip" , "targetname" ) Delete();
			
			level.ai_hendricks thread dialog::say( "Shit, they broke through! Keep 'em away!" );
		}
	}
	
	wait 5; //give players time to react and save Hendricks before next prompt
	
	level.ai_hendricks waittill( "damage" );
	
	level.ai_hendricks thread dialog::say( "I'm hit! Help me!" );
	
	wait 5; //give players time to react and save Hendricks before failure
	
	level.ai_hendricks waittill( "damage" );
	
	level notify( "server_room_fail" );
	
/# 
	util::screen_fade_out( 2 );
	util::screen_message_create( &"CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_HENDRICKS_WAS_KILLED" );
	util::screen_message_delete( 2 ); 
#/
	//TODO: below fail hint not appearing for some reason.	Above script is placeholder.
	util::missionfailedwrapper_nodeath( &"CP_MI_SING_BIODOMES_CLOUDMOUNTAIN_HENDRICKS_WAS_KILLED" ); 
}

function delete_all_window_states()
{
	GetEnt( "window_pristine" , "targetname" ) Delete();
	GetEnt( "window_dmg_1" , "targetname" ) Delete();
	GetEnt( "window_dmg_2" , "targetname" ) Delete();
}

function wait_for_position( ai_shooter )
{
	ai_shooter endon( "death" );
	ai_shooter.ignoreall = true;
	
	e_window_volume = GetEnt( "server_room_window_goal_volume" , "targetname" );
	
	while( ai_shooter IsTouching( e_window_volume ) == false ) //wait for ai to get in position
	{
		wait 0.1;
		if ( self GetVelocity() == 0 )
		{
			ai_shooter SetGoal( GetNode( "server_window_node" , "targetname" ) ); //guys are getting stuck so tell them to setgoal if they're not at the volume yet.
		}
	}
	
	ai_shooter.ignoreall = false;
}

function shoot_at_window()	//forces enemies to shoot at the bulletproof window
{
	self endon( "death" );
	e_server_room = GetEnt( "server_room_entrance_goal_volume" , "targetname" );
	
	if ( level flag::get( "window_broken" ) == false )
	{
		wait_for_position( self ); //waits for ai to get in place
	}
	else
	{
		self SetGoal( e_server_room );
		break;
	}
	
	while ( level flag::get( "window_broken" ) == false ) // shoot at target until defend event ends or window breaks or ai gets attacked
	{
		e_window_target = array::get_closest( self.origin , level.a_window_targets );
		
		self ai::shoot_at_target( "normal" , e_window_target , undefined , 1 ); //shoot at window for 1 second
		
		wait 1;  //re-evaluate every 1 second
	}
	
	self SetGoal( GetNode( "server_room_goal" , "targetname" ) , false , 256 ); //charge server room once window is broken
	self util::waittill_any( "goal" , "near_goal" );
	self SetGoal( e_server_room );
}

function hendricks_works_the_computer()
{
	if ( level scene::is_active( "cin_bio_09_02_accessdrives_1st_sever_end_loop" ) )
	{
		level scene::stop( "cin_bio_09_02_accessdrives_1st_sever_end_loop" );
	}	
	
	level.ai_hendricks notify( "stop_following" );
	level.ai_hendricks colors::disable();
	level.ai_hendricks.ignoreall = true;
	level.ai_hendricks.goalradius = 1;
	
	s_hendricks = struct::get( "hendricks_works_computer" , "script_noteworthy" );
	
	level thread hendricks_server_control_room_door_open( false );
	
	level.ai_hendricks skipto::teleport_single_ai( s_hendricks );
	level.ai_hendricks SetGoal( level.ai_hendricks.origin );
	
	level thread scene::play( "cin_bio_10_01_serverroom_vign_hack_loop" );
}

function objective_server_room_defend_done( str_objective, b_starting, b_direct, player )
{
	//level.ai_hendricks util::magic_bullet_shield(); //put this on in case it was removed during defend event
	
	cp_mi_sing_biodomes_util::objective_message( "server_room_defend_done" );
	
	objectives::complete( "cp_level_biodomes_repel", level.ai_hendricks );
	
	//objectives::complete( "cp_level_biodomes_defend_server_room", level.ai_hendricks ); 
	
	e_window = GetEnt( "server_window" , "targetname" );
	
	if ( isdefined( e_window ) )
	{
		e_window ConnectPaths();
		e_window delete();
	}
	
	if ( level scene::is_active( "cin_bio_10_01_serverroom_vign_hack_loop" ) )
	{
		level scene::stop( "cin_bio_10_01_serverroom_vign_hack_loop" );
	}
	
	if ( level scene::is_active( "cin_bio_09_02_accessdrives_1st_sever_end_loop" ) )
	{
		level scene::stop( "cin_bio_09_02_accessdrives_1st_sever_end_loop" );
	}
	
	//make sure hendricks doesn't get stuck inside room after coming out of animation
	if ( isdefined( level.ai_hendricks ) )
	{
		level.ai_hendricks ClearForcedGoal();
		level.ai_hendricks.goalradius = 1024;
	}
}

//Elevators
function elevator_spawning( str_location ) //should be called as a spawn function on ai in an elevator.
{	
	self endon( "death" );

	e_my_elevator_l = GetEnt( self.script_noteworthy + "_l", "targetname" );
	e_my_elevator_r = GetEnt( self.script_noteworthy + "_r", "targetname" );
	
	self util::set_ignoreall( true );
	self.goalradius = 1;	//keep AI in place while door opens
	self.allowpain = false; //don't let AI stop moving if they take damage
	
	level thread elevator_light( str_location );
	PlaySoundAtPosition( "evt_elevator_ding" , e_my_elevator_l.origin );
	
	//save off open/closed positions so that door knows where to open/close to
	e_my_elevator_l.v_closed = e_my_elevator_l.origin;
	e_my_elevator_r.v_closed = e_my_elevator_r.origin;
	s_elevator_l_open = struct::get( e_my_elevator_l.target, "targetname" );
	s_elevator_r_open = struct::get( e_my_elevator_r.target, "targetname" );
	e_my_elevator_l.v_open = s_elevator_l_open.origin;
	e_my_elevator_r.v_open = s_elevator_r_open.origin;
	
	e_my_elevator_l MoveTo( e_my_elevator_l.v_open, 1 );
	e_my_elevator_r MoveTo( e_my_elevator_r.v_open, 1 );
	
	level thread elevator_close( self , e_my_elevator_l, e_my_elevator_r );
	
	e_my_elevator_l waittill ( "movedone" ); //wait till door is open, both sides of elevator move at same speed, so just use left for this
	
	nd_target = GetNode( self.target , "targetname" );
	self SetGoal( nd_target , true ); 	//Go to whatever node the spawner is targeting
	
	elevator_wait( self ); //wait for AI to clear door. 
	
	self util::set_ignoreall( false );	//AI resume normal behavior once out of elevator
	self.allowpain = true;
	
	if ( str_location == "cloudmountain" )
	{
		self ai::set_behavior_attribute( "move_mode", "rusher" );
	}
	else
	{
		self util::waittill_any( "goal" , "near_goal" );
		self util::waittill_any_timeout( 5, "damage" , "pain" );
		self SetGoal( self.origin, false , 512 ); //free to move about after holding position for 5 seconds or taking damage
	}
}

function elevator_backup()
{
	self endon( "death" );

	e_my_elevator_l = GetEnt( self.script_noteworthy + "_l", "targetname" );
	e_my_elevator_r = GetEnt( self.script_noteworthy + "_r", "targetname" );
	
	self util::set_ignoreall( true );
	self.goalradius = 1;	//keep AI in place while door opens
	self.allowpain = false; //don't let AI stop moving if they take damage
	
	e_my_elevator_l waittill ( "movedone" ); //wait till door is open
	
	wait .1; //let front AI start moving first
	
	nd_target = GetNode( self.target , "targetname" );
	self SetGoal( nd_target , false , 200 );	
	
	elevator_wait( self ); //wait for AI to clear door. 
	
	self util::set_ignoreall( false );	//AI resume normal behavior once out of elevator
	self.allowpain = true;
	
	self ai::set_behavior_attribute( "move_mode", "rusher" );
}

function elevator_light( str_location )
{
	if ( level flag::get( "elevator_light_on_" + str_location ) == false )
	{
		n_duration = 3;
		
		level flag::set( "elevator_light_on_" + str_location );
		
		if ( str_location == "server_room" )
		{
			exploder::exploder_duration( "objective_server_room_def_elevator_lights" , n_duration ); //this function threads the duration wait so I need to sait the same duration before clearing the flag
		}
		else if ( str_location == "cloudmountain" )
		{
			//TODO get lights for cloudmountain elevators and play them here
		}
		
		wait n_duration;
		
		level flag::clear( "elevator_light_on_" + str_location );
	}
}

function elevator_close( ai_spawn, e_my_elevator_l, e_my_elevator_r ) //makes sure the door closes even if AI dies
{
	e_my_elevator_l waittill ( "movedone" );
	
	//flag is set on cleared in radiant trigger surrounding elevator
	level flag::wait_till( ai_spawn.script_noteworthy + "_cleared" );
	
	e_my_elevator_l MoveTo( e_my_elevator_l.v_closed, 1 );
	e_my_elevator_r MoveTo( e_my_elevator_r.v_closed, 1 );
}

function elevator_wait( ai_spawn )
{
	ai_spawn endon( "death" );
	
	t_elevator = GetEnt( ai_spawn.script_noteworthy + "_elevator_trigger", "targetname" );
	
	while ( ai_spawn IsTouching( t_elevator ) || util::any_player_is_touching( t_elevator , "allies" ) )
	{
		wait .5;
	}
}

function swat_team_control()
{
	spawner::simple_spawn( "server_room_enemy_swat1" );
	
	if ( level.players.size > 2 )
	{
		spawner::simple_spawn( "server_room_enemy_swat2" );
	}
	
	e_staging_area = GetEnt( "staging_area" , "targetname" );	
	b_gotime = false;
			
	while ( b_gotime == false )
	{
		wait 1;
		
		n_ready_attackers = 0;
		a_swat_team = GetAIArray( "server_room_enemy_swat1_ai" , "targetname" );
		n_attackers = a_swat_team.size;
		
		foreach ( ai in a_swat_team )
		{
			if ( ai IsTouching( e_staging_area ) )
			{
				n_ready_attackers++;
			}
		}			
		
		if ( ( n_attackers < 4 ) || ( n_ready_attackers >= ( n_attackers * 0.7 ) ) ) //launch attack if only a few ai are left or if 70% are in position 
		{
			b_gotime = true;
		}
		
		if ( n_ready_attackers > 0 || b_gotime == true )
		{
			level thread toss_smoke_grenade( a_swat_team, "smoke_grenade_final_hallway2_start" );
		}		
	}
	
	level notify( "swat_go_time" ); //ai are listening for this
}

function swat_team_ai() //run as spawn function on hallway ai
{
	self endon( "death" );
	
	self.goalradius = 1;
	
	nd_staging_area = GetNode( self.target, "targetname" );
	SetEnableNode( nd_staging_area );
	self SetGoal( nd_staging_area , false , 1 );
	
	level waittill( "swat_go_time" );
	
	a_server_room_nodes = GetNodeArray( "swat_node_" + self.script_noteworthy , "targetname" );	
	nd_server_room = array::random( a_server_room_nodes );
	
//	self.ignoreall = true;
//	self.ignoresuppression = true;

	self SetGoal( nd_server_room , false , 200 );
	SetEnableNode( nd_staging_area , false );	
	
	self util::waittill_any( "goal" , "pain" , "near_goal" , "damage" );
	
//	self.ignoreall = false;
//	self.ignoresuppression = false;
	
	self SetGoal( self.origin, false , 512 );
}

function set_goal_server_room() //self=ai, run as a spawn function
{
	e_goal = GetEnt( "server_room_entrance_goal_volume" , "targetname" );
	
	self ai::set_behavior_attribute( "sprint", true );
	
	self SetGoal( e_goal );
	
	self waittill( "goal" );
	
	self ai::set_behavior_attribute( "sprint", false );
}

function top_floor_door() //run as a spawn function, self = ai spawned up on roof
{
	self endon( "death" );
	
	self ai::set_behavior_attribute( "sprint", true );
	
	s_door = struct::get( "top_floor_door" );
	
	self SetGoal( s_door.origin , false , 100 );
	
	self waittill( "goal" );	
		
	if ( level flag::get( "top_floor_breached" ) == false )
	{
		//level flag::wait_till( "window_broken" ); //window break is gonna happen after this for now
		
		if ( !level scene::is_playing( "p7_fxanim_gp_door_broken_open_01_bundle" ) )
		{
			level thread scene::play( "p7_fxanim_gp_door_broken_open_01_bundle" );
		}
		
		e_door = GetEnt( "top_floor_door_clip" , "targetname" );
		
		if ( isdefined( e_door ) )
		{
			Earthquake( 0.5, 1, e_door.origin, 500 );
			
			e_door ConnectPaths();
			e_door Delete();
		}
		
		level flag::wait_till( "top_floor_breached" );
	}
	
	self ai::set_behavior_attribute( "sprint", false );
	
	self SetGoal( GetEnt( "server_room_top_floor_door_goal" , "targetname" ) , true ); //move into the upstairs
	
	self waittill( "goal" );
	
	wait 15; //stay upstairs for this long
	
	self SetGoal( GetEnt( "server_room_entrance_goal_volume" , "targetname" ) ); //now free to move about the whole server room, just in case the player has been hiding from you
}

function top_floor_flag()
{
	level waittill( "top_floor_door_open" ); //notify sent from door breach anim
		
	level flag::set( "top_floor_breached" );
}

function turret_hallway_keyline()
{
	trigger::wait_till( "trig_turret_hallway_enemy_spawns" );
	
	wait 0.5;  //make sure they've spawned
	
	a_ai_enemies = GetEntArray( "turret_hallway_enemy_ai", "targetname" );
	
	foreach( ai_enemy in a_ai_enemies )
	{
		if ( IsVehicle( ai_enemy ) )
		{
			ai_enemy.b_targeted = false;
			ai_enemy.b_keylined = false;
			ai_enemy thread squad_control::enable_keyline( 2 );
			ai_enemy turret::enable_laser( true, 0 );
			
			//have turrets prioritize robots initially, will automatically go back to players once robots are dead
			if ( level.a_ai_squad.size > 0 )
			{
				ai_enemy turret::set_target_ent_array( level.a_ai_squad, 0 );
			}
		}
	}
}

//VTOL Spawns
function vtol_init() //TODO much of this is a mockup, placeholder for fxanim scene
{	
	level endon( "server_room_fail" );
	
	e_rope1 = GetEnt( "vtol_zipline1" , "targetname" );
	e_rope2 = GetEnt( "vtol_zipline2" , "targetname" );

	e_rope1 Show();
	e_rope2 Show();
	
	v_rope1_dest = struct::get( "zipline1_dest" ).origin;
	v_rope2_dest = struct::get( "zipline2_dest" ).origin;
	
	v_rope1_home = e_rope1.origin;
	v_rope2_home = e_rope2.origin;
	
	//Shoot ropes at window
	e_rope1 MoveTo( v_rope1_dest - (0,0,50) , 1 );
	e_rope1 playsound ("evt_vtol_zipline_launch");
	wait RandomFloat( 0.5 );
	e_rope2 MoveTo( v_rope2_dest - (0,0,50) , 1 );
	
	e_rope2 waittill( "movedone" );
	e_rope1 playsound ("evt_vtol_zipline_attach_glass_1");
	e_rope2 playsound ("evt_vtol_zipline_attach_glass_2");
	
	level thread clientfield::set( "server_room_window_break", 1 ); //plays the window break anim
	level thread window_hooks();
	
	level notify( "stop_cracked_window" );
	
	GetEnt( "big_window_dmg_1" , "targetname" ) Delete(); //clientfield server_room_window_break plays an fxanim that represents this now
	
	level thread camera_feed( "vtol" );
	
	level.ai_hendricks thread dialog::say( "What the hell... They're taking out the whole window!" );
	
	level flag::wait_till( "window_hooks" );
	
	//Pull out window with ropes
	e_rope1 MoveY( -600 , 1 );
	e_rope2 MoveY( -600 , 1 );
	
	level flag::wait_till( "window_gone" );
	
	e_window = GetEnt( "server_window" , "targetname" );
	
	if ( isdefined( e_window ) )
	{
		e_window ConnectPaths();
		e_window delete();
		
		cp_mi_sing_biodomes_util::enable_traversals( true , "server_room_window_mantle" , "script_noteworthy" ); //enables traversals through the server room window
		
		level flag::set( "window_broken" );
	}	
	
	//Move ropes back into place for next launch
	e_rope1 MoveTo( v_rope1_home , 0.05 );
	e_rope2 MoveTo( v_rope2_home , 0.05 );
	
	e_rope2 waittill( "movedone" );
	
	wait 5; //TODO wait for scene to finish
	
	//shoot ropes into wall for zipline attackers
	e_rope1 MoveTo( v_rope1_dest , 1 );
	e_rope1 playsound ("evt_vtol_zipline_launch");
	wait RandomFloat( 0.5 );
	e_rope2 MoveTo( v_rope2_dest , 1 );
	
	e_rope2 waittill( "movedone" );
	e_rope1 playsound ("evt_vtol_zipline_attach_wall_1");
	e_rope2 playsound ("evt_vtol_zipline_attach_wall_2");
	
	wait 2; //pause for pacing
	
	//spawn attackers on ziplines
	level thread zipline_spawning();
	
	level.ai_hendricks thread dialog::say( "More incoming!" );
	
	level waittill( "zipline_attack_done" );
	
	e_rope1 Delete();
	e_rope2 Delete();
	
	nd_start = GetVehicleNode( "vtol_zipline_retreat", "targetname" );
	self vehicle::get_on_and_go_path( nd_start );
	self waittill( "reached_end_node" );
	
	self Delete(); //self = VTOL
}

function window_hooks() //TODO using this to estimate timing for when window is removed, because it currently has only client side anims i can't pass that info from it
{
	wait 5; //approximate time between when window hook scene starts and when the hooks are pulled out
	
	level flag::set( "window_hooks" );
	
	wait 0.75; //approximate time between when window hooks pull out and when the glass is clear and ready for AI to move through
	
	level flag::set( "window_gone" );
}	

function zipline_spawning()
{		
	level endon( "server_room_fail" );
	
	spawner::simple_spawn( "server_room_enemy_rope2_guy1" , &rope_guy_init );
	wait RandomFloat( 0.5 );
	spawner::simple_spawn( "server_room_enemy_rope1_guy1" , &rope_guy_init ); 
	
	wait RandomFloatRange( 1 , 4 ); //randomize timing a bit so it looks natural
	
	spawner::simple_spawn( "server_room_enemy_rope2_guy2" , &rope_guy_init );
	wait RandomFloat( 0.5 );
	spawner::simple_spawn( "server_room_enemy_rope1_guy2" , &rope_guy_init ); 

	wait RandomFloatRange( 1 , 4 ); //randomize timing a bit so it looks natural
	
	spawner::simple_spawn( "server_room_enemy_rope2_guy3" , &rope_guy_init ); 
	wait RandomFloat( 0.5 ); //randomize timing a bit so it looks natural
	spawner::simple_spawn( "server_room_enemy_rope1_guy3" , &rope_guy_init ); 
		
	if ( level.players.size > 2)
	{
		wait RandomFloatRange( 1 , 3 ); //randomize timing a bit so it looks natural

		spawner::simple_spawn( "server_room_enemy_rope2_guy1" , &rope_guy_init );
		wait RandomFloat( 0.5 );
		spawner::simple_spawn( "server_room_enemy_rope1_guy1" , &rope_guy_init );
	
		wait RandomFloatRange( 1 , 3 ); //randomize timing a bit so it looks natural
	
		spawner::simple_spawn( "server_room_enemy_rope2_guy2" , &rope_guy_init ); 
		wait RandomFloat( 0.5 ); //randomize timing a bit so it looks natural
		spawner::simple_spawn( "server_room_enemy_rope1_guy2" , &rope_guy_init ); 
	}
	
	spawner::simple_spawn( "server_room_enemy_top_floor" , &set_goal_server_room );
	
	if ( level.players.size > 2 )
	{
		spawner::simple_spawn( "server_room_enemy_top_floor_wave2" , &set_goal_server_room );
	}
	
	level notify( "zipline_spawning_done" );
	
	level.ai_hendricks thread dialog::say( "Watch the upstairs!" );
	
	level thread camera_feed( "top_floor" );
	
	wait 10; //arbitrary amount of time before VTOL departs
	
	level notify( "zipline_attack_done" ); //cleans up zipline props
}

function rope_guy_init() //self = ai running function
{
	self endon( "death" );
	
	s_vtol = struct::get( "vtol_dropoff_" + self.script_noteworthy );
	s_landing = struct::get( "vtol_landing_" + self.script_noteworthy ); 
	
	//TODO Put this back in once VTOL can be setup in correct location	
	//put AI up on the VTOL
	self ForceTeleport( s_vtol.origin , s_vtol.angles );
	
	//setup linked mover
	m_AImover = util::spawn_model( "tag_origin", s_vtol.origin , s_vtol.angles );
	m_AImover thread scene::play( "cin_gen_traversal_zipline_enemy01_idle", self );
	
	//Begin moving towards end point	
	n_dist = Distance( s_vtol.origin, s_landing.origin );
	n_time = n_dist / 500;
	
	m_AImover MoveTo( s_landing.origin, n_time );
	m_AImover playloopsound ("evt_vtol_npc_move");
	self thread rope_guy_stop_snd(m_AImover);

	m_AImover waittill ( "movedone" );
	m_AImover stoploopsound ( .5 );
	m_AImover playsound ("evt_vtol_npc_detach");
	
	//detach them at the end
	//HACK simulate the dismount animating downward. Would be better if we could standardize dismount heights instead for animation
	v_on_navmesh = GetClosestPointOnNavMesh( m_AImover.origin, 100, 48 );
	if ( isdefined ( v_on_navmesh ) )
	{
		m_AImover MoveTo( v_on_navmesh, 0.5 );
	}
	m_AImover scene::play( "cin_gen_traversal_zipline_enemy01_dismount", self );
	self notify ( "dismount_zipline" );
	self Unlink();
	m_AImover Delete();
	
	self SetGoal( GetEnt( "server_room_entrance_goal_volume" , "targetname" ) );
	
	level waittill( "server_defend_done" );
	cp_mi_sing_biodomes_util::delete_when_no_players_in_sight( self.targetname );
}
function rope_guy_stop_snd(m_AImover)
{
	m_AImover endon ( "movedone" );
	self waittill ("death");
	m_AImover stoploopsound ( .5 );
}