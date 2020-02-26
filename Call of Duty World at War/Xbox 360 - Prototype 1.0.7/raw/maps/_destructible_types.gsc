#include maps\_destructible;
#using_animtree( "vehicledamage" );

makeType( destructibleType )
{
	println( destructibleType );
	
	// if it's already been created dont create it again
	infoIndex = getInfoIndex( destructibleType );
	if ( infoIndex >= 0 )
	{
		println( "### DESTRUCTIBLE ### already created" );
		return infoIndex;
	}
	
	println( "### DESTRUCTIBLE ### creating" );
	
	switch( destructibleType )
	{
		case "vehicle_80s_sedan1_green":
			vehicle_80s_sedan1( "green" );
			break;
		case "vehicle_80s_sedan1_red":
			vehicle_80s_sedan1( "red" );
			break;
		case "vehicle_80s_sedan1_silv":
			vehicle_80s_sedan1( "silv" );
			break;
		case "vehicle_80s_sedan1_tan":
			vehicle_80s_sedan1( "tan" );
			break;
		case "vehicle_80s_sedan1_yel":
			vehicle_80s_sedan1( "yel" );
			break;
		case "vehicle_80s_sedan1_brn":
			vehicle_80s_sedan1( "brn" );
			break;
		case "vehicle_80s_sedan1_green_side":
			vehicle_80s_sedan1_side( "green" );
			break;
		case "vehicle_80s_sedan1_red_side":
			vehicle_80s_sedan1_side( "red" );
			break;
		case "vehicle_80s_sedan1_silv_side":
			vehicle_80s_sedan1_side( "silv" );
			break;
		case "vehicle_80s_sedan1_tan_side":
			vehicle_80s_sedan1_side( "tan" );
			break;
		case "vehicle_80s_sedan1_yel_side":
			vehicle_80s_sedan1_side( "yel" );
			break;
		case "vehicle_80s_sedan1_brn_side":
			vehicle_80s_sedan1_side( "brn" );
			break;
		case "vehicle_bus_destructible":
			vehicle_bus_destructible();
			break;
		default:
			assertMsg( "Destructible object 'destructible_type' key/value of '" + destructibleType + "' is not valid" );
			break;
	}
	
	infoIndex = getInfoIndex( destructibleType );
	assert( infoIndex >= 0 );
	return infoIndex;
}

getInfoIndex( destructibleType )
{
	if ( !isdefined( level.destructible_type ) )
		return -1;
	if ( level.destructible_type.size == 0 )
		return -1;
	
	for( i = 0 ; i < level.destructible_type.size ; i++ )
	{
		if ( destructibleType == level.destructible_type[ i ].v[ "type" ] )
			return i;
	}
	
	// didn't find it in the array, must not exist
	return -1;
}

vehicle_80s_sedan1( color )
{
	//---------------------------------------------------------------------
	// 80's Sedan
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_sedan1_" + color, 300 );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 200 );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 300, "player_only" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_healthdrain( 15, 0.25 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 400 );
				destructible_fx( "tag_death_fx", "explosions/large_vehicle_explosion" );
				destructible_sound( "flak88_explode" );
				destructible_explode( 400, 850, 400, 100, 800 );
				destructible_anim( %vehicle_80s_sedan1_destroy, #animtree, "setanimknob" );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destroyed" );
		// Hood
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_hood", 1000 );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_hood_dam" );
		//Trunk
		tag = "tag_trunk";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_trunk", 1000 );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_trunk_dam", 2000 );
		// Tires
		destructible_part( "tag_wheel_left_front", "vehicle_80s_sedan1_" + color + "_wheel_LF", 99 );
			destructible_anim( %vehicle_80s_sedan1_flattire_LF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate" );
		destructible_part( "tag_wheel_left_back", "vehicle_80s_sedan1_" + color + "_wheel_LF", 99 );
			destructible_anim( %vehicle_80s_sedan1_flattire_LB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate" );
		destructible_part( "tag_wheel_right_front", "vehicle_80s_sedan1_" + color + "_wheel_LF", 99 );
			destructible_anim( %vehicle_80s_sedan1_flattire_RF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate" );
		destructible_part( "tag_wheel_right_back", "vehicle_80s_sedan1_" + color + "_wheel_LF", 99 );
			destructible_anim( %vehicle_80s_sedan1_flattire_RB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_80s_sedan1_" + color + "_door_LF" );
		destructible_part( "tag_door_left_back", "vehicle_80s_sedan1_" + color + "_door_LB" );
		destructible_part( "tag_door_right_front", "vehicle_80s_sedan1_" + color + "_door_RF" );
		destructible_part( "tag_door_right_back", "vehicle_80s_sedan1_" + color + "_door_RB" );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_F", 99 );
			destructible_state( tag, "vehicle_80s_sedan1_glass_F_dam", 200 );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_B", 99 );
			destructible_state( tag, "vehicle_80s_sedan1_glass_B_dam", 200 );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_LF", 99 );
			destructible_state( tag, "vehicle_80s_sedan1_glass_LF_dam", 200 );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_RF", 99 );
			destructible_state( tag, "vehicle_80s_sedan1_glass_RF_dam", 200 );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_LB", 99 );
			destructible_state( tag, "vehicle_80s_sedan1_glass_LB_dam", 200 );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_RB", 99 );
			destructible_state( tag, "vehicle_80s_sedan1_glass_RB_dam", 200 );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_LF", 99 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_RF", 99 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_RF_dam" );
		// Tail Light ( Left )
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_LB", 99 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_LB_dam" );
		// Tail Light ( Right )
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_RB", 99 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_RB_dam" );
		// Bumpers
		destructible_part( "tag_bumper_front", "vehicle_80s_sedan1_" + color + "_bumper_F" );
		destructible_part( "tag_bumper_back", "vehicle_80s_sedan1_" + color + "_bumper_B" );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_80s_sedan1_" + color + "_mirror_L", 99 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_80s_sedan1_" + color + "_mirror_R", 99 );
			destructible_physics();
}

vehicle_80s_sedan1_side( color )
{
	//---------------------------------------------------------------------
	// 80's Sedan - Layed On Side
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_sedan1_" + color + "_side", 300 );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 200 );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 300, "player_only" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_healthdrain( 15, 0.25 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 400 );
				destructible_fx( "tag_death_fx", "explosions/large_vehicle_explosion" );
				destructible_sound( "flak88_explode" );
				destructible_explode( 400, 850, 400, 100, 800 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destroyed" );
		// Hood
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_hood", 1000 );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_hood_dam" );
		//Trunk
		tag = "tag_trunk";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_trunk", 1000 );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_trunk_dam", 2000 );
		// Tires
		destructible_part( "tag_wheel_left_front", "vehicle_80s_sedan1_" + color + "_wheel_LF", 99 );
			destructible_sound( "veh_tire_deflate" );
		destructible_part( "tag_wheel_left_back", "vehicle_80s_sedan1_" + color + "_wheel_LF", 99 );
			destructible_sound( "veh_tire_deflate" );
		destructible_part( "tag_wheel_right_front", "vehicle_80s_sedan1_" + color + "_wheel_LF", 99 );
			destructible_sound( "veh_tire_deflate" );
		destructible_part( "tag_wheel_right_back", "vehicle_80s_sedan1_" + color + "_wheel_LF", 99 );
			destructible_sound( "veh_tire_deflate" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_80s_sedan1_" + color + "_door_LF" );
		destructible_part( "tag_door_left_back", "vehicle_80s_sedan1_" + color + "_door_LB" );
		destructible_part( "tag_door_right_front", "vehicle_80s_sedan1_" + color + "_door_RF" );
		destructible_part( "tag_door_right_back", "vehicle_80s_sedan1_" + color + "_door_RB" );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_F", 99 );
			destructible_state( tag, "vehicle_80s_sedan1_glass_F_dam", 200 );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_B", 99 );
			destructible_state( tag, "vehicle_80s_sedan1_glass_B_dam", 200 );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_LF", 99 );
			destructible_state( tag, "vehicle_80s_sedan1_glass_LF_dam", 200 );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_RF", 99 );
			destructible_state( tag, "vehicle_80s_sedan1_glass_RF_dam", 200 );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_LB", 99 );
			destructible_state( tag, "vehicle_80s_sedan1_glass_LB_dam", 200 );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_RB", 99 );
			destructible_state( tag, "vehicle_80s_sedan1_glass_RB_dam", 200 );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_LF", 99 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_RF", 99 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_RF_dam" );
		// Tail Light ( Left )
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_LB", 99 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_LB_dam" );
		// Tail Light ( Right )
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_RB", 99 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_RB_dam" );
		// Bumpers
		destructible_part( "tag_bumper_front", "vehicle_80s_sedan1_" + color + "_bumper_F" );
		destructible_part( "tag_bumper_back", "vehicle_80s_sedan1_" + color + "_bumper_B" );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_80s_sedan1_" + color + "_mirror_L" );
		destructible_part( "tag_mirror_right", "vehicle_80s_sedan1_" + color + "_mirror_R" );
}

vehicle_bus_destructible()
{
	
	
	//---------------------------------------------------------------------
	// Bus
	//---------------------------------------------------------------------
	/*
	models:
	vehicle_bus_glass_back
	vehicle_bus_glass_back_dest
	vehicle_bus_glass_side
	vehicle_bus_glass_side_dest
	
	tags:
	tag_window_right_1
	tag_window_right_10
	tag_window_right_11
	tag_window_right_12
	tag_window_right_2 - back
	tag_window_right_3
	tag_window_right_4
	tag_window_right_5
	tag_window_right_6
	tag_window_right_7
	tag_window_right_8
	tag_window_right_9
	*/
	destructible_create( "vehicle_bus_destructible" );
	/*
	// Glass ( Front Left )
	tag = "tag_window_front_left";
	destructible_part( tag, "vehicle_bus_glass_fl", 99 );
		destructible_state( tag, "vehicle_bus_glass_fl_dest", 200 );
		//destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
		destructible_sound( "veh_glass_break_large" );
		destructible_state( undefined );
	// Glass ( Front Right )
	tag = "tag_window_front_right";
	destructible_part( tag, "vehicle_bus_glass_fr", 99 );
		destructible_state( tag, "vehicle_bus_glass_fr_dest", 200 );
		//destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
		destructible_sound( "veh_glass_break_large" );
		destructible_state( undefined );
	// Glass ( Driver Side )
	tag = "tag_window_driver";
	destructible_part( tag, "vehicle_bus_glass_driver", 99 );
		destructible_state( tag, "vehicle_bus_glass_driver_dest", 200 );
		//destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
		destructible_sound( "veh_glass_break_large" );
		destructible_state( undefined );
	*/
}