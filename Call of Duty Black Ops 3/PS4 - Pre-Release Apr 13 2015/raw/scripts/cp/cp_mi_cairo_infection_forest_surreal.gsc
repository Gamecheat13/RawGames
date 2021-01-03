
#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                           
                                               	                                                          	              	                                                                                           

#using scripts\cp\_dialog;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_objectives;

#using scripts\cp\gametypes\_spawnlogic;

#using scripts\cp\cp_mi_cairo_infection_murders;
#using scripts\cp\cp_mi_cairo_infection_util;

#namespace forest_surreal;
















	// 1
	// 1
	// 1

	// 40
	// 0.25
	// 1.0
	// 0.75
	// 1.0
	// 5.5

	// 42*30

	// 400
	// 1000

	// 250
	// 600


//*****************************************************************************
//*****************************************************************************

function cleanup( str_objective, b_starting, b_direct, player )
{

}


//*****************************************************************************
//*****************************************************************************
// WFA: SkipTo
//*****************************************************************************
//*****************************************************************************

function main( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread infection_util::sarah_objective_move( "t_sarah_bastogne_objective_", 8, &sarah_waits_at_ravine );
		
		level flag::wait_till( "all_players_spawned" );

		infection_util::turn_on_snow_fx_for_all_players();  // used for skipto; these should already be playing during normal progression
	}

	setup_spawners();
	//setup_scenes();
	setup_world_falls_away();
	setup_player_falling_deaths();

	// AI behaviours
	level thread intro_guys();
	level thread ai_middle_path_spawners();
	level thread runners_before_pit();
	
	// AI cleanup during the level progression
	level thread forest_surreal_cleanup_thread();

	// Guys hanging on ledges after pieces fall away
	level thread hanging_on_ledge_dudes();

	// Audio and rumble
	level thread transition_to_night();

	level thread turn_off_snow();

	level thread fancy_falling_pieces_at_start();

	if( 0 == 0 )
	{
		level thread wfa_falling_platform_guys();
	}

	if( 0 == 1 )
	{
		e_player = getplayers()[0];
		e_player.ignoreme = true;
	}
			
	// Wait until we reach the wolves section
	e_trigger = GetEnt( "forest_surreal_skipto_complete", "targetname" );
	e_trigger waittill( "trigger" );

	level notify( "forest_surreal_complete" );

	level thread skipto::objective_completed( str_objective );
}


//*****************************************************************************
//*****************************************************************************

function turn_off_snow()
{
	wait( 0.2 );
	infection_util::turn_off_snow_fx_for_all_players();
}


//*****************************************************************************
//*****************************************************************************

function delete_not_seen( dist )
{
	self endon( "death" );
	
	while( self infection_util::player_can_see_me( dist ) )
	{
		wait 0.1;
	}
	
	if(isdefined(self))
	{			
		self delete();
	}	
}	

function dev_black_station_intro( str_objective, b_starting )
{
	wait_for_player_to_enter_black_station();
	
	level thread blackstation_murders::murders_main( "black_station", false );  // run manually since this is a dev-only skipto
}


//*****************************************************************************
//*****************************************************************************

function dev_black_station_cleanup( str_objective, b_starting, b_direct, player )
{
	
}


//*****************************************************************************
//*****************************************************************************
// Forest Wolves: SkipTo
//*****************************************************************************
//*****************************************************************************

function forest_wolves( str_objective, b_starting )
{
	setup_scenes();

	level thread forest_wolves_cleanup_thread();

	// Allow the cleanup to take place
	wait( 0.1 );

	if( 0 == 1 )
	{
		e_player = getplayers()[0];
		e_player.ignoreme = true;
	}
	
	// set lighting state immediately to night
	level util::set_lighting_state( 1 );

	if( !IsDefined(level.world_falls_away_setup) )
	{
		level thread setup_world_falls_away();
	}

	if( b_starting )
	{
		level thread infection_util::sarah_objective_move( "t_sarah_bastogne_objective_", 13, &sarah_waits_at_ravine );
		setup_spawners();
		setup_player_falling_deaths();			
	}

	if( 0 == 0 )
	{
		level thread infection_util::setup_reverse_time_arrivals( "world_falls_away_wolf_reverse_anim" );
	}

	wolves_attack();

	// Sarah opens the chasm
	chasm_opens();
	wait_for_player_to_enter_black_station();

	level notify( "forest_wolves_complete" );

	level thread skipto::objective_completed( str_objective );
}


//*****************************************************************************
//*****************************************************************************

function forest_wolves_cleanup( str_objective, b_starting, b_direct, player )
{
	
}


//*****************************************************************************
// Lighting State Change for transition to Night
//*****************************************************************************

function transition_to_night()
{
	level thread vo_transition_night();	

	level util::set_lighting_state( 1 );
	
	s_sound_origin = struct::get( "world_falls_away_start_struct", "targetname" );
	PlaySoundAtPosition( "evt_night_transition", s_sound_origin.origin );

	s_struct = struct::get( "s_night_transition", "targetname" );
	count = 0;
	while( count < 20 )
	{
		PlayRumbleOnPosition( "cp_infection_world_falls_break", s_struct.origin );
		util::wait_network_frame();
		count++;
	}
}


//*****************************************************************************
//*****************************************************************************

function setup_scenes()
{
	// Sarah at the end of WFA
	scene::add_scene_func("cin_inf_07_03_worldfallsaway_vign_pain", &vo_worldfallsaway_vign, "play" );
	scene::add_scene_func( "cin_inf_07_02_worldfallsaway_vign_knelt", &infection_util::callback_scene_objective_light_enable, "play" );
	scene::add_scene_func( "cin_inf_07_02_worldfallsaway_vign_knelt", &infection_util::callback_scene_objective_light_disable_no_delete, "stop" );
}


//*****************************************************************************
//*****************************************************************************

function setup_spawners()
{
	infection_util::enable_exploding_deaths( true );
	
	spawner::add_spawn_function_group( "sm_bastogne_hill_guys_1", "targetname", &world_falls_away_ai_spawn_fn );
	spawner::add_spawn_function_group( "world_falls_away_intro_guys", "targetname", &world_falls_away_ai_spawn_fn );
	
	spawner::add_spawn_function_group( "wolf", "script_noteworthy", &spawn_func_wolf );

	if( 0 == 0 )
	{
		infection_util::setup_reverse_time_arrivals( "world_falls_away_reverse_anim" );
	}
}


//*****************************************************************************
// FALLING DEATH
//*****************************************************************************
// this is a temporary setup until the Unrecoverable Falling Death global system is ready. -TJanssen 10/24/2014
// TODO: replace with global system
function setup_player_falling_deaths()
{
	a_triggers = GetEntArray( "falling_death", "targetname" );
	
	foreach ( trigger in a_triggers )
	{
		trigger thread falling_death_think();
	}
}

//*****************************************************************************
//*****************************************************************************

// self = trigger
function falling_death_think()
{
	while ( true )
	{
		self waittill( "trigger", who );
		
		if( IsPlayer( who ) && !( isdefined( who.is_falling_to_death ) && who.is_falling_to_death ) )
		{	
			who thread player_falls_to_death();
		}
		util::wait_network_frame();
	}
}

// self = player
function player_falls_to_death()
{
	self.is_falling_to_death = true;

	const START_WAIT = 0;
	const OPAQUE_TIME = 2;
	const FADE_IN_TIME = 0.5;
	const FADE_OUT_TIME = 1;
	str_shader = "black";
	
	self EnableInvulnerability();
		
	self thread hud::fade_to_black_for_x_sec( START_WAIT, OPAQUE_TIME, FADE_IN_TIME, FADE_OUT_TIME, str_shader );
		
	wait START_WAIT + OPAQUE_TIME;
	self thread move_player_to_respawn_point();
	wait FADE_IN_TIME;
		
	self.is_falling_to_death = false;
	self DisableInvulnerability();
	
	//if game protocal asks to take a life would add that here. currently not doing so.
	self dodamage( self.health/10, self.origin );	
	if( self.health < 1 )
	{
		self.health = 1;
	}
}

// self = player
function move_player_to_respawn_point()
{
	// pick a respawn point
	str_skipto = level.skipto_point;
	
	a_respawn_points = spawnlogic::get_spawnpoint_array( "cp_coop_respawn" );
	a_respawn_points_filtered = skipto::filter_player_spawnpoints( self, a_respawn_points, str_skipto );
	
	Assert( a_respawn_points_filtered.size, "move_player_to_respawn_point found no respawn points!" );
	
	s_warp = array::random( a_respawn_points_filtered );

	// move the player there
	self SetOrigin( s_warp.origin );
	self SetPlayerAngles( s_warp.angles );

/*
	//hack fix when player are teleported
	self infection_util::snow_fx_stop();
	util::wait_network_frame();
	self infection_util::snow_fx_play();	
*/
}


//*****************************************************************************
//*****************************************************************************

function setup_world_falls_away()
{
	level.world_falls_away_setup = 1;

	// note: each piece has the same targetname as the prefab that contains it. 
	// Example: fallaway_01 is in _prefabs/cp/cp_mi_cairo_infection/geo/bastogne/fallaway_01.map	
	// all pieces should have script_noteworthy = bastogne_world_falls_away
	a_pieces = GetEntArray( "bastogne_world_falls_away", "script_noteworthy" );
	level thread array::thread_all( a_pieces, &fall_away_piece_think );
}


//*****************************************************************************
// Controls when the piece falls
// - links/unclinks paths, plays sound, exploders etc....
//
// All have model numbering convention......
//
//
// Pieces that fall (script_entities)
//  - script_noteworthy = "bastogne_world_falls_away"
//  - script_string = If set to "moving platform", then guys are spawned on top that will fal to the ground
//  - target = The script struct that triggers the falling event
//  - targetname = If set used by the AI spawned on top to id this piece
//
//*****************************************************************************

// self = falling piece (script mover)
function fall_away_piece_think()
{
	// Since pieces can either be script models or script brushmodels, use different info for each one; models have origins out in the middle of nowhere
	if ( self.classname == "script_model" )
	{
		str_debug = self.model;
	}
	else 
	{
		str_debug = self.origin;
	}

	// Only fallaway if pointing at a struct
	if( !IsDefined(self.target) )
	{
		return;
	}

	s_struct = struct::get( self.target, "targetname" );
	if( !IsDefined(s_struct) )
	{
		return;
	}

	s_struct.moving_platform = self;


	// BLOCKING - Use a notify on the struct to trigger the event
	// IMPORTANT: Multiple chunks could use the same struct
	// So other chunks using this struct could trigger this chunk to fall, nice!

	v_pos = s_struct.origin;
	radius = 42*30;		// 25 meters
	if( IsDefined(s_struct.radius) )
	{
		radius = s_struct.radius;
	}
	
	// Wait until the piece is triggered
	level thread fall_away_piece_trigger( s_struct, radius );
	level waittill( s_struct.script_string );


	//*********************************************************************************************
	// Is this piece a moving platform with a guy ontop?
	// - If it is we need a consistend move time, so its in sync with the AI wobble, fall animation
	//*********************************************************************************************
	
	if( IsDefined(self.script_string) && (self.script_string == "moving_platform") )
	{
		self.moving_platform_piece = 1;
		self SetMovingPlatformEnabled( true );  
	}
	else
	{
		self.moving_platform_piece = 0;
	}
		
	// Save the trigger origin. We will need to use this later since it will get delete a few lines below.
	v_rumble_origin = s_struct.origin;
	

	//******************************
	// Call effects etc... (steam..)
	//******************************

	self piece_rising_effects( v_rumble_origin );


	//******************************************************
	// Random wait so things don't all fall at the same time
	//******************************************************

	time = randomFloatRange( 0.5, 1 );
	self thread play_fall_away_piece_rumble( "cp_infection_world_falls_break", time, 1, v_rumble_origin );	

	if( self.moving_platform_piece == 0 )
	{
		wait( time );
	}

	
	//************************************
	// World shakes before the piece moves
	//************************************
	
	fallaway_piece_rising_rumble( v_rumble_origin, self.moving_platform_piece, undefined );


	//***************
	// Piece Moves UP
	//***************

	self fallaway_piece_moves_up();

	
	//***********************
	// Hold piece before fall
	//***********************
	
	wait( 1.0 );
	

	//*****************
	// Start piece fall
	//*****************

	self fallaway_piece_falls( v_rumble_origin );


	//********
	// Cleanup
	//********

	self Delete();
}


//*****************************************************************************
//*****************************************************************************

// self = falling piece
function fallaway_piece_moves_up()
{
	self.moveup_dist =	80;;
	self.moveup_time =	1.7;
	self.moveup_accel =	0.8;;

	if( randomint(100) > 60 )
	{
		self.moveup_dist += randomintrange( 20, 50 );
	}
	
	self notify( "starting_move_up" );

	// Delay so the linked guys are in sync
	wait( 0.05 );

	// Do the move
	self MoveZ( self.moveup_dist, self.moveup_time, self.moveup_accel, self.moveup_accel );
	self waittill( "movedone" );
}


//*****************************************************************************
//*****************************************************************************

// self = falling piece
function fallaway_piece_falls( v_pos )
{
	self notify( "fall_starting" );
	
	const MOVE_DIST = -3000;		// -5000
	const FALL_TIME = 5.5;			// 5
	const FALL_ACCEL = 2.0;			// 2
	
	// rumble_time = 3.5;
	rumble_time = randomfloatrange( 1.2, 2.5 );
	self thread play_fall_away_piece_rumble( "cp_infection_world_falls_away", rumble_time, 1, v_pos );

	quake_size = 0.28;			// 0.22
	quake_time = rumble_time;	// 3.5
	quake_radius = 1850;		// 2000
	earthquake( quake_size, quake_time, v_pos, quake_radius );
	
	playsoundatposition( "evt_small_flyaway_go", v_pos );

	// Play the exploder
	falling_piece_exploder_effect( self.model );
	
	// If the falling piece has an animated guy fallnig to his death, the death anim speed needs to match the falling pieces speed
	if( self.moving_platform_piece )
	{
		self MoveZ( MOVE_DIST, 5.5, FALL_ACCEL );
	}
	else
	{
		self MoveZ( MOVE_DIST, FALL_TIME, FALL_ACCEL );
	}
		
	self waittill( "movedone" );
}


//*****************************************************************************
//*****************************************************************************

function fallaway_piece_rising_rumble( v_rumble_origin, moving_platform_piece, rumble )
{
	quake_size = 0.28;							// 0.22
	quake_time = randomFloatRange( 0.5, 1.5 );	// 2.5
	quake_radius = 1850;						// 2000

	// Override the quake time if its a moving platform
	if( moving_platform_piece )
	{
		quake_time = 1.0;
	}
	
	if( IsDefined(rumble) )
	{
		level thread fallaway_piece_rumble( v_rumble_origin );
	}

	earthquake( quake_size, quake_time, v_rumble_origin, quake_radius );
	wait( quake_time );

	playsoundatposition( "evt_small_flyaway_start", v_rumble_origin );
}

function fallaway_piece_rumble( v_origin )
{
	count = 0;
	while( count < 10 )
	{
		PlayRumbleOnPosition( "cp_infection_world_falls_break", v_origin );
		util::wait_network_frame();
		count++;
	}

	wait( 1 );

	count = 0;
	while( count < 20 )
	{
		PlayRumbleOnPosition( "cp_infection_world_falls_break", v_origin );
		util::wait_network_frame();
		count++;
	}
}

//*****************************************************************************
//*****************************************************************************

// self = falling piece
function falling_piece_skirt_effect()
{
	// Get the skirt piece
	str_name = self.model + "_skirt";
	a_skirts = getentarray( str_name, "targetname" );
	if( IsDefined(a_skirts) )
	{
		for( i=0; i<a_skirts.size; i++ )
		{
			a_skirts[i] thread skirt_piece_update( self );
		}
	}
}

// self = skirt model piece
function skirt_piece_update( e_parent_model )
{
	// Link the skirt piece to the parent model
	self LinkTo( e_parent_model ); 
		
	// Wait for the final drop of the piece
	e_parent_model waittill( "fall_starting" );

	// Small wait before we delete the skirt
	wait( 2 );

	//iprintlnbold( "DELETING SKIRT" );
	self delete();
}


//*****************************************************************************
// Get the exploder ID from the last 3 characters of the piece name
//*****************************************************************************

function falling_piece_exploder_effect( str_model_name )
{
	size = str_model_name.size;
	str_exploder_id = str_model_name[ size-3 ] + str_model_name[ size-2 ] + str_model_name[ size-1 ];
	str_name = "light_wfa_" + str_exploder_id;
	
	a_exploder_names = [];
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_003";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_017";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_028";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_034";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_049";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_060";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_069";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_080";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_088";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_092";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_100";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_106";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_125";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_133";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_135";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_136";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_138";
	a_exploder_names[ a_exploder_names.size ] = "light_wfa_143";

	// Does the falling piece hav an associated exploder name?
	found = 0;
	for( i=0; i<a_exploder_names.size; i++ )
	{
		if( str_name == a_exploder_names[i] )
		{
			found = 1;
			break;
		}
	}

	if( found )
	{
		exploder::exploder( str_name );
	}
}


//*****************************************************************************
//*****************************************************************************

// TODO: Get this to work
//#if 0
//function does_exploder_exist( str_exploder_name )
//{
//	a_ents = GetEntArray( "script_model", "classname" );
//
//	if( IsDefined(a_ents) )
//	{
//		for( i=0; i<a_ents.size; i++ )
//		{
//			if( isdefined(a_ents[i].targetname) && IsString(a_ents[i].targetname) && (a_ents[i].targetname == str_exploder_name) )
//			{
//				return( 1 );
//			}	
//		}
//	}
//	
//	return( 0 );
//}
//#endif


//*****************************************************************************
//*****************************************************************************

// self = falling piece
function piece_rising_effects( v_pos )
{
	// Attach the moving skirt piece
	self thread falling_piece_skirt_effect();

	playsoundatposition( "evt_small_flyaway_steam", v_pos );

	// Play Steam fx 
	str_identifier = GetSubStr( self.model, 20, self.model.size );  // remove 'p7_inf_bas_fallaway_'
	str_exploder = "forest_surreal_groundfall_steam_" + str_identifier;
	exploder::exploder( str_exploder );
}



//*****************************************************************************
//*****************************************************************************

//  self = scriptmover
function play_fall_away_piece_rumble( str_name, n_loops, n_wait, v_origin )
{
	for( i = 0; i < n_loops; i++ )
	{
		 PlayRumbleOnPosition( str_name, v_origin );
		 wait n_wait;
	}
}


//*****************************************************************************
//*****************************************************************************

function fall_away_piece_trigger( s_struct, radius )
{
// TODO: Kill the thread at the end of the event
	level endon( "hello mike" );
	
	// Needed so we don't trigger the notify on first run
	wait( 0.1 );

	// Only thread once for this struct instance
	if( IsDefined(s_struct.active) )
	{
		return;
	}
	s_struct.active = true;

	while( 1 )
	{
		// Multiple chunks could use the same struct to trigger them
		if( IsDefined(s_struct.triggered) )
		{
			return;
		}

		a_players = GetPlayers();
		for( i=0; i<a_players.size; i++ )
		{
			e_player = a_players[i];
			dist = Distance2d( s_struct.origin, e_player.origin );
			if( dist < radius )
			{
				level notify( s_struct.script_string );
				s_struct.triggered = true;
				//iprintlnbold( "TRIGGERING A FALLER" );
				return;
			}
			else
			{
				//strstr = "DIST: " + dist;
				//iprintlnbold(strstr);
			}
		}

		wait( 0.5 );
	}
}


//*****************************************************************************
// CAVE ENTRANCE 
//*****************************************************************************

function players_enter_cave()
{
	// Turn on the cave effects
	level thread scene::play( "p7_fxanim_gp_wire_thick_01_bundle" );


	objectives::set( "cp_standard_breadcrumb" , struct::get( "s_wfa_objective_cave" ) );	
	
	// Trigger cave entrance light
	exploder::exploder( "lgt_forest_tunnel_01" );

	trig = GetEnt( "cave_entrance", "targetname" );
	trig waittill( "trigger", who );

	objectives::complete( "cp_standard_breadcrumb" , struct::get( "s_wfa_objective_cave" ) );
	objectives::set( "cp_standard_breadcrumb" , struct::get( "s_wfa_objective_blackstation" ) );

	if( IsPlayer(who) )
	{	
		//lgt_forest_tunnel_01 – 07
		const n_exploders = 7;
		
		for( i=2; i<=n_exploders; i++ )
		{
			str_exploder_name = "lgt_forest_tunnel_0" + i;		
			exploder::exploder(str_exploder_name);
			wait( 1.0 );
		}
	}
		
	// Cleanup

	level waittill( "forest_wolves_complete" );

	scene::stop( "p7_fxanim_gp_wire_thick_01_bundle" );
}


// ----------------------------------------------------------------------------
// DIALOG: transition to night
// ----------------------------------------------------------------------------
function vo_transition_night()
{
	level dialog::player_say( "plyr_why_are_we_here_sar_0", 1.0 );//Why are we here, Sarah?
	level.players[0] dialog::say( "hall_don_t_you_know_0", 1.0 );//Don’t you know?
	level.players[0] dialog::say( "corv_listen_only_to_the_s_0", 1.0 );//Listen only to the sound of my voice.
	level.players[0] dialog::say( "corv_let_your_mind_relax_0", 1.0 );//Let your mind relax.
	level.players[0] dialog::say( "corv_imagine_yourself_in_0", 1.0 );//Imagine yourself in a frozen forest.
	level dialog::player_say( "plyr_hall_what_the_hell_0", 0.0 );//Hall! What the Hell is happening??
	level.players[0] dialog::say( "hall_so_much_suffering_s_0", 1.0 );//So much suffering. So much pain. It wasn’t just the enemy soldiers...

}

// ----------------------------------------------------------------------------
// DIALOG: transition to night
// ----------------------------------------------------------------------------
function vo_transition_wolves()
{
	level waittill( "wolf_howl" );
		
	level dialog::player_say( "plyr_what_the_hell_2", 1.0 );//What... the hell... was that?
	level.players[0] dialog::say( "hall_the_dire_wolves_a_0", 0.0 );//The Dire Wolves... At first, they scavenged upon the wounded - the weak. Later - they went after the strong.
}	

//*****************************************************************************
// DIALOG IGC: vo_worldfallsaway_vign
// TODO: much of this will be handled in cinematic
//*****************************************************************************

function vo_worldfallsaway_vign( a_ents )
{
	e_sarah = a_ents[ "sarah" ];
	
	e_sarah SetTeam( "allies" );
	e_player = infection_util::get_closest_player_to_position( a_ents[ "sarah" ].origin );
/*
	level dialog::player_say( "plyr_sarah_who_was_tha_0", 1.0 );//Sarah... Who was that voice... Have you heard it before?
*/	

	e_sarah waittill( "move_mountain" );

	// Notify the script to move the mountain
	level notify( "move_mountain" );
}


//*****************************************************************************
// 2 or 3 guys that run towards the player just before the trench
//*****************************************************************************

function runners_before_pit()
{
	e_trigger = getEnt( "t_runner_before_pit", "targetname" );
	e_trigger waittill( "trigger" );

	a_guys = GetEntArray( "sp_runner_before_pit", "targetname" );
	for( i=0; i<a_guys.size; i++ )
	{
		e_ent = a_guys[i] spawner::spawn();
		e_ent thread ent_run_to_goal( 0 );
	}
}

// self = ent
function ent_run_to_goal( hold_position )
{
	self endon( "death" );
	self.goalradius = 94;
	self waittill( "goal" );
	if( !( isdefined( hold_position ) && hold_position ) )
	{
		self.goalradius = 1024;
	}
}


//*****************************************************************************
// Called when a AI is spawned in WFA
//*****************************************************************************

// self = AI
function world_falls_away_ai_spawn_fn()
{
	if( IsDefined(self.script_noteworthy) && (self.script_string == "fall_to_death") )
	{
		self.ignoreall = true;
		self.goalradius = 64;
		debug_line( self );
		return;
	}

	self thread infection_util::set_goal_on_spawn();
}


//************************************************************************************
//************************************************************************************
//							coop_active_count_max	coop_active_count_min	coop_count
//
// sm_trench_dogs_wave2				3 5 10 14				3 5 10 14		2 6 12 16
//
// sm_dogs_left_side				3 5 6 6					5 5 6 6			4 6 8 10
// sm_dogs_right_side 				3 5 6 6					5 5 6 6			4 6 8 10
//
// sm_ending_dogs_right				3 4 6 8					3 4 6 8			5 7 10 12
// sm_ending_dogs_left				3 4 5 5					3 4 5 5			5 7 10 12
//
//************************************************************************************
//************************************************************************************

function wolves_attack()
{
	level.wolf_sprint_min_dist = 400;
	level.wolf_sprint_max_dist = 1000;

	// Dogs ignore the players until the soldiers in the trench are killed
	level thread dogs_ignore_playeroverride();
	
	// Wait to start the Wolves
	e_trigger = GetEnt( "wolves_attack_in_trench", "targetname" );
	e_trigger waittill( "trigger" );

	level notify( "wolves_start_attacking" );

	// Enemy soldiers in the old trench area that the wolves attack as part of the introduction
//	level thread dog_meat_guys();

	// VO for wolves attack
	level thread vo_transition_wolves();

	// Background wolves that run around like drones
	level thread dog_eyecandy();

	// Initial wave of wolves that attack the players and friendlies in the trench
//	level thread dogs_approaching_trench();

	// Play the audio introduction and the animated wolf intro
	level thread intro_wolf_animations();
	level thread wolf_intro_music();

	// Jumping wolves - After the player exits the trench (that was)
	level thread dogs_left_side();
	level thread dogs_right_side();

	// Wolves at the very end
	level thread ending_dogs_left();
	level thread ending_dogs_right();
}


//*****************************************************************************
// Animations that introduce the wolves
// - Two animations of wolves entering frmo the rocks
// - One animation of wolvez eating a guy
//*****************************************************************************

function intro_wolf_animations()
{
	// Wolf on top of the big rock
	level thread scene::play( "cin_inf_07_02_worldfallsaway_vign_direwolf_entrance" );

	// Wolf at the back of the bunker on the opposite rocks
	level thread scene::play( "cin_inf_07_02_worldfallsaway_vign_direwolf_entrance_bunker" );

	// Two wolves eating a guy in the trench
	// - Spawns in and puts them in the loop

	// Wolves eating humans
	scene::add_scene_func( "cin_inf_07_02_worldfallsaway_vign_direwolves_eating", &scene_callback_dude_getting_eaten, "init" );

	wait( 0.2 );
	level thread scene::init( "dude_getting_eaten_in_trench" );
}


//*****************************************************************************
// Looping animation of two wolves eating a solder on the ground
// - Break out of the loop if a player gets close
// - Or break out if the player kills one of the wolves
//*****************************************************************************



// self = bundle
function scene_callback_dude_getting_eaten( a_ents )
{
	e_soldier = a_ents["dude_getting_eaten"];
	e_soldier.ignoreme = true;
	
	looping = 1;
	while( looping )
	{
		// If the players are close, break out
		a_players = getplayers();
		for( i=0; i<a_players.size; i++ )
		{
			dist = Distance( self.origin, a_players[i].origin );
			if( dist < 600 )
			{
				looping = 0;
				break;
			}
		}

		// If one of the wolves is killed, break out
		e_wolf1 = a_ents["intro_wolf_eating_1"];
		e_wolf2 = a_ents["intro_wolf_eating_2"];
		if( !IsAlive(e_wolf1) || !IsAlive(e_wolf2) )
		{
			looping = 0;
			break;
		}

		wait( 0.05 );
	}

	// Play the break out of loop animation	
	level thread scene::play( self.targetname );
}


//*****************************************************************************
//*****************************************************************************

function wolf_intro_music()
{
	s_howl = struct::get_array( "wolf_intro_howl_struct", "targetname" );
	
	foreach ( struct in s_howl )
	{
		PlaySoundAtPosition( "aml_dire_wolf_howl", struct.origin );  // howl on spawn
		
		wait 0.25;
	}
	
	level notify( "wolf_howl" );
}


//*****************************************************************************
// Initial wave of dogs that attack the players and friendlies in the trench
//*****************************************************************************

function dogs_approaching_trench()
{
	a_spawners = GetEntArray( "trench_dogs_coop", "targetname" );
	a_players = getplayers();
	for( i=0; i<a_spawners.size; i++ )
	{
		a_spawners[i] spawner::spawn();
	}
	
	// This is a group that attacks through the trench at the start
	spawn_manager::enable( "sm_trench_dogs_wave2" );
}


//*****************************************************************************
//*****************************************************************************

function dogs_left_side()
{
	e_trigger = GetEnt( "t_jumping_dogs_after_trench", "targetname" );
	e_trigger waittill( "trigger" );
	spawn_manager::enable( "sm_dogs_left_side" );
}


//*****************************************************************************
//*****************************************************************************

function dogs_right_side()
{
	e_trigger = GetEnt( "t_jumping_dogs_after_trench", "targetname" );
	e_trigger waittill( "trigger" );
	spawn_manager::enable( "sm_dogs_right_side" );
}


//*****************************************************************************
//*****************************************************************************

function ending_dogs_left()
{

//wait( 5 );
//iprintlnbold( "STARTING DOG WAIT" );

//#if 1
	// NOTE: Used by BOTH "ending_dogs_left" and "ending_dogs_right"
	level thread catch_ending_trigger();
	level thread catch_ending_spawners_complete();

	// Wait until the active spawn managers are finished
	while( 1 )
	{
		if( ( isdefined( level.ending_trigger ) && level.ending_trigger ) && IsDefined(level.spawners_complete_time) )
		{
			break;
		}
		wait( 0.05 );
	}

	//iprintlnbold( "READY TO SPAWN ENDINGDOGS" );

	while( 1 )
	{
		time = gettime();
		dt = ( time - level.spawners_complete_time ) / 1000.0;
		if( dt > 5 )
		{
			break;
		}
		wait( 0.05 );
	}
//#endif

	level notify( "spawning_ending_dogs" );

//wait( 30 );
//iprintlnbold( "SPAWNING ENDING DOGS" );

	level notify( "spawn_ending_dogs" );

	level.wolf_sprint_min_dist = 250;
	level.wolf_sprint_max_dist = 600;

	spawn_manager::enable( "sm_ending_dogs_left" );
}

function ending_dogs_right()
{
	level waittill( "spawn_ending_dogs" );
	spawn_manager::enable( "sm_ending_dogs_right" );
}

function catch_ending_trigger()
{
	e_trigger = GetEnt( "t_ending_dogs", "targetname" );
	e_trigger waittill( "trigger" );
	level.ending_trigger = true;
}

function catch_ending_spawners_complete()
{
	s_struct = struct::get( "s_turn_off_eyecandy_wolves", "targetname" );
	v_forward = anglestoforward( s_struct.angles );

	while( 1 )
	{
		// First wait until both the left and right spawn managers are completed
		if( spawn_manager::is_complete("sm_dogs_left_side") && spawn_manager::is_complete("sm_dogs_right_side") )
		{
			if( !IsDefined(level.spawners_complete_time) )
			{
				level.spawners_complete_time = gettime();
			}
			
			// Now check that all players have approached the end arena
			a_players = GetPlayers();
			num_players_passed = 0;
			for( i=0; i<a_players.size; i++ )
			{
				e_player = a_players[i];
				v_dir = e_player.origin - s_struct.origin;
				v_dir = vectornormalize( v_dir );

				dp = vectordot( v_dir, v_forward );
				if( dp > 0.2 )
				{
					num_players_passed++;
				}
			}

			if( num_players_passed == a_players.size )
			{
				//iprintlnbold( "Turning off Eyecandy Wolves" );
				break;
			}
		}

		wait( 0.05 );
	}
}


//*****************************************************************************
// script_string:	  If "sprinter" the wolf sprints immediately when spawned
//					  If "stalker" will stalk for 10 seconds befire using radius
// script_noteworthy: If "no_audio" the wolf doesn't play an intro audio effect
//						- used by the eyecandy
// script_float:	  If set its an override sprint dist
//*****************************************************************************

// self = ai
function spawn_func_wolf()
{
	self endon( "death" );

	if( !IsDefined(level.wolf_sprint_min_dist) )
	{
		return;
	}
	
	// Only allow the players to hurt the wolves
	self.overrideActorDamage = &callback_wolf_damage;
	
	// Howl on spawn
	if( !(IsDefined(self.script_noteworthy) && (self.script_noteworthy == "no_audio")) )
	{
		PlaySoundAtPosition( "aml_dire_wolf_howl", self.origin );
		// Play attack sounds
		self thread infection_util::zmbAIVox_NotifyConvert();
	}

	initial_delay = 0;

	// Set the sprint mode
	if( IsDefined(self.script_string) && (self.script_string == "sprinter") )
	{
		self ai::set_behavior_attribute( "sprint", true );
	}
	else
	{
		if( IsDefined(self.script_string) && (self.script_string == "stalker") )
		{
			initial_delay = randomintrange( 6, 12 );
		}

		dist = randomintrange( level.wolf_sprint_min_dist, level.wolf_sprint_max_dist );
		if( IsDefined(self.script_float) )
		{
			dist = self.script_float;
		}

		self thread wolf_sprint_check( initial_delay, dist );
	}
}

function callback_wolf_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if( IsDefined(eAttacker) && !IsPlayer(eAttacker) )
	{
		iDamage = 0;
	}
	return( iDamage );
}


//*****************************************************************************
//*****************************************************************************
// self = wolf
function wolf_sprint_check( initial_delay, sprint_dist )
{
	self endon( "death" );
	self endon( "kill_sprint_check" );

	if( IsDefined(initial_delay) )
	{
		wait( initial_delay );
	}

	while( 1 )
	{
		dist = dist_to_players( self.origin );

		// If the dog is looking at the players, they can break out of sprint sooner
//#if 0
//		player_angle = self looking_at_players_angle( 1 );
//		if( player_angle > 0.7 )
//		{
//			iprintlnbold( "looking at players" );
//			dist -= 200;
//		}
//#endif

		if( dist < sprint_dist )
		{
			self ai::set_behavior_attribute( "sprint", true );
			return;
		}

		delay = randomfloatrange( 0.0, 1.0 );
		wait( delay );
	}
}


//*****************************************************************************
// Friendlies that get attacked in the trench
//*****************************************************************************

function dog_meat_guys()
{
	level.num_trench_guys_killed = 0;
	a_guys = GetEntArray( "sp_enemy_trench", "targetname" );
	for( i=0; i<a_guys.size; i++ )
	{
		e_ent = a_guys[i] spawner::spawn();
		e_ent.name = "";
		e_ent thread ent_run_to_goal( 1 );
		e_ent thread count_trench_guy_deaths();
		//e_ent.ignoreall = true;
		e_ent.goalradius = 64;
	}
}


//***************************************************************************
//***************************************************************************

// self = trench guy
function count_trench_guy_deaths()
{
	self waittill( "death" );
	level.num_trench_guys_killed++;
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

function dist_to_players( pos )
{
	closest = 999999;

	a_players = getplayers();
	for( i=0; i<a_players.size; i++ )
	{
		dist = distance( a_players[i].origin, pos );
		if( dist < closest )
		{
			closest = dist;
		}
	}

	return( closest );
}


// self = ent
function looking_at_players_angle( ignore_z )
{
	best_dp = 1000.0;

	v_pos = self.origin;
	v_forward = vectorNormalize( AnglesToForward( self.angles ) );

	if( ignore_z )
	{
		v_pos = ( v_pos[0], v_pos[1], 0.0 );
	}

	a_players = getplayers();
	for( i=0; i<a_players.size; i++ )
	{
		player_origin = a_players[i].origin;
		if( ignore_z )
		{
			player_origin = ( player_origin[0], player_origin[1], 0.0 );
		}

		v_dir = vectorNormalize( player_origin - v_pos );
		dp = vectordot( v_forward, v_dir );
		if( dp < best_dp )
		{
			best_dp = dp;
		}
	}

	return( best_dp );
}


//*****************************************************************************
// Background "drone" wolves on path
//*****************************************************************************

function dog_eyecandy()
{
	start_pos = struct::get_array( "dog_eyecandy_startpath" );
	array::thread_all( start_pos, &dog_follow_nodes_eyecandy );
}

// self = struct
function dog_follow_nodes_eyecandy()
{
	level endon( "world_falls_away_ravine_start" );
	level endon( "ending_dogs_starting" );
	level endon( "spawning_ending_dogs" );
	
	while( 1 )
	{
		dog_spawner = GetEnt( "sp_eyecandy_wolf", "targetname" );
		wolf = spawner::simple_spawn_single( dog_spawner );
		wolf thread wolf_drone_path( self );

		if( IsDefined(self.script_vector) )
		{
			delay = randomfloatrange( self.script_vector[0], self.script_vector[1]);
		}
		else
		{
			delay = randomfloatrange( 53.0, 55.0 );		// 3.0, 5.0
		}
		wait( delay );
	}
}

// self = wolf
function wolf_drone_path( s_path )
{
	self endon( "death" );

	if( !IsDefined(level.dog_delay) )
	{
		level.dog_delay = 0;
	}
	self notify( "kill_sprint_check" );
	self thread wolf_start_running( level.dog_delay, 15 );
	level.dog_delay = level.dog_delay + 1;
	if( level.dog_delay > 6 )
	{
		level.dog_delay = 0;
	}
		
	self.goalradius = 32;
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	self ForceTeleport( s_path.origin, s_path.angles );
	next_pos = s_path;

	while( true )
	{
//#if 0
//		if( IsDefined(next_pos.script_string) && (next_pos.script_string == "attack_player") )
//		{
//			return;
//		}
//#endif

		if( IsDefined(next_pos.target) )
		{
			next_pos = struct::get( next_pos.target, "targetname" );
		}
		else
		{
			break;
		}					
	
		//self.goalradius = 32;		
		self setgoalpos( next_pos.origin, true, 32 );
		self waittill( "goal" );
	}

	self delete();
}

// self = wolf
function wolf_start_running( delay, kill_time )
{
	self endon( "death" );

	start_time = gettime();

	wait( delay );
	self ai::set_behavior_attribute( "sprint", true );

	while( 1 )
	{
		time = gettime();
		dt = ( time - start_time ) / 1000.0;
		if( dt > kill_time )
		{
			break;
		}
		wait( 0.1 );
	}

	self delete();
}


//*****************************************************************************
// Dogs ignore the players until the soldiers in the trench are killed
//*****************************************************************************

function dogs_ignore_playeroverride()
{
	level.is_player_valid_override = &is_player_valid_dog_target;
}

function is_player_valid_dog_target( player )
{
	a_spawners = getentarray( "sp_enemy_trench", "targetname" );

//#if 0
//	if( IsDefined(level.num_trench_guys_killed) && (level.num_trench_guys_killed >= a_spawners.size) )
//	{
//		level.is_player_valid_override = undefined;
//		return( true );
//	}
//	return( false );
//#else
	return( 1 );
//#endif
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//self = ai_objective_sarah
function sarah_waits_at_ravine()
{
	self thread scene::play( "cin_inf_07_02_worldfallsaway_vign_knelt", self );
		
	level waittill( "world_falls_away_ravine_start" );

	self scene::stop( "cin_inf_07_02_worldfallsaway_vign_knelt" );
	self thread scene::play( "cin_inf_07_03_worldfallsaway_vign_pain", self );
	
	// Notify 1 second from end of scene.
	level waittill( "ravine_seen_fade" );

	self thread infection_util::actor_camo( 1 );
		
	self waittill( "scene_done" );
	
	self Delete();	
	
	level.sarah_ravine_anim_complete = true;
}


//*****************************************************************************
//*****************************************************************************

function chasm_opens()
{
	level flag::init( "chasm_open" );
	
	// Wait for the players to get close to Sarah
	trigger::wait_till( "world_falls_away_ravine_start" );
	
	// Sarah starts the open ravine animation
	level notify( "world_falls_away_ravine_start" );

	// Kill off the wolves
	level thread kill_off_wolves();

	// Trigger the chasm to open	
	chasm_movement_start();
}


//*****************************************************************************
// Move the chasm geo after meeting up wth Sarah
//*****************************************************************************

function chasm_movement_start()
{
//#if 0
//	while( !IS_TRUE(level.sarah_ravine_anim_complete) )
//	{
//		wait( 0.05 );
//	}
//#endif

	// Wait for a notetrack from the animation
	level waittill( "move_mountain" );

	// Kick off the chasm opening effects
	level thread chasm_opens_effects();

	//prestream next closeup scene
	level thread util::set_streamer_hint( 4 );
		
	// Force streamer to load blackstation murder script bundles when the chasm start moving.
	level thread util::set_streamer_hint( 2 );

	playsoundatposition( "evt_pullapart_world", (0,0,0) );

	// Start the rumble
	level thread chasm_rumble_start();

	// Start the effect explode
	exploder::exploder( "light_wfa_end" );

	// Get the entities to move and move them
	a_chasm = GetEntArray( "world_falls_away_chasm", "targetname" );
	Assert( IsDefined( a_chasm ), "world falls away: chasm model not found!" );

	const MOVE_TIME = 12;
	const ACCEL_TIME = 5;
	const DECEL_TIME = 5;

	// Move the cave blocker separately
	level thread move_cave_blocker( MOVE_TIME, ACCEL_TIME, DECEL_TIME );

	// Move the ents
	for( i=0; i<a_chasm.size; i++ )
	{
		str_name = a_chasm[i].target;

		if( IsDefined(str_name) )
		{
			s_struct = struct::get( str_name, "targetname" );
			target_position = s_struct.origin;
			a_chasm[i] SetMovingPlatformEnabled( true );
			a_chasm[i] MoveTo( target_position, MOVE_TIME, ACCEL_TIME, DECEL_TIME );
		}
	}
	
	a_chasm[0] waittill( "movedone" );
	a_chasm[0] playloopsound( "evt_pullapart_world_looper", 3 );

	level thread players_enter_cave();
	level flag::set( "chasm_open" );
}


//*****************************************************************************
// Screenshake and Rumble as the chasm opens
//*****************************************************************************

function chasm_rumble_start()
{
	s_earthquake = struct::get( "chasm_earthquake_start_struct", "targetname" );
	Assert( IsDefined( s_earthquake ), "chasm_rumble_start: chasm earthquake struct not found!" );

	a_chasm = GetEntArray( "world_falls_away_chasm", "targetname" );
	Assert( IsDefined( a_chasm ), "chasm_rumble_start: chasm model not found!" );
		
	// temp entity is used as reference point since chasm model origin is nowhere near play-space
	e_chasm = a_chasm[0];
	e_temp = Spawn( "script_origin", s_earthquake.origin );
	e_temp LinkTo( e_chasm );	
	
	const UPDATE_TIME = 0.05;
	
	while ( !level flag::get( "chasm_open" ) )
	{
		Earthquake( 0.18, ( UPDATE_TIME * 4 ), e_temp.origin, 3000 );
		
		e_temp infection_util::slow_nearby_players( 3000, 2 );

		PlayRumbleOnPosition( "cp_infection_world_falls_break", e_temp.origin );
		
		wait UPDATE_TIME;
	}
	
	Earthquake( 0.25, 2, e_temp.origin, 3000 );
	
	e_temp Delete();	
}


//*****************************************************************************
//*****************************************************************************

function move_cave_blocker( MOVE_TIME, ACCEL_TIME, DECEL_TIME )
{
	e_ent = getent( "world_falls_away_chasm_blocker", "targetname" );

	s_struct = struct::get( e_ent.target, "targetname" );
	e_ent MoveTo( s_struct.origin, MOVE_TIME, ACCEL_TIME, DECEL_TIME );
	e_ent waittill( "movedone" );
	e_ent delete();
}


//*****************************************************************************
//*****************************************************************************

function chasm_opens_effects()
{
	// Ravine moving rocks fxanim, attached to ent with target "final_position_3"
	scene::add_scene_func( "p7_fxanim_cp_infection_rock_mountain_bundle", &fxanim_ravine_moving_rocks_callback, "play" );
	level thread scene::play( "p7_fxanim_cp_infection_rock_mountain_bundle" );

	// Looping hovering rocks, kill them off at the end of the event
	level thread scene::play( "p7_fxanim_cp_infection_rock_bridge_floaters_bundle" );

	// Three bundles that move up and hover
	level thread scene::play( "p7_fxanim_cp_infection_rock_bridge_p1_bundle" );
	level thread scene::play( "p7_fxanim_cp_infection_rock_bridge_p2_bundle" );
	// This one blocks
	scene::play( "p7_fxanim_cp_infection_rock_bridge_p3_bundle" );

	// Small wait to make sure all the anims above have cleared
	wait( 0.5 );

	// Wait for the players to approach the floating rocks
	infection_util::wait_for_all_players_to_pass_struct( "s_ravine_drop_marker_p1" );
	level thread scene::play( "p7_fxanim_cp_infection_rock_bridge_p1_end_bundle" );
	
	infection_util::wait_for_all_players_to_pass_struct( "s_ravine_drop_marker_p2" );
	level thread scene::play( "p7_fxanim_cp_infection_rock_bridge_p2_end_bundle" );

	infection_util::wait_for_all_players_to_pass_struct( "s_ravine_drop_marker_p3" );
	level thread scene::play( "p7_fxanim_cp_infection_rock_bridge_p3_end_bundle" );

	// Cleanup
	level waittill( "forest_surreal_complete" );
	level thread scene::stop( "p7_fxanim_cp_infection_rock_bridge_floaters_bundle" );
}


//*****************************************************************************
//*****************************************************************************

function fxanim_ravine_moving_rocks_callback( a_ents )
{
	e_effect = a_ents["rock_mountain"];

	e_rock = getent( "final_position_3", "target" );

	e_effect linkto( e_rock );
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

function kill_off_wolves()
{
	// Kill of the ending spawn managers if they are still active
	if( !spawn_manager::is_complete("sm_ending_dogs_left" ) )
	{
		spawn_manager::disable( "sm_ending_dogs_left" );
	}
	if( !spawn_manager::is_complete("sm_ending_dogs_right" ) )
	{
		spawn_manager::disable( "sm_ending_dogs_right" );
	}

	// Kill any remaining wolves
	a_ai = GetAITeamArray( "team3" );
	for( i=0; i<a_ai.size; i++ )
	{
		a_ai[i] kill();
	}
}


//*****************************************************************************
//*****************************************************************************

function wait_for_player_to_enter_black_station()
{
	trigger = GetEnt( "black_station_start_trigger", "targetname" );
	
	trigger waittill( "trigger", who );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "s_wfa_objective_blackstation" ) );	

	util::screen_fade_out( 1, "black" );

	level notify( "level_complete_cleanup" );
	
	// AUDIO: Stopping a looper
	a_chasm = GetEntArray( "world_falls_away_chasm", "targetname" );
	a_chasm[0] stoploopsound( 5 );
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
// SETUP:
// Falling geo ent
//   - Add kvp script_string "moving_platform"
//   - Add a path node on the piece so the nav mesh will be generated
//
// Falling soldier
//   - Add kvp script_string "fallaway_xxx" (the same fallaway id as on the target struct)
//
// script struct
// - needs script_notewirthy and script_string = fallayay_XXX
//
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

function wfa_falling_platform_guys()
{
	// Spawn the guys standing on falling platforms - RIGHT PATH
	level thread world_falls_away_falling_guys( "t_world_falls_away_intro", "world_falls_away_intro_falling_guys" );
	level thread world_falls_away_falling_guys( "sm_world_falls_away_middle", "world_falls_away_middle_falling_guys" );
	
	// Spawn the guys standing on falling platforms - LEFT PATH
	level thread world_falls_away_falling_guys( "t_left_side_fallers_1", "world_falls_away_left_1_falling_guys" );

	// Spawn the guys standing on falling platforms - MIDDLE PATH
	level thread world_falls_away_falling_guys( "t_left_side_fallers_1", "wfa_middle_path_falling_guys" );
}

//*****************************************************************************
// ent parameters:-
//  - script_string, the targetname of the falling piece ( eg. fallaway_34)
//  - script_noteworthy - If "ignore" then the guy will ignore all
//  - script_parameters - targetname of a node to move towards
//*****************************************************************************

function world_falls_away_falling_guys( str_trigger, str_spawners )
{
	e_trigger = GetEnt( str_trigger, "targetname" );
	if( IsDefined(e_trigger) )
	{
		e_trigger waittill( "trigger" );
	
		a_spawners = GetEntArray( str_spawners, "targetname" );
		for( i=0; i<a_spawners.size; i++ )
		{
			e_ent = a_spawners[i] spawner::spawn();
			infection_util::cleanup_group_add( e_ent, "FALLING_GUYS" );
			e_ent thread fall_from_rock_guy();
		}
	}
}


//********************************************************************************************
// self.script_string: The script struct that causes the piece to fallaway
// self.script_noteworthy: Optional set piece animation that plays when the piece is about to fall
// self.radius - If set, use as the ai's goal radius
//********************************************************************************************

// self = AI
function fall_from_rock_guy()
{
	self endon( "death" );

//self thread debug_line( self );

	if( IsDefined(self.radius) )
	{
		self.goalradius = self.radius;
	}

	// Does the guy play a custom animation on the falling piece?
	if( IsDefined(self.script_noteworthy) && IsSubStr( self.script_noteworthy, "cin_" ) )
	{
		self.goalradius = 64;
		custom_fall_anim = self.script_noteworthy;
	}
		
	// Does the guy want to move?
	if( IsDefined(self.target) )
	{
		self thread goto_target_faller();
	}
	
//#if 0
//	// Ignore all?
//	if( IsDefined(self.script_noteworthy) && ( self.script_noteworthy == "ignore" ) )
//	{
//		self.ignoreall = true;
//	}
//#endif

	// Get the script struct that triggers the piece to fall and wait for it to start falling
	s_struct = struct::get( self.script_string, "script_noteworthy" );
	e_falling_piece = s_struct.moving_platform;
	
	// Wait for the piece to start moving up
	e_falling_piece waittill( "starting_move_up" );
	
	self.ignoreall = 1;

	// Let the platform rise
	//e_falling_piece waittill( "movedone" );
	wait( e_falling_piece.moveup_time );

	// Check for optional custom animation, EG.  Jump off the piece
	if( 1 == 1 )
	{
		if( IsDefined(custom_fall_anim) )
		{
			wait( 0.2 );
			self thread scene::play( custom_fall_anim, self );
			wait( 1.2 );
			self Kill();
			return;
		}
	}

	// Play the wobble animation
	str_wobble_anim = get_wobble_animation();
	if( 1 == 1 )
	{
//#if 0
//		e_tag_origin = util::spawn_model( "tag_origin", self.origin, self.angles );
//		e_tag_origin MoveZ( e_falling_piece.moveup_dist, e_falling_piece.moveup_time, e_falling_piece.moveup_accel );
//		e_tag_origin thread scene::play( str_wobble_anim, self );
//#else
		self thread scene::play( str_wobble_anim, self );
//#endif
	}

	// Wait for the platform to start the fall
	e_falling_piece waittill( "fall_starting" );

	// Stop the wobble animation
	if( 1 == 1 )
	{
//#if 0
//		e_tag_origin scene::stop( str_wobble_anim );
//		e_tag_origin delete();
//#else
		self scene::stop( str_wobble_anim );
//#endif
	}
	
	// Play the fall animation
	if( 1 == 1 )
	{
		if( !IsDefined(level.vign_fall_anim_index) )
		{
			init_vign_fall_anims();
		}
		str_anim = get_vign_fall_anim();
		scene::play( str_anim, self );
	}
	else
	{
		wait( 5 );
	}

	self delete();
}


//*****************************************************************************
//*****************************************************************************

function get_wobble_animation()
{
	if( !IsDefined(level.wobble_anim_index) )
	{
		level.wobble_anim_index = 0;
	}

	switch( level.wobble_anim_index )
	{
		case	0:
			str_animation = "cin_gen_vign_offbalance_a";
		break;

		case	1:
			str_animation = "cin_gen_vign_offbalance_b";
		break;

		// These are blockout animations so just level them now for reference

		case	2:
			str_animation = "cin_gen_vign_offbalance";
		break;

		case	3:
			str_animation = "cin_gen_vign_offbalance_left";
		break;

		case	4:
			str_animation = "cin_gen_vign_offbalance_right";
		break;

		default:
		case	5:
			str_animation = "cin_gen_vign_offbalance_center";
		break;
	}
	
	level.wobble_anim_index++;
	if( level.wobble_anim_index > 1 )
	{
		level.wobble_anim_index = 0;
	}

	return( str_animation );
}


//*****************************************************************************
//*****************************************************************************

// self = ent
function goto_target_faller()
{
	self endon( "death" );
	self.goalradius = 64;
	self waittill( "goal" );
}

//*****************************************************************************
//*****************************************************************************

function init_vign_fall_anims()
{
	level.vign_anim_index = 0;
	level.a_vign_fall_anims = [];
	if ( !isdefined( level.a_vign_fall_anims ) ) level.a_vign_fall_anims = []; else if ( !IsArray( level.a_vign_fall_anims ) ) level.a_vign_fall_anims = array( level.a_vign_fall_anims ); level.a_vign_fall_anims[level.a_vign_fall_anims.size]="cin_gen_vign_fall_left";;
	if ( !isdefined( level.a_vign_fall_anims ) ) level.a_vign_fall_anims = []; else if ( !IsArray( level.a_vign_fall_anims ) ) level.a_vign_fall_anims = array( level.a_vign_fall_anims ); level.a_vign_fall_anims[level.a_vign_fall_anims.size]="cin_gen_vign_fall_right";;
}

function get_vign_fall_anim()
{
	str_anim = level.a_vign_fall_anims[level.vign_anim_index];
	level.vign_anim_index++;
	if( level.vign_anim_index >= level.a_vign_fall_anims.size )
	{
		level.vign_anim_index = 0;
	}
	return( str_anim );
}


//*****************************************************************************
//*****************************************************************************
// Ai behaviours
//*****************************************************************************
//*****************************************************************************


//*****************************************************************************
//*****************************************************************************

function intro_guys()
{
	e_trigger = getent( "t_move_1st_falling_guys", "targetname" );
	e_trigger waittill( "trigger" );
	spawn_manager::enable( "sm_world_falls_away_intro" );
}

// self = ai
function intro_guy_goto_node()
{
	self endon( "death" );

	if( IsDefined(self.script_noteworthy) )
	{
		self.goalradius = 48;
		n_node = getnode( self.script_noteworthy, "targetname" );
		self setgoal( n_node.origin );	
	}
}


//*****************************************************************************
//*****************************************************************************

function ai_middle_path_spawners()
{
	e_trigger = getent( "t_wfa_middle_path", "targetname" );
	e_trigger waittill( "trigger" );
	spawn_manager::enable( "sm_wfa_middle_path" );
}


//*****************************************************************************
// THese falling pieces are the only pnes animated, so they are special
//*****************************************************************************

function fancy_falling_pieces_at_start()
{
	str_bundle_1 = "p7_fxanim_cp_infection_world_falling_116_bundle";
	str_bundle_2 = "p7_fxanim_cp_infection_world_falling_117_bundle";
	str_bundle_3 = "p7_fxanim_cp_infection_world_falling_132_bundle";
	
	level thread scene::init( str_bundle_1 );
	level thread scene::init( str_bundle_2 );
	level thread scene::init( str_bundle_3 );

	e_trigger = getent( "t_fancy_falling_pieces_at_start", "targetname" );
	e_trigger waittill( "trigger" );

	// Use this struct for the rumble origin
	s_struct = struct::get( "s_fancy_falling_pieces_at_start", "targetname" );
	v_rumble_origin = s_struct.origin;
	level thread fallaway_piece_rising_rumble( v_rumble_origin, false, true );
	
	level thread scene::play( str_bundle_1 );
	wait( 0.75 );
	level thread scene::play( str_bundle_2 );
	wait( 1.25 );
	level thread scene::play( str_bundle_3 );
}


//*****************************************************************************
//*****************************************************************************
// AI cleanup during level progression
//*****************************************************************************
//*****************************************************************************


//*****************************************************************************
// Cleanup for the forest_surreal event
//*****************************************************************************

function forest_surreal_cleanup_thread()
{
	// Cleanup the remaining AI from the forest section
	cleanup_bastogne_ai();

	// Cleanup all the guys standing on falling platforms
	level waittill( "wolves_start_attacking" );
	infection_util::cleanup_group_kill( "FALLING_GUYS", 1 );
}


//*****************************************************************************
// Cleanup for the forest_wolves event
//*****************************************************************************

function forest_wolves_cleanup_thread()
{
	// Soldier cleanup, needed so the dogs don't target enemy soldiers behind you
	level thread cleanup_soldiers_in_forest_surreal();

	// Do not want to do this untill we completely leave WFA
	level waittill( "level_complete_cleanup" );
	level thread level_complete_cleanup();
}


//*****************************************************************************
//*****************************************************************************

function cleanup_bastogne_ai()
{
	a_allies = GetAITeamArray( "allies" );
	foreach(ai in a_allies)
	{
		if( IsDefined(ai.targetname) )
		{
			if(IsSubStr(ai.targetname, "friendly_guys_bastogne_"))
			{	
				ai thread delete_not_seen( 512 );	
			}
		}
	}

	a_axis = GetAITeamArray( "axis" );
	foreach(ai in a_axis)
	{
		if( IsDefined(ai.targetname) )
		{
			if(IsSubStr(ai.targetname, "reverse_anim_") || IsSubStr(ai.targetname, "sm_bastogne_reinforcements_") )
			{	
				ai thread delete_not_seen( 1024 );	
			}
		}
	}
}


//*****************************************************************************
// Soldier cleanup, needed so the dogs don't target enemy soldiers behind you
// - Also we remove clamp the max guys alive to avoid server spikes
//*****************************************************************************

function cleanup_soldiers_in_forest_surreal()
{
	// Clamp the max number of soldiers alive
	a_ai = GetAITeamArray( "axis" );
	if( IsDefined(a_ai) )
	{
		if( a_ai.size > 12 )
		{
			// The array is sorted by closest to furthest from the players
			a_sorted_ai = infection_util::ent_array_distance_from_players( a_ai );
		
			num_to_kill = a_sorted_ai.size - 12;
			for( i=0; i<num_to_kill; i++ )
			{
				index = a_sorted_ai.size - 1 - i;
				a_sorted_ai[index] kill();
			}
		}
	}

	
	// Get the dogs to ignore the soldeirs remaining
	e_info_volume = getent( "world_falls_apart_soldier_kill_volume", "targetname" );
	a_ai = GetAITeamArray( "axis" );
	if( IsDefined(a_ai) )
	{
		for( i=0; i<a_ai.size; i++ )
		{
			if( a_ai[i] IsTouching(e_info_volume) )
			{
				a_ai[i].ignoreme = true;
			}
		}
	}
	

	// Wait until we leave the trench area
	e_trigger = GetEnt( "t_jumping_dogs_after_trench", "targetname" );
	e_trigger waittill( "trigger" );
	
			
	// Now we can delete the remaining AI soldiers
	a_ai = GetAITeamArray( "axis" );
	if( IsDefined(a_ai) )
	{
		for( i=0; i<a_ai.size; i++ )
		{
			if( a_ai[i] IsTouching(e_info_volume) )
			{
				a_ai[i] delete();
			}
		}
	}
}


//*****************************************************************************
//*****************************************************************************

function level_complete_cleanup()
{
	infection_util::enable_exploding_deaths( false );

	infection_util::turn_off_snow_fx_for_all_players();
	
	level util::set_lighting_state( 0 );
	
	infection_util::delete_all_ai();
	
	infection_util::delete_ents_if_defined( "reverse_anim_trigger", "script_noteworthy" );
}


//*****************************************************************************
//*****************************************************************************
// Hanging on Ledge Dudes
//*****************************************************************************
//*****************************************************************************

function hanging_on_ledge_dudes()
{
	// Guys hanging from rocks
	scene::add_scene_func( "cin_gen_vign_fall_fall", &guy_hanging_from_rock_callback, "play" );

	a_scene_bundles = struct::get_array( "hanging_on_ledge_dude", "targetname" );
	level thread array::spread_all( a_scene_bundles, &update_hanging_dude );
}


//*****************************************************************************
//*****************************************************************************

// self = animation bundle
function update_hanging_dude()
{
	level endon( "wolves_start_attacking" );

	level waittill( self.script_string );

	buffer_time = 2.0;
	wait( 1.7 + 1.0 + buffer_time );
	
	if( IsDefined(self.script_delay) )
	{
		wait( self.script_delay );
	}

	//iprintlnbold( "STARTING HANGING DUDE" );

	self scene::play();
}


//*****************************************************************************
//*****************************************************************************

function guy_hanging_from_rock_callback( a_ents )
{
//	debug_line( a_ents[0] );
}



//*****************************************************************************
//*****************************************************************************
// DEBUG
//*****************************************************************************
//*****************************************************************************

function debug_line( e_ent )
{
	e_ent endon( "death" );

	while( 1 )
	{
		v_start = e_ent.origin;

		v_end = v_start + ( 0, 0, 1000 );
		v_col = ( 1, 1, 1 );

/#
		line( v_start, v_end, v_col );
#/

		wait( 0.1 );
	}
}


