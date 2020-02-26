#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_afghanstinger;
#include maps\_dialog;

main()
{
	// This MUST be first for CreateFX!	
	maps\afghanistan_fx::main();
	
	level_precache();
	level_init_flags();
	level_init_spawn_funcs();
	blocking_point_chooser();
	maps\so_cmp_afghanistan::setup_skiptos();
	setup_level();
	init_crew_emplacement();
	
	maps\_patrol::patrol_init();
	maps\voice\voice_afghanistan::init_voice();
	
	maps\_load::main();
	maps\afghanistan_amb::main();
	maps\afghanistan_anim::main();
	maps\afghanistan_anim::init_afghan_anims_part1();
	
	maps\_heatseekingmissile::init();
	//maps\_drones::init();
	
	maps\_rusher::init_rusher();
	
	setup_objectives();
	
	level thread maps\_objectives::objectives();
	level thread maps\createart\afghanistan_art::main();
	
	//level thread maps\afghanistan_utility::handle_map_controls();
	level thread lockbreaker_door();
	level thread intruder_door();
	level thread pull_out_sword();
	//level thread decapitate_heads();
	
	//Shawn J - Sound
	SetSavedDvar( "vehicle_sounds_cutoff", 30000 );
	SetDvar( "footstep_sounds_cutoff", 3000 );
	//battlechatter_on( "allies" );
	//battlechatter_on( "axis" );
	
	OnPlayerConnect_Callback( ::on_player_connect );
	OnSaveRestored_Callback( ::on_save_restored );
	level.callbackActorKilled = ::Callback_ActorKilled_Check;
	
	level thread maps\_horse_player::init();
	level.overrideActorDamage = maps\_horse::horse_actor_damage;
	
	level.horse_sprint_unlimited = true;
}


on_player_connect()
{
	level.player = get_players()[0];	
	
	setup_challenges();
	init_weapon_cache();
	
	level.player thread waittill_player_mounts_horse();
	level.player thread heli_evade();
}


on_save_restored()
{
	if ( level.player GetCurrentWeapon() == "afghanstinger_ff_sp" )
	{
		level.player SwitchToWeapon( "afghanstinger_sp" );
	}
}


level_precache()
{
	precachemodel( "c_usa_mason_afgan_wrap_viewbody" );
	precachemodel( "c_usa_mason_afghan_viewbody" );
	precachemodel( "t5_weapon_1911_sp_world" );
	precachemodel( "viewmodel_t6_wpn_pistol_m1911_animated" );
	precachemodel( "t6_wpn_mortar_shell_prop_view" );
	precachemodel( "viewmodel_binoculars" );
	precachemodel( "t5_weapon_static_binoculars" );
	PrecacheModel( "p6_afghanistan_herding_staff" );
	Precachemodel( "t6_wpn_pistol_m1911_prop_view" );
	//PrecacheModel( "p6_empty_bucket_anim" );
	//PrecacheModel( "anim_rus_gascan" );
	PrecacheModel( "com_hand_radio" );
	PrecacheModel( "p_glo_tools_hammer" );
	PrecacheModel( "p6_anim_smoking_pipe" );
	precachemodel( "com_hookah_pipe_anim" );
	PrecacheModel( "jun_ammo_crate_anim" );
	precachemodel( "p6_bullet_shell_pile_large_anim" );
	precachemodel( "p6_bullet_shell_pile_small_anim" );
	PrecacheModel( "t6_wpn_ar_ak47_prop" );
	PrecacheModel( "mil_ammo_case_anim_1" );
	PrecacheModel( "c_usa_jungmar_assault_fb" );
	Precachemodel( "p6_knife_karambit" );
	Precachemodel( "p6_wooden_chair_anim" );
	Precachemodel( "p_jun_gear_canteen" );
	PrecacheModel( "weapon_c4_detonator" );
	PrecacheModel( "rope_test_ri" );
	PrecacheModel( "t6_wpn_ar_ak47_world" );
	PrecacheModel( "fxanim_chopper_crash_blades" );
	PrecacheModel( "p6_anim_vulture" );
	PrecacheModel( "t6_wpn_cratercharge_prop" );
	
	PrecacheItem( "satchel_charge_sp" );
	PrecacheItem( "afghanstinger_sp" );
	PrecacheItem( "afghanstinger_ff_sp" );
	PrecacheItem( "rpg_magic_bullet_sp" );
	PrecacheItem( "ak47_sp" );
	PrecacheItem( "btr60_heavy_machinegun" );
	PrecacheItem( "hind_rockets" );
	PrecacheItem( "stinger_sp" );
	PrecacheItem( "rpg_player_sp" );
	PrecacheItem( "pulwar_sword_sp" );
	PrecacheItem( "tc6_mine_sp" );
	PrecacheItem( "sticky_grenade_afghan_sp" );
	
	PreCacheShader( "cinematic" );
	PreCacheShader( "fullscreen_dirt_bottom_b" );
	
	// ShellShock
	PrecacheShellshock( "afghan_horsefall" );
	
	maps\_horse::precache_models();
	maps\_horse_player::precache_models();
}


level_init_flags()
{
	flag_init( "bp_underway" );
	
	maps\afghanistan_horse_intro::init_flags();
	maps\afghanistan_intro_rebel_base::init_flags();
	maps\afghanistan_firehorse::init_flags();
	maps\afghanistan_wave_1::init_flags();
	maps\afghanistan_wave_2::init_flags();
	maps\afghanistan_wave_3::init_flags();
	maps\afghanistan_blocking_done::init_flags();
	maps\afghanistan_horse_charge::init_flags();
	maps\afghanistan_krav_captured::init_flags();
	maps\afghanistan_deserted::init_flags();
}

level_init_spawn_funcs()
{
	maps\afghanistan_horse_charge::init_spawn_funcs();
}


/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
setup_skiptos()
{
	//Section 1
	add_skipto( "intro", maps\afghanistan_intro::skipto_intro, "Intro", maps\afghanistan_intro::main );
	add_skipto( "horse_intro", maps\afghanistan_horse_intro::skipto_intro, "Horse Intro", maps\afghanistan_horse_intro::main );
	add_skipto( "rebel_base_intro", maps\afghanistan_intro_rebel_base::skipto_intro, "rebel base intro", maps\afghanistan_intro_rebel_base::main );

	//Section 2
	add_skipto( "firehorse", maps\afghanistan_firehorse::skipto_firehorse, "Fire Horse", maps\afghanistan_firehorse::main );
	add_skipto( "wave_1", maps\afghanistan_wave_1::skipto_wave1, "Wave 1", maps\afghanistan_wave_1::main );
	add_skipto( "wave_2", maps\afghanistan_wave_2::skipto_wave2, "Wave 2", maps\afghanistan_wave_2::main );
	add_skipto( "wave_3", maps\afghanistan_wave_3::skipto_wave3, "Wave 3", maps\afghanistan_wave_3::main );
	add_skipto( "blocking_done", maps\afghanistan_blocking_done::skipto_blockingdone, "Blocking Done", maps\afghanistan_blocking_done::main );
		
	//Section 3
	add_skipto( "horse_charge", maps\afghanistan_horse_charge::skipto_horse_charge, "Horse Charge", maps\afghanistan_horse_charge::main );
	add_skipto( "krav_tank", maps\afghanistan_horse_charge::skipto_krav_tank, "Krav Tank", maps\afghanistan_horse_charge::after_button_mash_scene );
	add_skipto( "krav_captured", maps\afghanistan_krav_captured::skipto_krav_captured, "Krav Captured", maps\afghanistan_krav_captured::main );
	add_skipto( "interrogation", maps\afghanistan_krav_captured::skipto_krav_interrogation, "Krav Captured", maps\afghanistan_krav_captured::interrogation );
	add_skipto( "beat_down", maps\afghanistan_krav_captured::skipto_beat_down, "Beatdown", maps\afghanistan_krav_captured::beatdown );
	add_skipto( "deserted", maps\afghanistan_deserted::skipto_deserted, "Deserted", maps\afghanistan_deserted::main );
	
	default_skipto( "intro" );
}


/* ------------------------------------------------------------------------------------------
OBJECTIVES
-------------------------------------------------------------------------------------------*/
setup_objectives()
{
	level.a_objectives = [];
	level.n_obj_index = 0;
	
	//Perk Objs
	level.OBJ_BRUTE_PERK = register_objective( &"" );
	level.OBJ_LOCK_PERK = register_objective( &"" );
	level.OBJ_INTRU_PERK = register_objective( &"" );
	
	//Section 1
	
	//level.OBJ_AFGHAN_BC1 = register_objective( &"AFGHANISTAN_BASECAMP_1");
	//level.OBJ_AFGHAN_BC2 = register_objective( &"AFGHANISTAN_BASECAMP_2");
	level.OBJ_AFGHAN_BC3A = register_objective( &"");
	level.OBJ_AFGHAN_BC3 = register_objective( &"AFGHANISTAN_BASECAMP_3");
	//level.OBJ_AFGHAN_RC1 = register_objective( &"AFGHANISTAN_REBEL_CAMP");
	
	//Section 2
	level.OBJ_FOLLOW_BP1 = register_objective( &"" );
	level.OBJ_FOLLOW_BP2 = register_objective( &"" );
	level.OBJ_FOLLOW_BP3 = register_objective( &"" );
	level.OBJ_DEFEND_CACHE1 = register_objective( &"AFGHANISTAN_OBJ_DEFEND_CACHE1" );
	level.OBJ_AFGHAN_BP1 = register_objective( &"AFGHANISTAN_OBJ_BP1" );
	level.OBJ_AFGHAN_BP1_VEHICLES = register_objective( &"AFGHANISTAN_BP1_VEHICLES" );
	level.OBJ_DESTROY_DOME = register_objective( &"AFGHANISTAN_OBJ_DESTROY_DOME" );
	level.OBJ_DESTROY_BTR = register_objective( &"AFGHANISTAN_OBJ_DESTROY_BTR" );
	level.OBJ_BP1_WAVE3 = register_objective( &"" );
	
	level.OBJ_BP2_MORTAR = register_objective( &"AFGHANISTAN_OBJ_BP2_MORTAR" );
	level.OBJ_AFGHAN_BP2 = register_objective( &"AFGHANISTAN_OBJ_BP2" );
	level.OBJ_DEFEND_CACHE2 = register_objective( &"AFGHANISTAN_OBJ_DEFEND_CACHE2" );
	level.OBJ_AFGHAN_BP2WAVE2_VEHICLES = register_objective( &"AFGHANISTAN_BP2WAVE2_VEHICLES" );
	level.OBJ_AFGHAN_BRIDGES = register_objective( &"AFGHANISTAN_OBJ_BRIDGES" );
	level.OBJ_AFGHAN_BP2WAVE3_VEHICLES = register_objective( &"AFGHANISTAN_BP2WAVE3_VEHICLES" );
	level.OBJ_BP2_WAVE3 = register_objective( &"" );
	level.OBJ_BP2_ARCH = register_objective( &"" );
	
	level.OBJ_AFGHAN_BP1WAVE3_VEHICLES = register_objective( &"AFGHANISTAN_BP1WAVE3_VEHICLES" );
	level.OBJ_AFGHAN_BP3WAVE2_VEHICLES = register_objective( &"AFGHANISTAN_BP3WAVE2_VEHICLES" );
	level.OBJ_AFGHAN_BP3 = register_objective( &"AFGHANISTAN_OBJ_BP3" );
	level.OBJ_AFGHAN_BP3WAVE3_VEHICLES = register_objective( &"AFGHANISTAN_BP3WAVE3_VEHICLES" );
	level.OBJ_AFGHAN_WAVE3 = register_objective( &"AFGHANISTAN_OBJ_WAVE3" );	
	level.OBJ_BP3_WAVE3 = register_objective( &"" );
	//level.OBJ_WAVE2_THREAT = register_objective( &"AFGHANISTAN_OBJ_WAVE2_THREAT" );
	//level.OBJ_WAVE3_THREAT = register_objective( &"AFGHANISTAN_OBJ_WAVE3_THREAT" );
	
	level.OBJ_PROTECT = register_objective( &"AFGHANISTAN_OBJ_PROTECT" );
	level.OBJ_DEFEND_ALL = register_objective( &"AFGHANISTAN_OBJ_DEFEND_ALL" );
	level.OBJ_RETURN_BASE = register_objective( &"AFGHANISTAN_OBJ_RETURN_BASE" );
	
	
	//Section 3
}


setup_level()
{
	//DEMO: for Greenlight demo
	level.press_demo = 0;
	
	level.n_current_wave = 1;
	level.player_wave3_loc = 0;  //bp the player is located when wave3 is complete
	level.caches_lost = 0;
	
	t_cache_guard = GetEnt( "trigger_firehorse_cache_guard", "targetname" );
	t_cache_guard trigger_off();
	
	t_exit = getent( "tunnel_exit", "targetname" );
	t_exit trigger_off();
		
	t_overlook = getent( "player_at_overlook", "targetname" );
	t_overlook trigger_off();
	
	t_chase = GetEnt( "trigger_uaz_chase", "targetname" );
	t_chase trigger_off();
	
	m_cratercharge = GetEnt( "crater_charge_explosive", "targetname" );
	m_cratercharge Hide();
	
	//wave2 - bp3
	trigger_off( "trigger_btr_chase", "script_noteworthy" );
	
	t_bp3_uaz = GetEnt( "spawn_wave2_bp3", "targetname" );
	t_bp3_uaz trigger_off();
		
	bm_clips1 = GetEntArray( "bridge1_clip", "targetname" );
	foreach( bm_clip in bm_clips1 )
	{
		bm_clip trigger_off();
		bm_clip ConnectPaths();
	}
	
	bm_clips2 = GetEntArray( "bridge2_clip", "targetname" );
	foreach( bm_clip in bm_clips2 )
	{
		bm_clip trigger_off();
		bm_clip ConnectPaths();
	}
	
	bm_clips3 = GetEntArray( "bridge3_clip", "targetname" );
	foreach( bm_clip in bm_clips3 )
	{
		bm_clip trigger_off();
		bm_clip ConnectPaths();
	}
	
	bm_clips4 = GetEntArray( "bridge4_clip", "targetname" );
	foreach( bm_clip in bm_clips4 )
	{
		bm_clip trigger_off();
		bm_clip ConnectPaths();
	}
	
	t_bp3_exit = getentarray( "bp3_exit_flag_trigger", "script_noteworthy" );
	foreach( t_trig in t_bp3_exit )
	{
		t_trig trigger_off();
	}
	
	m_clip_arch = GetEnt( "BP2_tankdebris", "targetname" );
	m_clip_arch trigger_off();
	m_clip_arch ConnectPaths();
	
	//bp3 cache
	t_bp3_cache = GetEnt( "trigger_zhao_cache", "script_noteworthy" );
	t_bp3_cache trigger_off();
	
	a_m_destroyed_dome = GetEntArray( "archway_destroyed_static", "targetname" );
	foreach( m_dest in a_m_destroyed_dome )
	{
		m_dest Hide();
		m_dest NotSolid();
	}
	
	t_pulwar_victim = GetEnt( "trigger_pulwar_victim", "targetname" );
	t_pulwar_victim trigger_off();
	
	level.tank_dest = GetEnt( "firehorse_tank_dest", "targetname" );
	level.tank_dest Hide();
	level.tank_dest NotSolid();
	level.tank_dest ConnectPaths();
	
	SetSavedDvar( "vehicle_selfCollision", 0 );
}


blocking_point_chooser()
{
	// Wave 2
	level.wave2_loc = "blocking point 2";
	
	if ( cointoss() )
	{
		level.wave2_loc = "blocking point 3";
	}
	
	// Wave 3
	if ( level.wave2_loc == "blocking point 2" )
	{
		level.wave3_loc = "blocking point 3";  //plus "blocking point 1"
	}
	
	else
	{
		level.wave3_loc = "blocking point 2";
	}
}


waittill_player_mounts_horse()  //self = level.player
{
	level endon( "blocking_done" );
	
	while( 1 )
	{
		self waittill( "enter_vehicle", vehicle );
		
		level.mason_horse = vehicle;;
		
		if ( vehicle.vehicletype == "horse_player" || vehicle.vehicletype == "horse" )
		{
			SetSavedDvar( "player_disableWeaponsOnVehicle", "0" );
		}
		
		vehicle veh_magic_bullet_shield( true );
		
		self waittill( "exit_vehicle", vehicle );
		
		SetSavedDvar( "player_disableWeaponsOnVehicle", "1" );
	}
}


lockbreaker_door()
{
	trigger_off( "intruder_box", "targetname" );
	trigger_off( "lockbreaker_trigger", "targetname" );
	
	while( !isdefined( level.player ) )
	{
		wait 0.5;
	}
	
	level.player waittill_player_has_lock_breaker_perk();
		
	trigger_on( "intruder_box", "targetname" );
	trigger_on( "lockbreaker_trigger", "targetname" );
	
	m_door = GetEnt( "afghan_lockbreaker_door", "targetname" );
	m_door_clip = GetEnt( "afghan_lockbreaker_door_clip", "targetname" );
	m_door LinkTo( m_door_clip );
	m_door_hinge = GetEnt( "lockbreaker_hinge", "targetname" );
	m_door_clip LinkTo( m_door_hinge );
	
	s_obj = getstruct( "lockbreaker_objective", "targetname" );
	
	set_objective( level.OBJ_LOCK_PERK, s_obj, "interact" );
	
	trigger_wait( "lockbreaker_trigger" );
	
	trigger_off( "lockbreaker_trigger", "targetname" );
	
	set_objective( level.OBJ_LOCK_PERK, s_obj, "remove" );
	
	run_scene("lockbreaker");
	level notify( "player_accessed_perk" );

	m_door_clip playsound( "evt_specialty_door_open" );
	m_door_hinge RotateYaw( 78, 1 );	
	
	flag_set( "lockbreaker_opened" );
	
	/*
	level.player GiveWeapon( "sticky_grenade_afghan_sp" );
	level.player GiveMaxAmmo( "sticky_grenade_afghan_sp" );
	*/
	level.player give_grenade( "sticky_grenade_afghan_sp" );
		
	sticky_grenade_hint();
}

//self == player
give_grenade( str_grenade_type )
{
	players_grenades = [];
	
	a_player_weapons = self GetWeaponsList();
	foreach( weapon in a_player_weapons )
	{
		if( WeaponType( weapon ) == "grenade" )
		{
			ArrayInsert( players_grenades, weapon, players_grenades.size );
		}
	}
	
	if( players_grenades.size >= 2 )
	{
		//-- assuming the 2nd grenade is always the secondary offhand slot
		self TakeWeapon( players_grenades[1] );
	}
	
	self GiveWeapon( str_grenade_type );
	self GiveMaxAmmo( str_grenade_type );
}


sticky_grenade_hint()
{
	level endon( "sticky_threw" );
	
	screen_message_create( &"AFGHANISTAN_HINT_STICKY_THROW" );
	
	level thread hint_timer( "sticky_threw" );
	while ( !level.player SecondaryOffhandButtonPressed() )
	{
		wait .05;
	}
	
	screen_message_delete();
	
	level notify( "sticky_threw" );
}


intruder_door()
{
	trigger_off( "intruder_box", "targetname" );
	
	while( !isdefined( level.player ) )
	{
		wait 0.5;
	}
	
	level.player waittill_player_has_intruder_perk();
	
	run_scene_first_frame( "intruder_box_and_mine" );
	
	trigger_on( "intruder_box", "targetname" );
	
	s_obj = getstruct( "intruder_objective", "targetname" );
	
	set_objective( level.OBJ_INTRU_PERK, s_obj, "interact" );
	
	trigger_wait( "intruder_box" );
	
	trigger_off( "intruder_box", "targetname" );
	
	set_objective( level.OBJ_INTRU_PERK, s_obj, "remove" );
	
	level thread run_scene( "intruder_box_and_mine" );
	run_scene( "intruder" );
	level notify( "player_accessed_perk" );
	
	level.player GiveWeapon( "tc6_mine_sp" );
	level.player SetActionSlot( 1, "weapon", "tc6_mine_sp" );
	level.player GiveMaxAmmo( "tc6_mine_sp" );
	
	level thread mine_hint();
	
	level.woods thread maps\_dialog::say_dialog( "wood_try_and_lay_them_in_0", 1 );  //Try and lay them in the path of the vehicles.
}

mine_hint()
{
	level endon( "mine_placed" );
	
	level thread hint_timer( "mine_selected" );
	screen_message_create( &"AFGHANISTAN_HINT_MINE_SELECT" );
	
	while ( !level.player ActionSlotOneButtonPressed() )
	{
		wait .05;
	}
	
	level notify( "mine_selected" );
	
	level thread hint_timer( "mine_placed" );
	screen_message_delete();
	screen_message_create( &"AFGHANISTAN_HINT_MINE_PLACE" );
	
	level.player waittill_attack_button_pressed();
	
	screen_message_delete();
	level notify( "mine_placed" );
}

hint_timer( str_notify )
{
	level endon( str_notify );
	
	wait 3;
	
	screen_message_delete();
}

pull_out_sword()
{
	trigger_off("pullout_pulwar", "targetname");
	level run_scene_first_frame("e1_s1_pulwar_single");
	
	while( !isdefined(level.player) )
	{
		wait .5;
	}
	level.player waittill_player_has_brute_force_perk();
	
	if ( level.skipto_point == "intro" )
	{
		scene_wait ("e1_zhao_horse_charge_player");
	}
	
	trigger_on("pullout_pulwar", "targetname");
	
	//trigger = GetEnt( "pullout_pulwar", "targetname" );
	s_pullout_pulwar_obj = getstruct("pullout_pulwar_obj");
	
	set_objective( level.OBJ_BRUTE_PERK, s_pullout_pulwar_obj, "interact" );
	
	trigger_wait("pullout_pulwar");
	level.player FreezeControlsAllowLook( true );
	trigger_off("pullout_pulwar", "targetname");
	thread set_objective( level.OBJ_BRUTE_PERK,  s_pullout_pulwar_obj, "remove" );
	level run_scene("e1_s1_pulwar");
	level notify( "player_accessed_perk" );
	
	//dead_guy = GetEnt("dead_guy_ai", "targetname");
	//dead_guy ragdoll_death();
	scene_wait("e1_s1_pulwar");
	level.player FreezeControlsAllowLook( false );
	level.player GiveWeapon("pulwar_sword_sp");
}


// Challenge script

setup_challenges( )
{
	self thread maps\_challenges_sp::register_challenge( "nodeath", ::nodeath_challenge );
	self thread maps\_challenges_sp::register_challenge( "locateintel", ::locate_int );
	self thread maps\_challenges_sp::register_challenge( "tank_mine", ::tank_mine );
	self thread maps\_challenges_sp::register_challenge( "pulwar_sword", ::pulwar_sword_challenge );
	self thread maps\_challenges_sp::register_challenge( "grenade_helo", ::lockbreaker_challenge );
	self thread maps\_challenges_sp::register_challenge( "kill_heli_with_truck_mg", ::kill_helis_with_truck_mg );  // kill helicopters with truck mounted MG
	self thread maps\_challenges_sp::register_challenge( "trampled_under_hoof", ::trampled_under_hoof );  // run over guys with horse
	self thread maps\_challenges_sp::register_challenge( "blocking_point_2_kill_helis", ::blocking_point_2_kill_helis );
	self thread maps\_challenges_sp::register_challenge( "helo_rpg", ::helo_rpg);
	self thread maps\_challenges_sp::register_challenge( "rain_fire", ::rain_fire_challenge );
}


pulwar_sword_challenge( str_notify )
{
	while( 1 )
	{
		level waittill( "killed_by_sword" );
	
		self notify( str_notify );
	}
}


rain_fire_challenge( str_notify )
{
	while( 1 )
	{
		level waittill( "killed_by_rainfire" );
	
		self notify( str_notify );
	}
}


Callback_ActorKilled_Check( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime )
{
	if ( IsDefined( eAttacker ) )
	{
		if ( IsPlayer( eAttacker ) )
		{
			if ( sWeapon == "afghanstinger_sp" )
			{
				level notify( "killed_by_rainfire" );
			}
			
			else if ( sWeapon == "pulwar_sword_sp" )
			{
				level notify( "killed_by_sword" );
			}
		}
	}
}


nodeath_challenge( str_notify )
{
	level.player waittill( "mission_finished" );
	n_deaths = get_player_stat( "deaths" );
	
	if ( n_deaths == 0 )
	{
		self notify( str_notify );
	}
	
}

		
locate_int( str_notify )
{
	level.player waittill( "mission_finished" );
	
	player_collected_all = collected_all();
	
	if( player_collected_all )
	{
		self notify( str_notify );		
	}
	
}

accessallperk( str_notify )
{
	while ( true )
	{
		level waittill( "player_accessed_perk" );
		self notify( str_notify );
	}
}

trampled_under_hoof( str_notify )
{
	b_vo_said = false;
	
	while( true )
	{
		level waittill( "player_trampled_ai_with_horse" );  // sent from _horse.gsc
		self notify( str_notify );
		
		//maso_shit_gotta_hurt_0 - line cut as requested
		/*if ( !b_vo_said )
		{
			level.player thread say_dialog( "maso_shit_gotta_hurt_0", 0.5 );  //Shit! Gotta hurt!
			
			b_vo_said = true;
		}*/
		
		if ( RandomInt( 20 ) == 13 )
		{
			if ( cointoss() )
			{
				level.player thread say_dialog( "maso_shoulda_moved_fucke_0", 0.5 );  //Shoulda moved, fucker!
			}
			
			else
			{
				level.player thread say_dialog( "maso_get_outta_the_way_0", 0.5 );  //Get outta the way!
			}
		}
	}
}

kravchenko_intel( str_notify )
{
	level waittill( "krav_gives_all_intel" );
	
	self notify( str_notify );
}

kill_helis_with_truck_mg( str_notify )
{
	while( true )
	{
		level waittill( "killed_heli_with_truck_mg" );
		self notify( str_notify );
	}
}

lockbreaker_challenge( str_notify )
{
	level waittill( "helo_destroyed_by_grenade" );

	self notify( str_notify );	

}

blocking_point_2_kill_helis( str_notify )
{	
	while ( true )
	{
		level waittill( "blocking_point_2_heli_shot_down" );
		self notify( str_notify );
	}
}

helo_rpg( str_notify )
{
	level waittill( "helo_shot_down_by_rpg" );
	
	self notify( str_notify );
}

tank_mine( str_notify )
{
	level waittill( "tank_destroyed_by_mine" );
	
	self notify( str_notify );
}