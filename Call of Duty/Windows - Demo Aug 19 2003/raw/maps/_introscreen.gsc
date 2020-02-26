main()
{
	//EXAMPLE
	//introscreen("Place, Country", "Date", "24hourclocktime");
	//EXAMPLE

	if(level.script == "training")
	{
		introscreen(&"INTROSCREEN_TRAINING_PLACE", &"INTROSCREEN_TRAINING_DATE", &"INTROSCREEN_TRAINING_TIME");
		return;
	}

	if(level.script == "pathfinder")
	{
		introscreen(&"INTROSCREEN_PATHFINDER_PLACE", &"INTROSCREEN_PATHFINDER_DATE", &"INTROSCREEN_PATHFINDER_TIME");
		return;
	}

	if((level.script == "burnville") || (level.script == "burnville_nolight"))
	{
		introscreen(&"INTROSCREEN_BURNVILLE_PLACE", &"INTROSCREEN_BURNVILLE_DATE", &"INTROSCREEN_BURNVILLE_TIME");
		return;
	}

	if((level.script == "dawnville") || (level.script == "dawnville_nolight"))
	{
		introscreen(&"INTROSCREEN_DAWNVILLE_PLACE", &"INTROSCREEN_DAWNVILLE_DATE", &"INTROSCREEN_DAWNVILLE_TIME");
		return;
	}

	if(level.script == "carride")
	{
		introscreen(&"INTROSCREEN_CARRIDE_PLACE", &"INTROSCREEN_CARRIDE_DATE", &"INTROSCREEN_CARRIDE_TIME");
		return;
	}

	if(level.script == "brecourt")
	{
		introscreen(&"INTROSCREEN_BRECOURT_PLACE", &"INTROSCREEN_BRECOURT_DATE", &"INTROSCREEN_BRECOURT_TIME");
		return;
	}

	if(level.script == "chateau")
	{
		introscreen(&"INTROSCREEN_CHATEAU_PLACE", &"INTROSCREEN_CHATEAU_DATE", &"INTROSCREEN_CHATEAU_TIME");
		return;
	}

	if(level.script == "powcamp")
	{
		introscreen(&"INTROSCREEN_POWCAMP_PLACE", &"INTROSCREEN_POWCAMP_DATE", &"INTROSCREEN_POWCAMP_TIME");
		return;
	}

	if(level.script == "pegasusnight")
	{
		introscreen(&"INTROSCREEN_PEGASUSNIGHT_PLACE", &"INTROSCREEN_PEGASUSNIGHT_DATE", &"INTROSCREEN_PEGASUSNIGHT_TIME");
		return;
	}

	if(level.script == "pegasusday")
	{
		introscreen(&"INTROSCREEN_PEGASUSDAY_PLACE", &"INTROSCREEN_PEGASUSDAY_DATE", &"INTROSCREEN_PEGASUSDAY_TIME");
		return;
	}

	if(level.script == "dam")
	{
		introscreen(&"INTROSCREEN_DAM_PLACE", &"INTROSCREEN_DAM_DATE", &"INTROSCREEN_DAM_TIME");
		return;
	}

	if(level.script == "ship")
	{
		introscreen(&"INTROSCREEN_SHIP_PLACE", &"INTROSCREEN_SHIP_DATE", &"INTROSCREEN_SHIP_TIME");
		return;
	}

	if((level.script == "stalingrad") || (level.script == "stalingrad_nolight"))
	{
		introscreen(&"INTROSCREEN_STALINGRAD_PLACE", &"INTROSCREEN_STALINGRAD_DATE", &"INTROSCREEN_STALINGRAD_TIME");
		return;
	}
	
	if(level.script == "redsquare")
	{
		introscreen(&"INTROSCREEN_REDSQUARE_PLACE", &"INTROSCREEN_REDSQUARE_DATE", &"INTROSCREEN_REDSQUARE_TIME");
		return;
	}

	if(level.script == "sewer")
	{
		introscreen(&"INTROSCREEN_SEWER_PLACE", &"INTROSCREEN_SEWER_DATE", &"INTROSCREEN_SEWER_TIME");
		return;
	}

	if(level.script == "factory")
	{
		introscreen(&"INTROSCREEN_FACTORY_PLACE", &"INTROSCREEN_FACTORY_DATE", &"INTROSCREEN_FACTORY_TIME");
		return;
	}

	if(level.script == "tankdrivecountry")
	{
		introscreen(&"INTROSCREEN_TANKDRIVECOUNTRY_PLACE", &"INTROSCREEN_TANKDRIVECOUNTRY_DATE", &"INTROSCREEN_TANKDRIVECOUNTRY_TIME");
		return;
	}

	if(level.script == "hurtgen")
	{
		introscreen(&"INTROSCREEN_HURTGEN_PLACE", &"INTROSCREEN_HURTGEN_DATE", &"INTROSCREEN_HURTGEN_TIME");
		return;
	}

	if(level.script == "rocket")
	{
		introscreen(&"INTROSCREEN_ROCKET_PLACE", &"INTROSCREEN_ROCKET_DATE", &"INTROSCREEN_ROCKET_TIME");
		return;
	}

	if(level.script == "berlin")
	{
		introscreen(&"INTROSCREEN_BERLIN_PLACE", &"INTROSCREEN_BERLIN_DATE", &"INTROSCREEN_BERLIN_TIME");
		return;
	}

	level notify ("finished intro screen"); // Do final notify when player controls have been restored
}

introscreen(string1, string2, string3)
{
	hdSetPosition(0, 0, 0);
	hdSetString(0, hdGetShaderString("black", 640, 480));

	level.player freezeControls(true);

	wait 0.1;

	hdSetPosition(1, 0, 20);
	hdSetAlignment(1, "center", "center");
	hdSetFontScale(1, 1.75);
	hdSetAlpha(1, 0);
	hdSetString(1, string1);

	hdSetPosition(2, 0, 50);
	hdSetAlignment(2, "center", "center");
	hdSetFontScale(2, 1.75);
	hdSetAlpha(2, 0);
	hdSetString(2, string2);

	hdSetPosition(3, 0, 80);
	hdSetAlignment(3, "center", "center");
	hdSetFontScale(3, 1.75);
	hdSetAlpha(3, 0);
	hdSetString(3, string3);

	// Fade text in
	wait 0.01; // let the alpha of 0 get set first
	hdSetAlpha(1, 1.0, 1.2);
	hdSetAlpha(2, 1.0, 1.2);
	hdSetAlpha(3, 1.0, 1.2);
	wait 1.2;
	if (level.script == "stalingrad")
		wait (2.0);

	level notify ("finished final intro screen fadein");

	wait 1;

	hdSetAlpha(0, 0, 1.5);

	level notify ("starting final intro screen fadeout");

	// Restore player controls part way through the fade in

	wait 0.5;
	level.player freezeControls(false);
	level notify ("finished intro screen"); // Do final notify when player controls have been restored



	// Fade out text and screen
	hdSetAlpha(1, 0, 2.5);
	hdSetAlpha(2, 0, 2.5);
	hdSetAlpha(3, 0, 2.5);
}
