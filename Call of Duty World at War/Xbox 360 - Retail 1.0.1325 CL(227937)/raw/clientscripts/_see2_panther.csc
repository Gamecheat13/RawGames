// _panther.csc
// Sets up clientside behavior for the panther

#include clientscripts\_vehicle;

main(model,type)
{
	
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_panther" );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( "see2_panther" );
	build_rumble( "see2_panther", "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	build_gear( "see2_panther", "vehicle_ger_tracked_panther_seta_body", "tag_body" );
	build_gear( "see2_panther", "vehicle_ger_tracked_panther_seta_turret", "tag_turret" );
	build_gear( "see2_panther", "vehicle_ger_tracked_panther_setb_body", "tag_body" );
	build_gear( "see2_panther", "vehicle_ger_tracked_panther_setb_turret", "tag_turret" );
	build_gear( "see2_panther", "vehicle_ger_tracked_panther_setc_body", "tag_body" );
	build_gear( "see2_panther", "vehicle_ger_tracked_panther_setc_turret", "tag_turret" );	
}

