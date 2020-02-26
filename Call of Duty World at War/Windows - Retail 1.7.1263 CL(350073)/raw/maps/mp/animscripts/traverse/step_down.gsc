#include maps\mp\animscripts\traverse\shared;

// step_down.gsc
// Makes the character step down off a ledge.  Currently the ledge is assumed to be 36 units.


main()
{
	if ( self.type == "dog" )
		dog_jump_down( 40, 3 );
}
