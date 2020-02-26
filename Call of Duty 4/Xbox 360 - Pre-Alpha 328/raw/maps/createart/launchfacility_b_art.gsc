//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "6145");
	setdvar("scr_fog_nearplane", "512");
	setdvar("scr_fog_red", "0.546589");
	setdvar("scr_fog_green", "0.5");
	setdvar("scr_fog_blue", "0.5");
	setdvar("scr_fog_disable", "0");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 8000;
	level.dofDefault["farEnd"] = 10000;
	level.dofDefault["nearBlur"] = 6;
	level.dofDefault["farBlur"] = 0;
	getent("player","classname") maps\_art::setdefaultdepthoffield();

	//

	setExpFog(512, 6145, 0.546589, 0.5, 0.5, 0);
	maps\_utility::set_vision_set( "launchfacility_b", 0 );

}
