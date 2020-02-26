#include maps\mp\_utility;

init()
{
	/#
	if (GetDvar("scr_showspawns") == "")
	{
		SetDvar("scr_showspawns", "0");
	}
	if (GetDvar("scr_showstartspawns") == "")
	{
		SetDvar("scr_showstartspawns", "0");
	}

	precacheItem("defaultweapon_mp");
	precacheModel("defaultactor");

	thread addTestClients();
	
	setdvar( "scr_giveperk", "" );
	setdvar( "scr_takeperk", "" );

	// SRS 3/19/08: engagement distance debug dvar toggle watcher
	thread engagement_distance_debug_toggle();

	setdvar( "debug_dynamic_ai_spawning", "0" );
	
	for(;;)
	{
		updateDevSettings();
		wait .05;
	}
	#/
}

/#
updateDevSettings()
{
	show_spawns= GetDvarInt("scr_showspawns");
	show_start_spawns= GetDvarInt("scr_showstartspawns");
	
	if (show_spawns >= 1)
	{
		show_spawns= 1;
	}
	else
	{
		show_spawns= 0;
	}
	
	if (show_start_spawns >= 1)
	{
		show_start_spawns= 1;
	}
	else
	{
		show_start_spawns= 0;
	}
	
	if (!IsDefined(level.show_spawns) || level.show_spawns!=show_spawns)
	{
		level.show_spawns= show_spawns;
		SetDvar("scr_showspawns", level.show_spawns);

		if(level.show_spawns)
		{
			showSpawnpoints();
		}
		else
		{
			hideSpawnpoints();
		}
	}
	
	if (!IsDefined(level.show_start_spawns) || level.show_start_spawns!=show_start_spawns)
	{
		level.show_start_spawns= show_start_spawns;
		SetDvar("scr_showstartspawns", level.show_start_spawns);

		if(level.show_start_spawns)
		{
			showStartSpawnpoints();
		}
		else
		{
			hideStartSpawnpoints();
		}
	}
	
	updateMinimapSetting();
	
	if( level.players.size > 0 )
	{
		if ( getdvarint("scr_giveradar") == 1 )
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				level.players[i] maps\mp\gametypes\_hardpoints::giveHardpointItem( "radar_mp" );
			}
			setdvar( "scr_giveradar", "0" );
		}
		if ( getdvarint("scr_giveartillery") == 1 )
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				level.players[i] maps\mp\gametypes\_hardpoints::giveHardpointItem( "artillery_mp" );
			}
			setdvar( "scr_giveartillery", "0" );
		}
		if ( getdvarint("scr_givedogs") == 1 )
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				level.players[i] maps\mp\gametypes\_hardpoints::giveHardpointItem( "dogs_mp" );
			}
			setdvar( "scr_givedogs", "0" );
		}
	}
	if ( getdvar("scr_giveperk") != "" )
	{
		perk = getdvar("scr_giveperk");
		for ( i = 0; i < level.players.size; i++ )
		{
			level.players[i] setPerk( perk );
			level.players[i].extraPerks[ perk ] = 1;
		}
		setdvar( "scr_giveperk", "" );
	}
	if ( getdvar("scr_takeperk") != "" )
	{
		perk = getdvar("scr_takeperk");
		for ( i = 0; i < level.players.size; i++ )
		{
			level.players[i] unsetPerk( perk );
			level.players[i].extraPerks[ perk ] = undefined;
		}
		setdvar( "scr_takeperk", "" );
	}
	
	if ( getDvar( "scr_x_kills_y" ) != "" )
	{
		nameTokens = strTok( getDvar( "scr_x_kills_y" ), " " );
		if ( nameTokens.size > 1 )
			thread xKillsY( nameTokens[0], nameTokens[1] );

		setDvar( "scr_x_kills_y", "" );
	}

	if ( getDvar("scr_usedogs") != "" )
	{
		ownerName = getDvar( "scr_usedogs" );
		setDvar( "scr_usedogs", "" );

		owner = undefined;
		for ( index = 0; index < level.players.size; index++ )
		{
			if ( level.players[index].name == ownerName )
				owner = level.players[index];
		}
		
		if ( isDefined( owner ) )
			owner maps\mp\gametypes\_hardpoints::triggerHardpoint( "dogs_mp" );
	}
	
	if ( getDvar( "scr_set_level" ) != "" )
	{
		level.players[0].pers["rank"] = 0;
		level.players[0].pers["rankxp"] = 0;
		
		newRank = min( getDvarInt( "scr_set_level" ), 54 );
		newRank = max( newRank, 1 );

		setDvar( "scr_set_level", "" );

		lastXp = 0;
		for ( index = 0; index <= newRank; index++ )		
		{
			newXp = maps\mp\gametypes\_rank::getRankInfoMinXP( index );
			level.players[0] thread maps\mp\gametypes\_rank::giveRankXP( "kill", newXp - lastXp );
			lastXp = newXp;
			wait ( 0.25 );
			self notify ( "cancel_notify" );
		}
	}

	if ( getDvar( "scr_givexp" ) != "" )
	{
		level.players[0] thread maps\mp\gametypes\_rank::giveRankXP( "challenge", getDvarInt( "scr_givexp" ) );
		
		setDvar( "scr_givexp", "" );
	}


	if ( getDvar( "scr_unlock_weapon" ) != "" )
	{
		level.players[0] thread maps\mp\gametypes\_rank::unlockWeapon( getDvar( "scr_unlock_weapon" ) );
		setDvar( "scr_unlock_weapon", "" );
	}

	if ( getDvar( "scr_unlock_camo" ) != "" )
	{
		level.players[0] thread maps\mp\gametypes\_rank::unlockCamoSingular( getDvar( "scr_unlock_camo" ) );
		setDvar( "scr_unlock_camo", "" );
	}

	if ( getDvar( "scr_unlock_attachment" ) != "" )
	{
		level.players[0] thread maps\mp\gametypes\_rank::unlockAttachmentSingular( getDvar( "scr_unlock_attachment" ) );
		setDvar( "scr_unlock_attachment", "" );
	}

	if ( getDvar( "scr_do_notify" ) != "" )
	{
		for ( i = 0; i < level.players.size; i++ )
			level.players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage( getDvar( "scr_do_notify" ), getDvar( "scr_do_notify" ), game["icons"]["allies"] );
		
		announcement( getDvar( "scr_do_notify" ) );
		setDvar( "scr_do_notify", "" );
	}	
	if ( getDvar( "scr_entdebug" ) != "" )
	{
		ents = getEntArray();
		level.entArray = [];
		level.entCounts = [];
		level.entGroups = [];
		for ( index = 0; index < ents.size; index++ )
		{
			classname = ents[index].classname;
			if ( !isSubStr( classname, "_spawn" ) )
			{
				curEnt = ents[index];

				level.entArray[level.entArray.size] = curEnt;
				
				if ( !isDefined( level.entCounts[classname] ) )
					level.entCounts[classname] = 0;
			
				level.entCounts[classname]++;

				if ( !isDefined( level.entGroups[classname] ) )
					level.entGroups[classname] = [];
			
				level.entGroups[classname][level.entGroups[classname].size] = curEnt;
			}
		}
	}

	if( getdvar( "debug_dynamic_ai_spawning" ) == "1" && !IsDefined( level.larry ) )
	{
		thread larry_thread();
	}
	else if ( getdvar( "debug_dynamic_ai_spawning" ) == "0" )
	{
		level notify ( "kill_larry" );	
	}
}

giveExtraPerks()
{
	if ( !isdefined( self.extraPerks ) )
		return;
	
	perks = getArrayKeys( self.extraPerks );
	
	for ( i = 0; i < perks.size; i++ )
		self setPerk( perks[i] );
}

xKillsY( attackerName, victimName )
{
	attacker = undefined;
	victim = undefined;
	
	for ( index = 0; index < level.players.size; index++ )
	{
		if ( level.players[index].name == attackerName )
			attacker = level.players[index];
		else if ( level.players[index].name == victimName )
			victim = level.players[index];
	}
	
	if ( !isAlive( attacker ) || !isAlive( victim ) )
		return;
		
	victim thread [[level.callbackPlayerDamage]](
		attacker, // eInflictor The entity that causes the damage.(e.g. a turret)
		attacker, // eAttacker The entity that is attacking.
		1000, // iDamage Integer specifying the amount of damage done
		0, // iDFlags Integer specifying flags that are to be applied to the damage
		"MOD_RIFLE_BULLET", // sMeansOfDeath Integer specifying the method of death
		"none", // sWeapon The weapon number of the weapon used to inflict the damage
		(0,0,0), // vPoint The point the damage is from?
		(0,0,0), // vDir The direction of the damage
		"none", // sHitLoc The location of the hit
		0 // psOffsetTime The time offset for the damage
	);
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
			
			players = get_players();
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
					
					if ( level.console )
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

//	for ( index = 1; index < 24; index++ )
//		kick( index );

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
			
		ent[i].pers["isBot"] = true;
		ent[i] thread TestClient("autoassign");
	}
	
	thread addTestClients();
}

TestClient(team)
{
	self endon( "disconnect" );

	while(!isdefined(self.pers["team"]))
		wait .05;

	self notify("menuresponse", game["menu_team"], team);
	wait 0.5;

	classes = getArrayKeys( level.classMap );
	okclasses = [];
	for ( i = 0; i < classes.size; i++ )
	{
		if ( !issubstr( classes[i], "custom" ) && isDefined( level.default_perk[ level.classMap[ classes[i] ] ] ) )
			okclasses[ okclasses.size ] = classes[i];
	}
	
	assert( okclasses.size );

	while( 1 )
	{
		class = okclasses[ randomint( okclasses.size ) ];
		
		if ( !level.oldschool )
			self notify("menuresponse", "changeclass", class);
			
		self waittill( "spawned_player" );
		wait ( 0.10 );
	}
}

showOneSpawnPoint(
	spawn_point,
	color,
	notification)
{
	k_player_height= get_player_height();
	center = spawn_point.origin;
	forward = anglestoforward(spawn_point.angles);
	right = anglestoright(spawn_point.angles);

	forward = maps\mp\_utility::vector_scale(forward, 16);
	right = maps\mp\_utility::vector_scale(right, 16);

	a = center + forward - right;
	b = center + forward + right;
	c = center - forward + right;
	d = center - forward - right;
	
	thread lineUntilNotified(a, b, color, 0, notification);
	thread lineUntilNotified(b, c, color, 0, notification);
	thread lineUntilNotified(c, d, color, 0, notification);
	thread lineUntilNotified(d, a, color, 0, notification);

	thread lineUntilNotified(a, a + (0, 0, k_player_height), color, 0, notification);
	thread lineUntilNotified(b, b + (0, 0, k_player_height), color, 0, notification);
	thread lineUntilNotified(c, c + (0, 0, k_player_height), color, 0, notification);
	thread lineUntilNotified(d, d + (0, 0, k_player_height), color, 0, notification);

	a = a + (0, 0, k_player_height);
	b = b + (0, 0, k_player_height);
	c = c + (0, 0, k_player_height);
	d = d + (0, 0, k_player_height);
	
	thread lineUntilNotified(a, b, color, 0, notification);
	thread lineUntilNotified(b, c, color, 0, notification);
	thread lineUntilNotified(c, d, color, 0, notification);
	thread lineUntilNotified(d, a, color, 0, notification);

	center = center + (0, 0, k_player_height/2);
	arrow_forward = anglestoforward(spawn_point.angles);
	arrowhead_forward = anglestoforward(spawn_point.angles);
	arrowhead_right = anglestoright(spawn_point.angles);

	arrow_forward = maps\mp\_utility::vector_scale(arrow_forward, 32);
	arrowhead_forward = maps\mp\_utility::vector_scale(arrowhead_forward, 24);
	arrowhead_right = maps\mp\_utility::vector_scale(arrowhead_right, 8);
	
	a = center + arrow_forward;
	b = center + arrowhead_forward - arrowhead_right;
	c = center + arrowhead_forward + arrowhead_right;
	
	thread lineUntilNotified(center, a, color, 0, notification);
	thread lineUntilNotified(a, b, color, 0, notification);
	thread lineUntilNotified(a, c, color, 0, notification);

	thread print3DUntilNotified(spawn_point.origin + (0, 0, k_player_height), spawn_point.classname, color, 1, 1, notification);
	
	return;
}

showSpawnpoints()
{
	if (IsDefined(level.spawnpoints))
	{
		// show standard spawn points
		color= (1, 1, 1);
		for (spawn_point_index= 0; spawn_point_index<level.spawnpoints.size; spawn_point_index++)
		{
			showOneSpawnPoint(level.spawnpoints[spawn_point_index], color, "hide_spawnpoints");
		}
	}
	
	return;
}

hideSpawnpoints()
{
	level notify("hide_spawnpoints");
	
	return;
}

showStartSpawnpoints()
{
	if (IsDefined(level.spawn_axis_start))
	{
		color= (1, 0, 1);
		for (spawn_point_index= 0; spawn_point_index<level.spawn_axis_start.size; spawn_point_index++)
		{
			showOneSpawnPoint(level.spawn_axis_start[spawn_point_index], color, "hide_startspawnpoints");
		}
	}
	if (IsDefined(level.spawn_allies_start))
	{
		color= (0, 1, 1);
		for (spawn_point_index= 0; spawn_point_index<level.spawn_allies_start.size; spawn_point_index++)
		{
			showOneSpawnPoint(level.spawn_allies_start[spawn_point_index], color, "hide_startspawnpoints");
		}
	}
	
	return;
}

hideStartSpawnpoints()
{
	level notify("hide_startspawnpoints");
	
	return;
}

print3DUntilNotified(origin, text, color, alpha, scale, notification)
{
	level endon(notification);
	
	for(;;)
	{
		print3d(origin, text, color, alpha, scale);
		wait .05;
	}
}

lineUntilNotified(start, end, color, depthTest, notification)
{
	level endon(notification);
	
	for(;;)
	{
		line(start, end, color, depthTest);
		wait .05;
	}
}

// -- SRS 3/19/08: engagement distance debug.  only works for P1 --

get_playerone()
{
	return level.players[0];
}

// this controls the engagement distance debug stuff with a dvar
engagement_distance_debug_toggle()
{
	level endon( "kill_engage_dist_debug_toggle_watcher" );

	if( !IsDefined( getdvarint("debug_engage_dists") ) )
		setdvar( "debug_engage_dists", "0" );
	
	lastState = getdvarint( "debug_engage_dists" );

	while( 1 )
	{
		currentState = getdvarint( "debug_engage_dists" );

		if( dvar_turned_on( currentState ) && !dvar_turned_on( lastState ) )
		{
			// turn it on
			weapon_engage_dists_init();
			thread debug_realtime_engage_dist();
			//thread debug_ai_engage_dist();

			lastState = currentState;
		}
		else if( !dvar_turned_on( currentState ) && dvar_turned_on( lastState ) )
		{
			// send notify to turn off threads
			level notify( "kill_all_engage_dist_debug" );

			lastState = currentState;
		}

		wait( 0.3 );
	}
}

dvar_turned_on( val )
{
	if( val <= 0 )
	{
		return false;
	}
	else
	{
		return true;
	}
}

engagement_distance_debug_init()
{
	// set up debug stuff
	level.debug_xPos = -50;
	level.debug_yPos = 250;
	level.debug_yInc = 18;

	level.debug_fontScale = 1.5;

	level.white = ( 1, 1, 1 );
	level.green = ( 0, 1, 0 );
	level.yellow = ( 1, 1, 0 );
	level.red = ( 1, 0, 0 );

	level.realtimeEngageDist = NewHudElem();
	level.realtimeEngageDist.alignX = "left";
	level.realtimeEngageDist.fontScale = level.debug_fontScale;
	level.realtimeEngageDist.x = level.debug_xPos;
	level.realtimeEngageDist.y = level.debug_yPos;
	level.realtimeEngageDist.color = level.white;
	level.realtimeEngageDist SetText( "Current Engagement Distance: " );

	xPos = level.debug_xPos + 207;

	level.realtimeEngageDist_value = NewHudElem();
	level.realtimeEngageDist_value.alignX = "left";
	level.realtimeEngageDist_value.fontScale = level.debug_fontScale;
	level.realtimeEngageDist_value.x = xPos;
	level.realtimeEngageDist_value.y = level.debug_yPos;
	level.realtimeEngageDist_value.color = level.white;
	level.realtimeEngageDist_value SetValue( 0 );

	xPos += 37;

	level.realtimeEngageDist_middle = NewHudElem();
	level.realtimeEngageDist_middle.alignX = "left";
	level.realtimeEngageDist_middle.fontScale = level.debug_fontScale;
	level.realtimeEngageDist_middle.x = xPos;
	level.realtimeEngageDist_middle.y = level.debug_yPos;
	level.realtimeEngageDist_middle.color = level.white;
	level.realtimeEngageDist_middle SetText( " units, SHORT/LONG by " );

	xPos += 105;

	level.realtimeEngageDist_offvalue = NewHudElem();
	level.realtimeEngageDist_offvalue.alignX = "left";
	level.realtimeEngageDist_offvalue.fontScale = level.debug_fontScale;
	level.realtimeEngageDist_offvalue.x = xPos;
	level.realtimeEngageDist_offvalue.y = level.debug_yPos;
	level.realtimeEngageDist_offvalue.color = level.white;
	level.realtimeEngageDist_offvalue SetValue( 0 );

	hudObjArray = [];
	hudObjArray[0] = level.realtimeEngageDist;
	hudObjArray[1] = level.realtimeEngageDist_value;
	hudObjArray[2] = level.realtimeEngageDist_middle;
	hudObjArray[3] = level.realtimeEngageDist_offvalue;

	return hudObjArray;
}

engage_dist_debug_hud_destroy( hudArray, killNotify )
{
	level waittill( killNotify );

	for( i = 0; i < hudArray.size; i++ )
	{
		hudArray[i] Destroy();
	}
}

weapon_engage_dists_init()
{
	level.engageDists = [];

	// first pass ok
	genericPistol = spawnstruct();
	genericPistol.engageDistMin = 125;
	genericPistol.engageDistOptimal = 225;
	genericPistol.engageDistMulligan = 50;  // range around the optimal value that is still optimal
	genericPistol.engageDistMax = 400;

	// first pass ok
	shotty = spawnstruct();
	shotty.engageDistMin = 50;
	shotty.engageDistOptimal = 200;
	shotty.engageDistMulligan = 75;
	shotty.engageDistMax = 350;

	// first pass ok
	genericSMG = spawnstruct();
	genericSMG.engageDistMin = 100;
	genericSMG.engageDistOptimal = 275;
	genericSMG.engageDistMulligan = 100;
	genericSMG.engageDistMax = 500;

	// first pass NEED TEST
	genericLMG = spawnstruct();
	genericLMG.engageDistMin = 325;
	genericLMG.engageDistOptimal = 550;
	genericLMG.engageDistMulligan = 150;
	genericLMG.engageDistMax = 850;

	// first pass ok
	genericRifleSA = spawnstruct();
	genericRifleSA.engageDistMin = 325;
	genericRifleSA.engageDistOptimal = 550;
	genericRifleSA.engageDistMulligan = 150;
	genericRifleSA.engageDistMax = 850;

	// first pass ok
	genericRifleBolt = spawnstruct();
	genericRifleBolt.engageDistMin = 350;
	genericRifleBolt.engageDistOptimal = 600;
	genericRifleBolt.engageDistMulligan = 150;
	genericRifleBolt.engageDistMax = 900;

	// first pass NEED TEST
	genericHMG = spawnstruct();
	genericHMG.engageDistMin = 390;
	genericHMG.engageDistOptimal = 600;
	genericHMG.engageDistMulligan = 100;
	genericHMG.engageDistMax = 900;

	// first pass ok
	genericSniper = spawnstruct();
	genericSniper.engageDistMin = 950;
	genericSniper.engageDistOptimal = 1700;
	genericSniper.engageDistMulligan = 300;
	genericSniper.engageDistMax = 3000;

	// Pistols
	engage_dists_add( "colt_mp", genericPistol );
	engage_dists_add( "nambu_mp", genericPistol );
	engage_dists_add( "tokarev_mp", genericPistol );
	engage_dists_add( "walther_mp", genericPistol );

	// SMGs
	engage_dists_add( "thompson_mp", genericSMG );
	engage_dists_add( "type100_smg_mp", genericSMG );
	engage_dists_add( "ppsh_mp", genericSMG );
	engage_dists_add( "mp40_mp", genericSMG );
	engage_dists_add( "stg44_mp", genericSMG );
	engage_dists_add( "sten_mp", genericSMG );
	engage_dists_add( "sten_silenced_mp", genericSMG );

	// shotgun
	engage_dists_add( "shotgun_mp", shotty );

	// LMGs
	engage_dists_add( "bar_mp", genericLMG );
	engage_dists_add( "bar_bipod_mp", genericLMG );
	engage_dists_add( "type99_lmg_mp", genericLMG );
	engage_dists_add( "type99_lmg_bipod_mp", genericLMG );
	engage_dists_add( "dp28_mp", genericLMG );
	engage_dists_add( "dp28_bipod_mp", genericLMG );
	engage_dists_add( "fg42_mp", genericLMG );
	engage_dists_add( "fg42_bipod_mp", genericLMG );
	engage_dists_add( "bren_mp", genericLMG );
	engage_dists_add( "bren_bipod_mp", genericLMG );

	// Rifles (semiautomatic)
	engage_dists_add( "m1garand_mp", genericRifleSA );
	engage_dists_add( "m1garand_bayonet_mp", genericRifleSA );
	engage_dists_add( "m1carbine_mp", genericRifleSA );
	engage_dists_add( "m1carbine_bayonet_mp", genericRifleSA );
	engage_dists_add( "svt40_mp", genericRifleSA );
	engage_dists_add( "gewehr43_mp", genericRifleSA );

	// Rifles (bolt-action)
	engage_dists_add( "springfield_mp", genericRifleBolt );
	engage_dists_add( "springfield_bayonet_mp", genericRifleBolt );
	engage_dists_add( "type99_rifle_mp", genericRifleBolt );
	engage_dists_add( "type99_rifle_bayonet_mp", genericRifleBolt );
	engage_dists_add( "mosin_rifle_mp", genericRifleBolt );
	engage_dists_add( "mosin_rifle_bayonet_mp", genericRifleBolt );
	engage_dists_add( "kar98k_mp", genericRifleBolt );
	engage_dists_add( "kar98k_bayonet_mp", genericRifleBolt );
	engage_dists_add( "lee_enfield_mp", genericRifleBolt );
	engage_dists_add( "lee_enfield_bayonet_mp", genericRifleBolt );

	// HMGs
	engage_dists_add( "30cal_mp", genericHMG );
	engage_dists_add( "30cal_bipod_mp", genericHMG );
	engage_dists_add( "mg42_mp", genericHMG );
	engage_dists_add( "mg42_bipod_mp", genericHMG );

	// Sniper Rifles
	engage_dists_add( "springfield_scoped_mp", genericSniper );
	engage_dists_add( "type99_rifle_scoped_mp", genericSniper );
	engage_dists_add( "mosin_rifle_scoped_mp", genericSniper );
	engage_dists_add( "kar98k_scoped_mp", genericSniper );
	engage_dists_add( "fg42_scoped_mp", genericSniper );
	engage_dists_add( "lee_enfield_scoped_mp", genericSniper );

	// start waiting for weapon changes
	level thread engage_dists_watcher();
}

engage_dists_add( weapontypeStr, values )
{
	level.engageDists[weapontypeStr] = values;
}

// returns a script_struct, or undefined, if the lookup failed
get_engage_dists( weapontypeStr )
{
	if( IsDefined( level.engageDists[weapontypeStr] ) )
	{
		return level.engageDists[weapontypeStr];
	}
	else
	{
		return undefined;
	}
}

// checks currently equipped weapon to make sure that engagement distance values are correct
engage_dists_watcher()
{
	level endon( "kill_all_engage_dist_debug" );
	level endon( "kill_engage_dists_watcher" );

	while( 1 )
	{
		player = get_playerone();
		playerWeapon = player GetCurrentWeapon();

		if( !IsDefined( player.lastweapon ) )
		{
			player.lastweapon = playerWeapon;
		}
		else
		{
			if( player.lastweapon == playerWeapon )
			{
				wait( 0.05 );
				continue;
			}
		}

		values = get_engage_dists( playerWeapon );

		if( IsDefined( values ) )
		{
			level.weaponEngageDistValues = values;
		}
		else
		{
			level.weaponEngageDistValues = undefined;
		}

		player.lastweapon = playerWeapon;

		wait( 0.05 );
	}
}

debug_realtime_engage_dist()
{
	level endon( "kill_all_engage_dist_debug" );
	level endon( "kill_realtime_engagement_distance_debug" );

	hudObjArray = engagement_distance_debug_init();
	level thread engage_dist_debug_hud_destroy( hudObjArray, "kill_all_engage_dist_debug" );

	level.debugRTEngageDistColor = level.green;

	player = get_playerone();

	while( 1 )
	{
		lastTracePos = ( 0, 0, 0 );

		// Trace to where the player is looking
		direction = player GetPlayerAngles();
		direction_vec = AnglesToForward( direction );
		eye = player GetEye();

		eye = ( eye[0], eye[1], eye[2] + 20 );

		trace = BulletTrace( eye, eye + vector_scale( direction_vec, 10000 ), true, player );
		tracePoint = trace["position"];
		traceNormal =  trace["normal"];
		traceDist = int( Distance( eye, tracePoint ) );  // just need an int, thanks

		if( tracePoint != lastTracePos )
		{
			lastTracePos = tracePoint;

			if( !IsDefined( level.weaponEngageDistValues ) )
			{
				hudobj_changecolor( hudObjArray, level.white );
				hudObjArray engagedist_hud_changetext( "nodata", tracedist );
			}
			else
			{
				// for convenience
				engageDistMin = level.weaponEngageDistValues.engageDistMin;
				engageDistOptimal = level.weaponEngageDistValues.engageDistOptimal;
				engageDistMulligan = level.weaponEngageDistValues.engageDistMulligan;
				engageDistMax = level.weaponEngageDistValues.engageDistMax;

				// if inside our engagement distance range...
				if( ( traceDist >= engageDistMin ) && ( traceDist <= engageDistMax ) )
				{
					// if in the optimal range...
					if( ( traceDist >= ( engageDistOptimal - engageDistMulligan ) )
						&& ( traceDist <= ( engageDistOptimal + engageDistMulligan ) ) )
					{
						hudObjArray engagedist_hud_changetext( "optimal", tracedist );
						hudobj_changecolor( hudObjArray, level.green );
					}
					else
					{
						hudObjArray engagedist_hud_changetext( "ok", tracedist );
						hudobj_changecolor( hudObjArray, level.yellow );
					}
				}
				else if( traceDist < engageDistMin )
				{
					hudobj_changecolor( hudObjArray, level.red );
					hudObjArray engagedist_hud_changetext( "short", tracedist );
				}
				else if( traceDist > engageDistMax )
				{
					hudobj_changecolor( hudObjArray, level.red );
					hudObjArray engagedist_hud_changetext( "long", tracedist );
				}
			}
		}

		// draw our trace spot
		// plot_circle_fortime(radius1,radius2,time,color,origin,normal)
		thread plot_circle_fortime( 1, 5, 0.05, level.debugRTEngageDistColor, tracePoint, traceNormal );
		thread plot_circle_fortime( 1, 1, 0.05, level.debugRTEngageDistColor, tracePoint, traceNormal );

		wait( 0.05 );
	}
}

hudobj_changecolor( hudObjArray, newcolor )
{
	for( i = 0; i < hudObjArray.size; i++ )
	{
		hudObj = hudObjArray[i];

		if( hudObj.color != newcolor )
		{
			hudObj.color = newcolor;
			level.debugRTEngageDistColor = newcolor;
		}
	}
}

// self = an array of hud objects
engagedist_hud_changetext( engageDistType, units )
{
	if( !IsDefined( level.lastDistType ) )
	{
		level.lastDistType = "none";
	}

	if( engageDistType == "optimal" )
	{
		self[1] SetValue( units );
		self[2] SetText( "units: OPTIMAL!" );
		self[3].alpha = 0;
	}
	else if( engageDistType == "ok" )
	{
		self[1] SetValue( units );
		self[2] SetText( "units: OK!" );
		self[3].alpha = 0;
	}
	else if( engageDistType == "short" )
	{
		amountUnder = level.weaponEngageDistValues.engageDistMin - units;
		self[1] SetValue( units );
		self[3] SetValue( amountUnder );
		self[3].alpha = 1;

		if( level.lastDistType != engageDistType )
		{
			self[2] SetText( "units: SHORT by " );
		}
	}
	else if( engageDistType == "long" )
	{
		amountOver = units - level.weaponEngageDistValues.engageDistMax;
		self[1] SetValue( units );
		self[3] SetValue( amountOver );
		self[3].alpha = 1;

		if( level.lastDistType != engageDistType )
		{
			self[2] SetText( "units: LONG by " );
		}
	}
	else if( engageDistType == "nodata" )
	{
		self[1] SetValue( units );
		self[2] SetText( " units: (NO CURRENT WEAPON VALUES)" );
		self[3].alpha = 0;
	}

	level.lastDistType = engageDistType;
}

// draws print3ds above enemy AI heads to show contact distances
/*
debug_ai_engage_dist()
{
	level endon( "kill_all_engage_dist_debug" );
	level endon( "kill_ai_engagement_distance_debug" );

	player = get_playerone();

	while( 1 )
	{
		axis = GetAIArray( "axis" );

		if( IsDefined( axis ) && axis.size > 0 )
		{	
			playerEye = player GetEye();

			for( i = 0; i < axis.size; i++ )
			{
				ai = axis[i];
				aiEye = ai GetEye();

				if( SightTracePassed( playerEye, aiEye, false, player ) )
				{
					dist = Distance( playerEye, aiEye );

					drawColor = level.white;
					drawString = "-";

					if( !IsDefined( level.weaponEngageDistValues ) )
					{
						drawColor = level.white;
					}
					else
					{
						// for convenience
						engageDistMin = level.weaponEngageDistValues.engageDistMin;
						engageDistOptimal = level.weaponEngageDistValues.engageDistOptimal;
						engageDistMulligan = level.weaponEngageDistValues.engageDistMulligan;
						engageDistMax = level.weaponEngageDistValues.engageDistMax;

						// if inside our engagement distance range...
						if( ( dist >= engageDistMin ) && ( dist <= engageDistMax ) )
						{
							// if in the optimal range...
							if( ( dist >= ( engageDistOptimal - engageDistMulligan ) )
								&& ( dist <= ( engageDistOptimal + engageDistMulligan ) ) )
							{
								drawColor = level.green;
								drawString = "RAD";
							}
							// else it's just ok
							else
							{
								drawColor = level.yellow;
								drawString = "MEH";
							}
						}
						else if( dist < engageDistMin )
						{
							drawColor = level.red;
							drawString = "BAD";
						}
						else if( dist > engageDistMax )
						{
							drawColor = level.red;
							drawString = "BAD";
						}
					}		

					scale = dist / 525;
					Print3d( ai.origin + ( 0, 0, 67 ), drawString, drawColor, 1, scale );
				}
			}
		}

		wait( 0.05 );
	}
}
*/

// draws a circle in script
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

	rad = 0.00;
	timer = gettime()+(time*1000);
	radius = radius1;

	while(gettime()<timer)
	{
		// radius = radius1+((radius2-radius1)*(1-((timer-gettime())/(time*1000))));
		radius = radius2;
		angletoplayer = vectortoangles(normal);
		for(i=0;i<circleres;i++)
		{
			plotpoints[plotpoints.size] = origin+vector_scale(anglestoforward((angletoplayer+(rad,90,0))),radius);
			rad+=circleinc;
		}
		maps\mp\_utility::plot_points(plotpoints,color[0],color[1],color[2],hangtime);
		plotpoints = [];
		wait hangtime;
	}
}


// -- end engagement distance debug --

larry_thread()
{
	level.larry = SpawnStruct();

	level.players[0] thread larry_init( level.larry ); 

	// Cleanup hudelems, dummy models, etc.
	level waittill ( "kill_larry" );

	larry_hud_destroy( level.larry );

	if ( IsDefined( level.larry.model ) )
		level.larry.model delete();

	if ( IsDefined( level.larry.ai ) )
	{
		for ( i = 0; i < level.larry.ai.size; i++ )
		{
			kick( level.larry.ai[i] GetEntityNumber() );
		}
	}

	level.larry = undefined;
}

larry_init( larry )
{	
	level endon ( "kill_larry" );

	// HUD
	larry_hud_init( larry );

	// Model
	larry.model = spawn( "script_model", (0,0,0) );
	larry.model setmodel( "defaultactor" );

	// AI
	larry.ai = [];

	wait 0.1;

	for ( ;; )
	{
		wait (0.05);

		if ( larry.ai.size > 0 )
		{
			larry.model Hide();
			continue;
		}
		
		// Trace to where the player is looking
		direction = self getPlayerAngles();
		direction_vec = anglesToForward( direction );
		eye = self getEye();

		// offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
		trace = bullettrace( eye, eye + vector_scale( direction_vec , 8000 ), 0, undefined );

		dist = distance (eye, trace["position"]);		
		position = eye + vector_scale( direction_vec , (dist - 64) );

		larry.model.origin = position;
		larry.model.angles = self.angles + ( 0, 180, 0 );

		if ( self UseButtonPressed() )
		{
			self larry_ai( larry );
						
			while ( self UseButtonPressed() )
				wait ( 0.05 );
		}
	}
}

larry_ai( larry )
{
	larry.ai[larry.ai.size] = AddTestClient();
	
	i = larry.ai.size - 1;
	larry.ai[i].pers["isBot"] = true;
	larry.ai[i] thread TestClient( "autoassign" );

	larry.ai[i] thread larry_ai_thread( larry, larry.model.origin, larry.model.angles );
	larry.ai[i] thread larry_ai_damage( larry );
	larry.ai[i] thread larry_ai_health( larry );
}

larry_ai_thread( larry, origin, angles )
{
	level endon( "kill_larry" );

	for ( ;; )
	{
		self waittill( "spawned_player" );

		//larry.clearTextMarker ClearAllTextAfterHudElem();

		larry.menu[larry.menu_health]	SetValue( self.health );
		larry.menu[larry.menu_damage]	SetText( "" );	
		larry.menu[larry.menu_range]	SetText( "" );	
		larry.menu[larry.menu_hitloc]	SetText( "" );	
		larry.menu[larry.menu_weapon]	SetText( "" );	
		larry.menu[larry.menu_perks]	SetText( "" );	

		self SetOrigin( origin );
		self SetPlayerAngles( angles );
	}
}

larry_ai_damage( larry )
{
	level endon( "kill_larry" );

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );

		range = "";

		if ( attacker == level.players[0] )
		{
			eye = level.players[0] GetEye();
			eye = ( eye[0], eye[1], eye[2] + 20 );

			range = int( Distance( eye, self.origin ) );
		}

		//larry.clearTextMarker ClearAllTextAfterHudElem();

		larry.menu[larry.menu_health]	SetValue( self.health );
		larry.menu[larry.menu_damage]	SetValue( damage );	
		larry.menu[larry.menu_range]	SetValue( range );	
		larry.menu[larry.menu_hitloc]	SetText( "" );	
		larry.menu[larry.menu_weapon]	SetText( "" );	
		larry.menu[larry.menu_perks]	SetText( "" );	
	}
}

larry_ai_health( larry )
{
	level endon( "kill_larry" );

	for ( ;; )
	{
		wait( 0.05 );

		larry.menu[larry.menu_health] SetValue( self.health );
	}
}

larry_hud_init( larry )
{
	x = -45;
	y = 275;
	menu_name = "larry_menu";

	larry.hud = new_hud( menu_name, undefined, x, y, 1 );
	larry.hud SetShader( "white", 100, 70 );
	larry.hud.alignX = "left";
	larry.hud.alignY = "top";
	larry.hud.sort = 10;
	larry.hud.alpha = 0.6;	
	larry.hud.color = ( 0.0, 0.0, 0.5 );

	larry.menu[0] = new_hud( menu_name, "Larry Health:",	x + 5, y + 10, 1 );
	larry.menu[1] = new_hud( menu_name, "Damage:",			x + 5, y + 20, 1 );
	larry.menu[2] = new_hud( menu_name, "Range:",			x + 5, y + 30, 1 );
	larry.menu[3] = new_hud( menu_name, "Hit Location:",	x + 5, y + 40, 1 );
	larry.menu[4] = new_hud( menu_name, "Weapon:",			x + 5, y + 50, 1 );
	larry.menu[5] = new_hud( menu_name, "Perks:",			x + 5, y + 60, 1 );

	larry.clearTextMarker = NewDebugHudElem();
	larry.clearTextMarker.alpha = 0;
	larry.clearTextMarker setText( "marker" );

	larry.menu_health	= larry.menu.size;
	larry.menu_damage	= larry.menu.size + 1;
	larry.menu_range	= larry.menu.size + 2;
	larry.menu_hitloc	= larry.menu.size + 3;
	larry.menu_weapon	= larry.menu.size + 4;
	larry.menu_perks	= larry.menu.size + 5;

	x_offset = 70;

	larry.menu[larry.menu_health]	= new_hud( menu_name, "", x + x_offset, y + 10, 1 );
	larry.menu[larry.menu_damage]	= new_hud( menu_name, "", x + x_offset, y + 20, 1 );
	larry.menu[larry.menu_range]	= new_hud( menu_name, "", x + x_offset, y + 30, 1 );
	larry.menu[larry.menu_hitloc]	= new_hud( menu_name, "", x + x_offset, y + 40, 1 );
	larry.menu[larry.menu_weapon]	= new_hud( menu_name, "", x + x_offset, y + 50, 1 );
	larry.menu[larry.menu_perks]	= new_hud( menu_name, "", x + x_offset, y + 60, 1 );
}

larry_hud_destroy( larry )
{
	if ( IsDefined( larry.hud ) )
	{
		larry.hud Destroy();

		for ( i = 0; i < larry.menu.size; i++ )
		{
			larry.menu[i] Destroy();
		}

		//larry.clearTextMarker ClearAllTextAfterHudElem();
		larry.clearTextMarker Destroy();
	}
}

new_hud( hud_name, msg, x, y, scale )
{
	if( !IsDefined( level.hud_array ) )
	{
		level.hud_array = [];
	}

	if( !IsDefined( level.hud_array[hud_name] ) )
	{
		level.hud_array[hud_name] = [];
	}

	hud = set_hudelem( msg, x, y, scale );
	level.hud_array[hud_name][level.hud_array[hud_name].size] = hud;
	return hud;
}

//------------------------------------------------------//
// set_hudelem( [text], x, y, [scale], [alpha] )		//
//		Actually creates the hudelem					//
//------------------------------------------------------//
// self		- n/a										//
// text		- The text to be displayed					//
// x		- Sets the x position of the hudelem		//
// y		- Sets the y position of the hudelem		//
// scale	- Sets the scale of the hudelem				//
// alpha	- Sets the alpha of the hudelem				//
//------------------------------------------------------//
set_hudelem( text, x, y, scale, alpha, sort, debug_hudelem )
{
		if( !IsDefined( alpha ) )
		{
			alpha = 1;
		}

		if( !IsDefined( scale ) )
		{
			scale = 1;
		}

		if( !IsDefined( sort ) )
		{
			sort = 20;
		}

		hud = NewDebugHudElem();
		hud.debug_hudelem = true;
		
		hud.location = 0;
		hud.alignX = "left";
		hud.alignY = "middle";
		hud.foreground = 1;
		hud.fontScale = scale;
		hud.sort = sort;
		hud.alpha = alpha;
		hud.x = x;
		hud.y = y;
		hud.og_scale = scale;

		if( IsDefined( text ) )
		{
			hud SetText( text );
		}

		return hud;
}


// -- end dynamic AI spawning --

#/