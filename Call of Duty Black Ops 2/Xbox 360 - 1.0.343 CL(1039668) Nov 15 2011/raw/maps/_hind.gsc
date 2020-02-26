#include maps\_vehicle;

#using_animtree ("vehicles");
main()
{
	//self build_drive( %bh_rotors, undefined, 0, 3.0 );
	self.script_badplace = false; //All helicopters dont need to create bad places

	level._effect["rotor_full"] = LoadFX("vehicle/props/fx_hind_main_blade_full");
	level._effect["rotor_small_full"] = LoadFX("vehicle/props/fx_hind_small_blade_full");

	build_aianims( ::setanims , ::set_vehicle_anims );
	build_unload_groups( ::unload_groups );
}

set_vehicle_anims(positions)
{
	return positions;
}


#using_animtree ("generic_human");
setanims()
{
	positions = [];
	for(i = 0; i < 4; i++)
	{
		positions[i] = spawnstruct();
	}

/*	positions[0].sittag = "tag_driver";			// pilot
	positions[1].sittag = "tag_gunner1";		// minigun or launcher
	positions[2].sittag = "tag_gunner2";		// launcher or minigun
	positions[3].sittag = "tag_passenger";		// seated on the left edge back
	positions[4].sittag = "tag_passenger2";		// seated on the left edge front
	positions[5].sittag = "tag_passenger3";		// crouched on the left edge middle
	positions[6].sittag = "tag_passenger4";		// seated on the right edge middle
	positions[7].sittag = "tag_passenger5";		// seated on the right edge front
	positions[8].sittag = "tag_passenger6";		// crouched on the right edge back

	//positions[0].sittag = "tag_driver";
	//positions[1].sittag = "tag_passenger";
	//positions[2].sittag = "tag_passenger2";
	//positions[3].sittag = "tag_passenger3";

	//positions[0].idle = %crew_jeep1_driver_drive_idle;
	//positions[1].idle = %crew_jeep1_passenger1_drive_idle;
	//positions[2].idle = %crew_jeep1_passenger2_drive_idle;
	//positions[3].idle = %crew_jeep1_passenger3_drive_idle;

	positions[0].idle = %ai_huey_pilot1_idle_loop1;
	positions[1].idle = %ai_huey_gunner1;
	positions[2].idle = %ai_huey_gunner2;
	positions[3].idle = %ai_huey_passenger_b_lt;
	positions[4].idle = %ai_huey_passenger_f_lt;
	positions[5].idle = %ai_huey_passenger_m_lt;
	positions[6].idle = %ai_huey_passenger_m_rt;
	positions[7].idle = %ai_huey_passenger_f_rt;
	positions[8].idle = %ai_huey_passenger_b_rt;

	//positions[0].drive_under_fire = %crew_jeep1_driver_drive_under_fire;
	//positions[1].drive_under_fire = %crew_jeep1_passenger1_drive_under_fire;
	//positions[2].drive_under_fire = %crew_jeep1_passenger2_drive_under_fire;
	//positions[3].drive_under_fire = %crew_jeep1_passenger3_drive_under_fire;

	//positions[0].death_shot = %crew_jeep1_driver_death_shot;
	//positions[1].death_shot = %crew_jeep1_passenger1_death_shot;
	//positions[2].death_shot = %crew_jeep1_passenger2_death_shot;
	//positions[3].death_shot = %crew_jeep1_passenger3_death_shot;

	//positions[0].death_fire = %crew_jeep1_driver_death_fire;
	//positions[1].death_fire = %crew_jeep1_passenger1_death_fire;
	//positions[2].death_fire = %crew_jeep1_passenger2_death_fire;
	//positions[3].death_fire = %crew_jeep1_passenger3_death_fire;

	//positions[0].getout = %crew_jeep1_driver_climbout;
	//positions[1].getout = %crew_jeep1_passenger1_climbout;
	//positions[2].getout = %crew_jeep1_passenger2_climbout;
	//positions[3].getout = %crew_jeep1_passenger3_climbout;

	//positions[0].getin = %crew_jeep1_driver_climbin;
	//positions[1].getin = %crew_jeep1_passenger1_climbin;
	//positions[2].getin = %crew_jeep1_passenger2_climbin;
	//positions[3].getin = %crew_jeep1_passenger3_climbin;

	//positions[0].start = %crew_jeep1_driver_start;
	//positions[1].start = %crew_jeep1_passenger1_start;
	//positions[2].start = %crew_jeep1_passenger2_start;
	//positions[3].start = %crew_jeep1_passenger3_start;	

	//positions[0].stop = %crew_jeep1_driver_stop;
	//positions[1].stop = %crew_jeep1_passenger1_stop;
	//positions[2].stop = %crew_jeep1_passenger2_stop;
	//positions[3].stop = %crew_jeep1_passenger3_stop;

	//positions[0].turn_left_light = %crew_jeep1_driver_turn_left_light;
	//positions[1].turn_left_light = %crew_jeep1_passenger1_turn_left_light;
	//positions[2].turn_left_light = %crew_jeep1_passenger2_turn_left_light;
	//positions[3].turn_left_light = %crew_jeep1_passenger3_turn_left_light;

	//positions[0].turn_left_heavy = %crew_jeep1_driver_turn_left_heavy;
	//positions[1].turn_left_heavy = %crew_jeep1_passenger1_turn_left_heavy;
	//positions[2].turn_left_heavy = %crew_jeep1_passenger2_turn_left_heavy;
	//positions[3].turn_left_heavy = %crew_jeep1_passenger3_turn_left_heavy;	

	//positions[0].turn_right_light = %crew_jeep1_driver_turn_right_light;
	//positions[1].turn_right_light = %crew_jeep1_passenger1_turn_right_light;
	//positions[2].turn_right_light = %crew_jeep1_passenger2_turn_right_light;
	//positions[3].turn_right_light = %crew_jeep1_passenger3_turn_right_light;

	//positions[0].turn_right_heavy = %crew_jeep1_driver_turn_right_heavy;
	//positions[1].turn_right_heavy = %crew_jeep1_passenger1_turn_right_heavy;
	//positions[2].turn_right_heavy = %crew_jeep1_passenger2_turn_right_heavy;
	//positions[3].turn_right_heavy = %crew_jeep1_passenger3_turn_right_heavy;		
*/
	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];

	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	
	unload_groups[ "default" ] = unload_groups[ "all" ];

	return unload_groups;
}
