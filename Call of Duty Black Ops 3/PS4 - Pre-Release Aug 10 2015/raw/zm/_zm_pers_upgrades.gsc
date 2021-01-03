#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

       

#namespace zm_pers_upgrades;

//
// NOTES:
//
// Creating:-
//  - Initialize each stat in zm_stats::player_stats_init()
//  - Add the stat in zm_pers_upgrades::pers_upgrade_init()
//
// Additional:-
// - Abilities and the stat tracking are carried accross over multiple games
// - Upgrades can be marked to be reset at the games end (if not achieved) when resistered
//



//*****************************************************************************
// Register pers_upgrades
//*****************************************************************************

// self = level
function pers_upgrade_init()
{
	//****************************************************
	// Setup the persistent upgrades
	// - NOTE: Each level needs to turn on the level. flag
	//****************************************************

	setup_pers_upgrade_boards();					// Complete
	setup_pers_upgrade_revive();					// Complete
	setup_pers_upgrade_multi_kill_headshots();		// Complete
	setup_pers_upgrade_cash_back();					// Complete
	setup_pers_upgrade_insta_kill();				// Complete
	setup_pers_upgrade_jugg();						// Complete
	setup_pers_upgrade_carpenter();					// Complete
	

	//*************************
	// DLC3 persistent upgrades
	//*************************

	setup_pers_upgrade_perk_lose();					// Complete
	setup_pers_upgrade_pistol_points();				// Complete
	setup_pers_upgrade_double_points();				// Complete
	setup_pers_upgrade_sniper();					// Complete
	setup_pers_upgrade_box_weapon();				// Complete
	setup_pers_upgrade_nube();						// Complete
		

	//****************************
	//****************************
	
	level thread zm_pers_upgrades_system::pers_upgrades_monitor();
}


//***************************************************************************************
//***************************************************************************************
// Global initializations for each player
//***************************************************************************************
//***************************************************************************************

// self = player
function pers_abilities_init_globals()
{
	self.successful_revives = 0;
	self.failed_revives = 0;
	self.failed_cash_back_prones = 0;

	// For tracking persistent headshot upgrade
	self.pers["last_headshot_kill_time"] = gettime();
	self.pers["zombies_multikilled"] = 0;
	self.non_headshot_kill_counter = 0;

	if( ( isdefined( level.pers_upgrade_box_weapon ) && level.pers_upgrade_box_weapon ) )
	{
		self.pers_box_weapon_awarded = undefined;
	}

	if( ( isdefined( level.pers_upgrade_nube ) && level.pers_upgrade_nube ) )
	{
		self thread zm_pers_upgrades_functions::pers_nube_unlock_watcher();
	}
}


//***************************************************************************************
// Is the persistent ability system active?
//***************************************************************************************

function is_pers_system_active()
{
	if( !zm_utility::is_Classic() )
	{
		return( 0 );
	}

	if( is_pers_system_disabled() )
	{
		return( 0 );
	}
	
	return( 0 );
}


//***************************************************************************************
// Is the persistent ability system disabled?
//***************************************************************************************

function is_pers_system_disabled()
{
	return( 0 );
}



//***************************************************************************************
//*** BOARDS ***
//**************
//
// AWARDED RULES:-
// - Reach a target round
// - Board X amount after the target round
//	
// REWARD:-
// - Boards are reinforced when repaired by the upgraded player
//
// LOSE RULES:-
// - If you fail to board in a round when you have the ability, you will lose the ability
//***************************************************************************************

function setup_pers_upgrade_boards()
{
	if( ( isdefined( level.pers_upgrade_boards ) && level.pers_upgrade_boards ) )
	{
		level.pers_boarding_round_start = 10;						// (10) Starts to track at this round number
		level.pers_boarding_number_of_boards_required = 74;			// (74) Number of boards required to activate this upgrade
		zm_pers_upgrades_system::pers_register_upgrade( "board", &pers_upgrade_boards_active, "pers_boarding", level.pers_boarding_number_of_boards_required, false );
	}
}


//*****************************************************************************
// *** REVIVE ***
//***************
//
// AWARDED RULES:-
// - Revive X players in a single game
//
// REWARD:-
// - Player revive speed is quicker
//
// LOSE RULES:-
//  - If the player ever fails a revive attempt, they lose the upgrade
//*****************************************************************************

function setup_pers_upgrade_revive()
{
	if( ( isdefined( level.pers_upgrade_revive ) && level.pers_upgrade_revive ) )
	{
		level.pers_revivenoperk_number_of_revives_required = 17;	// (17) We need to revive this many in a single game
		level.pers_revivenoperk_number_of_chances_to_keep = 1;		// (1) Once we have it this is how many chances we have to keep it
		zm_pers_upgrades_system::pers_register_upgrade( "revive", &pers_upgrade_revive_active, "pers_revivenoperk", level.pers_revivenoperk_number_of_revives_required, true );
	}
}


//*****************************************************************************
// *** MULTI-KILL HEADSHOTS ***
//*****************************
//
// AWARDED RULES:-
// - Get X amount of multi-kill head shots in a single game
//
// REWARD:-
//
// LOSE RULES:-
// - After X number of non-headshot kills, you will lose the ability
//*****************************************************************************

function setup_pers_upgrade_multi_kill_headshots()
{
	if( ( isdefined( level.pers_upgrade_multi_kill_headshots ) && level.pers_upgrade_multi_kill_headshots ) )
	{
		level.pers_multikill_headshots_required = 5;				// (5) If we get this many multi-kill headshots in one game we will get the upgrade (two heads with 1 bullet)
		level.pers_multikill_headshots_upgrade_reset_counter = 25;	// (25) Once we have it, this many kills that ARENT headshots will lose the upgrade
		zm_pers_upgrades_system::pers_register_upgrade( "multikill_headshots", &pers_upgrade_headshot_active, "pers_multikill_headshots", level.pers_multikill_headshots_required, false );
	}
}


//*****************************************************************************
// *** CASH BACK ***
//******************
//
// AWARDED RULES:-
// - Buy 50 perks total lifetime (stat 1 - "pers_cash_back_bought")
// - Once you've bought 50 perks, go prone within 2 seconds of end of perk drink animation 15 times (stat 2 - "pers_cash_back_prone")
//
// REWARD:-
// - All perk buys, 1000 points awarded to the player
//
// LOSE RULES:-
// Don't prone 1 times after a perk buy
// - Reset 50 buys counter when lost
//*****************************************************************************

function setup_pers_upgrade_cash_back()
{
	if( ( isdefined( level.pers_upgrade_cash_back ) && level.pers_upgrade_cash_back ) )
	{
		level.pers_cash_back_num_perks_required = 50;				// (50) First unlock is 50 perk buys
		level.pers_cash_back_perk_buys_prone_required = 15;			// (15) Once you've bought 50 perks, go prone within 2 seconds of end of perk drink animation 15 times
		level.pers_cash_back_failed_prones = 1;						// (1) Once we have it, this many times the player doesn't prone after a perk buy will lose the ability
		level.pers_cash_back_money_reward = 1000;

		// Creates the "cash_back" structure
		zm_pers_upgrades_system::pers_register_upgrade( "cash_back", &pers_upgrade_cash_back_active, "pers_cash_back_bought", level.pers_cash_back_num_perks_required, false );

		// Adds to the "cash_back" stat array (2nd stat element)
		zm_pers_upgrades_system::add_pers_upgrade_stat( "cash_back", "pers_cash_back_prone", level.pers_cash_back_perk_buys_prone_required );
	}
}


//*****************************************************************************
// *** INSTA KILL ***
//*******************
//
// AWARDED RULES:-
// - Player picks up Insta kill twice and doesn't kill any one.
//
// REWARD:-
// - Zombies die on contact with the player for 1st half of insta kill time.
// - NOTE: Need a visual aid to players this is happening EX: put a second insta kill icon above original on screen, that is red and blinks out in half the time.
// - NOTE: When player stab kills a zombie the zombie explodes
//
// LOSE RULES:-
// - Get hit by a zombie when insta kill active
//*****************************************************************************

function setup_pers_upgrade_insta_kill()
{
	if( ( isdefined( level.pers_upgrade_insta_kill ) && level.pers_upgrade_insta_kill ) )
	{
		level.pers_insta_kill_num_required = 2;						// (2) Unlock is pickup 2 insta kills and don't kill anyone
		level.pers_insta_kill_upgrade_active_time = 18;				// (18) The insta kill reward lasts this amount of time each time a player picks up insta kill and has the upgrade

		// Create structure
		zm_pers_upgrades_system::pers_register_upgrade( "insta_kill", &pers_upgrade_insta_kill_active, "pers_insta_kill", level.pers_insta_kill_num_required, false );
	}
}


//*****************************************************************************
// *** JUGG ***
//*************
//
// AWARDED RULES:-
// - Hit and Die 25 times prior to round 3
//
// REWARD:-
// - Strength increases, if you have jugg or not
//
// LOSE RULES:-
// - Get to round 15, 3 times
//*****************************************************************************

function setup_pers_upgrade_jugg()
{
	if( ( isdefined( level.pers_upgrade_jugg ) && level.pers_upgrade_jugg ) )
	{
		level.pers_jugg_hit_and_die_total = 3;						// (3) Hit and die this amount of times
		level.pers_jugg_hit_and_die_round_limit = 2;				// (2) Hit and die only updates the stat if the round is <= this value
		level.pers_jugg_round_reached_max = 1;						// (1) If you reach the target round this amount of times, you lose the upgrade
		level.pers_jugg_round_lose_target = 15;						// (15) If the player reaches this round X times, they lose the upgrade
		level.pers_jugg_upgrade_health_bonus = 90;					// Bonus amount of health if you get the jugg upgrade
	
		// Create structure
		zm_pers_upgrades_system::pers_register_upgrade( "jugg", &pers_upgrade_jugg_active, "pers_jugg", level.pers_jugg_hit_and_die_total, false );
	}
}


//*****************************************************************************
// *** CARPENTER ***
//******************
//
// AWARDED RULES:-
// - Kill a zombie behind a window while carpenter is active
// - Boards become upgraded boards
//
// REWARD:-
// - If player has the upgrade and picks up carpenter, the boards are built upgraded during carpenter
//
// LOSE RULES:-
// - If player picks up the carpenter but fails to kill a zombie behind a window while carpenter is active
//*****************************************************************************

function setup_pers_upgrade_carpenter()
{
	if( ( isdefined( level.pers_upgrade_carpenter ) && level.pers_upgrade_carpenter ) )
	{
		level.pers_carpenter_zombie_kills = 1;					// (1) Kill this many zombies behind a window while the carpenter is active

		// Create structure
		zm_pers_upgrades_system::pers_register_upgrade( "carpenter", &pers_upgrade_carpenter_active, "pers_carpenter", level.pers_carpenter_zombie_kills, false );
	}
}


//*****************************************************************************
// *** PERK LOSE ***
//******************
//
// AWARDED RULES:-
// - Buy 4 perks before round 7, three times
//
// REWARD:-
// - If a player is revived they only lose the last perk they bought
//
// LOSE RULES:-
// - If the player buys a perk in the same round they lost it in, they lose the ability
//*****************************************************************************

function setup_pers_upgrade_perk_lose()
{
	if( ( isdefined( level.pers_upgrade_perk_lose ) && level.pers_upgrade_perk_lose ) )
	{
		level.pers_perk_round_reached_max = 6;				// (6) After this round the perks bought are not counted
		level.pers_perk_lose_counter = 3;					// (3) Buy all (four) perks this amount of times before round X to unlock
		
		// Create structure
		zm_pers_upgrades_system::pers_register_upgrade( "perk_lose", &pers_upgrade_perk_lose_active, "pers_perk_lose_counter", level.pers_perk_lose_counter, false );
	}
}


//*****************************************************************************
// *** PISTOL POINTS ***
//**********************
//
// AWARDED RULES:-
// - Kill 8 number of zombies in a game
// - Accuracy must be below 25% after reaching the num kills, to activate the upgrade
//
// REWARD:-
// - Player gets double points for every shot with the pistol
//
// LOSE RULES:-
// - Lose it when players accuracy gets above 25%
//*****************************************************************************

function setup_pers_upgrade_pistol_points()
{
	if( ( isdefined( level.pers_upgrade_pistol_points ) && level.pers_upgrade_pistol_points ) )
	{
		level.pers_pistol_points_num_kills_in_game = 8;		// (8) After this number of kills in a game
		level.pers_pistol_points_accuracy = 0.25;			// (0.25) If your accuracy is below this after X kills
		level.pers_pistol_points_counter = 1;				// Set to 1 to activate the upgrade
		
		// Create structure
		zm_pers_upgrades_system::pers_register_upgrade( "pistol_points", &pers_upgrade_pistol_points_active, "pers_pistol_points_counter", level.pers_pistol_points_counter, false );
	}
}


//*****************************************************************************
// *** DOUBLE POINTS ***
//**********************
//
// AWARDED RULES:-
// - Accumulate 2500 points or more when the double points powerup is active
// - Only works for the player who picked up the powerup
//
// REWARD:-
// - Purchases are 1/2 price when the X2 points powerup is active
//		(weapons, perks, box, wall buys) - For now all score reductions are halved ( minus_to_players_score() )!
//
// LOSE RULES:-
// - Don't collect any points when the X2 points powerup is active
//		Its ok for the player to lose points, but they can't gain any points
//*****************************************************************************

function setup_pers_upgrade_double_points()
{
	if( ( isdefined( level.pers_upgrade_double_points ) && level.pers_upgrade_double_points ) )
	{
		level.pers_double_points_score = 2500;				// (2500) Get this amount of points when X2 powerup is active
		level.pers_double_points_counter = 1;				// Set to 1 to activate the upgrade

		// Create structure
		zm_pers_upgrades_system::pers_register_upgrade( "double_points", &pers_upgrade_double_points_active, "pers_double_points_counter", level.pers_double_points_counter, false );
	}
}


//*****************************************************************************
// *** SNIPER ***
//***************
//
// AWARDED RULES:-
// - 5 Kills (any type of kill, head chest etc…) at more than 500 units distance in a single round with a SNIPER weapon
//
// REWARD:-
// - Player gets 300 points per kill with sniper rifle (any type of kill, head chest etc…)
//
// LOSE RULES:-
// - Miss 3 shots in a row
//*****************************************************************************

function setup_pers_upgrade_sniper()
{
	if( ( isdefined( level.pers_upgrade_sniper ) && level.pers_upgrade_sniper ) )
	{
		level.pers_sniper_round_kills_counter = 5;				// (5) Num kills in a round
		level.pers_sniper_kill_distance = 800;					// (500) Distance a sniper kill registers at
		level.pers_sniper_counter = 1;							// (1) Set to 1 to activate the upgrade
		level.pers_sniper_misses = 3;

		// Create structure
		zm_pers_upgrades_system::pers_register_upgrade( "sniper", &pers_upgrade_sniper_active, "pers_sniper_counter", level.pers_sniper_counter, false );
	}
}


//*****************************************************************************
// *** BOX WEAPON ***
//*******************
//
// AWARDED RULES:-
// - Use the box and take the weapon 5 times consecutively, if you skip the weapon the counter resets
// - Can't get the upgrade more than once in the same game
// - Can't get after round 9
//
// REWARD:-
// - Box gives better weapons, increase the percentage chance of box giving a better weapon
//
// LOSE RULES:-
// - Get to round 10 and you lose the upgrade
//*****************************************************************************

function setup_pers_upgrade_box_weapon()
{
	if( ( isdefined( level.pers_upgrade_box_weapon ) && level.pers_upgrade_box_weapon ) )
	{
		level.pers_box_weapon_counter = 5;							// (5) Set to 5 to activate the upgrade
		level.pers_box_weapon_lose_round = 10;						// (10) Lose the upgrade when the player gets to this round

		// Create structure
		zm_pers_upgrades_system::pers_register_upgrade( "box_weapon", &pers_upgrade_box_weapon_active, "pers_box_weapon_counter", level.pers_box_weapon_counter, false );
	}
}


//*****************************************************************************
// *** NUBE ***
//*************
//
// AWARDED RULES:-
// - Player needs to get 5 or more kills consecutively with:-
//   -> No melee kills
//   -> No headshot kills
//   -> No boarding
// - Once these conditions are met, the next time they buy the bad weapon (the olympia) or ammo they get the upgrade
//
// REWARD:-
// - When a bad weapon (the olympia) is purchased in the 1st round, the player recieves the ray gun
//
// LOSE RULES:-
// - Once the player gets to round 10, they won't be able to unlock the ability again
//*****************************************************************************

function setup_pers_upgrade_nube()
{
	if( ( isdefined( level.pers_upgrade_nube ) && level.pers_upgrade_nube ) )
	{
		level.pers_nube_counter = 1;								// (1) Buy the olympia once if the rules are met to unlock the ability
		level.pers_nube_lose_round = 10;							// (10) Lose the upgrade when the player gets to this round
		level.pers_numb_num_kills_unlock = 5;						// (5) Number of kills the player needs to get consecutively as a NUBE!

		// Create structure
		zm_pers_upgrades_system::pers_register_upgrade( "nube", &pers_upgrade_nube_active, "pers_nube_counter", level.pers_nube_counter, false );
	}
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
// Persistent Upgrade: Monitor functions
//  - Fire off when the player has the upgrade and tracks for resets
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************



//*****************************************************************************
// *** BOARDS - Upgraded ***
//
// If the player does not build any boards in round, they lose the stat
//*****************************************************************************

function pers_upgrade_boards_active()
{
	self endon( "disconnect" );
	
	last_round_number = level.round_number;

	while( 1 )
	{
		self waittill( "pers_stats_end_of_round" );

		// If the round number is smaller, we must have gone back in time using the time bomb or equivalent
		//  - so only check if the level.round_number has advanced
		if( level.round_number >= last_round_number )
		{
			if( zm_pers_upgrades::is_pers_system_active() )
			{
				if( self.rebuild_barrier_reward == 0 )
				{
					self zm_stats::zero_client_stat( "pers_boarding", false );	
					return;
				}
			}
		}

		last_round_number = level.round_number;
	}
}


//*****************************************************************************
// *** REVIVE - Upgraded ***
//
// If the player ever fails a revive attempt, they lose the upgrade
//*****************************************************************************

function pers_upgrade_revive_active()
{
	self endon( "disconnect" );
	
	while( 1 )
	{
		self waittill( "player_failed_revive" );

		if( zm_pers_upgrades::is_pers_system_active() )
		{
			if( self.failed_revives >= level.pers_revivenoperk_number_of_chances_to_keep )
			{
				// Player lost the revive upgrade
				self zm_stats::zero_client_stat( "pers_revivenoperk", false );	
				self.failed_revives = 0;
				return;
			}
		}
	}
}


//*****************************************************************************
// *** HEADSHOT - Upgraded ***
//
//*****************************************************************************

function pers_upgrade_headshot_active()
{
	self endon( "disconnect" );

	while( 1 )
	{
		self waittill( "zombie_death_no_headshot" );

		if( zm_pers_upgrades::is_pers_system_active() )
		{
			self.non_headshot_kill_counter++;
			if( self.non_headshot_kill_counter >= level.pers_multikill_headshots_upgrade_reset_counter )
			{
				// Lost the upgrade
				self zm_stats::zero_client_stat( "pers_multikill_headshots", false );	
				self.non_headshot_kill_counter = 0;
				return;
			}
		}
	}
}


//*****************************************************************************
// *** CASH BACK - Upgraded ***
//
//*****************************************************************************

function pers_upgrade_cash_back_active()
{
	self endon( "disconnect" );

	wait( 0.5 );
	/#
		//iprintlnbold( "*** WE GOT CASH BACK ***" );
	#/
	wait( 0.5 );

	while( 1 )
	{
		self waittill( "cash_back_failed_prone" );
			
		wait( 0.1 );

		/#
			//iprintlnbold( "PRONE - FAILED!" );
		#/
		
		if( zm_pers_upgrades::is_pers_system_active() )
		{
			self.failed_cash_back_prones++;
			if( self.failed_cash_back_prones >= level.pers_cash_back_failed_prones )
			{
				// Lost the upgrade
				self zm_stats::zero_client_stat( "pers_cash_back_bought", false );
				self zm_stats::zero_client_stat( "pers_cash_back_prone", false );
				self.failed_cash_back_prones = 0;

				wait( 0.4 );
				/#
					//iprintlnbold( "*** OH NO: LOST CASH BACK ***" );
				#/

				return;
			}
		}
	}
}


//*****************************************************************************
// *** INSTA KILL - Upgraded ***
//
//*****************************************************************************

function pers_upgrade_insta_kill_active()
{
	self endon( "disconnect" );

	wait( 0.2 );
	/#
		//iprintlnbold( "*** WE GOT INSTA KILL UPGRADE ***" );
	#/
	wait( 0.2 );

	// Wait until the player is swiped while Insta Kill is active
	while( 1 )
	{
		self waittill( "pers_melee_swipe" );

		if( zm_pers_upgrades::is_pers_system_active() )
		{
			// Kill the zombie that swiped if he's still alive
			if( IsDefined(level.pers_melee_swipe_zombie_swiper) )
			{
				e_zombie = level.pers_melee_swipe_zombie_swiper;
				if( IsAlive(e_zombie) && ( isdefined( e_zombie.is_zombie ) && e_zombie.is_zombie ) )
				{
					e_zombie.marked_for_insta_upgraded_death = true;
					e_zombie dodamage( e_zombie.health + 666, e_zombie.origin, self, self, "none", "MOD_PISTOL_BULLET", 0 );
				}
				level.pers_melee_swipe_zombie_swiper = undefined;
			}

			break;
		}
	}

	// Lost the upgrade
	self zm_stats::zero_client_stat( "pers_insta_kill", false );

	// Force terminate the Insta Kill Icon
	self kill_insta_kill_upgrade_hud_icon();

	wait( 0.4 );
	/#
		//iprintlnbold( "*** OH NO: Lost INSTA KILL Upgrade***" );
	#/
}


//*****************************************************************************
//*****************************************************************************
// self = player
function is_insta_kill_upgraded_and_active()
{
	// Only in classic mode
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		// Is the Insta Kill Powerup active?
		if( self zm_powerups::is_insta_kill_active() )
		{
			// Has the Insta Kill upgrade been awarded?
			if( ( isdefined( self.pers_upgrades_awarded["insta_kill"] ) && self.pers_upgrades_awarded["insta_kill"] ) )
			{
				return( 1 );
			}
		}
	}
	return( 0 );
}


//*****************************************************************************
// *** JUGG - Upgraded ***
//
//*****************************************************************************

function pers_upgrade_jugg_active()
{
	self endon( "disconnect" );

	wait( 0.5 );
	/#
		//iprintlnbold( "*** WE'VE GOT JUGG UPGRADED ***" );
	#/
	wait( 0.5 );

	// Upgrade the players health
	self zm_perks::perk_set_max_health_if_jugg( "jugg_upgrade", true, false );

	// Wait for the player to reach round 15
	// If we reach round 15, 3 times, you lose the upgrade
	while( 1 )
	{
		level waittill( "start_of_round" );

		if( zm_pers_upgrades::is_pers_system_active() )
		{
			if( level.round_number == level.pers_jugg_round_lose_target )
			{
				/#
					//iprintlnbold( "*** JUGG Round 15 - Downgrade Increment ***" );
				#/
				self zm_stats::increment_client_stat( "pers_jugg_downgrade_count", false );
				wait( 0.5 );

				if( self.pers["pers_jugg_downgrade_count"] >= level.pers_jugg_round_reached_max )
				{
					break;
				}
			}
		}
	}

	// Reset the players health
	self zm_perks::perk_set_max_health_if_jugg( "jugg_upgrade", true, true );

	/#
		//iprintlnbold( "*** OH NO: Lost JUGG Upgrade ***" );
	#/

	// Lost the upgrade
	self zm_stats::zero_client_stat( "pers_jugg", false );
	self zm_stats::zero_client_stat( "pers_jugg_downgrade_count", false );
}


//*****************************************************************************
// *** CARPENTER - Upgraded ***
//
//*****************************************************************************

function pers_upgrade_carpenter_active()
{
	self endon( "disconnect" );

	wait( 0.2 );
	/#
		//iprintlnbold( "*** WE GOT CARPENTER UPGRADE ***" );
	#/
	wait( 0.2 );

	// We can't lose the carpenter upgrade until the carpenter that triggered it has finished
	level waittill( "carpenter_finished" );

	self.pers_carpenter_kill = undefined;

	// If the player doesn't kill a zombie behind a window while the carpenter is active, we lose the upgrade ability
	while( 1 )
	{
		self waittill( "carpenter_zombie_killed_check_finished" );

		if( zm_pers_upgrades::is_pers_system_active() )
		{
			if( !IsDefined(self.pers_carpenter_kill) )
			{
				break;
			}

			/#
				//iprintlnbold( "*** CARPENTER Upgrade Retained ***" );
			#/
		}

		self.pers_carpenter_kill = undefined;
	}

	// Lost the upgrade
	self zm_stats::zero_client_stat( "pers_carpenter", false );

	wait( 0.4 );
	/#
		//iprintlnbold( "*** OH NO: Lost CARPENTER Upgrade***" );
	#/
}


//*****************************************************************************
// Called on a Player that picks up a Carpenter
// - Waits for the player to kill a zombie behind a window while the carpenter 
//   is active
//*****************************************************************************

// self = player
function persistent_carpenter_ability_check()
{
	if( ( isdefined( level.pers_upgrade_carpenter ) && level.pers_upgrade_carpenter ) )
	{
		self endon( "disconnect" );

		/#
			//iprintlnbold( "Checking Carpenter Windows" );
		#/

		// Does the player have the upgraded carpenter skills?
		if( ( isdefined( self.pers_upgrades_awarded["carpenter"] ) && self.pers_upgrades_awarded["carpenter"] ) )
		{
			level.pers_carpenter_boards_active = true;
		}

		self.pers_carpenter_zombie_check_active = true;
		self.pers_carpenter_kill = undefined;

		carpenter_extra_time = 3.0;
		carpenter_finished_start_time = undefined;

		level.carpenter_finished_start_time = undefined;

		while( 1 )
		{
			if( !is_pers_system_disabled() )
			{
				// Stop checking once the carpenter has timed out (with a bit of extra time)
				if( !IsDefined(level.carpenter_powerup_active) )
				{
					if( !IsDefined(level.carpenter_finished_start_time) )
					{
						level.carpenter_finished_start_time = gettime();
					}

					time = gettime();
					dt = ( time - level.carpenter_finished_start_time ) / 1000;
					if( dt >= carpenter_extra_time )
						{
						break;
					}
				}

				// Has the player killed a zombie behind a spawn window?
				if( IsDefined(self.pers_carpenter_kill) )
				{
					// If the carpenter persistent upgrade is active, we can stop checking
					if( ( isdefined( self.pers_upgrades_awarded["carpenter"] ) && self.pers_upgrades_awarded["carpenter"] ) )
					{
						break;
					}
	
					// The upgrade isn't active:-
					// - The player has attempted to board, so inc the stat
					else
					{
						self zm_stats::increment_client_stat( "pers_carpenter", false );
					}
				}
			}

			wait( 0.01 );
		}

		self notify( "carpenter_zombie_killed_check_finished" );

		self.pers_carpenter_zombie_check_active = undefined;

		level.pers_carpenter_boards_active = undefined;
	}
}


//*****************************************************************************
//*****************************************************************************

// self = level
function pers_zombie_death_location_check( attacker, v_pos )
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		// If the attacker is a player
		if( zm_utility::is_player_valid(attacker) )
		{
			if( IsDefined(attacker.pers_carpenter_zombie_check_active) )
			{
				if( !zm_utility::check_point_in_playable_area(v_pos) )
				{
					attacker.pers_carpenter_kill = true;
				}
			}
		}
	}
}


//*****************************************************************************
//*****************************************************************************

//self == player
function insta_kill_pers_upgrade_icon()
{
	//following insta_kill_on_hud() in _zm_powerups.gsc
	//check to see if this is on or not
	if( self.zombie_vars["zombie_powerup_insta_kill_ug_on"] )
	{
		//reset the time and keep going
		self.zombie_vars["zombie_powerup_insta_kill_ug_time"] = level.pers_insta_kill_upgrade_active_time;
		return;
	}

	self.zombie_vars["zombie_powerup_insta_kill_ug_on"] = true;
	self._show_solo_hud = true;

	self thread time_remaining_pers_upgrade();
}

//self == player
function time_remaining_pers_upgrade()
{
	self endon ("disconnect");
	self endon( "kill_insta_kill_upgrade_hud_icon" );

	//following time_remaning_on_insta_kill_powerup() in _zm_powerups.gsc
	//might need to add some sounds if needed
	while ( self.zombie_vars["zombie_powerup_insta_kill_ug_time"] >= 0)
	{
		{wait(.05);};
		self.zombie_vars["zombie_powerup_insta_kill_ug_time"] = self.zombie_vars["zombie_powerup_insta_kill_ug_time"] - 0.05;
	}

	self kill_insta_kill_upgrade_hud_icon();
}

//self == player
function kill_insta_kill_upgrade_hud_icon()
{
	//turn off icon
	self.zombie_vars["zombie_powerup_insta_kill_ug_on"] = false;
	self._show_solo_hud = false;
	//reset timer for next time
	self.zombie_vars["zombie_powerup_insta_kill_ug_time"] = level.pers_insta_kill_upgrade_active_time;

	self notify( "kill_insta_kill_upgrade_hud_icon" );
}


//*****************************************************************************
//*****************************************************************************
// DCL3 - Persistent Upgrade Active Functions
//*****************************************************************************
//*****************************************************************************


//*****************************************************************************
// *** PERK LOSE - Upgraded ***
//
//*****************************************************************************

function pers_upgrade_perk_lose_active()
{
	self endon( "disconnect" );

	wait( 0.5 );
	/#
		iprintlnbold( "*** WE'VE GOT PERK LOSE UPGRADED ***" );
	#/
	wait( 0.5 );

	// Record the round number we gained the ability
	self.pers_perk_lose_start_round = level.round_number;

	// If the player buys a perk before round X, you lose the perk
	self waittill( "pers_perk_lose_lost" );

	// Lost the upgrade
	/#
		iprintlnbold( "*** OH NO: Lost PERK LOSE Upgrade ***" );
	#/
	self zm_stats::zero_client_stat( "pers_perk_lose_counter", false );
}


//*****************************************************************************
// *** PISTOL POINTS - Upgraded ***
//
//*****************************************************************************

function pers_upgrade_pistol_points_active()
{
	self endon( "disconnect" );

	wait( 0.5 );
	/#
		iprintlnbold( "*** WE'VE GOT PISTOL POINTS UPGRADED ***" );
	#/
	wait( 0.5 );

	// Wait for a kill and re-check the accuracy
	while( 1 )
	{
		self waittill( "pers_pistol_points_kill" );

		// If the players accuracy has improved enough, you lose the ability
		accuracy = self zm_pers_upgrades_functions::pers_get_player_accuracy();
		if( accuracy > level.pers_pistol_points_accuracy )
		{
			break;
		}
	}

	// Lost the upgrade
	/#
		iprintlnbold( "*** OH NO: Lost PISTOL POINTS Upgrade ***" );
	#/
	self zm_stats::zero_client_stat( "pers_pistol_points_counter", false );
}


//*****************************************************************************
// *** DOUBLE POINTS - Upgraded ***
//
//*****************************************************************************

function pers_upgrade_double_points_active()
{
	self endon( "disconnect" );

	wait( 0.5 );
	/#
		iprintlnbold( "*** WE'VE GOT DOUBLE POINTS UPGRADED ***" );
	#/
	wait( 0.5 );

	// Wait for the lost it notify
	self waittill( "double_points_lost" );

	// Lost the upgrade
	/#
		iprintlnbold( "*** OH NO: Lost DOUBLE POINTS Upgrade ***" );
	#/
	self zm_stats::zero_client_stat( "pers_double_points_counter", false );
}


//*****************************************************************************
// *** SNIPER - Upgraded ***
//
//*****************************************************************************

function pers_upgrade_sniper_active()
{
	self endon( "disconnect" );

	wait( 0.5 );
	/#
		iprintlnbold( "*** WE'VE GOT SNIPER UPGRADED ***" );
	#/
	wait( 0.5 );

	self waittill( "pers_sniper_lost" );

	// Lost the upgrade
	/#
		iprintlnbold( "*** OH NO: Lost SNIPER Upgrade ***" );
	#/
	self zm_stats::zero_client_stat( "pers_sniper_counter", false );
}


//*****************************************************************************
// *** BOX WEAPON - Upgraded ***
//
//*****************************************************************************

function pers_upgrade_box_weapon_active()
{
	self endon( "disconnect" );

	wait( 0.5 );
	/#
		iprintlnbold( "*** WE'VE GOT BOX WEAPON UPGRADED ***" );
	#/

	// Turn on the Box teddy Bear
	self thread zm_pers_upgrades_functions::pers_magic_box_teddy_bear();

	wait( 0.5 );

	self.pers_box_weapon_awarded = true;

	while( 1 )
	{
		level waittill( "start_of_round" );

		if( zm_pers_upgrades::is_pers_system_active() )
		{
			if( level.round_number >= level.pers_box_weapon_lose_round )
			{
				break;
			}
		}
	}

	// Lost the upgrade
	/#
		iprintlnbold( "*** OH NO: Lost BOX WEAPON Upgrade ***" );
	#/
	self zm_stats::zero_client_stat( "pers_box_weapon_counter", false );
}


//*****************************************************************************
// *** NUBE - Upgraded ***
//
//*****************************************************************************

function pers_upgrade_nube_active()
{
	self endon( "disconnect" );

	wait( 0.5 );
	/#
		iprintlnbold( "*** WE'VE GOT NUBE UPGRADED ***" );
	#/
	wait( 0.5 );

	while( 1 )
	{
		level waittill( "start_of_round" );

		if( zm_pers_upgrades::is_pers_system_active() )
		{
			if( level.round_number >= level.pers_nube_lose_round )
			{
				break;
			}
		}
	}
	
	// Lost the upgrade
	/#
		iprintlnbold( "*** OH NO: Lost NUBE Upgrade ***" );
	#/
	self zm_stats::zero_client_stat( "pers_nube_counter", false );
}


