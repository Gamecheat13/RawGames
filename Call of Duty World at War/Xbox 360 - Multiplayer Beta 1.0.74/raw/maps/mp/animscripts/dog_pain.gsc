//#using_animtree ("dog");
#include maps\mp\animscripts\utility;

main()
{
	debug_anim_print("dog_pain::main() " );

	self endon("killanimscript");
	self SetAimAnimWeights( 0, 0 );

	if ( isdefined( self.enemy ) && isdefined( self.enemy.syncedMeleeTarget) && self.enemy.syncedMeleeTarget == self )
	{
		self unlink();
		self.enemy.syncedMeleeTarget = undefined;
	}
	
////	self clearanim(%root, 0.2);
////	self setflaggedanimrestart("dog_pain_anim", %german_shepherd_run_pain, 1, 0.2, 1);
	speed = length( self getvelocity() );
	 
	pain_anim = getAnimDirection( self.damageyaw );

	// should only do this while running because the anim is supposed to while running
	if ( speed > level.dogRunPainSpeed )
	{
			pain_anim = "pain_run_" + pain_anim;
	}
	else
	{
			pain_anim = "pain_" + pain_anim;
	}	
	
	self setanimstate( pain_anim );
	
////	self animscripts\shared::DoNoteTracks( "dog_pain_anim" );
	self maps\mp\animscripts\shared::DoNoteTracksForTime(0.2, "done");
	//self maps\mp\animscripts\shared::DoNoteTracks( "done" );
}

