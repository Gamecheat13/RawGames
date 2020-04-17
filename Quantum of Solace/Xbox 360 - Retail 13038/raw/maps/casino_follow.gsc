#include maps\_utility;
#include maps\_bossfight;
#include common_scripts\utility;

//
//	Montenegro Casino : Follow Le Chiffre  Floor 4
//
//	Events	
//			1 - See Le Chiffre get abducted
//			2 - Go out on the ledge outside and into the suite
//			3 - Get into the spa area
//			4 - Move around ledges outside
//			5 - Maneuver through the suite
//			6 - Suprised in conference room
//
//############################################################################
/*
Notes for Dave Chartier
Here is the basic format for the stuff you can do in script.  You have full access
to DoF and FoV.  You just need to use different functions:

// You need to use this function the very first time you want to do something with the camera.
//	After that, use the "change" function.
cameraID = customCamera_push(
cameraType,		// <required string, see camera types below>
originEntity,	// <required only by "entity" and "entity_abs" cameras>
trackEntity,	// <optional entity to look at/track>
offset,			// <optional positional vector offset, default (0,0,0)>
angles,			// <optional angle vector offset, default (0,0,0)>
trackOffset,	// <optional relative positional vector offset from tracked entity, default (0,0,0)>
lerpTime,		// <optional time to 'tween/lerp' to the camera, default 0.5>
lerpAccelTime,	// <optional time used to accel/'ease in', default 1/2 lerpTime> 
lerpDecelTime	// <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
);


// Use this anytime you want to move or change the behavior of the camera.
customCamera_change(
cameraID,		// <required ID returned from customCameraPush>
cameraType,		// <required string, see camera types below>
originEntity,	// <required only by "entity" and "entity_abs" cameras>
trackEntity,	// <optional entity to look at>
offset,			// <optional positional vector offset, default (0,0,0)>
angles,			// <optional angle vector offset, default (0,0,0)>
trackOffset,	// <optional relative positional vector offset from tracked entity, default (0,0,0)>
lerpTime,		// <optional time to 'tween/lerp' to the camera, default 0.5>
lerpAccelTime,	// <optional time used to accel/'ease in', default 1/2 lerpTime> 
lerpDecelTime	// <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
);


// This needs to be called to return to the normal camera.  I should already have these set up
//	for each scene, but you might want to change the lerp times.
customCamera_pop(
cameraID,		// <required ID returned from customCameraPush>
lerpTime,		// <optional time to 'tween/lerp' to the previous camera, default prev camera>
lerpAccelTime,	// <optional time used to accel/'ease in', default prev camera> 
lerpDecelTime	// <optional time used to decel/'ease out', default prev camera>
);


// This is how to change the Depth of Field.  
//	Setting all the 'near' and 'far' params to '0' (or passing in the ID only) will revert to the standard/level DoF. 
customCamera_setDoF(
cameraID,		// <required ID returned from customCameraPush>
dofNearStart,	// <required Before this distance, near depth of field is maximally blurry>
dofNearEnd,		// <required After this distance, near depth of field is perfectly in focus>
dofFarStart,	// <required Before this distance, far depth of field is perfectly in focus>
dofFarEnd,		// <required After this distance, far depth of field is maximally blurry>
dofNearBlur,	// <required Maximal blur radius for near depth of field (must be > 3.0)>
dofFarBlur,		// <required Maximal blur radius for far depth of field>
lerpTime,		// <optional time to 'tween/lerp' to the camera, default same as camera>
lerpAccelTime,	// <optional time used to accel/'ease in', default same as camera> 
lerpDecelTime 	// <optional time used to decel/'ease out', default same as camera>
);


//	To change Field of View, use this:  
//	Setting it to '0' (or passing in the ID only) will revert to the standard/level FoV.
customCamera_setFoV(
cameraID,		// <required ID returned from customCameraPush>
fov,			// <required the fov (in degrees) of the camera>
lerpTime,		// <optional time to 'tween/lerp' to the camera, default same as camera>
lerpAccelTime,	// <optional time used to accel/'ease in', default same as camera> 
lerpDecelTime	// <optional time used to decel/'ease out', default same as camera>
);
*/

//############################################################################
//	e1_main - All ai and events for the floor 4 hallway
//
e1_main()
{
	thread challenge_achievement();
	level thread disable_compass();
	//	level thread change_fog();
	if ( level.play_cutscenes )
	{
		level thread e1_igc();
	}
	else
	{
		balc_guy = maps\casino_util::spawn_guys( "cai_e1_balcony", true, "e1_ai", "thug" );
		balc_guy SetIgnoreThreatType("corpse", true);

		maps\casino_util::reinforcement_update( "cai_e1_reinforcements", "e1_ai", false );

		patroller = maps\casino_util::spawn_guys( "cai_e1", true, "e1_ai", "thug" );
		// SOUND: Jerry added this, so guy will hear floor creak.
		level.patroller_ears = patroller;
		level thread maps\casino_amb::thug_ears_1();
	}
	level thread maps\casino_util::driveway_vehicles( "e3_start" );

	// SOUND: shut off aiChat so the dead guy doesn't grunt as level starts
	SetSavedDVar( "ai_ChatEnable", "0" );

	// Setup the secondary camera now or we will crash
	//level thread maps\casino_pip::intro_pip();
	level thread maps\casino_pip::ledge();

	// Dead guy

	mr_body = maps\casino_util::spawn_guys( "cai_e1_body", true, "e1_ai", "civ" );
	mr_body DoDamage( mr_body.health + 1, mr_body.origin);
	mr_body StartRagDoll();
	//physicsJolt( mr_body.origin, 50, 0, (0.0, 0.7, 0.0) );
	wait 4;

	// SOUND: turn aiChat back on
	SetSavedDVar( "ai_ChatEnable", "1" );

	//dim the light =p
	elight = GetEntArray( "light_e1_elev", "targetname" );
	for ( i=0; i<elight.size; i++ )
	{
		elight[i] setlightintensity( 0.5 );
	}

	if ( level.play_cutscenes )
	{
		level waittill("e1_igc_finished");
	}
	wait( 1.0 );

	// Guys in conference room
	talker_thugs = maps\casino_util::spawn_guys_ordinal( "cai_e1_talker", 0, true, "e1_ai", "thug" );
	array_thread(talker_thugs, ::talker_thug);
	level.thug_tv_ears = talker_thugs[1];
	flag_set( "obj_start");

	level thread e1_conversation( talker_thugs );
	light = GetEnt( "light_e1_tv", "targetname" );
	light thread e1_tv_flicker();

	//wait( 2.0 );	// delay wait until stinger is done playing - dont need -jc
	//start music outside of elevator
	trig = GetEnt("e1_outside_elevator", "targetname" );
	trig waittill( "trigger" );
	level notify( "playmusicpackage_start" );

	//	thread e1_lookat_balcony();
	trig = GetEnt("ctrig_e1_balcony", "targetname" );
	trig waittill( "trigger" );

	//	SetExpFog(“fog near plane”, “fog half plane”, “fog red”, “fog green”, “fog blue”, “Lerp time”, “Fog max”);
//	setExpFog( 5700, 26117, 0.36, 0.414, 0.555, 0.711, 2.0);

	flag_set( "obj_detour_start");	//temp till re-bsp

	trig delete();
	maps\casino_util::reinforcement_update( "", "", false );
	level notify("fx_aircraft_flyby");		// Di Plane!  Di Plane!

	// E2 handoff
	trig = GetEnt("ctrig_e2_outer_suite", "targetname" );
	trig waittill( "trigger" );


	level thread e1_withdrawl();
	level thread e2_main();

	//savegame on ledge - jc
	//fixed bug where AI was engaged, then on restart, the player is stuck being killed - mm
	level.special_autosavecondition = maps\casino_util::check_no_enemies_alerted;
	//iprintlnbold("try autosave now");
	level thread maps\_autosave::autosave_by_name( "e1", 5.0 );

	// save again after ledge - AlexP
	trig = GetEnt( "ctrig_e2_balcony", "targetname" );
	trig waittill( "trigger" );

	//iprintlnbold("try autosave again");
	level thread maps\_autosave::autosave_by_name( "e1", 5.0 );

	// cleanup
	trig = GetEnt( "ctrig_e2_suite", "targetname" );
	trig waittill( "trigger" );

	// clear special savegame check
	level.special_autosavecondition = undefined;

	level waittill( "e3_start" );

	maps\casino_util::delete_group( "e1_ai" );
}

talker_thug()
{
	self SetIgnoreThreatType("corpse", true);

	if (IsDefined(self.script_noteworthy) && (self.script_noteworthy == "typer"))
	{
		self maps\_utility::gun_remove();
		self waittill("alert_yellow");
		self maps\_utility::gun_recall();
	}
}

//############################################################################
// This is the intro IGC
//	Watch Le Chiffre escorted through the hallway
e1_igc( )
{
	//	setSavedDvar( "cg_drawHUD", "0" );
	door_left  = GetEnt( "csbm_e_door_left",  "targetname" );
	door_right = GetEnt( "csbm_e_door_right", "targetname" );
	//door_left  MoveY( -52, 0.01, 0.1, 0.7 );
	//door_right MoveY(  52, 0.01, 0.1, 0.7 );

	// jl, 04/22
	// I spent some time yesterday playing with the cutscene and different ways to do it. We need a fade on the cutscene itself.
	door_left  MoveY( -52, 1, 0.1, 0.7 );
	door_right MoveY(  52, 1, 0.1, 0.7 );
	// jl 04/22

	//screen black
	level.hud_black.alpha = 1;	

	// Force the center dot off screen
	wait(0.1);
	setDvar( "cg_disableHudElements", 1 );
	level thread letterbox_on( false, true, undefined, false );

	// Stop right there
	level.player freezecontrols(true);	// Need To Call Freeze Controls Because I Need To Unstick The Player In Order To Call Force Cover
	wait( 1 ); 

	level.player playersetforcecover( true, (1,0,0) );

	wait( 2 );

	//patroller = maps\casino_util::spawn_guys( "cai_e1", true, "e1_ai", "thug" );
	balc_guy = maps\casino_util::spawn_guys( "cai_e1_balcony", true, "e1_ai", "thug" );
	balc_guy SetIgnoreThreatType("corpse", true);

	maps\casino_util::reinforcement_update( "cai_e1_reinforcements", "e1_ai", false );

	//	// Spawn the actors for the scene
	//	thugs		= maps\casino_util::spawn_guys_ordinal( "cai_e1_escort_", 0,	true, "e1_ai_igc", "thug" );
	//	lechiffre	= maps\casino_util::spawn_guys( "cai_e1_lechiffre",	true, "e1_ai_igc", "civ" );
	//	thugs[0].targetname		= "thug1";
	//	thugs[1].targetname		= "thug3";
	//	thugs[2].targetname		= "thug4";
	//	lechiffre.targetname	= "lechiffre";
	//	wait( 1.05 );

	//wait( 2.0 );


	// fade up
	level.hud_black fadeOverTime(5);
	level.hud_black.alpha = 0;

	level thread display_chyron();

	//stop elevator moving
	//elevator_moving_stop()
	level thread maps\casino_amb::elevator_moving_stop();

	//playsound ding
	door_left	playsound ("CAS_elevator_bell");
	wait(1);


	//	// Spawn the actors for the scene
	thugs		= maps\casino_util::spawn_guys_ordinal( "cai_e1_escort_", 0,	true, "e1_ai_igc", "thug", undefined, 0.2 );
	lechiffre	= maps\casino_util::spawn_guys( "cai_e1_lechiffre",	true, "e1_ai_igc", "civ" );
	thugs[0].targetname		= "thug1";
	thugs[1].targetname		= "thug3";
	thugs[2].targetname		= "thug4";
	lechiffre.targetname	= "lechiffre";

	//SEE DOORS OPEN - JC
	door_left  MoveY(  47, 2.0, 0.1, 0.7 );
	door_right MoveY( -47, 2.0, 0.1, 0.7 );
	door_left	playsound ("CAS_elevator_doors_open");

	//use pip on main window
	//	SetDVar("r_pipMainMode", "1");
	//	SetDVar("r_pip1Scale", "1 1 0 0");
	//	SetDVar("r_pip1Anchor", 4);						// use center anchor point
	//
	//	//scale
	//	level.player animatepip( 500, 1, -1,-1, 1, 0.7 );

	//level thread letterbox_on( false, true, undefined, false );

	SetDVar("ai_randomValue", 0); // force variant 1 for AI walk animations

	wait(2);	//pause to hold on bond before moving camera

	//turn off camera collision
	level.player customcamera_checkcollisions( 0 );

	//custom camera - push in on lechiffre
	elevator_cam = level.player customCamera_Push( "world", ( -680, 887, 760), (0,0,0) , 5.0);
	wait(1);	//start camera before dialog

	lechiffre play_dialogue( "LECH_CasiG01A_002A" );	// This is a waste of time.  I have no intention of cheating Mr. Obanno.

	SetDVar("ai_randomValue", -0.1); // negative value means random

	PlayCutscene("LeChiffre", "cutscene_done" );
	SetDVar("cg_pip_buffering","0");

	level thread intro_cutscene_dialog( thugs );

	level.player customCamera_pop( elevator_cam, 0.1 );

	// jl
	//	wait( 1.5);
	level waittill( "cutscene_done" );

	maps\casino_util::delete_group( "e1_ai_igc" );	// Get rid of the actors

	//turn on camera collision
	level.player customcamera_checkcollisions( 1 );

	
	//thugs[2] waittillmatch("anim_notetrack", "sndnt#OBG2_CasiG_001A");
	//thugs[2] play_dialogue( "OBG1_CasiG01A_001A", true );		// Move!
	//lechiffre maps\casino_util::play_dialog( "LECH_CasiG01A_002A" );	// This is a waste of time.  I have no intention of cheating Mr. Obanno.
	//thugs[2] maps\casino_util::play_dialog( "OBG2_CasiG01A_003A" );		// You can tell him yourself.
	//thugs[2] play_dialogue( "OBG2_CasiG01A_003A", true );		// You can tell him yourself.
	//thugs[2] play_dialogue( "OBG1_CasiG01A_001A", true );		// Move!
	//thugs[2] waittillmatch("anim_notetrack", "sndnt#OBG1_CasiG_003A");
	//thugs[2] play_dialogue( "OBG2_CasiG01A_003A", true );		//You can tell him yourself.

	patroller = maps\casino_util::spawn_guys( "cai_e1", true, "e1_ai", "thug" );
	// SOUND: Jerry added this, so guy will hear floor creak.
	level.patroller_ears = patroller;
	level thread maps\casino_amb::thug_ears_1();

	level.player thread play_dialogue( "TANN_CasiG01A_006A", true );	// You'd best move quietly.  Obanno's reserved the entire floor.  His men will be everywhere.

	//guy does his thing
	patroller e1_patroller();


	///---------------------------jl---------------------------------//

	level.hud_black fadeOverTime(1);
	level.hud_black.alpha = 0;

	level notify( "musicstinger_start", 0 );
	letterbox_off( true );

	player_stick( false );	// take weapons, allow look
	new_spot = GetEnt( "cso_playerstart", "targetname" );
	//wait(1.5);

	level.player playerSetForceCover(false, false);

	//	level.sticky_origin MoveTo( new_spot.origin, 0.5 );
	//	level.sticky_origin RotateTo( new_spot.angles, 0.5 );
	wait(0.5);

	player_unstick();
	level.player freezeControls(false);
	wait(0.1);

	setDvar( "cg_disableHudElements", 0 );	

	//	setSavedDvar( "cg_drawHUD", "1" );
	level thread maps\_autosave::autosave_by_name( "e1" );
	level notify("e1_igc_finished");
}

//guy looks at elevator, scratch ,then turn
e1_patroller()
{
	self SetIgnoreThreatType("corpse", true);
	//he's facing down the hall
	self waittill( "facing_node" );
	self cmdaction( "fidget" );
	self waittill( "cmd_done" );
	self StartPatrolRoute( "cpat_e1_start2" );
	wait(1);	// so he turns around
}

//############################################################################
//
//
intro_cutscene_dialog( thugs )
{
	thugs[2] playsound( "CAS_lechiffre_escort" );		//footsteps and other sounds

	//// play as radio dialog if scene has lipsync done
	//thugs[2] play_dialogue( "OBG2_CasiG01A_003A", true );		// You can tell him yourself.
	//thugs[2] play_dialogue( "OBG1_CasiG01A_001A", true );		// Move!
	wait(0.5);
	//thugs[2] waittillmatch("anim_notetrack", "sndnt#OBG2_CasiG_003A");
	//thugs[2] play_dialogue( "OBG1_CasiG01A_001A", true );		// Move!
	//thugs[2] play_dialogue( "OBG2_CasiG01A_003A", true );		// You can tell him yourself.
	//thugs[2] play_dialogue( "OBG1_CasiG01A_001A", true );		// Move!
	//thugs[2] waittillmatch("anim_notetrack", "sndnt#OBG1_CasiG_001A");
	//thugs[2] play_dialogue( "OBG2_CasiG01A_003A", true );		//You can tell him yourself.
}


//############################################################################
//
//
fade_to_black()
{
	wait( 4 );
	level.hud_black fadeOverTime(2);
	level.hud_black.alpha = 1;
}


//############################################################################
// This is the intro IGC
//	Watch Le Chiffre escorted through the hallway
// e1_igc_old( )
// {
// 	// Stop right there
// 	player_stick( false );	// take weapons, allow look
// 	level.player freezeControls(true);	// Need to call freeze controls because I need to unstick the player in order to call force cover
// 
// 	// Spawn the actors for the scene
// 	thugs		= maps\casino_util::spawn_guys( "cai_e1_escort",	true, "e1_ai", "thug" );
// 	lechiffre	= maps\casino_util::spawn_guys( "cai_e1_lechiffre",	true, "e1_ai", "civ" );
// 	thugs[0].targetname		= "thug1";
// 	thugs[1].targetname		= "thug3";
// 	thugs[2].targetname		= "thug4";
// 	lechiffre.targetname	= "LeShf";
// 	wait( 0.05 );
// 
// 	PlayCutscene("LeShf_Escort", "scene_anim_done");
// 
// 	//DC - Opening scene 
// 	// Camera Move down hallway toward elevator
// 	camera_id = level.player customCamera_push(
// 		"world",							// <required string, see camera types>
// 		(-13.96,  888.64,  716.82),			// <optional positional vector offset, default (0,0,0)>	
// 		(-1.71, -178.00,    0.00),			// <optional angle vector offset, default (0,0,0)>
// 		0.00, 								// <optional time to 'tween/lerp' to the camera, default 0.5>
// 		0.00,								// <optional time used to accel/'ease in', default 1/2 lerpTime> 
// 		0.00								// <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
// 		);
// 	level.player customCamera_setDoF(
// 			(camera_id),	// <required ID returned from customCameraPush>
// 			(0.01),	  		// <required Before this distance, near depth of field is maximally blurry>
// 			(0.02),			// <required After this distance, near depth of field is perfectly in focus>
// 			(400.00),		// <required Before this distance, far depth of field is perfectly in focus>
// 			(1000.00),		// <required After this distance, far depth of field is maximally blurry>
// 			(3.01),			// <required Maximal blur radius for near depth of field (must be > 3.0)>
// 			(2.00),			// <required Maximal blur radius for far depth of field>
// 			(0.01),			// <optional time to 'tween/lerp' to the camera, default same as camera>
// 			(0.00),			// <optional time used to accel/'ease in', default same as camera> 
// 			(0.00) 			// <optional time used to decel/'ease out', default same as camera>
// 	);
// 	level.player customCamera_setFoV(
//  		camera_id,    
//  		62.00,			    
//  		0.00,		            
//  		0.00,	                 
//  		0.00              	
//  	);
// 	wait(0.25);
// 	
// 	level.player customCamera_change(
// 		camera_id,									// <required ID returned from customCameraPush>
// 		"world",									// <required string, see camera types below>
// 		(-650.72,  888.64, 754.36),					// <optional positional vector offset, default (0,0,0)>	
// 		(-2.71, -178.00, 0.00),    					// <optional angle vector offset, default (0,0,0)>
// 		14.00,										// <optional time to 'tween/lerp' to the camera, default 0.5>
// 		0.00,										// <optional time used to accel/'ease in', default 1/2 lerpTime> 
// 		5.00										// <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
// 	);
// 	level.player customCamera_setDoF(
// 			(camera_id),	// <required ID returned from customCameraPush>
// 			(0.01),	  		// <required Before this distance, near depth of field is maximally blurry>
// 			(0.02),			// <required After this distance, near depth of field is perfectly in focus>
// 			(500.00),		// <required Before this distance, far depth of field is perfectly in focus>
// 			(1000.00),		// <required After this distance, far depth of field is maximally blurry>
// 			(3.01),			// <required Maximal blur radius for near depth of field (must be > 3.0)>
// 			(2.00),			// <required Maximal blur radius for far depth of field>
// 			(0.01),			// <optional time to 'tween/lerp' to the camera, default same as camera>
// 			(0.00),			// <optional time used to accel/'ease in', default same as camera> 
// 			(0.00) 			// <optional time used to decel/'ease out', default same as camera>
// 	);
// 	level.player customCamera_setFoV(
//  		camera_id,    
//  		62.00,			    
//  		0.00,		            
//  		0.00,	                 
//  		0.00              	
//  	);
// 	wait(14.0);
// 	
// //  elevator doors open toward end of shot	
// 		door_left  = GetEnt( "csbm_e_door_left",  "targetname" );
// 		door_right = GetEnt( "csbm_e_door_right", "targetname" );
// 		door_left  MoveY(  47, 2.0, 0.1, 0.7 );
// 		door_right MoveY( -47, 2.0, 0.1, 0.7 );
// 		door_left	playsound ("CAS_elevator_doors_open");
// //	door_right	playsound ("CAS_elevator_doors_open");
// 	
// 		// Spawn AI
// 		patrol_thugs	= maps\casino_util::spawn_guys( "cai_e1", true, "e1_ai", "thug" );
// 		talker_thugs	= maps\casino_util::spawn_guys_ordinal( "cai_e1_talker", 0, true, "e1_ai", "thug" );
// 		maps\casino_util::reinforcement_update( "cai_e1_reinforcements", "e1_ai", false );
// 
// 		level thread e1_conversation( talker_thugs );
// 		wait(0.5);
// 
// 	// Cut to back of Bond's head
// 	level.player customCamera_change(
// 		camera_id,							// <required ID returned from customCameraPush>
// 		"world",							// <required string, see camera types below>
// 		(-1000.00,  865.35,  765.82),		// <optional positional vector offset, default (0,0,0)>	
// 		(0.97,  -2.11,  -0.85),	    		// <optional angle vector offset, default (0,0,0)>
// 		(0.00), 							// <optional time to 'tween/lerp' to the camera, default 0.5>
// 		(0.00),								// <optional time used to accel/'ease in', default 1/2 lerpTime> 
// 		(0.00)								// <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
// 	);
// 	level.player customCamera_setDoF(
// 			camera_id,		
// 			0.01,	
// 			0.02,		
// 			300.00,	
// 			900.00,		
// 			3.01,	
// 			4.00,		
// 			0.01,		
// 			0.01,	 
// 			0.01 	
// 	);
// 	wait(0.01);
// 	level.player customCamera_change(
// 		camera_id,							// <required ID returned from customCameraPush>
// 		"world",							// <required string, see camera types below>
// 		(-990.94,  865.35,  765.82),		// <optional positional vector offset, default (0,0,0)>	
// 		(  0.97,  -2.11,  -0.85),	    	// <optional angle vector offset, default (0,0,0)>
// 		(3.50), 							// <optional time to 'tween/lerp' to the camera, default 0.5>
// 		(0.01),								// <optional time used to accel/'ease in', default 1/2 lerpTime> 
// 		(0.51)								// <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
// 	);
// 	level.player customCamera_setDoF(
// 			camera_id,		
// 			0.01,	
// 			0.02,		
// 			1200.00,	
// 			1400.00,		
// 			3.01,	
// 			2.00,		
// 			0.1,		
// 			0.1,	 
// 			0.1 	
// 	);
// 	wait(3.50);
// 
// 	// Stop Camera
// 	level.player customCamera_pop( 
// 		camera_id,	// <required ID returned from customCameraPush>
// 		0.16 );		// <optional time to 'tween/lerp' to the previous camera, default prev camera>
// 	wait( 0.85 );
// 
// 	//DC End here.  After this, the player gains control.
// 	player_unstick( );
// 	level.player freezeControls(false);
// }


//############################################################################
//
//	closetlight
e1_tv_flicker()
{
	level endon( "e3_start" );

	while (1)
	{
		intensity = RandomFloatRange( 1.0, 1.5 );
		// stay on long
		iterations = RandomIntRange(8,20);
		for ( i = 0; i<iterations; i++ )
		{
			self setlightintensity( intensity );
			wait( 0.05 + randomfloat( 0.1 ) );
			self setlightintensity( intensity + 0.1 );
			wait( 0.05 + randomfloat( 0.1 ) );
		}
	}
}


//############################################################################
//	setup the special balcony push quick kill anim
e1_conversation( talkers )
{
	level endon( "e2_start" );
	SetDVar("r_lodBias", 0);

	for ( i=0; i<talkers.size; i++ )
	{
		// Don't do if they are suspiscious
		if ( talkers[i] GetAlertState() != "alert_green" )
		{
			return;
		}

		talkers[i] endon( "alert_yellow" );
		talkers[i] endon( "alert_red" );
		talkers[i] endon( "death" );
		talkers[i] thread maps\casino_util::play_dialog_monitor( "conversation_done" );
	}

	trig = GetEnt( "ctrig_e1_conversation", "targetname" );
	trig waittill( "trigger" );


	talkers[0] maps\_utility::play_dialogue( "OBR2_CasiG01A_008A" ); // Who was this man?

	talkers[1] maps\_utility::play_dialogue( "OBR1_CasiG01A_009A" );	// A bodyguard for LeChiffre.

	talkers[0] maps\_utility::play_dialogue( "OBR2_CasiG01A_010A" );	// He was alone?

	talkers[1] maps\_utility::play_dialogue( "OBR1_CasiG01A_011A" );	// He was when I killed him
	talkers[1] notify( "conversation_done" );

	talkers[0] maps\_utility::play_dialogue( "OBR2_CasiG01A_012A" );	// You are a true soldier, Besigye.  Let us hope his friends come looking for him.
	talkers[0] notify( "conversation_done" );
}


//############################################################################
//	setup the special balcony push quick kill anim
e1_set_balcony_qk()
{
	self endon("death");

	// give time for the guy to get close and in position
	wait( 1.5 );
	if ( !IsDefined(self.new_qk_anim) )
	{
		self.new_qk_anim = true;
		self SetCtxParam("Interact", "SpecialQKAnim", "Skylight_QK");
	}
	for(;;)
	{
		if ( self GetAlertState() != "alert_green" )
		{
			self SetCtxParam("Interact", "SpecialQKAnim", "None");		
		}
		wait(0.1);
	}
}


//############################################################################
//	Move away and delete if unengaged
//
e1_withdrawl()
{
	node = GetNode( "cn_e1_withdrawl", "targetname" );

	ents = GetAIArray();
	for ( i=0; i<ents.size; i++ )
	{
		if ( ents[i] GetAlertState() != "alert_red" )
		{
			ents[i] SetGoalNode( node );
			ents[i] thread maps\casino_util::delete_on_goal();
		}
	}
}

//############################################################################

SetPerfectSenseOnRed()
{
	self endon("death");

	self waittill("alert_red");

	self SetPerfectSense(1);

}

//############################################################################
//	e2_main - Outer balcony
//
e2_main( )
{
	level notify( "e2_start" );

	// Startup level effects
	level notify("drapes_1_start");


	// Setup door blocker cart
	blockercart_sbm		= GetEnt( "csbm_e2_blockercart", "targetname" );
	blockercart_model	= GetEnt( "csm_e2_blockercart", "targetname" );
	blockercart_model	LinkTo( blockercart_sbm );

	// Teleport the cart into the right place.  We need to start it in a different spot
	//	away from the door so you can open it later.
	blockercart_start	= GetEnt( "cso_e2_blockercart_start", "targetname" );
	blockercart_sbm.origin = blockercart_start.origin;
	blockercart_sbm.angles = blockercart_start.angles;
	//	blockercart_sbm DisconnectPaths();

	maps\_playerawareness::setupSingleUseOnly( 
		"csm_e2_blockercart_origin",		//	awareness_entity_name,
		::e2_push_blocker_cart,			//	use_event_to_call,
		&"CASINO_HINT_MOVE_CART",		//	hint_string, 
		0,								//	use_time, 
		"",								//	use_text, 
		true,						   	//	single_use, 
		true,							//	require_lookat, 
		undefined,		   				//	filter_to_call, 
		level.awarenessMaterialNone,	//	awareness_material, 
		true,							//	awareness_glow, 
		false,						   	//	awareness_shine, 
		false );					   	//	wait_until_finished )


	// Spawn AI
	// cai_e2_?    0 = bedroom, 1=balcony, 2=bathroom
	thugs = maps\casino_util::spawn_guys_ordinal( "cai_e2_", 0, true, "e2_ai", "thug" );
	maps\casino_util::reinforcement_update( "cai_e2_reinforcements", "e2_ai", false );

	thugs[0] thread check_sight(40, 200);	
	thugs[0] thread SetPerfectSenseOnRed();

	thugs[1] thread check_sight(40, 200);
	thugs[1] thread SetPerfectSenseOnRed();

	thread e2_conversation( thugs );
	level thread e2_tanner();

	// Balcony
	trig = GetEnt( "ctrig_e2_suite", "targetname" );
	trig waittill( "trigger" );

	for ( i=0; i<thugs.size; i++ )
	{
		if ( IsAlive(thugs[i]) &&
			IsDefined(thugs[i].script_noteworthy) &&
			thugs[i].script_noteworthy == "bathroom" )
		{
			bathroom_guy = thugs[i];
			if ( IsAlive( bathroom_guy ) && bathroom_guy GetAlertState() == "alert_green" )
			{
				origin = GetEnt( "cso_toilet", "targetname" );
				origin playsound ("CAS_toilet_flush");
			}
		}
	}

	// E3 handoff
	flag_wait( "obj_detour_end");

	maps\casino_util::reinforcement_update( "", "", false );
	level thread e3_main();

	// cleanup
	level waittill( "e3_vent_start" );

	maps\casino_util::delete_group( "e2_ai" );
}


//############################################################################
//	e2_conversation
//	0=bedroom guy; 1=living room guy
e2_conversation( thugs )
{
	thugs[0] endon( "death" );
	thugs[0] endon( "alert_yellow" );
	thugs[0] endon( "alert_red" );
	thugs[0] thread maps\casino_util::play_dialog_monitor( "conversation_done" );
	thugs[1] endon( "death" );
	thugs[1] endon( "alert_yellow" );
	thugs[1] endon( "alert_red" );
	thugs[1] thread maps\casino_util::play_dialog_monitor( "conversation_done" );

	thugs[1] maps\_utility::play_dialogue( "OBR4_CasiG01A_013A" );	// Obanno did not come this far to be disappointed.

	thugs[0] maps\_utility::play_dialogue( "OBR5_CasiG01A_014A" );	// And if there is none to be had?  Then what?
	thugs[0] notify( "conversation_done" );

	thugs[1] maps\_utility::play_dialogue( "OBR4_CasiG01A_015A" );	// Then even I feel sorry for Le Chiffre.
	thugs[1] notify( "conversation_done" );

	// Balcony
	trig = GetEnt( "ctrig_e2_suite", "targetname" );
	trig waittill( "trigger" );

	thugs[2] maps\_utility::play_dialogue( "OBBR_CasiG01A_023A" );	// It would be much faster just to kill this Le Chiffre.
	thugs[2] notify( "conversation_done" );
	wait( 0.3 );

	thugs[0] maps\_utility::play_dialogue( "OBR4_CasiG01A_022A" );	// Be patient.
	thugs[0] notify( "conversation_done" );

}

//############################################################################
//	setup the special balcony push quick kill anim
e2_set_balcony_qk()
{
	self endon("death");

	// give time for the guy to get close and in position
	wait( 1.5 );
	self SetCtxParam("Interact", "SpecialQKAnim", "Skylight_QK");

	done = false;
	while( !done )
	{
		wait(0.1);

		if ( self GetAlertState() != "alert_green" )
		{		
			self SetCtxParam("Interact", "SpecialQKAnim", "None");	
			done = true;
		}
	}
}

// jl change 
change_fog()
{
	fog_trig = getent("fog_set_change" , "targetname");

	//SetExpFog(0, 532.172, 0.44, 0.41, 0.36, 0.626);
	while(true)
	{

		if(level.player istouching(fog_trig) )
		{
			SetExpFog(13312, 37364, 0.375, 0.382813, 0.648438, 6.3);

			//iprintlnbold("outdoor");
		}
		else 
		{
			//setExpFog(level.fognearplane, level.fogexphalfplane, level.fogred, level.foggreen, level.fogblue, 0, level.fogmax);
			SetExpFog(0, 532.172, 0.44, 0.41, 0.36, 6.3, 0.626);


			//iprintlnbold("indoor");
		}
		wait(0.2);


	}




}

disable_compass()
{

	trigger = getent("compass_gone", "targetname");

	while(true)
	{

		trigger waittill("trigger");
		setdvar("ui_hud_showcompass", 0);
			
		while(level.player istouching(trigger))
		{
			wait(0.1);
		}
		setdvar("ui_hud_showcompass", 1);

	}


}


//############################################################################
//	e2_conversation
//	0=bedroom guy; 1=living room guy
e2_conversation2( thugs )
{
	thugs[0] endon( "death" );
	thugs[0] endon( "alert_yellow" );
	thugs[0] endon( "alert_red" );
	thugs[0] thread maps\casino_util::play_dialog_monitor( "conversation_done" );
	thugs[2] endon( "death" );
	thugs[2] endon( "alert_yellow" );
	thugs[2] endon( "alert_red" );
	thugs[2] thread maps\casino_util::play_dialog_monitor( "conversation_done" );

	// Only proceed if green
	if ( thugs[0] GetAlertState() != "alert_green" || 
		thugs[2] GetAlertState() != "alert_green" )
	{
		return;
	}

	thugs[0] maps\_utility::play_dialogue( "OBBR_CasiG01A_021A" );	// Joseph?  How much longer do we stay?

	thugs[2] maps\_utility::play_dialogue( "OBR4_CasiG01A_022A" );	// Until Obanno says we go.  Be patient.

	thugs[0] maps\_utility::play_dialogue( "OBBR_CasiG01A_023A" );	// It would be much faster just to kill this Le Chiffre.  
	thugs[0] notify( "conversation_done" );

	thugs[2] maps\_utility::play_dialogue( "OBBR_CasiG01A_024A" );	// Obanno invested a hundred million dollars with him.  If we kill him now, we will never see it again.
	thugs[2] notify( "conversation_done" );
}


//############################################################################
//tanner speaks to bond on ledge

e2_tanner()
{
	trig = getent( "move_pip3", "targetname" );
	trig waittill( "trigger" );

	level.player maps\_utility::play_dialogue( "TANN_CasiG01A_019A" );	// Bond, we’ve located Obanno’s room--

	level.player maps\_utility::play_dialogue( "BOND_CasiG01A_020A" );	// Not now, Tanner.


}


//############################################################################
// Push the cart away from the door to the locker room and "unbar" it
e2_push_blocker_cart( object )
{
	cart = getent("csbm_e2_blockercart", "targetname");

	destination = GetEnt( "cso_e2_blockercart_stop", "targetname" );
	cart MoveTo( destination.origin, 1.5, 0.1, 1.0 );
	cart RotateTo( destination.angles, 1.5, 0.1, 1.0 );
	cart playsound( "CAS_tall_cart_roll" );

	wait(1.25);

	clip = GetEnt( "csbm_e2_locker_blocker", "targetname" );
	clip delete();
	//	door = GetEnt( "cdoor_e2_locker_door", "targetname" );
	//	door._doors_barred = false;
}


//############################################################################
//	e3_main - Spa
//
e3_main()
{
	level notify( "e3_start" );

	// Spa FX
	level notify("casino_pool_steam");	// start pool steam particles
	level notify("casino_sauna_steam");	// start pool steam particles
	level notify("vent_rattle_1_start");	// vent air movement
	level notify("vent_rattle_2_start");	// vent air movement

	// 	steam_origins = GetEntArray( "cso_e3_steam_origin", "targetname" );
	// 	for ( i=0; i<steam_origins.size; i++ )
	// 	{
	// 		angles = (0,0,1);
	// 		Playfx(level._effect[ "gettler_dusty_air01" ], steam_origins[i].origin+(0,0,-360), (0,0,1), (0,-1,0) );
	// 	}

	// spin up the fans
	vent_fans = GetEntArray( "vent_fan", "targetname" );
	for ( i=0; i<vent_fans.size; i++ )
	{
		vent_fans[i] thread e3_spin_fan();
	}

	// Setup push cart
	cart_mantle	= GetEnt( "csbm_e3_cart_clip", "targetname" );	// The mantle clip
	cart_mantle trigger_off();

	maps\_playerawareness::setupSingleUseOnly(
		"pushing_cart_trigger",					//	awareness_entity_name,
		::e3_push_cart,					//	use_event_to_call,
		&"CASINO_HINT_MOVE_CART",		//	hint_string, 
		//		"Move Cart",					//	hint_string, 
		0,								//	use_time, 
		"",								//	use_text, 
		true,						   	//	single_use, 
		true,							//	require_lookat, 
		undefined,						//	filter_to_call, 
		level.awarenessMaterialNone,	//	awareness_material, 
		true,							//	awareness_glow, 
		false,						   	//	awareness_shine, 
		false );					   	//	wait_until_finished )

	// Setup ceiling vents
	vent_clip = GetEnt( "csbm_e3_vent_clip", "targetname" );	// The ladder clip
	vent_clip trigger_off();

	maps\_playerawareness::setupArray( 
		"vent_open_locker",				//	awareness_entity_name, 
		::e3_open_vent_locker,			//	use_event_to_call, 
		true,							//	allow_aim_assist, 
		::e3_open_vent_locker,			//	use_event_to_call, 
		&"CASINO_HINT_OPEN_VENT",		//	hint_string, 
		0,								//	use_time, 
		"",								//	use_text, 
		true,							//	single_use, 
		true,							//	require_lookat, 
		undefined,						//	filter_to_call, 
		level.awarenessMaterialNone,	//	awareness_material, 
		true,							//	awareness_glow, 
		false );					   	//	awareness_shine

	// 	maps\_playerawareness::setupArray( 
	// 		"vent_open_spa",				//	awareness_entity_name, 
	// 		::e3_open_vent_spa,				//	use_event_to_call, 
	// 		true,							//	allow_aim_assist, 
	// 		::e3_open_vent_spa,				//	use_event_to_call, 
	// 		&"CASINO_HINT_OPEN_VENT",		//	hint_string, 
	// 		0,								//	use_time, 
	// 		"",								//	use_text, 
	// 		true,							//	single_use, 
	// 		true,							//	require_lookat, 
	// 		undefined,						//	filter_to_call, 
	// 		level.awarenessMaterialNone,	//	awareness_material, 
	// 		true,							//	awareness_glow, 
	// 		false );					   	//	awareness_shine

	flag_wait( "obj_detour2_start");

	// E3 - Inside locker room
	//	thread e3_puzzle_hint();	//	
	level thread e3_tanner();		
	thread e3_vent();
	thread e3_confrontation();	//	

	flag_wait( "flag_in_spa_lobby" );

	level.player AllowStand( true );
	// Automagically let grate fall
	vent = GetEnt("vent_open_spa", "targetname" );
	level thread e3_open_vent_spa( vent );

	/////////////////////////////////////
	//avulaj
	//03/29/08
	//added this to dispaly the level map
	//this will display the vent area
	level thread display_map_spa();
	/////////////////////////////////////

	unholster_weapons();


	// E3 handoff
	trig = GetEnt("ctrig_e4_courtyard", "targetname" );
	trig waittill( "trigger" );

	level thread e4_main();
	level thread maps\_autosave::autosave_now("e4");

	// cleanup
	level waittill( "e5_start" );

	maps\casino_util::delete_group( "e3_ai" );
	maps\casino_util::delete_group( "e3_obanno_ai" );
}

//############################################################################
// tanner talks to bond in locker room
e3_tanner()
{

	trig = GetEnt( "trig_e3_spa_area", "targetname" );
	trig waittill( "trigger" );

	wait(1);	//let player get inside room
	level.player maps\_utility::play_dialogue( "BOND_CasiG01A_025A" );	// Tanner? You were saying?

	level.player maps\_utility::play_dialogue( "TANN_CasiG01A_026A" );	// Obanno’s room is on the other side of the floor.   That’s where they’ll take Le Chiffre.

}

//############################################################################
// Crappy function for making you duck in the vents
e3_vent()
{
	level endon( "flag_in_spa_lobby" );

	level thread e3_unholster();
	trig = GetEnt( "trig_e3_vent", "targetname" );
	trigger_level_1 = getent("level_1_map_switch", "targetname");
	while( true )
	{
		trig waittill( "trigger" );

		level.player AllowStand(false);
		SetSavedDVar("cover_dash_fromCover_enabled",false);
		SetSavedDVar("cover_dash_from1stperson_enabled",false);
		holster_weapons();

		//////////////////////////////////////////////
		//avulaj
		//03/29/08
		//added this to dispaly the level map
		//this will display the vent area
		setSavedDvar( "sf_compassmaplevel",  "level2" );
		//////////////////////////////////////////////

		trigger_level_1 waittill("trigger");
		level.player AllowStand(true);
		//////////////////////////////////////////////////////////////////////////////////////////////////////////
		//avulaj
		//03/29/08
		//added this to dispaly the level map
		//this will display the first area map including the 1st hall the 1st ledge the suite leading to the vent
		setSavedDvar( "sf_compassmaplevel",  "level1" );

		//iprintlnbold("level1");
		//////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}


//############################################################################
//
//
e3_unholster()
{
	level endon( "flag_in_spa_lobby" );
	trig = GetEnt( "trig_e3_spa_area", "targetname" );

	while (1)
	{
		trig waittill("trigger");

		if ( IsDefined(level.player.weapons_holstered) && level.player.weapons_holstered )
		{
			unholster_weapons();
		}
	}
}


//############################################################################
// Push the laundry cart towards the locker
e3_push_cart( object )
{

	//delete clip off the top of the locker
	mantle_clip = getent("mantle_lock_clip", "targetname");
	mantle_clip delete();

	cart = object.primaryEntity;
	
	cart		= GetEnt( "csbm_e3_cart", "targetname" );
	cart_model	= GetEnt( "csm_e3_cart", "targetname" );
	cart_bag1	= GetEnt( "csm_e3_cart_bag1", "targetname" );
	cart_bag2	= GetEnt( "csm_e3_cart_bag2", "targetname" );
	cart_model	LinkTo( cart );
	cart_bag1	LinkTo( cart );
	cart_bag2	LinkTo( cart );

	destination = GetEnt( cart.target, "targetname" );

	physicsJolt( cart.origin, 64, 0, (0.0, 0.7, 0.0) );
	cart MoveTo( destination.origin, 1.0, 0.1, 0.0 );
	cart RotateTo( destination.angles, 1.0, 0.1, 0.0 );
	cart playsound ("CAS_laundry_cart_roll");
	player_stick(true);
	wait(0.5);
	player_unstick();
	wait(0.5);
	// bounce off locker
	push_pt = GetEnt( "cso_e3_locker_topple", "targetname" );
	physicsJolt( push_pt.origin, 32, 0, (0.1, -0.1, 0.0) );
	destination = GetEnt( destination.target, "targetname" );
	cart MoveTo( destination.origin, 0.3, 0.0 , 0.3 );
	cart RotateTo( destination.angles, 0.3, 0.0, 0.3 );

	//	cart ConnectPaths();
	cart_mantle	= GetEnt( "csbm_e3_cart_clip", "targetname" );	// The mantle clip
	cart_mantle trigger_on();
}


//############################################################################
// Activate only if the player is not in front of it and looking towards it
e3_push_cart_filter( object )
{
	cart = object.primaryEntity;

	dot = VectorDot(AnglesToForward(cart.angles), AnglesToForward(level.player.angles));
	if ( dot > 0.7 )
	{
		return true;
	}
	else
	{
		return false;
	}
}


//############################################################################
// Push the cart away from the door to the locker room and "unbar" it
e3_push_blocker_cart( object )
{
	cart = object.primaryEntity;

	destination = GetEnt( "cso_e3_blockercart_stop", "targetname" );
	cart MoveTo( destination.origin, 2.0, 0.1, 1.0 );
	cart RotateTo( destination.angles, 2.0, 0.1, 1.0 );

	wait(1.0);

	door = GetEnt( "door_lockerroom", "targetname" );
	door._doors_barred = false;
}


//############################################################################
// Open the vent so Bond can climb in
e3_open_vent_locker( object )
{
	vent = object.primaryEntity;
	vent RotateTo( (0, 0, 90), 1.0, 0.5, 0 );
	maps\casino_amb::vent_rattle_locker_stop();
	vent playsound ("CAS_vent_open");
	vent notsolid();
	level notify( "vent_open_1_start" );
	wait(0.5);

	//	vent solid();

	vent_clip = GetEnt( "csbm_e3_vent_clip", "targetname" );	// The ladder clip
	vent_clip trigger_on();
}


//############################################################################
// Open the vent so Bond can fall
e3_open_vent_spa( vent )
{
	//	vent = object.primaryEntity;
	vent RotateTo( (-90, 0, 0), 1.0, 0.5, 0 );
	maps\casino_amb::vent_rattle_spa_stop();
	//vent playsound ("CAS_vent_open");
	vent playsound ("CAS_vent_fall");	//uncomment after sync

	level notify( "vent_open_2_start" );
	vent notsolid();
	level notify( "vent_open_1_start" );
	fx = playfx( level._effect["casino_fallthroughvent"], vent.origin ); 

	wait(0.5);

	SetSavedDVar("cover_dash_fromCover_enabled",true);
	SetSavedDVar("cover_dash_from1stperson_enabled",true);
}

//avulaj
//03/29/08
//added this to dispaly the level map
//this will display the spa area and the path leading to the main hall
display_map_spa()
{	
	wait( 1 );
	setSavedDvar( "sf_compassmaplevel",  "level3" );
}


//############################################################################
//	Spin the fans! 
//
e3_spin_fan()
{
	level endon( "flag_in_spa_lobby" );

	rotation = AnglesToForward( self.angles );
	pitch = self.angles[0];
	yaw = self.angles[1];
	roll = self.angles[2];
	//	0
	if ( yaw > -5 && yaw < 5 )				
	{
		rotation = (  1,   0,   0);
	}
	//	90
	else if ( yaw > 85 && yaw < 95  )
	{
		if ( int(roll) == 0 )
		{
			rotation = (  -1,   0,   0);
		}
		else if ( int(self.angles[2]) == 90 )
		{
			rotation = (  0,   1,   0);
		}
	}
	//	180
	else if ( yaw > 175 && yaw < 185 )
	{
		rotation = ( -1,   0,   0);
	}
	//	270
	else if ( yaw > 265 && yaw < 275 )
	{
		rotation = (  -1,  0,  0);
	}
	else
	{
		/#
			print("Invalid angle: " + yaw );
#/
		return;
	}

	rotation = rotation * 500.0;
	while ( 1 )
	{
		self rotateVelocity( rotation, 10.0 );
		wait(10.0);
	}
}


//############################################################################
//	e3_puzzle_hint - Give a hint if you leave before opening the vent
//
// e3_puzzle_hint()
// {
// 	level endon( "e3_vent_start" );
// 	trig_spa_area = GetEnt( "trig_e3_spa_area", "targetname" );
// 	trig_vent_area = GetEnt( "trig_e3_vent_area", "targetname" );
// 
// 	// Wait for the player to enter the spa
// 	trig_spa_area waittill( "trigger" );
// 
// 	while( level.player IsTouching( trig_spa_area ) )
// 	{
// 		if ( flag( "flag_in_vents" ) )
// 		{
// 			return;
// 		}
// 		wait( 0.05 );
// 	}
// 
// 	// If we're here, the player is leaving the spa without having gone in the vent, so give the hint
// 	player_stick();
// 	holster_weapons();
// 	level.sticky_origin MoveTo(   (-550.06, 2185.58, 704.00), 1.5 );
// 
// 	// Point at the vent
// //	vent = GetEnt( "wall_vent_open", "targetname" );
// 	camera_id = level.player customCamera_push(
// 			"world",		// <required string, see camera types below>
// 			(-555.06, 2185.58, 768.62),		// <optional positional vector offset, default (0,0,0)>
// 			( -24.81,  148.51,    0.00),	// <optional angle vector offset, default (0,0,0)>
// 			2.0 );		// <optional time to 'tween/lerp' to the camera, default 0.5>
// 	wait( 3.0 );
// 
// 	// Now point at the cart
// 	cart_sbm	= GetEnt( "csbm_e3_cart", "targetname" );
// 	cart_direction = VectorToAngles( cart_sbm.origin - (level.player.origin+(0,0,72)) );	// don't forget to compute from the head, not the feet
// 	level.sticky_origin RotateTo( cart_direction, 2.0 );
// 	level.player customCamera_pop( 
// 			camera_id,	// <required ID returned from customCameraPush>
// 			2.0 );	// <optional time to 'tween/lerp' to the previous camera, default prev camera>
// 	wait(3.0);
// 	player_unstick();
// 	unholster_weapons();
// }


//############################################################################
//	e3_confrontation - Intro Obanno's guys vs. Le Chiffre's men
//
e3_confrontation()
{
	// Approach first vent
	trig = GetEnt("trig_e3_vent", "targetname" );
	trig waittill( "trigger" );


	level thread maps\_autosave::autosave_now( "E3_vent" );


	//////////////////////////////////////////////
	//avulaj
	//03/29/08
	//added this to dispaly the level map
	//this will display the vent area
	setSavedDvar( "sf_compassmaplevel",  "level2" );
	//////////////////////////////////////////////

	level notify( "e3_vent_start" );

	// Spawn the Obanno guy who's going to die.
	level.oguy = maps\casino_util::spawn_guys( "cai_e3_oguy_die", true, "e3_ai", "thug_yellow" );
	level.oguy LockAlertState("alert_yellow" );
	level.oguy SetEnableSense( false );
	level.oguy thread e3_aimat_lcguy();

	// Approach third opening
	trig = GetEnt("ctrig_e3_vent0", "targetname" );
	trig waittill( "trigger" );

	level thread maps\casino_pip::split_screen_spa_1();

	//level thread e3_doorway_runner();

	sorigin = GetEnt( "cso_door_crash", "targetname" );
	if ( IsDefined(sorigin) )
	{
		sorigin playsound( "CAS_door_crash" );
	}

	// Spawn Le Chiffre guys
	level.lcguys = maps\casino_util::spawn_guys_ordinal( "cai_e3_lcguy", 0, true, "e3_ai", "thug_yellow" );

	// LC Guys are set as allies so we need to make sure they still see Bond as a threat
	//	This also prevents you from getting the Friendly Fire failure
	for ( i=0; i<level.lcguys.size; i++ )
	{
		if ( IsAlive(level.lcguys[i]) )	// need check in case anyone got shot
		{
			level.lcguys[i]	setforcethreat( level.player,  true );
			level.lcguys[i]	thread magic_bullet_shield();
			level.lcguys[i]	LockAlertState("alert_yellow" );
			level.lcguys[i]	SetEnableSense( false );
		}
	}

	// Do not thread e3_faceoff.  It's completion triggers the fight
	flag_init( "e3_player_hidden" );
	trig = GetEnt( "ctrig_e3_vent3", "targetname" );
	trig thread e3_magic_bullets();

	GetEnt( "ctrig_e3_vent0", "targetname" ) thread shoot_player_in_vent();
	GetEnt( "ctrig_e3_vent3", "targetname" ) thread shoot_player_in_vent();
	GetEnt( "ctrig_e3_vent4", "targetname" ) thread shoot_player_in_vent();
	GetEnt( "ctrig_e3_vent5", "targetname" ) thread shoot_player_in_vent();

	e3_faceoff( level.oguy, level.lcguys );
	// This will spawn the Obanno guys when oguy_die dies.
	thread e3_fight( level.oguy, level.lcguys );

	//trig waittill("trigger");

}


//############################################################################
//	Run past a doorway!
//
e3_doorway_runner()
{
	//iPrintlnbold("Doorway");

	//runner = maps\casino_util::spawn_guys( "cai_e3_oguy_doorway", true, "e3_ai", "thug_yellow" );


}

//############################################################################
e3_aimat_oguy()
{
	if ( IsAlive(level.oguy) )
	{
		self CmdAimatEntity( level.oguy, true, -1 );
	}
}


//############################################################################
e3_aimat_lcguy()
{
	while( !IsDefined(level.lcguys) )
	{
		wait( 0.1 );
	}
	if ( IsAlive(level.lcguys[1]) )
	{
		self CmdAimatEntity( level.lcguys[1], true, -1, 1 );
	}
}

//############################################################################
//	Le Chiffre's men bust in demanding Le Chiffre
//
e3_faceoff( oguy, lcguys )
{
	oguy endon( "alert_red" );
	oguy endon( "death" );

	for ( i=0; i<lcguys.size; i++ )
	{
		lcguys[i] endon( "alert_red" );
		lcguys[i] endon( "death" );
	}

	// Talk and wave your arms around
	lcguys[1] CmdAction( "TalkA2", true );
	lcguys[1] maps\_utility::play_dialogue( "CMRC_CasiG01A_031A" );	// Where is Le Chiffre?
	lcguys[1] maps\_utility::play_dialogue( "CMRC_CasiG01A_032A" );	// If you’ve harmed him-- in any way-- we’ll kill you all.
	lcguys[1] StopCmd();

	// Oguys starts talking
	oguy StopCmd();
	oguy CmdAction( "TalkA1", true );
	oguy maps\_utility::play_dialogue( "OBR6_CasiG01A_033A" );			// We are revolutionaries.  We are more than ready to die.
	oguy StopCmd();

	// lower your weapons - shooting comes later
	lcguys[1] maps\_utility::play_dialogue( "CMRC_CasiG01A_034A" );	// Good.
	lcguys[1] playsound( "wpn_a3raker_fire_ai" );
	lcguys[0] StopCmd();
	lcguys[2] StopCmd();

	// If we got here, then nothing was interrupted
	flag_set( "e3_player_hidden" );
}


//############################################################################
//	Say something to let people know you're arriving
//
e3_announce_arrival()
{
	self endon( "death" );

	if ( RandomInt(100) < 50 )
	{
		self PlaySound( "CAS_big_door_01" );
		level.player PlaySound( "CAS_big_door_01" );	//xxx play on player so he hears it for now.
	}
	else
	{
		self PlaySound( "CAS_big_door_02" );
		level.player PlaySound( "CAS_big_door_02" );	//xxx play on player so he hears it for now.
	}

	wait( 1.0 );

	if ( self GetAlertState() == "alert_red" )
	{
		// 		switch( RandomInt(2) )
		// 		{
		// 			case 0:
		self thread maps\_utility::play_dialogue( "OSR3_CasiG01A_040A" );	// We must hold them here, comrade. 
		// 				break;
		// 			case 1:
		// 				break;
		// 		}
	}
}

//############################################################################
//	e3_fight after the one Obanno guy dies, then start the fighting
//
e3_fight( oguy_die, lcguys )
{
	// start the bullet fx threads
	for ( i=0; i<lcguys.size; i++ )
	{
		lcguys[i].team = "allies";
	}

	// Start Shooting
	tether_node = GetNode("cn_e3_lcguy_tether", "targetname" );
	if ( IsAlive( oguy_die ) )
	{
		// have the obanno guy become alert
		oguy_die UnlockAlertState();
		oguy_die SetEnableSense( true );

		// LC guys shoot oguy_die
		for ( i=0; i<lcguys.size; i++ )
		{
			if ( IsAlive( lcguys[i] ) )
			{
				lcguys[i] StopPatrolRoute();
				wait(0.05);
				lcguys[i] SetEnableSense( true );
				lcguys[i] cmdshootatentity( oguy_die, true, 1, 1 );
				lcguys[i] UnlockAlertState();
				lcguys[i] SetShootAllowed(false);

				node = GetNode( "LcGoal"+i, "targetname" );
				lcguys[i] SetGoalNode( node );
				
				lcguys[i].tetherradius	= 12*1;
 
				lcguys[i] SetPerfectSense(true);
				lcguys[i] SetIgnoreThreat(level.player, true );
				
				lcguys[i] LockAlertState("alert_red");
				lcguys[i] AddEngageRule("TgtPerceive");
			}
		}
	}
	//wait(2);	//too long of a pause -jc

	if ( IsAlive(oguy_die) )
	{
		oguy_die DoDamage(1000, oguy_die.origin );
	}
	wait( 1 );

	ent = GetEnt( "cso_e3_splash", "targetname" );
	ent playsound( "CAS_pool_splash" );

	wait( 1 );

	maps\casino_util::spawn_guys( "cai_e3_oguy_start", true, "e3_obanno_ai", "thug_red" );


	//Maek every AI terrible shooter
	maps\casino_util::Ai_SetEveryAiAccuracy(GetAIArray(), 0);
	maps\casino_util::Ai_StartAutoDisableSense(GetAIArray(), 0.60, 3, 5);

	// find the first set of oguys
	wait(0.1);
	level.oguys = [];
	ents = GetAIArray();
	for ( i=0; i<ents.size; i++ )
	{
		if ( IsDefined(ents[i].groupname) && ents[i].groupname == "e3_obanno_ai" )
		{
			level.oguys[level.oguys.size] = ents[i];
			ents[i] thread magic_bullet_shield();			
		}
	}
	wait( 1 );	// Give time for the AI to spawn in and start running before we come back

	// 	// Stop the camera if it was used
	// 	if ( IsDefined(level.camera_id) )
	// 	{
	// 		level.player customCamera_pop( 
	// 				level.camera_id,	// <required ID returned from customCameraPush>
	// 				1.5 );	// <optional time to 'tween/lerp' to the previous camera, default prev camera>
	// 		level.camera_id = undefined;
	// 		wait( 1.6 );
	// 		player_unstick( );
	// 	}

	//SaveGame( "E3");	// checkpoint after the IGC

	//	Dialog
	if ( flag( "e3_player_hidden" ) )
	{
		wait( 1.0 );
		// Scene played out by itself
		for ( i=0; i<lcguys.size; i++ )
		{
			if ( IsAlive(level.oguys[i]) )	// need check in case anyone got shot
			{
				break;
			}
		}
		wait( 2.0 );

		for ( i=0; i<lcguys.size; i++ )
		{
			if ( IsAlive(lcguys[i]) )	// need check in case anyone got shot
			{
				level.lcguys[i] thread maps\_utility::play_dialogue( "CMRC_CasiG01A_036A" );	// Get back!  Give me Le Chiffre!
				break;
			}
		}
	}

	//wait( 2.0 );

	trig = GetEnt( "trig_e3_prep_spa_scene", "targetname" );
	trig waittill( "trigger" );

	// HACK - respawn guys needed for cutscene if they died
	if (!IsDefined(lcguys[1]) || !IsAlive(lcguys[1]))
	{
		spawner = GetEnt("cai_e3_lcguy1", "targetname");
		spawner.count++;
		lcguys[1] = spawner StalingradSpawn();

		if (!spawn_failed(lcguys[1]))
		{
			lcguys[1] thread magic_bullet_shield();
		}
	}

	if (!IsDefined(lcguys[2]) || !IsAlive(lcguys[2]))
	{
		spawner = GetEnt("cai_e3_lcguy2", "targetname");
		spawner.count++;
		lcguys[2] = spawner StalingradSpawn();

		if (!spawn_failed(lcguys[2]))
		{
			lcguys[2] thread magic_bullet_shield();
		}
	}

	//AI become more accurate again
	maps\casino_util::Ai_SetEveryAiAccuracy(GetAIArray(), 0.9);
	maps\casino_util::Ai_StopAutoDisableSense(GetAIArray());


	lcguys[1] thread e3_spa_death( "cn_e3_lcguy_death" );
	lcguys[2] thread e3_spa_death( "cn_e3_lcguy2_death" );

	// E3 part 2 - just after dropping in
	level thread maps\_autosave::autosave_by_name( "E3");	// moved here -jc
	flag_wait( "flag_in_spa_lobby" );

	// Set off the death scene
	wait(0.1); // ludes

	// playsound of bond hitting ground
	level thread help_function();

	//	playfx
	level notify("spa_wall_start");
	wait(0.5);
	level notify("playmusicpackage_spa");

	//	delay the cutscene playing, so that the thug hit the door, and door broken at the same time
	wait(1.0);
	lcguys[1].targetname = "thug1";
	lcguys[2].targetname = "thug2";
	PlayCutscene("two_thug_death", "scene_anim_done");

	wall = GetEnt( "fxanim_spa_wall", "targetname" );
	wall playsound( "CAS_spa_wall" );

	// Release bullet shield
	for( i=0; i<level.oguys.size; i++ )
	{
		level.oguys[i] notify( "stop magic bullet shield" );

		level.oguys[i] thread maps\casino_util::Ai_SetPerfectSenseUntillThreatIsPlayer(5);

	}
	// 	for( i=0; i<level.lcguys.size; i++ )
	// 	{
	// 		level.lcguys[i] notify( "stop magic bullet shield" );
	// 	}
	level.lcguys[0] notify( "stop magic bullet shield" );

	level waittill( "scene_anim_done" );

	if( IsDefined( level.lcguys[0] ) )
	{
		//No need to see this dude getting shot multiple time... kill him the next time he get shot
		level.lcguys[0].health = 1;
	}

	wall = getent( "fxanim_spa_wall", "targetname" );
	wall waittillmatch("a_spa_wall", "end");

	level thread maps\_autosave::autosave_by_name( "E3_spa");	// moved here -jc

	wait( 1.5 );

	//	level notify("playmusicpackage_spa");

	level thread e3_remove_tethers(); // _brian_b_ : remove thethers when player exits the spa so the "barricade" guys can take better cover.

	// Wave scripting
	trig_left   = GetEnt( "ctrig_e3_spa_left",	"targetname" );
	trig_right	= GetEnt( "ctrig_e3_spa_right",	"targetname" );
	num_waves = 1;

	tether_pt = GetEnt("spa_barricade_tether", "targetname").origin;

	oguys = maps\casino_util::spawn_guys( "cai_e3_oguy_start2", true, "e3_obanno_ai", "thug_red" );
	
	for( i=0; i<oguys.size; i++ )
	{
		oguys[i] thread maps\casino_util::Ai_SetPerfectSenseUntillThreatIsPlayer(5);
	}

	level.oguys = maps\casino_util::array_add_Ex( level.oguys, oguys );
	while (1)
	{
		level.oguys = array_removeDead( level.oguys );

		if ( level.oguys.size <= 2 )
		{
			wait( randomfloatrange( 1.0, 3.0) );

			//Michel removed save point because it could save in a bad time
			// anyway, this fight is pretty easy now, so no need to save
			//level thread maps\_autosave::autosave_now( "E3C" );
			//wait( 5.0 );	// breather
			GetEnt("force_next_wave", "targetname") wait_for_trigger_or_timeout(5); //_brian_b_ : instead of just a wait here, do a trigger with a timeout, so the player can't rush forward passed the door

			//if ( RandomInt(100) < 50 )
			//{
			//if ( !level.player IsTouching( trig_left ) )
			//{
			//	spawnername = "cai_e3_oguy_left";
			//}
			//else
			//{
			//	spawnername = "cai_e3_oguy_right";
			//}
			//}
			//else	// _brian_b_ : both these blocks do the exact same thing.
			//{
			//	if ( !level.player IsTouching( trig_right ) )
			//	{
			//		spawnername = "cai_e3_oguy_right";
			//	}
			//	else
			//	{
			//		spawnername = "cai_e3_oguy_left";
			//	}
			//}

			//new_guys = maps\casino_util::spawn_guys( spawnername, true, "e3_ai", "thug_red" );
			//level.oguys = maps\casino_util::array_add_Ex( level.oguys, new_guys );

			num_waves--;
			if ( num_waves >= 0 )
			{
				//new_guys[0] thread e3_announce_arrival();

				if ( num_waves == 0 )
				{

					new_guys = maps\casino_util::spawn_guys( "cai_e3_oguy_barricade2", true, "e3_ai", "thug_red");
					for (i = 0; i < new_guys.size; i++)
					{
						new_guys[i] thread spa_hack();
						new_guys[i] maps\casino_util::SetPerfectSenseTimer(5.0);
					}
					level.oguys = maps\casino_util::array_add_Ex( level.oguys, new_guys );

					wait( 2.0 );
/* Michel

					// Spawn in the "turret" guys
					new_guys = maps\casino_util::spawn_guys( "cai_e3_oguy_barricade", true, "e3_ai", "thug_red", undefined, tether_pt, 300);
					level.oguys = maps\casino_util::array_add_Ex( level.oguys, new_guys );

					for (i = 0; i < new_guys.size; i++)
					{
						new_guys[i] maps\casino_util::reinforcement_awareness();
					}

					// spawn in another set of guys // _brian_b_ : don't spawn this set
					//new_guys = maps\casino_util::spawn_guys( spawnername, true, "e3_ai", "thug_red" );
					//level.oguys = maps\casino_util::array_add_Ex( level.oguys, new_guys );

					*/
				}
				break;
			}
			else
			{
				break;
			}
		}

		wait 2.0;
	}

	num_waves = 1;	//changed from 2 to 1 for demo -jc

	// _brian_b_ : spawn in more of the last guys
	/* Michel
	while (1)
	{
		level.oguys = array_removeDead( level.oguys );

		if ( level.oguys.size <= (3 + num_waves) )
		{
			if ( num_waves > 0 )
			{
				new_guys = maps\casino_util::spawn_guys( "cai_e3_oguy_barricade", true, "e3_ai", "thug_red", undefined, tether_pt, 300);
				for (i = 0; i < new_guys.size; i++)
				{
					new_guys[i] maps\casino_util::reinforcement_awareness();
				}

				level.oguys = maps\casino_util::array_add_Ex( level.oguys, new_guys );
				num_waves--;
			}
			else
			{
				break;
			}
		}

		wait 0.5;
	}*/

	// now wait until we're down to a few
	last_guy = false;
	while (1)
	{
		level.oguys = array_removeDead( level.oguys );

		if ( level.oguys.size <= 0 )
		{		
			level thread e3_final_spawn();
			flag_set( "obj_spa_exit_open" );
			break;
		}

		wait( 1.0 );
	}

	//while (1)
	//{
	//	level.oguys = array_removeDead( level.oguys );

	//	if ( !last_guy && level.oguys.size == 1 )
	//	{
	//		// only do this once
	//		level.oguys[0] SetCombatRole("rusher");
	//		last_guy = true;	
	//	}
	//	wait( 1.0 );
	//}
}

// _brian_b_ : spa_hack - keeps the aug guys in their room until the player leaves the spa, but allows their tethers to be big so they can take better
//							positions when the player flanks them.
spa_hack()
{
	self endon("death");
	self waittill("goal");

	if (!IsDefined(level.spa_hack))
	{
		level.spa_hack = 0;
	}

	level.spa_hack++;

	if (level.spa_hack == 3)
	{
		blocker = GetEnt("spa_exit_blocker", "targetname");
		blocker trigger_on();
		blocker DisconnectPaths();
		blocker trigger_off();
	}
}

// _brian_b_ : remove all tethers (or at least make them big)
e3_remove_tethers()
{
	GetEnt("spa_exit", "targetname") waittill("trigger");

	ai = GetAIArray();
	for (i = 0; i < ai.size; i++)
	{
		ai[i] SetTetherRadius(2000);
	}

	GetEnt("spa_exit2", "targetname") waittill("trigger");

	blocker = GetEnt("spa_exit_blocker", "targetname");
	blocker trigger_on();
	blocker ConnectPaths();
	blocker delete();
}


//############################################################################
//	JL - fall through vent
//
help_function()
{
	level.control_origin = spawn("script_origin", (-637, 1654, 889)); // drop the player 140 units

	//force player to look at explosion - jc
	//level.control_origin.angles = (-60,180,0);	//look up at vent -not working happens too late
	level.control_origin.angles = (-10,180,0);	//look at explosion
	level.player PlayerLinkToAbsolute(level.control_origin);

	//level.player PlayerLinkToDelta(level.control_origin, undefined, 0, 150, 200, 150, 200);
	//	level.control_origin movez( -10, 0.2, 0.2, 0.2 );
	//	level.control_origin waittill( "movedone" );


	//wait( 0.3 );	//needs to happen sooner - jc
	//	-637 1654 889

	level.control_origin moveto( (-648, 1656, 710), 0.5, 0.1, 0.2); // trying to move bond closer to wall for the wall hug	
	level.player playsound ("CAS_big_door_01");
	wait( 0.2 );

	level.player playsound ("CAS_chandelier_fancy_sml_crash");
	//fx = playfx( level._effect["casino_chandelier_burst"], level.player.origin + ( 0,0,20 ) ); 
	earthquake( 0.3, 2.5, level.player.origin, 850 );
	level.player shellshock("default", 6);
	wait( 0.2 );
	level.player playsound ("CAS_big_door_02");

	level.control_origin waittill( "movedone" );
	wait( 0.1 );

	//level.control_origin.angles = (-10,180,0);	//look at explosion
	//	level.player playsound ("breathing_start");	
	earthquake( 0.3, 2.5, level.player.origin, 850 );

	level.player Unlink();
	level.control_origin delete();
	level.control_origin = undefined;
	wait( 0.4 );
	//	level.player playsound ("breathing_heartbeat");


}


//############################################################################
//	Spawn some bullet holes in front of the player to scare him and look cool.
//	NOTE: the trigger this runs on should have script_int set to represent the direction
//	the bullets will come from (as a yaw).
//
e3_magic_bullets()
{
	self waittill ( "trigger" );
	//level thread maps\casino_pip::split_screen_spa_2();

	start_ent	= GetEnt( "cso_e3_bullet_hole", "targetname" );
	//fx_point	= start_ent.origin;
	for ( i=0; i<5; i++ )
	{
		x = randomfloatrange(0.0,30.0);
		z = randomfloatrange(-8.0, 8.0);
		// where the magic bullet will fire from 
		//	(NOTE: It's the opposite of where it should have come from)
		firepos = start_ent.origin + ( (i*40.0)+x+3, 0, 15-(i*8) );
		hitpos = firepos + ( 0, -3, 0);
		magicbullet("SAF9_Casino_s", firepos, hitpos);

		fx_spawn = Spawn( "script_model", hitpos+(0,4,0) );	// move it out from the wall 1
		fx_spawn SetModel( "tag_origin" );
		fx_spawn.angles = start_ent.angles+( randomfloatrange(-5.0, 5.0), 0,0);
		fx = playfxontag( level._effect["casino_vent_bullet_vol"], fx_spawn, "tag_origin" );
		fx_spawn thread impact_bullet_sound();

		wait( 0.1 );
	}
	start_ent	= GetEnt( "cso_e3_bullet_hole2", "targetname" );
	//fx_point	= start_ent.origin;
	for ( i=0; i<1; i++ )
	{
		x = randomfloatrange(0.0,30.0);
		z = randomfloatrange(-5.0, 5.0);
		// where the magic bullet will fire from 
		//	(NOTE: It's the opposite of where it should have come from)
		firepos = start_ent.origin + ( (i*40.0)+x+3, 0, 15-( (i+4)*8) );
		hitpos = firepos + ( 0, -3, 0);
		magicbullet("SAF9_Casino_s", firepos, hitpos);

		fx_spawn = Spawn( "script_model", hitpos+(0,1,0) );	// move it out from the wall 1
		fx_spawn SetModel( "tag_origin" );
		fx_spawn.angles = start_ent.angles+( randomfloatrange(-5.0, 5.0), 0,0);
		fx = playfxontag( level._effect["casino_vent_bullet_vol"], fx_spawn, "tag_origin" );
		fx_spawn thread impact_bullet_sound();

		wait( 0.1 );
	}
}


//
//  Don't let the player in the vent
shoot_player_in_vent()
{
	level endon("flag_in_spa_lobby");

	if ( !IsDefined( level.player_seen_in_vent ) )
	{
		level.player_seen_in_vent = 0;
	}

	while ( 1 )
	{
		self waittill( "trigger" );

		time_start = GetTime();
		while ( level.player IsTouching(self) )
		{
			if ( GetTime() > time_start + 10000 )
			{
				level.player_seen_in_vent++;

				level.player PlaySound("VENT_CasiG02A_999A");	// "Someone's in the vent!" - "Kill them!"  - or something
				old_player_pos = level.player.origin;
				wait 3.0;

				hitpos = undefined;
				for ( i=0; i<5; i++ )
				{
					x = randomfloatrange(-5.0, 5.0);
					y = randomfloatrange(-5.0, 5.0);
					// where the magic bullet will fire from 
					//	(NOTE: It's the opposite of where it should have come from)
					//firepos = level.player.origin + ( (i*40.0)+x+3, 0, 15-( (i+4)*8) );
					if ( level.player IsTouching(self) || level.player_seen_in_vent >= 3 )
					{
						firepos = level.player.origin + AnglesToForward(level.player.angles) * (i * 6 + RandomInt(6));
					}
					else
					{
						firepos = old_player_pos + (-1,0,0) * (i * 40 + RandomInt(20));
					}
					trace = bullettrace(firepos + (0, 0, 10), firepos + (0, 0, -100), false, undefined);
					hitpos = trace["position"] + (x, y, -3);
					magicbullet("SAF9_Casino_s", firepos, hitpos);

					fx_spawn = Spawn( "script_model", hitpos+(0,0,4) );	// move it out from the floor
					fx_spawn SetModel( "tag_origin" );
					//fx_spawn.angles = start_ent.angles+( randomfloatrange(-5.0, 5.0), 0,0);
					fx_spawn.angles = (-90, x, x);
					fx = playfxontag( level._effect["casino_vent_bullet_vol"], fx_spawn, "tag_origin" );
					fx_spawn thread impact_bullet_sound();

					if ( level.player IsTouching(self) )
					{
						level.player DoDamage(20, hitpos);
					}
					wait( 0.1 );
				}

				// You've dilly-dallied too long.  Now DIE!
				if ( level.player IsTouching(self) && level.player_seen_in_vent >= 3 )
				{
					level.player DoDamage(level.player.health * 2, level.player.origin);
				}

				break;
			}

			wait( 0.05 );
		}
	}
}


//############################################################################
//	Extra ricochet
//
impact_bullet_sound()
{
	wait( 0.2 );
	level.player playsound ("bulletspray_large_metal");
	level.player playsound ("whizby");
}


//############################################################################
//	Death scene for the guys who get shot
//
e3_spa_death( nodename )
{
	node = GetNode(nodename, "targetname" );

	self SetDeathEnable(false);
	self SetPainEnable(false);

	// Hang around your cue spot
	self stoppatrolroute();
	wait(0.05);
	self.tetherpt = node.origin;
	self.tetherradius = 100;


	//trig = GetEnt( "trig_e3_prep_spa_scene", "targetname" );
	//trig waittill( "trigger" );	// moved

	sticky_origin = Spawn("script_origin", self.origin);
	sticky_origin.angles = self.angles;
	self LinkTo(sticky_origin);
	sticky_origin MoveTo(   node.origin, 1.0 );
	wait( 1.0 );

	// get guys to cue spots
	self Unlink();
	sticky_origin delete();
	self.tetherradius = 16;
	flag_wait( "flag_in_spa_lobby" );

	self teleport( node.origin, node.angles );

	// Play your damn animation
	if ( IsAlive(self) )
	{
		self notify( "stop magic bullet shield" );

		//still give him a lot of health, 
		self.health = 1000;
	}
	//	self CmdPlayAnim( animname, false );
	//	self waittill( "cmd_done" );
	level waittill( "scene_anim_done" );

	self SetDeathEnable(true);
	self SetPainEnable(true);
	self DoDamage( 10000, self.origin );
}


//############################################################################
//	Show the final couple of guys come out and defend the door
//
e3_final_spawn()
{
	wait( 1.0 );

	//Michel
	//iprintlnbold("Last Guy");

	new_guys = maps\casino_util::spawn_guys( "cai_e3_oguy_doormen", true, "e3_ai", "thug_red" );

	for(i=0;i<new_guys.size; i++)
	{
		new_guys[i] maps\casino_util::SetPerfectSenseTimer(5.0);
	}

	wait(3);

	if (IsDefined(new_guys[0]) && IsAlive(new_guys[0]))
	{
		new_guys[0] maps\_utility::play_dialogue( "OSR3_CasiG01A_040A" );	// We must hold them here, comrade.
		wait(0.5);

		if (IsDefined(new_guys[1]) && IsAlive(new_guys[1]))
		{
			new_guys[1] maps\_utility::play_dialogue( "OSR4_CasiG01A_041A" );	// No one will pass.
			wait(0.5);
		}
	}

	// 	for ( i=0; i<level.oguys_barricade.size; i++ )
	// 	{
	// 		if ( IsAlive(level.oguys_barricade[i])
	// 		{
	// 			level.oguys_barricade[i].tetherradius = 350;
	// 		}
	// 	}

	while (1)
	{
		enemies = GetAIArray();
		if ( enemies.size == 0 )
		{
			wait( 2.0 );

			enemies = GetAIArray();
			if ( enemies.size == 0 )
			{
				level notify("endmusicpackage");
				break;
			}
		}
		wait( 1.0 );
	}
}


//############################################################################
//	e4_main - Courtyard
//
e4_main()
{
	level notify( "e4_start" );

	// Startup level effects
	level notify("drapes_2_start");

	// Spawn AI
	thugs = maps\casino_util::spawn_guys( "cai_e4", true, "e4_ai", "thug" );
	maps\casino_util::reinforcement_update( "cai_e4_reinforcements", "e4_ai", false );
	thread e4_conversation( thugs );

	// E5 handoff
	flag_wait( "obj_detour2_end");
	level thread e4_force_cover();

	//	SaveGame("e5");
	level thread e5_main();

	// cleanup
	level waittill( "e6_start" );
	maps\casino_util::delete_group( "e4_ai" );
	maps\casino_util::delete_group( "e4_ai_ledge" );
}
e4_force_cover()
{

	trigger = getent("balcony_2_force_cover", "targetname");
	trigger waittill("trigger");

	//iprintlnbold("cover check");
	level.player customcamera_checkcollisions( 0 );

// 	while ( !level.player isOnGround() )
// 	{
// 		wait( 0.05 );
// 	}
	while ( 1 )
	{
		level.player waittill( "mantle", msg );

		if ( msg == "end" )
		{
			break;
		}
	}

	level.player SetPlayerAngles((0,92,0));
	level.player playerSetForceCover(1);
	wait(0.05);
	level.player playerSetForceCover(0, 0);
	level.player customcamera_checkcollisions( 1 );
}

//############################################################################
//	setup the special balcony push quick kill anim
e4_conversation( talkers )
{
	
	for ( i=0; i<talkers.size; i++ )
	{
		talkers[i] endon( "alert_yellow" );
		talkers[i] endon( "alert_red" );
		talkers[i] endon( "death" );
		talkers[i] thread maps\casino_util::play_dialog_monitor( "conversation_done" );
		talkers[i] thread e4_kill_conversation(talkers);
	}

	talkers[1] maps\_utility::play_dialogue( "BCR2_CasiG01A_043A" );	// Ten million dollars?  Just to buy in to a card game?  How much is in the pot?

	talkers[0] maps\_utility::play_dialogue( "BCR1_CasiG01A_044A" );	// The winner will take a hundred million at least.

	talkers[1] maps\_utility::play_dialogue( "BCR2_CasiG01A_045A" );	// And this is how Le Chiffre expects to get back our money?
	talkers[1] notify( "conversation_done" );

	talkers[0] maps\_utility::play_dialogue( "BCR1_CasiG01A_046A" );	// He will not play by the rules.  He  is a desperate man.
	talkers[0] notify( "conversation_done" );

}
e4_kill_conversation(talkers)
{
	self endon("conversation_done");

	self waittill_any("death", "alert_red", "alert_yellow");
	
	for ( i=0; i<talkers.size; i++ )
	{	
		if(isdefined(talkers[i]))
		{
		talkers[i] playsound("null_voice");
		}
	}
}	
//############################################################################
//	e4_tether - Keep balcony guys from going to the side suite
e4_set_combat_tether( )
{
	level endon( "e5_start" );

	// wait until someone's alerted
	level waittill( "reinforcement_spawn" );

	wait(1.0);	// Give time for the reinforcements to spawn

	// Tether anyone on the balcony group
	tether = GetNode( "pn_e4_balcony", "targetname" );
	ents = GetAIArray();
	for ( i=0; i<ents.size; i++ )
	{
		if ( IsDefined(ents[i].groupname) && ents[i].groupname == "e4_ai" )
		{
			ents[i].tetherpt = tether.origin;
			ents[i].tetherradius = 500;
		}
	}
}


//############################################################################
//	e5_main - Suite
//
e5_main()
{
	level notify( "e5_start" );

	wait( 0.1 );
	// Spawn AI
	thugs = maps\casino_util::spawn_guys_ordinal( "cai_e5_", 0, true, "e5_ai", "thug" );

	// 	// Turn them off here
	// 	for (i = 0; i < thugs.size; i++)
	// 	{
	// 		thugs[i] SetEnableSense(false);
	// 	}

	level thread e5_hallway_thugs( thugs );

	level notify("playmusicpackage_stealth");

	flag_wait("cf_e5_patrol" );

	// Check to make sure no enemies are active or you will die on the ledge.
	level.special_autosavecondition = maps\casino_util::check_no_enemies_alerted;
	level thread maps\_autosave::autosave_by_name( "e5", 5.0 );

	wait( 0.1 );	// make sure the conversation has started
	maps\casino_util::reinforcement_update( "cai_e5_reinforcements", "e5_ai", false );

	// 	// Turn them on here
	// 	for (i = 0; i < thugs.size; i++)
	// 	{
	// 		thugs[i] SetEnableSense(true);
	// 	}

	// Set this up a little early for visibility
//	lock = GetEnt( "e6_door_button", "targetname" ) maps\_unlock_mechanisms::setup_lock("eleclock_1");
	//lock thread e6_door_lock();

	// E6 handoff
	trig = GetEnt("ctrig_e6_hallway", "targetname" );
	trig waittill( "trigger" );

	flag_set("obj_unlock_entrance_start");

	// clear special save condition;
	level.special_autosavecondition = undefined;

	level thread e5_tanner();

	level thread e6_main();

	// cleanup
	level waittill( "e6_inside_ballroom" );

	maps\casino_util::delete_group( "e5_ai" );
}


//############################################################################
//	two guys talking outside of the suite
//
e5_hallway_thugs( thugs )
{
	e5_conversation( thugs );

	// start patrolling
	thugs[0] StartPatrolRoute( "cpat_e5_northroom" );
	thugs[1] StartPatrolRoute( "cpat_e5_patrolintro" );
	thugs[1] thread e5_alter_route();
}


e5_conversation( thugs )
{
	for ( i=0; i<thugs.size; i++ )
	{
		thugs[i] endon("death");
		thugs[i] endon("alert_yellow");
		thugs[i] endon("alert_red");
	}
	flag_wait("cf_e5_patrol" );

	level notify( "playmusicpackage_stealth" );

	// Alerted
	if ( level.reinforcement_activated )
	{
		thugs[0] maps\_utility::play_dialogue( "STR1_CasiG01A_048A" );	// Tell Obanno there is trouble.  He must stay in the ballroom.

		thugs[1] maps\_utility::play_dialogue( "STR2_CasiG01A_049A" );	// You are not coming?

		thugs[0] maps\_utility::play_dialogue( "STR1_CasiG01A_050A" );	// Not ‘til I deal with our problem. I have a clear shot from the balcony.  Go!
	}
	else
	{
		for ( i=0; i<thugs.size; i++ )
		{
			thugs[i] endon("death");
			thugs[i] endon("alert_yellow");
			thugs[i] endon("alert_red");
		}

		thugs[1] maps\_utility::play_dialogue( "STR2_CasiG01A_051B" );	// Where is Obanno?

		thugs[0] maps\_utility::play_dialogue( "STR1_CasiG01A_052B" );	// In the ballroom with Le Chiffre.  Go.

		thugs[1] maps\_utility::play_dialogue( "STR2_CasiG01A_053B" );	// You are not coming?

		thugs[0] maps\_utility::play_dialogue( "STR1_CasiG01A_054B" );	// It is too quiet.  Something is not right.  I will keep watch from the balcony.
	}
}
//############################################################################
//	tanner and bond just before the ballroom

e5_tanner()
{

	level.player maps\_utility::play_dialogue( "TANN_CasiG01A_055A" );	// Bond, change in plan.  Le Chiffre never made it to Obanno’s room
	wait(0.5);
	level.player maps\_utility::play_dialogue( "BOND_CasiG01A_056A" );	// I know.  He’s in the ballroom
	wait(0.5);
	level.player maps\_utility::play_dialogue( "TANN_CasiG01A_057A" );	// That’s right.  Well done, Bond.

}


//############################################################################
//	This guy waits for you to see him and then starts moving
//
e5_alter_route()
{
	self endon("death");
	self endon("alert_yellow");
	self endon("alert_red");

	trig = GetEnt( "ctrig_e5_start_patrol", "targetname" );
	trig waittill( "trigger" );

	//	self StopPatrolRoute();
	//	wait(0.1);
	self StartPatrolRoute( "cpat_e5_patrol1" );
}


//############################################################################
//	e6_main - Conference room
//
e6_main()
{
	level notify( "reinforcement_stop" );
	level notify( "e6_start" );

	// Bar the doors to the room
	entrance_door1 = GetEnt( "door_e6_ballroom_entrance", "targetname" );
	entrance_door2 = GetEnt( "door_e6_ballroom_entrance2", "targetname" );
//	entrance_door1 maps\_doors::barred_door();
//	entrance_door2 maps\_doors::barred_door();

	flag_init( "e6_start_shooting" );
	flag_init( "e6_start_dialog" );

	//	level thread display_map_mainhall_first_floor();

	level thread kickover_table_setup();
	level thread e6_chandelier_trap();
	//	level thread helium_tank_setup();
	array_thread( GetEntArray("fxtrig_damage", "targetname"), ::e6_banner_drop );

	// Initialize the button to open the doors.
// 	maps\_playerawareness::setupSingleUseOnly(
// 		"e6_door_button",				//	awareness_entity_name,
// 		::e6_hack_door_control,			//	use_event_to_call,
// 		&"CASINO_HINT_OPEN_ENTRANCE",	//	hint_string, 
// 		0,								//	use_time, 
// 		"",								//	use_text, 
// 		false,						   	//	single_use, 
// 		true,							//	require_lookat, 
// 		undefined,						//	filter_to_call, 
// 		level.awarenessMaterialNone,	//	awareness_material, 
// 		true,							//	awareness_glow, 
// 		false,						   	//	awareness_shine, 
// 		false );					   	//	wait_until_finished )

	// Wait for the player to hit the switch to open the door
	entrance_door1 waittill( "unlocked" );

	holster_weapons();

//	flag_wait( "obj_unlock_entrance_end" );
	flag_set( "obj_unlock_entrance_end" );
	control = GetEnt( "e6_door_button", "targetname" );
//	control notify( "hacked" );
	control notify( "sound_done" );

	//unbar door	
//	entrance_door1 maps\_doors::unbarred_door();
//	entrance_door2 maps\_doors::unbarred_door();


	//iprintlnbold("Michel-E6");
	e6_thugs	= maps\casino_util::spawn_guys( "cai_e6", true, "e6_ai", "thug_yellow" );
	//iprintlnbold("Michel-E6-Delayed");
	thugs		= maps\casino_util::spawn_guys( "cai_e6_delayed", true, "e6_ai", "thug_yellow" );
	//xxx
	// 	for (i=0; i<thugs.size; i++)
	// 	{
	// 		thugs[i] e6_
	// 	}

	e6_thugs	= maps\casino_util::array_add_Ex( e6_thugs, thugs );

	blockers = GetEnt("ballroom_ai_blockers", "targetname");
	blockers ConnectPaths();
	blockers trigger_off();


	//iprintlnbold("Michel-Runner");
	// Spawn the guy who runs in from the hallway
	level.e6_runner = maps\casino_util::spawn_guys( "cai_e6_runner", true, "e6_ai", "thug_yellow" );

	//iprintlnbold("Michel-Leader");
	// Spawn leader guy
	level.e6_leader	= maps\casino_util::spawn_guys( "cai_e6_leader", true, "e6_ai", "thug_yellow" );

	// Spawn lechiffre and escorts
	//	level thread e6_lechiffre();

	//mini cutscene - lock player to cover
	//wait(0.1);	//for skipto to work, turn this on for skipto
	level thread e6_intro_setup();

	// Don't thread intro.  When it is done (either fully or prematurely, continue)
	level e6_intro( e6_thugs );
	level notify( "lechiffre_exit" );

	level thread e6_ballroom_fight( e6_thugs );

	trig = GetEnt( "ctrig_e6_final_door", "targetname" );
	trig waittill( "trigger" );

	//iprintlnbold("ctrig_e6_final_door");

	flag_set("obj_hack_door_end");

	// E7 handoff
	trig = GetEnt("ctrig_e7_obanno", "targetname" );
	trig waittill( "trigger" );

	//SaveGame("e7");
	level thread e7_main();

	// cleanup
	maps\casino_util::delete_group( "e6_ai" );
}


//############################################################################
//	Handles changing the light on the door lock.  Call on the entity that handles the lock script
//e6_door_lock()
//{
//	// Need to spawnfx so you can delete it!
//	fx = spawnfx( level._effect["door_lock_red"], self.origin+(-1.8, -1.5, 4), AnglesToForward(self.angles) );
//	triggerFx( fx );
//	self waittill( "hacked" );
//
//	fx delete();
//	fx = spawnfx( level._effect["door_lock_green"], self.origin+(-1.8, -1.5, 3), AnglesToForward(self.angles) );
//	triggerFx( fx );
//	SaveGame( "E6" );
//}


//############################################################################
//
// e6_hack_door_control(strcObject)
// {
// 	if ( !flag( "obj_unlock_entrance_start" ) )
// 	{
// 		flag_set( "obj_unlock_entrance_start" );
// 	}
// 
// 	control = strcObject.primaryEntity;
// 	control endon( "hacked" );
// 
// 	entOrigin = spawn("script_origin", level.player.origin + ( 0, 0, 7 ));
// 	entOrigin.targetname = "special_lockpick_origin";
// 	entOrigin.angles = level.player GetPlayerAngles();
// 
// 	control.lockparams = "complexity:2 speed:3 code:6";
// 
// 	if( control maps\_unlock_mechanisms::unlock_electronic() )
// 	{
// 		wait( 0.15 );
// 
// 		entOrigin Delete();
// 
// 		flag_set( "obj_unlock_entrance_end" );
// 
// 		control notify( "hacked" );
// 		control notify( "sound_done" );
// 	}
// 	else
// 	{
// 		wait( 0.15 );
// 
// 		entOrigin Delete();
// 
// 		maps\_playerawareness::setupSingleUseOnly( 
// 			"e6_door_button",				//	awareness_entity_name,
// 			::e6_hack_door_control,			//	use_event_to_call,
// 			&"CASINO_HINT_OPEN_ENTRANCE",	//	hint_string, 
// 			0,								//	use_time, 
// 			"",								//	use_text, 
// 			true,						   	//	single_use, 
// 			true,							//	require_lookat, 
// 			undefined,						//	filter_to_call, 
// 			level.awarenessMaterialNone,	//	awareness_material, 
// 			true,							//	awareness_glow, 
// 			false,						   	//	awareness_shine, 
// 			false );					   	//	wait_until_finished )
// 	}
// }


//############################################################################
//	Chandelier drop - make the chandelier drop if looking the right way
//	
e6_chandelier_drop()
{
	level endon("cf_e6_chandelier_fell");

	trig = GetEnt( "ctrig_e6_chandelier_lookat", "targetname" );
	trig waittill( "trigger" );

	dmg_trig = GetEnt( "trap_e6_chandelier", "targetname" );
	dmg_trig notify( "trigger" );
}


//############################################################################
//	Chandelier trap - watch it fall on people
//	
e6_chandelier_trap()
{
	flag_init("cf_e6_chandelier_fell");

	before_sbm	= GetEnt("csbm_e6_piano", "targetname" );
	after_sbm	= GetEnt("csbm_e6_piano_dmg", "targetname" );
	after_sbm ConnectPaths();
	after_sbm trigger_off();

	trig = GetEnt( "trap_e6_chandelier", "targetname" );
	trig waittill( "trigger" );

	flag_set("cf_e6_chandelier_fell");
	trig playsound( "CAS_piano_crash" );
	chandelier_light = GetEnt( "light_e6_chandelier", "targetname" );
	chandelier_light setlightintensity( 0.0 );
	chandelier_lit = GetEnt( "piano_chandelier_lit", "targetname" );
	chandelier_lit delete();
	level notify( "piano_chandelier_start" );	// send the chandelier crashing down
	level notify("piano_chandelier_d_start");
	/*level notify("fx_br_glass_burst_06");
	level notify("fx_br_glass_burst_07");
	level notify("fx_br_glass_burst_10");
	level notify("fx_br_glass_burst_11");
	wait(1);
	level notify("fx_br_glass_burst_01");
	level notify("fx_br_glass_burst_02");
	level notify("fx_br_glass_burst_03");
	level notify("fx_br_glass_burst_04");
	level notify("fx_br_glass_burst_05");
	level notify("fx_br_glass_burst_08");
	level notify("fx_br_glass_burst_09");
	level notify("fx_br_glass_burst_12");
	level notify("fx_br_glass_burst_13");
	level notify("fx_br_glass_burst_14");
	level notify("fx_br_glass_burst_15");
	level notify("fx_br_glass_burst_16");*/
	wait(2.6);

	damage_spot = GetEnt( "cso_e6_chandelier_trap", "targetname" );
	if ( IsDefined( damage_spot ) )
	{
		RadiusDamage( damage_spot.origin, 125, 200, 100 );
		earthquake( 0.2, 1, damage_spot.origin, 5000);
	}

	after_sbm trigger_on();
	after_sbm DisConnectPaths();

	if (level.player IsTouching(after_sbm))
	{
		level.player DoDamage(level.player.health * 2, (0, 0, 0));	// _brian_b_: the radius damage wasn't killing the player sometimes, and he would get stuck in the clip
	}

	before_sbm delete();
}



//############################################################################
//	Drop a banner when shot
//	
e6_banner_drop()
{
	if ( IsDefined(self.script_parameters) )
	{
		self waittill( "trigger" );

		level notify( self.script_parameters );
		self playsound( "CAS_banner_big_fall" );
		//		self playsound( "CAS_banner_small_fall" );
	}
}


//############################################################################
//	Handles Le Chiffre and escorts actions
//	
e6_lechiffre()
{

	//iprintlnbold("Michel-LeChiffreEscort");
	// Spawn Le Chiffre guards
	lechiffre_guards	= maps\casino_util::spawn_guys_ordinal( "cai_e6_lechiffre_escort", 1, true, "e6_ai", "thug" );
	for ( i=0; i<lechiffre_guards.size; i++ )
	{
		lechiffre_guards[i] LockAlertState("alert_yellow");
		lechiffre_guards[i] thread maps\casino_util::delete_on_goal();
	}
	// Make one guy keep running no matter what
	lechiffre_guards[1] setenablesense( false );


	//iprintlnbold("Michel-LeChiffre");
	// Spawn Le Chiffre
	lechiffre			= maps\casino_util::spawn_guys( "cai_e6_lechiffre", true, "e6_ai", "civ" );
	lechiffre LockAlertState("alert_yellow");
	lechiffre thread maps\casino_util::delete_on_goal();
	lechiffre setenablesense( false );

	level waittill( "lechiffre_exit" );

	// Send lechiffre to Obanno's room
	node = GetNode( "cn_e6_lechiffre_suite", "targetname" );
	lechiffre SetGoalNode( node );
	for ( i=0; i<lechiffre_guards.size; i++ )
	{
		lechiffre_guards[i] SetGoalNode( node );
	}

	wait( 8 );
	exit_door1 = GetEnt( "door_e6_ballroom", "targetname" );
	exit_door2 = GetEnt( "door_e6_ballroom2", "targetname" );

	//exit_door1._doors_barred = true;
	//exit_door2._doors_barred = true;
	exit_door1 maps\_doors::barred_door();
	exit_door2 maps\_doors::barred_door();


}


//############################################################################
//	Event Intro dialog
//	
e6_intro( e6_thugs )
{
	level endon( "reinforcement_spawn" ); // Bond spotted

	level notify( "e6_intro_start" );

	// Find the thug who needs to speak
	ballroom_speaker = undefined;	// variable declaration for scope purposes
	for ( i=0; i<e6_thugs.size; i++ )
	{
		if ( IsDefined( e6_thugs[i].script_parameters ) &&
			e6_thugs[i].script_parameters == "intro_speaker" )
		{
			ballroom_speaker = e6_thugs[i];
			ballroom_speaker endon( "death" );
			break;
		}
	}

	wait(5.0);

	level.e6_runner maps\_utility::play_dialogue( "SRC1_CasiG01A_058A" );	// Where are they?  Le Chiffre’s men!

	ballroom_speaker maps\_utility::play_dialogue( "BRR1_CasiG01A_059A" );	// We have seen no one.

	level.e6_runner maps\_utility::play_dialogue( "SRC1_CasiG01A_062A" );	// Ten men at least.  They killed a dozen of our soldiers in the spa.

	level.e6_leader maps\_utility::play_dialogue( "OBAN_CasiG01A_063A" );	// We will take Le Chiffre to my room.  The rest of you stay here.  We must hold this place.

	ballroom_speaker maps\_utility::play_dialogue( "BRR1_CasiG01A_064A" );	// Yes Obanno.
}



//lock bond to cover
e6_intro_setup()
{

	level.player freezeControls(true);	

	//if playing through - needs to stick to counter like on skiptos - fix
	skipto = GetDVar( "skipto" );
	if ( skipto == "" )
	{
		//so player is in right spot

	}
	start_pos = GetNode( "cn_e6_start", "targetname" );
	level.player setorigin( start_pos.origin );
	level.player setplayerangles( start_pos.angles );

	wait( 0.3 );	//to let bond get into cover
	
	level.player playerSetForceCover( true, (0,-1,0) );
	level thread maps\_utility::letterbox_on(false);
	//add letterbox
	//( take_weapons, allow_look, time, playerstick )
//	level thread letterbox_on( false, true, undefined, false );

	level waittill("lechiffre_exit");

//	letterbox_off( true );
	level.player playerSetForceCover( false, true ); //for demo, intermittent bug where bond becomes crab when forced off
	level.player freezeControls(false);
	maps\_utility::letterbox_off();
	unholster_weapons();

	wait(0.5);
	//savegame	
	level thread maps\_autosave::autosave_now( "e6" );
}


//############################################################################
//	Turn the AI aware if you kill runner
//
e6_ballroom_watcher()
{
	level endon( "reinforcement_spawn" );

	//	// Wait until the player enters and gets further in
	//	trig = GetEnt("ctrig_e6_con_room_inside", "targetname" );
	//	trig waittill( "trigger" );

	//if he gets killed from afar
	while (Isalive(	level.e6_runner ) )
	{
		wait( 0.1 );
	}

	if( !	flag( "e6_start_dialog" ))
	{
		flag_set( "e6_start_dialog" );
		level.player maps\_utility::play_dialogue( "BRR2_CasiG01A_065A" );	// They come!
		level.player maps\_utility::play_dialogue( "BRR3_CasiG01A_066A" );	// Stop them!
	}

	ais = GetAIArray();
	for ( i=0; i<ais.size; i++ )
	{
		ais[i] thread maps\casino_util::reinforcement_awareness();
	}
}

//############################################################################
//	Kick off fight intro when player enters
//
e6_ballroom_fight( e6_thugs )
{
	//	player_stick( true );
	//	level.player freezeControls(true);
	//	holster_weapons();

	// 	script_origin = GetEnt( "cso_e6_fight", "targetname" );
	// 	level.sticky_origin MoveTo(		script_origin.origin, 3.0 );
	// 	level.sticky_origin RotateTo(	script_origin.angles, 3.0 );

	level thread e6_ballroom_doors();	//close the doors once you enter ballroom

	level thread e6_ballroom_watcher();
	level waittill( "reinforcement_spawn" );

	flag_set( "e6_start_shooting" );
	flag_set("obj_hack_door_start");

	level thread e6_enemy_controller( e6_thugs );
	
	//Play Ballroom Battle Music	
	level notify( "playmusicpackage_ballroom" );

	if(!flag( "e6_start_dialog" ))
	{
		flag_set( "e6_start_dialog" );
	
		level.player maps\_utility::play_dialogue( "BRR2_CasiG01A_065A" );	// They come!
		level.player maps\_utility::play_dialogue( "BRR3_CasiG01A_066A" );	// Stop them!

		ais = GetAIArray();
		for ( i=0; i<ais.size; i++ )
		{
			ais[i] thread maps\casino_util::reinforcement_awareness();
		}
	}
}


//close the doors when bond in ballroom -jc
e6_ballroom_doors()
{
	// Wait until the player enters and gets further in
	trig = GetEnt("ctrig_e6_con_room_inside", "targetname" );
	trig waittill( "trigger" );

	level notify( "e6_inside_ballroom" );
	
	//iprintlnbold("e6_inside_ballroom");

	// Okay, lock the doors and update objective
 	entrance_door1 = GetEnt( "door_e6_ballroom_entrance", "targetname" );
 	entrance_door2 = GetEnt( "door_e6_ballroom_entrance2", "targetname" );

	level thread display_map_mainhall_second_floor();

	//close sesame
 	entrance_door1 thread maps\_doors::close_door();
 	entrance_door2 thread maps\_doors::close_door();

	// Bar the doors to the entrance
 	entrance_door1 maps\_doors::barred_door();
 	entrance_door2 maps\_doors::barred_door();

	// Bar the doors to the exit
	exit_door1 = GetEnt( "door_e6_ballroom", "targetname" );
	exit_door2 = GetEnt( "door_e6_ballroom2", "targetname" );
	exit_door1 maps\_doors::barred_door();
	exit_door2 maps\_doors::barred_door();

	//wake up if you try to sneak in
	if( !	flag( "e6_start_shooting" ))
	{
		ais = GetAIArray();
		for ( i=0; i<ais.size; i++ )
		{
			ais[i] thread maps\casino_util::reinforcement_awareness();
		}
	}
	//moved so lines play earlier
	if( !	flag( "e6_start_dialog" ))
	{
		flag_set( "e6_start_dialog" );
		level.player maps\_utility::play_dialogue( "BRR2_CasiG01A_065A" );	// They come!
		level.player maps\_utility::play_dialogue( "BRR3_CasiG01A_066A" );	// Stop them!
	}
}

// ############################################################################
// Helium tanks setup
// helium_tank_setup()
// {
//     tank = GetEntArray ( "pipe_shootable", "targetname" );
//     for ( i = 0; i<tank.size; i++ )
//     {
// 		tank[i].health = 150;
// 		tank[i] thread physic_tank_radius();
//     }
// }
// 
// ############################################################################
// Helium tanks wait for damage then explode
// physic_tank_radius()
// {
// 	self setcandamage(true);
// 	self waittill ( "damage" );
// 	self playsound( "CAS_helium_tanks" );
// 	wait( 2 );
// 	self hide();
// 	fx = playfx (level._effect["casino_tank_explosion"], self.origin);
// 	physicsExplosionSphere( self.origin, 200, 100, 5 );
// 	radiusdamage( self.origin + ( 0, 0, 36 ), 200, 150, 200 );
// 	earthquake( 0.3, 1, self.origin, 400 );
// }


//############################################################################
// kickover table setup
kickover_table_setup( )
{

	table_origins = GetEntArray( "kickover_table_origin", "targetname" );
	for ( i=0; i<table_origins.size; i++)
	{
		table = GetEnt( table_origins[i].target, "targetname" );

		// link all connected objects to the parent
		attachments = GetEntArray( table.target, "targetname" );
		for ( j=0; j<attachments.size; j++ )
		{
			attachments[j] LinkTo(table);
		}

		// Get valid yaw and rotate them so they're standing up.
		yaw = table_origins[i].angles[1];
		while ( yaw > 359 )
		{
			yaw = yaw - 360;
		}
		while ( yaw < 0 )
		{
			yaw = yaw + 360;
		}
		//	0
		if ( yaw > -5 && yaw < 5 )				
		{
			rotate_angles = (  -90,   0,   0);
		}
		//	45
		else if ( yaw > 40 && yaw < 50  )
		{
			rotate_angles = ( 315, 315,   90);
		}
		//	90
		else if ( yaw > 85 && yaw < 95  )
		{
			rotate_angles = (   0,   0, 90);
		}
		//	135
		else if ( yaw > 130 && yaw < 140  )
		{
			rotate_angles = (  45,  45,  90);
		}
		//	180
		else if ( yaw > 175 && yaw < 185 )
		{
			rotate_angles = ( 90,   0,   0);
		}
		//	225
		else if ( yaw > 220 && yaw < 230  )
		{
			rotate_angles = (  45, 315, -90);
		}
		//	270
		else if ( yaw > 265 && yaw < 275 )
		{
			rotate_angles = (   0,   0, -90);
		}
		//	315
		else if ( yaw > 310 && yaw < 320 )
		{
			rotate_angles = ( 315,  45, -90);
		}
		else
		{
			/#
				//iprintlnbold("Invalid angle: " + yaw );
#/
			return;
		}
		table RotateTo( rotate_angles, 0.05, 0.0, 0.0 );

		// Start useable tables kicked over
		//		if ( IsDefined(table_origins[i].script_noteworthy) && table_origins[i].script_noteworthy == "usable" )
		// 		{
		// 			maps\_useableObjects::create_useable_object( 
		// 				table_origins[i],		//	entities, 
		// 				::use_kickover_table,	//	use_event_to_call
		// 				"Kick Table",			//	hint_string
		// 				0,						//	use_time
		// 				"",						//	use_text
		// 				true,					//	single_use
		// 				true,					//	require_lookat
		// 				true );					//	initially_active
		// 		}
		// 		else
		//		{
		table_origins[i] thread kickover_table();
		//		}
	}
}

//############################################################################
// Use Kickover table for cover
//		Hacky McHaxxor :  This shit only works if the tables are 45 degree yaw angles.  Sorry Charlie
//
use_kickover_table( player )
{
	script_origin = self.entity;

	table = GetEnt( script_origin.target, "targetname" );
	switch( RandomInt(3) )
	{
	case 0:
		table playsound( "CAS_table_01" );
		break;
	case 1:
		table playsound( "CAS_table_02" );
		break;
	case 2:
		table playsound( "CAS_table_03" );
		break;
	}
	table RotateTo( (0,0,0), 0.5, 0.2, 0.0 );
	force = AnglesToForward( (0, script_origin.angles[1], 45) ) * 1.5;
	physicsJolt( script_origin.origin, 64, 0, force );
}


//############################################################################
// Use Kickover table for cover
//		Hacky McHaxxor :  This shit only works if the tables are 45 degree yaw angles.  Sorry Charlie
//		
kickover_table( )
{
	table = GetEnt( self.target, "targetname" );

	//Table Flip doesnt look good because no AI has an animation to play
	// SO it is better to flip them before we get there than seing table flipping magically
	//level waittill( "reinforcement_spawn" );
	
	wait( RandomFloatRange(0.1, 1.0) );	//lower the wait so it's faster -jc

	/*
	switch( RandomInt(3) )
	{
	case 0:
		table playsound( "CAS_table_01" );
		break;
	case 1:
		table playsound( "CAS_table_02" );
		break;
	case 2:
		table playsound( "CAS_table_03" );
		break;
	}*/

	table RotateTo( (0,0,0), 0.5, 0.2, 0.0 );
	force = AnglesToForward( (0, self.angles[1], 45) ) * 1.5;
	physicsJolt( self.origin, 64, 0, force );
	//	table DisconnectPaths();
	//	iPrintLnBold( "rotate to: " + rotate_angles[0] + "," + rotate_angles[1] + "," + rotate_angles[2] );
}


//
//	Setup AIs at start
//
e6_aimat_player()
{
	self endon( "death" );

	self SetPerfectSense( true );
	wait( 2.0 );

	self SetPerfectSense( false );
	self SetScriptSpeed( "run" );
	self setignorethreat( level.player, true );
	self waittill("goal");

	self CmdAimatEntity( level.player, true, -1 );
	flag_wait( "e6_start_shooting" );

	self stopallcmds();
	self setignorethreat( level.player, false );
}


WaitLessThanEqualAlive(thugs, count, timeout)
{	
	waitTime = 0.1;

	if( !IsDefined(timeout) )
	{
		timeout = 10000000;		
	}

	while ( thugs.size > count && timeout > 0 )
	{
		wait(waitTime);

		thugs = array_removeDead( thugs );
		
		timeout -= waitTime;
	}
}

//**************************************************************
//**************************************************************

E6Wave2Rusher()
{
	self endon("death");

	//self SetCombatRole("Rusher");
	self SetPerfectSense(1);		//SHould already be in perfect sense but just in case

	self.tetherradius = -1;
/*
	while( IsDefined(self) )
	{
		wait(0.5);
	}
*/
}

//**************************************************************
//**************************************************************

E6Wave2PickRusher( wave_2 )
{		
	chosen = wave_2[0];
	for( i=0; i<10; i++ )
	{
		attempt = wave_2[randomint(wave_2.size)];
		if( IsDefined(chosen) && chosen.tetherradius > 0 )
		{
			chosen = attempt;
		}
	}

	return chosen;
}

//**************************************************************
//**************************************************************

E6Wave2TetherTweaker(time0, time1, rate0, rate1)
{
	self endon("death");

	//Time Before we start
	wait( RandomFloatRange( time0, time1 ) );

	while(1)
	{
		self.tetherradius += RandomFloatRange( rate0, rate1 );		

		wait(1);
	}
}

//**************************************************************
//**************************************************************

E6Wave2AutoRusher( wave_2, time0, time1, rate0, rate1)
{
	for( i=0; i < wave_2.size ; i++ )
	{	
		if( IsDefined(wave_2[i]) )
		{		
			wave_2[i] thread E6Wave2TetherTweaker( time0, time1, rate0, rate1);
		}
		
		/*
		wait( RandomFloatRange( time0, time1 ) );
		
		wave_2 = array_removeDead( wave_2 );

		if( wave_2.size > 0 )
		{
			rusher = E6Wave2PickRusher( wave_2 );

			if( IsDefined(rusher) )
			{
				rusher E6Wave2Rusher();
			}		
		}

		wave_2 = array_removeDead( wave_2 );*/
	}
}


//**************************************************************
//**************************************************************
 
 _IsLeftFarter( spawnersLeftName, spawnersRightName, randomDist )
 { 
	spawnersLt = GetEntArray( spawnersLeftName, "targetname" );
	distLt     = DistanceSquared(spawnersLt[0].origin, self.origin) + randomfloat(randomDist*randomDist);

	spawnersRt = GetEntArray( spawnersRightName, "targetname" );
	distRt     = DistanceSquared(spawnersRt[0].origin, self.origin) + randomfloat(randomDist*randomDist);

	return distLt > distRt;
 }

//**************************************************************
//**************************************************************

//
//
// Maintain control of enemies and spawn new ones as needed.
e6_enemy_controller( enemies )
{
	level endon( "e7_start" );

	trig_east		= GetEnt( "ctrig_e6_east_side",			"targetname" );
	trig_west		= GetEnt( "ctrig_e6_west_side",			"targetname" );
	trig_northwest	= GetEnt( "ctrig_e6_northwest_side",	"targetname" );

	// Only run this if the player has been spotted
	//level waittill( "reinforcement_spawn" );	//never gets in here? -jc

	// 			shooter = maps\casino_util::spawn_guys( "cai_e6_glassshooter", true, "e6_ai", "thug_red" );
	// 			shooter thread e6_shoot_ceiling();

	// Tether guys to middle of room
	wait 1;
	center_of_room = GetEnt("center_of_room", "targetname").origin;
	for (i = 0; i < enemies.size; i++)
	{
		if (IsDefined(enemies[i]))
		{
			enemies[i].tetherpt = center_of_room;
			enemies[i].tetherradius = 450; //Michel
			//enemies[i].tetherradius = 120;
		}
	}



	// When we get down to a few, make them rush
	//	while (1)
	//	{
	//		enemies = array_removeDead( enemies );
	//
	//		// Make the last guys rushers
	//		if ( enemies.size < 3 )
	//		{
	//			for ( i=0; i<enemies.size; i++ )
	//			{
	////				enemies[i] SetCombatRole( "rusher" );
	//				enemies[i] SetPerfectSense( true );
	//				enemies[i] SetScriptSpeed( "run" );
	//			}
	//			break;
	//		}
	//		wait(1.0);
	//	}

	// Wave 2
	//while (1)
	//{
	//	enemies = array_removeDead( enemies );
	//	if ( enemies.size <= 0 )
	//	{
	blockers = GetEnt("ballroom_ai_blockers", "targetname");
	blockers trigger_on();
	blockers DisconnectPaths();

	flag_wait("cai_e6_wave1_cleared");

	// unblocked AI from going upstairs
	blockers ConnectPaths();
	blockers delete();

	//iprintlnbold("Michel-0");

	// trigger next wave when player goes into the middle of the room
	next_wave_trig = Spawn("trigger_radius", center_of_room, 0, 300, 100);	//changed radius to 300 so easier to trigger -jc

	//---------------------------
	//Dont wait for anything... it is confusing and also if we wait a little bit the player can get to a bad spot
	// at least, if we spawn right here, we know he must be in a position where he can shoot AI at the center of the ballroom
	//---------------------------
	//next_wave_trig = GetEnt("trigger_wave2", "targetname");
	//next_wave_trig waittill("trigger");
	//next_wave_trig wait_for_trigger_or_timeout(5);

	//iprintlnbold("Michel-1");

	//wait( 2.0 );	// Let the last AI die.

	level thread maps\_autosave::autosave_by_name( "E6B" );

	wait( randomfloatrange(3.0,4.0) );	//too long a pause-jc

	//Try to avoid spawning guys in the back of the player
	//Add some randomness, when the difference isnt that great
	if( level.player _IsLeftFarter("cai_e6_wave2a", "cai_e6_wave2b", 12*100) )
	{
		wave_2a   = maps\casino_util::spawn_guys( "cai_e6_wave2a", true, "e6_ai", "thug_red" );

		WaitLessThanEqualAlive(wave_2a, 1, 10);
		
		//iprintlnbold( "Spawn-B" );

		wave_2b = maps\casino_util::spawn_guys( "cai_e6_wave2b", true, "e6_ai", "thug_red" );
	}
	else
	{	
		wave_2b  = maps\casino_util::spawn_guys( "cai_e6_wave2b", true, "e6_ai", "thug_red" );		

		WaitLessThanEqualAlive( wave_2b, 1, 10);
		
		//iprintlnbold( "Spawn-A" );

		wave_2a = maps\casino_util::spawn_guys( "cai_e6_wave2a", true, "e6_ai", "thug_red" );
	}

	wave_2  = maps\casino_util::array_add_Ex( wave_2a, wave_2b );

	thread E6Wave2AutoRusher( wave_2, 15.0, 30.0, 12*0.5, 12*3 );

	enemies = maps\casino_util::array_add_Ex( enemies, wave_2    );


	enemies = array_removeDead( enemies);
	
	//level.player PlaySound( "CAS_big_door_01" );	//xxx play on player so he hears it for now.
	//level thread play_door_sounds();
	level.player PlaySound("CAS_secondwave_door_crash");

	enemies[ RandomInt(enemies.size)] thread e6_announce_arrival();

	wait( 3.0 );	//

	//			level thread e6_party_time();
	//	break;
	//}

	wait 1.0;
	//}


	//iprintlnbold("Michel-3");


	/* MICHEL-REVERT
	*/
	// When we get down to a few, make them rush
	watch_chandelier = true;
	while (1)
	{
		enemies = array_removeDead( enemies );

		if ( watch_chandelier && enemies.size < 4 )
		{
			watch_chandelier = false;
			if ( !flag("cf_e6_chandelier_fell") )
			{
				level thread e6_chandelier_drop();
			}
			break;
		}
		//else if ( enemies.size < 3 )
		//{
		//	for ( i=0; i<enemies.size; i++ )
		//	{
		//		enemies[i] SetCombatRole( "rusher" );
		//		enemies[i] SetPerfectSense( true );
		//		enemies[i] SetScriptSpeed( "run" );
		//	}
		//	break;
		//}
		wait(0.5);
	}

	/* MICHEL-REVERT
	*/
	while (1)
	{
		enemies = array_removeDead( enemies );
		if ( enemies.size < 3 )
		{
			// _brian_b_ : added lookat trigger for spawning waves
			trig = GetEnt("lookat_glass_shooters", "targetname");
			trig wait_for_trigger_or_timeout(10);
			trig delete();

			//iprintlnbold("Michel-Glass Escort");
			escort  = maps\casino_util::spawn_guys( "cai_e6_glass_escort", true, "e6_ai", "thug_red" );			
			enemies = maps\casino_util::array_add_Ex( enemies, escort  );

			wait( 5 );
			
			shooter = maps\casino_util::spawn_guys( "cai_e6_glassshooter", true, "e6_ai", "thug_red" );
			shooter thread e6_shoot_ceiling();
			enemies = maps\casino_util::array_add_Ex( enemies, shooter );

			break;
		}

		wait 0.5;
	}

	// Wave 3
	while (1)
	{
		wait( 0.5 );
		
		//iprintlnbold( "" + enemies.size );

		enemies = array_removeDead( enemies );

		//enemies = GetAIArray();
		if ( enemies.size <= 0 )
		{

			level thread maps\_autosave::autosave_by_name("e6-Last");

			// Unbar the doors to the room and let you leave...
			exit_door1 = GetEnt( "door_e6_ballroom", "targetname" );
			//exit_door1._doors_barred	= false;
			exit_door1 maps\_doors::unbarred_door();
			exit_door1._doors_auto_close	= false;

			exit_door2 = GetEnt( "door_e6_ballroom2", "targetname" );
			//exit_door2._doors_barred		= false;
			exit_door2 maps\_doors::unbarred_door();

			exit_door2._doors_auto_close	= false;
			flag_set("obj_hack_door_end");

			wait( 1.0 );

/*			Michel... not sure what this does
			nextToDoorTimer = 0;
			while( level.player IsTouching(trig_northwest) && nextToDoorTimer < 10.0 )
			{
				nextToDoorTimer += 0.05;
				wait(0.05);
			}

			// _brian_b_ : added lookat trigger for spawning waves
			trig = GetEnt("lookat_wave3", "targetname");
			trig wait_for_trigger_or_timeout(25);
			trig delete();
*/

			//iprintlnbold("Michel-Wave-3");

			enemies_a = maps\casino_util::spawn_guys( "cai_e6_wave3a", true, "e6_ai", "thug_red" );
			wait(5);
			enemies_b = maps\casino_util::spawn_guys( "cai_e6_wave3b", true, "e6_ai", "thug_red" );
			
			enemies   = maps\casino_util::array_add_Ex( enemies_a, enemies_b );

			thread e6_announce_arrivalFinal(enemies);
			//for ( i=0; i<enemies.size; i++ )
			//{
			//	enemies[i] thread maps\casino_util::reinforcement_awareness();
			//}

			//maps\casino_util::spawn_guys( "cai_e6_glass_escort", true, "e6_ai", "thug_red" );
			//shooter = maps\casino_util::spawn_guys( "cai_e6_glassshooter", true, "e6_ai", "thug_red" );
			//shooter thread e6_shoot_ceiling();
			
		
			break;
		}
	}

	//while (1)
	//{
	//	enemies = array_removeDead( enemies );
	//	if ( enemies.size <= 1 )
	//	{
	//		trig = GetEnt( "ctrig_e6_chandelier_lookat", "targetname" );	// _brina_b_ : trigger the chandelier if the player hasn't looked at it yet
	//		if (IsDefined(trig))
	//		{
	//			trig notify( "trigger" );
	//		}

	//		break;
	//	}

	//	wait 0.5;
	//}

	//while (1)
	//{
	//	//enemies = array_removeDead( enemies );
	//	enemies = GetAIArray();
	//	if (enemies.size <= 0)
	//	{

	//		// Unbar the doors to the room and let you leave...
	//		exit_door1 = GetEnt( "door_e6_ballroom", "targetname" );
	//		//exit_door1._doors_barred	= false;
	//		exit_door1 maps\_doors::unbarred_door();
	//		exit_door1._doors_auto_close	= false;

	//		exit_door2 = GetEnt( "door_e6_ballroom2", "targetname" );
	//		//exit_door2._doors_barred		= false;
	//		exit_door2 maps\_doors::unbarred_door();

	//		exit_door2._doors_auto_close	= false;
	//		break;
	//	}
	//	wait .5;
	//}

	//iprintlnbold("Michel-6");
	// Wait for guys to be dead
	while (1)
	{
		ents = GetAIArray();
		if ( ents.size == 0 )
		{				
			//End Ballroom Music, Start Ambient
			level notify("playmusicpackage_start");
			
			trig = GetEnt( "ctrig_e6_chandelier_lookat", "targetname" );	// _brina_b_ : trigger the chandelier if the player hasn't looked at it yet
			if (IsDefined(trig))
			{
				trig notify( "trigger" );
			}
		}

		if ( ents.size == 0 )
		{
			flag_set("obj_hack_door_end");
			// 			level thread e7_main();
			break;
		}
		wait( 1.0 );
	}
}

play_door_sounds()
{
	for (i = 0; i < 10; i++)
	{
		level.player PlaySound( "CAS_big_door_01" );
		wait RandomFloatRange(.5, 1.5);
	}
}

e6_announce_arrival()
{
	self endon( "death" );

	wait( 2.0 );
	if ( RandomInt(100) < 50 )
	{
		self thread maps\_utility::play_dialogue( "BRR6_CasiG01A_069A" );	// There’s only one!  Kill him!
	}
	else
	{
		self thread maps\_utility::play_dialogue( "BRR5_CasiG01A_068A" );	// This is for those you killed!
	}

}


//############################################################################
//	Second wave of guys pops out
//
e6_announce_arrival2( thug )
{
	self endon( "death" );

	if ( RandomInt(100) < 50 )
	{
		self thread maps\_utility::play_dialogue( "BRR6_CasiG01A_069A" );	// There’s only one!  Kill him!
	}
	else
	{
		self thread maps\_utility::play_dialogue( "BRR8_CasiG01A_071A" );	// Careful comrades!  This one is not easy to kill.
	}
}


//############################################################################
//
e6_announce_arrivalFinal( thugs )
{
	wait(2);

	//iprintlnbold("OPEN DOOR");

	level.player PlaySound( "CAS_big_door_01" );	//xxx play on player so he hears it for now.

	wait( 2 );

	for( i = 0 ; i < thugs.size; i++ )
	{	
		if( IsDefined(thugs[i]) )
		{
			//iprintlnbold("TALK");

			thugs[i] thread maps\_utility::play_dialogue( "BRR7_CasiG01A_070A" );	// Stop him!  He cannot follow Obanno!
			break;
		}
	}
}

//############################################################################

e6_party_time()
{
	level endon( "e6_end_sparks" );

	level notify("ballroom_sparks1_fx");
	wait(0.5);
	level notify("ballroom_sparks2_fx");
	wait(0.5);

	num_fx = 2;
	while(1)
	{
		for ( i=1; i<num_fx; i++ )
		{
			level notify("ballroom_confetti"+i+"_fx");
			wait(0.5);
		}
		wait(6); //you can make this wait longer, but making it shorter will effect the frame rate 
	}
}


//############################################################################
//	Guy shoots into the air as he dies and parts of the ceiling fall down
e6_shoot_ceiling()
{
	self endon("death");

	wait( 0.1 );
	//Michel : I remove magic bullet because you could be on the AI way and he will stop fighting you but would be unkillable
	//		   It is better to loose that cool moment and avoid feeling like we cheat
	//self thread magic_bullet_shield();

	self waittill( "goal" );	// don't die until you reach your goal

	//self stop_magic_bullet_shield();
	self SetDeathEnable(false);
	self SetPainEnable(false);
	self.tetherradius = 192;
	self waittill( "damage" );	// now wait till you get shot

	//self CmdPlayAnim( "Thug_ShootAirDeath2", false );	//add to generic_human and test -jc
	self CmdPlayAnim( "Thug_ShootAirDeath", false, true );
	wait(0.05);

	self StartRagdoll();
	level thread shatter_glasses();
	self waittill( "cmd_done" );
	self becomecorpse();




	alpha[0] = "a";
	alpha[1] = "b";
	alpha[2] = "c";
	alpha[3] = "d";
	glass = [];	// scope
	for ( i=1; i<=4; i++ )
	{
		for( j=0; j<=3; j++ )
		{
			glass[ glass.size ] = "" + i + alpha[j];
		}
	}

	array_randomize( glass );	//so it isn't always the same

	// now scramble it
	//	for (k=0; k<glass.size; k++ )
	//	{
	//		new_slot = RandomInt(glass.size);
	//		temp				= glass[ k ];
	//		glass[ k ]	= glass[ new_slot ];
	//		glass[ new_slot ]	= temp;
	//	}
	
	//drop the chandelier here if it hasn't fallen
	if ( !flag("cf_e6_chandelier_fell") )
	{
		//dmg_trig = GetEnt( "trap_e6_chandelier", "targetname" );
		//dmg_trig notify( "trigger" );

		level thread e6_chandelier_drop(); // _brian_b_: still wait till the player looks at it
	}

	level waittill( "demo_end" );

	//finale - break the last glass
	if( i >= 16 ) 
	{
		for (i=13; i<16; i++ )
		{
			level notify( "ballroom_glass_burst" + glass[i] );	
			wait(0.2);
		}
	}
}



show_shatter_glasses()
{
/#
	origin = self.origin;

	while(1)
	{	
		Print3D(origin, "GLASS");
		wait(0.05);
	}
#/
}


shatter_glasses()
{
	glasses = getentarray("glass_origin_1", "targetname");
	for (i=0; i<glasses.size; i++ )
	{
		//level notify( "ballroom_glass_burst" + glass[i] );
		if(randomint(10) >= 5)
		{
			//glasses[i] thread show_shatter_glasses();

			//If Radius is too big, it can get to the player and kill him
			glasses[i] radiusdamage( glasses[i].origin, 120, 3000, 3000 );
			wait(0.1);
		}
	}


}

//############################################################################
//	e6_tether - Put guys by the door
e6_last_stand( )
{
	wait(1.0);	// Give time for the reinforcements to spawn

	// Tether anyone on the balcony group
	tether = GetNode( "cn_e6_rallypoint", "targetname" );
	ents = GetAIArray();
	ents[0] thread maps\_utility::play_dialogue( "BRR7_CasiG01A_070A" );	// Stop him!  He cannot follow Obanno!
	for ( i=0; i<ents.size; i++ )
	{
		if ( IsDefined(ents[i].groupname) && ents[i].groupname == "e6_ai" )
		{
			ents[i].tetherpt = tether.origin;
			ents[i].tetherradius = 350;
		}
	}
}



//############################################################################
//	Last couple of guys open the way
//
e6_final_spawn()
{
	level endon( "e7_start" );

	// Unbar the doors to the room
	exit_door1 = GetEnt( "door_e6_ballroom", "targetname" );
	//exit_door1._doors_barred		= false;
	exit_door1 maps\_doors::unbarred_door();

	exit_door1._doors_auto_close	= false;

	exit_door2 = GetEnt( "door_e6_ballroom2", "targetname" );
	//exit_door2._doors_barred		= false;
	exit_door2 maps\_doors::unbarred_door();

	exit_door2._doors_auto_close	= false;

	// Spawn the final guys
	
	//iprintlnbold("Michel-reinforcements_final3");
	killaz = maps\casino_util::spawn_guys( "cai_e6_reinforcements_final", true, "e6_ai", "thug_red" );
	trig = GetEnt("ctrig_e6_final_door", "targetname" );



	while ( 1 )
	{
		trig waittill( "trigger" );

		killaz = array_removeDead( killaz );
		if ( killaz.size == 0 )
		
		{
			//			maps\_endmission::nextmission("barge");
	
			return;
		}

		for ( i=0; i<killaz.size; i++ )
		{
			if ( isalive( killaz[i] ) )
			{
				killaz[i] cmdshootatentity( level.player, true, -1, 1 );
			}
		}

		wait( 1.0 );

		if ( level.player IsTouching(trig) )
		{		
			// KILL HIM!
			level.player DoDamage( 10000, self.origin ); 
		}
	}
}

//congrats from tanner
e6_finale()
{
	

	level.player maps\_utility::play_dialogue( "BOND_End_1" );	// Tanner?
	level.player maps\_utility::play_dialogue( "TANN_End_2" );	// Well done, Bond.

	//break the glass
	level notify( "demo_end" );
}	


//############################################################################
//	e7_main - Obanno fight
//
e7_main()
{
	level thread check_mop();
	
	//iprintlnbold("Start e7_main");

	trig = GetEnt("ctrig_e7_obanno", "targetname" );
	trig waittill( "trigger" );

	//iprintlnbold("Trigger e7_main");

	level thread maps\_autosave::autosave_now("e7");
	level notify( "e7_start" );
	
	//letterbox_on( true, true );

	org = GetEnt("obanno_fight_org", "targetname");
	vesper		= GetEnt("vesper_spawner", "targetname")		StalingradSpawn("vesper");
	obanno		= GetEnt("obanno_spawner", "targetname")		StalingradSpawn("obanno");
	level.obanno = obanno; //CG - for attaching effects
	lieutenant	= GetEnt("obanno_thug_spawner", "targetname")	StalingradSpawn("thug");
	
	obanno thread maps\_bossfight::boss_transition();
	level.player maps\_gameskill::saturateViewThread(false);

	setdvar("ui_hud_showcompass", 0);
	setsaveddvar("cg_disableBackButton", "1"); //disable
	visionsetnaked("casino", 2);
	
	wait(0.1);
	obanno gun_remove();
	obanno attach( "w_t_machette", "TAG_WEAPON_RIGHT" );
	
	PlayCutScene("Obanno_Fight_Intro", "obanno_intro_done");

	level.player waittillmatch("anim_notetrack", "vision_stairs");
	visionsetnaked("casino_obanno", 2);

	wait(2.0);
	
	//Boss Fight Music
	level notify( "playmusicpackage_boss" );

	level waittill("obanno_intro_done");
	visionsetnaked("boss_fail", 0.2);
	
	lieutenant dodamage(500, (0, 0, 0));
	forcephoneactive(false);
	level.player SwitchToNoWeapon();
	level.player takeallweapons();
	start_interaction(level.player, obanno, "BossFight_Obanno");
	wait(0.2);
	forcephoneactive(false);
	level.player SwitchToNoWeapon();
	level.player takeallweapons();
	visionsetnaked("casino_obanno", 0.2);
	setblur(0, 0.2);
	PlayCutScene("Obano_Fight_Vesper_01", "vesper_done");
	level.player waittillmatch("anim_notetrack", "switch_to_gun");

	level.player attach( "w_t_p99", "TAG_UTILITY2" );

	//// ********* Obanno Fight Goes Here ***************//

	level.player waittill("interaction_done");
	EndCutScene("Obano_Fight_Vesper_01");
	if (level.boss_laststate == 1)
	{
		PlayCutScene("Obanno_Fight_Final_Success", "obanno_fight_done");
	}
	else
	{
		PlayCutScene("Obanno_Fight_Fail", "obanno_fight_done");
	}
	level.player waittillmatch("anim_notetrack", "fade_out");

	if (level.boss_laststate == 0)
	{
		level.player uideath();
		level.player notify("death");
		missionfailedwrapper();
	}

	level.player setorigin( (-6891, 2126, -119) );
	// Start Poison
	level notify( "endmusicpackage" );
	setsaveddvar("cg_disableBackButton", "0"); //enable
	//wait(7.0);
	thread e6_finale();
	maps\_endmission::nextmission();
}

check_mop()
{
	trigger = getent("set_mop_physic", "targetname");
	origin = getent("mop_phsic_origin", "targetname");
	trigger waittill("trigger");

	physicsExplosionSphere( origin.origin, 30, 1, 1);






}

//Ben Wang
//5/30/98
//Handle boss battle damage, camera shake, etc.
//remember the last state

//avulaj
//03/29/08
//added this to dispaly the level map
//this will display the main hall 1st floor and the path leading to it
display_map_mainhall_first_floor()
{
	level endon( "map_ballroom" );

	trigger = GetEnt( "ctrig_e6_con_room_inside", "targetname" );
	while( true )
	{
		trigger waittill( "trigger" );

		//////////////////////////////////////////////
		//avulaj
		//03/29/08
		//added this to dispaly the level map
		//this will display the 1st floor of the mainhall
		setSavedDvar( "sf_compassmaplevel",  "level4" );
		//////////////////////////////////////////////

		while ( level.player IsTouching( trigger ) )
		{
			wait( 0.1 );
		}
		////////////////////////////////////////////////////////////////////////
		//avulaj
		//03/29/08
		//added this to dispaly the level map
		//this will display the spa area and the path leading to the main hall
		setSavedDvar( "sf_compassmaplevel",  "level3" );
		///////////////////////////////////////////////////////////////////////
	}
}

//avulaj
//03/29/08
//added this to dispaly the level map
//this will display the main hall 1st floor and 2nd floor
display_map_mainhall_second_floor()
{
	level notify( "map_ballroom" );

	trigger = GetEnt( "ctrig_ballroom_lower", "targetname" );
	while( true )
	{
		trigger waittill( "trigger" );

		//////////////////////////////////////////////
		//avulaj
		//03/29/08
		//added this to dispaly the level map
		//this will display the 2nd floor of the mainhall
		setSavedDvar( "sf_compassmaplevel",  "level5" );
		//////////////////////////////////////////////

		while ( level.player IsTouching( trigger ) )
		{
			wait( 0.1 );
		}
		//////////////////////////////////////////////////
		//avulaj
		//03/29/08
		//added this to dispaly the level map
		//this will display the 1st floor of the mainhall
		setSavedDvar( "sf_compassmaplevel",  "level4" );
		////////////////////////////////////////////////////
	}
}


//
//	Challenge Achievement for Casino
//		Sneak past the guards in the hallways and suites without killing them.
//
challenge_achievement()
{
	level.broke_stealth = false;
	level.guy_killed = false;

	trig = GetEnt("ctrig_e3_vent0", "targetname" );
	trig waittill( "trigger" );

	if ( !level.broke_stealth && !level.guy_killed )
	{
		GiveAchievement( "Challenge_Casino" );
	}
}

display_chyron()
{
	wait(.05);
	maps\_introscreen::introscreen_chyron(&"CASINO_INTRO_01", &"CASINO_INTRO_02", &"CASINO_INTRO_03");
}
