#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;


/*QUAKED script_vehicle_littlebird_player_so (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

valid ai groups are:
"first_guys" - left and right side guys that need to be on first
"left" - all left guys
"right" - all right guys
"passengers" - everybody that can unload
"default"

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_littlebird_player::main( "vehicle_mh_6_little_bird", undefined, "script_vehicle_littlebird_player_so" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_littlebird_bench
sound,vehicle_littlebird,vehicle_standard,all_sp

defaultmdl="vehicle_mh_6_little_bird"
default:"vehicletype" "littlebird_player"
default:"script_team" "allies"
*/


//===========================================
// 				tweakables
//===========================================

CONST_heli_attacker_accuracy 		= 0.30;
CONST_damage_reduction				= 0.5;
CONST_littlebird 					= "littlebird_path01";
CONST_coop_heli_wait				= 3;
CONST_so_payback_debug				= "0";
CONST_heli_exit_invulnerable_time	= 2.0;	
CONST_rooftop_delay					= 2.0;


//===========================================
// 					main
//===========================================
main()
{
	so_payback_precache();
	delete_destructables();
	
	// fx from base map
	maps\payback_fx::main();
	so_fixup_all_createfx();
	
	maps\so_littlebird_payback_precache::main();
	maps\payback_precache::main();
	maps\_c4::main(); 
	maps\_load::main();
	maps\_xm25::init();	
	
	// audio from base map
	maps\_shg_common::so_mark_class( "trigger_multiple_audio" );
	maps\payback_aud::main();
	
	// compass
	maps\_compass::setupMiniMap("compass_map_payback_port","port_minimap_corner");
	
	// level scripting
    setup();
    level thread gameplay_logic();
}


//===========================================
// 			  so_fixup_all_createfx
//===========================================
so_fixup_all_createfx()
{
	foreach( fxent in level.createFXent )
	{
		fxent.script_specialops = 1;
	}
}
  

//===========================================
// 			  so_payback_precache
//===========================================
so_payback_precache()
{
	PrecacheMinimapSentryCodeAssets();
	
	// weapons
	level.so_payback_primary 	= "pecheneg_so_fastreload";
	level.so_payback_secondary 	= "m4m203_reflex_xmags";
	level.so_payback_alt 		= "alt_m4m203_reflex_xmags";
	
	PreCacheItem( level.so_payback_primary );
	PreCacheItem( level.so_payback_secondary );
	
	// effects
	level._effect[ "flesh_hit" ] 		= LoadFX( "impacts/flesh_hit_body_fatal_exit" );
	level._effect[ "cocaine" ] 			= LoadFX( "props/cocaine_puff" );
	
	// hint strings
	add_hint_string( "c4_hint", &"SO_LITTLEBIRD_PAYBACK_C4_HINT", ::remove_hint );
	add_hint_string( "grenade_hint", &"SO_LITTLEBIRD_PAYBACK_GRENADE_HINT", ::remove_hint );
	
	// c4
	level.c4_sound_override = true;
	level.scr_sound[ "detpack_explo_main" ] = "detpack_explo_main";
	
	// required by base map
	level._effect["_breach_doorbreach_detpack"] 	= loadfx("explosions/exp_pack_doorbreach");
	level._effect["aerial_explosion_large_linger"] 	= loadfx("explosions/aerial_explosion_large_linger");
	
	// need to delay createfx sounds for PC ship for the first few frames
	level.delay_createfx_seconds = 0.5;
	
	// on screen challenge text
	PreCacheString( &"SO_LITTLEBIRD_PAYBACK_SNIPE_KILLS_MENU" );
	PreCacheString( &"SO_LITTLEBIRD_PAYBACK_EXPLO_KILLS_MENU" );
}


//===========================================
// 					setup
//===========================================
setup()
{
	save_base_map_ents();
	so_delete_all_triggers();
	so_delete_all_spawners();
	so_delete_all_vehicles();
	so_delete_breach_ents();
	delete_path_blockers();
	delete_basemap_ents();
	
	setup_flags();
	setup_vo();
	setup_player_roles();
	setup_challenge();
	setup_littlebird();
	setup_enemy_spawn_settings();
}


//===========================================
// 			 save_base_map_ents
//===========================================
save_base_map_ents()
{
	ent_array = GetEntArray();
	
	foreach( ent in ent_array )
	{
		if( isdefined( ent.script_flag ) && ( ent.script_flag == "no_prone_water_trigger" ) )
		{
			ent.script_specialops = 1;
		}
	}
}


//===========================================
// 			 delete_path_blockers
//===========================================
delete_path_blockers()
{
	delete_by_key_value_pair( "SO_remove_model", "targetname" );
		
	brush_models = GetEntArray( "SO_remove_brush", "targetname" );
	
	for( i = 0; i < brush_models.size; i++)
	{
		brush_models[i] hide_entity();
	}
}


//===========================================
// 		  delete_by_key_value_pair
//===========================================
delete_by_key_value_pair( value, key, check_target )
{
	entity_array = GetEntArray( value, key );
	
	for( i = 0; i < entity_array.size; i++)
	{
		object = entity_array[i];
			
		if( IsDefined( object ) )
		{
			if( IsDefined( check_target ) && check_target )
			{
				if( IsDefined( object.target ) )
				{
					collision = GetEnt( object.target, "targetname" );
					
					if( IsDefined( collision ) )
					{
						collision hide_entity();
					}
				}
			}
			
			object notify( "delete" );
			object delete();
		}
	}
}


//===========================================
// 			  delete_destructables
//===========================================
delete_destructables()
{
	// need to delete destructables before maps\_load::main()
	delete_by_key_value_pair( "explodable_barrel", "targetname", true );
	delete_by_key_value_pair( "destructible_toy", "targetname", true );
}


//===========================================
// 			  delete_basemap_ents
//===========================================
delete_basemap_ents( )
{
	// remove basemap hummers
	delete_by_key_value_pair( "placeholder_hummer_alpha", "targetname" );	
	delete_by_key_value_pair( "placeholder_hummer_bravo", "targetname" );
	
	delete_by_key_value_pair( "misc_turret", "classname" );
	delete_by_key_value_pair( "weapon_dragunov", "classname" );
	
	delete_by_key_value_pair( "rpg_crate_clip", "targetname" );
	
	// remove parts of the vista
	delete_by_key_value_pair( "pb_end_vista", "targetname" );
	
	// remove basemap script models by model name
	add_to_delete_model_list( "pb_mortar_dmg" );
	add_to_delete_model_list( "prop_mortar" );
	delete_model_list();
}


//===========================================
// 		  add_to_delete_model_list
//===========================================
add_to_delete_model_list( model_name )
{
	if( !IsDefined(level.delete_model) )
	{
		level.delete_model = [];
	}
	
	level.delete_model[ level.delete_model.size ] = model_name;
}


//===========================================
// 		  	delete_model_list
//===========================================
delete_model_list()
{
	if( !IsDefined(level.delete_model) )
	{
		return;
	}
	
	script_models = GetEntArray( "script_model", "classname" ); 
	
	// remove basemap ents by model name
	for( i = 0; i < script_models.size; i++)
	{
		if( !IsDefined( script_models[i].model ) )
		{
			continue;
		}
		
		for( x = 0; x < level.delete_model.size; x++)
		{
			if( script_models[i].model == level.delete_model[x] )
			{
				script_models[i] delete();
				break;
			}
		}
	}
}


//===========================================
// 				setup_flags
//===========================================
setup_flags()
{
	// mission complete and fail flags
	flag_init ("so_littlebird_payback_start");
	flag_init ("so_littlebird_payback_complete");
	flag_init ("player_has_escaped");
	
	// c4 flags
	flag_init ("blue_star_planted");
	flag_init ("blue_star_finished");
	flag_init ("red_star_planted");
	flag_init ("red_star_finished");
	
	// flags set by triggers along the heli path
	flag_init ("path01_trigger01");
	flag_init ("path01_trigger02");
	flag_init ("path02_trigger01");
	flag_init ("path02_trigger02");
	flag_init ("path02_trigger03");
	flag_init ("path02_trigger04");
	flag_init ("path03_trigger01");
	
	// end path flags
	flag_init ("endpath01");
	flag_init ("endpath02");
	flag_init ("endpath03");
	
	// flags set by heli nodes
	flag_init ( "start_ground_assault" );
	flag_init ("endpath01_delay");
	flag_init ("path02_wave01_wait");
	flag_init ("rpg_vo");
	flag_init ("fly_over");
	flag_init ("endpath02_delay");
	flag_init ("endpath03_delay");
	
	// flags set in script
	flag_init ("ground_player_off_littlebird");
	flag_init ("heli_player_off_littlebird");
	flag_init ("heli_player_stayed_on_littlebird");
	flag_init ("stay_on_heli_button_pressed");
	flag_init ("path02_wave01");
	flag_init( "intro_vo_done" );
}


//===========================================
// 				setup_vo
//===========================================
setup_vo()
{	
	level.scr_radio[ "so_lb_payback_hqr_angelone" ] 		= "so_lb_payback_hqr_angelone";			// Angel-One, we've lost contact with Bravo Team.  Proceed to last known coordinates.
	level.scr_radio[ "so_lb_payback_plt_enroute" ] 			= "so_lb_payback_plt_enroute";			// Copy that Overlord, we are en-route.
	level.scr_radio[ "so_lb_payback_plt_eyeson" ] 			= "so_lb_payback_plt_eyeson";			// Overlord, this is angel-1.  We have eyes on Bravo's ride, looks like the team is KIA.
	level.scr_radio[ "so_lb_payback_plt_rooftopright" ] 	= "so_lb_payback_plt_rooftopright";		// Rooftop on the Right!
	level.scr_radio[ "so_lb_payback_plt_enemyright" ] 		= "so_lb_payback_plt_enemyright";		// Enemy, rooftop, right
	level.scr_radio[ "so_lb_payback_plt_rpgsrooftop" ] 		= "so_lb_payback_plt_rpgsrooftop";		// RPGs on the rooftops!
	level.scr_radio[ "so_lb_payback_plt_balconies" ] 		= "so_lb_payback_plt_balconies";		// Multiple contacts on the balconies!
	level.scr_radio[ "so_lb_payback_plt_technical" ] 		= "so_lb_payback_plt_technical";		// Enemy technical spotted in the street.
	level.scr_radio[ "so_lb_payback_hqr_pickup" ] 			= "so_lb_payback_hqr_pickup";			// Copy that angel-1, Find an L.Z. and pick up where Bravo team left off.
	level.scr_radio[ "so_lb_payback_hqr_narcotics" ] 		= "so_lb_payback_hqr_narcotics";		// The local militia is funded by the drug trafficking in this sector.  Find and eliminate the narcotics.
	level.scr_radio[ "so_lb_payback_hqr_stashes" ] 			= "so_lb_payback_hqr_stashes";			// All drug stashes have been destroyed.  Rendezvous with angel-1 and dust off.
	level.scr_radio[ "so_lb_payback_hqr_c4inplace" ] 		= "so_lb_payback_hqr_c4inplace";		// C4 is in place.  Blow it!
	level.scr_radio[ "so_lb_payback_hqr_chargeplanted" ]	= "so_lb_payback_hqr_chargeplanted";	// Charge planted, hit the clacker.
}


//===========================================
// 			 setup_player_roles
//===========================================
setup_player_roles()
{
	level.ground_player = level.player;
	level.heli_player 	= level.player2;
	
	// Role select text: 	"Select Ground Support." 
	// dvar coop_start: 	value "so_char_host" from menus sets host as ground support
	// dvar coop_start: 	value "so_char_client" from menus sets client as ground support
		
	if( is_coop() && ( GetDvar( "coop_start" ) == "so_char_client" ) )
	{
		level.ground_player = level.player2;
		level.heli_player 	= level.player;
	}
}


//===========================================
// 				setup_challenge
//===========================================
setup_challenge()
{
	level thread enable_challenge_timer( "so_littlebird_payback_start", "so_littlebird_payback_complete" );
	level thread fade_challenge_in( 1.5, false );
	level thread fade_challenge_out( "so_littlebird_payback_complete" );
	
	level thread enable_escape_warning();
	level thread enable_escape_failure();
}


//===========================================
// 				setup_littlebird
//===========================================
setup_littlebird()
{
	level.littlebird = spawn_vehicle_from_targetname( CONST_littlebird );
	level.littlebird.dont_crush_player = 1;
	level.littlebird godon();
	level.littlebird hidepart( "static_rotor_jnt" );
	level.littlebird hidepart( "static_tail_rotor_jnt" );
	
	setsaveddvar( "g_friendlyfireDamageScale", 0.1 );
	flag_clear( "laststand_on" );
	
	if( CONST_littlebird != "littlebird_path01" )
	{
		init_player_on_littlebird( level.ground_player, "TAG_GUY3" );
		init_player_on_littlebird( level.heli_player, "TAG_GUY4" );
	}
	else
	{
		init_player_on_littlebird( level.ground_player, "heli_seat_front" );
		init_player_on_littlebird( level.heli_player, "heli_seat_back" );
	}
	
    skybox_malarkey();
    
    // play fire fx on the downed lynx
    crashed_lynx_fx = GetStruct( "crashed_lynx_fx", "targetname" );
	playfx( getfx( "heli_crash_fire_payback_xfar" ), crashed_lynx_fx.origin );
	
	// hide triggers during the heli ride
	heli_ride_hide = GetEntArray( "heli_ride_hide", "targetname" );
	array_thread( heli_ride_hide, ::hide_entity );
}


//===========================================
// 			init_player_on_littlebird
//===========================================
init_player_on_littlebird( player, seat_location )
{
	if( !IsDefined(player) )
	{
		return;
	}
	
	if( CONST_littlebird != "littlebird_path01" )
	{
		level.littlebird lerp_player_view_to_tag( player, seat_location, 0.05, 0.0, 180, 0, 40, 80 );
	}
	else
	{
		// create an offset tag to the littlebird
		seat_position 	= GetStruct( seat_location, "targetname");
		seat_tag 		= spawn_tag_origin();
		seat_tag.origin = seat_position.origin;
		
		if( IsDefined(seat_position.angles) )
		{
			seat_tag.angles = seat_position.angles;
		}
		
		// link the new tag to the heli and link the player to the new tag
		seat_tag linkto( level.littlebird, "tag_origin" );
		player PlayerLinkTo( seat_tag, "tag_origin", 0.0, 190, -10, 40, 80, false );
	}
	
	player_angles = GetEnt( "player_angles", "script_noteworthy" );
	player SetPlayerAngles( player_angles.angles );
	
	player AllowJump( false );
	player AllowSprint( false );
	player AllowProne( false );
	player AllowCrouch( false );
	
	player SetViewKickScale( 0.5 );
	player GiveMaxAmmo( level.so_payback_primary );
	player GiveMaxAmmo( level.so_payback_secondary );
	
	player.is_on_heli = true;
}


//===========================================
// 		 	skybox_malarkey
//===========================================
skybox_malarkey()
{
	level.skybox_brushes = [];
		
	level.skybox_brushes = array_combine( GetEntArray( "chopper_fog_brush", "targetname" ), GetEntArray( "sandstorm_sky", "targetname" ) );
	level.skybox_brushes = array_combine( level.skybox_brushes, GetEntArray( "construction_vista_blend", "targetname" ) );
		
	foreach( brush in level.skybox_brushes )
	{
		brush Hide();
		brush NotSolid();
	}
}


//===========================================
// 		  setup_enemy_spawn_settings
//===========================================
setup_enemy_spawn_settings()
{
	add_global_spawn_function( "axis", ::override_enemy_settings_on_spawn );
}


//===========================================
// 		override_enemy_settings_on_spawn
//===========================================
override_enemy_settings_on_spawn()
{
	self.grenadeammo = 0;
	
	// settings for ai while both players on heli
	if( !flag( "start_ground_assault" ) )
	{
		self.health = 100;
		self.baseAccuracy = self.baseAccuracy * 0.75;
	}
	
	// lower the accuracy of the ai on the rooftop, because they are within feet of the heli
	if( IsDefined(self.script_noteworthy) && self.script_noteworthy == "rooftop_ai" )
	{
		self.baseAccuracy = self.baseAccuracy * 0.65;
	}
	
	// coop player stayed on heli
	if( flag( "heli_player_stayed_on_littlebird" ) )
	{
		// the ai should focus on the player who is on the ground
		self setthreatbiasgroup( "ground_ai" );
		
		// ai that should ignore the player in the heli
		if( IsDefined(self.script_noteworthy) && self.script_noteworthy == "ignore_heli" )
		{
			self setthreatbiasgroup( "ignore_player" );
		}
	}
}


//===========================================
// 				gameplay_logic
//===========================================
gameplay_logic()
{
	// settings and support scripting
	level thread start_challenge_timer();
	level thread run_objectives();
	level thread run_littlebird_flight_path();
	level thread run_custom_damage();
	level thread run_music();
	level thread run_vo();
	level thread run_grenade_weapon_hint();
	
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i] thread no_prone_water_trigger();
		level.players[i] thread record_mission_challenges();
	}
	
	level thread report_mission_challenges();
	
	// combat scripting
	level thread run_intro_truck();
	level thread run_path_01();
	level thread run_path_02();
	level thread run_path_03();
	level thread run_path_04();
	level thread run_ground_assault();
	level thread run_buildingA_assault();
	level thread run_buildingB_assault();
	level thread run_objective_assault();
	
	/#
	level thread so_payback_debug();
	#/
}


//===========================================
// 		 record_mission_challenges
//===========================================
record_mission_challenges()
{
	level endon( "special_op_terminated" );
	level endon( "so_littlebird_payback_complete" );
	 
	self.bonus_1 = 0;
	self.bonus_2 = 0;
	
	while( true )
	{
		if( IsDefined( self.stats[ "kills_explosives" ] ) )
		{
			if( self.bonus_1 != self.stats[ "kills_explosives" ] )
			{
				self.bonus_1 = self.stats[ "kills_explosives" ];
				self notify( "explosion_kill", self.bonus_1 );
			}
			
		}
		
		if( IsDefined( self.stats[ "weapon" ][ "as50" ] ) )
		{
			if( self.bonus_2 != self.stats[ "weapon" ][ "as50" ].kills )
			{
				self.bonus_2 = self.stats[ "weapon" ][ "as50" ].kills;
				self notify( "snipe_kill", self.bonus_2 );
			}
			
		}
		
		wait( 0.05 );
	}
}


//===========================================
// 			report_mission_challenges
//===========================================
report_mission_challenges()
{
	CONVERT_MIN_TO_MILLI_SEC 	= 60 * 1000;
	
	level.so_mission_worst_time = 22 * CONVERT_MIN_TO_MILLI_SEC;
	level.so_mission_min_time	= 3 * CONVERT_MIN_TO_MILLI_SEC;
	
	maps\_shg_common::so_eog_summary( "@SO_LITTLEBIRD_PAYBACK_EXPLO_KILLS", 25, undefined, "@SO_LITTLEBIRD_PAYBACK_SNIPE_KILLS", 25, undefined );
	
	array_thread( level.players, ::enable_challenge_counter, 3, &"SO_LITTLEBIRD_PAYBACK_SNIPE_KILLS_MENU", "snipe_kill" );
	array_thread( level.players, ::enable_challenge_counter, 4, &"SO_LITTLEBIRD_PAYBACK_EXPLO_KILLS_MENU", "explosion_kill" );
}


//===========================================
// 			no_prone_water_trigger
//===========================================
no_prone_water_trigger()
{
	level endon( "special_op_terminated" );
	level endon( "so_littlebird_payback_complete" );
	
	while( true )
	{
		flag_wait( "no_prone_water_trigger" );
		
		if (self GetStance() == "prone" )
		{
			self SetStance( "stand" );
		}
		
		self AllowProne( false );
		
		flag_waitopen( "no_prone_water_trigger" );
		self AllowProne( true );
	}
}


//===========================================
// 			run_intro_truck
//===========================================
run_intro_truck()
{
	if( CONST_littlebird != "littlebird_path01" )
	{
		return;
	}
	
	intro_truck = spawn_vehicle_from_targetname_and_drive( "ai_truck_intro" );
	intro_truck godon();
	
	truck_ai = GetEntArray( "truck_ai", "script_noteworthy" );
	driver = undefined;
	
	// don't allow the truck driver to die
	for( i = 0; i < truck_ai.size; i++ )
	{
		ai = truck_ai[i];
		
		if( IsAI( ai ) && IsDefined( ai.script_startingposition ) )
		{
			driver = ai;
			driver deletable_magic_bullet_shield();
			break;
		}
	}
	
	flag_wait( "so_littlebird_payback_start" );
	wait( 0.75 );
	
	// the level has started, allow ai to find enemies
	for( i = 0; i < truck_ai.size; i++ )
	{
		ai = truck_ai[i];
		
		if( IsAI( ai ) )
		{
			ai set_ignoreall( false );
		}
	}
	
	flag_wait_or_timeout( "intro_truck_stop", 90 );
	
	intro_truck godoff();
	driver stop_magic_bullet_shield();
	
	intro_truck thread unload_vehicle_ai( "intro_truck_volume" );
}


//===========================================
// 			start_challenge_timer
//===========================================
start_challenge_timer()
{
	level endon( "special_op_terminated" );
	
	level waittill( "challenge_fading_in");
	flag_set( "so_littlebird_payback_start" );
}


//===========================================
// 				run_objectives
//===========================================
run_objectives()
{
	level endon( "special_op_terminated" );
	
	// turn off the level exit triggers
	level.exit_point 		= GetEnt( "level_exit", "targetname" );
	level.exit_point_coop 	= GetEnt( "level_exit_coop", "targetname" );
	level.exit_point_heli 	= GetEntArray( "exit_point_heli", "targetname" );
	
	level.exit_point 		hide_entity();
	level.exit_point_coop 	hide_entity();
	
	for( i = 0; i < level.exit_point_heli.size; i++ )
	{
		level.exit_point_heli[i] hide_entity();
	}
	
	// locate the crash site objective
	Objective_Add( 1, "current", &"SO_LITTLEBIRD_PAYBACK_CRASH_SITE" );
	flag_wait_any( "intro_vo_done", "endpath01", "endpath03_delay" );
	Objective_Complete( 1 );
	
	// find a landing zone
	Objective_Add( 2, "current", &"SO_LITTLEBIRD_PAYBACK_LZ" );
	flag_wait( "endpath03" );
	wait( 2 );
	Objective_Complete( 2 );

	// plant c4 objective
	Objective_Add( 3, "current", &"SO_LITTLEBIRD_PAYBACK_DRUGS" );
		
	// c4 roof top
	blue_star = GetEnt( "blue_star", "targetname");
	blue_star_offset = GetEnt( "blue_star_offset", "targetname");
	blue_star maps\_c4::c4_location( undefined, undefined, undefined, blue_star_offset.origin );
	blue_star thread detonation_objective( "blue_star_planted", "blue_star_finished", 3, 1, "blue_star_clip" );
	
	// c4 building
	red_star = GetEnt( "red_star", "targetname");
	red_star_offset = GetEnt( "red_star_offset", "targetname");
	red_star maps\_c4::c4_location( undefined, undefined, undefined, red_star_offset.origin );
	red_star thread detonation_objective( "red_star_planted", "red_star_finished", 3, 2, "red_star_clip" );
	
	// display hints for c4 detonation
	c4_array = getentarray( "generic_use_trigger", "targetname" );
	
	for( i = 0; i < c4_array.size; i++)
	{
		c4_array[i] thread c4_hint();
	}
		
	flag_wait_all( "blue_star_finished", "red_star_finished");
	
	// extraction point objective
	Objective_Complete( 3 );
	Objective_Add( 4, "current", &"SO_LITTLEBIRD_PAYBACK_EXIT" );
	
	// extraction point objective dot
	extraction_point = GetStruct( "extraction_point", "targetname" );
	Objective_AdditionalPosition( 4, 1, (0, 0, 0) );
	Objective_AdditionalPosition( 4, 1, extraction_point.origin );
	
	// turn on the level exit triggers
	if( !is_heli_on_overwatch() )
	{
		level.exit_point_coop show_entity();
		flag_init( level.exit_point_coop.targetname );
		level thread enable_triggered_complete( level.exit_point_coop.targetname, "so_littlebird_payback_complete", "all" );
	}
	else
	{
		level.exit_point show_entity();
	}
	
	for( i = 0; i < level.exit_point_heli.size; i++ )
	{
		level.exit_point_heli[i] show_entity();
	}
	
	flag_wait( "so_littlebird_payback_complete" );
	
	Objective_Complete( 4 );
	
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i] EnableInvulnerability();
		level.players[i] FreezeControls( true );
		level.players[i].ignoreme = true;
	}
}


//===========================================
// 				c4_hint
//===========================================
c4_hint()
{
	self waittill( "trigger", player );
	
	player display_hint_timeout( "c4_hint", 2 );
}


//===========================================
// 				remove_hint
//===========================================
remove_hint()
{
	 return false;
}


//===========================================
// 			detonation_objective
//===========================================
detonation_objective( flag_planted, flag_detonation, objective_index, position_index, clip )
{
	level endon( "special_op_terminated" );
	
	Objective_AdditionalPosition( objective_index, position_index, (0, 0, 0) );
	Objective_AdditionalPosition( objective_index, position_index, self.origin + (0, 0, 54) );
	
	self waittill( "c4_planted" );
	flag_set( flag_planted );
	
	self waittill( "c4_detonation" );
	flag_set( flag_detonation );
	
	Objective_AdditionalPosition( objective_index, position_index, (0, 0, 0) );
	PlayFX( level._effect[ "cocaine" ], self.origin );
	
	clip = GetEnt( clip, "targetname");
	clip NotSolid();
	
	self Delete();	
}


//===========================================
// 		  run_littlebird_flight_path
//===========================================
run_littlebird_flight_path()
{
	level endon( "special_op_terminated" );
	
	level.littlebird gopath();
	level.littlebird Vehicle_SetSpeed( 20, 5, 10 );
	
    level.littlebird thread switchpath_onflag( "endpath01", "path02" );
    level.littlebird thread switchpath_onflag( "endpath02", "path03" );
    
    level thread heli_fail_safe();
}


//===========================================
// 		  		heli_fail_safe
//===========================================
heli_fail_safe()
{
	level endon( "so_littlebird_payback_complete" );
	
	flag_set( "special_op_no_unlink" );
	
	level waittill( "special_op_terminated" );
	
	if( !IsDefined( level.littlebird ) )
	{
		return;
	}
	
	level.littlebird Vehicle_SetSpeedImmediate( 0, 60, 60 );
}


//===========================================
// 				switchpath_onflag
//===========================================
switchpath_onflag( flag_name, pathobj_targetname )
{
	level endon( "special_op_terminated" );
	
    flag_wait ( flag_name );
    
    path = getstruct( pathobj_targetname, "targetname");
    assert( isdefined( path ) );
    self vehicle_paths( path );    
}


//===========================================
// 			run_custom_damage
//===========================================
run_custom_damage()
{
	level endon( "special_op_terminated" );
		
	// reduce damage 
	level.damage_reduction 	= CONST_damage_reduction;
	level.damage_scale 		= ( 1 - level.damage_reduction ) / level.damage_reduction;
	
	setsaveddvar( "player_damageMultiplier", level.damage_reduction );

	level thread run_player_damage( level.ground_player );
	level thread run_player_damage( level.heli_player );
}


//===========================================
// 				run_player_damage
//===========================================
run_player_damage( player )
{	
	if( !IsDefined(player) )
	{
		return;
	}
	
	level 	endon( "special_op_terminated" );
	player  endon( "death" );
	
	while( true )
	{
		player waittill( "damage", amount, attacker, direction_vec, point, type );
		
		if( type == "MOD_FALLING" ) 
		{
			continue;
		}
		
		if( player.is_on_heli )
		{
			// damage reduction for heli player after split
			if( flag( "endpath03" ) )
			{
				continue;
			}
			
			// grenade attachment does not get the reloading damage reduction
			if( player IsReloading() && !(player GetCurrentWeapon() == level.so_payback_alt) )
			{
				continue;
			}
		}
		
		source_position = (0,0,0);
		
		if( IsDefined( attacker ) )
		{
			source_position = attacker.origin;
		}
		else if( IsDefined( direction_vec ) && ( direction_vec != (0,0,0) ) )
		{
			source_position = ( direction_vec + player.origin ) * 512;
		}
		
		// + 2 to offset rounding error
		if( source_position != (0,0,0) )
		{
			player dodamage( (level.damage_scale * amount) + 2, source_position, attacker );
		}
	}
}


//===========================================
// 				  run_music
//==========================================
run_music()
{
	flag_wait( "intro_vo_done" );
	
	maps\_audio_music::MUS_play( "pybk_mx_construction_r", 6 );
	
	flag_wait( "endpath03_delay" );
	
	maps\_audio_music::MUS_stop( 10 );
	
	maps\_audio_music::MUS_play( "so_littlebird_pybk_amb" );
}
	
	
//===========================================
// 				   run_vo
//==========================================
run_vo()
{
	level endon( "special_op_terminated" );
	
	flag_wait( "so_littlebird_payback_start" );
	
	play_vo_line( "so_lb_payback_hqr_angelone" );					// Angel-One, we've lost contact with Bravo Team.  Proceed to last known coordinates.
	play_vo_line( "so_lb_payback_plt_enroute" );					// Copy that Overlord, we are en-route.
	
	flag_wait( "endpath01_delay" );
		
	play_vo_line( "so_lb_payback_plt_eyeson" );						// Overlord, this is angel-1.  We have eyes on Bravo's ride, looks like the team is KIA.
	level thread play_vo_line( "so_lb_payback_hqr_pickup" );		// Copy that angel-1, Find an L.Z. and pick up where Bravo team left off.
	flag_set( "intro_vo_done" );
		
	flag_wait( "endpath01" );
	wait( CONST_rooftop_delay );
		
	radio_dialogue( "so_lb_payback_plt_rooftopright" ); 			// Rooftop on the Right!
	wait( 1.5 );
	radio_dialogue( "so_lb_payback_plt_enemyright" ); 				// Enemy, rooftop, right
	
	flag_wait( "rpg_vo" );
	radio_dialogue( "so_lb_payback_plt_rpgsrooftop" ); 				// RPGs on the rooftops!
	
	flag_wait( "truck01" );
	wait( 2 );
	
	radio_dialogue( "so_lb_payback_plt_technical" ); 				// Enemy technical spotted in the street.
	
	flag_wait( "endpath03" );
	wait( 2 );
	
	radio_dialogue( "so_lb_payback_hqr_narcotics" );				// The local militia is funded by the drug trafficking in this sector.  Find and eliminate the narcotics.
	
	level thread vo_wait( "so_lb_payback_hqr_c4inplace", "red_star_planted" ); 		// C4 is in place.  Blow it!
	level thread vo_wait( "so_lb_payback_hqr_chargeplanted", "blue_star_planted" ); // Charge planted, hit the clacker.
		
	flag_wait_all( "blue_star_finished", "red_star_finished");
	wait( 2 );
	
	play_vo_line( "so_lb_payback_hqr_stashes" );					// All drug stashes have been destroyed.  Rendezvous with angel-1 and dust off.  
}


//===========================================
// 			  	vo_wait
//===========================================
vo_wait( vo_line, vo_flag )
{
	flag_wait( vo_flag );
	radio_dialogue( vo_line );
}

//===========================================
// 			  	play_vo_line
//===========================================
play_vo_line( vo_line )
{
	level endon( "special_op_terminated" );
	
	radio_dialogue( vo_line );
}


//===========================================
// 		 	run_grenade_weapon_hint
//===========================================
run_grenade_weapon_hint()
{
	level endon( "special_op_terminated" );
	
	// bail out, if difficulty greater than regular
	if( level.gameSkill > 1 )
	{
		return;
	}
	
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i].show_grenade_weapon_hint = true;
		level.players[i] thread monitor_weapon_switch();
	}
		
	flag_wait( "path02_node_trigger02" );
	wait( 1.0 );
	
	for( i = 0; i  < level.players.size; i++ )
	{
		if( level.players[i].show_grenade_weapon_hint == true )
		{
			level.players[i] display_hint_timeout( "grenade_hint", 2.0 );
		}
	}
}


//===========================================
// 			monitor_weapon_switch
//===========================================
monitor_weapon_switch()
{
	level endon( "special_op_terminated" );
	
	while( true )
	{
		self waittill( "weapon_change" );
		
		if( (self GetCurrentWeapon() ) == level.so_payback_alt )
		{
			self.show_grenade_weapon_hint = false;
			break;
		}
	}
}


//===========================================
// 				run_path_01
//===========================================
run_path_01()
{
	level endon( "special_op_terminated" );
	
	flag_wait( "intro_vo_done" );
	flag_set( "path01_trigger01");
	
	flag_wait_and_flood_spawn( "path01_trigger01", 0 );
	
	wait( 2.0 );
	flag_set( "path01_trigger02");
	
	flag_wait_and_flood_spawn( "path01_trigger02", 3.0 );
	
	flag_wait( "endpath01_delay" );
	
	level thread monitor_ai_wave( "path01_wave01", 2, "endpath01" );
	flag_wait_or_timeout( "endpath01", 45 );
	flag_set( "endpath01" );
	
	level thread ai_wave_cleanup( "path01_wave01" );
	level thread ai_wave_cleanup( "truck_ai" );
	level.littlebird Vehicle_SetSpeed( 8, 2, 1 );
}


//===========================================
// 				monitor_path
//===========================================
monitor_ai_wave( script_noteworthy_value, min_number, flag_to_set )
{
	level endon( "special_op_terminated" );
	
	while( !flag( flag_to_set) )
	{
		ai_wave = GetEntArray( script_noteworthy_value, "script_noteworthy" );
		ai_counter = 0;
		
		for( i = 0; i < ai_wave.size; i++ )
		{
			ai = ai_wave[i];
		
			// count all valid ai
			if( IsAI( ai ) && IsAlive( ai ) && !IsLongDeath( ai ) )
			{
				ai_counter++;
			}
			
			// count valid spawners
			if( !IsAI( ai ) && IsDefined( ai.count ) )
			{
				ai_counter = ai_counter + ai.count;
			}
			
			// bail out early 
			if( ai_counter > min_number )
			{
				break;
			}
		}
		
		// if no ai, set flag immediately
		if( ai_counter == 0 )
		{
			flag_set( flag_to_set );
			break;
		}

		wait( 1.0 );
		
		// if a few ai left, wait for a bit
		if( ai_counter <= min_number )
		{
			wait( ai_counter );
			flag_set( flag_to_set );
		}
	}
}


//===========================================
// 				IsLongDeath
//===========================================
IsLongDeath( actor )
{
	return  actor doinglongdeath();
}


//===========================================
// 			   ai_wave_cleanup
//===========================================
ai_wave_cleanup( script_noteworthy_value )
{
	level endon( "special_op_terminated" );
	
	ai_wave_cleanup = GetEntArray( script_noteworthy_value, "script_noteworthy" );
	
	for( i = 0; i < ai_wave_cleanup.size; i++ )
	{
		ent = ai_wave_cleanup[i];
		
		if( !IsAI( ent ) )
		{
			ent notify( "stop current floodspawner" );
			continue;
		}
		
		if( IsAI( ent ) && IsAlive( ent ) )
		{
			ent thread maps\ss_util::fake_death_bullet( 1.5 );
		}
	}
}


//===========================================
// 				run_path_02
//===========================================
run_path_02()
{
	level endon( "special_op_terminated" );
	
	// 2nd floor roof top ai
	flag_wait_and_flood_spawn( "endpath01", CONST_rooftop_delay );
	flag_wait( "path02_wave01_wait" );
	level thread monitor_ai_wave( "path02_wave01", 1, "path02_wave01" );
	flag_wait_or_timeout( "path02_wave01", 12 );
	flag_set( "path02_wave01" );
	
	// balcony ai
	flag_wait_and_flood_spawn( "path02_trigger01", 0 );
	flag_wait_and_flood_spawn( "path02_node_trigger01", 0 );
	
	// 3rd floor roof ai
	flag_wait_and_flood_spawn( "path02_node_trigger02", 2.5 );		
	flag_wait_and_flood_spawn( "path02_trigger02", 0 );
	
	level thread fly_by_damage( level.ground_player );
	level thread fly_by_damage( level.heli_player );
	
	// roof tops fly-by ai
	flag_wait_and_flood_spawn( "path02_trigger03", 0 );
	flag_wait_and_flood_spawn( "path02_trigger03_wave02", 0 );		
	
	// last wave in path 02
	flag_wait_and_flood_spawn( "path02_trigger04", 0 );
	
	// fix heli yaw
	flag_wait( "endpath02_delay" );
	node = GetStruct( "path02_end_yaw", "targetname" );
	level.littlebird SetGoalYaw( node.angles[1] );
	
	num_remaining = 1;
	
	if( is_coop() )
	{
		num_remaining = 2;
	}
	
	// watch final wave
	level thread monitor_ai_wave( "path02_last_wave", num_remaining, "endpath02" );	
	flag_wait_or_timeout( "endpath02", 10 );
	flag_set( "endpath02" );
	
	// set heli speed to path03
	level.littlebird Vehicle_SetSpeed( 16, 16, 8 );
}


//===========================================
// 			  fly_by_damage
//===========================================
fly_by_damage( player )
{
	if( !IsDefined( player) )
	{
		return;
	}
	
	level 	endon( "special_op_terminated" );
	player	endon( "death" );
	
	flag_wait( "fly_over" );
	player EnableInvulnerability();
	
	flag_wait( "path02_trigger04" );
	wait( 2.5 );
	
	player DisableInvulnerability();
}


//===========================================
// 				run_path_03
//===========================================
run_path_03()
{
	level endon( "special_op_terminated" );
	
	flag_wait( "truck01" );
	ai_truck = spawn_vehicle_from_targetname_and_drive( "ai_truck01" );
	ai_truck thread unload_vehicle_ai( "truck_ai_volume" );
	
	flag_wait( "endpath03_delay" );
	level thread run_exit_littlebird();
	
	flag_wait( "ground_player_off_littlebird" );
	
	heli_wait_time = 1.0;
	
	// give the coop player a couple of extra seconds to exit the heli
	if( is_coop() && !flag( "heli_player_stayed_on_littlebird" ) && !flag( "heli_player_off_littlebird" ) )
	{
		heli_wait_time = CONST_coop_heli_wait;
	}

	wait( heli_wait_time );
	flag_set( "endpath03" );
}


//===========================================
// 		 	unload_vehicle_ai
//===========================================
unload_vehicle_ai( volume_targetname )
{
	level endon( "special_op_terminated" );
	
	self waittill_either( "unloaded", "death" );
	
	truck_ai = GetEntArray( "truck_ai","script_noteworthy" );
	
	for( i = 0; i < truck_ai.size; i++ )
	{
		ai = truck_ai[i];
		
		if( IsAI( ai ) && IsAlive( ai ) && !IsLongDeath( ai ) )
		{
			ai SetGoalVolumeAuto( GetEnt( volume_targetname, "targetname" ) );
		}
	}
}


//===========================================
// 		 	run_exit_littlebird
//===========================================
run_exit_littlebird()
{
	level endon( "special_op_terminated" );
	
	level thread player_exit_littlebird( level.ground_player, false, "ground_player_off_littlebird" );
	level thread player_exit_littlebird( level.heli_player, true, "heli_player_off_littlebird" );
	level thread enable_revive();
	
	// show triggers that where hidden during the heli ride
	heli_ride_hide = GetEntArray( "heli_ride_hide", "targetname" );
	array_thread( heli_ride_hide, ::show_entity );
}


//===========================================
// 		 		enable_revive
//===========================================
enable_revive()
{
	level endon( "special_op_terminated" );
		
	flag_wait_any( "heli_player_off_littlebird", "heli_player_stayed_on_littlebird" );
	flag_wait( "ground_player_off_littlebird" );
	
	if( flag( "heli_player_off_littlebird" ) )
	{
		flag_set( "laststand_on" );
		setsaveddvar( "g_friendlyfireDamageScale", 2 );
	}
}


//===========================================
// 		 player_exit_littlebird
//===========================================
player_exit_littlebird( player, has_option, flag_set )
{
	if( !IsDefined( player ) )
	{
		return;
	}
	
	level 	endon( "special_op_terminated" );
	player 	endon( "death" );
	
	hint_string = &"SO_LITTLEBIRD_PAYBACK_EXIT_HELI";
	
	if( has_option )
	{
		hint_string = &"SO_LITTLEBIRD_PAYBACK_OPTION";
		player thread monitor_stance();
	}
	
	player disableweapons();
	player forceusehinton( hint_string );
	
	player GiveMaxAmmo( level.so_payback_primary );
	player GiveMaxAmmo( level.so_payback_secondary );
	
	stock_ammo = player GetWeaponAmmoStock( level.so_payback_alt );
	player SetWeaponAmmoStock( level.so_payback_alt,  stock_ammo + ( 9 - stock_ammo) );
	
	player SetWeaponAmmoClip( level.so_payback_primary, WeaponClipSize (level.so_payback_primary ) );
	player SetWeaponAmmoClip( level.so_payback_secondary, WeaponClipSize( level.so_payback_secondary ) );
	player SetWeaponAmmoClip( level.so_payback_alt, WeaponClipSize( level.so_payback_alt ) );
	
	while( true )
	{
		if( player useButtonPressed() )
		{
			exit_littlebird( player, flag_set );
			break;
		}
		
		if( has_option )
		{
			if( flag( "stay_on_heli_button_pressed" ) || flag( "endpath03" ) )
			{
				stay_on_littlebird( player );
				break;
			}
		}
		
		wait( 0.05 );
	}
}


//===========================================
// 			monitor_stance
//===========================================
monitor_stance()
{
	level 	endon( "special_op_terminated" );
	level 	endon( "endpath03" );
	self 	endon( "death" );
	
	notifyOnCommand( "hit_crouch_button", "+movedown" );
	notifyOnCommand( "hit_crouch_button", "+prone" );
	notifyOnCommand( "hit_crouch_button", "+stance" );
	notifyOnCommand( "hit_crouch_button", "lowerstance" );
	notifyOnCommand( "hit_crouch_button", "togglecrouch" );
	notifyOnCommand( "hit_crouch_button", "toggleprone" );
	notifyOnCommand( "hit_crouch_button", "goprone" );
	notifyOnCommand( "hit_crouch_button", "gocrouch" );

	self waittill( "hit_crouch_button" );
	flag_set( "stay_on_heli_button_pressed" );
}


//===========================================
// 			exit_littlebird
//===========================================
exit_littlebird( player, flag_set )
{
	level 	endon( "special_op_terminated" );
	player 	endon( "death" );
	
	player EnableInvulnerability();
	player unlink();
		
	// push the player out of the heli	
	heli_exit_angles = GetStruct( "heli_exit_angles", "targetname" );
	heli_exit_angles = AnglesToForward( heli_exit_angles.angles );
	player SetVelocity( heli_exit_angles * 200 );
	
	player AllowJump( true );
	player AllowSprint( true );
	player AllowProne( true );
	player AllowCrouch( true );
	player AllowStand( true );
	player enableweapons();
	player forceusehintoff();
	player SetViewKickScale( 1 );
	
	flag_set( flag_set );
	player.is_on_heli = false;
	
	wait( CONST_heli_exit_invulnerable_time );
	player DisableInvulnerability();
}


//===========================================
// 			stay_on_littlebird
//===========================================
stay_on_littlebird( player )
{
	heli_combat();
				
	player enableweapons();
	player forceusehintoff();
	player.attackeraccuracy = player.attackeraccuracy * CONST_heli_attacker_accuracy;
}


//===========================================
// 				heli_combat
//===========================================
heli_combat()
{	
	flag_set( "heli_player_stayed_on_littlebird" );
	
	createthreatbiasgroup( "ground_player" );
	createthreatbiasgroup( "heli_player" );
	createthreatbiasgroup( "ground_ai" );
	createthreatbiasgroup( "coop_ai" );
	createthreatbiasgroup( "ignore_player" );
    
	level.ground_player setthreatbiasgroup( "ground_player" );
	level.heli_player 	setthreatbiasgroup( "heli_player" );
	
	setthreatbias( "ground_ai", "ground_player", 100 );
	setthreatbias( "coop_ai", "heli_player", 1000 );
	SetIgnoreMeGroup( "heli_player", "ignore_player" );
	
	dock_ai_settings();
}


//===========================================
// 			dock_ai_settings
//===========================================
dock_ai_settings()
{
	dock_ai = GetEntArray( "dock_wave", "script_noteworthy" );
	
	for( i = 0; i < dock_ai.size; i++ )
	{
		ai = dock_ai[i];
		
		if( IsDefined( ai ) && IsAI( ai) && IsAlive( ai ) )
		{
			ai override_enemy_settings_on_spawn();
			
			if( (i % 2) == 0 )
			{
				ai setthreatbiasgroup( "ignore_player" );
			}
		}
	}
}


//===========================================
// 				run_path_04
//===========================================
run_path_04()
{
	level endon( "special_op_terminated" );
	
	flag_wait( "endpath03" );
    
	if( !is_heli_on_overwatch() )
    {
    	level no_heli_player_path();
    	return;
    }
    	
    level.littlebird thread switchpath_onflag( "endpath03", "path04" ); 
   
	// set inital speed for path04 - ground player just exited the heli
	level.littlebird Vehicle_SetSpeed( 8, 3, 3 ); 
		
	flag_wait( "path04_face01" );
	
	// fix heli yaw
	node = GetStruct( "face01", "targetname" );
	level.littlebird SetGoalYaw( node.angles[1] );
	
	flag_wait( "ground_advance_01" );
	
	// follow the ground player's advancement
	node = getstruct( "advance_position", "targetname");
	level.littlebird thread vehicle_paths( node );
	level.littlebird Vehicle_SetSpeed( 8, 5, 5 );   
	
	flag_wait_all( "red_star_planted", "blue_star_planted" );
	 
	// cover the ground player's exit
	node = getstruct( "exit_cover", "targetname");
	level.littlebird thread vehicle_paths( node );
	level.littlebird Vehicle_SetSpeed( 15, 15, 15 ); 
	level.littlebird SetGoalYaw( node.angles[1] ); 
	
	flag_wait( "exit_point_heli" );
	
	// pick up the ground player on the heli
	node = getstruct( "exit_position", "targetname");
	level.littlebird thread vehicle_paths( node );
	level.littlebird Vehicle_SetSpeed( 9, 9, 9 ); 
	level.littlebird SetGoalYaw( node.angles[1] ); 
}


//===========================================
// 			no_heli_player_path
//===========================================
no_heli_player_path()
{
	level endon( "special_op_terminated" );
	
	level.littlebird thread switchpath_onflag( "endpath03", "heli_outro" ); 
	level.littlebird Vehicle_SetSpeed( 6, 4, 4 ); 
	
	flag_wait( "remove_littlebird" );
	level.littlebird delete();
	
	flag_wait_all( "red_star_planted", "blue_star_planted" );
	
	level.littlebird = spawn_vehicle_from_targetname_and_drive( "heli_return" );
	level.littlebird.dont_crush_player = 1;
	level.littlebird godon();
}


//===========================================
// 			run_ground_assault
//===========================================
run_ground_assault()
{
	level endon( "special_op_terminated" );
	
	// this flag is by the heli node directly before the end of heli path03
	flag_wait( "start_ground_assault" );
	
	level thread missile_repulsor( level.ground_player, "endpath03" );
	level thread missile_repulsor( level.heli_player, "endpath03" );
		
	targetname_spawn( "docks_wave01" );
	
	monitor_ai_trigger( "ground_advance_01" );
	monitor_ai_trigger( "ground_advance_02" );
	
	if( !is_heli_on_overwatch() )
	{
		targetname_spawn( "ground_advance_02_no_heli" );
	}
}


//===========================================
// 			missile_repulsor
//===========================================
missile_repulsor( ent, end_on_flag )
{
	if( !IsDefined( ent ) )
	{
		return;
	}
		
	level 	endon( "special_op_terminated" );
	ent 	endon( "death" );
	
	repulsor = Missile_CreateRepulsorEnt( ent, 5000, 750 );
	
	flag_wait( end_on_flag );
	
	if( IsDefined (repulsor ) )
	{
		Missile_DeleteAttractor( repulsor );
	}
}

	
//===========================================
// 			run_buildingA_assault
//===========================================
run_buildingA_assault()
{
	flag_wait_any( "buildingA_stairs", "buildingA_ladder");
	
	if( flag( "buildingA_stairs" ) )
	{
		targetname_spawn( "buildingA_stairs" );
		
		if( !is_heli_on_overwatch() )
		{
			fs_enemies = GetEntArray( "buildingA_stairs_fs", "targetname" );
			
			// remove force spwan key on these AI 
			for( i= 0; i < fs_enemies.size; i++ )
			{
				fs_enemies[i].script_forcespawn = undefined;
			}
		}
		
		targetname_spawn( "buildingA_stairs_fs" );
	}
	
	if( flag( "buildingA_ladder" ) )
	{
		targetname_spawn( "buildingA_ladder" );
	}
	
	if( is_heli_on_overwatch() )
	{
		monitor_ai_trigger( "buildingA_rooftop" );
	}
	
	monitor_ai_trigger( "buildingA_trigger02" );
}

	
//===========================================
// 			run_buildingB_assault
//===========================================
run_buildingB_assault()
{
	monitor_ai_trigger( "buildingB_trigger01" );
	
	if( is_heli_on_overwatch() )
	{
		targetname_spawn( "coop_buildingB" );
	}
}


//===========================================
// 			run_objective_assault
//===========================================
run_objective_assault()
{
	flag_wait_any( "red_star_planted", "blue_star_planted");
	
	if( !is_heli_on_overwatch() )
	{
		objective_enemies = GetEntArray( "objective_enemies", "targetname" );
		
		// remove force spwan key on these AI 
		for( i= 0; i < objective_enemies.size; i++ )
		{
			objective_enemies[i].script_forcespawn = undefined;
		}
	}
	
	targetname_spawn( "objective_enemies" );
	
	flag_wait_all( "red_star_planted", "blue_star_planted");
	
	if( !is_heli_on_overwatch() )
	{
		exit_enemies = array_combine( GetEntArray( "exit_enemies", "targetname" ), GetEntArray( "exit_enemies_no_heli", "targetname" ) );
		
		// remove force spwan key on these AI 
		for( i= 0; i < exit_enemies.size; i++ )
		{
			exit_enemies[i].script_forcespawn = undefined;
		}
	}
		
	targetname_spawn( "exit_enemies" );
	targetname_spawn( "exit_enemies_no_heli" );
}


//===========================================
// 			is_heli_on_overwatch
//===========================================
is_heli_on_overwatch()
{
	return IsDefined( level.heli_player ) && IsDefined( level.heli_player.is_on_heli ) && level.heli_player.is_on_heli;
}


//===========================================
// 			flag_wait_and_flood_spawn
//===========================================
flag_wait_and_flood_spawn( flag, addition_wait_time )
{
	flag_wait( flag );
	
	if( addition_wait_time > 0 )
	{
		wait( addition_wait_time );
	}
	
	enemy_spawners = GetEntArray( flag, "targetname" );
	maps\_spawner::flood_spawner_scripted( enemy_spawners );
}


//===========================================
// 			monitor_ai_trigger
//===========================================
monitor_ai_trigger( flag_to_watch )
{
	flag_wait( flag_to_watch );
	targetname_spawn( flag_to_watch );
}
	
	
//===========================================
// 			targetname_spawn
//===========================================
targetname_spawn( targetname )
{
	enemies = GetEntArray( targetname, "targetname" );
	array_thread( enemies, ::spawn_ai );
}


/#
//===========================================
// 				so_payback_debug
//===========================================
so_payback_debug()
{
	SetDvarIfUninitialized( "so_payback_debug", CONST_so_payback_debug );
		
	if( GetDebugDvar( "so_payback_debug" ) == "1" )
	{
		level thread flag_wait_and_print( "endpath01", "end path01" );
		level thread flag_wait_and_print( "endpath02", "end path02" );
		level thread flag_wait_and_print( "endpath03", "end path03" );
	}
}


//===========================================
// 			flag_wait_and_print
//===========================================
flag_wait_and_print( flag, message )
{
	level endon( "special_op_terminated" );
	
	flag_wait( flag );
	iprintlnbold( message );
}
#/