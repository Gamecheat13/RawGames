#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;

#using_animtree ("generic_human");

main()
{
	PrepareForTraverse();

	traverseData[ "traverseAnim" ]			= animArray("jump_across_72", "move");
	traverseData[ "traverseStance" ]		= "stand";

	DoTraverse( traverseData );
}