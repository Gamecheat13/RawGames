// Test clientside script for mp_la

#include clientscripts\mp\_utility;

main()
{
	// ******** remove before shipping when fx are final
	//clientscripts\mp\_fx::disableAllParticleFxInLevel();
	// ******** remove before shipping when fx are final
	
	// team nationality
	clientscripts\mp\_teamset_seals::level_init();

	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\mp_la_fx::main();

	//thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_la_amb::main();
	
	RegisterClientField( "scriptmover", "police_car_lights", 1, "int", ::destructible_car_lights, false );

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	/# println("*** Client : mp_la running..."); #/
}

destructible_car_lights( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName )
{
	if ( newVal )
	{
		wait( RandomFloatRange( 0.1, 0.5 ) );
		self.fx = PlayFXOnTag( localClientNum, level._effect["fx_light_police_car"], self, "tag_origin" );
	}
	else if ( IsDefined( self.fx ) )
	{
		StopFx( localClientNum, self.fx );
	}
}