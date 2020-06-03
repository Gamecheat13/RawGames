// _t34.csc
// Sets up clientside behavior for the t34

#include clientscripts\_vehicle;

main(model,type)
{
	
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_t34" );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( "see2_t34" );
	build_rumble( "see2_t34", "tank_rumble", 0.15, 4.5, 600, 1, 1 );	
	//build_gear( "see2_t34", "vehicle_rus_tracked_t34_seta_body", "tag_body" );
	//build_gear( "see2_t34", "vehicle_rus_tracked_t34_seta_turret", "tag_turret" );
	build_gear( "see2_t34", "vehicle_rus_tracked_t34_setb_body", "tag_body" );
	build_gear( "see2_t34", "vehicle_rus_tracked_t34_setb_turret", "tag_turret" );
	build_gear( "see2_t34", "vehicle_rus_tracked_t34_setc_body", "tag_body" );
	build_gear( "see2_t34", "vehicle_rus_tracked_t34_setc_turret", "tag_turret" );	
}

