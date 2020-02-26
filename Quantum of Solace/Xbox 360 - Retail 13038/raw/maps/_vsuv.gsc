#include maps\_vehicle_aianim;
#include maps\_vehicle;

#using_animtree("vehicles");

main(model, type)
{
	if(!isdefined(type))
	{
		type = "suv";
	}

	build_template(type, model);
	build_localinit(::init_local);

	level.vehicle_hasMainTurret[model] = false;	//no turret

	switch(model)	
	{
		case "v_suv_clean_radiant":
			precachemodel("v_suv_clean_radiant");
			level.vehicle_deathmodel[model] = "v_suv_clean_radiant";
			break;

		case "v_suv_clean_silver_radiant":
			precachemodel("v_suv_clean_silver_radiant");
			level.vehicle_deathmodel[model] = "v_suv_clean_silver_radiant";
			break;

		case "v_suv_clean_black_radiant":
			precachemodel("v_suv_clean_black_radiant");
			level.vehicle_deathmodel[model] = "v_suv_clean_black_radiant";
			break;

		case "v_suv_clean_red_radiant":
			precachemodel("v_suv_clean_red_radiant");
			level.vehicle_deathmodel[model] = "v_suv_clean_red_radiant";
			break;

		case "v_suv_clean_blue_radiant":
			precachemodel("v_suv_clean_blue_radiant");
			level.vehicle_deathmodel[model] = "v_suv_clean_blue_radiant";
			break;	
			
		case "v_suv_us_blue_radiant":
			precachemodel("v_suv_us_blue_radiant");
			level.vehicle_deathmodel[model] = "v_suv_us_blue_radiant";
			break;
			
		case "v_suv_us_red_radiant":
			precachemodel("v_suv_us_red_radiant");
			level.vehicle_deathmodel[model] = "v_suv_us_red_radiant";
			break;					

		case "v_suv_us_gunmetal_radiant":
			precachemodel("v_suv_us_gunmetal_radiant");
			level.vehicle_deathmodel[model] = "v_suv_us_gunmetal_radiant";
			break;
	}
	
	level.vehicleanimtree[model] = #animtree;
	level.vehicle_DriveIdle[model] = %v_auto_tire_spin;
	level.vehicle_DriveIdle_normal_speed[model] = 10;

	level.vehicle_death_fx[type] = Loadfx( "vehicles/destructible/vehicle_explosion_large" );
	level.vehicle_headlight_fx[type] = Loadfx( "vehicles/night/vehicle_night_headlight01" );
	level.vehicle_breaklight_fx[type] = Loadfx( "vehicles/night/vehicle_night_brakelight01" );
	level.vehicle_exhaust_fx[type] = Loadfx( "vehicles/night/vehicle_night_exhaust" );

	// sets the various treadfx for a vehicle, if not called vehicles of this type won't do cool treadfx
	maps\_treadfx::main(type);

	// give the vehicle life
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	level.vehicle_team[type] = "allies";	
	
	level.vehicle_unloadwhenattacked[type] = false;
	
	build_aianims(::setanims, ::set_vehicle_anims);
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