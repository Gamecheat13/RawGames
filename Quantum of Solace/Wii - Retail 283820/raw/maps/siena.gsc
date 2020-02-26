#include maps\_utility;
#include maps\siena_util;

main()
{
	
	maps\siena_fx::main();

	
	level._effect["fxtunnel"] = Loadfx("explosions/grenadeExp_dirt_1");
	level._effect["dust_column"] = Loadfx("maps/siena/siena_hall_dust");
	level._effect["dust_door"] = Loadfx("maps/siena/siena_falling_debris1");
	level._effect["dust_storm"] = Loadfx("explosions/grenadeExp_concrete");
	level._effect["box_spark"] = Loadfx("props/electric_box");
	level._effect["muzzle_flash"] = Loadfx("weapons/p99_discharge");
	level._effect["impact_igc"] = Loadfx("impacts/small_concrete_1");
	level._effect["bomb_glow"] = Loadfx("maps/OperaHouse/opera_buoy_light");

	
	precachecutscene("Siena_M_Talking_to_Camera");
	precachecutscene("Siena_SC01_Intro");
	PrecacheCutScene("Siena_SC01b_Intro");
	PrecacheCutScene("Siena_SC01_A_Drop");
	PrecacheCutScene("Siena_SC02_A_Drop");
	PrecacheCutScene("Siena_SC02_Gate1");
	PrecacheCutScene("Siena_SC03_Gate2");
	PrecacheCutScene("Siena_SC04_Gate3");

	precacheitem("concussion_grenade");
	timer_init();

	setup_data_collection();

	
	if( Getdvar( "artist" ) == "1" )
	{
		maps\_load::main();
		return;
	}	

	maps\_load::main();

	
	precacheShader( "compass_map_siena" );
	setminimap( "compass_map_siena", 2304, 1960, -11152, -7136 );
	
	
	thread maps\siena_snd::main();
	thread maps\siena_mus::main();
	
	thread setup_vision();
	thread setup_bond();
	thread setup_objectives();
	thread setup_misc();
	thread setup_skipto();

	thread enemy_door();
	thread enemy_door_2();
	thread handicap_trap();
	thread grenade_tutorial();
	
}


setup_pip()
{
	wait(.1);
	SetDVar("r_pipSecondaryX", 0.05);
	SetDVar("r_pipSecondaryY", 0.05);						
	SetDVar("r_pipSecondaryAnchor", 0);						
	SetDVar("r_pipSecondaryScale", "0.5 0.5 1.0 1.0");		
	SetDVar("r_pipSecondaryAspect", false);					
	SetDVar("r_pipSecondaryMode", 5);

	level.player setsecuritycameraparams( 55, 3/4 );

	wait(.1);
	level.player SecurityCustomCamera_Push("world", (0, 0, 0), (0, 0, 0), 0.0);
}


setup_vision()
{
	
	Visionsetnaked("siena_cistern");	
}


setup_objectives()
{
	level.strings["objective_1_head"] = &"SIENA_OBJECTIVE_1_HEAD";
	level.strings["objective_1_desc"] = &"SIENA_OBJECTIVE_1_DESC";
	level.strings["objective_2_head"] = &"SIENA_OBJECTIVE_2_HEAD";
	level.strings["objective_2_desc"] = &"SIENA_OBJECTIVE_2_DESC";
	level.strings["objective_2_1_head"] = &"SIENA_OBJECTIVE_2_1_HEAD";
	level.strings["objective_2_1_desc"] = &"SIENA_OBJECTIVE_2_1_DESC";
	level.strings["objective_3_head"] = &"SIENA_OBJECTIVE_3_HEAD";
	level.strings["objective_3_desc"] = &"SIENA_OBJECTIVE_3_DESC";
	level.strings["objective_4_head"] = &"SIENA_OBJECTIVE_4_HEAD";
	level.strings["objective_4_desc"] = &"SIENA_OBJECTIVE_4_DESC";
	level.strings["objective_5_head"] = &"SIENA_OBJECTIVE_5_HEAD";
	level.strings["objective_5_desc"] = &"SIENA_OBJECTIVE_5_DESC";
	level.strings["objective_6_head"] = &"SIENA_OBJECTIVE_6_HEAD";
	level.strings["objective_6_desc"] = &"SIENA_OBJECTIVE_6_DESC";
	level.strings["objective_7_head"] = &"SIENA_OBJECTIVE_7_HEAD";
	level.strings["objective_7_desc"] = &"SIENA_OBJECTIVE_7_DESC";
	level.strings["objective_8_head"] = &"SIENA_OBJECTIVE_8_HEAD";
	level.strings["objective_8_desc"] = &"SIENA_OBJECTIVE_8_DESC";
	level.strings["objective_9_head"] = &"SIENA_OBJECTIVE_9_HEAD";
	level.strings["objective_9_desc"] = &"SIENA_OBJECTIVE_9_DESC";
}


setup_data_collection()
{
	
	
	level.strings["siena_phone_name_0"] = &"SIENA_DATA_TITLE_5";
	level.strings["siena_phone_body_0"] = &"SIENA_DATA_BODY_5";

	
	
	level.strings["siena_phone_name_1"] = &"SIENA_DATA_TITLE_2";
	level.strings["siena_phone_body_1"] = &"SIENA_DATA_BODY_2";

	
	
	level.strings["siena_phone_name_2"] = &"SIENA_DATA_TITLE_3";
	level.strings["siena_phone_body_2"] = &"SIENA_DATA_BODY_3";

	
	
	level.strings["siena_phone_name_3"] = &"SIENA_DATA_TITLE_4";
	level.strings["siena_phone_body_3"] = &"SIENA_DATA_BODY_4";
}


setup_bond()
{
	
	maps\_phone::setup_phone();

	setWaterSplashFX("maps/siena/siena_water_splash");
	setWaterFootSplashFX("maps/siena/siena_water_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading_idle"); 
	setWaterWadeFX("maps/siena/siena_water_wading"); 
}


setup_skipto()
{
	switch( getdvar( "skipto") )
	{

	case "m":
	case "M":
		wait(0.05);
		level.player freezecontrols(true);
		playcutscene("Siena_M_Talking_to_Camera","m_over");
		level waittill("m_over");
		level thread event_1_aftermath();
		break;

	
	case "cisterns":
	case "Cisterns":
		
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("cistern_start","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		clear_enemies();

		level thread event_1_to_2_tunnel_gravity();
		level thread event_2_cistern_battle();
		break;

	
	case "collapse":
	case "Collapse":
		
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("collapse_start","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		clear_enemies();

		level thread event_2_to_3();
		break;

	
	default:
		level thread event_1_aftermath();
		break;
	}
}

setup_fog()
{
	
	setExpFog(0, 1121.62, 0.3475, 0.421875, 0.421875, 0);

	trigger = GetEnt("trigger_event_2","targetname");
	trigger waittill("trigger");

	
	setExpFog(474.44, 449.872, 0.398438, 0.398438, 0.40625, 3, 0.448603);
	Visionsetnaked("siena_cistern_room");	

	trigger = GetEnt("trigger_shake_1","targetname");
	trigger waittill("trigger");

	
	setExpFog(0, 1121.62, 0.3475, 0.421875, 0.421875, 3);
	Visionsetnaked("siena_cistern");	
}


setup_misc()
{
	
	level.enemy_count = 0;

	SetSavedDVar("ai_teamGrenadeInterval",60);

	
	

	
	

	
	

	
	support = GetEnt("support_2_fall","targetname");
	support trigger_off();
	support ConnectPaths();

	
	bent_s = GetEnt("cistern_scaf_02","targetname");
	bent_s hide();

	
	decal_1 = GetEnt("blast_decal01","targetname");
	decal_1 hide();
	decal_2 = GetEnt("blast_decal02","targetname");
	decal_2 hide();

	
	
	
	
	
	wall = GetEnt("collapse_geo_collision","targetname");
	wall trigger_off();
	wall ConnectPaths();
}


level_end()
{
	Objective_State(4, "done");
	
		
	level notify("endmusicpackage");

	maps\_endmission::nextmission();
}


event_1_aftermath()
{
	wait(0.05);
	mitchell = GetEnt("mitchell","targetname");
	level.player freezecontrols(true);

	playcutscene("Siena_SC01_Intro","intro_over");

	level thread display_chyron();

	level thread event_1_laptop_light();
	
	
	level.player playsound("intro_igc");
	
	
	level.player playsound("bond_stinger_01_siena");

	letterbox_on(false, false);

	wait(11);
	
	

	level.player playerSetForceCover(true);

	bullet_dest[0] = GetEnt("bullet_1","targetname");
	bullet_dest[1] = GetEnt("bullet_2","targetname");
	bullet_dest[2] = GetEnt("bullet_3","targetname");
	bullet_orig = GetEnt("bullet_org","targetname");
	
	for(i = 0; i < 3; i++)
	{	
		mitchell waittillmatch("anim_notetrack","gun shot");
		org = bullet_orig.origin;
		vFwd = AnglesToForward(bullet_orig.angles);
		vUp = anglestoup(bullet_orig.angles);
		endof = bullet_dest[i].origin;

		Playfx(level._effect["muzzle_flash"],org,vFwd,vUp);
		
		
		
		
		
		endpos = physicstrace(org, endof);
		Playfx(level._effect["impact_igc"],endpos,vFwd,vUp);
		
	}

	
	
	level notify("playmusicpackage_start");

	wait(0.4);
	

	letterbox_off();

	level waittill("intro_over");

	level notify("laptop_off");
	laptop = GetEnt("lit_laptop","targetname");
	laptop thread light_flicker(false,0);

	playcutscene("Siena_SC01b_Intro","intro_b_over");
	
	level.player freezecontrols(false);

	
	level.player playerSetForceCover(false,false);
	
	Objective_Add( 1, "active", level.strings["objective_1_head"], (-3050,-21,-60), level.strings["objective_1_desc"]);
	

	level thread event_1_to_2();

	
	
	level waittill("intro_b_over");

	
	
	mitchell delete();

	wait(1);

	level thread event_1_first_quake();
	level thread event_1_door_move();
	
	level notify("rock_fall_2_start");
	
	trigger = GetEnt("safehouse_trigger_1","targetname");
	trigger waittill("trigger");
	trigger delete();

	level thread voice_tanner_00();

	trigger = GetEnt("safehouse_trigger_2","targetname");
	trigger waittill("trigger");
	trigger delete();

	level notify("stop_quake_1");
	
	level notify("stop_repeating");
	level thread event_1_second_quake();

	trigger = GetEnt("safehouse_trigger_3","targetname");
	trigger waittill("trigger");
	trigger delete();

	
	

	
	
	
	
	
	
	
	
	
	
	Earthquake(0.2, 4, level.player.origin, 850);

	

}

event_1_laptop_light()
{
	self endon("laptop_off");

	laptop = GetEnt("lit_laptop","targetname");

	while(1)
	{
		laptop thread light_flicker(false,1);
		wait(1);
		laptop thread light_flicker(true,0.7,1);
		wait(.25);
	}

}

event_1_first_quake()
{
	self endon("stop_quake_1");
	

	explosion = GetEnt("well_explosion","targetname");
	vFwd = AnglesToForward(explosion.angles);
	vUp = anglestoup(explosion.angles);

	Playfx(level._effect["fxtunnel"], explosion.origin, vFwd, vUp);
	
	
	explosion playsound("cistern_expl_01");
	level.player playloopsound("cistern_rumble", 0.5);

	quake = GetEnt("safehouse_earthquake","targetname");
	
	Earthquake(0.2, 4, quake.origin, 850);
	
	dust_origin = GetEntArray("safehouse_dust","targetname");
	for(j = 0; j < dust_origin.size; j++)
	{
		vFwd = anglestoforward(dust_origin[j].angles);
		vUp  = anglestoup(dust_origin[j].angles);
		Playfx(level._effect["dust_column"], dust_origin[j].origin, vFwd, vUp);
	}
	storm = GetEntArray("safehouse_middle_exp","targetname");
	for(i = 0; i < storm.size; i++)
	{
		wait(.2);
		vFwd = anglestoforward(storm[i].angles);
		vUp  = anglestoup(storm[i].angles);
		Playfx(level._effect["dust_storm"], storm[i].origin, vFwd, vUp);
	}
	PhysicsExplosionSphere(quake.origin, 100, 80, 5);
	
	table_tab = GetEnt("table_safehouse","targetname");
	table_org = GetEnt("table_turn","targetname");
	table_tab linkto(table_org);
	table_col = GetEnt("table_safehouse_col","targetname");
	table_col linkto(table_org); 
	table_org rotatepitch(-85,.5);
	
	
	
	
	
	
	level thread event_1_repeating_quake();
}

event_1_repeating_quake()
{
	self endon("stop_repeating");
	while(1)
	{
		wait(8);
	
		
		quake = GetEnt("safehouse_earthquake","targetname");
		
		Earthquake(0.2, 4, quake.origin, 850);
		
		dust_origin = GetEntArray("safehouse_dust","targetname");
		for(j = 0; j < dust_origin.size; j++)
		{
			vFwd = anglestoforward(dust_origin[j].angles);
			vUp  = anglestoup(dust_origin[j].angles);
			Playfx(level._effect["dust_column"], dust_origin[j].origin, vFwd, vUp);
		}
		for(i = 0; i < 4; i+=0.05)
		{
			PhysicsJolt(quake.origin,200,150, (0.02, 0.02, 0.01) );
			
			wait(0.05);
		}
		
	}
}

event_1_second_quake()
{
	
		
	level notify("rock_fall_1_start");
	
	level.player playsound("cistern_shake_lf_02");

	panel = GetEnt("safehouse_sparks","targetname");
	vFwd = anglestoforward(panel.angles);
	vUp = anglestoup(panel.angles);
	Playfx(level._effect["siena_lamp_sparks"], panel.origin, vFwd, vUp);
	
	quake_2 = GetEnt("safehouse_earthquake_2","targetname");
	Earthquake(0.3, 2, quake_2.origin, 850);
	
	dust_origin = GetEntArray("safehouse_door_dust","targetname");
	for(j = 0; j < dust_origin.size; j++)
	{
		vFwd = anglestoforward(dust_origin[j].angles);
		vUp  = anglestoup(dust_origin[j].angles);
		Playfx(level._effect["dust_column"], dust_origin[j].origin, vFwd, vUp);
	}
	for(i = 0; i < 4; i+=0.05)
	{

		PhysicsJolt(quake_2.origin,200,150, (-0.12, -0.12, 0.12) );
		wait(0.05);
	}


}

event_1_door_move()
{
	self endon("stop_door_move");

	door = GetEnt("gate_safehouse","targetname");
	direction = true;
	max_angle = 90;
	min_angle = -90;
	duration = 1;

	while(min_angle < 0)
	{
		if(direction == true)
		{
			door rotateyaw(min_angle,duration, (duration/3), (duration/3));
			
			
			door playsound("gate_swing_b");
			
			door waittill("rotatedone");
			direction = false;
			if(min_angle < -10)
			{
				min_angle += 20;
				duration += .1;
			}
		}
		else
		{
			door rotateyaw(max_angle,duration, (duration/3), (duration/3));
			
			
			door playsound("gate_swing_b");
			
			door waittill("rotatedone");
			direction = true;	
			if(max_angle > 10)
			{
				max_angle -= 20;
				duration += .1;
			}
		}
	}
}


event_1_to_2()
{
	
	wait(0.3);
	
	

	
	
	trigger = GetEnt("trigger_trash_1","targetname");
	trigger waittill("trigger");
		
	mitchell = spawn_mitchell("event_1_mitchell_a");
	
	vFwd = anglestoforward(level.player.angles);
	PlayFx( level._effect["siena_bond_splash"], (level.player.origin+(vFwd*30)) );  
	level.player freezecontrols(true);
	playcutscene("Siena_SC01_A_Drop","drop_over");
	
	
	level thread random_earthquakes();

	level notify("stop_door_move");

	
	level.player playsound("land_plr_water_loud");

	level.player thread physics_sphere();

	
	dynEnt_StartPhysics("stream_1_trash");
	gravity = GetEnt("well_gravity_end","targetname");
	g_well = anglestoforward(gravity.angles);
	phys_changeDefaultGravityDir(VectorNormalize(g_well));

	wait(1.5);
	mitchell_goal = GetNode("event_1_mitchell_a_goal","targetname");
	mitchell SetScriptSpeed("Default");
	mitchell SetGoalNode(mitchell_goal);
	mitchell thread kill_on_goal();

	level waittill("drop_over");
	level.player freezecontrols(false);
	Earthquake(0.3, 2, level.player.origin, 850);

	level thread voice_tanner_01();

	
	trigger = GetEnt("trigger_tunnel_01_quake","targetname");
	trigger waittill("trigger");
	Earthquake(0.3, 4, level.player.origin, 850);
	dust_origin = GetEntArray("tunnel_01_dust","targetname");
	for(j = 0; j < dust_origin.size; j++)
	{
		vFwd = anglestoforward(dust_origin[j].angles);
		vUp  = anglestoup(dust_origin[j].angles);
		Playfx(level._effect["dust_door"], dust_origin[j].origin, vFwd, vUp);
	}

	
	mitchell = spawn_mitchell("event_1_mitchell");
	
	reset_gravity();
	dynEnt_StartPhysics("tunnel_trash");
	level thread event_1_to_2_tunnel_gravity();

	level thread event_1_to_2_magic_bullet();
	trigger = GetEnt("trigger_event_1","targetname");
	trigger waittill("trigger");
	trigger delete();

	level notify("stop_earthquakes");

	
	mitchell_goal = GetNode("event_1_goal_2","targetname");
	mitchell SetGoalNode(mitchell_goal);
	mitchell thread kill_on_goal();

	
	trigger = GetEnt("trigger_tunnel_ambush","targetname");
	trigger waittill("trigger");

	wait(.5);
	ambusher = spawn_enemy("ambusher");
	ambusher thread sight_beyond_sight(-1);
	ambusher LockAlertState("alert_red");
	ambusher SetCombatRole("elite");
	ambusher cmdmeleeentity(level.player);

	level thread random_earthquakes();
	
	trigger = GetEnt("going_dark","targetname");
	trigger waittill("trigger");
	trigger delete();
	
	mitchell = spawn_mitchell("event_1_to_2_mitchell");
	mitchell thread event_1_to_2_mitchell_gate();
	
	
	
	
	
	

	trigger = GetEnt("trigger_event_1_to_2","targetname");
	trigger waittill("trigger");
	
	trigger = GetEnt("look_at_dust_fall","targetname");
	trigger notify("trigger");

	level.player notify("stop_sphere");
	level notify("stop_earthquakes");
	level notify("stop_gravity");
	reset_gravity();

	vFwd = anglestoforward(level.player.angles);
	PlayFx( level._effect["siena_crate_smash"], (level.player.origin+(vFwd*30)) );  
	
	level.player freezecontrols(true);
	playcutscene("Siena_SC02_A_Drop","end_drop_2");
	

	
	level.player playsound("land_on_crate");
	level.player stoploopsound(0.8);

	wait(0.75);
	Earthquake(1, .2, level.player.origin, 850);
	level.player radiusdamage(level.player.origin, 100, 500, 500);
	
	setSavedDvar( "sf_compassmaplevel",  "level2" );

	level waittill("end_drop_2");
	level.player freezecontrols(false);

	level thread event_2_cistern_battle();

	
	update_dvar_scheme();
	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message("SIENA_WII_TUTORIAL_CROUCH");
	}
	else
	{
		tutorial_message("SIENA_WII_TUTORIAL_CROUCH_ZAPPER");
	}
	
	wait( 3.0 );
	
	tutorial_message( "" );

	

	
	trigger = GetEnt("look_at_dust_fall","targetname");
	trigger waittill("trigger");

	Earthquake(0.2, 4, level.player.origin, 850);
	dust_origin = GetEntArray("fall_dust_fall","targetname");
	for(j = 0; j < dust_origin.size; j++)
	{
		vFwd = anglestoforward(dust_origin[j].angles);
		vUp  = anglestoup(dust_origin[j].angles);
		Playfx(level._effect["dust_column"], dust_origin[j].origin, vFwd, vUp);
	}
}

event_1_to_2_mitchell_gate()
{
	trigger = GetEnt("look_at_dust_fall","targetname");
	trigger waittill("trigger");

	
	
	level.player playsound("iron_gate_open");
	
	playcutscene("Siena_SC02_Gate1","gate_1_over");
	level waittill("gate_1_over");
	self thread voice_mitchell_01();
	mitchell_goal = GetNode("event_1_to_2_goal","targetname");
	self SetGoalNode(mitchell_goal);
	self thread kill_on_goal();

	trigger = GetEnt("trigger_event_2","targetname");
	trigger waittill("trigger");

	

	

	
	
}

event_1_to_2_magic_bullet()
{
	trigger = GetEnt("magic_bullet","targetname");
	trigger waittill("trigger");
	trigger delete();

	bullet_org = GetEnt("magic_bullet_start","targetname");
	bullet_end = GetEnt("magic_bullet_end3","targetname");
	magicbullet("p99", bullet_org.origin, bullet_end.origin);
	level.player playsound ("whizby");
	wait(.2);
	bullet_end = GetEnt("magic_bullet_end2","targetname");
	magicbullet("p99", bullet_org.origin, bullet_end.origin);
	level.player playsound ("whizby");
	wait(.3);
	bullet_end = GetEnt("magic_bullet_end1","targetname");
	magicbullet("p99", bullet_org.origin, bullet_end.origin);
	level.player playsound ("whizby");
}

event_1_to_2_tunnel_gravity()
{
	self endon("stop_gravity");

	north = GetEnt("tunnel_north","targetname");
	south = GetEnt("tunnel_south","targetname");
	g_north = anglestoforward(north.angles);
	g_south = anglestoforward(south.angles);

	north = true;

	while(1)
	{
		if(north == true)
		{
			wait(randomfloat(1) +4);
			phys_changeDefaultGravityDir(VectorNormalize(g_north));
			north = false;
		}
		else
		{
			wait(randomfloat(1) +4);
			phys_changeDefaultGravityDir(VectorNormalize(g_south));
			north = true;
		}	
	}

}

event_1_to_2_light_flicker(light_name)
{
	self endon("stop_lights");

	light = GetEnt(light_name,"targetname");
	light_bulb = GetEnt(light_name + "_on","targetname");

	if(!IsDefined(light))
	{
		iPrintLnBold(light_name + " Not Found");
		return;
	}

	on = true;

	while(1)
	{
		if(on == true)
		{
			light thread light_flicker(true,.5,1.5);
			wait(randomfloat(1) + 0.5);
			light thread light_flicker(false,0);
			light_bulb hide();

			
			light playsound("light_flicker_2");

			on = false;
		}
		else
		{
			light_bulb show();
			light thread light_flicker(true,.5,1.5);

			
			light playsound("light_flicker_2");

			wait(randomfloat(1) + 0.5);
			light thread light_flicker(false,1.5);
			on = true;
		}	
		wait(randomfloat(1) + 0.5);
	}

}

event_1_to_2_lights_out(light_name)
{
	light = GetEnt(light_name,"targetname");
	light_bulb = GetEnt(light_name+"_on","targetname");
	no_light_bulb = GetEnt(light_name+"_off","targetname");

	light thread light_flicker(true,1.5,2);
	wait(1);
	light thread light_flicker(false,0);
	light_bulb hide();
	no_light_bulb show();
}


event_2_cistern_battle()
{
	gate_c = GetEnt("gate_main01_col","targetname");
	gate = GetEnt("gate_main01","targetname");
	gate linkto(gate_c);

	gate_c movez(100,.05);
	gate_c connectpaths();

	
	
	wait(0.05);
	level thread event_2_tiny_tunnel_flicker("lit_tunnel_03_b");


	
	mitchell = spawn_mitchell("event_2_mitchell");
	door_guard_1 = spawn_enemy("door_guard_1");
	door_guard_2 = spawn_enemy("door_guard_2");
	door_guard_3 = spawn_enemy("door_guard_3");

	trigger = GetEnt("trigger_tiny_tunnel_voice","targetname");
	trigger waittill("trigger");

	level thread voice_mitchell_02();

	
	update_dvar_scheme();
	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message( "SIENA_WII_TUTORIAL_STAND" );
	}
	else
	{
		tutorial_message( "SIENA_WII_TUTORIAL_STAND_ZAPPER" );
	}
	
	wait( 3.0 );
	
	tutorial_message( "" );
	
	trigger = GetEnt("trigger_event_2","targetname");
	trigger waittill("trigger");

	level thread voice_mitchell_03(mitchell,door_guard_1,door_guard_2);

	level.player thread physics_sphere();

	
	level notify("stop_lights");

	level thread event_2_earthquake();
	level thread event_1_to_2_tunnel_gravity();

	Objective_State(1, "done");
	Objective_Add( 2, "active", level.strings["objective_2_head"], (-1074,-378,-196), level.strings["objective_2_desc"]);
	
	thread maps\_autosave::autosave_now("siena");

	mitchell_goal = GetNode("event_2_goal","targetname");
	mitchell SetGoalNode(mitchell_goal);
	mitchell CmdPlayAnim("Siena_SC05_TalkingtoThugs", false, false, 3.5);
	mitchell thread kill_on_goal();

	door_guard_1 thread sight_beyond_sight(20);
	door_guard_1 LockAlertState("alert_red");
	wave_1_1_goal = GetNode("event_2_wave_1_goal_1","targetname");
	door_guard_1 SetGoalNode(wave_1_1_goal,1);
	
	wait(.5);

	door_guard_2 thread sight_beyond_sight(20);
	door_guard_2 LockAlertState("alert_red");
	
	

	door_guard_3 thread sight_beyond_sight(20);
	door_guard_3 LockAlertState("alert_red");
	wave_1_3_goal = GetNode("event_2_wave_1_goal_3","targetname");
	door_guard_3 SetGoalNode(wave_1_3_goal);
	door_guard_3 thread tether_on_goal(128);

	
	level thread event_2_cistern_wave_2();

	
	level thread event_2_trigger_wave_3_1();
	level thread event_2_trigger_wave_3_2();

	level event_2_cistern_wave_3();

	level thread event_2_to_3();
	
	waittill_trigger_or_enemy("cistern_wave_4",1);
	
	level event_2_right_backup();

	e_wait(1);

	level event_2_left_backup();
}

event_2_earthquake()
{
	self endon("stop_earthquakes");

	while(1)
	{
		wait( 20 + randomfloat(10.0) );
		Earthquake( randomfloat(.1)+0.1, randomfloat(2.0)+3.5,level.player.origin,2000);

		
		level.player playsound("random_shake_light_lf");

		level notify ("fx_falling_debris");
	}
}

event_2_cistern_wave_2()
{
	waittill_trigger_or_enemy("cistern_wave_2",1);

	wave_2_gate = GetEntArray("gate_spawn1_a","targetname");
	for(i = 0; i < wave_2_gate.size; i++)
	{
		wave_2_gate[i] rotateyaw(-105,0.6);
	}

	level thread event_2_raise_water();
	level thread event_2_lower_water();

	wave_2_1 = spawn_enemy("cistern_side_spawner");
	wave_2_1 LockAlertState("alert_red");
	wave_2_1 SetCombatRole("guardian");
	wave_2_1_goal = GetNode("event_2_wave_2_goal_1","targetname");
	wave_2_1 SetGoalNode(wave_2_1_goal);
	wait(1);
	wave_2_2 = spawn_enemy("cistern_side_spawner");
	wave_2_2 LockAlertState("alert_red");
	wave_2_2 thread sight_beyond_sight();
	
	wait(1);
	wave_2_3 = spawn_enemy("cistern_side_spawner");
	wave_2_3 LockAlertState("alert_red");
	wave_2_3 SetCombatRole("flanker");
	wait(10);
	wave_2_gate = GetEntArray("gate_spawn1_a","targetname");
	for(i = 0; i < wave_2_gate.size; i++)
	{
		wave_2_gate[i] rotateyaw(105,4);
	}

	while(level.enemy_count > 0)
	{
		wait(.1);
	}

	thread maps\_autosave::autosave_by_name("siena",20);
}

event_2_trigger_wave_3_1()
{
	self endon("wave_3_go");

	trigger = GetEnt("cistern_wave_3","targetname");
	trigger waittill("trigger");

	level notify("wave_3_go");
}

event_2_trigger_wave_3_2()
{
	self endon("wave_3_go");

	trigger = GetEnt("trigger_wave_3_2","targetname");
	trigger waittill("trigger");

	wave_3_3 = spawn_enemy("cistern_side_gate_spawner");
	wave_3_3 LockAlertState("alert_red");
	wave_3_3 SetPerfectSense(true);
	wave_3_3 SetScriptSpeed("Sprint");
	wave_3_3_goal = GetNode("event_2_wave_3_goal_3","targetname");
	wave_3_3 SetGoalNode(wave_3_3_goal,1);
	wave_3_3 thread change_speed_on_goal();
	wave_3_3 thread physics_sphere();

	trigger = GetEnt("look_at_wave_3","targetname");
	trigger waittill("trigger");

	level notify("wave_3_go");
}

event_2_cistern_wave_3()
{
	level waittill("wave_3_go");

	mitchell = GetEnt("mitchell","targetname");
	if(IsDefined(mitchell))
	{
		level.player dodamage(level.player.health + 2000, level.player.origin);
	}
	
	wave_3_3 = spawn_enemy("cistern_gate_spawner");
	wave_3_3 LockAlertState("alert_red");
	wave_3_3 thread sight_beyond_sight();
	
	wave_3_3_goal = GetNode("event_2_wave_3_goal_2","targetname");
	wave_3_3 SetGoalNode(wave_3_3_goal,1);
	wave_3_3 thread event_2_wave_3_role_switch();
	wait(.1);
	wave_3_1 = spawn_enemy("cistern_raised_spawner");
	wave_3_1 LockAlertState("alert_red");
	wave_3_1 thread sight_beyond_sight();
	wave_3_1 SetScriptSpeed("Sprint");
	wave_3_1_goal = GetNode("event_2_wave_3_goal_4","targetname");
	wave_3_1 SetGoalNode(wave_3_1_goal,1);
	wave_3_1 SetCombatRole("guardian");
	wave_3_1 thread change_speed_on_goal();
	wait(.1);
	wave_3_2 = spawn_enemy("cistern_main_spawner");
	wave_3_2 LockAlertState("alert_red");
	wave_3_2 thread sight_beyond_sight();
	wave_3_2 SetScriptSpeed("Sprint");
	wave_3_2_goal = GetNode("event_2_wave_3_goal_1","targetname");
	wave_3_2 SetGoalNode(wave_3_2_goal,1);
	wave_3_2 thread change_speed_on_goal();

	gate_c = GetEnt("gate_main01_col","targetname");
	if(!IsDefined(gate_c))
	{
		return;
	}
	gate_c movez(-100,8);
	
	
	gate_c playsound("gate_lower");
	
	wait(6);
	if(IsDefined(gate_c))
	{
		gate_c disconnectpaths();
	}

	Earthquake(0.2, 4, level.player.origin, 850);
	trap = GetEntArray("mousetrap","targetname");
	
	dynEnt_StartPhysics("generator_boards");
	
	physicsExplosionSphere(trap[0].origin, 50, 50, .5);

	
	Objective_State(2, "done");
	Objective_Add( 3, "active", level.strings["objective_2_1_head"], trap[1].origin, level.strings["objective_2_1_desc"]);
	

}

event_2_wave_3_role_switch()
{
	self endon("death");

	self waittill("goal");
	self SetCombatRole("turret");
}

event_2_right_backup()
{
	
	wait(1.0);
	wave_4_2 = spawn_enemy("cistern_raised_spawner");
	wave_4_2 LockAlertState("alert_red");
	wave_4_2_goal = GetNode("event_2_wave_4_goal_2","targetname");
	wave_4_2 thread sight_beyond_sight(20);
	wave_4_2 SetGoalNode(wave_4_2_goal);
}

event_2_left_backup()
{
	
	if(level.gate_down == true)
	{
		return;
	}

	
	wave_5_1 = spawn_enemy("collapse_main_spawner");
	wave_5_1 LockAlertState("alert_red");
	wave_5_1 thread sight_beyond_sight();
	
	wave_5_1 SetCombatRole("rusher");
	wait(1.0);
	wave_5_2 = spawn_enemy("collapse_main_spawner");
	wave_5_2 LockAlertState("alert_red");
	wave_5_2  thread sight_beyond_sight();

	e_wait(0);
	
	
	b_org = GetEnt("trap_bullet_org","targetname");
	b_end = GetEnt("trap_bullet_end","targetname");
	magicbullet("p99",b_org.origin, b_end.origin);
}

event_2_tiny_tunnel_flicker(light_name)
{
	self endon("stop_lights");

	light = GetEnt(light_name,"targetname");
	light_bulb = GetEnt(light_name + "_on","targetname");

	if(!IsDefined(light))
	{
		iPrintLnBold(light_name + " Not Found");
		return;
	}

	on = true;

	while(1)
	{
		if(on == true)
		{
			light_bulb show();
			light thread light_flicker(true,0,.5);
			
			
			light playsound("light_flicker");
			
			wait(.5);
			light light_flicker(false,1);
			on = false;
		}
		else
		{
			light thread light_flicker(true,0,.5);
			wait(.5);
			light light_flicker(false,0);
			light_bulb hide();
			
			
			light playsound("light_flicker");
			
			on = true;
		}	
		wait(randomfloat(.2)+1);
	}
}

event_2_intro_light_flicker(light_name)
{
	self endon("stop_lights");

	light = GetEnt(light_name,"targetname");
	
	if(!IsDefined(light))
	{
		iPrintLnBold(light_name + " Not Found");
		return;
	}

	on = true;

	while(1)
	{
		if(on == true)
		{
			light thread light_flicker(false,3.5);
			wait(1);			
			on = false;
		}
		else
		{
			light thread light_flicker(true,3,3.5);
			wait(randomfloat(.5)+.5);
			on = true;
		}
	}
}

event_2_raise_water()
{
	crack = GetEnt("sewer_crack_02","targetname");
	crack hide();

	water = GetEntArray("cistern_water","targetname");
	foam = GetEntArray("water_rise_foam","targetname");
	waterfall = [];
	
	for(w = 1; w < 7; w++)
	{
		waterfall[w] = GetEnt("waterfall_"+w,"targetname");
	}

	
	for(f = 0; f < foam.size; f++)
	{
		foam[f] linkto(water[0]);
	}

	level.water_rising = true;
	level.gate_down = false;

	level notify("fx_water_rise");

	Earthquake(0.3, 5, level.player.origin, 850);
	
	
	thread maps\siena_snd::play_flood_rumble();

	wait(5);

	
	level thread event_2_lookat_waterfall();

	
	Earthquake(0.5,1,level.player.origin,2000);
	level notify("fx_water_flow5");
	PhysicsExplosionSphere(waterfall[5].origin, 64, 64, 5);
	
	
	thread maps\siena_snd::play_flood_stream_05();
	
	wait(2);
	Earthquake(0.5,1,level.player.origin,2000);
	level notify("fx_water_flow1");
	PhysicsExplosionSphere(waterfall[1].origin, 64, 64, 5);
	
	
	thread maps\siena_snd::play_flood_stream_01();


	
	
	

	for(i = 0; i < water.size; i++)
	{
		water[i] movez(25,20);
	}
	
	wait(4.3);
	Earthquake(0.5,1,level.player.origin,2000);
	level notify("fx_water_flow4");
	PhysicsExplosionSphere(waterfall[4].origin, 64, 64, 5);
	
	
	thread maps\siena_snd::play_flood_stream_04();
	
	wait(1);
	Earthquake(0.5,1,level.player.origin,2000);
	level notify("fx_water_flow2");
	PhysicsExplosionSphere(waterfall[2].origin, 64, 64, 5);
	
	
	thread maps\siena_snd::play_flood_stream_02();
	
	dynEnt_StartPhysics("cistern_trash");
	for(f = 0; f < foam.size; f++)
	{
		vFwd = anglestoforward(foam[f].angles);
		vUp  = anglestoup(foam[f].angles);
		Playfx(level._effect["siena_water_foam2"], foam[f].origin, vFwd, vUp);
	}
	
	wait(3.2);

	level notify("fx_water_flow3");
	PhysicsExplosionSphere(waterfall[3].origin, 64, 64, 5);
	
	
	thread maps\siena_snd::play_flood_stream_03();
	
	water[0] waittill("movedone");
	level.water_rising = false;

	
	
	

	

	
}

looping_fx_test()
{
	foam = GetEntArray("water_rise_foam","targetname");
	while(1)
	{
		for(f = 0; f < foam.size; f++)
		{
			vFwd = anglestoforward(foam[f].angles);
			vUp  = anglestoup(foam[f].angles);
			Playfx(level._effect["box_spark"], foam[f].origin, vFwd, vUp);
		}
		wait(2);
	}

}

event_2_lookat_waterfall()
{
	trigger = GetEnt("lookat_waterfall","targetname");
	trigger waittill("trigger");

	if(level.water_rising)
	{
		Earthquake(0.5,1,level.player.origin,2000);
		level notify("fx_water_flow6");
		waterfall = GetEnt("waterfall_6","targetname");
		PhysicsExplosionSphere(waterfall.origin, 64, 64, 5);

		
		thread maps\siena_snd::play_flood_stream_06();
	}
}

event_2_lower_water()
{
	trap = GetEntArray("mousetrap","targetname");
	
	trap[0] waittill("death");

	while(level.water_rising)
	{
		wait(.1);
	}

	s = GetEnt("cistern_scaf_01","targetname");
	s hide();
	bent_s = GetEnt("cistern_scaf_02","targetname");
	bent_s show();
		
	level notify("column_fall_start");
	wait(.2);

	level thread slow_time(.25, 2.5, 1.5);
	
	
	
	
	thread maps\siena_snd::play_stone_column_fall();
	
	
		
	wait(1.5);
	
	Earthquake(.5, 0.8,level.player.origin, 800);

	clip =  GetEnt("gate_player_clip","targetname");
	clip delete();
	
	wall = GetEnt("collapse_geo_collision","targetname");
	wall trigger_on();
	wall DisConnectPaths();

	if(level.player istouching(wall))
	{
		level.player dodamage(level.player.health + 2000, level.player.origin);
	}

	wait(1);
	Earthquake(.5, 1,level.player.origin, 800);
	setblur(3,.1);
	setblur(0,3);
	
	crack = GetEnt("sewer_crack_02","targetname");
	no_crack = GetEnt("sewer_crack_01","targetname");
	crack show();
	no_crack hide();

	level notify("fx_water_vortex");
	
	
	thread maps\siena_snd::play_big_flood_drain();

	level notify("stop_gravity");

	gravity = GetEnt("crack_gravity","targetname");
	g_well = anglestoforward(gravity.angles);
	phys_changeDefaultGravityDir(VectorNormalize(g_well));

	
	currentai = GetAIArray("axis");
	for(i = 0; i < currentai.size; i++)
	{
		if(currentai[i] istouching(wall))
		{
			
			currentai[i] delete();
		}
	}

	level notify("fx_water_lower");
	water = GetEntArray("cistern_water","targetname");
	for(i = 0; i < water.size; i++)
	{
		water[i] movez(-27,20);
	}

	level.gate_down = true;

	level thread voice_tanner_02();

	Objective_State(3, "done");
	Objective_Add( 4, "active", level.strings["objective_3_head"], (688,-835,-60), level.strings["objective_3_desc"]);
	

	wait(20);

	level.player notify("stop_sphere");
}


event_2_to_3()
{
	
	
	
	
	

	
	
	wait(.3);
	
	
	
	
	
	
	wait(.2);
	

	
	trigger = GetEnt("trigger_event_2_to_3","targetname");
	trigger waittill("trigger");
	trigger delete();

	
	guard = spawn_enemy("collapse_main_spawner");
	guard LockAlertState("alert_red");
	guard thread sight_beyond_sight(-1);
	
	level thread save_on_death(guard);
	
	guard LockAiSpeed("jog");
	guard setcombatrole("rusher");

	
	mitchell = spawn_mitchell("event_2_to_3_mitchell");
		
	trigger = GetEnt("look_at_event_2_to_3","targetname");
	trigger waittill("trigger");
	trigger delete();
	
	
	
	level.player playsound("iron_gate2_open");
	
	playcutscene("Siena_SC03_Gate2","gate_2_over");
	level waittill("gate_2_over");
	mitchell delete();
	
	level thread event_2_to_3_shortcut();
	
	
	charges = [];
	for(i = 0; i < 5; i++)
	{
		charges[i] = GetEnt("first_explosions_"+i,"targetname");
		level.fx[i] = spawnfx( level._effect["bomb_glow"], charges[i].origin );
		triggerFx(level.fx[i]);
		wait(.1);
	}
		
	
	Playfx(level._effect["fxtunnel"], charges[0].origin);
	level.fx[0] delete();

	
	charges[0] playsound("Fireball_Explosion");
	charges[0] playsound("cave_explo");

	Earthquake(1, 0.8,charges[0].origin, 800);
	
	
	level.player playsound("cave_shake_lf_01");
	
	
	wait(0.2);  

	wait_time = 0.4;
	for(i = 1; i < charges.size; i++)
	{
		Playfx(level._effect["fxtunnel"], charges[i].origin);
		level.fx[i] delete();
		
		
		charges[i] playsound("Fireball_Explosion");
		charges[i] playsound("cave_explo");

		Earthquake(1, wait_time,charges[i].origin, 800);
		if(i == 2)
		{
			
			
			
			decal_1 = GetEnt("blast_decal01","targetname");
			decal_1 show();
		}
		if(i == 4)
		{
			
			
			
			decal_2 = GetEnt("blast_decal02","targetname");
			decal_2 show();
		}	
		wait(wait_time);
		wait_time -= .1;
	}

	level.player shellshock("default",3);
	level notify("stop_earthquakes");
	level thread random_earthquakes();

	level thread event_2_to_3_door_move();

	level thread voice_tanner_03();

	
	wait(.2);
	

	
	trigger = GetEnt("trigger_shake_1","targetname");
	trigger waittill("trigger");

	
	trigger = GetEnt("look_at_shortcut","targetname");
	if(IsDefined(trigger))
	{
		trigger notify("trigger");
	}	

	
	ambusher = spawn_enemy("collapse_ambush");
	ambusher thread sight_beyond_sight();
	ambusher LockAlertState("alert_red");
	ambusher setcombatrole("rusher");
	
	Earthquake(0.3, 1, level.player.origin, 800);
	
	
	trigger = GetEnt("trigger_shake_2","targetname");
	trigger waittill("trigger");

	
	Earthquake(0.4, 1.5, level.player.origin, 800);
	
	
	trigger = GetEnt("trigger_rats","targetname");
	trigger waittill("trigger");
	trigger delete();

	
	trigger = GetEnt("trigger_shake_lights","targetname");
	trigger waittill("trigger");
	trigger delete();

	Earthquake(1, 1, level.player.origin, 800);
	
	
	trap = GetEnt("dark_tunnel","targetname");

	
	
	
	
	
	trap playsound("light_shatter_2");
	
	wait(.5);
	level.player shellshock("default",3.5);
	
	
	level notify("stop_lights");
	
	
	

	
	wait(2);
	
	
	wait(.1);
	
	wait(.3);
	
	
	level notify("fx_bats_tunnel2");
	
	
	level.player playsound("bats_swarm_front");

	wait(1);

	
	trigger = GetEnt("trigger_lights_out","targetname");
	trigger waittill("trigger");
	trigger delete();

	Earthquake(0.8, 1, level.player.origin, 800);
	level thread event_2_to_3_door_shake();
	level notify("stop_lights");
	
	
	


	
	level thread event_3_cistern_collapse();
}

event_2_to_3_door_move()
{
	self endon("stop_door_move");

	door = GetEnt("gate_tunnel3_a","targetname");
	direction = true;
	max_angle = 30;
	min_angle = -30;
	duration = .5;

	while(min_angle < 0)
	{
		if(direction == true)
		{
			door rotateyaw(min_angle,duration, (duration/3), (duration/3));
			door waittill("rotatedone");
			direction = false;
			if(min_angle < -10)
			{
				min_angle += 10;
				duration += .1;
			}
		}
		else
		{
			door rotateyaw(max_angle,duration, (duration/3), (duration/3));
			door waittill("rotatedone");
			direction = true;	
			if(max_angle > 10)
			{
				max_angle -= 10;
				duration += .1;
			}
		}
	}
}

event_2_to_3_door_shake()
{
	door = GetEnt("gate_tunnel3_b","targetname");

	door rotateyaw(120,3,0,2);
	
	
	
	door playsound("gate_open_slow");
	
	door waittill("rotatedone");

	direction = true;
	max_angle = 9;
	min_angle = -9;
	duration = 1;

	while(min_angle < 0)
	{
		if(direction == true)
		{
			door rotateyaw(min_angle,duration, (duration/3), (duration/3));
			door waittill("rotatedone");
			direction = false;
			if(min_angle < -10)
			{
				min_angle += 10;
				duration += .1;
			}
		}
		else
		{
			door rotateyaw(max_angle,duration, (duration/3), (duration/3));
			door waittill("rotatedone");
			direction = true;	
			if(max_angle > 10)
			{
				max_angle -= 10;
				duration += .1;
			}
		}
	}

}

event_2_to_3_shortcut()
{
	mitchell = spawn_mitchell("event_2_to_3_shortcut_mitchell");

	trigger = GetEnt("look_at_shortcut","targetname");
	trigger waittill("trigger");
	trigger delete();

	mitchell_goal = GetNode("event_2_to_3_shortcut_goal","targetname");
	playcutscene("Siena_SC04_Gate3","gate_3_over");
	level waittill("gate_3_over");
	mitchell SetGoalNode(mitchell_goal);
	mitchell thread kill_on_goal();
}

event_2_to_3_lamp_rotate_1()
{
	light_1_on = GetEnt("lit_tunnel_6_on","targetname");
	light_1_off = GetEnt("lit_tunnel_6_off","targetname");
	light_1_lite = GetEnt("lit_tunnel_6","targetname");
	light_1_off linkto(light_1_on);
	light_1_lite linkto(light_1_on);	
	light_1_off hide();

	direction = true;

	light_1_on rotateroll(-30,.5);
	light_1_on waittill("rotatedone");

	while(1)
	{
		if(direction)
		{
			light_1_on rotateroll(60,1, .25, .25);
			
			
			light_1_on playsound("lamp_swing");
			
			light_1_on waittill("rotatedone");
			direction = false;
		}
		else
		{
			light_1_on rotateroll(-60,1, .25, .25);
			light_1_on waittill("rotatedone");
			direction = true;	
		}
	}
}

event_2_to_3_lamp_rotate_2()
{
	light_2_on = GetEnt("lit_tunnel_6_a_on","targetname");
	light_2_off = GetEnt("lit_tunnel_6_a_off","targetname");
	light_2_lite = GetEnt("lit_tunnel_6_a","targetname");
	light_2_off linkto(light_2_on);
	light_2_lite linkto(light_2_on);	
	light_2_off hide();

	direction = true;

	light_2_on rotateroll(30,.5);
	light_2_on waittill("rotatedone");

	while(1)
	{
		if(direction)
		{
			light_2_on rotateroll(-60,1, .25, .25);
			
			
			
			
			light_2_on waittill("rotatedone");
			direction = false;
		}
		else
		{
			light_2_on rotateroll(60,1, .25, .25);
			
			
			light_2_on playsound("lamp_swing");
			
			light_2_on waittill("rotatedone");
			direction = true;	
		}
	}
}

event_2_to_3_lamp_rotate_3()
{
	light_3_on = GetEnt("lit_tunnel_6_b_on","targetname");
	light_3_off = GetEnt("lit_tunnel_6_b_off","targetname");
	light_3_lite = GetEnt("lit_tunnel_6_b","targetname");
	light_3_off linkto(light_3_on);
	light_3_lite linkto(light_3_on);	
	light_3_off hide();

	direction = true;

	light_3_on rotateroll(-30,.5);
	light_3_on waittill("rotatedone");

	while(1)
	{
		if(direction)
		{
			light_3_on rotateroll(60,1, .25, .25);
			
			
			light_3_on playsound("lamp_swing");
			
			light_3_on waittill("rotatedone");
			direction = false;
		}
		else
		{
			light_3_on rotateroll(-60,1, .25, .25);
			light_3_on waittill("rotatedone");
			direction = true;	
		}
	}
}

event_2_to_3_lights_out(light_name, light_state)
{
	light = GetEnt(light_name,"targetname");
	light_bulb = GetEnt(light_name+"_on","targetname");
	no_light_bulb = GetEnt(light_name+"_off","targetname");

	if(light_state)
	{
		light thread light_flicker(true,1.5,2.5);	
		light_bulb show();
		no_light_bulb hide();
	}
	else
	{
		light thread light_flicker(false,0);
		light_bulb hide();
		no_light_bulb show();
	}

}

event_3_cistern_collapse()
{
	level thread bomb_lights("tunnel_exp");
	
	
	thread maps\siena_snd::play_car_alarm();

	mitchell = spawn_mitchell("event_3_mitchell");

	
	support[0] = GetEnt("support_2_fall","targetname");
	support_old[0] = GetEnt("support_2","targetname");
	support_old[1] = GetEnt("support_3","targetname");
	
	trigger = GetEnt("trigger_collapse","targetname");
	trigger waittill("trigger");
	trigger delete();

	mitchell thread event_3_push_trigger();

	level.player maps\_gameskill::saturateViewThread(false);
	level thread event_3_timer();

	
	trigger = GetEnt("trigger_support_0","targetname");
	trigger waittill("trigger");
	trigger delete();
	
	
	level.player playsound("cave_in_one");
	wait(0.5);
	
	level notify("tunnel_collapse_1_start");
	support[0] trigger_on();
	support_old[0] delete();
	Earthquake(1,.5,level.player.origin, 2000);

	
	trigger = GetEnt("trigger_support_1","targetname");
	trigger waittill("trigger");
	trigger delete();
	
	
	level.player playsound("cave_in_two");
	wait(0.4);
	
	level notify("tunnel_collapse_2_start");
	support_old[1] delete();
	Earthquake(1,.5,level.player.origin, 2000);

	
	trigger = GetEnt("trigger_support_2","targetname");
	trigger waittill("trigger");

	level notify("kill_timer");
	level.player thread maps\_gameskill::saturateViewThread();
	level notify("stop_earthquakes");

	level thread level_end();
}

event_3_push_trigger()
{
	mitchell_goal = GetNode("event_3_goal","targetname");
	self SetGoalNode(mitchell_goal);
	self CmdPlayAnim("Siena_SC06_SetOffCharges");
	self thread kill_on_goal();

	self waittill("cmd_done");
	level notify("stop_earthquakes");
	effect = GetEntArray("tunnel_exp","targetname");

	
	level.player playsound("cistern_shake_lf_01", 1.5);
	
	

	for(i = 0; i < effect.size; i++)
	{
		Playfx(level._effect["fxtunnel"], effect[i].origin);
		level.fx[i] delete();

		
		effect[i] playsound("Fireball_Explosion");
		effect[i] playsound("cave_explo");
		
		wait(.1);
	}

	level thread constant_earthquake();
	level notify ("fx_falling_debris");

	level thread voice_tanner_04();
}

bomb_lights(origin_name)
{
	glowing_lights = GetEntArray(origin_name,"targetname");

	for(i = 0; i < glowing_lights.size; i++)
	{
		level.fx[i] = spawnfx( level._effect["bomb_glow"], glowing_lights[i].origin );
		triggerFx(level.fx[i]);
		wait(.1);
	}
	
}

grenade_tutorial()
{
	while( !level.player hasweapon("concussion_grenade") )
	{
		wait(.1);
	}

	
	update_dvar_scheme();
	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message( "SIENA_WII_TUTORIAL_GRENADE" );
	}
	else
	{
		tutorial_message( "SIENA_WII_TUTORIAL_GRENADE_ZAPPER" );
	}
	

	wait(6); 

	tutorial_message( "" );
}

event_3_timer()
{
	self endon("kill_timer");

	level thread timer_start(30);

	level waittill("timer_ended");

	pos = level.player.origin + (0,0,72);
	Playfx(level._effect["dust_door"], pos, (0,0,1), (1,0,0) );
	level.player dodamage(level.player.health + 2000, level.player.origin);
}

voice_tanner_00()
{
	level.player play_dialogue("BOND_SienG_501A");
	level.player play_dialogue( "TANN_SienG_001A", 1);
	level.player play_dialogue("BOND_SienG_002A");
}

voice_tanner_01()
{
	level.player play_dialogue( "TANN_SienG_003A", 1);
	
	level.player play_dialogue("BOND_SienG_504A");
}

voice_tanner_02()
{
	
	level waittill("timescale_stopped");
	level.player play_dialogue("TANN_SienG_511A");
}

voice_tanner_03()
{
	level.player play_dialogue("TANN_SienG_511C", 1);
	level.player play_dialogue("BOND_SienG_514A");
	level.player play_dialogue("TANN_SienG_515A", 1);
	level.player play_dialogue("BOND_SienG_516A");
}

voice_tanner_04()
{
	level.player play_dialogue("TANN_SienG_517A", 1);
	
	level.player play_dialogue("BOND_SienG_518A");
	level.player play_dialogue("TANN_SienG_519A", 1);
	level.player play_dialogue("BOND_SienG_520A");
}

voice_mitchell_01()
{
	self play_dialogue("MITC_SienG_505A");
}

voice_mitchell_02()
{
	source = GetEnt("tiny_tunnel_voice","targetname");

	source play_dialogue("SWM1_SienG_506A");
	source play_dialogue("MITC_SienG_507A");
}

voice_mitchell_03(mitch, thug1, thug2)
{
	if(IsDefined(thug1))
	{
		thug1 play_dialogue("SWM1_SienG_508A");
	}

	if(IsDefined(thug2))
	{
		thug2 play_dialogue("SWM2_SienG_509A");
	}

	if(IsDefined(mitch))
	{
		mitch play_dialogue("MITC_SienG_510A");
	}

}



swimming_holster_weapons()
{
	trigger = GetEnt("trigger_holster","targetname");
	holster = false;

	while(1)
	{
		if(level.player IsTouching(trigger))
		{
			if(holster == false)
			{
				
				level.player holster_weapons();
				holster = true;
			}
		}
		else
		{
			if(holster == true)
			{
				
				level.player unholster_weapons();
				holster = false;
			}
		}

		wait(0.1);
	}
}

handicap_trap()
{
	trigger = GetEnt("one_hit_trigger","targetname");
	trigger waittill("trigger");

	trap = GetEntArray("mousetrap","targetname");
	
	RadiusDamage(trap[1].origin, 25,200,1000);

	wait(0.5);

	exp = GetEnt("secondary_explosion","targetname");
	PhysicsExplosionSphere(exp.origin, 256, 200, 5);

}

enemy_door()
{
	self endon("death");
	
	while(1)
	{
		trigger = GetEnt("ai_open_door","targetname");
		trigger waittill("trigger");

		gate = GetEntArray("gate_spawn2_b","targetname");
		gate[0] rotateyaw(-90,.5);
		gate[1] rotateyaw(-90,.5);
		wait(1);
		gate[0] rotateyaw(90,4);
		gate[1] rotateyaw(90,4);
		wait(4);
	}
}

enemy_door_2()
{
	self endon("death");

	while(1)
	{
		trigger = GetEnt("ai_open_door_2","targetname");
		trigger waittill("trigger");

		gate = GetEntArray("gate_spawn2_a","targetname");
		gate[0] rotateyaw(90,.5);
		gate[1] rotateyaw(90,.5);
		wait(1);
		gate[0] rotateyaw(-90,4);
		gate[1] rotateyaw(-90,4);
		wait(4);
	}
}

display_chyron()
{
	wait(12);
	maps\_introscreen::introscreen_chyron(&"SIENA_INTRO_01", &"SIENA_INTRO_02", &"SIENA_INTRO_03");
}



optimize_lights()
{
	
	check_1 = GetEnt("trigger_trash_1","targetname");
	check_1 waittill("trigger");

	
	light_off("lit_safehouse01");
	light_off("lit_safehouse02");

	
	check_2 = GetEnt("trigger_event_1_to_2","targetname");
	check_2 waittill("trigger");

	light_off("lit_tunnel01");
	light_off("lit_tunnel02");
	light_off("lit_tunnel03");

	
	check_3 = GetEnt("trigger_event_2","targetname");
	check_3 waittill("trigger");

	
	
	
	
	check_4 = GetEnt("trigger_shake_1","targetname");
	check_4 waittill("trigger");

	light_off("lit_main");
}

light_off(light_name)
{
	light = GetEnt(light_name,"targetname");
	if(!IsDefined(light))
	{
		iPrintLnBold(light_name + " does not exist!");
		return;
	}
	light SetLightIntensity(0);
}
