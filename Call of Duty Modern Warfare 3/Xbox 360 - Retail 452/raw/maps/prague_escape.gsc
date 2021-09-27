#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_shg_common;
#include maps\prague_escape_code;


main()
{
	level_precache();
	init_level_flags();
	init_level_globals();
	setup_anim_nodes();
	setup_start_points();	
	
	maps\createart\prague_escape_art::main();
	maps\prague_escape_fx::main();
	maps\prague_escape_precache::main();
	maps\prague_escape_anim::main();

	setup_fxanim_notify_tests();
	
	maps\_load::main();
	
	level thread maps\prague_escape_amb::main();
  	level thread handle_prague_escape_music();
	
	maps\_molotov::init();
	
	setup_spawn_funcs();
	setup_level_objects();
	
	level.player DisableWeapons();
}

handle_prague_escape_music()
{
	flag_wait( "queue_sniper_music" );
	
	music_play( "prague_escape_sniper_mx", 1 ); //sniper section

	flag_wait( "queue_player_carry_music" );
	
	music_play( "prague_escape_player_carry_mx",1); //player carrying soap
	
	flag_wait( "queue_price_carry_music" );

	music_play( "prague_escape_price_carry_mx", 1 ); //price carrying soap
	
	flag_wait( "queue_defend_music" );
	
	music_play( "prague_escape_plaza_defend_mx", 1 ); //defend
	
	flag_wait( "queue_soap_death_music" ); //soap medic scene starts

	music_play( "prague_escape_soap_death_mx", 1 ); //medic
}	

level_precache()
{
	maps\_load::set_player_viewhand_model( "viewhands_player_yuri_europe" );
		
	vehicle_scripts\_suburban::main( "vehicle_suburban", undefined, "script_vehicle_suburban" );
		
	maps\prague_escape_code::init_fade_settings();
		
	// Section 1
	PreCacheString( &"PRAGUE_ESCAPE_WATCH_PRICE_LOOK" );
	PreCacheString( &"PRAGUE_ESCAPE_PICK_UP_SOAP" );
	PreCacheString( &"PRAGUE_ESCAPE_PICK_UP" );
	PreCacheString( &"PRAGUE_ESCAPE_FOLLOW_PRICE" );
	PreCacheString( &"PRAGUE_ESCAPE_SET_SOAP_DOWN" );
	PreCacheString( &"PRAGUE_ESCAPE_SET_DOWN" );
	PreCacheString( &"PRAGUE_ESCAPE_WATCH_CONVOY" );
	PreCacheString( &"PRAGUE_ESCAPE_FIND_PRICE" );
	PreCacheString( &"PRAGUE_ESCAPE_BALCONY_SNIPE" );
	
	PreCacheString( &"PRAGUE_ESCAPE_PROTECT_SOAP" );
	PreCacheString( &"PRAGUE_ESCAPE_PROTECT" );
	PreCacheString( &"PRAGUE_ESCAPE_CLEAR_ROOM" );
	PreCacheString( &"PRAGUE_ESCAPE_OPEN_DOOR" );
	PreCacheString( &"PRAGUE_ESCAPE_REVENGE_MAKAROV" );
	PreCacheString( &"PRAGUE_ESCAPE_STOP_MASSACRE" );

	PreCacheModel( "vehicle_shadow_suburban" );
	PreCacheModel( "pigeon_iw5" );
	PreCacheModel( "weapon_m82_MG_Setup" ); 
//	PreCacheModel( "weapon_rsass" );
	PreCacheModel( "viewmodel_rsass_sp_iw5" );
	PreCacheModel( "tag_origin_animate" );
	PreCacheModel( "weapon_us_smoke_grenade" );
	precachemodel( "prop_journal");
	
	PreCacheModel( "com_office_chair_killhouse" );
	PreCacheModel( "paris_debris_burnt_wood_panels_05" );
	PreCacheModel( "debris_rubble_chunk_09" );
	PreCacheModel( "ny_debris_rubble_chunk_01" );
	PreCacheModel( "debris_wood_shard_large" );
	PreCacheModel( "debris_wood_shard_med" );
	
	PreCacheItem( "m4m203_reflex" );
	PreCacheItem( "m203_m4" );
	PreCacheItem( "rpg_straight" );
//	PreCacheItem( "rsass_silenced" );
//	PreCacheItem( "rsass" );
	PreCacheItem( "p99" );
	PreCacheItem( "p99_airport_flashback" );
	PreCacheItem( "nosound_magicbullet" );
	PreCacheItem( "flash_grenade" );
	PreCacheItem( "fraggrenade" );
	PreCacheItem( "g36c" );
	PreCacheItem( "pecheneg" );
	PreCacheItem( "ak74u" );
	PreCacheItem( "btr80_ac130_turret" );
	
	PreCacheModel( "weapon_walther_p99" );
	PreCacheModel( "viewmodel_walther_p99" );	
	PreCacheModel( "body_complete_onearm_sp_zakhaev" );
	PreCacheModel( "com_gold_brick_case" );
	PreCacheModel( "prop_car_flag" );
	PreCacheModel( "hjk_cell_phone_off" );
	PreCacheModel( "vehicle_uaz_covered_destructible" );

	//for price streaming model
	PreCacheModel( "body_tf141_assault_a" );
	PreCacheModel( "head_hero_price_desert" );

	//Dead bodies
	PreCacheModel( "body_secret_service_assault_a" );
	PreCacheModel( "body_urban_civ_male_bb" );
	PreCacheModel( "body_urban_civ_male_ba" );
	PreCacheModel( "body_slum_civ_female_ba" );
	PreCacheModel( "head_city_civ_female_a_drone" );
	PreCacheModel( "head_city_civ_male_a_drone" );
	PreCacheModel( "body_complete_civilian_suit_male_1" );
	PreCacheModel( "body_urban_civ_male_aa" );
	PreCacheModel( "body_urban_civ_male_ac" ); 
	PreCacheModel( "body_urban_civ_male_bc" );
	
	PreCacheModel( "head_opforce_fsb_a" );
	PreCacheModel( "head_prague_civ_hero_male_d" );
	PreCacheModel( "head_secret_service_b" );
	
	// Dead Resistance
	PreCacheModel( "head_prague_civ_hero_male_a" );
	PreCacheModel( "head_prague_civ_hero_male_b" );
	PreCacheModel( "head_prague_civ_hero_male_c" );
	
	PreCacheModel( "viewhands_player_yuri_airport" ); 	// no russian
	PreCacheModel( "viewhands_yuri_airport" );			// no russian
	//PreCacheModel( "viewhands_airport" ); 			// no russian
	PreCacheModel( "viewhands_player_airport" ); 		// no russian
	PreCacheModel( "viewhands_player_russian_c" ); 		// shock and awe	
	PreCacheModel( "viewhands_player_russian_b" ); 		// one shot one kill
	
	PreCacheRumble( "heavy_1s" );
	PreCacheRumble( "heavy_2s" );
	PreCacheRumble( "heavy_3s" );
	PreCacheRumble( "light_1s" );
	PreCacheRumble( "light_2s" );
	PreCacheRumble( "light_3s" );
	PreCacheRumble( "grenade_rumble" );
	PreCacheRumble( "tank_rumble" );

	PreCacheShellShock( "slowview" );
	precacheshellshock( "prague_escape" );
	PreCacheShellShock( "prague_escape_airport" );
	PreCacheShellShock( "prague_escape_flashback" );

	PreCacheShader( "overlay_flashback_blur" );

	//PreCacheShellShock( "barrett" );
	add_hint_string( "barrett", &"PRAGUE_ESCAPE_PRESS_FORWARDS_OR_BACKWARDS" );
	add_hint_string( "save_soap", &"PRAGUE_ESCAPE_SOAP_DEATH_OBJ" );
	
	// ^3[{+attack}]^7
	PreCacheString( &"PRAGUE_ESCAPE_HINT_CRAWL_RIGHT" );
	add_hint_string( "HINT_crawl_right", &"PRAGUE_ESCAPE_HINT_CRAWL_RIGHT", maps\prague_escape_flashback_airport_code::hint_crawl_right );
	// ^3[{+speed_throw}]^7
	PreCacheString( &"PRAGUE_ESCAPE_HINT_CRAWL_LEFT" );
	add_hint_string( "HINT_crawl_left", &"PRAGUE_ESCAPE_HINT_CRAWL_LEFT", maps\prague_escape_flashback_airport_code::hint_crawl_left );
}

init_level_flags()
{
	flag_init("statue_go");
	flag_init("dumpster_go");
	flag_init("player_left_statue");
	flag_init("defend_go");
	flag_init( "FLAG_attack_button_pressed" );
	flag_init( "FLAG_ads_button_pressed" );
	flag_init( "FLAG_store_soap_sitting_at_statue" );
	flag_init( "FLAG_street_soap_sitting_by_mailbox" );
	maps\prague_escape_code::init_prague_code_level_flags();
	maps\prague_escape_sniper::init_event_flags();
	maps\prague_escape_scaffold::init_event_flags();
	maps\prague_escape_soap_carry::init_event_flags();
	maps\prague_escape_dumpster::flags_dumpster();
	maps\prague_escape_store::flags_store();
	maps\prague_escape_statue::flags_statue();
	maps\prague_escape_bank::flags_bank();
	maps\prague_escape_defend::flags_defend();
	maps\prague_escape_medic::init_medic_level_flags();
	maps\prague_escape_to_cellar::init_cellar_level_flags();
	maps\prague_escape_flashback_sniper::init_sniper_level_flags();
	maps\prague_escape_flashback_nuke::init_nuke_level_flags();
	maps\prague_escape_flashback_airport::init_airport_level_flags();
	maps\prague_escape_outro::init_outro_level_flags();
}

init_level_globals()
{
	level.objective_iterator = 0;

      SoundSetTimeScaleFactor( "Music", 0 ); 
      SoundSetTimeScaleFactor( "Menu", 0 ); 
      SoundSetTimeScaleFactor( "local3", 0.0 ); 
      SoundSetTimeScaleFactor( "Mission", 0.0 ); 
      SoundSetTimeScaleFactor( "Announcer", 0.0 ); 
      SoundSetTimeScaleFactor( "Bulletimpact", .60 ); 
      SoundSetTimeScaleFactor( "Voice", 0.30 ); 
      SoundSetTimeScaleFactor( "norestrict", 0.20 ); 
      SoundSetTimeScaleFactor( "norestrict2d", 0.20 ); 
      SoundSetTimeScaleFactor( "local", 0.40 ); 
      SoundSetTimeScaleFactor( "physics", 0.20 ); 
      SoundSetTimeScaleFactor( "ambient", 0.40 ); 
      SoundSetTimeScaleFactor( "auto", 0.50 );
}

setup_spawn_funcs()
{
	maps\prague_escape_dumpster::dumpster_spawnfuncs();
	maps\prague_escape_store::courtyard_spawnfuncs();
	maps\prague_escape_statue::tunnel_spawnfuncs();
	maps\prague_escape_bank::bank_spawnfuncs();
	maps\prague_escape_defend::defend_spawnfuncs();
}

setup_level_objects()
{
	maps\prague_escape_dumpster::setup_dumpster();
	maps\prague_escape_statue::setup_statue_ents();
	maps\prague_escape_defend::defend_setup();
	// maps\prague_escape_medic::setup_sniper_uaz();
}

setup_anim_nodes()
{
	
}

setup_start_points()
{
	set_default_start( "sniper" );
	
	// Section 1:  Brian Joyal
	add_start( "sniper",	maps\prague_escape_sniper::start_sniper,
			"Sniper Tower",	maps\prague_escape_sniper::sniper_main );
			
	add_start( "scaffold",	maps\prague_escape_scaffold::start_scaffold,
			"Scaffolding Fall",	maps\prague_escape_scaffold::scaffold_main );
			
	add_start( "soap_carry",	maps\prague_escape_soap_carry::start_soap_carry,
			"Soap Carry",	maps\prague_escape_soap_carry::soap_carry_main );
			
	// Section 2:  June Park		
	add_start( "dumpster", maps\prague_escape_dumpster::start_dumpster,
			"Dumpster to Store", maps\prague_escape_dumpster::dumpster_main );
			
	add_start( "store",	maps\prague_escape_store::start_store,
			"Store to Statue",	maps\prague_escape_store::store_main );
			
	add_start( "statue",	maps\prague_escape_statue::start_statue,
			"Statue to Bank",	maps\prague_escape_statue::statue_main );
			
	add_start( "bank", maps\prague_escape_bank::start_bank,
			"Bank to Plaza", maps\prague_escape_bank::bank_main );
			
	add_start( "defend", maps\prague_escape_defend::start_defend,
			"Plaza Defend", maps\prague_escape_defend::defend_main );
	
	add_start( "resistance_carry", maps\prague_escape_defend::start_resistance_carry,
			"Resistance Carry Soap", maps\prague_escape_defend::resistance_carry_main );
	
	// Section 3:  Damoun Shabestari					
	add_start( "medic",	maps\prague_escape_medic::start_medic,
			"Medic",	maps\prague_escape_medic::medic_main );
			
	add_start( "to_cellar",	maps\prague_escape_to_cellar::start_to_cellar,
			"To Cellar",	maps\prague_escape_to_cellar::to_cellar_main );	
			
	add_start( "flashback_sniper",	maps\prague_escape_flashback_sniper::start_flashback_sniper,
			"Flashback: Sniper",	maps\prague_escape_flashback_sniper::flashback_sniper_main );
			
	add_start( "flashback_nuke",	maps\prague_escape_flashback_nuke::start_flashback_nuke,
			"Flashback: Nuke",	maps\prague_escape_flashback_nuke::flashback_nuke_main );		
			
	add_start( "flashback_airport",	maps\prague_escape_flashback_airport::start_flashback_airport,
			"Flashback: Airport",	maps\prague_escape_flashback_airport::flashback_airport_main );				
			
	add_start( "outro",	maps\prague_escape_outro::start_outro,
			"Outro",	maps\prague_escape_outro::outro_main );		
}



setup_fxanim_notify_tests()
{
	level thread fxanim_test_hotel_explosion();
	level thread fxanim_test_belltower_explosion();
	level thread fxanim_test_rpg_wall();
	level thread fxanim_test_m203_wall();
}

fxanim_test_hotel_explosion()
{
	level waittill( "fxanim_test_hotel_explosion" );
	exploder( 160 ); // Hotel explosion
	
	m_pillars = GetEnt( "fxanim_prague2_hotel_mod", "targetname" );
	m_pillars.animname = "hotel_columns";
	m_pillars UseAnimTree( level.scr_animtree[ "script_model" ] );
	m_pillars thread anim_single_solo( m_pillars, "hotel_explode" );	
}

fxanim_test_belltower_explosion()
{
	level waittill( "fxanim_test_belltower_explosion" );
	maps\prague_escape_scaffold::swap_tower_model( level.player );
	maps\prague_escape_scaffold::tower_explosion_anim( level.player );
	maps\prague_escape_scaffold::scaffolding_anim( level.player );
}

fxanim_test_rpg_wall()
{
	m_wall = getent( "fxanim_rpg_wall", "targetname" );
	m_wall Hide();
	
	m_rpg_wall_destroyed = getentarray( "esc_wall_clean_01", "targetname" );
	foreach( m_wall_piece in m_rpg_wall_destroyed )
	{
		m_wall_piece Hide();
	}	
	
	level waittill( "fxanim_test_rpg_wall" );
	
	m_wall = getent( "fxanim_rpg_wall", "targetname" );
	m_wall Show();
	m_wall UseAnimTree( level.scr_animtree[ "script_model" ] );
	m_wall.animname = "rpg_wall";
	m_wall thread anim_single_solo( m_wall, "rpg_wall_explode" );	
	exploder( 250 );	
	
	m_rpg_wall_destroyed = getentarray( "esc_wall_destroy_01", "targetname" );
	foreach( m_wall_piece in m_rpg_wall_destroyed )
	{
		m_wall_piece Hide();
	}
	
	m_rpg_wall_clean = getentarray( "esc_wall_clean_01", "targetname" );
	foreach( m_wall_piece in m_rpg_wall_clean )
	{
		m_wall_piece Show();
	}	
}

fxanim_test_m203_wall()
{
	m_wall = GetEnt( "fxanim_exit_wall", "targetname" );
	m_wall Hide();
	
	a_m_dest = GetEntArray( "apt_wall_destroyed", "targetname" );
	foreach( m_dest in a_m_dest )
	{
		m_dest Hide();
	}	
	
	level waittill( "fxanim_test_m203_wall" );

	s_wall_moveto = getstruct( "exit_wall_struct", "targetname" );
	
	m_wall MoveTo( s_wall_moveto.origin, 0.05 );	
	
	maps\prague_escape_soap_carry::price_open_wall();
	exploder( 280 );
	m_wall Show();
	m_wall UseAnimTree( level.scr_animtree[ "script_model" ] );
	m_wall.animname = "exit_wall";
	m_wall anim_single_solo( m_wall, "exit_wall_explode" );	
	
	a_m_dest = GetEntArray( "apt_wall_destroyed", "targetname" );
	foreach( m_dest in a_m_dest )
	{
		m_dest Show();
	}
	
	a_m_clean = GetEntArray( "apt_wall_clean", "targetname" );
	foreach( m_clean in a_m_clean )
	{
		//m_clean ConnectPaths();
		m_clean Delete();
	}	
}
