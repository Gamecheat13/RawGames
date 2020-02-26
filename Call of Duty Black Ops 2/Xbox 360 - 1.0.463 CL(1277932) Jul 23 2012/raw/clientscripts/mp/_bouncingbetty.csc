#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

init( localClientNum )
{
	level._effect["fx_betty_friendly_light"] = loadfx( "weapon/bouncing_betty/fx_betty_light_green" );
	level._effect["fx_betty_enemy_light"] = loadfx( "weapon/bouncing_betty/fx_betty_light_red" );
}

spawned( localClientNum )
{	
	self thread playFlareFX( localClientNum );
	self thread checkForPlayerSwitch( localClientNum );
}

playFlareFX( localClientNum )
{
	self endon( "entityshutdown" );
	level endon( "player_switch" );
	
	if ( friendNotFoe(localClientNum) )
		self.bouncingBettyIdleFX = PlayFXOnTag( localClientNum, level._effect["fx_betty_friendly_light"], self, "tag_origin" );
	else
		self.bouncingBettyIdleFX = PlayFXOnTag( localClientNum, level._effect["fx_betty_enemy_light"], self, "tag_origin" );

	self thread watchBettyShutdown( localClientNum, self.bouncingBettyIdleFX );
}

watchBettyShutdown( localClientNum, fxHandle )
{
	msg = self waittill_any_return( "entityshutdown", "team_changed" );
	StopFX( localClientNum, fxHandle );

	if ( msg == "team_changed" )
	{
		self thread playFlareFX( localClientNum );
	}
}

checkForPlayerSwitch( localClientNum )
{
	self endon( "entityshutdown" );
	
	while ( true )
	{
		level waittill( "player_switch" );

		if ( isDefined( self.bouncingBettyIdleFX ) )
		{
			stopFx( localClientNum, self.bouncingBettyIdleFX );
			self.bouncingBettyIdleFX = undefined;
		}
	
		waittillframeend;
		
		self thread playFlareFX( localClientNum );
	}
}