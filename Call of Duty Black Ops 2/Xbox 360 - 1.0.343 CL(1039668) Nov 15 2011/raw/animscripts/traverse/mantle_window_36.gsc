#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;

#using_animtree ("generic_human");

main()
{
	switch (self.type)
	{
	case "human": human(); break;
	case "dog": dog(); break;
	case "zombie": human(); break;
	case "zombie_dog": dog(); break;
	default: assertmsg("Traversal: 'mantle_window_36' doesn't support entity type '" + self.type + "'.");
	}
}

human()
{
	PrepareForTraverse();

	traverseData = [];

	traverseData[ "traverseHeight" ]		= 36.0;
	traverseData[ "traverseAnim" ]			= animArray("mantle_window_36_run", "move");

	traverseData[ "traverseToCoverAnim" ]	= animArray("mantle_window_36_stop", "move");
	traverseData[ "coverType" ]				= "Cover Crouch";

	traverseData[ "interruptDeathAnim" ][0]	= animArray("traverse_40_death_start", "move");
	traverseData[ "interruptDeathAnim" ][1]	= animArray("traverse_40_death_end", "move");

	DoTraverse( traverseData );
}

dog()
{
	// TODO: update DoTraverse to support dogs, or maybe add a DoDogTraverse
	// Or maybe DoTraverse already works for dogs.. needs to be tested
	dog_wall_and_window_hop( "window_40", 40 );
}