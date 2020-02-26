#include animscripts\utility; 
#include animscripts\combat_utility; 
#include animscripts\shared; 
#include common_scripts\utility; 
#include maps\_utility;
#using_animtree( "generic_human" ); 

banzai_init_anims()
{
	anim.banzai_run = [];
	anim.banzai_run[anim.banzai_run.size] = %ai_bonzai_sprint_a;
	anim.banzai_run[anim.banzai_run.size] = %ai_bonzai_sprint_b;
	anim.banzai_run[anim.banzai_run.size] = %ai_bonzai_sprint_d;
	anim.banzai_run[anim.banzai_run.size] = %ai_bonzai_sprint_c;

	anim.banzai_meleeseq_ai_stab = [];
	anim.banzai_meleeseq_ai_stab[anim.banzai_meleeseq_ai_stab.size] = %ai_bayonet_back_death;

	anim.banzai_meleeseq_ai_death = [];
	anim.banzai_meleeseq_ai_death[anim.banzai_meleeseq_ai_death.size] = %ai_bayonet_back_death;

	anim.banzai_meleeseq_ai_attacker = [];
	anim.banzai_meleeseq_ai_attacker[anim.banzai_meleeseq_ai_attacker.size] = %ai_bonzai_enemy_success_front;
	anim.banzai_meleeseq_ai_attacker[anim.banzai_meleeseq_ai_attacker.size] = %ai_bonzai_enemy_fail_front;
	anim.banzai_meleeseq_ai_attacker[anim.banzai_meleeseq_ai_attacker.size] = %ai_bonzai_enemy_success_rear;
	anim.banzai_meleeseq_ai_attacker[anim.banzai_meleeseq_ai_attacker.size] = %ai_bonzai_enemy_fail_rear;
	anim.banzai_meleeseq_ai_attacker[anim.banzai_meleeseq_ai_attacker.size] = %ai_bonzai_enemy_fail_left;
	anim.banzai_meleeseq_ai_attacker[anim.banzai_meleeseq_ai_attacker.size] = %ai_bonzai_enemy_fail_right;
	
	anim.banzai_meleeseq_ai_defender = [];
	anim.banzai_meleeseq_ai_defender[anim.banzai_meleeseq_ai_defender.size] = %ai_bonzai_buddy_fail_front;
	anim.banzai_meleeseq_ai_defender[anim.banzai_meleeseq_ai_defender.size] = %ai_bonzai_buddy_success_front;
	anim.banzai_meleeseq_ai_defender[anim.banzai_meleeseq_ai_defender.size] = %ai_bonzai_buddy_fail_rear;
	anim.banzai_meleeseq_ai_defender[anim.banzai_meleeseq_ai_defender.size] = %ai_bonzai_buddy_success_rear;
	anim.banzai_meleeseq_ai_defender[anim.banzai_meleeseq_ai_defender.size] = %ai_bonzai_buddy_success_left;
	anim.banzai_meleeseq_ai_defender[anim.banzai_meleeseq_ai_defender.size] = %ai_bonzai_buddy_success_right;

	banzai_init_player_anims();
	
	anim.banzai_meleeseq_player_attacker = [];
	anim.banzai_meleeseq_player_attacker[anim.banzai_meleeseq_player_attacker.size] = %ai_bonzai_enemy_attack_player_impact;
	anim.banzai_meleeseq_player_attacker[anim.banzai_meleeseq_player_attacker.size] = %ai_bonzai_enemy_attack_player;
	anim.banzai_meleeseq_player_attacker[anim.banzai_meleeseq_player_attacker.size] = %ai_bonzai_enemy_attack_player_intro;
	anim.banzai_meleeseq_player_attacker[anim.banzai_meleeseq_player_attacker.size] = %ai_bonzai_enemy_attack_player_fail;
	anim.banzai_meleeseq_player_attacker[anim.banzai_meleeseq_player_attacker.size] = %ai_bonzai_enemy_attack_player_success;
}


banzai_ignoreme_monitor(time)
{
	self notify ("ignormeshield_off" );

	self endon( "death" );
	self endon( "ignormeshield_off" );


	wait(time);
	self.ignoreme = false;
}

init()
{
	self.ignoreSuppression = true; 	
	self.suppressionThreshold = 1; 
	self.noDodgeMove = true; 
	self.dontShootWhileMoving = true;
	self.grenadeawareness = 0;
	self.pathenemylookahead = 0;
	self.meleeAttackDist = 0; 
	self thread melee_attack_dist_thread(); 
	self.badplaceawareness = 0;
	self.chatInitialized = false; 
	self thread banzai_ignoreme_monitor(10);
	
	if ( GetDvar( "banzai_yell_distance" ) == "" )
		SetDvar( "banzai_yell_distance", 360 );
		
	if ( GetDvar( "banzai_yell_min_pause" ) == "" )
		SetDvar( "banzai_yell_min_pause", 0.3 );
		
	if ( GetDvar( "banzai_yell_max_pause" ) == "" )
		SetDvar( "banzai_yell_max_pause", 0.5 );
}

banzai_easy()
{
	return ( GetDvar( "banzai_hard" ) == "" );
}

allow_mashing()
{
	return ( GetDvar( "banzai_no_button_mash" ) == "" && banzai_easy() );
}

delayed_player_success()
{
	return ( GetDvar( "banzai_interactive_success" ) == "" && banzai_easy() );
}

debug_banzai()
{
	return ( GetDvar( "debug_banzai" ) == "1" );
}

ent_id()
{
	entNum = self GetEntityNumber();
	return padded_int( entNum, 3 );
}

power( base, exp )
{
	assert( exp >= 0 );
	if ( exp == 0 )
		return 1;
		
	return base * power( base, exp - 1 );
}

padded_int( num, numDigits )
{
	assert( numDigits > 0 );
	
	if ( numDigits == 1 )
		return num;
		
	limit = power( 10, numDigits - 1 );
	
	if ( num < limit )
		return "0" + padded_int( num, numDigits - 1 );
		
	return padded_int( num, numDigits - 1 );
}

banzai_print( attacker, defender, string1, string2, string3 )
{
	/#
	if ( debug_banzai() )
	{
		assertEx( IsDefined( string1 ), "banzai_print() expects at least one parameter!" );

		header = "BANZAI t: " + padded_int( gettime() / 10, 5 );
				
		if ( IsDefined( attacker ) )
		{
			header = header + " att: " + attacker ent_id();
		}
		else
		{
			header = header + " att:  ? ";
		}
		
		if ( IsDefined( defender ) )
		{
			header = header + " def: " + defender ent_id();
		}
		else
		{
			header = header + " def:  ? ";
		}
		
		header = header + " | ";
		
		if ( IsDefined( string2 ) )
		{
			if ( IsDefined( string3 ) )
			{
				println( header, string1, string2, string3 );
			}
			else
			{
				println( header, string1, string2 );
			}
		}
		else
		{
			println( header, string1 );
		}
	}
	#/
}

set_banzai_melee_distance( distance )
{
	self.meleeAttackDist = distance;
	self.pathEnemyFightDist = distance;
}

melee_attack_dist_thread()
{
	self endon( "death" ); 

	while( 1 )
	{
		set_banzai_melee_distance( 64 ); // This has to match one or more harcoded "64"s in the engine.
		self waittill( "enemy" ); // Notified from code when a new enemy is assigned.
	}
}

move_banzai()
{
	self OrientMode("face motion");
	
	animscripts\run::changeWeaponStandRun(); 
	
	// any endons in this function must also be in banzaiShootWhileMoving and banzaiDecideWhatAndHowToShoot
	
	if( self.a.pose != "stand" )
	{
		//( get rid of any prone or other stuff that might be going on )
		self ClearAnim( %root, 0.2 ); 
		if( self.a.pose == "prone" )
		{
			self ExitProneWrapper( 1 ); 
		}
		self.a.pose = "stand"; 
	}
	
	enemy = self.enemy;
	
	distSqToEnemy = 16000000;
	if ( IsDefined( enemy ) )
		distSqToEnemy = DistanceSquared( self.origin, enemy.origin );
	
	start_banzai_yell();
	
	move_anim = undefined;
	
	if ( IsDefined( enemy ) && distSqToEnemy < 4096 )
	{
		self.a.movement = "walk";
		move_anim = %walk_lowready_F;
	}
	else
	{
		self.a.movement = "run"; 
	
		runloopindex = getRandomIntFromSeed( self.a.runLoopCount, 3 );

		if ( IsDefined( enemy ) && IsPlayer( enemy ) && ( RandomInt( 100 ) <  50 ) )
		{ 
			// The last run loop is only for playing when we're closing in on the player.
			if ( distSqToEnemy < 40000 )
			{
				runloopindex = 3;
			}
		}
	
		move_anim = anim.banzai_run[runloopindex];
	}

	rate = self.moveplaybackrate; 
	
	self SetFlaggedAnimKnobAll( "runanim", move_anim, %body, 1, 0.3, rate );	
	animscripts\shared::DoNoteTracksForTime( 0.2, "runanim" );
}

start_banzai_yell()
{
	enemy = self.enemy;
	
	banzai_print( self, enemy, "Checking to see if should start banzai yell." );
	
	if ( !IsDefined( enemy ) || !IsPlayer( enemy ) )
		return;
	
	if ( IsDefined( self.banzai_announcing ) && self.banzai_announcing )
		return;
	
	if ( IsDefined( self.banzai_yelling) && self.banzai_yelling )
		return;
		
	if ( DistanceSquared( self.origin, enemy.origin ) > squared( GetDvarFloat( "banzai_yell_distance" ) ) )
		return;
		
	banzai_print( self, enemy, "Starting banzai yell." );

	self.banzai_yelling = true;
	self thread listen_for_end_of_banzai_yell();
	self maps\_banzai::banzai_dialogue( "banzai_charge_yell", undefined, "banzai_yell_ended" );
}

listen_for_end_of_banzai_yell()
{
	self endon( "death" );
	self waittill( "banzai_yell_ended" );
	banzai_print( self, undefined, "Banzai yell ended." );
	pauseTime = RandomFloatRange( GetDvarFloat( "banzai_yell_min_pause" ), GetDvarFloat( "banzai_yell_max_pause" ) );
	wait( pauseTime );
	banzai_print( self, undefined, "Ready for next banzai yell." );
	self.banzai_yelling = false;
}

stop_banzai_yell()
{
	self endon( "death" );
	
	if ( IsDefined( self.banzai_announcing ) && self.banzai_announcing )
	{
		// Make sure banzai announce completes before stopping all sounds.
		self waittill( "banzai_announce_ended" ); 
	}
	
	if ( IsDefined( self.banzai_yelling ) && self.banzai_yelling )
	{
		self stopsounds();
	}
}

banzai_attack()
{
	self notify( "melee" ); // This kills any other exposecombatmainloops running.
	
	//self trackScriptState( "banzai", "within melee distance" );

	enemy = self.enemy; // TBD: Would self.favoriteEnemy be safer? Note that self.enemy is set below.

	banzai_print( self, enemy, "Starting banzai attack." );

	if ( !IsAlive( enemy ) )
		return;
	
	/#
	if ( debug_banzai() )
	{
		self thread report_damage();
		enemy thread report_damage();
	}
	#/
		
	if( IsPlayer( enemy ) )
	{
		if( isdefined(self.banzai_grenadesuicide) && self.banzai_grenadesuicide )
		{
			level thread doSuicidegrenade( self, enemy );
		}
		else
		{
			level thread banzai_attack_player( self, enemy );
		}
	}
	else // AI
	{
		// AI animations are all authored with the defender standing.
		if ( IsDefined( enemy.a.pose ) && enemy.a.pose == "crouch" )
		{
			// TBD: Do we need to do something here other than just set the pose?
			self.enemy.a.pose = "stand";
		}
		
		level thread banzai_melee_ai_seq( self, enemy );		
	}
}

report_damage()
{
	self notify( "end_report_damage" );
	self endon( "end_report_damage" );
	
	while (1)
	{
		self waittill( "damage", amount, inflictor, direction, point, type, modelName, tagName );
		banzai_print( undefined, undefined, "Damage: sufferer=" + self GetEntityNumber() + " amount=" + amount + " type=" + type );
	}
}

doSuicideGrenade( attacker, victim )
{
	grenadeOrigin = attacker GetTagOrigin ( "tag_inhand" );
	velocity = getGrenadeDropVelocity();
	attacker MagicGrenadeManual( grenadeOrigin, velocity, 0 );
	attacker.hasSuicideGrenade = undefined;			
}


// START BANZAI vs. AI


calculate_link_time( animName )
{
	animLength = GetAnimLength( animName );
	
	// Always link 3/10ths of a second into the animation for now.	
	if ( animLength > 0.3 )
		return 0.3;
	
	return 0;
}

calculate_unlink_time( animName )
{
	animLength = GetAnimLength( animName );
	times = getNotetrackTimes( animName, "start_ragdoll" );
	if ( times.size > 0 )
		return times[0] * animLength;
		
	if ( animLength > 0.1 )
		return animLength - 0.1;
		
	return animLength;
}

banzai_melee_ai_seq( attacker, defender )
{
	if ( attacker in_banzai_attack() || defender in_banzai_attack() || attacker in_banzai_melee() || defender in_banzai_melee() )
	{
		assert( IsDefined( attacker ) && IsAlive( attacker ) && attacker.health > 0 );
		
		/#
		if ( attacker in_banzai_attack() )
			banzai_print( attacker, defender, "Attack aborted at last minute. Reason: attacker in banzai attack." );
			
		if ( defender in_banzai_attack() )
			banzai_print( attacker, defender, "Attack aborted at last minute. Reason: defender in banzai attack." );
			
		if ( attacker in_banzai_melee() )
			banzai_print( attacker, defender, "Attack aborted at last minute. Reason: attacker in banzai melee." );
			
		if ( defender in_banzai_melee() )
			banzai_print( attacker, defender, "Attack aborted at last minute. Reason: defender in banzai melee." );
		#/
		
		if ( !attacker in_banzai_attack() && !attacker in_banzai_melee() ) 
		{
			attacker thread continue_exposed_combat();
		}
		
		return;
	}
	
	banzai_print( attacker, defender, "Started AI vs. AI banzai melee." );
	
	attacker thread stop_banzai_yell();
	
	attacker AnimMode( "zonly_physics" );
	defender AnimMode( "zonly_physics" );

	attacker.amBanzaiAttacking = true;
	attacker.inBanzaiMelee = true;
	defender add_banzai_attacker( attacker );
	defender.inBanzaiMelee = true;
	attacker.disableArrivals = true;
	defender.disableArrivals = true;	
				
	attackerForward = VectorNormalize( AnglesToForward( attacker.angles ) );
	attackerRight = VectorNormalize( AnglesToRight( attacker.angles ) );
	defenderForward = VectorNormalize( AnglesToForward( defender.angles ) );
	defenderRight = VectorNormalize( AnglesToRight( attacker.angles ) );
	
	attackerToDefender = VectorNormalize( defender.origin - attacker.origin );
	defenderToAttacker = VectorNormalize( attacker.origin - defender.origin );
	
	defenderForwardDotAttackVector = VectorDot( defenderForward, defenderToAttacker );
	
	attackerSucceeds = false;
	level.banzai_ai_anim_index = -1;
	newDefenderForward = undefined;
	level.banzai_link_distance = 32; // currently hardcoded; should be based on animation tag_syncs
	
	if ( defenderForwardDotAttackVector > 0.7071 )
	{
		// Those with the magic bullet shield must always win their banzai melee
		if ( !IsDefined( defender.magic_bullet_shield ) || !defender.magic_bullet_shield )
		{
			attackerSucceeds = RandomInt( 100 ) < 60;
		}		
	
		if ( attackerSucceeds )
		{
			level.banzai_ai_anim_index = 0;
			level.banzai_link_distance = 48;
		}
		else
		{
			level.banzai_ai_anim_index = 1;
			level.banzai_link_distance = 42;
		}
		
		newDefenderForward = defenderToAttacker;
	}
	else if ( defenderForwardDotAttackVector < -0.7071 )
	{
		// Those with the magic bullet shield must always win their banzai melee
		if ( !IsDefined( defender.magic_bullet_shield ) || !defender.magic_bullet_shield )
		{
			attackerSucceeds = RandomInt( 100 ) < 60;
		}		
	
		if ( attackerSucceeds )
		{
			level.banzai_ai_anim_index = 2;
		}
		else
		{
			level.banzai_ai_anim_index = 3;
		}
		
		newDefenderForward = defenderToAttacker;
	}
	else
	{
		defenderUp = AnglesToUp( attacker.angles );
		
		defenderRightDotAttackVector = VectorDot( defenderRight, defenderToAttacker );

		// Just because it looks pretty good, use defender face left
		// for the behind case as well.
		if ( defenderRightDotAttackVector > 0 )
		{
			// defender face right; attacker comes from his left/left flank
			level.banzai_ai_anim_index = 4;
			level.banzai_link_distance = 32;
			newDefenderForward = VectorCross( defenderToAttacker, defenderUp );
		}
		else
		{
			// defender face left; attacker comes from his right/right flank
			level.banzai_ai_anim_index = 5;
			level.banzai_link_distance = 32;
			newDefenderForward = VectorCross( defenderUp, defenderToAttacker );
		}
	}
	
	assert( IsDefined( newDefenderForward ) );
	assert( level.banzai_ai_anim_index > -1 );
	
	// Must set OrientMode for this set of animations before setting the 
	// syncedMeleeTarget, since once that's set, the OrientMode is locked
	// into "face current".
	defender OrientMode( "face direction", newDefenderForward );
	attacker OrientMode( "face direction", attackerToDefender );

	defender.syncedMeleeTarget = attacker;
	attacker.syncedMeleeTarget = defender;

	attackerAnim = anim.banzai_meleeseq_ai_attacker[ level.banzai_ai_anim_index ];
	defenderAnim = anim.banzai_meleeseq_ai_defender[ level.banzai_ai_anim_index ];
	animLength = GetAnimLength( attackerAnim ); // shouldn't matter which since they should be the same length

	if ( attackerSucceeds )
	{	
		level.banzai_link_time = calculate_link_time( attackerAnim );
		level.banzai_unlink_time = calculate_unlink_time( defenderAnim );
	}
	else
	{
		level.banzai_link_time = calculate_link_time( defenderAnim );
		level.banzai_unlink_time = calculate_unlink_time( attackerAnim );
	}
	
	level thread notify_if_either_interrupted( attacker, defender );
	attacker thread notify_when_melee_over( animLength );
		
	attacker animcustom( ::play_banzai_ai_attacker_anim_custom_script );
	defender animcustom( ::play_banzai_ai_defender_anim_custom_script );
	
	attacker waittill_either( "banzai_melee_ended_on_time", "banzai_melee_interrupted" );
	
	banzai_print( attacker, defender, "Cleaning up after banzai AI melee." );
	
	// Kill the loser (if still around) and restore the state of the winner (if still around).
	
	if ( IsAlive( attacker ) )
	{
		attacker AnimMode( "none" );
		attacker OrientMode( "face default" );
		attacker.syncedMeleeTarget = undefined;

		if ( !attackerSucceeds )
		{
			if ( banzai_melee_interrupted( attacker, defender ) )
			{
				attacker.deathFunction = ::banzai_interrupted_death;
			}
			else
			{
				attacker.a.nodeath = true;
			}
			
			attacker do_kill_damage( attacker.origin, defender );
			attacker DropAllAIWeapons();
		}
		attacker.inBanzaiMelee = false;
		attacker.amBanzaiAttacking = false;
	}
	else
	{
		attacker StartRagdoll();
	}
	
	if ( IsAlive( defender ) )
	{
		defender AnimMode( "none" );
		defender OrientMode( "face default" );
		defender.syncedMeleeTarget = undefined;

		if ( attackerSucceeds )
		{
			if ( banzai_melee_interrupted( attacker, defender ) )
			{
				defender.deathFunction = ::banzai_interrupted_death;
			}
			else
			{
				defender.a.nodeath = true;
			}
			
			defender do_kill_damage( defender.origin, attacker );
			defender DropAllAIWeapons();
		}
		defender.inBanzaiMelee = false;
		defender remove_banzai_attacker( attacker );
	}
	else
	{
		defender StartRagdoll();
	}
		
	if ( IsAlive( attacker ) && attacker.health > 0 )
	{
		attacker thread continue_exposed_combat();
	}
	
	/#
	if ( debug_banzai() )
	{
		attacker notify( "end_report_damage" );
		defender notify( "end_report_damage" );
	}
	#/
}

banzai_interrupted_death()
{
	self DropAllAIWeapons(); 
	self StartRagdoll();
	wait 0.5;
	return true;
}

notify_if_either_interrupted( attacker, defender )
{
	attacker.banzai_melee_interrupted = undefined;
	defender.banzai_melee_interrupted = undefined;
	self thread notify_if_interrupted( attacker, defender );
	self thread notify_if_interrupted( defender, attacker );
}

notify_if_interrupted( interruptee, enemy )
{
	self endon( "banzai_melee_ended_on_time" );
	
	interruptee waittill_either( "pain", "death" );
	
	if ( IsDefined( interruptee ) )
	{
		banzai_print( undefined, undefined, "interuptee: " + interruptee GetEntityNumber() + " notify_if_interrupted handling pain/death notification." );
	}
	
	self notify( "banzai_melee_interrupted" );
	
	if ( IsDefined( interruptee ) )
	{
		interruptee.banzai_melee_interrupted = true;
		interruptee notify( "banzai_melee_interrupted" );
	}
	
	if ( IsDefined( enemy ) )
	{
		enemy.banzai_melee_interrupted = true;
		enemy notify( "banzai_melee_interrupted" );
	}
}

banzai_melee_interrupted( attacker, defender )
{
	if ( IsDefined( attacker.banzai_melee_interrupted ) && attacker.banzai_melee_interrupted ) 
		return true;
		
	if ( IsDefined( defender.banzai_melee_interrupted ) && defender.banzai_melee_interrupted ) 
		return true;
		
	return false;
}

notify_when_melee_over( meleeLength )
{
	self endon( "banzai_melee_interrupted" );
	wait( meleeLength );
	self notify( "banzai_melee_ended_on_time" );
}

debug_banzai_link( enemy )
{
	elapsed = 0;
	
	while ( elapsed <= level.banzai_unlink_time + 0.25 )
	{
		print_entities( self, enemy, elapsed );
		elapsed += 0.05;
		wait 0.05;
		if ( !IsDefined( enemy ) || !IsAlive( enemy ) )
		{
			banzai_print( enemy, self, "Banzai attacker removed." );
			return;
		}
		if ( !IsDefined( self ) || !IsAlive( self ) )
		{
			banzai_print( enemy, self, "Banzai defender removed." );
			return;
		}
	}
}

print_entities( defender, attacker, index )
{
	if ( IsDefined( attacker ) && IsAlive( attacker ) )
		attacker print_position( "attacker", index );
	
	if ( IsDefined( defender ) && IsAlive( defender ) )
		defender print_position( "defender", index );
	
	banzai_print( attacker, defender, "" );
}

print_position( label, index )
{
	pos = self.origin;
	rot = self.angles;
	syncPos = self GetTagOrigin( "tag_sync" );
	syncRot = self GetTagAngles( "tag_sync" );
	banzai_print( undefined, undefined, "Banzai " + label + " origin " + index + ": " + pos + "  /  " + rot );
	banzai_print( undefined, undefined, "Banzai " + label + " sync   " + index + ": " + syncPos + "  /  " + syncRot );
}

print_script_origin( scriptOrigin, label, duration )
{
	elapsed = 0;
	while ( elapsed <= duration )
	{
		pos = scriptOrigin.origin;
		rot = scriptOrigin.angles;
		banzai_print( undefined, undefined, "Banzai " + label + " script origin " + elapsed + ": " + pos + "  /  " + rot );
		elapsed += 0.05;
		wait 0.05;
	}
}

banzai_ai_defender_link( attacker, blendTime )
{
	self endon( "death" );
	
	//self thread debug_banzai_link( attacker );
	
	// Hold the defender still while we lerp the attacker to the right place.
	
	lerpTarget = spawn( "script_origin", self.origin );
	//level thread print_script_origin( lerpTarget, "defender", level.banzai_link_time );
	self linkto( lerpTarget );
		
	wait( level.banzai_link_time );	
		
	if ( IsDefined( self ) && IsAlive( self ) )
		self unlink();
		
	lerpTarget delete();
	
	if ( !IsDefined( self ) || !IsAlive( self ) || !IsDefined( attacker ) || !IsAlive( attacker ) )
		return;
	
	// Now that both are in place, lock the defender to the attacker until
	// the loser ragdolls, at which point we have to unlink or else the
	// combination of the ragdoll's physics, the attacker's gravity animmode
	// and the linking of the attacker to the defender causes the defender
	// to briefly pop up to stand on top of the dying loser.
	
	self linkto( attacker, "tag_sync", (0,0,0), (0,0,0) );

	banzai_print( attacker, self, "Starting banzai_ai_defender_unlink threads." );

	self thread banzai_ai_defender_unlink_on_time();		
	self thread banzai_ai_defender_unlink_on_interrupt();		
}

banzai_ai_defender_unlink_on_time()
{
	self endon( "banzai_ai_defender_unlinked_on_interrupt" );
	
	timeToUnlink = level.banzai_unlink_time - level.banzai_link_time;
	if ( timeToUnlink > 0 )
	{
		wait( timeToUnlink );
	}

	// Must send notify even if the unlink doesn't happen because we're already gone.
	self notify( "banzai_ai_defender_unlinked_on_time" );

	if ( IsDefined( self ) )
	{
		banzai_print( undefined, self, "Unlinking defender from attacker on time." );
		self unlink();	
	}
}

banzai_ai_defender_unlink_on_interrupt()
{
	self endon( "banzai_ai_defender_unlinked_on_time" );
	
	self waittill( "banzai_melee_interrupted" );

	// Must send notify even if the unlink doesn't happen because we're already gone.
	self notify( "banzai_ai_defender_unlinked_on_interrupt" );

	if ( IsDefined( self ) )
	{
		banzai_print( undefined, self, "Unlinking defender from attacker due to interrupt." );
		self unlink();	
	}
}

lerp_to_tag_sync( enemy, blendTime )
{
	if ( !IsDefined( self ) || !IsAlive( self ) || !IsDefined( enemy ) || !IsAlive( enemy ) )
		return;

	// During the run in, we lerp the attacker to the point of contact.
	
	lerpee = spawn( "script_origin", self.origin );
	//level thread print_script_origin( lerpee, "attacker", level.banzai_link_time );	
	self linkto( lerpee );
	
	enemyToSelf = self.origin - enemy.origin;
	unitEnemyToSelf = VectorNormalize( enemyToSelf );
	targetPos = enemy.origin + unitEnemyToSelf * level.banzai_link_distance; 
	
	lerpee MoveTo( targetPos, level.banzai_link_time - 0.05, 0.05, 0);

	banzai_print( self, enemy, "Starting banzai_ai_attacker_unlink threads." );
	
	self thread banzai_ai_attacker_unlink_on_time( lerpee );
	self thread banzai_ai_attacker_unlink_on_interrupt( lerpee );
}

banzai_ai_attacker_unlink_on_time( lerpOrigin )
{
	self endon( "banzai_ai_attacker_unlinked_on_interrupt" );
	
	wait( level.banzai_link_time );

	// Must send notify even if the unlink doesn't happen because we're already gone.
	self notify( "banzai_ai_attacker_unlinked_on_time" );

	if ( IsDefined( self ) )
	{
		banzai_print( self, undefined, "Unlinking attacker from lerp script origin on time." );
		self unlink();
	}
		
	lerpOrigin delete();
}

banzai_ai_attacker_unlink_on_interrupt( lerpOrigin )
{
	self endon( "banzai_ai_attacker_unlinked_on_time" );
	
	self waittill( "banzai_melee_interrupted" );

	// Must send notify even if the unlink doesn't happen because we're already gone.
	self notify( "banzai_ai_attacker_unlinked_on_interrupt" );

	if ( IsDefined( self ) )
	{
		banzai_print( self, undefined, "Unlinking attacker from lerp script origin due to interrupt." );
		self unlink();
	}
		
	lerpOrigin delete();
}

play_banzai_ai_attacker_anim( anim_to_play, blendTime )
{
	if ( !IsDefined( self ) || !IsAlive( self ) )
	{
		banzai_print( self, self.syncedMeleeTarget, "Banzai attacker died before attacker animation could start." );
		return;
	}
		
	if ( !IsDefined( self.syncedMeleeTarget ) || !IsAlive( self.syncedMeleeTarget ) )
	{
		banzai_print( self, self.syncedMeleeTarget, "Banzai defender died before attacker animation could start." );
		return;
	}
		
	self thread lerp_to_tag_sync( self.syncedMeleeTarget, blendTime );
	
	self clearanim( %root, blendTime );
	self setflaggedanimknobrestart( "banzai_ai_anim", anim_to_play, 1, blendTime, 1 );	

	self DoNoteTracksUntilInterrupted( "banzai_ai_anim" );
}

play_banzai_ai_defender_anim( anim_to_play, blendTime )
{
	if ( !IsDefined( self ) || !IsAlive( self ) )
	{
		banzai_print( self.syncedMeleeTarget, self, "Banzai defender died before defender animation could start." );
		return;
	}
	
	if ( !IsDefined( self.syncedMeleeTarget ) || !IsAlive( self.syncedMeleeTarget ) )
	{
		banzai_print( self.syncedMeleeTarget, self, "Banzai attacker died before defender animation could start." );
		return;
	}
				
	self thread banzai_ai_defender_link( self.syncedMeleeTarget, blendTime );
	
	self clearanim( %root, blendTime );
	self setflaggedanimknobrestart( "banzai_ai_anim", anim_to_play, 1, blendTime, 1 );	
	
	self DoNoteTracksUntilInterrupted( "banzai_ai_anim" );
}

DoNoteTracksUntilInterrupted( animTag )
{
	self endon( "banzai_melee_interrupted" );
	self animscripts\shared::DoNoteTracks( animTag );
}

play_banzai_ai_attacker_anim_custom_script()
{
	anim_to_play = anim.banzai_meleeseq_ai_attacker[ level.banzai_ai_anim_index ];
	self play_banzai_ai_attacker_anim( anim_to_play, 0.1 );
}

play_banzai_ai_defender_anim_custom_script()
{
	anim_to_play = anim.banzai_meleeseq_ai_defender[ level.banzai_ai_anim_index ];
	self play_banzai_ai_defender_anim( anim_to_play, 0.1 );
}


// END BANZAI vs. AI
// START BANZAI vs. PLAYER



// The melee sequence goes:
// 1) first impact: Banzai runs into player, possibly pushing player back. Play shock. Player takes slight damage.
// 2) freedom: For a second or two, the attacker and defender are at melee distance, but not synchronized. Player or banzai can shoot/melee/whatever.
// 3) knockdown sequence: Banzai knocks down player. They go into synchronized last stand. Player either dies or kills banzai and gets up with original weapon restored.

banzai_attack_player( attacker, player )
{
	if ( !IsAlive( attacker ) )
	{
		return;
	}
	
	if ( !IsAlive( player ) || !player can_player_banzai_melee() || ( player in_banzai_attack() && player banzai_attacked_by( attacker ) ) )
	{
		if ( !player can_player_banzai_melee() )
			banzai_print( attacker, player, "Aborting banzai attack against player who cannot banzai melee." );

		if ( player in_banzai_attack() )
			banzai_print( attacker, player, "Aborting banzai attack against player who is already under attack." );

		return;
	}
				
	start_banzai_attack( attacker, player );
		
	continueAttack = initial_impact( attacker, player );
	
	// If player didn't survive, just move on.
	if ( !continueAttack )
	{
		banzai_print( attacker, player, "Aborting banzai melee because player was killed by initial impact." );
		end_banzai_attack( attacker, player );
		return;
	}
	
	// This is the window in which the player gets to stop the banzai from
	// knocking the player down.
	delay = 0.5;
	recordTime = delay - 0.05;
	
	if ( debug_banzai() )
	{
		attacker thread record_pain( recordTime );
		attacker thread record_death( recordTime );
		attacker thread record_killanimscript( recordTime );
	}
	else
	{
		attacker thread record_interruptions( recordTime );
	}
	
	wait( delay );	
	
	if ( may_knockdown( attacker, player ) ) 
	{
		knockdown( attacker, player );
	}
	else
	{
		end_banzai_attack( attacker, player );
	}
}

record_interruptions( timeToRecord )
{
	self endon( "pain" );
	self endon( "death" );
	self endon( "killanimscript" );
	
	self.banzaiInterrupted = true;
	wait( timeToRecord ); 
	self.banzaiInterrupted = false;
}

record_pain( timeToRecord )
{
	self endon( "pain" );
	
	self.banzaiInterruptedByPain = true;
	wait( timeToRecord );
	self.banzaiInterruptedByPain = false;
}

record_death( timeToRecord )
{
	self endon( "death" );
	
	self.banzaiInterruptedByDeath = true;
	wait( timeToRecord );
	self.banzaiInterruptedByDeath = false;
}

record_killanimscript( timeToRecord )
{
	self endon( "killanimscript" );
	
	self.banzaiInterruptedByKillAnimScript = true;
	wait( timeToRecord );
	self.banzaiInterruptedByKillAnimScript = false;
}

may_knockdown( attacker, player )
{
	if ( IsGodMode( player ) )
		return false;
	
	if ( get_players().size > 1 )
		return false;
		
	if ( !attacker can_attacker_banzai_melee() )
	{
		banzai_print( attacker, player, "Aborting knockdown because attacker cannot banzai melee." );
		return false;
	}
	
	if ( !player can_player_banzai_melee() )
	{
		banzai_print( attacker, player, "Aborting knockdown because player cannot banzai melee." );
		return false;
	}
	
	if ( IsDefined( player.usingturret ) && player.usingturret )
		return false;
		
	if ( IsDefined( player.usingvehicle ) && player.usingvehicle )
		return false;
	
	if ( debug_banzai() )
	{
		if ( attacker.banzaiInterruptedByPain )
		{
			banzai_print( attacker, player, "Aborting knockdown because attacker was interrupted by pain while waiting between attacks." );
			return false;
		}
		
		if ( attacker.banzaiInterruptedByDeath )
		{
			banzai_print( attacker, player, "Aborting knockdown because attacker was interrupted by death while waiting between attacks." );
			return false;
		}
		
		if ( attacker.banzaiInterruptedByKillAnimScript )
		{
			banzai_print( attacker, player, "Aborting knockdown because attacker was interrupted by killanimscript while waiting between attacks." );
			return false;
		}
	}
	else
	{	
		if ( attacker.banzaiInterrupted )
		{
			banzai_print( attacker, player, "Aborting knockdown because attacker was interrupted while waiting between attacks." );
			return false;
		}
	}
		
	return true;
}

in_banzai_melee()
{
	return ( IsDefined( self.inBanzaiMelee ) && self.inBanzaiMelee );
}

can_player_banzai_melee()
{
	if ( !IsAlive( self ) )
		return false;
		
	if ( self.health <= 0 )
		return false;
		
	if ( self in_banzai_melee() )
		return false;

	// CODER_MOD: Austin (9/5/08): added check for berserker mode
	if ( maps\_collectibles::has_collectible( "collectible_berserker" ) )
		if ( IsPlayer( self ) && self.collectibles_berserker_mode_on )
			return false;
		
	return true;
}

can_attacker_banzai_melee()
{
	if ( !can_player_banzai_melee() )
		return false;

	if ( !IsDefined( self.enemy ) )
		return false;

	enemyPoint = self.enemy GetOrigin();
	vecToEnemy = enemyPoint - self.origin;
	self.enemyDistanceSq = lengthSquared( vecToEnemy );
		
	if ( self.enemyDistanceSq > anim.meleeRangeSq )
		return false;

	if ( !animscripts\melee::isMeleePathClear( vecToEnemy, enemyPoint ) )
		return false;

	return true;
}

in_banzai_attack()
{
	if ( IsDefined( self.amBanzaiAttacking ) && self.amBanzaiAttacking )
		return true;
		
	if ( self has_banzai_attacker() )
		return true;
		
	return false;
}

can_take_part_in_banzai_attack()
{
	return ( IsAlive( self ) && !( self in_banzai_attack() ) );
}

has_banzai_attacker()
{
	return ( IsDefined( self.banzaiAttackers ) && self.banzaiAttackers.size > 0 );
}

banzai_attacked_by( attacker )
{
	for ( i = 0; i < self.banzaiAttackers.size; i++ )
	{
		if ( self.banzaiAttackers[i] == attacker )
		{
			return true;
		}
	}
	
	return false;
}

add_banzai_attacker( attacker )
{
	if ( !IsDefined( self.banzaiAttackers ) )
		self.banzaiAttackers = [];
		
	if ( IsDefined( level.banzai_debug ) )
	{
		if ( self banzai_attacked_by( attacker ) )
		{
			banzai_print( attacker, self, "WARNING: Attacker trying to attack someone he is already attacking." );
			return;
		}
	}
	
	self.banzaiAttackers[ self.banzaiAttackers.size ] = attacker;
}

remove_banzai_attacker( attacker )
{
	if ( !IsDefined( self.banzaiAttackers ) || self.banzaiAttackers.size == 0 )
	{
		banzai_print( attacker, self, "WARNING: Attacker already removed from this defender's attacker list." );
		return;
	}

	self.banzaiAttackers = array_remove( self.banzaiAttackers, attacker );	
}

start_banzai_attack( attacker, player )
{
	assert( IsAlive( attacker ) );
	assert( IsAlive( player ) );
	
	banzai_print( attacker, player, "Starting banzai vs. player attack." );

	attacker.amBanzaiAttacking = true;
	player add_banzai_attacker( attacker );
	
	// Hack to avoid crashing if the player dies and his cooking grenade is released.
	player DisableOffhandWeapons();

	attacker thread stop_banzai_yell();

	banzai_print( attacker, player, "Finished starting banzai vs. player attack." );
}

end_banzai_attack( attacker, player )
{
	if ( !IsDefined( attacker.amBanzaiAttacking ) || !attacker.amBanzaiAttacking )
		return;
	
	banzai_print( attacker, player, "Ending banzai vs. player attack." );
	
	player EnableOffhandWeapons();
	player remove_banzai_attacker( attacker );

	attacker.amBanzaiAttacking = false;
	if ( IsAlive( attacker ) )
	{
		attacker thread continue_exposed_combat();
	}
	
	banzai_print( attacker, player, "Finished ending banzai vs. player attack." );
	
	/#
	if ( debug_banzai() )
	{
		player notify( "end_report_damage" );
		attacker notify( "end_report_damage" );
	}
	#/
}

	
continue_exposed_combat()
{
	self endon( "killanimscript" );
	self endon( "death" );
	
	waitTime = 0.6 + RandomFloat( 0.4 );
	wait( waitTime );

	if ( self.health > 0 )
	{
		banzai_print( self, undefined, "Banzai continuing exposed combat." );
		self animMode("none");
		self thread animscripts\combat::main();
		scriptChange();
	}
}

initial_impact( attacker, player )
{
	// TODO: In straight God Mode (as opposed to Demigod Mode), this
	// should probably not play the player reaction. However we would
	// need a new set of animations in that case, and there is no way
	// currently to distinguish God Mode from Demigod Mode in scripts,
	// so since God Mode is non-shipping, we'll likely never get to this.

	if ( !IsGodMode( player ) )
	{
		player do_nonlethal_melee_damage( 30, attacker );	
	}

	if ( IsAlive(player) && ( player.health > 0 ) )
	{
		banzai_print( attacker, player, "Banzai initial impact." );

		player shellshock( "banzai_impact", 1 );
		
		if ( !IsGodMode( player )	)
		{
			damagePosition = ( attacker.origin + player.origin ) / 2;
			damagePosition = damagePosition + ( 0, 0, 12 ); // chest height	
			player ViewKick( 64, damagePosition );
			player play_banzai_rumble();
		}
		
		attacker play_thrust_sound();
		
		attacker play_attacker_impact();

		return true;
	}

	return false;
}

knockdown( attacker, player )
{
	assert( !IsGodMode( player ) );
	
	banzai_print( attacker, player, "Banzai attacker knocking down player." );
	
	// This messes up the rest of the script if it accidentally kills the player.
	//player do_nonlethal_melee_damage( 5, attacker );
		
	if ( !start_synchronized_melee( attacker, player ) )
		return;

	player play_banzai_rumble();
	attacker play_thrust_sound();

	player play_playerview_knockdown();

	// Attacker anim is choreographing (i.e., its notetracks are driving) this sequence.
	attacker play_attacker_knockdown();
}

do_nonlethal_melee_damage( damage, attacker )
{	
	// Make sure the victim isn't killed by the initial impact.
	damageFactor = 1 / getdvarfloat("player_meleeDamageMultiplier");
	if ( self.health - 1 <= damage )
	{
		damage = self.health - 1;
	}
	
	actualDamage = damage * damageFactor;
	damagePosition = ( attacker.origin + self.origin ) / 2;
	damagePosition = damagePosition + ( 0, 0, 12 ); // chest height	
	
	banzai_print( attacker, self, "Doing (hopefully) non-lethal damage of amount " + actualDamage + "." ); 

	self DoDamage( actualDamage, damagePosition, attacker, undefined, "melee" );
}

do_kill_damage( position, inflictor )
{
	killDamage = self.health * 10 + 1000;
	
	if ( IsDefined( inflictor ) )
	{
		banzai_print( undefined, undefined, "Inflictor " + inflictor GetEntityNumber() + " doing damage of amount " + killDamage + " to entity " + self getEntityNumber() + "." );
		self DoDamage( killDamage, position, inflictor );
	}
	else
	{
		banzai_print( undefined, undefined, "Doing damage of amount " + killDamage + " to entity " + self getEntityNumber() + "." );	 
		self DoDamage( killDamage, position );
	}
		
}

handleBanzaiKnockdownNoteTracks( note )
{	
	player = self.syncedMeleeTarget;
	
	if ( !IsDefined( player ) || !IsAlive( player ) || !IsDefined( self ) || !IsAlive( self ) )
	{
		return;
	}
	
	banzai_print( self, player, "Handling banzai knockdown note: " + note );
	
	switch( note )
	{
		case "banzai_knockdown":
		{
			self knockedDownSequence( self, player );
		}
		break;
	}
}

time_scale_machine_restore()
{
	self waittill_any ("endBanzaiLastStand", "timescale_off");
	SetTimeScale(1);
}
time_scale_machine()
{
	self endon( "timescale_off" );
	players = GetPlayers();
	if(players.size != 1 || IsSplitScreen() )
		return;
	
	if ( GetPersistentProfileVar(1,1) == 1 )
	{
		self notify( "timescale_off" );
		return;
	}
		
	self.firstTime = true;
	SetPersistentProfileVar(1,1);
	UpdateGamerProfile();
		
	SetTimeScale(0.1);
	wait(0.35);
	self notify( "timescale_off" );
}

handleBanzaiLastStandNoteTracks( note )
{	
	player = self.syncedMeleeTarget;
	
	if ( !IsDefined( player ) || !IsAlive( player ) || !IsDefined( self ) || !IsAlive( self ) )
	{
		return;
	}
	
	banzai_print( self, player, "Handling banzai last stand note: " + note );

	switch( note )
	{
		case "banzai_loom":
		{
			player.firstTime = false;
			player thread time_scale_machine();
			player thread time_scale_machine_restore();
			self thread banzai_last_stand( self, player );
		}
		break;
	
		case "banzai_kill":
		{
			play_banzai_rumble();
			player notify( "timescale_off" );
			if ( delayed_player_success() )
			{
				self notify( "endBanzaiLastStand" );
				level thread hideBanzaiHint(player);
			}
			else
			{
				self thread last_stand_player_failed( self, player );
			}
		}
		break;
	}
}

handleBanzaiFailedNoteTracks( note )
{	
	player = self.syncedMeleeTarget;
	
	if ( !IsDefined( player ) || !IsAlive( player ) || !IsDefined( self ) || !IsAlive( self ) )
	{
		return;
	}
	
	banzai_print( self, player, "Handling banzai failed note: " + note );
	
	switch( note )
	{
		case "stab_wound":
		{
			if ( is_mature() )
				playfxontag( level._effects[ "stab_wound" ], self, "j_neck" );
		}
		break;
	}
}

knockedDownSequence( attacker, player )
{
	player play_playerview_intro();
	attacker play_attacker_intro( player );
}

player_attacking( player )
{
	return isalive( player ) && ( player MeleeButtonPressed() );
}

banzai_last_stand( attacker, player )
{
	attacker notify( "startBanzaiLastStand" );
	attacker endon( "endBanzaiLastStand" );
	
	level thread showBanzaiHint(player);
	
	if ( !allow_mashing() )
	{
		thread record_late_attacks( attacker, player );
	
		if ( player.banzaiAttackedTooEarly )
		{
			// Only get one chance to shoot once the banzai melee sequence starts. 
			// Fire before the knockdown is complete, and you're hosed.
			return;
		}
	}
		
	// If player fires in time, attacker dies and player gets back up.
	// If player does not fire in time, attacker stabs player repeatedly, killing the player.
	
	// Wait until player lets go of trigger before registering the next attack.
	while ( player_attacking( player ) )
	{
		wait( 0.05 );
	}
	
	player.attackedBanzai = false;
	
	while ( IsAlive(attacker) && IsDefined( attacker.inBanzaiMelee ) && attacker.inBanzaiMelee )
	{
		if ( player_attacking( player ) )
		{
			// Hide the hint when the player presses the button, regardless of whether or not
			// we're delaying the success anim until the current anim is finished.
			level thread hideBanzaiHint( player );
			player notify( "timescale_off" );
			
			if ( delayed_player_success() )
			{
				player.attackedBanzai = true;
			}
			else
			{
				last_stand_attacker_failed( attacker, player );
			}
			return;
		}

		wait( 0.05 );
	}
}

last_stand_attacker_failed( attacker, player )
{
	banzai_print( attacker, player, "Player won last stand." );
	
	attacker.banzaiKilled = true;
	
	player play_playerview_banzai_failed();
	attacker play_attacker_banzai_failed();
	
	level thread kill_attacker( attacker, player );
	
	end_synchronized_melee( attacker, player );
	end_banzai_attack( attacker, player );	
}

kill_attacker( attacker, player )
{
	attacker setcandamage( true );
	attacker.a.nodeath = true;
	
	attacker DropAllAIWeapons();
	
	dif = player.origin - attacker.origin;
	dif = ( dif[ 0 ], dif [ 1 ], 0 );
	arcademode_assignpoints( "arcademode_score_banzai", player );
	attacker do_kill_damage( attacker geteye() - dif, player );
	player giveAchievement("ANY_ACHIEVEMENT_BANZAI");	
}

last_stand_player_failed( attacker, player )
{	
	banzai_print( attacker, player, "Player lost last stand." );
	
	if ( IsAlive( attacker ) )
	{
		if ( attacker.inBanzaiMelee )
		{
			if ( !delayed_player_success() )
			{
				attacker notify( "endBanzaiLastStand" );
				level thread hideBanzaiHint(player);
			}
	 	 	
			player play_banzai_rumble();
	 	 	attacker play_thrust_sound();

			// If the final anim is interrupted for any reason (i.e., we never reach
			// the kill_player() call below), make sure to kill the player upon 
			// receiving the killanimscript notify.
			player.banzaiKilled = true;

			player play_playerview_banzai_succeeded();
			attacker play_attacker_banzai_succeeded();
	 	 	
	 	 	level thread kill_player( player );

	  	end_synchronized_melee( attacker, player );
	  }
	  else
	  {
	  	banzai_print( attacker, player, "Couldn't finish synchronized melee because attacker was no longer in synchronized melee." );
	  }
	  
	  end_banzai_attack( attacker, player );
	}
  else
  {
  	banzai_print( attacker, player, "Couldn't finish synchronized melee because attacker was dead." );
  }
}

play_thrust_sound()
{
	self PlaySound( "generic_thrust_japanese" );
	self PlaySound( "melee_swing" );
}

play_banzai_rumble()
{
	self PlayRumbleOnEntity( "damage_heavy" );
}

record_early_attacks( attacker, player )
{
	attacker endon( "startBanzaiLastStand" );
	
	while (1)
	{
		if ( player_attacking( player ) )
		{
			player.banzaiAttackedTooEarly = true;
			break;
		}
		
		wait( 0.05 );
	}
}

record_late_attacks( attacker, player )
{
	attacker endon( "killanimscript" );
	
	while (1)
	{
		if ( player_attacking( player ) )
		{
			player.banzaiAttackedTooLate = true;
			break;
		}
		
		wait( 0.05 );
	}
}

// CRITICAL SECTION: No yields or waits of any kind allowed here.
do_start_synchronized_melee( attacker, player )
{		
	assert( IsDefined( attacker ) && IsAlive( attacker ) );
	assert( IsDefined( player ) && IsAlive( player ) );
	assert( !IsDefined( player.player_view ) || !IsDefined( player.player_view.inSeq ) );
	
	if ( attacker in_banzai_melee() )
	{
		banzai_print( attacker, player, "do_start_synchronized_melee() failed because attacker couldn't banzai melee." );
		return false;
	}
		
	if ( player in_banzai_melee() )
	{
		banzai_print( attacker, player, "do_start_synchronized_melee() failed because player couldn't banzai melee." );
		return false;
	}

	if( IsDefined( player.player_view ) && IsDefined( player.player_view.inSeq ) )
	{
		banzai_print( attacker, player, "do_start_synchronized_melee() failed because player_view was already in a synchronized animation." );
		return false;
	}
		
	attacker OrientMode("face enemy");
	attacker setcandamage( false );

	if ( !allow_mashing() )
	{
		player.banzaiAttackedTooEarly = false;
		player.banzaiAttackedTooLate = false;
		thread record_early_attacks( attacker, player );
	}

	attacker clearanim(%root, 0.1);
	attacker clearpitchorient();

	attacker.syncedMeleeTarget = player;
	
	if ( !isdefined( player.player_view ) )
	{
		banzai_print(attacker, player, "Spawning banzai player view.");
		player.player_view = PlayerView_Spawn(player);
	}

	player notify( "banzai_attacks_player" );
	player.player_view.inSeq = true;
	
	setsaveddvar( "hud_drawhud", 0 );
	
	player setstance( "stand" );
	player.syncedMeleeTarget = attacker;
	player.player_view PlayerView_Show(player);
	
	direction = attacker.origin - player.origin;
	player.player_view.angles = vectortoangles( direction );
	player.player_view.angles = ( 0, player.player_view.angles[1], 0 );	

	playerpos = player.origin;
	player.player_view.origin = playerphysicstrace( ( playerpos[ 0 ], playerpos[ 1 ], playerpos[ 2 ] + 50 ), ( playerpos[ 0 ], playerpos[ 1 ], playerpos[ 2 ] - 200 ) );
		
	player playerLinkToAbsolute( player.player_view, "tag_player" );
	attacker linkto( player.player_view, "tag_sync", (0, 0, 0), (0, 0, 0) );
	
	syncTagAngles = player.player_view gettagangles( "tag_sync" );
	attacker orientmode( "face angle", syncTagAngles[ 1 ] );
	attacker orientmode( "face default" );
	
	player allowLean( false );
	player allowCrouch( false );
	player allowProne( false );
	player allowJump( false );
	player allowMelee( false );
	player freezeControls( true );
	
	player EnableInvulnerability();
	
	return true;
}

start_synchronized_melee( attacker, player )
{
	banzai_print( attacker, player, "Starting synchronized melee." );
		
	meleeStarted = do_start_synchronized_melee( attacker, player );

	if ( meleeStarted )
	{	
		player.inBanzaiMelee = true;
		attacker.inBanzaiMelee = true;
	
		attacker thread make_sure_end_synchronized_melee_on_killanimscript( attacker, player );
		player thread make_sure_end_synchronized_melee_on_killanimscript( attacker, player );
					
		banzai_print( attacker, player, "Finished starting synchronized melee." );
		return true;
	}
	
	banzai_print( attacker, player, "Aborted synchronized melee." );
	return false;
}				

make_sure_end_synchronized_melee_on_killanimscript( attacker, player )
{
	self endon( "synchronized_melee_ended" );
	self waittill( "killanimscript" );
	self thread do_synchronized_melee_cleanup( attacker, player );
}

do_synchronized_melee_cleanup( attacker, player )
{
	banzai_print( attacker, player, "Banzai vs. player melee sequence interrupted." );

	if ( IsDefined( player.banzaiKilled ) && player.banzaiKilled )
	{
		player.banzaiKilled = undefined;
		level thread kill_player( player );
	}
	
	if ( IsDefined( attacker.banzaiKilled ) && attacker.banzaiKilled )
	{
		attacker.banzaiKilled = undefined;
		level thread kill_attacker( attacker, player );
	}
	
	end_synchronized_melee( attacker, player );
	end_banzai_attack( attacker, player );
}

do_end_synchronized_melee( attacker, player )
{
	setsaveddvar( "hud_drawhud", 1 );
	
	player PlayerView_Hide( player );
		
	player DisableInvulnerability();

	player unlink();
	attacker unlink();
	
	if ( IsDefined( player.banzaiDefenseWeapon ) )
	{
		player.banzaiDefenseWeapon delete();
	}

	assert( IsDefined( player.player_view ) );
	if ( IsDefined( player.player_view ) )
	{
		player setOrigin( player.player_view.origin );
		player.player_view.inSeq = undefined;
		player.player_view delete();	// delete self
	}
	
	angles = player getplayerangles();
	player setplayerangles( (0, angles[1], 0) );

	player.syncedMeleeTarget = undefined;
	
	player allowLean( true );
	player allowCrouch( true );
	player allowProne( true );
	player allowJump( true );
	player allowMelee( true );
	player freezeControls( false );
	
	if ( IsAlive( attacker ) )
	{
		attacker.syncedMeleeTarget = undefined;
		attacker setCanDamage( true );
	}
	
	level thread hideBanzaiHint(player); // In case the anim sequence was interrupted.
}

end_synchronized_melee( attacker, player )
{
	banzai_print( attacker, player, "Trying to end banzai vs. player synchronized melee." );
	
	if( !IsDefined(player) || !IsDefined( player.inBanzaiMelee ) || !player.inBanzaiMelee )
	{
		if ( !IsDefined( player ) )
			banzai_print( attacker, player, "WARNING: Player removed before end_synchronized_melee could execute." );
		return; // do nothing if this has already been called for this particular banzai attack
	}
	
	banzai_print( attacker, player, "Ending banzai vs. player synchronized melee." );
	
	do_end_synchronized_melee( attacker, player );
	
	attacker.inBanzaiMelee = false;
	player.inBanzaiMelee = false;

	player notify( "synchronized_melee_ended" );
	attacker notify( "synchronized_melee_ended" );
	
	banzai_print( attacker, player, "Finished ending banzai vs. player synchronized melee." );
}

play_attacker_anim( index )
{
	//banzai_print( self, self.syncedMeleeTarget, "Banzai attacker anim ", anim.banzai_meleeseq_player_attacker[index], " has length " + GetAnimLength( anim.banzai_meleeseq_player_attacker[index] ) ); 
	self setflaggedanimknobrestart( "banzai_attacker_anim", anim.banzai_meleeseq_player_attacker[index], 1, 0.2, 1 );
}

play_attacker_impact()
{
	play_attacker_anim( 0 );
}

play_attacker_knockdown()
{
	play_attacker_anim( 1 );
	self animscripts\shared::DoNoteTracks( "banzai_attacker_anim", ::handleBanzaiKnockdownNoteTracks );
}

play_attacker_intro( player )
{
	play_attacker_anim( 2 );
	self animscripts\shared::DoNoteTracks( "banzai_attacker_anim", ::handleBanzaiLastStandNoteTracks );
			
	if ( delayed_player_success() )
	{
		if ( IsDefined( player.attackedBanzai ) && player.attackedBanzai )
		{
			self thread last_stand_attacker_failed( self, player );
		}
		else
		{
			self thread last_stand_player_failed( self, player );
		}
	}
}

play_attacker_banzai_failed()
{
	play_attacker_anim( 3 );
	self animscripts\shared::DoNoteTracks( "banzai_attacker_anim", ::handleBanzaiFailedNoteTracks );
}

play_attacker_banzai_succeeded( player )
{
	play_attacker_anim( 4 );
	self waittillmatch( "banzai_attacker_anim", "end");
}

get_banzai_player_anim_length( stage )
{
	return GetAnimLength( anim.banzai_meleeseq_player[stage] );
}

get_banzai_player_attacker_anim_length( stage )
{
	return GetAnimLength( anim.banzai_meleeseq_player_attacker[stage] );
}

kill_player( player, delay )
{
	if ( IsDefined( delay ) )
	{
		wait( delay );
	}
	
	if ( !IsAlive( player ) )
	{
		banzai_print( player.syncedMeleeTarget, player, "Tried to kill player at end of banzai attack, but player was already dead." );
		return;
	}
	
	banzai_print( undefined, player, "Killing player at end of banzai attack." );
	
	player enableHealthShield( false );
	player.specialDeath = true;
	
	player DisableInvulnerability();
	
	damagePosition = player.origin + ( 0, 0, 10 );
	player do_kill_damage( damagePosition ); // set damage position to player origin to avoid knockback
	player shellshock("default", 4);
	
	waittillframeend; // so quote gets set after _quotes sets it
	setDvar( "ui_deadquote", "" );
	
	wait( 1.6 );
	level.banzaiDeathHint = &"SCRIPT_PLATFORM_BANZAI_DEATH_DO_NOTHING";

	if ( IsDefined( player.banzaiAttackedTooEarly ) && player.banzaiAttackedTooEarly )
	{
		level.banzaiDeathHint = &"SCRIPT_PLATFORM_BANZAI_DEATH_TOO_SOON";
	}
	else if ( IsDefined( player.banzaiAttackedTooLate ) && player.banzaiAttackedTooLate )
	{
		level.banzaiDeathHint = &"SCRIPT_PLATFORM_BANZAI_DEATH_TOO_LATE";
	}
	
	thread banzai_deathquote(player);
}

banzai_deathquote(player)
{
	textOverlay = maps\_hud_util::createFontString( "default", 1.75, player );
	textOverlay.color = (1,1,1);
	textOverlay setText( level.banzaiDeathHint );
	textOverlay.x = 0;
	textOverlay.y = -30;
	textOverlay.alignX = "center";
	textOverlay.alignY = "middle";
	textOverlay.horzAlign = "center";
	textOverlay.vertAlign = "middle";
	textOverlay.foreground = true;
	textOverlay.alpha = 0;
	textOverlay fadeOverTime( 1 );
	textOverlay.alpha = 1;
	
	thread hide_banzai_deathquote( textOverlay );
}

hide_banzai_deathquote( textOverlay )
{
	wait( 4 );
	textOverlay fadeOverTime( 0.5 );
	textOverlay.alpha = 0;
	wait( 0.55 );
	textOverlay destroy();
}

showBanzaiHint(player)
{
	level endon ( "clearing_banzai_hint" );
	
	if(!isdefined(level.banzaiHintElem))
	{
		level.banzaiHintElem = [];
	}
	
	num = player GetEntityNumber();
	
	if ( isDefined( level.banzaiHintElem[num] ) )
		level.banzaiHintElem[num] maps\_hud_util::destroyElem();

	level.banzaiHintElem[num] = maps\_hud_util::createFontString( "default", 2, player );
	level.banzaiHintElem[num].color = (1,1,1);
	if ( player.firstTime )
		level.banzaiHintElem[num] setText( &"SCRIPT_PLATFORM_BANZAI_DEATH_TOO_LATE" );
	else
		level.banzaiHintElem[num] setText( &"SCRIPT_PLATFORM_BANZAI_HINT" );
	level.banzaiHintElem[num].x = 0;
	level.banzaiHintElem[num].y = 20;
	level.banzaiHintElem[num].alignX = "center";
	level.banzaiHintElem[num].alignY = "middle";
	level.banzaiHintElem[num].horzAlign = "center";
	level.banzaiHintElem[num].vertAlign = "middle";
	level.banzaiHintElem[num].foreground = true;
	level.banzaiHintElem[num].alpha = 1;
	level.banzaiHintElem[num] endon ( "death" );
}

hideBanzaiHint(player)
{
	if ( isDefined( level.banzaiHintElem ) )
	{
		num = player GetEntityNumber();
		
		if(isdefined(level.banzaiHintElem[num]))
		{		
			level notify ( "clearing_banzai_hint" );
			level.banzaiHintElem[num] maps\_hud_util::destroyElem();
			level.banzaiHintElem[num] = undefined;
		}
	}
}

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
#using_animtree( "player" );

// This is separated into this section to take advantage of the #using_animtree( "player" )
banzai_init_player_anims()
{
	anim.banzai_meleeseq_player = [];
	anim.banzai_meleeseq_player[anim.banzai_meleeseq_player.size] = %int_bonzai_attack_player_impact;
	anim.banzai_meleeseq_player[anim.banzai_meleeseq_player.size] = %int_bonzai_attack_player;
	anim.banzai_meleeseq_player[anim.banzai_meleeseq_player.size] = %int_bonzai_attack_player_intro;
	anim.banzai_meleeseq_player[anim.banzai_meleeseq_player.size] = %int_bonzai_attack_player_fail;
	anim.banzai_meleeseq_player[anim.banzai_meleeseq_player.size] = %int_bonzai_attack_player_success;
}

PlayerView_Spawn(player)
{
	playerView = spawn( "script_model", player.origin );
	playerView.angles = player.angles;
	playerView setModel( level.player_interactive_hands );
	playerView useAnimTree( #animtree );

	weapon = spawn( "script_model", playerView gettagorigin( "tag_weapon" ) );

	weapon setmodel( "weapon_usa_kbar_knife" );
	weapon linkto( playerView, "tag_weapon", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	player.banzaiDefenseWeapon = weapon;

	playerView hide();
	
	return playerView;
}

PlayerView_Show(player)
{
	self show();
	player hideViewModel();
	player disableweapons();
}

PlayerView_Hide(player)
{
	player endon( "death" );
	player showViewModel();
	player enableweapons();
}

play_playerview_anim( index )
{
	assert( IsDefined( self.player_view ) );
	
	animToPlay = anim.banzai_meleeseq_player[index];
	//banzai_print( self.syncedMeleeTarget, self, "Banzai player anim ", animToPlay, " has length " + GetAnimLength( animToPlay ) ); 

	self.player_view setflaggedanimknobrestart( "banzaistep", animToPlay);
}

play_playerview_knockdown()
{
	play_playerview_anim( 1 );
}

play_playerview_intro()
{
	play_playerview_anim( 2 );
}

play_playerview_banzai_failed()
{
	play_playerview_anim( 3 );
}

play_playerview_banzai_succeeded()
{
	play_playerview_anim( 4 );
}
