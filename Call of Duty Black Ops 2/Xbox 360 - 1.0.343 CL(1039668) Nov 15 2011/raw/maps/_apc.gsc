#include maps\_vehicle;
main()
{
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_unload_groups( ::unload_groups );
}


#using_animtree ("vehicles");
set_vehicle_anims(positions)
{
	positions[0].sittag = "tag_guy0";		
	positions[1].sittag = "tag_guy1";		
	positions[2].sittag = "tag_guy2";		
	positions[3].sittag = "tag_guy3";		
	positions[4].sittag = "tag_guy4";		
	positions[5].sittag = "tag_guy5";		
	
	positions[0].vehicle_getoutanim_clear = false;
	positions[1].vehicle_getoutanim_clear = false;
	positions[2].vehicle_getoutanim_clear = false;
	positions[3].vehicle_getoutanim_clear = false;
	positions[4].vehicle_getoutanim_clear = false;
	positions[5].vehicle_getoutanim_clear = false;	
	
	positions[0].vehicle_getoutanim = %v_crew_m113_hatch_open;
	positions[1].vehicle_getoutanim = %v_crew_m113_hatch_open;
	positions[2].vehicle_getoutanim = %v_crew_m113_hatch_open;
	positions[3].vehicle_getoutanim = %v_crew_m113_hatch_open;
	positions[4].vehicle_getoutanim = %v_crew_m113_hatch_open;
	positions[5].vehicle_getoutanim = %v_crew_m113_hatch_open;	
	
	return positions;
}

#using_animtree ("generic_human");
setanims ()
{
	positions = [];
	for(i = 0; i < 8; i++)
	{
		positions[i] = spawnstruct();
	}

	positions[0].sittag = "tag_guy0";			// driver
	positions[1].sittag = "tag_guy1";		// shotgun
	positions[2].sittag = "tag_guy2";		// guy2 - left side
	positions[3].sittag = "tag_guy3";		// guy3 - right side
	positions[4].sittag = "tag_guy4";		// guy4 - left back
	positions[5].sittag = "tag_guy5";		// guy5 - right back

	positions[0].idle = %ai_crew_m113_guy0_idle;	
	positions[1].idle = %ai_crew_m113_guy1_idle;	
	positions[2].idle = %ai_crew_m113_guy2_idle; 		
	positions[3].idle = %ai_crew_m113_guy3_idle;		
	positions[4].idle = %ai_crew_m113_guy4_idle;		
	positions[5].idle = %ai_crew_m113_guy5_idle;		

	positions[0].getout = %ai_crew_m113_guy0_exit;
	positions[1].getout = %ai_crew_m113_guy1_exit;
	positions[2].getout = %ai_crew_m113_guy2_exit;
	positions[3].getout = %ai_crew_m113_guy3_exit;
	positions[4].getout = %ai_crew_m113_guy4_exit;
	positions[5].getout = %ai_crew_m113_guy5_exit;	
	
	positions[6].sittag = "tag_gunner4";
	positions[6].vehiclegunner = 4;
	positions[6].idle = %ai_m113_gunner_aim;
	positions[6].aimup = %ai_m113_gunner_aim_up;
	positions[6].aimdown = %ai_m113_gunner_aim_down;
	positions[6].death = %ai_crew_m113_gunner_death;

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
	
	unload_groups[ "default" ] = unload_groups[ "all" ];
	
	return unload_groups;	
}