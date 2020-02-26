#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

init()
{
	level._effect["tacticalInsertionFriendly"] = LoadFX( "misc/fx_equip_tac_insert_light_grn" );
	level._effect["tacticalInsertionEnemy"] = LoadFX( "misc/fx_equip_tac_insert_light_red" );
	level._client_flag_callbacks["scriptmover"][level.const_flag_tactical_insertion] = ::spawned;
}

spawned( localClientNum, set )
{	
	if ( !set )
		return;
		
	self thread playFlareFX( localClientNum, true );
	self thread checkForPlayerSwitch( localClientNum );
}

playFlareFX( localClientNum, playsound )
{
	self endon( "entityshutdown" );
	level endon( "demo_player_switch" );
	
	while ( true )
	{
	
		if ( friendNotFoe(localClientNum) )
			self.tacticalInsertionFX = PlayFXOnTag( localClientNum, level._effect["tacticalInsertionFriendly"], self, "tag_flash" );
		else
			self.tacticalInsertionFX = PlayFXOnTag( localClientNum, level._effect["tacticalInsertionEnemy"], self, "tag_flash" );
			
		if ( playsound )
			self PlaySound(localClientNum, "fly_tinsert_beep");
		else
			playsound = true;
		
		serverWait( localClientNum, 1.0 );
	}
}

checkForPlayerSwitch( localClientNum )
{
	self endon( "entityshutdown" );
	
	while ( true )
	{
		level waittill( "demo_player_switch" );

		if ( isDefined( self.tacticalInsertionFX ) )
		{
			stopFx( localClientNum, self.tacticalInsertionFX );
			self.tacticalInsertionFX = undefined;
		}
	
		waittillframeend;
		
		self thread playFlareFX( localClientNum, false );
	}
}