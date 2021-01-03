#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_util;
#using scripts\cp\_oed;
#using scripts\cp\_objectives;

#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;

#using scripts\cp\_skipto;

#using scripts\cp\cp_mi_eth_prologue;
#using scripts\cp\cp_prologue_util;
#using scripts\cp\cp_prologue_robot_reveal;



#precache( "lui_menu", "APCTurretHUD" );
#precache( "lui_menu_data", "frac" );
	
#precache( "fx", "explosions/fx_exp_generic_lg" );

#precache( "objective", "cp_level_prologue_enter_apc" );

#precache( "string", "CP_MI_ETH_PROLOGUE_MG_TURRET" );
#precache( "string", "CP_MI_ETH_PROLOGUE_GRENADE_TURRET" );
#precache( "triggerstring", "CP_MI_ETH_PROLOGUE_MOUNT_APC" );

//*****************************************************************************
// EVENT 16: APC
//*****************************************************************************

#namespace apc;

// DO ALL PRECACHING HERE
function apc_precache()
{
	level flag::init( "ai_team_inside_apc" );
	level flag::init( "apc_unlocked" );
	
}

//*****************************************************************************
//*****************************************************************************
// Event Main Function
function apc_main()
{
	apc_precache();	
	
	level cp_prologue_util::spawn_coop_player_replacement( "skipto_apc_ai" );

	level flag::wait_till( "all_players_spawned" );
	
	level.a_ai_allies = [];
	
	if( isDefined( level.ai_ally_01 ) )
	{
		level.ai_ally_01 ai::set_ignoreall( true );
		level.ai_ally_01 ai::set_ignoreme( true );
		level.ai_ally_01.goalradius = 16;			
		ArrayInsert( level.a_ai_allies, level.ai_ally_01, 0 );
	}
	
	if( isDefined( level.ai_ally_02 ) )
	{
		level.ai_ally_02 ai::set_ignoreall( true );
		level.ai_ally_02 ai::set_ignoreme( true );	
		level.ai_ally_02.goalradius = 16;
		ArrayInsert( level.a_ai_allies, level.ai_ally_02, 0 );
	}
	
	if( isDefined( level.ai_ally_03 ) )
	{
		level.ai_ally_03 ai::set_ignoreall( true );
		level.ai_ally_03 ai::set_ignoreme( true );
		level.ai_ally_03.goalradius = 16;
		ArrayInsert( level.a_ai_allies, level.ai_ally_03, 0 );
	}	
	
  	objectives::set( "cp_level_prologue_enter_apc" );

	//lets players get in APC, cleans up previous enemies
	level thread setup_vehicle();
	level thread apc_cleanup();

	//TODO: send ai to the apc
	level thread get_ai_team_into_apc();
	
	//wait til apc is done loading
	level flag::wait_till( "players_are_in_apc" );
	
	level apc_shared::ai_mount_apc();
		
	objectives::complete( "cp_level_prologue_enter_apc" );
	
	level flag::wait_till( "ai_team_inside_apc" );
    
	//once player is inside vehicle, play hyperion/hendricks chat
	level scene::play( "cin_pro_15_01_opendoor_vign_mount_new_prometheus_hendricks_end");
    
	//attach hendricks to APC via this anim
	apc_from_anim = GetEnt ("apc", "animname");
	apc_from_anim thread scene::skipto_end( "cin_pro_15_01_opendoor_vign_mount_hendricks_enter_apc" );
		
    	//TODO: have robots break through garage door we came through - animation?
	door1 = GetEnt("robot_alley_door01", "animname");
	door2 = GetEnt("robot_alley_door02", "animname");
	door1 Delete();
	door2 Delete();
    
	//robots that attack the garage door we came through
	spawner::simple_spawn( "garage_robot_attackers", &init_garage_robot_attackers );
    
	//wait here to realize that the robots have broke through the garage doors
	wait 3.5;
   	
	skipto::objective_completed( "skipto_apc" );
}


function setup_vehicle()
{
    //**************************************************
    // Put vehicle on rail and wait for players to enter
    //**************************************************
	level thread apc_shared::setup_apc_on_rail( "vehicle_apc_hijack_node", 1 );
    
	//puts up the triggers and markers to get in vehicle
	level thread apc_shared::manage_apc_3d_use_waypoints();
   
	// Lock the player in place
	level.apc MakeVehicleUnusable();
	level.apc SetSeatOccupied( 0 );
}


function apc_cleanup()
{
	// Kill all enemy
    level thread rail_cleanup_all_enemy();
    
    //clean up friendlies too
    if (IsDefined(level.ai_theia))
    {
    	level.ai_theia Delete();
    }
    if (IsDefined(level.ai_pallas))
    {
    	level.ai_pallas Delete();
    }
    if (IsDefined(level.ai_hyperion))
    {
    	level.ai_hyperion Delete();
    }	
}




//*****************************************************************************
// Get the AI team into the APC
//*****************************************************************************

function get_ai_team_into_apc()
{	
	//TODO: Send the AI team to the apc, wait til they are in
	//level.apc scene::play( "cin_pro_15_01_opendoor_1st_mount_player02", self );		// front left			
	//once all players are in
	//get an array of unclaimed spots
	//for each ai
	//go to a spot
	//mark it as claimed
	
	level flag::set( "ai_team_inside_apc" );
}

//*****************************************************************************
// Manage the robot horde
//*****************************************************************************

function init_garage_robot_attackers()
{
	self endon( "death" );
	
	nd_cleanup_garage_attackers = GetVehicleNode( "nd_cleanup_garage_attackers", "script_noteworthy" );
	nd_cleanup_garage_attackers waittill( "trigger" );
	self Delete();	
}

//*****************************************************************************
// Kill off and cleanup all enemy AI so we can have a clean rail
//*****************************************************************************

function rail_cleanup_all_enemy()
{
    a_ai = GetAITeamArray( "axis" );
    if( IsDefined(a_ai) )
    {
        for( i=0; i<a_ai.size; i++ )
        {
            a_ai[i] delete();
        }
    }
}


//*****************************************************************************
//*****************************************************************************
//APC RAIL
//*****************************************************************************
//*****************************************************************************
#namespace apc_rail;

function apc_rail_precache()
{
	level._effect[ "gen_explosion" ]	= "explosions/fx_exp_generic_lg";	
}

function apc_rail_main()	
{
	apc_rail_precache();
	
	level flag::wait_till( "all_players_spawned" );
	
	apc_from_anim = GetEnt ("apc", "animname");
	apc_from_anim thread scene::skipto_end( "cin_pro_15_01_opendoor_vign_mount_hendricks_enter_apc" );
	
	wait 0.05; //wait for anim to go
	level.ai_hendricks = GetEnt("hendricks", "animname");
	
	level thread apc_shared::garage_battle();
    
	level flag::wait_till( "players_are_in_apc" );
	
	level thread vehicle_rail();
		
	// Allow the vehicle to shoot itself
	setdvar( "vehicle_selfCollision", 1 );

	//sets up vtols that do not take off but can be destroyed for explosionz
	level thread vtol_eyecandy();
	
	level thread rail_spawning_main();
}

function rail_spawning_main()
{
	//spawn setup function
	level thread apc_spawn_functions();
	
	vh_attack_ambush_vtol = vehicle::simple_spawn_single( "attack_ambush_vtol" );
	vh_attack_ambush_vtol util::magic_bullet_shield();
	vh_attack_ambush_vtol thread vtol_pre_tunnel();

    //handles ai perception driving through fog
    level thread fog_awareness_handler();
    
//    ----------------------------------------
    
    //Road to Garage Apex turn
    spawner::add_spawn_function_group( "intro_road_robots" , "targetname" , &intro_road_robots_behavior );
    
    level thread spawn_ai_on_rail( "intro_road_robots", "t_initial_attackers", "trig_cleanup_apex_garage" );    
    level thread spawn_ai_on_rail( "intro_road_humans", "t_initial_attackers", "trig_cleanup_apex_garage" );    
    
    level thread apex_garage_door_think();
    level thread spawn_ai_on_rail( "apex_garage_robots", "trig_spawn_garage_robots", "trig_cleanup_apex_garage" );
    level thread spawn_ai_on_rail( "apex_garage_humans", "trig_spawn_garage_robots", "trig_cleanup_apex_garage" );    

//    ----------------------------------------
    
    //Helipad Roadblock
    level thread vehicle_helipad_roadblock();
    //level thread spawn_ai_on_rail( "helipad_human", "t_helipad_guys", "t_vtol_fire_missiles" );
        
//    ----------------------------------------
    
    //Off-road Section
    level thread spawn_ai_on_rail( "offroad_robot", "t_offroad_enemies", "trig_cleanup_offroad" );
    level thread spawn_ai_on_rail( "offroad_human", "t_offroad_enemies", "trig_cleanup_offroad" );

//    ----------------------------------------
}

function intro_road_robots_behavior()  //self = ai robot
{
	self ai::set_behavior_attribute( "move_mode", "rusher" );	
}

function vehicle_helipad_roadblock()
{
	level flag::wait_till( "spawn_roadblock" );

	a_helipad_roadbloack_trucks = vehicle::simple_spawn( "helipad_roadbloack_trucks" );
	foreach( e_tech_truck in a_helipad_roadbloack_trucks )
	{
		e_tech_truck thread setup_roadblock_truck();
		wait .5;
	}
}

function setup_roadblock_truck()
{
    self endon( "death" );
    
    nd_start_node = GetVehicleNode( self.target, "targetname" );
    self thread vehicle::get_on_and_go_path( nd_start_node );
        
    self turret::enable( 1, false );
    
    trigger::wait_till( "ambush_vtol_takeoff" );
    
    self turret::disable( 1 );
}

//str spawner - spawner //nd_spline_node - triggers spawns //str_cleanup_trigger - trigger multiple
function spawn_ai_on_rail( str_spawner, str_trigger_spawn, str_cleanup_trigger )
{
    str_delete_group = str_spawner + "_ai";

    //nd_trigger = GetVehicleNode( nd_spline_node, "script_noteworthy" );
    //nd_trigger waittill( "trigger" );
    if (isdefined(str_trigger_spawn))
    {
 		level trigger::wait_till(str_trigger_spawn);
    }
    
    // Spawn in the new AI wave
    a_spawners = GetEntArray( str_spawner, "targetname" );
    foreach( sp_guy in a_spawners )
	{
		e_ai = sp_guy spawner::spawn();
		e_ai.overrideActorDamage = &callback_robot_damage_rail;
	}

	// Wait for a trigger to cleanup
	e_trigger = GetEnt( str_cleanup_trigger, "targetname" );
	e_trigger waittill( "trigger" );
	
	a_str_delete_group = GetEntArray( str_delete_group, "targetname" );
	foreach( e_guy in a_str_delete_group )
	{
		e_guy Delete();
	}
}

function apc_spawn_functions()
{
    spawner::add_spawn_function_group( "rail_robot", "script_noteworthy", &setup_marcher_attackers );
}

function setup_tunnel_roadblock_human()
{
    self endon( "death" );
    
    nd_humans_run_away = GetVehicleNode( "nd_humans_run_away", "script_noteworthy" );
    nd_humans_run_away waittill( "trigger" );
    
    //node they run to, make it look like theyre avoiding the truck
    nd_avoid_player_truck = GetNode( "nd_humans_run_away", "targetname" );
    self thread ai::force_goal( nd_avoid_player_truck, 32, true );
}

function setup_marcher_attackers()
{
    self endon( "death" );
    
    //turn on glow eyes, wait until death then turns off
    self thread robot_horde::robot_eye_fx_on();    
    
    //TODO: i like this look, but they do not shoot while marching
    //self ai::set_behavior_attribute( "move_mode", "marching" );    
    
    //send ai to his goal pos
   /* if (IsDefined(self.target))
    {
    	n_goal_node = struct::get( self.target, "targetname" );
    	self thread ai::force_goal( n_goal_node, 32 );
    }*/
}

function apex_garage_door_think()
{
    // Scene: Theia close the gate: TODO: need to make sure the gate is removed during natural playthrough
    //    level thread scene::play( "cin_pro_15_01_opendoor_vign_getinside_theia_closedoor"  );    

    bm_apex_garage_door = GetEnt( "bm_apex_garage_door", "targetname" );
    
    nd_spawn_apex_garage_robots = GetVehicleNode( "nd_open_garage", "script_noteworthy" );
    nd_spawn_apex_garage_robots waittill( "trigger" );
        
    bm_apex_garage_door ConnectPaths();
    bm_apex_garage_door MoveZ( 100, 2.5 );
    bm_apex_garage_door waittill( "movedone" );
    bm_apex_garage_door Delete();
}

function fog_awareness_handler()
{
	level flag::wait_till("enter_fog1");
	apc_shared::set_fog_state(true);
	level flag::wait_till("exit_fog1");
	apc_shared::set_fog_state(false);
	level flag::wait_till("enter_fog2");
	apc_shared::set_fog_state(true);
	level flag::wait_till("exit_fog2");	
	apc_shared::set_fog_state(false);
	
}



//*****************************************************************************
// Vehicle Rail
//*****************************************************************************

function vehicle_rail()
{
	level.max_ai_on_rail = 45;
	 
	level.last_crawler_time = -10000.0;
    
	//starts rail scripts
	level flag::set( "apc_rail_begin" );    

	//***************
	// Start the Rail
	//***************
	// Turn on the vision set
	//SetDvar( "r_thermalFX_enable", "1" );
	//SetDvar( "r_thermalType", "1" );
	
	level.apc.goalradius = 130;        // 130
    
    
	// Start driving down the path    
	level.apc thread vehicle::go_path();

	//***********************************
	// APC bursts through the garage door
	//***********************************
	level thread burst_through_door();

	//******************************
	// Put AI players into the turret
	//******************************
	level thread setup_ai_inside_apc();
    
	//clean up guys in the garage so we don't see their friendnames
	level thread delete_garage_allies();
    
	//**********************
	// Spawn a crawler, we just drove over a handful of robots
	//**********************    
	trigger::wait_till( "trig_first_crawler" );

	create_robot_apc_crawler( 1 );
    
	//**********************
	// Approachnig the VTOLS
	//**********************
	e_trigger = GetEnt( "t_apc_sees_vtols", "targetname" );
	e_trigger waittill( "trigger" );
    
	// TODO: Should be khalil - khalil is in the truck with us, we can just play it off the player since he deletes when his get in anim ends
	level.players[0] thread dialog::say( "khal_take_out_the_vtols_0" );
    
	nd_truck_hits_fence = GetVehicleNode( "nd_truck_hits_fence", "script_noteworthy" );
	nd_truck_hits_fence waittill( "trigger" );
    
	a_fence = GetEntArray( "crash_into_fence", "targetname" );
	velocity = 250.0;
	earthquake_size = 0.75;
	num_shakes  = 2;
	apc_shared::physics_collision_with_ents( a_fence, velocity, earthquake_size, num_shakes, undefined, undefined );    
    
	//player rumble here and screen shake
	foreach( e_player in level.players )
	{
		e_player PlayRumbleOnEntity( "tank_damage_heavy_mp" );
		Earthquake( 0.65, 0.7, e_player.origin, 128.0 );
	}    

	level.apc waittill( "reached_end_node" );
   
	level.apc disconnectpaths();
    
	//player rumble here and screen shake
	foreach( e_player in level.players )
	{
		e_player PlayRumbleOnEntity( "tank_damage_heavy_mp" );
		Earthquake( 0.65, 0.7, e_player.origin, 128.0 );
	}    
    
	skipto::objective_completed( "skipto_apc_rail" );
}
    
    
//*****************************************************************************
//*****************************************************************************

function setup_ai_inside_apc()
{
	vh_nd_slide_stop_heroes = GetVehicleNode( "nd_garage_attackers", "script_noteworthy" );
	vh_nd_slide_stop_heroes waittill( "trigger" );
	
	level.apc thread apc_shared::setup_apc_ai_turrets();

	apc_shared::setup_apc_turrets_rail_firerates( 0 );
}

function delete_garage_allies()
{
	level flag::wait_till("delete_garage_allies");
	
	if (IsDefined(level.ai_prometheus))
	{
		level.ai_prometheus Delete();
	}
	if (IsDefined(level.ai_theia))
	{
		level.ai_theia Delete();
	}
	if (IsDefined(level.ai_pallas))
	{
		level.ai_pallas Delete();
	}
	if (IsDefined(level.ai_hyperion))
	{
		level.ai_hyperion Delete();
	}
}


function burst_through_door()
{
	level flag::wait_till("apc_thru_door");
    exploder::exploder( "apc_thru_door" );

    level thread scene::play( "apc_door_crash" );

    //player rumble here and screen shake
    foreach( e_player in level.players )
    {
        e_player PlayRumbleOnEntity( "tank_damage_heavy_mp" );
        Earthquake( 0.65, 0.7, e_player.origin, 128.0 );
    }
}

function intro_garage_door_think()
{
	bm_intro_garage_door_1 = GetEnt( "bm_intro_garage_door_1", "targetname" );
	bm_intro_garage_door_2 = GetEnt( "bm_intro_garage_door_2", "targetname" );
	
	level flag::wait_till( "apc_rail_begin" );
	
	//left door
	bm_intro_garage_door_1 ConnectPaths();
	bm_intro_garage_door_1 MoveZ( 100, 2.5 );
	
	wait .30;
	
	//right door
	bm_intro_garage_door_2 ConnectPaths();
	bm_intro_garage_door_2 MoveZ( 100, 2.5 );	
	
	//wait until second one reaches up and delete both doors
	bm_intro_garage_door_2 waittill( "movedone" );
	bm_intro_garage_door_1 Delete();	
	bm_intro_garage_door_2 Delete();	
}


function vtol_eyecandy()
{
    //hide vtol model after tunnel
    m_tunnel_vtol_death = GetEnt( "m_tunnel_vtol_death", "targetname" );
    m_tunnel_vtol_death Hide();
        
    vehicle::add_spawn_function( "vtol_apc_spline_eyecandy", &vtol_eyecandy_update );
    vehicle::simple_spawn( "vtol_apc_spline_eyecandy" );
    
    trigger::wait_till( "trig_cleanup_apex_garage" );
    
    
}

function vtol_eyecandy_update()
{
    self.overrideVehicleDamage = &callback_vtol_damage;
    self vehicle::toggle_sounds( 0 );//shutting off roadside vtol sounds
}

//*****************************************************************************
// Spawn a Vtol that attacks down a spline
//*****************************************************************************

function vtol_attack_down_spline( str_vehicle_targetname, str_node_targetname, n_spawn_delay, fire_delay, turret0, turret1, turret2, missile_func )
{
    e_vehicle = vehicle::simple_spawn_single( str_vehicle_targetname );

    e_trigger = GetEnt( "t_vtol_apc", "targetname" );
    e_trigger waittill( "trigger" );

    if( IsDefined(n_spawn_delay) )
    {
        wait( n_spawn_delay );
    }
        
    e_vehicle thread vtol_attack_player( str_node_targetname, fire_delay, turret0, turret1, turret2 );
    
    if( IsDefined(missile_func)) 
    {
        e_vehicle thread [[missile_func]]();
    }
}


//*****************************************************************************
//*****************************************************************************
// self = vtol
function vtol_attack_player( str_start_node, fire_delay, turret0, turret1, turret2 )
{
    self endon( "death" );

    self.overrideVehicleDamage = &callback_vtol_damage;

    nd_start = GetVehicleNode( str_start_node, "targetname" );
    self AttachPath( nd_start );
    self StartPath();

    wait( fire_delay );

    if( turret0 )
    {
        self turret::enable( 0, false );
    }
    
    if( turret1 )
    {
        self turret::enable( 1, false );
    }
    
    if( turret2 )
    {
        self turret::enable( 2, false );
    }


    self waittill( "reached_end_node" );
}


//*****************************************************************************
//*****************************************************************************
//APC RAIL STALL
//*****************************************************************************
//*****************************************************************************

function apc_rail_stall_precache()
{
	level flag::init( "tunnel_vtol_hit" );
	
	level._effect[ "gen_explosion" ]	= "explosions/fx_exp_generic_lg";
	
}

function apc_rail_stall_main()	
{
	apc_rail_stall_precache();
	level flag::wait_till( "all_players_spawned" );
	
	// Allow the vehicle to shoot itself
	SetDvar( "vehicle_selfCollision", 1 );
	
	level thread apc_spawn_functions();
	level.apc = GetEnt("apc", "animname");
	//attach hendricks
	level.apc thread scene::skipto_end( "cin_pro_15_01_opendoor_vign_mount_hendricks_enter_apc" );
	
    level thread stall_enemy_handler();
    
    level stall_timing_handler();
      
    nd_start = GetVehicleNode("nd_stall_start", "targetname");
    level.apc thread vehicle::get_on_and_go_path(nd_start);
    
    veh_tunnel_apc = vehicle::simple_spawn_single_and_drive("tunnel_chase_apc");
    
    // The apc colliding with destructibles along the rail
    level thread rail_tunnel_enterance_destruction();    
    
    //-----------------------------------------------------
    // TUNNEL
    
    level thread vtol_after_tunnel(); 
     
    //node to have them run away
    level thread spawn_ai_on_rail( "tunnel_roadblock_robots", "t_spawn_tunnel_roadblock", "trig_cleanup_tunnel_roadblock" );
    
    //******************************
    // Destruction inside the tunnel
    //******************************
    level thread apc_hits_truck_in_tunnel();
    level thread apc_hits_scaffolding_in_tunnel();
    
    //***********************
    // Enter tunner - Cleanup
    //***********************
    trig_player_in_tunnel = GetEnt( "trig_player_in_tunnel", "targetname" );
    trig_player_in_tunnel waittill( "trigger" );
    
    level flag::set( "player_in_tunnel" );
    
    a_vehicles = GetEntArray( "vtol_apc_spline_eyecandy_vh", "targetname" );
    if( IsDefined(a_vehicles) )
    {
        for( i=0; i<a_vehicles.size; i++ )
        {
            e_vehicle = a_vehicles[i];
            e_vehicle Delete();
        }
    }
    
    //******************************************
    // Dialog when were near the end of the rail
    //******************************************
    // Node on the rail
    level.apc waittill( "approaching_extraction_point" );
// TODO: Should be khalil
    level.players[0] thread dialog::say( "hend_we_re_here_get_read_0" );

    //*****************************************
    // Wait until we get to the end of the rail
    //*****************************************
    level.apc waittill( "reached_end_node" );
    
    foreach (e_player in level.players)
    {
    	e_player notify("end_damage_callback");
    }
    
    skipto::objective_completed( "skipto_apc_rail_stall" );
}


function stall_enemy_handler()
{    
    level thread spawn_ai_on_rail( "ambush_robots", undefined, "trig_player_in_tunnel" );
    
    wait 2;//pacing
    
	level thread ambush_robot_crawlers();
        
	veh_jeep_1 = level cp_prologue_util::spawn_and_drive_jeep_and_guy("ambush_jeep_NW", "ambush_jeep_guy_NW");
	veh_jeep_2 = level cp_prologue_util::spawn_and_drive_jeep_and_guy("ambush_jeep_NE", "ambush_jeep_guy_NE");
	veh_jeep_3 = level cp_prologue_util::spawn_and_drive_jeep_and_guy("ambush_jeep_SE", "ambush_jeep_guy_SE");
	veh_jeep_4 = level cp_prologue_util::spawn_and_drive_jeep_and_guy("ambush_jeep_SW", "ambush_jeep_guy_SW");   
    
	wait 3;//pacing
	
    level thread spawn_ai_on_rail( "ambush_robots", undefined, "trig_player_in_tunnel" );
    
    level trigger::wait_till("trig_player_in_tunnel");
    
    veh_jeep_1 Delete();
    veh_jeep_2 Delete();
    veh_jeep_3 Delete();
    veh_jeep_4 Delete();
    
    
}

function stall_timing_handler()
{
    level.players[0] PlayLocalSound( "evt_apc_start_fail" );
    wait 2.5; //timing
	level.players[0] PlayLocalSound( "evt_apc_start_fail" );
    wait 2.5; //timing
    
    level.ai_hendricks thread dialog::say( "APC stalled! Keep them off of us!" );
    level.players[0] playlocalsound( "evt_apc_start_fail" );
    
    wait 5;// timing
    
    level.ai_hendricks thread dialog::say( "Shit, it's not starting." );
    level.players[0] playlocalsound( "evt_apc_start_fail" );
    
    wait 5;// timing
    
    level.players[0] playlocalsound( "evt_apc_start_success" );
    
    wait 2;// timing
    
    level.ai_hendricks thread dialog::say( "Alright! Got it!" );
    
    wait 1;//timing	
}

//*****************************************************************************
//*****************************************************************************

function apc_hits_truck_in_tunnel()
{
    e_trigger = GetEnt( "apc_hits_truck_in_tunnel", "targetname" );
    e_trigger waittill( "trigger" );

    a_blockers = GetEntArray( "apc_tunnel_barrels_left", "targetname" );
    
    a_blockers_right = GetEntArray( "apc_tunnel_barrels_right", "targetname" );
    for( i=0; i<a_blockers_right.size; i++ )
    {
        if ( !isdefined( a_blockers ) ) a_blockers = []; else if ( !IsArray( a_blockers ) ) a_blockers = array( a_blockers ); a_blockers[a_blockers.size]=a_blockers_right[i];;
    }

    level thread barrels_in_tunnel_shot();

    velocity = 140.0;
    earthquake_size = 0.5;
    num_shakes  = 2;
    apc_shared::physics_collision_with_ents( a_blockers, velocity, earthquake_size, num_shakes, -50, -1 );
}

// Trigger the barrels if shot
function barrels_in_tunnel_shot()
{
    level endon( "cleanup_apc" );

    e_trigger = GetEnt( "t_tunnel_barrels_shot", "targetname" );
    e_trigger waittill( "trigger" );

    e_trigger = GetEnt( "apc_hits_truck_in_tunnel", "targetname" );
    if( IsDefined(e_trigger) )
    {
        e_trigger notify( "trigger" );
    }
}

//*****************************************************************************
//*****************************************************************************

function apc_hits_scaffolding_in_tunnel()
{
    level thread scaffolding_in_tunnel_shot();

    e_trigger = GetEnt( "apc_bashes_scaffolding_in_tunnel", "targetname" );
    e_trigger waittill( "trigger" );

    a_blockers = GetEntArray( "apc_tunnel_scaffolding", "targetname" );

    velocity = 400.0;
    earthquake_size = 0.5;
    num_shakes  = 3;
    apc_shared::physics_collision_with_ents( a_blockers, velocity, earthquake_size, num_shakes, undefined, undefined );
}

// Trigger the scaffolding if shot
function scaffolding_in_tunnel_shot()
{
    level endon( "cleanup_apc" );

    e_trigger = GetEnt( "t_tunnel_exit_scaffolding", "targetname" );
    e_trigger waittill( "trigger" );

    e_trigger = GetEnt( "apc_bashes_scaffolding_in_tunnel", "targetname" );
    if( IsDefined(e_trigger) )
    {
        e_trigger notify( "trigger" );
    }
}

//*****************************************************************************
//*****************************************************************************


//*****************************************************************************
// VTOL that attacks the player after the tunnel
//*****************************************************************************

function vtol_after_tunnel()
{
    level flag::wait_till( "player_in_tunnel" ); //this flag is on the trigger at the entrance of the tunnel
    
    nd_spawn_tunnel_vtol = GetVehicleNode( "nd_spawn_tunnel_vtol", "script_noteworthy" );
    nd_spawn_tunnel_vtol waittill( "trigger" );
    
    e_tunnel_vtol = vehicle::simple_spawn_single( "tunnel_vtol" );
    e_tunnel_vtol thread tunnel_vtol_crash_path();
    e_tunnel_vtol thread tunnel_vtol_think();
}

function tunnel_vtol_think()
{
    self endon( "death" );
    
    self.overrideVehicleDamage = &callback_vtol_damage;

    nd_start = GetVehicleNode( self.target, "targetname" );
    self AttachPath( nd_start );
    self StartPath();

    self turret::enable( 0, false );
    self turret::enable( 1, false );
    self turret::enable( 2, false );
    
    self thread apc_shared::vtol_tunnel_exit_missile_attack();    
    
    nd_tunnel_vtol_failed = GetVehicleNode( "nd_tunnel_vtol_failed", "script_noteworthy" );
    nd_tunnel_vtol_failed waittill( "trigger" );
    
    if ( level flag::get( "tunnel_vtol_hit" ) )
    {
        //fail the player here
        IPrintLnBold( "Tunnel collapses killing EVERYONE!!! Mission Failed." );    
    }
}

function tunnel_vtol_crash_path()
{
    //TODO: we need to have the vtol play its crash path once it dies, check the call back
    level flag::wait_till( "tunnel_vtol_hit" );
    
    level.ai_hendricks dialog::say( "NICE!!! VTOL is down!!" );
    
    //start him on the spline path of death
    nd_tunnel_vtol_crash_start = GetVehicleNode( "nd_tunnel_vtol_crash_start", "targetname" );
    self thread vehicle::get_on_and_go_path( nd_tunnel_vtol_crash_start );
    
    //shutdown all turrets
    self turret::disable( 0 );
    self turret::disable( 1 );
    self turret::disable( 2 );    

    self thread fx::play( "gen_explosion", self.origin, self.angles );
    PlaySoundAtPosition ( "wpn_rocket_explode" , self.origin );//missile exp sound
    Earthquake( 0.5, 0.5, level.apc.origin, 400 );
    wait 1;
    //ROBOT_SHOT_EXP is just a default explosion
    self thread fx::play( "gen_explosion", self.origin, self.angles );
    PlaySoundAtPosition ( "wpn_rocket_explode" , self.origin );//missile exp sound
    Earthquake( 0.5, 0.5, level.apc.origin, 400 );
    wait 1;
    self thread fx::play( "gen_explosion", self.origin, self.angles );
    PlaySoundAtPosition ( "wpn_rocket_explode" , self.origin );//missile exp sound
    Earthquake( 0.5, 0.5, level.apc.origin, 400 );
    wait 1;
    self thread fx::play( "gen_explosion", self.origin, self.angles );
    PlaySoundAtPosition ( "wpn_rocket_explode" , self.origin );//missile exp sound
    Earthquake( 0.5, 0.5, level.apc.origin, 400 );
    
    self waittill( "reached_end_node" );
    self notify( "death" );
    
    //show vtol model after tunnel
    m_tunnel_vtol_death = GetEnt( "m_tunnel_vtol_death", "targetname" );
    m_tunnel_vtol_death Show();
    
    exploder::exploder( "fx_exploder_vtol_crash_rail" );

    level thread clientfield::set( "apc_rail_tower_collapse", 1 );
    exploder::exploder( "fx_exploder_rail_tower" );
    Earthquake( 0.5, 0.5, level.apc.origin, 400 );
}

//*****************************************************************************
// VTOL: Damage callback function
//*****************************************************************************

function callback_vtol_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
    if ( isdefined( self.targetname ) && self.targetname == "tunnel_vtol_vh" )
    {
        level flag::set( "tunnel_vtol_hit" );
        self.disable_damage = 1;
        return( 0 );
    }
    
    if( ( isdefined( self.disable_damage ) && self.disable_damage ) )
    {
        return( 0 );
    }

    if( IsDefined(weapon) && IsDefined(weapon.name) )
    {
        if( (weapon.name == "turret_bo3_mil_macv_gunner1") || (weapon.name == "turret_bo3_mil_macv_gunner2") )
        {
            iDamage = 70;
        }
    }

    if( self.health - iDamage <= 0 )
    {
        self notsolid();
    }
    
    return iDamage;
}

//*****************************************************************************
//*****************************************************************************

// self = robot spawner
function spawn_rail_robot( marching_robot, str_delete_group )
{
    if( IsDefined(self.script_float) )
    {
        wait( self.script_float );
    }

    e_ai = self spawner::spawn();

    e_ai endon( "death" );

    e_ai cp_mi_eth_prologue::DeleteGroupAdd( str_delete_group );
    e_ai.overrideActorDamage = &callback_robot_damage_rail;

    // Should the guy be able to shoot?
    if( !IsDefined(self.script_parameters) )
    {
        // Only every other robot shoots
        if( !IsDefined(level.is_robot_shooter) )
        {
            level.is_robot_shooter = 1;
            }
        if( level.is_robot_shooter == 0 )
        {
            e_ai.ignoreall = true;
        }
        level.is_robot_shooter++;
        if( level.is_robot_shooter > 1 )
        {
            level.is_robot_shooter = 0;
        }
    }

    // Set movement style
    if( IsDefined(self.script_noteworthy) && (self.script_noteworthy == "sprinter") )
    {
        e_ai ai::set_behavior_attribute( "sprint", true );
    }
    else
    {
        switch( marching_robot )
        {
            // Slow marching
            case 0:
                e_ai ai::set_behavior_attribute( "move_mode", "marching" );
            break;

            // Brisk walking - DEFULT SETUP, do nothing
            case 1:
            break;

            // Running:
            case 2:
                e_ai ai::set_behavior_attribute( "sprint", true );
            break;
        }
    }

    // Follow the path
    if( IsDefined(e_ai.script_string) ) 
    {
        e_ai thread cp_prologue_util::follow_linked_scripted_nodes();
    }
    else
    {
        e_ai.goalradius = 64;
    }
}


//*****************************************************************************
// Robot DAMAGE
//*****************************************************************************

function callback_robot_damage_rail( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, modelIndex, psOffsetTime, boneName, vSurfaceNormal )
{
    // Crush Damage
    if( IsDefined(sMeansOfDeath) && (sMeansOfDeath == "MOD_CRUSH") )
    {
        if( !IsDefined(self.alreadyLaunched) )
        {
            self.alreadyLaunched = true;

            // Maybe create a crawled to attack the APC
            if( IsDefined(self.script_noteworthy) && (self.script_noteworthy == "crawler") )
            {
                rval = create_robot_apc_crawler( 0 );
                if( rval )
                {
                    return( self.health + 1 );
                }
            }

            // Push the robot into ragdoll launch                
            self StartRagdoll( true );
            xvel = randomfloatrange( -60, 60 );
            v_launch = ( xvel, 0, randomfloatrange(40, 140) );
            v_launch += AnglesToForward( eInflictor.angles ) * 250;
            self LaunchRagdoll( v_launch, "J_SpineUpper" );
        }        
    }

    // Weapon Damage
    else if( IsDefined(weapon) && IsDefined(weapon.name) )
    {
        if ( !IsDefined(self.alreadyLaunched) )
        {
            // If shot by the machine guns
            if( (weapon.name == "turret_bo3_mil_macv_gunner1") || (weapon.name == "turret_bo3_mil_macv_gunner2") )
            {
                self.alreadyLaunched = true;
                self StartRagdoll( true );
                v_launch = (0, 0, 50 );
                v_launch += AnglesToForward( eInflictor.angles ) * 120;
                self LaunchRagdoll( v_launch, "J_SpineUpper" );
            }
            // If shot by the rocket launchers
            else if( (weapon.name == "turret_bo3_mil_macv_gunner3") || (weapon.name == "turret_bo3_mil_macv_gunner4") )
            {
                self.alreadyLaunched = true;
                self StartRagdoll( true );
                v_launch = ( 0, 0, randomfloatrange(30, 90) );    // 
                v_launch += AnglesToForward( eInflictor.angles ) * 120;
                self LaunchRagdoll( v_launch, "J_SpineUpper" );
            }
        }
    }

    //iDamage = self.health + 1;
    return iDamage;
}

//*****************************************************************************
// If no robot crawlers have been created, create one when we hit this trigger
//*****************************************************************************

function robot_crawler_failsafe_in_vtol_area()
{
    e_trigger = Getent( "t_robot_crawler_failsafe", "targetname" );
    e_trigger waittill( "trigger" );
    create_robot_apc_crawler( 0 );
}

//*****************************************************************************
// Robot crawling onto the APC when it tries to avoid the Vtols
//*****************************************************************************

function ambush_robot_crawlers()
{

   // e_trigger = getEnt( "t_rail_ambush_apc", "targetname" );
    //e_trigger waittill( "trigger" );
    
    // Setup the robots
    sp_array = [];
    sp_array[ sp_array.size ] = "robot_vtol_attack_1";
    sp_array[ sp_array.size ] = "robot_vtol_attack_2";
    sp_array[ sp_array.size ] = "robot_vtol_attack_3";
    sp_array[ sp_array.size ] = "robot_vtol_attack_4";

    for( i=0; i<sp_array.size; i++) 
    {
        sp_ent = GetEnt( sp_array[i], "targetname" );
        e_ent = sp_ent spawner::spawn();
        e_ent.overrideActorDamage = &callback_robot_apc_crawler;
    }
    
    // Play the robot attack scenes
    level.apc thread scene::play( "cin_pro_16_02_apc_vign_flung_robot_left_front_01" );
    level.apc thread scene::play( "cin_pro_16_02_apc_vign_flung_robot_left_rear_01" );
    level.apc thread scene::play( "cin_pro_16_02_apc_vign_flung_robot_right_front_01" );
    level.apc thread scene::play( "cin_pro_16_02_apc_vign_flung_robot_right_rear_01" );

    //give them enough time to spawn in 
    wait .2;
    
    ai_robot_vtol_attack_1 = GetEnt( "robot_vtol_attack_1_ai", "targetname" );
    ai_robot_vtol_attack_2 = GetEnt( "robot_vtol_attack_2_ai", "targetname" );
    ai_robot_vtol_attack_3 = GetEnt( "robot_vtol_attack_3_ai", "targetname" );
    ai_robot_vtol_attack_4 = GetEnt( "robot_vtol_attack_4_ai", "targetname" );
    
    ai_robot_vtol_attack_1 thread robot_horde::robot_eye_fx_on();    
    ai_robot_vtol_attack_2 thread robot_horde::robot_eye_fx_on();    
    ai_robot_vtol_attack_3 thread robot_horde::robot_eye_fx_on();    
    ai_robot_vtol_attack_4 thread robot_horde::robot_eye_fx_on();    

}

function vtol_pre_tunnel()
{
    self endon( "death" );
    
    trigger::wait_till( "ambush_vtol_takeoff" );
    
    //take off now
    nd_start_node = GetVehicleNode( "nd_tunnel_vtol_ambush_start", "targetname" );
    self thread vehicle::get_on_and_go_path( nd_start_node );
    
    nd_vtol_ambush_fire = GetVehicleNode( "nd_vtol_ambush_fire", "script_noteworthy" );
    nd_vtol_ambush_fire waittill( "trigger" );
    
    //temp wait to adjust timing of shots
    wait 3;
    
    level thread rocket_impacts();
    
    // Fire 5 rpgs at the grond near the player APC
    a_structs = struct::get_array( "tunnel_vtol_target", "targetname" );
    for( i=0; i<5; i++ )
    {
        v_dir = AnglesToforward( self.angles );
        v_start_pos = self.origin + (v_dir * 20.0);
        
        v_target_pos = a_structs[i].origin;

        self thread apc_shared::fire_missile_at_struct( v_start_pos, v_target_pos );
        wait( 0.2 );
    }    
        
    //second shots when it banks around
    nd_vtol_fire_at_tunnel = GetVehicleNode( "nd_vtol_fire_at_tunnel", "script_noteworthy" );
    nd_vtol_fire_at_tunnel waittill( "trigger" );    
    
    // Fire 5 rpgs at the grond near the player APC
    a_structs = struct::get_array( "tunnel_vtol_target_2", "targetname" );
    for( i=0; i<5; i++ )
    {
        v_dir = AnglesToforward( self.angles );
        v_start_pos = self.origin + (v_dir * 20.0);
        
        v_target_pos = a_structs[i].origin;

        self thread apc_shared::fire_missile_at_struct( v_start_pos, v_target_pos );
        wait( 0.2 );
    }        
    
    level flag::wait_till( "player_in_tunnel" );
    
    self Delete();
    
}

function rocket_impacts()
{
    level waittill( "rpg_hits_floor" );

    // Create a screen shake when the rpgs hit the floor
    for( i=0; i<4; i++ )
    {
        Earthquake( 0.65, 0.65, level.apc.origin, 400 );
        wait( 0.25 );
    }        
}

//*****************************************************************************
//*****************************************************************************

function rail_tunnel_enterance_destruction()
{
    level endon( "tunnel_blocker_shot" );
    
    a_blockers = GetEntArray( "apc_tunnel_blocker", "targetname" );

    a_triggers = [];
    a_triggers[ a_triggers.size ] = "enter_tunnel_damage_trigger_1";
    a_triggers[ a_triggers.size ] = "enter_tunnel_damage_trigger_2";
    a_triggers[ a_triggers.size ] = "enter_tunnel_damage_trigger_3";
    a_triggers[ a_triggers.size ] = "enter_tunnel_damage_trigger_4";
    a_triggers[ a_triggers.size ] = "enter_tunnel_damage_trigger_5";
    level thread apc_shared::shoot_physics_object( a_triggers );

    // Wait for the APC to hit the entrance trigger - in case the player does not shoot
    trig_enter_tunnel_damage_failsafe = GetEnt( "enter_tunnel_damage_failsafe", "targetname" );
    trig_enter_tunnel_damage_failsafe waittill( "trigger" );

    velocity = 250.0;
    earthquake_size = 0.5;
    num_shakes  = 2;
    apc_shared::physics_collision_with_ents( a_blockers, velocity, earthquake_size, num_shakes, undefined, undefined );
}


//*****************************************************************************
//*****************************************************************************
// Robot attacker that crawls on vehicle
//*****************************************************************************
//*****************************************************************************

function create_robot_apc_crawler( priority )
{
    create = 0;

    if( !priority )
    {
        time = gettime();
        dt = ( time - level.last_crawler_time ) / 1000.0;
        if( dt > 10 )
        {
            create = 1;
        }
    }

    if( priority || create )
    {
        level.last_crawler_time = time;

        if( !IsDefined(level.robot_attacker_index) )
        {
            level.robot_attacker_index = 0;
        }

        switch( level.robot_attacker_index )
        {
            case 0:
                str_scene = "cin_pro_16_02_apc_vign_attach_robot_left";
            break;

            default:
                str_scene = "cin_pro_16_02_apc_vign_attach_robot_right";
            break;
        }

        level.robot_attacker_index++;
        if( level.robot_attacker_index > 1 )
        {
            level.robot_attacker_index = 0;
        }

        sp_robot = GetEnt( "robot_crawling_on_apc", "targetname" );
        e_ent = sp_robot spawner::spawn();

        e_ent thread robot_horde::robot_eye_fx_on();    
        
        level thread scene::play( str_scene );
        e_ent.attack_scene = str_scene;
        //e_ent.allowPain = false;
        //wait( 0.1 );
        //e_ent.overrideActorDamage = &callback_robot_apc_crawler;


// TODO: Should be hendricks
        level.players[0] thread dialog::say( "hend_we_got_one_on_the_tr_0", 1 );


        create = 1;
    }

    return( create );
}

function callback_robot_apc_crawler( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, modelIndex, psOffsetTime, boneName, vSurfaceNormal )
{
    //iDamage = 0;

    if ( !IsDefined(self.alreadyLaunched) )
    {
        self.alreadyLaunched = true;
        self thread kill_robot_crawler( AnglesToForward( eInflictor.angles ) );
    }        

    return( iDamage );
}

// self = robot
function kill_robot_crawler( v_forward )
{
    self endon( "death" );

    wait( 0.1 );

    if( scene::is_active(self.attack_scene) )
    {
        scene::stop( self.attack_scene );
    }
    
    wait( 0.1 );

    self StartRagdoll( true );
    xvel = randomfloatrange( -50, 50 );
    v_launch = ( xvel, 0, randomfloatrange(40, 140) );
    v_launch += v_forward * 600;
    self LaunchRagdoll( v_launch, "J_SpineUpper" );
}


#namespace apc_shared;


//*****************************************************************************
//*****************************************************************************

// self = apc
function init_apc()
{
	self.overrideVehicleDamage = &apc_shared::callback_apc_damage;

	// Initialize the player potential gunner positions
	self.player_turret_slots = [];
	self.player_turret_slots[ self.player_turret_slots.size ] = 0;		// dummy ( player seat )
	self.player_turret_slots[ self.player_turret_slots.size ] = 0;		// gunner1
	self.player_turret_slots[ self.player_turret_slots.size ] = 0;		// gunner2
	self.player_turret_slots[ self.player_turret_slots.size ] = 0;		// gunner3
	self.player_turret_slots[ self.player_turret_slots.size ] = 0;		// gunner4

	// Initialize the ai potential gunner positions
	self.ai_turret_slots = [];
	self.ai_turret_slots[ self.ai_turret_slots.size ] = 0;		// dummy ( player seat )
	self.ai_turret_slots[ self.ai_turret_slots.size ] = 0;		// gunner1
	self.ai_turret_slots[ self.ai_turret_slots.size ] = 0;		// gunner2
	self.ai_turret_slots[ self.ai_turret_slots.size ] = 0;		// gunner3
	self.ai_turret_slots[ self.ai_turret_slots.size ] = 0;		// gunner4
}

//*****************************************************************************
//*****************************************************************************

function setup_apc_on_rail( str_node_start, get_on_rail )
{
	// Spawn in APC and set APC damage callback
	//level.apc = vehicle::simple_spawn_single( "vehicle_apc_hijack" );
	
	//spawned by animation
	level.apc = GetEnt("apc", "animname");
	
	level.apc apc_shared::init_apc();
	
	level.apc MakeVehicleUnusable();
   
	// Need to attach the vehicle to the path before we drive, otherwise we get a big screen glitch
	// Using drivepath will remove the glitch but drive path uses physics to go down the path, which we don't wan
	
	wait_for_all_players_to_enter_apc();
	
	//set up player joined callback
	
	if( get_on_rail )
	{
		nd_start = GetVehicleNode( str_node_start, "targetname" );
		level.apc thread vehicle::get_on_path( nd_start );
	}
}

//*****************************************************************************
//*****************************************************************************

function wait_for_all_players_to_enter_apc()
{
	// Wait for all players to enter the vehicle
	level.num_players_inside_apc = 0;
	
	while( 1 )
	{
		if ( level.num_players_inside_apc >= level.players.size )
		{
			break;
		}
		
		wait 0.05;
	}
	
	level flag::set( "players_are_in_apc" );
}

// self == player
function turret_overheat_hud(turret_index)
{
	n_heat = 0;
	n_overheat = 0;
	
	while( true )
	{
		if ( isDefined( self.viewlockedentity ) )
		{
			n_oldheat = n_heat;
			n_heat = self.viewlockedentity GetTurretHeatValue( turret_index );

			n_old_overheat = n_overheat;
			n_overheat = self.viewlockedentity IsVehicleTurretOverheating( turret_index );

			if ( n_oldheat != n_heat || n_old_overheat != n_overheat )
			{
				if ( isdefined( self.turret_menu ) )
				{
					self SetLUIMenuData( self.turret_menu, "frac", n_heat/100 );
				}
			}
		}

		{wait(.05);};
	}
}


//*****************************************************************************
//*****************************************************************************
// self = player
function player_enters_apc( trigger_index )
{	
	//I activate the triggers via script_int based on number of players, but their script_int != turret index!
	//Play the enter APC animation
	switch( trigger_index )
	{
		case 1:
			level.apc scene::play( "cin_pro_15_01_opendoor_1st_mount_player04", self );		// rear left - 
			turret_index = 3;
		break;
		
		case 2:
			level.apc scene::play( "cin_pro_15_01_opendoor_1st_mount_player02", self );		// front left
			turret_index = 1;		
		break;

		case 3:
			level.apc scene::play( "cin_pro_15_01_opendoor_1st_mount_player03", self );		// rear right		
			turret_index = 4;
		break;

		case 4:
		default:
			level.apc scene::play( "cin_pro_15_01_opendoor_1st_mount_player01", self );		// front right	
			turret_index = 2;
		break;
	}
	
	//without this wait the player won't enter the apc after the animation
	wait 0.05;
	
	self thread player_attach_to_apc( level.apc, turret_index );
	
	ArrayRemoveValue( level.a_gunner_pos, level.a_gunner_pos[ turret_index-1 ] );
}

//self is player
function player_attach_to_apc( vh_apc, turret_index )
{
	level.num_players_inside_apc++;	
	level.apc.player_turret_slots[ turret_index ] = 1;
	self.turret_index = turret_index;  
	self.overridePlayerDamage = &apc_shared::callback_player_damage_inside_vehicle;
	
	vh_apc UseVehicle( self, turret_index );		// 0 = driver, 1 = gunner
	
	self.turret_menu = self OpenLUIMenu( "APCTurretHUD" );
	self SetLUIMenuData( self.turret_menu, "frac", 0 );
	self thread turret_overheat_hud( turret_index );
}

//*****************************************************************************
//*****************************************************************************

function kick_players_out_of_apc()
{
	// Kick players out of Turrets
	a_players = GetPlayers();
	for( i=0; i<a_players.size; i++ )
	{
		a_players[i] kick_player_out_of_apc();
	}
	
	level.num_players_inside_apc = 0;
	level.players_using_apc = undefined;
	level notify( "cleanup_apc" );
}

//*****************************************************************************
//*****************************************************************************
// self = player
function kick_player_out_of_apc()
{	
	self.overridePlayerDamage = undefined;
	self.player_using_turret = undefined;
	self unlink();

	if ( isdefined( self.turret_menu ) )
	{
		self CloseLUIMenu( self.turret_menu );
	}
		
	if( isdefined(self.turret_index) )
	{
		level.apc.player_turret_slots[ self.turret_index ] = 0;
	}
}


function CreateClientHudText( e_player, str_message, x_off, y_off, font_scale )
{
	font_color = ( 1.0, 1.0, 1.0 );
	
	hud_elem = e_player __create_client_hud_elem( "center", "middle", "center", "top", x_off, y_off, font_scale, font_color, str_message );
				 
	return( hud_elem );
}

// self = the player
function __create_client_hud_elem( alignX, alignY, horzAlign, vertAlign, xOffset, yOffset, fontScale, color, str_text )
{
	hud_elem = NewClientHudElem( self );
	hud_elem.elemType = "font";
	hud_elem.font = "objective";
	hud_elem.alignX = alignX;
	hud_elem.alignY = alignY;
	hud_elem.horzAlign = horzAlign;
	hud_elem.vertAlign = vertAlign;
	hud_elem.x += xOffset;
	hud_elem.y += yOffset;
	hud_elem.foreground = true;
	hud_elem.fontScale = fontScale;
	hud_elem.alpha = 1;
	hud_elem.color = color;
	hud_elem.hidewheninmenu = true;
	hud_elem SetText( str_text );
	return hud_elem;
}


//*****************************************************************************
// PLAYER APC Damage
//*****************************************************************************

function callback_apc_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	iDamage = 0;
	return iDamage;
}


//*****************************************************************************
// Player DAMAGE
//*****************************************************************************

function callback_player_damage_inside_vehicle( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, modelIndex, psOffsetTime, vSurfaceNormal )
{
//	if( IsDefined(weapon) && (weapon == "hind_minigun_enemy_pilot") )
//	{
//		iDamage = 1;
//	}
//
//	else
//	{
//		iDamage = 1;
//	}

	self endon ("end_damage_callback");
	// Don't let the APC die
	if( iDamage >= self.health )
	{
		iDamage = self.health - 10;
		if( iDamage < 0 )
		{
			iDamage = 0;
		}
	}

		
	return iDamage;	
}


//*****************************************************************************
// 3D Use markers on the APC, one for each player
//*****************************************************************************

function manage_apc_3d_use_waypoints()
{
	// Setup trigger checks for players to enter the turret
	a_trigger = GetEntArray( "t_enter_apc", "targetname" );
	array::run_all(a_trigger, &TriggerEnable, false);
	
	level.a_gunner_pos = Array( "gunner1", "gunner2", "gunner3", "gunner4" );
	
	foreach (t_trigger in a_trigger)
	{
		//removing to test all 4 seats
		//spawn a trigger for each player in the level, prioritized by their script int
		if ( level.players.size >= t_trigger.script_int )
		{
			level thread setup_apc_trigger( t_trigger );
		}
	}
}

function setup_apc_trigger( t_trigger )
{
	s_turret_pos = struct::get( t_trigger.target );
	
	if ( t_trigger.script_int == 1 || t_trigger.script_int == 3 )
	{
		objectives::set( "cp_level_prologue_grenade_turret", s_turret_pos );
	}
	else
	{
		objectives::set( "cp_level_prologue_mg_turret", s_turret_pos );
	}
	
	t_trigger TriggerEnable( true );
	t_trigger SetCursorHint( "HINT_NOICON" );
	t_trigger UseTriggerRequireLookAt();
	t_trigger SetHintString( &"CP_MI_ETH_PROLOGUE_MOUNT_APC" );
	t_trigger waittill( "trigger", e_player );
	
	objectives::hide_for_target( "cp_level_prologue_grenade_turret", s_turret_pos );
	
	e_player thread player_enters_apc( t_trigger.script_int );
	
	t_trigger Delete();
}

function ai_mount_apc()
{
	for ( i = 0; i < level.a_gunner_pos.size; i++ )  //check all MACV gunner seats
	{
		e_gunner = level.apc vehicle::get_rider( level.a_gunner_pos[i] );
		
		if ( !isdefined( e_gunner ) )
		{
			level.a_ai_allies[0] vehicle::get_in( level.apc, level.a_gunner_pos[i], true );
			
			ArrayRemoveValue( level.a_ai_allies, level.a_ai_allies[0] );
		}
	}
	
	level.a_ai_allies = [];
}


//*****************************************************************************
//*****************************************************************************

function create_objective_waypoint( str_shader, v_origin, z_offset)
{
	hud_waypoint = NewHudElem();
	hud_waypoint.horzAlign = "right";
	hud_waypoint.vertAlign = "middle";
	hud_waypoint.sort = 0;
	hud_waypoint.alpha = 1;
	hud_waypoint SetShader( str_shader, 5, 5 );
	hud_waypoint SetWaypoint( true, str_shader, false, false );
	hud_waypoint.hidewheninmenu = true;
	hud_waypoint.immunetodemogamehudsettings = true;	

	hud_waypoint.x = v_origin[0];
	hud_waypoint.y = v_origin[1];
	hud_waypoint.z = v_origin[2] + z_offset;	
	
	return hud_waypoint;
}

// self = vtol
function fire_missile_at_struct( v_start_pos, v_target_pos  )
{
	//weapon = GetWeapon( "rpg_cp" );
	weapon = level.weapons["rpg"];
	e_bullet = MagicBullet( weapon, v_start_pos, v_target_pos, self );
	e_bullet thread rgb_attack_floor( v_target_pos );
}

// self = weapon
function rgb_attack_floor( v_target_pos )
{
	self endon( "death" );

	while( 1 )
	{
		dist = distance( self.origin, v_target_pos );
		if( dist < 100 )
		{
			break;
		}
		wait( 0.05 );
	}

	PlayFX( "explosions/fx_exp_generic_lg", v_target_pos );
	PlaySoundAtPosition ( "wpn_rocket_explode" , self.origin );//missile exp sound

	level notify( "rpg_hits_floor" );
}

//*****************************************************************************
//*****************************************************************************

// self = vtol
function vtol_tunnel_exit_missile_attack()
{
	self endon( "death" );

	// Fire 5 rpgs at the grond near the player APC
	a_structs = struct::get_array( "tunnel_exit_vtol_target", "targetname" );
	for( i=0; i<5; i++ )
	{
		v_dir = AnglesToforward( self.angles );
		v_start_pos = self.origin + (v_dir * 20.0);
		
		v_target_pos = a_structs[i].origin;

		self thread apc_shared::fire_missile_at_struct( v_start_pos, v_target_pos );
		wait( 0.2 );
	}

	level waittill( "rpg_hits_floor" );

	// Create a screen shake when the rpgs hit the floor
	for( i=0; i<3; i++ )
	{
		Earthquake( 0.75, 0.75, level.apc.origin, 400 );
		wait( 0.25 );
	}
}

//*****************************************************************************
// Turn on the AI Player Turrets
//*****************************************************************************

// self = apc
function setup_apc_ai_turrets()
{
	for( i=1; i<5; i++ )
	{
		if( self.player_turret_slots[ i ] == 0 )
		{
			turret_index = i;
			self.ai_turret_slots[ turret_index ] = 1;
			self turret::enable( turret_index, false );
		}
	}
}

//*****************************************************************************
//*****************************************************************************

function setup_apc_turrets_rail_firerates( very_slow_firing )
{
	if( very_slow_firing )
	{
		for( turret_index = 1; turret_index < 5; turret_index++ )
		{
			fire_time_min = 0.01;
			fire_time_max = 0.02;
			burst_wait_min = 10.0;
			burst_wait_max = 11.0;
			level.apc turret::set_burst_parameters( fire_time_min, fire_time_max, burst_wait_min, burst_wait_max, turret_index );
		}
	}

	else
	{
		for( turret_index = 1; turret_index < 5; turret_index++ )
		{
	
			if( (turret_index == 1 ) || ( turret_index == 2) )
			{
				fire_time_min = RandomFloatRange( 0.9, 1.2 );		// 0.9, 1.2
				fire_time_max = RandomFloatRange( 1.6, 2.4 );		// 1,6, 2.4
				burst_wait_min = RandomFloatRange( 1.6, 1.9 );		// 1.0, 1.2
				burst_wait_max = RandomFloatRange( 2.4, 2.9 );		// 1.5, 1.8
				level.apc turret::set_burst_parameters( fire_time_min, fire_time_max, burst_wait_min, burst_wait_max, turret_index );
			}

			if( (turret_index == 3 ) || ( turret_index == 4) )
			{
				fire_time_min = RandomFloatRange( 0.9, 1.2 );		// 0.9, 1.2
				fire_time_max = RandomFloatRange( 1.6, 2.4 );		// 1.6, 2.4
				burst_wait_min = RandomFloatRange( 1.6, 1.9 );		// 1.0, 1.2
				burst_wait_max = RandomFloatRange( 2.4, 2.9 );		// 1.5, 1.8
				level.apc turret::set_burst_parameters( fire_time_min, fire_time_max, burst_wait_min, burst_wait_max, turret_index );
			}
		}
	}
}


//*****************************************************************************
//*****************************************************************************

function setup_apc_turrets_endfight_firerates()
{
	for( turret_index = 1; turret_index < 5; turret_index++ )
	{
		if( (turret_index == 1 ) || ( turret_index == 2) )
		{
			fire_time_min = RandomFloatRange( 0.9, 1.2 );
			fire_time_max = RandomFloatRange( 1.3, 1.8 );
			burst_wait_min = RandomFloatRange( 3.5, 3.8 );
			burst_wait_max = RandomFloatRange( 4.5, 4.9 );
			level.apc turret::set_burst_parameters( fire_time_min, fire_time_max, burst_wait_min, burst_wait_max, turret_index );
		}

		if( (turret_index == 3 ) || ( turret_index == 4) )
		{
			fire_time_min = RandomFloatRange( 0.9, 1.2 );
			fire_time_max = RandomFloatRange( 1.3, 1.8 );
			burst_wait_min = RandomFloatRange( 3.5, 3.8 );
			burst_wait_max = RandomFloatRange( 4.5, 4.9 );
			level.apc turret::set_burst_parameters( fire_time_min, fire_time_max, burst_wait_min, burst_wait_max, turret_index );
		}
	}
}


//*****************************************************************************
// NOTE: side_max and side_min are optional
//*****************************************************************************

function physics_collision_with_ents( a_blockers, velocity, earthquake_size, num_shakes, side_max, side_min )
{
	for( i=0; i<a_blockers.size; i++ )
	{
		e_ent = a_blockers[i];

		if( !IsDefined(e_ent.already_launched) )
		{
			v_dir = VectorNormalize( e_ent.origin - level.apc.origin );

			v_velocity = v_dir * velocity;

			// Add optional side velocity?
			if( IsDefined(side_min) && IsDefined(side_max) )
			{
				v_up = ( 0, 0, 1);
				v_side = vectorcross( v_dir, v_up );
				rval = RandomFloatRange( side_max, side_min );
				v_velocity += ( v_side * rval );
			}
		
			e_ent NotSolid();
			e_ent PhysicsLaunch( e_ent.origin, v_velocity );
		}
	}

	for( i=0; i<num_shakes; i++ )
	{
		Earthquake( earthquake_size, earthquake_size, level.apc.origin, 400 );
		a_players = GetPlayers();
		for( j=0; j<a_players.size; j++ )
		{
			a_players[j] PlayRumbleOnEntity( "damage_heavy" );
		}
		wait( 0.1 );
	}
}


//*****************************************************************************
//*****************************************************************************

//"enter_tunner_damage_trigger_1"

function shoot_physics_object( a_triggers )
{
	for( i=0; i<a_triggers.size; i++ )
	{
		e_trigger = GetEnt( a_triggers[i], "targetname" );
		level thread launch_if_shot( "cleanup_apc", a_triggers[i] );
	}
}


//*****************************************************************************
//*****************************************************************************

// self = trigger
function launch_if_shot( str_level_endon, str_trigger_targetname )
{
	level endon( str_level_endon );

	e_trigger = GetEnt( str_trigger_targetname, "targetname" );
	e_trigger waittill( "trigger" );

	level notify( "tunnel_blocker_shot" );
	
	// Which physics object is targetting this trigger?
	e_ent = getEnt( str_trigger_targetname, "target" );

	if( IsDefined(e_ent) && !( isdefined( e_ent.already_launched ) && e_ent.already_launched ) )
	{
		v_dir = VectorNormalize( e_ent.origin - level.apc.origin );
		v_velocity = v_dir * 250.0;
		e_ent NotSolid();
		e_ent PhysicsLaunch( e_ent.origin, v_velocity );

		e_ent.already_launched = 1;
	}
}

//handles the robots breaking into the garage
function garage_battle()
{

}

function set_fog_state(b_is_in_fog)
{
	a_team = cp_prologue_util::get_ai_allies_and_players();
	array::add(a_team, level.ai_hendricks);
	
	array::run_all(a_team, &ai::set_ignoreall, b_is_in_fog);
	array::run_all(a_team, &ai::set_ignoreme, b_is_in_fog);
	if (b_is_in_fog)
	{
		level.apc turret::disable( 1 );
		level.apc turret::disable( 2 );
		level.apc turret::disable( 3 );
		level.apc turret::disable( 4 );
	}
	else
	{
		level.apc turret::disable( 1 );
		level.apc turret::disable( 2 );
		level.apc turret::disable( 3 );
		level.apc turret::disable( 4 );
	}
		
}

