#include common_scripts\utility;
#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;

main()
{
	debug_anim_print("dog_combat::main() " );

	self endon("killanimscript");
	self SetAimAnimWeights( 0, 0 );

	assert( isdefined( self.enemy ) );
	if ( !isalive( self.enemy ) )
	{
		combatIdle();
		return;
	}

	if ( IsPlayer(self.enemy) )
		self meleeBiteAttackPlayer(self.enemy);
}

combatIdle()
{
	self set_orient_mode("face enemy");
	self animMode( "zonly_physics" );
	
	idleAnims = [];
	idleAnims[ 0 ] = "combat_attackidle";
	idleAnims[ 1 ] = "combat_attackidle_bark";
	idleAnims[ 2 ] = "combat_attackidle_growl";
	idleAnim = maps\mp\_utility::random( idleAnims );
	
	self thread combatIdlePreventOverlappingPlayer();
			
	debug_anim_print("dog_combat::combatIdle() - Setting " + idleAnim );
	self setanimstate( idleAnim );
	self maps\mp\animscripts\shared::DoNoteTracks( "done" );
	debug_anim_print("dog_combat::combatIdle() - " + idleAnim + " notify done." );
	
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
		
		if ( !isdefined( self.enemy))
			continue;
			
		if ( !isdefined( self.enemy.syncedMeleeTarget ) || self.enemy.syncedMeleeTarget == self )
			continue;
		
		offsetVec = self.enemy.origin - self.origin;
		
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

meleeBiteAttackPlayer(player)
{
	attackRangeBuffer = 30;

	for ( ;; )	
	{
		if ( !isalive( self.enemy ) )
			break;

		meleeRange = self.meleeAttackDist + attackRangeBuffer;
			
		if ( ( isdefined( player.syncedMeleeTarget ) && player.syncedMeleeTarget != self ) )
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
			
		self set_orient_mode("face enemy");
		self animMode( "gravity" );

		self.safeToChangeScript = false;

		prepareAttackPlayer(player);

		self clearpitchorient();
		
/#		
		if ( getdvarint( "debug_dog_sound" ) )
			iprintln( "dog " + (self getentnum()) + " attack player " + getTime() );

#/		
		player setNextDogAttackAllowTime( 200 );
		
		if ( dog_cant_kill_in_one_hit(player) )
		{
			level.lastDogMeleePlayerTime = getTime();
			level.dogMeleePlayerCounter++;
		
			if ( use_low_attack() )
			{
				// this is a hack using an existing anim to try and do a short range
				// ground based attack
				self animMode("angle deltas");
				self setanimstate( "combat_attack_player_close_range" );
				
				doMeleeAfterWait( 0.1 );
				self maps\mp\animscripts\shared::DoNoteTracksForTime( 1.4, "done" );
				
				self animMode( "gravity" );
			}
			else
			{
				// 1.6 is about as big as you want to go or the dog anim will "stall"
				attack_time = 1.2 + randomfloat( 0.4 );
				debug_anim_print("dog_combat::meleeBiteAttackPlayer() - Setting  combat_run_attack" );
				self setanimstate( "combat_attack_run" );
				self maps\mp\animscripts\shared::DoNoteTracksForTime( attack_time, "done", ::handleMeleeBiteAttackNoteTracks, player );
				debug_anim_print("dog_combat::meleeBiteAttackPlayer() - combat_attack_run notify done." );
			}
		}
		else
		{
			self thread dog_melee_death(player);
			player.attacked_by_dog = true;
			self thread clear_player_attacked_by_dog_on_death(player);

			debug_anim_print("dog_combat::meleeBiteAttackPlayer() - Setting  combat_attack_player" );
			self setanimstate( "combat_attack_player" );
			self maps\mp\animscripts\shared::DoNoteTracks( "done", ::Handlemeleefinishattacknotetracks, player );
			debug_anim_print("dog_combat::meleeBiteAttackPlayer() - combat_attack_player notify done." );
			self notify( "dog_no_longer_melee_able" );
			self setcandamage( true );
			self unlink();
		}
		
		self.safeToChangeScript = true;

		if ( checkEndCombat( meleeRange ) )
			break;
	}
	
	self.safeToChangeScript = true;
	self animMode("none");
}

doMeleeAfterWait( time )
{
	self endon("death");
	
	wait(time);
	
	// not useing angles on the melee hit so it will always hit
	hitEnt = self melee( );
	if ( isdefined( hitEnt ) )
	{
		if ( isplayer(hitEnt) )
			hitEnt shellshock("dog_bite", 1);
	}
}

handleMeleeBiteAttackNoteTracks( note, player )
{
	switch ( note )
	{
		case "dog_melee":
		{
			if ( !isdefined(level.dogMeleeBiteAttackTime) )
			{
				level.dogMeleeBiteAttackTime = GetTime() - level.dogMeleeBiteAttackTimeStart;
				level.dogMeleeBiteAttackTime += 50;
			}

			hitEnt = self melee( anglesToForward( self.angles ) );

			if ( isdefined( hitEnt ) )
			{
				if ( isplayer(hitEnt) )
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
		{
			// best guess
			melee_time = 200;
			
			// how much longer until the bite
			// bit of a hack solution 
			if ( !isdefined(level.dogMeleeBiteAttackTime) )
			{
				level.dogMeleeBiteAttackTimeStart = GetTime();
			}
			else
			{
				melee_time = level.dogMeleeBiteAttackTime;
			}
			
			self thread orientToPlayerDeadReckoning(player, melee_time);
		}
			break;
	}
}

handleMeleeFinishAttackNoteTracks( note, player )
{
	switch( note )
	{
		case "dog_melee":

			if ( !isdefined(level.dogMeleeFinishAttackTime) )
			{
				level.dogMeleeFinishAttackTime = GetTime() - level.dogMeleeFinishAttackTimeStart;
				level.dogMeleeFinishAttackTime += 50;
			}

			hitEnt = self melee( anglesToForward( self.angles ) );
			if ( isdefined( hitEnt ) && isalive( player ) )
			{
				if ( hitEnt == player )
				{
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

			debug_anim_print("dog_combat::handleMeleeFinishAttackNoteTracks() - Setting  combat_attack_player_early" );
			self setanimstate( "combat_attack_player_early" );
			break;
			
		case "dog_lunge":
			thread set_melee_timer(player);
			debug_anim_print("dog_combat::handleMeleeFinishAttackNoteTracks() - Setting  combat_attack_player_lunge" );
			self setanimstate( "combat_attack_player_lunge" );
			break;
			
		case "dogbite_damage":
		
			self thread killplayer(player);
			break;
			
		case "stop_tracking":
		{
			// best guess
			melee_time = 200;
			
			// how much longer until the bite
			// bit of a hack solution 
			if ( !isdefined(level.dogMeleeFinishAttackTime) )
			{
				level.dogMeleeFinishAttackTimeStart = GetTime();
			}
			else
			{
				melee_time = level.dogMeleeFinishAttackTime;
			}
			
			self thread orientToPlayerDeadReckoning(player, melee_time );
		}
			break;
	}
}

orientToPlayerDeadReckoning(player, time_till_bite )
{
	enemy_attack_current_origin = player.origin;
	enemy_attack_current_time = GetTime();
	
	enemy_motion_time_delta = enemy_attack_current_time - self.enemy_attack_start_time;
	enemy_motion_direction = enemy_attack_current_origin - self.enemy_attack_start_origin;
	
	if ( enemy_motion_time_delta == 0 )
	{
		enemy_predicted_position = player.origin;
	}
	else
	{	
		enemy_velocity =  enemy_motion_direction / enemy_motion_time_delta;
		enemy_predicted_position = player.origin + (enemy_velocity * time_till_bite);
	}
	
	self set_orient_mode("face point", enemy_predicted_position );
}

checkEndCombat( meleeRange )
{
	if ( !isdefined( self.enemy ) )
		return false;
		
	distToTargetSq = distanceSquared( self.origin, self.enemy.origin );
	
	return ( distToTargetSq > meleeRange * meleeRange );
}

use_low_attack(player)
{
	height_diff = self.enemy_attack_start_origin[2] - self.origin[2];
	
	low_enough = 30.0;	

 	if ( height_diff < low_enough && self.enemy_attack_start_stance == "prone" )
 	{
 		return true;
 	}
 	
 	return false;
}

prepareAttackPlayer(player)
{
	level.dog_death_quote = &"SCRIPT_PLATFORM_DOG_DEATH_DO_NOTHING";
	distanceToTarget = distance( self.origin, self.enemy.origin );
	targetHeight = Abs(self.enemy.origin[2] - self.origin[2]);
	
	self.enemy_attack_start_distance = distanceToTarget;
	self.enemy_attack_start_origin = player.origin;
	self.enemy_attack_start_time = GetTime();
	self.enemy_attack_start_stance = player getStance();
	
	distance_ok = ( (distanceToTarget > self.meleeAttackDist) && (targetHeight < (self.meleeAttackDist * 0.5)) );
	
	if ( distance_ok && !use_low_attack() )
	{
		offset = self.enemy.origin - self.origin;

		length = ( distanceToTarget - self.meleeAttackDist ) / distanceToTarget;
		offset = ( offset[0] * length, offset[1] * length, offset[2] * length );
		
		self thread attackTeleportThread( offset );
	}
	
/#
	if ( maps\mp\_dogs::dog_get_dvar_int( "debug_dog_attack","0" )  )
	{
		teleported = "";
		if ( distance_ok && !use_low_attack() )
		{
			teleported = "Teleported";
		}

		//println("Attack Target - Dist: " + distanceToTarget + " Stance: " + self.enemy_attack_start_stance + " " + teleported);
	}	
#/

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

player_attacked()
{
	return isalive( self ) && ( self MeleeButtonPressed() );
}

set_melee_timer(player)
{
	wait( 0.15 );
	self.melee_able_timer = gettime();
}


clear_player_attacked_by_dog_on_death(player)
{
	self waittill( "death" );
	player.attacked_by_dog = undefined;
}
			

dog_cant_kill_in_one_hit(player)
{
	// right now we want the dogs not to do the singleplayer "instant-kill"
	return true;
	
	if ( isdefined( player.dogs_dont_instant_kill ) )
	{
		assertex( player.dogs_dont_instant_kill, "Dont set player.dogs_dont_instant_kill to false, set to undefined" );
		return true;
	}
	
	if ( getTime() - level.lastDogMeleePlayerTime > 8000 )
		level.dogMeleePlayerCounter = 0;
	
	return level.dogMeleePlayerCounter < level.dog_hits_before_kill && 
		   player.health > 25;	// little more than the damage one melee dog bite hit will do
}

dog_melee_death(player)
{
	self endon( "killanimscript" );
	self endon( "dog_no_longer_melee_able" );
	pressed = false;

	// change this number for difficulty level:
	press_time = anim.dog_presstime;
	
	
	self waittill( "dog_early_notetrack" );
	
	while ( player player_attacked() )
	{
		// wait until the player lets go of the button, if he's holding it
		wait( 0.05 );
	}
	
	for ( ;; )
	{
		if ( !pressed )
		{
			
			if ( player player_attacked() )
			{
				pressed = true;
				if ( isdefined( self.melee_able_timer ) && isalive( player ) )
				{
					if ( gettime() - self.melee_able_timer <= press_time )
					{
						player.player_view.custom_dog_save = "neck_snap";
						self notify( "melee_stop" );
						debug_anim_print("dog_combat::dog_melee_death() - Setting  combat_player_neck_snap" );
						self setanimstate( "combat_player_neck_snap" );
					
						self waittillmatch( "done", "dog_death" );
						debug_anim_print("dog_combat::dog_melee_death() - combat_player_neck_snap notify done." );
						self playsound( "dog_neckbreak", self gettagorigin( "tag_eye" ) );
						self setcandamage( true );
						self.a.nodeath = true;
						dif = player.origin - self.origin;
						dif = ( dif[ 0 ], dif [ 1 ], 0 );
						self dodamage( self.health + 503, self geteye() - dif, player );
						self notify( "killanimscript" );
					}
					else
					{
						debug_anim_print("dog_combat::dog_melee_death() - Setting  combat_player_neck_snap"  );
						self setanimstate( "combat_attack_player" );
						level.dog_death_quote = &"SCRIPT_PLATFORM_DOG_DEATH_TOO_LATE";
					}
					return;
				}
				
				level.dog_death_quote = &"SCRIPT_PLATFORM_DOG_DEATH_TOO_SOON";
				debug_anim_print("dog_combat::dog_melee_death() - Setting  combat_player_neck_miss" );
				self setanimstate( "combat_player_neck_miss" );

				// once player clicks, if it is at the wrong time, he does not get another chance.
				return;
			}
		}
		else
		{
			if ( !player player_attacked() )
			{
				pressed = false;
			}
		}

		wait( 0.05 );
	}
}


attackMiss()
{
	if ( isdefined( self.enemy ) )
	{
		forward	= anglestoforward( self.angles );
		dirToEnemy = self.enemy.origin - ( self.origin + vectorscale( forward, 50 ) );
		if ( vectordot( dirToEnemy, forward ) > 0 )
		{
			debug_anim_print("dog_combat::attackMiss() - Setting  combat_attack_miss" );
			self setanimstate( "combat_attack_miss" );
			self thread maps\mp\animscripts\dog_stop::lookAtTarget( "normal" );
		}
		else 
		{
			self.skipStartMove = true;
			self thread attackMissTrackTargetThread();
			
			if ( ( dirToEnemy[0] * forward[1] - dirToEnemy[1] * forward[0] ) > 0 )
			{
						debug_anim_print("dog_combat::attackMiss() - Setting  combat_attack_miss_right" );
						self setanimstate( "combat_attack_miss_right" );
			}
			else
			{
						debug_anim_print("dog_combat::attackMiss() - Setting  combat_attack_miss_left" );
						self setanimstate( "combat_attack_miss_left" );
			}
		}
	}
	else
	{
					debug_anim_print("dog_combat::attackMiss() - Setting  combat_attack_miss" );
					self setanimstate( "combat_attack_miss" );
	}

	self maps\mp\animscripts\shared::DoNoteTracks( "done" );
	debug_anim_print("dog_combat::attackMiss() - attackMiss notify done." );
	self notify("stop tracking");
	debug_anim_print("dog_combat::attackMiss() - Stopped tracking"  );
}


attackMissTrackTargetThread()
{
	self endon( "killanimscript" );

	wait 0.6;
	self set_orient_mode( "face enemy" );
}

killplayer(player)
{
	self endon( "pvd_melee_interrupted" );
	
	player.specialDeath = true;
	player setcandamage( true );

	wait 1;

	damage = player.health + 1;
	
	if ( !isalive( player ) )
		return;
		
}
