#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include maps\_horse;
#include maps\_turret;
#include maps\_dialog;
#include maps\_scene;
#include maps\_skipto;
#include maps\_rusher;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

skipto_setup()
{
	// this is for the sandparticles in the valley you look through during the horse_charge event
	//	binocular moment.  They are an exploder so we can turn them off during this moment
	//exploder( 1000 );
	
	load_gumps_afghanistan();
	
	skipto = level.skipto_point;
	if (skipto == "intro")
		return;
	
	//set_objective( level.OBJ_AFGHAN_BC1, undefined, "done");
	//set_objective( level.OBJ_AFGHAN_BC2, undefined, "done");
	
	if(skipto == "horse_intro")
		return;
	//set_objective( level.OBJ_AFGHAN_BC3, undefined, "done");
	set_objective( level.OBJ_AFGHAN_BC3A, undefined, "done");
	
	maps\createart\afghanistan_art::turn_down_fog();
	
	if(skipto == "rebel_base_intro")
		return;
	
	flag_set( "first_rebel_base_visit" );

	if (skipto == "firehorse")
		return;
	
	if (skipto == "wave_1")
		return;
	
	flag_set( "wave1_done" );
	
	if (skipto == "wave_2")
		return;
	
	flag_set( "wave2_done" );
	
	if (skipto == "wave_3")
		return;
	
	flag_set( "wave3_done" );
	
	if (skipto == "blocking_done")
		return;
	
	flag_set( "blocking_done" );
	
	if(skipto == "horse_charge")
		return;
	
	flag_set("player_pushed_off_horse");
	
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


load_gumps_afghanistan()
{
	if ( is_after_skipto( "krav_tank" ) )
	{
		load_gump( "afghanistan_gump_ending" );
	}
	
	else if ( is_after_skipto( "rebel_base_intro" ) )
	{
		load_gump( "afghanistan_gump_arena" );
	}
	
	else
	{
		load_gump( "afghanistan_gump_intro" );
	}
}

	
delete_section1_scenes()
{
	delete_scene_all("e1_s1_pulwar");
	delete_scene_all("e1_s1_pulwar_single");	
	//delete_scene_all("e1_player_wood_greeting");  //this deleted Woods also, which is not what we want
	delete_scene("e1_player_wood_greeting");
	delete_scene("e1_player_wood_idle");
	delete_scene("e1_zhao_horse_charge_woods_intro");
	delete_scene("e1_zhao_horse_charge_woods_intro_idle");
	delete_scene("e1_zhao_horse_charge_idle");
	delete_scene("e1_zhao_horse_charge_player");
	delete_scene("e1_zhao_horse_charge");
	//delete_scene("e1_horse_charge_muj_endloop");
	delete_scene("e1_horse_charge_muj1_endloop");
	delete_scene("e1_horse_charge_muj2_endloop");
	delete_scene("e1_horse_charge_muj3_endloop");
	delete_scene("e1_horse_charge_muj4_endloop");
	//delete_scene("e1_s5_vulture_shoot_woods");
	//delete_scene("e1_s5_vulture_shoot_zhao");
	//delete_scene_all("e1_horse_charge_muj");
	delete_scene_all("e1_horse_charge_muj1");
	delete_scene_all("e1_horse_charge_muj2");
	delete_scene_all("e1_horse_charge_muj3");
	delete_scene_all("e1_horse_charge_muj4");
	//delete_scene("e1_zhao_horse_approach_far_loop");
	delete_scene("e1_zhao_horse_approach_spread");
	//delete_scene("e1_zhao_horse_approach_spread_loop");
	
	delete_scene("e1_zhao_horse_charge_woods");
}

delete_section1_ride_scenes()
{
	delete_scene_all("e1_truck_offload");
	delete_scene_all("e1_truck_offload_idle");
	delete_scene_all("e1_truck_hold_truck_idle");
	delete_scene_all("e1_ride_lookout");
	delete_scene_all("e2_tank_ride_idle_start");
	delete_scene_all("e2_tank_ride_idle");		
	delete_scene_all("e2_tank_ride_idle_end");
}

delete_section_2_scenes()
{
	delete_scene_all("e2_cooking_muj");
	delete_scene_all("e2_drum_burner");
	//level delete_scene_all("e2_gas_guys");
	delete_scene_all("e2_gunsmith");
	//level delete_scene("e2_ridge_lookout");
	delete_scene_all("e2_smokers");
	delete_scene_all("e2_generator");
	delete_scene_all("e2_tower_lookout_startidl");
	delete_scene_all("e2_tower_lookout_follow");			
	delete_scene_all("e2_tower_lookout_endidl");
	delete_scene_all("e2_stinger_move");
	delete_scene_all("e2_stinger_endidl");
	//level delete_scene_all("e2_herder_startidl");
	//level delete_scene_all("e2_herder_move");	
	//level delete_scene_all("e2_herder_endidl");
	delete_scene_all("e2_stacker_carry_1");
	delete_scene_all("e2_stacker_carry_2");
	delete_scene_all("e2_stacker_main_2");
	delete_scene_all("e2_stacker_endidl");
	delete_scene_all("e2_stacker_3");
	delete_scene_all("e2_window_startidl");
	delete_scene_all("e2_window_follow");		
	delete_scene_all("e2_walltop_start");
	delete_scene_all("e2_walltop_lookout");
	delete_scene_all("e2_walltop_end");
	delete_scene_all("e2_runout_startidl_1");
	delete_scene_all("e2_runout_startidl_2");
	delete_scene_all("e2_runout_startidl_3");
	delete_scene_all("e2_runout_startidl_4");
	delete_scene_all("e2_runout_startidl_5");
	delete_scene_all("e2_runout_startidl_6");
	delete_scene_all("e2_runout_run_1");
	delete_scene_all("e2_runout_run_2");
	delete_scene_all("e2_runout_run_3");
	delete_scene_all("e2_runout_run_4");
	delete_scene_all("e2_runout_run_5");
	delete_scene_all("e2_runout_run_6");
	delete_scene_all("e2_tank_guy");
	delete_scene_all("e2_rooftop_guys");
}

delete_section3_scenes()
{
	delete_scene("e3_exit_map_room");
	delete_scene("e3_map_room_idle");
	delete_scene("e3_ride_out");
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
	self endon( "death" );
	
	self.vh_horse = vh_riders_horse;
	self.deathFunction = ::rider_died_make_horse_rideable;
}

rider_died_make_horse_rideable()
{
	self endon( "death" );
	
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
	const Default_Near_End = 400;
	const Default_Far_Start = 2000;
	const Default_Far_End = 3000;
	const Default_Near_Blur = 4;
	const Default_Far_Blur = 3;
	
	const Near_Start = 0;	// 0
	const Near_End = 650;	// 8000
	const Far_Start = 700;	// 700
	const Far_End = 15000;	// 10000
	const Near_Blur = 10; // 6
	const Far_Blur = 7;	// 0
	
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

lerp_dof_over_time_pass_out( time )
{
	
	const Near_Start = 0;	// 0
	const Near_End = 1;		// 1
	const Far_Start = 8000;	// 8000
	const Far_End = 10000;	// 10000
	const Near_Blur = 6;	// 6
	const Far_Blur = 0;	// 0
	
	const Default_Near_Start = 0;
	const Default_Near_End = 650;
	const Default_Far_Start = 700;
	const Default_Far_End = 15000;
	const Default_Near_Blur = 10;
	const Default_Far_Blur = 7;
	
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

reset_dof()
{
	const Near_Start = 0;	// 0
	const Near_End = 1;		// 1
	const Far_Start = 8000;	// 8000
	const Far_End = 10000;	// 10000
	const Near_Blur = 6;	// 6
	const Far_Blur = 0;	// 0
	self SetDepthOfField( Near_Start, Near_End, Far_Start, Far_End, Near_Blur, Far_Blur );
}


spawn_bp2_cache( str_weapon )
{
	m_ammo_cache = GetEnt( "bp2_cache", "script_noteworthy" );
	if ( str_weapon == "rpg" )
	{
		/*s_rpg_pos = getstruct( "rpg_bp2_pos1", "targetname" );
		
		if ( level.b_rpg_bp2 )
		{
			s_rpg_pos = getstruct( "rpg_bp2_pos2", "targetname" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_bp2_cache( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 1, "rpg_player_sp" );
	}
	
	if ( str_weapon == "afghanstinger" )
	{
		/*s_stinger_pos = getstruct( "stinger_bp2_pos1", "targetname" );
		
		if ( level.b_stinger_bp2 )
		{
			s_stinger_pos = getstruct( "stinger_bp2_pos2", "targetname" );
		}
		
		e_stinger = Spawn( "weapon_afghanstinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_bp2_cache( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 2, "afghanstinger_sp" );
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
	
	else if ( str_weapon == "afghanstinger" )
	{
		level.player GiveMaxAmmo( "afghanstinger_sp" );
		
		level.player setactionslot( 3, "weapon", "afghanstinger_ff_sp" );
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
	m_ammo_cache = GetEnt( "weapon_cache", "script_noteworthy" );
	if ( str_weapon == "rpg" )
	{
		/*s_rpg_pos = getstruct( "rpg_pos1", "targetname" );		
		
		if ( level.b_rpg_shift )
		{
			s_rpg_pos = getstruct( "rpg_pos2", "targetname" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_pickup( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 1, "rpg_player_sp" );
	}
	
	else if ( str_weapon == "afghanstinger" )
	{
		/*s_stinger_pos = getstruct( "stinger_pos1", "targetname" );		
		
		if ( level.b_stinger_shift )
		{
			s_stinger_pos = getstruct( "stinger_pos2", "targetname" );
		}
		
		e_stinger = Spawn( "weapon_afghanstinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_pickup( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 2, "afghanstinger_sp" );
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
	
	if ( str_weapon == "afghanstinger" )
	{
		level.player GiveMaxAmmo( "afghanstinger_sp" );
		
		level.player setactionslot( 3, "weapon", "afghanstinger_ff_sp" );
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
	m_ammo_cache = GetEnt( "bp3_cache", "script_noteworthy" );
	if ( str_weapon == "rpg" )
	{
		/*s_rpg_pos = getstruct( "rpg_bp3_pos1", "targetname" );
		
		if ( level.b_rpg_bp3 )
		{
			s_rpg_pos = getstruct( "rpg_bp3_pos2", "targetname" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_bp3_cache( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 1, "rpg_player_sp" );
	}
	
	if ( str_weapon == "afghanstinger" )
	{
		/*s_stinger_pos = getstruct( "stinger_bp3_pos1", "targetname" );
		
		if ( level.b_stinger_bp3 )
		{
			s_stinger_pos = getstruct( "stinger_bp3_pos2", "targetname" );
		}
		
		e_stinger = Spawn( "weapon_afghanstinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_bp3_cache( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 2, "afghanstinger_sp" );
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
	
	else if ( str_weapon == "afghanstinger" )
	{
		level.player GiveMaxAmmo( "afghanstinger_sp" );
		
		level.player setactionslot( 3, "weapon", "afghanstinger_ff_sp" );
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
	m_ammo_cache = GetEnt( "cache1_cache", "script_noteworthy" );
	if ( str_weapon == "rpg" )
	{
		/*s_rpg_pos = getstruct( "rpg_cache1_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache1 )
		{
			s_rpg_pos = getstruct( "rpg_cache1_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache1( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 1, "rpg_player_sp" );
	}
	
	if ( str_weapon == "afghanstinger" )
	{
		/*s_stinger_pos = getstruct( "stinger_cache1_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache1 )
		{
			s_stinger_pos = getstruct( "stinger_cache1_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_afghanstinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache1( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 2, "afghanstinger_sp" );
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
	
	else if ( str_weapon == "afghanstinger" )
	{
		level.player GiveMaxAmmo( "afghanstinger_sp" );
		
		level.player setactionslot( 3, "weapon", "afghanstinger_ff_sp" );
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
	m_ammo_cache = GetEnt( "cache2_cache", "script_noteworthy" );
	if ( str_weapon == "rpg" )
	{
		/*s_rpg_pos = getstruct( "rpg_cache2_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache2 )
		{
			s_rpg_pos = getstruct( "rpg_cache2_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache2( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 1, "rpg_player_sp" );
	}
	
	if ( str_weapon == "afghanstinger" )
	{
		/*s_stinger_pos = getstruct( "stinger_cache2_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache2 )
		{
			s_stinger_pos = getstruct( "stinger_cache2_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_afghanstinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache2( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 2, "afghanstinger_sp" );
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
	
	else if ( str_weapon == "afghanstinger" )
	{
		level.player GiveMaxAmmo( "stinger_sp" );
		
		level.player setactionslot( 3, "weapon", "afghanstinger_ff_sp" );
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
	m_ammo_cache = GetEnt( "cache3_cache", "script_noteworthy" );
	if ( str_weapon == "rpg" )
	{
		/*s_rpg_pos = getstruct( "rpg_cache3_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache3 )
		{
			s_rpg_pos = getstruct( "rpg_cache3_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache3( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 1, "rpg_player_sp" );
	}
	
	if ( str_weapon == "afghanstinger" )
	{
		/*s_stinger_pos = getstruct( "stinger_cache3_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache3 )
		{
			s_stinger_pos = getstruct( "stinger_cache3_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_afghanstinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache3( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 2, "afghanstinger_sp" );
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
	
	else if ( str_weapon == "afghanstinger" )
	{
		level.player GiveMaxAmmo( "afghanstinger_sp" );
		
		level.player setactionslot( 3, "weapon", "afghanstinger_ff_sp" );
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
	level endon( "wave2_done" );
	
	m_ammo_cache = GetEnt( "cache4_cache", "script_noteworthy" );
	if ( str_weapon == "rpg" )
	{
		/*s_rpg_pos = getstruct( "rpg_cache4_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache4 )
		{
			s_rpg_pos = getstruct( "rpg_cache4_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache4( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 1, "rpg_player_sp" );
	}
	
	if ( str_weapon == "afghanstinger" )
	{
		/*s_stinger_pos = getstruct( "stinger_cache4_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache4 )
		{
			s_stinger_pos = getstruct( "stinger_cache4_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_afghanstinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache4( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 2, "afghanstinger_sp" );
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
	
	else if ( str_weapon == "afghanstinger" )
	{
		level.player GiveMaxAmmo( "afghanstinger_sp" );
		
		level.player setactionslot( 3, "weapon", "afghanstinger_ff_sp" );
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
	m_ammo_cache = GetEnt( "cache5_cache", "script_noteworthy" );
	if ( str_weapon == "rpg" )
	{
		/*s_rpg_pos = getstruct( "rpg_cache5_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache5 )
		{
			s_rpg_pos = getstruct( "rpg_cache5_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache5( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 1, "rpg_player_sp" );
	}
	
	if ( str_weapon == "afghanstinger" )
	{
		/*s_stinger_pos = getstruct( "stinger_cache5_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache5 )
		{
			s_stinger_pos = getstruct( "stinger_cache5_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_afghanstinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache5( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 2, "afghanstinger_sp" );
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
	
	else if ( str_weapon == "afghanstinger" )
	{
		level.player GiveMaxAmmo( "afghanstinger_sp" );
		
		level.player setactionslot( 3, "weapon", "afghanstinger_ff_sp" );
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
	m_ammo_cache = GetEnt( "cache6_cache", "script_noteworthy" );
	if ( str_weapon == "rpg" )
	{
		/*s_rpg_pos = getstruct( "rpg_cache6_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache6 )
		{
			s_rpg_pos = getstruct( "rpg_cache6_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache6( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 1, "rpg_player_sp" );
	}
	
	if ( str_weapon == "afghanstinger" )
	{
		/*s_stinger_pos = getstruct( "stinger_cache6_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache6 )
		{
			s_stinger_pos = getstruct( "stinger_cache6_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_afghanstinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache6( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 2, "afghanstinger_sp" );
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
	
	else if ( str_weapon == "afghanstinger" )
	{
		level.player GiveMaxAmmo( "afghanstinger_sp" );
		
		level.player setactionslot( 3, "weapon", "afghanstinger_ff_sp" );
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
	m_ammo_cache = GetEnt( "cache7_cache", "script_noteworthy" );
	if ( str_weapon == "rpg" )
	{
		/*s_rpg_pos = getstruct( "rpg_cache7_pos1", "script_noteworthy" );
		
		if ( level.b_rpg_cache7 )
		{
			s_rpg_pos = getstruct( "rpg_cache7_pos2", "script_noteworthy" );
		}
		
		e_rpg = Spawn( "weapon_rpg_player_sp", s_rpg_pos.origin, 0 );
				
		e_rpg thread watch_weapon_cache7( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 1, "rpg_player_sp" );
	}
	
	if ( str_weapon == "afghanstinger" )
	{
		/*s_stinger_pos = getstruct( "stinger_cache7_pos1", "script_noteworthy" );
		
		if ( level.b_stinger_cache7 )
		{
			s_stinger_pos = getstruct( "stinger_cache7_pos2", "script_noteworthy" );
		}
		
		e_stinger = Spawn( "weapon_afghanstinger_sp", s_stinger_pos.origin, 0 );
				
		e_stinger thread watch_weapon_cache7( str_weapon );*/
		m_ammo_cache thread maps\_ammo_refill::activate_extra_slot( 2, "afghanstinger_sp" );
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
	
	else if ( str_weapon == "afghanstinger" )
	{
		level.player GiveMaxAmmo( "afghanstinger_sp" );
		
		level.player setactionslot( 3, "weapon", "afghanstinger_ff_sp" );
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
	level thread spawn_bp2_cache( "afghanstinger" );
	level thread spawn_bp3_cache( "afghanstinger" );
	level thread spawn_weapon_cache4( "rpg" );
	
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


stock_weapon_caches()
{
	level thread spawn_weapon_cache1( "rpg" );
	level thread spawn_weapon_cache1( "afghanstinger" );
	level thread spawn_weapon_cache2( "rpg" );
	level thread spawn_weapon_cache2( "afghanstinger" );
	level thread spawn_weapon_cache3( "rpg" );
	level thread spawn_weapon_cache3( "afghanstinger" );
	level thread spawn_weapon_cache4( "afghanstinger" );
	level thread spawn_weapon_cache5( "rpg" );
	level thread spawn_weapon_cache5( "afghanstinger" );
	level thread spawn_weapon_cache6( "rpg" );
	level thread spawn_weapon_cache6( "afghanstinger" );
	level thread spawn_weapon_cache7( "rpg" );
	level thread spawn_weapon_cache7( "afghanstinger" );	
}


hind_fireat_target( e_target )
{
	self endon( "death" );
	
	n_burst = RandomIntRange( 12, 25 );
	
	self SetLookAtEnt( e_target );
		
	wait 3;
	
	for ( i = 0; i < n_burst; i++ )
	{
		n_offset_x = RandomIntRange( -64, 64 );
		n_offset_y = RandomIntRange( -24, 24 );
		n_offset_z = RandomIntRange( -24, 84 );
		
		if ( IsDefined( e_target ) )
		{
			v_target = ( n_offset_x, n_offset_y, n_offset_z ) + e_target.origin;
			
			MagicBullet( "btr60_heavy_machinegun", self.origin + ( 251, 0, -130 ), v_target );
		}
			
		wait 0.05;
	}
	
	if ( IsDefined( e_target ) )
	{
		for ( i = 0; i < RandomIntRange( 1, 5 ); i++ )
		{	
			if ( IsDefined( e_target ) )
			{
				v_missile_left = self gettagorigin( "tag_missile_left" ) + ( AnglesToForward( self.angles ) * 200 );
				v_missile_right = self gettagorigin( "tag_missile_right" ) + ( AnglesToForward( self.angles ) * 200 );
				
				MagicBullet( "hind_rockets", v_missile_left, e_target.origin, self, e_target, ( RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ) ) );
				MagicBullet( "hind_rockets", v_missile_right, e_target.origin, self, e_target, ( RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ) ) );
			}
			
			i++;
			
			wait RandomFloatRange( 0.5, 1.5 );
		}
	}
	
	self ClearLookAtEnt();
}


vehicle_acquire_target()
{
	self endon( "death" );
	
	a_enemies = getaiarray( "allies" );
	
	e_target = level.player;
		
	if ( cointoss() )
	{
		if ( a_enemies.size )
		{
			ai_muj = a_enemies[ RandomInt( a_enemies.size ) ];
			
			if ( IsDefined( ai_muj ) && Distance2DSquared( self.origin, ai_muj.origin ) < ( 8000 * 8000 ) )
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


mig_gun_strafe()
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	while( 1 )
	{
		v_gunl = self gettagorigin( "tag_weapons_l" ) + ( AnglesToForward( self.angles ) * 500 );
		v_gunr = self gettagorigin( "tag_weapons_r" ) + ( AnglesToForward( self.angles ) * 500 );
		v_targetl = self gettagorigin( "tag_weapons_l" ) + ( AnglesToForward( self.angles ) * 800 );
		v_targetr = self gettagorigin( "tag_weapons_r" ) + ( AnglesToForward( self.angles ) * 800 );
			
		MagicBullet( "btr60_heavy_machinegun", v_gunl, v_targetl + ( 0, 0, -100 ) );
		MagicBullet( "btr60_heavy_machinegun", v_gunr, v_targetr + ( 0, 0, -100 ) );
			
		wait 0.1;
	}
}


hind_rocket_attack()
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	while ( 1 )
	{
		a_guys = getaiarray( "allies" );
		
		for ( i = 0; i < a_guys.size; i++ )
		{
			if ( Distance2D( self.origin, a_guys[ i ].origin ) <= 8000 )
			{
				b_canshoot = SightTracePassed( ( self GetTagOrigin( "tag_origin" ) ), ( a_guys[ i ] GetTagOrigin( "tag_origin" ) ), true, undefined );
				
				if ( b_canshoot )
				{
					e_target = a_guys[ i ];
					break;
				}
			}
		}
		
		if ( RandomInt( 3 ) == 0 )
		{
			e_target = level.player;	
		}
		
		if ( IsAlive( e_target ) )
		{
			v_target = e_target.origin;
			
			self setLookAtEnt( e_target );
			
			wait 4.5;
			
			MagicBullet( "stinger_sp", self gettagorigin( "tag_missile_left" ) + ( 0, 0, -80 ), v_target );
			wait 1;
			MagicBullet( "stinger_sp", self gettagorigin( "tag_missile_right" ) + ( 0, 0, -80 ), v_target );
			
			wait 2;
			
			self ClearLookAtEnt();
		}
		
		wait RandomIntRange( 2, 5 );
	}
}


hind_rocket_target( e_target )
{
	self endon( "death" );
	
	if ( IsDefined( e_target ) )
	{
		self setLookAtEnt( e_target );
			
		wait 3;
		
		if ( IsDefined( e_target ) )
		{
			v_target = e_target.origin;
			
			MagicBullet( "stinger_sp", self gettagorigin( "tag_missile_left" ) + ( 0, 0, -80 ), v_target );
			wait 1;
			MagicBullet( "stinger_sp", self gettagorigin( "tag_missile_right" ) + ( 0, 0, -80 ), v_target );
			
			wait 2;
			
			v_target = undefined;
		}
	}
}


hind_strafe()
{
	self endon( "death" );
	self endon( "stop_strafe" );
	
	self thread hind_rocket_strafe();
	
	while( 1 )
	{
		v_target = self.origin + ( AnglesToForward( self.angles ) * 5000 );
			
		MagicBullet( "btr60_heavy_machinegun", self.origin + ( 251, 0, -130 ), v_target );
		
		//wait RandomFloatRange( 1.0, 2.0 );
		wait 0.05;
	}
}


hind_rocket_strafe()
{
	self endon( "death" );
	self endon( "stop_strafe" );
	
	while( 1 )
	{
		v_missile_left = self gettagorigin( "tag_missile_left" ) + ( AnglesToForward( self.angles ) * 200 );
		v_left_target = ( self gettagorigin( "tag_missile_left" ) + ( AnglesToForward( self.angles ) * 2500 ) ) + ( 0, 0, -1000 );
		
		v_missile_right = self gettagorigin( "tag_missile_right" ) + ( AnglesToForward( self.angles ) * 200 );
		v_right_target = ( self gettagorigin( "tag_missile_right" ) + ( AnglesToForward( self.angles ) * 2500 ) ) + ( 0, 0, -1000 );
		
		MagicBullet( "hind_rockets", v_missile_left, v_left_target );
		MagicBullet( "hind_rockets", v_missile_right, v_right_target );
		
		wait 0.5;
	}
}


hind_attack_indefinitely()
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	while( 1 )
	{
		e_target = self vehicle_acquire_target();
		
		if ( IsDefined( e_target ) )
		{		
			self hind_fireat_target( e_target );
		}
		
		self ClearLookAtEnt();
	}	
}


hind_stop_attack_aftertime( n_time )
{
	self endon( "death" );
	
	wait n_time;
	
	self notify( "stop_attack" );
}


hind_attack_think( n_range )
{
	self endon( "death" );
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


hind_attack_base( n_delay )
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	s_target = getstruct( "base_pos", "targetname" );
	
	if ( IsDefined( n_delay ) )
	{
		wait n_delay;	
	}
	
	while( 1 )
	{
		MagicBullet( "stinger_sp", self gettagorigin( "tag_missile_left" ) + ( 0, 0, -80 ), s_target.origin + ( 0, 0, RandomIntRange( -50, 50 ) ) );
		MagicBullet( "stinger_sp", self gettagorigin( "tag_missile_right" ) + ( 0, 0, -80 ), s_target.origin + ( 0, 0, RandomIntRange( -50, 50 ) ) );
		wait 1;
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
		MagicBullet( "stinger_sp", self gettagorigin( "tag_missile_left" ) + ( 0, 0, -80 ), e_base_target.origin );
		MagicBullet( "stinger_sp", self gettagorigin( "tag_missile_right" ) + ( 0, 0, -80 ), e_base_target.origin );
		
		wait RandomIntRange( 3, 6 );
	}
}


heli_evade()
{
	self endon( "death" );
	
	while ( 1 )
	{
		self waittill( "missile_fire", missile );
		
		heli = self.stingerTarget;
		
		if ( IsDefined( heli ) )
		{
			if ( !IsDefined( heli.b_rappel_done ) && !IsDefined( heli.statue_target ) )
			{
				heli thread heli_deploy_flares( missile );
			}
			
			else if ( IsDefined( heli.b_rappel_done ) && ( heli.b_rappel_done ) )
			{
				heli thread heli_deploy_flares( missile );
			}
			
			else if ( IsDefined( heli.statue_target ) && ( !heli.statue_target ) )
			{
				heli thread heli_deploy_flares( missile );
			}
		}
	}
}


heli_deploy_flares( missile )
{
	self endon( "death" );
	
	if ( !IsDefined( missile ) )
		return;
		
	//Create an entity for the stinger to track
	vec_toForward = anglesToForward( self.angles );
	vec_toRight = AnglesToRight( self.angles );
		
	self.chaff_fx = spawn( "script_model", self.origin );
	self.chaff_fx.angles = (0,180,0);
	self.chaff_fx SetModel( "tag_origin" );
	self.chaff_fx LinkTo( self , "tag_origin", ( 0, 0, -120 ), ( 0, 0, 0 ) );
		
	delta = self.origin - missile.origin;
	dot = VectorDot(delta,vec_toRight);
		
	sign = 1;
	if ( dot > 0 ) 
		sign = -1;
			
	// out to one side or the other slightly backwards
	chaff_dir = VectorNormalize(VectorScale( vec_toForward, -0.2 ) + VectorScale( vec_toRight, sign ));
		
	velocity = VectorScale( chaff_dir, RandomIntRange(400, 600));
	velocity = (velocity[0], velocity[1], velocity[2] - RandomIntRange(10, 100) );
	
	self.chaff_target = spawn( "script_model", self.chaff_fx.origin );
	self.chaff_target SetModel( "tag_origin" );
	self.chaff_target MoveGravity( velocity, 5.0 );
	
	// need to give the particle effect time to finish
	self.chaff_fx thread delete_after_time( 5.0 );
		
	//Play the particle on this new spawned entity
	wait(0.1); // must wait a bit because of the bug where a new entity has its events ignored on the client side
	
	n_odds = 10;
	
	if ( self.vehicletype == "heli_hind_afghan" )
	{
		n_odds = 10;
	}
	
	else if ( self.vehicletype == "heli_hip" )
	{
		n_odds = 20;
	}
		
	n_chance = RandomInt( n_odds );
		
	if ( n_chance < 2 )
	{
		self.chaff_fx thread play_flares_fx();
		
		missile Missile_SetTarget( self.chaff_target );
		
		wait 0.5;
	
		if ( IsDefined(self.chaff_target) )
		{
			self.chaff_target Delete();
		}
		
		if ( IsDefined( missile ) )
		{
			missile Missile_SetTarget( undefined );
		}
				
		wait 1;
	
		if ( IsDefined( missile ) )
		{
			missile ResetMissileDetonationTime( 0 );
		}
	}	
}


play_flares_fx()
{
	self endon( "death" );
	
	for ( i = 0; i < 3; i++ )
	{
		PlayFXOnTag( level._effect[ "aircraft_flares" ], self, "tag_origin" );
		self playsound ( "veh_huey_chaff_explo_npc" );
		wait 0.25;
	}
}


hind_evade()
{
	self endon( "death" );
	
	while ( 1 )
	{
		level.player waittill( "missile_fire", missile );
		
		if ( level.player.stingerTarget == self )
		{
			self thread hind_deploy_flares( missile );

			break;			
		}
	}
}


hind_deploy_flares( missile )
{
	self endon( "death" );
	
	self notify( "evade" );
	
	if ( !IsDefined( missile ) )
		return;
		
	vec_toForward = anglesToForward( self.angles );
	vec_toRight = AnglesToRight( self.angles );
		
	self.chaff_fx = spawn( "script_model", self.origin );
	self.chaff_fx.angles = (0,180,0);
	self.chaff_fx SetModel( "tag_origin" );
	self.chaff_fx LinkTo( self , "tag_origin", ( 0, 0, -120 ), ( 0, 0, 0 ) );
		
	delta = self.origin - missile.origin;
	dot = VectorDot(delta,vec_toRight);
		
	sign = 1;
	if ( dot > 0 ) 
		sign = -1;
			
	chaff_dir = VectorNormalize(VectorScale( vec_toForward, -0.2 ) + VectorScale( vec_toRight, sign ));
		
	velocity = VectorScale( chaff_dir, RandomIntRange(400, 600));
	velocity = (velocity[0], velocity[1], velocity[2] - RandomIntRange(10, 100) );
	
	self.chaff_target = GetEnt( "fx_statue_target", "targetname" );
	
	self.chaff_fx thread delete_after_time( 5.0 );
		
	wait(0.1);
	
	self.chaff_fx thread play_flares_fx();
		
	missile Missile_SetTarget( self.chaff_target );
	
	wait( 5 );
	
	if ( IsDefined( self.chaff_target ) )
	{
		self.chaff_target Delete();
	}
	
	self.statue_target = false;
}


fxanim_statue()
{
	m_clip = GetEnt( "bp3_statue_clip", "targetname" );
	
	m_clip SetCanDamage( true );
	
	while( 1 )
	{
		m_clip waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		if ( type == "MOD_PROJECTILE" )
		{
			level notify( "fxanim_statue_crumble_start" );
			
			break;
		}
	}
}


fxanim_statue_entrance()
{
	m_clip = GetEnt( "bp3_statue_clip_entrance", "targetname" );
	
	m_clip SetCanDamage( true );
	
	while( 1 )
	{
		m_clip waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		if ( type == "MOD_PROJECTILE" )
		{
			level notify( "fxanim_statue_lrg_crumble_start" );
			
			break;
		}
	}
}


fxanim_statue_end()
{
	m_clip = GetEnt( "bp3_statue_clip_end", "targetname" );
	
	m_clip SetCanDamage( true );
	
	while( 1 )
	{
		m_clip waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		if ( type == "MOD_PROJECTILE" )
		{
			level notify( "fxanim_statue_02_crumble_start" );
			
			break;
		}
	}
}


heli_select_death()
{
	self endon( "death" );
	
	n_index = RandomInt( 5 );
	
	self thread heli_handle_challenge_death();
	
	if ( !n_index )
	{
		self.overrideVehicleDamage = ::heli_vehicle_damage;
	}
	
	else
	{
		self.overrideVehicleDamage = ::sticky_grenade_damage;	
	}
	
	n_index = undefined;
}

// send challenge related notifies
heli_handle_challenge_death()
{
	// custom notify used since vehicledamageoverride func will clear additional parameters since custom deaths are used with explosives...
	// this should be cleaned up after milestone. -TJanssen
	self waittill( "check_helicopter_death", attacker, weapon );  
	
	if ( IsDefined( attacker ) && ( IsPlayer( attacker ) ) )
	{
	    // sticky grenade kill	
		if( weapon == "sticky_grenade_afghan_sp" )
		{
			level notify( "helo_destroyed_by_grenade" );
		}
		
		// killed by pickup with turret
		if ( weapon == "civ_pickup_turret_afghan" )
		{
			level notify( "killed_heli_with_truck_mg" );
		}
		
		// rpg kill
		if( weapon == "rpg_player_sp" )
		{
			level notify( "helo_shot_down_by_rpg" );
		}
		
		// blocking point 2 helicopter
		if ( IsDefined( self.is_bp2_heli ) )
		{
			level notify( "blocking_point_2_heli_shot_down" );
		}	
	}
}

hind_vehicle_damage( eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if ( IsSubStr( sWeapon, "hind" ) )
	{
		iDamage = 0;
	}
	
	else if ( IsSubStr( sWeapon, "rpg" ) || IsSubStr( sWeapon, "stinger" ) )
	{
		self notify( "check_helicopter_death", eAttacker, sWeapon );
		iDamage = 1;
		
		m_explode = spawn( "script_model", self.origin );
		m_explode SetModel( "tag_origin" );
		m_explode linkto( self, "tag_origin" );
		
		PlayFXOnTag( level._effect[ "explosion_midair_heli" ], m_explode, "tag_origin" );
		
		wait 0.1;
			
		VEHICLE_DELETE( self );
		
		wait 5;
		
		m_explode Delete();
	}
	
	else if ( IsSubStr( sWeapon, "sticky" ) )
	{
		iDamage = 1;
		
		self notify( "check_helicopter_death", eAttacker, sWeapon );
		eInflictor waittill( "death" );
		
		RadiusDamage( self.origin, 32, self.health, self.health );	
	}
	
	// custom case for turret deaths. 'none' can be sent by giant hurt trigger that helicopters can fly into for 10k damage
	if ( ( self.health - iDamage < 1 ) && ( sWeapon != "none" ) )
	{
		self notify( "check_helicopter_death", eAttacker, sWeapon );
	}
	
	return iDamage;
}


heli_vehicle_damage( eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if ( sWeapon == "rpg_player_sp" || sWeapon == "afghanstinger_ff_sp" || sWeapon == "afghanstinger_sp" || type == "MOD_EXPLOSIVE" )
	{
		self notify( "check_helicopter_death", eAttacker, sWeapon );
		iDamage = 1;
		
		m_explode = spawn( "script_model", self.origin );
		m_explode SetModel( "tag_origin" );
		m_explode linkto( self, "tag_origin" );
		
		PlayFXOnTag( level._effect[ "explosion_midair_heli" ], m_explode, "tag_origin" );
		
		wait 0.1;
			
		VEHICLE_DELETE( self );
		
		wait 5;
		
		m_explode Delete();
	}
	
	if ( IsSubStr( sWeapon, "sticky" ) )
	{
		self notify( "check_helicopter_death", eAttacker, sWeapon );
		iDamage = 1;
		
		eInflictor waittill( "death" );
		
		if ( IsDefined( self.dropoff_heli ) )
		{
			m_explode = spawn( "script_model", self.origin );
			m_explode SetModel( "tag_origin" );
			m_explode linkto( self, "tag_origin" );
			
			PlayFXOnTag( level._effect[ "explosion_midair_heli" ], m_explode, "tag_origin" );
			
			wait 0.1;
				
			VEHICLE_DELETE( self );
			
			wait 5;
			
			m_explode Delete();
		}
		
		else
		{
			RadiusDamage( self.origin, 100, 500, 500 );
		}
	}
	
	// custom case for turret deaths. 'none' can be sent by giant hurt trigger that helicopters can fly into for 10k damage
	if ( ( self.health - iDamage < 1 ) && ( sWeapon != "none" ) )
	{
		self notify( "check_helicopter_death", eAttacker, sWeapon );
	}
	
	return iDamage;
}


sticky_grenade_damage( eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if ( IsSubStr( sWeapon, "sticky" ) )
	{
		self notify( "check_helicopter_death", eAttacker, sWeapon );
		
		iDamage = 1;
		
		n_grenade_damage = 100;
		
		if ( self.vehicletype == "apc_btr60" || self.vehicletype == "heli_hind_afghan" || self.vehicletype == "heli_hip" || self.vehicletype == "jeep_uaz" || self.vehicletype == "heli_hip_afghanistan_land" )
		{
			eInflictor waittill( "death" );
			
			if ( self.vehicletype == "heli_hind_afghan" || self.vehicletype == "heli_hip" || self.vehicletype == "heli_hip_afghanistan_land" )
			{
				RadiusDamage( self.origin, 32, 500, 500 );
			}
			
			else
			{
				RadiusDamage( self.origin, 32, n_grenade_damage, n_grenade_damage );
				
				play_fx( "tank_dmg", self.origin, self.angles, undefined, true, "tag_origin" );
			}
		}
	}
	
	else if ( IsSubStr( sWeapon, "tc6_mine" ) )
	{
		self notify( "check_helicopter_death", eAttacker, sWeapon );	
		
		iDamage = 1;
		
		n_grenade_damage = 400;
		
		if ( self.vehicletype == "apc_btr60" || self.vehicletype == "heli_hind_afghan" || self.vehicletype == "heli_hip" || self.vehicletype == "jeep_uaz" || self.vehicletype == "heli_hip_afghanistan_land" )
		{
			eInflictor waittill( "death" );
			
			RadiusDamage( self.origin, 32, n_grenade_damage, n_grenade_damage );
			
			play_fx( "tank_dmg", self.origin, self.angles, undefined, true, "tag_origin" );
		}
	}
	
	else if ( IsSubStr( sWeapon, "afghanstinger" ) )
	{
		self notify( "check_helicopter_death", eAttacker, sWeapon );
		
		iDamage = 1;
		
		eInflictor waittill( "death" );
		
		RadiusDamage( self.origin, 32, self.health, self.health );
	}
	
	else if ( IsSubStr( sWeapon, "rpg" ) )
	{
		self notify( "check_helicopter_death", eAttacker, sWeapon );	
		iDamage = 1;
		
		n_grenade_damage = 1000;
		
		eInflictor waittill( "death" );
			
		RadiusDamage( self.origin, 32, self.health, self.health );
	}
	
	// custom case for turret deaths. 'none' can be sent by giant hurt trigger that helicopters can fly into for 10k damage
	if ( ( self.health - iDamage < 1 ) && ( sWeapon != "none" ) )
	{
		self notify( "check_helicopter_death", eAttacker, sWeapon );
	}	
	
	return iDamage;
}


tank_damage( eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if ( IsSubStr( sWeapon, "sticky" ) )
	{
		iDamage = 1;
		
		n_grenade_damage = 400;
		
		eInflictor waittill( "death" );
			
		RadiusDamage( self.origin, 32, n_grenade_damage, n_grenade_damage );
		
		play_fx( "tank_dmg", self.origin, self.angles, undefined, true, "tag_origin" );
	}
	
	else if ( IsSubStr( sWeapon, "tc6_mine" ) )
	{
		iDamage = 1;
		
		n_grenade_damage = 400;
		
		eInflictor waittill( "death" );
		
		// since RadiusDamage does damage here, send failsafe notify
		if ( self.health - n_grenade_damage < 1 )
		{
			level notify( "tank_destroyed_by_mine" );
		}	
			
		RadiusDamage( self.origin, 32, n_grenade_damage, n_grenade_damage );
		
		play_fx( "tank_dmg", self.origin, self.angles, undefined, true, "tag_origin" );
	}
	
	else if ( IsSubStr( sWeapon, "afghanstinger" ) )
	{
		iDamage = 1;
		
		n_grenade_damage = 1000;
		
		eInflictor waittill( "death" );
		
		RadiusDamage( self.origin, 32, n_grenade_damage, n_grenade_damage );
		
		play_fx( "tank_dmg", self.origin, self.angles, undefined, true, "tag_origin" );
	}
	
	else if ( IsSubStr( sWeapon, "rpg" ) )
	{
		iDamage = 1;
		
		n_grenade_damage = 1000;
		
		eInflictor waittill( "death" );	
			
		RadiusDamage( self.origin, 32, n_grenade_damage, n_grenade_damage );
		
		play_fx( "tank_dmg", self.origin, self.angles, undefined, true, "tag_origin" );
	}
	
	return iDamage;
}



horse_damage( eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if ( type == "MOD_PROJECTILE" )
	{
		iDamage = 1;
		
		n_damage = 5000;
		
		RadiusDamage( self.origin, 32, n_damage, n_damage );
	}
	
	return iDamage;
}


delete_after_time( n_time )
{
	self endon( "death" );
	wait n_time;
	self delete();
}


tank_targetting()
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	while ( 1 )
	{
		a_guys = getaiarray( "allies" );
		
		for ( i = 0; i < a_guys.size; i++ )
		{
			if ( Distance2D( self.origin, a_guys[ i ].origin ) <= 5000 )
			{
				b_canshoot = SightTracePassed( ( self GetTagOrigin( "tag_flash" ) ), a_guys[ i ].origin, true, undefined );
				
				if ( b_canshoot )
				{
					e_target = a_guys[ i ];
					break;
				}
			}
		}
		
		if ( RandomInt( 3 ) == 0 )
		{
			e_target = level.player;	
		}
		
		if ( IsDefined( level.muj_tank ) && ( Distance2D( self.origin, level.muj_tank.origin ) <= 5000 ) )
		{
			//b_sightpassed = SightTracePassed( self.origin, level.muj_tank.origin, true, undefined );
			//b_bulletpassed = BulletTracePassed( self.origin, level.muj_tank.origin, true, undefined );
			
			b_sightpassed = true;
			b_bulletpassed = true;
			
			if ( b_sightpassed || b_bulletpassed )
			{
				e_target = level.muj_tank;
			}
		}
		
		if ( IsDefined( e_target ) )
		{
			self SetTargetEntity( e_target );
			
			self waittill( "turret_on_target" );
			
			wait 1;
		
			if ( IsDefined( e_target ) )
			{
				self shoot_turret_at_target_once( e_target, ( RandomIntRange( -99, 99 ), RandomIntRange( -99, 99 ), RandomIntRange( -32, 80 ) ), 0 );
			
				wait RandomFloatRange( 2.5, 4.0 );
				
				self ClearTargetEntity();
			}
		}
		
		wait RandomIntRange( 2, 5 );
	}
}


projectile_fired_at_tank( e_cache )
{
	self endon( "death" );
	self endon( "stop_projectile_check" );
	
	while( 1 )
	{
		level.player waittill( "missile_fire", missile );
			
		self notify( "stop_attack" );
			
		wait 2;
			
		self SetTargetEntity( level.player );
			
		self waittill( "turret_on_target" );
		
		wait 1;
			
		self shoot_turret_at_target_once( level.player, ( RandomIntRange( -99, 99 ), RandomIntRange( -99, 99 ), RandomIntRange( -32, 80 ) ), 0 );
			
		wait 2;
			
		self ClearTargetEntity();
		
		if ( IsDefined( e_cache ) )
		{
			self thread attack_cache_tank( e_cache );
		}
		
		else
		{
			self thread tank_targetting();
		}
	}
}


attack_cache_tank( e_cache )
{
	self endon( "death" );
	self endon( "stop_attack" );
		
	while ( 1 )
	{
		e_target = e_cache;
		
		if ( RandomInt( 3 ) == 0 )
		{
			e_target = level.player;	
		}
		
		if ( Distance2D( self.origin, e_target.origin ) <= 5000 )
		{
			self SetTargetEntity( e_target );
			
			self waittill( "turret_on_target" );
			
			wait 1;
		
			self FireWeapon();
		
			wait 2;
		
			self ClearTargetEntity();
		}
		
		wait RandomFloatRange( 2.0, 3.0 );
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
		
		wait RandomIntRange( 3, 6 );
	}
}


btr_attack()
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	while( 1 )
	{
		a_guys = getaiarray( "allies" );
		
		for ( i = 0; i < a_guys.size; i++ )
		{
			e_target = a_guys[ RandomInt( a_guys.size ) ];
			
			if ( Distance2DSquared( self.origin, e_target.origin ) < ( 5000 * 5000 ) )
			{
				break;
			}
		}
		
		if ( RandomInt( 4 ) == 0 )
		{
			e_target = level.player;
		}
		
		if ( IsDefined( e_target ) )
		{
			self thread shoot_turret_at_target( e_target, -1, ( RandomIntRange( -80, 80 ), RandomIntRange( -80, 80 ), RandomIntRange( -80, 80 ) ), 1 );
			
			wait RandomFloatRange( 3.0, 5.0 );
			
			self stop_turret( 1 );
		}
		
		wait RandomFloatRange( 3.0, 5.0 );
	}
}


btr_set_target( e_target, n_time )
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	while( 1 )
	{
		self set_turret_target( e_target, ( RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ) ), 1 );
				
		wait 5;
	}
}


projectile_fired_at_btr( e_cache )
{
	self endon( "death" );
	self endon( "stop_projectile_check" );
	
	while( 1 )
	{
		level.player waittill( "missile_fire", missile );
			
		self notify( "stop_attack" );
			
		wait 2;
		
		self set_turret_target( level.player, ( RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ) ), 1 );
		
		self fire_turret_for_time( RandomIntRange( 3, 6 ), 1 );
				
		if ( IsDefined( e_cache ) )
		{
			self thread attack_cache_btr( e_cache );
		}
		
		else
		{
			self thread btr_attack();
		}
	}
}


attack_cache_btr( e_cache )
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	while ( 1 )
	{
		if ( IsDefined( e_cache ) )
		{
			self set_turret_target( e_cache, ( RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ) ), 1 );
		
			self fire_turret_for_time( RandomIntRange( 3, 6 ), 1 );
		}
				
		wait RandomFloatRange( 5.0, 7.0 );
	}
}


hip_attack_cache( e_cache )
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	self set_turret_target( e_cache, ( RandomInt( 64 ), RandomInt( 64 ), RandomInt( 64 ) ), 2 );
	
	while( 1 )
	{
		if ( IsDefined( e_cache ) )
		{
			self thread fire_turret_for_time( RandomIntRange( 3, 6 ), 2 );
		}
		
		wait RandomFloatRange( 5.0, 7.0 );
	}
}


hip_circle( s_start )
{
	self endon( "death" );
	self endon( "stop_circle" );
	
	self SetSpeed( 50, 25, 20 );
	
	s_goal = s_start;
	
	while( 1 )
	{
		self setvehgoalpos( s_goal.origin );
		self waittill_any( "goal", "near_goal" );
		
		s_goal = getstruct( s_goal.target, "targetname" );
	}
}


hip_attack()
{
	self endon( "death" );
	self endon( "stop_attack" );
	
	while( 1 )
	{
		a_guys = getaiarray( "allies" );
		
		for ( i = 0; i < a_guys.size; i++ )
		{
			if ( Distance2DSquared( self.origin, a_guys[ i ].origin ) < ( 5000 * 5000 ) )
			{
				e_target = a_guys[ i ];
				break;
			}
		}
		
		if ( RandomInt( 5 ) == 0 )
		{
			e_target = level.player;
		}
		
		if ( IsDefined( e_target ) )
		{
			self set_turret_target( e_target, ( RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ) ), 2 );
		}
			
		if ( IsAlive( e_target ) )
		{
			if ( IsDefined( e_target.crew ) )
			{
				self fire_turret_for_time( RandomIntRange( 3, 6 ), 2 );
			}
			
			else
			{
				self fire_turret_for_time( RandomIntRange( 3, 6 ), 2 );
			}
		}
		
		wait RandomFloatRange( 3.0, 5.0 );
	}
}


delete_corpse_bp1()
{
	flag_wait( "wave2_started" );	
	
	if ( IsDefined( self ) )
	{
		VEHICLE_DELETE( self );
	}
}


delete_corpse_wave2()
{
	flag_wait( "wave3_started" );
	
	if ( IsDefined( self ) )
	{
		VEHICLE_DELETE( self );
	}
}


delete_corpse_wave3()
{
	flag_wait( "wave4_started" );
	
	if ( IsDefined( self ) )
	{
		VEHICLE_DELETE( self );
	}
}


delete_corpse_arena()
{
	flag_wait( "blocking_done" );
	
	if ( IsDefined( self ) )
	{
		VEHICLE_DELETE( self );
	}
}


set_dropoff_flag_ondeath( str_flag )
{
	self waittill( "death" );
	
	flag_set( str_flag );
}


set_flag_ondeath( str_flag )
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


nag_destroy_vehicle()
{
//	level endon( "all_veh_destroyed" );
//	self endon( "death" );
//	
//	wait 12;
//	
//	while( 1 )
//	{
//		if ( cointoss() )
//		{
//			if ( self.vehicletype == "apc_btr60" )
//			{
//				level.zhao say_dialog( "zhao_kill_the_btr_0" );
//			}
//							
//			else if ( self.vehicletype == "heli_hip" || self.vehicletype == "heli_hind_afghan" )
//			{
//				level.zhao say_dialog( "zhao_take_out_that_choppe_0" );
//			}
//					
//			else if ( self.vehicletype == "tank_t62" )
//			{
//				level.zhao say_dialog( "zhao_destroy_the_tanks_0" );
//			}
//		}
//			
//		else
//		{
//			if ( cointoss() )
//			{
//				level.zhao say_dialog( "wood_concentrate_your_fir_0" );
//			}
//				
//			else
//			{
//				level.zhao say_dialog( "wood_destroy_all_of_the_v_0" );
//			}
//		}
//			
//		wait RandomIntRange( 30, 40 );
//	}
}


crew_sniper_logic()
{
	self endon( "death" );
	self endon( "crew_sleep" );
	
	n_sniper_range = 2800;
	a_tags = [];
	
	a_tags[ 0 ] = "J_SpineLower";
	a_tags[ 1 ] = "J_Knee_LE";
	a_tags[ 2 ] = "J_SpineUpper";
	a_tags[ 3 ] = "J_Neck";
	a_tags[ 4 ] = "J_Head";
	
	while( 1 )
	{
		a_ai_targets = getaiarray( "axis" );
		
		if ( a_ai_targets.size )
		{
			a_targets = sort_by_distance( a_ai_targets, level.player.origin );
			
			for( i = ( a_targets.size - 1 ); i >= 0; i-- )
			{
				if ( IsAlive( a_targets[ i ] ) && self CanSee( a_targets[ i ] ) )
				{
					ai_target = a_targets[ i ];
					break;
				}
			}
			
			if ( IsAlive( ai_target ) )
			{
				if ( Distance2DSquared( self.origin, ai_target.origin ) <= ( n_sniper_range * n_sniper_range ) )
				{
					self thread aim_at_target( ai_target );
					
					wait 1;
					
					self thread stop_aim_at_target();
					
					if ( IsAlive( ai_target ) )
					{
						v_target = ai_target GetTagOrigin( a_tags[ RandomInt( 5 ) ] );
						
						b_canshoot = BulletTracePassed( ( self GetTagOrigin( "tag_flash" ) ), v_target, true, ai_target );
						
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
		
		wait RandomFloatRange( 2.0, 3.0 );
	}
}


crew_stinger_logic()
{
	self endon( "death" );
	self endon( "crew_sleep" );
	
	n_stinger_range = 7500;
	
	while( 1 )
	{
		e_target = self stinger_crew_get_target();
		
		if ( IsDefined( e_target ) )
		{
			self stinger_crew_shoot( e_target );
		}
		
		wait RandomFloatRange( 4.0, 6.0 );
	}
}


stinger_crew_get_target()
{
	self endon( "death" );
	
	n_stinger_range = 7500;
	
	a_vh_targets = getentarray( "script_vehicle", "classname" );
			
	if ( ( a_vh_targets.size ) )
	{
		a_targets = sort_by_distance( a_vh_targets, self.origin );
			
		for ( i = a_targets.size - 1; i > 0; i-- )
		{
			if ( Distance2DSquared( self.origin, a_targets[ i ].origin ) <= ( n_stinger_range * n_stinger_range ) )
			{
				if ( a_targets[ i ].vehicletype == "heli_hind_afghan" && IsDefined( a_targets[ i ] ) )
				{
					//if ( cointoss() )
					//{
						e_target = a_targets[ i ];
						break;	
					//}
				}
				
				else if ( a_targets[ i ].vehicletype == "heli_hip" && IsDefined( a_targets[ i ] ) )
				{
					//if ( cointoss() )
					//{
						e_target = a_targets[ i ];
						break;	
					//}
				}
			}
		}
		
		return( e_target );
	}
}


stinger_crew_shoot( e_target )
{
	if ( IsDefined( e_target ) )
	{
		self thread aim_at_target( e_target );
						
		wait 3;
		
		self thread stop_aim_at_target();
						
		if ( IsDefined( e_target ) )
		{
			if ( IsDefined( e_target ) && SightTracePassed( ( self GetTagOrigin( "tag_eye" ) ), e_target.origin, false, e_target ) )	
			{
				//if ( cointoss() )
				//{
					MagicBullet( "afghanstinger_ff_sp", self GetTagOrigin( "tag_flash" ), e_target.origin, self, e_target, ( RandomInt( 100 ), RandomInt( 100 ), -32 ) );
				//}
					
				//else
				//{
				//	MagicBullet( "afghanstinger_ff_sp", self GetTagOrigin( "tag_flash" ), e_target.origin );
				//}
			}
		}
	}	
}


crew_rpg_logic()
{
	self endon( "death" );
	
	while( 1 )
	{
		e_target = self rpg_crew_get_target();
		
		if ( IsDefined( e_target ) )
		{
			self rpg_crew_shoot( e_target );
		}
		
		else
		{
			self rpg_crew_attack_ai();
		}
		
		wait RandomFloatRange( 4.0, 6.0 );
	}
}


rpg_crew_get_target()
{
	self endon( "death" );
	
	n_rpg_range = 4000;
	
	a_vh_targets = getentarray( "script_vehicle", "classname" );
			
	if ( ( a_vh_targets.size ) )
	{
		a_targets = sort_by_distance( a_vh_targets, self.origin );
			
		for ( i = a_targets.size - 1; i > 0; i-- )
		{
			if ( Distance2DSquared( self.origin, a_targets[ i ].origin ) <= ( n_rpg_range * n_rpg_range ) )
			{
				if ( a_targets[ i ].vehicletype == "tank_t62" && isAlive( a_targets[ i ] ) )
				{
					e_target = a_targets[ i ];
					break;	
				}
					
				else if ( a_targets[ i ].vehicletype == "apc_btr60" && isAlive( a_targets[ i ] ) )
				{
					e_target = a_targets[ i ];
					break;	
				}
				
				else if ( a_targets[ i ].vehicletype == "heli_hind_afghan" && isAlive( a_targets[ i ] ) )
				{
					if ( cointoss() )
					{
						e_target = a_targets[ i ];
						break;	
					}
				}
				
				else if ( a_targets[ i ].vehicletype == "heli_hip" && isAlive( a_targets[ i ] ) )
				{
					if ( cointoss() )
					{
						e_target = a_targets[ i ];
						break;	
					}
				}
			}
		}
		
		return( e_target );
	}
}


rpg_crew_attack_ai( n_range )
{
	self endon( "death" );
	
	n_rpg_range = 4000;
	
	a_ai_targets = getaiarray( "axis" );
		
	if ( a_ai_targets.size )
	{
		while( 1 )
		{
			a_ai_targets = getaiarray( "axis" );
			
			if ( a_ai_targets.size )
			{
				ai_target = a_ai_targets[ RandomInt( a_ai_targets.size ) ];
					
				if ( IsDefined( ai_target ) )
				{
					if ( Distance2DSquared( self.origin, ai_target.origin ) <= ( n_rpg_range * n_rpg_range ) )
					{
						e_target = ai_target;
						
						self rpg_crew_shoot( e_target );
						
						break;
					}
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
			MagicBullet( "rpg_magic_bullet_sp", self GetTagOrigin( "tag_flash" ), e_target.origin + ( RandomIntRange( -300, 300 ), RandomIntRange( -300, 300 ), RandomIntRange( 0, 150 ) ) );
		}
		
		self thread stop_aim_at_target();
	}	
}


//crew_monitor()
//{
//	self endon( "death" );
//	
//	self thread crew_counter( self.crew_type );
//	
//	self.health = 10000;
//	
//	b_under_attack = false;
//	b_at_risk = false;
//
//	while( 1 )
//	{
//		self waittill( "damage" );
//		
//		if ( self.health < 9750 && !b_under_attack )
//		{
//			self say_dialog( "wood_the_crew_is_under_at_0" );
//			
//			b_under_attack = true;
//		}
//		
//		
//		if ( self.health < 8000 && !b_at_risk )
//		{
//			self say_dialog( "wood_the_crew_is_taking_h_0" );
//			
//			wait 1;
//			
//			self say_dialog( "wood_protect_the_crew_0" );
//			
//			b_at_risk = true;
//		}
//		
//		if ( self.health < 7000 )
//		{
//			self notify( "crew_dead" );
//			self remove_crew_model();
//			self.ai_spotter stop_magic_bullet_shield();
//			self.ai_spotter die();
//			self die();
//		}
//		
//		//iprintlnbold( "crew health = " +self.health	);
//	}
//}


crew_counter( str_type )
{
	self waittill( "crew_dead" );
	
	if ( str_type == "sniper" )
	{	
		level.crew_remaining[ 0 ]--;
		
		level.zhao say_dialog( "wood_we_ve_lost_the_snipe_0" );
		
		if ( level.crew_remaining[ 0 ] )
		{
			level.zhao say_dialog( "wood_deploy_another_crew_0", 1 );
			
			level.zhao say_dialog( "omar_we_have_one_more_sni_0", 1 );
		}
		
		else
		{
			level.zhao say_dialog( "omar_that_s_the_last_of_t_0", 1 );
		}
	}
	
	else if ( str_type == "rpg" )
	{
		level.crew_remaining[ 1 ]--;
		
		level.zhao say_dialog( "wood_we_ve_lost_the_rpg_c_0" );
		
		if ( level.crew_remaining[ 0 ] )
		{
			level.zhao say_dialog( "omar_we_have_one_more_rpg_0", 1 );
			
			level.zhao say_dialog( "wood_deploy_another_crew_0", 1 );
		}
		
		else
		{
			level.zhao say_dialog( "omar_that_s_the_last_of_t_1", 1 );
		}
	}
	
	else
	{
		level.crew_remaining[ 2 ]--;
		
		level.zhao say_dialog( "wood_we_ve_lost_the_sting_0" );
		
		if ( level.crew_remaining[ 0 ] )
		{
			level.zhao say_dialog( "omar_we_have_one_more_sti_0", 1 );
			
			level.zhao say_dialog( "wood_deploy_another_crew_0", 1 );
		}
		
		else
		{
			level.zhao say_dialog( "omar_that_s_the_last_of_t_2", 1 );
		}
	}
}


muj_tank_behavior()
{
	self endon( "death" );
	
	self thread track_muj_tank_death();
	self SetVehicleAvoidance( true );
	
	while ( 1 )
	{
		tank_target = get_vehicle_target();
		
		if ( IsDefined( tank_target ) )
		{
			self SetTargetEntity( tank_target );
			
			self waittill( "turret_on_target" );
			
			wait 1;
			
			if ( IsDefined( tank_target ) )
			{
				self shoot_turret_at_target_once( tank_target, ( RandomIntRange( -99, 99 ), RandomIntRange( -99, 99 ), RandomIntRange( -32, 80 ) ), 0 );
			}
		}
		
		else
		{
			ai_target = get_ai_target();
			
			if ( IsDefined( ai_target ) )
			{
				self SetTargetEntity( ai_target );
				
				self waittill( "turret_on_target" );
			
				wait 1;
				
				if ( IsAlive( ai_target ) )
				{
					self shoot_turret_at_target_once( ai_target, ( RandomIntRange( -99, 99 ), RandomIntRange( -99, 99 ), RandomIntRange( -32, 80 ) ), 0 );
				}				
			}
		}
				
		wait RandomFloatRange( 5, 8 );
	}
}

track_muj_tank_death()
{
	self waittill("death");
	level.player.tank_button_off = true;
	level.tank_piece.origin = level.hold_map_items.origin;
}


get_vehicle_target()
{
	self endon( "death" );
	
	a_targets = getentarray( "script_vehicle", "classname" );
	
	vh_target = array_exclude( a_targets, self );
	
	if ( ( vh_target.size ) )
	{
		for( i = 0; i < vh_target.size; i++ )
		{
			if ( Distance2D( self.origin, vh_target[ i ].origin ) < 5000 )
			{
				b_sightpassed = SightTracePassed( self GetTagOrigin( "tag_flash" ), vh_target[ i ].origin, true, vh_target[ i ] );
				b_bulletpassed = BulletTracePassed( self GetTagOrigin( "tag_flash" ), vh_target[ i ].origin, true, vh_target[ i ] );
				
				if ( vh_target[ i ].vehicletype == "tank_t62" )
				{
					if ( b_sightpassed || b_bulletpassed )
					{
						return vh_target[ i ];
						break;
					}
				}
				
				else if ( vh_target[ i ].vehicletype == "apc_btr60" )
				{
					if ( b_sightpassed || b_bulletpassed )
					{
						return vh_target[ i ];
						break;
					}
				}
				
				else if ( vh_target[ i ].vehicletype == "jeep_uaz" )
				{
					if ( b_sightpassed || b_bulletpassed )
					{
						return vh_target[ i ];
						break;
					}
				}
			}
		}
	}
}


get_ai_target()
{
	self endon( "death" );
	
	a_ai_enemies = getaiarray( "axis" );
		
	if ( a_ai_enemies.size )
	{
		for( i = 0; i < a_ai_enemies.size; i++ )
		{
			if ( Distance2D( self.origin, a_ai_enemies[ i ].origin ) < 5000 )
			{
				b_sightpassed = SightTracePassed( self.origin, a_ai_enemies[ i ].origin, true, a_ai_enemies[ i ] );
				b_bulletpassed = BulletTracePassed( self.origin, a_ai_enemies[ i ].origin, true, a_ai_enemies[ i ] );
			
				if ( b_sightpassed || b_bulletpassed )
				{
					if ( IsAlive( a_ai_enemies[ i ] ) )
					{
						return a_ai_enemies[ i ];
						break;
					}
				}
			}
		}
	}	
}


monitor_base_health()
{
	level endon( "blocking_done" );
	
	t_dmg = GetEnt( "trigger_base_health", "targetname" );
	
	t_dmg waittill( "damage" );
	
	//level.zhao say_dialog( "wood_the_base_is_under_at_0" );
	
	t_dmg waittill( "trigger" );
	
	//level.zhao say_dialog( "zhao_keep_those_tanks_fro_0" );
		
	wait 0.5;
		
	//level.zhao say_dialog( "zhao_keep_those_helicopte_0" );
	
	t_dmg waittill( "trigger" );
	
	//level.zhao say_dialog( "wood_we_can_t_take_much_m_0" );
	
	t_dmg waittill( "trigger" );
	
	//level.zhao say_dialog( "wood_it_s_too_late_we_v_0" );
		
	wait 2;
	
	missionfailedwrapper( &"AFGHANISTAN_PROTECT_FAILED" );
}

too_far_fail_managment( str_end_flag )
{
	if( isdefined( str_end_flag ) )
	{
		level endon(str_end_flag);
	}	
	
	trigger_array = GetEntArray("player_too_far_trigger", "targetname");
	
	for(i = 0; i < trigger_array.size; i++)
	{
		trigger_array[i] thread touching_fail_trigger( str_end_flag );
	}
}

touching_fail_trigger( str_end_flag )
{
	if( isdefined( str_end_flag ) )
	{
		level endon(str_end_flag);
	}
	self endon( "death" );
	
	const n_duration_max = 6;
	
	n_duration = n_duration_max;
	
	while(n_duration > 0)
	{
		if( level.player IsTouching(self) )
		{
			n_duration -= 1;
		}
		else
		{
			n_duration = n_duration_max;
		}
		
		//Fire vo immediately and with a few seconds remaining
		if( n_duration + 1 == n_duration_max || ( n_duration == 3 ) )
		{
			if( cointoss() )
			{
				level.woods say_dialog( "wood_stay_with_me_mason_0" );  //Stay with me, Mason.
			}
			else
			{
				level.woods say_dialog( "wood_where_the_hell_you_g_0" );  //Where the Hell you goin'?
			}
		}
		wait 1;
	}
	
	missionfailedwrapper( &"AFGHANISTAN_DISTANCE_FAILED" );
}

insta_fail_trigger( str_end_flag )
{
	if( isdefined( str_end_flag ) )
	{
		level endon(str_end_flag);
	}
	self endon( "death" );

	self waittill( "trigger" );
	
	missionfailedwrapper( &"AFGHANISTAN_DISTANCE_FAILED" );
}


vehicle_route( s_start )
{
	self endon( "vehicle_stop" );
	self endon( "death" );
	
	self setvehgoalpos( s_start.origin, 0 );
	
	if ( IsDefined( s_start.target ) )
	{
		s_next_pos = getstruct( s_start.target, "targetname" );
	}
	
	if ( IsDefined( s_next_pos ) )
	{
		v_next_pos = s_next_pos.origin;
		
		while( 1 )
		{
			self setvehgoalpos( v_next_pos, 0 );
			
			self waittill_any( "goal", "near_goal" );
			
			if ( IsDefined( s_next_pos.target ) )
			{
				s_next_pos = getstruct( s_next_pos.target, "targetname" );
				v_next_pos = s_next_pos.origin;
			}
			else
			{
				VEHICLE_DELETE( self );
			}
		}
	}
}

fire_magic_bullet_rpg( str_struct_name, v_fire_at_origin , v_fire_at_offset )
{
	if( ! IsDefined( v_fire_at_offset ) )
	{
		v_fire_at_offset = ( 0, 0, 0 );
	}
	
	s_fire_from = getstruct( str_struct_name , "targetname");
	e_rpg = MagicBullet("rpg_magic_bullet_sp", s_fire_from.origin, v_fire_at_origin + v_fire_at_offset);
	e_rpg = undefined;
}

fire_magic_bullet_huey_rocket( str_struct_name, v_fire_at_origin , v_fire_at_offset )
{
	if( ! IsDefined( v_fire_at_offset ) )
	{
		v_fire_at_offset = ( 0, 0, 0 );
	}
	
	s_fire_from = getstruct( str_struct_name , "targetname");
	e_rocket = MagicBullet("stinger_sp", s_fire_from.origin, v_fire_at_origin + v_fire_at_offset);
	
	e_rocket = undefined;
}

play_mortar_fx( str_struct_name, sound_name )
{
	s_morter = getstruct( str_struct_name, "targetname");
	PlayFX( level._effect[ "explode_mortar_sand" ], s_morter.origin );
	
	if(isdefined(sound_name))
	{
		playsoundatposition(sound_name, s_morter.origin);
	}
	
	return s_morter;
}

vehicle_go_path_on_node( str_vehicle_node, str_vehicle_spawner )
{
	if( IsDefined( str_vehicle_spawner ) && !flag( "horse_charge_finished" ) )
	{
		vh_spawned = spawn_vehicle_from_targetname( str_vehicle_spawner );	
		vh_spawned thread go_path( GetVehicleNode( str_vehicle_node, "targetname" ) );
		
		return vh_spawned;
	}
	
	self thread go_path( GetVehicleNode( str_vehicle_node, "targetname" ) );
}
make_horse_unuseable()
{
	self MakeVehicleUnusable();
}

mig_shoot_down_challenge_spawn_func()
{
	self waittill( "death" );
	level notify( "mig_shot_down" );
}

old_man_woods( str_movie_name, b_trans = true )
{
	level clientnotify( "omw_on" );
	level thread old_man_woods_waittill_end();
	play_movie( str_movie_name, false, false, undefined, b_trans, "movie_done" );
}
old_man_woods_waittill_end()
{
	level waittill( "movie_done" );
	level clientnotify( "omw_off" );
}

trigger_wait_for_player_touch( str_name, str_key )
{
	assert( isdefined(level.player), "level.player not defined" );
	if ( IsDefined( str_name ) )
	{
		DEFAULT( str_key, "targetname" );
		
		trigger = GetEnt( str_name, str_key );
		Assert( isdefined( trigger ), "trigger not found: " + str_name + " key: " + str_key );
		
		while( !level.player IsTouching( trigger ) )
		{
			wait .05;	
		}
		
		level notify( str_name );
	}	
}


shake_base_lights()
{
	force_x = RandomFloatRange( 0.001, 0.005 );
	force_y = RandomFloatRange( 0.001, 0.005 );
	force_z = RandomFloatRange( 0.001, 0.005 );
	
	PhysicsJolt( (15850.7, -9946.1, -84.8), 8, 8, (force_x, force_y, force_z));
	play_shake_lights_audio( 15850.7, -9946.1, -84.8 );
	
	force_x = RandomFloatRange( 0.001, 0.005 );
	force_y = RandomFloatRange( 0.001, 0.005 );
	force_z = RandomFloatRange( 0.001, 0.005 );
	
	PhysicsJolt( (15412.7, -10106.1, -84.8), 8, 8, (force_x, force_y, force_z));
	play_shake_lights_audio( 15412.7, -10106.1, -84.8 );
	
	force_x = RandomFloatRange( 0.001, 0.005 );
	force_y = RandomFloatRange( 0.001, 0.005 );
	force_z = RandomFloatRange( 0.001, 0.005 );

	PhysicsJolt( (15832.7, -9554.1, -68.8), 8, 8, (force_x, force_y, force_z));
	play_shake_lights_audio( 15832.7, -9554.1, -68.8 );
	
	force_x = RandomFloatRange( 0.001, 0.005 );
	force_y = RandomFloatRange( 0.001, 0.005 );
	force_z = RandomFloatRange( 0.001, 0.005 );
	
	PhysicsJolt( (16028.7, -10108.1, -84.8), 8, 8, (force_x, force_y, force_z));
	play_shake_lights_audio( 16028.7, -10108.1, -84.8 );
}
play_shake_lights_audio( x, y, z )
{
	wait(randomfloatrange(0.05, 0.11) );
	playsoundatposition( "evt_mortar_explosion_indoor_shake", (x,y,z) );
}

trigger_delete( str_trigger_targetname )
{
	t_trigger = GetEnt( str_trigger_targetname, "targetname" );
	
	if ( IsDefined( t_trigger ) )
	{
		t_trigger Delete();
	}
}


///////////////////////////////////////////////////////////////////////////
//		Arena Explosions Ambience
///////////////////////////////////////////////////////////////////////////
arena_explosions()
{
	level endon( "clear_arena" );
	level endon( "stop_arena_explosions" );
	
	a_s_explosions = getstructarray( "arena_explosion_pos", "script_noteworthy" );
	
	while( 1 )
	{
		s_explosion = a_s_explosions[ RandomInt( a_s_explosions.size ) ];
		
		playsoundatposition ( "prj_mortar_launch" , ( -3127, -36443, 3469 ) );
		wait(1);
		playsoundatposition ( "prj_mortar_incoming", s_explosion.origin );
			
		wait( 0.45 );
			
		PlaySoundAtPosition( "exp_mortar", s_explosion.origin );
			
		PlayFX( level._effect[ "explode_mortar_sand" ], s_explosion.origin );
		
		level thread check_explosion_radius( s_explosion.origin );
			
		Earthquake( 0.2, 1, level.player.origin, 100 );
			
		wait RandomFloatRange( 1.0, 1.5 );
	}
}


check_explosion_radius( v_pos )
{
	a_ai_allies = GetAIArray( "allies" );
	a_ai_riders = array_exclude( a_ai_allies, level.woods );
	a_ai_muj = array_exclude( a_ai_riders, level.zhao );
	
	foreach( ai_rider in a_ai_muj )
	{
		if ( IsDefined( ai_rider ) )
		{
			if ( Distance2DSquared( v_pos, ai_rider.origin ) < ( 400 * 400 ) )
			{
				RadiusDamage( ai_rider.origin, 50, 5000, 5000 );
			}
		}
	}
	
	a_ai_allies = undefined;
	a_ai_riders = undefined;
	a_ai_muj = undefined;
}


///////////////////////////////////////////////////////////////////////////
//		Arena Enemy Squads Ambience
///////////////////////////////////////////////////////////////////////////
test_sight()
{
	e_entity = GetEnt( "muj_arena_cache7", "targetname" );
	
	while( 1 )
	{
		if ( level.player is_player_looking_at( e_entity.origin, undefined, false ) )
		{
			iprintlnbold( "can see" );
		}
		
		else
		{
			iprintlnbold( "no can see" );
		}
		
		wait 1;
	}
}

manage_arena_enemy_squads()
{
	a_e_caches = [];
	a_e_caches[ 0 ] = GetEnt( "vol_cache1", "targetname" );
	a_e_caches[ 1 ] = GetEnt( "vol_cache2", "targetname" );
	a_e_caches[ 2 ] = GetEnt( "vol_cache3", "targetname" );
	a_e_caches[ 3 ] = GetEnt( "vol_cache5", "targetname" );
	a_e_caches[ 4 ] = GetEnt( "vol_cache6", "targetname" );
		
	sp_cache1 = GetEnt( "soviet_cache1", "targetname" );
	sp_cache2 = GetEnt( "soviet_cache2", "targetname" );
	sp_cache3 = GetEnt( "soviet_cache3", "targetname" );
	sp_cache5 = GetEnt( "soviet_cache5", "targetname" );
	sp_cache6 = GetEnt( "soviet_cache6", "targetname" );
			
	a_caches = [];
	a_caches = sort_by_distance( a_e_caches, level.player.origin );
	
	if ( level.player is_on_horseback() )
	{
		n_index = a_caches.size - 1;
				
		for ( i = 0; i < a_caches.size; i++ )
		{
			n_dist = Distance2DSquared( level.player.origin, a_caches[ n_index ].origin );
			
			if ( level.player is_player_looking_at( a_caches[ n_index ].origin, undefined, false ) && n_dist > 2000 )
			{
				n_index = i;
				
				break;
			}
		}
	}
	
	else
	{
		n_index = 0;
		
		for ( i = a_caches.size - 1; i >= 0; i-- )
		{
			n_dist = Distance2DSquared( level.player.origin, a_caches[ n_index ].origin );
			
			if ( level.player is_player_looking_at( a_caches[ n_index ].origin, undefined, false ) && n_dist > 2000 )
			{
				n_index = i;
				
				break;
			}
		}
	}
	
	if ( a_caches[ n_index ].targetname == "vol_cache1" )
	{
		sp_soviet = sp_cache1;
	}
	
	else if ( a_caches[ n_index ].targetname == "vol_cache2" )
	{
		sp_soviet = sp_cache2;
	}
	
	else if ( a_caches[ n_index ].targetname == "vol_cache3" )
	{
		sp_soviet = sp_cache3;
	}
	
	else if ( a_caches[ n_index ].targetname == "vol_cache5" )
	{
		sp_soviet = sp_cache5;
	}
	
	else
	{
		sp_soviet = sp_cache6;
	}
	
	for ( i = 0; i < RandomIntRange( 3, 6 ); i++ )
	{
		ai_soviet_arena = sp_soviet spawn_ai( true );
		
		if ( IsDefined( ai_soviet_arena ) )
		{
			ai_soviet_arena.targetname = "arena_soviet";
			ai_soviet_arena.goalradius = 64;
			ai_soviet_arena SetGoalEntity( level.player );
					
			wait 0.1;
		}
	}
	
	wait 1;
	
	level thread monitor_arena_soviet();
	level thread monitor_arena_kill();
	
	a_e_caches = undefined;
	a_caches = undefined;
}


monitor_arena_soviet()
{
	level endon( "blocking_done" );
	
	while( 1 )
	{
		a_soviets = GetEntArray( "arena_soviet", "targetname" );
		
		if ( !a_soviets.size )
		{
			break;
		}
		
		wait 1;
	}
	
	wait RandomIntRange( 5, 8 );
	
	if ( !flag( "bp_underway" ) )
	{
		level thread manage_arena_enemy_squads();
	}
}


monitor_arena_kill()
{
	flag_wait( "bp_underway" );
	
	a_soviets = GetEntArray( "arena_soviet", "targetname" );
		
	if ( a_soviets.size )
	{
		wait RandomFloatRange( 0.5, 2.0 );
		
		if ( IsDefined( a_soviets[ 0 ] ) )
		{
			playsoundatposition ( "prj_mortar_incoming", a_soviets[ 0 ].origin );
				
			wait 0.45;
			
			ai_soviet = a_soviets[ RandomInt( a_soviets.size ) ];
			
			if ( IsDefined( ai_soviet ) )
			{
				PlayFX( level._effect[ "explode_mortar_sand" ], ai_soviet.origin );
					
				Earthquake( 0.2, 1, level.player.origin, 100 );	
	
				PlaySoundAtPosition( "exp_mortar", ai_soviet.origin );
			}
		
			foreach( ai_soviet in a_soviets )
			{
				if ( IsDefined( ai_soviet ) )
				{
					PlaySoundAtPosition( "exp_small_scripted", ai_soviet.origin );
				
					PlayFX( level._effect[ "explode_grenade_sand" ], ai_soviet.origin );
				
					RadiusDamage( ai_soviet.origin, 60, 200, 150, undefined, "MOD_PROJECTILE" );
				}
			}
		}
	}
}


manage_arena_muj_squads( vol_cache )
{
	a_sp_spawners = [];
	a_sp_spawners[ 0 ] = GetEnt( "muj_arena_cache1", "targetname" );
	a_sp_spawners[ 1 ] = GetEnt( "muj_arena_cache2", "targetname" );
	a_sp_spawners[ 2 ] = GetEnt( "muj_arena_cache3", "targetname" );
	a_sp_spawners[ 3 ] = GetEnt( "muj_arena_cache4", "targetname" );
	a_sp_spawners[ 4 ] = GetEnt( "muj_arena_cache5", "targetname" );
	a_sp_spawners[ 5 ] = GetEnt( "muj_arena_cache6", "targetname" );
	a_sp_spawners[ 6 ] = GetEnt( "muj_arena_cache7", "targetname" );
	
	while( get_ai_count( "all" ) > 27 )
	{
		wait 1;
	}
	
	a_sp_muj = [];
	a_sp_muj = sort_by_distance( a_sp_spawners, level.player.origin );
	
	if ( cointoss() )
	{
		sp_muj = a_sp_muj[ a_sp_muj.size - 1 ];
	}
	
	else
	{
		sp_muj = a_sp_muj[ a_sp_muj.size - 2 ];
	}
		
	for ( i = 0; i < 3; i++ )
	{
		level.player waittill_player_not_looking_at( sp_muj.origin, undefined, false );
		
		ai_arena_squad = sp_muj spawn_ai( true );
		
		if ( IsDefined( ai_arena_squad ) )
		{
			ai_arena_squad thread arena_squad_behavior( vol_cache );
		}
		
		wait 0.1;
	}
	
	a_sp_spawners = undefined;
	a_sp_muj = undefined;
}


arena_squad_behavior( vol_cache )
{
	self endon( "death" );
	
	self.goalradius = 64;
	self.arena_guy = true;
	
	self SetGoalVolumeAuto( vol_cache );	
	
	self waittill( "goal" );
	
	self set_fixednode( false );
	
	wait RandomIntRange( 3, 6 );
	
	while( IsDefined( self.enemy ) )
	{
		wait 1;	
	}
	
	while( 1 )
	{
		a_ai_soviets = GetAIArray( "axis" );
		
		if ( IsDefined( a_ai_soviets ) )
		{
			a_ai_guys = sort_by_distance( a_ai_soviets, level.player.origin );
			
			if ( IsDefined( a_ai_guys[ a_ai_guys.size - 1 ] ) )
			{  
				self SetGoalEntity( a_ai_guys[ a_ai_guys.size - 1 ] );
			
				self.goalradius = 64;
			
				self waittill( "goal" );
			}
		}
		
		wait RandomIntRange( 2, 5 );
	}
}


///////////////////////////////////////////////////////////////////////////
//		Arena Horse Riders Ambience
///////////////////////////////////////////////////////////////////////////
start_horse_patrollers()
{
	vh_horses = [];
	
	for ( i = 0; i < 8; i++ )
	{
		s_spawnpt = getstruct( "horse_patrol_spawnpt1", "targetname" );
	
		if ( cointoss() )
		{
			s_spawnpt = getstruct( "horse_patrol_spawnpt2", "targetname" );
		}
	
		vh_horses[ i ] = spawn_vehicle_from_targetname( "horse_afghan" );
		vh_horses[ i ].origin = s_spawnpt.origin;
		vh_horses[ i ].angles = s_spawnpt.angles;
		vh_horses[ i ].targetname = "arena_horse";
		
		sp_rider = GetEnt( "horse_patroller", "targetname" );
		ai_rider = sp_rider spawn_ai( true );
		
		vh_horses[ i ] thread horse_patroller_behavior( ai_rider, s_spawnpt.targetname );
		
		wait RandomFloatRange( 0.5, 1.0 );
	}
}


monitor_arena_horse_death()
{
	self waittill( "death" );
	
	if ( !flag( "clear_arena" ) )
	{
		s_spawnpt = getstruct( "reinforcement_spawnpt", "targetname" );
	
		vh_horse = spawn_vehicle_from_targetname( "horse_afghan" );
		vh_horse.origin = s_spawnpt.origin;
		vh_horse.angles = s_spawnpt.angles;
		vh_horse.targetname = "arena_horse";
			
		sp_rider = GetEnt( "horse_patroller", "targetname" );
		ai_rider = sp_rider spawn_ai( true );
		
		str_spawnpt = "horse_patrol_spawnpt1";
		
		if ( cointoss() )
		{
			str_spawnpt = "horse_patrol_spawnpt2";
		}
			
		vh_horse thread horse_patroller_behavior( ai_rider, str_spawnpt );
	}
}


horse_patroller_behavior( ai_rider, str_spawnpt )
{
	self endon( "death" );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 400 );
	self MakeVehicleUnusable();
	
	self thread monitor_arena_horse_death();
			
	self setspeed( 25, 20, 10 );
	
	n_offset = 0;
	
	if ( cointoss() )
	{
		n_offset += 50;
	}
		
	else
	{
		n_offset -= 50;
	}
	
	self PathFixedOffset( (0, n_offset, 0) );
	
	if ( IsAlive( ai_rider ) )
	{
		ai_rider enter_vehicle( self );
	
		wait 0.1;
		
		self notify( "groupedanimevent", "ride" );
		
		if ( IsDefined( ai_rider ) )
		{
			ai_rider maps\_horse_rider::ride_and_shoot( self );
		
			self thread monitor_rider( ai_rider );
			self thread choose_driveby_or_dismount( ai_rider );
		}
	}
	
	if ( str_spawnpt == "horse_patrol_spawnpt1" )
	{
		self thread horse_patrol_path_1();
	}
	
	else
	{
		self thread horse_patrol_path_2();
	}
}


choose_driveby_or_dismount( ai_rider )  //self = horse
{
	self endon( "death" );
		
	while( 1 )
	{
		if ( IsDefined( ai_rider ) && IsDefined ( ai_rider.enemy ) && Distance2DSquared( ai_rider.origin, ai_rider.enemy.origin ) < ( 1000 * 1000 ) )
		{
			break;
		}
		
		wait 1;
	}
	
	if ( RandomInt( 4 ) < 1 )
	{
		self SetSpeed( 0, 15, 10 );
		
		while( self GetSpeed() > 0 )
		{
			wait 0.25;	
		}

		if ( IsAlive( ai_rider ) )
		{
			ai_rider ai_dismount_horse( self );
			
			ai_rider set_fixednode( false );
			
			ai_rider thread muj_dismount_behavior();
			//ai_rider thread get_back_on_horse( self );
		}		
	}
			
	self SetSpeed( 25, 15, 10 );
}


muj_dismount_behavior()  //self = muj ai
{
	self endon( "death" );
	
	a_vol_caches = [];
	a_vol_caches[ 0 ] = GetEnt( "vol_cache2", "targetname" );
	a_vol_caches[ 1 ] = GetEnt( "vol_cache3", "targetname" );
	a_vol_caches[ 2 ] = GetEnt( "vol_cache4", "targetname" );
	a_vol_caches[ 3 ] = GetEnt( "vol_cache5", "targetname" );
	a_vol_caches[ 4 ] = GetEnt( "vol_cache6", "targetname" );
	a_vol_caches[ 5 ] = GetEnt( "vol_cache1", "targetname" );
	
	if ( IsDefined( self.enemy ) )
	{
		self.goalradius = 64;
		self SetGoalEntity( self.enemy );
	}
	
	else
	{
		a_caches = [];
		a_caches = sort_by_distance( a_vol_caches, self.origin );
	
		self.goalradius = 64;
		self SetGoalVolumeAuto( a_caches[ a_caches.size - 1 ] );
	}
}


get_back_on_horse( vh_horse )  //self = ai_rider
{
	self endon( "death" );
	
	while( IsDefined( self.enemy ) &&  Distance2DSquared( self.origin, self.enemy.origin ) < ( 1000 * 1000 ) )
	{
		wait 1;		
	}
	
	if ( IsDefined( vh_horse ) )
	{
		self ai_mount_horse( vh_horse );
		
		wait 0.5;
		
		if ( IsDefined( vh_horse ) )
		{
			vh_horse thread horse_choose_patrol_path();
		}
	}
}


monitor_rider( ai_rider )
{
	self endon( "death" );
	
	while( IsAlive( ai_rider ) )
	{
		wait 1;
	}
	
	level.player waittill_player_not_looking_at( self.origin, undefined, false );
	
	while( !IsDefined( ai_rider ) )
	{
		ai_rider = get_muj_ai();
		
		if ( IsDefined( ai_rider ) )
		{
			ai_rider enter_vehicle( self );
		
			wait 0.1;
			
			self notify( "groupedanimevent", "ride" );
		
			ai_rider maps\_horse_rider::ride_and_shoot( self );
		}
		
		wait 1;
	}
}


horse_patrol_path_1()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "horse_patrol_goal5", "targetname" );
	a_s_goal[ 1 ] = getstruct( "horse_patrol_goal4", "targetname" );
	a_s_goal[ 2 ] = getstruct( "horse_patrol_goal3", "targetname" );
	a_s_goal[ 3 ] = getstruct( "horse_patrol_goal2", "targetname" );
	a_s_goal[ 4 ] = getstruct( "horse_patrol_goal1", "targetname" );
	a_s_goal[ 5 ] = getstruct( "horse_patrol_goal6", "targetname" );
	a_s_goal[ 6 ] = getstruct( "horse_patrol_goal5", "targetname" );
	a_s_goal[ 7 ] = getstruct( "horse_patrol_goal4", "targetname" );
	a_s_goal[ 8 ] = getstruct( "horse_patrol_goal3", "targetname" );
	a_s_goal[ 9 ] = getstruct( "horse_patrol_goal2", "targetname" );
	
	self SetSpeed( 25, 15, 10 );
	
	for ( i = 0; i < a_s_goal.size; i++ )
	{
		if( self SetVehGoalPos( a_s_goal[ i ].origin, 0, 1 ) )
			self waittill( "near_goal" );
		else
			wait 1;
	}
	
	a_s_goal = undefined;
	
	self thread horse_choose_patrol_path();
}


horse_patrol_path_2()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "horse_patrol_goal11", "targetname" );
	a_s_goal[ 1 ] = getstruct( "horse_patrol_goal10", "targetname" );
	a_s_goal[ 2 ] = getstruct( "horse_patrol_goal9", "targetname" );
	a_s_goal[ 3 ] = getstruct( "horse_patrol_goal8", "targetname" );
	a_s_goal[ 4 ] = getstruct( "horse_patrol_goal7", "targetname" );
	a_s_goal[ 5 ] = getstruct( "horse_patrol_goal12", "targetname" );
	
	self SetSpeed( 25, 15, 10 );
			
	for ( i = 0; i < a_s_goal.size; i++ )
	{
		if( self SetVehGoalPos( a_s_goal[ i ].origin, 0, 1 ) )
			self waittill( "near_goal" );
		else
			wait 1;
	}
	
	a_s_goal = undefined;
	
	self thread horse_choose_patrol_path();
}


horse_patrol_path_3()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "horse_patrol_divert1", "targetname" );
	a_s_goal[ 1 ] = getstruct( "horse_patrol_divert2", "targetname" );
	a_s_goal[ 2 ] = getstruct( "horse_patrol_divert3", "targetname" );
	a_s_goal[ 3 ] = getstruct( "horse_patrol_divert4", "targetname" );
	a_s_goal[ 4 ] = getstruct( "horse_patrol_divert5", "targetname" );
	
	self SetSpeed( 25, 15, 10 );
			
	for ( i = 0; i < a_s_goal.size; i++ )
	{
		if( self SetVehGoalPos( a_s_goal[ i ].origin, 0, 1 ) )
			self waittill( "near_goal" );
		else
			wait 1;
	}
	
	a_s_goal = undefined;
	
	self thread horse_choose_patrol_path();
}


horse_choose_patrol_path()
{
	self endon( "death" );
	
	a_s_center = [];
	a_s_center[ 0 ] = getstruct( "horse_patrol1_center", "targetname" );
	a_s_center[ 1 ] = getstruct( "horse_patrol2_center", "targetname" );
	a_s_center[ 2 ] = getstruct( "horse_patrol3_center", "targetname" );
	
	a_s_points = sort_by_distance( a_s_center, level.player.origin );
	
	if ( cointoss() )
	{
		if ( a_s_points[ 2 ] == a_s_center[ 0 ] )
		{
			self thread horse_patrol_path_1();
		}
		
		else if ( a_s_points[ 2 ] == a_s_center[ 1 ] )
		{
			self thread horse_patrol_path_2();
		}
		
		else
		{
			self thread horse_patrol_path_3();
		}
	}
	
	else
	{
		if ( RandomInt( 3 ) == 0 )
		{
			self thread horse_patrol_path_1();
		}
		
		else if ( RandomInt( 3 ) == 1 )
		{
			self thread horse_patrol_path_2();
		}
		
		else
		{
			self thread horse_patrol_path_3();
		}
	}
	
	a_s_center = undefined;
	a_s_points = undefined;
}


ai_horse_ride( vh_horse )
{
	self enter_vehicle( vh_horse );
	
	wait 0.1;
		
	vh_horse notify( "groupedanimevent", "ride" );
	
	self maps\_horse_rider::ride_and_shoot( vh_horse );
}


///////////////////////////////////////////////////////////////////////////
//		Arena Truck Ambience
///////////////////////////////////////////////////////////////////////////
truck_patrollers_bp1()
{
	s_spawnpt1 = getstruct( "truck_patrol_spawnpt1", "targetname" );
	
	vh_truck1 = spawn_vehicle_from_targetname( "truck_afghan" );
	vh_truck1.origin = s_spawnpt1.origin;
	vh_truck1.angles = s_spawnpt1.angles;
	vh_truck1.n_path = 1;
	vh_truck1.targetname = "arena_truck";
	
	ai_rider1 = get_muj_ai();
	ai_rider2 = get_muj_ai();
	
	if ( IsDefined( ai_rider1 ) )
	{
		ai_rider1.script_startingposition = 0;
	}
	
	if ( IsDefined( ai_rider2 ) )
	{
		ai_rider2.script_startingposition = 2;
	}
	
	if ( IsDefined( ai_rider1 ) && IsDefined( ai_rider2 ) )
	{
		vh_truck1 thread truck_patroller_behavior( ai_rider1, ai_rider2 );
	}
	
	else
	{
		vh_truck1 thread truck_patroller_behavior();
	}
}


monitor_arena_truck_death()
{
	self waittill( "death" );
	
	self thread remove_vehicle_corpse();
	
	if ( !flag( "clear_arena" ) )
	{
		s_spawnpt = getstruct( "reinforcement_spawnpt", "targetname" );
		
		vh_truck1 = spawn_vehicle_from_targetname( "truck_afghan" );
		vh_truck1.origin = s_spawnpt.origin;
		vh_truck1.angles = s_spawnpt.angles;
		vh_truck1.targetname = "arena_truck";
		vh_truck1.n_path = 1;
		
		sp_rider = GetEnt( "horse_patroller", "targetname" );
		ai_rider1 = sp_rider spawn_ai( true );
		ai_gunner = sp_rider spawn_ai( true );
		
		if ( IsDefined( ai_rider1 ) )
		{
			ai_rider1.script_startingposition = 0;
		}
		
		if ( IsDefined( ai_gunner ) )
		{
			ai_gunner.script_startingposition = 2;
		}
		
		vh_truck1 thread truck_patroller_behavior( ai_rider1, ai_gunner );
	}
}


truck_patroller_behavior( ai_rider1, ai_gunner )
{
	self endon( "death" );
	
	self SetVehicleAvoidance( true );
	self SetNearGoalNotifyDist( 400 );
	self MakeVehicleUnusable();
	
	self thread monitor_arena_truck_death();
	
	self setspeed( 30, 10, 5 );
	
	n_offset = 0;
	
	if ( cointoss() )
	{
		n_offset += 50;
	}
		
	else
	{
		n_offset -= 50;
	}
	
	self PathFixedOffset( (0, n_offset, 0) );
	
	if ( IsDefined( ai_rider1 ) )
	{
		ai_rider1 enter_vehicle( self );
	}
	
	if ( IsDefined( ai_gunner ) )
	{
		ai_gunner enter_vehicle( self );
	}
	
	self thread truck_patrol_path_1();
	
	if ( IsDefined( ai_gunner ) )
	{
		self thread truck_gunner( ai_gunner );
	}
}


truck_gunner( ai_gunner )
{
	self endon( "death" );
	
	self thread monitor_gunner( ai_gunner );
	
	while( 1 )
	{
		if ( IsDefined( ai_gunner ) )
		{
			if ( RandomInt( 4 ) < 1 )
			{
				vh_hips = GetEntArray( "arena_hip", "targetname" );
				
				if ( vh_hips.size )
				{
					vh_hip_targets = sort_by_distance( vh_hips, self.origin );
				
					e_target = vh_hip_targets[ 1 ];
				}
			}
			
			else
			{
				ai_enemies = GetAIArray( "axis" );
				
				if ( ai_enemies.size )
				{
					ai_soviets = sort_by_distance( ai_enemies, self.origin );
				
					e_target = ai_soviets[ ai_soviets.size - 1 ];
				}
			}
			
			if ( IsDefined( e_target ) )
			{
				if ( Distance2DSquared( self.origin, e_target.origin ) < ( 5000 * 5000 ) )
				{
					a_v_offset = [];
					a_v_offset[ 0 ] = ( RandomIntRange( -300, 300 ), RandomIntRange( -300, 300 ), RandomIntRange( -300, 300 ) );
					a_v_offset[ 1 ] = ( RandomIntRange( -500, -300 ), 0, RandomIntRange( -500, -300 ) );
					a_v_offset[ 2 ] = ( 0, 0, RandomIntRange( -500, -300 ) );
					a_v_offset[ 3 ] = ( RandomIntRange( -500, -300 ), 0, RandomIntRange( -500, -300 ) );
					
					v_offset = a_v_offset[ RandomInt( 3 ) ];
					
					self set_turret_target( e_target, v_offset, 1 );
					self shoot_turret_at_target( e_target, RandomFloatRange( 3.0, 5.0 ), v_offset, 1 );
					
					a_v_offset = undefined;
				}
			}
		}
		
		wait RandomFloatRange( 2.0, 4.0 );
	}
}


monitor_gunner( ai_gunner )
{
	self endon( "death" );
	
	while( IsAlive( ai_gunner ) )
	{
		wait 0.1;
	}
	
	self stop_turret( 1, true );
	
	level.player waittill_player_not_looking_at( self.origin, undefined, false );
	
	while( !IsDefined( ai_gunner ) )
	{
		ai_gunner = get_muj_ai();
		ai_gunner.script_startingposition = 2;
		
		if ( IsDefined( ai_gunner ) )
		{
			ai_gunner enter_vehicle( self );
		
		}
		
		wait 1;
	}
}


truck_patrol_path_1()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "truck_patrol_goal1", "targetname" );
	a_s_goal[ 1 ] = getstruct( "truck_patrol_goal2", "targetname" );
	a_s_goal[ 2 ] = getstruct( "truck_patrol_goal3", "targetname" );
	a_s_goal[ 3 ] = getstruct( "truck_patrol_goal4", "targetname" );
	a_s_goal[ 4 ] = getstruct( "truck_patrol_goal5", "targetname" );
	a_s_goal[ 5 ] = getstruct( "truck_patrol_goal6", "targetname" );
	a_s_goal[ 6 ] = getstruct( "truck_patrol_goal7", "targetname" );
	a_s_goal[ 7 ] = getstruct( "truck_patrol_goal8", "targetname" );
	a_s_goal[ 8 ] = getstruct( "truck_patrol_goal9", "targetname" );
	a_s_goal[ 9 ] = getstruct( "truck_patrol_goal10", "targetname" );
	a_s_goal[ 10 ] = getstruct( "truck_patrol_spawnpt1", "targetname" );
	
	for ( i = 0; i < a_s_goal.size; i++ )
	{
		self SetVehGoalPos( a_s_goal[ i ].origin, 0, 1 );
		self waittill_any( "goal", "near_goal" );
		
		if ( i == 0 )
		{
			if ( cointoss() )
			{
				self thread truck_patrol_path_2();
				break;
			}
		}
		
		if ( i == 3 )
		{
			if ( cointoss() )
			{
				self thread truck_patrol_path_3();
				break;
			}
		}
	}
	
	a_s_goal = undefined;
	
	self thread truck_patrol_path_1();
}


truck_patrol_path_2()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "truck_patrol2_goal1", "targetname" );
	a_s_goal[ 1 ] = getstruct( "truck_patrol2_goal2", "targetname" );
	a_s_goal[ 2 ] = getstruct( "truck_patrol2_goal3", "targetname" );
	a_s_goal[ 3 ] = getstruct( "truck_patrol2_goal4", "targetname" );
	a_s_goal[ 4 ] = getstruct( "truck_patrol_goal3", "targetname" );
	a_s_goal[ 5 ] = getstruct( "truck_patrol_goal4", "targetname" );
	a_s_goal[ 6 ] = getstruct( "truck_patrol_goal5", "targetname" );
	a_s_goal[ 7 ] = getstruct( "truck_patrol_goal6", "targetname" );
	a_s_goal[ 8 ] = getstruct( "truck_patrol_goal7", "targetname" );
	a_s_goal[ 9 ] = getstruct( "truck_patrol_goal8", "targetname" );
	a_s_goal[ 10 ] = getstruct( "truck_patrol_goal9", "targetname" );
	a_s_goal[ 11 ] = getstruct( "truck_patrol_goal10", "targetname" );
	a_s_goal[ 12 ] = getstruct( "truck_patrol_spawnpt1", "targetname" );
	
	
	for ( i = 0; i < a_s_goal.size; i++ )
	{
		self SetVehGoalPos( a_s_goal[ i ].origin, 0, 1 );
		self waittill_any( "goal", "near_goal" );
	}
	
	a_s_goal = undefined;
	
	self thread truck_patrol_path_1();
}


truck_patrol_path_3()
{
	self endon( "death" );
	
	a_s_goal = [];
	a_s_goal[ 0 ] = getstruct( "truck_patrol3_goal1", "targetname" );
	a_s_goal[ 1 ] = getstruct( "truck_patrol3_goal2", "targetname" );
	a_s_goal[ 2 ] = getstruct( "truck_patrol3_goal3", "targetname" );
	a_s_goal[ 3 ] = getstruct( "truck_patrol3_goal4", "targetname" );
	a_s_goal[ 4 ] = getstruct( "truck_patrol_goal8", "targetname" );
	a_s_goal[ 5 ] = getstruct( "truck_patrol_goal9", "targetname" );
	a_s_goal[ 6 ] = getstruct( "truck_patrol_goal10", "targetname" );
	a_s_goal[ 7 ] = getstruct( "truck_patrol_spawnpt1", "targetname" );
	
	
	for ( i = 0; i < a_s_goal.size; i++ )
	{
		self SetVehGoalPos( a_s_goal[ i ].origin, 0, 1 );
		self waittill_any( "goal", "near_goal" );
	}
	
	a_s_goal = undefined;
	
	self thread truck_patrol_path_1();
}


///////////////////////////////////////////////////////////////////////////
//		Arena Helicopters Ambience
///////////////////////////////////////////////////////////////////////////
hips_arena_ambient()
{
	s_spawn1 = getstruct( "s_arena_hip1_spawnpt", "targetname" );
		
	vh_hip = spawn_vehicle_from_targetname( "hip_soviet" );
	vh_hip.origin = s_spawn1.origin;
	vh_hip.angles = s_spawn1.angles;
	vh_hip.targetname = "arena_hip";
	
	vh_hip thread hip1_arena_behavior();
	
	wait RandomFloatRange( 4.0, 7.0 );
	
	s_spawn2 = getstruct( "s_arena_hip2_spawnpt", "targetname" );
		
	vh_hip = spawn_vehicle_from_targetname( "hip_soviet" );
	vh_hip.origin = s_spawn2.origin;
	vh_hip.angles = s_spawn2.angles;
	vh_hip.targetname = "arena_hip";
	
	vh_hip thread hip2_arena_behavior();
}


ambient_hip1_death()
{
	self waittill( "death" );
	
	wait RandomFloatRange( 7.0, 10.0 );
	
	if ( !flag( "clear_arena" ) )
	{
		s_spawn1 = getstruct( "s_arena_hip1_spawnpt", "targetname" );
			
		vh_hip = spawn_vehicle_from_targetname( "hip_soviet" );
		vh_hip.origin = s_spawn1.origin;
		vh_hip.angles = s_spawn1.angles;
		
		vh_hip thread hip1_arena_behavior();
	}
}


ambient_hip2_death()
{
	self waittill( "death" );
	
	wait RandomFloatRange( 7.0, 10.0 );
	
	if ( !flag( "clear_arena" ) )
	{
		s_spawn1 = getstruct( "s_arena_hip2_spawnpt", "targetname" );
		
		vh_hip = spawn_vehicle_from_targetname( "hip_soviet" );
		vh_hip.origin = s_spawn1.origin;
		vh_hip.angles = s_spawn1.angles;
	
		vh_hip thread hip2_arena_behavior();
	}
}


hip1_arena_behavior()
{
	self endon( "death" );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetForceNoCull();
	self HidePart( "tag_back_door" );
	self thread heli_select_death();
	self thread ambient_hip1_death();
	self thread hip_attack();
		
	a_s_goal = [];
	a_s_goal[ 0 ] = undefined;
	
	for ( i = 1; i < 9; i++ )
	{
		a_s_goal[ i ] = getstruct( "s_arena_hip1_goal"+i, "targetname" );
	}
	
	sp_rappel = GetEnt( "ambient_troops1", "targetname" );
		
	self SetNearGoalNotifyDist( 500 );
	self setspeed( 100, 25, 10 );
	
	i = 1;
	
	while( 1 )
	{
		self setvehgoalpos( a_s_goal[ i ].origin );
		self waittill_any( "goal", "near_goal" );
		
		if ( flag( "clear_arena" ) )
		{
			self kill_arena_vehicle();
		}
				
		if ( RandomInt( 4 ) > 1 )
		{
			if ( ( i == 2 || i == 4 ) && !flag( "hip1_rappellers" ) )
			{
				self setspeed( 25, 20, 15 );
				
				if ( i == 2 )
				{
					s_drop_pt = "ambient_hip1_cache6";
					
					a_vol_caches = [];
					a_vol_caches[ 0 ] = GetEnt( "vol_cache2", "targetname" );
					a_vol_caches[ 1 ] = GetEnt( "vol_cache5", "targetname" );
					a_vol_caches[ 2 ] = GetEnt( "vol_cache6", "targetname" );
					a_vol_caches[ 3 ] = GetEnt( "vol_cache1", "targetname" );
					
					a_caches = [];
					a_caches = sort_by_distance( a_vol_caches, level.player.origin );
					
					vol_cache = a_caches[ a_caches.size - 1 ];
					
					a_vol_caches = undefined;
					a_caches = undefined;
				}
				
				else if ( i == 4 )
				{
					s_drop_pt = "ambient_hip1_cache4";
					
					a_vol_caches = [];
					a_vol_caches[ 0 ] = GetEnt( "vol_cache3", "targetname" );
					a_vol_caches[ 1 ] = GetEnt( "vol_cache4", "targetname" );
					a_vol_caches[ 2 ] = GetEnt( "vol_cache5", "targetname" );
					
					a_caches = [];
					a_caches = sort_by_distance( a_vol_caches, level.player.origin );
					
					vol_cache = a_caches[ a_caches.size - 1 ];
					
					a_vol_caches = undefined;
					a_caches = undefined;
				}
				
				level thread manage_arena_muj_squads( vol_cache );
				
				ambient_rappel( sp_rappel, s_drop_pt );
				
				flag_set( "hip1_rappellers" );
				
				level thread monitor_ambient_rapellers( sp_rappel, "hip1_rappellers", vol_cache );
				
				self setspeed( 100, 25, 10 );
			}
		}
		
		i++;
		
		if ( i == 9 )
		{
			i = 2;	
		}
	}
}


hip2_arena_behavior()
{
	self endon( "death" );
	
	Target_Set( self, ( -50, 0, -32 ) );
	
	self SetForceNoCull();
	self HidePart( "tag_back_door" );
	
	self thread ambient_hip2_death();
	self thread heli_select_death();
	
	a_s_goal = [];
	a_s_goal[ 0 ] = undefined;
	
	for ( i = 1; i < 16; i++ )
	{
		a_s_goal[ i ] = getstruct( "s_arena_hip2_goal"+i, "targetname" );
	}
	
	sp_rappel = GetEnt( "ambient_troops2", "targetname" );
		
	self SetNearGoalNotifyDist( 500 );
	self setspeed( 80, 25, 10 );
	
	i = 1;
	
	while( 1 )
	{
		self setvehgoalpos( a_s_goal[ i ].origin );
		self waittill_any( "goal", "near_goal" );
		
		if ( flag( "clear_arena" ) )
		{
			self kill_arena_vehicle();
		}
		
		if ( ( i == 6 || i == 8 || i == 12 ) && !flag( "hip2_rappellers" ) )
		{
			if ( RandomInt( 4 ) > 1 )
			{
				if ( i == 6 )
				{
					s_drop_pt = "ambient_hip_dropoff6";
						
					a_vol_caches = [];
					a_vol_caches[ 0 ] = GetEnt( "vol_cache2", "targetname" );
					a_vol_caches[ 1 ] = GetEnt( "vol_cache3", "targetname" );
							
					vol_cache = a_vol_caches[ RandomInt( a_vol_caches.size ) ];
				}
						
				else if ( i == 8 )
				{
					s_drop_pt = "ambient_hip_dropoff8";
							
					a_vol_caches = [];
					a_vol_caches[ 0 ] = GetEnt( "vol_cache2", "targetname" );
					a_vol_caches[ 1 ] = GetEnt( "vol_cache3", "targetname" );
					a_vol_caches[ 2 ] = GetEnt( "vol_cache4", "targetname" );
					a_vol_caches[ 3 ] = GetEnt( "vol_cache5", "targetname" );
					a_vol_caches[ 4 ] = GetEnt( "vol_cache6", "targetname" );
					a_vol_caches[ 5 ] = GetEnt( "vol_cache1", "targetname" );
							
					a_caches = [];
					a_caches = sort_by_distance( a_vol_caches, level.player.origin );
					
					vol_cache = a_caches[ a_caches.size - 1 ];
					
					a_vol_caches = undefined;
					a_caches = undefined;
				}
						
				else
				{
					s_drop_pt = "ambient_hip_dropoff12";
							
					a_vol_caches = [];
					a_vol_caches[ 0 ] = GetEnt( "vol_cache2", "targetname" );
					a_vol_caches[ 1 ] = GetEnt( "vol_cache3", "targetname" );
					a_vol_caches[ 2 ] = GetEnt( "vol_cache5", "targetname" );
							
					a_caches = [];
					a_caches = sort_by_distance( a_vol_caches, level.player.origin );
					
					vol_cache = a_caches[ a_caches.size - 1 ];
					
					a_vol_caches = undefined;
					a_caches = undefined;
				}
				
				level thread manage_arena_muj_squads( vol_cache );
						
				ambient_rappel( sp_rappel, s_drop_pt );
						
				flag_set( "hip2_rappellers" );
						
				level thread monitor_ambient_rapellers( sp_rappel, "hip2_rappellers", vol_cache );
						
				self setspeed( 80, 25, 10 );
			}
		}
		
		i++;
		
		if ( i > 15 )
		{
			i = 3;	
		}
	}
}


ambient_rappel( sp_rappel, s_drop_pt )  //self = heli hip
{
	self endon( "death" );
	
	self SetHoverParams( 0, 0, 10 );
	
	drop_struct = GetStruct( s_drop_pt, "targetname" );
	drop_origin = drop_struct.origin;
	
	// TODO: stick this value in the vehicle's main as a self variable
	drop_offset_tag = "tag_fastrope_ri";
	
	// Get offset from drop tag to origin
	drop_offset = self GetTagOrigin( "tag_origin" ) - self GetTagOrigin( drop_offset_tag );
	
	// Adjust for height
	drop_offset = ( drop_offset[0], drop_offset[1], self.fastropeoffset );
	
	// Adjust for height and tag offset
	drop_origin += drop_offset;
	
	// Fly there
	self SetVehGoalPos( drop_origin, 1 );
	
	// wait till we get there
	self waittill( "goal" );
	
	n_pos = 2;
	
	for ( i = 0; i < 3; i++ )
	{
		ai_rappeller = sp_rappel spawn_ai( true );
		ai_rappeller.script_startingposition = n_pos;
		ai_rappeller enter_vehicle( self );
		n_pos++;
		wait 0.1;
	}
	
	// Unload
	self notify( "unload" );
	
	// Wait until unload finished
	self waittill( "unloaded" );
	
	// Get the exit point
	//exit_struct = GetStruct( drop_exit_struct_name, "targetname" );
	
	// Go and delete
	//self SetVehGoalPos( exit_struct.origin, 1 );
	//self waittill( "goal" );
}


monitor_ambient_rapellers( sp_rappel, str_rappel, vol_cache )
{
	a_ai_rappellers = GetEntArray( sp_rappel.targetname+"_ai", "targetname" );
	
	foreach( ai_guy in a_ai_rappellers )
	{
		if ( IsAlive( ai_guy ) )
		{
			ai_guy.goalradius = 64;
			ai_guy.arena_guy = true;
			ai_guy SetGoalVolumeAuto( vol_cache );
			wait RandomFloatRange( 0.3, 1.5 );
		}
	}
	
	while( 1 )
	{
		a_ai_rappellers = GetEntArray( sp_rappel.targetname+"_ai", "targetname" );
		
		if ( !a_ai_rappellers.size )
		{
			flag_clear( str_rappel );
			
			break;
		}
		
		if ( flag( "clear_arena" ) )
		{
			foreach( ai_guy in a_ai_rappellers )
			{
				if ( IsAlive( ai_guy ) )
				{
					ai_guy die();
				}
			}
			
			a_ai_muj = GetEntArray( "horse_patroller_ai", "targetname" );
			
			foreach( ai_muj in a_ai_muj )
			{
				if ( IsAlive( ai_muj ) )
				{
					ai_muj die();
				}
			}
		}
		
		wait 1;
	}
}


cleanup_bp_ai()
{
	a_ai_guys = getaiarray( "allies", "axis" );
	
	a_ai_heroes = [];
	a_ai_heroes[ 0 ] = level.zhao;
	a_ai_heroes[ 1 ] = level.woods;
	
	a_ai_bpguys = array_exclude( a_ai_guys, a_ai_heroes );
	
	foreach( ai_guy in a_ai_bpguys )
	{
		if ( IsDefined( ai_guy.bp_ai ) )
		{
			ai_guy delete();
		}
	}	
}


cleanup_arena()
{
	level notify( "stop_guns_base" );
	level notify( "stop_stingers_base" );
	
	flag_set( "clear_arena" );
	flag_set( "stop_arena_explosions" );
	
	a_muj_guys = getaiarray( "allies" );
	
	foreach( guy in a_muj_guys )
	{
		if ( IsDefined( guy.arena_guy ) )
		{
			guy die();
		}
	}
	
	a_bad_guys = getaiarray( "axis" );
	
	foreach( guy in a_bad_guys )
	{
		if ( !IsDefined( guy.no_cleanup ) && !IsDefined( guy.bp_ai ) )
		{
			guy die();
		}
	}
	
	a_vh_hips = GetEntArray( "arena_hip", "targetname" );
	
	if ( a_vh_hips.size )
	{
		for ( i = 0; i < a_vh_hips.size; i++ )
		{
			if ( IsDefined( a_vh_hips[ i ] ) )
			{
				a_vh_hips[ i ] thread kill_arena_vehicle();
			}
		}
	}
	
	a_vh_horses = GetEntArray( "arena_horse", "targetname" );
	
	if ( a_vh_horses.size )
	{
		for ( i = 0; i < a_vh_horses.size; i++ )
		{
			if ( IsAlive( a_vh_horses[ i ] ) )
			{
				a_vh_horses[ i ] thread kill_arena_vehicle();
			}
		}
	}
	
	a_vh_trucks = GetEntArray( "arena_truck", "targetname" );
	
	if ( a_vh_trucks.size )
	{
		for ( i = 0; i < a_vh_trucks.size; i++ )
		{
			if ( IsAlive( a_vh_trucks[ i ] ) )
			{
				a_vh_trucks[ i ] thread kill_arena_vehicle();
			}
		}
	}
}


kill_arena_vehicle()
{
	self endon( "death" );
	
	wait RandomFloat( 2.0 );
	
	RadiusDamage( self.origin, 100, self.health, self.health );
}


respawn_arena()
{
	flag_clear( "clear_arena" );
	
	//level thread maps\afghanistan_firehorse::fire_guns_base();
	//level thread maps\afghanistan_firehorse::fire_stingers_base();
	
	level thread hips_arena_ambient();
	level thread manage_arena_enemy_squads();
		
	wait 0.5;
	
	level thread arena_explosions();
	level thread start_horse_patrollers();
	
	wait 2;
	
	level thread truck_patrollers_bp1();
	
	
//	level thread maps\afghanistan_firehorse::arena_explosion_fx();
//	
//	spawn_manager_enable( "manager_troops_exit" );
//	
//	flag_clear( "stop_arena_explosions" );
//	
//	spawn_manager_enable( "manager_hip3_troops" );
//	spawn_manager_enable( "manager_hip4_troops" );
//	
//	level thread maps\afghanistan_firehorse::ambience_manager();
}

remove_woods_facemask_util()
{
	level.woods Detach("c_usa_afghan_woods_facewrap");		
}


get_muj()
{
	a_ai_muj = GetAIArray( "allies" );
	a_ai_muj = array_exclude( a_ai_muj, level.woods );
	a_ai_muj = array_exclude( a_ai_muj, level.zhao );
	
	a_ai_talkers = sort_by_distance( a_ai_muj, level.player.origin );
	
	for ( i = ( a_ai_talkers.size - 1 ); i >= 0; i-- )
	{
		if ( IsAlive( a_ai_talkers[ i ] ) )
		{
			return a_ai_talkers[ i ];
			
			break;
		}
	}
}


ride_horse( ai_rider, vh_horse )
{
	ai_rider enter_vehicle( vh_horse );
	
	wait 0.1;
		
	vh_horse notify( "groupedanimevent", "ride" );
	
	ai_rider maps\_horse_rider::ride_and_shoot( vh_horse );
}


hip_land_unload( drop_struct_name )
{
	self endon( "death" );
	
	self SetHoverParams( 0, 0, 10 );
	
	drop_struct = GetStruct( drop_struct_name, "targetname" );
	drop_origin = drop_struct.origin;
	
	// save the original drop point
	original_drop_origin = drop_origin;
	original_drop_origin = ( original_drop_origin[0], original_drop_origin[1], original_drop_origin[2] + self.dropoffset );
		
	// Adjust for height
	drop_origin = ( drop_origin[0], drop_origin[1], drop_origin[2] + 350 );;
		
	// Fly there
	self setNearGoalNotifyDist( 100 );
	self SetVehGoalPos( drop_origin, 1 );
	
	// wait till we get there
	self waittill( "goal" );
	
	// fly down
	self SetVehGoalPos( original_drop_origin, 1 );
		
	// wait till we get there
	self waittill( "goal" );
	
	// Unload
	self notify( "unload" );
	
	// Wait until unload finished
	self waittill( "unloaded" );
}


hip_rappel_unload( s_drop_pt )
{
	self endon( "death" );
	
	self SetHoverParams( 0, 0, 10 );
	
	drop_struct = GetStruct( s_drop_pt, "targetname" );
	drop_origin = drop_struct.origin;
	
	// TODO: stick this value in the vehicle's main as a self variable
	drop_offset_tag = "tag_fastrope_ri";
	
	// Get offset from drop tag to origin
	drop_offset = self GetTagOrigin( "tag_origin" ) - self GetTagOrigin( drop_offset_tag );
	
	// Adjust for height
	drop_offset = ( drop_offset[0], drop_offset[1], self.fastropeoffset );
	
	// Adjust for height and tag offset
	drop_origin += drop_offset;
	
	// Fly there
	self SetVehGoalPos( drop_origin, 1 );
	
	// wait till we get there
	self waittill( "goal" );
	
	// Unload
	self notify( "unload" );
	
	// Wait until unload finished
	self waittill( "unloaded" );
}


load_landing_troops( n_guys_to_load, str_ai_targetname )
{
	self endon( "death" );
	
	n_pos = 2;
	
	for ( i = 0; i < n_guys_to_load; i++ )
	{
		n_aitype = RandomInt( 10 );
	
		if ( n_aitype < 5 )
		{
			sp_rappel = GetEnt( "soviet_assault", "targetname" );
		}
		
		else if ( n_aitype < 8 )
		{
			sp_rappel = GetEnt( "soviet_smg", "targetname" );
		}
		
		else
		{
			sp_rappel = GetEnt( "soviet_lmg", "targetname" );
		}
		
		ai_rappeller = sp_rappel spawn_ai( true );
		
		if ( IsDefined( ai_rappeller ) )
		{
			ai_rappeller.script_startingposition = n_pos;
			ai_rappeller.bp_ai = true;
			ai_rappeller enter_vehicle( self );
			
			if ( IsDefined( str_ai_targetname ) )
			{
				ai_rappeller.targetname = str_ai_targetname;
			}
			
			n_pos++;
			
			wait 0.1;
		}
	}
}


get_muj_ai()
{
	n_aitype = RandomInt( 10 );
	
	if ( n_aitype < 5 )
	{
		sp_rider = GetEnt( "muj_assault", "targetname" );
	}
		
	else if ( n_aitype < 8 )
	{
		sp_rider = GetEnt( "muj_assault", "targetname" );  //restore smg when possible
	}
		
	else
	{
		sp_rider = GetEnt( "muj_lmg", "targetname" );
	}
	
	ai_muj = sp_rider spawn_ai( true );
		
	return ai_muj;
}


get_soviet_ai()
{
	n_aitype = RandomInt( 10 );
	
	if ( n_aitype < 5 )
	{
		sp_rider = GetEnt( "soviet_assault", "targetname" );
	}
		
	else if ( n_aitype < 8 )
	{
		sp_rider = GetEnt( "soviet_smg", "targetname" );
	}
		
	else
	{
		sp_rider = GetEnt( "soviet_lmg", "targetname" );
	}
	
	ai_soviet = sp_rider spawn_ai( true );
		
	return ai_soviet;
}


ai_dismount_horse( vh_horse )  //self = ai
{
	self endon( "death" );
	
	self notify( "stop_riding" );
	self notify( "off_horse" );
	
	vh_horse vehicle_unload( 0.1 );
	
	vh_horse waittill( "unloaded" );	
}


ai_mount_horse( vh_horse )  //self = ai
{
	self endon( "death" );
	
	self run_to_vehicle( vh_horse );
	
	while( !IsDefined( vh_horse get_driver() ) )
	{
		wait 0.05;	
	}
	
	self notify( "on_horse" );
	
	vh_horse notify( "groupedanimevent", "ride" );
	
	wait 0.1;
	
	self maps\_horse_rider::ride_and_shoot( vh_horse );
}


nag_follow( str_end_flag )
{
	level endon( str_end_flag );
	
	a_zhao_nag = [];
	a_zhao_nag[ 0 ] = "zhao_stay_with_me_mason_0";  //Come on, Mason!
	a_zhao_nag[ 1 ] = "zhao_this_way_1";  //This way!
	a_zhao_nag[ 2 ] = "zhao_follow_me_0";  //Follow me!
	a_zhao_nag[ 3 ] = "zhao_stay_with_me_mason_2";  //Stay with me, Mason.
	a_zhao_nag[ 4 ] = "zhao_follow_me_2";  //Follow me.
	a_zhao_nag[ 5 ] = "zhao_stay_close_0";  //Stay Close.
	a_zhao_nag[ 6 ] = "zhao_keep_up_mason_0";  //Keep up, Mason.
	a_zhao_nag[ 7 ] = "zhao_we_need_to_get_movin_0";  //We need to get moving!
	a_zhao_nag[ 8 ] = "zhao_that_s_all_we_can_do_0";  //That's all we can do, let's go!
	a_zhao_nag[ 9 ] = "zhao_let_s_get_moving_0";  //Let's get moving.
	a_zhao_nag[ 10 ] = "zhao_let_s_go_0";  //Let's go.
	a_zhao_nag[ 11 ] = "zhao_push_forward_mason_0";  //Push forward, Mason!
	
	a_woods_nag = [];
	a_woods_nag[ 0 ] = "wood_we_need_to_stay_with_0";  //We need to stay with Zhao!
	a_woods_nag[ 1 ] = "wood_keep_up_mason_0";  //Keep up, Mason.
	a_woods_nag[ 2 ] = "wood_stay_close_to_me_0";  //Stay close to me.
	a_woods_nag[ 3 ] = "wood_this_way_follow_me_0";  //This way, follow me.
	a_woods_nag[ 4 ] = "wood_stay_with_me_mason_0";  //Stay with me, Mason.
	a_woods_nag[ 5 ] = "wood_let_s_go_mason_0";  //Let's go, Mason.
	a_woods_nag[ 6 ] = "wood_time_to_go_come_on_0";  //Time to go, come on.
	a_woods_nag[ 7 ] = "wood_forward_mason_0";  //Forward, Mason.
	a_woods_nag[ 8 ] = "wood_we_need_to_go_0";  //We need to go!
	a_woods_nag[ 9 ] = "wood_come_on_let_s_go_0";  //Come on, let's go.
	
	wait 7;
	
	while( !flag( str_end_flag ) )
	{
		if ( cointoss() )
		{
			level.woods say_dialog( a_woods_nag[ RandomInt( a_woods_nag.size ) ] );
		}
		
		else
		{
			level.zhao say_dialog( a_zhao_nag[ RandomInt( a_zhao_nag.size ) ] );
		}
		
		wait RandomFloatRange( 7.0, 9.0 );
	}
}


vo_nag_get_back( str_flag_clear )
{
	level endon( "wave2_done" );
	level endon( "wave3_done" );
	
	while( flag( str_flag_clear ) )
	{
		switch( RandomInt( 5 ) )
		{
			case 0:
			{
				level.woods say_dialog( "wood_stay_with_me_mason_0", 1 );  //Stay with me, Mason.
				
				break;
			}
			case 1:
			{
				level.woods say_dialog( "wood_quit_screwin_around_0", 1 );  //Quit screwin' around, Mason!
				
				break;
			}
			case 2:
			{
				level.woods say_dialog( "wood_get_back_here_we_st_0", 1 );  //Get back here! We still go a battle on our hands.
				
				break;
			}
			case 3:
			{
				level.woods say_dialog( "wood_hey_get_your_head_i_0", 1 );  //Hey! Get your head in the gam, Mason!
				
				break;
			}
			case 4:
			{
				level.woods say_dialog( "wood_where_the_hell_you_g_0", 1 );  //Where the Hell you goin'?
				
				break;
			}
		}
	}
}


vo_get_horse()
{
	if ( !level.player is_on_horseback() )
	{
		switch( RandomInt( 4 ) )
		{
			case 0:
			{
				level.woods say_dialog( "wood_you_need_a_horse_ma_0", 1 );  //You need a horse, Mason!
				
				break;
			}
			case 1:
			{
				level.zhao say_dialog( "zhao_find_another_horse_0", 1 );  //Find another horse!
				
				break;
			}
			case 2:
			{
				level.zhao say_dialog( "wood_it_s_too_far_to_walk_0", 1 );  //It's too far to walk - get on a horse, Mason!
				
				break;
			}
			case 3:
			{
				level.zhao say_dialog( "wood_get_a_horse_dammit_0", 1 );  //Get a horse, Dammit!
				
				break;
			}
		}	
	}
}


vo_player_horse_sprint()
{
	switch( RandomInt( 5 ) )
	{
		case 0:
		{
			level.player say_dialog( "maso_faster_come_on_0", 0 );  //Faster!  Come on!
		
			break;
		}
		case 1:
		{
			level.player say_dialog( "maso_hya_hya_0", 0 );  //Hya! Hya!
				
			break;
		}
		case 2:
		{
			level.player say_dialog( "maso_come_on_go_0", 0 );  //Come on, go!
				
			break;
		}
		case 3:
		{
			level.player say_dialog( "maso_gimme_all_you_got_b_0", 0 );  //Gimme all you got, Boy!
			
			break;
		}
		case 4:
		{
			level.player say_dialog( "maso_fast_as_you_can_com_0", 0 );  //Fast as you can! Come on!
			
			break;
		}
	}
}


player_has_stinger()
{
	a_current_weapons = level.player GetWeaponsList();
	
	foreach ( weapon in a_current_weapons )
	{
		if ( IsSubStr( weapon, "afghanstinger" )  )
		{
			return true;
		}
	}
	
	return false;
}


spawn_backup_cache_horse( s_spawnpt, str_delete_flag )
{
	vh_horse = spawn_vehicle_from_targetname( "horse_afghan" );
	vh_horse.origin = s_spawnpt.origin;
	vh_horse.angles = s_spawnpt.angles;
	
	vh_horse MakeVehicleUsable();
	vh_horse horse_panic();
	
	flag_wait( str_delete_flag );
	
	if ( IsDefined( vh_horse ) )
	{
		if ( Distance2DSquared( vh_horse.origin, s_spawnpt.origin ) <= ( 800 * 800 ) )
		{
			VEHICLE_DELETE( vh_horse )
		}
	}
}


remove_vehicle_corpse()
{
	self endon( "delete" );
	
	level.player waittill_player_not_looking_at( self.origin, undefined, false );
	
	self Delete();
}


attach_weapon( m_weapon_name )
{
	m_weapon = GetWeaponModel( m_weapon_name ); 
	self Attach( m_weapon, "tag_weapon_right" ); 
	self UseWeaponHideTags( m_weapon_name );		
}


teleport_ai( v_pos, v_ang )
{
	self endon( "death" );
	self endon( "on_horse" );
	
	level.player waittill_player_not_looking_at( self.origin, undefined, false );
	
	if ( Distance2DSquared( self.origin, v_pos ) > ( 300 * 300 ) )
	{
		if ( IsDefined( v_ang ) )
		{
			self forceteleport( v_pos, v_ang );
		}
	
		else
		{
			self forceteleport( v_pos, self.angles );
		}
	}
}


struct_cleanup_wave1()
{
	a_s_structs = [];
	
	a_s_structs[ 0 ] = getstruct( "uaz3_goal", "targetname" );
	a_s_structs[ 1 ] = getstruct( "zhao_bp1_goal", "targetname" );
	a_s_structs[ 2 ] = getstruct( "woods_bp1_goal", "targetname" );
	a_s_structs[ 3 ] = getstruct( "detonate_safe_point", "targetname" );
	a_s_structs[ 4 ] = getstruct( "chase_truck_spawnpt", "targetname" );
	a_s_structs[ 5 ] = getstruct( "chopper_victim_spawnpt", "targetname" );
	a_s_structs[ 6 ] = getstruct( "chopper_victim_goal0", "targetname" );
	a_s_structs[ 7 ] = getstruct( "chopper_victim_goal1", "targetname" );
	a_s_structs[ 8 ] = getstruct( "chopper_victim_goal2", "targetname" );
	a_s_structs[ 9 ] = getstruct( "chopper_victim_goal3", "targetname" );
	a_s_structs[ 10 ] = getstruct( "chopper_victim_goal4", "targetname" );
	a_s_structs[ 11 ] = getstruct( "chopper_victim_goal5", "targetname" );
	a_s_structs[ 12 ] = getstruct( "uaz_chase_horse_spawnpt", "targetname" );
	a_s_structs[ 13 ] = getstruct( "uaz_chase_horse_goal0", "targetname" );
	a_s_structs[ 14 ] = getstruct( "uaz_chase_horse_goal1", "targetname" );
	a_s_structs[ 15 ] = getstruct( "bp1_horse_spawnpt", "targetname" );
	a_s_structs[ 16 ] = getstruct( "bp1_horse_goal1", "targetname" );
	a_s_structs[ 17 ] = getstruct( "teleport_woods_pos", "targetname" );
	a_s_structs[ 18 ] = getstruct( "teleport_zhao_pos", "targetname" );
	a_s_structs[ 19 ] = getstruct ( "explosion_struct", "targetname" );
	a_s_structs[ 20 ] = getstruct( "hip1_bp1_circle05", "targetname" );
	a_s_structs[ 21 ] = getstruct( "bp1_mig_spawnpt", "targetname" );
	a_s_structs[ 22 ] = getstruct( "bp1_mig_goal1", "targetname" );
	a_s_structs[ 23 ] = getstruct( "bp1_mig_goal2", "targetname" );
	a_s_structs[ 24 ] = getstruct( "bp1_mig_exp1", "targetname" );
	a_s_structs[ 25 ] = getstruct( "bp1_mig_exp2", "targetname" );
	a_s_structs[ 26 ] = getstruct( "bp1_mig_exp3", "targetname" );
	a_s_structs[ 27 ] = getstruct( "bp1_mig_exp4", "targetname" );
	a_s_structs[ 28 ] = getstruct( "bp1_mig_exp5", "targetname" );
	a_s_structs[ 29 ] = getstruct( "bp1_mig_exp6", "targetname" );
	a_s_structs[ 30 ] = getstruct( "bp1_mig2_spawnpt", "targetname" );
	a_s_structs[ 31 ] = getstruct( "bp1_mig2_goal1", "targetname" );
	a_s_structs[ 32 ] = getstruct( "bp1_mig2_goal2", "targetname" );
	a_s_structs[ 33 ] = getstruct( "bp1_mig2_exp1", "targetname" );
	a_s_structs[ 34 ] = getstruct( "bp1_mig2_exp2", "targetname" );
	a_s_structs[ 35 ] = getstruct( "mig_tower_spawnpt", "targetname" );
	a_s_structs[ 36 ] = getstruct( "mig_tower_goal1", "targetname" );
	a_s_structs[ 37 ] = getstruct( "mig_tower_goal2", "targetname" );
	a_s_structs[ 38 ] = getstruct( "mig_tower_goal3", "targetname" );
	a_s_structs[ 39 ] = getstruct( "mig_tower_goal4", "targetname" );
	a_s_structs[ 40 ] = getstruct( "mig_tower_bomb1", "targetname" );
	a_s_structs[ 41 ] = getstruct( "bp1_hitch", "targetname" );
	a_s_structs[ 42 ] = getstruct( "zhao_bp1_horse", "targetname" );
	a_s_structs[ 43 ] = getstruct( "woods_bp1_horse", "targetname" );
	a_s_structs[ 44 ] = getstruct( "hip_flyby_spawnpt", "targetname" );
	a_s_structs[ 45 ] = getstruct( "hip_flyby_goal1", "targetname" );
	a_s_structs[ 46 ] = getstruct( "hip_flyby_goal2", "targetname" );
	a_s_structs[ 47 ] = getstruct( "hip_flyby_stinger", "targetname" );
	a_s_structs[ 48 ] = getstruct( "cache4_horse_spawnpt", "targetname" );
	a_s_structs[ 49 ] = getstruct( "uaz_bp1exit_spawnpt1", "targetname" );
	a_s_structs[ 50 ] = getstruct( "uaz_bp1exit_spawnpt2", "targetname" );
	a_s_structs[ 51 ] = getstruct( "uaz_bp1exit_spawnpt3", "targetname" );
	a_s_structs[ 52 ] = getstruct( "uaz_bp1exit_spawnpt4", "targetname" );
	a_s_structs[ 53 ] = getstruct( "arena_hip_land_spawnpt", "targetname" );
	a_s_structs[ 54 ] = getstruct( "mig1_strafe_spawnpt", "targetname" );
	a_s_structs[ 55 ] = getstruct( "arena_hip_land_goal1", "targetname" );
	a_s_structs[ 56 ] = getstruct( "arena_hip_land_goal2", "targetname" );
	a_s_structs[ 57 ] = getstruct( "arena_hip_land_goal3", "targetname" );
	a_s_structs[ 58 ] = getstruct( "arena_hip_land_goal4", "targetname" );
	a_s_structs[ 59 ] = getstruct( "arena_hip_land_goal5", "targetname" );
	a_s_structs[ 60 ] = getstruct( "exit_battle_goal", "targetname" );
	a_s_structs[ 61 ] = getstruct( "btr_chase_approach_goal", "targetname" );
	a_s_structs[ 62 ] = getstruct( "btr_chase_over_goal", "targetname" );
	a_s_structs[ 63 ] = getstruct( "hip1_bp1_spawnpt", "targetname" );
	a_s_structs[ 64 ] = getstruct( "hip2_bp1_spawnpt", "targetname" );
	a_s_structs[ 65 ] = getstruct( "btr1_bp1_spawnpt", "targetname" );
	a_s_structs[ 66 ] = getstruct( "btr2_bp1_spawnpt", "targetname" );
	a_s_structs[ 67 ] = getstruct( "hip1_bp1_goal01", "targetname" );
	a_s_structs[ 68 ] = getstruct( "hip1_bp1_goal02", "targetname" );
	a_s_structs[ 69 ] = getstruct( "hip1_bp1_goal03", "targetname" );
	a_s_structs[ 70 ] = getstruct( "hip1_bp1_goal04", "targetname" );
	a_s_structs[ 71 ] = getstruct( "hip1_bp1_goal05", "targetname" );
	a_s_structs[ 72 ] = getstruct( "hip1_bp1_goal06", "targetname" );
	a_s_structs[ 73 ] = getstruct( "hip1_bp1_circle02", "targetname" );
	a_s_structs[ 74 ] = getstruct( "bp1_sentry_goal01", "targetname" );
	a_s_structs[ 75 ] = getstruct( "hip2_bp1_goal01", "targetname" );
	a_s_structs[ 76 ] = getstruct( "hip2_bp1_goal02", "targetname" );
	a_s_structs[ 77 ] = getstruct( "hip2_bp1_goal03", "targetname" );
	a_s_structs[ 78 ] = getstruct( "hip2_bp1_goal04", "targetname" );
		
	for ( i = 0; i < a_s_structs.size; i++ )
	{
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
}


struct_cleanup_wave2()
{
	a_s_structs = [];
	
	a_s_structs[ 0 ] = getstruct( "wave2bp2_player_horse_spawnpt", "targetname" );
	a_s_structs[ 1 ] = getstruct( "wave2bp2_zhao_horse_spawnpt", "targetname" );
	a_s_structs[ 2 ] = getstruct( "wave2bp2_woods_horse_spawnpt", "targetname" );
	a_s_structs[ 3 ] = getstruct( "wave2bp3_player_horse_spawnpt", "targetname" );
	a_s_structs[ 4 ] = getstruct( "wave2bp3_zhao_horse_spawnpt", "targetname" );
	a_s_structs[ 5 ] = getstruct( "wave2bp3_woods_horse_spawnpt", "targetname" );
	a_s_structs[ 6 ] = getstruct( "bp2_mortar1_obj", "targetname" );
	a_s_structs[ 7 ] = getstruct( "bp2_mortar2_obj", "targetname" );
	a_s_structs[ 8 ] = getstruct( "cache1_horse_spawnpt", "targetname" );
	a_s_structs[ 9 ] = getstruct( "bp2_cache_obj", "targetname" );
	a_s_structs[ 10 ] = getstruct( "arch_target", "targetname" );
	a_s_structs[ 11] = getstruct( "zhao_teleport_pos", "targetname" );
	a_s_structs[ 12 ] = getstruct( "woods_teleport_pos", "targetname" );
	a_s_structs[ 13 ] = getstruct( "bp2_mortar1_pos", "targetname" );
	a_s_structs[ 14 ] = getstruct( "bp2_mortar2_pos", "targetname" );
	a_s_structs[ 15 ] = getstruct( "mortar_victim_right_spawnpt", "targetname" );
	a_s_structs[ 16 ] = getstruct( "mortar_victim_left_spawnpt", "targetname" );
	a_s_structs[ 17 ] = getstruct( "bp3_bp2_mortar_truck_spawnpt", "targetname" );
	a_s_structs[ 18 ] = getstruct( "bp3_bp2_mortar_truck_goal", "targetname" );
	a_s_structs[ 19 ] = getstruct( "mortar_victim_truck_goal", "targetname" );
	a_s_structs[ 20 ] = getstruct( "bp2_mig1_spawnpt", "targetname" );
	a_s_structs[ 21 ] = getstruct( "bp2_mig2_spawnpt", "targetname" );
	a_s_structs[ 22 ] = getstruct( "bp2_mig3_spawnpt", "targetname" );
	a_s_structs[ 23 ] = getstruct( "bp2_exit_horse_spawnpt", "targetname" );
	a_s_structs[ 24 ] = getstruct( "exit_battle_horse_goal4", "targetname" );
	a_s_structs[ 25 ] = getstruct( "bp2_exit_uaz1_spawnpt1", "targetname" );
	a_s_structs[ 26 ] = getstruct( "bp2_exit_uaz1_spawnpt2", "targetname" );
	a_s_structs[ 27 ] = getstruct( "bp2_exit_uaz2_spawnpt1", "targetname" );
	a_s_structs[ 28 ] = getstruct( "bp2_exit_uaz2_spawnpt2", "targetname" );
	a_s_structs[ 29 ] = getstruct( "bp2_exit_truck1_spawnpt", "targetname" );
	a_s_structs[ 30 ] = getstruct( "bp2_exit_truck2_spawnpt", "targetname" );
	a_s_structs[ 31 ] = getstruct( "bp2_exit_btr_spawnpt", "targetname" );
	a_s_structs[ 32 ] = getstruct( "bp2_horse_return", "targetname" );
	a_s_structs[ 33 ] = getstruct( "bp2_hitch", "targetname" );
	a_s_structs[ 34 ] = getstruct( "zhao_cache", "targetname" );
	a_s_structs[ 35 ] = getstruct( "bp2_zhaohorse_return", "targetname" );
	a_s_structs[ 36 ] = getstruct( "zhao_bp2_goal3", "targetname" );
	a_s_structs[ 37 ] = getstruct( "zhao_bp2_goal5", "targetname" );
	a_s_structs[ 38 ] = getstruct( "zhao_bp2_goal7", "targetname" );
	a_s_structs[ 39 ] = getstruct( "zhao_bp2_goal9", "targetname" );
	a_s_structs[ 40 ] = getstruct( "rpg_bridge_fire", "targetname" );
	a_s_structs[ 41 ] = getstruct( "bp2_woodshorse_return", "targetname" );
	a_s_structs[ 42 ] = getstruct( "woods_btr_chase_goal1", "targetname" );
	a_s_structs[ 43 ] = getstruct( "zhao_btr_chase_goal1", "targetname" );
	a_s_structs[ 44 ] = getstruct( "bp2_horse_runspot", "targetname" );
	a_s_structs[ 45 ] = getstruct( "ramp_horse_clear", "targetname" );
	a_s_structs[ 46 ] = getstruct( "cache_horse_clear", "targetname" );
	a_s_structs[ 47 ] = getstruct ( "bp2_horse_delete", "targetname" );
	a_s_structs[ 48 ] = getstruct( "wave2bp2_hip2_spawnpt", "targetname" );
	a_s_structs[ 49 ] = getstruct( "wave2bp2_hip1_spawnpt", "targetname" );
	a_s_structs[ 50 ] = getstruct( "wave2bp2_btr1_spawnpt", "targetname" );
	a_s_structs[ 51 ] = getstruct( "wave2bp2_btr2_spawnpt", "targetname" );
	a_s_structs[ 52 ] = getstruct( "wave2bp2_hip1_spawnpt", "targetname" );
	a_s_structs[ 53 ] = getstruct( "wave2bp2_btr1_spawnpt", "targetname" );
	a_s_structs[ 54 ] = getstruct( "wave2bp2_tank_spawnpt", "targetname" );
	a_s_structs[ 55 ] = getstruct( "cave_transport_pad", "targetname" );
	a_s_structs[ 56 ] = getstruct( "wave2bp2_tank_spawnpt", "targetname" );
	a_s_structs[ 57 ] = getstruct( "bp2_reinforce_horse_spawnpt", "targetname" );
	a_s_structs[ 58 ] = getstruct( "muj_reinforce_right", "targetname" );
	a_s_structs[ 59 ] = getstruct( "muj_right_goal1", "targetname" );
	a_s_structs[ 60 ] = getstruct( "muj_right_goal2", "targetname" );
	a_s_structs[ 61 ] = getstruct( "muj_right_goal3", "targetname" );
	a_s_structs[ 62 ] = getstruct( "muj_right_goal4", "targetname" );
	a_s_structs[ 63 ] = getstruct( "muj_reinforce_left", "targetname" );
	a_s_structs[ 64 ] = getstruct( "muj_left_goal1", "targetname" );
	a_s_structs[ 65 ] = getstruct( "muj_left_goal2", "targetname" );
	a_s_structs[ 66 ] = getstruct( "muj_left_goal3", "targetname" );
	a_s_structs[ 67 ] = getstruct( "muj_left_goal4", "targetname" );
	a_s_structs[ 68 ] = getstruct( "hipdropoff1_spawnpt", "targetname" );
	a_s_structs[ 69 ] = getstruct( "hipdropoff2_spawnpt", "targetname" );
	a_s_structs[ 70 ] = getstruct( "hipdropoff3_spawnpt", "targetname" );
	a_s_structs[ 71 ] = getstruct( "hipdropoff4_spawnpt", "targetname" );
	a_s_structs[ 72 ] = getstruct( "hip_dropoff_goal1", "targetname" );
	a_s_structs[ 73 ] = getstruct( "hip_dropoff_goal2", "targetname" );
	a_s_structs[ 74 ] = getstruct( "hip_dropoff_goal3", "targetname" );
	a_s_structs[ 75 ] = getstruct( "hip_dropoff_goal4", "targetname" );
	a_s_structs[ 76 ] = getstruct( "hip1_dropoff", "targetname" );
	a_s_structs[ 77 ] = getstruct( "hip_dropoff_goal1", "targetname" );
	a_s_structs[ 78 ] = getstruct( "hip_dropoff_goal2", "targetname" );
	a_s_structs[ 79 ] = getstruct( "hip_dropoff_goal3", "targetname" );
	a_s_structs[ 80 ] = getstruct( "hip_dropoff_goal4", "targetname" );
	a_s_structs[ 81 ] = getstruct( "hip2_dropoff_goal0", "targetname" );
	a_s_structs[ 82 ] = getstruct( "hip1_wave2bp2_goal1", "targetname" );
	a_s_structs[ 83 ] = getstruct( "hip1_wave2bp2_goal2", "targetname" );
	a_s_structs[ 84 ] = getstruct( "hip1_wave2bp2_goal3", "targetname" );
	a_s_structs[ 85] = getstruct( "hip1_wave2bp2_goal4", "targetname" );
	a_s_structs[ 86 ] = getstruct( "hip1_wave2bp2_goal5", "targetname" );
	a_s_structs[ 87 ] = getstruct( "hip1_wave2bp2_goal6", "targetname" );
	a_s_structs[ 88 ] = getstruct( "bp2_circle_goal01", "targetname" );
	a_s_structs[ 89 ] = getstruct( "bp2_sentry_goal08", "targetname" );
	a_s_structs[ 90 ] = getstruct( "hip2_wave2bp2_goal1", "targetname" );
	a_s_structs[ 91 ] = getstruct( "hip2_wave2bp2_goal2", "targetname" );
	a_s_structs[ 92 ] = getstruct( "hip2_wave2bp2_goal3", "targetname" );
	a_s_structs[ 93 ] = getstruct( "hip2_wave2bp2_goal4", "targetname" );
	a_s_structs[ 94 ] = getstruct( "bp2_hind_goal01", "targetname" );
	a_s_structs[ 95 ] = getstruct( "bp2_hind_goal02", "targetname" );
	a_s_structs[ 96 ] = getstruct( "bp2_hind_goal03", "targetname" );
	a_s_structs[ 97 ] = getstruct( "bp2_hind_goal04", "targetname" );
	a_s_structs[ 98 ] = getstruct( "bp2_hind_goal05", "targetname" );
	a_s_structs[ 99 ] = getstruct( "bp2_hind_goal06", "targetname" );
	a_s_structs[ 100 ] = getstruct( "bp2_hind_goal07", "targetname" );
	a_s_structs[ 101 ] = getstruct( "bp2_hind_goal08", "targetname" );
	a_s_structs[ 102 ] = getstruct( "bp2_hind_goal09", "targetname" );
	a_s_structs[ 103 ] = getstruct( "bp2_hind_goal10", "targetname" );
	a_s_structs[ 104 ] = getstruct( "hind_bp3_goal12", "targetname" );
	a_s_structs[ 105 ] = getstruct( "bp2_hind_right01", "targetname" );
	a_s_structs[ 106 ] = getstruct( "bp2_hind_right02", "targetname" );
	a_s_structs[ 107 ] = getstruct( "bp2_hind_right03", "targetname" );
	a_s_structs[ 108 ] = getstruct( "bp2_hind_right04", "targetname" );
	a_s_structs[ 109 ] = getstruct( "bp2_hind_left01", "targetname" );
	a_s_structs[ 110 ] = getstruct( "bp2_hind_left02", "targetname" );
	a_s_structs[ 111 ] = getstruct( "bp2_hind_left03", "targetname" );
	a_s_structs[ 112 ] = getstruct( "bp2_hind_left04", "targetname" );
	a_s_structs[ 113 ] = getstruct( "bp2_hind_cache1", "targetname" );
	a_s_structs[ 114 ] = getstruct( "bp2_hind_cache2", "targetname" );
	a_s_structs[ 115 ] = getstruct( "bp2_hind_cache3", "targetname" );
	a_s_structs[ 116 ] = getstruct( "bp2_hind_cache4", "targetname" );
	a_s_structs[ 117 ] = getstruct( "bp3_uaz1_spawnpt", "targetname" );
	a_s_structs[ 118 ] = getstruct( "bp3_uaz2_spawnpt", "targetname" );
	a_s_structs[ 119 ] = getstruct( "btr_chase_spawnpt", "targetname" );
	a_s_structs[ 120 ] = getstruct( "btr_chase_goal1", "targetname" );
	a_s_structs[ 121 ] = getstruct( "btr_chase_goal2", "targetname" );
	a_s_structs[ 122 ] = getstruct( "bp3_exit_chopper_spawnpt", "targetname" );
	a_s_structs[ 123 ] = getstruct( "bp3_exit_horse_spawnpt", "targetname" );
	a_s_structs[ 124 ] = getstruct( "exit_battle_horse_goal4", "targetname" );
	a_s_structs[ 125 ] = getstruct( "bp3_exit_chopper_spawnpt", "targetname" );
	a_s_structs[ 126 ] = getstruct( "bp3_exit_chopper_goal0", "targetname" );
	a_s_structs[ 127 ] = getstruct( "bp3_exit_chopper_goal1", "targetname" );
	a_s_structs[ 128 ] = getstruct( "bp3_exit_chopper_goal2", "targetname" );
	a_s_structs[ 129 ] = getstruct( "bp3_exit_chopper_goal3", "targetname" );
	a_s_structs[ 130 ] = getstruct( "btr1_bp3_spawnpt", "targetname" );
	a_s_structs[ 131 ] = getstruct( "btr2_bp3_spawnpt", "targetname" );
	a_s_structs[ 132 ] = getstruct( "btr1_bp3_spawnpt", "targetname" );
	a_s_structs[ 133 ] = getstruct( "rpg_bridge_target", "targetname" );
	a_s_structs[ 134 ] = getstruct( "wave3bp3_tank_spawnpt", "targetname" );
	a_s_structs[ 135 ] = getstruct( "rpg_sniper_target", "targetname" );
	a_s_structs[ 136 ] = getstruct( "bp2_exit_divert", "targetname" );
	a_s_structs[ 137 ] = getstruct( "bp2_exit_battle_zhao", "targetname" );
	a_s_structs[ 138 ] = getstruct( "bp2_exit_divert", "targetname" );
	a_s_structs[ 139 ] = getstruct( "bp2_exit_battle_woods", "targetname" );
	a_s_structs[ 140 ] = getstruct( "tank_bp3_spawnpt", "targetname" );
	a_s_structs[ 141 ] = getstruct( "bp3_hind1_spawnpt", "targetname" );
	a_s_structs[ 142 ] = getstruct( "bp3_horse_rideoff", "targetname" );
	a_s_structs[ 143 ] = getstruct( "bp3_hip1_spawnpt", "targetname" );
	a_s_structs[ 144 ] = getstruct( "bp3_hip2_spawnpt", "targetname" );
	a_s_structs[ 145 ] = getstruct( "hip1_bp3_liftoff", "targetname" );
	a_s_structs[ 146 ] = getstruct( "hip1_bp3_dropoff", "targetname" );;
	a_s_structs[ 147 ] = getstruct( "hip1_bp3_ascent", "targetname" );
	a_s_structs[ 148 ] = getstruct( "hip_bp3_circle01", "targetname" );
	a_s_structs[ 149 ] = getstruct( "bp3_sentry_goal07", "targetname" );
	a_s_structs[ 150 ] = getstruct( "hip2_bp3_liftoff", "targetname" );
	a_s_structs[ 151 ] = getstruct( "hip2_bp3_over", "targetname" );
	a_s_structs[ 152 ] = getstruct( "hip2_bp3_approach", "targetname" );
	a_s_structs[ 153 ] = getstruct( "hip2_bp3_dropoff", "targetname" );
	a_s_structs[ 154 ] = getstruct( "hip2_bp3_away", "targetname" );
	a_s_structs[ 155 ] = getstruct( "crew_stinger_fire", "targetname" );
	a_s_structs[ 156 ] = getstruct( "hind_bridge_target", "targetname" );
	a_s_structs[ 157 ] = getstruct( "hind_bp3_goal1", "targetname" );
	a_s_structs[ 158 ] = getstruct( "hind_bp3_goal2", "targetname" );
	a_s_structs[ 159 ] = getstruct( "hind_bp3_goal3", "targetname" );
	a_s_structs[ 160 ] = getstruct( "hind_bp3_goal4", "targetname" );
	a_s_structs[ 161 ] = getstruct( "hind_bp3_goal5", "targetname" );
	a_s_structs[ 162 ] = getstruct( "hind_bp3_goal6", "targetname" );
	a_s_structs[ 163 ] = getstruct( "hind_bp3_goal7", "targetname" );
	a_s_structs[ 164 ] = getstruct( "hind_bp3_goal8", "targetname" );
	a_s_structs[ 165 ] = getstruct( "hind_bp3_goal9", "targetname" );
	a_s_structs[ 166 ] = getstruct( "hind_bp3_goal10", "targetname" );
	a_s_structs[ 167 ] = getstruct( "hind_bp3_goal11", "targetname" );
	a_s_structs[ 168 ] = getstruct( "hind_bp3_goal12", "targetname" );
	a_s_structs[ 169 ] = getstruct( "hind_bp3_goal13", "targetname" );
	a_s_structs[ 170 ] = getstruct( "hind_bp3_goal14", "targetname" );
	a_s_structs[ 171 ] = getstruct( "hind_bp3_goal15", "targetname" );
	a_s_structs[ 172 ] = getstruct( "hind_bp3_goal3", "targetname" );
	a_s_structs[ 173 ] = getstruct( "hind_bp3_goal4", "targetname" );
	a_s_structs[ 174 ] = getstruct( "hind_bp3_goal5", "targetname" );
	a_s_structs[ 175 ] = getstruct( "hind_bp3_goal6", "targetname" );
	a_s_structs[ 176 ] = getstruct( "hind_bp3_goal7", "targetname" );
	a_s_structs[ 177 ] = getstruct( "hind_bp3_goal8", "targetname" );
	a_s_structs[ 178 ] = getstruct( "hind_bp3_base01", "targetname" );
	a_s_structs[ 179 ] = getstruct( "hind_bp3_base02", "targetname" );
	a_s_structs[ 180 ] = getstruct( "hind_bp3_base03", "targetname" );
	a_s_structs[ 181 ] = getstruct( "hind_bp3_base04", "targetname" );
	a_s_structs[ 182 ] = getstruct( "hind_bp3_base05", "targetname" );
	a_s_structs[ 183 ] = getstruct( "bp3_heli_hip_spawnpt", "targetname" );
	a_s_structs[ 184 ] = getstruct( "statue_entrance_rpg", "targetname" );
	a_s_structs[ 185 ] = getstruct( "statue_entrance_target", "targetname" );
			
	for ( i = 0; i < a_s_structs.size; i++ )
	{
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_structs = getstructarray( "bp3_approach_explosion", "targetname" );
	for ( i = 0; i < a_structs.size; i++ )
	{
		if ( IsDefined( a_structs[ i ] ) )
		{
			a_structs[ i ] structdelete();
			a_structs[ i ] = undefined;	
		}
	}
	
	
	a_s_hitpts = getstructarray( "mortar_hit_point", "targetname" );
	for ( i = 0; i < a_s_hitpts.size; i++ )
	{
		if ( IsDefined( a_s_hitpts[ i ] ) )
		{
			a_s_hitpts[ i ] structdelete();
			a_s_hitpts[ i ] = undefined;
		}
	}
	
	a_s_spawnpts = [];
	for ( i = 0; i < 8; i++ )
	{
		a_s_spawnpts[ i ] = getstruct( "horse_lineup_spawnpt" + i, "targetname" );
		if ( IsDefined( a_s_spawnpts[ i ] ) )
		{
			a_s_spawnpts[ i ] structdelete();
			a_s_spawnpts[ i ] = undefined;
		}
	}
	
	a_s_goal = [];
	for ( i = 1; i < 19; i++ )
	{
		a_s_goal[ i ] = getstruct( "hind_bp3_goal"+i, "targetname" );
		if ( IsDefined( a_s_goal[ i ] ) )
		{
			a_s_goal[ i ] structdelete();
			a_s_goal[ i ] = undefined;
		}
	}
	
	a_s_spawnpts = [];
	for ( i = 0; i < 9; i++ )
	{
		a_s_spawnpts[ i ] = getstruct( "bp3_horse_spawnpt" + i, "targetname" );
		if ( IsDefined( a_s_spawnpts[ i ] ) )
		{
			a_s_spawnpts[ i ] structdelete();
			a_s_spawnpts[ i ] = undefined;
		}
	}
}


struct_cleanup_firehorse()
{
	a_s_structs = [];
	
	a_s_structs[ 0 ] = getstruct( "muj_horse_exit", "targetname" );
	a_s_structs[ 1 ] = getstruct( "firehorse_zhao_spawnpt", "targetname" );
	a_s_structs[ 2 ] = getstruct( "firehorse_woods_spawnpt", "targetname" );
	a_s_structs[ 3 ] = getstruct( "firehorse_mason_spawnpt", "targetname" );
	a_s_structs[ 4 ] = getstruct( "rpg_fireat_hip1", "targetname" );
	a_s_structs[ 5 ] = getstruct( "flaming_horse_goal", "targetname" );
	a_s_structs[ 6 ] = getstruct( "mig_cave_strafe_spawnpt", "targetname" );
	a_s_structs[ 7 ] = getstruct( "mig_cave_strafe_goal2", "targetname" );
	a_s_structs[ 8 ] = getstruct( "hip4_approach", "targetname" );
	a_s_structs[ 9 ] = getstruct( "arena_mig1_start", "targetname" );
	a_s_structs[ 10 ] = getstruct( "arena_mig1_mid", "targetname" );
	a_s_structs[ 11 ] = getstruct( "arena_mig1_end", "targetname" );
	a_s_structs[ 12 ] = getstruct( "hip4_hover", "targetname" );
	a_s_structs[ 13 ] = getstruct( "explosion_base01", "targetname" );
	a_s_structs[ 14 ] = getstruct( "base_horse_goal1", "targetname" );
	a_s_structs[ 15 ] = getstruct( "mig23_bomb_exp1", "targetname" );
	a_s_structs[ 16 ] = getstruct( "mig23_bomb_exp2", "targetname" );
	a_s_structs[ 17 ] = getstruct( "hip4_liftoff", "targetname" );
	a_s_structs[ 18 ] = getstruct( "hip3_land", "targetname" );
	a_s_structs[ 19 ] = getstruct( "hip4_descent", "targetname" );
	a_s_structs[ 20 ] = getstruct( "hip4_factory", "targetname" );
	a_s_structs[ 21 ] = getstruct( "mig_shootat", "targetname" );
	a_s_structs[ 22 ] = getstruct( "tunnel_runner_killer", "targetname" );
	a_s_structs[ 23 ] = getstruct( "mig_in_face_spawnpt", "targetname" );
	a_s_structs[ 24 ] = getstruct( "mig23_firehorse_spawnpt", "targetname" );
	a_s_structs[ 25 ] = getstruct( "first_mig_delete", "targetname" );
	a_s_structs[ 26 ] = getstruct( "hip4_air", "targetname" );
	a_s_structs[ 27 ] = getstruct( "hip4_mid", "targetname" );
	a_s_structs[ 28 ] = getstruct( "arena_uaz1_spawnpt", "targetname" );
	a_s_structs[ 29 ] = getstruct( "uaz1_entry", "targetname" );
	a_s_structs[ 30 ] = getstruct( "arena_goal_01", "targetname" );
	a_s_structs[ 31 ] = getstruct( "uaz_stinger", "targetname" );
	a_s_structs[ 32 ] = getstruct( "afghan_tank_spawnpt", "targetname" );
	a_s_structs[ 33 ] = getstruct( "muj_tank_wait", "targetname" );
	a_s_structs[ 34 ] = getstruct( "muj_tank_pos", "targetname" );
	a_s_structs[ 35 ] = getstruct( "muj_tank_move", "targetname" );
	a_s_structs[ 36 ] = getstruct( "mig_tank_destroy_spawnpt", "targetname" );
	a_s_structs[ 37 ] = getstruct( "mig_tank_destroy_goal1", "targetname" );
	a_s_structs[ 38 ] = getstruct( "mig_tank_destroy_goal2", "targetname" );
	a_s_structs[ 39 ] = getstruct( "arena_uaz2_spawnpt", "targetname" );
	a_s_structs[ 40 ] = getstruct( "uaz2_goal_03", "targetname" );
	a_s_structs[ 41 ] = getstruct( "arena_uaz3_spawnpt", "targetname" );
	a_s_structs[ 42 ] = getstruct( "uaz3_goal", "targetname" );
	a_s_structs[ 43 ] = getstruct( "arena_hip2_spawn", "targetname" );
	a_s_structs[ 44 ] = getstruct( "arena_hip2_start", "targetname" );
	a_s_structs[ 45 ] = getstruct( "arena_hip2_mid", "targetname" );
	a_s_structs[ 46 ] = getstruct( "arena_hip2_destroy", "targetname" );
	a_s_structs[ 47 ] = getstruct( "arena_hip3", "targetname" );
	a_s_structs[ 48 ] = getstruct( "arena_hip3_start", "targetname" );
	a_s_structs[ 49 ] = getstruct( "arena_hip3_mid", "targetname" );
	a_s_structs[ 50 ] = getstruct( "arena_hip3_land", "targetname" );
	a_s_structs[ 51 ] = getstruct( "arena_hip3_takeoff", "targetname" );
	a_s_structs[ 52 ] = getstruct( "arena_hip3_air", "targetname" );
	a_s_structs[ 53 ] = getstruct( "arena_hip3_far", "targetname" );
	a_s_structs[ 54 ] = getstruct( "arena_hip3_end", "targetname" );
	a_s_structs[ 55 ] = getstruct( "hip3_factory", "targetname" );
	a_s_structs[ 56 ] = getstruct( "hip3_takeoff", "targetname" );
	a_s_structs[ 57 ] = getstruct( "hip3_air", "targetname" );
	a_s_structs[ 58 ] = getstruct( "hip3_approach", "targetname" );
				
	for ( i = 0; i < a_s_structs.size; i++ )
	{
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_spawnpts = getstructarray( "base_horse_spawnpt", "targetname" );
	for ( i = 0; i < a_s_spawnpts.size; i++ )
	{
		if ( IsDefined( a_s_spawnpts[ i ] ) )
		{
			a_s_spawnpts[ i ] structdelete();
			a_s_spawnpts[ i ] = undefined;	
		}
	}
	
	a_s_explosion = getstructarray( "explosion_close_base", "targetname" );
	for ( i = 0; i < a_s_explosion.size; i++ )
	{
		if ( IsDefined( a_s_explosion[ i ] ) )
		{
			a_s_explosion[ i ] structdelete();
			a_s_explosion[ i ] = undefined;	
		}
	}
	
	a_s_explos = getstructarray( "explosion_far_base", "targetname" );
	for ( i = 0; i < a_s_explos.size; i++ )
	{
		if ( IsDefined( a_s_explos[ i ] ) )
		{
			a_s_explos[ i ] structdelete();
			a_s_explos[ i ] = undefined;	
		}
	}

	a_s_scts = getstructarray( "explosion_player", "targetname" );
	for ( i = 0; i < a_s_scts.size; i++ )
	{
		if ( IsDefined( a_s_scts[ i ] ) )
		{
			a_s_scts[ i ] structdelete();
			a_s_scts[ i ] = undefined;	
		}
	}
	
	a_s_stcts = getstructarray( "arena_explosion_far", "targetname" );	
	for ( i = 0; i < a_s_stcts.size; i++ )
	{
		if ( IsDefined( a_s_stcts[ i ] ) )
		{
			a_s_stcts[ i ] structdelete();
			a_s_stcts[ i ] = undefined;	
		}
	}
	
	a_s_flyovers = getstructarray( "mig_base_flyover1", "targetname" );
	for ( i = 0; i < a_s_flyovers.size; i++ )
	{
		if ( IsDefined( a_s_flyovers[ i ] ) )
		{
			a_s_flyovers[ i ] structdelete();
			a_s_flyovers[ i ] = undefined;	
		}
	}
	
	a_s_migs = getstructarray( "mig_flyover_delete1", "targetname" );
	for ( i = 0; i < a_s_migs.size; i++ )
	{
		if ( IsDefined( a_s_migs[ i ] ) )
		{
			a_s_migs[ i ] structdelete();
			a_s_migs[ i ] = undefined;	
		}
	}
	
	a_s_mig_base = getstructarray( "mig_base_flyover2", "targetname" );
	for ( i = 0; i < a_s_mig_base.size; i++ )
	{
		if ( IsDefined( a_s_mig_base[ i ] ) )
		{
			a_s_mig_base[ i ] structdelete();
			a_s_mig_base[ i ] = undefined;	
		}
	}
	
	a_s_delete2 = getstructarray( "mig_flyover_delete2", "targetname" );
	for ( i = 0; i < a_s_delete2.size; i++ )
	{
		if ( IsDefined( a_s_delete2[ i ] ) )
		{
			a_s_delete2[ i ] structdelete();
			a_s_delete2[ i ] = undefined;	
		}
	}
}


struct_cleanup_wave3()
{
	a_s_structs = [];
	
	a_s_structs[ 0 ] = getstruct( "wave1_player_horse_spawnpt", "targetname" );
	a_s_structs[ 1 ] = getstruct( "wave1_zhao_horse_spawnpt", "targetname" );
	a_s_structs[ 2 ] = getstruct( "wave1_woods_horse_spawnpt", "targetname" );
	a_s_structs[ 3 ] = getstruct( "zhao_bp3", "targetname" );
	a_s_structs[ 4 ] = getstruct( "bp3_entrance", "targetname" );
	a_s_structs[ 5 ] = getstruct( "truckride_spawnpt", "targetname" );
	a_s_structs[ 6 ] = getstruct( "bp1wave3_hip1_spawnpt", "targetname" );
	a_s_structs[ 7 ] = getstruct( "bp1wave3_hip2_spawnpt", "targetname" );
	a_s_structs[ 8 ] = getstruct( "bp1_hind1_spawnpt", "targetname" );
	a_s_structs[ 9 ] = getstruct( "bp1_hind2_spawnpt", "targetname" );
	a_s_structs[ 10 ] = getstruct( "bp1wave3_hip1_goal1", "targetname" );
	a_s_structs[ 11 ] = getstruct( "bp1wave3_hip1_goal2", "targetname" );
	a_s_structs[ 12 ] = getstruct( "bp1wave3_hip_circle2", "targetname" );
	a_s_structs[ 13 ] = getstruct( "hip_arena_circle1", "targetname" );
	a_s_structs[ 14 ] = getstruct( "bp1wave3_hip2_goal1", "targetname" );
	a_s_structs[ 15 ] = getstruct( "bp1wave3_hip_circle1", "targetname" );
	a_s_structs[ 16 ] = getstruct( "bp1_hind1_cache1", "targetname" );
	a_s_structs[ 17 ] = getstruct( "bp1_hind1_cache2", "targetname" );
	a_s_structs[ 18 ] = getstruct( "bp1_hind1_cache3", "targetname" );
	a_s_structs[ 19 ] = getstruct( "bp1_hind2_cache1", "targetname" );
	a_s_structs[ 20 ] = getstruct( "bp1_hind2_cache2", "targetname" );
	a_s_structs[ 21 ] = getstruct( "bp1_obj_marker2", "targetname" );
	a_s_structs[ 22 ] = getstruct( "bp2_obj_marker", "targetname" );
	a_s_structs[ 23 ] = getstruct( "bp3_obj_marker", "targetname" );
	a_s_structs[ 24 ] = getstruct( "zhao_bp1wave3_goal", "targetname" );
	a_s_structs[ 25 ] = getstruct( "woods_bp1wave3_goal", "targetname" );
	a_s_structs[ 26 ] = getstruct( "zhao_bp2", "targetname" );
	a_s_structs[ 27 ] = getstruct( "woods_bp2", "targetname" );
	a_s_structs[ 28 ] = getstruct( "woods_bp3", "targetname" );
	a_s_structs[ 29 ] = getstruct( "bp3wave3_hind_spawnpt", "targetname" );
	a_s_structs[ 30 ] = getstruct( "bp2wave3_hind_spawnpt", "targetname" );
	
	for ( i = 0; i < a_s_structs.size; i++ )
	{
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];
	for ( i = 1; i < 8; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp1_hind2_basegoal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
		
	a_s_structs = [];
	for ( i = 1; i < 14; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp2wave3_hind_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];
	for ( i = 1; i < 13; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp3wave3_hind_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];
	for ( i = 1; i < 10; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp1_hind2_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];
	for ( i = 1; i < 10; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp1_hind1_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];
	for ( i = 1; i < 8; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp1_hind1_basegoal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}	
}


struct_cleanup_blocking_done()
{
	a_s_structs = [];
	
	s_horse_zhao = getstruct( "last_zhao_horse", "targetname" );
	s_horse_woods = getstruct( "last_woods_horse", "targetname" );
	s_horse_player = getstruct( "last_player_horse", "targetname" );
	s_return_base = getstruct( "zhao_return", "targetname" );
	s_return_base = getstruct( "return_base_pos", "targetname" );
	s_defend = getstruct( "base_defend_pos", "targetname" );
	s_spawnpt = getstruct( "truck_base_defense_spawnpt", "targetname" );
	s_goal0 = getstruct( "reinforcement_goal0", "targetname" );
	s_goal1 = getstruct( "reinforcement_goal1", "targetname" );
	s_goal2 = getstruct( "reinforcement_goal2", "targetname" );
	s_goal3 = getstruct( "reinforcement_goal3", "targetname" );
	s_goal1 = getstruct( "truck_goal1", "targetname" );
	s_goal2 = getstruct( "truck_goal2", "targetname" );
	s_goal3 = getstruct( "truck_goal3", "targetname" );
	s_hip1_spawnpt = getstruct( "bp1wave4_hip1_spawnpt", "targetname" );
	s_hip2_spawnpt = getstruct( "bp1wave4_hip2_spawnpt", "targetname" );
	s_hind1_spawnpt = getstruct( "bp1wave4_hind1_spawnpt", "targetname" );
	s_hind2_spawnpt = getstruct( "bp1wave4_hind2_spawnpt", "targetname" );
	s_hip1_spawnpt = getstruct( "bp2wave4_hip1_spawnpt", "targetname" );
	s_hip2_spawnpt = getstruct( "bp2wave4_hip2_spawnpt", "targetname" );
	s_btr1_spawnpt = getstruct( "wave4bp2_btr1_spawnpt", "targetname" );
	s_btr2_spawnpt = getstruct( "wave4bp2_btr2_spawnpt", "targetname" );
	s_spawnpt = getstruct( "wave4bp2_tank1_spawnpt", "targetname" );
	s_hind1_spawnpt = getstruct( "bp2wave4_hind1_spawnpt", "targetname" );
	s_hind2_spawnpt = getstruct( "bp2wave4_hind2_spawnpt", "targetname" );
	s_spawnpt = getstruct( "wave4bp2_tank2_spawnpt", "targetname" );
	s_goal1 = getstruct( "bp2wave4_hind_attackpos", "targetname" );
	s_hip1_spawnpt = getstruct( "bp3wave4_hip1_spawnpt", "targetname" );
	s_hip2_spawnpt = getstruct( "bp3wave4_hip2_spawnpt", "targetname" );
	s_spawnpt = getstruct( "wave4bp3_btr1_spawnpt", "targetname" );
	s_spawnpt = getstruct( "wave4bp3_btr2_spawnpt", "targetname" );
	s_hind1_spawnpt = getstruct( "bp3wave4_hind1_spawnpt", "targetname" );
	s_hind2_spawnpt = getstruct( "bp3wave4_hind2_spawnpt", "targetname" );
	s_spawnpt = getstruct( "wave4bp3_tank1_spawnpt", "targetname" );
	s_spawnpt = getstruct( "wave4bp3_tank2_spawnpt", "targetname" );
	
	for ( i = 0; i < a_s_structs.size; i++ )
	{
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];	
	for( i = 1; i < 19; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp1wave4_hind2_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];
	for( i = 1; i < 23; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp1wave4_hind1_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];
	for( i = 1; i < 17; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp2wave4_hip1_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];	
	for( i = 1; i < 17; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp2wave4_hip2_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];
	for( i = 1; i < 15; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp1wave4_hip2_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];
	for( i = 1; i < 12; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp2wave4_hind1_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];	
	for( i = 1; i < 12; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp2wave4_hind2_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];
	for( i = 1; i < 14; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp3wave4_hip1_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];	
	for( i = 1; i < 14; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp3wave4_hip2_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];	
	for( i = 1; i < 13; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp3wave4_hind1_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}

	a_s_structs = [];	
	for( i = 1; i < 13; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp3wave4_hind2_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;	
		}
	}
	
	a_s_structs = [];
	for( i = 1; i < 12; i++ )
	{
		a_s_structs[ i ] = getstruct( "bp1wave4_hip1_goal"+i, "targetname" );
		if ( IsDefined( a_s_structs[ i ] ) )
		{
			a_s_structs[ i ] structdelete();
			a_s_structs[ i ] = undefined;
		}
	}
}