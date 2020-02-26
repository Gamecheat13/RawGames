//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	//* Fog section * 

	setdvar("scr_fog_exp_halfplane", "264.344");
	setdvar("scr_fog_exp_halfheight", "431.442");
	setdvar("scr_fog_nearplane", "128.162");
	setdvar("scr_fog_red", "0.791");
	setdvar("scr_fog_green", "0.514");
	setdvar("scr_fog_blue", "0.152");
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

	setVolFog(600, 870, 220, 1232, 0.55, 0.47, 0.357, 0);

}

// setVolFog(<startDist>, <halfwayDist>, <halfwayHeight>, <baseHeight>, <red>, <green>, <blue>, <transition time>)

