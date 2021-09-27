#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_hud_util;
#include maps\castle_code;
#include maps\_stealth_utility;

main()
{
	//vehicle anim overrides.. -nate
	//level.castle_bm21_anim_func = maps\castle_anim::setvehicleanims_bm21_castle;
	//level.castle_bm21_human_anim_func = maps\castle_anim::setanims_bm21_castle;

	level_precache();

	init_level_flags();
	setup_start_points();
	
	maps\castle_precache::main();
	maps\createart\castle_art::main();
	maps\castle_fx::main();
	maps\castle_anim::main();	
	maps\_load::main();
	maps\_stealth::main();
	maps\_patrol_anims::main();
	maps\_drone_civilian::init();
	
	thread maps\castle_amb::main();
	
	maps\castle_courtyard_battle::disable_battle_triggers();
	maps\castle_courtyard_battle::hide_bridge_objects();
	
	thread castle_main_minmap();
		
	stealth_settings();
	setup_spawn_funcs();
	setup_anim_nodes();
	level.player stealth_default();
	
	level thread handle_objectives();
	level thread handle_music();
	level thread handle_environmental_fx();
	level thread init_water_splash_fx();
	level thread handle_fog_changes();
	level thread handle_generator_spotlights();

	level.player thread player_rain_drops();

	dual_stinger_setup();
	nightvision_setup();
	parachute_control_setup();
	
	a_e_lights = GetEntArray( "dungeon_light", "targetname" );
	foreach( e_light in a_e_lights )
	{
		e_light SetLightIntensity( 0.1 );
	}
	
	cage_pad_light = GetEnt( "cage_pad_light", "targetname" );
	cage_pad_light SetLightIntensity( 0.1 );
	
	set_ents_visible( "startvista", false );
	
	setup_set_ents_visible_triggers();

	battlechatter_on( "axis" );
	
	//reduce penalty of friendly fire kills for prisoners
	//level.friendlyfire[ "enemy_kill_points" ]	 = 0;
	//level.friendlyfire[ "friend_kill_points" ] 	 = -50;

	// Light array used by the lightning function	
	level.a_e_local_lightning = [];
	level.droneCallbackThread = maps\castle_prison_battle::prisoner_init;
}

castle_main_minmap()
{
	if ( level.start_point == "intro" )
	{
		SetSavedDvar( "ui_hideMap", "1" );
		SetSavedDvar( "hud_showStance", "0" );	
		
		flag_wait( "player_landed" );
		SetSavedDvar( "ui_hideMap", "0" );
		SetSavedDvar( "hud_showStance", "1" );	
	}
	
	maps\_compass::setupMiniMap("compass_map_castle");	
}

level_precache()
{
	PrecacheItem( "mp5" );
	PrecacheItem( "mp5_silencer_reflex_castle" );
	PrecacheItem( "c4" );
	PrecacheItem( "freerunner" );
	PreCacheItem( "rpg_straight" );
	PreCacheItem( "hellfire_missile_af_caves_end" );
	PreCacheItem( "flash_grenade" );
	PreCacheItem( "uzi" );
	PreCacheItem( "ak74u_acog" );
	PreCacheItem( "btr80_turret_castle" );
	
	PreCacheRumble( "minigun_rumble" );
	PreCacheRumble( "subtle_tank_rumble" );
	PreCacheRumble( "grenade_rumble" );
	
	PreCacheShader( "stinger_emplacement_override_white" );
	PreCacheShader( "stinger_emplacement_override_red" );
	PreCacheShader( "stinger_emplacement_loading" );
	PreCacheShader( "stinger_emplacement_ready" );	
	PreCacheShader( "stinger_emplacement_missile_full" );
	PreCacheShader( "stinger_emplacement_missile_empty" );
	PreCacheShader( "overlay_rain" );
	PrecacheShader( "overlay_rain_large");
	PrecacheShader( "overlay_rain_large_02");
	PrecacheShader( "overlay_rain_small");
	PrecacheShader( "overlay_rain_small_02");

	precacheModel("body_price_europe_assault_a");
	
	PreCacheModel( "ctl_missile_emplacement_obj" );
	PreCacheModel( "ctl_weapon_rpg7_obj" );
	
	PrecacheModel( "weapon_c4" );
	PrecacheModel( "weapon_c4_obj" );
	
	PreCacheModel( "ctl_parachute_handle_backup" );

	PreCacheModel( "ctl_spotlight_modern_3x_on" );
	PreCacheModel( "ctl_spotlight_modern_3x_destroyed" );
	
	PreCacheModel( "ctl_foliage_tree_pine_tall_c" );
	PreCacheModel( "ctl_foliage_tree_pine_tall_b" );
	
	PrecacheModel( "paris_catacombs_door_pry_kick_rigged" );
	
	PrecacheModel("vehicle_uaz_open_player_ride_door_backl_obj");
	
	PreCacheModel( "generic_prop_raven" );
	
	PreCacheModel( "weapon_usp_silencer" );
	PreCacheModel( "weapon_commando_knife" );
	
	PreCacheModel( "head_price_europe_c_nvg" );
	
	maps\_load::set_player_viewhand_model( "viewhands_player_yuri_europe" );
	maps\castle_parachute_sim::parachute_precache();
	maps\_c4::main();
}

init_level_flags()
{
	flag_init( "display_nvg_on_hint" );
	flag_init( "display_nvg_off_hint" );
	
	flag_init( "start_water_splash_fx" );
	flag_init( "stop_water_splash_fx" );
	flag_init( "re_start_water_splash_fx" );
	flag_init( "castle_intro_fog" );
	flag_init( "castle_intro_a_fog" );
	flag_init( "castle_courtyard_fog" );
	flag_init( "castle_dungeon_dark" );
	flag_init( "castle_flare_room" );
	flag_init( "castle_bridge_crossing_fog" );
	flag_init( "castle_bridge_crossing_a_fog" );
	flag_init( "castle_interior_exterior_fog" );
	flag_init( "castle_control_room_fog" );
	flag_init( "castle_courtyard_battle_fog" );
	flag_init( "castle_courtyard_battle_a_fog" );
	flag_init( "castle_bridge_explosion_fog" );
	flag_init( "castle_bridge_explosion_jump_fog" );
	flag_init( "castle_escape_fog" );
	flag_init( "price_blew_bridge");
	
	
	
	
	maps\castle_parachute::init_event_flags();
	maps\castle_ruins::init_event_flags();
	maps\castle_courtyard_stealth::init_event_flags();
	maps\castle_courtyard_activity::init_event_flags();
	maps\castle_prison_battle::init_event_flags();
	maps\castle_bridge_crossing::init_event_flags();
	maps\castle_into_wet_wall::init_event_flags();
	maps\castle_kitchen_battle::init_event_flags();
	maps\castle_prison_battle::init_event_flags();
	maps\castle_interior::init_event_flags();
	maps\castle_inner_courtyard::init_event_flags();
	maps\castle_courtyard_battle::init_event_flags();
	maps\castle_escape_new::init_event_flags();
}

setup_spawn_funcs()
{
	maps\castle_ruins::setup_spawn_funcs();
	maps\castle_courtyard_stealth::setup_spawn_funcs();
	maps\castle_prison_battle::setup_spawn_funcs();
}

setup_anim_nodes()
{
	register_anim_node( "landing" );
	register_anim_node( "ruins_middle" );
	register_anim_node( "anim_align_dropdown" );
	register_anim_node( "anim_align_helipad" );
	register_anim_node( "anim_align_road" );
	register_anim_node( "backward_crawl" );
	
	//section 2
	register_anim_node( "security_room" );
	register_anim_node( "align_dungeon_enter" );
	register_anim_node( "dungeon_cell" );
	register_anim_node( "align_multipath" );
	register_anim_node( "align_u_room" );
	register_anim_node( "align_flare_room" );
	register_anim_node( "align_dungeon_exit" );
	register_anim_node( "spiderclimb" );
	register_anim_node( "kitchen_battle" );
	
	//section 3
	register_anim_node( "price_talk" );
	register_anim_node( "generator_room" );
	register_anim_node( "foyer" );
	register_anim_node( "inner_courtyard" );
	register_anim_node( "bridge_overlook" );
	register_anim_node( "castle_bridge" );
	register_anim_node( "outer_courtyard" );
	register_anim_node( "anim_align_end_run" );
	register_anim_node( "anim_align_end_jump" );
	register_anim_node( "anim_align_end_land" );
}

setup_start_points()
{
	set_default_start( "intro" );
	
	//Section 1 - BBarnes
	add_start(	"intro",				maps\castle_parachute::start_intro,
				"Level Intro",			maps\castle_parachute::main );
				
	add_start(	"ruins",				maps\castle_ruins::start_ruins,
				"Ruins Start",			maps\castle_ruins::ruins_main );
	
	add_start(	"courtyard_activity",	maps\castle_courtyard_activity::start,
				"Courtyard Activity",	maps\castle_courtyard_activity::main );

	add_start(	"platform_crawl",		maps\castle_courtyard_stealth::start_platform,
				"Platform Crawl",		maps\castle_courtyard_stealth::main );

	//Section 2 - MMaestas
	add_start(	"security_office",		maps\castle_prison_battle::start_security_office,
				"Security Office",		maps\castle_prison_battle::security_office );
				
	add_start(	"prison_battle_start",	maps\castle_prison_battle::start_prison_battle_start,
				"Prison Battle Start",	maps\castle_prison_battle::prison_battle_start );
	
	add_start(	"prison_battle_flare_room",	maps\castle_prison_battle::start_prison_battle_flare_room,
				"Prison Battle Flare Room",	maps\castle_prison_battle::prison_battle_flare_room );

	add_start(	"bridge_crossing",	maps\castle_bridge_crossing::start_bridge_crossing,
				"Bridge Crossing",	maps\castle_bridge_crossing::bridge_crossing );
	
	add_start(	"destroy_wet_wall",	maps\castle_into_wet_wall::start_destroy_wet_wall,
				"Destroy Wet Wall",	maps\castle_into_wet_wall::destroy_wet_wall );
	
	add_start(	"into_wet_wall",	maps\castle_into_wet_wall::start_into_wet_wall,
				"Into Wet Wall",	maps\castle_into_wet_wall::into_wet_wall );
	
	add_start(	"kitchen_battle",	maps\castle_kitchen_battle::start_kitchen_battle,
				"Kitchen Battle",	maps\castle_kitchen_battle::kitchen_battle );

	//Section 3 - KDrew
	add_start(	"interior",	maps\castle_interior::start_interior,
				"Interior",	maps\castle_interior::interior_main );
	
	add_start(	"inner_courtyard",	maps\castle_inner_courtyard::start_inner_courtyard,
				"Inner Courtyard",	maps\castle_inner_courtyard::inner_courtyard_main );
	
	add_start(  "bridge_explode", maps\castle_courtyard_battle::start_bridge_explode,
	            "Bridge Explode", maps\castle_courtyard_battle::bridge_explode_main );

	add_start(	"courtyard_battle",	maps\castle_courtyard_battle::start_courtyard_battle,
				"Courtyard Battle",	maps\castle_courtyard_battle::courtyard_battle_main );

	add_start(	"escape",	maps\castle_escape_new::start_escape,
				"Escape",	maps\castle_escape_new::escape_main );
	
	add_start(  "cliff", maps\castle_escape_new::start_cliff,
	          "Cliff", maps\castle_escape_new::escape_main );
}

handle_objectives()
{
	waittillframeend;

	set_completed_objective_flags();
	
	//LANDING = obj( "landing" );
	
	MOTORPOOL_MELEE = obj( "motorpool_melee" );
	PLATFORM_BOMB_PLANT = obj( "platform_bomb_plant" );
	COURTYARD_STEALTH = obj( "courtyard_stealth" );

	//Section 2
	PRISON_CLEAR = obj( "prison_clear" );	
	BRIDGE_BOMB = obj( "bridge_bomb" );
	WALL_CHARGE = obj( "wall_charge" );
	COMM_ROOM = obj( "comm_room" );
	
	//Section 3
	DETONATE_BRIDGE = obj( "detonate_bridge" );
	DESTROY_BTR = obj( "destroy_btr" );
	ESCAPE_CASTLE = obj( "escape_castle" );
	PARACHUTE_TO_SAFETY = obj( "parachute_to_safety" );
	
	
	/*
	//GIVE: Landing
	Objective_Add( LANDING, "current", &"CASTLE_OBJECTIVE_LANDING");
	s_landing_obj = getstruct( "s_landing_obj", "targetname" );
	if( IsDefined( s_landing_obj ) )
	{
		Objective_Position( LANDING, s_landing_obj.origin );
	}
	
	//COMPLETE: Landing
	flag_wait( "player_landing" );
	Objective_State( LANDING, "done" );	
	*/
		
	//GIVE: Courtyard Stealth
	flag_wait( "player_landed" );
	Objective_Add( COURTYARD_STEALTH, "current", &"CASTLE_OBJECTIVE_COURTYARD_STEALTH");
	Objective_OnEntity( COURTYARD_STEALTH, level.price );

	//GIVE: Motorpool Melee
	flag_wait( "objective_motorpool_melee" );
	Objective_Add( MOTORPOOL_MELEE, "current", &"CASTLE_OBJECTIVE_MOTORPOOL_MELEE");
	if( IsDefined( level.ai_motorpool_melee ) )
	{
//		Objective_Position( MOTORPOOL_MELEE, level.ai_motorpool_melee.origin + (0,0,72) );
		Objective_State( COURTYARD_STEALTH, "active" );
	}
	
	//COMPLETE: Motorpool Melee
	flag_wait( "objective_motorpool_melee_complete" );
	
	if ( !flag( "stealth_not_following_price1" ) && !flag( "price_kill_melee_guard" ) )
	{
		Objective_State( MOTORPOOL_MELEE, "done" );
	}
	else
	{
		Objective_State( MOTORPOOL_MELEE, "failed" );
	}
	Objective_State( COURTYARD_STEALTH, "current" );
	
	//GIVE: Platform Bomb Plant
	flag_wait( "objective_bomb_plant" );
	Objective_Add( PLATFORM_BOMB_PLANT, "current", &"CASTLE_OBJECTIVE_PLANT_BOMB");
	if( IsDefined( level.platform_bomb ) )
	{
		level.platform_bomb Show();
		Objective_Position( PLATFORM_BOMB_PLANT, level.platform_bomb.origin );
	}
	
	//COMPLETE: Platform Bomb Plant
	flag_wait( "platform_bomb_planted" );
	
	if ( !flag( "stealth_not_following_price1" ) && !flag( "Price_Plant_bomb_instead" ) )
	{
		Objective_State( PLATFORM_BOMB_PLANT, "done" );
	}
	else
	{
		Objective_State( PLATFORM_BOMB_PLANT, "failed" );
	}
	
	//COMPLETE: Courtyard Stealth
	flag_wait( "security_office_cleared" );
	Objective_State( COURTYARD_STEALTH, "done" );

	//Section 2
	/*
	//GIVE: Clear Prison
	flag_wait( "objective_clear_prison" );
	Objective_Add( PRISON_CLEAR, "current", &"CASTLE_OBJECTIVE_PRISON_CLEAR");
	Objective_OnEntity( PRISON_CLEAR, level.price );
	
	flag_wait( "player_entered_prison" );
	level thread objective_breadcrumb( PRISON_CLEAR, "prison_obj_marker", "objective_clear_prison_cleared" );
	
	flag_wait( "meatshield_done" );
	Objective_OnEntity( PRISON_CLEAR, level.price );
	Objective_SetPointerTextOverride( PRISON_CLEAR , "Follow" );

	//COMPLETE: Clear Prison
	flag_wait( "objective_clear_prison_cleared" );
	Objective_State( PRISON_CLEAR, "done" );	
	*/
	
	
	//GIVE: Find Comm Room
	//flag_wait( "objective_comm_room" );
	flag_wait( "objective_clear_prison" );	
	Objective_Add( COMM_ROOM, "current", &"CASTLE_OBJECTIVE_COMM_ROOM" );
	Objective_OnEntity( COMM_ROOM, level.price );
	
	flag_wait( "player_entered_prison" );
	level thread objective_breadcrumb( COMM_ROOM, "prison_obj_marker" );
	
	flag_wait( "meatshield_done" );
	Objective_OnEntity( COMM_ROOM, level.price );
	Objective_SetPointerTextOverride( COMM_ROOM , &"CASTLE_FOLLOW" );
	
	
	flag_wait( "objective_comm_room" );
	//GIVE: Bridge Bomb Plant
	flag_wait( "objective_plant_bomb_bridge" );
	Objective_Add( BRIDGE_BOMB, "current", &"CASTLE_OBJECTIVE_PLANT_BOMB_BRIDGE" );
	if( IsDefined( level.m_bridge_bomb ) )
	{
		Objective_Position( BRIDGE_BOMB, level.m_bridge_bomb.origin );
	}
	
	//COMPLETE: Bridge Bomb Plant
	//flag_wait_any( "passed_bomb", "bomb_has_been_planted" );
	flag_wait( "bomb_has_been_planted" );
	Objective_State( BRIDGE_BOMB, "done" );
	
	/*if ( flag( "bomb_has_been_planted" ) )
	{
		Objective_State( BRIDGE_BOMB, "done" );	
	}
	else
	{
		Objective_State( BRIDGE_BOMB, "failed" );	
	}*/
	
	//GIVE: Time Wall Charge
	flag_wait( "objective_time_wall_charge" );
	Objective_Add( WALL_CHARGE, "current", &"CASTLE_OBJECTIVE_TIME_WALL_CHARGE" );
	Objective_OnEntity( WALL_CHARGE, level.price );
	
	//COMPLETE: Time Wall Charge
	flag_wait( "wet_wall_destroyed" );
	if ( !flag( "wet_wall_goofed" ) )
	{
		Objective_State( WALL_CHARGE, "done" );	
	}
	else
	{
		Objective_State( WALL_CHARGE, "failed" );
	}

	//COMPLETE: Find Comm Room
	flag_wait( "peephole_start" );
	Objective_State( COMM_ROOM, "done" );
	              
	//Section 3
	//GIVE: Escape Castle
	flag_wait( "kitchen_start" );
	Objective_Add( ESCAPE_CASTLE, "current", &"CASTLE_OBJECTIVE_ESCAPE_CASTLE" );
	Objective_OnEntity( ESCAPE_CASTLE, level.price );
	
	flag_wait( "inner_courtyard_initial_wave" );
	
	Objective_SetPointerTextOverride( ESCAPE_CASTLE , &"CASTLE_SUPPORT" );
	//Objective_Position( ESCAPE_CASTLE, GetEnt( "inner_courtyard_objective", "targetname" ).origin );
	
	flag_wait("inner_courtyard_door_kick");
	Objective_Position( ESCAPE_CASTLE, GetEnt( "obj_leave_innercourtyard", "targetname" ).origin );
	Objective_SetPointerTextOverride( ESCAPE_CASTLE , "" );
	
	//flag_wait( "inner_courtyard_done" );
	
	//Objective_OnEntity( ESCAPE_CASTLE, level.price );
	//Objective_SetPointerTextOverride( ESCAPE_CASTLE , "Follow" );
	
	//GIVE: Detonate Bridge
	flag_wait( "give_bridge_detonator" );
	Objective_Add( DETONATE_BRIDGE, "current", &"CASTLE_OBJECTIVE_DETONATE_BRIDGE" );
	Objective_OnEntity( ESCAPE_CASTLE, level.price );
	Objective_SetPointerTextOverride( ESCAPE_CASTLE , &"CASTLE_FOLLOW" );
	
	//COMPLETE: Detonate Bridge
	flag_wait( "bridge_detonated" );
	
	if ( !flag( "price_blew_bridge" ) )
	{
		Objective_State( DETONATE_BRIDGE, "done" );
	}
	else
	{
		Objective_State( DETONATE_BRIDGE, "failed" );
	}
	
	wait 2;
	
	Objective_Position( ESCAPE_CASTLE, GetEnt( "obj_leave_balcony", "targetname" ).origin );
	Objective_SetPointerTextOverride( ESCAPE_CASTLE , "" );
	
	flag_wait("jumped_to_bridge");
	
	Objective_OnEntity( ESCAPE_CASTLE, level.price );
	Objective_SetPointerTextOverride( ESCAPE_CASTLE , &"CASTLE_FOLLOW" );
	
	//GIVE: Destroy BTR
	//flag_wait( "courtyard_btr_alive" );
	flag_wait("get_to_escape_truck");
	Objective_SetPointerTextOverride( ESCAPE_CASTLE , "" );
	
	Objective_Position( ESCAPE_CASTLE,  GetEnt( "escape_truck_use_target", "targetname" ).origin );
	
//	Objective_Add( DESTROY_BTR, "current", &"CASTLE_OBJECTIVE_DESTROY_BTR" );
	
//	
//	if( IsDefined( level.vh_outer_courtyard_btr ) )
//	{
//		Objective_OnEntity( ESCAPE_CASTLE, level.vh_outer_courtyard_btr, (0, 0, 130) );
//		Objective_SetPointerTextOverride( ESCAPE_CASTLE, &"CASTLE_OBJECTIVE_DESTROY" );
//	}
	
	flag_wait( "player_entering_truck" );
	Objective_Position( ESCAPE_CASTLE, (0,0,0));

	flag_wait("through_escape_doors");
	wait 2.0;
	Objective_State( ESCAPE_CASTLE, "done" );
	
	flag_wait("escape_chute_ready");
	
	Objective_Add(PARACHUTE_TO_SAFETY, "current", &"CASTLE_OBJECTIVE_PARACHUTE_TO_SAFETY",(0,0,0));
			
	flag_wait( "player_chute_opens" );	
	
	wait 1.0;
	
	//COMPLETE: Escape Castle
	Objective_State( PARACHUTE_TO_SAFETY, "done" );
}


//	Follow a breadcumb trail for positional markers
//
objective_breadcrumb( n_obj, str_start_marker, str_endon )
{
	if ( IsDefined( str_endon ) )
	{
		level endon( str_endon );
	}
	
	s_obj_marker = GetStruct( str_start_marker, "targetname" );
	while ( IsDefined( s_obj_marker ) )
	{
		// Set our current goal
		Objective_Position( n_obj, s_obj_marker.origin );
		
		n_dist_sq = 128 * 128;
		if ( IsDefined( s_obj_marker.radius ) )
		{
			n_dist_sq = s_obj_marker.radius * s_obj_marker.radius;
		}
		
		while ( DistanceSquared( level.player.origin, s_obj_marker.origin ) > n_dist_sq )
		{
			wait( 0.1 );
		}
		
		// We've reached our destination, now go to the next
		if ( IsDefined( s_obj_marker.target ) )
		{
			s_obj_marker = GetStruct( s_obj_marker.target, "targetname" );
		}
		else
		{
			s_obj_marker = undefined;
		}
	}
}



handle_music()
{
	music_play( "castle_fight_music_01" );
	
	flag_wait( "player_landed" );
	
	music_play( "castle_sneak_music_01", 3.0 );
	
	flag_wait( "kitchen_start" );
		
	music_play( "castle_mombasa_music_01", 1.0 );
}

set_completed_objective_flags()
{
	if ( is_default_start() )
		return;

	start = level.start_point;
	
	if(start == "intro")
		return;
	
	flag_set( "player_landing" );
	flag_set( "player_landed" );

	if(start == "ruins")
		return;
	
	flag_set("castle_intro_fog");

	if(start == "courtyard_activity")
		return;
	
	flag_set( "objective_motorpool_melee" );
	flag_set( "objective_motorpool_melee_complete" );
	
	flag_set("castle_intro_a_fog");
	flag_set("castle_courtyard_fog");

	if(start == "platform_crawl")
		return;
		
	flag_set( "objective_motorpool_melee" );
	flag_set( "objective_motorpool_melee_complete" );
	
	flag_set( "player_in_backcrawl" );
	flag_set( "objective_bomb_plant" );
	flag_set( "platform_bomb_planted" );
			
	disable_stealth_system();

	flag_set("castle_courtyard_a_fog");
	
	//Section 2
	if(start == "security_office")
		return;
	
	flag_set( "security_office_closed" );
	flag_set( "security_office_cleared" );
	flag_set( "objective_clear_prison" );
	flag_set( "prison_start" );

	maps\castle_courtyard_stealth::cleanup();

	if(start == "prison_battle_start")
		return;
	
	level thread maps\castle_prison_battle::cleanup_security_office();
	flag_set( "entered_security_office_cage" );
	flag_set( "price_activate_switch" );
	flag_set( "player_entered_prison" );
	
	//flag_set("castle_dungeon_dark");
	
	if(start == "prison_battle_flare_room")
		return;

	//flag_set( "objective_clear_prison_cleared" );
	flag_set( "objective_comm_room" );
	flag_set("meatshield_done");

	level thread maps\castle_prison_battle::prison_cleanup();
	flag_set( "exited_prison" );
	
	flag_set("castle_flare_room");
	flag_set("castle_bridge_crossing_fog");

	if(start == "bridge_crossing")
		return;

	flag_set( "objective_comm_room" );
	flag_set( "objective_plant_bomb_bridge" );
	flag_set( "bomb_has_been_planted" );
	flag_set( "wet_wall_start" );
	
	flag_set("castle_bridge_crossing_a_fog");
	
	if(start == "destroy_wet_wall")
		return;

	flag_set( "objective_time_wall_charge" );
	flag_set( "wet_wall_destroyed" );

	if(start == "into_wet_wall")
		return;

	flag_set( "peephole_start" );
	flag_set( "stop_peeping" );

	if(start == "kitchen_battle")
		return;
	
	//Section 3
	
	flag_set( "kitchen_start" );
	
	//stop night vision logic again
	level notify( "security_office_closed" );
	
	if(start == "interior")
		return;
	
	flag_set("castle_interior_exterior_fog");
	flag_set("castle_control_room_fog");
	
	if(start == "inner_courtyard")
		return;
	
	flag_set( "inner_courtyard_initial_wave" );
	flag_set( "inner_courtyard_done" );
	
	flag_set("castle_courtyard_battle_fog");
	flag_set("castle_courtyard_battle_a_fog");

	if(start == "bridge_explode")
		return;
	
	flag_set("inner_courtyard_door_kick");
	flag_set( "give_bridge_detonator" );
	flag_set( "bridge_detonated" );
	
	flag_set("castle_bridge_explosion_fog");
	flag_set("castle_bridge_explosion_jump_fog");
	
	if(start == "courtyard_battle")
		return;
	
	flag_set("get_to_escape_truck");
	
	flag_set( "courtyard_btr_alive" );
	flag_set( "courtyard_btr_destroyed" );

	if(start == "escape")
		return;
	
	//flag_set("player_entering_truck");	
	flag_set("castle_escape_fog");
}


//
//	Set and stop exploders based on flags (so skiptos work too)
handle_environmental_fx()
{
	flag_wait( "player_landed" );

	exploder( 920 );	// rain and water drainage

	flag_wait( "peephole_start" );

	stop_exploder( 920 );
}

init_water_splash_fx(startPoint)
{
	
	thread handle_water_splash_fx();
	
	if ( !IsDefined(startPoint) )
	{
		startPoint = GetDVar("start");
	}

	switch ( startPoint )
	{
		case "cliff":
		case "escape":
		case "courtyard_battle":
			flag_set( "re_start_water_splash_fx" );
		case "bridge_explode":
		case "inner_courtyard":			
		case "interior":	
		case "kitchen_battle":
		case "into_wet_wall":		
		case "destroy_wet_wall":
		case "bridge_crossing":
		case "prison_battle_flare_room":
		case "prison_battle_start":
				flag_set( "stop_water_splash_fx" );
		case "security_office":
		case "platform_crawl":
		case "courtyard_activity":
		case "ruins":
		case "intro":
				flag_set( "start_water_splash_fx" );

		default:
			break;
	};
}

handle_water_splash_fx()
{
	flag_wait( "start_water_splash_fx" );
	exploder ( 9100 );
	exploder ( 9250 );
	exploder ( 5500 );
	exploder ( 530 );
	exploder ( 5700 );
	
	flag_wait( "stop_water_splash_fx" );
	stop_exploder ( 9100 );
	stop_exploder ( 5500 );
	stop_exploder ( 5800 );
	stop_exploder( 530 );
	stop_exploder ( 5700 );
	exploder ( 8000 );
	exploder ( 3500 );
	exploder ( 1234 );
	stop_exploder ( 9250 );
	
	flag_wait( "re_start_water_splash_fx" );
	exploder ( 9100 );
	exploder ( 530 );
	stop_exploder ( 3500 );
	stop_exploder ( 5000 );
	stop_exploder ( 1234 );
}

get_fog_ent(vision_set)
{
	current_vision_set = "";
	if ( IsDefined(vision_set) )
	{
		current_vision_set = vision_set;	
	}
	else if ( IsDefined(level.player.vision_set_transition_ent) )
	{
		current_vision_set = level.player.vision_set_transition_ent.vision_set;
	}
	else
	{
		current_vision_set = level.vision_set_transition_ent.vision_set;
	}
	return level.vision_set_fog[current_vision_set];
}

set_fog_ent(ent, transition_time)
{
	if ( !IsDefined(transition_time) )
	{
		transition_time = ent.transitiontime;
	}
	set_fog_to_ent_values( ent, transition_time );
	wait(transition_time);
}

handle_fog_changes()
{
	flag_wait("castle_intro_fog");	// set after first wall that player & price hide behind
	ent = get_fog_ent("castle_exterior");
	ent.sunBeginFadeAngle = 80;
	ent.sunEndFadeAngle = 90;
	set_fog_ent(ent, 1 );
		
	flag_wait("castle_intro_a_fog");	// set after first wall that player & price hide behind
	ent = get_fog_ent("castle_exterior");
	ent.sunBeginFadeAngle = 84;
	ent.sunEndFadeAngle = 92;
	set_fog_ent(ent, 1 );
	
	flag_wait("castle_courtyard_fog"); // set when player jumps down to the courtyard
	ent = get_fog_ent("castle_exterior");
	ent.sunBeginFadeAngle = 85;
	ent.sunEndFadeAngle = 95;
	ent.normalFogScale = 8;
	set_fog_ent(ent, 1 );

	flag_wait("castle_courtyard_a_fog"); // set when player jumps down to the courtyard
	ent = get_fog_ent("castle_exterior");
	ent.sunBeginFadeAngle = 80;
	ent.sunEndFadeAngle = 95;
	ent.normalFogScale = 5;
	set_fog_ent(ent, 1 );
	
	/*
	flag_wait("castle_dungeon_dark"); // when player reaches bottom of the stairs where price turns off the lights
	SetSavedDvar( "r_filmTweakContrast", 2 );
	
	flag_wait("castle_flare_room"); // right before entering flare room
	SetSavedDvar( "r_filmTweakContrast", 1.0 );
	SetSavedDvar( "r_filmTweakDesaturation", 0.5 );
	SetSavedDvar( "r_filmTweakDesaturationDark", 0.5 );
	*/
	
	flag_wait("castle_bridge_crossing_fog"); // player exits door out to bridge crossing
	ent = get_fog_ent("castle_exterior");
	ent.sunBeginFadeAngle = 70;
	ent.sunEndFadeAngle = 110;
	set_fog_ent(ent, 0.5 );
	
	flag_wait("castle_bridge_crossing_a_fog"); // player exits door out to bridge crossing
	ent = get_fog_ent("castle_exterior");
	ent.sunBeginFadeAngle = 70;
	ent.sunEndFadeAngle = 90;
	ent.normalFogScale = 5;
	set_fog_ent(ent, 1 );
	
	flag_wait("castle_interior_exterior_fog"); // player exits wine cellar
	ent = get_fog_ent("castle_exterior");
	ent.sunBeginFadeAngle = 70;
	set_fog_ent(ent, 1 );
	
	flag_wait("castle_control_room_fog");
	ent = get_fog_ent("castle_exterior");
	ent.sunBeginFadeAngle = 70;
	ent.normalFogScale = 5;
	set_fog_ent(ent, 1 );
	
	flag_wait("castle_courtyard_battle_fog");
	ent = get_fog_ent("castle_courtyard");
	ent.sunBeginFadeAngle = 80;
	ent.sunEndFadeAngle = 90;
	set_fog_ent(ent, 1 );
	
	flag_wait("castle_courtyard_battle_a_fog");
	ent = get_fog_ent("castle_courtyard");
	ent.sunBeginFadeAngle = 80;
	ent.sunEndFadeAngle = 95;
	set_fog_ent(ent, 1 );
	
	flag_wait("castle_bridge_explosion_fog"); // before pulling trigger to blow up bridge
	ent = get_fog_ent("castle_exterior");
	ent.sunBeginFadeAngle = 45;
	ent.sunEndFadeAngle = 75;
	set_fog_ent(ent, 1 );
	
	flag_wait("castle_bridge_explosion_jump_fog");
	ent = get_fog_ent("castle_exterior");
	ent.sunBeginFadeAngle = 75;
	ent.sunEndFadeAngle = 90;
	set_fog_ent(ent, 4 );
	
	flag_wait("castle_escape_fog");
	ent = get_fog_ent("castle_exterior");
	ent.startDist = 1000;
	ent.halfwayDist = 10000;
	ent.maxOpacity = 0.4;
	ent.sunFogEnabled = 0;
	set_fog_ent(ent, 1.5 );
}

setup_set_ents_visible_triggers()
{
	trig_visible = GetEntArray( "set_ents_visible", "script_noteworthy" );
	array_thread( trig_visible, ::trigger_wait_set_ents_visible, true );

	trig_hidden = GetentArray( "set_ents_hidden", "script_noteworthy" );
	array_thread( trig_hidden, ::trigger_wait_set_ents_visible, false );
}

trigger_wait_set_ents_visible( visible )
{
	self endon("death");
	for (;;)
	{
		self waittill("trigger");
		set_ents_visible( self.script_parameters, visible );	
	}
}

handle_generator_spotlights()
{
	lights = getentArray( "spotlight_generator", "targetname" );

	foreach(light in lights)
	{
		PlayFxOnTag( getfx( "gen_lamp_glow_white" ), light, "tag_fx_bulb_1");
		PlayFxOnTag( getfx( "gen_lamp_glow_white" ), light, "tag_fx_bulb_2");
		PlayFxOnTag( getfx( "gen_lamp_glow_white" ), light, "tag_fx_bulb_3");
	}
}

