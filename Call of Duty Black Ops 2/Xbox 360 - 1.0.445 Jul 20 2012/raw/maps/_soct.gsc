#include maps\_vehicle;

init()
{
	vehicle_add_main_callback( "boat_soct_player", ::main );
	vehicle_add_main_callback( "boat_soct_axis", ::main );	
	vehicle_add_main_callback( "boat_soct_allies", ::main );	
}

main()
{
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_unload_groups( ::unload_groups );
}

#using_animtree ("vehicles");
set_vehicle_anims(positions)
{
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_gunner1";	 
	
	positions[ 0 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getoutanim_clear = false;

	positions[ 0 ].vehicle_getinanim = undefined;
	positions[ 1 ].vehicle_getinanim = undefined;

	positions[ 0 ].vehicle_getoutanim = undefined;
	positions[ 1 ].vehicle_getoutanim = undefined;
	
	return positions;
}

#using_animtree ("generic_human");
setanims ()
{
	positions = [];
	for(i = 0; i < 2; i++)
	{
		positions[i] = spawnstruct();
	}

	positions[1].sittag = "tag_gunner1";	
	positions[1].vehiclegunner = 1;
	positions[1].idle = %ai_crew_soct_gunner_aim;
	positions[1].aimup = %ai_crew_soct_gunner_aim_up;
	positions[1].aimdown = %ai_crew_soct_gunner_aim_down;
	positions[1].death = %ai_crew_m113_gunner_death;
	positions[1].getout = %ch_pakistan_6_11_dismount_soct_gunner;
	
	positions[0].sittag = "tag_driver";	
	positions[0].idle = %ai_crew_soct_driver_idle;
	positions[0].getout = %ch_pakistan_6_11_dismount_soct_driver;

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