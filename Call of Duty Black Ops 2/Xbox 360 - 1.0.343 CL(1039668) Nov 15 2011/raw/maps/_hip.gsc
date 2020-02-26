#include maps\_vehicle;

#using_animtree ("vehicles");
main()
{
	//self build_drive( %bh_rotors, undefined, 0, 3.0 );
	self.script_badplace = false; //All helicopters dont need to create bad places

	build_aianims( ::setanims , ::set_vehicle_anims );
	//build_unload_groups( ::unload_groups );
}



set_vehicle_anims(positions)
{
	return positions;
}


#using_animtree ("generic_human");
setanims()
{
	positions = [];
	for(i = 0; i < 3; i++)
	{
		positions[i] = spawnstruct();
	}

	positions[0].sittag = "tag_driver";					// pilot
	positions[1].sittag = "tag_passenger";			// copilot
	positions[2].sittag = "tag_gunner1";				// side gunner
	
	positions[0].idle = %ai_mi8_pilot1_idle_loop1;  	// pilot
	positions[1].idle = %ai_mi8_pilot1_idle_loop2;		// copilot
	positions[2].idle = %ai_huey_gunner1;				// side gunner
	
	return positions;
}


unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];

	group = "all";
	//unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	unload_groups[ group ][ unload_groups[ group ].size ] = 6;
	unload_groups[ group ][ unload_groups[ group ].size ] = 7;
	unload_groups[ group ][ unload_groups[ group ].size ] = 8;


	unload_groups[ "default" ] = unload_groups[ "all" ];

	return unload_groups;
}
