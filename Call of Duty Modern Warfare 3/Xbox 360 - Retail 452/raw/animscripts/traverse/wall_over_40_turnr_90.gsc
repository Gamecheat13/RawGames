#include animscripts\utility;
#include animscripts\traverse\shared;
#using_animtree( "generic_human" );

main()
{
	traverseData = [];
	traverseData[ "traverseAnim" ]			 = %berlin_delta_open_sidewayselevator_guy2;

	DoTraverse( traverseData );
}
