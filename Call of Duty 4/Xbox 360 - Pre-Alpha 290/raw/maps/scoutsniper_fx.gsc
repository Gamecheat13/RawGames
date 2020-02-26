main()
{
	level._effect["dust_wind_leaves_chernobyl"]		= loadfx ("dust/dust_wind_leaves_chernobyl");	
	level._effect["thin_black_smoke_M"]				= loadfx ("smoke/thin_black_smoke_M");
	level._effect["thin_black_smoke_L"]				= loadfx ("smoke/thin_black_smoke_L");
	
	level._effect["bird"]							= loadfx ("misc/bird");
	level._effect["bird_takeoff"]					= loadfx ("misc/bird_takeoff");
	
	level._effect["dog_bite_blood"] 				= loadfx ("impacts/flesh_hit_body_fatal_exit");


	maps\createfx\scoutsniper_fx::main();
}
