#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\exploder_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                               	                                                          	              	                                                                                           

#using scripts\cp\_dialog;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_infection_forest_surreal;
#using scripts\cp\cp_mi_cairo_infection_util;

#using scripts\cp\_mobile_armory;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace forest;


//*****************************************************************************
//*****************************************************************************














//*****************************************************************************
//*****************************************************************************

#precache( "model", "p6_wine_bottle" );
#precache( "model", "p7_light_hurricane_lamp" );
#precache( "model", "p7_fxp_debris_newspaper_01" );
#precache( "model", "p7_fxp_debris_newspaper_02" );
#precache( "model", "p7_fxp_debris_newspaper_03" );
#precache( "model", "p7_book_vintage_01" );
#precache( "model", "p7_book_vintage_02" );
#precache( "model", "p7_book_vintage_01_burn" );
#precache( "model", "p7_book_vintage_02_burn " );
#precache( "model", "p7_binoculars" );
#precache( "model", "p7_gas_mask_can" );
#precache( "model", "p7_shovel_trench_kit" );
#precache( "model", "p7_hat_officer_nazi" );
#precache( "model", "p7_breadbag_flat" );



//*****************************************************************************
// init_client_field_callback_funcs
//*****************************************************************************

function init_client_field_callback_funcs()
{	
	// Mortars
	clientfield::register( "world", "forest_mortar_index", 1, 3, "int" );
	
	// Falling debris at the start
	clientfield::register( "world", "forest_sgen_falling_debris_1", 1, 1, "int" );

	clientfield::register( "toplayer", "pstfx_frost_up", 1, 1, "counter" );
	clientfield::register( "toplayer", "pstfx_frost_down", 1, 1, "counter" );
}
	

//*****************************************************************************
// Bastogne Intro Cinematic
//*****************************************************************************

function intro_main( str_objective, b_starting )
{
	skipto::teleport_players( str_objective );

	level flag::wait_till( "all_players_spawned" );

	if( b_starting )
	{
		exploder::exploder( "sgen_server_room_fall" );
	}		

	level thread exploding_trees_init();

	level.str_friendly_intro = "cin_inf_06_02_bastogne_vign_intro";
	level.str_sarah_intro = "cin_inf_06_02_bastogne_vign_sarahintro";
	level.str_player_intro = "cin_inf_06_02_bastogne_vign_playerintro";

	scene_setup();
	spawner_setup();

	infection_util::turn_on_snow_fx_for_all_players();

	if( 0 == 0 )
	{
		level thread intro_only_falling_debris_from_sgen();
	}

	level thread intro_only_random_mortar_explosions();

	// Frozen soldiers at the start
	level thread bastogne_frozen_soldiers();

	sarah_intro();

	level thread skipto::objective_completed( str_objective );
}	


//*****************************************************************************
//*****************************************************************************

function intro_cleanup( str_objective, b_starting, b_direct, player )
{
}


//*****************************************************************************
// MAIN
//*****************************************************************************

function forest_main( str_objective, b_starting )
{
	// Warp players to this location if we're not using a skipto - this transition will be added in event logic later
    if( b_starting )
	{
		level flag::wait_till( "all_players_spawned" );

		spawner_setup();

		// Falling debris from sgen
		if( 0 == 0 )
		{
			level thread falling_debris_from_sgen();
		}

		level thread random_mortar_explosions();

		infection_util::turn_on_snow_fx_for_all_players();

		//friendly ai scene, force to end.	
		level.str_friendly_intro = "cin_inf_06_02_bastogne_vign_intro";
		level thread scene::skipto_end( level.str_friendly_intro );
		level thread scene::skipto_end( "p7_fxanim_cp_infection_sgen_floor_debris_bundle" );
	}

	// Reduce german accuracy in 1 player games
	level.bastogne_reduced_accurcy = 0.8;
	if( ( isdefined( 1 ) && 1 ) )
	{
		num_players = GetPlayers().size;
		if( num_players == 1 )
		{
			level.reduce_german_accuracy = 1;
		}
	}

	level thread infection_util::sarah_objective_move( "t_sarah_bastogne_objective_", 0, &forest_surreal::sarah_waits_at_ravine );
	level thread force_sarah_move();

	level thread bastogne_battle_startup();

	// Some set piece ai in opening area
	level thread wakamole_guys();

	// Guys in the midle path
	level thread bastogne_hill_running_group();
	level thread sniper_guys_on_rocks();
	level thread high_ground_rpg();
	level thread bastogne_left_side_rocks_fallback();

	// Guys on the right path
	level thread bastogne_right_side_runners();
	level thread bastogne_right_side_wave2();

	// Guys on the 2nd hill
	level thread bastogne_2nd_hill_rienforcements( "t_2nd_hill_rienforcements", "sp_2nd_hill_rienforcements" );
	level thread bastogne_2nd_hill_rienforcements( "t_2nd_hill_rienforcements", "sp_2nd_hill_rienforcements_mg_side" );

	// SM at the very end
	level thread bastogne_final_guys();
	
	// Fallback behaviours
	level thread forest_fallback_triggers();

	// Frozen soldiers at the start
	level thread bastogne_frozen_soldiers();

	// Controlling the friendlies
	level thread friendly_ai_manager();
	
	// Misc effects
	level thread exploding_trees_update();
	level thread reverse_rock_bundles();

	// Bastogne turrets
	level thread bastogne_turret( "t_mg_turret_1", "bastogne_turret_1", 0, "s_turret_kill", "fx_expl_mg_bullet_impacts01" );
	level thread bastogne_turret( "t_mg_turret_1", "bastogne_turret_2", 0, "s_turret_kill_2", undefined );

	// Misc VO
	level thread misc_vo_thread();

	trigger::wait_till( "bastogne_complete" );

	level notify( "bastogne_complete" );

	level.reduce_german_accuracy = undefined;

	level_complete_cleanup();

	infection_util::enable_exploding_deaths( false );
	level thread skipto::objective_completed( str_objective );
}

//incase player moved into battlefield during cinematic
function force_sarah_move()
{
	t_objective_start = GetEnt( "t_sarah_bastogne_objective_0", "targetname" );

	//wait for player to trigger if close
	wait 2;
	if( isdefined( t_objective_start ) )
	{	
		trigger::use( "t_sarah_bastogne_objective_0", "targetname" );
	}
}	

//*****************************************************************************
//*****************************************************************************
function cleanup( str_objective, b_starting, b_direct, player )
{

}

//*****************************************************************************
//*****************************************************************************



function level_complete_cleanup()
{
	// Cleanup the enemy soldiers
	// There may still be AI close to the player, so kill all but the 3 closest enemy soldiers
	// - We'll handle the 3 closest separately

	a_enemy_to_keep = [];
	a_ai = GetAITeamArray( "axis" );
	if( IsDefined(a_ai) )
	{
		// The array is sorted by closest to furthest from the players
		a_sorted_ai = infection_util::ent_array_distance_from_players( a_ai );
		
		for( i=0; i<a_sorted_ai.size; i++ )
		{
			e_ent = a_sorted_ai[i];
			if( (i+7) >= a_sorted_ai.size )
			{
				a_enemy_to_keep[ a_enemy_to_keep.size ] = e_ent;
			}
			else
			{
				e_ent delete();
			}
		}
	}

// TODO: Handle this better
	// Put a 1 minute kill thread on the remaining enemy ai
	for( i=0; i<a_enemy_to_keep.size; i++ )
	{
		e_ent = a_enemy_to_keep[i];
		e_ent thread one_minute_kill();
	}

	// Cleanup the friendly squad
	a_ai = GetAITeamArray( "allies" );
    if( IsDefined(a_ai) )
	{
		for( i=0; i<a_ai.size; i++ )
		{
			if(!a_ai[i] util::is_hero())
			{		
				a_ai[i] delete();
			}	
		}
	}

	level notify( "tree_cleanup" );
}


//*****************************************************************************
//*****************************************************************************

function one_minute_kill()
{
	self endon( "death" );
	wait( 60 );
	self delete();
}


//*****************************************************************************
//*****************************************************************************

function init_anims_on_trigger( str_trigger, str_anim_group )
{
	self thread _init_anims_on_trigger( str_trigger, str_anim_group );  // don't make this blocking
}


//*****************************************************************************
//*****************************************************************************

function _init_anims_on_trigger( str_trigger, str_anim_group )
{
	trigger::wait_till( str_trigger );

	infection_util::setup_reverse_time_arrivals( str_anim_group );
}


//*****************************************************************************
//*****************************************************************************

function scene_setup()
{
	// Dialog
	scene::add_scene_func( level.str_sarah_intro, &vo_forest_messages, "play" );
	scene::add_scene_func( level.str_sarah_intro, &vo_forest_follow, "done" );

	// Fade in screen
	scene::add_scene_func( level.str_sarah_intro, &scene_callback_sarah_intro_play, "play" );

	// Why co-op only?
	scene::add_scene_func( level.str_player_intro, &scene_callback_player_intro_play, "play" );
}


//*****************************************************************************
//*****************************************************************************

function spawner_setup()
{
	infection_util::enable_exploding_deaths( true );

	spawner::add_spawn_function_group( "bastogne_tiger_tank_1_guys", "script_noteworthy", &infection_util::set_goal_on_spawn );
	spawner::add_spawn_function_group( "sm_bastogne_reinforcements", "script_noteworthy", &infection_util::set_goal_on_spawn );

	spawner::add_spawn_function_group( "sp_bastogne_battle_start", "targetname", &check_for_german_reduced_accuracy );
	spawner::add_spawn_function_group( "sp_bastogne_reinforcements_left_guys", "targetname", &check_for_german_reduced_accuracy );
	spawner::add_spawn_function_group( "sp_bastogne_reinforcements_right_guys", "targetname", &check_for_german_reduced_accuracy );
	spawner::add_spawn_function_group( "sp_bastogne_reinforcements", "targetname", &check_for_german_reduced_accuracy );
	spawner::add_spawn_function_group( "sp_bastogne_reinforcements_2", "targetname", &check_for_german_reduced_accuracy );
	spawner::add_spawn_function_group( "sp_bastogne_final_guys", "targetname", &check_for_german_reduced_accuracy );
				
	infection_util::setup_reverse_time_arrivals( "bastogne_reverse_anim" );
	init_anims_on_trigger( "init_bastogne_reverse_anims_2", "bastogne_reverse_anim_2" );
}



//*****************************************************************************
// Guys spawn in at the start, keeping the battle going if players doesn't move
//*****************************************************************************

function bastogne_battle_startup()
{
	// Start the spawner that keeps the battle going
	str_sp_manager = "sm_bastogne_battle_start";
	spawn_manager::enable( str_sp_manager );

	// Wait to turn of the spawn manager
	e_trigger = getent( "t_bastogne_battle_startup", "targetname" );
    if( IsDefined(e_trigger) )

	e_trigger waittill( "trigger" );

	if( spawn_manager::is_enabled( str_sp_manager ) )
	{
		spawn_manager::disable( str_sp_manager );
	}
}


//*****************************************************************************
// sarah Intro
//*****************************************************************************

function sarah_intro()
{
	level notify( "sarah_intro_started" );

	// Some eye candy guys as we fall to the ground
	level thread spawn_falling_intro_enemy();

	array::thread_all(level.players, &infection_util::player_enter_cinematic );

	level thread scene::play( level.str_friendly_intro );
	level thread scene::play( level.str_player_intro );
	level scene::play( level.str_sarah_intro );

	// Battle frozen until intro ended
	level thread sarah_intro_start_battle();

	trigger::use( "bastogne_intro_reverse_anims_start", "targetname", undefined, false );  // trigger under geo so only script can trigger

	//hack fix when player are teleported after a scene
	infection_util::turn_off_snow_fx_for_all_players();

	// Next scene depends on clientfield settings, so wait for them to catch up
	util::wait_network_frame();

	infection_util::turn_on_snow_fx_for_all_players();		

	array::thread_all( level.players, &infection_util::player_leave_cinematic );

	level notify( "sarah_intro_complete" );
}


//*****************************************************************************
// Spawn in some dead guys during the sarah Intro
//*****************************************************************************

function sarah_intro_start_battle()
{
	start_time = GetTime();

	intro_troops = 0;
	intro_guys = 0;

    while( 1 )
	{
		time = GetTime();
		dt = ( time - start_time ) / 1000.0;

        if( dt > 0.5 )
		{
            if( !intro_troops )
			{
				//iprintlnbold("SENDING IN THE TROOPS");
				intro_troops = 1;
				a_spawners = GetEntArray( "sp_sarah_intro_attacker", "targetname" );
				for( i=0; i<a_spawners.size; i++ )
				{
					a_spawners[i] spawner::spawn();
				}
			}
		}

		// Time to spawn in some dead guys?
		if( dt > 1 )
		{
        	if( !intro_guys )
			{
				//iprintlnbold( "INTRO GUYS" );
				level thread scene::play( "bastogne_reverse_anim_intro_1" );
				intro_guys = 1;
			}
		}

		// Time to send the squad forward and exit?
    	if( dt >= 4 )
		{
			return;
		}

		wait( 0.05 );
	}
}


//*****************************************************************************
//*****************************************************************************

function scene_callback_sarah_intro_play( a_ents )
{
	a_ents["sarah"] thread infection_util::actor_camo( 1, false );
	
	// flash white screen to cover anim starting
	util::screen_fade_in( 1, "white" );

	a_ents["sarah"]	waittill( "sarah_arrive" );
	
	a_ents["sarah"] thread infection_util::actor_camo( 0 );

	a_ents["sarah"]	waittill( "time_stop" );

	a_ents["sarah"] SetIgnorePauseWorld( true );

	level notify( "sarah_time_stop" );

	a_ents["sarah"]	waittill( "time_start" );
	level notify( "sarah_time_start" );
	//level thread scene::play( level.str_friendly_intro );
}


function scene_callback_player_intro_play( a_ents )
{
	foreach( player in level.players )
	{
//		player clientfield::increment_to_player( "pstfx_frost_up" );	
	}	
	
	level waittill( "landed_bastogne" );
	
	foreach( player in level.players )
	{
		player PlayRumbleOnEntity( "cp_infection_floor_break" );
		player ShellShock( "default", 2.5 );
		level util::set_lighting_state( 0 );
	}
	
	exploder::stop_exploder( "sgen_server_room_fall" );

	level thread scene_callback_player_intro_done();

	level waittill( "player_bastogne_intro_done" );
	
	level thread infection_util::teleport_coop_players_after_shared_cinematic();
}


function scene_callback_player_intro_done( a_ents )
{
	//waiting for the post fx to clear and so parts are partway down when world is frozen.
	wait 6.35;
	
	level thread scene::play( "p7_fxanim_cp_infection_sgen_floor_debris_bundle" );
}

//*****************************************************************************
//*****************************************************************************
// Push the enemy AI back during the forest Bastogne battle
//*****************************************************************************
//*****************************************************************************

function forest_fallback_triggers()
{
	//*******************
	// Wakamole fallbacks
	//*******************

	level thread wakamole_fallbacks();


	//*******************
	// FALLBACK trigger 1
	//*******************

	wait_for_all_players_to_enter_trigger( "info_bastogne_fallback_1" );

	level notify( "fallback1" );

	//iprintlnbold( "fallback trigger 1" );

	e_volume = GetEnt( "t_bastogne_fallback_1_volume", "targetname" );

	// Get the AI to retreat
	a_ai = GetAITeamArray( "axis" );
	for( i=0; i<a_ai.size; i++ )
	{
		a_ai[i] thread ai_fallback_to_volume( e_volume );
	}

	// Don't do the fallback behaviour anymore when more than 1 player
	a_players = GetPlayers();
 	if( a_players.size > 1 )
	{
		return;
	}


	//*******************
	// FALLBACK trigger 2
	//******************* 

	wait_for_all_players_to_enter_trigger( "info_bastogne_fallback_2" );

	//iprintlnbold( "fallback trigger 2" );

	e_volume = GetEnt( "t_bastogne_fallback_2_volume", "targetname" );

	// Get the AI to retreat
	a_ai = GetAITeamArray( "axis" );
	for( i=0; i<a_ai.size; i++ )
	{
		a_ai[i] thread ai_fallback_to_volume( e_volume );
	}

	// Stop the spawn managers used to attack the start area
	if( spawn_manager::is_enabled( "sm_bastogne_reinforcements_left" ) )
	{
		spawn_manager::disable( "sm_bastogne_reinforcements_left" );
	}
	if( spawn_manager::is_enabled( "sm_bastogne_reinforcements_right" ) )
	{
		spawn_manager::disable( "sm_bastogne_reinforcements_right" );
	}


	//*******************
	// FALLBACK trigger 3
	//*******************

// Not needed
//#if 0
//	wait_for_all_players_to_enter_trigger( "t_bastogne_fallback_3" );
//
//	iprintlnbold( "fallback trigger 3" );
//
//	e_volume = GetEnt( "t_bastogne_fallback_3_volume", "targetname" );
//
//	// Get the AI to retreat
//	a_ai = GetAITeamArray( "axis" );
//	for( i=0; i<a_ai.size; i++ )
//	{
//		a_ai[i] thread ai_fallback_to_volume( e_volume );
//	}
//#endif
}

//*****************************************************************************
//*****************************************************************************

// Warning don't thread this moer than once
function wait_for_all_players_to_enter_trigger( str_info_volume )
{
    if( IsDefined(level.players_enter_trigger) )
	{
		assertmsg( "Don't call the function: wait_for_all_players_to_enter_trigger()  multiple times" );
	}

	level.players_enter_trigger = true;

	e_info_volume = GetEnt( str_info_volume, "targetname" );
	// Wait for all 4 players to enter
  	while( 1 )
	{
		num_touching = 0;
		a_players = GetPlayers();
		for( i=0; i<a_players.size; i++ )
		{
			e_player = a_players[i];
			if( e_player IsTouching(e_info_volume) )
			{
				e_player.player_has_entered_trigger = true;
			}

        	if( IsDefined(e_player.player_has_entered_trigger) )
			{
				num_touching++;
			}
		}

   		if( num_touching >= a_players.size )
		{
			break;
		}

		wait( 0.05 );
	}

	// Cleanup
	a_players = GetPlayers();
	for( i=0; i<a_players.size; i++ )
	{
		a_players[i].player_has_entered_trigger = undefined;
	}

	level.players_enter_trigger = undefined;

	e_info_volume delete();
}


//*****************************************************************************
// self.disable_fallback: - Stops fallback behaviour
// self.script_string == "no_fallback", stops fallback behaviour
//*****************************************************************************
// self = ai
function ai_fallback_to_volume( e_volume )
{
	self endon( "death" );

	if( IsDefined(self.script_string) && (self.script_string == "no_fallback") )
	{
		return;
	}

	if( ( isdefined( self.disable_fallback ) && self.disable_fallback ) )
	{
		return;
	}

	self.goalradius = 128;
	self setgoal( e_volume );
	self waittill( "goal" );
	self.goalradius = 1024;
}


//*****************************************************************************
//*****************************************************************************

function wakamole_fallbacks()
{
	level thread wakamole_trigger_fallback( "s_fallback_wakamole_start", "vol_wakamole_start", "volume_wakamole_fallback" );
	level thread wakamole_trigger_fallback( "s_fallback_wakamole_middle", "volume_wakamole_middle", "volume_wakamole_fallback" );
	level thread wakamole_trigger_fallback( "s_fallback_wakamole_right_middle", "volume_wakamole_right_middle", "volume_wakamole_fallback" );
	level thread wakamole_trigger_fallback( "s_fallback_wakamole_end", "volume_wakamole_end", "volume_wakamole_fallback" );
}


//*****************************************************************************
//*****************************************************************************

function wakamole_trigger_fallback( str_fallback_struct, str_wakamole_volume, str_fallback_volume )
{
	// Wait for a player to run past the struct
	infection_util::wait_for_any_player_to_pass_struct( str_fallback_struct );

	//iprintlnbold( "Wakamole Fallback" );

	// Get the guys inside the volume
	e_ent_volume = getent( str_wakamole_volume, "targetname" );
	e_fallback_volume = getent( str_fallback_volume, "targetname" );

	a_ai = GetAITeamArray( "axis" );
	if( IsDefined(a_ai) )
	{
		for( i=0; i<a_ai.size; i++ )
		{
			e_ent = a_ai[i];
			if( e_ent IsTouching(e_ent_volume) )
			{
				e_ent thread ai_fallback_to_volume( e_fallback_volume );
			}
		}
	}
}


//*****************************************************************************
//*****************************************************************************
// Controling the friendlies in Bastogne
//*****************************************************************************
//*****************************************************************************

function friendly_ai_manager()
{
	sp_ent = GetEnt( "friendly_guys_bastogne_01", "targetname" );
	sp_ent spawner::add_spawn_function( &friendly_ai_spawn_function );

	sp_ent = GetEnt( "friendly_guys_bastogne_02", "targetname" );
	sp_ent spawner::add_spawn_function( &friendly_ai_spawn_function );

	sp_ent = GetEnt( "friendly_guys_bastogne_03", "targetname" );
	sp_ent spawner::add_spawn_function( &friendly_ai_spawn_function );

	sp_ent = GetEnt( "friendly_guys_bastogne_04", "targetname" );
	sp_ent spawner::add_spawn_function( &friendly_ai_spawn_function );

	sp_ent = GetEnt( "friendly_guys_bastogne_05", "targetname" );
	sp_ent spawner::add_spawn_function( &friendly_ai_spawn_function );

	sp_ent = GetEnt( "friendly_guys_bastogne_06", "targetname" );
	sp_ent spawner::add_spawn_function( &friendly_ai_spawn_function );

	sp_ent = GetEnt( "friendly_guys_bastogne_07", "targetname" );
	sp_ent spawner::add_spawn_function( &friendly_ai_spawn_function );

	sp_ent = GetEnt( "friendly_guys_bastogne_08", "targetname" );
	sp_ent spawner::add_spawn_function( &friendly_ai_spawn_function );

	if( 0 == 1 )
	{
		return;
	}

	// Force the team to the start color positions
	e_trigger = getent( "forest_color_start", "targetname" );
	e_trigger notify( "trigger" );
}


//*****************************************************************************
//*****************************************************************************

function friendly_ai_spawn_function()
{
	self.goalradius = 256;

	// In 1 player games, friendly accuracy remains high, in 4 player keep it low
	if( ( isdefined( 1 ) && 1 ) )
	{
		num_players = GetPlayers().size;
		if( num_players > 1 )
		{
			self.script_accuracy = level.bastogne_reduced_accurcy;
		}
	}

	if( 0 == 1 )
	{
		self.ignoreall = true;
		return;
	}

	self.overrideActorDamage = &callback_squad_damage;
	self thread increase_goalradius_on_color_trigger_3();
}


//*****************************************************************************
// When the AI reaches color 3, increase their goalradius
//*****************************************************************************

function increase_goalradius_on_color_trigger_3()
{
	self endon( "death" );
	e_trigger = getent( "color_trigger_3", "targetname" );
	e_trigger waittill( "trigger" );
	self.goalradius = 2048;
}


//*****************************************************************************
//*****************************************************************************

function callback_squad_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
    if( !IsDefined(level.num_friendlies_killed_in_forest) )
	{
		level.num_friendlies_killed_in_forest = 0;
	}

	// Don't allow players to kill friendlies
	if( IsDefined(eAttacker) && isplayer(eAttacker) )
	{
		iDamage = 0;
	}

	// Shoule we allow the guy to die?
	if( (self.health > 0) && (iDamage >= self.health)  )
	{
     	if( level.num_friendlies_killed_in_forest > 3 )
		{
			iDamage = self.health - 1;
		}
      	else
		{
			level.num_friendlies_killed_in_forest++;
		}
	}

	return( iDamage );
}


// ----------------------------------------------------------------------------
// DIALOG IGC: vo_forest_messages
// TODO: this will be handled in cinematic
// ----------------------------------------------------------------------------
function vo_forest_messages( a_ents )
{
	cin_sarah = a_ents["sarah"];
	if( IsDefined(cin_sarah) )
	{		
		cin_sarah SetTeam( "allies" );
	}	
/*
	wait 3;
	level dialog::player_say( "plyr_sarah_can_you_hea_0", 1.0 );

	level.players[0] dialog::say( "hall_i_know_what_this_is_0", 1.0 );
	level.players[0] dialog::say( "hall_this_is_bastogne_0", 1.0 );
	level.players[0] dialog::say( "hall_the_kind_of_battle_t_0", 1.0 );
	level.players[0] dialog::say( "hall_i_used_to_dream_abou_0", 0.0 );
*/
}


// ----------------------------------------------------------------------------
// DIALOG: vo forest objective
// ----------------------------------------------------------------------------
function vo_forest_follow( a_ents )
{
	//wait for sarah to take off a bit.
	wait 1;
	ai_objective_sarah = GetEnt( "sarah_ai", "targetname" );
	if( isdefined( ai_objective_sarah ) )
	{	
		ai_objective_sarah	thread dialog::say( "hall_follow_me_i_ll_sh_0", 0.0 ); //Follow me... I’ll show you what I mean.
	}
}

//*****************************************************************************
//*****************************************************************************
// Random mortar explosion effects
//*****************************************************************************
//*****************************************************************************

function intro_only_random_mortar_explosions()
{
	clientfield::set( "forest_mortar_index", 1 );

	level waittill( "sarah_time_stop" );

	foreach( player in level.players )
	{
		player SetIgnorePauseWorld( true );
	}

	SetPauseWorld( true );

	level waittill( "sarah_time_start" );
	//clientfield::set( "forest_mortar_index", 1 );

	SetPauseWorld( false );

	level waittill( "sarah_intro_complete" );
	level thread random_mortar_explosions();
}	


//*****************************************************************************
//*****************************************************************************

function random_mortar_explosions()
{
	clientfield::set( "forest_mortar_index", 2 );
	//iprintlnbold( "MOVING TO MORTAR 2" );

	e_trigger = GetEnt( "t_background_mortar_3", "targetname" );
	e_trigger waittill( "trigger" );
	clientfield::set( "forest_mortar_index", 3 );
	//iprintlnbold( "MOVING TO MORTAR 3" );

	e_trigger = GetEnt( "t_background_mortar_4", "targetname" );
	e_trigger waittill( "trigger" );
	clientfield::set( "forest_mortar_index", 4 );
	//iprintlnbold( "MOVING TO MORTAR 4" );

	// On the up slope

	e_trigger = GetEnt( "t_background_mortar_5", "targetname" );
	e_trigger waittill( "trigger" );
	clientfield::set( "forest_mortar_index", 5 );
	//iprintlnbold( "MOVING TO MORTAR 5" );

	e_trigger = GetEnt( "t_background_mortar_6", "targetname" );
	e_trigger waittill( "trigger" );
	clientfield::set( "forest_mortar_index", 6 );
	//iprintlnbold( "MOVING TO MORTAR 6" );
}


//*****************************************************************************
//*****************************************************************************

function spawn_falling_intro_enemy()
{
	a_ents = getentarray( "sp_falling_intro_enemy", "targetname" );
	for( i=0; i<a_ents.size; i++ )
	{
		e_ent = a_ents[i] spawner::spawn();
		e_ent thread falling_intro_enemy_update();
	}

	// Wait for the players to hit the ground
	wait( 3 );
	kill_falling_intro_enemy();
}

function kill_falling_intro_enemy()
{
	a_ents = getentarray( "sp_falling_intro_enemy_ai", "targetname" );
	for( i=0; i<a_ents.size; i++ )
	{
		a_ents[i] delete();
	}
}

function falling_intro_enemy_update()
{
	self endon( "death" );
	self.goalradius = 64;
	self.ignorall = true;

	//TODO: will be replaced with a freeze once online.
	level waittill( "sarah_time_stop" );
	//self dodamage(self.health + 100, self.origin);
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

	// 2000
	// 1

function intro_only_falling_debris_from_sgen()
{
	level waittill( "sarah_intro_started" );

	// Big debris pieces that fall during the intro
	level thread falling_big_piece( "bastogne_large_falling_piece_6", 4 );
	level thread falling_big_piece( "bastogne_large_falling_piece_2", 10 );

	level waittill( "sarah_time_start" );
	level thread falling_debris_from_sgen();

}	

function falling_debris_from_sgen()
{
	// Ordered by closest to start position
	initial_delay = 2;
	level thread falling_big_piece( "bastogne_large_falling_piece_2", initial_delay+2 );		// 2
	level thread falling_big_piece( "bastogne_large_falling_piece_4", initial_delay+5 );		// 5
	level thread falling_big_piece( "bastogne_large_falling_piece_3", initial_delay+6 );		// 7
	level thread falling_big_piece( "bastogne_large_falling_piece_6", initial_delay+10 );		// 11
	level thread falling_big_piece( "bastogne_large_falling_piece_1", initial_delay+13 );		// 16
	level thread falling_big_piece( "bastogne_large_falling_piece_5", initial_delay+16 );		// 22

//	wait( 2 );
//iprintlnbold( "starting debris" );

	// Start the falling debris field
	clientfield::set( "forest_sgen_falling_debris_1", 1 );

	// Leave it running foe a while
	wait( 50 );
	clientfield::set( "forest_sgen_falling_debris_1", 0 );
}


//*****************************************************************************
//*****************************************************************************

function falling_big_piece( struct_name, fall_delay )
{
	s_struct = struct::get( struct_name, "targetname" );

	// Get all the large falling debris pieces
	a_debris = getentarray( "bastogne_large_debris", "targetname" );

	closest_dist = 999999.9;
	e_closest = a_debris[0];
	for( i=0; i<a_debris.size; i++ )
	{
		dist = distance( s_struct.origin, a_debris[i].origin );
        if( dist < closest_dist )
		{
			closest_dist = dist;
			e_closest = a_debris[i];
		}
	}

	// Move the piece into the sky
	v_offset = ( 0, 0, 2000 );
	e_closest moveto( e_closest.origin + v_offset, 0.05 );

	e_closest hide();

	// Wait to fall
	wait( fall_delay );

	e_closest show();

	e_closest playsound ("evt_metal_incoming");

	// Trigger the piece to fall
	e_closest moveto( e_closest.origin - v_offset, 1 );
	wait( 1 );

	quake_size = 0.50;							// 0.55
	quake_time = randomFloatRange( 1.0, 1.2 );	// 1.0, 1.5
	quake_radius = 3000;						// 2000
	earthquake( quake_size, quake_time, e_closest.origin, quake_radius );
	e_closest playsound ("evt_metal_impact");
}


//*****************************************************************************
//*****************************************************************************
// DEBUG STUFF
//*****************************************************************************
//*****************************************************************************

function debug_ai_counts()
{
    while( 1 )
	{
		data = spawnstruct();

        while( 1 )
		{
			x_text = 200;
			y_text = 80;

			data.ai_types = [];
			data.ai_counts = [];
			data.hud = [];

			e_player = GetPlayers()[0];

			a_ai = GetAITeamArray( "axis" );
			for( i=0; i<a_ai.size; i++ )
			{
				found = 0;
				e_ent = a_ai[i];
                if( IsDefined(e_ent.targetname) )
				{
					for( j=0; j<data.ai_types.size; j++ )
					{
						if( data.ai_types[j] == e_ent.targetname )
						{
							data.ai_counts[j]++;
							found = 1;
							break;
						}
					}
				}

				// Add a new AI type
				if( !found && IsDefined(e_ent.targetname) )
				{
					data.ai_types[ data.ai_types.size ] = e_ent.targetname;
					data.ai_counts[ data.ai_counts.size ] = 1;
					hud_elem = infection_util::CreateClientHudText( e_player, "", x_text, y_text, 1.0 );

      				if (IsSubStr(e_ent.targetname, "anim_"))
					{
						hud_elem.color = (0,1,0);
					}
               		else if (IsSubStr(e_ent.targetname, "sm_"))
					{
						hud_elem.color = (1,0,0);
					}

					data.hud[ data.hud.size ] = hud_elem;

					y_text += 12;
				}
			}

			// Print out the ai counts

			for( i=0; i<data.ai_types.size; i++ )
			{
				hud_elem = data.hud[i];
				str_text = data.ai_types[i] + ":  " + data.ai_counts[i];
				hud_elem SetText( str_text );
			}

			wait( 0.1 );

			for( i=0; i<data.hud.size; i++ )
			{
				data.hud[i] destroy();
			}
		}

		wait( 0.05 );
	}
}


//*****************************************************************************
//*****************************************************************************

function exploding_trees_init()
{
	level.a_reverse_trees = [];
	level.a_reverse_trees[level.a_reverse_trees.size] = "fxanim_tree_break01";
	level.a_reverse_trees[level.a_reverse_trees.size] = "fxanim_tree_break02";
	level.a_reverse_trees[level.a_reverse_trees.size] = "fxanim_tree_break03";
	level.a_reverse_trees[level.a_reverse_trees.size] = "fxanim_tree_break04";
	level.a_reverse_trees[level.a_reverse_trees.size] = "fxanim_tree_break05";
	level.a_reverse_trees[level.a_reverse_trees.size] = "fxanim_tree_break06";
	level.a_reverse_trees[level.a_reverse_trees.size] = "fxanim_tree_break07";

	for( i=0; i<level.a_reverse_trees.size; i++ )
	{
		level thread scene::init( level.a_reverse_trees[i], "targetname" );
	}

	level.exploding_trees_initialized = 1;
}


//*****************************************************************************
//*****************************************************************************

function exploding_trees_update()
{
	if( !IsDefined(level.exploding_trees_initialized) )
	{
		exploding_trees_init();
	}

	for( i=0; i<level.a_reverse_trees.size; i++ )
	{
		level thread reverse_tree( level.a_reverse_trees[i], 2000 );
	}

	// Wait for the cleanup notify

	level waittill( "tree_cleanup" );

// TODO: Cleanup utriggered trees
//#if 0
//	for( i=0; i<level.a_reverse_trees.size; i++ )
//	{
//		if( (level scene::is_playing(level.a_reverse_trees[i])) )
//		{
//			level scene::stop( level.a_reverse_trees[i] );
//		}
//	}
//#endif
}


//*****************************************************************************
//*****************************************************************************

function reverse_tree( str_targetname, trigger_radius )
{
	level endon( "tree_cleanup" );
	
	s_tree = struct::get( str_targetname, "targetname" );
	while( 1 )
	{
		dist = infection_util::player_distance( s_tree.origin );
		if( dist < trigger_radius )
		{
			break;
		}
		wait( 0.1 );
	}

	level thread scene::play( str_targetname, "targetname" );
}



//*****************************************************************************
//*****************************************************************************
// wakamole - ww2 style guys
//*****************************************************************************
//*****************************************************************************

function wakamole_guys()
{
	// Some guys as we startup
	a_ents = getentarray( "sp_wakamole_start", "targetname" );
	for( i=0; i<a_ents.size; i++ )
	{
		e_ent = a_ents[i] spawner::spawn();		
		e_ent thread ai_wakamole( 64, false );
	}

	// Wait to bring in more guys
	e_trigger = getent( "bastogne_intro_mortar_group_2", "targetname" );
	if( IsDefined(e_trigger) )
	{
		e_trigger waittill( "trigger" );
	}

	// More wakamole guys in the Bastogne open fight
	a_ents = getentarray( "sp_bastogne_ww2_mg_wakamole", "targetname" );
	for( i=0; i<a_ents.size; i++ )
	{
		e_ent = a_ents[i] spawner::spawn();		
		e_ent thread ai_wakamole( 64, false );
	}
}

// self = ai
function ai_wakamole( end_goal_radius, disable_fallback )
{
	self endon( "death" );
	
	self check_for_german_reduced_accuracy();

	if( disable_fallback )
	{
		self.disable_fallback = true;
	}

	self.goalradius = 64;
	self waittill( "goal" );
	self.goalradius = end_goal_radius;
}


//*****************************************************************************
//*****************************************************************************

function bastogne_hill_running_group()
{
	level endon( "bastogne_complete" );

	e_trigger = getent( "t_bastogne_hill_running_group", "targetname" );
	e_trigger waittill( "trigger" );

	//iprintlnbold( "BASTOGNE Hill Running Group" );

	a_ents = getentarray( "sp_bastogne_hill_running_group", "targetname" );
	for( i=0; i<a_ents.size; i++ )
	{
		e_ent = a_ents[i] spawner::spawn();
		e_ent thread ai_wakamole( 512, false );
		wait( 0.7 );
	}
}


//*****************************************************************************
//*****************************************************************************

function bastogne_right_side_runners()
{
	level endon( "bastogne_complete" );

	e_trigger = getent( "t_bastogne_right_side_runners", "targetname" );
	e_trigger waittill( "trigger" );

	//iprintlnbold( "BASTOGNE Right Side Runners" );

	a_ents = getentarray( "sp_bastogne_right_side_runners", "targetname" );
	for( i=0; i<a_ents.size; i++ )
	{
		e_ent = a_ents[i] spawner::spawn();
		e_ent thread ai_wakamole( 512, true );
	}
}


//*****************************************************************************
//*****************************************************************************

function bastogne_right_side_wave2()
{
	level endon( "bastogne_complete" );

	e_trigger = getent( "t_bastogne_right_side_wave2", "targetname" );
	e_trigger waittill( "trigger" );

	//iprintlnbold( "BASTOGNE Right Side Wave2" );

	a_ents = getentarray( "sp_bastogne_right_side_wave2", "targetname" );
	for( i=0; i<a_ents.size; i++ )
	{
		e_ent = a_ents[i] spawner::spawn();
		e_ent thread ai_wakamole( 512, false );
	}
}


//*****************************************************************************
//*****************************************************************************

function bastogne_2nd_hill_rienforcements( str_trigger, str_spawners )
{
	e_trigger = getent( str_trigger, "targetname" );
	e_trigger waittill( "trigger" );

	//iprintlnbold( "2ND HILL RIENFORCEMENTS" );
	
	a_ents = getentarray( str_spawners, "targetname" );
	for( i=0; i<a_ents.size; i++ )
	{
		e_ent = a_ents[i] spawner::spawn();
		delay = randomfloatrange( 0.75, 1.2 );
		wait( delay );
		e_ent thread ai_wakamole( 512, false );
	}
}


//*****************************************************************************
// Spawn Manager at the very end of Bastogne
//*****************************************************************************

function bastogne_final_guys()
{
	e_trigger = getent( "t_2nd_hill_rienforcements", "targetname" );
	e_trigger waittill( "trigger" );
	spawn_manager::enable( "sm_bastogne_final_guys" );

	// Wait for a player to run past the struct, then kill the spawner
	infection_util::wait_for_any_player_to_pass_struct( "s_turret_kill_2" );
	if( spawn_manager::is_enabled("sm_bastogne_final_guys") )
	{
		spawn_manager::disable( "sm_bastogne_final_guys" );
	}
}


//*****************************************************************************
//*****************************************************************************

function sniper_guys_on_rocks()
{
	level waittill( "fallback1" );

	a_spawners = GetEntArray( "sp_bastogne_rocks_sniper", "targetname" );
	for( i=0; i<a_spawners.size; i++ )
	{
		e_ent = a_spawners[i] spawner::spawn();
		wait( 3 );
	}

	infection_util::infection_battle_chatter( "sniper_infection" );
}


//*****************************************************************************
//*****************************************************************************

function high_ground_rpg()
{
	level waittill( "fallback1" );

	a_spawners = GetEntArray( "sp_bastogne_high_ground_rpg", "targetname" );
	for( i=0; i<a_spawners.size; i++ )
	{
		e_ent = a_spawners[i] spawner::spawn();
		e_ent thread ai_wakamole( 64, true );
	}

	infection_util::infection_battle_chatter( "rpg_ridge" );
}


//*****************************************************************************
//*****************************************************************************

function bastogne_left_side_rocks_fallback()
{
	e_trigger = getent( "t_left_side_rocks_fallback", "targetname" );
	if( IsDefined(e_trigger) )
	{
		e_trigger waittill( "trigger" );

		a_spawners = GetEntArray( "sp_left_side_rocks_fallback", "targetname" );
		for( i=0; i<a_spawners.size; i++ )
		{
			e_ent = a_spawners[i] spawner::spawn();
			e_ent thread ai_wakamole( 512, true );
			wait( 0.75 );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

// self = ai
function check_for_german_reduced_accuracy()
{
	if( ( isdefined( level.reduce_german_accuracy ) && level.reduce_german_accuracy ) )
	{
		self.script_accuracy = level.bastogne_reduced_accurcy;
	}
}


//*****************************************************************************
//*****************************************************************************
// Reverse Rock Animations
//*****************************************************************************
//*****************************************************************************

function reverse_rock_bundles()
{
	scene::init( "p7_fxanim_cp_infection_reverse_rocks_01_bundle" );
	scene::init( "p7_fxanim_cp_infection_reverse_rocks_02_bundle" );

	e_trigger = getent( "t_reverse_rocks_01_bundle", "targetname" );
	e_trigger waittill( "trigger" );

	// The truck
	level thread scene::play( "p7_fxanim_cp_infection_reverse_rocks_02_bundle" );

	// The big rock
	wait( 5 );
	level thread scene::play( "p7_fxanim_cp_infection_reverse_rocks_01_bundle" );
}


//*****************************************************************************
//*****************************************************************************
// TURRETS
//*****************************************************************************
//*****************************************************************************

function bastogne_turret( str_trigger, str_turret_name, use_scripted_gunners, str_kill_struct, str_exploder_introduction )
{
	// Wait to spawn the turret
	e_trigger = getent( str_trigger, "targetname" );
	e_trigger waittill( "trigger" );
	
	// Create the turret
	e_turret = vehicle::simple_spawn_single( str_turret_name );

	// Setup turret firing parameters
	const FIRE_TIME_MIN = 0.75;			// 0.6
	const FIRE_TIME_MAX = 1.5;			// 1.1
	const BURST_WAIT_MIN = 0.25;		// 1.0
	const BURST_WAIT_MAX = 0.75;		// 2.0
	e_turret.turret_index = 1;
	e_turret turret::set_burst_parameters( FIRE_TIME_MIN, FIRE_TIME_MAX, BURST_WAIT_MIN, BURST_WAIT_MAX, e_turret.turret_index );

	e_turret turret::enable( 1 );

	if( use_scripted_gunners )
	{
		e_turret thread bastogne_update_turret();
	}
	else
	{
		e_turret turret::enable_auto_use( true );
	}

	// Do we want to introduce the turret with an exploder effect?
	e_turret thread turret_exploder_effect();

	// Wait for a player to run past the struct
	if( IsDefined(str_kill_struct) )
	{
		infection_util::wait_for_any_player_to_pass_struct( str_kill_struct );
		//iprintlnbold( "KILLING THE TURRET" );
		e_turret turret::enable_auto_use( false );
	}
}


//**********************************************************************************
// Wait until the player is in position and looking at the turret to play the effect
//**********************************************************************************

// self = turret
function turret_exploder_effect()
{
	e_volume = GetEnt( "volume_turret_introduction", "targetname" );

	while( 1 )
	{
		// Does the turret have a user?
		b_has_user = turret::does_have_user( self.turret_index );

		if( b_has_user )
		{
			// Is a player in the effect trigger volume?
			a_players = getplayers();
			for( i=0; i<a_players.size; i++ )
			{
				e_player = a_players[i];

				if( e_player IsTouching(e_volume) )
				{
					// Is a player looking at the turret?
					v_dir = vectornormalize( self.origin - e_player.origin );
					v_forward = AnglesToForward( e_player.angles );
					dp = VectorDot( v_dir, v_forward );
					if( dp > 0.95 )
					{
						//iprintlnbold( "ABOUT TO TRIGGER THE TURRET FIRING" );
						//wait( 2 );

						// Play the effect and trigger the VO
						exploder::exploder( "fx_expl_mg_bullet_impacts01" );
						return;
					}
				}
			}
		}

		wait( 0.05 );
	}
}


//*****************************************************************************
//*****************************************************************************

// self = turret
function bastogne_update_turret()
{
	level endon( "bastogne_complete" );

	e_gunner = undefined;

	turret_mode = "looking_for_gunner";

	while( 1 )
	{
		switch( turret_mode )
		{
			case "looking_for_gunner":
				e_gunner = bastogne_turret_get_gunner();
				turret_mode = "gunner_running_to_turret";
			break;

			case "gunner_running_to_turret":
				alive= self bastogne_turret_gunner_running_to_turret( e_gunner );
				if( alive )
				{
					turret_mode = "gunner_manning_turret";
				}
				else
				{
					turret_mode = "looking_for_gunner";
				}
			break;

			case "gunner_manning_turret":
				self bastogne_turret_gunner_firing( e_gunner );
				turret_mode = "looking_for_gunner";
			break;
		}

		wait( 0.05 );
	}
}


//*****************************************************************************
//*****************************************************************************

// self = turret
function bastogne_turret_get_gunner()
{
	e_closest = undefined;

	while( 1 )
	{
		a_ai = GetAITeamArray( "axis" );

		closest_dist = 99999.9;
		if( IsDefined(a_ai) )
		{
			for( i=0; i<a_ai.size; i++ )
			{
				dist = distance( a_ai[i].origin, self.origin );
				if( (dist < 2500) && (dist < closest_dist) )
				{
					closest_dist = dist;
					e_closest = a_ai[i];
				}
			}
		}

		if( IsDefined(e_closest) )
		{
			break;
		}

		wait( 0.5 );
	}

	return( e_closest );
}


//*****************************************************************************
//*****************************************************************************

// self = turret
function bastogne_turret_gunner_running_to_turret( e_gunner )
{
	// Wait for the gunner to get to the turret or be killed on the way
	self.gunner_ready = undefined;
	e_gunner thread gunner_run_to_goal( self );

	while( 1 )
	{
		if( !IsAlive( e_gunner) )
		{
			return( 0 );
		}

		if( IsDefined(self.gunner_ready) )
		{
			break;
		}

		wait( 0.05 );
	}

	// Put the gunner on the turret
	self turret::enable( 1 , true );
	e_gunner vehicle::get_in( self, "gunner1", true );
	
	return( 1 );
}

// self = gunner
function gunner_run_to_goal( e_turret )
{
	self endon( "death" );

	self.goalradius = 64;
	self setgoal( e_turret.origin );
	self waittill( "goal" );

	e_turret.gunner_ready = 1;
}


//*****************************************************************************
//*****************************************************************************

// self = turret
function bastogne_turret_gunner_firing( e_gunner )
{
	while( IsAlive(e_gunner) )
	{
		wait( 0.01 );
	}
	
	self turret::disable( 1 );
	self.gunner_ready = undefined;
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

function misc_vo_thread()
{
	// Right at the start of Bastogne
	wait( 1 );
	infection_util::infection_battle_chatter( "bastogne_intro" );

	// "multiple_routes"
	e_trigger = getent( "t_vo_multiple_routes", "targetname" );
	e_trigger waittill( "trigger" );
	infection_util::infection_battle_chatter( "multiple_routes" );

	// "regroup_halftracks"
	e_trigger = getent( "t_vo_regroup_halftracks", "targetname" );
	e_trigger waittill( "trigger" );
	infection_util::infection_battle_chatter( "regroup_halftracks" );
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

function bastogne_frozen_soldiers()
{
	if( IsDefined(level.frozen_soldiers) )
	{
		return;
	}

	level.frozen_soldiers = true;

	level thread scene::play( "bastogne_frozen_soldier" );

	// Wait for the players to pass this struct, then remove the dead soldies
	infection_util::wait_for_all_players_to_pass_struct( "s_fallback_wakamole_middle" );

	level thread scene::stop( "bastogne_frozen_soldier" );
}
