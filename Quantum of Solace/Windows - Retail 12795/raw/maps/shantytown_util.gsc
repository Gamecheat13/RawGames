#include maps\_utility;

#using_animtree("generic_human");

/*
Name: spawn_enemy							  
Author: Kevin Drew							  
Purpose: A wrapper function for the new ai to spawn an enemy from a spawn 
point and set default parameters that can be easily changed here. 
Parameters:								  
spawner - a spawnpoint	  
*/
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

/*
Name: spawn_civilian							  
Author: Kevin Drew							  
Purpose: A wrapper function for the new ai to spawn a civilian from a spawn 
point and set default parameters that can be easily changed here. 
Parameters:								  
spawner - a spawnpoint	  
*/
spawn_civilian(spawner)
{
	new_civ = spawner dospawn();
	spawn_failed(new_civ);

	console_print(spawner.targetname + " has spawned");
	new_civ SetMachine( "Brain", "BrainAiSoldierBasic" );
	new_civ animscripts\shared::placeWeaponOn( new_civ.weapon, "none" );
	new_civ SetEnableSense(false);
	//new_civ LockAlertState("alert_yellow");
	new_civ setoverridespeed(15);
	//new_civ thread civilian_friendlyfire();
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

				//civilian CmdPlayAnim( "Gen_Civs_CheerV2", false );
				////print3d (self.origin + (0,0,70), "Stand Talking", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale
				//wait(0.5);
				//civilian stopcmd();
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
				//print3d (self.origin + (0,0,70), "Stand Talking", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale
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

				//civilian CmdPlayAnim( "Gen_Civs_SitReading_A", false );
				////print3d (self.origin + (0,0,70), "Stand Talking", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale
				//wait(0.5);
				//civilian stopcmd();
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
				//print3d (self.origin + (0,0,70), "Stand Talking", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale
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
				//civilian CmdPlayAnim( "Gen_Civs_CheerV1", false );
				////print3d (self.origin + (0,0,70), "Stand Casual", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale		
				wait(3.5);
				//civilian stopcmd();
				node = getnode("node_cheer_3", "targetname");
				civilian setgoalnode(node);
				return;
			}
			break;
		case 1:
			while(1)
			{
				//civilian CmdPlayAnim( "Gen_Civs_CheerV2", false );
				////print3d (self.origin + (0,0,70), "Stand Casual", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale		
				wait(3);
				//civilian stopcmd();
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
				//civilian CmdPlayAnim( "Gen_Civs_SitReading_A", false );
				////print3d (self.origin + (0,0,70), "Stand Casual", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale		
				wait(5);
				//civilian stopcmd();
				physicsExplosionSphere( civilian.origin + (10, 0, 30), 40, 10, 0.5 );
				node = getnode("node_cheer_3", "targetname");
				civilian setgoalnode(node);
				return;
			}
			break;
		case 1:
			while(1)
			{
			//	civilian CmdPlayAnim( "Gen_Civs_SitReading_A", false );
			//	//print3d (self.origin + (0,0,70), "Stand Casual", (1,0,0), 1, .25, 35);	// origin, text, RGB, alpha, scale		
			wait(5);
			//	civilian stopcmd();
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
	
	if(level.ps3 || level.bx ) //GEBE
		pool_side = civilian_spawners.size - 5;
	else
		pool_side = civilian_spawners.size;

	//iprintlnbold(pool_side);

	for(i = 0; i < pool_side; i++)
	{
		civilians[i] = civilian_spawners[i] stalingradspawn();
		civilians[i] SetEnableSense(0);
		civilians[i] LockAlertState("alert_red");
		civilians[i] setscriptspeed("sprint");
		civilians[i] setoverridespeed(25);
		civilians[i] setignorethreat( level.player, true);
		civilians[i] animscripts\shared::placeWeaponOn( civilians[i].weapon, "none" );
		level thread setup_civilian_animation(civilians[i]);
		//wait(0.02);
	}

	//wait();
	level.flee = true;


}

//civilians = civilian_spawners dospawn();
//spawn_failed(civilians);
//civilians SetEnableSense(0);
//civilians LockAlertState("alert_red");
//civilians setoverridespeed(20);
//civilians setignorethreat( level.player, true);
//i = randomint(nodes.size);
//cililians setgoalnode(nodes[i]);
//
//timer = 0;
//duration = 0;
//civilians = undefined;
//	while(!bStopSpawn)
//	{
//		if(!isdefined(civilians))
//		{
//			civilians = civilian_spawners stalingradspawn();
//			if(!isdefined(civilians))
//			{
//				wait(0.5);
//				continue;
//			}

//			civilians SetEnableSense(0);
//			civilians LockAlertState("alert_red");
//			civilians setscriptspeed("sprint");
//			civilians setoverridespeed(20);
//			civilians setignorethreat( level.player, true);
//			civilians animscripts\shared::placeWeaponOn( civilians.weapon, "none" );
//		/*	i = randomint(nodes.size);
//			duration = randomintrange(6000, 10000);
//			civilians setgoalnode(nodes[i]);*/
//		}
//		timer += 500;

//		if(timer > duration)
//		{
//			while(civilians CanSee(level.player))
//			{
//				wait(0.5);
//			}
//			civilians delete();
//			timer = 0;
//		}

//	
//			

//		wait(0.5);

//	}





chase_status()
{
	level.player setsecuritycameraparams( 55, 3/4 );
	wait(0.01);
	//setup security camera on phone.
	SetDVar("r_pipSecondaryX", -0.20);
	SetDVar("r_pipSecondaryY", 0.13);						// place top left corner of display safe zone
	SetDVar("r_pipSecondaryAnchor", 0);						// use top left anchor point
	SetDVar("r_pipSecondaryScale", "0.4 0.4 1.0 1.0");		// scale image, without cropping
	SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio
	SetDVar("r_pipSecondaryMode", 0);						// enable video camera display with highest priority 
	setdvar("cg_pipsecondary_border", 2);
	setdvar("cg_pipsecondary_border_color", "0.0 0.0 0.0 1");



	//iprintlnbold("pip set up");
}


/*
Name: create_civilian_group
Author: Kevin Drew
Purpose: Grabs a group of civilian spawners and handles their spawning, goals, and
deletion.
Parameters:
civilian_spawner_name 	- name of the civlian spawners to create an array with
delete_trigger_name 	- name of the trigger that deletes that group of civilians
spawn_trigger_name 	- name of the trigger that spawns the group, if not specified
the group will spawn on function call
*/
create_civilian_group(civilian_spawner_name, delete_trigger_name, spawn_trigger_name)
{
	//checks to see if spawn_trigger_name is defined
	if(!isDefined(spawn_trigger_name))
	{
		spawn_trigger_name = "notrigger";
	}

	//if the spawn_trigger_name is defined, waits until it is triggered
	if(spawn_trigger_name != "notrigger")
	{
		spawn_trigger = GetEnt(spawn_trigger_name,"targetname");
		spawn_trigger waittill("trigger");
		//spawn_trigger delete();
	}

	//grabe the group of civilians to spawn
	civilian_spawners = GetEntArray(civilian_spawner_name,"targetname");
	civilians = [];
	//spawns the civilians and makes them go to their goal nodes or cower
	for(i = 0; i < civilian_spawners.size; i++)
	{
		civilians[i] = spawn_civilian(civilian_spawners[i]);
		civilians[i] SetEnableSense(0);
		civilians[i] LockAlertState("alert_red");
		civilians[i] setoverridespeed(20);
		civilians[i] setignorethreat( level.player, true);
		//if(civilian_spawners[i].script_noteworthy == "cower"  || !isDefined(civilian_spawners[i].script_noteworthy) )
		//{
		//	//cower
		//}
		//else
		//{
		//	iprintlnbold("not moving");
		//	goal_node = GetNode(civilian_spawners[i].script_noteworthy,"targetname");
		//	civilians[i] cmdplayanim( "Civs_Shanty_PanicRun" );          
		//	civilians[i] SetGoalNode(goal_node);
		//}
	}

	//wait until the delete trigger is hit
	delete_trigger = GetEnt(delete_trigger_name,"targetname");
	delete_trigger waittill("trigger");
	//delete_trigger delete();

	//delete all of the spawned civilians in the group
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

/*
Name: console_print					  	  	  
Author: Kevin Drew							  
Purpose: Looks to see if the dvar consoleprint is on and prints out debug 
text.		  						  
Parameters:								  
string - the string to print to the console	  		  
*/
console_print(string)
{
	if( getdvar( "consoleprint" ) == "1")
	{
		iprintln(string);
	}
}

/*
Name: clear_enemies					  	  	  
Author: Kevin Drew							  
Purpose: Gathers all ai catergorized as "axis" into one array and removes 
them from the level if they are alive.		  		  
Parameters:								  
none	  							  
*/
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

//make propane explode 
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
	//radiusdamage(<origin>, <range>, <max damage>, <min damage>)
	radiusDamage( self.origin + ( 0,0,32), 224, 500, 250 );	//have to add 16 units so it actually off the ground and kills dude

	//physicsExplosionSphere( <position of explosion>, <outer radius>, <inner radius>, <magnitude> )
	//physicsExplosionSphere( self.origin, 192, 64, 2 );

	//playfx( level._effect["propane_tank_explode"],self.origin);
	//self playsound ( "expl_gas_pipe_burst" );
	//radiusDamage( self.origin + ( 0,0,32), 224, 500, 250 );
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

	//iprintlnbold( "civ can die!!!" );
	self setcandamage( true );
	for (;;)
	{
		self waittill ( "damage", damage, attacker );
		if (attacker == level.player)
			break;
	}

	//thread maps\_friendlyfire::missionfail();
	//test missionfail dialog
	level.player playsound( "dia_mission_fail_civ" );
	wait(1);

	setdvar("ui_deadquote", "@SHANTYTOWN_MISSIONFAIL_CIVILIAN_KILLED");
	missionfailedwrapper();

}

player_death_vo()  
{  
	self waittill( "death" );  
	level.player playlocalsound( "dia_mission_fail" );  
}  

mission_fail_vo()  
{  
	level.player playlocalsound( "dia_mission_fail" );  
	missionfailedwrapper(); 
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
		level.player playlocalsound( "dia_mission_fail_civ" );  
		missionfailedwrapper();
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
