#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#include animscripts\utility;
#include maps\sciencecenter_a_util;
#using_animtree("vehicles");


rooftop_main()
{

	level.dprint = 0;
	
	for ( i = 0; i < 10; i++ )
	{
		level.roof_deaths[i] = 0;
	}
	
	// ------- ROOFTOP FUNCTIONS --------
	level thread roof_clean_outside_ground();
	level thread reach_rooftop_pipe();
	level thread roof_birds_01_func();
	level thread roof_birds_02_func();
	level thread rooftop_battle_01();
	level	thread pipe_save();
	level thread midroof_autosave();
	// ----------------------------------	

}

////////////////////////////////////////////////////////////////////////////////////
//                    ROOFTOP FUNCTIONS                
////////////////////////////////////////////////////////////////////////////////////

roof_clean_outside_ground()
{
	trigger = getent ( "roof_clean_outside_ground", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "roof_access" );
//	level thread setup_roof_qk();

	//iprintlnbold("Rooftop combat setup");
	thread rooftop_start();

}

setup_roof_qk()
{
	thug_1 = getent ("roof_thug_convers_01", "targetname")  stalingradspawn( "thug_1" );
	thug_1 waittill( "finished spawning" );
	thug_1 thread global_ai_random_anims();
	//iprintlnbold("special QK enabled"); 
	thug_1 SetCtxParam("Interact", "SpecialQKAnim", "Roof_QK");
}

reach_rooftop_pipe()
{
	trigger = getent ( "reached_roof_trig", "targetname" );
	trigger waittill ( "trigger" );
	
	level notify("reached_roof");

	setSavedDvar( "sf_compassmaplevel", "level4" );

	//temp culldist test for ps3
	//visionSetNaked( "sciencecenter_a_roof_ps3", 2.0 ); 
	//setculldist(6000);
	//setExpFog(0,2500,.180,.188,.195,0);

	if(level.ps3 ) //GEBE
	{
		visionSetNaked( "sciencecenter_a_roof_ps3", 2.0 ); 
		setculldist(6000);
		setExpFog(0,2500,.180,.188,.195,0);
	}
	else
	{	
		visionSetNaked( "sciencecenter_a_roof", 2.0 ); 
		setExpFog(0,3700,.180,.188,.195,0);
	}

	//Start Roof Music - Added by crussom
	// DCS: moved to reaching rooftop.
	level notify("playmusicpackage_roof");

	
	//level.player customCamera_pop( level.cameraID, 1.0 );

	blocker = GetEnt ( "roof_blocker_to_ledge", "targetname" );
	blocker movez ( -128, .5 );
	

	// AE 7/1/08: added vo
	level.player play_dialogue("RMR1_SciAG_034A", true); // shots fired
	wait(0.5);
	level.player play_dialogue("SCS1_SciAG_035A", true); // stand by
	wait(0.5);
	level.player play_dialogue("RMR2_SciAG_036A", true); // confirming contact
	wait(0.5);
	level.player play_dialogue("SCS1_SciAG_037A", true); // sending more men

}

////////////////////////////////////////////////////////////////////////////////////
//                    ROOFTOP BATTLE START               
////////////////////////////////////////////////////////////////////////////////////
rooftop_battle_01()
{
	trig1 = getent ("rooftop_trigger_01", "targetname");
	trig2 = getent ("rooftop_trigger_02", "targetname");
	trig3 = getent ("rooftop_trigger_03", "targetname");
		
	if(IsDefined(trig1))
	{
		trig1 waittill("trigger");
		enemy1_spawners = GetEntArray(trig1.target, "targetname");
		for(i=0; i< enemy1_spawners.size; i++)
		{
			enemy1[i] =  enemy1_spawners[i] StalingradSpawn();
			if( !spawn_failed( enemy1[i] ) )
			{
				enemy1[i] setalertstatemin("alert_red");	
				enemy1[i] setperfectsense(true);
				enemy1[i] addengagerule("tgtperceive");
			}
			else
			{
				//iprintlnbold("FAILED TO SPAWN AI!");
			}				
		}	
	}
			
	if(IsDefined(trig2))
	{
		trig2 waittill("trigger");
		enemy2_spawners = GetEntArray(trig2.target, "targetname");
		for(i=0; i< enemy2_spawners.size; i++)
		{
			enemy2[i] =  enemy2_spawners[i] StalingradSpawn();
			if( !spawn_failed( enemy2[i] ) )
			{
				enemy2[i] setalertstatemin("alert_red");	
				enemy2[i] setperfectsense(true);
				enemy2[i] addengagerule("tgtperceive");
			}
			else
			{
				//iprintlnbold("FAILED TO SPAWN AI!");
			}				
		}	
	}
				
	if(IsDefined(trig3))
	{
		trig3 waittill("trigger");
		enemy3_spawners = GetEntArray(trig3.target, "targetname");
		for(i=0; i< enemy3_spawners.size; i++)
		{
			enemy3[i] =  enemy3_spawners[i] StalingradSpawn();
			if( !spawn_failed( enemy3[i] ) )
			{
				enemy3[i] setalertstatemin("alert_red");	
				enemy3[i] setperfectsense(true);
				enemy3[i] addengagerule("tgtperceive");
			}
			else
			{
				//iprintlnbold("FAILED TO SPAWN AI!");
			}				
		}	
	}				
}	

pipe_save()
{
	while(true)
	{
		level.player waittill("pipe",notice);
	  if(notice == "end")
	  {
			thread maps\_autosave::autosave_now("MiamiScienceCenter");
			return;
		}
		wait(0.05);
	}
}

midroof_autosave()
{
	trigger = getent ( "wave_1", "targetname" );
	trigger waittill ( "trigger" );
	thread	maps\_autosave::autosave_now("MiamiScienceCenter");

	// AE 7/1/08: added vo
	//level.player play_dialogue("TANN_SciAG_502A", true); // air traffic
}
////////////////////////////////////////////////////////////////////////////////////
//                    ROOF ENVIRONMENTAL                
////////////////////////////////////////////////////////////////////////////////////
//avulaj
//
roof_birds_01_func()
{
	org = getent ( "roof_birds_01", "targetname" );
	trigger = getent ( "roof_trigger_birds_01", "targetname" );
	trigger waittill ( "trigger" );
	playfx ( level._effect["science_startled_birds"], org.origin );
	org playsound( "birds_taking_off" ); //this plays//birds flying off
}

//avulaj
//
roof_birds_02_func()
{
	org = getent ( "roof_birds_02", "targetname" );
	trigger = getent ( "roof_trigger_birds_02", "targetname" );
	trigger waittill ( "trigger" );
	playfx ( level._effect["science_startled_birds"], org.origin );
	org playsound( "birds_taking_off" ); //this plays//birds flying off
}



////////////////////////////////////////////////////////////////////////////////////
// 				AI ROOFTOP COMBAT
////////////////////////////////////////////////////////////////////////////////////


//====================================================================================================
// init function
//====================================================================================================
rooftop_start()
{
	roof_init_params();

	thread roof_wait_run(); 	

	thread trigger_wave( 1 );
	thread trigger_wave_1_rusher();

	thread trigger_wave( 2 );
	thread trigger_flood_on( 1 );

	thread trigger_wave( 3 );
	thread trigger_wave( 4 );
	thread trigger_heli_flyby();

	thread trigger_heli_thugs();
	thread trigger_heli_end();
	thread trigger_save();
	
	//thread objectives();
	thread maps\sciencecenter_a::objective_05();
	

}

//====================================================================================================
// tuning values for the level
//====================================================================================================
roof_init_params()
{
	level.heli_health = 2750;
	level.heli_diff_1 = 1800;
	level.heli_diff_2 = 1000;
	level.heli_diff_3 = 500;

	level.heli_at_end = 0;
	level.heli_charging = 0;
	level.heli_shield = 0;

	level.heli_health_phase_2 = 1500;

	level.health_init_fx = 0;
	level.health_fx_1 = 0;
	level.health_fx_2 = 0;

	level.heli_spd_default = 20;
	level.heli_acc_default = 20;

	level.heli_spd_rise = 30;
	level.heli_acc_rise = 30;

	level.heli_spd_attack = 8;
	level.heli_acc_attack = 8;

	level.heli_spd_phase2 = 30;
	level.heli_acc_phase2 = 30;

	level.spread_attack_min = -64;
	level.spread_attack_max = 64;

	level.update_pos_time = 0.7;

	level.heli_support_shoot_time = 6;
	level.heli_support_wait_time = 3;
	level.heli_support_spread_min = -12;
	level.heli_support_spread_max = 12;

	level.heli_start_at_end = 0;
	if ( level.heli_start_at_end )
	{
		level.player giveweapon( "SAF9_SCa" );
		level.player givemaxammo( "SAF9_SCa" );
	}

	level.enemy_count = 0;

	level.flank[0] = 0;
	level.flank[1] = 0;
	level.flank[2] = 0;

	level.current_pos = 0;
	level.difficulty = 0;
	level.charge = 0;
	level.strafe_time = 12;

	level.heli_grenadeEnabled = 0;
}

//====================================================================================================
// wait to trigger the first 2 enemies
//====================================================================================================
roof_wait_run()
{
	roof_spawner2 = getent( "thug_start_2", "targetname" );
	thug_start_2 = roof_spawner2 stalingradspawn();
	
	roof_spawner1 = getent( "thug_start", "targetname" );
	thug_start = roof_spawner1 Stalingradspawn();
	if ( spawn_failed(thug_start) )
	{
	//	iPrintLnBold( "runner spawn failed" );
	}		

	trig_run = GetEnt( "thug1_take_cover", "targetname" );
	if ( IsDefined(trig_run) )
	{
		node = GetNode( "thug_run_goal", "targetname" );
		if ( IsDefined(node) )
		{
			trig_run waittill( "trigger" );
			
			if ( IsDefined(thug_start_2) )
			{
				thug_start_2 thread turn_on_sense();
			}
			if ( IsDefined(thug_start) ) // make certain wasn't killed before trigger hit.
			{
				thug_start.goalradius = 12;	
				thug_start SetEnableSense( false );
				thug_start SetScriptSpeed( "sprint" );
				thug_start SetGoalNode(node);
				thug_start waittill("goal");
				if ( IsDefined(thug_start) ) // check again incase he was killed on the run.
				{						
					thug_start SetEnableSense( true );
					thug_start thread turn_on_sense();
				}
			}	
		}
	}
}

//====================================================================================================
// debug function to turn on/off messages
//====================================================================================================
dprint( msg )
{
	if ( level.dprint == 1 )
	{
		iprintlnbold( msg );
	}
}

//====================================================================================================
// utility function to temporary tell ai where the player is
//====================================================================================================
turn_on_sense()
{
	self setperfectsense( true );
	wait( 3 );
	
	if(IsDefined(self))
	{
		self setperfectsense( false );
	}	
}

//====================================================================================================
// camera to look at the heli
//====================================================================================================
camera_scene_1()
{
	player_stick( false );

	// -156 2976 1052
	camera_id = level.player customCamera_push(
		"world",
		( -476, 613, 1100 ),
		( 0, 300, 0 ),
		4.0 );

	wait( 4.0 );

	level.player customCamera_pop(
		camera_id,
		1.5 );

	player_unstick();
}

//====================================================================================================
// death counter
//====================================================================================================
death_watch( number )
{
	self waittill( "death" );

	level.roof_deaths[number]++;
	level.enemy_count--;
	
	if ( level.roof_deaths[2] == 1 )
	{
		thread spawn_extra( 1 );
	}

}

//====================================================================================================
// 
//====================================================================================================
spawn_extra( number )
{
	str = "spawner_extra_" + number;

	spawner = getentarray( str, "targetname" );
	for ( i = 0; i < spawner.size; i++ )
	{
		guy = spawner[i] stalingradspawn();
		guy thread turn_on_sense();
	}
}

//====================================================================================================
// brings the rusher in over the ledge
//====================================================================================================
trigger_wave_1_rusher()
{
	//rusher = getent( "wave_1_rusher", "targetname" );
	//rusher waittill( "trigger" );

	level waittill( "spawn_jumper" );

	//spawner = getent( "spawner_vent_4", "targetname" );
	//guy = spawner stalingradspawn();
	//guy thread turn_on_sense();
}

//====================================================================================================
// function to spawn enemies from a trigger
//====================================================================================================
trigger_wave( number )
{
	str = "wave_" + number;

	wave = getent( str, "targetname" );
	wave waittill( "trigger" );

	dprint( str );

	str = "spawner_wave_" + number;

	spawner = getentarray( str, "targetname" );
	for ( i = 0; i < spawner.size; i++ )
	{
		guy = spawner[i] stalingradspawn();
		guy thread turn_on_sense();
		guy thread death_watch( number );

		level.enemy_count++;
	}
}

//====================================================================================================
// function to trigger a flood of enemies until turned off
//====================================================================================================
trigger_flood_on( number )
{
	thread trigger_flood_off( number );

	str = "flood_" + number;
	str_end = str + "_end";

	level endon( str_end );

	flood = getent( str, "targetname" );
	flood waittill( "trigger" );

	str = "spawner_flood_" + number;
	spawner = getentarray( str, "targetname" );

	while ( 1 )
	{
		if ( level.enemy_count < 3 )
		{
			pick = RandomIntRange( 0, spawner.size );
			guy = spawner[pick] stalingradspawn();
			if ( isdefined(guy) )
			{
				guy thread turn_on_sense();
				guy thread death_watch( 0 );
				level.enemy_count++;
			}
		}

		waittime = 2;
		if ( level.difficulty > 1 )
		{
			waittime = 0.75;
		}
		if ( level.difficulty > 0 )
		{
			waittime = 1.5;
		}
		wait( waittime );
	}
}

trigger_flood_off( number )
{
	str = "flood_" + number + "_off";
	flood = getent( str, "targetname" );
	flood waittill( "trigger" );

	str_end = "flood_" + number + "_end";
	level notify( str_end );
}


trigger_heli_thugs()
{
	level endon( "heli_done" );

	wave = getent( "wave_5", "targetname" );
	wave waittill( "trigger" );

	spawner = getentarray( "spawner_wave_5", "targetname" );
	spawner_back = getentarray( "spawner_wave_5_2", "targetname" );

	while ( 1 )
	{
		pick = randomint( 2 );
		if ( !player_can_see(spawner[pick]) && level.current_pos == 0 && level.heli_charging == 1 )
		{
			guy = spawner[pick] stalingradspawn();
			wait( 1 );
			if ( isdefined(guy) )
			{
				guy thread turn_on_sense();
				guy.accuracy = 0.5;
				if ( level.heli_grenadeEnabled == 0 )
				{
					guy thread toss_grenades();
				}
			}
			wait( 29 );
		}
		else if ( !player_can_see(spawner_back[pick]) && level.current_pos == 1 && level.heli_charging == 1 )
		{
			guy = spawner_back[pick] stalingradspawn();
			wait( 1 );
			if ( isdefined(guy) )
			{
				guy thread turn_on_sense();
				if ( level.heli_grenadeEnabled == 0 )
				{
					guy thread toss_grenades();
				}
			}
			wait( 29 );
		}

		wait( 0.05 );
	}
}

//====================================================================================================
// designers wanted the thugs on the ground to throw grenades instead of the heli
//====================================================================================================
toss_grenades()
{
	while ( 1 )
	{
		delay = randomintrange( 11, 15 );
		if ( isdefined( self ) )
		{
			self cmdthrowgrenadeatentity( level.player, false, 1 );
		}
		wait( delay );
	}
}

//====================================================================================================
// triggers the initial heli
//====================================================================================================
trigger_heli_flyby()
{
	trigger_heli = getent( "heli_flyby", "targetname" );
	trigger_heli waittill( "trigger" );
 	thread heli_flyby();
}


//====================================================================================================
// triggers the helicopter fight at the end
//====================================================================================================
trigger_heli_end()
{
	trigger_heli = getent( "trigger_heli", "targetname" );
	trigger_heli waittill( "trigger" );
	level notify( "spawn_heli" );
	thread heli_init();
	//thread camera_scene_1();

	// AE 7/1/08: added vo
	level.player play_dialogue("HELI_SciAG_038A", true); // eagle 1
	wait(0.5);
	level.player play_dialogue("SCS1_SciAG_039A", true); // take him
	wait(0.5);
	level.player play_dialogue("HELI_SciAG_040A", true); // we're on it
}

//====================================================================================================
// triggers the savegame
//====================================================================================================
trigger_save()
{
	trigger = getent( "save", "targetname" );
	trigger waittill( "trigger" );

	thread maps\_autosave::autosave_now("MiamiScienceCenter");
	//savegame( "MiamiScienceCenter" );
}

//====================================================================================================
// the first time the heli shows up, just flys by
//====================================================================================================
heli_flyby()
{
	// spawn heli
	heli_flyby = getent( "heli_flyby1", "targetname" );
	heli = spawnvehicle( "v_heli_sca_red", "helicopter", "blackhawk", (heli_flyby.origin), (heli_flyby.angles) );

	// setup params
	heli.health = level.heli_health;
	heli setspeed( level.heli_spd_default, level.heli_acc_default );

	// setup anims
	heli UseAnimTree( #animtree );
	heli setanim( %bh_rotors );

	// setup light
	under_light = Spawn( "script_model", heli GetTagOrigin( "tag_ground" ) );
	under_light SetModel( "tag_origin" );
	under_light.angles = ( 0, 0, 10 );
	under_light LinkTo( heli );

	playfxontag ( level._effect["science_lightbeam05"], under_light, "tag_origin" );

	// spawn gunner
	spawner = getent( "spawner_vent_4", "targetname" );
	guy = spawner stalingradspawn();
	//guy thread turn_on_sense();
	guy setenablesense( false );
	guy allowedstances( "crouch" );

	guy linkto( heli, "tag_playerride", (0, 48, 12), (0, 0, 0) );
	guy cmdplayanim( "thu_crouch_aim_loop_dn_foregrip", true );

	// rsh080508 - design asked for another ai out of the copter
	spawner2 = getent( "spawner_vent_5", "targetname" );
	guy2 = spawner2 stalingradspawn();
	//guy thread turn_on_sense();
	guy2 setenablesense( false );
	guy2 allowedstances( "crouch" );

	guy2 linkto( heli, "tag_playerride", (-40, 44, 12), (0, 0, 0) );
	guy2 cmdplayanim( "thu_crouch_aim_loop_dn_foregrip", true );

	// move between points
	look = getent( "heli_look_1", "targetname" );
	heli setlookatent( look );

	pos = getent( "heli_flyby2", "targetname" );
	heli setvehgoalpos( pos.origin, 0 );
	//iprintlnbold ("SOUND: heli appearance 1");
	heli waittill( "goal" );

	pos = getent( "heli_flyby3", "targetname" );
	pos4 = getent( "heli_flyby4", "targetname" );

	if(IsDefined(guy))
	{
		thread jumper( guy );
	}
	if(IsDefined(guy2))
	{
		thread jumper2( guy2, heli );
	}
	
	heli setvehgoalpos( pos.origin, 1 );
	//iprintlnbold ("SOUND: heli flyby 2");
	heli waittill( "goal" );

	//level.tgt_pos = level.player.origin;
	//under_light thread heli_flyby_shoot( level.player.origin, -50, 50 );
	//heli thread update_shoot_pos();

	//level notify( "spawn_jumper" );
	wait( 2.0 );

	heli setspeed( level.heli_spd_phase2, level.heli_acc_phase2 );

	heli setlookatent( pos4 );
	wait( 1 );
	heli setvehgoalpos( pos4.origin, 0 );

	wait( 1 );
	level notify( "flyby_stop_shooting" );

	heli waittill( "goal" );

	pos = getent( "heli_flyby5", "targetname" );
	heli setlookatent( pos );
	heli setvehgoalpos( pos.origin, 0 );
	//iprintlnbold ("SOUND: heli flyby 3");
	heli waittill( "goal" );

	pos = getent( "heli_flyby6", "targetname" );
	heli setlookatent( pos );
	heli setvehgoalpos( pos.origin, 0 );
	//iprintlnbold ("SOUND: heli flyby 4");
	heli waittill( "goal" );

	heli delete();
	under_light delete();
}

//====================================================================================================
// this is the first guy out of the copter
//====================================================================================================
jumper( guy )
{
	node = getent( "heli_gunner", "targetname" );
	ground = getent( "jumper_ground", "targetname" );

	wait( .1);
	if(IsDefined(guy))
	{
		guy stopcmd();
	}	
	wait( .1 );

	if(IsDefined(guy))
	{
		guy cmdshootatentity( level.player, true, 1.5, 0.5 );
		guy waittill( "cmd_done" );

		node.origin = guy.origin;

		guy linkto( node );

		guy cmdplayanim( "thu_alrt_traversal_jumpdownloop_foregrip", true );
	}
	wait( .25 );
	
	part = getent( "jumper_part1", "targetname" );
	node moveto( part.origin, 0.4, 0.05, 0.05 );
	wait( 0.25 );
	node moveto( ground.origin, 0.7, 0.05, 0.05 );

	if(IsDefined(guy))
	{
		guy lockalertstate( "alert_red" );
		guy setcombatrole( "rusher" );
		guy setforcethreat( level.player, true );
		guy allowedstances( "crouch", "stand" );
	}
	
	wait( 0.7 );
	if(IsDefined(guy))
	{
		guy stopallcmds();
	}
	wait( .1 );
	if(IsDefined(guy))
	{
		guy unlink();

		guy setenablesense( true );
		guy turn_on_sense();
	}
}

//====================================================================================================
// this is the second guy out of the copter
//====================================================================================================
jumper2( guy, heli )
{
	node = getent( "heli_gunner2", "targetname" );
	ground = getent( "jumper_ground2", "targetname" );
	
	wait( .1);
	if(IsDefined(guy))
	{
		guy stopcmd();
	}
	wait( .1 );

//	guy cmdshootatentity( level.player, true, 1.5, 0.5 );
//	guy waittill( "cmd_done" );
	wait( 1.95 );

	temp_pos = heli gettagorigin( "tag_playerride" ) + (0, 48, 12);
	if(IsDefined(guy))
	{
		temp_pos = guy.origin + (-55, -4, 0);

		node.origin = guy.origin;

		guy linkto( node );
		node moveto( temp_pos, 0.5, 0.05, 0.05 );
	}
	
	wait( .75 );
	
	if(IsDefined(guy))
	{
		guy cmdplayanim( "thu_alrt_traversal_jumpdownloop_foregrip", true );
	}
	
	wait( .25 );
	
	part = getent( "jumper_part1", "targetname" );
	node moveto( part.origin, 0.4, 0.05, 0.05 );
	wait( 0.25 );
	node moveto( ground.origin, 0.7, 0.05, 0.05 );

	if(IsDefined(guy))
	{
		guy lockalertstate( "alert_red" );
		guy setcombatrole( "rusher" );
		guy setforcethreat( level.player, true );
		guy allowedstances( "crouch", "stand" );
	}
	
	wait( 0.7 );
	if(IsDefined(guy))
	{
		guy stopallcmds();
	}	
	wait( .1 );
	if(IsDefined(guy))
	{
		guy unlink();

		guy setenablesense( true );
		guy turn_on_sense();
	}
}

heli_flyby_shoot( tgt_pos, spread_min, spread_max )
{
	level endon("starting_heli_death");
	level endon("heli_done");
	level endon( "phase_1_done" );
	level endon( "flyby_stop_shooting" );

	while ( 1 )
	{
		x_spread = randomfloatrange( spread_min, spread_max );
		y_spread = randomfloatrange( spread_min, spread_max );

		target_pos = level.tgt_pos + ( x_spread, y_spread, 0 );

		magicbullet( "SAF9_SCa", self.origin, target_pos );
		bullettracer( self.origin, target_pos, 1 );

		pause = randomfloatrange( 0.05, 0.10 );
		wait( pause );
	}
}

//====================================================================================================
// helicopter flies in at the end of the level
//====================================================================================================
heli_init()
{
	heli_start = getent( "heli_start", "targetname" );
	heli = spawnvehicle( "v_heli_sca_red", "Cutscene_Spawned_1", "blackhawk", (heli_start.origin), (heli_start.angles) );
	//heli.vehicletype = "blackhawk";
	//heli.script_int = 1;
	//maps\_vehicle::vehicle_init( heli );
	
	//Start Helicopter Music - Added by crussom
	level notify("playmusicpackage_helicopter");

	level.tag_flash = heli gettagorigin( "tag_flash" );

	heli.health = level.heli_health;

	heli UseAnimTree( #animtree );
	heli setanim( %bh_rotors );

	heli setspeed( level.heli_spd_rise, level.heli_acc_rise );
	heli thread heli_under_light( 0, 0, 10 );

	intro = getent( "heli_intro", "targetname" );
	heli setvehgoalpos( intro.origin, 1 );
	wait( .8 );

	heli thread heli_block_path();
	heli waittill( "path_blocked" );

	heli thread heli_damaged();
	heli thread heli_damage_fx();

	wait( 1.5 );

	heli thread heli_support2();
	//heli thread heli_phase_1();
	heli thread maps\sciencecenter_a::objective_05B();
}

//====================================================================================================
// heli shoots and blows up part of the building to gate the player
//====================================================================================================
heli_block_path()
{
	block = getent( "roof_block", "targetname" );

	if ( isdefined(block) )
	{
		block rotateroll( 90, 1, 0.15 );
		block playsound("barricade_fall");

		playfx( level._effect["science_chopper_boom"], block.origin );
		earthquake( 0.7, 1.5, level.player.origin, 2700 );

		level notify ("fx_roof_vent"); //CG - adding an effect
		
		self setlookatent( block );

		level.tgt_pos = block.origin;
		self thread heli_shoot( block.origin, -10, 10 );
	}
	else
	{
		wait( 0.1 );
	}

	wait( 1.5 );
	self notify( "stop_shooting" );
	self notify( "path_blocked" );
}

//====================================================================================================
//====================================================================================================
heli_support()
{
	thread cover_watch();

	self thread heli_support_move();
	self thread heli_check_flank(1);
	self thread heli_check_flank(2);
	wait( 2 );
	self thread heli_support_shoot();
}

heli_strafe_shoot()
{
	level endon("starting_heli_death");	
	
	self endon( "stop_strafe_shoot" );
	spread_min = 0;
	spread_max = 0;

	if ( level.difficulty == 0 )
	{
		spread_min = -48;
		spread_max = 48;
	}
	else if ( level.difficulty == 1 )
	{
		spread_min = -24;
		spread_max = 24;
	}
	else
	{
		spread_min = -12;
		spread_max = 12;
	}

	while ( 1 )
	{
		x_spread = randomfloatrange( spread_min, spread_max );
		y_spread = randomfloatrange( spread_min, spread_max );

		target_pos = level.tgt_pos + ( x_spread, y_spread, 0 );

		start_pos = self gettagorigin( "tag_flash" );

//		if ( isdefined(start_pos) )
		if ( self.health > 0 )
		{
			magicbullet( "SAF9_SCa", start_pos, target_pos );
			bullettracer( start_pos, target_pos, 1 );
		}

		pause = randomfloatrange( 0.05, 0.2 );
		wait( pause );
	}
}

heli_strafe()
{
	level endon("starting_heli_death");
		
	self endon( "heli_strafe_stop" );
	self setspeed( 40, 40 );

	left = 0;
	while ( 1 )
	{
		// strafe left and right for 15 secs
		//left = randomint( 2 );
		angleOffset = 0;
		outro = getent( "heli_outro", "targetname" );
		if ( left )
		{
			left = 0;
			angleOffset = 90;
			outro = getent( "heli_outro2", "targetname" );
		}
		else
		{
			left = 1;
			angleOffset = -90;
		}

		strafeDir = self.angles + ( 0, angleOffset, 0 );
		newAngles = vectornormalize( anglestoforward( strafeDir ) );
		strafeDist = randomintrange( 500, 600 );
		newPos = self.origin + vectorscale( newAngles, strafeDist );

		self thread heli_strafe_shoot();
		self thread update_shoot_pos();
		
		if ( level.heli_at_end == 1 )
		{
			newPos = outro.origin;
		}

		self setvehgoalpos( newPos, 1 );
		//iprintlnbold ("SOUND: heli strafe");
		self waittill( "goal" );
		self notify( "stop_strafe_shoot" );

		// pause at the goal
		wait( 2 );
	}
}

render_line( start, end )
{
	while ( 1 )
	{
		line( start, end );
		wait( 0.1 );
	}
}

heli_grenade()
{
	done = false;
	vel = ( 0, 0, -10.0 );
	while ( !done )
	{
		heliPos = ( self.origin[0], self.origin[1], 0 );
		playerPos = ( level.player.origin[0], level.player.origin[1], 0 );
		offset = heliPos - playerPos;
		dist = length( offset );
		if ( dist < 500 )
		{
			level.grenade magicgrenademanual( self.origin + (0,0,1), vel, 3.0 );
			done = true;
		}
		wait( .1 );
	}
	wait( .4 );
	level.grenade magicgrenademanual( self.origin + (0,0,1), vel, 3.0 );

	if ( level.difficulty > 0 )
	{
		wait( .4 );
		level.grenade magicgrenademanual( self.origin + (0,0,1), vel, 3.0 );
	}
	if ( level.difficulty > 1 )
	{
		timer = randomfloatrange( 1.5, 2.5 );
		wait( .2 );
		level.grenade magicgrenademanual( self.origin + (0,0,1), vel, timer );
		wait( .2 );
		level.grenade magicgrenademanual( self.origin + (0,0,1), vel, timer );
	}
	wait( .1 );
}
heli_charge()
{
	self endon( "heli_charge_stop" );

	level.heli_charging = 1;
	if ( level.current_pos == 1 )
	{
		level.current_pos = 0;
	}
	else
	{
		level.current_pos = 1;
	}

	// make dive run at player, drop grenade
	headDir = vectornormalize( level.player.origin - self.origin );
	headDir = vectorscale( headDir, 2400 );
	tempPos = level.player.origin + ( headDir[0], headDir[1], 0 );
//	newPos = ( headDir[0], headDir[1], self.origin[2] );
	newPos = ( level.player.origin[0], level.player.origin[1], self.origin[2] );

	//str = "x " + newPos[0] + " y " + newPos[1];
	//iprintlnbold( str );
	//render_line( self.origin, newPos );

	if ( level.heli_grenadeEnabled == 1 )
	{
		self thread heli_grenade();
	}

	self setspeed( 60, 20 );
	//self setspeed( 1, 1 );
	self setvehgoalpos( newPos, 0 );
	//iprintlnbold ("SOUND: heli flyby - charge 1");
	self playsound ("police_helicopter_intro");
	self waittill( "goal" );

	start = getent( "heli_intro", "targetname" );
	end = getent( "heli_back", "targetname" );
	dist_start = length( self.origin - start.origin );
	dist_end = length( self.origin - end.origin );

	if ( level.current_pos == 1 )
	{
		newPos = end.origin;
	}
	else
	{
		newPos = start.origin;
	}
	self setvehgoalpos( newPos, 1 );
	//iprintlnbold ("SOUND: heli flyby - after charge");
	self waittill( "goal" );


	wait( .1 );


	level.heli_charging = 0;
	self notify( "heli_charge_done" );
}

heli_fly_to_end()
{
	self setspeed( 40, 25 );
	pos = getent( "heli_outro", "targetname" );
	self setvehgoalpos( pos.origin, 1 );
	//iprintlnbold ("SOUND: heli flyby - final");
	self waittill( "goal" );
	self notify( "heli_at_end" );
	level.heli_shield = 0;
	level.current_pos = 0;
	self.health = 10;
}

heli_support2()
{
	level endon("starting_heli_death");
		
	self setlookatent( level.player );

	// spawn gunner
	if ( level.heli_grenadeEnabled == 1 )
	{
		spawner = getent( "spawner_grenade", "targetname" );
		level.grenade = spawner stalingradspawn();
		level.grenade setenablesense( false );
	}
	//gunner_node = getent( "heli_gunner", "targetname" );
	//gunner_node.origin = level.grenade.origin;
	//level.grenade linkto( gunner_node );
	//wait( .1 );
	//gunner_node.origin = self gettagorigin( "tag_playerride" ) + (0, -8, 8);
	//gunner_node.angles = self gettagangles( "tag_playerride" ) + (0, 90, 0);
	//wait( .1 );
	//level.grenade linkto( self, "tag_playerride" );
	//level.grenade cmdplayanim( "thu_crouch_aim_loop_dn_foregrip", true );

	while ( 1 )
	{
		self thread heli_strafe();
		wait( level.strafe_time );
		self waittill( "goal" );
		self notify( "heli_strafe_stop" );
		wait( .1 );

		if ( level.charge == 0 )
		{
			if ( self.health < level.heli_diff_1 )
			{
				level.charge++;
				level.difficulty++;
				level.strafe_time -= 4;
			}
		}
		else if ( level.charge == 1 )
		{
			if ( self.health < level.heli_diff_2 )
			{
				level.charge++;
				level.difficulty++;
				level.strafe_time -= 4;
			}
		}

		if ( self.health > level.heli_diff_3 )
		{
			self notify( "stop_strafe_shoot" );		// in case it was still shooting
			self thread heli_charge();
			self waittill( "heli_charge_done" );
		}
		else if ( level.heli_at_end == 0 )
		{
			level.heli_shield = 1;
			//if ( level.current_pos == 1 )
			{
				self notify( "stop_strafe_shoot" );		// in case it was still shooting
				self thread heli_fly_to_end();
				self waittill( "heli_at_end" );
				level.current_pos = 0;
			}
			level.heli_at_end = 1;
		}
	}
}

heli_check_flank( pos )
{
	level endon("starting_heli_death");
		
	str = "trigger_flank_" + pos;
	flank = getent( str, "targetname" );

	while ( 1 )
	{
		// start timer
		if ( level.flank[pos] == 0 )
		{
			if ( level.player isTouching(flank) )
			{
				wait( 5 );
				// player is still there, move to flank
				if ( level.player isTouching(flank) )
				{
					level.flank[pos] = 1;
				}
			}
		}
		wait( .1 );
	}
}

heli_support_move()
{
	level endon("starting_heli_death");
		
	level endon( "heli_done" );

	self setlookatent( level.player );

	prev = -1;
	idx = 0;
	max = 3;

	while ( 1 )
	{
		// check non-destructible first
		t_flank_1 = getent( "trigger_flank_1", "targetname" );
		t_flank_2 = getent( "trigger_flank_2", "targetname" );

		if ( level.flank[1] == 1 )
		{
			level.flank[1] = 0;
			pos = getent( "heli_flank_1", "targetname" );
			self setvehgoalpos( pos.origin, 1 );
			self waittill( "goal" );

			wait( 5 );
		}
		else if ( level.flank[2] == 1 )
		{
			level.flank[2] = 0;
			pos = getent( "heli_flank_2", "targetname" );
			self setvehgoalpos( pos.origin, 1 );
			self waittill( "goal" );

			wait( 5 );
		}
		else
		{
			dprint( "goto pos " + idx );
			str = "heli_support_" + idx;
			pos = getent( str, "targetname" );
			
			self setvehgoalpos( pos.origin, 1 );
			self waittill( "goal" );

			wait( 5 );

			pick = randomintrange( 0, 3 );
			if ( pick == prev )
			{
				pick++;
				if ( pick >= max )
				{
					pick = 0;
				}
			}
			prev = pick;
			idx = pick;
		}

		wait( .1 );
	}
}

heli_support_shoot()
{
	level endon("starting_heli_death");
		
	level endon( "heli_done" );

	while ( 1 )
	{
		level.tgt_pos = level.player geteyeposition();
		self thread heli_shoot( level.tgt_pos, level.heli_support_spread_min, level.heli_support_spread_max );
		self thread update_shoot_pos();
		wait( level.heli_support_shoot_time );
		self notify( "stop_shooting" );
		wait( level.heli_support_wait_time );
	}
}

//====================================================================================================
// This is the first part of the heli fight.
// The heli circles the player, while trying to acquire los, slows down to shoot for a bit, then 
//	moves on.
//====================================================================================================
heli_phase_1()
{
	level.pos = 1;

	self thread heli_circle();

	self waittill( "start_shoot" );
	self thread heli_check_shoot();
}

heli_circle()
{
	level endon("starting_heli_death");
		
	level endon( "heli_done" );
	level endon( "phase_1_done" );

	self setlookatent( level.player );
	self setspeed( level.heli_spd_default, level.heli_acc_default );

	while ( 1 )
	{
		// circle around
		tgt = "phase1_" + level.pos;
		org = getent( tgt, "targetname" );
		
		self setvehgoalpos( org.origin, 0 );
		self waittill( "goal" );
		self notify( "start_shoot" );

		level.pos++;
		if ( level.pos >= 8 )
		{
			level.pos = 1;
		}
	}
}

heli_check_shoot()
{
	level endon("starting_heli_death");
		
	level endon( "heli_done" );
	level endon( "phase_1_done" );
	while ( 1 )
	{
		eye = level.player geteye();
		los = bullettracepassed( self.origin, eye, false, undefined );
		if ( los )
		{
			self setspeed( level.heli_spd_attack, level.heli_acc_attack );
			//iprintlnbold( "targeting..." );
			wait( 1.5 );
			shoot_pos = level.player geteye();
			level.tgt_pos = shoot_pos;
			self thread heli_shoot( shoot_pos, level.spread_attack_min, level.spread_attack_max );
			self thread update_shoot_pos();
			wait( 3 );
			self notify( "stop_shooting" );
			self setspeed( level.heli_spd_default, level.heli_acc_default );
			wait( 2 );
		}
		wait( .1 );
	}
}

//====================================================================================================
// This is the 2nd part of the heli fight.
// Heli moves to a point, then runs straight at the player while shooting more accurately
//====================================================================================================
heli_phase_2()
{
	level endon("starting_heli_death");
		
	dprint( "start phase 2" );

	self clearlookatent();
	self setspeed( level.heli_spd_phase2, level.heli_acc_phase2 );

	// find the furthest point from player
	points = getentarray( "heli_attack", "targetname" );

	level.next_run = 0;

	far_idx = 0;
	far_dist = 0.0;
	dist = 0.0;

	for ( i = 0; i < 4; i++ )
	{
		str = "phase2_" + i;
		pos = getent( str, "targetname" );
		dist = Distance( pos.origin, level.player.origin );
		if ( dist > far_dist )
		{
			far_idx = i;
			far_dist = dist;
		}
	}

	str = "phase2_" + far_idx;
	pos = getent( str, "targetname" );
	level.next_run = far_idx;

	self setvehgoalpos( pos.origin, 1 );
	self waittill( "goal" );

	self thread heli_direct_run();
}

heli_direct_run()
{
	level endon("starting_heli_death");
		
	level endon( "heli_done" );

	self setspeed( 30, 30 );

	while ( 1 )
	{
		dir = level.player.origin - self.origin;

		yaw = vectortoangles( dir )[1];

		// face the player and shoot ground leading up to them
		if ( self.health > 0 )
		{
			self setyawspeed( 180, 90 );
			self setlookatent( level.player );
		}
	
		notFacing = 1;
		while ( notFacing )
		{
			yawDiff = AbsAngleClamp180( yaw - self.angles[1] );
			if ( yawDiff <= 10 )
			{
				notFacing = 0;
			}
			wait( .1 );
		}

		dir = vectorscale( dir, 2 );
		dest = self.origin + ( dir[0], dir[1], 0 );

//		line( self.origin, dest );

		self setvehgoalpos( dest, 1 );

		self thread heli_shoot_near();

		self waittill( "stop_shooting" );

		level.next_run++;
		if ( level.next_run > 3 )
		{
			level.next_run = 0;
		}
		close = level.next_run;

		str = "phase2_" + close;
		goal = getent( str, "targetname" );

		self clearlookatent();
		self setvehgoalpos( goal.origin, 1 );
		self waittill( "goal" );
	}
}

heli_shoot_near()
{
	// target the ground in front of the player 
	dir = level.player.origin - self.origin;
	dir = vectorscale( dir, 0.5 );
	dest = level.player.origin - ( dir[0], dir[1], 0 );

	self thread heli_shoot( level.player.origin, -10, 10 );
	self thread update_shoot_pos();
	wait( 3 );
	self notify( "stop_shooting" );
}

update_shoot_pos()
{
	level endon("starting_heli_death");
		
	self endon( "stop_shooting" );
	level endon( "flyby_stop_shooting" );
	while ( 1 )
	{
		level.tgt_pos = level.player geteyeposition();
		wait( level.update_pos_time );
	}
}

//====================================================================================================
// Handles shooting from heli, with optional spread.
//====================================================================================================
heli_shoot( tgt_pos, spread_min, spread_max )
{
	level endon("starting_heli_death");
		
	level endon("heli_done");
	level endon( "phase_1_done" );
	self endon( "stop_shooting" );

	while ( 1 )
	{
		x_spread = randomfloatrange( spread_min, spread_max );
		y_spread = randomfloatrange( spread_min, spread_max );

		target_pos = level.tgt_pos + ( x_spread, y_spread, 0 );

		start_pos = self gettagorigin( "tag_flash" );

		//if ( isdefined(level.entOrigin) )
		{
			magicbullet( "SAF9_SCa", start_pos, target_pos );
			bullettracer( start_pos, target_pos, 1 );
		}

		//line( level.entOrigin.origin, target_pos );
		//maps\_spawner::waitframe();

		pause = randomfloatrange( 0.05, 0.2 );
		wait( pause );
	}
}

//====================================================================================================
// Handles the heli finish, play fx, clean up, trigger ending anim sequence.
//====================================================================================================
heli_damaged()
{
	level endon("starting_heli_death");
		
	level endon("heli_done");
	phase = 1;
	while ( 1 )
	{
		//str = "health = " + self.health;
		//print3d( self.origin+(0,0,72), str, (1.0, 0.8, 0.5), 1, 1, 25 );

		/*
		// check for phase 2
		if ( phase == 1 )
		{
			if ( self.health < level.heli_health_phase_2 )
			{
				level notify( "phase_1_done" );
				self thread heli_phase_2();
				phase = 2;
			}
		}
		*/

		if ( level.health_fx_1 == 0 )
		{
			if ( self.health < level.heli_diff_1 )
			{
				playfxontag ( level._effect["science_chopper_boom"], self, "tag_engine_left" );
				playfxontag ( level._effect["science_chopper_fire"], self, "tag_engine_left" );
				//iprintlnbold ("SOUND: heli damage - One");
				self playsound ("heli_explosion");
				level.health_fx_1 = 1;
			}
		}
		if ( level.health_fx_2 == 0 )
		{
			if ( self.health < level.heli_diff_2 )
			{
				playfxontag ( level._effect["science_chopper_boom"], self, "front_door_r_jnt" );
				playfxontag ( level._effect["science_chopper_fire"], self, "front_door_r_jnt" );
				//iprintlnbold ("SOUND: heli damage - Two");
				self playsound ("heli_explosion");
				level.health_fx_2 = 1;
			}
		}

		if ( self.health < 0 && level.heli_shield == 0 && level.current_pos == 0 )
		{
			dprint( "heli is dead" );
			//playfx ( level._effect["heli_explosion"], self.origin );
			//self delete();

			self notify( "stop_strafe_shoot" );

			//playcutscene( "SCA_Heli_Crash", "cutscene_done" );
			self thread destroy_heli_effects();
			
			level notify( "heli_done" );
		}

		wait( 1 );
	}
}

heli_damage_fx()
{
	level endon("starting_heli_death");
		
	prev_health = self.health;

	while ( 1 )
	{
		if ( self.health > 500 )
		{
			if ( level.health_init_fx == 0 )
			{
				if ( self.health < prev_health )
				{
					prev_health = self.health;
					playfxontag ( level._effect["science_chopper_boom"], self, "tag_driver" );
					//iprintlnbold ("SOUND: heli damage - impact");
					self playsound ("heli_impact_damage");
					level.health_init_fx = 1;
				}
			}
			else if ( level.health_init_fx == 1 )	// wait a little before the next fx
			{
				wait( 2 );
				level.health_init_fx = 0;
				prev_health = self.health;
			}
		}
		wait( .1 );
	}
}

//CG - playing effects on the helicopter and cut cables
destroy_heli_effects()
{
	level notify("starting_heli_death");
	self.goalradius = 64;
	end_pos = getent("heli_support_2", "targetname");
	self setvehgoalpos( end_pos.origin + (-275, 0, -175), 1 );
	//iprintlnbold("moving into position.");
	
	thread finale_mayday();

	self waittill( "goal" );
	//iprintlnbold("In position, start death.");

	//wait(0.5);
	playfxontag ( level._effect["science_chopper_boom"], self, "TAG_FastRope_RI" );

	playcutscene( "SCA_Heli_Crash", "final_cutscene_done" );
	//notetrack effects...

	self playsound( "chopper_crash" );

	self waittillmatch( "anim_notetrack", "heli_explode_1" );
	playfxontag ( level._effect["science_chopper_boom"], self, "TAG_FastRope_RI" );
	playfxontag ( level._effect["science_chopper_fire"], self, "TAG_FastRope_RI" );

	self waittillmatch( "anim_notetrack", "heli_explode_2" );
	playfxontag ( level._effect["science_chopper_boom"], self, "TAG_FastRope_RI" );

	thread finale_dialog();

	self waittillmatch( "anim_notetrack", "heli_wire_cut" );
	level notify("heli_wire_cut_start");

	self waittillmatch( "anim_notetrack", "heli_explode_3" );
	level notify("heli_death"); 
	
	earthquake( 0.7, 2.0, level.player.origin, 2700 );
		
	//End Music - Added by crussom
	level notify("endmusicpackage");

	level waittill("final_cutscene_done"); 
	//thread maps\sciencecenter_a::objective_06();
	
	wait(1.0);	
	level notify( "end_science_center_a" );
}
finale_mayday()
{
	// AE 7/1/08: added vo
	level.player play_dialogue("HELI_SciAG_041A", true); // mayday
}	
finale_dialog()
{
	// AE 7/1/08: added vo
	//iprintlnbold("playing finale vo!");
	level.player play_dialogue("SCS1_SciAG_042A", true); // eagle one, what's your location
	//iprintlnbold("finale vo played!");

}	

//====================================================================================================
// Places the spotlight under the heli.
//====================================================================================================
heli_under_light( angle_x, angle_y, angle_z )
{
	//org = getent ( "front_heli_spawn_point", "targetname" );
	level.entOrigin = Spawn( "script_model", self GetTagOrigin( "tag_ground" ) );
	level.entOrigin SetModel( "tag_origin" );
	level.entOrigin.angles = ( angle_x, angle_y, angle_z );
	level.entOrigin LinkTo( self );

	// playfx
	playfxontag ( level._effect["science_lightbeam05"], level.entOrigin, "tag_origin" );

	level waittill( "heli_done" );
	level.entOrigin delete();
}

//====================================================================================================
//====================================================================================================
cover_watch()
{
}
