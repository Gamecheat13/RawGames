//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "5049.45");
	setdvar("scr_fog_nearplane", "0");
	setdvar("scr_fog_red", "0.479631");
	setdvar("scr_fog_green", "0.508939");
	setdvar("scr_fog_blue", "0.570905");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 8000;
	level.dofDefault["farEnd"] = 10000;
	level.dofDefault["nearBlur"] = 5;
	level.dofDefault["farBlur"] = 0;
	getent("player","classname") maps\_art::setdefaultdepthoffield();
	setdvar("visionstore_glowTweakEnable", "0");
	setdvar("visionstore_glowTweakRadius0", "5");
	setdvar("visionstore_glowTweakRadius1", "12");
	setdvar("visionstore_glowTweakBloomCutoff", "0.9");
	setdvar("visionstore_glowTweakBloomDesaturation", "0.75");
	setdvar("visionstore_glowTweakBloomIntensity0", "1");
	setdvar("visionstore_glowTweakBloomIntensity1", "1");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "0.5");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "0");
	setdvar("visionstore_filmTweakEnable", "1");
	setdvar("visionstore_filmTweakContrast", "1");
	setdvar("visionstore_filmTweakBrightness", "0");
	setdvar("visionstore_filmTweakDesaturation", "0");
	setdvar("visionstore_filmTweakInvert", "0");
	setdvar("visionstore_filmTweakLightTint", "1.11534 1.1125 1.00625");
	setdvar("visionstore_filmTweakDarkTint", "1.09378 1.09552 1.20298");

	//

	setExpFog(0, 5049.45, 0.479631, 0.508939, 0.570905, 0);
	VisionSetNaked( "scoutsniper", 0 );

}
