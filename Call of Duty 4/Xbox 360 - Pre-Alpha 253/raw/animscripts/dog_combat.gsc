#include common_scripts\utility;

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
	
	//self OrientMode("face enemy");
	//self clearanim(%root, 0.1);
	//self setanim(%german_shepherd_attackidle, 1, 0.2, 1);	
}

killplayer()
{
	level.player.specialDeath = true;
	level.player setcandamage( true );

	if ( isdefined( level.player_view ) ) 
	{
		tagPos = level.player_view gettagorigin( "tag_torso" );	// rough tag to play fx on
		playfx( level._effect["dog_bite_blood"], tagPos + (0, 0, 20), anglestoforward( level.player.angles ), anglestoup( level.player.angles ) );
	}

	wait 1;
	level.player enableHealthShield( false );
	
	damage = 10 * level.player.health / getdvarfloat("player_DamageMultiplier");
	
	level.player dodamage( damage, level.player.origin ); // set damage position to player origin to avoid knockback
	level.player shellshock("default", 5);
}


handleMeleeBiteAttackNoteTracks( note )
{
	switch ( note )
	{
		case "dog_melee":
			hitEnt = self melee( anglesToForward( self.angles ) );
			if ( isdefined( hitEnt ) )
			{
				if ( hitEnt == level.player )
				{
					/#
					if ( isgodmode( level.player ) )
					{
						println("Player in god mode, aborting dog attack");
						break;
					}
					#/
					
					if ( level.player_view PlayerView_StartSequence( self ) )
						self setcandamage( false );
					break;
				}
			}
			else
			{
				self clearanim(%root, 0.1);
				self setflaggedanimrestart("miss_anim", %german_shepherd_attack_player_miss, 1, 0, 1);					
				self animscripts\shared::DoNoteTracks( "miss_anim" );
				return true;
			}
			break;
			
		case "dogbite_damage":
			/#
			if ( isgodmode( level.player ) )
				break;
			#/
		
			self thread killplayer();
			break;
			
		case "stop_tracking":
			self OrientMode("face current" );
			break;
	}
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

		if ( self.enemy == level.player )
			prepareAttackPlayer();

		self clearanim(%root, 0.1);
		self setflaggedanimrestart("meleeanim", %german_shepherd_attack_player, 1, 0.2, 1);
		self animscripts\shared::DoNoteTracks( "meleeanim", ::handleMeleeBiteAttackNoteTracks );
		
		self setcandamage( true );
		self unlink();
		
		self.safeToChangeScript = true;

		if ( checkEndCombat( meleeRange ) )
			break;
	}
	
	self animMode("none");
}


meleeStruggleVsAI()
{
	if ( !isalive( self.enemy ) )
		return;
	
	if ( isdefined( self.enemy.syncedMeleeTarget ) )
	{
		combatIdle();
		return;
	}

	self.safeToChangeScript = false;
	self animMode( "zonly_physics" );
	self.pushable = false;

	self.meleeKillTarget = !isdefined( self.enemy.magic_bullet_shield ) && randomint(100) > 50;	// make this a AI field instead of random

	meleeSeqAnims = [];
	meleeSeqAnim[0] = %root;
	meleeSeqAnim[1] = %german_shepherd_attack_AI_01_start_a;
	meleeSeqAnim[2] = %german_shepherd_attack_AI_02_idle_a;
	if ( self.meleeKillTarget )
	{
		meleeSeqAnim[3] = %german_shepherd_attack_AI_03_pushed_a;
		meleeSeqAnim[4] = %german_shepherd_attack_AI_04_middle_a;
		meleeSeqAnim[5] = %german_shepherd_attack_AI_05_kill_a;
		numMeleeStage = 5;
	}
	else
	{
		meleeSeqAnim[3] = %german_shepherd_attack_AI_03_shot_a;
		numMeleeStage = 3;
	}

	angles = vectorToAngles( self.origin - self.enemy.origin );

	self clearanim( meleeSeqAnim[0], 0.1 );
	self animrelative( "meleeanim", self.enemy.origin, angles, meleeSeqAnim[1] );
	self animscripts\shared::DoNoteTracks("meleeanim", ::handleStartAIPart);
	
	self animMode( "zonly_physics" );
	
	for ( meleeSeq = 1; meleeSeq < numMeleeStage; meleeSeq++ )
	{
		self clearanim( meleeSeqAnim[meleeSeq], 0 );
		
		// get ready to die
		if ( self.meleeKillTarget && meleeSeq + 1 == numMeleeStage )
			self.health = 1;

		self setflaggedanimrestart("meleeanim", meleeSeqAnim[meleeSeq + 1], 1, 0, 1);
		self animscripts\shared::DoNoteTracks( "meleeanim" );
	}
	
	self unlink();
	self.pushable = true;
	self.safeToChangeScript = true;
}

combatIdle()
{
	self OrientMode("face enemy");
	self clearanim(%root, 0.1);
	
	idleAnim = [];
	idleAnim[0] = %german_shepherd_attackidle;
	idleAnim[1] = %german_shepherd_attackidle_bark;
	idleAnim[2] = %german_shepherd_attackidle_growl;
	
	randomVal = randomint(3);
			
	self setflaggedanimrestart("combat_idle", idleAnim[randomVal], 1, 0.2, 1);		
	self animscripts\shared::DoNoteTracks( "combat_idle" );
}

handleStartAIPart( note )
{
	if ( note != "ai_attack_start" )
		return false;

	if ( isdefined( self.enemy.syncedMeleeTarget ) )
		return true;
		
	//self.enemy thread draw_tag( "tag_sync" );

	self.enemy.syncedMeleeTarget = self;
	self.enemy animcustom(::meleeStruggleVsDog);
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
	if ( !isdefined( level.player_view ) ) 
		level.player_view = PlayerView_Spawn();

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



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
#using_animtree ("generic_human");

meleeStruggleVsDog()
{
	self endon( "killanimscript" );
	self endon( "death" );
	self endon( "end_melee_struggle" );
	self endon( "end_melee_all" );
	
	if ( !isdefined( self.syncedMeleeTarget ) )
		return;
		
	//self.syncedMeleeTarget = self;
	
	self OrientMode("face point", self.syncedMeleeTarget.origin, 1);
	self animMode( "gravity" );
	
	meleeSeqAnim = [];
	meleeSeqAnim[0] = %root;
	meleeSeqAnim[1] = %AI_attacked_german_shepherd_01_start_a;
	meleeSeqAnim[2] = %AI_attacked_german_shepherd_02_idle_a;
	if ( self.syncedMeleeTarget.meleeKillTarget )
	{
		meleeSeqAnim[3] = %AI_attacked_german_shepherd_03_push_a;
		meleeSeqAnim[4] = %AI_attacked_german_shepherd_04_middle_a;
		meleeSeqAnim[5] = %AI_attacked_german_shepherd_05_death_a;
		numMeleeStage = 5;
	}
	else
	{
		meleeSeqAnim[3] = %AI_attacked_german_shepherd_03_shoot_a;
		numMeleeStage = 3;
	}
	
	self.meleeSeq = 0;

	self thread meleeStruggleVsDog_interruptdCheck();
	
	self clearanim( meleeSeqAnim[0], 0.1 );
	
	// this needs to happen here and not when the dog starts, because "tag_sync" won't be correct at that point
	self.syncedMeleeTarget linkto( self, "tag_sync", (0,0,0), (0,0,0) );

	self setflaggedanimrestart( "aianim", meleeSeqAnim[1], 1, 0.1, 1 );
	self waittillmatch( "aianim", "end" );

	for ( self.meleeSeq = 1; self.meleeSeq < numMeleeStage;  )
	{
		self clearanim( meleeSeqAnim[self.meleeSeq], 0 );
		
		self.meleeSeq++;
		self setflaggedanimrestart( "aianim", meleeSeqAnim[self.meleeSeq], 1, 0, 1 );
		self animscripts\shared::DoNoteTracks( "aianim" );
		
		// hack to let %AI_attacked_german_shepherd_03_push_a play to end when interrupted
		if ( !isdefined( self.syncedMeleeTarget ) || !isAlive( self.syncedMeleeTarget ) )	
		{
			if ( self.meleeSeq == 3 && numMeleeStage == 5 )
			{
				meleeSeqAnim[4] = %AI_attacked_german_shepherd_04_getup_a;
				numMeleeStage = 4;
			}
		}
		
		if ( self.meleeSeq == 5 )
		{	
			if ( !isdefined( self.magic_bullet_shield ) )
			{
				self.a.nodeath = true;
				self dodamage( self.health * 10, (0, 0, 0) );
			}
		}
	}
	
	meleeStruggleVsDog_End();
}


// check for premature termination from dog being shot by another AI or player
meleeStruggleVsDog_interruptdCheck()
{
	self endon( "killanimscript" );
	self endon( "death" );
	self endon( "end_melee_all" );

	meleeSeqAnim = [];
	meleeSeqAnim[1] = %AI_attacked_german_shepherd_02_getup_a;
	meleeSeqAnim[2] = %AI_attacked_german_shepherd_02_getup_a;

	if ( self.syncedMeleeTarget.meleeKillTarget )
	{
		// meleeSeqAnim[3] = %AI_attacked_german_shepherd_04_getup_a;	// handle this in meleeStruggleVsDog()
		meleeSeqAnim[4] = %AI_attacked_german_shepherd_04_getup_a;
	}

	while ( 1 )
	{
		if ( !isdefined( self.syncedMeleeTarget ) || !isAlive( self.syncedMeleeTarget ) )
			break;
			
		wait 0.1;
	}

	if ( self.meleeSeq > 0 ) 
	{
		if ( !isdefined( meleeSeqAnim[self.meleeSeq] ) )
			return;	// don't call meleeStruggleVsDog_End()

		self clearanim( %melee_dog, 0.1 );
		self setflaggedanimrestart( "getupanim", meleeSeqAnim[self.meleeSeq], 1, 0.1, 1 );
		self animscripts\shared::DoNoteTracks( "getupanim" );
	}
	
	meleeStruggleVsDog_End();
}


// this should kill both meleeStruggleVsDog() and meleeStruggleVsDog_endCheck() threads
meleeStruggleVsDog_End()
{
	self orientmode("face default");
	self.syncedMeleeTarget = undefined;
	self.meleeSeq = undefined;
	
	self notify( "end_melee_all" );
}


//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
#using_animtree( "player" );

PlayerView_Precache()
{
	precacheModel( "viewhands_player_usmc" );

	level._effect["dog_bite_blood"] = loadfx ("impacts/flesh_hit_body_fatal_exit");
}


PlayerView_Spawn()
{
	playerView = spawn( "script_model", level.player.origin );
	playerView.angles = level.player.angles;
	playerView setModel( "viewhands_player_usmc" );
	playerView useAnimTree( #animtree );
	playerView hide();
	
	return playerView;
}


PlayerView_KnockDownAnim()
{
	self setflaggedanimrestart( "viewanim", %player_view_dog_knockdown );
	self animscripts\shared::DoNoteTracks( "viewanim" );

	tagPos = self gettagorigin( "tag_torso" );	// rough tag to play fx on
	forward = anglestoforward( level.player.angles );
	
	tagPos = (tagPos[0], tagPos[1], 0) + vectorScale( forward, 20 );
	playfx( level._effect["dog_bite_blood"], tagPos, forward, anglestoup( level.player.angles ) );
	
	self dontInterpolate();
	
	PlayerView_EndSequence();
}


PlayerView_StartSequence( dog )
{
	if ( isdefined( self.inSeq ) )
		return false;

	self.inSeq = true;
	
	setsaveddvar("cg_drawHUD",0);
	
	level.player setstance( "stand" );
	level.player.syncedMeleeTarget = dog;
	level.player_view PlayerView_Show();
	
	direction = dog.origin - level.player.origin;
	self.angles = vectortoangles( direction );
	self.angles = ( 0, self.angles[1], 0 );	

	if ( level.player isonground() )
	{
		self.origin = level.player.origin;
	}
	else
	{
		playerpos = level.player.origin;
		self.origin = playerphysicstrace( playerpos, (playerpos[0], playerpos[1], playerpos[2] - 200) );
	}
	
	self thread PlayerView_KnockDownAnim();
	self dontInterpolate();
	
	level.player playerLinkToAbsolute( self, "tag_player" );
	dog linkto( self, "tag_sync", (0, 0, 0), (0, 0, 0) );
	
	//self thread draw_tag( "tag_player" );
	//dog thread draw_tag( "tag_origin" );

	level.player allowLean( false );
	level.player allowCrouch( false );
	level.player allowProne( false );
	level.player freezeControls( true );
	
	level.player setcandamage( false );
	
	return true;
}


PlayerView_EndSequence()
{
	self.inSeq = undefined;
	
	if ( isalive( level.player ) )
	{
		level.player setcandamage( true );

		level.player unlink();
		level.player setOrigin( self.origin );
		level.player showViewModel();
		level.player_view delete();
	}
	else
	{
		setsaveddvar( "compass", 0 );
	}

	setsaveddvar("cg_drawHUD",1);
	level.player.syncedMeleeTarget = undefined;
	
	level.player allowLean( true );
	level.player allowCrouch( true );
	level.player allowProne( true );
	level.player freezeControls( false );
}



PlayerView_Show()
{
	self show();
	level.player hideViewModel();
}


PlayerView_Hide()
{
	self hide();
	level.player showViewModel();
}


/*draw_tag( tagname )
{
	self endon( "death" );
	
	range = 25;
	
	while (1)
	{
		angles = self gettagangles( tagname );	
		origin = self gettagorigin( tagname );
		
		forward = anglestoforward(angles);
		forward = vectorscale(forward, range);
		right = anglestoright(angles);
		right = vectorscale(right, range);
		up = anglestoup(angles);
		up = vectorscale(up, range);
		line(origin, origin + forward, (1,0,0), 1);
		line(origin, origin + up, (0,1,0), 1);
		line(origin, origin + right, (0,0,1), 1);
		wait 0.05;
	}
}
*/