#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#include maps\sciencecenter_a_util;

#include maps\_distraction;


backlot_main()
{
	
	level.AIdead = 0;
	level.AIspawned = 0;
	
	thread SetupChallenge();
	thread backlot_autosave();
	
	
	level thread maps\sciencecenter_a_ledge::ledge_main();
	
	
}




backlot_autosave()
{
	trigger = getent ( "map_level_02a", "targetname" );
	trigger waittill ( "trigger" );
	thread	maps\_autosave::autosave_by_name("MiamiScienceCenter");
	thread maps\sciencecenter_a::objective_04();

	
	level.player play_dialogue("SCS1_SciAG_027A", true);
}


countAIdeath()
{
	self waittill("death");

	level.AIdead++;
}
calm_down()
{
	while(level.AIdead < level.AIspawned)
	{
		wait(0.5);
	}

	
	level notify("playmusicpackage_ledge");
}



StartSequence_dialog()
{
	
	level.player play_dialogue("BMR1_SciAG_020A", true);
	wait(0.5);
	level.player play_dialogue("SCS1_SciAG_021A", true);
}

VanListener_dialog()
{
	
	level.player play_dialogue("BMR2_SciAG_022A");
	wait(0.5);
	level.player play_dialogue("BMR3_SciAG_023A", true);
	
	level waittill("sending_additional");
	level.player play_dialogue("SCS1_SciAG_024A", true);
}

RoofListener_dialog()
{
	
	level.player play_dialogue("SCS1_SciAG_025A", true);
	wait(0.5);
	level.player play_dialogue("BMR4_SciAG_026A", true);

}	







SetupChallenge()
{
	

	self thread NotifyWhenTrigger("backlot_trigger_cleanup", "backlot_clean_ai");	

	self thread StartTriggerListener();
	self thread StartSequence();

	self thread VanTeaserTriggerListener();
	self thread VanTeaserListener();
	
	self thread VanTriggerListener();
	self thread VanListener();
	
	self thread RoofTeaserTriggerListener();	
	self thread RoofTeaserListener();
	
	self thread RoofTriggerListener();	
	self thread RoofListener();
	
	self thread StairwayTeaserTriggerListener();	
	self thread StairwayTeaserListener();
	
	self thread StairwayTriggerListener();	
	self thread StairwayListener();
}




SetupVehicle()
{
	level.VehicleExplosionCanKillPlayer = false;

	vehicles = GetEntArray( "dest_v_sedan", "targetname" );	

	for( i = 0 ;  i < vehicles.size; i++ )
	{
		vehicles[i] thread maps\_vehicle::bond_veh_death();
		vehicles[i] thread maps\_vehicle::bond_veh_flat_tire();
	}

	van = GetEnt( "backlot_Van_Static", "targetname" );	

	van thread maps\_vehicle::bond_veh_death();
	van thread maps\_vehicle::bond_veh_flat_tire();

}




StartTriggerListener()
{
	self endon( "death" );
	
	self NotifyWhenTrigger("backlot_trigger_start", "backlot_start");	
}




StartSequence()
{	
	
	
	self endon( "death" );
	
	
	
	self waittill("backlot_start");

	
	
	ai = self SpawnAi("backlot_StartDudes");

	
	
	level.AIspawned += ai.size;

	for(i = 0; i < ai.size; i++)
	{
		if( IsDefined(ai[i]) )
		{
			

			ai[i] thread IgnorePlayerTimer(2);

			
			ai[i] thread countAIdeath();
		}
	}

	thread StartSequence_dialog();

	
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");

	
	
	self NotifyWhenXAlive(ai, 0, "backlot_start_vanteaser");

	
}




VanTeaserTriggerListener()
{	
	self endon( "death" );
	
	self NotifyWhenTrigger("backlot_trigger_van_teaser", "backlot_start_vanteaser");
}









VanTeaserListener()
{	
	self endon( "death" );
	
	
	
	self waittill("backlot_start_vanteaser");
	
	
	
	ai = self SpawnAi("backlot_vanTeaser", 0.1, 0.3 );

	
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");
	
	

	
	level.AIspawned += ai.size;
	
	for(i = 0; i < ai.size; i++)
	{
		self  NotifyDamage( ai[i], "backlot_start_van", randomfloatrange(0.25, 0.75));

		
		ai[i] thread countAIdeath();
	}

	
	
	
}
	


	
NotifyDamage(ai, msg, time)
{
	ai waittill("damage");

	if( IsDefined(time) )
	{
		wait(time);
	}

	self notify("backlot_start_van");
}




VanTriggerListener()
{
	self endon( "death" );
	
	self NotifyWhenTrigger("backlot_trigger_van", "backlot_start_van");	
}




VanListener()
{	
	self endon( "death" );
	
	
	
	
	van			= GetEnt("backlot_Van", "targetname" );	
	van.health	= 1000000;


	vanStartNode  = GetVehicleNode("backlot_VanStartNode",	"targetname");
	
	van attachpath(vanStartNode);
	
	
	self waittill("backlot_start_van");	

	thread VanListener_dialog();

	
		
	
	
	{		
		van attachpath(vanStartNode);
		van StartPath();

		van playsound("van_peel_out");
	
		van thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight"], "tag_light_l_front" );
		van thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight"], "tag_light_r_front" );
		van thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_l_back"  );
		van thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_r_back"  );
							
		
		level notify("playmusicpackage_backlot");
				
		van waittill( "reached_end_node" );
		wait(2);	

		newVan = GetEnt( "backlot_Van_Static", "targetname" );
		newVan.takedamage = false;

		newVan.origin = van.origin;
		newVan.angles = van.angles;

		
		wait(0.10);

		van delete();	

	
	}
	
	
	
	
	wait(0.1);
	
	
	
	ai = self SpawnAi("backlot_VanDudes", 0.1, 0.2);

	
	level.AIspawned += ai.size;

	
			
	for( i=0; i<ai.size; i++ )
	{
		if( IsDefined(ai[i]) )
		{
			ai[i] AddEngageRule("TgtPerceive");
			
			
			ai[i] thread countAIdeath();
		}
	}

	
	level notify("sending_additional");

	
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");
	
	
	self thread TrySaveWhenAllDeath(getaiarray ("axis"),"BackLotPostVan");
	
	
	
	self NotifyWhenXAlive(ai, 0, "backlot_start_roofteaser", 10);
	
	
	
}




RoofTeaserTriggerListener()
{	
	self endon( "death" );
	
	self NotifyWhenTrigger("backlot_trigger_roof_teaser", "backlot_start_roofteaser");
}









RoofTeaserListener()
{	
	self endon( "death" );
	
	
	
	self waittill("backlot_start_roofteaser");
	
	
	
	ai = self SpawnAi("backlot_RoofTeaser", 0.0, 0.1 );
	
	
	level.AIspawned += ai.size;

	for(i=0;i<ai.size; i++)
	{
		ai[i] thread backlot_RoofTeaserThread();

		
		ai[i] thread countAIdeath();
	}

	
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");
	
	
	
	self NotifyWhenXAlive(ai, 0, "backlot_start_roof", 4);
	
	
		
	
	level notify("mus_sca_stealth_lp");
}




backlot_RoofTeaserThread()
{
	
	
	self cmdshootatentity( level.player, false, 1, 0 );

	self waittill("cmd_done");
		
	self setgoalnode (	getnode("RoofTeaserGoal1", "targetname"), 0);

	self waittill("goal");

	self setgoalnode (	getnode("RoofTeaserGoal2", "targetname"), 1);	
}




RoofTriggerListener()
{	
	self endon( "death" );
	
	self NotifyWhenTrigger("backlot_trigger_roof", "backlot_start_roof");
}





RoofListener()
{	
	

	self endon( "death" );
	
	
	
	self waittill("backlot_start_roof");
	
	thread RoofListener_dialog();
	
	
	

	ai1 = self SpawnAi( "backlot_RoofDudes1", 0.0, 0.0 );
	
	ai  = self SpawnAi( "backlot_RoofDudes",  1.0, 2.0 );

	ai	= MergeArray(ai, ai1);

	
	level.AIspawned += ai.size;
	for(i = 0; i < ai.size; i++)
	{
		
		ai[i] thread countAIdeath();
	}
	
	level thread calm_down();

	
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");
	
	
	
	
	
	
}




StairwayTeaserTriggerListener()
{	
	

	self endon( "death" );

	
	
	self NotifyWhenTrigger("backlot_trigger_stairway_teaser", "backlot_stairway_start_teaser");

	
}




StairwayTeaserListener()
{	
	
	
	self endon( "death" );
	
	
	
	self waittill("backlot_stairway_start_teaser");
	
	
	
	ai = self SpawnAi("backlot_StairwayTeaser", 1.0, 2.0 );
	
	
	level.AIspawned += ai.size;

	for(i=0;i<ai.size; i++)
	{
		ai[i] thread backlot_StairwayTeaserThread();

		
		ai[i] thread countAIdeath();
		
	}

	
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");
	
	
}




backlot_StairwayTeaserThread()
{
	
	
	self setgoalnode (	getnode("StairwayTeaserGoal1", "targetname"));
	self waittill("goal");
	
	
	
	
	

	
	
	
	

	
	
	
	
}




StairwayTriggerListener()
{		
	
	
	self endon( "death" );
	
	
	
	self NotifyWhenTrigger("backlot_trigger_stairway", "backlot_stairway_start");
	
	
}




StairwayListener()
{	
	
	
	self endon( "death" );
	
	
	
	self waittill("backlot_stairway_start");
	
	
	
	ai = self SpawnRandomAi("backlot_StairwayDudes");

	

	
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");
	
	
	
	self NotifyWhenXAlive(ai, 0, "backlot_done");
	
	
}




IgnorePlayerTimer(time)
{	
	self endon( "death" );

	self SetIgnoreThreat(level.player, true);
	
	wait(time);

	self SetIgnoreThreat(level.player, false);
}




MergeArray(me, add)
{
	if( !IsDefined( me ) )
	{
		me = [];
	}
	
	mySize = me.size;

	for( i=0; i<add.size; i++ )
	{
		me[mySize+i] = add[i];
	}

	return me;
}




SpawnAi( aiName, delayMin, delayMax )
{	
	ai		 = [];
	spawners = GetEntArray( aiName, "targetname" );	
	
	if( isdefined(spawners) )
	{	
		if( !isdefined(delayMin) )
		{
			delayMin= 0;
		}
		if( !isdefined(delayMax) )
		{
			delayMax= 0;
		}

		for( i=0; i<spawners.size; i++ )
		{
			if( delayMin > 0 || delayMax > 0 )
			{
				wait( randomfloatrange(delayMin,delayMax) );
			}

			ai[i] = spawners[i] StalingradSpawn();

			
			
			ai[i].destructibledamagescale = 0.5;
			ai[i].candestroydestructible  = false;	
		}
	}

	return ai;

}




SpawnRandomAi( aiName )
{	
	ai		 = [];
	spawners = GetEntArray( aiName, "targetname" );	
	
	if( isdefined(spawners))
	{	
		ai[0] = spawners[randomIntRange(0, spawners.size)] StalingradSpawn();
	}
	
	return ai;

}




TrySaveWhenAllDeath(aiArray, saveName)
{
	self endon( "death" );

	self thread NotifyWhenXAlive( aiArray, 0, saveName );

	
	self waittill(saveName);
		
	
	
	
	maps\_autosave::autosave_by_name( saveName, 30 );

}




CleanupAiListener( aiArray, msg )
{	
	self endon( "death" );

	self waittill(msg);
			
	
	if( level.AIspawned - level.AIdead > 5 )
	{
		
	}
	else
	{
		for( i=0; i<aiArray.size; i++ )
		{	
			if( IsDefined(aiArray[i]) )
			{
				aiArray[i] delete();
			}
		}	
	}
	
	
	level waittill ( "roof_access" );
	
	for( i=0; i<aiArray.size; i++ )
	{	
		if( IsDefined(aiArray[i]) )
		{
			aiArray[i] delete();
		}
	}
}




NotifyWhenTrigger( trigger_name, msg )
{	
	self endon( "death" );
	
	trigger = GetEnt(trigger_name,"targetname");
	
	if( isdefined(trigger) )
	{
		trigger waittill("trigger");
		
		
		
		self notify(msg);	
	}	
	else
	{
		
	}
}




NotifyWhenXAlive( aiArray, x, msg, timer )
{
	self endon( "death" );
	
	numAlive = 100000;
	
	while( numAlive > x )
	{	
		wait(0.2);
		
		numAlive = 0;
		
		for( i=0; i<aiArray.size; i++ )
		{
			if( IsDefined(aiArray[i]) )
			{
				numAlive++;
			}
		}
		
		
	}
	
	if( IsDefined(timer) )
	{
		wait(timer);
	}

	
	self notify(msg);	
}