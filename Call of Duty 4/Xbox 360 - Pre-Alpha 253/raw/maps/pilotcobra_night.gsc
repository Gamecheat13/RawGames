#include maps\_utility;
main()
{
	maps\pilotcobra_day::precacheStuff();
	
	setdvar( "scr_dof_enable", "0" );
		
	maps\_load::main();
	maps\_cobrapilot::init();
	maps\_compass::setupMiniMap( "compass_map_pilotcobra" );
	level thread maps\pilotcobra_amb::main();
	
	flag_clear( "nightvision_dlight_enabled" );
	
	setdvar( "scr_fog_type", "0" );
	setdvar( "scr_fog_density", ".00005" );
	setdvar( "scr_fog_nearplane", "0" );
	setdvar( "scr_fog_farplane", "5000" );
	setdvar( "scr_fog_red", "0.3" );
	setdvar( "scr_fog_green", "0.3" );
	setdvar( "scr_fog_blue", "0.5" );
	setdvar( "scr_fog_density", ".00006" );
	
	setExpFog( 0, 14600, 0, 0, 0, 0 );
	
	maps\pilotcobra_day::vehicleDeathFXOverrides();
	
	maps\pilotcobra_day::difficultyMenu();
	thread autosave_by_name( "cobrapilot_night_mission_started" );
	
	thread maps\pilotcobra_day::objectives();
	
	wait 0.05;
	setsaveddvar( "compassMaxRange", "30000" );
}