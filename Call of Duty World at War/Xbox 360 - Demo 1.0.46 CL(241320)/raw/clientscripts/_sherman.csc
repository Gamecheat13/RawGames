// _sherman.csc
// Sets up clientside behavior for the sherman

#include clientscripts\_vehicle; 

main( model, type )
{
	if( !IsDefined( type ) )
	{
		type = "sherman"; 
	}

	build_exhaust( model, "vehicle/exhaust/fx_exhaust_sherman" ); 
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" ); 

	build_treadfx( type ); 

	build_shoot_rumble( type, "tank_fire" ); 
	build_shoot_shock( type, "tankblast" ); 

	build_rumble( type, "tank_rumble", 0.15, 4.5, 600, 1, 1 ); 
	build_gear( type, "vehicle_usa_tracked_sherman_setA_chassis", "tag_body" ); 
	build_gear( type, "vehicle_usa_tracked_sherman_setA_turret", "tag_turret" ); 
	build_gear( type, "vehicle_usa_tracked_sherman_setB_chassis", "tag_body" ); 
	build_gear( type, "vehicle_usa_tracked_sherman_setB_turret", "tag_turret" ); 
	build_gear( type, "vehicle_usa_tracked_sherman_setC_chassis", "tag_body" ); 
	build_gear( type, "vehicle_usa_tracked_sherman_setC_turret", "tag_turret" ); 
	build_gear( type, "vehicle_usa_tracked_sherman_setD_chassis", "tag_body" ); 
	build_gear( type, "vehicle_usa_tracked_sherman_setD_turret", "tag_turret" ); 
	build_gear( type, "vehicle_usa_tracked_sherman_setE_chassis", "tag_body" ); 
	build_gear( type, "vehicle_usa_tracked_sherman_setE_turret", "tag_turret" ); 	
	build_gear( type, "vehicle_usa_tracked_sherman_setF_chassis", "tag_body" ); 
	build_gear( type, "vehicle_usa_tracked_sherman_setF_turret", "tag_turret" ); 	
}