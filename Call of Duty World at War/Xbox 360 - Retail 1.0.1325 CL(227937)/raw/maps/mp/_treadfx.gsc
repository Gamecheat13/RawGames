#include maps\mp\_utility;
main(vehicletype)
{
	//this sets default tread and tire fx for vehicles - they can be overwritten in level scripts
	if (!isdefined (vehicletype))
		return;
	level.vehicle_treads[vehicletype] = true;
	switch (vehicletype)
	{
		default: //if the vehicle isn't in this list it will use these effects
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_dust" );
			setvehiclefx( vehicletype, "concrete", "vehicle/treadfx/fx_treadfx_tiger_concrete" );
			setvehiclefx( vehicletype, "rock", "vehicle/treadfx/fx_treadfx_tiger_concrete" );
			setvehiclefx( vehicletype, "asphalt", "vehicle/treadfx/fx_treadfx_tiger_asphalt" );
			setvehiclefx( vehicletype, "gravel", "vehicle/treadfx/fx_treadfx_tiger_asphalt" );
			setvehiclefx( vehicletype, "dirt", "vehicle/treadfx/fx_treadfx_tiger_dirt" );
			setvehiclefx( vehicletype, "grass", "vehicle/treadfx/fx_treadfx_tiger_grass" );
			setvehiclefx( vehicletype, "mud", "vehicle/treadfx/fx_treadfx_tiger_mud" );	
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
 	setvehiclefx( vehicletype, "paintedmetal" ,fx);
 	setvehiclefx( vehicletype, "default" ,fx);
	setvehiclefx( vehicletype, "none" ,fx);
}