#include maps\_utility;
main(vehicletype)
{
	
	if (!isdefined (vehicletype))
		return;
	level.vehicle_treads[vehicletype] = true;
	switch (vehicletype)
	{
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		case "blackhawk":
			setallvehiclefx( vehicletype, "dust/heli_dust_default" );  
			setvehiclefx( vehicletype, "water", "treadfx/heli_water" );
			break;
			
		case "blackhawk_sca_bossfight":
			setallvehiclefx( vehicletype, "dust/heli_dust_default" );  
			setvehiclefx( vehicletype, "water", "treadfx/heli_water" );
			break;
		
		case "sedan":
			
			setvehiclefx( vehicletype, "water", "vehicles/night/vehicle_night_car_roadsplash" );
			break;

		case "van":
			setallvehiclefx( vehicletype, "vehicles/day/vehicle_default_dust" ); 
			setvehiclefx( vehicletype, "water", "vehicles/night/vehicle_night_car_roadsplash" );
			break;
			
		case "suv":
			
			setvehiclefx( vehicletype, "water", "vehicles/night/vehicle_night_car_roadsplash" );
			break;

		case "hatchback":
			
			setvehiclefx( vehicletype, "water", "vehicles/night/vehicle_night_car_roadsplash" );
			break;

		case "truck":
			
			setvehiclefx( vehicletype, "water", "vehicles/night/vehicle_night_car_roadsplash" );
			break;

		case "motor_boat":
			setallvehiclefx( vehicletype, "maps/venice/gettler_boat_wake" ); 
			
			break;

		case "gondola":
			
			
			break;

		default: 
			
			setallvehiclefx( vehicletype, "vehicles/day/vehicle_default_dust" ); 
			setvehiclefx( vehicletype, "water", "vehicles/night/vehicle_night_car_roadsplash" );
			break;
	}
}

setvehiclefx( vehicletype, material, fx )
{
	if ( !isdefined( level._vehicle_effect ) )
		level._vehicle_effect = [];
	if ( !isdefined ( fx ) )
		level._vehicle_effect[ vehicletype ][ material ] = -1;
	else
		level._vehicle_effect[ vehicletype ][ material ] = loadfx( fx );
}

setallvehiclefx( vehicletype, fx )
{
	setvehiclefx( vehicletype, "brick" ,fx);
 	setvehiclefx( vehicletype, "bark" ,fx);
 	setvehiclefx( vehicletype, "carpet" ,fx);
 	setvehiclefx( vehicletype, "cloth" ,fx);
 	setvehiclefx( vehicletype, "concrete" ,fx);
 	setvehiclefx( vehicletype, "dirt" ,fx);
 	setvehiclefx( vehicletype, "flesh" ,fx);
 	setvehiclefx( vehicletype, "foliage" ,fx);
 	setvehiclefx( vehicletype, "glass" ,fx);
 	setvehiclefx( vehicletype, "grass" ,fx);
 	setvehiclefx( vehicletype, "gravel" ,fx);
 	setvehiclefx( vehicletype, "ice" ,fx);
 	setvehiclefx( vehicletype, "metal" ,fx);
 	setvehiclefx( vehicletype, "mud" ,fx);
 	setvehiclefx( vehicletype, "paper" ,fx);
 	setvehiclefx( vehicletype, "plaster" ,fx);
 	setvehiclefx( vehicletype, "rock" ,fx);
 	setvehiclefx( vehicletype, "sand" ,fx);
 	setvehiclefx( vehicletype, "snow" ,fx);
 	setvehiclefx( vehicletype, "water" ,fx);
 	setvehiclefx( vehicletype, "wood" ,fx);
 	setvehiclefx( vehicletype, "asphalt" ,fx);
 	setvehiclefx( vehicletype, "ceramic" ,fx);
 	setvehiclefx( vehicletype, "plastic" ,fx);
 	setvehiclefx( vehicletype, "rubber" ,fx);
 	setvehiclefx( vehicletype, "cushion" ,fx);
 	setvehiclefx( vehicletype, "fruit" ,fx);
 	setvehiclefx( vehicletype, "painted metal" ,fx);
 	setvehiclefx( vehicletype, "default" ,fx);
	setvehiclefx( vehicletype, "none" ,fx);
}
