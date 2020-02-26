//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 8000;
	level.dofDefault["farEnd"] = 10000;
	level.dofDefault["nearBlur"] = 6;
	level.dofDefault["farBlur"] = 0;
	players = getentarray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
		players[i] maps\_art::setdefaultdepthoffield();

	//setExpFog(0, 2610.72, 0.531857, 0.529929, 0.474802, 1, 0);
	//setExpFog(0, 7500, 0.531857, 0.529929, 0.474802, 1, 0);
	setExpFog(0, 81600, 0.533333, 0.529412, 0.50576, 1, 0);
	maps\_utility::set_vision_set( "bridge", 0 );
}
