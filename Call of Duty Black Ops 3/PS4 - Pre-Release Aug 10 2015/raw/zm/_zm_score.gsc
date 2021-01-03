#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_bgb_token;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_score;

function autoexec __init__sytem__() {     system::register("zm_score",&__init__,undefined,undefined);    }

function __init__()
{
	score_cf_register_info( "damage", 1, 7 );
	score_cf_register_info( "death_normal", 1, 3 );
	score_cf_register_info( "death_torso", 1, 3 );
	score_cf_register_info( "death_neck", 1, 3 );
	score_cf_register_info( "death_head", 1, 3 );
	score_cf_register_info( "death_melee", 1, 3 );

	// clientuimodels are registered client-side in raw/ui/uieditor/clientfieldmodels.lua
	clientfield::register( "clientuimodel", "hudItems.doublePointsActive", 1, 1, "int" );
	clientfield::register( "clientuimodel", "hudItems.showDpadUp", 1, 1, "int" );
	clientfield::register( "clientuimodel", "hudItems.showDpadDown", 1, 1, "int" );
	clientfield::register( "clientuimodel", "hudItems.showDpadLeft", 1, 1, "int" );
	clientfield::register( "clientuimodel", "hudItems.showDpadRight", 1, 1, "int" );
	
	callback::on_spawned( &player_on_spawned );
	
	level.score_total = 0; // holds the sum of all score received by any player during the session
}


function player_on_spawned()
{
	util::wait_network_frame(); // Hotjoin fix: Wait one network frame to make sure the clientfields have completed registration. 
	if ( IsDefined(self) )
	{
		self.ready_for_score_events = true; 
	}
}


	
function score_cf_register_info( name, version, max_count )
{
	// clientuimodels are registered client-side in raw/ui/uieditor/clientfieldmodels.lua
	for ( i = 0; i < 4; i++ )
	{
		clientfield::register( "clientuimodel", "PlayerList.client" + i + ".score_cf_" + name, version, GetMinBitCountForNum( max_count ), "counter" );
	}
}


function score_cf_increment_info( name )
{
	foreach ( player in level.players )
	{
		thread wait_score_cf_increment_info( player, "PlayerList.client" + self.entity_num + ".score_cf_" + name );
	}
}

function wait_score_cf_increment_info( player, cf )
{
	if ( IsDefined(player) && ( isdefined( player.ready_for_score_events ) && player.ready_for_score_events ) )
	{
		player clientfield::increment_uimodel( cf );
	}
}


//chris_p - added dogs to the scoring
function player_add_points( event, mod, hit_location ,is_dog, zombie_team, damage_weapon )
{
	if( level.intermission )
	{
		return;
	}

	if( !zm_utility::is_player_valid( self ) )
	{
		return;
	}

	player_points = 0;
	team_points = 0;
	multiplier = get_points_multiplier(self);

	switch( event )
	{
		//TODO Add support for registering level-specific score events
		//TEMP adding wasp and raps points for playtest
		case "death_wasp":
		case "death_raps":
		 	player_points	= mod;
 			break;
 			
		case "death":
			player_points	= get_zombie_death_player_points();
			team_points		= get_zombie_death_team_points();
			points = self player_add_points_kill_bonus( mod, hit_location, damage_weapon );
			if( level.zombie_vars[self.team]["zombie_powerup_insta_kill_on"] == 1 && mod == "MOD_UNKNOWN" )
			{
				points = points * 2;
			}

			// Give bonus points 
			player_points	= player_points + points;
			// Don't give points if there's no team points involved.
			if ( team_points > 0 )
			{
				team_points		= team_points + points;
			}

			if (mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" )
			{
				self zm_stats::increment_client_stat( "grenade_kills" );
				self zm_stats::increment_player_stat( "grenade_kills" );
			}

			break; 
	
		case "ballistic_knife_death":
			player_points = get_zombie_death_player_points() + level.zombie_vars["zombie_score_bonus_melee"];
			self score_cf_increment_info( "death_melee" );
			break; 
	
		case "damage_light":
			player_points = level.zombie_vars["zombie_score_damage_light"];
			self score_cf_increment_info( "damage" );
			break;
	
		case "damage":
			player_points = level.zombie_vars["zombie_score_damage_normal"];
			self score_cf_increment_info( "damage" );
			break; 
	
		case "damage_ads":
			player_points = Int( level.zombie_vars["zombie_score_damage_normal"] * 1.25 ); 
			self score_cf_increment_info( "damage" );
			break;

		case "rebuild_board":
		case "carpenter_powerup":
			player_points	= mod;
			break;

 		case "bonus_points_powerup":
 			player_points	= mod;
 			break;
 
		case "nuke_powerup":
			player_points	= mod;
			team_points		= mod;
			break;
	
		case "jetgun_fling":
		case "thundergun_fling":
		case "riotshield_fling":
			player_points = mod;
			break;
			
 		case "hacker_transfer":
 			player_points = mod;
 			break;

		case "reviver":
			player_points = mod;
			break;

		case "vulture":
			player_points = mod;
			break;
			
		case "build_wallbuy":
			player_points = mod;
			break;
			
		case "ww_webbed":
		 	player_points	= mod;
 			break;
 			
			
		default:
			assert( 0, "Unknown point event" ); 
			break; 
	}

	player_points = multiplier * zm_utility::round_up_score( player_points, 5 );
	team_points = multiplier * zm_utility::round_up_score( team_points, 5 );
	
	if ( isdefined( self.point_split_receiver ) && (event == "death" || event == "ballistic_knife_death") )
	{
		split_player_points = player_points - zm_utility::round_up_score( (player_points * self.point_split_keep_percent), 10 );
		self.point_split_receiver add_to_player_score( split_player_points );
		player_points = player_points - split_player_points;
	}

	// Is the player persistent ability "pistol_points" active?
	if( ( isdefined( level.pers_upgrade_pistol_points ) && level.pers_upgrade_pistol_points ) )
	{
		player_points = self zm_pers_upgrades_functions::pers_upgrade_pistol_points_set_score( player_points, event, mod, damage_weapon );
	}

	// Add the points
	self add_to_player_score( player_points );

	//stat tracking
	self.pers["score"] = self.score;
	
	//check for game module point functions ( for greifing, etc )
	if(isdefined(level._game_module_point_adjustment))
	{
		level [[level._game_module_point_adjustment]](self,zombie_team,player_points);
	}
	

//	self thread play_killstreak_vo();
}

function get_points_multiplier(player)
{
	multiplier = level.zombie_vars[player.team]["zombie_point_scalar"];

	if(isdefined(level.current_game_module) && level.current_game_module == 2 ) //race
	{
	
		if(isdefined(level._race_team_double_points) && level._race_team_double_points == player._race_team)
		{
			return multiplier;
		}
		else //non teammates only get normal score
		{
			return 1;
		}
	}
	

	return multiplier;
}

// Adjust points based on number of players (MikeA)
function get_zombie_death_player_points()
{
	players = GetPlayers();
	if( players.size == 1 )
	{
		points = level.zombie_vars["zombie_score_kill_1player"]; 
	}
	else if( players.size == 2 )
	{
		points = level.zombie_vars["zombie_score_kill_2player"]; 
	}
	else if( players.size == 3 )
	{
		points = level.zombie_vars["zombie_score_kill_3player"]; 
	}
	else
	{
		points = level.zombie_vars["zombie_score_kill_4player"]; 
	}
	return( points );
}


// Adjust team points based on number of players (MikeA)
function get_zombie_death_team_points()
{
	return( 0 );
}


function player_add_points_kill_bonus( mod, hit_location, weapon )
{
	if( mod == "MOD_MELEE" )
	{
		self score_cf_increment_info( "death_melee" );
		scoreevents::processScoreEvent( "melee_kill", self, undefined, weapon );
		return level.zombie_vars["zombie_score_bonus_melee"]; 
	}

	if ( "head" == hit_location || "helmet" == hit_location )
	{
		scoreevents::processScoreEvent( "headshot", self, undefined, weapon );
	}
	else
	{
		scoreevents::processScoreEvent( "kill", self, undefined, weapon );
	}

	if( mod == "MOD_BURNED" )
	{
		self score_cf_increment_info( "death_torso" );
		return level.zombie_vars["zombie_score_bonus_burn"];
	}

	score = 0; 

	if ( isdefined( hit_location ) )
    {
		switch ( hit_location )
		{
			case "head":
			case "helmet":
				self score_cf_increment_info( "death_head" );
				score = level.zombie_vars["zombie_score_bonus_head"]; 
				break; 
		
			case "neck":
				self score_cf_increment_info( "death_neck" );
				score = level.zombie_vars["zombie_score_bonus_neck"]; 
				break; 
		
			case "torso_upper":
			case "torso_lower":
				self score_cf_increment_info( "death_torso" );
				score = level.zombie_vars["zombie_score_bonus_torso"]; 
				break; 
			
			default:
				self score_cf_increment_info( "death_normal" );
				break;
		}
    }

	return score; 
}

function player_reduce_points( event, n_amount )
{
	if( level.intermission )
	{
		return;
	}

	points = 0; 

	switch( event )
	{
		case "take_all":
			points = self.score;
			break;
			
		case "take_half":
			points = int( self.score / 2 );
			break;
			
		case "take_specified":
			points = n_amount;
			break;
			
		case "no_revive_penalty":
			percent = level.zombie_vars["penalty_no_revive"];
			points = self.score * percent;
			break; 
	
		case "died":
			percent = level.zombie_vars["penalty_died"];
			points = self.score * percent;
			break; 

		case "downed":
			percent = level.zombie_vars["penalty_downed"];;
			self notify("I_am_down");
			points = self.score * percent;

			self.score_lost_when_downed = zm_utility::round_up_to_ten( int( points ) );
			break; 
	
		default:
			assert( 0, "Unknown point event" ); 
			break; 
	}

	points = self.score - zm_utility::round_up_to_ten( int( points ) );

	if( points < 0 )
	{
		points = 0;
	}

	self.score = points;
}


//
//	Add points to the player's score
//	self is a player
//
function add_to_player_score( points, b_add_to_total = true )
{
	if( !isdefined( points ) || level.intermission )
	{
		return;
	}

	// bgb can intercept the points; all the points will be added to score_total regardless
	n_points_to_add_to_currency = bgb::add_to_player_score_override( points );

	self.score += n_points_to_add_to_currency;
	self.pers["score"] = self.score;

	if( b_add_to_total )
	{
		self.score_total += points;
		level.score_total += points; // also add to all players' running total score
	}
	
	self IncrementPlayerStat("score", points );
}


//
//	Subtract points from the player's score
//	self is a player
//
function minus_to_player_score( points )
{
	if( !isdefined( points ) || level.intermission )
	{
		return;
	}
	
	self.score -= points; 
	self.pers["score"] = self.score;
	
	level notify( "spent_points", self, points );
	
	// roll bgb token drop chance
	self bgb_token::roll_for_drop();
}


//
//	Add points to the team pool
//	self is a player.  We need to derive the team from the player
//
function add_to_team_score( points )
{
	//MM (3/10/10)	Disable team points

// 	if( !isdefined( points ) || points == 0 || level.intermission )
// 	{
// 		return;
// 	}
// 
// 	// Find out which team pool to adjust
// 	team_pool = level.team_pool[ 0 ];
// 	if ( isdefined( self.team_num ) && self.team_num != 0 )
// 	{
// 		team_pool = level.team_pool[ self.team_num ];
// 	}
// 
// 	team_pool.score += points; 
// 	team_pool.score_total += points; 
// 
// 	// also set the score onscreen
// 	team_pool set_team_score_hud(); 
}


//
//	Subtract points from the team pool
//	self is a player.  We need to derive the team from the player
//
function minus_to_team_score( points )
{
/*
	if( !isdefined( points ) || level.intermission )
	{
		return;
	}

	team_pool = level.team_pool[ 0 ];
	if ( isdefined( self.team_num ) && self.team_num != 0 )
	{
		team_pool = level.team_pool[ self.team_num ];
	}

	team_pool.score -= points; 

	// also set the score onscreen
	team_pool set_team_score_hud(); 
*/
}


//
//
//
function player_died_penalty()
{
	// Penalize all of the other players
	players = GetPlayers( self.team );
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] != self && !players[i].is_zombie )
		{
			players[i] player_reduce_points( "no_revive_penalty" );
		}
	}
}


//
//
//
function player_downed_penalty()
{
/#	println( "ZM >> LAST STAND - player_downed_penalty ");	#/
	self player_reduce_points( "downed" );

		
}
