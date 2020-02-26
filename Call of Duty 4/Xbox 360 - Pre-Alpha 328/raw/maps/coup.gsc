// fix credits timing
// rework credit positioning so each names have centered alignment, but are shifted offset from each other
// the 2nd name receives no shifting( it's position is relative to screen edges and the other names are relative to it ), with this arrangment, left and right positions work identically, and more positions can easily be added
// finish breathing sounds when hit

// drive start causes script error
// reflection probes are making some areas super bright
// need to get end sequence view updated, currently you miss seeing the soldier putting you on the pole almost entirely
// scr_anim generic for automatic idle transition

// more ai runners
// physics objects thrown out of windows
// ashes raining down effects
// clean out old script
// improve player hit in car( visionset )
// 
// get dog crossing street in
// guys patrolling
// guys smoking
// guys leaning against walls
// add more chickens
// add more dogs

// people getting chased
// people getting ziptied
// soldiers running
// dog walks?
// shorten end drag, 2 pulses, 3rd fades to put on pole anim
// get cowering guys in, getting shot, and other cowerers reacting
// can't look around during end sequence, can't see guards, are the animations sync'd properly
// window animations
// dog eating
// walking chickens
// cheering guys from hunted
// civilian bash to ground from scoutsniper

// see civilians getting abused
// they revolt and attack back later in the level
// sneak up and bash soldiers
// civilians with weapons attack soldiers with stolen weapons
// scripted smoke grenade?

// key points
// 		change truck unload to run a reinforcement to the market( gun point anims )
// 		show friendlies knocking out soldiers
// 		show friendlies in a firefight

// add casual guards around base at the end
// add celebrators along the shore
// figure out what to do with the vehicle chase, doesn't seem to fit atm( change to tank driving to base? )
// change last fight so civilians are attacking, figure out better timing / positioning()

// get final positioning of sneak attack in
// get talking guys sequence in
// update grid light data
// curb stomp civilian
// stumble / fall / look anims
// passenger anims

#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\coup_code;

main()
{
	precachemodel( "fx" );
	precachemodel( "viewhands_player_usmc" );
	precachemodel( "weapon_desert_eagle_silver_HR_promo" );
	precachemodel( "com_door_01_handleright" );
	precachemodel( "chicken" );
	precacheShellShock( "blackout1" );
	precacheShellShock( "blackout2" );
	precacheShellShock( "blackout3" );
	
	level.weaponClipModels = [];
	level.weaponClipModels[ 0 ] = "weapon_ak47_clip";
	level.weaponClipModels[ 1 ] = "weapon_ak74u_clip";

	default_start( ::startIntro );
	add_start( "drive", ::startDrive );
	add_start( "doorkick", ::startDoorKick );
	add_start( "trashstumble", ::startTrashStumble );
	add_start( "runners2", ::startRunners2 );
	add_start( "alley", ::startAlley );
	add_start( "shore", ::startShore );
	add_start( "carexit", ::startCarExit );
	add_start( "ending", ::startEnding );

	maps\_luxurysedan::main( "vehicle_luxurysedan_viewmodel" );
	maps\_hind::main( "vehicle_mi24p_hind_desert" );
 	maps\_mig29::main( "vehicle_mig29_desert" );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_bed" );
 	maps\_80s_sedan1::main( "vehicle_80s_sedan1_silv" );
 	maps\_mi17::main( "vehicle_mi17_woodland_fly" );
 	maps\_bmp::main( "vehicle_bmp" );
	
	maps\coup_fx::main();
	maps\createart\coup_art::main();
	// thread initDOF();
	maps\_load::main();
	maps\createfx\coup_audio::main();
	maps\coup_anim::main();
	thread maps\coup_amb::main();
	maps\_drone::init(); 
	DeleteCharacterTriggers();

 	array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ), maps\_mig29::plane_sound_node );
	array_thread( getentarray( "civilian", "script_noteworthy" ), ::add_spawn_function, ::setTeam, "axis" );
	array_thread( getentarray( "civilian", "script_noteworthy" ), ::add_spawn_function, ::gun_remove );
	array_thread( getentarray( "civilian_redshirt", "script_noteworthy" ), ::add_spawn_function, ::setSightDist, 0 );
	array_thread( getentarray( "civilian_redshirt", "script_noteworthy" ), ::add_spawn_function, ::setTeam, "allies" );
	array_thread( getentarray( "civilian_redshirt", "script_noteworthy" ), ::add_spawn_function, ::gun_remove );
	array_thread( getentarray( "civilian_attacker", "script_noteworthy" ), ::add_spawn_function, ::setTeam, "allies" );
	// array_thread( getentarray( "guard_redshirt", "script_noteworthy" ), ::add_spawn_function, ::gun_remove );
	array_thread( getentarray( "civilian_firingsquad", "script_noteworthy" ), ::add_spawn_function, ::setTeam, "allies" );
	array_thread( getentarray( "guard_firingsquad", "script_noteworthy" ), ::add_spawn_function, ::setupTarget );
	array_thread( getentarray( "passengeranim", "targetname" ), ::passengeranim );
	
	flag_init( "drive" );
	flag_init( "doors_open" );
	flag_init( "ending" );
	flag_init( "firingsquad_aiming" );

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player takeAllWeapons();
	level.player.ignoreme = true;

	level.playerview = spawn_anim_model( "playerview" );
	level.playerview hide();

	level.car = spawn_anim_model( "car" );

	wait 0.05;// can't set dvars on the first frame
	SetSavedDvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );	
	SetSavedDvar( "hud_showStance", 0 );
	// setsaveddvar( "cg_fov", 50 );
}

startIntro()
{
	thread intro_doors();
	thread initCredits();
	thread music();
	
	thread execIntro();
}

startDrive()
{
	thread execDrive();
	flag_set( "drive" );
}

startDoorKick()
{
// 	start_doorkick = getent( "start_doorkick", "targetname" );
	
// 	level.player setOrigin( start_doorkick.origin );
// 	level.player setPlayerAngles( start_doorkick.angles );
	
	thread execDrive( 0.15 );
	flag_set( "drive" );
}

startTrashStumble()
{
	thread execDrive( 0.32 );
	flag_set( "drive" );
}

startRunners2()
{
	thread execDrive( 0.45 );
	flag_set( "drive" );
}

startAlley()
{
	start_alley = getent( "start_alley", "targetname" );
	
	level.player setOrigin( start_alley.origin );
	level.player setPlayerAngles( start_alley.angles );

	thread execDrive( 0.55 );
	flag_set( "drive" );
}

startShore()
{
	start_shore = getent( "start_shore", "targetname" );
	level.player setOrigin( start_shore.origin );
	level.player setPlayerAngles( start_shore.angles );

	thread execDrive( 0.82 );
	flag_set( "drive" );
}

startCarExit()
{
	thread execDrive( 0.92 );
	flag_set( "drive" );
}

startEnding()
{
	start_ending = getent( "start_ending", "targetname" );
	
	level.player setOrigin( start_ending.origin );
	level.player setPlayerAngles( start_ending.angles );
	
	thread execEnding();
}

execIntro()
{
	thread execDrive();
	delaythread( 0.5, ::openIntroDoors );
	delaythread( 2, ::intro_speech );
	delaythread( 5, ::intro_birds );
	delaythread( 1, ::ziptie, "ziptie1a", undefined, 20 );
	delaythread( 1, ::spawn_vehicle_from_targetname_and_drive, "intro_heli" );
	delaythread( 5, ::playCredits );
	// delaythread( 5, ::intro_chicken );// temp

	node = getent( "intro_node", "targetname" );
	leftguard = scripted_spawn2( "intro_leftguard", "targetname", true );
	rightguard = scripted_spawn2( "intro_rightguard", "targetname", true );
	carguard = scripted_spawn2( "intro_carguard", "targetname", true );
	radioguard = scripted_spawn2( "intro_radioguard", "targetname", true );
	smokingguard = scripted_spawn2( "intro_smokingguard", "targetname", true );
	dog = scripted_spawn2( "intro_dog", "targetname", true );

	idleguards = scripted_array_spawn( "intro_idleguards", "targetname", true );
	for ( i = 0; i < idleguards.size; i++ )
		idleguards[ i ].animname = "drone_human";

	celebrators = scripted_array_spawn( "intro_celebrators", "targetname", true );
	for ( i = 0; i < celebrators.size; i++ )
	{
		celebrators[ i ].animname = "drone_human";
		celebrators[ i ] removeDroneWeapon();
		celebrators[ i ] thread celebrate();
	}

	tiedcivilians = scripted_array_spawn( "intro_tiedcivilian", "targetname", true );
	for ( i = 0; i < tiedcivilians.size; i++ )
		thread ziptied( tiedcivilians[ i ], 20 );

	rightguard.animname = "drone_human";
	leftguard.animname = "drone_human";
	radioguard.animname = "drone_human";
	smokingguard.animname = "drone_human";
	dog.animname = "drone_dog";

	radioguard thread anim_single_solo( radioguard, "radio" );
	smokingguard thread anim_loop_solo( smokingguard, "leaning_smoking_idle" );
	dog thread anim_single_solo( dog, "idle" );

	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	node anim_first_frame_solo( playerview, "intro" );
	level.player playerlinkto( playerview, "tag_player", 1, 45, 45, 30, 30 );

	node thread anim_single_solo( rightguard, "intro_rightguard" );
	node thread anim_single_solo( leftguard, "intro_leftguard" );
	node thread anim_single_solo( level.car, "intro" );
	node anim_single_solo( playerview, "intro" );
	
	wait 1.5;
	flag_set( "drive" );
}

execDrive( time )
{
	// temp
	thread drive_talkingguards1();
	thread drive_casualguards1();
	thread drive_eatingdog1();
	thread drive_doorkick1();
	thread drive_ziptie1();
	thread drive_ziptie2();
	thread drive_ziptie3();
	thread drive_doorkick2();
	thread drive_runners1();
	thread drive_windowshout1();
	thread drive_gunpoint1();
	thread drive_gunpoint2();
	thread drive_trashstumble();
	thread drive_casualguards2();
	thread drive_spraypaint1();
	thread drive_civiliansfightback();
	thread drive_ziptie4();
	thread drive_runners2();
	thread drive_garage1();
	thread drive_garage2();
	thread drive_basehinds();
	thread drive_celebrators2();
	thread drive_casualguards3();
	thread drive_endcrowd();
	thread drive_fastrope1();
	thread drive_firingsquad();
	thread drive_ziptie5();

	// show car tags
	// level.car thread maps\_debug::drawTagForever( "tag_driver", ( 0, 1, 0 ) );
	// level.car thread maps\_debug::drawTagForever( "tag_passenger" );
	// level.car thread maps\_debug::drawTagForever( "tag_guy0" );
	// level.car thread maps\_debug::drawTagForever( "tag_guy1" );

	car_driver = scripted_spawn2( "car_driver", "targetname", true );
	car_passenger = scripted_spawn2( "car_passenger", "targetname", true );

	car_driver.animname = "drone_human";
	car_passenger.animname = "drone_human";

	car_driver linkto( level.car, "tag_driver" );
	car_passenger linkto( level.car, "tag_passenger" );
	
	level.car.driver = car_driver;
	level.car.passenger = car_passenger;
	level.car.playerview = level.playerview;
	
	level.car thread anim_loop_solo( car_driver, "cardriver_idle", "tag_driver", "stop_driver_idle" );
	level.car thread anim_loop_solo( car_passenger, "carpassenger_idle", "tag_passenger", "stop_passenger_idle" );
	// thread drive_passengeranims();

	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	level.car_ride_playerview = playerview;
	level.car anim_first_frame_solo( playerview, "car_idle_firstframe", "tag_guy1" );
	playerview linkto( level.car, "tag_guy1" );
	// playerview linkto( level.car, "tag_guy1", ( 50, 0, -20 ), ( 0, 90, 0 ) );// temp

	flag_wait( "drive" );

	level.player playerlinktodelta( playerview, "tag_player", 1, 180, 180, 30, 30 );
	// level.player playerlinktodelta( playerview, "tag_player", 1, 180, 180, 45, 45 );

	level.car thread anim_loop_solo( playerview, "car_idle", "tag_guy1", "stop_playerview_idle" );// temp

	drive_node = getent( "intro_node", "targetname" );
	drive_node thread anim_single_solo( level.car, "coup_car_driving" );
	
	if ( isdefined( time ) )
	{
		anime = level.car getanim( "coup_car_driving" );
		level.car SetAnimTime( anime, time );
	}
	
	thread execCarExit();
}

execCarExit()
{
	flag_wait( "drive_carexit" );

	leftguard = scripted_spawn2( "carexit_leftguard", "targetname", true );
	rightguard = scripted_spawn2( "carexit_rightguard", "targetname", true );

	leftguard.animname = "drone_human";
	rightguard.animname = "drone_human";

	level.car waittillmatch( "single anim", "end" );

	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	level.car anim_first_frame_solo( playerview, "carexit" );
	wait 0.05;

	ride_tag_angles = level.car_ride_playerview gettagangles( "tag_player" );
	player_angles = level.player getplayerangles();
	final_angles = playerview gettagangles( "tag_player" );
	final_origin = playerview gettagorigin( "tag_player" );
	ride_tag_origin = level.car_ride_playerview gettagorigin( "tag_player" );

	/* 
	
	ride_origin = level.car_ride_playerview.origin;
	level.car_ride_playerview unlink();
	difference = final_angles - player_angles;
	*/ 
// 	level.car_ride_playerview thread maps\_debug::drawOrgForever( ( 0, 1, 1 ) );
// 	playerview thread maps\_debug::drawOrgForever( ( 0.5, 0, 0 ) );
	// level.car_ride_playerview thread maps\_debug::drawTagForever( "tag_player", ( 0, 0.5, 1 ) );
	// playerview thread maps\_debug::drawTagForever( "tag_player", ( 1, 0, 0 ) );
	// thread maps\_debug::drawPlayerViewForever();
	
	origin = spawn( "script_model", level.player.origin );
	origin setmodel( "tag_origin" );
// 	origin.origin = ride_tag_origin;
	origin.origin = get_player_feet_from_view();
	// origin thread maps\_debug::drawTagForever( "tag_origin", ( 0, 1, 0 ) );
	origin.angles = level.player GetPlayerAngles();
	
// 	wait( 1 );

// 	level.car_ride_playerview moveto( ride_origin + ( ride_tag_origin - ride_origin ), 5 );
// 	level.car_ride_playerview moveto( playerview.origin, 5 );
// 	level.car_ride_playerview rotateto( ride_tag_angles + ( final_angles - player_angles ), 5 );
// 	wait( 6 );
	// spawn script_origin
	// set to player origin and angles
	// link player to it
	// rotate to origin and angles of animation start
	
	level.player unlink();
	wait( 0.05 );
	level.player playerlinktodelta( origin, "tag_origin", 1, 0, 0, 0, 0 );
	
// 	wait( 1 );
	blend = 0.25;
	timer = 0.8;
	origin moveto( final_origin, timer, timer * blend, timer * blend );
	origin RotateTo( final_angles, timer, timer * blend, timer * blend );
	wait timer;

	// level.player playerlinkto( playerview, "tag_player", 1, 45, 45, 30, 30 );
	level.player playerlinkto( playerview, "tag_player", 1, 0, 0, 0, 0 );

	level.car thread anim_single_solo( leftguard, "carexit_leftguard" );
	level.car thread anim_single_solo( rightguard, "carexit_rightguard" );
	level.car thread anim_single_solo( level.car, "carexit" );
	level.car thread anim_single_solo( playerview, "carexit" );

	wait 12.60;

	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	overlay.sort = 1;

	thread pulseFadeVision( 29, 0 );// long pulsing fades
	level.player shellshock( "blackout1", 8 );// fade out over 1 sec, wait 2, fade in over 5
	overlay fadeOverlay( 1, 1, 6 );// fade out
	wait 2;

	// do intro drag with glimpses
	node = getent( "enddrag1_node", "targetname" );
	leftguard = scripted_spawn2( "enddrag_leftguard", "targetname", true );
	rightguard = scripted_spawn2( "enddrag_rightguard", "targetname", true );

	rightguard.animname = "drone_human";
	leftguard.animname = "drone_human";

	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	node anim_first_frame_solo( playerview, "intro" );
	level.player playerlinkto( playerview, "tag_player", 1, 45, 45, 30, 30 );

	node thread anim_single_solo( rightguard, "intro_rightguard" );
	node thread anim_single_solo( leftguard, "intro_leftguard" );
	node thread anim_single_solo( playerview, "intro" );

	overlay fadeOverlay( 5, 0, 2.5 );// fade in
	wait 5;
	level.player shellshock( "blackout2", 8 );// fade out over 1 sec, wait 2, fade in over 5
	overlay fadeOverlay( 1, 1, 6 );// fade out
	wait 2;

	// scripted_array_spawn( "ending_spawner", "script_noteworthy", true );
	// scripted_array_spawn( "ending_idleguards", "targetname", true );

	idleguards = scripted_array_spawn( "ending_idleguards", "targetname", true );
	for ( i = 0; i < idleguards.size; i++ )
		idleguards[ i ].animname = "drone_human";

	smokingguards = scripted_array_spawn( "ending_smokingguards", "targetname", true );
	for ( i = 0; i < smokingguards.size; i++ )
	{
		smokingguards[ i ].animname = "drone_human";
		smokingguards[ i ] thread anim_loop_solo( smokingguards[ i ], "leaning_smoking_idle" );
	}

	celebratingguards = scripted_array_spawn( "ending_celebratingguards", "targetname", true );
	for ( i = 0; i < celebratingguards.size; i++ )
	{
		celebratingguards[ i ].animname = "drone_human";
		celebratingguards[ i ] removeDroneWeapon();
		celebratingguards[ i ] thread celebrate();
	}

	node = getent( "enddrag3_node", "targetname" );
	node anim_first_frame_solo( playerview, "intro" );
	node thread anim_single_solo( rightguard, "intro_rightguard" );
	node thread anim_single_solo( leftguard, "intro_leftguard" );
	node thread anim_single_solo( playerview, "intro" );

	overlay fadeOverlay( 5, 0, 2.5 );// fade in
	wait 5;
	level.player shellshock( "blackout3", 8 );// fade out over 1 sec, wait 2, fade in over 5
	overlay fadeOverlay( 1, 1, 6 );// fade out
	wait 2;

	thread execEnding();
	leftguard delete();
	rightguard delete();
	playerview delete();

	overlay fadeOverlay( 5, 0, 0 );// fade in
	overlay destroy();
}

execEnding()
{
	level notify( "end_credits" );
	thread initDOF();
	setDOF( 0, 1, 5, 500, 2000, 4 );// initial DOF setting

	setsaveddvar( "cg_fov", 50 );
	musicstop( 5 );
	
	ending_node = getent( "ending_node", "targetname" );
	
	ending_alasad = scripted_spawn2( "ending_alasad", "targetname", true );
	ending_zakhaev = scripted_spawn2( "ending_zakhaev", "targetname", true );
	ending_leftguard = scripted_spawn2( "ending_leftguard", "targetname", true );
	ending_rightguard = scripted_spawn2( "ending_rightguard", "targetname", true );

	ending_alasad.animname = "ending_alasad";
	ending_zakhaev.animname = "ending_zakhaev";
	ending_leftguard.animname = "ending_leftguard";
	ending_rightguard.animname = "ending_rightguard";

	// Remove ak47s
	ending_alasad setWeapon( "none" );
	ending_zakhaev setWeapon( "none" );
	ending_zakhaev attach( "weapon_desert_eagle_silver_HR_promo", "tag_inhand" );
	
	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	ending_node anim_first_frame_solo( playerview, "ending" );
	
	dummy = spawn_anim_model( "playerview" );
	dummy hide();
	dummy.origin = get_player_feet_from_view();
	dummy.angles = level.player getplayerangles();
	level.player playerlinkto( dummy, "tag_player", 1, 0, 0, 0, 0 );
	dummy rotateto( playerview.angles, .1 );
	dummy moveto( playerview.origin, .1 );
	dummy waittill( "rotatedone" );
	
	level.player playerlinkto( playerview, "tag_player", 1, 45, 45, 30, 30 );
	
	ending_node thread anim_single_solo( playerview, "ending" );
	
	escort_actors[ 0 ] = ending_leftguard;
	escort_actors[ 1 ] = ending_rightguard;
	ending_node thread anim_single( escort_actors, "ending_escort" );

	wait 6.66;
	execution_actors[ 0 ] = ending_alasad;
	execution_actors[ 1 ] = ending_zakhaev;
	ending_node thread anim_single( execution_actors, "ending_execution" );	
	thread ending_dofchange();

	wait 0.05;
	level.player thread play_sound_on_entity( "coup_abs_greatnation" );
	
	wait 15;
	level.player thread play_sound_on_entity( "coup_abs_willperish" );
	
	// dialogprint( "Today, we rise again as one nation, in the face of betrayal and corruption!!!", 7 );
	// dialogprint( "We all trusted this man to deliver our great nation into a new era of prosperity...", 7 );

	// wait 3;

	// dialogprint( "...but like our monarchy before the Revolution, he has been colluding with the West with only self interest at heart!", 7 );
	// dialogprint( "Collusion breeds slavery!! And we shall not be enslaved!!!", 7 );
}

intro_doors()
{
	intro_leftdoor = getent( "intro_leftdoor", "targetname" );
	intro_leftdoor.origin = ( - 15, -510, 70 );
	intro_leftdoor.angles += ( 0, 180, 0 );

	intro_rightdoor = getent( "intro_rightdoor", "targetname" );
	intro_rightdoor.origin = ( 143, -510, 70 );
	intro_rightdoor.angles += ( 0, 180, 0 );
	
	set_vision_set( "coup_sunblind" );
	
	// blackout player's view
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;
	overlay.sort = 1;
	overlay.foreground = true;
	
	flag_wait( "doors_open" );

	// musicPlay( "music_coup_intro" ); 
	set_vision_set( "coup", 12 );
	
	overlay fadeOverTime( 0.5 );
	overlay.alpha = 0;

	wait 0.5;
	overlay destroy();
}

intro_speech()
{
	origin = spawn( "script_origin", ( 0, 0, 0 ) );
	origin.origin = level.player.origin;
	origin.angles = level.player.angles;
	origin linkto( level.player );

	origin playsound( "coup_dragin_speech_1" );
	wait 17;
	origin playsound( "coup_dragin_speech_2" );
	wait 22;
	origin playsound( "coup_dragin_speech_3" );
}

intro_birds()
{
	exploder( 1 );
	
	wait 5.5;
	exploder( 2 );
}

intro_chicken()
{
	node = getent( "chicken_node", "targetname" );
	
	// chicken = spawn_anim_model( "chicken" );
	// node thread anim_single_solo( chicken, "walk_basic" );
	
	chicken2 = spawn_anim_model( "chicken" );
	node thread anim_single_solo( chicken2, "cage_freakout" );
}

drive_talkingguards1()
{
	flag_wait( "drive_talkingguards1" );

	node = getent( "talkingguards1_node", "targetname" );
	leftguard = scripted_spawn2( "talkingguards1_leftguard", "targetname", true );
	rightguard = scripted_spawn2( "talkingguards1_rightguard", "targetname", true );

	leftguard.animname = "drone_human";
	rightguard.animname = "drone_human";

	node thread anim_single_solo( leftguard, "talkingguards_leftguard" );
	node thread anim_single_solo( rightguard, "talkingguards_rightguard" );
	
	/* wait 20;
	leftguard delete();
	rightguard delete();*/ 
}

drive_casualguards1()
{
	flag_wait( "drive_casualguards1" );

	smokingguard = scripted_spawn2( "casualguards1_smokingguard", "targetname", true );
	idleguard1 = scripted_spawn2( "casualguards1_idleguard1", "targetname", true );
	idleguard2 = scripted_spawn2( "casualguards1_idleguard2", "targetname", true );
	dog = scripted_spawn2( "casualguards1_dog", "targetname", true );

	smokingguard.animname = "drone_human";
	dog.animname = "drone_dog";

	smokingguard thread anim_loop_solo( smokingguard, "leaning_smoking_idle" );
	dog thread anim_loop_solo( dog, "sleeping" );
	
	/* wait 20;
	smokingguard delete();
	idleguard delete();
	dog delete();*/ 
}

drive_eatingdog1()
{
	flag_wait( "drive_eatingdog1" );
	
	dog = scripted_spawn2( "eatingdog1_dog", "targetname", true );
	dog.animname = "dog";
	dog thread anim_loop_solo( dog, "eating" );

	wait 20;
	dog delete();
}

drive_doorkick1()
{
	flag_wait( "drive_doorkick1" );

	node = getent( "doorkick1_node", "targetname" );
	leftguard = scripted_spawn2( "doorkick1_leftguard", "targetname", true );
	rightguard = scripted_spawn2( "doorkick1_rightguard", "targetname", true );

	node doorkick( leftguard, rightguard, 7 );
}

drive_ziptie1()
{
	flag_wait( "drive_ziptie1" );

	ziptie( "ziptie1", undefined, 20 );
}

drive_ziptie2()
{
	flag_wait( "drive_ziptie2" );

	ziptie( "ziptie2", undefined, 20 );
}

drive_doorkick2()
{
	flag_wait( "drive_doorkick2" );

	node = getent( "doorkick2_node", "targetname" );
	leftguard = scripted_spawn2( "doorkick2_leftguard", "targetname", true );
	rightguard = scripted_spawn2( "doorkick2_rightguard", "targetname", true );

	node doorkick( leftguard, rightguard, undefined, true );
}

// make sure this plays out killing the runners in the correct order
drive_runners1()
{
	flag_wait( "drive_runners1" );

	civilian1 = scripted_spawn2( "runners1_civilian1", "targetname", true );
	civilian2 = scripted_spawn2( "runners1_civilian2", "targetname", true );
	civilian3 = scripted_spawn2( "runners1_civilian3", "targetname", true );
	// civilian4 = scripted_spawn2( "runners1_civilian4", "targetname", true );

	civilian1.animname = "ai_human";
	civilian2.animname = "ai_human";
	civilian3.animname = "ai_human";
	// civilian4.animname = "ai_human";
	
	civilian1.disableexits = true;
	civilian2.disableexits = true;
	civilian3.disableexits = true;
	// civilian4.disableexits = true;

	runanims[ 0 ] = "run_panicked1";
	runanims[ 1 ] = "run_panicked2";
	civilian1 setRandomRun( runanims );
	civilian2 setRandomRun( runanims );
	civilian3 setRandomRun( runanims );
	// civilian4 set_run_anim( runanims[ RandomInt( 1 ) ], true );
	
	wait 3;

	guard1 = scripted_spawn2( "runners1_guard1", "targetname", true );
	guard2 = scripted_spawn2( "runners1_guard2", "targetname", true );

	wait 3;
	guard1.baseaccuracy = 1000;
	guard2.baseaccuracy = 1000;

	/* wait 10;
	runner1 delete();
	runner2 delete();
	runner3 delete();*/ 
}

drive_windowshout1()
{
	flag_wait( "drive_windowshout1" );

	civilian = scripted_spawn2( "windowshout1_civilian", "targetname", true );
	
	thread windowshout( civilian );
}

drive_gunpoint1()
{
	flag_wait( "drive_gunpoint1" );

	standguard = scripted_spawn2( "gunpoint1_standguard", "targetname", true );
	standcivilian = scripted_spawn2( "gunpoint1_standcivilian", "targetname", true );
	crouchguard = scripted_spawn2( "gunpoint1_crouchguard", "targetname", true );
	crouchcivilian = scripted_spawn2( "gunpoint1_crouchcivilian", "targetname", true );

	tiedcivilians = scripted_array_spawn( "gunpoint1_tiedcivilian", "targetname", true );
	for ( i = 0; i < tiedcivilians.size; i++ )
		thread ziptied( tiedcivilians[ i ], 20 );

	thread gunpoint_stand( standguard, standcivilian, 20 );
	thread gunpoint_crouch( crouchguard, crouchcivilian, 20 );
}

drive_gunpoint2()
{
	flag_wait( "drive_gunpoint2" );

	standguard = scripted_spawn2( "gunpoint2_standguard", "targetname", true );
	standcivilian = scripted_spawn2( "gunpoint2_standcivilian", "targetname", true );
	crouchguard = scripted_spawn2( "gunpoint2_crouchguard", "targetname", true );
	crouchcivilian = scripted_spawn2( "gunpoint2_crouchcivilian", "targetname", true );

	thread gunpoint_stand( standguard, standcivilian, 20 );
	thread gunpoint_crouch( crouchguard, crouchcivilian, 20 );
}

drive_ziptie3()
{
	flag_wait( "drive_ziptie3" );

	ziptie( "ziptie3", undefined, 20 );
}

// change guards to script spawned and set accuracy to 0 to make sure the runner isn't killed
drive_trashstumble()
{
	node = getent( "trashstumble_node", "targetname" );

	trashcan_rig = spawn_anim_model( "trashcan_rig" );
	trashcan_rig.origin = node.origin;
	trashcan_rig.angles = node.angles;
	
	trashcan = spawn( "script_model", ( 0, 0, 0 ) );
	trashcan setmodel( "com_trashcan_metal" );
	trashcan.origin = trashcan_rig getTagOrigin( "prop_rig_anim" );
	trashcan.angles = trashcan_rig getTagAngles( "prop_rig_anim" );
	trashcan linkto( trashcan_rig, "prop_rig_anim", ( 0, 0, 0 ), ( 0, 0, -90 ) );	
	node thread anim_first_frame_solo( trashcan_rig, "trash_stumble" );

	flag_wait( "drive_trashstumble" );

	runner = scripted_spawn2( "trashstumble_runner", "targetname", true );
	runner.animname = "ai_human";
	runner.a.disablePain = true;
	runner thread magic_bullet_shield();

	// chaser = scripted_spawn2( "trashstumble_chaser", "targetname", true );
	// chaser_goal = getent( "trashstumble_chaser_goal", "targetname" );
	// chaser setgoalpos( chaser_goal.origin );

	node thread anim_first_frame_solo( runner, "trash_stumble" );// needed?
	node thread anim_single_solo( trashcan_rig, "trash_stumble" );
	node anim_custom_animmode_solo( runner, "gravity", "trash_stumble" );

	node = getent( "wallclimb_node", "targetname" );
	node anim_single_solo( runner, "wall_climb" );
	
	wait 10;
	trashcan delete();
	trashcan_rig delete();
	runner stop_magic_bullet_shield();
	runner delete();
}

drive_casualguards2()
{
	flag_wait( "drive_casualguards2" );

	smokingguard = scripted_spawn2( "casualguards2_smokingguard", "targetname", true );
	idleguard = scripted_spawn2( "casualguards2_idleguard", "targetname", true );
	smokingguard.animname = "drone_human";

	smokingguard thread anim_loop_solo( smokingguard, "leaning_smoking_idle" );
	
	wait 20;
	smokingguard delete();
	if (isalive(idleguard))
		idleguard delete();
}

drive_spraypaint1()
{
	flag_wait( "drive_spraypaint1" );

	node = getent( "spraypaint1_node", "targetname" );
	civilian = scripted_spawn2( "spraypaint1_civilian", "targetname", true );
	civilian.animname = "ai_human";
	civilian.disableexits = true;
	civilian.ignoreme = true;	// temp
	
	runanims[ 0 ] = "run_panicked1";
	runanims[ 1 ] = "run_panicked2";
	civilian set_run_anim( runanims[ RandomInt( 1 ) ], true );

	node anim_single_solo( civilian, "spraypainting" );
	
	wait 20;
	civilian delete();
}

// guards pointing weapons at civilians are attacked
// they kill atleast 1 civilian at gunpoint
drive_civiliansfightback()
{
	flag_wait( "drive_civiliansfightback" );

	civilian1 = scripted_spawn2( "sneakattack_civilian1", "targetname", true );
	civilian1.animname = "ai_human";
	civilian1 thread anim_loop_solo( civilian1, "cowerstand_pointidle" );
	civilian2 = scripted_spawn2( "sneakattack_civilian2", "targetname", true );
	civilian2.animname = "ai_human";
	civilian2 thread anim_loop_solo( civilian2, "cowerstand_pointidle" );

	attacker1 = scripted_spawn2( "sneakattack_attacker1", "targetname", true );
	guard1 = scripted_spawn2( "sneakattack_guard1", "targetname", true );
	attacker2 = scripted_spawn2( "sneakattack_attacker2", "targetname", true );
	guard2 = scripted_spawn2( "sneakattack_guard2", "targetname", true );

	wait 5;
	enemy1 = getent( "ziptie4_guard", "targetname" ); // temp hackery
	enemy2 = getent( "ziptie4b_guard", "targetname" ); // temp hackery
	guard1 thread attackbehind( attacker1, enemy1 );
	guard2 thread attackside( attacker2, enemy2 );
	
	wait 2;
	civilian1 thread anim_single_solo( civilian1, "cowerstand_react_to_crouch" );

	wait 2;
	civilian2 thread anim_single_solo( civilian2, "cowerstand_react" );
}

drive_ziptie4()
{
	flag_wait( "drive_ziptie4" );

	tiedcivilians = scripted_array_spawn( "ziptie4_tiedcivilian", "targetname", true );
	for ( i = 0; i < tiedcivilians.size; i++ )
		thread ziptied( tiedcivilians[ i ], 20 );

	thread ziptie( "ziptie4", undefined, 20 );
	wait 2;
	thread ziptie( "ziptie4b", undefined, 20 );
}

drive_runners2()
{
	flag_wait( "drive_runners2" );

	civilian1 = scripted_spawn2( "runners2_civilian1", "targetname", true );
	civilian2 = scripted_spawn2( "runners2_civilian2", "targetname", true );
	civilian3 = scripted_spawn2( "runners2_civilian3", "targetname", true );
	civilian4 = scripted_spawn2( "runners2_civilian4", "targetname", true );

	/* civilian1.animname = "ai_human";
	civilian2.animname = "ai_human";
	civilian3.animname = "ai_human";
	civilian4.animname = "ai_human";
	
	civilian1.disableexits = true;
	civilian2.disableexits = true;
	civilian3.disableexits = true;
	civilian4.disableexits = true;

	runanims[ 0 ] = "run_panicked1";
	runanims[ 1 ] = "run_panicked2";
	
	civilian1 set_run_anim( runanims[ RandomInt( 1 ) ], true );
	civilian2 set_run_anim( runanims[ RandomInt( 1 ) ], true );
	civilian3 set_run_anim( runanims[ RandomInt( 1 ) ], true );
	civilian4 set_run_anim( runanims[ RandomInt( 1 ) ], true );*/ 
	
	wait 1;

	guard1 = scripted_spawn2( "runners2_guard1", "targetname", true );
	guard2 = scripted_spawn2( "runners2_guard2", "targetname", true );
	guard3 = scripted_spawn2( "runners2_guard3", "targetname", true );

	guard1 thread magic_bullet_shield();
	guard2 thread magic_bullet_shield();
	guard3 thread magic_bullet_shield();

	wait 2.5;

	guard1.baseaccuracy = 1000;
	guard2.baseaccuracy = 1000;
	guard3.baseaccuracy = 1000;
	
	flag_wait( "runners2_dead" );
	
	goal = getent( "runners2_guardsgoal", "targetname" );
	guard1 thread maps\_spawner::go_to_node( goal, 1  );
	guard2 thread maps\_spawner::go_to_node( goal, 1 );
	guard3 thread maps\_spawner::go_to_node( goal, 1 );

	/* wait 10;
	runner1 delete();
	runner2 delete();
	runner3 delete();*/ 
}

drive_garage1()
{
	flag_wait( "drive_garage1" );

	node = getent( "garage1_node", "targetname" );
	civilian = scripted_spawn2( "garage1_civilian", "targetname", true );
	door = getent( "garage1_door", "targetname" );

	// node garage( civilian, door, undefined, 7.5 );
}

drive_garage2()
{
	flag_wait( "drive_garage2" );

	node = getent( "garage2_node", "targetname" );
	civilian = scripted_spawn2( "garage2_civilian", "targetname", true );
	runner = scripted_spawn2( "garage2_runner", "targetname", true );
	door = getent( "garage2_door", "targetname" );

	node garage( civilian, runner, door, 4 );
}

drive_basehinds()
{
	flag_wait( "drive_basehinds" );

	base_hind1 = spawn_vehicle_from_targetname_and_drive( "base_hind1" );
	base_hind2 = spawn_vehicle_from_targetname_and_drive( "base_hind2" );

	base_hind1 sethoverparams( 0, 1, 0.5 );
	base_hind2 sethoverparams( 0, 1, 0.5 );
	
	flag_wait( "basehinds_flyaway" );
	base_hind1 setSpeed( 60, 15 );
	base_hind2 setSpeed( 60, 15 );
}

drive_celebrators2()
{
	flag_wait( "drive_celebrators2" );

	celebrators = scripted_array_spawn( "celebrators2", "targetname", true );
	for ( i = 0; i < celebrators.size; i++ )
	{
		celebrators[ i ].animname = "drone_human";
		celebrators[ i ] thread celebrate();
	}
}

// add a few dogs
drive_casualguards3()
{
	flag_wait( "drive_casualguards3" );

	smokingguards = scripted_array_spawn( "casualguards3_smokingguards", "targetname", true );
	for ( i = 0; i < smokingguards.size; i++ )
	{
		smokingguards[ i ].animname = "drone_human";
		smokingguards[ i ] thread anim_loop_solo( smokingguards[ i ], "leaning_smoking_idle" );
	}

	idleguards = scripted_array_spawn( "casualguards3_idleguards", "targetname", true );
	for ( i = 0; i < idleguards.size; i++ )
		idleguards[ i ].animname = "drone_human";

	// dog = scripted_spawn2( "casualguards1_dog", "targetname", true );
	// dog.animname = "drone_dog";
	// dog thread anim_loop_solo( dog, "sleeping" );
	
	/* wait 20;
	smokingguard delete();
	idleguard delete();
	dog delete();*/ 
}

drive_endcrowd()
{
	flag_wait( "drive_endcrowd" );

	smokingguards = scripted_array_spawn( "endcrowd_smokingguards", "targetname", true );
	for ( i = 0; i < smokingguards.size; i++ )
	{
		smokingguards[ i ].animname = "drone_human";
		smokingguards[ i ] thread anim_loop_solo( smokingguards[ i ], "leaning_smoking_idle" );
	}

	idleguards = scripted_array_spawn( "endcrowd_idleguards", "targetname", true );
	for ( i = 0; i < idleguards.size; i++ )
		idleguards[ i ].animname = "drone_human";

	celebrators = scripted_array_spawn( "endcrowd_celebrators", "targetname", true );
	for ( i = 0; i < celebrators.size; i++ )
	{
		celebrators[ i ].animname = "drone_human";
		celebrators[ i ] removeDroneWeapon();
		celebrators[ i ] thread celebrate();
	}

	dog = scripted_spawn2( "endcrowd_idledog", "targetname", true );
	dog.animname = "drone_dog";
	dog thread anim_single_solo( dog, "idle" );// ? why isn't this looped

	// walkguard1 = scripted_spawn2( "endcrowd_walkguard1", "targetname", true );
	// walkguard1 set_generic_run_anim( "patrol_walk", true );

	// goal = getent( walkguard1.target, "targetname" );
	// walkguard1 thread maps\_spawner::go_to_node( goal, 1  );	
	
	/* wait 20;
	smokingguard delete();
	idleguard delete();
	dog delete();*/ 
}

drive_fastrope1()
{
	flag_wait( "drive_fastrope1" );

	spawn_vehicle_from_targetname_and_drive( "fastrope1_heli" );
}

// guards should play raise weapon anim, wait, then fire
drive_firingsquad()
{
	flag_wait( "drive_firingsquad" );

	captain = scripted_spawn2( "firingsquad_captain", "targetname", true );
	guards = scripted_array_spawn( "guard_firingsquad", "script_noteworthy", true );
}

drive_ziptie5()
{
	flag_wait( "drive_ziptie5" );

	tiedcivilians = scripted_array_spawn( "ziptie5_tiedcivilian", "targetname", true );
	for ( i = 0; i < tiedcivilians.size; i++ )
		thread ziptied( tiedcivilians[ i ], 20 );

	thread ziptie( "ziptie5", undefined, 20 );
	wait 1.2;
	thread ziptie( "ziptie5b", undefined, 20 );
}

setupTarget()
{
	if ( !isdefined( level.aim_count ) )
	{
		level.aim_count = 1;
		thread syncAiming();
	}
	else
		level.aim_count++ ;
	
	civilian = scripted_spawn2( self.target, "targetname", true );
	civilian.animname = "ai_human";
	civilian.dieQuietly = true;
	civilian gun_remove();
	civilian thread anim_loop_solo( civilian, "cowerstand_pointidle" );
	civilian thread dropdead();

	target = getent( civilian.target, "targetname" );
	position = target.origin;

	wait 9;
	wait RandomFloat( 1 );
	node = getnode( self.target, "targetname" );
	self setGoalNode( node );
	self waittill( "goal" );
	level.aim_count -- ;

	flag_wait( "firingsquad_aiming" );

	wait 3;
	wait RandomFloat( .75 );

	for ( i = 0; i < 20; i++ )
	{
		self thread animscripts\utility::shootPosWrapper( position );
		wait 0.1;
	}
}

syncAiming()
{
	while ( level.aim_count )
		wait 0.5;

	flag_set( "firingsquad_aiming" );
	println( "All guards finished aiming" );
}

passengeranim()
{
	// self endon( "passengeranim" );
	
	self waittill( "trigger" );

	anime = "carpassenger_" + self.script_noteworthy;
	level.car notify( "stop_passenger_idle" );
	// println( "Started " + anime + ", idle OFF" );
	level.car anim_single_solo( level.car.passenger, anime, "tag_passenger" );
	// println( "Finished " + anime + ", idle ON" );
	level.car thread anim_loop_solo( level.car.passenger, "carpassenger_idle", "tag_passenger", "stop_passenger_idle" );
}

// make sure the first lookback anim happens properly
drive_passengeranims()
{
	wait 31;
	level.car notify( "stop_passenger_idle" );
	level.car anim_single_solo( level.car.passenger, "carpassenger_lookback", "tag_passenger" );
	level.car thread anim_loop_solo( level.car.passenger, "carpassenger_idle", "tag_passenger", "stop_passenger_idle" );
}

ending_dofchange()
{
	setDOF( 0, 1, 5, 250, 800, 4, 10 );
	// dialogprint( "250, 800 over 10 seconds finished" );
	wait 8;
	// dialogprint( "wait 8 seconds finished" );
	setDOF( 0, 1, 5, 50, 315, 4, 3 );
	// dialogprint( "50, 315 over 3 seconds finished" );
}

/* scene_stoptruck()
{
	wait 6;
	print3d( ( 3825, 515, 114 ), "soldier shouting at driver of this truck", level.green, 1, 1, 7 * 20 );
}

scene_firingaks1()
{
	wait 10;
	print3d( ( 6774, 560, 133 ), "guys jeering and firing AK's into the sky", level.red, 1, 3, 20 * 20 );
}

scene_gatecheckpoint()
{
	node = getvehiclenode( "gate_crossing", "script_noteworthy" );
	level.car setwaitnode( node );
	level.car waittill( "reached_wait_node" );	
	
	level.car setspeed( 0, 15 );
	
	print3d( ( 4531, 842, 148 ), "2 soldiers standing at gated checkpoint", level.yellow, 1, 1, 20 * 20 );
	
	temp_prints( "the guard walks over and has a conversation with the driver", "his dog runs over and starts barking at the window" );
	wait 3;
	temp_prints( "the guard then looks over at you and comes", "over to the back window, pushing his dog away" );
	wait 3;
	temp_prints( "he leans in and spits in your face, ", "then motions over to the other guard to open the gate" );
	wait 3;
	
	level.car resumespeed( 15 );
}

scene_dogsdiggingthroughtrash()
{
	wait 3;
	print3d( ( 4191, 2043, 324 ), "dogs digging through the trash", level.green, 1, 2, 7 * 20 );
}

scene_truckunloading()
{
	node = getvehiclenode( "truck_unloading", "script_noteworthy" );
	level.car setwaitnode( node );
	level.car waittill( "reached_wait_node" );	
	
	level.car setspeed( 0, 15 );	
	
	print3d( ( 3874, 3681, 470 ), "truck blocking the road, unloading troops", level.yellow, 1, 1, 20 * 20 );
	
	temp_prints( "Soldiers unload out of the back of the truck and", "start banging on doors to people homes and bursing in" );
	wait 3;
	temp_prints( "The guy to your left steps out of the", "car yelling at the truck to move it." );
	wait 3;
	temp_prints( "Eventually, the truck pulls off onto the sidewalk" );
	wait 2;
	
	level.car resumespeed( 15 );
}

scene_convoypass()
{
	node = getvehiclenode( "convoy_pass", "script_noteworthy" );
	level.car setwaitnode( node );
	level.car waittill( "reached_wait_node" );	
	
	level.car setspeed( 0, 15 );	
	
	print3d( ( 4236, 5470, 506 ), "convoy passes by to the left", level.green, 1, 1, 15 * 20 );
	
	temp_prints( "jeep pulls up and a guy gets out holding", "out his hand while a convoy passes by" );
	wait 5;
	temp_prints( "if we look back right now, we'll still see", "soldiers banging on peoples doors and dragging some out" );
	wait 5;
	
	level.car resumespeed( 15 );
}

scene_massacre()
{
	wait 5;
	print3d( ( 6596, 6901, 655 ), "a row of dead bodies with blood splattered on the walls", level.red, 1, 2, 5 * 20 );
	temp_prints( "guy to your right flicks his cigarette", "out the window and lights another one" );
}

scene_dogsrunning()
{
	wait 10;
	print3d( ( 6836, 8278, 628 ), "dogs jog by", level.green, 1, 2, 5 * 20 );
}

scene_loadingammo()
{
	wait 14;
	print3d( ( 6796, 9464, 508 ), "guys loading crates into truck", level.yellow, 1, 2, 5 * 20 );
}

scene_firingaks2()
{
	wait 21;
	print3d( ( 3586, 10194, 439 ), "big fire, 20 guys firing AK's into the sky", level.red, 1, 3, 5 * 20 );
}

scene_spraypaint()
{
	wait 25;
	print3d( ( 3766, 12959, 446 ), "guys spray - painting grafiti", level.green, 1, 2, 5 * 20 );
}

scene_cellphone()
{
	wait 29;
	temp_prints( "the guy to your left gets a call on", "his cell phone, and talks for a few." );
	wait 3;
	temp_prints( "He the passes the phone to", "the guy sitting shotgun" );
}

scene_lineup()
{
	wait 33;
	print3d( ( 5741, 15042, 395 ), "line up of civilians, 2 guards walking the line", level.green, 1, 2, 5 * 20 );
}

scene_trashdrop()
{
	wait 40;
	print3d( ( 6479, 17524, 415 ), "burning pile", level.red, 1, 2, 5 * 20 );
	print3d( ( 6451, 17665, 654 ), "tv's, desks, chairs being thrown out the windows", level.yellow, 1, 2, 5 * 20 );
}

scene_paperdrop()
{
	wait 50;
	print3d( ( 532, 17234, 870 ), "burning paper falling", level.yellow, 1, 5, 15 * 20 );
}

scene_heliflyby()
{
	wait 51;
	print3d( ( - 128, 17284, 834 ), "2 heli's fly by", level.green, 1, 5, 5 * 20 );
}

scene_hallway()
{
	temp_prints( "echoing footstep sounds" );
}*/ 

initCredits()
{
	if ( getdvar( "credits" ) == "" )
		setdvar( "credits", "1" );

	if ( getdvar( "credits" ) == "0" )
		return;

	level.namelist = [];
	addName( &"CREDIT_ROGER_ABRAHAMSSON_CAPS" );
	addName( &"CREDIT_MOHAMMAD_ALAVI_CAPS" );
	addName( &"CREDIT_TODD_ALDERMAN_CAPS" );
	addName( &"CREDIT_BRAD_ALLEN_CAPS" );
	addName( &"CREDIT_CHRISSY_ARYA_CAPS" );
	addName( &"CREDIT_RICHARD_BAKER_CAPS" );
	addName( &"CREDIT_CHAD_BARB_CAPS" );
	addName( &"CREDIT_ALESSANDRO_BARTOLUCCI_CAPS" );
	addName( &"CREDIT_KEITH_BELL_CAPS" );
	addName( &"CREDIT_PETE_BLUMEL_CAPS" );
	addName( &"CREDIT_MICHAEL_BOON_CAPS" );
	addName( &"CREDIT_ROBERT_BOWLING_CAPS" );
	addName( &"CREDIT_PETER_CHEN_CAPS" );
	addName( &"CREDIT_CHRIS_CHERUBINI_CAPS" );
	addName( &"CREDIT_GRANT_COLLIER_CAPS" );
	addName( &"CREDIT_JON_DAVIS_CAPS" );
	addName( &"CREDIT_DERRIC_EADY_CAPS" );
	addName( &"CREDIT_JOEL_EMSLIE_CAPS" );
	addName( &"CREDIT_ROBERT_FIELD_CAPS" );
	addName( &"CREDIT_STEVE_FUKUDA_CAPS" );
	addName( &"CREDIT_ROBERT_GAINES_CAPS" );
	addName( &"CREDIT_MARK_GANUS_CAPS" );
	addName( &"CREDIT_FRANCESCO_GIGLIOTTI_CAPS" );
	addName( &"CREDIT_BRIAN_GILMAN_CAPS" );
	addName( &"CREDIT_CHANCE_GLASCO_CAPS" );
	addName( &"CREDIT_PRESTON_GLENN_CAPS" );
	addName( &"CREDIT_JOEL_GOMPERT_CAPS" );
	addName( &"CREDIT_CHAD_GRENIER_CAPS" );
	addName( &"CREDIT_MARK_GRIGSBY_CAPS" );
	addName( &"CREDIT_JOHN_HAGGERTY_CAPS" );
	addName( &"CREDIT_EARL_HAMMON_JR_CAPS" );
	addName( &"CREDIT_JEFF_HEATH_CAPS" );
	addName( &"CREDIT_NEEL_KAR_CAPS" );
	addName( &"CREDIT_JAKE_KEATING_CAPS" );
	addName( &"CREDIT_RICHARD_KRIEGLER_CAPS" );
	addName( &"CREDIT_BRYAN_KUHN_CAPS" );
	addName( &"CREDIT_RYAN_LASTIMOSA_CAPS" );
	addName( &"CREDIT_OSCAR_LOPEZ_CAPS" );
	addName( &"CREDIT_CHENG_LOR_CAPS" );
	addName( &"CREDIT_HERBERT_LOWIS_CAPS" );
	addName( &"CREDIT_JULIAN_LUO_CAPS" );
	addName( &"CREDIT_STEVE_MASSEY_CAPS" );
	addName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
	addName( &"CREDIT_DREW_MCCOY_CAPS" );
	addName( &"CREDIT_BRENT_MCLEOD_CAPS" );
	addName( &"CREDIT_PAUL_MESSERLY_CAPS" );
	addName( &"CREDIT_STEPHEN_MILLER_CAPS" );
	addName( &"CREDIT_TAEHOON_OH_CAPS" );
	addName( &"CREDIT_JAVIER_OJEDA_CAPS" );
	addName( &"CREDIT_SAMI_ONUR_CAPS" );
	addName( &"CREDIT_VELINDA_PELAYO_CAPS" );
	addName( &"CREDIT_ERIC_PIERCE_CAPS" );
	addName( &"CREDIT_JON_PORTER_CAPS" );
	addName( &"CREDIT_ZIED_RIEKE_CAPS" );
	addName( &"CREDIT_LINDA_ROSEMEIER_CAPS" );
	addName( &"CREDIT_ALEX_ROYCEWICZ_CAPS" );
	addName( &"CREDIT_MARK_RUBIN_CAPS" );
	addName( &"CREDIT_EMILY_RULE_CAPS" );
	addName( &"CREDIT_ALEXANDER_SHARRIGAN_CAPS" );
	addName( &"CREDIT_JON_SHIRING_CAPS" );
	addName( &"CREDIT_NATHAN_SILVERS_CAPS" );
	addName( &"CREDIT_GEOFFREY_SMITH_CAPS" );
	addName( &"CREDIT_RICHARD_SMITH_CAPS" );
	addName( &"CREDIT_JIWON_SON_CAPS" );
	addName( &"CREDIT_JIESANG_SONG_CAPS" );
	addName( &"CREDIT_THEERAPOL_SRISUPHAN_CAPS" );
	addName( &"CREDIT_TODD_SUE_CAPS" );
	addName( &"CREDIT_SOMPOOM_TANGCHUPONG_CAPS" );
	addName( &"CREDIT_RAYME_VINSON_CAPS" );
	addName( &"CREDIT_ZACH_VOLKER_CAPS" );
	addName( &"CREDIT_ANDREW_WANG_CAPS" );
	addName( &"CREDIT_JASON_WEST_CAPS" );
	addName( &"CREDIT_LEI_YANG_CAPS" );
	addName( &"CREDIT_VINCE_ZAMPELLA_CAPS" );

	level.namesize = 1.5;
	level.credits = spawnstruct();
	
	page = createPage( "left", 64, 340 );

	page addCredit( level.namelist[ 0 ], "right" );
	page addCredit( level.namelist[ 1 ], "left" );
	page addCredit( level.namelist[ 2 ], "right" );
	level.credits addPage( page );

	page = createPage( "right", -64, 340 );
	page addCredit( level.namelist[ 3 ], "left" );
	page addCredit( level.namelist[ 4 ], "right" );
	page addCredit( level.namelist[ 5 ], "left" );
	level.credits addPage( page );

	page = createPage( "left", 64, 340 );
	page addCredit( level.namelist[ 6 ], "right" );
	page addCredit( level.namelist[ 7 ], "left" );
	page addCredit( level.namelist[ 8 ], "right" );
	level.credits addPage( page );

	page = createPage( "right", -64, 340 );
	page addCredit( level.namelist[ 9 ], "left" );
	page addCredit( level.namelist[ 10 ], "right" );
	page addCredit( level.namelist[ 11 ], "left" );
	level.credits addPage( page );

	page = createPage( "left", 64, 340 );
	page addCredit( level.namelist[ 12 ], "right" );
	page addCredit( level.namelist[ 13 ], "left" );
	page addCredit( level.namelist[ 14 ], "right" );
	level.credits addPage( page );

	page = createPage( "right", -64, 340 );
	page addCredit( level.namelist[ 15 ], "left" );
	page addCredit( level.namelist[ 16 ], "right" );
	page addCredit( level.namelist[ 17 ], "left" );
	level.credits addPage( page );

	page = createPage( "left", 64, 340 );
	page addCredit( level.namelist[ 18 ], "right" );
	page addCredit( level.namelist[ 19 ], "left" );
	page addCredit( level.namelist[ 20 ], "right" );
	level.credits addPage( page );

	page = createPage( "right", -64, 340 );
	page addCredit( level.namelist[ 21 ], "left" );
	page addCredit( level.namelist[ 22 ], "right" );
	page addCredit( level.namelist[ 23 ], "left" );
	level.credits addPage( page );
	
	page = createPage( "left", 64, 340 );
	page addCredit( level.namelist[ 24 ], "right" );
	page addCredit( level.namelist[ 25 ], "left" );
	page addCredit( level.namelist[ 26 ], "right" );
	level.credits addPage( page );

	page = createPage( "right", -64, 340 );
	page addCredit( level.namelist[ 27 ], "left" );
	page addCredit( level.namelist[ 28 ], "right" );
	page addCredit( level.namelist[ 29 ], "left" );
	level.credits addPage( page );
	
	page = createPage( "left", 64, 340 );
	page addCredit( level.namelist[ 30 ], "right" );
	page addCredit( level.namelist[ 31 ], "left" );
	page addCredit( level.namelist[ 32 ], "right" );
	level.credits addPage( page );

	page = createPage( "right", -64, 340 );
	page addCredit( level.namelist[ 33 ], "left" );
	page addCredit( level.namelist[ 34 ], "right" );
	page addCredit( level.namelist[ 35 ], "left" );
	level.credits addPage( page );
	
	page = createPage( "left", 64, 340 );
	page addCredit( level.namelist[ 36 ], "right" );
	page addCredit( level.namelist[ 37 ], "left" );
	page addCredit( level.namelist[ 38 ], "right" );
	level.credits addPage( page );

	page = createPage( "right", -64, 340 );
	page addCredit( level.namelist[ 39 ], "left" );
	page addCredit( level.namelist[ 40 ], "right" );
	page addCredit( level.namelist[ 41 ], "left" );
	level.credits addPage( page );
	
	page = createPage( "left", 64, 340 );
	page addCredit( level.namelist[ 42 ], "right" );
	page addCredit( level.namelist[ 43 ], "left" );
	page addCredit( level.namelist[ 44 ], "right" );
	level.credits addPage( page );

	page = createPage( "right", -64, 340 );
	page addCredit( level.namelist[ 45 ], "left" );
	page addCredit( level.namelist[ 46 ], "right" );
	page addCredit( level.namelist[ 47 ], "left" );
	level.credits addPage( page );
	
	page = createPage( "left", 64, 340 );
	page addCredit( level.namelist[ 48 ], "right" );
	page addCredit( level.namelist[ 49 ], "left" );
	page addCredit( level.namelist[ 50 ], "right" );
	level.credits addPage( page );

	page = createPage( "right", -64, 340 );
	page addCredit( level.namelist[ 51 ], "left" );
	page addCredit( level.namelist[ 52 ], "right" );
	page addCredit( level.namelist[ 53 ], "left" );
	level.credits addPage( page );
	
	page = createPage( "left", 64, 340 );
	page addCredit( level.namelist[ 54 ], "right" );
	page addCredit( level.namelist[ 55 ], "left" );
	page addCredit( level.namelist[ 56 ], "right" );
	level.credits addPage( page );

	page = createPage( "right", -64, 340 );
	page addCredit( level.namelist[ 57 ], "left" );
	page addCredit( level.namelist[ 58 ], "right" );
	page addCredit( level.namelist[ 59 ], "left" );
	level.credits addPage( page );
	
	page = createPage( "left", 64, 340 );
	page addCredit( level.namelist[ 60 ], "right" );
	page addCredit( level.namelist[ 61 ], "left" );
	page addCredit( level.namelist[ 62 ], "right" );
	level.credits addPage( page );

	page = createPage( "right", -64, 340 );
	page addCredit( level.namelist[ 63 ], "left" );
	page addCredit( level.namelist[ 64 ], "right" );
	page addCredit( level.namelist[ 65 ], "left" );
	level.credits addPage( page );
	
	page = createPage( "left", 64, 340 );
	page addCredit( level.namelist[ 66 ], "right" );
	page addCredit( level.namelist[ 67 ], "left" );
	page addCredit( level.namelist[ 68 ], "right" );
	level.credits addPage( page );

	page = createPage( "right", -64, 340 );
	page addCredit( level.namelist[ 69 ], "left" );
	page addCredit( level.namelist[ 70 ], "right" );
	page addCredit( level.namelist[ 71 ], "left" );
	level.credits addPage( page );

	page = createPage( "left", 64, 340 );
	page addCredit( level.namelist[ 72 ], "right" );
	page addCredit( level.namelist[ 73 ], "left" );
	// page addCredit( level.namelist[ 74 ], "right" );
	level.credits addPage( page );
}

addName( name )
{
	precacheString( name );
	level.namelist[ level.namelist.size ] = name;
}

createPage( alignment, x, y )
{
	page = spawnstruct();
	page.alignment = alignment;
	page.x = x;
	page.y = y;	
	
	return page;
}

addPage( page )
{
	if ( !isdefined( self.pages ) )
	{	
		self.pages = [];
		self.pages[ 0 ] = page;
	}
	else
		self.pages[ self.pages.size ] = page;
}

addCredit( name, direction )
{
	if ( !isdefined( self.names ) )
		self.names = [];
	
	credit = spawnstruct();
	credit.name = name;
	credit.direction = direction;
	
	self.names[ self.names.size ] = credit;
}

playCredits()
{
	level endon( "end_credits" );
	
	if ( getdvar( "credits" ) == "" )
		setdvar( "credits", "1" );

	if ( getdvar( "credits" ) == "0" )
		return;
	
	for ( i = 0; i < level.credits.pages.size; i++ )
	{
		displayPage( level.credits.pages[ i ] );
		wait 2;
	}
}

displayPage( page )
{
	names = undefined;
	
	if ( isdefined( page.names ) )
	{
		for ( i = 0; i < page.names.size; i++ )
		{
			pagetime = 4;
			names[ i ] = newHudElem();

			assert( page.alignment == "left" || page.alignment == "right" );
			names[ i ].alignX = page.alignment;
			names[ i ].horzAlign = page.alignment;

			if ( page.alignment == "left" )
				names[ i ].x = page.x + ( i * 46 );
			else if ( page.alignment == "right" )
				names[ i ].x = page.x + ( i * 46 ) - 138;
			
			names[ i ].y = page.y + ( i * 16 );
			names[ i ] setText( page.names[ i ].name );
			names[ i ].font = "objective";
			names[ i ].fontScale = level.namesize;
			names[ i ].sort = 2;
			names[ i ].glowColor = ( 0.7, 0.7, 0.3 );
			names[ i ].glowAlpha = 1;
			names[ i ] SetPulseFX( 60, 5000, 700 );

			if ( page.names[ i ].direction == "left" )
			{
				names[ i ] moveOverTime( 5 );
				names[ i ].x = names[ i ].x - 12;
			}
			else if ( page.names[ i ].direction == "right" )
			{
				names[ i ] moveOverTime( 5 );
				names[ i ].x = names[ i ].x + 12;
			}
			
			wait 0.7;
		}
	}

	wait 5;

	if ( isdefined( names ) )
	{
		for ( i = 0; i < names.size; i++ )
			names[ i ] destroy();	
	}
}

openIntroDoors()
{
	flag_set( "doors_open" );
	thread openIntroLeftDoor();
	thread openIntroRightDoor();
}

openIntroLeftDoor()
{
	intro_leftdoor = getent( "intro_leftdoor", "targetname" );

	time = 1;
	intro_leftdoor rotateyaw( 180, time, ( time * 0.5 ), ( time * 0 ) );
	intro_leftdoor waittill( "rotatedone" );	
	
	time = 1;
	intro_leftdoor rotateyaw( - 60, time, ( time * 0 ), ( time * 1 ) );
}

openIntroRightDoor()
{
	intro_rightdoor = getent( "intro_rightdoor", "targetname" );
	
	time = 1;
	intro_rightdoor rotateyaw( - 180, time, ( time * 0.5 ), ( time * 0 ) );
	intro_rightdoor waittill( "rotatedone" );	

	time = 1;
	intro_rightdoor rotateyaw( 60, time, ( time * 0 ), ( time * 1 ) );
}

// if drones have a weapon other than ak47 this will fail
removeDroneWeapon()
{
	self Detach( "weapon_ak47", "tag_weapon_right" );
}

setWeapon( weapon )
{
	self animscripts\shared::placeWeaponOn( self.weapon, weapon );
}

setTeam( team )
{
	self.team = team;
}

setSightDist( value )
{
	self.maxsightdstsqrd = value;
}

setRandomRun( array )
{
	self set_run_anim( array[ RandomInt( array.size ) ], true );
}

kickdoor( node, door )
{
	self waittillmatch( "single anim", "kick" );
	node thread anim_single_solo( door, "run_in" );
	door playsound( "wood_door_kick" );
}

// fix distance between kick animation and actual door
doorkick( leftguard, rightguard, pausetime, runtoposition )
{
	leftguard.animname = "doorkick_leftguard";
	rightguard.animname = "doorkick_rightguard";

	// rotate the offset for the door positioning to match the angles the scene is placed at
	x = 4;
	y = 16;
	c = cos( self.angles[ 1 ] );
	s = sin( self.angles[ 1 ] );
	new_x = c * x - s * y;
	new_y = s * x + c * y;
	door_originmod = ( new_x, new_y, 0 );
	door_anglesmod = ( 0, -90, 0 );
	
	door_node = spawn( "script_origin", self.origin + door_originmod );
	door_node.angles = self.angles + door_anglesmod;
	door = spawn_anim_model( "door" );
	door.origin = door_node.origin;
	door.angles = door_node.angles;

	door_node thread anim_first_frame_solo( door, "run_in" );
	
	if ( isdefined( runtoposition ) )
	{
		self thread anim_reach_solo( leftguard, "idle_before_step_out" );
		self anim_reach_solo( rightguard, "idle_before_step_out" );
	}
	self thread anim_first_frame_solo( leftguard, "idle_before_step_out" );
	self thread anim_first_frame_solo( rightguard, "idle_before_step_out" );

 	// self thread maps\_debug::drawOrgForever( ( 1, 0, 0 ) );
 	// door_node thread maps\_debug::drawOrgForever( ( 0, 1, 0 ) );
 	// door thread maps\_debug::drawOrgForever( ( 0, 0, 1 ) );

	if ( isdefined( pausetime ) )
		wait pausetime;
	
	leftguard thread kickdoor( door_node, door );
	self thread anim_single_solo( rightguard, "step_out_and_run_in" );
	self anim_single_solo( leftguard, "step_out" );
	self anim_single_solo( leftguard, "run_in" );

	wait 10;
	door delete();
	leftguard delete();
	rightguard delete();
}

// pausetime not used until first frame of animations are in the correct positions
ziptie( instance, pausetime, duration )
{
	node = getent( instance + "_node", "targetname" );
	guard = scripted_spawn2( instance + "_guard", "targetname", true );
	civilian = scripted_spawn2( instance + "_civilian", "targetname", true );

	guard.animname = "ziptie_guard";
	civilian.animname = "ziptie_civilian";

	node thread anim_first_frame_solo( guard, "ziptie_tie" );// needed?
	node thread anim_first_frame_solo( civilian, "ziptie_tie" );// needed?
	
	if ( isdefined( pausetime ) )
		wait pausetime;
		
	node thread anim_single_solo( guard, "ziptie_tie" );
	node thread anim_single_solo( civilian, "ziptie_tie" );

	wait duration;
	if (isalive(guard))
		guard delete();
	if (isalive(civilian))
		civilian delete();
}

ziptied( civilian, duration )
{
	civilian.animname = "drone_human";
	civilian removeDroneWeapon();
	
	node = getent( civilian.target, "targetname" );
	node thread anim_loop_solo( civilian, "ziptie_tie_idle" );
	
	wait duration;
	civilian delete();
}

gunpoint_stand( guard, civilian, duration )
{
	guard.animname = "ai_human";
	civilian.animname = "ai_human";

	guard thread anim_loop_solo( guard, "aim_straight" );
	civilian thread anim_loop_solo( civilian, "cowerstand_pointidle" );

	wait duration;
	guard delete();
	civilian delete();
}

gunpoint_crouch( guard, civilian, duration )
{
	guard.animname = "ai_human";
	civilian.animname = "ai_human";

	guard thread anim_loop_solo( guard, "aim_straight" );
	// civilian thread anim_loop_solo( civilian, "cowercrouch_idle" );
	civilian thread anim_loop_solo( civilian, "cowercrouch_idle" );

	wait duration;
	guard delete();
	civilian delete();
}



garage( operator, runner, door, pausetime )
{
	operator.animname = "drone_human";

	runner.animname = "ai_human";
	runner.disableExits = true;

	runanims[ 0 ] = "run_panicked1";
	runanims[ 1 ] = "run_panicked2";
	runner setRandomRun( runanims );
	
	nodeoffset = AnglesToForward( self.angles ) * - 22;
	self.origin = self.origin + nodeoffset;
	door.origin = door.origin + ( 0, 0, 51.013 );

	self anim_first_frame_solo( operator, "close_garage_a" );// needed?
	self anim_reach_solo( runner, "runinto_garage_right" );
	
	self thread anim_single_solo( operator, "close_garage_a" );
	self thread anim_single_solo( runner, "runinto_garage_right" );
	wait 1;
	
	door linkto( operator, "TAG_WEAPON_CHEST" );
	operator waittillmatch( "single anim", "end" );
	door unlink();
	operator delete();
	runner delete();
}

windowshout( civilian )
{
	civilian.animname = "drone_human";
	civilian removeDroneWeapon();
	civilian thread anim_single_solo( civilian, "window_shout_a" );

	wait 20;
	civilian delete();
}

leaningguard( guard )
{
	guard.animname = "leaning_guard";

	// loop
	guard thread anim_loop_solo( guard, "leaning_smoking_idle" );
	// guard thread anim_single_solo( guard, "window_shout_a" );

	wait 20;
	guard delete();
}

attackside( attacker, enemy )
{
	node = spawn( "script_origin", self.origin );
	node.angles = self.angles;	

	attacker.animname = "ai_human";
	self.animname = "ai_human";
	attacker.favoriteenemy = self;

	// node anim_reach_solo( attacker, "attack_side" );
	node thread anim_single_solo( attacker, "sneakattack_attack_side" );	
	node thread anim_single_solo( self, "sneakattack_defend_side" );	

	// temp, if this gets used elsewhere this should be reorganized
	enemy.ignoreme = true;
	attacker.ignoreall = false;

	wait 20;
	attacker delete();
}

attackbehind( attacker, enemy )
{
	node = spawn( "script_origin", self.origin );
	node.angles = self.angles;	

	attacker.animname = "ai_human";
	self.animname = "ai_human";
	attacker.favoriteenemy = self;

	node anim_reach_solo( attacker, "sneakattack_attack_behind" );
	node thread anim_single_solo( attacker, "sneakattack_attack_behind" );	
	node thread anim_single_solo( self, "sneakattack_defend_behind" );	

	// temp, if this gets used elsewhere this should be reorganized
	enemy.ignoreme = true;
	attacker.ignoreall = false;

	wait 20;
	attacker delete();
}

// modify pitch so he doesn't lean over so much
// fix origin jump on each cycle
// start anim at random position to keep them out of sync
// offset character floating until fixed
celebrate()
{
	self endon( "death" );
	
	celebrateanims[ 0 ] = "window_shout_a";
	// celebrateanims[ 1 ] = "window_shout_b";// looks too window specfic
	celebrateanim = celebrateanims[ RandomInt( celebrateanims.size ) ];

	self.angles += ( - 20, 0, 0 );
 	// self thread maps\_debug::drawOrgForever( ( 1, 1, 1 ) );

	original_position = self.origin + ( 0, 0, -10 );// temp offset until animation doesn't float

	anime = self getanim( celebrateanim );
	starttime = RandomFloatRange( 0, 1.0 );

	self thread DelaySetAnimTime( anime, starttime, 0.05 );
	self anim_single_solo( self, celebrateanim );
	
	for ( ;; )
	{	
		self.origin = original_position;
		self anim_single_solo( self, celebrateanim );
	}
}

DelaySetAnimTime( anime, starttime, delay )
{
	wait delay;
	self SetAnimTime( anime, starttime );
}

music()
{
	flag_wait( "doors_open" );

	musicPlay( "music_coup_intro" ); 

	wait 152;// temp to get music to play for the correct length until it is replaced.
	musicstop();
	musicPlay( "music_coup_intro" ); 
}

