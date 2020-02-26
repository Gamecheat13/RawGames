
#include maps\_utility;
#include maps\_anim;
#include maps\_vehicle;
#include common_scripts\utility;

main()
{
	setExpFog( 20000, 7500, 0.1, 0.1, 0.2, 0 );
	maps\_bm21::main("vehicle_bm21_mobile");
	maps\_hind::main("vehicle_mi24p_hind_woodland");
	maps\_t72::main("vehicle_t72_tank");
	maps\_bmp::main("vehicle_bmp");
	maps\_mig29::main("vehicle_mig29_desert");
	maps\_c4::main();
	
	maps\_load::main();
	maps\_compass::setupMiniMap("compass_map_school");
	visionsetnaked("school");
	maps\school_fx::main();
	thread maps\school_amb::main();
	thread bm21_setup();
	level thread setup_player();
	level thread start();
	level thread at_fence();
	level thread at_barn();
	level thread maps\_mortar::bog_style_mortar();
	level thread friendly_tanks_spawn_and_start_firing();
	level thread spawn_second_group();
	level thread first_enemy_tank();
	level thread run_past_tank_guy();
	level thread first_autosave();
	
	// compounding
	array_thread(getvehiclenodearray("plane_sound","script_noteworthy"),maps\_mig29::plane_sound_node);

}


start()
{
	level.price = spawnGuy("price",true);
	level.mark = spawnGuy("mark",true);
	level.fenceguy = spawnGuy("squadmember1",true);
	level.price cqb_walk("on");
	level.mark cqb_walk("on");
	level.fenceguy cqb_walk("on");
	level.price make_hero();
	level.mark make_hero();
	level.price thread magic_bullet_shield();
	level.mark thread magic_bullet_shield();
	level.fenceguy thread magic_bullet_shield();
	level.price.goalradius = 32;
	level.mark.goalradius = 32;
	level.fenceguy.goalradius = 32;
	level.noMaxMortarDist = true;
	
	level.price.pacifist = true;
	level.mark.pacifist = true;
	level.fenceguy.pacifist = true;
	level.firstgroup = spawn_guys_from_targetname("firstgroup");
	
	for( i = 0; i < level.firstgroup.size; i++)
	{
		level.firstgroup[i].pacifist = true;
		level.firstgroup[i].disable_blindfire = true;	
		level.firstgroup[i] set_force_color("red");	
	}
	
	thread maps\_mortar::bog_style_mortar_on(0);
	

	thread kickDownFence();
	thread waveToPlayer();	
	thread mark_quip();
	thread first_helo_flyby();
	thread mig_flyover();
	thread first_objectives();
}

at_fence()
{
	// compounding, see below
	getent("atFence","targetname") waittill("trigger");	
	
	// compounding, would be better to just pass the string and have the function do the getnode. More readable and less breakable.
	level.price thread cqb_walk_up_tracks(getnode("fartrainpath","targetname"));
	level.fenceguy thread cqb_walk_up_tracks(getnode("neartrainpath","targetname"));
	level.mark thread cqb_walk_up_tracks(getnode("fartrainpath","targetname"));
	objective_add( 2, "active", "Destroy rocket artillery vehicle",level.bm21.origin); 
	objective_current( 2 );

}

cqb_walk_up_tracks(startnode)
{
	self follownodepath(startnode);
	self set_force_color("blue");
}

followNodePath(startNode)
{
	// can call _spawner::go_to_node();
	node = startNode;
	if(!isdefined(node.target))
		assertMsg("followNodePath: not a node path!");
		
	for(;;)
	{
		self setgoalnode(node);
		self waittill("goal");
		if(isdefined(node.target))
		{
			node = getnode(node.target,"targetname");	
			self.goalradius = 32;
		}
		else
		{
			break;
		}
	}	
}

kickDownFence()
{
	level.fenceguy printOnSelf("kicking down fence",5);
}

waveToPlayer()
{
	level.price printOnSelf("waving",3);	
	iprintlnbold("Price: Over here!");	
}


printOnSelf(message,duration)
{
	print3d( self.origin + (0,0,32),message,(0,0,1),1.5,duration * 60);	
}

spawnGuy(spawnerName,stalingrad)
{
	spawner = getent(spawnerName,"targetname");

	// maps\_spawner::spawn_ai() does this
	if(stalingrad == true)
		guy = spawner stalingradSpawn();
	else
		guy = spawner dospawn();

	if (spawn_failed(guy))
		assertMsg("someone failed to spawn");
	
	// if you find yourself prefexing you're doing something wrong. This should never be done.
	if(isdefined(spawner.targetname))
		guy.targetname = "spawned_" + spawner.targetname;
				
	return guy;	
}

	
bm21_setup()
{
	wait(1);
	level.bm21 = getent("bm21_01", "targetname");	
	level.bm21 thread maps\_c4::c4_location( undefined,( 0, 0, 0 ) , ( 0, 0, 0 ), ( -3746.07, 3484.04, 575.984 ) );
	level.bm21 thread bm21_think();
	level.bm21 waittill("c4_detonation");
	// its better to use dodamage than notify death
	level.bm21 notify("death");
	objective_state(2,"done");
	wait(2);
	iprintlnbold("end of scripted level");
}

bm21_think()
{
	self endon("death");
	aTargets = getentarray( "missile_target", "targetname" );
	

	while (true)
	{
		// why is the wait frame necessary? Reason should be commented
		wait(0.05);
		for(i=0;i<aTargets.size;i++)
		{
			
			iTimesToFire = 5 + randomint(6);
			for(i2=0;i2<iTimesToFire;i2++)
			{
				if (i2 == 0)
				{
					self setturrettargetent(aTargets[i]);
					self waittill ("turret_rotate_stopped");	
					wait(1);	
				}
				// how can self not be alive if there is self endon death?
				if(isalive(self))
					self notify ( "shoot_target", aTargets[i]);
				
				wait (.25);
			}
	
	
			wait (5);
		}
	}
}

mark_quip()
{
	wait(10);

//	iprintlnbold("Price: We've received intel that Drago is ov.");
//	wait(4);
	
}

first_helo_flyby()
{
	// compound, see below
	getent("helotrig1","targetname") waittill("trigger");
	wait(.1);
	helos = [];
	
	helos[0] = getent("helo1","targetname");
	helos[1] = getent("helo2","targetname");
	helos[2] = getent("helo3","targetname");
	
	for(i = 0; i < helos.size; i++)
	{
		helos[i] setspeed(100, 15);
		helos[i] setairresistance( 30 );
		// don't compound
		helos[i] setvehgoalpos(getent("heloover1","targetname").origin,0);
		helos[i] setNearGoalNotifyDist(50);
		helos[i] thread _first_helo_do_path();
	}
}

_first_helo_do_path()
{
	// spaces for readability please, use nate's macro
	self waittill("near_goal");
	self setvehgoalpos(getent("heloover2","targetname").origin,0);
	self waittill("near_goal");
	self setvehgoalpos(getent("heloover3","targetname").origin,0);
	wait(1);
	self delete();
}

friendly_tanks_spawn_and_start_firing()
{
	// compounded, see below
	getent("friendlytank_trigger","targetname") waittill("trigger");
	tankarray = spawn_vehicles_from_targetname_and_drive("friendly_tank_wave");
	for(i = 0; i < tankarray.size; i++)
	{
		// compounded (and called multiple times for no reason) getentarray call, should be outside the loop and
		// the loop should be an array_thread.
		tankarray[i] thread wait_for_node_then_fire(getentarray("friendly_shotloc","script_noteworthy"));
	}	
	
	
}

wait_for_node_then_fire(shotlocs)
{
	node = self get_fire_node();
	node waittill("trigger");
	
	// use random( shotlocs )
	location = shotlocs[randomint(shotlocs.size)];
	for(;;)
	{
		self setTurretTargetVec(location.origin);
		self waittill("turret_on_target");
		self notify("turret_fire");	
		
		// use wait( randomfloatrange( 5, 15 ) )
		wait(randomfloat(10.0) + 5.0);
	}
}


get_fire_node()
{
	node = getvehiclenode(self.target,"targetname");
	for(;;)
	{
		if(isdefined(node.script_noteworthy) && node.script_noteworthy == "start_firing")
		{
			return node;	
		}
		
		if(!isdefined(node.target))
		{
			assertmsg("traversed to end of vehicle path without finding fire node");
			break;
		}
		node = getvehiclenode(node.target,"targetname");
	}	
}

spawn_guys_from_targetname( targetname )
{
	// should be moved to _utility and removed from bog_a_code
	guys = [];
	spawners = getentarray( targetname, "targetname" );
	for ( i=0; i < spawners.size; i++ )
	{
		spawner = spawners[i];
		spawner.count = 1;
		guy = spawner maps\_spawner::spawn_ai();
		spawn_failed( guy );
		assertEx( isalive( guy ), "Guy from spawner with targetname " + targetname + " at origin " + spawner.origin + " failed to spawn" );
		
		guys[ guys.size ] = guy;
	}
	
	return guys;
}

at_barn()
{
	// compounding, see notes below
	getent("atBarn","targetname") waittill("trigger");	
	
	for( i = 0; i < level.firstgroup.size; i++)
	{
		// create a reference guy if you're referencing an indexed array member several times, like firstgroup = level.firstgroup[ i ]
		
		// this can be simply if !isalive( member ), because isalive does an isdefined check internally.
		if(!isdefined(level.firstgroup[i]) || !isalive(level.firstgroup[i]))
			continue;	
		
		level.firstgroup[i].pacifist = false;
	}	
	
	level.mark.pacifist = false;
	level.price.pacifist = false;
	level.fenceguy.pacifist = false;
	level.mark cqb_walk("off");
	level.price cqb_walk("off");
	level.fenceguy cqb_walk("off");
}

setup_player()
{
	level.player takeAllWeapons();
	level.player giveWeapon("Beretta");
	level.player giveWeapon("m4_grenadier");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("flash_grenade");
	level.player setOffhandSecondaryClass( "flash" );
	level.player switchToWeapon( "m4_grenadier" );	
	
}

spawn_second_group()
{
	// compounding, use wait_for_targetname_trigger( "spawn_second_group" );
	getent("spawn_second_group","targetname") waittill("trigger");
	level.secondgroup = spawn_guys_from_targetname("second_group");	
	for( i = 0; i < level.secondgroup.size; i++)
	{
		level.secondgroup[i].disable_blindfire = true;	
	}
}

mig_flyover()
{
	plane = spawn_vehicle_from_targetname_and_drive("intromig");	
	
	// you can't setwaitnode reliably if you're using the vehicle scripts, the vehicle scripts control this
	plane setwaitnode(getvehiclenode("endofpath","script_noteworthy"));
	plane waittill("reached_wait_node");
	plane delete();
}

first_objectives()
{
	objective_add( 1, "active", "Hunt down Drago Zakhaev" );
	objective_current( 1 );
	
}	

first_enemy_tank()
{
	// this is excessive compounding, use wait_for_targetname_trigger( "spawn_first_enemy_tank" ), more readable.
	getent("spawn_first_enemy_tank","targetname") waittill("trigger");
	tank = spawn_vehicle_from_targetname_and_drive("first_enemy_tank");	
	tank.shock_distance = 1300;
	tank.black_distance = 1300;
	
	// compounding
	getvehiclenode("end_of_path_tank1","script_noteworthy") waittill ("trigger",other);
	tank thread first_enemy_tank_shoot_randomly();
	wait(20);
	tank notify("death");
}

first_enemy_tank_shoot_randomly()
{
	self endon("death");
	for(;;)
	{
		// compound calls are less readable, and there's no spaces
		self setTurretTargetVec(getent("enemytankshotloc","targetname").origin);
		
		self waittill("turret_on_target");
		
		// how could self not be alive if this function is endon death?
		if(isalive(self))
			self notify("turret_fire");	
			
		// use wait( randomfloatrange( 5, 10 ) ), more readable.
		wait(randomfloat(5.0) + 5.0);
	}
		
}

run_past_tank_guy()
{
	guys = getentarray("run_past_tank_guy","targetname");
	array_thread( guys, ::add_spawn_function, ::run_past_tank_guy_think );
}

run_past_tank_guy_think()
{
	// won't this error if he dies before he reaches his goal?
	self.pacifist = true; 
	
	// compound calls are less readable, not to mention there are no spaces.
	self setgoalnode(getnode("end_of_run_path","script_noteworthy"));
	self.goalradius = 32;
	self waittill("goal");
	self delete();
}

first_autosave()
{
	
	// shouldn't this be on a targetname "trigger_autosave" in the map?
	// You dont need explicit script references for autosaves that are triggered by the level
	trigger = getent("autosave1","targetname");
	trigger waittill("trigger");
	autosave_by_name("At barn");	
	
}