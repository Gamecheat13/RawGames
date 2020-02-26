// _createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	//* Fog section * 

	setdvar( "scr_fog_disable", "0" );

	//* depth of field section * 

	level.dofDefault[ "nearStart" ] = 0;
	level.dofDefault[ "nearEnd" ] = 24;
	level.dofDefault[ "farStart" ] = 6548;
	level.dofDefault[ "farEnd" ] = 19999;
	level.dofDefault[ "nearBlur" ] = 4.14188;
	level.dofDefault[ "farBlur" ] = 0.109702;
	getent( "player", "classname" ) maps\_art::setdefaultdepthoffield();

	// 

	setExpFog( 1002.96, 211520, 0.952506, 0.981772, 1, 0 );
	VisionSetNaked( "jeepride", 0 );

}
