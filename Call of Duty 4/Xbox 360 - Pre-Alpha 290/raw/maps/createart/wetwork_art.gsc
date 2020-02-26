//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "93561.1");
	setdvar("scr_fog_nearplane", "5189.64");
	setdvar("scr_fog_red", "0.855981");
	setdvar("scr_fog_green", "0.913694");
	setdvar("scr_fog_blue", "1");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 119;
	level.dofDefault["farStart"] = 121;
	level.dofDefault["farEnd"] = 19999;
	level.dofDefault["nearBlur"] = 5.02704;
	level.dofDefault["farBlur"] = 4.92701;
	getent("player","classname") maps\_art::setdefaultdepthoffield();
	setdvar("visionstore_glowTweakEnable", "1");
	setdvar("visionstore_glowTweakRadius0", "16.9162");
	setdvar("visionstore_glowTweakRadius1", "16.0336");
	setdvar("visionstore_glowTweakBloomCutoff", "0.692596");
	setdvar("visionstore_glowTweakBloomDesaturation", "0.749915");
	setdvar("visionstore_glowTweakBloomIntensity0", "0.595652");
	setdvar("visionstore_glowTweakBloomIntensity1", "0.400947");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "0.382551");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "0.0472402");
	setdvar("visionstore_filmTweakEnable", "1");
	setdvar("visionstore_filmTweakContrast", "1.55378");
	setdvar("visionstore_filmTweakBrightness", "0.127757");
	setdvar("visionstore_filmTweakDesaturation", "0.0446647");
	setdvar("visionstore_filmTweakInvert", "0");
	setdvar("visionstore_filmTweakLightTint", "1.13486 1.05167 1.03766");
	setdvar("visionstore_filmTweakDarkTint", "0.7 0.85 1");

	//

	setExpFog(5189.64, 93561.1, 0.855981, 0.913694, 1, 0);
	VisionSetNaked( "wetwork", 0 );

}
