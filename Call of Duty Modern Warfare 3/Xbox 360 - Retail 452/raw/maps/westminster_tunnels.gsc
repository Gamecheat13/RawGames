#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\westminster_code;
#include maps\london_code;

pre_load()
{
	setup_pillar_exploders();
	maps\westminster_tunnels_fx::main();
	callback( "westminster_anim" ); // Replaced maps\westminster_tunnels_anim::main();

//	maps\_aftermath_player::main();
//	level.aftermath.limp_start_speed = 10;
	
	PreCacheModel( "vehicle_uk_utility_truck_objective_tailgate" );
	PreCacheModel( "vehicle_subway_cart_destructible_lights_off" );
	PreCacheModel( "vehicle_uk_utility_truck_destructible_nobullets" );
	PreCacheItem( "mp5" );
	PreCacheRumble( "steady_rumble" );
	PreCacheItem( "nosound_magicbullet" );
	PreCacheShellShock( "westminster_truck_crash" );
//	PrecacheShader( "mw3_full_logo_alpha" );
//	PrecacheShader( "ui_side_dirt" );
	//Move with &&"BUTTON_MOVE"
	add_hint_string( "truck_move", &"PLATFORM_HINT_MOVEONTRUCK", ::player_pushes_stick_for_a_bit );
}

init_tunnels()
{
	//these guys are enemies.. 
	hero_light_me = GetEntArray( "hero_light_me", "script_noteworthy" );
	foreach ( hero_guy in hero_light_me )
	{
		if ( IsSpawner( hero_guy ) )
		{
			hero_guy add_spawn_function( ::setup_subway_cart_enemy );
		}
	}

	train_one_flyby_1s = GetEntArray( "train_one_flyby_1", "script_noteworthy" );
	foreach ( try_spawner in train_one_flyby_1s )
	{
		if ( IsSpawner( try_spawner ) )
		{
			try_spawner add_spawn_function( ::train_one_flyby_1_spawn );
		}
		else
		{
			try_spawner thread train_one_flyby_1_spawn();
		}
	}

	train_one_flyby_2s = GetEntArray( "train_one_flyby_2", "script_noteworthy" );
	foreach ( try_spawner in train_one_flyby_2s )
	{
		if ( IsSpawner( try_spawner ) )
		{
			try_spawner add_spawn_function( ::train_one_flyby_2_spawn );
		}
		else
		{
			try_spawner thread train_one_flyby_2_spawn();
		}
	}
	
	array_spawn_function_targetname( "trainride_littlebird_spawner1", ::littlebird_shoot_train );

	trigger = GetEnt( "train_goes", "targetname" );
	thread set_flag_on_trigger( trigger, "train_goes" );

	trigger = GetEnt( "truck_load_use_trigger", "targetname" );
	trigger UseTriggerRequireLookAt();
	//Hold &&1 to use
	trigger SetHintString( &"LONDON_HINT_TRUCK_GETIN" );
	trigger thread truck_trigger_by_jump();
	trigger thread truck_trigger_by_use();
//	thread set_flag_on_trigger( trigger, "player_mounts_car" );

	vehicle_start_points = GetVehicleNodeArray( "vehicle_start_point", "script_noteworthy" );
	array_thread( vehicle_start_points, ::add_trigger_function, ::tunnels_save_point );
	/#
	  array_thread( vehicle_start_points, ::start_dump );
	#/
	train_civilians_go = GetVehicleNode( "train_civilians_go", "script_noteworthy" );
	train_civilians_go thread train_civilians_go_think();
	
	script_vehicle_subway_engine_destructible = GetEntArray( "script_vehicle_subway_engine_destructible", "classname" );
	foreach ( try_spawner in script_vehicle_subway_engine_destructible )
	{
		if ( IsSpawner( try_spawner ) )
		{
			try_spawner add_spawn_function( ::handle_junk_paramters );
			try_spawner add_spawn_function( ::add_damage_function, ::special_subway_cart_damage );
			try_spawner add_spawn_function( ::script_vehicle_subway_engine_destructible_think );
		}
		else
		{
			try_spawner thread script_vehicle_subway_engine_destructible_think();
			try_spawner add_damage_function( ::special_subway_cart_damage );
			try_spawner handle_junk_paramters();
			try_spawner turn_on_my_spotlight();
		}
	}
	
	script_vehicle_subway_engine_destructible = GetEntArray( "script_vehicle_subway_cart_destructible", "classname" );
	foreach ( try_spawner in script_vehicle_subway_engine_destructible )
	{
		if ( IsSpawner( try_spawner ) )
		{
			try_spawner add_spawn_function( ::handle_junk_paramters );
			try_spawner add_spawn_function( ::add_damage_function, ::special_subway_cart_damage );
		}
		else
		{
			try_spawner add_damage_function( ::special_subway_cart_damage );
			try_spawner handle_junk_paramters();
		}
	}
	
	veh_node_player_truck_spot_ons = GetVehicleNodeArray( "veh_node_player_truck_spot_on", "script_noteworthy" );
	array_thread( veh_node_player_truck_spot_ons, ::add_trigger_function, ::veh_node_player_truck_spot_onthink );
	
	groups = [];
	groups[ groups.size ] = "spawn_train_guys";
	groups[ groups.size ] = "spawn_train_door_guys";
	foreach ( a in groups )
	{
		array_thread( GetVehicleNodeArray( a, "script_noteworthy" ), ::train_spawn_group );
	}

	event_nodes = [];
	event_nodes[ event_nodes.size ] = "switch_door_guys";
	foreach ( a in event_nodes )
	{
		array_thread( GetVehicleNodeArray( a, "script_noteworthy" ), ::train_event_node );
	}
		
	vehicle_node_car_crash = GetVehicleNode( "vehicle_node_car_crash", "script_noteworthy" );
	vehicle_node_car_crash thread vehicle_node_car_crash_think();
	
	init_damage_trigger_pool();

	radio_sound_node = GetVehicleNodeArray( "radio_sound_node", "script_noteworthy" );
	array_thread( radio_sound_node, ::add_trigger_function, ::vehicle_node_sound_think );
	
	vehicle_node_civs_cleanup = GetVehicleNode( "vehicle_node_civs_cleanup", "script_noteworthy" );
	vehicle_node_civs_cleanup add_trigger_function( ::vehicle_node_civs_cleanup_think );
	
	vehicle_node_player_fast_detour_start = GetVehicleNode( "vehicle_node_player_fast_detour_start", "script_noteworthy" );
	vehicle_node_player_fast_detour_start add_trigger_function( ::vehicle_node_player_fast_detour_start_think );
	
	rocky_road_triggers = GetEntArray( "rocky_road", "targetname" );
	array_thread( rocky_road_triggers, ::add_trigger_function, ::rocky_road_trigger );

	friendly_ignore_off = GetVehicleNodeArray( "friendly_ignore_off", "script_noteworthy" );
	array_thread( friendly_ignore_off,  ::add_trigger_function, ::friendly_ignore_off );

	friendly_ignore_on = GetVehicleNodeArray( "friendly_ignore_on", "script_noteworthy" );
	array_thread( friendly_ignore_on, ::add_trigger_function, ::friendly_ignore_on );
	
//	veh_node_open_subway_doors = GetVehicleNodeArray( "veh_node_open_subway_door", "script_noteworthy" );
//	array_thread( veh_node_open_subway_doors, ::add_trigger_function, ::open_doors_of_enemy_train );
	
	veh_node_close_subway_doors = GetVehicleNodeArray( "veh_node_close_subway_door", "script_noteworthy" );
	array_thread( veh_node_close_subway_doors, ::add_trigger_function, ::close_doors_of_enemy_train );
	
	scn_london_subway_truck_trans = GetVehicleNode( "scn_london_subway_truck_trans", "script_noteworthy" );
	scn_london_subway_truck_trans add_trigger_function( ::scn_london_subway_truck_trans );

	radio_sound_node = GetVehicleNodeArray( "rpg", "script_noteworthy" );
	array_thread( radio_sound_node, ::add_trigger_function, ::vehice_node_rpg );

	nodes = GetVehicleNodeArray( "spawn_littlebird", "script_noteworthy" );
	array_thread( nodes, ::add_trigger_function, ::vehicle_node_spawn_littlebird );

	nodes = GetVehicleNodeArray( "switch_minimap", "script_noteworthy" );
	array_thread( nodes, ::add_trigger_function, ::vehicle_node_switch_minimap );	
}

truck_trigger_by_jump()
{
	self endon( "death" );
	level endon( "player_mounts_car" );
//	self endon( "trigger" );

	level.player NotifyOnPlayerCommand( "jump_pressed", "+gostand" );

	while ( !flag( "player_mounts_car" ) )
	{
		level.player waittill( "jump_pressed" );

		if ( level.player IsTouching( self ) )
		{
			self notify( "trigger" );
			wait( 0.05 );
		}
	}
}

truck_trigger_by_use()
{
	self endon( "death" );
	level endon( "player_mounts_car" );

	self safe_playeruse_trigger();

	flag_set( "player_mounts_car" );
}

scn_london_subway_truck_trans( other )
{
	if ( !other_is_player_truck( other ) )
	{
		add_trigger_function( ::scn_london_subway_truck_trans );
		return;
	}
	level.player play_sound_on_entity( "scn_london_subway_truck_trans" );
}

position_friendlies_at_fight_to_train()
{
	guys = [];
	level.tunnels_godmode_guys = [];

	sas_leader_node_at_train = GetNode( "sas_leader_node_at_train", "targetname" );

	guys = get_force_color_guys( "allies", "o" );
	guys = array_combine( guys, level.sas_squad );
   
	//spawners
	other_redshirts = GetEntArray( "sas_orange_truck_riders", "script_noteworthy" );
	
	numguys = 5;

	while ( guys.size < numguys )
	{
		guy = other_redshirts[ 0 ] spawn_ai( true );
		other_redshirts = array_remove( other_redshirts, other_redshirts[ 0 ] );
		guys = array_add( guys, guy );
	}
	
	Assert( guys.size >= numguys );
	
	inc = 0;
	foreach ( guy in guys )
	{
		thread position_friendlies_at_fight_to_train_thread( guy, sas_leader_node_at_train );
		if ( guy == level.sas_leader )
		{
			continue;
		}

		if ( guy == level.sas_squad[ 1 ] )
		{
			continue;
		}

		// Do not add the guy if he's being melee'd
		if ( IsDefined( guy.melee ) )
		{
			continue;
		}
			
		if ( inc < numguys )
		{
			if ( !IsDefined( guy.magic_bullet_shield ) )
			{
				guy magic_bullet_shield();
			}

			level.tunnels_godmode_guys = array_add( level.tunnels_godmode_guys, guy );
		}

		inc++;
	}
}

position_friendlies_at_fight_to_train_thread( guy, sas_leader_node_at_train )
{
	level endon ( "stop_position_friendlies_at_fight_to_train_thread" );
	flag_wait( "transition_to_train" );
	guy disable_ai_color();
	guy set_ignoreall( false );
	guy set_fixednode_false();
	guy set_ignoresuppression( true );
	guy.disablebulletwhizbyreaction = true;
	guy set_goal_pos( sas_leader_node_at_train.origin );
	guy set_goal_radius( sas_leader_node_at_train.radius );
	
	
}

cleanup_junk_from_docs()
{
	if ( IsDefined( level.cleanup_ents[ "docks_stuff" ] ) )
	{
		// Remove any magic bulletshield from Ai or riders in a vehicle within the docks_stuff
		array = level.cleanup_ents[ "docks_stuff" ];
		foreach ( ent in array )
		{
			if ( IsAi( ent ) && IsDefined( ent.magic_bullet_shield ) )
			{
				ent stop_magic_bullet_shield();
			}

			if ( IsDefined( ent.riders ) )
			{
				foreach ( rider in ent.riders )
				{
					if ( IsAi( rider ) && IsDefined( rider.magic_bullet_shield ) )
					{
						rider stop_magic_bullet_shield();
					}
				}
			}
		}

		cleanup_ents( "docks_stuff" );
	}

	london_docks_fx_volume = GetEntArray( "london_docks_fx_volume", "script_noteworthy" );
	delete_destructibles_in_volumes( london_docks_fx_volume );
	delete_interactives_in_volumes( london_docks_fx_volume );
	//delete_exploders_in_volumes( london_docks_fx_volume );

}

truck_start_work_around()
{
	if ( level.start_point == "train_start" )
	{
		ent = Spawn( "script_origin", level.player.origin );
		struct = getstruct( "truck_start_move_point", "targetname" );

		level.player PlayerLinkTo( ent );
		ent MoveTo( struct.origin, 2 );
		ent waittill( "movedone" );
		ent Delete();
	}
}

train_chase_intro()
{
	flag_wait( "start_train_encounter" );
	level.player ent_flag_init( "train_chase_introd" );
	door_open_delay = 5;
	delaythread( door_open_delay, ::open_doors_of_enemy_train );
	level.player delaythread( door_open_delay +  1.633333 , ::ent_flag_set, "train_chase_introd" );
	
	
	
}

train_chase()
{
	flag_wait( "start_train_encounter" );

//	thread truck_start_work_around();

	westminster_tunnels_fx_volume = GetEnt( "westminster_tunnels_fx_volume", "script_noteworthy" );
	westminster_tunnels_fx_volume activate_destructibles_in_volume();
	westminster_tunnels_fx_volume activate_interactives_in_volume();
	westminster_tunnels_fx_volume activate_exploders_in_volume();

	westminster_tunnels_crash_fx_volume = GetEnt( "westminster_tunnels_crash_fx_volume", "script_noteworthy" );
	westminster_tunnels_crash_fx_volume activate_destructibles_in_volume();
	westminster_tunnels_crash_fx_volume activate_interactives_in_volume();
	westminster_tunnels_crash_fx_volume activate_exploders_in_volume();
	
	if ( !flag( "riding_train_already" ) )
	{
		guys = array_spawn_noteworthy( "subway_enemy" );
		foreach ( guy in guys )
			guy.onTrain = false;
		thread guys_trickle_into_train( guys );
	}

	position_friendlies_at_fight_to_train();	
	
	fx_volume_restart_noteworthy( "westminster_tunnels_fx_volume" );
	fx_volume_restart_noteworthy( "westminster_tunnels_crash_fx_volume" );
	
	init_tunnels();
	
	train_vehicle_spawners = GetEntArray( "train_test", "script_noteworthy" );
	train_vehicle_spawner = train_vehicle_spawners[ 0 ];
	
	if ( flag( "riding_train_already" ) )
	{
		foreach ( spawner in train_vehicle_spawners )
			if ( IsSpawner( spawner ) )
				train_vehicle_spawner = spawner;
	}
	Assert( IsSpawner( train_vehicle_spawner ) );

	thread start_train_on_track( train_vehicle_spawner );
	
	player_ride();
}

train_chase_transition()
{

}

guys_trickle_into_train( ai )
{
	level endon ( "stop_guys_trickle_into_train" );
	
	flag_wait( "train_fight_trigger" );

	ai = array_removeundefined( ai );
	ai = array_removedead_or_dying( ai );

	if ( IsDefined( level.docks_enemy_ai ) )
	{
		ai = array_combine( ai, level.docks_enemy_ai );
	}
	
	node_train_spot_runtos = GetNodeArray( "node_train_spot_runto", "targetname" );
	
	center = get_average_origin( node_train_spot_runtos );
	
	timer = GetTime();
	
	while ( ai.size > 0 && node_train_spot_runtos.size > 0 )
	{
		ai = array_removeDead_or_dying( ai );
		if ( ai.size == 0 )
			break;
		ai = SortByDistance( ai, center );
		
		current_guy = ai[ 0 ];
		ai = array_remove( ai, current_guy );
		
		current_spot = node_train_spot_runtos[ 0 ];
		node_train_spot_runtos = array_remove( node_train_spot_runtos, current_spot );
	  
		if ( node_train_spot_runtos.size == 0 )
			return;

		current_spot = random( node_train_spot_runtos );
		current_guy thread guy_runs_into_train( current_spot );
		
		if ( ! ( ai.size > 0 && node_train_spot_runtos.size > 0 ) )
			break;
			
		wait 0.25;
	}

	flag_set( "last_guy_running_to_train" );
	
	wait_for_buffer_time_to_pass( timer, 10 );



	flag_set( "train_goes" );
}
 

start_train_on_track( train_vehicle_spawner )
{
	train_engine = undefined;
	
	if ( flag( "riding_train_already" ) )
		train_engine = train_vehicle_spawner.last_spawned_vehicle;
	else
		train_engine = train_vehicle_spawner spawn_vehicle();

//	train_engine hide_train_windows();

	train_engine godon();
	
	org = train_engine.origin;
	
	Assert( IsDefined( train_vehicle_spawner ) );
	
	level.lead_engine_train = train_engine;
	
	add_cleanup_ent( train_engine, "train" );

	train_engine.trains = [];
	train_engine.stacked = true;
	train_engine thread train_engine_thread();
	train_section = undefined;
	
	train_engine_node = GetVehicleNode( train_engine.target, "targetname" );
	targeting_section = train_engine_node train_get_targeting_train_node();
	
//	train_engine thread spawn_magic_inside_windows();
	while ( IsDefined( targeting_section ) )
	{
		train_vehicle_spawners = GetEntArray( targeting_section.targetname, "target" );
		train_vehicle_spawner = train_vehicle_spawners[ 0 ];

		if ( flag( "riding_train_already" ) )
			foreach ( spawner in train_vehicle_spawners )
				if ( IsSpawner( spawner ) )
					train_vehicle_spawner = spawner;
		
		spawner_last_org = train_vehicle_spawner.origin;
		train_vehicle_spawner.origin = targeting_section.origin;
		train_vehicle_spawner.target = targeting_section.targetname;
		
		if ( flag ( "riding_train_already" ) )
		{
			if ( IsDefined( train_vehicle_spawner.target_node ) )
			{
				train_section = train_vehicle_spawner.last_spawned_vehicle;
			}
			else
			{
				train_section = vehicle_spawn( train_vehicle_spawner );
			}
		}
		else
		{
			 foreach ( object in train_vehicle_spawners )
			 {
				if ( IsSpawner( object ) )
					train_section = vehicle_spawn( object );
				else
					train_section = object;
			 }
		}
		
		
		//train_section hide_train_windows();
		train_section.stacked = false;

		train_engine.trains = array_add( train_engine.trains, train_section );
		
		add_cleanup_ent( train_section, "train" );
		
		targeting_section = targeting_section train_get_targeting_train_node();
		train_vehicle_spawner.origin = spawner_last_org;
	}
	
	
	flag_wait( "train_goes" );
	thread close_doors_of_enemy_train_on_track();	
	thread manage_players_attacker_accuracy();
	
	fix_up_guys_left_behind();
	
	train_engine gopath();
	foreach ( train_section in train_engine.trains )
	{
		train_section gopath();
		train_engine thread train_re_stack();
	}
}

close_doors_of_enemy_train_on_track()
{
	wait 1;

	if ( !IsAlive( level.player ) )
	{
		return;
	}

	if( level.player ent_flag_exist( "train_chase_introd" ) )
		level.player ent_flag_wait( "train_chase_introd" );
	close_doors_of_enemy_train();

}

player_ride_link_player( player_truck, player_mount_truck )
{
	player_spot = get_player_spot( player_truck );
	player_spot Hide();
	thread callback( "manage_player_position", player_spot ); // maps\westminster_truck_movement::manage_player_position( player_spot );
	
	ground_ent_to_tag( player_spot, "tag_player", ( 0,180,0 ) );
	
//	level.player unlink_from_ground_ent();

//	delay = 0.1;

//	if ( ! flag( "riding_train_already" ) )
//		level.player PlayerLinkToBlend( player_spot, "tag_player", delay );
//	else
//		delay = 0;

	level.player AllowSprint( false );
	
//	wait delay;
	if ( flag( "riding_train_already" ) )
		level.player SetPlayerAngles( CombineAngles( player_spot GetTagAngles( "tag_player" ),  ( 0, 180, 0 ) ) );

	level.player_crash_truck = player_spot;
	level.player_origin_before = level.player.origin;	
	player_link_default();

	if ( IsDefined( player_mount_truck ) )
		player_mount_truck Delete();

	level.player_origin_after = level.player.origin;	
	
	level notify ( "start_manage_player_position" );
	level.player PlayerSetGroundReferenceEnt( level.groundent );
}

player_ride_headlight( player_truck )
{
	player_spot = get_player_spot( player_truck );
	head_light = get_vehicle_headlight( player_truck );
	level.players_truck_headlight = head_light;

	if ( !flag( "ride_without_wait" ) )
		player_truck ent_flag_wait( "loaded" );
		
	player_spot vehicle_lights_on( "all", player_truck.classname );

	head_light Unlink();
	head_light LinkTo( player_spot );
	head_light thread spot_light( "spotlight_truck_player", "spotlight_truck_player_cheap", "tag_origin", player_spot );
}

player_uses_truck( player_truck, model )
{
	flag_wait( "player_mounts_car" );

	thread player_give_ammo_thread();
	level.player EnableInvulnerability();
	
	GetEnt( "truck_load_use_trigger", "targetname" ) Delete();
	
	array_delete( getallweapons() );
	
	foreach( junk in player_truck.truckjunk )
	{
		if( junk.model == "weapon_mp5" )
		{
			// We're going to try giving ammo when running low instead
//			mp5 = spawn( "weapon_mp5", junk.origin );
//			mp5 LinkTo( player_truck, junk.script_ghettotag, junk.base_origin, junk.base_angles);
//			mp5 StartUsingHeroOnlyLighting();
//
//			junk hide();

			player_truck.truckjunk = array_remove( player_truck.truckjunk, junk );
			junk Delete();
		}
	}
	
//	level.player delayThread( 1.0, ::display_hint_timeout, "truck_move", 10 );
	player_mount_truck = undefined;
	if( !flag( "riding_train_already" ) )
	{
		level.player AllowCrouch( false );
		level.player AllowProne( false );
		level.player SetStance("stand");
		player_mount_truck = spawn_anim_model( "player_mount_truck" );
		ground_ent_to_tag( player_mount_truck, "tag_player" );
		player_truck thread anim_first_frame_solo( player_mount_truck, "truck_mount", "tag_guy1" );
		level.player PlayerLinkToBlend( player_mount_truck, "tag_player", 0.3, 0, 0 );
		level.player PlayerSetGroundReferenceEnt( level.groundent );
		level.player FreezeControls( true );
		level.player DisableWeapons();
		level.player PlaySound( "scn_london_enter_truck_plr" );
		wait 0.44; // little more time;
		level.player delaycall( 2.5, ::enableweapons);
		player_truck anim_single_solo( player_mount_truck, "truck_mount", "tag_guy1" );
		level.player AllowCrouch( true );
		player_mount_truck Hide();
	}
	else
		level.player PlayerSetGroundReferenceEnt( level.groundent );

	player_ride_link_player( player_truck, player_mount_truck );
	
	flag_set( "player_mount_car_complete" );
	level.player DisableInvulnerability();
}

player_give_ammo_thread()
{
	while ( !flag( "train_crash_explode" ) )
	{
		wait( 1 );
		player_give_ammo( 0.25, 1.5 );
	}
}

player_give_ammo( ratio, give_mult )
{
	weapons = level.player GetWeaponsList( "primary" );
	foreach ( weapon in weapons )
	{
		if ( !IsDefined( give_mult ) )
		{
			level.player GiveMaxAmmo( weapon );
		}
		else
		{
			frac = level.player GetFractionMaxAmmo( weapon );
			if ( frac < ratio )
			{
				ammo = level.player GetWeaponAmmoStock( weapon );
				ammo += level.player GetWeaponAmmoClip( weapon );
				ammo = Max( ammo, 70 );

				level.player SetWeaponAmmoStock( weapon, int( ammo * give_mult ) );
			}
		}
	}
}

PLAYER_TRAIL_TIME = 1.75;

player_ride( player_truck )
{

	player_truck_ghost = undefined;
	friend_truck_ghost = undefined;
	
	if ( !IsDefined( level.player_truck ) )
		level.player_truck = spawn_vehicle_from_targetname( "player_truck" );
	player_truck = level.player_truck;
		
	player_truck.dontunloadonend = true;
	player_truck godon();

	model = player_truck.model;
	
	player_spot = get_player_spot( player_truck );
	player_spot hide_truck_windows();
	player_spot SetModel( "vehicle_uk_utility_truck_destructible_nobullets" );
	player_spot Hide();

	if ( !flag( "riding_train_already" ) )
	{
		if ( !IsDefined( level.player_truck_ghost ) )
			level.player_truck_ghost = spawn_vehicle_from_targetname( "player_truck_ghost" );
		player_truck_ghost = level.player_truck_ghost;
		player_truck_ghost godon();
		player_truck_ghost Hide();
		player_truck_ghost Vehicle_TurnEngineOff();
		if ( !IsDefined( level.friend_truck_ghost ) )
			level.friend_truck_ghost = spawn_vehicle_from_targetname( "friend_truck_ghost" );
		friend_truck_ghost = level.friend_truck_ghost;
		friend_truck_ghost godon();
		friend_truck_ghost Hide();
		friend_truck_ghost Vehicle_TurnEngineOff();
	   
	}
	

	if ( !IsDefined( level.friend_truck ) )
		level.friend_truck = spawn_vehicle_from_targetname( "friend_truck" );
	
	//hides it.
	head_light = get_vehicle_headlight( level.friend_truck );

		
	level.friend_truck Vehicle_TurnEngineOff();
	level.player_truck Vehicle_TurnEngineOff();

		
	friend_spot = get_friend_spot( level.friend_truck );
	friend_spot Hide();

	friend_truck = level.friend_truck;
	friend_truck godon();

	thread player_uses_truck( player_truck, model );
	thread player_ride_headlight( player_truck );

	flag_wait_either( "last_guy_running_to_train", "train_goes" );
	flag_clear( "can_save" );
	
	vehicle_uk_utility_truck_objective_tailgate = Spawn( "script_model", player_truck.origin );
	vehicle_uk_utility_truck_objective_tailgate SetModel ( "vehicle_uk_utility_truck_objective_tailgate" );
	vehicle_uk_utility_truck_objective_tailgate LinkTo( player_truck, "TAG_ORIGIN", ( 0, 0, 0 ), ( 0, 0, 0 ) );
//	player_truck HidePart( "TAG_TAIL_GATE" );
	
	player_truck_passenger = level.sas_squad[ 1 ];
	player_truck_passenger.script_startingposition = 1;
	level.sas_leader.script_startingposition = 0;
	friend_truck_driver = level.tunnels_godmode_guys[ 0 ];
	friend_truck_passenger = level.tunnels_godmode_guys[ 1 ];
	friend_truck_gunner = level.tunnels_godmode_guys[ 2 ];
	
	level notify ( "stop_position_friendlies_at_fight_to_train_thread" );


	if ( !flag( "ride_without_wait" ) )
	{
		player_truck thread aggressively_load_ai( [ level.sas_leader, player_truck_passenger ] );
		level.sas_leader thread fast_truck_load( "friendly_truck_fast_load", true, level.player_truck );
		player_truck_passenger thread fast_truck_load( "friendly_truck_fast_load", false, level.player_truck );
		// friend_truck_passenger thread fast_truck_load( "friendly_truck_other_fast_load", false, level.friend_truck );
	}
	else
	{
		flag_set( "friendly_truck_fast_load" );
		flag_set( "friendly_truck_other_fast_load" );
		player_truck guy_enter_vehicle( level.sas_leader );
		player_truck guy_enter_vehicle( player_truck_passenger );
	}
   
	level.friend_truck_gunner = friend_truck_gunner;
	friend_truck_gunner.disableReactionAnims = true;
		
	friend_truck_driver.script_startingposition = 0;
	friend_truck_passenger.script_startingposition = 1;
	friend_truck_gunner.script_startingposition = 2;
	
	if ( !flag( "ride_without_wait" ) )
	{
		friend_truck_ghost.script_badplace = false;
		player_truck_ghost.script_badplace = false;
		player_truck.script_badplace = false;
		friend_truck.script_badplace = false;

		friend_truck_gunner thread friendly_gunner_behavior_on_enter();
		friend_truck thread aggressively_load_ai( [ friend_truck_driver, friend_truck_passenger, friend_truck_gunner ] );
	}
	else
	{
		friend_truck guy_enter_vehicle( friend_truck_driver );
		friend_truck guy_enter_vehicle( friend_truck_passenger );
		friend_truck guy_enter_vehicle( friend_truck_gunner );
		friend_truck_gunner thread friendly_gunner_behavior();
	}
	
	
	flag_wait( "train_goes" );
	
	if ( !flag( "riding_train_already" ) )
	{
		//Sandman: They're taking off!  Everyone on the trucks!
		level.sas_leader thread dialogue_queue( "london_ldr_inthetrucks" );
		thread train_failure();
		player_truck_ghost delaythread( PLAYER_TRAIL_TIME, ::gopath );
		friend_truck_ghost thread gopath();
		friend_truck_ghost Hide();
		player_truck_ghost Hide();

	}
	
	flag_wait( "player_mounts_car" );

	level.sas_leader delaythread( 2.0, ::teleport_to_struct_if_not_in_radius, "teleport_player_driver_struct" );
	player_truck_passenger delaythread( 2.0, ::teleport_to_struct_if_not_in_radius, "teleport_player_passenger_struct" );

	flag_wait( "player_mount_car_complete" );
	flag_set( "can_save" );

	//"Those bastards aren't skivin outta 'dis!""	-- REMOVED FOR E3.
//	delaythread( 3, ::radio_dialogue, "london_gfn_skivin" );
	
	BadPlace_Cylinder( "player_spot", 15, level.player.origin + ( 0, 0, -500 ), 2000, 3000, "axis" );
	if ( !flag( "ride_without_wait" ) )
	{
		friend_truck_ghost.script_badplace = true;
		player_truck_ghost.script_badplace = true;
		player_truck.script_badplace = true;
		friend_truck.script_badplace = true;
	}
	
	cleanup_junk_from_docs();
	
	friend_truck_driver teleport_to_struct_if_not_in_radius( "teleport_friend_driver_struct" );
	friend_truck_gunner teleport_to_struct_if_not_in_radius( "teleport_friend_gunner_struct" );
	
	friend_truck_driver thread teleporty_load(); // get him started on his animation.
	friend_truck_passenger thread teleporty_load(); // get him started on his animation.
	
	friend_truck thread callback( "force_door_shut" );

	level.sas_leader notify( "goal" );
	friend_truck_gunner notify( "goal" ); // get him started on his animation.
	
	level.enable_ai_shotgun_destructible_damage = true;
	
	//flag_wait( "friendly_truck_other_fast_load" );
	
	timer = GetTime();
	
	if ( ! flag( "riding_train_already" ) )
	{
		friend_truck thread play_sound_on_tag( "scn_london_utility_truck_startup_npc", "TAG_DRIVER" );
		wait 0.5;
		friend_truck Vehicle_TurnEngineOn();
		wait 0.5;
		friend_truck gopath();
		friend_spot vehicle_lights_on( "all", "script_vehicle_uk_utility_truck" );
		friend_truck turn_on_my_spotlight();
		friend_truck thread match_position_of_target_vehicle( friend_truck_ghost );
	}
	else
	{
		friend_spot vehicle_lights_on( "all", "script_vehicle_uk_utility_truck" );
		friend_truck Vehicle_TurnEngineOn();
	}
	
	time_passed = ( GetTime() - timer ) / 1000;
	trail_time = clamp( time_passed, PLAYER_TRAIL_TIME - time_passed, PLAYER_TRAIL_TIME );

	flag_wait( "friendly_truck_fast_load" );
	player_truck thread play_sound_on_tag( "scn_london_utility_truck_startup", "TAG_DRIVER" );
		
	if ( ! flag( "riding_train_already" ) )
	{
		player_truck delaythread( trail_time + 0.2, ::play_sound_on_entity, "scn_london_utilitytruck_peelout" );
		player_truck delaythread( trail_time, ::gopath );
		player_truck delaythread( trail_time, ::match_position_of_target_vehicle, player_truck_ghost );
		
		//"Hold on!"
		delaythread( Clamp( trail_time - 1, 0.05, trail_time ), ::radio_dialogue, "london_ldr_holdon" );
	}  
	
	if ( IsDefined( level.docks_littlebird ) )
		level.docks_littlebird Delete();
	
//	player_truck ShowPart( "TAG_TAIL_GATE" );
	vehicle_uk_utility_truck_objective_tailgate Delete();
	
	vehicle_node_transition_to_crash = GetVehicleNode( "vehicle_node_transition_to_crash", "script_noteworthy" );
	vehicle_node_transition_to_crash waittill ( "trigger", other );
	
//	delaythread( 23, maps\westminster_truck_movement::stop_manage_player_position, player_spot );
	delaythread( 23, ::callback, "stop_manage_player_position", player_spot );

	train_crash( player_truck );
}

teleporty_load()
{
	self notify ( "goal" );
	wait 0.05;
	self notify ( "animontagdone", "end" );
	
}

train_failure()
{
	count = 15;
	for ( i = count; i > 0; i-- )
	{
		if ( flag( "player_mounts_car" ) )
		   return;
		//IPrintLnBold( i );
		if ( i == 11 )
			level.sas_leader thread dialogue_queue( "london_ldr_burnsintruck" );
			
		if ( i == 7 )
			level.sas_leader thread dialogue_queue( "london_ldr_arseintruck" );

		if ( i == 5 )
			level.sas_leader thread dialogue_queue( "london_ldr_burnsintruck" );
			
		wait 1;
	}
	
	if ( flag( "player_mounts_car" ) )
	   return;
	   
	//Keep up with the train!
	SetDvar( "ui_deadquote",	  &"LONDON_SUBWAY_CART_GOT_AWAY" );
	missionFailedWrapper();
}

train_crash_mirrored_in_crash_sight( node, is_innocent )
{
//	train_car4 = spawn_anim_model( "train_car4_mirrored" );
  
	player_car_damage = spawn_anim_model( "player_car_mirrored" );
	
	level.player_car_damage_mirrored = player_car_damage;
	
	player_car_damage hide_truck_windows();
	player_car_damage HidePart( "TAG_TAIL_GATE" );
	player_car_damage HidePart( "TAG_RAIL" );

	if ( !IsDefined( is_innocent ) )
	{
		player_car_damage Hide();
		player_car_damage NotSolid();
	}
	
	node anim_teleport_solo( player_car_damage, "train_crash" );
//	node anim_teleport_solo( train_car4, "train_crash" );

	player_car_damage vehicle_lights_on( "all", "script_vehicle_uk_utility_truck_no_rail_player" );
	
//	delete_time = GetAnimLength( train_car4 getanim( "train_crash" ) );
//	train_car4 delaycall( delete_time, ::Delete );

	node thread anim_single_solo( player_car_damage, "train_crash" );
	
	if ( IsDefined( is_innocent ) )
	{
		wait 0.05;
		node anim_set_time( [ player_car_damage ], "train_crash", 1 );
		return;
	}
	else
	{
		flag_wait( "teleport_to_west" );
	}
	
	stop_last_spot_light();
}

draw_body_tag( train )
{
	self endon ( "death" );
	while ( true )
	{
		Line( self GetTagOrigin ( "tag_body" ), level.player.origin, ( 1, 1, 1 ), 1 );
		foreach ( guy in train.riding_guys )
			Line( self GetTagOrigin ( "tag_body" ), guy.origin, ( 0, 1, 0 ), 1 );
		foreach ( junk in train.truckjunk )
			Line( self GetTagOrigin ( "tag_body" ), junk.origin, ( 0, 0, 1 ), 1 );
		
		wait 0.05;
	}
}

relink_guys_to_junk()
{
	foreach ( guy in self.riding_guys )
		if ( IsDefined( guy.junk_linked ) )
		{
			junk = guy.junk_linked;
			guy LinkTo( junk, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
		}
			
}

train_crash( player_truck_vehicle )
{
	flag_set( "train_crashing" );
	
	westminster_tunnels_fx_volume = GetEntArray( "westminster_tunnels_fx_volume", "script_noteworthy" );
	delete_destructibles_in_volumes( westminster_tunnels_fx_volume );
	delete_interactives_in_volumes( westminster_tunnels_fx_volume );
	//delete_exploders_in_volumes( westminster_tunnels_fx_volume );
	fx_volume_pause_noteworthy( "westminster_tunnels_fx_volume" );
	
	
	array_thread( level.pillar_exploders, ::pillar_think );
	
	//make them shoot at friendly truck.
	level.player.ignoreme = true;
	level.player EnableInvulnerability();
	level notify ( "stop_manage_players_attacker_accuracy" );
	
	//reset attacker accuracy for player.
	level.player thread maps\_gameskill::update_player_attacker_accuracy();

	level.player.IgnoreRandomBulletDamage = false;
	
	array_thread( GetAIArray( "axis" ), ::set_favoriteenemy, level.friend_truck_gunner );
	
	transition_time = 1;
	
	thread train_crash_dialogue();
//	thread post_train_crash_dialogue();
	
	node = getstruct( "train_crash_script_node", "targetname" );

	// Fake node for split of london
	teleport_node = SpawnStruct();
	teleport_node.angles = node.angles;
	teleport_node.origin = node.origin;

	level.lead_engine_train delaycall(1, ::Hide);
	foreach ( train in level.lead_engine_train.trains )
		train delaycall(1, ::Hide);
	
	guys = [];
	
	train_car1 = spawn_anim_model( "train_car1" );
	train_car1_broken = spawn_anim_model( "train_car1_broken" );
	train_car2 = spawn_anim_model( "train_car2" );
	train_car3 = spawn_anim_model( "train_car3" );
	train_car4 = spawn_anim_model( "train_car4" );

	player_rig_tunnel_crash = spawn_anim_model( "player_rig_tunnel_crash" );
	player_rig_tunnel_crash_teleport = spawn_anim_model( "player_rig_tunnel_crash_teleport" );

	player_rig_tunnel_crash_teleport Hide();
	player_rig_tunnel_crash Hide();
	
	level.player_rig_tunnel_crash_teleport = player_rig_tunnel_crash_teleport;
	level.player_rig_tunnel_crash = player_rig_tunnel_crash;
	
	train_car1 hide_train_windows();
	train_car2 hide_train_windows();
	train_car3 hide_train_windows();
	train_car4 hide_train_windows();
	
	friend_truck_gunner = level.friend_truck_gunner;
	friend_truck_gunner notify ( "stop_orient_to_player" );
	friend_truck_gunner get_the_bastard_off_the_vehicle();
	friend_truck_gunner stop_magic_bullet_shield();
	friend_truck_gunner = maps\_vehicle_aianim::convert_guy_to_drone( friend_truck_gunner, false );
	friend_truck_gunner.animname = "truck_gunner";
	
	GetVehicleNode( "all_enemies_target_friend_gunner", "script_noteworthy" ) thread all_enemies_target_friend_gunner( friend_truck_gunner );

	level.friend_truck.dontunloadonend = true;
	
	truck = get_friend_spot( level.friend_truck );
	truck Unlink();
	truck Show();
	
	foreach ( rider in level.friend_truck.riders )
		if ( IsDefined( rider.magic_bullet_shield ) )
			rider stop_magic_bullet_shield();
		
	level.friend_truck.modeldummy = truck;
	level.friend_truck maps\_vehicle::move_riders_here( truck );
	level.friend_truck maps\_vehicle::move_truck_junk_here( truck );
	level.friend_truck Hide();
	
	truck.animname = "truck";
	truck assign_animtree();
	
	//truck = spawn_anim_model( "truck" );
//	truck vehicle_lights_on( "all", "script_vehicle_uk_utility_truck" );

	truck_wrecked = spawn_anim_model( "truck_wrecked" );
	truck_wrecked HidePart( "TAG_RAIL" );
	
	if ( IsDefined( level.player_crash_truck ) )
	{
		player_car = level.player_crash_truck;
		player_car.animname = "player_car";
		player_car assign_animtree();
	}
	else
		player_car = spawn_anim_model( "player_car" );


	player_car Show();
	player_car hide_truck_windows();
	player_truck_vehicle.modeldummy = player_car;
	player_truck_vehicle maps\_vehicle::move_riders_here( player_car );
	player_truck_vehicle maps\_vehicle::move_truck_junk_here( player_car );

	level.player.ignoreme = true;
	truck HidePart( "TAG_RAIL" );
	
	level.lead_engine_train.modeldummy = train_car1;
	level.lead_engine_train maps\_vehicle::move_truck_junk_here( train_car1 );
	level.lead_engine_train relink_guys_to_junk();
	
	array_levelthread( level.lead_engine_train.truckjunk, ::add_cleanup_ent, "lead_train_junk" );

	//move junk to trains.

	train_vehicle = level.lead_engine_train.trains[ 0 ];
	train_vehicle.modeldummy = train_car2;
	train_vehicle maps\_vehicle::move_truck_junk_here( train_car2 );
	train_vehicle relink_guys_to_junk();

	train_vehicle = level.lead_engine_train.trains[ 1 ];
	train_vehicle.modeldummy = train_car3;
	train_vehicle maps\_vehicle::move_truck_junk_here( train_car3 );
	train_vehicle relink_guys_to_junk();

	train_vehicle = level.lead_engine_train.trains[ 2 ];
	train_vehicle.modeldummy = train_car4;
	train_vehicle maps\_vehicle::move_truck_junk_here( train_car4 );
	train_vehicle relink_guys_to_junk();

	player_car HidePart( "TAG_RAIL" );
	guys = array_add( guys, train_car1 );
	guys = array_add( guys, train_car2 );
	guys = array_add( guys, train_car3 );
	guys = array_add( guys, train_car4 );
	guys = array_add( guys, truck_wrecked );
	guys = array_add( guys, player_rig_tunnel_crash );

	node anim_teleport( guys, "train_crash" );

	array_call( guys, ::Hide );
	
	player_car Unlink();
	player_truck_vehicle Hide();
	
	friend_truck_gunner LinkTo( truck, "tag_gunner", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	node anim_moveto( [ player_car, truck ] , "train_crash", undefined, transition_time, 0, 0 );

	truck thread anim_loop_solo( friend_truck_gunner, "idle_loop", "stop_idle_loop", "tag_gunner" );
	wait transition_time;

	temp_array = array_remove( guys, player_rig_tunnel_crash );
	array_call( temp_array, ::Show );

	level.friend_truck notify ( "stop_idle_loop" );
	friend_truck_gunner Unlink();
	
	thread train_crash_mirrored_in_crash_sight( teleport_node );

	guys = array_add( guys, player_car );
	guys = array_add( guys, friend_truck_gunner );
	guys = array_add( guys, truck );

	add_cleanup_ent( train_car2, "crashed_left_behinds" );
	add_cleanup_ent( train_car3, "crashed_left_behinds" );
	add_cleanup_ent( train_car4, "crashed_left_behinds" );
	add_cleanup_ent( truck, "crashed_left_behinds" );
	add_cleanup_ent( truck_wrecked, "crashed_left_behinds" );
	add_cleanup_ent( player_rig_tunnel_crash, "crashed_left_behinds" );
	add_cleanup_ent( player_truck_vehicle, "crashed_left_behinds" );
	add_cleanup_ent( level.friend_truck, "crashed_left_behinds" );
	add_cleanup_ent( level.player_truck_ghost, "crashed_left_behinds" );
	add_cleanup_ent( level.lead_engine_train, "crashed_left_behinds" );
	add_cleanup_ent( level.lead_engine_train.trains[ 0 ], "crashed_left_behinds" );
	add_cleanup_ent( level.lead_engine_train.trains[ 1 ], "crashed_left_behinds" );
	add_cleanup_ent( level.lead_engine_train.trains[ 2 ], "crashed_left_behinds" );

	
// PRE SPLIT
//	teleport_node = getstruct( "train_crash_script_node_damaged_side", "targetname" );
//	teleport_node = getstruct( "train_crash_script_node_damaged_side_player", "targetname" );

	thread train_crash_breaks( "train_breaks_in_half", train_car1_broken, train_car1, node );
	thread truck_wrecks( "london_truck_crash", truck_wrecked, truck, node );

	
	thread disable_weapons_on_explode();
	

	truck thread play_sound_on_entity( "scn_london_subway_truck_crash" );
	train_car2 thread play_sound_on_entity( "scn_london_subway_train_crash" );
	node thread anim_single( guys, "train_crash" );

	teleport_node anim_single_solo( player_rig_tunnel_crash_teleport, "train_crash" );
	
	player_truck_vehicle.riders = array_remove( player_truck_vehicle.riders, level.sas_leader );
	array_thread( player_truck_vehicle.riders, ::stop_magic_bullet_shield );
	array_delete( player_truck_vehicle.riders );

   
	head_light = get_vehicle_headlight( player_truck_vehicle );
	junk = array_remove( player_truck_vehicle.truckjunk, head_light );
	junk = array_remove( junk, player_car );
	player_car Hide();
	array_delete( junk );
	
	guys = GetEntArray( "sas_squad", "targetname" );
	guys = array_remove( guys, level.sas_leader );
	foreach ( guy in guys )
	{
		if ( IsDefined( guy.magic_bullet_shield ) )
			guy stop_magic_bullet_shield();
	}

	array_delete( guys );

	
	cleanup_ents( "crashed_left_behinds" );
	
	level.player.ignoreme = false;

	if ( IsDefined( level.rumble_ent ) )
	{
		level.rumble_ent Delete();
	}
	
	flag_set( "train_crashed" );
   
	westminster_tunnels_fx_volume = GetEntArray( "westminster_tunnels_fx_volume", "script_noteworthy" );
	delete_destructibles_in_volumes( westminster_tunnels_fx_volume );
	delete_interactives_in_volumes( westminster_tunnels_fx_volume );
	//delete_exploders_in_volumes( westminster_tunnels_fx_volume );
	
	westminster_tunnels_crash_fx_volume = GetEntArray( "westminster_tunnels_crash_fx_volume", "script_noteworthy" );
	delete_destructibles_in_volumes( westminster_tunnels_crash_fx_volume );
	delete_interactives_in_volumes( westminster_tunnels_crash_fx_volume );
	//delete_exploders_in_volumes( westminster_tunnels_crash_fx_volume );
}

train_crash_dialogue()
{
	wait( 1 );
	// "I see the driver, taking the shot!"
	radio_dialogue( "london_sasl_seethedriver" );
	// "MAN DOWN!! MAN DO-- <BLAM!!>"
	radio_dialogue( "london_sas2_pierceisdown" );

//	flag_wait( "slow_mo" );

	wait( 10 );
	
	// "HOLD OOOONNNNN!!!!"
	radio_dialogue( "london_ldr_holdon2" );
}

all_enemies_target_friend_gunner( friend_truck_gunner )
{
	self waittill ( "trigger" );
	org = spawn_tag_origin();
	org.origin = friend_truck_gunner GetTagOrigin( "tag_eye" );
	org LinkTo ( friend_truck_gunner, "tag_eye", ( 0, 0, -44 ), ( 0, 0, 0 ) );
	add_cleanup_ent( org, "crashed_left_behinds" );
	all_enemies = GetAIArray( "axis" );
	foreach ( ai in all_enemies )
		ai thread enemy_fires_at_target( org );
		
	delayThread( 3, ::flag_set, "guys_shot_enough_at_train" );
		
}

enemy_fires_at_target( org )
{
	self notify ( "stop_orient_to_player" );
	
	self SetEntityTarget( org );
	self endon ( "death" );
	
	self thread orient_to_ent_point( org );
	
	wait RandomFloatRange( 1, 2 );
	while ( IsAlive( self ) )
	{
		self Shoot();
		wait RandomFloatRange( 0.05, 0.10 );
		if ( flag( "train_crash_explode" ) )
			break;
		if ( flag( "guys_shot_enough_at_train" ) )
			break;
	}
	
	self ClearEntityTarget();
}


disable_weapons_on_explode()
{
	flag_wait( "train_crash_explode" );
	
	train_array = level.lead_engine_train.trains;
	train_array[ train_array.size ] = level.lead_engine_train;
	
	foreach ( train in train_array )
		array_thread( train.riding_guys, ::kill_train_guys_at_end );
		
	headlight = get_vehicle_headlight( level.lead_engine_train );
	headlight Delete();
		
	foreach ( train in train_array )
	{
		train.mirror_destructible_model Show();
		train.modeldummy HidePart( "TAG_INTERIOR_UNLIT" );
	}
		
	level.player DisableWeapons();
}

kill_train_guys_at_end()
{
	self.train_ragdoll = true;
	self Kill();
}

//train_slowmo()
//{
//	flag_set( "slow_mo" );
//	SetSlowMotion( 1.0, 0.2, 0.1 );
//	wait( 0.4 );
//	SetSlowMotion( 0.2, 1.0, 0.4 );
//}

train_crash_breaks( msg, train_car1_broken, train_car1, node )
{
	level.train_car1_broken = train_car1_broken;
	flag_wait( msg );
//	thread train_slowmo();
	cleanup_ents( "lead_train_junk" );
	
	train_car1_broken DontInterpolate();
	node anim_teleport_solo( train_car1_broken, "train_crash" );
	node thread anim_single_solo( train_car1_broken, "train_crash" );
	train_car1_broken Show();
	train_car1 Hide();
}

truck_wrecks( msg, broken, alive, node )
{
	broken Hide();
	flag_wait( msg );
	alive vehicle_lights_off( "all", "script_vehicle_uk_utility_truck" );
	broken Show();
	alive Hide();
}

start_train_start()
{
	flag_set( "transition_to_train" );
	set_start_locations( "start_train_start" );
	redshirts = array_spawn_noteworthy( "sas_orange_truck_riders_start" );
}

friendly_ignore_on( triggerer )
{
	if ( !IsDefined( level.friend_truck_gunner ) )
		return;
	level.friend_truck_gunner.ignoreme = true;
}

friendly_ignore_off( triggerer )
{
	if ( !IsDefined( level.friend_truck_gunner ) )
		return;
	level.friend_truck_gunner.ignoreme = false;
}

