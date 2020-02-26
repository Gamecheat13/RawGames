#include maps\_vehicle_aianim;
#using_animtree ("vehicles");
main(model,type)
{
	if(!isdefined(type))
		type = "truck";
	level.vehicleInitThread[type][model] = ::init_local;

	deathfx = undefined;
	switch(model)	
	{
		
		case "vehicle_pickup_roobars":
			precachemodel("vehicle_pickup_roobars");
			precachemodel("vehicle_pickup_techinal_destroyed");
			level.vehicle_deathmodel[model] = "vehicle_pickup_techinal_destroyed";
			break;
		case "vehicle_pickup_4door":
			precachemodel("vehicle_pickup_4door");
			precachemodel("vehicle_pickup_techinal_destroyed");
			level.vehicle_deathmodel[model] = "vehicle_pickup_4door";
			break;
		case "vehicle_opfor_truck":
			precachemodel("vehicle_opfor_truck");
			precachemodel("vehicle_pickup_techinal_destroyed");
			level.vehicle_deathmodel[model] = "vehicle_pickup_techinal_destroyed";
			break;
		case "vehicle_pickup_technical":
			precachemodel("vehicle_pickup_technical");
			precachemodel("vehicle_pickup_techinal_destroyed");
			level.vehicle_deathmodel[model] = "vehicle_pickup_techinal_destroyed";
			break;
	}
	deathfx = loadfx ("explosions/large_vehicle_explosion");
	precachevehicle(type);
	
	level.vehicleanimtree[model] = #animtree;



	
	level.vehicle_death_fx[type] = [];
	


	



	effects = maps\_vehicle::build_deathfx(undefined,deathfx,undefined,"explo_metal_rand");
	level.vehicle_death_fx[type] = effects;
	
	


	
	

	
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	
	

	
	


	
	level.vehicle_team[type] = "allies";	
	
	
	level.vehicle_hasMainTurret[model] = false;
	
	

	
	
	level.vehicle_unloadwhenattacked[type] = false;
	
	level.vehicle_aianims[type] = setanims();
	level.vehicle_aianims[type] = set_vehicle_anims(level.vehicle_aianims[type]);

	
	

	
	

	level.vehicle_unloadgroups[type] = Unload_Groups();


}

init_local()
{
}

#using_animtree ("vehicles");
set_vehicle_anims(positions)
{

	positions[0].vehicle_getoutanim = %door_pickup_driver_climb_out;
	positions[1].vehicle_getoutanim = %door_pickup_passenger_climb_out;
	positions[2].vehicle_getoutanim = %door_pickup_passenger_RL_climb_out;
	positions[3].vehicle_getoutanim = %door_pickup_passenger_RR_climb_out;
		return positions;
}


#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	for(i=0;i<4;i++)
		positions[i] = spawnstruct();





	positions[0].sittag = "tag_driver";
	positions[1].sittag = "tag_passenger";	 
	positions[2].sittag = "tag_guy0";  
	positions[3].sittag = "tag_guy1"; 

	positions[0].idle = %technical_driver_idle;
	positions[1].idle = %technical_passenger_idle;
	positions[2].idle = %pickup_passenger_RL_idle;
	positions[3].idle = %pickup_passenger_RR_idle;

	positions[0].getout = %pickup_driver_climb_out;
	positions[1].getout = %pickup_passenger_climb_out;
	positions[2].getout = %pickup_passenger_RL_climb_out;
	positions[3].getout = %pickup_passenger_RR_climb_out;

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups["passengers"] = [];
	unload_groups["all"] = [];

	group = "passengers";
	unload_groups[group][unload_groups[group].size] = 1;
	unload_groups[group][unload_groups[group].size] = 2;
	unload_groups[group][unload_groups[group].size] = 3;

	group = "all";
	unload_groups[group][unload_groups[group].size] = 0;
	unload_groups[group][unload_groups[group].size] = 1;
	unload_groups[group][unload_groups[group].size] = 2;
	unload_groups[group][unload_groups[group].size] = 3;

	unload_groups["default"] = unload_groups["all"];
	
	return unload_groups;
	
}