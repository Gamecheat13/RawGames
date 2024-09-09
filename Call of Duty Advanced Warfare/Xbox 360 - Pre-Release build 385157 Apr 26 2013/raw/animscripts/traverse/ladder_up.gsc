// ladder_up.gsc
// Climbs a ladder of any height by using a looping animation, and gets off at the top.
#include animscripts\utility;
#include animscripts\traverse\shared;
#using_animtree( "generic_human" );

main()
{
	if ( IsDefined( self.type ) && self.type == "dog" )
		return;
	
	DoVariableLengthTraverse( undefined, %ladder_climbup, %ladder_climboff, "noclip", "crouch", "run" );
}
