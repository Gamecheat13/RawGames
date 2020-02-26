#include maps\_utility;
#using_animtree("generic_human");


spawn_enemy(spawner)
{
	new_enemy = spawner stalingradspawn();
	spawn_failed(new_enemy);

	console_print(spawner.targetname + " has spawned.");

	if( getdvar( "relaxed" ) == "1")
	{
		new_enemy LockAlertState("alert_green");
	}


	return new_enemy;
}


spawn_civilian(spawner)
{
	new_civ = spawner dospawn();
	spawn_failed(new_civ);

	console_print(spawner.targetname + " has spawned");
	new_civ SetMachine( "Brain", "BrainAiSoldierBasic" );
	new_civ animscripts\shared::placeWeaponOn( new_civ.weapon, "none" );
	new_civ SetEnableSense(false);
	new_civ setoverridespeed(15);
	new_civ thread civ_death();

	return new_civ;
}

setup_civilian_animation(civilian)
{

	switch(civilian.script_noteworthy)
	{
	case "talking":
		switch(level.counter % 2)
		{
		case 0:
			while(1)
			{
				physicsExplosionSphere( civilian.origin + (10, 0, 30), 40, 10, 0.5 );

				node = getnode("node_cheer_2", "targetname");
				civilian setgoalnode(node);
				return;
			}
			break;
		case 1:
			while(1)
			{
				civilian CmdPlayAnim( "Gen_Civs_CheerV2", false );
				civilian waittill("cmd_done");	
				level.counter++;
				if(level.flee)
					break;
			}		        
			break;  
		}
		break;

	case "talking_2":
		switch(level.counter % 2)
		{
		case 0:
			while(1)
			{
				physicsExplosionSphere( civilian.origin + (10, 0, 30), 40, 10, 0.5 );

				node = getnode("node_cheer_2", "targetname");
				civilian setgoalnode(node);
				return;
			}
			break;
		case 1:
			while(1)
			{
				civilian CmdPlayAnim( "Gen_Civs_ExcitedConvoV1", false );
				civilian waittill("cmd_done");	
				level.counter++;
				if(level.flee)
					break;
			}		        
			break;  
		}
		break;

	case "cheering":
		switch(level.counter % 2)
		{
		case 0:
			while(1)
			{
				wait(3.5);
				node = getnode("node_cheer_3", "targetname");
				civilian setgoalnode(node);
				return;
			}
			break;
		case 1:
			while(1)
			{
				wait(3);
				node = getnode("node_cheer_3", "targetname");
				civilian setgoalnode(node);
				return;
			}
			break;
		}

	case "cheering_2":
		switch(level.counter % 2)
		{
		case 0:
			while(1)
			{
				wait(5);
				physicsExplosionSphere( civilian.origin + (10, 0, 30), 40, 10, 0.5 );
				node = getnode("node_cheer_3", "targetname");
				civilian setgoalnode(node);
				return;
			}
			break;
		case 1:
			while(1)
			{
				wait(5);
				physicsExplosionSphere( civilian.origin + (10, 0, 30), 40, 10, 0.5 );
				node = getnode("node_cheer_3", "targetname");
				civilian setgoalnode(node);
				return;
			}
			break;
		}
		break;
	}
}

flood_spawn_civ(spawn_name, target_node_array, bStopSpawn)
{
	civilian_spawners = [];
	civilian_spawners = GetEntarray(spawn_name,"targetname");
	civilians = [];
	level.counter = 0;
	for(i = 0; i < civilian_spawners.size; i++)
	{
		civilians[i] = civilian_spawners[i] stalingradspawn();
		civilians[i] SetEnableSense(0);
		civilians[i] LockAlertState("alert_red");
		civilians[i] setscriptspeed("sprint");
		civilians[i] setoverridespeed(25);
		civilians[i] setignorethreat( level.player, true);
		civilians[i] animscripts\shared::placeWeaponOn( civilians[i].weapon, "none" );
		level thread setup_civilian_animation(civilians[i]);
	}

	level.flee = true;
}

chase_status()
{
	level.player setsecuritycameraparams( 55, 3/4 );
	wait(0.01);
	
	SetDVar("r_pipSecondaryX", -0.20);
	SetDVar("r_pipSecondaryY", 0.13);						
	SetDVar("r_pipSecondaryAnchor", 0);						
	SetDVar("r_pipSecondaryScale", "0.4 0.4 1.0 1.0");		
	SetDVar("r_pipSecondaryAspect", false);					
	SetDVar("r_pipSecondaryMode", 0);						
	setdvar("cg_pipsecondary_border", 2);
	setdvar("cg_pipsecondary_border_color", "0.0 0.0 0.0 1");
}



create_civilian_group(civilian_spawner_name, delete_trigger_name, spawn_trigger_name)
{
	
	if(!isDefined(spawn_trigger_name))
	{
		spawn_trigger_name = "notrigger";
	}

	
	if(spawn_trigger_name != "notrigger")
	{
		spawn_trigger = GetEnt(spawn_trigger_name,"targetname");
		spawn_trigger waittill("trigger");
	}

	
	civilian_spawners = GetEntArray(civilian_spawner_name,"targetname");
	civilians = [];
	
	for(i = 0; i < civilian_spawners.size; i++)
	{
		civilians[i] = spawn_civilian(civilian_spawners[i]);
		civilians[i] SetEnableSense(0);
		civilians[i] LockAlertState("alert_red");
		civilians[i] setoverridespeed(20);
		civilians[i] setignorethreat( level.player, true);
	}

	
	delete_trigger = GetEnt(delete_trigger_name,"targetname");
	delete_trigger waittill("trigger");

	
	for(i = 0; i < civilians.size; i++)
	{
		if(isalive(civilians[i]) )
		{
			civilians[i] delete();
		}
	}
}

bomber_pause()
{
	level.bomber maps\_chase::pause_chase_route();
}

bomber_resume()
{
	level.bomber maps\_chase::resume_chase_route();
}

bomber_start(targetname)
{
	temp_node = GetNode(targetname,"targetname");
	level.bomber maps\_chase::start_chase_route(temp_node);
}

slow_time()
{
	SetSavedDVar( "timescale", .25);
}

norm_time()
{
	SetSavedDVar( "timescale", 1);
}


console_print(string)
{
	if( getdvar( "consoleprint" ) == "1")
	{
		iprintln(string);
	}
}


clear_civilians(targetname)
{
	todelete = GetEntarray(targetname,"targetname");
	for(i = 0; i < todelete.size; i++)
	{
		if(isalive(todelete[i]) )
		{
			todelete[i] delete();
		}
	}
}


propane_destruct()
{
	triggers = getentarray( "propane_destruct", "targetname" );

	for( i=0; i < triggers.size; i++ )
	{
		triggers[i] thread propane_destruct_think();
	}
}

propane_destruct_think()
{
	self waittill( "trigger" );
	tank = GetEnt(self.target,"targetname");
	self delete();
	tank propane_destruct_effect();
	tank delete();
}

propane_destruct_effect()
{
	
	radiusDamage( self.origin + ( 0,0,32), 224, 500, 250 );	
	physicsExplosionSphere( self.origin, 192, 64, 2 );

	self notsolid();
	self hide();
}

flash_drive_find(awareness_object)
{
	level.information++;
	iPrintLnBold(level.information+" of 3 found");
}

civilian_friendlyfire()
{
	self setcandamage( true );
	for (;;)
	{
		self waittill ( "damage", damage, attacker );
		if (attacker == level.player)
			break;
	}

	
	
	level.player playsound( "dia_mission_fail_civ" );
	wait(1);
	level.chase_timer = 0;
	setdvar("ui_deadquote", "@SHANTYTOWN_MISSIONFAIL_CIVILIAN_KILLED");
	
	missionfailed();
}

player_death_vo()  
{  
	self waittill( "death" );  
	level.chase_timer = 0;
	level.player playlocalsound( "dia_mission_fail" );  
}  

mission_fail_vo()  
{  
	level.chase_timer = 0;
	level.player playlocalsound( "dia_mission_fail" );  
	MissionFailed();  
}  

civ_collateral_vo( sValue, sKey )  
{  
	if( !IsDefined( sValue ) )  
	{  
		return;  
	}  

	if( !IsDefined( sKey ) )  
	{  
		sKey = "targetname";  
	}  

	entaCiv = GetEntArray( sValue, sKey );  

	for( i = 0; i < entaCiv.size; i++ )  
	{  
		entaCiv[i] thread civ_death();  
	}  
}  

civ_death()  
{  
	self waittill ( "damage", damage, attacker );
	if (attacker == level.player)
	{
		
		level.chase_timer = 0;
		level.player playlocalsound( "dia_mission_fail_civ" );  
		MissionFailed(); 
	}
}

slow_time_new(val, tim, out_tim)
{
	self endon("stop_timescale");

	thread check_for_death();
	SetSavedDVar( "timescale", val);

	wait(tim - out_tim);

	change = (1-val) / (out_tim*30);
	while(val < 1)
	{
		val += change;
		SetSavedDVar( "timescale", val);
		wait(0.05);
	}

	SetSavedDVar("timescale", 1);

	level notify("timescale_stopped");
}

check_for_death()
{
	self endon("timescale_stopped");

	while(level.player.health > 0)
	{
		wait(.05);
	}

	level notify("stop_timescale");
	SetSavedDVar( "timescale", 1);
}