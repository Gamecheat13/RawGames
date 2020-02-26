/***********************************************************************************
Module: flak88 (module_flak88.map & module_flak88.gsc)

Demonstrates:

	How to set up a flak88.  Currently it doesn't really do anything since we're
		going to need animations etc.
			
Notes:  WORK IN PROGRESS!

************************************************************************************/

#include maps\_utility;
main()
{
	level.tanks = 0;
	// Required to set up the vehicles through the vehicle script
	maps\_flak88::main( "german_artillery_flak88_nm" );

	// This needs to come AFTER the vehicle loading scripts
	maps\_load::main();
}