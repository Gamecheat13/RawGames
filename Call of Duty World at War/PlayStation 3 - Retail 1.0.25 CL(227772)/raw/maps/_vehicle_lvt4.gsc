#include maps\_vehicle_aianim;
#include maps\_vehicle;
main(model,type)
{
	build_template( "lvt4", model, type );
	build_localinit( ::init_local );
	//build_deathmodel( "vehicle_ltv4_buffalo", "vehicle_ltv4_buffalo_d" );
	build_deathmodel( "vehicle_usa_tracked_lvt4_gunners", "vehicle_usa_tracked_lvt4_gunners" );
	//build_shoot_shock( "tankblast" );
	//build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
	//build_exhaust( "distortion/abrams_exhaust" );
	//build_deckdust( "dust/abrams_desk_dust" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	
	build_treadfx();
	build_life( 9999998, 9999998, 9999999 );
	//build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	build_team( "allies" );
	//build_mainturret();
	build_compassicon();
	build_aianims( ::setanims , ::set_vehicle_anims );
	

	// turret stuff: TODO update with actual turret models and types when we get them
	build_turret( "mg42_bipod_stand", "tag_turret", "weapon_ger_mg_mg42", true );
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
	max_positions = 11;
	
	positions = [];
	for(i = 0 ; i < max_positions ;i++)
		positions[i] = spawnstruct();

//	positions[0].sittag = "tag_MGguy";
//	positions[1].sittag = "tag_guy1";
//	positions[2].sittag = "tag_guy2";
//	positions[3].sittag = "tag_guy3";
//	positions[4].sittag = "tag_guy4";
//	positions[5].sittag = "tag_guy5";
//	positions[6].sittag = "tag_guy6";
//	positions[7].sittag = "tag_guy7";
//	positions[8].sittag = "tag_guy8";
//	positions[9].sittag = "tag_guy9";
//	positions[10].sittag = "tag_guy10";
//		
//	positions[0].idle = %humvee_passenger_idle_R;
//	positions[1].idle = %humvee_passenger_idle_R;
//	positions[2].idle = %humvee_passenger_idle_R;
//	positions[3].idle = %humvee_passenger_idle_R;
//	positions[4].idle = %humvee_passenger_idle_R;
//	positions[5].idle = %humvee_passenger_idle_R;
//	positions[6].idle = %humvee_passenger_idle_R;
//	positions[7].idle = %humvee_passenger_idle_R;
//	positions[8].idle = %humvee_passenger_idle_R;
//	positions[9].idle = %humvee_passenger_idle_R;
//	positions[10].idle = %humvee_passenger_idle_R;
//							
//	positions[0].getout = %humvee_passenger_out_R;
//	positions[1].getout = %humvee_passenger_out_R;
//	positions[2].getout = %humvee_passenger_out_R;
//	positions[3].getout = %humvee_passenger_out_R;
//	positions[4].getout = %humvee_passenger_out_R;
//	positions[5].getout = %humvee_passenger_out_R;
//	positions[6].getout = %humvee_passenger_out_R;
//	positions[7].getout = %humvee_passenger_out_R;
//	positions[8].getout = %humvee_passenger_out_R;
//	positions[9].getout = %humvee_passenger_out_R;
//	positions[10].getout = %humvee_passenger_out_R;
//		
//	positions[0].getin = %humvee_passenger_in_R;
//	positions[1].getin = %humvee_passenger_in_R;
//	positions[2].getin = %humvee_passenger_in_R;
//	positions[3].getin = %humvee_passenger_in_R;
//	positions[4].getin = %humvee_passenger_in_R;
//	positions[5].getin = %humvee_passenger_in_R;
//	positions[6].getin = %humvee_passenger_in_R;
//	positions[7].getin = %humvee_passenger_in_R;
//	positions[8].getin = %humvee_passenger_in_R;
//	positions[9].getin = %humvee_passenger_in_R;
//	positions[10].getin = %humvee_passenger_in_R;
	
	// 0 = first mg turret to man, 1 would be second, and so on.
	//positions[0].mgturret = 0;
		
	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups["passengers"] = [];
	unload_groups["all"] = [];

	group = "passengers";
	unload_groups[group][unload_groups[group].size] = 1;
	unload_groups[group][unload_groups[group].size] = 2;
	unload_groups[group][unload_groups[group].size] = 3;
	unload_groups[group][unload_groups[group].size] = 4;
	unload_groups[group][unload_groups[group].size] = 5;
	unload_groups[group][unload_groups[group].size] = 6;
	unload_groups[group][unload_groups[group].size] = 7;
	unload_groups[group][unload_groups[group].size] = 8;
	unload_groups[group][unload_groups[group].size] = 9;
	unload_groups[group][unload_groups[group].size] = 10;
	
	group = "all";
	unload_groups[group][unload_groups[group].size] = 0;	
	unload_groups[group][unload_groups[group].size] = 1;
	unload_groups[group][unload_groups[group].size] = 2;
	unload_groups[group][unload_groups[group].size] = 3;
	unload_groups[group][unload_groups[group].size] = 4;
	unload_groups[group][unload_groups[group].size] = 5;
	unload_groups[group][unload_groups[group].size] = 6;
	unload_groups[group][unload_groups[group].size] = 7;
	unload_groups[group][unload_groups[group].size] = 8;
	unload_groups[group][unload_groups[group].size] = 9;
	unload_groups[group][unload_groups[group].size] = 10;
	
	unload_groups["default"] = unload_groups["passengers"];
	
	return unload_groups;
}