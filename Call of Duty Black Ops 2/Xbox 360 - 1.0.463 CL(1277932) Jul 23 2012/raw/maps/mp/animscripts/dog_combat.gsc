#include common_scripts\utility;
#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;

main()
{
	debug_anim_print("dog_combat::main() " );

	self endon("killanimscript");
	self SetAimAnimWeights( 0, 0 );

/#
	if( !debug_allow_combat() )
	{
		combatIdle();
		return;
	}
#/

	if ( isDefined( level.hostMigrationTimer ) )
	{
		combatIdle();
		return;
	}


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
	self animMode( "zonly_physics", 0 );
	
	idleAnims = [];
	idleAnims[ 0 ] = "combat_attackidle";
	idleAnims[ 1 ] = "combat_attackidle_bark";
	idleAnims[ 2 ] = "combat_attackidle_growl";
	idleAnim = random( idleAnims );
	
	debug_anim_print("dog_combat::combatIdle() - Setting " + idleAnim );
	self setanimstate( idleAnim );
	self maps\mp\animscripts\shared::DoNoteTracks( "done" );
	debug_anim_print("dog_combat::combatIdle() - " + idleAnim + " notify done." );
}

meleeBiteAttackPlayer(player)
{
	self set_orient_mode("face enemy");
	self animMode( "gravity", 0 );

	self.safeToChangeScript = false;

	if ( use_low_attack() )
	{
		// this is a hack using an existing anim to try and do a short range
		// ground based attack
		self animMode("angle deltas", 0);
		self setanimstate( "combat_attack_player_close_range" );
				
		self maps\mp\animscripts\shared::DoNoteTracksForTime( 1.4, "done" );
				
		self animMode( "gravity", 0 );
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
		
	self.safeToChangeScript = true;
	self animMode("none", 0);
}

handleMeleeBiteAttackNoteTracks( note, player )
{
	if ( note == "dog_melee" )
	{
		self Melee( AnglesToForward( self.angles ) );
	}
}

use_low_attack(player)
{
/*	height_diff = self.enemy_attack_start_origin[2] - self.origin[2];
	
	low_enough = 30.0;	

 	if ( height_diff < low_enough && self.enemy_attack_start_stance == "prone" )
 	{
 		return true;
 	}

	// check if the jumping melee attack origin would be in a solid
	melee_origin = ( self.origin[0], self.origin[1], self.origin[2] + 65 );
	enemy_origin = ( self.enemy.origin[0], self.enemy.origin[1], self.enemy.origin[2] + 32 );

	if ( !BulletTracePassed( melee_origin, enemy_origin, false, self ) )
	{
		return true;
	}
 */	
 	return false;
}