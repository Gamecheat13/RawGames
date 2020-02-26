
// MikeD (12/17/2007): Not called anywhere
precache()
{
	precacheShader( "damage_feedback" );
}


init(fadeTime)
{	
	if ( GetDvar( "scr_damagefeedback" ) == "" )
		SetDvar( "scr_damagefeedback", "1" );

	if ( !GetDvarint( "scr_damagefeedback" ) )
		return;

	self.hud_damagefeedback = newclientHudElem( self );
	self.hud_damagefeedback.horzAlign = "center";
	self.hud_damagefeedback.vertAlign = "middle";
	self.hud_damagefeedback.x = -12;
	self.hud_damagefeedback.y = -12;
	self.hud_damagefeedback.alpha = 0;
	self.hud_damagefeedback.archived = true;
	self.hud_damagefeedback setShader("damage_feedback", 24, 48);
	
	if (IsDefined(fadeTime))
	{
		self.hud_damagefeedback.fadeTime = fadeTime;
	}
	else
	{
		self.hud_damagefeedback.fadeTime = 1;		
	}
}

/*
doDamageFeedback( sWeapon, eInflictor )
{
	switch(sWeapon)
	{
		case "artillery_mp":
		case "airstrike_mp":
		case "napalm_mp":
		case "mortar_mp":
			return false;
	}
		
	if ( IsDefined( eInflictor ) )
	{
		if ( IsAI(eInflictor) )
		{
			return false;
		}
		if ( IsDefined(level.chopper) && level.chopper == eInflictor )
		{
			return false;
		}
	}
	
	return true;
}
*/

updateDamageFeedback()
{
	if ( !GetDvarint( "scr_damagefeedback" ) )
		return;

	if ( !IsPlayer( self ) )
		return;

	self playlocalsound( "spl_hit_alert" );

	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime( self.hud_damagefeedback.fadeTime );
	self.hud_damagefeedback.alpha = 0;
}
