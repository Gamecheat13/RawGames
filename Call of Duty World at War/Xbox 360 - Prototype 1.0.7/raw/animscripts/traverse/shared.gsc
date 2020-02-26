#include animscripts\Utility;
#using_animtree ("generic_human");
advancedTraverse(traverseAnim, normalHeight)
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self.old_anim_movement = self.a.movement;
	self.old_anim_alertness = self.a.alertness;
	
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip"); // So he doesn't get stuck if the wall is a little too high
	
	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	realHeight = startnode.traverse_height - startnode.origin[2];
	
	self thread teleportThread(realHeight - normalHeight);
	
	blendTime = 0.15;
	
	self clearAnim( %body, blendTime );
	self setFlaggedAnimKnoballRestart( "traverse", traverseAnim, %root, 1, blendTime, 1 );
	
	gravityToBlendTime = 0.2;
	endBlendTime = 0.2;
	
	self thread animscripts\shared::DoNoteTracksForever( "traverse", "no clear" );
	if ( !animHasNotetrack( traverseAnim, "gravity on" ) )
	{
		magicWhateverTime_WhereTheHeckDidWeGetThisNumberAnyway = 1.23;
		wait ( magicWhateverTime_WhereTheHeckDidWeGetThisNumberAnyway - gravityToBlendTime );
		self traverseMode( "gravity" );
		wait ( gravityToBlendTime );
	}
	else
	{
		self waittillmatch( "traverse", "gravity on" );
		self traverseMode( "gravity" );
		if ( !animHasNotetrack( traverseAnim, "blend" ) )
			wait ( gravityToBlendTime );
		else
			self waittillmatch( "traverse", "blend" );
	}

	self.a.movement = self.old_anim_movement;
	self.a.alertness = self.old_anim_alertness;
	
	runAnim = undefined;
	if (self.preCombatRunEnabled && !isInCombat())
		runAnim = %precombatrun1;
	else
		runAnim = self.a.combatrunanim;
	
	self setAnimKnobAllRestart(runAnim, %body, 1, endBlendTime, 1);
	wait (endBlendTime);
	thread animscripts\run::MakeRunSounds ( "killSoundThread" );

	/*
	for (;;)
	{
		self waittill ("traverse",notetrack);
		println ("notetrack ", notetrack);
	}
	*/
}

teleportThread(destination)
{
	self endon ("death");
	reps = 5;
	offset = ( 0, 0, destination / reps);
	for (i=0;i<reps;i++)
	{
		self teleport (self.origin + offset);
		wait (0.05);
	}
}