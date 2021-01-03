#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

       
                                                                                                                               

#namespace zm_pers_upgrades_system;

//******************************************************************************
// Persistent System Library Functions:-
// - General global functions for the persistent system
// - Put upgrade specific setup and releted functions in "_zm_pers_upgrades/gsc"
//******************************************************************************



//*****************************************************************************
// Function: Sets up a persistent upgrade
//*****************************************************************************

function pers_register_upgrade( name, upgrade_active_func, stat_name, stat_desired_value, game_end_reset_if_not_achieved )
{
	if( !IsDefined(level.pers_upgrades) )
	{
		level.pers_upgrades = [];
		level.pers_upgrades_keys = [];
	}	
	
	if( IsDefined(level.pers_upgrades[name]) )
	{
		assert( 0, "A persistent upgrade is already registered for name: " + name );
	}
	
	level.pers_upgrades_keys[ level.pers_upgrades_keys.size ] = name;

	level.pers_upgrades[ name ] = spawnstruct();
	level.pers_upgrades[ name ].stat_names = [];
	level.pers_upgrades[ name ].stat_desired_values = [];
	level.pers_upgrades[ name ].upgrade_active_func = upgrade_active_func;
	level.pers_upgrades[ name ].game_end_reset_if_not_achieved = game_end_reset_if_not_achieved;

	add_pers_upgrade_stat( name, stat_name, stat_desired_value );
	
/#	
	if (IsDefined(level.devgui_add_ability))
	{
		[[level.devgui_add_ability]]( name, upgrade_active_func, stat_name, stat_desired_value, game_end_reset_if_not_achieved );
	}
#/	
}


//*****************************************************************************
//*****************************************************************************

function add_pers_upgrade_stat( name, stat_name, stat_desired_value )
{
	if( !IsDefined(level.pers_upgrades[name]) )
	{
		assert( 0, name + " - Persistent upgrade is not registered yet." );
	}

	stats_size = level.pers_upgrades[ name ].stat_names.size;
	level.pers_upgrades[name].stat_names[stats_size] = stat_name;
	level.pers_upgrades[name].stat_desired_values[stats_size] = stat_desired_value;
}


//********************************************************************************************************************
// Updates the status of the persistent upgrades every frame
//
// Incrementing persistent stats example ("pers_boading") 
// - player zm_stats::increment_client_stat( "pers_boarding", false );
//
// Testing if a persistent upgrade has been unlocked (its unlocked when the stat reaches the registered desired value)
//  - if ( IS_TRUE(self.pers_upgrades_awarded["pers_boarding"]) )
//
// Once an upgrade has been achieved the optional registered upgrade function is threaded
// - Upgrades should be removed by logic in the upgrade function
//********************************************************************************************************************

function pers_upgrades_monitor( )
{
	if( !isDefined(level.pers_upgrades) )
	{
		return;
	}
	
	// Only in classic mode
	if( !zm_utility::is_Classic() )
	{
		return;
	}

	// Resets upgrades when game ends
	level thread wait_for_game_end();

	while ( 1 )
	{
		waittillframeend;
		
		players = GetPlayers();
		for ( player_index = 0; player_index < players.size; player_index++ )
		{
			player = players[player_index];
			if ( zm_utility::is_player_valid( player ) &&  isDefined( player.stats_this_frame ) )
			{				
				if ( !player.stats_this_frame.size && !( isdefined( player.pers_upgrade_force_test ) && player.pers_upgrade_force_test ) )
				{
					continue;
				}
			
				for ( pers_upgrade_index = 0; pers_upgrade_index < level.pers_upgrades_keys.size; pers_upgrade_index++ )
				{
					pers_upgrade = level.pers_upgrades[level.pers_upgrades_keys[pers_upgrade_index]];
					
					is_stat_updated = player is_any_pers_upgrade_stat_updated( pers_upgrade );
					if( is_stat_updated )
					{
						should_award = player check_pers_upgrade( pers_upgrade );
						if ( should_award )
						{
							if ( ( isdefined( player.pers_upgrades_awarded[level.pers_upgrades_keys[pers_upgrade_index]] ) && player.pers_upgrades_awarded[level.pers_upgrades_keys[pers_upgrade_index]] ) )
							{
								continue;
							}
	
							player.pers_upgrades_awarded[level.pers_upgrades_keys[pers_upgrade_index]] = true;
							
							// No sound or FX if we are in the beginning of a round
							if( level flag::get( "initial_blackscreen_passed" ) && !( isdefined( player.is_hotjoining ) && player.is_hotjoining ) )
							{
								type = "upgrade";
								
								if ( IsDefined( level.snd_pers_upgrade_force_type ) )
								{
									type = level.snd_pers_upgrade_force_type;
								}
								
								player PlaySoundToPlayer("evt_player_upgrade", player );
								if ( ( isdefined( level.pers_upgrade_vo_spoken ) && level.pers_upgrade_vo_spoken ) )
								{
									player util::delay( 1, undefined, &zm_audio::create_and_play_dialog, "general", type, level.snd_pers_upgrade_force_variant );
								}
								else
								{
									//player util::delay( 1, undefined, &zm_utility::play_vox_to_player, "general",type,level.snd_pers_upgrade_force_variant );
								}
								
								if( IsDefined(player.upgrade_fx_origin) )
								{
									fx_org = player.upgrade_fx_origin;
									// Need to reset it for next use
									player.upgrade_fx_origin = undefined;
								}
								else
								{
									fx_org = player.origin;
									v_dir = anglestoforward( player getplayerangles() );
									v_up = anglestoup( player getplayerangles() );
									fx_org = fx_org + (v_dir * 30 ) + (v_up * 12);			// (v_dir * 10 ) + (v_up * 10)
								}

								Playfx( level._effect["upgrade_aquired"] ,fx_org );

								// Disable a potential Intermission game end
								level thread zm::disable_end_game_intermission( 1.5 );
							}
							
							/#
							player iprintlnbold("Upgraded!");
							#/

							// Activate a function that monitors the upgrade and turns it off when the conditions are met
							if( IsDefined(pers_upgrade.upgrade_active_func) )
							{
								player thread [[pers_upgrade.upgrade_active_func]]();			
							}
						}
						else
						{
							if ( ( isdefined( player.pers_upgrades_awarded[level.pers_upgrades_keys[pers_upgrade_index]] ) && player.pers_upgrades_awarded[level.pers_upgrades_keys[pers_upgrade_index]] ) ) //only play the sound if the player has lost the upgrade
							{
								if( level flag::get( "initial_blackscreen_passed" ) && !( isdefined( player.is_hotjoining ) && player.is_hotjoining ) )
								{
									player PlaySoundToPlayer("evt_player_downgrade",player);
								}
								/#
								player iprintlnbold("Downgraded!");
								#/
							}
							
							//Make sure we dont have the upgrade (we lost it)
							player.pers_upgrades_awarded[level.pers_upgrades_keys[pers_upgrade_index]] = false;
						}
					}
				}

				player.pers_upgrade_force_test = false;
				player.stats_this_frame = [];
			}
		}

		{wait(.05);};
	}
}


//*****************************************************************************
// Resets upgrades when game ends
//*****************************************************************************

function wait_for_game_end()
{
	// Only in classic mode
	if( !zm_utility::is_Classic() )
	{
		return;
	}
	
	level waittill( "end_game" );

	//******************************************************************
	// For each player, test is any persistent upgrades need to be reset
	//******************************************************************

	players = GetPlayers();
	for ( player_index=0; player_index<players.size; player_index++ )
	{
		player = players[player_index];
		
		// Check each upgrade to see if it is active and needs to be reset
		for( index=0; index<level.pers_upgrades_keys.size; index++ )
		{
			// Get the upgrade name
			str_name = level.pers_upgrades_keys[ index ];

			game_end_reset_if_not_achieved = level.pers_upgrades[ str_name ].game_end_reset_if_not_achieved;
			if( IsDefined(game_end_reset_if_not_achieved) && (game_end_reset_if_not_achieved == true) )
			{
				if( !( isdefined( player.pers_upgrades_awarded[ str_name ] ) && player.pers_upgrades_awarded[ str_name ] ) )
				{
					// Reset this for the next game if we did not achieve it
					// We could have multiple stats
					for( stat_index=0; stat_index<level.pers_upgrades[ str_name ].stat_names.size; stat_index++ )
					{
						player zm_stats::zero_client_stat( level.pers_upgrades[str_name].stat_names[stat_index], false );	
					}
				}
			}
		}
	}
}


//*****************************************************************************
//*****************************************************************************

function check_pers_upgrade( pers_upgrade )
{
	should_award = true;
	
//	is_stat_updated = self is_any_pers_upgrade_stat_updated( pers_upgrade );
//	if ( !is_stat_updated )
//	{
//		should_award = false;	
//	}
//	else
//	{
		for ( i = 0; i < pers_upgrade.stat_names.size; i++ )
		{
			stat_name = pers_upgrade.stat_names[i];
			should_award = self check_pers_upgrade_stat( stat_name, pers_upgrade.stat_desired_values[i] );
			if ( !should_award )
			{
				break;
			}
		}
//	}
	
	return should_award;
}


//*****************************************************************************
//*****************************************************************************

function is_any_pers_upgrade_stat_updated( pers_upgrade )
{
	if ( ( isdefined( self.pers_upgrade_force_test ) && self.pers_upgrade_force_test ) )
	{
		return true;
	}

	result = false;
	for ( i = 0; i < pers_upgrade.stat_names.size; i++ )
	{
		stat_name = pers_upgrade.stat_names[i];		
		if ( isDefined( self.stats_this_frame[stat_name] ) )
		{
			result = true;
			break;
		}
	}
	
	return result;
}


//*****************************************************************************
//*****************************************************************************

function check_pers_upgrade_stat( stat_name, stat_desired_value )
{
	should_award = true;
	current_stat_value = self zm_stats::get_global_stat( stat_name );
	if ( current_stat_value < stat_desired_value )
	{
		should_award = false;
	}
			
	return should_award;
}


//*****************************************************************************
// Called for each player when a round ends
//*****************************************************************************

// self = player
function round_end()
{
	// Only in classic mode
	if( !zm_utility::is_Classic() )
	{
		return;
	}

	self notify( "pers_stats_end_of_round" );

	// Increment the max round the player has reached
	if( IsDefined(self.pers["pers_max_round_reached"]) )
	{
		if( level.round_number > self.pers["pers_max_round_reached"] )
		{
			self zm_stats::set_client_stat( "pers_max_round_reached", level.round_number, false );
		}
	}
}


