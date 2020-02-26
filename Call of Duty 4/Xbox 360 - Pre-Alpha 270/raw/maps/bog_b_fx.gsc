main()
{
	//----------------------------
	// Placed Effects Declarations
	//----------------------------
	level._effect["paper_falling_burning"]				= loadfx( "misc/paper_falling_burning" );
	level._effect["battlefield_smokebank_S"]			= loadfx( "smoke/battlefield_smokebank_S" );
	level._effect["thin_black_smoke_M"]					= loadfx( "smoke/thin_black_smoke_M" );
	level._effect["thin_black_smoke_L"]					= loadfx( "smoke/thin_black_smoke_L" );
	level._effect["dust_wind_slow"]						= loadfx( "dust/dust_wind_slow_yel_loop" );

	
	//-----------------------
	//Mortar effects & sounds
	//-----------------------
	
	level._effect["mortar"]["dirt"]						= loadfx( "explosions/grenadeExp_dirt" );
	level._effect["mortar"]["mud"]						= loadfx( "explosions/grenadeExp_mud" );
	
	level.scr_sound["mortar"]["incomming"]				= "mortar_incoming";
	level.scr_sound["mortar"]["dirt"]					= "mortar_explosion_dirt";
	level.scr_sound["mortar"]["mud"]					= "mortar_explosion_water";
	
	level._effect["wall_explosion_small"]				= loadfx( "explosions/wall_explosion_small" );
	level._effect["wall_explosion_grnd"]				= loadfx( "explosions/wall_explosion_grnd" );
	level._effect["wall_explosion_draft"]				= loadfx( "explosions/wall_explosion_draft" );
	level._effect["wall_explosion_round"]				= loadfx( "explosions/wall_explosion_round" );
	level._effect["tank_round_spark"]					= loadfx( "impacts/tank_round_spark" );
	
	level._effect["exploder"]["100"]					= loadfx( "explosions/wall_explosion_small" );
	level._effect["exploder"]["101"]					= loadfx( "explosions/wall_explosion_small" );
	level._effect["exploder"]["102"]					= loadfx( "explosions/wall_explosion_small" );
	level._effect["exploder"]["102"]					= loadfx( "explosions/wall_explosion_draft" );
	level._effect["exploder"]["103"]					= loadfx( "explosions/wall_explosion_small" );
	level._effect["exploder"]["104"]					= loadfx( "explosions/wall_explosion_small" );
	level._effect["exploder"]["105"]					= loadfx( "explosions/wall_explosion_grnd" );
	level._effect["exploder"]["400"]					= loadfx( "explosions/wall_explosion_round" );

	
	level._vehicle_effect["tankcrush"]["window_med"]	= loadfx( "props/car_glass_med");
	level._vehicle_effect["tankcrush"]["window_large"]	= loadfx( "props/car_glass_large");
	
	level._effect[ "mg_kill_grenade" ]					= loadfx( "explosions/grenadeExp_wood" );
	level.scr_sound[ "mg_kill_grenade_bounce" ]			= "grenade_bounce_wood";
	level.scr_sound[ "mg_kill_grenade_explode" ]		= "grenade_explode_wood";
	
	level._effect["afterburner"]						= loadfx ("fire/jet_afterburner");
	level._effect["abrams_exhaust"]						= loadfx ("distortion/abrams_exhaust");
	
	//End Tank Destruction
	level._effect["t72_explosion"]						= loadfx ("explosions/large_vehicle_explosion");
	level._effect["t72_ammo_breach"]					= loadfx ("explosions/tank_ammo_breach");
	level._effect["t72_ammo_explosion"]					= loadfx ("explosions/t72_ammo_explosion");
	level._effect["firelp_large_pm"]					= loadfx ("fire/firelp_large_pm");
	

	//Override Tread FX
	maps\_treadfx::setvehiclefx( "m1a1", "brick" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "bark" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "carpet" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "cloth" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "concrete" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "dirt" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "flesh" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "foliage" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "glass" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "grass" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "gravel" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "ice" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "metal" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "mud" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "paper" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "plaster" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "rock" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "sand" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "snow" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "water" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "wood" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "asphalt" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "ceramic" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "plastic" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "rubber" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "cushion" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "fruit" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "painted metal" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "default" ,"dust/tread_dust_bog_b" );
	maps\_treadfx::setvehiclefx( "m1a1", "none" ,"dust/tread_dust_bog_b" );

	maps\_treadfx::setvehiclefx( "t72", "brick" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "bark" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "carpet" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "cloth" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "concrete" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "dirt" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "flesh" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "foliage" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "glass" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "grass" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "gravel" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "ice" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "metal" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "mud" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "paper" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "plaster" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "rock" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "sand" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "snow" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "water" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "wood" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "asphalt" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "ceramic" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "plastic" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "rubber" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "cushion" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "fruit" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "painted metal" ,"dust/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "default" ,"dust/tread_dust_bog_b" );
	maps\_treadfx::setvehiclefx( "t72", "none" ,"dust/tread_dust_bog_b" );

	maps\createfx\bog_b_fx::main();

}