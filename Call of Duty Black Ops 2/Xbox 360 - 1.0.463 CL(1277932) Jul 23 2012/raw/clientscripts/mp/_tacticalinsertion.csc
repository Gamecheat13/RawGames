#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;
#include clientscripts\mp\_audio;
#insert raw\maps\mp\_clientflags.gsh;

init()
{
	level._effect["tacticalInsertionFriendly"] = LoadFX( "misc/fx_equip_tac_insert_light_grn" );
	level._effect["tacticalInsertionEnemy"] = LoadFX( "misc/fx_equip_tac_insert_light_red" );

	level._client_flag_callbacks["scriptmover"][CLIENT_FLAG_TACTICAL_INSERTION] = ::spawned;
}

spawned( localClientNum, set )
{	
	if ( !set )
		return;
		
	self thread playFlareFX( localClientNum );
	self thread checkForPlayerSwitch( localClientNum );
}

playFlareFX( localClientNum )
{
	self endon( "entityshutdown" );
	level endon( "player_switch" );
	
	if ( friendNotFoe(localClientNum) )
	{
		self.tacticalInsertionFX = PlayFXOnTag( localClientNum, level._effect["tacticalInsertionFriendly"], self, "tag_flash" );
	}
	else
	{
		self.tacticalInsertionFX = PlayFXOnTag( localClientNum, level._effect["tacticalInsertionEnemy"], self, "tag_flash" );
	}

	self thread watchTacInsertShutdown( localClientNum, self.tacticalInsertionFX );
	
	//self PlaySound(localClientNum, "fly_tinsert_beep");
	loopOrigin = self.origin;
	playloopat( "fly_tinsert_beep", loopOrigin);
	
	self thread stopflareloopWatcher( loopOrigin );

}

watchTacInsertShutdown( localClientNum, fxHandle )
{
	self waittill( "entityshutdown" );
	StopFX( localClientNum, fxHandle );
}

stopflareloopWatcher( loopOrigin )
{
	while (1)
	{
		if (!isdefined(self.tacticalInsertionFX ))
		{
			stoploopat ( "fly_tinsert_beep", loopOrigin);
			//self notify ("stoppedLoop");
			break;
		}
		
		wait .5;
	}
}

checkForPlayerSwitch( localClientNum )
{
	self endon( "entityshutdown" );
	
	while ( true )
	{
		level waittill( "player_switch" );

		if ( isDefined( self.tacticalInsertionFX ) )
		{
			stopFx( localClientNum, self.tacticalInsertionFX );
			self.tacticalInsertionFX = undefined;
		}
	
		waittillframeend;
		
		self thread playFlareFX( localClientNum );
	}
}