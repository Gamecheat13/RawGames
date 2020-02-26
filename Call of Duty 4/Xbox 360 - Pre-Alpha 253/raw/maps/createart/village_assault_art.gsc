//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{
 
	level.tweakfile = true;
	 
	// *depth of field section* 
	 
	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 0;
	level.dofDefault["farStart"] = 2000;
	level.dofDefault["farEnd"] = 8000;
	level.dofDefault["nearBlur"] = 5;
	level.dofDefault["farBlur"] = 1.5;
	getent("player","classname") maps\_art::setdefaultdepthoffield();
	 
	//
	
	setExpFog(500, 5500, .05, .03, 0.13, 0);
	VisionSetNaked( "village_assault" );
}