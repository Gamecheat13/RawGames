#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                               	               	               	                	                                                               

#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\_bot;

#namespace bot;

function autoexec __init__sytem__() {     system::register("bot",&__init__,undefined,undefined);    }
	
function __init__()
{
	bot::init_shared();
/#
	level thread watch_bot_connect();
#/
}

/#
	
function watch_bot_connect()
{
	level endon(" game_ended" );
	
	while(1)
	{
		level waittill ("connected", player );
		if ( player IsTestclient() )	
		{
			player thread watch_bot_spawn();
		}
	}
}

function watch_bot_spawn()
{
	self endon( "disconnect" );
	
	while(1)
	{
		self waittill( "spawned_player" );
		self thread bot_main( get_host_player() );
	}
}


function bot_main( host )
{
	self endon( "death" );

	for ( ;; )
	{
		self bot_combat::combat_think( undefined );

		self bot_update_goal( host );
		self bot_update_lookat( host );
		self bot_update_revive( host );

		{wait(.05);};
	}
}



function bot_update_goal( player )
{
	if ( !IsAlive( player ) )
	{
		self CancelGoal( "wander" );
		return;
	}
	
	distSq = Distance2DSquared( self.origin, player.origin );
	
	if ( isdefined( self.botGoalRadius ) && distSq < self.botGoalRadius * self.botGoalRadius )
	{
		self CancelGoal( "wander" );
		return;
	}
	else if ( isdefined( self.botLastGoal ) )
	{
		goalDistSq = Distance2DSquared( player.origin, self.botLastGoal );
		
		newGoalDist = ( 24 * 10 );
		
		if ( goalDistSq < ( newGoalDist * newGoalDist ) )
		{
			return;	
		}
	}

	self.botGoalRadius = 24 * RandomFloatRange( 5, 10 );
	self.botLastGoal = player.origin;
	
	self AddGoal( self.botLastGoal, self.botGoalRadius, 1, "wander" );
}

function bot_update_lookat( player )
{
	if ( GetTime() > self.bot.update_idle_lookat )
	{
		self ClearLookAt();
		enemy = get_closest_enemy( self.origin );

		if ( IsDefined( enemy ) )
		{
			self LookAt( enemy GetEye() );
		}
		else if ( RandomInt( 100 ) < 30 )
		{
			self LookAt( player.origin );
		}

		self.bot.update_idle_lookat = GetTime() + RandomIntRange( 1500, 3000 );
	}
}

function bot_update_revive( player )
{
	if ( self AtGoal( "revive" ) && player laststand::player_is_in_laststand() )
	{
		self LookAt( player.origin );
		wait( 0.5 );

		self PressUseButton( 3.5 );
		wait( 3.5 );
		self CancelGoal( "revive" );
	}
	else if ( player laststand::player_is_in_laststand() )
	{
		self AddGoal( player.origin, 64, 4, "revive" );
	}
	else
	{
		self CancelGoal( "revive" );
	}
}
	
#/