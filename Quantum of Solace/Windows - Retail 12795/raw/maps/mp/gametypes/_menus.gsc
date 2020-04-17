init()
{
	level.xenon = (getdvar("xenonGame") == "true"); // for lack of a better place to put it
	level.consoleGame = (getdvar("consoleGame") == "true"); // for lack of a better place to put it
	
	level.bx = (getdvar("BxGame") == "true"); // GEBE
	
	game["menu_team"] = "team_marinesopfor";
	game["menu_class"] = "class";
	game["menu_class_allies"] = "class";
	game["menu_class_axis"] = "class";
	
	game["menu_ingame"] = "ingame";
	game["menu_ingame_allies"] = "ingame";
	game["menu_ingame_axis"] = "ingame";

	game["menu_warmup"] = "warmup";

	game["menu_victory_mi6"] = "victory_marines";
	game["menu_victory_org"] = "victory_opfor";
	game["menu_victory_draw"] = "victory_draw";
	game["menu_victory_freeforall"] = "victory_freeforall";

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
			game["menu_class_axis"] += "_splitscreen";
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
	precacheMenu(game["menu_class_axis"]);
	precacheMenu(game["menu_ingame"]);
	precacheMenu(game["menu_ingame_allies"]);
	precacheMenu(game["menu_ingame_axis"]);
	precacheMenu(game["menu_warmup"]);
	precacheMenu(game["menu_victory_mi6"]);
	precacheMenu(game["menu_victory_org"]);
	precacheMenu(game["menu_victory_draw"]);
	precacheMenu(game["menu_victory_freeforall"]);

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
				if(menu == "class" && !getDvarInt("cl_match_warmup") )
				{
					self openMenu(game["menu_ingame"]);
				}
				if(menu == game["menu_options"] || menu == game["menu_team"])
				{
//					assert(self.pers["team"] == "allies" || self.pers["team"] == "axis");
	
					if(self.pers["team"] == "allies")
						self openMenu(game["menu_class_allies"]);
					else
						self openMenu(game["menu_class_axis"]);
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

		if(response == "changeclass")
		{
		  self closeMenu();
		  self closeInGameMenu();
		  if(self.pers["team"] == "allies")
		    self openMenu(game["menu_class_allies"]);
		  else
		    self openMenu(game["menu_class_axis"]);
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
		if(menu == "character_options")
		{
			maps\mp\gametypes\_class::onCharacterOptionsResponse(response);
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
		else if( menu == game["menu_class_allies"] || menu == game["menu_class_axis"] )
		{
			self closeMenu();
			self closeInGameMenu();

			self.selectedClass = true;
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
