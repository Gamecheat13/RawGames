#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_death;

#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

                                                                
                                                                                                                               



#precache( "string", "ZOMBIE_POWERUP_MAX_AMMO" );

#namespace zm_powerup_carpenter;

function autoexec __init__sytem__() {     system::register("zm_powerup_carpenter",&__init__,undefined,undefined);    }

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "carpenter", &grab_carpenter );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "carpenter", "p7_zm_power_up_carpenter", &"ZOMBIE_POWERUP_MAX_AMMO", &func_should_drop_carpenter, !true, !true, !true );
	}
	
	level.use_new_carpenter_func = &start_carpenter_new;
}

function grab_carpenter( player )
{	
	// Check for the carpenter persistent upgrade
	if( zm_utility::is_Classic() )
	{
		player thread zm_pers_upgrades::persistent_carpenter_ability_check();
	}
	if( isDefined(level.use_new_carpenter_func) )
	{
		level thread [[level.use_new_carpenter_func]](self.origin);
	}
	else
	{
		level thread start_carpenter( self.origin );
	}
	player thread zm_powerups::powerup_vo( "carpenter" );
}

function start_carpenter( origin )
{
	window_boards = struct::get_array( "exterior_goal", "targetname" ); 
	total = level.exterior_goals.size;
	
	//COLLIN
	carp_ent = spawn("script_origin", (0,0,0));
	carp_ent playloopsound( "evt_carpenter" );
	
	while(true)
	{
		windows = get_closest_window_repair(window_boards, origin);
		if( !IsDefined( windows ) )
		{
			carp_ent stoploopsound( 1 );
			carp_ent PlaySoundWithNotify( "evt_carpenter_end", "sound_done" );
			carp_ent waittill( "sound_done" );
			break;
		}		
		else
		{
			ArrayRemoveValue(window_boards, windows);
		}


		while( 1 )
		{
			if( zm_utility::all_chunks_intact( windows, windows.barrier_chunks ) )
			{
				break;
			}

			chunk = zm_utility::get_random_destroyed_chunk( windows, windows.barrier_chunks );

			if( !IsDefined( chunk ) )
			{
				break;
			}

			windows thread zm_blockers::replace_chunk( windows, chunk, undefined, zm_powerups::is_carpenter_boards_upgraded(), true );
			
			if(isdefined(windows.clip))
			{
				windows.clip TriggerEnable( true );
				windows.clip DisconnectPaths();
			}
			else
			{
				zm_blockers::blocker_disconnect_paths(windows.neg_start, windows.neg_end);
			}
			util::wait_network_frame();
			{wait(.05);};
		}
		 
		util::wait_network_frame();
	}
	
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] zm_score::player_add_points( "carpenter_powerup", 200 );
	}
	
	carp_ent delete();	
}

function get_closest_window_repair( windows, origin )
{
	current_window = undefined;
	shortest_distance = undefined;
	for( i = 0; i < windows.size; i++ )
	{
		if( zm_utility::all_chunks_intact(windows, windows[i].barrier_chunks ) )
		{
			continue;
		}

		if( !IsDefined( current_window ) )	
		{
			current_window = windows[i];
			shortest_distance = DistanceSquared( current_window.origin, origin );			
		}
		else
		{
			if( DistanceSquared(windows[i].origin, origin) < shortest_distance )
			{

				current_window = windows[i];
				shortest_distance =  DistanceSquared( windows[i].origin, origin );
			}
		}
	}

	return current_window;
}

function start_carpenter_new( origin )
{
	level.carpenter_powerup_active = true;

	window_boards = struct::get_array( "exterior_goal", "targetname" ); 
	
	if(isdefined(level._additional_carpenter_nodes))
	{
		window_boards = ArrayCombine(window_boards, level._additional_carpenter_nodes, false, false);
	}
	
	//COLLIN
	carp_ent = spawn("script_origin", (0,0,0));
	carp_ent playloopsound( "evt_carpenter" );	
	
	boards_near_players = get_near_boards(window_boards);
	boards_far_from_players = get_far_boards(window_boards);	
	
	//instantly repair all 'far' boards
	level repair_far_boards( boards_far_from_players, zm_powerups::is_carpenter_boards_upgraded() );

	for(i=0;i<boards_near_players.size;i++)
	{
		window = boards_near_players[i];
		
		num_chunks_checked = 0;
		
		last_repaired_chunk = undefined;
		
		while( 1 )
		{
			if( zm_utility::all_chunks_intact( window, window.barrier_chunks ) )
			{
				break;
			}

			chunk = zm_utility::get_random_destroyed_chunk( window, window.barrier_chunks ); 

			if( !IsDefined( chunk ) )
				break;

			window thread zm_blockers::replace_chunk( window, chunk, undefined, zm_powerups::is_carpenter_boards_upgraded(), true );
			
			last_repaired_chunk = chunk;
			
			if(IsDefined(window.clip))
			{
				window.clip TriggerEnable( true ); 
				window.clip DisconnectPaths();
			}
			else
			{
				zm_blockers::blocker_disconnect_paths(window.neg_start, window.neg_end);
			}
			
			util::wait_network_frame();
			
			num_chunks_checked++;
			
			if(num_chunks_checked >= 20)
			{
				break;	// Avoid staying in this while loop forever....
			}
		}
		
		//wait for the last window board to be repaired
		
		if(isdefined(window.zbarrier))
		{
			if(isdefined(last_repaired_chunk))
			{
				while(window.zbarrier GetZBarrierPieceState(last_repaired_chunk) == "closing")
				{
					{wait(.05);};
				}
				
				if(isdefined(window._post_carpenter_callback))
				{
					window [[window._post_carpenter_callback]]();
				}
			}
		}
		else
		{
			while((IsDefined(last_repaired_chunk)) && (last_repaired_chunk.state == "mid_repair"))
			{
				wait(.05);
			}
		}
	}
	
	carp_ent stoploopsound( 1 );
	carp_ent PlaySoundWithNotify( "evt_carpenter_end", "sound_done" );
	carp_ent waittill( "sound_done" );

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] zm_score::player_add_points( "carpenter_powerup", 200 ); 
	}

	carp_ent delete();

	level notify( "carpenter_finished" );
	level.carpenter_powerup_active = undefined;
}

function get_near_boards(windows)
{
	// get all boards that are farther than 500 units away from any player and put them into a list
	players = GetPlayers();
	boards_near_players = [];
	
	for(j =0;j<windows.size;j++)
	{
		close = false;
		for(i=0;i<players.size;i++)
		{
			origin = undefined;
			
			if(isdefined(windows[j].zbarrier))
			{
				origin = windows[j].zbarrier.origin;
			}
			else
			{
				origin = windows[j].origin;
			}
			
			if( distancesquared(players[i].origin, origin) <= 750 * 750  )
			{
				close = true;
				break;
			}
		}
		if(close)
		{
			boards_near_players[boards_near_players.size] = windows[j];
		}			
	}
	return boards_near_players;
}

function get_far_boards(windows)
{
	// get all boards that are farther than 500 units away from any player and put them into a list
	players = GetPlayers();
	boards_far_from_players = [];
	
	for(j =0;j<windows.size;j++)
	{
		close = false;
		for(i=0;i<players.size;i++)
		{
			
			origin = undefined;
			
			if(isdefined(windows[j].zbarrier))
			{
				origin = windows[j].zbarrier.origin;
			}
			else
			{
				origin = windows[j].origin;
			}			
			
			if( distancesquared(players[i].origin, origin) >= 750 * 750  )
			{
				close = true;
				break;
			}
		}
		
		if(close)
		{
			boards_far_from_players[boards_far_from_players.size] = windows[j];
		}			
	}
	return boards_far_from_players;
}

function repair_far_boards( barriers, upgrade )
{
	for(i=0;i<barriers.size;i++)
	{
		barrier = barriers[i];
		if( zm_utility::all_chunks_intact( barrier, barrier.barrier_chunks ) )
		{
			continue;
		}

		if(isdefined(barrier.zbarrier))
		{
			a_pieces = barrier.zbarrier GetZBarrierPieceIndicesInState( "open" );
			if( IsDefined(a_pieces) )
			{
				for( xx=0; xx<a_pieces.size; xx++ )
				{
					chunk = a_pieces[ xx ];

					if(upgrade)
					{
						barrier.zbarrier ZBarrierPieceUseUpgradedModel(chunk);
						barrier.zbarrier.chunk_health[chunk] = barrier.zbarrier GetUpgradedPieceNumLives(chunk);
					}
					else
					{
						barrier.zbarrier ZBarrierPieceUseDefaultModel(chunk);
						barrier.zbarrier.chunk_health[chunk] = 0;
					}
				}
			}

			for(x = 0; x < barrier.zbarrier GetNumZBarrierPieces(); x ++)
			{
				barrier.zbarrier SetZBarrierPieceState(x, "closed");
				barrier.zbarrier ShowZBarrierPiece(x);
			}
		}
		
		if(IsDefined(barrier.clip))
		{
			barrier.clip TriggerEnable( true ); 
			barrier.clip DisconnectPaths();
		}
		else
		{
			zm_blockers::blocker_disconnect_paths(barrier.neg_start, barrier.neg_end);
		}			
		
		if((i % 4) == 0)
		{
			util::wait_network_frame();
		}		
	}
}

function func_should_drop_carpenter()
{
	if(get_num_window_destroyed() < 5 )
	{
		return false;
	}
	return true;
}

function get_num_window_destroyed()
{
	num = 0;
	for( i = 0; i < level.exterior_goals.size; i++ )
	{
		/*targets = getentarray(level.exterior_goals[i].target, "targetname");

		barrier_chunks = []; 
		for( j = 0; j < targets.size; j++ )
		{
			if( IsDefined( targets[j].script_noteworthy ) )
			{
				if( targets[j].script_noteworthy == "clip" )
				{ 
					continue; 
				}
			}

			barrier_chunks[barrier_chunks.size] = targets[j];
		}*/


		if( zm_utility::all_chunks_destroyed( level.exterior_goals[i], level.exterior_goals[i].barrier_chunks ) )
		{
			num += 1;
		}

	}

	return num;
}
