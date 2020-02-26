#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	/*
	maps\_photosource::psource_create("rangeguns",(2455.12, -263.567, 54.2626),(13.8593, 125.365, 0));
	maps\_photosource::psource_create("range4000",(2616.81, -474.504, 59.9423),(4.35608, 177.006, 0));
	maps\_photosource::psource_create("range3500",(2359.75, -480.863, 52.5558),(0.98877, 177.94, 0));
	maps\_photosource::psource_create("range3000",(1876, -484.389, 52.125),(3.2959, 174.534, 0));
	maps\_photosource::psource_create("range2500",(1359.42, -461.199, 52.125),(0.878906, 176.732, 0));
	maps\_photosource::psource_create("range2000",(860.308, -441.641, 52.125),(-0.109863, 177.061, 0));
	maps\_photosource::psource_create("range1500",(358.542, -437.032, 52.125),(-0.109863, 177.061, 0));
	maps\_photosource::psource_create("range1000",(-138.914, -443.953, 52.125),(3.40576, 174.205, 0));
	maps\_photosource::psource_create("range500",(-638.514, -424.344, 52.0623),(1.2085, 168.92, 0));
	maps\_photosource::psource_create("rangeview",(-872.266, -75.1796, 60.125),(0.32959, -139.164, 0));
	*/ 
	maps\mp\_load::main();

/*
	level.weaponlist = [];
	level.weaponlist[level.weaponlist.size] = "flash_grenade_mp";             
	level.weaponlist[level.weaponlist.size] = "tear_grenade_mp";              
	level.weaponlist[level.weaponlist.size] = "frag_grenade_mp";               
	level.weaponlist[level.weaponlist.size] = "concussion_grenade_mp";        
	level.weaponlist[level.weaponlist.size] = "smoke_grenade_mp";    
	level.weaponlist[level.weaponlist.size] = "mp5_mp";                       
	level.weaponlist[level.weaponlist.size] = "c4_mp";          
	level.weaponlist[level.weaponlist.size] = "mac10_mp";                     
	level.weaponlist[level.weaponlist.size] = "p90_mp";                       
	level.weaponlist[level.weaponlist.size] = "m16_mp";                       
	level.weaponlist[level.weaponlist.size] = "m16_m203_mp";                  
	level.weaponlist[level.weaponlist.size] = "m203_mp";                      
	level.weaponlist[level.weaponlist.size] = "g36c_mp";                      
	level.weaponlist[level.weaponlist.size] = "g36c_ag36_mp";                 
	level.weaponlist[level.weaponlist.size] = "ag36_mp";                      
	level.weaponlist[level.weaponlist.size] = "scar_mp";                      
	level.weaponlist[level.weaponlist.size] = "scar_eglm_mp";                 
	level.weaponlist[level.weaponlist.size] = "eglm_mp";                      
	level.weaponlist[level.weaponlist.size] = "m14_scoped_mp";                
	level.weaponlist[level.weaponlist.size] = "m40a3_mp";                     
	level.weaponlist[level.weaponlist.size] = "barrett_mp";                   
	level.weaponlist[level.weaponlist.size] = "winchester1200_mp";            
	level.weaponlist[level.weaponlist.size] = "m1014_mp";                     
	level.weaponlist[level.weaponlist.size] = "m4_mp";                        
	level.weaponlist[level.weaponlist.size] = "sa80_mp";                      
	level.weaponlist[level.weaponlist.size] = "saw_mp";                       
	level.weaponlist[level.weaponlist.size] = "m60e4_mp";                     
	level.weaponlist[level.weaponlist.size] = "skorpion_mp";                  
	level.weaponlist[level.weaponlist.size] = "uzi_mp";                       
	level.weaponlist[level.weaponlist.size] = "bizon_mp";                     
	level.weaponlist[level.weaponlist.size] = "ak47_mp";                      
	level.weaponlist[level.weaponlist.size] = "ak47_gp25_mp";                 
	level.weaponlist[level.weaponlist.size] = "gp25_mp";                      
	level.weaponlist[level.weaponlist.size] = "g3_mp";                        
	level.weaponlist[level.weaponlist.size] = "g3_hk79_mp";                   
	level.weaponlist[level.weaponlist.size] = "hk79_mp";                      
	level.weaponlist[level.weaponlist.size] = "famas_mp";                     
	level.weaponlist[level.weaponlist.size] = "famas_m203_mp";                
	level.weaponlist[level.weaponlist.size] = "m203_f_mp";                    
	level.weaponlist[level.weaponlist.size] = "dragunov_mp";                  
	level.weaponlist[level.weaponlist.size] = "remington700_mp";              
	level.weaponlist[level.weaponlist.size] = "aw50_mp";                      
	level.weaponlist[level.weaponlist.size] = "ak74u_mp";                     
	level.weaponlist[level.weaponlist.size] = "groza_mp";                     
	level.weaponlist[level.weaponlist.size] = "rpk_mp";                       
	level.weaponlist[level.weaponlist.size] = "rpd_mp";                       
	level.weaponlist[level.weaponlist.size] = "rpg_mp";                       
	level.weaponlist[level.weaponlist.size] = "at4_mp";                       
	level.weaponlist[level.weaponlist.size] = "beretta_mp";           
	level.weaponlist[level.weaponlist.size] = "usp_mp";
	level.weaponlist[level.weaponlist.size] = "m4_m203_mp";
	*/

	while(!isdefined(level.player))
	{
		level.player = getentarray("player","classname")[0]; // only supporting one player on this test map - nate
		wait .05;
	}
	thread weapontable(); //weapons are precached by _weapons.gsc
	thread init();
	setExpFog(800, 6000, .5, .55 , .6, 0);
}
	
init()
{
	level.player setorigin((2516, -341, 52));
//	level.friendlyfire["min_participation"] = -100000000;
//	setdvar("psource_enable", "1");
//	setexpfog(.000051,.3,.3,.2,0);
//	mod = .8;

//	level.player SetActionSlot( 1, "weapon", "at4_mp" );	//DPAD_LEFT
//	level.player SetActionSlot( 2, "weapon", "rpg_mp" );	//DPAD_LEFT
	level.player SetActionSlot( 3, "weapon", "c4_mp" );	//DPAD_LEFT
	level.player SetActionSlot( 4, "weapon", "claymore_mp" );
	
	thread weaponmarks();
	thread teleporters();
	//thread TestObjectives();
	thread PlayerUnlimitedAmmoThread();
	
	SetDvar( "g_entinfo", "1" );
	SetDvar( "scr_war_timelimit", "99999" );

	wait 5.0;
	IPrintLnBold( "===========================================" );
	IPrintLnBold( "To disable unlimited ammo, set dvar:" );
	IPrintLnBold( "'UnlimitedAmmoOff' to '1'." );
	IPrintLnBold( "===========================================" );

	wait 4.0;
	VisionSetNaked( "village_defend" );
}

PlayerUnlimitedAmmoThread()
{
	while (1)
	{
		wait 5;

		if ( getdvar( "UnlimitedAmmoOff" ) == "1" )
			continue;

		currentWeapon = level.player getCurrentWeapon();
		if ( currentWeapon == "none" )
			continue;

		currentAmmo = level.player GetFractionMaxAmmo( currentWeapon );
		if ( currentAmmo < 0.2 )
			level.player GiveMaxAmmo( currentWeapon );
	}
}

weaponadd( weapon, slot )
{
	truename = weapon;
	weapon = "weapon_" + weapon;

	weaponobj = spawnstruct();
	weaponobj.weapon = weapon;
	weaponobj.truename = truename;

	slot[slot.size] = weaponobj;
	return slot;
}

weapontable()
{
	weaponslots = [];
	for( i=0; i < level.weaponlist.size; i++ )
	{
		weaponslots = weaponadd( level.weaponlist[i], weaponslots );
	}

	weaponorg[0] = getent( "weapontableorg_1", "targetname" ).origin;
	weaponorg[1] = getent( "weapontableorg_2", "targetname" ).origin;
	weaponorg[2] = getent( "weapontableorg_3", "targetname" ).origin;
	weaponorg[3] = getent( "weapontableorg_4", "targetname" ).origin;

	limits[0] = 21;
	limits[1] = 21;
	limits[2] = 22;
	limits[3] = 22;

	weaponoffset[0] = ( 15, -40, 0);
	weaponoffset[1] = ( -15, -40, 0);

	weaponsOnTable = 0;
	currentTable = 0;
	offsetIdx = 0;

	for( i=0; i < weaponslots.size; i++ )
	{
		if ( WeaponInventoryType( weaponslots[i].truename ) != "primary" )
			continue;
	
		weaponslots[i].origin = weaponorg[currentTable];
		weaponorg[currentTable] += weaponoffset[offsetIdx];
		thread weaponspawn( weaponslots[i] );
		weaponsOnTable++;

		//PrintLn( "Table #" + currentTable + ", " + i + ": " + weaponslots[i].truename );
		
		if ( offsetIdx == 0 )
			offsetIdx = 1;
		else
			offsetIdx = 0;

		if ( currentTable >= ( weaponorg.size - 1 ) )
			continue;

		if ( weaponsOnTable >= limits[currentTable] )
		{
			weaponsOnTable = 0;
			offsetIdx = 0;
			currentTable++;
		}
	}
	
	level.weaponslots = weaponslots;
}


weaponspawn(weaponorg)
{
//	while(1)
//	{
		spawnedweapon = spawn( weaponorg.weapon, weaponorg.origin );
//		spawnedweapon = spawn(weaponorg.weapon,weaponorg.origin);
//		while(isdefined(spawnedweapon))
//			wait 1;
//	}
}

/*
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
//			thread lookattele_engage(teleorgent);

		}

		wait .05;
	}
}
*/

/*
lookattele_engage(teleorgent)
{
		level notify ("stop_teleporters");
		level.player setplayerangles(teleorgent.angles);
		level.player setorigin (teleorgent.origin);
		while(level.player usebuttonpressed())
			wait .05;
		level notify ("refresh_teleporters");
}
*/


teleporters()
{
	/*
	while(1)
	{
		array_levelthread(getentarray("trigger_lookat","classname"),::lookattele);
		level waittill ("refresh_teleporters");
	}
	*/
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
		
//		thread plot_circle_fortime(1,5,5,(0,0,1),loc,normal);
//		thread plot_circle_fortime(1,1,5,(1,0,0),loc,normal);
		//print3d(<origin>, <text>, <color>, <alpha>, <scale>, <duration> )
		print3d (loc, "O", (1.0, 0.8, 0.5), 1, 2,5*20);
		trigger notify ("donedmg");
}

plot_circle_fortime(radius1,radius2,time,color,origin,normal)
{
	if(!isdefined(color))
		color = (0,1,0);
	hangtime = .05;
	circleres = 4;
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
			plotpoints[plotpoints.size] = origin+vector_scale(anglestoforward((angletoplayer+(rad,90,0))),radius);
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
//		thread draw_line_for_time(points["origin"][i],points["origin"][i+1],0,i/count,(count-i)/count,3);
	
		if(i!=0)
			wait (points["time"][i]-points["time"][i-1])/1000;
	}
}


/// stole this from maps\_utility.gsc

plot_points(plotpoints,r,g,b,timer)
{
	lastpoint = plotpoints[0];
	if(!isdefined(r))
		r = 1;
	if(!isdefined(g))
		g = 1;
	if(!isdefined(b))
		b = 1;
	if(!isdefined(timer))
		timer = 0.05;
	for(i=1;i<plotpoints.size;i++)
	{
		thread draw_line_for_time(lastpoint,plotpoints[i],r,g,b,timer);
		lastpoint = plotpoints[i];	
	}
}

draw_line_for_time(org1,org2,r,g,b,timer)
{
	timer = gettime()+(timer*1000);
	while(gettime()<timer)
	{
//		line (org1,org2, (r,g,b), 1 ,0);
		wait .05;		
	}
	
}