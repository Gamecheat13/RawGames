#include maps\_utility;

init()
{
	level.xenon = (GetDvar( "xenonGame") == "true"); // for lack of a better place to put it
	level.consoleGame = (GetDvar( "consoleGame") == "true"); // for lack of a better place to put it
	
	precacheMenu("loadout_splitscreen");
	
	// cache the in game menus
	precacheMenu( "ObjectiveInfoMenu" );
	precacheMenu( "InGamePopupMenu" );

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
		
		if (response == "close_all_ingame_menus")
		{
			self closeInGameMenu();
		}
	}
}
