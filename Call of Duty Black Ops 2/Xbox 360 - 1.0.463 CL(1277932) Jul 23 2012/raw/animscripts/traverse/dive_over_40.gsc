#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;

#using_animtree ("generic_human");

main()
{
	switch (self.type)
	{
	case "human": human(); break;
	default: assertmsg("Traversal: 'dive_over_40' doesn't support entity type '" + self.type + "'.");
	}
}

human()
{
	PrepareForTraverse();

	traverseData = [];

	traverseData[ "traverseHeight" ]		= 40.0;
	traverseData[ "traverseAnim" ]			= array(	animArray("dive_over_40", "move")		);

	traverseData[ "traverseStance" ]		= "stand";
	traverseData[ "traverseMovement" ]		= "run";
	
	DoTraverse( traverseData );
}