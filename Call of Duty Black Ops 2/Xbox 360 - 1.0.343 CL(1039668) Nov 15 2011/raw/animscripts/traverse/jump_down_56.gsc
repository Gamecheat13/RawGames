#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;

#using_animtree ("generic_human");

main()
{
	switch (self.type)
	{
	case "human": human(); break;
	default: assertmsg("Traversal: 'jump_down_56' doesn't support entity type '" + self.type + "'.");
	}
}

human()
{
	PrepareForTraverse();

	traverseData = [];
	traverseData[ "traverseAnim" ]			= animArray("jump_down_56", "move");
	traverseData[ "traverseHeight" ]		= 56.0;

	traverseData[ "traverseStance" ]		= "crouch";
	traverseData[ "traverseAlertness" ]		= "alert";
	traverseData[ "traverseMovement" ]		= "walk";

	DoTraverse( traverseData );
}