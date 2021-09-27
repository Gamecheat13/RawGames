#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	template_so_level( "so_deltacamp" );
	level.trainer_version = 2;
	maps\so_deltacamp::main();

  // mini map
	maps\_compass::setupMiniMap( "compass_map_so_trainer2_so_deltacamp" );
	
	setsaveddvar( "compassmaxrange", "1200" );

}