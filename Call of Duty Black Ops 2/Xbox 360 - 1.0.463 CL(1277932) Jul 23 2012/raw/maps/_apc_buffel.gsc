#include maps\_vehicle;
main()
{
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_unload_groups( ::unload_groups );
}

#using_animtree ("vehicles");
set_vehicle_anims(positions)
{
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_guy1";	 
	positions[ 2 ].sittag = "tag_guy2";
	positions[ 3 ].sittag = "tag_guy3";
	positions[ 4 ].sittag = "tag_guy4";
	positions[ 5 ].sittag = "tag_guy5";
	positions[ 6 ].sittag = "tag_guy6";
	positions[ 7 ].sittag = "tag_guy7";
	positions[ 8 ].sittag = "tag_guy8";
	positions[ 9 ].sittag = "tag_gunner_turret1";

	positions[ 0 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	positions[ 2 ].vehicle_getoutanim_clear = false;
	positions[ 3 ].vehicle_getoutanim_clear = false;
	positions[ 4 ].vehicle_getoutanim_clear = false;
	positions[ 5 ].vehicle_getoutanim_clear = false;
	positions[ 6 ].vehicle_getoutanim_clear = false;
	positions[ 7 ].vehicle_getoutanim_clear = false;
	positions[ 8 ].vehicle_getoutanim_clear = false;
	
	positions[ 0 ].vehicle_getoutanim = %v_crew_buffel_left_frontdoor_open;
	positions[ 1 ].vehicle_getoutanim = %v_crew_buffel_left_backdoor_open;
	positions[ 2 ].vehicle_getoutanim = %v_crew_buffel_left_backdoor_open;
	positions[ 3 ].vehicle_getoutanim = %v_crew_buffel_left_backdoor_open;
	positions[ 4 ].vehicle_getoutanim = %v_crew_buffel_left_backdoor_open;
	positions[ 5 ].vehicle_getoutanim = %v_crew_buffel_right_backdoor_open;
	positions[ 6 ].vehicle_getoutanim = %v_crew_buffel_right_backdoor_open;
	positions[ 7 ].vehicle_getoutanim = %v_crew_buffel_right_backdoor_open;
	positions[ 8 ].vehicle_getoutanim = %v_crew_buffel_right_backdoor_open;

	positions[ 9 ].vehicle_idle = %v_crew_buffel_gun_aim;
	positions[ 9 ].vehicle_aimup = %v_crew_buffel_gun_aim_down;
	positions[ 9 ].vehicle_aimdown = %v_crew_buffel_gun_aim_up;
	positions[ 9 ].vehicle_fire = %v_crew_buffel_fire;
	positions[ 9 ].vehicle_fireup = %v_crew_buffel_fire_down;
	positions[ 9 ].vehicle_firedown = %v_crew_buffel_fire_up;
	
	return positions;
}

#using_animtree ("generic_human");
setanims ()
{
	positions = [];
	const num_positions = 10;
	
	for( i = 0; i < num_positions; i++ )
	{
		positions[ i ] = spawnstruct();
	}

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_guy1";
	positions[ 2 ].sittag = "tag_guy2";
	positions[ 3 ].sittag = "tag_guy3";
	positions[ 4 ].sittag = "tag_guy4";
	positions[ 5 ].sittag = "tag_guy5";
	positions[ 6 ].sittag = "tag_guy6";
	positions[ 7 ].sittag = "tag_guy7";
	positions[ 8 ].sittag = "tag_guy8";
	positions[ 9 ].sittag = "tag_gunner1";		
  
	positions[ 0 ].getout = %ai_crew_buffel_driver_exit;
	positions[ 1 ].getout = %ai_crew_buffel_guy1_exit;
	positions[ 2 ].getout = %ai_crew_buffel_guy2_exit;
	positions[ 3 ].getout = %ai_crew_buffel_guy3_exit;
	positions[ 4 ].getout = %ai_crew_buffel_guy4_exit;
	positions[ 5 ].getout = %ai_crew_buffel_guy5_exit;
	positions[ 6 ].getout = %ai_crew_buffel_guy6_exit;
	positions[ 7 ].getout = %ai_crew_buffel_guy7_exit;
	positions[ 8 ].getout = %ai_crew_buffel_guy8_exit;
	
	positions[ 0 ].idle = %ai_crew_buffel_driver_idle;
	positions[ 1 ].idle = %ai_crew_buffel_guy1_idle;
	positions[ 2 ].idle = %ai_crew_buffel_guy2_idle;
	positions[ 3 ].idle = %ai_crew_buffel_guy3_idle;
	positions[ 4 ].idle = %ai_crew_buffel_guy4_idle;
	positions[ 5 ].idle = %ai_crew_buffel_guy5_idle;
	positions[ 6 ].idle = %ai_crew_buffel_guy6_idle;
	positions[ 7 ].idle = %ai_crew_buffel_guy7_idle;
	positions[ 8 ].idle = %ai_crew_buffel_guy8_idle;
	
	positions[ 9 ].vehiclegunner = 1;
	positions[ 9 ].idle = %ai_crew_buffel_gunner_aim;
	positions[ 9 ].aimup = %ai_crew_buffel_gunner_aim_down;
	positions[ 9 ].aimdown = %ai_crew_buffel_gunner_aim_up;
	positions[ 9 ].fire = %ai_crew_buffel_gunner_fire;
	positions[ 9 ].fireup = %ai_crew_buffel_gunner_fire_down;
	positions[ 9 ].firedown = %ai_crew_buffel_gunner_fire_up;
	

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
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	unload_groups[ group ][ unload_groups[ group ].size ] = 6;
	unload_groups[ group ][ unload_groups[ group ].size ] = 7;
	unload_groups[ group ][ unload_groups[ group ].size ] = 8;
	
	unload_groups[ "default" ] = unload_groups[ "all" ];
	
	return unload_groups;	
}