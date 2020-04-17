#include animscripts\shared;
#include maps\_utility;
#include maps\_anim;

#include maps\constructionsite_util;

#using_animtree("generic_human");

main()
{
	//precache & load FX entities (do before calling _load::main) - not for PS3 branching -D.O.
	
	maps\_vvan::main("v_van_white_radiant");
	maps\_vdigger::main("v_digger_motion_radiant");
	maps\_load::main();
	maps\constructionsite_fx::main();

	maps\constructionsite_mus::main();
	
	maps\_sea::main();

	
	//Dash disabled for this level
	SetSavedDVar("cover_dash_fromCover_enabled", false);
	SetSavedDVar("cover_dash_from1stperson_enabled", true);
	SetDvar("sm_spotShadowEnable", false);     
	
	//artist mode
	if( Getdvar( "artist" ) == "1" )
	{
		maps\_load::main();
		return;
	}	
	
	maps\createart\constructionsite_art::main();
	//setExpFog(level.fognearplane, level.fogexphalfplane, level.fogred, level.foggreen, level.fogblue, 0, level.fogmax);
	setExpFog( 0, 2195, 0.587434, 0.570319, 0.529037, 0, 0.676873);
	
	SetDVar("sm_SunSampleSizeNear", 0.5);

	//precache the sceneanims
	PrecacheCutScene("Bomber_Chase");
	PrecacheCutScene("Bomber_Chase_2");
	PrecacheCutScene("Bomber_Chase_2B");
	PrecacheCutScene("Bomber_Chase_3");
	PrecacheCutScene("Bomber_Chase_4");
	PrecacheCutScene("Bomber_Chase_5");
	PrecacheCutScene("Bomber_Chase_5B");
	PrecacheCutScene("Bomber_Chase_6");
	PrecacheCutScene("Bond_DryWall");
	PrecacheCutScene("Bond_FloorFall");
	PrecacheCutScene("Bond_Jump_to_Pipes");
	PrecacheCutScene("bnd_scissorlift");
	PrecacheCutScene("bnd_jump_roof");
	PrecacheCutScene("Bond_Jump_to_Crane2");
	PrecacheCutScene("BondClimbPipesTop");
	PrecacheCutScene("Bond_KickPipes");
	level thread maps\_utility::timer_init();
	precacherumble("movebody_rumble");
	character\character_tourist_1::precache();

	//thread camera_test();
	//Enable mini-map for test level
	precacheShader( "compass_map_construction_site" );
	setminimap( "compass_map_construction_site", 4104, 312, -4632, -4640 );            //POINTS C AND D!!!!!!!

	level.radio = [];
	level.radio[0] = "TANN_ConsG01A_075A";
	level.radio[1] = "TANN_ConsG01A_076B";
	level.radio[2] = "TANN_ConsG01A_077C";
	level.radio[3] = "TANN_ConsG01A_078D";
	level.radio[4] = "TANN_ConsG01A_079E";
	level.radio[5] = "TANN_ConsG01A_080F";
	level.radio[6] = "TANN_ConsG01A_081G";
	level.radio[7] = "TANN_ConsG01A_082H";
	level.radio[8] = "TANN_ConsG01A_083I";
	level.radio[9] = "TANN_ConsG01A_084J";
	level._effect["bird_1"] = loadfx("maps/Siena/siena_birds_flying4");

	level.radio_not_played = level.radio;
	level.radio_warning = true;

	flag_init("bomber_climb");	// for when the bomber waits before he climbs up the pole until the player mantles up to the platform
//	level thread arrow_hint();

	// Set the underlying ambient track

	//Audio
	thread maps\constructionsite_snd::main();

	//events throughout the level waiting for triggers
	thread drywall_break();
	thread crane_arm_1_camera();
	thread crane_arm_2_camera();
	//thread crane_collapse();
	thread crane_up();
	thread level_end_van();
	//thread move_elevator_switch();
	
	//populate the starting areas with civilians
	thread ambience_other_floors();
	thread ambience_inside_building();
	thread ambience_ground_falling_pipes();
	thread ambience_elevator_worker();

	//setup functions that need to be called at the start of the level
	thread setup_vision();
	thread setup_bond();
	thread setup_objectives();
	level thread setup_new_objectives();
	thread setup_bomber();
	thread setup_deathplane();
	thread setup_awareness();
	thread setup_misc();
	//thread setup_flash_drives();
	thread elevator_crash();
	
	//mission fail and chase related functions
	thread chase_fail();
	level thread trigger_check_van();
	//thread balance_fail();
	level thread set_timer_base_on_difficulty();
	level thread start_amb_crane();
	level thread sand_grunt();
	level thread end_chase_timer();
	level thread hide_useless_ents();
	level thread ambience_run_from_digger();

	
}
sand_grunt()
{

	trigger = getent("sand_noise", "targetname");
	
	while(true)
	{
		trigger waittill("trigger");
		level.player playsound("bond_xrt_grunt");
		wait(2);
	}


}
start_amb_crane()
{
	trigger = getent("crane_ambience", "targetname");
	trigger waittill("trigger");

	sound = random(level.radio_not_played);
	level.player play_dialogue_nowait(sound);
	level.radio_not_played = array_remove(level.radio_not_played, sound);

	origin = getent("bird_origin", "targetname");
	playfx( level._effect["bird_1"], origin.origin );
	//iprintlnbold("SOUND: Birds");
	//origin playsound ("Birds_Taking_Off");
	//level.player playsound ("Birds_Taking_Off");

	van = getent("amb_van", "targetname");
	path = GetVehicleNode("level_end_path","targetname");
	van attachpath( path );
	van startpath();

}

set_timer_base_on_difficulty()
{

	if(getdvarint("level_gameskill") == 0)
	{
		//iprintlnbold("difficulty = 0");
		level.timer_set = 50;
		

	}
	else if(getdvarint("level_gameskill") == 1)
	{
		//iprintlnbold("difficulty = 1");
		level.timer_set = 38;	
	}
	else if(getdvarint("level_gameskill") == 2)
	{
		//iprintlnbold("difficulty = 2");
		level.timer_set = 33;
	}
	else if(getdvarint("level_gameskill") == 3)
	{
		//iprintlnbold("difficulty = 3");
		level.timer_set = 30;
	}





}
trigger_check_van()
{	

	trigger = getent("miss_van", "targetname");
	trigger waittill("trigger");
	MissionFailedWrapper();
	


}

setup_vision()
{
	// set visual values
	if(level.ps3)
	{
		VisionSetNaked( "constructionsite_0_ps3");	
		
	}
	else
	{
		VisionSetNaked( "constructionsite_0");	
	}
}
setup_new_objectives()
{

	trigger = getent("pursue_objective", "targetname");

	objective_add( 0, "active", &"CONSTRUCTIONSITE_PURSUE_ON_FOOT_HEADER", trigger.origin, &"CONSTRUCTIONSITE_PURSUE_ON_FOOT_BODY");
	trigger waittill("trigger");
	setSavedDvar( "cg_disableBackButton", "0" );
	trigger = getent("climb_crane_objective", "targetname");
	objective_state(0, "done" );
	objective_add( 1, "active", &"CONSTRUCTIONSITE_PURSUE_ON_FOOT_HEADER", trigger.origin, &"CONSTRUCTIONSITE_PURSUE_ON_FOOT_BODY");
	
	trigger waittill("trigger");
	VisionSetNaked( "constructionsite_2");	


	
	
	trigger = getent("get_to_ground_objective", "targetname");
	objective_state(1, "done" );
	objective_add (2, "active", &"CONSTRUCTIONSITE_GET_TO_CRANE_HEADER", trigger.origin, &"CONSTRUCTIONSITE_GET_TO_CRANE_BODY");
	//level.player play_dialogue("TANN_ConsG_086A", true);
	trigger waittill("trigger");

	sound = random(level.radio_not_played);
	level.player play_dialogue_nowait(sound);
	level.radio_not_played = array_remove(level.radio_not_played, sound);

	if(level.ps3)
	{
		VisionSetNaked( "constructionsite_0_ps3");	
		
	}
	else
	{
		VisionSetNaked( "constructionsite_0");	
	}


	trigger = getent("chase_van_objective", "targetname");
	objective_state(2, "done" );
	objective_add (3,"active", &"CONSTRUCTIONSITE_GET_TO_GROUND_HEADER", trigger.origin, &"CONSTRUCTIONSITE_GET_TO_GROUND_BODY");
		
	trigger waittill("trigger");
	van = getent("level_end_van", "targetname");
	objective_state(3, "done" );

	objective_add(4,"active", &"CONSTRUCTIONSITE_CATCH_THE_BOMBER_HEADER", van.origin, &"CONSTRUCTIONSITE_CATCH_THE_BOMBER_BODY");
	//level.player play_dialogue("TANN_ConsG_087A", true);
}
setup_objectives()
{


	level.elevator_can_move = false;
	
	wait(0.05);
	trigger = GetEnt("objective_update_1","targetname");

	
	//objective_add( 1, "current", &"SHANTYTOWN_OBJECTIVE_GET_TO_DIGGER_NAME", level.bomber.origin, &"SHANTYTOWN_OBJECTIVE_GET_TO_DIGGER_BODY");
	
	
	trigger waittill("trigger");

				sound = random(level.radio_not_played);
			level.player play_dialogue_nowait(sound);
			level.radio_not_played = array_remove(level.radio_not_played, sound);

	flag_set("bomber_climb");

	level notify("climb_up_sand");		
	level notify("checkpoint_reached");

	wait(1.0);

	level thread create_time_limit(level.timer_set);
	level thread maps\_utility::timer_restart(level.timer_set);
	
	flag_wait("trigger_jump_table");
	SetDvar("sm_spotShadowEnable", true);   
	
	//objective_state( 2, "done");
		
	trigger = GetEnt("trigger_inside_vision","targetname");
	trigger waittill("trigger");

	if(level.ps3)
	{
		VisionSetNaked( "constructionsite_1_ps3");	
		
	}
	else
	{
		VisionSetNaked( "constructionsite_1");	
	}
	

	trigger = GetEnt("objective_update_2","targetname");
	trigger waittill("trigger");
	
	level notify("clear_civilians_1");
	
	
	trigger = GetEnt("trigger_lift_fall","targetname");
	trigger waittill("trigger");
	level.player play_dialogue("TANN_ConsG_085A", true);
	//objective_state( 3, "done");
	
	
	trigger = GetEnt("trigger_climb_camera","targetname");
	trigger waittill("trigger");
		level.player play_dialogue_nowait("TANN_CONSG_300A");
	//objective_state( 4, "done");

	level waittill("clear_civilians_2");
	
	level waittill("van_start");
	
	//objective_state(5, "done");
	
}

setup_flash_drives()
{
	level.information = 0;

	thread maps\_playerawareness::setupSingleUseOnly("flash_drive_1",
		::flash_drive_find,
		&"CONSTRUCTIONSITE_PICKUP",
		1,
		undefined,
		true,
		false,
		undefined,
		level.awarenessMaterialNone,
		true,
		false,
		false );

	thread maps\_playerawareness::setupSingleUseOnly("flash_drive_2",
		::flash_drive_find,
		&"CONSTRUCTIONSITE_PICKUP",
		1,
		undefined,
		true,
		false,
		undefined,
		level.awarenessMaterialNone,
		true,
		false,
		false );

	thread maps\_playerawareness::setupSingleUseOnly("flash_drive_3",
		::flash_drive_find,
		&"CONSTRUCTIONSITE_PICKUP",
		1,
		undefined,
		true,
		false,
		undefined,
		level.awarenessMaterialNone,
		true,
		false,
		false );
}

setup_bond()
{
	holster_weapons();

	//no prone or crouch for digger
	level.player allowProne(false);
	level.player allowCrouch(false);

	//setup the phone
	maps\_phone::setup_phone();
	wait(0.05);
	setSavedDvar( "cg_disableBackButton", "1" );
}

setup_bomber()
{
	bomber_spawner = GetEnt("bomber_spawner","targetname");
	level.bomber = spawn_enemy(bomber_spawner);
	level.bomber SetEnableSense(false);
	level.bomber LockAlertState("alert_red");
	level.bomber setoverridespeed(29.5295591);
	level.bomber.script_radius = 28;
	level.bomber.targetname = "bomber";
	level.bomber thread magic_bullet_shield();

	level thread chase_status();

	if( getdvar( "pip_off") != "true")
	{
		//SetDVar("r_pipSecondaryX", 0.05);
		//SetDVar("r_pipSecondaryY", 0.05);						// place top left corner of display safe zone
		//SetDVar("r_pipSecondaryAnchor", 0);						// use top left anchor point
		//SetDVar("r_pipSecondaryScale", "0.5 0.5 1.0 1.0");		// scale image, without cropping
		//SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio
		//SetDVar("cg_pip_buffering","1");
		// comment off for demo
		//	SetDVar("r_pipSecondaryMode", 0);
		
	}
	
	
	switch( getdvar( "skipto") )
	{
		case "girders":
		case "Girders":
			location = GetEnt("girders_start","targetname");
			level.player SetOrigin(location.origin);
			level.player SetPlayerAngles(location.angles);
			level.player allowCrouch(true);
			//SetDVar("cg_pip_buffering","0");	
			//SetDVar("r_pipSecondaryMode", 5);
			//////////////////////////////////////
			//comment out for demo
			//level thread set_default_pip();
			//////////////////////////////////////
			break;

		case "crane":
		case "Crane":
			location = GetEnt("crane_end","targetname");
			level.player SetOrigin(location.origin);
			level.player SetPlayerAngles(location.angles);
			
			//SetDVar("cg_pip_buffering","0");	
			//SetDVar("r_pipSecondaryMode", 5);

			//////////////////////////////////////
			//comment out for demo
			//level thread set_default_pip();
			////////////////////////////////////

			//start bomber to the elevator
			//playcutscene("Bomber_Chase_5","Bomber_Chase_5_Done");
			level thread bomber_5();
			level.bomber thread bomber_create_impulse();
			//speed of the balance beam walk
			//SetSavedDVar("bal_move_speed",100.0);
			level thread create_time_limit(level.timer_set);
			level thread maps\_utility::timer_restart(level.timer_set);
			break;

		case "van":
		case "Van":
			location = GetEnt("skipto_van","targetname");
			level.player SetOrigin(location.origin);
			level.player SetPlayerAngles(location.angles);

			wait(1);

			//move the scissor lift cage down to hide hover
			cage = GetEnt("scissorlift_cage","targetname");
			cage MoveZ(152,0.5);

			break;
			
		default:
			thread digger_rail();
			break;
	}
}

setup_deathplane()
{
	trigger = GetEnt("trigger_death_plane","targetname");
	trigger waittill("trigger");
	trigger delete();
		
	level.player DoDamage(level.player.health + 500, level.player.origin);

}

setup_awareness()
{
	//thread maps\_playerawareness::setupSingleUseOnly("trigger_elevator_crash",
	//						 ::awareness_elevator_crash,
	//						 "Flip Switch",
	//						 0,
	//						 undefined,
	//						 true,
	//						 false,
	//						 undefined,
	//						 level.awarenessMaterialNone,
	//						 true,
	//						 false,
	//						 false );

	//thread maps\_playerawareness::setupSingleUseOnly("trigger_girder_door",
	//						::awareness_girder_door,
	//						"Bash Door",
	//						0,
	//						undefined,
	//						true,
	//						false,
	//						undefined,
	//						level.awarenessMaterialNone,
	//						true,
	//						false,
	//						false );

	level thread awareness_girder_door();
							 
	thread maps\_playerawareness::setupSingleUseOnly("trigger_scissor_lift",
							 ::awareness_scissor_lift,
							 &"CONSTRUCTIONSITE_TEAR_CABLES",
							 0,
							 undefined,
							 true,
							 false,
							 undefined,
							 level.awarenessMaterialNone,
							 true,
							 false,
							 false );
							 
}

setup_misc()
{
	precacheModel("bond_construction_body");
	precacheModel("bond_construction_head");

	//precache the full body model of the digger
	precachemodel("v_digger_stationary_radiant");
	digger = GetEnt("digger_rail_end","targetname");
	digger hide();

	//wrench that the construction worker uses
	precacheModel("p_msc_wrench");
	precachemodel("p_msc_ball_hammer");

	//hide destroyed version of the shack the digger runs through
	destroyed_shack = GetEnt("shed_destroyed","targetname");
	destroyed_shack hide();

	//hide the destroyed flooring in the girders
	bent_floor = GetEnt("grate_bent","targetname");
	bent_floor trigger_off();

	//move the scissor lift cage down to hide hover
	cage = GetEnt("scissorlift_cage","targetname");
	cage MoveZ(-152,0.5);

	//hide the down version of the scissor lift
	scissor_lift_down = GetEnt("scissorlift_down","targetname");
	scissor_lift_down hide();
	
	//hide the destroyed version of the scissor lift cage
	scissor_lift_d = GetEnt("scissorlift_cage_d","targetname");
	scissor_lift_d hide();

	//hide the broken water pipes
	broken_pipes = GetEnt("pipe_broken","targetname");
	broken_pipes hide();

	//hide the dented roof after the last crane jump
	dented_roof = GetEnt("metal_dented","targetname");
	dented_roof hide();

	//a flag for the last fail condition of the level
	level.last_sprint = false;

	//speed of the balance beam walk
	SetSavedDVar("bal_move_speed",70.0);

	//readjust balance beam settings
	SetSavedDVar("Bal_wobble_accel", 1.02);
	SetSavedDVar("Bal_wobble_decel", 1.05);
}

chase_fail()
{
	if( getdvar( "timer_off") == "1")
	{
		return;
	}
	
	level waittill("time_limit_reached");
	MissionFailedWrapper();
}

//balance_fail()
//{
//	level.player waittill("beam",notice);
//	if(notice == "fall")
//	{
//		MissionFailedWrapper();
//	}
//}

#using_animtree("generic_human");
level_end(awareness_object)
{
	//flag_clear("arrow_hint");

	level.player freezecontrols(true);

	clone_bond = Spawn( "script_model", level.player.origin );
	clone_bond SetModel( "tag_origin" );
	clone_bond setModel("bond_construction_body");
	clone_bond attach("bond_construction_head", "", false);
	clone_bond.voice = "american";

	clone_bond useanimtree(#animtree);
	clone_bond setanim(%Bnd_jmp_Van_idle, 1.0, 1.0, 1.0);




	//changelevel("sciencecenter_a");

	//turn off picture in picture
	//SetDVar("r_pipSecondaryMode", 0);
	level thread set_default_main();

	van_origin = GetEnt("van_attach_player","targetname");
	
	//player_stick(false);
	
	//level.sticky_origin moveto(van_origin.origin,.05);
	//level.sticky_origin rotateto(van_origin.angles,.05);
	//level.sticky_origin waittill ("movedone");
	
	//level.sticky_origin LinkTo(van_origin);
	cameraID_van = level.player customCamera_Push("world", level.player.origin + (0,0,72), level.player.angles, 0.1);
	clone_bond moveto(van_origin.origin,.05);
	clone_bond rotateto(van_origin.angles,.05);
	clone_bond waittill ("movedone");
	
	
	level notify("checkpoint_reached");
	
	//Music notify, added by Chuck Russom
						
	level notify("endmusicpackage");
	
	objective_state(4, "done");
	
	clone_bond LinkTo(van_origin);

	level.player play_dialogue_nowait("TANN_ConsG_201A", true);
	level thread fade_in_black(4, false);

	maps\_endmission::nextmission();
	return;

	// this hack links the player to the van so the van doesn't pop out
	//hack = Spawn("script_origin", level.player.origin + (0, 0, -100));
	//level.player LinkTo(hack);
	//hack LinkTo(clone_bond);

	//cam_path = GetEnt("embassy_cam", "targetname");
	//cam_path = GetEnt(cam_path.target, "targetname");
	//embassy = GetEnt("embassy", "targetname");

	//level.van SetSpeed(40, 5);

	//wait 2;

	////cam = 1;
	//while (IsDefined(cam_path))
	//{
	//	//accel = 0.0;
	//	//decel = 0.0;
	//	//if (cam == 1)
	//	//{
	//	//	accel = cam_path.script_wait / 2;
	//	//	decel = 0.0;
	//	//}
	//	//else if (cam == 2)
	//	//{
	//	//	accel = 0.0;
	//	//	decel = cam_path.script_wait / 2;
	//	//}

	//	//cameraID_van = level.player customCamera_Push("world", cam_path.origin, cam_path.angles, cam_path.script_wait, accel, decel);
	//	//cam_path.script_wait = 2;
	//	cameraID_van = level.player customCamera_Push("world", cam_path.origin, cam_path.angles, cam_path.script_wait);
	//	level.player customCamera_setFoV(cameraID_van, cam_path.script_float, cam_path.script_wait);
	////	wait cam_path.script_wait + .25;
	//	if (IsDefined(cam_path.target))
	//	{
	//		cam_path = GetEnt(cam_path.target, "targetname");
	//	}
	//	else
	//	{
	//		cam_path = undefined;
	//	}
	//}

	////level.player play_dialogue("TANN_ConsG_201B", true);
	////wait(5);
	////GiveAchievement("Progression_Construction"); 
	//

	////changelevel("sciencecenter_a");
}

level_end_van()
{
	level waittill("van_start");
	
	level.van = GetEnt("level_end_van","targetname");
	level.van thread setup_car_driver();
	van_origin = GetEnt("van_attach_player","targetname");
	van_origin LinkTo(level.van);
	
	//Steve G
	van_origin playloopsound("suspension_rattle", 1.4);
	
	trigger = Spawn( "script_model", level.van.origin );
	trigger SetModel( "tag_origin" );
	trigger.origin += (0,0,100);
	trigger.use_range = 180;
	trigger LinkTo( level.van );
	
	path = GetVehicleNode("level_end_path","targetname");
	level.van attachpath( path );
	level.van startpath();

	while(1)
	{
		if(Distance(level.player.origin, level.van.origin) < 200)
		{

			level notify("checkpoint_reached");
	
			//Music notify, added by Chuck Russom
						
			level notify("endmusicpackage");
	
			objective_state(4, "done");
	
	

	level.player play_dialogue_nowait("TANN_ConsG_201A", true);
	level thread fade_in_black(2, false);

	maps\_endmission::nextmission();
	return;


		}

		wait(0.1);





	}
	
	//maps\_playerawareness::setupEntSingleUseOnly(	 trigger,
	//						 ::level_end,
	//						 "Jump On Van",
	//						 undefined,
	//						 undefined,
	//						 true,
	//						 true,
	//						 undefined,
	//						 level.awarenessMaterialNone,
	//						 true,
	//						 false,
	//						 false );

	//wait(10);

	//barrier = GetEnt("barrier_arm_script","targetname");
	//barrier RotateRoll(-70,2);

	//wait(18);

	//barrier RotateRoll(70,2);
}
#using_animtree("fxanim_necklace");
necklace()
{

	self UseAnimTree(#animtree);
	self animscripted("a_necklace", self.origin, self.angles, %fxanim_necklace);
}
	
#using_animtree("vehicles");
digger_rail()
{
	//setup, links the origins to the digger model as well as the player
	digger_rail = GetEnt("digger_rail","targetname");
	
	bike = getent("off_digger", "targetname");
	bike hide();
	
	
	path = GetVehicleNode("digger_rail_path","targetname");

	necklace = getent("digger_necklace", "targetname");

	digger_rail setanim(%v_digger_steering, 1.0, 1.0, 1.0);
	//the origin of the physics force on the digger
	digger_impulse = GetEnt("digger_impulse","targetname");
	digger_impulse linkto(digger_rail);

	//where the player is linked to inside the digger
	digger_seat = GetEnt("digger_player_seat","targetname");
	digger_seat linkto(digger_rail);
	
	//move the player to the seat
	level.player PlayerLinkToDelta(digger_seat,undefined,1,20,20,10,10);

	//grab the destroyed and normal versions of the construction overhang
	digger_area = GetEntArray("digger_terrain","targetname");
	digger_area_destroyed = GetEntArray("digger_terrain_d","targetname");
	
	//hide the destroyed part
	for(i = 0; i < digger_area_destroyed.size; i++)
	{
		digger_area_destroyed[i] trigger_off();
	}
	
	//get the party started (make mini earthquakes and play sounds)
	level.impulse_digger_flag = true;
	digger_rail playsound("earth_digger_move");
	digger_rail thread digger_create_impulse();

	digger_rail attachpath( path );
	digger_rail startpath();
	necklace linkto(digger_rail);
	necklace thread necklace();


	
	
	//level.player PlayRumbleLoopOnEntity("movebody_rumble");
	digger_rail thread digger_clear_forest();
	
	//Stop the player being able to move the camera up and down on the rail
	wait(0.1);
	setDvar( "cg_lockPitch", 1 );

	wait(17.9);
	
	//playing the glass windshield effect with an offset
	//offset from Bond's view = (z, x, y)
	digger_rail thread shoot_digger_glass((36.0, -8.0, 160.70), 0);
	digger_rail thread shoot_digger_glass((38.0, -2.0, 152.70), 0.3);
	digger_rail thread shoot_digger_glass((39.0, 0.0, 146.70), 0.6);
	digger_rail thread shoot_digger_glass((41.0, 8.0, 142.70), 0.8);

	digger_rail useanimtree(#animtree);
	digger_rail setanim(%v_digger_bucket_up, 1.0, 1.0, 1.0);
	

	digger_rail waittill("reached_end_node");

	//tells the bomber to fall down and move on
	level notify("digger_crash_finished");
	
	endcutscene("Bomber_Chase");

	playcutscene("Bomber_Chase_2","Bomber_Chase_2_Done");
	//level.player StopRumble("tank_rumble");

	//Music notify, added by Chuck Russom
	
	level notify("playmusicpackage_start");
	
	level thread bomber_catch_breath();

	//stop making the world shake
	level.impulse_digger_flag = false;

	// Added by Steve G
	level.player playlocalsound("earth_digger_crash");
	level.player playsound("earth_digger_crash_LFE");

	level notify("cement_crush_start");
	level notify("fx_digger_impact");
	
	for(i = 0; i < digger_area.size; i++)
	{
		digger_area[i] delete();
	}
	
	for(i = 0; i < digger_area_destroyed.size; i++)
	{
		digger_area_destroyed[i] trigger_on();
	}
	
	level thread digger_aftermath_pipes();

	level thread ambience_detour_area();
	
	//make a large crash shake
	earthquake(0.8, 1, level.player.origin, 256);
	//level.player ShellShock("default",4);
	wait(1);

	//Enable the player to move the camera up and down now the rail is finishing
	setDvar( "cg_lockPitch", 0 );

	//get player out of digger
	level.player unlink();

	necklace delete();

	////insert camera to bomber with crane falling
	//level.player PlaySound ("crane_creak");
	//destination = GetEnt("after_digger_start","targetname");
	//player_stick(false);
	//level.sticky_origin rotateyaw(-90,.5);
	//level.sticky_origin waittill("rotatedone");
	//level.sticky_origin moveto(destination.origin,.5);
	//level.sticky_origin rotateto(destination.angles,.5);

	SetSavedDVar("ik_bob_pelvis_scale_1st","1.5");
	level.player allowCrouch(true);
	SetSavedDVar("cg_fov","80");

	node_start = getvehiclenode("move_off_digger_1", "targetname");
	maps\_vehicle::vehicle_init( bike );
	
	bike attachpath(node_start);
	level.player playerlinkto( bike, "tag_origin", 0.5);
	level.player setgod( true );
	//level.player thread magic_bullet_shield();
	wait(0.1);
	bike startpath( node_start );
	bike waittill("reached_end_node");
	level.player unlink();
	bike delete();
	//level.player stop_magic_bullet_shield();
	level.player setgod( false );

	//level.sticky_origin waittill ("movedone");

	digger_rail delete();
	digger_rail = GetEnt("digger_rail_end","targetname");
	digger_rail show();

	//Steve G
	//wait(2.6);
	//wait(1.5);
	player_unstick();

	//flag_set("arrow_hint");
	
	//ent_tag delete();	// delete fx of digger windshield getting shot by bomber
	maps\_autosave::autosave_now("construction");

	//////////////////////////////////////
	//comment out for demo
	//level thread set_default_pip();
	///////////////////////////////

	level thread create_time_limit(level.timer_set);
	level thread maps\_utility::timer_restart(level.timer_set);	
}

shoot_digger_glass(offset, delay)
{	
	//iprintlnbold("FX: shoot_digger_glass");
	
	ent_tag = undefined;
	ent_tag = Spawn("script_model", self.origin + offset);
	ent_tag SetModel("tag_origin");
	ent_tag.angles = self.angles;
	ent_tag LinkTo(self);

	wait(delay);
	ent_tag playsound("wpn_1911_fire_ai");
	Playfxontag(level._effect["const_glass_impact"], ent_tag, "tag_origin");
	wait(30.0);
	ent_tag delete();
}

digger_create_impulse()
{
	digger_impulse = GetEnt("digger_impulse","targetname");
	while(level.impulse_digger_flag == true)
	{
		earthquake(0.11,0.05,level.player.origin,256);
		wait(.05);
	}
}

digger_clear_forest()
{
	//animate warners
	rail_warn = GetEnt("intro_warn","targetname");
	rail_warn thread civilian_action_warn();

	rail_dig = GetEnt("intro_dig","targetname");
	rail_dig thread civilian_action_anim("Gen_Civs_HoleDig");

	//1st trigger
	trigger = GetEnt("trigger_forest_1","targetname");
	trigger waittill("trigger");
	trigger delete();

	//SetDVar("r_pipSecondaryMode", 5);

	//1st tree
	tree_one = GetEnt("rail_tree_1","targetname");
	// Added by Steve G
	level.player playlocalsound("treefall_01");
	earthquake(0.4, .5, level.player.origin, 256);
	tree_one RotatePitch(90, 0.7);

	//2nd trigger
	trigger = GetEnt("trigger_forest_2","targetname");
	trigger waittill("trigger");
	trigger delete();

	//leaves
	level notify("fx_foliage_burst");

	//delete warners
	rail_warn delete();
	rail_dig delete();

	//start the van
	van = GetEnt("level_start_van","targetname");
	path = GetVehicleNode("level_start_path","targetname");
	van attachpath( path );
	van startpath();

	//knock the palm tree over
	palm = GetEnt("rail_tree_2","targetname");
	earthquake(0.4, 3, level.player.origin, 256);
	// Added by Steve G
	level.player playlocalsound("treefall_02");
	palm RotatePitch(85,0.7);
	wait(1);

	//knock both bushes over
	bush1 = GetEnt("shrub_fall","targetname"); //left bush
	bush2 = GetEnt("shrub_fall2","targetname"); //right bush
	bush1 RotateRoll(-85,0.7);
	
	bush2 RotatePitch(-85,0.7);

	//2nd tree
	tree_two = GetEnt("tree_fall","targetname");
	tree_two playsound("chain_link_hit");
	tree_two RotatePitch(90,1,0.25);

	//fence behind trees
	dynEnt_StartPhysics("fence_fall");
	earthquake(0.4, 3, level.player.origin, 256);

	//spawn the workers that run away from the digger
	level notify("civ_run_off");
	//level thread ambience_run_from_digger();
	wait(2);
	
	//start bomber running
	playcutscene("Bomber_Chase","Bomber_Chase_Done");
	//SetDVar("cg_pip_buffering","0");						// enable video camera display with highest priority 
	//SetDVar("r_pipSecondaryMode", 5);

	//////////////////////////////////////
	//comment out for demo
	//level thread set_default_pip();
	////////////////////////////////////////

	wait(4.5);

	level notify("shed_roof_start");
	dynEnt_StartPhysics("sheda_dyn");

	// Added by Steve G
	earthquake(0.4, 3, level.player.origin, 256);
	level.player playlocalsound("shed_collapse");
	level notify("fx_shack_dust");

	wait(1);

	dynEnt_StartPhysics("digger_barrels");
	
	wait(1);

	dynEnt_StartPhysics("digger_fence");
	// Added by Steve G
	level.player playlocalsound("chain_link_collapse");
	earthquake(0.4, 1, level.player.origin, 256);

	wait(1.5);

	dynEnt_StartPhysics("digger_pipes");
	// Added by Steve G
	level.player playlocalsound("metal_barrels_crash");
	earthquake(0.4, 1, level.player.origin, 256);

	wait(3);

	//unhide destroyed version of shack
	destroyed_shack = GetEnt("shed_destroyed","targetname");
	destroyed_shack show();
}

digger_aftermath_pipes()
{
	broken_pipes = GetEnt("pipe_broken","targetname");
	broken_pipes show();

	pipes = GetEnt("pipe","targetname");
	pipes hide();
	
	
	
	
	level notify("fx_water_pipe");
	
	
	trigger = GetEnt("trigger_pipe_fall","targetname");
	trigger waittill("trigger");
	trigger delete();
	//Steve G
	//wait(2.6);
	wait(1.1);
	level notify("pipe_drop_01_start"); //the pipes are now an animated prop
	// Steve G
	thread Maps\constructionsite_snd::crane_load_drop();

	earthquake(0.3, 1, level.player.origin, 30);



}

crane_arm_1_camera()
{
	trigger = GetEnt("trigger_crane_1_camera","targetname");
	//trigger waittill("trigger");
	trigger jump_trigger();


	trigger delete();
	
	//Steve G
	level.player PlaySound("high_crane_jump");

	//Music notify, added by Chuck Russom
				
	level notify("playmusicpackage_crane2");

	//flag_clear("arrow_hint");
	playcutscene("Bond_Jump_to_Crane2","Bond_Jump_to_Crane2");
	wait(1.1);

	//flag_set("arrow_hint");
	earthquake(1, 1, level.player.origin, 256);
	level waittill("Bond_Jump_to_Crane2");
	level thread create_time_limit(level.timer_set);
	level thread maps\_utility::timer_restart(level.timer_set);
	//Steve G
	level.player PlaySound("crane_breath_two");
	
	
	//rail = spawn("script_origin",level.player.origin);
	//level.player linkto( rail );
	destination = GetEnt("crane1_end","targetname");
	level.player SetOrigin(destination.origin);
	level.player SetPlayerAngles(destination.angles);
//	rail moveto(destination.origin,.05);
	//rail rotateto(destination.angles,.05);
	//rail waittill ("rotatedone");

	//level.player unlink();

	/*crane = GetEnt("crane_arm","targetname");
	collision = GetEntArray("crane_arm_collision","targetname");
	for(i = 0; i < collision.size; i++)
	{
		collision[i] linkto(crane);
	}
	beam = GetEnt("crane_balance_beam","targetname");
	beam linkto(crane);
	origin = GetEnt("crane_balance_origin","targetname");
	origin linkto(crane);

	wait(3);

	crane RotateYaw(-30,10);*/

	wait .5;

	// this script brushmodel is a hack to keep the player from falling off of the crane do to forward momentum durring the jump
	GetEnt("crane_jump_player_clip", "targetname");

	level notify("fx_birds_takeoff2");	
	//iprintlnbold("SOUND: Birds takeoff 2");
	//level.player playsound ("Birds_Taking_Off");
}

crane_arm_2_camera()
{
	trigger = GetEnt("trigger_crane_2_camera","targetname");
	//trigger waittill("trigger");
	trigger jump_trigger();
	trigger delete();

	level notify("checkpoint_reached");

	//Music notify, added by Chuck Russom
					
	level notify("playmusicpackage_roof");
	
	//Steve G
	level.player PlaySound("crane_roof_jump");

	//flag_clear("arrow_hint");
	
	endcutscene("Bomber_Chase_5");
	Playcutscene("bnd_jump_roof","Bond_Jump_Roof_Done");
	//wait(1.00);
	//earthquake(1, 1, level.player.origin, 256);
	playcutscene("Bomber_Chase_5B","Bomber_Chase_5B_Done");
	wait(2.5);
	
		// TODO: waitill notetrack when notetrack gets implemented

	level notify("fx_roofdent_dust");
	earthquake(1, 1, level.player.origin, 256);
	//iprintlnbold("Dust_now");

	roof = GetEnt("metal_undented","targetname");
	roof hide();

	dented_roof = GetEnt("metal_dented","targetname");
	dented_roof show();

	level waittill("Bond_Jump_Roof_Done");


	//flag_set("arrow_hint");
	
	SetDVar("sm_SunSampleSizeNear", 0.5);

	//Steve G
	level.player PlaySound("crane_breath_three");

	//rail = spawn("script_origin",level.player.origin);
	//level.player linkto( rail );
	//wait(0.5);
	destination = GetEnt("crane2_end","targetname");
	level.player SetOrigin(destination.origin);
	level.player SetPlayerAngles(destination.angles);
	//rail moveto(destination.origin,.05);
	//rail rotateto(destination.angles,.05);
	//rail waittill ("rotatedone");

	//level.player unlink();

	//move the scissor lift cage down to hide hover
	cage = GetEnt("scissorlift_cage","targetname");
	cage MoveZ(152,0.5);

	//save game
	maps\_autosave::autosave_now("construction");
	level thread create_time_limit(level.timer_set);
	level thread maps\_utility::timer_restart(level.timer_set);

	//////////////////////////////////////
	//comment out for demo
	//level thread set_default_pip();
	///////////////////////////////////////

	//level thread create_time_limit(level.timer_set);
	//level thread maps\_utility::timer_restart(level.timer_set);
}

scissor_lift_camera()
{
	trigger = GetEnt("scissor_lift_cam_trigger","targetname");
	camera_change = false;
	cameraID_test = undefined;

	while(1)
	{
		if(level.player IsTouching(trigger))
		{
			if(camera_change == false)
			{
				//change camera to 3rd person
				cameraID_test = level.player customCamera_Push( "offset",  (-30, 0.0, 70.0), (60.0, 0.0, 0.0), 0.5);
				camera_change = true;
			}
		}
		else
		{
			if(camera_change == true)
			{
				//pop camera
				level.player customCamera_pop( cameraID_test, 0.5 );
				camera_change = false;
			}
		}

		wait(0.1);
	}
}

crane_collapse()
{
	trigger = GetEnt("trigger_crane_collapse","targetname");
	trigger waittill("trigger");
	trigger delete();

	balance_beam = GetEnt("crane_balance","targetname");
	crane = GetEnt("moving_crane","targetname");
	//Steve G
	crane playsound("crane_collapse");
	
	balance_beam linkto(crane);

	//rotate crane down and make small earthquake
	crane rotateroll(1, 0.2);
	crane waittill("rotatedone");
	earthquake(0.2, 1, level.player.origin, 256);

}

crane_up()
{
	//wait for bond to leap out to the pipes to pull back for a 3rd person camera
	trigger = GetEnt("trigger_climb_camera","targetname");
	rail = spawn("script_origin", trigger.origin);
	trigger enablelinkto();
	trigger linkto(rail);
	rail movex(24, 0.05);
	//trigger waittill("trigger");
	trigger jump_trigger();
	trigger delete();


	
	//iprintlnbold("bond jump to crane");
	

	SetDVar("sm_SunSampleSizeNear", 1.5);
	
	level thread ambience_lumber_yard();
	level thread ambience_move_boats();
	
	level notify("checkpoint_reached");
	
	//Steve G
	level.player PlaySound("jump_to_pipes");
	
	//Music notify, added by Chuck Russom
				
	level notify("playmusicpackage_crane1");
	
	//flag_clear("arrow_hint");
	playcutscene("Bond_Jump_to_Pipes","Bond_Jump_to_Pipes_Done");

	level waittill("Bond_Jump_to_Pipes_Done");
	rail = spawn("script_origin",level.player.origin);
	//level.player linkto( rail );
	//player_stick(false); 
	level.player PlayerLinkToAbsolute(rail);
	
	//readjust balance beam settings
	SetSavedDVar("Bal_wobble_accel", 1.025);
	SetSavedDVar("Bal_wobble_decel", 1.05);

	//start timer
//	level thread create_time_limit(8);

	collision = GetEnt("crane_collision","targetname");
	collision delete();
		
	trigger = GetEnt("trigger_detach_pipes","targetname");
	trigger sethintstring(&"CONSTRUCTIONSITE_DETACH_PIPE");	
	trigger waittill("trigger");
	trigger delete();

	level notify("checkpoint_reached");
	
	//Steve G
	level.player PlaySound("rappel_up_crane");

	rail rotatepitch(65, 1);
	wait(1);

	//move buckle and bond up the crane
	buckle = GetEnt("crane_buckle_script","targetname");
	buckle linkto( rail);	
	physicsExplosionCylinder(buckle.origin, 300.0, 200.0, 1.0);
	level notify("pipe_drop_02_start");
	destination = GetEnt("crane_end","targetname");
	rail moveto(destination.origin,5);
		
	wait(3.7);
	level.player unlink();
	buckle unlink();
	level thread create_time_limit(level.timer_set);
	level thread maps\_utility::timer_restart(level.timer_set);
	//Steve G
	level.player PlaySound("climb_high_crane");

	playcutscene("BondClimbPipesTop","Bond_Climb_Pipes_Top_Done");
	level notify("fx_birds_takeoff1");
	
	origin = getent("bird_origin", "targetname");
	//iprintlnbold("SOUND: Birds takeoff 1");
	origin playsound ("Birds_Taking_Off");
	
	//readjust player orientation after the cutscene
	level waittill("Bond_Climb_Pipes_Top_Done");
	//flag_set("arrow_hint");

	level.player SetOrigin(destination.origin);
	level.player SetPlayerAngles(destination.angles);
	
	//Steve G
	level.player PlaySound("crane_breath_one");
	
	//level.player linkto(rail);
	//rail rotateto(destination.angles, 0.05);
	//rail waittill("rotatedone");
	//level.player unlink();

	//turn off buffering so bomber can be seen in PIP
	//SetDVar("cg_pip_buffering","0");
	//SetDVar("r_pipSecondaryMode", 5);

	//////////////////////////////////////
	//comment out for demo
	//level thread set_default_pip();
	/////////////////////////
	
	
	//save game
	maps\_autosave::autosave_now("construction");

		//////////////////////////////////////
	//comment out for demo
	//level thread set_default_pip();
	/////////////////////////

	//start timer
//	level thread create_time_limit(38);

	//start bomber to the elevator
	endcutscene("Bomber_Chase_4");

	bomber_5();
}

bomber_5()
{
	playcutscene("Bomber_Chase_5","Bomber_Chase_5_Done");
	level thread bomber_ride_elevator();

	//speed of the balance beam walk
	SetSavedDVar("bal_move_speed", 100.0);

	level waittill("Bomber_Chase_5_Done");
	set_default_main();
}

drywall_break()
{
	//grab worker in the cutscene and give him a wrench
	worker = GetEnt("worker","targetname");
	worker gun_remove();
	worker attach( "p_msc_wrench", "TAG_WEAPON_RIGHT" );
	//worker_fall = getent("worker", "targetname");
	

	//wait for the trigger in the hallway
	trigger = GetEnt("trigger_drywall","targetname");
	trigger waittill("trigger");
	worker show();

	level notify("ibeam_wire_loose_start");
	
	//spawn the workers in the girders area
	level 	thread ambience_girders();
	
	//remove timer and clear pip of static
	level notify("checkpoint_reached");
	SetDVar("cg_pipstatic_opacity", "0"); 

	//timescale the scene
	SetSavedDVar("timescale","0.75");

	//shrink main screen and enlarge the pip
	//SetDVar("r_pipSecondaryX", 0.04);
	//SetDVar("r_pipSecondaryY", 0.04);						// place top left corner of display safe zone
	//SetDVar("r_pipSecondaryAnchor", 0);						// use top left anchor point
	//SetDVar("r_pipSecondaryScale", "1.0 1.0 1.0 1.0");		// scale image, without cropping

	//SetDVar("r_pip1X", "0.55");
	//SetDVar("r_pip1Y", "0.55");
	//SetDVar("r_pip1Scale", "0.41 0.43 1.0 1.0");
	//SetDVar("r_pipMainMode", "1");


	//auto pilot bond to the drywall
	//rail = spawn("script_origin",level.player.origin);
	//rail.angles = level.player.angles;
	//level.player linkto( rail );
	//location = GetEnt("drywall_position","targetname");
	//rail moveto(location.origin,1);
	//rail rotateto(location.angles,1);

	//start bomber fight cutscene
	// Steve G

	wait(0.5);
	level.player Playsound("igc_bomber_fight");
	endcutscene("Bomber_Chase_3");
	playcutscene("Bomber_Chase_4","Bomber_Chase_4_Done");
	//wait(.25);
	//SetDVar("cg_pip_buffering","0");
	//SetDVar("r_pipSecondaryMode", 5);
	
		//////////////////////////////////////
	//comment out for demo
	//level thread set_default_pip();
	/////////////////////////

	wait(1.0);
	//notify propane tank to fall off
	level notify("propane_fall_start");
	
	//Added by Steve G
	//level.player PlaySound("acetylene_tank_drop");

//	wait(2);

	//level.player unlink();
	//level.player freezecontrols(true);
		
	
	//reset the main screen and pip
	//SetDVar("r_pipSecondaryX", 0.05);
	//SetDVar("r_pipSecondaryY", 0.05);						// place top left corner of display safe zone
	//SetDVar("r_pipSecondaryAnchor", 0);						// use top left anchor point
	//SetDVar("r_pipSecondaryScale", "0.5 0.5 1.0 1.0");		// scale image, without cropping

	//SetDVar("r_pip1X", "0");
	//SetDVar("r_pip1Y", "0");
	//SetDVar("r_pip1Scale", "1.0 1.0 1.0 1.0");
	//SetDVar("r_pipMainMode", "0");

	//notify fx to break the wall
	//flag_clear("arrow_hint");
	
	
	trigger = getent("drywall_cam", "targetname");
	trigger waittill("trigger");

	sound = random(level.radio_not_played);
	level.player play_dialogue_nowait(sound);
	level.radio_not_played = array_remove(level.radio_not_played, sound);

	level thread create_time_limit(level.timer_set);
	level thread maps\_utility::timer_restart(level.timer_set);
		
	
	level notify("propane_explode_now");

	if(level.ps3)
	{
		VisionSetNaked( "constructionsite_0_B_ps3");	
		
	}
	else
	{
		VisionSetNaked( "constructionsite_0_B");	
	}

	
	//setExpFog(level.fognearplane, level.fogexphalfplane, level.fogred, level.foggreen, level.fogblue, 0, level.fogmax);
	setExpFog( 1536.26, 2548.21, 0.406, 0.476, 0.554, 0, 0.829);

	playcutscene("Bond_Drywall","Bond_Drywall_Done");
	level notify("drywall_break_start");
	level notify("fx_drywall_dust");
	// Added by Steve G
	level.player playsound("drywall_break");
	earthquake(0.4, .5, level.player.origin, 256);

	level waittill("Bond_Drywall_Done");
	
	rail = spawn("script_origin",level.player.origin);
	level.player playerlinkto( rail,undefined,0,20,20,10,10);
	location = GetEnt("origin_player_explosion","targetname");
	rail moveto(location.origin,.05);
	rail waittill("movedone");
	rail rotateto(location.angles,.05);
	rail waittill("rotatedone");
	
	
	SetSavedDVar("timescale","1.0");
	
	//Added by Steve G
	level.player PlaySound("acetylene_explode");
	
	// Music notify, added by Chuck Russom
	level notify ("endmusicpackage");
	
	//attempt to prevent crash
	wait(.25);

	//EXPLOSION
	exp_origin = GetEnt("welding_explosion_origin","targetname");
	//Added by Steve G
	//exp_origin PlaySound("acetylene_explode");
	//level.player PlaySound("acetylene_explode_lfe");

	earthquake(0.6, 1, level.player.origin, 256);
	bent_floor = GetEnt("grate_bent","targetname");
	bent_floor trigger_on();

	floor = GetEnt("grate_unbent","targetname");
	floor delete();

	girder_1 = GetEnt("girderA_script","targetname");
	girder_2 = GetEnt("girderB_script","targetname");
	//girder_1 physicslaunch(girder_1.origin, vectornormalize((-90,0,-9.8)));
	//girder_2 physicslaunch(girder_2.origin, vectornormalize((90,0,-9.8)) );
	
	// Steve G
	wait (0.7);
	earthquake(0.4, 1.8, level.player.origin, 256);
	wait (0.8);
	
	dynEnt_StartPhysics("walkway_planks");
	// Added by Steve G
	level.player PlaySound("fall_through_boards");
	level.player unlink();
	worker = spawn_civilian(GetEnt("spawner_falling_worker_2","targetname"));
	worker dodamage(worker.health + 200, worker.origin);
	
	//level.player freezeControls(false);
	playcutscene("Bond_FloorFall","Bond_FloorFall_Done");

	plank_hide = getent("planks_hide", "targetname");
	plank_hide delete();
	
	// Music notify, added by Chuck Russom		
	wait (1.0);
	level notify ("playmusicpackage_floorfall");
	
	level notify("ibeam_wire_tight_start");
	
	level waittill("Bond_FloorFall_Done");
	
	/*level.control_light = GetEnt("control_panel_light", "targetname");
	level.control_light light_flicker(true);*/

	//flag_set("arrow_hint");

	//level.player freezecontrols(false);
	maps\_autosave::autosave_now("construction");
	
	ambience_girders_animate();

	//////////////////////////////////
	// comment out changed for demo
	//level thread set_default_pip();
//////////////////////////////////////////
	level thread create_time_limit(level.timer_set);
	level thread maps\_utility::timer_restart(level.timer_set);
	level.bomber thread bomber_create_impulse();

	//roughly when the bomber reaches the top of the crane and stops
	wait(15);

	//level notify("fx_birds_takeoff1");
	//iPrintLnBold("Birds!");

	wait(8);

	//turn the menu buffering on
	//SetDVar("r_pipSecondaryMode", 0);
	level thread set_default_main();

	//once the next chase begins turn off the buffering
	level waittill("Bomber_Chase_4_Done");
	//SetDVar("r_pipSecondaryMode", 5);

	/////////////////////////////////
	//comment out for demo
	//level thread set_default_pip();
	///////////////////////////////////////
}

elevator_crash()
{

	GetEnt("trigger_elevator_crash", "targetname") waittill("trigger");

	elevator = GetEntArray("elevator_platform_script","targetname");
	
	spark_origin_left = GetEnt("elevator_spark_left","targetname");
	spark_origin_right = GetEnt("elevator_spark_right","targetname");

	spark_origin_left linkto(elevator[0]);
	spark_origin_right linkto(elevator[0]);

	//Steve G
	elevator[0] PlaySound("construction_elevator_fall");
	level thread elevator_sparks();
	
	dynEnt_StartPhysics("elevator_props");

	for(i = 0; i < elevator.size; i++)
	{
		elevator[i] MoveZ(-436,3,3);
	}
	
	wait(3);

	earthquake(.8, 1, level.player.origin, 256);
	
	for(i = 0; i < elevator.size; i++)
	{
		elevator[i] RotateRoll(18,.5);
	}
	
	wait(1);
	level notify("fx_elevator_impact");
	level notify("elevator_crashed");

	wait(2);
	/*iprintlnbold("x = " + elevator[0].origin[0] + "Y = " + elevator[0].origin[1] + "z = " + elevator[0].origin[2]);
	iprintlnbold("x = " + elevator[0].angles[0] + "Y = " + elevator[0].angles[1] + "z = " + elevator[0].angles[2]);*/

	//level.control_light light_flicker(false, 0);
}

gradual_quake(time, final)
{
	//deltax = (newx*time) / 0.05;
	//

	//for(t = time; t > 0.00; )
	//{
	//	x += deltax;
	//	y += deltay;
	//	scale[0] += deltasx;
	//	scale[1] += deltasy;

	//	SetDVar("r_pipSecondaryX", x + "");
	//	SetDVar("r_pipSecondaryY", y + "");						// place top left corner of display safe zone
	//	SetDVar("r_pipSecondaryScale", scale[0] + scale[1] + " 1.0 1.0");		// scale image, without cropping

	//	wait(0.05);
	//	t -= 0.05;
	//}
}

awareness_girder_door(awareness_object)
{
	GetEnt("trigger_girder_door", "targetname") waittill("trigger");
	level notify("fence_door_start");

	collision = GetEnt("gate_bash_collision","targetname");
	//Steve G
	door_bash_org_var = GetEnt("door_bash_org","targetname");
	door_bash_org_var PlaySound("door_bash");
	Earthquake(1, .2, collision.origin, 256);
	collision delete();
}

awareness_scissor_lift(awareness_object)
{


	//flag_clear("arrow_hint");

	cage = GetEnt("scissorlift_cage","targetname");
	cage_d = GetEnt("scissorlift_cage_d","targetname");
	setExpFog( 0, 2195, 0.587434, 0.570319, 0.529037, 0, 0.676873);

	//start the van on it's path
	level notify("van_start");
	//level.player play_dialogue_nowait("TANN_ConsG_200A", true);
	level.radio_warning = false;
	
	cameraID_lift = level.player customCamera_Push("entity", level.player, level.player, (-39.67, 0.09, 225.87), (-4.70, -1.68, 0), 0.0);
	//cameraID_lift = level.player customCamera_Push("world", (1366.0, -2824.0, 655.0), (55.0, 38.0, 0.0), 0.2);

	level notify("checkpoint_reached");
	//player_stick(false);
	level.player freezecontrols(true);
	level.sticky_origin = Spawn("script_origin", level.player.origin);
	// NOTE: player.angles only stores the YAW
	level.sticky_origin.angles = level.player.angles;
	level.player PlayerLinkToAbsolute(level.sticky_origin);
	origin_camera = getent("scissor_lift_camera", "targetname");
	

	

	level.last_sprint = true;
	
	//Steve G
	level.player PlaySound("scissor_drop");
	level.sticky_origin linkto(cage_d);
	//level.player linkto(cage_d);

	cage_collision = GetEntArray("scissorlift_cage_collision","targetname");
	for(i = 0; i < cage_collision.size; i++)
	{
		cage_collision[i] linkto(cage);
	}
	cage_d_collision = GetEntArray("scissorlift_cage_d_collision","targetname");
	for(i = 0; i < cage_d_collision.size; i++)
	{
		cage_d_collision[i] linkto(cage_d);
	}
	wait(0.1);
	lift_up = GetEnt("scissorlift_up","targetname");
	lift_down = GetEnt("scissorlift_down","targetname");
	
	lift_down show();
	lift_up delete();
	oil_org = GetEnt("oil", "targetname");
	cameraID_lift = level.player customCamera_change(cameraID_lift, "world", origin_camera.origin, origin_camera.angles, 2.0);
	cage MoveZ(-330,1.5);
	cage_d MoveZ(-330,1.5);
	oil_org movez(-330,1.5);



	
	
	cage_d waittill("movedone");

	level notify("fx_scissorlift_impact");
	earthquake(0.8, 1, level.player.origin, 256);
	

	if(level.ps3)
	{
		VisionSetNaked( "constructionsite_0_ps3");	
		
	}
	else
	{
		VisionSetNaked( "constructionsite_0");	
	}	
	
	cage_d show();
	
	oil = Spawn("script_model", oil_org.origin);
	oil SetModel("tag_origin");
	oil LinkTo(cage);
	PlayfxOnTag(level._effect["const_oil_spray1"], oil, "tag_origin");
	cage delete();
	for(i = 0; i < cage_collision.size; i++)
	{
		cage_collision[i] delete();
	}

	maps\_utility::unholster_weapons();
	level.player disableweapons();

	//player_unstick();
		level.player Unlink();
	level.sticky_origin delete();
	level.sitcky_origin = undefined;

	level.player freezecontrols(false);



	level.player customCamera_pop( cameraID_lift, 0.0);

	//Steve G
	level.player PlaySound("jump_from_scissor");
	
	playcutscene("bnd_scissorlift","Bond_Scissorlift_Done");

	//adjust player angles
	level waittill("Bond_Scissorlift_Done");
	earthquake(0.8, 1, level.player.origin, 256);
	//rail = spawn("script_origin",level.player.origin);
	//level.player linkto( rail );
	location = GetEnt("origin_bond_van_chase","targetname");

	level.player SetOrigin(location.origin);
	level.player SetPlayerAngles(location.angles);
	//rail moveto(location.origin,.05);
	//rail rotateto(location.angles,.05);
	//rail waittill("rotatedone");
	//level.player unlink();

	//Carter tells Bond to catch up to the van
	level thread create_time_limit(12);
	level thread maps\_utility::timer_restart(12);
	level.player play_dialogue("TANN_ConsG_087A", true);

	//flag_set("arrow_hint");


}

bomber_catch_breath()
{
	//hack to turn off pip
	//wait(15);
	level waittill("Bomber_Chase_2_Done");
	SetDVar("r_pipSecondaryMode", 0);
	//level thread set_default_main();
	flag_wait("bomber_climb");
	playcutscene("Bomber_Chase_2B","Bomber_Chase_2B_Done");
	wait 2;
	level thread show_useless_ents();
	//SetDVar("r_pipSecondaryMode", 5);
////////////////////////////
	//comment out for demo
	//level thread set_default_pip();
////////////////////////////////////////////////	
	
	//level waittill("Bomber_Chase_2B_Done");	// no notetrack in anim

	t = 0;
	w = .05;
	b = false;
	while (!flag("trigger_jump_table"))
	{
		wait w;
		t += w;

		if ((t >= 9) && !b)
		{
			b = true;
			//SetDVar("r_pipSecondaryMode", 0);
			level thread set_default_main();
		}
	}
	
	level notify("spawn_inside_workers");

	endcutscene("Bomber_Chase_2B");
	playcutscene("Bomber_Chase_3","Bomber_Chase_3_Done");

	//SetDVar("r_pipSecondaryMode", 5);
//////////////////////////////////////
	//comment out for demo
	//level thread set_default_pip();
//////////////////////////////////////

	wait(3.5);
	exp_origin = GetEnt("worker_bench_exp","targetname");
	physicsExplosionSphere( exp_origin.origin, 50, 20, 0.4);
	exp_origin Playsound("jumping_buckets");
	
	wait(2.5);
	level notify("pipe_break_start");
	level.bomber Playsound("pipe_collapse");

}


bomber_ride_elevator()
{
	level waittill("Bomber_Chase_5B_Done");
	
	//SetDVar("cg_pip_buffering","1");
	//SetDVar("r_pipSecondaryMode", 0);
	level thread set_default_main();
	elevator = GetEnt("elevator_platformb_script","targetname");
	level.bomber linkto(elevator);
	wait(.05);
	level.bomber CmdPlayAnim("Bomber_Elevator_Cycle");

	trigger = GetEnt("objective_update_3","targetname");
	trigger waittill("trigger");

	//SetDVar("cg_pip_buffering","0");
	//SetDVar("r_pipSecondaryMode", 5);

	//////////////////////////////////////
	//comment out for demo
	//level thread set_default_pip();
	//////////////////////////////////////
	
	//OBJECTIVE UPDATE
	cage = GetEnt("scissorlift_cage","targetname");
	objective_add(5, "active",&"CONSTRUCTIONSITE_FIND_A_WAY_HEADER", cage.origin, &"CONSTRUCTIONSITE_FIND_A_WAY_BODY");
	
	//Steve G
	elevator PlaySound("cage_elevator_down");

	elevator moveZ(-400,5);
	elevator waittill("movedone");
	
	level.bomber unlink();
	level.bomber notify("stop_animating_elevator");
	endcutscene("Bomber_Chase_5B");
	playcutscene("Bomber_Chase_6","Bomber_Chase_6_Done");

	level waittill("Bomber_Chase_6_Done");

	//SetDVar("cg_pip_buffering","1");
	//SetDVar("r_pipSecondaryMode", 0);
	level thread set_default_main();
}

bomber_create_impulse()
{
	self endon("stop_bomber_impulse");

	while(1)
	{
		physicsExplosionSphere( level.bomber.origin + (30, 30, 0) , 30, 1, .4);
		wait(.05);
	}
}

//workers running away from the digger in it's path
ambience_run_from_digger()
{

	
	worker_2 = GetEnt("digger_rail_worker_2","script_noteworthy");
	worker_3 = GetEnt("digger_rail_worker_3","script_noteworthy");
	worker_4 = GetEnt("digger_rail_worker_4","script_noteworthy");
	worker_5 = GetEnt("digger_rail_worker_5","script_noteworthy");
	worker_6 = GetEnt("digger_rail_worker_6","script_noteworthy");
	worker_fall = getent("worker", "targetname");
	worker_fall hide();
	worker_2 hide();
	worker_3 hide();
	worker_4 hide();
	worker_5 hide();
	worker_6 hide();
	
	//wait(3);
	level waittill("civ_run_off");
	worker_1 = GetEnt("digger_rail_worker_1","script_noteworthy");
	worker_1 SetScriptSpeed("Run");
	goal_1 = GetNode("digger_rail_goal_1","targetname");
	worker_1 SetGoalNode(goal_1);

	//wait(5);
	level waittill("shed_roof_start");

	worker_2 show();
	worker_3 show();
	worker_4 show();
	worker_5 show();
	worker_6 show();
	
	worker_2 SetScriptSpeed("Run");
	goal_2 = GetNode("digger_rail_goal_2","targetname");
	worker_2 SetGoalNode(goal_2);

	
	worker_3 SetScriptSpeed("Run");
	goal_3 = GetNode("digger_rail_goal_3","targetname");
	worker_3 SetGoalNode(goal_3);

	
	worker_4 SetScriptSpeed("Run");
	goal_4 = GetNode("digger_rail_goal_4","targetname");
	worker_4 SetGoalNode(goal_4);

	
	worker_5 SetScriptSpeed("Run");
	goal_5 = GetNode("digger_rail_goal_5","targetname");
	worker_5 SetGoalNode(goal_5);

	
	worker_6 SetScriptSpeed("Run");
	goal_6 = GetNode("digger_rail_goal_6","targetname");
	worker_6 SetGoalNode(goal_6);

	level waittill("digger_crash_finished");
	clear_civilians("digger_rail_worker");
}

//workers in the sand area with the broken pipes
ambience_detour_area()
{
	workers = [];

	worker_spawners = GetEntArray("spawner_detour_area","targetname");
	for(i = 0; i < worker_spawners.size; i++)
	{
		workers[i] = spawn_civilian(worker_spawners[i]);
		workers[i].targetname = "detour_area";
		workers[i] thread civilian_action_warn();
		wait(0.3);
	}

	//wait for the delete flag for this group of workers
	//level waittill("clear_civilians_1");
	GetEnt("cleanup_before_crane1", "targetname") waittill("trigger");

	//remove all civilians in this group
	clear_civilians("detour_area");
}

//for the two floors as Bond goes up the crane
ambience_other_floors()
{
	workers = [];

	//grab the spawners
	worker_spawner = GetEntArray("spawner_sublevel_worker","targetname");
	for(i = 0; i < worker_spawner.size; i++)
	{
		//spawn the civilians into the array and set their targetnames
		workers[i] = spawn_civilian(worker_spawner[i]);
		workers[i].targetname = "civilians_sublevel";
	}

	//wait for the delete flag for this group of workers
	level waittill("clear_civilians_1");

	//remove all civilians in this group
	clear_civilians("civilians_sublevel");
}

ambience_inside_building_animate_1()
{
	//worker who is hammering posters outside
	worker_hammer = GetEnt("worker_hammer","script_noteworthy");
	worker_hammer gun_remove();
	worker_hammer attach( "p_msc_ball_hammer", "TAG_WEAPON_RIGHT" );
	worker_hammer thread civilian_action_anim("Gen_Civs_Hammering");
	
	flag_wait("trigger_jump_table");

	//worker walking down the stairs
	worker_walk = GetEnt("worker_walk_stairs","script_noteworthy");
	worker_walk gun_remove();
	worker_dest = GetNode("stair_well_goal","targetname");
	worker_walk SetGoalNode(worker_dest);
}

ambience_inside_building_animate_2()
{
	//worker using the tablesaw
	worker_saw = GetEnt("worker_saw","script_noteworthy");
	worker_saw gun_remove();
	worker_saw thread civilian_action_anim("Gen_Civs_TableToolOperate");

	//start the sparks for the saw
	level thread saw_sparks();

	//worker examining the blueprints
	worker_blueprint = GetEnt("worker_blueprint","script_noteworthy");
	worker_blueprint gun_remove();;
	worker_blueprint thread civilian_action_anim("Gen_Civs_BluePrintExamine");

	//worker welding the pipes
	worker_weld = GetEnt("worker_weld","script_noteworthy");
	worker_weld gun_remove();
	worker_weld thread civilian_action_anim("Gen_Civs_WallToolOperate");

	wait(2);

	//worker walking inside
	worker_walk = GetEnt("worker_walk","script_noteworthy");
	worker_walk gun_remove();
	worker_dest = GetNode("worker_move_goal","targetname");
	worker_walk SetGoalNode(worker_dest);

	//wait for the delete flag for this group of workers
	//level waittill("clear_civilians_1");
	
	//remove all civilians in this group
	//clear_civilians("inside_worker");
	//clear_civilians("inside_worker_first");
}

//any workers inside of the the building
ambience_inside_building()
{
	GetEnt("cleanup_before_crane1", "targetname") waittill("trigger");

	wait 1;

	spawners = GetEntArray("inside_worker_first", "targetname");
	for (i = 0; i < spawners.size; i++)
	{
		guy = spawners[i] StalingradSpawn();
		guy thread delete_guy();
		spawners[i] delete();
	}
	
	ambience_inside_building_animate_1();
	
	level waittill("spawn_inside_workers");
	spawners = GetEntArray("inside_worker", "targetname");
	for (i = 0; i < spawners.size; i++)
	{
		guy = spawners[i] StalingradSpawn();
		guy thread delete_guy();
		spawners[i] delete();
	}
	
	ambience_inside_building_animate_2();

}

delete_guy()
{
	level waittill("clear_civilians_1");
	self delete();
}

//three workers that run away as the pipes fall to the ground
ambience_ground_falling_pipes()
{
	trigger = GetEnt("objective_update_2","targetname");
	trigger waittill("trigger");
	
	workers = [];

	for(i = 1; i < 7; i++)
	{
		workers[i] = spawn_civilian( GetEnt("spawner_pipe_watcher_"+i,"targetname") );
		wait(0.05);
	}

	trigger = GetEnt("trigger_detach_pipes","targetname");
	trigger waittill("trigger");

	for(i = 1; i < 7; i++)
	{
		workers[i].targetname = "civilians_falling_pipes";
		workers[i] SetScriptSpeed("Run");
		workers[i] SetGoalNode( GetNode("pipe_goal_"+i,"targetname") );
		wait(0.05);
	}

	wait(1.7);

	//notify the corresponding explosion for the pipes falling
	level notify("fx_acetylene_exp2");

	//wait for the delete flag for this group of workers
	level waittill("clear_civilians_2");

	//remove all civilians in this group
	clear_civilians("civilians_falling_pipes");
}

//worker inside the elevator that the bomber goes down on
ambience_elevator_worker()
{
	trigger = GetEnt("objective_update_2","targetname");
	trigger waittill("trigger");

	elevator = GetEnt("elevator_platformb_script","targetname");
	worker = spawn_civilian( GetEnt("spawner_elevator_worker","targetname") );
	worker linkto (elevator);
}

ambience_scissor_lift_area()
{
	trigger = GetEnt("objective_update_2","targetname");
	trigger waittill("trigger");

	worker_spawner = GetEntArray("spawner_scissor_worker","targetname");
	for(i = 0; i < worker_spawner.size; i++)
	{
		//spawn the civilians into the array and set their targetnames
		workers[i] = spawn_civilian(worker_spawner[i]);
		workers[i].targetname = "civilians_scissor";
	}
}

// Helper scripts... split the ambience stuff into spawn and animate functions

ambience_girders_animate()
{
	//move worker to the hanging position
	worker_hang = GetEnt("girder_hang","targetname");
	rail = Spawn("script_origin",worker_hang.origin);
	worker_hang linkto(rail);
	worker_hang_position = GetEnt("lock_hang","targetname");
	rail rotateto(worker_hang_position.angles, 0.05);
	rail moveto(worker_hang_position.origin,0.05);
	rail waittill("movedone");
	worker_hang thread civilian_action_anim("Gen_Civs_GirderHang");

	//worker being scared
	worker_scared = GetEnt("girder_scared","targetname");
	worker_scared thread civilian_action_anim("Gen_Civs_ConstructWorkerYellV2");

	//worker yelling at Bond	
	worker_warn = GetEnt("girder_warn","targetname");
	worker_warn thread civilian_action_anim("Gen_Civs_ConstructWorkerYellV1");

	wait(5);

	//make hanging worker fall
	//worker_hang notify("stop_anim");
	//worker_hang unlink();
	//worker_hang thread civilian_action_anim("Gen_Civs_Fall");
}

ambience_girders()
{
	//grab the spawners
	worker_spawner = GetEntArray("spawner_worker_girder","targetname");
	for(i = 0; i < worker_spawner.size; i++)
	{
		worker = spawn_civilian(worker_spawner[i]);
		worker.targetname = worker_spawner[i].script_noteworthy;
	}
	

	wait(6);

	ambience_girders_animate();
	
	////wait for the delete flag for this group of workers
	level waittill("clear_civilians_2");

	//remove all civilians in this group
	clear_civilians("girders_worker");
}

//a digger is moving in the lumber yard with a worker making signals at it
ambience_lumber_yard()
{
	digger = GetEnt("lumber_yard_digger","targetname");

	path = [];

	for(i = 0; i < 4; i++)
	{
		path[i] = GetEnt("lumber_path_"+i,"targetname");
	}

	digger MoveTo(path[0].origin,8);
	//Steve G
	digger PlaySound("crane_earth_mover_distant");
	digger RotateTo(path[0].angles,8);

	digger waittill("movedone");

	digger MoveTo(path[1].origin,6);
	digger RotateTo(path[1].angles,6);

	digger waittill("movedone");

	digger MoveTo(path[2].origin,5);
	digger RotateTo(path[2].angles,5);

	digger waittill("movedone");

	digger MoveTo(path[3].origin,3);
	digger RotateTo(path[3].angles,3);


}

move_elevator_switch()
{
	org = GetEnt("elevator_wind_origin","targetname");
	while(1)
	{
		physicsExplosionSphere( org.origin, 30, 5, .1 );
		wait(2);
	}
}

ambience_move_boats()
{
	speed_boat_1 = GetEnt("speedboat01","targetname");
	speed_boat_1 moveto(GetEnt("speedboat01_origin","targetname").origin, 50);

	speed_boat_2 = GetEnt("speedboat02","targetname");
	speed_boat_2 moveto(GetEnt("speedboat02_origin","targetname").origin, 50);

	sail_boat_1 = GetEnt("sailboat01","targetname");
	sail_boat_1 moveto(GetEnt("sailboat01_origin","targetname").origin, 50);

	sail_boat_2 = GetEnt("sailboat02","targetname");
	sail_boat_2 moveto(GetEnt("sailboat02_origin","targetname").origin, 50);

	sail_boat_3 = GetEnt("sailboat03","targetname");
	sail_boat_3 moveto(GetEnt("sailboat03_origin","targetname").origin, 50);

	boat_1 = GetEnt("boat01","targetname");
	boat_1 moveto(GetEnt("boat01_origin","targetname").origin, 60);
}

//arrow_hint()
//{
//	level thread breadcrumb();
//	level thread show_arrow();
//
//	while (IsDefined(level.breadcrumb))
//	{
////		level.player ArrowSetGoal((level.breadcrumb.origin[0], level.breadcrumb.origin[1], level.player.origin[2]));
//		level waittill("breadcrumb_update");
//	}
//
////	level.player ArrowSetGoal((0, 0, 0));
////	SetSavedDVar("cg_showDirectionArrow", "0");
//}
//
//show_arrow()
//{
//	flag_init("arrow_hint");
//	return;//turned off for demo
//	wait(0.01); // wait for dvars to be initialized
//
//	while (true)
//	{
//		if (flag("arrow_hint"))
//		{
////			SetSavedDVar("cg_showDirectionArrow", "1");
//		}
//		else
//		{
////			SetSavedDVar("cg_showDirectionArrow", "0");
//		}
//
//		level waittill("arrow_hint");
//	}
//}
//
//breadcrumb()
//{
//	level.breadcrumb = GetEnt("breadcrumb", "targetname");
//	while (IsDefined(level.breadcrumb))
//	{
//		level.breadcrumb waittill("trigger");
//		level.breadcrumb = GetEnt(level.breadcrumb.target, "targetname");
//		level notify("breadcrumb_update");
//	}
//}


#using_animtree("generic_human");
setup_car_driver()
{
	driver = Spawn( "script_model", self GetTagOrigin( "tag_driver" ) );
	driver.angles = self.angles;
	driver character\character_tourist_1::main();
	driver LinkTo( self, "tag_driver" );
	
	// play anims
	driver useAnimTree(#animtree);
	driver setFlaggedAnimKnobRestart("idle", %vehicle_driver);
	
	// delete at end node.
	self waittill("reached_end_node");
	driver delete();
}	
hide_useless_ents()
{
	pipe_drop = getent("fxanim_pipe_drop_02", "targetname");
	propane = getent("fxanim_propane_fall", "targetname");
	wires = getentarray("fxanim_ibeam_wire_loose", "targetname");
	wires_2 = getentarray("fxanim_ibeam_wire_tight", "targetname");


	pipe_drop hide();
	propane hide();

	for(i = 0; i < wires.size; i++)
	{

		wires[i] hide();

	}
	for(i = 0; i < wires_2.size; i++)
	{

		wires_2[i] hide();

	}
		

}

show_useless_ents()
{
	pipe_drop = getent("fxanim_pipe_drop_02", "targetname");
	propane = getent("fxanim_propane_fall", "targetname");
	wires = getentarray("fxanim_ibeam_wire_loose", "targetname");
	wires_2 = getentarray("fxanim_ibeam_wire_tight", "targetname");
	
	pipe_drop show();
	propane show();

	for(i = 0; i < wires.size; i++)
	{
		wires[i] show();
	}
	for(i = 0; i < wires_2.size; i++)
	{
		wires_2[i] show();
	}
		
}