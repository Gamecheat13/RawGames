init()
{
	// CODER_MOD: Bryce (05/08/08): Useful output for debugging replay system
	/#
	if( getdebugdvar( "replay_debug" ) == "1" )
		println("File: _ingamemenus.gsc. Function: init()\n");
	#/
	
	level.xenon = (getdvar("xenonGame") == "true"); // for lack of a better place to put it
	level.consoleGame = (getdvar("consoleGame") == "true"); // for lack of a better place to put it
	
	precacheMenu("loadout_splitscreen");
	
	level thread onPlayerConnect();
	
	// CODER_MOD: Bryce (05/08/08): Useful output for debugging replay system
	/#
	if( getdebugdvar( "replay_debug" ) == "1" )
		println("File: _ingamemenus.gsc. Function: init() - COMPLETE\n");
	#/
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
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		//iprintln("^6", response);
		
		if(menu == "loadout_splitscreen")
		{
			self closeMenu();
			self closeInGameMenu();

			self [[level.loadout]](response);
			continue;
		}
		
		if ( response == "endround" )
		{
			if ( !level.gameEnded )
			{
				level thread maps\_cooplogic::forceEnd();
			}
			else
			{
				self closeMenu();
				self closeInGameMenu();
			}			
			continue;
		}

	}
}
