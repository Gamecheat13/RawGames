























































#include maps\_utility;
main()
{
	
	if( GetDvar( "enable_stats" ) == "" )
	{
		return;
	}

	self setup_player_stats();
	self thread weapon_use_thread();

	if( GetDvar( "stat_track_player" ) != "" )
	{
		self thread track_player();
	}
}

setup_player_stats()
{
	self._stats = [];

	
	init_stat( "level", "time", 0 );
	init_stat( "level", "start_time", GetTime() );
	init_stat( "career", "time", 0 );

	
	init_stat( "level", "hits", 0 );
	init_stat( "career", "hits", 0 );


	init_stat( "level", "kills", 0 );
	init_stat( "career", "kills", 0 );

	

	init_stat( "level", "hitloc_helmet", 0 );
	init_stat( "level", "hitloc_head", 0 );
	init_stat( "level", "hitloc_neck", 0 );
	init_stat( "level", "hitloc_torso_upper", 0 );
	init_stat( "level", "hitloc_torso_lower", 0 );
	init_stat( "level", "hitloc_right_arm_upper", 0 );
	init_stat( "level", "hitloc_right_arm_lower", 0 );
	init_stat( "level", "hitloc_right_hand", 0 );
	init_stat( "level", "hitloc_left_arm_upper", 0 );
	init_stat( "level", "hitloc_left_arm_lower", 0 );
	init_stat( "level", "hitloc_left_hand", 0 );
	init_stat( "level", "hitloc_right_leg_upper", 0 );
	init_stat( "level", "hitloc_right_leg_lower", 0 );
	init_stat( "level", "hitloc_right_foot", 0 );
	init_stat( "level", "hitloc_left_leg_upper", 0 );
	init_stat( "level", "hitloc_left_leg_lower", 0 );
	init_stat( "level", "hitloc_left_foot", 0 );
	init_stat( "level", "hitloc_gun", 0 );

	

	init_stat( "career", "hitloc_helmet", 0 );
	init_stat( "career", "hitloc_head", 0 );
	init_stat( "career", "hitloc_neck", 0 );
	init_stat( "career", "hitloc_torso_upper", 0 );
	init_stat( "career", "hitloc_torso_lower", 0 );
	init_stat( "career", "hitloc_right_arm_upper", 0 );
	init_stat( "career", "hitloc_right_arm_lower", 0 );
	init_stat( "career", "hitloc_right_hand", 0 );
	init_stat( "career", "hitloc_left_arm_upper", 0 );
	init_stat( "career", "hitloc_left_arm_lower", 0 );
	init_stat( "career", "hitloc_left_hand", 0 );
	init_stat( "career", "hitloc_right_leg_upper", 0 );
	init_stat( "career", "hitloc_right_leg_lower", 0 );
	init_stat( "career", "hitloc_right_foot", 0 );
	init_stat( "career", "hitloc_left_leg_upper", 0 );
	init_stat( "career", "hitloc_left_leg_lower", 0 );
	init_stat( "career", "hitloc_left_foot", 0 );
	init_stat( "career", "hitloc_gun", 0 );

	

	
	init_weapon_stat( "ak47" );
	init_weapon_stat( "g3" );
	init_weapon_stat( "g36c" );
	init_weapon_stat( "mp14_scoped" );
	init_weapon_stat( "mp44" );
	init_weapon_stat( "mp5" );
}




end_level_stats()
{
	players = GetEntArray( "player", "classname" );
	array_thread( players, ::get_stats );

	if( GetDvar( "stat_track_player" ) != "" )
	{
		array_thread( players, ::write_player_track );
	}
}

get_career_stats()
{
	begin_html_table( "Career Stats" );

	
	time_played = GetTime() - get_stat_value( "level", "start_time" );

	time = get_stat_value( "career", "time" );
	set_stat( "career", "time", time + time_played );

	SetDvar( "stats_career_time_days", to_hours( get_stat_value( "career", "time" ) * 0.001, true ) );
	

	add_html_table_row( "Career Game Time:", to_hours( get_stat_value( "career", "time" ) * 0.001, true ) );

	kills = get_stat_value( "career", "kills" );
	add_html_table_row( "Total Kills:", kills );

	if( kills > 0 && time > 0 )
	{
		add_html_table_row( "Kills Per Minute:", per_minute( kills, time * 0.001 ) );
	}
	else
	{
		add_html_table_row( "Kills Per Minute:", 0 );
	}
	end_html_table();

	get_weapon_stats( true );

	
	hits = get_stat_value( "career", "hits" );

	begin_html_table( "Locational Damage Stats" );
	add_html_table_row( "Helmet:", 			to_percent( get_stat_value( "career", "hitloc_helmet" ), hits ) );
	add_html_table_row( "Head:", 			to_percent( get_stat_value( "career", "hitloc_head" ), hits ) );
	add_html_table_row( "Neck:", 			to_percent( get_stat_value( "career", "hitloc_neck" ), hits ) );
	add_html_table_row( "Upper Torso:", 	to_percent( get_stat_value( "career", "hitloc_torso_upper" ), hits ) );
	add_html_table_row( "Lower Torso:", 	to_percent( get_stat_value( "career", "hitloc_torso_lower" ), hits ) );
	add_html_table_row( "Upper Right Arm:", to_percent( get_stat_value( "career", "hitloc_right_arm_upper" ), hits ) );
	add_html_table_row( "Lower Right Arm:", to_percent( get_stat_value( "career", "hitloc_right_arm_lower" ), hits ) );
	add_html_table_row( "Right Hand:", 		to_percent( get_stat_value( "career", "hitloc_right_hand" ), hits ) );
	add_html_table_row( "Upper Left Arm:", 	to_percent( get_stat_value( "career", "hitloc_left_arm_upper" ), hits ) );
	add_html_table_row( "Lower Left Arm:", 	to_percent( get_stat_value( "career", "hitloc_left_arm_lower" ), hits ) );
	add_html_table_row( "Left Hand:", 		to_percent( get_stat_value( "career", "hitloc_left_hand" ), hits ) );
	add_html_table_row( "Upper Right Leg:", to_percent( get_stat_value( "career", "hitloc_right_leg_upper" ), hits ) );
	add_html_table_row( "Lower Right Leg:", to_percent( get_stat_value( "career", "hitloc_right_leg_lower" ), hits ) );
	add_html_table_row( "Right Foot:", 		to_percent( get_stat_value( "career", "hitloc_right_foot" ), hits ) );
	add_html_table_row( "Upper Left Leg:", 	to_percent( get_stat_value( "career", "hitloc_left_leg_upper" ), hits ) );
	add_html_table_row( "Lower Left Leg:", 	to_percent( get_stat_value( "career", "hitloc_left_leg_lower" ), hits ) );
	add_html_table_row( "Left Foot:", 		to_percent( get_stat_value( "career", "hitloc_left_foot" ), hits ) );
	add_html_table_row( "Gun:", 			to_percent( get_stat_value( "career", "hitloc_gun" ), hits ) );
	end_html_table();
}

get_stats()
{
	begin_html_table( "Current Level Stats" );
	add_html_table_row( "Level:", level.script );

	
	time_played = GetTime() - get_stat_value( "level", "start_time" );
	set_stat( "level", "time", time_played );
	add_html_table_row( "Time:", to_hours( time_played * 0.001 ) );
	

	
	add_html_table_row( "Hits:", get_stat_value( "level", "hits" ) );

	kills = get_stat_value( "level", "kills" );
	add_html_table_row( "Kills:", kills );

	if( kills > 0 && time_played > 0 )
	{
		add_html_table_row( "Kills Per Minute:", per_minute( kills, time_played * 0.001 ) );
	}
	else
	{
		add_html_table_row( "Kills Per Minute:", 0 );
	}
	end_html_table();

	get_weapon_stats();

	
	hits = get_stat_value( "level", "hits" );

	begin_html_table( "Locational Damage Stats" );
	add_html_table_row( "Helmet:", 			to_percent( get_stat_value( "level", "hitloc_helmet" ), hits ) );
	add_html_table_row( "Head:", 			to_percent( get_stat_value( "level", "hitloc_head" ), hits ) );
	add_html_table_row( "Neck:", 			to_percent( get_stat_value( "level", "hitloc_neck" ), hits ) );
	add_html_table_row( "Upper Torso:", 	to_percent( get_stat_value( "level", "hitloc_torso_upper" ), hits ) );
	add_html_table_row( "Lower Torso:", 	to_percent( get_stat_value( "level", "hitloc_torso_lower" ), hits ) );
	add_html_table_row( "Upper Right Arm:", to_percent( get_stat_value( "level", "hitloc_right_arm_upper" ), hits ) );
	add_html_table_row( "Lower Right Arm:", to_percent( get_stat_value( "level", "hitloc_right_arm_lower" ), hits ) );
	add_html_table_row( "Right Hand:", 		to_percent( get_stat_value( "level", "hitloc_right_hand" ), hits ) );
	add_html_table_row( "Upper Left Arm:", 	to_percent( get_stat_value( "level", "hitloc_left_arm_upper" ), hits ) );
	add_html_table_row( "Lower Left Arm:", 	to_percent( get_stat_value( "level", "hitloc_left_arm_lower" ), hits ) );
	add_html_table_row( "Left Hand:", 		to_percent( get_stat_value( "level", "hitloc_left_hand" ), hits ) );
	add_html_table_row( "Upper Right Leg:", to_percent( get_stat_value( "level", "hitloc_right_leg_upper" ), hits ) );
	add_html_table_row( "Lower Right Leg:", to_percent( get_stat_value( "level", "hitloc_right_leg_lower" ), hits ) );
	add_html_table_row( "Right Foot:", 		to_percent( get_stat_value( "level", "hitloc_right_foot" ), hits ) );
	add_html_table_row( "Upper Left Leg:", 	to_percent( get_stat_value( "level", "hitloc_left_leg_upper" ), hits ) );
	add_html_table_row( "Lower Left Leg:", 	to_percent( get_stat_value( "level", "hitloc_left_leg_lower" ), hits ) );
	add_html_table_row( "Left Foot:", 		to_percent( get_stat_value( "level", "hitloc_left_foot" ), hits ) );
	add_html_table_row( "Gun:", 			to_percent( get_stat_value( "level", "hitloc_gun" ), hits ) );
	end_html_table();

	self get_career_stats();
	self write_html();
}




init_weapon_stat( weapon_name )
{
	if( !IsDefined( self._stats["levelweapons"] ) )
	{
		self._stats["levelweapons"] = [];
	}

	if( !IsDefined( self._stats["careerweapons"] ) )
	{
		self._stats["careerweapons"] = [];
	}

	self._stats["levelweapons"][weapon_name] = [];
	self._stats["careerweapons"][weapon_name] = [];

	set_weapon_stat( weapon_name, "in_use", false );
	set_weapon_stat( weapon_name, "start_time", 0 );
	set_weapon_stat( weapon_name, "use_time", 0, GetDvarInt( get_weaponstat_dvar_name( "careerweapons", weapon_name, "use_time" ) ) );
	set_weapon_stat( weapon_name, "kills", 0, GetDvarInt( get_weaponstat_dvar_name( "careerweapons", weapon_name, "kills" ) ) );
	set_weapon_stat( weapon_name, "hits", 0, GetDvarInt( get_weaponstat_dvar_name( "careerweapons", weapon_name, "hits" ) ) );

	
	if( !IsDefined( self._stats["careerweapons"]["weapon_list"] ) )
	{
		self._stats["careerweapons"]["weapon_list"] = [];
	}

	size = self._stats["careerweapons"]["weapon_list"].size;
	self._stats["careerweapons"]["weapon_list"][size] = weapon_name;
}

set_weapon_stat( weapon_name, stat_name, value, career_value )
{
	if( !IsDefined( self._stats["levelweapons"] ) )
	{
		AssertMsg( "self._stats[\"levelweapons\"] is UNDEFINED!" );
		return -1;
	}

	if( !IsDefined( self._stats["careerweapons"] ) )
	{
		AssertMsg( "self._stats[\"careerweapons\"] is UNDEFINED!" );
		return -1;
	}

	if( !IsDefined( self._stats["levelweapons"][weapon_name] ) )
	{
		AssertMsg( "self._stats[\"levelweapons\"][" + weapon_name + "] is UNDEFINED!" );
		return -1;
	}

	if( !IsDefined( self._stats["careerweapons"][weapon_name] ) )
	{
		AssertMsg( "self._stats[\"careerweapons\"][" + weapon_name + "] is UNDEFINED!" );
		return -1;
	}

	if( !IsDefined( career_value ) )
	{
		career_value = 0;
	}

	self._stats["levelweapons"][weapon_name][stat_name] = value;
	self._stats["careerweapons"][weapon_name][stat_name] = career_value;

	
	store_weapon_dvar( "levelweapons", weapon_name, stat_name );
	store_weapon_dvar( "careerweapons", weapon_name, stat_name );
}

set_weapon_in_use( weapon_name )
{
	if( !check_valid_weapon( weapon_name ) )
	{
		return;
	}

	if( !IsDefined( self._stats["levelweapons"]["currentweapon"] ) )
	{
		self._stats["levelweapons"]["currentweapon"] =  weapon_name;
		self._stats["levelweapons"][weapon_name]["in_use"] = true;
		self._stats["levelweapons"][weapon_name]["start_time"] = GetTime();
	}
	else
	{
		previous_weapon = self._stats["levelweapons"]["currentweapon"];
		self._stats["levelweapons"][previous_weapon]["in_use"] = false;

		time_used = GetTime() - self._stats["levelweapons"][previous_weapon]["start_time"];
		level_time = get_weaponstat_value( "levelweapons", previous_weapon, "use_time" ) + time_used;
		career_time = get_weaponstat_value( "careerweapons", previous_weapon, "use_time" ) + time_used;
		set_weapon_stat( previous_weapon, "use_time", level_time, career_time );

		if( weapon_name != "end_level" )
		{
			self._stats["levelweapons"]["currentweapon"] =  weapon_name;
			self._stats["levelweapons"][weapon_name]["in_use"] = true;
			self._stats["levelweapons"][weapon_name]["start_time"] = GetTime();
		}
	}
}

check_valid_weapon( weapon_name )
{
	if( weapon_name == "none" )
	{
		return false;
	}

	return true;
}

get_weapon_stats( career )
{
	
	self set_weapon_in_use( "end_level" );

	weapon_list = self._stats["careerweapons"]["weapon_list"];
	level_weapon_stats = self._stats["levelweapons"];
	career_weapon_stats = self._stats["careerweapons"];

	
	favorite_level_weapon = 0;
	favorite_weapon = 0;

	level_weapon_times = [];

	for( i = 0; i < weapon_list.size; i++ )
	{
		if( level_weapon_stats[weapon_list[i]]["use_time"] > level_weapon_stats[weapon_list[favorite_level_weapon]]["use_time"] )
		{
			favorite_level_weapon = i;
		}

		if( career_weapon_stats[weapon_list[i]]["use_time"] > career_weapon_stats[weapon_list[favorite_weapon]]["use_time"] )
		{
			favorite_weapon = i;
		}
	}

	
	favorite_level_weaponname = weapon_list[favorite_level_weapon];
	favorite_weaponname = weapon_list[favorite_weapon];

	
	begin_html_table( "Weapon Stats" );

	if( IsDefined( career ) && career )
	{
		add_html_table_row( "Favorite All-Time Weapon:", favorite_weaponname );
	}
	else
	{
		add_html_table_row( "Favorite Level Weapon:", favorite_level_weaponname );
	}

	
	for( i = 0; i < weapon_list.size; i++ )
	{
		add_html_table_row( weapon_list[i], undefined, true, true );

		if( IsDefined( career ) && career )
		{
			time = career_weapon_stats[weapon_list[i]]["use_time"] * 0.001;
			add_html_table_row( "Total Time Used:", to_hours( time, true ) );
			add_html_table_row( "Hits:", get_weaponstat_value( "careerweapons", weapon_list[i], "hits" ) );

			kills = get_weaponstat_value( "careerweapons",weapon_list[i], "kills" );
			add_html_table_row( "Kills:", kills );

			if( kills > 0 && time > 0 )
			{
				add_html_table_row( "Total Kills Per Minute:", per_minute( kills, time ) );
			}
			else
			{
				add_html_table_row( "Total Kills Per Minute:", 0 );
			}
		}
		else
		{
			time = level_weapon_stats[weapon_list[i]]["use_time"] * 0.001;
			add_html_table_row( "Time Used in Level:", to_hours( time ) );
			add_html_table_row( "Hits:", get_weaponstat_value( "levelweapons", weapon_list[i], "hits" ) );

			kills = get_weaponstat_value( "levelweapons",weapon_list[i], "kills" );
			add_html_table_row( "Kills:", kills );

			if( kills > 0 && time > 0 )
			{
				add_html_table_row( "Total Kills Per Minute:", per_minute( kills, time ) );
			}
			else
			{
				add_html_table_row( "Total Kills Per Minute:", 0 );
			}
		}
	}

	end_html_table();
}


set_enemy_damage( mod, hitloc )
{
	
	if( GetDvar( "enable_stats" ) == "" )
	{
		return;
	}

	weapon_name = self GetCurrentWeapon();

	if( IsDefined( mod ) )
	{
		println( "set_enemy_damage( " + mod + " )" );
	}

	println( "set_enemy_damage( " + hitloc + " )" );

	
	if( check_hitloc( hitloc ) )
	{
		hitloc = "hitloc_" + hitloc;
		set_stat( "level", hitloc, get_stat_value( "level", hitloc ) + 1 );
		set_stat( "career", hitloc, get_stat_value( "career", hitloc ) + 1 );
	}

	
	set_stat( "level", "hits", get_stat_value( "level", "hits" ) + 1 );
	set_stat( "career", "hits", get_stat_value( "career", "hits" ) + 1 );

	set_weapon_stat( weapon_name, "hits", get_weaponstat_value( "levelweapons", weapon_name, "hits" ) + 1, get_weaponstat_value( "careerweapons", weapon_name, "hits" ) + 1 );
}

set_enemy_kill( mod, hitloc, enemy_pos )
{
	
	if( GetDvar( "enable_stats" ) == "" )
	{
		return;
	}

	weapon_name = self GetCurrentWeapon();
















	if( IsDefined( mod ) )
	{
		println( "set_enemy_kill( " + mod + " )" );


	}

	println( "set_enemy_kill( " + hitloc + " )" );

	
	if( check_hitloc( hitloc ) )
	{
		hitloc = "hitloc_" +  hitloc;
		set_stat( "level", hitloc, get_stat_value( "level", hitloc ) + 1 );
		set_stat( "career", hitloc, get_stat_value( "career", hitloc ) + 1 );
	}

	
	set_stat( "level", "hits", get_stat_value( "level", "hits" ) + 1 );
	set_stat( "career", "hits", get_stat_value( "career", "hits" ) + 1 );

	
	set_stat( "level", "kills", get_stat_value( "level", "kills" ) + 1  );
	set_stat( "career", "kills", get_stat_value( "career", "kills" ) + 1 );

	set_weapon_stat( weapon_name, "hits", get_weaponstat_value( "levelweapons", weapon_name, "hits" ) + 1, get_weaponstat_value( "careerweapons", weapon_name, "hits" ) + 1 );
	set_weapon_stat( weapon_name, "kills", get_weaponstat_value( "levelweapons", weapon_name, "kills" ) + 1, get_weaponstat_value( "careerweapons", weapon_name, "kills" ) + 1 );


	if( GetDvar( "stat_track_player" ) != "" )
	{
		self store_player_position( enemy_pos );
	}	
}




weapon_use_thread()
{
	while( 1 )
	{
		self waittill( "weapon_change" );
		self set_weapon_in_use( self GetCurrentWeapon() );
	}
}




init_stat( stat_group, stat_name, value )
{
	if( !IsDefined( self._stats[stat_group] ) )
	{
		self._stats[stat_group] = [];
	}

	self._stats[stat_group][stat_name] = [];

	
	if( stat_group == "career" )
	{	
		value = get_stat_dvarfloat( stat_group, stat_name );
	}

	if( IsDefined( value ) )
	{
		set_stat( stat_group, stat_name, value );
	}
}

set_stat( stat_group, stat_name, value )
{
	if( !IsDefined( self._stats[stat_group] ) )
	{
		AssertMsg( "self._stats[" + stat_group + "] is UNDEFINED!" );
		return -1;
	}

	if( !IsDefined( self._stats[stat_group][stat_name] ) )
	{
		AssertMsg( "self._stats[" + stat_group + "][" + stat_name + "] is UNDEFINED!" );
		return -1;
	}

	self._stats[stat_group][stat_name]["value"] = value;

	
	store_dvar( stat_group, stat_name );
}

get_stat_value( stat_group, stat_name )
{
	if( !IsDefined( self._stats[stat_group] ) )
	{
		AssertMsg( "self._stats[" + stat_group + "] is UNDEFINED!" );
		return -1;
	}

	if( !IsDefined( self._stats[stat_group][stat_name] ) )
	{
		AssertMsg( "self._stats[" + stat_group + "][" + stat_name + "] is UNDEFINED!" );
		return -1;
	}

	return self._stats[stat_group][stat_name]["value"];
}

get_weaponstat_value( stat_group, weapon_name, stat_name )
{
	if( !IsDefined( self._stats[stat_group] ) )
	{
		AssertMsg( "self._stats[" + stat_group + "] is UNDEFINED!" );
		return -1;
	}

	if( !IsDefined( self._stats[stat_group][weapon_name] ) )
	{
		AssertMsg( "self._stats[" + stat_group + "][" + weapon_name + "] is UNDEFINED!" );
		return -1;
	}

	if( !IsDefined( self._stats[stat_group][weapon_name][stat_name] ) )
	{
		AssertMsg( "self._stats[" + stat_group + "][" + weapon_name + "][" + stat_name + "] is UNDEFINED!" );
		return -1;
	}

	return self._stats[stat_group][weapon_name][stat_name];
}


check_for_dupes( array, single )
{
	for( i = 0; i < array.size; i++ )
	{
		if( array[i] == single )
		{
			return false;
		}
	}

	return true;
}


store_dvar( stat_group, stat_name )
{
	stat_dvar = get_stat_dvar_name( stat_group, stat_name );
	SetDvar( stat_dvar, get_stat_value( stat_group, stat_name ) );
}

store_weapon_dvar( stat_group, weapon_name, stat_name )
{
	stat_dvar = get_weaponstat_dvar_name( stat_group, weapon_name, stat_name );
	SetDvar( stat_dvar, get_weaponstat_value( stat_group, weapon_name, stat_name ) );
}


get_stat_dvarfloat( stat_group, stat_name )
{
	stat_dvar = get_stat_dvar_name( stat_group, stat_name );
	return GetDvarFloat( stat_dvar );
}


get_stat_dvar_name( stat_group, stat_name )
{
	return "stats_" + stat_group + "_" + stat_name;
}


get_weaponstat_dvar_name( stat_group, weapon_name, stat_name )
{
	return "stats_" + stat_group + "_" + weapon_name + "_" + stat_name;
}

to_hours( seconds, do_days )
{
	if( !IsDefined( do_days ) )
	{
		do_days = false;
	}

	hours = 0;
	minutes = 0;
	days = 0;

	if( seconds > 59 )
	{
		minutes = int( seconds / 60 );

		seconds = int( seconds * 1000 ) % ( 60 * 1000 );
		seconds = seconds * 0.001;

		if( minutes > 59 )
		{
			hours = int( minutes / 60 );
			minutes = int( minutes * 1000 ) % ( 60 * 1000 );
			minutes = minutes * 0.001;		
		}

		if( do_days )
		{
			if( hours > 23 )
			{
				days = int( hours / 24 );
				hours = int( hours * 1000 ) % ( 24 * 1000 );
				hours = hours * 0.001;		
			}
		}
	}

	if( days < 10 )
	{
		days = "0" + days;
	}

	if( hours < 10 )
	{
		hours = "0" + hours;
	}

	if( minutes < 10 )
	{
		minutes = "0" + minutes;
	}

	seconds = int( seconds );
	if( seconds < 10 )
	{
		seconds = "0" + seconds;
	}

	if( do_days )
	{
		combined = "" + days + " Days " + hours  + ":" + minutes  + ":" + seconds;
	}
	else
	{
		combined = "" + hours  + ":" + minutes  + ":" + seconds;
	}

	println( "to_hours = ", combined );

	return combined;
}


per_minute( val, time )
{
	return round_to( 60 / ( ( time ) / val ), 100 );
}


round_to( val, num ) 
{
	return int( val * num ) / num;
}

check_hitloc( hitloc )
{
	if( hitloc == "none" )
	{
		return false;
	}

	return true;
}

to_percent( val, total )
{
	if( total > 0 )
	{
		string = round_to( ( val / total) * 100, 100 );
	}
	else
	{
		string = 0;
	}
	return ( string + "%" ) ;
}




add_html_line( msg, no_br )
{
	if( !IsDefined( self._stats_output ) )
	{
		self._stats_output = [];
	}

	size = self._stats_output.size;

	if( IsDefined( no_br ) && no_br )
	{
		self._stats_output[size] = msg;
	}
	else
	{	
		self._stats_output[size] = msg + "<br>";
	}
}

add_html_bar()
{
	add_html_line( "<br><hr NOSHADE><br>", true );
}

begin_html_table( title, width )
{
	tab = "     ";

	if( !IsDefined( width ) )
	{
		width = "450";
	}

	table = "<TABLE BORDER=0 bgcolor=#8E99A3 WIDTH=\"" + width + "\" CELLPADDING=2 CELLSPACING=2>";

	add_html_line( table, true );

	if( IsDefined( title ) )
	{
		add_html_line( tab + "<TD WIDTH=300><FONT SIZE=+2><b><u>" + title + "</u></b></FONT></TD>", true );
	}
}

add_html_table_row( val1, val2, bold, underline )
{
	tab = "     ";
	if( !IsDefined( val2 ) )
	{
		add_html_line( tab + "<TD><hr NOSHADE></TD>", true );
	}

	prefix = "";
	suffix = "";

	if( IsDefineD( bold ) && bold )
	{
		prefix = "<b>";
		suffix = "</b>";
	}

	if( IsDefineD( underline ) && underline )
	{
		prefix = prefix + "<u>";
		suffix = "</u>" + suffix;
	}

	add_html_line( tab + "<TR>", true );
	add_html_line( tab + tab + "<TD>" + prefix + val1 + suffix + "</TD>", true );

	if( IsDefined( val2 ) )
	{
		add_html_line( tab + tab + "<TD>" + prefix + val2 + suffix + "</TD>", true );
	}

	add_html_line( tab + "</TR>", true );
}

end_html_table()
{
	add_html_line( "<TD><br><br></TD>", true );
	add_html_line( "</TABLE>", true );
}

write_html()
{
/#
	filename = "stats/my_stats.html";

	file = OpenFile( filename, "write" );
	assertex( file != -1, "File not writeable (maybe you should check it out): " + filename );

	tab = "     ";
	fprintln( file, "<HTML>" );
	fprintln( file, tab + "<HEAD>" );
	fprintln( file, tab + tab + "<style>" );
	fprintln( file, tab + tab + tab + "BODY" );			
	fprintln( file, tab + tab + tab + "{" );			
	fprintln( file, tab + tab + tab + tab + "background-color: 64819D;" );
	fprintln( file, tab + tab + tab + tab + "font-size: 11pt;" );
	fprintln( file, tab + tab + tab + tab + "font-family: georgia,verdana,helvetica;" );				
	fprintln( file, tab + tab + tab + "}" );
	fprintln( file, tab + tab + "</style>" );
	fprintln( file, tab + "</HEAD>" );
	fprintln( file, tab + "<BODY BGCOLOR=\"#FFFFFF\">" );

	for( i = 0; i < self._stats_output.size; i++ )
	{
		fprintln( file, tab + tab + self._stats_output[i] );
	}

	fprintln( file, tab + "</BODY>" );
	fprintln( file, "</HTML>" );

	saved = CloseFile( file );
	assertex( saved == 1, "File not saved (see above message?): " + filename );
#/
}




track_player()
{
	level.track_player_wait = 1;

	while( 1 )
	{
		store_player_position();
		wait( level.track_player_wait );
	}
}

store_player_position( dead_enemy_pos, killed_pos )
{
	if( !IsDefined( self._stats["track_player"] ) )
	{
		self._stats["track_player"] = [];
	}

	size = self._stats["track_player"].size;

	if( !IsDefined( dead_enemy_pos ) && !IsDefined( killed_pos ) )
	{
		if( size > 0 )
		{
			if( self._stats["track_player"][size-1]["position"] == self.origin )
			{
				return;
			}
			else if( DistanceSquared( self._stats["track_player"][size-1]["position"], self.origin ) < 32 * 32 )
			{
				return;
			}
		}
	}

	self._stats["track_player"][size] = [];
	self._stats["track_player"][size]["position"] = self.origin;
	self._stats["track_player"][size]["time"] = GetTime();

	if( IsDefined( dead_enemy_pos ) )
	{
		self._stats["track_player"][size]["dead_enemy_pos"] = dead_enemy_pos;
	}
	else
	{
		self._stats["track_player"][size]["dead_enemy_pos"] = undefined;
	}

	if( IsDefined( killed_pos ) )
	{
		self._stats["track_player"][size]["killed_pos"] = killed_pos;
	}
	else
	{
		self._stats["track_player"][size]["killed_pos"] = undefined;
	}
}











write_player_track()
{
/#
	filename = "stats/player_track.gsc";

	file = OpenFile( filename, "write" );
	assertex( file != -1, "File not writeable (maybe you should check it out): " + filename );

	tab = "     ";
	result_text = "maps\\_stats::add_track_player_results( ";
	fprintln( file, "main()" );
	fprintln( file, "{" );
	fprintln( file, tab + "maps\\_stats::begin_track_results();" );
	for( i = 0; i < self._stats["track_player"].size; i++ )
	{
		dead_enemy_pos = "undefined";
		killed_pos = "undefined";

		if( IsDefined( self._stats["track_player"][i]["dead_enemy_pos"] ) )
		{
			dead_enemy_pos = self._stats["track_player"][i]["dead_enemy_pos"];
		}

		if( IsDefined( self._stats["track_player"][i]["killed_pos"] ) )
		{
			killed_pos = self._stats["track_player"][i]["killed_pos"];
		}

		fprintln( file, tab + result_text + self._stats["track_player"][i]["position"] + ", " + self._stats["track_player"][i]["time"] + ", " + dead_enemy_pos + ", " + killed_pos + ");" );

	}
	fprintln( file, tab + "maps\\_stats::draw_track_results();" );
	fprintln( file, "}" );


	saved = CloseFile( file );
	assertex( saved == 1, "File not saved (see above message?): " + filename );
#/
}

begin_track_results()
{
	if( !IsDefined( level._stat_track_results ) )
	{
		level._stat_track_results = [];
	}

	size = level._stat_track_results.size;
	level._stat_track_results[size] = SpawnStruct();
}


add_track_player_results( pos, time, dead_enemy_pos, killed_pos )
{
	num = level._stat_track_results.size - 1;

	if( !IsDefined( level._stat_track_results[num].positions ) )
	{
		level._stat_track_results[num].positions = [];
	}

	size = level._stat_track_results[num].positions.size;
	level._stat_track_results[num].positions[size] = pos;

	
	level._stat_track_results[num].times[size] = time;

	
	color = ( 1, 1, 1 );
	string = ".";
	scale = 1;

	if( IsDefined( dead_enemy_pos ) )
	{
		color = ( 1, 1, 0 );
		string = "*";
		scale = 2;
	}
	else if( IsDefined( killed_pos ) )
	{
		color = ( 1, 0, 0 );
		string = "!";
		scale = 2;
	}

	
	level._stat_track_results[num].color[size] = color;
	level._stat_track_results[num].string[size] = string;
	level._stat_track_results[num].scale[size] = scale;

	
	level._stat_track_results[num].dead_enemy_pos[size] = dead_enemy_pos;	
}

draw_track_results()
{
	num = level._stat_track_results.size - 1;
	struct = level._stat_track_results[num];

	time_colors[0] = ( 1, 1, 1 );
	time_colors[1] = ( 1, 1, 0 );
	time_colors[2] = ( 1, 0, 0 );
	color = 0;
	for( i = 0; i < struct.positions.size; i++ )
	{
		if( i > 0 )
		{
			time_diff = ( struct.times[i] - struct.times[i - 1] ) * 0.001;
			if( time_diff > 10 )
			{
				struct.color[i] = ( 1, 1, 0 );
				struct.string[i] = ".camper (" + time_diff + ")";
				color = 1;

				if( time_diff > 30 )
				{
					struct.string[i] = ".1337 camper (" + time_diff + ")";
					struct.color[i] = ( 1, 0, 0 );
					color = 2;
				}
			}
		}

		if( i < struct.positions.size - 1 )
		{
			struct thread draw_track_pos( struct.positions[i], struct.string[i], struct.scale[i], struct.color[i], struct.times[i], time_colors[color], struct.positions[i + 1], struct.dead_enemy_pos[i] );
		}
		else
		{
			struct thread draw_track_pos( struct.positions[i], struct.string[i], struct.scale[i], struct.color[i], struct.times[i], time_colors[color], undefined, struct.dead_enemy_pos[i] );
		}
	}
}

draw_track_pos( position, msg, scale, color, time, time_color, position2, dead_enemy_pos, killed_pos )
{
	if( GetDvar( "tracker_time" ) == "" )
	{
		SetDvar( "tracker_time", "0" );
	}

	time = to_hours( time * 0.001 );

	if( IsDefined( position2 ) )
	{
		do_line = true;
	}
	else
	{
		do_line = false;
	}

	dead_arrows = [];
	half_way = undefined;
	if( IsDefined( dead_enemy_pos ) )
	{
		dead_enemy = true;

		alt_pos = ( position[0], position[1], dead_enemy_pos[2] );
		dist = Distance( dead_enemy_pos, alt_pos  );
		forward = VectorNormalize( dead_enemy_pos - alt_pos );
		half_way = alt_pos + vector_multiply( forward, dist * 0.5 );

		forward = AnglesToForward( VectorToAngles( dead_enemy_pos - alt_pos ) + ( 0, 160, 0 ) );
		dead_arrows[0] = vector_multiply( forward, 16 );

		forward = AnglesToForward( VectorToAngles( dead_enemy_pos - alt_pos ) + ( 0, -160, 0 ) );
		dead_arrows[1] = vector_multiply( forward, 16 );

		forward = AnglesToForward( VectorToAngles( dead_enemy_pos - alt_pos ) + ( 160, 0, 0 ) );
		dead_arrows[2] = vector_multiply( forward, 16 );

		forward = AnglesToForward( VectorToAngles( dead_enemy_pos - alt_pos ) + ( -160, 0, 0 ) );
		dead_arrows[3] = vector_multiply( forward, 16 );
	}
	else
	{
		dead_enemy = false;
	}

	max_dist = 500 * 500;
	while( 1 )
	{
		player_distsqrd = DistanceSquared( level.player.origin, position );

		pos_dist = ( max_dist * 5 - player_distsqrd ) / ( max_dist * 5 );
		if( pos_dist > 0 )
		{
			print3d( position, msg, color, 1, scale );
		}

		if( GetDvarInt( "tracker_time" ) > 0 ) 
		{
			alpha = ( max_dist - player_distsqrd ) / max_dist;
			if( alpha > 0.1 )
			{
				print3d( position + ( 0, 0, 32 ), time, time_color, alpha, 1 );
			}
		}

		if( do_line )
		{
			line_dist = ( max_dist * 2 - player_distsqrd ) / ( max_dist * 2 );
			if( line_dist > 0.1 )
			{
				line( position, position2, ( 0, 1, 0 ) );
			}
		}

		if( dead_enemy )
		{
			kill_color = ( 1, 1, 0 );
			line_dist = ( max_dist * 2 - player_distsqrd ) / ( max_dist * 2 );
			if( line_dist > 0.1 )
			{
				line( position + ( 0, 0, 60 ), dead_enemy_pos + ( 0, 0, 60 ), kill_color );
				line( position + ( 0, 0, 60 ), position, kill_color );

				for( i = 0; i < dead_arrows.size; i++ )
				{
					line( dead_enemy_pos + dead_arrows[i] + ( 0, 0, 60 ), dead_enemy_pos + ( 0, 0, 60 ), kill_color );
					line( half_way + dead_arrows[i] + ( 0, 0, 60 ), half_way + ( 0, 0, 60 ), kill_color );
				}
			}
		}

		wait( 0.05 );
	}
}