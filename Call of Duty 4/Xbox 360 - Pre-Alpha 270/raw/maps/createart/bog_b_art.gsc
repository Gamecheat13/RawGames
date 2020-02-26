//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "2664.25");
	setdvar("scr_fog_nearplane", "156.105");
	setdvar("scr_fog_red", "0.627076");
	setdvar("scr_fog_green", "0.611153");
	setdvar("scr_fog_blue", "0.5");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 8;
	level.dofDefault["farStart"] = 2000;
	level.dofDefault["farEnd"] = 6000;
	level.dofDefault["nearBlur"] = 5.62756;
	level.dofDefault["farBlur"] = 1.15985;
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
	setdvar("visionstore_filmTweakContrast", "1.727");
	setdvar("visionstore_filmTweakBrightness", "0.244");
	setdvar("visionstore_filmTweakDesaturation", "0.45");
	setdvar("visionstore_filmTweakInvert", "0");
	setdvar("visionstore_filmTweakLightTint", "1.0209 1.05 1.11");
	setdvar("visionstore_filmTweakDarkTint", "1.08015 1.08 1.09957");

	//

	setExpFog(156.105, 2664.25, 0.627076, 0.611153, 0.5, 0);
	VisionSetNaked( "bog_b", 0 );

}
