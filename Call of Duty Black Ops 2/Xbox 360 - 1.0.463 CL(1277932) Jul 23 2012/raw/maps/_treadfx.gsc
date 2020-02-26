loadtreadfx( vehicle )
{
	treadfx = GetVehicleTreadFXArray( vehicle.vehicletype );
	
	for ( i = 0; i < treadfx.size; i++ )
	{
		loadfx( treadfx[i] );
	}
	
	lightfx = vehicle.lightfxnamearray;
	
	for ( i = 0; i < lightfx.size; i++ )
	{
		loadfx( lightfx[i] );
	}

	if( IsDefined( vehicle.friendlylightfxname ) && vehicle.friendlylightfxname != "" )
	{
		loadfx( vehicle.friendlylightfxname );
	}
	
	if( IsDefined( vehicle.enemylightfxname ) && vehicle.enemylightfxname != "" )
	{
		loadfx( vehicle.enemylightfxname );
	}
	
	if( vehicle.vehicletype == "boat_soct_player" )
	{
        vehicle.throttlefx = [];
        vehicle.throttlefx[0] = loadfx( "water/fx_vwater_soct_wake_accelerate_1" );
        vehicle.throttlefx[1] = loadfx( "water/fx_vwater_soct_wake_accelerate_2" );
        vehicle.throttlefx[2] = loadfx( "water/fx_vwater_soct_wake_accelerate_3" );
        
        //vehicle.splashfx = loadfx( "vehicle/water/fx_wake_pbr_jump_splash" ); // Don’t use!
        //vehicle.splashfxright = loadfx( "vehicle/water/fx_wake_pbr_jump_splash" );
        //vehicle.splashfxleft = loadfx( "vehicle/water/fx_wake_pbr_jump_splash" );
        
        vehicle.wakefx[0] = loadfx( "water/fx_vwater_soct_churn_0" );    // reverse
        vehicle.wakefx[1] = loadfx( "water/fx_vwater_soct_churn_0" );        // idle
        vehicle.wakefx[2] = loadfx( "water/fx_vwater_soct_churn_1" );        // forward slow
        vehicle.wakefx[3] = loadfx( "water/fx_vwater_soct_churn_2" );        // forward med
        vehicle.wakefx[4] = loadfx( "water/fx_vwater_soct_churn_3" );        // forward fast
	}
}