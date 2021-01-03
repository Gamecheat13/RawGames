
//
// Events 6 - 9
//
// prologue_hostage_rescue.gsc
//

#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_eth_prologue_fx;

#using scripts\cp\cp_mi_eth_prologue_sound;

#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\doors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\lui_shared;

#using scripts\cp\_skipto;
#using scripts\cp\cp_mi_eth_prologue;
#using scripts\cp\_spawn_manager;

#using scripts\cp\cp_prologue_apc;
#using scripts\cp\cp_prologue_util;
#using scripts\cp\cp_prologue_hangars;
#using scripts\shared\ai_shared;



#precache( "objective", "cp_level_prologue_rescue_the_minister" );
#precache( "objective", "cp_level_prologue_goto_minister_door" );
#precache( "objective", "cp_level_prologue_defend_khalil" );
#precache( "objective", "cp_level_prologue_goto_lift" );



//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
// EVENT 6: Hostage 1
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************


#namespace hostage_1;


function hostage_1_start( str_objective )
{
	hostage_1_precache();
	
	spawner::add_spawn_function_group( "fuel_tunnel_ai" , "script_noteworthy", &cp_prologue_util::ai_idle_then_alert, "fuel_tunnel_alerted");

	if( !IsDefined(level.ai_hendricks) )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		cp_mi_eth_prologue::init_hendricks( "skipto_hostage_1_hendricks" );
		skipto::teleport_ai( str_objective );
	}

	level flag::wait_till( "all_players_spawned" );
	
	level.ai_hendricks.ignoreme = true;
	
	level thread hostage_1_main();
}

// DO ALL PRECACHING HERE
function hostage_1_precache()
{
	level thread scene::init( "cin_pro_06_01_hostage_vign_rollgrenade");
}

// Event Main Function
function hostage_1_main()
{	
	//spawn in the initial guys
	spawn_manager::enable( "sm_fuel_tunnel" );
	spawner::simple_spawn( "sp_fuel_depot_staging");
	
	//open spawning door
	m_door_r = GetEnt( "fueltunnel_spawnclosetdoor_1", "targetname" );
	m_door_r RotateTo( m_door_r.angles + (0, -150, 0), 0.5 );
		
	level thread spawn_machine_gunner();
	
	level thread fuel_tunnel_reinforcements();

	objectives::set( "cp_level_prologue_rescue_the_minister" );

	// Hendricks movement through the event
	level thread hendricks_hostage_1_update();
		
	//...
	trigger::wait_till( "hendricks_rollgrenade" );
	
	// Fires off fuel_tunnel_alert when a player fires
	array::thread_all( level.players, &watch_player_fire );
	
	// Wait for the truck explosion	
	level waittill( "truck_explodes" );
	
	//damage radius around truck
	orig_explosion = GetEnt("orig_fuel_tunnel_explosion", "targetname");
	const radius = 300;
	const min_damage = 2000;
	const max_damage = 2000;
	level.ai_hendricks radiusDamage( orig_explosion.origin, radius, max_damage, min_damage, undefined, "MOD_EXPLOSIVE" );

	// TODO: put a stun/wait on AI here
	level flag::set( "fuel_tunnel_alerted" );

	//...
	level thread fuel_depot_enemies_dead();
	
	// Wait until all enemies are dead, or player moves to top of stairs
	level flag::wait_till( "fuel_room_end" );
	
	skipto::objective_completed( "skipto_hostage_1" );
}


//*****************************************************************************
//*****************************************************************************

function hendricks_hostage_1_update()
{
	// Move Hendricks to the area
	trigger::use( "t_color_red_501" );
	
	trigger::wait_till( "hendricks_rollgrenade" );
	
	level thread hend_fuel_depot_OTR_dialog();
	
	// hendrick roll the generade animation
	level thread scene::play( "cin_pro_06_01_hostage_vign_rollgrenade", level.ai_hendricks );
	
	level waittill("truck_explodes");
	
	node = GetNode( "hendricks_post_grenade_node", "targetname" );
	level.ai_hendricks ai::force_goal( node, 64, true, undefined, true );
	level.ai_hendricks ai::set_pacifist(false);
	level.ai_hendricks ai::set_ignoreme(false);
	level.ai_hendricks ai::set_ignoreall(false);
	
	level thread fuel_depot_door_handler();
}

//*****************************************************************************
//*****************************************************************************

function fuel_depot_door_handler()
{
	// Wait until all enemies are dead, or player moves to top of stairs
	level flag::wait_till("fuel_depot_upstairs");
	
	//move hendricks to the door
	n_node = GetNode("hendricks_fuel_depot_door", "targetname");
	level.ai_hendricks.goalradius = 16;
	level.ai_hendricks SetGoal( n_node, true );
	level.ai_hendricks waittill( "goal" );	
	
	//open the door
	wait .5; //replace with anim when we get it , holdingcells_entrydoor_2
	m_door1 = GetEnt("holdingcells_entrydoor_1", "targetname");
	m_door1 Movex(64, 1, .1, .2);
	wait .5; //pacing
	m_door2 = GetEnt("holdingcells_entrydoor_2", "targetname");
	m_door2 Movex(64, 1, .1, .2);
	m_door2 waittill( "movedone" );
	
	n_node = GetNode("hendricks_jail_setup", "targetname");
	level.ai_hendricks SetGoal( n_node, true );
}




//*****************************************************************************
//*****************************************************************************

function watch_player_fire()
{
	//wait til player fires
	self endon ("death");
	self waittill( "weapon_fired" );
	level flag::set( "fuel_tunnel_alerted" );
}

function fuel_tunnel_reinforcements()
{
	//spawn in reinforcements as guys die in the tunnel
	spawn_manager::wait_till_ai_remaining("sm_fuel_tunnel", 4);
	spawn_manager::enable( "sm_fuel_tunnel_backup" );
}

function hend_fuel_depot_OTR_dialog()
{
	level.ai_hendricks dialog::say( "hend_no_choice_but_to_go_0" ); //No choice but to go loud now - Stay back.
}
	
// Spawn in guys part2
function spawn_machine_gunner()
{
	trigger::wait_till ("t_spawn_machine_gunner");
	
	spawner::simple_spawn_single("fuel_tunnel_mg_guy");
	
	wait 1;//wait for guy to show up before dialog
	
	level.ai_hendricks dialog::say( "Machine gunner! Take him out" );
}


//*****************************************************************************
//*****************************************************************************

function fuel_depot_enemies_dead()
{
	spawner::waittill_ai_group_cleared("aig_fuel_tunnel");
	level flag::set("fuel_depot_upstairs");

}

//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
// EVENT 7: Prison
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************


#namespace prison;

function prison_start( str_objective )
{
	prison_precache();	

	if( !IsDefined(level.ai_hendricks) )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		cp_mi_eth_prologue::init_hendricks( "skipto_prison_hendricks" );
		skipto::teleport_ai( str_objective );
	}

	
	// Spawn in the Minister
	if( !IsDefined(level.ai_minister) )
	{
		level.ai_minister = util::get_hero( "minister" );
		level.ai_minister.ignoreme = true;
		level.ai_minister.ignoreall = true;
		cp_mi_eth_prologue::init_minister( "skipto_prison_minister" );
		level.ai_minister.goalradius = 64;
	}

	// Spawn in Khalil
	if( !IsDefined(level.ai_khalil) )
	{
		level.ai_khalil = util::get_hero( "khalil" );
		level.ai_khalil.ignoreme = true;
		level.ai_khalil.ignoreall = true;
		cp_mi_eth_prologue::init_khalil( "skipto_prison_khalil" );
		level.ai_khalil.goalradius = 64;
	}

	level flag::wait_till( "all_players_spawned" );
	
	level.ai_hendricks.pacifist = false;
	level.ai_hendricks.ignoreme = false;
	
	level thread prison_main();
}

// DO ALL PRECACHING HERE
function prison_precache()
{
	
}

// Event Main Function
function prison_main()
{

	// Messages from unknown prisoners

	level thread prisoner_dialog();
	//set up minister interview
	
	if (scene::is_playing("cin_pro_05_02_securitycam_pip_minister"))
	{
		level thread scene::stop("cin_pro_05_02_securitycam_pip_minister");
	}
	level thread scene::play("cin_pro_06_03_hostage_vign_interview");

	// Main function for the level
	level.ai_hendricks thread hendricks_update();

}

//*****************************************************************************
//*****************************************************************************

// Hendricks breaks into the Ministers cell
// self = Hendricks
function hendricks_update()
{
	// Hide Khalil cell trigger
	trig_khalil_door = GetEnt( "trig_use_khalil_door", "targetname" );
	trig_khalil_door TriggerEnable(false);
	
	//show door objective 
	s_pos = struct::get( "s_objective_minister_cell", "targetname" );
	objectives::set( "cp_level_prologue_goto_minister_door", s_pos );	

	// Wait for the player to open the door
	level thread door_breach();
	
	// Force Hendricks to the door open position
	nd_node = GetNode( "hendricks_minister_cell_node", "targetname" );
	self.goalradius = 48;
	self setgoalpos( nd_node.origin );
	
	//wait til hendricks is in position
	self waittill( "goal" );	
	
	// If player hasn't opened the door, play the reminder scene
	level thread scene::play( "cin_pro_06_01_hostage_vign_reminder" );
	
	//wait til player breaches
	level flag::wait_till("player_entered_observation");//fired off at end of cin_pro_06_02_hostage_1st_open
	
	level thread minister_interrogation_dialog();

	//complete objective
	objectives::complete( "cp_level_prologue_goto_minister_door" );
	

	// We want the player to look around the room so.....
	// Now wait either X seconds or until the player fires
	prologue_util::setup_player_firing_callback( &prologue_util::player_fires, undefined );
	
	level thread hendricks_countdown_dialog();

	start_time = gettime();
	while( 1 )
	{
		time = gettime();

		dt = ( time - start_time ) / 1000.0;
		if( (dt > 3) || (( isdefined( level.player_has_fired ) && level.player_has_fired )) )
		{
			break;
		}
		
		wait( 0.05 );
	}

	// Open cell exit (double) door and send Hendricks and the minister to Khalils cell
	a_doors = struct::get_array( "prologue_cells_minister_exit", "targetname" );
	for( i=0; i<a_doors.size; i++ )
	{
		[[a_doors[i].c_door]]->unlock();
		[[a_doors[i].c_door]]->open();
	}


	
	objectives::complete( "cp_level_prologue_rescue_the_minister" );
		
	// TODO: need new animation 
	level thread scene::play( "cin_pro_06_02_hostage_vign_kick" );		
	level scene::play( "cin_pro_06_02_hostage_vign_kick_hendricks" );
	
	a_ais = GetAITeamArray( "axis", "axis" );
	for( i=0; i<a_ais.size; i++ )
	{
		a_ais[i] kill();

	}
			
	//Animate Hendricks, Minister and Khalil to the end of the event
	level thread scene::play( "cin_pro_06_03_hostage_1st_khalil_intro_start" );
	
	level waittill("khalil_available"); // fired off in a notetrack from cin_pro_06_03_hostage_1st_khalil_intro_start
	
	s_pos = struct::get( "s_objective_khalil_cell", "targetname" );
	objectives::set( "cp_level_prologue_goto_minister_door", s_pos );	

	// Wait for the PLAYER to open the door
	trig_khalil_door TriggerEnable(true);
	trig_khalil_door SetCursorHint( "HINT_NOICON" );
	trig_khalil_door UseTriggerRequireLookAt();
	trig_khalil_door SetHintString( "Press and Hold ^3[{+activate}]^7 to Use door" );	
	trig_khalil_door waittill( "trigger", e_player );
	trig_khalil_door Delete();
	
	objectives::complete( "cp_level_prologue_goto_minister_door" );
	
	
	//play anims on player et al
	level thread scene::play( "cin_pro_06_03_hostage_1st_khalil_intro_player_rescue", e_player );
	level thread scene::play( "cin_pro_06_03_hostage_1st_khalil_intro_rescue" );

	//wait til cinematic is over
	level waittill("hendricks_by_weapon_room"); //notetrack fired in cin_pro_06_03_hostage_1st_khalil_intro_rescue
		
	skipto::objective_completed( "skipto_prison" );
}

function hendricks_countdown_dialog()
{
	level endon( "player_weapon_fired" );
	
	//wait 3;
		
	// Hendricks gives a small countdown
}

function minister_interrogation_dialog()
{
	level.ai_hendricks dialog::say( "hend_with_the_alarms_down_0" );
}

//Cutting the door
function door_breach()
{
	// Wait for the PLAYER to open the door
	trig_use_minister_door = GetEnt( "trig_use_minister_door", "targetname" );
	trig_use_minister_door TriggerEnable(true);
	trig_use_minister_door SetCursorHint( "HINT_NOICON" );
	trig_use_minister_door UseTriggerRequireLookAt();
	trig_use_minister_door SetHintString( "Press and Hold ^3[{+activate}]^7 to Use door" );	
	trig_use_minister_door waittill( "trigger", e_player );
	trig_use_minister_door Delete();
	
	//move the doo

	// Play the door cutter animation
	scene::play( "cin_pro_06_02_hostage_1st_cut", e_player );
	scene::play( "cin_pro_06_02_hostage_1st_open", e_player );
	
	//move the door
	door_r = GetEnt( "prologue_cells_minister_enter", "targetname" );
	door_r RotateTo( door_r.angles + (0, -120, 0), 0.5 );
	
	
}


function open_security_room_door()
{
	s_door_left = struct::get( "door_enter_security_room_left", "targetname" );
	[[s_door_left.c_door]]->unlock();
	[[s_door_left.c_door]]->open();
	s_door_right = struct::get( "door_enter_security_room_right", "targetname" );
	[[s_door_right.c_door]]->unlock();
	[[s_door_right.c_door]]->open();
}

function prisoner_dialog()
{
	level thread cell_prisoner_message_update( "trig_volume_prisoner1_cell", "pris_please_please_help_0" );
	level thread cell_prisoner_message_update( "trig_volume_prisoner2_cell", "pris_get_us_out_of_here_0" );
	level thread cell_prisoner_message_update( "trig_volume_prisoner3_cell", "pris_don_t_leave_me_here_0" );
	level thread cell_prisoner_message_update( "trig_volume_prisoner4_cell", "pris_please_help_us_0" );
}

// Messages when you approach locked cell doors
// - NOTE: str_scene is an optional scene to play
function cell_prisoner_message_update( str_trigger, str_VO )
{
	level trigger::wait_till(str_trigger, "targetname", undefined, false);
	level.ai_hendricks dialog::say(str_VO);
}


function security_desk_reacts(str_scene)
{
	trigger::wait_till( "t_wakeup_desk_guard" );
	if( level scene::is_active( str_scene )  )
	{
		level thread scene::stop( str_scene );
	}
		
	if( IsDefined( level.ai_guard ) )
	{
		level.ai_hendricks  thread ai::shoot_at_target( "shoot_until_target_dead" , level.ai_guard );
	}
}

//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
// EVENT 8: Security Desk
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************


#namespace security_desk;


function security_desk_start( str_objective )
{
	security_desk_precache();

	//if we're in skip to
	if( !IsDefined(level.ai_hendricks) )
	{
		//add skipto struct names
		level.ai_hendricks = util::get_hero( "hendricks" );
		cp_mi_eth_prologue::init_hendricks("skipto_security_desk_hendricks");

		level.ai_minister = util::get_hero( "minister" );
		cp_mi_eth_prologue::init_minister("skipto_security_desk_minister");
		level.ai_minister ai::set_ignoreme(true);
		level.ai_minister ai::set_ignoreall(true);

		level.ai_khalil = util::get_hero( "khalil" );
		cp_mi_eth_prologue::init_khalil("skipto_security_desk_khalil");
		level.ai_khalil ai::set_ignoreme(true);

		//this sets up the spawning of the security desk guards
		level thread setup_security_guard();
		
		//force base alarm
		level thread cp_prologue_util::base_alarm_goes_off();

		//prison::open_security_room_door();
	}

	spawner::add_spawn_function_group( "bridge_attacker" , "script_noteworthy", &hangar::ai_think);
	
	level thread security_desk_main();
}

// DO ALL PRECACHING HERE
function security_desk_precache()
{
	
}


//*****************************************************************************
//*****************************************************************************

// Event Main Function
function security_desk_main()
{
	//spawn in ai buddies if needed
	level flag::wait_till( "all_players_spawned" );    
	
	level thread scene::skipto_end( "cin_pro_06_03_hostage_1st_khalil_intro_rescue");
	
	//wait til player moves up to the staircase
	trig_weapon_room_door = GetEnt( "trig_open_weapons_room", "targetname" );
	trig_weapon_room_door TriggerEnable(true); //made invisible in the fuel depot skipto
	level flag::wait_till("open_weapons_room");
	
	level thread scene::stop( "cin_pro_06_03_hostage_1st_khalil_intro_rescue");
	
	level thread cp_prologue_util::base_alarm_goes_off();
	
	//play hendricks et al down the stairs
	level thread scene::play( "cin_pro_07_01_securitydesk_vign_weapons_main");

	//send the minister and khalil and hendricks on a color chain
	level.ai_hendricks clearforcedgoal();
	trigger::use("trig_armory_color");
    
    thread bioweapon_objective_handler();
    //thread close_prison_area_door(); TODO: implement this right, waiting for players to enter first
    
	//thread the script for the next section in case the player rushes ahead
	level thread trigger_lift_battle_early_check();
	
	//make the guards stay up front
	wait 3;
	level.e_bio_goal_volume = GetEnt( "v_bioweapons_enemy_goal", "targetname");
	a_spawners = GetEntArray( "aig_bioweapons", "script_aigroup" );
	foreach (sp in a_spawners)
	{
		sp spawner::add_spawn_function( &cp_prologue_util::set_goal_volume, level.e_bio_goal_volume );
	}
	
	//Activate the spawn manager and individual spawners
	str_khalil_bioweapon_attackers = "khalil_bioweapon_attackers";
	cp_mi_eth_prologue::DeleteGroupAddSpawners( str_khalil_bioweapon_attackers );
	
	spawn_manager::enable( "sm_khalil_bioweapon_attackers" );
	
	sp_vaulter = GetEnt ("sp_weapons_room_vaulter", "targetname");
	sp_vaulter spawner::spawn();
	sp_rusher = GetEnt ("sp_weapons_room_shotgun", "targetname");
	sp_rusher spawner::spawn();

	// TODO:Wait for animation to complete

	// Found weapon message
	wait 15;
	level thread found_weapon_message();
	level thread scene::play( "cin_pro_07_01_securitydesk_vign_weapons_end");
	
	// End event
	skipto::objective_completed( "skipto_security_desk" );
}

function close_prison_area_door()
{
	trigger::wait_till( "trig_prison_area_door" );
	
	prison_door = GetEnt( "prison_area_door", "targetname" );
	prison_door rotateto( prison_door.angles + (0, -112, 0), 0.1 );
}

// self = Khalil
function find_weapon_animation()
{
	level thread need_weapon_message();
	self scene::play( "cin_pro_07_01_securitydesk_vign_retrieve", self );
}

function need_weapon_message()
{
	// Khalil has found his weapon
	level.ai_khalil thread dialog::say( "khal_i_need_to_get_my_wea_0" );
}
	
function found_weapon_message()
{
	// Khalil has found his weapon
	level notify("found_weapon");
	
	level.ai_khalil dialog::say( "Found the weapon, let's move on." );
}


function trigger_lift_battle_early_check()
{
	trigger::wait_till("t_trigger_lift_battle_early_check", undefined, undefined, false);

	//make sure these guys don't push too far up with goal volumes
	level.str_guard_lift = "guard_lift";
	a_lift_spawner = GetEntArray (level.str_guard_lift, "targetname");
	level.e_lift_goal_volume = GetEnt( "v_lift_room_volume", "targetname");
	foreach (sp_spawner in a_lift_spawner)
	{
		sp_spawner spawner::add_spawn_function( &cp_prologue_util::set_goal_volume, level.e_lift_goal_volume );
	}
	cp_mi_eth_prologue::DeleteGroupAddSpawners( level.str_guard_lift );
	spawn_manager::enable( "sm_guard_lift" );

	// send a guy to the bridge
	a_spawners = GetEntArray( "sp_stairs_guy_wave1", "targetname" );
	for( i=0; i<a_spawners.size; i++ )
	{
		a_spawners[i]spawner::spawn();
	}
	
	//Start up elevator guard checks
	level thread lift_escape::lift_reinforcement_handler();
	
	//send the second set of stairs guys
	trigger::wait_till("t_move_ai_buddies_bridge", undefined, undefined, false);
	// send next wave to the bridge
	a_spawners = GetEntArray( "sp_stairs_guy_wave2", "targetname" );
	foreach (sp_spawner in a_spawners)
	{
		sp_spawner spawner::spawn();
	}
	
	level thread fxanim_celling_crane();
}

function fxanim_celling_crane()
{
	level scene::play( "p7_fxanim_cp_prologue_ceiling_underground_crane_bundle" , "scriptbundlename" );
}

//TODO: Put this into the util namespace
function get_ai_count( str_targetname)
{
	a_ai = util::get_ai_array( str_targetname, "targetname" );	
	num_alive = 0;
	if(isdefined(a_ai))
	{
		for (i = 0; i< a_ai.size; i++)
		{
			e_ai = a_ai[i];
			if (IsAlive(e_ai))
			{
				num_alive++;
			}
			
		}
	}
	
	return num_alive;
}

function bioweapon_objective_handler()
{
	objectives::set( "cp_level_prologue_defend_khalil" , level.ai_khalil );
	
	//complete defend, set up move to elevator objective
	level waittill( "found_weapon" );
	
	objectives::complete( "cp_level_prologue_defend_khalil" );
	
	lift_escape::lift_objective_handler();
}

// self = level
function setup_security_guard()
{
	//Spawn some guards to defend the security desk area
	a_spawners = GetEntArray( "guard_security_desk", "targetname" );
	for( i=0; i<a_spawners.size; i++ )
	{
		a_spawners[i] spawner::add_spawn_function( &cp_prologue_util::ai_low_goal_radius );
		a_spawners[i] spawner::spawn();
	}
	
}



//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
// EVENT 8: Lift Escape
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************


#namespace lift_escape;


function lift_escape_start( str_objective )
{
	lift_escape_precache();

	if( !IsDefined(level.ai_hendricks) )
	{
		thread lift_objective_handler();
			
		level.ai_hendricks = util::get_hero( "hendricks" );
		cp_mi_eth_prologue::init_hendricks();
		level.ai_hendricks.goalradius = 16;

		level.ai_minister = util::get_hero( "minister" );
		cp_mi_eth_prologue::init_minister();
		level.ai_minister ai::set_ignoreme(true);
		level.ai_minister ai::set_ignoreall(true);

		level.ai_khalil = util::get_hero( "khalil" );
		cp_mi_eth_prologue::init_khalil();
		level.ai_khalil ai::set_ignoreme(true);
		

		skipto::teleport_ai( str_objective );

		//Most of the heavy lifting for the AI happens in this thread
		level thread security_desk::trigger_lift_battle_early_check();
	}

	level thread lift_escape_main();
}

// DO ALL PRECACHING HERE
function lift_escape_precache()
{
	flag::init("lift_arrived");
}

// Event Main Function
function lift_escape_main()
{	
	//spawn in ai buddies if needed
	level flag::wait_till( "all_players_spawned" );    
    
	

	level.player_lift_clip = GetEnt( "player_lift_clip", "targetname" );
	level.player_lift_clip Notsolid();

	// If the enemy hasn't been triggered by the previous event, trigger them
	e_trigger = GetEnt( "t_trigger_lift_battle_early_check", "targetname" );
	if( IsDefined(e_trigger) )
	{
		e_trigger notify( "trigger" );
	}

	//set up a trigger in case the player rushes forward
	level thread player_at_elevator();
	
	// Wait for all the bad guys to be killed and the lift to arrive
	wait( 1 );
	spawner::waittill_ai_group_cleared("aig_lift_defenders");
	spawn_manager::wait_till_cleared("sm_guard_lift");
	flag::wait_till("lift_arrived");
		
	level thread send_hendricks_to_lift();
	
	// Send Khalil and Minister to the open lift start positions
	level thread send_minister_and_khalil_to_lift();

	level thread lift_escape_battle();
	
	// Head to the elevator message
	level thread hend_lift_battle_OTR_dialog();
	
	level thread lift_escape_cleanup();

	// Wait for the team to get inside the lift - BLOCKING
	level setup_lift();
	
	// End event
	skipto::objective_completed( "skipto_lift_escape" );
}


//*****************************************************************************
//*****************************************************************************

function setup_lift()
{
	//wait for khalil/min to get in
	level waittill("khalil_at_lift");
	wait .5; // wait to make sure they're in
	
	// Blocking: Wait for the players to get into position to use the lift
	e_volume = getent( "info_lift_volume", "targetname" );
	a_allies = GetPlayers();
	array::add(a_allies, level.ai_hendricks);
	array::wait_till_touching(a_allies, e_volume);	
	
	level.player_lift_clip Solid();
	
	level thread scene::play( "cin_pro_08_01_liftescape_vign_groupmove_pushbutton" );
	
	//need to kick minister out of this anim or he won't go up lift
	level scene::stop("cin_pro_08_01_liftescape_vign_groupmove");

	//TODO: have them crouch down or something
	
	level notify("lift_is_moving");
	
	//clientfield::set( "light_lift_panel_green_on", 1 );

	// Close the lift door
	e_lift_door = GetEnt( "lift_door", "targetname" );
	e_lift_door playsound ( "evt_freight_elev_door_start" );
	snd_door = spawn( "script_origin", (e_lift_door.origin));
	snd_door linkto (e_lift_door);
	snd_door playloopsound ( "evt_freight_elev_door_loop" );
	v_up = ( 0, 0, 1 );
	v_dest = ( e_lift_door.origin + v_up * -100 );
	move_time = 1;
	e_lift_door MoveTo( v_dest, move_time );
	e_lift_door waittill( "movedone" );
	
	e_lift_door playsound ("evt_freight_elev_door_stop");
	
	level thread spawn_lift_enemies();
	
	//make sure these guys stay in place
	level.ai_minister.goalradius = 16;
	level.ai_minister.goalheight = 1600;
	level.ai_minister setgoal(level.ai_minister.origin);
	level.ai_khalil.goalradius = 16;	
	level.ai_khalil.goalheight = 1600;
	level.ai_khalil setgoal(level.ai_khalil.origin);
	
	// Move the lift
	snd_door stoploopsound ( .1 );
	level.e_lift = getent( "freight_lift", "targetname" );
	level.e_lift playsound ("evt_freight_lift_start");
	snd_lift = spawn( "script_origin", (level.e_lift.origin));
	snd_lift linkto (level.e_lift);
	snd_lift playloopsound ( "evt_freight_lift_loop" );
	// Link the lifts door to the lift
	e_lift_door LinkTo( level.e_lift );
	level.e_lift SetMovingPlatformEnabled( true );
	v_up = ( 0, 0, 1 );
	lift_height = 460;
	move_time = 20;
	v_lift_destination = (level.e_lift.origin + v_up * lift_height );
	level.e_lift MoveTo( v_lift_destination, move_time );

	// Wait for the lift to get to the destination
	level.e_lift waittill( "movedone" );
	snd_lift stoploopsound ( .1 );
	level.e_lift playsound ("evt_freight_lift_stop");
	level.e_lift SetMovingPlatformEnabled( false );
	level notify( "lift_is_moved" );
	
	//link up lift traversal nodes to exit the lift
	nd_lift_traversal = GetNode( "ms_lift_exit1_begin", "targetname" );
	LinkTraversal( nd_lift_traversal );
	nd_lift_traversal = GetNode( "ms_lift_exit2_begin", "targetname" );
	LinkTraversal( nd_lift_traversal );
	nd_lift_traversal = GetNode( "ms_lift_exit3_begin", "targetname" );
	LinkTraversal( nd_lift_traversal );
	nd_lift_traversal = GetNode( "ms_lift_exit4_begin", "targetname" );
	LinkTraversal( nd_lift_traversal );
}

//*****************************************************************************
//*****************************************************************************

function lift_escape_battle()
{
	trigger::wait_till("t_lift_interior", undefined, undefined, false);
	
	// Spawn in guys attacking at the back of the elevator
	level.str_guards_at_elevator = "guards_at_elevator";
	cp_mi_eth_prologue::DeleteGroupAddSpawners( level.str_guards_at_elevator );
	spawn_manager::enable( "sm_guards_at_elevator" );
	
	
}

function spawn_lift_enemies()
{
	//start the second wave spawning, turn down their accuracy
	a_spawners = GetEntArray( "inaccurate_elevator_guys", "script_noteworthy" );
	foreach (sp in a_spawners)
	{
		sp spawner::add_spawn_function( &adjust_ai_accuracy );
	}
	spawn_manager::disable( "sm_guards_at_elevator", true );
	spawn_manager::enable( "sm_guards_at_elevator_wave2" );
	wait 3;
	spawn_manager::enable( "sm_guards_at_elevator_wave3" );
	
}
//*****************************************************************************
//*****************************************************************************

function lift_escape_cleanup()
{
	level waittill( "lift_is_moved" );

	wait( 2 );

	// Clean up enemy soldiers
	thread hangar::cleanup( "sm_guards_at_elevator_wave3", "elevator_guys" );
	thread hangar::cleanup( "sm_guards_at_elevator_wave2", "elevator_guys" );
	thread hangar::cleanup( "sm_guards_at_elevator", "elevator_guys" );
	
	wait( 0.1 );

	// Cleanup the AI when Khalil looks for his bio weapon
	if( IsDefined(level.str_khalil_bioweapon_attackers) )
	{
		cp_mi_eth_prologue::DeleteGroupDelete( level.str_khalil_bioweapon_attackers );
	}

	// Cleanup the AI spawned in the main lift area
	if( IsDefined(level.str_guard_lift) )
	{
		cp_mi_eth_prologue::DeleteGroupDelete( level.str_guard_lift );
	}
	
	// Cleanup the AI behind the lift
	if( IsDefined(level.str_guards_at_elevator) )
	{
		cp_mi_eth_prologue::DeleteGroupDelete( level.str_guards_at_elevator );
	}
		
	//fix everyone's goal height
	level.ai_minister.goalheight = 80;	
	level.ai_khalil.goalheight = 80;
	
}

function hend_lift_battle_OTR_dialog()
{
	level.ai_hendricks dialog::say( "hend_that_s_our_exit_car_0" ); //That’s our exit, Cargo Elevator across the bridge. Move!
}
//*****************************************************************************
// Get Khalil and Minister to the lift
//*****************************************************************************

// self = AI (Khalil or Minister)
function get_to_lift_wait( str_s_target )
{
	s_target = struct::get( str_s_target, "targetname" );
	self.at_lift = undefined;
	self.goalradius = 128;
	self setgoalpos( s_target.origin );
	self waittill( "goal" );
	self.at_lift = true;
	//self.goalradius = 2048;
}

function send_hendricks_to_lift()
{
	level.ai_hendricks colors::disable();
	// Send the Hendricks to the lift
	n_node = GetNode( "n_lift01", "targetname" );
	level.ai_hendricks.goalradius = 16;
	level.ai_hendricks SetGoal( n_node, true );
}

// self = level
function send_minister_and_khalil_to_lift()
{
	level scene::play( "cin_pro_08_01_liftescape_vign_groupmove" );

	level.ai_khalil.goalradius = 64;
	level.ai_khalil setgoal( level.ai_khalil.origin );
	level.ai_minister.goalradius = 64;
	level.ai_minister setgoal( level.ai_minister.origin );
}

function adjust_ai_accuracy()
{
	//variable is a scalar, .5 sets it to half of default (10)
	self.script_accuracy = 0.5;
}

function player_at_elevator()
{
	//wait til first trigger
	trigger::wait_till("t_enemies_fallback", undefined, undefined, false);	
	
	//get all remaining ai from spawner
	a_remaing_ai = GetEntArray( "aig_lift_defenders", "script_aigroup" );
	//a_remaing_ai = GetEntArray( "guard_lift_ai", "targetname" );
	//send them to lift area
	v_goal = GetEnt( "v_lift_fallback", "targetname");
	foreach (ai in a_remaing_ai)
	{		
		if (IsAI(ai))
		{
			ai SetGoalVolume(v_goal);
		}
	}	
	
	//set all remaining spawners to send guys to gather area
	a_spawners = GetEntArray( "aig_lift_defenders", "script_aigroup" );
	foreach (sp in a_spawners)
	{
		if (IsSpawner(sp))
	    {
			sp spawner::add_spawn_function( &cp_prologue_util::set_goal_volume, v_goal );
	
		}
	}
	
	trigger::wait_till("t_got_to_lift", undefined, undefined, false);	
	//turn off spawner
	spawn_manager::kill("sm_guard_lift");
}


//*****************************************************************************
//*****************************************************************************

function lift_objective_handler()
{
	wait( 0.1 );
	s_goto_lift = struct::get( "obj_goto_lift" , "targetname" );
	objectives::set( "cp_level_prologue_goto_lift", s_goto_lift );

	level waittill("lift_is_moving");
		
	objectives::complete( "cp_level_prologue_goto_lift" );
}


//*****************************************************************************
//*****************************************************************************

function lift_reinforcement_handler()
{
	//set up a timer that waits for 15 seconds to pass
	level thread lift_reinforcement_timeout();
	//set up trigger to fire if player gets close without looking at elevator
	level thread lift_reinforcement_proximity_trigger();
	//set up a trigger that waits for the player to look at the elevator
	trigger::wait_till("t_lookat_lift_reinforcements", undefined, undefined, false);
	
	//spawn in guys in elevator
	a_spawners = GetEntArray( "sp_lift_reinforcements", "targetname" );
	for( i=0; i<a_spawners.size; i++ )
	{
		a_spawners[i]spawner::add_spawn_function( &cp_prologue_util::ai_very_low_goal_radius );
		a_spawners[i]spawner::spawn();
	}
		
	//move elevator to ground floor
	e_lift_door = GetEnt( "lift_door", "targetname" );
	level.e_lift = getent( "freight_lift", "targetname" );
	//link the door to the lift
	e_lift_door LinkTo( level.e_lift );
	level.e_lift SetMovingPlatformEnabled( true );
	
	// link the light
	probe_lift = GetEnt( "probe_lift", "targetname" );
	light_lift = GetEnt( "light_lift", "targetname" );
	probe_lift linkto (level.e_lift);
	light_lift linkto (level.e_lift);
	
	v_down = ( 0, 0, -1 );
	lift_height = 352;//should be 348 but minister doesn't come
	move_time = 8;
	v_lift_destination = (level.e_lift.origin + v_down * lift_height );
	level.e_lift MoveTo( v_lift_destination, move_time );
	
	//lift sounds
	level.e_lift = getent( "freight_lift", "targetname" );
	level.e_lift playsound ("evt_freight_lift_start");
	snd_lift = spawn( "script_origin", (level.e_lift.origin));
	snd_lift linkto (level.e_lift);
	snd_lift playloopsound ( "evt_freight_lift_loop" );

	// Wait for the lift to get to the destination
	level.e_lift waittill( "movedone" );
	snd_lift stoploopsound ( .1 );
	
	//move the door here
	e_lift_door playsound ( "evt_freight_elev_door_start" );
	snd_door = spawn( "script_origin", (e_lift_door.origin));
	snd_door linkto (e_lift_door);
	snd_door playloopsound ( "evt_freight_elev_door_loop" );
	v_up = ( 0, 0, 1 );
	v_dest = ( e_lift_door.origin + v_up * 100 );
	move_time = 1;
	e_lift_door Unlink();
	e_lift_door MoveTo( v_dest, move_time );
	
	wait move_time/2; //wait til the door is mostly up
	
	//link traversal nodes
	nd_lift_traversal = GetNode( "n_lift_entrance_begin1", "targetname" );
	LinkTraversal( nd_lift_traversal );
	nd_lift_traversal = GetNode( "n_lift_entrance_begin2", "targetname" );
	LinkTraversal( nd_lift_traversal );
	nd_lift_traversal = GetNode( "n_lift_entrance_begin3", "targetname" );
	LinkTraversal( nd_lift_traversal );
	nd_lift_traversal = GetNode( "n_lift_entrance_begin4", "targetname" );
	LinkTraversal( nd_lift_traversal );
	
	flag::set("lift_arrived");
	//give them a large goal radius
	a_ai_reinforcements = GetEntArray("sp_lift_reinforcements_ai", "targetname");
	foreach(ai_dude in a_ai_reinforcements)
	{
		ai_dude.goalradius = 1024;
	}
	
	wait 2;
	snd_door stoploopsound ( .1 );

}

function lift_reinforcement_timeout()
{
	wait 16;
	e_trigger = getent( "t_lookat_lift_reinforcements", "targetname" );
	if (IsDefined(e_trigger))
	{
		e_trigger notify( "trigger" );
	}
}

function lift_reinforcement_proximity_trigger()
{
	trigger::wait_till("t_once_lift_reinforcements", undefined, undefined, false);
	e_trigger = getent( "t_lookat_lift_reinforcements", "targetname" );
	if (IsDefined(e_trigger))
	{
		e_trigger notify( "trigger" );
	}
}

//*****************************************************************************
//*****************************************************************************
// Useful stuff
//*****************************************************************************
//************************************************`````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````*****************************

#namespace prologue_util;




//*****************************************************************************
// Calls a function when the player has fired
//*****************************************************************************

function setup_player_firing_callback( player_fires_function, param1 )
{
	level.player_has_fired = undefined;
	a_players = GetPlayers();
	for( i=0; i<a_players.size; i++ )
	{
		e_player = a_players[i];
		e_player thread [[player_fires_function]]( param1 );
	}
}


//*****************************************************************************
// Alerts the base when a player fires
//*****************************************************************************

function stealth_check_player_firing( alert_delay_deadzone )
{
	level endon( "ai_alerted_base" );
	
	while( 1 )
	{
		self waittill( "weapon_fired" );

		if( IsDefined(alert_delay_deadzone) )
		{
			wait( alert_delay_deadzone );
		}

		currentweapon = self getCurrentWeapon();
		if( !WeaponHasAttachment( currentweapon, "suppressed" ) )
		{
			level flag::set( "is_base_alerted" );
			level notify( "ai_alerted_base" );
			level.player_has_fired = true;
		}
	}
}


//*****************************************************************************
//*****************************************************************************

function base_alerted()
{	
	if ( level flag::get( "is_security_camera_alerted" ) == 0 )
	{
		level flag::set_val( "is_security_camera_alerted" , true );

		level notify( "ai_alerted_base" );
		level thread cp_prologue_util::base_alarm_goes_off();


		/# PrintLn( "Base is Alerted" ); #/
		
//#if 0
		//PlaySoundAtPosition( "evt_base_alarm" , (-1546, 287, 461) );
		//wait 2.0;
		//PlaySoundAtPosition( "evt_base_alarm" , (-1546, 287, 461) );
		//wait 2.0;
		//PlaySoundAtPosition( "evt_base_alarm" , (-1546, 287, 461) );
//#endif
	}
}

// - Kill the guard instantly because we want him to go straignt into a death anim
function callback_bioweapon_guard_death_anim( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	iDamage = self.health + 1;
	return( iDamage );
}

//*****************************************************************************
// If the guard is shot and the base is NOT alerted
// - Kill the guard instantly because we want him to go straignt into a death anim
//*****************************************************************************

function callback_camera_guard_death_anim( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if( level flag::get( "is_security_camera_alerted" ) == 0 )
	{
		level thread prologue_util::base_alerted();
		level notify( "ai_alerted_base" );
	}
	return( iDamage );
}


//*****************************************************************************
// Just sends out a notify if the weapon is fired
//*****************************************************************************

function check_player_firing()
{
	while( 1 )
	{
		self waittill( "weapon_fired" );
		currentweapon = self getCurrentWeapon();
		if( !WeaponHasAttachment( currentweapon, "suppressed" ) )
		{
			level thread prologue_util::base_alerted();
			level notify( "ai_alerted_base" );
		}
	}
}

//*****************************************************************************
//*****************************************************************************

// self = player
function player_fires( param1 )
{
	self waittill( "weapon_fired" );
	level.player_has_fired = true;
	level notify( "player_weapon_fired" );
}

// self = actor
function ai_death_count()
{
	self waittill( "death" );
	if( !IsDefined(level.ai_death_counter) )
	{
		level.ai_death_counter = 0;
	}
	level.ai_death_counter++;
}


