//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "500");
	setdvar("scr_fog_exp_halfheight", "500");
	setdvar("scr_fog_nearplane", "0");
	setdvar("scr_fog_red", "1");
	setdvar("scr_fog_green", "1");
	setdvar("scr_fog_blue", "1");
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


	setVolFog(759.379, 4196, 276, 358.969, 0.49, 0.56, 0.6, 0.0);
	VisionSetNaked( "mp_downfall", 0 );

}

