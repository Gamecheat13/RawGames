#include maps\_vehicle_aianim;
#include maps\_vehicle;

#using_animtree("vehicles");

main(model, type)
{
	if(!isdefined(type))
	{
		type = "motor_boat";
	}

	build_template(type, model);
	build_localinit(::init_local);

	level.vehicle_hasMainTurret[model] = false;	//no turret

	switch(model)	
	{
		case "v_boat_motor_a":
			precachemodel("v_boat_motor_a");
			level.vehicle_deathmodel[model] = "v_boat_motor_a";
			break;

		case "v_boat_motor_b":
			precachemodel("v_boat_motor_b");
			level.vehicle_deathmodel[model] = "v_boat_motor_b";
			break;
	}

	level.vehicleanimtree[model] = #animtree;
	level.vehicle_DriveIdle[model] = %v_auto_tire_spin;
	level.vehicle_DriveIdle_normal_speed[model] = 10;

	// set tread override function
	level.tread_override_thread = ::tread;

	// sets the various treadfx for a vehicle, if not called vehicles of this type won't do cool treadfx
	maps\_treadfx::main(type);

	// give the vehicle life
	level.vehicle_life[type] = 9999;
	level.vehicle_life_range_low[type] = 5000;
	level.vehicle_life_range_high[type] = 9999;

	//set default team for this vehicletype
	level.vehicle_team[type] = "allies";	

	//when the riders on this vehicle get attacked the vehicle gets unloaded
	level.vehicle_unloadwhenattacked[type] = false;

	//BOND_MOD: vehicle damage
	maps\_vehicle_damage::setup(model);
}

init_local()
{
}

#using_animtree("tank");
set_vehicle_anims(positions)
{
	return positions;
}

#using_animtree("generic_human");
setanims()
{
	positions = [];
	return positions;
}