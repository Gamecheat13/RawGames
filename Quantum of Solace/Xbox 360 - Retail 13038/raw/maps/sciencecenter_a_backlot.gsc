#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#include maps\sciencecenter_a_util;

#include maps\_distraction;
////////////////////////////////////////////////////////////////////////////////////

backlot_main()
{
	// AE 7/7/08: need to know when we can calm the music
	level.AIdead = 0;
	level.AIspawned = 0;
	
	thread SetupChallenge();
	thread backlot_autosave();
	
	// -------- START LEDGE FUNCTIONS -------
	level thread maps\sciencecenter_a_ledge::ledge_main();
	// --------------------------------------
	
	//thread temp_ai_counter();

}

temp_ai_counter()
{
	while(true)
	{
		iprintlnbold("Number of Backlot ai spawned ", level.AIspawned);
		iprintlnbold("Number of Backlot ai dead ", level.AIdead);
		wait(2.0);
	}	
}	
////////////////////////////////////////////////////////////////////////////////////
//					 BACKLOT FUNCTIONS 
////////////////////////////////////////////////////////////////////////////////////
backlot_autosave()
{
	trigger = getent ( "map_level_02a", "targetname" );
	trigger waittill ( "trigger" );
	thread	maps\_autosave::autosave_by_name("MiamiScienceCenter");
	thread maps\sciencecenter_a::objective_04();

	// AE 7/1/08: added vo
	level.player play_dialogue("SCS1_SciAG_027A", true);
}


countAIdeath()
{
	self waittill("death");

	level.AIdead++;
}
calm_down()
{
	//while(level.AIdead < level.AIspawned)
	enemy = getaiarray("axis");
	
	while(enemy.size > 0)
	{
		wait(0.5);
		enemy = getaiarray("axis");
	}

	// AE 7/7/08: added this level notify for the music to go back to ambient, for Chuck
	level notify("playmusicpackage_ledge");
}
////////////////////////////////////////////////////////////////////////////////////
//                    Backlot Dialog                
////////////////////////////////////////////////////////////////////////////////////
StartSequence_dialog()
{
	// AE 7/1/08: added vo
	level.player play_dialogue("BMR1_SciAG_020A", true);
	wait(0.5);
	level.player play_dialogue("SCS1_SciAG_021A", true);
}

VanListener_dialog()
{
	// AE 7/1/08: added vo
	level.player play_dialogue("BMR2_SciAG_022A");
	wait(0.5);
	level.player play_dialogue("BMR3_SciAG_023A", true);
	
	level waittill("sending_additional");
	level.player play_dialogue("SCS1_SciAG_024A", true);
}

RoofListener_dialog()
{
	// AE 7/1/08: added vo
	level.player play_dialogue("SCS1_SciAG_025A", true);
	wait(0.5);
	level.player play_dialogue("BMR4_SciAG_026A", true);

}	
////////////////////////////////////////////////////////////////////////////////////
//			 BACKLOT FUNCTIONS FROM AI
////////////////////////////////////////////////////////////////////////////////////

//**************************************************************************
//**************************************************************************

SetupChallenge()
{
	//self SetupVehicle();

	level.VehicleExplosionCanKillPlayer = false;
	self thread NotifyWhenTrigger("backlot_trigger_cleanup", "backlot_clean_ai");	
	
	self thread WaitForMusic();

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

//**************************************************************************
//**************************************************************************

SetupVehicle()
{
	level.VehicleExplosionCanKillPlayer = false;

	vehicles = GetEntArray( "dest_v_sedan", "targetname" );	

	for( i = 0 ;  i < vehicles.size; i++ )
	{
		vehicles[i] thread maps\_vehicle::bond_veh_death();
		vehicles[i] thread maps\_vehicle::bond_veh_flat_tire();
	}

	van = GetEnt( "backlot_Van_Static", "script_noteworthy" );	

	van thread maps\_vehicle::bond_veh_death();
	van thread maps\_vehicle::bond_veh_flat_tire();

}

//**************************************************************************
//**************************************************************************

StartTriggerListener()
{
	self endon( "death" );
	
	self NotifyWhenTrigger("backlot_trigger_start", "backlot_start");	
}

//**************************************************************************
//**************************************************************************

StartSequence()
{	
	//----------------------------------------------------------------------
	
	self endon( "death" );
	
	//----------------------------------------------------------------------
	
	self waittill("backlot_start");

	//----------------------------------------------------------------------
	
	ai = self SpawnAi("backlot_StartDudes");

	//----------------------------------------------------------------------
	// AE 7/7/08: need to know how many spawn
	level.AIspawned += ai.size;

	for( i=0; i<ai.size; i++ )
	{
		if( IsDefined(ai[i]) )
		{
			//ai[i] AddEngageRule("TgtSight");

			ai[i] thread IgnorePlayerTimer(2);
			
			// AE 7/7/08: keep count of the deaths
			ai[i] thread countAIdeath();
		}
	}
	
	thread StartSequence_dialog();

	//----------------------------------------------------------------------
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");

	//----------------------------------------------------------------------
	
	self NotifyWhenXAlive(ai, 0, "backlot_start_vanteaser");

	//----------------------------------------------------------------------
}

//**************************************************************************
//**************************************************************************

VanTeaserTriggerListener()
{	
	self endon( "death" );
	
	self NotifyWhenTrigger("backlot_trigger_van_teaser", "backlot_start_vanteaser");
}


//**************************************************************************
//**************************************************************************

//------------------------------------------------------------	
// Send a tease to make sure the player 
// will look in the right direction
//------------------------------------------------------------
VanTeaserListener()
{	
	self endon( "death" );
	
	//------------------------------------------------------------	
	
	self waittill("backlot_start_vanteaser");
	
	//------------------------------------------------------------
	
	ai = self SpawnAi("backlot_vanTeaser", 0.1, 0.3 );

	//----------------------------------------------------------------------
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");
	
	//------------------------------------------------------------

	// AE 7/7/08: need to know how many spawn
	level.AIspawned += ai.size;
	
	for(i=0; i<ai.size ;i++)
	{
		self  thread NotifyOnDamage(     ai[i], "backlot_start_van", randomfloatrange(3.00, 4.00));
		self  thread NotifyOnSeePlayer(  ai[i], "backlot_start_van", randomfloatrange(3.00, 4.00));

		// AE 7/7/08: keep count of the deaths
		ai[i] thread countAIdeath();
	}

	self thread SetPerfectSenseOnNotify("backlot_start_van", ai); 

	if( ai.size > 1)
	{
		self thread TalkToEachOther( ai[0], ai[1] );		
	}

	//self NotifyWhenXAlive(ai, 0, "backlot_start_van");
	
	//------------------------------------------------------------
}

//**************************************************************************
//**************************************************************************

NotifyOnDamage(ai, msg, time)
{
	ai waittill("damage");

	if( IsDefined(time) )
	{
		wait(time);
	}
	
	self notify(msg);	
}

//**************************************************************************
//**************************************************************************

NotifyOnSeePlayer(ai, msg, time)
{
	ai endon("death");

	while( !( ai IsAThreat(level.player) && ai CanSeeThreat(level.player) ) )
	{
		wait(0.2);
	}

	if( IsDefined(time) )
	{
		wait(time);
	}
	
	self notify(msg);	
}

//**************************************************************************
//**************************************************************************

WaitForMusic()
{
	while( !IsStealthBroken() )
	{
		wait( 0.05 );
	}

	//Give it a little time 
	wait(1);
	
	//Start Backlot Music - Added by crussom
	//Moved by Michel
	level notify("playmusicpackage_backlot");
}

//**************************************************************************
//**************************************************************************

SetPerfectSenseOnNotify(msg, ai)
{
	self endon("death");

	self waittill(msg);

	for(i=0; i< ai.size; i++)
	{	
		if( IsDefined(ai[i]) )
		{
			//Perfect sense is necessary in case we trigger 
			// the van with the location trigger instead of combat
			ai[i] SetPerfectSense(1);
		}
	}
}


//**************************************************************************
//**************************************************************************

TalkToEachOther(ai1, ai2)
{
	ai1 endon("death");
	ai1 endon("damage");
	ai1 endon("alert_change");
	ai2 endon("death");
	ai2 endon("damage");
	ai2 endon("alert_change");

	ai1 stopallcmds();
	ai2 stopallcmds();

	//For blending purpose, always make sure we have the next cmd in the queue
	ai1 cmdaction("TalkA1");
	ai2 cmdaction("TalkA2");

	while( 1 )
	{		
		if( randomfloatrange(0.0, 1.0) < 0.5 )
		{
			ai1 cmdaction("TalkA1");
			ai2 cmdaction("TalkA2");
		}
		else
		{
			ai1 cmdaction("TalkA2");
			ai2 cmdaction("TalkA1");
		}

		ai1 waittill("cmd_done");



	}
}

//**************************************************************************
//**************************************************************************

VanTriggerListener()
{
	self endon( "death" );
	
	self NotifyWhenTrigger("backlot_trigger_van", "backlot_start_van");	
}

//**************************************************************************
//**************************************************************************
#using_animtree("vehicles");
VanListener()
{	
	self endon( "death" );
	
	//----------------------------------------------------------------------
	//Setup The Van coming in the middle of the fight
	//----------------------------------------------------------------------
	van			= GetEnt("backlot_Van", "targetname" );	
	van.health	= 1000000;


	vanStartNode  = GetVehicleNode("backlot_VanStartNode",	"targetname");
	
	van attachpath(vanStartNode);
	//----------------------------------------------------------------------
	
	self waittill("backlot_start_van");
	
	thread VanListener_dialog();

	//wait( randomfloatrange(0.0, 1.0) );
	
	//This loop is for debugging purpose
//	while(1)
	{					
		van attachpath(vanStartNode);
		van StartPath();

		van playsound("van_peel_out");

		van thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight"], "tag_light_l_front" );
		van thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight"], "tag_light_r_front" );
		van thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_l_back"  );
		van thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_r_back"  );
		
		van waittill( "reached_end_node" );
		

		newVan = GetEnt( "backlot_Van_Static", "script_noteworthy" );
		newVan.takedamage = false;
	
		newVan.origin = van.origin;
		newVan.angles = van.angles;

		//If I delete right away, it will create a pop (vehicle disappear, then new one show...)
		wait(0.10);

		van delete();	
	
//		wait(3); //This is use to reproduce the car comming at me
	}
	
	//----------------------------------------------------------------------
	
	//Simulate guys leaving the van	by waiting a little bit
	wait(0.1);

	// DCS: Pop open van doors.
	newVan UseAnimTree(#animtree);
	newVan animscripted("open_van_doors", newVan.origin, newVan.angles, %fxanim_van_doors);
	
	//----------------------------------------------------------------------
	
	ai = self SpawnAi("backlot_VanDudes", 0.1, 0.2);

	// AE 7/7/08: need to know how many spawn
	level.AIspawned += ai.size;
	
	//----------------------------------------------------------------------
			
	for( i=0; i<ai.size; i++ )
	{
		if( IsDefined(ai[i]) )
		{
			ai[i] AddEngageRule("TgtPerceive");
			
			// AE 7/7/08: keep count of the deaths
			ai[i] thread countAIdeath();			
		}
	}

	// to play the next dialof line.
	level notify("sending_additional");

	//----------------------------------------------------------------------
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");

	//Take all of the AI there is so far and when 
	self thread TrySaveWhenAllDeath(getaiarray ("axis"),"BackLotPostVan");
	
	//----------------------------------------------------------------------
	
	self NotifyWhenXAlive(ai, 0, "backlot_start_roofteaser", 5);
	
	//----------------------------------------------------------------------
	
}

//**************************************************************************
//**************************************************************************

RoofTeaserTriggerListener()
{	
	self endon( "death" );
	
	self NotifyWhenTrigger("backlot_trigger_roof_teaser", "backlot_start_roofteaser");
}


//**************************************************************************
//**************************************************************************

//------------------------------------------------------------	
// Send a tease to make sure the player 
// will look in the right direction
//------------------------------------------------------------
RoofTeaserListener()
{	
	self endon( "death" );
	
	//------------------------------------------------------------	
	
	self waittill("backlot_start_roofteaser");
	
	//------------------------------------------------------------
	
	ai = self SpawnAi("backlot_RoofTeaser", 0.0, 0.1 );
	
	// AE 7/7/08: need to know how many spawn
	level.AIspawned += ai.size;
	
	for(i=0;i<ai.size; i++)
	{
		ai[i] thread backlot_RoofTeaserThread();
		
		// AE 7/7/08: keep count of the deaths
		ai[i] thread countAIdeath();
	}

	//----------------------------------------------------------------------
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");
	
	//------------------------------------------------------------
	
	self NotifyWhenXAlive(ai, 0, "backlot_start_roof", 4);
	
	//------------------------------------------------------------

	//Start Stealth Music - Added by crussom
	level notify("mus_sca_stealth_lp");
}

//**************************************************************************
//**************************************************************************

backlot_RoofTeaserThread()
{		
	self setgoalnode (	getnode("RoofTeaserGoal1", "targetname"), 0);

	self waittill("goal");

	self setgoalnode (	getnode("RoofTeaserGoal2", "targetname"), 1);	
}

//**************************************************************************
//**************************************************************************

RoofTriggerListener()
{	
	self endon( "death" );
	
	self NotifyWhenTrigger("backlot_trigger_roof", "backlot_start_roof");
}


//**************************************************************************
//**************************************************************************

RoofListener()
{	
	//------------------------------------------------------------	

	self endon( "death" );
	
	//------------------------------------------------------------	
	
	self waittill("backlot_start_roof");
	
	thread RoofListener_dialog();

	//------------------------------------------------------------	
	//					Spawning

	ai1 = self SpawnAi( "backlot_RoofDudes1", 0.0, 0.0 );
	
	ai  = self SpawnAi( "backlot_RoofDudes",  1.0, 2.0 );

	ai	= MergeArray(ai, ai1);
	
	// AE 7/7/08: need to know how many spawn
	level.AIspawned += ai.size;
	for(i = 0; i < ai.size; i++)
	{
		// AE 7/7/08: keep count of the deaths
		ai[i] thread countAIdeath();
	}

	//----------------------------------------------------------------------
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");
	
	//------------------------------------------------------------
	
	//self NotifyWhenXAlive(ai, 0, "backlot_stairway_start_teaser");
	
	//------------------------------------------------------------
}

//**************************************************************************
//**************************************************************************

StairwayTeaserTriggerListener()
{	
	//------------------------------------------------------------	

	self endon( "death" );

	//------------------------------------------------------------	
	
	self NotifyWhenTrigger("backlot_trigger_stairway_teaser", "backlot_stairway_start_teaser");

	//------------------------------------------------------------	
}

//**************************************************************************
//**************************************************************************

StairwayTeaserListener()
{	
	//------------------------------------------------------------
	
	self endon( "death" );
	
	//------------------------------------------------------------
	
	self waittill("backlot_stairway_start_teaser");
	
	//------------------------------------------------------------
	
	ai = self SpawnAi("backlot_StairwayTeaser", 1.0, 2.0 );
	
	// AE 7/7/08: need to know how many spawn
	level.AIspawned += ai.size;

	for(i=0;i<ai.size; i++)
	{
		ai[i] thread backlot_StairwayTeaserThread();
		
		// AE 7/7/08: keep count of the deaths
		ai[i] thread countAIdeath();
		
	}

	// this should be the spot to start the calm_down thread
	level thread calm_down();

	//----------------------------------------------------------------------
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");
	
	//------------------------------------------------------------
}

//**************************************************************************
//**************************************************************************

backlot_StairwayTeaserThread()
{
	//We want to go to different spot and shoot... to let the player know we are coming
	
	self setgoalnode (	getnode("StairwayTeaserGoal1", "targetname"));
	self waittill("goal");
	
	//wait(2);	
	
	//self setgoalnode (	getnode("StairwayTeaserGoal2", "targetname"));
	//self waittill("goal");

	//wait(2.5);
	
	//self setgoalnode (	getnode("StairwayTeaserGoal3", "targetname") );
	//self waittill("goal");

	//wait(2.5);	
	//self setgoalnode (	getnode("StairwayTeaserGoal4", "targetname") );
	//self waittill("goal");
	//self SetCombatRole("Rusher");
}

//**************************************************************************
//**************************************************************************

StairwayTriggerListener()
{		
	//------------------------------------------------------------
	
	self endon( "death" );
	
	//------------------------------------------------------------
	
	self NotifyWhenTrigger("backlot_trigger_stairway", "backlot_stairway_start");
	
	//------------------------------------------------------------
}

//**************************************************************************
//**************************************************************************

StairwayListener()
{	
	//------------------------------------------------------------
	
	self endon( "death" );
	
	//------------------------------------------------------------
	
	self waittill("backlot_stairway_start");
	
	//------------------------------------------------------------
	
	ai = self SpawnRandomAi("backlot_StairwayDudes");
	
	//----------------------------------------------------------------------
	ledge_stairway_door = getent("ledge_stairway_door", "targetname");
	ledge_stairway_door rotateYaw(110,0.5);
	ledge_stairway_door ConnectPaths();
	
	//----------------------------------------------------------------------
	
	self thread CleanupAiListener(ai, "backlot_clean_ai");
	
	//------------------------------------------------------------
	
	self NotifyWhenXAlive(ai, 0, "backlot_done");
	
	//------------------------------------------------------------
}

//**************************************************************************
//**************************************************************************

IgnorePlayerTimer(time)
{	
	self endon( "death" );

	self SetIgnoreThreat(level.player, true);
	
	wait(time);

	self SetIgnoreThreat(level.player, false);
}

//**************************************************************************
//**************************************************************************

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

//**************************************************************************
//**************************************************************************

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

			//We  want to make sure AI doesnt blow themself with Car and Also, it is more fun if the player do it
			//So reduce the damage they do and avoid them creating explosion
			ai[i].destructibledamagescale = 0.35;
			ai[i].candestroydestructible  = false;	
		}
	}
	
	return ai;

}

//**************************************************************************
//**************************************************************************

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

//**************************************************************************
//**************************************************************************

TrySaveWhenAllDeath(aiArray, saveName)
{
	self endon( "death" );

	self thread NotifyWhenXAlive( aiArray, 0, saveName );

	//When this round is all killed
	self waittill(saveName);
		
	//Try to autosave... dont do it for too long because 
	// we try to avoid saving in a bad spot... so if within the timeout we cant,
	// it is probably that the player is rushing is way through and we should not save
	maps\_autosave::autosave_by_name( saveName, 30 );

}

//**************************************************************************
//**************************************************************************

CleanupAiListener( aiArray, msg )
{	
	self endon( "death" );

	self waittill(msg);
	
	// more than 5 ai alive when reach roof.
	if( level.AIspawned - level.AIdead > 5 )
	{
		//iprintlnbold("shoot bond up!");
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
		level notify("playmusicpackage_ledge");
	}
	
	// waittill on way to roof, clean the rest up.
	level waittill ( "roof_access" );
	
	for( i=0; i<aiArray.size; i++ )
	{	
		if( IsDefined(aiArray[i]) )
		{
			aiArray[i] delete();
		}
	}
}

//**************************************************************************
//**************************************************************************

NotifyWhenTrigger( trigger_name, msg )
{	
	self endon( "death" );
	
	trigger = GetEnt(trigger_name,"targetname");
	
	if( isdefined(trigger) )
	{
		trigger waittill("trigger");
		
		//iprintlnbold( trigger_name );
		
		self notify(msg);	
	}	
	else
	{
		//iprintlnbold( "CANT FIND" + trigger_name );
	}
}

//**************************************************************************
//**************************************************************************

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
		
		//iprintlnbold( msg + ": numAlive=" + numAlive + " < " + x );
	}
	
	if( IsDefined(timer) )
	{
		wait(timer);
	}

	//Start second wave
	self notify(msg);	
}

//**************************************************************************
//**************************************************************************