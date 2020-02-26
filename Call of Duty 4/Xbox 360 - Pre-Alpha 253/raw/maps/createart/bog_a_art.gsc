//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "4556.45");
	setdvar("scr_fog_nearplane", "477.057");
	setdvar("scr_fog_red", "0.544852");
	setdvar("scr_fog_green", "0.394025");
	setdvar("scr_fog_blue", "0.221177");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 6354;
	level.dofDefault["farEnd"] = 10000;
	level.dofDefault["nearBlur"] = 5;
	level.dofDefault["farBlur"] = 0.261956;
	getent("player","classname") maps\_art::setdefaultdepthoffield();

	//

	setExpFog(477.057, 4556.45, 0.544852, 0.394025, 0.221177, 0);
	VisionSetNaked( "bog_a", 0 );

}
