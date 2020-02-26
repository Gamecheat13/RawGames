#include maps\_utility;
#include common_scripts\utility;


init()
{
	level.player setorigin((2516, -341, 52));
//	level.friendlyfire["min_participation"] = -100000000;
//	setdvar("psource_enable", "1");
//	setexpfog(.000051,.3,.3,.2,0);
//	mod = .8;

	PreCacheItem( "c4" );
	level.player SetActionSlot( 3, "weapon", "C4" );	//DPAD_LEFT
	level.player SetActionSlot( 4, "" );
	
	thread weaponmarks();
	thread teleporters();
	thread weapontable();
	//thread TestObjectives();
	thread maps\_utility::PlayerUnlimitedAmmoThread();
}


TestObjectives()
{
	wait( 1.0 );
	objective_add( 1, "active", "Test Objective", (800, 488, 32) );
	objective_current( 1 );
	objective_ring( 1 );

	wait( 2.0 );
	objective_delete( 1 );
	objective_add( 1, "active", "Test Objective 2", (488, 800, 32) );
	objective_current( 1 );
	objective_ring( 1 );
	
	while( true )
	{
		wait( 0.05 );
		line( (488, 800, 28), (488, 800, 36), (0, 0, 1.0), false, 1 );
		line( (484, 800, 32), (492, 800, 32), (0, 0, 1.0), false, 1 );
		line( (488, 804, 32), (488, 796, 32), (0, 0, 1.0), false, 1 );
	}
}

weaponadd(weapon,slot)
{
	precacheitem(weapon);
	weaponobj = spawnstruct();
	weaponobj.weapon = weapon;
	slot[slot.size] = weaponobj;
	return slot;
}

weapontable()
{
	
	weaponslots = [[level.weaponslotsthread]]();

/*
	weaponslots = weaponadd("ak47",weaponslots);
	weaponslots = weaponadd("ak47_grenadier",weaponslots);
	weaponslots = weaponadd("ak74u",weaponslots);
	weaponslots = weaponadd("beretta",weaponslots);
	weaponslots = weaponadd("usp",weaponslots);
	weaponslots = weaponadd("dragunov",weaponslots);
	weaponslots = weaponadd("m14_scoped",weaponslots);
	weaponslots = weaponadd("m40a3",weaponslots);
	weaponslots = weaponadd("g36c",weaponslots);
	weaponslots = weaponadd("m16_basic",weaponslots);
	weaponslots = weaponadd("m16_grenadier",weaponslots);
	weaponslots = weaponadd("m4_grunt",weaponslots);
	weaponslots = weaponadd("m4_silencer",weaponslots);
	weaponslots = weaponadd("m4_grenadier",weaponslots);
	weaponslots = weaponadd("m4m203_silencer",weaponslots);
	weaponslots = weaponadd("mp5",weaponslots);
	weaponslots = weaponadd("mp5_silencer",weaponslots);
	weaponslots = weaponadd("g3",weaponslots);
	weaponslots = weaponadd("winchester1200",weaponslots);
	weaponslots = weaponadd("at4",weaponslots);
	weaponslots = weaponadd("rpg",weaponslots);
	weaponslots = weaponadd("uzi",weaponslots);
	weaponslots = weaponadd("skorpion",weaponslots);
	weaponslots = weaponadd("m60e4",weaponslots);
	weaponslots = weaponadd("saw",weaponslots);
	*/


	
	weaponorg = [];
	weaponorg[0] = getent("weapontableorg_1","targetname").origin;
	weaponorg[1] = getent("weapontableorg_2","targetname").origin;
	weaponorg[2] = getent("weapontableorg_3","targetname").origin;
	weaponorg[3] = getent("weapontableorg_4","targetname").origin;
	
	weaponoffset = (0,-64,0);
	
	weaponsOnTable = 0;
	currentTable = 0;
	for(i=0;i<weaponslots.size;i++)
	{
		weaponslots[i].origin = weaponorg[currentTable];
		weaponorg[currentTable] += weaponoffset;
		thread weaponspawn( weaponslots[i] );
		weaponsOnTable++;
		if ( currentTable >= ( weaponorg.size - 1 ) )
			continue;
		if ( weaponsOnTable >= 13 )
		{
			weaponsOnTable = 0;
			currentTable++;
		}
	}
	
	level.weaponslots = weaponslots;
	
	thread weaponsprint();
}

getweaponarray()
{

}

weaponsprint()
{
	weaponslots = level.weaponslots;
	weapon = undefined;
	while(1)
	{
		for(i=0;i<weaponslots.size;i++)
		{
				weapon = getentarray("weapon_"+weaponslots[i].weapon,"classname");
				if(!weapon.size)
					continue;
				for(j=0;j<weapon.size;j++)
					print3d(weapon[j].origin, getsubstr(weapon[j].classname,7), (1,1,1), 1, .2);
				weapon = [];
		}
		wait .05;
	}
}


weaponspawn(weaponorg)
{
//	while(1)
//	{
		spawnedweapon = spawn("weapon_" + weaponorg.weapon,weaponorg.origin);
//		while(isdefined(spawnedweapon))
//			wait 1;
//	}
}


lookattele(trigger)
{
	level endon ("stop_teleporters");
	teleorgent = getent(trigger.target,"targetname");
	teleorgmarker = getent(teleorgent.target,"targetname");
	if(!isdefined(teleorgmarker.isup))
		teleorgmarker.isup = false;
	if(!isdefined(teleorgmarker.org_org))
		teleorgmarker.org_org = teleorgmarker.origin;
	
	while(1)
	{
		if(!level.player islookingat(trigger))
		{
			if(teleorgmarker.isup)
			{
				teleorgmarker.isup = false;
				teleorgmarker moveto(teleorgmarker.org_org,0.1,0.01,.01);
			}
			wait .05;
			continue;
		}

		if(!teleorgmarker.isup)
		{
			teleorgmarker.isup = true;
			teleorgmarker moveto(teleorgmarker.org_org+(0,0,48),0.1,0.01,.01);
		}
		if(level.player usebuttonpressed())
		{
			thread lookattele_engage(teleorgent);

		}

		wait .05;
	}
}

lookattele_engage(teleorgent)
{
		level notify ("stop_teleporters");
		level.player setplayerangles(teleorgent.angles);
		level.player setorigin (teleorgent.origin);
		while(level.player usebuttonpressed())
			wait .05;
		level notify ("refresh_teleporters");
}



teleporters()
{
	while(1)
	{
		array_levelthread(getentarray("trigger_lookat","classname"),::lookattele);
		level waittill ("refresh_teleporters");
	}
}


weaponmarks()
{
	array_levelthread(getentarray("targetwall","targetname"),::weaponmarks_trigger);
}

weaponmarks_trigger(trigger)
{
	trigger setcandamage(true);
	while(1)
	{
		points = [];
		points["time"] = [];
		points["origin"] = [];
		points["normal"] = [];
		counter = 0;
		while(1)
		{
			trigger.health = 1000000;
			thread weaponmarks_triggerdamage(trigger);
			thread weaponmarks_triggertimeout(trigger);
			msg = trigger waittill_any_return("donedmg","timeout");
			if(isdefined(msg)&& msg == "timeout")
				break;
			points["time"][counter] = trigger.time;
			assert(isdefined(trigger.damage_origin));
			points["origin"][counter] = trigger.damage_origin;
			points["normal"][counter] = trigger.normal;
			counter++;
		}
		if(points["time"].size)
			thread weaponmarks_tracepoints(points);
	}
}

weaponmarks_triggerdamage(trigger)
{
		trigger endon ("donedmg");
		trigger endon ("timeout");
		trigger waittill("damage",amount,who,normal,loc);

		assert(isdefined(loc));
		trigger.time = gettime();
		trigger.damage_origin = loc;
		trigger.normal = normal;
		
		thread plot_circle_fortime(1,5,5,(0,0,1),loc,normal);
		thread plot_circle_fortime(1,1,5,(1,0,0),loc,normal);
		trigger notify ("donedmg");
}

plot_circle_fortime(radius1,radius2,time,color,origin,normal)
{
	if(!isdefined(color))
		color = (0,1,0);
	hangtime = .05;
	circleres = 6;
	hemires = circleres/2;
	circleinc = 360/circleres;
	circleres++;
	plotpoints = [];
	rad = 0;

	plotpoints = [];
	rad = 0.000;
	timer = gettime()+(time*1000);
	radius = radius1;

	while(gettime()<timer)
	{
		dist = distance(level.player.origin,origin);
//		radius = radius1+((radius2-radius1)*(1-((timer-gettime())/(time*1000))));
		radius = radius2;
		angletoplayer = vectortoangles(normal);
		for(i=0;i<circleres;i++)
		{
			plotpoints[plotpoints.size] = origin+vector_multiply(anglestoforward((angletoplayer+(rad,90,0))),radius);
			rad+=circleinc;
		}
		plot_points(plotpoints,color[0],color[1],color[2],hangtime);
		plotpoints = [];
		wait hangtime;
	}
}


weaponmarks_triggertimeout(trigger)
{
	trigger endon ("damage");
	wait 1;
	trigger notify ("timeout");
}

weaponmarks_tracepoints(points)
{
	count = points["time"].size;
	for(i=0;i<count-1;i++)
	{
		assert(isdefined(points["origin"][i]));
		thread draw_line_for_time(points["origin"][i],points["origin"][i+1],0,i/count,(count-i)/count,3);
		if(i!=0)
			wait (points["time"][i]-points["time"][i-1])/1000;
	}
}


