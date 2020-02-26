#include clientscripts\mp\_utility;

main()
{
}

playerspawned( localClientNum )
{
	self thread watchForRespawn();
	self thread watchForExplosion();
	self thread watchForDaze();
}

watchForRespawn()
{
	self endon( "entityshutdown" );
	
	menuName = "fullscreen_dirt";
	if ( IsDefined( level.isWinter ) && level.isWinter )
		menuName = "fullscreen_snow";
	
	while ( true )
	{
		localPlayers = level.localPlayers;
		for ( i = 0 ; i < localPlayers.size ; i++ )
		{
			if ( !IsSplitscreen() && ( localPlayers[i] == self ) )
			{
				AnimateUI( i, menuName, "dirt", "Default", 0 );
				AnimateUI( i, menuName, "blurred_dirt", "Default", 0 );
				AnimateUI( i, menuName, "dirt_left", "Default", 0 );
				AnimateUI( i, menuName, "dirt_left_splash", "Default", 0 );
				AnimateUI( i, menuName, "dirt_right", "Default", 0 );
				AnimateUI( i, menuName, "dirt_right_splash", "Default", 0 );
			}
		}
		self waittill( "respawn" );
	}
}

watchForExplosion()
{
	self endon( "entityshutdown" );
	
	if ( IsSplitscreen() )
		return;
	
	menuName = "fullscreen_dirt";
	if ( IsDefined( level.isWinter ) && level.isWinter )
		menuName = "fullscreen_snow";
	
	while ( true )
	{
		self waittill( "explode", localClientNum, position, mod, weaponName );
		localPlayer = GetLocalPlayer( localClientNum );
		if ( ( localPlayer == self ) && ( !localPlayer isPlayerViewLinkedToEntity( localClientNum ) ) )
		{
			if ( weaponName == "proximity_grenade_mp" && distance( localPlayer.origin, position ) < GetDvarInt( "scr_proximityGrenadeDamageRadius" )  )
			{
				trace = bulletTrace( GetLocalClientEyePos( localClientNum ), position, false, self );
				
				if ( trace["fraction"] >= 1 )
					localPlayer thread playProximityGrenadeEffects( localClientNum );
			}

			if ( ( ( mod == "MOD_GRENADE_SPLASH" ) || ( mod == "MOD_PROJECTILE_SPLASH" ) ) && ( Distancesquared( localPlayer.origin, position ) < (600*600) ) )
			{
				trace = bulletTrace( GetLocalClientEyePos( localClientNum ), position, false, self );
				if ( trace["fraction"] >= 1 )
				{
					forwardVec = VectorNormalize( AnglesToForward( localPlayer.angles ) );
					rightVec = VectorNormalize( AnglesToRight( localPlayer.angles ) );
					explosionVec = VectorNormalize( position - localPlayer.origin );
					
					fDot = VectorDot( explosionVec, forwardVec );
					rDot = VectorDot( explosionVec, rightVec );
					
					if ( fDot > 0.5 )
						AnimateUI( localClientNum, menuName, "dirt", "in", 0 );
						
					if ( abs( fDot ) < 0.866 )
					{
						if ( rDot > 0 )
							AnimateUI( localClientNum, menuName, "dirt_right", "in", 0 );
						else
							AnimateUI( localClientNum, menuName, "dirt_left", "in", 0 );
					}
				}
			}
		}
	}
}

playProximityGrenadeEffects( localClientNum )
{
	wait 0.7;
	visionsetnaked( localClientNum, "proximity_grenade", 3 );
	wait 4.0;
	visionsetnaked( localClientNum, GetDvar( "mapname" ), 3 );
}

watchForDaze()
{
	self notify ("dazeloop");
	self endon ("dazeloop");
	while(1)
	{
		level waittill ("pg_daze");
		self pg_daze();
	}
}
		
		
pg_daze()
{
	self endon ("entityshutdown");
	duration = 6;
	framerate = .016;
	
	reps = duration / framerate;
	counter = 0;
	
	degree = -360;
	dchange = 2;
	while(counter < reps)
	{
		while(degree < 360 && counter < reps)
		{
			wait framerate;
			degree +=dchange;
			setdvar("r_poisonFX_dvisionA", degree);
			counter++;
		}
		while(degree > -360 && counter < reps)
		{
			wait framerate;
			degree -=dchange;
			setdvar("r_poisonFX_dvisionA", degree);
			counter++;
		}
	}
}