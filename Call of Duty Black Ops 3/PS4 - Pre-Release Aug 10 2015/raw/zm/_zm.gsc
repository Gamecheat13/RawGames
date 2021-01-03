#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\ai_puppeteer_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\gametypes\_globallogic_vehicle;
#using scripts\zm\_bb;

#using scripts\shared\ai\systems\gib;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                       	     	                                                                                   
                                                                                                             	     	                                                                                                                                                                

#using scripts\zm\gametypes\_weapons;
#using scripts\zm\gametypes\_zm_gametype;
#using scripts\zm\gametypes\_globallogic_spawn;

#using scripts\zm\_util;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_bgb_token;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_bot;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_ffotd;
#using scripts\zm\_zm_game_module;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_player;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\shared\ai_shared;

// AATs
#using scripts\zm\aats\_zm_aat_blast_furnace;
#using scripts\zm\aats\_zm_aat_dead_wire;
#using scripts\zm\aats\_zm_aat_thunder_wall;
#using scripts\zm\aats\_zm_aat_turned;

// BGBs
#using scripts\zm\bgbs\_zm_bgb_aftertaste;
#using scripts\zm\bgbs\_zm_bgb_alchemical_antithesis;
#using scripts\zm\bgbs\_zm_bgb_always_done_swiftly;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\bgbs\_zm_bgb_armamental_accomplishment;
#using scripts\zm\bgbs\_zm_bgb_arms_grace;
#using scripts\zm\bgbs\_zm_bgb_arsenal_accelerator;
#using scripts\zm\bgbs\_zm_bgb_burned_out;
#using scripts\zm\bgbs\_zm_bgb_cache_back;
#using scripts\zm\bgbs\_zm_bgb_coagulant;
#using scripts\zm\bgbs\_zm_bgb_danger_closest;
#using scripts\zm\bgbs\_zm_bgb_dead_of_nuclear_winter;
#using scripts\zm\bgbs\_zm_bgb_ephemeral_enhancement;
#using scripts\zm\bgbs\_zm_bgb_firing_on_all_cylinders;
#using scripts\zm\bgbs\_zm_bgb_im_feelin_lucky;
#using scripts\zm\bgbs\_zm_bgb_immolation_liquidation;
#using scripts\zm\bgbs\_zm_bgb_impatient;
#using scripts\zm\bgbs\_zm_bgb_in_plain_sight;
#using scripts\zm\bgbs\_zm_bgb_kill_joy;
#using scripts\zm\bgbs\_zm_bgb_killing_time;
#using scripts\zm\bgbs\_zm_bgb_licensed_contractor;
#using scripts\zm\bgbs\_zm_bgb_lucky_crit;
#using scripts\zm\bgbs\_zm_bgb_now_you_see_me;
#using scripts\zm\bgbs\_zm_bgb_on_the_house;
#using scripts\zm\bgbs\_zm_bgb_one_for_the_road;
#using scripts\zm\bgbs\_zm_bgb_perkaholic;
#using scripts\zm\bgbs\_zm_bgb_phoenix_up;
#using scripts\zm\bgbs\_zm_bgb_pop_shocks;
#using scripts\zm\bgbs\_zm_bgb_private_eyes;
#using scripts\zm\bgbs\_zm_bgb_respin_cycle;
#using scripts\zm\bgbs\_zm_bgb_stock_option;
#using scripts\zm\bgbs\_zm_bgb_sword_flay;
#using scripts\zm\bgbs\_zm_bgb_wall_power;
#using scripts\zm\bgbs\_zm_bgb_whos_keeping_score;


#using scripts\zm\craftables\_zm_craftables;

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;

                                                                                                           	                                     	                	                       	            	                                                                                                                                                                                                                              
                                                                                       	                                
       

#precache( "material", "hud_chalk_1" );
#precache( "material", "hud_chalk_2" );
#precache( "material", "hud_chalk_3" );
#precache( "material", "hud_chalk_4" );
#precache( "material", "hud_chalk_5" );

#precache( "material", "zom_icon_community_pot" );
#precache( "material", "zom_icon_community_pot_strip" );

#precache( "material","zom_icon_player_life");

#precache( "string", "ZOMBIE_WEAPONCOSTAMMO" );
#precache( "string", "ZOMBIE_ROUND" );
#precache( "string", "SCRIPT_PLUS" );
#precache( "string", "ZOMBIE_GAME_OVER" );
#precache( "string", "ZOMBIE_SURVIVED_ROUND" );
#precache( "string", "ZOMBIE_SURVIVED_ROUNDS" );
#precache( "string", "ZOMBIE_SURVIVED_NOMANS" );
#precache( "string", "ZOMBIE_EXTRA_LIFE" );
#precache( "string", "ZOMBIE_UNDEFINED" );
// Random Treasure Chest
#precache( "string", "ZOMBIE_RANDOM_WEAPON_COST" );
#precache( "string", "ZOMBIE_RANDOM_WEAPON_950" ); // T7TODO - this can be deleted
// Barrier Pieces
#precache( "string", "ZOMBIE_BUTTON_BUY_BACK_BARRIER_10" );
#precache( "string", "ZOMBIE_BUTTON_BUY_BACK_BARRIER_20" );
#precache( "string", "ZOMBIE_BUTTON_BUY_BACK_BARRIER_50" );
#precache( "string", "ZOMBIE_BUTTON_BUY_BACK_BARRIER_100" );
// REWARD Barrier Pieces
#precache( "string", "ZOMBIE_BUTTON_REWARD_BARRIER" );
#precache( "string", "ZOMBIE_BUTTON_REWARD_BARRIER_10" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_REWARD_BARRIER_20" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_REWARD_BARRIER_30" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_REWARD_BARRIER_40" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_REWARD_BARRIER_50" ); // T7TODO - this can be deleted
// Debris
#precache( "string", "ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_COST" );
#precache( "string", "ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_100" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_200" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_250" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_500" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_750" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1000" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1250" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1500" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1750" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_2000" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_3000" ); // T7TODO - this can be deleted
// Doors
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_COST" );
#precache( "string", "ZOMBIE_BUTTON_BUY_CLOSE_DOOR" );
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_100" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_200" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_250" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_500" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_750" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_1000" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_1250" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_1500" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_1750" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_2000" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_2500" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_3000" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_4000" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_8000" ); // T7TODO - this can be deleted
#precache( "string", "ZOMBIE_BUTTON_BUY_OPEN_DOOR_16000" ); // T7TODO - this can be deleted

#precache( "fx", "_t6/maps/zombie/fx_zombie_bar_break" );
#precache( "fx", "_t6/maps/zombie/fx_zombie_bar_break_lite" );
#precache( "fx", "_t6/maps/zombie/fx_fog_zombie_amb" );
#precache( "fx", "zombie/fx_weapon_box_open_glow_zmb" );
#precache( "fx", "zombie/fx_weapon_box_closed_glow_zmb" );
#precache( "fx", "zombie/fx_glow_eye_orange" );
#precache( "fx", "zombie/fx_bul_flesh_head_fatal_zmb" );
#precache( "fx", "zombie/fx_bul_flesh_head_nochunks_zmb" );
#precache( "fx", "zombie/fx_bul_flesh_neck_spurt_zmb" );
#precache( "fx", "_t6/maps/zombie/fx_zombie_tesla_neck_spurt" );
#precache( "fx", "zombie/fx_blood_torso_explo_zmb" );
#precache( "fx", "zombie/fx_blood_torso_explo_lg_zmb" );
#precache( "fx", "zombie/fx_spawn_dirt_hand_burst_zmb" );
#precache( "fx", "zombie/fx_spawn_dirt_body_billowing_zmb" );
#precache( "fx", "zombie/fx_spawn_dirt_body_dustfalling_zmb" );	
#precache( "fx", "zombie/fx_fire_torso_zmb" );
#precache( "fx", "_t6/explosions/fx_default_explosion" );
#precache( "fx", "zombie/fx_wallbuy_xr2_zmb" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_wall_buy_berreta93r" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_wall_buy_bowie" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_wall_buy_claymore" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_wall_buy_m14" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_wall_buy_m16" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_wall_buy_mp5k" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_wall_buy_olympia" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_wall_buy_semtex" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_wall_buy_taseknuck" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_wall_buy_question" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_tanzit_upgrade" );

#namespace zm;

function autoexec __init__sytem__() {     system::register("zm",&__init__,undefined,undefined);    }
	
function __init__()
{
	level.zombie_vars = [];	
}

function init()
{
	
	//New movement disabled for Zombies
	SetDvar( "doublejump_enabled", 0 );
	SetDvar( "juke_enabled", 0 );
	SetDvar( "playerEnergy_enabled", 0 );
	SetDvar( "wallrun_enabled", 0 );
	SetDvar( "sprintLeap_enabled", 0 );
	SetDvar( "traverse_mode", 2 );
	SetDvar( "weaponrest_enabled", 0 );

	if ( !IsDefined( level.killstreakWeapons ) )
	{
		level.killstreakWeapons = [];
	}

	level.weaponNone = GetWeapon( "none" );
	level.weaponNull = GetWeapon( "weapon_null" );
	level.weaponBaseMelee = GetWeapon( "knife" );
	level.weaponBaseMeleeHeld = GetWeapon( "knife_held" );
	level.weaponBallisticKnife = GetWeapon( "knife_ballistic" );
	if(!isdefined(level.weaponRiotshield))level.weaponRiotshield=GetWeapon( "riotshield" );
	level.weaponReviveTool = GetWeapon( "syrette" );
	level.weaponZMDeathThroe = GetWeapon( "death_throe" );
	level.weaponZMFists = GetWeapon( "zombie_fists" );

	level.player_out_of_playable_area_monitor = true;	
	level.player_too_many_weapons_monitor = true;
	level.player_too_many_weapons_monitor_func = &player_too_many_weapons_monitor;

	level.player_too_many_players_check = true;
	level.player_too_many_players_check_func = &player_too_many_players_check;
	
	level._use_choke_weapon_hints = 1;
	level._use_choke_blockers = 1;
	
	level.passed_introscreen = false;
		
	if(!isdefined(level.custom_ai_type))
	{
		level.custom_ai_type = [];
	}
	
	level.custom_ai_spawn_check_funcs = [];

	// put things you'd like to be able to turn off in here above this line
	level thread zm_ffotd::main_start();
	
	level.zombiemode = true;
	level.reviveFeature = false;
	level.swimmingFeature = false;
	level.calc_closest_player_using_paths = false;
	level.zombie_melee_in_water = true;
	level.put_timed_out_zombies_back_in_queue = true;
	level.use_alternate_poi_positioning = true;
	level.zmb_laugh_alias = "zmb_laugh_child";
	level.sndAnnouncerIsRich = true;

	level.scr_zm_ui_gametype = GetDvarString( "ui_gametype" );
	level.scr_zm_ui_gametype_group = GetDvarString( "ui_zm_gamemodegroup" );
	level.scr_zm_map_start_location = GetDvarString( "ui_zm_mapstartlocation" );

	level.curr_gametype_affects_rank = false;
	gametype = toLower( GetDvarString( "g_gametype" ) );
	if ( "zclassic" == gametype || "zstandard" == gametype )
	{
		level.curr_gametype_affects_rank = true;
	}

	level.grenade_multiattack_bookmark_count = 1;
	demo::initActorBookmarkParams( 3, 6000, 6000 );
		
	// set up any gameplay modes
/*	level.GAME_MODULE_CLASSIC_INDEX = 0;
	zm_game_module::register_game_module(level.GAME_MODULE_CLASSIC_INDEX,"classic",undefined,undefined);	
	zm_game_module::set_current_game_module(level.scr_zm_game_module); */
	
	// Allowing custom round_spawn_failsafe function to be set here.
	if(	!isdefined(	level._zombies_round_spawn_failsafe	)	)
	{
		level._zombies_round_spawn_failsafe = &zombie_utility::round_spawn_failsafe;
	}

	level.func_get_zombie_spawn_delay = &get_zombie_spawn_delay;
	level.func_get_delay_between_rounds = &get_delay_between_rounds;

	level.zombie_visionset = "zombie_neutral";

	if(GetDvarString("anim_intro") == "1")
	{
		level.zombie_anim_intro = 1;
	}
	else
	{
		level.zombie_anim_intro = 0;
	}

	precache_models();
	
	precache_zombie_leaderboards();

	level._ZOMBIE_GIB_PIECE_INDEX_ALL = 0;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM = 1;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM = 2;
	level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG = 3;
	level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG = 4;
	level._ZOMBIE_GIB_PIECE_INDEX_HEAD = 5;
	level._ZOMBIE_GIB_PIECE_INDEX_GUTS = 6;
	level._ZOMBIE_GIB_PIECE_INDEX_HAT = 7;

	//Limit zombie to 24 max, must have for network purposes
	if ( !isdefined( level.zombie_ai_limit ) )
	{
		level.zombie_ai_limit = 24;
	}	
	if ( !isdefined( level.zombie_actor_limit ) )
	{
		level.zombie_actor_limit = 31;
	}
	
	init_flags();
	init_dvars();
	init_strings();
	init_levelvars();
	init_sounds();
	init_shellshocks();
	init_client_field_callback_funcs();
	
	zm_utility::register_offhand_weapons_for_level_defaults();

	level thread drive_client_connected_notifies();
	
	// load map defaults

	//Systems
	zm_craftables::init();	
	zm_perks::init();
	zm_powerups::init();
	zm_spawner::init();
	zm_weapons::init();
	zm_ai_dogs::init();
	
	//Grab all static poi in the map
	level.zombie_poi_array = getEntArray( "zombie_poi", "script_noteworthy" );

	
	init_function_overrides();
	
	// ww: init the pistols in the game so last stand has the importance order
	level thread last_stand_pistol_rank_init();
	
	level thread post_all_players_connected();
	
	zm_utility::init_utility();

	util::registerClientSys( "lsm" );

	// STATS_TODO: will check if the following is needed later
	initializeStatTracking();	
	
	if ( GetPlayers().size <= 1 )
	{
		incrementCounter( "global_solo_games", 1 );
	}
	else if( ( isdefined( level.systemLink ) && level.systemLink ) )
	{
		incrementCounter( "global_systemlink_games", 1 );
	}
	else if ( GetDvarInt( "splitscreen_playerCount" ) == GetPlayers().size )
	{
		incrementCounter( "global_splitscreen_games", 1 );
	}
	else // coop game
	{
		incrementCounter( "global_coop_games", 1 );
	}
	
	callback::on_connect( &zm_on_player_connect);

	//self LUINotifyEvent( &"score_event", 3, label, score, rampageBonus );

	// Initialize persistent upgrades
	//zm_pers_upgrades::pers_upgrade_init();
	
	zm_utility::set_demo_intermission_point();

	level thread zm_ffotd::main_end();
	level thread zm_utility::track_players_intersection_tracker();
	level thread onAllPlayersReady();
	level thread startUnitriggers();
	
	level thread zm_gametype::post_init_gametype();
	
	callback::on_spawned( &zm_on_player_spawned );
}

function post_main()
{
	level thread init_custom_ai_type();	
}

function cheat_enabled( val )
{
	if ( GetDvarInt( "zombie_cheat" ) >= val )
	{
/#
		return true;
#/

		if ( IsProfileBuild() )
		{
			return true;
		}
	}

	return false;
}

function startUnitriggers()
{
	level flag::wait_till_any( array( "start_zombie_round_logic", "start_encounters_match_logic" ) );
	level thread zm_unitrigger::main();
}

function drive_client_connected_notifies()
{
	while(1)
	{
		level waittill("connected", player);
		player demo::reset_actor_bookmark_kill_times();
		player callback::callback( #"on_player_connect" );
	}
}

function fade_out_intro_screen_zm( hold_black_time, fade_out_time, destroyed_afterwards )
{
	if( !IsDefined(level.introscreen) )
	{
		level.introscreen = NewHudElem(); 
		level.introscreen.x = 0; 
		level.introscreen.y = 0; 
		level.introscreen.horzAlign = "fullscreen"; 
		level.introscreen.vertAlign = "fullscreen"; 
		level.introscreen.foreground = false;
		level.introscreen SetShader( "black", 640, 480 );
		level.introscreen.immunetodemogamehudsettings = true;
		level.introscreen.immunetodemofreecamera = true;
		wait .05;
	}

	level.introscreen.alpha = 1; 

	if( IsDefined( hold_black_time ) )
	{
		wait hold_black_time;
	}
	else
	{
		wait 0.2;
	}

	if( !IsDefined( fade_out_time ) )
	{
		fade_out_time = 1.5;
	}
	
	level.introscreen FadeOverTime( fade_out_time ); 
	level.introscreen.alpha = 0; 
	
	//level notify("fade_introblack");

	wait 1.6;

	level.passed_introscreen = true;	

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] setClientUIVisibilityFlag( "hud_visible", 1 );
		players[i] setClientUIVisibilityFlag( "weapon_hud_visible", 1 );
		if(!( isdefined( level.host_ended_game ) && level.host_ended_game ))
		{
			if (isdefined(level.player_movement_suppressed))
			{
				players[i] FreezeControls(level.player_movement_suppressed);
				/# println(" Unfreeze controls 4"); #/
				
			}
			else
			{
				if(!( isdefined( players[i].hostMigrationControlsFrozen ) && players[i].hostMigrationControlsFrozen ))
				{
					players[i] FreezeControls(false);
					
					/# println(" Unfreeze controls 5"); #/
				}
			}
		}
	}
	// level notify("fade_in_complete");
	
	if ( destroyed_afterwards == true )
	{
		level.introscreen destroy();
	}

	level flag::set("initial_blackscreen_passed");
}

function onAllPlayersReady()
{
	
	timeOut = GetTime() + 5000;	// 5 second time out.
	
	while(GetNumExpectedPlayers() == 0  && (GetTime() < timeOut))
	{
		wait(0.1);
	}
	
	/#	println( "ZM >> player_count_expected=" + GetNumExpectedPlayers());		#/
	player_count_actual = 0;
	while( (GetNumConnectedPlayers() < GetNumExpectedPlayers()) || (player_count_actual != GetNumExpectedPlayers()) )
	{
		players = GetPlayers();
		player_count_actual = 0;
		for( i = 0; i < players.size; i++ )
		{
			players[i] FreezeControls( true );
			if( players[i].sessionstate == "playing" )
			{
				player_count_actual++;
			} 
		}
	
		/#	println( "ZM >> Num Connected =" + GetNumConnectedPlayers() + " Expected : " + GetNumExpectedPlayers());	#/
		wait( 0.1 );	
	}

	SetInitialPlayersConnected();

	level flag::set( "all_players_connected" );
	SetDvar( "all_players_are_connected", "1" );

	/#	println( "ZM >> We have all players - START ZOMBIE LOGIC" );	#/


	
	//Check to see if we should spawn some bots to help
	if ( (1 == GetNumConnectedPlayers()) && (GetDvarInt( "scr_zm_enable_bots" )==1) )
	{
		level thread add_bots();
		level flag::set("initial_players_connected");
	}
	else
	{
		players = GetPlayers();
		if ( players.size == 1 )
		{
			level flag::set( "solo_game" );
			level.solo_lives_given = 0;
			foreach ( player in players )
			{
				player.lives = 0;
			}
			level zm::set_default_laststand_pistol( true );
		}

		level flag::set("initial_players_connected");

		while ( !AreTexturesLoaded() )
		{
			{wait(.05);};
		}

		//level flag::set( "start_zombie_round_logic" );
		thread start_zombie_logic_in_x_sec( 3.0 );
	}

	fade_out_intro_screen_zm( 5.0, 1.5, true );
}

function start_zombie_logic_in_x_sec( time_to_wait )
{
	wait( time_to_wait );
	level flag::set( "start_zombie_round_logic" );
}


function getAllOtherPlayers()
{
	aliveplayers = [];

	// Make a list of fully connected, non-spectating, alive players
	for(i = 0; i < level.players.size; i++)
	{
		if ( !isdefined( level.players[i] ) )
			continue;
		player = level.players[i];
		
		if ( player.sessionstate != "playing" || player == self )
			continue;

		aliveplayers[aliveplayers.size] = player;
	}
	return aliveplayers;
}

function getFreeSpawnpoint(spawnpoints, player)
{
	// There are no valid spawnpoints in the map
	if(!isdefined(spawnpoints))
	{
/#
		iprintlnbold( "ZM >> No free spawn points in map" );
#/
		return undefined;
	}

	// only should happen on initial spawn.
	
	if(!isdefined(game["spawns_randomized"]))
	{
		game["spawns_randomized"] = true;
		
		spawnpoints = array::randomize(spawnpoints);
		
		random_chance = randomint(100);
		if(random_chance > 50)
		{
			zm_utility::set_game_var("side_selection", 1);
		}
		else
		{
			zm_utility::set_game_var("side_selection", 2);
		}
	}	
	
	side_selection = zm_utility::get_game_var("side_selection");
	
	// used in vs. games where you switch sides on next round.
	if( zm_utility::get_game_var("switchedsides"))
	{
		if(side_selection == 2)
		{
			side_selection = 1;
		}
		else if(side_selection == 1)
		{
			side_selection = 2;
		}
	}
	
	if(IsDefined(player) && IsDefined(player.team))
	{
		i = 0; 
		while(IsDefined(spawnpoints) && i < spawnpoints.size)
		{
			If(side_selection == 1)
			{
				if(player.team != "allies" && (IsDefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 1))
				{
					ArrayRemoveValue(spawnpoints, spawnpoints[i]);
					i=0;
				}
				else if(player.team == "allies" && (IsDefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 2))
				{
					ArrayRemoveValue(spawnpoints, spawnpoints[i]);
					i=0;
				}
				else 
				{
					i++;
				}
			}	
			else
			{
				if(player.team == "allies" && (IsDefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 1))
				{
					ArrayRemoveValue(spawnpoints, spawnpoints[i]);
					i=0;
				}
				else if(player.team != "allies" && (IsDefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 2))
				{
					ArrayRemoveValue(spawnpoints, spawnpoints[i]);
					i=0;
				}
				else 
				{
					i++;
				}
			}		
		}	
	}	

	if(!Isdefined(player.playernum))
	{
		if(player.team == "allies")
		{
			player.playernum = zm_utility::get_game_var("_team1_num");
			zm_utility::set_game_var("_team1_num", player.playernum + 1);
		}	
		else
		{
			player.playernum = zm_utility::get_game_var("_team2_num");
			zm_utility::set_game_var("_team2_num", player.playernum + 1);
		}	
	}	

	for( j = 0; j < spawnpoints.size; j++ )
	{
		if(!IsDefined(spawnpoints[j].en_num))
		{
			for( m = 0; m < spawnpoints.size; m++ )
			{
				spawnpoints[m].en_num = m;
			}	
		}	

		if(	spawnpoints[j].en_num == player.playernum)
		{
			return spawnpoints[j];
		}	
	}

	return spawnpoints[0];
}


function delete_in_createfx()
{
	exterior_goals =struct::get_array( "exterior_goal", "targetname" );
	for( i = 0; i < exterior_goals.size; i++ )
	{
		if( !IsDefined( exterior_goals[i].target ) ) // If the exterior_goal entity has no targets defined then return
		{
			continue;
		}
		targets = GetEntArray( exterior_goals[i].target, "targetname" ); // Grab all the pieces that are targeted by the exterior_goal

		for( j = 0; j < targets.size; j++ ) // count total targets of exterior_goal
		{
			targets[j] zm_utility::self_delete();
		}
	}

	if(isdefined(level.level_createfx_callback_thread))
	{
		level thread [[level.level_createfx_callback_thread]]();
	}
}



function add_bots()
{
	//Wait for the host!
	host = util::GetHostPlayer();
	while ( !IsDefined( host ) )
	{
		{wait(.05);};
		host = util::GetHostPlayer();
	}
	
	wait( 4.0 );
	
	//Then spawn bots
	zbot_spawn();
	SetDvar("bot_AllowMovement", "1");
	SetDvar("bot_PressAttackBtn", "1");
	SetDvar("bot_PressMeleeBtn", "1");
	
	//Wait until bots are spawned
	while( GetPlayers().size<2 )
	{
		{wait(.05);};
	}
	
	//Unfreeze all players
	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] FreezeControls( false );
		/# println(" Unfreeze controls 6"); #/
		
	}

	level.numberBotsAdded = 1;
	level flag::set( "start_zombie_round_logic" );
}

function zbot_spawn()
{
	player = util::GetHostPlayer();
	
	//spawnPoints =struct::get_array( "initial_spawn_points", "targetname" ); 
	//spawnPoint =  getFreeSpawnpoint( spawnPoints, player );
	
	bot = AddTestClient();	
	if ( !IsDefined( bot ) )
	{
	/#	println( "Could not add test client" );	#/
		return;
	}
			
	
	spawnPoint = bot zm_gametype::onFindValidSpawnPoint();
	
	bot.pers["isBot"] = true;
	bot.equipment_enabled = false;
	yaw = spawnPoint.angles[1];
	
	return bot;
}

function post_all_players_connected()
{
	level thread end_game();
	
	level flag::wait_till( "start_zombie_round_logic" );
/#
	println( "sessions: mapname=", level.script, " gametype zom isserver 1 player_count=", GetPlayers().size );
#/
	level thread zm_utility::clear_mature_blood();

	// Start the Zombie MODE!
	level thread round_end_monitor();
	
	if(!level.zombie_anim_intro)
	{
		if(isDefined(level._round_start_func))
		{
			level thread [[level._round_start_func]]();
		}
	}

	level thread players_playing();

	DisableGrenadeSuicide();
	level.startInvulnerableTime = GetDvarInt( "player_deathInvulnerableTime" );
}

function init_custom_ai_type()
{
	//wait( 0.1 );
//	waittillframeend;

	if( isDefined( level.custom_ai_type ) )
	{
		for( i = 0; i < level.custom_ai_type.size; i++ )
		{
			[[ level.custom_ai_type[i] ]]();
		}
	}
}
	
function zombiemode_melee_miss()
{
	if( isDefined( self.enemy.curr_pay_turret ) )
	{
		self.enemy doDamage( GetDvarInt( "ai_meleeDamage" ), self.origin, self, self, "none", "melee" );
	}
}

/*------------------------------------
function chrisp - adding vo to track players ammo
------------------------------------*/
function player_track_ammo_count()
{
	self notify( "stop_ammo_tracking" );
	self endon( "disconnect" );
	self endon( "stop_ammo_tracking" );
	
	ammoLowCount = 0;
	ammoOutCount = 0;

	while ( 1 )
	{
		wait( .5 );
        weapon = self getcurrentweapon();
        
		if ( weapon == level.weaponNone || weapon.skiplowammovox )
		{
			continue;
		}
		
		if( weapon.type == "grenade" )
		{
			continue;
		}

		if ( self GetAmmoCount( weapon ) > 5 || self laststand::player_is_in_laststand() )
		{
			ammoOutCount = 0;
			ammoLowCount = 0;
			continue;
		}		
		
		if ( self GetAmmoCount( weapon ) > 0 )
		{
			if ( ammoLowCount < 1 )
			{
				self zm_audio::create_and_play_dialog( "general", "ammo_low" );
				ammoLowCount++;
			}
		}
		else
		{
			if ( ammoOutCount < 1 )
			{
				self zm_audio::create_and_play_dialog( "general", "ammo_out" );
				ammoOutCount++;
			}
		}
		wait( 20 );	
	}	
}

/*------------------------------------
function audio plays when more than 1 player connects
------------------------------------*/
function spawn_vo()
{
	//not sure if we need this
	wait(1);
	
	players = GetPlayers();
	
	//just pick a random player for now and play some vo 
	if(players.size > 1)
	{
		player = array::random(players);
		index = zm_utility::get_player_index(player);
		player thread spawn_vo_player(index,players.size);
	}

}

function spawn_vo_player(index,num)
{
	sound = "plr_" + index + "_vox_" + num +"play";
	self PlaySoundWithNotify(sound, "sound_done");			
	self waittill("sound_done");
}

function precache_models()
{
	if ( isDefined( level.precacheCustomCharacters ) )
	{
		self [[ level.precacheCustomCharacters ]]();
	}
}

function init_shellshocks()
{
	level.player_killed_shellshock = "zombie_death";
}

function init_strings()
{
	zm_utility::add_zombie_hint( "undefined", &"ZOMBIE_UNDEFINED" );

	// Random Treasure Chest
	zm_utility::add_zombie_hint( "default_treasure_chest", &"ZOMBIE_RANDOM_WEAPON_COST" );
	/*zm_utility::add_zombie_hint( "default_treasure_chest_950", &"ZOMBIE_RANDOM_WEAPON_950" ); // T7TODO - this can be deleted*/

	// Barrier Pieces
	zm_utility::add_zombie_hint( "default_buy_barrier_piece_10", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_10" );
	zm_utility::add_zombie_hint( "default_buy_barrier_piece_20", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_20" );
	zm_utility::add_zombie_hint( "default_buy_barrier_piece_50", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_50" );
	zm_utility::add_zombie_hint( "default_buy_barrier_piece_100", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_100" );

	// REWARD Barrier Pieces
	zm_utility::add_zombie_hint( "default_reward_barrier_piece", &"ZOMBIE_BUTTON_REWARD_BARRIER" );
	/*zm_utility::add_zombie_hint( "default_reward_barrier_piece_10", &"ZOMBIE_BUTTON_REWARD_BARRIER_10" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_reward_barrier_piece_20", &"ZOMBIE_BUTTON_REWARD_BARRIER_20" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_reward_barrier_piece_30", &"ZOMBIE_BUTTON_REWARD_BARRIER_30" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_reward_barrier_piece_40", &"ZOMBIE_BUTTON_REWARD_BARRIER_40" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_reward_barrier_piece_50", &"ZOMBIE_BUTTON_REWARD_BARRIER_50" ); // T7TODO - this can be deleted*/
	
	// Areas
	zm_utility::add_zombie_hint( "default_buy_area", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_COST" );
	/*zm_utility::add_zombie_hint( "default_buy_area_100", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_100" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_buy_area_200", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_200" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_buy_area_250", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_250" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_buy_area_500", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_500" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_buy_area_750", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_750" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_buy_area_1000", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1000" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_buy_area_1250", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1250" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_buy_area_1500", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1500" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_buy_area_1750", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1750" ); // T7TODO - this can be deleted
	zm_utility::add_zombie_hint( "default_buy_area_2000", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_2000" ); // T7TODO - this can be deleted*/
}

function init_sounds()
{
	zm_utility::add_sound( "end_of_round", "mus_zmb_round_over" );
	zm_utility::add_sound( "end_of_game", "mus_zmb_game_over" ); //Had to remove this and add a music state switch so that we can add other musical elements.
	zm_utility::add_sound( "chalk_one_up", "mus_zmb_chalk" );
	zm_utility::add_sound( "purchase", "zmb_cha_ching" );
	zm_utility::add_sound( "no_purchase", "zmb_no_cha_ching" );

	// Zombification
	// TODO need to vary these up
	zm_utility::add_sound( "playerzombie_usebutton_sound", "zmb_zombie_vocals_attack" );
	zm_utility::add_sound( "playerzombie_attackbutton_sound", "zmb_zombie_vocals_attack" );
	zm_utility::add_sound( "playerzombie_adsbutton_sound", "zmb_zombie_vocals_attack" );

	// Head gib
	zm_utility::add_sound( "zombie_head_gib", "zmb_zombie_head_gib" );

	// Blockers
	zm_utility::add_sound( "rebuild_barrier_piece", "zmb_repair_boards" );
	zm_utility::add_sound( "rebuild_barrier_metal_piece", "zmb_metal_repair" );
	zm_utility::add_sound( "rebuild_barrier_hover", "zmb_boards_float" );
	zm_utility::add_sound( "debris_hover_loop", "zmb_couch_loop" );
	zm_utility::add_sound( "break_barrier_piece", "zmb_break_boards" );
	zm_utility::add_sound( "grab_metal_bar", "zmb_bar_pull" );
	zm_utility::add_sound( "break_metal_bar", "zmb_bar_break" );
	zm_utility::add_sound( "drop_metal_bar", "zmb_bar_drop" );
	zm_utility::add_sound("blocker_end_move", "zmb_board_slam");
	zm_utility::add_sound( "barrier_rebuild_slam", "zmb_board_slam" );
	zm_utility::add_sound( "bar_rebuild_slam", "zmb_bar_repair" );
	zm_utility::add_sound( "zmb_rock_fix", "zmb_break_rock_barrier_fix" );
	zm_utility::add_sound( "zmb_vent_fix", "evt_vent_slat_repair" );

	// Doors
	zm_utility::add_sound( "door_slide_open", "zmb_door_slide_open" );
	zm_utility::add_sound( "door_rotate_open", "zmb_door_slide_open" );

	// Debris
	zm_utility::add_sound( "debris_move", "zmb_weap_wall" );

	// Random Weapon Chest
	zm_utility::add_sound( "open_chest", "zmb_lid_open" );
	zm_utility::add_sound( "music_chest", "zmb_music_box" );
	zm_utility::add_sound( "close_chest", "zmb_lid_close" );

	// Weapons on walls
	zm_utility::add_sound( "weapon_show", "zmb_weap_wall" );
	
	zm_utility::add_sound( "break_stone", "break_stone" );
}

function init_levelvars()
{
	// Variables
	// used to a check in last stand for players to become zombies
	level.is_zombie_level				= true; 
	level.default_laststandpistol 		= GetWeapon( "pistol_standard" );
	level.default_solo_laststandpistol	= GetWeapon( "pistol_standard_upgraded" );
	level.laststandpistol				= level.default_laststandpistol;		// so we dont get the uber colt when we're knocked out
	level.start_weapon					= level.default_laststandpistol;
	level.first_round					= true;	
	level.start_round					= GetGametypeSetting( "startRound" );
	level.round_number					= level.start_round;
	level.enable_magic					= GetGametypeSetting( "magic" );
	level.headshots_only				= GetGametypeSetting( "headshotsonly" );	
	level.player_starting_points 		= level.round_number * 500;
	level.round_start_time				= 0;
	level.pro_tips_start_time			= 0;
	level.intermission					= false;
	level.dog_intermission				= false;
	level.zombie_total					= 0;									// Total number of zombies left to spawn
	level.zombie_respawns				= 0;									// Total number of zombies that need to be respawned due to cleanup
	level.total_zombies_killed			= 0;
	level.hudelem_count					= 0;
	level.zm_loc_types					= [];
	level.zm_loc_types[ "zombie_location" ] = [];			// List of normal zombie spawners (other types will be added in the zone manager)
	
	level.zm_variant_type_max						= [];
	level.zm_variant_type_max[ "walk" ]				= [];
	level.zm_variant_type_max[ "run" ]				= [];
	level.zm_variant_type_max[ "sprint" ] 			= [];
	level.zm_variant_type_max[ "walk" ][ "down" ]	= 14;
	level.zm_variant_type_max[ "walk" ][ "up" ] 	= 16;
	level.zm_variant_type_max[ "run" ][ "down" ]	= 13;
	level.zm_variant_type_max[ "run" ][ "up" ]		= 12;
	level.zm_variant_type_max[ "sprint" ][ "down" ]	= 7;
	level.zm_variant_type_max[ "sprint" ][ "up" ]	= 6;

	level.current_zombie_array = [];
	level.current_zombie_count = 0;
	level.zombie_total_subtract = 0;
	level.destructible_callbacks = [];
	
	foreach( team in level.teams )
	{
		level.zombie_vars[ team ] = [];
	}

	difficulty = 1;
	column = int(difficulty) + 1;

	//#######################################################################
	//	zombie_utility::set_zombie_var( identifier, 					value,	float,	column );

	// AI
	zombie_utility::set_zombie_var( "zombie_health_increase", 			100,	false,	column );	//	cumulatively add this to the zombies' starting health each round (up to round 10)
	zombie_utility::set_zombie_var( "zombie_health_increase_multiplier",0.1, 	true,	column );	//	after round 10 multiply the zombies' starting health by this amount
	zombie_utility::set_zombie_var( "zombie_health_start", 				150,	false,	column );	//	starting health of a zombie at round 1
	zombie_utility::set_zombie_var( "zombie_spawn_delay", 				2.0,	true,	column );	// Time to wait between spawning zombies.  This is modified based on the round number.
	zombie_utility::set_zombie_var( "zombie_new_runner_interval", 		 10,	false,	column );	//	Interval between changing walkers who are too far away into runners 
	zombie_utility::set_zombie_var( "zombie_move_speed_multiplier", 	  8,	false,	column );	//	Multiply by the round number to give the base speed value.  0-40 = walk, 41-70 = run, 71+ = sprint
	zombie_utility::set_zombie_var( "zombie_move_speed_multiplier_easy",  2,	false,	column );	//	Multiply by the round number to give the base speed value.  0-40 = walk, 41-70 = run, 71+ = sprint

	zombie_utility::set_zombie_var( "zombie_max_ai", 					24,		false,	column );	//	Base number of zombies per player (modified by round #)
	zombie_utility::set_zombie_var( "zombie_ai_per_player", 			6,		false,	column );	//	additional zombie modifier for each player in the game
	zombie_utility::set_zombie_var( "below_world_check", 				-1000 );					//	Check height to see if a zombie has fallen through the world.

	// Round	
	zombie_utility::set_zombie_var( "spectators_respawn", 				true );		// Respawn in the spectators in between rounds
	zombie_utility::set_zombie_var( "zombie_use_failsafe", 				true );		// Will slowly kill zombies who are stuck
	zombie_utility::set_zombie_var( "zombie_between_round_time", 		10 );		// How long to pause after the round ends
	zombie_utility::set_zombie_var( "zombie_intermission_time", 		15 );		// Length of time to show the end of game stats
	zombie_utility::set_zombie_var( "game_start_delay", 				0,		false,	column );	// How much time to give people a break before starting spawning

	// Life and death
	zombie_utility::set_zombie_var( "player_base_health", 				100 );		// Base health of a player

	zombie_utility::set_zombie_var( "penalty_no_revive", 				0.10, 	true,	column );	// Percentage of money you lose if you let a teammate die
	zombie_utility::set_zombie_var( "penalty_died",						0.0, 	true,	column );	// Percentage of money lost if you die
	zombie_utility::set_zombie_var( "penalty_downed", 					0.05, 	true,	column );	// Percentage of money lost if you go down // ww: told to remove downed point loss

	zombie_utility::set_zombie_var( "zombie_score_kill_4player", 		50 );		// Individual Points for a zombie kill in a 4 player game
	zombie_utility::set_zombie_var( "zombie_score_kill_3player",		50 );		// Individual Points for a zombie kill in a 3 player game
	zombie_utility::set_zombie_var( "zombie_score_kill_2player",		50 );		// Individual Points for a zombie kill in a 2 player game
	zombie_utility::set_zombie_var( "zombie_score_kill_1player",		50 );		// Individual Points for a zombie kill in a 1 player game

	zombie_utility::set_zombie_var( "zombie_score_damage_normal",		10 );		// points gained for a hit with a non-automatic weapon
	zombie_utility::set_zombie_var( "zombie_score_damage_light",		10 );		// points gained for a hit with an automatic weapon

	zombie_utility::set_zombie_var( "zombie_score_bonus_melee", 		80 );		// Bonus points for a melee kill
	zombie_utility::set_zombie_var( "zombie_score_bonus_head", 			50 );		// Bonus points for a head shot kill
	zombie_utility::set_zombie_var( "zombie_score_bonus_neck", 			20 );		// Bonus points for a neck shot kill
	zombie_utility::set_zombie_var( "zombie_score_bonus_torso", 		10 );		// Bonus points for a torso shot kill
	zombie_utility::set_zombie_var( "zombie_score_bonus_burn", 			10 );		// Bonus points for a burn kill

	zombie_utility::set_zombie_var( "zombie_flame_dmg_point_delay",		500 );	

	zombie_utility::set_zombie_var( "zombify_player", 					false );	// Default to not zombify the player till further support

	if ( IsSplitScreen() )
	{
		zombie_utility::set_zombie_var( "zombie_timer_offset", 			280 );	// hud offsets
	}
	
	level thread init_player_levelvars();

	level.gamedifficulty = GetGametypeSetting( "zmDifficulty" );

	if( level.gamedifficulty == 0 ) //easy
	{
		level.zombie_move_speed			= level.round_number * level.zombie_vars["zombie_move_speed_multiplier_easy"]; 
	}
	else	//normal
	{
		level.zombie_move_speed			= level.round_number * level.zombie_vars["zombie_move_speed_multiplier"]; 
	}

	//Make sure we only have walker zombies in round 1
	if ( level.round_number == 1 )
	{
		level.zombie_move_speed = 1;
	}

	level.speed_change_max = 0;
	level.speed_change_num = 0;
}

function init_player_levelvars()
{
	level flag::wait_till( "start_zombie_round_logic" );
	
	difficulty = 1;
	column = int(difficulty) + 1;	
	
	for(i = 0; i < 8; i ++)
	{
		points = 500;
		
		if(i > 3)
		{
			points = 3000;	// Dont change the behavior of grief.
		}
		
		points = zombie_utility::set_zombie_var( ("zombie_score_start_"+ (i+1) +"p"), points, false, column );
	}
}

function init_dvars()
{
//t6.5todo: move these dvars out of script, dangerous to leave them here like this

	if( GetDvarString( "zombie_debug" ) == "" )
	{
		SetDvar( "zombie_debug", "0" );
	}

	if( GetDvarString( "scr_zm_enable_bots" ) == "" )
	{
		SetDvar( "scr_zm_enable_bots", "0" );
	}

	if( GetDvarString( "zombie_cheat" ) == "" )
	{
		SetDvar( "zombie_cheat", "0" );
	}

	if ( GetDvarString("zombiemode_debug_zombie_count") == "" ) 
	{
		SetDvar("zombiemode_debug_zombie_count", "0");
	}

	if ( level.script != "zombie_cod5_prototype" )
	{
		SetDvar( "magic_chest_movable", "1" );
	}

	SetDvar( "revive_trigger_radius", "75" ); 
	SetDvar( "player_lastStandBleedoutTime", "45" );

	SetDvar( "scr_deleteexplosivesonspawn", "0" );
}


function init_function_overrides()
{
	level.callbackPlayerDamage = &Callback_PlayerDamage;
	level.overridePlayerDamage		= &player_damage_override; //_cheat;
	level.callbackPlayerKilled		= &player_killed_override;
	
	level.playerlaststand_func		= &player_laststand;
	level.callbackPlayerLastStand	= &Callback_PlayerLastStand;
	
	level.prevent_player_damage		= &player_prevent_damage;

	level.callbackActorKilled		= &actor_killed_override;
	level.callbackActorDamage		= &actor_damage_override_wrapper;
	
	level.callbackVehicleDamage 	= &vehicle_damage_override;
	level.callbackVehicleKilled	    = &globallogic_vehicle::Callback_VehicleKilled;
	level.callbackVehicleRadiusDamage = &globallogic_vehicle::Callback_VehicleRadiusDamage;
	
	level.custom_introscreen		= &zombie_intro_screen; 
	level.custom_intermission		= &player_intermission; 

	level.global_damage_func		= &zm_spawner::zombie_damage; 
	level.global_damage_func_ads	= &zm_spawner::zombie_damage_ads;
	
	level.reset_clientdvars			= &onPlayerConnect_clientDvars;
	
	level.zombie_last_stand 		= &last_stand_pistol_swap;
	level.zombie_last_stand_pistol_memory = &last_stand_save_pistol_ammo;
	level.zombie_last_stand_ammo_return		= &last_stand_restore_pistol_ammo;

	level.player_becomes_zombie		= &zombify_player; 	

	level.validate_enemy_path_length = &zm_utility::default_validate_enemy_path_length;
}

function Callback_PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self endon( "disconnect" );
	//self Callback("on_player_last_stand");
	zm_laststand::PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ); 
}

function CodeCallback_DestructibleEvent( event, param1, param2, param3 )
{
	if( event == "broken" )
	{
		notify_type = param1;
		attacker = param2;
		weapon = param3;

		if ( IsDefined( level.destructible_callbacks[ notify_type ] ) )
		{
			self thread [[level.destructible_callbacks[ notify_type ]]]( notify_type, attacker );
		}

		self notify( event, notify_type, attacker );
	}
	else if( event == "breakafter" )
	{
		piece = param1;
		time = param2;
		damage = param3;
		self thread breakAfter( time, damage, piece );
	}
}

function breakAfter( time, damage, piece )
{
	self notify( "breakafter" );
	self endon( "breakafter" );
	
	wait time;
	
	// this does not work in mp.  DoDamage does not take a piece for mp.
	self dodamage( damage, self.origin, undefined, /*piece*/undefined );
}

function Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal )
{	
	startedInLastStand = 0;
	if ( isPlayer(self)  )
	{
		startedInLastStand = self laststand::player_is_in_laststand();
	}
	
	/# println( "ZM Callback_PlayerDamage"+iDamage+"\n"); #/
	if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && (eAttacker.sessionteam == self.sessionteam) && !eAttacker HasPerk( "specialty_playeriszombie" ) && !( isdefined( self.is_zombie ) && self.is_zombie ) )
	{
		self process_friendly_fire_callbacks( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex );
		if ( self != eAttacker )
		{
			//one player shouldn't damage another player, grenades, airstrikes called in by another player
		/#	println("Exiting - players can't hurt each other.");	#/
			
			
			return;
		}
		else if ( sMeansOfDeath != "MOD_GRENADE_SPLASH"
				&& sMeansOfDeath != "MOD_GRENADE"
				&& sMeansOfDeath != "MOD_EXPLOSIVE"
				&& sMeansOfDeath != "MOD_PROJECTILE"
				&& sMeansOfDeath != "MOD_PROJECTILE_SPLASH"
				&& sMeansOfDeath != "MOD_BURNED"
				&& sMeansOfDeath != "MOD_SUICIDE" )
		{
		/#	println("Exiting - damage type verbotten.");	#/
			//player should be able to damage they're selves with grenades and stuff
			//otherwise don't damage the player, so like airstrikes  won't kill the player
			return;
		}
	}
	
	// Notify the player of a zombie swipe if the persistent Insta Kill upgrade is active
	if( ( isdefined( level.pers_upgrade_insta_kill ) && level.pers_upgrade_insta_kill ) )
	{
		self zm_pers_upgrades_functions::pers_insta_kill_melee_swipe( sMeansOfDeath, eAttacker );
	}

	if( IsDefined( self.overridePlayerDamage ) )
	{
		iDamage = self [[self.overridePlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}
	else if( IsDefined( level.overridePlayerDamage ) )
	{
		iDamage = self [[level.overridePlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}

	Assert(IsDefined(iDamage), "You must return a value from a damage override function.");

//	self Callback("on_player_damage");

	if (( isdefined( self.magic_bullet_shield ) && self.magic_bullet_shield ))
	{
		// save out and restore the maxHealth, because setting health below modifies it
		maxHealth = self.maxHealth;

		// increase health by damage, because it will be subtracted back out below in finishActorDamage
		self.health += iDamage;

		// restore the maxHealth to what it was
		self.maxHealth = maxHealth;
	}
	
	// DtP: When player is diving to prone away from the grenade, the damage is reduced

	// player is diving
	if( isdefined( self.divetoprone ) && self.divetoprone == 1 )
	{
		// grenade splash damage
		if( sMeansOfDeath == "MOD_GRENADE_SPLASH" )
		{
			// if the player is at least 32 units away
			dist = Distance2d(vPoint, self.origin);
			if( dist > 32 )
			{
				// if player is diving away
				dot_product = vectordot( AnglesToForward( self.angles ), vDir ); 
				if( dot_product > 0 )
				{
					// grenade is behind player
					iDamage = int( iDamage * 0.5 ); // halves damage
				}
			}
		}
	}
	
/#	println("CB PD");	#/

	// players can only hurt themselves, zombie players can hurt any other player and be hurt by human players
/*	if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && !eAttacker HasPerk( "specialty_playeriszombie" ) && !IS_TRUE( self.is_zombie ) )
	{
		if ( self != eAttacker )
		{
			//one player shouldn't damage another player, grenades, airstrikes called in by another player
			println("Exiting - players can't hurt each other.");
			return;
		}
		else if ( sMeansOfDeath != "MOD_GRENADE_SPLASH"
				&& sMeansOfDeath != "MOD_GRENADE"
				&& sMeansOfDeath != "MOD_EXPLOSIVE"
				&& sMeansOfDeath != "MOD_PROJECTILE"
				&& sMeansOfDeath != "MOD_PROJECTILE_SPLASH"
				&& sMeansOfDeath != "MOD_BURNED"
				&& sMeansOfDeath != "MOD_SUICIDE" )
		{
			println("Exiting - damage type verbotten.");
			//player should be able to damage they're selves with grenades and stuff
			//otherwise don't damage the player, so like airstrikes  won't kill the player
			return;
		}
	}*/

	if ( isdefined( level.prevent_player_damage ) )
	{
		if ( self [[ level.prevent_player_damage ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime ) )
		{
			return;
		}
	}
	

	iDFlags = iDFlags | level.iDFLAGS_NO_KNOCKBACK;
	
	//damage should have been reduced to 0 if it really was a riotshield hit
	if( iDamage > 0 && sHitLoc == "riotshield" )
	{
		sHitLoc = "torso_upper";
	}

/#	PrintLn("Finishplayerdamage wrapper.");		#/
	wasDowned = 0;
	if ( isPlayer(self))
	{
		wasDowned = !startedInLastStand && self laststand::player_is_in_laststand();
	}

	self finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal );
	bb::logdamage(eattacker, self, weapon, idamage, smeansofdeath, shitloc, self.Health <= 0, wasDowned);
}

function finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal )
{
	self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal ); 
	
	// the MP version of finishPlayerDamage does not take 11 parameters 
	// the 11 parameter version in SP does not take these parameters (10 is modelIndex and 11 is pOffsetTime)
	//surface = "flesh";
	//self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, surface );

}

function register_player_friendly_fire_callback( callback )
{
	if (!isdefined(level.player_friendly_fire_callbacks))
		level.player_friendly_fire_callbacks = [];
	level.player_friendly_fire_callbacks[level.player_friendly_fire_callbacks.size] = callback;
}

function process_friendly_fire_callbacks( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex )
{
	if (isdefined(level.player_friendly_fire_callbacks))
	{
		foreach( callback in level.player_friendly_fire_callbacks )
		{
			self [[callback]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex );
		}
	}
}

function init_flags()
{
	level flag::init( "solo_game" );
	level flag::init( "start_zombie_round_logic" );
	level flag::init( "start_encounters_match_logic" );
	level flag::init( "spawn_point_override" );
	level flag::init( "crawler_round" );
	level flag::init( "spawn_zombies", true );
	level flag::init( "special_round" );
	level flag::init( "dog_round" );
	level flag::init( "raps_round" );
	level flag::init( "begin_spawning" );
	level flag::init( "end_round_wait" );
	level flag::init( "wait_and_revive" );
	level flag::init( "instant_revive" );
	level flag::init( "initial_blackscreen_passed" );
	level flag::init( "initial_players_connected" );
	
	level flag::init( "power_on" );
	//DCS: this will init all zone controlling power switch flags.
	power_trigs = GetEntArray( "use_elec_switch", "targetname" );
	foreach(trig in power_trigs)
	{
		if(IsDefined(trig.script_int))
		{
			level flag::init("power_on" + trig.script_int);
		}
	}
}

function init_client_field_callback_funcs()
{	
	// Client fields for actors

	clientfield::register("actor", "zombie_riser_fx", 1, 1, "int");
	
	if ( ( isdefined( level.use_water_risers ) && level.use_water_risers ) )
	{
		clientfield::register("actor", "zombie_riser_fx_water", 1, 1, "int");
	}
	
	if ( ( isdefined( level.use_foliage_risers ) && level.use_foliage_risers ) )
	{
		clientfield::register("actor", "zombie_riser_fx_foliage", 1, 1, "int");
	}
	
	if ( ( isdefined( level.use_low_gravity_risers ) && level.use_low_gravity_risers ) )
	{
		clientfield::register("actor", "zombie_riser_fx_lowg", 1, 1, "int");
	}
	
	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int");		
	clientfield::register("actor", "zombie_ragdoll_explode", 1, 1, "int");	
	clientfield::register("actor", "zombie_gut_explosion", 1, 1, "int");
	clientfield::register("actor", "sndZombieContext", (0 - 1), 1, "int");
	
	bits = 4;
	trigs = GetEntArray( "use_elec_switch", "targetname" );
	if ( IsDefined( trigs ) )
	{
		bits = GetMinBitCountForNum( trigs.size + 1 );
	}
	clientfield::register("world", "zombie_power_on", 1, bits, "int");
	clientfield::register("world", "zombie_power_off", 1, bits, "int");
}

function init_fx()
{
	level.createfx_callback_thread = &delete_in_createfx;

//	level._effect["wood_chunk_destory"]	 		= "_t6/impacts/fx_large_woodhit" ;
	level._effect["fx_zombie_bar_break"]		= "_t6/maps/zombie/fx_zombie_bar_break";
	level._effect["fx_zombie_bar_break_lite"]	= "_t6/maps/zombie/fx_zombie_bar_break_lite";
	
	if ( !( isdefined( level.FX_exclude_edge_fog ) && level.FX_exclude_edge_fog ) )
	{
		level._effect["edge_fog"]			 		= "_t6/maps/zombie/fx_fog_zombie_amb"; 
	}
	
	level._effect["chest_light"]		 		= "zombie/fx_weapon_box_open_glow_zmb"; 
	level._effect["chest_light_closed"]		 	= "zombie/fx_weapon_box_closed_glow_zmb"; 

	if ( !( isdefined( level.FX_exclude_default_eye_glow ) && level.FX_exclude_default_eye_glow ) )
	{
		level._effect["eye_glow"]				= "zombie/fx_glow_eye_orange";
	}

	level._effect["headshot"]				= "zombie/fx_bul_flesh_head_fatal_zmb";
	level._effect["headshot_nochunks"]		= "zombie/fx_bul_flesh_head_nochunks_zmb";
	level._effect["bloodspurt"]				= "zombie/fx_bul_flesh_neck_spurt_zmb";

	if ( !( isdefined( level.FX_exclude_tesla_head_light ) && level.FX_exclude_tesla_head_light ) )
	{
		level._effect["tesla_head_light"]		= "_t6/maps/zombie/fx_zombie_tesla_neck_spurt";
	}
	level._effect["zombie_guts_explosion"]      = "zombie/fx_blood_torso_explo_lg_zmb";


	level._effect["rise_burst_water"]			= "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["rise_billow_water"]			= "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["rise_dust_water"]			= "zombie/fx_spawn_dirt_body_dustfalling_zmb";

	level._effect["rise_burst"]					= "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["rise_billow"]				= "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["rise_dust"]					= "zombie/fx_spawn_dirt_body_dustfalling_zmb";	

	level._effect["fall_burst"]					= "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["fall_billow"]				= "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["fall_dust"]					= "zombie/fx_spawn_dirt_body_dustfalling_zmb";	

	// Flamethrower
	level._effect["character_fire_death_sm"]    = "zombie/fx_fire_torso_zmb";
	level._effect["character_fire_death_torso"] = "zombie/fx_fire_torso_zmb";

	if ( !( isdefined( level.fx_exclude_default_explosion ) && level.fx_exclude_default_explosion ) )
	{
		level._effect["def_explosion"]				= "_t6/explosions/fx_default_explosion";
	}
//	level._effect["betty_explode"]				= "_t6/weapon/bouncing_betty/fx_explosion_betty_generic";
	
//	level._effect["default_weapon_glow"]		= "_t6/maps/zombie/fx_zmb_tranzit_weapon_glow";
	if ( ( isdefined( level._uses_default_wallbuy_fx ) && level._uses_default_wallbuy_fx ) )
	{
		level._effect["870mcs_zm_fx"]						= "zombie/fx_wallbuy_xr2_zmb";
//		level._effect["ak74u_zm_fx"]						= "_t6/maps/zombie/fx_zmb_wall_buy_ak74u";
		level._effect["beretta93r_zm_fx"]				= "_t6/maps/zombie/fx_zmb_wall_buy_berreta93r";
		level._effect["bowie_knife_zm_fx"]			= "_t6/maps/zombie/fx_zmb_wall_buy_bowie";
		level._effect["claymore_zm_fx"]					= "_t6/maps/zombie/fx_zmb_wall_buy_claymore";
		level._effect["m14_zm_fx"]							= "_t6/maps/zombie/fx_zmb_wall_buy_m14";
		level._effect["m16_zm_fx"]							= "_t6/maps/zombie/fx_zmb_wall_buy_m16";
		level._effect["mp5k_zm_fx"]							= "_t6/maps/zombie/fx_zmb_wall_buy_mp5k";
		level._effect["rottweil72_zm_fx"]				= "_t6/maps/zombie/fx_zmb_wall_buy_olympia";
	}
	
	if (  ( isdefined( level._uses_sticky_grenades ) && level._uses_sticky_grenades ) )
	{
		// Needed way to just disable effect becuase "level._uses_sticky_grenades" does more than just disable the effect (like claymores)
		if( !( isdefined( level.disable_fx_zmb_wall_buy_semtex ) && level.disable_fx_zmb_wall_buy_semtex ) )
		{
			level._effect["sticky_grenade_zm_fx"]		= "_t6/maps/zombie/fx_zmb_wall_buy_semtex";
		}
	}
	
	if ( ( isdefined( level._uses_taser_knuckles ) && level._uses_taser_knuckles ) )
	{
		level._effect["tazer_knuckles_zm_fx"]		= "_t6/maps/zombie/fx_zmb_wall_buy_taseknuck";
	}
	
	if (IsDefined(level.buildable_wallbuy_weapons))
	{
		level._effect["dynamic_wallbuy_fx"]				= "_t6/maps/zombie/fx_zmb_wall_buy_question";
	}

	if ( !( isdefined( level.disable_fx_upgrade_aquired ) && level.disable_fx_upgrade_aquired ) )
	{
		level._effect["upgrade_aquired"]			= "_t6/maps/zombie/fx_zmb_tanzit_upgrade";
	}
}

// Handles the intro screen
function zombie_intro_screen( string1, string2, string3, string4, string5 )
{
	level flag::wait_till( "start_zombie_round_logic" );
}

function players_playing()
{
	// initialize level.players_playing
	players = GetPlayers();
	level.players_playing = players.size;

	wait( 20 );

	players = GetPlayers();
	level.players_playing = players.size;
}


//
// NETWORK SECTION ====================================================================== //
//

function onPlayerConnect_clientDvars()
{
	self SetClientCompass( 0 );
	self SetClientThirdPerson( 0 );
	self resetFov();
	self SetClientThirdPersonAngle( 0 );
	self SetClientUIVisibilityFlag( "weapon_hud_visible", 1 );
	self SetClientMiniScoreboardHide( 1 );
	self SetClientHUDHardcore( 0 );
	self SetClientPlayerPushAmount( 1 );

	self SetDepthOfField( 0, 0, 512, 4000, 4, 0 );
	
	self SetClientAimLockonPitchStrength( 0.0 );
	
	self zm_laststand::player_getup_setup();
}



function checkForAllDead(excluded_player)
{
	players = GetPlayers();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if(isDefined(excluded_player) && excluded_player == players[i])
		{
			continue;
		}
		if( !(players[i] laststand::player_is_in_laststand()) && !(players[i].sessionstate == "spectator") )
		{
			count++;
		}
	}
	
	if( count==0 && !( isdefined( level.no_end_game_check ) && level.no_end_game_check ) )
	{
		level notify( "end_game" );
	}
}
	

//
//	Runs when the player spawns into the map
//	self is the player.surprise!
//
function onPlayerSpawned()
{
	self endon( "disconnect" ); 
	self notify("stop_onPlayerSpawned");
	self endon("stop_onPlayerSpawned");
	
	for( ;; )
	{
		self waittill( "spawned_player" ); 
		
		if(!( isdefined( level.host_ended_game ) && level.host_ended_game ))
		{
			self freezecontrols( false );
			/# println(" Unfreeze controls 7"); #/

		}
		self.hits = 0;

		self zm_utility::init_player_offhand_weapons();
		
		lethal_grenade = self zm_utility::get_player_lethal_grenade();
		if( !self HasWeapon( lethal_grenade ) )
		{
			self GiveWeapon( lethal_grenade );	
			self SetWeaponAmmoClip( lethal_grenade, 0 );
		}
		
		self RecordPlayerReviveZombies( self );
		
/#
		if ( GetDvarInt( "zombie_cheat" ) >= 1 && GetDvarInt( "zombie_cheat" ) <= 3 ) 
		{
			self EnableInvulnerability();
		}
#/

		self SetActionSlot( 3, "altMode" );
		self PlayerKnockback( false );

		self SetClientThirdPerson( 0 );
		self resetFov();
		self SetClientThirdPersonAngle( 0 );

		self SetDepthOfField( 0, 0, 512, 4000, 4, 0 );

		self cameraactivate(false);

		self.num_perks = 0;
		self.on_lander_last_stand = undefined;
		self setblur(0, 0.1);
		self.zmbDialogQueue = [];
		self.zmbDialogActive = false;
		self.zmbDialogGroups = [];
		self.zmbDialogGroup = "";
		
		if ( ( isdefined( level.player_out_of_playable_area_monitor ) && level.player_out_of_playable_area_monitor ) )
		{
			self thread player_out_of_playable_area_monitor();
		}

		if ( ( isdefined( level.player_too_many_weapons_monitor ) && level.player_too_many_weapons_monitor ) )
		{
			self thread [[level.player_too_many_weapons_monitor_func]]();
		}
		
		if ( ( isdefined( level.player_too_many_players_check ) && level.player_too_many_players_check ) )
		{
			level thread [[level.player_too_many_players_check_func]]();
		}

		self.disabled_perks = [];
		
		if( isdefined( self.player_initialized ) )
		{
			if( self.player_initialized == false )
			{
				self.player_initialized = true; 
				
				//t6.5todo self freezecontrols( true ); // first spawn only, intro_black_screen will pull them out of it

				self giveweapon( self zm_utility::get_player_lethal_grenade() );	
				self setweaponammoclip( self zm_utility::get_player_lethal_grenade(), 0);
				self SetClientUIVisibilityFlag( "weapon_hud_visible", 1 );
				self SetClientMiniScoreboardHide( 0 );				
				// ww: set the is_drinking variable
				self.is_drinking = 0;

				self thread player_zombie_breadcrumb();				
			
				self thread player_monitor_travel_dist();	
				self thread player_monitor_time_played();
				
				if(isDefined(level.custom_player_track_ammo_count))
				{
					self thread [[level.custom_player_track_ammo_count]]();
				}
				else
				{
					self thread player_track_ammo_count();	
				}
				
				self thread zm_utility::shock_onpain();

				self thread player_grenade_watcher();
				self laststand::revive_hud_create();
			
				if(isDefined(level.zm_gamemodule_spawn_func))
				{
					self thread [[level.zm_gamemodule_spawn_func]]();
				}
				
				self thread player_spawn_protection();
				if(!isDefined(self.lives))
				{
					self.lives = 0;
				}
			}
		}
	}
}

function player_spawn_protection()
{
	self endon("disconnect");
	self zm_utility::increment_ignoreme();
	x = 0;
	while( x < 60 )
	{
		x++;
		wait(.05);
	}	
	self zm_utility::decrement_ignoreme();
}

function spawn_life_brush( origin, radius, height )
{
	life_brush = spawn( "trigger_radius", origin, 0, radius, height );
	life_brush.script_noteworthy = "life_brush";
	
	return life_brush;
}


function in_life_brush()
{
	life_brushes = getentarray( "life_brush", "script_noteworthy" );

	if ( !IsDefined( life_brushes ) )
	{
		return false;
	}
	
	for ( i = 0; i < life_brushes.size; i++ )
	{

		if ( self IsTouching( life_brushes[i] ) )
		{
			return true;
		}
	}

	return false;
}


function spawn_kill_brush( origin, radius, height )
{
	kill_brush = spawn( "trigger_radius", origin, 0, radius, height );
	kill_brush.script_noteworthy = "kill_brush";
	
	return kill_brush;
}


function in_kill_brush()
{
	kill_brushes = getentarray( "kill_brush", "script_noteworthy" );

	if ( !IsDefined( kill_brushes ) )
	{
		return false;
	}
	
	for ( i = 0; i < kill_brushes.size; i++ )
	{

		if ( self IsTouching( kill_brushes[i] ) )
		{
			return true;
		}
	}

	return false;
}


function in_enabled_playable_area()
{
	playable_area = getentarray( "player_volume", "script_noteworthy" );

	if( !IsDefined( playable_area ) )
	{
		return false;
	}
	
	for ( i = 0; i < playable_area.size; i++ )
	{
		if ( zm_zonemgr::zone_is_enabled( playable_area[i].targetname ) && self IsTouching( playable_area[i] ) )
		{
			return true;
		}
	}

	return false;
}


function get_player_out_of_playable_area_monitor_wait_time()
{
/#
	if ( ( isdefined( level.check_kill_thread_every_frame ) && level.check_kill_thread_every_frame ) )
	{
		return 0.05;
	}
#/

	return 3;
}


function player_out_of_playable_area_monitor()
{
	self notify( "stop_player_out_of_playable_area_monitor" );
	self endon( "stop_player_out_of_playable_area_monitor" );
	self endon( "disconnect" );
	level endon( "end_game" );
	
	while(!isDefined(self.characterindex))
	{
		wait(.05);
	}
	// load balancing
	wait( (0.15 * self.characterindex) );

	while ( true )
	{
		// skip over players in spectate, otherwise Sam keeps laughing every 3 seconds since their corpse is still invisibly in a kill area
		if ( self.sessionstate == "spectator" )
		{
			wait( get_player_out_of_playable_area_monitor_wait_time() );
			continue;
		}
		
		if(( isdefined( level.hostmigration_occured ) && level.hostmigration_occured ))
		{
			wait( get_player_out_of_playable_area_monitor_wait_time() );
			continue;
		}
		
		if ( !self in_life_brush() && (self in_kill_brush() || !self in_enabled_playable_area()) )
		{
			if ( !isdefined( level.player_out_of_playable_area_monitor_callback ) || self [[level.player_out_of_playable_area_monitor_callback]]() )
			{
/#
				if ( ( isdefined( level.kill_thread_test_mode ) && level.kill_thread_test_mode ) )
				{
					PrintTopRightln( "out of playable area: " + self.origin );
					wait( get_player_out_of_playable_area_monitor_wait_time() );
					continue;
				}

				if ( self isinmovemode( "ufo", "noclip" ) || ( isdefined( level.disable_kill_thread ) && level.disable_kill_thread ) || GetDvarInt( "zombie_cheat" ) > 0 )
				{
					wait( get_player_out_of_playable_area_monitor_wait_time() );
					continue;
				}
#/

				//track the cheaters
				self zm_stats::increment_map_cheat_stat( "cheat_out_of_playable" );
				self zm_stats::increment_client_stat( "cheat_out_of_playable",false );
				self zm_stats::increment_client_stat( "cheat_total",false );
							
				self playlocalsound( level.zmb_laugh_alias );
				
				wait( 0.5 );

				if ( GetPlayers().size == 1 && level flag::get( "solo_game" ) && ( isdefined( self.waiting_to_revive ) && self.waiting_to_revive ) )
				{
					level notify( "end_game" );
				}
				else
				{
					self DisableInvulnerability();
					self.lives = 0;
					self dodamage( self.health + 1000, self.origin );
					self.bleedout_time = 0;
				}
			}
		}

		wait( get_player_out_of_playable_area_monitor_wait_time() );
	}
}


function get_player_too_many_weapons_monitor_wait_time()
{
	return 3;
}


function player_too_many_weapons_monitor_takeaway_simultaneous( primary_weapons_to_take )
{
	self endon( "player_too_many_weapons_monitor_takeaway_sequence_done" );

	self util::waittill_any( "player_downed", "replace_weapon_powerup" );

	for ( i = 0; i < primary_weapons_to_take.size; i++ )
	{
		self TakeWeapon( primary_weapons_to_take[i] );
	}

	self zm_score::player_reduce_points( "take_all" );
	self zm_utility::give_start_weapon( false );
	if ( !self laststand::player_is_in_laststand() )
	{
		self zm_utility::decrement_is_drinking();
	}
	else if ( level flag::get( "solo_game" ) )
	{
		self.score_lost_when_downed = 0;
	}

	self notify( "player_too_many_weapons_monitor_takeaway_sequence_done" );
}


function player_too_many_weapons_monitor_takeaway_sequence( primary_weapons_to_take )
{
	self thread player_too_many_weapons_monitor_takeaway_simultaneous( primary_weapons_to_take );

	self endon( "player_downed" );
	self endon( "replace_weapon_powerup" );

	self zm_utility::increment_is_drinking();
	score_decrement = zm_utility::round_up_to_ten( int( self.score / (primary_weapons_to_take.size + 1) ) );

	for ( i = 0; i < primary_weapons_to_take.size; i++ )
	{
		self playlocalsound( level.zmb_laugh_alias );
		self SwitchToWeapon( primary_weapons_to_take[i] );
		self zm_score::player_reduce_points( "take_specified", score_decrement );
		wait( 3 );

		self TakeWeapon( primary_weapons_to_take[i] );
	}

	self playlocalsound( level.zmb_laugh_alias );
	self zm_score::player_reduce_points( "take_all" );
	wait( 1 );
	self zm_utility::give_start_weapon( true );
	self zm_utility::decrement_is_drinking();

	self notify( "player_too_many_weapons_monitor_takeaway_sequence_done" );
}

function player_too_many_weapons_monitor()
{
	self notify( "stop_player_too_many_weapons_monitor" );
	self endon( "stop_player_too_many_weapons_monitor" );
	self endon( "disconnect" );
	level endon( "end_game" );

	// load balancing
	scalar = self.characterindex;
	
	if ( !isdefined( scalar ) )
	{
		scalar = self GetEntityNumber();
	}
	
	wait( (0.15 * scalar) );

	while ( true )
	{
		if ( self zm_utility::has_powerup_weapon() || self laststand::player_is_in_laststand() || self.sessionstate == "spectator" )
		{
			wait( get_player_too_many_weapons_monitor_wait_time() );
			continue;
		}

/#
		if ( GetDvarInt( "zombie_cheat" ) > 0 )
		{
			wait( get_player_too_many_weapons_monitor_wait_time() );
			continue;
		}
#/

		weapon_limit = zm_utility::get_player_weapon_limit( self );

		primaryWeapons = self GetWeaponsListPrimaries();

		if ( primaryWeapons.size > weapon_limit )
		{
			self zm_weapons::take_fallback_weapon();
			primaryWeapons = self GetWeaponsListPrimaries();
		}

		primary_weapons_to_take = [];
		for ( i = 0; i < primaryWeapons.size; i++ )
		{
			if ( zm_weapons::is_weapon_included( primaryWeapons[i] ) || zm_weapons::is_weapon_upgraded( primaryWeapons[i] ) )
			{
				primary_weapons_to_take[primary_weapons_to_take.size] = primaryWeapons[i];
			}
		}

		if ( primary_weapons_to_take.size > weapon_limit )
		{
			if ( !isdefined( level.player_too_many_weapons_monitor_callback ) || self [[level.player_too_many_weapons_monitor_callback]]( primary_weapons_to_take ) )
			{
				//track the cheaters
				self zm_stats::increment_map_cheat_stat( "cheat_too_many_weapons" );
				self zm_stats::increment_client_stat( "cheat_too_many_weapons",false );
				self zm_stats::increment_client_stat( "cheat_total",false );
				
				
				self thread player_too_many_weapons_monitor_takeaway_sequence( primary_weapons_to_take );
				self waittill( "player_too_many_weapons_monitor_takeaway_sequence_done" );
			}
		}

		wait( get_player_too_many_weapons_monitor_wait_time() );
	}
}


function player_monitor_travel_dist()
{
	self endon("disconnect");
	self notify("stop_player_monitor_travel_dist");
	self endon("stop_player_monitor_travel_dist");
	
	prevpos = self.origin;
	while(1)
	{
		wait .1;

		self.pers["distance_traveled"] += distance( self.origin, prevpos ) ; 
		prevpos = self.origin;
	}
}

function player_monitor_time_played()
{
	self endon( "disconnect" );
	self notify("stop_player_monitor_time_played");
	self endon("stop_player_monitor_time_played");

	level flag::wait_till( "start_zombie_round_logic" );
	
	for ( ;; )
	{
		wait ( 1.0 );
		zm_stats::increment_client_stat( "time_played_total" );
	}
}

function player_grenade_multiattack_bookmark_watcher( grenade )
{
	self endon( "disconnect" );

	waittillframeend;
	
	if ( !IsDefined( grenade ) )
	{
		return;
	}

	inflictorEntNum = grenade getEntityNumber();
	inflictorEntType = grenade getEntityType();
	inflictorBirthTime = 0;
	if ( isDefined( grenade.birthTime ) )
		inflictorBirthTime = grenade.birthTime;

	ret_val = grenade util::waittill_any_timeout( 15, "explode" );

	if ( !IsDefined( self ) || (IsDefined( ret_val ) && "timeout" == ret_val) )
	{
		return;
	}

	self.grenade_multiattack_count = 0;
	self.grenade_multiattack_ent = undefined;

	waittillframeend;

	if ( !IsDefined( self ) )
	{
		return;
	}

	count = level.grenade_multiattack_bookmark_count;
	if ( ( isdefined( grenade.grenade_multiattack_bookmark_count ) && grenade.grenade_multiattack_bookmark_count ) )
	{
		count = grenade.grenade_multiattack_bookmark_count;
	}

	bookmark_string = "zm_player_grenade_multiattack";
	if ( ( isdefined( grenade.use_grenade_special_long_bookmark ) && grenade.use_grenade_special_long_bookmark ) )
	{
		bookmark_string = "zm_player_grenade_special_long";
	}
	else if ( ( isdefined( grenade.use_grenade_special_bookmark ) && grenade.use_grenade_special_bookmark ) )
	{
		bookmark_string = "zm_player_grenade_special";
	}

	if ( count <= self.grenade_multiattack_count && IsDefined( self.grenade_multiattack_ent ) )
	{
		addDemoBookmark( bookmark_string, gettime(), self GetEntityNumber(), 255, 0, inflictorEntNum, inflictorEntType, inflictorBirthTime, false, self.grenade_multiattack_ent GetEntityNumber() );
	}

	self.grenade_multiattack_count = 0;
}


function player_grenade_watcher()
{
	self endon( "disconnect" );
	
	self notify("stop_player_grenade_watcher");
	self endon("stop_player_grenade_watcher");
	
	self.grenade_multiattack_count = 0;

	while ( 1 )
	{
		self waittill( "grenade_fire", grenade, weapon );

		if( isdefined( grenade ) && isalive( grenade ) )
		{
			grenade.team = self.team;
		}

		self thread player_grenade_multiattack_bookmark_watcher( grenade );

		if ( isdefined( level.grenade_watcher ) )
		{
			self [[ level.grenade_watcher ]]( grenade, weapon );
		}
	}
}

function player_prevent_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if( !isdefined( eInflictor ) || !isdefined( eAttacker ) )
	{
		return false;
	}
	
	if ( eInflictor == self || eAttacker == self )
	{
		return false;
	}

	if ( isdefined( eInflictor ) && isdefined( eInflictor.team ) )
	{
		if (!( isdefined( eInflictor.damage_own_team ) && eInflictor.damage_own_team ))
			if ( eInflictor.team == self.team )
			{
				return true;
			}
	}

	return false;
}

//
//	Keep track of players going down and getting revived
function player_revive_monitor()
{
	self endon( "disconnect" ); 
	self notify("stop_player_revive_monitor");
	self endon("stop_player_revive_monitor");
	
	while (1)
	{
		self waittill( "player_revived", reviver );	
		
		self playsoundtoplayer( "zmb_character_revived", self );
		
		if(( isdefined( level.isresetting_grief ) && level.isresetting_grief ))
		{
			continue;
		}
		
        //AYERS: Working on Laststand Audio
        //self util::clientnotify( "revived" );
        
		//self laststand_giveback_player_perks();

		if ( IsDefined(reviver) )
		{
			self zm_audio::create_and_play_dialog( "general", "revive_up" );
			
			//reviver maps\_zombiemode_rank::giveRankXp( "revive" );
			//maps\_zombiemode_challenges::doMissionCallback( "zm_revive", reviver );

			// Check to see how much money you lost from being down.
			points = self.score_lost_when_downed;
			
		/#	println( "ZM >> LAST STAND - points = " + points);	#/
			
			reviver zm_score::player_add_points( "reviver", points );
			self.score_lost_when_downed = 0;
		}
	}
}


// self = a player
// If the player has just 1 perk, they wil always get it back
// If the player has more than 1 perk, they will lose a single perk
function laststand_giveback_player_perks()
{
	if ( IsDefined( self.laststand_perks ) )
	{
		// Calculate a lost perk index
		lost_perk_index = int( -1 );
		if( self.laststand_perks.size > 1 )
		{
			lost_perk_index = RandomInt( self.laststand_perks.size-1 );
		}
		
		// Give the player back their perks
		for ( i=0; i<self.laststand_perks.size; i++ )
		{
			if ( self HasPerk( self.laststand_perks[i] ) )
			{
				continue;
			}
			if( i == lost_perk_index )
			{
				continue;
			}
			
			zm_perks::give_perk( self.laststand_perks[i] );
		}
	}
}

function remote_revive_watch()
{
	self endon( "death" );
	self endon( "player_revived" );

	keep_checking = true;
	while( keep_checking )
	{
		self waittill( "remote_revive", reviver );
	
		//Check the remote reviver is on the same team
		if( reviver.team == self.team )
			keep_checking = false;
	}
	
	self zm_laststand::remote_revive( reviver );
}

function player_laststand( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
/#	println( "ZM >> LAST STAND - player_laststand called" );	#/
	
	b_alt_visionset = false;
		
	self AllowJump(false);
	
	currWeapon = self GetCurrentWeapon();
	
	self AddWeaponStat( currWeapon, "deathsDuringUse", 1 );

	// Grab the perks if we have the player persistent ability "perk lose"
	if( ( isdefined( self.pers_upgrades_awarded["perk_lose"] ) && self.pers_upgrades_awarded["perk_lose"] ) )
	{
		self zm_pers_upgrades_functions::pers_upgrade_perk_lose_save();
	}

	players = GetPlayers();
	if ( players.size == 1 && level flag::get( "solo_game" ) )
	{
		if ( self.lives > 0 && self HasPerk("specialty_quickrevive") )
		{
			self thread wait_and_revive();
		}
	}
	
	self zm_utility::clear_is_drinking();

	self thread remote_revive_watch();
	
	self zm_score::player_downed_penalty();
	
	// Turns out we need to do this after all, but we don't want to change _laststand.gsc postship, so I'm doing it here manually instead
	self DisableOffhandWeapons();

	self thread last_stand_grenade_save_and_return();
	
	if( sMeansOfDeath != "MOD_SUICIDE" && sMeansOfDeath != "MOD_FALLING" )
	{		
		if( !( isdefined( self.intermission ) && self.intermission ) )
			self zm_audio::create_and_play_dialog( "general", "revive_down" );
		else
		{
			if(isDefined(level.custom_player_death_vo_func) && !self [[level.custom_player_death_vo_func]]() )
			{
				self zm_audio::create_and_play_dialog( "general", "exert_death" );
			}
		}
	}
	
	if( IsDefined( level._zombie_minigun_powerup_last_stand_func ) )
	{
		self thread [[level._zombie_minigun_powerup_last_stand_func]]();
	}
	
	if( IsDefined( level._zombie_tesla_powerup_last_stand_func ) )
	{
		self thread [[level._zombie_tesla_powerup_last_stand_func]]();
	}
	
	if ( self HasPerk( "specialty_electriccherry" ) )
	{
		b_alt_visionset = true;
		
		if ( IsDefined( level.custom_laststand_func ) )
		{
			self thread [[ level.custom_laststand_func ]]();
		}
	}

	if( IsDefined( self.intermission ) && self.intermission )
	{
		//maps\_zombiemode_challenges::doMissionCallback( "playerDied", self );
		
		wait(.5);
		self stopsounds();
		
		level waittill( "forever" );
	}
	
	if ( !( b_alt_visionset ) )
	{
		VisionSetLastStand( "zombie_last_stand", 1 );
	}
}


function failsafe_revive_give_back_weapons(excluded_player)
{
	for ( i = 0; i < 10; i++ )
	{
		{wait(.05);};

		players = GetPlayers();
		foreach(player in players )
		{
			if (player == excluded_player|| !isdefined( player.reviveProgressBar ) || player zm_laststand::is_reviving_any() )
			{
				continue;
			}
	
			// he's not reviving anyone but he still has revive stuff up, clean it all up
		/#
		iprintlnbold( "FAILSAFE CLEANING UP REVIVE HUD AND GUN" );
		#/
			// pass in "none" since we have no idea what the weapon they should be showing is
			player zm_laststand::revive_give_back_weapons( level.weaponNone );
		
			if ( isdefined( player.reviveProgressBar ) )
			{
				player.reviveProgressBar hud::destroyElem();
			}
		
			if ( isdefined( player.reviveTextHud ) )
			{
				player.reviveTextHud destroy();
			}		
		}
	}
}


function spawnSpectator()
{
	self endon( "disconnect" ); 
	self endon( "spawned_spectator" ); 
	self notify( "spawned" ); 
	self notify( "end_respawn" );

	if( level.intermission )
	{
		return;
	}

	if( IsDefined( level.no_spectator ) && level.no_spectator )
	{
		wait( 3 );
		ExitLevel();
	}

	// The check_for_level_end looks for this
	self.is_zombie = true;

	//failsafe against losing viewarms due to the thread returning them getting an endon from "zombified"
	level thread failsafe_revive_give_back_weapons(self);

	// Remove all reviving abilities
	self notify ( "zombified" );

	if( isdefined( self.revivetrigger ) )
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
	}

	self.zombification_time = GetTime(); //set time when player died

	resetTimeout(); 

	// Stop shellshock and rumble
	self StopShellshock(); 
	self StopRumble( "damage_heavy" ); 

	self.sessionstate = "spectator"; 
	self.spectatorclient = -1;

	self.maxhealth = self.health;
	self.shellshocked = false; 
	self.inWater = false; 
	self.friendlydamage = undefined; 
	self.hasSpawned = true; 
	self.spawnTime = GetTime(); 
	self.afk = false; 

/#	println( "*************************Zombie Spectator***" );	#/
	self detachAll();

	if( isdefined( level.custom_spectate_permissions ) )
	{
	   self [[level.custom_spectate_permissions]]();
	}
	else
	{
		self setSpectatePermissions( true );
	}
	self thread spectator_thread();

	self Spawn( self.origin, self.angles );
	self notify( "spawned_spectator" );
}

function setSpectatePermissions( isOn )
{
	self AllowSpectateTeam( "allies", isOn && self.team == "allies" );
	self AllowSpectateTeam( "axis", isOn && self.team == "axis" );
	self AllowSpectateTeam( "freelook", false );
	self AllowSpectateTeam( "none", false );	
}

function spectator_thread()
{
	self endon( "disconnect" ); 
	self endon( "spawned_player" );

/*	we are not currently supporting the shared screen tech
	if( self IsSplitScreen() )
	{
		last_alive = undefined;
		players = GetPlayers();

		for( i = 0; i < players.size; i++ )
		{
			if( !players[i].is_zombie )
			{
				last_alive = players[i];
			}
		}

		share_screen( last_alive, true );

		return;
	}
*/

//	self thread spectator_toggle_3rd_person();
}

function spectator_toggle_3rd_person()
{
	self endon( "disconnect" ); 
	self endon( "spawned_player" );

	third_person = true;
	self set_third_person( true );
}


function set_third_person( value )
{
	if( value )
	{
		self SetClientThirdPerson( 1 );
		self SetClientThirdPersonAngle( 354 );

		self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
	}
	else
	{
		self SetClientThirdPerson( 0 );
		self SetClientThirdPersonAngle( 0 );

		self setDepthOfField( 0, 0, 512, 4000, 4, 0 );
	}
	self resetFov();
}

function last_stand_revive()
{
	level endon( "between_round_over" );

	players = GetPlayers();


	//If everyone is in last stand or spectate then revive all
	laststand_count = 0;
	foreach(player in players)
	{
		if( !zm_utility::is_player_valid( player ) )
		{
			laststand_count ++;
		}
	}

	if( laststand_count == players.size )
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[i] laststand::player_is_in_laststand() && players[i].revivetrigger.beingRevived == 0 )
			{
				players[i] zm_laststand::auto_revive( players[i] );
			}
		}
	}
}

// ww: arrange the last stand pistols so when it come time to choose which one they are inited
function last_stand_pistol_rank_init()
{
	level.pistol_values = [];	
	
	// ww: in a solo game the ranking of the pistols is a bit different based on the upgraded 1911 swap
	// any pistol ranked level.pistol_value_solo_replace_below or lower will be ignored and the player will be given the upgraded 1911
	level.pistol_values[ level.pistol_values.size ] = level.default_laststandpistol;
	level.pistol_values[ level.pistol_values.size ] = GetWeapon( "kard" );
	level.pistol_values[ level.pistol_values.size ] = GetWeapon( "beretta93r" );
	level.pistol_values[ level.pistol_values.size ] = GetWeapon( "beretta93r_extclip" );
	level.pistol_values[ level.pistol_values.size ] = GetWeapon( "python" );
	level.pistol_values[ level.pistol_values.size ] = GetWeapon( "kard_upgraded" );
	level.pistol_value_solo_replace_below = level.pistol_values.size-1;  // EO: anything scoring lower than this should be replaced
	level.pistol_values[ level.pistol_values.size ] = level.default_solo_laststandpistol;
	level.pistol_values[ level.pistol_values.size ] = GetWeapon( "beretta93r_upgraded" );
	level.pistol_values[ level.pistol_values.size ] = GetWeapon( "beretta93r_extclip_upgraded" );
	level.pistol_values[ level.pistol_values.size ] = GetWeapon( "python_upgraded" );
	level.pistol_values[ level.pistol_values.size ] = GetWeapon( "ray_gun" );
	level.pistol_values[ level.pistol_values.size ] = GetWeapon( "raygun_mark2" );
	level.pistol_values[ level.pistol_values.size ] = GetWeapon( "ray_gun_upgraded" );
	level.pistol_values[ level.pistol_values.size ] = GetWeapon( "raygun_mark2_upgraded" );
}

function last_stand_pistol_swap()
{
	if ( self zm_utility::has_powerup_weapon() )
	{
		// this will force the laststand module to switch us to any primary weapon, since we will no longer have this after revive
		self.lastActiveWeapon = level.weaponNone;
	}

	if ( !self HasWeapon( self.laststandpistol ) )
	{
		self GiveWeapon( self.laststandpistol );
	}
	ammoclip = self.laststandpistol.clipSize;
	doubleclip = ammoclip * 2;
	
	if( ( isdefined( self._special_solo_pistol_swap ) && self._special_solo_pistol_swap ) || (self.laststandpistol == level.default_solo_laststandpistol && !self.hadpistol) )
	{
		self._special_solo_pistol_swap = 0;
		self.hadpistol = false;
		self SetWeaponAmmoStock( self.laststandpistol, doubleclip );
	}
	else if( level flag::get("solo_game") && self.laststandpistol == level.default_solo_laststandpistol )
	{
		self SetWeaponAmmoStock( self.laststandpistol, doubleclip );
	}
	else if ( self.laststandpistol == level.default_laststandpistol )
	{
		self SetWeaponAmmoStock( self.laststandpistol, doubleclip );
	}
	else if ( self.laststandpistol.name == "ray_gun" || self.laststandpistol.name == "ray_gun_upgraded" )
	{
		if ( self.stored_weapon_info[ self.laststandpistol ].total_amt >= ammoclip )
		{
			self SetWeaponAmmoClip( self.laststandpistol, ammoclip );
			self.stored_weapon_info[ self.laststandpistol ].given_amt = ammoclip;
		}
		else
		{
			self SetWeaponAmmoClip( self.laststandpistol, self.stored_weapon_info[ self.laststandpistol ].total_amt );
			self.stored_weapon_info[ self.laststandpistol ].given_amt = self.stored_weapon_info[ self.laststandpistol ].total_amt;
		}
		self SetWeaponAmmoStock( self.laststandpistol, 0 );
	}
	else
	{
		if ( self.stored_weapon_info[ self.laststandpistol ].stock_amt >= doubleclip )
		{
			self SetWeaponAmmoStock( self.laststandpistol, doubleclip );
			self.stored_weapon_info[ self.laststandpistol ].given_amt = doubleclip + self.stored_weapon_info[ self.laststandpistol ].clip_amt + self.stored_weapon_info[ self.laststandpistol ].left_clip_amt;
		}
		else
		{
			self SetWeaponAmmoStock( self.laststandpistol, self.stored_weapon_info[ self.laststandpistol ].stock_amt );
			self.stored_weapon_info[ self.laststandpistol ].given_amt = self.stored_weapon_info[ self.laststandpistol ].total_amt;
		}
	}
	
	self SwitchToWeapon( self.laststandpistol );
}

// ww: make sure the player has the best pistol when they go in to last stand
function last_stand_best_pistol()
{
	pistol_array = [];

	current_weapons = self GetWeaponsListPrimaries();
	
	for( i = 0; i < current_weapons.size; i++ )
	{
		// make sure the weapon is a pistol
		wclass = current_weapons[i].weapClass;
		if ( current_weapons[i].isBallisticKnife )
		{
			wclass = "knife";
		}
		
		if ( wclass == "pistol" || wclass == "pistolspread" || wclass == "pistol spread" )
		{
			if ( (current_weapons[i] != level.default_solo_laststandpistol && !level flag::get("solo_game") )  || (!level flag::get("solo_game") && current_weapons[i] != level.default_solo_laststandpistol ))
			{
				if ( self GetAmmoCount( current_weapons[i] ) <= 0 )
				{
					continue;
				}
			}

			pistol_array_index = pistol_array.size; // set up the spot in the array 
			pistol_array[ pistol_array_index ] = SpawnStruct(); // struct to store info on
			
			pistol_array[ pistol_array_index ].weapon = current_weapons[i];
			pistol_array[ pistol_array_index ].value = 0; // add a value in case a new weapon is introduced that hasn't been set up in level.pistol_values
			
			// compare the current weapon to the level.pistol_values to see what the value is
			for( j = 0; j < level.pistol_values.size; j++ )
			{
				if( level.pistol_values[j] == current_weapons[i].rootWeapon )
				{
					pistol_array[ pistol_array_index ].value = j;
					break;
				}
			}
		}
	}
	
	self.laststandpistol = last_stand_compare_pistols( pistol_array );
}

// ww: compares the array passed in for the highest valued pistol
function last_stand_compare_pistols( struct_array )
{
	if( !IsArray( struct_array ) || struct_array.size <= 0 )
	{
		self.hadpistol = false;
		
		//array will be empty if the pistol had no ammo...so lets see if the player had the pistol
		if(isDefined(self.stored_weapon_info))
		{
			stored_weapon_info = GetArrayKeys( self.stored_weapon_info );
			for( j = 0; j < stored_weapon_info.size; j++ )
			{
				if( stored_weapon_info[ j ].rootWeapon == level.laststandpistol)
				{
					self.hadpistol = true;
					return stored_weapon_info[ j ];
				}
			}
		}
				
		return level.laststandpistol; // nothing in the array then give the level last stand pistol
	}
	
	highest_score_pistol = struct_array[0]; // first time through give the first one to the highest score

	for( i = 1; i < struct_array.size; i++ )
	{
		if( struct_array[i].value > highest_score_pistol.value )
		{
			highest_score_pistol = struct_array[i];
		}
	}

	if( level flag::get( "solo_game" ) )
	{
		self._special_solo_pistol_swap = 0; // ww: this way the weapon knows to pack texture when given
		if( highest_score_pistol.value <= level.pistol_value_solo_replace_below ) 
		{
			self.hadpistol = false;
			self._special_solo_pistol_swap = 1;

			if ( ( isdefined( level.force_solo_quick_revive ) && level.force_solo_quick_revive ) && ( !self HasPerk( "specialty_quickrevive" ) ) )
			{
				return highest_score_pistol.weapon; // ar: gun won't be replaced
			}
			else
			{
				return level.laststandpistol; // ww: if it scores too low the player gets the 1911 upgraded
			}
		}
		else
		{
			return highest_score_pistol.weapon; // ww: gun is high in ranking and won't be replaced
		}
	}
	else // ww: happens when not in solo
	{
		return highest_score_pistol.weapon;
	}

}

// ww: override function for saving player pistol ammo count
function last_stand_save_pistol_ammo()
{
	weapon_inventory = self GetWeaponsList( true );
	self.stored_weapon_info = [];

	for( i = 0; i < weapon_inventory.size; i++ )
	{
		weapon = weapon_inventory[i];

		wclass = weapon.weapClass;
		if ( weapon.isBallisticKnife )
		{
			wclass = "knife";
		}
		
		if ( wclass == "pistol" || wclass == "pistolspread" || wclass == "pistol spread" ) 
		{
			self.stored_weapon_info[ weapon ] = SpawnStruct();
			self.stored_weapon_info[ weapon ].clip_amt = self GetWeaponAmmoClip( weapon );
			self.stored_weapon_info[ weapon ].left_clip_amt = 0;
			dual_wield_weapon = weapon.dualWieldWeapon;
			if ( level.weaponNone != dual_wield_weapon )
			{
				self.stored_weapon_info[ weapon ].left_clip_amt = self GetWeaponAmmoClip( dual_wield_weapon );
			}
			self.stored_weapon_info[ weapon ].stock_amt = self GetWeaponAmmoStock( weapon );
			self.stored_weapon_info[ weapon ].total_amt = self.stored_weapon_info[ weapon ].clip_amt + self.stored_weapon_info[ weapon ].left_clip_amt + self.stored_weapon_info[ weapon ].stock_amt;
			self.stored_weapon_info[ weapon ].given_amt = 0;
		}
	}
	
	self last_stand_best_pistol();
}

// ww: override to restore the player's pistol ammo after being picked up
function last_stand_restore_pistol_ammo()
{
	self.weapon_taken_by_losing_specialty_additionalprimaryweapon = level.weaponNone;

	if ( !IsDefined( self.stored_weapon_info ) )
	{
		return;
	}
	
	weapon_inventory = self GetWeaponsList( true );
	weapon_to_restore = GetArrayKeys( self.stored_weapon_info );
	
	for( i = 0; i < weapon_inventory.size; i++ )
	{
		weapon = weapon_inventory[i];
		
		if ( weapon != self.laststandpistol )
		{
			continue;
		}
		
		for( j = 0; j < weapon_to_restore.size; j++ )
		{
			if ( weapon == weapon_to_restore[j] )
			{
				dual_wield_weapon = weapon_to_restore[j].dualWieldWeapon;
				if ( weapon != level.default_laststandpistol )
				{
					last_clip = self GetWeaponAmmoClip( weapon );
					last_left_clip = 0;
					if ( level.weaponNone != dual_wield_weapon )
					{
						last_left_clip = self GetWeaponAmmoClip( dual_wield_weapon );
					}
					last_stock = self GetWeaponAmmoStock( weapon );
					last_total = last_clip + last_left_clip + last_stock;

					used_amt = self.stored_weapon_info[ weapon ].given_amt - last_total;

					if ( used_amt >= self.stored_weapon_info[ weapon ].stock_amt )
					{
						used_amt -= self.stored_weapon_info[ weapon ].stock_amt;
						self.stored_weapon_info[ weapon ].stock_amt = 0;

						self.stored_weapon_info[ weapon ].clip_amt -= used_amt;
						if ( self.stored_weapon_info[ weapon ].clip_amt < 0 )
						{
							self.stored_weapon_info[ weapon ].clip_amt = 0;
						}
					}
					else 
					{
						new_stock_amt = self.stored_weapon_info[ weapon ].stock_amt - used_amt;
						if ( new_stock_amt < self.stored_weapon_info[ weapon ].stock_amt )
						{
							self.stored_weapon_info[ weapon ].stock_amt = new_stock_amt;
						}
					}
				}

				self SetWeaponAmmoClip( weapon, self.stored_weapon_info[weapon].clip_amt );
				if ( level.weaponNone != dual_wield_weapon )
				{
					self SetWeaponAmmoClip( dual_wield_weapon, self.stored_weapon_info[weapon].left_clip_amt );
				}
				self SetWeaponAmmoStock( weapon, self.stored_weapon_info[weapon].stock_amt );
				break;
			}
		}
	}
}

function last_stand_take_thrown_grenade()
{
	self endon( "disconnect" );
	self endon( "bled_out" );
	self endon( "player_revived" );
	
	self waittill ( "grenade_fire", grenade, weapon );

	if ( isdefined(self.lsgsar_lethal) && weapon == self.lsgsar_lethal )
	{
		self.lsgsar_lethal_nade_amt--;
	}

	if ( isdefined(self.lsgsar_tactical) && weapon == self.lsgsar_tactical )
	{
		self.lsgsar_tactical_nade_amt--;
	}
}

// ww: zeros out the player's grenades until they revive
function last_stand_grenade_save_and_return()
{
	if(( isdefined( level.isresetting_grief ) && level.isresetting_grief )) //don't do this for Grief when resetting the round
	{
		return;
	}
	self endon( "disconnect" );
	self endon ("bled_out");
	level endon( "between_round_over" );
	
	self.lsgsar_lethal_nade_amt = 0;
	self.lsgsar_has_lethal_nade = false;
	self.lsgsar_tactical_nade_amt = 0;
	self.lsgsar_has_tactical_nade = false;
	self.lsgsar_lethal = undefined;
	self.lsgsar_tactical = undefined;

	if (self IsThrowingGrenade())
	{
		self thread last_stand_take_thrown_grenade();
	}
	
	weapon = self zm_utility::get_player_lethal_grenade();
	if ( weapon != level.weaponNone )
	{
		self.lsgsar_has_lethal_nade = true;
		self.lsgsar_lethal = weapon;
		self.lsgsar_lethal_nade_amt = self GetWeaponAmmoClip( weapon );
		self SetWeaponAmmoClip( weapon, 0 );
		self TakeWeapon( weapon );
	}

	weapon = self zm_utility::get_player_tactical_grenade();
	if ( weapon != level.weaponNone )
	{
		self.lsgsar_has_tactical_nade = true;
		self.lsgsar_tactical = weapon;
		self.lsgsar_tactical_nade_amt = self GetWeaponAmmoClip( weapon );
		self SetWeaponAmmoClip( weapon, 0 );
		self TakeWeapon( weapon );
	}
	
	self waittill( "player_revived" );
	
	if ( self.lsgsar_has_lethal_nade )
	{
		self zm_utility::set_player_lethal_grenade( self.lsgsar_lethal );
		self GiveWeapon( self.lsgsar_lethal );
		self SetWeaponAmmoClip( self.lsgsar_lethal, self.lsgsar_lethal_nade_amt );
	}
	
	if ( self.lsgsar_has_tactical_nade )
	{
		self zm_utility::set_player_tactical_grenade( self.lsgsar_tactical );
		self GiveWeapon( self.lsgsar_tactical );
		self SetWeaponAmmoClip( self.lsgsar_tactical, self.lsgsar_tactical_nade_amt );
	}

	self.lsgsar_lethal_nade_amt = undefined;
	self.lsgsar_has_lethal_nade = undefined;
	self.lsgsar_tactical_nade_amt = undefined;
	self.lsgsar_has_tactical_nade = undefined;
	self.lsgsar_lethal = undefined;
	self.lsgsar_tactical = undefined;

}

function spectators_respawn()
{
	level endon( "between_round_over" );

	if( !IsDefined( level.zombie_vars["spectators_respawn"] ) || !level.zombie_vars["spectators_respawn"] )
	{
		return;
	}

	if( !IsDefined( level.custom_spawnPlayer ) )
	{
		// Custom spawn call for when they respawn from spectator
		level.custom_spawnPlayer = &spectator_respawn;
	}

	while( 1 )
	{
		players = GetPlayers();
		for( i = 0; i < players.size; i++ )
		{
			if( players[i].sessionstate == "spectator" && IsDefined( players[i].spectator_respawn ))	
			{
				players[i] [[level.spawnPlayer]]();
				thread refresh_player_navcard_hud();
				if (isDefined(level.script) && level.round_number > 6 && players[i].score < 1500)
				{
					players[i].old_score = players[i].score;
					if(isDefined(level.spectator_respawn_custom_score))
					{
						players[i] [[level.spectator_respawn_custom_score]]();
					}
					players[i].score = 1500;
				}
			}
		}

		wait( 1 );
	}
}

function spectator_respawn()
{
/#	println( "*************************Respawn Spectator***" );	#/
	assert( IsDefined( self.spectator_respawn ) );

	origin = self.spectator_respawn.origin;
	angles = self.spectator_respawn.angles;

	self setSpectatePermissions( false );

	new_origin = undefined;
	
	
	if ( isdefined( level.check_valid_spawn_override ) )
	{
		new_origin = [[ level.check_valid_spawn_override ]]( self );
	}

	if ( !isdefined( new_origin ) )
	{
		new_origin = check_for_valid_spawn_near_team( self,true );
	}
	

	if( IsDefined( new_origin ) )
	{
		if(!isDefined(new_origin.angles))
		{
			angles = (0, 0, 0);
		}
		else
		{	
			angles = new_origin.angles;
		}	
		self Spawn( new_origin.origin, angles );
	}
	else
	{
		self Spawn( origin, angles );
	}


	if ( IsDefined( self zm_utility::get_player_placeable_mine() ) )
	{
		self TakeWeapon( self zm_utility::get_player_placeable_mine() );
		self zm_utility::set_player_placeable_mine( level.weaponNone );
	}

	self zm_equipment::take();

	self.is_burning = undefined;
	self.abilities = [];

	// The check_for_level_end looks for this
	self.is_zombie = false;
	zm_laststand::set_ignoreme( false );

	self clientfield::set( "zmbLastStand", 0 );
	self RevivePlayer();

	self notify( "spawned_player" );
	self callback::callback( #"on_player_spawned" );

	if(IsDefined(level._zombiemode_post_respawn_callback))
	{
		self thread [[level._zombiemode_post_respawn_callback]]();
	}
	
	// Penalize the player when we respawn, since he 'died'
	self zm_score::player_reduce_points( "died" );
	
	self zm_melee_weapon::spectator_respawn_all();

	self thread player_zombie_breadcrumb();

	self thread zm_perks::return_retained_perks();
	
	return true;
}


//*****************************************************************************
//*****************************************************************************

function check_for_valid_spawn_near_team( revivee, return_struct )
{
	// if level override is detected, use it instead of normal respawn logic
	if ( IsDefined( level.check_for_valid_spawn_near_team_callback ) )
	{
		spawn_location = [[ level.check_for_valid_spawn_near_team_callback ]](revivee, return_struct);
		return spawn_location;
	}
	else  // normal respawn logic below here
	{
		players = GetPlayers();
		spawn_points = zm_gametype::get_player_spawns_for_gametype();
		
		closest_group = undefined;
		closest_distance = 100000000;
		backup_group = undefined;
		backup_distance = 100000000;
	
		if( spawn_points.size == 0 )
			return undefined;
	
		// Look for the closest group that is within the specified ideal distances
		//	If we can't find one within a valid area, use the closest unlocked group.
		for( i = 0; i < players.size; i++ )
		{
			if( zm_utility::is_player_valid( players[i],undefined,true ) && (players[i] != self) )
			{
				for( j = 0 ; j < spawn_points.size; j++ )
				{
					if( isdefined(spawn_points[j].script_int) )
						ideal_distance = spawn_points[j].script_int;
					else
						ideal_distance = 1000;
	
					if ( spawn_points[j].locked == false )
					{
						plyr_dist = DistanceSquared( players[i].origin, spawn_points[j].origin );
						if( plyr_dist < ( ideal_distance * ideal_distance ) )
						{
							if ( plyr_dist < closest_distance )
							{
								closest_distance = plyr_dist;
								closest_group = j;
							}
						}
						else
						{
							if ( plyr_dist < backup_distance )
							{
								backup_group = j;
								backup_distance = plyr_dist;
							}
						}
					}
				}
			}
	
			//	If we don't have a closest_group, let's use the backup
			if( !IsDefined( closest_group ) )
			{
				closest_group = backup_group;
			}
	
			if( IsDefined( closest_group ) )
			{
				spawn_location = get_valid_spawn_location( revivee, spawn_points, closest_group, return_struct );
				if( IsDefined(spawn_location) )
				{
					return( spawn_location );
				}
			}
		}
	
		return undefined;
	}
}


//*****************************************************************************
//*****************************************************************************

function get_valid_spawn_location( revivee, spawn_points, closest_group, return_struct )
{
	spawn_array =struct::get_array( spawn_points[closest_group].target, "targetname" );
	spawn_array = array::randomize(spawn_array);
			
	for( k = 0; k < spawn_array.size; k++ )
	{
		if(IsDefined(spawn_array[k].plyr) && spawn_array[k].plyr == revivee GetEntityNumber())
		{
			if(positionWouldTelefrag(spawn_array[k].origin))
			{
				spawn_array[k].plyr = undefined;
				break;
			}
			else if(( isdefined( return_struct ) && return_struct ))
			{
				return spawn_array[k];
			}
			else
			{			
				return spawn_array[k].origin;
			}
		}	
	}
			
	for( k = 0; k < spawn_array.size; k++ )
	{
		if(positionWouldTelefrag(spawn_array[k].origin))
		{
			continue;
		}
		if(!IsDefined(spawn_array[k].plyr) || spawn_array[k].plyr == revivee GetEntityNumber())
		{
			spawn_array[k].plyr = revivee GetEntityNumber();
			if(( isdefined( return_struct ) && return_struct ))
			{
				return spawn_array[k];
			}
			else
			{			
				return spawn_array[k].origin;
			}
		}
	}	

	if(( isdefined( return_struct ) && return_struct ))
	{
		return spawn_array[0];
	}
			
	return spawn_array[0].origin;
}


//*****************************************************************************
//*****************************************************************************

function check_for_valid_spawn_near_position( revivee, v_position, return_struct )
{
	spawn_points = zm_gametype::get_player_spawns_for_gametype();

	if( spawn_points.size == 0 )
	{
		return( undefined );
	}
	
	closest_group = undefined;
	closest_distance = 100000000;
	backup_group = undefined;
	backup_distance = 100000000;

	for( i=0 ; i<spawn_points.size; i++ )
	{
		if( IsDefined(spawn_points[i].script_int) )
		{
			ideal_distance = spawn_points[i].script_int;
		}
		else
		{
			ideal_distance = 1000;
		}

		if ( spawn_points[i].locked == false )
		{
			dist = DistanceSquared( v_position, spawn_points[i].origin );
			if( dist < ( ideal_distance * ideal_distance ) )
			{
				if ( dist < closest_distance )
				{
					closest_distance = dist;
					closest_group = i;
				}
			}
			else
			{
				if ( dist < backup_distance )
				{
					backup_group = i;
					backup_distance = dist;
				}
			}
		}
		//	If we don't have a closest_group, let's use the backup
		if ( !IsDefined( closest_group ) )
		{
			closest_group = backup_group;
		}
	}

	if( IsDefined( closest_group ) )
	{
		spawn_location = get_valid_spawn_location( revivee, spawn_points, closest_group, return_struct );
		if( IsDefined(spawn_location) )
		{
			return( spawn_location );
		}
	}

	return undefined;
}



//*****************************************************************************
// Get a valid spawn point within the (min_distance, max_distance) ranges
//*****************************************************************************

function check_for_valid_spawn_within_range( revivee, v_position, return_struct, min_distance, max_distance )
{
	spawn_points = zm_gametype::get_player_spawns_for_gametype();

	if( spawn_points.size == 0 )
	{
		return( undefined );
	}
	
	closest_group = undefined;
	closest_distance = 100000000;

	for( i=0 ; i<spawn_points.size; i++ )
	{
		if ( spawn_points[i].locked == false )
		{
			dist = Distance( v_position, spawn_points[i].origin );
			if( (dist >= min_distance) && (dist <= max_distance) )
			{
				if( dist < closest_distance )
				{
					closest_distance = dist;
					closest_group = i;
				}
			}
		}
	}

	if( IsDefined( closest_group ) )
	{
		spawn_location = get_valid_spawn_location( revivee, spawn_points, closest_group, return_struct );
		if( IsDefined(spawn_location) )
		{
			return( spawn_location );
		}
	}

	return undefined;
}


//*****************************************************************************
//*****************************************************************************

function get_players_on_team(exclude)
{
	teammates = [];

	players = GetPlayers();
	for(i=0;i<players.size;i++)
	{		
		//check to see if other players on your team are alive and not waiting to be revived
		if(players[i].spawn_side == self.spawn_side && !isDefined(players[i].revivetrigger) && players[i] != exclude )
		{
			teammates[teammates.size] = players[i];
		}
	}

	return teammates;
}



function get_safe_breadcrumb_pos( player )
{
	players = GetPlayers();
	valid_players = [];

	min_dist = 150 * 150;
	for( i = 0; i < players.size; i++ )
	{
		if( !zm_utility::is_player_valid( players[i] ) )
		{
			continue;
		}

		valid_players[valid_players.size] = players[i];
	}

	for( i = 0; i < valid_players.size; i++ )
	{
		count = 0;
		for( q = 1; q < player.zombie_breadcrumbs.size; q++ )
		{
			if( DistanceSquared( player.zombie_breadcrumbs[q], valid_players[i].origin ) < min_dist )
			{
				continue;
			}
			
			count++;
			if( count == valid_players.size )
			{
				return player.zombie_breadcrumbs[q];
			}
		}
	}

	return undefined;
}

function round_spawning()
{
	level endon( "intermission" );
	level endon( "end_of_round" );
	level endon( "restart_round" );
/#
	level endon( "kill_round" );
#/

	if( level.intermission )
	{
		return;
	}

	if ( cheat_enabled( 2 ) ) 
	{
		return;
	}

	if( level.zm_loc_types[ "zombie_location" ].size < 1 )
	{
		ASSERTMSG( "No active spawners in the map.  Check to see if the zone is active and if it's pointing to spawners." ); 
		return; 
	}

	zombie_utility::ai_calculate_health( level.round_number ); 

	count = 0; 

	//CODER MOD: TOMMY K
	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i].zombification_time = 0;
	}

	// Now set the total for the new round, except when it's already been set by the kill counter
	if ( !( IsDefined( level.kill_counter_hud ) && level.zombie_total > 0 ) )
	{
		level.zombie_total = get_zombie_count_for_round( level.round_number, level.players.size );
		level.zombie_respawns = 0;	// reset number of zombies needing respawn
		level notify( "zombie_total_set" );
	}
	
	if ( IsDefined( level.zombie_total_set_func ) )
	{
		level thread [[ level.zombie_total_set_func ]]();
	}
	 
	if ( level.round_number < 10 || level.speed_change_max > 0 )
	{
		level thread zombie_utility::zombie_speed_up();
	}
	
	old_spawn = undefined;
	while( 1 )
	{
		while( zombie_utility::get_current_zombie_count() >= level.zombie_ai_limit || level.zombie_total <= 0 )
		{
			wait( 0.1 );
		}
		
		while ( zombie_utility::get_current_actor_count() >= level.zombie_actor_limit )
		{
			zombie_utility::clear_all_corpses();
			wait( 0.1 );
		}

		// added ability to pause zombie spawning
		level flag::wait_till( "spawn_zombies" );
		
		//Not great fix for this being zero - which it should NEVER be! (2 days to ship - PETER)
		while( level.zm_loc_types[ "zombie_location" ].size <= 0 )
		{
			wait( 0.1 );
		}
		
		run_custom_ai_spawn_checks();
		
		//	Run custom round spawn logic - returns TRUE if we spawned something, FALSE if we need to spawn a zombie.
		if ( isdefined( level.fn_custom_round_ai_spawn ) )
		{
			if ( [[ level.fn_custom_round_ai_spawn ]]() )
			{
				// we handled the spawn
				util::wait_network_frame();
				continue;
			}
		}

		if( IsDefined( level.zombie_spawners ) )
		{
			// Check for custom zombie spawner selection
			if ( isdefined( level.fn_custom_zombie_spawner_selection ) )
			{
				spawner = [[ level.fn_custom_zombie_spawner_selection ]]();
			}

			// Default zombie spawner selection
			else
			{
				if( ( isdefined( level.use_multiple_spawns ) && level.use_multiple_spawns ) )
				{
					if( isdefined( level.spawner_int ) && ( isdefined( level.zombie_spawn[level.spawner_int].size ) && level.zombie_spawn[level.spawner_int].size ) )
					{
						spawner = array::random( level.zombie_spawn[level.spawner_int] );
					}
					else
					{
						spawner = array::random( level.zombie_spawners );
					}				
				}
				else
				{
					spawner = array::random( level.zombie_spawners );
				}
			}

			ai = zombie_utility::spawn_zombie( spawner, spawner.targetname ); 
 		}
 		
		if( IsDefined( ai ) )
		{
			level.zombie_total--;
			if ( level.zombie_respawns > 0 )
			{
				level.zombie_respawns--;
			}

			ai thread zombie_utility::round_spawn_failsafe();
			count++; 
			
			ai ai::set_behavior_attribute("can_juke", false);

			// Get zombies into the map quicker if they're respawning from cleanup
			if ( level.zombie_respawns > 0 && level.zombie_vars["zombie_spawn_delay"] > 1.0 )
			{
				wait 1.0;
			}
			else
			{
				wait( level.zombie_vars["zombie_spawn_delay"] );
			}
		}

		util::wait_network_frame();
	}
}

function get_zombie_count_for_round( n_round, n_player_count )
{
	max = level.zombie_vars["zombie_max_ai"];

	multiplier = n_round / 5;
	if( multiplier < 1 )
	{
		multiplier = 1;
	}

	// After round 10, exponentially have more AI attack the player
	if( n_round >= 10 )
	{
		multiplier *= n_round * 0.15;
	}

	if( n_player_count == 1 )
	{
		max += int( ( 0.5 * level.zombie_vars["zombie_ai_per_player"] ) * multiplier ); 
	}
	else
	{
		max += int( ( ( n_player_count - 1 ) * level.zombie_vars["zombie_ai_per_player"] ) * multiplier ); 
	}

	if( !isDefined( level.max_zombie_func ) )
	{
		level.max_zombie_func = &zombie_utility::default_max_zombie_func;
	}

	n_zombie_count = [[ level.max_zombie_func ]]( max, n_round );
	
	return n_zombie_count;
}

// Add custom ai (quads, etc.) to zombie spawner arrays for spawning
function run_custom_ai_spawn_checks()
{
	foreach ( str_id, s in level.custom_ai_spawn_check_funcs )
	{
		if ( [[ s.func_check ]]() )
		{
			a_spawners = [[ s.func_get_spawners ]]();
			level.zombie_spawners = ArrayCombine( level.zombie_spawners, a_spawners, false, false );
				
			if ( ( isdefined( level.use_multiple_spawns ) && level.use_multiple_spawns ) )
			{
				foreach ( sp in a_spawners )
				{
					if ( IsDefined( sp.script_int ) )
					{
						if ( !IsDefined( level.zombie_spawn[ sp.script_int ] ) )
						{
							level.zombie_spawn[ sp.script_int ] = [];
						}
						
						if ( !IsInArray( level.zombie_spawn[ sp.script_int ], sp ) )
						{
							if ( !isdefined( level.zombie_spawn[ sp.script_int ] ) ) level.zombie_spawn[ sp.script_int ] = []; else if ( !IsArray( level.zombie_spawn[ sp.script_int ] ) ) level.zombie_spawn[ sp.script_int ] = array( level.zombie_spawn[ sp.script_int ] ); level.zombie_spawn[ sp.script_int ][level.zombie_spawn[ sp.script_int ].size]=sp;;
						}
					}
				}
			}
			
			if ( IsDefined( s.func_get_locations ) )
			{
				a_locations = [[ s.func_get_locations ]]();
				level.zm_loc_types[ "zombie_location" ] = ArrayCombine( level.zm_loc_types[ "zombie_location" ], a_locations, false, false );
			}
		}
		else
		{
			a_spawners = [[ s.func_get_spawners ]]();
			
			foreach ( sp in a_spawners )
			{
				ArrayRemoveValue( level.zombie_spawners, sp );
			}
			
			if ( ( isdefined( level.use_multiple_spawns ) && level.use_multiple_spawns ) )
			{
				foreach ( sp in a_spawners )
				{
					if ( IsDefined( sp.script_int ) && IsDefined( level.zombie_spawn[ sp.script_int ] ) )
					{
						ArrayRemoveValue( level.zombie_spawn[ sp.script_int ], sp );
					}
				}
			}
			
			if ( IsDefined( s.func_get_locations ) )
			{
				a_locations = [[ s.func_get_locations ]]();
			
				foreach ( s_loc in a_locations )
				{
					ArrayRemoveValue( level.zm_loc_types[ "zombie_location" ], s_loc );
				}
			}
		}
	}
}

function register_custom_ai_spawn_check( str_id, func_check, func_get_spawners, func_get_locations )
{
	if ( !IsDefined( level.custom_ai_spawn_check_funcs[str_id] ) )
	{
		level.custom_ai_spawn_check_funcs[ str_id ] = SpawnStruct();
	}
	
	level.custom_ai_spawn_check_funcs[ str_id ].func_check = func_check;
	level.custom_ai_spawn_check_funcs[ str_id ].func_get_spawners = func_get_spawners;
	level.custom_ai_spawn_check_funcs[ str_id ].func_get_locations = func_get_locations;
}

// TESTING: spawn one zombie at a time
function round_spawning_test()
{
	while (true)
	{
		spawn_point = array::random( level.zm_loc_types[ "zombie_location" ] );	// grab a random spawner

		spawner = array::random(level.zombie_spawners);		
		ai = zombie_utility::spawn_zombie( spawner,spawner.targetname,spawn_point); 
		
		ai waittill("death");

		wait 5;
	}
}


/////////////////////////////////////////////////////////

// round_text( text )
// {
// 	if( level.first_round )
// 	{
// 		intro = true;
// 	}
// 	else
// 	{
// 		intro = false;
// 	}
// 
// 	hud = create_simple_hud();
// 	hud.horzAlign = "center"; 
// 	hud.vertAlign = "middle";
// 	hud.alignX = "center"; 
// 	hud.alignY = "middle";
// 	hud.y = -100;
// 	hud.foreground = 1;
// 	hud.fontscale = 16.0;
// 	hud.alpha = 0; 
// 	hud.color = ( 1, 1, 1 );
// 
// 	hud SetText( text ); 
// 	hud FadeOverTime( 1.5 );
// 	hud.alpha = 1;
// 	wait( 1.5 );
// 
// 	if( intro )
// 	{
// 		wait( 1 );
// 		level notify( "intro_change_color" );
// 	}
// 
// 	hud FadeOverTime( 3 );
// 	//hud.color = ( 0.8, 0, 0 );
// 	hud.color = ( 0.21, 0, 0 );
// 	wait( 3 );
// 
// 	if( intro )
// 	{
// 		level waittill( "intro_hud_done" );
// 	}
// 
// 	hud FadeOverTime( 1.5 );
// 	hud.alpha = 0;
// 	wait( 1.5 ); 
// 	hud destroy();
// }


//	Allows the round to be paused.  Displays a countdown timer.
//
function round_pause( delay )
{
	if ( !IsDefined( delay ) )
	{
		delay = 30;
	}

	level.countdown_hud = zm_utility::create_counter_hud();
	level.countdown_hud SetValue( delay );
	level.countdown_hud.color = ( 1, 1, 1 );
	level.countdown_hud.alpha = 1;
	level.countdown_hud FadeOverTime( 2.0 );
	wait( 2.0 );

	level.countdown_hud.color = ( 0.21, 0, 0 );
	level.countdown_hud FadeOverTime( 3.0 );
	wait(3);

	while (delay >= 1)
	{
		wait (1);
		delay--;
		level.countdown_hud SetValue( delay );
	}

	// Zero!  Play end sound
	players = GetPlayers();
	for (i=0; i<players.size; i++ )
	{
		players[i] playlocalsound( "zmb_perks_packa_ready" );
	}

	level.countdown_hud FadeOverTime( 1.0 );
	level.countdown_hud.color = (1,1,1);
	level.countdown_hud.alpha = 0;
	wait( 1.0 );

	level.countdown_hud zm_utility::destroy_hud();
}


//	Zombie spawning
//
function round_start()
{
	if ( !isdefined( level.zombie_spawners) || level.zombie_spawners.size == 0 )
	{
		/#PrintLn("***Warning: No spawners found for this level.***");#/
			level flag::set( "begin_spawning" );
			return;
	}
/#	PrintLn( "ZM >> round_start start" );	#/

	if ( IsDefined(level.round_prestart_func) )
	{
		[[ level.round_prestart_func ]]();
	}
	else
	{
		n_delay = 2;
		
		if ( IsDefined( level.zombie_round_start_delay ) )
		{
			n_delay = level.zombie_round_start_delay;
		}
		
		wait n_delay;
	}

	level.zombie_health = level.zombie_vars["zombie_health_start"]; 

	if( GetDvarInt( "scr_writeconfigstrings" ) == 1 )
	{
		wait(5);
		ExitLevel();
		return;
	}

	if ( level.zombie_vars["game_start_delay"] > 0 )
	{
		round_pause( level.zombie_vars["game_start_delay"] );
	}

	level flag::set( "begin_spawning" );

	if( !isDefined(level.round_spawn_func) )
	{
		level.round_spawn_func = &round_spawning;
	}
	
	if(!IsDefined(level.move_spawn_func))
	{
		level.move_spawn_func	= &zm_utility::move_zombie_spawn_location;
	}	
	
/#
	if (GetDvarInt( "zombie_rise_test") )
	{
		level.round_spawn_func = &round_spawning_test;		// FOR TESTING, one zombie at a time, no round advancement
	}
#/

	if ( !isDefined(level.round_wait_func) )
	{
		level.round_wait_func = &round_wait;
	}

	if ( !IsDefined(level.round_think_func) )
	{
		level.round_think_func = &round_think;
	}

	
	level thread [[ level.round_think_func ]]();
}

//
// Lets the players know that you need power to open these
function play_door_dialog()
{
	self endon ("warning_dialog");
	timer = 0;

	while(1)
	{
		{wait(.05);};
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{		
			dist = distancesquared(players[i].origin, self.origin );
			if(dist > 70*70)
			{
				timer =0;
				continue;
			}
			while(dist < 70*70 && timer < 3)
			{
				wait(0.5);
				timer++;
			}
			if(dist > 70*70 && timer >= 3)
			{
				self playsound("door_deny");
				
				players[i] zm_audio::create_and_play_dialog( "general", "outofmoney" );	
				wait(3);				
				self notify ("warning_dialog");
				//iprintlnbold("warning_given");
			}
		}
	}
}

function wait_until_first_player()
{
	players = GetPlayers();
	if( !IsDefined( players[0] ) )
	{
		level waittill( "first_player_ready" );
	}
}

//
//	Set the current round number hud display
function round_one_up()
{
	level endon("end_game");
	if( isdefined(level.noRoundNumber) && level.noRoundNumber==true )
	{
		return;
	}
	
	if(!IsDefined(level.doground_nomusic))
	{
		level.doground_nomusic = 0;
	}

	if( level.first_round )
	{
		intro = true;
		if( isdefined( level._custom_intro_vox ) )
		{
			level thread [[level._custom_intro_vox]]();
		}
		else
		{
			level thread play_level_start_vox_delayed();
		};
	}
	else
	{
		intro = false;
	}
	
	//Round Number Specific Lines
	if( level.round_number == 5 || level.round_number == 10 || level.round_number == 20 || level.round_number == 35 || level.round_number == 50 )
	{
	    players = GetPlayers();
	    rand = RandomIntRange(0,players.size);
	    players[rand] thread zm_audio::create_and_play_dialog( "general", "round_" + level.round_number );
	}
	
	if( intro )
	{
		if(( isdefined( level.host_ended_game ) && level.host_ended_game ))
		{
			return;
		}
		
		wait( 6.25 );
		level notify( "intro_hud_done" );
		wait( 2 );

	}
	else
	{
		wait( 2.5 );
	}
	
	ReportMTU(level.round_number);	// In network debug instrumented builds, causes network spike report to generate.
}


//	Flash the round display at the end of the round
//
function round_over()
{
	if( isdefined(level.noRoundNumber) && level.noRoundNumber==true )
	{
		return;
	}
	
	time = [[level.func_get_delay_between_rounds]]();

	players = GetPlayers();
	for ( player_index = 0; player_index < players.size; player_index++ )
	{
		if ( !IsDefined( players[player_index].pers["previous_distance_traveled"] ) )
		{
			players[player_index].pers["previous_distance_traveled"] = 0;
		}
		distanceThisRound = int( players[player_index].pers["distance_traveled"] - players[player_index].pers["previous_distance_traveled"] );
		players[player_index].pers["previous_distance_traveled"] = players[player_index].pers["distance_traveled"];
		players[player_index] IncrementPlayerStat("distance_traveled", distanceThisRound );
		if ( players[player_index].pers["team"] != "spectator" )
		{
			zoneName = players[player_index] zm_utility::get_current_zone();
			if( IsDefined(zoneName) )
			{
				players[player_index] RecordZombieZone( "endingZone", zoneName );
			}
		}
	}
	RecordZombieRoundEnd();
	// waiting for the Pulse from lua
	wait( time );
}

function get_delay_between_rounds()
{
	return( level.zombie_vars["zombie_between_round_time"] );
}


function round_think( restart = false )
{
/#	PrintLn( "ZM >> round_think start" );	#/
	
	level endon("end_round_think");
	
	if(!( isdefined( restart ) && restart ))
	{
		// Wait for blackscreen to end if in use
		if ( IsDefined( level.initial_round_wait_func ))
			[[level.initial_round_wait_func]]();
		
		if(!( isdefined( level.host_ended_game ) && level.host_ended_game ))
		{
			//unfreeze the players controls now
			players = GetPlayers();
			foreach(player in players)
			{
				if(!( isdefined( player.hostMigrationControlsFrozen ) && player.hostMigrationControlsFrozen ))
				{
					player FreezeControls(false);
					/# println(" Unfreeze controls 8"); #/
				}

				// set the initial round_number
				player zm_stats::set_global_stat( "rounds", level.round_number );
			}
		}
	}
	
	SetRoundsPlayed( level.round_number );
	
	for( ;; )
	{
		//////////////////////////////////////////
		//designed by prod DT#36173
		maxreward = 50 * level.round_number;
		if ( maxreward > 500 )
			maxreward = 500;
		level.zombie_vars["rebuild_barrier_cap_per_round"] = maxreward;
		//////////////////////////////////////////

		level.pro_tips_start_time = GetTime();
		level.zombie_last_run_time = GetTime();	// Resets the last time a zombie ran
	
		if ( IsDefined( level.zombie_round_change_custom ) )
		{
			[[ level.zombie_round_change_custom ]]();
		}
		else 
		{
			if( !( isdefined( level.sndMusicSpecialRound ) && level.sndMusicSpecialRound ) )
			{
				if( level.round_number == 1 )
					level thread zm_audio::sndMusicSystem_PlayState( "round_start_first" );
				else if( level.round_number <= 5 )
					level thread zm_audio::sndMusicSystem_PlayState( "round_start" );
				else
					level thread zm_audio::sndMusicSystem_PlayState( "round_start_short" );
			}
			round_one_up();
			//		round_text( &"ZOMBIE_ROUND_BEGIN" );
		}

		zm_powerups::powerup_round_start();

		players = GetPlayers();
		array::thread_all( players, &zm_blockers::rebuild_barrier_reward_reset );
		
		if(!( isdefined( level.headshots_only ) && level.headshots_only ) && !restart ) //no grenades for headshot only mode, or when grief restarts the round after everyone dies
		{
			level thread award_grenades_for_survivors();
		}
		
	/#	PrintLn( "ZM >> round_think, round="+level.round_number+", player_count=" + players.size );		#/

		level.round_start_time = GetTime();
	
		//Not great fix for this being zero - which it should NEVER be! (post ship - PETER)
		while( level.zm_loc_types[ "zombie_location" ].size <= 0 )
		{
			wait( 0.1 );
		}

	/#
		//Reset spawn counter for zones
		zkeys = GetArrayKeys( level.zones );
		for ( i = 0; i < zkeys.size; i++ )
		{
			zoneName = zkeys[i];
			level.zones[zoneName].round_spawn_count = 0;
		}
	#/

		level thread [[level.round_spawn_func]]();

		level notify( "start_of_round" );
		RecordZombieRoundStart();
		bb::logRoundEvent("start_of_round");
		players = GetPlayers();
		for ( index = 0; index < players.size; index++ )
		{
			zoneName = players[index] zm_utility::get_current_zone();
			if( IsDefined(zoneName) )
			{
				players[index] RecordZombieZone("startingZone", zoneName);
			}
		}
		if(isDefined(level.round_start_custom_func))
		{
			[[level.round_start_custom_func]]();
		}
		
		[[level.round_wait_func]]();

		level.first_round = false;
		level notify( "end_of_round" );
		bb::logRoundEvent("end_of_round");
		UploadStats();
		
		if(isDefined(level.round_end_custom_logic))
		{
			[[level.round_end_custom_logic]]();
		}
		
		players = GetPlayers();
		
		if( ( isdefined( level.no_end_game_check ) && level.no_end_game_check ) )
		{
			level thread last_stand_revive();
			level thread spectators_respawn();
		}
		else if ( 1 != players.size )
		{
			level thread spectators_respawn();
			//level thread last_stand_revive();
		}

		players = GetPlayers(); 
		array::thread_all( players, &zm_pers_upgrades_system::round_end );

		// 
		// Increase the zombie move speed
		//level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];

		if( level.gamedifficulty == 0 ) //easy
		{
			level.zombie_move_speed			= level.round_number * level.zombie_vars["zombie_move_speed_multiplier_easy"]; 
		}
		else	//normal
		{
			level.zombie_move_speed			= level.round_number * level.zombie_vars["zombie_move_speed_multiplier"]; 
		}


		level.round_number++;
		if ( 255 < level.round_number )
		{
			level.round_number = 255;
		}
		SetRoundsPlayed( level.round_number );

		// Here's the difficulty increase over time area
		//level.zombie_vars["zombie_spawn_delay"] = get_zombie_spawn_delay( level.round_number );
		level.zombie_vars["zombie_spawn_delay"] = [[level.func_get_zombie_spawn_delay]]( level.round_number );

		//	round_text( &"ZOMBIE_ROUND_END" );
		
		matchUTCTime = GetUTC();

		players = GetPlayers(); // delay in round_over allows a player that leaves during that time to remain in the players array - leading to round based SRES.  Bad.
		foreach(player in players)
		{
			if ( level.curr_gametype_affects_rank && level.round_number > (3 + level.start_round) )
			{
				player zm_stats::add_client_stat( "weighted_rounds_played",level.round_number );
			}
			player zm_stats::set_global_stat( "rounds", level.round_number );
			
			// update the game played time
			player zm_stats::update_playing_utc_time( matchUTCTime );
			
			// Reset the health if necessary
			player zm_perks::perk_set_max_health_if_jugg( "health_reboot", true, true );
		}
		
		if( isdefined( level.check_quickrevive_hotjoin ) )
		{
			[[ level.check_quickrevive_hotjoin ]]();
		}
		
		level round_over();

		level notify( "between_round_over" );
		
		restart = false;
	}
}


function award_grenades_for_survivors()
{
	players = GetPlayers();

	for (i = 0; i < players.size; i++)
	{
		if (!players[i].is_zombie && !( isdefined( players[i].altbody ) && players[i].altbody ))
		{
			lethal_grenade = players[i] zm_utility::get_player_lethal_grenade();
			if( !players[i] HasWeapon( lethal_grenade ) )
			{
				players[i] GiveWeapon( lethal_grenade );	
				players[i] SetWeaponAmmoClip( lethal_grenade, 0 );
			}

			frac = players[i] GetFractionMaxAmmo( lethal_grenade );
			if ( frac < .25 )
			{
				players[i] SetWeaponAmmoClip( lethal_grenade, 2 );
			}
			else if ( frac < .5 )
			{
				players[i] SetWeaponAmmoClip( lethal_grenade, 3 );
			}
			else
			{
				players[i] SetWeaponAmmoClip( lethal_grenade, 4 );
			}
		}
	}
}


//	Calculate the correct spawn delay for the round number
function get_zombie_spawn_delay( n_round )
{
	if ( n_round > 60 )	// Don't let this loop too many times
	{
		n_round = 60;
	}
	
	// Decay rate
	n_multiplier = 0.95;
	// Base delay
	switch( level.players.size )
	{
		case 1:
			n_delay = 2.0;		// 0.95 == 0.1 @ round 60
			break;
		case 2:
			n_delay = 1.5;		// 0.95 == 0.1 @ round 54
			break;
		case 3:
			n_delay = 0.89;		// 0.95 == 0.1 @ round 60
			break;
		case 4:
			n_delay = 0.67;		// 0.95 == 0.1 @ round 60
			break;
	}

	for( i=1; i<n_round; i++ )
	{
		n_delay *= n_multiplier;
		
		if ( n_delay <= 0.1 )
		{
			n_delay = 0.1;
			break;			
		}
	}
	
	return n_delay;
}


/#
function round_spawn_failsafe_debug()
{
	level notify( "failsafe_debug_stop" );
	level endon( "failsafe_debug_stop" );

	start = GetTime();
	level.chunk_time = 0;

	while ( 1 )
	{
		level.failsafe_time = GetTime() - start;

		if ( isdefined( self.lastchunk_destroy_time ) )
		{
			level.chunk_time = GetTime() - self.lastchunk_destroy_time;
		}
		util::wait_network_frame();
	}
}
#/

/#
function print_zombie_counts()
{
	while ( true )
	{
		if( GetDvarInt("zombiemode_debug_zombie_count") )
		{	
			if( !isdefined( level.debug_zombie_count_hud ) )
			{
				level.debug_zombie_count_hud= NewDebugHudElem();
				level.debug_zombie_count_hud.alignX = "right";
				level.debug_zombie_count_hud.x = 100;
				level.debug_zombie_count_hud.y = 10;
				level.debug_zombie_count_hud SetText( "COUNTS" );
			}

			currentCount = zombie_utility::get_current_zombie_count();
			number_to_kill = level.zombie_total;
			level.debug_zombie_count_hud SetText( "ALIVE=" + currentCount + " / TOGO=" + number_to_kill );
			//println( "ALIVE=" + currentCount + " / TOGO=" + number_to_kill );
		}
		else
		{
			if( isdefined( level.debug_zombie_count_hud ) )
			{
				level.debug_zombie_count_hud Destroy();
				level.debug_zombie_count_hud = undefined;
			}
		}	

		wait( 0.1 );
	}
}
#/


// Waits for the time and the ai to die
function round_wait()
{
	level endon("restart_round");
/#
	level endon( "kill_round" );
#/

/#
    if (GetDvarInt( "zombie_rise_test") )
	{
		level waittill("forever"); // TESTING: don't advance rounds
	}
#/

	if ( cheat_enabled( 2 ) )
	{
		level waittill("forever");
	}

/#
	if ( GetDvarInt( "zombie_default_max" ) == 0 )
	{
		level waittill( "forever" );
	}
#/

	wait( 1 );

/#
	level thread print_zombie_counts();
	level thread sndMusicOnKillRound();
#/

	while( 1 )
	{
		should_wait = ( zombie_utility::get_current_zombie_count() > 0 || level.zombie_total > 0 || level.intermission );	
		if( !should_wait )
		{
			level thread zm_audio::sndMusicSystem_PlayState( "round_end" );
			return;
		}			
			
		if( level flag::get( "end_round_wait" ) )
		{
			level thread zm_audio::sndMusicSystem_PlayState( "round_end" );
			return;
		}
		wait( 1.0 );
	}
}
//To make sure music plays when using debug to switch rounds
function sndMusicOnKillRound()
{
	level endon( "end_of_round" );
	
	level waittill( "kill_round" );
	level thread zm_audio::sndMusicSystem_PlayState( "round_end" );
}



function zombify_player()
{
	self zm_score::player_died_penalty(); 

	self RecordPlayerDeathZombies();

	if ( IsDefined( level.deathcard_spawn_func ) )
	{
		self [[level.deathcard_spawn_func]]();
	}

	if( !IsDefined( level.zombie_vars["zombify_player"] ) || !level.zombie_vars["zombify_player"] )
	{
		self thread spawnSpectator(); 
		return; 
	}

	self.ignoreme = true; 
	self.is_zombie = true; 
	self.zombification_time = GetTime(); 

	self.team = level.zombie_team;
	self notify( "zombified" ); 

	if( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger Delete(); 
	}
	self.revivetrigger = undefined; 

	self setMoveSpeedScale( 0.3 ); 
	self reviveplayer(); 

	self TakeAllWeapons(); 
	self DisableWeaponCycling(); 
	self DisableOffhandWeapons(); 

	util::setClientSysState( "zombify", 1, self ); 	// Zombie grain goooo

	self thread zombie_utility::zombie_eye_glow(); 

	self thread playerzombie_player_damage(); 
	self thread playerzombie_soundboard(); 
}

function playerzombie_player_damage()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	self thread playerzombie_infinite_health();  // manually keep regular health up
	self.zombiehealth = level.zombie_health; 

	// enable PVP damage on this guy
	// self EnablePvPDamage(); 

	while( 1 )
	{
		self waittill( "damage", amount, attacker, directionVec, point, type ); 

		if( !IsDefined( attacker ) || !IsPlayer( attacker ) )
		{
			{wait(.05);}; 
			continue; 
		}

		self.zombiehealth -= amount; 

		if( self.zombiehealth <= 0 )
		{
			// "down" the zombie
			self thread playerzombie_downed_state(); 
			self waittill( "playerzombie_downed_state_done" ); 
			self.zombiehealth = level.zombie_health; 
		}
	}
}

function playerzombie_downed_state()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	downTime = 15; 

	startTime = GetTime(); 
	endTime = startTime +( downTime * 1000 ); 

	self thread playerzombie_downed_hud(); 

	self.playerzombie_soundboard_disable = true; 
	self thread zombie_utility::zombie_eye_glow_stop(); 
	self DisableWeapons(); 
	self AllowStand( false ); 
	self AllowCrouch( false ); 
	self AllowProne( true ); 

	while( GetTime() < endTime )
	{
		{wait(.05);}; 
	}

	self.playerzombie_soundboard_disable = false; 
	self thread zombie_utility::zombie_eye_glow(); 
	self EnableWeapons(); 
	self AllowStand( true ); 
	self AllowCrouch( false ); 
	self AllowProne( false ); 

	self notify( "playerzombie_downed_state_done" ); 
}

function playerzombie_downed_hud()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	text = NewClientHudElem( self ); 
	text.alignX = "center"; 
	text.alignY = "middle"; 
	text.horzAlign = "user_center"; 
	text.vertAlign = "user_bottom"; 
	text.foreground = true; 
	text.font = "default"; 
	text.fontScale = 1.8; 
	text.alpha = 0; 
	text.color = ( 1.0, 1.0, 1.0 ); 
	text SetText( &"ZOMBIE_PLAYERZOMBIE_DOWNED" ); 

	text.y = -113; 	
	if( self IsSplitScreen() )
	{
		text.y = -137; 
	}

	text FadeOverTime( 0.1 ); 
	text.alpha = 1; 

	self waittill( "playerzombie_downed_state_done" ); 

	text FadeOverTime( 0.1 ); 
	text.alpha = 0; 
}

function playerzombie_infinite_health()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	bighealth = 100000; 

	while( 1 )
	{
		if( self.health < bighealth )
		{
			self.health = bighealth; 
		}

		wait( 0.1 ); 
	}
}

function playerzombie_soundboard()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	self.playerzombie_soundboard_disable = false; 

	self.buttonpressed_use = false; 
	self.buttonpressed_attack = false; 
	self.buttonpressed_ads = false; 

	self.useSound_waitTime = 3 * 1000;  // milliseconds
	self.useSound_nextTime = GetTime(); 
	useSound = "playerzombie_usebutton_sound"; 

	self.attackSound_waitTime = 3 * 1000; 
	self.attackSound_nextTime = GetTime(); 
	attackSound = "playerzombie_attackbutton_sound"; 

	self.adsSound_waitTime = 3 * 1000; 
	self.adsSound_nextTime = GetTime(); 
	adsSound = "playerzombie_adsbutton_sound"; 

	self.inputSound_nextTime = GetTime();  // don't want to be able to do all sounds at once

	while( 1 )
	{
		if( self.playerzombie_soundboard_disable )
		{
			{wait(.05);}; 
			continue; 
		}

		if( self UseButtonPressed() )
		{
			if( self can_do_input( "use" ) )
			{
				self thread playerzombie_play_sound( useSound ); 
				self thread playerzombie_waitfor_buttonrelease( "use" ); 
				self.useSound_nextTime = GetTime() + self.useSound_waitTime; 
			}
		}
		else if( self AttackButtonPressed() )
		{
			if( self can_do_input( "attack" ) )
			{
				self thread playerzombie_play_sound( attackSound ); 
				self thread playerzombie_waitfor_buttonrelease( "attack" ); 
				self.attackSound_nextTime = GetTime() + self.attackSound_waitTime; 
			}
		}
		else if( self AdsButtonPressed() )
		{
			if( self can_do_input( "ads" ) )
			{
				self thread playerzombie_play_sound( adsSound ); 
				self thread playerzombie_waitfor_buttonrelease( "ads" ); 
				self.adsSound_nextTime = GetTime() + self.adsSound_waitTime; 
			}
		}

		{wait(.05);}; 
	}
}

function can_do_input( inputType )
{
	if( GetTime() < self.inputSound_nextTime )
	{
		return false; 
	}

	canDo = false; 

	switch( inputType )
	{
	case "use":
		if( GetTime() >= self.useSound_nextTime && !self.buttonpressed_use )
		{
			canDo = true; 
		}
		break; 

	case "attack":
		if( GetTime() >= self.attackSound_nextTime && !self.buttonpressed_attack )
		{
			canDo = true; 
		}
		break; 

	case "ads":
		if( GetTime() >= self.useSound_nextTime && !self.buttonpressed_ads )
		{
			canDo = true; 
		}
		break; 

	default:
		ASSERTMSG( "can_do_input(): didn't recognize inputType of " + inputType ); 
		break; 
	}

	return canDo; 
}

function playerzombie_play_sound( alias )
{
	self zm_utility::play_sound_on_ent( alias ); 
}

function playerzombie_waitfor_buttonrelease( inputType )
{
	if( inputType != "use" && inputType != "attack" && inputType != "ads" )
	{
		ASSERTMSG( "playerzombie_waitfor_buttonrelease(): inputType of " + inputType + " is not recognized." ); 
		return; 
	}

	notifyString = "waitfor_buttonrelease_" + inputType; 
	self notify( notifyString ); 
	self endon( notifyString ); 

	if( inputType == "use" )
	{
		self.buttonpressed_use = true; 
		while( self UseButtonPressed() )
		{
			{wait(.05);}; 
		}
		self.buttonpressed_use = false; 
	}

	else if( inputType == "attack" )
	{
		self.buttonpressed_attack = true; 
		while( self AttackButtonPressed() )
		{
			{wait(.05);}; 
		}
		self.buttonpressed_attack = false; 
	}

	else if( inputType == "ads" )
	{
		self.buttonpressed_ads = true; 
		while( self AdsButtonPressed() )
		{
			{wait(.05);}; 
		}
		self.buttonpressed_ads = false; 
	}
}

function remove_ignore_attacker()
{
	self notify( "new_ignore_attacker" );
	self endon( "new_ignore_attacker" );
	self endon( "disconnect" );
	
	if( !isDefined( level.ignore_enemy_timer ) )
	{
		level.ignore_enemy_timer = 0.4;
	}
	
	wait( level.ignore_enemy_timer );
	
	self.ignoreAttacker = undefined;
}

function player_shield_facing_attacker( vDir, limit )
{
	orientation = self getPlayerAngles();
	forwardVec = anglesToForward( orientation );
	forwardVec2D = ( forwardVec[0], forwardVec[1], 0 );
	unitForwardVec2D = VectorNormalize( forwardVec2D );

	toFaceeVec = -vDir;
	toFaceeVec2D = ( toFaceeVec[0], toFaceeVec[1], 0 );
	unitToFaceeVec2D = VectorNormalize( toFaceeVec2D );
	
	dotProduct = VectorDot( unitForwardVec2D, unitToFaceeVec2D );
	return ( dotProduct > limit ); // more or less in front
}

function player_damage_override_cheat( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
	return 0;
}


//
//	player_damage_override
//		MUST return the value of the damage override
//
// MM (08/10/09) - Removed calls to PlayerDamageWrapper because it's always called in 
//		Callback_PlayerDamage now.  We just need to return the damage.
//
function player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	//check to see if we are in a game module that wants to do something with PvP damage
	if(isDefined(level._game_module_player_damage_callback))
	{
		self [[level._game_module_player_damage_callback]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}
	
	iDamage = self check_player_damage_callbacks( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
	
	if ( ( isdefined( self.use_adjusted_grenade_damage ) && self.use_adjusted_grenade_damage ) )
    {
        self.use_adjusted_grenade_damage = undefined;
        if( ( self.health > iDamage ) )
        {
        	return iDamage;
        }
    }

	if ( !iDamage )
	{
		return 0;
	}
	
	// WW (8/20/10) - Sledgehammer fix for Issue 43492. This should stop the player from taking any damage while in laststand
	if( self laststand::player_is_in_laststand() )
	{
		return 0;
	}
	
	if ( isDefined( eInflictor ) )
	{
		if ( ( isdefined( eInflictor.water_damage ) && eInflictor.water_damage ) )
		{
			return 0;
		}
	}

	if ( isDefined( eAttacker ) && (( isdefined( eAttacker.is_zombie ) && eAttacker.is_zombie ) || IsPlayer(eAttacker)) )
		if ( IsDefined(self.hasRiotShield) && self.hasRiotShield && IsDefined(vDir) )
		{
			if ( IsDefined(self.hasRiotShieldEquipped) && self.hasRiotShieldEquipped  )
			{
				if ( self player_shield_facing_attacker(vDir, 0.2) && isdefined(self.player_shield_apply_damage))
				{
					self [[self.player_shield_apply_damage]](iDamage, false, true);
					return 0;
				}
			}
			else if ( !IsDefined( self.riotshieldEntity ))
			{
				// shield on back - half damage to player, half to shield
				if ( !self player_shield_facing_attacker(vDir, -0.2) && isdefined(self.player_shield_apply_damage))
				{
					self [[self.player_shield_apply_damage]](iDamage, false, true);
					return 0;
				}
			}
		}
	
	if ( isDefined( eAttacker ) )
	{
		
		if( isDefined( self.ignoreAttacker ) && self.ignoreAttacker == eAttacker ) 
		{
			return 0;
		}
		
		// AR (5/30/12) - Stop Zombie players from damaging other Zombie players
		if ( ( isdefined( self.is_zombie ) && self.is_zombie ) && ( isdefined( eAttacker.is_zombie ) && eAttacker.is_zombie ) )
		{
			return 0;
		}
		
		if( (isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie) )
		{
			self.ignoreAttacker = eAttacker;
			self thread remove_ignore_attacker();

			if ( isdefined( eAttacker.custom_damage_func ) )
			{
				iDamage = eAttacker [[ eAttacker.custom_damage_func ]]( self );
			}
		}
		
		eAttacker notify( "hit_player" ); 

		if( sMeansOfDeath != "MOD_FALLING" )
		{
			self thread playSwipeSound( sMeansOfDeath, eattacker );
			if( ( isdefined( eattacker.is_zombie ) && eattacker.is_zombie ) || IsPlayer(eAttacker) )
				self PlayRumbleOnEntity( "damage_heavy" );
			
			canExert = true;
			
			if ( ( isdefined( level.pers_upgrade_flopper ) && level.pers_upgrade_flopper ) )
			{
				// If the player has persistent flopper power, then no exert on explosion
				if ( ( isdefined( self.pers_upgrades_awarded[ "flopper" ] ) && self.pers_upgrades_awarded[ "flopper" ] ) )
				{
					canExert = ( sMeansOfDeath != "MOD_PROJECTILE_SPLASH" && sMeansOfDeath != "MOD_GRENADE" && sMeansOfDeath != "MOD_GRENADE_SPLASH" );
				}
			}
			
			if ( ( isdefined( canExert ) && canExert ) )
			{
			    if(RandomIntRange(0,1) == 0 )
			    {
			    	self thread zm_audio::playerExert( "hitmed" );
			        //self thread zm_audio::create_and_play_dialog( "general", "hitmed" );
			    }
			    else
			    {
			    	self thread zm_audio::playerExert( "hitlrg" );
			        //self thread zm_audio::create_and_play_dialog( "general", "hitlrg" );
			    }
			}
		}
	}
	finalDamage = iDamage;
	
	// claymores and freezegun shatters, like bouncing betties, harm no players
	if ( zm_utility::is_placeable_mine( weapon ) )
	{
		return 0;
	}

	if ( isDefined( self.player_damage_override ) )
	{
		self thread [[ self.player_damage_override ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}
	
	if( isdefined( level.perk_damage_override ) )
	{
		foreach( func in level.perk_damage_override )
		{
			n_damage = self [[ func ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
			if( isdefined( n_damage ) )
			{
				return n_damage;		
			}
		}
	}

	if ( sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" )
	{
		if ( self bgb::is_enabled( "zm_bgb_danger_closest" ) )
		{
			return 0;
		}
		
		if ( self.health > 75 && !( isdefined( self.is_zombie ) && self.is_zombie ) )
		{
			return 75;
		}
	}

	if( iDamage < self.health )
	{
		if ( IsDefined( eAttacker ) )
		{
			if( IsDefined( level.custom_kill_damaged_VO ) )
			{
				eAttacker thread [[ level.custom_kill_damaged_VO ]]( self );
			}
			else
			{
				eAttacker.sound_damage_player = self;	
			}
			
			if( ( isdefined( eAttacker.missingLegs ) && eAttacker.missingLegs ) )
			{
			    self zm_audio::create_and_play_dialog( "general", "crawl_hit" );
			}
		}
		
		// MM (08/10/09)
		return finalDamage;
	}
	
	//player died
	if( isdefined( eAttacker ) )
	{
		if(isDefined(eAttacker.animname) && eAttacker.animname == "zombie_dog")
		{
			self zm_stats::increment_client_stat( "killed_by_zdog" );
			self zm_stats::increment_player_stat( "killed_by_zdog" );
		}
		else if(( isdefined( eAttacker.is_avogadro ) && eAttacker.is_avogadro ))
		{
			self zm_stats::increment_client_stat( "killed_by_avogadro", false );
			self zm_stats::increment_player_stat( "killed_by_avogadro" );
		}
	}

	self thread clear_path_timers();
		
	if( level.intermission )
	{
		level waittill( "forever" );
	}
	
	// AR (3/7/12) - Keep track of which player killed player in Zombify modes like Cleansed / Turned
	// Confirmed with Alex 
	if ( level.scr_zm_ui_gametype == "zcleansed" && iDamage > 0 )
	{
		if ( IsDefined( eAttacker ) && IsPlayer( eAttacker ) && eAttacker.team != self.team && ( ( !( isdefined( self.laststand ) && self.laststand ) && !self laststand::player_is_in_laststand() ) || !IsDefined( self.last_player_attacker ) ) )
		{
			// Restore Health To Zombie Player
			//--------------------------------
			if ( IsDefined( eAttacker.maxhealth ) && ( isdefined( eAttacker.is_zombie ) && eAttacker.is_zombie ) )
			{
				eAttacker.health = eAttacker.maxhealth;
			}
			
			//self.last_player_attacker = eAttacker;

			if ( IsDefined( level.player_kills_player ) )
			{
				self thread [[ level.player_kills_player]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
			}			
		}
	}
	
	if ( self.lives > 0 && self HasPerk( "specialty_whoswho" ) )
	{
		self.lives--;
		if ( IsDefined( level.whoswho_laststand_func ) )
		{
			self thread [[ level.whoswho_laststand_func]]();
			return 0;
		}			
	}	
	
	players = GetPlayers();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] == self || players[i].is_zombie || players[i] laststand::player_is_in_laststand() || players[i].sessionstate == "spectator" )
		{
			count++;
		}
	}
	
	if( count < players.size || (isDefined(level._game_module_game_end_check) && ![[level._game_module_game_end_check]]()) )
	{
		if ( IsDefined( self.lives ) && self.lives > 0 && ( isdefined( level.force_solo_quick_revive ) && level.force_solo_quick_revive ) &&  self HasPerk( "specialty_quickrevive" ) )
		{
			self thread wait_and_revive();
		}
		
		// MM (08/10/09)
		return finalDamage;
	}
	
	if ( players.size == 1 && level flag::get( "solo_game" ) )
	{
		if ( isdefined( level.check_end_solo_game_override ) && [[level.check_end_solo_game_override]]() )
		{
			return finalDamage;
		}
		else if ( self.lives == 0 || !self HasPerk( "specialty_quickrevive" ) )
		{
			self.intermission = true;
		}
	}
	
	
	
	
	// WW (01/05/11): When a two players enter a system link game and the client drops the host will be treated as if it was a solo game
	// when it wasn't. This led to SREs about undefined and int being compared on death (self.lives was never defined on the host). While
	// adding the check for the solo game flag we found that we would have to create a complex OR inside of the if check below. By breaking
	// the conditions out in to their own variables we keep the complexity without making it look like a mess.
	solo_death = ( players.size == 1 && level flag::get( "solo_game" ) && ( self.lives == 0  || !self HasPerk("specialty_quickrevive") ) ); // there is only one player AND the flag is set AND self.lives equals 0
	non_solo_death = ( ( count > 1 || ( players.size == 1 && !level flag::get( "solo_game" ) ) ) /*&& !level.is_zombie_level*/ ); // the player size is greater than one OR ( players.size equals 1 AND solo flag isn't set ) AND not a zombify game level
	if ( (solo_death || non_solo_death) && !( isdefined( level.no_end_game_check ) && level.no_end_game_check ) ) // if only one player on their last life or any game that started with more than one player
	{	
		level notify("stop_suicide_trigger");
		self thread zm_laststand::PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime );
		if( !isdefined( vDir ) )
		{
			vDir = ( 1.0, 0.0, 0.0 );
		}
		self FakeDamageFrom(vDir);
		
		level notify("last_player_died");
		if ( isdefined(level.custom_player_fake_death) )
			self thread [[level.custom_player_fake_death]](vDir, sMeansOfDeath);
		else
			self thread player_fake_death();
	}

	if( count == players.size && !( isdefined( level.no_end_game_check ) && level.no_end_game_check ) )
	{
		if ( players.size == 1 && level flag::get( "solo_game" ))
		{
			if ( self.lives == 0 || !self HasPerk("specialty_quickrevive") ) // && !self laststand::player_is_in_laststand()
			{
				self.lives = 0;
				level notify("pre_end_game");
				util::wait_network_frame();
				if(level flag::get("dog_round"))
				{
					increment_dog_round_stat( "lost" );	
						
				}				
				level notify( "end_game" );
			}
			else
			{
				return finalDamage;
			}
		}
		else
		{
			level notify("pre_end_game");
			util::wait_network_frame();
			if(level flag::get("dog_round"))
			{
				increment_dog_round_stat( "lost" );	
					
			}
			level notify( "end_game" );
		}
		return 0;	// MM (09/16/09) Need to return something
	}
	else
	{
		// MM (08/10/09)
		
		surface = "flesh";
		
		return finalDamage;
	}
}

function clear_path_timers()
{
	zombies = GetAITeamArray( level.zombie_team );
	foreach( zombie in zombies )
	{
		if ( isdefined( zombie.favoriteenemy ) && ( zombie.favoriteenemy == self ) )
		{
			zombie.zombie_path_timer = 0;
		}
	}
}


function check_player_damage_callbacks( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( !isdefined( level.player_damage_callbacks ) )
	{
		return iDamage;
	}
	
	for ( i = 0; i < level.player_damage_callbacks.size; i++ )
	{
		newDamage = self [[ level.player_damage_callbacks[i] ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
		if ( -1 != newDamage )
		{
			return newDamage;
		}
	}

	return iDamage;
}


function register_player_damage_callback( func )
{
	if ( !isdefined( level.player_damage_callbacks ) )
	{
		level.player_damage_callbacks = [];
	}

	level.player_damage_callbacks[level.player_damage_callbacks.size] = func;
}


function wait_and_revive()
{
	
	self endon( "remote_revive" );
	level flag::set( "wait_and_revive" );

	if ( isdefined( self.waiting_to_revive ) && self.waiting_to_revive == true )
	{
		return;
	}

	// Grab the perks if we have the player persistent ability "perk lose"
	if( ( isdefined( self.pers_upgrades_awarded["perk_lose"] ) && self.pers_upgrades_awarded["perk_lose"] ) )
	{
		self zm_pers_upgrades_functions::pers_upgrade_perk_lose_save();
	}

	self.waiting_to_revive = true;
	if ( isdefined( level.exit_level_func ) )
	{
		self thread [[ level.exit_level_func ]]();
	}
	else
	{
		if ( GetPlayers().size == 1 )
		{
			level.move_away_points =  PositionQuery_Source_Navigation( GetPlayers()[0].origin, 12*40, 12*80, 120, 20 );
		}
	}

	solo_revive_time = 10.0;

	self.revive_hud setText( &"ZOMBIE_REVIVING_SOLO", self );
	self laststand::revive_hud_show_n_fade( solo_revive_time );

	level flag::wait_till_timeout( solo_revive_time, "instant_revive" );

	if ( level flag::get( "instant_revive" ) )
	{
		self laststand::revive_hud_show_n_fade( 1.0 );
	}
	
	level flag::clear( "wait_and_revive" );

	self zm_laststand::auto_revive( self );
	self.lives--;
	self.waiting_to_revive = false;

	// Give player his perks back if he has the "perk_lose" persistent ability
	if( ( isdefined( self.pers_upgrades_awarded["perk_lose"] ) && self.pers_upgrades_awarded["perk_lose"] ) )
	{
		self thread zm_pers_upgrades_functions::pers_upgrade_perk_lose_restore();
	}
}

function register_vehicle_damage_callback( func )
{
	if( !IsDefined( level.vehicle_damage_callbacks ) )
	{
		level.vehicle_damage_callbacks = [];
	}
	
	level.vehicle_damage_callbacks[level.vehicle_damage_callbacks.size] = func;
}

function vehicle_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	//apply damage modifiers on the vehicle
	if( IsDefined( level.vehicle_damage_callbacks ) )
    {
    	for( i = 0; i < level.vehicle_damage_callbacks.size; i++ )
    	{
    		iDamage = self [[ level.vehicle_damage_callbacks[i] ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );
    	}
    }
			
	//TODO Sabarish: Move code from globallogic to here to be more consistent with other zombie damage functions
	self globallogic_vehicle::Callback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );
}

//
//		MUST return the value of the damage override
//
function actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType )
{
	// skip conditions
	if( !isdefined( self) || !isdefined( attacker ) )
		return damage;

	damage = bgb::actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType );

	self.knuckles_extinguish_flames = (weapon.name == "tazer_knuckles");

	if ( isdefined( attacker.animname ) && attacker.animname == "quad_zombie" )
	{
		if ( isdefined( self.animname ) && self.animname == "quad_zombie" )
		{
			return 0;
		}
	}
	
	if(isdefined(self.killby_interdimensional_gun_hole))
	{
		return damage;
	}
	else if(isdefined(self.interdimensional_gun_kill))
	{
		if ( isdefined( self.idgun_damage_cb ) )
		{
			self [[ self.idgun_damage_cb ]]();
		}
		return 0;
	}
	
	
	if(isdefined(weapon))
	{
		if( is_idgun_damage( weapon ) )
		{
			if( !( self.archetype === "margwa" ) )
			{
				self.damageOrigin = vpoint;
				self.allowdeath = false;
				self.magic_bullet_shield = true;
				self.interdimensional_gun_kill = true;
				self.interdimensional_gun_weapon = weapon;
				self.interdimensional_gun_attacker = attacker;
			
				if(isdefined(inflictor))
					self.interdimensional_gun_inflictor = inflictor;
				else
					self.interdimensional_gun_inflictor = attacker;
			}

			if ( isdefined( self.idgun_damage_cb ) )
			{
				self [[ self.idgun_damage_cb ]]();
			}
			
			return 0;
		}
	}
	
	if ( !isplayer( attacker ) && isdefined( self.non_attacker_func ) )
	{
		if(( isdefined( self.non_attack_func_takes_attacker ) && self.non_attack_func_takes_attacker ))
		{
			return self [[ self.non_attacker_func ]]( damage, weapon, attacker );
		}
		else
		{
			return self [[ self.non_attacker_func ]]( damage, weapon );
		}
	}
	
	if ( IsDefined( attacker ) && IsAI( attacker ) )
	{
		// AI do not do melee damage to teammates
		if( self.team == attacker.team && meansofdeath == "MOD_MELEE" )
		{
			return 0;
		}
	}
	
	if ( !isplayer( attacker ) && !isplayer( self ) && !IsAI( attacker ) )
		return damage;
	if( !isdefined( damage ) || !isdefined( meansofdeath ) )
		return damage;
	if( meansofdeath == "" )
		return damage;

	old_damage = damage;
	final_damage = damage;

	if ( IsDefined( self.actor_damage_func ) )
	{
		final_damage = [[ self.actor_damage_func ]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex );
	}

	// debug
/#
		if ( GetDvarInt( "scr_perkdebug") )
			println( "Perk/> Damage Factor: " + final_damage/old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
#/
	
	if( attacker.classname == "script_vehicle" && isDefined( attacker.owner ) )
		attacker = attacker.owner;

	if ( ( isdefined( self.in_water ) && self.in_water ) )
	{
		if ( int( final_damage ) >= self.health )
		{
			self.water_damage = true;
		}
	}
	
	// return unchanged damage
	//iPrintln( final_damage );
	if(	(attacker zm_pers_upgrades_functions::pers_mulit_kill_headshot_active()) && zm_utility::is_headshot(weapon, sHitLoc, meansofdeath) )
	{
		//double damage
		final_damage = final_damage * 2;
	}
	
	//modifier for the sword in ZOD colliding with zombies
	if( IsDefined( inflictor ) && IsDefined( inflictor.archetype ) && inflictor.archetype == "glaive" )
	{
		if( meansofdeath == "MOD_CRUSH" )
		{
			if( ( IsDefined( inflictor.enemy ) && inflictor.enemy != self ) || ( isdefined( inflictor._glaive_must_return_to_owner ) && inflictor._glaive_must_return_to_owner ) )
			{
				if( IsDefined( self.archetype ) && self.archetype != "margwa" )
				{
					final_damage += self.health;
					if( IsActor( self ) )
					{
						self zombie_utility::gib_random_parts();
					}
				}
			}
			else
			{
				return 0;
			}
		}
	}
	
	if ( ( isdefined( level.headshots_only ) && level.headshots_only ) && isDefined( attacker ) && isplayer(attacker) )
	{
		if(meansofdeath == "MOD_MELEE" && (sHitLoc == "head" || sHitLoc == "helmet") )
		{
			return int( final_damage );
		}		
		if( zm_utility::is_explosive_damage( meansofdeath ))
		{
			return int( final_damage );
		}
		else if(!zm_utility::is_headshot( weapon, sHitLoc, meansofdeath ) )
		{
			return 0;
		}
	}
	
	return int( final_damage );
}


function actor_damage_override_wrapper( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, modelIndex, surfaceType, vSurfaceNormal )
{
	damage_override = self actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType );
	willBeKilled = (self.health - damage_override) <= 0;
	bb::logdamage(attacker, self, weapon, damage_override, meansofdeath, shitloc, willBeKilled, willBeKilled);
	if (damage_override<self.health || !( isdefined( self.dont_die_on_me ) && self.dont_die_on_me ))
	{
		self finishActorDamage( inflictor, attacker, damage_override, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, surfaceType, vSurfaceNormal );
	}
}

function actor_killed_override(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	if ( game["state"] == "postgame" )
	{
		return;	
	}
	
	if( isai(attacker) && isDefined( attacker.script_owner ) )
	{
		// if the person who called the dogs in switched teams make sure they don't
		// get penalized for the kill
		if ( attacker.script_owner.team != self.team )
			attacker = attacker.script_owner;
	}
		
	if( attacker.classname == "script_vehicle" && isDefined( attacker.owner ) )
	{
		attacker = attacker.owner;
	}
		
	if ( isdefined( attacker ) && isplayer( attacker ) )
	{
		multiplier = 1;
		if( zm_utility::is_headshot( weapon, sHitLoc, sMeansOfDeath ) )
		{
			multiplier = 1.5;
		}

		type = undefined;

		//MM (3/18/10) no animname check
		if ( IsDefined(self.animname) )
		{
			switch( self.animname )
			{
			case "quad_zombie":
				type = "quadkill";
				break;
			case "ape_zombie":
				type = "apekill";
				break;
			case "zombie":
				type = "zombiekill";
				break;
			case "zombie_dog":
				type = "dogkill";
				break;
			}
		}
	}
	
	if(( isdefined( self.is_ziplining ) && self.is_ziplining ))
	{
		self.deathanim = undefined;
	}

	if ( IsDefined( self.actor_killed_override ) )
	{
		self [[ self.actor_killed_override ]]( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime );
	}
	
	if ( IsDefined( self.deathFunction ) )
	{
		self [[ self.deathFunction ]]( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime );
	}
}


function round_end_monitor()
{
	while(1)
	{
		level waittill( "end_of_round" );

		demo::bookmark( "zm_round_end", gettime(), undefined, undefined, 1 );
		BBPostDemoStreamStatsForRound( level.round_number );

		{wait(.05);};
	}
}


//*****************************************************************************
//*****************************************************************************

function end_game()
{
	level waittill ( "end_game" );
	
	check_end_game_intermission_delay();

/#	println( "end_game TRIGGERED " );	#/
	
	util::clientnotify( "zesn" );
	
	level thread zm_audio::sndMusicSystem_PlayState( "game_over" );
	
	//AYERS: Turn off ANY last stand audio at the end of the game
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		players[i] clientfield::set( "zmbLastStand", 0 );
	}

	for ( i = 0; i < players.size; i++ )
	{	
		if ( players[i] laststand::player_is_in_laststand() )
		{
			players[i] RecordPlayerDeathZombies();
			players[i] zm_stats::increment_player_stat( "deaths" );
			players[i] zm_stats::increment_client_stat( "deaths" );
			players[i] zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
		}
		
		//clean up the revive text hud if it's active
		if( isdefined( players[i].reviveTextHud ) )
		{
			players[i].reviveTextHud destroy();
		}
	}

	StopAllRumbles();

	level.intermission = true;
	level.zombie_vars["zombie_powerup_insta_kill_time"] = 0;
	level.zombie_vars["zombie_powerup_fire_sale_time"] = 0;
	level.zombie_vars["zombie_powerup_double_points_time"] = 0;
	wait 0.1;

	game_over = [];
	survived = [];

	players = GetPlayers();

	//disabled the ingame pause menu from opening after a game ends
	setMatchFlag( "disableIngameMenu", 1 );
	foreach( player in players )
	{
		player closeInGameMenu();
	}


	//AAR - set stat for each player (this will show the menu)
	foreach( player in players )
	{
		player setDStat( "AfterActionReportStats", "lobbyPopup", "summary" );
	}

	if(!isDefined(level._supress_survived_screen))
	{
		
		for( i = 0; i < players.size; i++ )
		{
			if ( IsDefined( level.custom_game_over_hud_elem ) )
			{
				game_over[i] = [[ level.custom_game_over_hud_elem ]]( players[i] );
			}
			else
			{
				game_over[i] = NewClientHudElem( players[i] );
				game_over[i].alignX = "center";
				game_over[i].alignY = "middle";
				game_over[i].horzAlign = "center";
				game_over[i].vertAlign = "middle";
				game_over[i].y -= 130;
				game_over[i].foreground = true;
				game_over[i].fontScale = 3;
				game_over[i].alpha = 0;
				game_over[i].color = ( 1.0, 1.0, 1.0 );
				game_over[i].hidewheninmenu = true;
				game_over[i] SetText( &"ZOMBIE_GAME_OVER" );
	
				game_over[i] FadeOverTime( 1 );
				game_over[i].alpha = 1;
				if ( players[i] isSplitScreen() )
				{
					game_over[i].fontScale = 2;
					game_over[i].y += 40;
				}
			}
	
			survived[i] = NewClientHudElem( players[i] );
			survived[i].alignX = "center";
			survived[i].alignY = "middle";
			survived[i].horzAlign = "center";
			survived[i].vertAlign = "middle";
			survived[i].y -= 100;
			survived[i].foreground = true;
			survived[i].fontScale = 2;
			survived[i].alpha = 0;
			survived[i].color = ( 1.0, 1.0, 1.0 );
			survived[i].hidewheninmenu = true;
			if ( players[i] isSplitScreen() )
			{
				survived[i].fontScale = 1.5;
				survived[i].y += 40;
			}
	
			//OLD COUNT METHOD
			if( level.round_number < 2 )
			{
				if( level.script == "zombie_moon" )
				{
					if( !isdefined(level.left_nomans_land) )
					{
						nomanslandtime = level.nml_best_time;
						player_survival_time = int( nomanslandtime/1000 );
						player_survival_time_in_mins = zm::to_mins( player_survival_time );
						survived[i] SetText( &"ZOMBIE_SURVIVED_NOMANS", player_survival_time_in_mins );
					}
					else if( level.left_nomans_land == 2 )
					{
						survived[i] SetText( &"ZOMBIE_SURVIVED_ROUND" );
					}
				}
				else
				{
					survived[i] SetText( &"ZOMBIE_SURVIVED_ROUND" );
				}
			}
			else
			{
				survived[i] SetText( &"ZOMBIE_SURVIVED_ROUNDS", level.round_number );
			}
	
			survived[i] FadeOverTime( 1 );
			survived[i].alpha = 1;
		}
	}

	//check to see if we are in a game module that wants to do something with PvP damage
	if(isDefined(level.custom_end_screen))
	{
		level [[level.custom_end_screen]]();
	}

	for (i = 0; i < players.size; i++)
	{
		players[i] SetClientUIVisibilityFlag( "weapon_hud_visible", 0 );
		players[i] SetClientMiniScoreboardHide( true );
		//players[i] setDStat( "AfterActionReportStats", "lobbyPopup", "summary" );
	}

	UploadStats();
	zm_stats::update_players_stats_at_match_end( players );
	zm_stats::update_global_counters_on_match_end();
	bb::logroundevent("end_game");
	wait( 1 );
	// upload_leaderboards();
	
	//zm_utility::play_sound_at_pos( "end_of_game", ( 0, 0, 0 ) );
	wait( 3.95 );

	players = GetPlayers();
	foreach( player in players )
	{
		if( IsDefined( player.sessionstate ) && player.sessionstate == "spectator" )
		{
			player.sessionstate = "playing";
		}
	}
	{wait(.05);};

	players = GetPlayers();
	// hide the gameover message, there's just no room for it alongside the scoreboard anymore, especially not in splitscreen, so this way the modes are consistent
	if ( !isDefined( level._supress_survived_screen ) )
	{
		for ( i = 0; i < players.size; i++ )
		{
			survived[i] Destroy();
			game_over[i] Destroy();
		}
	}
	else
	{
		for ( i = 0; i < players.size; i++ )
		{
			if(isDefined(players[i].survived_hud ) )
				players[i].survived_hud  Destroy();
			if (isDefined( players[i].game_over_hud ) )
				players[i].game_over_hud Destroy();
		}
	}
	
	intermission();

	wait( level.zombie_vars["zombie_intermission_time"] );

	level notify( "stop_intermission" );
	array::thread_all( GetPlayers(), &player_exit_level );

	wait( 1.5 );

	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		players[i] CameraActivate( false );
	}
	
	ExitLevel( false );

	// Let's not exit the function
	wait( 666 );
}


//*****************************************************************************
//*****************************************************************************

function disable_end_game_intermission( delay )
{
	level.disable_intermission = true;
	wait( delay );
	level.disable_intermission = undefined;
}


//*****************************************************************************
//*****************************************************************************

function check_end_game_intermission_delay()
{
	if( IsDefined(level.disable_intermission) )
	{
		while( 1 )
		{
			if( !IsDefined(level.disable_intermission) )
			{
				break;
			}
			wait( 0.01 );
		}
	}
}


//*****************************************************************************
// This will save the leaderboard data per round, for use in single player
//*****************************************************************************

function upload_leaderboards()
{	
	// place restrictions on whether leaderboards are uploaded to in the precache leaderboards function
	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] uploadleaderboards();
	}
}


function initializeStatTracking()
{
	level.global_zombies_killed = 0;
	level.zombies_timeout_spawn = 0;
	level.zombies_timeout_playspace = 0;
	level.zombies_timeout_undamaged = 0;	
	level.zombie_player_killed_count = 0;
	level.zombie_trap_killed_count = 0;
	level.zombie_pathing_failed = 0;
	level.zombie_breadcrumb_failed = 0;		
	
}

function uploadGlobalStatCounters()
{
	incrementCounter( "global_zombies_killed", level.global_zombies_killed );
	incrementCounter( "global_zombies_killed_by_players", level.zombie_player_killed_count );
	incrementCounter( "global_zombies_killed_by_traps", level.zombie_trap_killed_count );	
}

function player_fake_death()
{
	level notify ("fake_death");
	self notify ("fake_death");

	self TakeAllWeapons();
	self AllowStand( false );
	self AllowCrouch( false );
	self AllowProne( true );

	self.ignoreme = true;
	self EnableInvulnerability();

	wait( 1 );
	self FreezeControls( true );
}

function player_exit_level()
{
	self AllowStand( true );
	self AllowCrouch( false );
	self AllowProne( false );

	if( IsDefined( self.game_over_bg ) )
	{
		self.game_over_bg.foreground = true;
		self.game_over_bg.sort = 100;
		self.game_over_bg FadeOverTime( 1 );
		self.game_over_bg.alpha = 1;
	}
}


function player_killed_override(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	// BLANK
	level waittill( "forever" );
}
	
function player_zombie_breadcrumb()
{
	self notify("stop_player_zombie_breadcrumb");
	self endon("stop_player_zombie_breadcrumb");
	self endon( "disconnect" ); 
	self endon( "spawned_spectator" ); 
	level endon( "intermission" );

	self.zombie_breadcrumbs = []; 
	self.zombie_breadcrumb_distance = 24 * 24; // min dist (squared) the player must move to drop a crumb
	self.zombie_breadcrumb_area_num = 3;	   // the number of "rings" the area breadcrumbs use
	self.zombie_breadcrumb_area_distance = 16; // the distance between each "ring" of the area breadcrumbs

	self store_crumb( self.origin ); 
	last_crumb = self.origin;

	self thread zm_utility::debug_breadcrumbs(); 

	while( 1 )
	{
		wait_time = 0.1;
		
		
		if( self.ignoreme )
		{
			wait( wait_time ); 
			continue;
		}

		//For cloaking ability
		//if( self.ignoreme )
		//{
		//	wait( wait_time ); 
		//	continue;
		//}


		store_crumb = true; 
		airborne = false;
		crumb = self.origin;

//TODO TEMP SCRIPT for vehicle testing Delete/comment when done
		if ( !self IsOnGround() && self isinvehicle() )
		{
			trace = bullettrace( self.origin + (0,0,10), self.origin, false, undefined );
			crumb = trace["position"];
		}

//TODO TEMP DISABLE for vehicle testing.  Uncomment when reverting
// 		if ( !self IsOnGround() )
// 		{
// 			airborne = true;
// 			store_crumb = false; 
// 			wait_time = 0.05;
// 		}
// 		
		if( !airborne && DistanceSquared( crumb, last_crumb ) < self.zombie_breadcrumb_distance )
		{
			store_crumb = false; 
		}

		if ( airborne && self IsOnGround() )
		{
			// player was airborne, store crumb now that he's on the ground
			store_crumb = true;
			airborne = false;
		}
		
		if( isDefined( level.custom_breadcrumb_store_func ) )
		{
			store_crumb = self [[ level.custom_breadcrumb_store_func ]]( store_crumb );
		}
		
		if( isDefined( level.custom_airborne_func ) )
		{
			airborne = self [[ level.custom_airborne_func ]]( airborne );
		}
		
		if( store_crumb )
		{
			zm_utility::debug_print( "Player is storing breadcrumb " + crumb );
			
			if( IsDefined(self.node) )
			{
				zm_utility::debug_print( "has closest node " );
			}
			
			last_crumb = crumb;
			self store_crumb( crumb );
		}

		wait( wait_time ); 
	}
}


function store_crumb( origin )
{
	offsets = [];
	height_offset = 32;
	
	index = 0;
	for( j = 1; j <= self.zombie_breadcrumb_area_num; j++ )
	{
		offset = ( j * self.zombie_breadcrumb_area_distance );
		
		offsets[0] = ( origin[0] - offset, origin[1], origin[2] );
		offsets[1] = ( origin[0] + offset, origin[1], origin[2] );
		offsets[2] = ( origin[0], origin[1] - offset, origin[2] );
		offsets[3] = ( origin[0], origin[1] + offset, origin[2] );

		offsets[4] = ( origin[0] - offset, origin[1], origin[2] + height_offset );
		offsets[5] = ( origin[0] + offset, origin[1], origin[2] + height_offset );
		offsets[6] = ( origin[0], origin[1] - offset, origin[2] + height_offset );
		offsets[7] = ( origin[0], origin[1] + offset, origin[2] + height_offset );

		for ( i = 0; i < offsets.size; i++ )
		{
			self.zombie_breadcrumbs[index] = offsets[i];
			index++;
		}
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LEADERBOARD CODE///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function to_mins( seconds )
{
	hours = 0; 
	minutes = 0; 
	
	if( seconds > 59 )
	{
		minutes = int( seconds / 60 );

		seconds = int( seconds * 1000 ) % ( 60 * 1000 );
		seconds = seconds * 0.001; 

		if( minutes > 59 )
		{
			hours = int( minutes / 60 );
			minutes = int( minutes * 1000 ) % ( 60 * 1000 );
			minutes = minutes * 0.001; 		
		}
	}

	if( hours < 10 )
	{
		hours = "0" + hours; 
	}

	if( minutes < 10 )
	{
		minutes = "0" + minutes; 
	}

	seconds = Int( seconds ); 
	if( seconds < 10 )
	{
		seconds = "0" + seconds; 
	}

	combined = "" + hours  + ":" + minutes  + ":" + seconds; 

	return combined; 
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//
// INTERMISSION =========================================================== //
//

function intermission()
{
	level.intermission = true;
	level notify( "intermission" );

	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		util::setclientsysstate( "levelNotify", "zi", players[i] ); // Tell clientscripts we're in zombie intermission

		players[i] SetClientThirdPerson( 0 );
		players[i] resetFov();

		players[i].health = 100; // This is needed so the player view doesn't get stuck
		players[i] thread [[level.custom_intermission]]();
		
		players[i] StopSounds();
	}

	wait( 0.25 );

	// Delay the last stand monitor so we are 100% sure the zombie intermission ("zi") is set on the cients
	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] clientfield::set( "zmbLastStand", 0 );
	}

	level thread zombie_game_over_death();
}

function zombie_game_over_death()
{
	// Kill remaining zombies, in style!
	zombies = GetAiTeamArray( level.zombie_team );
	for( i = 0; i < zombies.size; i++ )
	{
		if( !IsAlive( zombies[i] ) )
		{
			continue;
		}

		zombies[i] SetGoal( zombies[i].origin );
	}

	for( i = 0; i < zombies.size; i++ )
	{
		if( !IsAlive( zombies[i] ) )
		{
			continue;
		}

		if ( ( isdefined( zombies[i].ignore_game_over_death ) && zombies[i].ignore_game_over_death ) )
		{
			continue;
		}
		
		wait( 0.5 + RandomFloat( 2 ) );

		if ( isdefined( zombies[i] ) )
		{
			if( !IsVehicle( zombies[i] ) )
			{
				zombies[i] zombie_utility::zombie_head_gib();
			}
			
			zombies[i] Kill();
		}
	}
}

function player_intermission()
{
	self closeInGameMenu();

	level endon( "stop_intermission" );
	self endon("disconnect");
	self endon("death");
	self notify( "_zombie_game_over" ); // ww: notify so hud elements know when to leave

	//Show total gained point for end scoreboard and lobby
	self.score = self.score_total;	

	self.sessionstate = "intermission";
	self.spectatorclient = -1; 
	self.killcamentity = -1; 
	self.archivetime = 0; 
	self.psoffsettime = 0; 
	self.friendlydamage = undefined;

	points =struct::get_array( "intermission", "targetname" );

	if( !IsDefined( points ) || points.size == 0 )
	{
		points = getentarray( "info_intermission", "classname" ); 
		if( points.size < 1 )
		{
		/#	println( "NO info_intermission POINTS IN MAP" ); 	#/
			return;
		}	
	}

	self.game_over_bg = NewClientHudelem( self );
	self.game_over_bg.foreground = true;
	self.game_over_bg.sort = 100;
	self.game_over_bg.horzAlign = "fullscreen";
	self.game_over_bg.vertAlign = "fullscreen";
	self.game_over_bg SetShader( "black", 640, 480 );
	self.game_over_bg.alpha = 1;

	org = undefined;
	while( 1 )
	{
		points = array::randomize( points );
		for( i = 0; i < points.size; i++ )
		{
			point = points[i];
			// Only spawn once if we are using 'moving' org
			// If only using info_intermissions, this will respawn after 5 seconds.
			if( !IsDefined( org ) )
			{
				self Spawn( point.origin, point.angles );
			}

			// Only used with STRUCTS
			if( IsDefined( points[i].target ) )
			{
				if( !IsDefined( org ) )
				{
					org = Spawn( "script_model", self.origin + ( 0, 0, -60 ) );
					org SetModel("tag_origin");
				}

//				self LinkTo( org, "", ( 0, 0, -60 ), ( 0, 0, 0 ) );
//				self SetPlayerAngles( points[i].angles );
				org.origin = points[i].origin;
				org.angles = points[i].angles;
				

				for ( j = 0; j < GetPlayers().size; j++ )
				{
					player = GetPlayers()[j];
					player CameraSetPosition( org );
					player CameraSetLookAt();
					player CameraActivate( true );	
				}

				speed = 20;
				if( IsDefined( points[i].speed ) )
				{
					speed = points[i].speed;
				}

				target_point = struct::get( points[i].target, "targetname" );
				dist = Distance( points[i].origin, target_point.origin );
				time = dist / speed;

				q_time = time * 0.25;
				if( q_time > 1 )
				{
					q_time = 1;
				}

				self.game_over_bg FadeOverTime( q_time );
				self.game_over_bg.alpha = 0;

				org MoveTo( target_point.origin, time, q_time, q_time );
				org RotateTo( target_point.angles, time, q_time, q_time );
				wait( time - q_time );

				self.game_over_bg FadeOverTime( q_time );
				self.game_over_bg.alpha = 1;

				wait( q_time );
			}
			else
			{
				self.game_over_bg FadeOverTime( 1 );
				self.game_over_bg.alpha = 0;

				wait( 5 );
				
				self.game_over_bg thread fade_up_over_time(1);

				//wait( 1 );
			}
		}
	}
}

function fade_up_over_time(t)
{
		self FadeOverTime( t );
		self.alpha = 1;
}

function default_exit_level()
{
	zombies = GetAiTeamArray( level.zombie_team );
	for ( i = 0; i < zombies.size; i++ )
	{
		if ( ( isdefined( zombies[i].ignore_solo_last_stand ) && zombies[i].ignore_solo_last_stand ) )
		{
			continue;
		}

		if ( isDefined( zombies[i].find_exit_point ) )
		{
			zombies[i] thread [[ zombies[i].find_exit_point ]]();
			continue;
		}

		if ( zombies[i].ignoreme )
		{
			zombies[i] thread default_delayed_exit();
		}
		else
		{
			zombies[i] thread default_find_exit_point();
		}
	}
}

function default_delayed_exit()
{
	self endon( "death" );

	while ( 1 )
	{
		if ( !level flag::get( "wait_and_revive" ) )
		{
			return;
		}

		// broke through the barricade, find an exit point
		if ( !self.ignoreme )
		{
			break;
		}
		wait( 0.1 );
	}

	self thread default_find_exit_point();
}

function default_find_exit_point()
{
	self endon( "death" );

	player = GetPlayers()[0];

	dist_zombie = 0;
	dist_player = 0;
	dest = 0;

	away = VectorNormalize( self.origin - player.origin );
	endPos = self.origin + VectorScale( away, 600 );

	if ( isdefined( level.zm_loc_types[ "wait_location" ] && level.zm_loc_types[ "wait_location" ].size > 0 ) )
    {
		locs = array::randomize( level.zm_loc_types[ "wait_location" ] );
    }
	//TODO Add wait_locations to Der Reise and we can remove this line
	else	// Legacy catch
	{
		locs = array::randomize( level.zm_loc_types[ "dog_location" ] );
	}

	for ( i = 0; i < locs.size; i++ )
	{
		dist_zombie = DistanceSquared( locs[i].origin, endPos );
		dist_player = DistanceSquared( locs[i].origin, player.origin );

		if ( dist_zombie < dist_player )
		{
			dest = i;
			break;
		}
	}

	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );

	if( isdefined( locs[dest] ) )
	{
		self SetGoal( locs[dest].origin );
	}

	while ( 1 )
	{
		// in the event this function isn't run through a solo revive, use level override to dictate behavior; don't change existing behavior if this doesn't exist
		b_passed_override = true;
		
		// Returning 'false' from the level override will put zombies back into find_flesh
		if ( IsDefined( level.default_find_exit_position_override ) )
		{
			b_passed_override = [[ level.default_find_exit_position_override ]]();
		}
		
		if ( !level flag::get( "wait_and_revive" ) && b_passed_override )
		{
			break;
		}
		wait( 0.1 );
	}
	
}

function play_level_start_vox_delayed()
{
    wait(3);
    players = GetPlayers();
	num = RandomIntRange( 0, players.size );
	players[num] zm_audio::create_and_play_dialog( "general", "intro" );
}


function register_sidequest( id, sidequest_stat )
{
	if ( !IsDefined( level.zombie_sidequest_stat ) )
	{
		level.zombie_sidequest_previously_completed = [];
		level.zombie_sidequest_stat = [];
	}
	
	level.zombie_sidequest_stat[id] = sidequest_stat;

	//level flag::wait_till( "all_players_spawned" );
	level flag::wait_till( "start_zombie_round_logic" );

	level.zombie_sidequest_previously_completed[id] = false;

	// don't do stats stuff if it's not an online game
	if ( level.systemLink || GetDvarInt( "splitscreen_playerCount" ) == GetPlayers().size )
	{
		return;
	}
	
	//don't do stats stuff if stats are disabled
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{	
		return;	
	}

	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] zm_stats::get_global_stat( level.zombie_sidequest_stat[id] ) )
		{
			level.zombie_sidequest_previously_completed[id] = true;
			return;
		}
	}
}


function is_sidequest_previously_completed(id)
{
	return ( isdefined( level.zombie_sidequest_previously_completed[id] ) && level.zombie_sidequest_previously_completed[id] );
}


function set_sidequest_completed(id)
{
	level notify( "zombie_sidequest_completed", id );
	level.zombie_sidequest_previously_completed[id] = true;

	// don't do stats stuff if it's not an online game
	if ( level.systemLink )
	{
		return; 
	}
	if ( GetDvarInt( "splitscreen_playerCount" ) == GetPlayers().size )
	{
		return;
	}

	//don't do stats stuff if stats are disabled
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{	
		return;	
	}	

	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( isdefined( level.zombie_sidequest_stat[id] ) )
		{
			players[i] zm_stats::add_global_stat( level.zombie_sidequest_stat[id], 1 );
		}
	}
}

function playSwipeSound( mod, attacker )
{
	if( ( isdefined( attacker.is_zombie ) && attacker.is_zombie ) || (isdefined( attacker.archetype ) && attacker.archetype == "margwa" ) )
	{
		self playsoundtoplayer( "evt_player_swiped", self );
		return;
	}
}

function precache_zombie_leaderboards()
{
	// don't save leaderboards for systemlink or custom games
	if( SessionModeIsSystemlink() )
	{
		return; 
	}

	// global ones
	globalLeaderboards = "LB_ZM_GB_BULLETS_FIRED_AT ";
	globalLeaderboards += "LB_ZM_GB_BULLETS_HIT_AT "; 
	globalLeaderboards += "LB_ZM_GB_DEATHS_AT "; 
	globalLeaderboards += "LB_ZM_GB_DISTANCE_TRAVELED_AT "; 
	globalLeaderboards += "LB_ZM_GB_DOORS_PURCHASED_AT "; 
	globalLeaderboards += "LB_ZM_GB_DOWNS_AT "; 
	globalLeaderboards += "LB_ZM_GB_GIBS_AT "; 
	globalLeaderboards += "LB_ZM_GB_GRENADE_KILLS_AT "; 
	globalLeaderboards += "LB_ZM_GB_HEADSHOTS_AT "; 
	globalLeaderboards += "LB_ZM_GB_KILLS_AT "; 
	globalLeaderboards += "LB_ZM_GB_PERKS_DRANK_AT "; 
	globalLeaderboards += "LB_ZM_GB_REVIVES_AT "; 

	if(  SessionModeIsPrivateOnlineGame() )
	{
		precacheLeaderboards( globalLeaderboards );
		return;
	}
	
	// gamemode leaderboards
	mapLocationName = level.scr_zm_map_start_location;
	if ((mapLocationName == "default" || mapLocationName == "" ) && IsDefined(level.default_start_location))
	{
		mapLocationName = level.default_start_location;
	}			

	// zcleansed game will use the encounter game leaderboard style.
	if ( ( level.scr_zm_ui_gametype == "zclassic" || level.scr_zm_ui_gametype_group == "zsurvival" ) && level.scr_zm_ui_gametype != "zcleansed" )
	{		
		expectedPlayerNum = GetNumExpectedPlayers();
		if ( expectedPlayerNum == 1)
		{
			gamemodeLeaderboard = "LB_ZM_GM_"+ level.scr_zm_ui_gametype + "_" + mapLocationName + "_" + expectedPlayerNum + "PLAYER"; 
		}
		else
		{
			gamemodeLeaderboard = "LB_ZM_GM_"+ level.scr_zm_ui_gametype + "_" + mapLocationName + "_" + expectedPlayerNum + "PLAYERS"; 
		}
	}
	else // other game modes
	{		
		gamemodeLeaderboard = "LB_ZM_GM_" + level.scr_zm_ui_gametype + "_" + mapLocationName; 		
	}	

	precacheLeaderboards( globalLeaderboards + gamemodeLeaderboard );
}

function zm_on_player_connect()
{
	if( level.passed_introscreen)
	{
		self setClientUIVisibilityFlag( "hud_visible", 1 );
		self setClientUIVisibilityFlag( "weapon_hud_visible", 1 );
	}
	thread  refresh_player_navcard_hud();
	self thread watchDisconnect();

	self.hud_damagefeedback = newdamageindicatorhudelem(self);
	self.hud_damagefeedback.horzAlign = "center";
	self.hud_damagefeedback.vertAlign = "middle";
	self.hud_damagefeedback.x = -12;
	self.hud_damagefeedback.y = -12;
	self.hud_damagefeedback.alpha = 0;
	self.hud_damagefeedback.archived = true;
	self.hud_damagefeedback setShader( "damage_feedback", 24, 48 );
	self.hitSoundTracker = true;
}

function zm_on_player_disconnect()
{
	thread refresh_player_navcard_hud();
}

function watchDisconnect()
{
	self notify("watchDisconnect");
	self endon("watchDisconnect");
	self waittill("disconnect");
	zm_on_player_disconnect();
}



function increment_dog_round_stat(stat)
{
	players = GetPlayers();
	foreach(player in players)
	{
		player zm_stats::increment_client_stat( "zdog_rounds_" + stat );
	}
}

function setup_player_navcard_hud()
{
	level flag::wait_till( "start_zombie_round_logic" );
	thread refresh_player_navcard_hud();
}


function refresh_player_navcard_hud()
{
	if (!IsDefined(level.navcards))
		return;
	players = GetPlayers();
	foreach( player in players )
	{
		navcard_bits = 0;
		for(i = 0;i < level.navcards.size; i++)
		{
			hasit = player zm_stats::get_global_stat( level.navcards[i] );
			if (isdefined(player.navcard_grabbed) && player.navcard_grabbed == level.navcards[i] )
				hasit = 1;
			if( hasit )
			{
				navcard_bits +=( 1 << i );
			}
		}
		util::wait_network_frame();
		player clientfield::set( "navcard_held", 0 );
		if ( navcard_bits > 0 )
		{
			util::wait_network_frame();
			player clientfield::set( "navcard_held", navcard_bits );
		}
	}

}

function set_default_laststand_pistol(solo_mode)
{
		
	if (!solo_mode )
	{
		level.laststandpistol = level.default_laststandpistol;
	}
	else 
	{
		level.laststandpistol = level.default_solo_laststandpistol;
	}
	
}

//109171 	Zombies - ZM_Global - Add check for player count at beginning of the game
//monitors during the match for exploits extra players being able to join the match
function player_too_many_players_check()
{
	max_players = 4;
	if ( level.scr_zm_ui_gametype == "zgrief" || level.scr_zm_ui_gametype == "zmeat" )
	{
		max_players = 8;
	}

	if ( GetPlayers().size > max_players )
	{
		zm_game_module::freeze_players(true);
		level notify("end_game");
	}

}

//vehicle response to idgun damage
function is_idgun_damage( weapon )
{
	if( isdefined( level.idgun_weapons ) )
	{
		if ( IsInArray( level.idgun_weapons, weapon ) )
			return true; 
	}
	return false;
}

function zm_on_player_spawned()
{
	thread update_zone_name();
	thread update_is_player_valid();
}

function update_is_player_valid()
{
	self endon( "death" );
	self endon( "disconnnect" );
		
	self.am_i_valid = true;	
	while ( isDefined( self ) )
	{
		self.am_i_valid = zm_utility::is_player_valid( self, true );
		{wait(.05);}
	}
}

function update_zone_name()
{
	self endon( "death" );
	self endon( "disconnnect" );
	
	self.zone_name = zm_utility::get_current_zone();
	if ( isDefined( self.zone_name ) )
	{
		self.previous_zone_name = self.zone_name;
	}
	
	while ( isDefined( self ) )
	{
		if( isDefined( self.zone_name ) )
		{
			self.previous_zone_name = self.zone_name;
		}
		self.zone_name = zm_utility::get_current_zone();
		
		wait RandomFloatRange( 0.5, 1.0 );
	}
}
