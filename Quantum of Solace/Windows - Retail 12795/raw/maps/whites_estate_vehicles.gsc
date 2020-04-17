#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;

////////////////////////////////////////  vehicle script  //////////////////////////////////////
//NOTE: miami_science_center_vehicle_script
//
//
//
//
//
//
//
////////////////////////////////////////////////////////////////////////////////////////////////


// bond_veh_death monitors the health of the vehicle and calls an explosion when it reaches 0
//[vehicle] thread maps\_vehicle::bond_veh_death();

// bond_veh_flat_tire monitors which tire has been shot and calls the flat tire animation
//[vehicle] thread maps\_vehicle::bond_veh_flat_tire();

// bond_veh_running_lights creates headlights and breaklights fx
//[vehicle] thread maps\_vehicle::bond_veh_running_lights();

// bond_veh_exhaust creates exhaust fx
//[vehicle] thread maps\_vehicle::bond_veh_exhaust();

// bond_veh_exhauset crates the water splashes on a moving vehicle
//[vehicle] thread maps\_vehicle::bond_veh_roadfx();

main()
{
	// precache vehicles for street traffic


	//level thread spawn_northbound_lane_vehicles();
	//level thread spawn_southbound_lane_vehicles();
}


// spawn street vehicle functions south lane
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

// spawn street vehicle functions north lane
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

//	delete car when it's at the end node.
delete_car_at_endnode()
{
	self waittill( "reached_end_node" );
	self delete();
}
