#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#using scripts\cp\_util;

#using scripts\cp\sm\_sm_ui;
#using scripts\cp\sm\_sm_round_base;
#using scripts\cp\sm\_sm_round_scavenger;
#using scripts\cp\sm\_sm_round_survival;
#using scripts\cp\sm\_sm_round_beacon;
#using scripts\cp\sm\_sm_round_boss;
#using scripts\cp\sm\_sm_round_objective;
#using scripts\cp\sm\_sm_scavenger;

#using scripts\cp\gametypes\_persistence;
#using scripts\cp\gametypes\_globallogic;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                   	       	     	          	      	                                                                                            	                                                           	                                  



#namespace side_mission;

function autoexec __init__sytem__() {     system::register("sm_round_manager",&__init__,&__main__,undefined);    }

function __init__()
{
	clientfield::register( "world", "sm_round", 1, 4, "int" );
}

function __main__()
{
	level.o_sm_objective_manager = new cSMObjectiveManager();
	
	thread [[level.o_sm_objective_manager]]->main();  // __main__() can't contain waits, so thread this
}


//
//	Returns the current round number
function get_round_number()
{
	return [[level.o_sm_objective_manager]]->get_round_number();
}

// Returns the current type of the round (SM_ROUND_TYPE_*)
function get_round_type()
{
	return [[level.o_sm_objective_manager]]->get_round_type();
}

function may_player_spawn()
{
	if ( ( isdefined( level.inPrematchPeriod ) && level.inPrematchPeriod ) )
		return true;
	
	return [[level.o_sm_objective_manager]]->may_player_spawn( self );
}

function mission_success()
{
	globallogic::endGame( "allies" );
}

// Returns the current type of the round (SM_ROUND_TYPE_*)
function on_end_game( winner )
{
	success = false;
	
	// need a better way to determine if the players won
	if ( winner == "allies" )
		success = true;
	
	thread [[level.o_sm_objective_manager]]->on_end_game( success );
}

/#  // DEV FUNCTIONALITY
	function complete_current_round()
{
	o_current_round = level.o_sm_objective_manager.m_o_current_round;
	
	if ( IsDefined( o_current_round ) )
	{
		o_current_round _complete_current_round();
	}
}

function _complete_current_round()  // self = current round object
{
	[[self]]->wait_till_round_started();
	
	[[self]]->dev_clean_up_round();
	
	[[self]]->wait_till_round_finished();	
}
#/

class cSMObjectiveManager
{
	var m_a_objective_flow;
	var m_a_objective_types;
	var m_n_round;
	var m_o_current_round;
	
	constructor()
	{
		// register all valid objective types and their corresponding function pointers
		m_a_objective_types = [];
		m_n_round = 0;
		
		register_objective_type( "activate_beacon", 		&sm_round_beacon::main );
		register_objective_type( "survival_first_round", 	&sm_round_survival::first_round );
		register_objective_type( "survival", 				&sm_round_survival::main );
		register_objective_type( "scavenger",		&sm_round_scavenger::main );
		register_objective_type( "boss", 					&sm_round_boss::main );
		register_objective_type( "objective", 				&sm_round_objective::main );
			
		// register objective flow
		add_round( "activate_beacon" );			// round 0
		add_round( "survival_first_round" );	// round 1
		add_round( "survival" );				// round 2
		add_round( "objective" );				// round 3
		add_round( "boss" );					// round 4
		add_round( "scavenger" );		// round 5
		add_round( "survival" );				// round 6
		add_round( "objective" );				// round 7
		add_round( "survival" );				// round 8
		add_round( "survival" );				// round 9
		add_round( "boss" );				// round 10
		
		// validate objective list
		str_valid_objective_list = "";
		a_keys = GetArrayKeys( m_a_objective_types );
		
		for ( i = 0; i < a_keys.size; i++ )
		{
			str_valid_objective_list += "\n" + a_keys[ i ];
		}
		
		foreach ( str_objective in m_a_objective_flow )
		{
			Assert( IsDefined( m_a_objective_types[ str_objective ] ), str_objective + " is not a supported objective type. The valid objective types are: " + str_valid_objective_list );
		}
		
		// clear debug settings
		/#
			SetDvar( "sidemission_force_next_round", -1 );
			SetDvar( "sidemission_force_round", -1 );	
		#/
	}
	
	destructor()
	{
		
	}
	
	function main()
	{		
		// wait until prematch period is done
		wait_for_prematch_end();		
		wait_for_player_spawn();
		
		/#
			self thread round_skipto_think();
		#/	
		
		// objective flow
		for ( m_n_round = 0; m_n_round < m_a_objective_flow.size; m_n_round++ )
		{
			/# 
				n_round = GetDvarInt( "sidemission_force_round" );
			
				if ( IsDefined( n_round ) && ( n_round > -1 ) )
				{
					m_n_round = n_round;
					
					SetDvar( "sidemission_force_round", -1 );  // only do this once
				}
			#/			
			
			level clientfield::set( "sm_round", m_n_round );
			str_objective = m_a_objective_flow[ m_n_round ];
			
			o_objective = [[ m_a_objective_types[ str_objective ] ]]();
			
			m_o_current_round = o_objective;
			
			[[o_objective]]->set_round_number( m_n_round );  // alters Round # text
			
			[[o_objective]]->round_start();  // plays splash screen
			
			[[o_objective]]->main();  // main round logic
			
			[[o_objective]]->round_end();
			
			respawn_spectators();
			
			wait 3;
		}
		
		side_mission::mission_success();
	}
	
	function on_end_game( success )
	{
		if ( IsDefined( m_o_current_round ) )
		{
			[[m_o_current_round]]->on_end_game( success );
		}
		
		sm_ui::on_end_game( success );
	}
	
	function may_player_spawn( player )
	{
		if ( !IsDefined( m_o_current_round ) )
		{
			return true;
		}
		
		if ( !sm_round_beacon::is_beacon_active() && IsDefined( player.deathcount ) && ( player.deathcount == 0 ) )
		{
			return true;
		}
		
		if ( m_o_current_round flag::get( "round_started" ) )
		{
			return false;
		}
		
		return true;
	}
	
	function wait_for_prematch_end()
	{
		level waittill("prematch_over");
	}
	
	function wait_for_player_spawn()
	{
		do 
		{
			{wait(.05);};
			
			n_players_spawned = 0;
			
			foreach ( player in level.players )
			{
				if ( ( player.sessionstate === "playing" ) )
				{
					n_players_spawned++;
				}
			}
		}
		while ( n_players_spawned == 0 );
	}
	
	function register_objective_type( str_objective, func_objective )
	{
		Assert( !IsDefined( m_a_objective_types[ str_objective ] ), "cSMObjectiveManager: " + str_objective + " has already been registered! Objectives should only be registered once." );
		
		m_a_objective_types[ str_objective ] = func_objective;
	}
	
	function respawn_spectators()
	{
		level notify( "sm_respawn_spectators" );
	}
	
	function get_round_number()
	{
		return m_n_round;
	}
	
	function get_round_type()
	{
		return m_a_objective_flow[m_n_round];
	}

	function add_round( str_type )
	{
		if ( !IsDefined( m_a_objective_flow ) )
		{
			m_a_objective_flow = [];
		}
		
		/#
			str_label = m_a_objective_flow.size + "-" + str_type + ":" + m_a_objective_flow.size;
			AddDebugCommand( "devgui_cmd \"SideMission/Round/Set Round/" + str_label + "\" \"set sidemission_force_next_round " + m_a_objective_flow.size + "\"\n" ); 
		#/
		
		if ( !isdefined( m_a_objective_flow ) ) m_a_objective_flow = []; else if ( !IsArray( m_a_objective_flow ) ) m_a_objective_flow = array( m_a_objective_flow ); m_a_objective_flow[m_a_objective_flow.size]=str_type;;
	}	
	
	function round_skipto_think()
	{
		wait 1;  // let starting round begin before trying to skip ahead
		
		while ( true )
		{
			n_round = GetDvarInt( "sidemission_force_next_round" );
			
			if ( IsDefined( n_round ) && ( n_round > 0 ) && ( m_n_round != n_round ) )
			{				
				if ( IsDefined( m_o_current_round ) )
				{
					m_o_current_round side_mission::_complete_current_round();
				}
				
				SetDvar( "sidemission_force_next_round", -1 );
				SetDvar( "sidemission_force_round", n_round );
			}
			
			wait 1;
		}
	}	
}
