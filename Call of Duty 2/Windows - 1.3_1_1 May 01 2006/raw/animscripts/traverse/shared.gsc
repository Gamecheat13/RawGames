#include animscripts\Utility;
#using_animtree ("generic_human");
advancedTraverse(traverseAnim, normalHeight)
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self.old_anim_movement = self.anim_movement;
	self.old_anim_alertness = self.anim_alertness;
	
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip"); // So he doesn't get stuck if the wall is a little too high
	
	// orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert( isdefined( startnode ) );
    self OrientMode( "face angle", startnode.angles[1] );
//	println ("height difference " + ());
	//normalHeight = 47.8;
	realHeight = startnode.traverse_height - startnode.origin[2];
	
//    self teleport((self.origin[0], self.origin[1], self.origin[2] + realHeight - normalHeight));
//    self thread teleportThread((self.origin[0], self.origin[1], self.origin[2] + realHeight - normalHeight));
    self thread teleportThread(realHeight - normalHeight);
//	heightOffset = (0,0,startNode.origin[2] + realHeight - normalHeight);
//	println ("height offset " + heightOffset);
	
//	self startscriptedanim("traverse", (1,02,3), (34,15,132), self.anim_combatrunanim, "normal", %body);
	self setFlaggedAnimKnoballRestart("traverse", traverseAnim, %body, 1, 0.15, 1);
	timer = gettime();
	self thread animscripts\shared::DoNoteTracksForever("traverse", "no clear");
	if (!animhasnotetrack(traverseAnim, "gravity on"))
	{
		timer = 1.23;
		timerOffset = 0.2;
		wait (timer - timerOffset);
		self traverseMode("gravity");
		wait (timerOffset);
	}
	else
	{
		self waittillmatch("traverse","gravity on");
		self traverseMode("gravity");
		if (!animhasnotetrack(traverseAnim, "blend"))
			wait (0.2);
		else
		self waittillmatch("traverse","blend");
	}

	self.anim_movement = self.old_anim_movement;
	self.anim_alertness = self.old_anim_alertness;
	
	runAnim = undefined;
	if (self.preCombatRunEnabled && !isInCombat())
		runAnim = %precombatrun1;
	else
		runAnim = self.anim_combatrunanim;
	
	self setAnimKnobAllRestart(runAnim, %body, 1, 0.2, 1);
//	self waittillmatch ("traverse","end");
	wait (0.2);
	thread animscripts\run::MakeRunSounds ( "killSoundThread" );
//	println ("length " + (gettime() - timer));
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