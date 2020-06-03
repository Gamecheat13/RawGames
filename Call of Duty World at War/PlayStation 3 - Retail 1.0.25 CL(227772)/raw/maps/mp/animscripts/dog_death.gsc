//#using_animtree ("dog");
#include maps\mp\animscripts\utility;

main()
{
	debug_anim_print("dog_death::main()" );
	self SetAimAnimWeights( 0, 0 );

	self endon("killanimscript");
	if ( isdefined( self.a.nodeath ) )
	{
		assertex( self.a.nodeath, "Nodeath needs to be set to true or undefined." );
		
		// allow death script to run for a bit so it doesn't turn to corpse and get deleted too soon during melee sequence
		wait 3;
		return;
	}

	self unlink();

	if ( isdefined( self.enemy ) && isdefined( self.enemy.syncedMeleeTarget ) && self.enemy.syncedMeleeTarget == self )
	{
		self.enemy.syncedMeleeTarget = undefined;
	}

	death_anim = "death_" + getAnimDirection( self.damageyaw );
/#
	println(death_anim);
#/
	
	self animMode( "gravity" );
	debug_anim_print("dog_death::main() - Setting " + death_anim );
	self setanimstate( death_anim );
	self maps\mp\animscripts\shared::DoNoteTracks( "done" );
}