#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;
#include maps\_shg_common;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_to_cellar()
{
	move_player_to_start( "to_cellar_player" );
	
	maps\_compass::setupMiniMap( "compass_map_prague_escape_standoff", "standoff_minimap_corner" );
	
	if ( !IsDefined( level.player ) )
	{
		level.player = GetEntArray( "player", "classname" )[ 0 ];
		level.player.animname = "player_rig";
	}

	level.player EnableDeathShield( true );
	
	setup_hero_for_start( "price", "to_cellar" );
	
	if ( !IsDefined( level.s_price_align ) )
	{
		s_anim_align_soap_death = getstruct( "anim_align_soap_death", "targetname" );

		level.s_price_align = SpawnStruct();
		level.s_price_align.origin = s_anim_align_soap_death.origin;
		level.s_price_align.angles = s_anim_align_soap_death.angles;
				
		level.s_price_align thread anim_loop_solo( level.price, "price_punch_loop" );
	}
		
	battlechatter_off();	
	
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
}

init_cellar_level_flags()
{
	flag_init( "kill_window_bullets" );
	flag_init( "player_opened_door" );
	flag_init( "end_to_cellar" );
	flag_init( "give_punch_headlook" );
	flag_init( "stop_stair_rumble" );
	flag_init( "play_price_door_vo" );
	flag_init( "bottles_go_boom" );
	flag_init( "leader_escape_dialogue02" );
	flag_init( "leader_escape_dialogue03" );
	flag_init( "leader_escape_dialogue04" );
	flag_init( "price_punch_dialog_02" );
	flag_init( "price_punch_dialog_03" );
	
	flag_init( "start_no_sound_bullets" );
}

// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
to_cellar_main()
{
	if ( !IsDefined( level.m_escape_door ) || !IsDefined( level.m_link_pistol ) )
	{
		maps\prague_escape_medic::setup_props();
	}
	
	//level thread no_sound_bullets();
		
	level thread price_punch_player();
	
	flag_wait( "end_to_cellar" );	
}

resistance_leader_escape_dialogue( guy )
{
	level.ai_resistance_leader dialogue_queue( "presc_rl_price" ); //PRICE!
	flag_wait( "leader_escape_dialogue02" );
	level.ai_resistance_leader dialogue_queue( "presc_rl_havetogo" );	//Come on!  We have to go!
	flag_wait( "leader_escape_dialogue03" );
	level.ai_resistance_leader dialogue_queue( "presc_rl_thisway" ); //PRICE!  This way.
	flag_wait( "leader_escape_dialogue04" );
	level.ai_resistance_leader dialogue_queue( "presc_rl_now" ); //You have to go - NOW!
}

no_sound_bullets()
{
	level endon( "stop_no_sound_bullets" );
	
	flag_wait( "start_no_sound_bullets" );

	a_window_bullet_start = getstructarray( "window_bullet_start", "targetname" );
	
	while( 1 )
	{
		n_delta_x = RandomFloatRange( -15, 15 );
		n_delta_y = RandomFloatRange( -15, 15 );
		n_delta_z = RandomFloatRange( -15, 15 );
		
		v_start = a_window_bullet_start[ RandomInt( a_window_bullet_start.size ) ];
		v_end = getstruct( v_start.target, "targetname" );

		MagicBullet( "nosound_magicbullet", v_start.origin, ( v_end.origin + ( n_delta_x, n_delta_y, n_delta_z ) ) );
		
		
		wait( 0.05 );
	}
	
}

price_punch_dialogue( guy )
{	
	//level.price dialogue_queue( "presc_pri_soaptrustedyou" ); 	// Soap trusted you...
	level.price delaythread( 3.8, ::play_sound_on_entity, "scn_prague_de50_chamber_price" );
	
	flag_wait( "price_punch_dialog_02" );
	
	a_bar_shelf_damage = GetEntArray( "e_bar_shelf_damage", "targetname" );
	foreach ( ent in a_bar_shelf_damage )
	{
		RadiusDamage( ent.origin, 50, 50, 25 );
		PhysicsExplosionSphere( ent.origin, 50, 25, 5 );
	}
	
	bar_shelf_collapse = GetEnt( "bar_shelf_collapse", "targetname" );
	bar_shelf_collapse MoveZ( 35, 0.05 );
	bar_shelf_collapse RotatePitch( 90, 0.50 );
	bar_shelf_collapse waittill( "movedone" );
	bar_shelf_collapse MoveZ( -5, 0.05 );	
	
	//level.price dialogue_queue( "presc_pri_thoughticouldtoo" );	// I thought I could too...		
	
	flag_wait( "price_punch_dialog_03" );
	//level.price thread dialogue_queue( "presc_pri_makarovknowyou" ); // So why... In bloody hell, does Makarov know you?
}

price_punch_player()
{
	s_anim_align_soap_death = getstruct( "anim_align_soap_death", "targetname" );

	m_player_rig = spawn_anim_model( "player_rig", level.player.origin );
	m_player_rig.angles = level.player GetPlayerAngles();
	m_player_rig DontCastShadows();
	s_anim_align_soap_death anim_first_frame_solo( m_player_rig, "price_punch" );	
	m_player_rig Hide();
	
	level thread bottles_on_counter();
	level thread price_door_vo();
	
	trig_player_bar_door = GetEnt( "trig_player_bar_door", "targetname" );
	trig_player_bar_door trigger_on();
	trig_player_bar_door waittill( "trigger" );
	trig_player_bar_door Delete();

//	a_vh_btrs = GetEntArray( "alley_btrs", "targetname" );
//	array_thread( a_vh_btrs, ::fire_away_from_door );

	flag_set( "player_opened_door" );
	
	thread set_ambient( "prague_bar_cellar_int" );

	level thread maps\prague_escape_flashback_sniper::setup_no_time_scene();

	//setup stream for first flashback
	sniper_stream_ent = GetEnt( "sniper_stream_ent", "targetname" );
	level.player PlayerSetStreamOrigin( sniper_stream_ent.origin );
	
	level.player SetStance( "stand" );
	level.player DisableWeapons();
	level.player TakeAllWeapons();
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player AllowSprint( false );
	level.player AllowJump( false );
	level.player AllowAds( false );
	
	//hide hud
	maps\prague_escape_code::hide_player_hud();
	
	if ( IsDefined( level.s_price_align ) )
	{
		level.s_price_align notify( "stop_loop" );
	}
	
	//Give Price the pistol
	level.price gun_remove();
	level.price forceUseWeapon( "deserteagle", "primary" );
	
	level thread sniper_transition_timer();
	
	n_lerp_time = .25;
	
	level.player PlayerLinkToBlend( m_player_rig, "tag_player", n_lerp_time, n_lerp_time * 0.25, n_lerp_time * 0.25 );
	wait n_lerp_time;	
	m_player_rig Show();
	level.player PlayerLinkToAbsolute( m_player_rig, "tag_player" );

	//Headlook wait
	level thread headlook_wait( m_player_rig );
	
	a_anim_ents = [];
	a_anim_ents[0] = level.price;
	a_anim_ents[1] = m_player_rig;
	a_anim_ents[2] = level.m_escape_door;
	
		//vehicle spawners	
	a_vh_btrs = GetEntArray( "alley_btrs", "targetname" );
	array_thread( a_vh_btrs, ::self_delete );
		
	//delete btrs
	
	s_anim_align_soap_death = getstruct( "anim_align_soap_death", "targetname" );
	level.s_price_align = SpawnStruct();
	level.s_price_align.origin = s_anim_align_soap_death.origin;
	level.s_price_align.angles = s_anim_align_soap_death.angles;
	
	level.player delaythread(.05, ::play_sound_on_entity, "scn_prague_player_downstairs" );
	level.s_price_align anim_single( a_anim_ents, "price_punch" );
	a_anim_ents = array_remove( a_anim_ents, level.price );		
	level.s_price_align anim_last_frame_solo( level.price, "price_punch" );	
	 
	m_player_rig Delete();
	level.m_escape_door Delete(); //door we open
	level.m_link_pistol Delete(); //pistol thats on soap

	//Stop Bloom out windows
//	stop_exploder( 1110 );
//	stop_exploder( 1111 );
//	stop_exploder( 1112 );	
}

bottles_on_counter()
{
	flag_wait( "bottles_go_boom" );

	wait( 0.10 );
	
	s_physics_0 = getstruct( "s_physics_0", "targetname" );
	PhysicsExplosionSphere( s_physics_0.origin, 5, 5, 1 );
		
	s_physics_1 = getstruct( "s_physics_1", "targetname" );
	PhysicsExplosionSphere( s_physics_1.origin, 5, 5, 1 );
	
	wait( 0.25 );

	s_physics_2 = getstruct( "s_physics_2", "targetname" );
	PhysicsExplosionSphere( s_physics_2.origin, 5, 5, 1 );

	wait( 0.25 );

	s_physics_3 = getstruct( "s_physics_3", "targetname" );
	PhysicsExplosionSphere( s_physics_3.origin, 5, 5, 1 );
}

price_door_vo()
{
	trig_player_bar_door = GetEnt( "play_price_door_vo", "targetname" );

	
	if( isdefined(trig_player_bar_door) )
	{
		trig_player_bar_door waittill("trigger");
	}
	s_physics_frame_door = getstruct( "s_physics_frame_door", "targetname" );
	PhysicsExplosionSphere( s_physics_frame_door.origin, 5, 5, 1 );
	
	level.price dialogue_queue( "presc_pri_yuriopenit" ); //Yuri! Open it!
}

punch_blink_blur( guy )
{
	level.player DisableInvulnerability();	
	music_stop(1);
	s_punch_magic_bullet = getstruct( "s_punch_magic_bullet", "targetname" );
	MagicBullet( "nosound_magicbullet", s_punch_magic_bullet.origin, level.player.origin + (0,0,40 ) );
	level.player DoDamage( 99, s_punch_magic_bullet.origin );
	
	stop_exploder(1100);

	vh_alley_btr_1 = GetEnt( "vh_alley_btr_1", "script_noteworthy" );
	
	if( isdefined( vh_alley_btr_1 ) )
	{
		vh_alley_btr_1 Delete();
	}
	
	vh_alley_btr_2 = GetEnt( "vh_alley_btr_2", "script_noteworthy" );
	
	if( isdefined( vh_alley_btr_2 ) )
	{
		vh_alley_btr_2 Delete();
	}
		
	level.player ShellShock( "prague_escape", 5 );
	level.player PlayRumbleOnEntity( "grenade_rumble" );	
	
	level.player PlaySound( "scn_prague_price_punch_face" );
	level.player thread play_sound_on_entity( "breathing_hurt" );
	
	blur_time = 5;
	set_screen_fade_timer( 0.05 );
	level	thread screen_fade_out();		
	delaythread( 0.25, ::screen_fade_in );
	SetBlur( 3, 3 );
	wait blur_time;
	SetBlur( 0, 3 );
	
	s_stair_top_pulse	= getstruct( "stair_top_pulse", "targetname" );
	PhysicsExplosionSphere( s_stair_top_pulse.origin, 5, 5, 1 );
}

stair_fall_rumble( guy )
{
	level.player PlayRumbleLoopOnEntity( "tank_rumble" );
	flag_wait( "stop_stair_rumble" );
	level.player StopRumble( "tank_rumble" );
}

headlook_wait( m_player_rig )
{
	flag_wait( "give_punch_headlook" );

	wait( 2 );

	flag_set( "kill_window_bullets" );		
	flag_set( "start_no_sound_bullets" );	

	n_lerp_time = .25;
	
	level.player PlayerLinkToBlend( m_player_rig, "tag_player", n_lerp_time, n_lerp_time * 0.25, n_lerp_time * 0.25 );
	level.player PlayerLinkToDelta( m_player_rig, "tag_player", 0, 15, 15, 5, 5, true );	
}

sniper_transition_timer()
{
	flag_wait( "price_punch_dialog_03" );

	wait( 5.3 );
	level notify( "stop_no_sound_bullets" );	
	
	level.player PlaySound( "scn_prague_flash_sniperescape" );
	thread set_ambient( "prague_flashback_sniperescape" );
	flashback_teleport( "end_to_cellar", "start_no_time_scene", "prague_escape_sniper_outside", 0.25, 2, "presc_yri_firstmetmakarov" );
}
