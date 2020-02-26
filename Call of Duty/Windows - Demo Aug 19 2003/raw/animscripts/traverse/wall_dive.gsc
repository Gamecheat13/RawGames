// Wall_dive.gsc
// Makes the character dive over a low wall

#using_animtree ("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip"); // JBW Was getting caught on wall in test/obstacle

	self setFlaggedAnimKnoballRestart("diveanim",%jump_over_low_wall, %body, 1, .1, 1);
	self playsound("dive_wall");
	self waittillmatch("diveanim", "gravity on");
	self traverseMode("gravity");
	self animscripts\shared::DoNoteTracks("diveanim");
	self.anim_movement = "run";
	self.anim_alertness = "casual";
	self setAnimKnobAllRestart(self.anim_crouchrunanim, %body, 1, 0.1, 1);
	thread animscripts\run::MakeRunSounds ( "killSoundThread" );
}
