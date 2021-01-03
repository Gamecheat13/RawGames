    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                 

#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;

#namespace bgb_token;

function autoexec __init__sytem__() {     system::register("bgb_token",&__init__,&__main__,undefined);    }

function private __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	callback::on_connect( &on_player_connect );
	callback::on_disconnect( &on_player_disconnect );
}

function private __main__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	level.bgb_tokens_received_in_session = 0;
	level.a_bgb_token_accumulated_target_score = [];

	// ensure that we update the target score values on round transition, independently of any modifications to normal round structure (keep special enemy rounds from interrupting the calculation)
	level thread update_target_score_on_round_transition();

/#
	level thread setup_devgui();
#/
}

function private on_player_connect()
{	
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}
}

function private on_player_disconnect()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}
}

/#


function private setup_devgui()
{
	waittillframeend;

	SetDvar( "bgb_award_token_devgui", "" );

	bgb_devgui_base = "devgui_cmd \"ZM/BGB/Token";
	AddDebugCommand( bgb_devgui_base + "/Award\" \"set " + "bgb_award_token_devgui" + " 1\" \n");

	level thread bgb_token_devgui_think();
}

function bgb_token_devgui_think()
{
	for( ;; )
	{
		bgb_award_token_dvar = GetDvarString( "bgb_award_token_devgui" );

		if ( bgb_award_token_dvar != "" )
		{
			award_bgb_token_to_team();
		}
		
		SetDvar( "bgb_award_token_devgui", "" );
		
		wait( 0.5 );
	}
}
#/
	
// self = player
// b_play_fanfare - allow for silently giving buff through devgui
function give_bgb_token_to_player( n_bgb_token_count = 1, b_play_fanfare = true )
{
	for( i = 0; i < n_bgb_token_count; i++ )
	{
		self incrementbgbtokensgained(); // add to tokens gained
	}
	
	// TODO play fanfare
	/#
		IPrintLnBold( "GAINED A BGB TOKEN!!!" );
	#/
}

// self = player who instigated the roll
function roll_for_drop()
{
	b_roll_succeeds = false;

	// determine target roll
	if( isdefined( level.bgb_token_drop_override_func ) )
	{
		n_target_pct = [[ level.bgb_token_drop_override_func ]]();
	}
	else
	{
		n_target_pct = get_pct_chance_of_bgb_token_drop();
	}
		
	// roll for success
	n_roll = RandomFloat( 1.0 );
	if( n_roll < n_target_pct )
	{
		b_roll_succeeds = true;
	}

	// award bgb tokens
	if( b_roll_succeeds )
	{
		award_bgb_token_to_team();
	}
}

function award_bgb_token_to_team()
{
	level.bgb_tokens_received_in_session++; // counts as one for the team
	
	/#
		IPrintLn( "AWARDED A BGB TOKEN TO TEAM!!!" );
	#/
	
	foreach( player in level.players )
	{
		player give_bgb_token_to_player(); // give player a token
	}
}



function get_pct_chance_of_bgb_token_drop()
{
	// if we haven't started the first round yet, it's too early to get a bgb token drop
	if( !isdefined( level.bgb_token_weighted_target_score ) )
	{
		return 0;
	}
	
	n_current_scalar = 1 / ( 2.5 * level.bgb_token_weighted_target_score );
	n_target_pct = ( level.score_total * n_current_scalar );
	
	return n_target_pct;
}

// have to update our target score on its own thread, to avoid contamination by special rounds
function update_target_score_on_round_transition()
{
	while( true )
	{
		// update accumulated target score for bgb token drops at the start of each round, to incorporate the current number of active players
		level waittill( "start_of_round" );
		
		// get target round index that we're projecting towards
		n_target_round_index = get_target_round_index_for_bgb_tokens_received( level.bgb_tokens_received_in_session );
		
		// get total projected score for the remaining range of rounds, based on current player count; if we're outside the target round window, then don't do any projection
		n_projected_target_score = 0;
		for( i = ( level.round_number + 1 ); i <= n_target_round_index; i++ )
		{
			n_score_estimate_for_round = get_score_estimate_for_round( i );
			n_projected_target_score += n_score_estimate_for_round;
		}

		// if we are above the target round index,
		// we want to keep collecting the correct accumulated score based on the actual number of players each round,
		// but it shouldn't count towards the weighted target score anymore, so we store each collection window's actual point weighting in its own array index until we need it

		// here, we determine the correct collection window for the current points
		n_collection_window = 0;
		n_target_round_index = get_target_round_index_for_bgb_tokens_received( 0 ); // start from the first window to ensure we get the correct offset into the array
		while( level.round_number > n_target_round_index )
		{
			n_collection_window++;
			n_target_round_index = get_target_round_index_for_bgb_tokens_received( n_collection_window );
		}

		// ensure all windows are defined
		n_max_index = Max( n_collection_window, level.bgb_tokens_received_in_session ); // prevent SRE that could occur when skipping rounds via devgui; probability results won't be valid if devguiing, we just need it to not SRE
		for( i = 0; i <= n_max_index; i++ )
		{
			if( !isdefined( level.a_bgb_token_accumulated_target_score[ i ] ) )
			{
				level.a_bgb_token_accumulated_target_score[ i ] = 0;
			}
		}

		// add the current round's score to the correct collection window
		level.a_bgb_token_accumulated_target_score[ n_collection_window ] += bgb_token::get_score_estimate_for_round( level.round_number );

		// sum the applicable collection windows to get the portion of accumulated score that applies to the current target (base on number of bgb tokens received)
		n_accumulated_target_score = 0;
		for( i = 0; i <= level.bgb_tokens_received_in_session; i++ )
		{
			n_accumulated_target_score += level.a_bgb_token_accumulated_target_score[ i ];
		}
		
		// combine accumulated score 
		level.bgb_token_weighted_target_score = n_accumulated_target_score + n_projected_target_score;
	}
}




function get_target_round_index_for_bgb_tokens_received( n_bgb_tokens_received )
{
	n_target_round_index = 13 + ( n_bgb_tokens_received * 10 );
	return n_target_round_index;
}




function get_score_estimate_for_round( n_round )
{
	n_projected_zombie_count = zm::get_zombie_count_for_round( n_round, level.players.size );
	n_zombie_score_increment_multiplier = Floor( n_round / 10 );
	n_average_score_per_zombie = 200 + ( n_zombie_score_increment_multiplier * 100 );
	n_score_estimate_for_round = n_projected_zombie_count * n_average_score_per_zombie;

	return n_score_estimate_for_round;
}
