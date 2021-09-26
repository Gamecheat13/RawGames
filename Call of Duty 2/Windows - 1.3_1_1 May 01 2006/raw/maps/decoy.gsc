/*===========================================================================

Level: 		DECOY
Campaign: 	British
Objectives:
		1. ?
		
============================================================================*/

#include maps\_utility;
#include maps\_fx;
#include maps\_anim;

main()
{	
	setExpFog (0.0001,  0.0667, 0.0941, 0.1412, 0);
	
	//// Load External Scripts
	maps\_load::main();
	maps\decoy_fx::main();
	maps\decoy_anim::main();
}