#include maps\_vehicle_aianim;
#include maps\_vehicle;

main(model,type)
{
	
	// Makes sherman the default vehicle type
	if(!isdefined(type))
	{
		type = "tiger";
	}
	
	build_template( "tiger", model, type );
	
	// Init anything to be used globally
	level.vehicleInitThread[type][model] = ::init_local;

	// Death FX for this vehicle
	deathfx = loadfx ("explosions/large_vehicle_explosion");

	// Models to set up precaching
	switch(model)	
	{
		case "vehicle_tiger_woodland":
			precachemodel("vehicle_tiger_woodland");
			precachemodel("vehicle_tiger_woodland_d");					
			level.vehicle_deathmodel[model] = "vehicle_tiger_woodland_d";
			break;
		case "vehicle_tiger_woodland_brush":
			precachemodel("vehicle_tiger_woodland_brush");
			precachemodel("vehicle_tiger_woodland_d_brush");					
			level.vehicle_deathmodel[model] = "vehicle_tiger_woodland_d_brush";
			break;
	}
	precachevehicle(type);

	// death fx stuff
	level.vehicle_death_fx[type] = [];
	// 2/21/07 - THESE ARE TEMP TURRETS

	// Build the mg turrets
	turrets = maps\_vehicle::build_turret( "m1a1_coaxial_mg", "tag_turret2", "vehicle_m1a1_abrams_PKT_Coaxial_MG", false );
	level.vehicle_mgturret[type] = turrets;
	
	// sets the various treadfx for a vehicle, if not called vehicles of this type won't do cool treadfx
	maps\_treadfx::main(type);

	// give the vehicle life
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	//set default team for this vehicletype
	level.vehicle_team[type] = "axis";	
	
	//enables turret
	level.vehicle_hasMainTurret[model] = true;
	level.vehicle_turretFireTime[model] = 4;
	
	//enables vehicle on the compass
	level.vehicle_compassicon[type] = true;
	
	// this vehicle will recieve a random name from _vehiclenames
	//level.vehicle_hasname[type] = true;
	
	// Max walkers along side the tanks, tied to amount of tag_walkerX tags.
	level.vehicle_walkercount[type] = 6;

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
	for(i=0;i<10;i++)
		positions[i] = spawnstruct();

	positions[0].sittag = "tag_guy1";
	positions[1].sittag = "tag_guy2";
	positions[2].sittag = "tag_guy3";
	positions[3].sittag = "tag_guy4";
	positions[4].sittag = "tag_guy5";
	positions[5].sittag = "tag_guy6";
	positions[6].sittag = "tag_guy7";
	positions[7].sittag = "tag_guy8";
	positions[8].sittag = "tag_guy9";
	positions[9].sittag = "tag_guy10";
	
	positions[0].idle = %humvee_passenger_idle_R;
	positions[1].idle = %humvee_passenger_idle_R;
	positions[2].idle = %humvee_passenger_idle_R;
	positions[3].idle = %humvee_passenger_idle_R;
	positions[4].idle = %humvee_passenger_idle_R;
	positions[5].idle = %humvee_passenger_idle_R;
	positions[6].idle = %humvee_passenger_idle_R;
	positions[7].idle = %humvee_passenger_idle_R;
	positions[8].idle = %humvee_passenger_idle_R;
	positions[9].idle = %humvee_passenger_idle_R;
						
	positions[0].getout = %humvee_passenger_out_R;
	positions[1].getout = %humvee_passenger_out_R;
	positions[2].getout = %humvee_passenger_out_R;
	positions[3].getout = %humvee_passenger_out_R;
	positions[4].getout = %humvee_passenger_out_R;
	positions[5].getout = %humvee_passenger_out_R;
	positions[6].getout = %humvee_passenger_out_R;
	positions[7].getout = %humvee_passenger_out_R;
	positions[8].getout = %humvee_passenger_out_R;
	positions[9].getout = %humvee_passenger_out_R;
	
	positions[0].getin = %humvee_passenger_in_R;
	positions[1].getin = %humvee_passenger_in_R;
	positions[2].getin = %humvee_passenger_in_R;
	positions[3].getin = %humvee_passenger_in_R;
	positions[4].getin = %humvee_passenger_in_R;
	positions[5].getin = %humvee_passenger_in_R;
	positions[6].getin = %humvee_passenger_in_R;
	positions[7].getin = %humvee_passenger_in_R;
	positions[8].getin = %humvee_passenger_in_R;
	positions[9].getin = %humvee_passenger_in_R;
	
	return positions;
}

