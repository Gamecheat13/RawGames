init()
{
	level.xenon = (getdvar("xenonGame") == "true"); // for lack of a better place to put it
	level.consoleGame = (getdvar("consoleGame") == "true"); // for lack of a better place to put it
	
	precacheMenu("loadout_splitscreen");
	
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
		}
	}
}
