#include maps\_vehicle_aianim;
#include maps\_vehicle;

#using_animtree("vehicles");

main(model, type)
{
	if(!isdefined(type))
	{
		if (model == "v_astonmartindbs_radiant")
		{
			type = "aston_martin";	
		}
		else
		{
			type = "sedan";
		}
	}

	build_template(type, model);
	build_localinit(::init_local);

	

	level.vehicle_hasMainTurret[model] = false;	

	switch(model)	
	{
		case "v_sedan_blue_radiant":
			precachemodel("v_sedan_blue_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_blue_radiant";
			break;

		case "v_sedan_gray_radiant":
			precachemodel("v_sedan_gray_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_gray_radiant";
			break;

		case "v_sedan_silver_radiant":
			precachemodel("v_sedan_silver_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_silver_radiant";
			break;
			
		case "v_sedan_clean_gunmetal_radiant":
			precachemodel("v_sedan_clean_gunmetal_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_clean_gunmetal_radiant";
			break;
			
		case "v_sedan_clean_silver_radiant":
			precachemodel("v_sedan_clean_silver_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_clean_silver_radiant";
			break;
			
		case "v_sedan_clean_black_radiant":
			precachemodel("v_sedan_clean_black_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_clean_black_radiant";
			break;
			
		case "v_sedan_clean_blue_radiant":
			precachemodel("v_sedan_clean_blue_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_clean_blue_radiant";
		break;

		case "v_sedan_tan_radiant":
			precachemodel("v_sedan_tan_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_tan_radiant";
			break;

		case "v_sedan_police_radiant":
			precachemodel("v_sedan_police_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_police_radiant";
			break;

		case "v_astonmartindbs_radiant":
			precachemodel("v_astonmartindbs_radiant");
			level.vehicle_deathmodel[model] = "v_astonmartindbs_radiant";
			break;
			
		case "v_sedan_us_gunmetal_radiant":
			precachemodel("v_sedan_us_gunmetal_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_us_gunmetal_radiant";
			break;	

		case "v_sedan_us_black_radiant":
			precachemodel("v_sedan_us_black_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_us_black_radiant";
			break;				

		case "v_sedan_us_silver_radiant":
			precachemodel("v_sedan_us_silver_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_us_silver_radiant";
			break;	

		case "v_sedan_us_blue_radiant":
			precachemodel("v_sedan_us_blue_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_us_blue_radiant";
			break;	
	
	}
	
	level.vehicleanimtree[model] = #animtree;
	level.vehicle_DriveIdle[model] = %v_auto_tire_spin;
	level.vehicle_DriveIdle_normal_speed[model] = 10;

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	level.vehicle_death_fx[type] = Loadfx( "vehicles/destructible/vehicle_explosion_large" );
	level.vehicle_headlight_fx[type] = Loadfx( "vehicles/night/vehicle_night_headlight01" );
	level.vehicle_breaklight_fx[type] = Loadfx( "vehicles/night/vehicle_night_brakelight01" );
	level.vehicle_exhaust_fx[type] = Loadfx( "vehicles/night/vehicle_night_exhaust" );

	
	level._vehicle_damage_effect[type]["grind"] = Loadfx("impacts/large_metalhit");

	


	
	



	
	
	maps\_treadfx::main(type);

	
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	
	

	
	


	
	level.vehicle_team[type] = "allies";	
	
	
	

	
	
	level.vehicle_unloadwhenattacked[type] = false;
	
	

	build_aianims(::setanims, ::set_vehicle_anims);
	
	

	
	


	
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
