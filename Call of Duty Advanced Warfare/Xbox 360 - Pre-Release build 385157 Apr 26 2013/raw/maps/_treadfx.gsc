#include maps\_utility;
main( classname )
{
	//this sets default tread and tire fx for vehicles - they can be overwritten in level scripts
	if ( !IsDefined( classname ) )
		return;

	println( "^3 (" + classname + ") _treadfx is being deprecated, please do not use this if you are adding a new vehicle, use build_treadfx( classname, fx, surface_type )" );

	switch( classname )
	{
		case "script_vehicle_m1a1_abrams_minigun":
		case "script_vehicle_m1a1_abrams_player_tm":
			setallvehiclefx( classname, "fx/treadfx/tread_dust_hamburg_cheap" );
					  //   classname    material 	   
			setvehiclefx( classname, "water" );
			setvehiclefx( classname, "paintedmetal" );
			setvehiclefx( classname, "riotshield" );
			break;

		case "script_vehicle_uk_utility_truck":
		case "script_vehicle_uk_utility_truck_no_rail":
		case "script_vehicle_uk_utility_truck_no_rail_player":
			setallvehiclefx( classname, "vfx/treadfx/tread_dust_default" );
            setvehiclefx( classname, 	"water" );
			
				  //   classname    material 	    fx 							 
			setvehiclefx( classname, 	"rock", 		undefined );
			setvehiclefx( classname, 	"metal", 		undefined );
			setvehiclefx( classname, 	"brick", 		undefined );
			setvehiclefx( classname, 	"plaster", 		undefined );
			setvehiclefx( classname, 	"asphalt", 		undefined );
			setvehiclefx( classname, 	"paintedmetal", undefined );
			setvehiclefx( classname, 	"riotshield", 	undefined );
			setvehiclefx( classname, 	"snow", 		"fx/treadfx/tread_snow_default" );
			setvehiclefx( classname, 	"slush", 		"fx/treadfx/tread_snow_default" );
			setvehiclefx( classname, 	"ice", 			"fx/treadfx/tread_ice_default" );

		    break;
		    
		//IW5 - uses QUAKED class
        case "script_vehicle_ny_blackhawk":
        case "script_vehicle_ny_harbor_hind":
		case "script_vehicle_mi24p_hind_blackice":
        case "script_vehicle_mi24p_hind_woodland_opened_door":
        case "script_vehicle_apache":
        case "script_vehicle_apache_mg":
        case "script_vehicle_apache_dark":
        case "script_vehicle_cobra_helicopter":
        case "script_vehicle_cobra_helicopter_fly":
        case "script_vehicle_cobra_helicopter_fly_low":
        case "script_vehicle_cobra_helicopter_low":
        case "script_vehicle_cobra_helicopter_player":
        case "script_vehicle_cobra_helicopter_fly_player":
        case "script_vehicle_littlebird_armed":
        case "script_vehicle_littlebird_md500":
        case "script_vehicle_littlebird_bench":
        case "script_vehicle_littlebird_player":
        case "script_vehicle_blackhawk":
        case "script_vehicle_blackhawk_hero_sas_night":
        case "script_vehicle_blackhawk_low":
        case "script_vehicle_blackhawk_low_thermal":
        case "script_vehicle_blackhawk_hero_hamburg":
        case "script_vehicle_blackhawk_minigun_low":
        case "script_vehicle_harrier":
        case "script_vehicle_mi17_woodland":
        case "script_vehicle_mi17_woodland_fly":
        case "script_vehicle_mi17_woodland_fly_cheap":
		case "script_vehicle_mi17_woodland_landing":
		case "script_vehicle_mi17_woodland_landing_so":
        case "script_vehicle_mi17_woodland_noai":
        case "script_vehicle_mi17_woodland_fly_noai":
        case "script_vehicle_mi17_woodland_fly_cheap_noai":
		case "script_vehicle_mi17_woodland_landing_noai":
        case "script_vehicle_ch46e":
        case "script_vehicle_ch46e_notsolid":
        case "script_vehicle_ch46e_low":
        case "script_vehicle_ch46e_ny_harbor":
        case "script_vehicle_mi28_flying":
        case "script_vehicle_osprey":
        case "script_vehicle_osprey_fly":
        case "script_vehicle_mi28_flying_low":
        case "script_vehicle_pavelow":
        case "script_vehicle_pavelow_noai":
        case "script_vehicle_b2":
			setallvehiclefx( classname, "fx/treadfx/heli_dust_default" );
					  //   classname    material    fx 						    
			setvehiclefx( classname, 	"water", 		"fx/treadfx/heli_water" );
			setvehiclefx( classname, 	"snow", 		"fx/treadfx/heli_snow_default" );
			setvehiclefx( classname, 	"slush", 		"fx/treadfx/heli_snow_default" );
			setvehiclefx( classname, 	"ice", 			"fx/treadfx/heli_snow_default" );
			break;
		case "script_vehicle_warrior_physics_turret":
			setallvehiclefx( classname, "vfx/treadfx/tread_dust_default" );
			setvehiclefx( classname, 	"snow", 		"fx/treadfx/tread_snow_default" );
			setvehiclefx( classname, 	"slush", 		"fx/treadfx/tread_snow_default" );
			setvehiclefx( classname, 	"ice", 			"fx/treadfx/tread_ice_default" );
		    break;
		default:	// if the vehicle isn't in this list it will use these effects
			setallvehiclefx( classname, "vfx/treadfx/tread_dust_default" );
					  //   classname    material 	   
			setvehiclefx( classname, 	"water" );
			setvehiclefx( classname, 	"concrete" );
			setvehiclefx( classname, 	"rock" );
			setvehiclefx( classname, 	"metal" );
			setvehiclefx( classname, 	"brick" );
			setvehiclefx( classname, 	"plaster" );
			setvehiclefx( classname, 	"asphalt" );
			setvehiclefx( classname, 	"paintedmetal" );
			setvehiclefx( classname, 	"riotshield" );
					  //   classname    material    fx 							 
			setvehiclefx( classname, 	"snow", 		"fx/treadfx/tread_snow_default" );
			setvehiclefx( classname, 	"slush", 		"fx/treadfx/tread_snow_default" );
			setvehiclefx( classname, 	"ice", 			"fx/treadfx/tread_ice_default" );
			break;
	}
}

setvehiclefx( classname, material, fx )
{
	maps\_vehicle::set_vehicle_effect( classname, material, fx );
}

setallvehiclefx( classname, fx )
{
	types = get_trace_types();

	setvehiclefx( classname, "none" );
	foreach ( type in types )
	{
		setvehiclefx( classname, type, fx );
	}
}


get_trace_types()
{
	types = [];
	types[ types.size ] = "brick";
	types[ types.size ] = "bark";
	types[ types.size ] = "carpet";
	types[ types.size ] = "cloth";
	types[ types.size ] = "concrete";
	types[ types.size ] = "dirt";
	types[ types.size ] = "flesh";
	types[ types.size ] = "foliage";
	types[ types.size ] = "glass";
	types[ types.size ] = "grass";
	types[ types.size ] = "gravel";
	types[ types.size ] = "ice";
	types[ types.size ] = "metal";
	types[ types.size ] = "mud";
	types[ types.size ] = "paper";
	types[ types.size ] = "plaster";
	types[ types.size ] = "rock";
	types[ types.size ] = "sand";
	types[ types.size ] = "snow";
	types[ types.size ] = "water";
	types[ types.size ] = "wood";
	types[ types.size ] = "asphalt";
	types[ types.size ] = "ceramic";
	types[ types.size ] = "plastic";
	types[ types.size ] = "rubber";
	types[ types.size ] = "cushion";
	types[ types.size ] = "fruit";
	types[ types.size ] = "paintedmetal";
	types[ types.size ] = "riotshield";
	types[ types.size ] = "slush";
	types[ types.size ] = "default";

	return types;
}