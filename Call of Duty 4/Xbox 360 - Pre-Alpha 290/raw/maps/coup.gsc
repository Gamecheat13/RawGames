// fix credits timing
// rework credit positioning so each names have centered alignment, but are shifted offset from each other
// the 2nd name receives no shifting( it's position is relative to screen edges and the other names are relative to it ), with this arrangment, left and right positions work identically, and more positions can easily be added
// finish breathing sounds when hit

// change end sequence so the AI are spawned in
// drive start causes script error
// title screen video isn't playing
// reflection probes are making some areas super bright
// fix overlapping sequence at the end

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

	default_start( ::startIntro );
	add_start( "drive", ::startDrive );
	add_start( "alley", ::startAlley );
	add_start( "shore", ::startShore );
	add_start( "ending", ::startEnding );

	maps\_luxurysedan::main( "vehicle_luxurysedan_viewmodel" );
	maps\_hind::main( "vehicle_mi24p_hind_desert" );
 	maps\_mig29::main( "vehicle_mig29_desert" );
 	array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ), maps\_mig29::plane_sound_node );
	
	maps\coup_fx::main();
	maps\createart\coup_art::main();
	// thread initDOF();
	maps\_load::main();
	maps\createfx\coup_audio::main();
	maps\coup_anim::main();
	thread maps\coup_amb::main();
	deleteai_triggers();

	flag_init( "drive" );
	flag_init( "doors_open" );
	
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player takeAllWeapons();
	level.player.ignoreme = true;

	if ( getdvar( "car" ) == "scripted" )
		level.car = spawn_vehicle_from_targetname( "car" );
	else
		level.car = spawn_anim_model( "car" );

	wait 0.05;// can't set dvars on the first frame
	setsaveddvar( "compass", 0 );
	setSavedDvar( "ammoCounterHide", "1" );	
	// setsaveddvar( "cg_fov", 50 );
}

startIntro()
{
	thread intro_doors();
	thread initCredits();
	
	thread execIntro();
}

startDrive()
{
	thread execDrive();
	
	flag_set( "drive" );
}

startAlley()
{
	start_alley = getent( "start_alley", "targetname" );
	
	level.player setOrigin( start_alley.origin );
	level.player setPlayerAngles( start_alley.angles );

	// thread execAlley();
}

startShore()
{
	start_shore = getent( "start_shore", "targetname" );
	
	level.player setOrigin( start_shore.origin );
	level.player setPlayerAngles( start_shore.angles );

	thread base_hinds();
}

startEnding()
{
	ending_node = getent( "ending_node", "targetname" );
	
	level.player setOrigin( ending_node.origin );
	level.player setPlayerAngles( ending_node.angles );
	
	thread execEnding();
}

execIntro()
{
	thread execDrive();
	delaythread( 0.5, ::openIntroDoors );
	delaythread( 2, ::intro_speech );
	delaythread( 5, ::intro_birds );
	delaythread( 5, ::playCredits );

	intro_node = getent( "intro_node", "targetname" );
	intro_leftguard = getent( "intro_leftguard", "targetname" );
	intro_rightguard = getent( "intro_rightguard", "targetname" );

	intro_rightguard.animname = "intro_rightguard";
	intro_leftguard.animname = "intro_leftguard";
	level.car.animname = "car";

	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	level.car.playerview = playerview;
	intro_node anim_first_frame_solo( playerview, "coup_opening" );
	level.player playerlinkto( playerview, "tag_player", 1, 45, 45, 30, 30 );

	intro_actors[ 0 ] = intro_leftguard;
	intro_actors[ 1 ] = intro_rightguard;
	intro_actors[ 2 ] = playerview;
	intro_actors[ 3 ] = level.car;
	
	intro_node anim_single( intro_actors, "coup_opening" );
	
	wait 9;
	flag_set( "drive" );
}

execDrive()
{
	// show car tags
	// level.car thread maps\_debug::drawTagForever( "tag_driver" );
	// level.car thread maps\_debug::drawTagForever( "tag_passenger" );
	// level.car thread maps\_debug::drawTagForever( "tag_guy0" );
	// level.car thread maps\_debug::drawTagForever( "tag_guy1" );

	car_driver = getent( "car_driver", "targetname" );
	car_shotgun = getent( "car_shotgun", "targetname" );

	car_driver.animname = "car_driver";
	car_shotgun.animname = "car_shotgun";

	car_driver linkto( level.car, "tag_driver" );
	car_shotgun linkto( level.car, "tag_passenger" );
	
	level.car thread anim_loop_solo( car_driver, "car_idle", "tag_driver", "stop_idle" );
	level.car thread anim_loop_solo( car_shotgun, "car_idle", "tag_passenger", "stop_idle" );

	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	level.car anim_first_frame_solo( playerview, "car_idle_firstframe", "tag_guy1" );
	playerview linkto( level.car, "tag_guy1" );

	flag_wait( "drive" );

	level.player playerlinktodelta( playerview, "tag_player", 1, 90, 90, 30, 30 );

	level.car thread anim_loop_solo( playerview, "car_idle", "tag_guy1", "stop_idle" );

	if ( getdvar( "car" ) == "scripted" )
	{
		thread gopath( level.car );
		level.car setspeed( 15, 3 );
		level.car waittill( "reached_end_node" );
	}
	else
	{
		drive_node = getent( "intro_node", "targetname" );
		drive_node anim_single_solo( level.car, "coup_car_driving" );
	}

	thread temp_transition();
	//thread execEnding();
}

execEnding()
{
	level notify( "end_credits" );
    thread ending_dofchange();

	setsaveddvar( "cg_fov", 50 );
	musicstop( 5 );
	
	scripted_array_spawn( "ending_spawner", "script_noteworthy", true );

	ending_node = getent( "ending_node", "targetname" );
	
	// ending_alasad = getent( "ending_alasad", "targetname" );
	// ending_zakhaev = getent( "ending_zakhaev", "targetname" );
	// ending_leftguard = getent( "ending_leftguard", "targetname" );
	// ending_rightguard = getent( "ending_rightguard", "targetname" );
	ending_alasad = scripted_spawn2( "ending_alasad", "targetname", true );
	ending_zakhaev = scripted_spawn2( "ending_zakhaev", "targetname", true );
	ending_leftguard = scripted_spawn2( "ending_leftguard", "targetname", true );
	ending_rightguard = scripted_spawn2( "ending_rightguard", "targetname", true );

	ending_alasad.animname = "ending_alasad";
	ending_zakhaev.animname = "ending_zakhaev";
	ending_leftguard.animname = "ending_leftguard";
	ending_rightguard.animname = "ending_rightguard";

	// Remove ak47s
	ending_alasad animscripts\shared::placeWeaponOn( ending_alasad.weapon, "none" );
	ending_zakhaev animscripts\shared::placeWeaponOn( ending_zakhaev.weapon, "none" );
	ending_zakhaev attach( "weapon_desert_eagle_silver_HR_promo", "tag_inhand" );
	
	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	ending_node anim_first_frame_solo( playerview, "coup_ending" );
	level.player playerlinkto( playerview, "tag_player", 1, 45, 45, 30, 30 );

	ending_actors[ 0 ] = playerview;
	ending_actors[ 1 ] = ending_leftguard;
	ending_actors[ 2 ] = ending_rightguard;
	ending_actors[ 3 ] = ending_alasad;
	ending_actors[ 4 ] = ending_zakhaev;

	ending_node thread anim_single( ending_actors, "coup_ending" );

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
	
	VisionSetNaked( "coup_sunblind" );
	
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
	overlay.sort = 2;
	overlay.foreground = true;
	
	flag_wait( "doors_open" );

	musicPlay( "music_coup_intro" ); 
	VisionSetNaked( "coup", 12 );
	
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

shore_jets()
{

}

shore_helicopters()
{

}

base_hinds()
{
	trigger = getent( "base_hinds", "targetname" );
	trigger waittill( "trigger" );	

	base_hind1 = spawn_vehicle_from_targetname_and_drive( "base_hind1" );
	base_hind2 = spawn_vehicle_from_targetname_and_drive( "base_hind2" );

	base_hind1 sethoverparams( 0, 1, 0.5 );
	base_hind2 sethoverparams( 0, 1, 0.5 );
}

ending_dofchange()
{
	thread initDOF();

	setDOF( 0, 1, 5, 500, 2000, 4 );// initial DOF setting
	
	setDOF( 0, 1, 5, 250, 800, 4, 10 );
	// dialogprint( "250, 800 over 10 seconds finished" );
	wait 8;
	// dialogprint( "wait 8 seconds finished" );
	setDOF( 0, 1, 5, 50, 315, 4, 3 );
	// dialogprint( "50, 315 over 3 seconds finished" );
}

#using_animtree( "generic_human" );
 /* scene_player_drag2()
{
	rig = create_drag_rig();
	level.villians[ "shotgun" ] unlink();
	level.villians[ "right" ] unlink();
	level.villians[ "shotgun" ].testnode notify( "stop_loop" );
	level.villians[ "right" ].testnode notify( "stop_loop" );
	level.villians[ "shotgun" ] linkto( rig );
	level.villians[ "right" ] linkto( rig );
	
	rig.origin += ( 0, 0, -64 );
	
	rig thread anim_loop_solo( level.villians[ "shotgun" ], "drag_loop", "tag_origin", "stop_drag" );
	rig thread anim_loop_solo( level.villians[ "right" ], "drag_loop", "tag_origin", "stop_drag" );
	rig thread anim_loop_solo( rig, "drag_loop", "tag_origin", "stop_drag" );
	level.player playerlinktodelta( rig.camera, "tag_origin", 1, 50, 60, 25, 30 );
	
	link = spawn( "script_origin", rig.origin );
	link.angles = rig.angles;
	rig linkto( link );
	
	link tempmove( "fudgemove" );
	level.villians[ "shotgun" ] stop_magic_bullet_shield();
	level.villians[ "right" ] stop_magic_bullet_shield();
	level.villians[ "shotgun" ] delete();
	level.villians[ "right" ] delete();
	link rotateyaw( 180, 1 );
} */ 

 /* test_riders()
{	
	keys = getArrayKeys( level.villians );
	
	for ( i = 0; i < keys.size; i ++ )
	{
		level.villians[ keys[ i ] ].testnode = spawn( "script_model", self.origin );
		level.villians[ keys[ i ] ].testnode.angles = self.angles;
		level.villians[ keys[ i ] ].testnode setmodel( "tag_origin" );
		level.villians[ keys[ i ] ] linkto( level.villians[ keys[ i ] ].testnode );
	}
	
	level.villians[ "driver" ].testnode 	linkto( self, "Trim_Char_F_1_1", ( - 97, -72, 23 ), ( 0, 0, 0 ) );
	level.villians[ "shotgun" ].testnode 	linkto( self, "Trim_Char_F_1_1", ( - 97, -108, 23 ), ( 0, 0, 0 ) );
	level.villians[ "left" ].testnode 	linkto( self, "Trim_Char_F_1_1", ( - 131, -70, 23 ), ( 0, 0, 0 ) );
	level.villians[ "right" ].testnode 	linkto( self, "Trim_Char_F_1_1", ( - 131, -110, 23 ), ( 0, 0, 0 ) );
	
	for ( i = 0; i < keys.size; i ++ )
		level.villians[ keys[ i ] ].testnode thread anim_loop_solo( level.villians[ keys[ i ] ], "car_idle", "tag_origin", "stop_loop" );
} */ 

scene_stoptruck()
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
	 /* node = getvehiclenode( "gate_crossing", "script_noteworthy" );
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
	
	level.car resumespeed( 15 ); */ 
}

scene_dogsdiggingthroughtrash()
{
	wait 3;
	print3d( ( 4191, 2043, 324 ), "dogs digging through the trash", level.green, 1, 2, 7 * 20 );
}

scene_truckunloading()
{
	 /* node = getvehiclenode( "truck_unloading", "script_noteworthy" );
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
	
	level.car resumespeed( 15 ); */ 
}

scene_convoypass()
{
	 /* node = getvehiclenode( "convoy_pass", "script_noteworthy" );
	level.car setwaitnode( node );
	level.car waittill( "reached_wait_node" );	
	
	level.car setspeed( 0, 15 );	
	
	print3d( ( 4236, 5470, 506 ), "convoy passes by to the left", level.green, 1, 1, 15 * 20 );
	
	temp_prints( "jeep pulls up and a guy gets out holding", "out his hand while a convoy passes by" );
	wait 5;
	temp_prints( "if we look back right now, we'll still see", "soldiers banging on peoples doors and dragging some out" );
	wait 5;
	
	level.car resumespeed( 15 ); */ 
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

scene_waves()
{
	wait 60;
	print3d( ( - 721, 17302, 361 ), "huge waves crash", level.yellow, 1, 3, 5 * 20 );
}

scene_migflyby()
{
	wait 63;
	print3d( ( - 1113, 13085, 1403 ), "2 mig's fly by", level.green, 1, 5, 5 * 20 );
}

scene_helitouchdown()
{
	wait 70;
	print3d( ( - 5680, 14408, 926 ), "large heli lands", level.green, 1, 5, 5 * 20 );
}

scene_trip()
{
	wait 86;
	print3d( ( - 3520, 9009, 475 ), "guards line the walls", level.yellow, 1, 1, 5 * 20 );
	wait 3;
	temp_prints( "you get shoved to the ground and roll up", "then get a swift boot to the face. everyone laughs" );
}

scene_torture()
{
	trigger = getent( "scene_torture", "targetname" );
	trigger waittill( "trigger" );	
	temp_prints( "The walls are lined with tiny barred windows", "Sounds of people getting beat up, tortured, ", "and whimpering in pain" );
}

scene_stairs()
{
	trigger = getent( "scene_stairs", "targetname" );
	trigger waittill( "trigger" );
	print3d( ( - 5597, 8872, 548 ), "smoking guard, waves to you", level.green, 1, 1, 5 * 20 );
	print3d( ( - 5890, 8927, 448 ), "2 guard talking", level.yellow, 1, 1, 5 * 20 );
}

scene_hallway()
{
	trigger = getent( "scene_hallway", "targetname" );
	trigger waittill( "trigger" );
	temp_prints( "echoing footstep sounds" );
}

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
	//page addCredit( level.namelist[ 73 ], "left" );
	//page addCredit( level.namelist[ 74 ], "right" );
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
	level endon("end_credits");
	
	if ( getdvar( "credits" ) == "" )
		setdvar( "credits", "1" );

	if ( getdvar( "credits" ) == "0" )
		return;
	
	for ( i = 0; i < level.credits.pages.size; i ++ )
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
		for ( i = 0; i < page.names.size; i ++ )
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
			names[ i ].sort = 1;
			names[ i ].glowColor = ( 0.7, 0.7, 0.3 );
			names[ i ].glowAlpha = 1;
			// names[ i ] SetPulseFX( 60, 3000, 700 );
			// names[ i ] SetPulseFX( 60, 4000, 700 );
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
			
			// thread fadeout( names[ i ] );
			
			// wait 0.25;
			wait 0.7;
		}
	}

	wait 5;

	if ( isdefined( names ) )
	{
		for ( i = 0; i < names.size; i ++ )
			names[ i ] destroy();	
	}
}

fadeout( elem )
{
	wait 3;
	elem fadeOverTime( 2 );
	elem.alpha = 0;
}

blackout()
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	overlay.sort = 2;
	
	overlay fadeinBlackOut( 2, 1, 6 );
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

 /* playScenes()
{
	level.red = ( 1, 0, 0 );
	level.blue = ( 0, 0, 1 );
	level.green = ( 0, 1, 0 );
	level.yellow = ( 1, 1, 0 );
	
	if ( 1 )
		return;

	thread scene_stoptruck();
	thread scene_firingaks1();
	scene_gatecheckpoint();
	thread scene_dogsdiggingthroughtrash();
	scene_truckunloading();
	scene_convoypass();
	thread scene_massacre();
	thread scene_dogsrunning();
	thread scene_loadingammo();
	thread scene_firingaks2();
	thread scene_spraypaint();
	thread scene_cellphone();
	thread scene_lineup();
	thread scene_trashdrop();
	thread scene_paperdrop();
	thread scene_heliflyby();
	thread scene_waves();
	thread scene_migflyby();
	thread scene_helitouchdown();
	thread scene_trip();
	scene_torture();
	scene_stairs();
	scene_hallway();
	scene_execution();
	scene_lastwords();
} */ 

temp_transition()
{
	// temp transition from car
	level.trans_overlay = newHudElem();
	level.trans_overlay.x = 0;
	level.trans_overlay.y = 0;
	level.trans_overlay setshader( "black", 640, 480 );
	level.trans_overlay.alignX = "left";
	level.trans_overlay.alignY = "top";
	level.trans_overlay.horzAlign = "fullscreen";
	level.trans_overlay.vertAlign = "fullscreen";
	level.trans_overlay.alpha = 0;
	level.trans_overlay.sort = 3;

	level.trans_overlay fadeOverTime( 5 );
	level.trans_overlay.alpha = 1;
	wait 5;

	thread execEnding();
	
	level.trans_overlay fadeOverTime( 5 );
	level.trans_overlay.alpha = 0;
	wait 5;

	level.trans_overlay destroy();
}