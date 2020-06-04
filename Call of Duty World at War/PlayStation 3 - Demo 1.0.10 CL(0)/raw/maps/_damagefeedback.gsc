
// MikeD (12/17/2007): Not called anywhere
init()
{
	precacheShader( "damage_feedback" );
	
	if ( getDvar( "scr_damagefeedback" ) == "" )
		setDvar( "scr_damagefeedback", "0" );

	if ( !getDvarInt( "scr_damagefeedback" ) )
		return;

	self.hud_damagefeedback = newHudElem( self );
	self.hud_damagefeedback.alignX = "center";
	self.hud_damagefeedback.alignY = "middle";
	self.hud_damagefeedback.horzAlign = "center";
	self.hud_damagefeedback.vertAlign = "middle";
	self.hud_damagefeedback.alpha = 0;
	self.hud_damagefeedback.archived = true;
	self.hud_damagefeedback setShader( "damage_feedback", 24, 24 );
}

monitorDamage()
{
	if ( !getDvarInt( "scr_damagefeedback" ) )
		return;

	for ( ;; )
	{
		self waittill( "damage", amount, attacker );
		
		if ( IsPlayer( attacker ) )
			attacker updateDamageFeedback();
	}
}

updateDamageFeedback()
{
	if ( !IsPlayer( self ) )
		return;
	
	self playlocalsound( "SP_hit_alert" );
	
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime( 1 );
	self.hud_damagefeedback.alpha = 0;
}