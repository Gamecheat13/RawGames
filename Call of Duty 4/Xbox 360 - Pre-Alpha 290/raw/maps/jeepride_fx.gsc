#include common_scripts\utility;
#include maps\_utility;
#include maps\_weather;

main()
{
	
	flag_init("cargoship_lighting_off");
	 
	//don't kill me for making this effect, was curious about some lighting stuff and it ended up looking kind of cool -Nathan
	level._effect["tunnel_light"]					= loadfx ("test/jeepride_tunnellight");
	level._effect["tunnel_light_flicker"]					= loadfx ("test/jeepride_tunnellight_flicker");

	level._effect["fog_icbm"]					= loadfx ("weather/fog_icbm");
	level._effect["fog_icbm_a"]					= loadfx ("weather/fog_icbm_a");
	level._effect["fog_icbm_b"]					= loadfx ("weather/fog_icbm_b");
	level._effect["fog_icbm_c"]					= loadfx ("weather/fog_icbm_c");	
	level._effect["leaves_runner_lghtr"]		= loadfx ("misc/leaves_runner_lghtr");
	level._effect["leaves_runner_lghtr_1"]		= loadfx ("misc/leaves_runner_lghtr_1");
	level._effect["insect_trail_runner_icbm"]	= loadfx ("misc/insect_trail_runner_icbm");
	level._effect["cloud_bank_far"]				= loadfx ("weather/jeepride_cloud_bank_far");
	level._effect["moth_runner"]				= loadfx ("misc/moth_runner");
	level._effect["hawks"]						= loadfx ("misc/hawks");
	level._effect["mist_icbm"]					= loadfx ("weather/mist_icbm");	
	level._effect["exp_wall"]			= loadfx("props/wallExp_concrete");
	
	level._effect[ "tunnelspark" ] = loadfx( "misc/jeepride_tunnel_sparks" );
	level._effect[ "tunnelspark_dl" ] = loadfx( "misc/jeepride_tunnel_sparks" );

	level.flare_fx["hind"] 							= loadfx( "misc/flares_cobra" );

}

jeepride_fxline()
{
//	comment out this stuff to record effects. 
//	make sure jeepride_fxline_* are checked out so that the game can write to them.
//	also check to see if a new one has been written and add that to P4
//	emitters are setup in these prefab map files they can be fastfiled over
	
//	sparkrig_vehicle_80s_hatch1_brn_destructible.map
//	sparkrig_vehicle_bm21_mobile_bed.map
//	sparkrig_vehicle_luxurysedan_test.map
//	sparkrig_vehicle_pickup_4door.map
//	sparkrig_vehicle_uaz_open.map
//	sparkrig_vehicle_uaz_open_for_ride.map
	
	maps\scriptgen\jeepride_fxline_0::fxline();
	maps\scriptgen\jeepride_fxline_1::fxline();
	maps\scriptgen\jeepride_fxline_2::fxline();
	maps\scriptgen\jeepride_fxline_3::fxline();
}
