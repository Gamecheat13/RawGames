#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\yemen_utility;
#include maps\_objectives;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	flag_init( "metal_storms_start" );
	flag_init( "metal_storms_fire_building_rocket" );
	flag_init( "metal_storms_entered_street" );
	flag_init( "player_engaged_street_terrorists" );
}


//
//	event-specific spawn functions
init_spawn_funcs()
{
	add_spawn_function_group( "terrorist", "script_noteworthy", maps\yemen_utility::terrorist_teamswitch_spawnfunc );
	add_spawn_function_group( "yemeni", "script_noteworthy", maps\yemen_utility::yemeni_teamswitch_spawnfunc );
	add_spawn_function_group( "street_yemeni", "script_noteworthy", maps\yemen_utility::yemeni_teamswitch_spawnfunc );
	add_spawn_function_group( "street_terrorist", "script_noteworthy", ::street_terrorist_spawnfunc );
	add_spawn_function_group( "courtyard_asd_target", "script_noteworthy", ::courtyard_asd_target_spawnfunc );
		
	add_spawn_function_veh( "courtyard_left_metalstorm", ::courtyard_left_metalstorm_think );
	add_spawn_function_veh( "courtyard_right_metalstorm", ::courtyard_right_metalstorm_think );
	add_spawn_function_veh( "street_metalstorm_1", ::street_metalstorm_think, 1 );
	add_spawn_function_veh( "street_metalstorm_2", ::street_metalstorm_think, 2 );
	add_spawn_function_veh( "courtyard_vtol", ::courtyard_vtol_think );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_metal_storms()
{	
	skipto_teleport( "skipto_metal_storms_player" );
	
	level.friendlyFireDisabled = true;
	level.player SetThreatBiasGroup( "player" );	
	
	maps\_vehicle::vehicle_add_main_callback( "heli_quadrotor", maps\yemen_utility::yemen_quadrotor_indicator );
	
	level thread maps\yemen::meet_menendez_objectives();
}

/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
/#
	IPrintLn( "Metal Storms" );
#/
	flag_set( "metal_storms_start" );	
		
	init_spawn_funcs();
	
	maps\_vehicle::vehicle_add_main_callback( "drone_firestorm", maps\yemen_utility::yemen_metalstorm_indicator );
	maps\_vehicle::vehicle_add_main_callback( "drone_metalstorm", maps\yemen_utility::yemen_metalstorm_indicator );	
	
	// Spawn AI on the second floor in the courtyard
	simple_spawn( "courtyard_floor2_guys", ::courtyard_floor2_spawnfunc );
	
	// due to the AI placement, changing the threat bias
	// SetThreatBias( "player", "yemeni", 2000 );
	
	level thread maps\yemen_amb::yemen_drone_control_tones( true );
	level thread street_terrorist_count_watch();
	level thread street_balcony_runners();
	level thread street_advancers();
	
	level thread courtyard_trigger_watcher_left();
	level thread courtyard_trigger_watcher_right();
	
	level thread intruder_turret();
	level thread metal_storms_intruder();
	
	level thread vo_metal_storms();
	
	trigger_wait( "pre_morals" );
//	level thread vo_pre_morals();
}

vo_metal_storms()
{
	dialog_start_convo( "drones_ahead" );
	level.player priority_dialog( "harp_there_s_another_dron_0" );	//There's another drone swarm dead ahead - divert!
	dialog_end_convo();
}

metal_storms_cleanup()
{	
	cleanup( "street_terrorist", "script_noteworthy" );
	cleanup( "street_yemeni", "script_noteworthy" );	
	cleanup( "street_drone", "script_noteworthy" );
	cleanup( "courtyard_right_metalstorm", "script_noteworthy" );
	cleanup( "courtyard_left_metalstorm", "script_noteworthy" );
}

courtyard_trigger_watcher_left()
{
	trigger_wait( "start_courtyard_metalstorm_left" );	
	trigger_off( "start_courtyard_metalstorm_right" );
	trigger_wait( "courtyard_move_asd_left" );
	trigger_off( "courtyard_move_asd_right" );
}

courtyard_trigger_watcher_right()
{
	trigger_wait( "start_courtyard_metalstorm_right" );	
	trigger_off( "start_courtyard_metalstorm_left" );
	trigger_wait( "courtyard_move_asd_right" );
	trigger_off( "courtyard_move_asd_left" );
}

/* ------------------------------------------------------------------------------------------
	EVENT functions
-------------------------------------------------------------------------------------------*/

courtyard_floor2_spawnfunc()
{
	self endon( "death" );
	
	self thread maps\yemen_utility::terrorist_teamswitch_spawnfunc();
	wait .1;
	self notify( "detected_farid" );
	//self set_ignoreall( true );
	
	level waittill( "courtyard_asd_spawned" );
	veh_asd = level.courtyard_asd;
	self shoot_at_target( veh_asd, "tag_origin", 0.1, -1 );
}

courtyard_asd_target_spawnfunc()
{
	self endon( "death" );
	
	self set_pacifist( true );
	
	//veh_asd = level.courtyard_asd;
	//self shoot_at_target( veh_asd, "tag_origin", 0.1, -1 );
}

courtyard_fire_fake_rocket() //self = asd
{
	level thread maps\yemen_anim::metal_storms_anims();
	
	v_start_point = self GetTagOrigin( "tag_flash" );
	e_target = get_ent( "metalstorm_courtyard_balcony_target" );
	MagicBullet( "rpg_magic_bullet_sp", v_start_point, e_target.origin );
	wait 0.5;
	
	level thread courtyard_explosion_fx();

	level notify( "fxanim_balcony_courtyard_start" );
	playsoundatposition ( "fxa_balcony_courtyard", (-2544, -5521, 327));
	level run_scene( "courtyard_balcony_deaths" );
	
	// TODO: change the ragdolling to notetracks
	a_scene_ai = get_ais_from_scene( "courtyard_balcony_deaths" );	
	a_balcony_ai = GetEntArray( "courtyard_floor2_guys_ai", "targetname" );
	a_scene_and_balcony_ai = ArrayCombine( a_scene_ai, a_balcony_ai, true, false );
	
	foreach ( ai_guy in a_scene_and_balcony_ai )
	{
		ai_guy StartRagdoll();
		ai_guy DoDamage( ai_guy.health + 10, (0,0,0) );
	}	
	
	trigger_use( "courtyard_start_qr_drones" );
}

courtyard_explosion_fx()
{
	s_explosion_point = GetStruct( "courtyard_building_fx", "targetname" );
	s_drama_struct = GetStruct( "courtyard_fx_at_player", "targetname" );	// Struct to play Rocket FX off of (that flies towards the player)
	
	exploder( 410 );
	//	PlayFX( level._effect["balcony_explosion"], s_explosion_point.origin );
	
	// Play this fx so it shoots right in front of where the player is looking
	v_eye_pos = level.player geteye();
	v_player_eye = level.player getPlayerAngles();
	v_player_eye = VectorNormalize( AnglesToForward( v_player_eye ) );
	
	v_trace_to_point = v_eye_pos + ( v_player_eye * 256 );
	a_trace = BulletTrace( v_eye_pos, v_trace_to_point, false, level.player );
	
	v_drama_fx = VectorNormalize( a_trace["position"] - s_drama_struct.origin );
	v_drama_fx = VectorToAngles( v_drama_fx );
	
	m_drama_spot = spawn_model( "tag_origin", s_drama_struct.origin, v_drama_fx );
	
//	level thread draw_debug_line( a_trace["position"], s_drama_struct.origin, 15 );
	
//	PlayFXOnTag( GetFX( "balcony_debris_atplayer" ), m_drama_spot, "tag_origin" );
}

street_balcony_runners()
{
	trigger_wait( "street_balcony_runner_start" );
	
	sp_runners = GetEnt( "street_balcony_runner", "targetname" );
	s_run_spot = GetStruct( "street_balcony_runner_goal", "targetname" );

	level thread street_balcony_take_position();
	
	for( i = 0; i < sp_runners.count; i++ )
	{
		ai_guy = sp_runners spawn_ai( true );
		ai_guy thread street_balcony_run( s_run_spot.origin );
		wait .5;
	}
}

street_balcony_run( v_runto_spot )
{
	level endon( "balcony_runner_alerted" );
	wait .1;
	self.goalradius = 128;
	self set_ignoreall( true );
	self SetGoalPos( v_runto_spot );
	
	self thread street_balcony_damage_listener();
	
	self waittill( "goal" );
	wait .5;
	self Delete();
}

street_balcony_damage_listener()
{
	self waittill_any( "damage", "pain", "bulletwhizby", "balcony_alert" );
	level notify( "balcony_runner_alerted" );
}

street_balcony_take_position()
{
	level waittill( "balcony_runner_alerted" );
	
	a_balcony_runners = GetEntArray( "street_balcony_runner_ai", "targetname" );
	a_balcony_nodes = array_randomize( GetNodeArray( "street_balcony_covernode", "targetname" ) );
	
	for( i = 0; i < a_balcony_runners.size; i++ )
	{
		a_balcony_runners[i] set_ignoreall( false );
		a_balcony_runners[i] SetGoalNode( a_balcony_nodes[i] );
	}
}

street_terrorist_count_watch()
{
	flag_wait( "metal_storms_fire_building_rocket" );	// guys will be spawned by this point
	
	waittill_ai_group_ai_count( "street_terrorist", 2 );
	
	m_door = GetEnt( "street_terrorist_bldg_door", "script_noteworthy" );
	m_door ConnectPaths();
	m_door Delete();
	
	a_street_yemeni = get_ai_array( "street_yemeni", "script_noteworthy" );
	array_thread( a_street_yemeni, ::street_yemeni_enter_building );
}

street_yemeni_enter_building()
{
	self endon( "death" );
	
	s_runto_spot = GetStruct( "street_yemeni_runto_bldg_spot", "targetname" );
	
	wait RandomFloatRange( .05, 2 );
	self set_goalradius( 256 );
	self SetGoalPos( s_runto_spot.origin );	
	self waittill( "goal" );
	self Delete();
}

street_advancers()
{
	flag_wait( "metal_storms_fire_building_rocket" );
	
	a_nodes_1 = GetNodeArray( "streets_advance_1", "targetname" );
	a_nodes_2 = GetNodeArray( "streets_advance_2", "targetname" );
	a_nodes_3 = GetNodeArray( "streets_advance_3", "targetname" );
	
	a_advancers = simple_spawn( "yemeni_street_advancer", maps\yemen_utility::yemeni_teamswitch_spawnfunc );
	
	wait .5;
	street_advancers_move( a_advancers, a_nodes_1 ); 	// move to the first spot
	
	flag_wait( "metal_storms_entered_street" );
	wait 1;		// give time for rappelers to finish
	street_advancers_move( a_advancers, a_nodes_2 ); 	// move up
	
	wait 10;
	street_advancers_move( a_advancers, a_nodes_3 );	// move up
}

street_advancers_move( a_advancers, a_nodes )
{
	for( i = 0; i < a_advancers.size; i++ )
	{
		if ( IsDefined( a_advancers[i] ) && IsAlive( a_advancers[i] ) )
		{
			a_advancers[i] SetGoalNode( a_nodes[i] );
		}
	}
}
	
/* ------------------------------------------------------------------------------------------
	Metal Storms
-------------------------------------------------------------------------------------------*/

street_terrorist_spawnfunc()
{
	self endon( "death" );
	
	self thread maps\yemen_utility::terrorist_teamswitch_spawnfunc();
	
	while( !flag( "player_engaged_street_terrorists" ) )
	{
		self waittill( "damage", damage, ai_guy );

		if( ai_guy == level.player )
		{
			flag_set( "player_engaged_street_terrorists" );
			spawn_manager_kill( "street_terrorist_spawn_manager" );
		}
	}	
}

courtyard_left_metalstorm_think()
{
	self endon( "death" );
	
	level.courtyard_asd = self;
	level notify( "courtyard_asd_spawned" );
	
	//The ASD takes no damage so it can complete the vignette before being destroyed
	self maps\_metal_storm::metalstorm_stop_ai();
	self.attackeraccuracy = 0;
	//self thread maps\_metal_storm::metalstorm_weapon_think();
	
	//level flag_wait( "metal_storms_fire_building_rocket" );
	t_courtyard = GetEnt( "courtyard_move_asd_left", "targetname" );
	t_courtyard waittill( "trigger" );
	
	/*v_start_point = self GetTagOrigin( "tag_flash" );
	e_target = get_ent( "metalstorm_courtyard_dummy_target", "targetname" );
	self SetTurretTargetEnt( e_target );
	self waittill( "turret_on_target" );
	MagicBullet( "rpg_magic_bullet_sp", v_start_point, e_target.origin );*/
	
	v_start_point = self GetTagOrigin( "tag_flash" );
	a_ai_targets = get_ai_array( "courtyard_asd_target", "script_noteworthy" );
	e_target = a_ai_targets[0];
	self SetTurretTargetEnt( e_target );
	self waittill( "turret_on_target" );
	MagicBullet( "rpg_magic_bullet_sp", v_start_point, e_target.origin );
	
	courtyard_metalstorm_think();
}

courtyard_right_metalstorm_think()
{
	self endon( "death" );
	
	level.courtyard_asd = self;
	level notify( "courtyard_asd_spawned" );
	
	//The ASD takes no damage so it can complete the vignette before being destroyed
	self maps\_metal_storm::metalstorm_stop_ai();
	self.attackeraccuracy = 0;
	//self thread maps\_metal_storm::metalstorm_weapon_think();
	
	//trigger_wait( "courtyard_move_asd_right" );
	
	e_start = get_ent( "courtyard_right_mb_startpoint", "targetname" );
	e_end = get_ent( "courtyard_right_mb_endpoint", "targetname" );
	MagicBullet( "rpg_magic_bullet_sp", e_start.origin, e_end.origin );
	
	courtyard_metalstorm_think();
}

courtyard_metalstorm_think()
{
	self waittill( "reached_end_node" );
	flag_wait( "metal_storms_fire_building_rocket" );
	
	flag_wait( "yemen_gump_morals" );

	//Blow up the Balcony
	e_target = GetEnt( "metalstorm_courtyard_balcony_target", "targetname" );
	self notify( "change_state" );
	self SetTurretTargetEnt( e_target );
	self waittill( "turret_on_target" );
	self thread courtyard_fire_fake_rocket();
		
	self VehClearEntityTarget( e_target );
	self maps\_metal_storm::metalstorm_start_ai();
	
	//Vignette's done, allow the ASD to be shot
	//self.attackeraccuracy = 1;
	
	// setup to defend the courtyard
	s_courtyard_defend = GetStruct( "courtyard_metalstorm_defend", "targetname" );
	self thread maps\_vehicle::defend( s_courtyard_defend.origin, s_courtyard_defend.radius );
}

street_metalstorm_think( id )
{
	self endon( "death" );
	
	// fire weapons while on intro spline
	self thread maps\_metal_storm::metalstorm_weapon_think();
	
	// waittill end of spline
	self waittill( "reached_end_node" );
	
	// done scripted
	self notify( "scripted_done" );
	wait( 0.05 );
	
	// defend an area
	s_defend_area = GetStruct( "street_metalstorm_" + id + "_defend", "targetname" );
	self thread maps\_vehicle::defend( s_defend_area.origin, s_defend_area.radius );
}

courtyard_vtol_think()
{
	self endon( "death" );
	
	self SetForceNoCull();
	self waittill( "reached_end_node" );
	self Delete();
}


/* ------------------------------------------------------------------------------------------
	Specialties
-------------------------------------------------------------------------------------------*/

metal_storms_intruder()
{
	flag_wait( "player_has_intruder" );
	
	s_intruder_pos = GetEnt( "trig_intruder", "targetname" );
	set_objective( level.OBJ_INTERACT, s_intruder_pos.origin, "interact" );
	
	trigger_wait( "trig_intruder" );
	
	set_objective( level.OBJ_INTERACT, s_intruder_pos, "remove" );
	m_clip = GetEnt( "intruder_gate_clip", "targetname" );
	m_clip Delete();
	
	run_scene( "intruder" );
}

intruder_turret()
{
	flag_wait( "yemen_gump_morals" );
	
	e_turret = GetEnt( "intruder_turret", "targetname" );
	
	e_turret thread intruder_turret_move_qrdrones();
	
	e_turret maps\_turret::set_turret_target_flags( TURRET_TARGET_VEHICLES );	// TURRET_TARGET_AI | TURRET_TARGET_VEHICLES 
	e_turret maps\_turret::set_turret_burst_parameters( 1, 2, 1, 2 );
	e_turret enable_turret();
//	trigger_wait( "start_morals" );
	flag_wait( "morals_start" ); // Sky - wait for flag because trigger is gone already sometimes
	e_turret Delete();
}

intruder_turret_move_qrdrones()
{
	level endon( "morals_start" );
	
	flag_wait( "street_player_on_balcony" );
		
	a_qrs = GetEntArray( "street_drone", "script_noteworthy" );
	s_goal = GetStruct( "streets_qr_moveto", "targetname" );
	
	foreach ( vh_qr in a_qrs )
	{
		vh_qr.goalpos = s_goal.origin;
		vh_qr.goalradius = 600;
	}
}

/* ------------------------------------------------------------------------------------------
	Metal Storms VO
-------------------------------------------------------------------------------------------*/

vo_pre_morals()
{
	level.player queue_dialog( "harp_farid_you_still_m_0" );			//Farid... You still me?
}

vo_courtyard()
{
	level.player queue_dialog( "yeme_watchtower_we_are_m_0" );		//Watchtower, we are moving into position and commencing our assault.
	level.player queue_dialog( "yeme_watchtower_confirmi_0" );		//Watchtower, confirming metal storm robots on site assisting attack.
	level.player queue_dialog( "yeme_we_are_encountering_0" );		//We are encountering strong resistance!
	level.player queue_dialog( "yeme_taking_fire_from_the_0" );		//Taking fire from the windows! We need additional support!
}



/* ------------------------------------------------------------------------------------------
	Challenges
-------------------------------------------------------------------------------------------*/

turretqrkills_death_listener( str_notify )
{
	level endon( "morals_start" );
	
	self.script_noteworthy = "street_drone";	// just in case, needed for moving the drone when the player gets on the turret
	self waittill ( "death", attacker, type, weapon );
	
	if ( attacker == level.player && weapon == "auto_gun_turret_sp" )
	{
		level.player notify ( str_notify );
	}
}