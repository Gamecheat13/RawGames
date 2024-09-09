// ladder_down.gsc
// Climbs down a ladder of any height by using a looping animation.
#include animscripts\utility;
#include animscripts\traverse\shared;

#using_animtree( "generic_human" );

main()
{
	if ( IsDefined( self.type ) && self.type == "dog" )
		return;
	
	DoVariableLengthTraverse( %ladder_climbon, %ladder_climbdown, undefined, "noclip", "stand", "stop" );
}