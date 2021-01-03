#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
   	                                                         	                                                                                                                                               	                                                      	                                                                              	                                                          	                                    	                                     	                                                     	                                                                                      	                                                             	                                                                                                    	                                             	                                     	                                                     

#using scripts\zm\gametypes\_globallogic_score;

#using scripts\zm\_util;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                            
                                                                                       	                                
       
                                                                                                                               

#namespace zm_pers_upgrades_functions;

//******************************************************************************
//******************************************************************************
// Persistent System Misc functions for each ability:-
//******************************************************************************
//******************************************************************************


//******************************************************************************
//******************************************************************************
// Boards
//******************************************************************************
//******************************************************************************

// self = player
function pers_boards_updated( zbarrier )
{
	if( ( isdefined( level.pers_upgrade_boards ) && level.pers_upgrade_boards ) )
	{
		if( zm_pers_upgrades::is_pers_system_active() )
		{
			// If the abillty is active, don't try and award it again
			if( !( isdefined( self.pers_upgrades_awarded["board"] ) && self.pers_upgrades_awarded["board"] ) )
			{
				// After a specificed round start tracking for a persistent upgrade
				if( level.round_number >= level.pers_boarding_round_start )
				{
					self zm_stats::increment_client_stat( "pers_boarding", false );

					// If we have reached the unlock limit, set the effect position at the boards position
					if( self.pers["pers_boarding"] >= level.pers_boarding_number_of_boards_required )
					{
						if( IsDefined(zbarrier) )
						{
							self.upgrade_fx_origin = zbarrier.origin;
						}
					}
				}
			}
		}
	}
}


//******************************************************************************
//******************************************************************************
// Revive
//******************************************************************************
//******************************************************************************

// self = player
function pers_revive_active()
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		if( ( isdefined( self.pers_upgrades_awarded["revive"] ) && self.pers_upgrades_awarded["revive"] ) )
		{
			return( 1 );
		}
	}

	return( 0 );
}

function pers_increment_revive_stat( reviver )
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		reviver zm_stats::increment_client_stat( "pers_revivenoperk", false );
	}
}


//******************************************************************************
//******************************************************************************
// Multi Kill Headshot
//******************************************************************************
//******************************************************************************

// self = player
function pers_mulit_kill_headshot_active()
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		if( IsDefined( self.pers_upgrades_awarded) && ( isdefined( self.pers_upgrades_awarded["multikill_headshots"] ) && self.pers_upgrades_awarded["multikill_headshots"] ) )
		{
			return( 1 );
		}
	}

	return( 0 );
}

function pers_check_for_pers_headshot( time_of_death, zombie )
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		if ( self.pers["last_headshot_kill_time"] == time_of_death )
		{
			self.pers["zombies_multikilled"]++;
		}
		else
		{
			self.pers["zombies_multikilled"] = 1;
		}
		self.pers["last_headshot_kill_time"] = time_of_death;
	
		if( self.pers["zombies_multikilled"] == 2 ) //at least 2 or more zombies were killed 
		{
			if(isDefined(zombie))
			{
				self.upgrade_fx_origin = zombie.origin; //for playing upgrade effect
			}
			self zm_stats::increment_client_stat( "pers_multikill_headshots", false );
			self.non_headshot_kill_counter = 0;
		}
	}
}




//******************************************************************************
//******************************************************************************
// Cash Back
//******************************************************************************
//******************************************************************************

//*****************************************************************************
// Only in classic mode - Update the "cash_back" persistent unlock
//*****************************************************************************

// self = player
function cash_back_player_drinks_perk()
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		if( ( isdefined( level.pers_upgrade_cash_back ) && level.pers_upgrade_cash_back ) )
		{
			// If we have the persistent ability, check for not going prone after the perk drink
			if( ( isdefined( self.pers_upgrades_awarded["cash_back"] ) && self.pers_upgrades_awarded["cash_back"] ) )
			{
				// Give the player a money reward
				self thread cash_back_money_reward();

				self thread cash_back_player_prone_check( true );
				//iprintlnbold( "CHECKING FOR PRONE - TO TAKE AWAY" );
			}

			// We don't have the ability, so update the stat tracking
			else
			{
					// Increment the number of perks drank stat if the stat hasn't reached its max
				if( self.pers["pers_cash_back_bought"] < level.pers_cash_back_num_perks_required )
				{
					self zm_stats::increment_client_stat( "pers_cash_back_bought", false );
					//iprintlnbold( "DRANK PERK STAT: INCREMENTED" );
				}
		
				// Only when we have bought 50 perks can we start incrementing the 2nd stat
				else
				{
					// Check if the player goes prone for 2 seconds after drinking the perk
					self thread cash_back_player_prone_check( false );
					//iprintlnbold( "CHECKING FOR PRONE - TO GIVE" );
				}
			}
		}
	}
}


//*****************************************************************************
// Give the player a money reward
//*****************************************************************************

function cash_back_money_reward()
{
	self endon( "death" );

	step = 5;
	amount_per_step = int( level.pers_cash_back_money_reward / step );

	for( i=0; i<step; i++ )
	{
		self zm_score::add_to_player_score( amount_per_step );
		wait( 0.2 );
	}
}


//*****************************************************************************
//*****************************************************************************
// self = player
function cash_back_player_prone_check( got_ability )
{
	self endon( "death" );

	prone_time = 2.5;

	start_time = gettime();
	while( 1 )
	{
		// After 2 seconds without prone, notify a failed prone
		// Only matters if the persistent upgrade has been awarded
		time = gettime();
		dt = ( time - start_time ) / 1000;
		if( dt > prone_time )
		{
			break;
		}

		// We have a prone, inc the 2nd "prone" stat
		if( self GetStance() == "prone" )
		{
			if( !got_ability )
			{
				self zm_stats::increment_client_stat( "pers_cash_back_prone", false );
				wait( 0.8 );
				//iprintlnbold( "PRONE STAT: INCREMENTED" );
			}
			return;
		}

		wait( 0.01 );
	}

	// Did not go prone, so notify the prone failure
	if( got_ability )
	{
		self notify( "cash_back_failed_prone" );
	}
}


//******************************************************************************
//******************************************************************************
// Insta Kill
//******************************************************************************
//******************************************************************************

//*****************************************************************************
// Called on the player that picked up the power up
//*****************************************************************************

// self = player
function pers_upgrade_insta_kill_upgrade_check()
{
	if( ( isdefined( level.pers_upgrade_insta_kill ) && level.pers_upgrade_insta_kill ) )
	{
		self endon( "death" );

		if( !zm_pers_upgrades::is_pers_system_active() )
		{
			return;
		}
			
		// For all players with the "insta_kill" ability, turn it on
		players = GetPlayers();
		for( i=0; i<players.size; i++ )
		{
			e_player = players[i];

			if( ( isdefined( e_player.pers_upgrades_awarded["insta_kill"] ) && e_player.pers_upgrades_awarded["insta_kill"] ) )
			{
				//iprintlnbold( "Player Insta Kill - Upgrade Active" );
				e_player thread insta_kill_upgraded_player_kill_func( level.pers_insta_kill_upgrade_active_time );
			}
		}

		// If the player that picked up the Insta kill pickup doesn't have the ability
		// - If player does not kill a zombie, inc the stat to get the ability
		if( !( isdefined( self.pers_upgrades_awarded["insta_kill"] ) && self.pers_upgrades_awarded["insta_kill"] ) )
		{
			//iprintlnbold( "Player Insta Kill Ability - Upgrade Check" );

			kills_start = self globallogic_score::getPersStat( "kills" );
			self waittill( "insta_kill_over" );
			kills_end = self globallogic_score::getPersStat( "kills" );

			num_killed = kills_end - kills_start;
				if( num_killed > 0 )
			{
				//iprintlnbold( "INSTA KILL: Zombies killed: " + num_killed + " RESET!" );
				self zm_stats::zero_client_stat( "pers_insta_kill", false );
			}
			else
			{
				//iprintlnbold( "INSTA KILL: Upgrade Stat INCREMENTED, NO KILLS");
				self zm_stats::increment_client_stat( "pers_insta_kill", false );
			}
		}
	}
}


//*****************************************************************************
//*****************************************************************************

// self = player
function insta_kill_upgraded_player_kill_func( active_time )
{
	self endon( "death" );
	
	// Wait for it to become active
	wait ( 0.25 );

	// Check its not been disabled
	if( zm_pers_upgrades::is_pers_system_disabled() )
	{
		return;
	}

	// HUD Element, use LUI Icon
	self thread zm_pers_upgrades::insta_kill_pers_upgrade_icon();

	start_time = gettime();

	zombie_collide_radius = 50;			// 45
	zombie_player_height_test = 100;	// 100

	// While Insta Kill is active, search for zombies close by and kill them
	while( 1 )
	{
		// Check for time out
		time = gettime();
		dt = ( time - start_time ) / 1000;
		if( dt > active_time )
		{
			break;
		}

		// Safety, stop killing when insta kill wears off
		if( !zm_powerups::is_insta_kill_active() )
		{
			break;
		}

		// Get all the zombies
		a_zombies = GetAiTeamArray( level.zombie_team );

		// Find the closest zombie
		e_closest = undefined;
		
		for( i=0; i<a_zombies.size; i++ )
		{
			e_zombie = a_zombies[ i ];

			if( IsDefined(e_zombie.marked_for_insta_upgraded_death) )
			{
				continue;
			}
			
			// Does the zombie pass the heigh check? 
			height_diff = abs( self.origin[2] - e_zombie.origin[2] );
			if( height_diff < zombie_player_height_test )
			{
				// Is the zombie close enough to be killed?
				dist = Distance2D( self.origin, e_zombie.origin );
				if( dist < zombie_collide_radius )
				{
					dist_max = dist;
					e_closest = e_zombie;
				}
			}
		}

		// Is the closest zombie within the kill distance?
		if( IsDefined(e_closest) )
		{
			e_closest.marked_for_insta_upgraded_death = true;
			e_closest dodamage( e_closest.health + 666, e_closest.origin, self, self, "none", "MOD_PISTOL_BULLET", 0 );
		}

		wait( 0.01 );
	}

	//iprintlnbold( "Insta kill Upgrade - Timed out" );
}


//******************************************************************************
//******************************************************************************

// self =  player
function pers_insta_kill_melee_swipe( sMeansOfDeath, eAttacker )
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		if( IsDefined(sMeansOfDeath) && (sMeansOfDeath == "MOD_MELEE") )
		{
			if( IsPlayer(self) && zm_pers_upgrades::is_insta_kill_upgraded_and_active() )
			{
				self notify( "pers_melee_swipe" );
				// We will kill this zombie if he's still alive
				level.pers_melee_swipe_zombie_swiper = eAttacker;
			}
		}
	}
}


//******************************************************************************
//******************************************************************************
// Jugg
//******************************************************************************
//******************************************************************************

// self = player
function pers_upgrade_jugg_player_death_stat()
{
	if( ( isdefined( level.pers_upgrade_jugg ) && level.pers_upgrade_jugg ) )
	{
		if( zm_pers_upgrades::is_pers_system_active() )
		{
			// If we don't have the ability, update the stat tracking
			if( !( isdefined( self.pers_upgrades_awarded["jugg"] ) && self.pers_upgrades_awarded["jugg"] ) )
			{
				if( level.round_number <= level.pers_jugg_hit_and_die_round_limit )
				{
					// Increment the number of zombie swipes we survived
					self zm_stats::increment_client_stat( "pers_jugg", false );
					/#
						//iprintlnbold( "PERS JUGG STAT: INCREMENTED" );
					#/
				}
			}
		}
	}
}

// self = player
function pers_jugg_active()
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		if( IsDefined(self.pers_upgrades_awarded) && ( isdefined( self.pers_upgrades_awarded["jugg"] ) && self.pers_upgrades_awarded["jugg"] ) )
		{
			return( 1 );
		}
	}

	return( 0 );
}


//******************************************************************************
//******************************************************************************
// Pistol Points
//******************************************************************************
//******************************************************************************




//******************************************************************************
//******************************************************************************
// Pistol Points
//******************************************************************************
//******************************************************************************

//*****************************************************************************
// Called when the player kills a zombie
//*****************************************************************************

// self = player
function pers_upgrade_pistol_points_kill()
{
	if( !zm_pers_upgrades::is_pers_system_active() )
	{
		return;
	}

	// Register the kill
	if( !IsDefined(self.pers_num_zombies_killed_in_game) )
	{
		self.pers_num_zombies_killed_in_game = 0;
	}
	self.pers_num_zombies_killed_in_game++;

	// If we don't have the persistent ability, check to see if we should activate it
	if( !( isdefined( self.pers_upgrades_awarded["pistol_points"] ) && self.pers_upgrades_awarded["pistol_points"] ) )
	{
		// Has the player killed the required number of zombies yet?
		if( self.pers_num_zombies_killed_in_game >= level.pers_pistol_points_num_kills_in_game )
		{
			// Get the players accuracy, if the players accuracy is low enough, activate the upgrade
			accuracy = self pers_get_player_accuracy();
			if( accuracy <= level.pers_pistol_points_accuracy )
			{
				// Activate the Ability
				self zm_stats::increment_client_stat( "pers_pistol_points_counter", false );
				/#
					iprintlnbold( "PISTOL POINTS STAT: INCREMENTED" );
				#/
			}
		}
	}

	// If we have it, notify the update routine to check if we should lose it
	else
	{
		self notify( "pers_pistol_points_kill" );
	}
}


//*****************************************************************************
// Called when a player shoots a zombie
//*****************************************************************************

// self = player
function pers_upgrade_pistol_points_set_score( score, event, mod, damage_weapon )
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		if( ( isdefined( self.pers_upgrades_awarded["pistol_points"] ) && self.pers_upgrades_awarded["pistol_points"] ) )
		{
			if( IsDefined(event) )
			{
				// Fix for an SRE when rebuilding boards (mod is passed as a number)
				if( event == "rebuild_board" )
				{
					return( score );
				}

				// Can we verify that it is a PISTOL WEAPON
				// Needed for the AK74u - It gives MOD_PISTOL_BULLET damage for some reason!
				if( IsDefined(damage_weapon) )
				{
					weapon_class = zm_utility::getWeaponClassZM( damage_weapon );
					if( weapon_class != "weapon_pistol" )
					{
						return( score );
					}
				}

				// Just check the pistol, don't need to check damage type
				//if( (event == "damage") || (event == "death") || (event == "damage_light") || (event == "damage_heavy") )
				{
					if( IsDefined(mod) && (IsString(mod)) && (mod == "MOD_PISTOL_BULLET") )
					{
						score = score * 2;
					}
				}
			}
		}
	}

	return( score );
}


//******************************************************************************
//******************************************************************************
// Double Points
// - Wait time is 30 seconds
// - Its ok for the player to lose points, but they can't gain any points
//******************************************************************************
//******************************************************************************

// self = player
function pers_upgrade_double_points_pickup_start()
{
	self endon( "death" );
	self endon( "disconnect" );

	if( !zm_pers_upgrades::is_pers_system_active() )
	{
		return;
	}
	
	// If the double points check is already active, just reset the wait time
	if( ( isdefined( self.double_points_ability_check_active ) && self.double_points_ability_check_active ) )
	{
		self.double_points_ability_start_time = gettime();
		return;
	}
	
	// Used to stop multiple double point theads being active at the same time
	self.double_points_ability_check_active = true;

	// Same wait time as the powerup
	level.pers_double_points_active = true;

	// Count the amount of points scored while the powerup is active
	start_points = self.score;

	// Whats the players bank account value, we don't want bank transactions counting as points gained
	if( IsDefined(self.account_value) )
	{
		bank_account_value_start = self.account_value;
	}
	else
	{
		bank_account_value_start = 0;
	}

	// Check every frame that the players points tally has not increased
	self.double_points_ability_start_time = gettime();
	last_score = self.score;
	ability_lost = false;
	while( 1 )
	{
		if( self.score > last_score )
		{
			ability_lost = true;
		}
		last_score = self.score;

		time = gettime();
		dt = ( time - self.double_points_ability_start_time ) / 1000;
		if( dt >= 30 )
		{
			break;
		}

		wait( 0.1 );
	}
	
	level.pers_double_points_active = undefined;

	// Whats the players bank account value at the end
	if( IsDefined(self.account_value) )
	{
		bank_account_value_end = self.account_value;
	}
	else
	{
		bank_account_value_end = 0;
	}

	// If the account value is negative then the player made withdrawals, so remove the withdrawal amount from the points scored
	if( bank_account_value_end < bank_account_value_start )
	{
		withdrawal_number = ( bank_account_value_start - bank_account_value_end );

		withdrawal_fees = level.ta_vaultfee * withdrawal_number;
		withdrawal_amount = level.bank_deposit_ddl_increment_amount * withdrawal_number;

		bank_withdrawal_total = withdrawal_amount - withdrawal_fees;
	}
	else
	{
		bank_withdrawal_total = 0;
	}

	// If the ability is active
	// - The player loses the ability if they got any points
	if( ( isdefined( self.pers_upgrades_awarded["double_points"] ) && self.pers_upgrades_awarded["double_points"] ) )
	{
		// If the player ever has gained points, you lose the upgrade
		if( ability_lost == true )
		{
			self notify( "double_points_lost" );	
		}
	}

	// If the ability is not active
	// - The player needs to have reached the required amount to activate the ability
	else
	{
		total_points = self.score - start_points;

		// Don't include bank withdrawals from the players points gained
		total_points = total_points - bank_withdrawal_total;

		if( total_points >= level.pers_double_points_score )
		{
			// Activate the Ability
			self zm_stats::increment_client_stat( "pers_double_points_counter", false );
			/#
				iprintlnbold( "PISTOL POINTS STAT: INCREMENTED" );
			#/
		}
	}

	self.double_points_ability_check_active = undefined;
}


//*****************************************************************************
// Called when a player spends money
// - Halve the score (or cost) when the double points powerup is ACTIVE
//*****************************************************************************

// self = player
function pers_upgrade_double_points_set_score( score )
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		if( ( isdefined( self.pers_upgrades_awarded["double_points"] ) && self.pers_upgrades_awarded["double_points"] ) )
		{
			// Only halve the score if the powerup double points is active
			if( ( isdefined( level.pers_double_points_active ) && level.pers_double_points_active ) )
			{
				/#
					//iprintlnbold( "Points Halved" );
				#/
				score = int(score * 0.5);
			}
		}
	}

	return( score );
}

function pers_upgrade_double_points_cost( current_cost )
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		if( ( isdefined( self.pers_upgrades_awarded["double_points"] ) && self.pers_upgrades_awarded["double_points"] ) )
		{
			current_cost = int( current_cost / 2 );
		}
	}
	return( current_cost );
}

function is_pers_double_points_active()
{
	// Is the ability active?
	if( ( isdefined( self.pers_upgrades_awarded["double_points"] ) && self.pers_upgrades_awarded["double_points"] ) )
	{
		// Is the powerup active?
		if( ( isdefined( level.pers_double_points_active ) && level.pers_double_points_active ) )
		{
			return( 1 );
		}
	}
	return( 0 );
}


//******************************************************************************
//******************************************************************************
// Perk Lose
//******************************************************************************
//******************************************************************************

// self = player
function pers_upgrade_perk_lose_bought()
{
	if( !zm_pers_upgrades::is_pers_system_active() )
	{
		return;
	}
	
	// Allows the perk to get registerered
	wait( 1 );

	// If the ability NOT active
	// - Buy 3 perks before round X to inc the stat
	if( !( isdefined( self.pers_upgrades_awarded["perk_lose"] ) && self.pers_upgrades_awarded["perk_lose"] ) )
	{
		// Is the round number low enough?
		if( level.round_number <= level.pers_perk_round_reached_max )
		{
			// Has the stat been incremented this game?
			if( !IsDefined(self.bought_all_perks) )
			{
				// Has the player bought all 4 perks?  Stat can only be incremented once in a game
				// If so, increment the stat
				a_perks = self zm_perks::get_perk_array();
				if( IsDefined(a_perks) && (a_perks.size == 4) )
				{
					self zm_stats::increment_client_stat( "pers_perk_lose_counter", false );
					/#
						iprintlnbold( "PERK LOSE STAT: INCREMENTED" );
					#/
					self.bought_all_perks = true;
				}
			}
		}
	}

	// If the ability IS active
	// - Lose it by buying a perk in the same round they lost a perk in
	else
	{
		if( IsDefined(self.pers_perk_lose_start_round) )
		{
			// round > 1 caters for starting a new game
			if( (level.round_number > 1) && (self.pers_perk_lose_start_round == level.round_number) )
			{
				self notify( "pers_perk_lose_lost" );
			}
		}
	}
}


//*****************************************************************************
// Save the perks and primary weapons the player has
//*****************************************************************************

function pers_upgrade_perk_lose_save()
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		// Save perks
		if ( IsDefined( self.perks_active ) )
		{
			self.a_saved_perks = [];
			self.a_saved_perks = ArrayCopy( self.perks_active );  // if using self.perks_active directly, ArrayRemoveValue will remove entries from _zm_perks.gsc
		}	
		else
		{
			self.a_saved_perks = self zm_perks::get_perk_array();
		}
		
		// Save weapons, needed if the mule kick weapons needs to be restored
		self.a_saved_primaries = self GetWeaponsListPrimaries();
		self.a_saved_primaries_weapons = [];
		index = 0;
		foreach( weapon in self.a_saved_primaries )
		{
			// saves weapon, ammo, dual wield ammo, and alt weapon ammo
			self.a_saved_primaries_weapons[ index ] = zm_weapons::get_player_weapondata( self, weapon );
			index++;
		}
	}
}


//*****************************************************************************
// Restore the perks and primary weapons the player has
//*****************************************************************************

function pers_upgrade_perk_lose_restore()
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		player_has_mule_kick = false;
		discard_quickrevive = false;

		// Restore perks
		if( IsDefined(self.a_saved_perks) && (self.a_saved_perks.size >= 2) )
		{
			// Note: If you have quick revive, the perk you lose is quick revive
			// Otherwise its the last one in the array
			for( i=0; i<self.a_saved_perks.size; i++ )
			{
				perk = self.a_saved_perks[ i ];
				if( perk == "specialty_quickrevive" )
				{
					discard_quickrevive = true;
				}
			}
			
			// Give all back except quick revive
			if( discard_quickrevive == true )
			{
				size = self.a_saved_perks.size;
			}
			// Give all back (-1)
			else
			{
				size = self.a_saved_perks.size - 1;
			}
			
			// Restore perks
			for( i=0; i<size; i++ )
			{
				perk = self.a_saved_perks[ i ];

				if( (discard_quickrevive == true) && (perk == "specialty_quickrevive") )
				{
					continue;
				}
				
				if( perk == "specialty_additionalprimaryweapon" )
				{
					player_has_mule_kick = true;
				}

				if( self HasPerk(perk) )
				{
					continue;
				}

				self zm_perks::give_perk( perk );

				// Needed to the perks get given back in the correct order (not stored in a single frame bitfield)
				util::wait_network_frame();
			}
		}

		// Does the mule kick weapon need to be restored?
		if( player_has_mule_kick )
		{
			a_current_weapons = self GetWeaponsListPrimaries();

			for( i=0; i<self.a_saved_primaries_weapons.size; i++ )
			{
				saved_weapon = self.a_saved_primaries_weapons[i];

				// Do we have the saved weapon?
				found = false;
				for( j=0; j<a_current_weapons.size; j++ )
				{
					current_weapon = a_current_weapons[j];
					if( current_weapon == saved_weapon["weapon"] )
					{
						found = true;
						break;
					}
				}

				// Did we find a new weapon to give the player?
				if( found == false )
				{
					self zm_weapons::weapondata_give( self.a_saved_primaries_weapons[ i ] );
					self SwitchToWeapon( a_current_weapons[0] );
					break;
				}
			}
		}
		
		// Cleanup
		self.a_saved_perks = undefined;
		self.a_saved_primaries = undefined;
		self.a_saved_primaries_weapons = undefined;
	}
}


//******************************************************************************
//******************************************************************************
// Sniper
//******************************************************************************
//******************************************************************************


//*****************************************************************************
// Called when the player kills a zombie
// NOTE: call from zombie_death_event()
//*****************************************************************************

// self = player
function pers_upgrade_sniper_kill_check( zombie, attacker )
{
	if( !zm_pers_upgrades::is_pers_system_active() )
	{
		return;
	}

	if( !IsDefined(zombie) || !IsDefined(attacker) )
	{
		return;
	}

	if( ( isdefined( zombie.marked_for_insta_upgraded_death ) && zombie.marked_for_insta_upgraded_death ) )
	{
		return;
	}

	// Was it a sniper kill?
	weapon = zombie.damageweapon;

	if( weapon.isSniperWeapon )
	{
		return;
	}
	
	// Is the ability active?
	if( ( isdefined( self.pers_upgrades_awarded["sniper"] ) && self.pers_upgrades_awarded["sniper"] ) )
	{
		// Award the player with extra points
		self thread pers_sniper_score_reward();
	}

	// Not active, so check the rules for activating
	else
	{
		// Is the kill distance acceptable
		dist = distance( zombie.origin, attacker.origin );
		if( dist < level.pers_sniper_kill_distance )
		{
			return;
		}
	
		// Ok, the kill is valid, update the tracking
		if( !IsDefined(self.pers_sniper_round) )
		{
			self.pers_sniper_round = level.round_number;
			self.pers_sniper_kills = 0;
		}
		else if( self.pers_sniper_round != level.round_number )
		{
			self.pers_sniper_round = level.round_number;
			self.pers_sniper_kills = 0;
		}

		self.pers_sniper_kills++;

		/#
			iprintlnbold( "Pers: Long range Sniper Kill" );
		#/

		if( self.pers_sniper_kills >= level.pers_sniper_round_kills_counter )
		{
			self zm_stats::increment_client_stat( "pers_sniper_counter", false );
			/#
				iprintlnbold( "SNIPER STAT: INCREMENTED" );
			#/
		}
	}
}

//*****************************************************************************
//*****************************************************************************

function pers_sniper_score_reward()
{
	self endon( "disconnect" );
	self endon( "death" );

	if( zm_pers_upgrades::is_pers_system_active() )
	{
		total_score = 300;
		steps = 10;
		score_inc = int( total_score / steps );

		for( i=0; i<steps; i++ )
		{
			self zm_score::add_to_player_score( score_inc );
			wait( 0.25 );
		}
	}
}


//*****************************************************************************
// Called whan a player fires
//  - LOSE RULES: Miss 3 shots in a row
//*****************************************************************************

function pers_sniper_player_fires( weapon, hit )
{
	if( !zm_pers_upgrades::is_pers_system_active() )
	{
		return;
	}

	if( IsDefined(weapon) && IsDefined(hit) )
	{
		// Is the ability active?
		if( ( isdefined( self.pers_upgrades_awarded["sniper"] ) && self.pers_upgrades_awarded["sniper"] ) )
		{
			if( weapon.isSniperWeapon )
			{
				// Make sure the miss tracking is initialized
				if( !IsDefined(self.num_sniper_misses) )
				{
					self.num_sniper_misses = 0;
				}

				// Did we hit or miss
				if( hit )
				{
					self.num_sniper_misses = 0;
				}
				else
				{
					self.num_sniper_misses++;
					if( self.num_sniper_misses >= level.pers_sniper_misses )
					{
						self notify( "pers_sniper_lost" );
						self.num_sniper_misses = 0;
					}
				}
			}
		}
	}
}


//*****************************************************************************
// Calculate the players accuracy
//*****************************************************************************

function pers_get_player_accuracy()
{
	accuracy = 1.0;

	total_shots = self globallogic_score::getPersStat( "total_shots" );
	total_hits = self globallogic_score::getPersStat( "hits" );

	if( total_shots > 0 )
	{
		accuracy = total_hits / total_shots;
	}
	return( accuracy );
}


//******************************************************************************
//******************************************************************************
// Box Weapon
// - Called when a player used the box
//******************************************************************************
//******************************************************************************

// self = box
function pers_upgrade_box_weapon_used( e_user, e_grabber )
{
	if( !zm_pers_upgrades::is_pers_system_active() )
	{
		return;
	}

	// Can't get the ability after round X
	if( level.round_number >= level.pers_box_weapon_lose_round )
	{
		return;
	}

	// Did the player pick up the weapon?
	if( IsDefined(e_grabber) && IsPlayer(e_grabber) )
	{
		// Only allowed to gain the ability once per game
		if( ( isdefined( e_grabber.pers_box_weapon_awarded ) && e_grabber.pers_box_weapon_awarded ) )
		{
			return;
		}
		
		// If the abililty is active, no need to do anything
		if( ( isdefined( e_grabber.pers_upgrades_awarded["box_weapon"] ) && e_grabber.pers_upgrades_awarded["box_weapon"] ) )
		{
			return;
		}
		e_grabber zm_stats::increment_client_stat( "pers_box_weapon_counter", false );
		/#
			//iprintlnbold( "BOX WEAPON STAT: INCREMENTED" );
		#/
	}

	// If the player failed to grab the weapon after activating the box, reset the persistent counter
	else			
	{
		if( IsDefined(e_user) && IsPlayer(e_user) )
		{
			// The player only have their stats reset of they don;t have the ability
			// - If you have the ability and choose not to take the weapon, thats ok
			if( ( isdefined( e_user.pers_upgrades_awarded["box_weapon"] ) && e_user.pers_upgrades_awarded["box_weapon"] ) )
			{
				return;
			}
			
			e_user zm_stats::zero_client_stat( "pers_box_weapon_counter", false );

			/#
				//iprintlnbold( "BOX WEAPON STAT: RESET" );
			#/
		}
	}
}


//*****************************************************************************
// self = player
//*****************************************************************************

function pers_magic_box_teddy_bear()
{
	self endon( "disconnect" );

	// Special case teddy bears for the fire sale boxes
	if( ( isdefined( level.pers_magic_box_firesale ) && level.pers_magic_box_firesale ) )
	{
		self thread pers_magic_box_firesale();
	}

	// Create the magic box teddy bear
	m_bear = Spawn( "script_model", self.origin );
	m_bear SetModel( level.chest_joker_model );

	// Set bears location relative to the box
	m_bear pers_magic_box_set_teddy_location( level.chest_index );

	//playfxontag( level._effect["powerup_on"], m_bear, "tag_origin" );
	
	self.pers_magix_box_teddy_bear = m_bear;
	
	// Make the teddy bear only visible to the player with the ability
	m_bear SetInvisibleToAll();
	wait( 0.1 );
	m_bear SetVisibleToPlayer( self );

	// We now have to wait for state changes:-
	//  - The box moves
	//  - The player loses the ability
	while( 1 )
	{
		box = level.chests[level.chest_index];

		// Check for the player losing the ability
		if( level.round_number >= level.pers_box_weapon_lose_round )
		{
			break;
		}


		//*************************************
		// Check for the mini-game being active
		//  - If so, hide the bear
		//*************************************

		if( zm_pers_upgrades::is_pers_system_disabled() )
		{
			m_bear SetInvisibleToAll();

			while( 1 )
			{
				if( !zm_pers_upgrades::is_pers_system_disabled() )
				{
					break;
				}
				wait( 0.01 );
			}

			m_bear SetVisibleToPlayer( self );
		}


		//**************************************************
		// If the box starts to move:-
		//  - Hide the bear
		//  - Wait for the box move to complete
		//  - Show the bear again in the new position
		//**************************************************

		if( level flag::get("moving_chest_now") )
		{
			m_bear SetInvisibleToAll();
			
			while( level flag::get("moving_chest_now") )
			{
				wait( 0.1 );
			}

			// Set bears location relative to the box
			m_bear pers_magic_box_set_teddy_location( level.chest_index );
			wait( 0.1 );

			m_bear SetVisibleToPlayer( self );
		}


		//**********************************************************************
		// If the box is moved by the sloth, 
		// - Hide the bear
		// - Show the bear at the boxes new location once the move has completed
		//**********************************************************************

		if( ( isdefined( level.sloth_moving_box ) && level.sloth_moving_box ) )
		{
			m_bear SetInvisibleToAll();
			
			while( ( isdefined( level.sloth_moving_box ) && level.sloth_moving_box ) )
			{
				wait( 0.1 );
			}

			// Set bears location relative to the box
			m_bear pers_magic_box_set_teddy_location( level.chest_index );
			wait( 0.1 );

			m_bear SetVisibleToPlayer( self );
		}


		//*************************************
		// If the box lid is open
		// - Hide the bear until the lid closes
		//*************************************

		if( ( isdefined( box._box_open ) && box._box_open ) )
		{
			m_bear SetInvisibleToAll();

			while( 1 )
			{
				if( !( isdefined( box._box_open ) && box._box_open ) )
				{
					break;
				}
				wait( 0.01 );
			}

			m_bear SetVisibleToPlayer( self );
		}

		wait( 0.01 );
	}

	// Cleanup the model
	m_bear delete();
}

// self = teddy bear
function pers_magic_box_set_teddy_location( box_index )
{
	box = level.chests[box_index];

	if( IsDefined(box.zbarrier) )
	{
		v_origin = box.zbarrier.origin;
		v_angles = box.zbarrier.angles;
	}
	else
	{
		v_origin = box.origin;
		v_angles = box.angles;
	}

	v_up = anglestoup( v_angles );

	height_offset = 22;			// 20
	self.origin = v_origin + ( v_up * height_offset );

	// Set the angels offset for boxes that are facing UP or DOWN
	dp = vectordot( v_up, (0,0,1) );
	if( dp > 0 )
	{
		v_angles_offset = (0, 90, 0);
	}
	else
	{
		v_angles_offset = (0, -90, -10);
	}

	self.angles = v_angles + v_angles_offset;
}

// Pick a special weapon from the box
function pers_treasure_chest_ChooseSpecialWeapon( player )
{
	rval = randomfloat( 1 );

	if( !IsDefined(player.pers_magic_box_weapon_count) )
	{
		player.pers_magic_box_weapon_count = 0;
	}
	
	// Should we pick a special weapon?	
	if( (player.pers_magic_box_weapon_count < 2) && ((player.pers_magic_box_weapon_count == 0) || (rval < 0.6)) )
	{
/#
		//iprintlnbold( "BOX: Special Weapon" );
#/

		player.pers_magic_box_weapon_count++;

		// Get the weapons array
		if( IsDefined(level.pers_treasure_chest_get_weapons_array_func) )
		{
			[[ level.pers_treasure_chest_get_weapons_array_func ]]();
		}
		else
		{
			pers_treasure_chest_get_weapons_array();
		}

		keys = array::randomize( level.pers_box_weapons );

/#
		forced_weapon_name = GetDvarString( "scr_force_weapon" );
		forced_weapon = GetWeapon( forced_weapon_name );
		if ( forced_weapon_name != "" && IsDefined( level.zombie_weapons[ GetWeapon( forced_weapon ) ] ) )
		{
			ArrayInsert( keys, forced_weapon, 0 );
		}
#/
		
		pap_triggers = zm_pap_util::get_triggers();
		for( i=0; i<keys.size; i++ )
		{
			if( zm_magicbox::treasure_chest_CanPlayerReceiveWeapon( player, keys[i], pap_triggers ) )
			{
				return keys[i];
			}
		}

		return keys[0];
	}
	else
	{
/#
		//iprintlnbold( "BOX: Regular Weapon" );
#/

		player.pers_magic_box_weapon_count = 0;
		weapon = zm_magicbox::treasure_chest_ChooseWeightedRandomWeapon( player );
		return( weapon );
	}
}

// Generic multi map weapons available from the magic box persistent upgrade
function pers_treasure_chest_get_weapons_array()
{
	if( !IsDefined(level.pers_box_weapons) )
	{
		level.pers_box_weapons = [];
		level.pers_box_weapons[ level.pers_box_weapons.size ] = GetWeapon( "ray_gun" );
		level.pers_box_weapons[ level.pers_box_weapons.size ] = GetWeapon( "knife_ballistic" );
		level.pers_box_weapons[ level.pers_box_weapons.size ] = GetWeapon( "srm1216" );
		level.pers_box_weapons[ level.pers_box_weapons.size ] = GetWeapon( "hamr" );
		level.pers_box_weapons[ level.pers_box_weapons.size ] = GetWeapon( "tar21" );
		level.pers_box_weapons[ level.pers_box_weapons.size ] = GetWeapon( "raygun_mark2" );
	}
}
	
// If the player has the box ability and a fire sale kicks off
//  - Give all boxes the ability
function pers_magic_box_firesale()
{
	self endon( "disconnect" );

	wait( 1 );
	
	// Wait for a firesale
	while( 1 )
	{
		// Has the fire sale started?
		if( level.zombie_vars["zombie_powerup_fire_sale_on"] == true )
		{
			// Wait for the boxes to appear
			wait( 5 );

			// Ok add Teddy Bears to all boxes 
			for ( i=0; i<level.chests.size; i++ )
			{
				if ( i == level.chest_index )
				{
					continue;
				}
		
				box = level.chests[i];
				self thread box_firesale_teddy_bear( box, i );
			}

			// Wait for the fire sale to complete
			while( 1 )
			{
				if( level.zombie_vars["zombie_powerup_fire_sale_on"] == false )
				{
					break;
				}
				wait( 0.01 );
			}
			
			// Remove all the fire sale teddy bears
				
		}


		// Has the player lost the ability?

		// Check for the player losing the ability
		if( level.round_number >= level.pers_box_weapon_lose_round )
		{
			return;
		}

		wait( 0.5 );
	}
}

// self = player
function box_firesale_teddy_bear( box, box_index )
{
	self endon( "disconnect" );

	// Createt the bear above the box
	m_bear = Spawn( "script_model", self.origin );
	m_bear SetModel( level.chest_joker_model );

	// Set bears location relative to the box
	m_bear pers_magic_box_set_teddy_location( box_index );

	// Make the teddy bear only visible to the player with the ability
	m_bear SetInvisibleToAll();
	wait( 0.1 );
	m_bear SetVisibleToPlayer( self );
		
	// Wait for the firesale to finish
	while( 1 )
	{
		//*************************************
		// If the box lid is open
		// - Hide the bear until the lid closes
		//*************************************

		if( ( isdefined( box._box_open ) && box._box_open ) )
		{
			m_bear SetInvisibleToAll();

			while( 1 )
			{
				if( !( isdefined( box._box_open ) && box._box_open ) )
				{
					break;
				}
				wait( 0.01 );
			}

			m_bear SetVisibleToPlayer( self );
		}

		// Has the firesale finished?
		if( level.zombie_vars["zombie_powerup_fire_sale_on"] == false )
		{
			break;
		}
		
		wait( 0.01 );
	}

	// Delete the bear
	m_bear delete();
}


//******************************************************************************
//******************************************************************************
// Nube
//
// - Player needs to get 5 or more kills consecutively with:-
//   -> No melee kills
//   -> No headshot kills
//   -> No boarding
// - Once these conditions are met, the next time they buy the bad weapon (the olympia) or ammo they get the upgrade
//******************************************************************************
//******************************************************************************

function pers_nube_unlock_watcher()
{
	self endon( "disconnect" );

	if( !zm_pers_upgrades::is_pers_system_active() )
	{
		return;
	}

	// The total number of nube kills
	self.pers_num_nube_kills = 0;

	// If the player has ever reached round 10, you can't get this ability
	if( self.pers["pers_max_round_reached"] >= level.pers_nube_lose_round )
	{
		return;
	}

	// Record the current stats
	num_melee_kills = self.pers["melee_kills"];
	num_headshot_kills = self.pers["headshots"];
	num_boards = self.pers["boards"];

	// Update the number of "nube" kills
	while( 1 )
	{
		// Wait for a zombie kill
		self waittill( "pers_player_zombie_kill" );

		// If the player has ever reached round 10, you can't get this ability
		if( self.pers["pers_max_round_reached"] >= level.pers_nube_lose_round )
		{
			self.pers_num_nube_kills = 0;
			return;
		}
		
		// If the stats havn't increased in size, increase the rule counter
		if( (num_melee_kills == self.pers["melee_kills"]) && (num_headshot_kills == self.pers["headshots"]) && (num_boards == self.pers["boards"]) )
		{
			self.pers_num_nube_kills++;
		}
		else
		{
			self.pers_num_nube_kills = 0;

			num_melee_kills = self.pers["melee_kills"];
			num_headshot_kills = self.pers["headshots"];
			num_boards = self.pers["boards"];
		}
	}
}

function pers_nube_player_ranked_as_nube( player )
{
	if( player.pers_num_nube_kills >= level.pers_numb_num_kills_unlock )
	{
		return( 1 );
	}
	return( 0 );
}

function pers_nube_weapon_upgrade_check( player, weapon )
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		// If its the Olympia weapon, maybe we upgrade to the Ray Gun
		if( weapon.name == "rottweil72" )
		{
			if( !( isdefined( player.pers_upgrades_awarded["nube"] ) && player.pers_upgrades_awarded["nube"] ) )
			{
				if( pers_nube_player_ranked_as_nube( player ) )
				{
					player zm_stats::increment_client_stat( "pers_nube_counter", false );
					weapon = GetWeapon( "ray_gun" );
					
					// Becuase the player is soo close to the wall, play the effect closer to the player
					fx_org = player.origin;
					v_dir = anglestoforward( player getplayerangles() );
					v_up = anglestoup( player getplayerangles() );
					fx_org = fx_org + (v_dir * 5 ) + (v_up * 12);
					player.upgrade_fx_origin = fx_org;
				}
			}
			else
			{
				weapon = GetWeapon( "ray_gun" );
			}
		}
	}

	return weapon;
}

// Upgrade Ammo for the "nube" ray gun check
function pers_nube_weapon_ammo_check( player, weapon )
{
	if( zm_pers_upgrades::is_pers_system_active() )
	{
		// Is it the Olympia weapon
		if( weapon.name == "rottweil72" )
		{
			// Is the upgrade active?
			if( ( isdefined( player.pers_upgrades_awarded["nube"] ) && player.pers_upgrades_awarded["nube"] ) )
			{
				// Do we have the Ray gun?
				ray_gun_weapon = GetWeapon( "ray_gun" );
				if( player HasWeapon( ray_gun_weapon ) )
				{
					weapon = GetWeapon( ray_gun_weapon );
				}

				// Do we have the upgraded Ray Gun?
				ray_gun_upgraded_weapon = GetWeapon( "ray_gun_upgraded" );
				if( player HasWeapon( ray_gun_upgraded_weapon ) )
				{
					weapon = GetWeapon( ray_gun_upgraded_weapon );
				}
			}
		}
	}

	return weapon;
}

// If the player doesn't have the raygun we should give it to them
function pers_nube_should_we_give_raygun( player_has_weapon, player, weapon_buy )
{
	if( !zm_pers_upgrades::is_pers_system_active() )
	{
		return( player_has_weapon );
	}

	// If the player has ever reached round 10, you can't get this ability
	if( player.pers["pers_max_round_reached"] >= level.pers_nube_lose_round )
	{
		return( player_has_weapon );
	}

	// If the player hasn't met the conditions for the reward, abort out.
	if( !pers_nube_player_ranked_as_nube( player ) )
	{
		return( player_has_weapon );
	}

	// Only give the Raygun (or ammo) if its the Olympia we are trying to buy
	rottweil_weapon = GetWeapon( "rottweil72" );
	if( weapon_buy != rottweil_weapon )
	{
		return( player_has_weapon );
	}

	// Does the player have any of the two important weapons?
	player_has_olympia = ( (player HasWeapon(rottweil_weapon)) || (player HasWeapon(GetWeapon( "rottweil72_upgraded" ))) );
	player_has_raygun = ( (player HasWeapon(GetWeapon( "ray_gun" ))) || (player HasWeapon(GetWeapon( "ray_gun_upgraded" ))) );

	// If the player has the RAY GUN and OLYMPIA, just update ammo
	if( player_has_olympia && player_has_raygun )
	{
		player_has_weapon = 1;
	}

	// If the player his "Ranked as a Nube" and has the Olympia but not the Ray Gun, let them buy the weapon
	else if ( pers_nube_player_ranked_as_nube(player) && (player_has_olympia) && (player_has_raygun == 0) )
	{
		player_has_weapon = 0;
	}
	
	// If the player has the ABILITY and the Ray Gun, then its ammo reload time
	else if( ( isdefined( player.pers_upgrades_awarded["nube"] ) && player.pers_upgrades_awarded["nube"] ) && (player_has_raygun) )
	{
		player_has_weapon = 1;
	}

	return( player_has_weapon );
}

// If the player has the nube upgrade and has bought the olympia
// - We need to change the prompt to an ammo promot
function pers_nube_ammo_hint_string( player, weapon )
{
	ammo_cost = 0;

	if( !zm_pers_upgrades::is_pers_system_active() )
	{
		return( 0 );
	}
		
	// Is it the Olympia weapon
	if( weapon.name == "rottweil72" )
	{
		// Do we have the Ray gun?
		ammo_cost = pers_nube_ammo_cost( player, ammo_cost );
	}

	if( !ammo_cost )
	{
		return( false );
	}
	
	self.stub.hint_string = &"ZOMBIE_WEAPONAMMOONLY"; //get_weapon_hint_ammo(); 
	self SetHintString( self.stub.hint_string, ammo_cost );

	return( true );
}

function pers_nube_ammo_cost( player, ammo_cost )
{
	if( player HasWeapon( GetWeapon( "ray_gun" ) ) )
	{
		ammo_cost = 250;
	}
	// Do we have the upgraded Ray Gun?
	if( player HasWeapon( GetWeapon( "ray_gun_upgraded" ) ) )
	{
		ammo_cost = 4500;
	}

	return( ammo_cost );
}

function pers_nube_override_ammo_cost( player, weapon, ammo_cost )
{
	if( !zm_pers_upgrades::is_pers_system_active() )
	{
		return( ammo_cost );
	}
		
	// Is it the Olympia weapon
	if( weapon.name == "rottweil72" )
	{
		// Do we have the Ray gun?
		ammo_cost = pers_nube_ammo_cost( player, ammo_cost );
	}

	return( ammo_cost );
}




