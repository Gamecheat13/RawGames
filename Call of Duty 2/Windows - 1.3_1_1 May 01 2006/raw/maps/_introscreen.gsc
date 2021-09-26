main()
{
	precacheshader("black");
	
	//String1 = Title of the level
	//String2 = Place, Country or just Country
	//String3 = Month Day, Year
	//String4 = Optional additional detailed information
	//Pausetime1 = length of pause in seconds after title of level
	//Pausetime2 = length of pause in seconds after Month Day, Year
	//Pausetime3 = length of pause in seconds before the level fades in 
	
	if(level.script == "moscow")
	{
		precacheString(&"INTROSCREEN_MOSCOW_TITLE");
		precacheString(&"INTROSCREEN_MOSCOW_PLACE");
		precacheString(&"INTROSCREEN_MOSCOW_DATE");
		precacheString(&"INTROSCREEN_MOSCOW_INFO");
		if(!level.jumpto_shoot)
			introscreen_delay(&"INTROSCREEN_MOSCOW_TITLE", &"INTROSCREEN_MOSCOW_PLACE", &"INTROSCREEN_MOSCOW_DATE", &"INTROSCREEN_MOSCOW_INFO");
	}

	if(level.script == "decoytrenches")
	{
		precacheString(&"INTROSCREEN_DECOYTRENCHES_TITLE");
		precacheString(&"INTROSCREEN_DECOYTRENCHES_PLACE");
		precacheString(&"INTROSCREEN_DECOYTRENCHES_DATE");
		precacheString(&"INTROSCREEN_DECOYTRENCHES_INFO");
		introscreen_delay(&"INTROSCREEN_DECOYTRENCHES_TITLE", &"INTROSCREEN_DECOYTRENCHES_PLACE", &"INTROSCREEN_DECOYTRENCHES_DATE", &"INTROSCREEN_DECOYTRENCHES_INFO", 2.8, 3, 3);
	}

	if(level.script == "decoytown")
	{
		precacheString(&"INTROSCREEN_DECOYTOWN_TITLE");
		precacheString(&"INTROSCREEN_DECOYTOWN_PLACE");
		precacheString(&"INTROSCREEN_DECOYTOWN_DATE");
		precacheString(&"INTROSCREEN_DECOYTOWN_INFO");
		introscreen_delay(&"INTROSCREEN_DECOYTOWN_TITLE", &"INTROSCREEN_DECOYTOWN_PLACE", &"INTROSCREEN_DECOYTOWN_DATE", &"INTROSCREEN_DECOYTOWN_INFO", 1.5, 2, 2.3);
	}

	if(level.script == "elalamein")
	{
		precacheString(&"INTROSCREEN_ELALAMEIN_TITLE");
		precacheString(&"INTROSCREEN_ELALAMEIN_PLACE");
		precacheString(&"INTROSCREEN_ELALAMEIN_DATE");
		precacheString(&"INTROSCREEN_ELALAMEIN_INFO");
		introscreen_delay(&"INTROSCREEN_ELALAMEIN_TITLE", &"INTROSCREEN_ELALAMEIN_PLACE", &"INTROSCREEN_ELALAMEIN_DATE", &"INTROSCREEN_ELALAMEIN_INFO");
	}
	
	if(level.script == "eldaba")
	{
		precacheString(&"INTROSCREEN_ELDABA_TITLE");
		precacheString(&"INTROSCREEN_ELDABA_PLACE");
		precacheString(&"INTROSCREEN_ELDABA_DATE");
		precacheString(&"INTROSCREEN_ELDABA_INFO");
		introscreen_delay(&"INTROSCREEN_ELDABA_TITLE", &"INTROSCREEN_ELDABA_PLACE", &"INTROSCREEN_ELDABA_DATE", &"INTROSCREEN_ELDABA_INFO", undefined, 3.5, 4);
	}
	
	if(level.script == "demolition")
	{
		precacheString(&"INTROSCREEN_DEMOLITION_TITLE");
		precacheString(&"INTROSCREEN_DEMOLITION_PLACE");
		precacheString(&"INTROSCREEN_DEMOLITION_DATE");
		precacheString(&"INTROSCREEN_DEMOLITION_INFO");
		introscreen_delay(&"INTROSCREEN_DEMOLITION_TITLE", &"INTROSCREEN_DEMOLITION_PLACE", &"INTROSCREEN_DEMOLITION_DATE", &"INTROSCREEN_DEMOLITION_INFO");
	}
	
	if(level.script == "tankhunt")
	{
		precacheString(&"INTROSCREEN_TANKHUNT_TITLE");
		precacheString(&"INTROSCREEN_TANKHUNT_PLACE");
		precacheString(&"INTROSCREEN_TANKHUNT_DATE");
		precacheString(&"INTROSCREEN_TANKHUNT_INFO");
		introscreen_delay(&"INTROSCREEN_TANKHUNT_TITLE", &"INTROSCREEN_TANKHUNT_PLACE", &"INTROSCREEN_TANKHUNT_DATE", &"INTROSCREEN_TANKHUNT_INFO");
	}
	
	if(level.script == "trainyard")
	{
		precacheString(&"INTROSCREEN_TRAINYARD_TITLE");
		precacheString(&"INTROSCREEN_TRAINYARD_PLACE");
		precacheString(&"INTROSCREEN_TRAINYARD_DATE");
		precacheString(&"INTROSCREEN_TRAINYARD_INFO");
		introscreen_delay(&"INTROSCREEN_TRAINYARD_TITLE", &"INTROSCREEN_TRAINYARD_PLACE", &"INTROSCREEN_TRAINYARD_DATE", &"INTROSCREEN_TRAINYARD_INFO");
	}
	
	if(level.script == "downtown_assault")
	{
		precacheString(&"INTROSCREEN_DOWNTOWN_ASSAULT_TITLE");
		precacheString(&"INTROSCREEN_DOWNTOWN_ASSAULT_PLACE");
		precacheString(&"INTROSCREEN_DOWNTOWN_ASSAULT_DATE");
		precacheString(&"INTROSCREEN_DOWNTOWN_ASSAULT_INFO");
		//precacheString("Two blocks north of Gogol St.");
		introscreen_delay(&"INTROSCREEN_DOWNTOWN_ASSAULT_TITLE", &"INTROSCREEN_DOWNTOWN_ASSAULT_PLACE", &"INTROSCREEN_DOWNTOWN_ASSAULT_DATE", &"INTROSCREEN_DOWNTOWN_ASSAULT_INFO", undefined, 3);
	}
	
	if(level.script == "cityhall")
	{
		precacheString(&"INTROSCREEN_CITYHALL_TITLE");
		precacheString(&"INTROSCREEN_CITYHALL_PLACE");
		precacheString(&"INTROSCREEN_CITYHALL_DATE");
		precacheString(&"INTROSCREEN_CITYHALL_INFO");
		introscreen_delay(&"INTROSCREEN_CITYHALL_TITLE", &"INTROSCREEN_CITYHALL_PLACE", &"INTROSCREEN_CITYHALL_DATE", &"INTROSCREEN_CITYHALL_INFO");
	}
	
	if(level.script == "downtown_sniper")
	{
		precacheString(&"INTROSCREEN_DOWNTOWN_SNIPER_TITLE");
		precacheString(&"INTROSCREEN_DOWNTOWN_SNIPER_PLACE");
		precacheString(&"INTROSCREEN_DOWNTOWN_SNIPER_DATE");
		precacheString(&"INTROSCREEN_DOWNTOWN_SNIPER_INFO");
		introscreen_delay(&"INTROSCREEN_DOWNTOWN_SNIPER_TITLE", &"INTROSCREEN_DOWNTOWN_SNIPER_PLACE", &"INTROSCREEN_DOWNTOWN_SNIPER_DATE", &"INTROSCREEN_DOWNTOWN_SNIPER_INFO");
	}
	
	if(level.script == "toujane_ride")
	{
		precacheString(&"INTROSCREEN_TOUJANE_RIDE_TITLE");
		precacheString(&"INTROSCREEN_TOUJANE_RIDE_PLACE");
		precacheString(&"INTROSCREEN_TOUJANE_RIDE_DATE");
		precacheString(&"INTROSCREEN_TOUJANE_RIDE_INFO");
		introscreen_delay(&"INTROSCREEN_TOUJANE_RIDE_TITLE", &"INTROSCREEN_TOUJANE_RIDE_PLACE", &"INTROSCREEN_TOUJANE_RIDE_DATE", &"INTROSCREEN_TOUJANE_RIDE_INFO");
	}
	
	if(level.script == "toujane")
	{
		precacheString(&"INTROSCREEN_TOUJANE_TITLE");
		precacheString(&"INTROSCREEN_TOUJANE_PLACE");
		precacheString(&"INTROSCREEN_TOUJANE_DATE");
		precacheString(&"INTROSCREEN_TOUJANE_INFO");
		introscreen_delay(&"INTROSCREEN_TOUJANE_TITLE", &"INTROSCREEN_TOUJANE_PLACE", &"INTROSCREEN_TOUJANE_DATE", &"INTROSCREEN_TOUJANE_INFO", 2.5, undefined, 3.5);
	}
	
	if(level.script == "matmata")
	{
		precacheString(&"INTROSCREEN_MATMATA_TITLE");
		precacheString(&"INTROSCREEN_MATMATA_PLACE");
		precacheString(&"INTROSCREEN_MATMATA_DATE");
		//precacheString( "1200 hrs" );
		introscreen_delay(&"INTROSCREEN_MATMATA_TITLE", &"INTROSCREEN_MATMATA_PLACE", &"INTROSCREEN_MATMATA_DATE", undefined, 2.7, undefined, 3);

	}
	
	if(level.script == "libya")
	{
		precacheString(&"INTROSCREEN_LIBYA_TITLE");
		precacheString(&"INTROSCREEN_LIBYA_PLACE");
		precacheString(&"INTROSCREEN_LIBYA_DATE");
		precacheString(&"INTROSCREEN_LIBYA_INFO");
		introscreen_delay(&"INTROSCREEN_LIBYA_TITLE", &"INTROSCREEN_LIBYA_PLACE", &"INTROSCREEN_LIBYA_DATE", &"INTROSCREEN_LIBYA_INFO");
	}
	
	if(level.script == "88ridge")
	{
		precacheString(&"INTROSCREEN_88RIDGE_TITLE");
		precacheString(&"INTROSCREEN_88RIDGE_PLACE");
		precacheString(&"INTROSCREEN_88RIDGE_DATE");
		precacheString(&"INTROSCREEN_88RIDGE_INFO");
		introscreen_delay(&"INTROSCREEN_88RIDGE_TITLE", &"INTROSCREEN_88RIDGE_PLACE", &"INTROSCREEN_88RIDGE_DATE", &"INTROSCREEN_88RIDGE_INFO");
	}
	
	if(level.script == "duhoc_assault")
	{
		precacheString(&"INTROSCREEN_DUHOC_ASSAULT_TITLE");
		precacheString(&"INTROSCREEN_DUHOC_ASSAULT_PLACE");
		precacheString(&"INTROSCREEN_DUHOC_ASSAULT_DATE");
		precacheString(&"INTROSCREEN_DUHOC_ASSAULT_INFO");
		introscreen_delay(&"INTROSCREEN_DUHOC_ASSAULT_TITLE", &"INTROSCREEN_DUHOC_ASSAULT_PLACE", &"INTROSCREEN_DUHOC_ASSAULT_DATE", &"INTROSCREEN_DUHOC_ASSAULT_INFO", undefined, undefined, 4);
	}
	
	if(level.script == "duhoc_defend")
	{
		precacheString(&"INTROSCREEN_DUHOC_DEFEND_TITLE");
		precacheString(&"INTROSCREEN_DUHOC_DEFEND_PLACE");
		precacheString(&"INTROSCREEN_DUHOC_DEFEND_DATE");
//		precacheString(&"INTROSCREEN_DUHOC_DEFEND_INFO");
		introscreen_delay(&"INTROSCREEN_DUHOC_DEFEND_TITLE", &"INTROSCREEN_DUHOC_DEFEND_PLACE", &"INTROSCREEN_DUHOC_DEFEND_DATE");
	}
	
	if(level.script == "silotown_assault")
	{
		precacheString(&"INTROSCREEN_SILOTOWN_ASSAULT_TITLE");
		precacheString(&"INTROSCREEN_SILOTOWN_ASSAULT_PLACE");
		precacheString(&"INTROSCREEN_SILOTOWN_ASSAULT_DATE");
//		precacheString(&"INTROSCREEN_SILOTOWN_ASSAULT_INFO");
		introscreen_delay(&"INTROSCREEN_SILOTOWN_ASSAULT_TITLE", &"INTROSCREEN_SILOTOWN_ASSAULT_PLACE", &"INTROSCREEN_SILOTOWN_ASSAULT_DATE");
	}
	
	if(level.script == "beltot")
	{
		precacheString(&"INTROSCREEN_BELTOT_TITLE");
		precacheString(&"INTROSCREEN_BELTOT_PLACE");
		precacheString(&"INTROSCREEN_BELTOT_DATE");
		precacheString(&"INTROSCREEN_BELTOT_INFO");
		introscreen_delay(&"INTROSCREEN_BELTOT_TITLE", &"INTROSCREEN_BELTOT_PLACE", &"INTROSCREEN_BELTOT_DATE", &"INTROSCREEN_BELTOT_INFO");
	}
	
	if(level.script == "crossroads")
	{
		precacheString(&"INTROSCREEN_CROSSROADS_TITLE");
		precacheString(&"INTROSCREEN_CROSSROADS_PLACE");
		precacheString(&"INTROSCREEN_CROSSROADS_DATE");
		precacheString(&"INTROSCREEN_CROSSROADS_INFO");
		introscreen_delay(&"INTROSCREEN_CROSSROADS_TITLE", &"INTROSCREEN_CROSSROADS_PLACE", &"INTROSCREEN_CROSSROADS_DATE", &"INTROSCREEN_CROSSROADS_INFO", 1.8, undefined, 2.2);
	}
	
	if(level.script == "newvillers")
	{
		precacheString(&"INTROSCREEN_NEWVILLERS_TITLE");
		precacheString(&"INTROSCREEN_NEWVILLERS_PLACE");
		precacheString(&"INTROSCREEN_NEWVILLERS_DATE");
		precacheString(&"INTROSCREEN_NEWVILLERS_INFO");
		introscreen_delay(&"INTROSCREEN_NEWVILLERS_TITLE", &"INTROSCREEN_NEWVILLERS_PLACE", &"INTROSCREEN_NEWVILLERS_DATE", &"INTROSCREEN_NEWVILLERS_INFO");
	}
	
	if(level.script == "breakout")
	{
		precacheString(&"INTROSCREEN_BREAKOUT_TITLE");
		precacheString(&"INTROSCREEN_BREAKOUT_PLACE");
		precacheString(&"INTROSCREEN_BREAKOUT_DATE");
//		precacheString(&"INTROSCREEN_BREAKOUT_INFO");
		introscreen_delay(&"INTROSCREEN_BREAKOUT_TITLE", &"INTROSCREEN_BREAKOUT_PLACE", &"INTROSCREEN_BREAKOUT_DATE", undefined, 2.5, 3);
	}	
	
	if(level.script == "bergstein")
	{
		precacheString(&"INTROSCREEN_BERGSTEIN_TITLE");
		precacheString(&"INTROSCREEN_BERGSTEIN_PLACE");
		precacheString(&"INTROSCREEN_BERGSTEIN_DATE");
//		precacheString(&"INTROSCREEN_BERGSTEIN_INFO");
		introscreen_delay(&"INTROSCREEN_BERGSTEIN_TITLE", &"INTROSCREEN_BERGSTEIN_PLACE", &"INTROSCREEN_BERGSTEIN_DATE");
	}
	
	if(level.script == "hill400_assault")
	{
		precacheString(&"INTROSCREEN_HILL400_ASSAULT_TITLE");
		precacheString(&"INTROSCREEN_HILL400_ASSAULT_PLACE");
		precacheString(&"INTROSCREEN_HILL400_ASSAULT_DATE");
		precacheString(&"INTROSCREEN_HILL400_ASSAULT_INFO");
		introscreen_delay(&"INTROSCREEN_HILL400_ASSAULT_TITLE", &"INTROSCREEN_HILL400_ASSAULT_PLACE", &"INTROSCREEN_HILL400_ASSAULT_DATE", &"INTROSCREEN_HILL400_ASSAULT_INFO");
	}
	
	if(level.script == "hill400_defend")
	{
		precacheString(&"INTROSCREEN_HILL400_DEFEND_TITLE");
		precacheString(&"INTROSCREEN_HILL400_DEFEND_PLACE");
		precacheString(&"INTROSCREEN_HILL400_DEFEND_DATE");
		precacheString(&"INTROSCREEN_HILL400_DEFEND_INFO");
		introscreen_delay(&"INTROSCREEN_HILL400_DEFEND_TITLE", &"INTROSCREEN_HILL400_DEFEND_PLACE", &"INTROSCREEN_HILL400_DEFEND_DATE", undefined, 4, 4);
	}
	
	if(level.script == "rhine")
	{
		precacheString(&"INTROSCREEN_RHINE_TITLE");
		precacheString(&"INTROSCREEN_RHINE_PLACE");
		precacheString(&"INTROSCREEN_RHINE_DATE");
		precacheString(&"INTROSCREEN_RHINE_INFO");
		introscreen_delay(&"INTROSCREEN_RHINE_TITLE", &"INTROSCREEN_RHINE_PLACE", &"INTROSCREEN_RHINE_DATE");

	}
	else
	{
		// Shouldn't do a notify without a wait statement before it, or bad things can happen when loading a save game.
		wait 0.05; 
		level notify("finished final intro screen fadein");
		wait 0.05; 
		level notify ("starting final intro screen fadeout");
		wait 0.05; 
		level notify("controls_active"); // Notify when player controls have been restored
		wait 0.05; 
		level notify("introscreen_complete"); // Do final notify when player controls have been restored
	}
}

introscreen_create_line(string)
{
	index = level.introstring.size;
	yPos = (index * 30);
	
	if (level.xenon)
		yPos -= 60;
	
	level.introstring[index] = newHudElem();
	level.introstring[index].x = 0;
	level.introstring[index].y = yPos;
	level.introstring[index].alignX = "center";
	level.introstring[index].alignY = "middle";
	level.introstring[index].horzAlign= "center";
	level.introstring[index].vertAlign = "middle";
	level.introstring[index].sort = 1; // force to draw after the background
	level.introstring[index].foreground = true;
	level.introstring[index].fontScale = 1.75;
	level.introstring[index] setText(string);
	level.introstring[index].alpha = 0;
	level.introstring[index] fadeOverTime(1.2); 
	level.introstring[index].alpha = 1;
}

introscreen_fadeOutText()
{
	for(i = 0; i < level.introstring.size; i++)
	{
		level.introstring[i] fadeOverTime(1.5);
		level.introstring[i].alpha = 0;
	}

	wait 1.5;

	for(i = 0; i < level.introstring.size; i++)
		level.introstring[i] destroy();
}

introscreen_delay(string1, string2, string3, string4, pausetime1, pausetime2, timebeforefade)
{
	doIntro = true;
	if (getcvar("introscreen") == "0")
		doIntro = false;
	if( (getcvar("start") != "") && (getcvar("start") != "start") )
		doIntro = false;
	if( (getcvar("jumpto") != "") && (getcvar("jumpto") != "start") )
		doIntro = false;
	
	if (!doIntro)
	{
		wait 0.05; 
		level notify("finished final intro screen fadein");
		wait 0.05; 
		level notify ("starting final intro screen fadeout");
		wait 0.05; 
		level notify("controls_active"); // Notify when player controls have been restored
		wait 0.05; 
		level notify("introscreen_complete"); // Do final notify when player controls have been restored
		return;
	}
	
	level.introblack = newHudElem();
	level.introblack.x = 0;
	level.introblack.y = 0;
	level.introblack.horzAlign = "fullscreen";
	level.introblack.vertAlign = "fullscreen";
	level.introblack.foreground = true;
	level.introblack setShader("black", 640, 480);

	level.player freezeControls(true);
	wait .05;

	level.introstring = [];
	
	//Title of level
	
	if(isdefined(string1))
		introscreen_create_line(string1);
	
	if(isdefined(pausetime1))
	{
		wait pausetime1;
	}
	else
	{
		wait 2;	
	}
	
	//City, Country, Date
	
	if(isdefined(string2))
		introscreen_create_line(string2);
	if(isdefined(string3))
		introscreen_create_line(string3);
	
	//Optional Detailed Statement
	
	if(isdefined(string4))
	{
		if(isdefined(pausetime2))
		{
			wait pausetime2;
		}
		else
		{
			wait 2;
		}
	}
	
	if(isdefined(string4))
		introscreen_create_line(string4);
	
	//if(isdefined(string5))
		//introscreen_create_line(string5);
	
	level notify("finished final intro screen fadein");
	
	if(isdefined(timebeforefade))
	{
		wait timebeforefade;
	}
	else
	{
		wait 3;
	}

	// Fade out black
	level.introblack fadeOverTime(1.5); 
	level.introblack.alpha = 0;

	level notify ("starting final intro screen fadeout");

	// Restore player controls part way through the fade in
	level.player freezeControls(false);
	level notify("controls_active"); // Notify when player controls have been restored

	// Fade out text
	introscreen_fadeOutText();

	level notify("introscreen_complete"); // Notify when complete
}
