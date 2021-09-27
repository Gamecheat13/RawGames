#include animscripts\utility;
#include animscripts\traverse\shared;
#using_animtree( "generic_human" );

main()
{
	if ( isdefined( self.type ) && self.type == "dog" ) // no dogs allowed
		return;
		
	prague_dumpster_climb();
}

prague_dumpster_climb()
{
	traverseData = [];
	traverseData[ "traverseAnim" ]			 = %prague_dumpster_climb;
	traverseData[ "traverseSound"]			 = "scn_prague_price_dumpster_jump";
	DoTraverse( traverseData );
}