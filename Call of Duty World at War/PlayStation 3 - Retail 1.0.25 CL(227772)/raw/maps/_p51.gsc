// Cleaned up by: SRS (03/29/07)
//
// TODO: if the artists add bomb/turret tags,
//  we can set up the script to include that functionality. (SRS 03/29/07)

main( model, type )
{

	// Makes p51 the default vehicle type
	if( !IsDefined( type ) )
	{
		type = "p51";
	}

	// Init anything to be used globally
	level.vehicleInitThread[type][model] = ::init_local;

	// Death FX for this vehicle
	deathfx = LoadFx( "explosions/large_vehicle_explosion" );

	// Models to set up precaching
	switch( model )
	{
		case "vehicle_p51_mustang":
			PrecacheModel( "vehicle_p51_mustang" );
			// if we had a bomb model we'd have to precache that here also.  (SRS 03/29/07)
			//
			// if we had a deathmodel we'd have to precache that here as well;
			//  for now just use the regular model as the deathmodel.  (SRS 03/29/07)
			level.vehicle_deathmodel[model] = "vehicle_p51_mustang";
			break;
	}
	PrecacheVehicle( type );

	// death fx stuff
	level.vehicle_death_fx[type] = [];

	// give the vehicle life
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;

	// TODO add quake/rumble for when the plane flies by the player. (SRS 03/29/07)

	//set default team for this vehicletype
	level.vehicle_team[type] = "allies";

	//enables turret
	level.vehicle_hasMainTurret[model] = false;

	//enables vehicle on the compass
	level.vehicle_compassicon[type] = false;
}

// Anything specific to this vehicle, used globally.
init_local()
{
}
