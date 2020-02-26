
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
	positions[ 1 ].vehicle_getoutanim = %v_crew_pavelow_doors_open;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getinanim = %v_crew_pavelow_doors_close;
	positions[ 1 ].vehicle_getinanim_clear = false;

	positions[ 1 ].vehicle_getoutsound = "pavelow_door_open";
	positions[ 1 ].vehicle_getinsound = "pavelow_door_close";

	positions[ 1 ].delay = getanimlength( %v_crew_pavelow_doors_open ) - 1.7;
	positions[ 2 ].delay = getanimlength( %v_crew_pavelow_doors_open ) - 1.7;
	positions[ 3 ].delay = getanimlength( %v_crew_pavelow_doors_open ) - 1.7;
	positions[ 4 ].delay = getanimlength( %v_crew_pavelow_doors_open ) - 1.7;
	
	return positions;
}


#using_animtree ("generic_human");
setanims()
{
	positions = [];
	for(i = 0; i < 6; i++)
	{
		positions[i] = spawnstruct();
	}

	positions[ 0 ].idle[ 0 ] = %ai_crew_pavelow_pilot_idle;
	positions[ 0 ].idle[ 1 ] = %ai_crew_pavelow_pilot_switches;
	positions[ 0 ].idle[ 2 ] = %ai_crew_pavelow_pilot_switches;
	positions[ 0 ].idleoccurrence[ 0 ] = 1000;
	positions[ 0 ].idleoccurrence[ 1 ] = 400;
	positions[ 0 ].idleoccurrence[ 2 ] = 200;

	positions[ 0 ].bHasGunWhileRiding = false;
	positions[ 5 ].bHasGunWhileRiding = false;

	positions[ 1 ].idle = %ai_crew_pavelow_unload_1_idle;
	positions[ 2 ].idle = %ai_crew_pavelow_unload_2_idle;
	positions[ 3 ].idle = %ai_crew_pavelow_unload_3_idle;
	positions[ 4 ].idle = %ai_crew_pavelow_unload_4_idle;

	positions[ 5 ].idle[ 0 ] = %ai_crew_pavelow_copilot_idle;
	positions[ 5 ].idle[ 1 ] = %ai_crew_pavelow_copilot_switches;
	positions[ 5 ].idle[ 2 ] = %ai_crew_pavelow_copilot_twitch;

	positions[ 5 ].idleoccurrence[ 0 ] = 1000;
	positions[ 5 ].idleoccurrence[ 1 ] = 400;
	positions[ 5 ].idleoccurrence[ 2 ] = 200;

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_guy1";
	positions[ 2 ].sittag = "tag_guy2";
	positions[ 3 ].sittag = "tag_guy3";
	positions[ 4 ].sittag = "tag_guy4";
	positions[ 5 ].sittag = "tag_passenger";

//	positions[ 1 ].getoutstance = "crouch";
//	positions[ 2 ].getoutstance = "crouch";
//	positions[ 3 ].getoutstance = "crouch";
//	positions[ 4 ].getoutstance = "crouch";

	positions[ 1 ].getout = %ai_crew_pavelow_unload_1;
	positions[ 2 ].getout = %ai_crew_pavelow_unload_2;
	positions[ 3 ].getout = %ai_crew_pavelow_unload_3;
	positions[ 4 ].getout = %ai_crew_pavelow_unload_4;

	positions[ 1 ].getin = %ai_crew_pavelow_load_1;
	positions[ 2 ].getin = %ai_crew_pavelow_load_2;
	positions[ 3 ].getin = %ai_crew_pavelow_load_3;
	positions[ 4 ].getin = %ai_crew_pavelow_load_4;

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "passengers" ] = [];

	group = "passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	
	unload_groups[ "default" ] = unload_groups[ group ];

	return unload_groups;
}
