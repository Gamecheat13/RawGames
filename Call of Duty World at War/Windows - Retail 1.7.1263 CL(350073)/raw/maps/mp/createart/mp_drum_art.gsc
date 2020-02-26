//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "857");
	setdvar("scr_fog_exp_halfheight", "691");
	setdvar("scr_fog_nearplane", "480");
	setdvar("scr_fog_red", "0.5");
	setdvar("scr_fog_green", "0.5");
	setdvar("scr_fog_blue", "0.5");
	setdvar("scr_fog_baseheight", "337");

	setdvar("visionstore_glowTweakEnable", "1");
	setdvar("visionstore_glowTweakRadius0", "2");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "0.9");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");


	setVolFog(260, 1348, 1250, 80, 0.80, 0.80, 0.76, 0);
	VisionSetNaked( "mp_drum", 0 );

}

// setVolFog(<startDist>, <halfwayDist>, <halfwayHeight>, <baseHeight>, <red>, <green>, <blue>, <transition time>)
