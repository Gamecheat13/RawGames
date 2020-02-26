#insert raw\maps\mp\_clientflags.gsh;

init( localClientNum )
{
	level._effect["missile_drone_enemy_light"] = loadfx( "weapon/missile/fx_missile_drone_light_red" );
	level._effect["missile_drone_friendly_light"] = loadfx( "weapon/missile/fx_missile_drone_light_red" );
	RegisterClientField( "toplayer", "missile_drone_active", 2, "int", ::missile_drone_active_cb, false);
	RegisterClientField( "missile", "missile_drone_projectile_active", 1, "int", ::missile_drone_projectile_active_cb, false);
}

missile_drone_projectile_active_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName )
{
	if ( newVal == 1 ) 
	{
	//	iprintlnbold( "ON" );
		self thread clientscripts\mp\_fx::blinky_light( localClientNum, "tag_target", level._effect["missile_drone_friendly_light"], level._effect["missile_drone_enemy_light"] );
	}
	else
	{
	//	iprintlnbold( "OFF" );
		self thread clientscripts\mp\_fx::stop_blinky_light( localClientNum );
	}
}

missile_drone_active_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName)
{
	if( newVal == 2 )
	{
		//iprintlnbold( "ENABLED" );
		self targetAcquired( localClientNum );
	}
	else if( newVal == 1 )
	{
		//iprintlnbold( "ON" );
		self targetScan( localClientNum );
	}
	else
	{
		//iprintlnbold( "OFF" );
		self targetLost( localClientNum );
	}
}

targetLost( localClientNum ) 
{
	self notify( "targetLost" );
	
	//iprintlnbold( "target Lost" );
	
	if ( isdefined ( self.missile_drone_fx ) ) 
	{
		stopFX( localClientNum, self.missile_drone_fx );
	}
	// stop viewModelFX
	
}
targetAcquired( localClientNum )
{
	self endon( "disconnect" );
	self endon( "targetLost" );
	self endon( "targetScanning" );
	self notify( "targetAcquired" );
	
	soundPlayed = false;
	for( ;; )
	{
		currentweapon = GetCurrentWeapon( localclientnum ); 

		if ( currentweapon != "missile_drone_mp" && currentweapon != "inventory_missile_drone_mp" )
		{
			waitrealtime( 1 );
			continue;
		}
		
		self.missile_drone_fx = PlayViewmodelFX( localClientNum, level._effect["missile_drone_enemy_light"], "tag_target" );

		if ( !soundPlayed )
		{
			playsound( localClientNum, "mpl_hk_target_id", self.origin );
		}
		soundPlayed = true;
		
		waitrealtime( .5 );
	}
}

targetScan( localClientNum )
{
	self endon( "disconnect" );
	self endon( "targetLost" );
	self endon( "targetAcquired" );
	self notify( "targetScanning" );
	
	soundPlayed = false;
	for( ;; )
	{
		currentweapon = GetCurrentWeapon( localclientnum ); 

		if ( currentweapon != "missile_drone_mp" && currentweapon != "inventory_missile_drone_mp" )
		{
			waitrealtime( 1 );
			continue;
		}

		if ( !soundPlayed )
		{
			playsound( localClientNum, "mpl_hk_scan", self.origin );
		}
		soundPlayed = true;
		
		waitrealtime( 1 );
	}
}