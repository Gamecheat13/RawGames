#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");

main()
{
    self trackScriptState( "Cover Prone Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("cover_prone");
	self cover_prone();
}

cover_prone()
{
	handleSuppressingEnemy();
	
	nodeOrigin = animscripts\utility::GetNodeOrigin();
	nodeAngles = (0,0,0);
	if (isdefined (self.node))
		nodeAngles = self.node.angles;
	
	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
	{
		animscripts\wounded::SubState_WoundedGetup("pose be wounded", "prone");
	}

	// Say random shit.
	animscripts\combat_say::generic_combat();
	self SetPoseMovement(self.anim_pose, "stop");
	if (self.anim_pose != "prone")
	{
		for (;;)
		{
			if (hasEnemySightPos())
			{
				targetPos = getEnemySightPos();
				myYawFromTarget = VectorToAngles(targetPos - self.origin );
				self OrientMode( "face angle", myYawFromTarget[1] );
				
				yaw = AbsYawToOrigin(targetPos);
				if (yaw < 5)
					break;
			}
			else
			{
				if (isdefined (self.node))
				{
					self OrientMode ("face angle", self.node.angles[1]); 
					yaw = AbsYawToAngles(self.node.angles[1]);
					if (yaw < 5)
						break;
				}
			}
				
			wait (0.05);
		}
	}

	self SetPoseMovement("prone","stop");

	for (;;)
	{
		// Make sure we're in the right place.
		self teleport (nodeOrigin);

		Rechamber();

		// TODO: Hide for a while here, longer if suppressed.

		// Do prone combat, if you can.
//		self OrientMode ("face enemy"); 
		if (hasEnemySightPos())
		{
			targetPos = getEnemySightPos();
			myYawFromTarget = VectorToAngles(targetPos - self.origin );
			self OrientMode( "face angle", myYawFromTarget[1]);
		}
		else
			self OrientMode ("face angle", nodeAngles[1]); 
        ////		animscripts\combat::ProneCombat();
        self thread animscripts\prone::ProneRangeCombat("cover prone jumps here");
        return;
	}
}					
