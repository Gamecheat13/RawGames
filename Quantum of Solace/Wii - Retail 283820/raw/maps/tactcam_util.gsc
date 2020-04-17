



main()
{
 
 level thread prototype_push_cam();
}

prototype_push_cam()
{
	

	while ( 1 )
	{
		if( level.player ButtonPressed( "dpad_up" ) )
		{
	
				level.cameraID = level.player customCamera_Push( "entity_abs", level.player, level.player, ( 0, 0, 1400 ), ( 0, 90, 0 ), 1.3);
		}
		wait( 0.5 );
		if( level.player ButtonPressed( "dpad_down" ) )
		{

				level.player customCamera_pop( level.cameraID, 1  );
		}
		wait 0.01;
	}
	
	
}



