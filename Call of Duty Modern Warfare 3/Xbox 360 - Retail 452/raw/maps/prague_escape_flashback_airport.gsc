#include maps\_hud_util;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;
#include maps\_shg_common;
#include maps\prague_escape_flashback_airport_code;
#include maps\_utility_chetan;

start_flashback_airport()
{
	move_player_to_start( "flashback_airport_player" );
	
	if ( !IsDefined( level.player ) )
	{
		level.player = GetEntArray( "player", "classname" )[ 0 ];
		level.player.animname = "player_rig";
	}
	
	flag_set( "start_betray_me_scene" );
	
	level.player vision_set_fog_changes( "prague_escape_airport", 0 );
	
	//hide hud
	maps\prague_escape_code::hide_player_hud();
	
	level.player EnableDeathShield( true );
	level.player TakeAllWeapons();

	level.player AllowSprint( false );
	level.player AllowJump( false );
	level.player AllowCrouch( false );
	level.player AllowProne( false );

	level.flashback_overlay = NewClientHudElem( level.player );
	level.flashback_overlay.horzAlign = "fullscreen";
	level.flashback_overlay.vertAlign = "fullscreen";
	level.flashback_overlay SetShader( "overlay_flashback_blur", 640, 480 );
	level.flashback_overlay.archive = true;
	level.flashback_overlay.sort = 10;
			
	battlechatter_off();	
	
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
}

init_airport_level_flags()
{
	flag_init( "FLAG_adsing" );
	flag_init( "start_betray_me_scene" );
	flag_init( "FLAG_betray_me_scene_paused" );
	flag_init( "FLAG_betray_me_scene_finished" );
	flag_init( "start_gunshot_blackout" );
	
	flag_init( "FLAG_airport_player_collapsed_in_elevator" );
	flag_init( "makarov_shoots_yuri" );
	flag_init( "start_elevator_hand" );
	flag_init( "player_hits_button" );
	flag_init( "FLAG_airport_player_exits_elevator" );
	flag_init( "player_grabbed_pistol" );
	flag_init( "start_blackout_anim" );
	flag_init( "open_elevator_doors" );	
	flag_init( "close_elevator_doors" );
	flag_init( "stairs_go_up" );
	flag_init( "setup_emt_anim" );
	flag_init( "emt_begin" );
	flag_init( "emt_end" );
	flag_init( "play_hand_print" );	
	flag_init( "stop_hand_print" );
	flag_init( "play_falling_tiles" );
	flag_init( "elevator_is_up" );
	flag_init( "FLAG_airport_player_blackout_at_end" );
	flag_init( "FLAG_airport_player_blackout_ended" );
	
	flag_init( "good_state_heart" );
	flag_init( "mild_state_heart" );
	flag_init( "bad_state_heart" );
	
	flag_init( "mak_betray_dialog_02" );
	flag_init( "mak_betray_dialog_03" );
	flag_init( "mak_betray_dialog_04" );
	flag_init( "mak_betray_dialog_05" );
	
	flag_init( "start_emt_dialogue" );
	
	SetDvarIfUninitialized( "pause", 0 );
}

flashback_airport_main()
{
	level.player shellshock( "prague_escape_flashback", 10 );
	thread set_ambient( "prague_flashback_airportgarage" );
	//level thread autosave_by_name_silent( "flashback_airport" );	
	maps\_autosave::_autosave_game_now_nochecks(); // no gun, no ammo.  Force the save

	button_off = GetEnt( "button_off", "targetname" );
	button_off Show();
	
	button_on = GetEnt( "button_on", "targetname" );
	button_on Hide();

	//deagle_stream = GetEnt( "e_deagle_stream", "targetname" );
	//deagle_stream Hide();

	level.player EnableDeathShield( true );
	level.player TakeAllWeapons();

	level.player AllowSprint( false );
	level.player AllowJump( false );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player player_speed_percent( 40 );
	level.player.g_speed_percent = 0.4;

	setup_intro_scene();
	betray_me_scene();
	elevator_sequence();

	flag_wait( "emt_end" );
}

setup_intro_scene()
{
	airport_kiril 	= GetEnt( "ai_airport_kiril", "targetname" );
	airport_lev 	= GetEnt( "ai_airport_lev", "targetname" );
	makarov_spawner = GetEnt( "airport_makarov", "targetname" );
		
	airport_kiril add_spawn_function( ::init_airport_goons );
	airport_lev add_spawn_function( ::init_airport_goons );
	makarov_spawner add_spawn_function( ::init_airport_goons );

	level.airport_kiril = airport_kiril spawn_ai( true );
	level.airport_lev 	= airport_lev spawn_ai( true );
	level.makarov 		= makarov_spawner spawn_ai( true );
		
	level.airport_kiril.animname 	= "kiril";
	level.airport_lev.animname 		= "lev";
	level.makarov.animname 			= "makarov";
	
	level.makarov gun_remove();
	level.makarov forceUseWeapon( "deserteagle", "primary" );
	
	thread setup_intro_toggle_ai_weapons();
}

setup_intro_toggle_ai_weapons()
{
	wait 0.1;
	
	level.airport_kiril HidePart_AllInstances( "tag_weapon" );
	level.airport_kiril HidePart_AllInstances( "tag_sight_on" );
	level.airport_lev HidePart_AllInstances( "tag_weapon" );
	level.airport_lev HidePart_AllInstances( "tag_sight_on" );
	level.airport_lev HidePart_AllInstances( "tag_clip" );
}

init_airport_goons()
{
	self endon( "death" );

	self.ignoreme 	= true;
	self.ignoreall 	= true;
	self.goalradius = 32;
}

betray_me_scene()
{
	//TEMP UNTIL WE GET NOTETRACKS
	thread medic_dialogue();
	
	align_to_elevator = getstruct( "anim_align_elevator", "targetname" );
	
	level.player_rig 			= spawn_anim_model( "player_rig_airport", level.player.origin );
	level.player_rig.angles 	= level.player GetPlayerAngles();	
	level.player_rig.animname 	= "player_rig";
	
	anim_ents = [ level.makarov,
				  level.airport_kiril,
				  level.airport_lev,
				  level.player_rig ];

	align_to_elevator anim_first_frame( anim_ents, "betray_me" );

	flag_wait( "start_betray_me_scene" );

	SetDvar( "pause", 0 );
	
	level.player LerpFOV( 60, 0.05 );
	level.player.ignoreme = true;
	
	thread intro_blur();

	delayThread( 3.0, ::music_play, "prague_escape_airport_makarov_intro" );
	
	level.player PlayerLinkToDelta( level.player_rig, "tag_player", 1, 15, 15, 10, 0, true );
	level.player delayCall( 10, ::LerpViewAngleClamp, 3, 1.5, 1.5, 0, 0, 0, 0 );
	level.player delayCall( 13.05, ::LerpViewAngleClamp, 0, 0.05, 0.05, 15, 15, 10, 0 );

	thread gunshot_blackout();		//TEMP - until notetrack
	thread player_shot(); 	//TEMP - until notetrack
	
	thread betray_me_scene_pause();
	
	level.player thread play_sound_on_entity( "ch_pragueb_15_1_betray_me_makarov" );
	align_to_elevator anim_single( anim_ents, "betray_me" );
	if ( flag( "FLAG_betray_me_scene_paused" ) )
		level waittill( "forever" );
	array_thread( anim_ents, ::self_delete );
	flag_set( "FLAG_betray_me_scene_finished" );
	
	airport_stream_ent = GetEnt( "e_airport_stream_ent", "targetname" );
	airport_stream_ent Delete();
}

betray_me_scene_pause()
{
	start_time = GetTime();
	
	for ( ; !flag( "FLAG_betray_me_scene_finished" ) && !GetDvarInt( "pause", 0 ); wait 0.05 ){}
	
	if ( flag( "FLAG_betray_me_scene_finished" ) || !IsDefined( level.player_rig ) )
		return;
	flag_set( "FLAG_betray_me_scene_paused" );
		
	end_time = GetTime();
	level notify( "LISTEN_end_script" );
	set_screen_fade_timer( 0.05 );
	screen_fade_out();
	screen_fade_in();
	
	// Setup scene again
	elapsed = ( end_time - start_time ) / 1000;
	
	thread anim_single_freeze_frame_player( level.player_rig, elapsed, "betray_me" );
	spawner = GetEnt( "airport_makarov", "targetname" );
	thread ai_anim_single_freeze_frame( level.makarov, spawner, elapsed, "betray_me" );
	spawner = GetEnt( "ai_airport_kiril", "targetname" );
	thread ai_anim_single_freeze_frame( level.airport_kiril, spawner, elapsed, "betray_me" );
	spawner = GetEnt( "ai_airport_lev", "targetname" );
	thread ai_anim_single_freeze_frame( level.airport_lev, spawner, elapsed, "betray_me" );
}

betray_me_struggle_exert( guy )
{
	level.player play_sound_on_entity( "prague_escape_yri_groanexert" );
}

betray_me_struggle_pain( guy )
{
	level.player play_sound_on_entity( "prague_escape_yri_groanpain" );
}

player_shot()
{
	level endon( "LISTEN_end_script" );
	
	wait( 1 );	
	level.player PlayRumbleOnEntity( "damage_heavy" );	
	wait( 1.5 );	
	level.player PlayRumbleOnEntity( "damage_heavy" );
	wait( 1.5 );
	level.player PlayRumbleOnEntity( "damage_heavy" );	
	wait( 1.5 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
		
	flag_wait( "makarov_shoots_yuri" );
	
	level.player thread play_sound_on_entity( "prague_escape_yri_groanpain" );
	
	PlayFXOnTag( getfx( "desert_eagle_flash" ), level.makarov, "tag_flash" );
	s_makarov_bullet_start = getstruct( "makarov_bullet_start", "targetname" );
	MagicBullet( "deserteagle", s_makarov_bullet_start.origin, level.player.origin + ( 0,0,40 ) );		
	level.player DoDamage( 99, s_makarov_bullet_start.origin );
	
	level.player PlayRumbleOnEntity( "grenade_rumble" );	
		
	player_blink();
	wait( 1 );
	level.player thread play_sound_on_entity( "breathing_hurt" );	
	player_blink();	
	wait( 1 );
	player_blink();	
}

gunshot_blackout()
{
	level endon( "LISTEN_end_script" );
	
	set_screen_fade_shader( "black" );
	set_screen_fade_timer( 2.5 );
	
	flag_wait( "start_gunshot_blackout" );
	
	level.player DoDamage( 200, level.player.origin );
	level.player PlayRumbleOnEntity( "grenade_rumble" );	
	level.player thread play_sound_on_entity( "breathing_hurt" );
	
	wait( 5 );
	
	level.player SetBlurForPlayer( 3, 2 );	
	screen_fade_out();
}

player_blink( guy )
{
	set_screen_fade_shader( "black" );
	set_screen_fade_timer( 0.50 );

	level.player SetBlurForPlayer( 3, 2 );
	screen_fade_out();
	set_screen_fade_timer( 1 );	
	screen_fade_in();		
	level.player SetBlurForPlayer( 0, 4 );
}

crawl_in_player_blink( guy )
{
	set_screen_fade_shader( "black" );
	set_screen_fade_timer( 0.50 );

	level.player SetBlurForPlayer( 3, 2 );
	screen_fade_out();
	set_screen_fade_timer( 2.5 );	
	wait( 1 );
	screen_fade_in();		
	level.player SetBlurForPlayer( 0, 4 );	
}

elevator_sequence()
{
	thread airport_elevator();
	thread lobby_dead_bodies();
	thread casual_killers();
	
	thread monitor_attack_button_pressed();
	thread monitor_ads_button_pressed();
	thread monitor_ads();
	
	elevator = GetEnt( "airport_elevator", "targetname" );
	_align_to_evelator = getstruct( "anim_align_elevator", "targetname" );
	align_to_evelator = Spawn( "script_origin", _align_to_evelator.origin );
		
	level.elevator_start = Spawn( "script_origin", elevator.origin );
	level.elevator_start.angles = elevator.angles;
	
	level.player_rig 			= spawn_anim_model( "player_rig_airport", level.player.origin );
	level.player_rig.angles 	= level.player GetPlayerAngles();
	level.player_rig.animname 	= "player_rig";
	level.player_rig DontCastShadows();
	level.player_rig Hide();
	
	elevator LinkTo( level.elevator_start );
	level.player_rig LinkTo( level.elevator_start );
	align_to_evelator LinkTo( level.elevator_start );

	thread fade_to_crawl_to_elevator();

	level.player player_limp_init();
	level.player thread player_heartbeat();
	
	thread crawl_to_elevator_sounds();
	crawl_to_elevator();
	
	flag_wait( "elevator_is_up" );
	
	thread wounded_civs();
	wakeup_in_elevator();
	
	// Start limp after waking up in elevator
	thread player_blackout_monitor();
	thread player_blackout_elevator_timeout();
	waittill_player_exit_elevator();
	level.player notify( "LISTEN_end_player_limp" );
	
	if ( flag( "FLAG_airport_player_blackout_at_end" ) )
		return;
	
	//thread airplane_takeoff();

	flag_set( "FLAG_airport_player_exits_elevator" );	
	
	thread player_blackout_timeout();
	thread player_blackout_triggers();
	thread player_blackout_shoot_at_enemies();
	
	wait 0.50;
	
	align_to_evelator notify( "stop_loop" );
	
	thread exit_elevator_stand_player_blink();
	
	// Player stumbles out of elevator
	align_to_evelator thread anim_single_solo( level.player_rig, "elevator_crawl_out" );
	
	thread set_ambient( "prague_flashback_airportterminal" );
	
	// Lerp player into position for animation
	wait 0.25;
	lerp_time = 1.0;
	level.player PlayerLinktoBlend( level.player_rig, "tag_player", lerp_time, lerp_time * 0.5, lerp_time * 0.5 );
	wait lerp_time;
	level.player PlayerLinkToDelta( level.player_rig, "tag_player", 1, 15, 15, 10, 10, true );
	level.player_rig Show();
	level.player_rig CastShadows();
	length = GetAnimLength( level.player_rig getanim( "elevator_crawl_out" ) );
	wait length - lerp_time - 0.25;
	level.player_rig Delete();
	
	Objective_Add( Obj( "OBJ_STOP_MASSACRE" ), "current", &"PRAGUE_ESCAPE_STOP_MASSACRE" );
	flag_set( "player_grabbed_pistol" );
	
	level.player Unlink();
	level.player AllowAds( true );
	level.player EnableWeapons();
	level.player SetViewModel( "viewhands_yuri_airport" );
	level.player GiveWeapon( "p99_airport_flashback" );	
	level.player SwitchToWeapon( "p99_airport_flashback" );
	level.player SetWeaponAmmoClip( "p99_airport_flashback", 12 );

	//SetSavedDvar( "ui_hidemap", 0 );
	//SetSavedDvar( "hud_showStance", "1" );
	//SetSavedDvar( "compass", "1" );
	//SetDvar( "old_compass", "1" );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "cg_drawCrosshair", 1 );
	
	thread player_blackout_ammo();
	swinging_airport_light();	
	thread falling_ceiling_tiles();
}

fade_to_crawl_to_elevator()
{
	level.player FreezeControls( true );
	level.player vision_set_fog_changes( "prague_escape_airport_crawl_to_elevator", 0 );
	wait 2.0;
	level.player FreezeControls( false );
	screen_fade_in();
	level.player SetBlurForPlayer( 0, 4 );
}

crawl_to_elevator_sounds()
{
	sound_spot = getstruct_delete( "airport_makarov_exit_elevator_sound_spot", "targetname" );
	Assert( IsDefined( sound_spot ) );
	/*
	thread crawl_to_elevator_weapon_loading();
	thread crawl_to_elevator_beeps();
	
	level.player play_sound_on_entity( "weap_suitcase_raise_plr" );
	level.player play_sound_on_entity( "weap_suitcase_drop_plr" );
		
	thread crawl_to_elevator_talking();
	*/
	level.player play_sound_on_entity( "prague_escape_radio_crawl" );
}

crawl_to_elevator_talking()
{	
				// alias, delay before playing next alias
	sounds = [ [ "prague_escape_ru_conv4_2", 0.5 ],
			   [ "prague_escape_ru_conv6_3", 0 ],
			   [ "prague_escape_ru_conv4_5", 1.0 ],
			   
			   [ "prague_escape_ru_conv9_2", 0 ],
			   [ "prague_escape_ru_conv9_4", 1.0 ],
				
			   [ "prague_escape_ru_conv1_1", 0.5 ],
			   [ "prague_escape_ru_conv2_6", 1.0 ],
				
			   [ "prague_escape_ru_conv4_1", 0 ],
			   [ "prague_escape_ru_conv4_9", 1.0 ],
				
			   [ "prague_escape_ru_conv4_8", 0 ],
			   [ "prague_escape_ru_conv4_4", 1.0 ],
				
		       [ "prague_escape_ru_conv4_18", 0.5 ],
			   [ "prague_escape_ru_conv4_14", 0.25 ],
			   [ "prague_escape_ru_conv4_16", 1.0 ],
	
			   [ "prague_escape_ru_conv2_1", 0.25 ],
			   [ "prague_escape_ru_conv8_4", 1.0 ] ];
	
	for ( i = 0; !flag( "FLAG_airport_player_collapsed_in_elevator" ); i++ )
	{
		i %= sounds.size;
		level.player play_sound_on_entity( sounds[ i ][ 0 ] );
		wait sounds[ i ][ 1 ];
	}
}

crawl_to_elevator_beeps()
{
	for ( ; !flag( "FLAG_airport_player_collapsed_in_elevator" ); wait 1.0 )
		level.player play_sound_on_entity( "prague_escape_elevator_pass_floor_beep" );
}

crawl_to_elevator_weapon_loading()
{
	sounds = [ "weap_m203_chamber_open_plr",
			   "weap_ak74_clift_plr",
			   "weap_mg36_lift_plr",
			   "weap_sa80_lift_plr",
			   "weap_mp7_lift_plr",
			   "weap_p90_lift_plr",
			   "weap_glock_first_lift_chamber_plr",
		       "weap_mk46_chamber_plr",
			   "weap_m60_chamber_plr",
			   "weap_smaw_raise_plr",
			   "weap_smaw_drop_plr",
			   "weap_miniuzi_clipin_plr",
			   "weap_m60_clipin_plr",
			   "weap_m16_clipout_plr",
			   "weap_mg36_clipout_plr" ];
	sounds = array_randomize( sounds );
	
	while ( !flag( "FLAG_airport_player_collapsed_in_elevator" ) )
		foreach ( sound in sounds )
			if ( !flag( "FLAG_airport_player_collapsed_in_elevator" ) )
				level.player play_sound_on_entity( sound );
}

crawl_to_elevator()
{
	level.player ent_flag_set( "FLAG_player_heartbeat_sound" );
	level.player SetViewKickScale( 0 );
	
	// Link player to arms

	level.player_rig_alt 			= spawn_anim_model( "player_rig_airport_alt", level.player.origin );
	level.player_rig_alt.angles 	= level.player GetPlayerAngles();
	level.player_rig_alt.animname 	= "player_rig";
	level.player PlayerLinkToDelta( level.player_rig_alt, "tag_player", 1, 0, 0, 0, 0, true );
	
	align_to_elevator = getstruct_delete( "airport_align_to_elevator", "targetname" );

	//align_to_elevator anim_first_frame_solo( level.player_rig_alt, "gun_crawl_01_idle" );
	
//	level.player ShellShock( "af_chase_ending_wakeup", 60 );

	button_funcs = [ ::hint_crawl_left,
					 ::hint_crawl_right ];

	button_hints = [ "HINT_crawl_left",
					 "HINT_crawl_right" ];

	button_track = SpawnStruct();
	thread track_buttons( button_track, button_funcs, button_hints );
	
	level notify ( "stop_heart" );
	button_index = 0;

	for ( i = 1; i < 7; i++ )
	{

		align_to_elevator thread anim_loop( [ level.player_rig_alt ], "gun_crawl_0" + i + "_idle", "stop_crawl" );

		skip_to_end = button_wait( button_funcs, button_track, button_index );

		//level.player thread play_sound_on_entity( "scn_prague_player_crawl" );

		align_to_elevator notify( "stop_crawl" );

		earthquake_time = randomfloatrange( 0.9, 1.1 );
		Earthquake( 0.16, earthquake_time, level.player.origin, 5000 );
		time = GetAnimLength( level.player_rig_alt getanim( "gun_crawl_0" + i ) );
		delaythread( time - 0.25, ::crawl_earthquake );

		button_index++;
		button_index %= button_funcs.size;
		
		if  ( skip_to_end )
		{
			fade_out( 0.5 );
			level.player.health = 100;
			level.player ent_flag_clear( "FLAG_player_heartbeat_sound" );
			flag_set( "FLAG_attack_button_pressed" );
			flag_set( "FLAG_ads_button_pressed" );
			wait 1.5;
			flag_clear( "FLAG_attack_button_pressed" );
			flag_clear( "FLAG_ads_button_pressed" );
			break;
		}
		
		if ( i != 6 )
		{
			level.player DoDamage( 50, level.player.origin );
			align_to_elevator anim_single( [ level.player_rig_alt ], "gun_crawl_0" + i );
		}
		else
		{
			align_to_elevator thread anim_single( [ level.player_rig_alt ], "gun_crawl_0" + i );
			level.player thread play_sound_on_entity( "prague_escape_yri_groanexert2" );
			wait 0.05;
			fade_out( 0.5 );
			level.player.health = 100;
			level.player ent_flag_clear( "FLAG_player_heartbeat_sound" );
			wait 1.5;
		}
	}
	level.player thread player_limp();
	flag_set( "FLAG_airport_player_collapsed_in_elevator" );
	thread wakeup_in_elevator_sounds();
	level.player_rig_alt Hide();
	wait 9.0;
}

wakeup_in_elevator_sounds()
{
	music_stop( 1.0 );
	wait 1.0;
	level.player thread play_sound_on_entity( "prague_escape_elevator_reach_floor_ring" );
	wait 3.5;
	level.player play_sound_on_entity( "prague_escape_mkv_no_russian" );
	wait 2.0;
	
	sound_start = GetEnt( "airport_in_elevator_sound_spot", "targetname" );
	
	thread wakeup_in_elevator_burst_weapon_fire( "weap_ak47_fire_npc", sound_start, 3, 3, 0.085 );
	delayThread( 0.75, ::wakeup_in_elevator_screams, sound_start );
	delayThread( 1.5, ::wakeup_in_elevator_burst_weapon_fire, "weap_m240_fire_npc", sound_start, 3, 3, .075 );
	delayThread( 2.0, ::wakeup_in_elevator_burst_weapon_fire, "weap_shotgunattach_fire_npc", sound_start, 3, 7, 0.5, 1.5 );
	
	flag_wait( "FLAG_airport_player_exits_elevator" );
	
	sound_end = getstruct_delete( "airport_exit_elevator_sound_spot", "targetname" );
	sound_start MoveTo( sound_end.origin, 10.0 );
	
	flag_wait( "FLAG_airport_player_blackout_ended" );
	
	sound_start StopSounds();
}

wakeup_in_elevator_burst_weapon_fire( alias, sound_spot, duration, interval, min_delay, max_delay )
{
	Assert( IsDefined( alias ) );
	Assert( IsDefined( sound_spot ) );
	
	duration 	= gt_op( duration, 0.05 );
	interval	= gt_op( interval, 0.05 );
	min_delay 	= ter_op( IsDefined( min_delay ), min_delay, 0.05 );
	max_delay	= ter_op( IsDefined( max_delay ), max_delay, 0.05 );
	max_delay	= ter_op( min_delay != max_delay && min_delay > max_delay, min_delay + 0.05, max_delay );
	
	for ( ; !flag( "FLAG_airport_player_blackout_ended" ); wait interval )
	{
		delay = min_delay;
		for ( elapsed = 0; elapsed < duration && !flag( "FLAG_airport_player_blackout_ended" ); wait delay )
		{
			time = GetTime();
			sound_spot thread play_sound_on_entity( alias );
			if ( min_delay != max_delay )
				delay = RandomFloatRange( min_delay, max_delay );
			elapsed += delay + ( ( GetTime() - time ) * 1000 );
		}
	}
}

wakeup_in_elevator_screams( sound_spot )
{
	Assert( IsDefined( sound_spot ) );
	
	for ( ; !flag( "FLAG_airport_player_blackout_ended" ); )
		sound_spot play_sound_on_entity( "prague_escape_airport_civ_scream", "LISTEN_stop_sounds" );
		
}

wakeup_in_elevator()
{
	thread music_play( "prague_escape_airport_elevator", 1 );
	level.player vision_set_fog_changes( "prague_escape_airport_exit_elevator", 0 );
	
	align_to_exit_elevator = getstruct_delete( "airport_align_to_exit_elevator", "targetname" );
	Assert( IsDefined( align_to_exit_elevator ) );
	
	level.player_rig_alt.origin = align_to_exit_elevator.origin;
	level.player_rig_alt.angles = align_to_exit_elevator.angles;
	
	level.player PlayerLinkToDelta( level.player_rig_alt, "tag_player", 1, 0, 0, 0, 0, true );
	level.player LerpFOV( 65, 0.05 );
	
	// Fast forward and play wake up animation
	
	thread set_ambient( "prague_flashback_airportelevator" );
	
	rate = 1.0;
	level.player_rig_alt setanimknoball_player( level.player_rig_alt getanim( "wakeup" ), "root", 1.0, 0, rate );
	wait 0.05;
	percent = 0.6;
	level.player_rig_alt SetAnimTime( level.player_rig_alt getanim( "wakeup" ), percent );
	level.player_rig_alt Show();
	fade_in( 1.25 );
	level.player ent_flag_set( "FLAG_player_heartbeat_sound" );
	delayThread( 2.0, ::airport_intro_screen );
	level.player delayThread( 1.0, ::play_sound_on_entity, "prague_escape_yri_groanexert" );
	delayThread( 3.5, ::wakeup_in_elevator_civ_falling );
	delayThread( 4.5, ::wakeup_in_elevator_civ_crawling );
	
	time = ( 1 - percent ) * GetAnimLength( level.player_rig_alt getanim( "wakeup" ) );
	wait gt_op( ( time / rate ) - 4.0, 0 );
	
	flag_set( "open_elevator_doors" );
	
	// Since the wakeup anim leaves the player linked in some geo, lerp to a spot above
	
	elevator_wakeup_end = getstruct_delete( "airport_elevator_walkup_end", "targetname" );
	Assert( IsDefined( elevator_wakeup_end ) );
	tag 		= spawn_tag_origin();
	tag.origin 	= elevator_wakeup_end.origin;
	tag.angles	= elevator_wakeup_end.angles;
	
	lerp_time = 1.0;
	level.player PlayerLinktoBlend( tag, "tag_origin", lerp_time, lerp_time * 0.5, lerp_time * 0.5 );
	wait lerp_time;
	level.player PlayerLinkToDelta( tag, "tag_origin", 1, 0, 0, 0, 0 );
	level.player UnLink();
	tag Delete();
	level.player_rig_alt Delete();
}

wakeup_in_elevator_civ_falling()
{
	female_head 		= "head_city_civ_female_a_drone";
	falling_civ_spot 	= getstruct_delete( "airport_civ_falling_dead", "targetname" );
	falling_civ 	 	= spawn_anim_model( "falling_civ", falling_civ_spot.origin );
	falling_civ.angles  = falling_civ_spot.angles;
	falling_civ Attach( female_head, "", true );
	
	falling_civ thread anim_single_solo( falling_civ, "death" );
	wait 0.5;
	spots = get_connected_ents( "airport_shoot_civ_falling_dead" );
	thread wakeup_in_elevator_civ_falling_getting_shot( spots[ 0 ].origin, spots[ 1 ].origin );
	fx_tag 			= Spawn( "script_model", falling_civ GetTagOrigin( "j_head" ) );
	fx_tag.angles 	= falling_civ GetTagAngles( "j_head" ) + ( 25, 180, 0 );
	fx_tag SetModel( "tag_origin" );
	fx_tag LinkTo( falling_civ, "j_head" );
	wait 0.1;
	PlayFXOnTag( getfx( "FX_airport_civ_headshot_impact" ), fx_tag, "tag_origin" );
	PlayFXOnTag( getfx( "FX_airport_civ_headshot_trail" ), fx_tag, "tag_origin" );
}

wakeup_in_elevator_civ_falling_getting_shot( start, end )
{
	for ( i = 0; i < 6; i++ )
	{
		MagicBullet( "ak74u", start, end );
		wait 0.1;
	}
}

wakeup_in_elevator_civ_crawling()
{
	male_head 			= "head_city_civ_male_a_drone";
	crawling_civ_spot 	= getstruct_delete( "airport_civ_crawling_dead", "targetname" );
	crawling_civ 	 	= spawn_anim_model( "crawling_civ", crawling_civ_spot.origin );
	crawling_civ.angles = crawling_civ_spot.angles;
	crawling_civ Attach( male_head, "", true );
	
	time = GetAnimLength( crawling_civ getanim( "crawl" ) );
	crawling_civ thread anim_single_solo( crawling_civ, "crawl" );
	crawling_civ delayThread( time, ::anim_single_solo, crawling_civ, "death" );
	
	fx_rate 	= .25;
	fx 			= getfx( "crawling_death_blood_smear" );
	
	for( elapsed = 0; elapsed < time; elapsed += fx_rate )
	{
		origin 	= crawling_civ GetTagOrigin( "J_SpineLower" );
		angles 	= crawling_civ GetTagAngles( "tag_origin" );
		fwd 	= AnglesToRight( angles );
		up 		= AnglesToForward( ( 270, 0, 0 ) );
		
		PlayFX( fx, origin, up, fwd );
		wait fx_rate;
	}
	wait gt_op( time - elapsed, 0 );
}

waittill_player_exit_elevator()
{
	trigger = GetEnt( "airport_player_exit_elevator_trigger", "targetname" );
	Assert( IsDefined( trigger ) );
	
	for ( ; !level.player IsTouching( trigger ) && !flag( "FLAG_airport_player_blackout_at_end" ); wait 0.05 ){}
	trigger Delete();
}

exit_elevator_stand_player_blink()
{
	animation 	= level.player_rig GetAnim( "elevator_crawl_out" );	
	time 		= GetAnimLength( animation );	
	
	level.player delayThread( time - 2.3, ::player_limp );
	
	wait( time - 0.40 );

	set_screen_fade_shader( "black" );
	set_screen_fade_timer( 0.50 );

	level.player SetBlurForPlayer( 3, 6 );
	screen_fade_out();
	set_screen_fade_timer( 2.5 );	
	screen_fade_in();		
	level.player SetBlurForPlayer( 0, 4 );
}

airplane_takeoff()
{
	airplane 	= GetEntArray( "airport_airplane", "targetname" );
	root_spot	 = getstruct_delete( "airport_airplane_root", "targetname" );
	Assert( IsDefined( root_spot ) );
	root = root_spot spawn_tag_origin();

	foreach ( part in airplane )
		part LinkTo( root, "tag_origin" );
		
	trigger = GetEnt( "airport_airplane_trigger", "targetname" );
	Assert( IsDefined( trigger ) );
	
	for ( ; !level.player IsTouching( trigger ); wait 0.05 ){}
	trigger Delete();
	
	spots = get_connected_ents( "airport_airplane_start" );
	deletestructarray_ref( spots );
	
	root MoveTo( spots[ 0 ].origin, 0.05 );
	wait 0.1;
	time = 10;
	root MoveTo( spots[ 1 ].origin, 10 );
	root RotateTo( VectorToAngles( spots[ 1 ].origin - spots[ 0 ].origin ), 10 );
	root thread play_sound_on_entity( "prague_escape_airplane_flyby" );
}

wounded_civs()
{
	align_to_airport_entrance = getstruct( "anim_align_airport_entrance", "targetname" );

	female_head 	= "head_city_civ_female_a_drone";
	male_head 		= "head_city_civ_male_a_drone";
	officer_head 	= "head_secret_service_b";

	//security office with pistol
	level thread pistol_officer( align_to_airport_entrance, officer_head );

	//security officer moving wounded
	anim_crawling_wounded_2 = getstruct( "s_anim_crawling_wounded_2", "targetname" );	
	hurt_officer_1 			= spawn_anim_model( "hurt_officer_1", anim_crawling_wounded_2.origin );
	hurt_officer_1 thread play_wounded_officer_anim( anim_crawling_wounded_2, officer_head );	
	
	anim_crawling_wounded_1 = getstruct( "s_anim_crawling_wounded_1", "targetname" );		
	hurt_officer_2 			= spawn_anim_model( "hurt_officer_2", anim_crawling_wounded_1.origin );
	hurt_officer_2 thread play_wounded_officer_anim( anim_crawling_wounded_1, officer_head );
	
	//lobby wounded civs
	neckwound_align 		= getstruct( "airport_neck_wound_civ", "targetname" );
	neck_wound_civ 			= spawn_anim_model( "neck_wound_civ", neckwound_align.origin );
	neck_wound_civ.angles 	= neckwound_align.angles;
	neck_wound_civ setanimknoball_gh( neck_wound_civ getanim( "death" ), "root", 1, 0, 1 );
	length = GetAnimLength( neck_wound_civ getanim( "death" ) );
	neck_wound_civ delayCall( 0.05, ::SetAnimTime,neck_wound_civ getanim( "death" ), 3 / length );
	neck_wound_civ Attach( male_head, "", true );
	neck_wound_civ.headmodel = male_head;

	crying_civ_align 	= getstruct( "airport_crying_civ", "targetname" );
	crying_civ 			= spawn_anim_model( "crying_civ", crying_civ_align.origin );
	crying_civ.angles 	= crying_civ_align.angles;
	crying_civ setanimknoball_gh( crying_civ getanim( "death" ), "root", 1, 0, 1 );
	crying_civ Attach( female_head, "", true );
	crying_civ.headmodel = female_head;

	wounded_shoulder 			= spawn_anim_model( "wounded_shoulder", align_to_airport_entrance.origin );
	wounded_shoulder_civ_align 	= getstruct( "s_wounded_shoulder_civ_align", "targetname" );
	wounded_shoulder_civ_align thread anim_last_frame_solo( wounded_shoulder, "wounded_civ" );
	wounded_shoulder Attach( male_head, "", true );
	wounded_shoulder.headmodel = male_head;

	headwound_civ 		= spawn_anim_model( "headwound_civ", align_to_airport_entrance.origin );
	headwound_civ_align = getstruct( "s_headwound_civ_align", "targetname" );
	headwound_civ_align thread anim_last_frame_solo( headwound_civ, "wounded_civ" );
	headwound_civ Attach( female_head, "", true );
	headwound_civ.headmodel = female_head;
}

pistol_officer( align_to, head )
{
	wounded_officer = spawn_anim_model( "wounded_officer", align_to.origin );

	wounded_officer Attach( head, "", true );
	wounded_officer.headmodel = head;
		
	p99_pistol 			= Spawn( "script_model", wounded_officer GetTagOrigin( "tag_weapon_right" ) );
	p99_pistol.angles 	= wounded_officer GetTagAngles( "tag_weapon_right" );	
	p99_pistol SetModel( "weapon_walther_p99" );	
	p99_pistol LinkTo( wounded_officer, "tag_weapon_right" );
	p99_pistol DontCastShadows();
	p99_pistol HidePart( "TAG_SILENCER" );

	align_to anim_first_frame_solo( wounded_officer, "wounded_officer" );	

	flag_wait( "FLAG_airport_player_exits_elevator" );
	wait 0.5;
	
	align_to anim_single_solo( wounded_officer, "wounded_officer" );
	align_to thread anim_last_frame_solo( wounded_officer, "wounded_officer" );		
	
	flag_wait( "player_grabbed_pistol" );
	
	p99_pistol Delete();

	flag_wait( "emt_end" );
	
	wounded_officer Delete();
}

play_wounded_officer_anim( align_to, head )
{
	self endon( "death" );

	if ( IsDefined( head ) )
	{
		self Attach( head, "", true );
		self.headmodel = head;
	}		
	
	self SetCanDamage( false );

	align_to thread anim_loop_solo( self, "wounded_civ_loop" );
	
	flag_wait( "emt_end" );
	
	align_to notify( "stop_loop" );
	self Delete();	
}

airport_intro_screen()
{
	lines = [];
	// 08:34:[{FAKE_INTRO_SECONDS:25}] - 2016
	lines[ lines.size ] = &"PRAGUE_ESCAPE_INTRO_AIRPORT_1";
	// Zakhaev International Airport - 2016
	lines[ lines.size ] = &"PRAGUE_ESCAPE_INTRO_AIRPORT_2";
	//Moscow, Russia
	lines[ lines.size ] = &"PRAGUE_ESCAPE_INTRO_AIRPORT_3";
		
	maps\_introscreen::introscreen_feed_lines( lines );	
}

swinging_airport_light()
{
	light = GetEnt( "fxanim_prague2_airport_light_mod", "targetname" );
	light.animname = "swinging_light";
	light UseAnimTree( level.scr_animtree[ "script_model" ] );
	
	light thread anim_single_solo( light, "airport_light" );
}

falling_ceiling_tiles()
{
	falling_tiles 			= GetEnt( "fxanim_prague2_airport_tiles_mod", "targetname" );
	falling_tiles.animname 	= "falling_tiles";
	falling_tiles UseAnimTree( level.scr_animtree[ "script_model" ] );
	
	flag_wait_or_timeout( "play_falling_tiles", 10 ); //look at trigger sets this flag
	
	wait( 1 );
	
	falling_tiles thread anim_single_solo( falling_tiles, "airport_tiles" );	
}

blood_handprint()
{
	level endon( "stop_hand_print" );
	
	flag_wait( "play_hand_print" );

	while ( 1 )
	{
		PlayFXOnTag( getfx( "blood_handprint" ), self, "J_Wrist_RI" );
		wait( 0.20 );
	}
}

casual_killers()
{
	makarov_spawner 	= GetEnt( "ai_makarov_stairs", "targetname" );
	viktor_spawner 		= GetEnt( "ai_viktor_stairs", "targetname" );
	lev_spawner 		= GetEnt( "ai_lev_stairs", "targetname" );
	kiril_spawner 		= GetEnt( "ai_kiril_stairs", "targetname" );
	mw2_player_spawner 	= GetEnt( "ai_mw2_player_stairs", "targetname" );	
	
	makarov_spawner add_spawn_function( ::casual_killers_init );
	viktor_spawner add_spawn_function( ::casual_killers_init );
	lev_spawner add_spawn_function( ::casual_killers_init );
	kiril_spawner add_spawn_function( ::casual_killers_init );
	mw2_player_spawner add_spawn_function( ::casual_killers_init );	
	
	level.makarov 		= makarov_spawner spawn_ai( true );
	level.viktor 		= viktor_spawner spawn_ai( true );
	level.lev 			= lev_spawner spawn_ai( true );
	level.kiril 		= kiril_spawner spawn_ai( true );
	level.mw2_player	= mw2_player_spawner spawn_ai( true );

	flag_wait( "player_grabbed_pistol" );
			
	//TOP STAIRS RUN AND FIRING
	makarov_node 	= GetNode( "makarov", "script_noteworthy" );
	viktor_node 	= GetNode( "m4", "script_noteworthy" );
	lev_node 		= GetNode( "saw", "script_noteworthy" );
	kiril_node 		= GetNode( "shotgun", "script_noteworthy" );
	mw2_player_node = GetNode( "mw2_player", "script_noteworthy" );
	
	makarov_target 	= Spawn( "script_origin", getstruct_delete( "airport_makarov_target", "targetname" ).origin );
	viktor_target 	= Spawn( "script_origin", getstruct_delete( "airport_viktor_target", "targetname" ).origin );
	lev_target 		= Spawn( "script_origin", getstruct_delete( "airport_lev_target", "targetname" ).origin );
	kiril_target 	= Spawn( "script_origin", getstruct_delete( "airport_kiril_target", "targetname" ).origin );
	mw2_target 		= Spawn( "script_origin", getstruct_delete( "airport_mw2_target", "targetname" ).origin );
	
	level.makarov  thread casual_killer_movement( makarov_target, makarov_node );		
	level.viktor  thread casual_killer_movement( viktor_target, viktor_node );
	level.lev  thread casual_killer_movement( lev_target, lev_node );	
	level.kiril  thread casual_killer_movement( kiril_target, kiril_node );
	level.mw2_player thread casual_killer_movement( mw2_target, mw2_player_node );
	
	flag_wait( "start_blackout_anim" );
	
	makarov_delete_node = GetNode( "makarov_delete_node", "targetname" );
	viktor_delete_node 	= GetNode( "viktor_delete_node", "targetname" );
	lev_delete_node 	= GetNode( "lev_delete_node", "targetname" );
	kiril_delete_node 	= GetNode( "kiril_delete_node", "targetname" );
	player_delete_node 	= GetNode( "player_delete_node", "targetname" );

	level.makarov  thread casual_killers_run_and_delete( makarov_delete_node );
	level.viktor  thread casual_killers_run_and_delete( viktor_delete_node );
	level.lev  thread casual_killers_run_and_delete( lev_delete_node );
	level.kiril  thread casual_killers_run_and_delete( kiril_delete_node );
	level.mw2_player thread casual_killers_run_and_delete( player_delete_node );
}

casual_killers_init()
{
	self endon( "death" );
		
	self SetCanDamage( false );
	self.ignoreme = true;
	self.ignoreall = true;
	self.ignoresuppression = true;
	self.goalradius = 32;
	self maps\_casual_killer::enable_casual_killer();
	self.team = "axis";
	self disable_pain();
}

casual_killer_movement( target, node )
{
	self endon( "death" );

	self.ignoreall 			= false;
	self.ignoreme 			= false;
	self.moveplaybackrate 	= 1.0;
	self.noreload 			= true;
	self disable_arrivals();
	
	self SetEntityTarget( target );
	wait RandomFloatRange( 1.5, 3.0 );
	self ClearEntityTarget( target );
	target Delete();
	
	self thread follow_path( node, 5000 );

	node waittill( "trigger" );

	self maps\_casual_killer::disable_casual_killer();
	self walkdist_zero();
	waittillframeend;

	self clear_run_anim();

	self delayThread( 1, ::enable_arrivals );

	self waittill( "reached_path_end" );

	self maps\_casual_killer::enable_casual_killer();

	wait RandomFloatRange( 0.25, 1.0 );

	speed 	= RandomFloatRange( 1, 4 );
	delay 	= RandomFloatRange( 1, 4 );
	fwd 	= RandomFloatRange( 1, 4 );
	
	self StopAnimScripted();
	node = GetNode( node.target, "targetname" );
	self OrientMode( "face angle", node.angles[ 1 ] );

	self thread spray_and_pray( delay, speed, fwd );

	flag_wait( "start_blackout_anim" );
	self notify( "stop_spray_and_pray" );
}

casual_killers_run_and_delete( delete_node )
{
	self endon( "death" );
	
	self SetGoalNode( delete_node );
	self waittill( "goal" );
	self Delete();
}

player_blackout_elevator_timeout()
{
	timeout = 90.0;
	
	for ( elapsed = 0; elapsed < timeout && !flag( "FLAG_airport_player_exits_elevator" ); elapsed += 0.05 )
		wait 0.05;
	if ( elapsed >= timeout )
		flag_set( "FLAG_airport_player_blackout_at_end" );
}

player_blackout_triggers()
{
	trigger = GetEnt( "airport_force_blackout_trigger", "targetname" );
	Assert( IsDefined( trigger ) );
	
	for ( ; !flag( "start_blackout_anim" ) && !level.player IsTouching( trigger ); wait 0.05 ){}
	flag_set( "FLAG_airport_player_blackout_at_end" );
}

player_blackout_ammo()
{
	for ( ; !flag( "start_blackout_anim" ) && level.player GetAmmoCount( "p99" ) > 0; wait 0.05 ){}
	flag_set( "FLAG_airport_player_blackout_at_end" );
}

player_blackout_monitor()
{
	flag_wait( "FLAG_airport_player_blackout_at_end" );
	flag_set( "start_blackout_anim" );
	
	level.player thread play_sound_on_entity( "presc_yri_soldierofrussia" );
	
	level.player notify( "LISTEN_end_player_limp" );
	level notify( "LISTEN_end_random_blur" );
	
	anim_scene 			= undefined;
	touching_detector 	= false;
	
	right_detector = GetEnt( "trig_right_metal_detector", "targetname" );
	Assert( IsDefined( right_detector ) );
	
	if ( level.player IsTouching( right_detector ) )
	{
		anim_scene 			= "right_detector_passout";
		touching_detector 	= true;
	}
	
	left_detector = GetEnt( "trig_left_metal_detector", "targetname" );
	Assert( IsDefined( left_detector ) );
	
	if ( level.player IsTouching( left_detector ) )
	{
		anim_scene 			= "left_detector_passout";
		touching_detector 	= true;
	}
	
	if ( touching_detector )
	{
		SetBlur( 0, 0.05 );	
		
		level.player FreezeControls( true );
		level.player DisableWeapons();

		level.player_rig 			= spawn_anim_model( "player_rig_airport", level.player.origin );
		level.player_rig.angles 	= level.player GetPlayerAngles();	
		level.player_rig.animname 	= "player_rig";
		level.player_rig DontCastShadows();
		
		align_to_entrance = getstruct( "anim_align_airport_entrance", "targetname" );
		
		align_to_entrance anim_first_frame_solo( level.player_rig, anim_scene );
		level.player_rig Hide();
		
		lerp_time = .25;	
		
		level.player PlayerLinkToBlend( level.player_rig, "tag_player", lerp_time, lerp_time * 0.25, lerp_time * 0.25 );
		wait lerp_time;		
		level.player_rig Show();	
		level.player PlayerLinkToDelta( level.player_rig, "tag_player", 1, 15, 15, 10, 10, true );
		
		align_to_entrance thread anim_single_solo( level.player_rig, anim_scene);			
	
		if ( flag( "screen_fade_out_active" ) )
		{
			flag_wait( "screen_fade_out_end" );
			set_screen_fade_timer( 0.3 );
			screen_fade_in();		
		}
		else if ( flag( "screen_fade_in_active" ) )
		{
			flag_wait( "screen_fade_in_end" );
		}	
		
		thread metal_detector_blackout_fades();
		thread player_emt_anim();		
	}
	else
	{
		thread player_blackout_forced();	
	}
}

player_blackout_timeout()
{
	trigger = GetEnt( "no_blackout_area", "targetname" );
	Assert( IsDefined( trigger ) );
	
	timeout = 180;
	for ( elapsed = 0; !flag( "start_blackout_anim" ) && elapsed < timeout; elapsed += 0.05 )
		wait 0.05;
	
	//if player is too close to the wall don't let him black out.
	while( !flag( "start_blackout_anim" ) && level.player IsTouching( trigger ) )
		wait 0.05 ;
	flag_set( "FLAG_airport_player_blackout_at_end" );
}

player_blackout_forced()
{
	wait( RandomFloatRange( 0.50, 1.0 ) );

	level.player FreezeControls( true );
	level.player DisableWeapons();
	
	SetBlur( 0, 0.05 );

	align_to_player 		= Spawn( "script_model", level.player.origin );
	align_to_player.angles 	= level.player.angles;
	align_to_player SetModel( "tag_origin" );
	
	level.player PlayerLinkToDelta( align_to_player, "tag_origin", 1, 0, 0, 0, 0 );

	// Check if the player is still in the elevator
	if ( !flag( "FLAG_airport_player_exits_elevator" ) )
	{
		center = getstruct_delete( "airport_elevator_center", "targetname" );
		Assert( IsDefined( center ) );
		move_time = 0.5;
		align_to_player MoveTo( center.origin, move_time, move_time * 0.5, move_time * 0.5 );
		fade_out( 0.25 );
		level.player thread play_sound_on_entity( "breathing_hurt" );
		wait move_time;
		fade_in( 0.25 );
	}
		
	player_rig 			= spawn_anim_model( "player_rig_airport", level.player.origin );
	player_rig.angles 	= level.player GetPlayerAngles();		
	player_rig.animname = "player_rig";
	player_rig DontCastShadows();
	
	// Don't show the pistol if the player never exited the elevator
	if ( flag( "FLAG_airport_player_exits_elevator" ) )
	{
		p99_pistol 			= Spawn( "script_model", player_rig GetTagOrigin( "tag_weapon" ) );
		p99_pistol.angles 	= player_rig GetTagAngles( "tag_weapon" );	
		p99_pistol SetModel( "viewmodel_walther_p99" );
		p99_pistol LinkTo( player_rig, "tag_weapon" );
		p99_pistol HidePart( "TAG_KNIFE" );
		p99_pistol HidePart( "TAG_SILENCER" );
	}
		
	align_to_player anim_first_frame_solo( player_rig, "player_force_blackout" );
	
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 15, 15, 10, 10, true );	
	
	align_to_player thread anim_single_solo( player_rig, "player_force_blackout" );
	
	if ( flag( "screen_fade_out_active" ) )
	{
		flag_wait( "screen_fade_out_end" );
		set_screen_fade_timer( 0.3 );
		screen_fade_in();		
	}
	else 
	if ( flag( "screen_fade_in_active" ) )
	{
		flag_wait( "screen_fade_in_end" );
	}
	thread player_blackout_in_place();
	thread player_emt_anim();
}

player_blackout_in_place()
{
	level thread autosave_by_name_silent( "test_emt_save" );	
	
	wait( 1 );
	player_blink();
	wait( 1 );
	player_blink();
	wait( 0.25 );
	player_blink();	
	wait( 0.10 );

	flag_set( "FLAG_airport_player_blackout_ended" );
	
	screen_fade_out();

	level.player vision_set_fog_changes( "prague_escape_airport_revive", 0 );
	flag_set( "setup_emt_anim" );

	wait 3.0;

	level thread emt_transition();
}

emt_transition()
{		
	flag_set( "emt_begin" );
	screen_fade_in();
	
	wait( 2 );
	player_blink();
	wait( 1.15 );	
	set_screen_fade_shader( "white" );
	set_screen_fade_timer( .5 );
	level.player PlaySound( "scn_prague_flash_airlift" );
	screen_fade_out();
	
	level.player Unlink();	
	flag_set( "emt_end" );	
}

player_blackout_shoot_at_enemies()
{
	trigger = GetEnt( "airport_monitor_shooting_enemies", "targetname" );
	Assert( IsDefined( trigger ) );
	
	for ( ; !flag( "FLAG_airport_player_blackout_at_end" ) && !level.player IsTouching( trigger ); wait 0.05 ){}
	trigger Delete();
	
	enemies = [ level.makarov,
				level.viktor,
				level.lev,
				level.kiril,
				level.mw2_player ];
	
	fov 					= Cos( 17 );
	successfull_shots		= 0;
	shots_before_blackout	= 2;
	
	for ( ; !flag( "FLAG_airport_player_blackout_at_end" ); )
	{
		level.player waittill( "LISTEN_attack_button_pressed" );
		
		foreach ( guy in enemies )
		{
			n 	= VectorNormalize( guy.origin - level.player GetEye() );
			fwd = AnglesToForward( level.player GetPlayerAngles() );
			dot = VectorDot( fwd, n );
			
			if ( dot >= fov )
			{
				successfull_shots++;

				if ( successfull_shots >= shots_before_blackout )
				{
					flag_set( "FLAG_airport_player_blackout_at_end" );
					return;
				}
				break;
			}
		}
	}
}

player_emt_anim()
{
	align_to_emt = getstruct( "s_emt_align", "targetname" );
	
	flag_wait( "setup_emt_anim" );
	
	//level.player thread play_sound_on_entity( "presc_yri_soldierofrussia" );
	
	sound_spot = GetEnt( "airport_in_elevator_sound_spot", "targetname" );
	Assert( IsDefined( sound_spot ) );
	sound_spot notify( "LISTEN_stop_sounds" );
	
	//deagle_stream = GetEnt( "e_deagle_stream", "targetname" );
	//deagle_stream Show();

	maps\prague_escape_outro::setup_outro_anim();
	
	cellar_stream_ent = GetEnt( "e_cellar_stream_ent", "targetname" );	
	//level.player PlayerSetStreamOrigin( cellar_stream_ent.origin );

	level.emt = spawn_anim_model( "emt", align_to_emt.origin );
	
	head = "head_prague_civ_hero_male_d";
	level.emt Attach( head, "", true );
	level.emt.headmodel = head;
	
	player_rig = spawn_anim_model( "player_rig_airport", level.player.origin );
	player_rig.angles = level.player GetPlayerAngles();
	player_rig.animname = "player_rig";
	player_rig DontCastShadows();
		
	align_to_emt anim_first_frame_solo( player_rig, "emt_assist" );
	
	flag_wait( "emt_begin" );

	align_to_escalators = getstruct( "anim_align_airport_escalators", "targetname" );
	align_to_escalators thread spawn_dead_by_animname( "price_stream_model", "head_hero_price_desert" );
	
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 15, 15, 10, 10, true );	

	oxygen_mask 			= spawn_anim_model( "oxygen_mask" );
	oxygen_mask.animname 	= "oxygen_mask";
	oxygen_mask UseAnimTree( level.scr_animtree[ "oxygen_mask" ] );	

	medic_anim_ents = [ player_rig,
						level.emt,
						oxygen_mask ];
	
	thread clean_up_dead_bodies();

	flag_set( "start_emt_dialogue" );
	level.player  delaycall( 2, ::PlayerSetStreamOrigin, cellar_stream_ent.origin );
	align_to_emt anim_single( medic_anim_ents, "emt_assist" );
	array_thread( medic_anim_ents, ::self_delete );
}

metal_detector_blackout_fades()
{
	player_blink();
	wait( 1 );
	player_blink();
	wait( 1 );

	flag_set( "FLAG_airport_player_blackout_ended" );
	screen_fade_out();
	flag_set( "setup_emt_anim" );

	wait 3;
	
	/*
	//First Drag
	level.player PlayRumbleLoopOnEntity( "tank_rumble" );
	wait( 1.5 );
	level.player StopRumble( "tank_rumble" );
	wait( 1.5 );
	
	//Second Drag
	level.player PlayRumbleLoopOnEntity( "tank_rumble" );
	wait( 1.5 );
	level.player StopRumble( "tank_rumble" );
	wait( 1.5 );	
	*/
	level thread emt_transition();
	
}

init_emt()
{
	self endon( "death" );

	self SetCanDamage( false );
	self.animname = "emt";
	self.goalradius = 32;
	self.ignoreme = true;
	self.ignoreall = true;
	self gun_remove();
}

airport_elevator()
{
	doors 				= [];
	doors[ "left" ] 	= GetEnt( "intro_elevator_door_left", "targetname" );
	doors[ "right" ] 	= GetEnt( "intro_elevator_door_right", "targetname" );
	
	elevator_setup( doors );
	
	snd 	= Spawn( "script_origin", doors[ "left" ].close_pos );
	snd2 	= Spawn( "script_origin", doors[ "left" ].close_pos );
	
	//flag_wait( "player_hits_button" ); //notetrack sets this

	//level.player PlayRumbleOnEntity( "damage_heavy" );
	
	bm_button_on = GetEnt( "button_on", "targetname" );
	bm_button_on Show();
	
	elevator_open_doors( doors, snd );
	
	//flag_wait( "close_elevator_doors" ); //notetrack sets this
	
	//elevator_close_doors( doors, snd );

	flag_wait( "FLAG_airport_player_collapsed_in_elevator" );
	
	elevator_close_doors( doors, snd );
	
	// Some light models that need to be moved up with the elevator
	elevator_models = GetEntArray( "airport_elevator_models", "targetname" );
	override_array_call( elevator_models, ::MoveZ, [ 144, 5, 2.5, 0.05 ] );
	
	level.elevator_start MoveZ( 144, 0.05 );
	doors[ "left" ] MoveZ( 144, 0.05 );
	doors[ "right" ] MoveZ( 144, 0.05 );
	
	level.elevator_start waittill( "movedone" );

	flag_set( "elevator_is_up" );

	flag_wait( "open_elevator_doors" );
	
	elevator_open_doors( doors, snd );
	
	/*
	wait 2.0;
	
	elevator_close_doors( doors, snd );
	
	doors[ "left" ] MoveZ( 144, 0.1 );
	doors[ "right" ] MoveZ( 144, 0.1 );
	*/
}

elevator_setup( doors )
{
	doors[ "left" ].close_pos 	 = doors[ "left" ].origin;
	doors[ "right" ].close_pos 	 = doors[ "right" ].origin;

	dist = ( -38, 0, 0 );

	doors[ "left" ].open_pos 	 = doors[ "left" ].origin - dist;
	doors[ "right" ].open_pos 	 = doors[ "right" ].origin + dist;
}

elevator_open_doors( doors, snd )
{
	snd PlaySound( "elev_door_open" );

	doors[ "left" ] ConnectPaths();
	doors[ "right" ] ConnectPaths();

	speed = 14;									// scaler
	closed_pos = doors[ "left" ].close_pos;
	dist = abs( Distance( doors[ "left" ].open_pos, closed_pos ) );
	moveTime = ( dist / speed ) * 0.5;										// scaler

	v_left_open_pos = ( doors[ "left" ].open_pos[ 0 ], doors[ "left" ].open_pos[ 1 ], doors[ "left" ].origin[ 2 ] );
	v_right_open_pos = ( doors[ "right" ].open_pos[ 0 ], doors[ "right" ].open_pos[ 1 ], doors[ "right" ].origin[ 2 ] );

	doors[ "left" ] MoveTo( v_left_open_pos, moveTime, moveTime * 0.1, moveTime * 0.25 );
	doors[ "right" ] MoveTo( v_right_open_pos, moveTime, moveTime * 0.1, moveTime * 0.25 );

	doors[ "left" ] waittill( "movedone" );
}

elevator_close_doors( doors, snd, speed )
{
	snd PlaySound( "elev_door_close" );

	doors[ "left" ] DisconnectPaths();
	doors[ "right" ] DisconnectPaths();

	if ( !isdefined( speed ) )
		speed = 14;

	closed_pos = doors[ "left" ].close_pos;
	dist = abs( Distance( doors[ "left" ].open_pos, closed_pos ) );
	moveTime = dist / speed;

	doors[ "left" ] MoveTo( closed_pos, moveTime, moveTime * 0.1, moveTime * 0.25 );
	doors[ "right" ] MoveTo( closed_pos, moveTime, moveTime * 0.1, moveTime * 0.25 );

	doors[ "left" ] waittill( "movedone" );
}

spray_and_pray( delay, speed_scaler, forward, height, angle, dist )
{
	self endon( "death" );
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );

	msg = "stop_spray_and_pray";
	self endon( msg );

	array = self spray_and_pray_get_target( delay, speed_scaler, forward, height, angle, dist );

	self thread stop_spray_and_pray_cleanup( array[ "target" ], msg );

	self.spraypray_target = array[ "target" ];
	self SetEntityTarget( self.spraypray_target );

	self.old_pistol_switch = self.no_pistol_switch;
	self.no_pistol_switch = true;

	self spray_and_pray_move_target( array );
}

spray_and_pray_move_target( array )
{
	while ( 1 )
	{
		dist = Distance( array[ "node_origin" ], array[ "target" ].origin );
		time = dist / array[ "speed" ];

		array[ "target" ] MoveTo( array[ "node_origin" ], time, time * .1, time * .1 );
		wait time;

		if ( array[ "node_origin" ] == array[ "start_origin" ] )
			array[ "node_origin" ] = array[ "end_origin" ];
		else
			array[ "node_origin" ] = array[ "start_origin" ];
	}
}

spray_and_pray_move_target_node( array )
{
	node = array[ "node" ];

	while ( 1 )
	{
		node = getstruct( node.target, "targetname" );

		dist = Distance( node.origin, array[ "target" ].origin );
		time = dist / array[ "speed" ];

		array[ "target" ] MoveTo( node.origin, time, time * .1, time * .1 );
		wait time;
	}
}

spray_and_pray_get_target_node( delay, speed_scaler, node )
{
	array = [];

	if ( !isdefined( delay ) )
		delay = .05;
	if ( !isdefined( speed_scaler ) )
		speed_scaler = 1;

	wait delay;

	array[ "speed" ]	= 50 * speed_scaler;
	array[ "node" ]		= node;

	array[ "target" ] = Spawn( "script_origin", node.origin );
//	array[ "target" ] = Spawn( "script_model", node.origin );
//	array[ "target" ] SetModel( "weapon_us_smoke_grenade" );
	return array;
}

spray_and_pray_get_target( delay, speed_scaler, forward, height, angle, dist )
{
	array = [];

	if ( !isdefined( delay ) )
		delay = .05;
	if ( !isdefined( speed_scaler ) )
		speed_scaler = 1;
	if ( !isdefined( forward ) )
		forward = true;
	if ( !isdefined( height ) )
		height = 0;
	if ( !isdefined( angle ) )
		angle = 38;
	if ( !isdefined( dist ) )
		dist = 64;

	wait delay;

	muzzle 				 = self GetTagOrigin( "tag_flash" );
	array[ "speed" ] 	 = 50 * speed_scaler;
	start				 = ( self.origin[ 0 ], self.origin[ 1 ], muzzle[ 2 ] );

	origin					= start + ( ( AnglesToForward( self.angles ) * dist ) ) + ( 0, 0, height );
	array[ "start_origin" ] = start + ( ( AnglesToForward( self.angles + ( 0, angle, 0 ) ) * dist ) ) + ( 0, 0, height );
	array[ "end_origin" ]	= start + ( ( AnglesToForward( self.angles + ( 0, ( angle * -1 ), 0 ) ) * dist ) ) + ( 0, 0, height );

	if ( forward )
		array[ "node_origin" ] = array[ "end_origin" ];
	else
		array[ "node_origin" ] = array[ "start_origin" ];

	array[ "target" ] = Spawn( "script_origin", origin );
//	array[ "target" ] = Spawn( "script_model", origin );
//	array[ "target" ] SetModel( "weapon_us_smoke_grenade" );
	return array;
}

stop_spray_and_pray_cleanup( target, msg )
{
	self waittill( msg );

	self.no_pistol_switch = self.old_pistol_switch;
	self ClearEntityTarget();
	target Delete();
}

lobby_dead_bodies()
{
	//align nodes
	s_anim_align_airport_entrance 	= getstruct( "anim_align_airport_entrance", "targetname" );
	s_anim_align_airport_escalators = getstruct( "anim_align_airport_escalators", "targetname" );
		
	//Lobby Bodies
	s_anim_align_airport_entrance thread spawn_dead_by_animname( "airport_male_suit" );
	s_anim_align_airport_entrance thread spawn_dead_by_animname( "male_blue_khaki", "head_city_civ_male_a_drone" );
	s_anim_align_airport_entrance thread spawn_dead_by_animname( "male_red_blue", "head_city_civ_male_a_drone" );
	s_anim_align_airport_entrance thread spawn_dead_by_animname( "female_gray_blue", "head_city_civ_female_a_drone" );
	s_anim_align_airport_entrance thread spawn_dead_by_animname( "male_green_blue", "head_city_civ_male_a_drone" );
	s_anim_align_airport_entrance thread spawn_dead_by_animname( "male_red_stripes", "head_city_civ_male_a_drone" );	

	s_anim_align_airport_entrance thread spawn_dead_by_animname( "security", "head_city_civ_male_a_drone" );	

	//Escalator Bodies
	s_anim_align_airport_escalators thread spawn_dead_by_animname( "escalator_male_suit" );		
	s_anim_align_airport_escalators thread spawn_dead_by_animname( "escalator_female_green", "head_city_civ_female_a_drone" );		
	s_anim_align_airport_escalators thread spawn_dead_by_animname( "escalator_male_red", "head_city_civ_male_a_drone" );		
	s_anim_align_airport_escalators thread spawn_dead_by_animname( "escalator_male_blue", "head_city_civ_male_a_drone" );		
}
		
spawn_dead_by_animname( str_anim_name, head_model )
{
	a_keys = GetArrayKeys( level.scr_anim[ str_anim_name ] );
	for ( i=0; i < level.scr_anim[ str_anim_name ].size; i++ )
	{
		m_dead_body = spawn_anim_model( str_anim_name, self.origin );
		m_dead_body.script_noteworthy = "setup_emt_anim";
		
		if ( IsDefined( head_model ) )
		{
			m_dead_body Attach( head_model, "", true );
			m_dead_body.headmodel = head_model;
		}	

		str_scene_name = a_keys[ i ];
		m_dead_body SetCanDamage( false );
		
		self thread anim_loop_solo( m_dead_body, str_scene_name );		
	}
}


clean_up_dead_bodies()
{
	dead_bodies = GetEntArray("setup_emt_anim", "script_noteworthy");
	
	flag_wait( "setup_emt_anim" );
	
	foreach( body in dead_bodies )
		body Delete();
}

betray_me_dialogue( guy )
{
	level.makarov dialogue_queue( "presc_mkv_iknowwhat" ); //I know what you have done, Yuri.  I know what you have told them.  
	flag_wait( "mak_betray_dialog_02" );
	level.makarov dialogue_queue( "presc_mkv_myfriend" ); //My friend... My ally... My betrayer.
	flag_wait( "mak_betray_dialog_03" );
	level.makarov dialogue_queue( "presc_mkv_changeforever" ); //What happens here today, will change the world forever.
	flag_wait( "mak_betray_dialog_04" );
	level.makarov dialogue_queue( "presc_mkv_nothingcanstop" ); //Nothing can stop this...
	flag_wait( "mak_betray_dialog_05" );
	level.makarov dialogue_queue( "presc_mkv_notevenyou" ); //Not even you.
}

medic_dialogue()
{
	flag_wait( "emt_begin" );
	
	wait( 3 );
	
	level.emt dialogue_queue( "presc_med_liveone" ); //We've got a live one, here!
}
