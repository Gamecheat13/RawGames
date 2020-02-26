//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "2610.72");
	setdvar("scr_fog_nearplane", "0");
	setdvar("scr_fog_red", "0.531857");
	setdvar("scr_fog_green", "0.529929");
	setdvar("scr_fog_blue", "0.474802");

	setdvar("visionstore_glowTweakEnable", "0");
	setdvar("visionstore_glowTweakRadius0", "5");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "1");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");
	setdvar("visionstore_filmTweakEnable", "1");
	setdvar("visionstore_filmTweakContrast", "1.30497");
	setdvar("visionstore_filmTweakBrightness", "-0.0195861");
	setdvar("visionstore_filmTweakDesaturation", "0.476688");
	setdvar("visionstore_filmTweakInvert", "0");
	setdvar("visionstore_filmTweakLightTint", "1 1 1");
	setdvar("visionstore_filmTweakDarkTint", "1 1 1");

	setExpFog(0, 2610.72, 0.531857, 0.529929, 0.474802, 0);
	VisionSetNaked( "mp_showdown", 0 );

}
