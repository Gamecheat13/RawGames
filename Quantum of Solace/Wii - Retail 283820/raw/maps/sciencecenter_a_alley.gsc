#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#include maps\sciencecenter_a_util;


alley_main()
{
	level thread spawn_alley_thugs();
	level thread alley_beer_roll();
	level thread alley_camera_cover();
	level thread alley_clearing_traffic();
	level thread alley_adding_traffic();
	
	level thread setup_backlot_combat();
}





spawn_alley_thugs()
{
		thug_dumpster = GetEnt( "thug_dumpster", "targetname" );
		thug = thug_dumpster StalingradSpawn("thug");
		thug thread alley_waittill_crossing();
		thug thread alley_cleanup();
		
		thug thread after_death_vo();

		alley_thug_patrol = GetEntArray( "alley_thug_patrol", "targetname" );
		if ( IsDefined(alley_thug_patrol) )
		{
			for (i=0; i<alley_thug_patrol.size; i++)
			{
				alley_thug[i] = alley_thug_patrol[i] StalingradSpawn();
				alley_thug[i] thread alley_waittill_crossing();
				alley_thug[i] thread alley_cleanup();
			}
		}
		
		level waittill("street_crossing_done");
		thug thread global_ai_random_anims();

		
		wait(0.5);
		thug_dumpster play_dialogue("DUMR_SciAG_014A"); 
		wait(0.5);
		alley_thug_patrol[0] play_dialogue("ALMR_SciAG_015A"); 
		wait(0.5);
}
alley_waittill_crossing()
{
	self setenablesense(false);
	
	level waittill("street_crossing_done");
	self setenablesense(true);
	thread check_alley_alert();
}	

after_death_vo()
{
	self waittill("death");
	
	level.player play_dialogue("SCS1_SciAG_016A", true); 
	wait(1.0);
	level.player play_dialogue("SCS1_SciAG_017A", true); 
	wait(1.0);
	level.player play_dialogue("DUMR_SciAG_018A", true); 
}

check_alley_alert()
{
	self endon( "death" );
	
	
	if( self getalertstate() != "alert_red" )
	{
		self waittill( "start_propagation" );
	}
	
	
	alley_thug_spawner = GetEntArray( "alley_thug_alerted", "targetname" );
	if ( IsDefined(alley_thug_spawner) )
	{
		for (i=0; i<alley_thug_spawner.size; i++)
		{
			alley_thug_alerted[i] = alley_thug_spawner[i] StalingradSpawn();
			if( !spawn_failed( alley_thug_alerted[i] ) )
			{
				alley_thug_alerted[i] thread alley_cleanup();
			}
			else
			{
				
			}	
		}
	}

	if(level.alley_door_closed == true)
	{
		level.alley_door_closed = false;

		
		
		alley_door_cover = getentArray ( "alley_door_cover", "targetname" );
		for (i=0; i<alley_door_cover.size; i++)
		{
			alley_door_cover[i] movez(256, 0.5);
		}			
		

	}	
}		



alley_clearing_traffic()
{
	level endon("catwalk");
	trigger = getent ( "alley_clear_traffic", "targetname" );
	
	while(true)
	{
	trigger waittill ( "trigger" );
	
		if(	level.traffic_running == true)
		{
			level notify ( "enter_back_lot" );
			level.traffic_running = false;
		}
		wait(0.05);
	}
}



alley_adding_traffic()
{
	level endon("catwalk");

	trigger = getent ( "alley_add_traffic", "targetname" );
	
	while(true)
	{
	trigger waittill ( "trigger" );
		if(	level.traffic_running == false)
		{
	level thread maps\sciencecenter_a_vehicle::spawn_eastbound_lane1_vehicles();
	level thread maps\sciencecenter_a_vehicle::spawn_eastbound_lane2_vehicles();
	level thread maps\sciencecenter_a_vehicle::spawn_eastbound_lane3_vehicles();
	level thread maps\sciencecenter_a_vehicle::spawn_eastbound_lane4_vehicles();

			iPrintLnBold ( "traffic is running" );

			level.traffic_running = true;
		}
		wait(0.05);
	}
}



alley_beer_roll()
{
	trigger = getent ( "trigger_alley_beer_roll", "targetname" );
	trigger waittill ( "trigger" );
	
	maps\_utility::unholster_weapons();
	setsaveddvar("melee_enabled", true);
	setsaveddvar("bg_quick_kill_enabled", true);
	level.player switchtoweapon( "p99_wet_s" );

	camera_01 = getent ( "basement_camera_1", "targetname" );
	hack_box_01 = getent ( "alley_camera01_hack_box", "targetname" );
	wait( .05 );
	if(IsDefined(camera_01))
	{
		camera_01 thread maps\_securitycamera::camera_start( hack_box_01, true, false, false );
	}

}




alley_camera_cover()
{
	wait( .5 );
	lid = GetEntArray( "alley_camera_lid", "targetname" );

	for ( i = 0; i<lid.size; i++ )
	{
		lid[i] maps\_distract_object_small::distract_obj_setup( maps\_distraction::phys_push_ondmg, undefined, false );
		lid[i] thread maps\sciencecenter_a::enable_camera_hack();
		lid[i].script_alert = "none";
	}
}

setup_backlot_combat()
{
	trigger = getent ( "start_back_patrol_01", "targetname" );
	trigger waittill ( "trigger" );

	thread maps\sciencecenter_a::objective_03();
	
	
	
	level notify("cleanup_alley");
	
	
	wait(0.05);
	
	
	level thread maps\sciencecenter_a_backlot::backlot_main();
	
	

	thread maps\_autosave::autosave_now("MiamiScienceCenter");
	
	trigger delete();
}	

alley_cleanup()
{
	level waittill("cleanup_alley");
	
	
	if(IsDefined(self))
	{
		if ( !self canSee( level.player ) )
		{
			self delete();
		}	
		else
		{
			
			self SetAlertStateMin( "alert_green" );
			self LockAlertState( "alert_green" );
			self UnlockAlertState();
			
			node = getnode( "alley_cleanup", "targetname" );
			self setgoalnode( node );
			self waittill("goal");
			self delete();
		}	
	}
}	

open_side_door_enemy()
{
	side_enemy_spawner = getent ( "alley_thug_sidedoor", "targetname" );
	alley_side_door = getent ( "alley_side_door", "targetname" );

	trigger = getent ( "alley_side_door_trig", "targetname" );
	trigger waittill ( "trigger" );
	
	if(IsDefined(side_enemy_spawner))
	{
		alley_side_door rotateYaw(100,0.5);
		wait(0.5);
		side_thug = side_enemy_spawner StalingradSpawn();
		if(level.alley_door_closed == false)
		{
			side_thug setperfectsense(true);
			side_thug lockalertstate("alert_red");
		}	
		else
		{
		side_thug thread check_alley_alert();
		}
		side_thug thread alley_cleanup();
		wait(0.5);
		alley_side_door rotateYaw(-100,0.5);

	}	
}	






alley_command_node_01()
{
	self CmdAction( "fidget" );
}

alley_command_node_02()
{
	self CmdAction( "TypeLaptop" );
}
