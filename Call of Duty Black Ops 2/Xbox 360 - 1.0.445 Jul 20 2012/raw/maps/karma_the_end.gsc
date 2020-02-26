
#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_objectives;
#include maps\_dialog;
#include maps\_glasses;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_glasses.gsh;
#insert raw\maps\karma.gsh;

#define PERK_ARMORY_LAUNCHER "fhj18_dpad_sp"
#define NEXTMISSION_FADE_TIME 1
#define EXPLODER_DEFALCO_OSPREY_SPOTLIGHT 1010 
#define EXPLODER_DEFALCO_DEAD_EXPLOSIONS 1020
/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "use_alt_escape_anim" );		// trigger
	flag_init( "mission_ends" );
	flag_init( "final_animation_started" );
	
	// ending resolution flags
	flag_init( "shot_timeout" );
	flag_init( "shot_defalco" );
	flag_init( "shot_defalco_fatally" );
	flag_init( "shot_karma" );
	flag_init( "shot_karma_fatally" );
	flag_init( "shot_karma_hitbox" );
	flag_init( "shot_karma_vitals" );
	flag_init( "defalco_can_be_killed_safely" );
	flag_init( "player_fired_rocket_at_defalco" );
	
	flag_init( "karma_captured" );
	flag_init( "defalco_killed_in_vtol" );
	flag_init( "skip_end_sequence_gameplay" );
	flag_init( "vtol_doors_start_closing" );
	flag_init( "standoff_logic_done" );
	flag_init( "start_end_sequence" );
	flag_init( "use_player_react_anim" );
	flag_init( "defalco_shootdown_timed_out" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
	sp_guard_left = get_ent( "defalco_escort_left", "targetname", true );
	sp_guard_left add_spawn_function( ::defalco_guard_setup );
	
	sp_guard_right = get_ent( "defalco_escort_right", "targetname", true );
	sp_guard_right add_spawn_function( ::defalco_guard_setup );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_the_end()
{
//	init_hero( "hero_name_here" );

	skipto_teleport( "skipto_the_end" );
	
	level.ai_harper = init_hero_startstruct( "harper", "e10_harper_start" );
	level.ai_salazar = init_hero_startstruct( "salazar", "e10_salazar_start" );
	level.ai_redshirt1 = init_hero_startstruct( "redshirt1", "e10_redshirt1_start" );
	level.ai_redshirt2 = init_hero_startstruct( "redshirt2", "e10_redshirt2_start" );
}

skipto_the_end_perk()
{
	_give_player_rocket_launcher();
	skipto_the_end();
}

// debug testing function
_give_player_rocket_launcher()
{
	level.player GiveWeapon( PERK_ARMORY_LAUNCHER );
	level.player SetActionSlot( 3, "weapon", PERK_ARMORY_LAUNCHER );
	level.player GiveMaxAmmo( PERK_ARMORY_LAUNCHER );	
}


/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{
	// Temp Development info
	/#
		IPrintLn( "Exit Club" );
	#/

	// Initialization
	spawn_funcs();
	maps\karma_2_anim::the_end_anims();
	
	// Objectives
	level thread the_end_objectives();

	// Make characters pacififts etc....
	setup_endscene_characters();
	
	//adding waittill for gunshot sound
	level thread GunShotAudioWait();

	flag_set( "use_player_react_anim" );  // turn this off to give gameplay back during ending
	
	exploder( EXPLODER_DEFALCO_OSPREY_SPOTLIGHT );
	level.player.str_old_vision_set = level.player GetVisionSetNaked();
	
	t_start = get_ent( "trigger_start_defalco_end_anim", "targetname", true );
	add_trigger_function( t_start, ::flag_set, "start_end_sequence" );
	
	// Scene Animations
	if ( flag( "skip_end_sequence_gameplay" ) )
	{
		end_sequence_cinematic();
	}
	else 
	{
		end_sequence_gameplay();
	}
	
	// set story stats before we go to next mission
	if ( _is_karma_dead() )
	{
		level.player set_story_stat( "KARMA_DEAD_IN_KARMA", true );
	}
	
	if ( _is_karma_captured() )
	{
		level.player set_story_stat( "KARMA_CAPTURED", true );
	}
	
	if ( _is_defalco_dead() )
	{
		level.player set_story_stat( "DEFALCO_DEAD_IN_KARMA", true );
	}
	
	level.player notify( "mission_finished" );
	
	screen_fade_out( NEXTMISSION_FADE_TIME );
	
	nextmission();	
}


//
//	Need an AI to run something when spawned?  Put it here.
spawn_funcs()
{
//	add_spawn_function_veh( "intro_drone", ::intro_drone );
}

the_end_objectives()
{
	// player comes around corner to start animation
	flag_wait( "start_end_sequence" );
	
	// check flag to see if gameplay occurs
	if ( !flag( "skip_end_sequence_gameplay" ) )
	{
		wait 5;  // let objective appear when player gets ready to shoot
		
		// if gameplay, show 'disable karma' objective
		set_objective( level.OBJECTIVE_DISABLE_KARMA, level.ai_karma, "" );
		
		// wait for shot sequence to play out
		flag_wait( "standoff_logic_done" );
		
		waittillframeend; // prevent race
		
		// this objective should pass when karma is dead OR with the squad
		if ( flag( "shot_karma_hitbox" ) || flag( "shot_karma_fatally" ) )
		{
			str_state = "done";
		}
		else // otherwise consider it a failure to disable her
		{
			str_state = "failed";
		}
		
		set_objective( level.OBJECTIVE_DISABLE_KARMA, undefined, str_state );
	}
}

//*****************************************************************************
//*****************************************************************************

setup_endscene_characters()
{
	level.ai_harper.pacifist = true;
	level.ai_salazar.pacifist = true;
	level.ai_redshirt1.pacifist = true;
	level.ai_redshirt2.pacifist = true;
	level.ai_harper.ignoreall = true;
	level.ai_salazar.ignoreall = true;
	level.ai_redshirt1.ignoreall = true;
	level.ai_redshirt2.ignoreall = true;

	if( !IsDefined(level.ai_defalco) )
	{	
		level.ai_defalco = simple_spawn_single( "defalco" );
	}
	
		level.ai_defalco.ignoreme = true;
		level.ai_defalco.animname = "defalco";
	level.ai_defalco DisableAimAssist();
		level.ai_defalco.health = 99999;
	level.ai_defalco.team = "axis";  // don't show friend name
	level.ai_defalco set_ignoreall( true );

	if( !IsDefined(level.ai_karma) )
	{	
		level.ai_karma = simple_spawn_single( "karma" );
	}
	
		level.ai_karma.ignoreme = true;
		level.ai_karma.animname = "karma";
		level.ai_karma.health = 99999;
	level.ai_karma.team = "allies"; 
	level.ai_karma.name = " ";
	level.ai_karma set_ignoreall( true );
}


end_sequence_gameplay()
{
	debug_print_line( "playing ending gameplay sequence" );
	
	_defalco_escape_setup();
	
	flag_wait( "start_end_sequence" );

	// Clean up Ents from Event 9
	maps\karma_little_bird::cleanup_ents_for_defalco_escape_animation();
	
	level.player playsound ( "evt_standoff_start" );
	level thread setup_ambience();

	level run_scene_first_frame( "escape_start" );
	level karma_toggle_scan_models( "escape_start", false );  // hide organs!
	level thread escape_start_player_setup();
	wait 0.5; // delay scene while salazar gives you his sniper rifle
	
	// Take away players weapons
	level.player take_weapons();
	level thread battlechatter_off();

	// Make the primary characters invulnerable
	level thread make_scene10_characters_invulnerable();
	

	//************************
	// SCENE STARTS - BLOCKING
	//************************
	
	//level thread karma_showdown_dialog();
	SetDvar( "aim_assist_script_disable", 1 );

	level thread run_scene_and_delete( "escape_start" );
	
	wait 0.1; // let models spawn in before trying to grab them
	karma_toggle_scan_models( "escape_start", false );  // hide organs!
	flag_wait( "escape_start_player_done" );  // wait until scope overlay is active
	wait 1;  // 'time for display to initialize'
	karma_toggle_scan_models( "escape_start", true );  // show organs!
	
	scene_wait( "escape_start" );

	//*****************************************
	// SETUP: Prepare for the shoot Karma Scene
	//*****************************************
	
	// Get accurate damage info on Karma being shot
	level.ai_karma.overrideActorDamage = ::karma_shot_callback_new;
	level.ai_defalco.overrideActorDamage = ::defalco_shot_callback;
	
	// watch for player's shot in case of miss
	level thread player_shot_check_thread();

	//****************************
	// START THE SHOOT KARMA SCENE
	//****************************
	
	level thread run_scene( "ending_shoot_karma" );
	
	flag_set( "e10_player_raise_gun" );
	
	clientnotify( "kbss" );
	level.player playsound( "evt_bodyscan_start" );
	level.player playloopsound( "evt_bodyscan_loop", .5 );

	// Swap  Karma to the Scan Model
	karma_toggle_scan_models( "ending_shoot_karma", true );  // new animation, so show organs again

	// show hint
	screen_message_create( &"KARMA_2_HINT_SHOOT_KARMA" );
	
	_setup_organ_damage_check();  // check for damage on models
	
	// determine timeout condition and wait for gameplay logic to be determined
	n_timeout_max = _get_time_window_to_shoot_karma();
	n_time_scale = _get_timescale_to_shoot_karma( n_timeout_max );
	n_timeout_real_time = n_timeout_max * n_time_scale;  // SetTimeScale will wait ( n_timeout_max / N_TIME_SCALE ) otherwise
	delay_thread( n_timeout_real_time, ::flag_set, "shot_timeout" );
	waittill_notify_or_timeout( "standoff_logic_done", n_timeout_real_time );

	LUINotifyEvent( &"hud_karma_circulatory_remove_scan", 1, level.ai_karma GetEntityNumber() );

	flag_set( "standoff_logic_done" );  // kill off any threads still running in case of timeout condition
	
	screen_message_delete();  // remove hint since gameplay is done
	
	//***********************************************************************
	// PLAY THE APPROPRIATE ENDING - Based on results of end_condition thread
	//***********************************************************************

	level notify( "shootout_finished" );
	
	clientnotify( "kbse" );
	level.player stoploopsound( 1 );
	level.player playsound( "evt_bodyscan_end" );
			
	waittillframeend; // make sure dust has settled and all flags are set
	
	str_ending = _get_ending_resolution();
	debug_print_line( str_ending );
	
	SetTimeScale( 0.2 );  // immediately put scene into faster timescale than shot window so reduce pop
	end_scene( "ending_shoot_karma" );
	
	level thread _restore_timescale( str_ending );
	level thread _play_player_reaction( str_ending );
	
	switch ( str_ending )
	{			
		case "shot_timeout":
			shot_timeout();  // defalco leaves with karma alive
			break;
			
		case "shot_karma_hitbox":
			shot_karma_hitbox();  // defalco leaves, karma with squad
			break;
			
		case "shot_karma_nonvitals":
			shot_karma_nonvitals();  // defalco leaves, karma with defalco
			break;
			
		case "shot_karma_dead":
			shot_karma_dead();  // defalco leaves, karma dead
			break;
			
		case "shot_defalco_dead":
		case "shot_defalco_wounded":
			shot_defalco_dead();  // defalco dead, bombs go off: mission fail
			break;

// TJanssen - 5/24 - made Defalco wounded equivalent to dead; no hit react anims available			
//		case "shot_defalco_wounded":   // note: same as miss logic with additional defalco react anim
//			shot_defalco_wounded();  // defalco hit by bullet, sets off bombs, karma alive with defalco
//			break;
		
		case "shot_missed":
			shot_missed();  // karma alive with defalco
			break;
		
		default:
			AssertMsg( "ending " + str_ending + " is not a supported case for end sequence!" );
			break;
	}
}

_play_player_reaction( str_ending )
{
	level waittill( "timescale_restored" );
	
	level.player VisionSetNaked( level.player.str_old_vision_set, 0.1 );
	level.player.str_old_vision_set = undefined;	
	LUINotifyEvent( &"hud_karma_circulatory_end", 1, level.ai_karma GetEntityNumber() );
	
	if ( flag( "use_player_react_anim" ) )
	{
		if ( ( str_ending == "shot_timeout" ) || ( str_ending == "shot_karma_nonvitals" ) || ( str_ending == "shot_missed" ) )  // timeout has special timing condition
		{
			flag_set( "player_shot_reaction_done" );
			level notify( "standoff_unlink_player" ); 
		}
		else 
		{
			level thread run_scene( "player_shot_reaction" );
		}
	}
}	

// if player doesn't get to helipad in time, don't play gameplay portion
end_sequence_cinematic()
{
	debug_print_line( "skipping ending gameplay sequence" );
	
	flag_set( "karma_captured" );
	
	_defalco_escape_setup();
	level thread _defalco_vtol_close_bay();  // don't let player see inside vtol as he arrives
	
	flag_wait( "start_end_sequence" );

	// Clean up Ents from Event 9
	maps\karma_little_bird::cleanup_ents_for_defalco_escape_animation();
	
	level.player playsound ( "evt_standoff_start" );
	level thread setup_ambience();
	
	level thread defalco_escapes_on_vtol();
	
	level.player say_dialog( "sect_we_need_to_get_back_0", 2 ); // We need to get back to the Obama...
	
	level.player say_dialog( "sect_find_out_why_the_gir_0" ); // Find out why the girl's so important to Menendez...
	
	wait 10;  // don't end level immediately
}

_is_karma_dead()
{
	b_karma_killed_in_standoff = flag( "shot_karma_fatally" );
	b_karma_killed_in_vtol = ( flag( "karma_captured" ) && flag( "defalco_killed_in_vtol" ) );
	
	b_karma_killed = ( b_karma_killed_in_standoff || b_karma_killed_in_vtol );
	
	return b_karma_killed;
}

_is_karma_captured()
{
	b_karma_captured = flag( "karma_captured" );
	
	return b_karma_captured;	
}

_is_defalco_dead()
{
	b_defalco_killed = flag( "defalco_killed_in_vtol" );
	
	return b_defalco_killed;
}

_defalco_escape_setup()
{
	s_pos = GetStruct( "s_escape_vtol_pos", "targetname" );
	
	// use real struct position if it's in the map. TODO: BSP and make this the only one -TJanssen
	s_pos_2 = get_struct( "end_vtol_location", "targetname" );
	if ( IsDefined( s_pos_2 ) )
	{
		s_pos = s_pos_2;
	}
	
	vh_vtol = GetEnt( "defalco_osprey", "targetname" );
	vh_vtol.takedamage = false;  // don't let vtol die until it's in the air
	vh_vtol.animname = "defalco_osprey";
	vh_vtol.origin = s_pos.origin;
	vh_vtol.angles = s_pos.angles;
}

_restore_timescale( str_ending )
	{
		SetTimeScale( 0.2 );  // since time scale is variable up to this point, even it out
	level.player DisableWeaponFire();
		
	wait 1.5; // give same reaction time to shots, every time
	
	SetTimeScale( 1.0 );
	
	level.player EnableWeaponFire();
	level notify( "timescale_restored" );
}

_detach_ballista_model( e_weapon )
{
	anim_weapon = level.scr_anim[ "ending_weapon" ][ "escape_start_player" ];
	n_anim_time = GetAnimLength( anim_weapon );
	const n_fade_time = 0.25;
	const n_ads_fraction = 0.7;
	
	wait n_anim_time - n_fade_time;
	
	screen_fade_out( n_fade_time );
	
	scene_wait( "escape_start_player" );

	while ( level.player PlayerADS() < n_ads_fraction )
	{
		wait 0.05;
	}
	
	screen_fade_in( n_fade_time );
	
	level.player VisionSetNaked( "Sp_karma2_end", 3.0 );
}

_attach_ballista_model( e_player_body )
{
	e_player_body Attach( "t6_wpn_sniper_ballista_prop_view", "tag_weapon_right" );
}

escape_start_player_setup()
{
	// GiveWeapon early to get around 'firstraise' anim playing when we get core control
	level.player GiveWeapon( "ballista_karma_sp" );
	level.player TakeWeapon( "ballista_karma_sp" );

	// get player in position via animation
	level thread run_scene( "escape_start_squad" );
	level thread _wait_to_catch_gun();
	run_scene( "escape_start_player" );
	ai_defalco = get_ent( "defalco_ai", "targetname", true );
	level.player delay_thread( 0.5, ::look_at, ai_defalco );
	LUINotifyEvent( &"hud_karma_circulatory_scan" );
	
	// link player to fixed point
	e_temp = Spawn( "script_origin", level.player.origin );
	e_temp.angles = level.player.angles;
	level.player SetStance( "crouch" );
	level.player AllowStand( true );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player AllowJump( false );
	level.player PlayerLinkToDelta( e_temp, undefined, 0, 30, 30, 30, 2 );
	
	level.player thread _give_player_sniper_weapon();
	//level.player thread trace_test();  // DEBUG FUNCTION ONLY
	level.player thread _timescale_for_shot();
	
	// wait for escape sequence logic to be finalized
	level waittill( "standoff_logic_done" );
	
	level waittill_any( "defalco_detonates_explosives", "standoff_unlink_player", "player_shot_reaction_done" );
	
	level.player TakeWeapon( "ballista_karma_sp" );
	level.player SetForceAds( false );

	flag_wait( "player_shot_reaction_done" );
	
	// restore player movement
	level.player Unlink();
	level.player AllowStand( true );
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	level.player AllowJump( true );
	e_temp Delete();
	
	level.player give_weapons_wrapper();
	
	waittillframeend;  // wait for other movement clearing logic to finish before changing to another state
	
	if ( flag( "use_player_react_anim" ) )
	{
		//level.player _temporarily_restrict_player_movement();	
	}
}

// since give_weapons can be called in multiple places, ensure it'll only run once
give_weapons_wrapper()  // self = player
{
	DEFAULT( self.got_weapons_back, false );
	
	if ( !self.got_weapons_back )
	{
		self give_weapons();
		self.got_weapons_back = true;
	}
}

_wait_to_catch_gun()
{
	wait( 3 );
	LUINotifyEvent( &"hud_karma_circulatory_fade", 1, level.ai_karma GetEntityNumber() );
}

_give_player_sniper_weapon()
{
	self giveweapon( "ballista_karma_sp" );
	self switchtoWeapon( "ballista_karma_sp" );
	self GiveMaxAmmo( "ballista_karma_sp" );
	
	level.player SetForceAds( true );
	level.player DisableWeaponFire();
}

_timescale_for_shot()
{
	level endon( "standoff_logic_done" );
	
	flag_wait( "e10_player_raise_gun" );
	level.player EnableWeaponFire();
	
	n_time_scale = _get_timescale_to_shoot_karma();
	SetTimeScale( n_time_scale );	
}

// figure out how long we have to shoot karma, based on difficulty
_get_time_window_to_shoot_karma()
{
	str_difficulty = getdifficulty();
	
	a_time_window = [];
	a_time_window[ "easy" ] 	= 14;
	a_time_window[ "medium" ] 	= 12;
	a_time_window[ "hard" ] 	= 10;
	a_time_window[ "fu" ] 		= 8;	
	
	return a_time_window[ str_difficulty ];
}

// figure out what the timescale value should be, based on difficulty setting. Do NOT allow animation to loop!
_get_timescale_to_shoot_karma( n_shoot_time )
{
	n_anim_time = GetAnimLength( level.scr_anim[ "karma" ][ "ending_shoot_karma" ] );
		
	// pick appropriate time window before timeout condition is achieved, based on difficulty
	if ( !IsDefined( n_shoot_time ) )
	{
		n_shoot_time = _get_time_window_to_shoot_karma();
	}
	
	n_time_scale = ( n_anim_time / n_shoot_time );
	
	return n_time_scale;
}

_create_hud_elem( x_pos = 0, y_pos = 0, str_horiz_align = "center", str_vert_align = "middle", v_color = (1,1,1) )
{
	hud_elem = NewHudElem();
	hud_elem.x = x_pos;
	hud_elem.y = y_pos;
	hud_elem.horzAlign = str_horiz_align;
	hud_elem.vertAlign = str_vert_align;
	hud_elem.color = v_color;
	
	hud_elem.foreground = true;
	hud_elem.sort = 1;
	hud_elem.alpha = 1;			
	hud_elem.font = "objective";
	hud_elem.fontScale = 1;
	
	return hud_elem;
}

_get_ending_resolution()
{
	if ( flag( "shot_timeout" ) )
	{
		// timeout condition: karma goes with defalco
		str_end_scene = "shot_timeout";
	}
	else // player fired a shot. what did he hit?
	{
		if ( flag( "shot_karma" ) )
		{
			if ( flag( "shot_karma_vitals" ) )
			{
				if ( flag( "shot_karma_hitbox" ) )  // BEST SCENARIO
				{
					str_end_scene = "shot_karma_hitbox";
				}
				else // ( flag( "shot_karma_fatally" ) )
				{
					// karma dead, defalco escapes
					str_end_scene = "shot_karma_dead";
				}
			}
			else 
			{
				// karma alive and with defalco
				str_end_scene = "shot_karma_nonvitals";
			}
		}		
		else if ( flag( "shot_defalco" ) )
		{
		   	if ( flag( "shot_defalco_fatally" ) )
		   	{
		   		// mission fail: bombs go off
		   		str_end_scene = "shot_defalco_dead";
		   	}
		   	else   // player shot defalco but not fatally
		   	{
		   		// 'miss' scenario temporarily; 'hit react' scenario later
		   		// karma alive with defalco
		   		str_end_scene = "shot_defalco_wounded";
		   	}
		}
		else // encompasses all other scenarios; considered a miss fictionally
		{
			// player missed shot; karma alive and with defalco
			str_end_scene = "shot_missed";
		}
	}
	
	return str_end_scene;
}

// SUCCESS - Karma alive, with squad. Defalco leaves
shot_karma_hitbox()
{
	level notify( "player_alive_challenge_complete" );	
	
	// Triggers MISSION SUCCESS
	level.e_extra_cam ClearClientFlag( CLIENT_FLAG_KARMA_VITAL_CAM );
	
	SetDvar( "aim_assist_script_disable", 1 );
	
	level thread defalco_detonates_explosives();
	
	level.player PlaySound( "evt_standoff_success" );
	
	level thread defalco_escapes_on_vtol();
	level thread run_scene( "escape_guard_deaths" );
	level thread _shot_karma_hitbox_friendly_sequence();
	level thread _defalco_shoots_then_idles_in_vtol();
	level thread _shot_karma_hitbox_player_sequence();
	
	delay_thread( 1.5, ::vo_vtol_takes_off );
	
	flag_wait( "player_ending_success_started" );
	wait_for_scene_to_nearly_complete( "player_ending_success", "player_body" );
}

_play_final_player_anim( e_player_body )
{
	flag_set( "final_animation_started" );
}

_shot_karma_hitbox_friendly_sequence()
{
	run_scene( "ending_success" );	
	level thread _end_salazar_idle( "ending_success" );
	level thread run_scene( "ending_success_idle" );
	
	flag_wait( "player_ending_success_started" );
	
	run_scene( "ending_success_aftermath" );
}

_end_salazar_idle( str_scene )
{
	// get anim time remaining for salazar
	anim_salazar_hitfatal = level.scr_anim[ "salazar" ][ str_scene ];
	n_anim_time_remaining = level.ai_salazar GetAnimTime( anim_salazar_hitfatal );
	
	// wait that amount of time
	wait n_anim_time_remaining;

	run_scene( "ending_salazar_idle" );
}

_shot_karma_hitbox_player_sequence()
{
	scene_wait( "player_shot_reaction" );
	
	_defalco_escape_conditionals( true );
	
	run_scene( "player_ending_success" );
}

defalco_escapes_on_vtol( b_close_door = false )
{
	debug_print_line( "defalco escapes on VTOL" );
	
	// TEMP: not all animations in yet; cheat otherwise notetrack driven flag
	if ( b_close_door )
	{
		_defalco_vtol_close_bay();
	}
	
	flag_wait( "e10_close_vtol_door" );  // wait until door is closed for VTOL to take off
	
	level thread _defalco_vtol_retract_landing_gear();
	
	level thread launch_escape_vehicle();  // handle VTOL movement
}

_defalco_escape_conditionals( b_link_player = false )
{	
	const n_gameplay_timeout = 10;
	level.player give_weapons_wrapper();
	
	flag_wait( "defalco_can_be_killed_safely" );
	
	b_player_can_kill_defalco = ( level.player player_has_weapon( PERK_ARMORY_LAUNCHER ) && ( level.player GetAmmoCount( PERK_ARMORY_LAUNCHER ) > 0 ) );	
		
	if ( b_player_can_kill_defalco )
	{
		debug_print_line( "player has rocket launcher!" );
		delay_thread( n_gameplay_timeout, ::flag_set, "defalco_shootdown_timed_out" );
		
		if ( b_link_player )
		{
			// link player to his current position
			waittillframeend; // possible Unlink call from generic function; make sure it doesn't interfere
			e_temp = Spawn( "script_origin", level.player.origin );
			e_temp.angles = level.player.angles;
			level.player PlayerLinkToDelta( e_temp, undefined, 0, 30, 40, 20, 20 );
		}
		
		if ( flag( "karma_captured" )  && !flag( "shot_karma_fatally" ) )
		{
			level.player thread say_dialog( "sect_i_know_0" );  // I know...
		}
		else 
		{
			level.player thread say_dialog( "sect_good_to_know_0" ); // Good to know.
		}
		
		level.player thread play_defalco_death_vo();
		
		flag_wait_any( "defalco_shootdown_timed_out", "defalco_killed_in_vtol" );
		
		if ( b_link_player )
		{
			level.player Unlink();
			e_temp Delete();
		}
	}
	else
	{
		debug_print_line( "player does NOT have rocket launcher" );
		// level.player say_dialog( "harp_nice_going_egghead_0" ); // Nice going, Egghead.  // removed since line was tonally wrong
		if ( flag( "karma_captured" ) )
		{
			level.player thread say_dialog( "sect_i_m_sorry_chloe_0" ); // I'm sorry, Chloe...
		}
		else 
		{
			level.player thread say_dialog( "sect_good_to_know_0" ); // Good to know.  // temp replacement
		}
	}			
}

_defalco_shoots_then_idles_in_vtol()
{
	run_scene( "ending_defalco_shoots_salazar" );	

	vh_vtol = get_ent( "defalco_osprey", "targetname", true );
	level.ai_defalco LinkTo( vh_vtol );
}

play_defalco_death_vo()
{
	flag_wait( "defalco_killed_in_vtol" );
	
	while ( IsDefined( level.player.is_talking ) )
	{
		wait 0.1;
	}
	
	if ( flag( "karma_captured" ) )
	{
		level.player thread say_dialog( "sect_i_m_sorry_chloe_0" ); // I'm sorry, Chloe...
	}
	else 
	{
		level.player say_dialog( "sect_lights_out_fucker_0" );  // Lights out, fucker.		
	}
}

// checks if player has a particular weapon in his inventory
player_has_weapon( str_weapon )  // self = player
{
	b_has_weapon = false;
	
	a_weapons = self GetWeaponsList();
	
	foreach ( weapon in a_weapons )
	{
		if ( weapon == str_weapon )
		{
			b_has_weapon = true;
		}
	}
	
	return b_has_weapon;
}

shot_karma_nonvitals()
{
	flag_set( "karma_captured" );
	
	level thread defalco_detonates_explosives();
	level thread defalco_escapes_on_vtol();
	
	level thread run_scene( "escape_guard_deaths" );
	level thread _karma_wounded_and_idles_in_vtol();
	level thread run_scene( "ending_timeout_defalco" );
	level thread _defalco_vtol_close_bay_magic();
	level.player thread _karma_wounded_squad_runs_up();
	level thread _defalco_escape_conditionals();
	
	delay_thread( 1.5, ::vo_vtol_takes_off );
	delay_thread( 16, ::vo_ending );
	
	wait_for_scene_to_nearly_complete( "ending_squad_arrives_late", "harper" );
}

_karma_wounded_and_idles_in_vtol()
{
	level thread run_scene( "ending_karma_wounded" );
	level thread run_scene( "ending_timeout_defalco" );
	
	flag_wait( "vtol_doors_start_closing" );
	
	end_scene( "ending_karma_wounded" );
	run_scene( "ending_vtol_idle_karma" );
}

_karma_wounded_squad_runs_up()
{
	run_scene_first_frame( "ending_squad_arrives_late" );

	const n_time_to_drop_scope = 3;
	
	self DisableWeaponFire();
	
	wait n_time_to_drop_scope;
	
	level notify( "standoff_unlink_player" );
	level thread run_scene( "ending_squad_arrives_late" );	
}

// Karma dead, Defalco alive
shot_karma_dead()
{
	level.player playsound ( "evt_standoff_kill_karma" );
	level thread defalco_detonates_explosives();
	level thread defalco_escapes_on_vtol();
	level thread _shot_karma_dead_friendly_sequence();
	level thread _defalco_shoots_then_idles_in_vtol();
	level thread _shot_karma_dead_player_sequence();
	delay_thread( 1.5, ::vo_vtol_takes_off );
	
	flag_wait( "ending_failure_aftermath_started" );
	wait_for_scene_to_nearly_complete( "ending_failure_aftermath", "harper" );
}

_shot_karma_dead_friendly_sequence()
{
	run_scene( "ending_karma_killed" );	
	level thread _end_salazar_idle( "ending_karma_killed" );
	level thread run_scene( "ending_failure_idle" );
	
	flag_wait( "final_animation_started" );
	
	run_scene( "ending_failure_aftermath" );
}

_shot_karma_dead_player_sequence()
{
	scene_wait( "player_shot_reaction" );
	
	_defalco_escape_conditionals( true );
	
	run_scene( "player_ending_karma_dead" );
}

delete_if_defined( str_name, str_key = "targetname" )
{
	e_to_delete = get_ent( str_name, str_key );
	
	if ( IsDefined( e_to_delete ) )
	{
		e_to_delete Delete();
	}
}

shot_defalco_dead()
{
	level.player playsound ( "evt_standoff_kill_defalco"  );
	
	if ( !flag( "use_player_react_anim" ) )
	{
		level notify( "standoff_unlink_player" );
	}
	
	run_scene_and_delete( "ending_defalco_killed" );
	
	wait 9999; // arbitrary wait since next function to run is nextmission
}

shot_defalco_wounded()
{
	flag_set( "karma_captured" );

	level thread defalco_detonates_explosives();	
	level thread defalco_escapes_on_vtol();
	level thread _defalco_shoots_then_idles_in_vtol();
	run_scene( "ending_defalco_wounded" );	
}

// Karma leaves with Defalco, alive
shot_missed()
{
	flag_set( "karma_captured" );
	
	level.player PlaySound( "evt_standoff_kill_guards" );
	
	level thread defalco_detonates_explosives();
	level thread defalco_escapes_on_vtol();
	level thread _karma_and_defalco_escape_unharmed_then_idle();
	level thread run_scene( "escape_guard_deaths" );
	level thread run_scene( "ending_squad_arrives_late" );	
	level thread _clean_up_guards( "escape_guard_deaths" );
	level thread _defalco_vtol_close_bay_magic();
	level thread _defalco_escape_conditionals( false );
	
	delay_thread( 1.5, ::vo_vtol_takes_off );
	delay_thread( 16, ::vo_ending );
	
	wait_for_scene_to_nearly_complete( "ending_squad_arrives_late", "harper" );
}

_karma_and_defalco_escape_unharmed_then_idle()
{
	level thread run_scene( "ending_timeout_defalco" );
	run_scene( "ending_timeout_karma" );
	
	waittillframeend;
	
	run_scene( "ending_vtol_idle_timeout_defalco_and_karma" );
}

shot_timeout()
{
	flag_set( "karma_captured" );
	
	level.player thread _shot_timeout_handle_player_control();
	level.player thread say_dialog( "sect_no_0", 3 );  // No!!
	
//	level.player thread _give_back_weapons();
	level thread defalco_escapes_on_vtol();
	level thread _karma_and_defalco_escape_unharmed_then_idle();
	level thread run_scene( "ending_timeout_guards" );
	level thread _shot_timeout_link_to_vtol();
	level thread run_scene( "ending_squad_arrives_late" );
	level thread _defalco_escape_conditionals( false );
	
	delay_thread( 5, ::vo_vtol_takes_off );
	delay_thread( 16, ::vo_ending );
	
	wait_for_scene_to_nearly_complete( "ending_squad_arrives_late", "harper" );
} 

_shot_timeout_link_to_vtol()
{
	flag_wait( "vtol_doors_start_closing" );
	
	flag_set( "e10_close_vtol_door" );  // TODO: switch to different flag
	end_scene( "ending_timeout_karma" );
	end_scene( "ending_timeout_defalco" );
	end_scene( "ending_timeout_guards" );
	
	wait 0.1; // give time for scene to end, otherwise it'll cause weird linking offset issues (scene alignment points change here)
	
	level.ai_defalco Hide();
	level.ai_karma Hide();
	ai_pmc1 = get_ent( "defalco_escort_left", "targetname", true );
	ai_pmc1 Hide();
	ai_pmc2 = get_ent( "defalco_escort_right", "targetname", true );
	ai_pmc2 Hide();
	
	level thread run_scene( "ending_vtol_idle_timeout_guards" );
	run_scene( "ending_vtol_idle_timeout_defalco_and_karma" );
}

_shot_timeout_handle_player_control()
{
	level notify( "timeout_restored" );
	const n_time_to_drop_scope = 3;
	
	self DisableWeaponFire();
	
	wait n_time_to_drop_scope;
	
	self EnableWeaponFire();
	//level.player SetLowReady( true );
	level notify( "standoff_unlink_player" );
}

// this will figure out how long an animation is, then return X seconds before it's done.
// this function will allow smooth transitions to nextmission before animations complete.
wait_for_scene_to_nearly_complete( str_scene, str_actor, n_time_before_return = NEXTMISSION_FADE_TIME )
{
	anim_time_check = level.scr_anim[ str_actor ][ str_scene ];
	n_anim_time = GetAnimLength( anim_time_check );
	
	n_wait_time = n_anim_time - n_time_before_return;
	
	wait n_wait_time;
}

_clean_up_guards( str_scene )
{
	scene_wait( str_scene );
	
	delete_if_defined( "defalco_escort_left_ai" );
	delete_if_defined( "defalco_escort_right_ai" );
} 
 
// call this version for temp scripting
defalco_detonates_explosives( n_delay = 1.5 )
{
	wait n_delay;
	
	if ( !flag( "use_player_react_anim" ) )  // don't blow anything up if we're using player anim version
	{
		_defalco_detonates_explosives();
	}
}

// TODO: get notetracks on all animations to support this case
_defalco_detonates_explosives( ai_defalco )
{
	level notify( "defalco_detonates_explosives" );
	
	const n_shellshock_duration = 3.5;
	const n_damage_multiplier = 0.9;
	const n_blur_amount = 0.35;
	const n_blur_time = 4.0;
	n_damage_amount = Int( level.player.health * n_damage_multiplier );  // never kill the player, just bring him low
	
	// detonate explosive
	s_nearby_explosive = get_struct( "defalco_remote_charge", "targetname", true );
	s_nearby_explosive _play_generic_explosion( false );
	level.player SetBlur( n_blur_amount, n_blur_time );
	level.player ShellShock( "explosion", n_shellshock_duration );
	level.player DoDamage( n_damage_amount, level.player.origin );
	level.player SetLowReady( true );
	
	// knock player down
	level.player SetStance( "prone" );
}

// slow down the player so he can't rush into the vtol; works with timeout condition and all shot variations
_temporarily_restrict_player_movement()  // self = player
{
	const n_movement_scale_slow = 0.1;
	const n_movement_restore_time = 8;
	
	// temporarily restrict player movement
	self AllowProne( true );
	self AllowSprint( false );
	self AllowCrouch( true );
	self AllowStand( false );
	self AllowJump( false );

	self thread _restore_move_speed_scale( n_movement_restore_time, n_movement_scale_slow );
	self thread _give_back_weapons();
	
	// wait until Defalco is in VTOL
	flag_wait( "e10_close_vtol_door" ); 
	
	// restore movement once door is sufficiently closed
	self AllowStand( true );
	self SetMoveSpeedScale( 1.0 );
	self ResetPlayerViewRateScale();
	self AllowSprint( true );
	self AllowJump( true );		
}

_give_back_weapons( n_delay )
{
	flag_wait( "vtol_doors_start_closing" );
	
	level.player SetLowReady( false );
}

_restore_move_speed_scale( n_time, n_start_val )  // self = player
{
	n_delta = ( 1 - n_start_val );
	n_change_per_frame = ( ( n_delta / n_time ) / 20 );  
	const n_delay = 0.05;
	n_counter = 0;
	
	while ( n_time > 0 )
	{
		n_current_rate = n_start_val + ( n_counter * n_change_per_frame );
		self SetPlayerViewRateScale( n_current_rate * 100 );  // scale ( 0 to 100 )
		self SetMoveSpeedScale( n_current_rate );  // scale ( 0.0 to 1.0 )
		n_counter++;
		n_time -= n_delay;
		wait n_delay;
	}		
	
	self ResetPlayerViewRateScale();
	self SetMoveSpeedScale( 1.0 );
}

//
//	
karma_showdown_dialog()
{
	wait( 2 );
	debug_print_line( "We can't Let Karma Leave the Ship, we have to stop her abduction" );
	wait( 9 );
	debug_print_line( "Get Ready to Disable Karma, shoot her in the leg" );
}


//*****************************************************************************
// Handles the 'shootability' state of each character shroughout the scene(s)
//*****************************************************************************
make_scene10_characters_invulnerable()
{
	// Wait for the scene to start
	flag_wait( "escape_start_started" );

	//*************************************
	// Make primary characters invulnerable
	//*************************************
	ai_enemy_soldier_left = getent( "defalco_escort_left_ai", "targetname" );
	ai_enemy_soldier_right = getent( "defalco_escort_right_ai", "targetname" );
	
	ai_enemy_soldier_left 	thread magic_bullet_shield();
	ai_enemy_soldier_right 	thread magic_bullet_shield();
	level.ai_defalco 		thread magic_bullet_shield();
	
	//*******************************
	// Wait for the shootout to start
	//*******************************
	
	//level.ai_karma waittill( "shooot_karma_now" );
	
	level waittill( "shootout_finished" );
	
	level.ai_defalco		stop_magic_bullet_shield();
	ai_enemy_soldier_left	stop_magic_bullet_shield();
	ai_enemy_soldier_right	stop_magic_bullet_shield();
}

defalco_guard_setup()  // self = guard
{
	self.overrideActorDamage = ::guard_shot_callback;
	self.a.nodeath = true;  // guy shouldn't play death anim since he 'dies' during death anim
	
	flag_wait( "player_shot_reaction_done" );
	
	self.overrideActorDamage = undefined;
}


Play_Blood_Fx_On_Guard( str_guard )
{
	e_guard = getent( str_guard, "targetname" );
	PlayFXOnTag( level._effect["guard_blood"], e_guard, "tag_aim");
	
}

// self = guard. use for testing hitboxes mostly
guard_shot_callback( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	debug_print_line( self.targetname + " hit in " + sHitLoc );
	
	/#
		const n_scale_forward = 1000;
		v_start = vPoint;
		v_end = vPoint + ( vDir * n_scale_forward );
		
		RecordLine( v_start, v_end, ( 1, 0, 0 ) );  // track line in recorder for debugging
	#/	
	
	PlayFX( level._effect["guard_blood"], vPoint, vDir );
	
	return iDamage;
}

//*****************************************************************************
// self = karma
//*****************************************************************************
karma_shot_callback( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	//level notify( "karma_shootout_finished" );
	debug_print_line( "karma hit in " + sHitLoc  );
	
	/#
		const n_scale_forward = 1000;
		v_start = vPoint;
		v_end = vPoint + ( vDir * n_scale_forward );
		
		RecordLine( v_start, v_end, ( 1, 0, 0 ) );  // track line in recorder for debugging
	#/	

	flag_set( "shot_karma" );
		
	switch( sHitLoc )
	{
		case "helmet":								// Head
		case "head":
		case "neck":
			b_karma_killed = true;
			b_hit_in_vitals = true;
			break; 
	
		case "torso_upper":							// Upper Body
			b_karma_killed = true;
			b_hit_in_vitals = true;
			break;
		
		case "torso_lower":							// Lower Body
			b_karma_killed = false;
			b_hit_in_vitals = true;
			break; 
		
		case "right_arm_upper":						// Right Arm
		case "right_arm_lower":
		case "right_hand":
			b_karma_killed = false;
			b_hit_in_vitals = false;
			break; 
		
		case "left_arm_upper":						// Left Arm
		case "left_arm_lower":
		case "left_hand":
			b_karma_killed = false;
			b_hit_in_vitals = false;
			break; 

		case "right_leg_upper":						// Right Leg
		case "right_leg_lower":
		case "right_foot":
			b_karma_killed = false;
			b_hit_in_vitals = false;
			break; 
		
		case "left_leg_upper":						// Left Leg
		case "left_leg_lower":
		case "left_foot":
			b_karma_killed = false;
			b_hit_in_vitals = false;
			break;
		
		default:									// Unknown - Is it posible?
			b_karma_killed = false;
			b_hit_in_vitals = false;
			break;
	}
		
	if ( b_karma_killed )
	{
		flag_set( "shot_karma_fatally" );
	}
	
	if ( b_hit_in_vitals )
	{
		flag_set( "shot_karma_vitals" );
	}

	if( b_karma_killed )
	{
		PlayFX( level._effect["karma_blood"], vPoint, vDir );
	}
	
	return iDamage;
}

//**************************************************************************************************
// use info from callback to figure out where shot came from. the server is too slow to detect this 
// in time with the client, so use the existing information to get information about the shot,
// THEN do traces against models to see if Karma was hit in safe/fatal spot
//**************************************************************************************************
karma_shot_callback_new( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	flag_set( "shot_karma" );
	
	debug_print_line( "karma hit in " + sHitLoc  );
	
	const n_scale_backward = -50;
	const n_scale_forward = 1000;
	v_start = vPoint + ( vDir * n_scale_backward );
	v_end = vPoint + ( vDir * n_scale_forward );
	
	/#
		RecordLine( v_start, v_end, ( 1, 0, 0 ) );  // track line in recorder for debugging
	#/

	// make sure headshots are fatal in all cases
	switch( sHitLoc )
	{
		case "head":
		case "helmet":
		case "neck":
			flag_set( "shot_karma_vitals" );
			flag_set( "shot_karma_fatally" );
			break;
	}
	
	PlayFX( level._effect["karma_blood"], vPoint, vDir );	
	
	return iDamage;
}


_setup_organ_damage_check()
{
	level.ai_karma.m_organs _enable_damage();
	level.ai_karma.m_hitbox _enable_damage();
	
	level.ai_karma.m_hitbox thread _hitbox_wait_for_damage();
	level.ai_karma.m_organs thread _organs_wait_for_damage();
}

_enable_damage()  // self = model
{
	// script needs SetCanDamage = true and health value to send out 'damage' notify
	self SetCanDamage( true );
	self.health = 9999;
}

_organs_wait_for_damage()
{
	level endon( "standoff_logic_done" );
	
	self waittill( "damage" );
	
	debug_print_line( "model: organs hit" );
	
	flag_set( "shot_karma" );
	flag_set( "shot_karma_vitals" );
	flag_set( "shot_karma_fatally" );
}

_hitbox_wait_for_damage()
{
	level endon( "standoff_logic_done" );
	
	self waittill( "damage" );
	
	debug_print_line( "model: hitbox hit" );
	
	flag_set( "shot_karma" );
	flag_set( "shot_karma_vitals" );
	flag_set( "shot_karma_hitbox" );
	flag_clear( "shot_karma_fatally" );
}

defalco_shot_callback( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	flag_set( "shot_defalco" );
	
	switch( sHitLoc )
	{
		case "helmet":								// Head
		case "head":
		case "neck":
			b_defalco_killed = true;
			break; 
	
		case "torso_upper":							// Upper Body
			b_defalco_killed = true;
			break;
		
		case "torso_lower":							// Lower Body
			b_defalco_killed = false;
			break; 
		
		case "right_arm_upper":						// Right Arm
		case "right_arm_lower":
		case "right_hand":
			b_defalco_killed = false;
			break; 
		
		case "left_arm_upper":						// Left Arm
		case "left_arm_lower":
		case "left_hand":
			b_defalco_killed = false;
			break; 

		case "right_leg_upper":						// Right Leg
		case "right_leg_lower":
		case "right_foot":
			b_defalco_killed = false;
			break; 
		
		case "left_leg_upper":						// Left Leg
		case "left_leg_lower":
		case "left_foot":
			b_defalco_killed = false;
			break;
		
		default:									// Unknown - Is it posible?
			b_defalco_killed = false;
			break;
	}
		
	if ( b_defalco_killed )
	{
		flag_set( "shot_defalco_fatally" );
	}	
	
	PlayFX( level._effect["defalco_blood"], vPoint, vDir );
	return iDamage;
}


//*****************************************************************************
//*****************************************************************************

player_shot_check_thread()
{
	level.player waittill( "weapon_fired" );
	
	waittillframeend; // reaction time for actors, script callbacks
	
	flag_set( "standoff_logic_done" );
}


//*****************************************************************************
// Turn organs and hitbox models on and off, with optional delay. Blocking.
//*****************************************************************************

karma_toggle_scan_models( str_scene, b_show_models, n_delay = 0 )
{	
	if ( n_delay > 0 )
	{
		wait n_delay;
	}
	
	if ( !IsDefined( level.ai_karma ) )
	{
		level.ai_karma = get_ent( "karma_ai", "targetname", true );
	}
	
	if ( !IsDefined( level.ai_karma.m_organs ) )
	{
		level.ai_karma.m_organs = get_model_or_models_from_scene( str_scene, "karma_organ" );		
	}
	
	if ( !IsDefined( level.ai_karma.m_hitbox ) )
	{
		level.ai_karma.m_hitbox = get_model_or_models_from_scene( str_scene, "karma_hitbox" );
	}

	Assert( IsDefined( level.ai_karma.m_organs ), "Karmas organs model is missing from scene " + str_scene );
	Assert( IsDefined( level.ai_karma.m_hitbox ), "Karmas hitbox model is missing from scene " + str_scene );
	
	// client flags start at 0 with organs visible by default
	if ( b_show_models )
	{
		// attempts to get collision working on organs and hitbox
		level.ai_karma.m_organs SetModel( level.ai_karma.m_organs.model );  
		level.ai_karma.m_hitbox SetModel( level.ai_karma.m_hitbox.model ); 
		
		level.ai_karma.m_organs IgnoreCheapEntityFlag( true ); // make sure bullet collision is enabled
		level.ai_karma.m_hitbox IgnoreCheapEntityFlag( true ); // make sure bullet collision is enabled
		
		// SHOW models
		level.ai_karma.m_organs ClearClientFlag( CLIENT_FLAG_ORGAN_FADE );
		level.ai_karma.m_hitbox ClearClientFlag( CLIENT_FLAG_ORGAN_FADE );
	}
	else 
	{
		// HIDE models
		level.ai_karma.m_organs SetClientFlag( CLIENT_FLAG_ORGAN_FADE );
		level.ai_karma.m_hitbox SetClientFlag( CLIENT_FLAG_ORGAN_FADE );
	}
}

//*****************************************************************************
//*****************************************************************************

#using_animtree( "animated_props" );
launch_escape_vehicle( delay )
{
	vh_escape = getent( "defalco_osprey", "targetname" );

	vh_escape.health = 10000;
	vh_escape.overrideVehicleDamage = ::defalco_escape_vehicle_callback;
	vh_escape.drivepath = true;  // clean up pop in movement on takeoff
	
	vh_escape thread defalco_escape_vehicle_watch_for_death();
	
	flag_wait( "e10_close_vtol_door" );

	level thread launcher_sound();
	vh_escape playsound ( "evt_standoff_boat_leave" );
	
	// Door is closed, move Defalco since he's off camera
	if ( IsDefined( level.ai_defalco ) )
	{
		level.ai_defalco Hide();  // do not delete him since it'll stop scenes early
		level.ai_defalco LinkTo( vh_escape );
	}

	// Move the Launch Vehicle
	nd_escape_path = GetVehicleNode( "escape_plane_path_start", "targetname" );
	nd_escape_path.origin = vh_escape.origin;
	vh_escape thread go_path( nd_escape_path );
		
	// allow lock on with guided missiles
	flag_wait( "defalco_can_be_killed_safely" );
	v_offset = ( 0, 0, 50 );
	Target_Set( vh_escape, v_offset );
	maps\_heatseekingmissile::SetMinimumSTIDistance( 100 );	
	
	vh_escape.takedamage = true;  // actually allow death now
}

defalco_escape_vehicle_watch_for_death()  // self = defalco's vtol
{
	self waittill( "hack_helicopter_death" );
	
	if ( !flag( "defalco_can_be_killed_safely" ) )
	{
		const n_delay_explosions = 2;
		defalco_detonates_all_explosives( n_delay_explosions );
	}	
}

// temp measure for scripted fail conditions
defalco_detonates_all_explosives( n_delay = 1.5 )
{
	wait n_delay;
	
	_defalco_detonates_all_explosives();
}

// TODO: get notetracks added to defalco dead conditional animation
_defalco_detonates_all_explosives( ai_defalco )
{
	level.player thread	say_dialog( "fari_the_detonator_0" ); // The detonator!
	
	exploder( EXPLODER_DEFALCO_DEAD_EXPLOSIONS );
	
	a_explosions = get_struct_array( "defalco_death_explosion_struct", "targetname" );
	const n_explosion_delay_min = 0.15;
	const n_explosion_delay_max = 0.35;
	
	if ( a_explosions.size > 0 )
	{
		foreach ( struct in a_explosions )
		{
			struct _play_generic_explosion();
			wait RandomFloatRange( n_explosion_delay_min, n_explosion_delay_max );
		}
	}
	
	level.player _play_generic_explosion();  // blow something up in the players face, then kill him off
	level.player DoDamage( level.player.health, level.player.origin );
	missionfailedwrapper( &"KARMA_2_DEFALCO_ENDLEVEL_FATAL_SHOT" );	
}

_play_generic_explosion( b_do_damage = true )
{
	const n_damage = 65;
	const n_radius = 128;
	
	PlayFX( level._effect[ "kar_exp_ship_fail_player" ], self.origin );  
	PlaySoundAtPosition( "wpn_grenade_explode", self.origin );  // play at position so we don't need entity
	
	if ( b_do_damage )
	{
		RadiusDamage( self.origin, n_radius, n_damage, n_damage );
	}
}

defalco_escape_vehicle_callback( eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if ( IsSubStr( ToLower( type ), "bullet" ) )
	{
		iDamage = 0;
	}
	else if ( IsSubStr( ToLower( type ), "explosive" ) || IsSubStr( ToLower( type ), "projectile" ) )  // TEMP - WEAPON NOT YET AVAILABLE; NEEDS SPECIFIC WEAPON
	{
		iDamage = 99999;
		self notify( "hack_helicopter_death" );  // HACK: helicopter doesn't blow up in place
		flag_set( "defalco_killed_in_vtol" );
		PlayFX( self.deathfx, self.origin );
		self Hide();
	}
	
	return iDamage;
}

//*****************************************************************************
//*****************************************************************************

setup_ambience()
{
	setup_cagelight_fx( "cagelight" );  // helipad lights
	
	setup_vtol_escape_amb();
	
	setup_boat_escape_amb();
	
	flag_wait( "vtol_doors_start_closing" );
		
	stop_exploder( EXPLODER_DEFALCO_OSPREY_SPOTLIGHT );	
}

setup_cagelight_fx( str_light_targetname )
{
	a_cagelights = get_ent_array( str_light_targetname, "targetname" );
	foreach( m_light in a_cagelights )
	{
		m_light thread delay_cagelight_fx();
	}	
}

delay_cagelight_fx()  // self = cagelight
{
	if ( IsDefined( self.script_delay ) )
	{
		wait( self.script_delay );
	}
	
	PlayFXOnTag( level._effect["light_caution_red_flash"], self, "tag_origin"  );
}

setup_vtol_escape_amb()
{
	nd_start_array = GetVehicleNodeArray("e10_vtol_escape_start_node", "targetname");
	
	while(1)
	{
		for(i = 0; i < nd_start_array.size; i++)
		{
			vtol = maps\_vehicle::spawn_vehicle_from_targetname("e10_vtol_escape_spawner");
			vtol thread go_path(nd_start_array[i]);
			vtol thread delete_on_end_node();
			PlayFXOnTag(level._effect["vtol_exhaust"], vtol, "tag_origin");
			wait(RandomIntRange(2, 5));
		}
		wait(RandomIntRange(2, 5));
	}

}

setup_boat_escape_amb()
{
	nd_start_array = GetVehicleNodeArray("e10_boat_escape_node", "targetname");
	
	while(1)
	{
		for(i = 0; i < nd_start_array.size; i++)
		{
			boat = maps\_vehicle::spawn_vehicle_from_targetname("e10_escape_boat_spawner");
			boat thread go_path(nd_start_array[i]);
			boat thread delete_on_end_node();
			wait(RandomIntRange(2, 5));
		}
		wait(RandomIntRange(2, 5));
	}

}

delete_on_end_node()
{
	
	self waittill("reached_end_node");
	self delete();
}

launcher_sound()
{
	launcher_sound = spawn ( "script_origin" , (-83, 7563, -2754));
	launcher_sound playsound ( "evt_standoff_boat_launcher");
}

GunShotAudioWait()
{
	level waittill ( "e10_defalco_fires" );
	level.player playsound ( "evt_standoff_shot" );
}

debug_print_line( str_text )
{
	/#
	str_dvar = GetDvar( "debug_karma" );
	if ( str_dvar != "" )
	{
		iprintln( str_text );
	}
	#/
}

_defalco_vtol_close_bay_magic( n_close_time = 5 )
{
	wait_for_scene_to_nearly_complete( "ending_timeout_defalco", "defalco", n_close_time );
	
	_defalco_vtol_close_bay();
}

vo_vtol_takes_off()
{
	if ( flag( "karma_captured" )  && !flag( "shot_karma_fatally" ) )
	{
		level.ai_harper say_dialog( "harp_we_can_t_let_them_ta_0" ); // We can't let them take her, Section!
	}
	else 
	{
		level.player say_dialog( "sect_farid_defalco_esca_0" );  // Farid!  Defalco escaped - He'll blow the ship as soon as he's clear.
		level.player thread say_dialog( "fari_not_anymore_the_de_0" );  // Not anymore.  The detonator signal's jammed.		
	}
	
	flag_set( "defalco_can_be_killed_safely" );
}

vo_salazar_shot_karma_success( e_player_body )
{
	wait 3;
	vo_salazar_shot( e_player_body );
}

vo_ending_karma_success( e_player_body )
{
	wait 11;
	vo_ending();
}

vo_salazar_shot_karma_dead( e_player_body )
{
	wait 3;
	vo_salazar_shot( e_player_body );
}

vo_salazar_shot( e_player_body )
{
	level.player say_dialog( "sect_you_okay_sal_0" );  // You ok, Sal?
	level.ai_salazar say_dialog( "sala_i_swears_in_spani_0" );  // I... I am ok
}

vo_ending_karma_dead( e_player_body )
{
	wait 16;
	vo_ending();
}

vo_ending()
{
	level.player say_dialog( "sect_we_need_to_get_back_0" );  // We need to get back to the Obama...
	
	if ( _is_karma_dead() )
	{
		//level.player say_dialog( "" ); // Find out why the girl was so important to Menendez... - TJanssen: NO ASSET 5/25
		level.player say_dialog( "sect_find_out_why_the_gir_0" );  // Find out why the girl's so important to Menenez...
	}
	else 
	{
		level.player say_dialog( "sect_find_out_why_the_gir_0" );  // Find out why the girl's so important to Menenez...
	}
}

// should be sent by notetrack
_defalco_vtol_close_bay( e_closer )
{
	debug_print_line( "cargo bay doors closing" );
	flag_set( "vtol_doors_start_closing" );
	
	vh_vtol = get_ent( "defalco_osprey", "targetname", true );
	
	// link karma to vtol if she's captured
	if ( flag( "karma_captured" ) )
	{
		if ( IsDefined( level.ai_karma ) )
		{
			level.ai_karma Hide();  // do not delete her since it'll stop scenes early	
			level.ai_karma LinkTo( vh_vtol );
		}
	}	
	
	anim_doors_close = level.scr_anim[ "defalco_osprey" ][ "vtol_cargo_bay_closes" ];
	n_time = GetAnimLength( anim_doors_close );
	
	// using SetAnim call rather than _scene since vtol is moving on spline
	vh_vtol SetAnim( anim_doors_close, 1, 0, 1 ); 
	wait n_time;
	
	flag_set( "e10_close_vtol_door" );
	debug_print_line( "cargo bay doors closed" );
}

_defalco_vtol_retract_landing_gear()
{
	flag_wait( "e10_close_vtol_door" ); // make sure we're only playing one animation at a time on vtol
	
	wait 1;  // let vtol get off the ground before retracting gear
	vh_vtol = get_ent( "defalco_osprey", "targetname", true );
	anim_landing_gear_up = level.scr_anim[ "defalco_osprey" ][ "vtol_landing_gear_retracts" ];
	anim_doors_close = level.scr_anim[ "defalco_osprey" ][ "vtol_cargo_bay_closes" ];
	n_time = GetAnimLength( anim_landing_gear_up );
	
	debug_print_line( "vtol raising landing gear" );
	vh_vtol ClearAnim( anim_doors_close, 1 );
	vh_vtol SetAnim( anim_landing_gear_up, 1, 0, 1 ); 
}

trace_test()
{
	wait_for_first_player();
	
	iprintlnbold( "trace test start" );
	
	e_player = level.player;
	n_scale = 8000;
	
	while ( true )
	{
		v_start_pos = e_player GetEye();
		v_end_pos = ( AnglesToForward( e_player GetPlayerAngles() ) * n_scale ) + v_start_pos;
		//level thread draw_line_for_time( v_start_pos, v_end_pos, 1, 1, 1, 1 );
		//a_trace = BulletTrace( v_start_pos, v_end_pos, false, level.ai_karma, true, true, level.ai_karma.m_organs );
		a_trace = BulletTrace( v_start_pos, v_end_pos, false, level.ai_karma );
		
		str_ent = "NONE";
		str_fraction = "NONE";
		str_normal = "NONE";
		str_position = "NONE";
		str_surfacetype = "NONE";
		
		if ( IsDefined( a_trace[ "entity" ] ) )
		{
			str_ent = a_trace[ "entity" ].classname;
			
			if ( a_trace[ "entity" ] == level.ai_karma.m_organs )
			{
				iprintln( "organs" );
			}
			else if ( a_trace[ "entity" ] == level.ai_karma.m_hitbox )
			{
				iprintln( "hitbox" );
			}
			//iprintln( "ent = " + str_ent );
		}
		
		if ( IsDefined( a_trace[ "fraction" ] ) )
		{
			str_fraction = a_trace[ "fraction" ];
		}
		
		if ( IsDefined( a_trace[ "normal" ] ) )
		{
			str_normal = a_trace[ "normal" ];
		}
		
		if ( IsDefined( a_trace[ "position" ] ) )
		{
			str_position = a_trace[ "position" ];
		}
		
		if ( IsDefined( a_trace[ "surfacetype" ] ) )
		{
			str_surfacetype = a_trace[ "surfacetype" ];
		}
		
		level.debug_trace_ent = a_trace[ "entity" ];
		RecordLine( v_start_pos, a_trace[ "position" ], ( 1, 1,1 ) );
		
//		iprintln( "ent = " + str_ent );
//		iprintln( "fraction = " + str_fraction );
//		iprintln( "normal = " + str_fraction );
//		iprintln( "position = " + str_position );
//		iprintln( "surfacetype = " + str_surfacetype );
//		iprintln( "distance = " + Distance( v_start_pos, a_trace[ "position" ] ) );
		
		wait 0.05;
	}
}

// create streamer hints to show high mips on characters
_create_streamer_hint_on_ent( ai_guy )
{
	const n_hint_factor = 1.0;
	
	wait 0.1; // let animation start before creating hint

	DEFAULT( ai_guy.has_streamer_hint, false );  // this scene runs at first frame; only create one hint
	
	if ( !ai_guy.has_streamer_hint )
	{
		ai_guy.has_streamer_hint = true;
		
		v_streamer_hint_offset = ( 0, 0, 70 );  // rough height of AI; origin is at feet
		e_streamer_hint_defalco = CreateStreamerHint( ai_guy.origin + v_streamer_hint_offset, n_hint_factor );
		e_streamer_hint_defalco LinkTo( ai_guy );		
	}
}
_pmc1_shot_by_salazar( ai_pmc1 )
{
	ai_salazar = get_ent( "salazar_ai", "targetname", true );
	v_start = ai_salazar GetTagOrigin( "tag_flash" );
	v_end = ai_pmc1 GetTagOrigin( "tag_eye" ); 
	
	MagicBullet( ai_salazar.weapon, v_start, v_end );
	
	/#
		RecordLine( v_start, v_end, ( 1, 0, 0 ) );
	#/
}

_pmc2_shot_by_harper( ai_pmc2 )
{
	ai_harper = get_ent( "harper_ai", "targetname", true );
	v_start = ai_harper GetTagOrigin( "tag_flash" );
	v_end = ai_pmc2 GetTagOrigin( "tag_eye" ); 
	
	MagicBullet( ai_harper.weapon, v_start, v_end );
	
	/#
		RecordLine( v_start, v_end, ( 0, 0, 1 ) );
	#/	
}