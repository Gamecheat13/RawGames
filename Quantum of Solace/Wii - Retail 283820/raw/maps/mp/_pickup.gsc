



init()
{
	
	level.pickup_spawntime    = 45; 
	level.pickup_AmmoArray    = getentarray( "ammo_pickup", "targetname" );
	
	
	level.pickup_interval     = 0.05;
	level.pickup_distance     = 50;
	
	
	
	precachestring( &"MP_PICKUP_AMMO" );
	
	
	
	for( i = 0; i < level.pickup_AmmoArray.size; i++ )
	{
		level.pickup_AmmoArray[i] show();
		level.pickup_AmmoArray[i] notsolid();
		level.pickup_AmmoArray[i].timeLeftSpawn = 0.0;
	}
	
	
	
	
	level thread startMonitoringPickup();
}


stopMonitoringPickup()
{
	level notify("stop_monitoring_pickup");
}

startMonitoringPickup()
{
	level endon("stop_monitoring_pickup");
	
	while(1)
	{
		
		
		
		wait level.pickup_interval;
		
		players = getentarray("player", "classname");
		
		for( i = 0; i < level.pickup_AmmoArray.size; i++ )
		{
			
			if( level.pickup_AmmoArray[i].timeLeftSpawn > 0 )
			{
				level.pickup_AmmoArray[i].timeLeftSpawn -= level.pickup_interval;
				continue;
			}	
			level.pickup_AmmoArray[i] show();
			
			
			for (y = 0; y < players.size; y++)
			{
				
				if (!isalive(players[y]) || players[y].sessionstate != "playing" )
					continue;
					
				
				currentWeapon = players[y] getCurrentWeapon();
				if ( currentWeapon == "none" )
					continue;
					
				
				fraction = players[y] GetFractionMaxAmmo( currentWeapon );
				if( fraction == 1.0 )
					continue;
				
				dist = distance( level.pickup_AmmoArray[i].origin, players[y].origin );
				
				if ( dist < level.pickup_distance )
				{					
					players[y] GiveRandomAmmo( currentWeapon );
					players[y] iPrintLnBold( &"MP_PICKUP_AMMO" );

					level.pickup_AmmoArray[i] hide();
					level.pickup_AmmoArray[i].timeLeftSpawn = level.pickup_spawntime;
					
					
				}
			}
		}
		
		
		
		
		
	}
}