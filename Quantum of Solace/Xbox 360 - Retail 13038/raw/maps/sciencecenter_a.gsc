#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#include maps\sciencecenter_a_util;


////////////////////////////////////////////////////////////////////////////////////////////////
// 			SCIENCE CENTER A (EXTERIOR)
////////////////////////////////////////////////////////////////////////////////////////////////
// NOTE: This GSC file only deals with the front, the alley, the back lot and the roof.
// "cinematic_done" is the notify when a movie is done playing.
////////////////////////////////////////////////////////////////////////////////////////////////

main()
{
	// debug variables
	level.spawn_count = 0;
	level.spawn_deleted = 0;
 
	//// precache & load FX entities (do before calling _load::main) - not for ps3! moved below load::main -D.O.
	level._effect["electric_sparks"]	= loadfx("impacts/large_metalhit");
	level._effect["rifle_rain"]	= loadfx("weapons/rifle_rain_splashes");


	maps\_blackhawk::main( "v_heli_sca_red", "blackhawk" );
	

	maps\_vvan::main("v_van_white_rain_radiant");
	maps\_vsedan::main("v_sedan_us_silver_radiant");
	maps\_vsedan::main("v_sedan_us_blue_radiant");
	maps\_vsedan::main("v_sedan_us_gunmetal_radiant");
	maps\_vsedan::main("v_sedan_police_radiant");
	maps\_vsuv::main("v_suv_us_blue_radiant");
	maps\_vsuv::main("v_suv_us_gunmetal_radiant");
	maps\_vsuv::main("v_suv_us_red_radiant");

	
	maps\_securitycamera::init();

	
	level._effect["vehicle_night_headlight"]	= loadfx ("vehicles/night/vehicle_night_headlight02");	
	level._effect["vehicle_night_taillight"]	= loadfx ("vehicles/night/vehicle_night_taillight");

	
	// * Setup Drones * //
	character\character_tourist_1::precache();
	//level.drone_spawnFunction["civilian"] = character\character_tourist_1::main;

	// drone init - look for drone trigs
	//	maps\_drones::init();

	// ----- FOR Data Collection -----
	level.strings["sciencecenter_a_phone1_name"] = &"SCIENCECENTER_A_SCIENCECENTER_A_NAME1";
	level.strings["sciencecenter_a_phone1_body"] = &"SCIENCECENTER_A_SCIENCECENTER_A_BODY1";
	
	level.strings["sciencecenter_a_phone2_name"] = &"SCIENCECENTER_A_SCIENCECENTER_A_NAME2";
	level.strings["sciencecenter_a_phone2_body"] = &"SCIENCECENTER_A_SCIENCECENTER_A_BODY2";
	
	level.strings["sciencecenter_a_phone3_name"] = &"SCIENCECENTER_A_SCIENCECENTER_A_NAME3";
	level.strings["sciencecenter_a_phone3_body"] = &"SCIENCECENTER_A_SCIENCECENTER_A_BODY3";
	
	level.strings["sciencecenter_a_phone4_name"] = &"SCIENCECENTER_A_SCIENCECENTER_A_NAME4";
	level.strings["sciencecenter_a_phone4_body"] = &"SCIENCECENTER_A_SCIENCECENTER_A_BODY4";

	level.strings["sciencecenter_a_phone5_name"] = &"SCIENCECENTER_A_SCIENCECENTER_A_NAME5";
	level.strings["sciencecenter_a_phone5_body"] = &"SCIENCECENTER_A_SCIENCECENTER_A_BODY5";

	data_phone2 = getent("data_phone2", "targetname");
	data_phone3 = getent("data_phone3", "targetname");
	data_phone2.script_image = "data_collection_image_sciA_2";
	data_phone3.script_image = "data_collection_image_sciA_3";

	data_phone1 = getent("data_phone1", "targetname");
	data_phone4 = getent("data_phone4", "targetname");	
	data_phone1.script_soundalias = "SCM1_SciAG_816A";
	data_phone4.script_soundalias = "SCM2_SciAG_817A";


	maps\_load::main();
	maps\sciencecenter_a_fx::main();

	// temp xenon test for ps3
//	visionSetNaked( "sciencecenter_a_ps3" ); 
//	setculldist(8000);
//	setExpFog(0,2500,.180,.188,.195,0);


	if(level.ps3)
	{
		visionSetNaked( "sciencecenter_a_ps3" ); 
		setculldist(8000);
		setExpFog(0,2500,.180,.188,.195,0);
	}
	else
	{	
		VisionSetNaked("sciencecenter_a");	
		setExpFog(0,3700,.180,.188,.195,0);
	}
	
	//precache the sceneanims
	PrecacheCutScene("Dim_steps");
	PrecacheCutScene("SCA_BOND_Street_Cross");
	precachecutscene( "SCA_Heli_Crash" );


	//// setup map
	precacheShader( "compass_map_miamisciencecenter" );
	setminimap( "compass_map_miamisciencecenter", 3904, 5376, -2880, -3318);
	
	thread maps\miamisciencecenter_snd::main();
	maps\sciencecenter_a_mus::main();

	// street traffic.
	level thread maps\sciencecenter_a_vehicle::main();
	level.traffic_running = true;
	

	//artist mode
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}           

	// Precaching shell shock effect.
	precacheshellshock ("default");
	
	// dynamic spotlight initial setup
	level.dyn_spot_light = getent ( "light_spot", "targetname" );
	level.dyn_spot_light setlightintensity ( 0 );
	level.spotlight_ledge = getent ( "light_ledge_spot", "targetname" );
	level.spotlight_ledge setlightintensity ( 0 );

	// precache sniper weapon.
	PreCacheItem("WA2000_intro");
	PreCacheItem("WA2000_SCa_s");
	PreCacheItem("p99_wet_s");
	PreCacheItem("SAF9_SCa");

	// setup cutscenes
	level thread setup_cutscenes();

	//---------- OBJECTIVES -------------
	level thread objective_01();
	//-----------------------------------
	
	//---------- MAP CHANGES ------------
	level thread map_change_level2a();
	//-----------------------------------
	
	//------- GLOBAL FUNCTIONS ----------
	level thread hud_info_text();
	level thread setup_sniperScope();
	//level thread setup_laptop_pets();
	//-----------------------------------

	// ------ LEVEL VARIABLES -----------
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
	// ----------------------------------
	
	// ------ Rain Tracking -------------
	level.player_outside = true;
	level.weapon_rain_fx = undefined;
	thread track_current_weapon();
	thread change_environment_setup();
	
	level thread global_rain1();
	level thread global_rain5();
	level thread global_rain_05();
	// ----------------------------------

	
	// ----- FOR SAVING SNIPER FOV -----
	level.sniperFov = 65.0; 
	level.sniperFocusDistance = 1000.0;
	// ----------------------------------
   
	// ----- Add the Wet Materials -----	
	level thread add_wet_materials();
	
	// ----------------------------------

	//if need to skipto ----------------
	level thread skip_to_points();
	// ----------------------------------
	
	level thread check_achievement();
	
	
	// -------- FRONT FUNCTIONS ---------
	thread maps\sciencecenter_a_vehicle::mono_move_0();
	
	level thread balcony_sniper_event();
	level thread rotating_billboard_setup();
	level thread setup_dead_roof_guy();

	// ----------------------------------
	
	// ------ DAD ROCKET JUMP FIX -------
	level thread dad_rocket_jump_fix();
	
	// ----------------------------------

	
	// ------ END LEVEL FUNCTION --------
	level thread roof_end_level();
	// ----------------------------------

}

////////////////////////////////////////////////////
//							 OBJECTIVES 
////////////////////////////////////////////////////


//avulaj
//this is the first Objective Bond gets
objective_01()
{
	level waittill ( "start_objective_01" );
	objective_01_pos = getent("objective_01_pos", "targetname");
	objective_add( 0, "active", &"SCIENCECENTER_A_OBJECTIVE_01", objective_01_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_01_INSTR"  ); //"Eliminate the marksmen "
	
	level waittill("obj_1_modified");
	objective_state( 0, "done" );
	objective_add( 1, "active", &"SCIENCECENTER_A_OBJECTIVE_01B", objective_01_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_01B_INSTR"  ); //"Eliminate the marksmen "

	level waittill("all_snipers_dead");

	// AE 7/3/08: bug fix, we need to show that the objective is complete and tell them to leave the roof
	objective_02_pos = getent("objective_02_pos", "targetname");
	objective_state( 1, "done" );
	objective_add(2, "active", &"SCIENCECENTER_A_OBJECTIVE_01C", objective_02_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_01C_INSTR"); // leave the roof

	level notify( "obj_1_complete" );
}
objective_02()
{
	objective_02_pos = getent("objective_02_pos", "targetname");
	objective_state( 2, "done" );
	objective_add( 3, "active", &"SCIENCECENTER_A_OBJECTIVE_02", objective_02_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_02_INSTR" );//"Sneak through the alley."
}

objective_03()
{
	objective_03_pos = getent("objective_03_pos", "targetname");
	objective_state( 3, "done" );
	objective_add( 4, "active", &"SCIENCECENTER_A_OBJECTIVE_03", objective_03_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_03_INSTR" ); //"Clear a path to the loading dock"
}

objective_04()
{
	objective_04_pos = getent("objective_04_pos", "targetname");
	objective_state( 4, "done" );
	objective_add( 5, "active", &"SCIENCECENTER_A_OBJECTIVE_04", objective_04_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_04_INSTR" );//"Climb up to the roof"
}

objective_05()
{
	objective_05_pos = getent("objective_05_pos", "targetname");
	objective_state( 5, "done" );
	objective_add( 6, "active", &"SCIENCECENTER_A_OBJECTIVE_05", objective_05_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_05_INSTR" ); //"Find the service door"
}

objective_05B()
{
	objective_state( 6, "done" );
	objective_add( 7, "active", &"SCIENCECENTER_A_OBJECTIVE_05B", self.origin ); //"take out the helicopter"
}
objective_06()
{
	objective_05_pos = getent("objective_05_pos", "targetname");
	objective_state( 7, "done" );
	objective_add( 8, "active", &"SCIENCECENTER_A_OBJECTIVE_06", objective_05_pos.origin, &"SCIENCECENTER_A_OBJECTIVE_06_INSTR" ); //"Enter the Facility"
}


////////////////////////////////////////////////////////////////////////////////////
//   Add the Wet materials to the game
////////////////////////////////////////////////////////////////////////////////////

add_wet_materials()
{
	wait( 0.01 );
	
	// Weapon WA2000
	materialaddwet( "mtl_w_wa_2000_metal_wet" );
	materialaddwet( "mtl_w_wa_2000_wood_wet" );
	materialaddwet( "mtl_w_scope_nv_wet" );
	
	// Weapon PA99
	materialaddwet( "mtl_w_p99_wet" );
	materialaddwet( "mtl_w_p99_silenced_wet" );
	
	// M14
	materialaddwet( "mtl_w_m14_wet" );
	materialaddwet( "mtl_w_m14_stock_rail_wet" );
	materialaddwet( "mtl_w_foregrip_wet" );
	materialaddwet( "mtl_w_silencer_rifle_wet" );
	
	// SAF9
	materialaddwet( "mtl_w_mp05_wet" );
	materialaddwet( "mtl_w_silencer_rifle_03_wet" );
	materialaddwet( "mtl_w_foregrip_wet" );
	materialaddwet( "mtl_w_mp05_plastic_wet" );
	materialaddwet( "mtl_w_mp05_stock_sd_wet" );

	// Additional requested materials
	materialaddwet( "mtl_w_laser_wet" );
	materialaddwet( "mtl_w_longscope_wet" );
	materialaddwet( "mtl_w_m14_plastic_wet" );

	// 1911
	materialaddwet( "mtl_w_1911_wet" );

	//DAD
	materialaddwet( "mtl_w_m32" );
	materialaddwet( "mtl_w_m32_metal_wet" );
	materialaddwet( "mtl_w_m32_ammo_wet" );	

	//wait( 51 );
	//materialsetwet( 0 );
	
	//wait( 8 );
	//materialsetwet( 1 );
}

////////////////////////////////////////////////////////////////////////////////////
street_civs_setup()
{
	street_civ = getentArray ( "street_civ", "targetname" );
	for(i=0;i<street_civ.size; i++)
	{
		street_civ[i] animscripts\shared::placeWeaponOn(street_civ[i].weapon, "none");
		street_civ[i] setenablesense(false);
		street_civ[i] lockalertstate("alert_green");
		street_civ[i] setignorethreat(level.player, true);

	}
}	
////////////////////////////////////////////////////////////////////////////////////
//                    ROOFTOP SNIPER EVENT                
////////////////////////////////////////////////////////////////////////////////////
balcony_sniper_event()
{
	if((Getdvar( "skipto" ) == "1" ) || (Getdvar( "skipto" ) == "2" ) || 
	(Getdvar( "skipto" ) == "3" ) || (Getdvar( "skipto" ) == "4" ))
	{
		return;
	}
	
	//need to move crumb.
	thread setup_roof_crumb();
	thread street_civs_setup();
	
	// setup sniper location hint lights
	roof_hint_pos = GetEntArray("roof_flashing_light", "targetname");
	if(Isdefined(roof_hint_pos))
	{
		for(i=0;i<roof_hint_pos.size; i++)
		{
			red_hint_fx = spawnfx( level._effect["science_building_light01"], roof_hint_pos[i].origin );
			triggerfx( red_hint_fx );
		}
	}	
		
	//Start Low Key Sniper Music - Added by crussom
	level notify("playmusicpackage_sniper1");
	
	//// play intro cutscene. ////////////////////////////////////

	//// NOW IN _LOADOUT
	//level.player GiveWeapon("WA2000_intro");
	//level.player switchToWeapon("WA2000_intro");
	//wait(0.5);
	
	level.player freezecontrols( true );
	wait(0.05);
	sf_start_minigame( "scope" );
	playcutscene("Dim_steps", "intro_cutscene_done");
	level thread display_chyron();
	

	// AE: 7/2/08: bug fix (11636) make the hud go away during the cutscene, this HAS to happen after the playcutscene call
	//setSavedDvar("cg_drawHUD", "0"); // clears everything, even the sniper scope overlay
	setdvar("ui_hud_showstanceicon", "0");
	setsaveddvar("ammocounterhide", "1");
	// the wait seems to be messing things up here, the sound goes out and sometimes the scope overlay goes out
	wait(0.05);
	setsaveddvar("cg_drawBreathHint", "0"); // waiting on steve
	setsaveddvar("cg_disableBackButton", "1"); // freeze controls should do this

	//SOUND - Shawn J - 8/12/08 commented out - now notetracked
	//thread play_intro_dialog();

	level waittill("intro_cutscene_done");	
	

	////////////////////////////////////////////////////////////// 

	// AE 7/1/08: check for the challenge achievement (kill all snipers with 1 shot)

	// turn on lasers for snipers.
	setDVar( "cg_laserAiOn", 1 );
	
	level.sniper_event = true;
	
	// DCS: added ammo box, no longer needed.
	//thread temporary_infinite_ammo();
	
	
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
				//iprintlnbold("FAILED TO SPAWN AI!");
			}	
		}
	}
		
	// AE 7/7/08: use the custom camera to show the balcony thugs
	level thread show_thugs(balcony_thug);
	level waittill("thug_camera_done");
	
	// switch to the usable weapon here so that we get a clean camera break after the intro
	level.player switchToWeapon( "wa2000_sca_s" );

	// AE 7/10/08: take the intro weapon here so we can start the custom camera, to show the snipers
	// this gives us a clean break after the cutscene
	level.player takeweapon("WA2000_intro");

	wait(0.1);	
	// AE 7/2/08: bring the hud back
	setdvar("ui_hud_showstanceicon", "1");
	setsaveddvar("ammocounterhide", "0");
	setsaveddvar("cg_drawBreathHint", "1"); // waiting on steve
	setsaveddvar("cg_disableBackButton", "0"); // freeze controls should do this

	setsaveddvar("bg_quick_kill_enabled", false);
	setsaveddvar("melee_enabled", false);	
	level.player freezecontrols( false );
	
	wait(0.05);
	level.balcony_snipers = getentArray ("balcony_thug", "targetname");
	
	thread villiers_sniper_text();
	
	// do a save here so the checkpoint starts the sniper event over again
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
	// do a save here so the checkpoint starts at the next sniper event
	thread maps\_autosave::autosave_now("MiamiScienceCenter");	

}	
setup_roof_crumb()
{
	roof_door_crumb = GetEnt("roof_door_crumb", "script_noteworthy");
	objective1_crumb = GetEnt("objective1_crumb", "script_noteworthy");

	//roof_door_crumb trigger_off();
	
	level waittill("all_snipers_dead");
	objective1_crumb notify("trigger");
	//roof_door_crumb trigger_on();
}

//SOUND - Shawn J - 8/12/08 commented out - now notetracked
//play_intro_dialog()
//{
	// AE 7/1/08 - added vo to the cutscene
	//Shawn J - sound 7/25/08 - commented out waits - timing now controlled from csv - added dimitrios and merc lines
	//wait(17.0);
	//level.player play_dialogue("BOND_SciAC_001A", true); // looks like dimitros
	//wait(0.5);
	//level.player play_dialogue("M_SciAC_002A", true); // do you know who
	//wait(0.5);
	//level.player play_dialogue("BOND_SciAC_003A", true); // not yet
	//wait(0.5);
	//level.player play_dialogue("DIMI_SciAC_801A", true); // when my guest arrives, show him in  no one else gets through
	//level.player play_dialogue("SCDM_SciAC_100A", true); // yes sir
	
//}	
show_thugs(thugs)
{	
	
	level.player customcamera_checkcollisions(0);	// turn off collision
	
	cam_pos = level.player.origin + (0, 0, 72);
	thug1 = thugs[1];
	thug1_pos = spawn( "script_origin", thug1.origin +(0, 0, 52) ); // lookat point instead of feet.
	thug1_pos linkto(thug1);
	
	cameraID = level.player CustomCamera_Push("world", thug1_pos, cam_pos, (0, 0, 0),	0.0);
	thread show_thugs_dialog();
	
	//// need to add adjustments to zoom.
	updateTime = 0.05;
	sniperFov = 5.0;
	level.player customcamera_setFov( cameraID, sniperFov, updateTime, 0.0, 0.0 );

	wait(2.0);
	
	thug2 = thugs[2];
	thug2_pos = spawn( "script_origin", thug2.origin +(0, 0, 52) ); // lookat point instead of feet.
	thug2_pos linkto(thug2);
	level.player customcamera_change( CameraID, "world", thug2_pos, cam_pos, (0, 0, 0), 2.0 );

	updateTime = 0.5;
	sniperFov = 8.0;
	level.player customcamera_setFov( cameraID, sniperFov, updateTime, 0.0, 0.0 );

	wait( 4.0 );

	thug0 = thugs[0];
	thug0_pos = spawn( "script_origin", thug0.origin +(0, 0, 52) ); // lookat point instead of feet.
	thug0_pos linkto(thug0);
	level.player customcamera_change( CameraID, "world", thug0_pos, cam_pos, (0, 0, 0), 2.0 );
	
	updateTime = 1.0;
	sniperFov = 20.0;
	level.player customcamera_setFov( cameraID, sniperFov, updateTime, 0.0, 0.0 );
	
	wait( 3.0 );

	level.player CustomCamera_Pop( cameraID, 1.0 );
	wait(1.0);

	level.player customcamera_checkcollisions(1);	// turn on collision
	thread sparking_busted_panel();

	level notify("thug_camera_done");
	
	// setup car alarm triggers.
	thread setup_car_alarms();
}
show_thugs_dialog()
{
	level.player play_dialogue("BOND_SciAC_004A", true); // he's got three lookouts
	wait(0.5);
	level.player play_dialogue("M_SciAC_007A", true); // you're in miami
	wait(1.0);
	level.player play_dialogue("BOND_SciAC_008A", true); // then i'll have to move
}
balcony_shootat_bond()
{
	self endon("death");
	
	if( self getalertstate() != "alert_red" )
	{
		self waittill( "start_propagation" );
	}
	
	if(	level.alarm_triggered == true) return; // already shooting at bond at higher rate.
		
	self setalertstatemin("alert_red");	
	self setperfectsense(true);
	self addengagerule("tgtperceive");
	
	//iprintlnbold("thug should shoot back!");

	while(IsDefined(self))
	{
		xtime = randomfloatrange( 1.0, 2.5 );
		self cmdshootatentityxtimes( level.player, false, 2, 0.8 );		
		self cmdaimatentity( level.player, false, -1);

		wait( xtime );
		self stopallcmds();
	}
}
villiers_sniper_text()
{
	// AE 7/1/08 - added vo, took out printing text to screen

	wait(2.0);
	//thread dialog_placeholder("Villiers: Bond, there are 3 snipers on the Balcony of the Science Center.");
	//iprintlnbold("Villiers: Bond, there are 3 snipers on the Balcony of the Science Center.");
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
	//thread dialog_placeholder("Villiers: There are more snipers on the roof.");
	//iprintlnbold("Villiers: There are more snipers on the roof.");
	
	level notify("obj_1_modified");

	wait(1.0);
	//thread dialog_placeholder("See if you can find a higher vantage point.");
	//iprintlnbold("See if you can find a higher vantage point.");
}	

roof_sniper_setup()
{
	
	roof_sniper_spawner = getent("roof_sniper_front", "targetname");
	edge_node = getnode( "roof_sniper_edgenode", "targetname" );
	
	roof_sniper_spawner_L = getent("roof_sniper_left", "targetname");
	edge_node_L = getnode( "roof_sniper_edgenode_L", "targetname" );

	roof_sniper_spawner_R = getent("roof_sniper_right", "targetname");
	edge_node_R = getnode( "roof_sniper_edgenode_R", "targetname" );
	

	//// they don't start shooting immediately unless alerted, no longer need to wait.
	//in_sign_trig = getent("in_sign_trigger", "targetname");
	//in_sign_trig waittill("trigger");

	//Start Higer IntensitySniper Music - Added by crussom
	level notify("playmusicpackage_sniper2");

	// AE 7/1/08: added vo, took out printing text to screen
	// AE 7/10/08: changed this event to have all of the snipers spawn at once
	//the reason is so that once bond shots, the others will know where he is and start shooting



	// spawn all snipers
	roof_sniper_front = roof_sniper_spawner StalingradSpawn();
	roof_sniper_left = roof_sniper_spawner_L StalingradSpawn();
	roof_sniper_right = roof_sniper_spawner_R StalingradSpawn();
	
	if(	level.alarm_triggered == true)
	{
		// Put into immediate alert.
		roof_sniper_front thread alarm_shoot_bond(edge_node);
		roof_sniper_left thread alarm_shoot_bond(edge_node_L);
		roof_sniper_right thread alarm_shoot_bond(edge_node_R);
	}
	else
	{
		// setup roof snipers.
		roof_sniper_front thread sniper_shootat_bond(edge_node);
		roof_sniper_left thread sniper_shootat_bond(edge_node_L);
		roof_sniper_right thread sniper_shootat_bond(edge_node_R);
	}	
	
	
	level.player thread check_snipers(roof_sniper_front, roof_sniper_left, roof_sniper_right);

	level waittill("all_snipers_dead");

	// play the finish vo		
	level.player play_dialogue("TANN_SciAG_013A", true); // thats all of them
	
	level.sniper_event = false;

	thread exit_roof_setup();
}
sniper_shootat_bond(node)
{
	self endon("death");
	
	// have the ai run to the passed in node
	self SetScriptSpeed("Run");
	self setgoalnode(node);
	self waittill("goal");
	self SetScriptSpeed("default");
	
	if( self getalertstate() != "alert_red" )
	{
		self waittill( "start_propagation" );
	}

	// wait for one to become alerted and wake them all up.
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
		// while the player is in the sign, we have to wait until he shoots for the ai to know where he is
		if(level.in_sign)
		{
			// keep shooting at the player
		xtime = randomfloatrange( 1.0, 2.5 );
			self cmdshootatentityxtimes(level.player, false, 1, 0.5);		
			self cmdaimatentity(level.player, false, -1);

			wait(xtime);
			self stopallcmds();
		}
		// if the player is outside of the sign then he's fair game
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
// Is the player inside the billboard while sniper is alive.	
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
// check to see if the sniper is alive, play vo where necessary
check_snipers(sniper1, sniper2, sniper3)
{
	self endon("death");

	// play the first vo
	thread play_roof_intro_dialog();
	
	playedVO2 = false;
	playedVO3 = false;
	while(isalive(sniper1) || isalive(sniper2) || isalive(sniper3))
	{
		// once the first sniper is killed, if the second is still alive then play vo
		if(!isalive(sniper1) && isalive(sniper2) && !playedVO2)
		{
			// play the second vo		
			level.player play_dialogue("TANN_SciAG_011A", true); // there's a second
			playedVO2 = true;
		}

		// once the first and second sniper is killed, if the third is still alive then play vo
		if(!isalive(sniper1) && !isalive(sniper2) && isalive(sniper3) && !playedVO3)
		{
			// play the third vo		
			level.player play_dialogue("TANN_SciAG_012A", true); // one more
			playedVO3 = true;
		}
		wait(0.05);
	}
	level notify("all_snipers_dead");
	level.all_snipers_dead = true;
}
play_roof_intro_dialog()
{
	level.player play_dialogue("TANN_SciAG_009A", true); //
	level.player play_dialogue("TANN_SciAG_010A", true); // your first target
}	
exit_roof_setup()
{
	//Start Stealth Music - Added by crussom
	level notify("playmusicpackage_alley");
	
	roof_exit = getent("sniper_roof_exit", "targetname");
	if(IsDefined(roof_exit))
	{
		roof_exit waittill("trigger");
		
		//disable ADS zoom
		level.no_zoom = 1;
		
		thread sniper_event_end_cinematic();
	
	}	
}	
// AE: the slats can take damage, when they do, they fall
take_damage()
{
	// random health.
	self setcandamage(true);
	strength = randomintrange(100, 200);
	self.health = strength;
	
	self waittill("damage");
	
	// tell it to stop rotating
	self.moving = false;
	
	//// DCS: caused show stopper bugs, could trap or kill player.
	//// Will now just stick open like the original broken slat.
	
	// randomly break out slat or random sticking angles.
	t = randomint(4);
	if(t == 2)
	{
		p = randomfloatrange(-7, 7);
		self rotatepitch(p, 1.0);
	}
	else
	{
		//random sticking angles
		y = randomfloatrange(45, 135);
		self RotateTo((0, y, 0), 1.0);
	}
	wait(1.1);
	
	while( level.sniper_event == true)
	{
		sparks = playfx( level._effect[ "electric_sparks" ], self.origin );
		//self playsound("sparks");
				
		self rotateYaw(5,0.2);
		wait(0.25);
		self rotateYaw(-5,0.2);
		wait(0.7);
	}	
	
/*
	// make it fall
	//iprintlnbold("angles: " + self.angles[0] + " " + self.angles[1] + " " + self.angles[2]);
	force_vec = (0, 100, 0);
	self physicslaunch(self.origin, force_vec);
*/

}

////////////////////////////////////////////////////////////////////////////////////
temporary_infinite_ammo()
{
	level.player endon("death");
	
	while (level.sniper_event == true)
	{
		// AE 7/1/08: added the ammo stock check so that we can check the shot bullets to see if we got the achievement
		// so we're giving max ammo when the user runs out
		clipCount = level.player GetWeaponAmmoStock("wa2000_sca");
		if(clipCount <= 0)
			level.player givemaxammo("wa2000_sca");
		wait(0.5);
	}
}
////////////////////////////////////////////////////////////////////////////////////

//// cinematic event to have bond cross street after entering roof stairwell.
sniper_event_end_cinematic()
{
	// AE 7/10/08: tell threads to stop by sending this notify
	level notify("end_sniper_event");

	level.player freezecontrols( true );
	forcephoneactive( false ); 
	
	//DCS: deleting exiting traffic. scene should have player across road before another could come.
	//level notify ( "enter_back_lot" );
	level notify("delete_current_traffic");

	if(level.ps3)
	{
		visionSetNaked( "sciencecenter_a_alley_ps3", 1.0 ); 
	}
	else
	{		
		visionSetNaked( "science_center_a_alley", 1.0 ); 
	}
	// clean up street civilian ai.
	street_civ = getentArray ( "street_civ", "targetname" );
	for(i=0;i<street_civ.size; i++)
	{
		street_civ[i] delete();
	}

	// turn off lasers for snipers.
	setDVar( "cg_laserAiOn", 0 );
	
	// -------- START ALLEY FUNCTIONS -------
	level thread maps\sciencecenter_a_alley::alley_main();
	level notify("alley_trash_nonlooping_start");
	// --------------------------------------

	level.player GiveWeapon("p99_wet_s");
	level.player switchToWeapon( "p99_wet_s" );
	level.player takeweapon("wa2000_sca_s");

	
	wait(0.05);
	playcutscene("SCA_BOND_Street_Cross","cutscene_done");
	level notify("ledge_pigeons"); //CG - trigger the pigeons near the garbage can (the ledge is out of frame).
	level waittill("cutscene_done");
	level notify("street_crossing_done");

	thread alley_dumpster_cover();
	wait(0.5);
	level.crossed_street = true; 
	
	thread objective_02();
	thread maps\_autosave::autosave_now("MiamiScienceCenter");
}

alley_dumpster_cover()
{
	level.player endon("death");

	new_player_pos = getent ("event2_player", "targetname");
	level.player setorigin( new_player_pos.origin + (0, -5, -8));
	level.player setplayerangles((new_player_pos.angles));
	level.player freezecontrols( false );
	
	//level.dumpster_trig = getent ("alley_force_cover", "targetname");
	//level.dumpster_trig waittill("trigger");
	//while(level.player IsTouching(level.dumpster_trig) && level.crossed_street == false)

	while(level.crossed_street == false)
	{
		//iprintlnbold("player should be in cover");
		level.player playerSetForceCover( true, (0, 0, 0), true, true );
		wait(0.05);
	}	
	//level.dumpster_trig delete();
	level.player playerSetForceCover(false, false);
}	
////////////////////////////////////////////////////////////////////////////////////
rotating_billboard_setup()
{
	self endon("end_sniper_event");

	// AE 7/7/08: made billboard_rotating a global so we can mess with it outside of here
	level.billboard_rotating = GetEntArray("billboard_rotating01", "targetname");
	level.billboard_moving = true;

	for(i = 0; i < level.billboard_rotating.size; i++)
	{
		if(isdefined(level.billboard_rotating[i]))
		{
			level.billboard_rotating[i].moving = true;

			//// DCS: moved to setup, doesn't make sense that they can only be damaged after first event.
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

		//// billboard freezes open for a second.
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

////////////////////////////////////////////////////////////////////////////////////
//                    MISC.                
////////////////////////////////////////////////////////////////////////////////////

enable_camera_hack()
{
	self waittill( "damage" );
	
	entBox = GetEnt( self.target, "targetname" );
	
	entBox notify( entBox.script_alert );
}

////////////////////////////////////////////////////////////////////////////////////
//                    END LEVEL TRIGGER                
////////////////////////////////////////////////////////////////////////////////////
roof_end_level()
{
	level waittill( "end_science_center_a" );

	//changelevel( "sciencecenter_b", true );
	maps\_endmission::nextmission();
}

////////////////////////////////////////////////////////////////////////////////////
//                    FORESHADOW HELICOPTER                
////////////////////////////////////////////////////////////////////////////////////
#using_animtree("vehicles");
sniper_heli_flyby()
{
	// spawn heli
	heli_flyby = getent( "sniper_heli_flyby1", "targetname" );
	heli = spawnvehicle( "v_heli_sca_red", "helicopter", "blackhawk", (heli_flyby.origin), (heli_flyby.angles) );

	// setup params
	heli.health = 100000;
	heli setspeed( 50, 40 );

	// setup anims
	heli UseAnimTree( #animtree );
	heli setanim( %bh_rotors );
	
	//iprintlnbold("helicopter flying overhead");

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