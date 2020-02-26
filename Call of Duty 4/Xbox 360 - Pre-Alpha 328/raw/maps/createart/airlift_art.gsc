//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "3724.21");
	setdvar("scr_fog_nearplane", "0");
	setdvar("scr_fog_red", "0.678352");
	setdvar("scr_fog_green", "0.498765");
	setdvar("scr_fog_blue", "0.372533");
	setdvar("scr_fog_disable", "0");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 7807;
	level.dofDefault["farEnd"] = 10404;
	level.dofDefault["nearBlur"] = 6;
	level.dofDefault["farBlur"] = 0.25;
	getent("player","classname") maps\_art::setdefaultdepthoffield();

	//

	setExpFog(0, 3724.21, 0.678352, 0.498765, 0.372533, 0);
	maps\_utility::set_vision_set( "airlift", 0 );

}
