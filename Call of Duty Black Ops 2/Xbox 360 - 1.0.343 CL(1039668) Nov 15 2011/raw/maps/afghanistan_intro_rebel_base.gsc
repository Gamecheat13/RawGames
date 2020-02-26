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
	flag_init( "first_rebel_base_visit" );
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
	skipto_setup();
	level.woods = init_hero("woods");
	level.zhao = init_hero("zhao");
	start_teleport( "skipto_rebel_base_intro", level.heroes );
	
	
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
		IPrintLn( "Intro Rebel Base" );
	#/
	// Initialization
	level thread cleanup();
	level thread lockbreaker_door();
	level thread intruder_door();
	setup_objective();
	set_up_map_room();
	rebel_base_clean_up();
	flag_set( "first_rebel_base_visit" );

	// Additional event logic    
}
setup_objective()
{
	set_objective( level.OBJ_AFGHAN_RC1, level.zhao, "follow");	
}
set_up_map_room()
{
	
	autosave_by_name("e3_base_start");
	rebel_node = getnode("e3_rebel_leader_node", "targetname");
	zhao_node = getnode("e3_woods_node", "targetname");
	woods_node = getnode("e3_zhao_node", "targetname");
	hudson_node = getnode("e3_hudson_node", "targetname");
	
	level.rebel_leader = init_hero("rebel_leader");
	level.rebel_leader.animname = "rebel_leader";
	level.hudson = init_hero("hudson");
	level.hudson.animname = "hudson";
//	level.rebel_leader forceteleport(rebel_node.origin, rebel_node.angles);
//	level.hudson forceteleport(hudson_node.origin, hudson_node.angles);
//	level.woods setgoalnode(woods_node);
//	level.zhao setgoalnode(zhao_node);
//	
	level thread run_scene("e2_base_activity");
	
	wait 25;
	
	trigger = GetEnt("e3_map_event_start", "targetname");
	while(!level.player IsTouching(trigger))
	{
		wait 0.5;
	}
	
	level map_setup();
	
	screen_fade_out();
	level thread map_tutorial();
	level thread map_room_teleport();
	screen_fade_in();
	
	level.player waittill("map_tutorial_finished");
	screen_fade_in();
	
	level.Woods setgoalpos(level.Woods.origin);
	level.zhao setgoalpos(level.zhao.origin);
	end_scene("e2_base_activity_generic");
	set_objective( level.OBJ_AFGHAN_RC1, undefined, "done");	
}

cleanup()
{
	if(isdefined(level.muj_horses))
	{
		for(i = 0; i < level.muj_horses.size; i++)
		{
			level.muj_horses[i] delete();
		}
	}
	
}

rebel_base_clean_up()
{

	ent_useless = getentarray("e2_muj_clean_up", "targetname");
	
	for(i = 0; i < ent_useless.size; i++)
	{
		ent_useless[i] delete();
	}
	
	if(isDefined(level.zhao_horse))
	{
		level.zhao_horse delete();
	}
	if(isDefined(level.wood_horse))
	{
		level.wood_horse delete();
	}
	if(isDefined(level.player_horse))
	{
		level.player_horse delete();
	}
	
	const start_dist = 620.795;
	const half_dist = 17173.1;
	const half_height = 2309.3;
	const base_height = -144.597;
	const fog_r = 0.937255;
	const fog_g = 0.984314;
	const fog_b = 1;
	const fog_scale = 16.4713;
	const sun_col_r = 0.894118;
	const sun_col_g = 0.996078;
	const sun_col_b = 1;
	const sun_dir_x = 0.262877;
	const sun_dir_y = 0.800647;
	const sun_dir_z = 0.538386;
	const sun_start_ang = 0;
	const sun_stop_ang = 140.854;
	const time = 2;
	const max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
}

map_tutorial()
{
	level.player.map_input_off = true;
	level.player.map_button_off = true;
	
	add_temp_dialog_line("Rebel Leader", "Our base is to the South, where you are standing.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "Just beyond the base is an open area, or Arena, where we expect the enemy to flood in.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "To the West, North and East are Blocking Points where we hope to delay the enemy from advancing.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "You can get to each point the same way you arrived at our base, by horseback.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "If you lose your horse, we have Hitching Posts throughout the area, where you can always find a horse to ride.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "The enemy vehicles at the Blocking Points will be going for the Ammo Caches.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "If these are eliminated, the vehicles will flood into the Arena, and head for our base.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "Utilize the Stingers and RPG’s at the Ammo Caches to prevent this from happening.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "In addition to the weapon caches, we have a limited number of experienced crews");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "that have been training with captured Russian weapons.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "We have Stinger Crews, RPG Crews and Sniper Crews.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "These men are all experienced with the weapon mentioned in the crew and are available for you to assign to");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "any of the blocking points that you feel need the support.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "We have only had time to train two (2) of each crew type.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "Finally, we recently captured a Russian T-62 tank. This will be at your disposal to help defend the base");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "and be assigned to any of the three blocking points.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "If it is destroyed, it is gone. We only have the one tank.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "What you're pointing to right now is the arena. This is where only tank can be placed but the crews do not have");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "access to without being put at risk. Through out the area there are ammo caches where you will find equipment.");
	wait 3;
	add_temp_dialog_line("Rebel Leader", "Now look towards the West side of the map at blocking point 1");
	wait 3;
	
	level.player.map_input_off = false;
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_1");
	
	level.player waittill("Blocking_Point_1");
	screen_message_delete();
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_2");
	
	level.player waittill("Blocking_Point_2");
	screen_message_delete();
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_3");
	
	level.player waittill("Blocking_Point_3");
	screen_message_delete();
	
	add_temp_dialog_line("Woods", "Okay, we want to assign a Crew to a Blocking Point.  First pick a Blocking point. ");
	
	level.player.map_button_off = false;
	level.player.tank_button_off = true;
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_4");
	
	level.player waittill("Unit_Placed");
	screen_message_delete();
	
	add_temp_dialog_line("Woods", "Now we want to place the tank.");
	
	level.player.tank_button_off = false;
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_5");
	
	level.player waittill("Tank_Placed");
	screen_message_delete();
	
	add_temp_dialog_line("Woods", "Finish your strategic placements and head out to battle with Zhao, Mason.");
	wait 2;
	add_temp_dialog_line("Woods", "When you're out in the field you'll be able to radio back to me to move the crews or tank.");
	wait 2;

	screen_message_create(&"AFGHANISTAN_MAP_TUT_6");
	
	while( !level.player ActionSlotFourButtonPressed() )
	{
		wait 0.05;
	}
	
	screen_message_delete();
	
	screen_fade_out();
	map_room_teleport();
	level.player notify("map_tutorial_finished");
	
	screen_message_create(&"AFGHANISTAN_MAP_TUT_7");
	
	wait 6;
	
	screen_message_delete();
}

lockbreaker_door()
{
	m_door = GetEnt( "afghan_lockbreaker_door", "targetname" );
	m_door_clip = GetEnt( "afghan_lockbreaker_door_clip", "targetname" );
	m_door LinkTo( m_door_clip );
	
	trigger_wait("lockbreaker_trigger");
	trigger_off("lockbreaker_trigger", "targetname");
	run_scene("lockbreaker");

	m_door_clip RotateYaw( 90, 1 );	
	level notify("lockbreaker_opened");
}

intruder_door()
{
	trigger_wait("intruder_box");
	trigger_off("intruder_box", "targetname");
	run_scene("intruder");
	
	level.player GiveWeapon( "tc6_mine_sp" );
	level.player SetActionSlot( 1, "weapon", "tc6_mine_sp" );
	level.player GiveMaxAmmo( "tc6_mine_sp" );
	
	
}
/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/

// Everything else goes here
