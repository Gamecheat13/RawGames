setup_types( model, type )
{
	level.vehicle_types = [];
	
	// vehicletype , model
	// assigns vehicletypes to models in the game so we don't have to put vehicletype on everything in radiant
		
	set_type( "80s_wagon1", "vehicle_80s_wagon1_brn_destructible");
	
	set_type( "apache", "vehicle_apache");
	set_type( "apache", "vehicle_apache_dark");
	
	set_type( "blackhawk", "vehicle_blackhawk");
	set_type( "blackhawk", "vehicle_blackhawk");
	
	set_type( "bm21", "vehicle_bm21_mobile_dstry");

	set_type( "bm21_troops", "vehicle_bm21_mobile");
	set_type( "bm21_troops", "vehicle_bm21_mobile_cover_no_bench");

	set_type( "bmp", "vehicle_bmp");
	set_type( "bmp", "vehicle_bmp_thermal");

	set_type( "bradley", "vehicle_bradley");

	set_type( "camera", "vehicle_camera");
	
	set_type( "cobra", "vehicle_cobra_helicopter");
	set_type( "cobra", "vehicle_cobra_helicopter_fly");

	set_type( "80s_hatch1", "vehicle_80s_hatch1_brn_destructible");
	set_type( "80s_hatch1", "vehicle_80s_hatch1_green_destructible");
	set_type( "80s_hatch1", "vehicle_80s_hatch1_red_destructible");
	set_type( "80s_hatch1", "vehicle_80s_hatch1_silv_destructible");
	set_type( "80s_hatch1", "vehicle_80s_hatch1_tan_destructible");
	set_type( "80s_hatch1", "vehicle_80s_hatch1_yel_destructible");

	set_type( "80s_sedan1", "vehicle_80s_sedan1_brn_destructible");
	set_type( "80s_sedan1", "vehicle_80s_sedan1_green_destructible");
	set_type( "80s_sedan1", "vehicle_80s_sedan1_red_destructible");
	set_type( "80s_sedan1", "vehicle_80s_sedan1_silv_destructible");
	set_type( "80s_sedan1", "vehicle_80s_sedan1_tan_destructible");
	set_type( "80s_sedan1", "vehicle_80s_sedan1_yel_destructible");
	      
	set_type( "hind", "vehicle_mi24p_hind_desert");
	set_type( "hind", "vehicle_mi24p_hind_woodland");
	set_type( "hind", "vehicle_mi24p_hind_woodland_opened_door");
        
	set_type( "humvee", "vehicle_humvee_camo");
	set_type( "humvee", "vehicle_humvee_camo_50cal_doors");
	set_type( "humvee", "vehicle_humvee_camo_50cal_nodoors");
	
	set_type( "luxurysedan", "vehicle_luxurysedan");
	set_type( "luxurysedan", "vehicle_luxurysedan_test");
	
	set_type( "m1a1", "vehicle_m1a1_abrams");

	set_type( "mi17", "vehicle_mi17_woodland");
	set_type( "mi17", "vehicle_mi17_woodland_fly");
	set_type( "mi17", "vehicle_mi17_woodland_fly_cheap");
	
	set_type( "mig29", "vehicle_mig29_desert");
	
	set_type( "sa6", "vehicle_sa6_no_missiles_desert");
	set_type( "sa6", "vehicle_sa6_no_missiles_woodland");

	set_type( "seaknight", "vehicle_ch46e");
	
	set_type( "slamraam", "vehicle_camera");
	
	set_type( "t72", "vehicle_camera");
	
	set_type( "technical", "vehicle_camera");
	
	set_type( "truck", "vehicle_pickup_roobars");
	set_type( "truck", "vehicle_pickup_4door");
	set_type( "truck", "vehicle_opfor_truck");
	set_type( "truck", "vehicle_pickup_technical");
	
	set_type( "uaz", "vehicle_uaz_fabric");
	set_type( "uaz", "vehicle_uaz_hardtop");
	set_type( "uaz", "vehicle_uaz_open");
	set_type( "uaz", "vehicle_uaz_open_for_ride" );
	
	set_type( "mi28", "vehicle_mi-28_flying" );
	
/*




80s_hatch1
80s_wagon1
apache
blackhawk
blackhawk_mp
bm21
bm21_troops
bmp
bog_mortar
bradley
camera
cobra
cobra_mp
cobra_player
defaultvehicle
defaultvehicle_mp
flare
hind
humvee
humvee50cal
humvee50cal_mp
hvy_truck
luxurysedan
m1a1
mi17
mi17_noai
mig29
pickup
sa6
seaknight
slamraam
t72
technical
truck
uaz

	*/
	
	
}

set_type( type, model )
{
	level.vehicle_types[ model ] = type;
	
}

get_type( model )
{
	if(!isdefined(level.vehicle_types[ model ]))
	{
		println("type doesn't exist for model, "+ model);
		println("make set it in vehicletypes::setup_types(); doesn't exist for model, "+ model);
		assertmsg("vehicle type for model doesn't exits, see console for info");
	}
	return level.vehicle_types[ model ];
	
}

is_type( model )
{
	if(isdefined(level.vehicle_types[ model ]))
		return true;
	else
		return false;
}