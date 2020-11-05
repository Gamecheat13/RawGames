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
//	level.vehicle_DriveIdle[model] = %british_crusader_tank_drive_idle;
//	level.vehicle_DriveIdle_normal_speed[model] = 10;

	// death fx stuff
	level.vehicle_death_fx[type] = [];
	//this builds an array of effects, timings and such that will be processed by _maps\_vehicle::kill();
//	turretfire = 	loadfx("fire/crusader_fire_turret_large");
//	enginefire =  	loadfx("fire/tank_fire_engine");
	//_______________________build_deathfx( array, effect, tag, sound, bEffectLooping, delay, bSoundlooping )
//	effects = maps\_vehicle::build_deathfx(undefined,enginefire,"tag_right_wheel_03",undefined,true,1,true);
//	effects = maps\_vehicle::build_deathfx(effects,enginefire,"tag_left_wheel_05",undefined,true,1,true);
//	effects = maps\_vehicle::build_deathfx(effects,turretfire,"tag_turret","smallfire",true,1,true);
	effects = maps\_vehicle::build_deathfx(undefined,deathfx,undefined,"explo_metal_rand");
	level.vehicle_death_fx[type] = effects;
	
	//this is the top string the vehicle will get when you aim at it.
//	level.vehicletypefancy[type] = &"VEHICLENAME_CRUSADER_TANK";

	// sets the various treadfx for a vehicle, if not called vehicles of this type won't do cool treadfx
	//maps\_treadfx::main(type);

	// give the vehicle life
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	//rumble that loops during driving of vehicle
	//build_rumble( rumble , scale , duration , radius , basetime , randomaditionaltime )
//	level.vehicle_rumble[type] = maps\_vehicle::build_rumble("tank_rumble", 0.15,4.5,600,1,1);
	
	//build_quake ( scale, duration, radius )
//	level.vehicle_death_earthquake[type] = maps\_vehicle::build_quake(0.25,3,1050);

	//set default team for this vehicletype
	level.vehicle_team[type] = "allies";	
	
	//enables turret
	level.vehicle_hasMainTurret[model] = false;
	
	//enables vehicle on the compass
//	level.vehicle_compassicon[type] = true;
	
	//when the riders on this vehicle get attacked the vehicle gets unloaded
	level.vehicle_unloadwhenattacked[type] = false;
	
	level.vehicle_aianims[type] = setanims();
	level.vehicle_aianims[type] = set_vehicle_anims(level.vehicle_aianims[type]);

	
	// this vehicle will recieve a random name from _vehiclenames
//	level.vehicle_hasname[type] = true;
	
	// might want to rethink implementation on this or other things.  Tanks have convenient tag_walk0-6 or somesuch
//	level.vehicle_walkercount[type] = 6;
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

//	positions[0].getout_delete = true;

/*
pickup_driver_climb_out
pickup_passenger_climb_out
pickup_passenger_RL_idle
pickup_passenger_RL_climb_out
pickup_passenger_RR_idle
pickup_passenger_RR_climb_out
technical_passenger_climb_out

*/

	positions[0].sittag = "tag_driver";
	positions[1].sittag = "tag_passenger";	 
	positions[2].sittag = "tag_guy0";  //RL
	positions[3].sittag = "tag_guy1"; //RR

	positions[0].idle = %technical_driver_idle;
	positions[1].idle = %technical_passenger_idle;
	positions[2].idle = %pickup_passenger_RL_idle;
	positions[3].idle = %pickup_passenger_RR_idle;

	positions[0].getout = %pickup_driver_climb_out;
	positions[1].getout = %pickup_passenger_climb_out;
	positions[2].getout = %pickup_passenger_RL_climb_out;
	positions[3].getout = %pickup_passenger_RR_climb_out;

	//positions[0].getin = %humvee_driver_climb_in;
	//positions[1].getin = %humvee_passenger_in_L;
	//positions[2].getin = %humvee_passenger_in_R;
	//positions[3].getin = %humvee_passenger_in_L;

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