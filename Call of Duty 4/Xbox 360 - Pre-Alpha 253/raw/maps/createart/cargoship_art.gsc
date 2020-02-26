//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

/*	setdvar("scr_fog_exp_halfplane", "32769");
	setdvar("scr_fog_nearplane", "0");
	setdvar("scr_fog_red", "0.5");
	setdvar("scr_fog_green", "0.5");
	setdvar("scr_fog_blue", "0.5");
*/
	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 1000;
	level.dofDefault["farEnd"] = 7000;
	level.dofDefault["nearBlur"] = 5;
	level.dofDefault["farBlur"] = 1.5;
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
	setdvar("visionstore_filmTweakContrast", "1.31838");
	setdvar("visionstore_filmTweakBrightness", "0.0625");
	setdvar("visionstore_filmTweakDesaturation", "0.48125");
	setdvar("visionstore_filmTweakInvert", "0");
	setdvar("visionstore_filmTweakLightTint", "1.0375 1.05 1.17813");
	setdvar("visionstore_filmTweakDarkTint", "0.7 0.85 1");

	//

	//setExpFog(0, 32769, 0.5, 0.5, 0.5, 0);
	VisionSetNaked( "cargoship", 0 );

}
