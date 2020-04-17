/*
*****************************	
*****************************	

VEHICLE script

This handles playing the various effects and animations on a vehicle.  
It handles initializing a vehicle (giving it life, turrets,machine guns, treads and things)

It also handles spawning of vehicles in a very ugly way for now, we're getting code to make it pretty

Most things you see in the vehicle menu in Radiant are handled here.  There's all sorts of properties 
that you can set on a trigger to access some of this functionality.  A trigger can spawn a vehicle,
toggle different behaviors,


HIGH LEVEL FUNCTIONS

vehicle_init (vehicle) 
	this give the vehicle life,treads,turrets,machine guns, all that good stuff

main() 
	this is setup, sets up spawners, trigger associations etc is ran on first frame by _load

trigger_process (trigger,vehicles) 
	since triggers are multifunction I made them all happen in the same thread so that
	the sequencing would be easy to handle
	
vehicle_paths()
	This makes the nodes get notified trigger when they are hit by a vehicle, we hope 
	to move this functionality to CODE side because we have to use a lot of wrappers for 
	attaching a vehicle to a path
	
*****************************	
*****************************	
*/
#include maps\_utility;
#include common_scripts\utility;
#using_animtree ("generic_human");

init_vehicles ()
{
	//vehicle related dvar initializing goes here
	setup_dvars();

	//initialize all the level wide vehicle system variables
	setup_levelvars();

	// put all the vehicles with targetnames into an array so we can spawn vehicles from
	// a string instead of their vehicle group #
	setup_targetname_spawners();
		
	//drives vehicle through level
	//helpful on levels where vehicles don't always make it through the whole path
	vclogin_vehicles();
	
	//pre-associate origins for tanks to shoot at and dynamic helicopters.
	origin_triggers = setup_origins();
	
	//pre-associate ai and spawners with their vehicles
	setup_ai();	

	//pre-associate vehicle triggers and vehicle nodes with stuff.
	processtriggers = array_combine(setup_triggers(),origin_triggers);
	
	//check precacheing of vehicle scripts.
	allvehiclesprespawn = precache_scripts();
	
	
	//setup spawners and non-spawning vehicles
	setup_vehicles();

	//send the setup triggers to be processed
	array_levelthread (processtriggers, ::trigger_process, allvehiclesprespawn);
	
	if ( getdvar( "debug_tankcrush") == "" )
		setdvar( "debug_tankcrush", "0" );
}

setup_attackorg_chain ( origin )
{
	targ = origin;
	while(isdefined(targ))
	{
		if(isdefined(targ.targetname))
		{
			targeters = getentarray(targ.targetname,"target");
			for(i=0;i<targeters.size;i++)
				if(targeters[i].classname == "trigger_radius" || targeters[i].classname == "trigger_multiple")
					targ.triggertarget = targeters[i];
		}
		
		if(isdefined(targ.target))
			targ = getent(targ.target,"targetname");
		else
			targ = undefined;
	}	
}

delete_group ( vehicle, group )
{
	if(isdefined(vehicle.walkers))
		for(j=0;j<vehicle.walkers.size;j++)
			if(issentient(vehicle.walkers[j]))
				vehicle.walkers[j] delete();
	if(isdefined(vehicle.riders))
		for(j=0;j<vehicle.riders.size;j++)
			if(issentient(vehicle.riders[j]))
				vehicle.riders[j] delete();
	if(isdefined(vehicle))
		vehicle delete();
}

trigger_getlinkmap( trigger )
{
	linkMap = [];
	if ( isdefined( trigger.script_linkTo ) )
	{
		links = strtok( trigger.script_linkTo, " " );
		for ( i = 0; i < links.size; i++ )
			linkMap[links[i]] = true;
		links = undefined;
	}
	return linkMap;
	
}

/*
Uber trigger handling.  I do this so I can process more than one 
function on a trigger and maintain sequence (don't have 5 threads 
running on a trigger) it also helps that I only have to get the 
linkmap and waittill trigger in one place
*/

trigger_process ( trigger, vehicles )
{
	// these triggers only trigger once where vehicle paths trigger everytime a vehicle crosses them
	if(isdefined(trigger.classname) && (trigger.classname == "trigger_multiple" || trigger.classname == "trigger_radius" || trigger.classname == "trigger_lookat"))
			bTriggeronce = true;
	else
		bTriggeronce = false;
	
	//override to make a trigger loop
	if(isdefined(trigger.script_noteworthy) && trigger.script_noteworthy == "trigger_multiple")
		bTriggeronce = false;
		
	linkMap = [];
	linkvehicles = [];
	vehiclenames = [];
	gates = [];
	groupvehicles = [];
	targetedvehicle = undefined;
	
	//get map of links
	linkMap = trigger_getlinkmap(trigger);

	if ( isdefined( trigger.script_gatetrigger ) )
	{
		gates = getlinks_array( level.vehicle_linkedpaths, linkMap );
		script_gatetrigger = level.vehicle_gatetrigger[trigger.script_gatetrigger];
		if ( isdefined( script_gatetrigger ) )
			gates = array_merge_links( gates, script_gatetrigger );
	}
	
	//preprocesses linked vehicles for spawningg
	script_vehiclespawngroup =false;
	if(isdefined(trigger.script_vehiclespawngroup))
	{
		script_vehiclespawngroup =true;
		if(bTriggeronce)
			if(isdefined(trigger.target))
			{
 				target = getent(trigger.target,"targetname");
  				if (isdefined (target) && target.classname == "script_vehicle")
  				{
  					targetedvehicle = target.targetname;
  					thread spawner_setup(target,target.targetname,"trigger target");
  				}
			}

		if(linkMap.size > 0)
		{
			linkvehicles = getlinks_array(vehicles,linkMap);
			if(linkvehicles.size > 0)
				thread spawner_setup(linkvehicles,linkvehicles[0].script_linkname,"trigger link");
		}
	}
	
	if(isdefined(trigger.script_VehicleAttackgroup) && !isdefined(level.vehicle_AttackGroup[trigger.script_VehicleAttackgroup]))
		level.vehicle_AttackGroup[trigger.script_VehicleAttackgroup] = [];
	if(isdefined(trigger.script_vehiclefocusfiregroup) && !isdefined(level.vehicle_FocusFireGroup[trigger.script_vehiclefocusfiregroup]))
		level.vehicle_FocusFireGroup[trigger.script_vehiclefocusfiregroup] = [];
	if(isdefined(trigger.script_vehicledeathgate) && !isdefined(level.vehicle_DeathGate[trigger.script_vehicledeathgate]))
		level.vehicle_DeathGate[trigger.script_vehicledeathgate] = [];
	
	// do all the isdefined checks on the first frame changing them to simple boolean values to be checked. 
	// (maybe a bit memory intensive, I don't know)
	
	script_vehicleaianim =					isdefined(trigger.script_vehicleaianim);
	script_turret = 						isdefined(trigger.script_turret);
	script_delay = 						isdefined(trigger.script_delay);
	script_linkto = 						isdefined(trigger.script_4);
	script_VehicleAttackgroup = 				isdefined(trigger.script_VehicleAttackgroup);
	script_VehicleStartMove = 				isdefined(trigger.script_VehicleStartMove);
	script_vehicleGroupDelete = 				isdefined(trigger.script_vehicleGroupDelete);
	script_vehiclefocusfiregroup = 			isdefined(trigger.script_vehiclefocusfiregroup);
	script_attackorgs = 					isdefined(trigger.script_attackorgs);
	script_crashtypeoverride = 				isdefined(trigger.script_crashtypeoverride);
	script_badplace = 						isdefined(trigger.script_badplace);
	script_attackspeed = 					isdefined(trigger.script_attackspeed);
	script_turretmg = 						isdefined(trigger.script_turretmg);
	script_noteworthy = 					isdefined(trigger.script_noteworthy);
	script_shots = 						isdefined(trigger.script_shots);
	script_accuracy = 						isdefined(trigger.script_accuracy);
	script_deathroll =						isdefined(trigger.script_deathroll);
	script_vehiclesquadleader = 				isdefined(trigger.script_vehiclesquadleader);
	script_attackai = 						isdefined(trigger.script_attackai);
	script_vehicledeathgate =				isdefined(trigger.script_vehicledeathgate);
	script_avoidvehicles = 					isdefined(trigger.script_avoidvehicles);
	script_vehicledisabletrigger = 			isdefined(trigger.script_vehicledisabletrigger);
	script_turningdir = 					isdefined(trigger.script_turningdir);
	script_exploder = 					isdefined(trigger.script_exploder);
	script_vehicledetour =			(isdefined(trigger.script_vehicledetour) && isdefined(trigger.classname) && trigger.classname == "script_origin");
	script_unload = 					isdefined(trigger.script_unload);
	
	
	detoured = 							isdefined(trigger.detoured);
	
	gotrigger = true;

	if(script_vehicledisabletrigger)
		level endon ("disabletriggers"+trigger.script_vehicledisabletrigger);

	vehicles = undefined;
	
	
	while(gotrigger)
	{
		trigger waittill ("trigger",other);
		if(isdefined(trigger.enabled) && !trigger.enabled)
			trigger waittill ("enable");
		if(script_exploder)
			exploder(trigger.script_exploder);
		triggererisdefined = isdefined(other);
		if(script_unload)
			other thread unload_node(trigger);
		if(detoured && triggererisdefined)
			other thread path_detour(trigger);

		if(script_delay)
			wait trigger.script_delay;
		if(script_vehicledisabletrigger && script_noteworthy && trigger.script_noteworthy == "trigger")
			level notify ("disabletriggers"+trigger.script_vehicledisabletrigger);
		targs = [];
		if(bTriggeronce)
		{
			if(isdefined(trigger.target) && isdefined(level.vehicle_target[trigger.target]))
				targs = level.vehicle_target[trigger.target];
			gotrigger = false;
		}
		if(script_vehicleGroupDelete)
		{
			if(!isdefined(level.vehicle_DeleteGroup[trigger.script_vehicleGroupDelete]))
			{
				println("failed to find deleteable vehicle with script_vehicleGroupDelete group number: ",trigger.script_vehicleGroupDelete);
				level.vehicle_DeleteGroup[trigger.script_vehicleGroupDelete] = [];
			}
			array_levelthread(array_merge(level.vehicle_DeleteGroup[trigger.script_vehicleGroupDelete],targs), ::delete_group, trigger.script_vehicleGroupDelete);  //was _links
		}
		
		if(script_vehiclespawngroup)
		{
			if(isdefined(linkvehicles) && linkvehicles.size > 0)
				level notify ("spawnvehiclegroup"+linkvehicles[0].script_linkname);
			level notify ("spawnvehiclegroup"+trigger.script_vehiclespawngroup);
			if(isdefined(targetedvehicle))
				level notify ("spawnvehiclegroup"+targetedvehicle);
			waittillframeend;
//			level waittill ("vehiclegroup spawned"+targetedvehicle);
		}


		linkvehicles = [];
		if(script_linkto)
			linkvehicles = getlinks_array(getentarray("script_vehicle","classname"),linkMap);

		targs = array_merge_links(targs,linkvehicles);
		if(gates.size > 0)
			array_levelthread(gates,::path_gate_open);
		if(script_VehicleStartMove)
		{
			if(!isdefined(level.vehicle_StartMoveGroup[trigger.script_VehicleStartMove]) && !targs.size)
			{
				assertmsg("script_VehicleStartMove trigger hit with nothing to move");
				return;
			}
			array_levelthread(array_merge(level.vehicle_StartMoveGroup[trigger.script_VehicleStartMove],targs), ::gopath);  // was _links
			
		}
		if(!(triggererisdefined))
			continue;
		if(script_vehiclefocusfiregroup && triggererisdefined)
		{
			if(other == level.player && level.playervehicle.classname == "script_vehicle")
				array_levelthread(array_merge(level.vehicle_FocusFireGroup[trigger.script_vehiclefocusfiregroup],targs), ::focusfire,level.playervehicle); //was _links
			else
				array_levelthread(array_merge(level.vehicle_FocusFireGroup[trigger.script_vehiclefocusfiregroup],targs), ::focusfire,other); //was _links
		}
		if(script_avoidvehicles)
			other.script_avoidvehicles = trigger.script_avoidvehicles;
		if(script_turret)
			other.script_turret = trigger.script_turret;
		if(script_attackorgs)
			other thread turret_queorgs(trigger.script_attackorgs);
		if(script_VehicleAttackgroup)
		{
			if(trigger.script_VehicleAttackgroup == -1)
				other notify ("attack",array_merge_links(level.vehicle_AttackGroup[trigger.script_VehicleAttackgroup],targs),"attack_all");
			else
				other notify ("attack",array_merge_links(level.vehicle_AttackGroup[trigger.script_VehicleAttackgroup],targs));
			//make ai attack too
			other notify ("groupedanimevent","attack");
		}
		if(script_vehiclesquadleader)
			other thread squad_leader(trigger);		
		if(script_crashtypeoverride)
			other.script_crashtypeoverride = trigger.script_crashtypeoverride;
		if(script_badplace)
			other.script_badplace = trigger.script_badplace;
		if(script_attackspeed)
			other.attackspeed = trigger.script_attackspeed;
		if(script_turretmg)
			other.script_turretmg = trigger.script_turretmg;
		if(script_noteworthy)
		{
			if(trigger.script_noteworthy == "forcekill")
				other forcekill();
			if(trigger.script_noteworthy == "godon")
				other godon();
			if(trigger.script_noteworthy == "godoff")
				other godoff();
			other notify (trigger.script_noteworthy);
		}
		if(script_attackai)
			other.script_attackai = trigger.script_attackai;
		if(script_shots)
			other.shotcount = trigger.script_shots;
		if(script_accuracy)
			other.accuracy = other.offsetzero+(other.offsetrange*trigger.script_accuracy);
		if(script_turningdir)
			other notify ("turning",trigger.script_turningdir);
			
		if(script_deathroll)
			if(trigger.script_deathroll == 0)
				other thread deathrolloff();
			else
				other thread deathrollon();
				
		if(script_vehicleaianim)
			other notify ("groupedanimevent",trigger.script_vehicleaianim);	
	}
}

path_detour_get_detourpath(detournode)
{
	detourpath = undefined;
	for(j=0;j<level.vehicle_detourpaths[detournode.script_vehicledetour].size;j++)
	{
		if(level.vehicle_detourpaths[detournode.script_vehicledetour][j] != detournode)
			if(!islastnode(level.vehicle_detourpaths[detournode.script_vehicledetour][j]))
				detourpath = level.vehicle_detourpaths[detournode.script_vehicledetour][j];
		
	}	
	return detourpath;
}

path_detour(node)
{
	bnodeisscriptorigin = isdefined(node.classname) && node.classname == "script_origin";
	if ( (isdefined(node.detoured)) && (node.detoured == 0) )
	{
		
		if ( self != level.playervehicle )
		{
			detournode = getvehiclenode(node.target,"targetname");
			if(!isdefined(detournode))
				detournode = getent(node.target,"targetname");
			detourpath = path_detour_get_detourpath(detournode);

			if(isdefined(detourpath))
			{
				if(isdefined(detourpath.script_crashtype))
				{
					if(isdefined(self.deaddriver) || self.health <= 0 || detourpath.script_crashtype == "forced" || (level.vclogin_vehicles))  //script_noteworthy was for forced crash path I think
					{
						if((!isdefined (detourpath.derailed)) || (isdefined(detourpath.script_crashtype) && detourpath.script_crashtype == "plane"))
						{
							self notify ("crashpath", detourpath);
							detourpath.derailed = 1;
							self notify ("newpath");
							// todo script origin crashpaths maybe?
							self setSwitchNode (node,detourpath);
							
							return;
						}
					}				
				}
				else if(!(isdefined(detournode.scriptOverride) && detournode.scriptOverride))
				{
					self thread debug_vehicledetour(detournode,detourpath);
					if(bnodeisscriptorigin)
						self thread setdymanicpathswitchnode(detournode,detourpath);
					else
					{
						self notify ("newpath");
						self setswitchnode(detournode,detourpath);
					}
						
					if(!islastnode(detournode) && !(isdefined(node.scriptdetour_persist) && node.scriptdetour_persist) )
						node.detoured = 1;
					self.attachedpath = detourpath;
					if(!bnodeisscriptorigin)
						thread vehicle_paths();
					return;
				}
			}
		}
	}
	else if(isdefined(node.toggledetour) && node.toggledetour)
		node.detoured = 0;

}

setdymanicpathswitchnode(detournode,detourpath)
{
	detournode waittillmatch("trigger",self);
	self thread vehicle_dynamicpath(detourpath);
}

squad_breaker()
{
	self notify ("breaksquad");
	self.tanksquadfollow = false;
	script_resumespeed("breaksquad",level.vehicle_ResumeSpeed);	
}

turret_queorgs( hintnum, looping )
{
	if(!isdefined(looping))
		looping = false;
	println("queing orgs");
	orgs = [];
	rand = randomint( level.vehicle_attackorgs[ hintnum ].size );
	targ = level.vehicle_attackorgs[ hintnum ][ rand ];

	while(isdefined(targ))
	{
		if(!isdefined(targ.script_shots))
		{
			targ.script_shots = 1;
			targ.hinter = false;
		}
		else
		{
			
			if(targ.script_shots == 0 && !looping)
				targ.hinter = true;
			else
			{
				//if(looping)
				//	targ.script_shots = 1;
				targ.hinter = false;
			}
		}
		
		orgs[orgs.size] = targ;
		if(isdefined(targ.target))
			targ = getent(targ.target,"targetname");
		else
			targ = undefined;
	}
	
	self.originque = array_combine( self.originque, orgs );
}

VehicleAttackgroup (groupid)
{
	self notify ("attack",level.vehicle_AttackGroup[groupid]);
}


focusfire (target,other)
{
	if(!isalive(target) || target.health <= 0)
		return;
	other endon ("death");
	other endon ("deadstop");
	/#
	thread debug_vehiclefocusfire(other.origin,target.origin+(0,0,256));
	#/
	target queaddtofront(other);
}

debug_vehiclefocusfire (other,target)
{
	if(getdvar("debug_vehiclefocusfire") == "off")
		return;
	timer = gettime()+ 3000;
	while(getdvar("debug_vehiclefocusfire") != "off" && gettime()< timer)
	{
		line(other,target,(0,0,1),1);
		wait .05;
	}
}


vehicle_Levelstuff (vehicle,trigger)
{
	//associate with links. false
	if(isdefined(vehicle.script_linkname))
		level.vehicle_link = array_2dadd(level.vehicle_link,vehicle.script_linkname,vehicle);

	//associate with targets
	if(isdefined(vehicle.targetname))
		level.vehicle_target = array_2dadd(level.vehicle_target,vehicle.targetname,vehicle);

	if(isdefined(vehicle.script_VehicleAttackgroup))
		level.vehicle_AttackGroup = array_2dadd(level.vehicle_AttackGroup,vehicle.script_VehicleAttackgroup,vehicle);

	if(isdefined(vehicle.script_VehicleSpawngroup))
		level.vehicle_SpawnGroup = array_2dadd(level.vehicle_SpawnGroup,vehicle.script_VehicleSpawngroup,vehicle);

	if(isdefined(vehicle.script_VehicleStartMove))
		level.vehicle_StartMoveGroup = array_2dadd(level.vehicle_StartMoveGroup,vehicle.script_VehicleStartMove,vehicle);

	if(isdefined(vehicle.script_vehicleGroupDelete))
		level.vehicle_DeleteGroup = array_2dadd(level.vehicle_DeleteGroup,vehicle.script_vehicleGroupDelete,vehicle);

	if(isdefined(vehicle.script_vehiclefocusfiregroup))
		level.vehicle_FocusFireGroup = array_2dadd(level.vehicle_FocusFireGroup,vehicle.script_vehiclefocusfiregroup,vehicle);

	if(isdefined(vehicle.script_vehicledeathgate))
		level.vehicle_DeathGate = array_2dadd(level.vehicle_DeathGate,vehicle.script_vehicledeathgate,vehicle);

	if(isdefined(vehicle.script_vehicledeathswitch))
		level.vehicle_DeathSwitch = array_2dadd(level.vehicle_DeathSwitch,vehicle.script_vehicledeathswitch,vehicle);

	// putting space between drones targeting the same path
	if(isdefined(vehicle.script_dronelag))  
	{
		if(!isdefined(level.vehicle_DroneNodeTime_last[vehicle.target]))
			level.vehicle_DroneNodeTime_last[vehicle.target] = gettime();
		if(!isdefined(level.vehicle_DroneNodeTime[vehicle.target]) || gettime()-level.vehicle_DroneNodeTime_last[vehicle.target] > 2)
			level.vehicle_DroneNodeTime[vehicle.target] = 0;
		level.vehicle_DroneNodeTime[vehicle.target] += vehicle.script_dronelag;
		vehicle.script_delay+=level.vehicle_DroneNodeTime[vehicle.target];
		level.vehicle_DroneNodeTime_last[vehicle.target] = gettime();
	}
		
	thread vehicle_level_unstuff(vehicle);
}

vehicle_level_unstuff(vehicle)
{
	vehicle waittill ("death");
	//dis-associate with links. false
	if(isdefined(vehicle.script_linkname))
		level.vehicle_link[vehicle.script_linkname] = array_remove(level.vehicle_link[vehicle.script_linkname],vehicle);
	//dis-associate with targets

	if(isdefined(vehicle.targetname))
		level.vehicle_target[vehicle.targetname] = array_remove(level.vehicle_target[vehicle.targetname],vehicle);;

	if(isdefined(vehicle.script_VehicleAttackgroup))
		level.vehicle_AttackGroup[vehicle.script_VehicleAttackgroup] = array_remove(level.vehicle_AttackGroup[vehicle.script_VehicleAttackgroup],vehicle);

	if(isdefined(vehicle.script_VehicleSpawngroup))
		level.vehicle_SpawnGroup[vehicle.script_VehicleSpawngroup] = array_remove(level.vehicle_SpawnGroup[vehicle.script_VehicleSpawngroup],vehicle);

	if(isdefined(vehicle.script_VehicleStartMove))
		level.vehicle_StartMoveGroup[vehicle.script_VehicleStartMove] = array_remove(level.vehicle_StartMoveGroup[vehicle.script_VehicleStartMove],vehicle);

	if(isdefined(vehicle.script_vehicleGroupDelete))
		level.vehicle_DeleteGroup[vehicle.script_vehicleGroupDelete] = array_remove(level.vehicle_DeleteGroup[vehicle.script_vehicleGroupDelete],vehicle);

	if(isdefined(vehicle.script_vehiclefocusfiregroup))
		level.vehicle_FocusFireGroup[vehicle.script_vehiclefocusfiregroup] = array_remove(level.vehicle_FocusFireGroup[vehicle.script_vehiclefocusfiregroup],vehicle);

	if(isdefined(vehicle.script_vehicledeathswitch))
	{
		level.vehicle_DeathSwitch[vehicle.script_vehicledeathswitch] = array_remove(level.vehicle_DeathSwitch[vehicle.script_vehicledeathswitch],vehicle);
		if(!level.vehicle_DeathSwitch[vehicle.script_vehicledeathswitch].size)
			level notify ("script_vehicledeathswitch"+vehicle.script_vehicledeathswitch);
	}

	if(isdefined(vehicle.script_vehicledeathgate))
	{
		level.vehicle_DeathGate[vehicle.script_vehicledeathgate] = array_remove(level.vehicle_DeathGate[vehicle.script_vehicledeathgate],vehicle);
		if(!level.vehicle_DeathGate[vehicle.script_vehicledeathgate].size)
			level notify ("deathgate_open"+vehicle.script_vehicledeathgate);
	}
}





spawn_array (spawners)
{
	ai = [];
	for(i=0;i<spawners.size;i++)
	{
		spawners[i].count = 1;
		dronespawn = false;
		if (isdefined(spawners[i].script_drone))
		{
				dronespawn = true;
				spawned = dronespawn(spawners[i]);
				assert(isdefined(spawned));
		}
		else if (isdefined(spawners[i].script_forcespawn))
			spawned = spawners[i] stalingradSpawn();
		else
			spawned = spawners[i] doSpawn();
		if (!dronespawn && spawn_failed(spawned))
			continue;
		assert(isdefined(spawned));
		ai[ai.size] = spawned;
	}
	return ai;
}



spawn_group ()
{

	HasRiders = (isdefined(self.script_vehicleride));
	HasWalkers = (isdefined(self.script_vehiclewalk));
	if(!(HasRiders || HasWalkers))
	{
		return;	
	}
	spawners = [];

	riderspawners = [];
	walkerspawners = [];

	if(HasRiders)
		riderspawners = level.vehicle_RideSpawners[self.script_vehicleride];
	if(!isdefined(riderspawners))
		riderspawners = [];
	
	if(HasWalkers)
		walkerspawners = level.vehicle_walkspawners[self.script_vehiclewalk];
	if(!isdefined(walkerspawners))
		walkerspawners = [];


	spawners = array_combine(riderspawners,walkerspawners);
	startinvehicles = [];
	runtovehicles = [];	

	ai = spawn_array(spawners);
	
	if(HasRiders)
		if(isdefined(level.vehicle_RideAI[self.script_vehicleride]))
			ai = array_combine(ai,level.vehicle_RideAI[self.script_vehicleride]);
	if(HasWalkers)
		if(isdefined(level.vehicle_WalkAI[self.script_vehiclewalk]))
			ai = array_combine(ai,level.vehicle_WalkAI[self.script_vehiclewalk]);

	for(i=0;i<ai.size;i++)
	{
		if (isdefined (ai[i].script_vehiclewalk))
		{
			if (isdefined (ai[i].script_followmode))
				ai[i].FollowMode = ai[i].script_followmode;
			else
				ai[i].FollowMode = "cover nodes";
			
			//check if the AI should go to a node after walking with the vehicle
			if (isdefined (ai[i].target))
			{
				node = getnode(ai[i].target,"targetname");
				if (isdefined (node))
					ai[i].NodeAftervehicleWalk = node;
			}
		}
		//this is kind of legacy stuff from CoD1 I don't think anybody uses it anymore. - nate 
		
		if( (isdefined (ai[i].script_noteworthy)) && (ai[i].script_noteworthy == "runtovehicle") )
			runtovehicles[runtovehicles.size] = ai[i];
		else
			startinvehicles[startinvehicles.size] = ai[i];
		
	}
	
	if(runtovehicles.size > 0)
		self notify ("load",runtovehicles);
	guy_array_enter_vehicle(startinvehicles,self);	
}

runtovehicle (guy)
{
	guyarray = [];

	climbinnode = self.climbnode;
	climbinanim = self.climbanim;
	closenode = climbinnode[0];
	currentdist = 5000;
	thenode = undefined;
	for(i=0;i<climbinnode.size;i++)
	{
		climborg = self gettagorigin(climbinnode[i]);
		climbang = self gettagangles(climbinnode[i]);
		org = getstartorigin (climborg, climbang, climbinanim[i]);
		distance = distance(guy.origin, climborg);
		if(distance < currentdist)
		{
			currentdist = distance;
			closenode = climbinnode[i];
			thenode = i;
		}

	}
	
	climbang = undefined;
	climborg = undefined;
	thread runtovehicle_setgoal(guy);
	while(!guy.vehicle_goal)
	{
		climborg = self gettagorigin(climbinnode[thenode]);
		climbang = self gettagangles(climbinnode[thenode]);
		org = getStartOrigin (climborg, climbang, climbinanim[thenode]);
		guy set_forcegoal();
		guy setgoalpos (org);
		guy.goalradius = 64;
		wait .25;
	}
	guy unset_forcegoal();

	if(self getspeedmph() < 1)
	{
		guy linkto (self);
		guy animscripted("hopinend", climborg,climbang, climbinanim[thenode]);
		guy waittillmatch ("hopinend", "end");
		guy_enter_vehicle(guy,self);	
	}
}

runtovehicle_setgoal(guy)
{
	guy.vehicle_goal = false;
	self endon ("death");
	guy endon ("death");
	guy waittill ("goal");
	guy.vehicle_goal = true;
}

vehicle_paths_setup ( pathstart )
{
	detourpath = undefined;
	processtriggers = [];
	pathpoint = pathstart;
	theone = undefined;
	paths = [];
	count = 0;
	pathstart.squadnodes = [];
	while(isdefined (pathpoint))
	{
		paths[count] = pathpoint;
		count++;
		if(isdefined(pathpoint.script_vehicledetour) && pathpoint != pathstart)
		{
			paths[count-2].detoured = 0;
			if(isdefined(pathpoint.script_vehicledisabletrigger))
				paths[count-2].script_vehicledisabletrigger = pathpoint.script_vehicledisabletrigger;
			processtriggers[processtriggers.size] = paths[count-2];

		}
		if(isdefined(pathpoint.script_vehiclesquad))
		{
			if(!isdefined(pathpoint.script_vehiclesquadleader))
			{
				if(isdefined(level.VehicleSquadLeaderPosition[pathpoint.script_vehiclesquad]))
				{
					pathpoint.squadposition = spawn("script_origin",pathpoint.origin);
					pathpoint.gateopen = false;
					pathpoint.gatetype = "vehicle squad formation"; // for debugging
					
				}
				else
				{
					pathpoint.squadbreaker = true;
				}
			}			
			if(!isdefined(pathstart.squadnodes[pathpoint.script_vehiclesquad]))
				pathstart.squadnodes[pathpoint.script_vehiclesquad] = [];
			pathstart.squadnodes[pathpoint.script_vehiclesquad]
			[pathstart.squadnodes[pathpoint.script_vehiclesquad].size]
			= pathpoint;
		}
		if(isdefined (pathpoint.target))
			pathpoint = getvehiclenode(pathpoint.target, "targetname");
		else
			pathpoint = undefined;
	}
	return processtriggers;
}

islastnode ( node )
{
	if(!isdefined(node.target))
		return true;
	if(!isdefined(getvehiclenode(node.target,"targetname")) && !isdefined(getent(node.target,"targetname")))
		return true;
	return false;
}

vehicle_paths ()
{	
	// BOND_MOD:	check for script_ignoreme and don't do this path stuff.
	//				enables us to have a "fake" vehicle to attach a camera to,
	//				but we don't want it to trigger nodes or anything else.

	if (!IsDefined(self.script_sync_enable))
	{
		self.script_sync_enable = true;
	}

	if (IsDefined(self.script_ignoreme) && self.script_ignoreme)
	{
		self.script_sync_enable = false;
		return;
	}

	pathstart = self.attachedpath;
	self.currentNode = self.attachedpath;
	if(!isdefined (pathstart))
		return;
	pathpoint = pathstart;
	arraycount = 0;
	pathpoints = [];
	self.syncpoints = [];
	detourpath = undefined;
	self endon ("newpath");
	while(isdefined (pathpoint))
	{
		pathpoints[arraycount] = pathpoint;
		if (IsDefined(pathpoint.script_sync) && self.script_sync_enable)
		{
			self.syncpoints[self.syncpoints.size] = pathpoint;
		}

		arraycount++;
		if(isdefined (pathpoint.target))
		{
			pathpoint = getvehiclenode(pathpoint.target, "targetname");
		}
		else
			break;
	}

	pathpoint = pathstart;
	for(i=0;i<pathpoints.size;i++)
	{
		self setWaitNode(pathpoints[i]);
		self waittill ("reached_wait_node");
		if(!isdefined(self))
			return;
		self.currentNode = pathpoints[i]; 
		if(isdefined(pathpoints[i].gateopen) && !pathpoints[i].gateopen)
			self thread path_gate_wait_till_open(pathpoints[i]); // threaded because vehicle may setspeed(0,15) and run into the next node
		if(isdefined(pathpoints[i].squadbreaker))
			self thread squad_breaker();
		if(isdefined(self.enemyque) && self.enemyque.size > 0)
			self notify ("attack",self.enemyque);  // stop at every node
		if(isdefined(pathpoints[i].script_begin_sync) && self.script_sync_enable)
				level notify("begin_sync", self, pathpoints[i].script_begin_sync);  // notify "slave" cars to begin sync
		pathpoints[i] notify ("trigger",self); // the sweet stuff! Pathpoints handled in script as triggers!
	}
}

// BOND_MOD: implemented sync nodes - allows vehicles to sync up with other vehicle at specific nodes
vehicle_sync()
{
	self endon("death");
	while (true)
	{
		level waittill("begin_sync", sync_vehicle, sync_id);
		if (self.script_sync_enable)
		{
			if (sync_vehicle == self)	// don't sync with self
			{
				continue;
			}

			for (i = 0; i < self.syncpoints.size; i++)
			{
				if (self.syncpoints[i].script_sync == sync_id)	// found the sync node on this vehicle's path
				{
					for (j = 0; j < sync_vehicle.syncpoints.size; j++)
					{
						if (sync_vehicle.syncpoints[j].script_sync == sync_id) // found the sync node on the master vehicle's path
						{
							self syncToVehicle(sync_vehicle, self.syncpoints[i], sync_vehicle.syncpoints[j]);
						}
					}
				}
			}
		}
	}
}

vehicle_dynamicpathsvehicle (node,bwaitforstart) //for helicopters
{	
	self endon( "death" );
	self notify ("newpath");
	if(isdefined(node))
		self.attachedpath = node;
	if(!isdefined(bwaitforstart))
		bwaitforstart = false;
	pathstart = self.attachedpath;
	self.currentNode = self.attachedpath;
	if(!isdefined (pathstart))
		return;
	pathpoint = pathstart;
	arraycount = 0;
	pathpoints = [];
	detourpath = undefined;
	self endon ("newpath");
	while(isdefined (pathpoint))
	{
		pathpoints[arraycount] = pathpoint;
		arraycount++;
		if(isdefined (pathpoint.target))
			pathpoint = getent(pathpoint.target, "targetname");
		else
			break;
	}
	pathpoint = pathstart;
	if(bwaitforstart)
		self waittill ("start_dynamicpath");
	for(i=0;i<pathpoints.size;i++)
	{
		if(isdefined(pathpoints[i].script_unload) && isdefined(self.fastropeoffset))
		{
			pathpoints[i].radius = 2;
			pathpoints[i].origin = groundpos(pathpoints[i].origin)+(0,0,self.fastropeoffset);
			self sethoverparams(3,1,.5); // TODO, bug engineering. get them to make 0 level the helicopter off better.
		}
		
		if ( ( isdefined( pathpoints[ i - 1 ] ) ) && ( isdefined( pathpoints[ i - 1 ].speed ) ) )
		{
			accel = 25;
			if ( accel > pathpoints[ i - 1 ].speed )
				accel = ( pathpoints[ i - 1 ].speed / 4 );
			self setSpeed( pathpoints[ i - 1 ].speed, accel );
		}
			
		self setvehgoalnode( pathpoints[i]);
		
		if(isdefined(pathpoints[i].radius))
		{
			self setNearGoalNotifyDist( pathpoints[i].radius );
			assertex(pathpoints[i].radius > 0, "radius: " + pathpoints[i].radius);
			self waittill_any ("near_goal","goal");
		}
		else
		{
			self waittill ("goal");
		}
		
		if(isdefined(pathpoints[i].script_stopnode))
			if (pathpoints[i].script_stopnode)
				self notify("reached_stop_node");
		
		if(isdefined(pathpoints[i].script_noteworthy))
			self notify(pathpoints[i].script_noteworthy);
		
		//todo handle nodes with angles for strafeing and all that cool stuff
		if(!isdefined(self))
			return;
			
		self.currentNode = pathpoints[i]; 
		if(isdefined(pathpoints[i].gateopen) && !pathpoints[i].gateopen)
			self thread path_gate_wait_till_open(pathpoints[i]); // threaded because vehicle may setspeed(0,15) and run into the next node
		if(isdefined(pathpoints[i].squadbreaker))
			self thread squad_breaker();
		if(isdefined(self.enemyque) && self.enemyque.size > 0)
			self notify ("attack",self.enemyque);  // stop at every node
		pathpoints[i] notify ("trigger",self); // the sweet stuff! Pathpoints handled in script as triggers!

		if(isdefined(pathpoints[i].script_unload) && isdefined(self.fastropeoffset))
			return; // script_unload nodes will resume the path.
	}
}

setvehgoalnode(node,stop,radius)
{
	self endon( "death" );
	
	stop = false;
	if( !isdefined( stop ) )
		stop = true;
	if( isdefined( node.script_stopnode ) ) //z: stop at nodes if there is a script_stopnode = 1 value
		stop = node.script_stopnode;
		
	if( isdefined(node.script_unload))
		stop = true;
		
	if(isdefined(node.script_anglevehicle))
		self forcetarget(node);
	else
		self unforcetarget();
	self setvehgoalpos_wrap( node.origin, stop );  //Z: second param = false dont stop at each node.
}

forcetarget(node)
{
	vector = vector_multiply(anglestoforward(node.angles),300000);
	if(!isdefined(self.forcelookatent))
		self.forcelookatent = spawn("script_origin",self.origin);
	self.forcelookatent.origin = node.origin+vector;
	self setLookAtEnt(self.forcelookatent);
}

unforcetarget()
{
	self clearlookatent();
}


debug_vehicledetour (start,end)
{
	/#
	self notify ("newdetour");
	self endon ("newdetour");
	self endon ("death");
	while(getdvar("debug_vehicledetour") != "off")
	{
		print3d(self.origin+(0,0,128),"vehicle_detourpaths group: "+start.script_vehicledetour, (1,1,1),1,2);
		line(start.origin,end.origin, (1,1,1),1);
		line(self.origin,start.origin, (1,1,1),1);
		wait .05;
	}
	#/
}

deathrollon () 
{
	if(self.health > 0)
		self.rollingdeath = 1;
}

deathrolloff ()
{
	self.rollingdeath = undefined;
	self notify("deathrolloff");
}

getonpath (target)
{
	self.bpathisdynamic = false;
	theone = undefined;
	type = self.vehicletype;

	if (IsDefined(target))
	{
		self.target = target;
	}

	if(isdefined(self.target))
	{
		theone = getvehiclenode(self.target,"targetname");
		if (!isdefined (theone))
		{
			theone = getent(self.target,"targetname");
			self.bpathisdynamic = true;
		}
	}
	if (!isdefined (theone))
		return;
	self.attachedpath = theone;
	
	self.origin = theone.origin;
	if(!self.bpathisdynamic)
		self attachpath (theone);
	else if(isdefined(theone.speed))
		self setspeed(theone.speed,20,10);
	else
		self setspeed(60,20,10);
	self disconnectpaths();
	
	if(!self.bpathisdynamic)
		self thread vehicle_paths();
	else
		self thread vehicle_dynamicpath(undefined,true);

}

create_vehicle_from_spawngroup_and_gopath( spawnGroup )
{
	vehicleArray = maps\_vehicle::scripted_spawn( spawnGroup );
	for ( i=0; i<vehicleArray.size; i++ )
		level thread maps\_vehicle::gopath( vehicleArray[ i ] );
}

gopath ( vehicle )
{
	if(!isdefined(vehicle))
		println("go path called on non existant vehicle");
	
	if(isdefined(vehicle.script_vehiclestartmove))
		level.vehicle_StartMoveGroup[vehicle.script_vehiclestartmove] = array_remove(level.vehicle_StartMoveGroup[vehicle.script_vehiclestartmove],vehicle);
	vehicle endon ("death");
	if(isdefined(vehicle.hasstarted))
	{
		println("vehicle already moving when triggered with a startmove");
		return;
	}
	else
		vehicle.hasstarted = true;
	
	if(isdefined(vehicle.script_delay))
		wait vehicle.script_delay;
	
	vehicle notify ("start_vehiclepath");
	
	if(!vehicle.bpathisdynamic)
		vehicle startpath();
	else
		vehicle notify ("start_dynamicpath");
	wait .05;
	vehicle connectpaths();
	vehicle waittill ("reached_end_node");
	
	if(isdefined(vehicle.script_unloaddelay))
		vehicle thread dounload(vehicle.script_unloaddelay);
	else
		vehicle notify ("unload");
	
//	vehicle vehicle_setspeed(0,200,"reached end node");
//	vehicle joltbody((vehicle.origin + (0,0,64)),.5);
	vehicle disconnectpaths();
}

dounload ( delay )
{
	self endon ("unload");
	
	if (delay <= 0)
		return;

	wait delay;
		
	self notify ("unload");
}

path_gate_open ( node )
{
	node.gateopen = true;
	node notify ("gate opened");
}

path_gate_wait_till_open ( pathspot )
{

	self endon ("death");
	self.waitingforgate = true;
	self vehicle_setspeed(0,15,"path gate closed");
	pathspot waittill("gate opened");
	self.waitingforgate = false;
	if(self.health > 0)
		script_resumespeed("gate opened",level.vehicle_ResumeSpeed);
}

spawner_setup ( vehicles ,message, from )
{

	script_vehiclespawngroup = message;
	
	if ( !isdefined( level.vehicleSpawners ) )
		level.vehicleSpawners = [];
	
	level.vehicleSpawners[script_vehiclespawngroup] = [];
	
	vehicle = [];  // vehicle is an array of vehiclegroup array's
	for(i=0;i<vehicles.size;i++)
	{
		if(!isdefined(vehicle[script_vehiclespawngroup]))
			vehicle[script_vehiclespawngroup] = [];
		
		
		script_origin = spawn("script_origin",vehicles[i].origin);
		
		//creates struct that copies certain values from the vehicle to be added when the vehicle is spawned.
		script_origin setspawnervariables(vehicles[i],from);
		vehicle[script_vehiclespawngroup][vehicle[script_vehiclespawngroup].size] = script_origin;
		level.vehicleSpawners[script_vehiclespawngroup][i] = script_origin;
		
	}
	while(1)
	{
		spawnedvehicles = [];	
		level waittill ("spawnvehiclegroup"+message);
		for(i=0;i<vehicle[script_vehiclespawngroup].size;i++)
			spawnedvehicles[spawnedvehicles.size] = vehicle_spawn( vehicle[script_vehiclespawngroup][i] );		
		level notify ("vehiclegroup spawned"+message,spawnedvehicles);
	}
}

scripted_spawn ( group )
{
	thread scripted_spawn_go( group );
	level waittill ("vehiclegroup spawned"+group,vehicles);
	return vehicles;
}

scripted_spawn_go ( group )
{
	waittillframeend;
	level notify ("spawnvehiclegroup"+group);
}

setspawnervariables ( vehicle,from )
{
//	self.spawnerclassname = vehicle.classname;
	self.spawnermodel = vehicle.model;
	self.angles = vehicle.angles;
	self.origin = vehicle.origin;
	if(isdefined(vehicle.script_delay))
		self.script_delay = vehicle.script_delay;
	if(isdefined(vehicle.script_noteworthy))
		self.script_noteworthy = vehicle.script_noteworthy;
	if(isdefined(vehicle.script_team))
		self.script_team = vehicle.script_team;
	if(isdefined(vehicle.script_accuracy))
		self.script_accuracy = vehicle.script_accuracy;
	if(isdefined(vehicle.script_vehicleride))
		self.script_vehicleride = vehicle.script_vehicleride;
	if(isdefined(vehicle.target))
		self.target = vehicle.target;
	if(isdefined(vehicle.targetname))
		self.targetname = vehicle.targetname;
	else
		self.targetname = "notdefined";
		self.spawnedtargetname = self.targetname;

	self.targetname = self.targetname+"_vehiclespawner";
	if(isdefined(vehicle.triggeredthink))
		self.triggeredthink = vehicle.triggeredthink;
	if(isdefined(vehicle.script_sound))
		self.script_sound = vehicle.script_sound;
	if(isdefined(vehicle.script_turretmg))
		self.script_turretmg = vehicle.script_turretmg;
	if(isdefined(vehicle.script_startinghealth))
		self.script_startinghealth = vehicle.script_startinghealth;
	if(isdefined(vehicle.spawnerNum))
		self.spawnerNum = vehicle.spawnerNum;
	if(isdefined(vehicle.script_deathnotify))
		self.script_deathnotify = vehicle.script_deathnotify;
	if(isdefined(vehicle.script_turret))
		self.script_turret = vehicle.script_turret;
	if(isdefined(vehicle.script_linkTo))
		self.script_linkTo = vehicle.script_linkTo;
	if(isdefined(vehicle.script_VehicleAttackgroup))
		self.script_VehicleAttackgroup = vehicle.script_VehicleAttackgroup;
	if(isdefined(vehicle.script_VehicleSpawngroup))
		self.script_VehicleSpawngroup = vehicle.script_VehicleSpawngroup;
	if(isdefined(vehicle.script_VehicleStartMove))
		self.script_VehicleStartMove = vehicle.script_VehicleStartMove;
	if(isdefined(vehicle.script_vehicleGroupDelete))
		self.script_vehicleGroupDelete = vehicle.script_vehicleGroupDelete;
	if(isdefined(vehicle.script_nomg))
		self.script_nomg = vehicle.script_nomg;
	if(isdefined(vehicle.script_badplace))
		self.script_badplace = vehicle.script_badplace;
	if(isdefined(vehicle.script_nobadplace))
		self.script_nobadplace = vehicle.script_nobadplace;
	if(isdefined(vehicle.script_vehicleride))
		self.script_vehicleride = vehicle.script_vehicleride;
	if(isdefined(vehicle.script_vehiclewalk))
		self.script_vehiclewalk = vehicle.script_vehiclewalk;
	if(isdefined(vehicle.script_linkName))
		self.script_linkName = vehicle.script_linkName;
	if(isdefined(vehicle.script_avoidvehicles))
		self.script_avoidvehicles = vehicle.script_avoidvehicles;
	if(isdefined(vehicle.script_vehiclefocusfiregroup))
		self.script_vehiclefocusfiregroup = vehicle.script_vehiclefocusfiregroup;
	if(isdefined(vehicle.script_crashtypeoverride))
		self.script_crashtypeoverride = vehicle.script_crashtypeoverride;
	if(isdefined(vehicle.script_vehicledeathgate))
		self.script_vehicledeathgate = vehicle.script_vehicledeathgate;
	if(isdefined(vehicle.script_vehicledeathswitch))
		self.script_vehicledeathswitch = vehicle.script_vehicledeathswitch;
	if(isdefined(vehicle.script_dronelag))
		self.script_dronelag = vehicle.script_dronelag;
	if(isdefined(vehicle.script_unloaddelay))
		self.script_unloaddelay = vehicle.script_unloaddelay;
	if(isdefined(vehicle.script_unloadmgguy))
		self.script_unloadmgguy = vehicle.script_unloadmgguy;
	if(isdefined(vehicle.script_keepdriver))
		self.script_keepdriver = vehicle.script_keepdriver;
	if(isdefined(vehicle.script_fireondrones))
		self.script_fireondrones = vehicle.script_fireondrones;
	if(isdefined(vehicle.script_tankgroup))
		self.script_tankgroup = vehicle.script_tankgroup;
	if(isdefined(vehicle.script_avoidplayer))
		self.script_avoidplayer = vehicle.script_avoidplayer; 
	if(isdefined(vehicle.script_playerconeradius))
		self.script_playerconeradius = vehicle.script_playerconeradius;
	if(isdefined(vehicle.script_cobratarget))
		self.script_cobratarget = vehicle.script_cobratarget;
	if(isdefined(vehicle.script_targettype))
		self.script_targettype = vehicle.script_targettype;
	if(isdefined(vehicle.script_targetoffset_z))
		self.script_targetoffset_z = vehicle.script_targetoffset_z;
	if(isdefined(vehicle.script_wingman))
		self.script_wingman = vehicle.script_wingman;
	if(isdefined(vehicle.script_mg_angle))
		self.script_mg_angle = vehicle.script_mg_angle;
	
	
	if(vehicle.count > 0)
		self.count = vehicle.count;
	else
		self.count = 1;

	if(isdefined(vehicle.script_attackai))
		self.script_attackai = vehicle.script_attackai;

	if(isdefined(vehicle.vehicletype))
		self.vehicletype = vehicle.vehicletype;
	else
		println("vehicle doesn't have vehicle type at ",vehicle.origin);
	vehicle delete();
}

vehicle_spawn ( vspawner, from )
{
	if(!vspawner.count)
		return;


	vehicle = spawnVehicle( vspawner.spawnermodel, vspawner.spawnedtargetname, vspawner.vehicletype ,vspawner.origin, vspawner.angles );
	if(isdefined(vspawner.script_delay))
		vehicle.script_delay = vspawner.script_delay;
	if(isdefined(vspawner.script_noteworthy))
		vehicle.script_noteworthy = vspawner.script_noteworthy;
	if(isdefined(vspawner.script_team))
		vehicle.script_team = vspawner.script_team;
	if(isdefined(vspawner.script_accuracy))
		vehicle.script_accuracy = vspawner.script_accuracy;
	if(isdefined(vspawner.script_vehicleride))
		vehicle.script_vehicleride = vspawner.script_vehicleride;
	if(isdefined(vspawner.target))
		vehicle.target = vspawner.target;
	if(isdefined(vspawner.vehicletype))
		vehicle.vehicletype = vspawner.vehicletype;
	if(isdefined(vspawner.triggeredthink))
		vehicle.triggeredthink = vspawner.triggeredthink;
	if(isdefined(vspawner.script_sound))
		vehicle.script_sound = vspawner.script_sound;
	if(isdefined(vspawner.script_turretmg))
		vehicle.script_turretmg = vspawner.script_turretmg;
	if(isdefined (vspawner.script_startinghealth))
		vehicle.script_startinghealth = vspawner.script_startinghealth;
	if(isdefined (vspawner.script_deathnotify))
		vehicle.script_deathnotify = vspawner.script_deathnotify;
	if(isdefined (vspawner.script_turret))
		vehicle.script_turret = vspawner.script_turret;
	if(isdefined (vspawner.script_linkTo))
		vehicle.script_linkTo = vspawner.script_linkTo;
	if(isdefined (vspawner.script_VehicleAttackgroup))
		vehicle.script_VehicleAttackgroup = vspawner.script_VehicleAttackgroup;
	if(isdefined (vspawner.script_VehicleSpawngroup))
		vehicle.script_VehicleSpawngroup = vspawner.script_VehicleSpawngroup;
	if(isdefined (vspawner.script_VehicleStartMove))
		vehicle.script_VehicleStartMove = vspawner.script_VehicleStartMove;
	if(isdefined (vspawner.script_vehicleGroupDelete))
		vehicle.script_vehicleGroupDelete = vspawner.script_vehicleGroupDelete;
	if(isdefined (vspawner.script_nomg))
		vehicle.script_nomg = vspawner.script_nomg;
	if(isdefined (vspawner.script_badplace))
		vehicle.script_badplace = vspawner.script_badplace;
	if(isdefined (vspawner.script_vehicleride))
		vehicle.script_vehicleride = vspawner.script_vehicleride;
	if(isdefined (vspawner.script_vehiclewalk))
		vehicle.script_vehiclewalk = vspawner.script_vehiclewalk;
	if(isdefined (vspawner.script_linkName))
		vehicle.script_linkName = vspawner.script_linkName;
	if(isdefined (vspawner.script_avoidvehicles))
		vehicle.script_avoidvehicles = vspawner.script_avoidvehicles;
	if(isdefined (vspawner.script_vehiclefocusfiregroup))
		vehicle.script_vehiclefocusfiregroup = vspawner.script_vehiclefocusfiregroup;
	if(isdefined (vspawner.script_crashtypeoverride))
		vehicle.script_crashtypeoverride = vspawner.script_crashtypeoverride;
	if(isdefined (vspawner.script_attackai))
		vehicle.script_attackai = vspawner.script_attackai;
	if(isdefined (vspawner.script_vehicledeathgate))
		vehicle.script_vehicledeathgate = vspawner.script_vehicledeathgate;
	if(isdefined (vspawner.script_vehicledeathswitch))
		vehicle.script_vehicledeathswitch = vspawner.script_vehicledeathswitch;
	if(isdefined (vspawner.script_dronelag))
		vehicle.script_dronelag = vspawner.script_dronelag;
	if(isdefined (vspawner.script_unloaddelay))
		vehicle.script_unloaddelay = vspawner.script_unloaddelay;
	if(isdefined(vspawner.script_unloadmgguy))
		vehicle.script_unloadmgguy = vspawner.script_unloadmgguy;
	if(isdefined(vspawner.script_keepdriver))
		vehicle.script_keepdriver = vspawner.script_keepdriver;
	if(isdefined(vspawner.script_fireondrones))
		vehicle.script_fireondrones = vspawner.script_fireondrones;
	if(isdefined(vspawner.script_tankgroup))
		vehicle.script_tankgroup = vspawner.script_tankgroup;
	if(isdefined(vspawner.script_avoidplayer))
		vehicle.script_avoidplayer = vspawner.script_avoidplayer;
	if(isdefined(vspawner.script_playerconeradius))
		vehicle.script_playerconeradius = vspawner.script_playerconeradius; 
	if(isdefined(vspawner.script_cobratarget))
		vehicle.script_cobratarget = vspawner.script_cobratarget; 	
	if(isdefined(vspawner.script_targettype))
		vehicle.script_targettype = vspawner.script_targettype; 	
	if(isdefined(vspawner.script_targetoffset_z))
		vehicle.script_targetoffset_z = vspawner.script_targetoffset_z; 
	if(isdefined(vspawner.script_wingman))
		vehicle.script_wingman = vspawner.script_wingman; 
	if(isdefined(vspawner.script_mg_angle))
		vehicle.script_mg_angle = vspawner.script_mg_angle; 
	
	initVehicle = true;
	if ( (isdefined(vehicle.script_noteworthy)) && (vehicle.script_noteworthy == "playervehicle") )
		initVehicle = false;
	
//	if ( initVehicle )
	vehicle_init(vehicle);

	if(isdefined(vehicle.targetname))
		level notify ("new_vehicle_spawned"+vehicle.targetname,vehicle);
	
	return vehicle;
}

waittill_vehiclespawn ( targetname )
{
	level waittill ("new_vehicle_spawned"+targetname,vehicle);
	return vehicle;
	
}

wait_vehiclespawn (targetname)
{
	println("wait_vehiclespawn() called; change to waittill_vehiclespawn()");
	level waittill ("new_vehicle_spawned"+targetname,vehicle);
	return vehicle;
}

vehicle_init (vehicle)
{
	// get on path and start the path handler thread
	vehicle thread getonpath();

	// BOND_MOD
	// 03/05/08: Hack to not do most of the vehicle stuff on invisible vehicles
	if (IsDefined(self.script_ignoreme) && self.script_ignoreme)
	{
		return;
	}
	// 03/01/08: handle vehicle syncing
	vehicle thread vehicle_sync();
	// !BOND_MOD

	if ( (isdefined(vehicle.script_noteworthy)) && (vehicle.script_noteworthy == "playervehicle") )
		return; //TODO:  I really don't think we should branch off the players vehicle so early. - nate
	
	// TODO: These shouldn't be asigned to everyvehicle
	vehicle.tanksquadfollow = false;
	vehicle.zerospeed = true;
	
	if(!isdefined(vehicle.modeldummyon))
		vehicle.modeldummyon = false;	


	type = vehicle.vehicletype;

	// give the vehicle health
	vehicle vehicle_life();

	// set the script_team value used everywhere to determine which team the vehicle belongs to
	vehicle vehicle_setteam();


	// init pointer is specified in the precache script (IE maps\_tiger::main())
	// only special case gag works should exist in this thread, 
	// I'm currently working to reduce redundancy by moving common init functions here 
	vehicle thread [[level.vehicleInitThread[vehicle.vehicletype][vehicle.model]]]();

	if(!isdefined(vehicle.script_avoidvehicles))
		vehicle.script_avoidvehicles = false;
	if(!isdefined(vehicle.script_badplace))
		vehicle.script_badplace = true;
	if(!isdefined(vehicle.script_attackai))
		vehicle.script_attackai = true;
	if(!isdefined(vehicle.script_avoidplayer))
		vehicle.script_avoidplayer = false; 
	
	vehicle.riders = [];
	vehicle.walkers = [];
	vehicle.unloadque = [];  //for ai. wait till a vehicle is unloaded all the way
	vehicle.unload_group = "default";

	vehicle.getoutrig = [];
	if(isdefined(level.vehicle_attachedmodels) && isdefined(level.vehicle_attachedmodels[type]))
	{
		rigs = level.vehicle_attachedmodels[type];
		strings = getarraykeys(rigs);
		for(i=0;i<strings.size;i++)
		{
			vehicle.getoutrig[strings[i]] = false;
			vehicle.getoutriganimating[strings[i]] = false;
		}
	}

	// BOND MOD
	// MQL 11/30/07: add death anim, flat tire anim, and night fx (if applicable)
	if( ( type == "sedan" ) || ( type == "van" ) || ( type == "suv" ) || ( type == "humvee50cal" ) )
	{
		// set up automobile death, flattire anims, and exhaust
		vehicle thread bond_veh_death();
		vehicle thread bond_veh_flat_tire();
		// Creates an entity but its cleared up ok on death
		vehicle thread bond_veh_exhaust();

		// check for nightime to enable night effects
		if( IsDefined( vehicle.script_int )  && ( vehicle.script_int > 0 ) )
		{
			vehicle thread bond_veh_running_lights();
		}
	}
	
	if( type == "blackhawk" )
	{
		// check for helicopter lights
		if( IsDefined( vehicle.script_int )  && ( vehicle.script_int > 0 ) )
		{
			vehicle thread bond_veh_running_lights();
		}
	}

	// Bond Scripted localized damage system
	if (IsDefined(vehicle.script_damage) && vehicle.script_damage)
	{
		vehicle thread maps\_vehicle_damage::main();
	}

	// avoid running into other vehicles TODO: GET CODE to do this expensive stuff
	vehicle thread vehicle_avoidcolision();
	
	// make ai run way from vehicle
	vehicle thread vehicle_badplace();
	
	// BOND_MOD: _brian_b_ - I dont' think we need this for Bond and it was causing problems
	// regenerate friendly fire damage
	//vehicle thread friendlyfire_shield();

	// handles guys riding and doing stuff on vehicles
	vehicle thread maps\_vehicle_aianim::handle_attached_guys();

	// special stuff for unloading
	vehicle thread vehicle_handleunloadevent();
	
	// Make the main turret think
	vehicle thread turret_attack_think();
	
	// make the vehicle rumble
	vehicle thread vehicle_rumble();
	
	// handle tread effects
	vehicle thread vehicle_treads();
	
	// handle the compassicon for friendly vehicles
	vehicle thread vehicle_compasshandle();

	// make the wheels rotate
	vehicle thread animate_drive_idle();
	
	// handle machine guns
	vehicle thread mginit();
	
	if ( isdefined( level.vehicleSpawnCallbackThread ) )
		level thread [[level.vehicleSpawnCallbackThread]](vehicle);

	// get on path and start the path handler thread
	// vehicle thread getonpath(); //03/05/08 (brian b): moved up
	
	// every vehicle that stops will disconnect its paths TODO: remove flak88's from this
	vehicle thread disconnect_paths_whenstopped();


	// this got kind of ugly and hackery but it's how I deal with player driveable vehicles in decoytown,elalamein,88ridge and libya
	if (isdefined(vehicle.spawnflags) && vehicle.spawnflags & 1 )
	{
		startinvehicle = (isdefined(vehicle.script_noteworthy) && vehicle.script_noteworthy == "startinside"); // can't see making a whole new keys.txt entry for something that's only going to be used once in any given level.
		vehicle maps\_vehicledrive::setup_vehicle();
		vehicle thread maps\_vehicledrive::vehicle_wait(startinvehicle);
		vehicle_Levelstuff(vehicle);
		vehicle thread kill();
		return;
	}

	// associate vehicle with living level variables.	
	vehicle_Levelstuff(vehicle);
	if(isdefined(vehicle.script_team))
		vehicle setvehicleteam(vehicle.script_team);
	
	// squad behavior
	vehicle thread squad();
	
	// some vehicles unload when the player uses them
	vehicle thread vehicle_use_unload();

	// helicopters do dust kickup fx
	if ( vehicle isHelicopter() )
		vehicle thread helicopter_dust_kickup();
	
	//spawn the vehicle and it's associated ai	
	vehicle spawn_group();
	

	if( ( type == "sedan" ) || ( type == "humvee50cal" ) )
	{
	}
	else
	{
		vehicle thread kill();
	}
}

kill_damage (type)
{
	if(!isdefined(level.vehicle_death_radiusdamage) || !isdefined(level.vehicle_death_radiusdamage[type]))
		return;
	
	if(isdefined(self.deathdamage_max))
		maxdamage = self.deathdamage_max;
	else
		maxdamage = level.vehicle_death_radiusdamage[type].maxdamage;
	if(isdefined(self.deathdamage_min))
		mindamage = self.deathdamage_min;
	else
		mindamage = level.vehicle_death_radiusdamage[type].mindamage;
	
	if(level.vehicle_death_radiusdamage[type].bKillplayer)
		level.player enableHealthShield( false );		
	radiusDamage(self.origin+level.vehicle_death_radiusdamage[type].offset,level.vehicle_death_radiusdamage[type].range,maxdamage,mindamage);
	if(level.vehicle_death_radiusdamage[type].bKillplayer)
		level.player enableHealthShield( true );		
}

kill ()
{
	self endon ( "nodeath_thread" );
	type = self.vehicletype;
	model = self.model;

	//self thread print3Dmessage( (0,0,20), "kill");

	self waittill ("death",attacker);

	//if vehicle is gone then don't do this stuff		
	if(!isdefined(self))
		return; 

	//some tank and turret cleanup
/*	

	// don't think all this is necessary. should just be a matter of deleting them
	for (i=0;i<self.mgturret.size;i++)
	{
		self.mgturret[i] notify ("death");
		self.mgturret[i] cleartargetentity();
		self thread maps\_vehicle::mgoff();
		self.mgturret[i] thread maps\_vehicle::mgoff();
		self.mgturret[i] setmode("manual");
	}
*/
	if(isdefined(self.rumbletrigger))
		self.rumbletrigger delete();
	if(isdefined(self.mgturret))
		for (i=0;i<self.mgturret.size;i++)
			if(isdefined(self.mgturret[i]))
				self.mgturret[i] delete();
	if(isdefined(self.colidecircle))
		for(i=0;i<self.colidecircle.size;i++)
			self.colidecircle[i] delete();
	
	level.vehicles[self.script_team] = array_remove( level.vehicles[self.script_team], self );
	level.vehicle_threats = array_remove(level.vehicle_threats,self);
	
	if(isdefined(self.samplepoints))
		for(i=0;i<self.samplepoints.size;i++)
			self.samplepoints[i] delete();
	if(isdefined(self.checkorg))
		self.checkorg delete();
		
	if(isdefined(self.nospawning))
		self.tankgetout = 0;

	if(isdefined(level.vehicle_rumble[type]))
		self StopRumble( level.vehicle_rumble[type].rumble );

		
	if(isdefined(level.vehicle_death_thread[type]))
		thread [[level.vehicle_death_thread[type]]]();	

	if(isdefined(level.vehicle_death_earthquake[type]))
		earthquake
		(
			level.vehicle_death_earthquake[type].scale,
			level.vehicle_death_earthquake[type].duration,
			self.origin,
			level.vehicle_death_earthquake[type].radius
		);

	//does radius damage
	kill_damage (type);

	if( isdefined(level.vehicle_deathmodel[model]))
		self setmodel (level.vehicle_deathmodel[model]);
		
	// I used this for identifying when the players tank kills stuff in libya for dialog
	if(isdefined(level.vehicle_deathnotify) && isdefined(level.vehicle_deathnotify[self.vehicletype]))
		level notify (level.vehicle_deathnotify[self.vehicletype],attacker);
		
	thread kill_fx(model);
	if(self.health > 0)
	{
		playerWasDemiGod = level.player isdemigod();

		if( !level.VehicleExplosionCanKillPlayer )
		{
			level.player setdemigod(true);
		}

		radiusdamage( self.origin + ( 0, 0, 50 ), 30, 20000, 20000 ); // for vehicles notified "death".

		if(  !level.VehicleExplosionCanKillPlayer && !playerWasDemiGod )
		{	
			level.player setdemigod(false);
		}
	}
	
	if ( isdefined( self.delete_on_death ) )
	{
		wait 0.05;
		self disconnectpaths();
		self freevehicle();
		wait 0.05;
		self delete();
		return;
	}
	
	// all the vehicles get the same jolt...
	self joltbody((self.origin + (23,33,64)),3);
	
	//crazy crashpath stuff.
	if(isdefined(self.script_crashtypeoverride))
		crashtype = self.script_crashtypeoverride;
	else if(isdefined(self.currentnode) && crash_path_check(self.currentnode))
		crashtype = "none";
	else
		crashtype = "tank";  //tanks used to be the only vehicle that would stop. legacy nonsense from CoD1
	
	if(crashtype == "tank")
	{
		if(!isdefined(self.rollingdeath))
			self vehicle_setspeed(0,25,"Dead");
		else
		{
			self vehicle_setspeed(8,25,"Dead rolling out of path intersection");
			self waittill ("deathrolloff");
			self vehicle_setspeed(0,25,"Dead, finished path intersection");
		}
		wait .4;
		self vehicle_setspeed(0,10000,"deadstop");
	
		self notify ("deadstop");
		self disconnectpaths();
		if ( (isdefined(self.tankgetout)) && (self.tankgetout > 0) )
			self waittill ("animsdone");  //tankgetout will never get notified if there are no guys getting out
	}
	if ((isdefined(level.vehicle_hasMainTurret[model]) && level.vehicle_hasMainTurret[model]) && (!isdefined (level.playervehicle)) || ( (isdefined (level.playervehicle)) && (self != level.playervehicle) ) )
		self clearTurretTarget();
	while(isdefined(self) && self getspeedmph () > 0 )
		wait .1;
	
	wait .5;
	
	if ( (isdefined (self)) && (level.playervehicle != self) )
		self freevehicle();
}

crash_path_check(node)
{
	//find a crashnode on the current path?
	targ = node;
	while(isdefined(targ))
	{
		if ( (isdefined(targ.detoured)) && (targ.detoured == 0) )
		{
			detourpath = path_detour_get_detourpath(getvehiclenode(targ.target,"targetname"));
			if(isdefined(detourpath) && isdefined(detourpath.script_crashtype))
	 			return true;
		}
		if(isdefined(targ.target))
			targ = getvehiclenode(targ.target,"targetname");
		else
			targ = undefined;
	}
	return false;
	
}

death_firesound (sound)
{
	self playloopsound (sound);
	self waittill_any("death","fire_extinguish");
	self stoploopsound ();
}

kill_fx (model)
{
	// going to use vehicletypes for identifying a vehicles association with effects. 
	// will add new vehicle types if vehicle is different enough that it needs to use 
	// different effect. also handles the sound
		
	//all of these effects will end when the vehicle is notified ("fire_extinguish");
	
	level notify ( "vehicle_explosion", self.origin );
	
	type = self.vehicletype;
	effects = [];

	if (IsArray(level.vehicle_death_fx[type]))	// 03.06.08: bb - fix for conflict between old stuff and new bond stuff
	{
		for(i=0;i<level.vehicle_death_fx[type].size;i++)
		{
			if(isdefined(level.vehicle_death_fx[type][i].effect))
			{
				if( (level.vehicle_death_fx[type][i].bEffectLooping) && (!isdefined(self.delete_on_death)) )
					thread playLoopedFxontag( level.vehicle_death_fx[type][i].effect, level.vehicle_death_fx[type][i].delay, level.vehicle_death_fx[type][i].tag);
				else
					playfxontag(level.vehicle_death_fx[type][i].effect,self,level.vehicle_death_fx[type][i].tag);
			}
			if( (isdefined(level.vehicle_death_fx[type][i].sound)) && (!isdefined(self.delete_on_death)) )
			{
				if(level.vehicle_death_fx[type][i].bSoundlooping)
					self playsound(level.vehicle_death_fx[type][i].sound);
				else
					thread death_firesound(level.vehicle_death_fx[type][i].sound);
			}
		}
	}
}

build_radiusdamage ( offset, range, maxdamage, mindamage,bKillplayer )
{
	if(!isdefined(bKillplayer))
		bKillplayer = false;
	if(!isdefined(offset))
		offset = (0,0,0);
	struct = spawnstruct();
	struct.offset = offset;
	struct.range = range;
	struct.maxdamage = maxdamage;
	struct.mindamage = mindamage;
	struct.bKillplayer = bKillplayer;
	return struct;
}


build_rumble( rumble , scale , duration , radius , basetime , randomaditionaltime )
{
	struct = build_quake ( scale, duration, radius ,basetime,randomaditionaltime);
	struct.rumble = rumble;
	return struct;
}

build_quake ( scale, duration, radius ,basetime,randomaditionaltime)
{
	struct = spawnstruct();
	struct.scale = scale;
	struct.duration = duration;
	struct.radius = radius;
	if(isdefined(basetime))
		struct.basetime = basetime;
	if(isdefined(randomaditionaltime))
		struct.randomaditionaltime = randomaditionaltime;
	return struct;
}
	
build_deathfx(array,effect,tag,sound,bEffectLooping,delay,bSoundlooping)
{
	if(!isdefined(array))
		array = [];
	if(!isdefined(bSoundlooping))
		bSoundlooping = false;
	if(!isdefined(bEffectLooping))
		bEffectLooping = false;
	if(!isdefined(tag))
		tag = "tag_origin";
	if(!isdefined(delay))
		delay = 1;
	struct = spawnstruct();
	struct.effect = effect;
	struct.tag = tag;
	struct.sound = sound;
	struct.bSoundlooping = bSoundlooping;
	struct.delay = delay;
	struct.bEffectLooping = bEffectLooping;
	struct.effect = effect;
	array[array.size] = struct;
	return array;
}

precache_scripts ()
{
	//find all the vehicles in the level and initialize precaching ( calling of vehicles main() mostly)
	allvehiclesprespawn = [];
	vehicles = getentarray("script_vehicle","classname");
	vehicles = array_combine(vehicles,getentarray("vehiclespawnmodel","targetname"));
	
	level.needsprecaching = [];
	playerdrivablevehicles = [];
	allvehiclesprespawn = [];
	if(!isdefined(level.vehicleInitThread))
		level.vehicleInitThread = [];

	for (i=0;i<vehicles.size;i++)
	{
		vehicles[i].vehicletype = tolower(vehicles[i].vehicletype);

		if(isdefined(vehicles[i].spawnflags) && vehicles[i].spawnflags & 1)
			playerdrivablevehicles[playerdrivablevehicles.size] = vehicles[i];
		else
			allvehiclesprespawn[allvehiclesprespawn.size] = vehicles[i];

		if(!isdefined(level.vehicleInitThread[vehicles[i].vehicletype]))
			level.vehicleInitThread[vehicles[i].vehicletype] = [];

				
		loadstring = "maps\\\_"+vehicles[i].vehicletype+"::main(\""+vehicles[i].model+"\");";
		
		if(level.bScriptgened)
			script_gen_dump_addline(loadstring,vehicles[i].model);  // adds to scriptgendump using model as signature for lookup
		
		precachesetup(loadstring,vehicles[i]);
		
	}

	if(!level.bScriptgened && level.needsprecaching.size > 0)
	{
		println("----------------------------------------------------------------------------------");
		println("----------------------------------------------------------------------------------");
		println("-----add these lines to your level script above maps\\\_load::main();-------------");
		for(i=0;i<level.needsprecaching.size;i++)
			println(level.needsprecaching[i]);
		println("----------------------------------------------------------------------------------");
		println("-------------------------hint copy paste them from console.log--------------------");
		println("----if it already exists then check for unmatching vehicletypes in your map ------");
		println("----------------------------------------------------------------------------------");
		assertEX(false,"missing vehicle scripts, see above console prints");
		level waittill ("never");
	}

	if(playerdrivablevehicles.size > 0)
		thread maps\_vehicledrive::main(); //precache driveable vehicle huds and such.
	return allvehiclesprespawn;
}

precachesetup (string,vehicle)
{
	if(isdefined(level.vehicleInitThread[vehicle.vehicletype][vehicle.model]))
		return;
	matched = false;
	for(i=0;i<level.needsprecaching.size;i++)
		if(level.needsprecaching[i] == string)
			matched = true;	
	if(!matched)
		level.needsprecaching[level.needsprecaching.size] = string;
}


vehicle_modelinarray ( arrayofmodels, model )
{
	for(i=0;i<arrayofmodels.size;i++)
		if(arrayofmodels[i] == model)
			return true;
	return false;
}

disconnect_paths_whenstopped ()
{
	self endon ("death");
	wait (randomfloat(1));
	while (isdefined (self) && issentient(self) )
	{
		if(self getspeed() < 1)
		{
			self disconnectpaths();
			while(self getspeed() < 1)
				wait .05;
		}
		self connectpaths();
		wait 1;
	}
}


// this is a big hack job at making tanks "form a squad" on their paths. 
// I'm not going to bother with this stuff unless a new sequence in the 
// game requires vehicles to be dynamic in a squad

squad ()
{
	self.tanksquadfollow = false;
	self endon ("death");
	while(1)
	{
		level waittill ("form squad", leader);
		foundsquad = false;
		attachedpath = self.attachedpath;
//		println("attachedpath = ",attachedpath);
//		println("self targetname = ",self.targetname);
		squadnodes = undefined;
		if(!isdefined(attachedpath.squadnodes))
		{
			node = attachedpath;
			while(isdefined(node))
			{
				node = getvehiclenode(node.targetname,"target");
				if(isdefined(node) && isdefined(node.squadnodes))
				{
					squadnodes = node.squadnodes;
					break;
				}
			}
		}
		else
			squadnodes = attachedpath.squadnodes;

		squadposition = undefined;
		if(self == leader)
		{
			continue;
		}
		squad = leader.node.script_vehiclesquad;
		if(!isdefined(squadnodes[squad]))
		{
			println("can't find squadnodes for path with node: ",self.attachedpath.targetname);	
			return;
			
		}
		self.squad = squad;
		if(!isdefined(squad))
		{
			println("can't find squad for path with node: ",leader.node);	
			println("can't find squad for path with node targetname: ",leader.node.targetname);	
			return;
		}		
		for(i=0;i<squadnodes[squad].size;i++)
		{
			squadposition = squadnodes[squad][i].squadposition;
			path_gate_open(squadnodes[squad][i]);
			foundsquad = true;
		}
		if(!foundsquad)
			continue;
		self notify ("breaksquad");
		thread squad_follow(squadposition,leader,squad);
	}
}

squad_follow (squadposition, leader,squad)
{
	self.tanksquadfollow = true; 
	squadposition.angles = leader.angles;
	squadposition linkto(leader,"tag_body");
	self endon ("breaksquad");
	self endon ("death");
	leader endon ("death");
	thread squad_deleteoriginonbreaksquad(squadposition);
	maxspeed = 34; // for testing and Libya should go somewhere else (like in vehiclesettings.gdt)
	mindist = 300; // distance to try and be within from the tank
	maxdist = 1000; // distance at which tank will drive at it's maxspeed to catch up
	self.avoidresumespeed = 5;
	rangedist = maxdist-mindist;
	level.vehicle_squadfollowdelay+= .05;
	if(level.vehicle_squadfollowdelay > 1)
		level.vehicle_squadfollowdelay = 0;
	wait level.vehicle_squadfollowdelay;

	check_delay = 1;
	while(1)
	{
		if(leader.health <= 0)
			break;
		leaderspeed = leader getspeedmph();
		if(leaderspeed < 10)
		{
			leaderspeed = 10; // tanks will go untill they get passed the squadposition
		}
		rangespeed = (maxspeed - leaderspeed);
		dist = distance(self.origin,squadposition.origin);
		if(self.avoiding)
		{
			msg = "avoiding colision";
			speed = 0;
			thread squad_debugline(squadposition,0,1,1,speed,msg,leader);
			
			wait check_delay;
			continue;
		}
		forwardvec = anglestoforward(flat_angle(squadposition.angles));
		normalvec = vectorNormalize(self.origin-squadposition.origin);
		vectordotup = vectordot(forwardvec,normalvec);
		if(vectordotup > 0)
		{
			speed = 0;
			msg = "ahead of position";
			self vehicle_setspeed(speed,15,"squad: "+msg);

			thread squad_debugline(squadposition,1,0,0,speed,msg,leader);
		}
		else if(dist < mindist)
		{
			speed = leaderspeed;
			msg = "matching speed";
			self vehicle_setspeed(speed,15,"squad: "+msg);
			thread squad_debugline(squadposition,1,1,0,speed,msg,leader);
		
		}
		else if(dist > mindist && dist < maxdist)
		{
			speed = ( ( (dist-mindist)/rangedist)   *   (maxspeed-rangespeed) )+leaderspeed;
			msg = "speeding up";
			self vehicle_setspeed(speed,15,"squad: "+msg);
			thread squad_debugline(squadposition,1,1,0,speed,msg,leader);

		}
		else if (dist > maxdist)
		{
			msg = "fullspeed";
			speed = maxspeed;
			self vehicle_setspeed(speed,15,"squad: "+msg);
			thread squad_debugline(squadposition,0,1,0,speed,msg,leader);
		}		
		wait check_delay;
	}
	script_resumespeed("squade leader dead",level.vehicle_ResumeSpeed);
}

squad_deleteoriginonbreaksquad (origin)
{
	self waittill ("breaksquad");
	origin delete();	
}

squad_leader (triggernode)
{
	self endon ("death");
	self endon ("breaksquad");
	squad = triggernode.script_vehiclesquad;
	level.squadspeed[squad] = self getspeedmph();
	self.node = triggernode;
	level notify ("form squad", self);
	println("level notified squad form");
	self.squad = squad;
	self.tanksquadfollow = true; 
	thread squad_debugline(self,1,1,1,self getspeedmph(),"leading the squad",self);
	speedpolltime = 500; //ms
	speedpolltimer = gettime()+speedpolltime;
	catchingup = false;
	maxspeed = 31;
	trailingposition = spawn("script_origin",(0,0,0));
	fartrailingposition = spawn("script_origin",(0,0,0));
	backwardvec = vector_multiply(anglestoforward((self.angles[0],self.angles[1]+180,self.angles[2])),1000);
	farbackwardvec = vector_multiply(anglestoforward((self.angles[0],self.angles[1]+180,self.angles[2])),2100);
	trailingposition.origin = self.origin+backwardvec;
	fartrailingposition.origin = self.origin+farbackwardvec;
	trailingposition.angles = self.angles;
	fartrailingposition.angles = self.angles;
	trailingposition linkto (self);
	fartrailingposition linkto (self);
	thread squad_deleteoriginonbreaksquad(trailingposition);
	thread squad_deleteoriginonbreaksquad(fartrailingposition);
	lastaction = "catchingup";
	while(1)
	{
		forwardvec = anglestoforward(self.angles);
		normalvec = vectorNormalize(level.player.origin-trailingposition.origin);
		vectordotup = vectordot(forwardvec,normalvec);
		if(vectordotup > 0)
		{
			if(lastaction != "catchingup")
			{
				lastaction = "catchingup";
				self vehicle_setspeed(maxspeed,7,"squad leader: catching up to player");
				
			}
			level notify ("player ahead of squad"); // so level script can know that the player is ahead of the squad for too long.
			
		}
		else
		{
			forwardvec = anglestoforward(self.angles);
			normalvec = vectorNormalize(level.player.origin-fartrailingposition.origin);
			vectordotup = vectordot(forwardvec,normalvec);
			if(vectordotup > 0)
			{
				if(lastaction != "resuming")
				{
					lastaction = "resuming";
					script_resumespeed("squad leader: caught up to player",10);
				}
			}
			else
			{
				if(lastaction != "waiting")
				{
					lastaction = "waiting";
					self vehicle_setspeed(4,7,"squad leader: slowing down for player");
				}
			}
		}
		level.squadspeed[squad] = self getspeedmph();
		wait .4;
	}
	
}

squad_debugline (ent_end,r,g,b,speed,msg,leader)
{
	/#
	self notify ("new line");
	self endon ("new line");
	while(1)
	{
		while(getdvar("debug_vehiclesquad") != "off")
		{
			print3d(self.origin,"speed: "+speed, (r,g,b),1,3);
			print3d(self.origin+(0,0,64),"realspeed: "+self getspeedmph(), (r,g,b),1,3);
			print3d(self.origin+(0,0,128),"vehicle_squad status: "+msg, (r,g,b),1,3);
			line(self.origin,ent_end.origin,(r,g,b),1);
			wait .05;
		}
		wait .2;
	}
	#/
}

vehicle_setspeed (speed,rate,msg)
{
	if(self getspeedmph() ==  0 && speed == 0)
		return;  //potential for disaster? keeps messages from overriding previous messages
	self thread debug_vehiclesetspeed(speed,rate,msg);
	if(speed == 0)
		self.zerospeed = true;
	else
		self.zerospeed = false;
	println( msg );
	self setspeed( speed, rate );
}

debug_vehiclesetspeed ( speed, rate, msg )
{
	/#
	self notify ("new debug_vehiclesetspeed"); 
	self endon ("new debug_vehiclesetspeed"); 
	self endon ("resuming speed");
	self endon ("death");
	while(1)
	{
		while(getdvar("debug_vehiclesetspeed") != "off")
		{
			print3d(self.origin+(0,0,192),"vehicle setspeed: "+msg, (1,1,1),1,3);
			wait .05;
		}
		wait .5;
	}
	#/
}
	
script_resumespeed ( msg, rate )
{
	self endon ("death");
	fSetspeed = 0;
	type = "resumespeed";
	if(!isdefined(self.resumemsgs))
		self.resumemsgs = [];
	if(isdefined(self.waitingforgate) && self.waitingforgate)
		return; // ignore resumespeeds on waiting for gate.
		
	if(isdefined(self.attacking))
	{
		if(self.attacking)
		{
			fSetspeed = self.attackspeed;
			type = "setspeed";
		} 
	}		

	self.zerospeed = false;
	if(fSetspeed == 0)
		self.zerospeed = true;
	if(type == "resumespeed")
		self resumespeed(rate);
	else if (type == "setspeed")
		self vehicle_setspeed(fSetspeed,15,"resume setspeed from attack");
	self notify ("resuming speed");
	self thread debug_vehicleresume(msg+" :"+type);
	
}

debug_vehicleresume (msg)
{
	if(getdvar("debug_vehicleresume") == "off")
		return;
	self endon ("death");
	number = self.resumemsgs.size;
	self.resumemsgs[number] = msg;
	timer = 3;
	self thread print_resumespeed(gettime()+(timer*1000));
	
	wait timer;
	newarray = [];
	for(i=0;i<self.resumemsgs.size;i++)
	{
		if(i != number)
			newarray[newarray.size] = self.resumemsgs[i];
	}
	self.resumemsgs =  newarray;
}

print_resumespeed (timer)
{
	self notify ("newresumespeedmsag");
	self endon ("newresumespeedmsag");
	self endon ("death");
	while(gettime() < timer && isdefined(self.resumemsgs))
	{
		if(self.resumemsgs.size> 6)
			start = self.resumemsgs.size-5;
		else
			start = 0;
		for(i=start;i<self.resumemsgs.size;i++)  // only display last 5 messages
		{
			position = i*32;
			print3d(self.origin+(0,0,position),"resuming speed: "+self.resumemsgs[i], (0,1,0),1,3);
		}
		wait .05;
	}	
}

vclogin_vehicles ()
{
	if (getdvar("vclogin_vehicles") == "off")
		return;
	precachemodel("vehicle_blackhawk");
	level.vclogin_vehicles = 1;
//	paths = level.vehicle_startnodes;
	vehicles = getentarray("script_vehicle","classname");
	for(i=0;i<vehicles.size;i++)
		vehicles[i] delete();

	paths = getallvehiclenodes();
	
	for(i=0;i<paths.size;i++)
	{
		if(!(isdefined(paths[i].spawnflags)&& (paths[i].spawnflags & 1)))
			continue;
		crashtype = paths[i].script_crashtype;
		if(!isdefined(crashtype))
			crashtype = "default";
		if(crashtype == "plane")
			vehicle = spawnVehicle( "vehicle_blackhawk", "vclogger", "blackhawk" ,(0,0,0), (0,0,0) );
		else
			vehicle = spawnVehicle( "vehicle_blackhawk", "vclogger", "blackhawk" ,(0,0,0), (0,0,0) );
		vehicle attachpath(paths[i]);
		
		if(isdefined(vehicle.model) && vehicle.model == "vehicle_blackhawk")
		{
			tagorg = vehicle gettagorigin("tag_bigbomb");	
			level.player setorigin (tagorg);
			level.player playerLinkTodelta (vehicle, "tag_bigbomb", 1.0);
		}
		else
		{
			tagorg = vehicle gettagorigin("tag_player");
			level.player setorigin (tagorg);
			level.player playerLinkToDelta (vehicle, "tag_player", 0.1);
		}
		

		vehicle startpath();
		vehicle.zerospeed = false;
//		vehicle setspeed (100,50);
		vehicle waittill ("reached_end_node");
		level.player unlink();
		vehicle delete();
		crashtype = undefined;
	}
	level waittill ("never");  // map needs to be restarted at this point
}

path_gate_deathwait(node)
{
	level waittill ("deathgate_open"+node.script_vehicledeathgate);
	path_gate_open(node);	
}

forcekill()
{
	radiusDamage (self.origin+(0,0,50), 30, 20000, 20000);
}

godon ()
{
	self.godmode = true;
}

godoff ()
{
	self.godmode = false;	
}

path_vehicledeathswitch(node)
{
	node.scriptOverride = true;
	level waittill ("script_vehicledeathswitch"+node.script_vehicledeathswitch);
	node.scriptOverride = false;
}

trigger_disable()
{
	level waittill ("disabletriggers"+self.script_vehicledisabletrigger);
	self notify ("disabletrigger");
}


getTurnStrength()
{
	assertEX(isdefined(self.lastangles),"self.lastangles not getting set");
	
	currentAngle = self.angles[1];
	oldAngle = self.lastangles;
	
	change = (oldAngle - currentAngle);
	
	while (change <= -360)
		change += 360;
	
	return change;
}

setturretfireondrones(b)
{
	if(isdefined(self.mgturret) && self.mgturret.size)
		for(i=0;i<self.mgturret.size;i++)
			self.mgturret[i].script_fireondrones = b;
}

animate_drive_idle()
{
	model = self.model;
	if(!isdefined(level.vehicle_DriveIdle[model]))
		return;
	self endon ("death");
	self UseAnimTree(level.vehicleanimtree[model]);
	normalspeed = level.vehicle_DriveIdle_normal_speed[model];
	

	
	thread animate_drive_idle_death();
	

	animrate = 1.0;
	if ( ( isdefined( level.vehicle_DriveIdle_animrate ) ) && ( isdefined( level.vehicle_DriveIdle_animrate[model] ) ) )
		animrate = level.vehicle_DriveIdle_animrate[model];

	while(1)
	{
		if(self.modeldummyon)
		{
			animatemodel = self.modeldummy;
			animatemodel UseAnimTree(level.vehicleanimtree[model]);
		}
		else
			animatemodel = self;

		if(!normalspeed)
		{
				//vehicles like helicopters always play the same rate. will come up with better design if need arises.
				
				animatemodel setanim(level.vehicle_DriveIdle[model],1,.2,animrate);
				thread animtimer ( .5);
				self waittill ("animtimer");
				continue;
		}
		speed = self getspeedmph();
		
		if(speed == 0 )
			animatemodel clearanim(level.vehicle_DriveIdle[model],0);
		else
			animatemodel setanim(level.vehicle_DriveIdle[model],1,.2,speed/normalspeed);
			thread animtimer ( .5);
			self waittill ("animtimer");
	}
}

animtimer ( time )
{
	self endon ( "animtimer" );
	wait time;
	self notify ( "animtimer" );
}

animate_drive_idle_death()
{
	model = self.model;
	self UseAnimTree(level.vehicleanimtree[model]);
	self waittill ("death");
	if(isdefined(self))
		self clearanim(level.vehicle_DriveIdle[model],0);
}

setup_origins()
{
	triggers = [];
	origins = getentarray("script_origin","classname");
	for(i=0;i<origins.size;i++)
	{
		if(isdefined(origins[i].script_unload))
			triggers[triggers.size] = origins[i];
		if(isdefined(origins[i].script_vehicledetour))
		{
			
			level.vehicle_detourpaths = array_2dadd(level.vehicle_detourpaths,origins[i].script_vehicledetour,origins[i]);
			if(level.vehicle_detourpaths[origins[i].script_vehicledetour].size > 2)
				println("more than two script_vehicledetour grouped in group number: ",origins[i].script_vehicledetour);
			
			prevnode = getent(origins[i].targetname,"target");	
			assertex(isdefined(prevnode),"detour can't be on start node");
			triggers[triggers.size] = prevnode;
			prevnode.detoured = 0;
			prevnode = undefined;

/*			
			paths[count-2].detoured = 0;
			if(isdefined(pathpoint.script_vehicledisabletrigger))
				paths[count-2].script_vehicledisabletrigger = pathpoint.script_vehicledisabletrigger;
*/			
			
		}
		if( isdefined( origins[ i ].script_attackorgs ) )
		{
			if( !isdefined( level.vehicle_attackorgs[ origins[ i ].script_attackorgs ] ) )
			{
				if( isdefined( origins[ i ].targetname ) )
					origins[ i ].triggertarget = getent( origins[ i ].targetname, "target" );
				level.vehicle_attackorgs[ origins[ i ].script_attackorgs ] = [];
			}
			
			size = level.vehicle_attackorgs[ origins[i].script_attackorgs].size;
			level.vehicle_attackorgs[ origins[ i ].script_attackorgs ][ size ] = origins[ i ];
			
			setup_attackorg_chain( origins[ i ] );
		}
	}
	return triggers;
}

setup_ai()
{
	ai = getaiarray();
	for(i=0;i<ai.size;i++)
	{
		if(isdefined(ai[i].script_vehicleride))
			level.vehicle_RideAI = array_2dadd(level.vehicle_RideAI,ai[i].script_vehicleride,ai[i]);
		else
		if(isdefined(ai[i].script_vehiclewalk))
			level.vehicle_WalkAI = array_2dadd(level.vehicle_WalkAI,ai[i].script_vehiclewalk,ai[i]);
	}
	ai = getspawnerarray();

	for(i=0;i<ai.size;i++)
	{
		if(isdefined(ai[i].script_vehicleride))
			level.vehicle_RideSpawners = array_2dadd(level.vehicle_RideSpawners,ai[i].script_vehicleride,ai[i]);
		if(isdefined(ai[i].script_vehiclewalk))
			level.vehicle_walkspawners = array_2dadd(level.vehicle_walkspawners,ai[i].script_vehiclewalk,ai[i]);
	}	
}

array_2dadd(array,firstelem,newelem)
{
	if(!isdefined(array[firstelem]))
		array[firstelem] = [];
	array[firstelem][array[firstelem].size] = newelem;
	return array;
}

setup_triggers()
{
	// TODO: move this to _load under the triggers section.  larger task than this simple cleanup.
	
	// the processtriggers array is all the triggers and vehicle node triggers to be put through
	// the trigger_process function.   This is so that I only do a waittill trigger once 
	// in script to assure better sequencing on a multi-function trigger.
	
	// some of the vehiclenodes don't need to waittill trigger on anything and are here only 
	// for being linked with other trigger
	
	processtriggers = [];
	pathnodes = getallvehiclenodes();
	
	for(i=0;i<pathnodes.size;i++)
	{
		processtrigger = false;
		
		// for forcing a trigger to be processed.. this is used when a certain
		// association needs to designate one vehicle node as the trigger node
		if(isdefined(pathnodes[i].script_noteworthy))
		{
			if
			(
				pathnodes[i].script_noteworthy == "trigger" 	||
				pathnodes[i].script_noteworthy == "godon" 	||
				pathnodes[i].script_noteworthy == "forcekill"||
				pathnodes[i].script_noteworthy == "godoff"
			)
			processtrigger = true;
		}
			
			
		// special treatment for start nodes	
		if(isdefined(pathnodes[i].spawnflags)&& (pathnodes[i].spawnflags & 1))
		{
			if(isdefined(pathnodes[i].script_crashtype))
				level.vehicle_crashpaths[level.vehicle_crashpaths.size] = pathnodes[i];
			level.vehicle_startnodes[level.vehicle_startnodes.size] = pathnodes[i];
		}
		
		if(isdefined(pathnodes[i].script_vehicledetour))
		{
			level.vehicle_detourpaths = array_2dadd(level.vehicle_detourpaths,pathnodes[i].script_vehicledetour,pathnodes[i]);
			if(level.vehicle_detourpaths[pathnodes[i].script_vehicledetour].size > 2)
				println("more than two script_vehicledetour grouped in group number: ",pathnodes[i].script_vehicledetour);
		}
		
		if(isdefined(pathnodes[i].script_linkname))
			level.vehicle_linkedpaths[level.vehicle_linkedpaths.size] = pathnodes[i];
		
		//crazy vehiclesquad stuff used for keeping tanks in formation on CoD2's Libya and 88ridge.  Not sure that we'll use this stuff in the next game.
		if(isdefined(pathnodes[i].script_vehiclesquad))
		{
			if(isdefined(pathnodes[i].script_vehiclesquadleader))
			{
				level.VehicleSquadLeaderPosition[pathnodes[i].script_vehiclesquad] = pathnodes[i];
				processtrigger = true;
			}
		}
		
		// if a gate isn't open then the vehicle will stop there and wait for it to become open.
		if(isdefined(pathnodes[i].script_gatetrigger))
		{
			level.vehicle_gatetrigger = array_2dadd(level.vehicle_gatetrigger,pathnodes[i].script_gatetrigger,pathnodes[i]);
			pathnodes[i].gateopen = false;
		}
		
		// a vehicle node will have a closed gate untill its associated vehicle is killed.	
		if(isdefined(pathnodes[i].script_vehicledeathgate))
		{
			pathnodes[i].gateopen = false;
			thread path_gate_deathwait(pathnodes[i]);
		}
		
		if(isdefined(pathnodes[i].script_vehicledeathswitch))
			thread path_vehicledeathswitch(pathnodes[i]);
			
		//various nodes that will be sent through trigger_process
		if
		(
			isdefined(pathnodes[i].script_VehicleAttackgroup) 	||
			isdefined(pathnodes[i].script_VehicleSpawngroup)		||
			isdefined(pathnodes[i].script_VehicleStartMove)		||
			isdefined(pathnodes[i].script_Vehiclegroupdelete)		||
			isdefined(pathnodes[i].script_vehiclefocusfiregroup)	||
			isdefined(Pathnodes[i].script_turret)				||
			isdefined(Pathnodes[i].script_attackorgs)			||
			isdefined(pathnodes[i].script_crashtypeoverride)		||
			isdefined(pathnodes[i].script_badplace)				||
			isdefined(pathnodes[i].script_attackspeed)			||
			isdefined(pathnodes[i].script_turretmg)				||
			isdefined(pathnodes[i].script_shots)				||
			isdefined(pathnodes[i].script_accuracy)				||
			isdefined(pathnodes[i].script_deathroll)			||
			isdefined(pathnodes[i].script_attackai)				||
			isdefined(pathnodes[i].script_avoidvehicles)			||
			isdefined(pathnodes[i].script_vehicleaianim)			||
			isdefined(pathnodes[i].script_turningdir)			||
			isdefined(pathnodes[i].script_vehicledeathgate)		||
			isdefined(pathnodes[i].script_exploder)		||
			isdefined(pathnodes[i].script_unload)		||
			isdefined(pathnodes[i].script_noteworthy)
		)
			processtrigger = true;

		if(processtrigger)
		{
			pathnodes[i].processtrigger = true;
			processtriggers[processtriggers.size] = pathnodes[i];
		}
	}
	
	for(i=0;i<level.vehicle_startnodes.size;i++)
	{
		detourpaths = [];
		detourpaths = vehicle_paths_setup(level.vehicle_startnodes[i]);
		if(detourpaths.size)
			for(j=0;j<detourpaths.size;j++)
			{
				if(!isdefined(detourpaths[j].processtrigger))
					processtriggers[processtriggers.size] = detourpaths[j];
				detourpaths[j].processtrigger = undefined;	
			}
	}

	VehicleAttackgroup = [];
	VehicleSpawngroup = [];
	VehicleStartMove = [];
	vehicleGroupDelete = [];
	nonplayervehicles = [];
	triggers = array_combine(getentarray("trigger_multiple","classname"),getentarray("trigger_radius","classname"));
	triggers = array_combine(triggers,getentarray("trigger_lookat","classname"));
	for(i=0;i<triggers.size;i++)
	{
		if
		(
		isdefined(triggers[i].script_VehicleAttackgroup) 		||
		isdefined(triggers[i].script_VehicleSpawngroup)		||
		isdefined(triggers[i].script_VehicleStartMove)		||
		isdefined(triggers[i].script_vehicleGroupDelete)		||
		isdefined(triggers[i].script_vehiclefocusfiregroup)	||
		isdefined(triggers[i].script_gatetrigger)			||
		isdefined(triggers[i].detoured)					||
		isdefined(triggers[i].script_attackorgs)			||
		isdefined(triggers[i].script_vehicledisabletrigger)

		)
		processtriggers[processtriggers.size] = triggers[i];
	}	
	return processtriggers;
}

setup_vehicles ()
{
	vehicles = getentarray("script_vehicle","classname");
	vehicles = array_combine(vehicles,getentarray("vehiclespawnmodel","targetname"));
	spawnvehicles = [];
	groups = [];
	nonspawned = [];
	
	for(i=0;i<vehicles.size;i++)
	{
		if(isdefined(vehicles[i].script_vehiclespawngroup))
		{
			if(!isdefined(spawnvehicles[vehicles[i].script_vehiclespawngroup]))
				spawnvehicles[vehicles[i].script_vehiclespawngroup] = [];
				
			spawnvehicles[vehicles[i].script_vehiclespawngroup]
			[spawnvehicles[vehicles[i].script_vehiclespawngroup].size] = vehicles[i];
			addgroup[0] = vehicles[i].script_vehiclespawngroup;
			groups = array_merge(groups,addgroup);
			continue;
		}
		else
			nonspawned[nonspawned.size] = vehicles[i];
	}
	
	for(i=0;i<groups.size;i++)
		thread spawner_setup(spawnvehicles[groups[i]],groups[i],"main");

	//init vehicles that aren't spawned
	for(i=0;i<nonspawned.size;i++)
		thread vehicle_init(nonspawned[i]);	
}

vehicle_life ()
{
	type = self.vehicletype;
	assertEX(isdefined(level.vehicle_life[type]), "need to specify level.vehicle_life[type] in vehicle script for vehicletype: "+type);

	
	if (isdefined (self.script_startinghealth))
		self.health = self.script_startinghealth;
	else
	{
		if(level.vehicle_life[type] == -1)
			return;
		else if(isdefined(level.vehicle_life_range_low[type]) && isdefined(level.vehicle_life_range_high[type]))
			self.health  = (randomint(level.vehicle_life_range_high[type]-level.vehicle_life_range_low[type])+level.vehicle_life_range_low[type]);
		else 
			self.health = level.vehicle_life[type];
	}

	if( isDefined( level.destructible_model ) && isDefined( level.destructible_model[ self.model ] ) )
	{
		self.destructible_type = level.destructible_model[ self.model ]; 
		self maps\_destructible::setup_destructibles();// true );
	}
}

mginit ()
{
	type = self.vehicletype;
	if( ((isdefined(self.script_nomg)) && (self.script_nomg > 0)) )
		return;
	
	if( ( !self isHelicopter() ) && ( isdefined(level.vehicle_mgturret[type]) ) )
	{
		mgangle = 0;
		if(isdefined(self.script_mg_angle))
			mgangle = self.script_mg_angle;
		for (i=0;i<level.vehicle_mgturret[type].size;i++)
		{
			self.mgturret[i] = spawnTurret("misc_turret", (0,0,0), level.vehicle_mgturret[type][i].info);
			self.mgturret[i] linkto(self, level.vehicle_mgturret[type][i].tag, (0, 0, 0), (0, -1*mgangle, 0));
			self.mgturret[i] setmodel(level.vehicle_mgturret[type][i].model);
			self.mgturret[i].angles = self.angles;
			self.mgturret[i].isvehicleattached = true; // lets mgturret know not to mess with this turret
			
//			if(isdefined(self.script_mg_angle))
//				self.mgturret[i].angles = self.angles - (0,mgangle,0); // sets attach angle,  might have to do something nicer than this
			self.mgturret[i] thread maps\_mgturret::burst_fire_unmanned();
			self.mgturret[i] maketurretunusable();
			level thread maps\_mgturret::mg42_setdifficulty(self.mgturret[i],getdifficulty());
			if(isdefined(self.script_fireondrones))
				self.mgturret[i].script_fireondrones = self.script_fireondrones;
			self.mgturret[i] setshadowhint ("never");
			if(isdefined(level.vehicle_mgturret[type][i].defaultOFFmode))
				self.mgturret[i] setmode(level.vehicle_mgturret[type][i].defaultOFFmode);
			if(isdefined(level.vehicle_mgturret[type][i].maxrange))
				self.mgturret[i].maxrange = level.vehicle_mgturret[type][i].maxrange;
			if(isdefined(self.script_noteworthy) && self.script_noteworthy == "onemg")
					break;		
		}
	}
	
	if ( isdefined (self.script_turretmg) && self.script_turretmg == 0 )
		self thread mgoff();
	else
	{
		self.script_turretmg = 1;
		self thread mgon();
	}
	self thread mgtoggle();
}

mgtoggle()
{
	self endon ("death");
	if(self.script_turretmg)
		lasttoggle = 1;
	else
		lasttoggle = 0;
	while(1)
	{
		if(lasttoggle != self.script_turretmg)
		{
			lasttoggle = self.script_turretmg;
			if(self.script_turretmg)
				self thread mgon();
			else
				self thread mgoff();
		}
		wait .5;
	}
}

mgoff ()
{
	type = self.vehicletype;
	self.script_turretmg = 0;  // fix me.. defense for scripts using mgoff();
	
	if ( ( self isHelicopter() ) && ( self hasHelicopterTurret() ) )
	{
		self thread chopper_Turret_Off();
		return;
	}
	
	if (!isdefined (self.mgturret))
		return;
	for (i=0;i<self.mgturret.size;i++)
	{
		if(isdefined(self.mgturret[i].script_fireondrones))
			self.mgturret[i].script_fireondrones = false;
		if(isdefined(level.vehicle_mgturret[type][i].defaultOFFmode))
			self.mgturret[i] setmode(level.vehicle_mgturret[type][i].defaultOFFmode);
		else
			self.mgturret[i] setmode("manual");
	}
}

mgon ()
{
	type = self.vehicletype;
	self.script_turretmg = 1; // fix me.. defense for scripts using mgon();
	
	if ( ( self isHelicopter() ) && ( self hasHelicopterTurret() ) )
	{
		self thread chopper_Turret_On();
		return;
	}
	
	if (!isdefined (self.mgturret))
		return;
	for (i=0;i<self.mgturret.size;i++)
	{
		if(isdefined(self.mgturret[i].script_fireondrones))
			self.mgturret[i].script_fireondrones = true;
		if(isdefined(level.vehicle_mgturret[type][i].defaultONmode))
			self.mgturret[i] setmode(level.vehicle_mgturret[type][i].defaultONmode);
		else
			self.mgturret[i] setmode("auto_nonai");
		if ( (self.script_team == "allies") || (self.script_team == "friendly") )
			self.mgturret[i] setTurretTeam("allies");
		else if ( (self.script_team == "axis") || (self.script_team == "enemy") )
			self.mgturret[i] setTurretTeam("axis");
	}
}

isHelicopter()
{
	if ( !isdefined( self.vehicletype ) )
		return false;
	if ( self.vehicletype == "blackhawk" )
		return true;
	if ( self.vehicletype == "apache" )
		return true;
	if ( self.vehicletype == "seaknight" )
		return true;
	if ( self.vehicletype == "hind" )
		return true;
	if ( self.vehicletype == "cobra" )
		return true;
	if ( self.vehicletype == "cobra_player" )
		return true;
	return false;
}

hasHelicopterTurret()
{
	if ( !isdefined( self.vehicletype ) )
		return false;
	if ( self.vehicletype == "cobra" )
		return true;
	if ( self.vehicletype == "cobra_player" )
		return true;
	return false;
}

Chopper_Turret_On()
{
}

chopper_Turret_Off()
{
	self notify( "mg_off" );
}

playLoopedFxontag ( effect, durration, tag )
{
	effectorigin = spawn("script_origin",self.origin);
	self endon ("fire_extinguish");
	thread playLoopedFxontag_originupdate(tag,effectorigin);
	while(1)
	{
		playfx(effect,effectorigin.origin,effectorigin.upvec);
		wait durration;		
	}
}

playLoopedFxontag_originupdate ( tag,effectorigin )
{
	effectorigin.angles = self gettagangles(tag);
	effectorigin.origin  = self gettagorigin(tag);
	effectorigin.forwardvec = anglestoforward(effectorigin.angles);
	effectorigin.upvec = anglestoup(effectorigin.angles);
	while(isdefined(self) && self.classname == "script_vehicle" && self getspeedmph() > 0)
	{
		effectorigin.angles = self gettagangles(tag);
		effectorigin.origin  = self gettagorigin(tag);
		effectorigin.forwardvec = anglestoforward(effectorigin.angles);
		effectorigin.upvec = anglestoup(effectorigin.angles);
		wait .05;
	}
}

build_turret ( array , info, tag, model, bAicontrolled, maxrange, defaultONmode ,defaultOFFmode )
{
	precachemodel(model);
	precacheturret(info);
	if(!isdefined(array))
		array = [];
	struct = spawnstruct();
	struct.info = info;
	struct.tag = tag;
	struct.model = model;
	struct.bAicontrolled = bAicontrolled;
	struct.maxrange = maxrange;
	struct.defaultONmode = defaultONmode;
	struct.defaultOFFmode = defaultOFFmode;
	array[array.size] = struct;
	return array;
}


setup_dvars()
{
	if (getdvar("vclogin_vehicles") == "")
		setdvar("vclogin_vehicles", "off");
	if (getdvar("debug_vehiclesquad") == "")
		setdvar("debug_vehiclesquad", "off");
	if (getdvar("debug_vehicleresume") == "")
		setdvar("debug_vehicleresume", "off");
	if (getdvar("debug_vehicleavoid") == "")
		setdvar("debug_vehicleavoid", "off");
	if (getdvar("debug_vehicleturretaccuracy") == "")
		setdvar("debug_vehicleturretaccuracy", "off");
	if (getdvar("debug_vehicledetour") == "")
		setdvar("debug_vehicledetour", "off");
	if (getdvar("debug_vehiclefocusfire") == "")
		setdvar("debug_vehiclefocusfire", "off");
	if (getdvar("debug_vehicleattackthreats") == "")
		setdvar("debug_vehicleattackthreats", "off");
	if (getdvar("debug_vehiclesetspeed") == "")
		setdvar("debug_vehiclesetspeed", "off");
	if (getdvar("debug_vehiclesittags") == "")
		setdvar("debug_vehiclesittags", "off");
	
}

setup_levelvars()
{
	level.vehicle_ResumeSpeed = 5;
//	level.vehicle_turretfiretime = 4;
	level.vehicle_DeleteGroup = [];
	level.vehicle_FocusFireGroup = [];
	level.vehicle_AttackGroup = [];
	level.vehicle_SpawnGroup = [];
	level.vehicle_StartMoveGroup = [];
	level.vehicle_DeathGate = [];
	level.vehicle_RideAI =  [];
	level.vehicle_DroneNodeTime = [];
	level.vehicle_DroneNodeTime_last = [];
	level.vehicle_WalkAI =  [];
	level.vehicle_DeathSwitch = [];
	level.vehicle_RideSpawners = [];
	level.vehicle_walkspawners = [];
	level.vehicle_gatetrigger = [];
	level.vehicle_crashpaths = [];
	level.vehicle_target = [];
	level.vehicle_link = [];
	level.vehicle_avoiddelay = 0;
	level.vehicle_attackthreatsdelay = 0;
	level.vehicle_detourpaths = [];
	level.vehicle_squadfollowdelay = 0;
	level.vehicle_attackorgs = [];
	level.vehicle_linkedpaths = [];
	level.vehicle_startnodes = [];
	
	level.vclogin_vehicles = 0;
	level.vehicle_threats = [];
	level.playervehicle = spawn ("script_origin",(0,0,0)); // no isdefined for level.playervehicle 
	level.playervehiclenone = level.playervehicle; // no isdefined for level.playervehicle 	
	level.vehicles = [];	// will contain all the vehicles that are spawned and alive
	level.vehicles["allies"] = [];
	level.vehicles["axis"] = [];
	
	if(!isdefined(level.vehicle_team))
		level.vehicle_team = [];
	if(!isdefined(level.vehicle_deathmodel))
		level.vehicle_deathmodel = [];
	if(!isdefined(level.vehicle_death_thread))
		level.vehicle_death_thread = [];
	if(!isdefined(level.vehicle_DriveIdle))
		level.vehicle_DriveIdle = [];
	if(!isdefined(level.attack_origin_condition_threadd))
		level.attack_origin_condition_threadd = [];
	if(!isdefined(level.vehiclefireanim))
		level.vehiclefireanim = [];
	if(!isdefined(level.vehiclefireanim_settle))
		level.vehiclefireanim_settle = [];
	if(!isdefined(level.vehicle_hasname))
		level.vehicle_hasname = [];
	if(!isdefined(level.vehicle_walkercount))
		level.vehicle_walkercount = [];
	if(!isdefined(level.vehicle_unloadonuse))
		level.vehicle_unloadonuse = [];
	if(!isdefined(level.vehicle_turret_requiresrider))
		level.vehicle_turret_requiresrider = [];
	if(!isdefined(level.vehicle_rumble))
		level.vehicle_rumble = [];
	if(!isdefined(level.vehicle_mgturret))
		level.vehicle_mgturret = [];
	if(!isdefined(level.vehicleanimtree))
		level.vehicleanimtree = [];
	if(!isdefined(level.vehicle_isStationary))
		level.vehicle_isStationary = [];
	if(!isdefined(level.vehicle_rumble))
		level.vehicle_rumble = [];
	if(!isdefined(level.vehicle_death_earthquake))
		level.vehicle_death_earthquake = [];
	if(!isdefined(level.vehicle_treads))
		level.vehicle_treads = [];		
	if(!isdefined(level.vehicle_compassicon))
		level.vehicle_compassicon = [];		
	if(!isdefined(level.vehicle_unloadgroups))
		level.vehicle_unloadgroups = [];		
	if(!isdefined(level.vehicle_aianims))
		level.vehicle_aianims = [];
	if(!isdefined(level.vehicle_unloadwhenattacked))
		level.vehicle_unloadwhenattacked = [];

}

friendlyfire_shield ()
{
	self endon ("death");
	self endon ("stop_friendlyfire_shield");
	
	self.healthbuffer = 2000;
	self.health += self.healthbuffer;
	self.currenthealth = self.health;
	attacker = undefined;
	
	while(self.health > 0)
	{
		self waittill ("damage",amount, attacker);
		if(isdefined(self.godmode) && self.godmode)
			self.health = self.currenthealth;
		if ( (isdefined(attacker)) && isdefined(attacker.script_team) && (isdefined (self.script_team)) && (attacker.script_team == self.script_team) )
			self.health = self.currenthealth;
		else if ( (isdefined(self.script_team)) && (self.script_team == "allies") && (isdefined (attacker)) && (attacker == level.player) )
			self.health = self.currenthealth;
		else if (isdefined(self.frontarmorregen))  //regen health for tanks with armor in the front
		{
			hitbyplayervehicle = false;
			if(isdefined(attacker) && attacker == level.playervehicle)
			{
				hitbyplayervehicle = true;
				if(isdefined(level.hitbyplayervehiclethread))
					thread [[level.hitbyplayervehiclethread]]();
				
			}
			else if(isdefined(attacker) && attacker.classname  == "script_vehicle")
			{
				if(attacker.script_team == "allies" && self.script_team == "axis")
					level notify ("hitbyalliedtank");
				else if(attacker.script_team == "axis" && self.script_team == "allies")
					level notify ("hitbyaxistank");
			}
			forwardvec = anglestoforward(self.angles);
			othervec = vectorNormalize(attacker.origin-self.origin);
			if(vectordot(forwardvec,othervec) > .86) 
			{
				if(hitbyplayervehicle)
					level notify ("tank_hit_from_front"); // notify for hintprint
				self.health+= int(amount*self.frontarmorregen);
			}
			self.currenthealth = self.health;
		}
		else
			self.currenthealth = self.health;
			
		if(self == level.playervehicle && IsDefined(attacker.targetname))
			println( "damaged by attacker: ",attacker.targetname);
		if(self.health < self.healthbuffer)
			break;
		
	}
	self notify ("death",attacker);
}


vehicle_avoidcolision ()
{
	// sets the samples for other vehicles
	thread vehicle_conechecksamples();
	
	self.avoiding = false;
	if(isdefined(self.spawnflags) && self.spawnflags & 1)
		return; // useable tanks don't avoid stu
	self endon ("reached_end_node");
	self endon ("deadstop");
	self endon ("death");
	self endon ("delete");
	self endon ("stop avoiding tanks");
	level.vehicle_avoiddelay+= .05;
	if(level.vehicle_avoiddelay > 1)
		level.vehicle_avoiddelay = 0;
	wait level.vehicle_avoiddelay;
	thread debug_vehicleavoid();
	for (;;)
	{
		if(!self.script_avoidvehicles)
		{
			wait .5;
			continue;
		}
		if ( (isdefined (self.dontAvoidTanks)) && (self.dontAvoidTanks == true) )
			return;

		check = vehicle_check(level.vehicle_threats);
		if(check != 0)
		{
			self.avoiding = true;
			if(check == 1)
			{
				self.truecheck = 1;
				stopspeed = self getspeedmph()/15*15;
				if(stopspeed<15)
					stopspeed = 15;
				vehicle_setspeed(0,stopspeed,"collision avoidance, non player");	
				while(check == 1)
				{
					if(!self.script_avoidvehicles)
						break;
					self maps\_vehicle::vehicle_setspeed(0,stopspeed,"collision avoidance, non player");
					check = vehicle_check(level.vehicle_threats);
				}
				self.truecheck = 0;

				script_resumespeed("collision avoidance done",15);
			}
			self.avoiding = false;
		}
	}
}

vehicle_rumble ()
{
// makes vehicle rumble

	type = self.vehicletype;
	if(!isdefined(level.vehicle_rumble[type]))
		return;
		
	rumblestruct = level.vehicle_rumble[type];
	height = rumblestruct.radius*2;
	zoffset = -1*rumblestruct.radius;
	areatrigger = spawn( "trigger_radius", self.origin+(0,0,zoffset), 0, rumblestruct.radius, height );
	areatrigger enablelinkto();
	areatrigger linkto(self);
	self.rumbletrigger = areatrigger;
	self endon ("death");
//	( rumble , scale , duration , radius , basetime , randomaditionaltime )
	if(!isdefined(self.rumbleon))
		self.rumbleon = true;
	if(isdefined(rumblestruct.scale))
		self.rumble_scale = rumblestruct.scale;
	else
		self.rumble_scale = 0.15;
		
	if(isdefined(rumblestruct.duration))
		self.rumble_duration = rumblestruct.duration;
	else
		self.rumble_duration = 4.5;
		
	if(isdefined(rumblestruct.radius))
			self.rumble_radius = rumblestruct.radius;
	else
			self.rumble_radius = 600;
	if(isdefined(rumblestruct.basetime))
			self.rumble_basetime = rumblestruct.basetime;
	else
		self.rumble_basetime = 1;
	if(isdefined(rumblestruct.randomaditionaltime))
			self.rumble_randomaditionaltime = rumblestruct.randomaditionaltime;
	else
		self.rumble_randomaditionaltime = 1;
	
	areatrigger.radius = self.rumble_radius;
	while (1)
	{
		areatrigger waittill ("trigger");
		if(self getspeedmph() == 0 || !self.rumbleon)
		{
			wait .1;
			continue;
		}

		self PlayRumbleLoopOnEntity( level.vehicle_rumble[type].rumble );
		while(level.player istouching(areatrigger) && self.rumbleon && self getspeedmph() > 0)
		{
			earthquake(self.rumble_scale, self.rumble_duration, self.origin, self.rumble_radius); // scale duration source radius
			wait (self.rumble_basetime + randomfloat(self.rumble_randomaditionaltime));
		}
		self StopRumble( level.vehicle_rumble[type].rumble );
	}
}


/*

//Possibly add this default vehicle turret behavior

debug_vehicleattackthreats ( tagorg, angle, coneangle, radius, r, g, b, targorg )
{
	/#
	if(getdvar("debug_vehicleattackthreats") == "off")
		return;
	timer = gettime()+3000;
	thread draw_line_for_time(tagorg,targorg,1,0,0,4);
	while(getdvar("debug_vehicleattackthreats") != "off" && timer > gettime())
	{
		drawcone(tagorg,angle,coneangle,radius,r,g,b);
		wait .05;
	}
	#/
}

attack_threats ()  //if a tank falls within this cone they will put that tank at the front of their attack que
{
	self endon ("death");
	
	if(!(level.script == "libya" || level.script == "88ridge"))
		return;  
	radius = 3000;
	largeradius = 4500;
	angle = 22;
	conevectordotnumber = -1*cos(angle);
	
	level.vehicle_attackthreatsdelay+= .05;
	if(level.vehicle_attackthreatsdelay > 1)
		level.vehicle_attackthreatsdelay = 0;
	wait level.vehicle_attackthreatsdelay;
	while(1)
	{
		if(!self.script_turret)
		{
			wait .5;
			continue;
		}
		tagang = self gettagangles("tag_barrel");
		tagorg = self gettagorigin("tag_barrel");
		barrelvect = anglesToForward(tagang);
		for(i=0;i<level.vehicle_threats.size;i++)
		{
			if(level.vehicle_threats[i].script_team == self.script_team)
				continue;
			dist = distance(level.vehicle_threats[i].origin,self.origin);
			if(dist > largeradius)
				continue;
			else if(dist > radius && level.vehicle_threats[i] == level.playervehicle && level.currentlytargetingplayertanks.size < 3)
			{
				self thread debug_vehicleattackthreats(tagorg,tagang,angle,radius,1,0,1,level.vehicle_threats[i].origin);
				self queaddtofront(level.vehicle_threats[i]); //teh magic
				wait 4;
				break;		
			}
			else if(dist > radius)
				continue;
			normalvec = vectorNormalize(tagorg-level.vehicle_threats[i].origin);
			vectordot = vectordot(barrelvect,normalvec);
			if(level.vehicle_threats[i] == level.playervehicle && self.script_team == "axis")
			{
				self queaddtofront(level.vehicle_threats[i]); //teh magic
				wait 4;
				break;
				
			}
	//			bullettracepassed(<start>, <end>, <hit characters>, <ignore entity>)
			if(vectordot < conevectordotnumber && bullettracepassed(self.origin +(0,0,40),level.vehicle_threats[i].origin+(0,0,40),0,level.vehicle_threats[i]))
			{
				self thread debug_vehicleattackthreats(tagorg,tagang,angle,radius,1,0,1,level.vehicle_threats[i].origin);
				self queaddtofront(level.vehicle_threats[i]); //teh magic
				wait 4;
				break;
			}
		}
		wait 1;
	}
}
*/

vehicle_conechecksamples ()
{
//  TODO: GET CODE to do this 
// these are sample points that a vehicle uses to determine that another vehicle is in the way
// some points are also used as origins for other badplaces.  it's ugly TODO: MAKE IT BETTER

	if(!isdefined(self.cosinedangle))
		self.cosinedangle = 17.0000;
	if(!isdefined(self.conevectordotnumber))
		self.conevectordotnumber = cos(self.cosinedangle);
	if(!isdefined(self.coneradius))
		self.coneradius = 800;


	
	angle1 = anglestoright(self.angles);
	vector1 = vector_multiply(angle1,64);

	point1 = spawn("script_origin", (1,1,1));
	point2 = spawn("script_origin", (1,1,1));
	point3 = spawn("script_origin", (1,1,1));
	point4 = spawn("script_origin", (1,1,1));
	point5 = spawn("script_origin", (1,1,1));

	stoporg1 = spawn("script_origin", (1,1,1));
	stoporg2 = spawn("script_origin", (1,1,1));


	point1.origin =  self.origin+vector1;
	point2.origin =  self.origin-vector1;

	angles = anglestoforward(self.angles);
	vector1 = vector_multiply(angles,96);

	vector2 = vector_multiply(angles,84);
	vector3 = vector_multiply(angles,84);

	stoporg1.origin = self.origin+vector2;
	stoporg2.origin = self.origin-vector3;

	point1.origin = point1.origin+vector1;
	point2.origin = point2.origin+vector1;
	p3add = vector_multiply(vector1,2);
	point3.origin = point1.origin-(p3add);
	point4.origin = point2.origin-(p3add);
	
	point5.origin = self.origin+vector_multiply(angles,-194);
	
	self.samplepoints[0] = point1;
	self.samplepoints[1] = point2;
	self.samplepoints[2] = point3;
	self.samplepoints[3] = point4;
//	self.samplepoints[4] = point5;
	
	self.colidecircle[0] = stoporg1;
	self.colidecircle[1] = stoporg2;
	
	self.checkorg = point5;
	
	self.checkorg linkto (self);
	for(i=0;i<self.colidecircle.size;i++)
		self.colidecircle[i] linkto(self);

	for(i=0;i<self.samplepoints.size;i++)
		self.samplepoints[i] linkto (self);
		
		
	self waittill("death");
	
	point1 delete();
	point2 delete();
	point3 delete();
	point4 delete();
	point5 delete();

	stoporg1 delete();
	stoporg2 delete();
}

vehicle_badplace()
{
	self endon ("death");
	self endon ("delete");
	if(isdefined(level.custombadplacethread))
	{
		self thread [[level.custombadplacethread]]();
		return;
	}
	hasturret = isdefined(level.vehicle_hasMainTurret[self.model]) && level.vehicle_hasMainTurret[self.model];
	bp_duration = .5;
	bp_height = 300;
	bp_angle_left = 17;
	bp_angle_right = 17;
	for (;;)
	{
		if(!self.script_badplace)
		{
//			badplace_delete("tankbadplace");
			while(!self.script_badplace)
				wait .5;
		}
		speed = self getspeedmph();
		if (speed > 0)
		{
			if (speed < 5)
				bp_radius = 200;
			else if ((speed > 5) && (speed < 8))
				bp_radius = 350;
			else
				bp_radius = 500;
			
			if (isdefined(self.BadPlaceModifier))
				bp_radius = (bp_radius * self.BadPlaceModifier);
			
//			bp_direction = anglestoforward(self.angles);
			if(hasturret)
				bp_direction = anglestoforward(self gettagangles ("tag_turret"));
			else
				bp_direction = anglestoforward(self.angles);

			badplace_arc("", bp_duration, self.origin, bp_radius*1.9, bp_height, bp_direction, bp_angle_left, bp_angle_right,"allies","axis");
			badplace_cylinder("", bp_duration, self.colidecircle[0].origin, 200, bp_height, "allies","axis");
			badplace_cylinder("", bp_duration, self.colidecircle[1].origin, 200, bp_height, "allies","axis");
		}
		wait bp_duration+.05;
	}
}

// does check on entities that have a samplepoint array and will add
// baddies that are close to the front of the vehicle to its enemy que 
vehicle_check ( vehicles )
{
	prof_begin("vehicle_check");
	check = 0;
	checkdelay = .3;
	speed = self getspeedmph(); 
	if(self.script_avoidplayer == true)
	{
		if(speed < 8)
			speed = 8;  // at 15/mph the cone stays the samee
		if(isdefined(self.script_playerconeradius))
			coneRadius = self.script_playerconeradius;
		else
			coneRadius = 200; 	
		check = stopcheck(self,level.player,(speed/5*coneRadius));
		if(check != 0)
		{
			wait checkdelay;
			prof_end("vehicle_check");
			return check;
		}
	}
	if(speed < 15)
		speed = 15;  // at 15/mph the cone stays the same
	speed = (speed/15)*self.coneradius;
	for(i=0;i<vehicles.size;i++)
	{
		check = stopcheck(self,vehicles[i],speed);
		if(check != 0)
			break;
	}
	wait checkdelay;
	prof_end("vehicle_check");
	return check;
}

vehicle_treads () 
{
	//larger number means fx will play less frequently. 
	
   	if(!isdefined(level.vehicle_treads[self.vehicletype]))
   		return;
   	
	// BOND MOD
	// MQL 4/9/08: add boat wake
	if( self.vehicletype == "motor_boat" )
	{
		self thread wake();
		return;
	}

   	if ( self isHelicopter() )
   		return;
   	
	if(isdefined(level.tread_override_thread)) 
		self thread [[level.tread_override_thread]](	"tag_origin", "back_left", (160,0,0));
	else 
	{
		self.TuningValue = 35;
		self thread tread("tag_wheel_back_left","back_left"); 
		self thread tread("tag_wheel_back_right","back_right"); 
	}
}

tread (tagname, side, relativeOffset)
{
	// BOND_MOD
	// 03/05/08: Hack to not play fx on invisible vehicles
	if (IsDefined(self.script_ignoreme) && self.script_ignoreme)
	{
		return;
	}
	// !BOND_MOD

	self endon ("death");
	if (!isDefined(relativeOffset) )
		relativeOffset = (0,0,0);
	treadfx = treadget(self, side);
	for (;;)
	{
		// BOND MOD
		// 11/30/07: use getspeedmph since vehicles aren't sentient
		speed = self GetSpeedMPH();
		//speed = self getspeed();

		if (speed == 0)
		{
			wait 0.1;
			continue;
		}
		waitTime = (1 / speed);
		waitTime = (waitTime * self.TuningValue);
		if (waitTime < 0.1)
			waitTime = 0.1;
		else if (waitTime > 0.3)
			waitTime = 0.3;
		wait waitTime;
		lastfx = treadfx;
		treadfx = treadget(self, side);
		if(treadfx != -1)
		{
			ang = self getTagAngles(tagname);
			forwardVec = anglestoforward(ang);
			rightVec = anglestoright(ang);
			upVec = anglestoup(ang);
			effectOrigin = self getTagOrigin(tagname);
			effectOrigin += maps\_utility::vector_multiply(forwardVec, relativeOffset[0]);
			effectOrigin += maps\_utility::vector_multiply(rightVec, relativeOffset[1]);
			effectOrigin += maps\_utility::vector_multiply(upVec, relativeOffset[2]);
			forwardVec = maps\_utility::vector_multiply(forwardVec, waitTime);
			playfx (treadfx, effectOrigin, (0,0,0) - forwardVec);
		}
	}
}

treadget (vehicle, side)
{
	surface = self getwheelsurface(side);
	if (!isdefined (vehicle.vehicletype))
	{
		treadfx = -1;
		return treadfx;
	}
	
	if(!isdefined(level._vehicle_effect[vehicle.vehicletype]))
	{
		println("no treads setup for vehicle type: ",vehicle.vehicletype);
		wait 1;
		return -1;
	}
	treadfx = level._vehicle_effect[vehicle.vehicletype][surface];
	
	if(surface == "ice")
		self notify ("iminwater");
	
	if(!isdefined(treadfx))
		treadfx = -1;
	
	return treadfx;
}

wake()
{
	self endon ("death");

	self.TuningValue = 17.5;

	while( IsDefined( self ) )
	{
		speed = self GetSpeedMPH();

		if (speed == 0)
		{
			wait 0.1;
			continue;
		}
		waitTime = (1 / speed);
		waitTime = (waitTime * self.TuningValue);
		if (waitTime < 0.1)
			waitTime = 0.1;
		else if (waitTime > 0.3)
			waitTime = 0.3;
		wait waitTime;

		PlayFxOnTag( level._vehicle_effect[ self.vehicletype ][ "water" ], self, "tag_wake");
	}
}

turret_attack_think ()
{
	// chad - disable this for now, will eventually handle shooting of missiles at targets
	if ( self isHelicopter() )
		return;
	
	type = self.vehicletype;
	thread turret_shoot();
	if(!isdefined(level.vehicle_hasMainTurret[self.model]) || !level.vehicle_hasMainTurret[self.model] || (isdefined(self.spawnflags) && self.spawnflags & 1))
		return;
	self.enemyque = [];
	
	//vehicle becomes a threat
	level.vehicle_threats[level.vehicle_threats.size] = self;

	thread turret_stun(1);
	
	if (!isdefined (self.script_turret))
		self.script_turret = true;
	self.attackspeed = 0;
	self.badshot = false;
	self.predictororigin = spawn("script_origin",self.origin);
	self.originque = [];
	self.attackingtroops = false;
	self.attackingorigins = false;
	self.attackback = true;
	self thread turret_idle();
//	self thread attack_threats();
	self thread turret_attack();
	self thread turret_attack_respond();
	self.offsetone = 30;
	self.offsetzero = 430;
	self.offsetrange = self.offsetone-self.offsetzero;

	if(!isdefined(self.script_accuracy))
		self.script_accuracy = .44;
	if(self.script_accuracy > .9999)
		self.script_accuracy = .9999;
	
	if(!isdefined(self.waitingforgate))
		self.waitingforgate = false;
	self.accuracy = self.offsetzero+(self.offsetrange*self.script_accuracy);

	self endon ("death");
	self.shotcount = 2;
	shotattempts = 0;
	self thread turret_infinitendnodeshots();
	self.turretfiretimer = gettime(); // ready to fire
	self.turretaccmins = .35;  // precentag of accuracy.  tank will never fire with accuracy less than this.   To get a tank to be more accurate simply addust the script_accuracy on the nodes.
	self.turretaccmaxs = 1-self.turretaccmins;
	
	self.shotsatzerospeed = 0;
	self.badshotcount = 0;
	if(!isdefined(self.holdfire))
		self.holdfire = false;
	for (;;)
	{
		for (;;)
		{
			if(!turret_quecheck())
				break;
			if (!turret_allowedShoot())
				break;

			//aim at an offset origin with turret_on_vistarget();
			self thread turret_on_vistarget(self.enemyque[0],"vehicle");
			while(turret_allowedShoot() && !self.turretonvistarg && !self.badshot )
				wait .05;
			if(self.badshot)
				break;
			while(self.holdfire)
				wait .05;
			self notify ("novistarget");  //ends turret_on_vistarget
			self.turretonvistarg = false;
			if (!turret_allowedShoot())
				break;
			while(gettime() < self.turretfiretimer && turret_allowedShoot())
				wait .05;
			wait .1;
			if (!turret_allowedShoot())
				break;
			self clearTurretTarget();
			self notify( "turret_fire" );

			if(self getspeedmph() == 0)
				self.shotsatzerospeed++;
			if(self.shotsatzerospeed>9)
				self.shotsatzerospeed = 9;

			self.turretfiretimer = gettime() + (level.vehicle_turretfiretime[self.model]*1000);
			if(self.shotcount != -1 && !self.waitingforgate)
				shotattempts++;
			timer = gettime()+1000;
			while(gettime() < timer && turret_allowedShoot())
				wait .05;

			if (!turret_allowedShoot())
				break;
			self setTurretTargetEnt(self.enemyque[0], (0, 0, 64) );
			if(self.shotcount != -1 && shotattempts > self.shotcount)
			{
				shotattempts = 0;
				break;
			}
		}
		if(!self.script_turret || riders_check())
		{
			wait .05;
			continue;
		}
		if(self.badshot && !self.attackingtroops)
		{
			wait .1;
			self.badshot = false;
			if(self.enemyque.size != 1)
				continue;
		}
		self.shotsatzerospeed = 0;
		shotattempts = 0;
		if(self.enemyque.size > 0)
		{
			if (!turret_allowedShoot())
				queremove(self.enemyque[0]); 
			else	if(self.attackspeed == 0 && !isStationary() )  //!isdefined(self.killcomit)
			{
				self notify ("turretidle");  // sets tank to resume waits for next attack message from trigger
				self waittill ("attackernow");
			}
		}
		else
		{
			self notify ("turretidle");
			if(self.originque.size > 0)
			{
				if(!self.attackingorigins)
					self thread attack_origins();
			}
			else if(!self.attackingtroops && !self.riders.size && self.script_turret && self.script_attackai)
				self thread attack_troops();
		}
		wait .3;
	}
}

riders_check()
{
	type = self.vehicletype;
	if(isdefined(level.vehicle_turret_requiresrider[type]) && level.vehicle_turret_requiresrider[type] && !has_riders())
	{
		self.attackingtroops = false;
		self.attackingorigins = false;
		self notify ("noriders"); //kills ai targeting
		return true;
	}
	else
		return false;
	
}

isStationary()
{
	type = self.vehicletype;
	if(isdefined(level.vehicle_isStationary[type]) && level.vehicle_isStationary[type])
		return true;
	else 
		return false;
		
}



has_riders()
{
	if(isdefined(self.requiresriders) && !self.requiresriders)
		return true;  //this vehicle is force to fire without riders through level script
	if(self.riders.size)
		return true;
	else
		return false;
}


turret_idle()
{
	while(1)
	{
		self waittill("turretidle");
		if(!self.script_turret)
			continue;
		if(self.enemyque.size || self.attackingtroops || self.attackingorigins ||  has_riders() )
			continue;
		self clearTurretTarget();
		vect = (0,0,32)+self.origin+vector_multiply(anglestoforward(self.angles),3000);
		self setturrettargetvec(vect);
	}
}

attack_origins()
{
	self.attackingorigins = true;
	self endon ("death");
	self endon ("attack");
	self endon ("enemy tank que found");
	looping = undefined;
	//getting messy perhaps
	self notify ("attacking origins"); // ends attacking troops
	self endon ("attacking origins");
	self.attackingtroops = false;	//sets flag of not attacking troops
	self.turretonvistarg = false;
	
	while( ( self.script_turret && self.originque.size > 0 ) || ( self.originque.size && self.originque[ 0 ].hinter ) )
	{
		if(isdefined(self.stop_for_attack_origins))
			self vehicle_setspeed(0,15,"attacking origins");
		//player touching triggers takes priority over ai touching the triggers.
		if(self.script_team == "axis")
			for(i=0;i<self.originque.size;i++)
				if(isdefined(self.originque[i].triggertarget))
					if(level.player istouching (self.originque[i].triggertarget))
						self.originque = add_tofrontarray(self.originque,self.originque[i]);
		target = self.originque[0];
		if(isdefined(self.originque[0].script_noteworthy) && isdefined(level.attack_origin_condition_threadd[self.originque[0].script_noteworthy]))
			if(!self.originque[0] [[level.attack_origin_condition_threadd[self.originque[0].script_noteworthy]]]())
			{
				script_resumespeed("no more origins",level.vehicle_ResumeSpeed);
				self.originque = array_remove(self.originque,self.originque[0]);
				continue;
			}
		self notify ("novistarget");
		self.turretonvistarg = false;
		self setTurretTargetEnt(target,(0,0,0));
		self thread turret_on_vistarget(target,"origin");
		while(gettime() < self.turretfiretimer || !self.turretonvistarg)
			wait .05;
		self clearTurretTarget();
		if(!self.script_turret)
		{
			self.attackingorigins = false;
			return;
		}
		dofire = true;
		
		if(!self.originque.size)
		{
			self.attackingorigin = false;
			return;
		}

	
		if(isdefined(self.originque[0].triggertarget))
		{
			dofire = false;
			if(self.script_team == "axis")
			{
				ai = getaiarray ("allies");
				ai[ai.size] = level.player;
			}
			else if(self.script_team == "allies")
			{
				ai = getaiarray ("axis");
			}
			else
				ai = [];
			for(i=0;i<ai.size;i++)
			{
				if(ai[i] istouching (self.originque[0].triggertarget))
				{
					dofire = true;
					break;
				}
			}
				
		}
		if(self.originque[0].hinter)
			dofire = false;
		if( dofire && ( self.originque[0].script_shots > 0 ) )
		{
		  	if(isdefined(self.originque[0].script_exploder))
				maps\_utility::exploder(self.originque[0].script_exploder);
			self notify( "turret_fire" );
		}
	
		self.originque[0].script_shots--;
		self.turretfiretimer = gettime() + (level.vehicle_turretfiretime[self.model]*1000);
		if(!self.script_turret)
		{
			self.attackingorigins = false;
			return;
		}
		self notify ("novistarget");
		self clearTurretTarget();
		self notify( "turretidle" );
		if(isdefined(self.originque[0].script_noteworthy) && self.originque[0].script_noteworthy == "looping")
			looping = self.originque[0].script_attackorgs;
		else if ( self.originque[0].script_shots <= 0 )
			break;
		self.originque = array_remove(self.originque,self.originque[0]);
		if(self.originque.size == 0)
			break;
		wait .4;
	}
	if(isdefined(self.stop_for_attack_origins))
		script_resumespeed("no more origins",level.vehicle_ResumeSpeed);
	if(isdefined(looping))
		self turret_queorgs(looping,true);
	self.attackingorigins = false;
}

attack_troops ()
{
	self.attackingtroops = true;
	self endon ("death");
	self endon ("attack");
	self endon ("enemy tank que found");
	self endon ("attacking origins");
	self endon ("noriders");
	self.turretonvistarg = false;
	nearrange = 650;
	maxshots = 3;
	failedguy = [];

	failedcount = 0;
	while(self.script_turret)
	{
		troops = undefined;
		if(self.script_team == "axis")
		{
			troops = getaiarray("allies");
			troops[troops.size] = level.player;
		}
		else if(self.script_team == "allies")
			troops = getaiarray("axis");
		else 
			break;
		if(!isdefined(troops))
			break;
		fullarray = troops;
		for(i=0;i<failedguy.size;i++)
			troops = array_remove(troops,failedguy[i]);
		if(!troops.size)
		{
			troops = fullarray;
			failedguy = [];  //reset failed guy que start over.  Everybody has failed at this point
		}
		forwardvec = anglestoforward(self gettagangles("tag_flash"));
		target = getnearestvectoroutsiderange( self gettagorigin("tag_flash"), forwardvec, troops, nearrange);
		if(!isdefined(target))
		{
			wait .1;
			failedguy = [];
			continue;
		}
		if(!self.script_turret || !self.script_attackai)
			return;
		shotsfired = 0;
		while(isalive(target) && distance(self.origin, target.origin) > nearrange && shotsfired < maxshots )
		{

			self notify ("novistarget");
			self thread turret_on_vistarget(target,"troop");
			while(!self.turretonvistarg && !self.badshot)
				wait .05;
			if(!self.script_turret || !self.script_attackai)
				return;	
			if(self.badshot)
			{
				wait .05;
				self.badshot = false;
				break;
			}
			tracepassed = true;
			while(gettime() < self.turretfiretimer && isalive(target) && tracepassed)
			{
				tracepassed = bullettracepassed(target.origin+(0,0,48),self gettagorigin("tag_flash"),false,self);
				wait .05;
			}
			if(!(tracepassed))
			{
				wait .05;
				break;
			}
			self clearTurretTarget();
			self notify( "turret_fire" );
			failedcount = 0;
			shotsfired++;
			self.turretfiretimer = gettime() + (level.vehicle_turretfiretime[self.model]*1000);
		}
		if(failedcount > 2)
		{
			wait .05;
			failedcount = 0;
		}
		shotsfired = 0;
		if(!self.script_turret || !self.script_attackai)
			return;
		self notify ("novistarget");
		if(isalive(target))
		{
			failedguy[failedguy.size] = target;
			failedcount++;			
		}
		self clearTurretTarget();
		self notify( "turretidle" );
		wait .05;
	}
	self.attackingtroops = false;
}


turret_infinitendnodeshots ()
{
	self endon ( "death" );
	self waittill ("reached_end_node");
	self.shotcount = -1;
}

turret_allowedShoot ( target )
{
	if(riders_check())
		return false;
	if (!self.script_turret)
		return false;
	if (self.stunned)
		self waittill ("stundone");
	if(!turret_quecheck())
		return false;
	target = self.enemyque[0];
	if(!isdefined(target))
		return false;
	if(target.health <= 0)
		return false;
	return true;
}


getnearestvectoroutsiderange ( org, forwardvec, array, range )
{
	theone = undefined;
	if (array.size < 1)
		return;
	rangeontheone = 0;
	ent = undefined;
	highestvectordot = -1;
	offsetorg = self.origin+(0,0,128);
	for (i=0;i<array.size;i++)
	{
		trace = bullettrace(offsetorg,array[i].origin+(0,0,48),true,self);
		if(trace["fraction"] < .7)
		{
//			thread draw_line_for_time(offsetorg,array[i].origin+(0,0,32),1,0,0,4);
			continue;
		}
//		else
//		{
//			thread draw_line_for_time(offsetorg,array[i].origin+(0,0,32),0,1,0,4);
//		}
		newdist = distance(array[i].origin, org);
		if ( newdist < range )
			continue;
		targetvec = vectornormalize(array[i].origin - org);
		vectordotnumber = vectordot(targetvec,forwardvec);
		if( vectordotnumber > highestvectordot )
		{
			theone = array[i];
			rangeontheone = newdist;
			highestvectordot = vectordotnumber;
		}
	}
	return theone;
}

// sets stunned flag on damage for turrets
turret_stun ( stuntime )
{
	self endon ("death");
	while(self.health > 0)
	{
		self.stunned = false;
		self waittill ("damage");
		self.stunned = true;
		wait stuntime;
		self notify ("stundone");
	}
}

turret_attack ()
{
	while(1)
	{
		self waittill ("attack",targets,attackall);
		if(!self.script_turret)
		{
			wait .05;
			continue;
		}
		if(isdefined(attackall))
			turret_queallenemies();
		for(i=0;i<targets.size;i++)
			self thread queadd(targets[i]);
		self notify ("attackernow");
		if(self.enemyque.size == 0)
				continue;
		else
			target = self.enemyque[0];
		target notify ("attackresponse",self);  //fight back
		if(!isdefined(self.rollingdeath))
			self thread attackspeed();
	}
}

turret_attack_respond ()
{
	while(1)
	{
		self waittill ("attackresponse",attacker);
		if(!self.script_turret || !self.attackback)
			continue;
		self thread queadd(attacker);
	}
}

attackspeed ()
{
	self.attacking = true;
	if(!self.tanksquadfollow)  // don't stop if you're in squad formation
	{
		self vehicle_setspeed(self.attackspeed,15,"Attack speed");
	}
	self waittill ("turretidle");
	self.selfresumestate = "attack";
	self.attacking = false;  // lets resumespeed know that there's a script set speed for attacking.
	script_resumespeed("Done attacking,turretidle",level.vehicle_ResumeSpeed);
}

turret_shoot ()
{
	type = self.vehicletype;
	self endon ("death");
	self endon ("stop_turret_shoot");
	while(self.health > 0)
	{
		self waittill( "turret_fire" );
		self thread turret_shoot_anim();
		self notify ("groupedanimevent","turret_fire");
		self fireWeapon();
	}
}

turret_shoot_anim ()
{
	self endon ("death");
	self endon ("turret_fire");
	if(!isdefined(level.vehicleanimtree[self.model]))
		return;
	self useanimtree(level.vehicleanimtree[self.model]);
	if(!isdefined(level.vehiclefireanim[self.model]))
		return;

	if(!isdefined(level.vehiclefireanim_settle[self.model]))
	{
		self setanim(level.vehiclefireanim[self.model],1,0);
		return;
	}
	self clearanim(level.vehiclefireanim_settle[self.model],0);
	self setanim(level.vehiclefireanim[self.model],1,0);
	wait .25;
	self clearanim(level.vehiclefireanim[self.model],0);
	if(!isdefined(level.vehiclefireanim_settle[self.model]))
		return;
	self setflaggedanim("shooting_animation",level.vehiclefireanim_settle[self.model],1,0);
	self waittillmatch("shooting_animation","end");
	self clearanim(level.vehiclefireanim_settle[self.model],0);
}


vehicle_compasshandle ()
{
	type = self.vehicletype;
	if(!isdefined(level.vehicle_compassicon[type]))
		return;
	self endon ("death");
	level.compassradius = int(getdvar("compassMaxRange"));
	self.onplayerscompass = false;
	//TODO: complain to Code about this feature.  I shouldn't have to poll the distance of the tank to remove it from the compass
	while(1)
	{
		if(distance(self.origin,level.player.origin) < level.compassradius)
		{
			if(!(self.onplayerscompass))
			{
				self addvehicletocompass();
				self.onplayerscompass = true;
			}
		}
		else
		{
			if(self.onplayerscompass)
			{
				self removevehiclefromcompass();
				self.onplayerscompass = false;
			}
		}
		wait .5;	
	}
}

turret_queallenemies ()
{
	tanks = array_randomize(level.vehicle_threats);
	
	for(i=0;i<tanks.size;i++)
	{
		if(tanks[i].script_team != self.script_team)
			queadd(tanks[i]);
	}
}

vehicle_setteam ()
{
	type = self.vehicletype;
	if(!isdefined(self.script_team) && isdefined(level.vehicle_team[type]))
		self.script_team = level.vehicle_team[type];
	if(isdefined(level.vehicle_hasname[type]))
		self thread maps\_vehiclenames::get_name();
	
	level.vehicles[self.script_team] = array_add( level.vehicles[self.script_team], self );
}

turret_quecheck ()
{
	if(self.enemyque.size > 0)
	{
		self notify ("enemy tank que found");
		self.attackingtroops = false;
		self.attackingorigins = false;
		return true;
	}
	return false;
}

queremove ( target )
{
	if(self.enemyque.size == 0)
		println("self.enemyque not defined in quermove before array remove");
	self.enemyque = array_remove(self.enemyque,target);
}

queadd ( target )
{
	if(!isdefined(target))
		return;		
	if(target.health > 0)
		self.enemyque = add_to_arrayfinotinarray( self.enemyque, target );
}

queaddtofront ( target )
{
	if(!isdefined(target))
		println("tried to add undefined to que");
	if(target.health > 0)
		self.enemyque = add_tofrontarray( self.enemyque, target );
}

add_tofrontarray ( array,ent )
{
	newarray[0] = ent;
	for(i=0;i<array.size;i++)
	{
		if(ent != array[i])
			newarray[newarray.size] = array[i];
	}
	return newarray;
}

quetoback ( array, ent )
{
	newarray = [];
	count = 0;
	if(array.size > 1)
	{
		for(i=0;i<array.size;i++)
		{
			if(i!=0)
			{
				newarray[count] = array[i];
				count++;
			}
		}
		newarray[count] = array[0];
		return newarray;
	}
	else
	{
		return array;
	}
}

turret_on_vistarget ( vistarget, type )
{
	self endon ("death");
	if(!self.script_turret)
		return;
	self.turretonvistarg = false;	
	predictorvehicle = undefined;
	predicting = false;
	if(isdefined(vistarget.predictor))
	{
		predicting = true;
		predictorvehicle = vistarget;
		vistarget = vistarget.predictor;
	}
	if(type == "vehicle" || type == "troop")
	{
		dist = distance(self.origin,vistarget.origin);
		visibility = getfxvisibility(self.origin,vistarget.origin);

		vismin = 1;
		vismax = 4;
		visrange = vismax-vismin;
		visibilitymod = vismin+(visrange-visibility*visrange);
		
		if(self getspeedmph() < 1 && (type == "troop" || ((predicting && predictorvehicle getspeedmph() < 1) || (!predicting && vistarget getspeedmph() < 1))))
		{
			distacc = (self.accuracy*(1-.1*self.shotsatzerospeed))*visibilitymod*(dist/5000);
		}
		else
		{
			self.shotsatzerospeed = 0;
			distacc = self.accuracy*visibilitymod*(dist/5000);
		}
		if(!predicting)
		{
			if(isdefined(vistarget.accuracyoffsetmod))
				distacc*= vistarget.accuracyoffsetmod; // for players tank artificially modifying enemies accuracy based on whatever wacky conditions I decide to use.
		}
		else
		{
			if(isdefined(predictorvehicle.accuracyoffsetmod))
				distacc*= predictorvehicle.accuracyoffsetmod; // for players tank artificially modifying enemies accuracy based on whatever wacky conditions I decide to use.
			
		}
		randomacc = randomfloat(distacc*self.turretaccmaxs)+(distacc*self.turretaccmins);
		angletoenemy = flat_angle(vectortoangles(vistarget.origin-self.origin));
		randrad = -20+randomint(220);
		if(type == "vehicle")
			heightoffset = (0,0,78);
		else
			heightoffset = (0,0,16); //try for splash damage
		randomthreesixtyangle = angletoenemy+(randrad,90,0);
		offset = vector_multiply(anglestoforward(randomthreesixtyangle),randomacc);
		if(type == "troop")
			tracetroops = true;
		else
			tracetroops = false;
		trace = bullettrace(self gettagorigin("tag_flash"), vistarget.origin+offset+heightoffset,tracetroops, self);
	//			thread draw_line_for_time(self gettagorigin("tag_flash"),vistarget.origin+offset+heightoffset,1,1,1,hangtime);
		offset = trace["position"]-vistarget.origin;		

		/#
		dvar =getdvar("debug_vehicleturretaccuracy"); 
		while(dvar != "off")
		{
			if(
				(dvar == "axis" && self.script_team != "axis")
			||	(dvar == "allies" && self.script_team != "allies")
			  )
			  break;
			hangtime = 2;
			circleres = 14;
			hemires = circleres/2;
			circleinc = 360/circleres;
			circleres++;
			plotpoints = [];
			rad = 0;
	
			plotpoints = [];
			rad = 0.000;
			if(predicting)
				thread draw_line_for_time(predictorvehicle.origin+heightoffset,vistarget.origin+offset,0,0,1,hangtime);
	
			for(i=0;i<circleres;i++)
			{
				plotpoints[plotpoints.size] = vistarget.origin+heightoffset+vector_multiply(anglestoforward((angletoenemy+(rad,90,0))),distacc);
				rad+=circleinc;
			}
			plot_points(plotpoints,0,1,0,hangtime);
	
			plotpoints = [];
			
			rad = 0.000;
			for(i=0;i<circleres;i++)
			{
				plotpoints[plotpoints.size] =  vistarget.origin+heightoffset+vector_multiply(anglestoforward((angletoenemy+(rad,90,0))),distacc*self.turretaccmins);
				rad+=circleinc;
			}
			plot_points(plotpoints,1,1,0,hangtime);
			thread draw_line_for_time(self gettagorigin("tag_flash"),vistarget.origin+offset,1,0,0,hangtime);
			break;
		}		
		#/
		
		if(distance(trace["position"],vistarget.origin+heightoffset)/distacc > 1.5  &&  
		( 
		(predicting &&(!isdefined(trace["entity"]) || trace["entity"] != predictorvehicle)  || 
		(!isdefined(trace["entity"]) || trace["entity"] != vistarget) && vistarget != level.player )
		))
		{
			self.badshotcount++;
			if(self.badshotcount > 5)
			{
				if(type == "vehicle")
				{
					if(predicting)				
						self.enemyque = quetoback(self.enemyque,predictorvehicle);
					else
						self.enemyque = quetoback(self.enemyque,vistarget);
					
				}
				self.badshotcount = 0;
			}
	//				thread draw_line_for_time(self gettagorigin("tag_flash"),vistarget.origin+offset+heightoffset,0,0,1,hangtime);
	//				thread draw_line_for_time(self gettagorigin("tag_flash"),trace["position"],1,0,0,hangtime);
			wait .05;
			self.badshot = true;
			return;
		}
		else
			self.badshotcount = 0;
	//			thread draw_line_for_time(self.origin,offset+heightoffset,0,1,0,4);
	}
	else
	{
		offset = (0,0,0);
		heightoffset = (0,0,0);
	}
	
	if(type != "troop")
		self setTurretTargetvec(vistarget.origin+offset );
	else
		self setTurretTargetent(vistarget,offset );
		
//	self setTurretTargetEnt(vistarget, offset );
	self.turretonvistarg = false;	
	self endon ("turret_fire");
	self endon ("novistarget");
	self waittill ("turret_on_target");
	self.turretonvistarg = true;
}

add_to_arrayfinotinarray ( array, ent )
{
	doadd = 1;
	for(i=0;i<array.size;i++)
	{
		if ( (isdefined (array[i])) && (array[i] == ent) )
			doadd = 0;
	}
	if(doadd == 1)
		array = add_to_array (array, ent);
	return array;
}

stopcheck ( turret, target, radius )
{
//	org1 = flat_origin(turret.checkorg.origin);  //old way was turret.oriign
//	org2 = flat_origin(target.origin);
	
	if ( (!isdefined (turret)) || (!isdefined (target)) )
		return 0;
	
	dist = distance(turret.origin,target.origin);

	if(dist >= radius)
		return 0; 

		// make sure we aren't checking ourselves
	if(turret == target) //&& !(turret.tanksquadfollow && target.tanksquadfollow && turret.squad == target.squad))
		return 0;
		
	if(isdefined(turret.squad) && isdefined(target.squad) && turret.squad == target.squad)
		return 0;
		
	org1 = flat_origin(turret.checkorg.origin);
	forwardvec = anglestoforward(flat_angle(turret.angles));
	normalvec = vectorNormalize(flat_origin(target.origin)-org1);

	//only if guys origins are in front do we check for colisions
	
	if(vectordot(forwardvec,normalvec) <= 0)  
  	return 0;
	if(target == level.player)
	{
		org2 = flat_origin(target.origin);
		normalvec = vectorNormalize(org2 - org1); 
		dot = vectordot(forwardvec,normalvec); 
		if(dot > self.conevectordotnumber)
		{
			return 1; 
		}
		return 0;
	}
	
	for(i=0;i<target.samplepoints.size;i++)
	{
		org2 = flat_origin(target.samplepoints[i].origin);
		normalvec = vectorNormalize(org2-org1);
		dot = vectordot(forwardvec,normalvec);
		if(dot > self.conevectordotnumber)
		{
			if(target.script_team != turret.script_team)
			{
				if(isdefined(turret.enemyque))
					turret.enemyque = add_tofrontarray(turret.enemyque,target);
				if(isdefined(target.enemyque))
					target.enemyque = add_tofrontarray(target.enemyque,turret);										
			}
			return 1;
		}
	}
	return 0;
}

//TODO: move to _utility
drawcone ( origin, angle, coneangle, radius , r, g, b )
{
	threesixtydiv = 64; 
	divs = int(((coneangle*2)/360)*threesixtydiv);
	condivinc = (coneangle*2)/divs;
	plotpoints = [];
	
	angles = (angle[0],angle[1]+coneangle,angle[2]);
	rightvector = anglesToForward(angles);
	rightvector =vector_multiply(rightvector,radius);
	line (origin,origin+rightvector, (r,g,b), 1);

	angles = (angle[0],angle[1]-coneangle,angle[2]);
	leftvector = anglesToForward(angles);
	leftvector = vector_multiply(leftvector,radius);
	line (origin,origin+leftvector, (r,g,b), 1);		

	plotang = angle[1]-coneangle;
	for(i=0;i<divs;i++)
	{
		angles = (angle[0],plotang,angle[2]);		
		vector = anglesToForward(angles);
		plotpoints[plotpoints.size] = origin+vector_multiply(vector,radius);
		plotang += condivinc;
	}
	plotpoints[plotpoints.size] = origin+rightvector;
	
	lastpoint = plotpoints[0];
	for(i=1;i<plotpoints.size;i++)
	{
		line(lastpoint,plotpoints[i],(r,g,b),1);
		lastpoint = plotpoints[i];
	}
}

debug_vehicleavoid ()
{
	/#
	self endon ("death");
	while(1)
	{

		self.truecheck = 0;
//		self.circlecheck = 0;	
	
		while(getdvar("debug_vehicleavoid") != "off" && self.script_avoidvehicles)
		{		
			speed = self getspeedmph(); 
			if(speed < 15)
				speed = 15;  // at 15/mph the cone stays the samee
			drawcone(self.checkorg.origin,self.angles,self.cosinedangle,(speed/15)*self.coneradius,0,1,0);
			for(i=0;i<self.samplepoints.size;i++)
			{
				print3d(self.samplepoints[i].origin,"o", (0,1,0),1);
			}
			print3d (self.origin+(0,0,32), "conecheck: "+self.truecheck, (0, 1, 0), 1);
//			print3d (self.origin,"circlecheck: "+self.circlecheck, (1, 0, 1), 1);
			wait .05;		
		}
		wait .6;
	}
	#/	
}

vehicle_use_unload ()
{
	type = self.vehicletype;
	if(!isdefined(level.vehicle_unloadonuse[type]))
		return;
	self waittill ("trigger");
	self notify ("unload");
}

vehicle_handleunloadevent ()
{
	self endon( "death" );

	type = self.vehicletype;
	while(1)
	{
		self waittill ("unload",who);

		// setting an unload group unloaded guys resets to "default"
		if(isdefined(who))
			self.unload_group = who;
		//makes ai unload
		self notify ("groupedanimevent","unload");

		if(isdefined(level.vehicle_hasMainTurret[self.model]) && level.vehicle_hasMainTurret[self.model] && riders_check())
			self clearTurretTarget();
	}
}

vehicle_resumepathvehicle()
{
	node = undefined;
	if ( isdefined( self.currentnode.target ) )
		node = getent(self.currentnode.target,"targetname");
	else if ( isdefined( self.attachedpath ) )
		node = self.attachedpath;
	if(!isdefined(node))
		return;
	vehicle_dynamicpath(node);
}

vehicle_landvehicle()
{
		self setNearGoalNotifyDist( 2 );
		self sethoverparams(0);
		self	setvehgoalpos_wrap( groundpos(self.origin), 1 ); 
		self waittill ("goal");
}



setvehgoalpos_wrap( origin, bStop )
{
	if ( self.health <= 0 )
		return;
	if(isdefined(self.originheightoffset))
		origin+=(0,0,self.originheightoffset);  // TODO-FIXME: this is temporarily set in the vehicles init_local function working on getting it this requirement removed
	self setvehgoalpos( origin,bStop );
}

vehicle_liftoffvehicle(height)
{
	if(!isdefined(height))
		height = 512;
	dest= self.origin+(0,0,height);
	self setNearGoalNotifyDist(10);
	self	setvehgoalpos_wrap( dest, 1 );
	self waittill ("goal");
}

unload_node(node)
{

//	hoverradius = 10;
//	hoverspeed = 1;
//	hoveraccel = .5;
//	self sethoverparams( hoverradius, hoverspeed, hoveraccel ); 

	self endon ("death");
	pathnode = getnode(node.targetname,"target");
	if(isdefined(pathnode) && self.riders.size)
		for(i=0;i<self.riders.size;i++)
			if(isai(self.riders[i]))
				self.riders[i] thread maps\_spawner::go_to_node(pathnode);
	
//	vehicle_pathdetach();
//	self setjitterparams( (0,0,0), 0, 0 );
//	wait 4; // give the vehicle time to settle into position
//	wait .55;
	
	//wait for it to level out before unloading
	offset = 4;
	stabletime = 1500;
	timer = gettime()+stabletime;
	while(1)
	{
		if(self.angles[0] > offset || self.angles [0] < (-1*offset))
			timer = gettime()+stabletime;
		if(self.angles[2] > offset || self.angles [2] < (-1*offset))
			timer = gettime()+stabletime;
		if(gettime()>timer)
			break;
		wait .05;
	}
	self notify ("unload",node.script_unload);
	self sethoverparams(0);
//	wait .2; // kind of blackhawk specific.  will make variable when necessary.  This is so the hover animation starts befor turning off the helicopters code physics hover
//	timetoreduce = 3;
//	self hoverreducetozeroovertime( hoverradius, hoverspeed, hoveraccel, timetoreduce ); 
//	self sethoverparams( 0 );  // should probably define default hover parameters somewhere and return to those once this sequence is finished
	if(self.riders.size)
		self waittill ("unloaded");
	wait 1; 
	thread vehicle_resumepathvehicle();
}

hoverreducetozeroovertime( hoverradius, hoverspeed, hoveraccel ,time)
{
	incs = time/.05;
	hoverradiusinc = hoverradius/incs;
	hoverspeedinc = hoverspeed/incs;
	
	for(i=0;i<incs;i++)
	{
		self sethoverparams(hoverradiusinc * i , hoverspeedinc * i, hoveraccel);
		wait .05;
	}
}


vehicle_pathdetach()
{
	self.attachedpath = undefined;
	self notify ("newpath");
	
	self setGoalyaw(flat_angle(self.angles)[1]);
	self	setvehgoalpos( self.origin+(0,0,4), 1 );

}

vehicle_to_dummy()
{
	// create a dummy model that takes the place of a vehicle, the vehicle gets hidden
	assertEx( !isdefined( self.modeldummy ), "Vehicle_to_dummy was called on a vehicle that already had a dummy." );
	self.modeldummy = spawn( "script_model", self.origin );
	self.modeldummy setmodel( self.model );
	
	self.modeldummy.origin = self.origin;	
	self.modeldummy.angles = self.angles;
	
	self hide();
	
	self notify ("animtimer");

	//move rider characters to dummy model
	move_riders_here( self.modelDummy );
	
	 //flag for various looping functions keeps them from doing isdefined a lot
	self.modeldummyon = true;
	return self.modeldummy;
}

dummy_to_vehicle()
{
	assertEx( isdefined( self.modeldummy ), "Tried to turn a vehicle from a dummy into a vehicle. Can only be called on vehicles that have been turned into dummies with vehicle_to_dummy." );
	
	if ( self isHelicopter() )
	{
		self.modeldummy.origin = self gettagorigin( "tag_ground" );
	}
	else
	{
		self.modeldummy.origin = self.origin;
		self.modeldummy.angles = self.angles;
	}
	
	self show();

	//move rider characters back to the vehicle
	move_riders_here( self );
	
	//flag for various looping functions keeps them from doing isdefined a lot
	self.modeldummyon = false;
	self.modeldummy delete();
	self.modeldummy = undefined;
	return self.modeldummy;
}

move_riders_here( base )
{
	riders = self.riders;
	//move rider characters to their new location
	for( i=0; i < riders.size; i++ )
	{
		guy = riders[ i ];
		guy unlink();
		animpos = maps\_vehicle_aianim::anim_pos( self, guy.pos );
		guy linkto( base, animpos.sittag, (0, 0, 0), (0, 0, 0) );
		if ( isai( guy ) )
		{
			guy teleport( base gettagorigin( animpos.sittag ) );
		}
		else
		{
			guy.origin = base gettagorigin( animpos.sittag );
		}
	}
}	


setup_targetname_spawners()
{
	level.vehicle_targetname_array = [];
	
	vehicles = getentarray( "script_vehicle", "classname" );
	for ( i = 0; i < vehicles.size; i++ )
	{
		if ( !isdefined( vehicles[ i ].targetname ) )
			continue;
		if ( !isdefined( vehicles[ i ].script_vehicleSpawnGroup ) )
			continue;
			
		targetname = vehicles[ i ].targetname;
		spawngroup = vehicles[ i ].script_vehicleSpawnGroup;
		
		if ( !isdefined( level.vehicle_targetname_array[ targetname ] ) )
			level.vehicle_targetname_array[ targetname ] = [];
			
		level.vehicle_targetname_array[ targetname ][ spawngroup ] = true;
	}
}

spawn_vehicles_from_targetname( name )
{
	// spawns an array of vehicles that all have the specified targetname in the editor,
	// but are deleted at runtime
	assertEx ( isdefined( level.vehicle_targetname_array[ name ] ), "No vehicle spawners had targetname " + name );
	
	array = level.vehicle_targetname_array[ name ];
	keys = getArrayKeys( array );
	
	vehicles = [];
	for ( i =0; i < keys.size; i++ )
	{
		vehicleArray = scripted_spawn( keys[ i ] );
		vehicles = array_combine( vehicles, vehicleArray );
	}
	
	return vehicles;
}

spawn_vehicle_from_targetname( name )
{
	// spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	assertEx( vehicleArray.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicleArray.size + " vehicles, instead of 1" );
	
	return vehicleArray[0];
}

spawn_vehicle_from_targetname_and_drive( name )
{
	// spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	assertEx( vehicleArray.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicleArray.size + " vehicles, instead of 1" );
	
	thread gopath( vehicleArray[0] );
	return vehicleArray[0];
}

spawn_vehicles_from_targetname_and_drive( name )
{
	// spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	for ( i=0; i < vehicleArray.size; i++ )
	{
		thread goPath( vehicleArray[ i ] );
	}

	return vehicleArray;
}

helicopter_dust_kickup()
{
	self endon( "death" );
	
	assert( isdefined( self.vehicletype ) );
	
	maxHeight = 1200;
	minHeight = 350;
	
	slowestRepeatWait = 0.15;
	fastestRepeatWait = 0.05;
	
	numFramesPerTrace = 3;
	doTraceThisFrame = numFramesPerTrace;
	
	defaultRepeatRate = 1.0;
	repeatRate = defaultRepeatRate;
	
	trace = undefined;
	d = undefined;
	
	for (;;)
	{
		if (repeatRate <= 0)
		repeatRate = defaultRepeatRate;
		wait repeatRate;
		
		doTraceThisFrame--;
		
		prof_begin( "helicopter_dust_kickup" );
		
		if ( doTraceThisFrame <= 0 )
		{
			doTraceThisFrame = numFramesPerTrace;
			
			trace = bullettrace( self.origin, self.origin - (0,0,100000), false, self );
			/*
			trace["entity"]
			trace["fraction"]
			trace["normal"]
			trace["position"]
			trace["surfacetype"]
			*/
			
			d = distance( self.origin, trace["position"] );
			
			repeatRate = ( ( d - minHeight ) / ( maxHeight - minHeight ) ) * ( slowestRepeatWait - fastestRepeatWait ) + fastestRepeatWait;
		}
		
		if ( !isdefined( trace ) )
			continue;
		
		assert( isdefined( d ) );
		
		if ( d > maxHeight )
		{
			repeatRate = defaultRepeatRate;
			continue;
		}
		
		if ( isdefined( trace["entity"] ) )
		{
			repeatRate = defaultRepeatRate;
			continue;
		}
		
		if ( !isdefined( trace["position"] ) )
		{
			repeatRate = defaultRepeatRate;
			continue;
		}
		
		if ( !isdefined( trace["surfacetype"] ) )
			trace["surfacetype"] = "dirt";
		//assertEx( isdefined( level._vehicle_effect[self.vehicletype] ), self.vehicletype + " vehicle script hasn't run _tradfx properly" );
		//assertEx( isdefined( level._vehicle_effect[self.vehicletype][trace["surfacetype"]] ), "UNKNOWN SURFACE TYPE: " + trace["surfacetype"] );
		
		prof_end( "helicopter_dust_kickup" );
		
		//if ( level._vehicle_effect[self.vehicletype][trace["surfacetype"]] != -1 )
			//playfx ( level._vehicle_effect[self.vehicletype][trace["surfacetype"]], trace["position"] );
	}
}

tank_crush( crushedVehicle, endNode, tankAnim, truckAnim, animTree, soundAlias )
{
	// Chad G's tank crushing vehicle script. Self corrects for node positioning errors.
	
	assert( isdefined( crushedVehicle ) );
	assert( isdefined( endNode ) );
	assert( isdefined( tankAnim ) );
	assert( isdefined( truckAnim ) );
	assert( isdefined( animTree ) );
	
	
	
	//------------------------------------------------------------------------------------------
	// Create an animatable tank and move the real tank to the next path and store required info
	//------------------------------------------------------------------------------------------
	
	animatedTank = vehicle_to_dummy();
	//self setspeed( 7, 5, 5 );
	
	
	//----------------------------------------------------------------
	// Total time for animation, and correction and uncorrection times
	//----------------------------------------------------------------
	
	animLength = getanimlength( tankAnim );
	move_to_time = ( animLength / 3 );
	move_from_time = ( animLength / 3 );
	
	
	
	//----------------------------------------------------------------------------------------
	// Node information used for calculating both starting and ending points for the animation
	//----------------------------------------------------------------------------------------
	
	// get node vecs
	node_origin = crushedVehicle.origin;
	node_angles = crushedVehicle.angles;
	node_forward = anglesToForward( node_angles );
	node_up = anglesToUp( node_angles );
	node_right = anglesToRight( node_angles );
	
	
	
	//------------------------------------------------------------------------------------
	// Calculate Starting Point for the animation from crushedVehicle and create the dummy
	//------------------------------------------------------------------------------------
	
	// get anim starting point origin and angle
	anim_start_org = getStartOrigin( node_origin, node_angles, tankAnim );
	anim_start_ang = getStartAngles( node_origin, node_angles, tankAnim );
	
	// get anim starting point vecs
	animStartingVec_Forward = anglesToForward( anim_start_ang );
	animStartingVec_Up = anglesToUp( anim_start_ang );
	animStartingVec_Right = anglesToRight( anim_start_ang );
	
	// get tank vecs
	tank_Forward = anglesToForward( animatedTank.angles );
	tank_Up = anglesToUp( animatedTank.angles );
	tank_Right = anglesToRight( animatedTank.angles );
	
	// spawn dummy with appropriate offset
	offset_Vec = ( node_origin - anim_start_org );
	offset_Forward = vectorDot( offset_Vec, animStartingVec_Forward );
	offset_Up = vectorDot( offset_Vec, animStartingVec_Up );
	offset_Right = vectorDot( offset_Vec, animStartingVec_Right );
	dummy = spawn( "script_origin", animatedTank.origin );
	dummy.origin += vector_multiply( tank_Forward, offset_Forward );
	dummy.origin += vector_multiply( tank_Up, offset_Up );
	dummy.origin += vector_multiply( tank_Right, offset_Right );
	
	// set dummy angles to reflect the different in animation starting angles and the tanks actual angles
	offset_Vec = anglesToForward( node_angles );
	offset_Forward = vectorDot( offset_Vec, animStartingVec_Forward );
	offset_Up = vectorDot( offset_Vec, animStartingVec_Up );
	offset_Right = vectorDot( offset_Vec, animStartingVec_Right );
	dummyVec = vector_multiply( tank_Forward, offset_Forward );
	dummyVec += vector_multiply( tank_Up, offset_Up );
	dummyVec += vector_multiply( tank_Right, offset_Right );
	dummy.angles = vectorToAngles( dummyVec );
	
	
	
	//---------------------
	// Debug Lines
	//---------------------
	if ( getdvar( "debug_tankcrush") == "1" )
	{
		// line to where tank1 is
		thread draw_line_from_ent_for_time( level.player, animatedTank.origin, 1, 0, 0, animLength / 2 );
		
		// line to where tank1 SHOULD be
		thread draw_line_from_ent_for_time( level.player, anim_start_org, 0, 1, 0, animLength / 2 );
		
		// line to the dummy
		thread draw_line_from_ent_to_ent_for_time( level.player, dummy, 0, 0, 1, animLength / 2 );
	}
	
	
	
	//----------------------------------------------------------------------
	// Animate the animatable tank and self correct into the crushed vehicle
	//----------------------------------------------------------------------
	
	if ( isdefined( soundAlias ) )
		level thread play_sound_in_space( soundAlias, node_origin );
	
	animatedTank linkto( dummy );
	crushedVehicle useAnimTree( animTree );
	animatedTank useAnimTree( animTree );
	
	assert( isdefined( level._vehicle_effect["tankcrush"]["window_med"] ) );
	assert( isdefined( level._vehicle_effect["tankcrush"]["window_large"] ) );
	
	crushedVehicle thread tank_crush_fx_on_tag( "tag_window_left_glass_fx", level._vehicle_effect["tankcrush"]["window_med"], "veh_glass_break_small", 0.2 );
	crushedVehicle thread tank_crush_fx_on_tag( "tag_window_right_glass_fx", level._vehicle_effect["tankcrush"]["window_med"], "veh_glass_break_small", 0.4 );
	crushedVehicle thread tank_crush_fx_on_tag( "tag_windshield_back_glass_fx", level._vehicle_effect["tankcrush"]["window_large"], "veh_glass_break_large", 0.7 );
	crushedVehicle thread tank_crush_fx_on_tag( "tag_windshield_front_glass_fx", level._vehicle_effect["tankcrush"]["window_large"], "veh_glass_break_large", 1.5 );
	
	crushedVehicle animscripted( "tank_crush_anim", node_origin, node_angles, truckAnim );
	animatedTank animscripted( "tank_crush_anim", dummy.origin, dummy.angles, tankAnim );
	
	dummy moveTo( node_origin, move_to_time, ( move_to_time / 2 ), ( move_to_time / 2 ) );
	dummy rotateTo( node_angles, move_to_time, ( move_to_time / 2 ), ( move_to_time / 2 ) );
	wait move_to_time;
	
	animLength -= move_to_time;
	animLength -= move_from_time;
	
	
	
	//---------------------------------------------------------------
	// Tank plays animation in the exact correct location for a while
	//---------------------------------------------------------------
	wait animLength;
	
	
	
	//-------------------------------------------------------------
	// Calculate Ending Point for the animation from crushedVehicle
	//-------------------------------------------------------------
	
	// get anim ending point origin and angle
	//anim_end_org = anim_start_org + getMoveDelta( tankAnim, 0, 1 );
	temp = spawn( "script_model", ( anim_start_org ) );
	temp.angles = anim_start_ang;
	anim_end_org = temp localToWorldCoords( getMoveDelta( tankAnim, 0, 1 ) );
	anim_end_ang = anim_start_ang + ( 0, getAngleDelta( tankAnim, 0, 1 ), 0 );
	temp delete();
	
	// get anim ending point vecs
	animEndingVec_Forward = anglesToForward( anim_end_ang );
	animEndingVec_Up = anglesToUp( anim_end_ang );
	animEndingVec_Right = anglesToRight( anim_end_ang );
	
	// get ending tank pos vecs
	attachPos = self getAttachPos( endNode );
	tank_Forward = anglesToForward( attachPos[ 1 ] );
	tank_Up = anglesToUp( attachPos[ 1 ] );
	tank_Right = anglesToRight( attachPos[ 1 ] );
	
	// see what the dummy's final origin will be
	offset_Vec = ( node_origin - anim_end_org );
	offset_Forward = vectorDot( offset_Vec, animEndingVec_Forward );
	offset_Up = vectorDot( offset_Vec, animEndingVec_Up );
	offset_Right = vectorDot( offset_Vec, animEndingVec_Right );
	dummy.final_origin = attachPos[ 0 ];
	dummy.final_origin += vector_multiply( tank_Forward, offset_Forward );
	dummy.final_origin += vector_multiply( tank_Up, offset_Up );
	dummy.final_origin += vector_multiply( tank_Right, offset_Right );
	
	// set dummy angles to reflect the different in animation starting angles and the tanks actual angles
	offset_Vec = anglesToForward( node_angles );
	offset_Forward = vectorDot( offset_Vec, animEndingVec_Forward );
	offset_Up = vectorDot( offset_Vec, animEndingVec_Up );
	offset_Right = vectorDot( offset_Vec, animEndingVec_Right );
	dummyVec = vector_multiply( tank_Forward, offset_Forward );
	dummyVec += vector_multiply( tank_Up, offset_Up );
	dummyVec += vector_multiply( tank_Right, offset_Right );
	dummy.final_angles = vectorToAngles( dummyVec );
	
	//---------------------
	// Debug Lines
	//---------------------
	if ( getdvar( "debug_tankcrush") == "1" )
	{
		// line to where tank2 is
		thread draw_line_from_ent_for_time( level.player, self.origin, 1, 0, 0, animLength / 2 );
		
		// line to where tank2 SHOULD be
		thread draw_line_from_ent_for_time( level.player, anim_end_org, 0, 1, 0, animLength / 2 );
		
		// line to the dummy
		thread draw_line_from_ent_to_ent_for_time( level.player, dummy, 0, 0, 1, animLength / 2 );
	}
	
	
	
	//---------------------------------------------------------------
	// Tank uncorrects to the real location of the tank on the spline
	//---------------------------------------------------------------
	
	dummy moveTo( dummy.final_origin, move_from_time, ( move_from_time / 2 ), ( move_from_time / 2 ) );
	dummy rotateTo( dummy.final_angles, move_from_time, ( move_from_time / 2 ), ( move_from_time / 2 ) );
	wait move_from_time;
	
	
	
	//----------------------------------------------------------------------------------------------------------------------
	// Tank is done animating now, remove the animatable tank and show the real one ( they should be perfectly aligned now )
	//----------------------------------------------------------------------------------------------------------------------
	
	self attachPath( endNode );
	dummy_to_vehicle();
}

tank_crush_fx_on_tag( tagName, fxName, soundAlias, startDelay )
{
	if ( isdefined( startDelay ) )
		wait startDelay;
	playfxontag ( fxName, self, tagName );
	if ( isdefined( soundAlias ) )
		self thread play_sound_on_tag ( soundAlias, tagName );
}
loadplayer( position , animfudgetime )
{
	if(!isdefined(animfudgetime))
		animfudgetime = 0;
	assert(isdefined(self.riders));
	assert(self.riders.size);
	guy = undefined;
	for(i=0;i<self.riders.size;i++)
	{
		if(self.riders[i].pos == position)
		{
			guy = self.riders[i];
			guy.drone_delete_on_unload = true;
			break;
		}
	}
	thread show_rigs( position );
	
	assert(isdefined(guy));
	animpos = maps\_vehicle_aianim::anim_pos(self,position);
	
	//playerlinktodelta( <linkto entity>, <tag>, <viewpercentag fraction>, <right arc>, <left arc>, <top arc>, <bottom arc> )
	level.player playerlinktodelta (guy,"tag_origin",1.0,20,80,90,90);

	guy hide();
	
	animtime = getanimlength(animpos.getout);
	animtime -= animfudgetime;
	self waittill ("unload");
//	guy waittill ("jumpedout");
	if(isai(guy))
		guy pushplayer (false);
	else
		guy notsolid();
		
	wait animtime;
	level.player unlink();
//	guy delete();
	
}

show_rigs( position )
{
	wait .01;
	self thread maps\_vehicle_aianim::getout_rigspawn(self,position); // spawn the getoutrig for this position
	if(!self.riders.size)
		return;
	for(i=0;i<self.riders.size;i++)
		self thread maps\_vehicle_aianim::getout_rigspawn(self,self.riders[i].pos);
}




// IW_BOND_CONFLICT
//MANUALLY PORTED FROM IW DROP FOLDER - PJL


 /* 
 ============= 
 ///ScriptDocBegin
"Name: build_aianims( <aithread> , <vehiclethread> )"
"Summary: called in individual vehicle file - set threads for ai animation and vehicle animation assignments"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <aithread> : ai thread"
"OptionalArg: <vehiclethread> : vehicle thread"
"Example: 	build_aianims( ::setanims, ::set_vehicle_anims );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_aianims( aithread, vehiclethread )
{
	level.vehicle_aianims[ level.vttype ] = [[ aithread ]]();
	if( isdefined( vehiclethread ) )
		level.vehicle_aianims[ level.vttype ] = [[ vehiclethread ]]( level.vehicle_aianims[ level.vttype ] );
}


 /* 
 ============= 
 ///ScriptDocBegin
"Name: build_team( <team> )"
"Summary: called in individual vehicle file - sets team"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <team> : team"
"Example: 	build_team( "allies" );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_team( team )
{
	level.vehicle_team[ level.vttype ] = team; 
}


 /* 
 ============= 
 ///ScriptDocBegin
"Name: build_unload_groups( <health> , <minhealth> , <maxhealth> , )"
"Summary: called in individual vehicle file - sets health for vehicles"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <health> :  health"
"OptionalArg: <minhealth> : randomly chooses between the minhealth, maxhealth"
"OptionalArg: <maxhealth> : randomly chooses between the minhealth, maxhealth"
"Example: 			build_life( 999, 500, 1500 );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_life( health, minhealth, maxhealth )
{
	level.vehicle_life[ level.vttype ] = health; 
	level.vehicle_life_range_low[ level.vttype ] = minhealth; 
	level.vehicle_life_range_high[ level.vttype ] = maxhealth; 
}


build_destructible( model, destructible )
{
	assert( isdefined( model ) );
	assert( isdefined( destructible ) );
	if( model != level.vtmodel )
		return; 
	struct = spawnstruct();
	struct.destuctableInfo = maps\_destructible_types::makeType( destructible );; 
	struct thread maps\_destructible::precache_destructibles();
	
	level.destructible_model[ level.vtmodel ] = destructible; 
}

/* 
 ============= 
 ///ScriptDocBegin
"Name: build_localinit( <init_thread> )"
"Summary: called in individual vehicle file - mandatory for all vehicle files, this sets the individual init thread for those special sequences, it is also used to determine that a vehicle is being precached or not"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <init_thread> :  local thread to the vehicle to be called when it spawns"
"Example: 			build_localinit( ::init_local );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_localinit( init_thread )
{
	level.vehicleInitThread[ level.vttype ][ level.vtmodel ] = init_thread; 
}


/* 
 ============= 
 ///ScriptDocBegin
"Name: build_template( <type> , <model> , <typeoverride> )"
"Summary: called in individual vehicle file - mandatory to call this in all vehicle files at the top!"
"Module: vehicle_build( vehicle.gsc )"
"CallOn: "
"MandatoryArg: <type> : vehicle type to set"
"MandatoryArg: <model> : model to set( this is usually generated by the level script )"
"OptionalArg: <typeoverride> : this overrides the type, used for copying a vehicle script"
"Example: 	build_template( "bmp", model, type );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_template( type, model, typeoverride )
{
	if( isdefined( typeoverride ) )
		type = typeoverride; 
	precachevehicle( type );

	if( !isdefined( level.vehicle_death_fx ) )
		level.vehicle_death_fx = []; 
	if( 	!isdefined( level.vehicle_death_fx[ type ] ) )
		level.vehicle_death_fx[ type ] = []; // can have overrides
		
	level.vehicle_compassicon[ type ] = []; 
	level.vehicle_team[ type ] = "axis"; 
	level.vehicle_life[ type ] = 999; 
	level.vehicle_hasMainTurret[ type ] = false; 
	level.vtmodel = model; 
	level.vttype = type; 
}


///////////////////////////////////////////////////////////////////
// BOND MOD
//
// MQL 11/20/07: ALL NEW BOND SCRIPTS GO UNDER HERE
//
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
// bond_veh_delete_fx - delete particle if veh doesn't exist
///////////////////////////////////////////////////////////////////
bond_veh_delete_fx( entVeh )
{
	while( true )
	{
		if( !IsDefined( entVeh ) )
		{
			if( IsDefined( self ) )
			{
				self Delete();
			}
			return;
		}
		else
		{
			wait( 0.15 );
		}
	}
}


///////////////////////////////////////////////////////////////////
// bond_veh_death - monitor vehicle death. Call fx & S-plosion on death
///////////////////////////////////////////////////////////////////
#using_animtree( "vehicles" );
bond_veh_death( iRadius, iMaxDmg, iMinDmg, sTag )
{
	// set defaults
	if( !IsDefined( iRadius ) )
	{
		iRadius = 256;
	}
	iRadiusInn = iRadius/2;
	if( !IsDefined( iMaxDmg ) )
	{
		iMaxDmg = 20000;
	}
	if( !IsDefined( iMinDmg ) )
	{
		iMinDmg = 20000;
	}
	if( !IsDefined( sTag ) )
	{
		sTag = "tag_death_fx";
	}
	if( !IsDefined( level.VehicleExplosionCanKillPlayer ) )
	{
		level.VehicleExplosionCanKillPlayer = true;
	}	

	type = self.vehicletype;
	
	if( IsDefined( self ) )
	{
		//self thread print3Dmessage( (0,0,0), "bond_veh_death");

		// wait for vehicle to die
		self waittill( "death" );
	}
	else
	{
		return;
	}

	if( IsDefined( self ) )
	{
		// set anim tree
		self UseAnimTree( #animtree );
	}
	else
	{
		return;
	}

	// play anim
	self.tire_l_frnt = false;
	self.tire_r_frnt = false;
	self.tire_l_back = false;
	self.tire_r_back = false;
	wait( 0.05 );
	self SetAnimKnob( %v_auto_explode, 1.0, 0.2, 1.0 );


	// do large damage radius
	entOrigin = Spawn( "script_origin", self.origin );

	playerWasDemiGod = level.player isdemigod();

	if( !level.VehicleExplosionCanKillPlayer )
	{
		level.player setdemigod(true);
	}

	entOrigin RadiusDamage( self.origin + ( 0, 0, 50 ), iRadius, iMaxDmg, iMinDmg );

	if(  !level.VehicleExplosionCanKillPlayer && !playerWasDemiGod )
	{	
		level.player setdemigod(false);
	}

	// play fx
	if( IsDefined( level.vehicle_death_fx[type] ) )
	{
		PlayfxOnTag( level.vehicle_death_fx[type], self, sTag );
	}

	// physics explosion
	PhysicsExplosionSphere( entOrigin.origin, iRadius, iRadiusInn, 25);

	// earthquake
	Earthquake( 0.25, 3, entOrigin.origin, 1024 );

	// delete origin
	wait( 0.05 );
	entOrigin Delete();
}


print3Dmessage( offset, message )
{
	self endon("death");

	while ( 1 )
	{
		print3d (self.origin+offset, message, (0.5,1,0.5), 1, 1);
		wait (0.05);
	}
}

///////////////////////////////////////////////////////////////////
// bond_veh_flat_tire - monitor tires & play flat animation when shot
///////////////////////////////////////////////////////////////////
#using_animtree( "vehicles" );
bond_veh_flat_tire()
{
	if( !IsDefined( self ) )
	{
		return;
	}

	// setup tires to undamaged flag
	self.tire_l_frnt = true;
	self.tire_r_frnt = true;
	self.tire_l_back = true;
	self.tire_r_back = true;

	// wait for damage
	while( IsDefined( self ) )
	{
		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName ); 

		// filter out melee
		if ( issubstr( tolower( iType ), "melee" )  )
		{
			continue;
		}

		// continue if no damage is done
		if( !IsDefined( iDamage ) )
		{
			continue;
		}
		if( iDamage <= 0 )
		{
			continue;
		}

		// set anim tree
		self UseAnimTree( #animtree );

		// identify part damaged & animate
		switch( sTagName )
		{
			case "tag_left_wheel_01_jnt":
				if( self.tire_l_frnt )
				{
					/#
						if( GetDVarInt( "secr_camera_debug" ) == 1 )
						{	
							Print3d( self.origin + (0, 0, 64), "LEFT FRONT DAMAGED", (0, 1, 0), 1, 1, 90 );
						}
					#/

						// update tire to damaged & animate
						self.tire_l_frnt = false;
						self SetAnim( %v_auto_fl_pop, 1.0, 1.0, 1.0 );
				}
				else
				{
					/#
						if( GetDVarInt( "secr_camera_debug" ) == 1 )
						{	
							Print3d( self.origin + (0, 0, 64), "LEFT FRONT NO EFFECT", (0, 1, 0), 1, 1, 90 );
						}
					#/
				}
				break;

			case "tag_left_wheel_02_jnt":
				if( self.tire_l_back )
				{
					/#
						if( GetDVarInt( "secr_camera_debug" ) == 1 )
						{	
							Print3d( self.origin + (0, 0, 64), "LEFT BACK DAMAGED", (0, 1, 0), 1, 1, 90 );
						}
					#/

						// update tire to damaged & animate
						self.tire_l_back = false;
						self SetAnim( %v_auto_bl_pop, 1.0, 1.0, 1.0 );
				}
				else
				{
					/#
						if( GetDVarInt( "secr_camera_debug" ) == 1 )
						{	
							Print3d( self.origin + (0, 0, 64), "LEFT BACK NO EFFECT", (0, 1, 0), 1, 1, 90 );
						}
					#/
				}
				break;

			case "tag_right_wheel_01_jnt":
				if( self.tire_r_frnt )
				{
					/#
						if( GetDVarInt( "secr_camera_debug" ) == 1 )
						{	
							Print3d( self.origin + (0, 0, 64), "RIGHT FRONT DAMAGED", (0, 1, 0), 1, 1, 90 );
						}
					#/

						// update tire to damaged & animate
						self.tire_r_frnt = false;
						self SetAnim( %v_auto_fr_pop, 1.0, 1.0, 1.0 );
				}
				else
				{
					/#
						if( GetDVarInt( "secr_camera_debug" ) == 1 )
						{	
							Print3d( self.origin + (0, 0, 64), "RIGHT FRONT NO EFFECT", (0, 1, 0), 1, 1, 90 );
						}
					#/
				}
				break;

			case "tag_right_wheel_02_jnt":
				if( self.tire_r_back )
				{
					/#
						if( GetDVarInt( "secr_camera_debug" ) == 1 )
						{	
							Print3d( self.origin + (0, 0, 64), "RIGHT BACK DAMAGED", (0, 1, 0), 1, 1, 90 );
						}
					#/

						// update tire to damaged & animate
						self.tire_r_back = false;
						self SetAnim( %v_auto_br_pop, 1.0, 1.0, 1.0 );
				}
				else
				{
					/#
						if( GetDVarInt( "secr_camera_debug" ) == 1 )
						{	
							Print3d( self.origin + (0, 0, 64), "RIGHT BACK NO EFFECT", (0, 1, 0), 1, 1, 90 );
						}
					#/
				}
				break;

			default:
				/#
					if( GetDVarInt( "secr_camera_debug" ) == 1 )
					{	
						Print3d( self.origin + (0, 0, 64), sTagName, (0, 1, 0), 1, 1, 90 );
					}
				#/
		}
	}
}


///////////////////////////////////////////////////////////////////
// bond_veh_running_lights - turn on lights and monitor for destruction
///////////////////////////////////////////////////////////////////
bond_veh_running_lights()
{
	// BOND_MOD
	// 03/05/08: Hack to not play fx on invisible vehicles
	if (IsDefined(self.script_ignoreme) && self.script_ignoreme)
	{
		return;
	}
	// !BOND_MOD

	if( !IsDefined( self ) )
	{
		return;
	}

	type = self.vehicletype;

	// setup lights
	if(  ( type == "sedan" ) || ( type == "humvee50cal" ) || ( type == "van" ) || ( type == "suv" ))
	{
		self thread bond_veh_lights( level.vehicle_headlight_fx[type], "tag_light_l_front" );
		self thread bond_veh_lights( level.vehicle_headlight_fx[type], "tag_light_r_front" );
		self thread bond_veh_lights( level.vehicle_breaklight_fx[type], "tag_light_l_back" );
		self thread bond_veh_lights( level.vehicle_breaklight_fx[type], "tag_light_r_back" );
	}

	if( type == "blackhawk" )
	{
		self thread bond_veh_lights( level.vehicle_searchlight_fx[type], "tag_flash" );
		self thread bond_veh_lights( level.vehicle_tailrotor_light_fx[type], "tag_light_tail" );
		self thread bond_veh_lights( level.vehicle_rightwing_light_fx[type], "tag_light_l_wing" );
		self thread bond_veh_lights( level.vehicle_leftwing_light_fx[type], "tag_light_r_wing" );
	}
}

bond_veh_lights( iFX, sTag )
{
	// BOND_MOD
	// 03/05/08: Hack to not play fx on invisible vehicles
	if (IsDefined(self.script_ignoreme) && self.script_ignoreme)
	{
		return;
	}
	// !BOND_MOD

	// spawn tag origin
	entOrigin = Spawn( "script_model", self GetTagOrigin( sTag ) );
	entOrigin.angles = self GetTagAngles( sTag );
	entOrigin SetModel( "tag_origin" );
	entOrigin LinkTo( self );

	// set up delete if veh no longer exists
	entOrigin thread bond_veh_delete_fx( self );

	// play particle fx
	if( IsDefined( iFx ) )
	{
		PlayfxOnTag( iFx, entOrigin, "tag_origin" );
	}

	// wait for damage to shut it off
	while( IsDefined( entOrigin ) )
	{
		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName ); 
		
		if( sTagName == sTag )
		{
			entOrigin Delete();
		}
	}
}


///////////////////////////////////////////////////////////////////
// bond_veh_exhaust - turn on exhaust and monitor veh destruction
///////////////////////////////////////////////////////////////////
bond_veh_exhaust()
{
	// BOND_MOD
	// 03/05/08: Hack to not play fx on invisible vehicles
	if (IsDefined(self.script_ignoreme) && self.script_ignoreme)
	{
		return;
	}
	// !BOND_MOD

	type = self.vehicletype;

	// spawn tag origin
	entOrigin = Spawn( "script_model", self GetTagOrigin( "tag_tailpipe" ) );
	entOrigin.angles = self GetTagAngles( "tag_tailpipe" );
	entOrigin SetModel( "tag_origin" );
	entOrigin LinkTo( self );

	// set up delete if veh no longer exists
	entOrigin thread bond_veh_delete_fx( self );

	// play particle fx
	if( IsDefined( level.vehicle_exhaust_fx[type] ) )
	{
		PlayfxOnTag( level.vehicle_exhaust_fx[type], entOrigin, "tag_origin" );
	}

	// wait for vehicle destruction and delete
	if( IsDefined( self ) )
	{
		self waittill( "death" );
	}
	else
	{
		entOrigin Delete();
		return;
	}
	entOrigin Delete();
}


///////////////////////////////////////////////////////////////////
// bond_veh_roadfx - turn on veh road fx and monitor for death
///////////////////////////////////////////////////////////////////
bond_veh_roadfx()
{
	//type = self.vehicletype;

	//// spawn tag origins
	//entOrigin = Spawn( "script_model", self GetTagOrigin( "tag_body" ) );
	//entOrigin.angles = self GetTagAngles( "tag_body" );
	//entOrigin SetModel( "tag_origin" );
	//entOrigin LinkTo( self );

	//// set up delete if veh no longer exists
	//entOrigin thread bond_veh_delete_fx( self );

	//// play particle fx
	//if( IsDefined( level.vehicle_exhaust_fx[type] ) )
	//{
	//	PlayfxOnTag( level.vehicle_exhaust_fx[type], entOrigin, "tag_origin" );
	//}

	//// wait for vehicle destruction and delete
	//self waittill( "death" );
	//entOrigin Delete();
}