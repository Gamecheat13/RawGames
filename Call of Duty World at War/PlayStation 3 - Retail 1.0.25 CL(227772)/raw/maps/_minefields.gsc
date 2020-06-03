main()
{
	minefields = getentarray ("minefield", "targetname");
	if (minefields.size > 0)
	{
		level._effect["mine_explosion"] = loadfx ("explosions/grenadeExp_dirt");
	}

	for (i=0;i<minefields.size;i++)
	{
		minefields[i] thread minefield_think();
	}
}

minefield_think()
{
	while (1)
	{
		self waittill ("trigger",other);

		if(isSentient(other))
			other thread minefield_kill(self);
	}
}

minefield_kill(trigger)
{
	if(isDefined(self.minefield))
		return;

	self.minefield = true;
	self playsound ("minefield_click");

	wait(.5);
	wait(randomFloat(.2));
	
	if (!(isdefined(self)))
		return;

	if(self istouching(trigger))
	{
		// SCRIPTER_MOD
		// JesseS (3/14/2007): Changed from check against level.player to classname player.
		if (isplayer(self))
		{
			level notify ("mine death");
			self playsound ("explo_mine");
		}
		else
			level thread maps\_utility::play_sound_in_space("explo_mine",self.origin);
		
		origin = self getorigin();
		range = 300;
		maxdamage = 2000;
		mindamage = 50;
		
		playfx ( level._effect["mine_explosion"], origin);
		playsoundatposition("mortar_dirt", origin);
		// SCRIPTER_MOD
		// JesseS (3/14/2007): changed level.player to self, they've assumed only the player can activate a minefield
		self enableHealthShield( false );
		radiusDamage(origin, range, maxdamage, mindamage);
		
		// SCRIPTER_MOD
		// JesseS (3/14/2007): changed level.player to self, they've assumed only the player can activate a minefield
		self enableHealthShield( true );

		// SCRIPTER_MOD
		// JesseS (3/14/2007): Changed from check against level.player to classname player.
		// SCRIPTER_MOD
		// JesseS (3/14/2007): Took this out because we dont want to end the game if one player dies.
		//if(isplayer(self))
		//{
			//setdvar("ui_deadquote", "@MINEFIELDS_MINEDIED");
			//maps\_utility::missionFailedWrapper();
		//}
	}

	self.minefield = undefined;
}
