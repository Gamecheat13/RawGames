#include maps\_utility;
#using_animtree ("generic_human");
main()
{
	if (getcvar("debug_vclogin") == "")
		setcvar("debug_vclogin", "off");
	if (getcvar("debug_crashpaths") == "")
		setcvar("debug_crashpaths", "off");
	if (getcvar("debug_vehiclespeed") == "")
		setcvar("debug_vehiclespeed", "off");
	if (getcvar("debug_tankgod") == "")
		setcvar("debug_tankgod", "off");
	if (getcvar("debug_vehiclesquad") == "")
		setcvar("debug_vehiclesquad", "off");
	if (getcvar("debug_vehicleresume") == "")
		setcvar("debug_vehicleresume", "off");
	if (getcvar("debug_vehicleavoid") == "")
		setcvar("debug_vehicleavoid", "off");
	if (getcvar("debug_vehicleturretaccuracy") == "")
		setcvar("debug_vehicleturretaccuracy", "off");
	if (getcvar("debug_vehicledetour") == "")
		setcvar("debug_vehicledetour", "off");
	if (getcvar("debug_vehiclefocusfire") == "")
		setcvar("debug_vehiclefocusfire", "off");
	if (getcvar("debug_vehicleattackthreats") == "")
		setcvar("debug_vehicleattackthreats", "off");  //_tank.gsc
	if (getcvar("debug_vehiclesetspeed") == "")
		setcvar("debug_vehiclesetspeed", "off");
		
		
	precacheRumble("tank_rumble");
	level.resumespeed = 5;
	level.turretfiretime = 4;
	
	level.obscure = [];
	level.linkedspawners = 0;
	level.tanks = [];
	level.script_vehicleGroupDelete = [];
	level.script_vehiclefocusfiregroup = [];
	level.script_VehicleAttackgroup = [];
	level.script_VehicleSpawngroup = [];
	level.script_VehicleStartMove = [];
	level.script_vehicledeathgate = [];
	level.script_vehiclerideai =  [];
	level.script_dronenodetime = [];
	level.script_dronenodetime_last = [];
	level.script_vehiclewalkai =  [];
	level.script_vehicledeathswitch = [];
	level.script_vehicleridespawners = [];
	level.script_vehiclewalkspawners = [];
	level.script_gatetrigger = [];
	level.vehicle_crashpaths = [];
	level.vehicle_target = [];
	level.vehicle_link = [];
	level.avoiddelay = 0;
	level.attack_threats_delay = 0;
	level.playervehicle = spawn ("script_origin",(0,0,0)); // no isdefined for level.playervehicle 
	level.playervehiclenone = level.playervehicle; // no isdefined for level.playervehicle 
	level.vehicle_detourpaths = [];
	level.vehicle = [];
	level.BlowupAnimDirection = []; // for _tankai
	level.spawnedvehicles = [];
	level.vehicle_squad_followdelay = 0;
	level.script_attackorgs = [];
	level.vehiclecorpses = [];
	if(!isdefined(level.deathfx_extra))
		level.deathfx_extra = [];
	if(!isdefined(level._vehicledriveidle))
		level._vehicledriveidle = [];
	debug_vclogin();
	
	
	origins = getentarray("script_origin","classname");
	for(i=0;i<origins.size;i++)
	{
		if(isdefined(origins[i].script_attackorgs))
		{
			
			if(!isdefined(level.script_attackorgs[origins[i].script_attackorgs]))
			{
				if(isdefined(origins[i].targetname))
					origins[i].triggertarget = getent(origins[i].targetname,"target");
				level.script_attackorgs[origins[i].script_attackorgs] = origins[i];
			}
			else
				assertmsg("multiple script origins with script_attackorgs: "+origins[i].script_attackorgs);
			setup_attackorg_chain(origins[i]);
		}
	}
		
	ai = getaiarray();
	for(i=0;i<ai.size;i++)
	{
		if(isdefined(ai[i].script_vehicleride))
		{
			if(!isdefined(level.script_vehiclerideai[ai[i].script_vehicleride]))
				level.script_vehiclerideai[ai[i].script_vehicleride] = [];
			level.script_vehiclerideai[ai[i].script_vehicleride]
			[level.script_vehiclerideai[ai[i].script_vehicleride].size] = ai[i];
		}
		else
		if(isdefined(ai[i].script_vehiclewalk))
		{
			if(!isdefined(level.script_vehiclewalkai[ai[i].script_vehiclewalk]))
				level.script_vehiclewalkai[ai[i].script_vehiclewalk] = [];
			level.script_vehiclewalkai[ai[i].script_vehiclewalk]
			[level.script_vehiclewalkai[ai[i].script_vehiclewalk].size] = ai[i];
		}
	}
	ai = getspawnerarray();
	for(i=0;i<ai.size;i++)
	{
		if(isdefined(ai[i].script_vehicleride))
		{
			if(!isdefined(level.script_vehicleridespawners[ai[i].script_vehicleride]))
				level.script_vehicleridespawners[ai[i].script_vehicleride] = [];
			
			level.script_vehicleridespawners[ai[i].script_vehicleride]
			[level.script_vehicleridespawners[ai[i].script_vehicleride].size] = ai[i];
			
		}
		if(isdefined(ai[i].script_vehiclewalk))
		{
			if(!isdefined(level.script_vehiclewalkspawners[ai[i].script_vehiclewalk]))
				level.script_vehiclewalkspawners[ai[i].script_vehiclewalk] = [];
			
			level.script_vehiclewalkspawners[ai[i].script_vehiclewalk]
			[level.script_vehiclewalkspawners[ai[i].script_vehiclewalk].size] = ai[i];
		}
	}
	processtriggers = [];
	level.linkedpaths = [];
	pathnodes = getallvehiclenodes();
	level.onramps = [];
	level.vehicle_startnodes = [];
	triggernodes = [];
	pathnodelist = [];
	for(i=0;i<pathnodes.size;i++)
	{
		processtrigger = false;
		if(isdefined(pathnodes[i].script_noteworthy) && pathnodes[i].script_noteworthy == "onramp")
			level.onramps[level.onramps.size] = pathnodes[i];
		if(isdefined(pathnodes[i].script_noteworthy) && pathnodes[i].script_noteworthy == "trigger")
			processtrigger = true;
		if(isdefined(pathnodes[i].spawnflags)&& (pathnodes[i].spawnflags & 1))
		{
			if(isdefined(pathnodes[i].script_crashtype))
				level.vehicle_crashpaths[level.vehicle_crashpaths.size] = pathnodes[i];
				
			level.vehicle_startnodes[level.vehicle_startnodes.size] = pathnodes[i];
		}
		if(isdefined(pathnodes[i].script_vehicledetour))
		{
			if(!isdefined(level.vehicle_detourpaths[pathnodes[i].script_vehicledetour]))
				level.vehicle_detourpaths[pathnodes[i].script_vehicledetour] =[];
			level.vehicle_detourpaths[pathnodes[i].script_vehicledetour]		
			[level.vehicle_detourpaths[pathnodes[i].script_vehicledetour].size] = pathnodes[i];
			if(level.vehicle_detourpaths[pathnodes[i].script_vehicledetour].size > 2)
				println("more than two script_vehicledetour grouped in group number: ",pathnodes[i].script_vehicledetour);
		}
		if(isdefined(pathnodes[i].script_linkname))
		{
			level.linkedpaths[level.linkedpaths.size] = pathnodes[i];
		}
		if(isdefined(pathnodes[i].script_vehiclesquad))
		{
			if(isdefined(pathnodes[i].script_vehiclesquadleader))
			{
				level.VehicleSquadLeaderPosition[pathnodes[i].script_vehiclesquad] = pathnodes[i];
				processtrigger = true;
			}
		}
		if(isdefined(pathnodes[i].script_gatetrigger))
		{
			if(!isdefined(level.script_gatetrigger[pathnodes[i].script_gatetrigger]))
				level.script_gatetrigger[pathnodes[i].script_gatetrigger] = [];
			level.script_gatetrigger[pathnodes[i].script_gatetrigger]
			[level.script_gatetrigger[pathnodes[i].script_gatetrigger].size] = pathnodes[i];
			pathnodes[i].gateopen = false;
		}
		if(isdefined(pathnodes[i].script_vehicledeathgate))
		{
			pathnodes[i].gateopen = false;
			processtrigger = true;
			thread path_gate_deathwait(pathnodes[i]);
		}
		if(isdefined(pathnodes[i].script_vehicledeathswitch))
			thread path_vehicledeathswitch(pathnodes[i]);	
			
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
			isdefined(pathnodes[i].script_lvlmsg)				||
			isdefined(pathnodes[i].script_shots)				||
			isdefined(pathnodes[i].script_accuracy)				||
			isdefined(pathnodes[i].script_deathroll)			||
			isdefined(pathnodes[i].script_attackai)				||
			isdefined(pathnodes[i].script_avoidvehicles)			||
			isdefined(pathnodes[i].script_turningdir)			||
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
		{
			for(j=0;j<detourpaths.size;j++)
			{	
				if(!isdefined(detourpaths[j].processtrigger))
					processtriggers[processtriggers.size] = detourpaths[j];
			}
		}
//			processtriggers=array_merge(processtriggers,detourpaths);  //expensive .. hmmm 
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
	allvehiclesprespawn = [];
	allvehicles = getentarray("script_vehicle","classname");
	allvehicles = array_combine(allvehicles,getentarray("vehiclespawnmodel","targetname"));
	allvehiclesprespawn = vehicles_setup(allvehicles);
	level.debugvclogin = 0;
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
	//tanks setup for tanks who aren't spawned
	for(i=0;i<nonspawned.size;i++)
		vehicle_init(nonspawned[i]);

	array_levelthread(getvehiclenodearray("godon","script_noteworthy"),::godon);
	array_levelthread(getvehiclenodearray("godoff","script_noteworthy"),::godoff);
	array_levelthread(getvehiclenodearray("forcekill","script_noteworthy"),::forcekillnode);
	array_levelthread(getvehiclenodearray("unload_continue","script_noteworthy"),::unload_continue);
	array_levelthread (processtriggers, ::trigger_process, allvehiclesprespawn);

}

setup_attackorg_chain(origin)
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

delete_group (vehicle, group)
{
	if(isdefined(vehicle.walkers))
		for(j=0;j<vehicle.walkers.size;j++)
			if(issentient(vehicle.walkers[j]))
				vehicle.walkers[j] delete();
	if(isdefined(vehicle.riders))
		for(j=0;j<vehicle.riders.size;j++)
			if(issentient(vehicle.riders[j]))
				vehicle.riders[j] delete();
	if(isdefined(vehicle.getinorgs))
		for(i=0;i<vehicle.getinorgs.size;i++)
			vehicle.getinorgs[i] delete();	
	vehicle notify ("delete");
	wait .1;
	if(isdefined(vehicle))
		vehicle delete();
}

trigger_process (trigger,vehicles)
{
	if(isdefined(trigger.classname) && (trigger.classname == "trigger_multiple" || trigger.classname == "trigger_radius" || trigger.classname == "trigger_lookat"))
			bTriggeronce = true;
	else
		bTriggeronce = false;
		
	if(isdefined(trigger.script_noteworthy) && trigger.script_noteworthy == "trigger_multiple")
		bTriggeronce = false;
		
	linkMap = [];
	linkvehicles = [];
	vehiclenames = [];
	gates = [];
	groupvehicles = [];
	targetedvehicle = undefined;

	if ( isdefined( trigger.script_linkTo ) )
	{
		links = strtok( trigger.script_linkTo, " " );
		linkMap = [];
		for ( i = 0; i < links.size; i++ )
			linkMap[links[i]] = true;
		links = undefined;
	}

	if ( isdefined( trigger.script_gatetrigger ) )
	{
		gates = getlinks_array( level.linkedpaths, linkMap );
		script_gatetrigger = level.script_gatetrigger[trigger.script_gatetrigger];
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
	if(isdefined(trigger.script_VehicleAttackgroup) && !isdefined(level.script_VehicleAttackgroup[trigger.script_VehicleAttackgroup]))
		level.script_VehicleAttackgroup[trigger.script_VehicleAttackgroup] = [];
	if(isdefined(trigger.script_vehiclefocusfiregroup) && !isdefined(level.script_vehiclefocusfiregroup[trigger.script_vehiclefocusfiregroup]))
		level.script_vehiclefocusfiregroup[trigger.script_vehiclefocusfiregroup] = [];
	if(isdefined(trigger.script_vehicledeathgate) && !isdefined(level.script_vehicledeathgate[trigger.script_vehicledeathgate]))
		level.script_vehicledeathgate[trigger.script_vehicledeathgate] = [];
		
	script_turret = 						isdefined(trigger.script_turret);
	script_delay = 						isdefined(trigger.script_delay);
	script_linkto = 						isdefined(trigger.script_linkto);
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
	script_lvlmsg = 						isdefined(trigger.script_lvlmsg);  //fixme once once bugs are resolved and find within .maps gives no results remove
	script_shots = 						isdefined(trigger.script_shots);
	script_accuracy = 						isdefined(trigger.script_accuracy);
	script_deathroll =						isdefined(trigger.script_deathroll);
	script_vehiclesquadleader = 				isdefined(trigger.script_vehiclesquadleader);
	script_attackai = 						isdefined(trigger.script_attackai);
	script_vehicledeathgate =				isdefined(trigger.script_vehicledeathgate);
	script_avoidvehicles = 					isdefined(trigger.script_avoidvehicles);
	script_vehicledisabletrigger = 			isdefined(trigger.script_vehicledisabletrigger);
	script_turningdir = 					isdefined(trigger.script_turningdir);
	detoured = 							isdefined(trigger.detoured);
	gotrigger = true;

	if(script_vehicledisabletrigger)
		level endon ("disabletriggers"+trigger.script_vehicledisabletrigger);

//	if(script_vehicledisabletrigger && (!script_noteworthy || (script_noteworthy && trigger.script_noteworthy != "trigger")) )
//		trigger thread trigger_disable();
	
	while(gotrigger)
	{
		trigger waittill ("trigger",other);
		if(isdefined(trigger.enabled) && !trigger.enabled)
			trigger waittill ("enable");
		triggererisdefined = isdefined(other);
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
			if(!isdefined(level.script_vehicleGroupDelete[trigger.script_vehicleGroupDelete]))
			{
				println("failed to find deleteable vehicle with script_vehicleGroupDelete group number: ",trigger.script_vehicleGroupDelete);
				level.script_vehicleGroupDelete[trigger.script_vehicleGroupDelete] = [];
			}
			array_levelthread(array_merge(level.script_vehicleGroupDelete[trigger.script_vehicleGroupDelete],targs), ::delete_group, trigger.script_vehicleGroupDelete);  //was _links
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
			if(!isdefined(level.script_VehicleStartMove[trigger.script_VehicleStartMove]) && !targs.size)
			{
				assertmsg("script_VehicleStartMove trigger hit with nothing to move");
				return;
			}
			array_levelthread(array_merge(level.script_VehicleStartMove[trigger.script_VehicleStartMove],targs), ::gopath);  // was _links
			
		}
		if(!(triggererisdefined))
			continue;
		if(script_vehiclefocusfiregroup && triggererisdefined)
		{
			if(other == level.player && level.playervehicle.classname == "script_vehicle")
				array_levelthread(array_merge(level.script_vehiclefocusfiregroup[trigger.script_vehiclefocusfiregroup],targs), ::focusfire,level.playervehicle); //was _links
			else
				array_levelthread(array_merge(level.script_vehiclefocusfiregroup[trigger.script_vehiclefocusfiregroup],targs), ::focusfire,other); //was _links
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
				other notify ("attack",array_merge_links(level.script_VehicleAttackgroup[trigger.script_VehicleAttackgroup],targs),"attack_all");
			else
				other notify ("attack",array_merge_links(level.script_VehicleAttackgroup[trigger.script_VehicleAttackgroup],targs));
			
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
			other notify (trigger.script_noteworthy);
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
		
	}
}

path_detour(node)
{
	if ( (isdefined(node.detoured)) && (node.detoured == 0) )
	{
		if ( self != level.playervehicle )
		{
			detourpath = undefined;
			detournode = getvehiclenode(node.target,"targetname");
			for(j=0;j<level.vehicle_detourpaths[detournode.script_vehicledetour].size;j++)
			{
				if(level.vehicle_detourpaths[detournode.script_vehicledetour][j] != detournode)
					if(!islastnode(level.vehicle_detourpaths[detournode.script_vehicledetour][j]))
						detourpath = level.vehicle_detourpaths[detournode.script_vehicledetour][j];
				
			}

			if(isdefined(detourpath))
			{
				if(isdefined(detourpath.script_crashtype))
				{
					if(isdefined(self.deaddriver) || self.health <= 0 || detourpath.script_crashtype == "forced" || (level.debugvclogin))  //script_noteworthy was for forced crash path I think
					{
						if((!isdefined (detourpath.derailed)) || (isdefined(detourpath.script_crashtype) && detourpath.script_crashtype == "plane"))
						{
							self notify ("crashpath", detourpath);
							detourpath.derailed = 1;
							self notify ("newpath");
							self setSwitchNode (node,detourpath);
							
							return;
						}
					}				
				}
				else if(!(isdefined(detournode.scriptOverride) && detournode.scriptOverride))
				{
					self thread debug_vehicledetour(detournode,detourpath);
					self notify ("newpath");
					self setswitchnode(detournode,detourpath);
					if(!islastnode(detournode) && !(isdefined(node.scriptdetour_persist) && node.scriptdetour_persist) )
						node.detoured = 1;
					self.attachedpath = detourpath;
					thread vehicle_paths();
					return;
				}
			}
		}
	}
	else if(isdefined(node.toggledetour) && node.toggledetour)
		node.detoured = 0;

}



squad_breaker()
{
	self notify ("breaksquad");
	self.tanksquadfollow = false;
	script_resumespeed("breaksquad",level.resumespeed);	
}

turret_queorgs(hintnum,looping)
{
	if(!isdefined(looping))
		looping = false;
	println("queing orgs");
	orgs = [];
	targ = level.script_attackorgs[hintnum];
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
				if(looping)
					targ.script_shots = 1;
				targ.hinter = false;
			}
		}
		
		orgs[orgs.size] = targ;
		if(isdefined(targ.target))
			targ = getent(targ.target,"targetname");
		else
			targ = undefined;
	}
//		orgs[orgs.size-1].looping = hintnum;
	self.originque = array_combine(self.originque,orgs);
}

VehicleAttackgroup (groupid)
{
	self notify ("attack",level.script_VehicleAttackgroup[groupid]);
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
	target maps\_tank::queaddtofront(other);
}

debug_vehiclefocusfire (other,target)
{
	if(getcvar("debug_vehiclefocusfire") == "off")
		return;
	timer = gettime()+ 3000;
	while(getcvar("debug_vehiclefocusfire") != "off" && gettime()< timer)
	{
		line(other,target,(0,0,1),1);
		wait .05;
	}
}


vehicle_Levelstuff (vehicle,trigger)
{
	//associate with links. false
	if(isdefined(vehicle.script_linkname))
	{
		if(!isdefined(level.vehicle_link[vehicle.script_linkname]))
			level.vehicle_link[vehicle.script_linkname] = [];
		level.vehicle_link[vehicle.script_linkname][level.vehicle_link[vehicle.script_linkname].size] = vehicle;
	}
	//associate with targets
	if(isdefined(vehicle.targetname))
	{
		if(!isdefined(level.vehicle_target[vehicle.targetname]))
			level.vehicle_target[vehicle.targetname] = [];
		level.vehicle_target[vehicle.targetname][level.vehicle_target[vehicle.targetname].size] = vehicle;
	}
	if(isdefined(vehicle.script_VehicleAttackgroup))
	{
		if(!isdefined(level.script_VehicleAttackgroup[vehicle.script_VehicleAttackgroup]))
			level.script_VehicleAttackgroup[vehicle.script_VehicleAttackgroup] = [];
		level.script_VehicleAttackgroup[vehicle.script_VehicleAttackgroup]
		[level.script_VehicleAttackgroup[vehicle.script_VehicleAttackgroup].size]
		 = vehicle;
		
	}
	if(isdefined(vehicle.script_VehicleSpawngroup))
	{
		if(!isdefined(level.script_VehicleSpawngroup[vehicle.script_VehicleSpawngroup]))
			level.script_VehicleSpawngroup[vehicle.script_VehicleSpawngroup] = [];
		level.script_VehicleSpawngroup[vehicle.script_VehicleSpawngroup]
		[level.script_VehicleSpawngroup[vehicle.script_VehicleSpawngroup].size]
		 = vehicle;
	}
	if(isdefined(vehicle.script_VehicleStartMove))
	{
		if(!isdefined(level.script_VehicleStartMove[vehicle.script_VehicleStartMove]))
			level.script_VehicleStartMove[vehicle.script_VehicleStartMove] = [];
		level.script_VehicleStartMove[vehicle.script_VehicleStartMove]
		[level.script_VehicleStartMove[vehicle.script_VehicleStartMove].size]
		 = vehicle;

	}
	if(isdefined(vehicle.script_vehicleGroupDelete))
	{
		if(!isdefined(level.script_vehicleGroupDelete[vehicle.script_vehicleGroupDelete]))
			level.script_vehicleGroupDelete[vehicle.script_vehicleGroupDelete] = [];
		level.script_vehicleGroupDelete[vehicle.script_vehicleGroupDelete]
		[level.script_vehicleGroupDelete[vehicle.script_vehicleGroupDelete].size]
		 = vehicle;

	}
	if(isdefined(vehicle.script_vehiclefocusfiregroup))
	{
		if(!isdefined(level.script_vehiclefocusfiregroup[vehicle.script_vehiclefocusfiregroup]))
			level.script_vehiclefocusfiregroup[vehicle.script_vehiclefocusfiregroup] = [];
		level.script_vehiclefocusfiregroup[vehicle.script_vehiclefocusfiregroup]
		[level.script_vehiclefocusfiregroup[vehicle.script_vehiclefocusfiregroup].size]
		 = vehicle;
	}
	if(isdefined(vehicle.script_vehicledeathgate))
	{
		if(!isdefined(level.script_vehicledeathgate[vehicle.script_vehicledeathgate]))
			level.script_vehicledeathgate[vehicle.script_vehicledeathgate] = [];
		level.script_vehicledeathgate[vehicle.script_vehicledeathgate]
		[level.script_vehicledeathgate[vehicle.script_vehicledeathgate].size]
		 = vehicle;
	}
	if(isdefined(vehicle.script_vehicledeathswitch))
	{
		if(!isdefined(level.script_vehicledeathswitch[vehicle.script_vehicledeathswitch]))
			level.script_vehicledeathswitch[vehicle.script_vehicledeathswitch] = [];
		level.script_vehicledeathswitch[vehicle.script_vehicledeathswitch]
		[level.script_vehicledeathswitch[vehicle.script_vehicledeathswitch].size]
		 = vehicle;
	}
	if(isdefined(vehicle.script_dronelag))  // for putting space between drones targeting the same path
	{
		if(!isdefined(level.script_dronenodetime_last[vehicle.target]))
			level.script_dronenodetime_last[vehicle.target] = gettime();
		if(!isdefined(level.script_dronenodetime[vehicle.target]) || gettime()-level.script_dronenodetime_last[vehicle.target] > 2)
			level.script_dronenodetime[vehicle.target] = 0;
		level.script_dronenodetime[vehicle.target] += vehicle.script_dronelag;
		vehicle.script_delay+=level.script_dronenodetime[vehicle.target];
		level.script_dronenodetime_last[vehicle.target] = gettime();
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
		level.script_VehicleAttackgroup[vehicle.script_VehicleAttackgroup] = array_remove(level.script_VehicleAttackgroup[vehicle.script_VehicleAttackgroup],vehicle);
	if(isdefined(vehicle.script_VehicleSpawngroup))
		level.script_VehicleSpawngroup[vehicle.script_VehicleSpawngroup] = array_remove(level.script_VehicleSpawngroup[vehicle.script_VehicleSpawngroup],vehicle);
	if(isdefined(vehicle.script_VehicleStartMove))
		level.script_VehicleStartMove[vehicle.script_VehicleStartMove] = array_remove(level.script_VehicleStartMove[vehicle.script_VehicleStartMove],vehicle);
	if(isdefined(vehicle.script_vehicleGroupDelete))
		level.script_vehicleGroupDelete[vehicle.script_vehicleGroupDelete] = array_remove(level.script_vehicleGroupDelete[vehicle.script_vehicleGroupDelete],vehicle);
	if(isdefined(vehicle.script_vehiclefocusfiregroup))
		level.script_vehiclefocusfiregroup[vehicle.script_vehiclefocusfiregroup] = array_remove(level.script_vehiclefocusfiregroup[vehicle.script_vehiclefocusfiregroup],vehicle);
	if(isdefined(vehicle.script_vehicledeathswitch))
	{
		level.script_vehicledeathswitch[vehicle.script_vehicledeathswitch] = array_remove(level.script_vehicledeathswitch[vehicle.script_vehicledeathswitch],vehicle);
		if(!level.script_vehicledeathswitch[vehicle.script_vehicledeathswitch].size)
			level notify ("script_vehicledeathswitch"+vehicle.script_vehicledeathswitch);
	}

	if(isdefined(vehicle.script_vehicledeathgate))
	{
		level.script_vehicledeathgate[vehicle.script_vehicledeathgate] = array_remove(level.script_vehicledeathgate[vehicle.script_vehicledeathgate],vehicle);
		if(!level.script_vehicledeathgate[vehicle.script_vehicledeathgate].size)
			level notify ("deathgate open"+vehicle.script_vehicledeathgate);
	}

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
		riderspawners = level.script_vehicleridespawners[self.script_vehicleride];
	if(!isdefined(riderspawners))
		riderspawners = [];
	
	if(HasWalkers)
		walkerspawners = level.script_vehiclewalkspawners[self.script_vehiclewalk];
	if(!isdefined(walkerspawners))
		walkerspawners = [];


	spawners = array_combine(riderspawners,walkerspawners);
	startinvehicles = [];
	runtovehicles = [];	
	
	//level.script_vehiclewalkai
	
	riders = [];
	walkers = [];
	ai = [];
	for(i=0;i<spawners.size;i++)
	{
		spawners[i].count = 1;
		spawned = spawners[i] doSpawn();
		if (spawn_failed(spawned))
			continue;
		ai[ai.size] = spawned;
	}
	
	if(HasRiders)
		if(isdefined(level.script_vehiclerideai[self.script_vehicleride]))
			ai = array_combine(ai,level.script_vehiclerideai[self.script_vehicleride]);
	if(HasWalkers)
		if(isdefined(level.script_vehiclewalkai[self.script_vehiclewalk]))
			ai = array_combine(ai,level.script_vehiclewalkai[self.script_vehiclewalk]);

	for(i=0;i<ai.size;i++)
	{
		if (isdefined (ai[i].script_vehicleride))
			riders[riders.size] = ai[i];
		else if (isdefined (ai[i].script_vehiclewalk))
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
					ai[i].NodeAfterTankWalk = node;
			}
			walkers[walkers.size] = ai[i];
		}

		if( (isdefined (ai[i].script_noteworthy)) && (ai[i].script_noteworthy == "runtovehicle") )
			runtovehicles[runtovehicles.size] = ai[i];
//			thread runtovehicle(ai[i]);
		else
			startinvehicles[startinvehicles.size] = ai[i];
		
	}
	self.walkers = walkers;
	self.riders = riders;

	if(runtovehicles.size > 0)
		self notify ("load",runtovehicles);
	self notify ("guyenters",startinvehicles); //for trucks and kubelwagons, maybe do _tankai this way too.
}

runtovehicle (guy)
{
	guyarray = [];
	guy.animatein = 1;

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
	climborg = self gettagorigin(climbinnode[thenode]);
	climbang = self gettagangles(climbinnode[thenode]);
	org = getStartOrigin (climborg, climbang, climbinanim[thenode]);

	guy set_forcegoal();

	guy setgoalpos (org);
	guy.goalradius = 16;
	guy waittill ("goal");
	guy unset_forcegoal();

	if(self getspeedmph() < 1)
	{
		guy linkto (self);
		guy animscripted("hopinend", climborg,climbang, climbinanim[thenode]);
		guy waittillmatch ("hopinend", "end");
		guyarray[0] = guy;
		self notify ("guyenters", guyarray);
	}
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
	if(!isdefined(getvehiclenode(node.target,"targetname")))
		return true;
	return false;
}

vehicle_paths ()
{	
	pathstart = self.attachedpath;
	self.currentNode = self.attachedpath; // for _tankai.gsc
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
		self.currentNode = pathpoints[i]; // for _tankai
		if(isdefined(pathpoints[i].gateopen) && !pathpoints[i].gateopen)
			self thread path_gate_wait_till_open(pathpoints[i]); // threaded because vehicle may setspeed(0,15) and run into the next node
		if(isdefined(pathpoints[i].squadbreaker))
			self thread squad_breaker();
		if(isdefined(self.enemyque) && self.enemyque.size > 0)
			self notify ("attack",self.enemyque);  // stop at every node
		pathpoints[i] notify ("trigger",self); // the sweet stuff! Pathpoints handled in script as triggers!
	}
}

debug_vehicledetour (start,end)
{
	/#
	self notify ("newdetour");
	self endon ("newdetour");
	self endon ("death");
	while(getcvar("debug_vehicledetour") != "off")
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

skidderon ()
{
	self endon ("skidoff");
	self waittill ("skidon");
	while(1)
	{
		self playsound("Dirt_skid","skidsound",true);
		self waittill ("skidsound");
	}
}

skidder ()  // applies skid sound when node tells it to skid
{
	while(1)
	{
		self waittill ("skidon");
		self notify ("skidoff");
		thread skidderon();
	}
}
/*
draw_crash_path()
{
	if(getcvar("debug_crashpaths") == "off")
		return;
	path = self.crashing_path;
	drawpath = path;
	drawpaths = [];
	arraycount = 0;
	while (isdefined (drawpath))
	{
		drawpaths[arraycount] = drawpath;
		if(isdefined (drawpath.target))
		{
			drawpath = getvehiclenode(drawpath.target, "targetname");
			arraycount++;
		}
		else
			break;
	}
	drawpath = path;
	while (self.crashing_path == path)
	{
		line (self.origin, path.origin, (0, 1, 0), 0.5);
		print3d (path.origin + (0,0,64), path.targetname, (1, 1, 1), 1);
		print3d (path.origin + (0,0,50), "targeting", (1, 1, 1), 1);
		print3d (path.origin + (0,0,36), path.target, (1, 1, 1), 1);
		for(i=0;i<drawpaths.size;i++)
		{
			if(isdefined (drawpaths[i+1]))
				line (drawpaths[i].origin, drawpaths[i+1].origin, (1, 0, 0), 0.5);
		}
		wait .05;
	}
}
*/

getonpath ()
{
	self thread skidder();
	theone = undefined;
	if(self.vehicletype == "vehicledroneai")
	{
		self endon ("death");
		wait self.script_delay-.05;
	}
	if(isdefined(self.target))
		theone = getvehiclenode(self.target,"targetname");
	if (!isdefined (theone))
		return;
	self.attachedpath = theone;
	self.origin = theone.origin;
	self attachpath (theone);
	self notify ("onpath");
	self disconnectpaths();
	self thread vehicle_paths();
}

gopath ( vehicle )
{
	if(!isdefined(vehicle))
	{
		println("go path called on non existant vehicle");
	}
	if(isdefined(vehicle.script_vehiclestartmove))
		level.script_vehiclestartmove[vehicle.script_vehiclestartmove] = array_remove(level.script_vehiclestartmove[vehicle.script_vehiclestartmove],vehicle);
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
	vehicle startpath();
	wait .05;
	vehicle connectpaths();
	vehicle waittill ("reached_end_node");
	
	if(isdefined(vehicle.script_unloaddelay))
		vehicle thread dounload(vehicle.script_unloaddelay);
	else
		vehicle notify ("unload");
	
	vehicle vehicle_setspeed(0,200,"reached end node");
	vehicle joltbody((vehicle.origin + (0,0,64)),.5);
	vehicle disconnectpaths();
}

dounload( delay )
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
//	if(isdefined(pathspot.gatetype))
//		println("gatetype, :",pathspot.gatetype); 
	self endon ("death");
	self.waitingforgate = true;
	self vehicle_setspeed(0,15,"path gate closed");
	pathspot waittill("gate opened");
	self.waitingforgate = false;
	if(self.health > 0)
		script_resumespeed("gate opened",level.resumespeed);
}

spawner_setup ( vehicles ,message,from )
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
		
		struct = spawnstruct();
		struct setspawnervariables(vehicles[i],from);
		vehicle[script_vehiclespawngroup]                 
		[vehicle[script_vehiclespawngroup].size] = struct;
		level.vehicleSpawners[script_vehiclespawngroup][i] = struct;
		
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

scripted_spawn_go( group )
{
	wait 0;  // lets scripted_spawn() get to wait point before this notification
	level notify ("spawnvehiclegroup"+group);
}



setspawnervariables( vehicle,from )
{
	self.classname = vehicle.classname;
	self.model = vehicle.model;
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
	if(isdefined(vehicle.script_fireondrones))
		self.script_fireondrones = vehicle.script_fireondrones;
	if(isdefined(vehicle.script_tankgroup))
		self.script_tankgroup = vehicle.script_tankgroup;
	if(isdefined(vehicle.script_avoidplayer))
		self.script_avoidplayer = vehicle.script_avoidplayer; 
	if(isdefined(vehicle.script_playerconeradius))
		self.script_playerconeradius = vehicle.script_playerconeradius;
	

	if(vehicle.count > 0)
		self.count = vehicle.count;
	else
		self.count = 1;


	if(isdefined(vehicle.simpletype))
		self.simpletype = vehicle.simpletype;
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
	if(vspawner.vehicletype == "vehicledroneai" && getentarray("script_vehicle","classname").size > 46)
		return;
	vehicle = spawnVehicle( vspawner.model, vspawner.targetname, vspawner.vehicletype ,vspawner.origin, vspawner.angles );
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
	if(isdefined (vspawner.simpletype))
		vehicle.simpletype = vspawner.simpletype;
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
	if(isdefined(vspawner.script_fireondrones))
		vehicle.script_fireondrones = vspawner.script_fireondrones;
	if(isdefined(vspawner.script_tankgroup))
		vehicle.script_tankgroup = vspawner.script_tankgroup;
	if(isdefined(vspawner.script_avoidplayer))
		vehicle.script_avoidplayer = vspawner.script_avoidplayer;
	if(isdefined(vspawner.script_playerconeradius))
		vehicle.script_playerconeradius = vspawner.script_playerconeradius; 

	vehicle_init(vehicle);

	if(isdefined(vehicle.targetname))
		level notify ("new vehicle spawned"+vehicle.targetname,vehicle);
	return vehicle;
}

waittill_vehiclespawn ( targetname )
{
	level waittill ("new vehicle spawned"+targetname,vehicle);
	return vehicle;
	
}

wait_vehiclespawn (targetname)
{
	println("wait_vehiclespawn() called; change to waittill_vehiclespawn()");
	level waittill ("new vehicle spawned"+targetname,vehicle);
	return vehicle;
}

vehicle_init (vehicle)
{
	if ( (vehicle.vehicletype == "higgins") || (vehicle.vehicletype == "flakveirling") )
		return;
	if(isdefined(vehicle.script_nobadplace) && vehicle.script_nobadplace == 1)
	{
		println("vehicle using oldschool \"script_nobadplace\" please change to \"script_badplace\"");
		vehicle.script_badplace = 0;	//legacy support to be removed once it no longer exists in .maps
	}
	
	vehicle.tanksquadfollow = false;
	vehicle.zerospeed = true;
	
	vehicle thread [[level.vehicleInitThread[vehicle.vehicletype][vehicle.model]]]();
	
	if(isdefined(level._vehicledriveidle[vehicle.model]))
		vehicle thread animate_drive_idle();
	
	if (isdefined(vehicle.spawnflags) && vehicle.spawnflags & 1 )
	{

		startinvehicle = (isdefined(vehicle.script_noteworthy) && vehicle.script_noteworthy == "startinside"); // can't see making a whole new keys.txt entry for something that's only going to be used once in any given level.
//		println("startinvehicle is ",startinvehicle);
	
		if(vehicle.simpletype == "tank")
			vehicle maps\_vehicledrive::setup_vehicle_tank();
		else if(vehicle.simpletype == "mobile")
			vehicle maps\_vehicledrive::setup_vehicle_other();
		vehicle thread maps\_vehicledrive::vehicle_wait(startinvehicle);
		vehicle_Levelstuff(vehicle);
		vehicle thread kill();
		return;
		
		

	}
	vehicle_Levelstuff(vehicle);
	
	if(isdefined(vehicle.script_team))
		vehicle setvehicleteam(vehicle.script_team);
	
	if(isdefined(vehicle.script_team) && vehicle.script_team == "allies" && vehicle.simpletype == "tank" && vehicle.vehicletype != "armoredcar" && vehicle.vehicletype != "buffalo") // armored car is a special case for now
		vehicle maps\_vehiclenames::get_name();
	vehicle thread disconnect_paths_whenstopped();
	vehicle thread getonpath();
	vehicle spawn_group();
	
	if(vehicle.simpletype == "tank" && vehicle.vehicletype != "buffalo") //break out the l33t hax0r
		vehicle thread maps\_tank::tanks_think();
	vehicle thread kill();
}

kill ()
{
	model = self.model;
	self waittill ("death");
	self endon ("delete");
	waittillframeend; // allow vehicle specific kill scripts to go first
	if(!isdefined(self))
		return; //for deleting I think
	thread kill_fx(model);
	if(self.health > 0)
		radiusdamage(self.origin, 30, 10000,10000); // for vehicles notified "death".
	self joltbody((self.origin + (23,33,64)),3);
	if(isdefined(self.script_crashtypeoverride))
		crashtype = self.script_crashtypeoverride;
	else
		crashtype = self.simpletype;
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
			self waittill ("animsdone");  //tankgetout will never get notified if there is no guys getting out
		if ( (!isdefined (level.playervehicle)) || ( (isdefined (level.playervehicle)) && (self != level.playervehicle) ) )
			self clearTurretTarget();
	}
	while(isdefined(self) && isalive(self) && self getspeedmph () > 0 )
		wait .1;
	
	wait .5;
	
	if ( (isdefined (self)) && (level.playervehicle != self) )
	{
		self freevehicle();
		level.vehiclecorpses[level.vehiclecorpses.size] = self;
	}
}

kill_fx(model)
{
//	self endon ("death");
	self endon ("fire extinguish");
	if(!isdefined(level.deathfx_extra[model]))
		return;
	while(1)
	{
		playfxontag ( level.deathfx_extra[model]["loop"], self, level.deathfx_extra[model]["tag"] );
		wait (level.deathfx_extra[model]["delay"]);
	}
}

vehicles_setup (vehicles)
{
	level.needsprecaching = [];
	playerdrivablevehicles = [];
	allvehiclesprespawn = [];
	if(!isdefined(level.vehicleInitThread))
		level.vehicleInitThread = [];
	//find all the vehicle tanks in the level and initialize precaching ( calling of vehicles main() mostly)
	
	for (i=0;i<vehicles.size;i++)
	{

		vehicles[i].vehicletype = tolower(vehicles[i].vehicletype);

		if(isdefined(vehicles[i].spawnflags) && vehicles[i].spawnflags & 1)
			playerdrivablevehicles[playerdrivablevehicles.size] = vehicles[i];
		else
			allvehiclesprespawn[allvehiclesprespawn.size] = vehicles[i];
		if(!isdefined(level.vehicleInitThread[vehicles[i].vehicletype]))
			level.vehicleInitThread[vehicles[i].vehicletype] = [];
		
		vehicles[i].simpletype = "mobile";  //default
		switch(vehicles[i].vehicletype)
		{
			case "tiger":
			case "tiger2":
				vehicles[i].simpletype = "tank";
				precachesetup("maps\\\_tiger::main(\""+vehicles[i].model+"\");",vehicles[i]);
				break;
			case "crusader":
			case "crusader_player":
			case "sherman":
			case "armoredcar":
			case "buffalo":
			case "panzer2":
				vehicles[i].simpletype = "tank";
				precachesetup("maps\\\_"+vehicles[i].vehicletype+"::main(\""+vehicles[i].model+"\");",vehicles[i]);
				break;
			case "stuka":
				vehicles[i].simpletype = "plane";
				precachesetup("maps\\\_"+vehicles[i].vehicletype+"::main(\""+vehicles[i].model+"\");",vehicles[i]);
				break;
			case "flak88":
			case "unicarrier":
			case "jeep":
			case "kubelwagon":
			case "vehicledroneai":
				precachesetup("maps\\\_"+vehicles[i].vehicletype+"::main(\""+vehicles[i].model+"\");",vehicles[i]);
				break;
			case "germanfordtruck":
			case "blitz":
				precachesetup("maps\\\_truck::main(\""+vehicles[i].model+"\");",vehicles[i]);
				break;
			case "germanhalftrackrocket":
			case "germanhalftrack":
				precachesetup("maps\\\_halftrack::main(\""+vehicles[i].model+"\");",vehicles[i]);
				break;
			case "flak88_forward":
				precachesetup("maps\\\_flak88::main(\""+vehicles[i].model+"\");",vehicles[i]);
				break;

				
		}
	}
	
	
	if(level.needsprecaching.size > 0)
	{
		println("----------------------------------------------------------------------------------");
		println("----------------------------------------------------------------------------------");
		println("-----add these lines to your level script above maps\\\_load::main();-------------");
		
		for(i=0;i<level.needsprecaching.size;i++)
		{
			println(level.needsprecaching[i]);
		}
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

precachesetup(string,vehicle)
{
	if(isdefined(level.vehicleInitThread[vehicle.vehicletype][vehicle.model]))
	{
		return;
		
	}
	matched = false;
	for(i=0;i<level.needsprecaching.size;i++)
	{
		if(level.needsprecaching[i] == string)
			matched = true;	
	}
	if(!matched)
		level.needsprecaching[level.needsprecaching.size] = string;
	
}


vehicle_modelinarray(arrayofmodels,model)
{
	for(i=0;i<arrayofmodels.size;i++)
		if(arrayofmodels[i] == model)
			return true;
	return false;
}

disconnect_paths_whenstopped ()  // to be replaced with Badplaces
{
	self endon ("death");
	wait (randomfloat(1));
	while (isdefined (self))
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
	level.vehicle_squad_followdelay+= .05;
	if(level.vehicle_squad_followdelay > 1)
		level.vehicle_squad_followdelay = 0;
	wait level.vehicle_squad_followdelay;

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
	script_resumespeed("squade leader dead",level.resumespeed);
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
	backwardvec = vectormultiply(anglestoforward((self.angles[0],self.angles[1]+180,self.angles[2])),1000);
	farbackwardvec = vectormultiply(anglestoforward((self.angles[0],self.angles[1]+180,self.angles[2])),2100);
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
		while(getcvar("debug_vehiclesquad") != "off")
		{
			print3d(self.origin,"speed: "+speed, (r,g,b),1,3);
			print3d(self.origin+(0,0,64),"realspeed: "+self getspeedmph(), (r,g,b),1,3);
			print3d(self.origin+(0,0,128),"vehicle_squad status: "+msg, (r,g,b),1,3);
			line(self.origin,ent_end.origin,(r,g,b),1);
//			line(ent_end.origin,leader.origin,(0,0,1),1);
			
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

	self setspeed(speed,rate,msg);
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
		while(getcvar("debug_vehiclesetspeed") != "off")
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
	if(getcvar("debug_vehicleresume") == "off")
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

debug_vclogin ()
{
	precachemodel("xmodel/vehicle_stuka_flying");
	if (getcvar("debug_vclogin") == "off")
		return;
	level.debugvclogin = 1;
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
			vehicle = spawnVehicle( "xmodel/vehicle_stuka_flying", "vclogger", "Stuka" ,(0,0,0), (0,0,0) );
		else
			vehicle = spawnVehicle( "xmodel/vehicle_stuka_flying", "vclogger", "Stuka" ,(0,0,0), (0,0,0) );
		vehicle attachpath(paths[i]);
		
		if(isdefined(vehicle.model) && vehicle.model == "xmodel/vehicle_stuka_flying")
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
	level waittill ("deathgate open"+node.script_vehicledeathgate);
	path_gate_open(node);	
}

forcekillnode(node)
{
	node waittill ("trigger",other);
	radiusDamage (other.origin, 2, 10000, 9000);
}

godon(node)
{
	node waittill ("trigger",other);
	other.godmode = true;
}

godoff(node)
{
	node waittill ("trigger",other);
	other.godmode = false;	
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

unload_continue(trigger)
{
	while(1)
	{
		trigger waittill ("trigger",other);
		level thread unload_continue_thread(other);

	}
}

unload_continue_thread(other)
{
	other endon ("death");
	other setspeed(1,20);
	other setwaitspeed(5);
	other waittill ("reached_wait_speed");
	other notify ("unload");
	other thread unload_continue_timeout();
	other waittill_any ("unloaded","unloaded_timeout");
	other resumespeed(10);	
}

unload_continue_timeout()
{
	self endon ("unloaded");
	wait 10;
	self notify ("unloaded_timeout");
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

animate_drive_idle ()
{
	model = self.model;
	self endon ("death");
	self UseAnimTree(level._vehicleanimtree[model]);
	normalspeed = level._vehicledriveidle_normal_speed[model];
	thread animate_drive_idle_death();
	while(1)
	{
		speed = self getspeedmph();
		if(speed == 0)
		{
			self clearanim(level._vehicledriveidle[model],0);
		}
		else
		{
			self setanim(level._vehicledriveidle[model],1,.2,speed/normalspeed);
		}
		wait .5;
	}
}

animate_drive_idle_death()
{
	model = self.model;
	self UseAnimTree(level._vehicleanimtree[model]);
	self waittill ("death");
	if(isdefined(self))
		self clearanim(level._vehicledriveidle[model],0);
}