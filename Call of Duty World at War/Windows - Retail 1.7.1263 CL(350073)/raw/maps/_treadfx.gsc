#include maps\_utility;
main(vehicletype)
{
	//this sets default tread and tire fx for vehicles - they can be overwritten in level scripts
	if (!isdefined (vehicletype))
		return;
	level.vehicle_treads[vehicletype] = true;
	switch (vehicletype)
	{
	// jeeps, trucks, other wheeled
		case "willys":
			level.vehicle_treads[vehicletype] = false;
			setallvehiclefx( vehicletype, undefined );  
			break;
		case "gmc":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_dust" );
			break;
		case "horch":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_dust" );
			break;
		case "opel":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_dust" );
			break;
		case "sdk":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_dust" );
			break;
		case "type94":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_dust" );
			break;	
		case "type95":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_dust" );
			break;	
		case "wc51":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_dust" );
			break;	
	// water based & amphibious
		case "jap_ptboat":
			//level.vehicle_treads[vehicletype] = false;
			setallvehiclefx( vehicletype, "maps/fly/fx_wake_ptboat" );
			break;
		case "rubber_raft":
			level.vehicle_treads[vehicletype] = false;
			setvehiclefx( vehicletype, "water", "maps/mak/fx_water_wake_boat" );
			break;
		case "buffalo":
			setallvehiclefx( vehicletype, "vehicle/water/fx_wake_lvt_churn" );
			break;
		case "amtank":
			setallvehiclefx( vehicletype, "vehicle/water/fx_wake_lvt_churn" );
			break;	
	// tanks & tracked
		case "t34":
		case "t34_ber1":
		case "ot34":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_tiger_asphalt" );
			setvehiclefx( vehicletype, "concrete", "vehicle/treadfx/fx_treadfx_tiger_concrete" );
			setvehiclefx( vehicletype, "rock", "vehicle/treadfx/fx_treadfx_tiger_concrete" );
			setvehiclefx( vehicletype, "asphalt", "vehicle/treadfx/fx_treadfx_tiger_asphalt" );
			setvehiclefx( vehicletype, "gravel", "vehicle/treadfx/fx_treadfx_tiger_asphalt" );
			setvehiclefx( vehicletype, "dirt", "vehicle/treadfx/fx_treadfx_tiger_dirt" );
			setvehiclefx( vehicletype, "grass", "vehicle/treadfx/fx_treadfx_tiger_grass" );
			setvehiclefx( vehicletype, "mud", "vehicle/treadfx/fx_treadfx_tiger_mud" );	
			break;
		case "t34_wet":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_t34_rain" );
			break;
		case "see2_t34":
		case "see2_ot34":
		case "see2_tiger":
		case "see2_panther":
		case "see2_panzeriv":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_tiger_dirt_lg" );
			setvehiclefx( vehicletype, "concrete", "vehicle/treadfx/fx_treadfx_tiger_concrete_lg" );
			setvehiclefx( vehicletype, "rock", "vehicle/treadfx/fx_treadfx_tiger_concrete_lg" );
			setvehiclefx( vehicletype, "asphalt", "vehicle/treadfx/fx_treadfx_tiger_asphalt_lg" );
			setvehiclefx( vehicletype, "gravel", "vehicle/treadfx/fx_treadfx_tiger_asphalt_lg" );
			setvehiclefx( vehicletype, "dirt", "vehicle/treadfx/fx_treadfx_tiger_dirt_lg" );
			setvehiclefx( vehicletype, "grass", "vehicle/treadfx/fx_treadfx_tiger_grass_lg" );
			setvehiclefx( vehicletype, "mud", "vehicle/treadfx/fx_treadfx_tiger_mud_lg" );		
			break;		
		case "sherman":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_sherman_dirt" );
			setvehiclefx( vehicletype, "concrete", "vehicle/treadfx/fx_treadfx_sherman_concrete" );
			setvehiclefx( vehicletype, "dirt", "vehicle/treadfx/fx_treadfx_sherman_dirt" );
			setvehiclefx( vehicletype, "asphalt", "vehicle/treadfx/fx_treadfx_sherman_asphalt" );
			setvehiclefx( vehicletype, "mud", "vehicle/treadfx/fx_treadfx_sherman_mud" );
			break;	
		case "tiger":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_tiger_dirt" );
			setvehiclefx( vehicletype, "concrete", "vehicle/treadfx/fx_treadfx_tiger_concrete" );
			setvehiclefx( vehicletype, "asphalt", "vehicle/treadfx/fx_treadfx_tiger_asphalt" );
			setvehiclefx( vehicletype, "dirt", "vehicle/treadfx/fx_treadfx_tiger_dirt" );
			setvehiclefx( vehicletype, "grass", "vehicle/treadfx/fx_treadfx_tiger_grass" );
			setvehiclefx( vehicletype, "mud", "vehicle/treadfx/fx_treadfx_tiger_mud" );	
			break;	
		case "panther":
    	setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_sherman_dirt" );
			break;	
		case "type97":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_type97_dirt" );
			setvehiclefx( vehicletype, "concrete", "vehicle/treadfx/fx_treadfx_type97_concrete" );
			setvehiclefx( vehicletype, "dirt", "vehicle/treadfx/fx_treadfx_type97_dirt" );			
			setvehiclefx( vehicletype, "asphalt", "vehicle/treadfx/fx_treadfx_type97_asphalt" );	
			break;	
		case "halftrack":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_dust" );
			break;		
		case "katyusha":
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_dust" );
			break;				
	// misc
		case "triple25":
		case "at74":
		case "pak43":
			level.vehicle_treads[vehicletype] = false;
			setallvehiclefx( vehicletype, undefined );  					
			break;						
		default: //if the vehicle isn't in this list it will use these effects
			setallvehiclefx( vehicletype, "vehicle/treadfx/fx_treadfx_dust" );  
			setvehiclefx( vehicletype, "water" );
			setvehiclefx( vehicletype, "concrete" );
			setvehiclefx( vehicletype, "rock" );
			setvehiclefx( vehicletype, "metal" );
			setvehiclefx( vehicletype, "brick" );
			setvehiclefx( vehicletype, "plaster" );
			setvehiclefx( vehicletype, "asphalt" );
			setvehiclefx( vehicletype, "paintedmetal" );
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