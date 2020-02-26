// _type97.csc
// Sets up clientside behavior for the type97

#include clientscripts\_vehicle; 

main( model, type )
{
	if( !IsDefined( type ) )
	{
		type = "type97"; 
	}

	build_shoot_rumble( type, "tank_fire" ); 
	build_shoot_shock( type, "tankblast" ); 

	
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_t97" ); 
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" ); 
	build_treadfx( type ); 
	build_rumble( type, "tank_rumble", 0.15, 4.5, 600, 1, 1 ); 
	build_gear( type, "vehicle_jap_type97_seta_chassis", "tag_body" ); 
	build_gear( type, "vehicle_jap_type97_seta_turret", "tag_turret" ); 
	build_gear( type, "vehicle_jap_type97_setb_chassis", "tag_body" ); 
	build_gear( type, "vehicle_jap_type97_setb_turret", "tag_turret" ); 
	build_gear( type, "vehicle_jap_type97_setc_chassis", "tag_body" ); 
	build_gear( type, "vehicle_jap_type97_setc_turret", "tag_turret" ); 	
	
}