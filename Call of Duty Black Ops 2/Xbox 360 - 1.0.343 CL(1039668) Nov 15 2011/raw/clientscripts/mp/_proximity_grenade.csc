// _proximity_grenade.csc 
// Sets up clientside behavior for the proximity grenade
#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

main()
{
	level._effect["prox_grenade_friendly_default"] = loadfx( "weapon/grenade/fx_prox_grenade_scan_grn" );
	level._effect["prox_grenade_friendly_warning"] = loadfx( "weapon/grenade/fx_prox_grenade_wrn_grn" );
	level._effect["prox_grenade_enemy_default"] = loadfx( "weapon/grenade/fx_prox_grenade_scan_red" );
	level._effect["prox_grenade_enemy_warning"] = loadfx( "weapon/grenade/fx_prox_grenade_wrn_red" );
}


spawned( localClientNum ) // self == the grenade
{
	self endon( "entityshutdown" );

	friend = self friendNotFoe( localClientNum );
	
	if ( !friend )
	{
		self.fxDefault = level._effect["prox_grenade_enemy_default"];
		self.fxWhenActivated = level._effect["prox_grenade_enemy_warning"];
	}
	else
	{
		self.fxDefault = level._effect["prox_grenade_friendly_default"];
		self.fxWhenActivated = level._effect["prox_grenade_friendly_warning"];
	}
		
	self thread checkForActivation();
	self thread proximityGrenadeFxDefault( localClientNum );
	self thread proximityGrenadeFxActivated( localClientNum );
}

checkForActivation()
{
	self endon( "entityshutdown" );

	while( 1 )
	{
		if ( isDefined( self.enemyInProximity ) && self.enemyInProximity )
			self notify( "ent_in_proximity" );

		wait( 0.5 );
	}
}

proximityGrenadeFxDefault( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "ent_in_proximity" );

	if( isDefined( self.fxDefault ) )
	{
		self.proximityGrenadeFx = PlayFXOnTag( localClientNum, self.fxDefault, self, "tag_fx" );
	}	
}

proximityGrenadeFxActivated( localClientNum )
{
	self endon( "entityshutdown" );
	self waittill( "ent_in_proximity" );

	if ( isDefined( self.proximityGrenadeFx ) )
	{
		stopfx( localClientNum, self.proximityGrenadeFx );
		self.proximityGrenadeFx = undefined;
	}

	if( isDefined( self.fxWhenActivated ) )
	{
		PlayFXOnTag( localClientNum, self.fxWhenActivated, self, "tag_fx" );
		self playsound( 0, "wpn_pgrenade_alarm" );
	}
}








