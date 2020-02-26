#include maps\_vehicle_aianim;
main(model,type)
{
	
	// Makes sherman the default vehicle type
	if(!isdefined(type))
	{
		type = "jeep";
	}
	
	// Init anything to be used globally
	level.vehicleInitThread[type][model] = ::init_local;

	// Death FX for this vehicle
	deathfx = loadfx ("explosions/large_vehicle_explosion");

	// Models to set up precaching
	switch(model)	
	{
		case "vehicle_american_jeep":
			precachemodel("vehicle_american_jeep");
			precachemodel("vehicle_american_jeep_damage");					
			level.vehicle_deathmodel[model] = "vehicle_american_jeep_damage";
			break;
		case "vehicle_american_jeep_can":
			precachemodel("vehicle_american_jeep_can");
			precachemodel("vehicle_american_jeep_can_damage");					
			level.vehicle_deathmodel[model] = "vehicle_american_jeep_can_damage";
			break;
		case "vehicle_american_jeep_cot":
			precachemodel("vehicle_american_jeep_cot");
			precachemodel("vehicle_american_jeep_cot_damage");					
			level.vehicle_deathmodel[model] = "vehicle_american_jeep_cot_damage";
			break;
		case "vehicle_russia_jeep":
			precachemodel("vehicle_russia_jeep");
			precachemodel("vehicle_russia_jeep_dmg");					
			level.vehicle_deathmodel[model] = "vehicle_russia_jeep_dmg";
			break;
		case "vehicle_russia_jeep_can":
			precachemodel("vehicle_russia_jeep_can");
			precachemodel("vehicle_russia_jeep_can_dmg");					
			level.vehicle_deathmodel[model] = "vehicle_russia_jeep_can_dmg";
			break;		
		case "vehicle_russia_jeep_cot":
			precachemodel("vehicle_russia_jeep_cot");
			precachemodel("vehicle_russia_jeep_cot_dmg");					
			level.vehicle_deathmodel[model] = "vehicle_russia_jeep_cot_dmg";
			break;			
		case "test_willysjeep_cod3":
			precachemodel("test_willysjeep_cod3");
			precachemodel("test_willysjeep_cod3");					
			level.vehicle_deathmodel[model] = "test_willysjeep_cod3";
			break;	
	}
	precachevehicle(type);

	// death fx stuff
	level.vehicle_death_fx[type] = [];
	// 2/21/07 - THESE ARE TEMP TURRETS
	
	// sets the various treadfx for a vehicle, if not called vehicles of this type won't do cool treadfx
	maps\_treadfx::main(type);

	// give the vehicle life
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	//set default team for this vehicletype
	level.vehicle_team[type] = "allies";	
	
	//enables turret
	level.vehicle_hasMainTurret[model] = false;
	
	//enables vehicle on the compass
	level.vehicle_compassicon[type] = true;
	
	// this vehicle will recieve a random name from _vehiclenames
	//level.vehicle_hasname[type] = true;

	// Set up the animations for riders	
	level.vehicle_aianims[type] = setanims();

}

// Anthing specific to this vehicle, used globally.
init_local()
{
	
}

// Animtion set up for vehicle anims
#using_animtree ("tank");
set_vehicle_anims(positions)
{
	return positions;
}


// Animation set up for AI on the tank
// 2/21/07 - THESE ARE TEMP ANIMS
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
	
	positions[0].idle = %humvee_passenger_idle_R;
	positions[1].idle = %humvee_passenger_idle_R;
	positions[2].idle = %humvee_passenger_idle_R;
	positions[3].idle = %humvee_passenger_idle_R;
						
	positions[0].getout = %humvee_passenger_out_R;
	positions[1].getout = %humvee_passenger_out_R;
	positions[2].getout = %humvee_passenger_out_R;
	positions[3].getout = %humvee_passenger_out_R;
	
	positions[0].getin = %humvee_passenger_in_R;
	positions[1].getin = %humvee_passenger_in_R;
	positions[2].getin = %humvee_passenger_in_R;
	positions[3].getin = %humvee_passenger_in_R;
	
	return positions;
}

