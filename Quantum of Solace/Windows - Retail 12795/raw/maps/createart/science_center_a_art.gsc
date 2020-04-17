//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{
 
	level.tweakfile = true;
 
	// *Fog section* 
 
	//setdvar("scr_fog_exp_halfplane", "6145");
	//setdvar("scr_fog_nearplane", "3072");
	//setdvar("scr_fog_red", "0.742188");
	//setdvar("scr_fog_green", "0.71875");
	//setdvar("scr_fog_blue", "0.65625");
 
	// *depth of field section* 
 
	level.dofDefault["nearStart"] = 1;
	level.dofDefault["nearEnd"] = 4;
	level.dofDefault["farStart"] = 6040.87;
	level.dofDefault["farEnd"] = 15306.2;
	level.dofDefault["nearBlur"] = 4;
	level.dofDefault["farBlur"] = 10;
	getent("player","classname") maps\_art::setdefaultdepthoffield();
	
	//setExpFog( 2049, 3072, 0.742188, 0.71875, 0.65625, 1 );
	//VisionSetNaked( "science_center_outside" ); 
}
