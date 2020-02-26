//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{
	level.tweakfile = true;


	SetDvar("visionstore_glowTweakEnable", "0");
	SetDvar("visionstore_glowTweakRadius0", "5");
	SetDvar("visionstore_glowTweakRadius1", "");
	SetDvar("visionstore_glowTweakBloomCutoff", "0.5");
	SetDvar("visionstore_glowTweakBloomDesaturation", "0");
	SetDvar("visionstore_glowTweakBloomIntensity0", "1");
	SetDvar("visionstore_glowTweakBloomIntensity1", "");
	SetDvar("visionstore_glowTweakSkyBleedIntensity0", "");
	SetDvar("visionstore_glowTweakSkyBleedIntensity1", "");
	


	VisionSetNaked( "mp_meltdown", 1 );
	SetDvar( "r_lightGridEnableTweaks", 1 );
	SetDvar( "r_lightGridIntensity", 1.0 );
	SetDvar( "r_lightGridContrast", 0 );
}

