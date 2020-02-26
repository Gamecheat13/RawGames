#include maps\mp\_utility;
main()
{
	//needs to be first for create fx
	maps\mp\mp_yemen_fx::main();

	maps\mp\teams\_teamset_seals::register();
	maps\mp\_load::main();

	maps\mp\mp_yemen_amb::main();

	// If the team nationalites change in this file, you must also update the level's csc file,
	// the level's csv file, and the share/raw/mp/mapsTable.csv
	maps\mp\teams\_teamset_seals::level_init();
  maps\mp\_compass::setupMiniMap("compass_map_mp_yemen");
	// Set up the default range of the compass
	SetDvar("compassmaxrange","2100");

	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	SetDvar( "scr_spawn_enemy_influencer_radius", 2600 );

	turbine_spin_init();
}

turbine_spin_init()
{
	level endon ("game_ended");
		
	//turbines = GetEntArray( "turbine_blades", "targetname" ); 
  //array_thread( turbines, ::rotate_blades, 10 );

	turbine1 = GetEnt ("turbine_blades", "targetname" ); 
  turbine1 thread rotate_blades(4);

	turbine2 = GetEnt ("turbine_blades2", "targetname" ); 
  turbine2 thread rotate_blades(3);
  
  turbine3 = GetEnt ("turbine_blades3", "targetname" ); 
  turbine3 thread rotate_blades(6);

	turbine4 = GetEnt ("turbine_blades4", "targetname" ); 
  turbine4 thread rotate_blades(3);
  
//  turbine5 = GetEnt ("turbine_blades5", "targetname" ); 
//  turbine5 thread rotate_blades(15);
 
 	turbine6 = GetEnt ("turbine_blades6", "targetname" ); 
  turbine6 thread rotate_blades(4);
  
  }

rotate_blades( time )
{
	self endon ("game_ended");

	revolutions = 1000;

	while(1)
	{
		self RotateRoll( 360 * revolutions, time * revolutions );
		self waittill( "rotatedone" );
	}
}