#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_anim;
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
	flag_init( "start_vo_market_overwhelmed" );
	
	flag_init( "player_attacked_yemeni" );
	flag_init( "player_attacked_terrorists" );
	flag_init( "player_killed_terrorists" );
	
	flag_init( "yemeni_attacked_player" );
	flag_init( "robot_attacked_player" );
	flag_init( "terrorist_attacked_player" );
	
	flag_init( "player_cover_blown" );
	
	flag_init( "yemenis_ahead" );
	
	flag_init( "kill_market_vo" );	
}

//	event-specific spawn functions
init_spawn_funcs()
{
	add_spawn_function_group( "yemeni", "script_noteworthy", ::yemeni_teamswitch_spawnfunc );
	add_spawn_function_group( "terrorist", "script_noteworthy", ::terrorist_teamswitch_spawnfunc );
	
	add_spawn_function_group( "court_terrorists", "targetname", ::terrorist_teamswitch_spawnfunc );
	
	waittillframeend;

	add_spawn_function_group( "melee_01_terrorist", "targetname", ::melee_01_terrorist );
	add_spawn_function_group( "melee_01_yemeni", "targetname", ::melee_01_yemeni );
	
	add_spawn_function_group( "rolling_door_01", "targetname", ::rolling_door_guy );
	add_spawn_function_group( "rolling_door_02", "targetname", ::rolling_door_guy );
	
	add_spawn_function_group( "rolling_door_2_01", "targetname", ::rolling_door_2_guy );
	add_spawn_function_group( "rolling_door_2_02", "targetname", ::rolling_door_2_guy );
	
	add_spawn_function_veh( "market_drone_ambush_01", ::market_drone_ambush_drone );
	add_spawn_function_veh( "market_drone_ambush_02", ::market_drone_ambush_drone );
	add_spawn_function_veh( "market_drone_ambush_03", ::market_drone_ambush_drone );
	
	/#
		add_spawn_function_group( "terrorist", "script_noteworthy", ::terrorist_debug_spawnfunc );
	#/
}

rolling_door_guy()
{
	self.ignoreme = true;
	self endon( "death" );
	scene_wait( "rolling_door" );
	self.ignoreme = false;
}

rolling_door_2_guy()
{
	self.ignoreme = true;
	self endon( "death" );
	scene_wait( "rolling_door2" );
	self.ignoreme = false;
}

market_drone_ambush_drone()
{
	wait 3;
	self maps\_vehicle::defend( self.origin, 300 );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_market()
{
	if ( level.is_defalco_alive )
	{
		skip_scene( "speech_walk_with_defalco" );
		skip_scene( "speech_walk_with_defalco_player" );
	}
	else
	{
		skip_scene( "speech_walk_no_defalco" );
		skip_scene( "speech_walk_no_defalco_player" );
	}
	
	//level.menendez = get_ai( "menendez_speech_ai", "targetname" );
	//level.menendez.team = "allies";
	
	skipto_teleport( "skipto_market_player" );
	
	maps\_vehicle::vehicle_add_main_callback( "heli_quadrotor", maps\yemen_utility::yemen_quadrotor_indicator );
}

skipto_drone_crash()
{
	load_gump( "yemen_gump_market_streets" );
	skipto_teleport( "skipto_drone_crash" );
	drone_crash_into_car();
}

/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in
//		your skipto sequence will be called.
main()
{
/#
	IPrintLn( "Market" );
#/
	level thread yemen_market_setup();
		
	add_global_spawn_function( "axis", ::die_behind_player, get_struct( "obj_market_meet_manendez" ) );
	add_global_spawn_function( "allies", ::die_behind_player, get_struct( "obj_market_meet_manendez" ) );
	
	flag_wait( "player_turn" );
	trigger_use( "courtyard_wounded" );
	
	SetSavedDvar( "aim_target_ignore_team_checking", 1 );
	
	level thread vo_after_speech();
	level thread vo_market();
	level thread speech_courtyard_ai();
	level thread maps\yemen::meet_menendez_objectives();
	level thread speech_drone_runners();
	level thread speech_leave_stage();
	level thread yemen_market_clean_up();
	level thread drone_crash_into_car();
	
	waittill_speech_anim_done();
	
	level thread kill_behind_player();
	
	level thread maps\yemen_anim::market_anims();
	load_gump( "yemen_gump_market_streets" );
	
	setup_scenes();
	
	stop_exploder( 1000 );
	exploder( 1020 );
	
	level notify( "start_market_canopies" );
	
	level.friendlyFireDisabled = true;
	
	level.player SetThreatBiasGroup( "player" );
	
	autosave_by_name( "yemen_market_start" );
	
	level thread maps\yemen_amb::yemen_drone_control_tones( true );
	
	level thread market_vtol_crash();
	
	trigger_wait( "market_end" );
	
	autosave_by_name( "yemen_market_complete" );
	
	remove_global_spawn_function( "axis", ::die_behind_player );
	remove_global_spawn_function( "allies", ::die_behind_player );
}

yemen_market_setup()
{
	flag_wait( "player_enters_market" );
	maps\createart\yemen_art::market();
}

waittill_speech_anim_done()
{
	if( level.is_defalco_alive )
	{
		scene_wait( "speech_walk_with_defalco_player" );
	}
	else
	{
		scene_wait( "speech_walk_no_defalco_player" );
	}
}

speech_leave_stage()
{
	level thread speech_drones_ignore_player();
	spawn_vehicle_from_targetname_and_drive( "speech_amb_vtol" );
}

speech_drones_ignore_player()
{
	level.player set_ignoreme( true );
	
	level thread speech_drones_ignore_player_timeout();
	
	level.player waittill_any( "weapon_fired", "speech_stop_player_ignoreme" );
	level.player set_ignoreme( false );
}

speech_drones_ignore_player_timeout()
{
	wait 15;
	level.player notify( "speech_stop_player_ignoreme" );
}

speech_quads()
{
	const count = 9;
	
	a_quads = [];
	
	for ( i = 0; i < count; i++ )
	{
		vh_quad = maps\_vehicle::spawn_vehicle_from_targetname( "vtol_attack_drone" );
		vh_quad.takedamage = false;
		ARRAY_ADD( a_quads, vh_quad );
	}
	
	wait 0.1;	// allow the state to change to scripted
	
	/* Enter */
	
	nd_start = GetVehicleNode( "quad_courtyard_enter_path", "targetname" );
	
	offset = (0, 100, 0);
	
	for( i=0; i < count; i++ )
	{
		vh_quad = a_quads[i];
		
		vh_quad SetVehicleAvoidance( false );
		vh_quad maps\_vehicle::getonpath( nd_start );
		//quad.drivepath = true;
		//quad PathVariableOffset( (0, 10, 10), 2 );
		
		offset_scale = get_offset_scale( i );
		vh_quad PathFixedOffset( offset * offset_scale );
		vh_quad PathVariableOffset( (0, 0, 30), .1 );
		
		vh_quad thread maps\_vehicle::gopath();
		
		vh_quad ent_flag_init( "circling_stage" );
		
		// 1/3 of them circle the stage.
		if ( i % 3 == 0 )
		{
			vh_quad thread circle_stage();
			vh_quad ent_flag_set( "circling_stage" );
		} else {
			vh_quad thread circle_courtyard();
		}
	}
	
	wait 15;
	
	/* Square Formation */
	
	nd_start = GetVehicleNode( "quad_courtyard_exit_path", "targetname" );
	
	// Send away the ones in the square.
	speech_quads_exit_formation( a_quads, nd_start, false );
	
	flag_wait( "menendez_exited" );
	level notify( "stage_quads_exit" );
	
	// Send away the ones over the stage.
	speech_quads_exit_formation( a_quads, nd_start, true );
}

speech_quads_exit_formation( a_quads, nd_start, stage_quads = false )
{
	offset = (0, 0, 0);
	i = 0;
	foreach ( vh_quad in a_quads )
	{
		if ( !IsDefined( vh_quad ) )
		{
			continue;
		}
		
		if ( vh_quad ent_flag( "circling_stage" ) != stage_quads )
		{
			continue;
		}
		
		vh_quad thread exit_courtyard( nd_start, offset );
		
		offset += (60, 0, 0);
		
		i++;
		if ( i % 3 == 0 )
		{
			offset = (0,0,0);
			wait 0.5;
		}
	}
}

exit_courtyard( nd_start, offset )
{
	self notify( "exit_speech" );
	self PathVariableOffsetClear();
	self SetVehicleAvoidance( false );
	self SetVehGoalPos( nd_start.origin + offset, true );
	self SetSpeed( 25 );
	self waittill( "goal" );
	wait 1;
	self PathMove( nd_start, nd_start.origin + offset, nd_start.angles );
	self thread go_path( nd_start );
}

circle_stage()
{
	self endon( "death" );
	self endon( "stage_quads_exit" );
	
	self waittill( "reached_end_node" );
	
	self PathVariableOffsetClear();
	self PathFixedOffsetClear();
	
	nd_start = GetVehicleNode( "quad_path_stage", "targetname" );
	
	while ( true )
	{	
		maps\_vehicle::getonpath( nd_start );
		self PathVariableOffset( ( 30, 30, 30 ), 2 );
		maps\_vehicle::gopath();
	}
}

circle_courtyard()
{
	self endon( "death" );
	self endon( "exit_speech" );
	
	self waittill( "reached_end_node" );
	
	self PathVariableOffsetClear();
	self PathFixedOffsetClear();
	
	nd_start = undefined;
	if ( cointoss() )
	{
		nd_start = GetVehicleNode( "quad_circle_path_1", "targetname" );
	}
	else
	{
		nd_start = GetVehicleNode( "quad_circle_path_2", "targetname" );
	}
	
	while ( true )
	{	
		maps\_vehicle::getonpath( nd_start );
		self PathVariableOffset( ( 30, 30, 30 ), 2 );
		maps\_vehicle::gopath();
	}
}

speech_drone_runners()
{
	flag_wait( "menendez_grabs_player" );
	trigger_use( "speech_running_drones", "script_noteworthy" );
	wait 10;
	trigger_use( "speech_end_drones", "script_noteworthy" );
}

speech_courtyard_ai()
{
	sp_courtyard_spawner = GetEnt( "court_terrorists", "targetname" );
	sp_courtyard_spawner add_spawn_function( ::spawn_func_player_damage_only );
	
	flag_wait( "player_turns_back" );
	
	level thread run_scene_and_delete( "shooting_drones_ter1" );
	level thread run_scene_and_delete( "shooting_drones_ter2" );
	level thread run_scene_and_delete( "shooting_drones_ter3" );
	level thread run_scene_and_delete( "shooting_drones_ter4" );
	level thread run_scene_and_delete( "shooting_drones_ter5" );
	level thread run_scene_and_delete( "shooting_drones_ter6" );
	
	a_courtyard_spots = GetStructArray( "speech_court_ai_spot", "targetname" ); // TODO: reduce number
	
	/#
		a_courtyard_spots = [];	// HACK: dirty hack to get level to run in release without running out of script vars
	#/
	
	foreach ( s_courtyard_spot in a_courtyard_spots )
	{
		ai_guy = simple_spawn_single( sp_courtyard_spawner );
		ai_guy maps\yemen_utility::teleport_ai_to_pos( s_courtyard_spot.origin );
		ai_guy.script_noteworthy = s_courtyard_spot.script_noteworthy;
	}
	
	array_delete( a_courtyard_spots, true );
	
	spawn_quadrotors_at_structs( "court_drone_spot", "court_drone" );
	trigger_use( "spawn_court_drones" );
	
	flag_wait_or_timeout( "player_leaves_stage", 10 );
	
	ai_courtyard = GetEntArray( "court_terrorists_ai", "targetname" );
	foreach ( ai in ai_courtyard )
	{
		ai.overrideActorDamage = undefined;
	}
	
	a_ai = get_ai_array( "courtyard_high_left", "script_noteworthy" );
	nd_exit = GetNode( "high_left_exit_node", "targetname" );
	foreach ( ai in a_ai )
	{
		ai thread run_to_goal_and_delete( nd_exit );
	}
	
	a_ai = get_ai_array( "courtyard_high_right", "script_noteworthy" );
	nd_exit = GetNode( "high_right_exit_node", "targetname" );
	foreach ( ai in a_ai )
	{
		ai thread run_to_goal_and_delete( nd_exit );
	}
	
	a_ai = get_ai_array( "courtyard_center", "script_noteworthy" );
	nd_exit = GetNode( "center_exit_node", "targetname" );
	foreach ( ai in a_ai )
	{
		ai thread run_to_goal_and_delete( nd_exit );
	}
	
	flag_wait_or_timeout( "player_moves_towards_market", 6 );
	
	ai = get_ais_from_scene( "shooting_drones_ter1" );
	if ( IsAlive( ai[0] ) )
	{
		ai[0].overrideactordamage = undefined;
		ai[0] thread bloody_death( undefined, 3 );
	}
	
	ai = get_ais_from_scene( "shooting_drones_ter2" );
	if ( IsDefined( ai ) && IsAlive( ai[0] ) )
	{
		ai[0].overrideactordamage = undefined;
		ai[0] thread bloody_death( undefined, 3 );
	}
	
	ai = get_ais_from_scene( "shooting_drones_ter3" );
	if ( IsDefined( ai ) && IsAlive( ai[0] ) )
	{
		ai[0].overrideactordamage = undefined;
		ai[0] thread bloody_death( undefined, 3 );
	}
	
	ai = get_ais_from_scene( "shooting_drones_ter4" );
	if ( IsDefined( ai ) && IsAlive( ai[0] ) )
	{
		ai[0].overrideactordamage = undefined;
		ai[0] thread bloody_death( undefined, 3 );
	}
	
	ai = get_ais_from_scene( "shooting_drones_ter5" );
	if ( IsDefined( ai ) && IsAlive( ai[0] ) )
	{
		ai[0].overrideactordamage = undefined;
		ai[0] thread bloody_death( undefined, 3 );
	}
	
	ai = get_ais_from_scene( "shooting_drones_ter6" );
	if ( IsDefined( ai ) && IsAlive( ai[0] ) )
	{
		ai[0].overrideactordamage = undefined;
		ai[0] thread bloody_death( undefined, 3 );
	}
	
	a_quads = get_vehicle_array( "court_drone", "script_noteworthy" );
	foreach ( vh_quad in a_quads )
	{
		if ( IsDefined( vh_quad ) )
		{
			vh_quad DoDamage( vh_quad.health, vh_quad.origin );
			wait RandomFloat( 2 );
		}
	}
}

run_to_goal_and_delete( nd_exit )
{
	self endon( "death" );
	self force_goal( nd_exit, 50 );
	self Delete();
}

autoexec market_gump_cleanup()
{
	level waittill( "flushing_yemen_gump_market_streets" );
	
	cleanup( "market_vtol_crash" );
	cleanup( "fxanim_vtol1_crash" );
}

drone_crash_into_car()
{
	flag_wait( "drone_crash_into_car" );
	vh_drone = spawn_vehicle_from_targetname( "market_drone_car" );
	vh_drone maps\_quadrotor::quadrotor_start_scripted();
	vh_drone DoDamage( 380, vh_drone.origin );
	vh_drone.takedamage = false;
	vh_drone thread maps\_quadrotor::quadrotor_fireupdate();
	vh_drone go_path( GetVehicleNode( vh_drone.target, "targetname" ) );
	v_damage = vh_drone.origin;
	VEHICLE_DELETE( vh_drone );
	RadiusDamage( v_damage, 250, 150, 50 );
}

setup_scenes()
{
	run_scene_first_frame( "table_flip_01", true );
	//run_scene_first_frame( "table_flip_02", true );
	run_scene_first_frame( "table_flip_03", true );
	run_scene_first_frame( "table_flip_04", true );
	run_scene_first_frame( "pushcart", true );
	run_scene_first_frame( "pushcart_right", true );
}

melee_01_terrorist( ai )
{
	self endon( "death" );
	
	self.overrideActorDamage = ::take_player_damage_only;
	self thread melee_01_terrorist_cancel();
	
	self.ignoreme = true;
	self.ignoreall = true;
	
	self waittill( "goal" );
			
	scene_wait( "melee_01" );
	
	self.ignoreme = false;
	self.ignoreall = false;
}

melee_01_terrorist_cancel()
{
	self waittill( "death" );
	end_scene( "melee_01" );
}

melee_01_yemeni()
{
	self endon( "death" );
	
	self thread take_player_damage_only_for_scene( "melee_01" );
	self thread melee_01_yemeni_cancel();
	
	self.ignoreme = true;
	self.ignoreall = true;
	
	self waittill( "goal" );
			
	scene_wait( "melee_01" );
	
	self.ignoreme = false;
	self.ignoreall = false;
}

melee_01_yemeni_cancel()
{
	self waittill( "death" );
	end_scene( "melee_01" );
	ai_terrorist = GetEnt( "melee_01_terrorist", "targetname" );
	if ( IsAlive( ai_terrorist ) )
	{
		ai_terrorist ragdoll_death();
	}
}

car_flip_guy01( ai )
{
	ai endon( "death" );
	wait 5;
	ai.takedamage = true;
	ai.allowdeath = true;
	ai thread take_player_damage_only_for_time( 5 );
}

car_flip_guy02( ai )
{
	car_flip_guy01( ai );
}

rolling_door1_01( ai )
{
	ai thread take_player_damage_only_for_time( 7 );
}

rolling_door1_02( ai )
{
	rolling_door1_01( ai );
}

rolling_door_2_01( ai )
{
	ai thread take_player_damage_only_for_time( 7 );
}

rolling_door_2_02( ai )
{
	rolling_door_2_01( ai );
}

pushcart_guy01( ai )
{
	ai thread take_player_damage_only_for_scene( "pushcart" );
	ai waittill( "death" );
	end_scene( "pushcart" );
}

pushcart_guy02( ai )
{
	ai thread take_player_damage_only_for_scene( "pushcart" );
}

pushcart_right_guy( ai )
{
	ai thread take_player_damage_only_for_scene( "pushcart_right" );
	ai waittill( "death" );
	end_scene( "pushcart_right" );
}

die_behind_player( s_market_exit )
{
	DEFAULT( level.market_ai, [] );
	
	self.market_position = Distance2DSquared( self.origin, s_market_exit.origin );
	
	n_index = 0;
	for ( i = 0; i < level.market_ai.size; i++ )
	{
		n_index = i;
		if ( self.market_position >= level.market_ai[ i ].market_position )
		{
			break;
		}
	}
	
	ArrayInsert( level.market_ai, self, n_index );
	
	self waittill( "death" );
	if ( IsDefined( self ) )
	{
		ArrayRemoveValue( level.market_ai, self );
	}
	else
	{
		REMOVE_UNDEFINED( level.market_ai );
	}
}

kill_behind_player()
{
	MAX_MARKET_AI = 24;
	/#
		MAX_MARKET_AI = 15;
	#/
	
	level endon( "out_of_market" );
	
	while ( true )
	{
		wait .05;
		
		n_ai = GetAICount();
		n_kill = clamp( n_ai - MAX_MARKET_AI, 0, level.market_ai.size );
		
		if ( n_kill > 0 )
		{
			v_eye = level.player GetEye();
			
			i = 0;
			while ( n_kill > 0 && i < level.market_ai.size )
			{
				ai = level.market_ai[ i ];
				
				if ( IsAlive( ai ) && ai.takedamage && !IsDefined( ai.overrideActorDamage ) )
				{
					if ( ( ai SightConeTrace( v_eye, level.player ) < .1 ) )
					{
						ai Delete();
					}
					else
					{
						ai thread bloody_death();
					}
					
					n_kill--;
					ArrayRemoveIndex( level.market_ai, i );
				}
				else
				{
					i++;
				}
			}
		}
	}
}

yemen_market_clean_up() // called in terrorist hunt
{
	flag_wait( "out_of_market" );
	
	a_ai = get_ai_array( "market_ai", "script_string" );
	array_delete( a_ai );
	
	cleanup( "market_drones", "script_noteworthy" );
	cleanup( "market_vtol", "targetname" );
	cleanup( "market_wounded", "script_noteworthy" );
	cleanup( "courtyard_wounded", "script_noteworthy" );
	
	level thread maps\yemen_amb::yemen_drone_control_tones( false );
}

/* ------------------------------------------------------------------------------------------
	EVENT functions
-------------------------------------------------------------------------------------------*/

market_vtol_crash()
{
	level thread run_scene_and_delete( "market_vtol_loop" );
	
	m_vtol			= GetEnt( "market_vtol", "targetname" );
	s_stinger_start	= GetStruct( "vtol_crash_stinger_start", "targetname" );
	
	trigger_wait( "market_end" );
	
	flag_set( "start_vo_market_overwhelmed" );		// start VO if it hasn't been said yet
	autosave_by_name( "yemen_market_vtol_crash" );
	
	MagicBullet( "rpg_magic_bullet_sp", s_stinger_start.origin, m_vtol.origin - ( 0, 0, 32 ) );
	
	wait .8;
	
	level thread run_scene_and_delete( "market_vtol_crash" );
}

market_vtol_crash_callback( veh )
{
	level notify( "fxanim_vtol1_crash_start" );
	level thread market_vtol_crash_shake( veh.origin );
}

market_vtol_crash_shake( v_org )
{
	Earthquake( .3, .5, v_org, 2000 );
	PlayRumbleOnPosition( "crash_heli_rumble", level.player.origin );
	wait 4;
	Earthquake( .35, 4, v_org, 2000 );
	level.player rumble_loop( 3, 1, "crash_heli_rumble" );
}

vtol_shooter_damage_callback( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if( isDefined(eAttacker) && isPlayer(eAttacker))
	{
		return iDamage;
	}
	else
	{
		return 0;
	}
}

/* ------------------------------------------------------------------------------------------
	Other functions
-------------------------------------------------------------------------------------------*/

// plays the scene str_drone_scene once a trigger with the same targetname is hit
market_drones_think( str_drone_scene )
{
	trigger_wait( str_drone_scene );
	run_scene_and_delete( str_drone_scene );
}

market_wounded_anims_think( str_wounded_anim )
{
	trigger_wait( str_wounded_anim );
	run_scene_and_delete( str_wounded_anim );
}

/* ------------------------------------------------------------------------------------------
Market VO
-------------------------------------------------------------------------------------------*/

#define CONVO_WAIT 10
#define FIRST_LINE_WAIT 1
	
vo_after_speech()
{
	dialog_start_convo( "menendez_exited" );
	level.player priority_dialog( "harp_egghead_farid_0" );		//Egghead? Farid?!!
	//level.player priority_dialog( "fari_harper_i_lost_mene_0" );	//Harper.  I don't have visual on Menendez.
	level.player priority_dialog( "fari_menendez_knows_i_m_0" );	//Menendez knows!  I’m sure of it.
	level.player priority_dialog( "harp_you_can_t_be_sure_0" );	//You can’t be sure.  He’d have killed you the moment he suspected a thing.
	dialog_end_convo();
	
	if ( !flag( "player_leaves_stage" ) )
	{	
		dialog_start_convo();
		level.player priority_dialog( "fari_it_is_okay_i_am_to_0" );	//He told me to meet him at the Citadel.
		level.player priority_dialog( "harp_we_can_t_give_him_th_0" );	//We can't give him the chance to get dug in - You need to move through the city and re-establish contact.
		dialog_end_convo();
	}

	if ( !flag( "player_leaves_stage" ) )
	{	
		dialog_start_convo();	
		level.player priority_dialog( "harp_you_can_do_it_farid_0" );	//You can do it Farid, just stay calm and stay focused.  I'll get you through this.
		dialog_end_convo();
	}
	
	if ( !flag( "player_enters_market" ) )
	{
		dialog_start_convo();
		level.player priority_dialog( "fari_what_would_you_have_0" );	//What would you have me do?
		level.player priority_dialog( "harp_remember_what_s_at_s_0" );	//Remember what's at stake here.
		dialog_end_convo();
	}
	
	dialog_start_convo();
	level.player priority_dialog( "harp_the_yemeni_forces_ar_0" );	//The Yemeni forces are entering the market - moving in on your left.
	level.player priority_dialog( "harp_your_contacts_will_h_0" );	//Your contacts will highlight good guys with a blue diamond.
	level.player priority_dialog( "harp_do_not_fire_on_them_0" );	//Do not fire on them - unless you have no choice.	
	dialog_end_convo();
}

vo_market()
{
	level.player thread detect_player_attacker();
	
	level thread vo_fire_at_yemeni();
	level thread vo_yemenis_fire_at_player();
	level thread vo_terrorists_fire_at_player();
	//level thread vo_evade_terrorists();
	level thread vo_shoot_drones();
	level thread vo_kill_terrorists();
	level thread vo_yemeni_warning();
}

vo_yemenis_fire_at_player()
{
	level endon( "kill_market_vo" );
	
	dialog_start_convo( "yemeni_attacked_player" );
	level.player priority_dialog( "fari_harper_the_yemeni_0", FIRST_LINE_WAIT );	//Harper!  The Yemeni troops are firing on me!
	level.player priority_dialog( "harp_to_them_you_re_just_0" );	//To them you're just another terrorist!
	dialog_end_convo();
	
	wait CONVO_WAIT;
	
	dialog_start_convo( "yemeni_attacked_player" );
	level.player priority_dialog( "fari_harper_the_yemeni_f_0", FIRST_LINE_WAIT );	//Harper! The Yemeni forces are going to kill me!
    level.player priority_dialog( "harp_stay_outta_their_way_0" );	//Stay outta their way.
    dialog_end_convo();
	
    wait CONVO_WAIT;
    
    dialog_start_convo( "yemeni_attacked_player" );
    level.player priority_dialog( "fari_you_have_to_get_me_o_0", FIRST_LINE_WAIT );	//You have to get me out of here!
    level.player priority_dialog( "harp_we_can_t_extract_you_0" );	//We can't extract you, Farid! - not yet.
    dialog_end_convo();
}
   
vo_terrorists_fire_at_player()
{
	level endon( "kill_market_vo" );
	
	dialog_start_convo( "player_cover_blown" );
	priority_dialog_enemy( "enem_traitor_0" );										//Traitor!!!
	level.player priority_dialog( "fari_harper_they_re_on_0", FIRST_LINE_WAIT );	//Harper!  They're on to me!
    level.player priority_dialog( "harp_dammit_farid_i_to_0" );						//Dammit, Farid!  I told you not to blow your cover!
//    flag_waitopen( "player_cover_blown" );
//    level.player priority_dialog( "harp_you_re_in_the_clear_0" );					//You're in the clear.
    dialog_end_convo();
    
    wait CONVO_WAIT;
    
	dialog_start_convo( "player_cover_blown" );
   	priority_dialog_enemy( "enem_what_are_you_doing_0" );							//What are you doing!
   	level.player priority_dialog("fari_they_know_i_m_a_trai_0", FIRST_LINE_WAIT );	//They know I'm a traitor!
   	level.player priority_dialog("harp_fight_your_way_out_0" );						//Fight your way out!
//    flag_waitopen( "player_cover_blown" );
//    level.player priority_dialog( "harp_you_got_away_with_it_0" );					//You got away with it, but don't push it, Farid.
    dialog_end_convo();
    
    wait CONVO_WAIT;
    
	dialog_start_convo( "player_cover_blown" );
   	priority_dialog_enemy( "enem_get_him_0" );										//Get him!!
   	level.player priority_dialog("fari_they_know_i_m_not_on_0", FIRST_LINE_WAIT );	//They know I'm not on their side!
   	level.player priority_dialog("harp_lose_them_any_way_0" );						//Lose them - any way you can!
//    flag_waitopen( "player_cover_blown" );
//    level.player priority_dialog( "harp_they_didn_t_id_you_a_0" );					//They didn't ID you as one of us.
    dialog_end_convo();
    
    wait CONVO_WAIT;
    
	dialog_start_convo( "player_cover_blown" );
   	priority_dialog_enemy( "enem_he_s_turned_against_0" );								//He's turned against us!
   	level.player priority_dialog("harp_farid_they_re_on_t_0", FIRST_LINE_WAIT );		//Farid - they're on to you!  Lose ‘em or kill ‘em.
//    flag_waitopen( "player_cover_blown" );
//    level.player priority_dialog( "harp_you_re_taking_risks_0" );						//You're taking risks, Farid.  Knock that shit off.
	dialog_end_convo();
    
    wait CONVO_WAIT;
    
	dialog_start_convo( "player_cover_blown" );
   	priority_dialog_enemy( "enem_he_s_crazy_0" );										//He's crazy!
   	level.player priority_dialog("harp_watch_your_fire_far_0", FIRST_LINE_WAIT );		//Watch your fire, Farid! You're drawing too much attention!
   	dialog_end_convo();
    
    wait CONVO_WAIT;
    
	dialog_start_convo( "player_cover_blown" );
   	priority_dialog_enemy( "enem_he_s_fighting_for_th_0" );								//He's fighting for the enemy!
   	level.player priority_dialog("harp_you_got_trouble_far_0", FIRST_LINE_WAIT );		//You got trouble, Farid! Find some cover!
   	dialog_end_convo();
    
    wait CONVO_WAIT;
    
	dialog_start_convo( "player_cover_blown" );
   	priority_dialog_enemy( "enem_kill_him_0" );											//Kill him!
   	level.player priority_dialog("harp_get_the_hell_out_of_0", FIRST_LINE_WAIT );		//Get the hell out of there before you blow your cover!
   	dialog_end_convo();
}

//vo_evade_terrorists()
//{
//	level endon( "kill_market_vo" );
//	
//	flag_wait( "player_cover_blown" );
//	flag_waitopen( "player_cover_blown" );
//	
//	dialog_start_convo();
//	level.player priority_dialog( "harp_you_re_in_the_clear_0", FIRST_LINE_WAIT );	//You're in the clear.
//	dialog_end_convo();
//	
//	wait CONVO_WAIT;
//	
//	flag_wait( "player_cover_blown" );
//	flag_waitopen( "player_cover_blown" );
//	
//	dialog_start_convo();
//    level.player priority_dialog( "harp_you_got_away_with_it_0", FIRST_LINE_WAIT );	//You got away with it, but don't push it, Farid.
//    dialog_end_convo();
//    
//    wait CONVO_WAIT;
//    
//    flag_wait( "player_cover_blown" );
//	flag_waitopen( "player_cover_blown" );
//	
//    dialog_start_convo();
//    level.player priority_dialog( "harp_they_didn_t_id_you_a_0", FIRST_LINE_WAIT );	//They didn't ID you as one of us.
//    dialog_end_convo();
//    
//    wait CONVO_WAIT;
//    
//    flag_wait( "player_cover_blown" );
//	flag_waitopen( "player_cover_blown" );
//    
//    dialog_start_convo();
//    level.player priority_dialog( "harp_you_re_taking_risks_0", FIRST_LINE_WAIT );	//You're taking risks, Farid.  Knock that shit off.
//    dialog_end_convo();
//}

vo_kill_terrorists()
{
	level endon( "kill_market_vo" );
	
	dialog_start_convo( "player_killed_terrorists", "player_cover_blown" );
//	level.player priority_dialog( "fari_harper_i_killed_so_0", FIRST_LINE_WAIT );	//Harper!  I killed some bad guys.
   	level.player priority_dialog( "harp_stay_on_mission_far_0" );					//Stay on mission, Farid.
   	dialog_end_convo();
    
    wait CONVO_WAIT;
        
	dialog_start_convo( "player_killed_terrorists", "player_cover_blown" );
//   	level.player priority_dialog( "fari_i_managed_to_take_ou_0", FIRST_LINE_WAIT );	//I managed to take out some of the bad guys.
   	level.player priority_dialog( "harp_be_careful_farid_0" );						//Be careful, Farid.  We need you alive!
   	level.player priority_dialog( "fari_it_s_okay_no_one_s_0" );					//It's okay - No one saw me.
   	dialog_end_convo();
}

vo_shoot_drones()
{
	level endon( "kill_market_vo" );
	
	dialog_start_convo( "robot_attacked_player", "yemeni_attacked_player" );
	level.player priority_dialog( "fari_i_m_taking_fire_from_0", FIRST_LINE_WAIT );	//I'm taking fire from the drones!
   	level.player priority_dialog( "harp_return_fire_you_ha_0" );					//Return fire!  You have to protect yourself.
   	dialog_end_convo();
    
    wait CONVO_WAIT;
    
	dialog_start_convo( "robot_attacked_player", "yemeni_attacked_player" );
   	level.player priority_dialog( "fari_i_have_to_engage_the_0", FIRST_LINE_WAIT );	//I have to engage the drones!
   	level.player priority_dialog( "harp_fuck_em_they_re_0" );						//Fuck ‘em... They're only robots.
   	dialog_end_convo();
}

vo_fire_at_yemeni()
{
	level endon( "kill_market_vo" );
	
	dialog_start_convo( "player_attacked_yemeni", "yemeni_attacked_player" );
	level.player priority_dialog( "harp_return_fire_only_if_0" );	//Return fire ONLY if you have no other choice!
	dialog_end_convo();
	
	wait CONVO_WAIT;
	
	dialog_start_convo( "player_attacked_yemeni", "yemeni_attacked_player" );
   	level.player priority_dialog( "harp_the_yemeni_s_are_on_0" );	//The Yemeni's are on OUR side, remember?
   	dialog_end_convo();
    
    wait CONVO_WAIT;
    
	dialog_start_convo( "player_attacked_yemeni", "yemeni_attacked_player" );
	level.player priority_dialog( "harp_farid_what_the_hel_0" );	//Farid!  What the Hell are you doing?
   	dialog_end_convo();
    
    wait CONVO_WAIT;
    
	dialog_start_convo( "player_attacked_yemeni", "yemeni_attacked_player" );
   	level.player priority_dialog( "harp_do_not_fire_on_the_y_0" );					//Do not fire on the yemeni unless you have to.
   	dialog_end_convo();
    
    wait CONVO_WAIT;
    
	dialog_start_convo( "player_attacked_yemeni", "yemeni_attacked_player" );
   	level.player priority_dialog( "harp_dammit_farid_do_n_0" );						//Dammit, Farid!  Do NOT engage unless your life depends on it!
   	dialog_end_convo();
}

vo_yemeni_warning()
{
	level endon( "kill_market_vo" );
	
	dialog_start_convo( "yemenis_ahead" );
	level.player priority_dialog( "harp_yemeni_troops_dead_a_0" );	//Yemeni troops dead ahead.  Find another way around.	
	dialog_end_convo();
	
	dialog_start_convo( "window_explosion_01_started" );
   	level.player priority_dialog( "harp_you_re_walking_strai_0" );	//You're walking straight into the Yemeni lines!
   	dialog_end_convo();
    
//    wait CONVO_WAIT;
//    
//    level.player priority_dialog( "harp_stay_in_the_alleys_0" );		//Stay in the alleys, Farid.
//    
//    wait CONVO_WAIT;
//    
//    level.player priority_dialog( "harp_dammit_man_get_th_0" );		//Dammit, Man!  Get the hell out of there.    
}
