//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "3316");
	setdvar("scr_fog_exp_halfheight", "512");
	setdvar("scr_fog_nearplane", "512");
	setdvar("scr_fog_red", "0.47");
	setdvar("scr_fog_green", "0.52");
	setdvar("scr_fog_blue", "0.47");
	setdvar("scr_fog_baseheight", "0");


	setdvar("visionstore_glowTweakEnable", "1");
	setdvar("visionstore_glowTweakRadius0", "5");
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "1.7");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "0.49");
	setdvar("visionstore_glowRayExpansion", ".7");
	setdvar("visionstore_glowRayIntensity", "0.5");
	setdvar("visionstore_filmEnable", "1");
	setdvar("visionstore_filmContrast", "1.4");
	setdvar("visionstore_filmBrightness", "0.18");
	setdvar("visionstore_filmDesaturation", "0");

	setdvar("visionstore_filmInvert", "0");
	setdvar("visionstore_filmLightTint", "0.98 1.1 1.1");
	setdvar("visionstore_filmDarkTint", "0.87 1.06 1.06");


	setVolFog(512, 3316, 512, 0, .47, 0.52, 0.47, 0);
	VisionSetNaked( "mp_roundhouse", 0 );

}

