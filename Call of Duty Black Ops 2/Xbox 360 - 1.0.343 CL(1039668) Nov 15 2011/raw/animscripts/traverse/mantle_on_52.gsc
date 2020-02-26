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
	default: assertmsg("Traversal: 'mantle_on_52' doesn't support entity type '" + self.type + "'.");
	}
}

human()
{
	PrepareForTraverse();

	traverseData = [];

	traverseData[ "traverseAnim" ]			= array( animArray("mantle_on_52", "move") );
	traverseData[ "traverseHeight" ]		= 52.0;

	traverseData[ "traverseStance" ]		= "stand";
	traverseData[ "traverseAlertness" ]		= "casual";
	traverseData[ "traverseMovement" ]		= "run";

	traverseData[ "interruptDeathAnim" ][0]	= animArray("traverse_40_death_start", "move");
	traverseData[ "interruptDeathAnim" ][1]	= animArray("traverse_40_death_end", "move");

	DoTraverse( traverseData );
}

dog()
{
	// TODO: make a generic dog traverse function or use DoTraverse
	dog_jump_up( 52.0, 5 );
}