#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\panama_utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\panama_2_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

skipto_slums_intro()
{
	skipto_teleport_players( "player_skipto_slums_intro" );	
		
	flag_set( "movie_done" );
}

skipto_slums_main()
{
	level.mason = init_hero( "mason" );
	level.mason change_movemode( "cqb_sprint" );
	level.mason.grenadeAwareness = 0;
	
	level.noriega = init_hero( "noriega" );
	level.noriega set_ignoreall( true );
	level.noriega set_ignoreme( true );
	level.noriega change_movemode( "run" );
	level.noriega.grenadeAwareness = 0;

	skipto_teleport( "player_skipto_slums_main", level.heroes);	
	
	//	flag_wait( "panama_gump_3" );
	
	//TODO: - just for the skipto
	trigger_use("trig_slums_start", "targetname");
	flag_set( "slums_mason_at_overlook" );
	trigger_use( "slums_heli_shoot_trigger" );
	flag_set( "slums_update_objective");
	
	delay_thread( 5, ::flag_set, "slums_player_down" );
	
	level thread slums_paired_movement();
	
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
	flag_init( "slums_start_building_fire" );
	flag_init( "slums_bottleneck_reached" );
	flag_init( "slums_bottleneck_2_reached" );
		
	// SLUMS MOVEMENT FLAGS
	flag_init( "noriega_moved_now_move_mason" );
	flag_init( "mv_noriega_to_van" );
	flag_init( "mv_noriega_to_dumpster" );
	flag_init( "mv_noriega to_parking_lot" );
	flag_init( "mv_noriega_to_gazebo" );
	flag_init( "mv_noriega_just_before_stairs" );
	flag_init( "mv_noriega_slums_left_bottleneck" );
	flag_init( "mv_noriega_right_of_church" );
	flag_init( "mv_noriega_before_church" );
	flag_init( "mv_noriega_slums_right_bottleneck" );
	flag_init( "mv_noriega_slums_right_bottleneck_complete" );
	flag_init( "mv_noriega_move_passed_library" );
	
	//shabs
	flag_init( "spawn_balcony_digbat" );
	flag_init( "building_breach_ready" );
	flag_init( "army_street_push" );
	flag_init( "left_path_cleanup" );
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

challenge_rescue_soldier( str_notify )
{
	level waittill( "slums_soldier_rescued" );
	self notify( str_notify );
}
	
challenge_find_weapon_cache( str_notify )
{
	level waittill( "slums_found_weapon_cache" );
	self notify( str_notify );
}

slums_wind_settings()
{
	SetSavedDvar( "wind_global_vector", "246.366 0 0" );						// change "1 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0 );						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 5000 );					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.5 );	// change 0.5 to your desired wind strength percentage		
}

intro()
{
//	flag_wait( "panama_gump_3" );

	level slums_wind_settings();
	
	maps\createart\panama_art::slums();
	
	flag_wait( "movie_done" );
	
	level.mason = init_hero( "mason" );
	level.noriega = init_hero( "noriega" );
	
	//start ambulance looping
	level thread intro_ambulance();
	
	/#get_animation_endings();#/
	
	//move the three heroes into position
	level.player thread intro_player();
	level.mason thread intro_mason();
	level.noriega thread intro_noriega();
	
	level thread slums_manage_grenade_count(); //-- reduce the amount of the grenades on the AI
	level thread slums_spawn_functions();
	
	//Shabs - 8/26 - added checkpoint in case player shoots civs
	autosave_by_name( "ambulance_start" );
	
	flag_wait( "ambulance_player_engaged" );
}

slums_spawn_functions()
{
	add_spawn_function_veh( "slums_opening_read_heli", ::littlebird_fire_until_flag, "move_intro_heli" );
}

littlebird_fire_until_flag(str_flag)
{
	self thread fire_turret_for_time( -1, 1 );
	self thread fire_turret_for_time( -1, 2 );
	
	flag_wait( str_flag );
	
	self stop_turret( 1 );
	self stop_turret( 2 );
}

slums_manage_grenade_count()
{
	a_axis_array = GetSpawnerTeamArray( "axis" );
	
	foreach( e_spawner in a_axis_array )
	{
		if(RandomInt(2) < 1)
		{
			e_spawner.script_grenades = 0;
		}
		else
		{
			e_spawner.script_grenades = 1;	
		}
	}
}

intro_show_gun( player_body )
{
	level.player EnableWeapons();
	level.player ShowViewModel();
}

intro_civ()
{	
	level thread run_scene( "slums_intro_civ_3_fight" );
	
	level thread run_scene( "slums_intro_civ_4_loop" );
	
	flag_wait( "slums_intro_civ_4_loop_started" );
	
	wait 0.65;
	
	ai_doctor = GetEnt( "amb_doctor_4_ai", "targetname" );
	ai_doctor ragdoll_death();
	
	wait 3;
	
	ai_doctor = GetEnt( "amb_doctor_3_ai", "targetname" );
	ai_doctor ragdoll_death();
}

intro_bat_digbat()
{
	run_scene( "slums_intro_digbat_fight" );
	
	level thread run_scene( "slums_intro_digbat_loop" );
	
	flag_wait_any( "ambulance_staff_killed", "ambulance_player_engaged" );

	end_scene( "slums_intro_digbat_loop" );
}

ambulance_van()
{
	run_scene( "slums_ambulance" );
	
	//attach siren effects to ambulance
	v_ambulance = GetEnt( "ambulence", "targetname" );
	PlayFXOnTag( getfx( "ambulance_siren" ), v_ambulance, "tag_light_left" );
	PlayFXOnTag( getfx( "ambulance_siren" ), v_ambulance, "tag_light_right" );
}

intro_ambulance()
{
	level thread intro_civ();
	level thread intro_bat_digbat();
	
	level thread ambulance_van();
	
//	level thread run_scene( "slums_ambulance_doors" );
	
	level thread run_scene( "slums_intro_corpses" );
//-- TODO: DELETE
//	level thread run_scene( "slums_overlook_corpse_loop" );
	
	level thread intro_civilian_watch();
	level thread intro_digbat_watch();
	
//	//attach siren effects to ambulance
//	v_ambulance = GetEnt( "ambulence", "targetname" );
//	PlayFXOnTag( getfx( "ambulance_siren" ), v_ambulance, "tag_light_left" );
//	PlayFXOnTag( getfx( "ambulance_siren" ), v_ambulance, "tag_light_right" );
	
	flag_wait_any( "ambulance_staff_killed", "ambulance_player_engaged" );
		
	if ( !flag( "ambulance_staff_killed" ) )
	{
		a_staff = get_ai_group_ai( "ambulance_staff" );
		foreach ( e_civ in a_staff )
		{
			e_civ thread intro_civilian_saved();
		}
		a_digbats = get_ai_group_ai( "ambulance_digbats" );
		foreach ( e_digbat in a_digbats )
		{
			level thread run_scene( "slums_intro_react_" + e_digbat.animname );
		}
	}
	
	flag_wait( "slums_player_down" );
	
	end_scene( "slums_ambulance" );
//	end_scene( "slums_ambulance_doors" );
	end_scene( "slums_intro_corpses" );
	//end_scene( "slums_overlook_corpse_loop" );
	end_scene( "slums_intro_digbat_loop" );
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
	
//	//number of loops for the control pair before execution callout (nurse and digbat)
//	n_loops = 4;
	
	level thread run_scene( "slums_intro_ambulance_loop_1" );
	level thread run_scene( "slums_intro_ambulance_loop_2" );
	level thread run_scene( "slums_intro_ambulance_loop_control" );
	
	wait 19;
	
//	for( i = 1; i < n_loops; i++ )
//	{
//		run_scene( "slums_intro_ambulance_loop_control" );
//	}

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
	
	//-- TODO: This should trigger off when anyone fires, not just the player
	self waittill_any( "weapon_fired", "grenade_fire" );
		
	flag_set( "ambulance_player_engaged" );
	
	flag_wait( "ambulance_complete" );
	
	self set_ignoreme( true );
	
	flag_wait( "slums_turn_off_player_ignore" );
	
	self set_ignoreme( false );
}

intro_player_vo_1( ai_mason )
{
	level.player say_dialog( "okay_fucker_wh_001" );	//Okay, fucker... Which way now?
}

intro_player_vo_2( ai_mason )
{
	level.player say_dialog( "got_it_011" );	//Got it.
}

//self is Mason
intro_mason()
{
	//Mason going into AI and Noriega looping
	self set_ignoreall( true );
	self.grenadeAwareness = 0;
	self disable_react();
	self.perfectaim = true;
	self SetGoalNode( GetNode( "mason_slums_intro_cover", "targetname" ) );	

	run_scene( "slums_intro" );
	level thread run_scene( "slums_intro_loop" );

	level thread player_door_kick();
	
	flag_wait( "ambulance_complete" );
	
	//Audio notify to slowly quiet distant gunfire\explosions for the hallway scene
	level ClientNotify ("dbid");
	
	//exploder for burning building, gets turned off when fxanim starts
	exploder(15011);
	
	end_scene( "slums_intro_loop" );
	
	run_scene( "slums_into_building" );
	
	
	
	if ( !flag( "slums_player_see_pistol_anim" ) )
	{
		level thread run_scene( "slums_into_building_wait" );
		flag_wait( "slums_player_see_pistol_anim" );
		end_scene( "slums_into_building_wait");
	}
	
	run_scene( "slums_noriega_pistol" );
	level notify("noriega_pistol_animation_done");
		
	//TODO: FIX THIS WITH SKY COWBELL
	//start the helicopter that will fly byt the overlook
	//trigger_use( "slums_heli_shoot_trigger" );
	
	//TODO: this used to be on a notetrack, make sure this implementation makes sense
	flag_set( "slums_update_objective");
	
	if(!flag("slums_player_took_point") ) //-- try to avoid a 1 frame pop
	{
		level thread run_scene( "slums_noriega_pistol_wait" );
		flag_wait( "slums_player_took_point" );	
		end_scene( "slums_noriega_pistol_wait" );
	}
	
	level.noriega Detach( "c_pan_noriega_sack", ""); //-- remove the sack
	level.noriega Attach( "c_pan_noriega_cap", "", true ); //-- attach the hat
	
	self set_ignoreme( false );
	self set_ignoreall( false );
	self change_movemode( "cqb_sprint" );
	
	level thread slums_paired_movement();
	
	//FIXME: write a proper setup function for the slums
	level thread veh_animate_pickup_trucks();
	level thread veh_animate_pickup_cars();
	
	//TODO: - REMOVE THIS
	trigger_use("trig_slums_start", "targetname");
}

player_door_kick()
{
	e_clip = GetEnt("player_blocker_door_clip", "targetname");
	e_door = GetEnt("player_blocker_door", "targetname" );
	
	e_clip LinkTo( e_door );
	
	//e_rotator = GetEnt("player_door_rotate_origin", "targetname");
	//e_door LinkTo( e_rotator );
	
	//run_scene_first_frame( "player_door_kick_door" );
	
	level waittill("noriega_pistol_animation_done");
	trigger_wait( "trig_player_kick_door" );
	
	level thread run_scene( "player_door_kick_door" );
	
	level ClientNotify ("drkck");
	
	level run_scene( "player_door_kick" );
	
	//flag_wait( "slums_rotate_door" );
	
	//e_rotator RotateYaw( 101, 0.5 );
	
	flag_set( "slums_player_took_point" );
	
	level thread dialog_intro_to_slums();
}


intro_noriega()
{
	self set_ignoreme( true );
	self set_ignoreall( true );
	self.grenadeAwareness = 0;
	
	//self Attach( "c_pan_noriega_sack", "", true ); TODO: DELETE THIS IF THE NEW CHAR MODEL WORKS
	
	self change_movemode( "run" );
	self set_noriega_run_anims();
}

set_noriega_run_anims()
{
	self animscripts\anims::clearAnimCache();

	self.a.combatrunanim = %generic_human::ai_noriega_run;
	self.run_noncombatanim  = self.a.combatrunanim;
	self.walk_combatanim 	= self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
}

main()
{
	slums_drones_setup();
	slums_magic_rpg_setup();
	
	add_spawn_function_veh( "slums_apache_stay", ::e_02_heli_think );
	add_spawn_function_veh( "slums_zpu", ::e_10_zpu_think );
	add_spawn_function_veh( "slums_overlook_apc", ::e_01_overlook_apc_think );
	
	add_spawn_function_group( "slums_apc_passenger", "targetname", ::e_13_apc_passenger_think );
	add_spawn_function_group( "slums_right_alley_1", "script_noteworthy", ::ambience_right_alley_truck );
	
	level thread air_ambience( "slums_jet", "slums_jet_path", "slums_done" );
	level thread air_ambience( "slums_apache", "slums_apache_path", "slums_done", 8.0, 10.0 );
	level thread ambience_alley_fire( "slums_done" );
	level thread ambient_alley_dog();
	
	//dogs
	//level thread dog_that_runs_on_slum_entrance();
	level thread ambient_slums_dog_init(); //-- dogs that run inside the slums
	
	
	level thread ac130_ambience( "slums_done" );
	level thread sky_fire_light_ambience( "slums", "slums_done" );
	
	//level thread slums_nag_setup();
	
	level thread slums_cleanup_1();
	
	level thread e_01_left_path_cleanup();
	
	//spread out the threads
	wait 0.05;
	
	level thread e_01_left_path();
	
	level thread e_01_overlook();
	level thread e_02_apache_attack();
	level thread e_03_building_destroy();
	level thread e_04_apc_wall_crash();
	level thread e_07_mg_nest();
	level thread e_11_snipers();
//	level thread e_12_building_fire();
	level thread e_13_apc_trigger_watch();
	level thread e_15_dumpster_push();
	level thread e_16_claymore_alley();
	level thread e_17_brute_force();
	//level thread e_18_lock_breaker();
	level thread e_19_molotov_digbat();
	level thread e_19_molotov_digbat_alley();
	//level thread e_20_scared_couple();
	level thread e_21_store_rummage();
	level thread e_22_woman_beating();
	level thread e_23_parking_lot();
	level thread slums_bottle_neck();
	//SOUND - Shawn J
	level.vehicleSpawnCallbackThread = ::apc_announcements;
	
	//two ways to end the slums
	level thread slums_heroes_watch();
//	level thread slums_side_door_watch(); //not needed anymore, blocking left path in.
	
	level thread building_player_breach();
	
	flag_wait( "slums_done" );
	
	level run_scene("slums_breach_exit");
}

notetrack_function_end_mission( guy )
{
	wait(1.5);
	nextmission();
}

building_player_breach()
{
	trig_building_player_breach = GetEnt( "trig_building_player_breach", "targetname" );
	trig_building_player_breach SetHintString( &"PANAMA_MOTEL_BREACH" );
	trig_building_player_breach SetCursorHint( "HINT_NOICON" );
	trig_building_player_breach trigger_off();
	
	flag_wait( "building_breach_ready" );
	
	trig_building_player_breach trigger_on();
	trig_building_player_breach waittill( "trigger" );
	flag_set( "slums_done" );
	
	wait 0.05;
	
	trig_building_player_breach Delete();	
}

slums_nag_setup()
{
	add_vo_to_nag_group( "slums_nag", level.mason, "go_keep_moving_012" );  	//Go! Keep moving!
	add_vo_to_nag_group( "slums_nag", level.mason, "were_right_behind_013" ); 	//We're right behind you.
	add_vo_to_nag_group( "slums_nag", level.mason, "keep_moving_014" ); 		//Keep moving!
	add_vo_to_nag_group( "slums_nag", level.mason, "we_gotta_pick_up_015" ); 	//We gotta pick up!
	add_vo_to_nag_group( "slums_nag", level.mason, "hurry_woods_hurr_016" ); 	//Hurry, Woods. Hurry!
	add_vo_to_nag_group( "slums_nag", level.mason, "dont_hold_up_h_ju_017" ); 	//Don't hold up - Just keep moving.
	
	flag_wait( "slums_player_down" );
	
	level thread start_vo_nag_group_flag( "slums_nag", "slums_done", 15, 5, false, 3, ::slums_nag_check );
}

//created for additional checks on when to play nag lines from Mason
slums_nag_check()
{
	return true;	
}

slums_drones_setup()
{
	sp_drone_ally = GetEnt( "slums_ally_drone", "targetname" );
	maps\_drones::drones_assign_spawner( "slums_ally_drone_trigger", sp_drone_ally );
	
	sp_drone_axis = GetEnt( "slums_axis_drone", "targetname" );
	maps\_drones::drones_assign_spawner( "slums_axis_drone_trigger", sp_drone_axis );
	maps\_drones::drones_assign_spawner( "slums_apache_drones", sp_drone_axis );
	maps\_drones::drones_assign_spawner( "slums_howitzer_drones", sp_drone_axis );
	
	sp_digbat_axis = GetEnt( "slums_digbat_drone", "targetname" );
	maps\_drones::drones_assign_spawner( "slums_digbat_drone_trigger", sp_digbat_axis );
}

slums_magic_rpg_setup()
{
	a_triggers = GetEntArray( "slums_rpg", "targetname" );
	array_thread( a_triggers, ::slums_magic_rpg_think );
}

slums_magic_rpg_think()
{
	self waittill( "trigger" );
	
	s_rpg_start = getstruct( self.target, "targetname" );
	s_rpg_end = getstruct( s_rpg_start.target, "targetname" );
	
	MagicBullet( "rpg_magic_bullet_sp", s_rpg_start.origin, s_rpg_end.origin );
	
	self Delete();
}

slums_heroes_watch()
{
	level endon( "slums_done" );
	
	t_position = GetEnt( "building_enter_front_door", "targetname" );
	
	while( 1 )
	{
		if( level.mason IsTouching( t_position ) && level.noriega IsTouching( t_position ) )
		{
			flag_set( "building_breach_ready" );
			return;
		}
		
		wait 1;
	}
}

//slums_side_door_watch()
//{
//	level endon( "slums_done" );
//	
//	trigger_wait( "building_enter_side_door", "targetname" );
//	flag_set( "slums_done" );	
//}

slums_cleanup_1()
{
	flag_wait( "slums_bottleneck_reached" );
	
	spawn_manager_kill( "sm_slums_standoff", true );
	//spawn_manager_kill( "sm_slums_left_narrow", true );
	spawn_manager_kill( "sm_slums_park_digbats", true );

//	a_ai = get_ai_group_ai( "slums_left_narrow" );
//	foreach( ai in a_ai )
//	{
//		ai Delete();
//	}
	
	a_ai = get_ai_group_ai( "high_rise_snipers" );
	foreach( ai in a_ai )
	{
		ai Delete();
	}
}

e_01_left_path_cleanup()
{
	flag_wait( "left_path_cleanup" );
	
	spawn_manager_kill( "sm_slums_left_narrow", true );
	
	a_ai = get_ai_group_ai( "slums_left_narrow" );
	foreach( ai in a_ai )
	{
		ai kill();
	}
}

init_slums_pre_mgnest_axis()
{
	self endon( "death" );
	
	self magic_bullet_shield();
	self set_spawner_targets( "pdf_street_front" );
	
	flag_wait( "slums_player_down" );
	
	self stop_magic_bullet_shield();
	
	flag_wait( "army_street_push" );
	
	self set_spawner_targets( "pdf_street_fallback" );
}

e_01_army_street_push()
{
	a_sp_allies = GetEntArray( "slums_mg_nest_allies", "targetname" );
	array_thread( a_sp_allies, ::add_spawn_function, ::magic_bullet_shield );

	a_slums_pre_mgnest_axis = GetEntArray( "slums_pre_mgnest_axis", "targetname" );
	array_thread( a_slums_pre_mgnest_axis, ::add_spawn_function, ::init_slums_pre_mgnest_axis );
	
	slums_mg_nest_allies = simple_spawn( "slums_mg_nest_allies" );
	
	spawn_manager_enable( "sm_slums_axis_pre_mgnest" );

	flag_wait( "slums_player_down" );
	
	delay_thread( 5, ::flag_set, "army_street_push" ); //timeout if player doesnt move forward and hit trigger
	flag_wait( "army_street_push" );

	trigger_use( "army_street_push_color", "script_noteworthy" );
	
	spawn_manager_disable( "sm_slums_axis_pre_mgnest" );
	
//	//have pdf fall back
//	a_slums_pre_mgnest_axis = get_ai_group_ai( "slums_pre_mgnest_axis" );
//	foreach( axis in a_slums_pre_mgnest_axis )
//	{	
//		axis set_spawner_targets( "pdf_street_fallback" );
//	}
	
//	//push army forward
//	a_slums_mg_nest_allies = get_ai_group_ai( "slums_mg_nest_allies" );
//	foreach( ally in a_slums_mg_nest_allies )
//	{
//		ally set_spawner_targets( "army_street_push" );
//	}
}

e_01_fire_building_civs()
{
	a_fire_building_civilians = GetEntArray( "fire_building_civilians", "targetname" );
	array_thread( a_fire_building_civilians, ::add_spawn_function, ::init_fire_building_civilians );		
	
	level thread run_scene( "civs_building_01" );
	level thread run_scene( "civs_building_02" );
	level thread run_scene( "civs_building_03" );
	level thread run_scene( "civs_building_04" );
	level thread run_scene( "civs_building_05" );
	level thread run_scene( "civs_building_06" );
}

init_fire_building_civilians()
{
	self endon( "death" );
	
	nd_delete_fire_civs = GetNode( "delete_fire_civs", "targetname" );
	           
	self.ignoreme = 1;
	self.ignoreall = 1;
	
	self.goalradius = 32;
	self SetGoalPos( nd_delete_fire_civs.origin );
	self waittill( "goal" );
	
	self Die();
	
	//TODO: if player can see civ, send him to another node and die
	// if the player cant see civ, delete him.
}

e_01_left_path()
{
	trigger_wait( "sm_slums_left_narrow" );
	
	a_left_path_heroes = simple_spawn( "left_path_heroes" );
	array_thread( a_left_path_heroes, ::magic_bullet_shield );
	
	trigger_wait( "trig_left_path_truck", "script_noteworthy" );
	
	wait 0.4;

	left_path_pdf_truck = spawn_vehicle_from_targetname_and_drive( "left_path_pdf_truck" );
	
	trigger_wait( "pdf_truck_rpg", "script_noteworthy" );
	
	if ( IsDefined( left_path_pdf_truck ) )
	{
		left_path_pdf_truck notify( "death" );
	}
	
	array_thread( a_left_path_heroes, ::stop_magic_bullet_shield );
	
	a_slums_left_narrow = get_ai_group_ai( "slums_left_narrow" );
	foreach( guy in a_slums_left_narrow )
	{
		if ( guy.team == "axis" )
		{
			guy set_spawner_targets( "pdf_left_path_fallback" );
		}
		else if( guy.team == "allies" )
		{
			guy set_spawner_targets( "army_left_path_push" );
		}
	}
}

e_01_overlook()
{
//	spawn_manager_enable( "sm_slums_allies_5_1" );
//	spawn_manager_enable( "sm_slums_axis_5_1" );
		
	level thread e_01_apc_digbat_alley();
	
	level thread e_01_army_street_push();
	
	flag_wait( "slums_player_down" );
	
	autosave_by_name( "slums_start" );
	
//	spawn_manager_kill( "sm_slums_allies_5_1" );
//	spawn_manager_kill( "sm_slums_axis_5_1" );
	
//	run_scene( "slums_strobe_grenade_throw" );
	
	//wait 2;
	
	//-- put the hydrant in the first damage state
	v_hydrant_pos = getstruct( "slums_hydrant", "targetname" ).origin;
	RadiusDamage( v_hydrant_pos, 36, 350, 349);
	
	//-- This should play when you cn see it
	trigger_wait("trig_lookat_burning_building");
	
	/#iprintln("triggering burning building");#/
	
	stop_exploder(15011);
	level notify( "fxanim_overlook_building_start" );
	level thread e_01_fire_building_civs();
	level.player playsound ( "fxa_pan_overwatch_collapse" );
	
	a_models = GetEntArray( "overlook_hide", "targetname" );
	array_delete( a_models );
	
	wait(0.3);
	level thread dialog_building_collapse();
	
//	level thread e_01_overlook_advance( "slums_5_1_moveup" );
//	level thread e_01_overlook_advance( "slums_5_1_moveup_north" );
}

e_01_apc_digbat_alley()
{
	level endon("kill_e_01_apc_digbat_alley");
	//digbat alley spawn funcs
	/*
	a_apc_alley_digbats = GetEntArray( "apc_alley_digbats", "targetname" );
	array_thread( a_apc_alley_digbats, ::add_spawn_function, ::init_apc_alley_digbats );
	*/
	
	a_apc_alley_army = GetEntArray( "apc_alley_army", "targetname" );
	array_thread( a_apc_alley_army, ::add_spawn_function, ::magic_bullet_shield );	
	
	ai_alley_apc_gunner = GetEnt( "alley_apc_gunner", "targetname" );
	ai_alley_apc_gunner add_spawn_function( ::magic_bullet_shield );	
	
	a_apc_alley_army = simple_spawn( "apc_alley_army" );
	
	spawn_manager_enable( "sm_apc_alley_digbats" );
	
	spawn_vehicle_from_targetname_and_drive( "slums_overlook_apc" );

	flag_wait( "spawn_balcony_digbat" );
	
	//send two army guys up the alley
	foreach( guy in a_apc_alley_army )
	{
		guy set_spawner_targets( "digbat_alley_move" );
	}
	
	trigger_wait( "digbat_alley_rpg", "script_noteworthy" );
	
	//remove magic bullet shield in time for magic rpg
	foreach( guy in a_apc_alley_army )
	{
		if(IsAlive(guy))
		{
			guy stop_magic_bullet_shield();
		}
	}	
}

//init_apc_alley_army()
//{
//	self endon( "death" );
//	
//	self thread magic_bullet_shield();
//	
//	flag_wait( "spawn_balcony_digbat" );
//	
//	self stop_magic_bullet_shield();
//	
//	wait( RandomFloatRange( 0.1, 0.3 ) );	
//	
//	surprise_anim = "exchange_surprise_" + RandomInt( level.surprise_anims );
//	
//	self anim_generic_custom_animmode( self, "gravity", surprise_anim );
//
//	RadiusDamage( self.origin, 32, 32, 32, undefined, "MOD_EXPLOSIVE");
//	self Die();
//}

init_apc_alley_digbats()
{
	self endon( "death" );
	
	n_rand_goal_radius = RandomIntRange( 32, 128 );
	self.goalradius = n_rand_goal_radius;
	
	nd_apc_death = GetNode( self.target, "targetname" );
	self SetGoalNode( nd_apc_death );
	self waittill( "goal" );
	
	self Die();
}

e_01_overlook_advance( str_aigroup )
{
	a_allies = get_ai_group_ai( str_aigroup );
	a_nodes = GetNodeArray( str_aigroup, "targetname" );
	
	for( i = 0; i < a_allies.size; i++ )
	{
		if( IsAlive( a_allies[i] ) )
		{
			a_allies[i] SetGoalNode( a_nodes[i] );
			wait RandomFloatRange( 1, 3 );
		}		
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
	self endon( "death" );
	
	self veh_magic_bullet_shield( true );	
		
	//self maps\_turret::set_turret_burst_parameters( 1.5, 5.0, 0.5, 1.0, 4 ); 	
	self enable_turret( 4 );
	
//	a_target_pos = getstructarray( "slums_overlook_apc_target", "targetname" );

//	e_target = spawn( "script_origin" , a_target_pos[0].origin );
	
//	self set_turret_burst_parameters( 3.0, 5.0, 1.0, 2.0, 4 );m	
//	self set_turret_target( e_target, ( 0, 0, 0 ), 4 );
//	self thread fire_turret_for_time( -1, 4 );
//		
//	while( !flag( "spawn_balcony_digbat" ) )
//	{
//		e_target MoveTo( a_target_pos[ RandomInt( a_target_pos.size ) ].origin, 3.0 );	
//		e_target waittill( "movedone" );
//	}
//	
//	self stop_firing_turret( 4 );
//	e_target Delete();
	
	//flag_wait( "spawn_balcony_digbat" );
	
	trigger_wait("send_apc_rpg", "targetname");
	
	s_start_pos = get_struct("rpg_apc_scene_start", "targetname");
	
	e_rpg = MagicBullet( "rpg_magic_bullet_sp", s_start_pos.origin, get_struct(s_start_pos.target, "targetname").origin );
	
	while(IsDefined(e_rpg))
	{
		wait(0.05);
	}
		
	self maps\_turret::stop_turret( 4 );
	
	//wait( RandomFloatRange( 0.1, 0.3 ) );	
	
	self veh_magic_bullet_shield( false );
	self notify( "death" );
}

e_02_apache_attack()
{
	//flag_wait( "slums_player_down" );
	
	//trigger_use( "slums_heli_fly" );

	flag_wait( "slums_e_02_start" );
	
	autosave_by_name( "slums_apache" );
		
	// start drone spawning in script
	maps\_drones::drones_start( "slums_apache_drones" );
	
	//-- start critical path spawning
	spawn_manager_enable( "sm_slums_apache_critical_guys" );
	
	
	//flag_wait( "slums_e_02_finish" );
	level waittill("fxanim_gazebo_start");
	wait 5;
	
	s_rpg_start = getstruct( "apache_rpg_start", "targetname" );
	s_rpg_end = getstruct( s_rpg_start.target, "targetname" );
	
	MagicBullet( "rpg_magic_bullet_sp", s_rpg_start.origin, s_rpg_end.origin );
	wait(2);
	
	//notify the apache to unload rockets and retreat
	flag_set( "slums_apache_retreat" );
	
	// stop drone spawning
	maps\_drones::drones_delete( "slums_apache_drones" );
	level notify( "apache_target_stop" );
	
	//make sure to kill off the remaining alive PDF in the structure
	a_pdf = GetEntArray( "apache_target", "script_noteworthy" );
	foreach( e_drone in a_pdf )
	{
		if( IsDefined( e_drone ) )
		{
			e_drone thread drone_doDeath( %fakeshooters::death_stand_dropinplace, "remove_drone_corpses");
			wait RandomFloatRange( 0.5, 1.0 );
		}
	}	
}

e_02_heli_think()
{
	self SetTeam( "allies" );
	self veh_magic_bullet_shield( true );
	self veh_toggle_tread_fx( 0 );
	
	flag_wait( "slums_e_02_helicopter" );
	
	level thread e_02_gazebo_destruction();
	
	a_target_pos = getstructarray( "capitol_hill_target", "targetname" );

	e_target = spawn( "script_origin" , a_target_pos[0].origin );
		
	self set_turret_target( e_target, ( 0, 0, 0 ), 1 );
	self set_turret_target( e_target, ( 0, 0, 0 ), 2 );
	self thread fire_turret_for_time( -1, 1 );
	self thread fire_turret_for_time( -1, 2 );
	
	self SetLookAtEnt( e_target );
	level thread move_gazebo_target( e_target ); //-- moves the targetting struct around
		
	level waittill("fxanim_gazebo_start");
	flag_wait( "slums_apache_retreat" );
	
	//apache is retreating, stop firing turret and unload rockets	
	self ClearLookAtEnt();
	self stop_turret( 1 );
	self stop_turret( 2 );
	
	/*-- TODO: PUT THE ROCKET TURRET BACK IN ONCE THE LITTLEBIRD HAS IT
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
	*/

	e_target Delete();
	
	//stop FX of gazebo destruction
	stop_exploder( 5201 );
	
	s_retreat = getstruct( "slums_apache_retreat", "targetname" );
	self SetVehGoalPos( s_retreat.origin );
	
	wait 4;
	
	s_retreat = getstruct( "slums_apache_retreat_end", "targetname" );
	self SetVehGoalPos( s_retreat.origin );
	
	wait 10;
	
	VEHICLE_DELETE( self );
}

move_gazebo_target( e_target )
{
	a_target_pos = getstructarray( "capitol_hill_target", "targetname" );
	
	while( !flag( "slums_apache_retreat" ) )
	{
		e_target MoveTo( a_target_pos[ RandomInt( a_target_pos.size ) ].origin, 3.0 );		
		e_target waittill( "movedone" );
	}
}

e_02_gazebo_destruction()
{
	level thread notify_on_lookat_trigger( "see_gazebo_flank", "blow_gazebo" );
	level thread notify_on_lookat_trigger( "see_gazebo_street", "blow_gazebo" );
	
	//start FX of gazebo destruction
	exploder( 5201 );
	
	level thread gazebo_audio_loop();
	
	level waittill("blow_gazebo");
	
	level notify("fxanim_gazebo_start");
}


gazebo_audio_loop()
{
	
	gaz_sound = spawn ("script_origin", (24465, 28335, 720));
	gaz_sound playloopsound ("fxa_gzbo_loop", 2); 
	gaz_sound thread gazebo_impacts();
	
	level waittill ("blow_gazebo");
	gaz_sound stoploopsound (2.5);
	wait (10);
	gaz_sound delete();

}

gazebo_impacts()
{
	level endon ("blow_gazebo");
	while (1)
	{
		self playsound ("fxa_gzbo_hit_prj");
		wait (RandomFloatRange (.02, .1));
	}
}



e_03_building_destroy()
{
	a_library_destroyed = GetEntArray("jc_library_destroyed", "targetname");
	foreach( e_piece in a_library_destroyed )
	{
		e_piece Hide();
	}
	
	trigger_wait( "sm_slums_building_destroy" );
	
	// start drone spawning in script
	maps\_drones::drones_start( "slums_howitzer_drones" );
	
	trigger_wait( "trigger_slums_building_destroy" );
	
	autosave_by_name( "slums_building" );
	
	s_start = getstruct( "slums_howitzer_start", "targetname" );
	s_end = getstruct( s_start.target, "targetname" );
	MagicBullet( "ac130_howitzer_minigun", s_start.origin, s_end.origin );
	
	//make sure to kill off the remaining alive PDF in the structure
	a_pdf = GetEntArray( "howitzer_target", "script_noteworthy" );
	foreach( e_drone in a_pdf )
	{
		e_drone thread drone_fakeDeath( true );
	}	
	
	exploder( 550 );
	
	level notify( "fxanim_library_start" );
	
	foreach( e_piece in a_library_destroyed )
	{
		e_piece Show();
	}
	a_library_pristine = GetEntArray("jc_library_intact", "targetname");
	array_delete(a_library_pristine);
	
}

e_04_apc_wall_crash()
{
	//Shabs - buildings been moved, have to find a place for this guy or get rid of him.
	//level thread e_04_rooftop_ambience();
	
	trigger_wait( "slums_e4_start" );
	
	autosave_by_name( "slums_crash" );
	level notify( "remove_drone_corpses" );

	s_pos = getstruct( "APC_StoreCrash", "targetname" );
	e_sound = spawn( "script_origin" , s_pos.origin );
	
	level notify( "fxanim_laundromat_wall_start" );
	e_sound PlaySound( "evt_apc_wall_crash" );
	run_scene( "slums_apc_wall_crash" );
	
	//TODO: MAKE THIS FIRE AT RETREATING DIGBATS (not supposed to move)
	/*	
	vh_apc = GetEnt( "slums_apc_building", "targetname" );
	nd_path = GetVehicleNode( "slums_apc_building_path", "targetname" );
	
	vh_apc maps\_vehicle::getonpath( nd_path );
	vh_apc maps\_vehicle::gopath();
	*/
	
	e_sound Delete();
}

//spawns 3 digbats that run across the rooftops
//e_04_rooftop_ambience()
//{
//	trigger_wait( "rooftop_ambience_end_trigger" );
//	
//	sp_enemy = GetEnt( "slums_rooftop_ambience_end", "targetname" );
//	
//	e_enemy = sp_enemy spawn_ai( true );
//	nd_goal = GetNode( "rooftop_ambience_end_goal", "targetname" );
//	e_enemy thread force_goal( nd_goal );
//	
//	wait 3;
//	e_enemy = sp_enemy spawn_ai( true );
//	nd_goal = GetNode( "rooftop_ambience_end_delete_goal", "targetname" );
//	
//	wait 0.05;
//	e_enemy force_goal( nd_goal, 32 );
//	e_enemy die();
//
//}

e_07_mg_nest()
{
//	sp_allies = GetEnt( "slums_mg_nest_allies", "targetname" );
//	sp_allies add_spawn_function( ::magic_bullet_shield );

	//TODO: place wait here until army push pdf back
	flag_wait( "army_street_push" );
	
	//spawn_manager_enable( "sm_slums_allies_5_7" );
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
	
	e_turret set_turret_ignore_ent_array( array( level.player, level.mason, level.noriega4 ) );
	
	flag_wait( "slums_nest_engage" );
	
	level thread e_07_rooftop_ambience();
	
	e_turret set_turret_ignore_ent_array( array( level.mason, level.noriega ) );
	
	a_friendlies = GetEntArray( "slums_mg_nest_allies_ai", "targetname" );
	foreach( ai in a_friendlies )
	{
		ai stop_magic_bullet_shield();
	}
	
	//spawn_manager_kill( "sm_slums_allies_5_7" );
	spawn_manager_kill( "sm_slums_axis_5_7" );
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
	
//	spawn_manager_enable( "sm_slums_axis_5_11" );
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

//e_12_building_fire()
//{
//	t_fire_damage = GetEnt( "e_14_fire_damage", "targetname" );
//	t_fire_damage trigger_off();
//	
//	trigger_wait( "e_12_building_fire" );
//	
//	level thread run_scene( "slums_burning_building" );
//	
//	//set with a notetrack in the animation
//	flag_wait( "slums_start_building_fire" );
//	
//	//fire fx
//	exploder( 520 );
//	
//	//fire damage
//	t_fire_damage trigger_on();
//
//}

e_13_apc_passenger_think()
{
	self endon( "death" );
	
	self thread magic_bullet_shield();
	e_goal_volume = GetEnt( "slums_apc_drop_goal", "targetname" );
	self.fixednode = false;
	self SetGoalVolumeAuto( e_goal_volume );	
	
	self waittill( "exit_vehicle" );
	
	self FindBestCoverNode();
	
	self delay_thread( 60, ::stop_magic_bullet_shield );
}

//SOUND - Shawn J
apc_announcements( vehicle )
{
	vehicle endon( "death" );
	vehicle endon( "delete" );
	
	wait 1;
	
	if( isdefined( vehicle.model ) && vehicle.model == "veh_t6_mil_m113" )
	{
		while(isdefined( vehicle ))
		{
			wait RandomFloatRange( 1, 3 );
			vehicle PlaySound( "blk_announcer_01", "sounddone" );
			vehicle waittill( "sounddone" );
			
			wait RandomFloatRange( 1, 3 );
			vehicle PlaySound( "blk_announcer_02", "sounddone" );
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
	
	//--TODO: FIGURE OUT IF I NEED TO DELETE EITHER OF THESE
	//t_left_apc Delete();
	//t_right_apc Delete();
}

e_15_dumpster_push()
{
	
	//FIXME: you can see the dumpster pop in, but for some reason anim_first_frame breaks the linot with the clip
	m_clip = GetEnt( "slums_dumpster_clip", "targetname" );
	m_dumpster = GetEnt( "slums_dumpster", "targetname" );
	m_clip LinkTo( m_dumpster );
	
	trigger_wait( "slums_e_15_start" );
	
	//SOUND - Shawn J
	PlaySoundAtPosition ("evt_dumpster", (22976, 27216, 452));	
	
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
	
//TODO: delete all of the extra claymore stuff
//	trigger_wait( "slums_claymore_setup" );
//	
//	level thread run_scene_first_frame( "slums_claymore_plant" );
//	
//	wait 0.05;
//	
//	ai_enemy = GetEnt( "slums_claymore_pdf_ai", "targetname" );
//	ai_enemy Attach( "weapon_claymore", "tag_weapon_left" );
//	ai_enemy thread e_16_holding_claymore();
//	
//	trigger_look = trigger_wait( "slums_claymore_start" );
//	trigger_look Delete();
//	run_scene( "slums_claymore_plant" );	
}

//e_16_spawn_claymore( ai_pdf )
//{
//	ai_pdf Detach( "weapon_claymore", "tag_weapon_left" );
//	ai_pdf notify( "claymore_planted" );
//	
//	v_origin = ai_pdf GetTagOrigin( "tag_weapon_left" );
//	v_angles = ai_pdf GetTagAngles( "tag_weapon_left" );
//	m_claymore = spawn_model( "weapon_claymore", v_origin, v_angles );
//	
//	PlayFXOnTag( getfx( "claymore_laser" ), m_claymore, "tag_fx" );
//		
//	m_claymore thread e_16_satchel_damage();
//	m_claymore thread e_16_claymore_detonation();	
//}

//e_16_holding_claymore()
//{
//	self endon( "claymore_planted" );
//	
//	self waittill_any( "death", "damage" );
//	
//	PlayFX( getfx( "claymore_gib" ), self GetTagOrigin( "tag_fx" ) );
//	PlayFX( getfx( "claymore_explode" ), self GetTagOrigin( "tag_fx" ) );
//	RadiusDamage( self GetTagOrigin( "tag_fx" ), 192, 250, 500 );
//}

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
	level endon( "slums_done" );
	
	t_start = GetEnt( "slums_brute_force", "targetname" );
	//t_start SetHintString( &"PANAMA_LIFT_RUBBLE" );
	//t_start SetCursorHint( "HINT_NOICON" );
	t_start trigger_off();
	
	level.player waittill_player_has_brute_force_perk();
	
//	level thread run_scene( "brute_force_introloop" );
//	level thread run_scene_first_frame( "brute_force_props" );
	
	wait 0.5;
	
	run_scene_first_frame("brute_force");
	
//	ai_brute_force = GetEnt( "brute_force_ai", "targetname" );
//	
//	m_strobe_grenade = Spawn( "script_model", ai_brute_force GetTagOrigin("tag_weapon_right") );
//	m_strobe_grenade.angles = ai_brute_force GetTagAngles("tag_weapon_right");
//	m_strobe_grenade SetModel( "t6_wpn_ir_strobe_world" );
//	m_strobe_grenade LinkTo( ai_brute_force, "tag_weapon_right" );
	
	t_start trigger_on();
	set_objective( level.OBJ_INTERACT, t_start, "interact" );
	t_start waittill( "trigger" );
	set_objective( level.OBJ_INTERACT, t_start, "remove" );
	t_start Delete();
	
	level.player set_ignoreme( true );
	
	/*
	level.player thread player_lock_in_position( level.player.origin, level.player GetPlayerAngles() );
	
	//switch to the epipen weapon and play it's bring up animation
	str_old_weapon = level.player GetCurrentWeapon();
	level.player GiveWeapon( "epipen_sp" );
	level.player SwitchToWeapon( "epipen_sp" );
	wait 3.0;
	level.player SwitchToWeapon( str_old_weapon );
	level.player TakeWeapon( "epipen_sp" );
	level.player notify( "unlink_from_ent" );
	
	//wait for player to unlink before running a scene on them
	wait 0.05;
	*/
	
	level thread run_scene("brute_force");
	run_scene( "brute_force_player" );
	//end_scene( "brute_force_introloop" );
	//level thread run_scene( "brute_force_props" );
	//run_scene( "brute_force" );
	//level thread run_scene( "brute_force_outroloop" );
	
	//m_strobe_grenade Delete();
	
	level.player set_ignoreme( false );
	
	level.player GiveWeapon( "irstrobe_dpad_sp" );
	level.player SetActionSlot(4, "weapon", "irstrobe_dpad_sp");
	level.player thread ir_strobe_watch();
	
	level notify ( "slums_soldier_rescued" );
}


//TODO: REMOVE lockbreaker
//e_18_lock_breaker()
//{
//	level endon( "slums_done" );
//	
//	t_start = GetEnt( "slums_lock_breaker", "targetname" );
//	t_start SetHintString( &"PANAMA_PICK_LOCK" );
//	t_start SetCursorHint( "HINT_NOICON" );
//	t_start trigger_off();
//	
//	level.player waittill_player_has_lock_breaker_perk();
//	
//	level thread e_18_lock_breaker_reward();
//	
//	t_start trigger_on();
//	set_objective( level.OBJ_INTERACT, t_start, "interact" );
//	t_start waittill( "trigger" );
//	set_objective( level.OBJ_INTERACT, t_start, "remove" );
//	t_start Delete();
//	
//	run_scene( "lock_breaker" );
//	delete_scene( "lock_breaker" );
//}
//
//e_18_lock_breaker_door( player_body )
//{
//	level.player PlayRumbleOnEntity( "damage_light" );
//	
//	m_door = GetEnt( "lock_breaker_door", "targetname" );
//	m_door_clip = GetEnt( "lock_breaker_door_clip", "targetname" );
//	m_door LinkTo( m_door_clip );
//	m_door_clip RotateYaw( 100, 1, 0.0, 0.5 );
//	m_door_clip waittill("rotatedone");
//	m_door_clip RotateYaw( -5, 0.5, 0.0, 0.2 );
//}
//
//e_18_lock_breaker_reward()
//{
//	trigger_wait( "slums_lock_breaker_reward" );
//	
//	level.player GiveWeapon( "irstrobe_sp" );
//	level.player SetActionSlot(1, "weapon", "irstrobe_sp");
//	level.player thread ir_strobe_watch();
//	
//	level.player GiveWeapon( "nightingale_sp" );
//	level.player SetActionSlot(2, "weapon", "nightingale_sp");
//	level.player thread nightingale_watch();
//	
//	a_grenades = GetEntArray( "lockbreaker_grenades", "targetname" );
//	foreach( m_grenade in a_grenades )
//	{
//		m_grenade Delete();
//	}
//	
//	level notify( "slums_found_weapon_cache" );
//}

//-- this is the digbat just passed the alley apc that gets blown up by the rpg
e_19_molotov_digbat_alley()
{
	//TODO: add proper cleanup
	flag_wait("spawn_balcony_digbat");
	level run_scene_first_frame( "slums_molotov_throw_left_alley" );
		
	trigger_wait("trig_digbat_alley_left", "targetname");
	
	e_digbat = get_ais_from_scene( "slums_molotov_throw_left_alley", "molotov_digbat" );
	
	while(!level.player is_player_looking_at(e_digbat.origin + (0,0,30), 0.9, true))
	{
		wait(0.05);
	}
	
	flag_set("alley_molotov_digbat_animating");
	level thread run_scene( "slums_molotov_throw_left_alley" );
	wait(5);
	flag_clear("alley_molotov_digbat_animating");
	
	
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


//TODO: DELETE TRIGGERS FROM RADIANT
//e_20_scared_couple()
//{
//	trigger_wait( "slums_e_20_start" );
//	
//	level thread run_scene( "slums_scaredcouple_introloop" );
//	
//	trigger_wait( "slums_e_20_look" );
//	
//	run_scene( "slums_scaredcouple_reaction" );
//	level thread run_scene( "slums_scaredcouple_outroloop" );
//}

//commented out rummage to play anim in a new
e_21_store_rummage()
{
	trigger_wait( "slums_e_21_start" );
	
//	level thread run_scene( "slums_apt_rummage_loop" );
	
//	trigger = trigger_wait( "slums_e_21_react" );
//	trigger Delete();
	
//	run_scene( "slums_apt_rummage_react" );		
	
//	delete_scene( "slums_apt_rummage_loop" );
//	delete_scene( "slums_apt_rummage_react" );
}

e_22_woman_beating()
{
	trigger_wait( "slums_e_22_start" );
	
	level thread run_scene( "beating_loop" );
	level thread run_scene( "beating_corpse" );
	
	wait(0.1); //-- wait for everything to spawn
	
	digbat = get_ais_from_scene( "beating_loop", "e_22_digbat" );
	digbat endon("death");
	
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
	
	level thread mn_moveup_after_digbat_parking();
	
	wait 0.5;
	
	for( i = 0; i < 5; i++ )
	{
		MagicBullet( "ak47_sp", s_window_start.origin, s_window_end.origin );
		wait .05;
	}
}

//-- the slums bottleneck (need to kick off some spawn managers not tied to the main triggger)
slums_bottle_neck()
{
	trigger_wait( "sm_slums_bottleneck" );
	
	spawn_manager_enable( "sm_slums_bottleneck_critical" );
	spawn_manager_enable( "sm_slums_bottleneck_left" );
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
	
	str_weapon = "ak47_sp";
	if( IsDefined( s_start.script_noteworthy ) && s_start.script_noteworthy == "ally" )
	{
		str_weapon = "m16_sp";	
	}
	
	for( i = 0; i < 10; i++ )
	{
		MagicBullet( str_weapon, v_start, v_end );
		wait 0.05;
	}
}

ambient_alley_dog()
{
	level endon( "slums_done" );
	
	t_scare = trigger_wait( "slums_dog_scare" );
	
	a_dogs = GetEntArray( "slums_dog", "script_noteworthy" );
	
	nd_delete = GetNode( "slums_dog_goal", "targetname" );
	
	foreach( ai_dog in a_dogs )
	{
		if(IsAlive(ai_dog))
		{
			ai_dog thread ambient_alley_dog_retreat( nd_delete );
			wait RandomFloatRange( 1.0, 3.0 );
		}
	}
	
	t_scare Delete();
}

ambient_alley_dog_retreat( nd_delete )
{
	self endon( "death" );
	
	self.goalradius = 32;
	self SetGoalPos( nd_delete.origin );
	self waittill( "goal" );
	
	self Delete();
}


dog_that_runs_on_slum_entrance()
{
	trigger_wait("trig_slums_start_dog", "targetname");
	
	start_struct = getstruct( "dog_starting_struct", "targetname" );
	e_dog_spawner = GetEnt( "dog_random_spawner", "targetname" );
	
	//-- spawn_dog
	e_dog_spawner.origin = start_struct.origin;
	e_dog_spawner.angles = start_struct.angles;
	e_dog_spawner.count = 100;
	e_dog = simple_spawn_single( e_dog_spawner );
	e_dog.ignoreme = true;
	e_dog.ignoreall = true;
	e_dog.goalradius = 64;
	
	e_dog endon("death"); //ENDON
	
	end_struct = getstruct( start_struct.target, "targetname" );
	
	e_dog SetGoalPos( end_struct.origin );
	e_dog waittill("goal");
	e_dog Delete();
}

//-- dog running through the slums occasionally
ambient_slums_dog_init()
{
	a_dog_triggers = GetEntArray( "trig_run_a_dog", "script_noteworthy" );
	array_thread( a_dog_triggers, ::ambient_slums_dog );
	
}

//-- self == dog_trigger
ambient_slums_dog()
{
	self waittill( "trigger" ); //-- start dog trigger
	
	start_struct = getstruct( self.target, "targetname" );
	end_struct = getstruct( start_struct.target, "targetname" );
	e_dog_spawner = GetEnt( "dog_random_spawner", "targetname" );
	
	//-- spawn_dog
	e_dog_spawner.origin = start_struct.origin;
	e_dog_spawner.angles = start_struct.angles;
	e_dog_spawner.count = 100;
	e_dog = simple_spawn_single( e_dog_spawner );
	e_dog.ignoreme = true;
	e_dog.ignoreall = true;
	e_dog.goalradius = 64;
	
	while( IsDefined(end_struct) )
	{
		e_dog SetGoalPos( end_struct.origin );
		e_dog waittill("goal");
		
		if(IsDefined(end_struct.target))
		{
			end_struct = getstruct(end_struct.target, "targetname");
		}
		else
		{
			end_struct = undefined;	
		}
	}	
	
	e_dog Delete();
}

/*
 * 
 * 
 *  FUNCTIONS THAT TRACK MASON/NORIEGA AND PLAYER POSITION TO TURN-OFF / CLEANUP EVENTS THAT SHOULD NO LONGER HAPPEN
 * 
 * 
 * 
 */

cleanup_slums_think()
{
	level thread cleanup_progression_passed_digbat_parking_lot();
	level thread cleanup_initial_mgnest_through_digbat_parking_lot();
}

cleanup_slums_ai_by_targetname( str_targetname )
{
	a_guys = GetEntArray( str_targetname, "targetname" );
	
	foreach( e_guy in a_guys )
	{
		//e_guy thread bloody_death();
		e_guy Delete();
	}
}

//-- If mason/noriega make it all the way passed the digbat parking lot, then all the stuff on the left side, up until you get passed the APC are invalidated
cleanup_progression_passed_digbat_parking_lot()
{
	flag_wait( "cleanup_before_digbat_parking_lot" );
	
	/* Cleans Up:
	 * - mn_warp_move_around_parking_lot
	 * - blows up the APC
	 * - kills sm_apc_alley_digbats spawn manager
	 * - cleanup the apc_alley_army
	 * - cleanup ai from the sm_apc_alley_digbats_spawnmanager
	*/
	
	//cleanup warp
	level notify("cleanup_warp_around_parking_lot");
	t_for_warp = GetEnt("trig_player_moving_around_parking_lot", "targetname");
	t_for_warp Delete();
	
	//blowup the apc
	flag_set( "spawn_balcony_digbat" );
	trigger_use("send_apc_rpg", "targetname");
	
	//disable spawn manager and kill the guys
	spawn_manager_kill( "sm_apc_alley_digbats" );
		
	wait(0.05); //-- break up the work, plus let other stuff kill the magic bullet shield on these guys
	
	level notify("kill_e_01_apc_digbat_alley");
	
	// cleanup the apc_alley_army
	a_guys = GetEntArray( "apc_alley_army_ai", "targetname" );
	array_thread(a_guys, ::bloody_death);
	
	wait(0.05);
	
	a_guys = get_ai_from_spawn_manager("sm_apc_alley_digbats");
	array_thread(a_guys, ::bloody_death);
	
	cleanup_slums_ai_by_targetname( "sm_apc_alley_digbats_ai" );
	cleanup_slums_ai_by_targetname( "slums_mg_nest_allies_ai" );
}

//-- cleanup the right side if the player goes to the left
cleanup_initial_mgnest_through_digbat_parking_lot()
{
	/* Cleans Up:
	 * - mgnest ais and spawn managers
	 * - rooftop and windows alley spawn managers
	 * - slums_axis_5_7
	 * - sm_slums_initial_retreat
	 * - digbat_parking
	 * - TODO flagset / army_street_push - does this spawn people?
	 * - delete targetname / slums_e_23_start (digbat van and charger)
	 * - cleanup the AI from the spawn managers
	 * - TODO clean up allies
	 */
	
	trigger_wait("trig_warp_passed_apc", "targetname");
	t_for_warp = GetEnt("trig_player_moving_around_parking_lot", "targetname");
	t_for_warp Delete();
	
	//cleanup warp
	level endon("cleanup_warp_around_parking_lot");
	
	level notify("kill_e_01_apc_digbat_alley");
	cleanup_slums_ai_by_targetname( "apc_alley_army_ai" );
	
	trig_digbat_parking_lot = GetEnt("slums_e_23_start", "targetname");
	if (IsDefined(trig_digbat_parking_lot) )
	{
		trig_digbat_parking_lot Delete();
	}
	
	a_spawn_managers = Array("sm_slums_axis_mgnest",
	                         "sm_slums_axis_pre_mgnest",
	                         "sm_rooftop_and_windows_alley",
	                         "sm_slums_axis_5_7",
	                         "sm_slums_initial_retreat",
	                         "sm_digbat_parking" );
	
	foreach ( str_sm in a_spawn_managers )
	{
		spawn_manager_kill( str_sm, true );
		
		wait(0.05);
	}
	
	foreach ( str_sm in a_spawn_managers )
	{
		a_guys = get_ai_from_spawn_manager( str_sm );
		//array_thread( a_guys, ::bloody_death );
		
		foreach( e_guy in a_guys )
		{
			e_guy Delete();
		}
		
		wait(0.05);
	}
	
	/* -- don't think these actually need to be deleted
	foreach ( str_sm in a_spawn_managers )
	{
		e_sm = GetEnt( str_sm, "targetname" );
		if( IsDefined( e_sm ) )
		{
			e_sm Delete();
		}
		
		wait(0.05);
	}
	*/
}



/*----------------------------------------------------------------------------------------------------------------------------
 * 
 * 
 *  FUNCTIONS THAT HANDLE MASON AND NOREIGA MOVING UP BASED ON KILLS/SIDEPATHS/EVERYTHING NON-PLAYER PLAYING EXACTLY CORRECT
 * 
 * 
 * 
 -----------------------------------------------------------------------------------------------------------------------------*/

slums_paired_movement()
{
	//TODO: pull out the color chains entirely, though they are useful for now
	level.mason disable_ai_color();
	level.noriega disable_ai_color();
	
	//-- ALWAYS NEED TO USE GETNODEARRAY FOR THE PAIRED MOVEMENT
	nd_noriega_start = GetNodeArray("node_noriega_path_start", "targetname");
	nd_mason_start = GetNodeArray("node_mason_path_start", "targetname");
	
	trigger_wait("trig_slums_start"); //-- this is an old color chain trigger
	
	level.mason thread slums_go_to_node_using_funcs( nd_mason_start );
	level.noriega thread slums_go_to_node_using_funcs( nd_noriega_start );
	
	level thread move_up_script_logic();
	
	level thread cleanup_slums_think();
}

move_up_script_logic()
{
	//-- CRITICAL PATH
	//-- threaded in the order they play out if the player
	level thread mn_moveup_after_mg_nest(); //van to dumpster
	level thread mn_moveup_from_dumpster_to_wall(); //dumpster to wall
	level thread mn_moveup_to_digbat_parking();
	//level thread mn_moveup_after_digbat_parking(); - digbat parking lot relies on the scene to be played first
	level thread mn_moveup_after_apache_attack(); //move up to the bench at the dome
	level thread mn_move_along_cafe_wall();
	level thread mn_moveup_into_bottleneck_right();
	level thread mn_moveup_to_library();
	level thread mn_move_passed_the_library();
	//-- after this moment they basically just sprint all the way to the end
	
	//-- WARPS
	level thread mn_warp_move_around_parking_lot(); //-- if they went left, passed the apc, then turned right and took the alley headed towards the digbat parking lot
	level thread mn_warp_straight_passed_apc(); //-- if they went left, passed the apc, and continued on straight
	level thread mn_warp_upper_left_corner(); //-- player went all the way to the left, the whole time
	level thread mn_warp_before_digbat_beatdown(); //-- the player went all the way to the left the whole time
	level thread mn_warp_after_intruder_hallway(); //-- player went through the intruder hallway
	level thread mw_warp_end_failsafe(); //-- in case the player got way ahead of them and made it to the end //TODO: pull this out?
	
	//-- cut
	//level thread mn_move_from_bottleneck_to_bottom_of_stairs(); 
	
}


//-- used to move mason/noriega to the magic moments spots
warp_me_in_slums_logic( str_start_node )
{
	self notify( "stop_going_to_node_slums" );
	
	//-- see if this speeds up their ability to run in
	self.disableExits		  = true;
	self.disableArrivals	  = true;
	
	if(IsDefined( self.slums_current_scene ))
	{
		end_scene(self.slums_current_scene);
	}
	
	nd_warp_point = GetNode( str_start_node, "targetname" );
	self ForceTeleport( nd_warp_point.origin, nd_warp_point.angles );
	
	nd_start_point = GetNodeArray( nd_warp_point.target, "targetname" );
	self thread slums_go_to_node_using_funcs( nd_start_point );
}

//-- needs the first node
slums_go_to_node_using_funcs( node, get_target_func = ::slums_get_target_nodes, set_goal_func_quits = maps\_spawner::go_to_node_set_goal_node, require_player_dist )
{
	// AI is moving to a goal node
	self endon( "stop_going_to_node_slums" );
	self endon( "death" );
	
	for ( ;; )
	{
		// node should always be an array at this point, so lets get just 1 out of the array
		node = get_least_used_from_array( node );

		player_wait_dist = require_player_dist;
		if( isdefined( node.script_requires_player ) )
		{
			if( node.script_requires_player > 1 )
				player_wait_dist = node.script_requires_player;
			else
				player_wait_dist = 256;
		
			node.script_requires_player = false;
		}

		//TODO: figure out if we actually want/need this
		//self set_goalradius_based_on_settings( node );
	
		if(node.type == "Path" || (IsDefined(node.script_string) && node.script_string == "anim_waitscene"))
		{
			//-- goal radius is so small that we want to avoid the AI playing their arrival animation
			self.disableArrivals = true;	
		}
		else
		{
			self.disableExits = false;
			self.disableArrivals = false;
		}
		
		if( IsDefined(node.script_radius) )
		{
			self.goalradius = node.radius;	
		}
		else
		{
			self.goalradius = 32;	
		}
		
		if(!IsDefined(self.slum_state) || self.slum_state != "moving" )
		{
			self set_slums_moving_ai_params();
		}
		
		//-- pretty much only used for ignore_me, but could be used for all sorts of stuff
		
		if(IsDefined(node.script_string))
		{
			/* FIXME: fix these, was improperly using self instead of node
			if( node.script_string == "ignore_me" )
			{
				node set_ignoreme( true );
			}
			
			if( node.script_string == "run" )
			{
				node change_movemode( "run" );
			}
			
			if( node.script_string == "sprint" )
			{
				if(node == level.mason)
				{
					self change_movemode( "cqb_sprint" );
				}
				else
				{
					self change_movemode( "sprint" );
				}
			}
			*/
			
			if(IsSubStr( node.script_string, "notify"))
			{
				a_str = StrTok(node.script_string, "_");
				level notify(a_str[1]);
			}
		}
		
		//-- wrap these because some nodes need to kick off their animation right away
		if(!IsDefined( node.script_waittill ) || node.script_waittill != "none" )
		{
			[[ set_goal_func_quits ]]( node );
		
			self waittill( "goal" );
		}
		
		if(node.type != "Path")
		{
			self set_slums_at_cover_ai_params();
			
			if(self == level.mason)
			{
				level thread autosave_by_name( "autosave_" + node.targetname );
			}
		}

		if( IsDefined( node.script_string ) )
		{
			a_string_tokens = StrTok( node.script_string, "_" );
			
			if( a_string_tokens[0] == "anim" )
			{
				//-- it's an animation so run the scene	
				if( a_string_tokens[1] == "waitscene" )
				{
					if( flag("slum_scene_waiting" ))
					{
						self SetGoalNode( GetNode( node.target, "targetname" ) );
						flag_clear("slum_scene_waiting");
						wait(0.1);
					}
					else
					{
						flag_set("slum_scene_waiting");
						flag_waitopen("slum_scene_waiting");
					}
				}
				else if( a_string_tokens[1] == "coverwall" )
				{
					if(self == level.mason)
					{
						level.noriega notify("stop_going_to_node_slums");
					}
					else
					{
						level.mason notify( "stop_going_to_node_slums" );
					}
					
					level.noriega.slums_current_scene = "slums_critical_path_along_the_wall";
					level.mason.slums_current_scene = "slums_critical_path_along_the_wall";
					level thread run_scene("slums_critical_path_along_the_wall_mason");
					run_scene("slums_critical_path_along_the_wall_noriega");
					level.noriega.slums_current_scene = undefined;
					level.mason.slums_current_scene = undefined;
					
					if(self == level.mason)
					{
						nd_start_point = GetNodeArray( "nd_start_after_wall_noriega", "targetname" );
						level.noriega thread slums_go_to_node_using_funcs( nd_start_point );
					}
					else
					{
						nd_start_point = GetNodeArray( "nd_start_after_wall_mason", "targetname" );
						level.mason thread slums_go_to_node_using_funcs( nd_start_point );	
					}									
				}
				else if( a_string_tokens[1] == "coverstairs" )
				{
					if(self == level.mason)
					{
						level.noriega notify("stop_going_to_node_slums");

					}
					else
					{
						level.mason notify( "stop_going_to_node_slums" );

					}
					
					level.noriega.slums_current_scene = "slums_critical_path_before_library";
					level.mason.slums_current_scene = "slums_critical_path_before_library";
					run_scene("slums_critical_path_before_library");
					level.noriega.slums_current_scene = undefined;
					level.mason.slums_current_scene = undefined;
					
					if(self == level.mason)
					{
						nd_start_point = GetNodeArray( "nd_noriega_start_after_stair_cover", "targetname" );
						level.noriega thread slums_go_to_node_using_funcs( nd_start_point );
					}
					else
					{
						nd_start_point = GetNodeArray( "nd_mason_start_after_stair_cover", "targetname" );
						level.mason thread slums_go_to_node_using_funcs( nd_start_point );	
					}
				}
				else if( a_string_tokens[1] == "behindcar" )
				{
					if(self == level.mason)
					{
						level.noriega notify("stop_going_to_node_slums");
					}
					else
					{
						level.mason notify( "stop_going_to_node_slums" );
					}
					
					/#iprintln("animating at car");#/
					level.noriega.slums_current_scene = "slums_critical_path_first_car";
					level.mason.slums_current_scene = "slums_critical_path_first_car";
					run_scene("slums_critical_path_first_car");
					//level thread run_scene("slums_critical_path_first_car_idle"); //TODO: currently run this with no idle to speed it up
					run_scene("slums_critical_path_first_car_exit");
					level.noriega.slums_current_scene = undefined;
					level.mason.slums_current_scene = undefined;
					/#iprintln("done animating at car");#/
				
					if(self == level.mason)
					{
						nd_start_point = GetNodeArray( "nd_start_after_car_noriega", "targetname" );
						level.noriega thread slums_go_to_node_using_funcs( nd_start_point );
					}
					else
					{
						nd_start_point = GetNodeArray( "nd_start_after_car_mason", "targetname" );
						level.mason thread slums_go_to_node_using_funcs( nd_start_point );	
					}				
				}
				else if( a_string_tokens[1] == "gobarrels" )
				{
					if(self == level.mason)
					{
						level.noriega notify("stop_going_to_node_slums");
					}
					else
					{
						level.mason notify( "stop_going_to_node_slums" );
					}
					
					level.noriega.slums_current_scene = "slums_critical_path_to_barrels_from_wall";
					level.mason.slums_current_scene = "slums_critical_path_to_barrels_from_wall";
					level thread run_scene("slums_critical_path_to_barrels_from_wall_noriega");
					run_scene("slums_critical_path_to_barrels_from_wall_mason");
					level.noriega.slums_current_scene = undefined;
					level.mason.slums_current_scene = undefined;
					
					if(self == level.mason)
					{
						nd_start_point = GetNodeArray( "nd_start_after_barrels_noriega", "targetname" );
						level.noriega thread slums_go_to_node_using_funcs( nd_start_point );
					}
					else
					{
						nd_start_point = GetNodeArray( "nd_start_after_barrels_mason", "targetname" );
						level.mason thread slums_go_to_node_using_funcs( nd_start_point );	
					}									
				}
			}
		}
		
		if ( IsDefined( node.script_flag_set ) )
		{
			flag_set( node.script_flag_set );
		}
	
		if ( IsDefined( node.script_flag_clear ) )
		{
			flag_set( node.script_flag_clear );
		}
			
		if ( IsDefined( node.script_flag_wait ) )
		{	
			if(IsDefined(node.script_timer))
			{
				//-- A WAY TO SET A TIME AND THEN MOVE TO A NEW NODE (need this to make sure that Mason reached his node as well)
				wait( node.script_timer);
				flag_set( node.script_flag_wait );
			}
			
			flag_wait( node.script_flag_wait );
		
			if(self == level.mason)
			{
				//-- Mason moves slightly after Noriega since he is leading us through the slums
				flag_wait( "noriega_moved_now_move_mason" );
				flag_clear( "noriega_moved_now_move_mason" );
			}
			
			if(self == level.noriega)
			{
				//-- move mason after a pause
				delay_thread( 1.0 , ::flag_set, "noriega_moved_now_move_mason");
			}
		}
		else if ( IsDefined( node.script_timer ) )
		{
			wait(node.script_timer);
		}

		if( IsDefined( node.script_aigroup ) )
		{
			waittill_ai_group_cleared(  node.script_aigroup  );
		}

		if ( !IsDefined( node.target ) )
		{
			break;
		}

		nextNode_array = [[ get_target_func ]]( node.target );
		if ( !nextNode_array.size )
		{
			break;
		}

		node = nextNode_array;
	}


	self notify( "reached_path_end" );
}

/#
get_animation_endings()
{
	//print_out_end_location_of_animation( level.scr_anim["mason"]["slums_critical_path_along_the_wall"], "anim_moment_3", "mason" );
	//print_out_end_location_of_animation( level.scr_anim["noriega"]["slums_critical_path_along_the_wall"], "anim_moment_3", "noriega" );
}
	
print_out_end_location_of_animation( _anim, str_align_node, animname )
{
	align_node = GetStruct( str_align_node, "targetname" );
	start_org = GetStartOrigin( align_node.origin, (0,0,0), _anim );
	start_ang = GetStartAngles( align_node.origin, (0,0,0), _anim );
	
	endpoint = start_org;
	
	IPrintLn( animname + " anim starts at: " + endpoint[0] + " " + endpoint[1] + " " + endpoint[2] );
	
	temp_ent = spawn( "script_origin", start_org );
	temp_ent.angles = start_ang;
	
	localDeltaVector = getMoveDelta( _anim, 0, 1 );
    endPoint = temp_ent localToWorldCoords( localDeltaVector );
	
    IPrintLn( animname + " anim ends at: " + endpoint[0] + " " + endpoint[1] + " " + endpoint[2] );
}
#/

//-- the AI params for being at cover
set_slums_at_cover_ai_params()
{
	//-- MASON SPECIFIC
	if(self == level.mason)
	{
		self set_ignoreall( false );
		self.disable_blindfire = true;
	}
	
	//-- NORIEGA SPECIFIC
	if(self == level.noriega)
	{
		self.a.coverIdleOnly = true;
	}
	
	//-- GENERAL CASE
	self set_ignoresuppression( false );
	self enable_pain();
	self enable_react();
	self change_movemode( "run" );
	self.slum_state = "cover";
}

//-- the AI params for moving between cover
set_slums_moving_ai_params()
{
	if(self == level.mason)
	{
		self change_movemode( "cqb_sprint" );
	}
	else if( self == level.noriega )
	{
		self change_movemode( "run" );	
	}
	
	self set_ignoreall(true);
	self set_ignoresuppression(true);
	self disable_pain();
	self disable_react();
	self.nododgemove = true;
	self.slum_state = "moving";
}

//-- This is what always got passed into _spawner version of slums_go_to_node_using_funcs
slums_get_target_nodes( target )
{
	return getnodearray( target, "targetname" );
}

//-- move from the van to the dumpster
mn_moveup_after_mg_nest()
{
	level endon("cleanup_player_committed_left");
	
	waittill_spawn_manager_cleared( "sm_slums_axis_mgnest" );
		
	while(is_spawn_manager_enabled( "sm_slums_axis_pre_mgnest" ))
	{
		wait(0.15);
	}
	
	flag_set( "mv_noriega_to_dumpster" );
}

//-- dumpster to the alley with the molotovs and snipers
mn_moveup_from_dumpster_to_wall()
{
	level endon("cleanup_player_committed_left");
	
	trig = GetEnt("trig_mv_noriega_to_wall_alley", "targetname");
	trig endon("trigger");
	
	waittill_spawn_manager_complete("sm_slums_initial_retreat");
		
	trigger_use( "trig_mv_noriega_to_wall_alley" );
}

//-- move from the wall to the digbat parking lot
mn_moveup_to_digbat_parking()
{
	level endon("cleanup_player_committed_left");
	
	waittill_spawn_manager_cleared( "sm_slums_initial_retreat" );
	waittill_spawn_manager_cleared( "sm_rooftop_and_windows_alley" );
	
	flag_set( "mv_noriega to_parking_lot" );
}

//4 guys - 2 that come in from left, 1 that jumps out window, 1 that jumps onto the top of the van
mn_moveup_after_digbat_parking()
{
	level endon("cleanup_player_committed_left");
	
	wait(0.15);//-- Give the scenes a chance to run
	
	trig_next_color = GetEnt("trig_color_after_db_park", "targetname");
	trig_next_color endon("trigger");
	
	e_digbat_1 = get_ais_from_scene( "parking_jump", "slums_park_digbat_01" );
	e_digbat_2 = get_ais_from_scene( "parking_window", "slums_park_digbat_02" );
	
	waittill_spawn_manager_cleared( "sm_digbat_parking" );
	
	while(IsAlive(e_digbat_1) || IsAlive(e_digbat_2))
	{
		wait(0.15);
	}
	
	flag_set("cleanup_before_digbat_parking_lot");
	trigger_use( "trig_color_after_db_park", "targetname" );
}

//-- 2 guys, move up to the bench next to the dome
mn_moveup_after_apache_attack()
{
	waittill_spawn_manager_cleared( "sm_slums_apache_critical_guys"	);
	flag_set( "mv_noriega_to_gazebo" );
}

//-- this one might become a scene
mn_move_along_cafe_wall()
{	
	//TODO: repurpose or delete this function
	//waittill_spawn_manager_cleared( "sm_slums_bottleneck_critical" );
	//flag_set( "mv_noriega_just_before_stairs" );
}

//-- this one moves then halfway up the right bottleneck
mn_moveup_into_bottleneck_right()
{
	waittill_spawn_manager_cleared("sm_slums_bottleneck");
	flag_set("mv_noriega_slums_right_bottleneck");
}

mn_moveup_to_library()
{
	waittill_spawn_manager_cleared( "sm_bottleneck_right_rear" );
	flag_set("mv_noriega_slums_right_bottleneck_complete");
}

mn_move_passed_the_library()
{
	level waittill( "fxanim_library_start" );
	wait( 10 );
	flag_set("mv_noriega_move_passed_library");
}

/*
mn_move_from_bottleneck_to_bottom_of_stairs()
{
	waittill_spawn_manager_cleared( "sm_slums_bottleneck_left" );
	flag_set( "mv_noriega_slums_left_bottleneck" );
}
*/


// WARPING FUNCTIONS
mn_warp_move_around_parking_lot()
{
	level endon("cleanup_warp_around_parking_lot");
	
	trigger_wait("trig_player_moving_around_parking_lot", "targetname");
	
	level notify("cleanup_player_committed_left"); //cleanup all of the functions that move mason and noriega up through the digbat parking lot
	
	level.mason thread warp_me_in_slums_logic( "nd_mason_start_around_parking" );
	level.noriega thread warp_me_in_slums_logic( "nd_noriega_start_around_parking" );
}

mn_warp_straight_passed_apc()
{
	trigger_wait("trig_warp_passed_apc", "targetname");
	
	if(flag("alley_molotov_digbat_animating"))
	{
		flag_waitopen("alley_molotov_digbat_animating");
	}
	
	level.mason thread warp_me_in_slums_logic( "nd_mason_start_straight_past_apc" );
	level.noriega thread warp_me_in_slums_logic( "nd_noriega_start_straight_past_apc" );
}

mn_warp_upper_left_corner() //-- player went all the way down the left side (you can't get farther from the critical path
{
	trigger_wait("trig_player_upper_left_corner", "targetname" );
	
	level.mason thread warp_me_in_slums_logic( "nd_mason_start_left_corner" );
	level.noriega thread warp_me_in_slums_logic( "nd_noriega_start_left_corner" );
}

mn_warp_before_digbat_beatdown()
{
	trigger_wait("trig_warp_before_beatdown", "targetname");
		
	level.mason thread warp_me_in_slums_logic( "nd_mason_start_before_beatdown" );
	level.noriega thread warp_me_in_slums_logic( "nd_noriega_start_before_beatdown" );
}

mn_warp_after_intruder_hallway()
{

	trigger_wait("trig_warp_for_intruder", "targetname");
		
	level.mason thread warp_me_in_slums_logic( "nd_mason_start_intruder_hallway" );
	level.noriega thread warp_me_in_slums_logic( "nd_noriega_start_intruder_hallway" );
}

mw_warp_end_failsafe()
{
	level endon("stopfailsafe"); //-- notified by radiant
	
	trigger_wait("warp_trig_failsafe_end", "targetname");
	
	/#iprintln("Do failsafe warp here");#/
		
	//-- start from the furthest out node from the last cover point and then walk in until we find the best place to warp mason and noriega to
	mason_node = GetNode( "nd_mason_failsafe", "targetname" );
	noriega_node = GetNode( "nd_noriega_failsafe", "targetname" );
	
	safe_to_warp = true;
	
	while(safe_to_warp)
	{
		temp_node = undefined;
		
		if(IsDefined( mason_node.target ))
		{
			temp_node = GetNode( mason_node.target, "targetname" );
			
			if(!level.player is_player_looking_at(temp_node.origin + (0,0,30), 0.6, true))
			{
				mason_node = temp_node;	
			}
			else
			{
				safe_to_warp = false;
			}
		}
		else
		{
			safe_to_warp = false;	
		}
	}
	
	level.mason thread warp_me_in_slums_logic( mason_node.targetname );
	
	safe_to_warp = true;
	
	while(safe_to_warp)
	{
		temp_node = undefined;
		
		if(IsDefined( noriega_node.target ))
		{
			temp_node = GetNode( noriega_node.target, "targetname" );
			
			if(!level.player is_player_looking_at(temp_node.origin + (0,0,30), 0.6, true))
			{
				noriega_node = temp_node;	
			}
			else
			{
				safe_to_warp = false;
			}
		}
		else
		{
			safe_to_warp = false;	
		}
	}
	
	level.noriega thread warp_me_in_slums_logic( noriega_node.targetname );
	
}

#using_animtree ("animated_props");

//VEHICLE ANIMATIONS
veh_animate_pickup_trucks()
{
	a_trucks = GetEntArray( "anim_truck_hood", "targetname" );
	
	foreach( e_truck in a_trucks )
	{
		e_truck UseAnimTree(#animtree);
		e_truck.animname = "anim_truck_hood";
		e_truck maps\_anim::anim_first_frame( e_truck, "truck_hood_up" );
	}
	
	/#iprintln( "animated " + a_trucks.size + " trucks hoods up");#/
}

veh_animate_pickup_cars()
{
	a_cars = GetEntArray( "anim_car_door", "targetname" );
	
	foreach( e_car in a_cars )
	{
		e_car UseAnimTree(#animtree);
		e_car.animname = "anim_car_door";
		e_car maps\_anim::anim_first_frame( e_car, "car_driver_door_open" );
	}
	
	/#iprintln( "animated " + a_cars.size + " car driver doors open");#/
}