#include maps\_utility;
main( classname )
{
	//this sets default tread and tire fx for vehicles - they can be overwritten in level scripts
	if ( !isdefined( classname ) )
		return;
	level.vehicle_treads[ classname ] = true;
	switch( classname )
	{
		case "script_vehicle_m1a1_abrams_minigun":
		case "script_vehicle_m1a1_abrams_player_tm":
			setallvehiclefx( classname, "treadfx/tread_dust_hamburg_cheap" );
			setvehiclefx( classname, "water" );
//			setvehiclefx( classname, "mud", "treadfx/tread_mud_m1a1" );
			setvehiclefx( classname, "paintedmetal" );
			setvehiclefx( classname, "riotshield" );
			break;

		case "script_vehicle_uk_utility_truck":
		case "script_vehicle_uk_utility_truck_no_rail":
		case "script_vehicle_uk_utility_truck_no_rail_player":
			setallvehiclefx( classname, "treadfx/tread_dust_default" );
            setvehiclefx( classname, "water" );
            // concrete enabling dust treads for tunnel in london - because that material looks like dust - feel free to remove if sucks. - Nate
			//setvehiclefx( classname, "concrete" );
			setvehiclefx( classname, "rock" );
			setvehiclefx( classname, "metal" );
			setvehiclefx( classname, "brick" );
			setvehiclefx( classname, "plaster" );
			setvehiclefx( classname, "asphalt" );
			setvehiclefx( classname, "paintedmetal" );
			setvehiclefx( classname, "riotshield" );
			setvehiclefx( classname, "snow", "treadfx/tread_snow_default" );
			setvehiclefx( classname, "slush", "treadfx/tread_snow_default" );
			setvehiclefx( classname, "ice", "treadfx/tread_ice_default" );

		    break;
		//IW4
		case "apache":
		case "cobra":
		case "cobra_player":
		case "littlebird":
		case "littlebird_player":
		case "blackhawk":
		case "blackhawk_minigun":
		case "blackhawk_minigun_so":
		case "hind":
		case "ny_harbor_hind":
		case "harrier":
		case "mi17":
		case "mi17_noai":
		case "seaknight":
		case "mi28":
		case "pavelow":
		case "mig29":
		case "b2":
		    
		//IW5 - uses QUAKED class
        case "script_vehicle_ny_blackhawk":
        case "script_vehicle_ny_harbor_hind":
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
			setallvehiclefx( classname, "treadfx/heli_dust_default" );
			setvehiclefx( classname, "water", "treadfx/heli_water" );
			setvehiclefx( classname, "snow", "treadfx/heli_snow_default" );
			setvehiclefx( classname, "slush", "treadfx/heli_snow_default" );
			setvehiclefx( classname, "ice", "treadfx/heli_snow_default" );
			break;
		default:// if the vehicle isn't in this list it will use these effects
			setallvehiclefx( classname, "treadfx/tread_dust_default" );
			setvehiclefx( classname, "water" );
			setvehiclefx( classname, "concrete" );
			setvehiclefx( classname, "rock" );
			setvehiclefx( classname, "metal" );
			setvehiclefx( classname, "brick" );
			setvehiclefx( classname, "plaster" );
			setvehiclefx( classname, "asphalt" );
			setvehiclefx( classname, "paintedmetal" );
			setvehiclefx( classname, "riotshield" );
			setvehiclefx( classname, "snow", "treadfx/tread_snow_default" );
			setvehiclefx( classname, "slush", "treadfx/tread_snow_default" );
			setvehiclefx( classname, "ice", "treadfx/tread_ice_default" );
			break;
	}
}

setvehiclefx( classname, material, fx )
{
	if ( !isdefined( level._vehicle_effect ) )
		level._vehicle_effect = [];
	if ( !isdefined( fx ) )
		level._vehicle_effect[ classname ][ material ] = -1;
	else
		level._vehicle_effect[ classname ][ material ] = loadfx( fx );
}

setallvehiclefx( classname, fx )
{
	setvehiclefx( classname, "brick", fx );
 	setvehiclefx( classname, "bark", fx );
 	setvehiclefx( classname, "carpet", fx );
 	setvehiclefx( classname, "cloth", fx );
 	setvehiclefx( classname, "concrete", fx );
 	setvehiclefx( classname, "dirt", fx );
 	setvehiclefx( classname, "flesh", fx );
 	setvehiclefx( classname, "foliage", fx );
 	setvehiclefx( classname, "glass", fx );
 	setvehiclefx( classname, "grass", fx );
 	setvehiclefx( classname, "gravel", fx );
 	setvehiclefx( classname, "ice", fx );
 	setvehiclefx( classname, "metal", fx );
 	setvehiclefx( classname, "mud", fx );
 	setvehiclefx( classname, "paper", fx );
 	setvehiclefx( classname, "plaster", fx );
 	setvehiclefx( classname, "rock", fx );
 	setvehiclefx( classname, "sand", fx );
 	setvehiclefx( classname, "snow", fx );
 	setvehiclefx( classname, "water", fx );
 	setvehiclefx( classname, "wood", fx );
 	setvehiclefx( classname, "asphalt", fx );
 	setvehiclefx( classname, "ceramic", fx );
 	setvehiclefx( classname, "plastic", fx );
 	setvehiclefx( classname, "rubber", fx );
 	setvehiclefx( classname, "cushion", fx );
 	setvehiclefx( classname, "fruit", fx );
 	setvehiclefx( classname, "paintedmetal", fx );
 	setvehiclefx( classname, "riotshield", fx );
 	setvehiclefx( classname, "slush", fx );
 	setvehiclefx( classname, "default", fx );
	setvehiclefx( classname, "none" );
}