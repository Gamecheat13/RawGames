main()

{
	level._effect["firelp_med_pm"]					= loadfx ("fire/firelp_med_pm");	
	level._effect["firelp_small_pm"]				= loadfx ("fire/firelp_small_pm");
	level._effect["firelp_small_pm_a"]				= loadfx ("fire/firelp_small_pm_a");
	level._effect["dust_wind_slow"]					= loadfx ("dust/dust_wind_slow_yel_loop");
	level._effect["dust_wind_spiral"]				= loadfx ("dust/dust_spiral_runner");
	level._effect["hawk"]							= loadfx ("weather/hawk");
	level._effect["birds_takeoff"]					= loadfx ("misc/birds_takeoff_coup");
	level._effect["bird_seagull_flock_large"]		= loadfx ("misc/bird_seagull_flock_large");
	level._effect["wavebreak_runner"]				= loadfx ("misc/wavebreak_runner");
	level._effect["execution_muzzleflash"]          = loadfx ("muzzleflashes/execution_flash_view");
	level._effect["execution_shell_eject"]          = loadfx ("shellejects/execution_pistol");

	treadfx_override();
	maps\createfx\coup_fx::main();
}

treadfx_override()
{
	maps\_treadfx::setvehiclefx( "bmp", "brick" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "bark" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "carpet" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "cloth" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "concrete" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "dirt" ,"treadfx/tread_dust_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "flesh" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "foliage" ,"treadfx/tread_dust_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "glass" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "grass" ,"treadfx/tread_dust_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "gravel" ,"treadfx/tread_dust_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "ice" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "metal" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "mud" ,"treadfx/tread_dust_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "paper" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "plaster" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "rock" ,"treadfx/tread_dust_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "sand" ,"treadfx/tread_dust_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "snow" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "water" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "wood" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "asphalt" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "ceramic" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "plastic" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "rubber" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "cushion" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "fruit" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "painted metal" ,"treadfx/tread_road_coup" );
 	maps\_treadfx::setvehiclefx( "bmp", "default" ,"treadfx/tread_road_coup" );
	maps\_treadfx::setvehiclefx( "bmp", "none" ,"treadfx/tread_road_coup" );
}