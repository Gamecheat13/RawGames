//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	//* Fog section * 

	setdvar("scr_fog_exp_halfplane", "1053");
	setdvar("scr_fog_exp_halfheight", "243");
	setdvar("scr_fog_nearplane", "2869");
	setdvar("scr_fog_red", "0.52");
	setdvar("scr_fog_green", "0.62");
	setdvar("scr_fog_blue", "0.52");
	setdvar("scr_fog_baseheight", "167.563");

	setdvar("visionstore_glowTweakEnable", "0");
	setdvar("visionstore_glowTweakRadius0", "5");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "1");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");

	setVolFog(2869, 1053, 243, 243, 0.52, 0.54, 0.52, 0);
	
VisionSetNaked( "mp_makin_day", 0 );

	SetCullDist( 10000 ); 
}

// setVolFog(<startDist>, <halfwayDist>, <halfwayHeight>, <baseHeight>, <red>, <green>, <blue>, <transition time>)

