#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 

init()
{
//team_score_init();
}

//chris_p - added dogs to the scoring
player_add_points( event, mod, hit_location ,is_dog, zombie_team)
{
	if( level.intermission )
	{
		return;
	}

	if( !is_player_valid( self ) )
	{
		return;
	}

	player_points = 0;
	team_points = 0;
	multiplier = get_points_multiplier(self);

	switch( event )
	{
		case "death":
			player_points	= get_zombie_death_player_points();
			team_points		= get_zombie_death_team_points();
			points = player_add_points_kill_bonus( mod, hit_location );
			if( level.zombie_vars["zombie_powerup_insta_kill_on"] == 1 && mod == "MOD_UNKNOWN" )
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

			self.kills++;
			//stats tracking
			self maps\mp\zombies\_zm_stats::increment_client_stat( "kills" );

			if (mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" )
			{
				self maps\mp\zombies\_zm_stats::increment_client_stat( "grenade_kills" );
			}

			break; 
	
		case "ballistic_knife_death":
			player_points = get_zombie_death_player_points() + level.zombie_vars["zombie_score_bonus_melee"];

			self.kills++;
			//stats tracking
			self maps\mp\zombies\_zm_stats::increment_client_stat( "kills" );

			break; 
	
		case "damage_light":
			player_points = level.zombie_vars["zombie_score_damage_light"];
			break;
	
		case "damage":
			player_points = level.zombie_vars["zombie_score_damage_normal"];
			break; 
	
		case "damage_ads":
			player_points = Int( level.zombie_vars["zombie_score_damage_normal"] * 1.25 ); 
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

		default:
			assert( 0, "Unknown point event" ); 
			break; 
	}

	player_points = multiplier * round_up_score( player_points, 5 );
	team_points = multiplier * round_up_score( team_points, 5 );
	
	if ( isdefined( self.point_split_receiver ) && (event == "death" || event == "ballistic_knife_death") )
	{
		split_player_points = player_points - round_up_score( (player_points * self.point_split_keep_percent), 10 );
		self.point_split_receiver add_to_player_score( split_player_points );
		player_points = player_points - split_player_points;
	}

	// Add the points
	self add_to_player_score( player_points );

	//stat tracking
	self.pers["score"] = self.score;
	
	//check for game module point functions ( for greifing, etc )
	if(isDefined(level._game_module_point_adjustment))
	{
		level [[level._game_module_point_adjustment]](self,zombie_team,player_points);
	}
	

//	self thread play_killstreak_vo();
}

get_points_multiplier(player)
{
	multiplier = level.zombie_vars["zombie_point_scalar"];

	if( level.mutators["mutator_doubleMoney"] )
	{
		multiplier *= 2;
	}	
	
	if(isDefined(level.current_game_module) && level.current_game_module == 2 ) //race
	{
	
		if(isDefined(level._race_team_double_points) && level._race_team_double_points == player._race_team)
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
get_zombie_death_player_points()
{
	players = GET_PLAYERS();
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
get_zombie_death_team_points()
{
	players = GET_PLAYERS();
	if( players.size == 1 )
	{
		points = level.zombie_vars["zombie_score_kill_1p_team"]; 
	}
	else if( players.size == 2 )
	{
		points = level.zombie_vars["zombie_score_kill_2p_team"]; 
	}
	else if( players.size == 3 )
	{
		points = level.zombie_vars["zombie_score_kill_3p_team"]; 
	}
	else
	{
		points = level.zombie_vars["zombie_score_kill_4p_team"]; 
	}
	return( points );
}


//TUEY Old killstreak VO script---moved to utility
/*
play_killstreak_vo()
{
	index = maps\mp\zombies\_zm_weapons::get_player_index(self);
	self.killstreak = "vox_killstreak";
	
	if(!isdefined (level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	if (!isdefined (self.killstreak_points))
	{
		self.killstreak_points = 0;
	}
	self.killstreak_points = self.score_total;	
	if (!isdefined (self.killstreaks))
	{
		self.killstreaks = 1;
	}
	if (self.killstreak_points > 1500 * self.killstreaks )
	{
		wait (randomfloatrange(0.1, 0.3));
		if(level.player_is_speaking != 1)
		{
			level.player_is_speaking = 1;
			self PlaySoundWithNotify ("plr_" + index + "_" +self.killstreak, "sound_done");
			self waittill("sound_done");
			level.player_is_speaking = 0;
				
		}
		self.killstreaks ++;
	}
	

}
*/
player_add_points_kill_bonus( mod, hit_location )
{
	if( mod == "MOD_MELEE" )
	{
		return level.zombie_vars["zombie_score_bonus_melee"]; 
	}

	if( mod == "MOD_BURNED" )
	{
		return level.zombie_vars["zombie_score_bonus_burn"];
	}

	score = 0; 

	switch( hit_location )
	{
		case "head":
		case "helmet":
			score = level.zombie_vars["zombie_score_bonus_head"]; 
			break; 
	
		case "neck":
			score = level.zombie_vars["zombie_score_bonus_neck"]; 
			break; 
	
		case "torso_upper":
		case "torso_lower":
			score = level.zombie_vars["zombie_score_bonus_torso"]; 
			break; 
	}

	return score; 
}

player_reduce_points( event, mod, hit_location )
{
	if( level.intermission )
	{
		return;
	}

	points = 0; 

	switch( event )
	{
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

			self.score_lost_when_downed = round_up_to_ten( int( points ) );
			break; 
	
		default:
			assert( 0, "Unknown point event" ); 
			break; 
	}

	points = self.score - round_up_to_ten( int( points ) );

	if( points < 0 )
	{
		points = 0;
	}

	self.score = points;
	
	self set_player_score_hud(); 
}


//
//	Add points to the player's score
//	self is a player
//
add_to_player_score( points, add_to_total )
{
	if ( !IsDefined(add_to_total) )
	{
		add_to_total = true;
	}

	if( !IsDefined( points ) || level.intermission )
	{
		return;
	}

	self.score += points; 
	self.pers["score"] = self.score;

	if ( add_to_total )
	{
		self.score_total += points;
	}

	// also set the score onscreen
	self set_player_score_hud(); 
}


//
//	Subtract points from the player's score
//	self is a player
//
minus_to_player_score( points )
{
	if( !IsDefined( points ) || level.intermission )
	{
		return;
	}

	self.score -= points; 
	self.pers["score"] = self.score;

	// also set the score onscreen
	self set_player_score_hud(); 
}


//
//	Add points to the team pool
//	self is a player.  We need to derive the team from the player
//
add_to_team_score( points )
{
	//MM (3/10/10)	Disable team points

// 	if( !IsDefined( points ) || points == 0 || level.intermission )
// 	{
// 		return;
// 	}
// 
// 	// Find out which team pool to adjust
// 	team_pool = level.team_pool[ 0 ];
// 	if ( IsDefined( self.team_num ) && self.team_num != 0 )
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
minus_to_team_score( points )
{
/*
	if( !IsDefined( points ) || level.intermission )
	{
		return;
	}

	team_pool = level.team_pool[ 0 ];
	if ( IsDefined( self.team_num ) && self.team_num != 0 )
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
player_died_penalty()
{
	// Penalize all of the other players
	players = GET_PLAYERS();
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
player_downed_penalty()
{
/#	println( "ZM >> LAST STAND - player_downed_penalty ");	#/
	self player_reduce_points( "downed" );

		
}



//
// SCORING HUD --------------------------------------------------------------------- //
//

//
//	Sets the point values of a score hud
//	self will be the player getting the score adjusted
//
set_player_score_hud( init )
{

	if ( IsPlayer( self ) )
	{
		// local only splitscreen only displays each player's own score in their own viewport only
		if( !level.onlineGame && !SessionModeIsSystemlink() && IsSplitScreen() )
		{
			self thread score_highlight();
		}
		else
		{
			if( is_encounter() )
			{
				self thread score_highlight();
			}
			else
			{
				players = GET_PLAYERS();
				for ( i = 0; i < players.size; i++ )
				{				
					players[i] thread score_highlight(self);
				}
			}
		}
	}

	if( IsDefined( init ) && init )
	{
		return; 
	}

	self.old_score = self.score; 
}


//
//	Sets the point values of a score hud
//	self will be the team_pool
//
set_team_score_hud( init )
{
	//MM (3/10/10)	Disable team points
	self.score = 0;
	self.score_total = 0;

// 
// 	if ( !IsDefined(init) )
// 	{
// 		init = false;
// 	}
// 
// 	//		TEMP function call.  Might rename this function so it makes more sense
// 	self set_player_score_hud( false );
// 	self.hud SetValue( self.score );
}


// Creates a hudelem used for the points awarded/taken away
create_highlight_hud( x, y, value )
{
	font_size = 2; 
	if ( self IsSplitscreen() )
	{
		font_size = 3;
	}

	hud = create_simple_hud( self );

	level.hudelem_count++; 

	hud.foreground = true; 
	hud.sort = 0; 
	hud.x = x; 
	hud.y = y; 
	hud.fontScale = font_size; 
	hud.alignX = "right"; 
	hud.alignY = "middle"; 
	hud.horzAlign = "user_right";
	hud.vertAlign = "user_bottom";

	if( value < 1 )
	{
		//		hud.color = ( 0.8, 0, 0 ); 
		hud.color = ( 0.21, 0, 0 );
	}
	else
	{
		hud.color = ( 0.9, 0.9, 0.0 );
		hud.label = &"SCRIPT_PLUS";
	}

	//	hud.glowColor = ( 0.3, 0.6, 0.3 );
	//	hud.glowAlpha = 1; 
	hud.hidewheninmenu = false; 

	hud SetValue( value ); 

	return hud; 	
}


//
// Handles the creation/movement/deletion of the moving hud elems
//
score_highlight(scoring_player )
{
	self endon( "disconnect" ); 	
	
	if(!isDefined(scoring_player))
	{
		scoring_player = self;
	}
	
	// Location from hud.menu
	score_x = -103;
	score_y = -100;

	if ( self IsSplitscreen() )
	{
		score_y = -95;
	}

	x = score_x;

	// local only splitscreen only displays each player's own score in their own viewport only
	if( !level.onlineGame && !SessionModeIsSystemlink() && IsSplitScreen() )
	{
		y = score_y;
	}
	else
	{
		players = GET_PLAYERS();
		num = 0;		
		for ( i = 0; i < players.size; i++ )
		{
			if ( scoring_player == players[i] )
			{
				num = players.size - i - 1;
			}
		}
		y = ( num * -20 ) + score_y;
	}

	if ( self IsSplitscreen() )
	{
		y *= 2;
	}

	time = 0.5; 
	half_time = time * 0.5; 

	hud = self create_highlight_hud( x, y,  (scoring_player.score - scoring_player.old_score) ); 

	// Move the hud
	hud MoveOverTime( time ); 
	hud.x -= 20 + RandomInt( 40 ); 
	hud.y -= ( -15 + RandomInt( 30 ) ); 

	wait( half_time ); 

	// Fade half-way through the move
	hud FadeOverTime( half_time ); 
	hud.alpha = 0; 

	wait( half_time ); 

	hud Destroy(); 
	level.hudelem_count--; 
}


//
//	Initialize the team point counter
//
team_score_init()
{
	//	NOTE: Make sure all players have connected before doing this.
/*
	flag_wait( "start_zombie_round_logic" );

	level.team_pool = [];

	// No Pools in a 1 player game
	players = GET_PLAYERS();
	if ( players.size == 1 )
	{
		// just create a stub team pool...
		level.team_pool[0] = SpawnStruct();
		pool				= level.team_pool[0];
		pool.team_num		= 0;
		pool.score			= 0;
		pool.old_score		= pool.score;
		pool.score_total	= pool.score;
		return;
	}

	if ( IsDefined( level.zombiemode_versus ) && level.zombiemode_versus )
	{
		num_pools = 2;
	}
	else
	{
		num_pools = 1;
	}

	for (i=0; i<num_pools; i++ )
	{
		level.team_pool[i] = SpawnStruct();
		pool				= level.team_pool[i];
		pool.team_num		= i;
		pool.score			= 0;
		pool.old_score		= pool.score;
		pool.score_total	= pool.score;

		// Based on the Location of the player score from hud.menu
		pool.hud_x			= -103 + 5;	// 2nd # is an offset from the menu position to get it to line up
		pool.hud_y			= -71 - 36;	// 2nd # is spacing away from the player score

		if( !IsSplitScreen() )
		{
			players = GET_PLAYERS();
			num = players.size - 1;
			pool.hud_y += (num+(num_pools-1 - i)) * -18;	// last number is a spacing gap from the player scores 
		}

		//MM (3/10/10)	Disable team points
//		pool.hud = create_team_hud( pool.score, pool );
	}
*/
}


//
//	Initialize the team score hud
//
create_team_hud( value, team_pool )
{
	assert( IsDefined( team_pool ), "create_team_hud:  You must specify a team_pool when calling this function" );
	font_size = 8.0; 

	hud				= create_simple_hud();
	hud.foreground	= true; 
	hud.sort		= 10; 
	hud.x			= team_pool.hud_x; 
	hud.y			= team_pool.hud_y; 
	hud.fontScale = font_size; 
	hud.alignX		= "left"; 
	hud.alignY		= "middle"; 
	hud.horzAlign	= "user_right";
	hud.vertAlign	= "user_bottom";
	hud.color		= ( 0.9, 0.9, 0.0 );
	hud.hidewheninmenu = false; 

	hud SetValue( value ); 

	// Set score icon
	bg_hud				= create_simple_hud();
	bg_hud.alignX		= "right"; 
	bg_hud.alignY		= "middle"; 
	bg_hud.horzAlign	= "user_right";
	bg_hud.vertAlign	= "user_bottom";
	bg_hud.color		= ( 1, 1, 1 );
	bg_hud.sort			= 8; 
	bg_hud.x			= team_pool.hud_x - 8; 
	bg_hud.y			= team_pool.hud_y; 
	bg_hud.alpha		= 1;
	bg_hud SetShader( "zom_icon_community_pot", 32, 32 );

	// Set score highlight
	bg_hud				= create_simple_hud();
	bg_hud.alignX		= "left"; 
	bg_hud.alignY		= "middle"; 
	bg_hud.horzAlign	= "user_right";
	bg_hud.vertAlign	= "user_bottom";
	bg_hud.color		= ( 0.0, 0.0, 0 );
	bg_hud.sort			= 8; 
	bg_hud.x			= team_pool.hud_x - 24; 
	bg_hud.y			= team_pool.hud_y; 
	bg_hud.alpha		= 1;
	bg_hud SetShader( "zom_icon_community_pot_strip", 128, 16 );

	return hud; 	
}
