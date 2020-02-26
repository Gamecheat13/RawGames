#include maps\_vehicle;
#using_animtree ("vehicles");
main()
{
	//self build_drive( %bh_rotors, undefined, 0,3.0 );
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
	for(i = 0; i < 2; i++)
	{
		positions[i] = spawnstruct();
	}

	positions[0].sittag = "tag_driver";			// pilot
	positions[1].sittag = "tag_gunner1";		// copilot

	positions[0].idle = %crew_jeep1_driver_drive_idle;
	positions[1].idle = %crew_jeep1_passenger1_drive_idle;

	positions[0].drive_under_fire = %crew_jeep1_driver_drive_under_fire;
	positions[1].drive_under_fire = %crew_jeep1_passenger1_drive_under_fire;

	positions[0].death_shot = %crew_jeep1_driver_death_shot;
	positions[1].death_shot = %crew_jeep1_passenger1_death_shot;

	positions[0].death_fire = %crew_jeep1_driver_death_fire;
	positions[1].death_fire = %crew_jeep1_passenger1_death_fire;

	positions[0].getout = %crew_jeep1_driver_climbout;
	positions[1].getout = %crew_jeep1_passenger1_climbout;

	positions[0].getin = %crew_jeep1_driver_climbin;
	positions[1].getin = %crew_jeep1_passenger1_climbin;

	positions[0].start = %crew_jeep1_driver_start;
	positions[1].start = %crew_jeep1_passenger1_start;

	positions[0].stop = %crew_jeep1_driver_stop;
	positions[1].stop = %crew_jeep1_passenger1_stop;

	positions[0].turn_left_light = %crew_jeep1_driver_turn_left_light;
	positions[1].turn_left_light = %crew_jeep1_passenger1_turn_left_light;

	positions[0].turn_left_heavy = %crew_jeep1_driver_turn_left_heavy;
	positions[1].turn_left_heavy = %crew_jeep1_passenger1_turn_left_heavy;

	positions[0].turn_right_light = %crew_jeep1_driver_turn_right_light;
	positions[1].turn_right_light = %crew_jeep1_passenger1_turn_right_light;

	positions[0].turn_right_heavy = %crew_jeep1_driver_turn_right_heavy;
	positions[1].turn_right_heavy = %crew_jeep1_passenger1_turn_right_heavy;

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];

	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;


	unload_groups[ "default" ] = unload_groups[ "all" ];

	return unload_groups;
}
