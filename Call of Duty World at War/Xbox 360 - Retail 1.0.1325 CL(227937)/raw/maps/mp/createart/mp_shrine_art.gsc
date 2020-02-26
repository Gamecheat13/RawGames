//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	//* Fog section * 

	setdvar("scr_fog_exp_halfplane", "900");
	setdvar("scr_fog_exp_halfheight", "400");
	setdvar("scr_fog_nearplane", "500");
	setdvar("scr_fog_red", "0.5");
	setdvar("scr_fog_green", "0.5");
	setdvar("scr_fog_blue", "0.5");
	setdvar("scr_fog_baseheight", "0");

	setdvar("visionstore_glowTweakEnable", "0");
	setdvar("visionstore_glowTweakRadius0", "5");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "1");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");

	setVolFog(0, 4400, 1400, 0, 0.552, 0.682, 0.71, 0);

}

// setVolFog(<startDist>, <halfwayDist>, <halfwayHeight>, <baseHeight>, <red>, <green>, <blue>, <transition time>)

