#include maps\_utility;
#include common_scripts\utility;

main()
{
	maps\_load::main();
	
	for ( ;; )
	{
		ai = getaiarray( "axis" );
		if ( !ai.size )
			break;
		ai[0] waittill( "death" );
	}
	
	iprintlnbold("A winner is you!");
}