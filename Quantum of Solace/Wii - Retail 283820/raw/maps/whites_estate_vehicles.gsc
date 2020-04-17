#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;




























main()
{
	


	
	
}



spawn_northbound_lane_vehicles()
{
	northbound_lane_spawnpoint = getent( "northbound_lane_spawnpoint", "targetname" );
	i = 0;
	wait( 10 );
	
	while(1)
	{
		random_spawn_time = randomintrange(10,15);

		spawnvehicle("v_sedan_silver_radiant", "lane_northbound_vehicle" + i, "sedan", (northbound_lane_spawnpoint.origin), (northbound_lane_spawnpoint.angles));
		north_lane = getvehiclenode("north_lane", "targetname");
		vehicle = getent( "lane_northbound_vehicle" + i, "targetname" );
		vehicle.health = 10000;
	
		vehicle.vehicletype = "sedan";
		vehicle.script_int = 1;
		maps\_vehicle::vehicle_init( vehicle );
		
		vehicle attachpath( north_lane );
		vehicle startpath( north_lane );
		vehicle setspeed(50, 50, 50);
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );
		
		if( i == 10 )
		{
			i = 0;
		}
	}
}


spawn_southbound_lane_vehicles()
{
	southbound_lane_spawnpoint = getent( "southbound_lane_spawnpoint", "targetname" );
	i = 0;
	wait( 10 );
	
	while(1)
	{
		random_spawn_time = randomintrange(8,14);

		spawnvehicle("v_sedan_silver_radiant", "lane_southbound_vehicle" + i, "sedan", (southbound_lane_spawnpoint.origin), (southbound_lane_spawnpoint.angles));
		south_lane = getvehiclenode("south_lane", "targetname");
		vehicle = getent( "lane_southbound_vehicle" + i, "targetname" );
		vehicle.health = 10000;
	
		vehicle.vehicletype = "sedan";
		vehicle.script_int = 1;
		maps\_vehicle::vehicle_init( vehicle );
		
		vehicle attachpath( south_lane );
		vehicle startpath( south_lane );
		vehicle setspeed(50, 50, 50);
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );
		
		if( i == 10 )
		{
			i = 0;
		}
	}
}


delete_car_at_endnode()
{
	self waittill( "reached_end_node" );
	self delete();
}
