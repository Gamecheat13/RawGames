#include maps\mp\animscripts\traverse\shared;

// step_up.gsc
// Makes the character step up onto a ledge.  Currently the ledge is assumed to be 36 units.

main()
{
	if ( self.type == "dog" )
		dog_jump_up( 40, 3 );
}
