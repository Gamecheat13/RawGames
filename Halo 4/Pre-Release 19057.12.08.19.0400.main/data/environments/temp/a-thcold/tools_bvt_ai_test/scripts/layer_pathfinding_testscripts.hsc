/*
	343 Industries - Copyright Microsoft 2011
	Hammer Team AI (BVT) Test Map
	Scripting created by Thomas Coldwell (a-thcold@microsoft.com)
	
	PURPOSE:
	Test a number of different AI/scripting functions that are used frequently by designers.
	
	THIS FILE CONTAINS:
	- Command scripts for pathfinding
*/

// =================================================================================================
// =================================================================================================
// Command Scripts
// =================================================================================================
// =================================================================================================


// _______________________________________________
//
// cs_go_to
// _______________________________________________
script command_script cs_test_path_inf_height
	cs_go_to (pts_inf_height.p0);
	cs_go_to (pts_inf_height.p1);
	cs_go_to (pts_inf_height.p2);
end

script command_script cs_test_path_inf_width
	cs_go_to (pts_inf_width.p0);
	cs_go_to (pts_inf_width.p1);
	cs_go_to (pts_inf_width.p2);
end