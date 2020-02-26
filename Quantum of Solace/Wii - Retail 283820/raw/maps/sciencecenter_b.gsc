#include maps\_utility;
#include maps\_bossfight;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#include maps\_equalizer;
#include maps\_weather;

main()
{
	level.strings["sciencecenter_b_collection0_name"] = &"SCIENCECENTER_B_DATA0_NAME";
	level.strings["sciencecenter_b_collection0_body"] = &"SCIENCECENTER_B_DATA0_BODY";
	
	level.strings["sciencecenter_b_collection1_name"] = &"SCIENCECENTER_B_DATA1_NAME";
	level.strings["sciencecenter_b_collection1_body"] = &"SCIENCECENTER_B_DATA1_BODY";
	
	level.strings["sciencecenter_b_collection2_name"] = &"SCIENCECENTER_B_DATA2_NAME";
	level.strings["sciencecenter_b_collection2_body"] = &"SCIENCECENTER_B_DATA2_BODY";
	
	level.strings["sciencecenter_b_collection3_name"] = &"SCIENCECENTER_B_DATA3_NAME";
	level.strings["sciencecenter_b_collection3_body"] = &"SCIENCECENTER_B_DATA3_BODY";
	
	level.strings["sciencecenter_b_collection4_name"] = &"SCIENCECENTER_B_DATA4_NAME";
	level.strings["sciencecenter_b_collection4_body"] = &"SCIENCECENTER_B_DATA4_BODY";
	
	level.strings["sciencecenter_b_collection5_name"] = &"SCIENCECENTER_B_DATA5_NAME";
	level.strings["sciencecenter_b_collection5_body"] = &"SCIENCECENTER_B_DATA5_BODY";

	
	precachecutscene( "SCB_BombHandoff" );

	
	maps\_trap_extinguisher::init(); 
	maps\_securitycamera::init();
	maps\_playerawareness::init();
	maps\sciencecenter_b_fx::main();
	
	
	

	maps\_load::main();
	maps\sciencecenter_b_snd::main();
	maps\sciencecenter_b_mus::main();
		
	
	precacheShader( "compass_map_miamisciencecenterb" );
	setminimap( "compass_map_miamisciencecenterb", 1168, 3896, -1080, -704  );

	
	
	level thread maps\miami_science_center_catwalk::main();
	level thread maps\miami_science_center_basement::main();
	
	
	setExpFog( 0, 500, 0.29, 0.29, 0.29, 0 );
		
	
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}           

	
	VisionSetNaked( "sciencecenter_b_01" );
	precachevehicle("defaultvehicle");
	
	
	precacheModel("w_t_knife_demitrios");
	
	
	level.flick_ele_light_var = false;
	level.davinchi_crashed = false;
	
	
	level thread setup_cutscenes();


	
	
	
	
	


	

	level.light_flicker = 1;
	
	
	
	level thread science_center_objectives();
	

	
	level thread skip_to_points();	

	
	
	
	
	
	
	level thread elevator_moves_up_from_security();
	
	
	
	level thread e1_camera();
	level thread monitor_cam();
	level thread setup_security_feed();
	
	
	
	level thread shut_elev_doors();
	level thread jl_ending();
	
	
	
	
	
	level.laptop = 0;        
	level.debug_text = 0;    
	

	
	
	level thread level_setup();                       
	
		

	
	
	
	
	
	
	

	
	level.player freezecontrols( false );

	
	
	

	flag_init("reached_basement");
	flag_init("reached_stairwell");
	flag_init("accessed_elevator");
	flag_init( "dimitrios_dead" );
	flag_init("success");

	level.terminate_elevator_lights = false;
	level.elevator_crashed = false;
	level.rocket_impact = false;
	level.rocket_impact2 = false;
	level.wave2_spawned = false;
	level.wave3_spawned = false;
	level.side_spawned = false;
	level.lastside_spawned = false;
	level.davinci_collapsed = false;
	level.lights_shot_down = 0;

	level notify("streamer_2_start");
	level notify("streamer_3_start");

	thread init_mainhall();

	GetEnt("player_at_catwalk1_door", "script_noteworthy") maps\miami_science_center_catwalk::catwalk1();	
}



watch_checkpoints()
{
	
	
	level waittill("checkpoint_reached");
	
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	
	
	level waittill("checkpoint_reached");
	
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	
	
	level waittill("checkpoint_reached");
	
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	
	
	level waittill("checkpoint_reached");
	
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	
	
	level waittill("checkpoint_reached");
	
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	
	
	level waittill("checkpoint_reached");
	
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	
	
	level waittill("checkpoint_reached");
	
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	
	
	level waittill("checkpoint_reached");
	
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	
	
	level waittill("checkpoint_reached");
	
	level maps\_autosave::autosave_now("MiamiScienceCenter");
}



level_setup() 
{
	
	
	
	
	
	level.debug_text = 1;
	
	
	
	maps\_phone::setup_phone();
	
	level waittill ( "ready_mainhall" );
	
	
	
		
	
	
	
	
	
	
		
	
	
	level thread wave3_fx_end();                                         
	
		
	
	
	level thread elevator_shot_by_bond_and_falls(); 
	

	
	
	
	level thread main_hall_audio_earpiece();    	
	level thread merc_audio_lights_shot();      	
	level thread merc_audio_stairwell();          
	level thread mercs_audio_he_is_the_middle();  
	level thread merc_audio_underneath_us();      
	level thread mercs_audio_behind_display();    
	level thread mercs_audio_second_to_second();  
	level thread mercs_audio_lights_shotdown();   
	level thread mercs_audio_he_is_left();        
	
	
	
	
	
	
	
	
	
	level thread stairwell_lights_off();	
	
	
	
	level thread music_controller();                              
	
}








global_delete_end_node()
{
	if (( isdefined ( self )) && ( !level.player islookingat( self )))
	{
		wait( .5 );
		self delete();
	}
}



setup_cutscenes()
{
	level thread preview_cutscene();
}



preview_cutscene()
{
	
	strIGC = GetDVar( "preview");
	if(	!IsDefined(	strIGC ) )
	{
		return;
	}

	
	if(	 strIGC	== "MM_SC_0201"	)
	{
		
		wait(	2	);
		
		PlayCutScene(	strIGC,	"scene_anim_done"	);

	}
	else if(	 strIGC	== "MM_SC_0301"	)
	{
		
		wait(	2	);
		
		PlayCutScene(	strIGC,	"scene_anim_done"	);

	}
	
	
	level	waittill(	"scene_anim_done"	);
	preview_cutscene();
	
}



































































mission_success()
{	
	level notify("music_end_stinger");

	
	
	flag_set("success");
	
	

	wait( 2 );
	level.player play_dialogue("TANN_GlobG_019A", true);	
	wait( 3 );
	maps\_endmission::nextmission();
}











thug_attack_elev()
{
	dimi_boss = getent( "dimi_boss_fight", "script_noteworthy" );
	level.dimitrous = dimi_boss stalingradspawn();
	level.dimitrous thread main_hail_floor1_attack1();

	
	main_shooting_thugs = getent( "main_shooting_thugs", "targetname" );
	
	thug = main_shooting_thugs stalingradspawn("elevator_guards");
	if( !maps\_utility::spawn_failed( thug) )
	{
		thug.accuracy = 0.5; 
		thug thread main_hail_floor1_attack1(); 
	}
	
	wait( 1.5 );
	
	
	ai = getaiarray();
	for(i=0;i<ai.size;i++)
	{
		if( i == 0 )
		{
			if (isalive(ai[i]))
			{
				ai[i] play_dialogue ("SSF2_SciBG02A_070A", false); 
				
				ai[i] CmdAction( "CallOut"); 
				wait( 0.4 );
			}
		}
		else if( i == 1 )
		{
			if (isalive(ai[i]))
			{
				ai[i] play_dialogue ("SHM2_MiaG02A_005A", false);
				ai[i] CmdAction( "Aim", true ); 
				wait( 0.7 );
			}
		}
		else if( i == 2 )
		{
			if (isalive(ai[i]))
			{
				ai[i] play_dialogue ("SHM3_MiaG02A_006A", false);
				ai[i] CmdAction( "Aim", true ); 
				wait( 2.3 );
				if (isalive(ai[i]))
				{
					ai[i] play_dialogue ("SHM1_MiaG02A_011A", false); 
					wait( 2.5 );
				}
				if (isalive(ai[i]))
				{
					ai[i] play_dialogue ("SHM1_MiaG02A_009A", false); 
				}
			}
		}		
	}
}

main_hail_floor1_attack1() 
{
				self endon("death");
				
				shoot_spot = getent( "shoot_spot", "targetname" );
				
				target = getent("target_crate_elevator", "targetname");
				
				level waittill ("thug_attack_elev_now");
				wait( 3.5 );
				self setenablesense( false );
				
				self CmdShootAtPos( shoot_spot.origin );
				
				thread explosion_outside_elevator();
				
				if (isdefined(target))
				{
					target delete();
				}
				wait( 5.4 );
				
				if (isdefined(self))
				{
					self stopallcmds();
					self lockalertstate( "alert_red" ); 
					node = getnode( "poop2", "targetname");
					self setscriptspeed("sprint");
					self setgoalnode ( node );
					
					if( (isdefined (self.script_noteworthy)) && (self.script_noteworthy == "dimi_boss_fight") )
					{
							node = getnode( "surprise_player", "targetname");
							self setgoalnode ( node );
							self thread surprise_bond();
					}	
				}
				
			
			thread spawn_elevator_exit();
}


surprise_bond()
{
	
	trigger = getent ( "surprise_player_now", "targetname" );
	trigger waittill ( "trigger" );
	self setenablesense(true);
	self setgoalentity( level.player );
	self setcombatrole("rusher");
	self setperfectsense( true );
	self play_dialogue("SAM_E_4_FrRs_Cmb", true);	

}


turn_last_2_guys_into_rusher()
{
	while (1)
	{
		ai = GetAIArray("axis");
		if ( ai.size <= 3 )
		{
			for (i = 0; i < ai.size; i++)
			{
				
				
					ai[i] SetCombatRole("Rusher");
					ai[i] setgoalentity( level.player );
					break;
				
			}
		}
		wait( 1.0 );
	}
}




fire_at_bond()
{
	trigger = getent ( "main_shooting_bond", "targetname" );
	trigger waittill ( "trigger" );
	
	if ( isalive ( self ) ) 
	{
		self setenablesense( true, 5 );
		self CmdShootAtPos( level.player.origin );
	}
}



go_after_bond()
{
	level waittill ( "thugs_run_to_second_floor" );
	if ( isalive ( self ) ) 
	{
		self setenablesense( true );
	}
}



wave1_battle_controller() 
{
	thread wave1_thugs();
}


wave1_thugs() 
{
		getent("wave1_start_trigger", "script_noteworthy") waittill("trigger");
		
		level notify ( "thugs_run_to_second_floor" );	
		level thread wave1_thugs_spawn_move();
}

wave1_thugs_spawn_move() 
{
	wait( 2 );





	
	wave1_shooting_thugs = getentarray ( "mainhall_thugs_1", "script_noteworthy" );
	
	
	for ( i = 0; i < wave1_shooting_thugs.size; i++ )
	{
		thug[i] = wave1_shooting_thugs[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] lockalertstate( "alert_red" );
			wait( 0.5 );
			thug[i] setscriptspeed("sprint");
			thug[i] forceperceive( level.player );



		}
	}
	
}


clear_coverlist(timer)
{
	wait( timer );
  self setcoverlist ("");
}
		
wave2_battle_controller() 
{
	
	getent("wave2_start_trigger", "script_noteworthy") waittill("trigger");

	level notify ("vo_everyone_to_the_first_floor_os2"); 
	
	level thread wave2_thugs_spawn_move(); 
}

wave2_thugs_spawn_move()
{
	wave2_shooting_thugs = getentarray ( "mainhall_thugs_2nd", "script_noteworthy" );
	
	
	for ( i = 0; i < wave2_shooting_thugs.size; i++ )
	{
		thug[i] = wave2_shooting_thugs[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i].accuracy = 0.7;
			thug[i] lockalertstate( "alert_red" );
			thug[i] setperfectsense( true );
			thug[i] setscriptspeed("sprint");
		}
	}
}

wave3_battle_controller() 
{
	getent("wave3_start_trigger", "script_noteworthy") waittill("trigger");
	thread wave3_thugs_spawn_move(); 
	
	wait( 20 );
	level notify ("vo_enemy_is_trapped_hold_positions_os2");
}	


wave3_thugs_spawn_move()
{
	thug_spawn = getentarray ( "mainhall_thugs_3rd", "script_noteworthy" );
	
	level notify ("davinchi_start"); 
	level notify("end_explosion_now");	
	
	for ( i = 0; i < thug_spawn.size; i++ )
	{
		thug[i] = thug_spawn[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] setperfectsense( true );
			thug[i].accuracy = 0.7;
			thug[i] lockalertstate( "alert_red" );
			thug[i] setscriptspeed("sprint");
		}
	}
	wait( 5 );
	level notify ("vo_fallback_fallback_os2"); 
}	


loop_davinchi()
{
	wait( 5 );
	while( 1 )
	{
		wait( 18 );
	
	}
}


wave3_fx_end()
{
	
	
	
	
	
	
	
	
	
	
	
	
	level waittill ("end_explosion_now");
	org = spawn("script_origin",  (-1.3, 1278.3, 336) );
	org	playsound ("davinci_crash");

	
	level thread wave3fx_end_quake_timing();
	wait( 5 ); 
	
	wait( 4 );
	
	wait( 0.2 );
	
	wait( 0.2 );
	
	wait( 0.2 );

	
	
	
}


wave3fx_end_quake_timing()
{
	earthquake( 0.5, 1, level.player.origin, 300 ); 
	wait( 5 );		

	
	
	

	earthquake( 0.6, 1, level.player.origin, 300 ); 
	wait( 4 );
	
	earthquake( 0.6, 1.6, level.player.origin, 300 ); 
}





access_camera_controls()
{
	
	

	
	

	level notify("move_elevator_to_position");
	
	wait (2.0);
	
	
	securityElevInnerLeftDoor = GetEnt ("securityElevInnerLeftDoor", "targetname");
	securityElevInnerRightDoor = GetEnt ("securityElevInnerRightDoor", "targetname");
	securityElevOuterLefttDoorSecRoom = GetEnt ("securityElevOuterLefttDoorSecRoom", "targetname");
	securityElevOuterRightDoorSecRoom = GetEnt ("securityElevOuterRightDoorSecRoom", "targetname");
	
	
	
	basement_blocker = getent("ele_blocker_clean","targetname"); 
	elevator_trigger = GetEnt( "basement_start_ele", "targetname" );

	
	securityElevOuterLefttDoorSecRoom movex ( 35.0, 1.0, 0.25, 0.25);
	securityElevOuterRightDoorSecRoom movex ( -35.0, 1.0, 0.25, 0.25);

	
	
	

	
	securityElevInnerLeftDoor movex ( 35.0, 1.0, 0.25, 0.25);
	securityElevInnerRightDoor movex ( -35.0, 1.0, 0.25, 0.25);	
	
	securityElevInnerRightDoor playsound("Elevator_Doors_Open");
	securityElevInnerRightDoor waittill("movedone");
	
	
	closed = false;
	
	elevator_trigger waittill("trigger");

	while( 1 )
	{
		if( closed )
		{
			
			if( level.player.origin[1] > basement_blocker.origin[1] && distancesquared( level.player.origin, basement_blocker.origin ) > 60*60 )
			
			{
				
				level notify("safe_to_close");
				break;
			}
			else
			{
				
				
				
				
				securityElevInnerLeftDoor movex ( 35.0, 1.0, 0.25, 0.25);
				securityElevInnerRightDoor movex  ( -35.0, 1.0, 0.25, 0.25);	

				
				securityElevOuterLefttDoorSecRoom movex ( 35.0, 1.0, 0.25, 0.25);
				securityElevOuterRightDoorSecRoom movex ( -35.0, 1.0, 0.25, 0.25);
				
				securityElevInnerRightDoor playsound("Elevator_Doors_Open");
				securityElevOuterRightDoorSecRoom waittill("movedone");
				wait( 0.5 );
				closed = false;
				elevator_trigger waittill("trigger");
			}
		}
		else if( level.player.origin[1] > basement_blocker.origin[1] && distancesquared( level.player.origin, basement_blocker.origin ) > 60*60 )
		{
			
			
			
			
			securityElevInnerLeftDoor movex ( -35.0, 1.0, 0.25, 0.25);
			securityElevInnerRightDoor movex ( 35.0, 1.0, 0.25, 0.25);	

			
			securityElevOuterLefttDoorSecRoom movex ( -35.0, 1.0, 0.25, 0.25);
			securityElevOuterRightDoorSecRoom movex ( 35.0, 1.0, 0.25, 0.25);
				
			securityElevInnerRightDoor playsound("Elevator_Doors_Close");
			securityElevOuterRightDoorSecRoom waittill("movedone");
			closed = true;
			wait(0.5);
		}
		
		wait( 0.1 );
	}
	
	
	
	
	

	
	
	
	
	
	
	
	
	
}		

spark(origin)
{
	sound_ent = Spawn("script_origin", origin);
	
	for (i = 0; i < 7; i++)
	{
		Playfx(level._effect["science_lamp_sparks"], origin); 
		waittillframeend;
	}
}


elevator_moves_up_from_security()
{
	
	
	elevator_ladder = GetEnt("ladder01", "targetname");
	elevator_ladder hide();

	level waittill("move_elevator_to_position");
	securityElevMain = GetEnt ("securityElevMain", "targetname");

	
	
	

	tiles = GetEntArray("elevator_tile", "targetname");
	for (i = 0; i < tiles.size; i++)
	{
		tiles[i] LinkTo(securityElevMain);
	}
	
	elevator_button_basement = getent("elevator_button_basement", "targetname");
	elevator_button_firstfloor = getent("elevator_button_firstfloor", "targetname");
	elevator_button_secondfloor = getent("elevator_button_secondfloor", "targetname");

	
	securityElevInnerLeftDoor = GetEnt ("securityElevInnerLeftDoor", "targetname");
	securityElevInnerRightDoor = GetEnt ("securityElevInnerRightDoor", "targetname");

	securityElevOuterLeftDoor_00 = GetEnt ("securityElevOuterLeftDoorMainHall_00", "targetname");
	securityElevOuterRightDoor_00 = GetEnt ("securityElevOuterRightDoorMainHall_00", "targetname");

	securityElevOuterLeftDoor = GetEnt ("securityElevOuterLeftDoorMainHall", "targetname");
	securityElevOuterRightDoor = GetEnt ("securityElevOuterRightDoorMainHall", "targetname");

	
	
	

	EleFloor_light = GetEnt ("EleFloor_light", "targetname"); 
	
	

	
	EleLightModel = Spawn( "script_model", ( -17, 3113, 3.5 ));
	
	
	EleLight = GetEnt ("EleLight", "targetname"); 
	
	
	

	securityElevHatch = GetEnt ("securityElevHatch", "targetname");
	securityElevReentry_clip = getent("elev_reentry_clip", "targetname");
	securityElevHatch_trig = getent("trigger_enter_ele_climb", "targetname");
	securityElevHatch_trig trigger_off();
	securityElevLitButton = GetEnt ("EleFloor_light", "targetname");
	

	
	
	
	
	
	

	
	
	og_angles = elelight.angles;
	EleLight linkLightToEntity(securityElevMain);
	EleLight.origin = (0,0,0);	
	EleLight.angles = og_angles;
	
	EleFloor_light LinkTo(securityElevMain);
	EleLightModel LinkTo(securityElevMain);
	securityElevReentry_clip LinkTo(securityElevMain);
	
	
	
	


	elevator_button_basement LinkTo(securityElevMain);
	elevator_button_firstfloor LinkTo(securityElevMain);
	elevator_button_secondfloor LinkTo(securityElevMain);

	

	
	securityElevMain movez ( -224, 0.1 );
	
	
	level.elevator_light_floor0 movez ( -224, 0.1 );
	level.elevator_light_floor1 movez ( -224, 0.1 );
	level.elevator_light_floor2 movez ( -224, 0.1 );
	securityElevInnerLeftDoor movez ( -224, 0.1 );
	securityElevInnerRightDoor movez ( -224, 0.1 );
	securityElevHatch movez ( -224, 0.1 );

	
	
	
	
	level waittill("safe_to_close");
	
	
	
	

	
	level notify ( "ready_mainhall" );
	
	level notify("endmusicpackage");
	
	
	
	
	
	
	

	
	
	
	player_unstick();

	
	
	
	
	thread delete_all_ai();
	thread delete_basement_spawners();
	thread delete_basement_triggers();


	
	securityElevBondAwareness = GetEnt ("securityElevHatchDamage", "script_noteworthy");
	
	
	wait( 1 );
	

	
	
	
	
	
	
	
	
	wait( 1 );
	
	
	
	
	
	level notify ("vo_going_down_ele_sec_os1"); 
	wait( 0.5 );
	
	
	level.player playsound("Elevator_To_Dimitrios");
	wait( 2.6 );
	
	
	securityElevOuterLeftDoor movex ( 35.0, 1.0, 0.25, 0.25);
	securityElevOuterRightDoor movex ( -35.0, 1.0, 0.25, 0.25);

	wait( 2 );
	
	
	
	
	
	
	
	
	if (Getdvar("cinematicText") == "on")
	{
	
	}
	
	
	level notify("elevator_up");
	securityElevMain movez ( 224, 6, 1, 1);
	
	
	level.elevator_light_floor0 movez ( 224, 6, 1, 1);
	level.elevator_light_floor1 movez ( 224, 6, 1, 1 );
	level.elevator_light_floor2 movez ( 224, 6, 1, 1 );
	securityElevInnerLeftDoor movez ( 224, 6, 1, 1 );
	securityElevInnerRightDoor movez ( 224, 6, 1, 1 );
	securityElevHatch movez ( 224, 6, 1, 1 );
	
	wait ( 7 );
	
	
	
	
	

	
	

	
	level notify ("vo_locate_on_first_floor_os2");
	level thread thug_attack_elev();

	securityElevInnerLeftDoor movex ( 35.0, 1.0, 0.25, 0.25);
	securityElevInnerRightDoor movex ( -35.0, 1.0, 0.25, 0.25);

	securityElevOuterLeftDoor_00 movex ( 35.0, 1.0, 0.25, 0.25);
	securityElevOuterRightDoor_00 movex ( -35.0, 1.0, 0.25, 0.25);
	securityElevInnerRightDoor playsound("Elevator_Doors_Open");

	

	wait(1.0);
	level notify ("thug_attack_elev_now");


	wait(1.0 );

	
	securityElevInnerLeftDoor movex ( -15.0, 0.7, 0.25, 0.25);
	securityElevInnerRightDoor movex ( 15.0, 0.7, 0.25, 0.25);

	
	securityElevOuterLeftDoor_00 movex ( -25.0, 0.7, 0.25, 0.25);
	securityElevOuterRightDoor_00 movex ( 25.0, 0.7, 0.25, 0.25);
	securityElevInnerRightDoor playsound("Elevator_Doors_Jammed");

	wait( 0.3 );
	earthquake( 0.15, 0.4, level.player.origin, 2050 );

	wait( 0.5 );

	
	securityElevInnerLeftDoor movex ( -3, 0.7, 0.01, 0.01);
	securityElevInnerRightDoor movex ( 3, 0.7, 0.01, 0.01);
	securityElevInnerRightDoor waittill ("movedone");
	wait( 0.2 );

	
	securityElevOuterLeftDoor_00 movex ( -5, 0.7, 0.01, 0.01);
	securityElevOuterRightDoor_00 movex ( 5, 0.7, 0.01, 0.01);

	wait( 0.4 );
	
	
	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	
	

	securityElevMain movez ( -15, 0.4, 0.1, 0.1 );
	
	
	level.elevator_light_floor0 movez ( -15, 0.4, 0.1, 0.1 );
	level.elevator_light_floor1 movez ( -15, 0.4, 0.1, 0.1 );
	level.elevator_light_floor2 movez ( -15, 0.4, 0.1, 0.1 );
	securityElevInnerLeftDoor movez ( -15, 0.4, 0.1, 0.1 );
	securityElevInnerRightDoor movez ( -15, 0.4, 0.1, 0.1 );
	securityElevHatch movez ( -15, 0.4, 0.1, 0.1 );

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	securityElevMain playsound("Elevator_Wild_Ride");
	securityElevInnerLeftDoor thread sound_ele_loop_here(); 
	securityElevMain waittill ("movedone");
	earthquake( 0.15, 1, level.player.origin, 2050 );
	EleLight thread light_flicker(true, 0, 1.5);

	earthquake( 0.15, 0.4, level.player.origin, 2050 );

	wait 1;

	EleLight thread light_flicker(false, .8);

	
	wait ( 1.3 );

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	
	securityElevMain movez ( -20, 0.5, 0.1, 0.1);
	
	
	level.elevator_light_floor0 movez ( -20, 0.5, 0.1, 0.1 );
	level.elevator_light_floor1 movez ( -20, 0.5, 0.1, 0.1 );
	level.elevator_light_floor2 movez ( -20, 0.5, 0.1, 0.1 );
	securityElevInnerLeftDoor movez ( -20, 0.5, 0.1, 0.1 );
	securityElevInnerRightDoor movez ( -20, 0.5, 0.1, 0.1 );
	securityElevHatch movez ( -20, 0.5, 0.1, 0.1 );
	securityElevInnerRightDoor waittill ("movedone");
	
	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	EleLight thread light_flicker(true, 0, 1.5);
	earthquake( 0.20, 1, level.player.origin, 2050 );
	playfx ( level._effect["ele_dust2a"], securityElevMain.origin + (0, 0, -100));

	wait 1.4;

	EleLight thread light_flicker(false, .8);

	
	wait( 2.0 );

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	EleLight thread light_flicker(true, 0, 1.5);
	securityElevMain movez ( -27, 0.22, 0.1, 0.1 );
	
	
	level.elevator_light_floor0 movez ( -27, 0.22, 0.1, 0.1 );
	level.elevator_light_floor1 movez ( -27, 0.22, 0.1, 0.1 );
	level.elevator_light_floor2 movez ( -27, 0.22, 0.1, 0.1 );
	securityElevInnerLeftDoor movez ( -27, 0.22, 0.1, 0.1 );
	securityElevInnerRightDoor movez ( -27, 0.22, 0.1, 0.1 );
	securityElevHatch movez ( -27, 0.22, 0.1, 0.1 );
	securityElevInnerRightDoor waittill ("movedone");

	

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	earthquake( 0.5, 0.7, level.player.origin, 2050 );
	playfx ( level._effect["ele_dust2a"], securityElevMain.origin + (0, 0, -100));
	
	
	spark(GetEnt("elevator_sparks", "targetname").origin);
	EleLight thread light_flicker(false, .8);

	
	wait ( 6 );

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	EleLight thread light_flicker(true, 0, 1.2);
	securityElevMain movez ( -30, 0.23, 0.1, 0.1 );
	
	
	level.elevator_light_floor0 movez ( -30, 0.23, 0.1, 0.1 );
	level.elevator_light_floor1 movez ( -30, 0.23, 0.1, 0.1 );
	level.elevator_light_floor2 movez ( -30, 0.23, 0.1, 0.1 );
	securityElevInnerLeftDoor movez ( -30, 0.23, 0.1, 0.1 );
	securityElevInnerRightDoor movez ( -30, 0.23, 0.1, 0.1 );
	securityElevHatch movez ( -30, 0.23, 0.1, 0.1 );
	securityElevInnerRightDoor waittill ("movedone");

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	earthquake( 0.3, 0.2, level.player.origin, 2050 );
	playfx ( level._effect["ele_dust2a"], securityElevMain.origin + (0, 0, -100));

	wait( 0.1 );

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	securityElevMain movez ( -5, 0.10, 0.01, 0.01 );
	
	
	level.elevator_light_floor0 movez ( -5, 0.10, 0.01, 0.01 );
	level.elevator_light_floor1 movez ( -5, 0.10, 0.01, 0.01 );
	level.elevator_light_floor2 movez ( -5, 0.10, 0.01, 0.01 );
	securityElevInnerLeftDoor movez ( -5, 0.10, 0.01, 0.01 );
	securityElevInnerRightDoor movez ( -5, 0.10, 0.01, 0.01 );
	securityElevHatch movez ( -5, 0.10, 0.01, 0.01 );
	
	securityElevInnerRightDoor waittill ("movedone");

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	playfx ( level._effect["ele_dust2a"], securityElevMain.origin + (0, 0, -100));
	earthquake( 0.8, 1, level.player.origin, 2050 );
	level notify("player_cause_ele_crash");
	level notify("elevator_down");
	
	wait(1.0);
	level notify ("vo_cant_lock_the_elevator_os2");

	wait(2.0);
	securityElevMain playsound("Elevator_Hatch_Fall_Open");

	
	
	securityElevHatch rotateto ( ( 0, 0 , -90), 0.3, 0.1, 0.1 );

	VisionSetNaked( "sciencecenter_b_05", 1.0);

	securityElevHatch waittill("rotatedone");
	securityElevHatch LinkTo(securityElevMain);
	
	
	
	elevator_ladder show();
	
	
	securityElevInnerLeftDoor LinkTo(securityElevMain);
	securityElevInnerRightDoor LinkTo(securityElevMain);
	level thread force_camera_initializer();
	securityElevOuterLeftDoor_00 movex ( -5, 0.7, 0.01, 0.01);
	securityElevOuterRightDoor_00 movex ( 5, 0.7, 0.01, 0.01);

	EleLight thread light_flicker(false, .5);
	wait 1.5;
	EleLight thread elevator_light_flicker();

	
	
	
	
	
	
	

	
	level waittill("player_cause_ele_crash");
	EleLightModel delete();

	
	
}

elevator_light_flicker()
{
	self endon("player_cause_ele_crash");
	while (true)
	{
		self thread light_flicker(true, 0, .8);
		wait RandomFloatRange(2, 3);
		self thread light_flicker(false, .5);
		wait RandomFloatRange(3, 5);
	}
}


sound_ele_loop_here()
{
	wait( 15.1 );
	self playloopsound("Elevator_Creak_Loop");
	level waittill("stop_ele_creak_sound");
	self stoploopsound();
}



elevator_shot_by_bond_and_falls()
{


































	securityElevMain = GetEnt ("securityElevMain", "targetname");

	
	
	
	level waittill("start_elev_crashing");
	
	
	
	

	
	securityElevMain playsound("Elevator_Crash");
	wait( .050 );
	level notify("stop_ele_creak_sound");
	level notify("on_second_floor");
	
	
	
	thread elevator_sparks();
	
	
	securityElevMain movez ( -700, 0.8, 0.5, 0.1 );
	
	
	level.elevator_light_floor0 movez ( -700, 0.8, 0.5, 0.1 );
	level.elevator_light_floor1 movez ( -700, 0.8, 0.5, 0.1 );
	level.elevator_light_floor2 movez ( -700, 0.8, 0.5, 0.1 );
	
	level.elevator_light_floor2 waittill ("movedone");
	earthquake( 0.20, 1, level.player.origin, 2050 );
	
	
	level notify("fireball");
	level.elevator_crashed = true;

	
	
	wait(0.15);	
	playfx(level._effect["elev_expl"], securityElevMain.origin + (0, 0, -160));
	
	wait(1.1);
	playfx(level._effect["fireball_01"], securityElevMain.origin + (0, 0, -150));	
}
















force_camera_initializer()
{
	enter_trigger = getEnt("trigger_enter_ele_climb", "targetname");
	enter_trigger trigger_on();
	enter_trigger waittill("trigger");
	
	
	level.player waittill("ladder", notice);
	
	if(notice == "begin")
	{
		level notify("start_elev_crashing");
		level.exit_trigger = getEnt("trigger_exit_ele_climb", "targetname");
		thread elevator_camera();

		thread slow_down_time();

		
		level waittill("fireball");
		wait(0.45);	
		thread speed_up_time();
	}
}
slow_down_time()
{
	self endon("fireball");
	
	while(1)
	{
		curr_timescale = getdvarfloat("timescale");
		if(curr_timescale > 0.3)
		{
			
			
			curr_timescale -= 0.04; 
			SetSavedDVar("timescale", "" + curr_timescale + "");
			
		}
		else
		{
			SetSavedDVar("timescale", "0.3");
			break;
		}
		
		wait(0.05);
	}
}
speed_up_time()
{
	
	while(1)
	{
		curr_timescale = getdvarfloat("timescale");
		if(curr_timescale < 1.0)
		{
			
			
			curr_timescale += 0.007; 
			SetSavedDVar("timescale", "" + curr_timescale + "");

			
			
			if(curr_timescale > 0.47)
			{
				
				trigger = getent("triggerhurt_elevator", "targetname");
				trigger trigger_on();
			}
		}
		else
		{
			SetSavedDVar("timescale", "1.0");
			break;
		}
		
		wait(0.05);
	}
}
elevator_camera()
{
	level.exit_trigger waittill("trigger");
	wait(0.05);
	
	earthquake(0.75, 2, level.player.origin, 300);
	level.player shellshock("default", 3);
}






main_hall_audio_earpiece()
{
	level waittill ("vo_going_down_ele_sec_os1");
	
	
	level.player play_dialogue ("SCS3_SciBG02A_037A", true);
	
	level waittill ("vo_locate_on_first_floor_os2");
	
	
	level.player play_dialogue ("SHM3_SciBG02A_042A", true);
	
	level waittill ("vo_cant_lock_the_elevator_os2");
	wait( 4 );
	
	
	
	
	level.player play_dialogue ("SCS3_SciBG02A_051A", true);
	
	level waittill ("vo_He_is_on_the_second_floor_os2");
	
	
	
	level.player play_dialogue ("SCS3_SciBG02A_052A", true);
	
	
	
	
	wait( 4 ); 
	
	
	level.player play_dialogue ("SCS3_SciBG02A_053A", true);
	
	level waittill ("vo_everyone_to_the_first_floor_os2");
	
	
	
	level.player play_dialogue ("SCS3_SciBG02A_056A", true);
	
	wait( 2.3 );
	
	
	
	
	level.player play_dialogue ("SCS3_SciBG02A_057A", true);
	
	wait( 5 );
	
	
 	
 	
 	
 
 	
 	wait( 3.2 );
  	
 	
 	
	
	 
	level waittill ("vo_enemy_is_trapped_hold_positions_os2");
	
 	
 	
 	level.player play_dialogue ("SCS3_SciBG02A_075A", true);
 
 	wait(4.0);
 
 	
 	
	
 	level.player play_dialogue ("SCS3_SciBG02A_076A", true);
}






merc_audio_lights_shot()
{
	
	
	
	level waittill("lights_shot");
	talker1 = get_closest_ai( level.player.origin, "axis");	
	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_067A", false);
	}
}

merc_audio_underneath_us()
{
	
	
	
	getent("merc_vo_trig_underneath", "targetname") waittill("trigger");
	talker1 = get_closest_ai( level.player.origin, "axis");	
 	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SSF1_SciBG02A_068A", false);
	}
}

merc_audio_stairwell()
{
	
	getent("merc_vo_trig_by_stairs", "targetname") waittill("trigger");
	level notify( "stair_light_off_now" );
	talker1 = get_closest_ai( level.player.origin, "axis");	
	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_058A", false);  
	}
}

mercs_audio_he_is_the_middle()
{
	
	
	getent("merc_vo_trig_by_models", "targetname") waittill("trigger");
	talker1 = get_closest_ai( level.player.origin, "axis");	
	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_062A", false);
	}
}

mercs_audio_behind_display()
{
	
	
	getent("merc_vo_trig_behind_display", "targetname") waittill("trigger");
	talker1 = get_closest_ai( level.player.origin, "axis");	
	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_059A", false);
	}
}

mercs_audio_second_to_second()
{
	
 	
 	
 	level waittill("2nd_floor_to_floor_vo");
 	talker1 = get_closest_ai( level.player.origin, "axis");	
 	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_055A", false);
	}
}

mercs_audio_lights_shotdown()
{
	
	
	
	
	
	level waittill("lights_shot_down");
	talker1 = get_closest_ai( level.player.origin, "axis");	
 	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_066A", false);
	}
}

mercs_audio_he_is_left()
{
	
	
	getent("merc_vo_trig_on_the_left", "targetname") waittill("trigger");
	talker1 = get_closest_ai( level.player.origin, "axis");	
 	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_061A", false);
	}
}

mercs_audio_by_scaf()
{
		
		
	getent("merc_vo_trig_by_the_scaf", "targetname") waittill("trigger");
	talker1 = get_closest_ai( level.player.origin, "axis");	
	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_063A", false);
	}
}





music_controller()
{
	
	
	level waittill ("music_med1_on_knife"); 
  	wait( 1.5 );
  	
	level waittill("on_second_floor");
	level notify("clear_ele_path");
	
	
	
	
	
	
	
	
	level waittill("music_end_stinger");
	
	wait( 3 );
	
}







elevator_button_hide()
{
	elevator_button_basement = getent("elevator_button_basement", "targetname");
	
	
	
	
	level.elevator_light_floor0 = getent("elevator_light_0", "targetname");
	level.elevator_light_floor1 = getent("elevator_light_1", "targetname");
	level.elevator_light_floor2 = getent("elevator_light_2", "targetname");
	
	level.elevator_light_floor1 hide();
	level.elevator_light_floor2 hide();
	
	elevator_button_basement hide();
	
	
	
	thread elevator_light_floor();
}


elevator_light_floor()
{
	level waittill("elevator_up");
	
	wait(3.0);
	
	level.elevator_light_floor0 hide();
	level.elevator_light_floor1 show();
	
	wait(4.0);
	
	
	
	
	level waittill("elevator_down");
	
	wait(0.3);
	
	
		
	while(!(level.terminate_elevator_lights))
	{
		level.elevator_light_floor0 show();
		wait(0.1);
		level.elevator_light_floor0 hide();
		level.elevator_light_floor1 show();
		wait(0.1);
		level.elevator_light_floor1 hide();
	}
}


stairwell_lights_off() 
{

		getent("stairwell_light_off", "targetname") waittill("trigger");
		stairlights = getEntArray( "stairwell_light", "targetname" );
		
		
		level notify ( "thugs_run_to_second_floor" );	
		
		for( i = 0; i < stairlights.size; i++ )
		{		

				stairlights[i] thread stairwell_lights_off_action();	
				if( (isdefined (stairlights[i].script_noteworthy)) && (stairlights[i].script_noteworthy == "stairwell_light_end") )
				{
				

				}




		}
}

stairwell_lights_loop()
{
	while( 1 )
	{
				
				wait( 1 + randomfloat( .1 ) );
				self setlightintensity ( 0 );
				wait( .05 + randomfloat( .1 ) );
				self setlightintensity ( 1 );
				wait( 2 + randomfloat( 4 ) );
				self setlightintensity ( .2 );
				wait( .05 + randomfloat( .1 ) );
				self setlightintensity ( 0 );
	}
}

stairwell_lights_off_action()
{



				

				wait( .03 + randomfloat( .1 ) );
				self setlightintensity ( .5 );
				wait( .05 + randomfloat( .1 ) );
				self setlightintensity ( .2 );
				wait( .05 + randomfloat( .1 ) );
				self setlightintensity ( 0 );
				wait( .05 + randomfloat( .1 ) );
				self setlightintensity ( .3 );
				wait( .03 + randomfloat( .1 ) );
				self setlightintensity ( 0 );
				wait( .05 + randomfloat( .1 ) );
				self setlightintensity ( .07 );
				wait( .05 + randomfloat( .1 ) );
				self setlightintensity ( .2 );
				wait( .05 + randomfloat( .03 ) );
				self setlightintensity ( 0 );

}


science_center_objectives()
{
	objective_00 = GetEnt( "objective_catwalk", "targetname" );
	objective_01 = GetEnt( "objective_clear", "targetname" );
	objective_02 = GetEnt( "objective_basement", "targetname" );
	objective_03 = GetEnt( "objective4_marker", "targetname" );
	objective_04 = GetEnt( "objective_mainhall", "targetname" );
	
	level waittill("introscreen_complete");
	
	
	
	objective_add( 1, "active", &"SCIENCECENTER_B_OBJECTIVE_CATWALK_HEADER", ( objective_00.origin ), &"SCIENCECENTER_B_OBJECTIVE_CATWALK_BODY" );
	
	trigger_obj_01 = getent("trigger_reached_maincatwalk", "targetname");
	trigger_obj_01 waittill("trigger");

	VisionSetNaked("Sciencecenter_b_02", 1.0);
	setExpFog(453.908,932.352,0.335938,0.304688,0.34375, 1.0);

	
	objective_state(1, "done");
	
	
	
	objective_add( 2, "active", &"SCIENCECENTER_B_OBJECTIVE_CLEAR_HEADER", ( objective_01.origin ), &"SCIENCECENTER_B_OBJECTIVE_CLEAR_BODY" );
	
	flag_wait("reached_stairwell");
	
	objective_state(2, "done");
	
	
	
	objective_add( 3, "active", &"SCIENCECENTER_B_OBJECTIVE_BASEMENT_HEADER", ( objective_02.origin ), &"SCIENCECENTER_B_OBJECTIVE_BASEMENT_BODY" );
	
	flag_wait("reached_basement");
	
	objective_state(3, "done");
	
	
	
	objective_add( 4, "active", &"SCIENCECENTER_B_OBJECTIVE_DIMITRIOS_HEADER", ( objective_03.origin ), &"SCIENCECENTER_B_OBJECTIVE_DIMITRIOS_BODY" );
	
	flag_wait("accessed_elevator");
	
	objective_state(4, "done");
	
	
	
	objective_add( 5, "active", &"SCIENCECENTER_B_OBJECTIVE_CARLOS_HEADER", ( objective_04.origin ), &"SCIENCECENTER_B_OBJECTIVE_CARLOS_BODY" );
	
	flag_wait("success");
	
	objective_state(5, "done");
}















init_mainhall()
{
	
	
	
	level.triggerhurt = getent("trigger_hurt_davinci", "targetname");
	level.triggerhurt trigger_off();
	
	level.rpg_proj = getent("rpg_projectile", "targetname");
	if (isdefined(level.rpg_proj))
	{
		level.rpg_proj hide();
	}
	
	level.rpg_proj2 = getent("rpg_projectile2", "targetname");
	if (isdefined(level.rpg_proj2))
	{
		level.rpg_proj2 hide();
	}
	
	thread spawn_mainhall_lower();
	

	thread steam_fx();
	thread elevator_explosion_kill();
	thread elevator_button_hide();
	
	
	
	
	
	
	
	
}
	
	





delete_elevator_guards()
{
	guardarray = getentarray("elevator_guards", "targetname");
	
	wait(5.0);
	
	for (i=0; i<guardarray.size; i++)
	{
		if (isalive(guardarray[i]))
		{
			guardarray[i] delete();
		}
	}
	
	thread spawn_elevator_exit();
}






spawn_elevator_exit()
{
	trigger = getent("trigger_rpg", "targetname");
	trigger waittill("trigger");
	
	
	
	spawnerarray = getentarray("guard_elevator_exit", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_elevator");
	}
	
	guardarray = getentarray("guard_elevator", "targetname");
	
	for (i=0; i<guardarray.size; i++)
	{
		guardarray[i] settetherradius(4);
	}
	
	wait(1.0);
	
	thread fire_rocket();
}


shut_elev_doors()
{
	trigger = getent("mainhall_objective_final", "targetname");
	trigger waittill("trigger");

	
	wait(0.3);
	
	pos = GetEnt ("skip_to_mainhall", "targetname");
	level.player SetOrigin(pos.origin + (0, -4, 0) );

	securityElevOuterLeftDoor = GetEnt ("securityElevOuterLeftDoorMainHall", "targetname");
	securityElevOuterRightDoor = GetEnt ("securityElevOuterRightDoorMainHall", "targetname");

	securityElevOuterLeftDoor movex ( -30.0, 1.0, 0.25, 0.2);
	securityElevOuterRightDoor movex ( 35.0, 1.0, 0.25, 0.2);
	securityElevOuterRightDoor playsound("Elevator_Doors_Open");
}



savegame_mainhall()
{
	trigger = getent("trigger_savegame_mainhall", "targetname");
	trigger waittill("trigger");
	

	
	
	
	
	level thread maps\_autosave::autosave_now("MiamiScienceCenter");
}






spawn_right_balcony()
{
	guardarray = getentarray("guard_right_balcony", "targetname");
			
	for (i=0; i<guardarray.size; i++)
	{
		guardarray[i] = guardarray[i] stalingradspawn("guard_right");
	}
}






spawn_left_balcony()
{
	guardarray = getentarray("guard_left_balcony", "targetname");
		
	for (i=0; i<guardarray.size; i++)
	{
		guardarray[i] = guardarray[i] stalingradspawn("guard_left");
	}
}






spawn_mainhall_lower()
{
	trigger = getent("trigger_mainhall_lower", "targetname");
	trigger waittill("trigger");


	
	setExpFog(0,1527.26,0.263,0.259,0.252, 2.0);

	
	level notify ("vo_He_is_on_the_second_floor_os2");
	
	guardarray = getentarray("guard_mainhall_lower", "targetname");
	
	for (i=0; i<guardarray.size; i++)
	{
		guardarray[i] = guardarray[i] stalingradspawn("guard_lower");
	}
	
	thread spawn_wave_01();
	wait(0.5);
	thread spawn_right_balcony();
	wait(0.3);
	thread spawn_left_balcony();	
	
	thread falling_light_01();
	thread falling_light_02();
	thread falling_light_03();
	thread falling_light_04();
	thread falling_light_05();
	thread falling_light_06();
	
	
	
}






fire_rocket()
{
	destroyed_wall1 = getent ("pillar_before","targetname");
	destroyed_wall2 = getent ("pillar_after","targetname");
	
	destroyed_wall2 hide();

	rpg = getent("guard_rpg", "targetname");
	rpg stalingradspawn( "rpg_guard" );
	guard = getent("rpg_guard", "targetname");
	guard thread rpg_guard();
	
	wait(1.5);
		
	level.tag = getent("tag_rocket", "targetname");
	
	thread rpg_projectile();
	thread loop_smoke_trail();
	thread rpg_davinci_fire();
	
	level.tag movey(1886, 2.0);
	
	wait(2.0);
	
	level.rocket_impact = true;
	
	tag_impact = getent("tag_rocket_impact", "targetname");
	

	origin_explosion = getent("rpg_explosion", "targetname");
	radiusdamage(origin_explosion.origin, 250, 200, 200, undefined );
	

	
	destroyed_wall1 hide();
	destroyed_wall2 show();
	
	
	tag_impact playsound("Vehicle_Explosion_01");
	wait(0.2);
	earthquake( 0.6, 1, level.player.origin, 300 );
	
	level.player play_dialogue("SCH1_SciBG02A_049A", true);
	
	
	
	wait(2.0);
	
	level.tag2 = getent("tag_rocket2", "targetname");
	thread rpg_projectile2();
	thread loop_smoke_trail2();
	level.tag2 moveto((-5, 3197, 470), 2.3);
	
	wait(2.3);
	
	level.rocket_impact2 = true;
	
	tag_impact2 = getent("tag_rocket_impact2", "targetname");
	level.player PlayRumbleOnEntity( "grenade_rumble" );
	
	playfxontag( level._effect[ "elev_expl" ], tag_impact2, "tag_origin" );
	
	tag_impact2 playsound("Vehicle_Explosion_01");
	wait(0.2);
	earthquake( 0.6, 1, level.player.origin, 300 );
	
	
}

rpg_guard()
{
	self endon("death");
	
	wait(1.5);

	self setperfectsense( true );
	self CmdShootAtEntity( level.player, false, 2.5, 0 );
	self playsound("wpn_rpg_fire_plr");

	wait 4.2;

	self CmdShootAtEntity( level.player, false, 2.5, 0 );
	self playsound("wpn_rpg_fire_plr");
	self setperfectsense( false );

	wait 2.5;

	node = getnode ("node_rpg", "targetname");
	self setgoalnode(node);
	self waittill("goal");
	self delete();
}

rpg_projectile()
{
	if (isdefined(level.rpg_proj))
	{
		level.rpg_proj show();
		level.rpg_proj movey(1886, 2.0);
	
		wait(2.0);
	
		
	}
}
	

loop_smoke_trail()
{
	while(!(level.rocket_impact))
	{
		playfxontag( level._effect[ "rpg_trail" ], level.tag, "tag_origin" );
		
		wait(0.05);
	}
}


rpg_davinci_fire()
{
	tag = getent("tag_rpg_fire", "targetname");
	wait(1.5);
	playfxontag( level._effect[ "rpg_fire" ], tag, "tag_origin" );	
	
	level waittill("gogogo");
	
	if (isdefined(tag))
	{
		tag delete();
	}
}


rpg_projectile2()
{
	if (isdefined(level.rpg_proj2))
	{
		level.rpg_proj2 show();
		level.rpg_proj2 moveto((-5, 3197, 470), 2.3);
	}
}


loop_smoke_trail2()
{
	while(!(level.rocket_impact2))
	{
		playfxontag( level._effect[ "rpg_trail" ], level.tag2, "tag_origin" );
		
		wait(0.05);
	}
}






spawn_wave_01()
{
	trigger = getent("trigger_mainhall_wave01", "targetname");
	trigger waittill("trigger");
	
	
	
	level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	
	guardarray = getentarray("guard_mainhall_wave01", "targetname");
	
	for (i=0; i<guardarray.size; i++)
	{
		guardarray[i] = guardarray[i] stalingradspawn("guard_wave01");
	}
	
	level notify ("vo_everyone_to_the_first_floor_os2");
	
	thread spawn_wave_02();
	thread check_wave02();
	thread check_wave03();
	
	thread spawn_lobby_guards();
	thread activate_davinci_heli();
	thread wave3_fx_end();
}






spawn_wave_02()
{
	guardarray = getentarray("guard_wave01", "targetname");
	
	while(!(level.wave2_spawned))
	{
		guardarray = getentarray("guard_wave01", "targetname");
		
		if (guardarray.size <= 1)
		{
			wait(2.0);
			
			spawnerarray = getentarray("guard_mainhall_wave02", "targetname");
	
			for (i=0; i<spawnerarray.size; i++)
			{
				spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_wave02");
			}
			
			level.wave2_spawned = true;
		}
		
		wait(0.5);	
	}
}


check_wave02()
{
	trigger = getent("trigger_check_wave02", "targetname");
	trigger waittill("trigger");
	
	level notify("gogogo");
	
	if (!(level.wave2_spawned))
	{
		spawnerarray = getentarray("guard_mainhall_wave02", "targetname");
	
		for (i=0; i<spawnerarray.size; i++)
		{
			spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_wave02");
		}
		
		level.wave2_spawned = true;
	}
	
	
}






spawn_wave_03()
{	
	while(!(level.wave3_spawned))
	{
		guards = getaiarray("axis");
		
		if (guards.size <= 1)
		{
			spawnerarray = getentarray("guard_mainhall_wave03", "targetname");
	
			for (i=0; i<spawnerarray.size; i++)
			{
				spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_wave03");
			}
			
			level.wave3_spawned = true;
			
		}
		
		wait(0.5);	
	}
}


check_wave03()
{
	trigger = getent("trigger_check_wave03", "targetname");
	trigger waittill("trigger");
	
	thread spawn_mainhall_left();
	thread spawn_mainhall_right();
	thread spawn_mainhall_rightside();
	thread spawn_mainhall_leftside();
	thread close_mainhall_gates();
	
	if (!(level.wave3_spawned))
	{
		spawnerarray = getentarray("guard_mainhall_wave03", "targetname");
	
		for (i=0; i<spawnerarray.size; i++)
		{
			spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_wave03");
		}
		
		level.wave3_spawned = true;
	}
}






spawn_mainhall_left()
{
	trigger = getent("trigger_mainhall_left", "targetname");
	trigger waittill("trigger");
	
	if(!(level.side_spawned))
	{
		spawnerarray = getentarray("guard_mainhall_left", "targetname");
	
		for (i=0; i<spawnerarray.size; i++)
		{
			spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_left");
		}
		
		level.side_spawned = true;
		
		level notify ("vo_enemy_is_trapped_hold_positions_os2");
	}
}



spawn_mainhall_right()
{
	trigger = getent("trigger_mainhall_right", "targetname");
	trigger waittill("trigger");
	
	if(!(level.side_spawned))
	{
		spawnerarray = getentarray("guard_mainhall_right", "targetname");
	
		for (i=0; i<spawnerarray.size; i++)
		{
			spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_right");
		}
		
		level.side_spawned = true;
		
		level notify ("vo_enemy_is_trapped_hold_positions_os2");
	}
}



spawn_mainhall_rightside()
{
	trigger = getent("trigger_mainhall_rightside", "targetname");
	trigger waittill("trigger");
	
	if(!(level.lastside_spawned))
	{
		spawnerarray = getentarray("guard_mainhall_rightside", "targetname");
	
		for (i=0; i<spawnerarray.size; i++)
		{
			spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_rightside");
		}
		
		level.lastside_spawned = true;
	}
}



spawn_mainhall_leftside()
{
	trigger = getent("trigger_mainhall_leftside", "targetname");
	trigger waittill("trigger");
	
	if(!(level.lastside_spawned))
	{
		spawnerarray = getentarray("guard_mainhall_leftside", "targetname");
	
		for (i=0; i<spawnerarray.size; i++)
		{
			spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_leftside");
		}
		
		level.lastside_spawned = true;
	}
}






spawn_bridge_guards()
{
	
	
	
	spawnerarray = getentarray("guard_mainhall_bridge", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_bridge");
		spawnerarray[i] kill_guards_death();
	}
	
}

kill_guards_death()
{
		self endon( "death" );
		wait( 10 ); 
		node = getnode( "run_n_die", "targetname");
		self setscriptspeed("sprint");
		self setgoalnode ( node );
		self waittill( "goal" );
		self delete();
}






spawn_lobby_guards()
{
	trigger = getent("trigger_spawn_lobby", "targetname");
	trigger waittill("trigger");
	level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	thread spawn_bridge_guards();
	thread open_mainhall_gates();
	level thread turn_last_2_guys_into_rusher();
	
	spawnerarray = getentarray("guard_lobby", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_lobby_exit");
		spawnerarray[i]thread TetherWatcher( 12*0, 12*3, 12*15 );
	}
	
	guardarray = getentarray("guard_lobby_exit", "targetname");
	
	for (i=0; i<guardarray.size; i++)
	{
		guardarray[i] setscriptspeed("sprint");
	}
	
	wait(5);
	thread close_mainhall_gates();
}






open_mainhall_gates()
{
	right = getent("mainhall_gate_right", "targetname");
	left = getent("mainhall_gate_left", "targetname");
	
	right movex (-84, 3.0);
	left movex (84, 3.0);
	
	thread mainhall_guards_dead();
}






mainhall_guards_dead()
{
	alldead = false;
	
	while(!(alldead))
	{
		guards = getaiarray("axis", "neutral");
		if (!(guards.size))
		{
			level notify("endmusicpackage");
			
			alldead = true;
			
			
			level thread maps\_autosave::autosave_now("MiamiScienceCenter");
			level thread mission_success();
		}
		wait(0.5);
	}
}






close_mainhall_gates()
{
	right = getent("mainhall_gate_right", "targetname");
	left = getent("mainhall_gate_left", "targetname");
	
	right movex (84, 3.0);
	left movex (-84, 3.0);
}








jl_ending()
{
	
	trigger = getent("trigger_check_wave03", "targetname");
	trigger waittill("trigger");

	
	wait( 5 );
	tetherPt1 = GetEnt( "auto2489", "targetname" );
	lower_guys = getaiarray("axis");
	for (i=0; i<lower_guys.size; i++)
	{
		lower_guys[i]thread TetherWatcher( 12*0, 12*3, 12*15 );
	}
}

jl_ending_kill_floor2()
{
	lower_guys = getaiarray("axis");
	
	
	for (i=0; i<lower_guys.size; i++)
	{
		if (IsDefined(lower_guys[i].script_string) && (lower_guys[i].script_string == "top_floor"))
		{
				lower_guys[i] dodamage( 10000, (0,0,0) );
		}
	}
}




TetherWatcher( tetherDelta0, tetherDelta1, minTether )
{
	self endon( "death" );
	
	level.tetherPt = GetEnt( "origin_heli_damage", "targetname" );
		
	if( IsDefined(level.tetherPt) )
	{		
		self.tetherpt			= level.tetherPt.origin;	
		self.tetherradius	= 10000000000;
		
		tetherDelta 			= randomfloatrange(tetherDelta0, tetherDelta1);
		
		while( isdefined(level.tetherPt) )
		{						
			wait( randomfloat(2.0,4.0) );			
						
			newRad = Distance(level.player.origin, self.tetherpt) - tetherDelta;
			
			
			if( newRad < self.tetherradius )
			{	
				
				if( newRad < minTether )
				{
					self.tetherradius = minTether;
				}
				else
				{
					self.tetherradius = newRad;
					
					tetherDelta = randomfloatrange(tetherDelta0, tetherDelta1);
				}
			}
		}
	}
}






activate_davinci_heli()
{
	level waittill("gogogo");
	
	
	
	level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	
	if (!(level.davinci_collapsed))
	{
		level notify("heli_start");
		
		wait(3);
		level notify("end_explosion_now");	
		level notify ("davinchi_start");
		level notify ("truss_fall_start");
		level notify ("rotor_fall_start");
		level.davinci_collapsed = true;
		thread damage_explosions();
	}

	VisionSetNaked( "Sciencecenter_b_07", 2.3);
	
	thread collision_davinci();
	wait(5.0);
	level thread jl_ending_kill_floor2(); 
	thread fire_barrier_mainhall();
	
	
	heli_fire_org_var = getent("heli_fire_org", "targetname");
	heli_fire_org_var playloopsound("heli_fire_low", 0.7);
	
	
}






collision_davinci()
{
	collision = getentarray("collision_davinci", "targetname");
	
	for (i=0; i<collision.size; i++)
	{
		collision[i] movez(377, 0.1);
	}
}






skip_to_points()
{
	
	if(Getdvar( "skipto" ) == "0" )
	{
		return;
	}     
	else if(Getdvar( "skipto" ) == "RopeSlide" )
	{
		level thread maps\miami_science_center_catwalk::vent_access_door();
		level thread maps\miami_science_center_catwalk::initiate_rope_slide();
		level notify ( "end_rain" );
		
		setdvar("skipto", "0");
		
		start_org = getent( "skip_to_rope", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
	}
	
	else if(Getdvar( "skipto" ) == "Elevator" )
	{
		level notify ( "basement" );
		level notify ( "end_rain" );
		
		setdvar("skipto", "0");
		
		start_org = getent( "skip_to_elevator", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));

		wait .5;

		
		level thread maps\sciencecenter_b::access_camera_controls();
	}
	
	else if(Getdvar( "skipto" ) == "Mainhall" )
	{
		setdvar("skipto", "0");
		
		level notify ( "end_rain" );
		
		start_org = getent( "skip_to_mainhall", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		
	}
	
}






steam_fx()
{
	thread steam_fx_01();
	thread steam_fx_02();
	thread steam_fx_03();
	thread steam_fx_04();
	thread steam_fx_05();
	thread steam_fx_06();
	thread steam_fx_07();
	thread steam_fx_08();
	thread steam_fx_09();
	
	level notify("playmusicpackage_start");
}

steam_fx_01()
{
	trigger = getent("trigger_steam_01", "targetname");
	trigger waittill("trigger");
	
	steam01_tag = getent("tag_steam_01", "targetname");
	
	playfxontag( level._effect[ "steam_large" ], steam01_tag, "tag_origin" );	
}

steam_fx_02()
{
	trigger = getent("trigger_steam_02", "targetname");
	trigger waittill("trigger");
	
	steam02_tag = getent("tag_steam_02", "targetname");
	
	playfxontag( level._effect[ "steam_large" ], steam02_tag, "tag_origin" );	
}

steam_fx_03()
{
	trigger = getent("trigger_steam_03", "targetname");
	trigger waittill("trigger");
	
	steam03_tag = getent("tag_steam_03", "targetname");
	
	playfxontag( level._effect[ "steam_large" ], steam03_tag, "tag_origin" );	
}

steam_fx_04()
{
	trigger = getent("trigger_steam_04", "targetname");
	trigger waittill("trigger");
	
	steam04_tag = getent("tag_steam_04", "targetname");
	
	playfxontag( level._effect[ "steam_large" ], steam04_tag, "tag_origin" );	
}

steam_fx_05()
{
	trigger = getent("trigger_steam_05", "targetname");
	trigger waittill("trigger");
	
	steam05_tag = getent("tag_steam_05", "targetname");
	
	playfxontag( level._effect[ "steam_large" ], steam05_tag, "tag_origin" );	
}

steam_fx_06()
{
	trigger = getent("trigger_steam_06", "targetname");
	trigger waittill("trigger");
	
	steam06_tag = getent("tag_steam_06", "targetname");
	
	playfxontag( level._effect[ "steam_large" ], steam06_tag, "tag_origin" );	
}

steam_fx_07()
{
	trigger = getent("trigger_steam_07", "targetname");
	trigger waittill("trigger");
	
	steam07_tag = getent("tag_steam_07", "targetname");
	
	playfxontag( level._effect[ "steam_large" ], steam07_tag, "tag_origin" );	
}

steam_fx_08()
{
	trigger = getent("trigger_steam_08", "targetname");
	trigger waittill("trigger");
	
	steam08_tag = getent("tag_steam_08", "targetname");
	
	playfxontag( level._effect[ "steam_large" ], steam08_tag, "tag_origin" );	
}

steam_fx_09()
{
	trigger = getent("trigger_steam_09", "targetname");
	trigger waittill("trigger");
	
	steam09_tag = getent("tag_steam_09", "targetname");
	
	playfxontag( level._effect[ "steam_large" ], steam09_tag, "tag_origin" );
}






fire_barrier_mainhall()
{
	fire_tag = getentarray("tag_fire_davinci", "targetname");
	wait(2.0);
	for (i=0; i<fire_tag.size; i++)
	{
		playfxontag( level._effect[ "floor_fire" ], fire_tag[i], "tag_origin" );
		
		
		fire_tag[i] Playloopsound ("sci_b_small_fire");
	}
	
	level.triggerhurt trigger_on();
}






Elevator_explosion_kill()
{
	trigger = getent("triggerhurt_elevator", "targetname");
	
	trigger trigger_off();
	
	level waittill("fireball");
	
	level notify("playmusicpackage_hall");
	
	
	
	
}






explosion_outside_elevator()
{
	origin_explosion = getent("origin_elevator_explosion", "targetname");
	tag = getent("tag_elevator_explosion", "targetname");

	playfxontag( level._effect[ "outside_elevator_exp" ], tag, "tag_origin" );
	
	wait(0.1);

	tag playsound("Vehicle_Explosion_01");	
	earthquake( 0.3, 1, level.player.origin, 300 );
	
	wait(0.1);
	
	radiusdamage ( origin_explosion.origin, 100, 200, 200 );
	
	level.player play_dialogue("SCH1_SciBG02A_049A", true);
}
	





banner_01()
{
	trigger = getent("trigger_banner_01", "targetname");
	
	while(1)
	{
		trigger waittill("trigger");
		
		level notify("sc_banner_01_start");
	
		wait(2.0);  
	}
}

banner_02()
{
	trigger = getent("trigger_banner_02", "targetname");
	
	while(1)
	{
		trigger waittill("trigger");
		
		level notify("sc_banner_02_start");
	
		wait(2.0);  
	}
}

banner_03()
{
	trigger = getent("trigger_banner_03", "targetname");
	
	while(1)
	{
		trigger waittill("trigger");
		
		level notify("sc_banner_03_start");
	
		wait(2.0);  
	}
}

banner_04()
{
	trigger = getent("trigger_banner_04", "targetname");
	
	while(1)
	{
		trigger waittill("trigger");
		
		level notify("sc_banner_04_start");
	
		wait(2.0);  
	}
}

banner_05()
{
	trigger = getent("trigger_banner_05", "targetname");
	
	while(1)
	{
		trigger waittill("trigger");
		
		level notify("sc_banner_05_start");
	
		wait(2.0);  
	}
}

banner_06()
{
	trigger = getent("trigger_banner_06", "targetname");
	
	while(1)
	{
		trigger waittill("trigger");
		
		level notify("sc_banner_06_start");
	
		wait(2.0);  
	}
}






challenge_shoot_lights()
{
	level.lights_shot_down++;
	
	if (level.lights_shot_down > 3)
	{
		GiveAchievement("Challenge_ScienceInt");
	}
}






falling_light_01()
{
	trigger = getent("trigger_lightfall_01", "targetname");
	trigger waittill("trigger");
	
	light_01 = getentarray("mainhall_lights_small_01", "targetname");
	origin_explosion = getent("origin_light01_explosion", "targetname");
	
	light_01[0] playsound ("Light_Fixture_Crash");
	
	for (k=0; k<light_01.size; k++)
	{
		playfx( level._effect[ "science_lamp_burst" ], light_01[k].origin );
		wait(0.1);
	}
		
	for (i=0; i<light_01.size; i++)
	{
		light_01[i] movez(-400, 0.75);
	}
	
	wait(0.8);
	
	playfx( level._effect[ "science_lamp_truss_hit" ], origin_explosion.origin );
	radiusdamage ( origin_explosion.origin, 125, 200, 200 );
	
	wait(0.1);
	
	for (j=0; j<light_01.size; j++)
	{
		if (isdefined(light_01[j]))
		{
			light_01[j] delete();
		}
	}
	
	origin_explosion playsound ("Light_Fixture_Crash");
	earthquake( 0.3, 1, level.player.origin, 300 );
	
	level thread challenge_shoot_lights();
}


falling_light_02()
{
	trigger = getent("trigger_lightfall_02", "targetname");
	trigger waittill("trigger");
	
	light_02 = getentarray("mainhall_lights_small_02", "targetname");
	origin_explosion = getent("origin_light02_explosion", "targetname");
	
	light_02[0] playsound ("Light_Fixture_Crash");
	
	for (k=0; k<light_02.size; k++)
	{
		playfx( level._effect[ "science_lamp_burst" ], light_02[k].origin );
		wait(0.1);
	}
	
	for (i=0; i<light_02.size; i++)
	{
		light_02[i] movez(-400, 0.75);
	}
	
	wait(0.8);
	
	playfx( level._effect[ "science_lamp_truss_hit" ], origin_explosion.origin );
	radiusdamage ( origin_explosion.origin, 125, 200, 200 );
	
	wait(0.1);
	
	for (j=0; j<light_02.size; j++)
	{
		if (isdefined(light_02[j]))
		{
			light_02[j] delete();
		}
	}
	
	origin_explosion playsound ("Light_Fixture_Crash");
	earthquake( 0.3, 1, level.player.origin, 300 );
	
	level thread challenge_shoot_lights();
}


falling_light_03()
{
	trigger = getent("trigger_lightfall_03", "targetname");
	trigger waittill("trigger");
	
	light_03 = getentarray("mainhall_lights_small_03", "targetname");
	origin_explosion = getent("origin_light03_explosion", "targetname");
	
	light_03[0] playsound ("Light_Fixture_Crash");
	
	for (k=0; k<light_03.size; k++)
	{
		playfx( level._effect[ "science_lamp_burst" ], light_03[k].origin );
		wait(0.1);
	}
	
	for (i=0; i<light_03.size; i++)
	{
		light_03[i] movez(-400, 0.75);
	}
	
	wait(0.8);
	
	playfx( level._effect[ "science_lamp_truss_hit" ], origin_explosion.origin );
	radiusdamage ( origin_explosion.origin, 125, 200, 200 );
	
	wait(0.1);
	
	for (j=0; j<light_03.size; j++)
	{
		if (isdefined(light_03[j]))
		{
			light_03[j] delete();
		}
	}
	
	origin_explosion playsound ("Light_Fixture_Crash");
	earthquake( 0.3, 1, level.player.origin, 300 );
	
	level thread challenge_shoot_lights();
}


falling_light_04()
{
	trigger = getent("trigger_lightfall_04", "targetname");
	trigger waittill("trigger");
	
	light_04 = getentarray("mainhall_lights_small_04", "targetname");
	origin_explosion = getent("origin_light04_explosion", "targetname");
	
	light_04[0] playsound ("Light_Fixture_Crash");
	
	for (k=0; k<light_04.size; k++)
	{
		playfx( level._effect[ "science_lamp_burst" ], light_04[k].origin );
		wait(0.1);
	}
	
	for (i=0; i<light_04.size; i++)
	{
		light_04[i] movez(-400, 0.75);
	}
	
	wait(0.8);
	
	playfx( level._effect[ "science_lamp_truss_hit" ], origin_explosion.origin );
	radiusdamage ( origin_explosion.origin, 125, 200, 200 );
	
	wait(0.1);
	
	for (j=0; j<light_04.size; j++)
	{
		if (isdefined(light_04[j]))
		{
			light_04[j] delete();
		}
	}
	
	origin_explosion playsound ("Light_Fixture_Crash");
	earthquake( 0.3, 1, level.player.origin, 300 );
	
	level thread challenge_shoot_lights();
}


falling_light_05()
{
	trigger = getent("trigger_lightfall_05", "targetname");
	trigger waittill("trigger");
	
	light_05 = getentarray("mainhall_lights_small_05", "targetname");
	origin_explosion = getent("origin_light05_explosion", "targetname");
	
	light_05[0] playsound ("Light_Fixture_Crash");
	
	for (k=0; k<light_05.size; k++)
	{
		playfx( level._effect[ "science_lamp_burst" ], light_05[k].origin );
		wait(0.1);
	}
	
	for (i=0; i<light_05.size; i++)
	{
		light_05[i] movez(-400, 0.75);
	}
	
	wait(0.8);
	
	playfx( level._effect[ "science_lamp_truss_hit" ], origin_explosion.origin );
	radiusdamage ( origin_explosion.origin, 125, 200, 200 );
	
	wait(0.1);
	
	for (j=0; j<light_05.size; j++)
	{
		if (isdefined(light_05[j]))
		{
			light_05[j] delete();
		}
	}
	
	origin_explosion playsound ("Light_Fixture_Crash");
	earthquake( 0.3, 1, level.player.origin, 300 );
	
	level thread challenge_shoot_lights();
}


falling_light_06()
{
	trigger = getent("trigger_lightfall_06", "targetname");
	trigger waittill("trigger");
	
	light_06 = getentarray("mainhall_lights_small_06", "targetname");
	origin_explosion = getent("origin_light06_explosion", "targetname");
	
	light_06[0] playsound ("Light_Fixture_Crash");
	
	for (k=0; k<light_06.size; k++)
	{
		playfx( level._effect[ "science_lamp_burst" ], light_06[k].origin );
		wait(0.1);
	}
	
	for (i=0; i<light_06.size; i++)
	{
		light_06[i] movez(-400, 0.75);
	}
	
	wait(0.8);
	
	playfx( level._effect[ "science_lamp_truss_hit" ], origin_explosion.origin );
	radiusdamage ( origin_explosion.origin, 125, 200, 200 );
	
	wait(0.1);
	
	for (j=0; j<light_06.size; j++)
	{
		if (isdefined(light_06[j]))
		{
			light_06[j] delete();
		}
	}
	
	origin_explosion playsound ("Light_Fixture_Crash");
	earthquake( 0.3, 1, level.player.origin, 300 );
	
	level thread challenge_shoot_lights();
}


falling_light_large()
{
	light = getentarray("mainhall_lights_large", "targetname");
	origin_explosion = getent("origin_light_explosion", "targetname");
	
	wait(2.0);
		
	for (k=0; k<light.size; k++)
	{
		playfx( level._effect[ "science_lamp_burst" ], light[k].origin );
		wait(0.1);
	}
	
	for (i=0; i<light.size; i++)
	{
		light[i] movez(-356, 0.75);
	}
	
	wait(0.8);
	

	
	
	wait(0.1);
	
	origin_explosion playsound ("Light_Fixture_Crash");
	
	
	fire_tag = getentarray("tag_fire_light", "targetname");
	
	for (j=0; j<fire_tag.size; j++)
	{
		playfxontag( level._effect[ "rpg_fire" ], fire_tag[j], "tag_origin" );
	}
}






damage_explosions()
{
	origin_davinci = getent("origin_davinci_damage", "targetname");
	origin_heli = getent("origin_heli_damage", "targetname");
	origin_wing = getent("origin_wing_damage", "targetname");
	tag_davinci = getent("tag_davinci_explosion", "targetname");
	
	wait(0.5);
	
	thread spawn_redshirts();
	
	wait(4.5);
	
	playfxontag( level._effect[ "science_gas_exp" ], tag_davinci, "tag_origin" );
	crates = getentarray("crate_weapons", "targetname");

	for (i=0; i<crates.size; i++)
	{
		if (isdefined(crates[i]))
		{
			crates[i] delete();
		}
	}
	
	wait(0.5);
	
	radiusdamage ( origin_davinci.origin, 50, 240, 240 );
	
	wait(1.2);
	
	radiusdamage ( origin_heli.origin, 250, 200, 200 );
	
	wait(1.5);
	

	earthquake( 0.3, 1, level.player.origin, 300 );

	radiusdamage ( origin_wing.origin, 200, 200, 200 );
}






spawn_redshirts()
{
	spawnerarray = getentarray("guard_davinci", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_davinci");
	}
}






elevator_sparks()
{
	tag_sparks = getentarray("tag_elevator_sparks", "targetname");
	elevator = getent("securityElevMain", "targetname");
	
	while(!(level.elevator_crashed))
	{
		for (i=0; i<tag_sparks.size; i++)
		{
			playfxontag( level._effect[ "elevator_sparks" ], tag_sparks[i], "tag_origin" );
			tag_sparks[i] linkto(elevator);
		}
		
		
		wait(0.2);
	}
}




e1_camera()
{
	e1_camera_1 = GetEnt("ent_e1_camera_1", "targetname");

	ent_e1_hack_cam1 = GetEnt("ent_e1_cam_hack", "targetname");
	
	e1_camera_1 thread maps\_securitycamera::camera_start(ent_e1_hack_cam1, true, false, false);









}




monitor_cam()
{
		
	cam_pos = [];
	cam_pos[0] = ( -262, -257, 832 );	
	cam_pos[1] = ( -281, 3000, 763 );	
	cam_pos[2] = ( -282, 646, 620 );	


	monitor_cameras = [];
	
	for( i = 0; i < 3; i++ )
	{
		
		monitor_cameras[i] = spawn( "script_origin", cam_pos[i] );
		
		if( i == 0 )
		{
				
				monitor_cameras[i].angles = ( 24.8, 53.6, 0 );
				monitor_cameras[i].script_float = 30;	
		}
		else if( i == 1 )
		{
				monitor_cameras[i].angles = ( 2.3, -44, 0 );
				monitor_cameras[i].script_float = 30; 
		}
		else if( i == 2 )
		{
				monitor_cameras[i].angles = ( 30, 63, 0 );
				monitor_cameras[i].script_float = 30; 
		}

		
		monitor_cameras[i] thread maps\_securitycamera::camera_start( undefined, false, undefined, undefined );
   		
	}
			





	
	

	maps\miami_science_center_catwalk::start_catwalk1_patrol();
	
}



setup_security_feed()
{
	security_screen = GetEnt("computer_security_access", "targetname");
	security_screen setmodel( "p_dec_laptop_blck" );

}	

start_dimitri_carlos_cutscene()
{
	security_screen = GetEnt("computer_security_access", "targetname");
	
		
	

	monitor_camera = spawn( "script_origin", (100.03, 1278.38, 243.35));
	monitor_camera.angles = (27.78, 159.10, 0);

	
	monitor_camera.destroyed = false;
	monitor_camera.disabled = false;
	monitor_camera thread maps\_securitycamera::camera_phone_track( true, true );
	wait(0.5);
	
	security_screen setmodel( "p_dec_laptop_blck_camera" );
	
	security_screen playsound ("monitor_on");
	
	
	
	setDVar( "r_bx_airport_laptop_enable", 1 );

	playcutscene("SCB_BombHandoff","cutscene_done");
	level waittill("cutscene_done");
	

  
  security_screen setmodel( "p_dec_laptop_blck" );
  
  
  setDVar( "r_bx_airport_laptop_enable", 0 );
  wait(0.5);
  level.player enablevideocamera( false );
  monitor_camera delete();
}	





delete_all_ai()
{
	count = 0;
	guys = getaiarray("axis", "neutral");

	for (i=0; i<guys.size; i++)
	{
		guys[i] delete();
		count++;
	}

	
}
delete_catwalk_spawners()
{
	ent_count = 0;
	
	ent = getent("spawner_thug_overrail", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("guard_01_spawner", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("guard_02_spawner", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getentarray("catwalk1_elites", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	
	
	
	
	
	
	ent = getentarray("catwalk2_thug", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	ent = getent("catwalk2_thug_05", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("catwalk2_thug_06", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("catwalk2_thug_09", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getentarray("final_catwalk_guards", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}

	
}
delete_catwalk_triggers()
{
	ent_count = 0;
	
	ent = getent("trigger_open_door", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_thug_overrail", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_map_2to1", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_map_1to2", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("player_in_catwalk1a", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_catwalk2_reached", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("player_in_catwalk1b", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getentarray("catwalk_longway", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	
	
	
	
	
	
	ent = getent("trigger_reached_maincatwalk", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_spawn_backup", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("catwalk2_guard_final", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_savegame_catwalk2", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getentarray("catwalk_no_spawn_trigger", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	ent = getent("trigger_balance_mainhall", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_spawn_balance", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}

	
}
delete_basement_spawners()
{
	ent_count = 0;
	
	ent = getent("guard_art_room", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("guard_security_01", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getentarray("guard_reinforce_artroom", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	ent = getentarray("guard_basement_reinforce", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	ent = getentarray("elite_basement_reinforce", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	ent = getentarray("guard_security_conversation", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}

	
}
delete_basement_triggers()
{
	ent_count = 0;
	
	
	
	
	
	
	
	ent = getent("stairs_end", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_map_3to2", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("section_one_thug_trigger", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_map_2to3", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	
	
	
	
	
	
	ent = getent("trigger_resume_patrol", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_spawn_officeguard", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	
	
	
	
	
	
	ent = getent("trigger_check_alert", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	ent = getent("trigger_monitor_guards", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_security_reached", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("basement_elevator_save_trig", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_map_3to4", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("basement_start_ele", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}

	
}

