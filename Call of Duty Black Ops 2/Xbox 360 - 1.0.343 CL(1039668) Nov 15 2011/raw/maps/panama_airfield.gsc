#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\panama_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_stealth_logic;

skipto_zodiac()
{
	level.mason = init_hero( "mason" );

	a_hero[0] = level.mason;
	start_teleport( "skipto_beach_player", a_hero );
	
	flag_set( "movie_done" );

	airfield_spawnfuncs();
	
	maps\createart\panama_art::airfield();
	
	flag_wait( "panama_gump_2" );
}

skipto_beach()
{
	level.mason = init_hero( "mason" );

	a_hero[0] = level.mason;
	start_teleport( "skipto_beach_player", a_hero );
	
	level.mason set_ignoreall( true );
	level.mason set_ignoreme( true );
	
	flag_set( "movie_done" );
	
	airfield_spawnfuncs();
	
	maps\createart\panama_art::airfield();
	
	flag_wait( "panama_gump_2" );	
}

skipto_runway()
{
	level.mason = init_hero( "mason" );

	a_hero[0] = level.mason;
	start_teleport( "skipto_runway_player", a_hero );

	airfield_spawnfuncs();
	
	maps\createart\panama_art::airfield();	
	
	flag_wait( "panama_gump_2" );	
}

skipto_learjet()
{
	level.mason = init_hero( "mason" );

	a_hero[0] = level.mason;
	start_teleport( "skipto_learjet_player", a_hero );	

	airfield_spawnfuncs();

	maps\createart\panama_art::airfield();
	
	flag_wait( "panama_gump_2" );
}

init_airfield_flags()
{
	flag_init( "zodiac_approach_start" );
	flag_init( "zodiac_approach_end" );
	flag_init( "player_at_first_blood" );
	flag_init( "mason_at_first_blood" );
	flag_init( "first_blood_guys_cleared" );
	flag_init( "contacted_skinner" );
	flag_init( "rooftop_goes_hot" );
	flag_init( "runway_standoff_goes_hot" );
	flag_init( "airfield_end" );
	flag_init( "hangar_doors_closing" );
	flag_init( "spawn_pdf_assaulters" );
	flag_init( "parking_lot_gone_hot" );	
	flag_init( "hangar_gone_hot" );	
	flag_init( "learjet_gone_hot" );	
	flag_init( "stop_intro_planes" );		
	flag_init( "stop_runway_planes" );		
	flag_init( "remove_hangar_god_mode" );		
	flag_init( "player_in_hangar" );
	flag_init( "beach_jet_done" );
	flag_init( "hotel_jet_done" );	
	flag_init( "hangar_pdf_cleared" );	
	flag_init( "rooftop_guy_killed" );	
	flag_init( "seal_1_in_pos" );	
	flag_init( "seal_2_in_pos" );	
	flag_init( "start_pdf_ladder_reaction" );
	flag_init( "player_contextual_start" );	
	flag_init( "player_contextual_end" );	
	flag_init( "player_destroyed_learjet" );
	flag_init( "player_opened_grate" );
	flag_init( "player_second_melee" );
	flag_init( "player_climb_up_done" );
	flag_init( "contextual_melee_success" );
	flag_init( "skinner_motel_dialogue" );
}

airfield_spawnfuncs()
{
	CreateThreatBiasGroup( "hangar_pdf" );
	CreateThreatBiasGroup( "hangar_seals" );
	CreateThreatBiasGroup( "hangar_player" );
	CreateThreatBiasGroup( "hangar_mason" );	
	CreateThreatBiasGroup( "pdf_assaulters" );	
	
	CreateThreatBiasGroup( "rooftop_pdf" );	
	CreateThreatBiasGroup( "runway_seals" );	
	
	CreateThreatBiasGroup( "learjet_pdf" );	
	CreateThreatBiasGroup( "learjet_seals" );	
	
	//forcegoal func
	a_force_goal_guy = GetEntArray( "force_goal_guy", "script_noteworthy" );	
	array_thread( a_force_goal_guy, ::add_spawn_function, ::init_force_goal_guy  );
	
	//rocket-man-o-matic
	a_rocket_man = GetEntArray( "rocket_man", "script_noteworthy" );	
	array_thread( a_rocket_man, ::add_spawn_function, ::make_rpg_guy  );	
	
	//parking lot pdf
	a_pdf_stealth = GetEntArray( "pdf_stealth", "script_noteworthy" );
	array_thread( a_pdf_stealth, ::add_spawn_function, maps\_stealth_logic::stealth_ai );	

	//hangar
	a_pdf_hangar_assaulters = GetEntArray( "pdf_hangar_assaulters", "targetname" );
	array_thread( a_pdf_hangar_assaulters, ::add_spawn_function, ::init_hangar_assaulters );
		
	a_rooftop_pdf = GetEntArray( "rooftop_pdf", "targetname" );
	array_thread( a_rooftop_pdf, ::add_spawn_function, ::init_rooftop_pdf );
	
	hangar_pdf = GetEntArray( "hangar_pdf", "targetname" );
	array_thread( hangar_pdf, ::add_spawn_function, ::init_hangar_pdf );
	
	hangar_frontline = GetEntArray( "hangar_frontline", "targetname" );
	array_thread( hangar_frontline, ::add_spawn_function, ::init_hangar_pdf );
	
	hangar_seals = GetEntArray( "hangar_seals", "targetname" );	
	array_thread( hangar_seals, ::add_spawn_function, ::init_hangar_seals );	
	
	//Lear Jet
	learjet_seals = GetEntArray( "learjet_seals", "targetname" );	
	array_thread( learjet_seals, ::add_spawn_function, ::init_learjet_seals );	
		
	a_learjet_pdf = GetEntArray( "learjet_pdf", "targetname" );	
	array_thread( a_learjet_pdf, ::add_spawn_function, ::init_learjet_pdf_runway );	
	
	learjet_pdf_runway = GetEntArray( "learjet_pdf_runway", "targetname" );	
	array_thread( learjet_pdf_runway, ::add_spawn_function, ::init_learjet_pdf_runway );	
	
	learjet_pdf_backup = GetEntArray( "learjet_pdf_backup", "targetname" );
	array_thread( learjet_pdf_backup, ::add_spawn_function, ::init_learjet_pdf_runway );
	
	learjet_turret_guy = GetEnt( "learjet_turret_guy", "targetname" );
	add_spawn_function( learjet_turret_guy, ::init_learjet_turret_guy );
	
	pdf_hangar_assaulters = GetEntArray( "pdf_hangar_assaulters", "targetname" );
	array_thread( pdf_hangar_assaulters, ::add_spawn_function, ::init_pdf_hangar_assaulters );	
}

make_rpg_guy()
{
	self endon( "death" );
	
//	self gun_remove();
//	self gun_switchto( "rpg_sp", "right" );	
//	self.a.rockets = 3;
}

init_force_goal_guy()
{
	self endon( "death" );	
	
	nd_goal = GetNode( self.target, "targetname" );
	self force_goal( nd_goal, 16 );	
}

init_learjet_turret_guy()
{		
	self endon( "death" );
	
	self thread pickup_disable_turret_on_gunner_death();
	
	self magic_bullet_shield();
	
	flag_wait( "learjet_gone_hot" );
	
	self stop_magic_bullet_shield();		
}

init_hangar_assaulters()
{
	self endon( "death" );
	
	nd_goal = GetNode( self.target, "targetname" );
	self force_goal( nd_goal, 16 );
}

init_learjet_seals()
{
	self endon( "death" );
	
	self SetThreatBiasGroup( "learjet_seals" );	
}

init_learjet_pdf_runway()
{
	self endon( "death" );
	
	//self.goalradius = 32;
	self SetThreatBiasGroup( "learjet_pdf" );	
}

init_pdf_hangar_assaulters()
{
	self endon( "death" );

	self SetThreatBiasGroup( "pdf_assaulters" );	
}

init_hangar_pdf()
{
	self endon( "death" );
	
	self SetThreatBiasGroup( "hangar_pdf" );
	
	if ( !flag( "spawn_pdf_assaulters" ) )
	{
		volume_hangar_front = GetEnt( "hangar_front", "targetname" );
		self SetGoalVolumeAuto( volume_hangar_front );
	}
	else
	{
		volume_hangar_back = GetEnt( "hangar_back", "targetname" );
		self SetGoalVolumeAuto( volume_hangar_back );
	}	
		
	if ( !flag( "remove_hangar_god_mode" ) )
	{
		self magic_bullet_shield();
		
		flag_wait( "remove_hangar_god_mode" );
		
		self stop_magic_bullet_shield();
	}
}

init_hangar_seals()
{
	self endon( "death" );

	self SetThreatBiasGroup( "hangar_seals" );
	
	if ( !flag( "remove_hangar_god_mode" ) )
	{
		self magic_bullet_shield();
	
		flag_wait( "remove_hangar_god_mode" );
		
		self stop_magic_bullet_shield();
	}	
}

init_rooftop_pdf()
{
	self endon( "death" );
	
	self.goalradius = 32;
	
	self magic_bullet_shield();
	
	flag_wait( "rooftop_goes_hot" );

	self stop_magic_bullet_shield();

	SetIgnoreMeGroup( "runway_seals", "rooftop_pdf" );
	
	switch( self.script_noteworthy )
	{
		case "rooftop_pdf_engager_1":
			nd_engager_1 = GetNode( "nd_engager_1", "targetname" );
			self force_goal( nd_engager_1, 16 );
			break;		
		case "rooftop_pdf_engager_2":
			nd_engager_2 = GetNode( "nd_engager_2", "targetname" );
			
			self.animname = "slide_guy_1";
			run_scene( "rooftop_slide_1" );
			
			self force_goal( nd_engager_2, 16 );	
			break;
		case "rooftop_pdf_engager_3":
			
			self.animname = "slide_guy_2";
			run_scene( "rooftop_slide_2" );
			
			nd_engager_3 = GetNode( "nd_engager_3", "targetname" );
			self force_goal( nd_engager_3, 16 );		
			break;
		case "rooftop_snipers":
			self set_spawner_targets( "rooftop_nodes" );		
			break;
	}
}

zodiac_approach_main()
{
	flag_wait( "panama_gump_2" );
	
	//wait for old man movie 1
	flag_wait( "movie_done" );
	
	level.mason = init_hero( "mason" );
	level.mason set_ignoreall( true );
	level.mason set_ignoreme( true );
	
	//FOG
	maps\createart\panama_art::airfield();	
	
	airfield_spawnfuncs();
	
	level thread run_scene( "zodiac_approach_boat" );
	level thread run_scene( "zodiac_approach_seals" );
	
	level thread zodiac_seal_squad();
	level thread zodiac_mason();
	
	level thread invasion_read();
	
	level thread beach_fail_condition();
	
	delay_thread( 2, ::zodiac_jet_flyover );
	
	level.player playloopsound( "evt_boat_loop", 1 );
	level.player delay_thread( 20, ::end_boat_sounds );
	
	flag_set( "zodiac_approach_start" );
	
	run_scene( "zodiac_approach_player" );
	run_scene( "zodiac_dismount_player" );
	delete_zodiac_scenes();
	
	flag_set( "zodiac_approach_end" );
	
	autosave_by_name( "beach" );
}

end_boat_sounds()
{
	level.player stoploopsound( 1 );
	level.player playsound( "evt_boat_stop" );
}

beach_fail_condition()
{
	trigger_wait( "beach_fail" );
	
	SetDvar( "ui_deadquote", &"PANAMA_HANGAR_FAIL" );

	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();	
}

zodiac_jet_flyover()
{
	vh_zodiac_jets = spawn_vehicles_from_targetname_and_drive( "vh_zodiac_jets" );
	array_thread( vh_zodiac_jets, ::add_jet_fx ); 
}

invasion_read()
{
	wait( 4 );
	
	level thread sky_fire_light_ambience( "airfield", "airfield_end" );
	
	level thread air_ambience( "beach_jet", "beach_jet_path", "beach_jet_done", 4.0, 7.0 );
	
//	level thread section_1_ac130_ambience( "motel_scene_end" );
		
	exploder( 101 ); //FLAK AA FIRE
	
	level thread runway_landing();
		
	//outgoing trucks	
	vh_trucks = spawn_vehicles_from_targetname_and_drive( "intro_trucks" );
	
	foreach( truck in vh_trucks )
	{
		truck veh_toggle_tread_fx( false );
	}
}

section_1_ac130_ambience( flag_ender )
{
	a_ac130_amb_struct = getstructarray( "ac130_amb_struct", "targetname" );	
	
	while( !flag( flag_ender ) )
	{
		s_start_pos = a_ac130_amb_struct[ RandomInt( a_ac130_amb_struct.size ) ];		
		s_end_pos = getstruct( s_start_pos.target, "targetname" );

		e_fx_start = Spawn( "script_model", s_start_pos.origin );
		e_fx_start.angles = s_start_pos.angles;
		e_fx_start SetModel( "tag_origin" );
	
		for ( i = 0; i < 60; i++ )
		{
			v_offset = ( RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ), 0 );
			MagicBullet( "ac130_vulcan_minigun", s_start_pos.origin, s_end_pos.origin + v_offset );
			PlayFXOnTag( getfx( "ac130_intense_fake" ), e_fx_start, "tag_origin" );
			
			wait 0.1;
		}
		
		e_fx_start Delete();
		
		wait 5;
	}	
}

runway_landing()
{
	level endon( "stop_runway_planes" );
	
	runway_landing_start = GetVehicleNode( "runway_landing_start", "targetname" );

	n_wait = RandomIntRange( 20, 30 );
	
	while ( 1 )
	{
		runway_plane = SpawnVehicle( "veh_t6_air_private_jet", "runway_landing_plane", "plane_learjet", runway_landing_start.origin, runway_landing_start.angles );	
		runway_plane thread go_path( runway_landing_start );
		runway_plane veh_magic_bullet_shield( true );
			
		wait n_wait;
	}	
}

delete_zodiac_scenes()
{
	delete_ais_from_scene( "zodiac_approach_seal_group_1" );
	delete_ais_from_scene( "zodiac_approach_seal_group_2" );
	delete_ais_from_scene( "zodiac_approach_seal_group_3" );
	
	delete_models_from_scene( "zodiac_approach_seal_boat_1" );
	delete_models_from_scene( "zodiac_approach_seal_boat_2" );
	delete_models_from_scene( "zodiac_approach_seal_boat_3" );
}

zodiac_seal_squad()
{
	level thread run_scene( "zodiac_approach_seal_boat_1" );
	level thread run_scene( "zodiac_approach_seal_group_1" );
	
	level thread run_scene( "zodiac_approach_seal_boat_2" );
	level thread run_scene( "zodiac_approach_seal_group_2" );
	
	level thread run_scene( "zodiac_approach_seal_boat_3" );
	level thread run_scene( "zodiac_approach_seal_group_3" );
}

zodiac_mason()
{
	run_scene( "zodiac_approach_mason" );
	//run_scene( "zodiac_dismount_mason" );
	level.mason Unlink();
	
	skipto_beach_player_ai = getstruct( "skipto_beach_player_ai", "targetname" );
	
	level.mason forceteleport( skipto_beach_player_ai.origin, skipto_beach_player_ai.angles );
	
	nd_mason_beach = GetNode( "nd_mason_beach", "targetname" );
	level.mason SetGoalNode( nd_mason_beach );	
	level.mason waittill( "goal" );
}

beach_main()
{
	level thread first_blood_fail(); //backtracking fail
	
	flag_wait( "spawn_first_blood_guys" );

	level thread parking_lot_scene();
	
	level thread melee_guard_01(); //guard player kills
	level thread melee_guard_02(); //guard mason kills
	level thread melee_guard_03(); //booth guard
	
	level thread player_contextual_kill();
	level thread mason_contextual_kill();
		
	flag_wait( "parking_lot_gone_hot" );

	trig_color_parking_mid = GetEnt( "trig_color_parking_mid", "targetname" );
	trig_color_parking_end = GetEnt( "trig_color_parking_end", "targetname" );
	
	waittill_ai_group_ai_count( "parking_lot_guys", 3 );
	
	wait 0.05;
	
	if ( IsDefined( trig_color_parking_mid ) )
	{
		trig_color_parking_mid notify( "trigger" );
	}

	waittill_ai_group_cleared( "parking_lot_guys" );
	level.mason change_movemode( "sprint" );

	wait 0.05;
	
	if ( IsDefined( trig_color_parking_end ) )
	{
		trig_color_parking_end notify( "trigger" );
	}
}

melee_guard_01()
{
	flag_wait( "player_opened_grate" );

	ai_first_blood_guard_1 = simple_spawn_single( "ai_first_blood_guard_1" );
	ai_first_blood_guard_1.animname = "guard_1";
	
	run_scene( "guard_01_walkup" );
	
	level thread run_scene( "guard_01_loop" );
	
	flag_wait( "player_contextual_start" );

	run_scene( "guard_01_grab_kill" );
	
	run_scene( "guard_01_button_wait" );
	
	//flag check to see if player hit melee or timed out
//	if ( flag( "contextual_melee_success" ) )
//	{
		run_scene( "guard_01_kill" );
//	}
//	else
//	{
//		run_scene( "guard_01_no_kill" );
//	}
}

melee_guard_02() //guard mason kills
{
	flag_wait( "player_opened_grate" );
	
	ai_first_blood_guard_2 = simple_spawn_single( "ai_first_blood_guard_2" );
	ai_first_blood_guard_2.animname = "guard_2";	
	
	level thread run_scene( "guard_02_loop" );
	
	flag_wait( "player_contextual_start" );
	
	run_scene( "guard_02_kill" );
}

melee_guard_03()
{
	flag_wait( "player_opened_grate" );

	ai_first_blood_guard_3 = simple_spawn_single( "ai_first_blood_guard_3" );
	ai_first_blood_guard_3.animname = "guard_3";	
	
	level thread run_scene( "guard_03_loop" );
	
	flag_wait( "player_contextual_start" );
	
	run_scene( "guard_03_button_wait" );
	
	//check for player button press
//	if ( flag( "contextual_melee_success" ) )
//	{
		run_scene( "guard_03_kill" );
//	}
//	else
//	{
//		run_scene( "guard_03_no_kill" );
//	}
}

player_contextual_kill()
{
	level.player.ignoreme = 1;
	
	iprintlnbold( "Mason: stay low and quiet." );
	
	//a_players_weapons = GetWeaponsList();
		
	//give player knife
//	level.player TakeAllWeapons();
//	level.player GiveWeapon( "knife_held_sp" );
//	level.player SwitchToWeapon( "knife_held_sp" );
	
	trig_contextual_melee = GetEnt( "trig_contextual_melee", "targetname" );
	
	trigger_wait( "trig_contextual_melee" ); //trigger at the end of the drain pipe
	flag_set( "player_opened_grate" );
	
	run_scene( "player_grate" );
	flag_set( "player_climb_up_done" );
	
	level thread run_scene( "player_melee_loop" );
	
	level.trigger_hint_func[ "contextual_kill" ] = ::contextual_kill_check;	
	level thread display_hint( "contextual_kill" );	
	
	while ( 1 )
	{
		if ( level.player UseButtonPressed() || level.player MeleeButtonPressed() )
		{
			flag_set( "player_contextual_start" );
			break;
		}
		wait 0.05;
	}
	
	run_scene( "player_melee_grab_kill" );
	
	level thread player_contextual_button_press();
	
	run_scene( "player_button_wait" );

//	if ( flag( "contextual_melee_success" ) )
//	{
		run_scene( "player_melee_kill" );
//	}
//	else
//	{
//		run_scene( "player_melee_no_kill" );
//	}

	level.player TakeWeapon( "knife_sp" );
	
	level.player.ignoreme = 0;	
	level thread monitor_player_parking_lot_threat();
}

monitor_player_parking_lot_threat()
{
	level endon( "parking_lot_gone_hot" );

	while( 1 )
	{
		level.player waittill_any( "weapon_fired", "grenade_fire" );
		flag_set( "parking_lot_gone_hot" );
		
		wait 0.05;
	}	
}

player_contextual_button_press()
{
	while ( 1 )
	{
		if ( level.player UseButtonPressed() || level.player MeleeButtonPressed() )
		{
			flag_set( "contextual_melee_success" ); //first melee
			break;
		}
		wait 0.05;
	}		
}

mason_contextual_kill()
{
	flag_wait( "player_opened_grate" );
	
	level thread run_scene( "mason_melee_loop" );
	
	flag_wait( "player_contextual_start" );
	
	run_scene( "mason_melee_kill" );
	
	trig_first_blood_cleared = GetEnt( "trig_first_blood_cleared", "targetname" );
	trig_first_blood_cleared notify( "trigger" );		
	
	//check here to see if area is alerted or still stealth

//	if ( flag( "contextual_melee_success" ) )
//	{
		level.mason set_ignoreall( true );
//	}
//	else
//	{
		level.mason set_ignoreall( false );
//	}
}

contextual_kill_check()
{
	return ( flag( "player_contextual_start" ) );
}

first_blood_fail()
{
	first_blood_fail = GetEnt( "first_blood_fail", "targetname" );
	first_blood_fail trigger_off();
	
	flag_wait( "player_at_first_blood" );
	
	first_blood_fail trigger_on();
	first_blood_fail waittill( "trigger" );
	
	SetDvar( "ui_deadquote", &"PANAMA_HANGAR_FAIL" );

	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();		
}

parking_lot_scene()
{
	level thread background_pdf_movement();
	level thread pre_standoff_fail();

	//HIDDEN is self explanatory
	hidden = [];
	hidden[ "prone" ]		= 0;
	hidden[ "crouch" ]		= 0;
	hidden[ "stand" ]		= 0;
	
	//ALERT levels are when the same AI has sighted the same enemy twice OR found a body	
	alert = [];
	alert[ "prone" ]	= 0;
	alert[ "crouch" ]	= 0;
	alert[ "stand" ]	= 0;

	//SPOTTED is when they are completely aware and go into NORMAL COD AI mode...however, the
	//distance they can see you is still limited by these numbers because of the assumption that
	//you're wearing a ghillie suit in woodsy areas
	spotted = [];
	spotted[ "prone" ]	= 0;
	spotted[ "crouch" ]	= 0;
	spotted[ "stand" ]	= 0;	

	stealth_detect_ranges_set( hidden, alert, spotted );		
    level.player stealth_friendly_movespeed_scale_set( hidden, alert, spotted );
	
	vh_parking_lot_gaz = spawn_vehicle_from_targetname( "parking_lot_gaz" );
	vh_unloading_gaz = spawn_vehicle_from_targetname( "unloading_gaz" );
	vh_parking_lot_truck = spawn_vehicle_from_targetname( "parking_lot_truck" );
		
	vh_unloading_gaz.team = "axis";
	vh_parking_lot_gaz.team = "axis";
	vh_parking_lot_truck.team = "axis";
	
	level thread run_scene( "unloading_gaz66_truck_loop" );	
	level thread run_scene( "unloading_box_loop" );

	//patrolelrs
	a_parking_lot_patroller = simple_spawn( "parking_lot_patroller" );
	
	//smokers
	a_parkling_lot_smoker = simple_spawn( "parkling_lot_smoker" );	
	foreach( smoker_guy in a_parkling_lot_smoker )
	{
		n_surprise_anim = "exchange_surprise_" + RandomInt( level.surprise_anims );		
		smoker_guy thread stealth_ai_idle_and_react( smoker_guy, "smoke_idle", n_surprise_anim );	
	}
	
	//bored dudes
	a_parkling_lot_bored = simple_spawn( "parkling_lot_bored" );
	foreach( bored_guy in a_parkling_lot_bored )
	{
		n_surprise_anim = "exchange_surprise_" + RandomInt( level.surprise_anims );		
		bored_guy thread stealth_ai_idle_and_react( bored_guy, "bored_idle", n_surprise_anim );	
	}
		
	ai_pdf_guy_1 = simple_spawn_single( "truck_pdf_1", ::truck_pdf_1 );
	ai_pdf_guy_2 = simple_spawn_single( "truck_pdf_2", ::truck_pdf_2 );	
		
	flag_wait( "first_blood_guys_cleared" );
	
	flag_set( "stop_runway_planes" );
}

truck_pdf_1()
{
	self endon( "death" );
	
	level thread run_scene( "truck_guy_1_loop" );
	
	flag_wait( "parking_lot_gone_hot" );
	
	run_scene( "truck_pdf_1_reaction" );
	
	self set_spawner_targets( "parking_lot_nodes" );
}

truck_pdf_2()
{
	self endon( "death" );

	level thread run_scene( "truck_guy_2_loop" );

	flag_wait( "parking_lot_gone_hot" );

	run_scene( "truck_pdf_2_reaction" );	
}

background_pdf_movement()
{
	flag_wait( "start_street_background" );
	
	vh_background_vehs = spawn_vehicles_from_targetname_and_drive( "vh_background_vehs" );
	
	foreach( vehicle in vh_background_vehs )
	{
		vehicle veh_toggle_tread_fx( false );
	}
}

pre_standoff_fail()
{
	level endon( "player_in_hangar" ); 
	
	trigger_wait( "trig_hangar_warn" );
	level.player thread display_hint( "hangar_warning" );
	
	trigger_wait( "trig_hangar_fail" );
	
	SetDvar( "ui_deadquote", &"PANAMA_HANGAR_FAIL" );

	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();
}

learjet_pdf_backup()
{
	trigger_wait( "trig_learjet_pdf_backup" );
	
	simple_spawn( "learjet_pdf_backup" );
}

monitor_learjet_battle()
{
	self endon( "death" );
	
	self veh_magic_bullet_shield( true );
	
	flag_wait( "learjet_gone_hot" );

	self veh_magic_bullet_shield( false );
	
	self maps\_turret::stop_turret( 1 );

	self maps\_turret::set_turret_burst_parameters( 3.0, 5.0, 1.0, 2.0, 1 ); 
	self maps\_turret::set_turret_target( level.player, ( 0, 0, 0 ), 1 ); 
	self thread maps\_turret::fire_turret_for_time( -1, 1 );	

	wait 5;
	
	//self maps\_turret::disable_turret( 1 );
	self maps\_turret::stop_turret( 1 );	
}

pickup_disable_turret_on_gunner_death()
{
	self waittill( "death" );
	
	n_index = 1;
	
	vh_learjet_truck = GetEnt( "vh_learjet_truck", "targetname" );
	
	if ( IsDefined( vh_learjet_truck ) )
	{
		vh_learjet_truck maps\_turret::disable_turret( n_index );
		vh_learjet_truck maps\_turret::stop_turret( n_index );
	}	
}

learjet_main()
{
	level thread hotel_path_fail();
	
	trig_shoulder_bash = GetEnt( "trig_shoulder_bash", "script_noteworthy" );
	trig_shoulder_bash trigger_off();
	
//	trigger_wait( "trig_spawn_foreshadow_seals_2" );
//	simple_spawn( "foreshadow_seals_group_2", ::init_foreshadow_seals );
	
	trigger_wait( "trig_learjet_pdf_runway" );
	
	spawn_manager_enable( "trig_sm_learjet_seals" );
	spawn_manager_enable( "trig_sm_learjet_pdf" );
	
	//simple_spawn( "learjet_pdf_runway" );
	
	level thread learjet_pdf_backup();
	
	SetThreatBias( "learjet_seals", "learjet_pdf", 5000 );

	SetThreatBias( "hangar_player", "learjet_pdf", 100 );
	SetThreatBias( "hangar_mason", "learjet_pdf", 100 );	
	
	level thread monitor_player_learjet_threat();

	//white truck shooting turret at origin
	e_runway_target = GetEnt( "e_runway_target", "targetname" );
	vh_learjet_truck = spawn_vehicle_from_targetname( "vh_learjet_truck" );
	vh_learjet_truck thread monitor_learjet_battle();
	vh_learjet_truck maps\_turret::set_turret_burst_parameters( 3.0, 5.0, 1.0, 2.0, 1 ); 
	vh_learjet_truck thread maps\_turret::shoot_turret_at_target( e_runway_target, -1, undefined, 1 );    
	//e_turret_or_veh maps\_turret::set_turret_target_types_array( a_target_types, n_index );
	
	vh_learjet_gaz = spawn_vehicle_from_targetname( "vh_learjet_gaz" );
		
	vh_lear_jet = spawn_vehicle_from_targetname( "vh_lear_jet" );
	vh_lear_jet veh_toggle_tread_fx( false );
	//vh_lear_jet thread seals_destroy_learjet();
	vh_lear_jet thread watch_death();
	
	flag_set( "beach_jet_done" );
	level thread air_ambience( "hotel_jet", "hotel_jet_path", "hotel_jet_done", 4.0, 7.0 );

	flag_wait( "learjet_gone_hot" );
	
	spawn_manager_disable( "trig_sm_learjet_pdf" );
		
	level.mason set_ignoreall( false );	
	level.mason set_ignoreme( false );
	
	SetThreatBias( "hangar_player", "learjet_pdf", 5000 );
	SetThreatBias( "hangar_mason", "learjet_pdf", 5000 );

	//SetThreatBias( "learjet_seals", "learjet_pdf", 100 );
	SetIgnoreMeGroup( "learjet_seals", "learjet_pdf" );
	
	simple_spawn( "learjet_pdf" );		
	level thread learjet_pdf_death_count();
	
	flag_set( "skinner_motel_dialogue" );
	
	waittill_ai_group_ai_count( "learjet_pdf", 5 );
	
	//trigger all color chains	
	trig_color_mid_lear = GetEnt( "trig_color_mid_lear", "targetname" );
	if ( IsDefined( trig_color_mid_lear ) )
	{
		trig_color_mid_lear notify( "trigger" );
	}			
	
	wait 0.10;
	
	trig_color_far_lear = GetEnt( "trig_color_far_lear", "targetname" );
	if ( IsDefined( trig_color_far_lear ) )
	{
		trig_color_far_lear notify( "trigger" );
	}	

	wait 0.10;

	waittill_ai_group_cleared( "learjet_pdf" );	
	
	level.mason change_movemode( "sprint" );
	
	trig_color_mason_post_learjet = GetEnt( "trig_color_mason_post_learjet", "targetname" );
	if ( IsDefined( trig_color_mason_post_learjet ) )
	{
		trig_color_mason_post_learjet notify( "trigger" );
	}			
	
	wait 0.10;
	
	spawn_manager_disable( "trig_sm_learjet_seals" );
	
	nd_delete_learjet_seals = GetNode( "nd_delete_learjet_seals", "targetname" );
	
	a_learjet_seals = get_ai_group_ai( "learjet_seals" );
	foreach( seal in a_learjet_seals )
	{
		seal ClearGoalVolume();
		seal thread stack_up_and_delete( nd_delete_learjet_seals );
	}

	IPrintLnBold( "Skinner: Noriega has been spotted entering the motel. Room #23" );
	
	flag_set( "airfield_end" );

	autosave_by_name( "learjet" );
	
	level thread temp_cleanup_func();
	
	trig_shoulder_bash trigger_on();
	flag_wait( "start_shoulder_bash" );
	
	run_scene( "shoulder_bash" );	

	level thread monitor_player_distance();
	
	trigger_use( "trig_color_post_bash" ); //color chain after the bash
	
	m_door_bash_clip = GetEnt( "door_bash_clip", "targetname" );
	m_shoulder_bash_door = GetEnt( "m_shoulder_bash_door", "targetname" );
	
	m_door_bash_clip Delete();
	m_shoulder_bash_door Delete();	
}

temp_cleanup_func()
{
	trigger_wait( "trig_motel_obj" );

	autosave_by_name( "motel" );
	
	//cleanup all ai
	ai = GetAIArray();
	foreach( guy in ai )
	{
		guy Die();
	}	
}

monitor_player_distance()
{
	level endon( "start_intro_anims" ); //when player hits trigger to open motel door
	
	while ( 1 )
	{
		if ( DistanceSquared( level.player.origin, level.mason.origin ) <= 750 )
		{
			SetDvar( "ui_deadquote", &"PANAMA_HANGAR_FAIL" );

			level notify( "mission failed" );
			maps\_utility::missionFailedWrapper();		
		}
		
		wait .2;
	}
}

hotel_path_fail()
{
	trigger_wait( "trig_hotel_warn" );
	level.player thread display_hint( "hangar_warning" );
	
	trigger_wait( "trig_hotel_fail" );
	
	SetDvar( "ui_deadquote", &"PANAMA_HANGAR_FAIL" );

	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();	
}

challenge_destroy_learjet( str_notify )
{
	flag_wait( "player_destroyed_learjet" );
	
	self notify( str_notify );
}

watch_death()
{
	level endon( "motel_scene_end" );
	
	self waittill( "death", e_attacker );
	
	if ( level.player == e_attacker )
	{
		flag_set( "player_destroyed_learjet" );
	}
}

//seals_destroy_learjet()
//{
//	level endon( "learjet_destroyed" );
//	self endon( "death" );
//	
//	flag_wait( "seals_destroy_learjet" );
//	
//	s_seal_rpg_start = getstruct( "s_seal_rpg_start", "targetname" );
//	s_seal_rpg_end = getstruct( s_seal_rpg_start.target, "targetname" );
//	
//	MagicBullet( "rpg_magic_bullet_sp", s_seal_rpg_start.origin, s_seal_rpg_end.origin );
//
//	wait( 1 );
//	
//	PlayFXOnTag( level._effect[ "learjet_explosion" ], self, "tag_origin" );
//	
//	self notify( "death" );
//}

learjet_pdf_death_count()
{
	level endon( "learjet_destroyed" );
	
	waittill_ai_group_ai_count( "learjet_pdf", 2 );
	
	flag_set( "seals_destroy_learjet" );	
}

monitor_player_learjet_threat()
{
	level endon( "learjet_gone_hot" );

	while( 1 )
	{
		level.player waittill_any( "weapon_fired", "grenade_fire" );
		SetThreatBias( "hangar_player", "learjet_pdf", 5000 );
		SetThreatBias( "hangar_mason", "learjet_pdf", 5000 );

		IPrintLn( "player/mason learjet threat level as seals" );
		flag_set( "learjet_gone_hot" );
		
		wait 0.05;
	}	
}

monitor_player_hangar_threat()
{
	level endon( "hangar_gone_hot" );

	while( 1 )
	{
		level.player waittill_any( "weapon_fired", "grenade_fire" );
		
		level.mason set_ignoreall( false );	
	
		SetThreatBias( "hangar_player", "hangar_pdf", 5000 );
		SetThreatBias( "hangar_mason", "hangar_pdf", 5000 );

		IPrintLn( "player/mason threat level as seals" );
		flag_set( "remove_hangar_god_mode" );
		flag_set( "hangar_gone_hot" );
		
		wait 0.05;
	}
}

monitor_skylight_damage()
{
	level endon( "hangar_gone_hot" );
	
	trigger_wait( "trig_damage_skylight" );

	flag_set( "remove_hangar_god_mode" );
}

pdf_death_count_timeout()
{
	wait 25;

	flag_set( "remove_hangar_god_mode" );	
	flag_set( "spawn_pdf_assaulters" );
}

runway_standoff_main()
{
	run_scene_first_frame( "ladder_hatch" );
	
	level thread hangar_pdf_seals();
	
	level thread runway_seals();
	level thread runway_hangar_mason(); //masons movement until learjet battle

	flag_wait( "player_at_standoff" );

	autosave_by_name( "standoff_save" );

	level.player thread monitor_player_runway_fire();
	level thread runway_standoff_timeout();
	
	level.mason.ignoreall = true;
	level.mason.ignoreme = true;
	
	level.player.ignoreme = true;

	flag_wait( "player_at_hatch" ); //set by trigger
	
	//cleanup in parking lot
	end_scene( "unloading_gaz66_truck_loop" );	
	
	level thread run_scene( "ladder_hatch" );
	run_scene( "player_opens_hatch" );

	level thread hatch_fail();
	
	//give player unlimited ammo
//	SetDvar( "UnlimitedAmmoOff", "0" );
		
	hide_player_hud();
		
	level.player SetStance( "stand" );
	level.player AllowCrouch( false );
	level.player AllowJump( false );
	level.player AllowProne( false );
	level.player AllowSprint( false );

	e_player_hatch_spot = Spawn( "script_origin", level.player.origin );
	e_player_hatch_spot.angles = level.player getplayerangles();
	e_player_hatch_spot SetModel( "tag_origin" );
	level.player PlayerLinkToDelta( e_player_hatch_spot, "tag_origin", 1, 40, 40, 40, 40, false );

	waittill_ai_group_cleared( "top_ladder_pdf" );
	
	wait( 1 );
	
	flag_set( "rooftop_guy_killed" );
		
	level.player Unlink();
	
	level.player AllowCrouch( true );
	level.player AllowJump( true );
	level.player AllowProne( true );
	level.player AllowSprint( true );

	//turn off unlimited ammo
//	SetDvar( "UnlimitedAmmoOff", "1" );

	show_player_hud();
	
	run_scene( "player_exits_hatch" );
	
	flag_set( "rooftop_goes_hot" );
		
	level.mason.ignoreall = false;
	level.mason.ignoreme = false;
	
	level.player.ignoreme = false;	
	
	autosave_by_name( "hangar_rooftop" );	
	
	//m203
	s_m203_start_1 = getstruct( "m203_start_1", "targetname" );
	s_m203_end_1 = getstruct( s_m203_start_1.target, "targetname" );
	
	s_m203_start_2 = getstruct( "m203_start_2", "targetname" );
	s_m203_end_2 = getstruct( s_m203_start_2.target, "targetname" );	
	
	MagicBullet( "gl_ak47_sp", s_m203_start_1.origin, s_m203_end_1.origin );	
	
	wait( 2 );
	
	MagicBullet( "gl_ak47_sp", s_m203_start_2.origin, s_m203_end_2.origin );	

	level thread monitor_skylight_damage();	
	
	flag_wait( "player_in_hangar" ); //trigger sets this flag
	flag_set( "remove_hangar_god_mode" );

	autosave_by_name( "hangar" );
		
	level thread hangar_intruder_specialty();
	
	level thread monitor_player_hangar_threat();
	level thread pdf_death_count_timeout(); 			
}

hide_player_hud()
{
	SetSavedDvar( "hud_showStance", "0" );
	SetSavedDvar( "compass", "0" );
	SetDvar( "old_compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "cg_drawCrosshair", 0 );
}

show_player_hud()
{
	SetSavedDvar( "hud_showStance", "1" );
	SetSavedDvar( "compass", "1" );
	SetDvar( "old_compass", "1" );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "cg_drawCrosshair", 1 );
}

hatch_fail()
{
	level endon( "rooftop_guy_killed" );

	wait 5;

	flag_set( "start_pdf_ladder_reaction" );
	
	wait 5;
		
	level.player Suicide();
}

setup_runway_cessnas()
{
	self endon( "death" );
	
	self veh_toggle_tread_fx( false );
	
	flag_wait( "runway_standoff_goes_hot" );
	
	wait( RandomFloatRange( 1, 5 ) );
	
	self notify( "death" );
}

runway_seals()
{
	flag_wait( "setup_runway_standoff" );
	
	IPrintLnBold( "Skinner: The SEALs are walking into an ambush" );
	IPrintLnBold( "Mason: Let's move. Hurry!" );
	
	a_runway_cessnas = spawn_vehicles_from_targetname( "runway_cessnas" );
	
	runway_hangar_cessna = spawn_vehicle_from_targetname( "runway_hangar_cessna" );
	runway_hangar_cessna veh_toggle_tread_fx( false );
	
	foreach( cessna in a_runway_cessnas )
	{
		cessna thread setup_runway_cessnas();
	}
	
	ai_seal_standoff_1 = simple_spawn_single( "seal_standoff_1", ::init_standoff_seal );
	ai_seal_standoff_1.animname = "seal_1";
		
	ai_seal_standoff_2 = simple_spawn_single( "seal_standoff_2", ::init_standoff_seal );
	ai_seal_standoff_2.animname = "seal_2";
	
	ai_seal_standoff_3 = simple_spawn_single( "seal_standoff_3", ::init_standoff_seal );
	ai_seal_standoff_3.animname = "seal_3";
	
	ai_seal_standoff_4 = simple_spawn_single( "seal_standoff_4", ::init_standoff_seal );
	ai_seal_standoff_4.animname = "seal_4";
	
	ai_seal_standoff_5 = simple_spawn_single( "seal_standoff_5", ::init_standoff_seal );
	ai_seal_standoff_5.animname = "seal_5";
	
	ai_seal_standoff_6 = simple_spawn_single( "seal_standoff_6", ::init_standoff_seal );
	ai_seal_standoff_6.animname = "seal_6";
	
	ai_seal_standoff_7 = simple_spawn_single( "seal_standoff_7", ::init_standoff_seal );
	ai_seal_standoff_7.animname = "seal_7";
	
	ai_seal_standoff_8 = simple_spawn_single( "seal_standoff_8", ::init_standoff_seal );
	ai_seal_standoff_8.animname = "seal_8";
	
	level thread run_scene( "seal_standoff_loop" );
	
	flag_wait( "runway_standoff_goes_hot" );
	
	level thread ladder_hatch_pdf();
	level thread runway_standoff_fail_timeout();

	simple_spawn( "rooftop_pdf" );	
		
	level thread rescue_1();
	level thread rescue_2();
	level thread rescue_3( ai_seal_standoff_5 );
	
	standoff_seals = get_ai_group_ai( "standoff_seals" );	
	foreach( seal in standoff_seals )
	{
		seal thread kill_off_standoff_seals();
	}
}

ladder_hatch_pdf()
{
	ai_top_ladder_pdf = simple_spawn_single( "top_ladder_pdf", ::init_top_ladder_pdf );
	
	level thread run_scene( "pdf_ladder_loop" );
	
	flag_wait( "start_pdf_ladder_reaction" );
	
	run_scene( "pdf_ladder_reaction" );		
}

runway_standoff_fail_timeout()
{
	level endon( "player_at_hatch" );
	
	wait 35;
	
	SetDvar( "ui_deadquote", &"PANAMA_ROOFTOP_FAIL" );

	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();		
}

kill_off_standoff_seals()
{
	self endon( "death" );
	 
	self set_spawner_targets( "seal_runway_nodes" );		
	
	wait RandomFloatRange( 4.0, 8.0 );	

	self Die();
}

init_standoff_seal()
{
	self endon( "death" );
	
	flag_wait( "runway_standoff_goes_hot" );
	
	self stopanimscripted();
	
	self magic_bullet_shield();
	
	if ( cointoss() )
    {
		self.ignoreme = true;
    }
	
	wait( 5 );
	
	self.ignoreme = false;
	self stop_magic_bullet_shield();
}

init_top_ladder_pdf()
{
	self endon( "death" );
	
	self.perfectAim = true;	
	self.ignoreme = true;
	self.goalradius = 16;	
}

rescue_1()
{
	run_scene( "seal_rescue_1" );
	run_scene( "seal_rescue_1_dies" );
}

rescue_2()
{
	run_scene( "seal_rescue_2" );
	run_scene( "seal_rescue_2_dies" );
}

rescue_3( ai_seal_standoff_5 )
{
	ai_seal_rescue_guy_3 = simple_spawn_single( "seal_rescue_guy_3" );
	ai_seal_rescue_guy_3.animname = "seal_rescue_guy_3";
	
	run_scene( "seal_rescue_3" );
	
	ai_seal_standoff_5 thread kill_off_standoff_seals();
	ai_seal_rescue_guy_3 thread kill_off_standoff_seals();
}
runway_hangar_mason()
{
	flag_wait( "player_at_standoff" );

	run_scene( "mason_standoff_fence_kick" );
	
	run_scene( "mason_standoff_arrival" );
	
	level thread run_scene( "mason_standoff_loop" );

	//waittill_ai_group_cleared( "top_ladder_pdf" );
	flag_wait( "rooftop_guy_killed" );
	
	run_scene( "mason_standoff_exit" );
	
	level.mason change_movemode( "run" );
	
	nd_mason_roof = GetNode( "nd_mason_roof", "targetname" );
	level.mason SetGoalNode( nd_mason_roof );
	
	waittill_ai_group_cleared( "rooftop_pdf" );
	
	run_scene( "mason_skylight_approach" );
	level thread run_scene( "mason_skylight_loop" );
	
	level thread rooftop_fail_timeout();
	
	flag_wait( "player_near_skylight" );
	
	delay_thread( 2.75, ::open_skylight );
	
	run_scene( "mason_skylight_jump_in" ); 	
	
	level.mason.goalradius = 32;	
	nd_mason_catwalk = GetNode( "nd_mason_catwalk", "targetname" );
	level.mason SetGoalNode( nd_mason_catwalk );
	
	flag_wait( "player_in_hangar" ); //trigger sets this flag
	
	nd_mason_hangar = GetNode( "nd_mason_hangar", "targetname");
	level.mason SetGoalNode( nd_mason_hangar );
	
	flag_wait( "spawn_pdf_assaulters" );
	
	iprintln( "Mason: shit, we have company. across the hangar!!" );
	
	run_scene( "mason_hangar_door_kick" );
	
	nd_mason_post_hangar_door = GetNode( "nd_mason_post_hangar_door", "targetname" );
	level.mason SetGoalNode( nd_mason_post_hangar_door );
	
//	simple_spawn( "foreshadow_seals_group_1", ::init_foreshadow_seals );

	waittill_ai_group_cleared( "pdf_hangar_assaulters" );
	
	trig_color_leer_jet = GetEnt( "trig_color_leer_jet", "targetname" );
	trig_color_leer_jet notify( "trigger" );		
	
	level.mason set_ignoreall( true );	
}

init_foreshadow_seals()
{
	self endon( "death" );
	
	self magic_bullet_shield();
	self set_ignoreall( true );
	
	nd_delete = GetNode( self.target, "targetname" );
	self force_goal( nd_delete, 32 );
	self waittill( "goal" );
	self Delete();
}

rooftop_fail_timeout()
{
	level endon( "player_near_skylight" );
	level endon( "player_in_hangar" );
	
	wait 25;
	
	SetDvar( "ui_deadquote", &"PANAMA_ROOFTOP_FAIL" );

	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();	
}

open_skylight()
{
	m_skylight_door = GetEnt( "m_skylight_door", "targetname" );
	m_skylight_door RotatePitch( 40, 1 );
}	

open_ladder_door( guy )
{
	m_ladder_door = GetEnt( "m_ladder_door", "targetname" );
	m_ladder_door RotateYaw( -130, 0.2, 0.1, 0 ); 
	
	PlayFx( getfx( "door_breach" ), m_ladder_door.origin );
	
	m_ladder_door_clip = GetEnt( "ladder_door_clip", "targetname" );
	m_ladder_door_clip Delete();
	
	level thread ladder_obj_breadcrumb();
}

extra_muzzle_flash( guy )
{
	PlayFXOnTag( getfx( "maginified_muzzle_flash" ), guy, "tag_flash" );
}

ladder_obj_breadcrumb()
{
	wait 0.10;
	
	//turn off mason's follow until roof is cleared
	set_objective( level.OBJ_CAPTURE_NORIEGA , level.mason, "remove" );
		
	wait 0.10;
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, getstruct( "ladder_breadcrumb_1" ), "breadcrumb" );
		
	flag_wait( "ladder_breadcrumb_1" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "remove" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, getstruct( "ladder_breadcrumb_2" ), "breadcrumb" );

	flag_wait( "ladder_breadcrumb_2" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "remove" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, getstruct( "ladder_breadcrumb_3" ), "breadcrumb" );
	
	flag_wait( "player_at_hatch" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "remove" );

	waittill_ai_group_cleared( "rooftop_pdf" );
	
	//turn on mason's follow 	
	set_objective( level.OBJ_CAPTURE_NORIEGA , level.mason, "follow" );	
}

monitor_player_runway_fire()
{
	level endon( "runway_standoff_goes_hot" );
	self endon( "death" );
	
	flag_wait( "player_at_standoff" );
	
	while( 1 )
	{
		self waittill_any( "weapon_fired", "grenade_fire" );
		flag_set( "runway_standoff_goes_hot" );
		IPrintLn( "runway gone hot!" );
		
		wait 0.05;
	}
}

runway_standoff_timeout()
{
	level endon( "runway_standoff_goes_hot" );
	
	flag_wait( "player_at_standoff" );
	
	wait 15;
	
	iprintln( "standoff timeout hit" );

	flag_set( "runway_standoff_goes_hot" );
}

set_flag_when_cleared( ai_group, str_flag )
{
	waittill_ai_group_cleared( ai_group );
	flag_set( str_flag );
}

init_first_blood_guys()
{
	self endon( "death" );
	
	self.ignoreme = true;
	self set_ignoreall( true );
	
	flag_wait( "parking_lot_gone_hot" );
	
	self set_ignoreall( false );
	self.ignoreme = false;
	self.goalradius = 256;
}

hangar_pdf_seals()
{
	flag_wait( "runway_standoff_goes_hot" );
	
//	cessna_fire_structs = getstructarray( "cessna_fire_structs", "targetname" );
//	array_thread( cessna_fire_structs, ::play_cessna_fires );
	
	spawn_manager_enable( "trig_sm_hangar_pdf" );
	spawn_manager_enable( "trig_sm_runway_seals" );	
	
	level.player SetThreatBiasGroup( "hangar_player" );	
	level.mason SetThreatBiasGroup( "hangar_mason" );
	
	SetThreatBias( "hangar_seals", "hangar_pdf", 5000 );

	SetThreatBias( "hangar_player", "hangar_pdf", 100 );
	SetThreatBias( "hangar_mason", "hangar_pdf", 100 );
	
	flag_wait( "spawn_pdf_assaulters" );

	spawn_manager_disable( "trig_sm_hangar_pdf" );
	spawn_manager_disable( "trig_sm_runway_seals" );
	
	simple_spawn( "pdf_hangar_assaulters" );
	
	SetIgnoreMeGroup( "hangar_seals", "pdf_assaulters" );
	SetIgnoreMeGroup( "hangar_mason", "hangar_pdf" );
	
	SetThreatBias( "hangar_player", "pdf_assaulters", 5000 );
	SetThreatBias( "hangar_mason", "pdf_assaulters", 5000 );
		
	seal_group_1 = simple_spawn( "seal_group_1" );
	seal_group_2 = simple_spawn( "seal_group_2" );
	
	level thread run_scene( "seal_group_1_hangar_entry" );
	run_scene( "seal_group_2_hangar_entry" );

	nd_delete_seals = GetNode( "nd_delete_seals", "targetname" );
	a_hangar_seals = get_ai_group_ai( "hangar_seals" );
	
	for( i = 0; i < a_hangar_seals.size; i++ )
	{
		if ( i < 2 )
		{
			a_hangar_seals[i].script_noteworthy = "cessna_seal_" + i;
		}	
				
		a_hangar_seals[i] thread seals_storm_hangar( nd_delete_seals );
	}

	a_hangar_pdf = get_ai_group_ai( "hangar_pdf" );
	foreach( pdf in a_hangar_pdf )
	{
		pdf thread pdf_hangar_fallback();
	}
	
	while ( 1 )
	{
		a_hangar_pdf = get_ai_group_ai( "hangar_pdf" );
		
		if ( a_hangar_pdf.size == 0 )
		{
			break;
		}
		
		wait 0.1;
	}

	flag_set( "hangar_pdf_cleared" );

	a_seal_group_1 = get_ai_group_ai( "seal_group_1" );
	a_seal_group_2 = get_ai_group_ai( "seal_group_2" );
	
	nd_delete_seal_group_1 = GetNode( "nd_delete_seal_group_1", "targetname" );
	nd_delete_seal_group_2 = GetNode( "nd_delete_seal_group_2", "targetname" );
	
	foreach( seal in a_seal_group_1 )
	{
		seal thread stack_up_and_delete( nd_delete_seal_group_1 );
	}
	
	foreach( seal in a_seal_group_2 )
	{
		seal thread stack_up_and_delete( nd_delete_seal_group_2 );
	}	
}

play_cessna_fires()
{
	PlayFX( getfx( "cessna_fire" ), self.origin );
}

seals_storm_hangar( nd_delete_seals )
{
	self endon( "death" );
	
	self magic_bullet_shield();
	self.perfectaim = 1;
	self change_movemode( "cqb" );

	self ClearGoalVolume();
	volume_hangar_front = GetEnt( "hangar_front", "targetname" );
	self SetGoalVolumeAuto( volume_hangar_front );	
	
	flag_wait( "hangar_pdf_cleared" );
	
	self set_ignoreall( true );
	self.ignoreme = true;
	self ClearGoalVolume();	
	
	e_cessna_target = GetEnt( "cessna_target", "targetname" );	
	
	if ( IsDefined( self.script_noteworthy ) )
	{
		self.fixednode = false;	
		self.goalradius = 32;
		
		if ( self.script_noteworthy == "cessna_seal_0" )
		{
			nd_first_node = GetNode( "nd_1_cessna_seal_1", "targetname" );
			nd_second_node = GetNode( "nd_2_cessna_seal_1", "targetname" );
					
			self SetGoalNode( nd_first_node );
			self waittill( "goal" );	

			flag_set( "seal_1_in_pos" );
		}
		else if ( self.script_noteworthy == "cessna_seal_1" )
		{
			nd_first_node = GetNode( "nd_1_cessna_seal_2", "targetname" );
			nd_second_node = GetNode( "nd_2_cessna_seal_2", "targetname" );	
			
			self SetGoalNode( nd_first_node );
			self waittill( "goal" );			
			
			flag_set( "seal_2_in_pos" );
		}

		flag_wait_all( "seal_1_in_pos", "seal_2_in_pos" );
	
		self thread shoot_at_target( e_cessna_target, undefined, undefined, -1 );
		
		wait 3;
		
		self SetGoalNode( nd_second_node );
		self waittill( "goal" );	
	
		wait 5;
			
		self stop_shoot_at_target();
		self ClearEntityTarget();
		self thread stack_up_and_delete( nd_delete_seals );	
	}
	else
	{
		self thread stack_up_and_delete( nd_delete_seals );	
	}
}

pdf_hangar_fallback()
{
	self endon( "death" );

	wait RandomFloatRange( 0.25, 1.0 );		
	
	self ClearGoalVolume();
	
	volume_hangar_back = GetEnt( "hangar_back", "targetname" );		
	self SetGoalVolumeAuto( volume_hangar_back );	
}

stack_up_and_delete( nd_delete )
{
	self endon( "death" );

	self.goalradius = 32;
	self set_ignoreall( true );
	
	self SetGoalPos( nd_delete.origin );
	self waittill( "goal" );
	self Delete();
}

hangar_intruder_specialty()
{
	if( !level.player HasPerk( "specialty_intruder" ) )
	{
		trig_control_room_specialty = GetEnt( "trig_control_room_specialty", "targetname" );
		trig_control_room_specialty Delete();	
		
		return;
	}
	
	s_intruder_obj = getstruct( "s_intruder_obj", "targetname" );
	set_objective( level.OBJ_INTERACT, s_intruder_obj.origin, "interact" );

	trig_control_room_specialty = GetEnt( "trig_control_room_specialty", "targetname" );
	trig_control_room_specialty SetHintString( &"PANAMA_BREAK_LOCK" );
	trig_control_room_specialty SetCursorHint( "HINT_NOICON" );
	trig_control_room_specialty waittill( "trigger" );
	trig_control_room_specialty Delete();

	set_objective( level.OBJ_INTERACT, undefined, "done" );	
	set_objective( level.OBJ_INTERACT, undefined, "delete" );

	run_scene( "player_intruder" );
	
	control_room_door = GetEnt( "control_room_door", "targetname" );
	control_room_door RotateYaw( -120, 0.5, 0.3, 0 ); 	
	
	trig_use_door_lever = GetEnt( "trig_use_door_lever", "targetname" );
	trig_use_door_lever SetHintString( &"PANAMA_CLOSE_HANGAR_DOORS" );
	trig_use_door_lever SetCursorHint( "HINT_NOICON" );	
	trig_use_door_lever waittill( "trigger" );
	trig_use_door_lever Delete();

	level thread pdf_door_reaction();
		
	//run_scene( "player_uses_lever" );
	flag_set( "hangar_doors_closing" );
	
	//SOUND - Shawn J
	level.player playsound ("blk_hangar_doors");

	m_hangar_door_left = GetEnt( "hangar_door_left", "targetname" );
	m_hangar_door_right = GetEnt( "hangar_door_right", "targetname" );
		
	m_hangar_door_left thread close_left_door();	
	m_hangar_door_right thread close_right_door();
}

close_left_door()
{
	self MoveY( 135, 25, 1, .5 );
	self DisconnectPaths();
}

close_right_door()
{
	self MoveY( -135, 25, 1, .5 );
	self DisconnectPaths();	
}

pdf_door_reaction()
{
	if ( flag( "hangar_gone_hot" ) )
	{
		return;
	}
	
	flag_wait( "hangar_doors_closing" );
	
	ai_hangar_pdf = get_ai_group_ai( "hangar_pdf" );
	ai_hangar_pdf = array_randomize( ai_hangar_pdf );
		
	n_pdf_reactions = 0;	
		
	for ( i = 0; i < ai_hangar_pdf.size; i++ )
	{
		if ( !IsAlive( ai_hangar_pdf[i] ) )
		{
			continue;
		}
		
		ai_hangar_pdf[i].animname = "pdf_" + n_pdf_reactions;
		level thread run_scene( "pdf_door_reaction_" + n_pdf_reactions );
		n_pdf_reactions++;
		
		if ( n_pdf_reactions == 2 )
		{
			break;
		}
	}
}