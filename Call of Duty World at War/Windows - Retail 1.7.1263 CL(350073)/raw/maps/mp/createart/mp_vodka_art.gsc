//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "1500");
	setdvar("scr_fog_exp_halfheight", "276");
	setdvar("scr_fog_nearplane", "450");
	setdvar("scr_fog_red", "0.49");
	setdvar("scr_fog_green", "0.56");
	setdvar("scr_fog_blue", "0.6");
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

	setVolFog(450, 2500, 302, 264, 0.432, 0.492, 0.459, 0);
	VisionSetNaked( "mp_vodka", 0 );

}

// setVolFog(<startDist>, <halfwayDist>, <halfwayHeight>, <baseHeight>, <red>, <green>, <blue>, <transition time>)
