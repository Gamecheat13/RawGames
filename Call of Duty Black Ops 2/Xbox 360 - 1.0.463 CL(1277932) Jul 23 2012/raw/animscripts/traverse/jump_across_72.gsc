// jump_across_120.gsc
// Makes the character do a lateral jump of 120 units.

#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;

#using_animtree ("generic_human");

main()
{
	switch (self.type)
	{
	case "human": human(); break;
	default: assertmsg("Traversal: 'jump_across_120' doesn't support entity type '" + self.type + "'.");
	}
}

human()
{
	PrepareForTraverse();

	traverseData[ "traverseAnim" ]		= animArray("jump_across_120", "move");
	traverseData[ "traverseStance" ]	= "stand";

	DoTraverse( traverseData );
}