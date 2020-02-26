#include maps\_vehicle;

#using_animtree ("vehicles");
main()
{
	//self build_drive( %bh_rotors, undefined, 0, 3.0 );
	self.script_badplace = false; //All helicopters dont need to create bad places

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
	for(i = 0; i < 9; i++)
	{
		positions[i] = spawnstruct();
	}

	//positions[0].sittag = "tag_driver";			// pilot
	//positions[1].sittag = "tag_gunner1";		// minigun or launcher
	//positions[2].sittag = "tag_gunner2";		// launcher or minigun
	//positions[3].sittag = "tag_passenger";		// seated on the left edge back
	//positions[4].sittag = "tag_passenger2";		// seated on the left edge front
	//positions[5].sittag = "tag_passenger3";		// crouched on the left edge middle
	//positions[6].sittag = "tag_passenger4";		// seated on the right edge middle
	//positions[7].sittag = "tag_passenger5";		// seated on the right edge front
	//positions[8].sittag = "tag_passenger6";		// crouched on the right edge back

	//positions[0].idle = %ai_huey_pilot1_idle_loop1;
	//positions[1].idle = %ai_huey_gunner1;
	//positions[2].idle = %ai_huey_gunner2;
	//positions[3].idle = %ai_huey_passenger_b_lt;
	//positions[4].idle = %ai_huey_passenger_f_lt;
	//positions[5].idle = %ai_huey_passenger_m_lt;
	//positions[6].idle = %ai_huey_passenger_m_rt;
	//positions[7].idle = %ai_huey_passenger_f_rt;
	//positions[8].idle = %ai_huey_passenger_b_rt;

	////positions[0].getout = %crew_jeep1_driver_climbout;
	//positions[1].getout = %ai_huey_gunner1_exit;
	//positions[2].getout = %ai_huey_gunner2_exit;
	//positions[3].getout = %ai_huey_passenger_b_lt_exit;
	//positions[4].getout = %ai_huey_passenger_f_lt_exit;
	//positions[5].getout = %ai_huey_passenger_m_lt_exit;
	//positions[6].getout = %ai_huey_passenger_m_rt_exit;
	//positions[7].getout = %ai_huey_passenger_f_rt_exit;
	//positions[8].getout = %ai_huey_passenger_b_rt_exit;

	////positions[0].getin = %crew_jeep1_driver_climbin;
	//positions[1].getin = %ai_huey_gunner1_enter;
	//positions[2].getin = %ai_huey_gunner2_enter;
	//positions[3].getin = %ai_huey_passenger_b_lt_enter;
	//positions[4].getin = %ai_huey_passenger_f_lt_enter;
	//positions[5].getin = %ai_huey_passenger_m_lt_enter;
	//positions[6].getin = %ai_huey_passenger_m_rt_enter;
	//positions[7].getin = %ai_huey_passenger_f_rt_enter;
	//positions[8].getin = %ai_huey_passenger_b_rt_enter;

	//// these positions will need to wait for the player to enter before getting on themselves
	//positions[1].waiting = %ai_huey_passenger_waiting;
	//positions[2].waiting = %ai_huey_passenger_waiting;
	//positions[3].waiting = %ai_huey_passenger_waiting;
	//positions[4].waiting = %ai_huey_passenger_waiting;
	//positions[5].waiting = %ai_huey_passenger_waiting;
	//positions[6].waiting = %ai_huey_passenger_waiting;
	//positions[7].waiting = %ai_huey_passenger_waiting;
	//positions[8].waiting = %ai_huey_passenger_waiting;

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];

	//group = "all";
	////unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	//unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	//unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	//unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	//unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	//unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	//unload_groups[ group ][ unload_groups[ group ].size ] = 6;
	//unload_groups[ group ][ unload_groups[ group ].size ] = 7;
	//unload_groups[ group ][ unload_groups[ group ].size ] = 8;


	//unload_groups[ "default" ] = unload_groups[ "all" ];

	return unload_groups;
}