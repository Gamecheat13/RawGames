//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "21271.1");
	setdvar("scr_fog_nearplane", "733.407");
	setdvar("scr_fog_red", "0.743173");
	setdvar("scr_fog_green", "0.761856");
	setdvar("scr_fog_blue", "0.804005");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 2000;
	level.dofDefault["farEnd"] = 8000;
	level.dofDefault["nearBlur"] = 5;
	level.dofDefault["farBlur"] = 0.665289;
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
	setdvar("visionstore_filmTweakContrast", "1.27");
	setdvar("visionstore_filmTweakBrightness", "0");
	setdvar("visionstore_filmTweakDesaturation", "0.36");
	setdvar("visionstore_filmTweakInvert", "0");
	setdvar("visionstore_filmTweakLightTint", "1 1.17 1.25");
	setdvar("visionstore_filmTweakDarkTint", "1.0958 1.15 0.988");

	//

	setExpFog(733.407, 21271.1, 0.743173, 0.761856, 0.804005, 0);
	VisionSetNaked( "village_defend", 0 );

}
