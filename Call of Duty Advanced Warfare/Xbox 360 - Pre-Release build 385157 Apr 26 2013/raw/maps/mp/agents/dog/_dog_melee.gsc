#include maps\mp\agents\_scriptedAgents;

main()
{
	self endon( "death" );
	self endon( "killanimscript" );

	assert( IsDefined( self.curMeleeTarget ) );

	meleeAnimState = self GetMeleeAnimState();

	self PlayAnimUntilNotetrack( meleeAnimState, "attack", "dog_melee" );

	self.curMeleeTarget DoDamage( self.curMeleeTarget.health, self.origin, self, self );

	self.curMeleeTarget = undefined;	// dude's dead now, or soon will be.

	self WaitUntilNotetrack( "attack", "end" );
}

GetMeleeAnimState()
{
	return "attack_run_and_jump";
}