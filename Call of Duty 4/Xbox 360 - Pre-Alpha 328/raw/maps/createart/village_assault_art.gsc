//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{
 
	level.tweakfile = true;
	 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "5500");
	setdvar("scr_fog_nearplane", "500");
	setdvar("scr_fog_red", "0.05");
	setdvar("scr_fog_green", "0.03");
	setdvar("scr_fog_blue", "0.13");

	// *depth of field section* 
	 
	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 2000;
	level.dofDefault["farEnd"] = 8000;
	level.dofDefault["nearBlur"] = 6;
	level.dofDefault["farBlur"] = 1.8;
	getent("player","classname") maps\_art::setdefaultdepthoffield();
	 
	//
	
	setExpFog(300, 1800, .05, .03, 0.13, 0);
	maps\_utility::set_vision_set( "village_assault" );
}