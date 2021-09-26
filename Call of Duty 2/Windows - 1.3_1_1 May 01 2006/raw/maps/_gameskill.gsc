#include maps\_utility;
#include animscripts\utility;
// this script handles all major global gameskill considerations
setSkill(reset)
{
	if (!isdefined(level.script))
		level.script = tolower(getcvar ("mapname"));
	
	if (!isdefined(reset) || reset == false)
	{
		if (isdefined(level.gameSkill))
			return;
	}
		
	if (!isdefined (level.xenon))
		level.xenon = (getcvar ("xenonGame") == "true");
	level.gameSkill = getcvarint("g_gameskill");
	flag_clear("player_has_red_flashing_overlay");
	flag_clear("player_is_invulnerable");
	setTakeCoverWarnings();
	thread increment_take_cover_warnings_on_death();
	
	if (!isdefined(level.axis_accuracy))
		level.axis_accuracy = 1;
		
	level.mg42badplace_mintime = 8; // minimum # of seconds a badplace is created on an mg42 after its operator dies
	level.mg42badplace_maxtime = 16; // maximum # of seconds a badplace is created on an mg42 after its operator dies

	// missTime is a number based on the distance from the AI to the player + some baseline
	// so the faster it gets reduced, the quicker the AI gains accuracy vs the player
	// this is used for auto and semi auto
	anim.missReductionRate = 1;

	if (level.gameSkill >= 3)
	{
		// fu (AI can spam grenades)
		anim.playerGrenadeBaseTime = 1;
		anim.playerGrenadeRangeTime = 1;
		level.player.threatbias = 175;
		if (level.xenon)
 			anim.difficultyBasedAccuracy = 1.25;
 		else
 			anim.difficultyBasedAccuracy = 1.4;

		anim.baseAccuracyBolt = 0.25;
		anim.accuracyIncreaseBolt = 1;
		anim.minimumBoltPlayerProtectionTime = 800;
		level.longRegenTime = 3000;
		level.healthOverlayCutoff = 0.35;
	}
	else
	if (level.gameSkill == 2)
	{
		// hard (AI can throw a few more grenades);
		anim.playerGrenadeBaseTime = 10000;
		anim.playerGrenadeRangeTime = 5000;
		level.player.threatbias = 150;
		if (level.xenon)
	 		anim.difficultyBasedAccuracy = 1;
 		else
	 		anim.difficultyBasedAccuracy = 1;

		anim.baseAccuracyBolt = 0.15;
		anim.accuracyIncreaseBolt = 0.4;
		anim.minimumBoltPlayerProtectionTime = 800;
		level.longRegenTime = 3000;
		level.healthOverlayCutoff = 0.35;
	}
	else
	if (level.gameSkill == 1)
	{
		// normal
//		anim.missReductionRate = 0.5;
		anim.playerGrenadeBaseTime = 15000;
		anim.playerGrenadeRangeTime = 5000;
		level.player.threatbias = 75;
		if (level.xenon)
			anim.difficultyBasedAccuracy = 1;
		else
			anim.difficultyBasedAccuracy = 1; // 0.8

		anim.baseAccuracyBolt = 0.2;
		anim.accuracyIncreaseBolt = 1;
		anim.minimumBoltPlayerProtectionTime = 1400;
		level.longRegenTime = 3000;
		level.healthOverlayCutoff = 0.28;
 	}
	else // easy
	{
//		anim.missReductionRate = 0.5;
		anim.playerGrenadeBaseTime = 30000;
		anim.playerGrenadeRangeTime = 10000;
		level.player.threatbias = 75;
		if (level.xenon)
	 		anim.difficultyBasedAccuracy = 1;
	 	else
	 		anim.difficultyBasedAccuracy = 1; // 0.65

		anim.baseAccuracyBolt = 0.2;
		anim.accuracyIncreaseBolt = 1;
//		anim.minimumBoltPlayerProtectionTime = 1400;
		anim.minimumBoltPlayerProtectionTime = 2400;
		level.longRegenTime = 4500;
		level.healthOverlayCutoff = 0.01;
 	}
	anim.baseAccuracyBolt = 1;
	anim.accuracyIncreaseBolt = 1;

	if (level.xenon)
	{
		// xenon
		if (level.gameSkill >= 3)
		{
			// fu
			level.invulTime_full = 0.0;
			level.invulTime_short = 0.0;
			level.playerHealth_RegularRegenDelay = 1200; // 1500; //4700;

			// fu
			level.invulTime_full = 0; // 0.4
			level.invulTime_short = 0; // 0.2
			level.playerHealth_RegularRegenDelay = 1200; // 1500; //4700;

			level.worthyDamageRatio = 0.0;
			level.explosiveplanttime = 5; 
		}
		else
		if (level.gameSkill == 2)
		{
			// hard
			level.invulTime_full = 1.0;
			level.invulTime_short = 0.5;
			level.playerHealth_RegularRegenDelay = 1200; // 1500; //4700;

			// hard
			level.invulTime_full = 1.3;
			level.invulTime_short = 0.4;
			level.playerHealth_RegularRegenDelay = 1200; // 1500; //4700;

			level.worthyDamageRatio = 0.0;
			level.explosiveplanttime = 5; 
		}
		else
		if (level.gameSkill == 1)
		{
			// normal
			level.invulTime_full = 2.2;
			level.invulTime_short = 1.0;
			level.playerHealth_RegularRegenDelay = 2000; // 1500; //4700;

			// normal
			level.invulTime_full = 2.2;
			level.invulTime_short = 1.75;
			level.playerHealth_RegularRegenDelay = 2000; // 1500; //4700;

			level.worthyDamageRatio = 0.18;
			level.explosiveplanttime = 10; 
		}
		else
		{
			// easy
			level.invulTime_full = 2.6;
			level.invulTime_short = 1.5;
			level.playerHealth_RegularRegenDelay = 2500; // 1500; //4700;

			level.invulTime_full = 2.6;
			level.invulTime_short = 2.5;
			level.playerHealth_RegularRegenDelay = 3000; // 1500; //4700;
			
			level.worthyDamageRatio = 0.0;
			level.explosiveplanttime = 10;
		}
	}
	else
	{
		// pc
		if (level.gameSkill >= 3)
		{
			// fu
			level.invulTime_full = 0; // 0.4
			level.invulTime_short = 0; // 0.2
			level.playerHealth_RegularRegenDelay = 1200; // 1500; //4700;

			level.worthyDamageRatio = 0.0;
			level.explosiveplanttime = 5; 
		}
		else
		if (level.gameSkill == 2)
		{
			// hard
			level.invulTime_full = 1.3;
			level.invulTime_short = 0.4;
			level.playerHealth_RegularRegenDelay = 1200; // 1500; //4700;

			level.worthyDamageRatio = 0.0;
			level.explosiveplanttime = 5; 
		}
		else
		if (level.gameSkill == 1)
		{
			// normal
			level.invulTime_full = 2.2;
			level.invulTime_short = 1.75;
			level.playerHealth_RegularRegenDelay = 2000; // 1500; //4700;

			level.worthyDamageRatio = 0.18;
			level.explosiveplanttime = 5; 
		}
		else
		{
			// easy
			level.invulTime_full = 2.6;
			level.invulTime_short = 1.5;
			level.playerHealth_RegularRegenDelay = 2500; // 1500; //4700;

			level.invulTime_full = 2.6;
			level.invulTime_short = 2.5;
			level.playerHealth_RegularRegenDelay = 3000; // 1500; //4700;
			
			level.worthyDamageRatio = 0.0;
			level.explosiveplanttime = 10;
		}
	}

/*
	if (level.xenon)
		anim.missReductionRate *= 0.5;
*/

	if (level.xenon)
	{
		switch(level.gameSkill)
		{
			case 0: // easy
				anim.difficultyFunc = ::difficultyEasy;
				anim.missTime = ::missTimeEasy;
			break;
			case 1: // normal
				anim.difficultyFunc = ::difficultyEasy; 
				anim.missTime = ::missTimeNormal;
			break;
			case 2: // hardened
				anim.difficultyFunc = ::difficultyHard;
				anim.missTime = ::missTimeHard;
			break;
			case 3: // fu
				anim.difficultyFunc = ::difficultyFu;
				anim.missTime = ::missTimeFu;
			break;
		}
	}
	else
	{		// pc
		switch(level.gameSkill)
		{
			case 0: // easy
				anim.difficultyFunc = ::difficultyEasy;
				anim.missTime = ::missTimeEasy;
			break;
			case 1: // normal
				anim.difficultyFunc = ::difficultyEasy;
				anim.missTime = ::missTimeNormal;
			break;
			case 2: // hardened
				anim.difficultyFunc = ::difficultyHard;
				anim.missTime = ::missTimeHard;
			break;
			case 3: // fu
				anim.difficultyFunc = ::difficultyFu;
				anim.missTime = ::missTimeFu;
			break;
		}
	}
}

difficultyEasy()
{
	return false;
}

difficultyHard()
{
	if (!difficultyHardPainCheck())
		return false;

	return (randomint(100) > 25);
}

difficultyFu()
{
	if (!difficultyHardPainCheck())
		return false;
		
	return (randomint(100) > 25);
}

difficultyHardPainCheck()
{
	if (!isalive(self.enemy))
		return false;
		
	if (self.enemy != level.player)
		return false;
		
	if (!isalive (level.painAI) || level.painAI.anim_script != "pain")
		level.painAI = self;

	// The pain AI can always take pain, so if the player focuses on one guy he'll see pain animations.	
	if (self == level.painAI)
		return false;

	if (!isdefined (getAIWeapon(self.damageWeapon)))
		return false;
		
	if (getAIWeapon(self.damageWeapon)["type"] == "bolt")
		return false;
	return true;
}

playerInvul()
{
	autoguy = animscripts\weaponList::usingAutomaticWeapon() || animscripts\weaponList::usingSemiAutoWeapon();
	self endon ("long_death");

	self endon ("death");
	for (;;)
	{
		wait (0.05);
		waittillframeend; // in case our accuracy changed this frame
		if (self.anim_missTime > 0)
		{
			self.accuracy = 0;
			self.anim_missTime-=anim.missReductionRate;
			continue;
		}

		if (!autoGuy)
			continue;

		if (!isalive(self.enemy))
			continue;

		self.accuracy = self.baseAccuracy * level.axis_accuracy * anim.difficultyBasedAccuracy;
		if (!flag("player_is_invulnerable"))
			continue;

		self.accuracy = 0;
	}
}



missTimeFu(dist)
{
//	setMissTime(0.04 + dist * 0.000185);
	setMissTime(0.03 + dist * 0.000085);
}

missTimeHard(dist)
{
//	setMissTime(0.05 + dist * 0.0002);
	setMissTime(0.04 + dist * 0.0002);
}

missTimeNormal(dist)
{
//	setMissTime(0.1 + dist * 0.0004);
	setMissTime(0.2 + dist * 0.0008);
}

missTimeEasy(dist)
{
//	setMissTime(0.15 + dist * 0.0006);
	setMissTime(1 + dist * 0.0012);
}

shootBolt()
{
	if (!isalive(self.enemy))
	{
		self notify ("shotBolt");
		self shootWrapper();
		return;
	}

	if (self.enemy != level.player)
	{
		self.accuracy = self.baseaccuracy;
		self notify ("shotBolt");
		self shootWrapper();
		return;
	}

	tempAccuracy = self.accuracy;
//	if (flag("player_is_invulnerable") || gettime() < level.hurtTime + anim.minimumBoltPlayerProtectionTime)

	//while (gettime() < level.hurtTime + anim.minimumBoltPlayerProtectionTime)

	waittillframeend;
	while (flag("player_is_invulnerable"))
	{
		anim.shootQueue++;
		if (anim.shootQueue > 2)
		{
			thread shootQueueDecrement();
			self.accuracy *= 0.2;
			break;
		}
		
		timer = gettime();
		flag_waitopen("player_is_invulnerable");
		if (gettime() - timer > 1000)
		{
			multiplier = self.baseAccuracy * level.axis_accuracy * anim.difficultyBasedAccuracy;
			self.accuracy+=anim.accuracyIncreaseBolt * multiplier;
			if (self.accuracy >= multiplier)
				self.accuracy = multiplier;
		}
		/*
		ratio = level.player.health / level.player.maxHealth;
		if (ratio <= level.healthOverlayCutoff)
			wait (0.8 + randomfloat(0.3));
		else
		*/
//		wait (0.3 + randomfloat(0.3));
		thread shootQueueDecrement();
		wait ((anim.shootQueue-1)* 0.2);
		waittillframeend;
	}
			
	self notify ("shotBolt");
	self shootWrapper();
	self.accuracy = tempAccuracy;
//	waittillframeend;		
	multiplier = self.baseAccuracy * level.axis_accuracy * anim.difficultyBasedAccuracy;
	self.accuracy+=anim.accuracyIncreaseBolt * multiplier;
	if (self.accuracy >= multiplier)
		self.accuracy = multiplier;
}

shootQueueDecrement()
{
	wait (0.2);
	anim.shootQueue--;
}

shotsAfterPlayerBecomesInvul()
{
	return( 1 + randomfloat(4) );
}

// give the player a chance to react
resetAccuracyAndPause(optionalPauseFunction, funcparam)
{
	thread maps\_gameSkill::resetAccuracyAuto();
	if (!isalive (self.enemy))
		return;
	if (self.enemy != level.player)
		return;

	pauseFunc = isdefined(optionalPauseFunction);
		
//	timer = gettime();
	if (flag("player_is_invulnerable"))
	{
		while (flag("player_is_invulnerable"))
		{
			if (distance(self.origin, level.player.origin) > 750)
				break;
			if (anim.shootQueue > 1)
			{
				resetMissDebounceTime();
				self.accuracy *= 0.2;
				break;
			}
			
			anim.shootQueue++;

			if (pauseFunc)
				[[optionalPauseFunction]](funcparam);
			flag_waitopen("player_is_invulnerable");
			resetMissDebounceTime();
			thread shootQueueDecrement();
			self.accuracy = self.baseAccuracy * level.axis_accuracy * anim.difficultyBasedAccuracy;
		}
	}
	else
		wait (self.anim_missTime/40); // conserve bullets while we cant hit
	/*
	waitTime = (timer + self.anim_missTime/40) - gettime();
	if (waitTime > 0)
		wait (waitTime); // wait for half the misstime then shoot
	*/
}

waitTimeIfPlayerIsHit()
{
	waittime = 0;
	waittillframeend;
	if (!isalive(self.enemy))
		return waittime;
		
	if (self.enemy != level.player)
		return waittime;

	if (flag("player_is_invulnerable") && !self.anim_nonstopFire)
		waittime = (0.3 + randomfloat(0.4));
	return waittime;
}

resetAccuracyBolt()
{
//	self.anim_nonstopFire = randomint(3) == 1;
	self.anim_nonstopFire = false;

	if (!isalive(self.enemy))
		return;
		
	if (self.enemy != level.player)
	{
		self.accuracy = self.baseaccuracy;
		return;
	}
		
	if (self.anim_missTimeDebounce > gettime())
	{
		resetMissDebounceTime();
		return;
	}
	
	resetMissDebounceTime();
	self.accuracy = anim.baseAccuracyBolt * self.baseAccuracy * level.axis_accuracy * anim.difficultyBasedAccuracy;
}

resetAccuracyAuto()
{
//	self.anim_nonstopFire = randomint(3) == 1;
	self.anim_nonstopFire = false;

	if (!isalive(self.enemy))
		return;
	if (self.enemy != level.player)
	{
		self.accuracy = self.baseAccuracy;
		return;		
	}

	dist = distance(self.enemy.origin, self.origin);
	[[anim.misstime]](dist);
}

resetMissDebounceTime()
{
	self.anim_missTimeDebounce = gettime() + 3000;
}

setMissTime(timer)
{
	self.anim_missTime = 0;
	if (self.team != "axis")
		return;
	if (self.anim_missTimeDebounce > gettime())
	{
		resetMissDebounceTime();
		return;
	}
	resetMissDebounceTime();
	self.accuracy = 0;
	self.anim_missTime = timer * 20;
	if (self.anim_missTime < 1)
		self.anim_missTime = 1;
}


resetAccuracy()
{
	setMissTime((200 + randomfloat(100)) * 0.01);
}

playerHurtcheck()
{
	self.hurtAgain = false;
	for (;;)
	{
		self waittill ("damage");
		self.hurtAgain = true;
	}
}

boltCheck()
{
	// on hard, kar98s dont do quite enough damage to put you into red flashing, so we bias it a bit)
	self endon ("death");
	maxhealth = self.health;
	for (;;)
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, cause );
		if (cause != "MOD_RIFLE_BULLET")
			continue;
		
		ratio = self.health / maxHealth;
		if (ratio > level.healthOverlayCutoff)
			self setnormalhealth (level.healthOverlayCutoff - 0.005);
	}
}

playerHealthRegen()
{
	// sarah - readd when SP is using code-driven low health overlay
	//if ( getcvarfloat( "hud_healthOverlay_pulseStart" ) == 0 )
	//	setcvar( "hud_healthOverlay_pulseStart", 0.35 );
	//level.healthOverlayCutoff = getcvarfloat( "hud_healthOverlay_pulseStart" );	


	thread healthOverlay();
	maxhealth = level.player.health;
	level.player_maxhealth = level.player.health;
	oldhealth = maxhealth;
	player = level.player;
	health_add = 0;
	
	/*
	if (level.xenon)
		regenRate = 0.01; // 0.017;
	else
	*/
	regenRate = 0.1; // 0.017;
//	regenRate = 0.01; // 0.017;
	veryHurt = false;
	playerJustGotRedFlashing = false;
	
	level.hurtTime = -10000;
	thread playerBreathingSound(maxhealth * 0.35);
	invulTime = level.invulTime_full; // 1
	hurtTime = 0;
	newHealth = 0;
	lastinvulhealth = maxhealth;
	player thread playerHurtcheck();
	
	player.boltHit = false;
	if (level.gameSkill == 2)
		player thread boltCheck();
	
	for (;;)
	{
		wait (0.05);
		waittillframeend; // if we're on hard, we need to wait until the bolt damage check before we decide what to do
		if (player.health == maxhealth)
		{
			if (flag("player_has_red_flashing_overlay"))
			{
				flag_clear("player_has_red_flashing_overlay");
				level notify ("take_cover_done");
//				level notify ("hit_again"); was cutting off the overlay fadeout
			}
			
			lastinvulhealth = maxhealth;
			playerJustGotRedFlashing = false;
			veryHurt = false;
			continue;
		}
					
		if (player.health <= 0)
			return;

		wasVeryHurt = veryHurt;
		ratio = player.health / maxHealth;
		if (ratio <= level.healthOverlayCutoff)
		{
			veryHurt = true;
			if (!wasVeryHurt)
			{
				hurtTime = gettime();
				level.hurtTime = hurtTime;
				thread blurView(3, 2);

				flag_set("player_has_red_flashing_overlay");
				playerJustGotRedFlashing = true;
			}
		}
			
		/*
		if (!wasVeryHurt && veryHurt)
			nearAIRushesPlayer();
		*/
		if (player.hurtAgain)
		{
			hurtTime = gettime();
			player.hurtAgain = false;
		}

		if (player.health >= oldhealth)
		{
			if (gettime() - hurttime < level.playerHealth_RegularRegenDelay)
				continue;

			if (veryHurt)
			{
				newHealth = ratio;
				if (gettime() > hurtTime + level.longRegenTime)
					newHealth += regenRate;
			}
			else
				newHealth = 1;
							
			if (newHealth > 1.0)
				newHealth = 1.0;
				
			if (newHealth <= 0)
			{
				// Player is dead
				return;
			}
			
			player setnormalhealth (newHealth);
			oldhealth = player.health;
			continue;
		}

		oldratio = lastinvulhealth / maxhealth;
		invulWorthyHealthDrop = oldratio - ratio > level.worthyDamageRatio;
		oldhealth = player.health;
		level notify ("hit_again");
			
		health_add = 0;
		hurtTime = gettime();
		level.hurtTime = hurtTime;
		thread blurView(2.5, 0.8);

		if (!invulWorthyHealthDrop)
			continue;
		if (flag("player_is_invulnerable"))
			continue;
		flag_set("player_is_invulnerable");
		
		if (playerJustGotRedFlashing)
		{
			invulTime = level.invulTime_full;
			playerJustGotRedFlashing = false;
		}
		else
			invulTime = level.invulTime_short;
		lastinvulhealth = player.health;
		thread invulEnd(invulTime);
	}	
}

invulEnd(timer)
{
	wait (timer);
	flag_clear("player_is_invulnerable");

}



grenadeAwareness()
{
	if (self.team == "allies")
	{
		self.grenadeawareness  = 0.9;
		return;
	}
		
	if (self.team == "axis")
	{
		if (level.gameSkill >= 2)
		{
			// hard and fu
			if (randomint(100) < 33)
				self.grenadeawareness = 0.2;
			else
				self.grenadeawareness = 0.5;
		}
		else
		{
			// normal
			if (randomint(100) < 33)
				self.grenadeawareness = 0;
			else
				self.grenadeawareness = 0.2;
		}
	}
}

blurView(blur, timer)
{
	level notify ("blurview_stop");
	level endon ("blurview_stop");
	setblur(blur, 0);
	wait (0.05);
	setblur(0, timer);
}
	
playerBreathingSound(healthcap)
{
	wait (2);
	player = level.player;
	maxHealth = level.player.health;
	for (;;)
	{
		wait (0.2);
		if (player.health <= 0)
			return;
			
		// Player still has a lot of health so no breathing sound
		ratio = player.health / maxHealth;
		if (ratio > level.healthOverlayCutoff)
			continue;
			
		level.player playSoundOnEntity("breathing_hurt");
		wait (0.1 + randomfloat (0.8));
	}
}

healthOverlay()
{
	level.player endon ("noHealthOverlay");
	
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ("overlay_low_health", 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

	wait (0.05); // to give a chance for moscow to init level.strings so it doesnt clear ours
	level.strings["take_cover"] 				= spawnstruct();
	level.strings["take_cover"].text			= &"GAME_GET_TO_COVER";

	thread healthOverlay_remove(overlay);
	maxHealth = level.player.health;
	pulseTime = 0.8;
	for (;;)
	{
		overlay fadeOverTime(0.5);
		overlay.alpha = 0;
		flag_wait("player_has_red_flashing_overlay");
		redFlashingOverlay(overlay);
	}
}


create_warning_elem (ender)
{
	level.hudelm_unpause_ender = ender;
	level notify("hud_elem_interupt");
	hudelem = newHudElem();
	hudelem add_hudelm_position_internal();
	hudelem thread destroy_warning_elem();
	hudelem setText (&"GAME_GET_TO_COVER");
	hudelem.fontscale = 2;
	hudelem.alpha = 1;
	hudelem.color = (1, 0.9, 0.9);

	return hudelem;
}

playerWasHitAgain()
{
	level endon ("hit_again");
	level.player waittill ("damage");
}


destroy_warning_elem()
{	
	playerWasHitAgain();
	self notify ("death");
	self destroy();
}


fontScaler(scale, timer)
{
	scale *=2;
	self endon ("death");
	dif = scale - self.fontscale;
	dif /= timer*20;
	for (i=0;i<timer*20;i++)
	{
		self.fontscale+=dif;
		wait (0.05);
	}
}

fadeFunc(overlay, coverWarning, mult, hud_scaleOnly)
{
	drawWarning = isdefined(coverWarning);
	pulseTime = 0.8;
	min = 0.0;
	scaleMin = 0.5;
	
	
	overlay fadeOverTime(0.1);
	overlay.alpha = mult * 1.0;
	if (drawWarning)
	{
		if (!hud_scaleOnly)
		{
			coverWarning fadeOverTime(0.1);
			coverWarning.alpha = mult * 1.0;
		}
		coverWarning thread fontScaler(1.0, 0.1);
		
		if (coverWarning.alpha < min)
			coverWarning.alpha = min;
	}
	wait (0.15);
	
	overlay fadeOverTime(pulseTime*0.2);
	overlay.alpha = mult * 0.85;
	if (drawWarning)
	{
		if (!hud_scaleOnly)
		{
			coverWarning fadeOverTime(pulseTime*0.2);
			coverWarning.alpha = mult * 0.85;
		}
		coverWarning thread fontScaler(0.95, pulseTime*0.2);

		if (coverWarning.alpha < min)
			coverWarning.alpha = min;
	}
	wait (pulseTime*0.2);
	
	overlay fadeOverTime(pulseTime*0.3);
	overlay.alpha = mult * 0.6;
	if (drawWarning)
	{
		if (!hud_scaleOnly)
		{
			coverWarning fadeOverTime(pulseTime*0.3);
			coverWarning.alpha = mult * 0.6;
		}
		
		coverWarning thread fontScaler(0.9, pulseTime*0.3);
		if (coverWarning.alpha < min)
			coverWarning.alpha = min;
	}
	wait (pulseTime*0.3);

	wait (pulseTime*0.5) - 0.15;
}


//&"GAME_GET_TO_COVER";
redFlashingOverlay(overlay)
{
	level endon ("hit_again");
	level.player endon ("damage");

	drawWarning = false;
	coverWarning = undefined;

	takeCoverWarnings = getcvarint( "takeCoverWarnings" );
	if ( takeCoverWarnings > 5 && level.gameskill < 3 )
	{
		// get to cover!
		coverWarning = create_warning_elem("take_cover_done");
		drawWarning = true;
	}

	// red flashing lasts longer on easy
	if (level.gameSkill == 0)
	{
		fadeFunc (overlay, coverWarning, 1, false);
		fadeFunc (overlay, coverWarning, 1, false);
	}

	fadeFunc (overlay, coverWarning, 1, false);
	fadeFunc (overlay, coverWarning, 1, false);
	fadeFunc (overlay, coverWarning, 1, false);
	fadeFunc (overlay, coverWarning, 0.8, false);
	
	if (drawWarning)
	{
		coverWarning fadeOverTime(0.5);
		coverWarning.alpha = 0;
	}
	fadeFunc (overlay, coverWarning, 0.6, true);
//	fadeFunc (overlay, coverWarning, 0.3);

	overlay fadeOverTime(0.5);
	overlay.alpha = 0;
	
	if (getcvarint("takeCoverWarnings") > 2)
	{
		if (isalive(level.player))
		{
			takeCoverWarnings = getcvarint( "takeCoverWarnings" );
			takeCoverWarnings--;
			setcvar( "takeCoverWarnings", takeCoverWarnings);
		}
	}
		
	flag_clear("player_has_red_flashing_overlay");
	level.player thread playSoundOnEntity("breathing_better");


	wait (0.5); // for fade out
	level notify ("take_cover_done");
	level notify ("hit_again");
}

healthOverlay_remove(overlay)
{
	level.player waittill ("noHealthOverlay");
	overlay destroy();
}

resetSkill()
{
	setskill(true);
}

setTakeCoverWarnings()
{
	// generates "Get to Cover" x number of times when you first get hurt
	if ( getcvarint( "takeCoverWarnings" ) == -1 ) // dvar defaults to -1
	{
 		if (level.script != "moscow")
			setcvar( "takeCoverWarnings", 5 );
		else
			setcvar( "takeCoverWarnings", 10 );
	}
}

increment_take_cover_warnings_on_death()
{
	level notify ("new_cover_on_death_thread");	
	level endon ("new_cover_on_death_thread");	
	level.player waittill ("death");
	
	// dont increment if player died to grenades, explosion, etc
	if (!flag("player_has_red_flashing_overlay"))
		return;
		
	warnings = getcvarint("takeCoverWarnings");
	if (warnings < 10)
		setcvar( "takeCoverWarnings", warnings + 1 );
}


