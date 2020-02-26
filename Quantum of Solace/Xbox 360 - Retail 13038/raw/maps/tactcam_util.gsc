// Jluyties
// Tact cam


main()
{
 // check button pres and then fade environment as well
 level thread prototype_push_cam();
}

prototype_push_cam()
{
	// button press
//	self endon("lockpick_done");
	while ( 1 )
	{
		if( level.player ButtonPressed( "dpad_up" ) )
		{
	//			level.button_on_off ("true ")
				level.cameraID = level.player customCamera_Push( "entity_abs", level.player, level.player, ( 0, 0, 1400 ), ( 0, 90, 0 ), 1.3);
		}
		wait( 0.5 );
		if( level.player ButtonPressed( "dpad_down" ) )
		{
//				level.button_on_off ("false ")
				level.player customCamera_pop( level.cameraID, 1  );
		}
		wait 0.01;
	}
	
	
}

/*
button_pressed( button, time )
{
	if ( button == "random" )
	{
		choice = RandomInt(4);
		switch( choice )
		{
		case 0:
			button = "BUTTON_A";
			break;
		case 1:
			button = "BUTTON_B";
			break;
		case 2:
			button = "BUTTON_X";
			break;
		case 3:
			button = "BUTTON_Y";
			break;
		}
	}

	// Display button to press
	iPrintLnBold( " " );
	iPrintLnBold( button );
	iPrintLnBold( " " );

	while ( time > 0 )
	{
		// Fail if the wrong button is pressed
		if ( button != "BUTTON_A" && level.player buttonPressed( "BUTTON_A" ) )
		{
			return false;
		}
		if ( button != "BUTTON_B" && level.player buttonPressed( "BUTTON_B" ) )
		{
			return false;
		}
		if ( button != "BUTTON_X" && level.player buttonPressed( "BUTTON_X" ) )
		{
			return false;
		}
		if ( button != "BUTTON_Y" && level.player buttonPressed( "BUTTON_Y" ) )
		{
			return false;
		}

		// Otherwise, succeed if the correct button is pressed
		if ( level.player buttonPressed( button ) )
		{
			return true;
		}
		//xxx temp PC testing hack
		if ( level.player attackbuttonpressed() )
		{
			return true;
		}

		time = time - 0.05;
		wait(0.05);
	}

	return false;  // button not pressed
}
*/

