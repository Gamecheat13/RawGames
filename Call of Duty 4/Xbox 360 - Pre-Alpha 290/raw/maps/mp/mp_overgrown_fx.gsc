main()
{
	maps\createfx\mp_overgrown_fx::main();

	level._effect["dust_wind_leaves_chernobyl"]		= loadfx ("dust/dust_wind_leaves_chernobyl");	
	level._effect["thin_black_smoke_M"]				= loadfx ("smoke/thin_black_smoke_M");
	level._effect["thin_black_smoke_L"]				= loadfx ("smoke/thin_black_smoke_L");
	
	level._effect["flak_explosion"]								= loadfx ("explosions/large_vehicle_explosion");		
	level.scr_sound["flak88_explode"]	= "flak88_explode";
}

