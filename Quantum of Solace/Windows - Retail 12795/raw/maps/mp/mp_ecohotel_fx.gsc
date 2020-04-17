main()
{
	// List all the effects you will use in the level:
	//
	// level._effect[ "[name for tool]" ]			 = loadfx( "[name of effect file, without the .efx]" );
	//

	level._effect["siena_room_dust1"] 			= loadfx ( "maps/siena/siena_room_dust1" );

/#
	if ( getdvar( "clientSideEffects" ) != "1" )	
		maps\createfx\mp_ecohotel_fx::main();
#/
}
