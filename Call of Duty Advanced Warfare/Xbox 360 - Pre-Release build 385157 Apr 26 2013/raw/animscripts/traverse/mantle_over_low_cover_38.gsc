#include animscripts\utility;
#include animscripts\traverse\shared;
#include common_scripts\utility;
#using_animtree( "generic_human" );

main()
{
	if ( self.type == "dog" )
		dog_wall_and_window_hop( "window_38", 38 );
	else
		mantle_over_low_wall_38_human();
}

mantle_over_low_wall_38_human()
{
	traverseData = [];
	traverseData[ "traverseAnim" ]			 = random([%traverse_mantle_over_low_cover_38_var1, %traverse_mantle_over_low_cover_38_var2]);
	traverseData[ "traverseHeight" ]		 = 0; // the height of the node above where the AI starts
	//traverseData[ "interruptDeathAnim" ][ 0 ]	 = array( %traverse38_death_start, %traverse38_death_start_2 );
	//traverseData[ "interruptDeathAnim" ][ 1 ]	 = array( %traverse38_death_end, %traverse38_death_end_2 );

	DoTraverse( traverseData );
}
