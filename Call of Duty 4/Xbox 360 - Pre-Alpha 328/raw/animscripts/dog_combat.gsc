#include common_scripts\utility;
#include maps\_utility;

#using_animtree( "dog" );

main()
{
	self endon( "killanimscript" );

	assert( isdefined( self.enemy ) );
	if ( !isalive( self.enemy ) )
	{
		self clearanim( %root, 0.2 );
		self setflaggedanimrestart( "dog_idle", %german_shepherd_idle, 1, 0.2, 1 );		
		self animscripts\shared::DoNoteTracks( "dog_idle" );
		return;
	}

	if ( self.enemy == level.player )
		self meleeBiteAttackPlayer();
	else
		self meleeStruggleVsAI();
}

killplayer()
{
	self endon( "pvd_melee_interrupted" );
	
	level.player.specialDeath = true;
	level.player setcandamage( true );

	if ( isdefined( level.player_view ) ) 
	{
		tagPos = level.player_view gettagorigin( "tag_torso" );	// rough tag to play fx on
		playfx( level._effect[ "dog_bite_blood" ], tagPos + ( 0, 0, 20 ), anglestoforward( level.player.angles ), anglestoup( level.player.angles ) );
	}

	wait 1;
	level.player enableHealthShield( false );
	
	damage = 10 * level.player.health / getdvarfloat( "player_DamageMultiplier" );
	
	level.player dodamage( damage, level.player.origin );// set damage position to player origin to avoid knockback
	level.player shellshock( "default", 5 );
}


attackMiss()
{
	self clearanim(%root, 0.1);
	
	if ( isdefined( self.enemy ) )
	{
		forward	= anglestoforward( self.angles );
		dirToEnemy = self.enemy.origin - ( self.origin + vectorscale( forward, 50 ) );
		if ( vectordot( dirToEnemy, forward ) > 0 )
			self setflaggedanimrestart( "miss_anim", %german_shepherd_attack_player_miss, 1, 0, 1 );
		else 
		{
			self.skipStartMove = true;
			self thread attackMissTrackTargetThread();
			
			if ( ( dirToEnemy[0] * forward[1] - dirToEnemy[1] * forward[0] ) > 0 )
				self setflaggedanimrestart( "miss_anim", %german_shepherd_attack_player_miss_turnR, 1, 0, 1 );
			else
				self setflaggedanimrestart( "miss_anim", %german_shepherd_attack_player_miss_turnL, 1, 0, 1 );
		}
	}
	else
	{
		self setflaggedanimrestart( "miss_anim", %german_shepherd_attack_player_miss, 1, 0, 1 );
	}

	self animscripts\shared::DoNoteTracks( "miss_anim" );
}


attackMissTrackTargetThread()
{
	self endon( "killanimscript" );

	wait 0.7;
	self OrientMode( "face enemy" );
}


handleMeleeBiteAttackNoteTracks( note )
{
	switch( note )
	{
		case "dog_melee":
		{
			hitEnt = self melee( anglesToForward( self.angles ) );

			if ( isdefined( hitEnt ) )
			{
				if ( hitEnt == level.player )
					hitEnt shellshock("dog_bite", 1);
			}
			else
			{
				attackMiss();
				return true;
			}
		}
		break;

		case "stop_tracking":
			self OrientMode( "face current" );
			break;
	}
}


handleMeleeFinishAttackNoteTracks( note )
{
	switch( note )
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
						println( "Player in god mode, aborting dog attack" );
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
				attackMiss();
				return true;
			}
			break;
			
		case "dog_early":
			self notify( "dog_early_notetrack" );

//			speed = randomfloatrange( 0.3, 1.2 );
			speed = 0.45 + 0.8 * level.dog_melee_timing_array[ level.dog_melee_index ];
//			println( "speed " + speed );
			level.dog_melee_index++;
			if ( level.dog_melee_index >= level.dog_melee_timing_array.size )
			{
				level.dog_melee_index = 0;
				// randomize the array for variety in dog attack timing
				level.dog_melee_timing_array = maps\_utility::array_randomize( level.dog_melee_timing_array );
			}

			self setflaggedanimlimited( "meleeanim", %german_shepherd_attack_player, 1, 0.2, speed );
			self setflaggedanimlimited( "meleeanim", %german_shepherd_attack_player_late, 1, 0.2, speed );
//			self setanimlimited( %attack_player, 1, 0, 1 );
//			self setanimlimited( %attack_player_late, 0, 0, 1 );

			level.player_view setflaggedanimlimited( "viewanim", get_player_view_dog_knock_down_anim(), 1, 0.2, speed );
			level.player_view setflaggedanimlimited( "viewanim", get_player_view_dog_knock_down_late_anim(), 1, 0.2, speed );
//			level.player_view setanimlimited( get_player_knockdown_knob(), 1, 0, 1 );
//			level.player_view setanimlimited( get_player_knockdown_late_knob(), 0, 0, 1 );
			break;
			
		case "dog_lunge":
			thread set_melee_timer();
			self setflaggedanim( "meleeanim", %german_shepherd_attack_player, 1, 0.2, 1 );
			self setflaggedanim( "meleeanim", %german_shepherd_attack_player, 1, 0.2, 1 );

			level.player_view setflaggedanim( "viewanim", get_player_view_dog_knock_down_anim(), 1, 0.2, 1 );
			level.player_view setflaggedanim( "viewanim", get_player_view_dog_knock_down_late_anim(), 1, 0.2, 1 );
			break;
			
		case "dogbite_damage":
			 /#
			if ( isgodmode( level.player ) )
				break;
			#/ 
		
			self thread killplayer();
			break;
			
		case "stop_tracking":
			self OrientMode( "face current" );
			break;
	}
}

handle_dogbite_notetrack( note )
{
	switch( note )
	{
		case "dogbite_damage":
			 /#
			if ( isgodmode( level.player ) )
				break;
			#/ 
		
			self thread killplayer();
			break;
	}
}

set_melee_timer()
{
	wait( 0.15 );
	self.melee_able_timer = gettime();

	/#
	if ( getdebugdvar( "dog_hint" ) == "on" )
	{
		introblack = newHudElem();
		introblack.x = 50;
		introblack.y = 50;
		introblack.horzAlign = "fullscreen";
		introblack.vertAlign = "fullscreen";
		introblack.foreground = true;
		introblack setShader("black", 100, 100 );
		wait ( 0.25 );
		introblack destroy();
	}
	#/
}


meleeBiteAttackPlayer()
{
	attackRangeBuffer = 30;
	meleeRange = self.meleeAttackDist + attackRangeBuffer;

	for ( ;; )	
	{
		if ( !isalive( self.enemy ) )
			break;
			
		if ( isdefined( level.player.syncedMeleeTarget ) && level.player.syncedMeleeTarget != self )
		{
			if ( checkEndCombat( meleeRange ) )
			{
				break;
			}
			else
			{
				combatIdle();
				continue;
			}
		}

		if ( self shouldWaitInCombatIdle() )
		{
			combatIdle();
			continue;
		}
			
		self OrientMode( "face enemy" );
		self animMode( "gravity" );

		self.safeToChangeScript = false;

		prepareAttackPlayer();

		self clearanim( %root, 0.1 );
		
/#		
		if ( getdebugdvar( "debug_dog_sound" ) != "" )
			iprintln( "dog " + (self getentnum()) + " attack player " + getTime() );

#/		
		//self thread play_sound_on_tag( "anml_dog_growl", "tag_eye" );
		
		level.player setNextDogAttackAllowTime( 500 );
		
		if ( dog_cant_kill_in_one_hit() )
		{
			self.hitsBeforeKillingBlow--;

			self setflaggedanimrestart( "meleeanim", %german_shepherd_run_attack, 1, 0.2, 1 );
			self animscripts\shared::DoNoteTracks( "meleeanim", ::handleMeleeBiteAttackNoteTracks );
		}
		else
		{
			self thread dog_melee_death();
			self setflaggedanimrestart( "meleeanim", %german_shepherd_attack_player, 1, 0.2, 1 );
			self setflaggedanimrestart( "meleeanim", %german_shepherd_attack_player_late, 1, 0, 1 );
			self setanimlimited( %attack_player, 1, 0, 1 );
			self setanimlimited( %attack_player_late, 0.01, 0, 1 );
			
			self animscripts\shared::DoNoteTracks( "meleeanim", ::handleMeleeFinishAttackNoteTracks );
//			self animscripts\shared::DoNoteTracks( "meleeanim_late", ::handle_dogbite_notetrack );
			self notify( "dog_no_longer_melee_able" );
			self setcandamage( true );
			self unlink();
		}
		
		self.safeToChangeScript = true;

		if ( checkEndCombat( meleeRange ) )
			break;
	}
	
	self.safeToChangeScript = true;
	self animMode( "none" );
}

dog_cant_kill_in_one_hit()
{
	if ( isdefined( level.player.dogs_dont_instant_kill ) )
	{
		assertex( level.player.dogs_dont_instant_kill, "Dont set level.player.dogs_dont_instant_kill to false, set to undefined" );
		return true;
	}
	
	return self.hitsBeforeKillingBlow > 0;
}


// prevent multiple dogs attacking at the same time and overlapping
shouldWaitInCombatIdle()
{
	assert( isdefined( self.enemy ) && isalive( self.enemy ) );
	
	return isdefined( self.enemy.dogAttackAllowTime ) && ( gettime() < self.enemy.dogAttackAllowTime );
}

// call on target
setNextDogAttackAllowTime( time )
{
	self.dogAttackAllowTime = gettime() + time;
}


meleeStruggleVsAI()
{
	if ( !isalive( self.enemy ) )
		return;
	
	if ( isdefined( self.enemy.syncedMeleeTarget ) || self shouldWaitInCombatIdle() )
	{
		combatIdle();
		return;
	}
	
	self.enemy setNextDogAttackAllowTime( 500 );

	self.safeToChangeScript = false;
	self animMode( "zonly_physics" );
	self.pushable = false;

	self.meleeKillTarget = !isdefined( self.enemy.magic_bullet_shield ) && randomint( 100 ) > 50;	// make this a AI field instead of random

	meleeSeqAnims = [];
	meleeSeqAnim[ 0 ] = %root;
	meleeSeqAnim[ 1 ] = %german_shepherd_attack_AI_01_start_a;
	meleeSeqAnim[ 2 ] = %german_shepherd_attack_AI_02_idle_a;
	if ( self.meleeKillTarget )
	{
		meleeSeqAnim[ 3 ] = %german_shepherd_attack_AI_03_pushed_a;
		meleeSeqAnim[ 4 ] = %german_shepherd_attack_AI_04_middle_a;
		meleeSeqAnim[ 5 ] = %german_shepherd_attack_AI_05_kill_a;
		numMeleeStage = 5;
	}
	else
	{
		meleeSeqAnim[ 3 ] = %german_shepherd_attack_AI_03_shot_a;
		numMeleeStage = 3;
	}

	angles = vectorToAngles( self.origin - self.enemy.origin );

	self.originalTarget = self.enemy;

	self setcandamage( false );
	self clearanim( meleeSeqAnim[ 0 ], 0.1 );
	self animrelative( "meleeanim", self.enemy.origin, angles, meleeSeqAnim[ 1 ] );
	self animscripts\shared::DoNoteTracks( "meleeanim", ::handleStartAIPart );

	self setcandamage( true );
	self animMode( "zonly_physics" );
	
	for ( meleeSeq = 1; meleeSeq < numMeleeStage; meleeSeq ++ )
	{
		self clearanim( meleeSeqAnim[ meleeSeq ], 0 );

		if ( !inSyncMeleeWithTarget() )
			break;
		
		// get ready to die
		if ( !self.meleeKillTarget && meleeSeq + 1 == numMeleeStage )
			self.health = 1;

		self setflaggedanimrestart( "meleeanim", meleeSeqAnim[ meleeSeq + 1 ], 1, 0, 1 );
		self animscripts\shared::DoNoteTracks( "meleeanim" );
	}
	
	self unlink();
	self.pushable = true;
	self.safeToChangeScript = true;
}

combatIdle()
{
	self OrientMode( "face enemy" );
	self clearanim( %root, 0.1 );
	self animMode( "zonly_physics" );
	
	idleAnims = [];
	idleAnims[ 0 ] = %german_shepherd_attackidle;
	idleAnims[ 1 ] = %german_shepherd_attackidle_bark;
	idleAnims[ 2 ] = %german_shepherd_attackidle_growl;
	
	idleAnim = maps\_utility::random( idleAnims );
	
	self thread combatIdlePreventOverlappingPlayer();
			
	self setflaggedanimrestart( "combat_idle", idleAnim, 1, 0.2, 1 );
	self animscripts\shared::DoNoteTracks( "combat_idle" );
	
	self notify( "combatIdleEnd" );
}


// when player is in melee sequence, other dogs need to move away
combatIdlePreventOverlappingPlayer()
{
	self endon( "killanimscript" );
	self endon( "combatIdleEnd" );
	
	while( 1 )
	{
		wait 0.1;
		
		if ( !isdefined( level.player.syncedMeleeTarget ) || level.player.syncedMeleeTarget == self )
			continue;
		
		offsetVec = level.player.origin - self.origin;
		
		if ( offsetVec[2] * offsetVec[2] > 6400 )
			continue;			
		
		offsetVec = ( offsetVec[0], offsetVec[1], 0 );
	
		offset = length( offsetVec );
		
		if ( offset < 1 )
			offsetVec = anglestoforward( self.angles );
		
		if ( offset < 30 )
		{
			offsetVec = vectorscale( offsetVec, 3 / offset );
			self teleport( self.origin - offsetVec );
		}			
	}
}


inSyncMeleeWithTarget()
{
	return( isdefined( self.enemy ) && isdefined( self.enemy.syncedMeleeTarget ) && self.enemy.syncedMeleeTarget == self );
}

handleStartAIPart( note )
{
	if ( note != "ai_attack_start" )
		return false;
		
	if ( !isdefined( self.enemy ) )
		return true;
		
	if ( self.enemy != self.originalTarget )
		return true;

	// enemy already has a synced melee target
	if ( isdefined( self.enemy.syncedMeleeTarget ) )
		return true;
		
	// self.enemy thread draw_tag( "tag_sync" );

	self.enemy.syncedMeleeTarget = self;
	self.enemy animcustom( ::meleeStruggleVsDog );
}

checkEndCombat( meleeRange )
{
	if ( !isdefined( self.enemy ) )
		return false;
		
	distToTargetSq = distanceSquared( self.origin, self.enemy.origin );
	
	return( distToTargetSq > meleeRange * meleeRange );
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
		offset = ( offset[ 0 ] * length, offset[ 1 ] * length, offset[ 2 ] * length );
		
		self thread attackTeleportThread( offset );
	}
}

// make up for error in intial attack jump position
attackTeleportThread( offset )
{
	self endon( "death" );
	self endon( "killanimscript" );
	reps = 5;
	increment = ( offset[ 0 ] / reps, offset[ 1 ] / reps, offset[ 2 ] / reps );
	for ( i = 0; i < reps; i ++ )
	{
		self teleport( self.origin + increment );
		wait( 0.05 );
	}
}

player_attacked()
{
	return level.player MeleeButtonPressed() || level.player attackButtonPressed();
}

dog_melee_death()
{
	self endon( "killanimscript" );
	self endon( "dog_no_longer_melee_able" );
	
	pressed = false;

	// change this number for difficulty level:
	press_time = 250;
	
	self waittill( "dog_early_notetrack" );
	
	while ( player_attacked() )
	{
		// wait until the player lets go of the button, if he's holding it
		wait( 0.05 );
	}
	
	for ( ;; )
	{
		if ( !pressed )
		{
			if ( level.player player_attacked() )
			{
				pressed = true;
				if ( isdefined( self.melee_able_timer ) )
				{
					if ( gettime() - self.melee_able_timer <= press_time )
					{
						level.player_view.custom_dog_save = "neck_snap";
						self notify( "melee_stop" );
						self setflaggedanimknobrestart( "dog_death_anim", %german_shepherd_player_neck_snap, 1, 0.2, 1 );

						self waittillmatch( "dog_death_anim", "dog_death" );
						self thread play_sound_in_space( "dog_neckbreak", self gettagorigin( "tag_eye" ) );
						self setcandamage( true );
						self.a.nodeath = true;
						self dodamage( self.health + 503, (0,0,0) );
						self notify( "killanimscript" );
					}
					else
					{
						level.player_view setanimlimited( get_player_knockdown_knob(), 0.01, 0.2, 1 );
						level.player_view setanimlimited( get_player_knockdown_late_knob(), 1, 0.2, 1 );
						
						self setanimlimited( %attack_player, 0.01, 0.2, 1 );
						self setanimlimited( %attack_player_late, 1, 0.2, 1 );
					}
					return;
				}
				
				self setflaggedanimknobrestart( "meleeanim", %german_shepherd_player_neck_miss, 1, 0.2, 1 );
				level.player_view setflaggedanimknobrestart( "meleeanim", get_player_dog_neck_miss_anim(), 1, 0.2, 1 );
				
				// once player clicks, if it is at the wrong time, he does not get another chance.
				return;
			}
		}
		else
		{
			if ( !level.player player_attacked() )
			{
				pressed = false;
			}
		}

		wait( 0.05 );
	}
}

// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
// 
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
#using_animtree( "generic_human" );

meleeStruggleVsDog()
{
	self endon( "killanimscript" );
	self endon( "death" );
	self endon( "end_melee_struggle" );
	self endon( "end_melee_all" );
	
	if ( !isdefined( self.syncedMeleeTarget ) )
		return;
		
	// self.syncedMeleeTarget = self;
	
	self OrientMode( "face point", self.syncedMeleeTarget.origin, 1 );
	self animMode( "gravity" );
	
	self.a.pose = "stand";
	
	meleeSeqAnim = [];
	meleeSeqAnim[ 0 ] = %root;
	meleeSeqAnim[ 1 ] = %AI_attacked_german_shepherd_01_start_a;
	meleeSeqAnim[ 2 ] = %AI_attacked_german_shepherd_02_idle_a;
	if ( self.syncedMeleeTarget.meleeKillTarget )
	{
		meleeSeqAnim[ 3 ] = %AI_attacked_german_shepherd_03_push_a;
		meleeSeqAnim[ 4 ] = %AI_attacked_german_shepherd_04_middle_a;
		meleeSeqAnim[ 5 ] = %AI_attacked_german_shepherd_05_death_a;
		numMeleeStage = 5;
	}
	else
	{
		meleeSeqAnim[ 3 ] = %AI_attacked_german_shepherd_03_shoot_a;
		numMeleeStage = 3;
	}
	
	self.meleeSeq = 0;

	self thread meleeStruggleVsDog_interruptedCheck();
	
	self clearanim( meleeSeqAnim[ 0 ], 0.1 );
	
	// this needs to happen here and not when the dog starts, because "tag_sync" won't be correct at that point
	self.syncedMeleeTarget linkto( self, "tag_sync", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	self setflaggedanimrestart( "aianim", meleeSeqAnim[ 1 ], 1, 0.1, 1 );
	self waittillmatch( "aianim", "end" );

	for ( self.meleeSeq = 1; self.meleeSeq < numMeleeStage;  )
	{
		self clearanim( meleeSeqAnim[ self.meleeSeq ], 0 );
		
		self.meleeSeq ++ ;
		
		// if starting the pistol pull out to shoot, don't let any other dog attack me for a bit
		if ( numMeleeStage == 3 && self.meleeSeq == 3 )
			self setNextDogAttackAllowTime( getAnimLength( meleeSeqAnim[ self.meleeSeq ] ) * 1000 - 1000 );
		
		self setflaggedanimrestart( "aianim", meleeSeqAnim[ self.meleeSeq ], 1, 0, 1 );
		self animscripts\shared::DoNoteTracks( "aianim" );
		
		// hack to let %AI_attacked_german_shepherd_03_push_a play to end when interrupted
		if ( !isdefined( self.syncedMeleeTarget ) || !isAlive( self.syncedMeleeTarget ) )	
		{
			if ( self.meleeSeq == 3 && numMeleeStage == 5 )
			{
				meleeSeqAnim[ 4 ] = %AI_attacked_german_shepherd_04_getup_a;
				numMeleeStage = 4;
			}
		}
		
		if ( self.meleeSeq == 5 )
		{	
			if ( !isdefined( self.magic_bullet_shield ) )
			{
				self.a.nodeath = true;
				self dodamage( self.health * 10, ( 0, 0, 0 ) );
			}
		}
	}
	
	meleeStruggleVsDog_End();
}


// check for premature termination from dog being shot by another AI or player
meleeStruggleVsDog_interruptedCheck()
{
	self endon( "killanimscript" );
	self endon( "death" );
	self endon( "end_melee_all" );

	meleeSeqAnim = [];
	meleeSeqAnim[ 1 ] = %AI_attacked_german_shepherd_02_getup_a;
	meleeSeqAnim[ 2 ] = %AI_attacked_german_shepherd_02_getup_a;

	if ( self.syncedMeleeTarget.meleeKillTarget )
	{
		// meleeSeqAnim[ 3 ] = %AI_attacked_german_shepherd_04_getup_a;	// handle this in meleeStruggleVsDog()
		meleeSeqAnim[ 4 ] = %AI_attacked_german_shepherd_04_getup_a;
	}

	while ( 1 )
	{
		if ( !isdefined( self.syncedMeleeTarget ) || !isAlive( self.syncedMeleeTarget ) )
			break;
			
		wait 0.1;
	}

	if ( self.meleeSeq > 0 ) 
	{
		if ( !isdefined( meleeSeqAnim[ self.meleeSeq ] ) )
			return;	// don't call meleeStruggleVsDog_End()

		self clearanim( %melee_dog, 0.1 );
		self setflaggedanimrestart( "getupanim", meleeSeqAnim[ self.meleeSeq ], 1, 0.1, 1 );
		self animscripts\shared::DoNoteTracks( "getupanim" );
	}
	
	meleeStruggleVsDog_End();
}


// this should kill both meleeStruggleVsDog() and meleeStruggleVsDog_endCheck() threads
meleeStruggleVsDog_End()
{
	self orientmode( "face default" );
	self.syncedMeleeTarget = undefined;
	self.meleeSeq = undefined;
	self.allowPain = true;
	self setNextDogAttackAllowTime( 1000 );
	
	self notify( "end_melee_all" );
}


// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
// 
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
#using_animtree( "player" );

PlayerView_Spawn()
{
	playerView = spawn( "script_model", level.player.origin );
	playerView.angles = level.player.angles;
	playerView setModel( level.player_viewhand_model );	// Add to level initialization maps\_load::set_player_viewhand_model;
	playerView useAnimTree( #animtree );
	playerView hide();
	
	return playerView;
}


handlePlayerKnockDownNotetracks( note )
{
	switch( note )
	{
		case "allow_player_save":
		{
			if ( getdvar( "friendlySaveFromDog" ) == "1" && isdefined( self.dog ) )
			{
				wait 1;
				self.dog setcandamage( true );
			}
		}
		break;
		
		case "blood_pool":
		{
			tagPos = self gettagorigin( "tag_torso" );	// rough tag to play fx on
			tagAngles = self gettagangles( "tag_torso" );
			forward = anglestoforward( tagAngles );
			up = anglestoup( tagAngles );
			right = anglestoright( tagAngles );
		
			tagPos = tagPos + vectorScale( forward, -8.5 ) + vectorScale( up, 5 ) + vectorScale( right, 0 );
			playfx( level._effect[ "deathfx_bloodpool" ], tagPos, forward, up );	// Add to level initialization animscripts\dog_init::initDogAnimations();
		}
		break;
	}
}


PlayerView_KnockDownAnim( dog )
{
	self endon( "pvd_melee_interrupted" );
	
	self.dog = dog;
	self thread PlayerView_CheckInterrupted();
	
	self setflaggedanimrestart( "viewanim", %player_view_dog_knockdown );
	self setflaggedanimrestart( "viewanim", %player_view_dog_knockdown_late );
	
	self setanimlimited( get_player_knockdown_knob(), 1, 0, 1 );
	self setanimlimited( get_player_knockdown_late_knob(), 0.01, 0, 1 );
	
	self animscripts\shared::DoNoteTracks( "viewanim", ::handlePlayerKnockDownNotetracks );
//	self animscripts\shared::DoNoteTracks( "viewanim_late", ::handlePlayerKnockDownNotetracks );
	
	self dontInterpolate();
	
	self.dog = undefined;
	PlayerView_EndSequence();
	self notify( "pvd_melee_done" );
}


PlayerView_CheckInterrupted()
{
	self endon( "pvd_melee_done" );
	
	self.dog waittill_any( "death", "pain", "melee_stop" );
	self notify( "pvd_melee_interrupted" );
	
	if ( !isdefined( level.player.specialDeath ) )
	{
		self.dog notify( "pvd_melee_interrupted" );
		PlayerView_EndSequence();
	}
}


PlayerView_StartSequence( dog )
{
	if ( isdefined( self.inSeq ) )
		return false;

	level.player notify( "dog_attacks_player" );
	self.inSeq = true;
	
	if ( isalive( level.player ) )
		setsaveddvar( "hud_drawhud", 0 );
	
	level.player setstance( "stand" );
	level.player.syncedMeleeTarget = dog;
	level.player_view PlayerView_Show();
	
	direction = dog.origin - level.player.origin;
	self.angles = vectortoangles( direction );
	self.angles = ( 0, self.angles[ 1 ], 0 );	

	playerpos = level.player.origin;
	self.origin = playerphysicstrace( ( playerpos[ 0 ], playerpos[ 1 ], playerpos[ 2 ] + 50 ), ( playerpos[ 0 ], playerpos[ 1 ], playerpos[ 2 ] - 200 ) );
	
	self thread PlayerView_KnockDownAnim( dog );
	self dontInterpolate();
	
	level.player playerLinkToAbsolute( self, "tag_player" );
	dog linkto( self, "tag_sync", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	syncTagAngles = self gettagangles( "tag_sync" );
	dog orientmode( "face angle", syncTagAngles[ 1 ] );
	dog orientmode( "face default" );
	
	// self thread draw_tag( "tag_player" );
	// self thread draw_tag( "tag_sync" );
	// dog thread draw_tag( "tag_origin" );

	level.player allowLean( false );
	level.player allowCrouch( false );
	level.player allowProne( false );
	level.player freezeControls( true );
	
	level.player setcandamage( false );
	
	return true;
}

SavedNotify()
{
	wait 0.5;
	level.player playsound( "saved_from_dog" );
}

PlayerView_EndSequence()
{
	self.inSeq = undefined;
	
	setsaveddvar( "hud_drawhud", 1 );

	if ( isalive( level.player ) )
	{
		level.player setcandamage( true );
		
		self clearanim( %player_view_dog_knockdown, 0.1 );
		if ( isdefined( self.custom_dog_save ) )
		{
			custom_saves = [];
			custom_saves[ "neck_snap" ] = %player_view_dog_knockdown_neck_snap;
			self setflaggedanimrestart( "viewanim", custom_saves[ self.custom_dog_save ], 1, 0.2, 1 );
		}
		else
		{
			// TEMP string messages
			messages = [];
			messages[0] = "You OK? I barely got him";
			messages[1] = "Get back up!";
			messages[2] = "That was close. You owe me one.";
			messages[3] = "Good thing I was nearby.";
			
			iprintlnbold( messages[ randomint( 4 ) ] );
			
			thread SavedNotify();
			self setflaggedanimrestart( "viewanim", %player_view_dog_knockdown_saved );
		}
		
		self animscripts\shared::DoNoteTracks( "viewanim" );

		level.player notify( "player_saved_from_dog" );

		level.player unlink();
		level.player setOrigin( self.origin );
		level.player showViewModel();
		level.player enableweapons();
		level.player_view delete();
		
		angles = level.player getplayerangles();
		level.player setplayerangles( (0, angles[1], 0) );
	}
	else
	{
		setsaveddvar( "compass", 0 );
	}

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
	level.player disableweapons();
}



/* draw_tag( tagname )
{
	self endon( "death" );
	
	range = 25;
	
	while ( 1 )
	{
		angles = self gettagangles( tagname );	
		origin = self gettagorigin( tagname );
		
		forward = anglestoforward( angles );
		forward = vectorscale( forward, range );
		right = anglestoright( angles );
		right = vectorscale( right, range );
		up = anglestoup( angles );
		up = vectorscale( up, range );
		line( origin, origin + forward, ( 1, 0, 0 ), 1 );
		line( origin, origin + up, ( 0, 1, 0 ), 1 );
		line( origin, origin + right, ( 0, 0, 1 ), 1 );
		wait 0.05;
	}
} */ 


get_player_dog_neck_miss_anim()
{
	return %player_view_dog_knockdown_neck_miss;
}

get_player_view_dog_knock_down_anim()
{
	return %player_view_dog_knockdown;
}

get_player_view_dog_knock_down_late_anim()
{
	return %player_view_dog_knockdown_late;
}

get_player_knockdown_knob()
{
	return %knockdown;
}

get_player_knockdown_late_knob()
{
	return %knockdown_late;
}