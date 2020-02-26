#using_animtree ("dog");

main()
{
	self endon("killanimscript");

	assert( isdefined( self.enemy ) );
	if ( !isalive( self.enemy ) )
		return;

	if ( self.enemy == level.player )
		self meleeBiteAttack();
	else
		self meleeStruggleVsAI();
	
	self OrientMode("face enemy");
	self clearanim(%root, 0.1);
	self setanim(%german_shepherd_idle, 1, 0.2, 1);	
}


meleeBiteAttack()
{
	self.safeToChangeScript = false;

	attackRangeBuffer = 30;
	meleeRange = self.meleeAttackDist + attackRangeBuffer;

	for ( ;; )	
	{
		if ( !isalive( self.enemy ) )
			break;

		self OrientMode("face enemy");
		self animMode( "gravity" );
		//self animMode( "zonly_physics" );

		self clearanim(%root, 0.1);
		//self setflaggedanimknoballrestart("meleeanim", %german_shepherd_run, %body, 1, 0.2, 1);
		self setflaggedanimrestart("meleeanim", %german_shepherd_run_attack, 1, 0.2, 1);

		if ( self.enemy == level.player )
			prepareAttackPlayer();

		while ( 1 )
		{
			self waittill("meleeanim", note);
			if ( note == "end" )
			{
				break;
			}
			else if ( note == "fire" )
			{
				hitEnt = self melee();
				if ( isdefined( hitEnt ) )
				{
					if ( hitEnt == level.player )
						hitEnt shellshock("dog_bite", 1);
				}
				else
				{
					self clearanim(%root, 0.1);
					self setflaggedanimrestart("miss_anim", %german_shepherd_run_attack_miss, 1, 0, 1);					
					self waittill("miss_anim", end);
					break;
				}
			}
			else if ( note == "stop" )
			{
				break;
			}
		}
		
		self.safeToChangeScript = true;

		if ( checkEndCombat( meleeRange ) )
			break;
			
		/*self OrientMode("face enemy");
		self clearanim(%root, 0.1);
		self setanim(%german_shepherd_idle, 1, 0.2, 1);
		wait randomfloat( 1 );*/			
	}
	
	self animMode("none");
}


meleeStruggleVsAI()
{
	self.safeToChangeScript = false;
	
	if ( !isalive( self.enemy ) || isdefined( self.enemy.attacker ) )
		return;

	self animMode( "nogravity" );
	//self animMode( "zonly_physics" );
	
	angles = vectorToAngles( self.origin - self.enemy.origin );

	self OrientMode("face angle", angles[1] + 180);
	
	offset = getstartorigin( self.enemy.origin, angles, %german_shepherd_attack_AI_01_start_a );
	self thread attackTeleportThread( offset );

	self clearanim(%root, 0.1);
	self setflaggedanimrestart("meleeanim", %german_shepherd_attack_AI_01_start_a, 1, 0.2, 1);
	
	self animscripts\shared::DoNoteTracks("meleeanim", ::handleStartAIPart);
	
	//self waittillmatch( "meleeanim", "ai_attack_start" );
	//self.enemy meleeStruggleHumanPart( self );
			
	//self waittillmatch( "meleeanim", "end" );
	
	self clearanim(%german_shepherd_attack_AI_01_start_a, 0);
	self setflaggedanimrestart("meleeanim", %german_shepherd_attack_AI_02_idle_a, 1, 0, 1);
	self waittillmatch( "meleeanim", "end" );
	
	self clearanim(%german_shepherd_attack_AI_02_idle_a, 0);
	self setflaggedanimrestart("meleeanim", %german_shepherd_attack_AI_03_pushed_a, 1, 0, 1);
	self waittillmatch( "meleeanim", "end" );
	
	self clearanim(%german_shepherd_attack_AI_03_pushed_a, 0);
	self setflaggedanimrestart("meleeanim", %german_shepherd_attack_AI_04_middle_a, 1, 0, 1);
	self waittillmatch( "meleeanim", "end" );

	self clearanim(%german_shepherd_attack_AI_04_middle_a, 0);
	self setflaggedanimrestart("meleeanim", %german_shepherd_attack_AI_05_kill_a, 1, 0, 1);
	self waittillmatch( "meleeanim", "end" );
	
	self.safeToChangeScript = true;
}

handleStartAIPart( note )
{
	if ( note != "ai_attack_start" )
		return false;

	self.enemy.attacker = self;
	self.enemy animcustom(animscripts\melee::meleeStruggleVsDog);
}

checkEndCombat( meleeRange )
{
	if ( !isdefined( self.enemy ) )
		return false;
		
	distToTargetSq = distanceSquared( self.origin, self.enemy.origin );
	
	return ( distToTargetSq > meleeRange * meleeRange );
}

prepareAttackPlayer()
{
	distanceToTarget = distance( self.origin, self.enemy.origin );
	
	if ( distanceToTarget > self.meleeAttackDist )
	{
		offset = self.enemy.origin - self.origin;

		length = ( distanceToTarget - self.meleeAttackDist ) / distanceToTarget;
		offset = ( offset[0] * length, offset[1] * length, offset[2] * length );
		
		self thread attackTeleportThread( offset );
	}
}

// make up for error in intial attack jump position
attackTeleportThread( offset )
{
	self endon ("death");
	self endon ("killanimscript");
	reps = 5;
	increment = ( offset[0] / reps, offset[1] / reps, offset[2] / reps );
	for ( i = 0; i < reps; i++ )
	{
		self teleport (self.origin + increment);
		wait (0.05);
	}
}