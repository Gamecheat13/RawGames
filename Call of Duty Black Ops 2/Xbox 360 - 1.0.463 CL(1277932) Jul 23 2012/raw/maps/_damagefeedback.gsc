
// MikeD (12/17/2007): Not called anywhere
precache()
{
	precacheShader( "damage_feedback_glow" );
	precacheShader( "damage_feedback_glow_blue" );
	precacheShader( "damage_feedback_glow_orange" );
}


init(fadeTime)
{
	if ( GetDvar( "scr_damagefeedback" ) == "" )
		SetDvar( "scr_damagefeedback", "1" );

	if ( !GetDvarint( "scr_damagefeedback" ) )
		return;

	self.hud_damagefeedback = newdamageindicatorhudelem( self );
	self.hud_damagefeedback.horzAlign = "center";
	self.hud_damagefeedback.vertAlign = "middle";
	self.hud_damagefeedback.x = -12;
	self.hud_damagefeedback.y = -12;
	self.hud_damagefeedback.alpha = 0;
	self.hud_damagefeedback.archived = true;
	self.hud_damagefeedback setShader( "damage_feedback_glow", 24, 48 );

	self.hud_damagefeedback_blue = newdamageindicatorhudelem( self );
	self.hud_damagefeedback_blue.horzAlign = "center";
	self.hud_damagefeedback_blue.vertAlign = "middle";
	self.hud_damagefeedback_blue.x = -12;
	self.hud_damagefeedback_blue.y = -12;
	self.hud_damagefeedback_blue.alpha = 0;
	self.hud_damagefeedback_blue.archived = true;
	self.hud_damagefeedback_blue setShader( "damage_feedback_glow_blue", 24, 48 );

	self.hud_damagefeedback_orange = newdamageindicatorhudelem( self );
	self.hud_damagefeedback_orange.horzAlign = "center";
	self.hud_damagefeedback_orange.vertAlign = "middle";
	self.hud_damagefeedback_orange.x = -12;
	self.hud_damagefeedback_orange.y = -12;
	self.hud_damagefeedback_orange.alpha = 0;
	self.hud_damagefeedback_orange.archived = true;
	self.hud_damagefeedback_orange setShader( "damage_feedback_glow_orange", 24, 48 );

	if( IsDefined( fadeTime ) )
	{
		self.hud_damagefeedback.fadeTime = fadeTime;
		self.hud_damagefeedback_blue.fadeTime = fadeTime;
		self.hud_damagefeedback_orange.fadeTime = fadeTime;
	}
	else
	{
		self.hud_damagefeedback.fadeTime = 1;
		self.hud_damagefeedback_blue.fadeTime = 1;
		self.hud_damagefeedback_orange.fadeTime = 1;
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
	if( !GetDvarint( "scr_damagefeedback" ) )
		return;

	if( !IsPlayer( self ) || !isDefined( self.hud_damagefeedback ) )
		return;

	self playlocalsound( "spl_hit_alert" );

	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime( self.hud_damagefeedback.fadeTime );
	self.hud_damagefeedback.alpha = 0;
}

updateVechicleDamageFeedback( weapon )
{
	if( !GetDvarint( "scr_damagefeedback" ) )
		return;

	if( !IsPlayer( self ) || !isDefined( self.hud_damagefeedback ) || !isDefined( self.hud_damagefeedback_blue ) || !isDefined( self.hud_damagefeedback_orange ) )
		return;

	self playlocalsound( "spl_hit_alert" );

	if( !isDefined( weapon ) )
	{
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeOverTime( self.hud_damagefeedback.fadeTime );
		self.hud_damagefeedback.alpha = 0;
		return;
	}

	switch( weapon )
	{
		case "f35_missile_turret_player":
		case "f35_side_minigun_player":
		case "f35_death_blossom":
			self.hud_damagefeedback_blue.alpha = 1;
			self.hud_damagefeedback_blue fadeOverTime( self.hud_damagefeedback_blue.fadeTime );
			self.hud_damagefeedback_blue.alpha = 0;
			break;
		case "sam_turret_player_sp":
			self.hud_damagefeedback_orange.alpha = 1;
			self.hud_damagefeedback_orange fadeOverTime( self.hud_damagefeedback_orange.fadeTime );
			self.hud_damagefeedback_orange.alpha = 0;
			break;
		default:
			self.hud_damagefeedback.alpha = 1;
			self.hud_damagefeedback fadeOverTime( self.hud_damagefeedback.fadeTime );
			self.hud_damagefeedback.alpha = 0;
			break;
	}
}
