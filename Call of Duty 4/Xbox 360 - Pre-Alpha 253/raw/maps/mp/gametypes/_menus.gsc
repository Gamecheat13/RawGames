init()
{
	level.xenon = (getdvar("xenonGame") == "true"); // for lack of a better place to put it
	level.consoleGame = (getdvar("consoleGame") == "true"); // for lack of a better place to put it
	
	game["menu_team"] = "team_marinesopfor";
	game["menu_class_allies"] = "class_marines";
	game["menu_changeclass_allies"] = "changeclass_marines";
	game["menu_class_axis"] = "class_opfor";
	game["menu_changeclass_axis"] = "changeclass_opfor";

	if(!level.consoleGame)
	{
		game["menu_callvote"] = "callvote";
		game["menu_muteplayer"] = "muteplayer";
		precacheMenu(game["menu_callvote"]);
		precacheMenu(game["menu_muteplayer"]);
		level.xboxlive = false;
	}
	else
	{
		game["menu_controls"] = "ingame_controls";
		game["menu_options"] = "ingame_options";
		game["menu_leavegame"] = "popup_leavegame";

		level.splitscreen = isSplitScreen();
		level.xboxlive = getDvarInt( "onlinegame" );
		if(level.splitscreen)
		{
			game["menu_team"] += "_splitscreen";
			game["menu_class_allies"] += "_splitscreen";
			game["menu_changeclass_allies"] += "_splitscreen";
			game["menu_class_axis"] += "_splitscreen";
			game["menu_changeclass_axis"] += "_splitscreen";
			game["menu_controls"] += "_splitscreen";
			game["menu_options"] += "_splitscreen";
			game["menu_leavegame"] += "_splitscreen";
		}

		precacheMenu(game["menu_controls"]);
		precacheMenu(game["menu_options"]);
		precacheMenu(game["menu_leavegame"]);
		precacheMenu("scoreboard");
	}

	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_class_allies"]);
	precacheMenu(game["menu_changeclass_allies"]);
	precacheMenu(game["menu_class_axis"]);
	precacheMenu(game["menu_changeclass_axis"]);
	precacheString( &"MP_HOST_ENDED_GAME" );

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player setClientDvar("ui_3dwaypointtext", "1");
		player.enable3DWaypoints = true;
		player setClientDvar("ui_deathicontext", "1");
		player.enableDeathIcons = true;
		
		player thread onMenuResponse();
	}
}

onMenuResponse()
{
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		//iprintln("^6", response);
		
		if(response == "back")
		{
			self closeMenu();
			self closeInGameMenu();

			if(level.consoleGame)
			{
				if(menu == game["menu_changeclass_allies"] || menu == game["menu_changeclass_axis"] || menu == game["menu_team"])
				{
//					assert(self.pers["team"] == "allies" || self.pers["team"] == "axis");
	
					if( self.pers["team"] == "allies" )
						self openMenu( game["menu_class_allies"] );
					if( self.pers["team"] == "axis" )
						self openMenu( game["menu_class_axis"] );
				}
			}
				
			continue;
		}

		if(response == "changeteam")
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu(game["menu_team"]);
		}
	
		if(response == "changeclass_marines")
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu(game["menu_changeclass_allies"]);
		}
		
		if(response == "changeclass_opfor")
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu(game["menu_changeclass_axis"]);
		}
		
		// rank update text options
		if(response == "xpTextToggle")
		{
			self.enableText = !self.enableText;
			if (self.enableText)
				self setClientDvar( "ui_xpText", "1" );
			else
				self setClientDvar( "ui_xpText", "0" );
			continue;
		}

		// 3D Waypoint options
		if(response == "waypointToggle")
		{
			self.enable3DWaypoints = !self.enable3DWaypoints;
			if (self.enable3DWaypoints)
				self setClientDvar( "ui_3dwaypointtext", "1" );
			else
				self setClientDvar( "ui_3dwaypointtext", "0" );
//			self maps\mp\gametypes\_objpoints::updatePlayerObjpoints();
			continue;
		}

		// 3D death icon options
		if(response == "deathIconToggle")
		{
			self.enableDeathIcons = !self.enableDeathIcons;
			if (self.enableDeathIcons)
				self setClientDvar( "ui_deathicontext", "1" );
			else
				self setClientDvar( "ui_deathicontext", "0" );
			self maps\mp\gametypes\_deathicons::updateDeathIconsEnabled();
			continue;
		}
		
		if(response == "endgame")
		{
			// TODO: replace with onSomethingEvent call 
			if(level.splitscreen)
			{
				announcement( &"MP_HOST_ENDED_GAME" );
				if ( level.consoleGame )
					endparty();
				level.skipVote = true;
				level thread maps\mp\gametypes\_globallogic::forceEnd();
			}
				
			continue;
		}

		if(response == "endround")
		{
			// TODO: replace with onSomethingEvent call 
			announcement( &"MP_HOST_ENDED_GAME" );
			level.skipVote = true;
			level thread maps\mp\gametypes\_globallogic::forceEnd();
				
			continue;
		}

		if(menu == game["menu_team"])
		{
			switch(response)
			{
			case "allies":
				self closeMenu();
				self closeInGameMenu();
				self [[level.allies]]();
				break;

			case "axis":
				self closeMenu();
				self closeInGameMenu();
				self [[level.axis]]();
				break;

			case "autoassign":
				self closeMenu();
				self closeInGameMenu();
				self [[level.autoassign]]();
				break;

			case "spectator":
				self closeMenu();
				self closeInGameMenu();
				self [[level.spectator]]();
				break;
			}
		}	// the only responses remain are change class events
		else if(menu == game["menu_changeclass_allies"] || menu == game["menu_changeclass_axis"])
		{
			self closeMenu();
			self closeInGameMenu();

			self [[level.class]](response);
		}
		else if(!level.consoleGame)
		{
			if(menu == game["menu_quickcommands"])
				maps\mp\gametypes\_quickmessages::quickcommands(response);
			else if(menu == game["menu_quickstatements"])
				maps\mp\gametypes\_quickmessages::quickstatements(response);
			else if(menu == game["menu_quickresponses"])
				maps\mp\gametypes\_quickmessages::quickresponses(response);
		}
	}
}
