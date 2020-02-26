#include common_scripts\utility;
#include animscripts\anims;

#insert raw\common_scripts\utility.gsh;

build_traverse_data(traverseData, stair_anims, transition_stair_count_in, transition_stair_count_out)
{
	stair_count = self get_stair_count() - transition_stair_count_in - transition_stair_count_out;
	if (stair_count < 0)
	{
		// The total number of stairs is only enough to do the "in" transition
		traverseData[ "traverseAnimTransOut" ] = undefined;
	}
	else
	{
		traverseData[ "traverseAnim" ] = build_anim_array(stair_anims, stair_count);
	}

	traverseData[ "traverseAnimType" ] = "sequence";

	traverseData[ "traverseStance" ]		= "stand";
	traverseData[ "traverseAlertness" ]		= "casual";
	traverseData[ "traverseMovement" ]		= "run";

	traverseData[ "traverseAllowAiming" ]	= true;
	traverseData[ "traverseAimUp" ]			= animArray( "staircase_aim_up", "move" );
	traverseData[ "traverseAimDown" ]		= animArray( "staircase_aim_down", "move" );
	traverseData[ "traverseAimLeft" ]		= animArray( "staircase_aim_left", "move" );
	traverseData[ "traverseAimRight" ]		= animArray( "staircase_aim_right", "move" );

	traverseData[ "traverseRagdollDeath" ]	= true;

	return traverseData;
}

build_anim_array(stair_anims, stair_count)
{
	ret_stair_anims = [];

	potential_sizes = GetArrayKeys(stair_anims);
	while (stair_count > 0)
	{
		sizes = [];
		for (i = 0; i < potential_sizes.size; i++)
		{
			// remove all animation options that are longer than how many steps we have
			if (potential_sizes[i] <= stair_count)
			{
				ARRAY_ADD(sizes, potential_sizes[i]);
			}
		}

		// go through all remaining size and pick a random one
		assert(sizes.size, "No potential animation for stair count.");
		
		random_size = random(sizes);
		if (random_size <= stair_count)
		{
			ARRAY_ADD(ret_stair_anims, stair_anims[random_size]);
			stair_count -= random_size;
		}
	}

	return ret_stair_anims;
}

get_stair_count()
{
	start_node = self GetNegotiationStartNode();
	assert(IsDefined(start_node.script_int), "Stair traversals must have a script_int with the number of stairs.");
	return start_node.script_int;
}