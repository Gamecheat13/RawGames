//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "211520");
	setdvar("scr_fog_nearplane", "1002.96");
	setdvar("scr_fog_red", "0.952506");
	setdvar("scr_fog_green", "0.981772");
	setdvar("scr_fog_blue", "1");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 24;
	level.dofDefault["farStart"] = 6548;
	level.dofDefault["farEnd"] = 19999;
	level.dofDefault["nearBlur"] = 4.14188;
	level.dofDefault["farBlur"] = 0.109702;
	getent("player","classname") maps\_art::setdefaultdepthoffield();
	setdvar("visionstore_glowTweakEnable", "1");
	setdvar("visionstore_glowTweakRadius0", "28.7915");
	setdvar("visionstore_glowTweakRadius1", "31.4337");
	setdvar("visionstore_glowTweakBloomCutoff", "0.703579");
	setdvar("visionstore_glowTweakBloomDesaturation", "3.7132e-005");
	setdvar("visionstore_glowTweakBloomIntensity0", "0.18776");
	setdvar("visionstore_glowTweakBloomIntensity1", "0.299955");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "0");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "0");
	setdvar("visionstore_filmTweakEnable", "1");
	setdvar("visionstore_filmTweakContrast", "1.0035");
	setdvar("visionstore_filmTweakBrightness", "-0.00534387");
	setdvar("visionstore_filmTweakDesaturation", "0.0299174");
	setdvar("visionstore_filmTweakInvert", "0");
	setdvar("visionstore_filmTweakLightTint", "1.09913 1.0521 1.10145");
	setdvar("visionstore_filmTweakDarkTint", "0.946567 1.04024 1.11933");

	//

	setExpFog(1002.96, 211520, 0.952506, 0.981772, 1, 0);
	VisionSetNaked( "jeepride", 0 );

}
