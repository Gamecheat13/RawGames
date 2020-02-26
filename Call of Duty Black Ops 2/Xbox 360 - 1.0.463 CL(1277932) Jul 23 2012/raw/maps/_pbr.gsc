// _pbr.gsc

#include maps\_vehicle;
init()
{
	vehicle_add_main_callback( "boat_pbr_medium", ::main );
	vehicle_add_main_callback( "boat_patrol_nva", ::patrol_main );		
	vehicle_add_main_callback( "boat_patrol_nva_river", ::patrol_main );	
}

main( model, type )
{
	build_aianims( ::setanims , ::set_vehicle_anims );
}

patrol_main( model, type)
{
	build_aianims( ::patrol_setanim , ::set_vehicle_anims );	
}

set_vehicle_anims(positions)
{
	return positions;
}

#using_animtree ("generic_human");
setanims()
{
	positions = [];
	positions[0] = spawnstruct();
	
	positions[0].sittag = "tag_gunner1";
	positions[0].vehiclegunner = 1;
	positions[0].idle = %ai_crew_gunboat_front_gunner_aim;
	positions[0].aimup = %ai_crew_gunboat_front_gunner_aim_up;
	positions[0].aimdown = %ai_crew_gunboat_front_gunner_aim_down;
	positions[0].death = %ai_crew_gunboat_front_gunner_death_front;
	positions[0].explosion_death = %ai_crew_gunboat_front_gunner_death_front;
	
	positions[1] = spawnstruct();
	
	positions[1].sittag = "tag_gunner2";
	positions[1].vehiclegunner = 2;
	positions[1].idle = %ai_crew_gunboat_rear_gunner_aim;
	positions[1].aimup = %ai_crew_gunboat_rear_gunner_aim_up;
	positions[1].aimdown = %ai_crew_gunboat_rear_gunner_aim_down;	
	positions[1].death = %ai_crew_gunboat_rear_gunner_death_right;
	positions[1].explosion_death = %ai_crew_gunboat_rear_gunner_death_right;
	
	return positions;
}

patrol_setanim()
{
	positions = [];
	positions[0] = spawnstruct();
	
	positions[0].sittag = "tag_gunner1";
	positions[0].vehiclegunner = 1;
	positions[0].idle = %ai_crew_gunboat_front_gunner_aim;
	positions[0].aimup = %ai_crew_gunboat_front_gunner_aim_up;
	positions[0].aimdown = %ai_crew_gunboat_front_gunner_aim_down;
	positions[0].death = %ai_crew_gunboat_front_gunner_death_front;
	positions[0].explosion_death = %ai_crew_gunboat_front_gunner_death_front;
	
	return positions;
}