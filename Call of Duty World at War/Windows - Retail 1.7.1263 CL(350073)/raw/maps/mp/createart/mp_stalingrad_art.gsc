//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "2657.01");
	setdvar("scr_fog_exp_halfheight", "2033.02");
	setdvar("scr_fog_nearplane", "0");
	setdvar("scr_fog_red", "0.549788");
	setdvar("scr_fog_green", "0.51098");
	setdvar("scr_fog_blue", "0");
	setdvar("scr_fog_baseheight", "-448");
	

	setdvar("visionstore_glowTweakEnable", "1");
	setdvar("visionstore_glowTweakRadius0", "1.25");
	setdvar("visionstore_glowTweakBloomCutoff", "0.17");
	setdvar("visionstore_glowTweakBloomDesaturation", "0.27");
	setdvar("visionstore_glowTweakBloomIntensity0", "0.88");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "0.29");
	setdvar("visionstore_glowRayExpansion", ".5");
	setdvar("visionstore_glowRayIntensity", "0.25");
	setdvar("visionstore_filmEnable", "1");
	setdvar("visionstore_filmContrast", "1.2");
	setdvar("visionstore_filmBrightness", "0.16");
	setdvar("visionstore_filmDesaturation", "0");

	setdvar("visionstore_filmInvert", "0");
	setdvar("visionstore_filmLightTint", "1.37 1.6 1.2");
	setdvar("visionstore_filmDarkTint", "0.44 0.15 0.24");




	setVolFog(98, 744, 170, 40, 0.46, 0.426, 0.219, 0);
	VisionSetNaked( "mp_stalingrad", 0 );

}

// setVolFog(<startDist>, <halfwayDist>, <halfwayHeight>, <baseHeight>, <red>, <green>, <blue>, <transition time>)


	

