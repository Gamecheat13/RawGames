//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//										
// *** FORERUNNER_SPHERE ***
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** FORERUNNER_SPHERE: DISSOLVE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_dissolve_active_limit =				25;
global short S_dissolve_active_cnt = 					0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === dissolve_piece_out::: Dissolves a piece out
script static void dissolve_piece_out( object obj_piece, sound snd_sound )
	sys_dissolve_piece_out( obj_piece, snd_sound );
end

// === dissolve_piece_in::: Dissolves a piece out
script static void dissolve_piece_in( object obj_piece, sound snd_sound )
	sys_dissolve_piece_in( obj_piece, snd_sound );
end

// === dissolve_time_out::: Gets the time for the dissolve out fx
script static real dissolve_time_out()
	0.85;
end

// === dissolve_time_out::: Gets the time for the dissolve in fx
script static real dissolve_time_in()
	0.85;
end

// === dissolve_active_limit::: Sets/Gets the active dissolve limit
script static void dissolve_active_limit( short s_limit )
	S_dissolve_active_limit = s_limit;
end
script static short dissolve_active_limit()
	S_dissolve_active_limit;
end

// === dissolve_active_cnt::: Gets the active dissolve cnt
script static short dissolve_active_cnt()
	S_dissolve_active_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_dissolve_piece_out( object obj_piece, sound snd_sound )

	if ( obj_piece != NONE ) then

		if ( S_dissolve_active_cnt >= S_dissolve_active_limit ) then
			sleep_until( S_dissolve_active_cnt < S_dissolve_active_limit, 1 );
		end
		sys_dissolve_active_inc( 1 );
		object_dissolve_from_marker( obj_piece, 'hard_kill', 'dissolve_out' );
		if ( snd_sound != NONE ) then
			sound_impulse_start( snd_sound, obj_piece, 1 );
		end
		sleep_s( dissolve_time_out() * 0.5 );
		object_set_physics( obj_piece, FALSE );
		sleep_s( dissolve_time_out() * 0.5 );
		object_set_health( obj_piece, 0.0 );
		object_hide( obj_piece, TRUE );
		sys_dissolve_active_inc( -1 );

	end

end

script static void sys_dissolve_piece_in( object obj_piece, sound snd_sound )

	if ( obj_piece != NONE ) then

		sys_dissolve_active_inc( 1 );
		object_set_health( obj_piece, 1.0 );
		object_dissolve_from_marker( obj_piece, 'resurrect', 'dissolve_in' );
		if ( snd_sound != NONE ) then
			sound_impulse_start( snd_sound, obj_piece, 1 );
		end
		sleep_s( dissolve_time_in() * 0.5 );
		object_set_physics( obj_piece, TRUE );
		sleep_s( dissolve_time_in() * 0.5 );
		object_hide( obj_piece, FALSE );
		sys_dissolve_active_inc( -1 );

	end

end

script static void sys_dissolve_active_cnt( short s_cnt )
	S_dissolve_active_cnt = s_cnt;
end
script static void sys_dissolve_active_inc( short s_inc )
	sys_dissolve_active_cnt( S_dissolve_active_cnt + s_inc );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** FORERUNNER_SPHERE: SHELLS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

script static real piece_health_destroy_calc( real r_players_1,  real r_players_2,  real r_players_3,  real r_players_4, real r_easy_mod,  real r_normal_mod,  real r_heroic_mod,  real r_legendary_mod )
local real r_health = 0.0;

	//dprint( "piece_health_destroy_calc" );

	// set initial player based value
	if ( game_coop_player_count() == 1 ) then
		r_health = r_players_1;
	end
	if ( game_coop_player_count() == 2 ) then
		r_health = r_players_2;
	end
	if ( game_coop_player_count() == 3 ) then
		r_health = r_players_3;
	end
	if ( game_coop_player_count() == 4 ) then
		r_health = r_players_4;
	end
	
	// apply difficulty mods
	if ( game_difficulty_get_real() == easy ) then 
		r_health = r_health * r_easy_mod;
	end
	if ( game_difficulty_get_real() == normal ) then 
		r_health = r_health * r_normal_mod;
	end
	if ( game_difficulty_get_real() == heroic ) then 
		r_health = r_health * r_heroic_mod;
	end
	if ( game_difficulty_get_real() == legendary ) then 
		r_health = r_health * r_legendary_mod;
	end
	
	//inspect( r_health );

	// return
	r_health;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** FORERUNNER_SPHERE: SHELL: OUTER ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_shell_outer_power_range_min = 					0.375;
static real R_shell_outer_power_range_max = 					1.00;
static real R_shell_outer_destroy_delay = 						0.125;
static real R_shell_outer_piece_destroy_health = 			0.75;

//static real R_shell_outer_pieces_health = 					0.0;
instanced real R_shell_outer_pieces_health_max = 			0.0;
instanced real R_shell_outer_pieces_health_current = 	0.0;

instanced object OBJ_shell_outer = 										object_at_marker( this, 'outer_pos' );
instanced device DM_shell_outer = 										NONE;

instanced object OBJ_shell_outer_piece_midshield_00 = NONE;
instanced object OBJ_shell_outer_piece_midshield_01 = NONE;
instanced object OBJ_shell_outer_piece_midshield_02 = NONE;
instanced object OBJ_shell_outer_piece_midshield_03 = NONE;
	
instanced object OBJ_shell_outer_piece_cover_00 = 		NONE;
instanced object OBJ_shell_outer_piece_cover_04 = 		NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === shell_outer_pieces_cnt::: Gets the count of the outer pieces
script static short shell_outer_pieces_cnt()
	6;
end

// === shell_outer_object::: Gets the outer shell object
script static instanced object shell_outer_object()
	OBJ_shell_outer;
end

// === shell_outer_piece::: Gets a piece object from the outer shell
script static instanced object shell_outer_piece( string_id sid_piece )
	object_at_marker( OBJ_shell_outer, sid_piece );
end

// === shell_outer_power::: Gets the outer shell power
script static instanced real shell_outer_power()
	R_shell_outer_power_range_min + ( shell_outer_pieces_health_ratio() * (R_shell_outer_power_range_max - R_shell_outer_power_range_min) );
end

// === shell_outer_power_range::: Sets the outer shell power range
script static void shell_outer_power_range( real r_min, real r_min )
	shell_outer_power_range_min( r_min );
	shell_outer_power_range_min( r_min );
end

// === shell_outer_power_range_min::: Sets/gets the outer shell power range min
script static void shell_outer_power_range_min( real r_val )
	R_shell_outer_power_range_min = r_val;
end
script static real shell_outer_power_range_min()
	R_shell_outer_power_range_min;
end

// === shell_outer_power_range_max::: Sets/gets the outer shell power range max
script static instanced void shell_outer_power_range_max( real r_val )
	R_shell_outer_power_range_max = r_val;
end
script static real shell_outer_power_range_max()
	R_shell_outer_power_range_max;
end

// === shell_outer_destroy_delay::: Sets/gets the outer shell delay between each piece when the core is destroyed
script static void shell_outer_destroy_delay( real r_val )
	R_shell_outer_destroy_delay = r_val;
end
script static real shell_outer_destroy_delay()
	R_shell_outer_destroy_delay;
end

// === shell_outer_piece_vitality_max::: Gets the max vitality of an outer piece
script static instanced real shell_outer_piece_vitality_max( string_id sid_piece )
	object_get_maximum_vitality( shell_outer_piece(sid_piece), TRUE );
end

// === shell_outer_pieces_health_max::: Gets the max vitality of the outer pieces
script static instanced real shell_outer_pieces_health_max()
	R_shell_outer_pieces_health_max;
end

// === shell_outer_piece_vitality_current::: Gets the current vitality of an outer piece
script static instanced real shell_outer_piece_vitality_current( string_id sid_piece )
local object obj_piece = shell_outer_piece( sid_piece );
	object_get_maximum_vitality( obj_piece, TRUE ) * object_get_health( obj_piece );
end

// === shell_outer_pieces_health_current::: Gets the current vitality of the outer pieces
script static instanced real shell_outer_pieces_health_current()
	R_shell_outer_pieces_health_current;
end

// === shell_outer_pieces_health_ratio::: Gets the vitality ratio of the outer pieces
script static instanced real shell_outer_pieces_health_ratio()
	R_shell_outer_pieces_health_current / R_shell_outer_pieces_health_max;
end

// === shell_outer_pieces_manage::: Manages the damage of the outer pieces
script static instanced void shell_outer_pieces_manage()
local boolean b_active_mid_00 = TRUE;
local boolean b_active_mid_01 = TRUE;
local boolean b_active_mid_02 = TRUE;
local boolean b_active_mid_03 = TRUE;

local boolean b_active_cover_00 = TRUE;
local boolean b_active_cover_04 = TRUE;

local short s_player_cnt = 0;

	//dprint( "shell_outer_pieces_manage: START" );
	
	repeat
	
		// update the vitality values
		repeat
			R_shell_outer_pieces_health_current = sys_shell_outer_pieces_health_current();
		until( (object_get_health(OBJ_core) <= 0.0) or (shell_outer_power() != device_get_power(DM_shell_outer)),1 );

		// update health tuning
		if ( s_player_cnt != game_coop_player_count() ) then
			s_player_cnt = game_coop_player_count();
			R_shell_outer_piece_destroy_health = piece_health_destroy_calc( 0.950, 0.925, 0.900, 0.875, 1.0, 0.975, 0.950, 0.925 );
		end
		sys_shell_outer_health_update();
		
		// notify something was damaged
		NotifyLevel( "POWER_SPHERE_OUTER_SHELL_PIECE_DAMAGED" );
	
		// wait for desired power to change
//		dprint( "shell_outer_pieces_manage: UPDATE" );
//		inspect( shell_outer_power() );
//		inspect( device_get_power(DM_shell_outer) );
//		inspect( object_get_health(OBJ_core) );
//		inspect( R_shell_outer_pieces_health_current );
		
		// manage the pieces
		begin_random
			b_active_mid_00 = sys_shell_outer_piece_update( OBJ_shell_outer_piece_midshield_00, b_active_mid_00 );
			b_active_mid_01 = sys_shell_outer_piece_update( OBJ_shell_outer_piece_midshield_01, b_active_mid_01 );
			b_active_mid_02 = sys_shell_outer_piece_update( OBJ_shell_outer_piece_midshield_02, b_active_mid_02 );
			b_active_mid_03 = sys_shell_outer_piece_update( OBJ_shell_outer_piece_midshield_03, b_active_mid_03 );
			
			b_active_cover_00 = sys_shell_outer_piece_update( OBJ_shell_outer_piece_cover_00, b_active_cover_00 );
			b_active_cover_04 = sys_shell_outer_piece_update( OBJ_shell_outer_piece_cover_04, b_active_cover_04 );
		end
			
		// set power
		device_set_power( DM_shell_outer, shell_outer_power() );
	
	until( (object_get_health(OBJ_core) <= 0.0) and (R_shell_outer_pieces_health_current <= 0.0), 1 );

	// reset the vitality values
	R_shell_outer_pieces_health_current = 0.0;

	// notify
	NotifyLevel( "POWER_SPHERE_OUTER_SHELL_DEREZ" );
	
	// disolve out the shell
	sys_dissolve_piece_out( OBJ_shell_outer, 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e8m2_powercore_derez.sound' );

	NotifyLevel( "POWER_SPHERE_OUTER_SHELL_DESTROYED" );
	
	// destroy the shell
	object_destroy( OBJ_shell_outer );

	//dprint( "shell_outer_pieces_manage: END" );

end

// STARTUP $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script startup instanced startup_shell_outer()
	//dprint( "startup_shell_outer" );
	
	DM_shell_outer = device( OBJ_shell_outer );
	
	OBJ_shell_outer_piece_midshield_00 = shell_outer_piece( 'outershell_midshield' );
	OBJ_shell_outer_piece_midshield_01 = shell_outer_piece( 'outershell_midshield_1' );
	OBJ_shell_outer_piece_midshield_02 = shell_outer_piece( 'outershell_midshield_2' );
	OBJ_shell_outer_piece_midshield_03 = shell_outer_piece( 'outershell_midshield_3' );
		
	OBJ_shell_outer_piece_cover_00 = shell_outer_piece( 'outershell_cover' );
	OBJ_shell_outer_piece_cover_04 = shell_outer_piece( 'outershell_cover_4' );
	
	// get the initial vitality values
	R_shell_outer_pieces_health_current = sys_shell_outer_pieces_health_current();
	R_shell_outer_pieces_health_max = R_shell_outer_pieces_health_current;

	// start the piece manager
	shell_outer_pieces_manage();

end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static instanced real sys_shell_outer_pieces_health_current()
	local real health = 0;
	health = health + object_get_health( OBJ_shell_outer_piece_midshield_00 ) + 
	object_get_health( OBJ_shell_outer_piece_midshield_01 ) ;
	sleep(3);
	health = health + object_get_health( OBJ_shell_outer_piece_midshield_02 ) + 
	object_get_health( OBJ_shell_outer_piece_midshield_03 ) ;
	sleep(3);
	
	health = health + object_get_health( OBJ_shell_outer_piece_cover_00 ) + 
	object_get_health( OBJ_shell_outer_piece_cover_04 );
	sleep(3);
	health;
end

script static instanced boolean sys_shell_outer_piece_update( object obj_piece, boolean b_active )
	
	if ( b_active != ((object_get_health(obj_piece) > R_shell_outer_piece_destroy_health) and (object_get_health(OBJ_core) > 0.0)) ) then
		b_active = not b_active;
		
		if ( not b_active ) then
			//dprint( "sys_shell_outer_piece_update: DISSOLVE OUT" );
			thread( sys_dissolve_piece_out(obj_piece, 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e8m2_powercore_panel_derez.sound') );
			NotifyLevel( "POWER_SPHERE_OUTER_SHELL_PIECE_DESTROYED" );
		else
			//dprint( "sys_shell_outer_piece_update: DISSOLVE IN" );
			thread( sys_dissolve_piece_in(obj_piece, NONE) );
			NotifyLevel( "POWER_SPHERE_OUTER_SHELL_PIECE_RESTORED" );
		end
		
		// this will allow other cores to dissolve, etc at the same time but if this becomes a problem this will get removed
		if ( object_get_health(OBJ_core) <= 0.0 ) then
			sleep_s( R_shell_outer_destroy_delay );
		end
		
	end
	sleep(1);
	// return
	b_active;
end

script static instanced void sys_shell_outer_health_update()
	object_set_health( OBJ_shell_outer, ((shell_outer_pieces_health_ratio() + shell_inner_pieces_health_ratio() + 1.0) * 0.333333) * object_get_health(OBJ_core) );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** FORERUNNER_SPHERE: SHELL: INNER ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_shell_inner_power_range_min = 					0.5;
static real R_shell_inner_power_range_max = 					1.00;
static real R_shell_inner_destroy_delay = 						0.125;
static real R_shell_inner_piece_destroy_health = 			0.75;

//static real R_shell_inner_pieces_health = 					0.0;
instanced real R_shell_inner_pieces_health_max = 			0.0;
instanced real R_shell_inner_pieces_health_current = 	0.0;

instanced object OBJ_shell_inner = 										object_at_marker( this, 'inner_pos' );
instanced device DM_shell_inner = 										NONE;

instanced object OBJ_shell_inner_piece_glasscap_00 = 	NONE;
instanced object OBJ_shell_inner_piece_glasscap_01 = 	NONE;
instanced object OBJ_shell_inner_piece_glasscap_02 = 	NONE;
instanced object OBJ_shell_inner_piece_glasscap_03 = 	NONE;
instanced object OBJ_shell_inner_piece_glasscap_04 = 	NONE;
instanced object OBJ_shell_inner_piece_glasscap_05 = 	NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === shell_inner_pieces_cnt::: Gets the count of the inner pieces
script static short shell_inner_pieces_cnt()
	6;
end
// === shell_inner_object::: Gets the inner shell object
script static instanced object shell_inner_object()
	OBJ_shell_inner;
end

// === shell_inner_piece::: Gets a piece object from the inner shell
script static instanced object shell_inner_piece( string_id sid_piece )
	object_at_marker( OBJ_shell_inner, sid_piece );
end

// === shell_inner_power::: Gets the inner shell power
script static instanced real shell_inner_power()
	R_shell_inner_power_range_min + ( shell_inner_pieces_health_ratio() * (R_shell_inner_power_range_max - R_shell_inner_power_range_min) );
end

// === shell_inner_power_range::: Sets the inner shell power range
script static void shell_inner_power_range( real r_min, real r_min )
	shell_inner_power_range_min( r_min );
	shell_inner_power_range_min( r_min );
end

// === shell_inner_power_range_min::: Sets/gets the inner shell power range min
script static void shell_inner_power_range_min( real r_val )
	R_shell_inner_power_range_min = r_val;
end
script static real shell_inner_power_range_min()
	R_shell_inner_power_range_min;
end

// === shell_inner_power_range_max::: Sets/gets the inner shell power range max
script static instanced void shell_inner_power_range_max( real r_val )
	R_shell_inner_power_range_max = r_val;
end
script static real shell_inner_power_range_max()
	R_shell_inner_power_range_max;
end

// === shell_inner_destroy_delay::: Sets/gets the inner shell delay between each piece when the core is destroyed
script static void shell_inner_destroy_delay( real r_val )
	R_shell_inner_destroy_delay = r_val;
end
script static real shell_inner_destroy_delay()
	R_shell_inner_destroy_delay;
end

// === shell_inner_piece_vitality_max::: Gets the max vitality of an inner piece
script static instanced real shell_inner_piece_vitality_max( string_id sid_piece )
	object_get_maximum_vitality( shell_inner_piece(sid_piece), TRUE );
end

// === shell_inner_pieces_health_max::: Gets the max vitality of the inner pieces
script static instanced real shell_inner_pieces_health_max()
	R_shell_inner_pieces_health_max;
end

// === shell_inner_piece_vitality_current::: Gets the current vitality of an inner piece
script static instanced real shell_inner_piece_vitality_current( string_id sid_piece )
local object obj_piece = shell_inner_piece( sid_piece );
	object_get_maximum_vitality( obj_piece, TRUE ) * object_get_health( obj_piece );
end

// === shell_inner_pieces_health_current::: Gets the current vitality of the inner pieces
script static instanced real shell_inner_pieces_health_current()
	R_shell_inner_pieces_health_current;
end

// === shell_inner_pieces_health_ratio::: Gets the vitality ratio of the inner pieces
script static instanced real shell_inner_pieces_health_ratio()
	R_shell_inner_pieces_health_current / R_shell_inner_pieces_health_max;
end

// === shell_inner_pieces_manage::: Manages the damage of the inner pieces
script static instanced void shell_inner_pieces_manage()

local boolean b_active_glasscap_00 = TRUE;
local boolean b_active_glasscap_01 = TRUE;
local boolean b_active_glasscap_02 = TRUE;
local boolean b_active_glasscap_03 = TRUE;
local boolean b_active_glasscap_04 = TRUE;
local boolean b_active_glasscap_05 = TRUE;

local short s_player_cnt = 0;

	// wait for outer piece to die
	sleep_until( LevelEventStatus("POWER_SPHERE_OUTER_SHELL_PIECE_DESTROYED"), 1 );

	//dprint( "shell_inner_pieces_manage: START" );
	repeat
	
		// update the vitality values
		repeat
			R_shell_inner_pieces_health_current = sys_shell_inner_pieces_health_current();
		until( (OBJ_shell_outer == NONE) or (shell_inner_power() != device_get_power(DM_shell_inner)), 1 );

		// update health tuning
		if ( s_player_cnt != game_coop_player_count() ) then
			s_player_cnt = game_coop_player_count();
			R_shell_inner_piece_destroy_health = piece_health_destroy_calc( 0.950, 0.925, 0.900, 0.875, 1.0, 0.975, 0.950, 0.925 );
		end
		sys_shell_outer_health_update();

		// notify something was damaged
		NotifyLevel( "POWER_SPHERE_INNER_SHELL_PIECE_DAMAGED" );
	
		// wait for desired power to change
		//dprint( "shell_inner_pieces_manage: UPDATE" );
		//inspect( shell_inner_power() );
		//inspect( shell_inner_pieces_health_ratio() );
		//inspect( R_shell_inner_pieces_health_current );
		//inspect( R_shell_inner_pieces_health_max );

		// manage the pieces
		begin_random
			b_active_glasscap_00 = sys_shell_inner_piece_update( OBJ_shell_inner_piece_glasscap_00, b_active_glasscap_00 );
			b_active_glasscap_01 = sys_shell_inner_piece_update( OBJ_shell_inner_piece_glasscap_01, b_active_glasscap_01 );
			b_active_glasscap_02 = sys_shell_inner_piece_update( OBJ_shell_inner_piece_glasscap_02, b_active_glasscap_02 );
			b_active_glasscap_03 = sys_shell_inner_piece_update( OBJ_shell_inner_piece_glasscap_03, b_active_glasscap_03 );
			b_active_glasscap_04 = sys_shell_inner_piece_update( OBJ_shell_inner_piece_glasscap_04, b_active_glasscap_04 );
			b_active_glasscap_05 = sys_shell_inner_piece_update( OBJ_shell_inner_piece_glasscap_05, b_active_glasscap_05 );
		end
			
		// set power
		device_set_power( DM_shell_inner, shell_inner_power() );
	
	until( (OBJ_shell_outer == NONE) and (R_shell_inner_pieces_health_current <= 0.0), 1 );
	
	// reset the vitality values
	R_shell_inner_pieces_health_current = 0.0;

	// notify
	NotifyLevel( "POWER_SPHERE_INNER_SHELL_DEREZ" );
	
	// disolve out the shell
	sys_dissolve_piece_out( OBJ_shell_inner, NONE );

	// notify
	NotifyLevel( "POWER_SPHERE_INNER_SHELL_DESTROYED" );
	
	// destroy the shell
	object_destroy( OBJ_shell_inner );

	//dprint( "shell_inner_pieces_manage: END" );

end

// STARTUP $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script startup instanced startup_shell_inner()
	//dprint( "startup_shell_inner" );
	
	// initialize object variables
	DM_shell_inner = device( OBJ_shell_inner );
	
	OBJ_shell_inner_piece_glasscap_00 = shell_inner_piece( 'innershell_glasscap' );
	OBJ_shell_inner_piece_glasscap_01 = shell_inner_piece( 'innershell_glasscap_1' );
	OBJ_shell_inner_piece_glasscap_02 = shell_inner_piece( 'innershell_glasscap_2' );
	OBJ_shell_inner_piece_glasscap_03 = shell_inner_piece( 'innershell_glasscap_3' );
	OBJ_shell_inner_piece_glasscap_04 = shell_inner_piece( 'innershell_glasscap_4' );
	OBJ_shell_inner_piece_glasscap_05 = shell_inner_piece( 'innershell_glasscap_5' );	
	
	// get the initial vitality values
	R_shell_inner_pieces_health_current = sys_shell_inner_pieces_health_current();
	R_shell_inner_pieces_health_max = R_shell_inner_pieces_health_current;
	
	// start up piece manager
	shell_inner_pieces_manage();
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static instanced real sys_shell_inner_pieces_health_current()
	local real health = 0;
	health  = health + object_get_health( OBJ_shell_inner_piece_glasscap_00 );
	sleep(1);
	health  = health +object_get_health( OBJ_shell_inner_piece_glasscap_01 );
	sleep (1);
	health = health+ object_get_health( OBJ_shell_inner_piece_glasscap_02 ) ;
	sleep(1);
	health  = health +object_get_health( OBJ_shell_inner_piece_glasscap_03 ) ;
	sleep (1);
	health = health+object_get_health( OBJ_shell_inner_piece_glasscap_04 ) ;
	sleep(1);
	health  = health + object_get_health( OBJ_shell_inner_piece_glasscap_05 );
	sleep (1);
	health;
end

script static instanced boolean sys_shell_inner_piece_update( object obj_piece, boolean b_active )
	
	if ( b_active != ((object_get_health(obj_piece) > R_shell_inner_piece_destroy_health) and (OBJ_shell_outer != NONE)) ) then
		b_active = not b_active;
		
		if ( not b_active ) then
			//dprint( "sys_shell_inner_piece_update: DISSOLVE OUT" );
			thread( sys_dissolve_piece_out(obj_piece, 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e8m2_powercore_panel_derez.sound') );
			NotifyLevel( "POWER_SPHERE_INNER_SHELL_PIECE_DESTROYED" );
		else
			//dprint( "sys_shell_inner_piece_update: DISSOLVE IN" );
			thread( sys_dissolve_piece_in(obj_piece, NONE) );
			NotifyLevel( "POWER_SPHERE_INNER_SHELL_PIECE_RESTORED" );
		end
		
		// this will allow other pieces to dissolve, etc at the same time but if this becomes a problem this will get removed
		if ( OBJ_shell_outer == NONE ) then
			sleep_s( R_shell_inner_destroy_delay );
		end
		
	end
	sleep(1);
	// return
	b_active;
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** FORERUNNER_SPHERE: CORE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
instanced object OBJ_core = object_at_marker( object_at_marker(this, 'core_pos'), 'orb_center' );

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === core_object::: Gets the core object
script static instanced object core_object()
	OBJ_core;
end

// === core_object::: Gets the core health
script static instanced real core_health()
	object_get_health( OBJ_core );
end

script static instanced void core_armor_manage()

	//dprint( "core_armor_manage: START" );

	// wait for outer piece to die
	sleep_until( LevelEventStatus("POWER_SPHERE_INNER_SHELL_PIECE_DESTROYED"), 1 );

	repeat
	
		// wait for desired power to change
		sleep_until( (OBJ_shell_inner == NONE) or (core_armor_power() != device_get_power(DM_core_armor)), 1 );
		//dprint( "core_armor_manage: UPDATE" );
		
		// update outer shell health
		sys_shell_outer_health_update();
			
		// set power
		device_set_power( DM_core_armor, core_armor_power() );

	until( OBJ_shell_inner == NONE, 1 );

	// notify
	NotifyLevel( "POWER_SPHERE_ARMOR_DEREZ" );
	
	// disolve out the shell
	sys_dissolve_piece_out( DM_core_armor, NONE );

	// notify
	NotifyLevel( "POWER_SPHERE_ARMOR_DESTROYED" );
	
	// destroy the shell
	object_destroy( DM_core_armor );

	// update outer shell health
	sys_shell_outer_health_update();

	//dprint( "core_armor_manage: END" );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** FORERUNNER_SPHERE: CORE: ARMOR ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_core_armor_power_range_min = 	0.25;
static real R_core_armor_power_range_max = 	1.00;

instanced object OBJ_core_armor = 					object_at_marker( this, 'core_pos' );
instanced device DM_core_armor = 						NONE;

static boolean B_core_armor_hidden = 				TRUE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === core_armor_object::: Gets the core armor object
script static instanced object core_armor_object()
	OBJ_core_armor;
end

// === core_armor_power::: Gets the inner shell power
script static instanced real core_armor_power()
	R_core_armor_power_range_min + ( (1.0 - object_get_health(OBJ_core)) * (R_core_armor_power_range_max - R_core_armor_power_range_min) );
end

// === core_armor_power_range::: Sets the inner shell power range
script static void core_armor_power_range( real r_min, real r_min )
	core_armor_power_range_min( r_min );
	core_armor_power_range_min( r_min );
end

// === core_armor_power_range_min::: Sets/gets the inner shell power range min
script static void core_armor_power_range_min( real r_val )
	R_core_armor_power_range_min = r_val;
end
script static real core_armor_power_range_min()
	R_core_armor_power_range_min;
end

// === core_armor_power_range_max::: Sets/gets the inner shell power range max
script static instanced void core_armor_power_range_max( real r_val )
	R_core_armor_power_range_max = r_val;
end
script static real core_armor_power_range_max()
	R_core_armor_power_range_max;
end

// STARTUP $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script startup instanced startup_core_armor()
	//dprint( "startup_core_armor" );
	
	DM_core_armor = device( OBJ_core_armor );

	sleep( 1 );
	core_armor_manage();
	
end
