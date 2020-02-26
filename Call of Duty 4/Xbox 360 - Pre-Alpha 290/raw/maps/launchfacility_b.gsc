/****************************************************************************
Level: 		"Countdown" ( launchfacility_b.bsp )
Campaign: 	Marine Force Recon
****************************************************************************/

#include maps\_hud_util;
#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#using_animtree( "generic_human" );

main()

{
	maps\_load::main();
	level thread maps\launchfacility_b_amb::main();	
	maps\_c4::main();
	maps\launchfacility_b_anim::main();
	maps\createart\launchfacility_b_art::main();
		
	precachemodel ("com_computer_keyboard_obj");
	precachemodel ("com_computer_keyboard");
	
	precachemodel ("weapon_c4_obj");
	precachemodel ("weapon_c4");	
	
//  progress bar stuff
	precacheShader("white"); 
    precacheShader("black"); 
		
	playerInit();
		
	battlechatter_off( "allies" );
//	battlechatter_off( "axis" );

// 	progress bar stuff
    level.secondaryProgressBarY = 75;
    level.secondaryProgressBarHeight = 14;
    level.secondaryProgressBarWidth = 152;
    level.secondaryProgressBarTextY = 45;
    level.secondaryProgressBarFontSize = 2;
	
	level.usetimer = true;	
	level.missionFailedQuote = &"LAUNCHFACILITY_B_BOMBS_GO_BOOM";	//Generic failure message
	level.c4 = getent( "c4", "targetname" );
	level.keyboard = getent( "keyboard", "targetname" );
	level.elevator_upper = getent( "elevator_upper", "targetname" );
	
//	level.wallExplosionSmall_fx						= loadfx ( "explosions/detpack_explo_concrete" );	
	level.wallExplosionSmall_fx						= loadfx ( "explosions/wall_explosion_small" );
	
//	maps\ned_timer_fx::main();
	
	price_spawner = getent ( "price", "script_noteworthy" );
	price_spawner add_spawn_function( ::price_think );
	
	grigsby_spawner = getent ( "grigsby", "script_noteworthy" );
	grigsby_spawner add_spawn_function( ::grigsby_think );
	
	team1_spawner = getent ( "team1", "script_noteworthy" );
	team1_spawner add_spawn_function( ::team1_think );
	
	vent_friendlies_group1_spawner = getentarray( "vent_friendlies_group1", "script_noteworthy" );
	array_thread ( vent_friendlies_group1_spawner, ::add_spawn_function, ::vent_friendlies_group1_spawner_think );	

	vent_enemies_group1_spawner = getentarray( "vent_enemies_group1", "script_noteworthy" );
	array_thread ( vent_enemies_group1_spawner, ::add_spawn_function, ::vent_enemies_group1_spawner_think );	
		
	vent_friendlies_group2_spawner = getentarray( "vent_friendlies_group2", "script_noteworthy" );
	array_thread ( vent_friendlies_group2_spawner, ::add_spawn_function, ::vent_friendlies_group2_spawner_think );	
	
	vent_enemies_group2_spawner = getentarray( "vent_enemies_group2", "script_noteworthy" );
	array_thread ( vent_enemies_group2_spawner, ::add_spawn_function, ::vent_enemies_group2_spawner_think );	
	
	retreating_enemies_spawner = getentarray( "gassed_runners", "script_noteworthy" );
	array_thread ( retreating_enemies_spawner, ::add_spawn_function, ::warehouse_retreating_enemies_think );	
		
	flag_init ( "10min_left" );	
	flag_init ( "8min_left" );	
	flag_init ( "6min_left" );	
	flag_init ( "5min_left" );	
	flag_init ( "4min_left" );	
	flag_init ( "3min_left" );	
	flag_init ( "2min_left" );	
	flag_init ( "1min_left" );	

 	flag_init ( "timer_expired" );
	flag_init ( "countdown_started" );
 	
 	flag_init ( "walk" );
 	flag_init ( "begin_countdown" );
 	flag_init ( "move_faster" );
 	
 	flag_init ( "blast_door_player_clip_on" );
 	flag_init ( "blast_door_player_clip_off" );
 	
	flag_init ( "open_vault_doors" );
	flag_init ( "vault_doors_unlocked" );
 	flag_init ( "vault_door_opened" );
 	
 	flag_init ( "spawn_c4" );
 	flag_init ( "wall_destroyed" );
 	flag_init ( "remove_c4" );
 	
 	flag_init ( "telemetry_room" );
 	flag_init ( "codes_uploaded" );
 	flag_init ( "weaken_team2" );
 	
 	flag_init ( "elevator_player_clip_on" );
 	flag_init ( "elevator_dialogue" );
 	
 	flag_init ( "at_the_jeep" );
 	flag_init ( "level_end" );	
 
 	flag_init ( "music_start_countdown" );
 
	level thread airduct_fan_large();
 	level thread airduct_fan_small();
 	level thread redlights();
 	level thread wall_lights();
 	
 	level thread obj_insert();
	level thread obj_telemetry_room();
	level thread obj_upload_the_abort_codes();
// 	level thread obj_plant_the_c4();
 	
 	level thread countdown_begins();
 	level thread grigsby_countdown_spam();
 	
 	level thread vent_dialogue1();
 	level thread vent_dialogue2();
 	
 	level thread team1_walk_trigger();
	level thread team1_run_trigger();

	level thread rocket_powering_up();

	level thread blast_door_clip();
	level thread shut_blast_door();
	level thread vault_doors_dialogue();
	
	level thread vault_doors_open();	
	level thread spawn_utility_enemies();
	level thread griggs_run_to_wall();
	level thread spawn_the_c4();
	
	level thread spawn_telemetry_enemies();
	level thread spawn_telemetry_friendlies();
	
	level thread upload_codes();
	level thread control_room_dialogue();
	level thread escape_doors_open();
	level thread telemetry_doors_open();
	
	level thread elevator_player_clip();
	level thread elevator_dialogue();
	
	level thread music();
	level thread hide_triggers( "escape" );
	
	level thread vehical_depot();
	level thread end_of_level();
					
// ****** Autosave ****** //
	trigger_array = getentarray( "autosave","targetname" );
	for ( i=0; i<trigger_array.size; i++)
	{
		 trigger_array[i] thread my_autosave();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
////		// ****** game play script ****** //																					 ////
/////////////////////////////////////////////////////////////////////////////////////////////////////

my_autosave()
{
    self waittill ( "trigger" );
	assertex( isdefined( self.script_timer ), "savetrigger needs script_timer value" );
    autosave_by_name_wraper ( "save", self.script_timer );
}

autosave_by_name_wraper( save_name, required_time )
{
	assertex( isdefined( required_time ), "required_time is needed to save" );

	if ( isdefined( level.timer_start_time ) )
	{
		current_time = gettime();
		elapsed_time = (current_time - level.timer_start_time) / 1000 / 60;

		remaining_time = level.stopwatch - elapsed_time;
		required_time = required_time * level.requried_time_scale;

		if ( remaining_time < required_time )
			return;
	}
    autosave_by_name ( save_name );
}

//player_setup()//

playerInit()
{	
	level.player takeAllWeapons();
	level.player giveWeapon( "fraggrenade" );
	level.player giveWeapon( "flash_grenade" );
	level.player giveWeapon( "m4m203_silencer" );
	level.player giveWeapon( "usp_silencer" );
	level.player switchToWeapon( "m4m203_silencer" );
	level.player setOffhandSecondaryClass( "flash" );
}

//team1()//

/****** Price ******/
price_think()
{
	level.price = self;
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	
	self thread ai_duct();
}

/****** Grigsby ******/
grigsby_think()
{
	level.grigsby = self;
	level.grigsby.animname = "grigsby";
	level.grigsby thread magic_bullet_shield();

	self thread ai_duct();
}

// ****** The other guys in team1 ****** //
team1_think()
{
	if( !isdefined( level.team1 ) )
		level.team1 = [];

	level.team1[ level.team1.size ] = self;
	
	self thread ai_duct();
}

vent_dialogue1()
{
	trigger = getent ( "move_out", "script_noteworthy" );
	trigger thread vent_dialogue1_01();
}

vent_dialogue1_01()
{
	self waittill ( "trigger" );		

	//Price: All right, let's move!
	radio_dialogue ( "letsmove" );
	
	wait 4;
	//Marine 1: Captain Price this is Five-Delta Six. We're clearing the east wing and heading for base security, over.
	radio_dialogue ( "basesecurity" );
	
	wait 1;
	//Price: Roger Delta Six, we're right above you in the vents, watch your fire.
	radio_dialogue ( "invents" );
	
	//Marine 1: Copy that sir.
	radio_dialogue ( "copythat" );
}

vent_dialogue2()
{
	trigger = getent ( "yankee_six_regroup", "script_noteworthy" );
	trigger thread vent_dialogue2_01();
}

vent_dialogue2_01()
{
	self waittill ( "trigger" );	
	//Marine 2:Captain Price, Two-Yankee Six reporting in. We're meeting with heavy resistance in the south wing. They've locked down our access point over here, over.
	radio_dialogue ( "heavyresistance" );
	
	//Price :Roger Yankee Six. Regroup with Team Two and help them gain control of base security, over.
	radio_dialogue ( "gaincontrol" );
	
	//Marine 2:Roger that sir. We're pulling back to regroup with Team Two. Yankee Six out.
	radio_dialogue ( "regroup" );
	
	flag_set ( "begin_countdown" );
}

// ****** Have team1 walk or run ****** //
team1_walk_trigger()
{
	trigger = getent ( "team1_walk", "script_noteworthy" );
	trigger waittill ( "trigger" );
		
	flag_set ( "walk" );
}
		 
team1_run_trigger()
{
	trigger = getent ( "team1_run", "script_noteworthy" );
	trigger waittill ( "trigger" );
		
	flag_set ( "move_faster" );
}

//objectives()// 

// ****** OBJECTIVES ****** //
// ****** 1st Objective, Get to the Telemetry Room, You have 10 minutes ****** //
obj_insert()
{
	objective_number = 0;
	
	obj_position = getent ( "origin_obj_breach_telemetry_room", "targetname" );
	wait .75;
	objective_add(objective_number, "active", &"LAUNCHFACILITY_B_GET_TO_THE_TELEMETRY", obj_position.origin);
	objective_current (objective_number);
	
	flag_wait ( "telemetry_room" );
	wait 1;
	objective_state (objective_number, "done");
} 

/*
// ****** New Objective: Tell player to plant the c4 and show where to plant it ****** //
obj_plant_the_c4()
{
	waittill_aigroupcleared( "utility_badies" );

	objective_number = 1;
	
	new_position = getent ( "c4", "targetname" );
	objective_add(objective_number, "active", &"LAUNCHFACILITY_B_PLANT_THE_C4", new_position.origin);
	objective_current (objective_number);
	
	flag_wait ( "wall_destroyed" );
	
	wait 1;
	objective_state (objective_number, "done");
	
	level thread obj_upload_the_abort_codes();
}
*/

obj_telemetry_room()
{
	trigger = getent ( "telemetry_room", "script_noteworthy" );
	trigger waittill ( "trigger" );
	
	flag_set ( "telemetry_room" );
}

// ****** New Objective: Upload the Abort Codes and show where to upload them****** //
obj_upload_the_abort_codes()
{
	waittill_aigroupcleared ( "control_room" );
	
	//Price: Soap, enter the codes! We'll watch for enemy reinforcements.
	radio_dialogue ( "entercodes" );
	
	objective_number = 2;
	
	obj_position = getent("keyboard_use_trigger", "targetname");
	objective_add(objective_number, "active", &"LAUNCHFACILITY_B_UPLOAD_THE_ABORT_CODES", obj_position.origin);
	objective_current (objective_number);
		
	flag_wait ( "codes_uploaded" );
	
	objective_state ( objective_number, "done" );
	
	if (level.usetimer)
	{
		level thread killTimer();
	}
	
	wait(1);	
}

// ****** New Objective: Follow Cpt. Price to the jeep ****** //
obj_follow_price()
{
	objective_number = 3;
	obj_position = level.price.origin;	
	objective_add ( objective_number, "active", &"LAUNCHFACILITY_B_FOLLOW_PRICE", obj_position );
	objective_current ( objective_number );

	level.price thread lock_obj_location( objective_number );	

	flag_wait ( "at_the_jeep" );
	objective_state ( objective_number, "done" );
	
	level notify ( "unlock_obj" ); 
	
	wait(1);		
}

lock_obj_location( objective_number )
{
	level endon ( "unlock_obj" ); 
	while ( true )
	{
		objective_position( objective_number, self.origin + ( 0, 0, 48 ));
		wait .5;
	}	
}

// main timer()//

countdown_begins()
{
	trigger = getent ( "countdown_start", "targetname" );
	trigger waittill  ( "trigger" );

	dialogue_line = undefined;

	switch( level.gameSkill )
	{
		case 1:
			level.stopwatch = 11;
			level.requried_time_scale = 1;
			dialogue_line = "11mins";
			break;
		case 2:
			level.stopwatch = 11;
			level.requried_time_scale = 1;
			dialogue_line = "11mins";
			break;
		case 3:
			level.stopwatch = 9;
			level.requried_time_scale = 0.82;
			dialogue_line = "9mins";
			break;
		default:
			level.stopwatch = 15;
			level.requried_time_scale = 1.36;
			dialogue_line = "15mins";
			break;
	}

	flag_wait ( "begin_countdown" );
	
	//HQ: 15, 11 or 9mins
	radio_dialogue ( dialogue_line );
	
	flag_set( "countdown_started" );

	//Price: Copy that!
//	radio_dialogue ( "copythat" );
	level thread startTimer();

	flag_set ( "music_start_countdown" );

	level.timer_start_time = gettime();
}

grigsby_countdown_spam()
{
	flag_wait( "countdown_started" );

	if ( level.stopwatch > 10 )
		thread flag_set_delayed( "10min_left", ( level.stopwatch * 60 ) - 602 );
	thread flag_set_delayed( "8min_left", ( level.stopwatch * 60 ) - 482 );
	thread flag_set_delayed( "6min_left", ( level.stopwatch * 60 ) - 362 );
	thread flag_set_delayed( "5min_left", ( level.stopwatch * 60 ) - 302 );
	thread flag_set_delayed( "4min_left", ( level.stopwatch * 60 ) - 242 );
	thread flag_set_delayed( "3min_left", ( level.stopwatch * 60 ) - 182 );
	thread flag_set_delayed( "2min_left", ( level.stopwatch * 60 ) - 122 );
	thread flag_set_delayed( "1min_left", ( level.stopwatch * 60 ) - 62 );

//	thread flag_set_delayed( "30sec_left", ( level.stopwatch * 60 ) - 30 );
//	thread flag_set_delayed( "20sec_left", ( level.stopwatch * 60 ) - 20 );
//	thread flag_set_delayed( "10sec_left", ( level.stopwatch * 60 ) - 10 );
//	thread flag_set_delayed( "5sec_left", ( level.stopwatch * 60 ) - 5 );

 	level thread grigsby_countdown_dialogue();
}

grigsby_countdown_dialogue()
{
	level endon ( "codes_uploaded" );

	flag_wait ( "10min_left" );	
	radio_dialogue ( "grg_10" );
	
	flag_wait ( "8min_left" );
	radio_dialogue ( "grg_8" );
			
	flag_wait ( "6min_left" );
	radio_dialogue ( "grg_6" );

	flag_wait ( "5min_left" );
	radio_dialogue ( "grg_5" );
	
	flag_wait ( "4min_left" );
	radio_dialogue ( "grg_4" );
		
	flag_wait ( "3min_left" );
	radio_dialogue ( "grg_3" );
		
//	flag_wait ( "2min_left" );
//	radio_dialogue ( "2min_left" );
		
//	flag_wait ( "1min_left" );
//	radio_dialogue ( "1min_left" );
		
//	flag_wait ( "30sec_left" );
//	radio_dialogue ( "30sec_left" );
	
//	flag_wait ( "20sec_left" );
//	radio_dialogue ( "20sec_left" );
		
//	flag_wait ( "10sec_left" );
//	radio_dialogue ( "10sec_left" );
	
//	flag_wait ( "5sec_left" );
//	radio_dialogue ( "5sec_left" );
	
}

// ****** Get the timer started ****** //
startTimer()
{
// destroy any previous timer just in case ****** //
	killTimer();
	
// destroy timer and thread if objectives completed within limit ****** //
	level endon ( "kill_timer" );
	
	level.hudTimerIndex = 20;

// Timer size and positioning ****** //	
	level.timer = newHudElem();
	level.timer.alignX = "left";
	level.timer.alignY = "middle";
	level.timer.horzAlign = "right";
    level.timer.vertAlign = "top";
    level.timer.x = -225;
    level.timer.y = 100;
    
  	level.timer.fontScale = 1.6;
	level.timer.color = (0.8, 1.0, 0.8);
	level.timer.font = "objective";
	level.timer.glowColor = (0.3, 0.6, 0.3);
	level.timer.glowAlpha = 1;

	level.timer SetPulseFX( 30, 900000, 700 );//something, decay start, decay duration

 	level.timer.hidewheninmenu = true;
  		
	level.timer.label = &"LAUNCHFACILITY_B_TIME_TILL_ICBM_IMPACT";
	level.timer settenthstimer( level.stopwatch * 60 );

// Wait until timer expired
	wait ( level.stopwatch * 60 );
	flag_set( "timer_expired" );

// Get rid of HUD element and fail the mission 
	level.timer destroy();	
	
	level thread mission_failed_out_of_time();
}

mission_failed_out_of_time()
{
	level.player endon ( "death" );
	level endon ( "kill_timer" );

	level notify ( "mission failed" );	
	setDvar("ui_deadquote", level.missionFailedQuote);
	maps\_utility::missionFailedWrapper();	
}

killTimer()	
{
	level notify ( "kill_timer" );
	if (isdefined (level.timer))
		level.timer destroy();		
}

// ****** Air duct ****** //
ai_duct()
{
	self.flashbangImmunity = true;
	self.interval = 24;
	self allowedstances ( "crouch" );
	
	flag_wait ( "walk" );
	self cqb_walk ( "on" );
	self allowedstances ( "stand", "crouch", "prone" );

	flag_wait ( "move_faster" );
	self cqb_walk ( "off" );
}

vent_friendlies_group1_spawner_think()
{
	self thread magic_bullet_shield();
	self.grenadeAmmo = 0;	
	
	self cqb_walk ( "on" );
	self allowedstances ( "stand", "crouch", "prone" );
	
	waittill_aigroupcleared ( "vent_enemies_group1" );
	activate_trigger_with_targetname ( "vent_friendlies_group1_move" );
	
	self cqb_walk ( "off" );
	
	wait 1;
	self waittill ( "goal" );
	self stop_magic_bullet_shield();
	self delete();	
}

vent_enemies_group1_spawner_think()
{
	self endon ( "death" );
	self.grenadeAmmo = 0;	
	self thread delete_on_damage();
	
	wait 10;
	self delete();		
}

delete_on_damage()
{
	self endon ( "death" );

	self waittill ( "damage" );
	self delete();		
}

vent_friendlies_group2_spawner_think()
{
	self thread magic_bullet_shield();	
	
	waittill_aigroupcleared ( "vent_enemies_group2" );
	activate_trigger_with_targetname ( "vent_friendlies_group2_move" );
	
	wait 1;
	self waittill ( "goal" );
	self stop_magic_bullet_shield();
	self delete();
}

vent_enemies_group2_spawner_think()
{
	self.health =2;	

	wait 10;
	if( isalive( self ) )
		self doDamage( self.health + 100, self.origin );	
}

//warehouse_area()//	
warehouse_retreating_enemies_think()
{
	self endon ( "death" );	
	self waittill ( "goal" );
	self delete();	
}

//launch_tubes()//

rocket_powering_up()
{
	trigger = getent ("rocket_power_up", "targetname" );
	trigger waittill ( "trigger" );

	thread rocket_powering_up_dialogue();
	
	while( !flag("blast_door_player_clip_off") )
	{
		earthquake(0.05, 1, level.player.origin, 1024);	
		wait .2;
	}
}

rocket_powering_up_dialogue()
{
	wait 2;
	//Price: They've started a bloody countdown! Zakhaev's going to launch the remaining missiles! Keep moving.
	radio_dialogue ( "startedcountdown" );	
}

shut_blast_door()
{
 	level.player in_volume();
	level thread close_the_door();
}	
	
in_volume()
{
    trigger = getent ( "shut_blast_door", "targetname" );

    while ( true )
    {
        trigger waittill ( "trigger" );
   
        allies = getaiarray ( "allies" );
        count = 0;
        for ( i=0; i<allies.size; i++ )
        {
            if ( allies[i] istouching( trigger ) )
                count++;
        }
        if ( count == allies.size )
            return;
    }
}

close_the_door()
{	
	flag_set ( "blast_door_player_clip_on" );
	
	blast_door = getent ( "blast_door_slam","targetname" );
	blast_clip = getent ( blast_door.target, "targetname" );
	blast_clip linkto ( blast_door );
	
	blast_door rotateyaw ( -80, 3, 1, 2 );
	blast_door playsound ( "gate_open" ); 		      // Sound of door closing
	blast_door waittill ( "rotatedone" );

	flag_set ( "blast_door_player_clip_off" );
	
	blast_clip disconnectPaths();
	level thread kill_enemy_in_tubes();
	
	flag_set ( "open_vault_doors" );
	
	thread rockets_launch();
}
	
//trigger launch of the rockets	
rockets_launch()
{
	intensity = .15;
        
        while( intensity > 0 )
		{
		earthquake(intensity, .1, level.player.origin, 256);
		wait .1;
		intensity -= .001;       	
		}		
}

blast_door_clip()
{
	blast_door_player_clip = getent ( "blast_player_clip","targetname" );
	blast_door_player_clip notsolid();

	flag_wait ( "blast_door_player_clip_on" );
	blast_door_player_clip solid();
	
	flag_wait ( "blast_door_player_clip_off" );
	blast_door_player_clip notsolid();
}

kill_enemy_in_tubes()
{
	volume = getent ( "killer_tubes", "targetname" );
	
	enemies = getaiarray( "axis" );
	for( i = 0 ; i < enemies.size ; i++ )
	{
		if ( enemies[ i ] istouching( volume ) )
			enemies[ i ] doDamage( enemies[ i ].health + 1000, enemies[ i ].origin );
	}
}

vault_doors_dialogue()
{
	flag_wait ( "open_vault_doors" );
	
	wait 1;
	// Marine 1: Captain Price, Delta Six. We've taken control of base security. What's your status over?
	radio_dialogue ( "controlbasesec" );
	
	wait 1;
	// Price:Team Two, we're in position. Open the outer door to launch control. 
//	level.price anim_single_queue( level.price, "atdoor" );
	
	wait 2;
	// Marine 1: Workin on it.
	radio_dialogue ( "workinonit" );
	
	wait 6;
	// Marine 1: Standby. Almost there.
	radio_dialogue ( "almostthere" );
	
	wait 6;
	// Marine 1: Got it. Doors are coming online now.
	radio_dialogue ( "gotit" );
	
	wait 2;
	flag_set( "vault_doors_unlocked" );
	
	wait 14;
	// Griggs: Oh, you gotta be shittin' me.
//	level.griggs anim_single_queue( level.griggs, "shittinme" );
}

// ****** Open the big Vault Doors ****** //
vault_doors_open()
{
	flag_wait ( "vault_doors_unlocked" );
	
	rdoor = getent ( "vault_door_left","targetname" );
	rclip = getent ( rdoor.target, "targetname" );
	rclip linkto ( rdoor );

	ldoor = getent ( "vault_door_right","targetname" );
	lclip = getent ( ldoor.target, "targetname" );
	lclip linkto ( ldoor );

	rdoor playsound ( "gate_open" ); 		    // Sound of gearworks and door unlocking
	
	wait 3;
	rdoor rotateyaw ( -.3, .05 );
	ldoor rotateyaw ( .3, .05 );
	
	rdoor playsound ( "mtl_steam_pipe_burst" ); // Sound of the seal breaking and the doors break free
	ldoor playsound ( "expl_steam_pipe_body" ); // Sound of the seals breaking 
	
	wait 1;
	rdoor playsound ( "expl_steam_pipe_body" ); // Sound of the seals breaking 
	
	wait 2;
	ldoor playsound ( "expl_steam_pipe_body" ); // Sound of the seals breaking 
	rdoor playsound ( "gate_open" ); 			  // Sound of the vault doors opening very slowly
	
	rdoor rotateyaw ( -50, 40, 0, 40 );
	ldoor rotateyaw ( 50, 40, 0, 40 );
	
	wait 20;
	rdoor rotateyaw ( -50, 30, 0, 30 );
	ldoor rotateyaw ( 50, 30, 0, 30 );
	
	autosave_by_name_wraper( "Time is running out", 3 );
	flag_set ( "vault_door_opened" );

	rclip connectpaths();
	lclip connectpaths();
}

spawn_utility_enemies()	
{
	flag_wait ( "vault_door_opened" );
	
	utility_enemies = getentarray ( "utility_enemies", "script_noteworthy" );
	array_thread ( utility_enemies, ::spawn_ai ); 	
}

griggs_run_to_wall()
{		
	level.player endon ( "death" );	
	
	waittill_aigroupcleared ( "utility_badies" );
	level thread hide_triggers( "attacking" );
	
	activate_trigger_with_targetname ( "protect_the_c4" );
	
	// Price: Team Three, what's your status, over?
	radio_dialogue ( "status" );
	
	// Marine 2: Team Three in position, at the southeast side of the launch control room. Standing by. Are you at the far wall over?
	radio_dialogue ( "gm2_inposition" );
	
	// Price: Affirmative. Preparing to breach. Grigsby?
	radio_dialogue ( "prepbreach" );
	
	thread griggs_plant_the_c4();	
}

griggs_plant_the_c4()
{
	level.anim_ent = getent ( "grigsby_plant_c4", "targetname" );
	level.anim_ent anim_reach_solo ( level.grigsby, "C4_plant_start" );
	
	flag_set ( "spawn_c4" );

	thread griggs_in_position_dialogue();
	// Griggs: Ready to breach. In position.
//	radio_dialogue ( "grg_inposition" );
		
	level.anim_ent anim_single_solo ( level.grigsby, "C4_plant" );
	
	level.grigsby set_force_color ( "o" );
	activate_trigger_with_targetname ( "take_cover" );
	
	wait 1;
	level.grigsby waittill ( "goal" );
	
	// Griggs: Breaching breaching.
	radio_dialogue ( "grg_breaching" );
	
	wait 1;
	
	thread blow_the_wall();
	flag_set ( "remove_c4" );
}	

griggs_in_position_dialogue()
{
	// Griggs: Ready to breach. In position.
	radio_dialogue ( "grg_inposition" );
}

spawn_the_c4()
{
	flag_wait ( "spawn_c4" );
	
	wait 2;
	explosives = getent ( "wall_explosives", "targetname" );
	c4_model = spawn ( "script_model", explosives.origin );
	c4_model setmodel ( "weapon_c4" );
	c4_model.angles = explosives.angles;
	
	flag_wait ( "remove_c4" );
	c4_model delete();
}	

blow_the_wall()
{
	blasted_wall = getent ( "blasted_wall","targetname" );
	blasted_wall connectpaths();
	
	exploder(100);
	explosives = getent ( "wall_explosives", "targetname" );
	playfx (level.wallExplosionSmall_fx, explosives.origin);
	thread play_sound_in_space ( "detpack_explo_metal", explosives.origin );
	radiusdamage ( explosives.origin, 256, 200, 50 );
	earthquake ( 0.4, 1, explosives.origin, 1000 );

	wait 1;
	flag_set( "wall_destroyed" );
	
	//Price: Moving in.
	radio_dialogue ( "pri_gogogo2" );
	
	// Marine 2: Moving in.
	radio_dialogue ( "movingin" );
}	
	
//control_room()// 
spawn_telemetry_enemies()	
{
	flag_wait ( "wall_destroyed" );
	
	telemetry_enemies = getentarray ( "telemetry_enemies", "script_noteworthy" );
	array_thread( telemetry_enemies, ::spawn_ai ); 	
}
	
// team2 spawning	
spawn_telemetry_friendlies()	
{
	flag_wait ( "wall_destroyed" );
	
	telemetry_friendlies = getentarray ( "team2", "script_noteworthy" );
	array_thread ( telemetry_friendlies, ::add_spawn_function, ::telemetry_friendlies_think );	
	array_thread( telemetry_friendlies, ::spawn_ai ); 
	
	activate_trigger_with_targetname ( "control_room_friendlies_attack" );
}

telemetry_friendlies_think()
{
	self thread magic_bullet_shield();
	
	flag_wait ( "weaken_team2" );
	
	self stop_magic_bullet_shield();
	self.health =2;
}

upload_codes()
{
	flag_wait ( "wall_destroyed" );
	waittill_aigroupcleared ( "control_room" );
	
	wait 1;
	
    interval = .05;
    timesofar = 0;
    planttime = 3;

	keyboard_use_trigger = getent ("keyboard_use_trigger", "targetname");
	keyboard_use_trigger sethintstring( &"LAUNCHFACILITY_B_HINT_UPLOAD_CODES" );
	keyboard_use_trigger usetriggerrequirelookat();

	keyboard_to_use = spawn( "script_model", level.keyboard.origin );
	keyboard_to_use.angles = (0, 315, 0);
	keyboard_to_use setmodel( "com_computer_keyboard_obj" );

    while ( true )
    {
    
        keyboard_use_trigger waittill ( "trigger" );
		level.player disableweapons();
        level.player freezeControls( true );

        // set hint string on trigger

        keyboard_use_trigger trigger_off();

        level.player startProgressBar( planttime );

        // change to localized string
        level.player.progresstext settext( "Uploading Codes" );

        success = false;
        
        while ( true )
        {
            if (!level.player useButtonPressed())
                break;

            timesofar += interval;
            level.player setProgressBarProgress(timesofar / planttime);

            if (timesofar >= planttime)
            {
                success = true;
                break;
            }
            wait interval;
        }

        level.player endProgressBar();

        if ( success )
            break;

        // give information that input failed.
        keyboard_use_trigger trigger_on();
		level.player freezeControls( false );
        level.player enableweapons();
    }
	
	level.player enableweapons();	
	level.player freezeControls( false );
	
	keyboard_use_trigger delete();
	keyboard_to_use delete();
	
	keyboard_switched = spawn( "script_model", level.keyboard.origin );
	keyboard_switched.angles = (0, 315, 0);
	keyboard_switched setmodel( "com_computer_keyboard" );

	flag_set ( "codes_uploaded" );
}

startProgressBar(planttime)
{
    // show hud elements
    self.progresstext = createSecondaryProgressBarText();
    self.progressbar = createSecondaryProgressBar(); }

setProgressBarProgress(amount)
{
    if (amount > 1)
        amount = 1;
    
    self.progressbar updateBar(amount);
}

endProgressBar()
{
    self notify("progress_bar_ended");
    self.progresstext destroyElem();
    self.progressbar destroyElem();
}

// should be moved to _hud.gsc
createSecondaryProgressBar()
{
    bar = createBar( "white", "black", level.secondaryProgressBarWidth, level.secondaryProgressBarHeight );
    bar setPoint("CENTER", undefined, 0, level.secondaryProgressBarY);
    return bar;
}

// should be moved to _hud.gsc
createSecondaryProgressBarText()
{
    text = createFontString("default", level.secondaryProgressBarFontSize);
    text setPoint("CENTER", undefined, 0, level.secondaryProgressBarTextY);
    return text;
}

telemetry_doors_open()
{
	trigger = getent ( "open_telemetry_door", "targetname" );
	trigger waittill ( "trigger" );

	telemetry_room_door = getent ( "telemetry_room_door","targetname" );
	
	telemetry_room_door rotateyaw ( -70, 1, 1, 0 );	
	telemetry_room_door playsound ( "gate_open" ); 			  // Sound of the vault doors opening very slowly	
	
	telemetry_room_door connectpaths();
	
	flag_set ( "weaken_team2" );
}

escape_doors_open()
{
	flag_wait ( "codes_uploaded" );

	escape_door_right = getent ( "escape_door_right" ,"targetname" );
	moveto_place = getent ( escape_door_right.target, "targetname" );

	wait 1;
	escape_door_right moveto ( moveto_place.origin, 3, 1, 2 );
	escape_door_right connectpaths();
}

control_room_dialogue()
{
	flag_wait ( "codes_uploaded" );
	
	level thread show_triggers( "escape" );
	
	//HQ: NORAD monitoring stations have confirmed the missiles have been destroyed in flight.
	radio_dialogue ( "destroyed" );
	
	wait 1;
	//Marine 2: Sir, check the security feed! Zakhaev's takin' off. What's the -
	radio_dialogue ( "checkfeed" );
	
	//Griggs: WE GOT COMPANYYYY!!!!! Enemy reinforcements movin' in!
//	radio_dialogue ( "company" );

	//Price: We've got to head for the extraction point! Move!
//	radio_dialogue ( "extractionpoint" );

	//Marine 1: Price this is Delta Six at the security station. They came in by trucks. I'm thinking we can all use them to get the hell outta here. I'm sending you the coordinates to the vehicle depot.
	radio_dialogue ( "sendcoordinates" );

	wait .5;
	//Price: Roger that. We'll meet you at the vehicle depot! Out! Everyone follow me let's go!
	radio_dialogue ( "vehicledepot" );
	
	thread follow_price();
}

//escape() Good Job, Now lets get to the jeeps!
follow_price()
{
	activate_trigger_with_targetname ( "escape" );
	level thread obj_follow_price();
	
	autosave_by_name ( "let's get out of here" );	
	thread price_move_up();
}

price_move_up()
{
	waittill_aigroupcleared ( "utility_escape" );
	activate_trigger_with_targetname ( "escape_utility" );
	
	waittill_aigroupcleared ( "vaultdoors_escape" );
	activate_trigger_with_targetname ( "escape_to_vaultdoors" );
	
	wait ( randomfloatrange ( 0.8, 2 ) );
	//HQ: All teams this is Command, recommend you exfil from the area immediately. Large numbers of hostile forces are converging on your position. Get outta there now.
	radio_dialogue ( "exfilfromarea" );
	
	waittill_aigroupcleared ( "hallway_escape" );
	activate_trigger_with_targetname ( "escape_hallway" );

	thread elevator();
}

elevator()
{
	waittill_aigroupcleared ( "elevator" );
	
	level.anim_ent = getent ( "tunnel_animent", "targetname" );
	
	level.price thread ai_to_elevator( "r" );
	level.grigsby thread ai_to_elevator( "o" );
 	level.player in_the_elevator();
	level thread elevator_think();
	
	elevator = getent ( "elevator","targetname" );
	level.anim_ent linkto ( elevator );
}	

elevator_player_clip()
{
	elevator_player_clip = getent ( "elevator_player_clip","targetname" );
	elevator_player_clip notsolid();

	flag_wait ( "elevator_player_clip_on" );
	elevator_player_clip solid();
}

ai_to_elevator( color )
{
	level.anim_ent anim_reach_solo ( self, "elevator_runin" );
	level.anim_ent anim_single_solo ( self, "elevator_runin" );
	level.anim_ent thread anim_loop_solo ( self, "elevator_idle", undefined, "stop_idle" );
	self linkto ( level.anim_ent );
	
	trigger = getent ( "elevator_top", "targetname" );
	trigger waittill ( "trigger" );

	wait 2;
	self unlink ( level.anim_ent );
	level.anim_ent notify ( "stop_idle" );
	level.anim_ent anim_single_solo( self, "elevator_runout" );
	
	self set_force_color( color );
}
	
in_the_elevator()
{
    trigger = getent ( "standing_in_elevator", "targetname" );

    while ( true )
    {
        trigger waittill ( "trigger" );
        if ( level.price istouching( trigger ) && level.grigsby istouching( trigger ) )
			return;
    }
}

linkto_elevator( elevator )
{
	self linkto ( elevator );
}

elevator_think()
{	
	flag_set ( "elevator_player_clip_on" );
	
	elevator = getent ( "elevator","targetname" );
	
	lights = getentarray ( "elevator_lights", "targetname" );
	array_thread ( lights,::linkto_elevator, elevator );

	level.elevator_door_inner_top = getent ( "elevator_door_inner_top", "targetname" );
	level.elevator_door_inner_top linkto ( elevator );

	level.elevator_door_inner_bottom = getent ( "elevator_door_inner_bottom", "targetname" );
	elevator_door_inner_bottom = getent ( "elevator_door_inner_bottom","targetname" );
	elevator_door_inner_bottom movez ( -102, 2, 1, 1 );
//	elevator_door playsound ( "elevator_door_moving" );				// Sound of elevator door closing/opening

	elevator_door_inner_bottom waittill ( "movedone" );
	level.elevator_door_inner_bottom linkto ( elevator );

	elevator_door_outside1_bottom = getent ( "elevator_door_outside1_bottom","targetname" );
	moveto_place = getent ( elevator_door_outside1_bottom.target, "targetname" );
	elevator_door_outside1_bottom moveto ( moveto_place.origin, 2, 1, 1 );
//	elevator_door playsound ( "elevator_door_moving" );				// Sound of elevator door closing/opening
	
	elevator_door_outside2_bottom = getent ( "elevator_door_outside2_bottom","targetname" );
	moveto_place = getent ( elevator_door_outside2_bottom.target, "targetname" );
	elevator_door_outside2_bottom moveto ( moveto_place.origin, 2, 1, 1 );

		
	elevator_door_outside1_bottom waittill ( "movedone" );

	elevator moveto ( level.elevator_upper.origin, 15, .5, .10 );
//	elevator playsound ( "elevator_door" );						// Sound of elevator moving up

	flag_set ( "elevator_dialogue" );
	
	elevator waittill ( "movedone" );
	autosave_by_name( "On our way" );
	
	level.elevator_door_inner_top = getent ( "elevator_door_inner_top", "targetname" );	
	level.elevator_door_inner_top unlink ( elevator );

	level.elevator_door_inner_top = getent ( "elevator_door_inner_top", "targetname" );
	elevator_door_inner_top = getent ( "elevator_door_inner_top","targetname" );
	elevator_door_inner_top movez ( 102, 2, 1, 1 );
	elevator_door_inner_top connectpaths();
//	elevator_door playsound ( "elevator_door_moving" );				// Sound of elevator door closing/opening

	elevator_door_inner_top waittill ( "movedone" );
	elevator_door_outside1_top = getent ( "elevator_door_outside1_top","targetname" );
	moveto_place = getent ( elevator_door_outside1_top.target, "targetname" );
	elevator_door_outside1_top moveto ( moveto_place.origin, 2, 1, 1 );
	elevator_door_outside1_top connectpaths();
//	elevator_door playsound ( "elevator_door_moving" );				// Sound of elevator door closing/opening

	elevator_door_outside2_top = getent ( "elevator_door_outside2_top","targetname" );
	moveto_place = getent ( elevator_door_outside2_top.target, "targetname" );
	elevator_door_outside2_top moveto ( moveto_place.origin, 2, 1, 1 );
	elevator_door_outside2_top connectpaths();
}

elevator_dialogue()
{
	flag_wait ( "elevator_dialogue" );
	
	wait 2;
	//Marine 1:This is Delta Six. We're takin' some fire up here at the vehicle depot. Where the hell are you guys?
	radio_dialogue ( "takinfire" );
	
	wait 1;
	//Price: We're coming up the lift. Standby.
	radio_dialogue ( "upthelift" );	
}

// ****** End of Level ****** //
vehical_depot()
{
	waittill_aigroupcleared ( "garage" );
	
	flag_set ( "at_the_jeep" );
	
	wait 1.5;
	//Price: All right, get in the trucks! Let's go!
	radio_dialogue ( "letsgo" );
	
	wait 1;
	flag_set ( "level_end" );
}

end_of_level()
{
	flag_wait ( "level_end" );

	missionsuccess ( "jeepride", true );
}

// ****** Misc ****** //
airduct_fan_large()
{
	fan = getent ( "airduct_fan_large","targetname" );
	time = 5000;
	
	while( true )
	{
		fan rotatevelocity((0,-120,0), time);	
		wait time;
	}
//	fan playsound ( "whoosh_woosh" ); 		      				// Sound of large fan rotating
} 

airduct_fan_small()
{
	small_fans = getentarray ( "airduct_fan_small","targetname" );
	array_thread( small_fans, ::small_fans_think );
}
	
small_fans_think()
{	
	time = 5000;
	
	while( true )
	{
		self rotatevelocity((190,0,0), time);	
		wait time;
	}
//	fan playsound ( "whoosh_woosh" ); 		      				// Sound of large fan rotating
} 

redlights()
{
	light = getentarray ( "redlight","targetname" );
	array_thread( light, ::redlights_think );
}

redlights_think()
{
	time = 5000;

	while( true )
	{
		self rotatevelocity((0,360,0), time);           
		wait time;
	}
}

wall_lights()
{

	light = getentarray ( "wall_light","targetname" );
	array_thread( light, ::wall_lights_think );

}

wall_lights_think()
{
	time = 5000;
	
	while( true )
	{
		self rotatevelocity((360,0,0), time);           
		wait time;
	}
} 

music()
{
	wait 0.1;
	thread music_vents();
	
	flag_wait ( "music_start_countdown" );
	musicStop( 5 );
	wait 5.15;
	musicPlay ( "launch_b_countdown_timer_music" );
	
	flag_wait ( "codes_uploaded" );
	
	musicStop( 2 );
	wait 2.1;
	
	while( 1 ) 
	{
		musicPlay ( "launch_b_escape_combat_music" );
		wait 71;
		musicStop( 1 );
		wait 1.1;
	}
}

music_vents()
{
	level endon ( "music_start_countdown" );
	
	while( 1 )
	{
		musicPlay ( "launch_b_escape_combat_music" );
		wait 71;
		musicStop( 1 );
		wait 1.1;
	}
}

hide_triggers( trigger_name )
{
	trigger = getentarray ( trigger_name, "script_noteworthy");
	for (i=0; i<trigger.size; i++)
	{
		trigger[i] trigger_off();
	}
}

show_triggers( trigger_name )
{
	trigger = getentarray ( trigger_name, "script_noteworthy");
	for (i=0; i<trigger.size; i++)
	{
		trigger[i] trigger_on();
	}
}