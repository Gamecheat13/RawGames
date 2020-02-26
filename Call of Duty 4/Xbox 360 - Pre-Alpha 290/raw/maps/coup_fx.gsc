main()

{
	level._effect["firelp_med_pm"]					= loadfx ("fire/firelp_med_pm");	
	level._effect["firelp_small_pm"]				= loadfx ("fire/firelp_small_pm");
	level._effect["firelp_small_pm_a"]				= loadfx ("fire/firelp_small_pm_a");
	level._effect["dust_wind_slow"]					= loadfx ("dust/dust_wind_slow_yel_loop");
	level._effect["dust_wind_spiral"]				= loadfx ("dust/dust_spiral_runner");
	level._effect["hawk"]							= loadfx ("weather/hawk");
	level._effect["birds_takeoff"]					= loadfx ("misc/birds_takeoff_coup");

	
	maps\createfx\coup_fx::main();

}