//_createart generated.  modify at your own risk. Changing values should be fine.
main()

{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "1242.13");
	setdvar("scr_fog_exp_halfheight", "603.62");
	setdvar("scr_fog_nearplane", "927.119");
	setdvar("scr_fog_red", "1");
	setdvar("scr_fog_green", "0");
	setdvar("scr_fog_blue", "0");
	setdvar("scr_fog_baseheight", "0.5743");


	setdvar("visionstore_glowTweakEnable", "1");
	setdvar("visionstore_glowTweakRadius0", "5");
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "1.7");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "0.49");

	setdvar("visionstore_filmInvert", "0");
	setdvar("visionstore_filmLightTint", "1.2865 1.03479 1.04204");
	setdvar("visionstore_filmDarkTint", "0.696813 0.889778 1.00089");


	setVolFog(600, 1000, 603, 28, 0.4705, 0.539379, 0.574387, 0);
	// VisionSetNaked( "mp_docks", 0 );
	

}
// setVolFog(<startDist>, <halfwayDist>, <halfwayHeight>, <baseHeight>, <red>, <green>, <blue>, <transition time>)
