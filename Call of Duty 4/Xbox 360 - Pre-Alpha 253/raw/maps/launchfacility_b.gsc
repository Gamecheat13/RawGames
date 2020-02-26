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
	
	precachemodel ("com_computer_keyboard_obj");
	precachemodel ("com_computer_keyboard");
	
//  progress bar stuff
	precacheShader("white"); 
    precacheShader("black"); 
		
	playerInit();
		
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
//	battlechatter_on( "axis" );

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
	level.wallExplosionSmall_fx						= loadfx ( "explosions/wall_explosion_small" );
	
//	maps\ned_timer_fx::main();
	
	price_spawner = getent( "price", "script_noteworthy" );
	price_spawner add_spawn_function( ::price_think );
	
	grigsby_spawner = getent( "grigsby", "script_noteworthy" );
	grigsby_spawner add_spawn_function( ::grigsby_think );
	
	team1_spawner = getent( "team1", "script_noteworthy" );
	team1_spawner add_spawn_function( ::team1_think );
	
	gassed_spawner = getentarray( "gassed_runners", "script_noteworthy" );
	array_thread ( gassed_spawner, ::add_spawn_function, ::gassed_runners_think );
		
 	flag_init ( "timer_expired" );
 	
 	flag_init ( "walk" );
 	flag_init ( "move_faster" );
	flag_init ( "open_vault_doors" );
	flag_init ( "vault_doors_unlocked" );
 	flag_init ( "utility_room_cleared" );
 	flag_init ( "vault_door_opened" );
 	flag_init ( "wall_destroyed" );
 	flag_init ( "codes_uploaded" );
 	flag_init ( "at_the_jeep" );
 
 	level thread misc_airduct_fan();
 	
 	level thread team1_walk_trigger();
	level thread team1_run_trigger();
	level thread obj_insert();
	
	level thread shut_blast_door();
	level thread team1_trapped();
	
	level thread plant_the_c4();
	level thread vault_doors_open();	
	level thread spawn_utility_enemies();
	level thread plant_c4();
	
	level thread spawn_telemetry_enemies();
	level thread spawn_telemetry_friendlies();
	level thread upload_codes();
	level thread escape_doors_open();
	level thread telemetry_doors_open();
	
	level thread music();
	end_of_level();
	
	createThreatBiasGroup( "telemetry_enemies" ); 
	createThreatBiasGroup( "telemetry_friendlies" ); 
	ignoreEachOther( "telemetry_friendlies", "telemetry_enemies" );
	ignoreEachOther( "telemetry_enemies", "telemetry_friendlies" );
					
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
    self waittill( "trigger" );
    autosave_by_name( "save" );
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
//	level.price set_force_color( "r" );
	
	self thread ai_duct();


}

/****** Grigsby ******/
grigsby_think()
{
	level.grigsby = self;
	level.grigsby.animname = "grigsby";
	level.grigsby thread magic_bullet_shield();
//	level.grigsby set_force_color( "o" );

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

// ****** Have team1 walk or run ****** //
team1_walk_trigger()
{
	trigger_array = getentarray( "team1_walk", "script_noteworthy" );
	for ( i=0; i<trigger_array.size; i++)
	{
		trigger_array[i] thread team1_walk();
	}
}	 
		 
team1_walk()
{
	self waittill( "trigger" );	
	flag_set ( "walk" );
}

team1_run_trigger()
{
	trigger_array = getentarray( "team1_run", "script_noteworthy" );
	for ( i=0; i<trigger_array.size; i++)
	{
		trigger_array[i] thread team1_run();
	}
}	 
		 
team1_run()
{
	self waittill( "trigger" );	
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
	wait 1.5;
	
// ****** Timed objective ****** //
	if (level.usetimer)
	{
		level.stopwatch = 10; 		// Minutes till Missiles reach their target
		level thread startTimer();
	}
	
//	if (level.usetimer)
//	{
//		level thread killTimer();
//	}		
} 

// ****** New Objective: Tell player to plant the c4 and show where to plant it ****** //
plant_the_c4()
{
	flag_wait ( "utility_room_cleared" );
	objective_number = 0;
	
	new_position = getent ( "c4", "targetname" );
	objective_add(objective_number, "active", &"LAUNCHFACILITY_B_PLANT_THE_C4", new_position.origin);
	objective_current (objective_number);
	
	flag_wait ( "wall_destroyed" );
	
	wait 1;
	objective_state (objective_number, "done");
	
	wait 2;
	level thread obj_upload_the_abort_codes();
}

// ****** New Objective: Upload the Abort Codes and show where to upload them****** //
obj_upload_the_abort_codes()
{
	objective_number = 0;
	
	obj_position = getent("keyboard_use_trigger", "targetname");
	objective_add(objective_number, "active", &"LAUNCHFACILITY_B_UPLOAD_THE_ABORT_CODES", obj_position.origin);
	objective_current (objective_number);
		
	flag_wait ( "codes_uploaded" );
	objective_state ( objective_number, "done" );
	
	if (level.usetimer)
	{
		level thread killTimer();
	}
	
//	autosave_by_name ( "insertion complete" );
	wait(1);
	
}

lock_obj_location( objective_number )
{
	level endon ( "unlock_obj" ); 
	while ( true )
	{
		objective_position( objective_number, self.origin );
		wait .5;
	}	
}

// ****** New Objective: Follow Cpt. Price to the jeep ****** //
obj_follow_price()
{
	objective_number = 0;
	obj_position = level.price.origin;	
	objective_add ( objective_number, "active", &"LAUNCHFACILITY_B_FOLLOW_PRICE", obj_position );
	objective_current ( objective_number );

	level.price thread lock_obj_location( objective_number );	

	flag_wait ( "at_the_jeep" );
	objective_state ( objective_number, "done" );
	autosave_by_name ( "let's get out of here" );
	level notify ( "unlock_obj" ); 
	wait(1);
	
}
// main timer()//

// ****** Get the timer started ****** //
startTimer()
{
// ****** destroy any prvious timer just in case ****** //
	killTimer();
	
// ****** destroy timer and thread if objectives completed within limit ****** //
	level endon ( "kill_timer" );
	
	level.hudTimerIndex = 20;

// ****** Timer size and positioning ****** //	
	level.timer = newHudElem();
	level.timer.alignX = "left";
	level.timer.alignY = "middle";
	level.timer.horzAlign = "right";
    level.timer.vertAlign = "top";
    if(level.xenon)
	{
		level.timer.fontScale = 2;
		level.timer.x = -225;
	}
	else
	{
		level.timer.fontScale = 1.6;    
		level.timer.x = -180;
	}
	level.timer.y = 100;
	level.timer.label = &"LAUNCHFACILITY_B_TIME_TILL_ICBM_IMPACT";
	level.timer settenthstimer( level.stopwatch * 60 );

//****** Wait until timer expired *******//
	wait ( level.stopwatch * 60 );
	flag_set( "timer_expired" );

// ****** Get rid of HUD element and fail the mission ****** //
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
	self.interval = 16;
	self allowedstances( "crouch" );
	
	flag_wait ( "walk" );
	self cqb_walk( "on" );
	self allowedstances( "stand", "crouch", "prone" );

	flag_wait ( "move_faster" );
	self cqb_walk( "off" );
}

//warehouse_area()//
	
gassed_runners_think()
{
	self endon( "death" );	
	self waittill( "goal" );
	self delete();	
}

//launch_tubes()//

shut_blast_door()
{
 	level.player in_volume();
	level thread close_the_door();
}	
	
in_volume()
{
    trigger = getent( "shut_blast_door", "targetname" );

    while ( true )
    {
        trigger waittill( "trigger" );
   
        allies = getaiarray( "allies" );
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
	blast_door = getent( "blast_door_slam","targetname" );
	blast_clip = getent( blast_door.target, "targetname" );
	blast_clip linkto( blast_door );
	
	wait 2;
	blast_door rotateyaw( -80, 3, 1, 2 );
	blast_door playsound ( "gate_open" ); 		      // Sound of door closing
	blast_door waittill( "rotatedone" );
	
//	earthquake( 0.5, 2, level.player.origin, 1250 );
	
	blast_clip disconnectPaths();
	
	flag_set( "open_vault_doors" );
}

team1_trapped()
{
	flag_wait( "open_vault_doors" );
	wait 1;
	iprintlnbold( "Radio chatter between Price and Team2 to get the vault doors open" );
	
	wait 6;
	iprintlnbold( "Radio chatter between Price and Team2... Blast Doors coming online now" );
	
	wait 3;
	flag_set( "vault_doors_unlocked" );
	
	wait 8;
	iprintlnbold( "Cpt. Price tells the player as soon as the room is cleared, plant the c4" );
	
	wait 4;
	flag_set( "utility_room_cleared" );	
}

//utility_room()// 

// ****** Open the big Vault Doors ****** //
vault_doors_open()
{
	flag_wait( "vault_doors_unlocked" );
	rdoor = getent( "vault_door_left","targetname" );
	rclip = getent( rdoor.target, "targetname" );
	rclip linkto( rdoor );

	ldoor = getent( "vault_door_right","targetname" );
	lclip = getent( ldoor.target, "targetname" );
	lclip linkto( ldoor );

	rdoor playsound ( "gate_open" ); 		      // Sound of gearworks and door unlocking
	
	wait 3;
	rdoor rotateyaw( -.3, .05 );
	ldoor rotateyaw( .3, .05 );
	
	rdoor playsound ( "mtl_steam_pipe_burst" ); // Sound of the seal breaking and the doors break free
	ldoor playsound ( "expl_steam_pipe_body" ); // Sound of the seals breaking 
	
	wait 1;
	rdoor playsound ( "expl_steam_pipe_body" ); // Sound of the seals breaking 
	
	wait 2;
	ldoor playsound ( "expl_steam_pipe_body" ); // Sound of the seals breaking 
	rdoor playsound ( "gate_open" ); 			  // Sound of the vault doors opening very slowly
	
	rdoor rotateyaw( -50, 40, 0, 40 );
	ldoor rotateyaw( 50, 40, 0, 40 );
	
	wait 20;
	rdoor rotateyaw( -50, 30, 0, 30 );
	ldoor rotateyaw( 50, 30, 0, 30 );
	
	autosave_by_name( "Time is running out" );
	flag_set( "vault_door_opened" );

	rclip connectpaths();
	lclip connectpaths();
}

spawn_utility_enemies()	
{
	flag_wait( "vault_door_opened" );
	utility_enemies = getentarray ( "utility_enemies", "script_noteworthy" );
	array_thread( utility_enemies, maps\_spawner::spawn_ai ); 	
}

plant_c4()	
{		
	level.player endon ( "death" );	
	flag_wait( "vault_door_opened" );
	
	c4 = getent( "c4", "targetname" );
	c4 maps\_c4::c4_location( undefined, (0,0,0) , (0,0,0), c4.origin ); 
	c4 waittill ( "c4_planted" );
	
	wait 1;
	iprintlnbold( "Team2 reporting they are in position" );
	
	c4 waittill ( "c4_detonation" );
	
	thread blow_the_wall();
}	

blow_the_wall()
{
	blasted_wall = getent( "blasted_wall","targetname" );
	blasted_wall connectpaths();
	
	exploder(100);
	org = getent( "telemetry_wall_breach", "targetname" );

	playfx(level.wallExplosionSmall_fx, org.origin);
	
	thread play_sound_in_space( "bricks_exploding", org.origin );
	earthquake (0.6, 1, org.origin, 2000);
	
	flag_set( "wall_destroyed" );
}	
	
//telemetry_room()// 

spawn_telemetry_enemies()	
{
	flag_wait ( "wall_destroyed" );
	
	telemetry_enemies = getentarray ( "telemetry_enemies", "script_noteworthy" );
	array_thread( telemetry_enemies, maps\_spawner::spawn_ai ); 	
}
	
// team2 spawning	
spawn_telemetry_friendlies()	
{
	flag_wait ( "wall_destroyed" );
	
	wait 1;
	telemetry_friendlies = getentarray ( "team2", "script_noteworthy" );
	array_thread( telemetry_friendlies, maps\_spawner::spawn_ai ); 
}

upload_codes()
{
	flag_wait( "wall_destroyed" );

    interval = .05;
    timesofar = 0;
    planttime = 3;

	keyboard_use_trigger = getent("keyboard_use_trigger", "targetname");
	keyboard_use_trigger sethintstring( &"LAUNCHFACILITY_B_HINT_UPLOAD_CODES" );
	keyboard_use_trigger usetriggerrequirelookat();

	keyboard_to_use = spawn( "script_model", level.keyboard.origin );
	keyboard_to_use.angles = (0, 315, 0);
	keyboard_to_use setmodel( "com_computer_keyboard_obj" );

    while ( true )
    {
    
        keyboard_use_trigger waittill( "trigger" );
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

	flag_set( "codes_uploaded" );
	
	thread follow_price();
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
	flag_wait( "codes_uploaded" );
	telemetry_room_door = getent( "telemetry_room_door","targetname" );
	
	wait 1;
	telemetry_room_door rotateyaw( -70, 3, 1, 2 );	
	telemetry_room_door playsound ( "gate_open" ); 			  // Sound of the vault doors opening very slowly	
	
	telemetry_room_door connectpaths();
}

escape_doors_open()
{
	flag_wait ( "codes_uploaded" );
	escape_door_left = getent( "escape_door_left","targetname" );
	escape_door_right = getent( "escape_door_right","targetname" );
	
	wait 1;
	escape_door_left rotateyaw( 70, 3, 1, 2 );	
	escape_door_right rotateyaw( -85, 3, 1, 2 );
	
	escape_door_left connectpaths();
	escape_door_right connectpaths();
	
}
//to_the_jeep() Good Job, Now get to the jeep!

follow_price()
{
	wait 1;
	iprintlnbold( "Price: Good job, now lets get out of here!" );
	
	wait 1;
	level thread obj_follow_price();
	
//	autosave_by_name ( "let's get out of here" );
//	activate_trigger_with_targetname ( "run_to_elevator" );	
	thread elevator();
}

ai_to_elevator()
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
	
	level.price set_force_color( "r" );
	level.grigsby set_force_color( "o" );
}

elevator()
{
	wait 2;

	level.anim_ent = getent( "tunnel_animent", "targetname" );
	
	level.price thread ai_to_elevator();
	level.grigsby thread ai_to_elevator();
 	level.player in_the_elevator();
	level thread elevator_think();
	
	elevator = getent( "elevator","targetname" );
	level.anim_ent linkto ( elevator );
}	
	
in_the_elevator()
{
    trigger = getent( "standing_in_elevator", "targetname" );

    while ( true )
    {
        trigger waittill( "trigger" );
        if ( level.price istouching( trigger ) && level.grigsby istouching( trigger ) )
			return;
    }
}

elevator_think()
{
	elevator_door_lower = getent( "elevator_door_lower","targetname" );
	elevator_door_lower movez ( -40, 2, .1, .1 );
//	elevator_door playsound ( "elevator_moving" );				// Sound of elevator door closing/opening

	elevator_door_lower_lower = getent( "elevator_door_lower_lower","targetname" );
	elevator_door_lower_lower movez ( 56, 2, .1, .1 );

	
	elevator_door_lower waittill ( "movedone" );
	wait 1;
	elevator = getent( "elevator","targetname" );	
	elevator moveto ( level.elevator_upper.origin, 15, .5, .10 );
//	elevator playsound ( "elevator_door" );						// Sound of elevator moving up

	elevator waittill ( "movedone" );
	wait 1;
	elevator_door_upper = getent( "elevator_door_upper","targetname" );
	elevator_door_upper movez ( 40, 2, .1, .1 );
//	elevator_door playsound ( "elevator_door" );				// Sound of elevator door closing/opening
	elevator_door_upper connectpaths();
	
	elevator_door_upper_lower = getent( "elevator_door_upper_lower","targetname" );
	elevator_door_upper_lower movez ( -56, 2, .1, .1 );
	elevator_door_upper_lower connectpaths();
}

// ****** Misc ****** //
misc_airduct_fan()
{
	fan = getent("airduct_fan","targetname");
	time = 5000;
	
	while( true )
	{
		fan rotatevelocity((0,-240,0), time);	
		wait time;
	}
//	fan playsound ( "whoosh_woosh" ); 		      				// Sound of large fan rotating
} 

music()
{
	wait 1;
	musicplay ( "launchfacility_b_countdown_music" );
}

// ****** End of Level ****** //
end_of_level()
{
	trigger = getent ("end_of_level", "targetname" );
	trigger waittill ( "trigger" );
	trigger delete();
	
	flag_set ( "at_the_jeep" );
	iprintlnbold( "End of currently scripted level" );
}
