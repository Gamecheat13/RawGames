//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "17489.1");
	setdvar("scr_fog_nearplane", "387.882");
	setdvar("scr_fog_red", "0.518786");
	setdvar("scr_fog_green", "0.529929");
	setdvar("scr_fog_blue", "0.474802");
	setdvar("scr_fog_disable", "0");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 7807;
	level.dofDefault["farEnd"] = 10404;
	level.dofDefault["nearBlur"] = 4.99672;
	level.dofDefault["farBlur"] = 0.210613;
	getent("player","classname") maps\_art::setdefaultdepthoffield();

	//

	setExpFog(387.882, 17489.1, 0.518786, 0.529929, 0.474802, 0);
	VisionSetNaked( "airlift", 0 );

}
