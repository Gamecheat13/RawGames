#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;
#include animscripts\utility;
#include maps\_utility;

#using_animtree ("generic_human");

main()
{
	switch (self.type)
	{
	case "human": human(); break;
	default: assertmsg("Traversal: 'stairs_up' doesn't support entity type '" + self.type + "'.");
	}
}

human()
{
	movement = "sprint";

	traverseData = [];
	
	if (self animscripts\traverse\stairs_util::get_stair_count() % 2)
	{
		transition_stair_count_in = 0;
		traverseData[ "traverseAnimTransIn" ] =		animArray("staircase_up_8x8_in", movement);
	}
	else
	{
		transition_stair_count_in = 1;
		traverseData[ "traverseAnimTransIn" ] =		animArray("staircase_up_8x8_in_even", movement);
	}
	
	transition_stair_count_out = 1;
	traverseData[ "traverseAnimTransOut" ] =	animArray("staircase_up_8x8_out", movement);

	stair_anims[2] =	animArray("staircase_up_8x8_2", movement, false);	// 2 stairs
	stair_anims[4] =	animArray("staircase_up_8x8_4", movement, false);	// 4 stairs
	stair_anims[6] =	animArray("staircase_up_8x8_6", movement, false);	// 6 stairs
	stair_anims[8] =	animArray("staircase_up_8x8_8", movement, false);	// 8 stairs
	stair_anims[10] =	animArray("staircase_up_8x8_10", movement, false);	// 10 stairs

	transition_stair_count = 1;
	traverseData = animscripts\traverse\stairs_util::build_traverse_data(traverseData, stair_anims, transition_stair_count_in, transition_stair_count_out);

	DoTraverse( traverseData );
}