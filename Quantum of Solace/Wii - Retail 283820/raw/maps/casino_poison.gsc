#include maps\_utility;
#include animscripts\shared;
#include maps\_anim;
#using_animtree("generic_human");


main()
{
	
	
	maps\casino_poison_fx::main();	
	
	precachevehicle("defaultvehicle");

	maps\_vsedan::main("v_sedan_blue_radiant");
	maps\_vsedan::main("v_sedan_gray_radiant");
	maps\_vsedan::main("v_sedan_silver_radiant");
	maps\_vsedan::main("v_sedan_tan_radiant");

	precachemodel( "v_sedan_blue_radiant" );
	precachemodel( "v_sedan_gray_radiant" );
	precachemodel( "v_sedan_silver_radiant" );
	precachemodel( "v_sedan_tan_radiant" );

	
	precacheShader("overlay_hunted_black");
	if (!IsDefined(level.hud_black))
	{
		level.hud_black = newHudElem();
		level.hud_black.x = 0;
		level.hud_black.y = 0;
		level.hud_black.horzAlign = "fullscreen";
		level.hud_black.vertAlign = "fullscreen";
		level.hud_black.foreground = -2;
		level.hud_black SetShader("overlay_hunted_black", 640, 480);
		level.hud_black.alpha = 0;
	}

	maps\_load::main();
	
	
	SetSavedDVar("cover_dash_fromCover_enabled",false);
	SetSavedDVar("cover_dash_from1stperson_enabled",false);
	
	SetDvar("player_sprintEnabled", false);
	
	precacheShader( "compass_map_casino_poison" );

	PrecacheCutScene("BondPoison1");
	PrecacheCutScene("BondPoison_sc2");
	PrecacheCutScene("BP_Stumble_Table_Left");
	PrecacheCutScene("BP_Stumble_Table_Right");
	PrecacheCutScene("BP_Stumble_Rail");
	

	maps\casino_poison_amb::main();
	maps\casino_poison_mus::main();
	
	
	setminimap( "compass_map_casino_poison", 4992.0, 8640.0, 832.0, 576.0 );


	
	
	
	character\character_casino_male_1::precache();
	
	
	

	level.drone_spawnFunction["civilian"][0] = character\character_casino_male_1::main;
	level.drone_spawnFunction["civilian"][1] = character\character_casino_male_1::main;
	
	
	level.drone_spawnFunction["civilian"][2] = character\character_casino_male_1::main;
	level.drone_spawnFunction["civilian"][3] = character\character_casino_male_1::main;
	
	
		
	maps\_drones::init();
	
	
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
	fov_transition_speed( 60.0 ); 
	VisionSetNaked( "casino_poison_0", .01 );
	level.currvision = "casino_poison_0";
	SetDVar( "r_motionblur_enable", "0" ); 

	level.skipto = "none";

	
	

	
	
	flag_init( "sway_on" );


	

	level thread setup_bond();

	

	level.dealer = getent( "dealer", "targetname");  
	level.dealer  lockalertstate( "alert_green" );  
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
		
		
		
		wait(0.1);
		level thread play_intro_cutscene();

		

		
	}

	if(getdvar( "skipto" ) != "artist")
	{

		
		
		if( getdvar( "nopoison" ) != "1")
		{
			
			level thread heartbeat_rumble();
			level thread poison_sway();
		}
		
		
		

		level thread set_courtyard_walker_trigger();
		level thread set_privee_walker_trigger();
		level thread set_anteroom_walker_trigger();
		level thread set_hallway_walker_trigger();
		level thread set_outdoor_walker_trigger();

		level thread set_courtyard_exit_trigger();
		level thread set_temp_teleport_trigger();
		level thread set_parking_lot_jumped_trigger();
		level thread set_reached_car_trigger();
		

		

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
		level thread ChangePassoutEffect(); 
		level thread debug_poison_off();
		
		wait(.005);

		skipto();  
	}
	
	
		
}

test()
{
	while(1)
	{
		
		wait(1);
	}
}




camera_cube_test()
{
	
	

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
	
}


movement_test()
{
	while(1)
	{
		lateral_move = level.player poisonEffectInput( "side" );    
		forward_move = level.player poisonEffectInput( "forward" );  

		
		

		wait(.5);
	}

}


double_vision()
{
	
	

	double_vision_x = 0;
	double_vision_y = 0;

	current_vision_x = 0;
	current_vision_y = 0;

	recovery_rate = .95; 
	blur_rate = .20; 
	d_vision_floor = .70;  

	setDvar("r_poisonFX_dvisionA", "45.0");   

	
	

	while(1)
	{
		
		yaw_move = level.player poisonEffectInput( "yaw" );    
		pitch_move = level.player poisonEffectInput( "pitch" );  

		
		if (abs(yaw_move) < d_vision_floor)
		{
			yaw_move = 0;
		}


		if (abs(pitch_move) < d_vision_floor)
		{
			pitch_move = 0;
		}


		
		double_vision_x = yaw_move * 20;
		double_vision_y = pitch_move * 20;

		
		if(abs(current_vision_x) < abs(double_vision_x))
		{
			
			current_vision_x = current_vision_x + ((double_vision_x - current_vision_x) * blur_rate);
		}
		else
		{
			current_vision_x = current_vision_x * recovery_rate;
		}


		if(abs(current_vision_y) < abs(double_vision_y))
		{
			current_vision_y = current_vision_y + ((double_vision_y - current_vision_y) * blur_rate);
			
		}
		else
		{
			current_vision_y = current_vision_y * recovery_rate;
		}		

		
		current_vision_x = max(min(20, current_vision_x), -20);
		current_vision_y = max(min(20, current_vision_y), -20);
		
		
		
		

		wait(.01);
	}




}

door_test()
{
	door = getnode ("salle_door_node", "targetname");
	
	if(isDefined(door))
	{
		door_right = getent ("salle_rest_door_right", "targetname");
		door_left = getent ("salle_rest_door_left", "targetname");
	
		door_right._doors_auto_close = false;
		door_left._doors_auto_close = false;	
		
		
		door maps\_doors::open_door_from_door_node();	
		

		wait(10);
		
		door_right._doors_auto_close = true;
		door_left._doors_auto_close = true;	
	
		
		door maps\_doors::close_door_from_door_node();
		
		
		
		
	
	
	}
	else
	{
		
	}



	
	
	
	
	
}


skipto()  
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







setup_bond()
{
	

	level.player allowcrouch(false);
	level.player allowjump(false);
	level.player allowProne( false );

	maps\_phone::setup_phone();
	
	wait(0.05);
	setSavedDvar("cg_disableBackButton","1"); 
	
	
	level.player TakeAllWeapons();
	
	
}




heartbeat_rumble()
{
	
	if(getdvar( "skipto" ) == "none" || getdvar( "skipto" ) == "")
	{
		level waittill("intro_cutscene_2_done"); 
	}
	
	level.stage = 1;  

	level.passout_active = false;  
	
	if (isdefined(level.current_time))
	{
		level.time_remaining = level.current_time + 1;
		
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

		level.time_remaining = timeRemaining;  
		
	}

	level thread poison_timer();

	
	

	
	
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
		
	}

	if (level.time_remaining < level.current_time)
	{
		level.time_remaining = level.current_time + 1;
		

	}
	else
	{
		level.time_remaining = 60;
		
	}

	
	
	SetSavedDVar( "timescale", "0.1" );
	wait(.3);

	
	SetSavedDVar( "timescale", ".75" ); 

	poisoneffectsettings( 2, 0.3, 0.22, 0.0, 0.0, 0.0 ); 

	while(level.stage == 2)
	{
		if(level.passout_active == false)
		{
			level.player PlayRumbleOnEntity( "damage_light" );
			
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
		wait(.75); 
	}


	if (level.time_remaining < level.current_time)
	{
		level.time_remaining = level.current_time + 1;
		
	}
	else
	{
		
		level.time_remaining = 45;
	}
	
	

	
	
	
	wait(0.3);

	
	

	
	

	while(level.stage == 3)
	{
		if(level.passout_active == false)
		{
			level.player PlayRumbleOnEntity( "qk_hit" );
			
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
		
		wait(.55); 
	}


	

	
	if (level.time_remaining < level.current_time)
	{
		level.time_remaining = level.current_time + 1;
		
	}
	else
	{
		level.time_remaining = 45;
		
	}
	
	wait(2);
	level notify ("reached_parking_lot"); 
	level notify ("reached_poison_checkpoint");  
	level.rumble_active = false;
	iprintlnbold("Rumble active false");
	wait(0.1);
	level thread begin_passout();  
	level.passout_active = false;
	
	




	
}


poison_timer()
{
	level endon ("reached_parking_lot");
		
	while(level.time_remaining > 13)
	{
		if (isdefined(level.timer))
		{
			if (level.time_remaining < level.current_time)
			{
				level.time_remaining = level.current_time;
			}
		}
		level.time_remaining = level.time_remaining - 1;
		wait(1);
		
	}

	level.passout_active = true; 
	wait(.5);
	level thread begin_passout();  
	while(level.time_remaining > 0)
	{
		if (isdefined(level.timer))
		{
			if (level.time_remaining < level.current_time)
			{
				level.time_remaining = level.current_time;
			}
		}
		level.time_remaining = level.time_remaining - 1;	
		
		wait(1);
	}
	while(level.time_remaining < 1)  
	{
		wait(.5);
	}

	level notify ("reached_poison_checkpoint");  
	level.rumble_active = false;
	iprintlnbold("Rumble active false");

	wait(.25);
	

	level.passout_active = false;
	level thread poison_timer();
}



begin_passout()
{
	
	
	if( getdvar( "nofail" ) == "1")
	{
		return;	
	}
	
	level endon ("reached_poison_checkpoint");
	level thread passout_rumble();
	
	while(level.time_remaining > 13)
	{
		if (isdefined(level.timer))
		{
			if (level.time_remaining < level.current_time)
			{
				level.time_remaining = level.current_time;
			}
		}
		wait(1);
	}
	level.passout_active = true;
	level.rumble_active = true;
	
	
	blackout_time = 8;

	wait(blackout_time);




	if (level.current_time < blackout_time)
	{
		VisionSetNaked( "casino_poison_8", 3.0 ); 
	}

	wait(5);
	
	
	
	
	
	
	{
		if (level.time_remaining < 1)
		{
			
			SetDVar("r_bx_poison_passOut_percent", 0.0);
			level.player dodamage( level.player.health + 1000, level.player.origin );
		}
		else
		{
			
			
			
			level.passout_active = false;
			level thread begin_passout();
			
			
		}
	}
}


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

			level.player PlayRumbleOnEntity( "movebody_rumble" ); 
			wait(.25);
		}
		wait(0.5);
	}
}



set_courtyard_exit_trigger()
{
  trigger = getent( "courtyard_exit_trigger", "targetname" );
  trigger waittill( "trigger" );

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
  
  visionsetnaked( "casino_poison_rstrnt" );
  level.currvision = "casino_poison_rstrnt";
 
  place_courtyard_civilian_walkers();
  
  
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
  
  VisionSetNaked( "casino_Poison_hall");
  level.currvision = "casino_Poison_hall";


  level thread place_hallway_civilian_walkers();
  level thread remove_drones();
}


set_outdoor_walker_trigger()
{
  trigger = getent( "outdoor_walker_trigger", "targetname" );
  trigger waittill( "trigger" );
    
  VisionSetNaked( "casino_poison_exit");
  level.currvision = "casino_poison_exit";

  place_outdoor_civilian_walkers();
  
  
  
  

	wait(2);
	
	VisionSetNaked( "casino_poison_parking");
	level.currvision = "casino_poison_parking";

  
}



screen_pulse(poison_stage)
{
	
		
	

























































}





set_temp_teleport_trigger()
{
  trigger = getent( "temp_teleport_trigger", "targetname" );
  trigger waittill( "trigger" );

  
  
  

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
	
	
	level notify("kill_timer");
	wait(0.1);
	
	
	
	
  level notify("fx_DBS_alarm");
  org = getent( "defib", "targetname" );
  org playsound( "CASP_car_alarm_chirp" );
  
  wait(2);

	
	if (!IsDefined(level.hud_black))
	{
		level.hud_black = newHudElem();
		level.hud_black.x = 0;
		level.hud_black.y = 0;
		level.hud_black.horzAlign = "fullscreen";
		level.hud_black.vertAlign = "fullscreen";
		level.hud_black.foreground = -2;
		level.hud_black SetShader("overlay_hunted_black", 640, 480);
		level.hud_black.alpha = 0;
	}
	
	
	setSavedDvar("cg_drawHUD","1");	
	setdvar("ui_hud_showstanceicon", "0");
	setsaveddvar ( "ammocounterhide", "1" );
	setdvar("ui_hud_showcompass", "0");
	
	
	level.hud_black fadeOverTime(0.5);
	level.hud_black.alpha = 1;
	wait(.5);

	
	
	level.player freezeControls( true );
	
	
	
	
	
	camera_position = getent ( "car_camera_position_1", "targetname" );
	camera_target = getent ( "car_camera_target_1", "targetname" );
	camera_angle = VectorToAngles( camera_target.origin - camera_position.origin); 

	level.preview_camera = level.player customCamera_Push( "world", camera_position.origin, camera_angle, .3, 0.35, 0.00);
	wait(2.0);
	

	
	
		












































































	level notify("endmusicpackage");

	new_ending();
	
	
	
	
	
	
	maps\_endmission::nextmission();

}



end_defib()
{
	defib = getent("defib", "targetname");
	defib_start = getent("defib_start", "targetname");
	
	defib hide();
	
	level waittill( "cam_at_car" );

	defib_start moveto( defib.origin, 1.0 );
	
	org = getent( "defib", "targetname" );
  org playsound( "CASP_defib" );
  wait( 2 );
	PlayLoopedFx(level._effect["defibrilator_light"], 0.5, defib.origin+(-0.9,-2.3,1.8));	
}


set_parking_lot_jumped_trigger()
{
















}


place_vesper()
{
  spawner = getent( "vesper", "targetname");
  if ( !IsDefined( spawner) )
  {
    
    return;
  }

  level.vesper = spawner stalingradspawn();

  if ( spawn_failed(level.vesper) )
  {
    return;
  }

	level.vesper lockalertstate( "alert_green" );
	level.vesper SetScriptSpeed( "jog" );
	level.vesper animscripts\shared::placeWeaponOn( level.vesper.primaryweapon, "none" );	

	wait( 4 );
	level.vesper play_dialogue("VESP_CaPoG_195A");

	
	
	
	
	
	
	
}



play_knock_back_animation()
{
    
    

	level.player playerAnimScriptEvent("ChairExitStumble");

	
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
		
	}
	

	level.hallway_door_node = getnode ("hallway_door_node", "targetname");
	
	if(isDefined(level.hallway_door_node))
	{
		level.hallway_door_right = getent ("hallway_entrance_room_right", "targetname");
		level.hallway_door_left = getent ("hallway_entrance_room_left", "targetname");
	
		level.hallway_door_right._doors_auto_close = false;
		level.hallway_door_left._doors_auto_close = false;	
		
		
		level.hallway_door_node maps\_doors::open_door_from_door_node();	
		
	}


	level.lobby_door_node = getnode ("lobby_door_node", "targetname");

	if(isDefined(level.lobby_door_node))
	{
		level.lobby_door_right = getent ("lobby_right", "targetname");
		level.lobby_door_left = getent ("lobby_left", "targetname");

		level.lobby_door_right._doors_auto_close = false;
		level.lobby_door_left._doors_auto_close = false;	


		level.lobby_door_node maps\_doors::open_door_from_door_node();	
		
	}
	
}


close_privee_door()
{
	if(isDefined(level.privee_door_node))
	{
		level.privee_door_right._doors_auto_close = true;
		level.privee_door_left._doors_auto_close = true;	

		
		level.privee_door_node maps\_doors::close_door_from_door_node();
	}
}


close_hallway_door()
{
	if(isDefined(level.hallway_door_node))
	{
		level.hallway_door_right._doors_auto_close = true;
		level.hallway_door_left._doors_auto_close = true;	

		
		level.hallway_door_node maps\_doors::close_door_from_door_node();
	}
}


close_lobby_door()
{
	if(isDefined(level.lobby_door_node))
	{
		level.lobby_door_right._doors_auto_close = true;
		level.lobby_door_left._doors_auto_close = true;	

		
		level.lobby_door_node maps\_doors::close_door_from_door_node();
	}
}


play_intro_cutscene()
{
	
	
	
	
	level.hud_black.alpha = 1;
	level.hud_black fadeOverTime(5);
	level.hud_black.alpha = 0;
	
	wait (0.05);	
	
	
	level thread letterbox_on();	
		
	playcutscene("BondPoison1","intro_cutscene_1_done");
	level thread intro_dialog();

	
	
	VisionSetNaked( "casino_poison_7", 3.0 ); 
	level.currvision = "casino_poison_7";	
	
	SetDVar("r_bx_dof_enable", "1");
	SetDVar("r_bx_dof_farStart", "0.25");
	SetDVar("r_bx_dof_farEnd", "1.0");
	

	wait(1);
	
	

	wait(1.0);  
	
	fov_transition(25);
	
	wait(1.5);
	
	
	level notify("lechiffe_talk" );
	fov_transition(40);

	wait(1.0);  
	
	
	VisionSetNaked( "casino_poison_0", 1.0 ); 
	level.currvision = "casino_poison_0";
	
	SetDVar("r_bx_dof_enable", "0");
	

	wait(1.5);  
	
	fov_transition(25);
	poisoneffectsettings( 1.0, 0.3, 0.22, 0.0, 0.0, 0.0 ); 
	poisoneffect(true);
	level.player PlaySound("CASP_PoisonHit");

	wait(2);
	
	
	fov_transition(0);

	level waittill("intro_cutscene_1_done"); 
	
	poisoneffect(false);	
	player_stick( false );
	
	level.player PlaySound("CASP_Flythrough");
	level thread end_defib();
	
	
	level.dealer thread intro_anims();
	level.lechiffre thread intro_anims();
	
	activate_preview_camera();
	
	level notify ("preview_cam_done");

	player_unstick();
	
	playcutscene( "BondPoison_sc2","intro_cutscene_2_done" );

	level thread intro_spill();

	

	
	SetDVar("r_bx_poison_enable_distortion", 0.0); 
	VisionSetNaked( "casino_poison_0", 1.0 ); 
	level.currvision = "casino_poison_0";

	level waittill("intro_cutscene_2_done");
	
	level.player freezecontrols(false);	
	
	flag_set( "sway_on" );
	poisoneffect(true);	
	SetDVar("r_bx_poison_passOut_percent", 0.001);
	
	letterbox_off();









	
	level thread intro_lechiffre();
	
	
	
	
	
	
	level notify( "playmusicpackage_start" );
	
	
	
		
	
	
	setdvar("ui_hud_showcompass", "1");
	setdvar("ui_hud_showstanceicon", "0");
	

	
	level thread maps\_autosave::autosave_now("casino_poison");
	level thread poisonTimer_SetDiff( 50, 40, 30, 20);	
	
	
	
	
	objective_add( 1, "active", &"CASINO_POISON_OBJECTIVE1_HEADER", (0, 0, 0), &"CASINO_POISON_OBJECTIVE1_TEXT");

	visionsetnaked( "casino_poison_salon" );
	level.currvision = "casino_poison_salon";
	
	
	level thread intro_lechiffre();

}

intro_spill()
{
	
	level.player waittillmatch( "anim_notetrack", "spill_drink");
	level notify("martini_fall_start");	
	level.player playsound( "CASP_drink_knock" );
	
}

intro_dialog()
{
	
	
	
	level waittill("lechiffe_talk");
	
	
	
	level waittill( "cam_at_car" );
	level.player play_dialogue("M_CaPoG_06A");
	level.player play_dialogue("BOND_CaPoG_07A");
	
	level waittill("martini_fall_start");	
	level.player play_dialogue("BOND_CaPoG_03A");
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
	originalTimescale = getDVar("timescale");
	reducedTimescale = 0.8;
	
	level.player customcamera_checkcollisions( 0 );
	 	
	

	SetDVar( "r_motionblur_enable", "1" );
	SetDVar( "r_motionblur_maxBlurAmt", "40.0" );
	SetDVar( "r_motionblur_dist", "120.0" );	

	camera_speed = .2;

	camera = getent ( "camera_position_1", "targetname" );

	level.preview_camera = level.player customCamera_Push( "world", camera.origin, camera.angles, camera_speed, 0.35, 0.00);
	wait(camera_speed);
	camera = getent( camera.target, "targetname");

	
	SetSavedDVar( "timescale", reducedTimescale );
	
	for(i=1; i<40; i++)
	{
		
    level.player customCamera_change( level.preview_camera, "world", camera.origin, camera.angles , camera_speed, 0.00, 0.00); 

		
		

		if(i==20) 
		{
			teleport_position = getent ( "teleport_for_camera_fly", "targetname" );
			level.sticky_origin moveTo( teleport_position.origin, .5);
		}

		wait(camera_speed);

		
		if( isdefined( camera.target ))
		{
			camera = getent( camera.target, "targetname");
		}
		
	}

	
	SetSavedDVar( "timescale", originalTimescale );
	
	level notify( "cam_at_car" );

	wait(1);

	

	wait(2);


    
	camera = getent ( "reverse_camera_position_1", "targetname" );

	level.player customCamera_change( level.preview_camera, "world", camera.origin, camera.angles , camera_speed, 0.00, 0.00); 
	wait(camera_speed);
	camera = getent( camera.target, "targetname");

	return_speed = .05;
	
	
    
	
	

	




	camera = getent ( "camera_position_1", "targetname" );
  level.player customCamera_change( level.preview_camera, "world", camera.origin, camera.angles, .1, 0.00, 0.00); 

	

	
	

	level.player PlayRumbleOnEntity( "grenade_rumble" );  
	level.player customCamera_pop( level.preview_camera, 0.0, 0.35, 0.5);
	level.player customcamera_checkcollisions( 1 );
}


intro_lechiffre()
{
	while(1)
	{
		level.lechiffre CmdPlayAnim( "Gen_Civs_SeatedPlayingCards_A", false );
		level.lechiffre waittill("cmd_done");				
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
			physicsExplosionCylinder( level.player.origin, 30, 1, 1.2 );
			
			x = randomfloatrange( 0.2, 0.4 );
			earthquake ( x, .25, level.player.origin, 1000);

			wait(1.5);

			self waittill( "trigger" );
		}

	}
	else
	{
		physicsExplosionCylinder( level.player.origin, 30, 1, 1.2 );
		
		earthquake (.5, .75, level.player.origin, 1000);	

	}
	
	

}


link_trigger_to_dynent()
{
	while(1)
	{
		position = DynEnt_getOrigin(self.target); 
		
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

	
	level.player dodamage( level.player.health + 1000, level.player.origin );
}


BEN_time_remaining_debug()
{
	for(;;)
	{
		if (isdefined(level.time_remaining))
		{
			
		}
		wait(1);
	}
}


set_privee_table_stumble_right_trigger()
{
	level endon( "table_stumble_left_active" );

	trigger = getent( "privee_table_stumble_right_trigger", "targetname" );
  trigger waittill( "trigger" );
	
	
	
	
	
	
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );
	wait(0.5);
	VisionSetNaked(level.currvision, 0.5);
	
	
	level notify ("table_stumble_right_active"); 

	flag_clear( "sway_on" );
	poisoneffect(false);
	
	level.player freezecontrols(true);
	level notify("table_tip_1_start"); 
	playcutscene("BP_Stumble_Table_Right","table_stumble_right_done");
	time_left = level.current_time;
	level notify("kill_timer");
	wait(0.1);
	
	level.player playsound ("CASP_champagne_table");
	
	level waittill("table_stumble_right_done");
	
	
	level thread maps\_utility::timer_start(time_left);
	level.player freezecontrols(false);
	
	
	poisoneffect(true);	
	flag_set( "sway_on" );
	
	
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );
	wait(0.5);
	visionsetnaked( "casino_poison_salon" );
	level.currvision = "casino_poison_salon";

	
	
	
	
}


set_privee_table_stumble_left_trigger()
{
	level endon( "table_stumble_right_active" );

	trigger = getent( "privee_table_stumble_left_trigger", "targetname" );
	trigger waittill( "trigger" );
	
	if (isdefined(level.timer))
	{
		if (level.current_time < 10)
			return;
	}
	
	flag_clear( "sway_on" );
	poisoneffect(false);	
	
	
	level notify ("table_stumble_left_active"); 

	level.player freezecontrols(true);
	level notify("table_tip_2_start"); 
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );
	wait(0.5);
	
	VisionSetNaked(level.currvision, 0.5);
	
	playcutscene("BP_Stumble_Table_Left","table_stumble_left_done");
	
	time_left = level.current_time;
	level notify("kill_timer");
	wait(0.1);
	level.player playsound ("CASP_champagne_table");
	
	level waittill("table_stumble_left_done");
	
	level thread maps\_utility::timer_start(time_left);
	level.player freezecontrols(false);
	
	
	poisoneffect(true);
	flag_set( "sway_on" );
	
	
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );

	wait(0.5);	
	visionsetnaked( "casino_poison_salon" );
	level.currvision = "casino_poison_salon";
	
	
}

set_exit_dining_trigger()
{
		trigger = getent( "exit_dining_trigger", "targetname" );
    trigger waittill( "trigger" );
    
    VisionSetNaked( "casino_poison_atrium");
		level.currvision = "casino_poison_atrium";

    
		
	
		
		level thread close_privee_door(); 
		level thread remove_lechiffre();	
		level thread remove_dealer();
		level thread remove_privee_civilian_walkers();
		
	
		spawner = getent( trigger.target, "targetname" );
		guy = spawner stalingradspawn();

    if ( spawn_failed(guy) )
    {
      return;
    }
    
    
    level waittill( "delete_guy" );
    guy delete();
    
    
    
	

}


set_courtyard_entrance_trigger()
{
	trigger = getent( "poison_stage_2_trigger", "targetname" );
  trigger waittill( "trigger" );
	
	
	

	wait(.25);
	
	level thread maps\_autosave::autosave_now("casino_poison");
	wait(1.0);
	level thread poisonTimer_SetDiff( 65, 60, 55, 45 );
	wait(0.1);
	level.stage = 2; 
	
	level notify("reached_poison_checkpoint");
	wait(0.1);
	level thread begin_passout();  
	level.rumble_active = false;
	level.passout_active = false;



    

	
	
	
	fov_transition(130);
	level.player playsound( "stretch_1" );
	SetSavedDVar( "timescale", "0.5" );

	
	wait( 3 );
	fov_transition(0);
	level.player playsound( "stretch_2" );
	SetSavedDVar( "timescale", "0.75" );


 
}

set_corridor_fov_stretch_trigger()
{
	trigger = getent( "corridor_fov_stretch_trigger", "targetname" );
  trigger waittill( "trigger" );

	level thread close_hallway_door();
	
	
	level thread remove_courtyard_civilian_walkers();
	level thread remove_anteroom_civilian_walkers();
	level notify ("delete_guy" );

	fov_transition(130);
	level.player playsound( "stretch_3" );
	SetSavedDVar( "timescale", "0.5" );


  
}

set_corridor_exit_trigger()
{
	trigger = getent( "corridor_exit_trigger", "targetname" );
  trigger waittill( "trigger" );

  
  fov_transition(0);
  level.player playsound( "stretch_4" );
	SetSavedDVar( "timescale", "0.75" );

}


set_stagger_to_railing_trigger()
{
	trigger = getent( "stagger_to_railing_trigger", "targetname" );
  trigger waittill( "trigger" );
	
	if (isdefined(level.timer))
	{
		if( level.current_time < 12)
		{
			
			level.current_time = 60;
			level.time_remaining = 60;
		}
	}
	
	
	level notify ("reached_poison_checkpoint");  
	wait(0.1);
	
	
	
	
	
	
	
	
	
	level thread remove_hallway_civilian_walkers();
	level thread remove_drones();

	
	

    
	
	level thread letterbox_on();
	
	VisionSetNaked("boss_fail", 0.5);
	level.player playsound( "white_flash" );
	wait(0.5);
	VisionSetNaked(level.currvision, 0.5);
	
	flag_clear( "sway_on" );
	poisoneffect(false);
	
	level.player freezecontrols(true);
	
	level.player setplayerangles((0, 0, 0));
	playcutscene("BP_Stumble_Rail","stumble_cutscene_done");
	level notify("kill_timer");
	wait(0.1);
	
	
	wait(3); 
	level thread lobby_railing_guy();

	level waittill("stumble_cutscene_done");
	
	level.player freezecontrols(false);
	
	
	poisoneffect(true);
	flag_set( "sway_on" );
	
	level thread close_lobby_door();

	
	level thread maps\_autosave::autosave_now("casino_poison");
	level thread poisonTimer_SetDiff( 65, 60, 55, 40 );
	
	level notify("reached_poison_checkpoint");
	wait(0.1);
	level thread begin_passout();  
	level.rumble_active = false;
	level.passout_active = false;
	 

	
	VisionSetNaked("boss_fail", 0.3);
	level.player playsound( "white_flash" );
	wait(0.3);
	VisionSetNaked( "casino_poison_hall");
	level.currvision = "casino_poison_hall";
		
	
	letterbox_off();
	

	
	
	
	
	
	
	setdvar("ui_hud_showstanceicon", "0");
		
	
	
	
	level.stage = 3;

	
	objective_add( 1, "active", &"CASINO_POISON_OBJECTIVE1_HEADER", (0, 0, 0), &"CASINO_POISON_OBJECTIVE1_TEXT");
	
}


icon_fix()
{
	level waittill("letterbox_off_done");
	wait( 1.55 );	
	setdvar("ui_hud_showstanceicon", "0");
}


fov_camera_zoom()
{
	camera_location = getent ( "fov_camera_location", "targetname" );
	camera_target = getent ( "fov_camera_target", "targetname" );

	if ( !IsDefined( camera_location.origin) )
	{
		
		wait(3);
	}

	if ( !IsDefined( camera_location.angles) )
	{
		
		wait(3);
	}
	camera_angle = VectorToAngles( camera_target.origin - camera_location.origin);      

	if ( !IsDefined( camera_angle) )
	{
		
	}

	fov_camera = level.player customCamera_Push( "world", camera_location.origin, camera_angle, .15, 0.35, 0.20);
	wait(.3);

	
	fov_transition(10);
	wait(3);
	level thread player_unstick();
	fov_transition_speed( 120.0 ); 
	fov_transition(0); 
	

	level.player customCamera_pop( fov_camera, 0.25, 0.35, 0.5);
}


lobby_railing_guy()
{
	
	spawner = getent( "lobby_railing_guy", "targetname" );
	level.railing_guy = spawner stalingradspawn();	
	if ( spawn_failed(level.railing_guy) )
  {
    return;
  }
  
  level waittill("stumble_cutscene_done");
	level.railing_guy thread play_dialogue( "CB03_CaPoG_53A");
  
 	level.railing_guy animscripts\shared::placeWeaponOn( level.railing_guy.primaryweapon, "none" );	

 }


set_fall_down_stairs_trigger()
{
	trigger = getent( "fall_down_stairs_trigger", "targetname" );
  trigger waittill( "trigger" );

	

	level thread set_backtrack_death_trigger(); 

	level.stage = 3;
 
  

  
	
	




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
	level.privee_civilian_walkers[i]  animscripts\shared::placeWeaponOn( level.privee_civilian_walkers[i].primaryweapon, "none" );	
	level.privee_civilian_walkers[i] thread civs_bump();        

  }
}


place_courtyard_civilian_walkers()
{
  spawner = getentarray( "courtyard_civilian_walkers", "targetname");
  if ( !IsDefined( spawner) )
  {
   
    return;
  }

  for( i = 0; i < spawner.size; i++ )
  {
    level.courtyard_civilian_walkers[i] = spawner[i] stalingradspawn();

    if ( spawn_failed(level.courtyard_civilian_walkers[i]) )
    {
      return;
    } 
     
	
	
	
	

	level.courtyard_civilian_walkers[i] SetEnableSense( false );
	level.courtyard_civilian_walkers[i] lockalertstate( "alert_green" );
	level.courtyard_civilian_walkers[i]  animscripts\shared::placeWeaponOn( level.courtyard_civilian_walkers[i].primaryweapon, "none" );	
	level.courtyard_civilian_walkers[i] thread civs_bump();        

  }
}

place_anteroom_civilian_walkers()
{
  spawner = getentarray( "anteroom_civilian_walkers", "targetname");
  if ( !IsDefined( spawner) )
  {
   
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
	level.anteroom_civilian_walkers[i]  animscripts\shared::placeWeaponOn( level.anteroom_civilian_walkers[i].primaryweapon, "none" );	

	level.anteroom_civilian_walkers[i] thread civs_bump();        
	
	
	
	
  }
}


place_hallway_civilian_walkers()
{
  spawner = getentarray( "hallway_civilian_walkers", "targetname");
  if ( !IsDefined( spawner) )
  {
    
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
	level.hallway_civilian_walkers[i]  animscripts\shared::placeWeaponOn( level.hallway_civilian_walkers[i].primaryweapon, "none" );	

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
	level.lobby_civilian_walkers[i]  animscripts\shared::placeWeaponOn( level.lobby_civilian_walkers[i].primaryweapon, "none" );	

	level.lobby_civilian_walkers[i] thread civs_bump();        
   
  }
}


place_outdoor_civilian_walkers()
{
  spawner = getentarray( "outdoor_civilian_walkers", "targetname");
  if ( !IsDefined( spawner) )
  {
    
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
	level.outdoor_civilian_walkers[i]  animscripts\shared::placeWeaponOn( level.outdoor_civilian_walkers[i].primaryweapon, "none" );	

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
	
	
	
	
	
	
	while(1)
	{
		
		if( (Distance(self.origin, level.player.origin ) < 32) && (level.player GetSpeed() > 40) )
		{
			
			self play_dialogue( dialog[ randomint(3) ]);
			
			

			
			
			
			wait( 3 );
		}
		else
		{
			wait( 0.1 );
		}
	}
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
			      		
		       			self waittill("cmd_done");				
					}
		         break;
		         
		        case 1:
					while(1)
					{
			       		self CmdPlayAnim( "Gen_Civs_StandConversationV2", false );
			      		
		       			self waittill("cmd_done");				
					}		        
		         break;  
		   }
		  break;
		
		case "stand_casual":
		    while(1)
		    {
				self CmdPlayAnim( "Gen_Civs_CasualStand", false );
			    
			    self waittill("cmd_done");        
		    }
		  break;
		  
		case "stand_arms_crossed":
		    while(1)
		    {
				self CmdPlayAnim( "Gen_Civs_StndArmsCrossed", false );
			    
			    self waittill("cmd_done");        
		    }		
		  break;	
		  
		case "stand_cell_phone":
		    while(1)
		    {
				self CmdPlayAnim( "Gen_Civs_CellPhoneTalk", false );
			    
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
			    
			    self waittill("cmd_done");        
		    }
		  break;
		  
		case 1:
		    while(1)
		    {
				self CmdPlayAnim( "Gen_Civs_StndArmsCrossed", false );
			    
			    self waittill("cmd_done");        
		    }		
		  break;	
		  
		case 2:
		    while(1)
		    {
				self CmdPlayAnim( "Gen_Civs_CellPhoneTalk", false );
			    
			    self waittill("cmd_done");        
		    }			  	  	
	}	
}

#using_animtree("generic_human");
setup_car_driver(passenger)
{
	driver = Spawn( "script_model", self GetTagOrigin( "tag_driver" ) );
	driver.angles = self.angles;
	driver character\character_casino_male_1::main();
	driver LinkTo( self, "tag_driver" );
	
	driver useAnimTree(#animtree);
	driver setFlaggedAnimKnobRestart("idle", %vehicle_luxury_sedan_driver);

	if(IsDefined(passenger) && passenger)
	{
		passenger = Spawn( "script_model", self GetTagOrigin( "tag_passenger01" ) );
		passenger.angles = self.angles;
		passenger character\character_casino_male_1::main();
		passenger LinkTo( self, "tag_passenger01" );
		passenger useAnimTree(#animtree);
		passenger setFlaggedAnimKnobRestart("idle", %vehicle_luxury_sedan_passenger);
	}
}	

set_car_block_trigger()
{
	car = GetEnt("blocker","targetname");
	car setup_car_driver();
	car setDamageAI( 0 );
	path = GetVehicleNode("vehicle_start_node_blocking_car","targetname");

	car attachpath(path);

	trigger = getent( "car_block_trigger", "targetname" );
	
	trigger waittill( "trigger" );

	wait(8);	
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
		level.lane_1[i].script_int = 1; 
		maps\_vehicle::vehicle_init( level.lane_1[i] );
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
		level.lane_2[i] setup_car_driver(true);
		level.lane_2[i].script_int = 1;
		maps\_vehicle::vehicle_init( level.lane_2[i] );	
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

	for(i = 0; i < level.lane_1.size; i++)
	{
		if(attacker == level.lane_1[i])
		{
			attacker thread car_collision_reaction(1);
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

	
	wait(.25);
	
	level thread player_collision_check(); 
}


car_collision_reaction(lane_number)
{
	self setspeed(0, 20, 20);
	level.player knockback( 2000, self.origin, self);
	earthquake (.5, .75, level.player.origin, 1000);
	level.player playsound("CASP_hit_by_car");
	self playsound("CASP_car_horn_01");

	
	car_direction = VectorToAngles( self.origin - (level.player.origin) );      
	level.player SetPlayerAngles( car_direction );

	switch(lane_number)
	{
		case 1:
			level.lane_1_collision = true; 
			self thread stop_other_cars(1);  
			break;

		case 2:
			level.lane_2_collision = true; 
			self thread stop_other_cars(2);  
			break;
	}

	wait(.05);
	
	level thread player_collision_check(); 
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
					level.lane_1[i] thread car_honk();
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
					level.lane_2[i] thread car_honk();
				}
			}
		}	
		wait(.1);
	}	
}


car_honk()
{
	honk[0] = "CASP_car_horn_01";
	honk[1] = "CASP_car_horn_02";
	honk[2] = "CASP_car_horn_03";
	
	self playsound(honk[randomint(3)]);
}




reached_get_jumped_melee()
{
	earthquake (.5, 2.0, level.player.origin, 1000);

	
	
	

    
	
	

	

	

	
	
	
	














	
	
	
	
	
	
	
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
	level.parking_lot_henchmen.targetname = "thug";	

  
  
}






debug_poison_off()
{
	if( getdvar( "nopoison" ) == "1")
	{
		while(1)
		{


				
		
				
				wait(10);
				poisoneffect(false);


		}
	}
	
}


poison_sway()
{
	
	
	
	while(1)
	{
				
			flag_wait("sway_on");
			
			level.player poisonmovements(1);
			poisoneffect(true);
			SetDVar("r_bx_poison_enable_distortion", 1); 
			SetDVar("r_bx_poison_distortion_speed", 0.25); 

			while( flag("sway_on") )
			{
				wait(0.1);
			}	
			
			
			level.player poisonmovements(0);
			poisoneffect(false);
			SetDVar("r_bx_poison_enable_distortion", 0); 

			
			
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
		
	
	org = getent( "defib", "targetname" );
    org playsound( "CASP_defib" );
    level.player play_dialog("M_CaPoG_193A");
    wait(2);
 	level.player play_dialog("M_CaPoG_194A");
    wait(2);
 	level.player play_dialog("VESP_CaPoG_195A");
	wait(1);
	level.player play_dialog("VESP_CaPoG_195A");
	
	
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


ChangePassoutEffect()
{	
	self endon ( "death" );
	while(true)
	{
		if(isDefined(level.timer))
		{
			timePercentage = 1.0 - (level.current_time/(level.start_time/1000.0));
			timePercentage = min(max(timePercentage, 0.0), 1.0); 
			
			
			passoutPercent = (timePercentage	* 0.4) + 0.001;
			
			SetDVar("r_bx_poison_passOut_percent", passoutPercent);
		}
		
		wait(.1);
	}
}
