#include maps\_utility; 

fog_settings()
{
	if( IsSplitScreen() )
	{
		set_splitscreen_fog( 0, 200, 0, -200, .71, .73, .72, 0, 1000 );
	}
}



main()
{
	//Sets the fog for the (level, near, far, red, green, blue, time fade)
	PrecacheModel( "dest_test_palm_spawnfrond1" );
	PrecacheModel( "dest_test_palm_spawnfrond2" );
	fog_settings();
}