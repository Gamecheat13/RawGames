/***********************************************************************************
Module: 		FX (effectsEd_box.map & effectsEd_box.gsc)

Demonstrates:		How to use the in-game fx editor.
	
	To use:		
			1. In the console, type 'exec createfx'				
			2. The map will now restart.
			3. Press and hold H to show the help menu.
			4. 'Insert' inserts an effect and should get you started.
			5. Adjust FX as necessary.
			6. Pressing S will save the FX data out to xenonOutput\scriptdata\createfx\mapname.gsc
			   and print to the console.
			7. Copy and paste the contents from this output to another map for use.
	
	Notes: 		- FX to be used need to be loaded like using the following format
			  (usually in the precacheFX() function of the level_fx file):
			  	
			  level._effect["exp_pack_doorbreach"] = loadfx("explosions/large_vehicle_explosion");
				
			  The in-game FX editor looks for level._effect["X"]. These FX must also
			  be loaded with a loadfx() call.
			  
			- Make sure that #include maps\_utility; is included in your level_fx script
			  or you'll get script errors if you're dumped FX using the createfx script
			  in your level somewhere.

************************************************************************************/

#include maps\_utility;
main()
{
	// This call would usually go in a level_fx.gsc
	precacheFX();	
	spawnFX();	
}

// Load some basic FX to play around with.
precacheFX()
{
	// For level._effect["X"]s, X can be whatever makes sense to the scritper. 
	// The loadfx() call needs to point to a valid effect, however.
	level._effect["missing_effect"]	= loadfx ("misc/fx_missing_fx");
  level._effect["mortarExp_dirt"]			= loadfx ("explosions/fx_mortarExp_dirt");
  level._effect["thin_black_smoke_M"]			= loadfx ("smoke/thin_black_smoke_M");
}

spawnFX()
{
     	
  
 }                       