// This function should take care of grain and glow settings for each map, plus anything else that artists 
// need to be able to tweak without bothering level designers.
main()
{
	// Defaults
	setsavedcvar("r_glowradius0","12");
	setsavedcvar("r_glowradius1","12");
	setsavedcvar("r_glowbloomcutoff", ".95");
	setsavedcvar("r_glowbloomdesaturation", ".75");
	setsavedcvar("r_glowbloomintensity0","0.5");
	setsavedcvar("r_glowbloomintensity1","0.5");
	setsavedcvar("r_glowskybleedintensity0","0.25");
	setsavedcvar("r_glowskybleedintensity1","0");
	defaultGrainStrength = 0.045;
	level.grainstrength = defaultGrainStrength;

	// Level-specific settings
	switch (level.script)
	{

////////////
// Russian
////////////
	case "moscow":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","12");
		setsavedcvar("r_glowradius1","12");
		setsavedcvar("r_glowbloomcutoff", ".96");
		setsavedcvar("r_glowbloomdesaturation", ".655");
		setsavedcvar("r_glowbloomintensity0","0");
		setsavedcvar("r_glowbloomintensity1","1");
		setsavedcvar("r_glowskybleedintensity0","0.25");
		setsavedcvar("r_glowskybleedintensity1","0");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "demolition":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","5");
		setsavedcvar("r_glowradius1","12");
		setsavedcvar("r_glowbloomcutoff", ".75");
		setsavedcvar("r_glowbloomdesaturation", ".75");
		setsavedcvar("r_glowbloomintensity0","0");
		setsavedcvar("r_glowbloomintensity1","0");
		setsavedcvar("r_glowskybleedintensity0","0.5");
		setsavedcvar("r_glowskybleedintensity1","0");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "tankhunt":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","5");
		setsavedcvar("r_glowradius1","12");
		setsavedcvar("r_glowbloomcutoff", ".75");
		setsavedcvar("r_glowbloomdesaturation", ".75");
		setsavedcvar("r_glowbloomintensity0","0");
		setsavedcvar("r_glowbloomintensity1","0");
		setsavedcvar("r_glowskybleedintensity0","0.5");
		setsavedcvar("r_glowskybleedintensity1","0");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "trainyard":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","5");
		setsavedcvar("r_glowradius1","18");
		setsavedcvar("r_glowbloomcutoff", ".7");
		setsavedcvar("r_glowbloomdesaturation", ".75");
		setsavedcvar("r_glowbloomintensity0","0.4");
		setsavedcvar("r_glowbloomintensity1","0");
		setsavedcvar("r_glowskybleedintensity0","0.6");
		setsavedcvar("r_glowskybleedintensity1","0");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "downtown_assault":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","5");
		setsavedcvar("r_glowradius1","12");
		setsavedcvar("r_glowbloomcutoff", ".9");
		setsavedcvar("r_glowbloomdesaturation", ".75");
		setsavedcvar("r_glowbloomintensity0","0");
		setsavedcvar("r_glowbloomintensity1","0");
		setsavedcvar("r_glowskybleedintensity0","0.5");
		setsavedcvar("r_glowskybleedintensity1","0");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "cityhall":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","5");
		setsavedcvar("r_glowradius1","20");
		setsavedcvar("r_glowbloomcutoff", ".9");
		setsavedcvar("r_glowbloomdesaturation", ".75");
		setsavedcvar("r_glowbloomintensity0","0.5");
		setsavedcvar("r_glowbloomintensity1","0.5");
		setsavedcvar("r_glowskybleedintensity0","0.7");
		setsavedcvar("r_glowskybleedintensity1","0");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "downtown_sniper":
		setsavedcvar("r_glowradius0","5");
		setsavedcvar("r_glowradius1","12");
		setsavedcvar("r_glowbloomcutoff", ".9");
		setsavedcvar("r_glowbloomdesaturation", ".75");
		setsavedcvar("r_glowbloomintensity0","0.5");
		setsavedcvar("r_glowbloomintensity1","0.5");
		setsavedcvar("r_glowskybleedintensity0","0");
		setsavedcvar("r_glowskybleedintensity1","0");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

////////////
// British
////////////
	case "decoytrenches":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","0");
		setsavedcvar("r_glowradius1","0");
		setsavedcvar("r_glowbloomcutoff","0.5");
		setsavedcvar("r_glowbloomdesaturation","0.75");
		setsavedcvar("r_glowbloomintensity0","1");
		setsavedcvar("r_glowbloomintensity1","1");
		setsavedcvar("r_glowskybleedintensity0","0.2");
		setsavedcvar("r_glowskybleedintensity1","0.0");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "decoytown":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","0");
		setsavedcvar("r_glowradius1","0");
		setsavedcvar("r_glowbloomcutoff","0.458857");
		setsavedcvar("r_glowbloomdesaturation","0.71575");
		setsavedcvar("r_glowbloomintensity0","0.09");
		setsavedcvar("r_glowbloomintensity1","0.85");
		setsavedcvar("r_glowskybleedintensity0","0.066801");
		setsavedcvar("r_glowskybleedintensity1","0.00521");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "elalamein":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","17");
		setsavedcvar("r_glowradius1","15");
		setsavedcvar("r_glowbloomcutoff","0.4");
		setsavedcvar("r_glowbloomdesaturation","0.655");
		setsavedcvar("r_glowbloomintensity0","0.2");
		setsavedcvar("r_glowbloomintensity1","0.2");
		setsavedcvar("r_glowskybleedintensity0","0.1");
		setsavedcvar("r_glowskybleedintensity1","0.1");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.7;
		break;

	case "eldaba":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","10");
		setsavedcvar("r_glowradius1","10");
		setsavedcvar("r_glowbloomcutoff", ".85");
		setsavedcvar("r_glowbloomdesaturation", ".65");
		setsavedcvar("r_glowbloomintensity0","0.1");
		setsavedcvar("r_glowbloomintensity1","0.1");
		setsavedcvar("r_glowskybleedintensity0","0.363");
		setsavedcvar("r_glowskybleedintensity1",".047");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.7;
		break;

	case "libya":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","15.0352");
		setsavedcvar("r_glowradius1","14.319");
		setsavedcvar("r_glowbloomcutoff","0.96");
		setsavedcvar("r_glowbloomdesaturation","0.655");
		setsavedcvar("r_glowbloomintensity0","0.519699");
		setsavedcvar("r_glowbloomintensity1","0.31408");
		setsavedcvar("r_glowskybleedintensity0","0.013036");
		setsavedcvar("r_glowskybleedintensity1","0.O10849");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.7;
		break;

	case "88ridge":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","17.0352");
		setsavedcvar("r_glowradius1","15.319");
		setsavedcvar("r_glowbloomcutoff","0.96");
		setsavedcvar("r_glowbloomdesaturation","0.655");
		setsavedcvar("r_glowbloomintensity0","0.519699");
		setsavedcvar("r_glowbloomintensity1","0.21408");
		setsavedcvar("r_glowskybleedintensity0","0.03036");
		setsavedcvar("r_glowskybleedintensity1","0.020849");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.7;
		break;

	case "toujane":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","5");
		setsavedcvar("r_glowradius1","8");
		setsavedcvar("r_glowbloomcutoff","0.9");
		setsavedcvar("r_glowbloomdesaturation","0.75");
		setsavedcvar("r_glowbloomintensity0","0.3");
		setsavedcvar("r_glowbloomintensity1","0.3");
		setsavedcvar("r_glowskybleedintensity0","0.45");
		setsavedcvar("r_glowskybleedintensity1","0.0");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.7;
	case "toujane_ride":
		break;

	case "matmata":
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "duhoc_assault":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","5");
		setsavedcvar("r_glowradius1","12");
		setsavedcvar("r_glowbloomcutoff","0.9");
		setsavedcvar("r_glowbloomdesaturation","0.75");
		setsavedcvar("r_glowbloomintensity0","1");
		setsavedcvar("r_glowbloomintensity1","1");
		setsavedcvar("r_glowskybleedintensity0","0.3");
		setsavedcvar("r_glowskybleedintensity1","0.0");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 2.0;
		break;

	case "duhoc_defend":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","5");
		setsavedcvar("r_glowradius1","12");
		setsavedcvar("r_glowbloomcutoff","0.9");
		setsavedcvar("r_glowbloomdesaturation","0.75");
		setsavedcvar("r_glowbloomintensity0","1");
		setsavedcvar("r_glowbloomintensity1","1");
		setsavedcvar("r_glowskybleedintensity0","0.3");
		setsavedcvar("r_glowskybleedintensity1","0.0");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 2.0;
		break;

	case "silotown_assault":
		//GLOW SETTINGS
		setsavedcvar("r_glowradius0","12");
		setsavedcvar("r_glowradius1","12");
		setsavedcvar("r_glowbloomcutoff", ".95");
		setsavedcvar("r_glowbloomdesaturation", ".75");
		setsavedcvar("r_glowbloomintensity0","0.5");
		setsavedcvar("r_glowbloomintensity1","0.5");
		setsavedcvar("r_glowskybleedintensity0","0.25");
		setsavedcvar("r_glowskybleedintensity1","0.25");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.3;
		break;

	case "silotown_defense":
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.3;
		break;

	case "beltot":
		//GLOW SETTINGS
		setsavedcvar("r_glowbloomintensity0","1");
		setsavedcvar("r_glowbloomintensity1","1");
		setsavedcvar("r_glowradius0","5");
		setsavedcvar("r_glowradius1","0");
		setsavedcvar("r_glowbloomcutoff","0.9");
		setsavedcvar("r_glowbloomdesaturation","0.75");
		setsavedcvar("r_glowskybleedintensity0","0.33");
		setsavedcvar("r_glowskybleedintensity1","0");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "crossroads":
		//GLOW SETTINGS
		setsavedcvar("r_glowSkyBleedIntensity0", "0.3");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.2;
		break;

	case "newvillers":
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "breakout":
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.5;
		break;

	case "bergstein":
		//GLOW SETTINGS
		setsavedcvar ("r_glowRadius0", "1");
		setsavedcvar ("r_glowRadius1", "3");
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "hill400_assault":
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "hill400_defend":
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.0;
		break;

	case "rhine":
		//GRAIN
		level.grainstrength = defaultGrainStrength * 1.5;
		break;
	}

	// Grain has been cut
//	if (getcvar("r_grainfilter") == "")
//		setcvar("r_grainfilter", "1");
//	thread grain_filter();
}

grain_filter()
{
// Grain has been cut.
/*
	//*****Full screen grain filter*****
	overlay = undefined;
	precacheShader("overlay_grain");
	for(;;)
	{
		if (getcvarfloat("r_grainfilter") > 0)
		{
			if (!isdefined(overlay))
			{
				overlay = newHudElem();
				overlay.x = 0;
				overlay.y = 0;
				overlay setshader ("overlay_grain", 640, 480);
				overlay.alignX = "left";
				overlay.alignY = "top";
				overlay.horzAlign = "fullscreen";
				overlay.vertAlign = "fullscreen";
			}
		}
		else
		{
			if (isdefined(overlay))
				overlay destroy();
		}
		if (isdefined(overlay))
			overlay.alpha = level.grainstrength * getcvarfloat("r_grainfilter");
		wait 0.05;
	}
*/
}

