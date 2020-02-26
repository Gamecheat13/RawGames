/*
	
	PUT NEED TO KNOW EVENT INFO UP HERE

*/
#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_vehicle;
#include maps\_objectives;
#include maps\_dialog;
#include maps\_horse;


/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//
//	Declare event-specific flags here
init_flags()
{
//	flag_init( "event_flag" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//	add_spawn_function( "intro_drone", ::intro_drone );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions	(you may have more than one skipto in this file)
-------------------------------------------------------------------------------------------*/

//
//	This is run before your main function is executed.  Put any skipto-only initialization here.
skipto_intro()
{
//	init_hero( "hero_name_here" );

//	start_teleport( "skipto_structname_here" );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
	// Temp Development info
	/#
		IPrintLn( "Intro Base Camp" );
	#/
	// Initialization
	// Additional event logic 	
	thread pull_out_sword();
	spawn_heroes();
	
	horse = spawn_vehicle_from_targetname( "player_horse" );
	horse MakeVehicleUnusable();
	
	flag_wait("starting final intro screen fadeout");
	
	e1_start();
}


spawn_heroes()
{
	woods = getent("woods", "targetname");
	woods add_spawn_function( ::set_horse_anim );
	level.woods = init_hero("woods");
	level.player_horse = getent("player_horse_2", "targetname");
//	level.player_horse thread maps\_horse::main();
	level.wood_horse = spawn_vehicle_from_Targetname("e1_woods_horse");
	level.wood_horse.animname = "woods_horse";
}

/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/

// Everything else goes here
e1_start()
{
//	wood_cliff_start = getnode("e1_wood_start_cliff", "targetname");
//	level.woods forceteleport( wood_cliff_start.origin, wood_cliff_start.angles);
//	level.woods SetGoalNode(wood_cliff_start);
//	obj_trigger = getent("e1_start_woods_drop", "targetname");
//	
//	
//	n_e1_player_node = getnode("e1_player_meet_wood_node", "targetname");
//	
	
//	set_objective( level.OBJ_AFGHAN_BC1, obj_trigger);
//	trigger_wait("e1_start_woods_drop");
//	
//	set_objective( level.OBJ_AFGHAN_BC1, undefined, "done" );
//	
//	level.player thread player_lock_in_position(n_e1_player_node.origin, n_e1_player_node.angles);
//	level.player SetLowReady(true);
	//level.player DisableWeapons();
//	wood_dest_node = getnode("e1_woods_meet_player_node", "targetname");
//	level.woods SetGoalNode(wood_dest_node);
//	level.woods.goalradius = 32;
//	level.woods waittill("goal");
	
	//iprintlnbold( "Someone is coming, let's wait for them");
	//wait(2);
	//level.player notify("unlink_from_ent");
	level thread spawn_horses();
	
	add_temp_dialog_line("Woods", "Someone is coming, let's wait for them.", 10);
	add_temp_dialog_line("Woods", "I hope it's our contact, we have been waiting here for far too long.", 12);
	run_scene("e1_player_wood_greeting");
	run_scene_first_frame("e1_zhao_horse_charge");
	autosave_by_name("e1_intro");

	wood_dest_node = getnode("e1_woods_wall_crouch", "targetname");
	level.woods SetGoalNode(wood_dest_node);

	obj_trigger = getent("e1_base_camp_obj_2_trigger", "targetname");
	set_objective( level.OBJ_AFGHAN_BC2, obj_trigger);
	trigger_wait("e1_base_camp_obj_2_trigger");
	
	level thread run_scene("e1_zhao_horse_charge_player");
	level thread run_scene("e1_zhao_horse_charge_woods");
//	n_e1_player_node = getnode("e1_player_wall_crouch", "targetname");
//	level.player thread player_lock_in_position(n_e1_player_node.origin, n_e1_player_node.angles);
	//level notify("start_horse_event");
	
	level thread manage_anim_timescale();
	
	level thread play_temp_dialogue();
	
	level thread run_scene("e1_zhao_horse_charge");
	level thread run_scene("e1_horse_charge_muj");
	level thread manage_dust_storm();
	
	level.scene_sys waittill("e1_horse_charge_muj_done");
	level thread run_scene("e1_horse_charge_muj_endloop");
	
	level.scene_sys waittill("e1_zhao_horse_charge_done");
	
	autosave_by_name("e1_horse_charge");
	
	level.zhao enter_vehicle(level.zhao_horse);
	
	clip = getent("e1_clip", "targetname");
	clip delete();
	
	//level thread send_player_horse();
}

play_temp_dialogue()
{
	add_temp_dialog_line("Woods", "Zhao is a Chinese agent working with the local Muj.");
	wait(2);
	add_temp_dialog_line("Woods", "He will put us in contact with the leader of Muj.");
	wait(2);
	add_temp_dialog_line("Mason", "Can we trust him?");
	wait(4);
	add_temp_dialog_line("Woods", "We can trust him, but can't be too careful?");
	wait(8);
	add_temp_dialog_line("Zhao", "It's good to see you again Woods.");
	wait(3);
	add_temp_dialog_line("Zhao", "What have you brought me today?");
	wait(3);
	add_temp_dialog_line("Woods", "We smuggled in a few cases of Stinger missile as well as some cash to help Muj's cause.");
	wait(3);
	add_temp_dialog_line("Woods", "But We need some informations from Leader of the Muj in this area.");
	wait(3);
	add_temp_dialog_line("Zhao", "You four stay here and transport the cargo to a safer area.");
	wait(3);
	add_temp_dialog_line("Zhao", "Woods, you and your friend will follow me, I hope your friend know how to ride a horse.");
	wait(3);
	add_temp_dialog_line("Zhao", "We need to Hurry, Soviets are planning an attack soon in this area.");
		
}

spawn_horses()
{	
	
	
	zhao = getent("zhao", "targetname");
	zhao add_spawn_function( ::set_horse_anim );
	
	level.zhao = init_hero("zhao");
	level.muj_horses = spawn_vehicles_from_targetname("e1_muj_horse");
	level.zhao_horse = spawn_vehicle_from_targetname("e1_zhao_horse");
	level.zhao_horse.animname = "zhao_horse";
	//level.zhao enter_vehicle(level.zhao_horse);
	
	
	muj_spawner = getent("e1_zhao_horseman_spawner", "targetname");
	muj_spawner add_spawn_function( ::set_horse_anim );
	
	horsemen = [];
	horsemen[ horsemen.size ] = simple_spawn_single("e1_zhao_horseman_spawner");
	horsemen[ horsemen.size ] = simple_spawn_single("e1_zhao_horseman_spawner");
	horsemen[ horsemen.size ] = simple_spawn_single("e1_zhao_horseman_spawner");
	horsemen[ horsemen.size ] = simple_spawn_single("e1_zhao_horseman_spawner");

	
	for(i = 0; i < level.muj_horses.size; i++)
	{
		//horsemen[i] enter_vehicle( level.muj_horses[i] );
		horsemen[i].animname = "horse_muj_" + (i + 1);
		level.muj_horses[i].animname = "muj_horse_" + (i + 1);

	}
	
	level waittill("start_horse_event");
	for(i = 0; i < level.muj_horses.size; i++)
	{
		level.muj_horses[i].cleanup_time = "e3_clean_up";

	}
	
	
	
}

horse_jump( node_number )
{
	zhao_node = GetVehicleNode("e1_zhao_node", "targetname");
	self waittill("reached_end_node");
	
	if(self == level.zhao_horse)
	{
		self go_path(zhao_node);
	}
	else
	{
		self go_path(level.muj_encircling_node[node_number]);
	}
	
}

set_horse_anim()
{
	while(1)
	{
		self waittill( "enter_vehicle", vehicle );
	 	vehicle notify( "groupedanimevent", "ride" );
	 	self notify( "ride" );
		self maps\_horse_rider::ride_and_shoot( vehicle );
	}
}

pull_out_sword()
{
	run_scene_first_frame("e1_s1_pulwar_single");
	trigger_wait("pullout_pulwar");
	trigger_off("pullout_pulwar", "targetname");
	run_scene("e1_s1_pulwar");
	
	level.player GiveWeapon("pulwar_sword_sp");
}

manage_anim_timescale()
{
	flag_wait("time_scale_horse");
	
	SetTimeScale(0.35);
	
	//--TODO: figure out if we really need this anim, if we do then it should be notetracked
	delay_thread( 2.0, ::manage_wall_fxanim );
	flag_wait("time_scale_horse_end");
	
	SetTimeScale(1.0);
}

manage_wall_fxanim()
{
	level notify("fxanim_horse_wall_break_start");
	exploder(10150);
}

manage_dust_storm()
{	
	start_dist = 620.795;
	half_dist = 17173.1;
	half_height = 2309.3;
	base_height = -144.597;
	fog_r = 0.937255;
	fog_g = 0.984314;
	fog_b = 1;
	fog_scale = 16.4713;
	sun_col_r = 0.894118;
	sun_col_g = 0.996078;
	sun_col_b = 1;
	sun_dir_x = 0.262877;
	sun_dir_y = 0.800647;
	sun_dir_z = 0.538386;
	sun_start_ang = 0;
	sun_stop_ang = 140.854;
	time = 5;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	
	wait 8;
	
	start_dist = 256.88;
	half_dist = 423.915;
	half_height = 466.706;
	base_height = -144.597;
	fog_r = 0.427451;
	fog_g = 0.364706;
	fog_b = 0.27451;
	fog_scale = 12.3418;
	sun_col_r = 0.792157;
	sun_col_g = 0.698039;
	sun_col_b = 0.52549;
	sun_dir_x = 0.165854;
	sun_dir_y = 0.823505;
	sun_dir_z = 0.542524;
	sun_start_ang = 0;
	sun_stop_ang = 124.905;
	time = 8;
	max_fog_opacity = 1;



	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
}

send_player_horse()
{
	level.player_horse AttachPath(GetVehicleNode("start_horse_path", "targetname"));
	level.player_horse StartPath();
	level.player_horse waittill("reached_end_node");
	level.player_horse vehicle_detachfrompath();
}