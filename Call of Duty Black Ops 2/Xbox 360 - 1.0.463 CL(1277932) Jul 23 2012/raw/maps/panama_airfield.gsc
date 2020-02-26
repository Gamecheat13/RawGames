#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\panama_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_stealth_logic;
#include maps\_music;
#include maps\_turret;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

#define CLIENT_FLAG_PLAYER_ZODIAC	7

skipto_zodiac()
{
	level.mason = init_hero( "mason" );

	a_hero[0] = level.mason;
	skipto_teleport( "skipto_beach_player", a_hero );
	
	flag_set( "movie_done" );

	airfield_spawnfuncs();
	
	maps\createart\panama_art::airfield();
	
//	flag_wait( "panama_gump_2" );
}

skipto_beach()
{
	level.mason = init_hero( "mason" );

	a_hero[0] = level.mason;
	skipto_teleport( "skipto_beach_player", a_hero );
	
	level.mason set_ignoreall( true );
	level.mason set_ignoreme( true );
	
	nd_mason_beach = GetNode( "nd_mason_beach", "targetname" );
	level.mason SetGoalNode( nd_mason_beach );	
	
	level.player SetLowReady( true );
	level.player.ignoreme = 1;
	
	flag_set( "movie_done" );
	
	airfield_spawnfuncs();
	
	maps\createart\panama_art::airfield();
	
//	flag_wait( "panama_gump_2" );	
}

skipto_runway()
{
	level.mason = init_hero( "mason" );

	a_hero[0] = level.mason;
	skipto_teleport( "skipto_runway_player", a_hero );

	airfield_spawnfuncs();
	
	maps\createart\panama_art::airfield();	
	
//	flag_wait( "panama_gump_2" );	
}

skipto_learjet()
{
	level.mason = init_hero( "mason" );

	a_hero[0] = level.mason;
	skipto_teleport( "skipto_learjet_player", a_hero );	

	airfield_spawnfuncs();

	maps\createart\panama_art::airfield();
	
//	flag_wait( "panama_gump_2" );
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
	flag_init( "rooftop_spawned" );
	flag_init( "runway_standoff_goes_hot" );
	flag_init( "airfield_end" );
	flag_init( "hangar_doors_closing" );
	flag_init( "spawn_pdf_assaulters" );
//	flag_init( "parking_lot_gone_hot" );	
	flag_init( "parking_lot_guys_cleared" );	
	flag_init( "hangar_gone_hot" );	
	flag_init( "stop_intro_planes" );		
	flag_init( "stop_runway_planes" );		
	flag_init( "remove_hangar_god_mode" );		
	flag_init( "player_in_hangar" );
//	flag_init( "beach_jet_done" );
	flag_init( "stop_parking_lot_jets" );
	flag_init( "motel_jet_done" );	
	flag_init( "hangar_pdf_cleared" );	
	flag_init( "rooftop_guy_killed" );	
	flag_init( "seal_1_in_pos" );	
	flag_init( "seal_2_in_pos" );	
	flag_init( "start_pdf_ladder_reaction" );
	flag_init( "player_contextual_start" );	
	flag_init( "player_contextual_end" );	
	flag_init( "player_destroyed_learjet" );
	flag_init( "learjet_destroyed" );
	flag_init( "player_opened_grate" );
	flag_init( "player_second_melee" );
//	flag_init( "player_climb_up_done" );
	flag_init( "contextual_melee_success" );
	flag_init( "skinner_motel_dialogue" );
	flag_init( "button_wait_done" );
	flag_init( "contextual_melee_done" );
	flag_init( "setup_runway_standoff" );
	flag_init( "player_on_roof" );
	flag_init( "turret_guy_died" );
	flag_init( "spawn_learjet_wave_2" );
	flag_init( "mason_at_drain" );
	flag_init( "spawn_parking_lot_backup" ); //trigger flag
	flag_init( "parking_lot_laststand" );
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
	
	//parking lot pdf
	a_pdf_stealth = GetEntArray( "pdf_stealth", "script_noteworthy" );
	array_thread( a_pdf_stealth, ::add_spawn_function, maps\_stealth_logic::stealth_ai );	

	//hangar
	a_pdf_hangar_assaulters = GetEntArray( "pdf_hangar_assaulters", "targetname" );
	array_thread( a_pdf_hangar_assaulters, ::add_spawn_function, ::init_hangar_assaulters );
		
	a_rooftop_pdf = GetEntArray( "rooftop_pdf", "targetname" );
	array_thread( a_rooftop_pdf, ::add_spawn_function, ::init_rooftop_pdf );
	
//	hangar_pdf = GetEntArray( "hangar_pdf", "targetname" );
//	array_thread( hangar_pdf, ::add_spawn_function, ::init_hangar_pdf );
	
	hangar_frontline = GetEntArray( "hangar_frontline", "targetname" );
	array_thread( hangar_frontline, ::add_spawn_function, ::init_hangar_pdf );
	
	hangar_seals = GetEntArray( "hangar_seals", "targetname" );	
	array_thread( hangar_seals, ::add_spawn_function, ::init_hangar_seals );	
	
	pdf_hangar_assaulters = GetEntArray( "pdf_hangar_assaulters", "targetname" );
	array_thread( pdf_hangar_assaulters, ::add_spawn_function, ::init_pdf_hangar_assaulters );	
	
	a_pdf_runner = GetEntArray( "pdf_runner", "script_noteworthy" );
	array_thread( a_pdf_runner, ::add_spawn_function, ::init_pdf_runner );
	
	a_learjet_intro_pdf = GetEntArray( "learjet_intro_pdf", "targetname" );
	array_thread( a_learjet_intro_pdf, ::add_spawn_function, ::learjet_turret_challenge_count );
	
	a_learjet_truck_pdf = GetEntArray( "learjet_truck_pdf", "targetname" );
	array_thread( a_learjet_truck_pdf, ::add_spawn_function, ::learjet_turret_challenge_count );
	
	a_learjet_wave_1 = GetEntArray( "learjet_wave_1", "targetname" );
	array_thread( a_learjet_wave_1, ::add_spawn_function, ::learjet_turret_challenge_count );
	
	a_learjet_wave_1_rpg = GetEntArray( "learjet_wave_1_rpg", "targetname" );
	array_thread( a_learjet_wave_1_rpg, ::add_spawn_function, ::learjet_turret_challenge_count );
	
	a_learjet_wave_2 = GetEntArray( "learjet_wave_2", "targetname" );
	array_thread( a_learjet_wave_2, ::add_spawn_function, ::learjet_turret_challenge_count );
	
	a_learjet_wave_3 = GetEntArray( "learjet_wave_3", "targetname" );
	array_thread( a_learjet_wave_3, ::add_spawn_function, ::learjet_turret_challenge_count );
	
	a_learjet_back_left = GetEntArray( "learjet_back_left", "targetname" );
	array_thread( a_learjet_back_left, ::add_spawn_function, ::learjet_turret_challenge_count );
	
	a_learjet_back_door_kick_pdf = GetEntArray( "learjet_back_door_kick_pdf", "targetname" );
	array_thread( a_learjet_back_door_kick_pdf, ::add_spawn_function, ::learjet_turret_challenge_count );
	
	a_learjet_back_right = GetEntArray( "learjet_back_right", "targetname" );
	array_thread( a_learjet_back_right, ::add_spawn_function, ::learjet_turret_challenge_count );
	
	a_tarp_pdf = GetEntArray( "tarp_pdf", "targetname" );
	array_thread( a_tarp_pdf, ::add_spawn_function, ::learjet_turret_challenge_count );

	a_rolling_door_guys = GetEntArray( "rolling_door_guys", "script_noteworthy" );
	array_thread( a_rolling_door_guys, ::add_spawn_function, ::learjet_turret_challenge_count );
}

learjet_turret_challenge_count()
{
	self waittill( "death", e_attacker, str_mod, str_weapon );
	
	if ( IsDefined( e_attacker ) && IsDefined( str_weapon ) )
	{
		if ( str_weapon == "civ_pickup_turret" && e_attacker == level.player )
		{
			level notify( "killed_by_turret" );
		}
	}
}

init_pdf_runner()
{
	self endon( "death" );	
	
	nd_goal = GetNode( self.target, "targetname" );
	self force_goal( nd_goal, 16 );	
}

init_force_goal_guy()
{
	self endon( "death" );	
	
	nd_goal = GetNode( self.target, "targetname" );
	self force_goal( nd_goal, 16 );	
}

init_hangar_assaulters()
{
	self endon( "death" );
	
	self.aggressiveMode= true;
	
	nd_goal = GetNode( self.target, "targetname" );
	self force_goal( nd_goal, 64 );
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
	
//	switch( self.script_noteworthy )
//	{
//		case "rooftop_pdf_engager":
//			nd_rooftop_pdf_engager = GetNode( "nd_rooftop_pdf_engager", "targetname" );
//			self force_goal( nd_rooftop_pdf_engager, 16 );
//			break;		
//		case "slide_guy1":
//			self.animname = "slide_guy_1";
//			run_scene( "rooftop_slide_1" );
//			
//			nd_slide_guy1 = GetNode( "nd_slide_guy1", "targetname" );			
//			self force_goal( nd_slide_guy1, 16 );	
//			break;
//		case "slide_guy2":
//			self.animname = "slide_guy_2";
//			run_scene( "rooftop_slide_2" );
//			
//			nd_slide_guy2 = GetNode( "nd_slide_guy2", "targetname" );
//			self force_goal( nd_slide_guy2, 16 );		
//			break;
//		case "rooftop_guys":
//			wait ( RandomIntRange( 1, 6 ) );
//			self set_spawner_targets( "rooftop_nodes" );		
//			break;
//	}
}

zodiac_approach_main()
{
//	flag_wait( "panama_gump_2" );
	
	//wait for old man movie 1
//	flag_wait( "movie_done" );
	
	a_intro_zodiacs = GetEntArray( "intro_zodiacs", "script_noteworthy" );
	
	foreach( zodiac in a_intro_zodiacs )
	{
		PlayFxOnTag( getfx( "zodiac_churn" ), zodiac, "TAG_PROPELLER_FX" );
	}
	
	level.mason = init_hero( "mason" );
	level.mason set_ignoreall( true );
	level.mason set_ignoreme( true );
	level thread maps\createart\panama_art::beach();
	//FOG
	maps\createart\panama_art::airfield();	
	
	airfield_spawnfuncs();
	
	//Set music to Zodiak
	setmusicstate ("PANAMA_ZODIAK");
	//Set music to BeachStealth 21 seconds into the animation
	level thread maps\_audio::switch_music_wait("PANAMA_BEACH", 22);
	

	
	//level.player playsound ( "evt_zodiac" );
	
	level thread run_scene( "zodiac_approach_boat" );
	level thread run_scene( "zodiac_approach_seals" );
	level thread run_scene( "zodiac_approach_seals2" );
	level thread zodiac_seal_squad();
	level thread zodiac_mason();
	level thread invasion_read();
		
//	level thread beach_fail_condition();
	
	delay_thread( 2, ::zodiac_jet_flyover );
	
	level.player playloopsound( "evt_boat_loop", 1 );
	level.player delay_thread( 20, ::end_boat_sounds );
	level.player thread set_zodiac_overlay();
	//level.player thread set_zodiac_exit_ads();
	
	level thread spawn_zodiac_littlebird();
	level thread zodiac_shake_and_rumble();
	
	flag_set( "zodiac_approach_start" );
	
	level thread screen_fade_in( 8 );
	
	level thread turn_off_hotel_lights();
	level thread can_see_buildings_on_zodiac();
	level thread phantom_truck_killer();
	level thread vo_zodiac_approach();
	level thread vo_zodiac_get_ready();
	
//	autosave_by_name( "zodiac" ); // TODO: figure out why the splashing fx from the zodiac doesn't play on restart on checkpoint
	
	run_scene( "zodiac_approach_player" );
	
	level thread run_scene( "zodiac_dismount_player" );
	
	level.player PlayRumbleOnEntity( "artillery_rumble" );
		
	Earthquake( 0.5, RandomFloatRange( 1.0, 2.0 ), level.player.origin, 100 );
	
	player_body = get_model_or_models_from_scene( "zodiac_dismount_player", "player_body" );
	
	PlayFxOnTag( getfx( "player_bubbles" ), player_body, "tag_camera" );
	
	scene_wait( "zodiac_dismount_player" );
	
	delete_zodiac_scenes();
	
	flag_set( "can_turn_off_lights" );
	
	level.player.ignoreme = 1;
	
	flag_set( "zodiac_approach_end" );
	
	autosave_by_name( "beach" );
	
	level clientnotify( "aS_on" );
}


vo_zodiac_get_ready()
{
	anim_length = GetAnimLength( %player::p_pan_02_01_beach_approach_player );
	
	wait( anim_length - 12.5 );
	
	level.mason thread say_dialog( "reds_10_seconds_out_0", 0 );  //10 seconds out!
	
	wait 5;
	
	level.mason thread say_dialog( "reds_5_seconds_0", 0 );  //5 seconds.
	
	wait 5;
	
	level.mason say_dialog( "reds_go_go_0", 0 );  //Go. Go.
}


vo_zodiac_approach()
{
	level.mason say_dialog( "maso_hudson_it_s_mason_0",  0 );  //Hudson.  It's Mason. The bombing's begun ahead of schedule!  Something you want to tell us?
	level.mason say_dialog( "hudson__do_you_co_003", 1 );  //Hudson.  Do you copy? No response. We continue as planned.
}


zodiac_shake_and_rumble()
{
	level endon( "zodiac_dismount_player_started" );
	
	while( 1 )
	{
		level.player PlayRumbleOnEntity( "grenade_rumble" );
		
		Earthquake( 0.5, RandomFloatRange( 1.0, 2.0 ), level.player.origin, 100 );
		
		wait RandomFloatRange( 1.0, 1.5 );
	}
}


spawn_zodiac_littlebird()
{
	s_spawnpt = getstruct( "littlebird_zodiac_spawnpt", "targetname" );
	
	vh_littlebird1 = spawn_vehicle_from_targetname( "us_littlebird" );
	vh_littlebird1.origin = s_spawnpt.origin;
	vh_littlebird1.angles = s_spawnpt.angles;
	vh_littlebird1 thread zodiac_littlebird_logic( ( 0, 0, 0 ) );
	vh_littlebird1 thread littlebird_fire( 5.5, 5.0 );
	
	wait 0.5;
	
	vh_littlebird2 = spawn_vehicle_from_targetname( "us_littlebird" );
	vh_littlebird2.origin = s_spawnpt.origin;
	vh_littlebird2.angles = s_spawnpt.angles;
	vh_littlebird2 thread zodiac_littlebird_logic( ( -700, 0, 100 ) );
	vh_littlebird2 thread littlebird_fire( 7, 4.5 );
	
	wait 0.3;
	
	vh_littlebird3 = spawn_vehicle_from_targetname( "us_littlebird" );
	vh_littlebird3.origin = s_spawnpt.origin;
	vh_littlebird3.angles = s_spawnpt.angles;
	vh_littlebird3 thread zodiac_littlebird_logic( ( -200, 0, 150 ) );
	vh_littlebird3 thread littlebird_fire( 6.8, 4.0 );
}


littlebird_fire( n_delay, n_firetime )
{
	self endon( "death" );
	
	wait n_delay;
	
	self thread fire_turret_for_time( n_firetime, 1 );
	self thread fire_turret_for_time( n_firetime, 2 );
}


zodiac_littlebird_logic( v_offset )
{
	self endon( "death" );
	
	s_goal1 = getstruct( "littlebird_zodiac_goal1", "targetname" );
	s_goal2 = getstruct( "littlebird_zodiac_goal2", "targetname" );
	s_goal3 = getstruct( "littlebird_zodiac_goal3", "targetname" );
	
	self SetNearGoalNotifyDist( 300 );
	
	self SetSpeed( 40, 30, 25 );
	
	self SetVehGoalPos( s_goal1.origin + v_offset, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal2.origin + v_offset, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetSpeed( 80, 30, 25 );
	
	self SetVehGoalPos( s_goal3.origin + v_offset, 0 );
	self waittill_any( "goal", "near_goal" );
	
	VEHICLE_DELETE( self );
}


phantom_truck_killer()
{
	wait 2;
	
	level thread spawn_gaz_trucks();
		
	wait 4;
	
	vh_phantom1 = spawn_vehicle_from_targetname( "us_phantom" );
	vh_phantom1 thread go_path( GetVehicleNode( "start_truck_killer1", "targetname" ) );
	vh_phantom1 thread phantom_fire_rocket();
	
	wait 0.5;
	
	vh_phantom2 = spawn_vehicle_from_targetname( "us_phantom" );
	vh_phantom2 thread go_path( GetVehicleNode( "start_truck_killer2", "targetname" ) );
	vh_phantom2 thread phantom_fire_rocket();
	
	wait 0.7;
	
	vh_phantom3 = spawn_vehicle_from_targetname( "us_phantom" );
	vh_phantom3 thread go_path( GetVehicleNode( "start_truck_killer3", "targetname" ) );
	vh_phantom3 thread phantom_fire_rocket();
	
	wait 1;
	
	flag_set( "destroy_gaz_trucks" );
}


spawn_gaz_trucks()
{
	vh_truck1 = spawn_vehicle_from_targetname( "pan_gaz_truck" );
	vh_truck1 thread go_path( GetVehicleNode( "start_gaz_truck", "targetname" ) );
	vh_truck1 thread gaz_truck_destroy();
	
	wait 1.5;
	
	vh_truck2 = spawn_vehicle_from_targetname( "pan_gaz_truck" );
	vh_truck2 thread go_path( GetVehicleNode( "start_gaz_truck", "targetname" ) );
	vh_truck2 thread gaz_truck_destroy();
	
	wait 1.8;
	
	vh_truck3 = spawn_vehicle_from_targetname( "pan_gaz_truck" );
	vh_truck3 thread go_path( GetVehicleNode( "start_gaz_truck", "targetname" ) );
	vh_truck3 thread gaz_truck_destroy();
	
	flag_wait( "destroy_gaz_trucks" );
	
	//play_fx( "cessna_fire", GetVehicleNode( "node_fire", "targetname" ).origin, undefined, "first_blood_guys_cleared", false, undefined, true );
}


gaz_truck_destroy()
{
	self endon( "death" );
	
	play_fx( "fx_vlight_headlight_default", self.origin, self.angles, undefined, true, "tag_headlight_left", true );
	play_fx( "fx_vlight_headlight_default", self.origin, self.angles, undefined, true, "tag_headlight_right", true );
	play_fx( "fx_vlight_brakelight_default", self.origin, self.angles, undefined, true, "tag_tail_light_left", true );
	play_fx( "fx_vlight_brakelight_default", self.origin, self.angles, undefined, true, "tag_tail_light_right", true );
		
	flag_wait( "destroy_gaz_trucks" );
	
	wait RandomFloatRange( 0.5, 1.0 );
	
	self vehicle_detachfrompath();
	
	wait 0.1;
	
	self LaunchVehicle( ( 100, 200, 300 ), ( AnglesToRight( self.angles ) * 180 ), true, 1 );
	
	wait 0.5;
	
	play_fx( "cessna_fire", self.origin, self.angles, undefined, true, "tag_origin", true );
	
	self thread gaz_truck_delete();
	
	RadiusDamage( self.origin, 100, 4000, 3500 );
}


gaz_truck_delete()
{
	self waittill( "death" );
	
	wait 2;
	
	VEHICLE_DELETE( self );
}


phantom_fire_rocket()
{
	self endon( "death" );
	
	self veh_magic_bullet_shield( true );
	
	wait 1.5;
	
	MagicBullet( "apache_rockets", ( self.origin + ( AnglesToForward( self.angles ) * 200 ) ), ( self.origin + ( AnglesToForward( self.angles ) * 1000 ) ) );
	wait 0.1;
	MagicBullet( "apache_rockets", ( self.origin + ( AnglesToForward( self.angles ) * 200 ) ), ( self.origin + ( AnglesToForward( self.angles ) * 1000 ) ) );
}


set_zodiac_exit_ads()  //self = level.player
{
	scene_wait( "zodiac_approach_player" );
	
	self SetForceAds( true );
	self ShowViewModel();
	self EnableWeapons();
	
	scene_wait( "zodiac_dismount_player" );
	
	self SetForceAds( false );
}


set_zodiac_overlay()  //self = level.player
{
	wait 0.25;
	
	self SetClientFlag( CLIENT_FLAG_PLAYER_ZODIAC );	
	
	scene_wait( "zodiac_approach_player" );
	
	self ClearClientFlag( CLIENT_FLAG_PLAYER_ZODIAC );
}


can_see_buildings_on_zodiac()
{
	wait 7; // wait for the zodiac can see the buildings
	
	flag_set( "can_turn_off_lights" );
	
	wait 3; // wait for the zodiac cannot see the buildings
	
	flag_clear( "can_turn_off_lights" );
}

turn_off_hotel_lights()
{	
	s_hotel = getstruct( "hotel_group_1", "targetname" );
	while ( !( level.player is_player_looking_at( s_hotel.origin, 0.95 ) ) || !flag( "can_turn_off_lights" ) )
	{
		wait 0.05;
	}
	
	exploder( 251 );
	wait 0.5;
	
	a_floor_numbers = array( 1, 2, 3, 4, 5, 6 );
	a_floor_numbers = array_randomize( a_floor_numbers );
	
	for ( i = 0; i < 3; i++ )
	{
		a_hotel_lights = GetEntArray( "hotel_floor_" + a_floor_numbers[i], "targetname" );
		
		foreach ( m_hotel_light in a_hotel_lights )
		{
			m_hotel_light Delete();
		}
	}
	
	wait 0.4;
	
	for ( i = 3; i < 6; i++ )
	{
		a_hotel_lights = GetEntArray( "hotel_floor_" + a_floor_numbers[i], "targetname" );
		
		foreach ( m_hotel_light in a_hotel_lights )
		{
			m_hotel_light Delete();
		}
	}
}

beach_dialog()
{
	level.mason say_dialog( "maso_mcknight_it_s_maso_0" );		//McKnight.  It's Mason.  We're in.
	level.player say_dialog( "mckn_seal_teams_will_secu_0" );	//Seal teams will secure the airfield and PDF Central HQ to prevent false profit's escape.
	level.player say_dialog( "mckn_i_ll_provide_over_wa_0" );	//I'll provide over watch from Building 12 off the battle map.
	level.mason say_dialog( "maso_didn_t_hudson_nix_th_0" );	//Didn't Hudson nix that plan?
	level.player say_dialog( "mckn_if_he_did_he_didn_t_0" );	//If he did, he didn't tell me.
	level.player say_dialog( "mckn_good_luck_mason_m_0" );		//Good luck, Mason.  McKnight out.
	
	flag_set( "beach_intro_vo_done" );
	
	flag_wait( "contextual_melee_done" );
	
	level.mason say_dialog( "maso_you_know_what_they_s_0" );	//You know what they say - If you're gonna fuck up - get it outta the way early.
	
	level thread general_enemy_vo();
	
	trigger_wait( "trig_first_color_street" );
	
	level notify( "stop_general_enemy_vo" );
}

challenge_thinkfast( str_notify )
{
	flag_wait( "contextual_melee_success" );
	
	self notify( str_notify );	
}

challenge_nightingale( str_notify )
{
	level waittill( "nightingale_challenge_completed" );
	
	self notify( str_notify );
}

challenge_close_hangar_doors( str_notify )
{
	flag_wait( "hangar_doors_closing" );
	
	self notify( str_notify );
}

challenge_destroy_learjet( str_notify )
{
	flag_wait( "player_destroyed_learjet" );
	
	self notify( str_notify );
}

challenge_turret_kill( str_notify )
{
	trigger_wait( "trig_color_leer_jet" );
	
	while ( true )
	{
		level waittill( "killed_by_turret" );
	
		self notify( str_notify );
	}
}

challenge_find_weapon_cache( str_notify )
{
	level waittill( "slums_found_weapon_cache" );
	
	self notify( str_notify );
}

end_boat_sounds()
{
	level.player stoploopsound( 1 );
	level.player playsound( "evt_boat_stop" );
}

//beach_fail_condition()
//{
//	trigger_wait( "beach_fail" );
//	
//	SetDvar( "ui_deadquote", &"PANAMA_HANGAR_FAIL" );
//
//	level notify( "mission failed" );
//	maps\_utility::missionFailedWrapper();	
//}

zodiac_jet_flyover()
{
//	vh_zodiac_jets = spawn_vehicles_from_targetname_and_drive( "vh_zodiac_jets" );
//	array_thread( vh_zodiac_jets, ::add_jet_fx ); 
}

invasion_read()
{
	level thread ac130_fire();
	
	//littlebird armade during zodiac
	a_zodiac_littlebird_armada = spawn_vehicles_from_targetname_and_drive( "zodiac_littlebird_armada" );
	
	//jet that takes out the building
	a_intro_building_jets = spawn_vehicles_from_targetname_and_drive( "intro_building_jet" );
	level.player playsound ("evt_zodiac_flyby_f");
	level thread temp_building_fx_explosion();
	
	//jet that takes out truck convoy
	intro_convoy_jet = spawn_vehicle_from_targetname_and_drive( "intro_convoy_jet" );
	level thread temp_building_fx_explosion();
	
//	vh_trucks = spawn_vehicles_from_targetname_and_drive( "intro_trucks" );
//	foreach( truck in vh_trucks )
//	{
//		truck veh_toggle_tread_fx( false );
//	}	
	
	wait 4.5;
	
//	level thread air_ambience( "parking_lot_jet", "parking_lot_jet_path", "stop_parking_lot_jets", 4.0, 7.0 );
//	level thread air_ambience( "parking_lot_apache", "parking_lot_apache_path", "stop_parking_lot_jets", 4.0, 7.0 );
	
	level thread sky_fire_light_ambience( "airfield", "motel_scene_end" );
	
//	delay_thread( 5, ::sky_fire_light_ambience, "airfield", "motel_scene_end" );
	
	exploder( 101 ); //FLAK AA FIRE
}


ac130_fire()
{
	level endon( "stop_ac130" );
	
	wait 2;
	
	s_spawnpt = getstruct( "ac130_fake_spawnpt", "targetname" );
	
	vh_ac130 = spawn_vehicle_from_targetname( "us_littlebird" );
	vh_ac130.origin = s_spawnpt.origin;
	vh_ac130.angles = s_spawnpt.angles;
	vh_ac130 Hide();
	
	vh_ac130 thread ac130_fake_move( s_spawnpt );
	
	e_ac130 = spawn( "script_model", vh_ac130.origin );
	e_ac130 SetModel( "tag_origin" );
	e_ac130.angles = ( 45, 270, 0 );
	e_ac130 LinkTo( vh_ac130 );
	
	while( 1 )
	{
		PlayFXOnTag( level._effect[ "ac130_intense_fake_no_impact" ], e_ac130, "tag_origin" );
		
		wait RandomFloatRange( 1.0, 1.5 );
	}
}


ac130_fake_move( s_org )
{
	self endon( "death" );
	
	self veh_magic_bullet_shield( true );
	self SetNearGoalNotifyDist( 300 );
	self SetSpeed( 15, 10, 5 );
	
	self SetVehGoalPos( s_org.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	s_goal = getstruct( s_org.target, "targetname" );
	
	while( 1 )
	{
		self SetVehGoalPos( s_goal.origin, 0 );
		self waittill_any( "goal", "near_goal" );
		
		if ( flag( "stop_ac130" ) )
		{
			VEHICLE_DELETE( self );
		}
		
		s_goal = getstruct( s_goal.target, "targetname" );
	}
}


temp_building_fx_explosion()
{
	nd_intro_building_boom = GetVehicleNode( "intro_building_boom", "script_noteworthy" );
	nd_intro_building_boom waittill( "trigger" );
	
	//play explosion fx
//	Iprintlnbold( "building boom" );
	//temp sound added before effect -- GS
	
	exploder( 250 );
}

temp_convoy_fx_explosion()
{
	nd_intro_convoy_boom = GetVehicleNode( "intro_convoy_boom", "script_noteworthy" );
	nd_intro_convoy_boom waittill( "trigger" );
	
	//play explosion fx
	Iprintlnbold( "convoy boom" );	
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
	level.mason Unlink();
	run_scene( "zodiac_dismount_mason" );
	
	//skipto_beach_player_ai = getstruct( "skipto_beach_player_ai", "targetname" );
	//level.mason forceteleport( skipto_beach_player_ai.origin, skipto_beach_player_ai.angles );
	
	nd_mason_beach = GetNode( "nd_mason_beach", "targetname" );
	level.mason SetGoalNode( nd_mason_beach );	
	level.mason waittill( "goal" );
}

//init_temp_contextual_guys()
//{
//	self endon( "death" );
//	self magic_bullet_shield();
//	
//	self.ignoreme = true;
//	
//	n_surprise_anim = "exchange_surprise_" + RandomInt( level.surprise_anims );		
//	self thread stealth_ai_idle_and_react( self, "smoke_idle", n_surprise_anim );	
//	
//	flag_wait( "player_opened_grate" );
//	
//	self Delete();
//}

beach_main()
{	
	level.mason change_movemode( "cqb_sprint" );
	level.mason set_ignoreall( true );
	level.mason set_ignoreme( true );
	
	level.player SetLowReady( true );
	level.player thread beach_walk_speed_adjustment();
	
	level thread beach_dialog();
	
	level.mason mason_movement_on_beach();
	
	flag_wait( "player_at_first_blood" );
	
	level.mason.goalradius = 32;
	
	PlaySoundAtPosition( "evt_bridge_trucks_by" , ( -23474 , -8785 , 322 ));
	
	a_beach_intro_trucks = spawn_vehicles_from_targetname_and_drive( "intro_civ_trucks" );
	foreach( vh_truck in a_beach_intro_trucks )
	{
		vh_truck thread intro_truck_behaviour();
	}
	
	level thread mason_contextual_kill();
	level thread melee_guard_02(); //guard mason kills
	level thread melee_guard_03(); //flare guy
	level thread play_fxanim_building_rubble();
	level thread parking_lot_scene();
	level thread player_contextual_kill();
	level thread parking_lot_exit();
	level thread kill_all_parkinglot();
	
	ai_contextual_guard = simple_spawn_single( "beach_contextual_guard" );
	ai_contextual_guard thread beach_contextual_guard();
	
	flag_wait( "setup_runway_standoff" );
	
	autosave_by_name( "after_parking_lot_battle" );
}

// self == mason
mason_movement_on_beach()
{
	t_move_up_to_drain = GetEnt( "trig_move_up_to_drain", "script_noteworthy" );
	t_move_up_to_drain trigger_off();
	
	self.goalradius = 4;
	
	self waittill( "goal" );
	
	t_move_up_to_drain trigger_on();
}

beach_contextual_guard()
{
	self.goalradius = 8;
	
	trigger_wait( "trig_contextual_melee" );
	
	self Delete();
}

// self == player
beach_walk_speed_adjustment()
{
	level endon( "player_contextual_start" );
	
	const n_dist_min = 128;
	const n_dist_max = 256;
	self.n_speed_scale_min = 0.35;
	self.n_speed_scale_max = 0.65;
	
	while ( true )
	{
		n_dist = Distance2D( level.player.origin, level.mason.origin );

		if ( n_dist < n_dist_min )
		{
			self SetMoveSpeedScale( self.n_speed_scale_min );
		}
		else if ( n_dist > n_dist_max )
		{
			self SetMoveSpeedScale( self.n_speed_scale_max );
		}
		else
		{
			n_speed_scale = linear_map( n_dist, n_dist_min, n_dist_max, self.n_speed_scale_min, self.n_speed_scale_max );
			self SetMoveSpeedScale( n_speed_scale );
		}
		
		wait 0.05;
	}
}

runway_dialog()
{
	trigger_wait( "trig_first_color_street" );
	
	//level.player say_dialog( "mckn_bravo_is_moving_to_s_0" );	//Bravo is moving to support positions on the south end of the Runway.  Golf is advancing.
	level.player say_dialog( "mckn_mason_it_s_mcknight_0" );	//Mason. It's McKnight. I'm in position on building 10.
	level.player say_dialog( "mckn_we_have_pdf_units_po_0" );	//We have PDF units posted all over the airfield. Golf is walking in to a trap.
	level.player say_dialog( "mckn_i_ve_tried_to_warn_t_0" );	//I've tried to warn them, but comms are bugging out.
	level.mason say_dialog( "maso_we_re_on_our_way_m_0" );		//We're on our way.  Mason out.
	level.player say_dialog( "wood_what_about_false_pro_0" );	//What about False Profit?
	level.mason say_dialog( "maso_awaiting_hudson_s_go_0" );	//Awaiting Hudson's go... CIA's watching his every move. I don't think he's going very far.
	
//	scene_wait( "seal_encounter_mason" );
//	
//	level.mason say_dialog( "maso_golf_team_this_is_0" );		//Golf Team.  This is Mason, ready to assist, request cease fire as we clear the roof top.
//	
//	wait 0.5; // There is no response from the Golf team because their comms are still dead.
//	
//	level.mason say_dialog( "maso_damn_still_problem_0" );		//Damn.  Still problems with comms.
//	level.mason say_dialog( "maso_come_on_woods_we_0" );		//Come on, Woods - We go anyway.

	level thread going_up_to_roof_nag();
	
	scene_wait( "mason_skylight_approach" );
	
	level thread skylight_nag();
	
	trigger_wait( "player_jumped_rafters" );
	
	if(flag("hangar_gone_hot") )
	{
		return;	
	}
	if ( level.player HasPerk( "specialty_trespasser" )  )
	{
		level.mason say_dialog( "maso_woods_get_to_the_c_0" );	//Woods - get to the control room!
		level.mason say_dialog( "maso_seal_the_door_give_0" );	//Seal the door - give the seals some room to breathe.
	}
}

going_up_to_roof_nag()
{
	level endon( "player_on_roof" );
	
	add_vo_to_nag_group( "going_up_to_roof_nag", level.mason, "maso_damn_pick_it_up_w_0" );		//Damn!  Pick it up, Woods.
	
	level thread start_vo_nag_group_flag( "going_up_to_roof_nag", "player_on_roof", 16, 3, false, 3 );
}

skylight_nag()
{
	level endon( "player_near_skylight" );
	
	add_vo_to_nag_group( "skylight_nag", level.mason, "maso_come_on_woods_pic_0" );		//Come on, Woods.  Pick it up.
	add_vo_to_nag_group( "skylight_nag", level.mason, "maso_through_the_skylight_0" );
	add_vo_to_nag_group( "skylight_nag", level.mason, "maso_pick_it_up_woods_0" );
	
	level thread start_vo_nag_group_flag( "skylight_nag", "player_near_skylight", 16, 3, false, 3 );
}

melee_guard_02() //guard mason kills
{
	ai_mason_kill_guard = simple_spawn_single( "mason_kill_guard" );
	ai_mason_kill_guard.animname = "guard_3";
	
	run_scene_first_frame( "guard_03_in" );
	
	trigger_wait( "trig_contextual_melee" );
	
	run_scene( "guard_03_in" );
	
	flag_wait( "player_contextual_start" );
	
	run_scene( "guard_03_kill" );
	
//	ai_mason_kill_guard ragdoll_death();
}

melee_guard_03()
{
	flag_wait( "player_contextual_start" );
	
	ai_flare_guy = simple_spawn_single( "flare_guy" );
	ai_flare_guy.animname = "flare_guy";
	
	delay_thread( 3.75, ::open_flareguy_door );

	run_scene( "flare_guy_walkout" );
	
	screen_message_delete();
	
	//check for player button press
	if ( flag( "contextual_melee_success" ) )
	{
		run_scene( "flare_guy_killed" );
//		ai_flare_guy ragdoll_death();
	}
	else
	{
		run_scene( "flare_guy_lives" );
		
		nd_flareguy = GetNode( "nd_flareguy", "targetname" );
		ai_flare_guy SetGoalNode( nd_flareguy );
	}
}

open_flareguy_door()
{
	m_flareguy_door = GetEnt( "m_flareguy_door", "targetname" );
	m_flareguy_door RotateYaw( 130, 0.4, 0.1, 0 ); 
	m_flareguy_door playsound( "evt_guards_door_open" );
	
	screen_message_create( &"PANAMA_CONTEXTUAL_KILL" );
	
	level thread player_contextual_button_press();	
}

player_contextual_kill()
{	
	level.mason thread beach_kill_vo();
	
	trigger_wait( "player_near_sewer" );
	
	level.player SetLowReady( false );
	level.player thread take_and_giveback_weapons( "contextual_melee_done" );	
	
	//give player knife
	level.player GiveWeapon( "knife_held_sp" );
	level.player SwitchToWeapon( "knife_held_sp" );
	
//	m_ladder = GetEnt( "drain_ladder", "targetname" );
//	m_ladder MoveTo( m_ladder.origin - ( 0, 0, 192 ), 0.05 );
//	
//	trig_contextual_melee = GetEnt( "trig_contextual_melee", "targetname" );
//	trig_contextual_melee trigger_off();
	
//	flag_wait( "mason_at_drain" );
	
//	m_ladder MoveTo( m_ladder.origin + ( 0, 0, 192 ), 0.05 );
//	trig_contextual_melee trigger_on();
	
	trigger_wait( "trig_contextual_melee" ); //trigger at the end of the drain pipe
	
	autosave_by_name( "pre_knife_kill" );
	flag_set( "player_climbs_up_ladder" );
	
	run_scene( "player_climbs_up" );
	
	flag_set( "player_contextual_start" ); //starts everyone's animationes
	
	run_scene( "player_melee_whistle" );

	level thread maps\_audio::switch_music_wait ("PANAMA_PRE_HANGAR_FIGHT", 5);
	
	flag_set( "button_wait_done" );
	
	if ( flag( "contextual_melee_success" ) )
	{
		run_scene( "player_knife_kill" );
	}
	else
	{
		run_scene( "player_knife_no_kill" );
	}
	
	autosave_by_name( "after_knife_kill" );	
	
	flag_set( "contextual_melee_done" );
	level.player notify( "contextual_melee_done" );	
	level.player TakeWeapon( "knife_held_sp" );
	
	level.player.ignoreme = 0;
	level.player SetMoveSpeedScale( 1 );
}

// self == mason
beach_kill_vo()
{
	level endon( "player_climbs_up_started" );
	
	trigger_wait( "trig_shh_vo" );
	
	flag_wait( "beach_intro_vo_done" );
	
	if ( !flag( "mason_drain_approach_started" ) )
	{
		self say_dialog( "maso_shhh_hold_up_0" );	//Shhh - Hold up!
	}
	
	flag_wait( "mason_getting_in_drain" );
	
	self say_dialog( "maso_take_em_woods_0" );		//Take ‘em, Woods.
}

play_fxanim_building_rubble()
{
	trigger_wait( "trig_fxanim_building_rubble" );
	
	level notify( "fxanim_bldg_rubble_start" );
}

box_truck_path()
{
	self endon( "death" );
	
	nd_box_truck_stop = GetVehicleNode( "box_truck_stop", "script_noteworthy" );
	nd_box_truck_stop waittill( "trigger" );
	
	self SetSpeedImmediate( 0 );
	
	wait 1.5;
	
	iprintlnbold( "Guard: Leave the box, get moving!" );
	
	wait 7;

	self ResumeSpeed( 10 );
}

//monitor_player_parking_lot_threat()
//{
//	level endon( "parking_lot_gone_hot" );
//
//	while( 1 )
//	{
//		level.player waittill_any( "weapon_fired", "grenade_fire" );
//		flag_set( "parking_lot_gone_hot" );
//		
//		wait 0.05;
//	}	
//}

player_contextual_button_press( guy )
{
	level endon( "knife_button_end" );
		
//	while ( 1 )
//	{
//		if ( level.player UseButtonPressed() || level.player MeleeButtonPressed() )
//		{
//			flag_set( "contextual_melee_success" ); //first melee
//			screen_message_delete();
//			break;
//		}
//		wait 0.05;
//	}
	
	level.player waittill_attack_button_pressed();
	
	flag_set( "contextual_melee_success" );
	screen_message_delete();
}

flare_sky_effect( guy )
{
//	iprintlnbold( "flare effect should be playing" );
	
	s_flare_sky_effect = getstruct( "flare_sky_effect", "targetname" );

	e_flare_weapon_effect = GetEnt( "flare_weapon_effect", "targetname" );
	
	e_flare_effect_mover = Spawn( "script_origin", e_flare_weapon_effect.origin );
	e_flare_effect_mover SetModel( "tag_origin" );	
	
	//wait 0.05;
	//PlayFX( getfx( "fx_cuba_flare" ), e_flare_weapon_effect.origin );
	
	e_flare_weapon_effect LinkTo( e_flare_effect_mover );
	
	//PlayFXOnTag( getfx( "fx_pan_signal_flare" ), e_flare_effect_mover, "tag_origin" );
	PlayFX( getfx( "fx_pan_signal_flare" ), e_flare_weapon_effect.origin );
	
//	e_flare_effect_mover MoveTo( s_flare_sky_effect.origin, 1.5 );
//	e_flare_effect_mover waittill( "movedone" );
//	e_flare_effect_mover Delete();
	
//	e_flare_weapon_effect Delete();
	
//	PlayFX( getfx( "fx_pan_signal_flare" ), s_flare_sky_effect.origin );
}

flare_guy_lives_flare( guy )
{
//	maps\_flare::flare_from_targetname( "flare_lives" );
	m_flare_gun = get_model_or_models_from_scene( "flare_guy_lives", "flare_gun" );
	PlayFXOnTag( level._effect[ "fx_pan_signal_flare" ], m_flare_gun, "tag_fx" );
	exploder( 298 );
}

flare_guy_killed_flare( guy )
{
//	maps\_flare::flare_from_targetname( "flare_killed" );
	m_flare_gun = get_model_or_models_from_scene( "flare_guy_killed", "flare_gun" );
	PlayFXOnTag( level._effect[ "fx_pan_signal_flare" ], m_flare_gun, "tag_fx" );
	exploder( 298 );
}

mason_contextual_kill()
{
	level.mason disable_ai_color();
	
//	level thread run_scene( "mason_drain_approach" );
//	
//	flag_wait( "mason_drain_approach_started" );
//	
//	flag_set( "mason_getting_in_drain" );
//	
//	scene_wait( "mason_drain_approach" );
//	
//	flag_set( "mason_at_drain" );
	
	level thread mason_drain();
	
	flag_wait( "player_contextual_start" );
	
	run_scene( "mason_melee_kill" );
	
	level.mason change_movemode();
	level.mason enable_ai_color();
	
	level.mason set_ignoreall( false );
	level.mason set_ignoreme( false );
	
	nd_mason_post_knife = GetNode( "nd_mason_post_knife", "targetname" );	
	level.mason SetGoalNode( nd_mason_post_knife );
	
	//color chain handling
	waittill_ai_group_amount_killed( "parking_lot_guys", 5 );
	
	trigger_use( "front_parking_lot_color" );

	//waittill_ai_group_ai_count( "parking_lot_guys", 4 );	
	
	waittill_ai_group_spawner_count( "parking_lot_guys", 4 );
	
	//spawn reinforcements, fallback existing
//	flag_set( "spawn_parking_lot_backup" );
	
	trigger_use( "trig_color_parking_mid" );

	//waittill_ai_group_spawner_count( "parking_lot_guys", 1 );
	waittill_ai_group_ai_count( "parking_lot_guys", 1 );	
	
	flag_set( "parking_lot_laststand" );
	
	level thread runway_dialog();
	
	trigger_use( "trig_color_parking_end" );

	waittill_ai_group_cleared( "parking_lot_guys" );
	
	trigger_use( "trig_first_color_street" );
	
	level.mason change_movemode( "sprint" );
}

mason_drain()
{
	level endon( "player_contextual_start" );
	
	level thread run_scene( "mason_drain_approach" );
	
	flag_wait( "mason_drain_approach_started" );
	
	flag_set( "mason_getting_in_drain" );
	
	scene_wait( "mason_drain_approach" );
	
	flag_set( "mason_at_drain" );
	
	run_scene( "mason_drain_walks2back" );
	level thread run_scene( "mason_drain_loop" );
}

open_grate_check()
{
	return ( flag( "player_opened_grate" ) );
}

parking_lot_backup()
{
//	flag_wait( "spawn_parking_lot_backup" );
	
	//a_parking_lot_backup = simple_spawn( "parking_lot_backup" );
	
//	flag_wait( "parking_lot_fallback" );
//	
//	//send any alive ai to fallback
//	a_parking_lot_guys = get_ai_group_ai( "parking_lot_guys" );
//	foreach( guy in a_parking_lot_guys )
//	{
//		guy set_spawner_targets( "parking_lot_fallback" );
//	}	
	
	flag_wait( "parking_lot_laststand" );
	
	//send any alive ai to fallback
	a_parking_lot_guys = get_ai_group_ai( "parking_lot_guys" );
	foreach( guy in a_parking_lot_guys )
	{
		guy set_spawner_targets( "parking_lot_laststand" );
	}	
	
	v_parking_lot_backup_truck = spawn_vehicle_from_targetname_and_drive( "parking_lot_backup_truck" );
}


parking_lot_scene()
{	
	level thread parking_lot_backup();
	
//	level thread pre_standoff_fail();

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
		
//	ai_pdf_guy_1 = simple_spawn_single( "truck_pdf_1", ::truck_pdf_1 );
//	ai_pdf_guy_2 = simple_spawn_single( "truck_pdf_2", ::truck_pdf_2 );
//	level thread run_scene( "unloading_loop" );
		
	flag_wait( "player_contextual_start" );
	
	//background patroller
	simple_spawn( "parking_lot_patroller" );
	
	flag_wait( "contextual_melee_done" );
	
	simple_spawn( "parking_lot_frontline" );
	
	level thread table_flip();
	level thread window_entries();
	level thread car_slide();
	level thread climb_over_wall();
	
	trigger_wait( "spawn_parking_lot_truck" );
	
	//truck drives in and guys unload
	vh_parking_lot_truck = spawn_vehicle_from_targetname_and_drive( "parking_lot_truck" );
	
//	//TODO: place this somewhere else
//	flag_wait( "first_blood_guys_cleared" );
//	
//	flag_set( "stop_runway_planes" );
}

car_slide()
{
	run_scene_first_frame( "car_slide" );
	
	s_lookat_car_slide = getstruct( "lookat_car_slide", "targetname" );
	
	while ( !( level.player is_player_looking_at( s_lookat_car_slide.origin, 0.95 ) ) )
	{
		wait 0.05;
	}
	
	run_scene( "car_slide" );
}

climb_over_wall()
{
	a_spawner_numbers = array( 0, 1, 2 );
	a_spawner_numbers = array_randomize( a_spawner_numbers );
	
	a_wall_climbers = [];
	
	for ( i = 0; i < 2; i++ )
	{
		wait 3;
		
		simple_spawn_single( "wall_climber_" + a_spawner_numbers[i] );
	}
}

table_flip()
{	
	level endon( "table_flip_open" );
	level endon( "table_flip_guy_died" );
	
	run_scene_first_frame( "window_dive" );
	ai_window_dive = GetEnt( "window_table_flip_ai", "targetname" );
	ai_window_dive thread waittill_death_to_send_notify( "table_flip_guy_died" );
	ai_window_dive endon( "death" );
	
	nd_after_table_flip_hall = GetNode( "table_flip_hall_node", "targetname" );
	nd_after_table_flip_hall table_flip_setup( "table_flip_hall" );
	
	nd_after_table_flip_open = GetNode( "table_flip_open_node", "targetname" );
	nd_after_table_flip_open table_flip_setup( "table_flip_open" );
	nd_after_table_flip_open thread table_flip_open( ai_window_dive );
	
	trigger_wait( "trig_table_flip_hall" );
	
	s_window_table_flip = getstruct( "lookat_window_table_flip", "targetname" );
	while ( !( level.player is_player_looking_at( s_window_table_flip.origin, 0.95 ) ) )
	{
		wait 0.05;
	}
	
	level notify( "window_table_flip" );
	
	m_window = GetEnt( "window_3", "targetname" );
	m_window RotateYaw( -145, 1 );
	
	level thread close_window_3();
	
	run_scene( "dive_over" );
	
	level thread run_scene( "table_flip_hall_ai" );
	flag_wait( "table_flip_hall_ai_started" );
	level thread run_scene( "table_flip_hall_table" );
	scene_wait( "table_flip_hall_ai" );
	
	m_clip_before = GetEnt( "table_flip_hall_clip_before", "targetname" );
	m_clip_before Delete();

	m_clip_after = GetEnt( "table_flip_hall_clip_after", "targetname" );
	m_clip_after MoveTo( m_clip_after.origin + ( 0, 0, 64 ), 0.05 );
	wait 0.15;
	m_clip_after DisconnectPaths();
}
close_window_3()
{
	wait(1);
	m_window = GetEnt( "window_3", "targetname" );
	m_window RotateYaw( 145, 1 );
	
}

// self == the enemy that will filp the tables
waittill_death_to_send_notify( str_notify )
{
	self waittill( "death" );
	
	level notify( str_notify );
}

// self == the cover node that is related to this table
table_flip_setup( str_side )
{
	run_scene_first_frame( str_side + "_table" );
	
	m_clip_before = GetEnt( str_side + "_clip_before", "targetname" );
	m_clip_before DisconnectPaths();
}

// self == the cover node that is in the open after the table flip
table_flip_open( ai_window_dive )
{
	level endon( "window_table_flip" );
	level endon( "table_flip_guy_died" );
	ai_window_dive endon( "death" );
	
	trigger_wait( "trig_table_flip_open" );
	
	level notify( "table_flip_open" );
	
	m_window = GetEnt( "window_3", "targetname" );
	m_window RotateYaw( -145, 1 );
	
	run_scene( "dive_over" );
	
	level thread run_scene( "table_flip_open_ai" );
	flag_wait( "table_flip_open_ai_started" );
	level thread run_scene( "table_flip_open_table" );
	scene_wait( "table_flip_open_ai" );
	
	m_clip_before = GetEnt( "table_flip_open_clip_before", "targetname" );
	m_clip_before Delete();

	m_clip_after = GetEnt( "table_flip_open_clip_after", "targetname" );
	m_clip_after MoveTo( m_clip_after.origin + ( 0, 0, 64 ), 0.05 );
	wait 0.15;
	m_clip_after DisconnectPaths();
}

window_entries()
{
	run_scene_first_frame( "dive_over" );
	run_scene_first_frame( "window_mantle" );
	
	trigger_wait( "trig_window_entries" );
	
	s_window_entries = getstruct( "lookat_window_entries", "targetname" );
	while ( !( level.player is_player_looking_at( s_window_entries.origin, 0.95 ) ) )
	{
		wait 0.05;
	}
	
	level thread run_scene( "window_mantle" );
	level thread run_scene( "window_dive" );
	
	m_window = GetEnt( "window_1", "targetname" );
	m_window RotateYaw( -111, 1 );

	m_window = GetEnt( "window_2", "targetname" );
	m_window RotateYaw( 145, 1 );
	
	wait(1);
	
	m_window = GetEnt( "window_1", "targetname" );
	m_window RotateYaw( 111, 1 );
	
	m_window = GetEnt( "window_2", "targetname" );
	m_window RotateYaw( -145, 1 );

}

truck_pdf_1()
{
	self endon( "death" );
	
	level thread run_scene( "truck_guy_1_loop" );
	
	flag_wait( "contextual_melee_done" );
	
	self Delete();
	
	//run_scene( "truck_pdf_1_reaction" );
	
	//self set_spawner_targets( "parking_lot_nodes" );
}

truck_pdf_2()
{
	self endon( "death" );

	level thread run_scene( "truck_guy_2_loop" );

	flag_wait( "contextual_melee_done" );

	self Delete();
	
	//run_scene( "truck_pdf_2_reaction" );	
}

setup_gunner_behaviour()
{
	self endon( "death" );
	
	self.ignoreme = 1;
	
	flag_wait( "spawn_learjet_wave_2" );
	
	self.ignoreme = 0;
}

gunner_death_logic()
{
	self waittill( "death" );
	
	vh_truck = GetEnt( "vh_learjet_truck", "targetname" );
	vh_truck MakeVehicleUsable();
	
	a_enemies = GetAIArray( "axis" );
	ai_random = a_enemies[ RandomInt( a_enemies.size ) ];
	if ( IsAlive( ai_random ) )
	{
		level.b_enemy_is_talking = true;
		ai_random say_dialog( "pdf_damn_we_lost_our_gu_0" );	//Damn! We lost our gunner!
		level.b_enemy_is_talking = undefined;
	}
	
	level.mason say_dialog( "maso_woods_get_on_it_0" );	//Woods! Get on it!
	
	//trigger_use( "trig_learjet_color_1_a" );
}

gunner_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if ( e_attacker != level.player && e_attacker != level.mason )
	{
		n_damage = 0;
	}
	
	return n_damage;
}

//mid_color_chain_think()
//{
//	waittill_ai_group_ai_count( "learjet_pdf", 4 );
//}	
	
learjet_turret_truck()
{
	//targets
	e_turret_target = GetEnt( "learjet_turret_target", "targetname" );
	s_target_start = getstruct( "turret_target_start", "targetname" );
	s_target_end = getstruct( "turret_target_end", "targetname" );
	
	wait 0.5; // delay the spawning of the turret truck
	
	//spawn turret truck
	e_turret_target PlaySound( "evt_lear_jet_truck" );
	vh_learjet_truck = spawn_vehicle_from_targetname_and_drive( "vh_learjet_truck" );
	vh_learjet_truck set_turret_target( e_turret_target, undefined, 1 );
//	vh_learjet_truck.health = 800;

	ai_gunner = GetEnt( "learjet_turret_guy_ai", "targetname" );
	ai_gunner thread gunner_death_logic();
	ai_gunner.overrideActorDamage = ::gunner_damage_override;
	
	vh_learjet_truck waittill( "reached_end_node" );
	
	wait 0.25;

	vh_learjet_truck maps\_turret::set_turret_burst_parameters( 3.0, 5.0, 1.0, 2.0, 1 ); 	
	vh_learjet_truck enable_turret( 1 );
	vh_learjet_truck endon( "death" );
	
	flag_wait( "learjet_intro_vo_done" );
	
	level.mason waittill_done_talking();
	
	level.mason say_dialog( "maso_watch_that_truck_0" );	//Watch that truck!
}

learjet_frontline_color()
{
//	level endon( "spawn_learjet_wave_2" );
//	level endon( "turret_guy_died" );
	
	waittill_ai_group_count( "learjet_pdf_frontline", 2 );
	
	flag_set( "spawn_learjet_wave_2" );
	
//	iprintlnbold( "learjet_pdf_frontline Ai Count = 1" );
}
	
init_learjet_pdf_frontline_rpg()
{
	self endon( "death" );
	
	e_pdf_rpg_target = GetEnt( "pdf_rpg_target", "targetname" );
	
	self.ignoreme = 1;
	self.ignoreall = 1;
	self.goalradius = 32;
	
	nd_rpg_spot = GetNode( self.target, "targetname" );
	self force_goal( nd_rpg_spot, 32 );
	self waittill( "goal" );
	
	self thread learjet_pdf_with_rpg_vo();
	
	wait 1;
	
	MagicBullet( "rpg_magic_bullet_sp", self GetTagOrigin( "tag_flash" ), e_pdf_rpg_target.origin );		
	
	wait 1.5;
	
	nd_post_rpg = GetNode( "nd_post_rpg", "targetname" );
	self force_goal( nd_post_rpg, 32 );
	
	self.ignoreme = 0;
	self.ignoreall = 0;
	
	flag_set( "learjet_pdf_with_rpg_at_final" );
}

learjet_pdf_with_rpg_vo()
{
	self endon( "death" );
	
	level.mason waittill_done_talking();
	
	level.mason say_dialog( "maso_shooter_building_r_0" );	//Shooter - building rooftop across the way!
	
	flag_wait( "learjet_pdf_with_rpg_at_final" );
	
	level.mason waittill_done_talking();
	
	level.mason say_dialog( "maso_rpg_second_floor_0" );	//RPG!  Second floor!
}
	
bash_door_pdf()
{
	run_scene_first_frame( "pdf_shoulder_bash" );
	
	trigger_wait( "trig_shoulder_bash", "script_noteworthy" );
	
	run_scene( "pdf_shoulder_bash" );
	
	level thread maps\_audio::switch_music_wait ("PANAMA_HOTEL_RUN", 8);
}

clean_up_stuff_before_hangar()
{
	end_scene( "zodiac_approach_seals" );
	end_scene( "zodiac_approach_seals2" );
	
	a_enemies = GetAIArray( "axis" );
	
	// delete AIs that meets the requiremnts given by the parameters
	foreach ( ai_enemy in a_enemies )
	{
		if ( ai_enemy.origin[ 1 ] < -6144 )
		{
			ai_enemy Delete();
		}
	}
}

general_enemy_vo()
{
	level endon( "stop_general_enemy_vo" );
	
	n_array_counter = 0;
	
	// this array has to have more than 2 items
	a_enemy_vo = array( "pdf_don_t_let_the_gringo_0", "pdf_for_general_noriega_0", "pdf_keep_shooting_comra_0", "pdf_reloading_0", "pdf_we_can_t_let_them_ad_0", "pdf_don_t_let_them_move_0", "pdf_for_panama_0", "pdf_running_low_on_ammo_0", "pdf_we_cannot_fail_0", "pdf_fuck_you_americans_0", "pdf_we_have_to_win_this_0", "pdf_we_need_to_make_a_st_0" );
	a_enemy_vo = random_shuffle( a_enemy_vo );
	
	while ( true )
	{
		while ( IsDefined( level.b_enemy_is_talking ) )
		{
			wait 0.05;
		}
		
		level.mason waittill_done_talking();
		
		a_enemies = GetAIArray( "axis" );
		ai_random = a_enemies[ RandomInt( a_enemies.size ) ];
		if ( IsAlive( ai_random ) )
		{
			ai_random say_dialog( a_enemy_vo[ n_array_counter ] );
		}
		
		n_array_counter++;
			
		// suffle the array once all dialog has been said
		if ( n_array_counter == a_enemy_vo.size )
		{
			a_enemy_vo = random_shuffle( a_enemy_vo );
			n_array_counter = 0;
		}
		
		wait RandomFloat( 8.1, 9.9 );
		
		wait 0.05;
	}
}

random_shuffle( a_items ) // this function helps to make sure no dialog repeats
{
	b_done_shuffling = undefined;
	item = a_items[ a_items.size - 1 ];
	
	while ( !IS_TRUE( b_done_shuffling ) )
	{
		a_items = array_randomize( a_items );
		if ( a_items[0] != item )
		{
			b_done_shuffling = true;
		}
		
		wait 0.05;
	}
	
	return a_items;
}

learjet_main()
{
	clean_up_stuff_before_hangar();
	
	m_fxanim_learjet = GetEnt( "fxanim_private_jet", "targetname" );
	m_fxanim_learjet Hide();
	
	trigger_wait( "trig_color_leer_jet" );
	level thread maps\createart\panama_art::learjet();
	//Spawn LearJet
	vh_learjet = spawn_vehicle_from_targetname( "vh_lear_jet" );
	vh_learjet veh_toggle_tread_fx( false );
	vh_learjet thread learjet_challenge_think( m_fxanim_learjet );
	
	level thread learjet_side_battle();
	level thread learjet_battle_seal_vs_pdf();
	level thread learjet_dialog();
	
	trigger_wait( "trig_learjet_truck" );
	trigger_use( "trig_learjet_color_1_a" );
	//turret truck
	level thread learjet_turret_truck();
	
	autosave_by_name( "learjet_battle_begin" );
	
	level thread general_enemy_vo();
	
	trigger_wait( "trig_learjet_wave_1" );
	
	simple_spawn( "learjet_wave_1" );
	simple_spawn_single( "learjet_wave_1_rpg", ::init_learjet_pdf_frontline_rpg );
	
	trigger_wait( "trig_learjet_wave_2" );
	
	wait 0.05;
	
	level thread learjet_rolling_door();
	level thread learjet_retreat();
	level thread learjet_back_left();
	level thread learjet_back_right();
	level thread learjet_multiple_enemy_vo();
	level thread learjet_middle_move_up_mason();
	
	trigger_wait( "trig_learjet_wave_3" );
	
	level thread seal_breaches();
	level thread bash_door_pdf();
	
	level.mason thread waittill_at_bash();
	
	scene_wait( "pdf_shoulder_bash" );
	
	level thread mason_door_bash();
	level thread player_door_kick();
	
	flag_wait( "friendly_door_bash_done" );
	
	level thread pool_guy1_death();	
	level thread pool_guy2_death();
	
	trigger_use( "trig_color_post_bash" ); //color chain after the bash
	
	level.mason change_movemode( "sprint" );
	
	autosave_by_name( "learjet_done" );
}

learjet_middle_move_up_mason()
{
	waittill_ai_group_amount_killed( "learjet_frontline", 9 );
	
	trigger_use( "trig_learjet_color_3" );
	trigger_use( "trig_learjet_wave_3" );
}

seal_breaches()
{
	trigger_wait( "trig_seal_breach_1" );
	
	level thread general_seals();
	
	run_scene( "seal_breach_1" );
	
	ai_seal_a = GetEnt( "door_breach_a_1_ai", "targetname" );
	ai_seal_a thread waittill_goal_and_die();
	
	ai_seal_a = GetEnt( "door_breach_a_2_ai", "targetname" );
	ai_seal_a thread waittill_goal_and_die();
}

general_seals()
{
	flag_wait( "seal_breach_1_started" );
	
	ai_seal = simple_spawn_single( "general_seal_1" );
	ai_seal change_movemode( "cqb_sprint" );
	ai_seal thread waittill_goal_and_die();
	
	wait 0.05;
	
	ai_seal = simple_spawn_single( "general_seal_2" );
	ai_seal change_movemode( "cqb_sprint" );
	ai_seal thread waittill_goal_and_die();
}

waittill_goal_and_die()
{
	nd_goal = GetNode( self.target, "targetname" );
	self force_goal( nd_goal, 16 );
	self Delete();
}

learjet_multiple_enemy_vo()
{
	level.mason waittill_done_talking();
	
	level.player say_dialog( "wood_dammit_multiple_ene_0" );	//Dammit! Multiple enemy - ground level.
}

// self == mason
waittill_at_bash()
{
	trigger_wait( "trig_approach_door_bash" );
	
	autosave_by_name( "learjet_battle_done" );
	flag_set( "learjet_battle_done" );
	
	self waittill( "goal" );
	
	flag_set( "in_bash_position" );
}

learjet_side_battle()
{
	//gaz truck on runway
	vh_learjet_gaz = spawn_vehicle_from_targetname_and_drive( "vh_learjet_gaz" );
	vh_learjet_gaz_2 = spawn_vehicle_from_targetname( "vh_learjet_gaz_2" );

	//extra seals on the side -- ignore function name
	level thread seals_destroy_learjet();
}

learjet_rolling_door()
{
	m_garage_door_segment_1 = GetEnt( "garage_door_segment1", "targetname" );
	m_garage_door_segment_2 = GetEnt( "garage_door_segment2", "targetname" );
	m_garage_door_segment_3 = GetEnt( "garage_door_segment3", "targetname" );
	m_garage_door_segment_4 = GetEnt( "garage_door_segment4", "targetname" );
	m_garage_door_segment_5 = GetEnt( "garage_door_segment5", "targetname" );
	
	m_garage_door_segment_1 MoveTo( m_garage_door_segment_1.origin + ( 0, 0, 24 ), 1 );
	m_garage_door_segment_2 MoveTo( m_garage_door_segment_2.origin + ( 0, 0, 48 ), 2 );
	m_garage_door_segment_3 MoveTo( m_garage_door_segment_3.origin + ( 0, 0, 72 ), 3 );
	m_garage_door_segment_4 MoveTo( m_garage_door_segment_4.origin + ( 0, 0, 96 ), 4 );
	m_garage_door_segment_5 MoveTo( m_garage_door_segment_5.origin + ( 0, 0, 120 ), 5 );
	
	level thread run_scene( "rolling_door_guy" );
	level thread run_scene( "rolling_door_guy_2" );
	level thread learjet_garage_guys_vo();
	
	m_garage_door_segment_1 waittill( "movedone" );
	m_garage_door_segment_1 Delete();
	
	m_garage_door_segment_2 waittill( "movedone" );
	m_garage_door_segment_2 Delete();
	
	m_garage_door_segment_3 waittill( "movedone" );
	m_garage_door_segment_3 Delete();
	
	m_garage_door_segment_4 waittill( "movedone" );
	m_garage_door_segment_4 Delete();
	
	m_garage_door_segment_5 waittill( "movedone" );
	m_garage_door_segment_5 Delete();
	
	m_garage_clip = GetEnt( "garage_clip", "targetname" );
	m_garage_clip ConnectPaths();
	m_garage_clip Delete();
}

learjet_garage_guys_vo()
{
	level.mason waittill_done_talking();
	
	level.mason say_dialog( "maso_coming_through_the_g_0" );	//Coming through the gate!
}

learjet_retreat()
{
	trigger_wait( "trig_learjet_retreat" );
	
	a_learjet_enemies = GetEntArray( "learjet_intro_pdf_ai", "targetname" );
	nd_side_reinforcement_node = GetNode( "side_reinforcement_node", "targetname" );
	
	foreach ( ai_enemy in a_learjet_enemies )
	{
		ai_enemy SetGoalNode( nd_side_reinforcement_node );
		ai_enemy.goalradius = 256;
		ai_enemy disable_tactical_walk();
	}
}

learjet_back_left()
{
	trigger_wait( "trig_learjet_back_left" );
	
	ai_back_left = simple_spawn_single( "learjet_back_left" );
	ai_back_left change_movemode( "sprint" );
	
	ai_back_left waittill( "goal" );
	
	ai_back_left change_movemode();
	ai_back_left set_ignoreall( false );
}

learjet_back_right()
{
	trigger_wait( "trig_learjet_kick_down_back_door" );
	
	m_back_door_clip = GetEnt( "garage_back_door_clip", "targetname" );
	m_back_door_clip ConnectPaths();
	m_back_door_clip Delete();
	
	level thread run_scene( "learjet_back_door_kick" );
}

learjet_back_door_open( ai_door_kick_pdf )
{
	m_back_door = GetEnt( "garage_back_door", "targetname" );
	m_back_door RotateYaw( 145, 1 );
}

seal_breach_door_open( ai_door_kick_pdf )
{
	m_back_door = GetEnt( "seal_breach_door_1", "targetname" );
	m_back_door RotateYaw( 145, 1 );
}
	
//learjet_main_old()
//{
//	level thread bash_door_pdf();
//	
//	level thread hotel_path_fail();
//	
//	trig_shoulder_bash = GetEnt( "trig_shoulder_bash", "script_noteworthy" );
//	trig_shoulder_bash trigger_off();
//	
//	trigger_wait( "trig_color_leer_jet" );
//	
//	level thread learjet_battle_seal_vs_pdf();
//
//	//gaz truck on runway
//	vh_learjet_gaz = spawn_vehicle_from_targetname_and_drive( "vh_learjet_gaz" );
//	vh_learjet_gaz_2 = spawn_vehicle_from_targetname( "vh_learjet_gaz_2" );
//	
//	//Spawn LearJet
//	vh_lear_jet = spawn_vehicle_from_targetname( "vh_lear_jet" );
//	vh_lear_jet veh_toggle_tread_fx( false );
//	vh_lear_jet thread learjet_challenge_think();
//	
//	//seals take out lear if player doesnt
//	level thread seals_destroy_learjet();
//	
//	trigger_wait( "trig_learjet_truck" );
//	vh_lear_jet thread learjet_audio();
//
//	//Spawn frontline of PDF
//	simple_spawn( "learjet_pdf_frontline" );
//
//	simple_spawn_single( "learjet_pdf_frontline_rpg", ::init_learjet_pdf_frontline_rpg );
//	
//	//color chain
//	level thread learjet_frontline_color();
//	
//	//turret truck
//	level thread learjet_turret_truck();
//	
//	flag_wait( "spawn_learjet_wave_2" );
//	
//	//masons color chain
//	trigger_use( "trig_color_front_lear" );
//	wait 0.05;
//	trigger_use( "trig_color_mid_lear" );
//	
//	level thread shop_door_opens();
//	
//	level thread run_scene( "rolling_door_guy" );
//	level thread run_scene( "rolling_door_guy_2" );
//	
//	simple_spawn( "learjet_pdf_backup" );
//
//	//send frontline pdf back if they're still alive
//	a_learjet_pdf_frontline = get_ai_group_ai( "learjet_pdf_frontline" );
//	foreach( pdf in a_learjet_pdf_frontline )
//	{
//		if ( IsDefined( pdf ) )
//		{
//			pdf set_spawner_targets( "learjet_fallback_nodes" );		
//		}
//	}
//	
//	simple_spawn( "learjet_pdf_last_wave" );
//
//	level thread learjet_far_color();
//	
//	//waittill_ai_group_cleared( "learjet_pdf_backup" );	
//	waittill_ai_group_count( "learjet_pdf_backup", 2 );
//	
//	nd_mason_post_learjet = GetNode( "nd_mason_post_learjet", "targetname" );
//	level.mason SetGoalNode( nd_mason_post_learjet );
//	
////	waittill_ai_group_cleared( "learjet_pdf_backup" );
//	trigger_wait( "trig_approach_door_bash" );
//		
//	nd_mason_pre_bash = GetNode( "nd_mason_pre_bash", "targetname" );
//	level.mason SetGoalNode( nd_mason_pre_bash );
//	
//	level thread learjet_dialog();
//	
//	autosave_by_name( "motel_run_save" );
//	
//	vh_motel_vehicles = spawn_vehicles_from_targetname_and_drive( "vh_motel_vehicles" );
//	
//	flag_set( "airfield_end" );
//	
//	autosave_by_name( "motel_path" );
//	
//	scene_wait( "pdf_shoulder_bash" );
//	
//	level thread mason_door_bash();
//	level thread player_door_kick();
//	
//	flag_wait( "friendly_door_bash_done" );
//	
//	//level thread intruder_box();
//	
//	flag_set( "skinner_motel_dialogue" ); //mcknight gives us noriega+'s location
//	
//	level.mcknight_sniper = simple_spawn_single( "mcknight_sniper", ::setup_mcknight_sniper );
//	//a_motel_path_runners = simple_spawn( "motel_pool_runners", ::setup_motel_pool_runners );
//	
//	level thread pool_guy1_death();	
//	level thread pool_guy2_death();
//	
//	//Distance fail condition
//	level thread monitor_player_distance();
//	
//	trigger_use( "trig_color_post_bash" ); //color chain after the bash
//	
//	level thread temp_cleanup_func();
//	
//	//Shabs - temp fix for progression, these guys spawn from a notetrack
//	simple_spawn( "motel_path_runners", ::init_motel_path_runners );
//	
//	level thread monitor_mason_motel_sprint();
//	
//	maps\createart\panama_art::set_water_dvar();
//}

learjet_battle_seal_vs_pdf()
{
	trigger_wait( "trig_learjet_battle" );
	
	cleanup_seals();
	
	trigger_wait( "trig_learjet_color_1" );
	
	level thread run_scene( "learjet_battle_seal" );
	run_scene( "learjet_battle_pdf" );
}

cleanup_seals()
{
	a_ai_seal1 = GetEntArray( "seal_group_1_ai", "targetname" );
	
	if ( IsDefined( a_ai_seal1 ) )
	{
		foreach( ai_seal1 in a_ai_seal1 )
		{
			ai_seal1 die();
		}
	}
	
	a_ai_seal2 = GetEntArray( "seal_group_2_ai", "targetname" );
	
	if ( IsDefined( a_ai_seal2 ) )
	{
		foreach( ai_seal2 in a_ai_seal2 )
		{
			ai_seal2 die();
		}
	}
	
	spawn_manager_kill( "trig_sm_runway_seals" );
	
	wait 0.1;
	
	a_ai_hangar_seals = GetEntArray( "hangar_seals_ai", "targetname" );
	
	if ( IsDefined( a_ai_hangar_seals ) )
	{
		foreach( ai_hangar_seal in a_ai_hangar_seals )
		{
			ai_hangar_seal delete();
		}
	}
	
	a_ai_foreshadow = get_ai_group_ai( "foreshadow_seals" );
	
	if ( IsDefined( a_ai_foreshadow ) )
	{
		foreach( ai_foreshadow in a_ai_foreshadow )
		{
			ai_foreshadow die();
		}
	}
	
	a_ai_rescue_seals = get_ai_group_ai( "rescue_seals" );
	
	if ( IsDefined( a_ai_rescue_seals ) )
	{
		foreach( ai_rescue_seals in a_ai_rescue_seals )
		{
			ai_rescue_seals die();
		}
	}
	
	a_ai_standoff_seals = get_ai_group_ai( "standoff_seals" );
	
	if ( IsDefined( a_ai_standoff_seals ) )
	{
		foreach( ai_standoff_seals in a_ai_standoff_seals )
		{
			ai_standoff_seals die();
		}
	}
}


player_door_kick()
{
	level endon( "mason_bashes_door" );
	
	trigger_wait( "trig_player_kick_door" );
	
	wait 0.05;
	
	level notify( "player_kicks_door" );
	
	level thread delete_door_bash_clip( "player_door_kick_started" );
	
	simple_spawn( "motel_path_runners", ::init_motel_path_runners );
	
	level thread run_scene( "player_door_kick_door" );
	run_scene( "player_door_kick" );
	
	flag_set( "friendly_door_bash_done" );
}

mason_door_bash()
{
	level endon( "player_kicks_door" );
	
	flag_wait( "in_bash_position" );
	
	wait 0.05;
	
//	t_shoulder_bash = GetEnt( "trig_shoulder_bash", "script_noteworthy" );
//	t_shoulder_bash trigger_on();
//	
//	flag_wait( "start_shoulder_bash" );
	
	level notify( "mason_bashes_door" );
	level thread delete_door_bash_clip( "mason_shoulder_bash_started" );
	simple_spawn( "motel_path_runners", ::init_motel_path_runners );
	
	level thread run_scene( "mason_shoulder_bash" );
	
	flag_wait( "mason_shoulder_bash_started" );
	
	level thread run_scene( "mason_shoulder_bash_door" );
	
	level.mason say_dialog( "maso_i_got_it_0" );	//I got it!
	
	scene_wait( "mason_shoulder_bash" );
	
	flag_set( "friendly_door_bash_done" );
}

delete_door_bash_clip( str_flag )
{
	flag_wait( str_flag );
	
	wait 1;
	
	m_door_bash_clip = GetEnt( "door_bash_clip", "targetname" );
	
	if ( IsDefined( m_door_bash_clip ) )
	{
		m_door_bash_clip Delete();
	}
}

intruder_box()
{
	level.player waittill_player_has_intruder_perk();
	
	s_intruder_obj = getstruct( "intruder_obj", "targetname" );
	set_objective( level.OBJ_INTRUDER, s_intruder_obj.origin, "interact" );
	
	trigger_wait( "trig_intruder" );
	
	set_objective( level.OBJ_INTRUDER, undefined, "remove" );
	
	run_scene( "intruder" );
	
	//level.player give_grenade( "nightingale_sp" );
	level.player GiveWeapon( "nightingale_dpad_sp" );
	level.player SetActionSlot(2, "weapon", "nightingale_dpad_sp");
	
	level.player thread nightingale_watch();
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

learjet_audio()
{
	level endon( "lear_exp_audio" );
	
	sound_ent = spawn( "script_origin" , self.origin );
	sound_ent thread learjet_audio_explode(self);
	self PlaySound( "evt_learjet_poweron" );
	wait 36;
	sound_ent PlayLoopSound( "evt_learjet_loop" , 2 );
}

learjet_audio_explode(jet)
{
	level waittill( "lear_exp_audio" );
	jet stopsound( "evt_learjet_poweron" );
	self stoploopsound( .1 );
}

pool_guy1_death()
{
//	ai_pool_guy_1 = simple_spawn_single( "pool_guy_1" );
//	ai_pool_guy_1.ignoreall = 1;
//	ai_pool_guy_1.animname = "pool_guy_1";
	run_scene_first_frame( "pool_guy_1" );
	
	trigger_wait( "trig_pool_anims" );
	
	run_scene( "pool_guy_1" );
//	ai_pool_guy_1 Die();	
}

pool_guy2_death()
{
	trigger_wait( "trig_pool_anims" );
//	ai_pool_guy_2 = simple_spawn_single( "pool_guy_2" );
//	ai_pool_guy_2.ignoreall = 1;
//	ai_pool_guy_2.animname = "pool_guy_2";
	
	run_scene( "pool_guy_2" );
//	ai_pool_guy_2 Die();
}

setup_mcknight_sniper()
{
	self endon( "death" );
	
	self magic_bullet_shield();
	self.ignoreme = 1;
	self.ignoreall =1;
	
	nd_sniper_node = GetNode( self.target, "targetname" );
	self force_goal( nd_sniper_node, 16 );		
}

setup_motel_pool_runners()
{
	self endon( "death" );
	
	self set_ignoreall( true );
	
	nd_sniper_death = GetNode( self.target, "targetname" );
	self force_goal( nd_sniper_death, 16 );	
	self waittill( "goal" );
	
	PlayFXOnTag( getfx( "sniper_glint" ), level.mcknight_sniper, "tag_flash" );
	wait 0.25;
	MagicBullet( "barretm82_emplacement", level.mcknight_sniper GetTagOrigin( "tag_flash" ), self.origin );

	wait 0.25;
	self Die();
}

learjet_far_color()
{
	waittill_ai_group_count( "learjet_pdf_backup", 7 );
	trigger_use( "trig_color_far_lear" );	
}

shop_door_opens()
{
	//s_delete_door_spot = getstruct( "s_delete_door_spot", "targetname" );
	
	e_garage_mid_piece = GetEnt( "garage_mid_piece", "targetname" );
	e_garage_bottom_piece = GetEnt( "garage_bottom_piece", "targetname" );
	e_garage_clip = GetEnt( "garage_clip", "targetname" );
	
	door_snd = spawn("script_origin", e_garage_bottom_piece.origin);
	door_snd playsound("evt_door_start");
	door_snd playloopsound("evt_door_move", 1);
	
	e_garage_mid_piece MoveZ( 38, 5 );
	e_garage_mid_piece ConnectPaths();
	
	e_garage_bottom_piece MoveZ( 74, 5 );
	e_garage_bottom_piece ConnectPaths();		
	e_garage_bottom_piece waittill( "movedone" );
	
	door_snd playsound("evt_door_stop");
	door_snd stoploopsound (.3);
	
	e_garage_mid_piece Delete();	
	e_garage_bottom_piece Delete();
	
	e_garage_clip ConnectPaths();	
	e_garage_clip Delete();
	
	wait(3);
	door_snd delete();
}

rpg_has_ammo()
{
	if ( level.player GetWeaponAmmoClip( "rpg_sp" ) || level.player GetWeaponAmmoStock( "rpg_sp" ) )
	{
		return true;
	}
	
	return false;
}

learjet_dialog()
{
	trigger_wait( "trig_learjet_color_1" );
	
	level.player say_dialog( "wood_noriega_s_plane_is_r_0" );			//Noriega's plane is ready to fucking go!
	
	a_weapons_list = level.player GetWeaponsList();
	foreach ( str_weapon in a_weapons_list )
	{
		if ( str_weapon == "rpg_sp" && rpg_has_ammo() )
		{
			level.mason say_dialog( "maso_woods_hit_it_with_0" );		//Woods!  Hit it with an RPG.
			level.mason say_dialog( "maso_don_t_let_it_take_of_0" );	//Don't let it take off!
		}
	}
	
	flag_set( "learjet_intro_vo_done" );
	
	trigger_wait( "trig_learjet_wave_3" );
	
	level notify( "stop_general_enemy_vo" );
	

	
	level thread general_enemy_vo();
	
	trigger_wait( "trig_learjet_color_4" );
	
	level notify( "stop_general_enemy_vo" );
	
	scene_wait( "pdf_shoulder_bash" );
	
	level.player say_dialog( "wood_dammit_0" );							//Dammit!

	flag_wait( "friendly_door_bash_done" );
	
	level.player say_dialog( "huds_mason_it_s_hudson_0" );				//Mason. It's Hudson.
	level.mason say_dialog( "maso_where_the_hell_have_0" );				//Where the hell have you been? Hudson?!
	level.player say_dialog( "huds_we_have_confirmation_0" );			//We have confirmation on location of objective False Profit.
	level.player say_dialog( "huds_adelina_hotel_room_0" );				//Adelina Hotel. Room 225. Move to secure.  Hudson out.
	
	
	level.player say_dialog( "mckn_i_have_visual_mult_0" );				//I have visual.  Multiple targets outside the hotel.
	level.player say_dialog( "mckn_leave_them_to_me_0" );				//Leave them to me.
	
	level thread mcknight_clear_pool();
	level thread mcknight_sniping_clear_vo();
	
	flag_wait( "player_near_motel" );
	
	level.mason say_dialog( "maso_225_s_upstairs_2nd_0" );				//225's upstairs.  2nd deck, East side.
	
	flag_wait( "motel_approach_started" );
	
	level.mason say_dialog( "maso_on_me_0" );							//On me.
}

mcknight_clear_pool()
{
	a_enemies_near_pool = GetEntArray( "motel_path_runners_ai", "targetname" );
	foreach ( ai_near_pool in a_enemies_near_pool )
	{
		while ( flag( "mcknight_sniping" ) )
		{
			wait 0.05;
		}
		
		if ( IsAlive( ai_near_pool ) )
		{
			sniper_shoot( ai_near_pool );
		}
		
		wait RandomFloatRange( 2.1, 3.9 );
	}
}

mcknight_sniping_clear_vo()
{
	waittill_ai_group_cleared( "before_motel_enemies" );
	
	level.player say_dialog( "mckn_you_re_clear_0" );					//You're clear.
}

open_bash_door( guy )
{
	m_door_bash_clip = GetEnt( "door_bash_clip", "targetname" );
	m_door_bash_clip Delete();
	
	iprintln( "door notetrack is getting hit" );
	
//	m_shoulder_bash_door = GetEnt( "m_shoulder_bash_door", "targetname" );
//	m_shoulder_bash_door RotateYaw( 130, 0.2, 0.1, 0 ); 
	
//	run_scene( "bash_door_mason" );
	
//	PlayFx( getfx( "door_breach" ), m_shoulder_bash_door.origin );
	
	//spawn motel path runners
	simple_spawn( "motel_path_runners", ::init_motel_path_runners );
	
	level thread monitor_mason_motel_sprint();
}

monitor_mason_motel_sprint()
{
	waittill_ai_group_cleared( "motel_path_runners" );
	level.mason change_movemode( "sprint" );
}

init_motel_path_runners()
{
	self endon( "death" );
	
	self.ignoreall = true;
	
	nd_die = GetNode( self.target, "targetname" );
	self SetGoalNode( nd_die );
	
	self waittill( "goal" );
	
	self.ignoreall = false;
	
//	self Die();
}

temp_cleanup_func()
{
	trigger_wait( "trig_motel_obj" );

	autosave_by_name( "motel_breach" );
	
	level.mcknight_sniper Delete();
	
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

//self == learjet
learjet_challenge_think( m_fxanim_learjet )
{
	level endon( "motel_scene_end" );
	
	self.do_scripted_crash = false;
	
	self thread seal_shoot_learjet();
	
	self waittill( "death", e_attacker );
	
	level notify( "lear_exp_audio" );//stops jet audio
	
	flag_set( "learjet_destroyed" );
	
	if ( level.player == e_attacker )
	{
		flag_set( "player_destroyed_learjet" );
	}
	
//	self SetModel( "veh_t6_air_private_jet_dead" );
//	
//	run_scene( "learjet_explosion" );
	
	self Hide();
	m_fxanim_learjet Show();
	
	level notify( "fxanim_private_jet_start" );
}

seal_shoot_learjet()
{
	level endon( "learjet_destroyed" );
	
	trigger_wait( "seal_shoot_learjet" );
	
	level thread run_scene( "seal_rocket" );
}

seals_destroy_learjet()
{	
	//2 pdf that aren't in a vehicle
	a_learjet_runway_pdf = simple_spawn( "learjet_runway_pdf" );
	a_learjet_rpg_seals = simple_spawn( "learjet_rpg_seals", ::init_learjet_rpg_seals );
	a_learjet_intro_pdfs = simple_spawn( "learjet_intro_pdf" );
	
	CreateThreatBiasGroup( "learjet_runway_seals" );
	CreateThreatBiasGroup( "learjet_intro_pdfs" );
	
	foreach ( ai_seal in a_learjet_rpg_seals )
	{
		ai_seal SetThreatBiasGroup( "learjet_runway_seals" );
	}
	
	foreach ( ai_intro_pdf in a_learjet_intro_pdfs )
	{
		ai_intro_pdf SetThreatBiasGroup( "learjet_intro_pdfs" );
		ai_intro_pdf magic_bullet_shield();
		
		if ( IsDefined( ai_intro_pdf.script_noteworthy ) && ai_intro_pdf.script_noteworthy == "learjet_intro_retreat" )
		{
			ai_intro_pdf_retreat = ai_intro_pdf;
		}
	}
	
	SetThreatBias( "learjet_runway_seals", "learjet_intro_pdfs", 100 );
	
	ai_intro_pdf_retreat thread learjet_intro_ai_retreat();
	
	trigger_wait( "trig_learjet_truck" );
	
	foreach ( ai_intro_pdf in a_learjet_intro_pdfs )
	{
		ai_intro_pdf stop_magic_bullet_shield();
	}
	
	trigger_wait( "seal_shoot_learjet" );
	
	SetThreatBias( "learjet_runway_seals", "learjet_intro_pdfs", 0 );
	
	CreateThreatBiasGroup( "learjet_enemies" );
	
	foreach ( ai_intro_pdf in a_learjet_intro_pdfs )
	{
		if ( IsAlive( ai_intro_pdf ) )
		{
			if ( !IsDefined( ai_intro_pdf.script_noteworthy ) )
			{
				ai_intro_pdf.goalradius = 2048;
			}
			
			ai_intro_pdf SetThreatBiasGroup( "learjet_enemies" );
		}
	}
	
	SetThreatBias( "learjet_enemies", "learjet_runway_seals", -10000 );
	
	waittill_ai_group_count( "learjet_runway_pdf", 3 );
	
	nd_delete_learjet_seals = GetNode( "nd_delete_learjet_seals", "targetname" );
	foreach( seal in a_learjet_rpg_seals )
	{
		//seal.perfectaim = 1;
		seal.script_accuracy = 0.8;
		seal thread stack_up_and_delete( nd_delete_learjet_seals );
	}
	
	wait 3;

	foreach( seal in a_learjet_rpg_seals )
	{
		seal.ignoreme = 1;
	}
}

// self == a learjet intro ai that is going to retreat
learjet_intro_ai_retreat()
{
	self endon( "death" );
	
	trigger_wait( "learjet_intro_retreat" );
	
	nd_retreat = GetNode( "learjet_intro_retreat_node", "targetname" );
	self SetGoalNode( nd_retreat );
	
	self disable_tactical_walk();
	
	self waittill( "goal" );
	
	self.goalradius = 2048;
}

init_learjet_rpg_seals()
{
	self endon( "death" );
	
	self.script_accuracy = 0.7;
	self.goalradius = 64;
	self magic_bullet_shield();
}

//rpg_seal_backup()
//{
//	ai_learjet_rpg_seal_2 = simple_spawn_single( "learjet_rpg_seal_2" );
//	
//	ai_learjet_rpg_seal_2 magic_bullet_shield();
//	ai_learjet_rpg_seal_2 set_ignoreme( true );
//	ai_learjet_rpg_seal_2.goalradius = 32;
//	
//	nd_seal_2 = GetNode( "nd_seal_2", "targetname" );
//	ai_learjet_rpg_seal_2 SetGoalNode( nd_seal_2 );
//	ai_learjet_rpg_seal_2 waittill( "goal" );
//	
//	flag_wait( "seal_rpgs_done" );
//	
//	nd_delete_learjet_seals = GetNode( "nd_delete_learjet_seals", "targetname" );
//	ai_learjet_rpg_seal_2 SetGoalPos( nd_delete_learjet_seals.origin );
//	ai_learjet_rpg_seal_2 waittill( "goal" );
//	ai_learjet_rpg_seal_2 Delete();	
//}

learjet_pdf_death_count()
{
	level endon( "learjet_destroyed" );
	
	waittill_ai_group_ai_count( "learjet_pdf", 2 );
	
	flag_set( "seals_destroy_learjet" );	
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

//		IPrintLn( "player/mason threat level as seals" );
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
	wait 15;

	if ( level.player HasPerk( "specialty_trespasser" ) )  //allow time for player to complete perk before spawning next event
	{
		if ( flag( "lock_breaker_started" ) )
		{
			flag_wait_or_timeout( "hangar_doors_closing", 20 );
		}
	}
	
	flag_set( "remove_hangar_god_mode" );	
	flag_set( "spawn_pdf_assaulters" );
}


hangar_rpg_guy()
{
	self endon( "death" );
	
	trigger_wait( "trigger_hangar_rpg2" );
	
	nd_rpg = GetNode( "node_rpg", "targetname" );
	
	self thread force_goal( nd_rpg, 64, false );
}


intro_truck_behaviour()
{
	self endon( "death" );
	
	self waittill( "reached_end_node" );
	
	switch( self.script_noteworthy )
	{
		case "intro_civ_truck_transport":
			a_intro_civ_truck_guys = GetEntArray( "intro_civ_truck_guys", "script_noteworthy" );		
			break;
		case "intro_civ_truck_turret":
			a_intro_civ_truck_guys = GetEntArray( "intro_civ_truck_turret_guys", "script_noteworthy" );		
			break;
	}
	
	foreach( civ in a_intro_civ_truck_guys )
	{
		if ( IsDefined( civ ) )
		{
			civ Delete();
		}
	}
	
	self Delete();	
}


parking_lot_exit()
{
	trigger_wait( "trig_color_parking_end" );
	
	flag_set( "parking_lot_laststand" );
	
	wait 1.5;
	
	level thread littlebird_parking_lot();
}


kill_all_parkinglot()
{
	trigger_wait( "trig_fxanim_building_rubble" );
	
	wait 2;
	
	a_ai_guys = GetAIArray( "axis" );
		
	foreach( ai_guy in a_ai_guys )
	{
		if ( IsDefined( ai_guy ) )
		{
			ai_guy die();
		}
	}
}


littlebird_parking_lot()
{
	s_spawnpt = getstruct( "littlebird_parkinglot_spawnpt", "targetname" );
	
	vh_littlebird1 = spawn_vehicle_from_targetname( "us_littlebird" );
	vh_littlebird1.origin = s_spawnpt.origin;
	vh_littlebird1.angles = s_spawnpt.angles;
	vh_littlebird1 thread littlebird_fireat_truck();
	
	wait 2;
	
	s_spawnpt2 = getstruct( "littlebird2_parkinglot_spawnpt", "targetname" );
	
	vh_littlebird2 = spawn_vehicle_from_targetname( "us_littlebird" );
	vh_littlebird2.origin = s_spawnpt2.origin;
	vh_littlebird2.angles = s_spawnpt2.angles;
	
	vh_littlebird2 thread littlebird_strafe_parkinglot();
}


littlebird_fireat_truck()
{
	self endon( "death" );
	
	s_goal1 = getstruct( "littlebird_parkinglot_goal1", "targetname" );
	s_goal2 = getstruct( "littlebird_parkinglot_goal2", "targetname" );
	s_goal3 = getstruct( "littlebird_parkinglot_goal3", "targetname" );
	s_goal4 = getstruct( "littlebird_parkinglot_goal4", "targetname" );
	s_goal5 = getstruct( "littlebird_parkinglot_goal5", "targetname" );
	s_goal6 = getstruct( "littlebird_parkinglot_goal6", "targetname" );
	
	self veh_magic_bullet_shield( true );
	self SetNearGoalNotifyDist( 300 );
	self SetSpeed( 30, 20, 10 );
	
	self SetVehGoalPos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	vh_truck = GetEnt( "parking_lot_backup_truck", "targetname" );
	
	if ( IsDefined( vh_truck ) )
	{
		self thread shoot_turret_at_target( vh_truck, -1, undefined, 1 );
		self thread shoot_turret_at_target( vh_truck, -1, undefined, 2 );
	}
	
	else
	{
		self thread fire_turret_for_time( 6.0, 1 );
		self thread fire_turret_for_time( 6.0, 2 );
	}
	
	self thread littlebird_kill_troops();
	
	self SetVehGoalPos( s_goal3.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	if ( IsDefined( vh_truck ) )
	{
		RadiusDamage( vh_truck.origin, 300, 2000, 1800 );
	}
	
	self SetSpeed( 60, 30, 20 );
	
	self stop_turret( 1 );
	self stop_turret( 2 );
	
	self thread fire_turret_for_time( 6.0, 1 );
	self thread fire_turret_for_time( 6.0, 2 );
	
	self SetVehGoalPos( s_goal4.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self stop_turret( 1 );
	self stop_turret( 2 );
	
	self SetSpeed( 105, 30, 20 );
	
	self SetVehGoalPos( s_goal5.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal6.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	VEHICLE_DELETE( self );
}


littlebird_strafe_parkinglot()
{
	self endon( "death" );
	
	s_goal1 = getstruct( "littlebird2_parkinglot_goal1", "targetname" );
	s_goal2 = getstruct( "littlebird2_parkinglot_goal2", "targetname" );
	s_goal3 = getstruct( "littlebird2_parkinglot_goal3", "targetname" );
	s_goal4 = getstruct( "littlebird2_parkinglot_goal4", "targetname" );
	
	self veh_magic_bullet_shield( true );
	self SetNearGoalNotifyDist( 300 );
	self SetSpeed( 30, 20, 10 );
	
	self SetVehGoalPos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self thread fire_turret_for_time( 6.0, 1 );
	self thread fire_turret_for_time( 6.0, 2 );
	
	self thread littlebird_kill_troops();
	
	self SetVehGoalPos( s_goal2.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetSpeed( 60, 30, 20 );
	
	self SetVehGoalPos( s_goal3.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal4.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	VEHICLE_DELETE( self );
}


littlebird_kill_troops()
{
	self endon( "death" );
	
	while( 1 )
	{
		a_ai_guys = GetAIArray( "axis" );
		
		foreach( ai_guy in a_ai_guys )
		{
			if ( IsDefined( ai_guy ) )
			{
				if ( Distance2DSquared( self.origin, ai_guy.origin ) < ( 1500 * 1500 ) )
				{
					ai_guy die();
				}
			}
		}
		
		wait 0.1;
	}
}


hangar_cessna_flyby()
{
	trigger_wait( "trig_spawn_hangar_cessna" );
	
	cessna_hangar_flyby = spawn_vehicles_from_targetname_and_drive( "cessna_hangar_flyby" );
		
	s_spawnpt = getstruct( "littlebird_cessna_spawnpt", "targetname" );
	
	vh_littlebird1 = spawn_vehicle_from_targetname( "us_littlebird" );
	vh_littlebird1.origin = s_spawnpt.origin;
	vh_littlebird1.angles = s_spawnpt.angles;
	vh_littlebird1 thread littlebird_fireat_cessna( s_spawnpt.origin + (0, 5000, 0 ) );
	
	wait 1.5;
	
	vh_littlebird2 = spawn_vehicle_from_targetname( "us_littlebird" );
	vh_littlebird2.origin = s_spawnpt.origin + ( 300, 0, 150 );
	vh_littlebird2.angles = s_spawnpt.angles;
	vh_littlebird2 thread littlebird_fireat_cessna( s_spawnpt.origin + ( 300, 5000, 150 ) );
}


littlebird_fireat_cessna( v_goal )
{
	self endon( "death" );
	
	self SetNearGoalNotifyDist( 300 );
	self SetSpeed( 65, 30, 20 );
	
	self thread fire_turret_for_time( 5.0, 1 );
	self thread fire_turret_for_time( 5.0, 2 );
	
	self SetVehGoalPos( v_goal, 0 );
	self waittill_any( "goal", "near_goal" );
	
	VEHICLE_DELETE( self );
}


radio_antenna_explosion()
{
	a_antenna_jets = spawn_vehicles_from_targetname_and_drive( "antenna_jets" );
	
	a_antenna_jets[0] PlaySound( "fxa_radar_tower_jets_by" );
	
	nd_radio_antenna_boom = GetVehicleNode( "radio_antenna_boom", "script_noteworthy" );
	nd_radio_antenna_boom waittill( "trigger" );
	
	//fxanim tower is destroyed
	level notify( "fxanim_radar_tower_start" );
}


runway_standoff_main()
{
//	run_scene_first_frame( "ladder_hatch" );
	level thread maps\createart\panama_art::airfield();
	level thread intruder_box();
	
	level thread hangar_cessna_flyby();
	
	level thread runway_seals();
	level thread runway_hangar_mason(); //masons movement until learjet battle
	
	flag_wait( "player_at_standoff" );

	setmusicstate ("PANAMA_AT_HANGAR");
	
	autosave_by_name( "standoff_save" );

	level.player thread monitor_player_runway_fire();
	level thread runway_standoff_timeout();
	
	level.mason.ignoreall = true;
	level.mason.ignoreme = true;
	
	level.player.ignoreme = true;

	flag_wait( "player_on_roof" ); //set by trigger
	
	//cleanup in parking lot
//	end_scene( "unloading_gaz66_truck_loop" );	
	
	//level thread run_scene( "ladder_hatch" );
	//run_scene( "player_opens_hatch" );

	//level thread hatch_fail();
	
	//level.player thread take_and_giveback_weapons( "rooftop_guy_killed" );
	
	//give player unlimited ammo
	//SetDvar( "UnlimitedAmmoOff", "0" );
		
	//level.player hide_hud();
		
	//level.player SetStance( "stand" );
	//level.player AllowCrouch( false );
	//level.player AllowJump( false );
	//level.player AllowProne( false );
	//level.player AllowSprint( false );

	//e_player_hatch_spot = Spawn( "script_origin", level.player.origin );
	//e_player_hatch_spot.angles = level.player getplayerangles();
	//e_player_hatch_spot SetModel( "tag_origin" );
	//level.player PlayerLinkToDelta( e_player_hatch_spot, "tag_origin", 1, 40, 40, 40, 40, false );

	//give colt
	//level.player GiveWeapon( "m1911_sp" );
	//level.player SwitchToWeapon( "m1911_sp" );
	
	//waittill_ai_group_cleared( "top_ladder_pdf" );
	
	//wait( 1 );
	
	flag_set( "rooftop_guy_killed" );

	//level.player Unlink();
	
	//level.player AllowCrouch( true );
	//level.player AllowJump( true );
	//level.player AllowProne( true );
	//level.player AllowSprint( true );

	//turn off unlimited ammo
	//SetDvar( "UnlimitedAmmoOff", "1" );

	//level.player show_hud();
	
	//run_scene( "player_exits_hatch" );
	//level.player TakeWeapon( "m1911_sp" );
	//level.player notify( "rooftop_guy_killed" );	
	
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
	level thread hangar_rpg();
	
	simple_spawn( "hangar_pdf_shotgun", ::shotgun_guy_logic );
}


shotgun_guy_logic()
{
	self endon( "death" );
	
	self.targetname = "shotgun_ai";
	
	flag_wait( "mason_jumped_down" );
	
	self SetGoalEntity( level.mason );
	
	self thread force_goal( undefined, 100, false );
}


hangar_rpg()
{
	trigger_wait( "trigger_hangar_rpg" );
	
	flag_set( "remove_hangar_god_mode" );	
	
	s_fire1 = getstruct( "hangar_rpg_fire", "targetname" );
	s_target1 = getstruct( "hangar_rpg_target", "targetname" );
		
	MagicBullet( "rpg_magic_bullet_sp", s_fire1.origin, s_target1.origin );
}


//hide_player_hud()
//{
//	SetSavedDvar( "hud_showStance", "0" );
//	SetSavedDvar( "compass", "0" );
//	SetDvar( "old_compass", "0" );
//	SetSavedDvar( "ammoCounterHide", "1" );
//	SetSavedDvar( "cg_drawCrosshair", 0 );
//}
//
//show_player_hud()
//{
//	SetSavedDvar( "hud_showStance", "1" );
//	SetSavedDvar( "compass", "1" );
//	SetDvar( "old_compass", "1" );
//	SetSavedDvar( "ammoCounterHide", "0" );
//	SetSavedDvar( "cg_drawCrosshair", 1 );
//}

//hatch_fail()
//{
//	level endon( "rooftop_guy_killed" );
//
//	wait 5;
//
//	flag_set( "start_pdf_ladder_reaction" );
//	
//	wait 5;
//		
//	level.player Suicide();
//}

setup_runway_cessnas()
{
	self endon( "death" );
	
	self.do_scripted_crash = false;
	
	self veh_toggle_tread_fx( false );
	
	//flag_wait( "runway_standoff_goes_hot" );
	
	wait( RandomFloatRange( 1, 5 ) );
	
	self SetModel( "veh_t6_air_small_plane_dead" );
	
	self notify( "death" );
}

runway_seals()
{
	flag_wait( "setup_runway_standoff" );
	
	level thread spawn_airfield_littlebirds();
	
	//IPrintLnBold( "Skinner: The SEALs are walking into an ambush" );
	//IPrintLnBold( "Mason: Let's move. Hurry!" );
	
	a_runway_cessnas = spawn_vehicles_from_targetname( "runway_cessnas" );	
	foreach( cessna in a_runway_cessnas )
	{
		cessna thread setup_runway_cessnas();
	}
	
	a_runway_hangar_cessna = spawn_vehicles_from_targetname( "runway_hangar_cessna" );
	foreach( cessna in a_runway_hangar_cessna )
	{
		cessna veh_toggle_tread_fx( false );
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
	
	//level thread ladder_hatch_pdf();
	//level thread runway_standoff_fail_timeout();

	simple_spawn( "rooftop_pdf" );
	
	wait 0.1;
	
	simple_spawn( "rooftop_pdf_sniper_victim", ::sniper_victim );
	
	wait 0.1;
	
	simple_spawn( "rooftop_pdf_engager" );
	
	wait 0.1;
	
	simple_spawn( "rooftop_pdf_slider1" );
	
	wait 0.1;
	
	simple_spawn( "rooftop_pdf_slider2" );
		
//	level thread rescue_1();
//	level thread rescue_2();
//	level thread rescue_3( ai_seal_standoff_5 );
	
	standoff_seals = get_ai_group_ai( "standoff_seals" );	
	foreach( seal in standoff_seals )
	{
		seal thread kill_off_standoff_seals();
	}
}


spawn_airfield_littlebirds()
{
	s_spawnpt = getstruct( "littlebird_airfield_spawnpt", "targetname" );
	
	vh_littlebird1 = spawn_vehicle_from_targetname( "us_littlebird" );
	vh_littlebird1.v_offset = ( 0, 0, 0 );
	vh_littlebird1.origin = s_spawnpt.origin + ( vh_littlebird1.v_offset );
	vh_littlebird1.angles = s_spawnpt.angles;
	vh_littlebird1.targetname = "littlebird_airfield_1";
	vh_littlebird1 thread airfield_littlebird_logic( vh_littlebird1.v_offset );
	
	vh_littlebird2 = spawn_vehicle_from_targetname( "us_littlebird" );
	vh_littlebird2.v_offset = ( 500, -200, 0 );
	vh_littlebird2.origin = s_spawnpt.origin + ( vh_littlebird2.v_offset );
	vh_littlebird2.angles = s_spawnpt.angles;
	vh_littlebird2.targetname = "littlebird_airfield_2";
	vh_littlebird2 thread airfield_littlebird_logic( vh_littlebird2.v_offset );
	
	vh_littlebird3 = spawn_vehicle_from_targetname( "us_littlebird" );
	vh_littlebird3.v_offset = ( 100, 500, 0 );
	vh_littlebird3.origin = s_spawnpt.origin + ( vh_littlebird3.v_offset );
	vh_littlebird3.angles = s_spawnpt.angles;
	vh_littlebird3.targetname = "littlebird_airfield_3";
	vh_littlebird3 thread airfield_littlebird_logic( vh_littlebird3.v_offset );
	
	vh_littlebird4 = spawn_vehicle_from_targetname( "us_littlebird" );
	vh_littlebird4.v_offset = ( 750, 500, 0 );
	vh_littlebird4.origin = s_spawnpt.origin + ( vh_littlebird4.v_offset );
	vh_littlebird4.angles = s_spawnpt.angles;
	vh_littlebird4.targetname = "littlebird_airfield_4";
	vh_littlebird4 thread airfield_littlebird_logic( vh_littlebird4.v_offset );
}


airfield_littlebird_logic( v_offset )
{
	self endon( "death" );
	
	s_goal1 = getstruct( "littlebird_airfield_goal1", "targetname" );
	s_goal2 = getstruct( "littlebird_airfield_goal2", "targetname" );
	s_goal3 = getstruct( "littlebird_airfield_goal3", "targetname" );
	s_goal4 = getstruct( "littlebird_airfield_goal4", "targetname" );
	
	self SetNearGoalNotifyDist( 300 );
	
	self SetSpeed( 25, 20, 15 );
	
	flag_wait( "seal_encounter_mason_started" );
	
	if ( self.targetname == "littlebird_airfield_1" )
	{
		wait 1;
	}
	
	else if ( self.targetname == "littlebird_airfield_2" )
	{
		wait 2;
	}
	
	else if ( self.targetname == "littlebird_airfield_3" )
	{
		wait 2.6;
	}
	
	else
	{
		wait 3.7;
	}
	
	self SetVehGoalPos( s_goal1.origin + v_offset, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal2.origin + v_offset, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetSpeed( 65, 30, 25 );
	
	self SetVehGoalPos( s_goal3.origin + v_offset, 0 );
	self waittill_any( "goal", "near_goal" );
	
	self SetVehGoalPos( s_goal4.origin + v_offset, 0 );
	self waittill_any( "goal", "near_goal" );
	
	VEHICLE_DELETE( self );
}


jets_flyby_hangar_stairs()
{
	flag_wait( "ladder_breadcrumb_1" );
	
	s_spawnpt = getstruct( "phantom_hangar_stair_spawnpt", "targetname" );
	
	for( i = 0; i < 5; i++ )
	{
		vh_phantom1 = spawn_vehicle_from_targetname( "us_phantom" );
		vh_phantom1.origin = s_spawnpt.origin;
		vh_phantom1.angles = s_spawnpt.angles;
		vh_phantom1 thread phantom_hangar_stair_logic();
		
		wait RandomFloatRange( 0.5, 1.0 );
	}
}


phantom_hangar_stair_logic()
{
	self endon( "death" );
	
	s_goal1 = getstruct( "phantom_hangar_stair_goal1", "targetname" );
		
	self SetNearGoalNotifyDist( 300 );
	
	self SetSpeed( 450, 400, 385 );
	
	self SetVehGoalPos( s_goal1.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	VEHICLE_DELETE( self );
}


phantom_rooftop_entrance()
{
	flag_wait( "rooftop_approach" );
	
	s_spawnpt = getstruct( "phantom_rooftop_entrance_spawnpt", "targetname" );
	
	v_offset = ( 0, 0, 0 );
	
	for( i = 0; i < 2; i++ )
	{
		vh_phantom = spawn_vehicle_from_targetname( "us_phantom" );
		vh_phantom.origin = s_spawnpt.origin + v_offset;
		vh_phantom.angles = s_spawnpt.angles;
		vh_phantom SetSpeed( 400, 250, 200 );
		vh_phantom thread ambient_aircraft_flightpath( s_spawnpt );
		v_offset = ( -200, 0, 150 );
		
		wait 0.5;
	}
}


ambient_aircraft_flightpath( s_start )
{
	self endon( "death" );
	
	self SetNearGoalNotifyDist( 1000 );
	self SetForceNoCull();
		
	s_goal = s_start;
	
	while( 1 )
	{
		self setvehgoalpos( s_goal.origin );
		self waittill_any( "goal", "near_goal" );
		
		if ( IsDefined( s_goal.target ) )
		{
			s_goal = getstruct( s_goal.target, "targetname" );
		}
		
		else
		{
			break;	
		}
	}
	
	VEHICLE_DELETE( self );
}


ambient_phantoms()
{
	level endon( "player_in_hangar" );
	
	wait 5;
	
	while( 1 )
	{
		a_s_spawnpts = getstructarray( "phantom_rooftop_spawnpt", "targetname" );
		
		s_spawnpt = a_s_spawnpts[ RandomInt( a_s_spawnpts.size ) ];
		
		for ( i = 0; i < RandomIntRange( 1, 5 ); i++ )
		{
			vh_phantom1 = spawn_vehicle_from_targetname( "us_phantom" );
			v_offset = ( RandomIntRange( -300, 300 ), RandomIntRange( -300, 300 ), RandomIntRange( -200, 200 ) );
			vh_phantom1.origin = s_spawnpt.origin + v_offset;
			vh_phantom1.angles = s_spawnpt.angles;
			vh_phantom1 thread phantom_rooftop_logic( s_spawnpt );
			
			wait RandomFloatRange( 0.5, 1.5 );
		}
			
		wait RandomFloatRange( 3.5, 5.0 );
	}
}


phantom_rooftop_logic( s_spawnpt )
{
	self endon( "death" );
	
	s_goal = getstruct( s_spawnpt.target, "targetname" );
		
	self SetNearGoalNotifyDist( 300 );
	self SetForceNoCull();
	self NotSolid();
	
	self SetSpeed( RandomIntRange( 300, 500 ), 250, 185 );
	
	self SetVehGoalPos( s_goal.origin, 0 );
	self waittill_any( "goal", "near_goal" );
	
	VEHICLE_DELETE( self );
}


ambient_littlebirds()
{
	level endon( "player_in_hangar" );
	
	wait 3;
	
	while( 1 )
	{
		a_s_spawnpts = getstructarray( "littlebird_rooftop_spawnpt", "targetname" );
			
		s_spawnpt = a_s_spawnpts[ RandomInt( a_s_spawnpts.size ) ];
			
		vh_littlebird = spawn_vehicle_from_targetname( "us_littlebird" );
		v_offset = ( RandomIntRange( -300, 300 ), RandomIntRange( -300, 300 ), RandomIntRange( -200, 200 ) );
		vh_littlebird.origin = s_spawnpt.origin + v_offset;
		vh_littlebird.angles = s_spawnpt.angles;
		vh_littlebird thread littlebird_circle( s_spawnpt );
		
		wait RandomFloatRange( 8.5, 10 );
	}
}


littlebird_circle( s_start )
{
	self endon( "death" );
	
	self SetNearGoalNotifyDist( 300 );
	self SetForceNoCull();
	self SetSpeed( 100, 25, 20 );
	
	self thread littlebird_fire_indiscriminately();
	
	s_goal = s_start;
	
	while( 1 )
	{
		self setvehgoalpos( s_goal.origin );
		self waittill_any( "goal", "near_goal" );
		
		if ( flag( "player_in_hangar" ) )
		{
			VEHICLE_DELETE( self );
		}
		
		if ( IsDefined( s_goal.target ) )
		{
			s_goal = getstruct( s_goal.target, "targetname" );
		}
		
		else
		{
			break;	
		}
	}
	
	VEHICLE_DELETE( self );
}


littlebird_fire_indiscriminately()
{
	self endon( "death" );
	
	while( 1 )
	{
		self thread littlebird_fire( 0, 5.0 );
		
		wait RandomFloatRange( 5.5, 7.0 );
	}
}


sniper_victim()
{
	self endon( "death" );
	
	self AllowedStances( "stand" );
}

//ladder_hatch_pdf()
//{
//	ai_top_ladder_pdf = simple_spawn_single( "top_ladder_pdf", ::init_top_ladder_pdf );
//	
//	level thread run_scene( "pdf_ladder_loop" );
//	
//	flag_wait( "start_pdf_ladder_reaction" );
//	
//	run_scene( "pdf_ladder_reaction" );		
//}

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

//init_top_ladder_pdf()
//{
//	self endon( "death" );
//	
//	self.perfectAim = true;	
//	self.ignoreme = true;
//	self.goalradius = 16;	
//}

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
	
	level thread vo_seals_runway();
	level thread vo_seals_under_fire();

	//TODO:default run
//	level.mason change_movemode( "sprint" );
	
	run_scene_first_frame( "hangar_door" );
	
	level thread jets_flyby_hangar_stairs();
	
	level thread run_scene( "seal_encounter_mason" );
	
	flag_wait( "seal_encounter_mason_started" );
	
	level thread run_scene( "seal_encounter_gate" );
	level thread run_scene( "seal_encounter_seals" );
	
	level thread vo_rooftop_approach();
	
	scene_wait( "seal_encounter_mason" );
		
	open_ladder_door();
	setmusicstate ("PANAMA_ROOFTOPS");
		
//	run_scene( "mason_standoff_arrival" );
//	
//	if ( !flag( "player_at_hatch" ) )
//	{
//		level thread run_scene( "mason_standoff_loop" );
//	} 
	
//	flag_wait( "rooftop_guy_killed" );
	
//	run_scene( "mason_standoff_exit" );
	
	level.mason change_movemode( "run" );
	
	nd_mason_stairs = GetNode( "nd_mason_stairs", "targetname" );
	level.mason SetGoalNode( nd_mason_stairs );
	
	flag_wait( "player_on_roof" ); //trigger sets this flag
	
	level thread vo_rooftop_battle();
	level thread vo_skylight();
	level thread phantom_rooftop_entrance();
	level thread ambient_phantoms();
	level thread ambient_littlebirds();
	level thread spawn_rooftop();
	level thread sniper_logic();
	//level thread rooftop_tracers();
	
	nd_mason_roof = GetNode( "nd_mason_roof", "targetname" );
	level.mason SetGoalNode( nd_mason_roof );
	
	waittill_ai_group_ai_count( "rooftop_pdf", 1 );
	
	level thread radio_antenna_explosion();
		
	level thread hangar_pdf_seals();
		
	run_scene( "mason_skylight_approach" );
	level thread run_scene( "mason_skylight_loop" );
	
	//level thread rooftop_fail_timeout();
	
	flag_wait( "player_near_skylight" );
	
	level thread hangar_doors_open();
	
	delay_thread( 2.75, ::open_skylight );
	
	run_scene( "mason_skylight_jump_in" );
	
	nd_mason_catwalk = GetNode( "nd_mason_catwalk", "targetname" );
	level.mason thread force_goal( nd_mason_catwalk, 64, true, undefined, true );
	
	flag_wait( "player_in_hangar" ); //trigger sets this flag
	
	level thread vo_hangar_battle();
	level thread player_rumbles();
	
	wait 8;
	
	ai_shotgun = GetEnt( "shotgun_ai", "targetname" );
	
	nd_mason_hangar = GetNode( "nd_mason_hangar", "targetname");
	
	if ( IsDefined( ai_shotgun ) )
	{
		level.mason SetGoalEntity( ai_shotgun );
		level.mason thread force_goal( undefined, 100, false, undefined, true );
		
		while( IsAlive( ai_shotgun ) )
		{
			wait 0.5;	
		}
		
		level.mason thread force_goal( nd_mason_hangar, 64, true, undefined, true );
	}
	
	else
	{
		level.mason thread force_goal( nd_mason_hangar, 64, true, undefined, true );
	}
	
	flag_wait( "mason_jumped_down" );  //trigger sets this flag
	
	level thread pdf_death_count_timeout();
	
	flag_wait( "spawn_pdf_assaulters" );
	
	level thread vo_upper_hangar_battle();
	
	wait 2;
	
	level.mason set_ignoreall( true );
	level.mason set_ignoreme( true );
	level.mason.ignoresuppression = 1;
	
	level thread mason_door_kick();
	
	run_scene( "mason_hangar_door_kick" );
	
	simple_spawn( "pdf_hangar_assaulters2" );
	
	autosave_by_name( "hangar_door_kick" );	
	
	level.mason set_ignoreall( false );
	level.mason set_ignoreme( false );
	level.mason.ignoresuppression = 0;
		
	nd_mason_post_hangar_door = GetNode( "nd_mason_post_hangar_door", "targetname" );
	level.mason thread force_goal( nd_mason_post_hangar_door, 64, true, undefined, true );
	
//	simple_spawn( "foreshadow_seals_group_1", ::init_foreshadow_seals );

	waittill_ai_group_cleared( "pdf_hangar_assaulters" );
	
	trig_color_leer_jet = GetEnt( "trig_color_leer_jet", "targetname" );
	trig_color_leer_jet notify( "trigger" );		
}


player_rumbles()
{
	wait 0.2;
	
	level.player PlayRumbleOnEntity( "damage_light" );
		
	Earthquake( 0.3, 1, level.player.origin, 100 );
	
	trigger_wait( "player_jumped_rafters" );
	
	level.player PlayRumbleOnEntity( "damage_light" );
		
	Earthquake( 0.3, 1, level.player.origin, 100 );
}


vo_seals_runway()
{
	level endon( "runway_standoff_goes_hot" );
	
	wait 5;
	
	level.ai_pdf = simple_spawn_single( "pdf_talker", ::talker_spawn_func );
	level.ai_seal = simple_spawn_single( "seal_talker", ::talker_spawn_func );
	
	level.ai_seal say_dialog( "reds_you_are_surrounded_b_0", 0 );  //You are surrounded by US forces - Throw down your weapons.
	level.ai_pdf say_dialog( "pdf_you_have_no_authorit_0", 1 );  //You have no authority here, American!
	level.ai_seal say_dialog( "reds_this_is_your_last_ch_0",  1 );  //This is your last chance to surrender or we will use deadly force!
	level.ai_pdf say_dialog( "pdf_no_it_s_your_last_0", 1 );  //No.  It's your last chance, drop your weapons!
}


vo_seals_under_fire()
{
	flag_wait( "runway_standoff_goes_hot" );
	
	level.ai_seal say_dialog( "reds_return_fire_0", 1.5 );  //Return fire!
	level.ai_seal say_dialog( "reds_find_cover_0", 1 );  //Find cover!
	level.ai_pdf say_dialog( "pdf_don_t_let_them_get_o_0", 1 );  //Don't let them get off the runway!
	
	flag_set( "runway_vo_done" );
}


talker_spawn_func()
{
	self endon( "death" );
	
	self SetCanDamage( false );
	self set_ignoreall( true );
	self set_ignoreme( true );
	
	flag_wait( "runway_vo_done" );
	
	self Delete();
}


vo_rooftop_approach()
{
	level endon( "player_on_roof" );
	
	wait 18;
	
	level.mason say_dialog( "maso_we_need_the_high_gro_0", 0 ); //We need the high ground...
		
	scene_wait( "seal_encounter_mason" );
	
	level.mason say_dialog( "maso_golf_team_this_is_0", 1 );  //Golf Team.  This is Mason, ready to assist, request cease fire as we clear the roof top.
	level.mason say_dialog( "maso_damn_still_problem_0", 1 ); //Damn.  Comms are still fucked.
	level.mason say_dialog( "maso_come_on_woods_we_0", 0.5 );  //Come on, Woods - We go anyway.
}


vo_sniper_kill()
{
	level.mason say_dialog( "mckn_i_got_you_covered_0", 1 );  //I got you covered!
}


vo_rooftop_battle()
{
	level endon( "player_in_hangar" );
	
	//level.mason say_dialog( "maso_they_don_t_see_us_ye_0", 0 );  //They don't see us yet, light ‘em up.
	//level.mason say_dialog( "maso_incoming_left_side_0", 1 );  //Incoming - Left side!
	level.mason say_dialog( "mckn_i_got_you_covered_0", 1 );  //I got you covered!
	level.mason say_dialog( "mckn_focus_on_supporting_0", 2 );  //Focus on supporting the Seals.
	//level.mason say_dialog( "maso_pick_it_up_woods_0", 1 );  //Pick it up, Woods.  Gotta help our guys on the runway.
}


//TODO
vo_nag_rooftop_approach()
{
	level.mason say_dialog( "maso_damn_pick_it_up_w_0", 1 ); //Damn!  Pick it up, Woods.	
}


vo_skylight()
{
	waittill_ai_group_cleared( "rooftop_pdf" );
	
	level.mason say_dialog( "maso_golf_team_this_is_m_0", 1 );  //Golf Team, this is Mason in the Blind.  Rooftop is clear, check your fire, we are entering through skylight.	
}


vo_hangar_battle()
{
	level.ai_pdf_hangar = simple_spawn_single( "pdf_talker", ::talker_hangar_spawn_func );
		
	level.mason say_dialog( "maso_check_below_they_r_0", 0.5 );  //Check below - They're using the crates for cover.
	
	level.ai_pdf_hangar say_dialog( "pdf_americans_are_behind_0", 1 );  //Americans are behind us - in the rafters!
	level.ai_pdf_hangar say_dialog( "pdf_they_re_above_us_0", 0.5 );  //They're above us!
	level.ai_pdf_hangar say_dialog( "pdf_they_re_inside_the_h_0", 0.2 );  //They're inside the hangar!
	level.ai_pdf_hangar say_dialog( "pdf_they_re_trying_to_ca_0", 2 );  //They're trying to capture the plane!
	level.ai_pdf_hangar say_dialog( "pdf_stand_your_ground_0", 1 );  //Stand your ground!
}


vo_upper_hangar_battle()
{
	level.ai_seal_hangar = simple_spawn_single( "seal_talker", ::talker_hangar_spawn_func );
	
	level.mason say_dialog( "maso_more_enemy_across_th_0", 1 );  //More enemy across the hangar.
	
	waittill_ai_group_cleared( "pdf_hangar_assaulters" );
	
	level.mason say_dialog( "maso_golf_finish_up_in_t_0", 1 );  //Golf, finish up in the hangar - We are moving on the jet.
	
	level.ai_seal_hangar say_dialog( "reds_roger_that_0", 1 );  //Roger that.
	
	flag_set( "hangar_vo_done" );
}


talker_hangar_spawn_func()
{
	self endon( "death" );
	
	self SetCanDamage( false );
	self set_ignoreall( true );
	self set_ignoreme( true );
	
	flag_wait( "hangar_vo_done" );
	
	self Delete();
}


rooftop_tracers()
{
	a_ai_seals = GetEntArray( "hangar_seals_ai", "targetname" );
	
	foreach( ai_seal in a_ai_seals )
	{
		ai_seal thread fire_at_rooftop();
	}
}


fire_at_rooftop()
{
	self endon( "death" );
	level endon( "rooftop_clear" );
	
	s_m203_start_1 = getstruct( "m203_start_1", "targetname" );
	s_m203_end_1 = getstruct( s_m203_start_1.target, "targetname" );
	
	s_m203_start_2 = getstruct( "m203_start_2", "targetname" );
	s_m203_end_2 = getstruct( s_m203_start_2.target, "targetname" );
	
	while( 1 )
	{
		e_target = spawn( "script_model", s_m203_end_1.origin + ( 0, RandomIntRange( -300, 300 ), 0 ) );
	
		if ( cointoss() )
		{
			e_target = spawn( "script_model", s_m203_end_2.origin + ( 0, RandomIntRange( -300, 300 ), 0 ) );
		}
	
		e_target SetModel( "tag_origin" );
		
		self shoot_at_target( e_target, "tag_origin", 0, RandomIntRange( 4, 7 ) );
		
		wait RandomIntRange( 2, 4 );
		
		e_target Delete();
	}
}


spawn_rooftop()
{
	ai_traversal1 = simple_spawn_single( "rooftop_pdf_traversal", ::rooftop_traversal_logic );
	
	wait 0.5;
	
	simple_spawn( "rooftop_pdf_reinforce", ::rooftop_traversal_logic );
	
	wait 0.25;
	
	flag_set( "rooftop_spawned" );
	
	level thread go_sliders();
	
	flag_wait( "player_near_skylight" );
	
	ai_last = simple_spawn_single( "rooftop_pdf_last", ::rooftop_last_logic );
	
	wait 3;
	
	level thread sniper_shoot( ai_last );
}


go_sliders()
{
	ai_engager = GetEnt( "rooftop_pdf_engager_ai", "targetname" );
	nd_rooftop_pdf_engager = GetNode( "nd_rooftop_pdf_engager", "targetname" );
	if ( IsDefined( ai_engager ) )
	{
		ai_engager thread force_goal( nd_rooftop_pdf_engager, 16 );
	}
	
	ai_slide_guy_1 = GetEnt( "rooftop_pdf_slider1_ai", "targetname" );
	if ( IsDefined( ai_slide_guy_1 ) )
	{
		ai_slide_guy_1.animname = "slide_guy_1";
		
		run_scene( "rooftop_slide_1" );
	}
	
	ai_slide_guy2 = GetEnt( "rooftop_pdf_slider2_ai", "targetname" );
	if ( IsDefined( ai_slide_guy2 ) )
	{
		ai_slide_guy2.animname = "slide_guy_2";
		
		run_scene( "rooftop_slide_2" );
	}		
}


rooftop_last_logic()
{
	self endon( "death" );
	
	self.aggressiveMode= true;
	
	self change_movemode( "sprint" );
	
	self thread force_goal( undefined, 64, false );
}


rooftop_traversal_logic()
{
	self endon( "death" );
	
	self thread force_goal( undefined, 64 );
	
	self.aggressiveMode= true;
}


sniper_logic()
{
	level endon( "player_in_hangar" );
	
	s_sniper = getstruct( "sniper_pos", "targetname" );
	
	wait 0.5;
	
	ai_victim = GetEnt( "rooftop_pdf_sniper_victim_ai", "targetname" );
	
	if ( IsDefined( ai_victim ) )
	{
		level thread sniper_shoot( ai_victim );
		//level thread vo_sniper_kill();
	}
	
	flag_wait( "rooftop_spawned" );
	
	wait 3;
	
	while( 1 )
	{
		a_ai_targets = get_ai_group_ai( "rooftop_pdf" );
		
		PlayFX( level._effect[ "sniper_glint" ], s_sniper.origin );
		
		if ( a_ai_targets.size )
		{
			ai_target = a_ai_targets[ RandomInt( a_ai_targets.size ) ];
			
			if ( IsDefined( ai_target ) )
			{
				level thread sniper_shoot( ai_target );
			}
		}
		
		wait RandomFloatRange( 3.5, 4.5 );
	}
}


sniper_shoot( ai_target )
{
	a_tags = [];
	
	a_tags[ 0 ] = "J_Head";
	a_tags[ 1 ] = "J_SpineUpper";
	a_tags[ 2 ] = "J_Neck";
		
	s_sniper = getstruct( "sniper_pos", "targetname" );
	
	v_target = ai_target GetTagOrigin( a_tags[ RandomInt( a_tags.size ) ] );
						
	e_trail = spawn( "script_model", s_sniper.origin );
	e_trail SetModel( "tag_origin" );
							
	PlayFXOnTag( level._effect[ "sniper_trail" ], e_trail, "tag_origin" );
	
	e_trail MoveTo( v_target, 0.1 );
	
	MagicBullet( "dragunov_sp", s_sniper.origin, v_target );
							
	PlayFX( level._effect[ "sniper_impact" ], v_target );
	
	PlaySoundAtPosition( "evt_sniper_impacts" , v_target );
							
//	if ( IsAlive( ai_target ) )
//	{
//		ai_target Die();
//	}
							
	wait 0.2;
							
	e_trail Delete();	
}

sniper_shot_without_death( ai_target )
{
	s_sniper = getstruct( "sniper_pos", "targetname" );
	
	v_target = ai_target GetTagOrigin( "J_Head" );
						
	e_trail = spawn( "script_model", s_sniper.origin );
	e_trail SetModel( "tag_origin" );
							
	PlayFXOnTag( level._effect[ "sniper_trail" ], e_trail, "tag_origin" );
	
	e_trail MoveTo( v_target, 0.1 );

	PlayFX( level._effect[ "sniper_impact" ], v_target );
	
	PlaySoundAtPosition( "evt_sniper_impacts" , v_target );
							
	wait 0.2;
							
	e_trail Delete();	
}

shoot_pool_guy_1( ai_pool_1 )
{
	flag_set( "mcknight_sniping" );
	
	sniper_shot_without_death( ai_pool_1 );
	
	flag_clear( "mcknight_sniping" );
}

shoot_pool_guy_2( ai_pool_2 )
{
	flag_set( "mcknight_sniping" );
	
	sniper_shot_without_death( ai_pool_2 );
	
	flag_clear( "mcknight_sniping" );
}

mason_door_kick()
{
	flag_wait( "mason_hangar_door_kick_started" );
	
	simple_spawn( "hangar_door_victim", ::door_guy_logic );
	
	level thread run_scene( "hangar_door" );
	
	//SOUND - Shawn J
	PlaySoundAtPosition ( "evt_door_kick_2", ( -22845, -4031, 388 ) );
	
	wait 2;
	
	s_fire2 = getstruct( "hangar_rpg_fire2", "targetname" );
	s_target2 = getstruct( "hangar_rpg_target2", "targetname" );
	
	MagicBullet( "rpg_magic_bullet_sp", s_fire2.origin, s_target2.origin );
	
	simple_spawn( "pdf_hangar_rpg", ::hangar_rpg_guy );
}


#using_animtree( "generic_human" );
door_guy_logic()
{
	self endon( "death" );
	
	self.deathanim = %ai_death_flyback_far;
	
	self set_fixednode( true );
	self set_ignoreall( true );
	self set_ignoreme( true );
	
	wait 1.85;
	
	self DoDamage( 200, self.origin );
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
	m_door_clip = GetEnt( "skylight_door_clip", "targetname" );
	m_door_clip RotatePitch( 32, 1 );
}	

open_ladder_door()
{
	//player clip brush
	m_roofstairs_clip = GetEnt( "m_roofstairs_clip", "targetname" );
	m_roofstairs_clip Delete();
	
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
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, getstruct( "ladder_breadcrumb_3" ), "use" );
	
//	level.mason thread say_dialog( "up_the_ladder_woo_010" ); //Up the ladder, Woods.
	
	flag_wait( "player_at_hatch" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "remove" );

	waittill_ai_group_cleared( "rooftop_pdf" );
	
	flag_set( "rooftop_clear" );

	//skylight
//	level.mason thread say_dialog( "through_the_skylig_011" ); //Through the skylight - go.
	
	//turn on mason's follow
	set_objective( level.OBJ_CAPTURE_NORIEGA , level.mason, "follow" );	
}

// self == player
monitor_player_runway_fire()
{
	level endon( "runway_standoff_goes_hot" );
	self endon( "death" );
	
	flag_wait( "player_at_standoff" );
	
	self waittill_any( "weapon_fired", "grenade_fire" );
	flag_set( "runway_standoff_goes_hot" );
	//IPrintLn( "runway gone hot!" );
}

runway_standoff_timeout()
{
	level endon( "runway_standoff_goes_hot" );
	
	flag_wait( "seal_encounter_mason_started" );
	
	wait 16;
	
//	/#
//	IPrintLn( "standoff timeout hit" );
//	#/

	flag_set( "runway_standoff_goes_hot" );
}

set_flag_when_cleared( ai_group, str_flag )
{
	waittill_ai_group_cleared( ai_group );
	flag_set( str_flag );
}

//init_first_blood_guys()
//{
//	self endon( "death" );
//	
//	self.ignoreme = true;
//	self set_ignoreall( true );
//	
//	flag_wait( "parking_lot_gone_hot" );
//	
//	self set_ignoreall( false );
//	self.ignoreme = false;
//	self.goalradius = 256;
//}

hangar_pdf_seals()
{
	//spawning too early, wait until roof hatch open
	//flag_wait( "runway_standoff_goes_hot" );
		
	level thread handle_pdf_hangar_movement();
	

	
	spawn_manager_enable( "trig_sm_hangar_pdf" );
	spawn_manager_enable( "trig_sm_runway_seals" );	
	
	level.player SetThreatBiasGroup( "hangar_player" );	
	level.mason SetThreatBiasGroup( "hangar_mason" );
	
	SetThreatBias( "hangar_seals", "hangar_pdf", 5000 );

	SetThreatBias( "hangar_player", "hangar_pdf", 100 );
	SetThreatBias( "hangar_mason", "hangar_pdf", 100 );
	
	flag_wait( "spawn_pdf_assaulters" );

	spawn_manager_kill( "trig_sm_hangar_pdf" );
	spawn_manager_disable( "trig_sm_runway_seals" );
	
	simple_spawn( "pdf_hangar_assaulters" );
	
	SetIgnoreMeGroup( "hangar_seals", "pdf_assaulters" );
	SetIgnoreMeGroup( "hangar_mason", "hangar_pdf" );
	
	SetThreatBias( "hangar_player", "pdf_assaulters", 5000 );
	SetThreatBias( "hangar_mason", "pdf_assaulters", 5000 );
		
	level thread monitor_pdf_assaulters();

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


handle_pdf_hangar_movement()
{
	trigger_use( "triggercolor_pdf_hangar_advance" );
	
	flag_wait( "player_in_hangar" );
	
	flag_wait_or_timeout( "mason_jumped_down", 10 );
	
	level thread seal_hangar_entry();
	
	trigger_use( "triggercolor_pdf_hangar_retreat" );
	
	a_ai_guys = get_ai_group_ai( "hangar_pdf" );
	
	foreach( ai_guy in a_ai_guys )
	{
		ai_guy thread force_goal( undefined, 64, true, undefined, true );
	}
}


seal_hangar_entry()
{
	trigger_use( "triggercolor_seal_hangar_advance" );
	
	seal_group_1 = simple_spawn( "seal_group_1" );
		
	level thread run_scene( "seal_group_1_hangar_entry" );
	
	wait 0.1;
	
	seal_group_2 = simple_spawn( "seal_group_2" );
	
	run_scene( "seal_group_2_hangar_entry" );
}


monitor_pdf_assaulters()
{
	waittill_ai_group_count( "pdf_hangar_assaulters", 2 );
	
	a_ai_guys = get_ai_group_ai( "pdf_hangar_assaulters" );
	
	foreach( ai_guy in a_ai_guys )
	{
		ai_guy.goalradius = 1024;
		ai_guy.aggressiveMode= true;
	}
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
	//self set_ignoreall( true );
	
	self SetGoalPos( nd_delete.origin );
	self waittill( "goal" );
	self Delete();
}

hangar_intruder_specialty()
{
//	if ( !level.player HasPerk( "specialty_intruder" ) )
//	{
//		trig_control_room_specialty = GetEnt( "trig_control_room_specialty", "targetname" );
//		trig_control_room_specialty Delete();	
//		
//		return;
//	}
	
	level.player waittill_player_has_lock_breaker_perk();
	
	run_scene_first_frame( "lock_breaker_door" );
	
	s_intruder_obj = getstruct( "s_intruder_obj", "targetname" );
	set_objective( level.OBJ_INTERACT, s_intruder_obj.origin, "interact" );

	trig_control_room_specialty = GetEnt( "trig_control_room_specialty", "targetname" );
	trig_control_room_specialty SetHintString( &"PANAMA_BREAK_LOCK" );
	trig_control_room_specialty SetCursorHint( "HINT_NOICON" );
	trig_control_room_specialty waittill( "trigger" );
	trig_control_room_specialty Delete();

	set_objective( level.OBJ_INTERACT, undefined, "done" );	
	set_objective( level.OBJ_INTERACT, undefined, "delete" );
	
	m_lock_breaker_door_clip = GetEnt( "lock_breaker_door_clip", "targetname" );
	m_lock_breaker_door_clip Delete();
	
	level.player say_dialog( "wood_on_it_0" );	//On it.

	run_scene( "lock_breaker" );
	
	control_room_door = GetEnt( "control_room_door", "targetname" );
	control_room_door RotateYaw( -120, 0.5, 0.3, 0 );
	
	trig_use_door_lever = GetEnt( "trig_use_door_lever", "targetname" );
	trig_use_door_lever SetHintString( &"PANAMA_CLOSE_HANGAR_DOORS" );
	trig_use_door_lever SetCursorHint( "HINT_NOICON" );	
	trig_use_door_lever waittill( "trigger" );
	trig_use_door_lever Delete();
	
	run_scene( "pull_the_lever" );

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


hangar_doors_open()
{
	m_hangar_door_left = GetEnt( "hangar_door_left", "targetname" );
	m_hangar_door_right = GetEnt( "hangar_door_right", "targetname" );
	
	m_hangar_door_left MoveY( -135, 0.1 );
	m_hangar_door_right MoveY( 135, 0.1 );
	
	m_hangar_door_left ConnectPaths();
	m_hangar_door_right ConnectPaths();
}


hangar_intruder_door_open( m_player )
{
	run_scene( "lock_breaker_door" );
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