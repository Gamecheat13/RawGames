#using scripts\codescripts\struct;

#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_score;

#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_weapons;

                                                                                       	                                


	
#namespace zm_stats;

function autoexec __init__sytem__() {     system::register("zm_stats",&__init__,undefined,undefined);    }

function __init__()
{
	// create a level function pointer, so that add_client_stat function can be called in non zm script file
	level.player_stats_init = &player_stats_init;
	level.add_client_stat = &add_client_stat;
	level.increment_client_stat = &increment_client_stat;
	level.track_gibs = &do_stats_for_gibs;	
}

function player_stats_init()
{
	self  globallogic_score::initPersStat( "kills", false );
	self  globallogic_score::initPersStat( "suicides", false );
	self  globallogic_score::initPersStat( "downs", false );
	self.downs = self  globallogic_score::getPersStat( "downs" );

	self  globallogic_score::initPersStat( "revives", false );
	self.revives = self  globallogic_score::getPersStat( "revives" );

	self  globallogic_score::initPersStat( "perks_drank", false );	
	self  globallogic_score::initPersStat( "headshots", false );
	
	self  globallogic_score::initPersStat( "gibs", false );	
	self  globallogic_score::initPersStat( "head_gibs", false );
	self  globallogic_score::initPersStat( "right_arm_gibs", false );
	self  globallogic_score::initPersStat( "left_arm_gibs", false );
	self  globallogic_score::initPersStat( "right_leg_gibs", false );
	self  globallogic_score::initPersStat( "left_leg_gibs", false );

	self  globallogic_score::initPersStat( "melee_kills", false );
	self  globallogic_score::initPersStat( "grenade_kills", false );
	self  globallogic_score::initPersStat( "doors_purchased", false );
	
	self  globallogic_score::initPersStat( "distance_traveled", false );
	self.distance_traveled = self  globallogic_score::getPersStat( "distance_traveled" );

	self  globallogic_score::initPersStat( "total_shots", false );
	self.total_shots = self  globallogic_score::getPersStat( "total_shots" );

	self  globallogic_score::initPersStat( "hits", false );
	self.hits = self  globallogic_score::getPersStat( "hits" );

	self  globallogic_score::initPersStat( "deaths", false );
	self.deaths = self  globallogic_score::getPersStat( "deaths" );

	self  globallogic_score::initPersStat( "boards", false );

	self  globallogic_score::initPersStat( "wins", false );
	self.totalwins = self  globallogic_score::getPersStat( "totalwins" );
	
	self  globallogic_score::initPersStat( "losses", false );
	self.totallosses = self  globallogic_score::getPersStat( "totallosses" );
	
	self  globallogic_score::initPersStat( "failed_revives", false );	
	self  globallogic_score::initPersStat( "sacrifices", false );		
	self  globallogic_score::initPersStat( "failed_sacrifices", false );	
	self  globallogic_score::initPersStat( "drops", false );	
	//individual drops pickedup
	self  globallogic_score::initPersStat( "nuke_pickedup",false);
	self  globallogic_score::initPersStat( "insta_kill_pickedup",false);
	self  globallogic_score::initPersStat( "full_ammo_pickedup",false);
	self  globallogic_score::initPersStat( "double_points_pickedup",false);
	self  globallogic_score::initPersStat( "meat_stink_pickedup",false);
	self  globallogic_score::initPersStat( "carpenter_pickedup",false);
	self  globallogic_score::initPersStat( "fire_sale_pickedup",false);
	self  globallogic_score::initPersStat( "zombie_blood_pickedup", false );
	self  globallogic_score::initPersStat( "time_bomb_ammo_pickedup",false);
	
	self  globallogic_score::initPersStat( "use_magicbox", false );	
	self  globallogic_score::initPersStat( "grabbed_from_magicbox", false );		
	self  globallogic_score::initPersStat( "use_perk_random", false );	
	self  globallogic_score::initPersStat( "grabbed_from_perk_random", false );		
	self  globallogic_score::initPersStat( "use_pap", false );	
	self  globallogic_score::initPersStat( "pap_weapon_grabbed", false );	
	self  globallogic_score::initPersStat( "pap_weapon_not_grabbed", false );
	
	//individual perks drank
	self  globallogic_score::initPersStat( "specialty_armorvest_drank", false );	
	self  globallogic_score::initPersStat( "specialty_quickrevive_drank", false );	
	self  globallogic_score::initPersStat( "specialty_doubletap2_drank", false );	
	self  globallogic_score::initPersStat( "specialty_fastreload_drank", false );	
	self  globallogic_score::initPersStat( "specialty_phdflopper_drank", false );	
	self  globallogic_score::initPersStat( "specialty_additionalprimaryweapon_drank", false );	
	self  globallogic_score::initPersStat( "specialty_staminup_drank", false );	
	self  globallogic_score::initPersStat( "specialty_deadshot_drank", false );	
	self  globallogic_score::initPersStat( "specialty_tombstone_drank", false );
	self  globallogic_score::initPersStat( "specialty_whoswho_drank", false );
	self  globallogic_score::initPersStat( "specialty_electriccherry_drank", false );
	self  globallogic_score::initPersStat( "specialty_vultureaid" + "_drank", false );	
	
	//weapons that can be planted/picked up ( claymores, ballistics...)
	self  globallogic_score::initPersStat( "claymores_planted", false );	
	self  globallogic_score::initPersStat( "claymores_pickedup", false );	
	self  globallogic_score::initPersStat( "ballistic_knives_pickedup", false );
	
	self  globallogic_score::initPersStat( "wallbuy_weapons_purchased", false );
	self  globallogic_score::initPersStat( "ammo_purchased", false );
	self  globallogic_score::initPersStat( "upgraded_ammo_purchased", false );
	
	self  globallogic_score::initPersStat( "power_turnedon", false );	
	self  globallogic_score::initPersStat( "power_turnedoff", false );
	self  globallogic_score::initPersStat( "planted_buildables_pickedup", false );	
	self  globallogic_score::initPersStat( "buildables_built", false );
	self  globallogic_score::initPersStat( "time_played_total", false );
	self  globallogic_score::initPersStat( "weighted_rounds_played", false ); //ex: round 5 = 1+2+3+4+5 = 15;
	self  globallogic_score::initPersStat( "contaminations_received", false );	
	self  globallogic_score::initPersStat( "contaminations_given", false );		
	
	self  globallogic_score::initpersstat( "zdogs_killed", false );
	self  globallogic_score::initpersstat( "zdog_rounds_finished", false );
	self  globallogic_score::initpersstat( "zdog_rounds_lost", false );
	self  globallogic_score::initpersstat( "killed_by_zdog", false );
	self  globallogic_score::initpersstat( "screecher_minigames_won", false );
	self  globallogic_score::initpersstat( "screecher_minigames_lost", false );
	self  globallogic_score::initpersstat( "screechers_killed", false );
	self  globallogic_score::initpersstat( "screecher_teleporters_used", false );
	self  globallogic_score::initpersstat( "avogadro_defeated", false );
	self  globallogic_score::initpersstat( "killed_by_avogadro", false );
	
	//cheats
	self  globallogic_score::initPersStat( "cheat_too_many_weapons", false );	
	self  globallogic_score::initPersStat( "cheat_out_of_playable", false );	
	self  globallogic_score::initPersStat( "cheat_too_friendly",false);
	self  globallogic_score::initPersStat( "cheat_total",false);

	self  globallogic_score::initPersStat( "prison_tomahawk_acquired", false );
	self  globallogic_score::initPersStat( "prison_fan_trap_used", false );
	self  globallogic_score::initPersStat( "prison_acid_trap_used", false );
	self  globallogic_score::initPersStat( "prison_sniper_tower_used", false );
	self  globallogic_score::initPersStat( "prison_ee_good_ending", false );
	self  globallogic_score::initPersStat( "prison_ee_bad_ending", false );
	self  globallogic_score::initPersStat( "prison_ee_spoon_acquired", false );
	self  globallogic_score::initPersStat( "prison_brutus_killed", false );

	self  globallogic_score::initPersStat( "buried_lsat_purchased", false );
	self  globallogic_score::initPersStat( "buried_fountain_transporter_used", false );
	self  globallogic_score::initPersStat( "buried_ghost_killed", false );
	self  globallogic_score::initPersStat( "buried_ghost_drained_player", false );
	self  globallogic_score::initPersStat( "buried_ghost_perk_acquired", false );
	self  globallogic_score::initPersStat( "buried_sloth_booze_given", false );
	self  globallogic_score::initPersStat( "buried_sloth_booze_break_barricade", false );
	self  globallogic_score::initPersStat( "buried_sloth_candy_given", false );
	self  globallogic_score::initPersStat( "buried_sloth_candy_protect", false );
	self  globallogic_score::initPersStat( "buried_sloth_candy_build_buildable", false );
	self  globallogic_score::initPersStat( "buried_sloth_candy_wallbuy", false );
	self  globallogic_score::initPersStat( "buried_sloth_candy_fetch_buildable", false );
	self  globallogic_score::initPersStat( "buried_sloth_candy_box_lock", false );
	self  globallogic_score::initPersStat( "buried_sloth_candy_box_move", false );
	self  globallogic_score::initPersStat( "buried_sloth_candy_box_spin", false );
	self  globallogic_score::initPersStat( "buried_sloth_candy_powerup_cycle", false );
	self  globallogic_score::initPersStat( "buried_sloth_candy_dance", false );
	self  globallogic_score::initPersStat( "buried_sloth_candy_crawler", false );
	self  globallogic_score::initPersStat( "buried_wallbuy_placed", false );
	self  globallogic_score::initPersStat( "buried_wallbuy_placed_pdw57_zm", false );
	self  globallogic_score::initPersStat( "buried_wallbuy_placed_svu_zm", false );
	self  globallogic_score::initPersStat( "buried_wallbuy_placed_tazer_knuckles_zm", false );
	self  globallogic_score::initPersStat( "buried_wallbuy_placed_870mcs_zm", false );

	self  globallogic_score::initPersStat( "tomb_mechz_killed", false );
	self  globallogic_score::initPersStat( "tomb_giant_robot_stomped", false );
	self  globallogic_score::initPersStat( "tomb_giant_robot_accessed", false );
	self  globallogic_score::initPersStat( "tomb_generator_captured", false );
	self  globallogic_score::initPersStat( "tomb_generator_defended", false );
	self  globallogic_score::initPersStat( "tomb_generator_lost", false );
	self  globallogic_score::initPersStat( "tomb_dig", false );
	self  globallogic_score::initPersStat( "tomb_golden_shovel", false );
	self  globallogic_score::initPersStat( "tomb_golden_hard_hat", false );
	self  globallogic_score::initPersStat( "tomb_perk_extension", false );
	
	//persistent systems
	self globallogic_score::initPersStat( "pers_boarding", false, true );
	self globallogic_score::initPersStat( "pers_revivenoperk", false, true );
	self globallogic_score::initPersStat( "pers_multikill_headshots", false, true );
	self globallogic_score::initPersStat( "pers_cash_back_bought", false, true );				// "cash_back" - stat 1
	self globallogic_score::initPersStat( "pers_cash_back_prone", false, true );				// "cash_back" - stat 2 (prone stat only gets updated once the "bought" stat is updated
	self globallogic_score::initPersStat( "pers_insta_kill", false, true );
	self globallogic_score::initPersStat( "pers_nube_5_times", false, true );
	self globallogic_score::initPersStat( "pers_jugg", false, true );
	self globallogic_score::initPersStat( "pers_jugg_downgrade_count", false, true );
	self globallogic_score::initPersStat( "pers_carpenter", false, true );
	self globallogic_score::initPersStat( "pers_max_round_reached", false, true );

	self globallogic_score::initPersStat( "pers_flopper_counter", false, true );
	self globallogic_score::initPersStat( "pers_perk_lose_counter", false, true );
	self globallogic_score::initPersStat( "pers_pistol_points_counter", false, true );
	self globallogic_score::initPersStat( "pers_double_points_counter", false, true );
	self globallogic_score::initPersStat( "pers_sniper_counter", false, true );

	self globallogic_score::initPersStat( "pers_marathon_counter", false, true );
	self globallogic_score::initPersStat( "pers_box_weapon_counter", false, true );
	self globallogic_score::initPersStat( "pers_zombie_kiting_counter", false, true );
	self globallogic_score::initPersStat( "pers_max_ammo_counter", false, true );

	self globallogic_score::initPersStat( "pers_melee_bonus_counter", false, true );
	self globallogic_score::initPersStat( "pers_nube_counter", false, true );
	self globallogic_score::initPersStat( "pers_last_man_standing_counter", false, true );
	self globallogic_score::initPersStat( "pers_reload_speed_counter", false, true );
	
	// Persistent system "player" globals
	self zm_pers_upgrades::pers_abilities_init_globals();
	
	// some extra ... 
	self  globallogic_score::initPersStat( "score", false );
	if ( level.resetPlayerScoreEveryRound )
	{
		self.pers["score"] = 0;
	}
	
	self.pers["score"] = level.player_starting_points;
	self.score = self.pers["score"];
	self IncrementPlayerStat("score", self.score );

	self globallogic_score::initPersStat( "zteam", false );

	if ( IsDefined( level.level_specific_stats_init ) )
	{
		[[ level.level_specific_stats_init ]]();
	}

	if( !isDefined( self.stats_this_frame ) )
	{
		self.pers_upgrade_force_test = true;
		self.stats_this_frame = [];				// used to track if stats is update in current frame
		self.pers_upgrades_awarded = [];
	}
}

function update_players_stats_at_match_end( players )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	// update the player stats at the end of match
	game_mode = GetDvarString( "ui_gametype" );
	game_mode_group = level.scr_zm_ui_gametype_group;
	map_location_name = level.scr_zm_map_start_location;

	// will be updated based on info from gametypesTable.csv 
	if ( map_location_name == "" )
		map_location_name = "default";
	if( IsDefined( level.gameModuleWinningTeam ) )
	{
		if( level.gameModuleWinningTeam == "B" )
		{
			MatchRecorderIncrementHeaderStat( "winningTeam", 1 );
		}
		else if ( level.gameModuleWinningTeam == "A" )
		{
			MatchRecorderIncrementHeaderStat( "winningTeam", 2 );
		}
	}
	RecordMatchSummaryZombieEndGameData( game_mode, game_mode_group, map_location_name, level.round_number );
	newTime = gettime();
	for ( i = 0; i < players.size; i++ ) 
	{	
		player = players[i];
		
		if ( player util::is_bot() )
			continue;

		distance = player get_stat_distance_traveled();
		
		player AddPlayerStatWithGameType( "distance_traveled", distance );
		
		// Add the "time_played_total" to startlocation stats and map stats
		player add_location_gametype_stat( level.scr_zm_map_start_location, level.scr_zm_ui_gametype, "time_played_total", player.pers["time_played_total"] );

		RecordPlayerMatchEnd( player );
		RecordPlayerStats(player, "presentAtEnd", 1 );
		player zm_weapons::updateWeaponTimingsZM( newTime );

		if(isdefined(level._game_module_stat_update_func))
		{
			player [[level._game_module_stat_update_func]]();
		}

		//high score
		old_high_score = player get_game_mode_stat(game_mode,"score");
		if(player.score_total > old_high_score)
		{
			player set_game_mode_stat(game_mode,"score",player.score_total);
		}
		
		if ( GameModeIsMode( 0 ) )
		{
			player GameHistoryFinishMatch( 4, 0, 0, 0, 0, 0 );
				
			if ( IsDefined( player.pers["matchesPlayedStatsTracked"] ) )
			{
				gameMode = globallogic::GetCurrentGameMode();
				player globallogic::IncrementMatchCompletionStat( gameMode, "played", "completed" );
					
				if ( IsDefined( player.pers["matchesHostedStatsTracked"] ) )
				{
					player globallogic::IncrementMatchCompletionStat( gameMode, "hosted", "completed" );
					player.pers["matchesHostedStatsTracked"] = undefined;
				}
				
				player.pers["matchesPlayedStatsTracked"] = undefined;
			}
		}

		if ( !IsDefined( player.pers["previous_distance_traveled"] ) )
		{
			player.pers["previous_distance_traveled"] = 0;
		}
		distanceThisRound = int( player.pers["distance_traveled"] - player.pers["previous_distance_traveled"] );
		player.pers["previous_distance_traveled"] = player.pers["distance_traveled"];
		player IncrementPlayerStat("distance_traveled", distanceThisRound );
	}
}

function update_playing_utc_time( matchEndUTCTime )
{
	current_days = int (matchEndUTCTime / 86400); // days

	last_days = self get_global_stat( "TIMESTAMPLASTDAY1" );
	last_days = int (last_days / 86400);
	diff_days = current_days - last_days;
	timestamp_name = "";
	if ( diff_days > 0 )
	{
		// shift the left values
		for( i = 5; i > diff_days ; i--)
		{
			timestamp_name = "TIMESTAMPLASTDAY" + (i - diff_days);
			timestamp_name_to = "TIMESTAMPLASTDAY" + i;
			timestamp_value = self get_global_stat( timestamp_name );
			self set_global_stat( timestamp_name_to, timestamp_value ); 		
		}

		for( i = 2; (i <= diff_days && i < 6) ; i++)
		{
			timestamp_name = "TIMESTAMPLASTDAY" + i;
			self set_global_stat( timestamp_name, 0 ); 		
		}
		
		// set the current utc to TIMESTAMPLASTDAY1
		self set_global_stat( "TIMESTAMPLASTDAY1", matchEndUTCTime );
	}
}

function survival_classic_custom_stat_update()
{
	// self set_global_stat( "combined_rank", self get_stat_combined_rank_value_survival_classic() );
}

function grief_custom_stat_update()
{
	// self set_global_stat( "combined_rank", self get_stat_combined_rank_value_grief() );
}

//**************************************************************
//**************************************************************
// DDL stats operation functions

function add_game_mode_group_stat( game_mode, stat_name, value )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self AddDStat( "PlayerStatsByGameTypeGroup", game_mode, stat_name, "statValue", value );
}

function set_game_mode_group_stat( game_mode, stat_name, value )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self SetDStat( "PlayerStatsByGameTypeGroup", game_mode, stat_name, "statValue", value );
}

function get_game_mode_group_stat( game_mode, stat_name)
{
	return ( self GetDStat( "PlayerStatsByGameTypeGroup", game_mode, stat_name, "statValue" ) );
}

//--------------------------------------------------------------
function add_game_mode_stat( game_mode, stat_name, value )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self AddDStat( "PlayerStatsByGameType", game_mode, stat_name, "statValue", value );
}

function set_game_mode_stat( game_mode, stat_name, value )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self SetDStat( "PlayerStatsByGameType", game_mode, stat_name, "statValue", value );
}

function get_game_mode_stat( game_mode, stat_name)
{
	return ( self GetDStat( "PlayerStatsByGameType", game_mode, stat_name, "statValue" ) );
}

//--------------------------------------------------------------
function get_global_stat( stat_name )
{
	return ( self GetDStat( "PlayerStatsList", stat_name, "StatValue" ) );
}

function set_global_stat( stat_name, value )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self SetDStat( "PlayerStatsList", stat_name, "StatValue", value );
}

function add_global_stat( stat_name, value )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self AddDStat( "PlayerStatsList", stat_name, "StatValue", value );
}

//--------------------------------------------------------------
function get_map_stat( stat_name, map = level.script )
{
	return ( self GetDStat( "PlayerStatsByMap", map, stat_name ) );
}

function set_map_stat( stat_name, value, map = level.script )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self SetDStat( "PlayerStatsByMap", map, stat_name, value );
}

function add_map_stat( stat_name, value, map = level.script )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self AddDStat( "PlayerStatsByMap", map, stat_name, value );
}

//--------------------------------------------------------------
function get_location_gametype_stat( start_location, game_type, stat_name )
{
	return ( self GetDStat( "PlayerStatsByStartLocation", start_location, "startLocationGameTypeStats", game_type, "stats", stat_name, "StatValue" ) );
}

function set_location_gametype_stat( start_location, game_type, stat_name, value )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self SetDStat( "PlayerStatsByStartLocation", start_location, "startLocationGameTypeStats", game_type, "stats", stat_name, "StatValue", value );
}

function add_location_gametype_stat( start_location, game_type, stat_name, value )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self AddDStat( "PlayerStatsByStartLocation", start_location, "startLocationGameTypeStats", game_type, "stats", stat_name, "StatValue", value );
}

//--------------------------------------------------------------
function get_map_weaponlocker_stat( stat_name, map = level.script )
{
	return ( self GetDStat( "PlayerStatsByMap", map, "weaponLocker", stat_name ) );
}

function set_map_weaponlocker_stat( stat_name, value, map = level.script )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	if (isdefined(value))
		self SetDStat( "PlayerStatsByMap", map, "weaponLocker", stat_name, value );
	else
		self SetDStat( "PlayerStatsByMap", map, "weaponLocker", stat_name, 0 );
}

function add_map_weaponlocker_stat( stat_name, value, map = level.script )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self AddDStat( "PlayerStatsByMap", map, "weaponLocker", stat_name, value );
}

function has_stored_weapondata( map = level.script )
{
	storedWeapon = self get_map_weaponlocker_stat( "weapon", map );
	if ( !IsDefined( storedWeapon ) || 
	     ( IsString( storedWeapon ) && storedWeapon == "" ) || 
	     ( IsInt( storedWeapon ) && storedWeapon == 0 ) )
			return false;
	return true;
}

function get_stored_weapondata( map = level.script )
{
	if ( self has_stored_weapondata(map) )
	{
		weapondata = [];
		weapondata["weapon"]     = self get_map_weaponlocker_stat( "weapon",      map );
		weapondata["lh_clip"]    = self get_map_weaponlocker_stat( "lh_clip",   map );
		weapondata["clip"]       = self get_map_weaponlocker_stat( "clip",      map );
		weapondata["stock"]      = self get_map_weaponlocker_stat( "stock",     map );
		weapondata["alt_clip"]   = self get_map_weaponlocker_stat( "alt_clip",  map );
		weapondata["alt_stock"]  = self get_map_weaponlocker_stat( "alt_stock", map );
		return weapondata;
	}
	return undefined;
}

function clear_stored_weapondata( map = level.script )
{
	self set_map_weaponlocker_stat( "weapon",    "", map );
	self set_map_weaponlocker_stat( "lh_clip" ,  0 , map );
	self set_map_weaponlocker_stat( "clip",      0 , map );
	self set_map_weaponlocker_stat( "stock",     0 , map );
	self set_map_weaponlocker_stat( "alt_clip",  0 , map );
	self set_map_weaponlocker_stat( "alt_stock", 0 , map );
}

function set_stored_weapondata( weapondata, map = level.script )
{
	self set_map_weaponlocker_stat( "weapon",    weapondata["weapon"].name , map );
	self set_map_weaponlocker_stat( "lh_clip" ,  weapondata["lh_clip"]     , map );
	self set_map_weaponlocker_stat( "clip",      weapondata["clip"]        , map );
	self set_map_weaponlocker_stat( "stock",     weapondata["stock"]       , map );
	self set_map_weaponlocker_stat( "alt_clip",  weapondata["alt_clip"]    , map );
	self set_map_weaponlocker_stat( "alt_stock", weapondata["alt_stock"]   , map );
}





//**************************************************************
//**************************************************************

function add_client_stat( stat_name, stat_value,include_gametype )
{
	if ( GetDvarString( "ui_zm_mapstartlocation" ) == "" || ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	if(!isDefined(include_gametype))
	{
		include_gametype = true;
	}
	
	self globallogic_score::incPersStat( stat_name, stat_value, false, include_gametype );	
	self.stats_this_frame[stat_name] = true;
}

function increment_player_stat( stat_name )
{
	if ( GetDvarString( "ui_zm_mapstartlocation" ) == "" || ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self IncrementPlayerStat( stat_name, 1 );
}

function increment_root_stat(stat_name,stat_value)
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self  AddDStat( stat_name, stat_value );
}

function increment_client_stat( stat_name,include_gametype )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	add_client_stat( stat_name, 1,include_gametype );
}

function set_client_stat( stat_name, stat_value, include_gametype )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	current_stat_count = self  globallogic_score::getPersStat( stat_name );
	self globallogic_score::incPersStat( stat_name, stat_value - current_stat_count, false, include_gametype );	
	self.stats_this_frame[stat_name] = true;
}

function zero_client_stat( stat_name, include_gametype )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	current_stat_count = self  globallogic_score::getPersStat( stat_name );
	self globallogic_score::incPersStat( stat_name, -current_stat_count, false, include_gametype );	
	self.stats_this_frame[stat_name] = true;
}

//-------------------------------------------
function increment_map_cheat_stat( stat_name )
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	self AddDStat( "PlayerStatsByMap", level.script, "cheats", stat_name, 1 );
}
//-------------------------------------------


//**************************************************************
//**************************************************************

function get_stat_distance_traveled()
{
	miles = int( self.pers["distance_traveled"] / 63360 );
	
	remainder = (self.pers["distance_traveled"] / 63360) - miles;
	
	if(miles < 1 && ( remainder < 0.5 ) ) 
	{
		miles = 1;
	}	
	else if(remainder >= 0.5)
	{
		miles++;
	}
		
	return miles; //int( self.pers["distance_traveled"] / 63360 ); // upload distance in miles since current distance was to capture in inches, 
}

function get_stat_round_number()
{
	return ( level.round_number );
}

function get_stat_combined_rank_value_survival_classic()
{
	rounds = get_stat_round_number();
	kills = self.pers["kills"];

	if( rounds > 99 ) 
		rounds = 99;

	result = rounds*10000000 + kills;
	return result;
}

function get_stat_combined_rank_value_grief()
{
	wins = self.pers["wins"];
	losses = self.pers["losses"];
	
	if ( wins > 9999 )
	{
		wins = 9999;
	}

	if ( losses > 9999 )
	{
		losses = 9999;
	}

	losses_value = 9999 - losses;

	result = wins*10000 + losses_value;
	return result;
}

//**************************************************************
//**************************************************************
function update_global_counters_on_match_end()
{
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{
		return;
	}

	deaths = 0;
	kills = 0;
	melee_kills = 0;
	headshots = 0;
	suicides = 0;
	downs = 0;
	revives = 0;
	perks_drank = 0;
	gibs = 0;
	doors_purchased = 0;
	distance_traveled = 0;
	total_shots = 0;
	boards = 0;
	sacrifices = 0;
	drops = 0;
	nuke_pickedup = 0;
	insta_kill_pickedup = 0;
	full_ammo_pickedup = 0;
	double_points_pickedup = 0;
	meat_stink_pickedup = 0;
	carpenter_pickedup = 0;
	fire_sale_pickedup = 0;
	zombie_blood_pickedup = 0;
	use_magicbox = 0;
	grabbed_from_magicbox = 0;
	use_perk_random = 0;
	grabbed_from_perk_random = 0;
	use_pap = 0;
	pap_weapon_grabbed = 0;
	specialty_armorvest_drank = 0;
	specialty_quickrevive_drank = 0;
	specialty_fastreload_drank = 0;
	specialty_staminup_drank = 0;
	specialty_tombstone_drank = 0;
	specialty_doubletap2_drank = 0;
	specialty_deadshot_drank = 0;
	specialty_phdflopper_drank = 0;
	specialty_additionalprimaryweapon_drank = 0;
	specialty_whoswho_drank = 0;
	specialty_electriccherry_drank = 0;
	specialty_vultureaid_drank = 0;
	claymores_planted = 0;
	claymores_pickedup = 0;
	ballistic_knives_pickedup = 0;
	wallbuy_weapons_purchased = 0;
	power_turnedon = 0;
	power_turnedoff = 0;
	planted_buildables_pickedup = 0;
	ammo_purchased = 0;
	upgraded_ammo_purchased = 0;
	buildables_built = 0;
	time_played = 0;
	contaminations_received = 0;
	contaminations_given = 0;	
	cheat_too_many_weapons = 0;
	cheat_out_of_playable_area = 0;
	cheat_too_friendly = 0;
	cheat_total = 0;	
	
	players = GetPlayers();
	foreach(player in players)
	{
		deaths 										+= player.pers["deaths"];
		kills 										+= player.pers["kills"];		
		headshots 									+= player.pers["headshots"];
		suicides 									+= player.pers["suicides"];		
		melee_kills 								+= player.pers["melee_kills"];
		downs 										+= player.pers["downs"];
		revives										+= player.pers["revives"];
		perks_drank									+= player.pers["perks_drank"];		
		specialty_armorvest_drank					+= player.pers["specialty_armorvest_drank"];
		specialty_quickrevive_drank					+= player.pers["specialty_quickrevive_drank"];
		specialty_fastreload_drank					+= player.pers["specialty_fastreload_drank"];
		specialty_staminup_drank					+= player.pers["specialty_staminup_drank"];
		specialty_doubletap2_drank					+= player.pers["specialty_doubletap2_drank"];
		specialty_deadshot_drank					+= player.pers["specialty_deadshot_drank"];
		specialty_tombstone_drank					+= player.pers["specialty_tombstone_drank"];
		specialty_phdflopper_drank					+= player.pers["specialty_phdflopper_drank"];
		specialty_additionalprimaryweapon_drank		+= player.pers["specialty_additionalprimaryweapon_drank"];		
		specialty_whoswho_drank						+= player.pers["specialty_whoswho_drank"];
		specialty_electriccherry_drank				+= player.pers["specialty_electriccherry_drank"];
		specialty_vultureaid_drank					+= player.pers[ "specialty_vultureaid" + "_drank"];
		gibs										+= player.pers["gibs"];
		doors_purchased								+= player.pers["doors_purchased"];
		distance_traveled							+= player get_stat_distance_traveled();
		boards										+= player.pers["boards"];
		sacrifices									+= player.pers["sacrifices"];
		drops										+= player.pers["drops"];
		nuke_pickedup 								+= player.pers["nuke_pickedup"];
		insta_kill_pickedup							+= player.pers["insta_kill_pickedup"];
		full_ammo_pickedup 							+= player.pers["full_ammo_pickedup"];
		double_points_pickedup 						+= player.pers["double_points_pickedup"];
		meat_stink_pickedup 						+= player.pers["meat_stink_pickedup"];
		carpenter_pickedup							+= player.pers["carpenter_pickedup"];
		fire_sale_pickedup							+= player.pers["fire_sale_pickedup"];
		zombie_blood_pickedup						+= player.pers["zombie_blood_pickedup"];
		use_magicbox								+= player.pers["use_magicbox"];
		grabbed_from_magicbox						+= player.pers["grabbed_from_magicbox"];
		use_perk_random								+= player.pers["use_perk_random"];
		grabbed_from_perk_random					+= player.pers["grabbed_from_perk_random"];
		use_pap										+= player.pers["use_pap"];
		pap_weapon_grabbed							+= player.pers["pap_weapon_grabbed"];
		claymores_planted							+= player.pers["claymores_planted"];
		claymores_pickedup							+= player.pers["claymores_pickedup"];
		ballistic_knives_pickedup					+= player.pers["ballistic_knives_pickedup"];
		wallbuy_weapons_purchased					+= player.pers["wallbuy_weapons_purchased"];
		power_turnedon								+= player.pers["power_turnedon"];
		power_turnedoff								+= player.pers["power_turnedoff"];
		planted_buildables_pickedup					+= player.pers["planted_buildables_pickedup"];
		buildables_built 							+= player.pers["buildables_built"];
		ammo_purchased								+= player.pers["ammo_purchased"];
		upgraded_ammo_purchased						+= player.pers["upgraded_ammo_purchased"];
		total_shots									+= player.total_shots;		
		time_played									+= player.pers["time_played_total"];
		contaminations_received						+= player.pers["contaminations_received"];
		contaminations_given						+= player.pers["contaminations_given"];		
		cheat_too_many_weapons 						+= player.pers["cheat_too_many_weapons"];
		cheat_out_of_playable_area 					+= player.pers["cheat_out_of_playable"];
		cheat_too_friendly 							+= player.pers["cheat_too_friendly"];
		cheat_total 								+= player.pers["cheat_total"];	
	}
	game_mode =  GetDvarString( "ui_gametype" );
	incrementCounter( "global_zm_" + game_mode ,1);	
	incrementCounter( "global_zm_games", 1 );

	if ( "zclassic" == game_mode || "zm_nuked" == level.script )
	{
		incrementCounter( "global_zm_games_" + level.script, 1 );
	}

	incrementCounter( "global_zm_killed", level.global_zombies_killed );
	incrementCounter( "global_zm_killed_by_players",kills );	
	incrementCounter( "global_zm_killed_by_traps",level.zombie_trap_killed_count);	

	incrementCounter( "global_zm_headshots", headshots );
	incrementCounter( "global_zm_suicides", suicides );
	incrementCounter( "global_zm_melee_kills", melee_kills );
	incrementCounter( "global_zm_downs", downs );
	incrementCounter( "global_zm_deaths", deaths );
	incrementCounter( "global_zm_revives", revives );	
	incrementCounter( "global_zm_perks_drank", perks_drank );
	incrementCounter( "global_zm_specialty_armorvest_drank", specialty_armorvest_drank );
	incrementCounter( "global_zm_specialty_quickrevive_drank", specialty_quickrevive_drank );
	incrementCounter( "global_zm_specialty_fastreload_drank", specialty_fastreload_drank );
	incrementCounter( "global_zm_specialty_staminup_drank", specialty_staminup_drank );	
	incrementCounter( "global_zm_specialty_doubletap2_drank", specialty_doubletap2_drank );
	incrementCounter( "global_zm_specialty_deadshot_drank", specialty_deadshot_drank );
	incrementCounter( "global_zm_specialty_tombstone_drank", specialty_tombstone_drank );
	incrementCounter( "global_zm_specialty_phdflopper_drank", specialty_phdflopper_drank );
	incrementCounter( "global_zm_specialty_additionalprimaryweapon_drank", specialty_additionalprimaryweapon_drank );		
	incrementCounter( "global_zm_specialty_whoswho_drank", specialty_whoswho_drank );
	incrementCounter( "global_zm_specialty_electriccherry_drank", specialty_electriccherry_drank );
	incrementCounter( "global_zm_" + "specialty_vultureaid" + "_drank", specialty_vultureaid_drank );
	incrementCounter( "global_zm_gibs", gibs );
	incrementCounter( "global_zm_distance_traveled", int(distance_traveled) );
	incrementCounter( "global_zm_doors_purchased", doors_purchased);	
	incrementCounter( "global_zm_boards", boards);
	incrementCounter( "global_zm_sacrifices", sacrifices);;
	incrementCounter( "global_zm_drops", drops);
	incrementCounter( "global_zm_total_nuke_pickedup",nuke_pickedup);
	incrementCounter( "global_zm_total_insta_kill_pickedup",insta_kill_pickedup);
	incrementCounter( "global_zm_total_full_ammo_pickedup",full_ammo_pickedup);
	incrementCounter( "global_zm_total_double_points_pickedup",double_points_pickedup);
	incrementCounter( "global_zm_total_meat_stink_pickedup",double_points_pickedup);
	incrementCounter( "global_zm_total_carpenter_pickedup",carpenter_pickedup);
	incrementCounter( "global_zm_total_fire_sale_pickedup",fire_sale_pickedup);
	incrementCounter( "global_zm_total_zombie_blood_pickedup",zombie_blood_pickedup);
	incrementCounter( "global_zm_use_magicbox", use_magicbox);
	incrementCounter( "global_zm_grabbed_from_magicbox", grabbed_from_magicbox);
	incrementCounter( "global_zm_use_perk_random", use_perk_random);
	incrementCounter( "global_zm_grabbed_from_perk_random", grabbed_from_perk_random);
	incrementCounter( "global_zm_use_pap", use_pap);
	incrementCounter( "global_zm_pap_weapon_grabbed", pap_weapon_grabbed);
	incrementCounter( "global_zm_claymores_planted", claymores_planted);
	incrementCounter( "global_zm_claymores_pickedup", claymores_pickedup);
	incrementCounter( "global_zm_ballistic_knives_pickedup", ballistic_knives_pickedup);
	incrementCounter( "global_zm_wallbuy_weapons_purchased", wallbuy_weapons_purchased);
	incrementCounter( "global_zm_power_turnedon", power_turnedon);
	incrementCounter( "global_zm_power_turnedoff", power_turnedoff);
	incrementCounter( "global_zm_planted_buildables_pickedup", planted_buildables_pickedup);
	incrementCounter( "global_zm_buildables_built", buildables_built);
	incrementCounter( "global_zm_ammo_purchased", ammo_purchased);
	incrementCounter( "global_zm_upgraded_ammo_purchased", upgraded_ammo_purchased);	
	incrementCounter( "global_zm_total_shots", total_shots);	
	incrementCounter( "global_zm_time_played", time_played);	
	incrementCounter( "global_zm_contaminations_received",contaminations_received);
	incrementCounter( "global_zm_contaminations_given",contaminations_given );	
	incrementCounter( "global_zm_cheat_players_too_friendly",cheat_too_friendly);
	incrementCounter( "global_zm_cheats_cheat_too_many_weapons",cheat_too_many_weapons);
	incrementCounter( "global_zm_cheats_out_of_playable",cheat_out_of_playable_area);
	incrementCounter( "global_zm_total_cheats",cheat_total);
}

function get_specific_stat( stat_category,stat_name )
{
	return ( self GetDStat( stat_category, stat_name, "StatValue" ) );
}

//track gibbing
function do_stats_for_gibs(zombie,limb_tags_array)
{
	if(isDefined(zombie) && isDefined(zombie.attacker) && isPlayer(zombie.attacker))
	{
		foreach(limb in limb_tags_array)
		{	
			stat_name = undefined;
			if(limb == level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM)
			{
				stat_name = "right_arm_gibs";
			}
			else if( limb == level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM)
			{
				stat_name = "left_arm_gibs";
			}
			else if(limb == level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG)
			{
				stat_name = "right_leg_gibs";
			}
			else if(limb == level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG)
			{
				stat_name = "left_leg_gibs";
			}
			else if(limb == level._ZOMBIE_GIB_PIECE_INDEX_HEAD)
			{
				stat_name = "head_gibs";
			}
			
			if(!isDefined(stat_name))
			{
				continue;
			}
			
			zombie.attacker increment_client_stat( stat_name, false );			
			zombie.attacker increment_client_stat( "gibs" );

		}
	}
}

function initializeMatchStats()
{
	if ( !level.onlineGame || !GameModeIsMode( 0 ) )
		return;

	self.pers["lastHighestScore"] =  self getDStat( "HighestStats", "highest_score" );

	currGameType = level.gametype;
	self GameHistoryStartMatch( getGameTypeEnumFromName( currGameType, false ) );
}

function adjustRecentStats()
{
/#
	if( GetDvarint( "scr_writeconfigstrings" ) == 1  || GetDvarint( "scr_hostmigrationtest" ) == 1 )
		return;
#/

	initializeMatchStats();
}

function uploadStatsSoon()
{
	self notify( "upload_stats_soon" );
	self endon( "upload_stats_soon" );
	self endon( "disconnect" );

	wait 1;
	UploadStats( self );
}

