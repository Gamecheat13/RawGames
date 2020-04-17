#include maps\_utility;
#include animscripts\shared;
#include maps\_anim;
#using_animtree("generic_human");
//#include maps\_playerawareness;

main()
{
	
	//NEEDS TO BE BEFORE _LOAD
	maps\casino_poison_fx::main();	
	//NEEDS TO BE BEFORE _LOAD
	precachevehicle("defaultvehicle");

	maps\_vsedan::main("v_sedan_luxury_radiant_red");
	maps\_vsedan::main("v_sedan_luxury_radiant_lightblue");
	maps\_vsedan::main("v_sedan_luxury_radiant_silver");
	maps\_vsedan::main("v_sedan_luxury_radiant_pearl");

	precachemodel( "v_sedan_luxury_radiant_red" );
	precachemodel( "v_sedan_luxury_radiant_lightblue" );
	precachemodel( "v_sedan_luxury_radiant_silver" );
	precachemodel( "v_sedan_luxury_radiant_pearl" );
	
	// Define blackout HUD element
	if (!IsDefined(level.hud_black))
	{
		level.hud_black = newHudElem();
		level.hud_black.x = 0;
		level.hud_black.y = 0;
		level.hud_black.horzAlign = "fullscreen";
		level.hud_black.vertAlign = "fullscreen";
		level.hud_black SetShader("black", 640, 480);
		level.hud_black.alpha = 0;
	}


	maps\_load::main();
	
	//Dash disabled for this level
	SetSavedDVar("cover_dash_fromCover_enabled",false);
	SetSavedDVar("cover_dash_from1stperson_enabled",false);
	//SetSavedDVar("cover_hints",false);	//temp script error
	SetDvar("player_sprintEnabled", false);
	
	precacheShader( "compass_map_casino_poison" );
	precache("w_t_sony_phone");

	PrecacheCutScene("BondPoison1");
	PrecacheCutScene("BondPoison_sc2");
	PrecacheCutScene("BP_Stumble_Table_Left");
	PrecacheCutScene("BP_Stumble_Table_Right");
	PrecacheCutScene("BP_Stumble_Rail");
	//PrecacheCutScene("BP_Fight");	//removed

	maps\casino_poison_amb::main();
	maps\casino_poison_mus::main();
	
	//Enable mini-map for test level
	setminimap( "compass_map_casino_poison", 4992.0, 8640.0, 832.0, 576.0 );


	// * Setup Drones * //
	
	//precache to fix variant errors
	character\character_civ_1_poison::precache();
	character\character_civ_2_poison::precache();
	character\character_civ_3_poison::precache();
	character\character_civ_4_poison::precache();
	character\character_civ_5_poison::precache();
	character\character_civ_6_poison::precache();

	character\character_fem_civ_1_poison::precache();
	character\character_fem_civ_2_poison::precache();

	level.drone_spawnFunction["civilian"][0] = character\character_civ_1_poison::main;
	level.drone_spawnFunction["civilian"][1] = character\character_civ_2_poison::main;
	level.drone_spawnFunction["civilian"][2] = character\character_civ_3_poison::main;
	level.drone_spawnFunction["civilian"][3] = character\character_civ_4_poison::main;
	level.drone_spawnFunction["civilian"][4] = character\character_civ_5_poison::main;
	level.drone_spawnFunction["civilian"][5] = character\character_civ_6_poison::main;
	level.drone_spawnFunction["civilian_female"][0] = character\character_fem_civ_1_poison::main;
	level.drone_spawnFunction["civilian_female"][1] = character\character_fem_civ_2_poison::main;
		
	maps\_drones::init();
	
	// for timer
	maps\_utility::timer_init();

	level.privee_civilian_walkers = [];
	level.courtyard_civilian_walkers = [];
	level.anteroom_civilian_walkers = [];	
	level.hallway_civilian_walkers = [];	
	level.lobby_civilian_walkers = [];

	level.someone_talking = false;
	level.lane_1_collision = false;
	level.lane_2_collision = false;

	level.blur_amount = 0;

	setpostfxblendmaterial("passoutfx");
	fov_transition(0);
	fov_transition_speed( 60.0 ); // resets to default of 60.0
	VisionSetNaked( "casino_poison_0", .01 );
	level.currvision = "casino_poison_0";
	SetDVar( "r_motionblur_enable", "0" ); // eliminates global motion blur as double vision is sufficient

	level.skipto = "none";

	//turn off sun for better framerate
	SetDVar("sm_sunShadowEnable", "0" );

	
	//init flag	
	flag_init( "sway_on" );


	///////// EVENT: BEGIN STORY /////////

	level thread setup_bond();

	level thread BEN_time_remaining_debug();

	level.dealer = getent( "dealer", "targetname");  // temp - this is only needed because I'm currently using a thug for the dealer
	level.dealer  lockalertstate( "alert_green" );  // temp - this is only needed because I'm currently using a thug for the dealer

	level.lechiffre = getent( "lechiffre", "targetname" );

	start = GetEnt( "temp_player_position", "targetname" );
	if ( IsDefined( start ) )
	{
		  level.player setorigin( start.origin );
		  level.player setplayerangles( start.angles );
	}

	level thread open_doors();

	if(getdvar( "skipto" ) == "none" || getdvar( "skipto" ) == "")
	{
		
		//wait(0.2); // wait required or else restarting the level will produce a crash.
		//level thread maps\_autosave::autosave_now("casino_poison");
		wait(0.1);
		level thread play_intro_cutscene();

		

		//savegame("casino_poison");
	}

	if(getdvar( "skipto" ) != "artist")
	{

		
		//for debugging	
		if( getdvar( "nopoison" ) != "1")
		{
			level thread double_vision();
			level thread heartbeat_rumble();
			level thread poison_sway();
		}
		
		//wait(.25); //necessary?
		//level thread poison_cycle();

		level thread set_courtyard_walker_trigger();
		level thread set_privee_walker_trigger();
		level thread set_anteroom_walker_trigger();
		level thread set_hallway_walker_trigger();
		level thread set_outdoor_walker_trigger();

		level thread set_courtyard_exit_trigger();
		level thread set_temp_teleport_trigger();
		level thread set_parking_lot_jumped_trigger();
		level thread set_reached_car_trigger();
		//level thread wait_for_player_to_open_door();

		//level thread wait_for_player_to_open_hallway_door();

		level thread set_exit_dining_trigger();
		level thread set_courtyard_entrance_trigger();
		level thread set_corridor_fov_stretch_trigger();
		level thread set_corridor_exit_trigger();

		level thread set_privee_table_stumble_right_trigger();
		level thread set_privee_table_stumble_left_trigger();
		
		
		level thread set_stagger_to_railing_trigger();
		
		level thread set_fall_down_stairs_trigger();
		level thread set_car_block_trigger();

		level thread set_collision_prop_physics_triggers();
		level thread set_mission_abandonment_triggers(); 

		level thread debug_poison_off();
		level thread freeze_player_road();
		//thread test();
		wait(.005);

		skipto();  //DEBUG - add this to the command line in the launcher //// +set skipto alley
	}
	
	
		
}

test()
{
	while(1)
	{
		//iprintlnbold( level.player.health );
		wait(1);
	}
}




camera_cube_test()
{
	//setdvar("com_maxfps", "5");
	//setdvar("fixedtime", "33");
/*
	TONY:  
	1.  Add a Script Origin to your map with a targetname of "camera_location".  
	2.  If you want to eliminate the text in the upper right of the screen 
	You may want to turn off any 3 elements. In the IWLauncher, open up the remote console tab. please type:
		cg_drawFPS 0
		replay_time 0
		on_errormessagetime 0 
	3.  Files are saved on your Xbox in jb/screenshot.  They are named shot0001.tga, with the number incrementing with each shot.
*/
	camera = getent("camera_location", "targetname");
	level.preview_camera = level.player customCamera_Push( "world", camera.origin, (0, 0, 0), .3, 0.35, 0.20);
	wait(2);


	level.player customCamera_change( level.preview_camera, "world", camera.origin, (0, 90, 0) , 1.5, 0.35, 0.20); 
	wait(2);
	screenshot("1");
	wait(1);
	level.player customCamera_change( level.preview_camera, "world", camera.origin, (0, 180, 0) , 1.5, 0.35, 0.20); 
	wait(2);
	screenshot("1");
	wait(1);
	level.player customCamera_change( level.preview_camera, "world", camera.origin, (0, 270, 0) , 1.5, 0.35, 0.20); 
	wait(2);
	screenshot("1");
	wait(1);
	level.player customCamera_change( level.preview_camera, "world", camera.origin, (-90, 270, 0) , 1.5, 0.35, 0.20); 
	wait(2);
	screenshot("1");
	wait(1);
	level.player customCamera_change( level.preview_camera, "world", camera.origin, (90, 270, 0) , 1.5, 0.35, 0.20); 
	wait(2);
	screenshot("1");
	wait(1);
	level.player customCamera_change( level.preview_camera, "world", camera.origin, (0, 0, 0) , 1.5, 0.35, 0.20); 
	wait(2);
	screenshot("1");
	wait(1);
	//iPrintLnBold( "Screenshots complete - tga filename is SHOT");
}


movement_test()
{
	while(1)
	{
		lateral_move = level.player poisonEffectInput( "side" );    //  players last yaw move (-1,1)
		forward_move = level.player poisonEffectInput( "forward" );  //  players last pitch move (-1,1)

		//iPrintLnBold( "Lateral move = "+ lateral_move);
		//iPrintLnBold( "Forward = "+ forward_move);

		wait(.5);
	}

}

//based on turning speed
double_vision()
{
	//poisoneffectsettings( 1.5, 0.3, 0.22, 90.0, 20.0, 0.0 ); // ( <pulse>, <warpX>, <warpY>, <dvisionA>, <dvisionX>, <dvisionY>)"
	//poisoneffect(true);

	double_vision_x = 0;
	double_vision_y = 0;

	current_vision_x = 0;
	current_vision_y = 0;

	recovery_rate = .95; // .92  // how quickly vision gets back to normal.  The lower the value, the faster the recovery.
	blur_rate = .20; // .15  // How sensitive double vision is to controller input.  1 = instant double vision, no build up required
	d_vision_floor = .70;  // ignores turn input that does not exceed this percentage of a full turn

	setDvar("r_poisonFX_dvisionA", "45.0");   // float +/- 0.0 -> 360.0 angle of double vision

	//setDvar("r_poisonFX_dvisionX", ""+ double_vision_x);   // float amount of double vision in x -20.0 -> + 20.0
	//setDvar("r_poisonFX_dvisionY", ""+ double_vision_y);   // float amount of double vision in y -20.0 -> + 20.0

	while(1)
	{
		// read controller input
		yaw_move = level.player poisonEffectInput( "yaw" );    //  players last yaw move (-1,1)
		pitch_move = level.player poisonEffectInput( "pitch" );  //  players last pitch move (-1,1)

		// discard controller input if it is below a minimum floor.  This limits the effect to significant turns and keeps the screen from being blured all the time.
		if (abs(yaw_move) < d_vision_floor)
		{
			yaw_move = 0;
		}


		if (abs(pitch_move) < d_vision_floor)
		{
			pitch_move = 0;
		}


		// calculate the ratio of double vision.  20 is the maximum effect.
		double_vision_x = yaw_move * 20;
		double_vision_y = pitch_move * 20;

		// Apply double vision effect.  Controller input builds over time.  No input causes it to fall off over time.
		if(abs(current_vision_x) < abs(double_vision_x))
		{
			//current_vision_x = double_vision_x;
			current_vision_x = current_vision_x + ((double_vision_x - current_vision_x) * blur_rate);
		}
		else
		{
			current_vision_x = current_vision_x * recovery_rate;
		}


		if(abs(current_vision_y) < abs(double_vision_y))
		{
			current_vision_y = current_vision_y + ((double_vision_y - current_vision_y) * blur_rate);
			//current_vision_y = double_vision_y;
		}
		else
		{
			current_vision_y = current_vision_y * recovery_rate;
		}		

		//setDvar("r_poisonFX_dvisionX", ""+ current_vision_x);   // float amount of double vision in x -20.0 -> + 20.0
		//setDvar("r_poisonFX_dvisionY", ""+ current_vision_y);   // float amount of double vision in y -20.0 -> + 20.0	

		wait(.01);
	}




}

door_test()
{
	door = getnode ("salle_door_node", "targetname");//auto1278
	
	if(isDefined(door))
	{
		door_right = getent ("salle_rest_door_right", "targetname");
		door_left = getent ("salle_rest_door_left", "targetname");
	
		door_right._doors_auto_close = false;
		door_left._doors_auto_close = false;	
		
		
		door maps\_doors::open_door_from_door_node();	
		//iPrintLnBold( "Opened Door");

		wait(10);
		
		door_right._doors_auto_close = true;
		door_left._doors_auto_close = true;	
	
		//iPrintLnBold( "Closed Door");	
		door maps\_doors::close_door_from_door_node();
		
		
		
		
	
	/*
	
		// keep doors from auto-closing	
		door_ents = getentarray (door.targetname, "target");	
		for( i = 0; i < door_ents.size; i++ )
		{
			door_ents[i]._doors_auto_close = false;
		}	

		// open the doors for the camera
		door maps\_doors::open_door_from_door_node();	
		iPrintLnBold( "Opened Door");

		wait(10);
		
		for( i = 0; i < door_ents.size; i++ )
		{
			door_ents[i]._doors_auto_close = true;
		}	
		iPrintLnBold( "Closed Door");	
		door maps\_doors::close_door_from_door_node(1);
		*/
	}
	else
	{
		//iPrintLnBold( "Door not defined");
	}



	
	//if(isDefined(door))
	//{
	//	level.doors[i]._doors_auto_close = true;
	//}
}


skipto()  //TEMP:this is only used for debugging
{
	level.skipto = getdvar( "skipto" );

	if (level.skipto == ( "courtyard" ) )
	{
		checkpoint = getent ( "courtyard_warp_point", "targetname" );
		level.player setorigin ( checkpoint.origin);
		level.player setplayerangles( checkpoint.angles );
	}
	else if (level.skipto == ( "hallway" ) )
	{
		checkpoint = getent ( "hallway_warp_point", "targetname" );
		level.player setorigin ( checkpoint.origin);
		level.player setplayerangles( checkpoint.angles );

		level.stage = 2;
	}
	else if (level.skipto == ( "lobby" ) )
	{
		checkpoint = getent ( "lobby_warp_point", "targetname" );
		level.player setorigin ( checkpoint.origin);
		level.player setplayerangles( checkpoint.angles );

		//level thread activate_traffic_lane_2();

		level.stage = 2;
	}
	else if (level.skipto == ( "street" ) )
	{
		checkpoint = getent ( "temp_teleport_destination", "targetname" );
		level.player setorigin ( checkpoint.origin);
		level.player setplayerangles( checkpoint.angles );

		level thread activate_traffic_lane_2();
		level thread activate_traffic_lane_1();


		level.stage = 3;
	}
	else if (level.skipto == ( "fight" ) )
	{
		checkpoint = getent ( "player_jumped_position", "targetname" );
		level.player setorigin ( checkpoint.origin);
		level.player setplayerangles( checkpoint.angles );
	}
	else if (level.skipto == ( "end" ) )
	{
		checkpoint = getent ( "car_warp_point", "targetname" );
		level.player setorigin ( checkpoint.origin);
		level.player setplayerangles( checkpoint.angles );

		level.stage = 4;
	}
}

/*
poison_effects()
{
	poisoneffectsettings( 1.5, 0.3, 0.22, 0.0, 0.0, 0.0 ); // ( <pulse>, <warpX>, <warpY>, <dvisionA>, <dvisionX>, <dvisionY>)"
	poisoneffect(true);
}
*/
/*
revive_test()
{
	level.attack_time = 1;

	while(1)
	{
		VisionSetNaked( "casino_poison_2", level.attack_time );
		//setblur( 2, level.attack_time );
		//earthquake (.15, level.attack_time * 3, level.player.origin, 1000);
		wait(level.attack_time*2);

		VisionSetNaked( "casino_poison_1", level.attack_time );
		//setblur( 0, level.attack_time * 2 );
		wait(level.attack_time * 2);
	}

}
*/

/*
fov_test()
{
	while(true)
	{
		iPrintLnBold( "FOV 30");  // default 4 second transition
		fov_transition(30);
		wait(4);

		iPrintLnBold( "FOV 130");
		fov_transition(130);
		wait(8);



		//iPrintLnBold( "FOV 0");
		//fov_transition(65);
		//wait(5);
	}
}
*/
/*
heat_distortion_test()
{
	//poison_heat_distortion is a one-shot effect
	//poison_heat_distortion2 is a looping effect

	//playfx (level._effect["poison_heat_distortion2"], level.player.origin +(0, -25, 60));
	//while(1)
	//{
	//	playfx (level._effect["poison_heat_distortion"], level.player.origin +(0, -25, 60));
	//	wait(8);
	//}

	test_ent = GetEnt( "heat_shimmer", "targetname" );
	//visible_ent = GetEnt( "heat_shimmer2", "targetname" );
	//test_ent moveto( level.player.origin +(0, -25, 60), 0.25 );

	//wait(.5);

	playfxontag (level._effect["poison_heat_distortion2"], test_ent, "tag_origin");
	//playfx (level._effect["poison_heat_distortion2"], test_ent.origin);
	//playfxontag (level._effect["science_lightbeam04"], test_ent, "tag_origin");

	while(1)
	{
		view_origin = level.player getViewOrigin();
		view_angles = level.player getViewAngles();

		forward = anglesToForward(view_angles);

		test_ent moveto( view_origin + (forward * 20), 0.25 );
		//visible_ent moveto( test_ent.origin, 0.25 );
		//playfx (level._effect["poison_heat_distortion"], test_ent.origin);

		wait(.01);
	}

}
*/

setup_bond()
{
	//setSavedDvar("cg_drawHUD","0");

	level.player allowcrouch(false);
	level.player allowjump(false);
	level.player allowProne( false );

	maps\_phone::setup_phone();
	//take away phone menu
	wait(0.05);
	setSavedDvar("cg_disableBackButton","1"); // disable
	//level.player.health = 100;
	
	
}

/*
place_le_chiffre()
{
	spawner = getent( "lechiffre", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "No Spawner!" );
		return;
	}

	level.le_chiffre = spawner stalingradspawn();

	if ( spawn_failed(level.le_chiffre) )
	{
		return;
	}

	level.le_chiffre  lockalertstate( "alert_green" );

	level.le_chiffre.targetname = "lechiffre";

	//level.privee_civilian_walkers[i] SetEnableSense( false );

	//while(1)
	//{
	//	level.le_chiffre CmdPlayAnim( "Gen_Civs_SeatedHeadTurn", false );
		//print3d (level.le_chiffre.origin + (0,0,70), "Sitting head turn", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale
	//	level.le_chiffre waittill("cmd_done");				
	//}
}


place_dealer()
{
	spawner = getent( "dealer", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "No Spawner!" );
		return;
	}

	level.dealer = spawner stalingradspawn();

	if ( spawn_failed(level.dealer) )
	{
		return;
	}

	level.dealer  lockalertstate( "alert_green" );

	level.dealer.targetname = "dealer";
}
*/
/*
drain_player_health()
{
	level endon ("kill_timer");

	while(level.player.health >2)
	{
		//level.player dodamage( 4, (0,0,0) );
		level.player.health = level.player.health - 1;
		wait(1);
	}
	wait(10);
	
	level.player dodamage( 4, (0,0,0) );
}
*/

heartbeat_rumble()
{
	//playing thru
	if(getdvar( "skipto" ) == "none" || getdvar( "skipto" ) == "")
	{
		level waittill("intro_cutscene_2_done"); 
	}
	
	level.stage = 1;  // changes when player enters checkpoint triggers

	level.passout_active = false;  // keeps heartbeat pulses from overriding blackout vision sets
	
	if (isdefined(level.current_time))
	{
		level.time_remaining = level.current_time + 1;
		//iprintlnbold("timer = timer time");
	}
	else
	{
		timeRemaining = 42;
		switch(getdifficulty())
		{
			case "Civilian": 
				timeRemaining = 52;
				break;
			case "New Recruit":
				timeRemaining = 42;
				break;
			case "Agent":
				timeRemaining = 32;
				break;
			case "Double-Oh":
				timeRemaining = 27;
				break;			
		}

		level.time_remaining = timeRemaining;  // initial time to reach courtyard
		//iprintlnbold("timer = 45");
	}

	//level thread poison_timer();

	//poisoneffectsettings( 0.5, 0.3, 0.22, 0.0, 0.0, 0.0 ); // ( <pulse>, <warpX>, <warpY>, <dvisionA>, <dvisionX>, <dvisionY>)"
	//poisoneffect(true);

	// small heartbeat every second
	//Breathing calls added by Bryan Pearson & Shawn J
	skipBreathing = 0;
	while(level.stage == 1)
	{
		if(level.passout_active == false)
		{
			level.player PlayRumbleOnEntity( "movebody_rumble" );
			level.player playsound( "CASP_poison_pulse_A" );
			
			if ( !skipBreathing )
			{
				level.player playsound( "CASP_poison_breathe_A" );
			}
			skipBreathing++;
			if ( skipBreathing > 1 )
			{
				skipBreathing = 0;
			}
			
			level thread screen_pulse(1);	
		}
		wait(1.25);
		//wait(4); // temp invert heart rate
	}

	if (level.time_remaining < level.current_time)
	{
		level.time_remaining = level.current_time + 1;
		//iprintlnbold("time remaining: current_time ");

	}
	else
	{
		level.time_remaining = 60;
		//iprintlnbold("time remaining: 60 ");
	}

	// momentary freeze transition
	//iPrintLnBold( "Full Screen Poison Effect");
	//SetSavedDVar( "timescale", "0.1" );
	wait(.3);

	// slower heartbeat every 2 seconds with time slightly slower
	SetSavedDVar( "timescale", ".75" ); // .75

	poisoneffectsettings( 1, 0.3, 0.22, 0.0, 0.0, 0.0 ); // ( <pulse>, <warpX>, <warpY>, <dvisionA>, <dvisionX>, <dvisionY>)"

	while(level.stage == 2)
	{
		if(level.passout_active == false)
		{
			level.player PlayRumbleOnEntity( "damage_light" );
			//Breathing calls added by Bryan Pearson & Shawn J
			level.player playsound( "CASP_poison_pulse_B" );

			if ( !skipBreathing )
			{
				level.player playsound( "CASP_poison_breathe_B" );
			}
			skipBreathing++;
			if ( skipBreathing > 1 )
			{
				skipBreathing = 0;
			}

			level thread screen_pulse(2);
		}
		wait(.75); // 1.5
	}


	if (level.current_time < level.current_time)
	{
		level.time_remaining = level.current_time + 1;
		//iprintlnbold("time remaining: current_time ");
	}
	else
	{
		//iprintlnbold("time remaining: 45 ");
		level.current_time = 45;
	}
	//savegame("casino_poison");	//move to after railing cutscene
	

	// momentary freeze transition - screen effects remain
	//iPrintLnBold( "Full Screen Poison Effect");
	//SetSavedDVar( "timescale", "0.1" );	//too slow
	wait(0.3);

	// slow heartbeat every 4 seconds with time at 50% speed
	//SetSavedDVar( "timescale", ".75" );

	poisoneffectsettings( 1.5, 0.3, 0.22, 0.0, 0.0, 0.0 ); // ( <pulse>, <warpX>, <warpY>, <dvisionA>, <dvisionX>, <dvisionY>)"
	//poisoneffect(true);

	while(level.stage == 3)
	{
		if(level.passout_active == false)
		{
			level.player PlayRumbleOnEntity( "qk_hit" );
			//Breathing calls added by Bryan Pearson & Shawn J
			level.player playsound( "CASP_poison_pulse_C" );

			if ( !skipBreathing )
			{
				level.player playsound( "CASP_poison_breathe_C" );
			}
			skipBreathing++;
			if ( skipBreathing > 2 )
			{
				skipBreathing = 0;
			}

			level thread screen_pulse(3); 
		}
		//wait(2);
		wait(.55); // temp invert heart rate
	}


	// 4th stage will be a mandatory blackout as you approach the car

	// allows timer to shut down normally if it is already engaged - and forces it to shut down if not engaged
	if (level.current_time < level.current_time)
	{
		level.time_remaining = level.current_time + 1;
		//iprintlnbold("time remaining: current_time ");
	}
	else
	{
		level.current_time = 45;
		//iprintlnbold("time remaining: 45 ");
	}
	
	wait(2);
	level notify ("reached_parking_lot"); // shuts down timer
	level notify ("reached_poison_checkpoint");  // reingages heartbeat pulse if player reaches checkpoint
	level.rumble_active = false;
	iprintlnbold("Rumble active false");
	wait(0.1);
	level thread begin_passout();  // starts passout sequence
	level.passout_active = false;
	// start pass out sequence again
	//level thread begin_passout(); //why do this again? -jc




	/*
	level.time_remaining = 2;
	// momentary freeze transition - screen effects remain
	iPrintLnBold( "Full Screen Poison Effect");
	SetSavedDVar( "timescale", "0.1" );
	wait(.3);

	// slow heartbeat every 4 seconds with time at 50% speed
	SetSavedDVar( "timescale", ".5" );


	while(level.player.health > 0)
	{
		level.player PlayRumbleOnEntity( "qk_hit" );
		level thread screen_pulse(4);
		wait(2.5);
	}
	*/
}


poison_timer()
{
	level endon ("reached_parking_lot");

	//while(level.time_remaining > 13)
	//{
	//	if (isdefined(level.timer))
	//	{
	//		if (level.time_remaining < level.current_time)
	//		{
	//			level.time_remaining = level.current_time;
	//		}
	//	}
	//	level.time_remaining = level.time_remaining - 1;
	//	wait(1);
	//	//iprintlnbold("debug spam time remaining: " + level.time_remaining);
	//}

	//level.passout_active = true; // stops heartbeat pulse
	wait(.5);
	level thread begin_passout();  // starts passout sequence
	while(level.current_time > 0)
	{
		//if (isdefined(level.timer))
		//{
		//	if (level.current_time < level.current_time)
		//	{
		//		level.current_time = level.current_time;
		//	}
		//}
		//level.time_remaining = level.time_remaining - 1;	
		//iprintlnbold("debug spam time remaining: " + level.time_remaining);
		wait(1);
	}
	while(level.current_time < 1)  // waits to see if player reaches checkpoint
	{
		wait(.5);
	}

	level notify ("reached_poison_checkpoint");  // reingages heartbeat pulse if player reaches checkpoint
	level.rumble_active = false;
	iprintlnbold("Rumble active false");

	wait(.25);
	//VisionSetNaked( "casino_poison_5", 1 ); // 3

	level.passout_active = false;
	level thread poison_timer();
}

begin_passout()
{
	level.current_time = 1000;
	level thread handleBlackoutVisionSet();
	level thread handleHeartbeatRumble();
	level thread handleDeath();
	level thread passout_rumble();
	level endon ("reached_poison_checkpoint");
	
	// this updates time_remaining, because current_time does not always exist
	//for(;;)
	//{
	//	if (isdefined(level.current_time))
	//	{
	//		if (level.current_time != level.current_time)
	//		{
	//			level.current_time = level.current_time;
	//		}			
	//	}
	//	wait(1);
	//}	
}

handleBlackoutVisionSet()
{
	level endon ("reached_poison_checkpoint");
	for(;;)
	{
		if (level.current_time < 5)
		{
			if (level.fadeoutActive == false)
			{
				VisionSetNaked( "casino_poison_8", 3.0 ); // flythrough black and white
				level.fadeoutActive = true;
			}			
		}
		else
		{
			level.fadeoutActive = false;
		}
		wait(1);
	}
}

handleDeath()
{
	level endon ("reached_poison_checkpoint");
	for(;;)
	{
		//if (isdefined(level.current_time))
		//{
		//	if (level.current_time != level.current_time)
		//	{
		//		level.current_time = level.current_time;
		//	}
		//}
		if (level.current_time <= 1 )
		{
			wait(1);
			//kill player
			level.player dodamage( level.player.health + 1000, level.player.origin );
		}
		wait(1);
	}
}

handleHeartbeatRumble()
{
	level endon ("reached_poison_checkpoint");
	for(;;)
	{
		if (level.current_time < 13)
		{
			if (level.passout_active == false)
			{
				level.passout_active = true;
				level.rumble_active = true;
			}
		}
		else
		{
			level.passout_active = false;
			level.rumble_active = false;
		}
		wait(1);
	}
}

//DEPRECATED_begin_passout()
//{
//	if (isdefined(level.currvision))
//	{
//		VisionSetNaked("casino_poison_0", 0.1);
//		wait(0.1);
//		VisionSetNaked(level.currvision, 1.0);
//	}
//	//for debug
//	if( getdvar( "nofail" ) == "1")
//	{
//		return;	
//	}
//	
//	level endon ("reached_poison_checkpoint");
//	level thread passout_rumble();
//	//iprintlnbold("beginning pass out!");
//	while(level.time_remaining > 13)
//	{
//		if (isdefined(level.current_time))
//		{
//			if (level.time_remaining != level.current_time)
//			{
//				level.time_remaining = level.current_time;
//			}
//		}
//		wait(1);
//	}
//	level.passout_active = true;
//	level.rumble_active = true;
//	
//	//iprintlnbold("pass out imminent (within 13 sec)");
//	blackout_time = 8;
////	VisionSetNaked( "casino_poison_5", blackout_time/2 ); // 3  // darken outer ring
//	//wait(blackout_time);//6
//	while(blackout_time > 0)
//	{
//		if (isdefined(level.current_time))
//		{
//			if (level.time_remaining != level.current_time)
//			{
//				level.time_remaining = level.current_time;
//			}
//		}
//		blackout_time = blackout_time - 1;
//		wait(1);
//	}
//	
////
////	VisionSetNaked( "casino_poison_4", blackout_time ); // 3   // blacking out tunnel vision
////	wait(blackout_time/3);
////	//VisionSetNaked( "casino_poison_2", .3 ); // 3   // go black
//	if (level.time_remaining < 5)
//	{
//		VisionSetNaked( "casino_poison_8", 3.0 ); // flythrough black and white
//	}
//
//	blackout_time = 5;
//	while(blackout_time > 0)
//	{
//		if (isdefined(level.current_time))
//		{
//			if (level.time_remaining != level.current_time)
//			{
//				level.time_remaining = level.current_time;
//			}
//		}
//		blackout_time = blackout_time - 1;
//		wait(1);
//	}
//	//level.rumble_active = false;
//	
//	
//	//missionfailed(); //need to let player know he died which is via bloodbarrel
//	
//	if (level.time_remaining < 1)
//	{
//		//kill player
//		level.player dodamage( level.player.health + 1000, level.player.origin );
//	}
//	else
//	{
//		
//		// oh, we must have reached a checkpoint and not notified ourselves.
//		//level notify("reached_poison_checkpoint");
//		level.passout_active = false;
//		level thread begin_passout();
//		if (isdefined(level.current_time))
//		{
//			if (level.time_remaining != level.current_time)
//			{
//				level.time_remaining = level.current_time;
//			}
//		}
//		//VisionSetSecondary(0);
//	}
//	
//}


passout_rumble()
{
	level endon("reached_poison_checkpoint");
	if (!isdefined(level.rumble_active))
	{
		level.rumble_active = false;

	}	

	level.player PlayRumbleOnEntity( "qk_hit" );
	wait(1.5);

	for(;;)
	{
		while(level.rumble_active == true)
		{

			level.player PlayRumbleOnEntity( "movebody_rumble" ); //"damage_light"  "qk_hit"
			wait(.25);
		}
		wait(0.5);
	}
}



set_courtyard_exit_trigger()
{
  trigger = getent( "courtyard_exit_trigger", "targetname" );
  trigger waittill( "trigger" );

	fov_movement( 1 );	//lerp
  fov_transition(0);
  
}


set_privee_walker_trigger()
{
  trigger = getent( "privee_walker_trigger", "targetname" );
  trigger waittill( "trigger" );

  place_privee_civilian_walkers();
}

set_anteroom_walker_trigger()
{
  trigger = getent( "anteroom_walker_trigger", "targetname" );
  trigger waittill( "trigger" );

  place_anteroom_civilian_walkers();
}


set_courtyard_walker_trigger()
{
  trigger = getent( "courtyard_walker_trigger", "targetname" );
  trigger waittill( "trigger" );
  
    
  if (!level.passout_active)
  {
	  visionsetnaked("casino_poison_0", 0.1);
	  wait(0.1);
  }
  visionsetnaked( "casino_poison_rstrnt" );
  level.currvision = "casino_poison_rstrnt";
 
  place_courtyard_civilian_walkers();
  
  //play anim on piano player
  guy = getent( "piano_guy", "targetname");
  while( isdefined( guy ) )
 	{
  	guy CmdPlayAnim( "Gen_Civs_Piano_Player", false );
  	guy waittill("cmd_done");	
  }
   
}


set_hallway_walker_trigger()
{
  trigger = getent( "hallway_walker_trigger", "targetname" );
  trigger waittill( "trigger" );
  
  if (!level.passout_active)
  {
	  visionsetnaked("casino_poison_0", 0.1);
	  wait(0.1);
  }
  VisionSetNaked( "casino_Poison_hall");
  level.currvision = "casino_Poison_hall";


  level thread place_hallway_civilian_walkers();
  level thread remove_drones();
}


set_outdoor_walker_trigger()
{
  trigger = getent( "outdoor_walker_trigger", "targetname" );
  trigger waittill( "trigger" );
  
  if (!level.passout_active)
  {
	  visionsetnaked("casino_poison_0", 0.1);
	  wait(0.1);
  }
  VisionSetNaked( "casino_poison_exit");
  level.currvision = "casino_poison_exit";

  place_outdoor_civilian_walkers();
  // BEN SEZ FIFTH SAVE HERE, JUST LEFT DOOR TO OUTSIDE
  //temp - move to outside door
  //savegame("casino_poison");
  //level thread maps\_autosave::autosave_now("casino_poison");

	wait(2);
	if (!level.passout_active)
	{
	  visionsetnaked("casino_poison_0", 0.1);
	  wait(0.1);
	}
	VisionSetNaked( "casino_poison_parking");
	level.currvision = "casino_poison_parking";

  
}

//comment out till manny gives us a better one
//changes vision sets
screen_pulse(poison_stage)
{
	
		//visionSetNaked( "casino_poison_0", 1.0 );	//fix bug with black screen

	
//	switch(poison_stage)
//	{
//	case 1:
//		level.attack_time = .25;
//
//		VisionSetNaked( "casino_Poison_1", level.attack_time ); // 2
//		//setblur( 2, level.attack_time );
//		//earthquake (.15, level.attack_time * 3, level.player.origin, 1000);
//		wait(level.attack_time);
//
//		VisionSetNaked( "casino_poison_3", level.attack_time *2 ); // 3
//		//setblur( 0, level.attack_time * 2 );
//		//wait(level.attack_time * 2);
//		break;
//
//	case 2:
//		level.attack_time = .25 * 1.5;
//
//		VisionSetNaked( "casino_poison_1", level.attack_time );
//		//setblur( 2, level.attack_time );
//		//earthquake (.15, level.attack_time * 3, level.player.origin, 1000);
//		wait(level.attack_time);
//
//		VisionSetNaked( "casino_poison_3", level.attack_time *2 );
//		//setblur( 0, level.attack_time * 2 );
//		//wait(level.attack_time * 2);
//		break;
//
//	case 3:
//		level.attack_time = .25 * 2;
//
//		VisionSetNaked( "casino_poison_1", level.attack_time ); // 2
//		//setblur( 2, level.attack_time );
//		//earthquake (.15, level.attack_time * 3, level.player.origin, 1000);
//		wait(level.attack_time);
//
//		VisionSetNaked( "casino_poison_3", level.attack_time *2 ); // 4
//		//setblur( 0, level.attack_time * 2 );
//		//wait(level.attack_time * 2);
//		break;
//
//	case 4:
//		level.attack_time = .25 * 3;
//
//		VisionSetNaked( "casino_poison_1", level.attack_time ); // 2
//		//setblur( 2, level.attack_time );
//		//earthquake (.15, level.attack_time * 3, level.player.origin, 1000);
//		wait(level.attack_time);
//
//		//level.blur_amount = level.blur_amount + .5;
//		//setblur( level.blur_amount, 6 );
//
//		VisionSetNaked( "casino_poison_3", level.attack_time *2 ); // 3
//		//setblur( 0, level.attack_time * 2 );
//		//wait(level.attack_time * 2);
//		break;
//	}
}





set_temp_teleport_trigger()
{
  trigger = getent( "temp_teleport_trigger", "targetname" );
  trigger waittill( "trigger" );

  //temp_teleport_position = getent ( "temp_teleport_destination", "targetname" );
  //level.player setorigin ( temp_teleport_position.origin);
  //level.player setplayerangles( temp_teleport_position.angles );

  level thread activate_traffic_lane_2();
  level thread activate_traffic_lane_1();

}

set_reached_car_trigger()
{
	trigger = getent( "reached_car_trigger", "targetname" );
	trigger waittill( "trigger" );
		
	level notify ("reached_poison_checkpoint");
	level notify ("reached_parking_lot");	
	level.rumble_active = false;
	
	//get rid of timer
	level notify("kill_timer");
	
	//Setsaveddvar( "timescale", "1" );
	
	//reached_get_jumped_melee();
  level notify("fx_DBS_alarm");
  org = getent( "defib", "targetname" );
  org playsound( "CASP_car_alarm_chirp" );
  
  wait(1);

	// Define blackout HUD element
	if (!IsDefined(level.hud_black))
	{
		level.hud_black = newHudElem();
		level.hud_black.x = 0;
		level.hud_black.y = 0;
		level.hud_black.horzAlign = "fullscreen";
		level.hud_black.vertAlign = "fullscreen";
		level.hud_black SetShader("black", 640, 480);
		level.hud_black.alpha = 0;
	}
	
	//no hud
	setSavedDvar("cg_drawHUD","1");	//turn it back on
	setdvar("ui_hud_showstanceicon", "0");
	setsaveddvar ( "ammocounterhide", "1" );
	setdvar("ui_hud_showcompass", "0");
	
	//go black
	level.hud_black fadeOverTime(0.5);
	level.hud_black.alpha = 1;
	wait(.5);
	player_stick( true );
	//player_jumped_position = getent( "player_jumped_position", "targetname" );
	camera_position = getent ( "car_camera_position_1", "targetname" );
	level.sticky_origin moveTo( camera_position.origin, .05);

	// begin cinematic
	//level thread end_defib(); use at beginning
		
//	camera_position = getent ( "car_camera_position_1", "targetname" );
//	camera_target = getent ( "car_camera_target_1", "targetname" );
//	camera_angle = VectorToAngles( camera_target.origin - camera_position.origin); 
//
//	level.preview_camera = level.player customCamera_Push( "world", camera_position.origin, camera_angle, .3, 0.35, 0.00);
//	level.player thread play_dialog("M_CaPoG_191A");
//	wait(5);
////	//VisionSetNaked( "casino_poison_5", 2 );  // darken outer ring
//	VisionSetNaked( "casino_poison_0", 2 );  // darken outer ring
////	wait(5);
////
////	//iPrintLnBold( "Bond starts going in and out of consciousness " );
////	//iPrintLnBold( "Screen cycles in and out of black out" );
////
////	
////
////	//while(1)
////	//{
////		camera_position = getent ( "car_camera_position_2", "targetname" );
////		camera_target = getent ( "car_camera_target_2", "targetname" );
////		camera_angle = VectorToAngles( camera_target.origin - camera_position.origin); 
////		level.player customCamera_change( level.preview_camera, "world", camera_position.origin, camera_angle, 4.0, 0.35, 0.20); 
////
////		//VisionSetNaked( "casino_poison_4", 15 ); // 3   // blacking out tunnel vision
////		wait(3.5);
//		//VisionSetNaked( "casino_poison_5", 2 );  // darken outer ring
//		
//
////		camera_position = getent ( "car_camera_position_3", "targetname" );
////		camera_target = getent ( "car_camera_target_3", "targetname" );
////		camera_angle = VectorToAngles( camera_target.origin - camera_position.origin); 
////		level.player customCamera_change( level.preview_camera, "world", camera_position.origin, camera_angle, 4.0, 0.35, 0.20); 
//		
//		//iPrintLnBold( "Defibrilator slides out" );
//		level notify( "defib_slide" );
//		org = getent( "defib", "targetname" );
// 		org playsound( "CASP_defib" );
//		
//		wait(5);
//				
//		//VisionSetNaked( "casino_poison_4", 15 ); // 3   // blacking out tunnel vision
//		//wait(3.5);
//		//VisionSetNaked( "casino_poison_5", 2 );  // darken outer ring
//		level.player play_dialog("M_CaPoG_193A");
//		level.player play_dialog("M_CaPoG_194A");
//
//		camera_target = getent ( "car_camera_target_4", "targetname" );
//		camera_angle = VectorToAngles( camera_target.origin - camera_position.origin); 
//		level.player customCamera_change( level.preview_camera, "world", camera_position.origin, camera_angle, 4.0, 0.35, 0.20); 
//		//wait(5);
//		//iPrintLnBold( "Power up. Lights blinking" );
//		
//		//iPrintLnBold( "black out" );
//		level thread place_vesper();
//
//		camera_target = getent ( "car_camera_target_5", "targetname" );
//		camera_angle = VectorToAngles( camera_target.origin - camera_position.origin); 
//		level.player customCamera_change( level.preview_camera, "world", camera_position.origin, camera_angle, 4.0, 0.35, 0.20); 
//	
//		//VisionSetNaked( "casino_poison_4", 20 ); // 3   // blacking out tunnel vision
//		wait(4); 
//		//VisionSetNaked( "casino_poison_2", .3 ); // 3   // go black
//
//		//camera_position = getent ( "car_camera_position_1", "targetname" );
//		//camera_target = getent ( "car_camera_target_1", "targetname" );
//		//camera_angle = VectorToAngles( camera_target.origin - camera_position.origin); 
//		//level.player customCamera_change( level.preview_camera, "world", camera_position.origin, camera_angle, 4.0, 0.35, 0.20); 
//		//wait(1.5);
//		//VisionSetNaked( "casino_poison_5", 2 );  // darken outer ring
//		//wait(5);
//	//}
//
//
//
//
//	//iPrintLnBold( "Mission Accomplished" );
	level notify("endmusicpackage");

	new_ending();
	
	//wait(2);
	player_unstick();
	//changelevel( "barge" );
	maps\_endmission::nextmission();

}



end_defib()
{
	defib = getent("defib", "targetname");
	defib_start = getent("defib_start", "targetname");
	
	defib hide();
	
	level waittill( "cam_at_car" );

	defib_start moveto( defib.origin, 1.0 );
	//added by Shawn J
	org = getent( "defib", "targetname" );
  org playsound( "CASP_defib" );
  wait( 2 );
	PlayLoopedFx(level._effect["defibrilator_light"], 0.5, defib.origin+(-0.9,-2.3,1.8));	
}


set_parking_lot_jumped_trigger()
{
//  trigger = getent( "parking_lot_jumped", "targetname" );
//  trigger waittill( "trigger" );
//  
//
//  //reached_get_jumped_melee();
//  level notify("fx_DBS_alarm");
//  org = getent( "defib", "targetname" );
//  org playsound( "CASP_car_alarm_chirp" );
//  
//  
//  wait(3);
//
//  trigger = getent( "reached_car_trigger", "targetname" );
//  trigger notify( "trigger" );
//  //for beta    
//  //changelevel( "barge" );
}


place_vesper()
{
  spawner = getent( "vesper", "targetname");
  if ( !IsDefined( spawner) )
  {
    //iPrintLnBold( "No Spawner!" );
    return;
  }

  level.vesper = spawner stalingradspawn();

  if ( spawn_failed(level.vesper) )
  {
    return;
  }

	level.vesper lockalertstate( "alert_green" );
	level.vesper SetScriptSpeed( "jog" );
	level.vesper gun_remove();
	//level.vesper animscripts\shared::placeWeaponOn( level.vesper.primaryweapon, "none" );	//xxx haxxor to remove weapon

	wait( 4 );
	level.vesper play_dialogue("VESP_CaPoG_195A");


	//vesper_reposition = getent( "vesper_reposition", "targetname");
	//while(1)
	//{
	//	level.vesper.origin = vesper_reposition.origin;
	//	level.vesper.angles = vesper_reposition.angles;
	//	wait(.5);
	//}
}



play_knock_back_animation()
{
    //iprintlnbold ( "Animation - Drink" );
    //iprintlnbold ( "Animation - Chair Exit Stumble" );

	level.player playerAnimScriptEvent("ChairExitStumble");

	// TEMP - MOVEMENT WILL BE CAUSED BY THE ANIMATION
    player_knockback_position = getent ( "player_knockback_position", "targetname" );
	level.sticky_origin moveTo( player_knockback_position.origin, 1);

	wait(1);
}


open_doors()
{
	level.privee_door_node = getnode ("salle_door_node", "targetname");
	
	if(isDefined(level.privee_door_node))
	{
		level.privee_door_right = getent ("salle_rest_door_right", "targetname");
		level.privee_door_left = getent ("salle_rest_door_left", "targetname");
	
		level.privee_door_right._doors_auto_close = false;
		level.privee_door_left._doors_auto_close = false;	
		
		
		level.privee_door_node maps\_doors::open_door_from_door_node();	
		//iPrintLnBold( "Opened Door");
	}
	

	level.hallway_door_node = getnode ("hallway_door_node", "targetname");
	
	if(isDefined(level.hallway_door_node))
	{
		level.hallway_door_right = getent ("hallway_entrance_room_right", "targetname");
		level.hallway_door_left = getent ("hallway_entrance_room_left", "targetname");
	
		level.hallway_door_right._doors_auto_close = false;
		level.hallway_door_left._doors_auto_close = false;	
		
		
		level.hallway_door_node maps\_doors::open_door_from_door_node();	
		//iPrintLnBold( "Opened Door");
	}


	level.lobby_door_node = getnode ("lobby_door_node", "targetname");

	if(isDefined(level.lobby_door_node))
	{
		level.lobby_door_right = getent ("lobby_right", "targetname");
		level.lobby_door_left = getent ("lobby_left", "targetname");

		level.lobby_door_right._doors_auto_close = false;
		level.lobby_door_left._doors_auto_close = false;	


		level.lobby_door_node maps\_doors::open_door_from_door_node();	
		//iPrintLnBold( "Opened Door");
	}
	
}
/*
close_doors()
{
	if(isDefined(level.privee_door_node))
	{
		level.privee_door_right._doors_auto_close = true;
		level.privee_door_left._doors_auto_close = true;	

		//iPrintLnBold( "Closed Door");	
		level.privee_door_node maps\_doors::close_door_from_door_node();
	}
	
	if(isDefined(level.hallway_door_node))
	{
		level.hallway_door_right._doors_auto_close = true;
		level.hallway_door_left._doors_auto_close = true;	

		//iPrintLnBold( "Closed Door");	
		level.hallway_door_node maps\_doors::close_door_from_door_node();
	}	
}	
*/

close_privee_door()
{
	if(isDefined(level.privee_door_node))
	{
		level.privee_door_right._doors_auto_close = true;
		level.privee_door_left._doors_auto_close = true;	

		//iPrintLnBold( "Closed Door");	
		level.privee_door_node maps\_doors::close_door_from_door_node();
	}
}


close_hallway_door()
{
	if(isDefined(level.hallway_door_node))
	{
		level.hallway_door_right._doors_auto_close = true;
		level.hallway_door_left._doors_auto_close = true;	

		//iPrintLnBold( "Closed Door");	
		level.hallway_door_node maps\_doors::close_door_from_door_node();
	}
}


close_lobby_door()
{
	if(isDefined(level.lobby_door_node))
	{
		level.lobby_door_right._doors_auto_close = true;
		level.lobby_door_left._doors_auto_close = true;	

		//iPrintLnBold( "Closed Door");	
		level.lobby_door_node maps\_doors::close_door_from_door_node();
	}
}


play_intro_cutscene()
{
	//screen black
	level.hud_black.alpha = 1;
	
	//hide these icons
	setdvar("ui_hud_showcompass", "0");
	setdvar("ui_hud_showstanceicon", "0");	

	wait (0.05);	//wait frame else letterbox doesn't work

	//dialogue over black screen
	level.player play_dialogue("TANN_CaPoG_701A");
	wait(1); //beat

	// fade up
	level.hud_black fadeOverTime(5);
	level.hud_black.alpha = 0;

	//fade_out_black( fTime, bFreeze, bFadeWait )
	//level thread fade_out_black( 8, false, true );
			
	//letterbox_on( take_weapons, allow_look, time, playerstick )
	level thread letterbox_on();	//works without playerstick, weird rotate happens animation? -jc

	//intro scene	
	playcutscene("BondPoison1","intro_cutscene_1_done");
	level thread intro_dialog();

	//wait(1);  // NOTIFY NEEDED - should be waiting for a notify from the scene animation when the camera points to the dealer
	
	VisionSetNaked( "casino_poison_7", 3.0 ); // depth of field - defocuses everything but the dealer
	level.currvision = "casino_poison_7";
	
	wait(1);
	
	//iPrintLnBold( "Play Dealer VO" );

	wait(1.0);  // NOTIFY NEEDED - should be waiting for a notify from the scene animation when the camera points to the drink
	
	fov_transition(25);
	
	wait(1.5);
	
	//iPrintLnBold( "Play Le Chiffre VO" );
	level notify("lechiffe_talk" );
	fov_transition(40);

	wait(1.0);  // NOTIFY NEEDED - should be waiting for a notify from the scene animation when the camera points to LeChiffre
	
	// poison warp effect plays
	VisionSetNaked( "casino_poison_0", 1.0 ); // returns to normal focus - so we can warp screen
	level.currvision = "casino_poison_0";
	level thread begin_passout();

	wait(1.5);  // NOTIFY NEEDED - should be waiting for a notify from the scene animation when the camera returns to drink
	
	fov_transition(25);
	poisoneffectsettings( 1.0, 0.3, 0.22, 0.0, 0.0, 0.0 ); // ( <pulse>, <warpX>, <warpY>, <dvisionA>, <dvisionX>, <dvisionY>)"
	poisoneffect(true);
	level.player PlaySound("CASP_PoisonHit");

	wait(2);
	//iPrintLnBold( "Play M VO" );
	//wait(2);	
	fov_transition(0);

	level waittill("intro_cutscene_1_done"); // NOTIFY
	
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );
	wait(0.6);
	
	VisionSetNaked( "casino_poison_0", 1.0 ); // returns to normal focus - so we can warp screen
	level.currvision = "casino_poison_0";
	//VisionSetNaked( "casino_poison_8", 1.0 ); // flythrough black and white
	poisoneffect(false);	//no poison effect on cam flythrough
	player_stick( false );
	
	level.player PlaySound("CASP_Flythrough");
	level thread end_defib();
	
	//fix guys during camera flythru
	level.dealer thread intro_anims();
	level.lechiffre thread intro_anims();
	
	activate_preview_camera();
	
	level notify ("preview_cam_done");

	player_unstick();
	
	wait(0.05);
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );
	wait(0.5);
	
	playcutscene( "BondPoison_sc2","intro_cutscene_2_done");

	level thread intro_spill();

	//level.player thread play_dialog("BOND_CaPoG_03A");

	//3rd person should be no fx
	wait(0.1);// to hide pop
	VisionSetNaked( "casino_poison_0", 1.0 ); // returns to normal focus - so we can warp screen
	level.currvision = "casino_poison_0";

	level waittill("intro_cutscene_2_done");
	
//	//play lechiffre idle anim
//	level thread intro_lechiffre();
		
	poisoneffect(true);	

	letterbox_off();
	
	

/////////// TEMP WARP-TO TO KEEP THE PLAYER FROM BEING STUCK INTO A TABLE /////////////
//	iPrintLnBold( "BUG - Cut scene leave you stuck in a table" );
//	//wait(2);
//	temp_reposition = getent ( "player_knockback_position", "targetname" );
//	level.player setorigin( temp_reposition.origin );
//	level.player setplayerangles( temp_reposition.angles );
//////////////////////////////////////////////////////////////////

	
	//start sway
	flag_set( "sway_on" );
	
	//start music
	level notify( "playmusicpackage_start" );
	
	//start curtain in lobby
	level notify( "curtain_1_start" );	//start curtain fx
		
	//no hud
	//setSavedDvar("cg_drawHUD","0");
	setdvar("ui_hud_showcompass", "1");
	setdvar("ui_hud_showstanceicon", "0");
	//setsaveddvar ( "ammocounterhide", "1" );

	// BEN SEZ FIRST SAVE
	//level thread maps\_autosave::autosave_now("casino_poison");
	savegame("casino_poison");	//only using to fix bug with anim cmd not saving -jc
	level thread poisonTimer_SetDiff( 45, 35, 30, 25);	
	
	objective_add( 1, "active", &"CASINO_POISON_OBJECTIVE1_HEADER", (0, 0, 0), &"CASINO_POISON_OBJECTIVE1_TEXT");
	if (!level.passout_active)
	{
		visionsetnaked("casino_poison_0", 0.1);
		wait(0.1);
	}
  	visionsetnaked( "casino_poison_salon" );
	level.currvision = "casino_poison_salon";
	
	//play post intro anims
	wait (0.1);	//so save works
	level thread intro_lechiffre();
	level thread intro_dealer();
	
	//no reticle
	setDvar( "cg_disableHudElements", 1 );

}


intro_spill()
{
	
	level.player waittillmatch( "anim_notetrack", "spill_drink");
	level notify("martini_fall_start");	//should be off a notify -jc
	level.player playsound( "CASP_drink_knock" );
	
}

intro_dialog()
{
	
	//level.dealer play_dialogue("DEAL_CaPoG_01A");
	//level.dealer play_dialogue("DEAL_CaPoG_02A");
	level waittill("lechiffe_talk");
	//level.lechiffre play_dialogue("LECH_CaPoG_04A");
	//level.player play_dialogue("M_CaPoG_05A");
	
	level waittill( "cam_at_car" );
	level.player play_dialogue("M_CaPoG_06A");
	level.player play_dialogue("BOND_CaPoG_07A");
	
	level waittill("martini_fall_start");	
	//level.player play_dialogue("BOND_CaPoG_03A");
	wait(3);
	level.player play_dialogue("M_CaPoG_09A");
	
}

intro_anims()
{
	level endon("preview_cam_done ");
	
	while(1)
	{
		self CmdPlayAnim( "Gen_Civs_SeatedPlayingCards_A", false );
	
		self waittill("cmd_done");				
	}
	
}

activate_preview_camera()
{
	level.player customcamera_checkcollisions( 0 );
	 	
	//level.player thread play_dialog("M_CaPoG_09A");

	SetDVar( "r_motionblur_enable", "1" );
	SetDVar( "r_motionblur_maxBlurAmt", "40.0" );
	SetDVar( "r_motionblur_dist", "120.0" );	

	camera_speed = .2;

	camera = getent ( "camera_position_1", "targetname" );

	level.preview_camera = level.player customCamera_Push( "world", camera.origin, camera.angles, camera_speed, 0.35, 0.00);
	wait(camera_speed);
	camera = getent( camera.target, "targetname");

	for(i=1; i<40; i++)
	{
		//level.player customCamera_change( level.preview_camera, "entity", camera, getent( camera.target, "targetname"), (0,0,0), (0,0,0), .5, 0.0, 0.0);
    level.player customCamera_change( level.preview_camera, "world", camera.origin, camera.angles , camera_speed, 0.00, 0.00); 

		//level.sticky_origin moveTo( camera.origin, .5);// temp
		//iprintlnbold ( "Position"+ camera.origin );

		if(i==20) // move player so cars can load in
		{
			teleport_position = getent ( "teleport_for_camera_fly", "targetname" );
			level.sticky_origin moveTo( teleport_position.origin, .5);
		}

		wait(camera_speed);

		//fixes script error because I deleted some origins
		if( isdefined( camera.target ))
		{
			camera = getent( camera.target, "targetname");
		}
		
	}
	
	level notify( "cam_at_car" );

	wait(1);

	//objective_add( 1, "current", "Reach Med-kit" );

	wait(2);


    /////////////////////// REVERSE CAMERA

	camera = getent ( "reverse_camera_position_1", "targetname" );

	level.player customCamera_change( level.preview_camera, "world", camera.origin, camera.angles , camera_speed, 0.00, 0.00); 
	wait(camera_speed);
	camera = getent( camera.target, "targetname");

	return_speed = .05;

	for(i=1; i<39; i++)
	{
        level.player customCamera_change( level.preview_camera, "world", camera.origin, camera.angles , return_speed, 0.00, 0.00); 

		if(i==20) // move player so cars can load in
		{
			player_start_position = getent ( "temp_player_position", "targetname" );
			level.sticky_origin moveTo( player_start_position.origin, .5);
		}

		wait(return_speed);

		//fixes script error because I deleted some origins
		if( isdefined( camera.target ))
		{
			camera = getent( camera.target, "targetname");
		}
		
	}
    ///////////////////////

	//VisionSetNaked( "casino_poison_3", 1.0 );

	//fix player pop before cutscene
//  player_start_position = getent ( "intro_cutscene_target_3", "targetname" );
//	level.player setorigin( player_start_position.origin );
//	level.player setplayerangles( player_start_position.angles );

	camera = getent ( "camera_position_1", "targetname" );
  level.player customCamera_change( level.preview_camera, "world", camera.origin, camera.angles, .1, 0.00, 0.00); 

	wait(.3);

	//start = GetEnt( "temp_player_position", "targetname" );
	//level.player setplayerangles( start.angles );

	level.player PlayRumbleOnEntity( "grenade_rumble" );  // damage_heavy
	level.player customCamera_pop( level.preview_camera, 0.0, 0.35, 0.5);
	level.player customcamera_checkcollisions( 1 );
}

//anim for lechiffre after cutscene
intro_lechiffre()
{
	
	level.lechiffre stopallcmds();
	level.lechiffre CmdPlayAnim( "Gen_Civs_SeatedPlayingCards_A", false );
	
	//to remove gun
	level.lechiffre animscripts\shared::placeWeaponOn( level.lechiffre.primaryweapon, "none" );	//xxx haxxor to remove weapon
	
	while(1)
	{
		level.lechiffre CmdPlayAnim( "Gen_Civs_SeatedPlayingCards_A", false );
		level.lechiffre waittill("cmd_done");				
	}
	
}

//anim for dealer after cutscene
intro_dealer()
{
	
	level.dealer stopallcmds();
	level.dealer CmdPlayAnim( "Gen_Civs_SitConversation_A", false );
	
	//to remove gun
	level.dealer animscripts\shared::placeWeaponOn( level.dealer.primaryweapon, "none" );	//xxx haxxor to remove weapon
	
	while(1)
	{
		level.dealer CmdPlayAnim( "Gen_Civs_SitConversation_A", false );
		level.dealer waittill("cmd_done");				
	}
	
}



set_collision_prop_physics_triggers()
{
	trigs = getentarray( "physics_trigger", "targetname" );
	for( i = 0; i < trigs.size; i++ )
	{
		trigs[i] thread wait_for_collision(); 
	}
}


wait_for_collision()
{
	self waittill( "trigger" );

	if (isdefined(self.target))
	{
		self thread link_trigger_to_dynent();

		while(1)
		{
			physicsExplosionCylinder( level.player.origin, 30, 1, 1.2 );// .5
			//level.player knockback( 2000, self.origin, self);	//replace with camera shake
			x = randomfloatrange( 0.2, 0.4 );
			earthquake ( x, .25, level.player.origin, 1000);

			wait(1.5);

			self waittill( "trigger" );
		}

	}
	else
	{
		physicsExplosionCylinder( level.player.origin, 30, 1, 1.2 );// .5
		//level.player knockback( 2000, self.origin, self);
		earthquake (.5, .75, level.player.origin, 1000);	//replace with camera shake

	}
	//penalty for bumping into stuff
	//level.time_remaining = level.time_remaining - 5;

}


link_trigger_to_dynent()
{
	while(1)
	{
		position = DynEnt_getOrigin(self.target); // Single player only! 
		//print3d (position + (0,0,70), "Physics object", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale
		self.origin = position;
		wait(.25);
	}
}







set_mission_abandonment_triggers()
{
	trigs = getentarray( "death_trigger", "targetname" );
	for( i = 0; i < trigs.size; i++ )
	{
		trigs[i] thread wait_for_mission_abandonment(); 
	}
}


wait_for_mission_abandonment()
{
	self waittill( "trigger" );

	//level.time_remaining = 0;
	level.player dodamage( level.player.health + 1000, level.player.origin );
}


BEN_time_remaining_debug()
{
	for(;;)
	{
		if (isdefined(level.current_time))
		{
			//iprintlnbold("debug spam time remaining: " + level.current_time);
		}
		wait(1);
	}
}


set_privee_table_stumble_right_trigger()
{
	level endon( "table_stumble_left_active" );

	trigger = getent( "privee_table_stumble_right_trigger", "targetname" );
  trigger waittill( "trigger" );
	
	// only have the timer go off if you have enough time for the cutscene
	if ( isdefined( level.current_time ) )
	{ 
		if( level.current_time < 10 )
		{
			return;
		}
	}
	
	//remove drones
  level thread remove_drones();

	//show the scene
	flag_clear( "sway_on" );
	poisoneffect(false);	//poison off for 3rd cutscenes
	
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );
	wait(0.5);
	VisionSetNaked(level.currvision, 0.5);
	//wait(0.5);
	//VisionSetNaked( "default_night", 0.1 );
	level notify ("table_stumble_right_active"); // kills trigger for the left version of the animation

	level notify("table_tip_1_start"); //table tip
	playcutscene("BP_Stumble_Table_Right","table_stumble_right_done");
	time_left = level.current_time;
	level notify("kill_timer");
	//setSavedDvar("cg_drawHUD","0");
	level.player playsound ("CASP_champagne_table");
	
	level waittill("table_stumble_right_done");
	//VisionSetNaked( "casino_poison_0", 1.0 );
	//setSavedDvar("cg_drawHUD","1");
	level thread maps\_utility::timer_start(time_left);
	
	//transition flash
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );
	wait(0.5);
	visionsetnaked( "casino_poison_salon" );
	level.currvision = "casino_poison_salon";

	//poison off for 3rd cutscenes
	poisoneffect(true);	
	flag_set( "sway_on" );

	
}


set_privee_table_stumble_left_trigger()
{
	level endon( "table_stumble_right_active" );

	trigger = getent( "privee_table_stumble_left_trigger", "targetname" );
	trigger waittill( "trigger" );
	// only have the timer go off if you have enough time for the cutscene
	if ( isdefined( level.current_time ) )
	{ 
		if( level.current_time < 10 )
		{
			return;
		}
	}
	
	//remove drones
  level thread remove_drones();

	//show the scene
	flag_clear( "sway_on" );
	poisoneffect(false);	//poison off for 3rd cutscenes
	//VisionSetNaked( "default_night", 0.1 );
	
	level notify ("table_stumble_left_active"); // kills trigger for the right version of the animation

	level notify("table_tip_2_start"); //table tip
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );
	wait(0.5);
	if (!level.passout_active)
	{
	  visionsetnaked("casino_poison_0", 0.1);
	  wait(0.1);
	}
	
	VisionSetNaked(level.currvision, 0.5);
	
	playcutscene("BP_Stumble_Table_Left","table_stumble_left_done");
	//setSavedDvar("cg_drawHUD","0");
	time_left = level.current_time;
	level notify("kill_timer");
	level.player playsound ("CASP_champagne_table_2");
	
	level waittill("table_stumble_left_done");
	//setSavedDvar("cg_drawHUD","1");
	level thread maps\_utility::timer_start(time_left);
	
	//transition flash
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );

	wait(0.5);	
	if (!level.passout_active)
	{
	  visionsetnaked("casino_poison_0", 0.1);
	  wait(0.1);
	}
	visionsetnaked( "casino_poison_salon" );
	level.currvision = "casino_poison_salon";
	poisoneffect(true);
	flag_set( "sway_on" );
}

set_exit_dining_trigger()
{
		trigger = getent( "exit_dining_trigger", "targetname" );
    trigger waittill( "trigger" );
    
    if (!level.passout_active)
	{
	  visionsetnaked("casino_poison_0", 0.1);
	  wait(0.1);
	}
	VisionSetNaked( "casino_poison_atrium");
		level.currvision = "casino_poison_atrium";

    //turn on poison controls -jc 
		//level.player poisonmovements(1);
	
		//cleanup
		level thread close_privee_door(); 
		level thread remove_lechiffre();	//moved here
		level thread remove_dealer();
		level thread remove_privee_civilian_walkers();
		//should delete privee drones here
	    
    //cleanup
    level waittill( "delete_guy" );
      
    //delete pianoguy
    guy = getent( "piano_guy", "targetname");
		guy delete();

}


set_courtyard_entrance_trigger()
{
	trigger = getent( "poison_stage_2_trigger", "targetname" );
  trigger waittill( "trigger" );
	// BEN SEZ SECOND SAVE
	//savegame("casino_poison");
	//level thread maps\_autosave::autosave_now("casino_poison");

	level notify("kill_timer");
	wait(.25);
	level thread maps\_autosave::autosave_now("casino_poison");
	level thread poisonTimer_SetDiff(60, 40, 35, 30 );
	wait(0.1);
	level.stage = 2; // changes poison visual effect and heart-rate frequency
	
	level notify("reached_poison_checkpoint");
	wait(0.1);
	level thread begin_passout();  // starts passout sequence
	level.rumble_active = false;
	level.passout_active = false;
//	level thread close_privee_door(); 
//	level thread remove_lechiffre();	
//	level thread remove_dealer();
    //iprintlnbold ( "FOV stretch" ); // temp - need FOV code functionality

	//fov_transition(30);
	//wait(1);
	// reached atrium, save game, update timer
	fov_transition(130);

	level.player playsound( "stretch_1" );
	SetSavedDVar( "timescale", "0.5" );

	//make it shorter since we're doing this in hallway
	wait( 3 );
	fov_movement( 1 );	//lerp
	//fov_transition(0);
	fov_transition(65);	//manually reset?
	
	level.player playsound( "stretch_2" );
	SetSavedDVar( "timescale", "0.75" );


 
}

set_corridor_fov_stretch_trigger()
{
	trigger = getent( "corridor_fov_stretch_trigger", "targetname" );
  trigger waittill( "trigger" );

	level thread close_hallway_door();
	
	//cleanup
	level thread remove_courtyard_civilian_walkers();
	level thread remove_anteroom_civilian_walkers();
	level notify ("delete_guy" );

	fov_transition(130);
	level.player playsound( "stretch_3" );
	SetSavedDVar( "timescale", "0.5" );


  //iprintlnbold ( "FOV corridor stretch" ); // temp - need FOV code functionality
}

set_corridor_exit_trigger()
{
	trigger = getent( "corridor_exit_trigger", "targetname" );
  trigger waittill( "trigger" );

  fov_movement( 1 );	//lerp
  fov_transition(0);
  level.player playsound( "stretch_4" );
	SetSavedDVar( "timescale", "0.75" );

}


set_stagger_to_railing_trigger()
{
	trigger = getent( "stagger_to_railing_trigger", "targetname" );
  trigger waittill( "trigger" );
	// only have the timer go off if you have enough time for the cutscene
	if (isdefined(level.current_time))
	{
		if( level.current_time < 12)
		{
			// you reached the cutscene, play it and give enough cushion to survive
			level.current_time = 60;
			level.time_remaining = 60;
		}
	}
	
	//so don't die right after cutscene
	level notify ("reached_poison_checkpoint");  // reingages heartbeat pulse if player reaches checkpoint
	wait(0.1);
	
	poisoneffect(false);	//poison off for 3rd cutscenes
	flag_clear( "sway_on" );
	
	//cleanup
	//level thread remove_privee_civilian_walkers();
	//level thread remove_courtyard_civilian_walkers();
	//level thread remove_anteroom_civilian_walkers();
	level thread remove_hallway_civilian_walkers();
	level thread remove_drones();

	//level thread remove_lechiffre();	//why here?
	//level thread remove_dealer();

    //iprintlnbold ( "Animation - Railing Stumble" );
	//level.player playerAnimScriptEvent("RailingStumble");
	level thread letterbox_on();
	level notify( "curtain_2_start" );	//start curtain fx
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );
	wait(0.4);
	visionsetnaked("casino_poison_0", 0.1);
	wait(0.1);
	VisionSetNaked(level.currvision, 0.5);
	playcutscene("BP_Stumble_Rail","stumble_cutscene_done");
	level notify("kill_timer");
	//setSavedDvar("cg_drawHUD","0");
	
	wait(3); //so railing guy isn't in the shot
	level thread lobby_railing_guy();

	level waittill("stumble_cutscene_done");
	//setSavedDvar("cg_drawHUD","1");
	level thread close_lobby_door();
	
	//transition flash
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );
	wait(0.5);
	level notify("kill_timer");
	wait(0.1);
	// insert timer update here
	level thread maps\_autosave::autosave_now("casino_poison");
	level thread poisonTimer_SetDiff( 60, 40, 40, 35 );
	level notify("reached_poison_checkpoint");
	//wait(0.1);
	level thread begin_passout();  // starts passout sequence
	level.rumble_active = false;
	level.passout_active = false;
	//level thread place_lobby_civilian_walkers(); 	//too many models, spawn only what's needed
	
	poisoneffect(true);

	VisionSetNaked( "casino_poison_hall");
	level.currvision = "casino_poison_hall";
		
	letterbox_off();
	
	//no reticle
	setDvar( "cg_disableHudElements", 1 );
	setdvar("ui_hud_showstanceicon", "0");
	flag_set( "sway_on" );
	
	level.stage = 3;

	//objective update
	objective_add( 1, "active", &"CASINO_POISON_OBJECTIVE1_HEADER", (0, 0, 0), &"CASINO_POISON_OBJECTIVE1_TEXT");
	
}



//railing look at car
fov_camera_zoom()
{
	camera_location = getent ( "fov_camera_location", "targetname" );
	camera_target = getent ( "fov_camera_target", "targetname" );

	if ( !IsDefined( camera_location.origin) )
	{
		//iPrintLnBold( "Camera location not defined" );
		wait(3);
	}

	if ( !IsDefined( camera_location.angles) )
	{
		//iPrintLnBold( "Camera location not defined" );
		wait(3);
	}
	camera_angle = VectorToAngles( camera_target.origin - camera_location.origin);      // don't forget to compute from the head, not the feet

	if ( !IsDefined( camera_angle) )
	{
		//iPrintLnBold( "Camera angle not defined" );
	}

	fov_camera = level.player customCamera_Push( "world", camera_location.origin, camera_angle, .15, 0.35, 0.20);
	wait(.3);

	//fov_transition_speed( 60.0 ); // default is 60.0
	fov_transition(10);
	wait(3);
	level thread player_unstick();
	fov_transition_speed( 120.0 ); // default is 60.0
	fov_transition(0); // default zero goes back to 65
	//wait(1);

	level.player customCamera_pop( fov_camera, 0.25, 0.35, 0.5);
}

//guy that talks to bond on the balcony
lobby_railing_guy()
{
	
	spawner = getent( "lobby_railing_guy", "targetname" );
	level.railing_guy = spawner stalingradspawn();	//delete him later
	if ( spawn_failed(level.railing_guy) )
  {
    return;
  }
  
  level waittill("stumble_cutscene_done");
	level.railing_guy thread play_dialogue( "CB03_CaPoG_53A");
  //walk him over to door - nr phone
 	level.railing_guy animscripts\shared::placeWeaponOn( level.railing_guy.primaryweapon, "none" );	//xxx haxxor to remove weapon

 }


set_fall_down_stairs_trigger()
{
	trigger = getent( "fall_down_stairs_trigger", "targetname" );
  trigger waittill( "trigger" );

	//level thread remove_drones(); //don't need 

	level thread set_backtrack_death_trigger(); // blocks going upstairs again 

	level.stage = 3;
 // BEN SEZ FOURTH SAVE HERE
  //level thread maps\_autosave::autosave_now("casino_poison");

  //iprintlnbold ( "Animation - Fall down stairs" );
	//level.player playerAnimScriptEvent("StaggerFall");
	//use knockback to simulate fall
//	org = spawn( "script_origin", level.player.origin );
//	wait(0.1);
//	level.player knockback( 4000, org.origin, org );
//		
}


set_backtrack_death_trigger()
{
	trig = getent( "backtrack_death_trigger", "targetname" );

	trig waittill( "trigger" );

	level.time_remaining = 0;
}


place_privee_civilian_walkers()
{
  spawner = getentarray( "privee_civilian_walkers", "targetname");
  if ( !IsDefined( spawner) )
  {
    //iPrintLnBold( "No Civilian Spawner!" );
    return;
  }

  for( i = 0; i < spawner.size; i++ )
  {
    level.privee_civilian_walkers[i] = spawner[i] stalingradspawn();

    if ( spawn_failed(level.privee_civilian_walkers[i]) )
    {
      return;
    }
 	
 	
 	
		level.privee_civilian_walkers[i] lockalertstate( "alert_green" );
		level.privee_civilian_walkers[i] SetEnableSense( false );
		level.privee_civilian_walkers[i]  animscripts\shared::placeWeaponOn( level.privee_civilian_walkers[i].primaryweapon, "none" );	//xxx haxxor to remove weapon
		//level.privee_civilian_walkers[i] thread civs_bump(); 
	
		if( spawner[i].script_noteworthy == "vesper" )
		{
			level.privee_civilian_walkers[i] thread privee_vesper_anim();
		}
		
	}
}

privee_vesper_anim()
{
	self attach( "w_t_sony_phone", "TAG_WEAPON_LEFT" );
	
	level waittill("curtain_1_start");
	wait(0.1);//fixes restart bug not playing anim
	
	while(1)
	{
	 		self CmdPlayAnim( "Gen_Civs_CellPhoneTalk_Female", false );
		  self waittill("cmd_done");			
	}
	
}


place_courtyard_civilian_walkers()
{
  spawner = getentarray( "courtyard_civilian_walkers", "targetname");
  if ( !IsDefined( spawner) )
  {
   // iPrintLnBold( "No Civilian Spawner!" );
    return;
  }

  for( i = 0; i < spawner.size; i++ )
  {
    level.courtyard_civilian_walkers[i] = spawner[i] stalingradspawn();

    if ( spawn_failed(level.courtyard_civilian_walkers[i]) )
    {
      return;
    } 
     
	//if ( isdefined(level.courtyard_civilian_walkers[i].script_noteworthy) )
	//{
	//	level.courtyard_civilian_walkers[i] StartPatrolRoute( level.courtyard_civilian_walkers[i].script_noteworthy );
	//}    

	level.courtyard_civilian_walkers[i] SetEnableSense( false );
	level.courtyard_civilian_walkers[i] lockalertstate( "alert_green" );
	level.courtyard_civilian_walkers[i]  animscripts\shared::placeWeaponOn( level.courtyard_civilian_walkers[i].primaryweapon, "none" );	//xxx haxxor to remove weapon
	level.courtyard_civilian_walkers[i] thread civs_bump();        

  }
}

place_anteroom_civilian_walkers()
{
  spawner = getentarray( "anteroom_civilian_walkers", "targetname");
  if ( !IsDefined( spawner) )
  {
   // iPrintLnBold( "No Civilian Spawner!" );
    return;
  }

  for( i = 0; i < spawner.size; i++ )
  {
    level.anteroom_civilian_walkers[i] = spawner[i] stalingradspawn();

    if ( spawn_failed(level.anteroom_civilian_walkers[i]) )
    {
      return;
    } 

	level.anteroom_civilian_walkers[i] SetEnableSense( false );
	level.anteroom_civilian_walkers[i] lockalertstate( "alert_green" );
	level.anteroom_civilian_walkers[i]  animscripts\shared::placeWeaponOn( level.anteroom_civilian_walkers[i].primaryweapon, "none" );	//xxx haxxor to remove weapon

	level.anteroom_civilian_walkers[i] thread civs_bump();        
	//if ( isdefined(level.anteroom_civilian_walkers[i].script_noteworthy) )
	////{
	//	level.anteroom_civilian_walkers[i] StartPatrolRoute( level.anteroom_civilian_walkers[i].script_noteworthy );
	//}    
  }
}


place_hallway_civilian_walkers()
{
  spawner = getentarray( "hallway_civilian_walkers", "targetname");
  if ( !IsDefined( spawner) )
  {
    //iPrintLnBold( "No Civilian Spawner!" );
    return;
  }

  for( i = 0; i < spawner.size; i++ )
  {
    level.hallway_civilian_walkers[i] = spawner[i] stalingradspawn();

    if ( spawn_failed(level.hallway_civilian_walkers[i]) )
    {
      return;
    } 

	level.hallway_civilian_walkers[i] SetEnableSense( false );
	level.hallway_civilian_walkers[i] lockalertstate( "alert_green" );
	level.hallway_civilian_walkers[i]  animscripts\shared::placeWeaponOn( level.hallway_civilian_walkers[i].primaryweapon, "none" );	//xxx haxxor to remove weapon

	level.hallway_civilian_walkers[i] thread civs_bump();        
    
     
	if ( isdefined(level.hallway_civilian_walkers[i].script_noteworthy) )
	{
		level.hallway_civilian_walkers[i] StartPatrolRoute( level.hallway_civilian_walkers[i].script_noteworthy );
	}    
  }
}



place_lobby_civilian_walkers()
{
  spawner = getentarray( "lobby_civilian_walkers", "targetname");
  if ( !IsDefined( spawner) )
  {
    //iPrintLnBold( "No Civilian Spawner!" );
    return;
  }

  for( i = 0; i < spawner.size; i++ )
  {
    level.lobby_civilian_walkers[i] = spawner[i] stalingradspawn();

    if ( spawn_failed(level.lobby_civilian_walkers[i]) )
    {
      return;
    }

	level.lobby_civilian_walkers[i] SetEnableSense( false );
	level.lobby_civilian_walkers[i] lockalertstate( "alert_green" );
	level.lobby_civilian_walkers[i]  animscripts\shared::placeWeaponOn( level.lobby_civilian_walkers[i].primaryweapon, "none" );	//xxx haxxor to remove weapon
	level.lobby_civilian_walkers[i] thread civs_bump();        
   
  }
}


place_outdoor_civilian_walkers()
{
  spawner = getentarray( "outdoor_civilian_walkers", "targetname");
  if ( !IsDefined( spawner) )
  {
    //iPrintLnBold( "No Civilian Spawner!" );
    return;
  }

  for( i = 0; i < spawner.size; i++ )
  {
    level.outdoor_civilian_walkers[i] = spawner[i] stalingradspawn();

    if ( spawn_failed(level.outdoor_civilian_walkers[i]) )
    {
      return;
    }
	level.outdoor_civilian_walkers[i] SetEnableSense( false );
	level.outdoor_civilian_walkers[i] lockalertstate( "alert_green" );
	level.outdoor_civilian_walkers[i]  animscripts\shared::placeWeaponOn( level.outdoor_civilian_walkers[i].primaryweapon, "none" );	//xxx haxxor to remove weapon
	level.outdoor_civilian_walkers[i] thread civs_bump();        
  
  }
}


remove_privee_civilian_walkers()
{
  for( i = 0; i < level.privee_civilian_walkers.size; i++ )
  {
	  if (isalive(level.privee_civilian_walkers[i]))
	  {
		  level.privee_civilian_walkers[i] delete();
	  }
  }
}

remove_courtyard_civilian_walkers()
{
  for( i = 0; i < level.courtyard_civilian_walkers.size; i++ )
  {
	  if (isalive(level.courtyard_civilian_walkers[i]))
	  {
		  level.courtyard_civilian_walkers[i] delete();
	  }
  }
}

remove_anteroom_civilian_walkers()
{
  for( i = 0; i < level.anteroom_civilian_walkers.size; i++ )
  {
	  if (isalive(level.anteroom_civilian_walkers[i]))
	  {
		  level.anteroom_civilian_walkers[i] delete();
	  }
  }
}

remove_hallway_civilian_walkers()
{
  for( i = 0; i < level.hallway_civilian_walkers.size; i++ )
  {
	  if (isalive(level.hallway_civilian_walkers[i]))
	  {
		  level.hallway_civilian_walkers[i] delete();
	  }
  }
}


remove_lobby_civilian_walkers()
{
  for( i = 0; i < level.lobby_civilian_walkers.size; i++ )
  {
	  if (isalive(level.lobby_civilian_walkers[i]))
	  {
		  level.lobby_civilian_walkers[i] delete();
	  }
  }
}


remove_drones()
{
	drones = getentarray ("drone", "targetname");	

	for( i = 0; i < drones.size; i++ )
	{
		if (IsDefined(drones[i]))
		{
			//drones[i] delete();
			drones[i] maps\_drones::drone_delete(0);
		}
	}
}


remove_lechiffre()
{
	level.le_chiffre = getent( "lechiffre", "targetname");
	if (IsDefined(level.le_chiffre))
	{
		if (isalive(level.le_chiffre)) level.le_chiffre delete();
	}
}

remove_dealer()
{
	level.dealer = getent( "dealer", "targetname");
	if (IsDefined(level.le_chiffre))
	{
		if (isalive(level.dealer)) level.dealer delete();
	}
}




civs_bump()
{
	self endon ( "death" );
	
	
	dialog[0] = "PB07_CaPoG_16A";
	dialog[1] = "PB09_CaPoG_18A";
	dialog[2] = "LR10_CaPoG_119A";
	
	// allow ai to push player
	//self PushPlayer( true );
	//penalty for bumping into stuff
	//level.time_remaining = level.time_remaining - 5;
	
	while(1)
	{
		// check for player dist and velocity
		if( (Distance(self.origin, level.player.origin ) < 32) && (level.player GetSpeed() > 40) )
		{
			//say something
			//self play_dialogue( dialog[ randomint(3) ]);
			self civs_talk();
			//self CmdPushEntity( level.player, true, 3 );
			//bounce off
			level.player knockback( 1000, self.origin, self);

			
			//penalty for bumping into stuff
			//level.player dodamage( 100, level.player.origin );
			wait( 3 );
		}
		else
		{
			wait( 0.1 );
		}
	}
}

civs_talk()
{
	dialog[0] = "PB07_CaPoG_16A";
	dialog[1] = "PB09_CaPoG_18A";
	dialog[2] = "LR10_CaPoG_119A";
	
	dialog_num = randomint(3);
	
	if( isdefined( level.last_dialog_num ) )
	{
		while( dialog_num == level.last_dialog_num )
		{
			dialog_num = randomint(3);	//pick a diff line
			wait(0.1);
		}
	}
	
	//say the line
	self play_dialogue( dialog[ dialog_num ] );
	
	level.last_dialog_num = dialog_num;
	
}




stop_patrol_now()
{
	wait(.05);

	if ( IsDefined( self ) )	
	{
		self stoppatrolroute();		
	}
	
	wait(.3);
	
	
	switch(self.script_noteworthy)
	{
		case "stand_talking":
		   switch(randomint(1))
		   {
		       case 0:
					while(1)
					{
			       		self CmdPlayAnim( "Gen_Civs_StandConversation", false );
			      		//print3d (self.origin + (0,0,70), "Stand Talking", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale
		       			self waittill("cmd_done");				
					}
		         break;
		         
		        case 1:
					while(1)
					{
			       		self CmdPlayAnim( "Gen_Civs_StandConversationV2", false );
			      		//print3d (self.origin + (0,0,70), "Stand Talking", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale
		       			self waittill("cmd_done");				
					}		        
		         break;  
		   }
		  break;
		
		case "stand_casual":
		    while(1)
		    {
				self CmdPlayAnim( "Gen_Civs_CasualStand", false );
			    //print3d (self.origin + (0,0,70), "Stand Casual", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale		
			    self waittill("cmd_done");        
		    }
		  break;
		  
		case "stand_arms_crossed":
		    while(1)
		    {
				self CmdPlayAnim( "Gen_Civs_StndArmsCrossed", false );
			    //print3d (self.origin + (0,0,70), "Stand Arms Crossed", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale		
			    self waittill("cmd_done");        
		    }		
		  break;	
		  
		case "stand_cell_phone":
		    while(1)
		    {
				self CmdPlayAnim( "Gen_Civs_CellPhoneTalk", false );
			    //print3d (self.origin + (0,0,70), "Stand Cell Phone", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale		
			    self waittill("cmd_done");        
		    }			  	  	
	}	
}


change_patrol()
{
	wait(.05);

	if ( IsDefined( self ) )	
	{
		self stoppatrolroute();	
		
		wait(.3);
		
	    if ( isdefined(self.script_noteworthy) )
	    {
		    self StartPatrolRoute( self.script_noteworthy );
	    } 
	    else
	    {
	    	//iprintlnbold("Noteworthy not defined");
	    } 
	}
}


end_of_patrol()
{
   wait(.3);
    
   switch(randomint(2))
   {
		case 0:
		    while(1)
		    {
				self CmdPlayAnim( "Gen_Civs_CasualStand", false );
			    //print3d (self.origin + (0,0,70), "Stand Casual", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale		
			    self waittill("cmd_done");        
		    }
		  break;
		  
		case 1:
		    while(1)
		    {
				self CmdPlayAnim( "Gen_Civs_StndArmsCrossed", false );
			    //print3d (self.origin + (0,0,70), "Stand Arms Crossed", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale		
			    self waittill("cmd_done");        
		    }		
		  break;	
		  
		case 2:
		    while(1)
		    {
				self CmdPlayAnim( "Gen_Civs_StandConversation", false );
			    //print3d (self.origin + (0,0,70), "Stand Cell Phone", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale		
			    self waittill("cmd_done");        
		    }			  	  	
	}	
}

#using_animtree("generic_human");
setup_car_driver(passenger)
{
	driver = Spawn( "script_model", self GetTagOrigin( "tag_driver" ) );
	driver.angles = self.angles;
	driver character\character_civ_1_poison::main();
	driver LinkTo( self, "tag_driver" );
	// play anims
	driver useAnimTree(#animtree);
	driver setFlaggedAnimKnobRestart("idle", %vehicle_luxury_sedan_driver);

	if(IsDefined(passenger) && passenger)
	{
//		passenger = Spawn( "script_model", self GetTagOrigin( "tag_passenger01" ) );
//		passenger.angles = self.angles;
//		passenger character\character_civ_1_poison::main();
//		passenger LinkTo( self, "tag_passenger01" );
//		passenger useAnimTree(#animtree);
//		passenger setFlaggedAnimKnobRestart("idle", %vehicle_luxury_sedan_passenger);
	}
}	

set_car_block_trigger()
{
	car = GetEnt("blocker","targetname");
	car setup_car_driver();
	car setDamageAI( 0 );
	path = GetVehicleNode("vehicle_start_node_blocking_car","targetname");
	car attachpath(path);
	//for lights
	car.script_int = 1;

	trigger = getent( "car_block_trigger", "targetname" );
	//trigger = getent( "outdoor_walker_trigger", "targetname" );
	trigger waittill( "trigger" );

	wait(8);	//so player can see pull in
	car startpath();

	player_collision_check();
}

activate_traffic_lane_1()
{
	level.lane_1 = GetEntArray("lane_1_car","targetname");

	lane_1_path = GetVehicleNode("vehicle_start_node_lane_1","targetname");
	level thread insure_no_collision_blocker();

	for(i = 0; i < level.lane_1.size; i++)
	{
		level.lane_1[i] setup_car_driver();
		//for lights
		level.lane_1[i].script_int = 1;
		level.lane_1[i] attachpath(lane_1_path);
		level.lane_1[i] startpath(lane_1_path);
		level.lane_1[i] setspeed(10, 10, 10);
		level.lane_1[i] setDamageAI( 0 );
		level.lane_1[i] thread restart_car_at_endnode(lane_1_path);

		wait(RandomIntRange(3,5));
	}
}

insure_no_collision_blocker()
{
	wait(9);
	trigger = getent( "car_block_trigger", "targetname" );
	trigger notify( "trigger" );
}

activate_traffic_lane_2()
{
	level.lane_2 = GetEntArray("lane_2_car","targetname");

	lane_2_path = GetVehicleNode("vehicle_start_node_lane_2","targetname");

	for(i = 0; i < level.lane_2.size; i++)
	{
		//level.lane_2[i] setup_car_driver(true);	// do later
		//for lights
		level.lane_2[i].script_int = 1;
		level.lane_2[i] attachpath(lane_2_path);
		level.lane_2[i] startpath(lane_2_path);
		level.lane_2[i] setspeed(25, 10, 10);
		level.lane_2[i] setDamageAI( 0 );
		level.lane_2[i] thread restart_car_at_endnode(lane_2_path);

		wait(RandomIntRange(2,6));
	}

}

restart_car_at_endnode(path)
{
	while(true)
	{
		self waittill( "reached_end_node" );
		self attachpath(path);
		self startpath(path);
		wait(.1);
	}
}

player_collision_check()
{
	level.player waittill("damage", amount ,attacker, direction_vec, P, type);
	
	iprintlnbold(" damage is ", amount );

	for(i = 0; i < level.lane_1.size; i++)
	{
		if(attacker == level.lane_1[i])
		{
			attacker thread car_collision_reaction(1);
			level notify("stop_freeze");
			fov_transition(-1);
			level.player freezeControls(false);
			return;
		}
	}
	for(i = 0; i < level.lane_2.size; i++)
	{
		if(attacker == level.lane_2[i])
		{
			attacker thread car_collision_reaction(2);
			return;
		}
	}

	//iprintlnbold("Player damage by something other than car");
	wait(.25);
	//level.player.health = 100;
	level thread player_collision_check(); // reset for collision with another car
}


car_collision_reaction(lane_number)
{
	self setspeed(0, 20, 20);
	level.player knockback( 2000, self.origin, self);
	earthquake (.5, .75, level.player.origin, 1000);
	level.player playsound("CASP_hit_by_car");
	//self playsound("CASP_car_horn_01");
	self thread car_honk();
	
	// Make player face the car
	car_direction = VectorToAngles( self.origin - (level.player.origin) );      // don't forget to compute from the head, not the feet
	level.player SetPlayerAngles( car_direction );

	switch(lane_number)
	{
		case 1:
			level.lane_1_collision = true; // stops new car spawns & stops collision with other cars in the same lane
			self thread stop_other_cars(1);  // stops existing cars
			break;

		case 2:
			level.lane_2_collision = true; // stops new car spawns & stops collision with other cars in the same lane
			self thread stop_other_cars(2);  // stops existing cars
			break;
	}

	wait(.05);
	//level.player.health = 100;
	level thread player_collision_check(); // reset for collision with another car
}

stop_other_cars(lane_number)
{
	level endon( "reached_parking_lot" );
	
	if(lane_number == 1)
	{
		current_distance = 15000;
		distance_increment = 25000;
	}
	else
	{
		current_distance = 30000;
		distance_increment = 50000;
	}

	while(true)
	{
		if(lane_number == 1)
		{
			for(i = 0; i < level.lane_1.size; i++)
			{
				if( DistanceSquared(level.lane_1[i].origin, self.origin) < current_distance)
				{
					level.lane_1[i] setspeed(0,30,30);
					current_distance = current_distance + distance_increment;
					//level.lane_1[i] thread car_honk();
				}
			}
		}
		else
		{
			for(i = 0; i < level.lane_2.size; i++)
			{
				if( DistanceSquared(level.lane_2[i].origin, self.origin) < current_distance)
				{
					level.lane_2[i] setspeed(0,30,30);
					current_distance = current_distance + distance_increment;
		
				}
			}
		}	
		wait(.1);
	}	
}

freeze_player_road()
{
	self endon("stop_freeze");

	trigger = GetEnt("nightmare_walk","targetname");
	trigger waittill("trigger");
	
	level thread car_drivers2();
	//level.player.health = 300;	//so don't die
	level.player freezeControls(true);
	fov_transition(130);
	level.player playsound( "stretch_1" );

}


//place drivers in car at last second
car_drivers2()
{
	
	for(i = 0; i < level.lane_2.size; i++)
	{
		level.lane_2[i] setup_car_driver(true);
		
	}
	
}


car_honk()
{
	
	level endon( "reached_parking_lot" );

	honk[0] = "CASP_car_horn_01";
	honk[1] = "CASP_car_horn_02";
	honk[2] = "CASP_car_horn_03";
	
	while(1)
	{
		self playsound(honk[randomint(3)]);
		wait(1);
	}
}


///////// REACHED GET JUMPED MELEE /////////

reached_get_jumped_melee()
{
	earthquake (.5, 2.0, level.player.origin, 1000);

	//player_stick( true );
	//player_jumped_position = getent( "player_jumped_position", "targetname" );
	//level.sticky_origin moveTo( player_jumped_position.origin, .05);

    //iprintlnbold ( "Animation - Fall down stairs" );
	//iPrintLnBold( "Placeholder for Animated Fight Sequence" );
	//level.player playerAnimScriptEvent("StaggerFall");

	//level.stage = 4;

	//wait(.5);

	//place_parking_lot_henchmen();
	//wait(0.1);	//so he's defined
	
	//SetSavedDVar( "timescale", "0.20" );

//	level.parking_lot_henchmen lockalertstate( "alert_red" );
//
//	wait(.15);
//
//	level.parking_lot_henchmen cmdaimatpos( level.player.origin + (0,-5,62), true, -1 );
//	//level.parking_lot_henchmen cmdshootatpos(level.player.origin + (0,-5,62),true,1,0);
//	//level.parking_lot_henchmen cmdshootatpos(level.player.origin + (0,0,60),true,-1,1);
//	wait(.6);
//
//	//level.parking_lot_henchmen waittill("damage");
//

//	player_unstick();
	
	//quick kill?
	//playcutscene("BP_Fight","BP_Fight_done");
	
	//level waittill( "BP_Fight_done" );
	//level.parking_lot_henchmen dodamage( 20, (0,0,0) );
	
	wait(.1);
	SetSavedDVar( "timescale", ".5" );
	wait(3.5);

	level notify("fx_DBS_alarm");
}


place_parking_lot_henchmen()
{
  spawner = getent( "p_parking_lot_henchmen", "targetname");
  if ( !IsDefined( spawner) )
  {
    //iPrintLnBold( "No Spawner!" );
    return;
  }

  level.parking_lot_henchmen = spawner stalingradspawn();

  if ( spawn_failed(level.parking_lot_henchmen) )
  {
    return;
  }

  level.parking_lot_henchmen lockalertstate( "alert_green" );
  level.parking_lot_henchmen SetEnableSense( false );
  level.parking_lot_henchmen.health = 10;
  level.parking_lot_henchmen.dropweapon = false;
	level.parking_lot_henchmen.targetname = "thug";	//for cutscene

  //level.parking_lot_henchmen animscripts\shared::placeWeaponOn( level.parking_lot_henchmen.primaryweapon, "none" );	//xxx haxxor to remove weapon
  //level.parking_lot_henchmen SetEngageRule( "Never" );
}





//turn poison off
debug_poison_off()
{
	if( getdvar( "nopoison" ) == "1")
	{
		while(1)
		{
//			wait(0.1);
//			poisoneffect(false);
				//VisionSetNaked( "casino_poison_0", 1.0 );
		
				//test poison not on all the time
				wait(10);
				poisoneffect(false);
//				wait(3);
//				poisoneffect(true);
		}
	}
	
}

//sets the sway control
poison_sway()
{
	//endon
	
	//turn on and off with a flag
	while(1)
	{
				
			flag_wait("sway_on");
			//turn on
			level.player poisonmovements(1);
			poisoneffect(true);

			while( flag("sway_on") )
			{
				wait(0.1);
			}	
			
			//turn off
			level.player poisonmovements(0);
			poisoneffect(false);

			//iprintlnbold("swayooff");
			
	}
	
}

play_dialog( sound_alias )
{
	self endon( "death" );

	self playsound( sound_alias, "play_dialog_done", true );
	self waittill( "play_dialog_done" );
}

poison_cycle()
{
	
	level waittill("intro_cutscene_2_done");
	
	while(1)
	{
			
			poisoneffect(false);

			wait(5);
			
			poisoneffect(true);
			
			wait(5);
			
	}
	
	
}

new_ending()
{
		
  level.player play_dialog("M_CaPoG_193A");
  wait(0.25);
  //defib sound
  level.player playsound( "CASP_defib" );
  wait(2);
  level thread defib_press();
 	level.player play_dialog("M_CaPoG_194A");
  wait(2);
 	level.player play_dialog("VESP_CaPoG_195A");
	//wait(1);
	//level.player play_dialog("VESP_CaPoG_195A");
	
	
}


defib_press()
{
	while(1)
	{
		if ( level.player buttonPressed( "BUTTON_B" ) )
		{
			//iprintlnbold(" button ");
			level.player playsound("cell_phone_pickup");
		}
		wait(0.5);		
		
	}
	
}

poisonTimer_SetDiff( easy, normal, hard, xprt )
{
	level notify("kill_timer");
	timeRemaining = normal;
	wait(0.1);
	switch(getdifficulty())
	{
		case "Civilian": 
			timeRemaining = easy;
			break;
		case "New Recruit":
			timeRemaining = normal;
			break;
		case "Agent":
			timeRemaining = hard;
			break;
		case "Double-Oh":
			timeRemaining = xprt;
			break;			
	}
	maps\_utility::timer_start(timeRemaining);
}
