init()
{
	precacheShader( "damage_feedback" );
	precacheShader( "damage_feedback_flak" );
	precacheShader( "damage_feedback_tac" );
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.hud_damagefeedback = newdamageindicatorhudelem(player);
		player.hud_damagefeedback.horzAlign = "center";
		player.hud_damagefeedback.vertAlign = "middle";
		player.hud_damagefeedback.x = -12;
		player.hud_damagefeedback.y = -12;
		player.hud_damagefeedback.alpha = 0;
		player.hud_damagefeedback.archived = true;
		player.hud_damagefeedback setShader( "damage_feedback", 24, 48 );
		player.hitSoundTracker = true;
	}
}

updateDamageFeedback( mod, inflictor, perkFeedback )
{
	if ( !isPlayer( self ) || SessionModeIsZombiesGame() )
		return;
	
	if ( isdefined( mod ) && mod != "MOD_CRUSH" && mod != "MOD_GRENADE_SPLASH" && mod != "MOD_HIT_BY_OBJECT" )
	{
	
		if ( isdefined( inflictor ) && isdefined( inflictor.soundMod ))
		{
			//Add sound stuff here for specific inflictor types	
			switch ( inflictor.soundMod )
			{
				case "player":
				self thread playHitSound (mod, "mpl_hit_alert");					
					break;	

				case "heli":	
				self thread playHitSound (mod, "mpl_hit_alert_air");	
					break;
					
				case "hpm":	
				self thread playHitSound (mod, "mpl_hit_alert_hpm");	
					break;
	
				case "taser_spike":
				self thread playHitSound (mod, "mpl_hit_alert_taser_spike");						
					break;	
					
				case "straferun":				
				case "dog":
					break;	
										
				case "default_loud":
				self thread playHitSound (mod, "mpl_hit_heli_gunner");					
					break;						
				
				default:
				self thread playHitSound (mod, "mpl_hit_alert_low");		
					break;
			}
		}

		else
		{
			self thread playHitSound (mod, "mpl_hit_alert_low");
		}
	}
	
	if ( isdefined( perkFeedback ) )
	{
		switch( perkFeedback )
		{
			case "flakjacket": 
				self.hud_damagefeedback setShader( "damage_feedback_flak", 24, 48 );
			break; 
			case "tacticalMask": 
				self.hud_damagefeedback setShader( "damage_feedback_tac", 24, 48 );
			break;
		}

	}
	else
	{
		self.hud_damagefeedback setShader( "damage_feedback", 24, 48 );
	}
	
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime(1);
	self.hud_damagefeedback.alpha = 0;
}
playHitSound (mod, alert)
{
	self endon ("disconnect");
	
	if (self.hitSoundTracker)
	{
		self.hitSoundTracker = false;
		
		self playlocalsound(alert);
		
		//println ("hit type mod " + mod);
		wait .05;	// waitframe
		self.hitSoundTracker = true;
	}
}	

updateSpecialDamageFeedback( hitEnt )
{
	if ( !isPlayer( self ) )
		return;
	
	if ( !isdefined(hitEnt) )
		return;
		
	if ( !isPlayer( hitEnt ) )
		return;

	wait (0.05);
	if ( !isdefined( self.directionalHitArray ) )
	{
		self.directionalHitArray = [];
		hitEntNum = hitEnt getEntityNumber();
		self.directionalHitArray[hitEntNum] = 1;
		self thread sendHitSpecialEventAtFrameEnd(hitEnt);
	}
	else
	{
		hitEntNum = hitEnt getEntityNumber();
		self.directionalHitArray[hitEntNum] = 1;
	}
}

sendHitSpecialEventAtFrameEnd(hitEnt)
{
	self endon ("disconnect");
	waittillframeend;

	enemysHit = 0;
	value = 1;
		
	entBitArray0 = 0;
	for ( i = 0; i < 32; i++ )
	{
		if (isdefined (self.directionalHitArray[i]) && self.directionalHitArray[i] != 0 )
		{
			entBitArray0 += value;
			enemysHit++;
		}
		value *= 2;
	}	
	entBitArray1 = 0;
	for (  i = 33; i < 64; i++ )
	{
		if (isdefined (self.directionalHitArray[i]) && self.directionalHitArray[i] != 0 )
		{
			entBitArray1 += value;
			enemysHit++;
		}
		value *= 2;
	}
	

	if ( enemysHit )
	{
		self directionalHitIndicator( entBitArray0, entBitArray1 );
	}
	self.directionalHitArray = undefined;
	entBitArray0 = 0;
	entBitArray1 = 0;
}
