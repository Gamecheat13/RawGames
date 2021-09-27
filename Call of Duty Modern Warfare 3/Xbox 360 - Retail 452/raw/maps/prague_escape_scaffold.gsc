#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_shg_common;
#include maps\prague_escape_code;
#include maps\_utility_chetan;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_scaffold()
{
	setup_hero_for_start( "soap", "scaffold" );
	setup_hero_for_start( "price", "scaffold" );
	
	move_player_to_start( "start_scaffold" );
	
	m_tower = getent( "fxanim_prague2_bell_tower_mod", "targetname" );
	m_tower Hide();
	
	maps\_compass::setupMiniMap( "compass_map_prague_escape_sniper", "sniper_minimap_corner" );
	
	e_rifle = getent( "bell_tower_sniper_rifle", "targetname" );
	e_rifle Delete();	
	
	level.price place_weapon_on( "m4m203_reflex", "back" );
	level.price forceUseWeapon( "m4m203_reflex", "primary" );		
	
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
}

// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
scaffold_main()
{
	// Safety check.  Flag will be set if player fires too early in the previous section
	while( flag( "sniper_cover_blown" ) )
	{
		wait .05;	
	}	
	
	/#
	iprintln( "scaffold" );
	#/
		
	//theres a save after the fall is done	
	//maps\_autosave::_autosave_game_now_nochecks(); // no gun, no ammo.  Force the save
		
	event_setup();
	m_player_rig = bell_tower_trap();
	intro_clear_fx();
	scaffolding_fall( m_player_rig );
	price_approach();
	scaffold_cleanup();
}

intro_clear_fx()
{
	fx_ids = [ [ "trash_spiral_far_runner_prague_esc", 		( 18745.4, 8796.03, -79.875 ) ],
			   [ "trash_spiral_far_runner_prague_esc", 		( 19946.9, 9179.49, -72 ) ],
			   [ "trash_spiral_far_runner_prague_esc", 		( 18981.3, 8054.98, -80 ) ],
			   [ "trash_spiral_far_runner_prague_esc", 		( 18303.2, 9894.09, -44.1296 ) ],
			   [ "trash_spiral_far_runner_prague_esc", 		( 19846.6, 7593.36, -72 ) ],
			   [ "trash_spiral_far_runner_prague_esc", 		( 20886, 9753.61, -72 ) ],
			   [ "small_fire_far_prague_esc", 				( 17101.4, 10208.3, -78.8362 ) ],
			   [ "small_fire_far_prague_esc", 				( 19566.3, 8045.61, -30.9095 ) ],
			   [ "small_fire_far_prague_esc", 				( 19366.6, 9680.44, -79.875 ) ],
			   [ "medium_fire_far_prague_esc", 				( 19398.9, 9795.79, -84.8909 ) ],
			   [ "medium_fire_far_prague_esc", 				( 18696.3, 8406.62, -83 ) ],
			   [ "medium_fire_far_prague_esc", 				( 17627.3, 9444.32, -79.875 ) ] ];
	delete_createFXent_fx( fx_ids );
}

init_event_flags()
{
	flag_init( "scaffold_use_limp_a" );
	flag_init( "scaffold_use_limp_b" );
	flag_init( "soap_injured_dialogue_2" );
	flag_init( "soap_injured_dialogue_3" );
	flag_init( "soap_injured_dialogue_4" );
	flag_init( "scaffolding_fall_dialogue_2" );
	flag_init( "scaffolding_fall_dialogue_3" );
}

event_setup()
{	
	default_screen_fade_settings();
	
	// clean up from sniper
	a_enemies = GetAIArray( "axis" );
	array_delete( a_enemies );
	
	a_price_followers = GetEntArray( "scaffold_price_followers", "targetname" );
	array_thread( a_price_followers, ::add_spawn_function, ::price_follower_spawnfunc );
	
	level.player EnableInvulnerability();
}

bell_tower_trap()
{
	s_align = getstruct( "anim_align_belltower", "targetname" );
	
	m_player_rig = spawn_anim_model( "player_rig", level.player.origin );
	m_player_rig.angles = level.player GetPlayerAngles();

	level.player PlayerLinkToDelta( m_player_rig, "tag_player", 1, 10, 10, 10, 10, 0 );
	m_player_rig dontcastshadows();
	level.m_sniper_model = spawn( "script_model", m_player_rig GetTagOrigin( "tag_weapon" ) );
	level.m_sniper_model.angles = m_player_rig GetTagAngles( "tag_weapon" );
	level.m_sniper_model SetModel( "viewmodel_rsass_sp_iw5" );
	level.m_sniper_model LinkTo( m_player_rig, "tag_weapon" );	
	level.m_sniper_model hidepart( "tag_clip", "viewmodel_rsass_sp_iw5" );
	level.m_sniper_model hidepart( "TAG_MOTION_TRACKER", "viewmodel_rsass_sp_iw5" );	
	
	s_align anim_first_frame_solo( m_player_rig, "scaffolding_fall" );
	
	level.price delaythread (1.6, ::dialogue_queue, "presc_mkv_yurimyfriend" );
	// wait( 3 );
	
	return m_player_rig;
}

scaffolding_fall( m_player_rig )
{
	wait(1);
	level thread scaffold_fall_shellshock();
	level thread soap_steam_fx();
	s_align = getstruct( "anim_align_belltower", "targetname" );
	s_align_debris = getstruct( "anim_align_scaffold", "targetname" );

	a_debris_models = make_array( "paris_debris_burnt_wood_panels_05", "debris_rubble_chunk_09", "ny_debris_rubble_chunk_01", "debris_wood_shard_large", "debris_wood_shard_med" );
	a_debris_jnt = [];
	a_debris = [];
	
	for( i = 0; i < a_debris_models.size; i++ )
	{
		a_debris_jnt[i] = spawn_anim_model( "debris0" + (i+1), s_align_debris.origin );
		a_debris_jnt[i].angles = s_align.angles;
		a_debris[i] = spawn( "script_model", a_debris_jnt[i].origin );
		a_debris[i].angles = s_align.angles;
		a_debris[i] SetModel( a_debris_models[i] );
		a_debris[i] LinkTo( a_debris_jnt[i], "origin_animate_jnt" );
	}
	
	s_align_debris anim_first_frame( a_debris_jnt, "scaffolding_fall" );
	
	a_anim_ents = make_array( m_player_rig, level.soap );
	
	//level.player PlayerLinkToAbsolute( m_player_rig, "tag_player" );
	
	level.player delaythread(.05, ::play_sound_on_entity, "scn_prague_player_scaffold_fall" );
	n_anim_length = GetAnimLength( level.scr_anim[ "player_rig" ][ "scaffolding_fall" ] );
	s_align thread anim_single( a_anim_ents, "scaffolding_fall" );	
	s_align_debris thread anim_single( a_debris_jnt, "scaffolding_fall" );
	musicstop(1);
	
	
	wait( n_anim_length - 2 );
	level thread screen_fade_out();
	wait( 2 );
	level.player Unlink();
	m_player_rig Delete();	
	
	array_delete( a_debris_jnt );
	array_delete( a_debris );
}

soap_steam_fx()
{
	wait(6.85);
	playfxontag( getfx( "soap_steam"), level.soap, "J_HEAD" );
	wait(5);
	stopfxontag( getfx( "soap_steam"), level.soap, "J_HEAD" );
}	

scaffold_fall_shellshock()
{
	n_anim_length = GetAnimLength( level.scr_anim[ "player_rig" ][ "scaffolding_fall" ] );
	wait( n_anim_length - 5.5 );
	
	level.player ShellShock( "prague_escape", 25 );	
}

price_approach()
{
	exploder( 226 );	// soap blood pool
	s_align = getstruct( "anim_align_scaffold", "targetname" );
	
	n_fade_time = 2;

	level thread scaffold_debris_anims();
	
	level thread price_run_anims();
	level thread price_followers();
	
	m_player_rig = spawn_anim_model( "player_rig", level.player.origin );
	m_player_rig.angles = level.player GetPlayerAngles();
	
	level.player.m_player_rig = m_player_rig;
	
	a_anim_ents = make_array( m_player_rig, level.soap );
	level.player.m_player_rig dontcastshadows();
	level.player PlayerLinkToDelta( m_player_rig, "tag_player", 1, 20, 20, 10, 10, true );
	flag_set( "scaffold_use_limp_a" );	
	level thread shellshock_cowbell();
	level thread screen_fade_in();
	n_anim_length = GetAnimLength( level.scr_anim[ "player_rig" ][ "fade_in_a" ] );
	level thread explosion_behind_price();
//	s_align thread anim_single( a_anim_ents, "fade_in_a" );
//	wait( n_anim_length );
//	wait( n_anim_length - n_fade_time );
//	level thread screen_fade_out();
//	wait( n_fade_time );
	flag_set( "scaffold_use_limp_b" );
	n_anim_length = GetAnimLength( level.scr_anim[ "player_rig" ][ "fade_in_b" ] );
	s_align thread anim_single( a_anim_ents, "fade_in_b" );
//	level thread screen_fade_in();
	wait( n_anim_length - n_fade_time );
	
	level thread screen_fade_out();
	wait( n_fade_time );
	n_anim_length = GetAnimLength( level.scr_anim[ "player_rig" ][ "scaffold_soap_injured" ] );
	a_anim_ents = array_add( a_anim_ents, level.price );
	
	level notify( "start_scaffold_soap_injured" );
	s_align thread anim_single( a_anim_ents, "scaffold_soap_injured" );
	level thread screen_fade_in();
	
	wait( n_anim_length );
}

shellshock_cowbell()
{
	//vehicles in the read when player is shellshocked on ground
	array_spawn_function_targetname("fountain_btr", ::fountain_btr_shoot_logic );
	spawn_vehicle_from_targetname_and_drive("shellshock_btr");
	spawn_vehicle_from_targetname_and_drive("shellshock_chopper1");
	
	delaythread(5, ::spawn_vehicle_from_targetname_and_drive, "fountain_btr" );
	delaythread(5, ::spawn_vehicle_from_targetname_and_drive, "shellshock_chopper2" );
	delaythread(3, ::spawn_vehicle_from_targetname_and_drive, "shellshock_btr");
	delaythread(6, ::spawn_vehicle_from_targetname_and_drive, "shellshock_btr");
	
	spots = getstructarray("dest_damage", "targetname");
	foreach( struct in spots )
	{
		level thread damage_when_player_is_close( struct.origin );
	}
	
}

damage_when_player_is_close(spot )
{
	flag_wait("soap_picked_up");
	dist = distancesquared (level.player.origin, spot );
	while( dist > 300*300 )
	{
		dist = distancesquared (level.player.origin, spot );
		wait(.15);
	}
	//iprintlnbold( "damage" );
	RadiusDamage( spot, 50, 1000, 1000, level.player );	
}	

fountain_btr_shoot_logic()
{
	level endon("clear_path_loop_started");
	self thread maps\prague_escape_sniper::delete_on_flag( "clear_path_loop_started" );
	flag_wait("soap_picked_up");
	while(1)
	{
		offset = randomintrange(400, 450);		
		self setturrettargetvec( level.player.origin +(offset, offset, 0) );
		wait(1);
		fire_at_target();	
		wait( randomfloatrange( .6, 1.4) );
	}	
}		


fire_at_target()
{
	level endon("clear_path_loop_started");
	self endon ("death");
	burstsize = RandomIntRange( 5, 12 );
	fireTime = 0.1;
	for ( i = 0; i < burstsize; i++ )
	{
		self FireWeapon();
		wait fireTime;
	}
}

price_followers()
{
	a_follower_spawners = GetEntArray( "scaffold_price_followers", "targetname" );
	array_thread( a_follower_spawners, ::spawn_ai, true );
}

price_run_anims()
{
	s_align = getstruct( "anim_align_scaffold", "targetname" );
	
	flag_wait( "scaffold_use_limp_a" );
	s_align thread anim_single_solo( level.price, "limp_a" );
	
	flag_wait( "scaffold_use_limp_b" );
	s_align anim_single_solo( level.price, "limp_b" );
}

explosion_behind_price()
{
	wait( 3 );
	
	s_price_start = getstruct( "scaffold_fall_price_run_start", "targetname" );
	
	PlayFX( level._effect[ "grenade_exp_concrete" ], level.price.origin );
}

scaffold_debris_anims()
{
	s_align = getstruct( "anim_align_scaffold", "targetname" );
	a_debris_models = make_array( "paris_debris_burnt_wood_panels_05", "debris_rubble_chunk_09", "ny_debris_rubble_chunk_01", "debris_wood_shard_large", "debris_wood_shard_med" );
	a_debris_jnt = [];
	
	for( i = 0; i < a_debris_models.size; i++ )
	{
		a_debris_jnt[i] = spawn_anim_model( "debris0" + (i+1), s_align.origin );
		a_debris_jnt[i].angles = s_align.angles;
		m_debris = spawn( "script_model", a_debris_jnt[i].origin );
		m_debris.angles = s_align.angles;
		m_debris SetModel( a_debris_models[i] );
		m_debris LinkTo( a_debris_jnt[i], "origin_animate_jnt" );
	}
	
	s_align anim_first_frame( a_debris_jnt, "scaffold_soap_injured" );
	
	level waittill( "start_scaffold_soap_injured" );
	
	s_align anim_single( a_debris_jnt, "scaffold_soap_injured" );
}

scaffold_cleanup()
{
	level.player DisableInvulnerability();
}

scaffold_fall_timescale_start( guy )
{
	SetTimeScale( .25 );
}

scaffold_fall_timescale_stop( guy )
{
	SetTimeScale( 1 );
}

swap_tower_model( guy )
{
	m_tower = getent( "fxanim_prague2_bell_tower_mod", "targetname" );
	m_tower Show();	
}

tower_explosion_anim( guy )
{
	m_tower = getent( "fxanim_prague2_bell_tower_mod", "targetname" );
	m_tower.animname = "bell_tower";
	m_tower UseAnimTree( level.scr_animtree[ "script_model" ] );
	
	level.soap StopLoopSound();
	exploder( 210 );
	
	m_tower anim_single_solo( m_tower, "bell_tower_explode" );
}

scaffolding_anim( guy )
{
	m_scaffold = getent( "fxanim_prague2_bell_tower_scaf_mod", "targetname" );
	m_scaffold.animname = "scaffold";
	m_scaffold UseAnimTree( level.scr_animtree[ "script_model" ] );

	exploder( 227 );
	m_scaffold thread anim_single_solo( m_scaffold, "scaffold_break" );
	
	wait( 5 );
	
	exploder( 224 );
}

scaffolding_fall_dialogue( guy )
{
	thread start_scaffold_blinking_light();
	//level.soap thread dialogue_queue( "presc_mct_hellshetalkinabout" );
	flag_wait( "scaffolding_fall_dialogue_3" );
	//level.soap thread dialogue_queue( "presc_mct_shite" );		
	level.m_sniper_model Delete();
}

start_scaffold_blinking_light()
{
	wait( 1.5 );
	level.soap PlayLoopSound( "scn_prague_belltower_bomb_beep" );	
	exploder( 209 ); // bomb flashing lights inside bell tower	
}

soap_injured_dialogue( guy )
{
	level.price dialogue_queue( "presc_pri_soap" );
	flag_wait( "soap_injured_dialogue_2" );
	level.price dialogue_queue( "presc_pri_igotyouson" );
	flag_wait( "soap_injured_dialogue_3" );
	level.price dialogue_queue( "presc_pri_yuri" );
	flag_wait( "soap_injured_dialogue_4" );
	level.price dialogue_queue( "presc_pri_grabsoap" );
}

scaffold_bell_impact( guy )
{
	level.player thread play_sound_on_entity( "scn_prague_belltower_bell_land" );
	exploder( 225 );
	level thread swap_soap_model();
	maps\prague_escape_code::play_extreme_rumble();
	
}

soap_injured_explosion( guy )
{
	s_grenade_spot = getstruct( "struct_soap_injured_explosion", "targetname" );
	MagicGrenade( "fraggrenade", s_grenade_spot.origin + ( 0, 0, 4 ), s_grenade_spot.origin, .05 );
}

scaffold_m203_fire( guy )
{
	s_point = getstruct( "price_203_car", "targetname" );//anim_align_scaffold //scaffold_m203_fire_spot
	maps\prague_escape_soap_carry::m203_fake_fire( s_point.origin );
}

scaffold_soap_hit_board_1( guy )
{
	exploder( 220 );
}

scaffold_player_hit_board_2( guy )
{
	maps\prague_escape_code::play_extreme_rumble_and_earthquake();
	exploder( 221 );
}

scaffold_player_hit_ground( guy )
{
	maps\prague_escape_code::play_extreme_rumble_and_earthquake();
	exploder( 229 );
}

debris_lift( guy )
{
	exploder( 230 );
}

debris_fall( guy )
{
	exploder( 231 );
}

price_follower_spawnfunc()
{
	self waittill( "goal" );
	self bloody_death();
}

coutyard_amb_zone( guy )
{
	level thread maps\_utility::set_ambient( "prague_city_courtyard_chase" );
}

swap_soap_model()
{
	//level.soap codescripts\character::new();
	level.soap character\character_hero_europe_soap_injured::main();
}	