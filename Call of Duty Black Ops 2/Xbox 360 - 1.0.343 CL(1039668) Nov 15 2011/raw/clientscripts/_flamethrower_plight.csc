// File: _flamethrower_plight.csc
// Author: Aaron Eady
// Description: Need to show the pilot light for the flamethrower attachment only when we are using the attachment

init()
{
	level._effect["ft_pilot_light"] = LoadFX( "weapon/muzzleflashes/fx_pilot_light" );
}

play_pilot_light_fx( localClientNum )
{
	self notify( "new_pilot_light" );
	self endon( "new_pilot_light" );

	self endon( "entityshutdown" );

	if( !IsDefined(level._ft_pilot_on) || !IsDefined( level._ft_pilot_on[ localClientNum ] ) )
	{
		level._ft_pilot_on[ localClientNum ] = false;
	}

	while ( true )
	{
		new_weapon = GetCurrentWeapon( localClientNum );
		//PrintLn( "current weapon: " + new_weapon + " GetSubStr( new_weapon, 0, 3 ) " + GetSubStr( new_weapon, 0, 3 ) );			

		// need to show flamethrower pilot light if applicable
		if( GetSubStr( new_weapon, 0, 3 ) == "ft_" && !level._ft_pilot_on[ localClientNum ] )
		{
			assert(IsDefined(level._effect["ft_pilot_light"]), "Need to call 'clientscripts\_flamethrower_plight::init();' in you client script.");

			//PrintLn( "play ft_pilot_light for weapon: " + new_weapon );			
			level._ft_pilot_light = PlayViewmodelFx( localClientNum, level._effect["ft_pilot_light"], "tag_flamer_pilot_light" );
			level._ft_pilot_on[ localClientNum ] = true;
		}
		else if( GetSubStr( new_weapon, 0, 3 ) != "ft_" && level._ft_pilot_on[ localClientNum ] )
		{
			//PrintLn( "delete ft_pilot_light: " + level._ft_pilot_light );			
			DeleteFX( localClientNum, level._ft_pilot_light );
			level._ft_pilot_on[ localClientNum ] = false;
		}

		wait 0.5;
	}
}