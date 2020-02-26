init()
{
	if(getdvar("scr_showspawns") == "")
		setdvar("scr_showspawns", "0");

	precacheItem("defaultweapon_mp");

	thread addTestClients();

	for(;;)
	{
		updateDevSettings();
		wait .05;
	}
}

updateDevSettings()
{
	showspawns = getdvarInt("scr_showspawns");
	if(showspawns > 1)
		showspawns = 1;
	else if(showspawns < 0)
		showspawns = 0;
	
	if(!isdefined(level.showspawns) || level.showspawns != showspawns)
	{
		level.showspawns = showspawns;
		setdvar("scr_showspawns", level.showspawns);

		if(level.showspawns)
			showSpawnpoints();
		else
			hideSpawnpoints();
	}
	
	updateMinimapSetting();
}

updateMinimapSetting()
{	
	// use 0 for no required map aspect ratio.
	requiredMapAspectRatio = getdvarfloat("scr_requiredMapAspectRatio");
	
	if (!isdefined(level.minimapheight)) {
		setdvar("scr_minimap_height", "0");
		level.minimapheight = 0;
	}
	minimapheight = getdvarfloat("scr_minimap_height");
	if (minimapheight != level.minimapheight)
	{
		if (isdefined(level.minimaporigin)) {
			level.minimapplayer unlink();
			level.minimaporigin delete();
			level notify("end_draw_map_bounds");
		}
		
		if (minimapheight > 0)
		{
			level.minimapheight = minimapheight;
			
			players = getentarray("player", "classname");
			if (players.size > 0)
			{
				player = players[0];
				
				corners = getentarray("minimap_corner", "targetname");
				if (corners.size == 2)
				{
					viewpos = (corners[0].origin + corners[1].origin);
					viewpos = (viewpos[0]*.5, viewpos[1]*.5, viewpos[2]*.5);

					maxcorner = (corners[0].origin[0], corners[0].origin[1], viewpos[2]);
					mincorner = (corners[0].origin[0], corners[0].origin[1], viewpos[2]);
					if (corners[1].origin[0] > corners[0].origin[0])
						maxcorner = (corners[1].origin[0], maxcorner[1], maxcorner[2]);
					else
						mincorner = (corners[1].origin[0], mincorner[1], mincorner[2]);
					if (corners[1].origin[1] > corners[0].origin[1])
						maxcorner = (maxcorner[0], corners[1].origin[1], maxcorner[2]);
					else
						mincorner = (mincorner[0], corners[1].origin[1], mincorner[2]);
					
					viewpostocorner = maxcorner - viewpos;
					viewpos = (viewpos[0], viewpos[1], viewpos[2] + minimapheight);
					
					origin = spawn("script_origin", player.origin);
					
					northvector = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
					eastvector = (northvector[1], 0 - northvector[0], 0);
					disttotop = vectordot(northvector, viewpostocorner);
					if (disttotop < 0)
						disttotop = 0 - disttotop;
					disttoside = vectordot(eastvector, viewpostocorner);
					if (disttoside < 0)
						disttoside = 0 - disttoside;
					
					// extend map bounds to meet the required aspect ratio
					if ( requiredMapAspectRatio > 0 )
					{
						mapAspectRatio = disttoside / disttotop;
						if ( mapAspectRatio < requiredMapAspectRatio )
						{
							incr = requiredMapAspectRatio / mapAspectRatio;
							disttoside *= incr;
							addvec = vecscale( eastvector, vectordot( eastvector, maxcorner - viewpos ) * (incr - 1) );
							mincorner -= addvec;
							maxcorner += addvec;
						}
						else
						{
							incr = mapAspectRatio / requiredMapAspectRatio;
							disttotop *= incr;
							addvec = vecscale( northvector, vectordot( northvector, maxcorner - viewpos ) * (incr - 1) );
							mincorner -= addvec;
							maxcorner += addvec;
						}
					}
					
					if ( level.consoleGame )
					{
						aspectratioguess = 16.0/9.0;
						// .8 would be .75 but it needs to be bigger because of safe area
						angleside = 2 * atan(disttoside * .8 / minimapheight);
						angletop = 2 * atan(disttotop * aspectratioguess * .8 / minimapheight);
					}
					else
					{
						aspectratioguess = 4.0/3.0;
						angleside = 2 * atan(disttoside / minimapheight);
						angletop = 2 * atan(disttotop * aspectratioguess / minimapheight);
					}
					if (angleside > angletop)
						angle = angleside;
					else
						angle = angletop;
					
					znear = minimapheight - 1000;
					if (znear < 16) znear = 16;
					if (znear > 10000) znear = 10000;
					
					player linkto(origin);
					origin.origin = viewpos + (0,0,-62);
					origin.angles = (90, getnorthyaw(), 0);
					

					player TakeAllWeapons();
					player GiveWeapon( "defaultweapon_mp" );
					player setclientdvar("cg_drawgun", "0");
					player setclientdvar("cg_draw2d", "0");
					player setclientdvar("cg_drawfps", "0");
					player setclientdvar("fx_enable", "0");
					player setclientdvar("r_fog", "0");
					player setclientdvar("r_highLodDist", "0"); // (turns of lods)
					player setclientdvar("r_znear", znear); // (reduces z-fighting)
					player setclientdvar("r_lodscale", "0");
					player setclientdvar("cg_drawversion", "0");
					player setclientdvar("sm_enable", "1");
					player setclientdvar("player_view_pitch_down", "90");
					player setclientdvar("player_view_pitch_up", "0");
					player setclientdvar("cg_fov", angle);
					player setclientdvar("cg_fovmin", "1");
					
					// hide 3D icons
					if ( isdefined( level.objPoints ) )
					{
						for ( i = 0; i < level.objPointNames.size; i++ )
						{
							if ( isdefined( level.objPoints[level.objPointNames[i]] ) )
								level.objPoints[level.objPointNames[i]] destroy();
						}
						level.objPoints = [];
						level.objPointNames = [];
					}
					
					level.minimapplayer = player;
					level.minimaporigin = origin;
					
					thread drawMiniMapBounds(viewpos, mincorner, maxcorner);
					
					wait .05;
					
					player setplayerangles(origin.angles);
				}
				else
					println("^1Error: There are not exactly 2 \"minimap_corner\" entities in the level.");
			}
			else
				setdvar("scr_minimap_height", "0");
		}
	}
}

vecscale(vec, scalar)
{
	return (vec[0]*scalar, vec[1]*scalar, vec[2]*scalar);
}

drawMiniMapBounds(viewpos, mincorner, maxcorner)
{
	level notify("end_draw_map_bounds");
	level endon("end_draw_map_bounds");
	
	viewheight = (viewpos[2] - maxcorner[2]);
	
	north = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
	
	diaglen = length(mincorner - maxcorner);

	/*diagonal = maxcorner - mincorner;
	side = vecscale(north, vectordot(diagonal, north));
	
	origcorner0 = mincorner;
	origcorner1 = mincorner + side;
	origcorner2 = maxcorner;
	origcorner3 = maxcorner - side;*/
	
	mincorneroffset = (mincorner - viewpos);
	mincorneroffset = vectornormalize((mincorneroffset[0], mincorneroffset[1], 0));
	mincorner = mincorner + vecscale(mincorneroffset, diaglen * 1/800);
	maxcorneroffset = (maxcorner - viewpos);
	maxcorneroffset = vectornormalize((maxcorneroffset[0], maxcorneroffset[1], 0));
	maxcorner = maxcorner + vecscale(maxcorneroffset, diaglen * 1/800);
	
	diagonal = maxcorner - mincorner;
	side = vecscale(north, vectordot(diagonal, north));
	sidenorth = vecscale(north, abs(vectordot(diagonal, north)));
	
	corner0 = mincorner;
	corner1 = mincorner + side;
	corner2 = maxcorner;
	corner3 = maxcorner - side;
	
	toppos = vecscale(mincorner + maxcorner, .5) + vecscale(sidenorth, .51);
	textscale = diaglen * .003;
	
	while(1)
	{
		line(corner0, corner1);
		line(corner1, corner2);
		line(corner2, corner3);
		line(corner3, corner0);

		/*line(origcorner0, origcorner1, (1,0,0));
		line(origcorner1, origcorner2, (1,0,0));
		line(origcorner2, origcorner3, (1,0,0));
		line(origcorner3, origcorner0, (1,0,0));*/
		
		print3d(toppos, "This Side Up", (1,1,1), 1, textscale);
		
		wait .05;
	}
}

addTestClients()
{
	wait 5;

	for(;;)
	{
		if(getdvarInt("scr_testclients") > 0)
			break;
		wait 1;
	}

	testclients = getdvarInt("scr_testclients");
	setDvar( "scr_testclients", 0 );
	for(i = 0; i < testclients; i++)
	{
		ent[i] = addtestclient();

		if (!isdefined(ent[i])) {
			println("Could not add test client");
			wait 1;
			continue;
		}
			
		/*if(i & 1)
			team = "allies";
		else
			team = "axis";*/
		
		ent[i] thread TestClient("autoassign");
	}
}

TestClient(team)
{
	self endon( "disconnect" );

	while(!isdefined(self.pers["team"]))
		wait .05;

	self notify("menuresponse", game["menu_team"], team);
	wait 0.5;

	classes = getArrayKeys( level.classMap );

	while ( true )
	{
		class = classes[randomint( classes.size )];
	
		if(self.pers["team"] == "allies")
			self notify("menuresponse", game["menu_class_allies"], class);
		else if(self.pers["team"] == "axis")
			self notify("menuresponse", game["menu_class_axis"], class);
			
		wait ( randomfloatrange( 5.0, 10.0 ) );
	}
}

showSpawnpoints()
{
	if(!isdefined(level.spawnpoints))
		return;
	
	for(i = 0; i < level.spawnpoints.size; i++)
	{
		spawnpoint = level.spawnpoints[i];
		
		//color = spawnpoint._color;
		//if(!isdefined(color))
			color = (1, 1, 1);

		center = spawnpoint.origin;
		forward = anglestoforward(spawnpoint.angles);
		right = anglestoright(spawnpoint.angles);

		forward = maps\mp\_utility::vector_scale(forward, 16);
		right = maps\mp\_utility::vector_scale(right, 16);

		a = center + forward - right;
		b = center + forward + right;
		c = center - forward + right;
		d = center - forward - right;
		
		thread lineUntilNotified(a, b, color, 0);
		thread lineUntilNotified(b, c, color, 0);
		thread lineUntilNotified(c, d, color, 0);
		thread lineUntilNotified(d, a, color, 0);

		thread lineUntilNotified(a, a + (0, 0, 72), color, 0);
		thread lineUntilNotified(b, b + (0, 0, 72), color, 0);
		thread lineUntilNotified(c, c + (0, 0, 72), color, 0);
		thread lineUntilNotified(d, d + (0, 0, 72), color, 0);

		a = a + (0, 0, 72);
		b = b + (0, 0, 72);
		c = c + (0, 0, 72);
		d = d + (0, 0, 72);
		
		thread lineUntilNotified(a, b, color, 0);
		thread lineUntilNotified(b, c, color, 0);
		thread lineUntilNotified(c, d, color, 0);
		thread lineUntilNotified(d, a, color, 0);

		center = center + (0, 0, 36);
		arrow_forward = anglestoforward(spawnpoint.angles);
		arrowhead_forward = anglestoforward(spawnpoint.angles);
		arrowhead_right = anglestoright(spawnpoint.angles);

		arrow_forward = maps\mp\_utility::vector_scale(arrow_forward, 32);
		arrowhead_forward = maps\mp\_utility::vector_scale(arrowhead_forward, 24);
		arrowhead_right = maps\mp\_utility::vector_scale(arrowhead_right, 8);
		
		a = center + arrow_forward;
		b = center + arrowhead_forward - arrowhead_right;
		c = center + arrowhead_forward + arrowhead_right;
		
		thread lineUntilNotified(center, a, (1, 1, 1), 0);
		thread lineUntilNotified(a, b, (1, 1, 1), 0);
		thread lineUntilNotified(a, c, (1, 1, 1), 0);

		thread print3DUntilNotified(spawnpoint.origin + (0, 0, 72), spawnpoint.classname, (1, 1, 1), 1, 1);
	}
}

print3DUntilNotified(origin, text, color, alpha, scale)
{
	level endon("hide_spawnpoints");
	
	for(;;)
	{
		print3d(origin, text, color, alpha, scale);
		wait .05;
	}
}

lineUntilNotified(start, end, color, depthTest)
{
	level endon("hide_spawnpoints");
	
	for(;;)
	{
		line(start, end, color, depthTest);
		wait .05;
	}
}

hideSpawnpoints()
{
	level notify("hide_spawnpoints");
}
