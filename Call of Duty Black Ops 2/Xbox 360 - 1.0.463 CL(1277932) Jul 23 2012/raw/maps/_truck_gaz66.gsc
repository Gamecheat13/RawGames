// _truck_gaz66.gsc
//-- originally copied from _truck.gsc

#include maps\_vehicle;
main( model, type )
{

	
	//truck_gaz66_player_single50 needs separate anims setup
	if(self.vehicletype == "truck_gaz66_player_single50")
	{
		build_aianims( ::set_gunner_anims , ::set_gunner_vehicle_anims );
		//build_unload_groups( ::unload_gunner_groups );
	}
	else
	{
		build_aianims( ::setanims , ::set_vehicle_anims );
		build_unload_groups( ::unload_groups );
	}
}

#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	positions[ 2 ].sittag = "tag_guy1";
	positions[ 3 ].sittag = "tag_guy6";
	positions[ 4 ].sittag = "tag_guy3";
	positions[ 5 ].sittag = "tag_guy8";
	positions[ 6 ].sittag = "tag_guy5";
	positions[ 7 ].sittag = "tag_guy2";
	positions[ 8 ].sittag = "tag_guy7";
	positions[ 9 ].sittag = "tag_guy4";

	positions[ 0 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getoutanim_clear = false;

	positions[ 0 ].vehicle_getinanim = %v_gaz63_driver_door_open;
	positions[ 1 ].vehicle_getinanim = %v_gaz63_passenger_door_open;

	positions[ 0 ].vehicle_getoutanim = %v_gaz63_driver_door_open;
	positions[ 1 ].vehicle_getoutanim = %v_gaz63_passenger_door_open;

	return positions;
}

#using_animtree( "generic_human" );
setanims()
{
	positions = [];
	const num_positions = 10;
	
	for( i =0 ;i < num_positions; i++ )
	{
		positions[ i ] = spawnstruct();
	}

	//positions tags are offset to even out the truckbed if less than max ai are riding top down looks like this
	// | 1 || 6 3 8 5 
	// | 0 || 2 7 4 9
		
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	positions[ 2 ].sittag = "tag_guy1";
	positions[ 3 ].sittag = "tag_guy6";
	positions[ 4 ].sittag = "tag_guy3";
	positions[ 5 ].sittag = "tag_guy8";
	positions[ 6 ].sittag = "tag_guy5";
	positions[ 7 ].sittag = "tag_guy2";
	positions[ 8 ].sittag = "tag_guy7";
	positions[ 9 ].sittag = "tag_guy4";

	positions[ 0 ].getout = %crew_truck_driver_climbout;
	positions[ 1 ].getout = %crew_truck_passenger_climbout;
	positions[ 2 ].getout = %crew_truck_guy1_climbout;
	positions[ 3 ].getout = %crew_truck_guy6_climbout;
	positions[ 4 ].getout = %crew_truck_guy3_climbout;
	positions[ 5 ].getout = %crew_truck_guy8_climbout;
	positions[ 6 ].getout = %crew_truck_guy5_climbout;
	positions[ 7 ].getout = %crew_truck_guy2_climbout;
	positions[ 8 ].getout = %crew_truck_guy7_climbout;
	positions[ 9 ].getout = %crew_truck_guy4_climbout;

	positions[ 0 ].getout_combat = %crew_gaz63_driver_jump_out;
	positions[ 1 ].getout_combat = %crew_gaz63_passenger_climbout_fast;
	positions[ 2 ].getout_combat = %crew_truck_guy1_climbout_fast;
	positions[ 3 ].getout_combat = %crew_truck_guy6_climbout_fast;
	positions[ 4 ].getout_combat = %crew_truck_guy3_climbout;
	positions[ 5 ].getout_combat = %crew_truck_guy8_climbout;
	positions[ 6 ].getout_combat = %crew_truck_guy5_climbout_fast;
	positions[ 7 ].getout_combat = %crew_truck_guy2_climbout_fast;
	positions[ 8 ].getout_combat = %crew_truck_guy7_climbout;
	positions[ 9 ].getout_combat = %crew_truck_guy4_climbout;

	/*positions[ 0 ].getin = %crew_truck_driver_climbin;
	positions[ 1 ].getin = %crew_truck_passenger_climbin;
	positions[ 2 ].getin = %crew_truck_guy1_climbin; 
	positions[ 3 ].getin = %crew_truck_guy2_climbin; 
	positions[ 4 ].getin = %crew_truck_guy3_climbin; 
	positions[ 5 ].getin = %crew_truck_guy4_climbin; 
	positions[ 6 ].getin = %crew_truck_guy5_climbin; 
	positions[ 7 ].getin = %crew_truck_guy6_climbin; 
	positions[ 8 ].getin = %crew_truck_guy7_climbin; 
	positions[ 9 ].getin = %crew_truck_guy8_climbin;*/

	positions[ 0 ].idle = %crew_truck_driver_sit_idle;
	positions[ 1 ].idle = %crew_gaz63_passenger_sit_idle;
	positions[ 2 ].idle = %crew_truck_guy1_sit_idle;
	positions[ 3 ].idle = %crew_truck_guy6_sit_idle;
	positions[ 4 ].idle = %crew_truck_guy3_sit_idle;
	positions[ 5 ].idle = %crew_truck_guy8_sit_idle;
	positions[ 6 ].idle = %crew_truck_guy5_sit_idle;
	positions[ 7 ].idle = %crew_truck_guy2_sit_idle;
	positions[ 8 ].idle = %crew_truck_guy7_sit_idle;
	positions[ 9 ].idle = %crew_truck_guy4_sit_idle;

	/*positions[ 0 ].drive_idle = %crew_truck_driver_drive_idle;
	positions[ 1 ].drive_idle = %crew_truck_passenger_drive_idle;               
	positions[ 2 ].drive_idle = %crew_truck_guy1_drive_sit_idle;                
	positions[ 3 ].drive_idle = %crew_truck_guy2_drive_sit_idle;                
	positions[ 4 ].drive_idle = %crew_truck_guy3_drive_sit_idle;                
	positions[ 5 ].drive_idle = %crew_truck_guy4_drive_sit_idle;                
	positions[ 6 ].drive_idle = %crew_truck_guy5_drive_sit_idle;                
	positions[ 7 ].drive_idle = %crew_truck_guy6_drive_sit_idle;                
	positions[ 8 ].drive_idle = %crew_truck_guy7_drive_sit_idle;                
	positions[ 9 ].drive_idle = %crew_truck_guy8_drive_sit_idle;                
                                                 
	positions[ 0 ].drive_reaction = %crew_truck_driver_drive_reaction;
	positions[ 1 ].drive_reaction = %crew_truck_passenger_drive_reaction;
	positions[ 2 ].drive_reaction = %crew_truck_guy1_drive_reaction; 
	positions[ 3 ].drive_reaction = %crew_truck_guy2_drive_reaction; 
	positions[ 4 ].drive_reaction = %crew_truck_guy3_drive_reaction;   
	positions[ 5 ].drive_reaction = %crew_truck_guy4_drive_reaction; 
	positions[ 6 ].drive_reaction = %crew_truck_guy5_drive_reaction; 
	positions[ 7 ].drive_reaction = %crew_truck_guy6_drive_reaction; 
	positions[ 8 ].drive_reaction = %crew_truck_guy7_drive_reaction; 
	positions[ 9 ].drive_reaction = %crew_truck_guy8_drive_reaction; 

	positions[ 0 ].death_shot = %crew_truck_driver_death_shot;
	positions[ 1 ].death_shot = %crew_truck_passenger_death_shot;
	positions[ 2 ].death_shot = %crew_truck_guy1_death_shot; 
	positions[ 3 ].death_shot = %crew_truck_guy2_death_shot; 
	positions[ 4 ].death_shot = %crew_truck_guy3_death_shot;   
	positions[ 5 ].death_shot = %crew_truck_guy4_death_shot; 
	positions[ 6 ].death_shot = %crew_truck_guy5_death_shot; 
	positions[ 7 ].death_shot = %crew_truck_guy6_death_shot; 
	positions[ 8 ].death_shot = %crew_truck_guy7_death_shot; 
	positions[ 9 ].death_shot = %crew_truck_guy8_death_shot; 

	positions[ 0 ].death_fire = %crew_truck_driver_death_fire;
	positions[ 1 ].death_fire = %crew_truck_passenger_death_fire;
	positions[ 2 ].death_fire = %crew_truck_guy1_death_fire; 
	positions[ 3 ].death_fire = %crew_truck_guy2_death_fire; 
	positions[ 4 ].death_fire = %crew_truck_guy3_death_fire;   
	positions[ 5 ].death_fire = %crew_truck_guy4_death_fire; 
	positions[ 6 ].death_fire = %crew_truck_guy5_death_fire; 
	positions[ 7 ].death_fire = %crew_truck_guy6_death_fire; 
	positions[ 8 ].death_fire = %crew_truck_guy7_death_fire; 
	positions[ 9 ].death_fire = %crew_truck_guy8_death_fire; 

	positions[ 2 ].explosion_death = %death_explosion_forward13;
	positions[ 3 ].explosion_death = %death_explosion_left11;
	positions[ 4 ].explosion_death = %death_explosion_left11;
	positions[ 5 ].explosion_death = %death_explosion_back13;
	positions[ 6 ].explosion_death = %death_explosion_forward13;
	positions[ 7 ].explosion_death = %death_explosion_right13;
	positions[ 8 ].explosion_death = %death_explosion_right13;
	*/

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];
	unload_groups[ "passengers" ] = [];
	unload_groups[ "rear_passengers" ] = [];	

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
	unload_groups[ group ][ unload_groups[ group ].size ] = 9;
	
	group = "passengers";		
	//unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	unload_groups[ group ][ unload_groups[ group ].size ] = 6;
	unload_groups[ group ][ unload_groups[ group ].size ] = 7;
	unload_groups[ group ][ unload_groups[ group ].size ] = 8;
	unload_groups[ group ][ unload_groups[ group ].size ] = 9;

	group = "rear_passengers";
	//unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	unload_groups[ group ][ unload_groups[ group ].size ] = 6;
	unload_groups[ group ][ unload_groups[ group ].size ] = 7;
	unload_groups[ group ][ unload_groups[ group ].size ] = 8;
	unload_groups[ group ][ unload_groups[ group ].size ] = 9;
	
	unload_groups[ "default" ] = unload_groups[ "passengers" ];
	
	return unload_groups;
}

//these are for the player_single50

#using_animtree( "generic_human" );
set_gunner_vehicle_anims(positions)
{
   return positions;
}

set_gunner_anims()
{
  positions = [];
 	const num_positions = 3;
 
  for( i =0 ;i < num_positions; i++ )
	{
		positions[ i ] = spawnstruct();
	}
  
  positions[0].sittag = "tag_driver";
	positions[1].sittag = "tag_passenger";	
  positions[2].sittag = "tag_gunner1";
  
  	positions[ 0 ].idle = %crew_truck_driver_sit_idle;
	positions[ 1 ].idle = %crew_gaz63_passenger_sit_idle;
	
	
  positions[2].vehiclegunner = 1;
  positions[2].idle = %ai_50cal_gunner_aim;
  positions[2].aimup = %ai_50cal_gunner_aim_up;
  positions[2].aimdown = %ai_50cal_gunner_aim_down;

  return positions;
}