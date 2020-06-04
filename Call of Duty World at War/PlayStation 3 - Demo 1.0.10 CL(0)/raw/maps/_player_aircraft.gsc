
#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );

main(model,type)
{
	if(!isdefined(type))
		type = "player_aircraft";

	build_template( "technical", model, type );
	build_localinit( ::init_local );
	switch( model )
	{
		case "vehicle_usa_aircraft_f4ucorsair":
			build_deathmodel( "vehicle_usa_aircraft_f4ucorsair", "vehicle_usa_aircraft_f4ucorsair" );
			break;
		case "vehicle_p51_mustang":
			build_deathmodel( "vehicle_p51_mustang", "vehicle_p51_mustang" );
			break;
	}
	
//	build_turret( "50cal_turret_technical", "tag_50cal", "weapon_pickup_technical_mg50cal", true );
//	build_drive( %technical_driving_idle_forward, %technical_driving_idle_backward, 10 );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_life( 999, 500, 1500 );
	build_team( "axis" );
//	build_aianims( ::setanims , ::set_vehicle_anims );
//	build_unload_groups( ::Unload_Groups );
		
		level.vehicle_death_thread[type] = ::kill_driver;
}

init_local()
{
}

kill_driver()
{
	println("******************KILLING DRIVER");
	driver = self getvehicleowner();
	
	if ( isdefined(driver) )
	{
		driver DoDamage( driver.health + 1, ( 0, 0, 0 ) ); 
	}	
}