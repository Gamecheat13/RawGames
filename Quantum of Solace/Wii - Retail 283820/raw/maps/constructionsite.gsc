#include animscripts\shared;
#include maps\_utility;
#include maps\_anim;

#include maps\constructionsite_util;

#using_animtree("generic_human");

main()
{
	
	maps\constructionsite_fx::main();
	maps\_vvan::main("v_van_white_radiant");
	maps\_vdigger::main("v_digger_motion_radiant");
	maps\_load::main();
	maps\constructionsite_mus::main();
	maps\_sea::main();

	
	SetSavedDVar("cover_dash_fromCover_enabled", false);
	SetSavedDVar("cover_dash_from1stperson_enabled", true);
	
	
	
	if( Getdvar( "artist" ) == "1" )
	{
		maps\_load::main();
		return;
	}	
	
	maps\createart\constructionsite_art::main();
	
	setExpFog( 0, 2195, 0.587434, 0.570319, 0.529037, 0, 0.676873);
	
	SetDVar("sm_SunSampleSizeNear", 0.5);

	
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

	precacherumble("movebody_rumble");
	character\character_tourist_1::precache();

	
	
	precacheShader( "compass_map_construction_site" );
	setminimap( "compass_map_construction_site", 4104, 312, -4632, -4640 );            

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
	
	level.radio_not_played = level.radio;
	level.radio_warning = true;

	flag_init("bomber_climb");	

	
	
	thread maps\constructionsite_snd::main();

	
	thread drywall_break();
	thread crane_arm_1_camera();
	thread crane_arm_2_camera();
	thread crane_up();
	thread level_end_van();
	
	
	thread ambience_other_floors();
	thread ambience_inside_building();
	thread ambience_ground_falling_pipes();
	thread ambience_elevator_worker();

	
	thread setup_vision();
	thread setup_bond();
	thread setup_objectives();
	level thread setup_new_objectives();
	thread setup_bomber();
	thread setup_deathplane();
	thread setup_awareness();
	thread setup_misc();
	thread elevator_crash();
	
	
	thread chase_fail();
	level thread trigger_check_van();
	level thread set_timer_base_on_difficulty();
	level thread start_amb_crane();
	level thread sand_grunt();


	
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

	
	

	van = getent("amb_van", "targetname");
	path = GetVehicleNode("level_end_path","targetname");
	van attachpath( path );
	van startpath();
}

set_timer_base_on_difficulty()
{
	if(getdvarint("level_gameskill") == 0)
	{
		level.timer_set = 50;
	}
	else if(getdvarint("level_gameskill") == 1)
	{
		level.timer_set = 38;	
	}
	else if(getdvarint("level_gameskill") == 2)
	{
		level.timer_set = 33;
	}
	else if(getdvarint("level_gameskill") == 3)
	{
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
	
	VisionSetNaked( "constructionsite_0");	
}

setup_new_objectives()
{
	trigger = getent("pursue_objective", "targetname");

	objective_add( 0, "current", &"CONSTRUCTIONSITE_CLIMB_THE_SITE_HEADER", trigger.origin, &"CONSTRUCTIONSITE_CLIMB_THE_SITE_BODY");
	trigger waittill("trigger");
	setSavedDvar( "cg_disableBackButton", "0" );
	trigger = getent("climb_crane_objective", "targetname");
	objective_state(0, "done" );
	objective_add( 1, "current", &"CONSTRUCTIONSITE_PURSUE_ON_FOOT_HEADER", trigger.origin, &"CONSTRUCTIONSITE_PURSUE_ON_FOOT_BODY");
	level.player play_dialogue_nowait("TANN_ConsG_085A", true);
	trigger waittill("trigger");
	VisionSetNaked( "constructionsite_2");	
	
	trigger = getent("get_to_ground_objective", "targetname");
	objective_state(1, "done" );
	objective_add (2, "current", &"CONSTRUCTIONSITE_GET_TO_CRANE_HEADER", trigger.origin, &"CONSTRUCTIONSITE_GET_TO_CRANE_BODY");
	level.player play_dialogue_nowait("TANN_ConsG_086A", true);
	trigger waittill("trigger");

	VisionSetNaked( "constructionsite_0");	
	trigger = getent("chase_van_objective", "targetname");
	objective_state(2, "done" );
	objective_add (3,"current", &"CONSTRUCTIONSITE_GET_TO_GROUND_HEADER", trigger.origin, &"CONSTRUCTIONSITE_GET_TO_GROUND_BODY");
		
	trigger waittill("trigger");
	van = getent("level_end_van", "targetname");
	objective_state(3, "done" );

	objective_add(4,"current", &"CONSTRUCTIONSITE_CATCH_THE_BOMBER_HEADER", van.origin, &"CONSTRUCTIONSITE_CATCH_THE_BOMBER_BODY");
}

setup_objectives()
{
	level.elevator_can_move = false;

	wait(0.05);
	trigger = GetEnt("objective_update_1","targetname");
	trigger waittill("trigger");

	flag_set("bomber_climb");

	level notify("climb_up_sand");		
	level notify("checkpoint_reached");
	wait(1.0);

	level thread create_time_limit(level.timer_set);
	flag_wait("trigger_jump_table");
	
	
	
		
	trigger = GetEnt("trigger_inside_vision","targetname");
	trigger waittill("trigger");
	VisionSetNaked( "constructionsite_1");	

	trigger = GetEnt("objective_update_2","targetname");
	trigger waittill("trigger");
	level notify("clear_civilians_1");
	trigger = GetEnt("trigger_lift_fall","targetname");
	trigger waittill("trigger");
	
	
	trigger = GetEnt("climb_crane_objective", "targetname");
	trigger waittill("trigger");
	
	level waittill("clear_civilians_2");
	level waittill("van_start");
}

setup_bond()
{
	holster_weapons();

	
	level.player allowProne(false);
	level.player allowCrouch(false);

	
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
	
	switch( getdvar( "skipto") )
	{
		case "girders":
		case "Girders":
			location = GetEnt("girders_start","targetname");
			level.player SetOrigin(location.origin);
			level.player SetPlayerAngles((location.angles));
			break;

		case "crane":
		case "Crane":
			location = GetEnt("crane_end","targetname");
			level.player SetOrigin(location.origin);
			level.player SetPlayerAngles((location.angles));
			level thread bomber_5();
			level.bomber thread bomber_create_impulse();
			level thread create_time_limit(level.timer_set);
			break;

		case "van":
		case "Van":
			location = GetEnt("skipto_van","targetname");
			level.player SetOrigin(location.origin);
			level.player SetPlayerAngles((location.angles));
			wait(1);

			
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

	
	precachemodel("v_digger_stationary_radiant");
	digger = GetEnt("digger_rail_end","targetname");
	digger hide();

	
	precacheModel("p_msc_wrench");
	precachemodel("p_msc_ball_hammer");

	
	
	

	
	
	

	
	cage = GetEnt("scissorlift_cage","targetname");
	cage MoveZ(-152,0.5);

	
	scissor_lift_down = GetEnt("scissorlift_down","targetname");
	scissor_lift_down hide();
	
	
	
	

	
	
	
	

	
	dented_roof = GetEnt("metal_dented","targetname");
	dented_roof hide();

	
	level.last_sprint = false;

	
	SetSavedDVar("bal_move_speed",70.0);

	
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

#using_animtree("generic_human");
level_end(awareness_object)
{
	level.player freezecontrols(true);

	clone_bond = Spawn( "script_model", level.player.origin );
	clone_bond SetModel( "tag_origin" );
	clone_bond setModel("bond_construction_body");
	clone_bond attach("bond_construction_head", "", false);
	clone_bond.voice = "american";

	clone_bond useanimtree(#animtree);
	clone_bond setanim(%Bnd_jmp_Van_idle, 1.0, 1.0, 1.0);



	level thread set_default_main();

	van_origin = GetEnt("van_attach_player","targetname");
	cameraID_van = level.player customCamera_Push("world", level.player.origin + (0,0,72), level.player.angles, 0.1);
	clone_bond moveto(van_origin.origin,.05);
	clone_bond rotateto(van_origin.angles,.05);
	clone_bond waittill ("movedone");
	
	
	level notify("checkpoint_reached");
	
	
						
	level notify("endmusicpackage");
	
	objective_state(4, "done");
	
	clone_bond LinkTo(van_origin);

	level.player play_dialogue_nowait("TANN_ConsG_201A", true);
	level thread fade_in_black(4, false);

	maps\_endmission::nextmission();
	return;
}


trigger_chase_fail()
{
	trigger = GetEnt("chase_fail","targetname");
	if ( IsDefined(trigger) )
	{
		trigger waittill("trigger");
		trigger delete();
		
		level notify("time_limit_reached");
	}
}

level_end_van()
{
	level thread trigger_chase_fail();		
	level waittill("van_start");
	
	
	level.van = GetEnt("level_end_van","targetname");
	level.van thread setup_car_driver();
	van_origin = GetEnt("van_attach_player","targetname");
	van_origin LinkTo(level.van);
	
	
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
	
			
						
			level notify("endmusicpackage");
	
			objective_state(4, "done");
	
	

	level.player play_dialogue_nowait("TANN_ConsG_201A", true);
	level thread fade_in_black(2, false);

	maps\_endmission::nextmission();
	return;


		}

		wait(0.1);





	}
	
	
	
	
	
	
	
	
	
	
	
	
	
}
	
#using_animtree("vehicles");
digger_rail()
{
	
	digger_rail = GetEnt("digger_rail","targetname");
	bike = getent("off_digger", "targetname");
	bike hide();
	
	
	path = GetVehicleNode("digger_rail_path","targetname");
	digger_rail setanim(%v_digger_steering, 1.0, 1.0, 1.0);
	
	digger_impulse = GetEnt("digger_impulse","targetname");
	digger_impulse linkto(digger_rail);
	
	digger_seat = GetEnt("digger_player_seat","targetname");
	digger_seat linkto(digger_rail, "", (0,0,85), (0,0,0));
	
	level.player PlayerLinkToDelta(digger_seat,undefined,1,20,20,10,10);

	
	digger_area = GetEntArray("digger_terrain","targetname");
	digger_area_destroyed = GetEntArray("digger_terrain_d","targetname");
	
	
	for(i = 0; i < digger_area_destroyed.size; i++)
	{
		digger_area_destroyed[i] trigger_off();
	}
	
	
	level.impulse_digger_flag = true;
	digger_rail playsound("earth_digger_move");
	digger_rail thread digger_create_impulse();

	digger_rail attachpath( path );
	digger_rail startpath();
	digger_rail thread digger_clear_forest();

	
	ent_tag = undefined;
	ent_tag = Spawn("script_model", digger_rail.origin + (0.0, 52.0, 142.70));
	ent_tag SetModel("tag_origin");
	ent_tag.angles = (0, 90, 0);
	ent_tag LinkTo(digger_rail);

	
	wait(0.1);
	setDvar( "cg_lockPitch", 1 );
	
	wait(17.9); 
	

	digger_rail useanimtree(#animtree);
	digger_rail setanim(%v_digger_bucket_up, 1.0, 1.0, 1.0);
	digger_rail waittill("reached_end_node");

	
	level notify("digger_crash_finished");
	
	endcutscene("Bomber_Chase");
	playcutscene("Bomber_Chase_2","Bomber_Chase_2_Done");
	

	
	level notify("playmusicpackage_start");
	level thread bomber_catch_breath();

	
	level.impulse_digger_flag = false;

	
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
	
	
	earthquake(0.8, 1, level.player.origin, 256);
	
	wait(1);

	
	setDvar( "cg_lockPitch", 0 );

	
	level.player unlink();


	SetSavedDVar("ik_bob_pelvis_scale_1st","1.5");
	level.player allowCrouch(true);
	SetSavedDVar("cg_fov","80");

	node_start = getvehiclenode("move_off_digger_1", "targetname");
	maps\_vehicle::vehicle_init( bike );

	bike attachpath(node_start);
	level.player playerlinkto( bike, "tag_origin", 0);
	level.player setgod( true );
	
	wait(0.1);
	bike startpath( node_start );
	bike waittill("reached_end_node");
	level.player unlink();
	bike delete();
	
	level.player setgod( false );

	

	digger_rail delete();
	digger_rail = GetEnt("digger_rail_end","targetname");
	digger_rail show();
	player_unstick();
	
	level.player freezecontrols(false);
	ent_tag delete();	
	maps\_autosave::autosave_now("construction");
	level thread create_time_limit(level.timer_set);
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
	
	rail_warn = GetEnt("intro_warn","targetname");
	rail_warn thread civilian_action_warn();
	rail_dig = GetEnt("intro_dig","targetname");
	rail_dig thread civilian_action_anim("Gen_Civs_HoleDig");

	
	trigger = GetEnt("trigger_forest_1","targetname");
	trigger waittill("trigger");
	trigger delete();

	
	tree_one = GetEnt("rail_tree_1","targetname");
	
	level.player playlocalsound("treefall_01");
	earthquake(0.4, .5, level.player.origin, 256);
	tree_one RotatePitch(90, 0.7);

	
	trigger = GetEnt("trigger_forest_2","targetname");
	trigger waittill("trigger");
	trigger delete();

	
	level notify("fx_foliage_burst");

	
	rail_warn delete();
	rail_dig delete();

	
	van = GetEnt("level_start_van","targetname");
	path = GetVehicleNode("level_start_path","targetname");
	van attachpath( path );
	van startpath();

	
	palm = GetEnt("rail_tree_2","targetname");
	earthquake(0.4, 3, level.player.origin, 256);
	
	level.player playlocalsound("treefall_02");
	palm RotatePitch(85,0.7);
	wait(1);

	
	
	bush2 = GetEnt("shrub_fall2","targetname"); 
	
	
	bush2 RotatePitch(-85,0.7);

	
	tree_two = GetEnt("tree_fall","targetname");
	tree_two playsound("chain_link_hit");
	tree_two RotatePitch(90,1,0.25);

	
	dynEnt_StartPhysics("fence_fall");
	earthquake(0.4, 3, level.player.origin, 256);

	
	level thread ambience_run_from_digger();
	wait(2);
	
	
	playcutscene("Bomber_Chase","Bomber_Chase_Done");
	wait(4.5);

	
	wait(1);

	
	earthquake(0.4, 3, level.player.origin, 256);
	
	wait(1);

	dynEnt_StartPhysics("digger_barrels");
	wait(1);
	dynEnt_StartPhysics("digger_fence");
	
	level.player playlocalsound("chain_link_collapse");
	earthquake(0.4, 1, level.player.origin, 256);

	wait(1.5);

	dynEnt_StartPhysics("digger_pipes");
	
	level.player playlocalsound("metal_barrels_crash");
	earthquake(0.4, 1, level.player.origin, 256);
	

	
	
	
	
}

digger_aftermath_pipes()
{
	
	level notify("fx_water_pipe");
	
	
	trigger = GetEnt("trigger_pipe_fall","targetname");
	trigger waittill("trigger");
	trigger delete();
	
	wait(1.1);
	level notify("pipe_drop_01_start"); 
	
	thread Maps\constructionsite_snd::crane_load_drop();

	earthquake(0.3, 1, level.player.origin, 30);



}

crane_arm_1_camera()
{
	trigger = GetEnt("trigger_crane_1_camera","targetname");
	trigger jump_trigger();
	trigger delete();
	
	
	level.player PlaySound("high_crane_jump");

	
	level notify("playmusicpackage_crane2");
	playcutscene("Bond_Jump_to_Crane2","Bond_Jump_to_Crane2");
	wait(1.1);
	
	earthquake(1, 1, level.player.origin, 256);
	level waittill("Bond_Jump_to_Crane2");
	
	level.player PlaySound("crane_breath_two");
	level.player freezeControls(false);
	destination = GetEnt("crane1_end","targetname");
	level.player SetOrigin(destination.origin);
	level.player SetPlayerAngles((-0, 216, 0));

	
	GetEnt("crane_jump_player_clip", "targetname");
	level notify("fx_birds_takeoff2");
}

crane_arm_2_camera()
{
	trigger = GetEnt("trigger_crane_2_camera","targetname");
	trigger jump_trigger();
	trigger delete();

	level notify("checkpoint_reached");

	
	level notify("playmusicpackage_roof");
	
	
	level.player PlaySound("crane_roof_jump");
	endcutscene("Bomber_Chase_5");

	
	level.player freezeControls(true);

	Playcutscene("bnd_jump_roof","Bond_Jump_Roof_Done");
	playcutscene("Bomber_Chase_5B","Bomber_Chase_5B_Done");
	
	wait (2.75);	

	level notify("fx_roofdent_dust");
	earthquake(1, 1, level.player.origin, 256);
	

	roof = GetEnt("metal_undented","targetname");
	roof hide();
	dented_roof = GetEnt("metal_dented","targetname");
	dented_roof show();
	level waittill("Bond_Jump_Roof_Done");
	SetDVar("sm_SunSampleSizeNear", 0.5);

	
	level.player PlaySound("crane_breath_three");
	level.player freezeControls(false);
	destination = GetEnt("crane2_end","targetname");
	level.player SetOrigin(destination.origin);
	level.player SetPlayerAngles((destination.angles));
	

	
	cage = GetEnt("scissorlift_cage","targetname");
	cage MoveZ(152,0.5);

	
	maps\_autosave::autosave_now("construction");
	level thread create_time_limit(level.timer_set);
}

crane_up()
{
	
	trigger = GetEnt("trigger_climb_camera","targetname");
	trigger jump_trigger();
	trigger delete();

	SetDVar("sm_SunSampleSizeNear", 1.5);
	
	
	level thread ambience_move_boats();
	level notify("checkpoint_reached");
	
	level.player PlaySound("jump_to_pipes");
	
	level notify("playmusicpackage_crane1");
	
	
	playcutscene("Bond_Jump_to_Pipes","Bond_Jump_to_Pipes_Done");
	level waittill("Bond_Jump_to_Pipes_Done");
	rail = spawn("script_origin",level.player.origin);
	
	
	
	
	level.player PlayerLinkToAbsolute(rail);
	
	
	SetSavedDVar("Bal_wobble_accel", 1.025);
	SetSavedDVar("Bal_wobble_decel", 1.05);

	collision = GetEnt("crane_collision","targetname");
	collision delete();
		
	trigger = GetEnt("trigger_detach_pipes","targetname");
	trigger sethintstring(&"CONSTRUCTIONSITE_DETACH_PIPE");	
	trigger waittill("trigger");
	trigger delete();

	level notify("checkpoint_reached");
	
	
	level.player unlink();
	
	
	level.player PlaySound("rappel_up_crane");
	level.player freezeControls(true);
	rail = spawn("script_origin",level.player.origin);
	level.player linkto( rail );
	rail rotatepitch(70, 1);
    wait(1);

	
	buckle = GetEnt("crane_buckle_script","targetname");
	buckle linkto( rail);	
	physicsExplosionCylinder(buckle.origin, 300.0, 200.0, 1.0);
	level notify("pipe_drop_02_start");
	destination = GetEnt("crane_end","targetname");
	rail moveto(destination.origin,5);	
	wait(3.7);
    buckle unlink();

    
	rail rotatepitch(-70, 1);
	wait(0.5);
	level.player unlink();
	level thread create_time_limit(level.timer_set);
	
	level.player PlaySound("climb_high_crane");
	playcutscene("BondClimbPipesTop","Bond_Climb_Pipes_Top_Done");
	level notify("fx_birds_takeoff1");

	
	level waittill("Bond_Climb_Pipes_Top_Done");
    level.player freezeControls(false);
	level.player SetPlayerAngles((0, 280, 0));
	level.player PlaySound("crane_breath_one");
	
	maps\_autosave::autosave_now("construction");

	
	endcutscene("Bomber_Chase_4");
	bomber_5();
}

bomber_5()
{
	playcutscene("Bomber_Chase_5","Bomber_Chase_5_Done");
	level thread bomber_ride_elevator();

	
	SetSavedDVar("bal_move_speed", 100.0);
	level waittill("Bomber_Chase_5_Done");
	set_default_main();
}

drywall_break()
{
	
	worker = GetEnt("worker","targetname");
	worker gun_remove();
	worker attach( "p_msc_wrench", "TAG_WEAPON_RIGHT" );

	
	trigger = GetEnt("trigger_drywall","targetname");
	trigger waittill("trigger");
	level notify("ibeam_wire_loose_start");
	
	
	level thread ambience_girders();
	
	
	level notify("checkpoint_reached");
	SetDVar("cg_pipstatic_opacity", "0"); 

	
	SetSavedDVar("timescale","0.75");
	
	level.player Playsound("igc_bomber_fight");
	endcutscene("Bomber_Chase_3");
	playcutscene("Bomber_Chase_4","Bomber_Chase_4_Done");
	
	
	
	level notify("propane_fall_start");
	trigger = getent("drywall_cam", "targetname");
	trigger waittill("trigger");
		
	level notify("propane_explode_now");
	VisionSetNaked("constructionsite_0_B", 0.05);
	
	setExpFog( 1536.26, 2548.21, 0.406, 0.476, 0.554, 0, 0.829);

	playcutscene("Bond_Drywall","Bond_Drywall_Done");
	level notify("drywall_break_start");
	level notify("fx_drywall_dust");
	
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
	
	
	level.player PlaySound("acetylene_explode");
	
	level notify ("endmusicpackage");

	
	wait(.25);

	
	exp_origin = GetEnt("welding_explosion_origin","targetname");
	earthquake(0.6, 1, level.player.origin, 256);
	girder_1 = GetEnt("girderA_script","targetname");
	girder_2 = GetEnt("girderB_script","targetname");
	
	
	wait (0.7);
	earthquake(0.4, 1.8, level.player.origin, 256);
	wait (0.8);
	
	
	
	
	
	
	destroyed_plank_array = GetEntArray("walkway_planks","targetname");
	
	for(i = 0; i < destroyed_plank_array.size; i++)
	{
		destroyed_plank_array[i] hide();
	}
	
	
	
	level.player PlaySound("fall_through_boards");
	level.player unlink();
	worker = spawn_civilian(GetEnt("spawner_falling_worker_2","targetname"));
	worker dodamage(worker.health + 200, worker.origin);
	
	
	level.player freezeControls(true);

	playcutscene("Bond_FloorFall","Bond_FloorFall_Done");

	
	
	
	
	wait (1.0);
	level notify ("playmusicpackage_floorfall");
	level notify("ibeam_wire_tight_start");
	level waittill("Bond_FloorFall_Done");

	
	destination = GetEnt("origin_player_after_explosion","targetname");
	level.player SetOrigin(destination.origin);
	level.player SetPlayerAngles((destination.angles));
	level.player freezecontrols(false);
	maps\_autosave::autosave_now("construction");
	
	ambience_girders_animate();
	level thread create_time_limit(level.timer_set);
	level.bomber thread bomber_create_impulse();

	
	wait(15);
	wait(8);

	
	
	level thread set_default_main();
	
	level waittill("Bomber_Chase_4_Done");
}

elevator_crash()
{
	GetEnt("trigger_elevator_crash", "targetname") waittill("trigger");
	elevator = GetEntArray("elevator_platform_script","targetname");
	spark_origin_left = GetEnt("elevator_spark_left","targetname");
	spark_origin_right = GetEnt("elevator_spark_right","targetname");
	spark_origin_left linkto(elevator[0]);
	spark_origin_right linkto(elevator[0]);

	
	elevator[0] PlaySound("construction_elevator_fall");
	level thread elevator_sparks();
	dynEnt_StartPhysics("elevator_props");

	for(i = 0; i < elevator.size; i++)
	{
		elevator[i] MoveZ(-420,3,3);
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
}

awareness_girder_door(awareness_object)
{
	GetEnt("trigger_girder_door", "targetname") waittill("trigger");
	level notify("fence_door_start");

	collision = GetEnt("gate_bash_collision","targetname");
	
	door_bash_org_var = GetEnt("door_bash_org","targetname");
	door_bash_org_var PlaySound("door_bash");
	Earthquake(1, .2, collision.origin, 256);
	collision delete();
}

awareness_scissor_lift(awareness_object)
{
	cage = GetEnt("scissorlift_cage","targetname");
	
	setExpFog( 0, 2195, 0.587434, 0.570319, 0.529037, 0, 0.676873);

	
	level notify("van_start");
	level.player play_dialogue_nowait("TANN_ConsG_200A", true);
	level.radio_warning = false;
	
	cameraID_lift = level.player customCamera_Push("world", (1455.0, -2803.0, 599.0), (80.0, 90.0, 0.0), 0.5);
	level notify("checkpoint_reached");
	level.player freezecontrols(true);
	level.sticky_origin = Spawn("script_origin", level.player.origin);
	
	level.sticky_origin.angles = level.player.angles;
	level.player PlayerLinkToAbsolute(level.sticky_origin);
	level.last_sprint = true;
	
	
	level.player PlaySound("scissor_drop");
	level.sticky_origin linkto(cage);

	cage_collision = GetEntArray("scissorlift_cage_collision","targetname");
	for(i = 0; i < cage_collision.size; i++)
	{
		cage_collision[i] linkto(cage);
	}
	
	
	lift_down = GetEnt("scissorlift_down","targetname");
	
	lift_down show();
	
	
	cage MoveZ(-330,1.5);
	cage MoveZ(-330,1.5);
	
	cage waittill("movedone");
	level notify("fx_scissorlift_impact");
	earthquake(0.8, 1, level.player.origin, 256);
	
	VisionSetNaked( "constructionsite_0");	

	
	
	
	
	
	

	maps\_utility::unholster_weapons();
	level.player disableweapons();

	
	level.player Unlink();
	level.sticky_origin delete();
	level.sitcky_origin = undefined;
	level.player freezecontrols(false);
	level.player customCamera_pop( cameraID_lift, 0.0);

	
	level.player PlaySound("jump_from_scissor");
	
	level.player freezeControls(true);
	playcutscene("bnd_scissorlift","Bond_Scissorlift_Done");

	
	level waittill("Bond_Scissorlift_Done");
	earthquake(0.8, 1, level.player.origin, 256);
	
	
	location = GetEnt("origin_bond_van_chase","targetname");

	level.player SetOrigin(location.origin);
	level.player freezeControls(false);

	
	level.player play_dialogue("TANN_ConsG_087A", true);
	level thread create_time_limit(8);
}

bomber_catch_breath()
{
	level waittill("Bomber_Chase_2_Done");
	SetDVar("r_pipSecondaryMode", 0);
	flag_wait("bomber_climb");
	playcutscene("Bomber_Chase_2B","Bomber_Chase_2B_Done");
	wait 2;

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
			level thread set_default_main();
		}
	}
	
	level notify("spawn_inside_workers");
	endcutscene("Bomber_Chase_2B");
	playcutscene("Bomber_Chase_3","Bomber_Chase_3_Done");

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
	level thread set_default_main();
	elevator = GetEnt("elevator_platformb_script","targetname");
	level.bomber linkto(elevator);
	wait(.05);
	level.bomber CmdPlayAnim("Bomber_Elevator_Cycle");

	trigger = GetEnt("objective_update_3","targetname");
	trigger waittill("trigger");

	
	lift_down = GetEnt("scissorlift_down","targetname");
	lift_cage = GetEnt("scissorlift_cage","targetname");
	lift_down show();
	lift_cage show();

	
	objective_add(5, "active",&"CONSTRUCTIONSITE_FIND_ANOTHER_WAY");
	
	
	elevator PlaySound("cage_elevator_down");
	elevator moveZ(-400,5);
	elevator waittill("movedone");
	
	level.bomber unlink();
	level.bomber notify("stop_animating_elevator");
	endcutscene("Bomber_Chase_5B");
	playcutscene("Bomber_Chase_6","Bomber_Chase_6_Done");
	level waittill("Bomber_Chase_6_Done");
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


ambience_run_from_digger()
{
	wait(3);
	wait(5);
	worker_4 = GetEnt("digger_rail_worker_4","script_noteworthy");
	worker_4 SetScriptSpeed("Run");
	goal_4 = GetNode("digger_rail_goal_4","targetname");
	worker_4 SetGoalNode(goal_4);

	worker_5 = GetEnt("digger_rail_worker_5","script_noteworthy");
	worker_5 SetScriptSpeed("Run");
	goal_5 = GetNode("digger_rail_goal_5","targetname");
	worker_5 SetGoalNode(goal_5);

	worker_6 = GetEnt("digger_rail_worker_6","script_noteworthy");
	worker_6 SetScriptSpeed("Run");
	goal_6 = GetNode("digger_rail_goal_6","targetname");
	worker_6 SetGoalNode(goal_6);

	level waittill("digger_crash_finished");
	clear_civilians("digger_rail_worker");
}


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

	
	GetEnt("cleanup_before_crane1", "targetname") waittill("trigger");

	
	clear_civilians("detour_area");
}


ambience_other_floors()
{
	workers = [];

	
	worker_spawner = GetEntArray("spawner_sublevel_worker","targetname");
	for(i = 0; i < worker_spawner.size; i++)
	{
		
		workers[i] = spawn_civilian(worker_spawner[i]);
		workers[i].targetname = "civilians_sublevel";
	}

	
	level waittill("clear_civilians_1");

	
	clear_civilians("civilians_sublevel");
}

ambience_inside_building_animate_1()
{
	flag_wait("trigger_jump_table");

	
	worker_walk = GetEnt("worker_walk_stairs","script_noteworthy");
	worker_walk gun_remove();
	worker_dest = GetNode("stair_well_goal","targetname");
	worker_walk SetGoalNode(worker_dest);
}

ambience_inside_building_animate_2()
{
	
	worker_saw = GetEnt("worker_saw","script_noteworthy");
	worker_saw gun_remove();
	worker_saw thread civilian_action_anim("Gen_Civs_TableToolOperate");

	
	level thread saw_sparks();

	
	worker_blueprint = GetEnt("worker_blueprint","script_noteworthy");
	worker_blueprint gun_remove();;
	worker_blueprint thread civilian_action_anim("Gen_Civs_BluePrintExamine");

	wait(2);
}


ambience_inside_building()
{
	GetEnt("cleanup_before_crane1", "targetname") waittill("trigger");
	wait (1);

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


ambience_ground_falling_pipes()
{
	trigger = GetEnt("objective_update_2","targetname");
	trigger waittill("trigger");
	workers = [];

	for(i = 1; i < 3; i++)
	{
		workers[i] = spawn_civilian( GetEnt("spawner_pipe_watcher_"+i,"targetname") );
		wait(0.05);
	}

	trigger = GetEnt("trigger_detach_pipes","targetname");
	trigger waittill("trigger");

	for(i = 1; i < 3; i++)
	{
		workers[i].targetname = "civilians_falling_pipes";
		workers[i] SetScriptSpeed("Run");
		workers[i] SetGoalNode( GetNode("pipe_goal_"+i,"targetname") );
		wait(0.05);
	}

	wait(1.7);

	
	level notify("fx_acetylene_exp2");

	
	level waittill("clear_civilians_2");

	
	clear_civilians("civilians_falling_pipes");
}


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
iprintlnbold("AMBIENCE_SCISSOR_LIFT_AREA IS NEVER CALLED !!!   NOT !");
	trigger = GetEnt("objective_update_2","targetname");
	trigger waittill("trigger");

	worker_spawner = GetEntArray("spawner_scissor_worker","targetname");
	for(i = 0; i < worker_spawner.size; i++)
	{
		
		workers[i] = spawn_civilian(worker_spawner[i]);
		workers[i].targetname = "civilians_scissor";
	}
}



ambience_girders_animate()
{
	
	worker_warn = GetEnt("girder_warn","targetname");
	worker_warn thread civilian_action_anim("Gen_Civs_ConstructWorkerYellV1");
	wait(5);
}

ambience_girders()
{
	
	worker_spawner = GetEntArray("spawner_worker_girder","targetname");
	for(i = 0; i < worker_spawner.size; i++)
	{
		worker = spawn_civilian(worker_spawner[i]);
		worker.targetname = worker_spawner[i].script_noteworthy;
	}
	
	wait(6);
	ambience_girders_animate();
	
	
	level waittill("clear_civilians_2");
	
	clear_civilians("girders_worker");
}

ambience_move_boats()
{
	speed_boat_1 = GetEnt("speedboat01","targetname");
	speed_boat_1 moveto(GetEnt("speedboat01_origin","targetname").origin, 50);

	sail_boat_1 = GetEnt("sailboat01","targetname");
	sail_boat_1 moveto(GetEnt("sailboat01_origin","targetname").origin, 50);
	sail_boat_2 = GetEnt("sailboat02","targetname");
	sail_boat_2 moveto(GetEnt("sailboat02_origin","targetname").origin, 50);
}



#using_animtree("generic_human");
setup_car_driver()
{
	driver = Spawn( "script_model", self GetTagOrigin( "tag_driver" ) );
	driver.angles = self.angles;
	driver character\character_tourist_1::main();
	driver LinkTo( self, "tag_driver" );
	
	
	driver useAnimTree(#animtree);
	driver setFlaggedAnimKnobRestart("idle", %vehicle_driver);
	
	
	self waittill("reached_end_node");
	driver delete();
}	
