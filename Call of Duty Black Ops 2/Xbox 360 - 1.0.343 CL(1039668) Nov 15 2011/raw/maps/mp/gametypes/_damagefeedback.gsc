init()
{
	precacheShader("damage_feedback");
//	precacheShader("damage_feedback_medium");
//	precacheShader("damage_feedback_small");
//	precacheShader("damage_feedback_j");

	level.hud_damageindicator_size = 24;
	
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.hud_damagefeedback = newClientHudElem(player);
		player.hud_damagefeedback.horzAlign = "center";
		player.hud_damagefeedback.vertAlign = "middle";
		player.hud_damagefeedback.x = -1 * ( level.hud_damageindicator_size / 2 );
		player.hud_damagefeedback.y = -1 * ( level.hud_damageindicator_size / 2 );
		player.hud_damagefeedback.alpha = 0;
		player.hud_damagefeedback.archived = true;
		player.hud_damagefeedback setShader("damage_feedback", level.hud_damageindicator_size, 64);
		player.hitSoundTracker = true;
	}
}

updateDamageFeedback( hitBodyArmor, mod, damage )
{
	if ( !isPlayer( self ) || SessionModeIsZombiesGame() )
		return;
	
	if ( hitBodyArmor )
	{
		//self.hud_damagefeedback setShader("damage_feedback_j", level.hud_damageindicator_size, 48);
		self playlocalsound("mpl_hit_alert"); 
	}
	else
	{
		shader = "damage_feedback";
		
		current_size = level.hud_damageindicator_size;

		// 9/16/11 - TFLAME - 
		/*
		if ( isdefined( damage ) )
		{
			if ( damage < 25 )
			{
				//shader = "damage_feedback_small";
				current_size -= 16;
			}
			else if ( damage < 34 )
			{
				//shader = "damage_feedback_medium";
				current_size -= 8;
			}
		}
		*/
		
		//println( "damage: " + damage + " size: " + current_size + " " + current_size * 2 + " " + (-1 * ( current_size / 2 )) );
		self.hud_damagefeedback setShader(shader, current_size, current_size * 2);
		self.hud_damagefeedback.x =  -1 * ( current_size / 2 );
		self.hud_damagefeedback.y =  -1 * ( current_size / 2 );
		
		if ( isdefined( mod ) && mod != "MOD_CRUSH" && mod != "MOD_GRENADE_SPLASH" && mod != "MOD_HIT_BY_OBJECT" )
		{
			self thread playHitSound (mod);
		}
	}
	
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime(1);
	self.hud_damagefeedback.alpha = 0;
}
playHitSound (mod)
{
self endon ("disconnect");
	if (self.hitSoundTracker)
	{
		self.hitSoundTracker = false;
		self playlocalsound("mpl_hit_alert");
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
