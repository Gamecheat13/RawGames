#include maps\_utility;
#include common_scripts\utility;


init()
{

//	level.friendlyfire["min_participation"] = -100000000;
//	setdvar("psource_enable", "1");
//	setexpfog(.000051,.3,.3,.2,0);
//	mod = .8;

	thread weapontable();
	
	level waittill( "first_player_ready" );

	thread init_debug_center_screen();	// center lines for making sure the gun aims properly

	wait 1;
	
	thread viewarms_cycling();
	
	//get_players()[0] setorigin((2516, -341, 52));
	//get_players()[0] thread spawn_guy_placement();
	thread debug_center_screen_toggle();
	thread teleporters();
	thread weaponmarks();	
	thread maps\_utility::PlayerUnlimitedAmmoThread();
	
}

viewarms_cycling()
{
	/#
	if( !IsDefined( level.viewarms ) || level.viewarms.size < 1 )
	{
		return;
	}
	
	level.viewarms_hud = NewHudElem();
	level.viewarms_hud.alignX = "left";
	level.viewarms_hud.fontScale = 1.5;
	level.viewarms_hud.x = -25;
	level.viewarms_hud.y = 315;
	level.viewarms_hud.color = ( 1, 1, 1 );
	
	playerone = get_players()[0];

	button = "DPAD_DOWN";
	
	currentIndex = 0;
	maxIndex = level.viewarms.size - 1;
	
	playerone SetViewModel( level.viewarms[currentIndex] );
	
	while( 1 )
	{
		if( playerone ButtonPressed( button ) )
		{
			currentIndex++;
			if( currentIndex > maxIndex )
			{
				currentIndex = 0;
			}
			
			playerone SetViewModel( level.viewarms[currentIndex] );
			thread viewarms_cycling_updatehud( currentIndex );
		}
		
		while( playerone ButtonPressed( button ) )
		{
			wait( 0.05 );
		}
		
		wait 0.05;
	}
	#/
}

viewarms_cycling_updatehud( currentIndex )
{
	level notify( "viewarm_cycle_updatehud" );
	level endon( "viewarm_cycle_updatehud" );
	
	ps = "";
	
	if( IsDefined( level.viewarms_lastSPIndex ) )
	{
		if( currentIndex <= level.viewarms_lastSPIndex )
		{
			ps = " (SP/MP)";
		}
		else
		{
			ps = " (MP only)";
		}
	}
	
	level.viewarms_hud SetText( level.viewarms[currentIndex] + ps );
	level.viewarms_hud FadeOverTime( 0.25 );
	level.viewarms_hud.alpha = 1;
	
	wait( 4 );
	
	level.viewarms_hud FadeOverTime( 0.5 );
	level.viewarms_hud.alpha = 0;
}

init_debug_center_screen()
{
	/#
	if( getdebugdvar( "debug_center_screen" ) == "" )
		setdvar( "debug_center_screen", "0" );
	
	for (;;)
	{
		if( getdebugdvar( "debug_center_screen" ) == "1" )
		{
			if (!isdefined (level.center_screen_debug_hudelem_active) || 
											level.center_screen_debug_hudelem_active == false)
											
			thread debug_center_screen();
		}
		else
		{	
			level notify ("stop center screen debug");
		}
		wait (0.05);
	}	
	#/
}

debug_center_screen_toggle()
{
	/#
	while (1)
	{
		if (get_players()[0] buttonPressed("DPAD_LEFT"))
		{
			if (getdebugdvar( "debug_center_screen" ) == "" || getdebugdvar( "debug_center_screen" ) == "0")
			{
				setdvar( "debug_center_screen", "1" );
			}
			else
			{
				setdvar( "debug_center_screen", "0" );
			}
		}
		
		wait 0.2;
	}	
	#/
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
		//thread weaponspawn( weaponslots[i] );
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
					print3d(weapon[j].origin, getsubstr(weapon[j].classname,7), (1,1,1), 1, .3);
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
		player = get_players();
		
		if(!player[0] islookingat(trigger))
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
		if(get_players()[0] usebuttonpressed())
		{
			thread lookattele_engage(teleorgent);

		}

		wait .05;
	}
}

lookattele_engage(teleorgent)
{
		level notify ("stop_teleporters");
		get_players()[0] setplayerangles(teleorgent.angles);
		get_players()[0] setorigin (teleorgent.origin);
		while(get_players()[0] usebuttonpressed())
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
		dist = distance(get_players()[0].origin,origin);
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

debug_center_screen()
{	
	level.center_screen_debug_hudelem_active = true;	
	wait 0.1;
			
	level.center_screen_debug_hudelem1 = newclienthudelem (get_players()[0]);
	level.center_screen_debug_hudelem1.alignX = "center";   
 	level.center_screen_debug_hudelem1.alignY = "middle";   
 	level.center_screen_debug_hudelem1.fontScale = 1;
 	level.center_screen_debug_hudelem1.alpha = 0.5;
 	level.center_screen_debug_hudelem1.x = (640/2) - 1;
 	level.center_screen_debug_hudelem1.y = (480/2);	
	level.center_screen_debug_hudelem1 setshader("white", 1000, 1);
	
	level.center_screen_debug_hudelem2 = newclienthudelem (get_players()[0]);
	level.center_screen_debug_hudelem2.alignX = "center";   
 	level.center_screen_debug_hudelem2.alignY = "middle";   
 	level.center_screen_debug_hudelem2.fontScale = 1;
 	level.center_screen_debug_hudelem2.alpha = 0.5;
 	level.center_screen_debug_hudelem2.x = (640/2) - 1;
 	level.center_screen_debug_hudelem2.y = (480/2);
	level.center_screen_debug_hudelem2 setshader("white", 1, 480);	
	
	level waittill ("stop center screen debug");
	
	level.center_screen_debug_hudelem1 destroy();
	level.center_screen_debug_hudelem2 destroy();
	level.center_screen_debug_hudelem_active = false;
}

// Targeting thread, sets up the drawing of smoke
spawn_guy_placement()
{	
	spawner = getent("spawn_anywhere", "targetname");
	
	if (!isdefined(spawner))
	{
		return;
	}
	
	// called on the player
	self thread spawn_anywhere_toggle_watch();
		
	wait 0.1;
	
	for (;;)
	{
		if (level.spawn_anywhere_toggle)
		{
			// Trace to where the player is looking
			direction = self getPlayerAngles();
			direction_vec = anglesToForward( direction );
			eye = self getEye();
			
			// offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
			trace = bullettrace( eye, eye + vector_multiply( direction_vec , 8000 ), 0, undefined );
			trace2 = bullettrace(  trace["position"]+(0,0,2),  trace["position"] - (0,0,100000), 0, undefined );
			
			// debug		
			thread draw_line_for_time( eye, trace2["position"], 1, 0, 0, 0.05 );
			
			spawner.origin = trace2["position"];
		
			self spawn_anywhere(spawner);
		}
		wait (0.05);
		
	}
}

spawn_anywhere_toggle_watch()
{
	level.spawn_anywhere_toggle = 0;
	while (1)
	{
		if (self ButtonPressed( "DPAD_DOWN" ) )
		{
			if (level.spawn_anywhere_toggle)
			{
				level.spawn_anywhere_toggle = false;
				iprintlnbold ("Spawn anywhere off");				
			}
			else
			{
				level.spawn_anywhere_toggle = true;
				iprintlnbold ("Press ADS to spawn AI");
			}
			wait 0.2;
		}
		wait 0.05;
	}

}

spawn_anywhere(spawner)
{
	if(self AdsButtonPressed())
	{
		spawn = spawner spawn_ai();

		if ( spawn_failed( spawn ) )
		{
			assertex( 0, "spawn failed from spawn anywhere guy" );
			return;			
		}
		
		wait 0.2;
			
	}
	spawner.count = 50;

}
