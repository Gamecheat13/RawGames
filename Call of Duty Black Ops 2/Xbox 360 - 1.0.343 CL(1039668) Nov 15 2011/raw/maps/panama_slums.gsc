#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\panama_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

skipto_slums_intro()
{
	start_teleport_players( "player_skipto_slums_intro" );	
	
	flag_set( "movie_done" );
}

skipto_slums_main()
{
	level.mason = init_hero( "mason" );
	level.noriega = init_hero( "noriega" );
	level.noriega set_ignoreall( true );
	level.noriega set_ignoreme( true );

	start_teleport( "player_skipto_slums_main", level.heroes);	
	
	flag_wait( "panama_gump_3" );
	
	maps\createart\panama_art::slums();
}

skipto_slums_halfway()
{
	
}

init_flags()
{
	flag_init( "ambulance_complete" );
	flag_init( "ambulance_staff_killed" );
	flag_init( "ambulance_player_engaged" );
	flag_init( "slums_done" );
	flag_init( "slums_player_at_overlook" );
	flag_init( "slums_noriega_at_overlook" );
	flag_init( "slums_mason_at_overlook" );
	flag_init( "slums_player_down" );
	flag_init( "slums_shot_at_snipers" );
	flag_init( "slums_e_02_start" );
	flag_init( "slums_e_02_finish" );
	flag_init( "slums_molotov_triggered" );
	flag_init( "slums_update_objective" );
	flag_init( "slums_nest_engage" );
	flag_init( "slums_apache_retreat" );
}

challenge_destroy_zpu( str_notify )
{
	level waittill( "slums_zpu_destroyed" );
	self notify( str_notify );
}

challenge_grenade_combo( str_notify )
{	
	while( 1 )
	{
		level waittill( "combo_death" );
		self notify( str_notify );
	}
}

intro()
{
	flag_wait( "panama_gump_3" );
	
	maps\createart\panama_art::slums();
	
	flag_wait( "movie_done" );
	
	level.mason = init_hero( "mason" );
	level.noriega = init_hero( "noriega" );
	
	//start ambulance looping
	level thread intro_ambulance();
	
	//move the three heroes into position
	level.player thread intro_player();
	level.mason thread intro_mason();
	level.noriega thread intro_noriega();
	
	//Shabs - 8/26 - added checkpoint in case player shoots civs
	autosave_by_name( "ambulance_start" );
	
	flag_wait( "ambulance_player_engaged" );
}

intro_ambulance()
{
	level thread run_scene( "slums_ambulance_doors" );
	level thread run_scene( "slums_intro_ambulance_loop" );
	level thread run_scene( "slums_intro_corpses" );
	level thread run_scene( "slums_overlook_corpse" );
	level thread intro_civilian_watch();
	level thread intro_digbat_watch();
	
	//attach siren effects to ambulance
	v_ambulance = GetEnt( "ambulence", "targetname" );
	PlayFXOnTag( getfx( "ambulance_siren" ), v_ambulance, "tag_light_left" );
	PlayFXOnTag( getfx( "ambulance_siren" ), v_ambulance, "tag_light_right" );
	
	flag_wait_any( "ambulance_staff_killed", "ambulance_player_engaged" );
		
	if ( !flag( "ambulance_staff_killed" ) )
	{
		a_staff = get_ai_group_ai( "ambulance_staff" );
		foreach ( e_civ in a_staff )
		{
			e_civ thread intro_civilian_saved();
		}
	}
	
	a_digbats = get_ai_group_ai( "ambulance_digbats" );
	foreach ( e_digbat in a_digbats )
	{
		level thread run_scene( "slums_intro_react_" + e_digbat.animname );
	}
}

intro_civilian_saved()
{
	self endon( "death" );
	
	run_scene( "slums_intro_saved_" + self.animname );
	run_scene( "slums_intro_saved_loop_" + self.animname );
}

intro_civilian_watch()
{
	level endon( "ambulance_player_engaged" );
	
	wait 15;
	run_scene( "slums_intro_ambulance_kill" );
}

intro_digbat_watch()
{
	waittill_ai_group_cleared( "ambulance_digbats" );
	flag_set( "ambulance_complete" );
}

//self is the player
intro_player()
{
	level endon( "ambulance_staff_killed" );
	
	run_scene( "slums_intro_player" );
	
	autosave_by_name( "slums_start" );
	
	self waittill_any( "weapon_fired", "grenade_fire" );
		
	flag_set( "ambulance_player_engaged" );
	
	flag_wait( "ambulance_complete" );
	
	self set_ignoreme( true );
	
	flag_wait( "slums_player_down" );
	
	self set_ignoreme( false );
}

//self is Mason
intro_mason()
{
	//Mason going into AI and Noriega looping
	self set_ignoreall( true );
	self.perfectaim = true;
	self SetGoalNode( GetNode( "mason_slums_intro_cover", "targetname" ) );	
	run_scene( "slums_intro_mason" );
	
	flag_wait_any( "ambulance_staff_killed", "ambulance_player_engaged" );
		
	//while dig bats are alive
	self set_ignoreall( false );

	flag_wait( "ambulance_complete" );
		
	self.perfectaim = false;
	self set_ignoreme( true );
	run_scene( "slums_move_overlook_mason" );
	flag_set( "slums_mason_at_overlook" );
	
	level thread run_scene( "slums_move_overlook_mason_loop" );
			
	flag_wait_all( "slums_player_at_overlook", "slums_mason_at_overlook", "slums_noriega_at_overlook" );
	
	//start the helicopter that will fire at the overlook
	trigger_use( "slums_heli_shoot_trigger" );
		
	level thread intro_overlook_vo();
	run_scene( "slums_overlook_mason" );
	
	m_door = GetEnt( "overlook_door", "targetname" );
	m_door RotateYaw( 135, 1.0, 0.0, 0.5 );

	//if the player is close shake camera and controller rumble
	n_distance = Distance2D( m_door.origin, level.player.origin );
	if( n_distance < 200 )
	{
		Earthquake(0.1, 0.5, level.player.origin, 256);
		level.player PlayRumbleOnEntity( "damage_light" );
	}

	m_door waittill("rotatedone");
	m_door ConnectPaths();
	m_door RotateYaw( -15, 0.5, 0.0, 0.2 );
	
	flag_wait( "slums_player_down" );
	
	self set_ignoreme( false );
}

intro_overlook_vo()
{
	iprintlnbold( "Noriega: We've got to get across the slums!" );
	
	wait 3;
	
	iprintlnbold( "Noriega: You've got to give me a gun!" );
	
	wait 3;
	
	iprintlnbold( "Mason: Oh I'll give you a gun..." );
	
	wait 3;
	
	iprintlnbold( "Mason: Oh shit look out!" );
	
	wait 3;
	
	iprintlnbold( "Mason: Woods you take point, make a path for us." );
}

intro_noriega()
{
	self set_ignoreme( true );
	self set_ignoreall( true );
	
	run_scene( "slums_intro_noriega" );
	level thread run_scene( "slums_intro_noriega_loop" );
	
	flag_wait( "ambulance_complete" );
	
	run_scene( "slums_move_overlook_noriega" );
	flag_set( "slums_noriega_at_overlook" );
	
	level thread run_scene( "slums_move_overlook_noriega_loop" );
	
	flag_wait_all( "slums_player_at_overlook", "slums_mason_at_overlook", "slums_noriega_at_overlook" );
	
	level thread run_scene( "slums_overlook_noriega" );
	
	//TODO Put a notetrack on the point
	wait 5;
	flag_set( "slums_update_objective" );	
}

main()
{
	add_spawn_function_veh( "slums_apache_stay", ::e_02_heli_think );
	add_spawn_function_veh( "slums_zpu", ::e_10_zpu_think );
	add_spawn_function_veh( "slums_overlook_apc", ::e_01_overlook_apc_think );
	
	add_spawn_function_group( "slums_apc_passenger", "targetname", ::e_13_apc_passenger_think );
	add_spawn_function_group( "slums_right_alley_1", "script_noteworthy", ::ambience_right_alley_truck );
	
	level thread air_ambience( "slums_jet", "slums_jet_path", "slums_done" );
	level thread air_ambience( "slums_apache", "slums_apache_path", "slums_done", 8.0, 10.0 );
	level thread ambience_alley_fire( "slums_done" );
	level thread ac130_ambience( "slums_done" );
	level thread sky_fire_light_ambience( "slums", "slums_done" );
	
	level thread slums_cleanup_1();
	
	level thread e_01_overlook();
	level thread e_02_apache_attack();
	level thread e_03_building_destroy();
	level thread e_04_apc_wall_crash();
	level thread e_07_mg_nest();
	level thread e_11_snipers();
	level thread e_12_building_fire();
	level thread e_13_apc_trigger_watch();
	level thread e_15_dumpster_push();
	level thread e_16_claymore_alley();
	level thread e_17_brute_force();
	level thread e_18_lock_breaker();
	level thread e_19_molotov_digbat();
	level thread e_20_scared_couple();
	level thread e_21_store_rummage();
	level thread e_22_woman_beating();
	level thread e_23_parking_lot();
	//SOUND - Shawn J
	level.vehicleSpawnCallbackThread = ::apc_announcements;
	
	//two ways to end the slums
	level thread slums_heroes_watch();
	level thread slums_side_door_watch();
	
	flag_wait( "slums_done" );
}

slums_heroes_watch()
{
	level endon( "slums_done" );
	
	t_position = GetEnt( "building_enter_front_door", "targetname" );
	
	while( 1 )
	{
		if( level.mason IsTouching( t_position ) && level.noriega IsTouching( t_position ) )
		{
			flag_set( "slums_done" );
			return;
		}
		
		wait 1;
	}
}

slums_side_door_watch()
{
	level endon( "slums_done" );
	
	trigger_wait( "building_enter_side_door", "targetname" );
	flag_set( "slums_done" );	
}

slums_cleanup_1()
{
	flag_wait( "slums_bottleneck_reached" );
	
	spawn_manager_kill( "sm_slums_standoff", true );
	spawn_manager_kill( "sm_slums_left_narrow", true );
	spawn_manager_kill( "sm_slums_park_digbats", true );

	a_ai = get_ai_group_ai( "slums_left_narrow" );
	foreach( ai in a_ai )
	{
		ai Delete();
	}
	
	a_ai = get_ai_group_ai( "high_rise_snipers" );
	foreach( ai in a_ai )
	{
		ai Delete();
	}
}

e_01_overlook()
{
	spawn_manager_enable( "sm_slums_allies_5_1" );
	spawn_manager_enable( "sm_slums_axis_5_1" );
	
	spawn_vehicle_from_targetname( "slums_overlook_apc" );
	
	flag_wait( "slums_player_down" );
	
	autosave_by_name( "slums_start" );
	
	spawn_manager_kill( "sm_slums_allies_5_1" );
	spawn_manager_kill( "sm_slums_axis_5_1" );
	
	run_scene( "slums_strobe_grenade_throw" );
	
	//rain vulcan bullets
	v_end_pos = getstruct( "slums_overlook_ac130", "targetname" ).origin;
	ac130_shoot( v_end_pos, true );
	
	v_hydrant_pos = getstruct( "slums_hydrant", "targetname" ).origin;
	for( i = 0; i < 5; i++ )
	{
		MagicBullet( "ac130_vulcan_minigun", v_hydrant_pos + ( 0, 0, 1000 ), v_hydrant_pos );
	}
		
	a_allies = get_ai_group_ai( "slums_5_1_moveup" );
	e_goal_volume = GetEnt( "slums_gv_5_1_moveup", "targetname" );
	foreach ( e_ally in a_allies )
	{
		e_ally.fixednode = false;
		e_ally SetGoalVolumeAuto( e_goal_volume );
		wait RandomFloatRange( 1, 3 );
	}
	
	a_allies = get_ai_group_ai( "slums_5_1_moveup_north" );
	e_goal_volume = GetEnt( "slums_gv_5_1_moveup_north", "targetname" );
	foreach ( e_ally in a_allies )
	{
		e_ally set_ignoreall( true );
		e_ally.fixednode = false;
		e_ally SetGoalVolumeAuto( e_goal_volume );
		wait RandomFloatRange( 1, 3 );
	}
	
}

e_01_overlook_attach_strobe( e_thrower )
{
	e_thrower Attach( "t5_weapon_tactical_insertion_world", "tag_weapon_left" );
	
	e_thrower.e_strobe = spawn( "script_model", e_thrower.origin );
	e_thrower.e_strobe SetModel( "tag_origin" );
	e_thrower.e_strobe LinkTo( e_thrower, "tag_weapon_left" );
	PlayFxOnTag( getfx( "ir_strobe" ), e_thrower.e_strobe, "tag_origin");
	e_thrower.e_strobe playloopsound( "fly_irstrobe_beep", .1 );
}

e_01_overlook_detach_strobe( e_thrower )
{
	e_thrower Detach( "t5_weapon_tactical_insertion_world", "tag_weapon_left" );
	
	e_strobe = e_thrower.e_strobe;
	e_strobe UnLink();
	
	wait 5;
	
	e_strobe Delete();
}

e_01_overlook_apc_think()
{
	self veh_magic_bullet_shield( true );	
		
	a_target_pos = getstructarray( "slums_overlook_apc_target", "targetname" );

	e_target = spawn( "script_origin" , a_target_pos[0].origin );
	
	self set_turret_burst_parameters( 3.0, 5.0, 1.0, 2.0, 4 );
	self set_turret_target( e_target, ( 0, 0, 0 ), 4 );
	self thread fire_turret_for_time( -1, 4 );
		
	while( !flag( "slums_player_down" ) )
	{
		e_target MoveTo( a_target_pos[ RandomInt( a_target_pos.size ) ].origin, 3.0 );	
		e_target waittill( "movedone" );
	}
	
	self stop_firing_turret( 4 );
	e_target Delete();
	self veh_magic_bullet_shield( false );
	self notify( "death" );
}

e_02_apache_attack()
{
	flag_wait( "slums_player_down" );
	
	trigger_use( "slums_heli_fly" );

	flag_wait( "slums_e_02_start" );
	
	autosave_by_name( "slums_apache" );
		
	// start drone spawning in script
	maps\_drones::drones_start( "slums_apache_drones" );
		
	flag_wait( "slums_e_02_finish" );
	
	wait 5;
	
	s_rpg_start = getstruct( "apache_rpg_start", "targetname" );
	s_rpg_end = getstruct( s_rpg_start.target, "targetname" );
	
	MagicBullet( "rpg_magic_bullet_sp", s_rpg_start.origin, s_rpg_end.origin );
	
	//notify the apache to unload rockets and retreat
	flag_set( "slums_apache_retreat" );
	
	// stop drone spawning
	maps\_drones::drones_delete( "slums_apache_drones" );
	level notify( "apache_target_stop" );
	
	//make sure to kill off the remaining alive PDF in the structure
	a_pdf = GetEntArray( "apache_target", "script_noteworthy" );
	foreach( e_drone in a_pdf )
	{
		e_drone thread drone_doDeath( %fakeshooters::death_stand_dropinplace, "remove_drone_corpses");
		wait RandomFloatRange( 0.5, 1.0 );
	}	
}

e_02_apache_wipe_out()
{
	
}

e_02_heli_think()
{
	self SetTeam( "allies" );
	self veh_magic_bullet_shield( true );
	self veh_toggle_tread_fx( 0 );
	
	flag_wait( "slums_e_02_start" );
	
	a_target_pos = getstructarray( "capitol_hill_target", "targetname" );

	e_target = spawn( "script_origin" , a_target_pos[0].origin );
	
	self set_turret_target( e_target, ( 0, 0, 0 ), 0 );
	self thread fire_turret_for_time( -1, 0 );
	
	//continues shooting at the hill until the retreat flag is set
	while( !flag( "slums_apache_retreat" ) )
	{
		e_target MoveTo( a_target_pos[ RandomInt( a_target_pos.size ) ].origin, 3.0 );		
		e_target waittill( "movedone" );
	}
	
	//apache is retreating, stop firing turret and unload rockets	
	self stop_turret( 0 );
	
	for( rockets_fired = 0; rockets_fired < 6; rockets_fired++ )
	{
		//alternate between rockets
		if( rockets_fired % 2 )
		{
			shoot_turret_at_target_once( e_target, ( 0, 0, 0 ), 1 );
		}
		else
		{
			shoot_turret_at_target_once( e_target, ( 0, 0, 0 ), 1 );
		}
		
		//move target to a new position on the hill before firing the next rocket
		e_target MoveTo( a_target_pos[ RandomInt( a_target_pos.size ) ].origin, 0.25 );		
		e_target waittill( "movedone" );
	}

	e_target Delete();
	
	s_retreat = getstruct( "slums_apache_retreat", "targetname" );
	self SetVehGoalPos( s_retreat.origin );
	
	wait 4;
	
	s_retreat = getstruct( "slums_apache_retreat_end", "targetname" );
	self SetVehGoalPos( s_retreat.origin );
	
	wait 10;
	
	VEHICLE_DELETE( self );
}

e_03_building_destroy()
{
	trigger_wait( "trigger_slums_building_destroy" );
	
	autosave_by_name( "slums_building" );
	
	s_start = getstruct( "slums_howitzer_start", "targetname" );
	s_end = getstruct( s_start.target, "targetname" );
	MagicBullet( "ac130_howitzer_minigun", s_start.origin, s_end.origin );
	
	a_ai = get_ai_group_ai( "slums_howitzer_kills" );
	foreach( ai in a_ai )
	{
		ai die();
	}
	
	wait 1;
	
	exploder( 550 );
}

e_04_apc_wall_crash()
{
	trigger_wait( "slums_e4_start" );
	
	autosave_by_name( "slums_crash" );
	level notify( "remove_drone_corpses" );

	level notify( "fxanim_laundromat_wall_start" );
	run_scene( "slums_apc_wall_crash" );
		
	vh_apc = GetEnt( "slums_apc_building", "targetname" );
	nd_path = GetVehicleNode( "slums_apc_building_path", "targetname" );
	
	vh_apc maps\_vehicle::getonpath( nd_path );
	vh_apc maps\_vehicle::gopath();
}

e_07_mg_nest()
{
	sp_allies = GetEnt( "slums_mg_nest_allies", "targetname" );
	sp_allies add_spawn_function( ::magic_bullet_shield );

	spawn_manager_enable( "sm_slums_allies_5_7" );
	spawn_manager_enable( "sm_slums_axis_5_7" );
	
	// Get the Turret
	e_turret = GetEnt( "slums_mg_nest_turret", "targetname" );
	e_turret disable_turret();
	
	// set firing parameters for use in set_turret_burst_parameters()
	n_fire_min = 0.5;
	n_fire_max = 1.1;
	n_wait_min = 0.3;
	n_wait_max = 0.6;
	e_turret maps\_turret::set_turret_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max );
	
	// get the focus target for the turret - it's a script origin
	e_focus_target = Spawn( "script_origin", getstruct( "slums_mg_nest_target_1", "targetname" ).origin );
	
	// Thread a function that moves the origin back and forth between two structs
	//e_focus_target thread e_07_mg_nest_think( "slums_mg_nest_target_1", "slums_mg_nest_target_2" );
	
	e_turret set_turret_ignore_ent_array( array( level.player, level.mason, level.noriega ) );
	
	flag_wait( "slums_nest_engage" );
	
	level thread e_07_rooftop_ambience();
	
	e_turret set_turret_ignore_ent_array( array( level.mason, level.noriega ) );
	
	a_friendlies = GetEntArray( "slums_mg_nest_allies_ai", "targetname" );
	foreach( ai in a_friendlies )
	{
		ai stop_magic_bullet_shield();
	}
	
	spawn_manager_kill( "sm_slums_allies_5_7" );
	spawn_manager_kill( "sm_slums_axis_5_7" );
	

}

e_07_mg_nest_think( str_struct_name_1, str_struct_name_2 )  
{
	// get the first struct
	s_point_1 = getstruct( str_struct_name_1, "targetname" );
	
	// get the second struct
	s_point_2 = getstruct( str_struct_name_2, "targetname" );
	
	n_move_time = 4;  // how long it will take to move between each point
	n_wait_time = 0.75;  // how long to wait after each move
	
	// Move the target 4 times
	while( 1 )
	{
		// move script_origin to point 1
		self MoveTo( s_point_2.origin, n_move_time );
		
		// wait until the move is done with the 'movedone' notify
		self waittill( "movedone" );
		
		// wait a bit before moving again
		wait n_wait_time;
		
		// move script_origin to point 2
		self MoveTo( s_point_1.origin, n_move_time );
		
		// wait until the move is done
		self waittill( "movedone" );
		
		// wait a bit before moving again
		wait n_wait_time;
	}
}

//spawns 3 digbats that run across the rooftops
e_07_rooftop_ambience()
{
	sp_enemy = GetEnt( "slums_rooftop_ambience", "targetname" );
	
	e_enemy = sp_enemy spawn_ai( true );
	e_enemy thread e_07_delete_on_goal( "rooftop_ambience_delete_goal" );
	
	wait 3;
	
	e_enemy = sp_enemy spawn_ai( true );
	nd_goal = GetNode( "rooftop_ambience_goal", "targetname" );
	e_enemy thread force_goal( nd_goal );
	
	wait 4;
	
	e_enemy = sp_enemy spawn_ai( true );
	e_enemy thread e_07_delete_on_goal( "rooftop_ambience_delete_goal" );
}

e_07_delete_on_goal( goal_node_targetname )
{
	nd_goal = GetNode( goal_node_targetname, "targetname" );
	self force_goal( nd_goal );
	self Delete();
}

e_10_zpu_think()
{
	self endon( "death" );
	
	a_target_pos = getstructarray( "slums_zpu_target", "targetname" );

	e_target = spawn( "script_origin" , a_target_pos[0].origin );
	self SetTurretTargetEnt( e_target );
	
	self thread e_10_zpu_burst_fire();
	self thread e_10_zpu_challenge_watch();
	
	while( self.riders.size )
	{
		wait 5;
		e_target MoveTo( a_target_pos[ RandomInt( a_target_pos.size ) ].origin, 3.0 );		
	}
}

e_10_zpu_burst_fire()
{
	self endon("death");
	
	while( self.riders.size )
	{
		n_burst_time = RandomIntRange( 25, 50 );
		
		for( i = 0; i < n_burst_time; i++ )
		{
			self FireWeapon();
			wait(0.05);
		}
		
		wait RandomFloatRange( 0.5, 1.5 );
	}
}

e_10_zpu_challenge_watch()
{
	self waittill( "death" );
	level notify( "slums_zpu_destroyed" );
}
	
e_11_snipers()
{
	add_spawn_function_ai_group( "high_rise_snipers", ::e_11_sniper_think );
	
	trigger_wait( "e_12_building_fire" );
	
	spawn_manager_enable( "sm_slums_axis_5_11" );
}

e_11_sniper_think()
{
	self endon( "death" );
	
	self set_ignoreme( true );
	self set_ignoreall( true );
	
	self thread e_11_sniper_shot();
	
	s_target = getstruct( self.script_noteworthy, "targetname" );
	e_focus_target = Spawn( "script_origin", s_target.origin );
	
	while( !flag( "slums_shot_at_snipers" ) )
	{
		self shoot_at_target( e_focus_target );
	}
	
	self stop_shoot_at_target();
	e_focus_target Delete();
	self shoot_at_target( level.player, undefined, -1 );
	self set_ignoreall( false );
}

e_11_sniper_shot()
{
	self waittill_any( "damage", "death" );
	
	flag_set( "slums_shot_at_snipers" );
}

e_12_building_fire()
{
	t_fire_damage = GetEnt( "e_14_fire_damage", "targetname" );
	t_fire_damage trigger_off();
	
	trigger_wait( "e_12_building_fire" );
	
	level thread run_scene( "slums_burning_building" );
	
	//TODO - Use a notetrack to trigger this
	
	wait 5;
	
	t_fire_damage trigger_on();

	exploder( 520 );
}

e_13_apc_passenger_think()
{
	self endon( "death" );
	
	//self waittill( "exit_vehicle" );
	
	e_goal_volume = GetEnt( "slums_apc_drop_goal", "targetname" );
	self.fixednode = false;
	self SetGoalVolumeAuto( e_goal_volume );	
}

//SOUND - Shawn J
apc_announcements( vehicle )
{
	self endon( "death" );
	
	wait (1);
	//apc_left = GetEnt( "slums_apc_speaker", "targetname" );	
	if( isdefined( vehicle.model ) && vehicle.model == "veh_t6_mil_m113" )
	{
		while(isdefined( vehicle ))
		{
			wait(randomfloatrange( 1, 3 ));
			vehicle playsound( "blk_announcer_01", "sounddone" );
			vehicle waittill( "sounddone" );
			wait(randomfloatrange( 1, 3  ));
			vehicle playsound( "blk_announcer_02", "sounddone" );
			vehicle waittill( "sounddone" );			
		}
	}
	//If we need to turn the announcements off, use a notify and: vehicle stopsounds();
}


//removes the trigger for both APCs once one is hit
e_13_apc_trigger_watch()
{
	t_left_apc = GetEnt( "trigger_slums_apc_left", "script_noteworthy" );
	t_right_apc = GetEnt( "trigger_slums_apc_right", "script_noteworthy" );
	
	waittill_any_ents( t_left_apc, "trigger", t_right_apc, "trigger" );
	
	t_left_apc Delete();
	//t_right_apc Delete();
}

e_15_dumpster_push()
{
	m_clip = GetEnt( "slums_dumpster_clip", "targetname" );
	m_dumpster = GetEnt( "slums_dumpster", "targetname" );
	m_clip LinkTo( m_dumpster );
	
	trigger_wait( "slums_e_15_start" );
	
	run_scene( "dumpster_push" );
	
	e_volume = GetEnt( "slums_gv_5_15_axis", "targetname");
	a_pushers = get_ai_group_ai( "slums_dumpster_pushers" );
	foreach( e_pusher in a_pushers )
	{
		e_pusher SetGoalVolumeAuto( e_volume );
	}
	
	m_clip DisconnectPaths();
}

e_16_claymore_alley()
{
	a_claymores = GetEntArray( "slums_claymore", "targetname" );
	
	foreach( m_claymore in a_claymores )
	{
		PlayFXOnTag( getfx( "claymore_laser" ), m_claymore, "tag_fx" );
		
		m_claymore thread e_16_satchel_damage();
		m_claymore thread e_16_claymore_detonation();
	}
	
	trigger_wait( "slums_claymore_setup" );
	
	level thread run_scene_first_frame( "slums_claymore_plant" );
	
	wait 0.05;
	
	ai_enemy = GetEnt( "slums_claymore_pdf_ai", "targetname" );
	ai_enemy Attach( "weapon_claymore", "tag_weapon_left" );
	ai_enemy thread e_16_holding_claymore();
	
	trigger_look = trigger_wait( "slums_claymore_start" );
	trigger_look Delete();
	run_scene( "slums_claymore_plant" );	
}

e_16_spawn_claymore( ai_pdf )
{
	ai_pdf Detach( "weapon_claymore", "tag_weapon_left" );
	ai_pdf notify( "claymore_planted" );
	
	v_origin = ai_pdf GetTagOrigin( "tag_weapon_left" );
	v_angles = ai_pdf GetTagAngles( "tag_weapon_left" );
	m_claymore = spawn_model( "weapon_claymore", v_origin, v_angles );
	
	PlayFXOnTag( getfx( "claymore_laser" ), m_claymore, "tag_fx" );
		
	m_claymore thread e_16_satchel_damage();
	m_claymore thread e_16_claymore_detonation();	
}

e_16_holding_claymore()
{
	self endon( "claymore_planted" );
	
	self waittill_any( "death", "damage" );
	
	PlayFX( getfx( "claymore_explode" ), self GetTagOrigin( "tag_fx" ) );
	RadiusDamage( self GetTagOrigin( "tag_fx" ), 192, 250, 500 );
	
}

e_16_satchel_damage()
{
	self endon( "death" );
	
	self.health = 100;
	self setcandamage(true);
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	self waittill("damage");
	
	wait .05;
	
	self thread e_16_detonate();
	
}

e_16_claymore_detonation()
{
	self endon( "death" );
	
	detonateRadius = 192;
	
	damagearea = spawn("trigger_radius", self.origin + (0,0,0-detonateRadius), 1, detonateRadius, detonateRadius*2);
	
	while(1)
	{
		damagearea waittill( "trigger", ent );
		
		if( IsPlayer( ent ) )
		{
			if ( ent damageConeTrace(self.origin, self) > 0 )
			{
				wait 0.4;
				self thread e_16_detonate();
				return;
			}
		}
	}
}

e_16_detonate()
{
	PlayFX( getfx( "claymore_explode" ), self GetTagOrigin( "tag_fx" ) );
	RadiusDamage( self GetTagOrigin( "tag_fx" ), 192, 250, 500 );
	self Delete();
}

e_17_brute_force()
{
	//trigger_wait( "e_12_building_fire" );
	
	level thread run_scene( "brute_force_loop" );
	//level thread run_scene_first_frame( "brute_force_props" );
	
	t_start = GetEnt( "slums_brute_force", "targetname" );
	t_start SetHintString( &"PANAMA_LIFT_RUBBLE" );
	t_start SetCursorHint( "HINT_NOICON" );
	t_start waittill( "trigger" );
	t_start Delete();
	
	level.player thread player_lock_in_position( level.player.origin, level.player GetPlayerAngles() );
	
	//switch to the epipen weapon and play it's bring up animation
	str_old_weapon = level.player GetCurrentWeapon();
	level.player GiveWeapon( "epipen_sp" );
	level.player SwitchToWeapon( "epipen_sp" );
	wait 3.0;
	level.player SwitchToWeapon( str_old_weapon );
	level.player TakeWeapon( "epipen_sp" );
	
	level.player notify( "unlink_from_ent" );
	
	wait 0.05;
	
	level thread run_scene( "brute_force_props" );
	run_scene( "brute_force" );
	
	level.player GiveWeapon( "irstrobe_sp" );
	level.player SetActionSlot(1, "weapon", "irstrobe_sp");
	level.player thread ir_strobe_watch();
}

e_18_lock_breaker()
{
	level thread e_18_lock_breaker_reward();
	
	m_door = GetEnt( "lock_breaker_door", "targetname" );
	m_door_clip = GetEnt( "lock_breaker_door_clip", "targetname" );
	m_door LinkTo( m_door_clip );
	
	t_start = GetEnt( "slums_lock_breaker", "targetname" );
	t_start SetHintString( &"PANAMA_PICK_LOCK" );
	t_start SetCursorHint( "HINT_NOICON" );
	t_start waittill( "trigger" );
	t_start Delete();
	
	run_scene( "lock_breaker" );
	delete_scene( "lock_breaker" );
	
	m_door_clip RotateYaw( 90, 1 );
}

e_18_lock_breaker_reward()
{
	trigger_wait( "slums_lock_breaker_reward" );
	
	level.player GiveWeapon( "irstrobe_sp" );
	level.player SetActionSlot(1, "weapon", "irstrobe_sp");
	level.player thread ir_strobe_watch();
	
	level.player GiveWeapon( "nightingale_sp" );
	level.player SetActionSlot(2, "weapon", "nightingale_sp");
	level.player thread nightingale_watch();
	
	a_grenades = GetEntArray( "lockbreaker_grenades", "targetname" );
	foreach( m_grenade in a_grenades )
	{
		m_grenade Delete();
	}
}

e_19_molotov_digbat()
{
	level thread e_19_left_side();
	level thread e_19_right_side();
	
	flag_wait( "slums_molotov_triggered" );
	
	t_left = GetEnt( "e_19_trigger_molotov_left", "targetname" );
	t_right = GetEnt( "e_19_trigger_molotov_right", "targetname" );
	
	t_left Delete();
	t_right Delete();
}

e_19_attach( e_digbat )
{
	e_digbat Attach( "t6_wpn_molotov_cocktail_prop_world", "tag_weapon_left" );
	PlayFXOnTag( getfx( "molotov_lit" ), e_digbat, "TAG_FX" );
}

e_19_shot( e_digbat )
{
	//remove the model
	e_digbat Detach( "t6_wpn_molotov_cocktail_prop_world", "tag_weapon_left" );
	
	//light him on fire
	PlayFXOnTag( getfx( "on_fire_tor" ), e_digbat, "J_Spine4" );
	PlayFXOnTag( getfx( "on_fire_leg" ), e_digbat, "J_Hip_LE" );
	PlayFXOnTag( getfx( "on_fire_leg" ), e_digbat, "J_Hip_RI" );
	PlayFXOnTag( getfx( "on_fire_arm" ), e_digbat, "J_Elbow_LE" );
	PlayFXOnTag( getfx( "on_fire_arm" ), e_digbat, "J_Elbow_RI" );
}

e_19_left_side()
{
	level endon( "e_19_molotov_triggered" );
	
	trigger_wait( "e_19_trigger_molotov_left" );
	
	level run_scene( "slums_molotov_throw_left" );
}

e_19_right_side()
{
	level endon( "e_19_molotov_triggered" );
	
	trigger_wait( "e_19_trigger_molotov_right" );
	
	run_scene( "slums_molotov_throw_right" );
}

e_20_scared_couple()
{
	trigger_wait( "slums_e_20_start" );
	
	level thread run_scene( "slums_scaredcouple_introloop" );
	
	trigger_wait( "slums_e_20_look" );
	
	run_scene( "slums_scaredcouple_reaction" );
	level thread run_scene( "slums_scaredcouple_outroloop" );
}

e_21_store_rummage()
{
	trigger_wait( "slums_e_21_start" );
	
	level thread run_scene( "slums_apt_rummage_loop" );
	
	trigger = trigger_wait( "slums_e_21_react" );
	trigger Delete();
	
	run_scene( "slums_apt_rummage_react" );		
	
	delete_scene( "slums_apt_rummage_loop" );
	delete_scene( "slums_apt_rummage_react" );
}

e_22_woman_beating()
{
	trigger_wait( "slums_e_22_start" );
	
	level thread run_scene( "beating_loop" );
	level thread run_scene( "beating_corpse" );
	
	trigger = trigger_wait( "slums_e_22_react" );
	trigger Delete();
	
	run_scene( "beating_reaction" );	
}

e_23_parking_lot()
{
	trigger_wait( "slums_e_23_start" );
	
	level thread run_scene( "parking_jump" );
	
	s_window_start = getstruct( "e_23_window_damage", "targetname" );
	s_window_end = getstruct( s_window_start.target, "targetname" );
	
	level thread run_scene( "parking_window" );
	
	wait 0.5;
	
	for( i = 0; i < 5; i++ )
	{
		MagicBullet( "ak47_sp", s_window_start.origin, s_window_end.origin );
		wait .05;
	}
}

ambience_right_alley_truck()
{
	self endon( "death" );
	
	self waittill( "exit_vehicle" );
	
	self.goalradius = 32;
	s_goal = getstruct( "slums_right_alley_1", "targetname" );
	self SetGoalPos( s_goal.origin );
	self waittill( "goal" );
	
	self Delete();
}

ambience_alley_fire( flag_ender )
{
	a_triggers = GetEntArray( "slums_fakefire_lookat", "targetname" );
	array_thread( a_triggers, ::ambient_alley_fire_think, flag_ender );
}

ambient_alley_fire_think( flag_ender )
{
	//grab all starting bullet positions from the trigger
	a_fire_pos = getstructarray( self.target, "targetname" );
	
	while( !flag( flag_ender ) )
	{
		self waittill( "trigger" );
		
		level thread ambient_alley_fire_burst( a_fire_pos[ RandomInt( a_fire_pos.size ) ] );
		wait 0.5;
	}
	
	self Delete();
}

ambient_alley_fire_burst( s_start )
{
	v_start = s_start.origin;
	v_end = getstruct( s_start.target, "targetname" ).origin;
	
	for( i = 0; i < 10; i++ )
	{
		MagicBullet( "ak47_sp", v_start, v_end );
		wait 0.05;
	}
}