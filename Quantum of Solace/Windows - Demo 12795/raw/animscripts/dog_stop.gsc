#using_animtree ("dog");

main()
{
	self endon("killanimscript");
	
	self clearanim(%root, 0.2);
	self clearanim(%german_shepherd_idle, 0);
	self clearanim(%german_shepherd_attackidle_knob, 0);

	while (1)
	{
		if ( shouldAttackIdle() )
		{
			self clearanim(%german_shepherd_idle, 0.1);
			self randomAttackIdle();
		}
		else
		{
			self orientmode( "face current" );
			self clearanim(%german_shepherd_attackidle_knob, 0);
			self setflaggedanimrestart("dog_idle", %german_shepherd_idle, 1, 0.2, 1);
		}

		animscripts\shared::DoNoteTracks("dog_idle");
	}
}


randomAttackIdle()
{
	self orientmode("face enemy");
	self clearanim(%german_shepherd_attackidle_knob, 0.1);
	
	rand = randomInt( 100 );
	if ( rand < 33 )
		self setflaggedanimrestart( "dog_idle", %german_shepherd_attackidle, 1, 0.2, 1 );
	else if ( rand < 66 )
		self setflaggedanimrestart( "dog_idle", %german_shepherd_attackidle_bark, 1, 0.2, 1 );
	else
		self setflaggedanimrestart( "dog_idle", %german_shepherd_attackidle_growl, 1, 0.2, 1 );
}

shouldAttackIdle()
{
	return ( isdefined( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) < 1000000 );
}