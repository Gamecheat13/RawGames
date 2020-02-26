#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;

#using_animtree ("generic_human");

main()
{
	switch (self.type)
	{
	case "human": human(); break;
	default: assertmsg("Traversal: 'stairs_down' doesn't support entity type '" + self.type + "'.");
	}
}

human()
{
	PrepareForTraverse();

// 	stair_anims[2] = %ai_staircase_run_up_loop_01;	// 2 stairs
// 	stair_anims[4] = %ai_staircase_run_up_loop_02;	// 4 stairs
// 	stair_anims[6] = %ai_staircase_run_up_loop_03;	// 6 stairs
// 	stair_anims[8] = %ai_staircase_run_up_loop_04;	// 8 stairs

// 	start_node = self GetNegotiationStartNode();

// 	assert(IsDefined(start_node.script_int), "Stair traversals must have a script_int with the number of stairs.");

// 	traverseData = [];

// 	traverseData[ "traverseAnimType" ] = "sequence";

// 	traverseData[ "traverseAnim" ] = build_anim_array(stair_anims, start_node.script_int);

// 	traverseData[ "traverseAnimTransIn" ] = %ai_staircase_run_up_in_04;
// 	traverseData[ "traverseAnimTransOut" ] = %ai_staircase_run_up_out_04;

// 	traverseData[ "traverseStance" ]		= "stand";
// 	traverseData[ "traverseAlertness" ]		= "casual";
// 	traverseData[ "traverseMovement" ]		= "run";

// 	DoTraverse( traverseData );
}
