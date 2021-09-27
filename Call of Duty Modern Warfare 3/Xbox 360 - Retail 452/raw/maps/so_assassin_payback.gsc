#include common_scripts\utility;
#include maps\_anim;
#include maps\_sandstorm;
#include maps\_specialops;
#include maps\ss_util;
#include maps\_utility;
#include maps\_vehicle;

#using_animtree("generic_human");
main()
{
 
	maps\so_assassin_payback_precache::main();
	maps\payback_precache::main();
	PreCacheItem( "smoke_grenade_american" );
	PreCacheItem( "zippy_rockets" );
	
	// need to delay createfx sounds for PC ship for the first few frames
	level.delay_createfx_seconds = 0.5;
	
	maps\_compass::setupMiniMap( "compass_map_payback_port", "port_minimap_corner" );
	
	// fx from base map
	maps\payback_fx::main();
	so_fixup_all_createfx();
	
	 // required by base map
    level._effect["_breach_doorbreach_detpack"]             = loadfx("explosions/exp_pack_doorbreach");
    level._effect["aerial_explosion_large_linger"]               = loadfx("explosions/aerial_explosion_large_linger");
	
	maps\_chopperboss::chopper_boss_load_fx();

	// effect for smoke grenade
	level._effect[ "extraction_smoke" ]				= LoadFX( "smoke/signal_smoke_green" );

	PrecacheMinimapSentryCodeAssets();
	
	add_hint_string( "contact_hostage", &"SO_ASSASSIN_PAYBACK_USE_HOSTAGE", ::show_hostage_hint );
	add_hint_string( "throw_smoke", &"SO_ASSASSIN_PAYBACK_THROW_SMOKE", ::show_smoke_hint );

	setup_players();
	maps\_load::main();
	maps\_stinger::init();
	
	initialize_flags();
		
	level thread enable_escape_warning();
	level thread enable_escape_failure();
	
	/////////////  END PRECACHING
	
	thread enable_challenge_timer( "so_assassin_payback_start", "so_assassin_payback_complete" );
	thread fade_challenge_in();
	thread fade_challenge_out( "so_assassin_payback_complete" );
	
	wait( 0.1 );	// to assist online co-op loading
	
	GetEnt("pb_end_vista", "targetname") Hide();
	
	right_gate = GetEnt( "intro_gate_right", "targetname" );
	right_gate Delete();
	left_gate = GetEnt( "intro_gate_left", "targetname" );
	left_gate Delete();
	
	level.scr_anim[ "generic" ][ "casual_killer_walk_f" ][0]	= %casual_killer_walk_f;
	level.scr_anim[ "generic" ][ "casual_stand_idle" ] 			= %casual_stand_idle;
	level.scr_anim[ "generic" ][ "death_pose_07" ]				= %paris_npc_dead_poses_v07;
	level.scr_anim[ "generic" ][ "death_pose_08" ]				= %paris_npc_dead_poses_v08;
	
    // audio from base map
    maps\_shg_common::so_mark_class( "trigger_multiple_audio" );    	
	maps\_shg_common::so_mark_class( "trigger_multiple_visionset" );
    maps\payback_aud::main();
    wait( 0.1 );	// to assist online co-op loading            
	setup();
	thread setup_vo();
	wait( 0.1 );	// to assist online co-op loading
	gameplay_logic();	
}

so_fixup_all_createfx()
{
	foreach( i, fx in level.createFXent )
	{
		if ( can_remove_soundfx( fx ) )
		{
			level.createFXent[ i ] = undefined;
			fx.v = undefined;
			continue;
		}

		fx.script_specialops = 1;
	}

	level.createFXent = array_removeUndefined( level.createFXent );
}

can_remove_soundfx( fx )
{
	if ( fx.v[ "type" ] != "soundfx_interval" && fx.v[ "type" ] != "soundfx" )
	{
		return false;
	}

	if ( fx.v[ "origin" ][ 0 ] > 3400 )
	{
		return true;
	}

	if ( fx.v[ "origin" ][ 0 ] < -2400 )
	{
		return true;
	}

	if ( fx.v[ "origin" ][ 1 ] < 3500 )
	{
		return true;
	}

	return false;
}

show_hostage_hint()
{
	player = get_player_from_self();
	
	// not awesome:  determine which player is calling this function, and use that player's entry in the showing_hostage_hint_array
	// to determine whether we should
	
	for( i=0; i < level.players.size; i++ )
	{
		if( player == level.players[i] )
		{
			break;
		}
	}
	
	if ( level.showing_hostage_hint_array[ i ] == true )
	{
		return false;
	}
	else
	{
		return true;
	}
}


show_smoke_hint()
{
	if ( flag( "smoke_thrown" ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

initialize_flags()
{
	flag_init ("player_has_escaped");
	flag_init( "triggered_alert" );
	flag_init( "triggered_alert_1" ); // instantly wake group 1 if a player is rushing
	flag_init( "triggered_alert_3"); // instantly wake group 3 if a player is rushing
	flag_init( "out_of_stage_1" );
	flag_init( "attack_heli_spawned" );
	flag_init( "hostages_vulnerable" );
	flag_init( "near_hostages" );
	flag_init( "hostage_x_pressed" );
	flag_init( "hostage_reached" );
	flag_init( "smoke_thrown" );
	flag_init( "stop_green_smoke_fx" );
	flag_init( "rescue_arrives" );
	flag_init( "obj_vips_dead" );
	flag_init( "no_prone_water_trigger" );
}

setup()
{
	init_fog_brushes();

	
	// SP map saves
	save_base_map_ents();
	
	// SP map deletions
	so_delete_all_by_type( ::type_spawn_trigger, ::type_vehicle, ::type_spawners );
	delete_path_blockers();
	delete_basemap_ents();
	disconnect_specops_paths();
	
	level.enemy_array_group_1 = []; // group 1
	level.enemy_array_group_2 = []; // group 2
	level.enemy_array_group_3 = []; // group 3
	level.patroller_array = [];		// group 4
	level.hostage_guards = [];
	level.roof_guards = [];
	level.vip_array = [];
	level.vips_alive = 0;
	level.vips_loaded = 0;
	level.challenge_start_time = 0;
	level.hostage_position = undefined;
	level.hostage_detect_distance = 1575; // approx. 40 meters
	level.hostages_killed = 0;
	level.waves_spawned = 0;
	level.num_attack_helis = 0;
	level.last_wave_guys = [];
		
	level.awake_groups = [];
	level.awake_groups[0] = false;
	level.awake_groups[1] = false;
	level.awake_groups[2] = false;
	level.awake_groups[3] = false;
	level.stinger_targets = [];
	
	level.showing_hostage_hint_array = []; // for handling which player (or both) sees the "press X" message in co-op
	
	level.defendtime = 90; // total time of the defense
	level.cobra_lead_time = 5; // seconds the cobra spawns ahead of the blackhawk
	level.flighttime = 20; // time of the friendly helo's flight
	level.stickaroundtime = 5; // time after the friendly helo spawns that the bad guys stay
	
	level.max_end_waves = 4; // maximum waves of 10 guys that spawn and come through the gate at the end of the mission

	if( ( level.gameskill <= 1 ) && ( !is_coop() ) )
	{
		level.assassin_num_enemies = 32 + ( 10 * level.max_end_waves ); //  in Regular, there's one fewer littlebird
	}
	else
	{
		level.assassin_num_enemies = 34 + ( 10 * level.max_end_waves );
	}
	
	level.best_score_time = 120000; // 2 minutes or less for maximum time component score -- should be impossible
	level.max_score_time = 720000; // 12 minutes is the longest players can take and still get a time bonus
	
	level.escape_vehicle = undefined;
	
	/*  level.stage options:
	 * 0 "sleep" -- the inital phase, where everybody is a blind pacifist and VIPs wander around
	 * 1 "waking" -- one group has been alerted, the others are in the process of waking up
	 * 2 "alert" -- all groups are alerted, VIPs move to their cover positions
	 * 3 "rescue" -- VIPs are dead, hostage is marked on map
	 * 4 "signal" -- hostage reached,use a smoke grenade
	 * 5 "defend" -- defend timer counts down
	 * 6 "win"
	 */

	level.heli_arrival_time = 15;			// seconds after the level goes on alert that the littlebird shows up
	level.initialGuardSightRange = 64;
	level.initialGuardSightRangeSqrd = level.initialGuardSightRange * level.initialGuardSightRange;
	level.patrol_starttime = 30;			// if the players haven't begun advancing the stages, start this patrol
	level.stage = 0; 						// "sleep"
	
	thread spawn_corpses("balcony_corpses");	
	setup_enemies();
		
	level.vips_alive = level.vip_array.size;
	level.vips_loaded = 0;
	
	spawn_hostages();
		
	level.challenge_start_time = GetTime();
	
	level thread heli_timer();
}
    
init_fog_brushes()
{
	level.fog_brushes = array_combine( GetEntArray( "chopper_fog_brush", "targetname" ), GetEntArray( "sandstorm_sky", "targetname" ) );
	
	foreach( brush in level.fog_brushes )
	{
		brush Hide();
		brush NotSolid();
	}
}

//===========================================
// 			 save_base_map_ents
//===========================================
save_base_map_ents()
{
	ent_array = GetEntArray();
	
	foreach( ent in ent_array )
	{
		if( isdefined( ent.script_flag ) && ( ent.script_flag == "no_prone_water_trigger" ) )
		{
			ent.script_specialops = 1;
		}
	}
}

delete_path_blockers()
{
	script_models = GetEntArray( "SO_remove_model", "targetname" );
	
	for( i = 0; i < script_models.size; i++)
	{
		script_models[i] delete();
	}
	
	brush_models = GetEntArray( "SO_remove_brush", "targetname" );
	
	for( i = 0; i < brush_models.size; i++)
	{
		brush_models[i] NotSolid();
		
		if ( brush_models[i].spawnflags & 1 ) // check for DYNAMIC_PATH spawnflag
      	{
			brush_models[i] ConnectPaths();
      	}
	}
}

delete_basemap_ents( )
{
	// remove basemap hummers
	delete_by_key_value_pair( "placeholder_hummer_alpha", "targetname" );	
	delete_by_key_value_pair( "placeholder_hummer_bravo", "targetname" );
	
	delete_by_key_value_pair( "misc_turret", "classname" );
	delete_by_key_value_pair( "rpg_crate_clip", "targetname" );
	delete_by_key_value_pair( "hostage_dragunov", "targetname" );
	
	barrel = GetEntArray( "explodable_barrel", "targetname" );
	
	for( i = 0; i < barrel.size; i++)
	{
		if( IsDefined( barrel[i].target ) )
		{
			collision = GetEnt( barrel[i].target, "targetname" );
			
			if( IsDefined( collision ) )
			{
				collision hide_entity();
			}
		}
		barrel[i] delete();
	}

	script_models = GetEntArray( "script_model", "classname" ); 
	
	for( i = 0; i < script_models.size; i++)
	{
		if( !IsDefined( script_models[i].model ) )
		{
			continue;
		}
		
		if( script_models[i].model == "pb_mortar_dmg" )
		{
			script_models[i] delete();
			continue;
		}
		
		if( script_models[i].model == "prop_mortar" )
		{
			script_models[i] delete();
			continue;
		}
	}
	
	script_brushmodels = GetEntArray( "script_brushmodel", "classname" );
	
	for( i = 0; i < script_brushmodels.size; i++ )
	{
		if( !IsDefined( script_brushmodels[i].script_noteworthy ) )
	    {
		   	continue;
		}

		if( script_brushmodels[i].script_noteworthy == "so_railing_remove" )
		{
			script_brushmodels[i] delete();
		}
	}
}

//===========================================
// 		  delete_by_key_value_pair
//===========================================
delete_by_key_value_pair( value, key, check_target )
{
	entity_array = GetEntArray( value, key );
	
	for( i = 0; i < entity_array.size; i++)
	{
		object = entity_array[i];
			
		if( IsDefined( object ) )
		{
			if( IsDefined( check_target ) && check_target )
			{
				if( IsDefined( object.target ) )
				{
					collision = GetEnt( object.target, "targetname" );
					
					if( IsDefined( collision ) )
					{
						collision hide_entity();
					}
				}
			}
			
			object notify( "delete" );
			object delete();
		}
	}
}

disconnect_specops_paths()
{
	specops_blockers = GetEntArray( "assassin_box_clip", "targetname" );
	foreach( blocker in specops_blockers )
	{
		blocker DisconnectPaths();
	}
}

setup_players()
{
	// _loadout.gsc takes care of actually assigning these
	level.sniper_primary = "dragunov";
	level.sniper_secondary = "mp5";

	level.heavy_primary = "mp5";
	level.heavy_secondary = "usp";
	
	// Note: we're spawning the "specialty" weapons in the map now,
	
}


setup_enemies()
{
	//sets up the chopper mesh
	maps\_chopperboss::chopper_boss_locs_populate( "script_noteworthy", "struct_chopper_boss_loc" );
	
	setup_vips();

	// Guards and VIPs all start in their "sleep" state.  VIPs will wander, but guards will stay put.  If any of them take
	// pain or death, their group will wake
	
	// vip1's guards
	guard1_spawner_array = GetEntArray( "vip1_guard", "script_noteworthy" );
	roof_array = GetEntArray( "roof_guard", "script_noteworthy" );
	guard1_spawner_array = array_combine( guard1_spawner_array, roof_array );
	for( i = 0; i < guard1_spawner_array.size; i++ )
	{
		guard1 = guard1_spawner_array[i] spawn_ai( true, false );
		guard1.maxsightdistsqrd = level.initialGuardSightRangeSqrd;
		guard1.pacifist = true;
		guard1.goalradius = 32;

		
		guard1 set_generic_run_anim( "casual_killer_walk_f" );
		guard1 set_generic_idle_anim( "casual_stand_idle" );
		guard1 AllowedStances( "stand" );
		guard1.disablearrivals = true;
		guard1.disableexits = true;	
		guard1.alertlevel = "noncombat";
	
		if( isdefined( guard1.target ) )
		{

			guard1 thread guard_path();
		}
		else
		{
			guard1 setgoalpos( guard1.origin );
		}
		
		level.enemy_array_group_1 = add_to_array( level.enemy_array_group_1, guard1 );
		
		// special case the roof guys to use a special alert that immediately awakens the other roof guy
		if( guard1.script_noteworthy == "roof_guard" )
        {
			level.roof_guards = add_to_array( level.roof_guards, guard1 );
			guard1 thread roof_alert_monitor();
		}
		else
		{
			guard1 thread alert_group_monitor( 1 );
		}
	}
	
	// vip2's guards
	guard2_spawner_array = GetEntArray( "vip2_guard", "script_noteworthy" );
	for( i = 0; i < guard2_spawner_array.size; i++ )
	{
		guard2 = guard2_spawner_array[i] spawn_ai( true, false );
		guard2.maxsightdistsqrd = level.initialGuardSightRangeSqrd;
		guard2.pacifist = true;
		guard2.goalradius = 32;
		
		guard2 set_generic_run_anim( "casual_killer_walk_f" );
		guard2 set_generic_idle_anim( "casual_stand_idle" );
		guard2 AllowedStances( "stand" );
		guard2.disablearrivals = true;
		guard2.disableexits = true;
		guard2.alertlevel = "noncombat";
		
		if( isdefined( guard2.target ) )
		{

			guard2 thread guard_path();
		}
		else
		{
			guard2 setgoalpos( guard2.origin );
		}		
		
		level.enemy_array_group_2 = add_to_array( level.enemy_array_group_2, guard2 );
		guard2 thread alert_group_monitor( 2 );		
	}
	
	// vip3's guards
	guard3_spawner_array = GetEntArray( "vip3_guard", "script_noteworthy" );
	for( i = 0; i < guard3_spawner_array.size; i++ )
	{
		guard3 = guard3_spawner_array[i] spawn_ai( true, false );
		guard3.maxsightdistsqrd = level.initialGuardSightRangeSqrd;
		guard3.pacifist = true;
		guard3.goalradius = 32;
		guard3 setgoalpos( guard3.origin );		
		
		guard3 set_generic_run_anim( "casual_killer_walk_f" );
		guard3 AllowedStances( "stand" );
		guard3.disablearrivals = true;
		guard3.disableexits = true;	

		level.enemy_array_group_3 = add_to_array( level.enemy_array_group_3, guard3 );
		guard3 thread alert_group_monitor( 3 );
	}	
}

setup_vips()
{
	vip_1_spawner = GetEnt( "vip_1_spawner", "targetname" );
	vip_1 = vip_1_spawner spawn_ai( true, false );
	vip_init( vip_1, 1 );
	vip_1.targetname = "vip_1";
	
	level.enemy_array_group_1[0] = vip_1;

	vip_2_spawner = GetEnt( "vip_2_spawner", "targetname" );
	vip_2 = vip_2_spawner spawn_ai( true, false );
	vip_init( vip_2, 2 );
	vip_2.targetname = "vip_2";
	level.enemy_array_group_2[0] = vip_2;
/*	
	vip_3_spawner = GetEnt( "vip_3_spawner", "targetname" );
	vip_3 = vip_3_spawner spawn_ai( true, false );
	vip_init( vip_3, 3 );
	vip_3.targetname = "vip_3";
	level.enemy_array_group_3[0] = vip_3;
*/	
	level.vip_array = GetEntArray( "vips", "script_noteworthy" );
	
	vip_1 thread vip1Path();
	vip_2 thread vip2Path();

	vip_1 StartUsingHeroOnlyLighting();
	vip_2 StartUsingHeroOnlyLighting();
}

vip_init( vip, groupNum )
{
	initialVIPSightRange = 128;
	initialSightRangeSqrd = initialVIPSightRange * initialVIPSightRange;

	vip.maxsightdistsqrd = initialSightRangeSqrd;
	vip.pacifist = true;
	vip.goalradius = 32;
	
	vip set_generic_run_anim( "casual_killer_walk_f" );
	vip AllowedStances( "stand" );
	vip.disablearrivals = true;
	vip.disableexits = true;	

	vip thread vip_death_monitor( groupNum );
	vip thread alert_group_monitor( groupNum );
	vip.script_noteworthy = "vips";

}

spawn_hostages()
{	
	// create a threatbias group for the hostages so the "axis" can ignore them
	CreateThreatBiasGroup( "hostages" );
	
	array_spawn_function_targetname( "hostage_spawner", ::hostage_setup );
	array_spawn_targetname( "hostage_spawner", 1 );
	
	ignoreEachOther( "hostages", "axis" );
	
	hostage_pos = GetStruct( "hostage_loc", "targetname" );
	level.hostage_position = hostage_pos;
}

hostage_setup()
{
	self.setfixednode = true;
	self.grenadeawareness = 0;
	self.team = "allies";
	self.ignoreme = true;
	self thread magic_bullet_shield();	// initially invincible
	self.ignorerandombulletdamage = true;
	self SetThreatBiasGroup( "hostages" );
	
	self thread hostage_death_count();	
}

hostage_death_count()
{
	flag_wait("hostages_vulnerable");
	
	self stop_magic_bullet_shield();
	self waittill( "death" );
	
	// if we're here because the level was successful, just leave
	if( flag( "so_assassin_payback_complete" ) )
	{
		return;
	}
	
	level.hostages_killed++;

	// we now fail if even one hostage dies, regardless of difficulty
	/*
	fail = false;
	
	if( level.gameskill <= 1)
	{
		if( level.hostages_killed >= 3 )
		{
			fail = true;
		}
	}
	else if( level.gameskill == 2 )
	{
		if( level.hostages_killed >= 2 )
		{
			fail = true;
		}
	}
	else
	{
		fail = true;		
	}
	
	if( fail )
	{ */
		level.challenge_end_time = gettime();
		maps\_specialops::so_force_deadquote( "@SO_ASSASSIN_PAYBACK_HOSTAGE_DEATH" );
		level maps\_utility::missionFailedWrapper();
//	}
	
}

alert_group_monitor( groupNum )
{
	level endon( "special_op_terminated" );
	self waittill_any( "bulletwhizby", "flashbang", "grenade danger", "explode", "pain", "death" );
	self wake();
	wait( RandomFloatRange( 0.5, 1.0 ) );
	alert_group( groupNum, false );
}

// special alert for the two roof guys
roof_alert_monitor()
{	
	level endon( "special_op_terminated" );
	level endon( "roof_alerted" );
	self waittill_any( "bulletwhizby", "flashbang", "grenade danger", "explode", "pain", "death" );
	self wake();
	wait( RandomFloatRange( 0.5, 1.0 ) );
	// wake the roof guys immediately
	foreach( guard in level.roof_guards )
	{
		guard wake();
	}
	alert_group( 1, false );
	level notify( "roof_alerted" );
}

// wake all members of this group if self takes pain or death
alert_group( groupNum, instant )
{
	if( group_is_awake( groupNum ) )
	{
		return;
	}
	
//	IPrintLnBold( "WAKING GROUP " + groupNum );
	
	awake_array = [];
	switch( groupNum )
	{
	case 1:
		awake_array = remove_dead_from_array( level.enemy_array_group_1 );
		level.awake_groups[0] = true;		
		foreach( enemy in awake_array )
		{
			if( isdefined( enemy ) && isalive( enemy ) )
			{
				enemy wake();
				// don't put vips in color groups.  They have special behavior.
				if( isdefined( enemy.script_noteworthy ) && enemy.script_noteworthy == "vips" )
				{
					hide_spot = getstruct( "vip1_hide_spot", "targetname" );
					enemy SetGoalPos( hide_spot.origin );
					enemy.goalradius = 64;
				}
				else
				{
					enemy set_force_color( "b" );
				}
			}
			enemy notify( "group_wake" );
			if( !instant )
			{
				wait( RandomFloatRange( 0.2, 0.5 ) );
			}
		}
		break;
	case 2:
		awake_array = remove_dead_from_array( level.enemy_array_group_2 );
		level.awake_groups[1] = true;
		foreach( enemy in awake_array )
		{
			if( isdefined( enemy ) && isalive( enemy ) )
			{
				enemy wake();
				// don't put vips in color groups.  They have special behavior.
				if( isdefined( enemy.script_noteworthy ) && enemy.script_noteworthy == "vips" )
				{
					hide_spot = getstruct( "vip2_hide_spot", "targetname" );
					enemy SetGoalPos( hide_spot.origin );
					enemy.goalradius = 24;
					enemy.pathenemyfightdist = 8;
					enemy.pathenemylookahead = 8;
//					enemy set_forcegoal(); // ARGH, this guy seems to think he can wander up on to the roof!
				}
				else	
				{
					enemy set_force_color( "r" );
				}
			}
			enemy notify( "group_wake" );
			if( !instant )
			{
				wait( RandomFloatRange( 0.2, 0.5 ) );
			}
		}
		break;
	case 3:
		awake_array = remove_dead_from_array( level.enemy_array_group_3 );
		level.awake_groups[2] = true;
		foreach( enemy in awake_array )
		{
			if( isdefined( enemy ) && isalive( enemy ) )
			{	
				enemy wake();
				// don't put vips in color groups.  They have special behavior.
				if( isdefined( enemy.script_noteworthy ) && enemy.script_noteworthy == "vips" )
				{
					hide_spot = getstruct( "vip_escape_wait_3", "targetname" );
					enemy SetGoalPos( hide_spot.origin );
					enemy.goalradius = 64;
				}	
				else	
				{	
					enemy set_force_color( "c" );
				}
			}
			enemy notify( "group_wake" );
			if( !instant )
			{
				wait( RandomFloatRange( 0.2, 0.5 ) );
			}
		}		
		break;
	case 4: // patrollers
		awake_array = remove_dead_from_array( level.patroller_array );
		level.awake_groups[3] = true;
		foreach( enemy in awake_array )
		{
			if( isdefined( enemy ) && isalive( enemy ) )
			{
				enemy wake();
			}
			enemy notify( "group_wake" );
			if( !instant )
			{
				wait( RandomFloatRange( 0.2, 0.5 ) );
			}
		}
		break;
		
	}

	advance_to_stage( 1 );
}

group_is_awake( groupNum )
{
	return level.awake_groups[groupNum-1];
}

// reset self's values for normal combat
wake()
{
	if( IsDefined( self ) && IsAlive( self ) )
	{
		self.maxsightdistsqrd = 25000000;
		self.goalradius = 256;
		self.pacifist = false;
		self clear_run_anim();
		self clear_generic_idle_anim();
		self AllowedStances( "stand", "prone", "crouch" );
		self.disablearrivals = false;
		self.disableexits = false;
		self.ignoreall = false;
		self.script_forcegoal = false;
	}
}

retreat_VIPs()	
{
	for ( i = 0; i < level.vip_array.size; i++ )
	{
		if( isAlive( level.vip_array[i] ) )
		{
			level.vip_array[i] unset_forcegoal();
			goalstruct = GetStruct( "vip_escape_wait_" + (i+1), "targetname" );
			level.vip_array[i] SetGoalPos( goalstruct.origin );
		}
	}	
}

// handles the objectives and their icons
vip_death_monitor( groupNum )
{
	level endon( "special_op_terminated" );
	self waittill("death");

	stillAlive = 0;
	completedMsg = false;	
	
	level.vip_array = array_removeDead( level.vip_array );

	for ( i = 0; i < level.vip_array.size; i++ )
	{
		if( isAlive( level.vip_array[i] ) )
		{
			stillAlive++;
		}
	}
	if( stillAlive > 0 )
	{
//		radio_dialogue_queue_single( "so_assassin_confirm_kill" );
		radio_dialogue_queue_single( "so_assassin_kill_confirmed" );		
		radio_dialogue_queue_single( "so_assassin_one_more" );		
	}
	else
	{
		advance_to_stage( 4 );
		if( !completedMsg ) // in case we kill all 3 simultaneously, such as when they are in a vehicle
		{
			completedMsg = true;
			flag_set( "obj_vips_dead" );
		}
	}
}


gameplay_logic()
{
	level thread run_music();
	
	level.custom_eog_no_defaults = 1;
	level.eog_summary_callback = ::customEOGSummary;
	
	thread objectives();
	
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i] thread no_prone_water_trigger();
	}
	
	flag_set( "so_assassin_payback_start" );
	
	level thread stage_monitor();	
	
	thread patrol_handler();
	thread attack_heli_handler();
}

/*************************************************************************************************
	customEOGSummary
	self = level
**************************************************************************************************/
CONST_POINTS_GAMESKILL	  	= 10000;
CONST_POINTS_PER_KILL		= 25;
customEOGSummary()
{
	// 10000 score breakdown:
	// max kills (53) = 2500 points
	// time under 2 minutes = 5000 points, 10 minutes or longer = 0 points
	// heli time = 2500
	
//	self add_custom_eog_summary_line( "", "@SPECIAL_OPS_PERFORMANCE_YOU", "@SPECIAL_OPS_PERFORMANCE_PARTNER", 1 );
	
	session_time = int( min( ( level.challenge_end_time - level.challenge_start_time ), 86400000 ) );
	total_kills = 0;

	// grab initial stats
	//-------------------
	foreach ( player in level.players )
	{
		total_kills += player.so_eog_summary_data[ "kills" ];
	}
	
	// determine score
	// ---------------
	// base score 10000 per difficulty
	gameskill_score = int( level.specops_reward_gameskill * 10000 );
	level.session_score = gameskill_score;
	
	// give 25 points per kill
	kill_score = int( total_kills * CONST_POINTS_PER_KILL );
 	level.session_score	+= kill_score;
	
	// give up to 5000 - max_kill_score for killing the helicopters quickly
	max_seen_time = 120 * 1000; // 2 minutes
	seen_ratio = (1.0 - min(1.0,(level.total_heli_time_seen/max_seen_time)));
	max_time_score = 5000 - (CONST_POINTS_PER_KILL * level.assassin_num_enemies);
	heli_time_score = int( seen_ratio * max_time_score);
	level.session_score += heli_time_score;
	
	// give up to 5000 points for completing the mission in "best time" or faster, 0 for "max time" or longer
	session_time_score = 0;
	if( session_time <= level.best_score_time )
	{
		session_time_score = 5000;
	}
	else if( session_time <= level.max_score_time )
	{
		session_time_score = int( 5000 * ( 1 - ( ( session_time - level.best_score_time ) / ( level.max_score_time - level.best_score_time ) ) ) );
	}
	
	level.session_score += session_time_score ;
	
	foreach ( player in level.players )
		player override_summary_score( level.session_score );	
		
	diffString[ 0 ] = "@MENU_RECRUIT";
	diffString[ 1 ] = "@MENU_REGULAR";
	diffString[ 2 ] = "@MENU_HARDENED";
	diffString[ 3 ] = "@MENU_VETERAN";
	
	score_label = undefined;
	col1_lable = undefined;
	col2_lable = undefined;
	col3_lable = undefined;
	
	if ( is_coop() )
	{
		score_label = "@SPECIAL_OPS_UI_TEAM_SCORE";
		col1_lable = "@SPECIAL_OPS_PERFORMANCE_YOU";
		col2_lable = "@SPECIAL_OPS_PERFORMANCE_PARTNER";
		col3_lable = "@SPECIAL_OPS_POINTS";
	}
	else
	{
		score_label = "@SPECIAL_OPS_UI_SCORE";
		col1_lable = "";//"@SPECIAL_OPS_COUNT";
		col2_lable = "@SPECIAL_OPS_POINTS";
	}
	
	clear_custom_eog_summary();
		
	foreach ( player in level.players )
	{
		kills 				= player.so_eog_summary_data[ "kills" ];
		seconds 			= player.so_eog_summary_data[ "time" ] * 0.001;
		time_string 		= convert_to_time_string( seconds, true );
		heli_time_string	= convert_to_time_string( level.total_heli_time_seen / 1000, true ); 
		diff 				= diffString[ player.so_eog_summary_data[ "difficulty" ] ];
		final_score 		= player.so_eog_summary_data[ "score" ];

		if ( is_coop() )
		{
			p2_kills = get_other_player( player ).so_eog_summary_data[ "kills" ];
			p2_diff = diffString[ get_other_player( player ).so_eog_summary_data[ "difficulty" ] ];
			
			if ( !level.missionfailed )
			{
				player add_custom_eog_summary_line( "",										col1_lable,			col2_lable, 		col3_lable,			1 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", 			diff, 				p2_diff, 			gameskill_score,	2 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 				time_string, 		time_string,		session_time_score,	3 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", 				kills, 				p2_kills, 			kill_score,			4 );
				player add_custom_eog_summary_line( "@SO_ASSASSIN_PAYBACK_HELI_KILL", 		heli_time_string, 	heli_time_string, 	heli_time_score,	5 );
				player add_custom_eog_summary_line( "",										"",					undefined, 			undefined,			6 );
				player add_custom_eog_summary_line( score_label, 							final_score, 		undefined, 			undefined, 			7 );
			}
			else
			{
				player add_custom_eog_summary_line( "",										col1_lable,			col2_lable, 		undefined,			1 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", 			diff, 				p2_diff, 			undefined,			2 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 				time_string, 		time_string,		undefined,			3 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", 				kills, 				p2_kills, 			undefined,			4 );
			}
		}
		else
		{
			if ( !level.missionfailed )
			{
				player add_custom_eog_summary_line( "",										col1_lable,			col2_lable, 		col3_lable,		1 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", 			diff, 				gameskill_score, 	undefined,		2 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 				time_string, 		session_time_score,	undefined,		3 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", 				kills, 				kill_score, 		undefined,		4 );
				player add_custom_eog_summary_line( "@SO_ASSASSIN_PAYBACK_HELI_KILL", 		heli_time_string, 	heli_time_score, 	undefined,		5 );
				player add_custom_eog_summary_line( "",										"",					undefined, 			undefined,		6 );
				player add_custom_eog_summary_line( score_label, 							final_score, 		undefined, 			undefined, 		7 );
			}
			else
			{
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", 			diff, 				undefined, 			undefined,			1 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 				time_string, 		undefined,			undefined,			2 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", 				kills, 				undefined, 			undefined,			3 );
			}
		}
	}
	
	if ( !level.missionfailed )
	{
		setdvar( "ui_hide_hint", 1 );
	}
	else
	{
		setdvar( "ui_hide_hint", 0 );
	}
}

//===========================================
// 			no_prone_water_trigger
//===========================================
no_prone_water_trigger()
{
	level endon( "special_op_terminated" );
	level endon( "so_assassin_payback_complete" );
	
	while( true )
	{
		flag_wait( "no_prone_water_trigger" );
		
		if (self GetStance() == "prone" )
		{
			self SetStance( "stand" );
		}
		
		self AllowProne( false );
		
		flag_waitopen( "no_prone_water_trigger" );
		self AllowProne( true );
	}
}

advance_to_stage( newStage )
{
	if( newStage > level.stage )
	{
		level.stage = newStage;
	}
}

stage_monitor()
{
	level endon( "special_op_terminated" );
		
	thread triggered_alert();
	thread triggered_alert_1();
	thread triggered_alert_3();
	
//	IPrintLnBold( "SLEEP" );	
	foreach( player in level.players )
	{
		player thread gunshot_monitor();
	}
	
	thread opening_dialogue();
	
	// sleep is a looping state
	while( level.stage < 1 ) // sleep
	{

		wait( 1.0 );
	}
	
	// waking 
	
	// waking is a progressive state 
	// Sequences:
	// 1, 2, 3
	// 2, 1, 3
	// 3, 2, 1
//	IPrintLnBold( "WAKING" );
	flag_set( "out_of_stage_1" );	
	thread radio_dialogue_queue_single ( "so_assassin_enemy_heading_your_way" );

	// spawn the hostages' guards
	hostage_guard_spawner_array = GetEntArray( "hostage_guard", "script_noteworthy" );
	hostage_loc = GetStruct( "hostage_loc", "targetname" );
	foreach( guard_spawner in hostage_guard_spawner_array )
	{
		guard = guard_spawner spawn_ai( true, false );
		guard.goalradius = 512;
		guard setgoalpos( hostage_loc.origin );
			
		level.hostage_guards = add_to_array( level.hostage_guards, guard );
	}
	
	if( group_is_awake( 1 ) )
	{
		alert_group( 4, false );
		wait( 3.0 );
		alert_group( 2, false );
		wait( 5.0 );
		alert_group( 3, false );
	}
	else if( group_is_awake( 2 ) )
	{
		wait( 3.0 );
		alert_group( 1, false );
		alert_group( 4, false );
		wait( 5.0 );
		alert_group( 3, false );
	}
	else if( group_is_awake( 3 ) )
	{
		wait( 5.0 );
		alert_group( 2, false );
		alert_group( 4, false );
		wait( 3.0 );
		alert_group( 1, false );
	}
	else if( group_is_awake( 4 ) )
	{
		wait( 1.0 );
		alert_group( 2, false );
		alert_group( 1, false );
		wait( 8.0 );
		alert_group( 3, false );
	}
	else
	{
//		IPrintLnBold( "ALERTING ALL GROUPS AT ONCE" );
		alert_group( 1, false );
		alert_group( 2, false );		
		alert_group( 3, false );
		wait( 1.0 );		
	}
	
	advance_to_stage( 2 );
//	IPrintLnBold( "ALERT" );
	// alert

	if( level.stage < 6 )
	{
		thread radio_dialogue_queue_single ( "so_assassin_team_large_enemy_force" );
	}
		
	level.vip_array = array_removeDead( level.vip_array );
	while( level.vip_array.size > 0 )
	{
	
		wait( 1.0 );
		level.vip_array = array_removeDead( level.vip_array );
	}	
	advance_to_stage( 3 );
//	thread radio_dialogue_queue_single ( "so_assassin_confirm_good_kills" );
	thread radio_dialogue_queue_single ( "so_assassin_nice_work" );

	
	
	// also everybody hates the players now, tee hee
	badguys = GetAiArray( "axis" );
	
	for( i = 0; i < badguys.size; i++ )
	{
		if( !IsDefined( badguys[i].script_noteworthy ) || badguys[i].script_noteworthy != "hostage_guard" )
		{
			badguys[i] thread player_seek_enable();
		}
	}	

//	IPrintLnBold( "RESCUE" );
	while( level.stage < 4 ) // rescue
	{
		wait( 1.0 );
	}	
	// advances once players reach hostage

	flag_wait( "hostage_x_pressed" );
	advance_to_stage( 5 );

//	IPrintLnBold( "SIGNAL" );
	// wait for one of the players to throw smoke
	foreach( player in level.players )
	{
		player setOffhandSecondaryClass( "smoke" );
		player giveWeapon("smoke_grenade_american");
		player thread grenade_monitor();
		player thread display_hint_timeout( "throw_smoke", undefined );
	}

	
	advance_to_stage( 6 );
	
	//	IPrintLnBold( "DEFEND" );
		
	flag_wait( "smoke_thrown" );

	thread radio_dialogue_queue_single ( "so_assassin_chopping_a_task_force" );
	thread enable_countdown_timer( level.defendtime, false, &"SO_ASSASSIN_PAYBACK_EXFIL_HUD" );
	
	// start the last enemy waves when the smoke is thrown
	thread handle_last_enemy_waves();	
	
	wait( level.defendtime - level.flighttime - level.cobra_lead_time );
	
	// spawn and send in the friendlies
	cobra_spawner = GetEnt( "cobra", "targetname" );
	cobra = cobra_spawner spawn_vehicle_and_gopath();
	cobra thread cobra_think();
	
	wait( level.cobra_lead_time );
	
	blackhawk_spawner = GetEnt( "blackhawk", "targetname" );
	blackhawk = blackhawk_spawner spawn_vehicle_and_gopath();
	
	blackhawk_pilot_spawner = GetEnt( "blackhawk_pilot", "targetname" );
	blackhawk_pilot = blackhawk_pilot_spawner spawn_ai( true, false );
	blackhawk_pilot thread set_battlechatter( false );
	blackhawk thread maps\_vehicle_aianim::guy_enter( blackhawk_pilot );
	
	blackhawk_copilot_spawner = GetEnt( "blackhawk_copilot", "targetname" );
	blackhawk_copilot = blackhawk_copilot_spawner spawn_ai( true, false );
	blackhawk_copilot thread set_battlechatter( false );
	blackhawk thread maps\_vehicle_aianim::guy_enter( blackhawk_copilot );
	
	wait( level.stickaroundtime );
	
	flee_struct = getstruct( "last_wave_flee", "targetname" );
	badguys = GetAiArray( "axis" );
	for( i = 0; i < badguys.size; i++ )
	{
		badguys[i] player_seek_disable();
		badguys[i] setgoalpos( flee_struct.origin );
		badguys[i].ignoreme = true;
	}		
	
	wait( level.flighttime - level.stickaroundtime );
	flag_set("rescue_arrives");
	waitframe(); //Allow Objective to complete
	flag_set( "so_assassin_payback_complete" );
}

// this is the trigger placed up against the balcony.  If the players jump down, the guys on the central building roof see them
triggered_alert()
{
	level endon( "special_op_terminated" );
	flag_wait( "triggered_alert" );
	alert_group( 4, false );
}

// this trigger is after the initial compound gate.  if a player hits it, it instantly awakens group 1 (building on right)
triggered_alert_1()
{
	level endon( "special_op_terminated" );
	flag_wait( "triggered_alert_1" );
	alert_group( 1, true );
}


// this trigger is about mid-way down the road.  if a player hits it, it instantly awakens group 3
triggered_alert_3()
{
	level endon( "special_op_terminated" );
	flag_wait( "triggered_alert_3" );
	flag_set( "hostages_vulnerable" );	
	alert_group( 3, true );
}


// if the player fires a gun, the guys on the roof will hear it
gunshot_monitor()
{
	self endon( "death" );
	level endon( "out_of_stage_1" );
	level endon( "special_op_terminated" );
	
	while ( level.stage < 1 )
	{
		self waittill ( "weapon_fired" );
		alert_group( 1, false );
	}
}

opening_dialogue()
{
	wait( 2.5 );
	
	// mission specific dialogue
//	radio_dialogue_queue_single( "so_assassin_metal_zero_one" );	
	radio_dialogue_queue_single( "so_assassin_approved_to_engage" );
}


handle_last_enemy_waves()
{
	level endon( "special_op_terminated" );
	
	//  spawn in the end rush of guys
	
	// open the gates
	right_gate = GetEnt( "intro_gate_right_so", "targetname" );
	left_gate = GetEnt( "intro_gate_left_so", "targetname" );
	gate_clip = GetEnt( "gate_clip", "targetname" );
	gate_clip delete();
	

	gate_origin = GetStruct( "end_gate_origin", "targetname" );
	right_gate_dest = GetStruct( "right_gate_dest", "targetname" );
	right_gate  moveto( right_gate_dest.origin, 3.0, 0.5, 0.5 );
	left_gate_dest = GetStruct( "left_gate_dest", "targetname" );
	left_gate  moveto( left_gate_dest.origin, 3.0, 0.5, 0.5 );	
	
	last_wave_spawners = GetEntArray( "last_wave", "script_noteworthy" );
	
	// first send any remaining guys to the player
	badguys = GetAiArray( "axis" );
	foreach ( guy in badguys )
	{
		if( isalive( guy ) )
		{
			guy thread player_seek_enable();
		}
	}
	
	wave_spawn_time = GetTime();
	
	// spawn a first wave of enemies
	for( i = 0; i < last_wave_spawners.size; i++ )
	{
		guy = last_wave_spawners[i] spawn_ai( true, false );
		guy thread player_seek_enable();
		level.last_wave_guys = add_to_array( level.last_wave_guys, guy );
	}
	level.waves_spawned++;
	
	while( level.waves_spawned < level.max_end_waves )
	{
		spawn_next_wave = false;
		num_guys_spawned = level.last_wave_guys.size;
		
		percent_left_to_spawn_next_wave = 0.30;
		time_before_spawning_next_wave = wave_spawn_time + ( 45 * 1000 );
		
		while ( !spawn_next_wave )
		{
			wait 1;
			badguys = GetAiArray( "axis" );
			percent_left = badguys.size / num_guys_spawned;
			cur_time = GetTime();
			
			if ( percent_left < percent_left_to_spawn_next_wave || cur_time > time_before_spawning_next_wave )
			{
				spawn_next_wave = true;
			}
		}
		
		// spawn a another wave of enemies
		for( i = 0; i < last_wave_spawners.size; i++ )
		{
			guy = last_wave_spawners[i] spawn_ai( true, false );
			guy thread player_seek_enable();
			level.last_wave_guys = add_to_array( level.last_wave_guys, guy );
		}
		level.waves_spawned++;
	}
}

// for use during the very brief segment when the players find the hostage
grenade_monitor()
{
	self endon( "death" );
	level endon( "smoke_thrown" );
	level endon( "special_op_terminated" );
	
	while ( true )
	{
		self waittill ( "grenade_fire", grenade, weapname );
		if( weapname == "smoke_grenade_american" )
		{
			// green smoke here
			grenade thread signal_grenade_think();
			foreach( player in level.players )
			{
				player setOffhandSecondaryClass( "flash" );
//				player TakeWeapon("smoke_grenade_american");
			}
			flag_set( "smoke_thrown" );
		}
	}
}

signal_grenade_think()
{
	// this is such a horrible hack.  detonation on smoke grenades is 4 seconds
	wait( 3.8 );
	thread playfx_then_stop( "extraction_smoke", self, "stop_green_smoke_fx" );
	wait( 0.1 );
	self delete();
}

playfx_then_stop(effect, org, flg, rot)
{
	tag1 = spawn_tag_to_loc(org);
	tag1 rotateto((180,180,0), 0.1);
		
	playFXontag( getfx( effect ), tag1, ( "tag_origin" ) );
	
	flag_wait(flg);
	stopFXontag( getfx( effect ), tag1, ( "tag_origin" ) );
}

spawn_tag_to_loc(move_to)
{
	tag1 = spawn_tag_origin();
	tag1 angles_and_origin(move_to);
	return tag1;
}
	
angles_and_origin(move_to)
{
	self.origin = move_to.origin;
	
	if (isdefined(move_to.angles))
		self.angles = move_to.angles;
}

patrol_handler()
{	
	level endon( "special_op_terminated" );
	
	// spawn the patrol, but don't have them start patrolling yet
	patrol_spawner_array = GetEntArray( "patrol_guy", "script_noteworthy" );
	for( i = 0; i < patrol_spawner_array.size; i++ )
	{
		patroller = patrol_spawner_array[i] spawn_ai( true, false );
		patroller.maxsightdistsqrd = level.initialGuardSightRangeSqrd;
		patroller.pacifist = true;
		patroller.goalradius = 32;
		
		patroller set_generic_run_anim( "casual_killer_walk_f" );
		patroller AllowedStances( "stand" );
		patroller.disablearrivals = true;
		patroller.disableexits = true;	
	
		level.patroller_array = add_to_array( level.patroller_array, patroller );
		patroller thread alert_group_monitor( 4 ); // patrollers are their own group
	}
	
	wait( level.patrol_starttime );

	// if the level isn't at least in "waking" stage yet, start the patrol
	if( level.stage > 0 )
	{
		return;
	}
		
	// start them moving
	thread radio_dialogue_queue_single ( "so_assassin_enemy_contacts" );

	patrol_goal_struct1 = GetStruct( "patrol_goal_struct1", "targetname" );
	patrol_goal_struct2 = GetStruct( "patrol_goal_struct2", "targetname" );
	patrol_goal_struct3 = GetStruct( "patrol_goal_struct3", "targetname" );

	level.patroller_array[0] SetGoalPos( patrol_goal_struct1.origin );
	level.patroller_array[1] SetGoalPos( patrol_goal_struct2.origin );
	level.patroller_array[2] SetGoalPos( patrol_goal_struct3.origin );
	
	level.patroller_array[0] waittill( "goal" );
//	iprintlnBold( "Patrol reached end of path" );
	if( IsDefined( level.patroller_array[0] ) && IsAlive( level.patroller_array[0] ) && (level.awake_groups[3] == false))
	{
		alert_group( 4, false );
	}
}




attack_heli_handler()
{	
	level endon( "special_op_terminated" );
	
	foreach( player in level.players )
	{
		player thread stinger_target_loop();
	}
	
	while( level.stage < 2 ) // helicopter is summoned when the level is on ALERT
	{
		wait( 1.0 );
	}
	
	setup_attack_heli( "attack_littlebird_spawner", "attack_heli_start", "attack_heli_pilot" );
	
	// on harder difficulty than regular and all co-op difficulties, there are two attack helicopters
	if( (  level.gameSkill > 1 ) || ( is_coop() ) )
	{
		wait( 3.0 );
		level thread safe_chopper_spawn( "attack_littlebird_spawner", "attack_heli_2_start", "attack_heli_start", "attack_heli_pilot_2" );
	}
		
	while( level.stage < 6 ) // helicopter is summoned when the player has popped smoke
	{
		wait( 1.0 );
	}
	
	wait 5;
	
	setup_attack_heli( "attack_littlebird_spawner_2", "attack_heli_start_dock_1", "attack_heli_pilot_3" );
}

setup_attack_heli( heli_spawner_name, heli_path_start_name, pilot_name )
{
	heli_spawner = GetEnt( heli_spawner_name, "targetname" );
	attack_heli = heli_spawner spawn_vehicle_and_gopath();
	path_start = GetStruct( heli_path_start_name, "targetname" );
	
	// we want our littlebirds to have 2x health, since they are based on Survival, which is based on MP where damage is half SP
	attack_heli.health =  ( 2 * attack_heli.health ) - attack_heli.healthbuffer;
	
	// needs a driver and a copilot (pos 0 and 1)
	pilot_spawner = GetEnt( pilot_name, "targetname" );	
	pilot = pilot_spawner spawn_ai( true, false );
	attack_heli thread maps\_vehicle_aianim::guy_enter( pilot );

	attack_heli thread maps\_chopperboss::chopper_boss_behavior_little_bird( path_start );
	attack_heli thread maps\_chopperboss::chopper_path_release( "death deathspin" );
	
	level.stinger_targets = array_add( level.stinger_targets, attack_heli );
	
	flag_set( "attack_heli_spawned" );
	
	level notify( "start_heli_timer" );
	level.num_attack_helis++;
	attack_heli thread heli_death();
	
	wait( 3.0 );
	thread radio_dialogue_queue_single ( "so_assassin_enemy_littlebird" );	
}

safe_chopper_spawn( heli_spawner_name, heli_path_start_name, heli_path_secondary_start_name, pilot_name )
{
	path_start = GetStruct( heli_path_start_name, "targetname" );
	secondary_path_start = GetStruct( heli_path_secondary_start_name, "targetname" );

	spawnFound = false;
	
	while( !spawnFound )
	{
		if( IsDefined(path_start.in_use)  && path_start.in_use )
		{
			// check the secondary start point
			if( IsDefined(secondary_path_start.in_use) && secondary_path_start.in_use )
			{
				// uh-oh.  delay the spawn
				wait( 0.5 ); // try again in half a second
			}
			else
			{
				spawnFound = true;
				setup_attack_heli( heli_spawner_name, heli_path_secondary_start_name, pilot_name );
			}
		}
		else
		{
			spawnFound = true;
			setup_attack_heli( heli_spawner_name, heli_path_start_name, pilot_name );
		}
	}
}

heli_death()
{
	level endon( "special_op_terminated" );
	
	self waittill( "death" );
	level.num_attack_helis--;
}

heli_timer()
{
	level endon( "special_op_terminated" );
	
	last_time_seen = 0;
	level.total_heli_time_seen = 0;
	
	foreach ( player in level.players )
	{
		player thread heli_timer_HUD();
	}
	
	while ( true )
	{
		if ( level.num_attack_helis > 0 )
		{
			level.total_heli_time_seen += GetTime() - last_time_seen;
			last_time_seen = GetTime();
			waitframe();
		}
		else
		{
			level waittill( "start_heli_timer" );
			last_time_seen = GetTime();
		}
	}
}

heli_timer_HUD()
{
	level endon( "special_op_terminated" );
	
	ypos = maps\_specialops::so_hud_ypos();
	self.hud_so_seen_msg = maps\_specialops::so_create_hud_item( 3, ypos, &"SO_ASSASSIN_PAYBACK_HELI_HUD", self );
	self.hud_so_seen_count = maps\_specialops::so_create_hud_item( 3, ypos, undefined, self );
	self.hud_so_seen_count.alignX = "left";
	
	self thread maps\_specialops::info_hud_handle_fade( self.hud_so_seen_msg );
	self thread maps\_specialops::info_hud_handle_fade( self.hud_so_seen_count );
	
	self thread heli_timer_HUD_set_color();
	
	time_string = convert_to_time_string( level.total_heli_time_seen / 1000, true );
	self.hud_so_seen_count SetText( time_string );
		
	while( true )
	{
		if ( level.num_attack_helis > 0 )
		{
			time_string = convert_to_time_string( level.total_heli_time_seen / 1000, true );
			self.hud_so_seen_count SetText( time_string );
		}
		else
		{
			level waittill( "start_heli_timer" );
		}
		
		waitframe();
	}
}

heli_timer_HUD_set_color()
{
	level endon( "special_op_terminated" );
	
	while ( true )
	{
		if ( level.num_attack_helis > 0 )
		{
			self.hud_so_seen_count set_hud_yellow();
			self.hud_so_seen_msg set_hud_yellow();
		}
		else
		{
			self.hud_so_seen_count set_hud_white();
			self.hud_so_seen_msg set_hud_white();
			level waittill( "start_heli_timer" );
		}
		waitframe();
	}
}

stinger_target_loop()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	for ( ;; )
	{
		while ( !self maps\_stinger::PlayerStingerAds() )
		{
			wait 0.05;
		}
		
		// NOTE:  without the functionality in the is_coop if-tests, target adding and removing only
		// takes place on player 0's screen.  So if player 1 uses the stinger, player 0 would see the targets OR
		// regardless of who uses the stinger, the targets would only be cleared from player 0.		
		
		level.stinger_targets = remove_dead_from_array( level.stinger_targets );
		foreach( target in level.stinger_targets )
		{
			Target_Set( target );
			if( is_coop() )
			{
				// don't draw targets on the other player's screen
				if( self == level.players[0] )
				{
					Target_HideFromPlayer( target, level.players[1] );
				}
				else
				{
					Target_HideFromPlayer( target, level.players[0] );
				}
			}
		}
		
		while ( self maps\_stinger::PlayerStingerAds() )
		{
			wait 0.05;
		}
		
		level.stinger_targets = remove_dead_from_array( level.stinger_targets );
		foreach( target in level.stinger_targets )
		{
			if( Target_IsTarget( target ) )
			{
				if( is_coop() )
				{
					// don't draw targets on MY screen
					if( self == level.players[0] )
					{
						Target_HideFromPlayer( target, level.players[0] );
					}
					else
					{
						Target_HideFromPlayer( target, level.players[1] );
					}
				}
				Target_Remove( target );
			}
		}
	}
}

enable_hostage_trigger()
{
	level endon( "special_op_terminated" );
	
	hostage_trigger = GetEnt( "hostage_trigger", "targetname" );
	
	// when the player gets withing a certain distance, change from displaying the distance to the hostages to just "Hostages"
	level thread detect_approach_to_hostages();
		
	trigger_wait( "hostage_trigger", "targetname" );
	flag_set( "hostage_reached" );
	
	level.showing_hostage_hint_array[0] = false;
	level.showing_hostage_hint_array[1] = false;
	
	waiting_for_use = true;
	
	while( waiting_for_use )
	{
		for( i = 0; i < level.players.size; i++ )
		{
			if( level.players[i] IsTouching( hostage_trigger ) )
			{
				either_player_in_trigger = true;
				if( level.showing_hostage_hint_array[i] == false ) // player entered and left trigger without pressing x
				{
					level.showing_hostage_hint_array[i] = true;
					 level.players[i] thread display_hint_timeout( "contact_hostage", undefined );
				}
				if (  level.players[i] UseButtonPressed() ) 
				{
					waiting_for_use = false;
					break;
				}
			}
			else
			{
				level.showing_hostage_hint_array[i] = false;
			}
		}
		
		wait( 0.1 );
	}
	level.showing_hostage_hint_array[0] = false;
	level.showing_hostage_hint_array[1] = false;
	
	flag_set( "hostage_x_pressed" );
}

detect_approach_to_hostages()
{
	level endon( "special_op_terminated" );
	
	far_from_hostages = true;
	
	while( far_from_hostages )
	{
		foreach( player in level.players )
		{
			distance_to_hostages = Distance2D( level.hostage_position.origin, player.origin );
			if( distance_to_hostages < level.hostage_detect_distance )
			{
				flag_set( "near_hostages" );
				far_from_hostages = false;
				break;
			}
		}
		wait( 0.1 );
	}
}

cobra_think()
{
	wait( 3 );
	
	level.stinger_targets = remove_dead_from_array( level.stinger_targets );
	for( i = (level.stinger_targets.size - 1 ); i >= 0; i-- )
	{
		target = level.stinger_targets[i];
		if( IsAlive( target ) )
		{
			self thread maps\_helicopter_globals::fire_missile( "cobra_zippy", 4, target, 0.1 );
		}
		wait( 2.0 );
	}
}

so_objective_handler(name, obj_string, obj_loc, flag_end, crumb, end_crumb, text_override, not_complete)
{
	level endon( "special_op_terminated" );
	
	Objective_Add( obj( name ), "active", obj_string );
	Objective_Current( obj( name ) );
	
	if( isdefined( text_override ) )
	{
		Objective_SetPointerTextOverride( obj( name ), text_override );
	}
	
	if ( isdefined( crumb ) )
	{
		Objective_position( obj( name ), crumb.origin );
		flag_wait (end_crumb);
		Objective_position( obj( name ), (0,0,0) );
	}
	if ( isdefined( obj_loc ) )
	{
		Objective_position( obj( name ), obj_loc.origin );
	}
	
	flag_wait (flag_end);
	Objective_position( obj( name ), (0,0,0) );
	if( !isdefined( not_complete ) || ( not_complete == false ) )
	{
		objective_complete( obj( name ) );
	}
}

objectives()
{
	level endon( "special_op_terminated" );
	
	thread vip_objectives();
	
	flag_wait( "obj_vips_dead" );

	thread enable_hostage_trigger();
	wait( 0.1 );
//	so_objective_handler( obj( "hostage" ), &"SO_ASSASSIN_PAYBACK_OBJECTIVE_RESCUE", level.hostage_position, "near_hostages", undefined, undefined, undefined, true );
//	wait( 0.1 );
	so_objective_handler( obj( "hostage" ), &"SO_ASSASSIN_PAYBACK_OBJECTIVE_RESCUE", level.hostage_position, "hostage_x_pressed", undefined, undefined, &"SO_ASSASSIN_PAYBACK_OBJECTIVE_HOSTAGES" );
	wait( 0.1 );
	so_objective_handler( obj( "smoke" ),  &"SO_ASSASSIN_PAYBACK_OBJECTIVE_SIGNAL", undefined, "smoke_thrown" );
	wait( 0.1 );
	so_objective_handler( obj( "defend" ), &"SO_ASSASSIN_PAYBACK_OBJECTIVE_DEFEND_EXFIL", undefined, "rescue_arrives" );
	wait( 0.1 );
	//win
	level.challenge_end_time = gettime();
	flag_set( "so_assassin_payback_complete" );
}

vip_objectives()
{
	level endon( "obj_vips_dead" );
	
	// kill VIPs -- sadly, in order for the distance/text behavior to work, each vip kill has to be treated as a separate objective
	Objective_Add( obj( "kill_vips" ), "active", &"SO_ASSASSIN_PAYBACK_OBJECTIVE_ELIMINATE_VIP1" );
	Objective_Add( obj( "kill_vips2" ), "active", &"SO_ASSASSIN_PAYBACK_OBJECTIVE_ELIMINATE_VIP2" );
	
	Objective_Current( obj( "kill_vips" ), obj( "kill_vips2" ) );

	level.vip_array[0] thread individual_vip_objective( obj( "kill_vips" ) );
	level.vip_array[0] thread remove_icon_on_death( obj( "kill_vips" )  );
	level.vip_array[1] thread individual_vip_objective( obj( "kill_vips2" ) );	
	level.vip_array[1] thread remove_icon_on_death( obj( "kill_vips2" )  );
}

remove_icon_on_death( obj_index )
{	
	level endon( "special_op_terminated" );
	
	self waittill( "death" );
	Objective_Complete( obj_index );
}

// Display the objective at the VIPs position.  Display it first as a distance, then as a "target"
individual_vip_objective( obj_index )
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	spotted = false;
	
	while( !spotted )
	{
		Objective_Position( obj_index, self.origin );
		if( either_player_looking_at( self GetEye() ) ||  either_player_looking_at( self.origin ) )
		{
			spotted = true;
		}
		wait( 0.1 );
	}
			   
	// once a player has seen a VIP, switch his objective marker to "Target"
	Objective_OnEntity( obj_index, self );
	Objective_SetPointerTextOverride( obj_index, &"SO_ASSASSIN_PAYBACK_OBJECTIVE_KILL" );
}



// These are the VIPs initial wander paths
vip1Path()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	self endon( "pain" );
	self endon( "group_wake" );
	
	struct1 = GetStruct( "vip1_struct1", "targetname" );
	struct2 = GetStruct( "vip1_struct2", "targetname" );
	struct3 = GetStruct( "vip1_struct3", "targetname" );

	while( true )
	{
		self SetGoalPos( struct1.origin );
		self waittill( "goal" );
		wait( 4.0 );
		self SetGoalPos( struct2.origin );
		self waittill( "goal" );
		wait( 2.0 );
		self SetGoalPos( struct3.origin );
		self waittill( "goal" );		
		wait( 5.0 );
	}
}

vip2Path()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	self endon( "pain" );
	self endon( "group_wake" );
	
	struct1 = GetStruct( "vip2_struct1", "targetname" );
	struct2 = GetStruct( "vip2_struct2", "targetname" );
	struct3 = GetStruct( "vip2_struct3", "targetname" );

	while( true )
	{
		self SetGoalPos( struct1.origin );
		self waittill( "goal" );
		wait( 6.0 );
		self SetGoalPos( struct2.origin );
		self waittill( "goal" );
		wait( 8.0 );
		self SetGoalPos( struct3.origin );
		self waittill( "goal" );		
		wait( 5.0 );
	}
}

guard_path()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	self endon( "pain" );
	self endon( "group_wake" );
	
	// turn off the spawner's pathing system with target so we can do it manually
	waitframe();
	self notify( "stop_going_to_node" );
	
	myGoal = GetStruct( self.target, "targetname" );
	
	while( true )
	{
		self.pathenemylookahead = 8;
		self SetGoalPos( myGoal.origin );
		self set_generic_idle_anim( "casual_stand_idle" );
		self.goalradius = 16;
		self.ignoreall = true;
		self waittill( "goal" );
		self.script_forcegoal = true;
		wait( 6.0 );
		myGoal = GetStruct( myGoal.target, "targetname" );
	}
}
	
/********************************
 * UTILITY FNs
 * ******************************/	

sandstorm_skybox_hide()
{
	skyboxes = GetEntArray( "sandstorm_sky" , "targetname" );
	foreach( box in skyboxes )
	{
		box Hide();
	}
	skyboxes = GetEntArray( "blue_sky" , "targetname" );
	foreach( box in skyboxes )
	{
		box Show();
	}
}

sandstorm_skybox_show()
{
	skyboxes = GetEntArray( "sandstorm_sky" , "targetname" );
	foreach( box in skyboxes )
	{
		box Show();
	}
	skyboxes = GetEntArray( "blue_sky" , "targetname" );
	foreach( box in skyboxes )
	{
		box Hide();
	}
}

// borrowed from paris_shared.gsc
spawn_corpses(targetname, anime_override)
{	
	corpses = [];
	
	// old system - look up all spawners with the given targetname, spawn corpses with them
	// problem is the engine insists on dropping them to the ground before spawning, so we can't
	// sit them at chairs, slumped over tables, etc.
	foreach(corpse_spawner in GetEntArray(targetname, "targetname"))
	{
		if(IsSpawner(corpse_spawner))
		{
			anime = corpse_spawner.script_noteworthy;
			if(IsDefined(anime_override))
			{
				anime = anime_override;	
			}
			corpses[corpses.size] = spawn_corpse(corpse_spawner, anime, corpse_spawner.origin, corpse_spawner.angles);
		}
	}
	
	// new system - corpses are structs, and they search for a spawner with the classname of the struct's script_noteworthy
	// the spawner must have a script_noteworthy of "corpse_spawner"
	structs = getstructarray(targetname, "targetname");	
	foreach(corpse_struct in structs)
	{
		AssertEx(IsDefined(corpse_struct.script_noteworthy), "Corpse struct needs script_noteworthy of the classname of actor to spawn");
		spawner_classname = corpse_struct.script_noteworthy;
		
		spawners = GetEntArray(spawner_classname, "classname");
		spawner = undefined;
		foreach(possible_spawner in spawners)
		{
			if(IsSpawner(possible_spawner) && IsDefined(possible_spawner.script_noteworthy) && possible_spawner.script_noteworthy == "corpse_spawner")
			{
				spawner = possible_spawner;
				break;
			}			
		}
		if(IsDefined(spawner))
		{
			// ok, found a spawner
			AssertEx(IsDefined(corpse_struct.script_animation), "Corpse struct needs script_animation set to the anime of the animation");
			
			corpses[corpses.size] = spawn_corpse(spawner, corpse_struct.script_animation, corpse_struct.origin, corpse_struct.angles);
		}
		else
		{
			AssertEx(false, "couldn't find spawner with classname " + spawner_classname + "and script_noteworthy corpse_spawner for spawning a corpse (NOTE: classnames are case-sensitive)");
		}
		
	}
	
	return corpses;
}

spawn_corpse(spawner, anime, origin, angles)
{
	spawner.count++;

	// we're reusing spawners, but the spawn may fail silently due to being called on the same frame...
	corpse_drone = undefined;
	while(true)
	{
		corpse_drone = spawner spawn_ai( true );
		if(IsDefined(corpse_drone))
			break;
		waitframe();
	}
	
	if(IsDefined(corpse_drone))
	{
		corpse_drone.animname = "generic";
		corpse_drone gun_remove();
		corpse_drone ForceTeleport(origin, angles);
		sAnim = corpse_drone getanim(anime);
		corpse_drone anim_generic_first_frame(corpse_drone, anime);
		dummy = maps\_vehicle_aianim::convert_guy_to_drone(corpse_drone);
		dummy SetAnim( sAnim, 1, .2 );
		dummy NotSolid();
		return dummy;
	}			
}

add_radio(lines)
{
	foreach(line in lines)
	{
		level.scr_radio[line] = line;	
	}	
}

setup_vo()
{
	//overlord
	
	add_radio([
		"so_assassin_enemy_heading_your_way",	//Enemy forces heading your way.
		"so_assassin_team_large_enemy_force",	//Team, large enemy force moving towards your location
//		"so_assassin_confirm_good_kills",		//Confirm good kills.  Proceed to hostage location and secure for transport.
		"so_assassin_chopping_a_task_force",	//Chopping a Task Force to your location.  Standby.
		"so_assassin_enemy_contacts",			//Enemy contacts approaching your position.
		"so_assassin_enemy_littlebird",			//Enemy Littlebird incoming
//		"so_assassin_metal_zero_one",			//Metal Zero-One, Kill order approved.  Engage your targets.
//		"so_assassin_confirm_kill",				//Confirm Kill.  Move in and engage next target.
// replacement VO lines below:	
		"so_assassin_approved_to_engage",		//Hitman 2, you are approved to engage those targets.
		"so_assassin_kill_confirmed", 			//Kill confirmed.
		"so_assassin_one_more",					//One more to go.
		"so_assassin_nice_work"				//Nice work.  You're clear to proceed.
	]); 
}

//===========================================
// 				  run_music
//==========================================
run_music()
{
	maps\_audio_music::MUS_play("pybk_mx_construction");
}