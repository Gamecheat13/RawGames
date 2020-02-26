//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "500");
	setdvar("scr_fog_nearplane", "0");
	setdvar("scr_fog_red", "0.5");
	setdvar("scr_fog_green", "0.5");
	setdvar("scr_fog_blue", "0.5");
	setdvar("scr_fog_disable", "1");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 1000;
	level.dofDefault["farEnd"] = 7000;
	level.dofDefault["nearBlur"] = 5;
	level.dofDefault["farBlur"] = 1.5;
	getent("player","classname") maps\_art::setdefaultdepthoffield();

	//

	VisionSetNaked( "cargoship", 0 );

}
