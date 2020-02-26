#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;

main()
{
	// Precaching shell shock effect.
	precacheshellshock ("default");

	maps\_load::main();

	//SOUND: added by Shawn J
	maps\unlockables_amb::main();
	
	maps\_securitycamera::init();

	wait( .3 );

	strings = [];
	strings[0] = &"UNLOCK_SINK_HOLE_DEBRIEFING";
	strings[1] = &"UNLOCK_SINK_HOLE_QUANTUM_PART_I";
	level thread start_of_level( strings );

	level thread set_up();
	level thread set_up_models();
	level thread set_up_model_female();
	level thread weapons_display_p99();
	level thread weapons_display_1911();
	level thread weapons_display_saf45();
	level thread weapons_display_phone();
	level thread concept_info_01();
	level thread concept_info_02();
	level thread concept_info_03();
	level thread concept_info_04();
	level thread smart_wall_display();
	level thread smart_wall_display1();
	level thread smart_wall_display2();
	level thread custom_camera_car_left();
	level thread custom_camera_car_right();
	level thread play_music();
	level thread play_vo();
	level thread link_weapons();
	level thread level_end1();
	level thread level_end2();
	level thread level_end3();
	level thread level_end4();
	array_thread( getentarray("screensaver","targetname") , ::screensaver );
}

//avulaj
set_up()
{
	wait( .1 );
	setSavedDvar("cg_disableBackButton","1");
	setdvar("ui_hud_showcompass", "0");


	//this blocks the player from using the phone
	//setSavedDvar("cg_disableBackButton","1"); // disable
	maps\_utility::holster_weapons();
	setDvar("ui_hud_showstanceicon","0");
	setsaveddvar ( "ammocounterhide", "1" );

	SetSavedDVar("cover_dash_fromCover_enabled",false);
	SetSavedDVar("cover_dash_from1stperson_enabled",false);
	
	//level.player allowcrouch(false);
	level.player allowjump(false);
	
	//this enables the camera
	camera[0] = getent ( "camera_car", "targetname" );
	smart_wall_display_ent = spawn( "script_origin", (13, 3, 36));;
	camera[0] thread maps\_securitycamera::camera_start( undefined, false, true, true, smart_wall_display_ent );
	wait( .1 );
	camera[0] maps\_securitycamera::camera_phone_track(true);
	level.player enablevideocamera( true );
//	level.player enablesecuritycameraonphone( true );
//	level thread maps\_securitycamera::camera_render_switch( camera );

	//this blocks the player from using melee
	wait( 1 );
	setsaveddvar( "melee_enabled", "0" );
	MusicPlay( "mus_unlockable", 0 );
}

//avulaj
//this handles the fade in
start_of_level( strings, outro )
{	
	level.player FreezeControls( true );

	level.player = GetEnt("player", "classname" );

	level.introblack = NewHudElem();
	level.introblack.x = 0;
	level.introblack.y = 0;
	level.introblack.horzAlign = "fullscreen";
	level.introblack.vertAlign = "fullscreen";
	level.introblack.foreground = true;

	if( IsDefined( outro ) )
	{
		level.introblack.alpha = 0;
	}

	level.introblack SetShader( "black", 640, 480 );

	if( IsDefined( outro ) )
	{
		level.introblack fadeOverTime( 2.0 );
		level.introblack.alpha = 1;
		wait( 3 );
	}

	wait( 0.05 );

	level.introstring = [];

	for( i = 0; i < strings.size; i++ )
	{
		maps\_introscreen::introscreen_create_line( strings[i] );
		if( !IsDefined( outro ) )
		{
			wait( 2 );

			if( i == strings.size - 1 )
			{
				wait( 2.5 );
			}
		}
	}

	level.player FreezeControls( false );

	// Fade out black
	if( !IsDefined( outro ) )
	{
		level.introblack fadeOverTime( 1.5 ); 
		level.introblack.alpha = 0;
	}
	else
	{
		return;
	}

	// Fade out text
	maps\_introscreen::introscreen_fadeOutText();
}

#using_animtree("fakeshooters");
set_up_models()
{
	maleidleAnim = %male_relax_stand_idleshow_none;

	//character_01 = GetEnt( "character_01", "targetname" );
	character_02 = GetEnt( "character_02", "targetname" );
	character_03 = GetEnt( "character_03", "targetname" );

	//character_01 UseAnimTree(#animtree);
	character_02 UseAnimTree(#animtree);
	character_03 UseAnimTree(#animtree);

	//character_01 animscripted("foo", character_01.origin, character_01.angles, idleAnim);
	character_02 animscripted("foo", character_02.origin, character_02.angles, maleidleAnim);
	character_03 animscripted("foo", character_03.origin, character_03.angles, maleidleAnim);

	//level thread character_01_display(character_01);
	level thread character_02_display(character_02);
	level thread character_03_display(character_03);
}

//avulaj
//setting up female with female anims
#using_animtree("fakeshooters");
set_up_model_female()
{
	idleAnim = %Gen_Civs_CasualStand_Female;

	character_01 = GetEnt( "character_01", "targetname" );
	character_01 UseAnimTree(#animtree);
	character_01 animscripted("foo", character_01.origin, character_01.angles, idleAnim);
	level thread character_01_display(character_01);
}

//avulaj
//this will dispaly a weapon and rotate 360
character_01_display(character_01)
{
	org = spawn("script_origin", character_01.origin);
	character_01 linkto( org );

	pause_trigger = GetEnt( "character_01_trigger_pause", "targetname" );
	turn_on_trigger = GetEnt( "character_01_trigger_turn_on", "targetname" );
	turn_on_trigger trigger_off();
	pause_trigger trigger_on();

	level thread rotate_character_01( org );

	turn_on_trigger thread pause_character_01_display(character_01);

	pause_trigger waittill ( "trigger" );
	
	//SOUND: added by Shawn J	
	character_01 playsound ("ped_big_stop");
	org stoploopsound();
	
	pause_trigger trigger_off();
	level notify ( "pause_character_01" );
	org rotateyaw( -0.01, 0.01 );

	org delete();

	turn_on_trigger trigger_on();
}

rotate_character_01( org )
{
	level endon ( "pause_character_01" );
	
	//SOUND: added by Shawn J	
	org playsound ("ped_big_start");
	
	while( 1 )
	{
		org rotateyaw( 3600, 71 );
		//SOUND: added by Shawn J
		org playloopsound ("ped_big_move", .2);
		wait( 7 );
	}
}

//avulaj
//
pause_character_01_display(character_01)
{
	self waittill ( "trigger" );
	level thread character_01_display(character_01);
}

//avulaj
//this will dispaly a weapon and rotate 360
character_02_display(character_02)
{
	org = spawn("script_origin", character_02.origin);
	character_02 linkto( org );

	pause_trigger = GetEnt( "character_02_trigger_pause", "targetname" );
	turn_on_trigger = GetEnt( "character_02_trigger_turn_on", "targetname" );
	turn_on_trigger trigger_off();
	pause_trigger trigger_on();

	level thread rotate_character_02( org );

	turn_on_trigger thread pause_character_02_display(character_02);

	pause_trigger waittill ( "trigger" );
	
	//SOUND: added by Shawn J	
	character_02 playsound ("ped_big_stop");
	org stoploopsound();
	
	pause_trigger trigger_off();
	level notify ( "pause_character_02" );
	org rotateyaw( -0.01, 0.01 );

	org delete();

	turn_on_trigger trigger_on();
}

rotate_character_02( org )
{
	level endon ( "pause_character_02" );

	//SOUND: added by Shawn J	
	org playsound ("ped_big_start");	
		
	while( 1 )
	{
		org rotateyaw( 3600, 71 );
		//SOUND: added by Shawn J
		org playloopsound ("ped_big_move", .2);
		wait( 7 );
	}
}

//avulaj
//
pause_character_02_display(character_02)
{
	self waittill ( "trigger" );
	level thread character_02_display(character_02);
}


//avulaj
//this will dispaly a weapon and rotate 360
character_03_display(character_03)
{
	org = spawn("script_origin", character_03.origin);
	character_03 linkto( org );

	pause_trigger = GetEnt( "character_03_trigger_pause", "targetname" );
	turn_on_trigger = GetEnt( "character_03_trigger_turn_on", "targetname" );
	turn_on_trigger trigger_off();
	pause_trigger trigger_on();

	level thread rotate_character_03( org );

	turn_on_trigger thread pause_character_03_display(character_03);

	pause_trigger waittill ( "trigger" );
	
	//SOUND: added by Shawn J	
	character_03 playsound ("ped_big_stop");
	org stoploopsound();
	
	pause_trigger trigger_off();
	level notify ( "pause_character_03" );
	org rotateyaw( -0.01, 0.01 );

	org delete();

	turn_on_trigger trigger_on();
}

rotate_character_03( org )
{
	level endon ( "pause_character_03" );
	
	//SOUND: added by Shawn J		
	org playsound ("ped_big_start");
	
	while( 1 )
	{
		org rotateyaw( 3600, 71 );
		
		//SOUND: added by Shawn J		
		org playloopsound ("ped_big_move", .2);
		
		wait( 7 );
	}
}

//avulaj
//
pause_character_03_display(character_03)
{
	self waittill ( "trigger" );
	level thread character_03_display(character_03);
}

//avulaj
//this will dispaly a weapon and rotate 360
weapons_display_p99()
{
	whites_p99 = GetEnt( "whites_p99", "targetname" );
	stop_trigger = GetEnt( "weapon_whites_p99_stop", "targetname" );
	trigger = GetEnt( "weapon_whites_p99", "targetname" );

	stop_trigger thread stop_rotate_p99( whites_p99, trigger, stop_trigger );
	
	trigger trigger_off();
	stop_trigger trigger_on();
	
	level endon ( "stop_p99" );
	
	//SOUND: added by Shawn J
	whites_p99 playsound ("ped_small_start");
	
	while( 1 )
	{
		whites_p99 show();
		whites_p99 rotateyaw( 3600, 71 );
		//SOUND: added by Shawn J		
		whites_p99 playloopsound ("ped_small_move", .2);
		
		wait( 7 );
	}
}

//avulaj
//
stop_rotate_p99( whites_p99, trigger, stop_trigger )
{
	self waittill ( "trigger" );
	level notify ( "stop_p99" );
	whites_p99 rotateyaw( -0.01, 0.01 );
	
	//SOUND: added by Shawn J	
	whites_p99 playsound ("ped_small_stop");
	whites_p99 stoploopsound();

	//*************
	//jbernardini *
	//*************
	stop_trigger trigger_off();
	
	org = spawn( "script_origin",level.player.origin );
	level.player playerlinktodelta ( org, undefined );
	
	tutorial_message("@UNLOCK_SINK_HOLE_WEAPON_01", 1);
	level.player waittill( "tutorialclosed" );
	
	level.player unlink();
	wait( .1 );
	//*************

	trigger trigger_on();
	trigger waittill ( "trigger" );

	org delete();

	level thread weapons_display_p99();
}


//avulaj
//this will dispaly a weapon and rotate 360
weapons_display_1911()
{
	whites_1911 = GetEnt( "whites_1911", "targetname" );
	stop_trigger = GetEnt( "weapon_whites_1911_stop", "targetname" );
	trigger = GetEnt( "weapon_whites_1911", "targetname" );

	stop_trigger thread stop_rotate_1911( whites_1911, trigger, stop_trigger );

	trigger trigger_off();
	stop_trigger trigger_on();

	level endon ( "stop_1911" );
	
	//SOUND: added by Shawn J
	whites_1911 playsound ("ped_small_start");
	
	while( 1 )
	{
		whites_1911 show();
		whites_1911 rotateyaw( 3600, 71 );
		
		//SOUND: added by Shawn J		
		whites_1911 playloopsound ("ped_small_move", .2);
		
		wait( 7 );
	}
}

//avulaj
//
stop_rotate_1911( whites_1911, trigger, stop_trigger )
{
	self waittill ( "trigger" );
	level notify ( "stop_1911" );
	whites_1911 rotateyaw( -0.01, 0.01 );
	
	//SOUND: added by Shawn J	
	whites_1911 playsound ("ped_small_stop");
	whites_1911 stoploopsound();
	
	//*************
	//jbernardini *
	//*************
	stop_trigger trigger_off();
	
	org = spawn( "script_origin",level.player.origin );
	level.player playerlinktodelta ( org, undefined );
	
	tutorial_message("@UNLOCK_SINK_HOLE_WEAPON_02", 1);
	level.player waittill( "tutorialclosed" );
	
	level.player unlink();
	wait( .1 );
	//*************

	trigger trigger_on();
	trigger waittill ( "trigger" );

	org delete();

	level thread weapons_display_1911();
}

//avulaj
//this will dispaly a weapon and rotate 360
weapons_display_saf45()
{
	whites_saf45 = GetEnt( "whites_saf45", "targetname" );
	stop_trigger = GetEnt( "weapon_whites_saf45_stop", "targetname" );
	trigger = GetEnt( "weapon_whites_saf45", "targetname" );

	stop_trigger thread stop_rotate_saf45( whites_saf45, trigger, stop_trigger );

	trigger trigger_off();
	stop_trigger trigger_on();

	level endon ( "stop_saf45" );
	
	//SOUND: added by Shawn J
	whites_saf45 playsound ("ped_small_start");
	
	while( 1 )
	{
		whites_saf45 show();
		whites_saf45 rotateyaw( 3600, 71 );
		
		//SOUND: added by Shawn J		
		whites_saf45 playloopsound ("ped_small_move", .2);
		
		wait( 7 );
	}
}

//avulaj
//
stop_rotate_saf45( whites_saf45, trigger, stop_trigger )
{
	self waittill ( "trigger" );
	level notify ( "stop_saf45" );
	whites_saf45 rotateyaw( -0.01, 0.01 );
	
	//SOUND: added by Shawn J	
	whites_saf45 playsound ("ped_small_stop");
	whites_saf45 stoploopsound();

	//*************
	//jbernardini *
	//*************
	stop_trigger trigger_off();
	
	org = spawn( "script_origin",level.player.origin );
	level.player playerlinktodelta ( org, undefined );
	
	tutorial_message("@UNLOCK_SINK_HOLE_WEAPON_03", 1);
	level.player waittill( "tutorialclosed" );
	
	level.player unlink();
	wait( .1 );
	//*************

	trigger trigger_on();
	trigger waittill ( "trigger" );

	org delete();

	level thread weapons_display_saf45();
}

//avulaj
//this will dispaly a weapon and rotate 360
weapons_display_phone()
{
	whites_phone = GetEnt( "whites_phone", "targetname" );
	whites_phone2 = GetEnt( "whites_phone1", "targetname" );
	stop_trigger = GetEnt( "weapon_whites_phone_stop", "targetname" );
	trigger = GetEnt( "weapon_whites_phone", "targetname" );

	stop_trigger thread stop_rotate_phone( whites_phone, whites_phone2, trigger, stop_trigger );

	trigger trigger_off();
	stop_trigger trigger_on();

	level endon ( "stop_phone" );

	//SOUND: added by Shawn J
	whites_phone playsound ("ped_small_start");
	
	while( 1 )
	{
		whites_phone show();
		whites_phone rotateyaw( -3600, 71 );
		
		//SOUND: added by Shawn J		
		whites_phone playloopsound ("ped_small_move_02", .2);
		
		whites_phone2 show();
		whites_phone2 rotateyaw( 3600, 71 );
		wait( 7 );
	}
}

//avulaj
//
stop_rotate_phone( whites_phone, whites_phone2, trigger, stop_trigger )
{
	self waittill ( "trigger" );
	level notify ( "stop_phone" );
	whites_phone rotateyaw( 0.01, 0.01 );
	whites_phone2 rotateyaw( -0.01, 0.01 );
	
	//SOUND: added by Shawn J	
	whites_phone playsound ("ped_small_stop");
	whites_phone stoploopsound();

	//*************
	//jbernardini *
	//*************
	stop_trigger trigger_off();
	
	org = spawn( "script_origin",level.player.origin );
	level.player playerlinktodelta ( org, undefined );
	
	tutorial_message("@UNLOCK_SINK_HOLE_WEAPON_04", 1);
	level.player waittill( "tutorialclosed" );
	
	level.player unlink();
	wait( .1 );
	//*************

	trigger trigger_on();
	trigger waittill ( "trigger" );

	org delete();

	level thread weapons_display_phone();
}


//avulaj
//
concept_info_01()
{
	level.player endon ( "death" );
	while ( 1 )
	{
		trigger = GetEnt( "concept_art_01", "targetname" );
		trigger waittill ( "trigger" );
		org = spawn( "script_origin",level.player.origin );
		level.player playerlinktodelta ( org, undefined );
		trigger trigger_off();

		tutorial_message("@UNLOCK_SINK_HOLE_CONCEPT_01", 1);
		level.player waittill( "tutorialclosed" );
		wait( .1 );
		level.player unlink();
		org delete();
		wait( 1 );
		trigger trigger_on();
	}
}

//avulaj
//
concept_info_02()
{
	level.player endon ( "death" );
	while ( 1 )
	{
		trigger = GetEnt( "concept_art_02", "targetname" );
		trigger waittill ( "trigger" );
		org = spawn( "script_origin",level.player.origin );
		level.player playerlinktodelta ( org, undefined );
		trigger trigger_off();

		tutorial_message("@UNLOCK_SINK_HOLE_CONCEPT_02", 1);
		level.player waittill( "tutorialclosed" );
		wait( .1 );
		level.player unlink();
		org delete();
		wait( 1 );
		trigger trigger_on();
	}
}

//avulaj
//
concept_info_03()
{
	level.player endon ( "death" );
	while ( 1 )
	{
		trigger = GetEnt( "concept_art_03", "targetname" );
		trigger waittill ( "trigger" );
		org = spawn( "script_origin",level.player.origin );
		level.player playerlinktodelta ( org, undefined );
		trigger trigger_off();

		tutorial_message("@UNLOCK_SINK_HOLE_CONCEPT_03", 1);
		level.player waittill( "tutorialclosed" );
		wait( .1 );
		level.player unlink();
		org delete();
		wait( 1 );
		trigger trigger_on();
	}
}

//avulaj
//
concept_info_04()
{
	level.player endon ( "death" );
	while ( 1 )
	{
		trigger = GetEnt( "concept_art_04", "targetname" );
		trigger waittill ( "trigger" );
		org = spawn( "script_origin",level.player.origin );
		level.player playerlinktodelta ( org, undefined );
		trigger trigger_off();

		tutorial_message("@UNLOCK_SINK_HOLE_CONCEPT_04", 1);
		level.player waittill( "tutorialclosed" );
		wait( .1 );
		level.player unlink();
		org delete();
		wait( 1 );
		trigger trigger_on();
	}
}

//avulaj
//
smart_wall_display()
{
	trigger = GetEnt( "smart_wall_display", "targetname" );
	level.player endon ( "death" );
	while ( 1 )
	{
		trigger waittill ( "trigger" );
		level.player hideViewModel();
		level.player FreezeControls(true);
		org = spawn( "script_origin", level.player.origin );
		level.player linkto ( org );
		trigger trigger_off();
		
		//SOUND: added by Shawn J
		level.player playsound ("look_in");

		level.cameraID_smartwall = level.player customCamera_push( "world", ( 3.72, -6.19, 93.50 ), ( 84.11, 90.37, -0.00 ), 3.0);
		org moveto (( 0, -53, 0 ), 0.1 );
		wait( 3.5 );

		trigger trigger_on();
		trigger waittill ( "trigger" );
		trigger trigger_off();
		
		//SOUND: added by Shawn J	
		level.player playsound ("pull_out");

		level.player customCamera_pop( level.cameraID_smartwall, 3.0 );
		wait( 3.5 );
		level.player showViewModel();

		level.player unlink();
		level.player FreezeControls(false);

		org delete();

		trigger trigger_on();
	}
}

//avulaj
//
smart_wall_display1()
{
	trigger = GetEnt( "smart_wall_display1", "targetname" );
	level.player endon ( "death" );
	while ( 1 )
	{
		trigger waittill ( "trigger" );
		level.player hideViewModel();
		level.player FreezeControls(true);
		org = spawn( "script_origin",level.player.origin );
		level.player playerlinktodelta ( org, undefined );
		trigger trigger_off();
		
		//SOUND: added by Shawn J
		level.player playsound ("look_in");

		level.cameraID_smartwall1 = level.player customCamera_push( "world", ( 72.26, -15.99, 106.30 ), ( 76.93, 90.08, -0.00 ), 3.0);
		org moveto (( 66, -53, 0 ), 0.1 );
		wait( 3.5 );

		trigger trigger_on();
		trigger waittill ( "trigger" );
		trigger trigger_off();
		
		//SOUND: added by Shawn J	
		level.player playsound ("pull_out");

		level.player customCamera_pop( level.cameraID_smartwall1, 3.0 );
		wait( 3.5 );
		level.player showViewModel();

		level.player unlink();
		level.player FreezeControls(false);

		org delete();

		trigger trigger_on();
	}
}

//avulaj
//
smart_wall_display2()
{
	trigger = GetEnt( "smart_wall_display2", "targetname" );
	level.player endon ( "death" );
	while ( 1 )
	{
		trigger waittill ( "trigger" );
		level.player hideViewModel();
		level.player FreezeControls(true);
		org = spawn( "script_origin",level.player.origin );
		level.player playerlinktodelta ( org, undefined );
		trigger trigger_off();

		//SOUND: added by Shawn J
		level.player playsound ("look_in");
		
		level.cameraID_smartwall2 = level.player customCamera_push( "world", ( -62.02, -14.31, 101.17 ), ( 76.93, 89.72, -0.00 ), 3.0);
		org moveto (( -62, -53, 0 ), 0.1 );
		wait( 3.5 );

		trigger trigger_on();
		trigger waittill ( "trigger" );
		trigger trigger_off();

		//SOUND: added by Shawn J	
		level.player playsound ("pull_out");

		level.player customCamera_pop( level.cameraID_smartwall2, 3.0 );
		wait( 3.5 );
		level.player showViewModel();

		level.player unlink();
		level.player FreezeControls(false);

		org delete();

		trigger trigger_on();
	}
}

//avulaj
//
custom_camera_car_left()
{
	trigger = GetEnt( "car_camera_left", "targetname" );
	triggerExit = GetEnt( "car_camera_exit_left", "targetname" );
	triggerExit trigger_off();
	level.player endon ( "death" );
	while ( 1 )
	{
		trigger waittill ( "trigger" );
		level.player hideViewModel();
		level.player FreezeControls(true);
		org = spawn( "script_origin", level.player.origin );
		level.player linkto ( org );
		trigger trigger_off();
		
		//SOUND: added by Shawn J			
		level.player playsound ("look_in");

		level.cameraID_car_left = level.player customCamera_push( "world", ( 665.96, 77.65, 42.83 ), ( 29.70, -135.04, -0.00 ), 3.0);
		wait( 3.5 );
		org moveto (( 697, 78, 0 ), 0.1 );

		trigger thread custom_camera_car_exit_left( triggerExit, org );
		break;
	}
}

//avulaj
//
custom_camera_car_exit_left( triggerExit, org )
{
	triggerExit trigger_on();
	triggerExit waittill ( "trigger" );
	triggerExit trigger_off();

	//org RotatePitch( 180, 0.1 );
	//org moveto (( 697, 78, 0 ), 0.1 );
	//wait( 0.5 );

	//SOUND: added by Shawn J
	level.player playsound ("pull_out");

	level.player customCamera_pop( level.cameraID_car_left, 3.0 );
	wait( 3.5 );
	level.player showViewModel();

	level.player unlink();
	level.player FreezeControls(false);

	org delete();

	self trigger_on();
	level thread custom_camera_car_left();
}

//avulaj
//
custom_camera_car_right()
{
	trigger = GetEnt( "car_camera_right", "targetname" );
	triggerExit = GetEnt( "car_camera_exit_right", "targetname" );
	triggerExit trigger_off();
	level.player endon ( "death" );
	while ( 1 )
	{
		trigger waittill ( "trigger" );
		level.player hideViewModel();
		level.player FreezeControls(true);
		org = spawn( "script_origin", level.player.origin );
		level.player linkto ( org );
		trigger trigger_off();
		
		//SOUND: added by Shawn J			
		level.player playsound ("look_in");

		level.cameraID_car_right = level.player customCamera_push( "world", ( 615.34, 74.29, 44.70 ), ( 30.90, -50.18, -0.00 ), 3.0);
		wait( 3.5 );
		org moveto (( 586, 78, 0 ), 0.1 );

		trigger thread custom_camera_car_exit_right( triggerExit, org );
		break;
	}
}

//avulaj
//
custom_camera_car_exit_right( triggerExit, org )
{
	triggerExit trigger_on();
	triggerExit waittill ( "trigger" );
	triggerExit trigger_off();
	
	//SOUND: added by Shawn J
	level.player playsound ("pull_out");

	level.player customCamera_pop( level.cameraID_car_right, 3.0 );
	wait( 3.5 );
	level.player showViewModel();

	level.player unlink();
	level.player FreezeControls(false);

	org delete();

	self trigger_on();
	level thread custom_camera_car_right();
}


//*************
//jbernardini *
//*************
play_music()
{
	while(1)
	{
		MusicPlay( "mus_unlockable", 0 );
		wait(.01);
	}
}

play_vo()
{
	while( IsAlive(level.player) )
	{
		wait(12.5);
		switch ( randomint(2) )
		{
		case 0:
			level.player playSound("M_MI6G_001A");
			break;
		case 1:
			level.player playSound("M_MI6G_002A");
			break;
		}
		wait(60);
	}
}

link_weapons()
{
	base = getent("whites_1911", "targetname");
	attachment1 = getent("attachment1", "targetname");
	attachment2 = getent("attachment2", "targetname");
	attachment3 = getent("attachment3", "targetname");
	attachment4 = getent("attachment4", "targetname");

	attachment1 linkto(base);
	attachment2 linkto(base);
	attachment3 linkto(base);
	attachment4 linkto(base);

	base2 = getent("whites_p99", "targetname");
	attachment6 = getent("attachment6", "targetname");
	attachment7 = getent("attachment7", "targetname");
	attachment8 = getent("attachment8", "targetname");
	attachment9 = getent("attachment9", "targetname");
	attachment10 = getent("attachment10", "targetname");
	attachment11 = getent("attachment11", "targetname");

	attachment6 linkto(base2);
	attachment7 linkto(base2);
	attachment8 linkto(base2);
	attachment9 linkto(base2);
	attachment10 linkto(base2);
	attachment11 linkto(base2);
}

level_end1()
{
	trigger = getent("level_end_trigger1", "targetname");
	trigger sethintstring (&"UNLOCK_SINK_HOLE_EXIT");
	trigger waittill("trigger");
	changelevel( "", false, 0 );
}

level_end2()
{
	trigger = getent("level_end_trigger2", "targetname");
	trigger sethintstring (&"UNLOCK_SINK_HOLE_EXIT");
	trigger waittill("trigger");
	changelevel( "", false, 0 );
}

level_end3()
{
	trigger = getent("level_end_trigger3", "targetname");
	trigger sethintstring (&"UNLOCK_SINK_HOLE_EXIT");
	trigger waittill("trigger");
	changelevel( "", false, 0 );
}

level_end4()
{
	trigger = getent("level_end_trigger4", "targetname");
	trigger sethintstring (&"UNLOCK_SINK_HOLE_EXIT");
	trigger waittill("trigger");
	changelevel( "", false, 0 );
}

screensaver()
{
	level.player endon ( "death" );

	screen = getent(self.target, "targetname");
	screen hide();
	while(IsAlive(level.player))
	{
		self waittill("trigger");
		screen show();
		screen playSound("wake_up");
		wait(60);
		screen hide();
	}
}
