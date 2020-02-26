#include maps\_vehicle;

#using_animtree ("vehicles");
main()
{
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_unload_groups( ::unload_groups );
}

precache_submodels()
{
	
}

#using_animtree ("vehicles");
set_vehicle_anims( positions )
{          
	positions[0].sittag = "tag_driver";			// driver
	positions[1].sittag = "tag_passenger";		// shotgun
	positions[2].sittag = "tag_passenger2";		// guy2 - left side
	positions[3].sittag = "tag_passenger3";		// guy3 - right side
	positions[4].sittag = "tag_passenger4";		// guy4 - left back
	positions[5].sittag = "tag_passenger5";		// guy5 - right back
	
	positions[ 0 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	positions[ 2 ].vehicle_getoutanim_clear = false;
	positions[ 3 ].vehicle_getoutanim_clear = false;
	positions[ 4 ].vehicle_getoutanim_clear = false;
	positions[ 5 ].vehicle_getoutanim_clear = false;

	positions[ 0 ].vehicle_getinanim = %v_crew_van_left_frontdoor_open;
	positions[ 1 ].vehicle_getinanim = %v_crew_van_right_frontdoor_open;
	positions[ 2 ].vehicle_getinanim = %v_crew_van_left_slidingdoor_open;
	positions[ 3 ].vehicle_getinanim = %v_crew_van_right_slidingdoor_open;
	positions[ 4 ].vehicle_getinanim = %v_crew_van_right_backdoor_open;
	positions[ 5 ].vehicle_getinanim = %v_crew_van_left_backdoor_open;

	positions[ 0 ].vehicle_getoutanim = %v_crew_van_left_frontdoor_open;
	positions[ 1 ].vehicle_getoutanim = %v_crew_van_right_frontdoor_open;
	positions[ 2 ].vehicle_getoutanim = %v_crew_van_left_slidingdoor_open;
	positions[ 3 ].vehicle_getoutanim = %v_crew_van_right_slidingdoor_open;
	positions[ 4 ].vehicle_getoutanim = %v_crew_van_right_backdoor_open;
	positions[ 5 ].vehicle_getoutanim = %v_crew_van_left_backdoor_open;
	
	positions[ 0 ].explosion_death = %generic_human::death_explosion_forward13;
	positions[ 1 ].explosion_death = %generic_human::death_explosion_left11;
	positions[ 2 ].explosion_death = %generic_human::death_explosion_left11;
	positions[ 3 ].explosion_death = %generic_human::death_explosion_back13;
	positions[ 4 ].explosion_death = %generic_human::death_explosion_forward13;
	positions[ 5 ].explosion_death = %generic_human::death_explosion_right13;

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

	positions[0].sittag = "tag_driver";			// driver
	positions[1].sittag = "tag_passenger";		// shotgun
	positions[2].sittag = "tag_passenger2";		// guy2 - left side
	positions[3].sittag = "tag_passenger3";		// guy3 - right side
	positions[4].sittag = "tag_passenger4";		// guy4 - left back
	positions[5].sittag = "tag_passenger5";		// guy5 - right back

	positions[0].idle = %ai_crew_van_driver_left_front_idle;	
	positions[1].idle = %ai_crew_van_shotgun_right_front_idle;	
	positions[2].idle = %ai_crew_van_guy2_left_side_idle; 		
	positions[3].idle = %ai_crew_van_guy3_right_side_idle;		
	positions[4].idle = %ai_crew_van_guy4_right_back_idle;		
	positions[5].idle = %ai_crew_van_guy5_left_back_idle;		

	positions[0].getout = %ai_crew_van_driver_left_front_exit;
	positions[1].getout = %ai_crew_van_shotgun_right_front_exit;
	positions[2].getout = %ai_crew_van_guy2_left_side_exit;
	positions[3].getout = %ai_crew_van_guy3_right_side_exit;
	positions[4].getout = %ai_crew_van_guy4_right_back_exit;
	positions[5].getout = %ai_crew_van_guy5_left_back_exit;

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];
	unload_groups[ "driver" ] = [];
	unload_groups[ "passengers" ] = [];
	unload_groups[ "mid_passengers" ] = [];
	unload_groups[ "rear_passengers" ] = [];
	unload_groups[ "left_passengers" ] = [];
	unload_groups[ "right_passengers" ] = [];
	
	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	
	group = "driver";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	
	group = "passengers";		
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;

	group = "mid_passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;	

	group = "rear_passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;	

	group = "left_passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;	
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;	

	group = "right_passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;	
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;	
	
	unload_groups[ "default" ] = unload_groups[ "all" ];
	
	return unload_groups;
}
