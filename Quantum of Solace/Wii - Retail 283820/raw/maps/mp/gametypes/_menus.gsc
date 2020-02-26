init()
{
	level.wii = (getdvar("wiiGame") == "true");
	level.consoleGame = (getdvar("consoleGame") == "true"); 
	
	game["menu_changeclass_allies"] = "bx_changeclass_mi6";
	game["menu_changeclass_axis"]	= "bx_changeclass_org";
	game["menu_class_allies"]		= "bx_mi6";
	game["menu_class_axis"]			= "bx_org";	
	game["menu_spectate"] 			= "bx_spectator";
	game["menu_leavegame"] 			= "popup_leavegame";
	game["menu_ingame"] 			= "mp_bx_ingame";

	game["menu_ingame_axis"]		= "bx_ingame_org";
	game["menu_ingame_allies"]		= "bx_ingame_mi6";

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
		game["menu_controls"] = "bx_controls";
		game["menu_options"] = "ingame_options";
		game["menu_split_wait"] = "mp_bx_splitscreen_wait";


		level.splitscreen = isSplitScreen();
		level.xboxlive = getDvarInt( "onlinegame" );
		if(level.splitscreen)
		{
			
			
			game["menu_class_allies"] += "_splitscreen";
			game["menu_class_axis"] += "_splitscreen";
			
			game["menu_changeclass_allies"] += "_splitscreen";
			game["menu_changeclass_axis"]	+= "_splitscreen";
			
			game["menu_ingame"] += "_splitscreen";
			game["menu_ingame_allies"] += "_splitscreen";
			game["menu_ingame_axis"] += "_splitscreen";

			game["menu_spectate"] += "_splitscreen";
			game["menu_controls"] += "_splitscreen";
			game["menu_options"] += "_splitscreen";
			game["menu_leavegame"] += "_splitscreen";
		}

		precacheMenu(game["menu_controls"]);
		precacheMenu(game["menu_options"]);
		precacheMenu(game["menu_split_wait"]);
	}

	
	precacheMenu(game["menu_changeclass_allies"]);
	precacheMenu(game["menu_changeclass_axis"]);
	precacheMenu(game["menu_ingame"]);
	precacheMenu(game["menu_ingame_allies"]);
	precacheMenu(game["menu_ingame_axis"]);
	precacheMenu(game["menu_class_allies"]);
	precacheMenu(game["menu_class_axis"]);
	precacheMenu(game["menu_spectate"]);
	precacheMenu(game["menu_leavegame"]);
	precacheMenu("scoreboard");

	precacheString( &"MP_HOST_ENDED_GAME" );
	precacheString( &"MP_GAME_ENDED" );

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
		
		
		tokens = strtok( response, "/" );

		if( tokens[0] == "menu_class_inited" )
		{
			self.menuSelectedClass = self maps\mp\gametypes\_class::getResponseToken( response, "class", "/" );
			self.menuSelectedSideArm = self maps\mp\gametypes\_class::getResponseToken( response, "sidearm", "/" );
		}
		
		if(response == "back")
		{
			self closeMenu();
			self closeInGameMenu();
			
			if (menu == game["menu_changeclass_allies"])
				self openMenu(game["menu_ingame_allies"]);
			else if (menu == game["menu_changeclass_axis"])
				self openMenu(game["menu_ingame_axis"]);
			else if (menu == game["menu_controls"])
			{
				if (self.pers["team"] == "allies")
					self openMenu(game["menu_ingame_allies"]);
				else
					self openMenu(game["menu_ingame_axis"]);
			}

			
			
			


			
			
			
			
			
			
				
			
			continue;
		}

		if(response == "changeteam")
		{	
			self closeMenu();
			self closeInGameMenu();
			if( self.pers["team"] == "allies" )
				self [[level.axis]]();
			else
				self [[level.allies]]();
			
			if(level.splitscreen)
				self [[level.class]]( "class/" + self.menuSelectedClass + "/sidearm/" + self.menuSelectedSideArm );
		}

		if (response == "dropout")
		{
			if (isDefined(level.onDropOut))
				[[level.onDropOut]]();
		
			
		}

		if ( !isDefined(self.pers) )
			continue;

		if(response == "spectator" || response == "dropout")
		{	
			logprint("\nmenus.gsc here");
			
			
			self [[level.spectator]]();
	
			if (level.splitscreen)
				self [[level.autoassign]]();
		}


		if(response == "changeclass")
		{
			self closeMenu();
			self closeInGameMenu();
		 	
			
			
				if( self.pers["team"] == "allies" )
					self openMenu(game["menu_changeclass_allies"]); 
				else
					self openMenu(game["menu_changeclass_axis"]);	
			
			
			
		}

		if (response == "controls_changed")
		{
			logprint("\nMENU RESPONSE CONTROLS_CHANGED\n");
			self closeMenu();
			self closeInGameMenu();
			if( self.pers["team"] == "allies" )
			{
				logprint("\nAND OPENING INGAME_ALLIES\n");
				self openMenu(game["menu_ingame_allies"]); 
			}
			else
			{
				logprint("\nAND OPENING INGAME_AXIS\n");
				self openMenu(game["menu_ingame_axis"]);	
			}
		}

		
		if(response == "xpTextToggle")
		{
			self.enableText = !self.enableText;
			if (self.enableText)
				self setClientDvar( "ui_xpText", "1" );
			else
				self setClientDvar( "ui_xpText", "0" );
			continue;
		}

		
		if(response == "waypointToggle")
		{
			self.enable3DWaypoints = !self.enable3DWaypoints;
			if (self.enable3DWaypoints)
				self setClientDvar( "ui_3dwaypointtext", "1" );
			else
				self setClientDvar( "ui_3dwaypointtext", "0" );

			continue;
		}

		if ( response == "endgame_menu_response" )
		{
			level notify("endgame_menu_response");
		}

		
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
			
			
			
				
				announcement( &"MP_GAME_ENDED" );
				if ( level.consoleGame )
					endparty();
				level.skipVote = true;
				level thread maps\mp\gametypes\_globallogic::forceEnd();
			
				
			continue;
		}

		if(response == "endround")
		{
			
			if (level.splitscreen)
				announcement( &"MP_GAME_ENDED" );
			else
				announcement( &"MP_HOST_ENDED_GAME" );
			level.skipVote = true;
			level thread maps\mp\gametypes\_globallogic::forceEnd();
				
			continue;
		}

		if( self maps\mp\gametypes\_class::getResponseToken( response, "settings_changed", "/" ) == "class" )
		{
			self.menuSelectedClass = self maps\mp\gametypes\_class::getResponseToken( response, "class", "/" );
		}
		else if( self maps\mp\gametypes\_class::getResponseToken( response, "settings_changed", "/" ) == "sidearm" )
		{
			self.menuSelectedSideArm = self maps\mp\gametypes\_class::getResponseToken( response, "sidearm", "/" );
		}
		
		if( response == "apply_settings" )
		{
			self closeMenu();
			self closeInGameMenu();

			
			if(level.splitscreen && !isDefined(self.selectedClass) )
			{
				numClients = getDvarInt("splitscreen_numClientsReady");
				numClients = numClients + 1;
				setDvar( "splitscreen_numClientsReady", numClients);
			}
			self.selectedClass = true;
			self [[level.class]]( "class/" + self.menuSelectedClass + "/sidearm/" + self.menuSelectedSideArm );
		}


		if(menu == "character_options")
		{
			maps\mp\gametypes\_class::onCharacterOptionsResponse(response);
			continue;
		}
	}
}
