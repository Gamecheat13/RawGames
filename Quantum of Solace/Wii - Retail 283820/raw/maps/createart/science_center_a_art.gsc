
main()
{
 
	level.tweakfile = true;
 
	
 
	
	
	
	
	
 
	
 
	level.dofDefault["nearStart"] = 1;
	level.dofDefault["nearEnd"] = 4;
	level.dofDefault["farStart"] = 6040.87;
	level.dofDefault["farEnd"] = 15306.2;
	level.dofDefault["nearBlur"] = 4;
	level.dofDefault["farBlur"] = 10;
	getent("player","classname") maps\_art::setdefaultdepthoffield();
	
	
	
}
