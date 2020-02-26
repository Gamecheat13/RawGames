#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	level.flareVisionEffectRadius = flare_get_dvar_int( "flare_effect_radius", "400" );
	level.flareDuration = flare_get_dvar_int( "flare_duration", "8"); //in seconds
	level.flareDistanceScale = flare_get_dvar_int( "flare_distance_scale", "16"); 
	level.flareLookAwayFadeWait = flare_get_dvar( "flareLookAwayFadeWait", "0.45" );
	level.flareBurnOutFadeWait = flare_get_dvar( "flareBurnOutFadeWait", "0.65" );
	//greater the number the longer the shock will be the closer you get to the explosion
}


watchFlareDetonation( owner )
{
	self waittill( "explode", position );
	
	level.flareVisionEffectRadius = flare_get_dvar_int( "flare_effect_radius", level.flareVisionEffectRadius );
	durationOfFlare = flare_get_dvar_int( "flare_duration", level.flareDuration );
	level.flareDistanceScale = flare_get_dvar_int( "flare_distance_scale", level.flareDistanceScale); 

	
	flareEffectArea = spawn("trigger_radius", position, 0, level.flareVisionEffectRadius, level.flareVisionEffectRadius*2);
	loopWaitTime = .5;

	while (durationOfFlare > 0)
	{
		players = get_players();
		for (i = 0; i < players.size; i++)
		{	
			if (!isDefined(players[i].item))
			{
				players[i].item = 0;
			}	

			if ( ( !isDefined ( players[i].inFlareVisionArea ) )  || ( players[i].inFlareVisionArea == false ) )
			{
				if (players[i].sessionstate == "playing" )
				{
					players[i].item = players[i] playersighttrace( position, level.flareVisionEffectRadius, players[i].item);
					if (players[i].item == 0)
					{
						players[i].lastFlaredby = owner;
						thread flareVision( players[i], flareEffectArea, position );
						players[i] thread maps\mp\gametypes\_battlechatter_mp::incomingSpecialGrenadeTracking( "flare" );
					}
				}	
			}
			
		}
		wait (loopWaitTime);
		durationOfFlare -= loopWaitTime;
	}
	
	flareEffectArea delete();	
}

flareVision( player, flareEffectArea, position )
{
	player endon( "disconnect" );
	player notify( "flareVision" );
	player endon( "flareVision" );
	player.inFlareVisionArea = true;
	
	loopWaitTime = 0.05;
	sightTraceTime = 0.3;
	count = 0;
	maxdistance = level.flareVisionEffectRadius;

	while ( (isdefined (flareEffectArea) ) && ( player.sessionstate == "playing" && player.item == 0 )  && !( player player_is_driver() ) )
	{
		wait( loopWaitTime );
		ratio = 1 - ( ( distance ( player.origin, position ) ) / maxdistance );
		player VisionSetLerpRatio( ratio );
		
		if ( count * loopWaitTime > sightTraceTime )
		{			
			player.item = player playersighttrace( position, level.flareVisionEffectRadius, player.item );
			count = 0;
		}
		count++;
	}
		
	if (! isdefined (flareEffectArea) )
		wait( flare_get_dvar( "flareBurnOutFadeWait", level.flareBurnOutFadeWait ) );
	else if (distance( position, player.origin) < level.flareVisionEffectRadius )
		wait( flare_get_dvar( "flareLookAwayFadeWait", level.flareLookAwayFadeWait ) );

	player.inFlareVisionArea = false;	
	player VisionSetLerpRatio( 0 );
}


// returns dvar value in int
flare_get_dvar_int( dvar, def )
{
	return int( flare_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
flare_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
	{
		return getdvarfloat( dvar );
	}
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

player_is_driver()
{
	if ( !isalive(self) )
		return false;
		
	vehicle = self GetVehicleOccupied();
	
	if ( IsDefined( vehicle ) )
	{
		seat = vehicle GetOccupantSeat( self );
		
		if ( isdefined(seat) && seat == 0 )
			return true;
	}
	
	return false;
}

