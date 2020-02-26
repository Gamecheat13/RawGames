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
	default: assertmsg("Traversal: 'jump_down_96' doesn't support entity type '" + self.type + "'.");
	}
}

human()
{
	PrepareForTraverse();

	traverseData = [];
	traverseData[ "traverseAnim" ]			= animArray("jump_down_96", "move");
	
	DoTraverse( traverseData );
}

dog()
{
	dog_jump_down( 96, 7 );
}
