init()
{
	game["menu_team"] = "team_marinesopfor";
	game["menu_class_allies"] = "class_marines";
	game["menu_changeclass_allies"] = "changeclass";
	game["menu_initteam_allies"] = "initteam_marines";
	game["menu_class_axis"] = "class_opfor";
	game["menu_changeclass_axis"] = "changeclass";
	game["menu_initteam_axis"] = "initteam_opfor";
	game["menu_class"] = "class";
	game["menu_changeclass"] = "changeclass";
	game["menu_changeclass_offline"] = "changeclass";
	game["menu_wager_side_bet"] = "sidebet";
	game["menu_wager_side_bet_player"] = "sidebet_player";
	game["menu_changeclass_wager"] = "changeclass_wager";
	game["menu_changeclass_custom"] = "changeclass_custom";
	game["menu_changeclass_barebones"] = "changeclass_barebones";

	if ( !level.console )
	{
		game["menu_callvote"] = "callvote";
		game["menu_muteplayer"] = "muteplayer";
		precacheMenu(game["menu_callvote"]);
		precacheMenu(game["menu_muteplayer"]);
		
		// ---- back up one folder to access game_summary.menu ----
		// game summary menu file precache
		game["menu_eog_main"] = "endofgame";
		game["menu_eog_unlock"] = "menu_aar_unlocks_weapons";
		game["menu_eog_summary"] = "menu_aar_summary";
		
		precacheMenu(game["menu_eog_main"]);
		precacheMenu(game["menu_eog_unlock"]);
		precacheMenu(game["menu_eog_summary"]);	
	}
	else
	{
		game["menu_controls"] = "ingame_controls";
		game["menu_options"] = "ingame_options";
		game["menu_leavegame"] = "popup_leavegame";

		precacheMenu(game["menu_controls"]);
		precacheMenu(game["menu_options"]);
		precacheMenu(game["menu_leavegame"]);
	}

	precacheMenu("scoreboard");
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_class_allies"]);
	precacheMenu(game["menu_changeclass_allies"]);
	precacheMenu(game["menu_initteam_allies"]);
	precacheMenu(game["menu_class_axis"]);
	precacheMenu(game["menu_changeclass_axis"]);
	precacheMenu(game["menu_class"]);
	precacheMenu(game["menu_changeclass"]);
	precacheMenu(game["menu_initteam_axis"]);
	precacheMenu(game["menu_changeclass_offline"]);
	precacheMenu(game["menu_changeclass_wager"]);
	precacheMenu(game["menu_changeclass_custom"]);
	precacheMenu(game["menu_changeclass_barebones"]);
	precacheMenu(game["menu_wager_side_bet"]);
	precacheMenu(game["menu_wager_side_bet_player"]);
	precacheString( &"MP_HOST_ENDED_GAME" );
	precacheString( &"MP_HOST_ENDGAME_RESPONSE" );

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);		
		player thread onMenuResponse();
	}
}

onMenuResponse()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		//println( self getEntityNumber() + " menuresponse: " + menu + " " + response );
		
		//iprintln("^6", response);
			
		if ( response == "back" )
		{
			self closeMenu();
			self closeInGameMenu();

			if ( level.console )
			{
				if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_team"] || menu == game["menu_controls"] )
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
		
		if(response == "changeteam" && level.allow_teamchange == "1")
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu(game["menu_team"]);
		}
	
		if(response == "changeclass_marines" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_allies"] );
			continue;
		}

		if(response == "changeclass_opfor" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_axis"] );
			continue;
		}

		if(response == "changeclass_wager" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_wager"] );
			continue;
		}

		if(response == "changeclass_custom" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_custom"] );
			continue;
		}

		if(response == "changeclass_barebones" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_barebones"] );
			continue;
		}

		if(response == "changeclass_marines_splitscreen" )
			self openMenu( "changeclass_marines_splitscreen" );

		if(response == "changeclass_opfor_splitscreen" )
			self openMenu( "changeclass_opfor_splitscreen" );
							
		if(response == "endgame")
		{
			// TODO: replace with onSomethingEvent call 
			if(level.splitscreen)
			{
				//if ( level.console )
				//	endparty();
				level.skipVote = true;

				if ( !level.gameEnded )
				{
					level thread maps\mp\gametypes\_globallogic::forceEnd();
				}
			}
				
			continue;
		}
		
		if(response == "killserverpc")
		{
				level thread maps\mp\gametypes\_globallogic::killserverPc();
				
			continue;
		}

		if ( response == "endround" )
		{
			if ( !level.gameEnded )
			{
				level thread maps\mp\gametypes\_globallogic::forceEnd();
			}
			else
			{
				self closeMenu();
				self closeInGameMenu();
				self iprintln( &"MP_HOST_ENDGAME_RESPONSE" );
			}			
			continue;
		}

		if(menu == game["menu_team"] && level.allow_teamchange == "1")
		{
			switch(response)
			{
			case "allies":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.allies]]();
				break;

			case "axis":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.axis]]();
				break;

			case "autoassign":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.autoassign]]();
				break;

			case "spectator":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.spectator]]();
				break;
			}
		}	// the only responses remain are change class events
		else if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_changeclass_wager"] || menu == game["menu_changeclass_custom"] || menu == game["menu_changeclass_barebones"] )
		{
			self closeMenu();
			self closeInGameMenu();
			
			if(  level.rankedMatch && isSubstr(response, "custom") )
			{
				if ( self IsItemLocked( maps\mp\gametypes\_rank::GetItemIndex( "feature_cac" ) ) )
				kick( self getEntityNumber() );
			}

			self.selectedClass = true;
			self [[level.class]](response);
		}
	}
}

/*
// sort response message from CAC menu
cacMenuStatOffset( menu, response )
{
	stat_offset = -1;
	
	if( menu == "menu_cac_assault" )
		stat_offset = 0;
	else if( menu == "menu_cac_specops" )
		stat_offset = 10;
	else if( menu == "menu_cac_heavygunner" )
		stat_offset = 20;
	else if( menu == "menu_cac_demolitions" )
		stat_offset = 30;
	else if( menu == "menu_cac_sniper" )
		stat_offset = 40;
	
	assert( stat_offset >= 0, "The response: " + response + " came from non-CAC menu" );	
	
	return stat_offset;
}
*/
