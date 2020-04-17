// door.gsc
// Traverses AI through a door

//#using_animtree ("generic_human");

main()
{
//	self.desired_anim_pose = "stand";
//	self animscripts\utility::UpdateAnimPose();
//	
//	self endon("killanimscript");
//	self traverseMode("noclip");
//
//	node = self getnegotiationstartnode();
//	assert(isdefined(node));
//
//    if(!isDefined(node.doorRef))
//    {
//        assertmsg("Door node has no door.");
//        return;
//    }    
//
//    door = node.doorRef;
//
//	self OrientMode("face angle", node.angles[1]);
//
//	if (door maps\_doors::is_door_open() && (!IsDefined(self._doors_traversing_door) || !self._doors_traversing_door))
//	{
//		/#
//		//iPrintLnBold("^6traversing open door");
//		#/
//
//		traverse_open_door_anim = %jump_across_72;
//
//		//self traverseMode("nogravity");
//		self setFlaggedAnimKnoballRestart("traverse_open_door", traverse_open_door_anim, %body, 1, .1, 1);
//		self waittillmatch("traverse_open_door", "gravity on");
//		self traverseMode("gravity");
//		self animscripts\shared::DoNoteTracks("traverse_open_door");
//		self.a.movement = "run";
//		self.a.alertness = "casual";
//		self setAnimKnobAllRestart(self.a.combatrunanim, %body, 1, 0.2, 1);
//	}
//	else
//	{
//		/#
//		//iPrintLnBold("^5traversing closed door");
//		#/
//
//		self._doors_traversing_door = true;
//
//		self thread maps\_doors::door_anim_ai(node);
//		node maps\_doors::open_door_from_door_node();
//
//		self._doors_traversing_door = false;
//	}
}