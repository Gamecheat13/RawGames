// _createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	//* depth of field section * 

	level.dofDefault[ "nearStart" ] = 0;
	level.dofDefault[ "nearEnd" ] = 1;
	level.dofDefault[ "farStart" ] = 8000;
	level.dofDefault[ "farEnd" ] = 10000;
	level.dofDefault[ "nearBlur" ] = 6;
	level.dofDefault[ "farBlur" ] = 0;
	getent( "player", "classname" ) maps\_art::setdefaultdepthoffield();

	//* Fog section * 

	setdvar( "scr_fog_disable", "0" );

	setExpFog( 800, 22579.9, 0.583, 0.631569, 0.553078, 0 );
	maps\_utility::set_vision_set( "killhouse", 0 );

}
