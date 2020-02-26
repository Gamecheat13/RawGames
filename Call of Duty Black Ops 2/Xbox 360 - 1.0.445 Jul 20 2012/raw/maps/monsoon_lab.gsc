/*
	MONSOON!
	
	SCRIPTERS: Kevin Drew, Damoun Shabestari, Sky Silcox
	BUILDERS: Gavin Goslin, Susan Arnold
	PROD: Brent Toda, John Dehart
*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\monsoon_util;
#include maps\_vehicle;
#include maps\_dialog;
#include maps\_scene;
#include maps\_anim;
#include maps\_dynamic_nodes;
#include maps\_glasses;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

#define INT_LIFT_MOVE_TIME 10
#define INT_LIFT_DOOR_DIST 60
#define INT_LIFT_DOOR_TIME 2

////////////////////////////////
//                            //
//          SKIPTOS           //
//                            //
////////////////////////////////

skipto_lab()
{
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	level.crosby = init_hero( "crosby" );
	
	skipto_teleport( "player_skipto_lab", get_heroes() );
}

skipto_lab_battle()
{
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	level.crosby = init_hero( "crosby" );

	lab_spawn_funcs();
	
	skipto_teleport( "player_skipto_lab_battle", get_heroes() );
	
	//for skipto
	trigger_use( "trig_spawn_lobby_guys" );
	trigger_use( "trig_color_lobby_front" );	
	trigger_use( "trig_color_lobby_mid" );	
	
	level.asd_destroyed = true;
	
	//thread that runs after asd, need this here
	level thread asd_lobby_guys();
	
	level thread lab_doors();

	m_asd_intro_tile_fall = GetEnt( "asd_intro_tile_fall", "targetname" );
	m_asd_intro_tile_fall Delete();
	
	m_asd_intro_pillar_fall = GetEnt( "asd_intro_pillar_fall", "targetname" );
	m_asd_intro_pillar_fall Delete();
	
	temp_lab_dialogue();
}

skipto_fight_to_isaac()
{
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	level.crosby = init_hero( "crosby" );

	foreach( hero in level.heroes )
	{
		hero change_movemode( "cqb" );
	}
	
	e_player_elevator_bottom_clip = GetEnt( "player_elevator_bottom_clip", "targetname" );
	e_player_elevator_bottom_clip ConnectPaths();
	e_player_elevator_bottom_clip Delete();
	
	m_lift = GetEnt( "lift_interior", "targetname" );
	m_lift.a_left_nodes = GetNodeArray( "interior_lift_left_nodes", "targetname" );
	
	//close the doors
	bm_door_south_l = GetEnt( "lift_interior_door_1_left", "targetname" );
	bm_door_south_l ConnectPaths();
	bm_door_south_l Delete();
	
	bm_door_south_r = GetEnt( "lift_interior_door_1_right", "targetname" );
	bm_door_south_r ConnectPaths();
	bm_door_south_r Delete();
	
	bm_door_north_l = GetEnt( "lift_interior_door_2_left", "targetname" );
	bm_door_north_l ConnectPaths();
	bm_door_north_l Delete();
	
	bm_door_north_r = GetEnt( "lift_interior_door_2_right", "targetname" );
	bm_door_north_r ConnectPaths();
	bm_door_north_r Delete();
	
	//models
	m_door_south_l = GetEnt( "lift_interior_door_2_left_m", "targetname" );
	m_door_south_l ConnectPaths();
	
	m_door_south_r = GetEnt( "lift_interior_door_2_right_m", "targetname" );
	m_door_south_r ConnectPaths();

	m_door_north_l = GetEnt( "lift_interior_door_1_left_m", "targetname" );
	m_door_north_l ConnectPaths();
	
	m_door_north_r = GetEnt( "lift_interior_door_1_right_m", "targetname" );
	m_door_north_r ConnectPaths();
	
	//open the doors
	m_door_north_l MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	m_door_north_r MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	
	m_door_south_l MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	m_door_south_r MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );	

	//manually connect nodes on the bottom floor
	interior_lift_bottom_connect_left = GetNodeArray( "interior_lift_bottom_connect_left", "targetname" );
	interior_lift_bottom_connect_right = GetNodeArray( "interior_lift_bottom_connect_right", "targetname" );
	
	array_func( m_lift.a_right_nodes, ::_interior_elevator_connect_nodes, interior_lift_bottom_connect_right );
	array_func( m_lift.a_left_nodes, ::_interior_elevator_connect_nodes, interior_lift_bottom_connect_left );
	
	lab_spawn_funcs();
	
	skipto_teleport( "player_skipto_isaac_battle", get_heroes() );
	
	temp_lab_dialogue();
	
	//player nitrogen death
	level.player.overridePlayerDamage = ::player_nitrogen_death;	
}

init_lab_flags()
{	
	//Lab Objectives
	flag_init( "obj_lab_entrance_regroup" );
	flag_init( "lab_clean_room_open" );
	flag_init( "salazar_entrance_hack_done" );
	flag_init( "salazar_at_clean_room_panel" );
	
	//Lab Entrance Flags
	flag_init( "player_at_lab_entrance" );
	flag_init( "lab_entrance_open" );
	flag_init( "player_at_clean_room" ); //trigger flag
	flag_init( "close_entrance_doors" );
	
	//Lab Doors
	flag_init( "lab_lobby_doors" );
	flag_init( "lab_2_1_right_door" );
	flag_init( "lab_2_1_left_door" );
	flag_init( "lab_doors_open" );
	
	//ASD Intro Flags
	flag_init( "start_player_asd_anim" );
	flag_init( "end_player_asd_anim" );
	
	flag_init( "asd_becomes_active" );
	flag_init( "asd_tutorial_died" );
	
	flag_init( "start_asd_battle" );
	
	flag_init( "spawn_lobby_guys" );
	flag_init( "start_lab_1_1_battle" );
	
	//First Floor Lab Color Flags
	flag_init( "lab_1_1_frontline_half" );
	flag_init( "lab_1_1_frontline_cleared" );
	
	flag_init( "lab_1_1_guys_half" );
		
	flag_init( "lab_1_2_frontline_half" );
		
	flag_init( "lab_1_2_guys_half" );
	flag_init( "lab_1_2_guys_cleared" );
	
	//Second Floor Lab Color Flags
	flag_init( "lab_2_1_frontline_half" );
	flag_init( "lab_2_1_frontline_cleared" );

	flag_init( "lab_2_1_guys_half" );

	flag_init( "lab_2_2_guys_half" );
	flag_init( "lab_2_2_guys_cleared" );
	
	//Elevator Flags
	flag_init( "start_lift_move_up" );
	flag_init( "start_lift_move_down" );
	flag_init( "lift_at_top" );
	flag_init( "lift_at_bottom" );
	flag_init( "elevator_is_ready" );
	flag_init( "start_elevator_exits" );
	flag_init( "start_shooting_lift" );
	flag_init( "spawn_nitrogen_guys" );
	
	flag_init( "nitrogen_asd_fallback_1" );
	flag_init( "nitrogen_asd_fallback_2" );
	
	flag_init( "right_path_asd_destroyed" );
	flag_init( "start_lab_defend" );
	flag_init( "harper_asd_titus_fire" );
	flag_init( "nitrogen_asd_is_dead" );
	
	//Issac 
	flag_init( "player_at_ddm" );
	
	//custom death/entrances
	flag_init( "stop_window_jumper" );
	flag_init( "stop_stair_guy_scene" );
	flag_init( "stop_harper_throw" );		
}

////////////////////////////////
//                            //
//        Lab Entrance        //
//                            //
////////////////////////////////

lab_entrance()
{
	temp_lab_dialogue();
	
	level thread lab_entrance_vo();
	
	level thread camo_kill_challenge_watch();
	
	level thread harper_asd_intro();
	level thread salazar_asd_intro();
	level thread crosby_asd_intro();	
		
	level.harper change_movemode( "cqb_walk" );
	level.salazar change_movemode( "cqb_walk" );
	level.crosby change_movemode( "cqb_walk" );

	level thread clean_room_doors();
	
	//using this trigger in monsoon_ruins.gsc to move the squad up -kdrew
	//trigger_wait( "trig_salazar_lab_entrance" );
	
	level.salazar.goalradius = 32;
	nd_salazar_entrance = GetNode( "nd_salazar_entrance", "targetname" );
	level.salazar SetGoalNode( nd_salazar_entrance );
	level.salazar waittill( "goal" );
	
	//SOUND - Shawn J
	//iprintlnbold ("eye_scan");
	playsoundatposition ("evt_eye_scanner_01", (7713, 55023, -809) );
	
	run_scene( "salazar_lab_entry_intro" );
	
	level thread run_scene( "salazar_lab_entry_loop" );
	
	flag_wait( "player_at_lab_entrance" );

	run_scene( "salazar_lab_entry_exit" );

	level.salazar SetGoalPos( level.salazar.origin );
	
	//Open Lab Entrance Doors
	m_lab_door_left = GetEnt( "lab_door_left", "targetname" );
	m_lab_door_right = GetEnt( "lab_door_right", "targetname" );
	
	bm_lab_door_left_clip = GetEnt( "lab_door_left_clip", "targetname" );
	bm_lab_door_right_clip = GetEnt( "lab_door_right_clip", "targetname" );
		
	bm_lab_door_left_clip LinkTo( m_lab_door_left );
	bm_lab_door_right_clip LinkTo( m_lab_door_right );
		
	s_rumble_door_dist = getstruct( "obj_infiltrate_lab", "targetname" );
	s_rumble_door_dist.is_moving = true;
	s_rumble_door_dist.is_big_door = true;
		
	s_rumble_door_dist thread player_door_rumble();
	
	//SOUND - Shawn J
	//iprintlnbold ("move_round_doors");
	m_lab_door_right playsound ("evt_lab_round_doors");
	
	m_lab_door_left RotateYaw( -45, 5, 1 );
	m_lab_door_right RotateYaw( 45, 5, 1 );
	
	m_lab_door_left waittill( "rotatedone" ); 
	
	s_rumble_door_dist.is_moving = false;
	
	n_distance = Distance( s_rumble_door_dist.origin, level.player.origin );
	if ( n_distance < 1000 )
	{
		level.player PlayRumbleOnEntity( "damage_heavy" );
	}	
	
	m_lab_door_left ConnectPaths();
	m_lab_door_right ConnectPaths();
	
	bm_lab_door_right_clip ConnectPaths();
	bm_lab_door_left_clip ConnectPaths();
		
	flag_set( "lab_entrance_open" );
	
	trigger_use( "trig_color_clean_room" );
	
	autosave_by_name( "asd_battle" );

	level.salazar thread say_dialog( "hacking2" ); 
	
	flag_wait( "close_entrance_doors" );
	
	m_lab_door_left RotateYaw( 45, 5, 1 );
	m_lab_door_right RotateYaw( -45, 5, 1 );	
}

lab_entrance_vo()
{
	flag_wait( "player_at_lab_entrance" );
	
	level.harper say_dialog( "harp_shit_look_at_this_0", 0.50 );
	level.player say_dialog( "sect_what_we_saw_up_top_w_0", 0.50 );
	level.player say_dialog( "sect_salazar_get_it_ope_0", 0.50 );
	
	flag_wait( "lab_entrance_open" );
	
	level.player say_dialog( "sect_alright_on_me_0", 0.50 );
}

clean_room_doors()
{
	e_clip_clean_room_door = GetEnt( "clip_clean_room_door", "targetname" );
	e_clip_clean_room_door NotSolid();
	e_clip_clean_room_door Hide();
	
	trigger_wait( "trig_clean_room_doors" );
	
	//SOUND - Shawn J
	//iprintlnbold ("open_cln_doors");
	playsoundatposition ("evt_clean_room_doors_open", (8220, 55198, -931) );	 
	
	//opem clean room doors 1
	m_clean_room_door_01_l = GetEnt( "clean_room_door_01_l", "targetname" );
	m_clean_room_door_01_l_clip = GetEnt( "clean_room_door_01_l_clip", "targetname" );
	
	m_clean_room_door_01_l_clip LinkTo( m_clean_room_door_01_l );
	
	m_clean_room_door_01_r = GetEnt( "clean_room_door_01_r", "targetname" );	
	m_clean_room_door_01_r_clip = GetEnt( "clean_room_door_01_r_clip", "targetname" );
	
	m_clean_room_door_01_r_clip LinkTo( m_clean_room_door_01_r );
	
	//trigger_wait( "trig_clean_room_doors" );
	//flag_wait( "lab_entrance_open" );
	
	m_clean_room_door_01_l MoveY( 58, 2, 1 );
	m_clean_room_door_01_r MoveY( -58, 2, 1 );	

	m_clean_room_door_01_l ConnectPaths();
	m_clean_room_door_01_r ConnectPaths();	
	
	m_clean_room_door_01_l_clip ConnectPaths();
	m_clean_room_door_01_r_clip ConnectPaths();
	
	s_clean_room_door1_rumble = getstruct( "clean_room_door1_rumble", "targetname" );
//	s_clean_room_door1_rumble.is_moving = true;
	s_clean_room_door1_rumble.is_big_door = true;
		
//	s_clean_room_door1_rumble thread player_door_rumble();	
	
//	m_clean_room_door_01_r waittill( "movedone" );
//	s_clean_room_door1_rumble.is_moving = false;	
	
//	n_distance = Distance( s_clean_room_door1_rumble.origin, level.player.origin );
//	if ( n_distance < 1000 )
//	{
//		level.player PlayRumbleOnEntity( "damage_light" );
//	}		

//	m_clean_room_door_01_l ConnectPaths();
//	m_clean_room_door_01_r ConnectPaths();	
//	
//	m_clean_room_door_01_l_clip ConnectPaths();
//	m_clean_room_door_01_r_clip ConnectPaths();
	
	//wait until salazar gets into position at the panel
//	flag_wait( "salazar_at_clean_room_panel" );
	
	flag_wait( "player_at_clean_room" ); //trigger flag

	//check if everyone is in the clean room
	trig_clean_room_player = GetEnt( "trig_clean_room_player", "script_noteworthy" );
		
	while ( 1 )
	{
		if ( level.player IsTouching( trig_clean_room_player ) &&
		   	 level.harper IsTouching( trig_clean_room_player ) &&
		  	 level.salazar IsTouching( trig_clean_room_player ) &&
		  	 level.crosby IsTouching( trig_clean_room_player ) 
		   )
		{
			break;
		}
	
		wait 0.05;		
	}
	
	//show player clip on the door
	e_clip_clean_room_door Solid();
	e_clip_clean_room_door Show();
	
	//close clean room doors
	m_clean_room_door_01_l MoveY( -58, 2, 1 );
	m_clean_room_door_01_r MoveY( 58, 2, 1 );	
	
	//SOUND - Shawn J
	//iprintlnbold ("close_cln_doors");
	playsoundatposition ("evt_clean_room_doors_close", (8220, 55198, -931) );	
	
	s_clean_room_door1_rumble.is_moving = true;	
	s_clean_room_door1_rumble thread player_door_rumble();	

	//close entrance doors
	flag_set( "close_entrance_doors" );
	
	m_clean_room_door_01_r waittill( "movedone" );
	s_clean_room_door1_rumble.is_moving = false;	

	n_distance = Distance( s_clean_room_door1_rumble.origin, level.player.origin );
	if ( n_distance < 1000 )
	{
		level.player PlayRumbleOnEntity( "damage_heavy" );
	}
	
	/#
//		iprintln( "clean room activated" );	
	#/
		
	wait 2;
	
	/#
//		iprintln( "clean room fx" );
	#/
		
	exploder( 1350 );
	//SOUND - Shawn J
	//iprintlnbold ("spray");
	spray_ent = spawn( "script_origin", (8382, 55196, -887) );	
	playsoundatposition ("evt_spray_start", (8382, 55196, -887) );
	spray_ent PlayLoopSound ("evt_spray_loop", .5);
	
	wait 5;

	spray_ent StopLoopSound(.5);
	playsoundatposition ("evt_spray_stop",(8382, 55196, -887) );	
	spray_ent delete();
	
	wait 1;
	
	/#
//		iprintln( "clean room complete" );
	#/
		
	flag_set( "lab_clean_room_open" );	
	
	//SOUND - Shawn J
	//iprintlnbold ("open_cln_doors_2");
	playsoundatposition ("evt_clean_room_door_2_open", (8517, 55198, -938) );	
	
	//Open Lab Door 2
	m_clean_room_door_02_l = GetEnt( "clean_room_door_02_l", "targetname" );
	m_clean_room_door_02_l_clip = GetEnt( "clean_room_door_02_l_clip", "targetname" );
	
	m_clean_room_door_02_l_clip LinkTo( m_clean_room_door_02_l );
		
	m_clean_room_door_02_r = GetEnt( "clean_room_door_02_r", "targetname" );
	m_clean_room_door_02_r_clip = GetEnt( "clean_room_door_02_r_clip", "targetname" );
	
	m_clean_room_door_02_r_clip LinkTo( m_clean_room_door_02_r );
	
	m_clean_room_door_02_l MoveY( 58, 4, 2 );
	m_clean_room_door_02_r MoveY( -58, 4, 2 );
	
	s_clean_room_door2_rumble = getstruct( "clean_room_door2_rumble", "targetname" );
	s_clean_room_door2_rumble.is_moving = true;
	s_clean_room_door2_rumble.is_big_door = true;
		
	s_clean_room_door2_rumble thread player_door_rumble();
	
	m_clean_room_door_02_r waittill( "movedone" );
	s_clean_room_door2_rumble.is_moving = false;

	n_distance = Distance( s_clean_room_door2_rumble.origin, level.player.origin );
	if ( n_distance < 1000 )
	{
		level.player PlayRumbleOnEntity( "damage_light" );
	}	
	
	m_clean_room_door_02_l ConnectPaths();
	m_clean_room_door_02_r ConnectPaths();	
	
	m_clean_room_door_02_l_clip ConnectPaths();
	m_clean_room_door_02_r_clip ConnectPaths();
	
	nd_crosby_asd_hallway = GetNode( "nd_crosby_asd_hallway", "targetname" );
	level.crosby.goalradius = 32;
	level.crosby SetGoalNode( nd_crosby_asd_hallway );
	
	nd_harper_asd_hallway = GetNode( "nd_harper_asd_hallway", "targetname" );
	level.harper.goalradius = 32;
	level.harper SetGoalNode( nd_harper_asd_hallway );
	level.harper waittill( "goal" );
	
	level.harper handsignal( "moveout", "start_player_asd_anim" );
}

//Player gets RPG'd in the hallway
player_asd_intro()
{
	flag_wait( "start_player_asd_anim" );
	
	level notify( "fxanim_metal_storm_enter01_start" );
	
	Earthquake( 0.75, 2, level.player.origin, 1000 );
	level.player ShellShock( "default", 10 ); 	
	level.player PlayRumbleOnEntity( "grenade_rumble" );
	level.player EnableInvulnerability();
	
	m_asd_intro_tile_fall = GetEnt( "asd_intro_tile_fall", "targetname" );
	m_asd_intro_tile_fall Delete();
	
	m_asd_intro_pillar_fall = GetEnt( "asd_intro_pillar_fall", "targetname" );
	m_asd_intro_pillar_fall Delete();
	
	run_scene( "asd_intro_player_intro" );
	
	flag_set( "end_player_asd_anim" );
	
	autosave_by_name( "asd_intro" );
	
	level.player DisableInvulnerability();
	
	s_hallway_rockets_start = getstruct( "hallway_rockets_start", "targetname" );
	s_asd_hallway_target = getstruct( "asd_hallway_target", "targetname" );
	
	MagicBullet( "metalstorm_launcher", s_hallway_rockets_start.origin, s_asd_hallway_target.origin );
	wait .25;
	MagicBullet( "metalstorm_launcher", s_hallway_rockets_start.origin, s_asd_hallway_target.origin );
}

destory_asd_window( guy )
{
	bm_player_asd_window = GetEnt( "player_asd_window", "targetname" );
	bm_player_asd_window ConnectPaths();
	bm_player_asd_window Delete();
	
	Earthquake( 0.35, 1, level.player.origin, 300 );
	level.player PlayRumbleOnEntity( "grenade_rumble" );		
	level.player ShellShock( "default", 1 ); 	
}

asd_grenade_defense( guy )
{
	level notify( "fxanim_metal_storm_enter02_start" );
	level.player PlayRumbleOnEntity( "grenade_rumble" );
	Earthquake( 0.20, 0.5, level.player.origin, 1000 );
}

//Harper loops at door until player triggers event
harper_asd_intro()
{
	flag_wait( "lab_entrance_open" );
	
//	run_scene( "asd_intro_harper_intro" );
//	level thread run_scene( "asd_intro_harper_loop" );	
	
	flag_wait( "start_player_asd_anim" );
	
	run_scene( "asd_intro_harper_int_player" );
	
	trigger_use( "trig_color_post_clean_room" );	
	
	//harper nag lines to flank
	n_nag_line_frequency = RandomIntRange( 4, 6 );
	
	while ( !flag( "asd_becomes_active" ) )
	{
		n_index = RandomIntRange( 1, 4 );
		
		level.harper thread say_dialog( "asd_flank_nag_" + n_index );
		
		wait n_nag_line_frequency;
	}		
}

//Salazar hacks panel, then loops at door until player triggers event
salazar_asd_intro()
{
	flag_wait( "lab_entrance_open" );
	
	run_scene( "asd_intro_salazar_intro" );	
	
	//SOUND - Shawn J
	//iprintlnbold ("eye_scan_2");
	playsoundatposition ("evt_eye_scanner_02", (8544, 55073, -940) );
	
	level thread run_scene( "asd_intro_salazar_loop" );	
	
	flag_set( "salazar_at_clean_room_panel" );
	flag_wait( "start_player_asd_anim" );
	
	//end_scene
	end_scene( "asd_intro_salazar_loop" );
	
	//delete scene
	delete_scene( "asd_intro_salazar_loop" );
}

//Crosby loops at door until player triggers event
crosby_asd_intro()
{
	flag_wait( "lab_entrance_open" );
	
//	run_scene( "asd_intro_crosby_intro" );
//	level thread run_scene( "asd_intro_crosby_loop" );	
	
	flag_wait( "start_player_asd_anim" );
	
	//end_scene
	end_scene( "asd_intro_crosby_loop" );
	
	//delete scene	
	delete_scene( "asd_intro_crosby_loop" );
}

//TEMP - Shabs - Delete later
temp_lab_dialogue()
{
	add_dialog( "hacking", "Salazar: Hacking now...." );	 
	add_dialog( "got_it", "Salazar: Got it!" );
	add_dialog( "hacking2", "Salazar: Gimme a second." );
	add_dialog( "enemy_readings", "Harper: I'm getting movement behind these doors." );
	add_dialog( "enemy_readings2", "Salazar: Ready up!!" );
	
	add_dialog( "asd_nade_throw", "Harper: Grenade out!" );
	add_dialog( "asd_nade_throw_fail", "Harper: Shit, damn thing shoot grenades!" );
	
	add_dialog( "asd_backup", "Harper: Reinforcements!" );
	
	add_dialog( "asd_flank_nag_1", "Harper: Flank that damn ASD!" );
	add_dialog( "asd_flank_nag_2", "Harper: Get around it and shoot it in the back!" );
	add_dialog( "asd_flank_nag_3", "Harper: Under fire! Flank it!" );
	
	add_dialog( "isaac_noise_1", "Harper: What the hell was that?!" );
	add_dialog( "isaac_noise_2", "Harper: Mason, on me. Open it." );
	add_dialog( "isaac_noise_3", "Mason (Player): Rgr that." );
	
	add_dialog( "isaac_reveal_1", "Scientist: Please don't hurt me." );
	add_dialog( "isaac_reveal_2", "Scientist: My name is Isaac Weichert and I can help." );
	add_dialog( "isaac_reveal_3", "Salazar: Taking down the firewall is gonna take time." );
	add_dialog( "isaac_reveal_4", "Isaac: Reinforcements will be here any minute. I can help!" );
	add_dialog( "isaac_reveal_5", "Harper: Speed this up and we'll take you with us." );
	add_dialog( "isaac_reveal_6", "Isaac: Ok. Ok. Let me start the shield sequence first." );
	add_dialog( "isaac_reveal_7", "Mason (Player): Shield sequence?!" );
	
	add_dialog( "isaac_defend_1", "Isaac: They're almost here. Get ready! 2 ASD bots and a lot of soldiers." );
	add_dialog( "isaac_defend_2", "Harper: Good man Isaac! Mason, grab the shield!" );
	add_dialog( "isaac_defend_3", "Salazar: They're coming in from the ceiling" );
	add_dialog( "isaac_defend_4", "Harper: Hold them off! ... Hurrrrrry the hell up Isaaaaac!" );
	
	add_dialog( "isaac_defend_asd_death_1", "Mason (Player): ASD bot down!" );
	add_dialog( "isaac_defend_asd_death_2", "Harper: Keep shooting at it! ... It's down!" );
	
	add_dialog( "isaac_codes_wounded", "Salazar: Shit! Isaac is hurt. Keep them off him!!" );
	add_dialog( "isaac_codes_dead", "Salazar: Isaac is dead!" );
	
	add_dialog( "isaac_codes_success", "Isaac: I got it! Let's move!! Mason is it?! On me!" );
	add_dialog( "salazar_codes_success", "Salazar: I got it! Let's move!!" );
	
	add_dialog( "salazar_door_nag_1", "Salazar: Let's move Mason, get on the left side to open the doors." );
	add_dialog( "salazar_door_nag_2", "Salazar: C'mon...left Side." );
	add_dialog( "salazar_door_nag_3", "Salazar: I need you do open the doors Mason." );	
	
	add_dialog( "isaac_door_nag_1", "Isaac: Let's move Mason, get on the left side to open the doors." );
	add_dialog( "isaac_door_nag_2", "Isaac: C'mon...left Side." );
	add_dialog( "isaac_door_nag_3", "Isaac: I need you do open the doors Mason." );		
	
	add_dialog( "harper_pre_celerium_chip", "Harper: Overlord, we are about to acquire the chip. Stand by for confirmation." );
	
	add_dialog( "isaac_celerium_chip", "Isaac: This is it. The celerium chip. Take it." );
	add_dialog( "salazar_celerium_chip", "Salazar: This is it. The celerium chip. Let's get out of here." );
	add_dialog( "harper_celerium_chip", "Harper: Overload, we got it. The celerium chip is secure.." );
	
	add_dialog( "isaac_player_perk", "Isaac: Here is the new firmware for your camo tracking." );
	
	add_dialog( "isaac_chip_nag_1", "Isaac: Let's move Mason." );
	add_dialog( "isaac_chip_nag_2", "Isaac: C'mon...Mason" );

	add_dialog( "salazar_chip_nag_1", "Salazar: Let's move Mason." );
	add_dialog( "salazar_chip_nag_2", "Salazar: C'mon...Mason" );
	
	add_dialog( "harper_cabinet_nag_1", "Harper: Mason, open the container" );
	add_dialog( "harper_cabinet_nag_2", "Harper: C'mon...Mason, open the container" );
	add_dialog( "harper_cabinet_nag_3", "Harper: Mason, open it!" );	
}

lab_main()
{
	lab_spawn_funcs();
	
	level thread lab_entrance();
	asd_tutorial_intro();
}

////////////////////////////////
//                            //
//        ASD INTRO           //
//                            //
////////////////////////////////

asd_tutorial_intro()
{
	level thread player_asd_intro();

	level.asd_destroyed = false;	
	
	level thread asd_intro_vo();
	
	flag_wait( "start_player_asd_anim" );
	
	level thread rpg_hallway_destruction();
		
	level.vh_asd_tutorial = spawn_vehicle_from_targetname( "asd_tutorial" );
	level.vh_asd_tutorial thread asd_lobby_think();
	
	flag_wait( "end_player_asd_anim" );
	
	level thread asd_lobby_guys();
	
	flag_wait( "start_lab_1_1_battle" );
	
	level.harper change_movemode( "cqb_run" );
	level.salazar change_movemode( "cqb_run" );
	level.crosby change_movemode( "cqb_run" );
}

asd_intro_vo()
{
	level endon( "start_player_asd_anim" );
	
	flag_wait( "lab_clean_room_open" );	
	 
	level.salazar say_dialog( "sala_it_looks_deserted_0", 0.50 );	
	level.player say_dialog( "sect_they_may_have_abando_0", 0.50 );	
}

rpg_hallway_destruction()
{
	s_asd_rpg_start = getstruct( "asd_rpg_start", "targetname" );
	s_asd_rpg_end = getstruct( s_asd_rpg_start.target,  "targetname" );
	
	s_asd_rpg_start_2 = getstruct( "asd_rpg_start_2", "targetname" );
	s_asd_rpg_end_2 = getstruct( s_asd_rpg_start_2.target,  "targetname" );	
	
	s_asd_rpg_start_3 = getstruct( "asd_rpg_start_3", "targetname" );
	s_asd_rpg_end_3 = getstruct( s_asd_rpg_start_3.target, "targetname" );
	
	s_asd_rpg_start_4 = getstruct( "asd_rpg_start_4", "targetname" );
	s_asd_rpg_end_4 = getstruct( s_asd_rpg_start_4.target, "targetname" );	
	
	MagicBullet( "metalstorm_launcher", s_asd_rpg_start.origin, s_asd_rpg_end.origin );
	MagicBullet( "metalstorm_launcher", s_asd_rpg_start_2.origin, s_asd_rpg_end_2.origin );	
	MagicBullet( "metalstorm_launcher", s_asd_rpg_start_3.origin, s_asd_rpg_end_3.origin );
	MagicBullet( "metalstorm_launcher", s_asd_rpg_start_4.origin, s_asd_rpg_end_4.origin );
	
	wait 0.25;
	MagicBullet( "metalstorm_launcher", s_asd_rpg_start.origin, s_asd_rpg_end.origin );
	
	m_asd_ceiling = GetEnt( "asd_ceiling", "targetname" );
	m_asd_ceiling RotateRoll( 45, 0.75, 0.35, 0.35 );
	m_asd_ceiling DisconnectPaths();

}

asd_hallway_gunfire() //self = asd
{
	self endon( "death" );
	
	wait 2;
	
	//have asd shoot a moving target and continue to shoot its rockets at the squad
	e_asd_turret_target = GetEnt( "asd_turret_target", "targetname" );
	s_asd_turret_target_end = getstruct( "asd_turret_target_end", "targetname" );
	
	self SetTurretTargetEnt( e_asd_turret_target );
	self thread metalstorm_fire_for_time( 5 );
	
	e_asd_turret_target MoveTo( s_asd_turret_target_end.origin, 5 );
	
	wait 3;
	
	s_asd_hallway_target = getstruct( "asd_hallway_target", "targetname" );
	
	MagicBullet( "metalstorm_launcher", self GetTagOrigin( "TAG_MISSILE1" ), s_asd_hallway_target.origin );
	wait 0.25;
	MagicBullet( "metalstorm_launcher", self GetTagOrigin( "TAG_MISSILE1" ), s_asd_hallway_target.origin );
	wait 0.25;
	MagicBullet( "metalstorm_launcher", self GetTagOrigin( "TAG_MISSILE1" ), s_asd_hallway_target.origin );
}

//asd_weakness_glasses_hud()
//{
//	screen_message_create( &"MONSOON_ASD_WEAKNESS_1" );
//	wait 2;
//	screen_message_delete();
//	
//	screen_message_create( &"MONSOON_ASD_WEAKNESS_2" );
//	wait 2;
//	screen_message_delete();
//	
//	screen_message_create( &"MONSOON_ASD_WEAKNESS_3" );
//	wait 2;
//	screen_message_delete();
//
//	//place marker	
//	level.player maps\_ar::add_ar_target( self, &"MONSOON_ASD_WEAKNESS_3", 1000, 1000 );
//	
//	self waittill( "death" );
//	kill_ar_target( 0 );
//}

vo_player_asd()
{
	self endon( "death" );
	
	trigger_wait( "trig_vo_player_asd" );
	level.player say_dialog( "sect_i_ve_got_you_now_0" );
}

asd_lobby_think()
{
	self endon( "death" );
		
	self thread vo_player_asd();
	
	self thread asd_hallway_gunfire();	
	
	self thread player_asd_rumble();
	self veh_magic_bullet_shield( true );
	self maps\_metal_storm::metalstorm_stop_ai();
	
	nd_start_node = GetVehicleNode( self.target, "targetname" );
	self thread go_path( nd_start_node );
	self waittill( "reached_end_node" );
		
	self SetSpeed( 0, 3, 2 );
	
	flag_wait( "end_player_asd_anim" );
	
	self maps\_vehicle::vehicle_pathdetach();		
	
	self ResumeSpeed( 5 );
	
	s_asd_tutorial_spot = getstruct( "asd_tutorial_spot", "targetname" );
	self SetVehGoalPos( s_asd_tutorial_spot.origin, true, 2, true );
	self waittill_any( "goal", "near_goal" );	
	
	self maps\_vehicle::defend( self.origin, 128 );
	
	self veh_magic_bullet_shield( false );
	self thread asd_health_watch();	
	//self thread asd_weakness_glasses_hud();
		
	flag_wait( "asd_becomes_active" );
	
	s_asd_fallback_pos = getstruct( "asd_fallback_pos", "targetname" );
	self thread maps\_vehicle::defend( s_asd_fallback_pos.origin, 300 );	
	
	flag_wait( "start_lab_1_1_battle" );

	s_asd_fallback_pos_2 = getstruct( "asd_fallback_pos_2", "targetname" );
	self thread maps\_vehicle::defend( s_asd_fallback_pos_2.origin, 300 );	
}

////////////////////////////////
//                            //
//        Lobby Battle        //
//                            //
////////////////////////////////

asd_lobby_guys()
{	
	level thread asd_tutorial_timeout();
	
	level thread lab_doors();
	
	flag_wait( "spawn_lobby_guys" );
	flag_set( "lab_lobby_doors" );
	
	level.harper thread say_dialog( "asd_backup" );
	
	trigger_use( "trig_spawn_lobby_guys" );
	
	level thread monitor_lobby_frontline();
	
	use_trigger_on_group_count( "lobby_guys", "trig_color_lobby_front", 6 );
	use_trigger_on_group_count( "lobby_guys", "trig_color_lobby_mid", 3, true );
	use_trigger_on_group_count( "lobby_guys", "trig_lab_1_1_color_cleared", 1 );
	
	flag_set( "start_lab_1_1_battle" );	

	trigger_wait( "trig_color_lobby_front" );
	e_asd_hallway_clip = GetEnt( "asd_hallway_clip", "targetname" );
	e_asd_hallway_clip ConnectPaths();
	e_asd_hallway_clip Delete();
	
	//trigger_wait( "trig_lab_1_1_frontline_half" );
	//send lobby guys back
	
	//cleanup after player hits trig	
	trigger_wait( "trig_window_jumper" );
	a_lobby_guys = get_ai_group_ai( "lobby_guys" );
	foreach( guy in a_lobby_guys )
	{
		if ( IsAlive( guy ) )
		{
			guy Die();
		}
	}
}

lab_doors()
{
	level thread lab_2_1_left_door();
	
	level thread lab_2_1_right_door();
	
	flag_wait( "lab_lobby_doors" );
	
	//upstairs	
	e_right_lobby_top_door = GetEnt( "right_lobby_top_door", "targetname" );
	e_right_lobby_top_door MoveX( 60, 0.5 );
	e_right_lobby_top_door thread connect_door_paths();
	
	e_left_lobby_top_door = GetEnt( "left_lobby_top_door", "targetname" );
	e_left_lobby_top_door MoveX( -60, 0.5 );
	e_left_lobby_top_door thread connect_door_paths();
	
	//downstairs
	//left lobby door
	e_left_lobby_door = GetEnt( "left_lobby_door", "targetname" );
	e_left_lobby_door MoveY( 60, 0.5 );
	e_left_lobby_door thread connect_door_paths();
	
	//right lobby door
	e_right_lobby_door = GetEnt( "right_lobby_door", "targetname" );
	e_right_lobby_door MoveY( -60, 0.5 );
	e_right_lobby_door thread connect_door_paths();
	
	trigger_wait( "trig_sm_lab_2_1" );
	
	flag_set( "lab_2_1_left_door" );
	flag_set( "lab_2_1_right_door" );
	flag_set( "lab_doors_open" );
}

lab_2_1_left_door()
{
	flag_wait_any( "lab_2_1_left_door", "lab_doors_open" );
	
	e_left_2_1_door = GetEnt( "left_2_1_door", "targetname" );
	e_left_2_1_door MoveX( -60, 0.5 );
	e_left_2_1_door thread connect_door_paths();	
}

lab_2_1_right_door()
{
	flag_wait_any( "lab_2_1_right_door", "lab_doors_open" );
	
	e_right_2_1_door = GetEnt( "right_2_1_door", "targetname" );
	e_right_2_1_door MoveX( 60, 0.5 );
	e_right_2_1_door thread connect_door_paths();		
}

connect_door_paths()
{
	self waittill( "movedone" );
	self ConnectPaths();	
}

monitor_lobby_frontline()
{
	waittill_ai_group_amount_killed( "lobby_guys", 2 );

	flag_set( "asd_becomes_active" );
	flag_set( "start_asd_battle" );	
}

//this will spawn the guys if the player hangs back
asd_tutorial_timeout()
{
	level endon( "spawn_lobby_guys" );
	
	wait 25;
	flag_set( "asd_becomes_active" );
	flag_set( "spawn_lobby_guys" );
	trigger_use( "trig_color_lobby_front" );
}

asd_health_watch()
{
	self endon( "death" );
	
	while ( self.health > 200 )
	{
		wait 0.05;
	}
	
	flag_set( "spawn_lobby_guys" );
	
	while ( self.health > 100 )
	{
		wait 0.05;
	}
	
	//set it to active bot mode
	flag_set( "asd_becomes_active" );
	trigger_use( "trig_color_lobby_front" );
	
	self waittill( "death" );
	flag_set( "asd_tutorial_died" );
	
	level.asd_destroyed = true;
}

player_nitrogen_death( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime  )
{
	if ( sMeansOfDeath == "MOD_GAS" )
	{
		if (  IS_TRUE( level.player.b_been_frozen ) )
		{
			return 0;	
		}
		else 
		{
			level.dont_save_now = true;
			
			level.player.b_been_frozen = true;		
			level.player.ignoreme = 1;
			level.player ShellShock( "default", 8 ); 	
			
			/#
				//IPrintLnBold( "player just got owned by nitrogen" );
			#/
			
			//TODO: setup custom death screen message before player dies	
				
			//TODO: have a notetrack to kill player when this occurs
			run_scene( "player_nitrogen_death" );
		}
	}
	
	return iDamage;
}

////////////////////////////////
//                            //
//        Lab Battle          //
//                            //
////////////////////////////////

lab_battle_main()
{
	level.player.overridePlayerDamage = ::player_nitrogen_death;
	
	//setup the elevator
  	level thread inside_lift_init();	
 
	flag_wait( "start_asd_battle" );
	
	//asd off player game space
	level thread ambient_2_1_asd();
	
	//setup Hero threat groups
	level.harper SetThreatBiasGroup( "lab_harper" );
	level.salazar SetThreatBiasGroup( "lab_crosby_salazar" );
	level.crosby SetThreatBiasGroup( "lab_crosby_salazar" );

	// Harper should focus on the top floor guys
	SetThreatBias( "lab_harper", "top_floor_guys", 1500 );
	SetThreatBias( "lab_harper", "first_floor_guys", -15000 );
	
	//Salazar and Crosby should focus on first floor guys
	SetThreatBias( "lab_crosby_salazar", "first_floor_guys", 1500 );
	SetThreatBias( "lab_crosby_salazar", "top_floor_guys", -15000 );		
	
	level thread lab_color_triggers();

	level thread elevator_transition();
		
	autosave_by_name( "lab_1_1_battle" );
	
	level thread first_floor_lab_main();
	level thread second_floor_lab_main();
	
	//once the elevator hits the bottom
	flag_wait( "start_lift_move_down" );
	
	//autosave_by_name( "elevator_bottom" );	
	
	a_ddm_prefab_riotshield = GetEntArray( "ddm_prefab_riotshield", "targetname" );
	foreach( shield in a_ddm_prefab_riotshield )
	{
		shield Delete();
	}
}

ambient_2_1_asd()
{
	trigger_wait( "trig_spawn_ambient_2_1_asd" );
	
	vh_ambient_asd = spawn_vehicle_from_targetname( "ambient_2_1_asd" );
	
	vh_ambient_asd.ignoreme = 1;
	vh_ambient_asd.ignoreall = 1;
	
	vh_ambient_asd veh_magic_bullet_shield( true );
	vh_ambient_asd maps\_metal_storm::metalstorm_stop_ai();
	
	nd_start_node = GetVehicleNode( vh_ambient_asd.target, "targetname" );
	vh_ambient_asd thread go_path( nd_start_node );
	
	vh_ambient_asd waittill( "reached_end_node" );
	VEHICLE_DELETE( vh_ambient_asd );
}

init_window_jumper()
{
	self endon( "death" );
	
	self.ignoreme = 1;
	self.ignoreall = 1;
	self.ignoresupression = 1;
	
	s_window_jumper_target = getstruct( "window_jumper_target", "targetname" );
	
	MagicBullet( "qcw05_sp", self GetTagOrigin( "tag_flash" ), s_window_jumper_target.origin );
	MagicBullet( "qcw05_sp", self GetTagOrigin( "tag_flash" ), s_window_jumper_target.origin );
	MagicBullet( "qcw05_sp", self GetTagOrigin( "tag_flash" ), s_window_jumper_target.origin );
	MagicBullet( "qcw05_sp", self GetTagOrigin( "tag_flash" ), s_window_jumper_target.origin );
	MagicBullet( "qcw05_sp", self GetTagOrigin( "tag_flash" ), s_window_jumper_target.origin );
	
	self waittill( "goal" );
	
	self.ignoreme = 0;
	self.ignoreall = 0;
	self.ignoresupression = 0;
}
	
lab_color_triggers()
{
	//upper lab level split path triggers
	a_lab_color_triggers = GetEntArray( "lab_color_triggers", "script_noteworthy" );
	foreach( trigger in a_lab_color_triggers )
	{
		trigger thread notify_targeted_trigger();
	}
	
	//lower lab level split path triggers
	a_lower_lab_color_triggers = GetEntArray( "lower_lab_color_triggers", "script_noteworthy" );
	foreach( trigger in a_lower_lab_color_triggers )
	{
		trigger thread notify_targeted_trigger();
	}
}

notify_targeted_trigger()
{
	self waittill( "trigger" );
	
	e_trig_split_path = GetEnt( self.target, "targetname" );
	e_trig_split_path UseBy( level.player );	
}

lab_spawn_funcs()
{
	CreateThreatBiasGroup( "lab_harper" );
	CreateThreatBiasGroup( "lab_crosby_salazar" );
	
	CreateThreatBiasGroup( "first_floor_guys" );
	CreateThreatBiasGroup( "top_floor_guys" );
	
	//post elevator
	CreateThreatBiasGroup( "lower_lab_harper_crosby" );
	CreateThreatBiasGroup( "lower_lab_salazar" );
	
	CreateThreatBiasGroup( "right_path_guys" );
	CreateThreatBiasGroup( "left_path_guys" );

	//Setup isaac
	ai_isaac = GetEnt( "isaac", "targetname" );
	ai_isaac add_spawn_function( ::setup_isaac );
	
	a_top_floor_guys = GetEntArray( "top_floor_guys", "script_noteworthy" );
	array_thread( a_top_floor_guys, ::add_spawn_function, ::init_top_floor_guys );
	
	a_first_floor_guys = GetEntArray( "first_floor_guys", "script_noteworthy" );
	array_thread( a_first_floor_guys, ::add_spawn_function, ::init_first_floor_guys );
	
	//scientist runners
	a_lab_scientist = GetEntArray( "ambient_lab_scientists", "script_noteworthy" );
	array_thread( a_lab_scientist, ::add_spawn_function, ::init_lab_scientists );
	
	//guy who shoots window and traverses through
	ai_window_jumper = GetEnt( "window_jumper", "script_noteworthy" );
	ai_window_jumper add_spawn_function(  ::init_window_jumper );
	
	ai_left_lobby_guy = GetEnt( "left_lobby_guy", "script_noteworthy" );
	ai_left_lobby_guy add_spawn_function( ::trigger_left_lobby_color );
	
	ai_right_lobby_guy = GetEnt( "right_lobby_guy", "script_noteworthy" );
	ai_right_lobby_guy add_spawn_function( ::trigger_right_lobby_color );
	
	a_left_path_guys = GetEntArray( "left_path_guys", "targetname" );
	array_thread( a_left_path_guys, ::add_spawn_function, ::init_left_path_guys );
	
	a_right_path_guys = GetEntArray( "right_path_guys", "targetname" );
	array_thread( a_right_path_guys, ::add_spawn_function, ::init_right_path_guys );	
	
	// Vehicle Spawn Functions
	add_spawn_function_veh( "nitrogen_asd", ::init_nitrogen_asd );
	add_spawn_function_veh( "right_path_asd", ::init_right_path_asd );
	
	add_spawn_function_veh( "asd_defend_1", maps\monsoon_lab_defend::init_defend_left_asd );
	add_spawn_function_veh( "asd_defend_2", maps\monsoon_lab_defend::init_defend_right_asd );
	add_spawn_function_veh( "right_path_asd", maps\monsoon_lab_defend::init_right_path_asd );
	
	a_area_1_enemies = GetEntArray( "area_1_enemies", "targetname" );
	array_thread( a_area_1_enemies, ::add_spawn_function, ::init_defend_enemies );		
	
	a_area_2_enemies = GetEntArray( "area_2_enemies", "targetname" );
	array_thread( a_area_2_enemies, ::add_spawn_function, ::init_defend_enemies );	
}

setup_isaac()
{
	self endon( "death" );
	level.isaac = self;
}

init_defend_enemies()
{
	self endon( "death" );
	
	self change_movemode( "cqb" );
	
	//flag checks for which spawner targets to go to
}

init_left_path_guys()
{
	self endon( "death" );
	
	self SetThreatBiasGroup( "left_path_guys" );
}

init_right_path_guys()
{
	self endon( "death" );
	
	self SetThreatBiasGroup( "right_path_guys" );
}

monitor_nitrogen_as_death()
{
	self waittill( "death" );
	
	/#
		//IPrintLnBold( "asd died" );
	#/
	
	flag_set( "nitrogen_asd_is_dead" );
		
	trigger_use( "trig_nitrogen_guys_half" );
}

init_nitrogen_asd()
{
	self endon( "death" );
	
	self.ignoreme = 1;
	
	self thread monitor_nitrogen_as_death();
	
	self thread player_asd_rumble();
	self veh_magic_bullet_shield( true );
	self maps\_metal_storm::metalstorm_stop_ai();
	
	nd_start_node = GetVehicleNode( self.target, "targetname" );
	self thread go_path( nd_start_node );
	self waittill( "reached_end_node" );	
	
	flag_wait( "start_shooting_lift" );
	
	self thread metalstorm_weapon_think();	
	
	flag_wait( "lift_at_bottom" );
	
	self veh_magic_bullet_shield( false );
	
	flag_wait( "nitrogen_asd_fallback_1" );
	
	self maps\_vehicle::vehicle_pathdetach();		
	
	self ResumeSpeed( 5 );

	self.ignoreme = 0;
	
	s_nitrogen_asd_elevator_pos = getstruct( "nitrogen_asd_elevator_pos", "targetname" );
	self SetVehGoalPos( s_nitrogen_asd_elevator_pos.origin, true, 2, true );
	self waittill_any( "goal", "near_goal" );	
	
	self maps\_vehicle::defend( self.origin, 250 );
	
	flag_wait( "nitrogen_asd_fallback_2" );
		
	s_nitrogen_asd_fallback_pos_1 = getstruct( "nitrogen_asd_fallback_pos_1", "targetname" );
	self SetVehGoalPos( s_nitrogen_asd_fallback_pos_1.origin, true, 2, true );
	self waittill_any( "goal", "near_goal" );	
	
	self maps\_vehicle::defend( self.origin, 350 );	
}

init_right_path_asd()
{
	self endon( "death" );
	
	self thread monitor_right_path_asd_death();

	self thread player_asd_rumble();
	self maps\_metal_storm::metalstorm_stop_ai();
	
	self thread metalstorm_weapon_think();	
	
	nd_start_node = GetVehicleNode( self.target, "targetname" );
	self thread go_path( nd_start_node );
	
	flag_wait( "right_path_asd_fallback" );
	
	self maps\_vehicle::vehicle_pathdetach();		
	
	self ResumeSpeed( 5 );	
	
	s_right_path_asd_fallback = getstruct( "right_path_asd_fallback", "targetname" );
	self SetVehGoalPos( s_right_path_asd_fallback.origin, true, 2, true );
	self waittill_any( "goal", "near_goal" );	
	
	self maps\_vehicle::defend( self.origin, 350 );
}

monitor_right_path_asd_death()
{
	self waittill( "death" );
	flag_set( "right_path_asd_destroyed" );
}

trigger_left_lobby_color()
{
	self waittill( "death" );
	trigger_use( "trig_left_lobby_guy" );
}

trigger_right_lobby_color()
{
	self waittill( "death" );
	trigger_use( "trig_right_lobby_guy" );
}
	
init_lab_scientists()
{
	self endon( "death" );
	
	self.team = "neutral";
	self.goalradius = 64;
	self.ignoreme = 1;
	self.ignoreall = 1;
	self.ignoresuppression = 1;
	self gun_remove();

	nd_delete_kill = GetNode( self.target, "targetname" );
	self SetGoalPos( nd_delete_kill.origin );
	self waittill_notify_or_timeout( "goal", 5 );
	
	if ( self CanSee( level.player ) )
	{
		self Die();
	}
	else
	{
		self Delete();
	}
}

init_top_floor_guys()
{
	self endon( "death" );
	
	self SetThreatBiasGroup( "top_floor_guys" );
}

init_first_floor_guys()
{
	self endon( "death" );
	
	self SetThreatBiasGroup( "first_floor_guys" );
}

////////////////////////////////
//                            //
//   1st Floor Lab Battle     //
//                            //
////////////////////////////////

first_floor_lab_main()
{
	level thread harper_speed_up();
	
	trigger_wait( "trig_sm_lab_1_1_frontline" );
		
	level thread custom_lab_deaths_entrances();
	
	use_trigger_on_group_count( "lab_1_1_frontline", "trig_lab_1_1_frontline_half", 2 );
	use_trigger_on_group_clear( "lab_1_1_frontline", "trig_lab_1_1_color_frontline_cleared" );	

	use_trigger_on_group_count( "lab_1_1_guys", "trig_lab_1_1_guys_half", 2 );
	
	use_trigger_on_group_count( "lab_1_2_guys", "trig_lab_1_2_guys_half", 2 );
	use_trigger_on_group_clear( "lab_1_2_guys", "trig_lab_1_2_guys_cleared" );	
	
	//Monitor Color Chains for lab_1_1
	level thread monitor_lab_1_1_frontline();
	level thread monitor_lab_1_1();
	
	trigger_wait( "trig_sm_lab_1_2_frontline" );
	
	flag_set( "lab_2_1_left_door" );
	flag_set( "lab_2_1_right_door" );
	flag_set( "lab_doors_open" );	
}

harper_speed_up()
{
	level endon( "salazar_crosby_speed_up" );
	
	trigger_wait( "trig_harper_speed_up" );
	
	level notify( "harper_speed_up" );
	
	//disable all upstair spawn managers
	spawn_manager_disable( "trig_sm_lab_2_1_frontline" );
	spawn_manager_disable( "trig_sm_lab_2_1" );
	spawn_manager_disable( "trig_sm_lab_2_2" );
	
	//grab all axis touching the upstairs trigger and delete them
	trig_top_floor_volume = GetEnt( "trig_top_floor_volume", "targetname" );
	a_axis_ai = GetAiArray( "axis" );
	foreach( ai in a_axis_ai )
	{
		if ( ai IsTouching( trig_top_floor_volume ) )
		{
			ai die();
		}
	}
	
	//a guy for harper to take out as he runs to his node
	simple_spawn_single( "harper_speed_up_victim" );

	level.harper disable_ai_color();
	
	//teleport here
	s_harper_speed_up_pos = getstruct( "harper_speed_up_pos", "targetname" );
	level.harper teleport( s_harper_speed_up_pos.origin, s_harper_speed_up_pos.angles );
	
	nd_harper_pre_lift = GetNode( "harper_pre_lift", "targetname" );
	level.harper.goalradius = 32;
	level.harper SetGoalNode( nd_harper_pre_lift );
}

salazar_crosby_speed_up()
{
	level endon( "harper_speed_up" );
	
	trigger_wait( "trig_salazar_crosby_speed_up" );
	
	level notify( "salazar_crosby_speed_up" );
	
	spawn_manager_disable( "trig_sm_lab_1_1_frontline" );
	spawn_manager_disable( "trig_sm_lab_1_1" );
	spawn_manager_disable( "trig_sm_lab_1_2_frontline" );
	spawn_manager_disable( "trig_sm_lab_1_2" );
	
	//grab all axis touching the upstairs trigger and delete them
	trig_bottom_floor_volume = GetEnt( "trig_bottom_floor_volume", "targetname" );
	a_axis_ai = GetAiArray( "axis" );
	foreach( ai in a_axis_ai )
	{
		if ( ai IsTouching( trig_bottom_floor_volume ) )
		{
			ai.a.deathForceRagdoll = true;
			ai die();
		}
	}	
	
	simple_spawn( "sal_crosby_speed_up_victims" );
	
	level.salazar disable_ai_color();
	level.crosby disable_ai_color();
		
	s_salazar_speed_up_pos = getstruct( "salazar_speed_up_pos", "targetname" );
	s_crosby_speed_up_pos = getstruct( "crosby_speed_up_pos", "targetname" );

	//teleport here
	level.salazar teleport( s_salazar_speed_up_pos.origin, s_salazar_speed_up_pos.angles );
	level.crosby teleport( s_crosby_speed_up_pos.origin, s_crosby_speed_up_pos.angles );
	
	//send both of them to their lift nodes
	nd_salazar_pre_lift = GetNode( "salazar_pre_lift", "targetname" );
	level.salazar.goalradius = 32;
	level.salazar SetGoalNode( nd_salazar_pre_lift );		
	
	nd_crosby_pre_lift = GetNode( "crosby_pre_lift", "targetname" );
	level.crosby.goalradius = 32;
	level.crosby SetGoalNode( nd_crosby_pre_lift );	
}

custom_lab_deaths_entrances()
{
	level thread stair_tumble_guy();
	
	level thread harper_railing_throw();
	
	level thread lab_window_jumpers();
}

stair_tumble_guy()
{
	level endon( "stop_stair_guy_scene" );
	
	trigger_wait( "trig_stair_tumble_guy" );
	
	trig_bottom_floor_volume = GetEnt( "trig_bottom_floor_volume", "targetname" );
	
	//check if player is downstairs
	if ( level.player IsTouching( trig_bottom_floor_volume ) )
	{
		run_scene( "stair_tumble_death" );
	}
}

harper_railing_throw()
{
	level endon( "stop_harper_throw" );
	level endon( "stop_stair_guy_scene" );
	
	trigger_wait( "trig_harper_railing_throw" );
	
	spawn_manager_disable( "trig_sm_lab_2_1" );
	
	trig_bottom_floor_volume = GetEnt( "trig_bottom_floor_volume", "targetname" );
	
	//check if player is downstairs
	if ( level.player IsTouching( trig_bottom_floor_volume ) )
	{
		spawn_manager_disable( "trig_sm_lab_2_1" );
	
		trig_volume_harper_throw = GetEnt( "trig_volume_harper_throw", "targetname" );
		
		a_axis_ai = GetAIArray( "axis" );
		foreach( axis in a_axis_ai )
		{
				if ( axis IsTouching( trig_volume_harper_throw ) )
				{
					if ( axis CanSee( level.player ) )
					{
						axis Die();
					}
					else
					{
						axis Delete();
					}
				}
		}
		
		//level.harper.ignoreme = 1;
	
		run_scene( "harper_railing_throw" );
	
		//level.harper.ignoreme = 0;
	
		trigger_use( "trig_color_post_throw" ); //send him to the closest color node		
	}
}

lab_window_jumpers()
{
	level endon( "stop_window_jumper" );
	
	trigger_wait( "trig_window_jumper" );

	s_window_jumper_target = getstruct( "window_jumper_target", "targetname" );
	s_window_jumper_target_end = getstruct( s_window_jumper_target.target, "targetname" );
	
	MagicBullet( "qcw05_sp", s_window_jumper_target.origin, s_window_jumper_target_end.origin );
	MagicBullet( "qcw05_sp", s_window_jumper_target.origin, s_window_jumper_target_end.origin );
	MagicBullet( "qcw05_sp", s_window_jumper_target.origin, s_window_jumper_target_end.origin );
	MagicBullet( "qcw05_sp", s_window_jumper_target.origin, s_window_jumper_target_end.origin );
	MagicBullet( "qcw05_sp", s_window_jumper_target.origin, s_window_jumper_target_end.origin );
	
	level thread run_scene( "window_jumper_1" );
//	level thread run_scene( "window_jumper_2" );
}

monitor_lab_1_1_frontline()
{
	waittill_ai_group_count( "lab_1_1_frontline", 2 );		
	trigger_use( "trig_sm_lab_1_1" ); 
}

monitor_lab_1_1()
{
	waittill_ai_group_count( "lab_1_1_guys", 2 );	
	trigger_use( "trig_sm_lab_1_2_frontline" );
}

////////////////////////////////
//                            //
//   2nd Floor Lab Battle     //
//                            //
////////////////////////////////

second_floor_lab_main()
{
	level thread salazar_crosby_speed_up();
	
	trigger_wait( "trig_sm_lab_2_1_frontline" );
	
	level thread monitor_harper_color_chains();
	level thread monitor_salazar_color_chains();
	
	//use_trigger_on_group_count
	use_trigger_on_group_count( "lab_2_1_frontline", "trig_lab_2_1_frontline_half", 2 );
	use_trigger_on_group_clear( "lab_2_1_frontline", "trig_lab_2_1_frontline_cleared" );	
	
	use_trigger_on_group_count( "lab_2_1_guys", "trig_lab_2_1_guys_half", 2 );

	use_trigger_on_group_count( "lab_2_2_guys", "trig_lab_2_2_guys_half", 2 );
	use_trigger_on_group_clear( "lab_2_2_guys", "trig_lab_2_2_guys_cleared" );	
	
	//Monitor Color Chains for lab_2_1
	level thread monitor_lab_2_1_frontline();
	
	//Monitor Color Chains for lab_2_2
	level thread monitor_lab_2_2();
}

monitor_harper_color_chains()
{
	//-- triggers downstairs frontline if player goes upstairs
	trigger_wait( "trig_sm_lab_2_1_frontline" );
	trigger_use( "trig_sm_lab_1_1_frontline" );
	
	//-- populate first half area 1 of downstairs
	trigger_wait( "trig_lab_2_1_frontline_half" );
	trigger_use( "trig_sm_lab_1_1" );
	
	//trigger_wait( "trig_lab_2_1_frontline_cleared" );
	//-- nothing here to spawn yet
	
	//-- halfway through the top floor, populate second half of first floor
	trigger_wait( "trig_lab_2_1_guys_half" );
	trigger_use( "trig_lab_1_1_guys_half" );
	trigger_use( "trig_sm_lab_1_2_frontline" );
	
	//-- halfway through area 2 of top floor, populate end of first floor
	trigger_wait( "trig_lab_2_2_frontline_half" );
	trigger_use( "trig_sm_lab_1_2" );
	
	//trigger_wait( "trig_lab_2_2_guys_half" );
	//-- nothing here to spawn yet
}

monitor_salazar_color_chains()
{
	//-- triggers upstairs frontline if player goes downstairs	
	trigger_wait( "trig_sm_lab_1_1_frontline" );
	trigger_use( "trig_sm_lab_2_1_frontline" );
	
	//-- populate first half area 1 of upstairs	
	trigger_wait( "trig_lab_1_1_frontline_half" );
	trigger_use( "trig_lab_2_1_frontline_half" );
		
	//-- populate area 1 of upstairs
	trigger_wait( "trig_lab_1_1_color_frontline_cleared" );
	trigger_use( "trig_sm_lab_2_1" );
	
	//open both doors
	flag_set( "lab_doors_open" );

	//-- populate area 2 of upstairs
	trigger_wait( "trig_lab_1_1_guys_half" );
	trigger_use( "trig_sm_lab_2_2" );
	
	//-- eventually want to spawn some guys here
	//trigger_wait( "trig_lab_1_2_frontline_half" );
	//nothing here to spawn yet
	
	//trigger_wait( "trig_lab_1_2_guys_half" );	
	//trigger_wait( "trig_lab_1_2_guys_cleared" );
}

monitor_lab_2_1_frontline()
{	
	waittill_ai_group_count( "lab_2_1_frontline", 2 );
	trigger_use( "trig_sm_lab_2_1" );
}

monitor_lab_2_2()
{
	trigger_wait( "trig_sm_lab_2_1" );
	
	waittill_ai_group_count( "lab_2_2_guys", 2 );	
	trigger_use( "trig_sm_lab_2_2" );
}

elevator_transition()
{
	trigger_wait( "interior_lift_trigger" );
	
	a_lab_lift_guys = simple_spawn( "lab_lift_guys" );
	
	wait 0.05;
	
	flag_set( "start_lift_move_up" );
		
	flag_wait( "lift_at_top" );
	
	waittill_ai_group_cleared( "lab_lift_guys" );

	foreach( hero in level.heroes )
	{
		hero disable_ai_color();
	}
	
	//TEMP: clean up
	ai_axis = GetAiArray( "axis" );
	foreach( ai in ai_axis )
	{
		ai Die();
	}
		
	level.harper thread harper_elevator_ride();
	level.salazar thread salazar_elevator_ride();
	level.crosby thread crosby_elevator_ride();
	
	trig_elevator_volume = GetEnt( "trig_elevator_volume", "targetname" );
	
	while ( 1 )
	{
		if ( level.crosby IsTouching( trig_elevator_volume ) &&
		   	 level.harper IsTouching( trig_elevator_volume ) &&
		  	 level.salazar IsTouching( trig_elevator_volume )
		   )
		{
			break;
		}
	
		wait 0.05;		
	}
		
	wait 2;
	
	flag_set( "elevator_is_ready" );
	
	autosave_by_name( "lab_interior_elevator" );
	
	e_trig_elevator_panel = GetEnt( "trig_elevator_panel", "targetname" );
	e_trig_elevator_panel trigger_on();	
	e_trig_elevator_panel SetHintString( &"MONSOON_LIFT_PROMPT" );
	e_trig_elevator_panel SetCursorHint( "HINT_NOICON" );		
	e_trig_elevator_panel waittill( "trigger" );
	e_trig_elevator_panel SetHintString( "" );
	
	run_scene( "player_lift_interact" );
	
	flag_set( "start_lift_move_down" );
}

harper_elevator_ride()
{
	run_scene( "harper_elevator_enter" );
	
	level thread run_scene( "harper_elevator_idle" );
	
	flag_wait( "start_elevator_exits" );
	
	end_scene( "harper_elevator_idle" );
	delete_scene( "harper_elevator_idle" );
	
	//flag_wait( "lift_at_bottom" );
	
//	e_elevator_regroup = GetEnt( "elevator_regroup", "targetname" );
//	level.harper LinkTo( e_elevator_regroup );
	
	run_scene( "harper_elevator_exit" );
	
//	level thread run_scene( "harper_elevator_loop" );
}

salazar_elevator_ride()
{
	run_scene( "salazar_elevator_enter" );
	
	level thread run_scene( "salazar_elevator_idle" );
	
	//flag_wait( "lift_at_bottom" );
	flag_wait( "start_elevator_exits" );
	
	e_elevator_regroup = GetEnt( "elevator_regroup", "targetname" );
	level.salazar LinkTo( e_elevator_regroup );
	
	run_scene( "salazar_elevator_exit" );	
}

crosby_elevator_ride()
{
	run_scene( "crosby_elevator_enter" );
	
	level thread run_scene( "crosby_elevator_idle" );
	
	flag_wait( "start_elevator_exits" );
	//flag_wait( "lift_at_bottom" );
	
	e_elevator_regroup = GetEnt( "elevator_regroup", "targetname" );
	level.crosby LinkTo( e_elevator_regroup );
		
	run_scene( "crosby_elevator_exit" );	
}

////////////////////////////////
//                            //
//      INSIDE LIFT           //
//                            //
////////////////////////////////
	
inside_lift_init()
{
	m_lift = GetEnt( "lift_interior", "targetname" );

	lift_interior_m = GetEnt( "lift_interior_m", "targetname" );
	lift_interior_m LinkTo( m_lift );

	//link brushmodels of the elevator doors
	a_bm_doors[0] = GetEnt( "lift_interior_door_2_left", "targetname" );
	a_bm_doors[1] = GetEnt( "lift_interior_door_2_right", "targetname" );

	a_bm_doors[2] = GetEnt( "lift_interior_door_1_left", "targetname" );
	a_bm_doors[3] = GetEnt( "lift_interior_door_1_right", "targetname" );
	foreach( bm_door in a_bm_doors )
	{
		bm_door LinkTo( m_lift );
	}
	
	//link models of the doors
	a_m_doors[0] = GetEnt( "lift_interior_door_2_left_m", "targetname" );
	a_m_doors[1] = GetEnt( "lift_interior_door_2_right_m", "targetname" );

	a_m_doors[2] = GetEnt( "lift_interior_door_1_left_m", "targetname" );
	a_m_doors[3] = GetEnt( "lift_interior_door_1_right_m", "targetname" );
	foreach( m_door in a_m_doors )
	{
		m_door LinkTo( m_lift );
	}
	
	//sort through the various nodes on the lift
	m_lift.a_right_nodes = GetNodeArray( "interior_lift_right_nodes", "targetname" );
	m_lift.a_left_nodes = GetNodeArray( "interior_lift_left_nodes", "targetname" );

	//assign the top and bottom position of the lift
	m_lift.v_lift_bottom = m_lift.origin;
	m_lift.v_lift_top = ( m_lift.origin[0], m_lift.origin[1], getstruct( "interior_lift_up", "targetname" ).origin[2] );
	
	level thread inside_lift_move_up();
	level thread inside_lift_move_down();
}

//self is the lift model
inside_lift_move_down()
{
	flag_wait( "start_lift_move_down" );
	
	//SOUND - Shawn J
	//iprintlnbold ("elevator_doors_close");
	playsoundatposition ("evt_elevator_close_2d", (0,0,0) );
	
	e_player_elevator_top_clip = GetEnt( "player_elevator_top_clip", "targetname" );
	e_player_elevator_top_clip DisconnectPaths();
	e_player_elevator_top_clip Solid();	
	
	m_lift = GetEnt( "lift_interior", "targetname" );
	
	//manually disconnect nodes on the top floor
	interior_lift_top_connect_left = GetNodeArray( "interior_lift_top_connect_left", "targetname" );
	interior_lift_top_connect_right = GetNodeArray( "interior_lift_top_connect_right", "targetname" );
	
	array_func( m_lift.a_right_nodes, ::_interior_elevator_disconnect_nodes, interior_lift_top_connect_right );
	array_func( m_lift.a_left_nodes, ::_interior_elevator_disconnect_nodes, interior_lift_top_connect_left );
	
	//close the doors
	bm_door_south_l = GetEnt( "lift_interior_door_1_left", "targetname" );
	bm_door_south_r = GetEnt( "lift_interior_door_1_right", "targetname" );
	
	bm_door_north_l = GetEnt( "lift_interior_door_2_left", "targetname" );
	bm_door_north_r = GetEnt( "lift_interior_door_2_right", "targetname" );

	//models
	m_door_south_l = GetEnt( "lift_interior_door_2_left_m", "targetname" );
	m_door_south_r = GetEnt( "lift_interior_door_2_right_m", "targetname" );

	m_door_north_l = GetEnt( "lift_interior_door_1_left_m", "targetname" );
	m_door_north_r = GetEnt( "lift_interior_door_1_right_m", "targetname" );	
	
	m_door_south_l Unlink();
	m_door_south_r Unlink();
	
	m_door_north_l Unlink();
	m_door_north_r Unlink();	
	
	bm_door_north_l Unlink();
	bm_door_north_r Unlink();
	
	bm_door_south_l Unlink();
	bm_door_south_r Unlink();
	
	m_door_south_l MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	m_door_south_r MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );

	m_door_north_l MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	m_door_north_r MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );	
	
	bm_door_south_l MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	bm_door_south_r MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );

	bm_door_north_l MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	bm_door_north_r MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	
	bm_door_north_r waittill( "movedone" );
	//close the doors
	
	//SOUND - Shawn J
	//iprintlnbold ("elevator_ride_start");
	playsoundatposition ("evt_elevator_start", (0,0,0) );
	
	level thread elevator_loop_n_stop_sounds();
	
	m_door_south_l LinkTo( m_lift );
	m_door_south_r LinkTo( m_lift );
	
	m_door_north_l LinkTo( m_lift );
	m_door_north_r LinkTo( m_lift );	
	
	bm_door_north_l LinkTo( m_lift );
	bm_door_north_r LinkTo( m_lift );	

	bm_door_south_l LinkTo( m_lift );
	bm_door_south_r LinkTo( m_lift );
	
	level.player thread rumble_loop( INT_LIFT_MOVE_TIME, 0.05, "tank_rumble" );
	
	delay_thread( 5, ::flag_set, "spawn_nitrogen_guys" );
	delay_thread( 5, ::flag_set, "start_elevator_exits" );
	
	flag_set( "start_shooting_lift" );
	
	m_lift MoveTo( m_lift.v_lift_bottom, INT_LIFT_MOVE_TIME, ( INT_LIFT_MOVE_TIME / 5 ), ( INT_LIFT_MOVE_TIME / 5 ) );
	m_lift waittill( "movedone" );
	
		
	//SOUND - Shawn J
	//iprintlnbold ("elevator_doors_open");
	playsoundatposition ("evt_elevator_open_2d", (0,0,0) );
	
	e_player_elevator_bottom_clip = GetEnt( "player_elevator_bottom_clip", "targetname" );
	e_player_elevator_bottom_clip ConnectPaths();
	e_player_elevator_bottom_clip Delete();

	bm_door_north_l Unlink();
	bm_door_north_r Unlink();
	
	bm_door_south_l Unlink();
	bm_door_south_r Unlink();

	m_door_north_l Unlink();
	m_door_north_r Unlink();
	
	m_door_south_l Unlink();
	m_door_south_r Unlink();	
	
	//open the doors
	m_door_north_l MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	m_door_north_r MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	
	m_door_south_l MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	m_door_south_r MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );	
	
	//open the doors
	bm_door_north_l MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	bm_door_north_r MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	
	bm_door_south_l MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	bm_door_south_r MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	
	bm_door_south_r waittill( "movedone" );

	flag_set( "lift_at_bottom" );
	
	bm_door_south_l LinkTo( m_lift );
	bm_door_south_r LinkTo( m_lift );	

	bm_door_north_l LinkTo( m_lift );
	bm_door_north_r LinkTo( m_lift );
	
	m_door_south_l LinkTo( m_lift );
	m_door_south_r LinkTo( m_lift );
	
	m_door_north_l LinkTo( m_lift );
	m_door_north_r LinkTo( m_lift );

	//manually connect nodes on the bottom floor
	interior_lift_bottom_connect_left = GetNodeArray( "interior_lift_bottom_connect_left", "targetname" );
	interior_lift_bottom_connect_right = GetNodeArray( "interior_lift_bottom_connect_right", "targetname" );
	
	array_func( m_lift.a_right_nodes, ::_interior_elevator_connect_nodes, interior_lift_bottom_connect_right );
	array_func( m_lift.a_left_nodes, ::_interior_elevator_connect_nodes, interior_lift_bottom_connect_left );
}

elevator_loop_n_stop_sounds()
{
	elevator_ent_2 = spawn( "script_origin", (0,0,0) );	
	elevator_ent_2 PlayLoopSound ("evt_elevator_loop", 2.5);
	wait(6);
	//iprintlnbold ("elevator_up_stop_2");
	elevator_ent_2 StopLoopSound (1);
	playsoundatposition ("evt_elevator_stop", (9277, 57793, -943) );	
	elevator_ent_2 delete();
}

//self is the trigger
inside_lift_move_up()
{
	flag_wait( "start_lift_move_up" );
	
	//SOUND - Shawn J
	//iprintlnbold ("elevator_up_start");
	elevator_ent = spawn( "script_origin", (9385, 57792, -987) );	
	elevator_ent PlayLoopSound ("evt_elevator_loop_3d", .5);
	level thread elevator_stop_1_sound(elevator_ent);
	
	m_lift = GetEnt( "lift_interior", "targetname" );
	lift_interior_m = GetEnt( "lift_interior_m", "targetname" );

	//play FX on the lift model
	lift_interior_m play_fx( "lift_light", lift_interior_m.origin, lift_interior_m.angles, undefined, true );	
	
	s_elevator_spotight_struct = getstruct( "elevator_spotight_struct", "targetname" );

	m_lift play_fx( "lift_spotlight", s_elevator_spotight_struct.origin, s_elevator_spotight_struct.angles, undefined, true );	

	array_func( m_lift.a_right_nodes, ::node_disconnect_from_path );
	array_func( m_lift.a_left_nodes, ::node_disconnect_from_path );
	
	bm_door_south_l = GetEnt( "lift_interior_door_1_left", "targetname" );
	bm_door_south_r = GetEnt( "lift_interior_door_1_right", "targetname" );
	
	bm_door_north_l = GetEnt( "lift_interior_door_2_left", "targetname" );
	bm_door_north_r = GetEnt( "lift_interior_door_2_right", "targetname" );
	
	//models
	m_door_south_l = GetEnt( "lift_interior_door_2_left_m", "targetname" );
	m_door_south_r = GetEnt( "lift_interior_door_2_right_m", "targetname" );

	m_door_north_l = GetEnt( "lift_interior_door_1_left_m", "targetname" );
	m_door_north_r = GetEnt( "lift_interior_door_1_right_m", "targetname" );
	
	m_lift MoveTo( m_lift.v_lift_top, INT_LIFT_MOVE_TIME, ( INT_LIFT_MOVE_TIME / 5 ), ( INT_LIFT_MOVE_TIME / 5 ) );
	m_lift waittill( "movedone" );
	
	//SOUND - Shawn J
	//iprintlnbold ("elevator_doors_open");
	playsoundatposition ("evt_elevator_open", (9403, 57800, -929) );

	e_player_elevator_top_clip = GetEnt( "player_elevator_top_clip", "targetname" );
	e_player_elevator_top_clip ConnectPaths();
	e_player_elevator_top_clip NotSolid();
	
	m_door_south_l Unlink();
	m_door_south_r Unlink();
	
	m_door_north_l Unlink();
	m_door_north_r Unlink();
		
	bm_door_north_l Unlink();
	bm_door_north_r Unlink();

	bm_door_south_l Unlink();
	bm_door_south_r Unlink();

	m_door_north_l MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	m_door_north_r MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );

	m_door_south_l MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	m_door_south_r MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	
	bm_door_north_l MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	bm_door_north_r MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );

	bm_door_south_l MoveY( INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	bm_door_south_r MoveY( -INT_LIFT_DOOR_DIST, INT_LIFT_DOOR_TIME, INT_LIFT_DOOR_TIME / 4 );
	
	bm_door_north_r waittill( "movedone" );
	
	bm_door_north_l LinkTo( m_lift );
	bm_door_north_r LinkTo( m_lift );	

	bm_door_south_l LinkTo( m_lift );
	bm_door_south_r LinkTo( m_lift );		

	m_door_north_l LinkTo( m_lift );
	m_door_north_r LinkTo( m_lift );	

	m_door_south_l LinkTo( m_lift );
	m_door_south_r LinkTo( m_lift );	

	flag_set( "lift_at_top" );	
	
	e_elevator_regroup = GetEnt( "elevator_regroup", "targetname" );
	e_elevator_regroup LinkTo( m_lift );		
	
	//manually connect nodes on the top floor
	interior_lift_top_connect_left = GetNodeArray( "interior_lift_top_connect_left", "targetname" );
	interior_lift_top_connect_right = GetNodeArray( "interior_lift_top_connect_right", "targetname" );
	
	array_func( m_lift.a_right_nodes, ::_interior_elevator_connect_nodes, interior_lift_top_connect_right );
	array_func( m_lift.a_left_nodes, ::_interior_elevator_connect_nodes, interior_lift_top_connect_left );
}

elevator_stop_1_sound(elevator_ent)
{
	wait(6);
	//iprintlnbold ("elevator_up_stop");
	elevator_ent StopLoopSound(.5);
	playsoundatposition ("evt_elevator_stop_3d", (9277, 57793, -943) );	
}

_interior_elevator_connect_nodes( a_nodes )
{
	foreach( nd_node in a_nodes )
	{
		LinkNodes( self, nd_node );
		LinkNodes( nd_node, self );
	}
}

_interior_elevator_disconnect_nodes( a_nodes )
{
	foreach( nd_node in a_nodes )
	{
		UnLinkNodes( self, nd_node );
		UnLinkNodes( nd_node, self);	
	}	
}

fight_to_isaac_main()
{
	flag_wait( "spawn_nitrogen_guys" );

	//setup Hero threat groups
	level.harper SetThreatBiasGroup( "lower_lab_harper_crosby" );
	level.crosby SetThreatBiasGroup( "lower_lab_harper_crosby" );

	level.salazar SetThreatBiasGroup( "lower_lab_salazar" );
	
	// Harper should focus on the top floor guys
	SetThreatBias( "lower_lab_harper_crosby", "right_path_guys", 1500 );
	SetThreatBias( "lower_lab_harper_crosby", "left_path_guys", -15000 );
	
	//Salazar and Crosby should focus on first floor guys
	SetThreatBias( "lower_lab_salazar", "left_path_guys", 1500 );
	SetThreatBias( "lower_lab_salazar", "right_path_guys", -15000 );		
	
	level.harper monsoon_hero_rampage( true );
	level.salazar monsoon_hero_rampage( true );
	level.crosby monsoon_hero_rampage( true );
			
	level thread fight_to_isaac_cleanup();
	
	nitrogen_asd = spawn_vehicle_from_targetname( "nitrogen_asd" );
	simple_spawn( "lab_nitrogen_guys" );
	simple_spawn( "nitrogen_scientists" );
	
	flag_wait( "lift_at_bottom" );

	level thread asd_nitrogen_challenge_watch();
	
	foreach( hero in level.heroes )
	{
		hero enable_ai_color();
	}
	
	trigger_use( "trig_elevator_exit" );
	
	level thread harper_destroys_nitrogen_asd( nitrogen_asd );
	
	level thread monitor_lower_lab_right_path();
	level thread monitor_lower_lab_left_path();

	//first encounter when elevator hits bottom
	use_trigger_on_group_count( "lab_nitrogen_guys", "trig_nitrogen_guys_cleared", 1 );
	
	//right path
	//3_1
	use_trigger_on_group_count( "3_1_right_path", "trig_3_1_right_half", 2 );
	use_trigger_on_group_clear( "3_1_right_path", "trig_3_1_right_cleared" );
	
	//3_2
	use_trigger_on_group_count( "3_2_right_path", "trig_3_2_right_half", 2 );
	use_trigger_on_group_clear( "3_2_right_path", "trig_3_2_right_cleared" );
	
	//left path
	//3_1 front
	use_trigger_on_group_clear( "3_1_left_path_front", "trig_3_1_left_front_cleared" );
	
	//3_1
	use_trigger_on_group_clear( "3_1_left_path", "trig_3_1_left_cleared" );
	
	//3_2
	use_trigger_on_group_count( "3_2_left_path", "trig_3_2_left_half", 2 );
	use_trigger_on_group_clear( "3_2_left_path", "trig_3_2_left_cleared" );	
	
	trigger_wait( "trig_lab_3_2_right_sm" );
	spawn_vehicle_from_targetname( "right_path_asd" );
	
	level thread monitor_3_2_guys();
	
	trigger_wait( "trig_start_lab_defend" );
	
	flag_wait( "right_path_asd_destroyed" );
	
	nd_harper_pre_ddm = GetNode( "harper_pre_ddm", "targetname" );
	nd_salazar_pre_ddm = GetNode( "salazar_pre_ddm", "targetname" );
	nd_crosby_pre_ddm = GetNode( "crosby_pre_ddm", "targetname" );
	
	level.harper SetGoalNode( nd_harper_pre_ddm );
	level.salazar SetGoalNode( nd_salazar_pre_ddm );
	level.crosby SetGoalNode( nd_crosby_pre_ddm );
	
	array_wait( level.heroes, "goal" );
}

asd_nitrogen_challenge_watch()
{
	level endon( "lab_defend_done" );
	
	level.n_asd_freeze_test = 0;
	
	while ( 1 )
	{
		level waittill( "asd_freezed" );
		
		level.n_asd_freeze_test++;
		
		level notify( "asd_frozen_challenge" );
		
		/#
//			IPrintLnBold( level.n_asd_freeze_test );
		#/
			
		wait 0.05;
	}
}

monitor_lower_lab_right_path()
{
	trigger_wait( "trig_lab_3_2_right_sm" );
	trigger_use( "trig_lab_3_2_left_sm" );
}

monitor_lower_lab_left_path()
{
	trigger_wait( "trig_lab_3_2_left_sm" );
	trigger_use( "trig_lab_3_2_right_sm" );	
}

harper_destroys_nitrogen_asd( asd )
{
	//FIXME: give heroes all their own align nodes for the elevator ride anim
	level.harper Unlink();
	
	wait 5;
	
	a_lab_nitrogen_guys = get_ai_group_ai( "lab_nitrogen_guys" );
	
	if ( !flag( "nitrogen_asd_fallback_1" ) )
	{
	   	if ( IsDefined( asd ) || a_lab_nitrogen_guys.size >= 4 )
		{
			end_scene( "harper_elevator_exit" );
			delete_scene( "harper_elevator_exit" );
			level thread run_scene( "harper_elevator_fire" );
		}
	}
	
	flag_wait( "nitrogen_asd_fallback_1" );
	
	end_scene( "harper_elevator_fire" );
	delete_scene( "harper_elevator_fire" );
}

//called from a notetrack in harper's animation in scene "harper_elevator_fire"
harper_titus_asd( ai_harper )
{
	s_harper_titus_target = getstruct( "harper_titus_target", "targetname" );
	e_titus_target = Spawn( "script_origin", s_harper_titus_target.origin );
	e_titus_target.angles = s_harper_titus_target.angles;
	
	maps\_titus::magic_bullet_titus( ai_harper GetTagOrigin( "tag_flash" ), e_titus_target.origin, ai_harper );
}

fight_to_isaac_cleanup()
{
	trigger_wait( "trig_clean_nitrogen_guys" );
	
	a_lab_nitrogen_guys = get_ai_group_ai( "lab_nitrogen_guys" );
	foreach( guy in a_lab_nitrogen_guys )
	{
		guy Die();	
	}
}

monitor_3_2_guys()
{
	waittill_ai_group_cleared( "3_2_right_path" );
	waittill_ai_group_cleared( "3_2_left_path" );
	
	flag_set( "start_lab_defend" );
	trigger_use( "trig_start_lab_defend" );
}

camo_kill_challenge_watch()
{
	level.n_camo_kills = 0;
	
  	array_thread( GetSpawnerArray(), ::add_spawn_function, ::camo_kill_challenge_watch_think );
}

camo_kill_challenge_watch_think()
{
	self waittill( "death", eAttacker );

	if ( !level.player ent_flag_exist( "camo_suit_on" ) )
	{
		return;	
	}
		
	if ( IsDefined( eAttacker ) && IsPlayer( eAttacker ) && level.player ent_flag( "camo_suit_on" ) )
	{
		level notify( "camo_death" );
		
		level.n_camo_kills++;
		
		/#
//			IPrintLn( "camo_death" );
//			IPrintLn( level.n_camo_kills );
		#/	
	}
}

challenge_camo_kills( str_notify )
{
	while( 1 )
	{
		level waittill( "camo_death" );
		self notify( str_notify );
		wait 0.05;
	}	
}

challenge_freeze_asds( str_notify )
{
	while ( 1 )
	{
		level waittill( "asd_frozen_challenge" );
		self notify( str_notify );
		
		wait 0.05;
	}
}