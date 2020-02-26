//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	//* Fog section * 

	SetDvar("scr_fog_exp_halfplane", "3759.28");
	SetDvar("scr_fog_exp_halfheight", "243.735");
	SetDvar("scr_fog_nearplane", "601.593");
	SetDvar("scr_fog_red", "0.806694");
	SetDvar("scr_fog_green", "0.962521");
	SetDvar("scr_fog_blue", "0.9624");
	SetDvar("scr_fog_baseheight", "-475.268");

	SetDvar("visionstore_glowTweakEnable", "0");
	SetDvar("visionstore_glowTweakRadius0", "5");
	SetDvar("visionstore_glowTweakRadius1", "");
	SetDvar("visionstore_glowTweakBloomCutoff", "0.5");
	SetDvar("visionstore_glowTweakBloomDesaturation", "0");
	SetDvar("visionstore_glowTweakBloomIntensity0", "1");
	SetDvar("visionstore_glowTweakBloomIntensity1", "");
	SetDvar("visionstore_glowTweakSkyBleedIntensity0", "");
	SetDvar("visionstore_glowTweakSkyBleedIntensity1", "");
	


	VisionSetNaked( "mp_drone", 1 );
	SetDvar( "r_lightGridEnableTweaks", 1 );
	SetDvar( "r_lightGridIntensity", 1.0 );
	SetDvar( "r_lightGridContrast", 0 );
}

