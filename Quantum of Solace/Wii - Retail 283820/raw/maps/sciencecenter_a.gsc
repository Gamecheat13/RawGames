#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#include maps\sciencecenter_a_util;









main()
{
	
	level.spawn_count = 0;
	level.spawn_deleted = 0;
 
	
	level._effect["electric_sparks"]	= loadfx("impacts/large_metalhit");
	level._effect["rifle_rain"]	= loadfx("weapons/rifle_rain_splashes");

	maps\_blackhawk::main( "v_heli_sca_red", "blackhawk" );
	maps\_blackhawk_sca_bossfight::main();
	
	maps\sciencecenter_a_fx::main();

	
	maps\_useableObjects::main();

	maps\_vvan::main("v_van_white_radiant");
	maps\_vsedan::main("v_sedan_clean_silver_radiant");
	maps\_vsedan::main("v_sedan_clean_blue_radiant");
	maps\_vsedan::main("v_sedan_clean_gunmetal_radiant");
	maps\_vsedan::main("v_sedan_police_radiant");
	maps\_vsuv::main("v_suv_clean_blue_radiant");
	maps\_vsuv::main("v_suv_clean_black_radiant");
	maps\_vsuv::main("v_suv_clean_red_radiant");
	
	maps\_securitycamera::init();

	
	level._effect["vehicle_night_headlight"]	= loadfx ("vehicles/night/vehicle_night_headlight02");	
	level._effect["vehicle_night_taillight"]	= loadfx ("vehicles/night/vehicle_night_taillight");

	
	
	character\character_tourist_1::precache();
	

	
	

	


	


	


	

















	maps\_load::main();


	
	VisionSetNaked("sciencecenter_a");	
	
	
	PrecacheCutScene("Dim_steps");
	PrecacheCutScene("SCA_BOND_Street_Cross");
	precachecutscene( "SCA_Heli_Crash" );


	
	precacheShader( "compass_map_miamisciencecenter" );
	setminimap( "compass_map_miamisciencecenter", 3904, 5376, -2880, -3318);
	
	thread maps\miamisciencecenter_snd::main();
	maps\sciencecenter_a_mus::main();

	
	level thread maps\sciencecenter_a_vehicle::main();
	level.traffic_running = true;
	

	
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}           

	
	precacheshellshock ("default");
	
	
	level.dyn_spot_light = getent ( "light_spot", "targetname" );
	level.dyn_spot_light setlightintensity ( 0 );
	level.spotlight_ledge = getent ( "light_ledge_spot", "targetname" );
	level.spotlight_ledge setlightintensity ( 0 );

	
	PreCacheItem("WA2000_intro");
	PreCacheItem("WA2000_SCa_s");
	PreCacheItem("p99_wet_s");
	PreCacheItem("SAF9_SCa");

	
	level thread setup_cutscenes();

	
	level thread objective_01();
	
	
	
	level thread map_change_level2a();
	
	
	
	level thread hud_info_text();
	level thread setup_sniperScope();
	
	

	
	level.alley_door_closed = true;
	level.crossed_street = false; 
	level.alarm_triggered = false;
	level.roof_snipers_alert = false;
	level.all_snipers_dead = false;

	level.stealth_inside = 0;  
	level.inside_pics = 0;     
	level.doors_open = 0;      
	level.trash = 0;           
	level.laptop = 0;          
	level.outside_clean = 0;   
	level.light_flicker = 0;   
	level.alley_thug_death = 0;
	level.dolly_check = 0;     
	level.dolly_thug = 0;      
	level.temp_node = 0;       
	level.fan = 0;             
	level.corner_thugs = 0;    
	level.box1_check = 0;      
	level.box2_check = 0;      
	level.roof_shooters = 0;   
	level.earpeice = 0;        
	level.chain_fence = 0;     
	level.ledge_access = 0;    
	level.go_away = 0;         
	level.alley_go_away = 0;   
	level.got_gun = 0;         
	level.roof_start = 0; 
	level.no_zoom = 0;
	
	level.player setstance("stand");
	level.player freezecontrols(true);

	
	
	level.player_outside = true;
	level.weapon_rain_fx = undefined;
	thread track_current_weapon();
	thread change_environment_setup();
	
	level thread global_rain1();
	level thread global_rain5();
	level thread global_rain_05();
	

	
	
	level.sniperFov = 65.0; 
	level.sniperFocusDistance = 1000.0;
	
   
	

	
	

	
	level thread skip_to_points();
	
	
	level thread check_achievement();
	
	
	
	

	level thread balcony_sniper_event();
	level thread rotating_billboard_setup();
	
	
	

	
	level thread roof_end_level();
	

}








objective_01()
{
	level waittill ( "start_objective_01" );
	objective_01_pos = getent("objective_01_pos", "targetname");
	objective_add( 0, "current", &"SCIENCECENTER_A_OBJECTIVE_01", objective_01_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_01_INSTR"  ); 
	
	level waittill("obj_1_modified");
	objective_state( 0, "done" );
	objective_add( 1, "current", &"SCIENCECENTER_A_OBJECTIVE_01B", objective_01_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_01B_INSTR"  ); 

	level waittill("all_snipers_dead");

	
	objective_02_pos = getent("objective_02_pos", "targetname");
	objective_state( 1, "done" );
	objective_add(2, "current", &"SCIENCECENTER_A_OBJECTIVE_01C", objective_02_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_01C_INSTR"); 

	level notify( "obj_1_complete" );
}
objective_02()
{
	objective_02_pos = getent("objective_02_pos", "targetname");
	objective_state( 2, "done" );
	objective_add( 3, "current", &"SCIENCECENTER_A_OBJECTIVE_02", objective_02_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_02_INSTR" );
}

objective_03()
{
	objective_03_pos = getent("objective_03_pos", "targetname");
	objective_state( 3, "done" );
	objective_add( 4, "current", &"SCIENCECENTER_A_OBJECTIVE_03", objective_03_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_03_INSTR" ); 
}

objective_04()
{
	objective_04_pos = getent("objective_04_pos", "targetname");
	objective_state( 4, "done" );
	objective_add( 5, "current", &"SCIENCECENTER_A_OBJECTIVE_04", objective_04_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_04_INSTR" );
}

objective_05()
{
	objective_05_pos = getent("objective_05_pos", "targetname");
	objective_state( 5, "done" );
	objective_add( 6, "current", &"SCIENCECENTER_A_OBJECTIVE_05", objective_05_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_05_INSTR" ); 
}

objective_05B()
{
	objective_state( 6, "done" );
	objective_add( 7, "current", &"SCIENCECENTER_A_OBJECTIVE_05B", self.origin ); 
}
objective_06()
{
	objective_05_pos = getent("objective_05_pos", "targetname");
	objective_state( 7, "done" );
	objective_add( 8, "current", &"SCIENCECENTER_A_OBJECTIVE_06", objective_05_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_06_INSTR" ); 
}










balcony_sniper_event()
{
	if((Getdvar( "skipto" ) == "1" ) || (Getdvar( "skipto" ) == "2" ) || 
	(Getdvar( "skipto" ) == "3" ) || (Getdvar( "skipto" ) == "4" ))
	{
		return;
	}

	
	thread setup_roof_crumb();
	
	
		
	
	level notify("playmusicpackage_sniper1");
	
	
	
	
	
	
	

	wait(0.05);
	playcutscene("Dim_steps", "intro_cutscene_done");
	level thread display_chyron();
	

	
	
	setdvar("ui_hud_showstanceicon", "0");
	setsaveddvar("ammocounterhide", "1");
	
	wait(0.05);
	setsaveddvar("cg_drawBreathHint", "0"); 
	setsaveddvar("cg_disableBackButton", "1"); 

	
	

	level waittill("intro_cutscene_done");	
	

	

	
	setDVar( "cg_laserAiOn", 1 );
	
	level.sniper_event = true;
	
	
	
	
	
	balcony_thug_spawner = getentArray("balcony_thug", "targetname");
	balcony_thug = [];
	if ( IsDefined(balcony_thug_spawner) )
	{
		for (i=0; i<balcony_thug_spawner.size; i++)
		{
			balcony_thug[i] = balcony_thug_spawner[i] StalingradSpawn();
			if( !spawn_failed( balcony_thug[i] ) )
			{
				balcony_thug[i] thread balcony_shootat_bond();
				balcony_thug[i].targetname = "balcony_thug";
			}
			else
			{
				
			}	
		}
	}
		
	
	level thread show_thugs(balcony_thug);
	level waittill("thug_camera_done");

	lookat = getent("bond_startpos_origin", "targetname");
	level.player setPlayerAngles(lookat.angles);
	level.player freezecontrols( false );

	
	level.player switchToWeapon( "wa2000_sca_s" );
	
	
	
	level.player takeweapon("WA2000_intro");

	
	setdvar("ui_hud_showstanceicon", "1");
	setsaveddvar("ammocounterhide", "0");
	setsaveddvar("cg_drawBreathHint", "1"); 
	setsaveddvar("cg_disableBackButton", "0"); 

	setsaveddvar("bg_quick_kill_enabled", false);
	setsaveddvar("melee_enabled", false);	
	
	wait(0.05);
	level.balcony_snipers = getentArray ("balcony_thug", "targetname");
	
	thread villiers_sniper_text();

	
	wait(0.05);
	thread maps\_autosave::autosave_now("MiamiScienceCenter");

	while(level.balcony_snipers.size > 0)
	{
		wait(0.05);
		level.balcony_snipers = array_removedead( level.balcony_snipers );
	}

	wait(0.05);
	level thread player_in_billboard();
	wait(0.05);
	thread roof_sniper_setup();

	wait(1.0);
	
	thread maps\_autosave::autosave_now("MiamiScienceCenter");	

}	
setup_roof_crumb()
{
	roof_door_crumb = GetEnt("roof_door_crumb", "script_noteworthy");
	objective1_crumb = GetEnt("objective1_crumb", "script_noteworthy");

	
	
	level waittill("all_snipers_dead");
	objective1_crumb notify("trigger");
	
}




	
	
	
	
	
	
	
	
	
	
	
	

show_thugs(thugs)
{	
	
	level.player customcamera_checkcollisions(0);	

	cam_pos = level.player.origin + (0, 0, 72);
	thug1 = thugs[1];
	thug1_pos = spawn( "script_origin", thug1.origin +(0, 0, 52) ); 
	thug1_pos linkto(thug1);

	cameraID = level.player CustomCamera_Push("world", thug1_pos, cam_pos, (0, 0, 0),	0.0);
	thread show_thugs_dialog();

	
	updateTime = 0.05;
	sniperFov = 5.0;
	level.player customcamera_setFov( cameraID, sniperFov, updateTime, 0.0, 0.0 );

	wait(2.0);
 
	thug2 = thugs[2];
	thug2_pos = spawn( "script_origin", thug2.origin +(0, 0, 52) ); 
	thug2_pos linkto(thug2);
	level.player customcamera_change( CameraID, "world", thug2_pos, cam_pos, (0, 0, 0), 2.0 );

	updateTime = 0.5;
	sniperFov = 8.0;
	level.player customcamera_setFov( cameraID, sniperFov, updateTime, 0.0, 0.0 );

	wait( 4.0 );

	thug0 = thugs[0];
	thug0_pos = spawn( "script_origin", thug0.origin +(0, 0, 52) ); 
	thug0_pos linkto(thug0);
	level.player customcamera_change( CameraID, "world", thug0_pos, cam_pos, (0, 0, 0), 2.0 );

	updateTime = 1.0;
	sniperFov = 20.0;
	level.player customcamera_setFov( cameraID, sniperFov, updateTime, 0.0, 0.0 );

	wait( 3.0 );

	level.player CustomCamera_Pop( cameraID, 1.0 );
	wait(1.0);

	level.player customcamera_checkcollisions(1);	
	thread sparking_busted_panel();
	
	level notify("thug_camera_done");

	
	thread setup_car_alarms();
}
show_thugs_dialog()
{
	level.player play_dialogue("BOND_SciAC_004A", true); 
	wait(0.5);
	level.player play_dialogue("M_SciAC_007A", true); 
	wait(1.0);
	level.player play_dialogue("BOND_SciAC_008A", true); 
}
balcony_shootat_bond()
{
	self endon("death");
	
	if( self getalertstate() != "alert_red" )
	{
		self waittill( "start_propagation" );
	}
	
	if(	level.alarm_triggered == true) return; 
		
	self setalertstatemin("alert_red");	
	self setperfectsense(true);
	self addengagerule("tgtperceive");
	
	

	while(IsDefined(self))
	{
		xtime = randomfloatrange( 1.0, 2.5 );
		self cmdshootatentityxtimes( level.player, false, 1, 0.75 );		
		self cmdaimatentity( level.player, false, -1);

		wait( xtime );
		self stopallcmds();
	}
}
villiers_sniper_text()
{
	

	wait(2.0);
	
	
	level notify( "start_objective_01" );

	while(level.balcony_snipers.size >= 3)
	{
		wait(0.05);
	}	
	thread sniper_heli_flyby();
	
	while(level.balcony_snipers.size >= 1)
	{
		wait(0.05);
	}	
	level.player play_dialogue("TANN_SciAG_009A", true); 
	
	
	
	level notify("obj_1_modified");

	wait(1.0);
	
	
}	

roof_sniper_setup()
{
	
	roof_sniper_spawner = getent("roof_sniper_front", "targetname");
	edge_node = getnode( "roof_sniper_edgenode", "targetname" );
	
	roof_sniper_spawner_L = getent("roof_sniper_left", "targetname");
	edge_node_L = getnode( "roof_sniper_edgenode_L", "targetname" );

	roof_sniper_spawner_R = getent("roof_sniper_right", "targetname");
	edge_node_R = getnode( "roof_sniper_edgenode_R", "targetname" );
	

	
	
	

	
	level notify("playmusicpackage_sniper2");

	
	
	



	
	roof_sniper_front = roof_sniper_spawner StalingradSpawn();
	roof_sniper_left = roof_sniper_spawner_L StalingradSpawn();
	roof_sniper_right = roof_sniper_spawner_R StalingradSpawn();
	
	if(	level.alarm_triggered == true)
	{
		
		roof_sniper_front thread alarm_shoot_bond(edge_node);
		roof_sniper_left thread alarm_shoot_bond(edge_node_L);
		roof_sniper_right thread alarm_shoot_bond(edge_node_R);
	}
	else
		{
		
		roof_sniper_front thread sniper_shootat_bond(edge_node);
		roof_sniper_left thread sniper_shootat_bond(edge_node_L);
		roof_sniper_right thread sniper_shootat_bond(edge_node_R);
	}


	level.player thread check_snipers(roof_sniper_front, roof_sniper_left, roof_sniper_right);

	level waittill("all_snipers_dead");
	
	
	level.player play_dialogue("TANN_SciAG_013A", true); 

	level.sniper_event = false;

	thread exit_roof_setup();
}
sniper_shootat_bond(node)
{
	self endon("death");
	
	
	self SetScriptSpeed("Run");
	self setgoalnode(node);
	self waittill("goal");
	self SetScriptSpeed("default");
	
	if( self getalertstate() != "alert_red" )
	{
		self waittill( "start_propagation" );
	}

	
	if(	level.roof_snipers_alert == false)
	{
		level.roof_snipers_alert = true;
		thug = getaiarray("axis");
		if ( IsDefined(thug) )
		{
			for (i=0; i<thug.size; i++)
			{
				thug[i] thread snipers_shooting_loop();
			}		
		}
	}	
}	
snipers_shooting_loop()
{	
	self endon("death");
	
	self setalertstatemin("alert_red");	
	self setperfectsense(true);
	self addengagerule("tgtperceive");
		
	while(IsDefined(self))
	{
		
		if(level.in_sign)
		{
			
		xtime = randomfloatrange( 1.0, 2.5 );
			self cmdshootatentityxtimes(level.player, false, 1, 0.5);		
			self cmdaimatentity(level.player, false, -1);

				wait(xtime);
				self stopallcmds();
			}
		
		else
		{
		xtime = randomfloatrange( 1.0, 2.5 );
			self cmdshootatentityxtimes(level.player, false, 2, 0.8);		
			self cmdaimatentity(level.player, false, -1);

			wait( xtime );
			self stopallcmds();
		}
		wait(0.05);
	}
}

player_in_billboard()
{
	level endon("all_snipers_dead");

	in_sign_trig = getent("in_sign_trigger", "targetname");
	level.in_sign = false;
		
	while(1)
	{
		wait(0.5);
		if(level.player istouching(in_sign_trig) )
		{
			if(level.in_sign == false)
			{
				level.in_sign = true;
			}	
		}
		else
		{
			if(level.in_sign == true)
			{
				level.in_sign = false;
			}	
		}	
	}
}	

check_snipers(sniper1, sniper2, sniper3)
{
	self endon("death");

	
	level.player play_dialogue("TANN_SciAG_010A", true); 
	
	playedVO2 = false;
	playedVO3 = false;
	while(isalive(sniper1) || isalive(sniper2) || isalive(sniper3))
	{
		
		if(!isalive(sniper1) && isalive(sniper2) && !playedVO2)
		{
			
			level.player play_dialogue("TANN_SciAG_011A", true); 
			playedVO2 = true;
		}

		
		if(!isalive(sniper1) && !isalive(sniper2) && isalive(sniper3) && !playedVO3)
		{
			
			level.player play_dialogue("TANN_SciAG_012A", true); 
			playedVO3 = true;
		}
		wait(0.05);
	}
	level notify("all_snipers_dead");
	level.all_snipers_dead = true;
}
exit_roof_setup()
{
	
	level notify("playmusicpackage_alley");

	roof_exit = getent("sniper_roof_exit", "targetname");
	if(IsDefined(roof_exit))
	{
		roof_exit waittill("trigger");
		
		
		level.no_zoom = 1;
		
		thread sniper_event_end_cinematic();
	
	}	
}	

take_damage()
{
	
	self setcandamage(true);
	strength = randomintrange(100, 200);
	self.health = strength;
	
	self waittill("damage");
	
	
	self.moving = false;
	
	
	
	
	
	t = randomint(4);
	if(t == 2)
	{
		p = randomfloatrange(-7, 7);
		self rotatepitch(p, 1.0);
	}
	else
	{
		
		y = randomfloatrange(45, 135);
		self RotateTo((0, y, 0), 1.0);
	}
	wait(1.1);
	
	while( level.sniper_event == true)
	{
		sparks = playfx( level._effect[ "electric_sparks" ], self.origin );
		
				
		self rotateYaw(5,0.2);
		wait(0.25);
		self rotateYaw(-5,0.2);
		wait(0.7);
	}	
	


}


temporary_infinite_ammo()
{
	level.player endon("death");
	
	while (level.sniper_event == true)
	{
		
		
		clipCount = level.player GetWeaponAmmoStock("wa2000_sca");
		if(clipCount <= 0)
			level.player givemaxammo("wa2000_sca");
		wait(0.5);
	}
}



sniper_event_end_cinematic()
{
	
	level notify("end_sniper_event");
	
	level.player freezecontrols( true );
	
	visionSetNaked( "science_center_a_alley", 1.0 ); 
	
	
	street_civ = getentArray ( "street_civ", "targetname" );
	for(i=0;i<street_civ.size; i++)
	{
		street_civ[i] delete();
	}

	
	setDVar( "cg_laserAiOn", 0 );
	
	
	level thread maps\sciencecenter_a_alley::alley_main();
	level notify("alley_trash_nonlooping_start");
	

	level.player GiveWeapon("p99_wet_s");
	level.player switchToWeapon( "p99_wet_s" );
	level.player takeweapon("wa2000_sca_s");

	
	level notify( "delete_cars" );
	level notify( "delete_drivers" );
	
	wait(0.05);
	playcutscene("SCA_BOND_Street_Cross","cutscene_done");
	level notify("ledge_pigeons"); 
        level waittill("cutscene_done");
	level notify("street_crossing_done");


	
	new_player_pos = getent ("event2_player", "targetname");
	level.player setorigin( new_player_pos.origin);
	level.player setplayerangles((new_player_pos.angles));

        level.player freezecontrols( false );
	
        thread alley_dumpster_cover();
	wait(2.0);

	level.crossed_street = true; 
	
	thread objective_02();
	thread maps\_autosave::autosave_now("MiamiScienceCenter");
	
}

alley_dumpster_cover()
{
	level.player endon("death");

	level.dumpster_trig = getent ("alley_force_cover", "targetname");
	level.dumpster_trig waittill("trigger");

	while(level.player IsTouching(level.dumpster_trig) && level.crossed_street == false)
	{
		
		level.player playerSetForceCover(true);
		wait(0.01);
	}	
	level.dumpster_trig delete();
	level.player playerSetForceCover(false, false);
}	

rotating_billboard_setup()
{
	self endon("end_sniper_event");

	
	level.billboard_rotating = GetEntArray("billboard_rotating01", "targetname");
	level.billboard_moving = true;

	for(i = 0; i < level.billboard_rotating.size; i++)
	{
		if(isdefined(level.billboard_rotating[i]))
		{
			level.billboard_rotating[i].moving = true;

			
			level.billboard_rotating[i] thread take_damage();
		}
	}
	
	level.billboard_rotating[10] playloopsound ( "bb_idle" );

	while(level.billboard_moving == true)
	{
		for ( i = 0; i < level.billboard_rotating.size; i++ )
		{
			if(level.billboard_rotating[i].moving)
				level.billboard_rotating[i] rotateYaw(90,2.5);
		}
		level.billboard_rotating[10] stoploopsound();
		level.billboard_rotating[9] playloopsound ( "bb_move" );
		wait(2.5);
		level.billboard_rotating[9] stoploopsound();
		level.billboard_rotating[10] playloopsound ( "bb_idle" );

		
		for ( i = 0; i < level.billboard_rotating.size; i++ )
		{		
			if(level.billboard_rotating[i].moving)
			{
				spark[i] = playfx( level._effect[ "electric_sparks" ], level.billboard_rotating[i].origin );
			}
		}

		wait(1.0);

		for ( i = 0; i < level.billboard_rotating.size; i++ )
		{
			if(level.billboard_rotating[i].moving)
				level.billboard_rotating[i] rotateYaw(90,2.5);
		}		
		level.billboard_rotating[10] stoploopsound();
		level.billboard_rotating[9] playloopsound ( "bb_move" );
		wait(2.5);
		level.billboard_rotating[9] stoploopsound();
		level.billboard_rotating[10] playloopsound ( "bb_idle" );
		wait(5.5);
	}
}

sparking_busted_panel()
{
	level.player endon("death");

	busted_panel = getent ("billboard_rotating02", "targetname");
	busted_panel playloopsound ( "bb_stuck" );
	
	while( level.sniper_event == true)
	{
		sparks = playfx( level._effect[ "electric_sparks" ], busted_panel.origin );
		busted_panel playsound("sparks");
				
		busted_panel rotateYaw(5,0.2);
		wait(0.25);
		busted_panel rotateYaw(-5,0.2);
		wait(0.7);
	}	
}	





enable_camera_hack()
{
	self waittill( "damage" );
	
	entBox = GetEnt( self.target, "targetname" );
	
	entBox notify( entBox.script_alert );
}




roof_end_level()
{
	level waittill( "end_science_center_a" );

	
	maps\_endmission::nextmission();
}




#using_animtree("vehicles");
sniper_heli_flyby()
{
	
	heli_flyby = getent( "sniper_heli_flyby1", "targetname" );
	heli = spawnvehicle( "v_heli_sca_red", "helicopter", "blackhawk", (heli_flyby.origin), (heli_flyby.angles) );

	
	heli.health = 100000;
	heli setspeed( 50, 40 );

	
	heli UseAnimTree( #animtree );
	heli setanim( %bh_rotors );
	
	

	pos = getent( "sniper_heli_flyby2", "targetname" );
	heli setlookatent( pos );
	heli setvehgoalpos( pos.origin, 0 );
	heli waittill( "goal" );

	pos = getent( "sniper_heli_flyby3", "targetname" );

	heli setvehgoalpos( pos.origin, 1 );
	heli waittill( "goal" );

	heli delete();
}

display_chyron()
{
	wait(3.0);
	maps\_introscreen::introscreen_chyron(&"SCIENCECENTER_A_INTRO_01", &"SCIENCECENTER_A_INTRO_02", &"SCIENCECENTER_A_INTRO_03");
}
