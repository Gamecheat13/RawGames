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

	level.vehicle_hasMainTurret[model] = false;	

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

	
	level.tread_override_thread = ::tread;

	
	maps\_treadfx::main(type);

	
	level.vehicle_life[type] = 9999;
	level.vehicle_life_range_low[type] = 5000;
	level.vehicle_life_range_high[type] = 9999;

	
	level.vehicle_team[type] = "allies";	

	
	level.vehicle_unloadwhenattacked[type] = false;

	
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