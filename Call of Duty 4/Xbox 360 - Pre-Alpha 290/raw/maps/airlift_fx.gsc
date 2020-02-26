#include maps\_utility;

main()
{

	/*-----------------------
	AMBIENT FX
	-------------------------*/	
	//misc
	level._effect[ "antiair_runner" ]					= loadfx ( "misc/antiair_runner_night" );	
	//level._effect[ "smoke_oilfire_01" ] 				= loadfx ( "misc/smoke_oilfire_01" );
	//level._effect[ "smoke_oilfire_02" ] 				= loadfx ( "misc/smoke_oilfire_02" );	
	
	//smoke
	level._effect[ "battlefield_smokebank_S" ]			= loadfx ( "smoke/battlefield_smokebank_bog_a" );
	level._effect[ "thin_black_smoke_M" ]				= loadfx ( "smoke/thin_black_smoke_M" );
	level._effect[ "thin_black_smoke_L" ]				= loadfx ( "smoke/thin_black_smoke_L" );
	level._effect[ "thin_light_smoke_S" ]				= loadfx ( "smoke/thin_light_smoke_S" );
	level._effect[ "thin_light_smoke_M" ]				= loadfx ( "smoke/thin_light_smoke_M" );
	level._effect[ "thin_light_smoke_L" ]				= loadfx ( "smoke/thin_light_smoke_L" );
	
	//fire
	level._effect[ "tire_fire_med" ]					= loadfx ( "fire/tire_fire_med" );
	level._effect[ "firelp_large_pm" ]					= loadfx ( "fire/firelp_large_pm" );
	level._effect[ "firelp_small_dl_a" ]				= loadfx ( "fire/firelp_small_dl_a" );
	level._effect[ "firelp_small_dl_b" ]				= loadfx ( "fire/firelp_small_dl_b" );
	level._effect[ "firelp_small_dl_c" ]				= loadfx ( "fire/firelp_small_dl_c" );
	level._effect[ "firelp_small_dl_d" ]				= loadfx ( "fire/firelp_small_dl_d" );
	level._effect[ "firelp_vhc_lrg_pm_farview" ]		= loadfx ( "fire/firelp_vhc_lrg_pm_farview" );
	
	//dust
	level._effect[ "dust_wind_slow" ]					= loadfx ( "dust/dust_wind_slow_yel_loop" );
	level._effect[ "smoke_oilfire_01" ] 				= loadfx ( "smoke/tunnel_smoke_bog_a" );
	level._effect[ "smoke_oilfire_02" ] 				= loadfx ( "smoke/tunnel_smoke_bog_a" );	

	//exploders
	level._effect[ "statue_explosion" ]					= loadfx( "explosions/exp_pack_doorbreach" );
	level._effect[ "statue_impact" ]					= loadfx( "explosions/grenadeExp_concrete_1" );
	level._effect[ "statue_smoke" ] 					= loadfx( "smoke/thin_light_smoke_S" );	
	level._effect[ "gas_station_explosion" ] 			= loadfx( "explosions/javelin_explosion" );	

	/*-----------------------
	FX: SCRIPTED SEQUENCES
	-------------------------*/	
	level._effect[ "smoke_blue_signal" ] 				= loadfx ( "misc/smoke_blue_signal" );
	//level._effect[ "smoke_orange_signal" ] 				= loadfx ( "misc/smoke_orange_signal" );
	level._effect[ "heat_shimmer_door" ]				= loadfx ( "distortion/abrams_exhaust" );
	level._effect[ "headshot" ]							= loadfx ( "impacts/flesh_hit_head_fatal_exit" );
	level._effect[ "heli_dust_default" ] 				= loadfx ( "treadfx/heli_dust_default" );	

	level._effect[ "palace_at4" ]						= loadfx( "explosions/large_vehicle_explosion" );
	//Tank crush fx
	level._vehicle_effect[ "tankcrush" ][ "window_med" ]	= loadfx( "props/car_glass_med" );
	level._vehicle_effect[ "tankcrush" ][ "window_large" ]	= loadfx( "props/car_glass_large" );
	
	//mortar fx
	level._effect[ "mortar" ][ "dirt" ]					= loadfx( "explosions/large_vehicle_explosion" );

	/*-----------------------
	SOUND EFFECTS
	-------------------------*/	
	level.scr_sound["heli_alarm_loop"]				= "airlift_heli_alarm_loop";
	level.scr_sound["seaknightdoor_open_start"]		= "seaknightdoor_open_start";
	level.scr_sound["seaknightdoor_open_loop"]		= "seaknightdoor_open_loop";
	level.scr_sound["seaknightdoor_open_end"]		= "seaknightdoor_open_end";
	
	/*-----------------------
	EXPLODER SOUND EFFECTS
	-------------------------*/
	level.scr_sound[ "exploder" ][ "100" ]				= "explo_rock";
	level.scr_sound[ "exploder" ][ "500" ]				= "building_explosion3";
	level.scr_sound[ "statue_fall" ]					= "ceiling_collapse";
	level.scr_sound[ "statue_impact" ]					= "ceiling_collapse";
	
	/*-----------------------
	MORTAR SOUND EFFECTS
	-------------------------*/	
	level.scr_sound[ "mortar" ][ "incomming" ]			= "fast_artillery_round";
	//level.scr_sound[ "mortar" ][ "dirt" ]				= "artillery_impact";
	level.scr_sound[ "mortar" ][ "dirt" ]				= "airstrike_explosion";
	
	maps\createfx\airlift_fx::main();
}
