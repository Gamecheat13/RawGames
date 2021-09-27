#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include maps\prague_escape_code;
#include maps\_shg_common;
#include animscripts\utility;
#include animscripts\traverse\shared;
#include maps\_utility_chetan;


flags_defend()
{
	flag_init( "chasers" );
	flag_init( "FLAG_defend_court_soap_reached_back_area" );
	flag_init( "soap_carry" );
	flag_init( "uazs_arrive" );
	flag_init( "uaz1_unloaded" );
	flag_init( "uaz2_unloaded" );
	flag_init( "open_fire" );
	flag_init( "advance_done" );
	flag_init( "enter_alley" );
	flag_init( "start_runners" );
	flag_init( "suv_flank_unloaded" );
	flag_init( "suv_final_unloaded" );
	flag_init( "btr_arrives" );
	flag_init( "rpg_fired" );
	flag_init( "kill_resist_window" );
	flag_init( "btr_on_court" );
	flag_init( "FLAG_defend_btr_knocks_down_fence" );
	flag_init( "FLAG_resistance_help_soap_spawned" );
	flag_init( "btr_destroyed" );
	flag_init( "resistance_attacks" );
	flag_init( "resistance_arrival" );
	flag_init( "resistance_mortal" );
	flag_init( "price_soap_leaving" );
	flag_init( "soap_pickedup" );
	flag_init( "clear_table" );
	flag_init( "soap_on_table" );
	flag_init( "in_safehouse" );
	flag_init( "FLAG_soap_death_close_door_to_defend" );
	
	flag_init( "queue_defend_music" );
}

start_defend()
{
	move_player_to_start( "start_defend" );
	
	maps\_compass::setupMiniMap( "compass_map_prague_escape_standoff", "standoff_minimap_corner" );
	
	setup_hero_for_start( "price", "defend" );
	setup_hero_for_start( "soap", "defend" );
	
	level.player EnableWeapons();
	
	level.price forceUseWeapon( "deserteagle", "primary" );
	level.soap forceUseWeapon( "p99", "primary" );
	
	level.n_obj_protect = prague_objective_add_on_ai( level.soap, &"PRAGUE_ESCAPE_PROTECT_SOAP", true, true, "active", &"PRAGUE_ESCAPE_PROTECT" );
	
	flag_set( "queue_sniper_music" );
	flag_set( "queue_player_carry_music" );
	flag_set( "queue_price_carry_music" );
	flag_set( "queue_defend_music" );
	
	level thread maps\prague_escape::handle_prague_escape_music();
	
	//spawn chopper 
	level.cough_alley_chopper = spawn_vehicle_from_targetname("cough_alley_chopper" );
	wait(.10);
	level.cough_alley_chopper.target_offset = undefined;	
	node = getstruct("defend_wait_node", "script_noteworthy" );
	level.cough_alley_chopper vehicle_teleport( node.origin, node.angles );
	level.cough_alley_chopper.attachedpath = node;	
	level.cough_alley_chopper thread vehicle_paths( node );
	level thread maps\prague_escape_store::chopper_navigate_logic();
	
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
}


start_resistance_carry()
{
	move_player_to_start( "start_resistance_carry" );
	
	maps\_compass::setupMiniMap( "compass_map_prague_escape_standoff", "standoff_minimap_corner" );
	
	level.player GiveWeapon( "m4m203_reflex" );
	level.player SwitchToWeapon( "m4m203_reflex" );
	
	setup_hero_for_start( "price", "resistance_carry" );
	setup_hero_for_start( "soap", "resistance_carry" );
	
	level.price forceUseWeapon( "ak47", "primary" );
	level.soap forceUseWeapon( "p99", "primary" );
	
	level.n_obj_protect = prague_objective_add_on_ai( level.soap, &"PRAGUE_ESCAPE_PROTECT_SOAP", true, true, "active", &"PRAGUE_ESCAPE_PROTECT" );
	
	defend_setup();
	flags_defend();
	defend_spawnfuncs();
	
	align_soap = getstruct( "anim_align_basketball", "targetname" );
	align_soap thread anim_loop_solo( level.soap, "idle_soap" );
	
	wait 5;
	
	thread transition_to_safehouse();
	thread gate_door_clips();
	
	align_soap_death = getstruct( "anim_align_soap_death", "targetname" );
	align_soap_death anim_reach_solo( level.price, "resistancearrive1" );
	
	flag_set( "btr_destroyed" );
	
	thread spawn_resistance();

	// **TODO put second group here
	
	align_soap notify( "stop_loop" );
	
	group = [ level.price, level.soap, level.ai_leader, level.ai_medic4 ];
	level.ai_leader thread play_sound_on_entity( "ch_pragueb_9_2_resistancecarry_leader" );
	align_soap_death anim_single( group, "resistancearrive1" );
	
	flag_set( "resistance_arrival" );
	
	carry_group = [ level.price, level.soap, level.ai_leader, level.ai_medic4 ];
	align_soap_death thread anim_loop( carry_group, "idle_carry" );
	
	wait 8;
	
	level.soap waittill_player_lookat();
	
	align_soap_death notify( "stop_loop" );
	
	flag_set( "soap_pickedup" );
	
	thread clear_table_timer();
	
	//thread medic_resistance_stop_carry_anims();
	exploder( 801 );
	
	align_soap_death anim_single( carry_group, "resistancecarry" );
	
	flag_set( "soap_on_table" );
	
	flag_wait( "in_safehouse" );
	
	battlechatter_off( "allies" );
	
	trig_medic_start = GetEnt( "trig_medic_start", "targetname" );
	trig_medic_start trigger_on();
	
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
}


resistance_carry_main()
{
	//move along, nothing to see here
}

defend_main()
{
	thread bank_to_defend();
	thread court_clips();
	thread gate_door_clips();
	thread spawn_resistance();
	thread defend_replenish_enemies();
	thread resistance_carry();
	thread defend_clean_up();
	thread defend_force_ai_to_reload();
}

#using_animtree( "generic_human" );
bank_to_defend()
{	
	flag_set( "FLAG_soap_blood_fx" );
	flag_clear( "FLAG_soap_walk_blood_drip_hip" );
	flag_set( "FLAG_soap_walk_blood_drip_elbow" );
	
	thread chase_crosscourt();
	thread hedge_destruction();
	thread crate_destruction();
	
	align_basketball = getstruct( "anim_align_basketball", "targetname" );

	level.price thread defend_price_dialogue();
	
	level.price delaythread(.05, ::play_sound_on_entity, "ch_pragueb_7_5_crosscourt_price" );
	align_basketball anim_single( [ level.price, level.soap ], "crosscourt" );
	
	level.soap ClearAnim( %root, 0 );
	
	level.price delaythread(.05, ::play_sound_on_entity, "ch_pragueb_7_5_crossplaza_price" );
	align_basketball anim_single( [ level.price, level.soap ], "crossplaza" );
	
	flag_set( "FLAG_defend_court_soap_reached_back_area" );
	
	level.price thread price_cover_selection();
	
	align_basketball thread anim_loop_solo( level.soap, "idle_fire_soap" );
	
	wait 5.0;
	
	align_basketball notify( "stop_loop" );
	
	align_basketball thread anim_loop_solo( level.soap, "idle_soap" );
}

resistance_carry()
{
	flag_wait( "uazs_arrive" );
	
	thread transition_to_safehouse();
	
	flag_wait( "FLAG_defend_court_soap_reached_back_area" );
	autosave_by_name( "autosave_soap_reached_end_area" );
	delayThread( 1.0, ::defend_soap_play_blood_pool_fx );
	flag_clear( "FLAG_soap_walk_blood_drip_elbow" );
	flag_set( "queue_soap_death_music" );
		
	align_soap_death = getstruct( "anim_align_soap_death", "targetname" );
	align_soap_death anim_reach_solo( level.price, "resistancearrive1" );
	
	s_align_soap = getstruct( "anim_align_basketball", "targetname" );
	s_align_soap notify( "stop_loop" );
	
	spawner = GetEnt( "resistance_medic1", "targetname" );
	medic_1 = spawner spawn_ai( true );
	
	spawner = GetEnt( "resistance_medic2", "targetname" );
	medic_2 = spawner spawn_ai( true );
	
	spawner = GetEnt( "resistance_medic3", "targetname" );
	medic_3 = spawner spawn_ai( true );
	
	spawner = GetEnt( "resistance_medic4", "targetname" );
	level.ai_medic4 = spawner spawn_ai( true );
	
	spawner = GetEnt( "resistance_leader", "targetname" );
	level.ai_leader = spawner spawn_ai( true );
	
	flag_set( "FLAG_resistance_help_soap_spawned" );
	
	group_1 = [ medic_1, medic_2, medic_3, level.m_link_gate, level.m_link_door ];
	group_2 = [ level.price, level.soap, level.ai_leader, level.ai_medic4 ];
	
	align_soap_death thread anim_single( group_1, "resistancearrive2" );
	align_soap_death anim_single( group_2, "resistancearrive1" );
	
	flag_set( "soap_carry" );
	thread resistance_building_guards();
	flag_set( "resistance_arrival" );
	
	// Group involved in carrying soap gets into place
	
	carry_group = [ level.price, level.soap, level.ai_leader, level.ai_medic4 ];
	align_soap_death thread anim_loop( carry_group, "idle_carry" );
	
	wait 1.0;
	
	// Wait till player looks at soap or price or timeout before going into safehouse
	
	range 	= 700;
	timeout = 20.0;
	
	level.price thread waittill_player_lookat_ent_timeout( range, timeout );
	level.soap thread waittill_player_lookat_ent_timeout( range, timeout );
	thread check_player_safehouse();
		
	flag_wait( "price_soap_leaving" );
		
	level.soap animscripts\shared::placeweaponon( level.soap.primaryweapon, "none" );
	
	thread clear_table_timer();
	thread medic_resistance_stop_carry_anims(); 
	exploder( 801 );
	
	// Pickup and carry soap to the table
	
	flag_set( "soap_pickedup" );
	flag_set( "FLAG_soap_walk_blood_drip_elbow" );
	flag_set( "FLAG_soap_walk_blood_drip_hip" );
	
	autosave_by_name( "autosave_soap_pickedup" );
	
	//carry_group = array_remove( carry_group, level.soap );
	
	align_basketball = getstruct( "anim_align_basketball", "targetname" );
	align_basketball notify( "stop_loop" );
	align_soap_death notify( "stop_loop" );

	array_thread( carry_group, ::play_carry_then_idle, align_soap_death );

	time = GetAnimLength( level.price getanim( "resistancecarry" ) );
	wait(time);
	
	flag_set( "soap_on_table" );
	flag_clear( "FLAG_soap_walk_blood_drip_elbow" );
	flag_clear( "FLAG_soap_walk_blood_drip_hip" );
	
	autosave_by_name( "autosave_soap_on_table" );
	
	// Blood spills over table fx
	exploder( 1105 );
	
	flag_wait( "in_safehouse" );
		
	battlechatter_off( "allies" );
		
	trig_medic_start = GetEnt( "trig_medic_start", "targetname" );
	trig_medic_start trigger_on();
		
	level notify( "end_fail_monitor" );
		
	//END OF SECTION
}


play_carry_then_idle( node )
{
	level endon( "FLAG_soap_death_started" );
	
	//play carry anim
	node anim_single_solo( self, "resistancecarry" );
	
	//soap  go into idle 
	//if( self == level.soap )
	//{ 		
		//go intro idle
	//	node anim_loop_solo( self, "soap_death_idle" );
	//}	
	
}	


defend_soap_play_blood_pool_fx()
{
	spots 	= getstructarray( "blood_pool", "targetname" );
	spot 	= array_keep_values( spots, [ "script_noteworthy" ], [ "defend" ] )[ 0 ];
	 
	PlayFX( getfx( "FX_soap_sit_blood_pool" ), spot.origin, AnglesToForward( spot.angles ), AnglesToUp( spot.angles ) );
}

medic_resistance_stop_carry_anims()
{
	thread medic_resistance_guy4_stop_carry_anim();
	thread medic_resistance_ai_leader_stop_carry_anim();
}

medic_resistance_guy4_stop_carry_anim()
{
	time = GetAnimLength( level.ai_medic4 getanim( "resistancecarry" ) );
	wait time;
	//level.ai_medic4 StopAnimScripted();
	nodes = GetNodeArray( "resistance_guy", "targetname" );
	nodes = array_index_by_script_index( nodes );
	level.ai_medic4 SetGoalNode( nodes[ 1 ] );
}

medic_resistance_ai_leader_stop_carry_anim()
{
	time = GetAnimLength( level.ai_leader getanim( "resistancecarry" ) );
	wait time - 4;
	level.ai_leader StopAnimScripted();
	//send him to start point of soap death idle.
	//align_soap_death 	= getstruct( "anim_align_soap_death", "targetname" );
	//align_soap_death anim_reach_solo( level.ai_leader, "soap_death_idle" );
	nodes = GetNodeArray( "resistance_guy", "targetname" );
	nodes = array_index_by_script_index( nodes );
	level.ai_leader SetGoalNode( nodes[ 2 ] );
}

spawn_resistance()
{
	/*
	killSpawner( 1 );  //tennis court
	killSpawner( 4 );  //bank
	*/
	
	thread medic_area_init();
	/*
	soldier_spawners = GetEntArray( "resistance_soldier", "targetname" );
	array_thread( soldier_spawners, ::spawn_ai );
	
	door_guard_spawner = GetEnt( "resist_door_guard", "targetname" );
	door_guard_spawner spawn_ai( true );
	*/
	wait 1.0;
	
	resistance_trigger = GetEnt( "triggercolor_resistance", "targetname" );
	resistance_trigger notify( "trigger" );
	
	resistance_trigger = GetEnt( "triggercolor_resistance2", "targetname" );
	resistance_trigger notify( "trigger" );
}

medic_area_init()
{
	maps\prague_escape_medic::setup_props();
	maps\prague_escape_medic::spawn_resistance_leader();
		
	thread clear_table();
	
	flag_wait( "soap_pickedup" );
	
	wait 1;
	
	maps\prague_escape_medic::spawn_resistance_guys();
	maps\prague_escape_medic::setup_heroes();
	
	flag_wait( "soap_on_table" );
	
	thread maps\prague_escape_medic::setup_soap_death_scene();
}

clear_table()
{
	align_props 				= getstruct( "anim_align_soap_death", "targetname" );
	align_clear_table 			= SpawnStruct();
	align_clear_table.origin 	= align_props.origin;
	align_clear_table.angles 	= align_props.angles;               

	props = [ level.m_link_beer1,
			  level.m_link_beer2,
			  level.m_link_beer3,
			  level.m_link_beer4,
		   	  level.m_link_cup1,
			  level.m_link_cup2,
			  level.m_link_cup3,
			  level.m_link_wine ];
	
	align_props anim_first_frame( props, "clear_table" );
	
	align_clear_table thread anim_loop_solo( level.ai_resistance_leader, "idle_clear_table" );
	
	flag_wait( "clear_table" );
	
	table_items = [ level.m_link_beer1,
					level.m_link_beer2,
					level.m_link_beer3,
					level.m_link_beer4,
					level.m_link_cup1,
					level.m_link_cup2,
					level.m_link_cup3,
					level.m_link_wine,
					level.ai_resistance_leader ];
	
	align_clear_table notify( "stop_loop" );
	align_clear_table anim_single( table_items, "clear_table" );	
	
	//TODO get the end pos of the table clear to match the death idle so we dont have this
	align_clear_table anim_reach_solo( level.ai_resistance_leader, "soap_death_idle" );
	
	//go right into death idle afterwards. He stops/starts the death idle with price in escape_medic.gsc
	align_clear_table thread anim_loop_solo( level.ai_resistance_leader, "soap_death_idle" );
	thread maps\prague_escape_medic::resistance_leader( align_clear_table );
}


clear_table_timer()
{
	wait 14;
	flag_set( "clear_table" );
}

price_cover_selection()
{
	self.fixednode = false;
	
	vol = GetEnt( "vol_price_defend", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	flag_wait( "btr_on_court" );
	
	self ClearGoalVolume();
	
	nd_cover = GetNode( "cover_price_soapcarry", "targetname" );
	self SetGoalNode( nd_cover );
	
	self waittill( "goal" );
	
	self.fixednode = true;
	
	flag_wait( "soap_carry" ); 
	
	self.fixednode = false;
}


resistance_building_guards()
{
	enter_gate_trigger = GetEnt( "trigger_resistance_guards", "targetname" );
	enter_gate_trigger waittill( "trigger" );
	
	guard_spawners = GetEntArray( "resistance_guard", "targetname" );
	array_thread( guard_spawners, ::spawn_ai );
}

defend_force_ai_to_reload()
{
	for ( ; !flag( "FLAG_soap_death_started" ); wait 5 )
	{
		ais = GetAIArray( "axis" );
		ais = array_randomize( ais ); 
		
		foreach ( i, guy in ais )
		{
			if ( i > ( ais.size / 2 ) )
				break;
			guy.bulletsinclip 	= RandomInt( 2 );
			guy.a.rockets 		= 0;
		}
	}
}

defend_replenish_enemies()
{
	flag_wait( "btr_arrives" );
	
	spawners = GetEntArray( "tactical_alley", "targetname" );
	spawners = add_to_array( spawners, GetEnt( "tactical_alley_cover", "targetname" ) );
	spawners = add_to_array( spawners, GetEnt( "tactical_alley_backup", "targetname" ) );
	spawners = add_to_array( spawners, GetEnt( "flanker_runner1", "script_noteworthy" ) );
	spawners = add_to_array( spawners, GetEnt( "flanker_runner2", "script_noteworthy" ) );
	spawners = add_to_array( spawners, GetEnt( "flanker_runner3", "script_noteworthy" ) );
	spawners = add_to_array( spawners, GetEnt( "flanker_runner4", "script_noteworthy" ) );

	array = [];
	
	for ( i = 0; i < spawners.size; i++ )
		array[ array.size ] = i;
		
	for ( ; !flag( "FLAG_soap_death_started" ) && array.size > 0; wait 0.05 )
	{
		if ( GetAIArray().size < 22 )
		{
			index = RandomInt( array.size );
			if ( IsDefined( spawners[ array[ index ] ] ) )
				spawners[ array[ index ] ] spawn_ai();
			array = array_remove_index( array, index );
			wait 0.05;
		}
	}

	spawners = [ GetEnt( "flanker_tennis_point", "targetname" ),
				 GetEnt( "flanker_tennis_fencer", "targetname" ) ];
	array = [];
	
	for ( i = 0; i < spawners.size; i++ )
		array[ array.size ] = i;
		
	for ( ; !flag( "FLAG_soap_death_started" ) && array.size > 0; wait 0.05 )
	{
		if ( GetAIArray().size < 22 )
		{
			index = RandomInt( array.size );
			if ( IsDefined( spawners[ array[ index ] ] ) )
				spawners[ array[ index ] ] spawn_ai();
			array = array_remove_index( array, index );
			wait 0.05;
		}
	}

	tennis_flood_trigger = GetEnt( "spawner_tennis", "script_noteworthy" );
	Assert( IsDefined( tennis_flood_trigger ) );
	tennis_flood_trigger notify( "trigger" );
	
	spawners 	= GetEntArray( "flanker_tennis_backup", "targetname" );
	array 		= [];
	
	for ( i = 0; i < spawners.size; i++ )
		array[ array.size ] = i;
		
	for ( ; !flag( "FLAG_soap_death_started" ) && array.size > 0; wait 0.05 )
	{
		if ( GetAIArray().size < 22 )
		{
			index = RandomInt( array.size );
			if ( IsDefined( spawners[ array[ index ] ] ) )
				spawners[ array[ index ] ] spawn_ai();
			array = array_remove_index( array, index );
			wait 0.05;
		}
	}
	
	alley_flood_trigger = GetEnt( "spawner_alley", "script_noteworthy" );
	Assert( IsDefined( alley_flood_trigger ) );
	alley_flood_trigger notify( "trigger" );

	spawners 	= GetEntArray( "flanker_recreation", "targetname" );
	array 		= [];
	
	for ( i = 0; i < spawners.size; i++ )
		array[ array.size ] = i;
		
	for ( ; !flag( "FLAG_soap_death_started" ) && array.size > 0; wait 0.05 )
	{
		if ( GetAIArray().size < 22 )
		{
			index = RandomInt( array.size );
			if ( IsDefined( spawners[ array[ index ] ] ) )
				spawners[ array[ index ] ] spawn_ai();
			array = array_remove_index( array, index );
			wait 0.05;
		}
	}
	
	rec_flood_trigger = GetEnt( "spawner_rec", "script_noteworthy" );
	Assert( IsDefined( rec_flood_trigger ) );
	rec_flood_trigger notify( "trigger" );
	
	bank_flood_trigger = GetEnt( "spawner_bank", "script_noteworthy" );
	Assert( IsDefined( bank_flood_trigger ) );
	bank_flood_trigger notify( "trigger" );
	
	tunnel_flood_trigger = GetEnt( "spawner_tunnel", "script_noteworthy" );
	Assert( IsDefined( tunnel_flood_trigger ) );
	tunnel_flood_trigger notify( "trigger" );
	
	flag_wait( "FLAG_resistance_help_soap_spawned" );
	
	spawners 	= GetEntArray( "defend_enemy", "targetname" );
	goal		= getstruct_delete( "defend_enemy_goal", "targetname" );
		
	for ( ; !flag( "FLAG_soap_death_started" ); wait 0.05 )
	{
		if ( GetAIArray().size < 22 )
		{
			spawner = spawners[ RandomInt( spawners.size ) ];
			spawner.count = 1;
			ai = spawner spawn_ai();
			ai SetGoalPos( goal.origin );
			ai set_goal_radius( goal.radius );
			wait 0.05;
		}
	}
	wait 0.05;
	override_array_call( GetAIArray( "axis" ), ::Delete );
}

chase_crosscourt()
{
	flag_wait_any( "chasers_go", "chasers_price" );
	
	thread monitor_player_distance( 1200 );
	thread chaser_bullets();
	thread explode_court_barrel();
		
	clip_street = GetEnt( "clip_bank_street", "targetname" );
	clip_street ConnectPaths();
	clip_street Delete();
	
	chase_spawners = GetEntArray( "court_chaser", "targetname" );
	array_thread( chase_spawners, ::spawn_ai );
	
	if ( level.player.origin[ 1 ] < level.price.origin[ 1 ] )
	{
		backup_spawners = GetEntArray( "court_chaser_backup", "targetname" );
		array_thread( backup_spawners, ::spawn_ai);
	}
	else
	{
		bank_spawners = GetEntArray( "court_chaser_bank", "targetname" );
		array_thread( bank_spawners, ::spawn_ai );
	}
	
	thread vehicle_reinforcement();
	
	wait 2.0;
	
	flag_set( "chasers" );
	flag_set( "queue_defend_music" );
}

vehicle_reinforcement()
{
	wait(10);
	thread spawn_uaz();
	thread spawn_btr();
	thread spawn_suv();
}

spawn_uaz()
{
	uaz1_spawner = GetEnt( "uaz1", "targetname" );
	uaz1_spawner thread add_spawn_function( ::uaz1_init );
	
	uaz2_spawner = GetEnt( "uaz2", "targetname" );
	uaz2_spawner thread add_spawn_function( ::uaz2_init );
	
	wait 5.0;
	uaz_trigger = GetEnt( "triggervehicle_uaz", "targetname" );
	uaz_trigger notify( "trigger" );
	
	wait 20.0;
	flag_set( "uazs_arrive" );
	
	// Clean up
	/*
	uaz_trigger Delete();
	uaz1_spawner Delete();
	uaz2_spawner Delete();
	*/
}

uaz1_init()
{
	self endon( "death" );
	
	//self.veh_pathtype = "constrained";
	
	self thread uaz_on_death_set_flags( [ "uaz1_unloaded", "uazs_arrive" ] );
	
	arrival_node = GetVehicleNode( "uaz_arrive", "targetname" );
	arrival_node waittill( "trigger" );
	
	flag_set( "uazs_arrive" );
	
	self waittill( "reached_end_node" );
	
	wait 1;
	
	self vehicle_unload();
	
	self waittill( "unloaded" );
	
	wait 1;
	
	flag_set( "uaz1_unloaded" );
}


uaz2_init()
{
	self endon( "death" );
	
	//self.veh_pathtype = "constrained";
	
	self thread uaz_on_death_set_flags( [ "uaz2_unloaded" ] );
	
	self waittill( "reached_end_node" );
	
	hydrant = getstruct_delete( "struct_hydrant_court", "targetname" );
	clip = GetEnt( "clip_hydrant_defend", "targetname" );
	clip Delete();
	
	wait 0.5;
	
	RadiusDamage( hydrant.origin, 35, 450, 350 );
	
	level notify( "plug_hydrant_leak" );
	
	wait 0.5;
	
	self vehicle_unload();
	
	self waittill( "unloaded" );
	
	wait 1;
	
	flag_set( "uaz2_unloaded" );
}

uaz_on_death_set_flags( flags )
{
	Assert( IsDefined( flags ) && IsArray( flags ) );
	self waittill( "death" );
	foreach ( flag in flags )
		flag_set( flag );
}

spawn_btr()
{
	btr_spawner = GetEnt( "btr", "targetname" );
	btr_spawner thread add_spawn_function( ::btr_init );
	
	flag_wait( "uazs_arrive" );
	wait 5.0;
	btr_trigger = GetEnt( "triggervehicle_btr", "targetname" );
	btr_trigger notify( "trigger" );
	
	flag_wait( "btr_on_court" );
	wait 10.0;
	
	btr_spawner_2 = GetEnt( "defend_btr", "targetname" );
	Assert( IsDefined( btr_spawner_2 ) );
	
	btr = btr_spawner_2 spawn_vehicle();
	btr.veh_pathtype = "constrained";
	btr thread gopath();
	btr thread btr_attack_player();
	
	// Clean up
	/*
	btr_trigger Delete();
	btr_spawner Delete();
	*/
}

btr_init()
{
	self.veh_pathtype = "constrained";
	
	self.mgturret[ 0 ] notify( "stop_burst_fire_unmanned" );
	
	self SetCanDamage( false );
	self SetTurretTargetEnt( level.player );
	
	self waittill( "reached_end_node" );
	
	flag_set( "btr_arrives" );
	
	self btr_start_attack();
	
	wait 1;
	/*
	backup_node = GetVehicleNode( "btr_backup", "targetname" );
	Assert( IsDefined( backup_node ) );
	self AttachPath ( backup_node );
	self.veh_transmission = "reverse";
	self vehicle_wheels_backward();
	
	self waittill( "reached_end_node" );
	
	self.veh_transmission = "forward";
	self vehicle_wheels_forward();
	
	stop_node = GetVehicleNode( "btr_stop", "targetname" );
	Assert( IsDefined( stop_node ) );
	self AttachPath ( stop_node );
	*/
	wait 1.0;
	
	turn_node = GetVehicleNode( "btr_turn", "targetname" );
	Assert( IsDefined( turn_node ) );
	self AttachPath ( turn_node );
		
	node = GetVehicleNode( "btr_fence", "targetname" );
	Assert( IsDefined( node ) );
	node waittill( "trigger" );
	
	self thread knock_down_hoop();
		
	on_court_node = GetVehicleNode( "btr_on_court", "targetname" );
	Assert( IsDefined( on_court_node ) );
	on_court_node waittill( "trigger" );
	
	flag_set( "btr_on_court" );
	
	self thread resistance_rpg_attack();
	self thread btr_attack_rooftop();
	
	at_end_node = GetVehicleNode( "btr_end", "targetname" );
	at_end_node waittill( "trigger" );
	
	self thread btr_target_select();
	
	wait 5;
	
	resistance_shutters();
	
	self thread resistance_gun_attack();
	
	self notify( "target_resistance" );
	
	self btr_hit_by_molotov();
	self notify( "target_building" );
	wait 1.0;
	self btr_attack_resistance_in_window();
	self thread btr_attack_building();
	
	wait 2;
	
	self thread btr_rpg_death();
		
	flag_wait( "resistance_arrival" );
	
	wait 2;
	
	flag_set( "resistance_mortal" );
}

btr_attack_player()
{
	self endon( "death" );
	
	mg_turret 						= self.mgturret[ 0 ];
	mg_turret.accuarcy 				= 0.1; //default is 0.38
	mg_turret.aiSpread 				= 10; //default is 2
	self.main_turret[ "aimspeed" ] 	= 1;
	
	target 	= level.player;
	
	mg_turret notify( "stop_burst_fire_unmanned" );
	
	offset_range 	= 512;
	time			= 10;
	elapsed			= 0;
	
	for( ; !flag( "FLAG_soap_death_started" ); )
	{
		wait 1;
		
		elapsed = lt_op( elapsed + 1, 20 );
		
		mg_turret thread maps\_mgturret::burst_fire_unmanned();
		
		shots 	= RandomIntRange( 10, 15 );
		range 	= ( 1 - ( elapsed / time ) ) * offset_range;
		offset 	= random_vector( -1 * range, range );
		offset  = ( offset[ 0 ], offset[ 1 ], gt_op( offset[ 2 ], 0 ) );
			
		for ( i = 0; i < shots; i++ )
		{	
			self SetTurretTargetEnt( target, offset );
			self waittill( "turret_on_target" );
			self FireWeapon();
			wait 0.05;
		}
		
		random_time = RandomFloatRange( 1.0, 2.0 );
		elapsed 	= lt_op( elapsed + random_time, 20 );
		wait random_time;
		
		mg_turret notify( "stop_burst_fire_unmanned" );
	}
	
}

btr_rpg_death()
{
	self waittill_player_lookat( 0.9, 0.1, true, 2 );
	
	rpg_starts = [ -1,
				   getstruct( "rpg_start1", "targetname" ),
				   getstruct( "rpg_start2", "targetname" ),
				   getstruct( "rpg_start3", "targetname" ) ];
	
	MagicBullet( "rpg_straight", rpg_starts[ 1 ].origin, ( self.origin + ( 0, -50, 150 ) ) );
	level thread court_chunk_1();
	
	flag_set( "rpg_fired" );
	
	wait 1.5;
	
	self SetCanDamage( true );
	
	MagicBullet( "rpg_straight", rpg_starts[ 3 ].origin, self.origin );
	
	level notify( "LISTEN_defend_btr_stop_impact_fx" );
	
	self waittill( "damage" );
	
	self DoDamage( self.health, self.origin );
	
	wait 1.5;
	
	MagicBullet( "rpg_straight", rpg_starts[ 2 ].origin, ( self.origin + ( 140, -100, 0 ) ) );
	level thread court_chunk_2();
	
	flag_set( "btr_destroyed" );
	
	level thread molotov_barrage();
}


btr_attack_resistance()
{
	self endon( "target_building" );
	
	mg_turret = self.mgturret[0];
	mg_turret notify( "stop_burst_fire_unmanned" );
	
	while( 1 )
	{
		allies = GetAIArray( "allies" );
		target = allies[ RandomInt( allies.size ) ];
		
		wait 1;
		
		mg_turret thread maps\_mgturret::burst_fire_unmanned();
		
		shots = RandomIntRange( 5, 9 );
		
		for ( i = 0; i < shots; i++ )
		{
			offset = ter_op( i == 4, ( 0, 0, 0 ), ( RandomIntRange( 20, 50 ), RandomIntRange( -40, -20 ), RandomIntRange( 50, 100 ) ) ); 
			
			self SetTurretTargetEnt( target, offset );
			self waittill( "turret_on_target" );
			self FireWeapon();
			wait 0.1;
		}
		
		mg_turret notify( "stop_burst_fire_unmanned" );
		
		wait RandomFloatRange( 1.5, 2.0 );
	}
}


btr_target_select()
{
	self endon( "target_resistance" );
	
	mg_turret 						= self.mgturret[ 0 ];
	mg_turret.accuarcy 				= 0.1; //default is 0.38
	mg_turret.aiSpread 				= 10; //default is 2
	self.main_turret[ "aimspeed" ] 	= 1;
	
	target 	= level.player;
	
	mg_turret notify( "stop_burst_fire_unmanned" );
	
	while( 1 )
	{
		target = ter_op( RandomInt( 2 ), level.player, level.price );

		wait 1;
		
		mg_turret thread maps\_mgturret::burst_fire_unmanned();
		
		shots = RandomIntRange( 5, 9 );
		
		for ( i = 0; i < shots; i++ )
		{
			offset = ter_op( i == 7, ( 0, 0, 0 ), ( RandomIntRange( 20, 50 ), RandomIntRange( -40, -20 ), RandomIntRange( 50, 100 ) ) ); 

			self SetTurretTargetEnt( target, offset );
			self waittill( "turret_on_target" );
			self FireWeapon();
			wait 0.1;
		}
		wait RandomFloatRange( 1.0, 2.0 );
		
		mg_turret notify( "stop_burst_fire_unmanned" );
	}
}


btr_start_attack()
{
	mg_turret 			= self.mgturret[0];
	mg_turret.accuarcy 	= 0.1; //default is 0.38
	
	mg_turret notify( "stop_burst_fire_unmanned" );
	
	wait 1;
	
	target 	= GetEnt( "btr_strafe_target", "targetname" );
	x 		= 0;
	z 		= 0;
	
	level thread lion_destruction();
	
	for ( i = 0; i < 60; i++ )
	{
		self SetTurretTargetEnt( target, ( x, 0, z ) );
		self waittill( "turret_on_target" );
		self FireWeapon();
	
		wait 0.1;
		
		x += 10;
		z = RandomIntRange( -35, 25 );
	}
}

btr_hit_by_molotov()
{
	start 	= getstruct( "molotov_start1", "targetname" );
	end 	= Spawn( "script_origin", self.origin + ( -100, 40, 100 ) );
	
	molotov_goes_jeremy( start, end );
	end Delete();
}


btr_attack_rooftop()
{
	mg_turret 			= self.mgturret[0];
	mg_turret.accuarcy 	= 0.1; //default is 0.38
	
	mg_turret notify( "stop_burst_fire_unmanned" );
	
	wait 1;
	
	_target = getstruct( "resist_rpg1", "targetname" );
	target 	= Spawn( "script_origin", _target.origin );
	
	self SetTurretTargetEnt( target );
		
	self waittill( "turret_on_target" );
	
	thread btr_attack_rooftop_fx();
	
	for ( i = 0; i < 12; i++ )
	{
		self FireWeapon();
		wait 0.1;
	}
	
	// Clean up
	
	self waittill( "death" );
	
	target Delete();
}

btr_attack_rooftop_fx()
{
	impact = GetEnt( "tag_rooftop_impact", "targetname" );
	
	wait 0.6;
	PlayFXOnTag( getfx( "btr_cannon_impact_burst" ), impact, "tag_origin" );
	wait 0.5;
	PlayFXOnTag( getfx( "btr_cannon_impact_burst" ), impact, "tag_origin" );
	
	impact Delete();
}

btr_attack_building()
{
	self endon( "death" );
	
	impact_spots = [ -1,
					 GetEnt( "tag_btr_impact2", "targetname" ),
					 GetEnt( "tag_btr_impact3", "targetname" ),
					 GetEnt( "tag_btr_impact4", "targetname" ),
					 GetEnt( "tag_btr_impact5", "targetname" ),
					 GetEnt( "tag_btr_impact6", "targetname" ),
					 GetEnt( "tag_btr_impact7", "targetname" ),
					 GetEnt( "tag_btr_impact8", "targetname" ) ];
	impact_spots = array_remove_index( impact_spots, 0 );
	
	mg_turret = self.mgturret[ 0 ];
	mg_turret SetMode( "manual" );
	
	for ( shots = RandomIntRange( 8, 21 ); IsDefined( self ); )
	{
		for( i = 1; i < 8; i++ )
		{
			mg_turret StartFiring();
			
			for( x = 0; x < shots; x++ )
			{
				self SetTurretTargetEnt( impact_spots[ i ], random_vector( 5, 25 ) );
				mg_turret SetTargetEntity( impact_spots[ i ] );
				
				level thread btr_impact_fx( impact_spots[ i ] );
				
				self waittill( "turret_on_target" );
			
				self FireWeapon();
				
				wait 0.1;
			}
			
			level notify( "LISTEN_defend_btr_stop_impact_fx" );
			
			mg_turret StopFiring();
			wait RandomFloatRange( 1.0, 1.5 );
		}
	}
	
	foreach ( spot in impact_spots )
		spot Delete();
}

btr_attack_resistance_in_window()
{
	rpg_spot 	= getstruct( "rpg_start1", "targetname" );
	btr_target 	= Spawn( "script_origin", rpg_spot.origin );
	
	self thread btr_shoot( btr_target );
	
	btr_impact1 = GetEnt( "tag_btr_impact1", "targetname" );
	
	level thread btr_impact_fx( btr_impact1 );
		
	wait 0.5;
	
	flag_set( "kill_resist_window" );
	
	exploder( 830 );	
}

btr_impact_fx( ent )
{
	level endon( "LISTEN_defend_btr_stop_impact_fx" );
	
	for ( ; ; wait 2 )
		PlayFXOnTag( getfx( "btr_cannon_impact_burst" ), ent, "tag_origin" );
}

spawn_suv()
{
	suv = GetEnt( "suv_flank", "targetname" );
	suv thread add_spawn_function( ::suv_init );
	
	flanker_suv_spawners = GetEntArray( "passenger_side", "script_noteworthy" );
	array_thread( flanker_suv_spawners, ::add_spawn_function, ::suv_passengerside_init );
	
	driverside_spawners = GetEntArray( "driver_side", "script_noteworthy" );
	array_thread( driverside_spawners, ::add_spawn_function, ::suv_driverside_init );
	
	flag_wait( "btr_on_court" );
	
	suv_trigger = GetEnt( "triggervehicle_flanker_suv", "targetname" );
	suv_trigger notify( "trigger" );
}

suv_init()
{
	self endon( "death" );
	
	self thread suv_on_damage();
	self thread suv_on_death();
	self thread suv_toggle_invulnerability();
	
	self waittill( "reached_end_node" );
	
	wait 1.0;
	
	self vehicle_unload( "passenger_side" );
	
	self waittill( "unloaded" );
	
	flag_set( "suv_flank_unloaded" );
	
	wait 3.0;
	
	reverse_node = GetVehicleNode( "tennis_reverse", "targetname" );
	self AttachPath ( reverse_node );
	self.veh_transmission = "reverse";
	self vehicle_wheels_backward();
	
	self waittill( "reached_end_node" );
	
	wait 0.5;
	
	forward_node = GetVehicleNode( "tennis_forward", "targetname" );
	self AttachPath ( forward_node );
	self.veh_transmission = "forward";
	self vehicle_wheels_forward();
	
	self waittill( "reached_end_node" );
	
	wait 1;
	
	self vehicle_unload();
	
	self waittill( "unloaded" );
	
	flag_set( "suv_final_unloaded" );
}

suv_on_damage()
{
	self endon( "death" );
	
	damage = ( self.script_startinghealth * 0.5 );
	
	for( ; ; )
	{
		self waittill( "damage", amount, attacker, direction, point, type );
		
		if ( compare( type, "MOD_GRENADE" ) )
		{
			origin = ( 0, 0, 0 );
			if ( IsDefined( attacker ) )
				origin = attacker.origin;
			self DoDamage( damage, origin );
		}
	}
}

suv_on_death()
{
	level endon( "suv_flank_unloaded" );
	
	self waittill( "death" );
	
	flag_set( "suv_flank_unloaded" );
}


suv_toggle_invulnerability()
{
	self endon( "death" );
	
	node = GetVehicleNode( "start_safe1", "targetname" );
	Assert( IsDefined( node ) );
	node waittill( "trigger" );
	self SetCanDamage( false );
	
	node = GetVehicleNode( "end_safe1", "targetname" );
	Assert( IsDefined( node ) );
	node waittill( "trigger" );
	self SetCanDamage( true );
	
	node = GetVehicleNode( "start_safe2", "targetname" );
	Assert( IsDefined( node ) );
	node waittill( "trigger" );
	self SetCanDamage( false );
	
	node = GetVehicleNode( "end_safe2", "targetname" );
	Assert( IsDefined( node ) );
	node waittill( "trigger" );
	self SetCanDamage( true );
}


suv_passengerside_init()
{
	self endon( "death" );
	
	self.goalradius 		= 32;
	self.animname 			= "enemy";
	self.disablearrivals 	= true;
	
	flag_wait( "suv_flank_unloaded" );
	
	self thread sprint_for_time( 5 );
	
	self waittill( "goal" );
	
	self.disablearrivals = false;
	
	vol = getent( "vol_price_defend", "targetname" );
	self SetGoalVolumeAuto( vol );
}


suv_driverside_init()
{
	self endon( "death" );
	
	self.ignoresuppression 	= true;
	self.goalradius 		= 32;
	
	flag_wait( "suv_final_unloaded" );
	
	vol = getent( "vol_price_defend", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	self waittill( "goal" );
	
	self.ignoresuppression = false;
}

lion_destruction()
{
	statue_destroyed = GetEnt( "fxanim_prague2_lion_statue_mod", "targetname" );
	statue_destroyed Show();
	
	statue_pristine = GetEnt( "ctl_statue_lion_stone", "targetname" );
	statue_pristine Delete();	
	
	wait 1;
	
	statue_tag = GetEnt( "tag_lion_statue", "targetname" );
	
	PlayFXOnTag( getfx( "lion_statue_dest" ) , statue_tag, "tag_origin" );
	
	statue_destroyed UseAnimTree( level.scr_animtree[ "script_model" ] );
	statue_destroyed.animname = "lion";
	statue_destroyed anim_single_solo( statue_destroyed, "lion_statue_destroy" );
}


resistance_rpg_attack()
{
	rpg_spots = [ getstruct( "resist_rpg1", "targetname" ),
				  getstruct( "resist_rpg2", "targetname" ),
				  getstruct( "molotov_start2", "targetname" ),
				  getstruct( "molotov_start1", "targetname" ) ];
	
	MagicBullet( "rpg_straight", rpg_spots[ 0 ].origin, self.origin + ( 250, 150, 200 ) );
	wait 1;
	MagicBullet( "rpg_straight", rpg_spots[ 0 ].origin, self.origin + ( -100, 0, -150 ) );
	wait 1.5;
	MagicBullet( "rpg_straight", rpg_spots[ 0 ].origin, self.origin + ( 0, 0, 150 ) );
	wait 1;
	MagicBullet( "rpg_straight", rpg_spots[ 0 ].origin, self.origin + ( 0, 150, 80 ) );
		
	flag_set( "resistance_attacks" );
}


resistance_gun_attack()
{
	gunfire_spots = getstructarray_delete( "resist_gunfire", "targetname" );
	
	foreach( spots in gunfire_spots )
	{
		thread resistance_burst_gunfire( spots );
		thread resistance_grenade_attack( spots );
	}
}


resistance_burst_gunfire( spot )
{
	Assert( IsDefined( spot ) );
		
	flag_wait( "resistance_attacks" );
	
	wait RandomFloatRange( 0.1, 1.3 );
	
	weapons = [ "ak47",
				"ak74u",
				"m4m203_reflex",
				"g36c",
				"pecheneg" ];
	
	for( ; !flag( "FLAG_soap_death_started" ); wait RandomIntRange( 2, 5 ) )
	{
		enemies = GetAIArray( "axis" );
		
		if ( enemies.size )
		{
			enemy 	= enemies[ RandomInt( enemies.size ) ];
			weapon 	= weapons[ RandomInt( weapons.size ) ];
			shots 	= RandomIntRange( 3, 9 );
		
			for ( i = 0; i < shots; i++ )
			{
				if ( IsDefined( enemy ) )
				{
					offset = random_int_vector( -40, 40 );
				
					MagicBullet( weapon, spot.origin, ( enemy.origin + offset ) );
				
					if ( cointoss() )
						BulletTracer( spot.origin, ( enemy.origin + offset ), true );
					wait 0.2;
				}
			}
		}
	}
}


resistance_grenade_attack( spot )
{
	Assert( IsDefined( spot ) );
	
	level endon( "in_safehouse" );
	
	wait RandomFloatRange( 2.0, 6.0 );
	
	for( ; !flag( "FLAG_soap_death_started" ); wait 0.05 )
	{
		enemies = GetAIArray( "axis" );
		
		if ( enemies.size )
		{
			enemy = enemies[ RandomInt( enemies.size ) ];

			if ( IsDefined( enemy ) && IsAlive( enemy ) )
				MagicGrenade( "fraggrenade", spot.origin, ( enemy.origin + random_int_vector( -40, 40 ) ) );
			wait RandomFloatRange( 5.0, 8.0 );
		}
	}
}

defend_price_dialogue()
{
	// Head for that building - Northwest corner!	
	self dialogue_queue( "presc_pri_headforthat" );
	
	flag_wait( "chasers" );
	
	wait 1;
	
	// Behind us!!!	
	self dialogue_queue( "presc_pri_behindus" );
	
	wait 0.5;
	
	battlechatter_on( "allies" );
	level.price set_ai_bcvoice( "taskforce" );
	
	// Yuri - Cover our six!!!	
	self dialogue_queue( "presc_pri_coveroursix" );
	
	wait(4);
	//self dialogue_queue( "presc_pri_itstheresistance2" );
	
	flag_wait( "uazs_arrive" );
	
	// UAZs bringing in reinforcements!	
	self dialogue_queue( "presc_pri_uazreinforce" );
	
	wait 5;
	
	// There's too many!!! We have to make a stand!
	// CHANGE: "Too many!!!, fall back!"
	self dialogue_queue( "presc_pri_therestoomany" );
	/*
	flag_wait( "enter_alley" );
	
	self dialogue_queue( "presc_pri_leftflank" );
	
	waittill_aigroupcount( "group_alley_tactical", 3 );
	
	flag_wait( "start_runners" );
	
	wait 3;
	
	self dialogue_queue( "presc_pri_morereinforcements" );
	
	flag_wait( "start_right_flank" );
	
	wait 2;
	
	self dialogue_queue( "presc_pri_illcoverleft" );
	*/
	//flag_wait( "suv_flank_unloaded" );
	
	//wait 2.0;
	
	// They're all around us!
	//self dialogue_queue( "presc_pri_allaroundus" );
	
	// NEED: "Fallback!"
	//self dialogue_queue( "presc_pri_keeponem2" );
	
	flag_wait( "btr_arrives" );
	/*
	level.soap dialogue_queue( "presc_mct_bringingbtr" );
	
	wait 0.5;
	
	level.soap dialogue_queue( "presc_mct_damnit" );
	
	wait 1;
	
	level.soap dialogue_queue( "presc_mct_leaveme" );
	
	wait 0.5;
	
	self dialogue_queue( "presc_pri_notanoption" );
	*/
	flag_wait( "FLAG_defend_btr_knocks_down_fence" );
	
	
	self dialogue_queue( "presc_pri_itstheresistance2" );
	
	wait(1);
	// Hold em back!
	self dialogue_queue( "presc_pri_holdemback" );
	
	flag_wait( "resistance_attacks" );
	
	// RPGS firing from the building on our left!	
	//self dialogue_queue( "presc_pri_rpgsonleft" );
	
	//wait 0.5;
	
	// Behind us!!!
	//self dialogue_queue( "presc_pri_behindus" );
	
	//wait 0.3;
	
	// It's the resistance!
	//self dialogue_queue( "presc_pri_itstheresistance2" );
	
	wait 1;
	
	// Yuri!  Get over here!!
	self dialogue_queue( "presc_pri_movesoap" );
	
	flag_wait( "price_soap_leaving" );
	
	// We've got wounded... Help him!	
	self dialogue_queue( "presc_pri_helphim" );
	
	flag_wait( "soap_pickedup" );
	
	self thread defend_price_enter_safehouse_dialogue();
	
	wait 3;
	
	// Okay! We're leaving!
	self dialogue_queue( "presc_pri_wereleaving" );
	
	wait 7;
	
	// Get him on the table!
	self dialogue_queue( "presc_pri_gethimontable" );
}


defend_price_enter_safehouse_dialogue()
{
	level endon( "in_safehouse" );
	
	self dialogue_queue( "presc_pri_letsgoletsgo" );
	
	range = 500;
	
	for ( prev_index = 0; !flag( "in_safehouse" ); wait 0.1 )
	{
		if ( dsq_2d_ents_gt( level.player, level.soap, range ) )
		{
			current_index = RandomInt( 3 );
			
			if ( current_index != prev_index )
			{
				switch( current_index )
				{
					case 0:
						self dialogue_queue( "presc_pri_yurimoveyour" );
						break;
				
					case 1:
						self dialogue_queue( "presc_pri_yurigetoverhere2" );
						break;
				
					case 2:
						self dialogue_queue( "presc_pri_keepup" );
						break;
				}
				prev_index = current_index;
				
				wait RandomFloatRange( 4.0, 5.5 );
			}
		}
	}
}


transition_to_safehouse()
{
	flag_wait( "soap_on_table" );
	
	safehouse_trigger = GetEnt( "trigger_in_safehouse", "targetname" );
	
	for( ; !level.player IsTouching( safehouse_trigger ); wait 0.05 ){}
	flag_set( "in_safehouse" );
}

defend_spawnfuncs()
{
	// First set of spawners while player the back of the courts
	
	spawners = array_combine( GetEntArray( "court_chaser", "targetname" ), GetEntArray( "court_chaser_bank", "targetname" ) );
	spawners = array_combine( spawners, GetEntArray( "court_chaser_backup", "targetname" ) );
	
	spawners_mantle_b = array_keep_values( spawners, [ "script_noteworthy" ], [ "mantleB" ] );
	array_thread( spawners_mantle_b, ::add_spawn_function, ::spawnfunc_chaser, "court_mantle_B" );
	
	spawners_mantle_c = array_keep_values( spawners, [ "script_noteworthy" ], [ "mantleC" ] );
	array_thread( spawners_mantle_c, ::add_spawn_function, ::spawnfunc_chaser, "court_mantle_C" );
	
	spawners_mantle_d = array_keep_values( spawners, [ "script_noteworthy" ], [ "mantleD" ] );
	array_thread( spawners_mantle_d, ::add_spawn_function, ::spawnfunc_chaser, "court_mantle_D" );
	
	spawners_mantle_e = array_keep_values( spawners, [ "script_noteworthy" ], [ "mantleE" ] );
	array_thread( spawners_mantle_e, ::add_spawn_function, ::spawnfunc_chaser, "court_mantle_E" );
	
	spawners_mantle_f = array_keep_values( spawners, [ "script_noteworthy" ], [ "mantleF" ] );
	array_thread( spawners_mantle_f, ::add_spawn_function, ::spawnfunc_chaser, "court_mantle_F" );
	
	spawners_mantle_g = array_keep_values( spawners, [ "script_noteworthy" ], [ "mantleG" ] );
	array_thread( spawners_mantle_g, ::add_spawn_function, ::spawnfunc_chaser, "court_mantle_G" );
	
	// Second Set
		
	alpha_spawners = GetEntArray( "uaz_team_alpha", "script_noteworthy" );
	array_thread( alpha_spawners, ::add_spawn_function, ::spawnfunc_team, "alpha" );
	
	bravo_spawners = GetEntArray( "uaz_team_bravo", "script_noteworthy" );
	array_thread( bravo_spawners, ::add_spawn_function, ::spawnfunc_team, "bravo" );
	
	alley_cover_spawners = GetEnt( "tactical_alley_cover", "targetname" );
	alley_cover_spawners thread add_spawn_function( ::spawnfunc_alley_cover );
	
	alley_backup_spawners = GetEnt( "tactical_alley_backup", "targetname" );
	alley_backup_spawners thread add_spawn_function( ::spawnfunc_alley_backup );
	
	tactical_alley_spawners = GetEntArray( "tactical_alley", "targetname" );
	array_thread( tactical_alley_spawners, ::add_spawn_function, ::spawnfunc_alley_charge );
	
	alley_sprinter_spawners = GetEnt( "alley_sprinter", "script_noteworthy" );
	alley_sprinter_spawners thread add_spawn_function( ::spawnfunc_alley_sprinter );
	
	flanker_alley_spawners = GetEntArray( "flanker_alley", "targetname" );
	array_thread( flanker_alley_spawners, ::add_spawn_function, ::spawnfunc_flanker_alley );
	
	flanker_tunnel_spawners = GetEntArray( "flanker_tunnel", "targetname" );
	array_thread( flanker_tunnel_spawners, ::add_spawn_function, ::spawnfunc_flanker_tunnel );
	
	flanker_bank_spawners = GetEntArray( "flanker_bank", "targetname" );
	array_thread( flanker_bank_spawners, ::add_spawn_function, ::spawnfunc_flanker_bank );
	
	flanker_spawners = GetEntArray( "flanker_runner", "targetname" );
	array_thread( flanker_spawners, ::add_spawn_function, ::spawnfunc_flanker_runner );
	
	tennis_point_spawners = GetEnt( "flanker_tennis_point", "targetname" );
	tennis_point_spawners thread add_spawn_function( ::spawnfunc_tennis_point );
	
	tennis_fencer_spawners = GetEnt( "flanker_tennis_fencer", "targetname" );
	tennis_fencer_spawners thread add_spawn_function( ::spawnfunc_tennis_fencer );
	
	tennis_spawners = GetEntArray( "flanker_tennis", "targetname" );
	array_thread( tennis_spawners, ::add_spawn_function, ::spawnfunc_tennis );
	
	tennis_backup_spawners = GetEntArray( "flanker_tennis_backup", "targetname" );
	array_thread( tennis_backup_spawners, ::add_spawn_function, ::spawnfunc_tennis_backup );
	
	flanker_recreation_spawners = GetEntArray( "flanker_recreation", "targetname" );
	array_thread( flanker_recreation_spawners, ::add_spawn_function, ::spawnfunc_flanker_rec );
	
	recreation_spawners = GetEntArray( "spawner_rec", "targetname" );
	array_thread( recreation_spawners, ::add_spawn_function, ::spawnfunc_recreation );
	
	// resistance
	
	resistance_spawner = GetEnt( "resistance_victim", "targetname" );
	resistance_spawner add_spawn_function( ::spawnfunc_resist_victim );
	
	resistance_spawners = GetEntArray( "resistance_soldier", "targetname" );
	array_thread( resistance_spawners, ::add_spawn_function, ::spawnfunc_resistance_soldier );
	
	door_guard_spawners = GetEnt( "resist_door_guard", "targetname" );
	door_guard_spawners add_spawn_function( ::spawnfunc_door_guard );
	
	window_spawners = GetEntArray( "resistance_window", "targetname" );
	array_thread( window_spawners, ::add_spawn_function, ::spawnfunc_window );
	
	medic1_spawner = GetEnt( "resistance_medic1", "targetname" );
	medic1_spawner add_spawn_function( ::spawnfunc_medic, "resistance1" );
	
	medic2_spawner = GetEnt( "resistance_medic2", "targetname" );
	medic2_spawner add_spawn_function( ::spawnfunc_medic, "resistance2" );
	
	medic3_spawner = GetEnt( "resistance_medic3", "targetname" );
	medic3_spawner add_spawn_function( ::spawnfunc_medic, "resistance3" );
	
	medic4_spawner = GetEnt( "resistance_medic4", "targetname" );
	medic4_spawner add_spawn_function( ::spawnfunc_medic, "resistance4" );
	
	leader_spawner = GetEnt( "resistance_leader", "targetname" );
	leader_spawner add_spawn_function( ::spawnfunc_leader );
	
	guard_spawners = GetEntArray( "resistance_guard", "targetname" );
	array_thread( guard_spawners, ::add_spawn_function, ::spawnfunc_resistance_guard );
}


spawnfunc_chaser( anim_scene )
{
	self endon( "death" );
	
	self.goalradius 		= 32;
	self.ignoresuppression 	= true;
	self.allowdeath 		= true;
	self.animname 			= "enemy";
	self.disableLongDeath 	= true;
	
	self thread sprint_for_time( 5 );
	
	align_basketball = getstruct( "anim_align_basketball", "targetname" );
	
	align_basketball anim_reach_solo( self, anim_scene );
	align_basketball anim_single_solo( self, anim_scene );
	
	vol = getent( "vol_court", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	self waittill( "goal" );
		
	self.ignoresuppression = false;
}

spawnfunc_team( team )
{
	team = ter_op( IsDefined( team ), team, "alpha" );
	
	self endon( "death" );
	self endon( "disperse" );
	
	self thread monitor_team( team );
	
	self.ignoresuppression 	= true;
	self.allowdeath 		= true;
	self.animname 			= "enemy";
	self.disableLongDeath 	= true;
	
	align_anim = getstruct( "anim_align_basketball", "targetname" );
	
	midcourt_volume = GetEnt( "vol_" + team + "_midcourt", "targetname" );
	sideline_volume = GetEnt( "vol_" + team + "_sideline", "targetname" );
	
	start_pos 	= self.script_startingposition;
	index		= [ "E", "C", "B", "D" ];
	
	flag_wait( "uaz2_unloaded" );
	
	align_anim anim_reach_solo( self, "court_mantle_" + index[ start_pos ] );
	align_anim anim_single_solo( self, "court_mantle_" + index[ start_pos ] );
	
	self cqb_walk( "on" );
	
	self.goalradius = 32;
	self SetGoalVolumeAuto( midcourt_volume );
	
	self waittill( "goal" );
	
	self SetGoalVolumeAuto( sideline_volume );
	
	flag_wait( "advance_done" );
	
	self cqb_walk( "off" );
	self.ignoresuppression = false;
	
	defend_volume = GetEnt( "vol_defend", "targetname" );
	self SetGoalVolumeAuto( defend_volume );
}

monitor_team( team )
{
	Assert( IsDefined( team ) );
	
	self endon( "death" );
	
	waittill_aigroupcount( "group_" + team, 2 );
	
	self notify( "disperse" );
	self cqb_walk( "off" );
	self.ignoresuppression = false;
	
	vol = GetEnt( "vol_alley", "targetname" );
	self SetGoalVolumeAuto( vol );
}

spawnfunc_alley_cover()
{
	self endon( "death" );
	
	self.animname = "enemy";
	self.goalradius = 32;
	self.disableLongDeath = true;
	
	self thread set_flag_on_death( "enter_alley" );
	
	s_align = getstruct( "anim_align_basketball", "targetname" );
	s_align anim_reach_solo( self, "box_traverse_C" );
	s_align anim_single_solo( self, "box_traverse_C" );
		
	nd_cover = GetNode( self.script_noteworthy, "targetname" );
	self setgoalnode ( nd_cover );
	
	flag_set( "enter_alley" );
	
	self waittill( "goal" );
	
	self.fixednode = true;
	
	flag_wait( "start_runners" );
	
	wait 3.0;
	
	self.fixednode = false;
	
	vol_alley = getent( "vol_alley", "targetname" );
	self SetGoalVolumeAuto( vol_alley );
}


spawnfunc_alley_backup()
{
	self endon( "death" );
	
	self.animname 			= "enemy";
	self.allowdeath 		= true;
	self.goalradius 		= 16;
	self.disableLongDeath 	= true;
	
	align_basketball = getstruct( "anim_align_basketball", "targetname" );
	align_basketball anim_reach_solo( self, "box_traverse_C" );
	align_basketball anim_single_solo( self, "box_traverse_C" );
	
	node = GetNode( self.target, "targetname" );
	self SetGoalNode ( node );
	
	self waittill( "goal" );
	
	self.fixednode = true;
	
	flag_wait( "start_runners" );
	
	wait 3.5;
	
	self.fixednode = false;
	
	vol = getent( "vol_alley", "targetname" );
	self SetGoalVolumeAuto( vol );
}


spawnfunc_alley_charge()
{
	self endon( "death" );
	
	self.animname 			= "enemy";
	self.allowdeath 		= true;
	self.ignoresuppression 	= true;
	self.disablearrivals 	= true;
	self.disableLongDeath	 = true;
		
	align_basketball = getstruct( "anim_align_basketball", "targetname" );
	align_basketball anim_reach_solo( self, "box_traverse_C" );
	align_basketball anim_single_solo( self, "box_traverse_C" );
	
	self.disablearrivals 	= false;
	self.goalradius 		= 32;
	
	node = GetNode( self.target, "targetname" );
	self SetGoalNode ( node );
	
	self waittill( "goal" );
	
	self.ignoresuppression = false;
	
	flag_wait( "start_runners" );
	
	vol = GetEnt( "vol_alley", "targetname" );
	self SetGoalVolumeAuto( vol );
}


spawnfunc_alley_sprinter()
{
	self endon( "death" );
		
	self thread sprint_for_time( 7 );
}


spawnfunc_flanker_alley()
{
	self endon( "death" );
	
	self.animname 	= "enemy";
	self.allowdeath = true;
	
	align_basketball = getstruct( "anim_align_basketball", "targetname" );
	align_basketball anim_reach_solo( self, "box_traverse_C" );
	align_basketball anim_single_solo( self, "box_traverse_C" );
	
	vol = GetEnt( "vol_alley", "targetname" );
	self SetGoalVolumeAuto( vol );
	self enemy_counter_attack();
}


spawnfunc_flanker_tunnel()
{
	self endon( "death" );
	
	vol = getent( "vol_court", "targetname" );
	self SetGoalVolumeAuto( vol );
	self enemy_counter_attack();
}


spawnfunc_flanker_bank()
{
	self endon( "death" );

	vol = getent( "vol_court", "targetname" );
	self SetGoalVolumeAuto( vol );
	self enemy_counter_attack();
}


enemy_counter_attack()
{
	self endon( "death" );
	
	flag_wait( "btr_on_court" );
	
	wait RandomFloatRange( 3.0, 5.0 );
	
	self ClearGoalVolume();
	
	vol = GetEnt( "vol_defend", "targetname" );
	self SetGoalVolumeAuto( vol );
}

spawnfunc_flanker_runner()
{
	self endon( "death" );
	
	self.animname = "enemy";
	self.disablearrivals = true;
	self.ignoresuppression = true;
	
	self thread sprint_for_time( 10 );
	
	self waittill( "goal" );
	
	vol_runner = getent( "vol_runner", "targetname" );
	self SetGoalVolumeAuto( vol_runner );
	
	self waittill( "goal" );
	
	self.disablearrivals = false;
	self.ignoresuppression = false;
	
	vol_right_flank = getent( "vol_right_flank", "targetname" );
	self SetGoalVolumeAuto( vol_right_flank );
	
	self waittill( "goal" );
}

spawnfunc_tennis_point()
{
	self endon( "death" );
	
	self.goalradius = 32;
	self.animname = "enemy";	
	self.allowdeath = true;
	
	s_align = getstruct( "anim_align_basketball", "targetname" );
	s_align anim_reach_solo( self, "box_traverse_A" );
	s_align anim_single_solo( self, "box_traverse_A" );
	
	self thread sprint_for_time( 5 );
	
	nd_cover = GetNode( self.target, "targetname" );
	self setgoalnode ( nd_cover );
	
	self waittill( "goal" );
	
	wait 6.0;
	
	vol_right = getent( "vol_right_flank", "targetname" );
	self SetGoalVolumeAuto( vol_right );
}


spawnfunc_tennis_fencer()
{
	self endon( "death" );
	
	self.goalradius = 32;
	self.animname = "enemy";	
	self.allowdeath = true;
	
	s_align = getstruct( "anim_align_basketball", "targetname" );
	s_align anim_reach_solo( self, "box_traverse_B" );
	s_align anim_single_solo( self, "box_traverse_B" );
	
	self thread sprint_for_time( 5 );
	
	nd_cover = GetNode( self.target, "targetname" );
	self setgoalnode ( nd_cover );
	
	self waittill( "goal" );
	
	s_align anim_reach_solo( self, "fence_traverse" );
	s_align anim_single_solo( self, "fence_traverse" );
	
	vol = getent( "vol_court", "targetname" );
	self SetGoalVolumeAuto( vol );
}


spawnfunc_tennis()
{
	self endon( "death" );
	
	self.goalradius = 32;
	self.animname = "enemy";	
	self.allowdeath = true;
	self.disablearrivals = true;
	
	s_align = getstruct( "anim_align_basketball", "targetname" );
	s_align anim_reach_solo( self, "box_traverse_A" );
	s_align anim_single_solo( self, "box_traverse_A" );
	
	self thread sprint_for_time( 5 );
	
	nd_cover = GetNode( self.target, "targetname" );
	self setgoalnode ( nd_cover );
	
	self waittill( "goal" );
	
	self.disablearrivals = false;
	
	vol_right = getent( "vol_right_flank", "targetname" );
	self SetGoalVolumeAuto( vol_right );
	self enemy_counter_attack();
}


spawnfunc_tennis_backup()
{
	self endon( "death" );
	
	self.animname = "enemy";
	self.allowdeath = true;
	
	s_align = getstruct( "anim_align_basketball", "targetname" );
	s_align anim_reach_solo( self, "box_traverse_A" );
	s_align anim_single_solo( self, "box_traverse_A" );
	
	self thread sprint_for_time( 5 );
	
	self.goalradius = 32;
	
	nd_cover = GetNode( self.target, "targetname" );
	self setgoalnode ( nd_cover );
	
	self waittill( "goal" );
	
	self set_fixednode_true();
	
	wait 3.0;
	
	self set_fixednode_false();
	
	self thread sprint_for_time( 5 );
	
	vol_rec = getent( "vol_rec", "targetname" );
	self SetGoalVolumeAuto( vol_rec );
	
	self waittill( "goal" );
	
	self ClearGoalVolume();
	
	vol = getent( "vol_court", "targetname" );
	self SetGoalVolumeAuto( vol );
}


spawnfunc_flanker_rec()
{
	self endon( "death" );
	
	self.goalradius = 32;
	
	self waittill( "goal" );
	
	self set_fixednode_true();
	
	wait RandomFloatRange( 2.0, 4.0 );
	
	self set_fixednode_false();
	
	vol = getent( "vol_court", "targetname" );
	self SetGoalVolumeAuto( vol );
	self enemy_counter_attack();
}


spawnfunc_recreation()
{
	self endon( "death" );
	
	vol = getent( "vol_right_flank", "targetname" );
	self SetGoalVolumeAuto( vol );
	self enemy_counter_attack();
}


spawnfunc_resist_victim()
{
	self endon( "death" );
	
	self.animname = "btr_victim";
	   	
	flag_wait( "kill_resist_window" );
	
	s_align = getstruct( "anim_align_soap_death", "targetname" );
	
	self.deathfunction = ::deathfunc_btr_victim;

	s_align anim_single_solo( self, "death_window" );
}


kill_btr_victim( guy )
{
	guy.allowdeath = true;
	guy Kill();
}


deathfunc_btr_victim()
{
	self StartRagDoll();
	
	wait( 0.05 );
}


spawnfunc_resistance_soldier()
{
	self endon( "death" );
	
	self thread magic_bullet_shield( true );
	flag_wait( "FLAG_soap_death_started" );
	self stop_magic_bullet_shield();
	self Delete();
}


spawnfunc_door_guard()
{
	self endon( "death" );
	
	self.goalradius = 32;
	self.ignoresuppression = true;
	self thread magic_bullet_shield( true );
	
	self waittill( "goal" );
	
	self set_fixednode_true();
	self.ignoresuppression = false;
	
	flag_wait( "FLAG_soap_death_started" );
	
	self Delete();
}


spawnfunc_window()
{
	self endon( "death" );
	
	flag_wait( "FLAG_soap_death_started" );
	self Delete();
}

spawnfunc_medic( animname )
{
	Assert( IsDefined( animname ) );
	
	self endon( "death" );
	
	self thread magic_bullet_shield( true );
	
	self.animname = animname;
	
	if ( IsSubStr( animname, "4" ) )
		return;
		
	self.goalradius = 32;
	self.ignoresuppression = true;
	self set_ignoreall( true );
	
	flag_wait( "resistance_arrival" );
	
	self waittill( "goal" );
	
	self.ignoresuppression = false;
	self set_ignoreall( false );
	
	flag_wait( "resistance_mortal" );
	
	self stop_magic_bullet_shield();
	
	flag_wait( "FLAG_soap_death_started" );
	
	self Delete();
}

spawnfunc_leader()
{
	self thread magic_bullet_shield( true );
	
	self.animname = "resistance_leader";
}


spawnfunc_resistance_guard()
{
	self endon( "death" );
	
	self.script_combatbehavior = "heat";
	self.goalradius = 32;
		
	self thread magic_bullet_shield( true );
	
	self waittill( "goal" );
	
	self set_fixednode_true();
		
	flag_wait( "FLAG_soap_death_started" );
	
	self set_fixednode_false();
	
	vol = getent( "vol_defend", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	self waittill( "goal" );
	
	flag_wait( "FLAG_soap_death_close_door_to_defend" );
	
	self Delete();
}


// utility functions ////////////////////////////////////////////////////////////
chaser_bullets()
{
	start = getstruct( "struct_chaser_bullets", "targetname" );
		
	wait 1.0;
	
	for ( i = 0; i < 16; i++ )
	{		
		offset 	= ( RandomFloatRange( 30.0, 50.0 ), RandomFloatRange( 20.0, 80.0 ), RandomFloatRange( -20.0, 72.0 ) );
		end 	= level.player.origin;
		
		MagicBullet( "ak47", start.origin, end + offset );
		BulletTracer( start.origin, end + offset , true );
		
		wait 0.3;
	}
}


explode_court_barrel()
{
	start 	= getstruct( "struct_chaser_bullets", "targetname" );
	end 	= getstruct_delete( "court_barrel", "targetname" );
	
	flag_wait( "explode_court_barrel" );
	
	for ( i = 0; i < 3; i++ )
	{
		MagicBullet( "ak47", start.origin, end.origin );
		BulletTracer( start.origin, end.origin, true );
		wait 0.1;
	}
	RadiusDamage( end.origin, 40, 500, 400 );
}

court_advance( node, str_flag )
{
	self endon( "death" );
	
	flag_wait( str_flag );
	
	self setgoalnode( node );
	
	self waittill( "goal" );
	
	wait 0.1;
	
	self.goalradius = 32;
}

court_chunk_1()
{
	//crater1_dest = getent( "blast_crater_1_destroyed", "targetname" );
	//crater1_clean = getent( "blast_crater_1_clean", "targetname" );
	
	wait 0.6;
	
	exploder( 860 );
	
	//crater1_clean delete();
	//crater1_dest show();
}


court_chunk_2()
{
	//crater2_dest = getent( "blast_crater_2_destroyed", "targetname" );
	//crater2_clean = getent( "blast_crater_2_clean", "targetname" );
	
	wait 0.4;
	
	exploder( 861 );
	
	//crater2_clean delete();
	//crater2_dest show();
}


btr_shoot( target )
{
	self endon( "death" );
	self endon( "kill_resist_window" );
	
	self ClearTurretTarget();
	
	self SetTurretTargetEnt( target );
	
	while ( 1 )
	{
		self FireWeapon();
		wait 0.1;
	}
}


btr_tree_fx()
{
	exploder( 850 );
	wait 2.0;
	exploder( 851 );
	wait 2.0;
	exploder( 852 );
	wait 2.0;
	exploder( 853 );
	wait 2.0;
	exploder( 854 );
	wait 2.0;
	exploder( 855 );
	wait 2.0;
	exploder( 856 );
	wait 2.0;
	exploder( 857 );
}


resistance_shutters()
{
	shutter01_left = GetEnt( "esc_shutter01_left", "targetname" );
	shutter01_right = GetEnt( "esc_shutter01_right", "targetname" );
	
	shutter02_left = GetEnt( "esc_shutter02_left", "targetname" );
	shutter02_right = GetEnt( "esc_shutter02_right", "targetname" );
	
	shutter03_left = GetEnt( "esc_shutter03_left", "targetname" );
	shutter03_right = GetEnt( "esc_shutter03_right", "targetname" );
	
	shutter05_left = GetEnt( "esc_shutter05_left", "targetname" );
	shutter05_right = GetEnt( "esc_shutter05_right", "targetname" );
	
	shutter06_left = GetEnt( "esc_shutter06_left", "targetname" );
	shutter06_right = GetEnt( "esc_shutter06_right", "targetname" );
	
	shutter08_left = GetEnt( "esc_shutter08_left", "targetname" );
	shutter08_right = GetEnt( "esc_shutter08_right", "targetname" );
	
	shutter09_left = GetEnt( "esc_shutter09_left", "targetname" );
	shutter09_right = GetEnt( "esc_shutter09_right", "targetname" );
	
	shutter10_left = GetEnt( "esc_shutter10_left", "targetname" );
	shutter10_right = GetEnt( "esc_shutter10_right", "targetname" );
	
	shutter11_left = GetEnt( "esc_shutter11_left", "targetname" );
	shutter11_right = GetEnt( "esc_shutter11_right", "targetname" );
	
	shutter12_left = GetEnt( "esc_shutter12_left", "targetname" );
	shutter12_right = GetEnt( "esc_shutter12_right", "targetname" );
	
	shutter14_left = GetEnt( "esc_shutter14_left", "targetname" );
	shutter14_right = GetEnt( "esc_shutter14_right", "targetname" );
	
	shutter12_left RotateYaw( -150, 0.25 );
	shutter12_right RotateYaw( 150, 0.25 );
	
	wait 0.2;
	
	shutter05_left RotateYaw( -150, 0.25 );
	shutter05_right RotateYaw( 150, 0.25 );
	
	wait 0.1;
	
	shutter01_left RotateYaw( -150, 0.25 );
	shutter01_right RotateYaw( 150, 0.25 );
	
	wait 0.1;
	
	shutter10_left RotateYaw( -150, 0.25 );
	shutter10_right RotateYaw( 150, 0.25 );
	
	shutter02_left RotateYaw( -150, 0.25 );
	shutter02_right RotateYaw( 150, 0.25 );
	
	wait 0.2;
	
	shutter09_left RotateYaw( -150, 0.25 );
	shutter09_right RotateYaw( 150, 0.25 );
	
	shutter03_left RotateYaw( -150, 0.25 );
	shutter03_right RotateYaw( 150, 0.25 );
	
	wait 0.1;
	
	shutter06_left RotateYaw( -150, 0.25 );
	shutter06_right RotateYaw( 150, 0.25 );
	
	wait 0.2;
	
	shutter08_left RotateYaw( -150, 0.25 );
	shutter08_right RotateYaw( 150, 0.25 );
	
	shutter11_left RotateYaw( -150, 0.25 );
	shutter11_right RotateYaw( 150, 0.25 );
	
	wait 0.2;
	
	shutter14_left RotateYaw( -150, 0.25 );
	shutter14_right RotateYaw( 150, 0.25 );
	
	window_spawners = GetEntArray( "resistance_window", "targetname" );
	array_thread( window_spawners, ::spawn_ai );
}


molotov_barrage()
{
	level endon( "in_safehouse" );
	
	wait 2;
	
	starts = [];
	for ( i = 1; i <= 5; i++ )
		starts[ i ] = getstruct( "molotov_start" + i, "targetname" );
	
	ends = [];
	for ( i = 1; i <= 10; i++ )
		ends[ i ] = getstruct( "molotov_end" + i, "targetname" );
		
	while( 1 )
	{
		molotov_goes_jeremy( starts[ 1 ], ends[ 1 ] );
		wait RandomFloatRange( 2.0, 3.0 );
		molotov_goes_jeremy( starts[ 2 ], ends[ 2 ] );
		wait RandomFloatRange( 2.0, 3.0 );
		molotov_goes_jeremy( starts[ 3 ], ends[ 3 ] );
		wait RandomFloatRange( 2.0, 4.0 );
		molotov_goes_jeremy( starts[ 4 ], ends[ 4 ] );
		wait RandomFloatRange( 1.5, 3.0 );
		molotov_goes_jeremy( starts[ 5 ], ends[ 5 ] );
		wait RandomFloatRange( 1.5, 3.5 );
		molotov_goes_jeremy( starts[ 1 ], ends[ 6 ] );
		wait RandomFloatRange( 2.0, 5.0 );
		molotov_goes_jeremy( starts[ 2 ], ends[ 7 ] );
		wait RandomFloatRange( 2.0, 3.5 );
		molotov_goes_jeremy( starts[ 3 ], ends[ 8 ] );
		wait RandomFloatRange( 2.0, 4.5 );
		molotov_goes_jeremy( starts[ 4 ], ends[ 9 ] );
		wait RandomFloatRange( 2.5, 5.5 );
		molotov_goes_jeremy( starts[ 5 ], ends[ 10 ] );
		wait RandomFloatRange( 3.5, 5.5 );
	}
}

knock_down_hoop()
{
	btr_trigger = GetVehicleNode( "btr_entrance", "targetname" );
	btr_trigger waittill( "trigger" );
	
	flag_set( "FLAG_defend_btr_knocks_down_fence" );
	
	wait 0.5;
	
	thread btr_entrance_fx();
	
	fence = GetEnt( "fxanim_prague2_basketball_court_mod", "targetname" );
	fence UseAnimTree( level.scr_animtree[ "script_model" ] );
	fence.animname = "btr_fence";
	fence anim_single_solo( fence, "btr_entrance" );
	
	defend_fence_clip = GetEnt( "defend_fence_clip", "targetname" );
	defend_fence_clip Delete();
	
	destroyed_fence_clip = GetEnt( "destroyed_fence_clip", "targetname" );
	destroyed_fence_clip trigger_on();
}


btr_entrance_fx()
{
	exploder( 820 );
	wait 0.5;
	exploder( 822 );
}


sprint_for_time( n_time )
{
	self endon( "death" );
	self endon( "end_sprint" );
	
	self thread check_player_proximity();
	
	self set_run_anim( "sprint" );
	self.ignoresuppression = true;
	
	wait n_time;
	
	self notify( "end_proximity" );
	
	self clear_run_anim();
	self.ignoresuppression = false;
}


check_player_proximity()  //if the player gets too close, end sprint
{
	self endon( "death" );
	self endon( "end_proximity" );
	
	while( Distance2D( self.origin, level.player.origin ) > 750 )
	{
		wait 0.05;	
	}
	
	self notify( "end_sprint" );
	
	self clear_run_anim();
}


gate_door_clips()
{
	gate 		= GetEnt( "clip_resist_gate", "targetname" );
	door 		= GetEnt( "clip_resist_door", "targetname" );
	player_clip = GetEnt( "clip_player_door", "targetname" );
	
	gate ConnectPaths();
	door ConnectPaths();
	
	door trigger_off();
	player_clip trigger_off();
	
	flag_wait( "FLAG_soap_death_started" );
	
	player_clip trigger_on();
	
	flag_set( "FLAG_soap_death_close_door_to_defend" );
	
	door trigger_on();
	door DisconnectPaths();
	
	level.m_link_door RotateYaw( -82, 0.5 );
}

court_clips()
{
	court_clips = GetEntArray( "clip_court", "targetname" );
	
	foreach( clip in court_clips )
	{
		clip ConnectPaths();
		clip trigger_off();
	}
}

waittill_player_lookat_ent_timeout( range, timeout )
{
	Assert( IsDefined( range ) );
	
	level endon( "price_soap_leaving" );
	
	timeout = gt_op( timeout, 0.05 );
	
	for ( elapsed = 0; !flag( "price_soap_leaving" ) && elapsed < timeout; wait 0.1 )
	{
		if ( player_looking_at( self GetEye(), 0.92 ) && dsq_2d_ents_lt( level.player, self, range ) )
			flag_set( "price_soap_leaving" );
		elapsed += 0.1;
	}
	flag_set( "price_soap_leaving" );
}

check_player_safehouse()
{
	level endon( "price_soap_leaving" );
	
	safehouse_trigger = GetEnt( "trigger_in_safehouse", "targetname" );
	
	for( ; !level.player IsTouching( safehouse_trigger ); wait 0.1 ){}
	level notify( "end_fail_monitor" );
	flag_set( "price_soap_leaving" );
}


price_shoots_weapon( guy )
{
	if ( GetAICount( "axis" ) )
		guy Shoot();
}


price_holster_weapon( guy )
{
	guy animscripts\shared::placeweaponon( guy.primaryweapon, "none" );
}


price_retrieve_weapon( guy )
{
	m_ak47 = GetEnt( "price_ak47_defend", "targetname" );
	m_ak47 Delete();
	guy forceUseWeapon( "ak47", "primary" );
}


defend_setup()
{
	fence_clip = GetEnt( "destroyed_fence_clip", "targetname" );
	fence_clip trigger_off();
	
	//crater1 = GetEnt( "blast_crater_1_destroyed", "targetname" );
	//crater1 Hide();
	
	//crater2 = GetEnt( "blast_crater_2_destroyed", "targetname" );
	//crater2 Hide();
	
	door = GetEnt( "bar_door", "targetname" );
	
	level.m_link_door 			= Spawn( "script_model", door.origin );
	level.m_link_door.angles 	= door.angles;
	level.m_link_door SetModel( "tag_origin_animate" );
	level.m_link_door.animname = "resistance_door";
	level.m_link_door UseAnimTree( level.scr_animtree[ "resistance_door" ] );
				
	door.origin = level.m_link_door GetTagOrigin( "origin_animate_jnt" );
	door.angles = level.m_link_door GetTagAngles( "origin_animate_jnt" );
	door LinkTo( level.m_link_door, "origin_animate_jnt" );
	
	gate = GetEnt( "bar_gate", "targetname" );
	
	level.m_link_gate 			= Spawn( "script_model", gate.origin );
	level.m_link_gate.angles 	= gate.angles;
	level.m_link_gate SetModel( "tag_origin_animate" );
	level.m_link_gate.animname = "resistance_gate";
	level.m_link_gate UseAnimTree( level.scr_animtree[ "resistance_gate" ] );
				
	gate.origin = level.m_link_gate GetTagOrigin( "origin_animate_jnt" );
	gate.angles = level.m_link_gate GetTagAngles( "origin_animate_jnt" );
	gate LinkTo( level.m_link_gate, "origin_animate_jnt" );
	
	gate_clip = GetEnt( "clip_resist_gate", "targetname" );
	gate_clip LinkTo( gate );
	
	trig_medic_start = GetEnt( "trig_medic_start", "targetname" );
	trig_medic_start trigger_off();
	
	lion_statue = GetEnt( "fxanim_prague2_lion_statue_mod", "targetname" );
	lion_statue Hide();
	
	trig_player_bar_door = GetEnt( "trig_player_bar_door", "targetname" );
	trig_player_bar_door trigger_off();
	
	// Table Items
	
	beer_1 = GetEnt( "beer1", "targetname" );
	
	level.m_link_beer1 			= Spawn( "script_model", beer_1.origin );
	level.m_link_beer1.angles 	= beer_1.angles;
	level.m_link_beer1 SetModel( "tag_origin_animate" );
	level.m_link_beer1.animname = "beer1";
	level.m_link_beer1 UseAnimTree( level.scr_animtree[ "beer1" ] );
				
	beer_1.origin = level.m_link_beer1 GetTagOrigin( "origin_animate_jnt" );
	beer_1.angles = level.m_link_beer1 GetTagAngles( "origin_animate_jnt" );
	beer_1 LinkTo( level.m_link_beer1, "origin_animate_jnt" );
	
	beer_2 = GetEnt( "beer2", "targetname" );
	
	level.m_link_beer2 			= Spawn( "script_model", beer_2.origin );
	level.m_link_beer2.angles 	= beer_2.angles;
	level.m_link_beer2 SetModel( "tag_origin_animate" );
	level.m_link_beer2.animname = "beer2";
	level.m_link_beer2 UseAnimTree( level.scr_animtree[ "beer2" ] );
				
	beer_2.origin = level.m_link_beer2 GetTagOrigin( "origin_animate_jnt" );
	beer_2.angles = level.m_link_beer2 GetTagAngles( "origin_animate_jnt" );
	beer_2 LinkTo( level.m_link_beer2, "origin_animate_jnt" );
	
	beer_3 = GetEnt( "beer3", "targetname" );
	
	level.m_link_beer3 = Spawn( "script_model", beer_3.origin );
	level.m_link_beer3.angles = beer_3.angles;
	level.m_link_beer3 SetModel( "tag_origin_animate" );
	level.m_link_beer3.animname = "beer3";
	level.m_link_beer3 UseAnimTree( level.scr_animtree[ "beer3" ] );
				
	beer_3.origin = level.m_link_beer3 GetTagOrigin( "origin_animate_jnt" );
	beer_3.angles = level.m_link_beer3 GetTagAngles( "origin_animate_jnt" );
	beer_3 LinkTo( level.m_link_beer3, "origin_animate_jnt" );
	
	beer_4 = GetEnt( "beer4", "targetname" );
	
	level.m_link_beer4 			= Spawn( "script_model", beer_4.origin );
	level.m_link_beer4.angles 	= beer_4.angles;
	level.m_link_beer4 SetModel( "tag_origin_animate" );
	level.m_link_beer4.animname = "beer4";
	level.m_link_beer4 UseAnimTree( level.scr_animtree[ "beer4" ] );
				
	beer_4.origin = level.m_link_beer4 GetTagOrigin( "origin_animate_jnt" );
	beer_4.angles = level.m_link_beer4 GetTagAngles( "origin_animate_jnt" );
	beer_4 LinkTo( level.m_link_beer4, "origin_animate_jnt" );
	
	cup_1 = GetEnt( "cup1", "targetname" );
	
	level.m_link_cup1 			= Spawn( "script_model", cup_1.origin );
	level.m_link_cup1.angles 	= cup_1.angles;
	level.m_link_cup1 SetModel( "tag_origin_animate" );
	level.m_link_cup1.animname = "cup1";
	level.m_link_cup1 UseAnimTree( level.scr_animtree[ "cup1" ] );
				
	cup_1.origin = level.m_link_cup1 GetTagOrigin( "origin_animate_jnt" );
	cup_1.angles = level.m_link_cup1 GetTagAngles( "origin_animate_jnt" );
	cup_1 LinkTo( level.m_link_cup1, "origin_animate_jnt" );
	
	cup_2 = GetEnt( "cup2", "targetname" );
	
	level.m_link_cup2 			= Spawn( "script_model", cup_2.origin );
	level.m_link_cup2.angles 	= cup_2.angles;
	level.m_link_cup2 SetModel( "tag_origin_animate" );
	level.m_link_cup2.animname = "cup2";
	level.m_link_cup2 UseAnimTree( level.scr_animtree[ "cup2" ] );
				
	cup_2.origin = level.m_link_cup2 GetTagOrigin( "origin_animate_jnt" );
	cup_2.angles = level.m_link_cup2 GetTagAngles( "origin_animate_jnt" );
	cup_2 LinkTo( level.m_link_cup2, "origin_animate_jnt" );
	
	cup_3 = GetEnt( "cup3", "targetname" );
	
	level.m_link_cup3 			= Spawn( "script_model", cup_3.origin );
	level.m_link_cup3.angles 	= cup_3.angles;
	level.m_link_cup3 SetModel( "tag_origin_animate" );
	level.m_link_cup3.animname = "cup3";
	level.m_link_cup3 UseAnimTree( level.scr_animtree[ "cup3" ] );
				
	cup_3.origin = level.m_link_cup3 GetTagOrigin( "origin_animate_jnt" );
	cup_3.angles = level.m_link_cup3 GetTagAngles( "origin_animate_jnt" );
	cup_3 LinkTo( level.m_link_cup3, "origin_animate_jnt" );
	
	wine = GetEnt( "wine", "targetname" );
	
	level.m_link_wine 			= Spawn( "script_model", wine.origin );
	level.m_link_wine.angles 	= wine.angles;
	level.m_link_wine SetModel( "tag_origin_animate" );
	level.m_link_wine.animname = "wine";
	level.m_link_wine UseAnimTree( level.scr_animtree[ "wine" ] );
				
	wine.origin = level.m_link_wine GetTagOrigin( "origin_animate_jnt" );
	wine.angles = level.m_link_wine GetTagAngles( "origin_animate_jnt" );
	wine LinkTo( level.m_link_wine, "origin_animate_jnt" );
	
	hedges = [ GetEnt( "hedge_a_dest01", "targetname" ),
			   GetEnt( "hedge_a_dest02", "targetname" ),
		   	   GetEnt( "hedge_a_dest03", "targetname" ),
			   GetEnt( "hedge_a_dest04", "targetname" ),
			   GetEnt( "hedge_b_dest01", "targetname" ),
			   GetEnt( "hedge_b_dest02", "targetname" ),
			   GetEnt( "hedge_b_dest03", "targetname" ) ];
	array_call( hedges, ::Hide );
	
	crates = [ GetEnt( "crate_destroyed01", "targetname" ),
			   GetEnt( "crate_destroyed02", "targetname" ),
			   GetEnt( "crate_destroyed03", "targetname" ),
			   GetEnt( "crate_destroyed04", "targetname" ),
		  	   GetEnt( "crate_destroyed05", "targetname" ),
			   GetEnt( "crate_destroyed06", "targetname" ) ];
	array_call( crates, ::Hide );
}

crate_destruction()
{
	crates = [ GetEnt( "trigger_crate_01", "targetname" ),
			   GetEnt( "trigger_crate_02", "targetname" ),
			   GetEnt( "trigger_crate_03", "targetname" ),
			   GetEnt( "trigger_crate_04", "targetname" ),
			   GetEnt( "trigger_crate_05", "targetname" ),
			   GetEnt( "trigger_crate_06", "targetname" ) ];
	
	foreach ( i, crate in crates )
		crate thread crate_on_damage( i + 1 );
}

crate_on_damage( index )
{
	level endon( "in_safehouse" );
	
	self waittill( "trigger" );
	
	crate_pristine 	= GetEnt( "crate_clean0" + index, "targetname" );
	crate_destroyed = GetEnt( "crate_destroyed0" + index, "targetname" );
	
	tag	= Spawn( "script_model", crate_destroyed.origin );
	tag SetModel( "tag_origin" );
	
	PlayFXOnTag( getfx( "crate_dest" ), tag, "tag_origin" );
		
	wait 0.1;
		
	crate_pristine Delete();
	crate_destroyed Show();
	
	wait 5.0;
	
	tag Delete();
}

hedge_destruction()
{
	hedges = [ GetEnt( "hedge_a_01", "targetname" ),
			   GetEnt( "hedge_a_02", "targetname" ),
			   GetEnt( "hedge_a_03", "targetname" ),
			   GetEnt( "hedge_a_04", "targetname" ),
			   GetEnt( "hedge_b_01", "targetname" ),
			   GetEnt( "hedge_b_02", "targetname" ),
			   GetEnt( "hedge_b_03", "targetname" ) ];
	
	hedges[ 0 ] thread hedge_on_damage( "a", 1 );
	hedges[ 1 ] thread hedge_on_damage( "a", 2 );
	hedges[ 2 ] thread hedge_on_damage( "a", 3 );
	hedges[ 3 ] thread hedge_on_damage( "a", 4 );
	hedges[ 4 ] thread hedge_on_damage( "b", 1 );
	hedges[ 5 ] thread hedge_on_damage( "b", 2 );
	hedges[ 6 ] thread hedge_on_damage( "b", 3 );
}


hedge_on_damage( index_1, index_2 )
{
	level endon( "in_safehouse" );
	
	self waittill( "trigger" );
	
	hedge_pristine 	= GetEnt( "hedge_" + index_1 + "_clean0" + index_2, "targetname" );
	hedge_destroyed = GetEnt( "hedge_" + index_1 + "_dest0" + index_2, "targetname" );
	
	tag	= Spawn( "script_model", hedge_destroyed.origin );
	tag SetModel( "tag_origin" );
	
	PlayFXOnTag( getfx( "hedge" + index_1 + "_dest" ), tag, "tag_origin" );
	
	wait 0.1;
		
	hedge_pristine Delete();
	hedge_destroyed Show();
	
	clip = GetEnt( "clip_" + index_1 + "_clean0" + index_2, "targetname" );
	clip Delete();
	
	wait 5.0;
	
	tag Delete();
}

defend_clean_up()
{
	flag_wait( "FLAG_soap_death_started" );
	
	keep = [ level.price, level.soap, level.ai_resistance_leader, level.ai_leader, level.ai_medic4 ];
	override_array_delete( array_remove_array( GetAIArray(), keep ) );
}
