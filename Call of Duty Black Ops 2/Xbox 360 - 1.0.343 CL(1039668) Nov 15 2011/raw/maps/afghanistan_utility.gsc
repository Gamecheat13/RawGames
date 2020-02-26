#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_horse;

skipto_setup()
{
	// this is for the sandparticles in the valley you look through during the horse_charge event
	//	binocular moment.  They are an exploder so we can turn them off during this moment
	exploder( 1000 );	
	
	skipto = level.skipto_point;
	if (skipto == "intro")
		return;
	
	set_objective( level.OBJ_AFGHAN_BC1, undefined, "done");
	set_objective( level.OBJ_AFGHAN_BC2, undefined, "done");
	
	if(skipto == "horse_intro")
		return;
	set_objective( level.OBJ_AFGHAN_BC3, undefined, "done");
	
	turn_down_fog();
	
	if(skipto == "rebel_base_intro")
		return;
	
	flag_set( "first_rebel_base_visit" );

	if (skipto == "firehorse")
		return;
	
	if (skipto == "wave_1")
		return;
	
	if (skipto == "wave_2")
		return;
	
	if (skipto == "wave_3")
		return;
	
	flag_set("wave3_done");
	
	if (skipto == "blocking_done")
		return;
	
	flag_set( "blocking_done" );
	
	if(skipto == "horse_charge")
		return;
	
	flag_set("pushed_off_horse");
	
	if(skipto == "krav_tank")
		return;
	
	flag_set("second_base_visit");
	
	if(skipto == "krav_captured")
		return;
	
	flag_set("interrogation_started");
	
	if(skipto == "interrogation")
		return;
	
	flag_set("numbers_struggle_completed");
	
	if(skipto == "beat_down")
		return;
	
	flag_set( "deserted_sequence" );
	
	if(skipto == "deserted")
		return;
}


hero_setup( spawner_name )
{	
	hero = simple_spawn_single( spawner_name );
	hero.name = spawner_name;
	hero thread make_hero();	
}

player_lock_in_position( origin, angles )
{
	link_to_ent = spawn("script_model", origin);
	link_to_ent.angles = angles;
	link_to_ent setmodel("tag_origin");
	//self playerlinktodelta(link_to_ent, "tag_origin", 0, 0, 0, 0, 0);
	self playerlinktoabsolute(link_to_ent, "tag_origin");
	
	self waittill("unlink_from_ent");
	self unlink();
	link_to_ent delete();
}

get_player_horse()
{
	return level.player.viewlockedentity;
}

spawn_rideable_horse( horse_targetname )
{
	horse = spawn_vehicle_from_targetname(horse_targetname);
	horse MakeVehicleUsable();
	return horse;
}

setup_rider( vh_riders_horse )
{
	self.vh_horse = vh_riders_horse;
	self.deathFunction = ::rider_died_make_horse_rideable;
}

rider_died_make_horse_rideable()
{
	self.vh_horse MakeVehicleUsable();
}


make_horse_usable()
{
	self endon( "death" );
	
	wait 1;
	
	ai_rider = self get_driver();
	
	if( IsDefined( ai_rider ) )
	{
		ai_rider waittill( "death" );
		
		self MakeVehicleUsable();
	}
}


horse_has_rider()
{
	self endon( "death" );
	
	while( !IsDefined( self get_driver() ) )
	{
		wait 1;
	}
	
	self notify( "got_rider" );
	
	self SetVehGoalPos( self.origin, 1 );
}


get_ai_count( str_faction )
{
	if ( str_faction == "allies" )
	{
		a_ai_guys = getaiarray( "allies" );
	}
	
	else if ( str_faction == "axis" )
	{
		a_ai_guys = getaiarray( "axis" );
	}
	
	else if ( str_faction == "neutral" )
	{
		a_ai_guys = getaiarray( "neutral" );
	}
	
	else if ( str_faction == "all" )
	{
		a_ai_guys = getaiarray( "all" );
	}
	
	return a_ai_guys.size;
}

lerp_dof_over_time( time )
{
	const Default_Near_Start = 0;
	const Default_Near_End = 1;
	const Default_Far_Start = 8000;
	const Default_Far_End = 10000;
	const Default_Near_Blur = 6;
	const Default_Far_Blur = 0;
	
	const Near_Start = 822;
	const Near_End = 823;
	const Far_Start = 886;
	const Far_End = 887;
	const Near_Blur = 4;
	const Far_Blur = 3.9;
	
	incs = int( time/.05 );
	
	incNearStart = ( Default_Near_Start - Near_Start ) / incs;
	incNearEnd = ( Default_Near_End - Near_End ) / incs;
	incFarStart = ( Default_Far_Start - Far_Start ) / incs;
	incFarEnd = ( Default_Far_End - Far_End ) / incs;
	incNearBlur = ( Default_Near_Blur - Near_Blur ) / incs;
	incFarBlur = ( Default_Far_Blur - Far_Blur ) / incs;
	
	current_NearStart = Near_Start;
	current_NearEnd = Near_End;
	current_FarStart = Far_Start;
	current_FarEnd = Far_End;
	current_NearBlur = Near_Blur;
	current_FarBlur = Far_Blur;
	
	for ( i = 0; i < incs; i++ )
	{
		self SetDepthOfField( current_NearStart, current_NearEnd, current_FarStart, current_FarEnd, current_NearBlur, current_FarBlur );	
		
		current_NearStart += incNearStart;
		current_NearEnd += incNearEnd;
		current_FarStart += incFarStart;
		current_FarEnd += incFarEnd;
		current_NearBlur += incNearBlur;
		current_FarBlur += incFarBlur;
		
		wait .05;
	}
}


cleanup_bp_ai()
{
	guys = getaiarray( "allies", "axis" );
	
	a_guys = array_exclude( guys, level.zhao );
	
	foreach( guy in a_guys )
	{
		if ( !IsDefined( guy.crew ) )
		{
			guy delete();
		}
	}	
}


cleanup_arena()
{
	flag_set( "stop_arena_explosions" );	
	spawn_manager_disable( "manager_troops_exit" );
	spawn_manager_disable( "manager_hip3_troops" );
	spawn_manager_disable( "manager_hip4_troops" );
	wait 0.1;
	guys = getaiarray( "allies", "axis" );
	a_guys = array_exclude( guys, level.zhao );
	foreach( guy in a_guys )
	{
		if ( IsDefined( guy.arena_guy ) )
		{
			guy delete();
		}
	}
}


respawn_arena()
{
	level thread maps\afghanistan_firehorse::arena_explosion_fx();
	
	spawn_manager_enable( "manager_troops_exit" );
	
	flag_clear( "stop_arena_explosions" );
	
	spawn_manager_enable( "manager_hip3_troops" );
	spawn_manager_enable( "manager_hip4_troops" );
	
	level thread maps\afghanistan_firehorse::ambience_manager();
}


spawn_bp2_cache( str_weapon )
{
	if ( str_weapon == "rpg" )
	{
		s_rpg_pos = getstruct( "rpg_bp2_pos1", "targetname" );
		
		if ( level.b_rpg_bp2 )
		{
			s_rpg_pos = getstruct( "rpg_bp2_pos2", "targetname" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_bp2_cache( str_weapon );
	}
	
	if ( str_weapon == "stinger" )
	{
		s_stinger_pos = getstruct( "stinger_bp2_pos1", "targetname" );
		
		if ( level.b_stinger_bp2 )
		{
			s_stinger_pos = getstruct( "stinger_bp2_pos2", "targetname" );
		}
		
		e_stinger = Spawn( "weapon_stinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_bp2_cache( str_weapon );
	}
}


watch_bp2_cache( str_weapon )
{
	level endon( "cache_destroyed_bp2" );
	
	self waittill( "trigger", player, theWeapon );
	
	if ( str_weapon == "rpg" )
	{
		level.player GiveMaxAmmo( "rpg_player_sp" );
	}
	
	else if ( str_weapon == "stinger" )
	{
		level.player GiveMaxAmmo( "stinger_sp" );
	}
	
	if ( !level.b_rpg_bp2 )
	{
		level.b_rpg_bp2 = true;
	}
	
	else
	{
		level.b_rpg_bp2 = false;
	}
	
	if ( !level.b_stinger_bp2 )
	{
		level.b_stinger_bp2 = true;
	}
	
	else
	{
		level.b_stinger_bp2 = false;
	}
		
	self thread spawn_bp2_cache( str_weapon );
}


spawn_weapon_cache( str_weapon )
{
	if ( str_weapon == "rpg" )
	{
		s_rpg_pos = getstruct( "rpg_pos1", "targetname" );		
		
		if ( level.b_rpg_shift )
		{
			s_rpg_pos = getstruct( "rpg_pos2", "targetname" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_pickup( str_weapon );
	}
	
	else if ( str_weapon == "stinger" )
	{
		s_stinger_pos = getstruct( "stinger_pos1", "targetname" );		
		
		if ( level.b_stinger_shift )
		{
			s_stinger_pos = getstruct( "stinger_pos2", "targetname" );
		}
		
		e_stinger = Spawn( "weapon_stinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_pickup( str_weapon );
	}
}


watch_weapon_pickup( str_weapon )
{
	level endon( "cache_destroyed_bp1" );
	
	self waittill( "trigger", player, theWeapon );
	
	if ( str_weapon == "rpg" )
	{
		level.player GiveMaxAmmo( "rpg_player_sp" );
	}
	
	if ( str_weapon == "stinger" )
	{
		level.player GiveMaxAmmo( "stinger_sp" );
	}
	
	if ( !level.b_rpg_shift )
	{
		level.b_rpg_shift = true;
	}
	
	else
	{
		level.b_rpg_shift = false;
	}
	
	if ( !level.b_stinger_shift )
	{
		level.b_stinger_shift = true;
	}
	
	else
	{
		level.b_stinger_shift = false;
	}
		
	self thread spawn_weapon_cache( str_weapon );
}


spawn_bp3_cache( str_weapon )
{
	if ( str_weapon == "rpg" )
	{
		s_rpg_pos = getstruct( "rpg_bp3_pos1", "targetname" );
		
		if ( level.b_rpg_bp3 )
		{
			s_rpg_pos = getstruct( "rpg_bp3_pos2", "targetname" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_bp3_cache( str_weapon );
	}
	
	if ( str_weapon == "stinger" )
	{
		s_stinger_pos = getstruct( "stinger_bp3_pos1", "targetname" );
		
		if ( level.b_stinger_bp3 )
		{
			s_stinger_pos = getstruct( "stinger_bp3_pos2", "targetname" );
		}
		
		e_stinger = Spawn( "weapon_stinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_bp3_cache( str_weapon );
	}
}


watch_bp3_cache( str_weapon )
{
	level endon( "cache_destroyed_bp3" );
	
	self waittill( "trigger", player, theWeapon );
	
	if ( str_weapon == "rpg" )
	{
		level.player GiveMaxAmmo( "rpg_player_sp" );
	}
	
	else if ( str_weapon == "stinger" )
	{
		level.player GiveMaxAmmo( "stinger_sp" );
	}
	
	if ( !level.b_rpg_bp3 )
	{
		level.b_rpg_bp3 = true;
	}
	
	else
	{
		level.b_rpg_bp3 = false;
	}
	
	if ( !level.b_stinger_bp3 )
	{
		level.b_stinger_bp3 = true;
	}
	
	else
	{
		level.b_stinger_bp3 = false;
	}
		
	self thread spawn_bp3_cache( str_weapon );
}


spawn_weapon_cache1( str_weapon )
{
	if ( str_weapon == "rpg" )
	{
		s_rpg_pos = getstruct( "rpg_cache1_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache1 )
		{
			s_rpg_pos = getstruct( "rpg_cache1_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache1( str_weapon );
	}
	
	if ( str_weapon == "stinger" )
	{
		s_stinger_pos = getstruct( "stinger_cache1_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache1 )
		{
			s_stinger_pos = getstruct( "stinger_cache1_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_stinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache1( str_weapon );
	}
}


watch_weapon_cache1( str_weapon )
{
	level endon( "cache1_destroyed" );
	
	self waittill( "trigger", player, theWeapon );
	
	if ( str_weapon == "rpg" )
	{
		level.player GiveMaxAmmo( "rpg_player_sp" );
	}
	
	else if ( str_weapon == "stinger" )
	{
		level.player GiveMaxAmmo( "stinger_sp" );
	}
	
	if ( !level.b_rpg_cache1 )
	{
		level.b_rpg_cache1 = true;
	}
	
	else
	{
		level.b_rpg_cache1 = false;
	}
	
	if ( !level.b_stinger_cache1 )
	{
		level.b_stinger_cache1 = true;
	}
	
	else
	{
		level.b_stinger_cache1 = false;
	}
		
	self thread spawn_weapon_cache1( str_weapon );
}


spawn_weapon_cache2( str_weapon )
{
	if ( str_weapon == "rpg" )
	{
		s_rpg_pos = getstruct( "rpg_cache2_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache2 )
		{
			s_rpg_pos = getstruct( "rpg_cache2_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache2( str_weapon );
	}
	
	if ( str_weapon == "stinger" )
	{
		s_stinger_pos = getstruct( "stinger_cache2_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache2 )
		{
			s_stinger_pos = getstruct( "stinger_cache2_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_stinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache2( str_weapon );
	}
}


watch_weapon_cache2( str_weapon )
{
	level endon( "cache2_destroyed" );
	
	self waittill( "trigger", player, theWeapon );
	
	if ( str_weapon == "rpg" )
	{
		level.player GiveMaxAmmo( "rpg_player_sp" );
	}
	
	else if ( str_weapon == "stinger" )
	{
		level.player GiveMaxAmmo( "stinger_sp" );
	}
	
	if ( !level.b_rpg_cache2 )
	{
		level.b_rpg_cache2 = true;
	}
	
	else
	{
		level.b_rpg_cache2 = false;
	}
	
	if ( !level.b_stinger_cache2 )
	{
		level.b_stinger_cache2 = true;
	}
	
	else
	{
		level.b_stinger_cache2 = false;
	}
		
	self thread spawn_weapon_cache2( str_weapon );
}


spawn_weapon_cache3( str_weapon )
{
	if ( str_weapon == "rpg" )
	{
		s_rpg_pos = getstruct( "rpg_cache3_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache3 )
		{
			s_rpg_pos = getstruct( "rpg_cache3_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache3( str_weapon );
	}
	
	if ( str_weapon == "stinger" )
	{
		s_stinger_pos = getstruct( "stinger_cache3_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache3 )
		{
			s_stinger_pos = getstruct( "stinger_cache3_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_stinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache3( str_weapon );
	}
}


watch_weapon_cache3( str_weapon )
{
	level endon( "cache3_destroyed" );
	
	self waittill( "trigger", player, theWeapon );
	
	if ( str_weapon == "rpg" )
	{
		level.player GiveMaxAmmo( "rpg_player_sp" );
	}
	
	else if ( str_weapon == "stinger" )
	{
		level.player GiveMaxAmmo( "stinger_sp" );
	}
	
	if ( !level.b_rpg_cache3 )
	{
		level.b_rpg_cache3 = true;
	}
	
	else
	{
		level.b_rpg_cache3 = false;
	}
	
	if ( !level.b_stinger_cache3 )
	{
		level.b_stinger_cache3 = true;
	}
	
	else
	{
		level.b_stinger_cache3 = false;
	}
		
	self thread spawn_weapon_cache3( str_weapon );
}


spawn_weapon_cache4( str_weapon )
{
	if ( str_weapon == "rpg" )
	{
		s_rpg_pos = getstruct( "rpg_cache4_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache4 )
		{
			s_rpg_pos = getstruct( "rpg_cache4_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache4( str_weapon );
	}
	
	if ( str_weapon == "stinger" )
	{
		s_stinger_pos = getstruct( "stinger_cache4_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache4 )
		{
			s_stinger_pos = getstruct( "stinger_cache4_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_stinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache4( str_weapon );
	}
}


watch_weapon_cache4( str_weapon )
{
	level endon( "cache4_destroyed" );
	
	self waittill( "trigger", player, theWeapon );
	
	if ( str_weapon == "rpg" )
	{
		level.player GiveMaxAmmo( "rpg_player_sp" );
	}
	
	else if ( str_weapon == "stinger" )
	{
		level.player GiveMaxAmmo( "stinger_sp" );
	}
	
	if ( !level.b_rpg_cache4 )
	{
		level.b_rpg_cache4 = true;
	}
	
	else
	{
		level.b_rpg_cache4 = false;
	}
	
	if ( !level.b_stinger_cache4 )
	{
		level.b_stinger_cache4 = true;
	}
	
	else
	{
		level.b_stinger_cache4 = false;
	}
		
	self thread spawn_weapon_cache4( str_weapon );
}


spawn_weapon_cache5( str_weapon )
{
	if ( str_weapon == "rpg" )
	{
		s_rpg_pos = getstruct( "rpg_cache5_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache5 )
		{
			s_rpg_pos = getstruct( "rpg_cache5_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache5( str_weapon );
	}
	
	if ( str_weapon == "stinger" )
	{
		s_stinger_pos = getstruct( "stinger_cache5_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache5 )
		{
			s_stinger_pos = getstruct( "stinger_cache5_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_stinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache5( str_weapon );
	}
}


watch_weapon_cache5( str_weapon )
{
	level endon( "cache5_destroyed" );
	
	self waittill( "trigger", player, theWeapon );
	
	if ( str_weapon == "rpg" )
	{
		level.player GiveMaxAmmo( "rpg_player_sp" );
	}
	
	else if ( str_weapon == "stinger" )
	{
		level.player GiveMaxAmmo( "stinger_sp" );
	}
	
	if ( !level.b_rpg_cache5 )
	{
		level.b_rpg_cache5 = true;
	}
	
	else
	{
		level.b_rpg_cache5 = false;
	}
	
	if ( !level.b_stinger_cache5 )
	{
		level.b_stinger_cache5 = true;
	}
	
	else
	{
		level.b_stinger_cache5 = false;
	}
		
	self thread spawn_weapon_cache5( str_weapon );
}


spawn_weapon_cache6( str_weapon )
{
	if ( str_weapon == "rpg" )
	{
		s_rpg_pos = getstruct( "rpg_cache6_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache6 )
		{
			s_rpg_pos = getstruct( "rpg_cache6_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache6( str_weapon );
	}
	
	if ( str_weapon == "stinger" )
	{
		s_stinger_pos = getstruct( "stinger_cache6_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache6 )
		{
			s_stinger_pos = getstruct( "stinger_cache6_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_stinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache6( str_weapon );
	}
}


watch_weapon_cache6( str_weapon )
{
	level endon( "cache6_destroyed" );
	
	self waittill( "trigger", player, theWeapon );
	
	if ( str_weapon == "rpg" )
	{
		level.player GiveMaxAmmo( "rpg_player_sp" );
	}
	
	else if ( str_weapon == "stinger" )
	{
		level.player GiveMaxAmmo( "stinger_sp" );
	}
	
	if ( !level.b_rpg_cache6 )
	{
		level.b_rpg_cache6 = true;
	}
	
	else
	{
		level.b_rpg_cache6 = false;
	}
	
	if ( !level.b_stinger_cache6 )
	{
		level.b_stinger_cache6 = true;
	}
	
	else
	{
		level.b_stinger_cache6 = false;
	}
		
	self thread spawn_weapon_cache6( str_weapon );
}


spawn_weapon_cache7( str_weapon )
{
	if ( str_weapon == "rpg" )
	{
		s_rpg_pos = getstruct( "rpg_cache7_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache7 )
		{
			s_rpg_pos = getstruct( "rpg_cache7_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache7( str_weapon );
	}
	
	if ( str_weapon == "stinger" )
	{
		s_stinger_pos = getstruct( "stinger_cache7_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache7 )
		{
			s_stinger_pos = getstruct( "stinger_cache7_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_stinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache7( str_weapon );
	}
}


watch_weapon_cache7( str_weapon )
{
	level endon( "cache7_destroyed" );
	
	self waittill( "trigger", player, theWeapon );
	
	if ( str_weapon == "rpg" )
	{
		level.player GiveMaxAmmo( "rpg_player_sp" );
	}
	
	else if ( str_weapon == "stinger" )
	{
		level.player GiveMaxAmmo( "stinger_sp" );
	}
	
	if ( !level.b_rpg_cache7 )
	{
		level.b_rpg_cache7 = true;
	}
	
	else
	{
		level.b_rpg_cache7 = false;
	}
	
	if ( !level.b_stinger_cache7 )
	{
		level.b_stinger_cache7 = true;
	}
	
	else
	{
		level.b_stinger_cache7 = false;
	}
		
	self thread spawn_weapon_cache7( str_weapon );
}


init_crew_emplacement()
{
	a_crew1_dest = GetEntArray( "BP1_crew_destroyed", "targetname" );
	a_crew2_dest = GetEntArray( "BP2_crew_destroyed", "targetname" );
	a_crew3_dest = GetEntArray( "BP3_crew_destroyed", "targetname" );
	
	foreach( crew1_dest in a_crew1_dest )
	{
		crew1_dest Hide();
	}
	
	foreach( crew2_dest in a_crew2_dest )
	{
		crew2_dest Hide();
	}
	
	foreach( crew3_dest in a_crew3_dest )
	{
		crew3_dest Hide();
	}
}


init_weapon_cache()
{
	level.b_rpg_bp2 = false;
	level.b_stinger_bp2 = false;
	level.b_rpg_bp3 = false;
	level.b_stinger_bp3 = false;
	level.b_rpg_shift = false;
	level.b_stinger_shift = false;
	level.b_rpg_cache1 = false;
	level.b_stinger_cache1 = false;
	level.b_rpg_cache2 = false;
	level.b_stinger_cache2 = false;
	level.b_rpg_cache3 = false;
	level.b_stinger_cache3 = false;
	level.b_rpg_cache4 = false;
	level.b_stinger_cache4 = false;
	level.b_rpg_cache5 = false;
	level.b_stinger_cache5 = false;
	level.b_rpg_cache6 = false;
	level.b_stinger_cache6 = false;
	level.b_rpg_cache7 = false;
	level.b_stinger_cache7 = false;
	
	level thread spawn_weapon_cache( "rpg" );
	level thread spawn_weapon_cache( "stinger" );
	level thread spawn_bp2_cache( "rpg" );
	level thread spawn_bp2_cache( "stinger" );
	level thread spawn_bp3_cache( "rpg" );
	level thread spawn_bp3_cache( "stinger" );
	level thread spawn_weapon_cache1( "rpg" );
	level thread spawn_weapon_cache1( "stinger" );
	level thread spawn_weapon_cache2( "rpg" );
	level thread spawn_weapon_cache2( "stinger" );
	level thread spawn_weapon_cache3( "rpg" );
	level thread spawn_weapon_cache3( "stinger" );
	level thread spawn_weapon_cache4( "rpg" );
	level thread spawn_weapon_cache4( "stinger" );
	level thread spawn_weapon_cache5( "rpg" );
	level thread spawn_weapon_cache5( "stinger" );
	level thread spawn_weapon_cache6( "rpg" );
	level thread spawn_weapon_cache6( "stinger" );
	level thread spawn_weapon_cache7( "rpg" );
	level thread spawn_weapon_cache7( "stinger" );
	
	cache1_dmg = GetEnt( "ammo_cache_arena_1_damaged", "targetname" );
	cache1_dest = GetEnt( "ammo_cache_arena_1_destroyed", "targetname" );
	cache2_dmg = GetEnt( "ammo_cache_arena_2_damaged", "targetname" );
	cache2_dest = GetEnt( "ammo_cache_arena_2_destroyed", "targetname" );
	cache3_dmg = GetEnt( "ammo_cache_arena_3_damaged", "targetname" );
	cache3_dest = GetEnt( "ammo_cache_arena_3_destroyed", "targetname" );
	cache4_dmg = GetEnt( "ammo_cache_arena_4_damaged", "targetname" );
	cache4_dest = GetEnt( "ammo_cache_arena_4_destroyed", "targetname" );
	cache5_dmg = GetEnt( "ammo_cache_arena_5_damaged", "targetname" );
	cache5_dest = GetEnt( "ammo_cache_arena_5_destroyed", "targetname" );
	cache6_dmg = GetEnt( "ammo_cache_arena_6_damaged", "targetname" );
	cache6_dest = GetEnt( "ammo_cache_arena_6_destroyed", "targetname" );
	cache7_dmg = GetEnt( "ammo_cache_arena_7_damaged", "targetname" );
	cache7_dest = GetEnt( "ammo_cache_arena_7_destroyed", "targetname" );
	cache_bp1_dmg = GetEnt( "ammo_cache_BP1_damaged", "targetname" );
	cache_bp1_dest = GetEnt( "ammo_cache_BP1_destroyed", "targetname" );
	cache_bp2_dmg = GetEnt( "ammo_cache_BP2_damaged", "targetname" );
	cache_bp2_dest = GetEnt( "ammo_cache_BP2_destroyed", "targetname" );
	cache_bp3_dmg = GetEnt( "ammo_cache_BP3_damaged", "targetname" );
	cache_bp3_dest = GetEnt( "ammo_cache_BP3_destroyed", "targetname" );
	
	cache1_dmg Hide();
	cache1_dest Hide();
	cache2_dmg Hide();
	cache2_dest Hide();
	cache3_dmg Hide();
	cache3_dest Hide();
	cache4_dmg Hide();
	cache4_dest Hide();
	cache5_dmg Hide();
	cache5_dest Hide();
	cache6_dmg Hide();
	cache6_dest Hide();
	cache7_dmg Hide();
	cache7_dest Hide();
	cache_bp1_dmg Hide();
	cache_bp1_dest Hide();
	cache_bp2_dmg Hide();
	cache_bp2_dest Hide();
	cache_bp3_dmg Hide();
	cache_bp3_dest Hide();
}


hind_fireat_target( e_target )
{
	n_burst = RandomIntRange( 12, 25 );
	
	for ( i = 0; i < n_burst; i++ )
	{
		n_offset_x = RandomIntRange( -64, 64 );
		n_offset_y = RandomIntRange( -24, 24 );
		n_offset_z = RandomIntRange( -24, 84 );
		
		if ( IsDefined( e_target ) )
		{
			v_target = ( n_offset_x, n_offset_y, n_offset_z ) + e_target.origin;
			
			MagicBullet( "btr60_heavy_machinegun", self GetTagOrigin( "tag_barrel1" ) + ( 0, 0, -50 ), v_target );
		}
			
		wait 0.05;
	}
	
	if ( IsDefined( e_target ) )
	{
		MagicBullet( "huey_rockets", self gettagorigin( "tag_missile_left" ) + ( 0, 0, -80 ), e_target.origin );
		MagicBullet( "huey_rockets", self gettagorigin( "tag_missile_right" ) + ( 0, 0, -80 ), e_target.origin );
	}
}


vehicle_acquire_target()
{
	//TODO - check distance to target
	
	a_enemies = getaiarray( "allies" );
	
	e_target = level.player;
		
	if ( cointoss() )
	{
		if ( a_enemies.size )
		{
			ai_muj = a_enemies[ RandomInt( a_enemies.size ) ];
		
			if ( IsDefined( ai_muj ) )
			{
				e_target = ai_muj;
			}
		}
		
		else
		{
			e_target = level.player;
		}
	}
	
	else
	{
		e_target = level.player;
	}
	
	return ( e_target );
}


vehicle_attack_target()
{
	self endon( "death" );
	
	e_target = vehicle_acquire_target();
	
	self SetLookAtEnt( e_target );
		
	wait 3;
		
	self hind_fireat_target( e_target );
		
	self ClearLookAtEnt();
}


hind_strafe()
{
	self endon( "death" );
	self endon( "stop_strafe" );
	
	self thread hind_rocket_strafe();
	
	while( 1 )
	{
		v_target = self.origin + ( 2000, 0, -500 );
			
		MagicBullet( "btr60_heavy_machinegun", self GetTagOrigin( "tag_barrel1" ) + ( 0, 0, -70 ), v_target );
			
		wait 0.05;
	}
}


hind_rocket_strafe()
{
	self endon( "death" );
	self endon( "stop_strafe" );
	
	while( 1 )
	{
		v_target = self.origin + ( 2000, 0, -500 );
			
		MagicBullet( "huey_rockets", self gettagorigin( "tag_missile_left" ) + ( 0, 0, -100 ), v_target + ( 0, 150, 0 ) );
		MagicBullet( "huey_rockets", self gettagorigin( "tag_missile_right" ) + ( 0, 0, -100 ), v_target + ( 0, -150, 0 ) );
			
		wait 0.5;
	}
}


hind_attack_indefinitely()
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	while( 1 )
	{
		e_target = vehicle_acquire_target();
		
		if ( IsDefined( e_target ) )
		{
			self SetLookAtEnt( e_target );
		}
		
		wait 3;
		
		if ( IsDefined( e_target ) )
		{		
			self hind_fireat_target( e_target );
		}
		
		self ClearLookAtEnt();
	}	
}


hind_stop_attack_aftertime( n_time )
{
	wait n_time;
	
	self notify( "stop_attack" );
}


hind_attack_think( n_range )
{
	self endon( "stop_attack" );
	
	if ( ( Distance2D( self.origin, level.player.origin ) < n_range ) )
	{
		while( Distance2D( self.origin, level.player.origin ) < n_range )
		{
			self hind_attack_indefinitely();
			wait 3;	
		}
	}	
}


hind_baseattack()
{
	self endon( "death" );
	
	e_base_target = spawn_model( "tag_origin", ( 15104, -10100, 36 ), ( 0, 0, 0 ) );
	
	self setLookAtEnt( e_base_target );
	
	wait 3;
	
	while( 1 )
	{
		MagicBullet( "huey_rockets", self gettagorigin( "tag_missile_left" ) + ( 0, 0, -80 ), e_base_target.origin );
		MagicBullet( "huey_rockets", self gettagorigin( "tag_missile_right" ) + ( 0, 0, -80 ), e_base_target.origin );
		iprintlnbold( "THE BASE IS UNDER ATTACK" );
		wait RandomIntRange( 3, 6 );
	}
	
	//missionfailedwrapper( &"AFGHANISTAN_PROTECT_FAILED" );
}


tank_targetting()
{
	self endon( "death" );
	self endon( "attack_cache" );
	self endon( "tank_stop_attack" );
	
	while ( 1 )
	{
		a_ai_allies = getaiarray( "allies" );
		
		self SetTargetEntity( level.player );
		
		if ( cointoss() )
		{
			ai_target = a_ai_allies[ RandomIntRange( 0, a_ai_allies.size ) ];
			
			if ( IsAlive( ai_target ) )
			{
				self SetTargetEntity( ai_target );
			}
			
			else
			{
				self SetTargetEntity( level.player );
			}
		}
		
		self FireWeapon();
		
		wait RandomFloatRange( 2.5, 4.0 );
	}
}


tank_baseattack()
{
	self endon( "death" );
	
	e_base_target = spawn_model( "tag_origin", ( 15104, -10100, 36 ), ( 0, 0, 0 ) );
	
	self SetTargetEntity( e_base_target );
	
	self waittill( "turret_on_target" );
	
	wait 3;
	
	while( 1 )
	{
		self FireWeapon();
		iprintlnbold( "THE BASE IS UNDER ATTACK" );
		wait RandomIntRange( 3, 6 );
	}
	
	//missionfailedwrapper( &"AFGHANISTAN_PROTECT_FAILED" );
}


delete_corpse_bp1()
{
	flag_wait( "wave2_started" );	
	
	if ( IsDefined( self ) )
	{
		self delete();
	}
}


delete_corpse_wave2()
{
	flag_wait( "wave3_started" );
	
	if ( IsDefined( self ) )
	{
		self delete();
	}
}


delete_corpse_wave3()
{
	flag_wait( "wave4_started" );
	
	if ( IsDefined( self ) )
	{
		self delete();
	}
}


delete_corpse_arena()
{
	flag_wait( "blocking_done" );
	
	if ( IsDefined( self ) )
	{
		self delete();
	}
}


set_dropoff_flag_ondeath( str_flag )
{
	self waittill( "death" );
	flag_set( str_flag );
}


runover_by_horse_callback( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime )
{
	if ( attacker == level.player && sMeansOfDeath == "MOD_CRUSH" )
	{
		level.player PlayRumbleOnEntity( "damage_heavy" );
		//iprintlnbold( "horse kill" );
	}
	
	return( attacker );
}


turn_down_fog()
{
	const start_dist = 620.795;
	const half_dist = 17173.1;
	const half_height = 2309.3;
	const base_height = -144.597;
	const fog_r = 0.937255;
	const fog_g = 0.984314;
	const fog_b = 1;
	const fog_scale = 16.4713;
	const sun_col_r = 0.894118;
	const sun_col_g = 0.996078;
	const sun_col_b = 1;
	const sun_dir_x = 0.262877;
	const sun_dir_y = 0.800647;
	const sun_dir_z = 0.538386;
	const sun_start_ang = 0;
	const sun_stop_ang = 140.854;
	const time = 0;
	const max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
}

map_setup()
{
	level.player.is_at_base = false;
	level.player.second_camera = getent("player_map_tele", "targetname");
	level setup_map_logic();
	level thread maps\_unit_command::load();
	level thread maps\_unit_command::setup_tank();
	CreateStreamerHint(level.player.second_camera.origin, 1);
	level.player.map_input_off = false;
	level.player.map_button_off = false;
	level.player.tank_button_off = false;
}

handle_map_controls()
{
	flag_wait("first_rebel_base_visit");
	
	if(!isDefined(level.player.is_at_base))
	{
		map_setup();
	}
	
	while(1)
	{
		if(level.player ActionSlotFourButtonPressed())
		{
			map_fade_out();
			map_room_teleport();
			map_fade_in();
		}
		
		wait 0.05;
	}
}


map_fade_out()
{
	if ( !IsDefined( level.fade_screen.hud ) )
	{
		level.fade_screen.hud = NewHudElem();
	}
	
	level.fade_screen.hud.x 					= level.fade_screen.x; 
	level.fade_screen.hud.y 					= level.fade_screen.y; 
	level.fade_screen.hud.horzAlign 	= level.fade_screen.horzAlign; 
	level.fade_screen.hud.vertAlign 	= level.fade_screen.vertAlign; 
	level.fade_screen.hud.foreground 	= level.fade_screen.foreground;
	level.fade_screen.hud.alpha 			= level.fade_screen.alpha; 
	level.fade_screen.hud.fadeTimer 	= level.fade_screen.fadeTimer;
	level.fade_screen.hud SetShader( level.fade_screen.shader, level.fade_screen.shader_width, level.fade_screen.shader_height );
	level.fade_screen.hud FadeOverTime( 0.5 );
	level.fade_screen.hud.alpha = 1;
	wait 0.5;
}

map_fade_in()
{
	level.fade_screen.hud.alpha = 1; 
	level.fade_screen.hud FadeOverTime( 0.05 ); 
	level.fade_screen.hud.alpha = 0; 
	
	wait 0.5;

	level.fade_screen.hud Destroy();
}

manage_unit_commands()
{
	//level.crew_state = [];
	switch(level.tank_state)
	{
		case 1:
		{
			level._tank_blocks["arena"] thread move_tank_in_position();
			break;
		}
		case 2:
		{
			level._tank_blocks["block_west"] thread move_tank_in_position();
			break;
		}
		case 3:
		{
			level._tank_blocks["block_north"] thread move_tank_in_position();
			break;
		}
		case 4:
		{
			level._tank_blocks["block_east"] thread move_tank_in_position();
			break;
		}
	}
	
	for(i = 0; i < 7; i++)
	{
		if( level.crew_state_current[i] != level.crew_state[i] )
		{
			level.crew_state_current[i] = level.crew_state[i];
			string = "none";
			
			switch(i)
			{
				case 0:
				case 1:
				{
					string = "sniper";
					break;
				}
				case 2:
				case 3:
				{
					string = "RPG";
					break;
				}
				case 4:
				case 5:
				{
					string = "stinger";
					break;
				}
			}
			
			switch(level.crew_state[i])
			{
				case 1:
				{
					level._unit_blocks["west"] thread move_unit_in_position(string);
					break;
				}
				case 2:
				{
					level._unit_blocks["north"] thread move_unit_in_position(string);	
					break;
				}
				case 3:
				{
					level._unit_blocks["east"] thread move_unit_in_position(string);	
					break;
				}
				case 4:
				{
					level._unit_blocks["west"] thread remove_unit_from_blocking_point();
					level.crew_state_current[i] = 0;
					level.crew_state[i] = 0;
					break;
				}
				case 5:
				{
					level._unit_blocks["north"] thread remove_unit_from_blocking_point();
					level.crew_state_current[i] = 0;
					level.crew_state[i] = 0;
					break;
				}
				case 6:
				{
					level._unit_blocks["east"] thread remove_unit_from_blocking_point();
					level.crew_state_current[i] = 0;
					level.crew_state[i] = 0;
					break;
				}
			}
		}
	}
}


#using_animtree("player");
map_room_teleport()
{
	if(!level.player.is_at_base)
	{	
		level.player CameraActivate( true );
		
		level.player AllowCrouch(false);
		
		level.player CameraSetPosition( level.player.second_camera.origin - (0,-17,20));
		
		//level.player CameraSetLookAt(level.player.map_look_at.origin);
			
		level.woods_viewmodel = spawn("script_model",level.player.origin);
		
		align_node = getstruct("by_numbers_struct", "targetname");
		level.woods_viewmodel.origin = level.player.second_camera.origin - (0,18,83);
		level.woods_viewmodel.angles = (0,90,0);
		level.woods_viewmodel setmodel("c_usa_cia_masonjr_viewbody");
		
		level.woods_viewmodel useanimtree(#animtree);
		level.player.old_health = level.player.health;
		
		level.player.horse = undefined;
		
		if(isDefined(level.player.viewlockedentity))
		{
			level.player.viewlockedentity.disable_mount_anim = true;
			level.player.horse = level.player.viewlockedentity;
			level.player.viewlockedentity use_horse(level.player);
		}
		
		level.player.is_at_base = true;
		
		level thread run_map_at_base();
		
		level.player DisableWeapons();
		
		level.player.holds_player_in_place = spawn("script_model",level.player.origin);
		level.player.holds_player_in_place.origin = level.player.origin;
		level.player.holds_player_in_place.angles = level.player.angles;
		level.player PlayerLinkToDelta(level.player.holds_player_in_place, undefined, 0, 0, 0, 0, 0);

	}
	else
	{
		level thread manage_unit_commands();
		level.player EnableWeapons();
		level.player Unlink();

		level.player.is_at_base = false;
		
		level.player AllowCrouch(true);
		
		if(isDefined(level.player.horse))
		{
			level.player.horse use_horse(level.player);	
		}
		level.player CameraActivate( false );		
		level.woods_viewmodel Delete();
		
		wait 0.5;
		if(isDefined(level.player.viewlockedentity))
		{
			level.player.viewlockedentity.disable_mount_anim = false;
		}
	}
}

handle_camera_pos()
{
	if(isDefined(level.woods_viewmodel))
	{
		level.camera_pos = spawn("script_origin", level.woods_viewmodel GetTagOrigin("tag_camera"));
		level.camera_pos.angles = level.woods_viewmodel GetTagAngles("tag_camera");
		
		level.camera_pos LinkTo(level.woods_viewmodel, "tag_camera");
		
		while(level.player.is_at_base)
		{
			level.player CameraSetPosition(level.camera_pos.origin);
			forward_vec = anglestoforward(level.camera_pos.angles);
			forward_vec *= 10;
			
			level.player CameraSetLookAt(level.camera_pos.origin + forward_vec);
			
			wait 0.05;
		}
	}
}

run_map_at_base()
{
	level.player.is_damaged = false;
	level.player.blocking_point_selected = 0;
	level thread track_player_damaged();
	
	level thread map_room_anim_states();
	while(level.player.is_at_base)
	{
		if(level.player.is_damaged)
		{
			map_room_teleport();
			break;
		}
				
		wait 0.05;
	}
}

///////////////////////////////////////
// HOW THE ANIMATION FOR THE MAP WORKS
//////////////////////////////////////
// INDEX 		|		 STATE
// ___________________________________
//		0		|		INTRO
//		1		|		IDLE ARENA
//		2		|		BP1 > ARENA
//		3		|		BP2 > ARENA
//		4		|		BP3 > ARENA
//		5		|		IDLE BP1
//		6		|		ARENA > BP1
//		7		|		BP2 > BP1
//		8		|		BP3 > BP1
//		9		|		IDLE BP2
//		10		|		ARENA > BP2
//		11		|		BP1 > BP2
//		12		|		BP3 > BP2
//		13		|		IDLE BP3
//		14		|		ARENA > BP3
//		15		|		BP1 > BP3
//		16		|		BP2 > BP3
//		17		|		PLACE ARENA
//		18		|		PLACE BP1
//		19		|		PLACE BP2
//		20		|		PLACE BP3


// 

#using_animtree("player");
map_room_anim_states()
{
	level.woods_viewmodel setanim(%int_afghan_com_map_intro_2_idle_arena, 1, 0, 1);
	anim_duration = getanimlength(%int_afghan_com_map_intro_2_idle_arena);
	level thread handle_camera_pos();
	
	wait anim_duration;
	anim_duration = 0;
	idle_duration = 0;
	animation_state_index = 1;
	
	while(level.player.is_at_base )
	{
		if(anim_duration > 0 || level.player.map_input_off)
		{
			anim_duration -= 0.05;
			
			if( anim_duration < 0)
			{
				anim_duration = 0;
			}
			
		}
		else
		{
			level.player.map_input_stick = level.player GetNormalizedMovement();
			
			if( animation_state_index == 1 || animation_state_index == 5 || animation_state_index == 9 || animation_state_index == 13)
			{
				if( (level.player ButtonPressed("Button_a") || level.player ButtonPressed("Button_x") || 
				   level.player ButtonPressed("Button_b") || level.player ButtonPressed("Button_y")) && !level.player.map_button_off)
				{
					level.woods_viewmodel ClearAnim( %root, 0);
					
					//level.temp_item = GetEnt("map_rpg", "targetname");
					//level.temp_item.origin = level.woods_viewmodel GetTagOrigin("tag_weapon");
					//level.temp_item.angle = level.woods_viewmodel GetTagAngles("tag_weapon");
					
					//level.temp_item LinkTo(level.woods_viewmodel, "tag_weapon");
					
					level thread manage_map_logic();
					
					switch(animation_state_index)
					{
						case 1:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_placepawn_arena, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_placepawn_arena);
								animation_state_index = 17;
								
								break;
							}
						case 5:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_placepawn_bp1, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_placepawn_bp1);
								animation_state_index = 18;
								
								break;
							}
						case 9:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_placepawn_bp2, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_placepawn_bp2);
								animation_state_index = 19;
								
								break;
							}
						case 13:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_placepawn_bp3, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_placepawn_bp3);
								animation_state_index = 20;
								
								break;
							}
							
					}
				}
				else if(level.player.map_input_stick[1] < 0 && abs(level.player.map_input_stick[1]) > abs(level.player.map_input_stick[0])
				        && animation_state_index != 5)
				{
					level.woods_viewmodel ClearAnim( %root, 0);
					switch(animation_state_index)
					{
						case 1:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_trans_arena_to_bp1, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_trans_arena_to_bp1);
								animation_state_index = 6;
								
								break;
							}
						case 9:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_trans_bp2_to_bp1, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_trans_bp2_to_bp1);
								animation_state_index = 7;
								
								break;
							}
						case 13:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_trans_bp3_to_bp1, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_trans_bp3_to_bp1);
								animation_state_index = 8;
								
								break;
							}
							
					}
					
				}
				else if(level.player.map_input_stick[1] > 0 && abs(level.player.map_input_stick[1]) > abs(level.player.map_input_stick[0]) 
				        && animation_state_index != 13)
				{
					level.woods_viewmodel ClearAnim( %root, 0);
					switch(animation_state_index)
					{
						case 1:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_trans_arena_to_bp3, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_trans_arena_to_bp3);
								animation_state_index = 14;
								
								break;
							}
						case 5:
						{
							level.woods_viewmodel setanim(%int_afghan_com_map_trans_bp1_to_bp3, 1, 0, 1);
							anim_duration = getanimlength(%int_afghan_com_map_trans_bp1_to_bp3);
							animation_state_index = 15;
							
							break;
						}
						case 9:
						{
							level.woods_viewmodel setanim(%int_afghan_com_map_trans_bp2_to_bp3, 1, 0, 1);
							anim_duration = getanimlength(%int_afghan_com_map_trans_bp2_to_bp3);
							animation_state_index = 16;
							
							break;
						}
					}
				}
				else if(level.player.map_input_stick[0] > 0 && abs(level.player.map_input_stick[1]) < abs(level.player.map_input_stick[0]) 
				        && animation_state_index != 9)
				{
					level.woods_viewmodel ClearAnim( %root, 0);
					switch(animation_state_index)
					{
						case 1:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_trans_arena_to_bp2, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_trans_arena_to_bp2);
								animation_state_index = 10;
								
								break;
							}
						case 5:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_trans_bp1_to_bp2, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_trans_bp1_to_bp2);
								animation_state_index = 11;
								
								break;
							}
						case 13:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_trans_bp3_to_bp2, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_trans_bp3_to_bp2);
								animation_state_index = 12;
								
								break;
							}
					}
				}
				else if(level.player.map_input_stick[0] < 0 && abs(level.player.map_input_stick[1]) < abs(level.player.map_input_stick[0]) 
				        && animation_state_index != 1)
				{
					level.woods_viewmodel ClearAnim( %root, 0);
					switch(animation_state_index)
					{
						case 5:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_trans_bp1_to_arena, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_trans_bp1_to_arena);
								animation_state_index = 2;
								
								break;
							}
						case 9:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_trans_bp2_to_arena, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_trans_bp2_to_arena);
								animation_state_index = 3;
								
								break;
							}
						case 13:
							{
								level.woods_viewmodel setanim(%int_afghan_com_map_trans_bp3_to_arena, 1, 0, 1);
								anim_duration = getanimlength(%int_afghan_com_map_trans_bp3_to_arena);
								animation_state_index = 4;
								
								break;
							}
					}
				}
				else 
				{
					if(idle_duration > 0)
					{
						idle_duration -= 0.05;
					}
					{
						if( (animation_state_index > 0 && animation_state_index < 5) || animation_state_index == 17)
						{
							level.player notify("Arena");
							level.woods_viewmodel ClearAnim( %root, 0);
							level.woods_viewmodel setanim(%int_afghan_com_map_idle_arena, 1, 0, 1);
							idle_duration = getanimlength(%int_afghan_com_map_idle_arena);
							animation_state_index = 1;
						}
						else if( (animation_state_index > 4 && animation_state_index < 9) || animation_state_index == 18)
						{
							level.player notify("Blocking_Point_1");
							level.woods_viewmodel ClearAnim( %root, 0);
							level.woods_viewmodel setanim(%int_afghan_com_map_idle_bp1, 1, 0, 1);
							idle_duration = getanimlength(%int_afghan_com_map_idle_bp1);
							animation_state_index = 5;
						}
						else if( (animation_state_index > 8 && animation_state_index < 13) || animation_state_index == 19)
						{
							level.player notify("Blocking_Point_2");
							level.woods_viewmodel ClearAnim( %root, 0);
							level.woods_viewmodel setanim(%int_afghan_com_map_idle_bp2, 1, 0, 1);
							idle_duration = getanimlength(%int_afghan_com_map_idle_bp2);
							animation_state_index = 9;
						}
						else if( (animation_state_index > 12 && animation_state_index < 17) || animation_state_index == 20)
						{
							level.player notify("Blocking_Point_3");
							level.woods_viewmodel ClearAnim( %root, 0);
							level.woods_viewmodel setanim(%int_afghan_com_map_idle_bp3, 1, 0, 1);
							idle_duration = getanimlength(%int_afghan_com_map_idle_bp3);
							animation_state_index = 13;
						}
					}
				}
			}
			else 
			{
				if(idle_duration > 0)
				{
					idle_duration -= 0.05;
				}
				{
					if( (animation_state_index > 0 && animation_state_index < 5) || animation_state_index == 17)
					{
						level.woods_viewmodel ClearAnim( %root, 0);
						level.woods_viewmodel setanim(%int_afghan_com_map_idle_arena, 1, 0, 1);
						idle_duration = getanimlength(%int_afghan_com_map_idle_arena);
						animation_state_index = 1;
						level.player.blocking_point_selected = 0;
					}
					else if( (animation_state_index > 4 && animation_state_index < 9) || animation_state_index == 18)
					{
						level.woods_viewmodel ClearAnim( %root, 0);
						level.woods_viewmodel setanim(%int_afghan_com_map_idle_bp1, 1, 0, 1);
						idle_duration = getanimlength(%int_afghan_com_map_idle_bp1);
						animation_state_index = 5;
						level.player.blocking_point_selected = 1;
					}
					else if( (animation_state_index > 8 && animation_state_index < 13) || animation_state_index == 19)
					{
						level.woods_viewmodel ClearAnim( %root, 0);
						level.woods_viewmodel setanim(%int_afghan_com_map_idle_bp2, 1, 0, 1);
						idle_duration = getanimlength(%int_afghan_com_map_idle_bp2);
						animation_state_index = 9;
						level.player.blocking_point_selected = 2;
					}
					else if( (animation_state_index > 12 && animation_state_index < 17) || animation_state_index == 20)
					{
						level.woods_viewmodel ClearAnim( %root, 0);
						level.woods_viewmodel setanim(%int_afghan_com_map_idle_bp3, 1, 0, 1);
						idle_duration = getanimlength(%int_afghan_com_map_idle_bp3);
						animation_state_index = 13;
						level.player.blocking_point_selected = 3;
					}
				}
			}
		}

		wait 0.05;
	}
}

// --------------------------
// ~~~~~~~ MAP DATA ~~~~~~~~
// Blocking Point Format
// CHANGED FORMAT, NEED TO UPDATE LATER
// --------------------------

setup_map_logic()
{
	level.tank_piece = getent("map_tank_01", "targetname");
	level.hold_map_items = getent("map_hold_items", "targetname");
	
	level.tank_locations = [];
	
	level.tank_locations[0] = getent("map_arena", "targetname");
	level.tank_locations[1] = getent("map_b1_tank", "targetname");
	level.tank_locations[2] = getent("map_b2_tank", "targetname");
	level.tank_locations[3] = getent("map_b3_tank", "targetname");
	
	level.crew_locations[0] = getent("map_b1", "targetname");
	level.crew_locations[1] = getent("map_b2", "targetname");
	level.crew_locations[2] = getent("map_b3", "targetname");
	
	level.crew_state = [];
	level.crew_state_current = [];
	level.crew_model = [];
	
	for(i = 0; i < 6; i++)
	{
		level.crew_state[i] = 0;
		level.crew_state_current[i] = 0;
	}
	
	level.crew_model[0] = getent("map_sniper_rifle_01", "targetname");
	level.crew_model[1] = getent("map_sniper_rifle_02", "targetname");
	level.crew_model[2] = getent("map_rpg_01", "targetname");
	level.crew_model[3] = getent("map_rpg_02", "targetname");
	level.crew_model[4] = getent("map_stinger_01", "targetname");
	level.crew_model[5] = getent("map_stinger_02", "targetname");
	
	level.tank_state = 0;
}

manage_map_logic()
{
	if(level.player ButtonPressed("Button_a") && !level.player.tank_button_off)
	{	
		switch(level.player.blocking_point_selected)
		{
			case 0:
			{
				if(level.tank_state == 1)
				{
					level.tank_piece.origin = level.hold_map_items.origin;
					level.tank_state = 0;
				}
				else
				{
					level.tank_piece.origin = level.tank_locations[level.player.blocking_point_selected].origin;
					level.tank_state = 1;
				}
				break;
			}
			case 1:
			{
				if(level.tank_state == 2)
				{
					level.tank_piece.origin = level.hold_map_items.origin;
					level.tank_state = 0;
				}
				else
				{
					level.tank_piece.origin = level.tank_locations[level.player.blocking_point_selected].origin;
					level.tank_state = 2;
				}
				break;
			}
			case 2:
			{
				if(level.tank_state == 3)
				{
					level.tank_piece.origin = level.hold_map_items.origin;
					level.tank_state = 0;
				}
				else
				{
					level.tank_piece.origin = level.tank_locations[level.player.blocking_point_selected].origin;
					level.tank_state = 3;
				}
				break;
			}
			case 3:
			{
				if(level.tank_state == 4)
				{
					level.tank_piece.origin = level.hold_map_items.origin;
					level.tank_state = 0;
				}
				else
				{
					level.tank_piece.origin = level.tank_locations[level.player.blocking_point_selected].origin;
					level.tank_state = 4;
				}
				break;
			}
		}
		
		level.player notify("Tank_Placed");
	}
	else if( ( level.player ButtonPressed("Button_x") || level.player ButtonPressed("Button_b") ||
	          level.player ButtonPressed("Button_y") ) && level.player.blocking_point_selected != 0 )
	{
		crew_type = 0;
		
		if( level.player ButtonPressed("Button_b"))
		{
			crew_type = 2;
		}
		else if( level.player ButtonPressed("Button_y"))
		{
			crew_type = 4;
		}
		
		if( level.crew_state[ crew_type ] == level.player.blocking_point_selected )
		{
			level.crew_model[ crew_type ].origin = level.hold_map_items.origin;
			level.crew_state[ crew_type ] = level.player.blocking_point_selected + 3;
		}
		else if( level.crew_state[ crew_type + 1 ] == level.player.blocking_point_selected)
		{
			level.crew_model[ crew_type + 1 ].origin = level.hold_map_items.origin;
			level.crew_state[ crew_type + 1 ] = level.player.blocking_point_selected + 3;
		}
		else
		{
			if( !level.crew_state[ crew_type ]  || level.crew_state[ crew_type ] > 3)
			{
				for( i = 0; i < 6; i ++ )
				{
					if( level.crew_state[ i ] == level.player.blocking_point_selected )
					{
						level.crew_model[ i ].origin = level.hold_map_items.origin;
						level.crew_state[ i ] = 0;
						break;
					}
				}
				
				level.crew_model[ crew_type ].origin = level.crew_locations[ level.player.blocking_point_selected - 1 ].origin;
				level.crew_state[ crew_type ] = level.player.blocking_point_selected;
			}
			else if( !level.crew_state[ crew_type + 1 ]  || (level.crew_state[ crew_type + 1 ] + 3) > 3)
			{
				for( i = 0; i < 6; i ++ )
				{
					if( level.crew_state[ i ] == level.player.blocking_point_selected )
					{
						level.crew_model[ i ].origin = level.hold_map_items.origin;
						level.crew_state[ i ] = 0;
						break;
					}
				}
				
				level.crew_model[ crew_type + 1 ].origin = level.crew_locations[ level.player.blocking_point_selected - 1 ].origin;
				level.crew_state[ crew_type + 1 ] = level.player.blocking_point_selected;
			}
		}
		
		level.player notify("Unit_Placed");
	}
}

track_player_damaged()
{
	level.player waittill("damage");
	
	level.player.is_damaged = true;
}

start_dust_storm_fog_settings()
{
	level.tweakfile = true;
 
	// *Fog section* 
	//dust storm fog
	//call afghanistan_dust_storm.vision here also
	
  	const start_dist = 131.046;
	const half_dist = 1000.5;
	const half_height = 1007.89;
	const base_height = -144.597;
	const fog_r = 0.427451;
	const fog_g = 0.364706;
	const fog_b = 0.27451;
	const fog_scale = 19.0959;
	const sun_col_r = 1;
	const sun_col_g = 0.941177;
	const sun_col_b = 0.843137;
	const sun_dir_x = 0.305329;
	const sun_dir_y = 0.730931;
	const sun_dir_z = 0.610339;
	const sun_start_ang = 0;
	const sun_stop_ang = 71.3698;
	const time = 2;
	const max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
}

//fog for start of canyon after intro
// use afghanistan_canyon_start.vision
canyon_fog_settings()
{

  	const start_dist = 296.237;
	const half_dist = 21215;
	const half_height = 11399.1;
	const base_height = -144.597;
	const fog_r = 0.580392;
	const fog_g = 0.627451;
	const fog_b = 0.647059;
	const fog_scale = 21.5074;
	const sun_col_r = 1;
	const sun_col_g = 0.941177;
	const sun_col_b = 0.843137;
	const sun_dir_x = 0.305329;
	const sun_dir_y = 0.730931;
	const sun_dir_z = 0.610339;
	const sun_start_ang = 0;
	const sun_stop_ang = 102.152;
	const time = 2;
	const max_fog_opacity = 1;


	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

}

// fog for after the canyon and before the rebel base
// use afghanistan_open_area.vision
arena_fog_settings()
{
	

	const start_dist = 296.237;
	const half_dist = 7497.43;
	const half_height = 4759.88;
	const base_height = -144.597;
	const fog_r = 0.74902;
	const fog_g = 0.796079;
	const fog_b = 0.823529;
	const fog_scale = 21.5074;
	const sun_col_r = 1;
	const sun_col_g = 0.941177;
	const sun_col_b = 0.843137;
	const sun_dir_x = 0.305329;
	const sun_dir_y = 0.730931;
	const sun_dir_z = 0.610339;
	const sun_start_ang = 0;
	const sun_stop_ang = 102.152;
	const time = 2;
	const max_fog_opacity = 0.900923;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
}

//fog for rebel base entrance
//use afghanistan_rebel_entrance.vision

rebel_entrance_fog_settings()
{
	const start_dist = 281.96;
	const half_dist = 16268.3;
	const half_height = 4759.88;
	const base_height = -144.597;
	const fog_r = 0.74902;
	const fog_g = 0.796079;
	const fog_b = 0.823529;
	const fog_scale = 16.9023;
	const sun_col_r = 1;
	const sun_col_g = 0.941177;
	const sun_col_b = 0.843137;
	const sun_dir_x = 0.305329;
	const sun_dir_y = 0.730931;
	const sun_dir_z = 0.610339;
	const sun_start_ang = 0;
	const sun_stop_ang = 102.152;
	const time = 2;
	const max_fog_opacity = 0.900923;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
}

//fog for inside rebel camp
//use afghanistan_rebel_camp.vision

rebel_camp_fog_settings()
{
	const start_dist = 162;
	const half_dist = 16268.3;
	const half_height = 4759.88;
	const base_height = -144.597;
	const fog_r = 0.74902;
	const fog_g = 0.796079;
	const fog_b = 0.823529;
	const fog_scale = 12;
	const sun_col_r = 1;
	const sun_col_g = 0.941177;
	const sun_col_b = 0.843137;
	const sun_dir_x = 0.305329;
	const sun_dir_y = 0.730931;
	const sun_dir_z = 0.610339;
	const sun_start_ang = 0;
	const sun_stop_ang = 102.152;
	const time = 2;
	const max_fog_opacity = 0.900923;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
}


sniper_crew_logic()
{
	self endon( "death" );
	//level endon( "wave1_complete" );
	
	n_sniper_range = 2800;
	a_tags = [];
	
	a_tags[ 0 ] = "J_SpineLower";
	a_tags[ 1 ] = "J_Knee_LE";
	a_tags[ 2 ] = "J_SpineUpper";
	a_tags[ 3 ] = "J_Neck";
	a_tags[ 4 ] = "J_Head";
	
	if ( level.n_current_wave == 1 )
	{
		flag_wait( "wave1_started" );
		
		n_sniper_range = 2800;
	}
	
	else if ( level.n_current_wave == 2 )
	{
		if ( level.wave2_loc == "blocking point 2" )
		{
			trigger_wait( "spawn_wave2_bp2" );
		}
		
		else
		{
			trigger_wait( "spawn_wave2_bp3" );	
		}
	}
	
	else
	{
	
	}
	
	while( 1 )
	{
		a_ai_targets = getaiarray( "axis" );
		
		if ( a_ai_targets.size )
		{
			a_targets = sortbydistance( a_ai_targets, level.player.origin );
			ai_target = a_targets[ ( a_targets.size - 1 ) ];
			
			if ( Distance2D( self.origin, ai_target.origin ) <= n_sniper_range )
			{
				if ( IsDefined( ai_target ) )
				{
					self thread aim_at_target( ai_target );
					
					wait 3;
					
					if ( IsDefined( ai_target ) )
					{
						v_target = ai_target GetTagOrigin( a_tags[ RandomInt( 5 ) ] );
						
						b_canshoot = BulletTracePassed( ( self GetTagOrigin( "tag_flash" ) ), v_target, true, undefined );
						
						if ( b_canshoot )
						{
							MagicBullet( "dragunov_sp", self GetTagOrigin( "tag_flash" ), v_target );
							
							e_trail = spawn( "script_model", self GetTagOrigin( "tag_flash" ) );
							e_trail SetModel( "tag_origin" );
							
							PlayFXOnTag( level._effect[ "sniper_trail" ], e_trail, "tag_origin" );
							
							e_trail MoveTo( v_target, 0.1 );
							
							PlayFX( level._effect[ "sniper_impact" ], v_target );
							
							if ( IsAlive( ai_target ) )
							{
								ai_target Die();
							}
							
							wait 0.1;
							
							e_trail Delete();
						}
					}
				}
			}
		}
		
		wait RandomFloatRange( 3.0, 6.0 );
	}
}


stinger_crew_logic()
{
	self endon( "death" );
	
	if ( level.n_current_wave == 1 )
	{
		flag_wait( "wave1_started" );
		
		n_stinger_range = 3200;
	}
	
	else if ( level.n_current_wave == 2 )
	{
		if ( level.wave2_loc == "blocking point 2" )
		{
			trigger_wait( "spawn_wave2_bp2" );
		}
		
		else
		{
			trigger_wait( "spawn_wave2_bp3" );	
		}
	}
	
	else
	{
	
	}
	
	while( 1 )
	{
		a_vh_targets = getentarray( "script_vehicle", "classname" );
			
		if ( ( a_vh_targets.size ) )
		{
			for ( i = 0; i < a_vh_targets.size; i++ )
			{
				if ( a_vh_targets[ i ].vehicletype == "heli_hip" && Distance2D( self.origin, a_vh_targets[ i ].origin ) <= n_stinger_range )
				{
					e_target = a_vh_targets[ i ];
					iprintlnbold( "found chopper" );
					break;	
				}
			}
			
			if ( IsDefined( e_target ) )
			{
				self thread aim_at_target( e_target );
				
				wait 3;
			}
					
			if ( IsAlive( e_target ) )
			{
				if ( IsAlive( e_target ) && BulletTracePassed( ( self GetTagOrigin( "tag_flash" ) ), e_target.origin, true, undefined ) )	
				{
					if ( cointoss() )
					{
						MagicBullet( "stinger_sp", self GetTagOrigin( "tag_flash" ), e_target.origin, self, e_target, ( 0, 0, -32 ) );
					}
					
					else
					{
						MagicBullet( "stinger_sp", self GetTagOrigin( "tag_flash" ), e_target.origin );
					}
				}
			}
		}
		
		wait RandomFloatRange( 5.0, 7.0 );
	}
}


rpg_crew_logic()
{
	self endon( "death" );
	//level endon( "wave1_complete" );
	
	if ( level.n_current_wave == 1 )
	{
		flag_wait( "wave1_started" );
		
		n_rpg_range = 2800;
		
		self thread rpg_crew_target( "spawn_vehicles_bp1", n_rpg_range );
	}
	
	else if ( level.n_current_wave == 2 )
	{
		if ( level.wave2_loc == "blocking point 2" )
		{
			trigger_wait( "spawn_wave2_bp2" );
		}
		
		else
		{
			trigger_wait( "spawn_wave2_bp3" );	
		}
	}
	
	else
	{
	
	}
}


rpg_crew_target( str_veh_flag, n_range )
{
	self endon( "death" );
	
	while( 1 )
	{
		if ( flag( str_veh_flag ) )
		{
			a_vh_targets = getentarray( "script_vehicle", "classname" );
			
			if ( ( a_vh_targets.size ) )
			{
				a_targets = sortbydistance( a_vh_targets, self.origin );
				
				for ( i = a_targets.size - 1; i > 0; i-- )
				{
					if ( a_targets[ i ].vehicletype == "apc_btr60" && isAlive( a_targets[ i ] ) )
					{
						e_target = a_targets[ i ];
						break;	
					}
				}
				
				if ( IsDefined( e_target ) && IsDefined( e_target.is_btr ) && Distance2D( self.origin, e_target.origin ) <= n_range )
				{
					if ( isAlive( e_target ) )
					{
						self rpg_crew_shoot( e_target );
					}
						
					else
					{
						self rpg_crew_attack_ai( str_veh_flag, n_range );
					}
				}
				
				else
				{
					self rpg_crew_attack_ai( str_veh_flag, n_range );
				}
			}
		}
		
		else
		{
			self rpg_crew_attack_ai( str_veh_flag, n_range );
		}
		
		wait RandomFloatRange( 7.0, 9.0 );
	}
}


rpg_crew_attack_ai( str_veh_flag, n_range )
{
	self endon( "death" );
	
	a_ai_targets = getaiarray( "axis" );
		
	if ( a_ai_targets.size )
	{
		while( 1 )
		{
			a_ai_targets = getaiarray( "axis" );
			ai_target = a_ai_targets[ RandomInt( a_ai_targets.size ) ];
				
			if ( IsDefined( ai_target ) )
			{
				b_canshoot = BulletTracePassed( ( self GetTagOrigin( "tag_flash" ) ), ai_target.origin, true, undefined );
						
				if ( Distance2D( self.origin, ai_target.origin ) <= n_range && b_canshoot )
				{
					e_target = ai_target;
					self rpg_crew_shoot( e_target );
					break;
				}
			}
			
			wait 2;
		}
	}
}


rpg_crew_shoot( e_target )
{
	if ( IsDefined( e_target ) )
	{
		self thread aim_at_target( e_target );
						
		wait 3;
						
		if ( IsDefined( e_target ) )
		{
			MagicBullet( "rpg_sp", self GetTagOrigin( "tag_flash" ), e_target.origin + ( 0, 0, 32 ) );
		}
	}	
}