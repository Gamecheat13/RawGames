#include maps\_vehicle_aianim;
#include maps\_vehicle;
main(model,type)
{
	build_template( "buffalo", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_usa_tracked_lvta4_amtank", "vehicle_usa_tracked_lvta4_amtank_d" );
	build_deathmodel( "vehicle_usa_tracked_lvta4_amtank_8k", "vehicle_usa_tracked_lvta4_amtank_d_8k" );
	build_deathmodel( "vehicle_usa_tracked_lvta2", "vehicle_usa_tracked_lvta2_d" );	
	build_deathmodel( "vehicle_usa_tracked_lvt4", "vehicle_usa_tracked_lvt4_dest" );
	build_deathmodel( "vehicle_usa_tracked_lvt4_8k", "vehicle_usa_tracked_lvt4_dest" );
	build_deathmodel( "vehicle_usa_tracked_gunners", "vehicle_usa_tracked_gunners" );
	
	//build_shoot_shock( "tankblast" );
	//build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
	//build_deckdust( "dust/abrams_desk_dust" );

// MikeD (12/20/2007): Commented this out, as build_predeathfx is no longer supported
//	build_predeathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );

	build_deathfx( "vehicle/vexplosion/fx_Vexplode_lvt_beach", undefined, "explo_metal_rand" );

	build_treadfx(type);
	build_exhaust( "vehicle/exhaust/fx_exhaust_lvt" );
	build_life( 9999998, 9999998, 9999999 );
	//build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	build_team( "allies" );
	//build_mainturret();
	build_aianims( ::setanims , ::set_vehicle_anims );
	
	// turret stuff: TODO update with actual turret models and types when we get them
	//build_turret( "30cal_bipod_stand", "barrel_animate1", "weapon_usa_30cal_mg", true );
	//build_turret( "30cal_bipod_stand", "barrel_animate2", "weapon_usa_30cal_mg", true );	

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
	max_positions = 8;
	
	positions = [];
	for(i = 0 ; i < max_positions ;i++)
		positions[i] = spawnstruct();

	positions[0].sittag = "tag_passenger2";
	positions[1].sittag = "tag_passenger3";
	positions[2].sittag = "tag_passenger4";
	positions[3].sittag = "tag_passenger5";
	positions[4].sittag = "tag_passenger6";
	positions[5].sittag = "tag_passenger7";
	positions[6].sittag = "tag_passenger8";
	positions[7].sittag = "tag_passenger9";
		
	positions[0].idle = %crew_lvt4_passenger2_idle; 
	positions[1].idle = %crew_lvt4_passenger3_idle; 
	positions[2].idle = %crew_lvt4_passenger4_idle; 
	positions[3].idle = %crew_lvt4_passenger5_idle; 
	positions[4].idle = %crew_lvt4_passenger6_idle; 
	positions[5].idle = %crew_lvt4_passenger7_idle; 
	positions[6].idle = %crew_lvt4_passenger8_idle; 
	positions[7].idle = %crew_lvt4_passenger9_idle; 

	positions[0].getout = %crew_lvt4_passenger2_exit_normal; 
	positions[1].getout = %crew_lvt4_passenger3_exit_normal; 
	positions[2].getout = %crew_lvt4_passenger4_exit_normal; 
	positions[3].getout = %crew_lvt4_passenger5_exit_normal; 
	positions[4].getout = %crew_lvt4_passenger6_exit_normal; 
	positions[5].getout = %crew_lvt4_passenger7_exit_normal; 
	positions[6].getout = %crew_lvt4_passenger8_exit_normal; 
	positions[7].getout = %crew_lvt4_passenger9_exit_normal; 
		
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
	unload_groups[group][unload_groups[group].size] = 0;	
	unload_groups[group][unload_groups[group].size] = 1;
	unload_groups[group][unload_groups[group].size] = 2;
	unload_groups[group][unload_groups[group].size] = 3;
	unload_groups[group][unload_groups[group].size] = 4;
	unload_groups[group][unload_groups[group].size] = 5;
	unload_groups[group][unload_groups[group].size] = 6;
	unload_groups[group][unload_groups[group].size] = 7;
	
	
	group = "all";
	unload_groups[group][unload_groups[group].size] = 0;	
	unload_groups[group][unload_groups[group].size] = 1;
	unload_groups[group][unload_groups[group].size] = 2;
	unload_groups[group][unload_groups[group].size] = 3;
	unload_groups[group][unload_groups[group].size] = 4;
	unload_groups[group][unload_groups[group].size] = 5;
	unload_groups[group][unload_groups[group].size] = 6;
	unload_groups[group][unload_groups[group].size] = 7;


	
	unload_groups["default"] = unload_groups["passengers"];
	
	return unload_groups;
}