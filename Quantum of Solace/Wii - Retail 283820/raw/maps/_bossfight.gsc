

boss_transition()
{
	level.boss_laststate = 1;
	self thread boss_success();
	self thread boss_fail();
	self thread boss_handledamagenote();
	self thread handleCameraShake();
	level.earthquake = self.origin;
	level.player thread fail_redflash();
}

boss_success()
{
	for(;;)
	{
		level.player waittill("interaction_pass");
		level.boss_laststate = 1;
	}
}

boss_fail()
{
	for(;;)
	{
		
		level.player waittill("interaction_fail");
		level.boss_laststate = 0;
	}
}

boss_handledamagenote()
{
	for(;;)
	{
		self waittillmatch( "anim_notetrack", "damage");
		if (level.boss_laststate == 0)
		{
			
			level.player dodamage(45, (0,0,0));
			setblur( 15, 0.3);
			earthquake(1.25, 0.25, self.origin, 7550);
			wait(0.3);
			setblur( 0, 0.2);
		}
		else
		{
			
			level.player PlayRumbleOnEntity( "damage_light" );
		}			
	}
}

handleCameraShake()
{
	self thread handlelightShake();
	self thread handleheavyShake();
}

handlelightShake()
{
	for(;;)
	{
		self waittillmatch( "anim_notetrack", "shake_light");
		earthquake(0.25, 0.25, level.earthquake, 7550);
		level.player PlayRumbleOnEntity("melee_attack_miss");
	}
}

handleheavyShake()
{
	for(;;)
	{
		self waittillmatch( "anim_notetrack", "shake_heavy");
		earthquake(0.55, 0.25, level.earthquake, 7550);
		level.player PlayRumbleOnEntity("qk_hit");
	}
}

fail_redflash()
{
	
	for(;;)
	{
		self waittill("interaction_fail");
		setblur( 15, 0.3);
		earthquake(2.25, 0.25, level.earthquake, 7550);
		VisionSetSecondary(0.7, "boss_fail");
		wait(0.05);
		
		VisionSetSecondary(0.6);
		wait(0.05);
		VisionSetSecondary(0.5);
		wait(0.05);
		VisionSetSecondary(0.4);
		wait(0.05);
		VisionSetSecondary(0.3);
		wait(0.05);
		VisionSetSecondary(0.2);
		wait(0.05);
		VisionSetSecondary(0);
		
		
		setblur( 0, 0.2);
		
	}
}
