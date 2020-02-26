#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;

#using_animtree ("generic_human");

main()
{
	switch (self.type)
	{
	case "human": human(); break;
	default: assertmsg("Traversal: 'mantle_window_dive_36' doesn't support entity type '" + self.type + "'.");
	}
}

human()
{
	PrepareForTraverse();

	traverseData = [];

	traverseData[ "traverseHeight" ]		= 36.0;
	traverseData[ "traverseAnim" ]			= animArray("mantle_window_dive_36", "move");

	DoTraverse( traverseData );
}
