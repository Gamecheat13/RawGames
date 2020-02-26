#include maps\_vehicle;

#using_animtree ("vehicles");

init()
{
	vehicle_add_main_callback( "apc_gaz_tigr", ::main );
	vehicle_add_main_callback( "apc_gaz_tigr_wturret", ::main );	
}

main()
{
	if( IsSubStr( self.vehicletype, "wturret" ) )
	{
		build_aianims( ::set_50cal_gunner_anims , ::set_vehicle_anims );
		self HidePart( "tag_hide_turret" );
	}	
	else
	{
		build_aianims( ::setanims , ::set_vehicle_anims );
	}
	
	build_unload_groups( ::unload_groups );
}

#using_animtree ("vehicles");
set_vehicle_anims( positions )
{   
	positions[0].sittag = "tag_driver";			// driver
	positions[1].sittag = "tag_passenger";		// shotgun
	positions[2].sittag = "tag_guy0";			// guy0
	positions[3].sittag = "tag_guy1";			// guy1
	
	positions[ 0 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	positions[ 2 ].vehicle_getoutanim_clear = false;
	positions[ 3 ].vehicle_getoutanim_clear = false;
	
	positions[ 0 ].vehicle_getinanim = %v_gaz_tigr_driver_door_enter;
	positions[ 1 ].vehicle_getinanim = %v_gaz_tigr_passenger_door_enter;
	positions[ 2 ].vehicle_getinanim = %v_gaz_tigr_rear_door_enter;
		
	positions[ 0 ].vehicle_getoutanim = %v_gaz_tigr_driver_door_exit;
	positions[ 1 ].vehicle_getoutanim = %v_gaz_tigr_passenger_door_exit;
	positions[ 2 ].vehicle_getoutanim = %v_gaz_tigr_rear_door_exit;
		
	return positions;               
}

#using_animtree( "generic_human" );
set_50cal_gunner_anims()
{
	positions = [];
	for(i = 0; i < 5; i++)
	{
		positions[i] = spawnstruct();
	}

	positions[0].sittag = "tag_driver";			// driver
	positions[1].sittag = "tag_passenger";		// shotgun
	positions[2].sittag = "tag_guy0";			// guy0
	positions[3].sittag = "tag_guy1";			// guy1
	positions[4].sittag = "tag_gunner1";		// gunner

	positions[0].idle = %ai_gaz_tigr_driver_idle;	
	positions[1].idle = %ai_gaz_tigr_passenger_idle;	
	positions[2].idle = %ai_gaz_tigr_guy0_idle; 		
	positions[3].idle = %ai_gaz_tigr_guy1_idle;	
	positions[4].idle = %ai_m113_gunner_aim;	

	positions[0].getin = %ai_gaz_tigr_driver_enter;
	positions[1].getin = %ai_gaz_tigr_passenger_enter;
	positions[2].getin = %ai_gaz_tigr_guy0_enter_back;
	positions[3].getin = %ai_gaz_tigr_guy1_enter_back;
	
	positions[0].getout = %ai_gaz_tigr_driver_exit;
	positions[1].getout = %ai_gaz_tigr_passenger_exit;
	positions[2].getout = %ai_gaz_tigr_guy0_exit_back;
	positions[3].getout = %ai_gaz_tigr_guy1_exit_back;
	
	positions[0].explosion_death = %death_explosion_forward13;
	positions[1].explosion_death = %death_explosion_left11;
	positions[2].explosion_death = %death_explosion_left11;
	positions[3].explosion_death = %death_explosion_back13;
	positions[4].explosion_death = %ai_crew_m113_gunner_death;
		
	positions[4].vehiclegunner = 1;
	positions[4].death = %ai_crew_m113_gunner_death;
	positions[4].aimup = %ai_m113_gunner_aim_up;
	positions[4].aimdown = %ai_m113_gunner_aim_down;
	positions[4].fire = %ai_m113_gunner_fire;
	positions[4].fireup = %ai_m113_gunner_fire_up;
	positions[4].firedown = %ai_m113_gunner_fire_down;
	
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

	positions[0].sittag = "tag_driver";			// driver
	positions[1].sittag = "tag_passenger";		// shotgun
	positions[2].sittag = "tag_guy0";			// guy0
	positions[3].sittag = "tag_guy1";			// guy1

	positions[0].idle = %ai_gaz_tigr_driver_idle;	
	positions[1].idle = %ai_gaz_tigr_passenger_idle;	
	positions[2].idle = %ai_gaz_tigr_guy0_idle; 		
	positions[3].idle = %ai_gaz_tigr_guy1_idle;		

	positions[0].getin = %ai_gaz_tigr_driver_enter;
	positions[1].getin = %ai_gaz_tigr_passenger_enter;
	positions[2].getin = %ai_gaz_tigr_guy0_enter_back;
	positions[3].getin = %ai_gaz_tigr_guy1_enter_back;
	
	positions[0].getout = %ai_gaz_tigr_driver_exit;
	positions[1].getout = %ai_gaz_tigr_passenger_exit;
	positions[2].getout = %ai_gaz_tigr_guy0_exit_back;
	positions[3].getout = %ai_gaz_tigr_guy1_exit_back;
	
	positions[ 0 ].explosion_death = %generic_human::death_explosion_forward13;
	positions[ 1 ].explosion_death = %generic_human::death_explosion_left11;
	positions[ 2 ].explosion_death = %generic_human::death_explosion_left11;
	positions[ 3 ].explosion_death = %generic_human::death_explosion_back13;
	
	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];
	unload_groups[ "driver" ] = [];
	unload_groups[ "passengers" ] = [];
	unload_groups[ "rear_passengers" ] = [];
	
	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	
	group = "driver";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	
	group = "passengers";		
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;

	group = "rear_passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;	

	unload_groups[ "default" ] = unload_groups[ "all" ];
	
	return unload_groups;
}
