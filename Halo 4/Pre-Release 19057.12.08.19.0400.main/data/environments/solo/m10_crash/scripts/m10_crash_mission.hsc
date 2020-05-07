//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash
//	Insertion Points:	start (or icr)	- Beginning
//										ila							- Lab / Armory
//										iob							- Observation Deck
//										ifl							- Flank / Prep Room
//										ibe							- Beacon
//										ibr							- Broken Floor
//										ivb							- Vehicle Bay
//										iju							- Jump Debris
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// M10 MISSION
// =================================================================================================
// =================================================================================================
// variables
global boolean b_mission_started 					= FALSE;

global boolean B_OYO 											= TRUE; 

// -------------------------------------------------------------------------------------------------
// INIT
// -------------------------------------------------------------------------------------------------
// variables

// functions
script startup m10_crash_startup()

	if ( b_game_emulate or (not editor_mode()) ) then
		fade_out( 0, 0, 0, 0 );
	
		// in editor mode make sure the players are there to start
		if ( editor_mode() ) then
			f_insertion_playerwait();
		end

		// run start function
		start();

		sleep_until( b_mission_started, 1);
		if ( game_insertion_point_get() > DEF_INSERTION_INDEX_CRYO ) then
			fade_in( 0, 0, 0, (0.50 * 30) );
		end

	end

	// wait for the game to start
	sleep_until( b_mission_started, 1);

	// display difficulty
	print_difficulty(); 

	// STARTING THE GAME
	//dprint_if( b_game_emulate, "_game_emulate" );
	//dprint_if( b_debug, "_debug" );
	//dprint_if( editor_mode(), "_editor_mode()" );
	//dprint_if( player_count() > 0, "_player_count > 0" );
	
	// hax!
	ai_lod_full_detail_actors(30);
	
	// set co-op profiles
	thread(f_loadout_set ("start"));
	
end

// -------------------------------------------------------------------------------------------------
// LIGHTING
// -------------------------------------------------------------------------------------------------
// variables

// functions
script startup m10_crash_lighting()

	// [mboulton 10/25/2011] Make sure that the observatory is set to "dark" initially
	set_lightmap_direct_scalar_bsp(6, 1.0);
	set_lightmap_indirect_scalar_bsp(6, 1.0);

end

// -------------------------------------------------------------------------------------------------
// GRAVITY
// -------------------------------------------------------------------------------------------------
// variables
global real R_gravity_default 										= 1.0;
global real R_gravity_cryo 												= 0.0;
global real R_gravity_obs 												= 0.0;
global real R_gravity_low 												= 0.4;
global real R_gravity_lower 											= 0.05;
global real R_gravity_end 												= 0.5;
global real R_gravity_vehiclebay_trans 						= 0.99;
global real R_gravity_space												= 0.0;

global long L_gravity_set_thread = 0;
global long L_gravity_jetpack_thread = 0;
global long L_gravity_audio_thread = 0;

// =================================================================================================
// Loadouts
// =================================================================================================
script static void f_loadout_set (string area)

	if area == "start" then
		player_set_profile (sp_start_mission, player0);
		player_set_profile (sp_start_mission, player1);
		player_set_profile (sp_start_mission, player2);
		player_set_profile (sp_start_mission, player3);
	elseif area == "default" or area == "NONE" then
		player_set_profile (default_respawn, player0);
		player_set_profile (default_respawn, player1);
		player_set_profile (default_respawn, player2);
		player_set_profile (default_respawn, player3);
	elseif area == "beacon" then
		player_set_profile (default_single_sniper, player0);
		player_set_profile (default_single_sniper, player1);
		player_set_profile (default_single_sniper, player2);
		player_set_profile (default_single_sniper, player3);
	end
	
end


// functions
// === f_gravity_set_time_thread::: Sets the mission gravity over time and waits for the transition to finish before returning
//	WARNING: THIS FUNCTION SHOULD NOT BE CALLED DIRECTLY
script static void f_gravity_set_time_thread( real r_gravity, real r_time )

	if ( r_gravity != physics_get_gravity() ) then
		//dprint( "::: f_gravity_set_time_thread :::" );
		inspect( r_gravity );

		// setup the watch threads
		//	jetpack watch
		if ( L_gravity_jetpack_thread != 0 ) then
			kill_thread( L_gravity_jetpack_thread );
			L_gravity_jetpack_thread = 0;
		end
		//	audio watch
		L_gravity_jetpack_thread = thread( f_gravity_jetpack_thread(r_gravity) );
		if ( L_gravity_audio_thread != 0 ) then
			kill_thread( L_gravity_audio_thread );
			L_gravity_audio_thread = 0;
		end
		L_gravity_audio_thread = thread( f_gravity_audio_thread(r_gravity) );

		if ( r_time != 0.0 ) then
			transition_gravity( DEF_GRAVITY_CURRENT, r_gravity, r_time, 10 );
		else
			physics_set_gravity( r_gravity );
		end

		// wait for gravity switch to finish
		sleep_until( physics_get_gravity() == r_gravity, 1 );
	end
	L_gravity_set_thread = 0;

end

// === f_gravity_set_time::: Sets the mission gravity over time
script static void f_gravity_set_time( real r_gravity, real r_time, boolean b_wait )

	if ( L_gravity_set_thread != 0 ) then
		kill_thread( L_gravity_set_thread );
		L_gravity_set_thread = 0;
	end
	L_gravity_set_thread = thread( f_gravity_set_time_thread(r_gravity, r_time) );
	if ( b_wait ) then
		sleep_until( L_gravity_set_thread == 0, 1 );
	end

end

// === f_gravity_set::: Sets the mission gravity; mainly for debugging purposes
script static void f_gravity_set( real r_gravity )
	f_gravity_set_time( r_gravity, 0.0, FALSE );
end

// === f_gravity_jetpack_thread::: Switches to the correct jetpack for all players
//	WARNING: THIS FUNCTION SHOULD NOT BE CALLED DIRECTLY
script static void f_gravity_jetpack_thread( real r_gravity )
static real r_last_gravity = 0;

	r_last_gravity = -666;

	repeat
	
		if ( r_last_gravity != -666 ) then
			//dprint( "::: f_gravity_jetpack_switch: WAIT :::" );
			if (r_last_gravity >= 1.0) then
				sleep_until( (physics_get_gravity() == r_gravity) or (physics_get_gravity() < 1.0), 1 );
			end
			if (r_last_gravity <= 0.0) then
				sleep_until( (physics_get_gravity() == r_gravity) or (physics_get_gravity() > 0.0), 1 );
			end
			if ((0.0 < r_last_gravity) and (r_last_gravity < 1.0)) then
				sleep_until( (physics_get_gravity() == r_gravity) or (physics_get_gravity() <= 0.0) or (physics_get_gravity() >= 1.0), 1 );
			end
		end

		//dprint( "::: f_gravity_jetpack_switch: SWITCH :::" );
		r_last_gravity = physics_get_gravity();
		f_gravity_jetpack_switch_player( 0 );
		f_gravity_jetpack_switch_player( 1 );
		f_gravity_jetpack_switch_player( 2 );
		f_gravity_jetpack_switch_player( 3 );
		
	until ( (physics_get_gravity() == r_gravity) or (L_gravity_jetpack_thread == 0), 1 );
	L_gravity_jetpack_thread = 0;
	
end

// === f_gravity_jetpack_switch::: Switches to the correct jetpack
script static void f_gravity_jetpack_switch_player( short s_index )
	//dprint( "::: f_gravity_jetpack_switch_player :::" );

	if ( s_index < player_count() ) then
		if ( unit_has_any_equipment(player_get(s_index)) ) then
			if ( physics_get_gravity() >= 1.0 ) then
				//dprint( "::: f_gravity_jetpack_switch_player-jet_pack.equipment :::" );
				player_set_equipment( player_get(s_index), 'objects\equipment\jet_pack\jet_pack.equipment', FALSE, TRUE, TRUE );
			end
			if ( physics_get_gravity() <= 0.0 ) then
				//dprint( "::: f_gravity_jetpack_switch_player-jet_pack_zero_grav.equipment :::" );
				player_set_equipment( player_get(s_index), 'objects\equipment\jet_pack\jet_pack_zero_grav.equipment', FALSE, TRUE, TRUE );
			end
			if ( (0.0 < physics_get_gravity()) and (physics_get_gravity() < 1.0) ) then
				//dprint( "::: f_gravity_jetpack_switch_player-jet_pack_low_grav.equipment :::" );
				player_set_equipment( player_get(s_index), 'objects\equipment\jet_pack\jet_pack_low_grav.equipment', FALSE, TRUE, TRUE );
			end
		end
	end

end

// === f_gravity_audio_thread::: Switches to the correct audio filter
//	WARNING: THIS FUNCTION SHOULD NOT BE CALLED DIRECTLY
script static void f_gravity_audio_thread( real r_gravity )
static real r_last_gravity = 0;

	r_last_gravity = -666;

	repeat
		//dprint( "::: f_gravity_audio_thread: WAIT :::" );

		if ( r_last_gravity != -666 ) then
			//dprint( "::: f_gravity_jetpack_switch: WAIT :::" );
			if (r_last_gravity >= 1.0) then
				sleep_until( (physics_get_gravity() == r_gravity) or (physics_get_gravity() < 1.0), 1 );
			end
			if (r_last_gravity <= 0.0) then
				sleep_until( (physics_get_gravity() == r_gravity) or (physics_get_gravity() > 0.0), 1 );
			end
			if ((0.0 < r_last_gravity) and (r_last_gravity < 1.0)) then
				sleep_until( (physics_get_gravity() == r_gravity) or (physics_get_gravity() <= 0.0) or (physics_get_gravity() >= 1.0), 1 );
			end
			inspect( physics_get_gravity() );
		end

		//dprint( "::: f_gravity_audio_thread: SWITCH :::" );
		r_last_gravity = physics_get_gravity();
		if ( physics_get_gravity() == 1.0 ) then
			sound_impulse_start( 'sound\storm\states\zero_g\set_state_high_gravity', NONE, 1 );
		elseif ( physics_get_gravity() == 0.0 ) then
			sound_impulse_start( 'sound\storm\states\zero_g\set_state_no_gravity', NONE, 1 );
		else
			sound_impulse_start( 'sound\storm\states\zero_g\set_state_low_gravity', NONE, 1 );
		end
		
	until ( (physics_get_gravity() == r_gravity) or (L_gravity_audio_thread == 0), 1 );
	L_gravity_audio_thread = 0;

end



// -------------------------------------------------------------------------------------------------
// Explosions
// -------------------------------------------------------------------------------------------------
// XXX Change FX and dmg
global effect FX_explosion_small = 		environments\solo\m10_crash\fx\explosions\explosion_brk_eal_med.effect; // XXX needed
global effect FX_explosion_medium = 	environments\solo\m10_crash\fx\explosions\explosion_brk_eal_med.effect;
global effect FX_explosion_large =  	environments\solo\m10_crash\fx\explosions\explosion_brk_eal_large.effect;
global effect FX_explosion_sparks =  	environments\solo\m10_crash\fx\explosions\explosion_36_hall.effect;

global damage DMG_explosion_small = 	objects\weapons\grenade\storm_frag_grenade\damage_effects\storm_frag_grenade_explosion.damage_effect; // XXX needed
global damage DMG_explosion_medium = 	objects\weapons\support_high\storm_rocket_launcher\projectiles\damage_effects\storm_rocket_launcher_rocket_explosion.damage_effect;
global damage DMG_explosion_large = 	objects\weapons\support_high\storm_rocket_launcher\projectiles\damage_effects\storm_rocket_launcher_rocket_explosion.damage_effect;

// === f_explosion_at::: Creates an explosiont at a location
script static void f_explosion_flag( cutscene_flag flg_loc, effect fx_tag, boolean b_fx, damage dmg_tag, boolean b_damage )

	if ( (b_damage) and (dmg_tag != NONE) ) then
		damage_new( dmg_tag, flg_loc );
	end
	if ( (b_fx) and (fx_tag != NONE) ) then
		effect_new( fx_tag, flg_loc );
	end

end

// === f_explosion_flag_large::: Creates an explosiont at a location for this size
script static void f_explosion_flag_large( cutscene_flag flg_loc, boolean b_fx, boolean b_damage )
	f_explosion_flag( flg_loc, FX_explosion_large, b_fx, DMG_explosion_large, b_damage );
end

// === f_explosion_flag_medium::: Creates an explosiont at a location for this size
script static void f_explosion_flag_medium( cutscene_flag flg_loc, boolean b_fx, boolean b_damage )
	f_explosion_flag( flg_loc, FX_explosion_medium, b_fx, DMG_explosion_medium, b_damage );
end

// === f_explosion_flag_small::: Creates an explosiont at a location for this size
script static void f_explosion_flag_small( cutscene_flag flg_loc, boolean b_fx, boolean b_damage )
	f_explosion_flag( flg_loc, FX_explosion_small, b_fx, DMG_explosion_small, b_damage );
end






// -------------------------------------------------------------------------------------------------
// FX: AIRLOCKS
// -------------------------------------------------------------------------------------------------
// variables
global real  R_airlock_fx_pos						= 0.0;

// functions
// === fx_airlock_play_loc: plays fx for an airlock location
script static void fx_airlock_play_loc( effect fx_tag, real r_delay, cutscene_flag CF_flag, real i_index, real i_max )
	//dprint( "::: fx_airlock_play_loc :::" );

	effect_new( fx_tag, CF_flag );
	sleep_s( r_delay );
	R_airlock_FX_pos = i_index/i_max;

end

// === fx_airlock_pos_reset: resets the position counter
script static void fx_airlock_pos_reset()
	R_airlock_FX_pos = 0.0;
end



// -------------------------------------------------------------------------------------------------
// SCREENSHAKES
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// SCREENSHAKES: RUMBLE
// -------------------------------------------------------------------------------------------------
script static long f_mission_screenshakes_rumble_low( real r_attack )
	if ( r_attack < 0.0 ) then
		 r_attack = 0.5;
	end
	f_screenshake_rumble_global_add( DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_LOW(), r_attack, sfx_rumble_low() );
end

script static long f_mission_screenshakes_rumble_med( real r_attack )
	if ( r_attack < 0.0 ) then
		 r_attack = 0.5;
	end
	f_screenshake_rumble_global_add( DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_MED(), r_attack, sfx_rumble_med() );
end

script static long f_mission_screenshakes_rumble_high( real r_attack )
	if ( r_attack < 0.0 ) then
		 r_attack = 0.5;
	end
	f_screenshake_rumble_global_add( DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_HIGH(), r_attack, sfx_rumble_high() );
end

// -------------------------------------------------------------------------------------------------
// SCREENSHAKES: AMBIENT
// -------------------------------------------------------------------------------------------------
global short DEF_S_AMBIENTSHAKE_STATE_NONE 						= 0;
global short DEF_S_AMBIENTSHAKE_STATE_LAB 						= 1;	// !!!
global short DEF_S_AMBIENTSHAKE_STATE_OBSERVATORY			= 2;	// !!!
global short DEF_S_AMBIENTSHAKE_STATE_BEACON_START		= 3;	// !!!
global short DEF_S_AMBIENTSHAKE_STATE_BEACON_END			= 4;	// !!!
global short DEF_S_AMBIENTSHAKE_STATE_END_AIRLOCK 		= 5;	// !!!
global short DEF_S_AMBIENTSHAKE_STATE_END 						= 6;	// !!!
global short DEF_S_AMBIENTSHAKE_STATE_BROKEN 					= 7;	// !!!
global short DEF_S_AMBIENTSHAKE_STATE_MAINTENANCE 		= 8;	// !!!
global short DEF_S_AMBIENTSHAKE_STATE_EXPLOSIONALLEY 	= 9;	// !!!
global short DEF_S_AMBIENTSHAKE_STATE_BLACKOUT 				= 10;	// !!!
global short DEF_S_AMBIENTSHAKE_STATE_VEHICLEBAY 			= 11;	// !!!
global short DEF_S_AMBIENTSHAKE_STATE_SPACE			 			= 12;	// !!!

script static void f_mission_screenshakes_ambient_layer_set_inc( short s_layer )
static short s_layer_saved = DEF_S_AMBIENTSHAKE_STATE_NONE;
static long l_thread = 0;

	if ( s_layer > s_layer_saved) then
		s_layer_saved = s_layer;
		
		if ( l_thread != 0 ) then
			kill_thread( l_thread );
		end
		
		l_thread = thread( f_mission_screenshakes_ambient_layer_set(s_layer) );
	end
	
end

script static void f_mission_screenshakes_ambient_layer_set( short s_layer )
static long l_distant_01 = 0;
static long l_distant_02 = 0;
static long l_distant_03 = 0;
static long l_distant_04 = 0;
static long l_large_01 = 0;
static long l_large_02 = 0;
static long l_large_03 = 0;
static long l_large_04 = 0;
static long l_large_05 = 0;
static long l_medium_01 = 0;
static long l_medium_02 = 0;
static long l_medium_03 = 0;

	// pause while shifting sets

	if ( s_layer == DEF_S_AMBIENTSHAKE_STATE_NONE ) then
		f_screenshake_ambient_pause( TRUE, FALSE, 0.0 );
	end
	if ( s_layer == DEF_S_AMBIENTSHAKE_STATE_LAB ) then
		f_screenshake_ambient_delay_set( 10.0, 15.0 );
		f_screenshake_ambient_pause( FALSE, FALSE, 0.0 );
	end
	if ( s_layer == DEF_S_AMBIENTSHAKE_STATE_OBSERVATORY ) then
		f_screenshake_ambient_delay_set( 10.0, 12.5 );
		f_screenshake_ambient_pause( FALSE, FALSE, -1 );
	end
	if ( s_layer == DEF_S_AMBIENTSHAKE_STATE_BEACON_START ) then
		f_screenshake_ambient_pause( TRUE, FALSE, 0.0 );
	end
	if ( s_layer == DEF_S_AMBIENTSHAKE_STATE_BEACON_END ) then
		f_screenshake_ambient_delay_set( 0.25, 0.5 );
		f_screenshake_ambient_pause( FALSE, FALSE, -1 );
	end
	if ( s_layer == DEF_S_AMBIENTSHAKE_STATE_END_AIRLOCK ) then
		f_screenshake_ambient_delay_set( 3.0, 7.0 );
		f_screenshake_ambient_pause( FALSE, FALSE, -1 );
	end
	if ( s_layer == DEF_S_AMBIENTSHAKE_STATE_BROKEN ) then
		f_screenshake_ambient_delay_set( 3.0, 6.0 );
		f_screenshake_ambient_pause( FALSE, FALSE, -1 );
	end
	if ( s_layer == DEF_S_AMBIENTSHAKE_STATE_MAINTENANCE ) then
		f_screenshake_ambient_delay_set( 3.0, 5.0 );
		f_screenshake_ambient_pause( FALSE, FALSE, -1 );
	end
	if ( s_layer == DEF_S_AMBIENTSHAKE_STATE_EXPLOSIONALLEY ) then
		f_screenshake_ambient_delay_set( 1.5, 2.5 );
		f_screenshake_ambient_pause( FALSE, FALSE, -1 );
	end
	if ( s_layer == DEF_S_AMBIENTSHAKE_STATE_BLACKOUT ) then
		f_screenshake_ambient_delay_set( 0.5, 1.25 );
		f_screenshake_ambient_pause( FALSE, FALSE, 0.0 );
	end
	if ( s_layer == DEF_S_AMBIENTSHAKE_STATE_VEHICLEBAY ) then
		f_screenshake_ambient_delay_set( 2.0, 3.0 );
		f_screenshake_ambient_pause( TRUE, FALSE, 0.0 );
	end
	if ( s_layer == DEF_S_AMBIENTSHAKE_STATE_SPACE ) then
		f_screenshake_ambient_pause( TRUE, FALSE, 0.0 );
	end
	
	// large
	if ( (s_layer >= DEF_S_AMBIENTSHAKE_STATE_BROKEN) and (s_layer <= DEF_S_AMBIENTSHAKE_STATE_VEHICLEBAY) ) then
		if ( l_large_01 == 0 ) then
			l_large_01 = f_screenshake_ambient_add( 0.25, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH(), -0.5, -1, -3.0, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_large_01', 0.0, 3, "amb_m10_explosions_large_01" );
		end
		if ( l_large_02 == 0 ) then
			l_large_02 = f_screenshake_ambient_add( 0.25, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH(), -0.5, -1, -3.5, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_large_02', 0.0, 3, "amb_m10_explosions_large_02" );
		end
		if ( l_large_03 == 0 ) then
			l_large_03 = f_screenshake_ambient_add( 0.25, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH(), -0.75, -1, -4.0, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_large_03', 0.0, 3, "amb_m10_explosions_large_03" );
		end
		if ( l_large_04 == 0 ) then
			l_large_04 = f_screenshake_ambient_add( 0.25, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH(), -0675, -1, -4.0, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_large_04', 0.0, 3, "amb_m10_explosions_large_04" );
		end
		if ( l_large_05 == 0 ) then
			l_large_05 = f_screenshake_ambient_add( 0.25, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH(), -1.0, -1, -2.75, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_large_05', 0.0, 3, "amb_m10_explosions_large_05" );
		end
	else
		l_large_01 = f_screenshake_ambient_remove( l_large_01 );
		l_large_02 = f_screenshake_ambient_remove( l_large_02 );
		l_large_03 = f_screenshake_ambient_remove( l_large_03 );
		l_large_04 = f_screenshake_ambient_remove( l_large_04 );
		l_large_05 = f_screenshake_ambient_remove( l_large_05 );
	end

	// medium
	if ( (s_layer >= DEF_S_AMBIENTSHAKE_STATE_BEACON_END) and (s_layer <= DEF_S_AMBIENTSHAKE_STATE_MAINTENANCE) ) then
		if ( l_medium_01 == 0 ) then
			l_medium_01 = f_screenshake_ambient_add( 0.20, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED(), -0.475, -1, -4.0, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_medium_01', 0.0, 1, "amb_m10_explosions_medium_01" );
		end
		if ( l_medium_02 == 0 ) then
			l_medium_02 = f_screenshake_ambient_add( 0.20, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED(), 0.0, -1, -3.5, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_medium_02', 0.0, 1, "amb_m10_explosions_medium_02" );
		end
		if ( l_medium_03 == 0 ) then
			l_medium_03 = f_screenshake_ambient_add( 0.20, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED(), 0.0, -1, -2.25, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_medium_03', 0.0, 1, "amb_m10_explosions_medium_03" );
		end
	else
		l_medium_01 = f_screenshake_ambient_remove( l_medium_01 );
		l_medium_02 = f_screenshake_ambient_remove( l_medium_02 );
		l_medium_03 = f_screenshake_ambient_remove( l_medium_03 );
	end
		
	// distant
	if ( (s_layer >= DEF_S_AMBIENTSHAKE_STATE_LAB) and (s_layer <= DEF_S_AMBIENTSHAKE_STATE_BEACON_END) ) then
		if ( l_distant_01 == 0 ) then
			l_distant_01 = f_screenshake_ambient_add( 0.15, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), -0.25, -1, -3.0, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_distant_01', 0.0, 2, "amb_m10_explosions_distant_01" );
		end
		if ( l_distant_02 == 0 ) then
			l_distant_02 = f_screenshake_ambient_add( 0.15, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), -0.25, -1, -4.0, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_distant_02', 0.0, 2, "amb_m10_explosions_distant_02" );
		end
		if ( l_distant_03 == 0 ) then
			l_distant_03 = f_screenshake_ambient_add( 0.15, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), -0.0, -1, -0.0, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_distant_03', 0.0, 2, "amb_m10_explosions_distant_03" );
		end
		if ( l_distant_04 == 0 ) then
			l_distant_04 = f_screenshake_ambient_add( 0.15, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), -1.5, -1, -4.0, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_distant_04', 0.0, 2, "amb_m10_explosions_distant_04" );
		end
	else
		l_distant_01 = f_screenshake_ambient_remove( l_distant_01 );
		l_distant_02 = f_screenshake_ambient_remove( l_distant_02 );
		l_distant_03 = f_screenshake_ambient_remove( l_distant_03 );
		l_distant_04 = f_screenshake_ambient_remove( l_distant_04 );
	end
	
end

// XXX keep these until supported
// === cam_shake_player: plays a screenshake
script static void cam_shake_player( player actor, real intensity, real attack, real duration, real decay )
static boolean b_vibrate_controller = TRUE;

	// make sure the player is valid
	if ( object_get_health(actor) > 0 ) then
		//dprint(  "::: cam_shake_player :::" );
	
		// sets the maximum rotations in each direction the shake can impact
		player_effect_set_max_rotation_for_player( actor, (intensity*3), (intensity*3), (intensity*2) );	//XXX tune ranges

		// trigger the effect to start
		player_effect_start_for_player( actor, intensity, attack );

		// start controller rumble
		if ( b_vibrate_controller ) then
			player_effect_set_max_rumble_for_player( actor, intensity, intensity );
		end
		
		if ( duration >= 0 ) then
	
			sleep_s( duration );
	
		end
	
		// stop screenshake if decay is set to 0 or greater.  this allows users to set it to -1 to keep the shake going until they decide to stop it
		if ( decay >= 0 ) then
	
			// stop screen shake
			player_effect_stop_for_player( actor, decay );
			
			// end controller rumble
			if ( b_vibrate_controller ) then
				player_effect_set_max_rumble_for_player( actor, 0, 0 );
			end
			
		end
	
	end
	
end

// === cam_shake_players: plays a screenshake for all the players
script static void cam_shake_players( real intensity, real attack, real duration, real decay )
	//dprint(  "::: cam_shake_players :::" );

	thread( cam_shake_player(player_get(0), intensity, attack, duration, decay) );
	thread( cam_shake_player(player_get(1), intensity, attack, duration, decay) );
	thread( cam_shake_player(player_get(2), intensity, attack, duration, decay) );
	thread( cam_shake_player(player_get(3), intensity, attack, duration, decay) );

end

// === cam_shake_player_volume: plays different intensity camera shakes if the player is or isn't in the volume
script static void cam_shake_player_volume( player actor, trigger_volume tv_shake, real intensity_on, real intensity_off, real attack, real duration, real decay )

	// make sure the player is valid
	if ( object_get_health(actor) > 0 ) then
		//dprint(  "::: cam_shake_player_volume :::" );

		// XXX Add fall off based on distance
		if ( volume_test_object(tv_shake, actor) ) then
	
			cam_shake_player( actor, intensity_on, attack, duration, decay );
	
		else
	
			cam_shake_player( actor, intensity_off, attack, duration, decay );
	
		end

	end

end

// === cam_shake_players_volume: for all players, plays different intensity camera shakes if the player is or isn't in the volume
script static void cam_shake_players_volume( trigger_volume tv_shake, real intensity_on, real intensity_off, real attack, real duration, real decay )
	//dprint(  "::: cam_shake_players_volume :::" );

	thread( cam_shake_player_volume(player_get(0), tv_shake, intensity_on, intensity_off, attack, duration, decay) );
	thread( cam_shake_player_volume(player_get(1), tv_shake, intensity_on, intensity_off, attack, duration, decay) );
	thread( cam_shake_player_volume(player_get(2), tv_shake, intensity_on, intensity_off, attack, duration, decay) );
	thread( cam_shake_player_volume(player_get(3), tv_shake, intensity_on, intensity_off, attack, duration, decay) );

end

// === cam_shake_player_in_volume: When the player enters the volume it will shake while the player remains in it or they die
script static void cam_shake_player_in_volume( player actor, trigger_volume tv_shake, real intensity, real attack, real decay, short s_use_cnt )

	if ( object_get_health(actor) > 0 ) then

		repeat
			sleep_until( volume_test_object(tv_shake, actor), 1 );
			cam_shake_player( actor, intensity, attack, -1, -1 );
			
			sleep_until( (not volume_test_object(tv_shake, actor)) or (object_get_health(actor) <= 0), 1 );
			cam_shake_player( actor, intensity, 0.0, 0.0, decay );
			
			s_use_cnt = s_use_cnt - 1;
		until( s_use_cnt == 0, 1 );

	end

end



// -------------------------------------------------------------------------------------------------
// ZONE SET: SETUP
// -------------------------------------------------------------------------------------------------
// VARIABLES

// FUNCTIONS
script startup f_zoneset_init()
	thread( f_zoneset_setup() );
end

// === fx_zoneset_setup::: Switches areas fx
script static void f_zoneset_setup()
static short s_zoneset_setup_index = -1;
	
	// call pre-mission started zoneset_setup functions
	f_zoneset_cin_opening( S_zoneset_cin_opening, current_zone_set_fully_active(), s_zoneset_setup_index );

	// wait for the game to start
	sleep_until( b_mission_started, 1);
	
	// call general zoneset_setup functions
	f_zoneset_00_cryo_02_hallway_04_armory( S_zoneset_00_cryo_02_hallway_04_armory, current_zone_set_fully_active(), s_zoneset_setup_index );
	f_zoneset_06_hallway_08_elevator_10_elevator_12_observatory( S_zoneset_06_hallway_08_elevator_10_elevator_12_observatory, current_zone_set_fully_active(), s_zoneset_setup_index );
	f_zoneset_08_elevator_14_elevator_16_lookout( S_zoneset_08_elevator_14_elevator_16_lookout, current_zone_set_fully_active(), s_zoneset_setup_index );
	f_zoneset_16_lookout_18_elevator_20_cafe( S_zoneset_16_lookout_18_elevator_20_cafe, current_zone_set_fully_active(), s_zoneset_setup_index );
	f_zoneset_24_corner_26_box_28_airlock( S_zoneset_24_corner_26_box_28_airlock, current_zone_set_fully_active(), s_zoneset_setup_index );
	f_zoneset_28_airlock_30_beacons( S_zoneset_28_airlock_30_beacons, current_zone_set_fully_active(), s_zoneset_setup_index );
	f_zoneset_32_broken_34_maintenance( S_zoneset_32_broken_34_maintenance, current_zone_set_fully_active(), s_zoneset_setup_index );
	f_zoneset_36_hallway_38_vehicle_40_debris( S_zoneset_36_hallway_38_vehicle_40_debris, current_zone_set_fully_active(), s_zoneset_setup_index );
	f_zoneset_40_debris_42_skybox( S_zoneset_40_debris_42_skybox, current_zone_set_fully_active(), s_zoneset_setup_index );
	
	// get the current zone set
	s_zoneset_setup_index = current_zone_set_fully_active();

	// wait for the zone set to switch	
	sleep_until( current_zone_set_fully_active() != s_zoneset_setup_index, 1 );
	
	// resetup the function again for the new area
	thread( f_zoneset_setup() );

end


// === fx_zoneset_00_cryo_02_hallway_04_armory::: Startup general zone set setup functions
script static void f_zoneset_00_cryo_02_hallway_04_armory( short s_zoneset_check, short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( (s_zoneset_check == s_zoneset_loading_index) or (s_zoneset_check == s_zoneset_unloading_index) ) then
		thread( fx_zoneset_00_cryo_02_hallway_04_armory(s_zoneset_loading_index, s_zoneset_unloading_index) );
	end
end
// === fx_zoneset_06_hallway_08_elevator_10_elevator_12_observatory::: Startup general zone set setup functions
script static void f_zoneset_06_hallway_08_elevator_10_elevator_12_observatory( short s_zoneset_check, short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( (s_zoneset_check == s_zoneset_loading_index) or (s_zoneset_check == s_zoneset_unloading_index) ) then
		thread( fx_zoneset_06_hallway_08_elevator_10_elevator_12_observatory(s_zoneset_loading_index, s_zoneset_unloading_index) );
	end
end

// === fx_zoneset_08_elevator_14_elevator_16_lookout::: Startup general zone set setup functions
script static void f_zoneset_08_elevator_14_elevator_16_lookout( short s_zoneset_check, short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( (s_zoneset_check == s_zoneset_loading_index) or (s_zoneset_check == s_zoneset_unloading_index) ) then
		thread( fx_zoneset_08_elevator_14_elevator_16_lookout(s_zoneset_loading_index, s_zoneset_unloading_index) );
	end
end

// === fx_zoneset_16_lookout_18_elevator_20_cafe::: Startup general zone set setup functions
script static void f_zoneset_16_lookout_18_elevator_20_cafe( short s_zoneset_check, short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( (s_zoneset_check == s_zoneset_loading_index) or (s_zoneset_check == s_zoneset_unloading_index) ) then
		thread( fx_zoneset_16_lookout_18_elevator_20_cafe(s_zoneset_loading_index, s_zoneset_unloading_index) );
	end
end
// === fx_zoneset_24_corner_26_box_28_airlock::: Startup general zone set setup functions
script static void f_zoneset_24_corner_26_box_28_airlock( short s_zoneset_check, short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( (s_zoneset_check == s_zoneset_loading_index) or (s_zoneset_check == s_zoneset_unloading_index) ) then
		thread( fx_zoneset_24_corner_26_box_28_airlock(s_zoneset_loading_index, s_zoneset_unloading_index) );
	end
end
// === fx_zoneset_28_airlock_30_beacons::: Startup general zone set setup functions
script static void f_zoneset_28_airlock_30_beacons( short s_zoneset_check, short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( (s_zoneset_check == s_zoneset_loading_index) or (s_zoneset_check == s_zoneset_unloading_index) ) then
		thread( fx_zoneset_28_airlock_30_beacons(s_zoneset_loading_index, s_zoneset_unloading_index) );
	end
end

// === fx_zoneset_32_broken_34_maintenance::: Startup general zone set setup functions
script static void f_zoneset_32_broken_34_maintenance( short s_zoneset_check, short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( (s_zoneset_check == s_zoneset_loading_index) or (s_zoneset_check == s_zoneset_unloading_index) ) then
		thread( fx_zoneset_32_broken_34_maintenance(s_zoneset_loading_index, s_zoneset_unloading_index) );
	end
end
// === fx_zoneset_36_hallway_38_vehicle_40_debris::: Startup general zone set setup functions
script static void f_zoneset_36_hallway_38_vehicle_40_debris( short s_zoneset_check, short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( (s_zoneset_check == s_zoneset_loading_index) or (s_zoneset_check == s_zoneset_unloading_index) ) then
		thread( fx_zoneset_36_hallway_38_vehicle_40_debris(s_zoneset_loading_index, s_zoneset_unloading_index) );
	end
end
// === fx_zoneset_40_debris_42_skybox::: Startup general zone set setup functions
script static void f_zoneset_40_debris_42_skybox( short s_zoneset_check, short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( (s_zoneset_check == s_zoneset_loading_index) or (s_zoneset_check == s_zoneset_unloading_index) ) then
		thread( fx_zoneset_40_debris_42_skybox(s_zoneset_loading_index, s_zoneset_unloading_index) );
	end
end
// === fx_zoneset_cin_opening::: Startup general zone set setup functions
script static void f_zoneset_cin_opening( short s_zoneset_check, short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( (s_zoneset_check == s_zoneset_loading_index) or (s_zoneset_check == s_zoneset_unloading_index) ) then
		thread( fx_zoneset_cin_opening(s_zoneset_loading_index, s_zoneset_unloading_index) );
	end
end
