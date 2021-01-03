#using scripts\codescripts\struct;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;

                                               	               	               	                	                                                               

#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\_bot;

#using scripts\zm\_zm_weapons;

//Must match code (hkai_influence.h)
	//bullet impacts
	//ai positions
	//player positions






#namespace zm_bot;

function autoexec __init__sytem__() {     system::register("zm_bot",&__init__,undefined,undefined);    }

function __init__()
{
	bot::init_shared();

/#
	level thread watch_bot_connect();
#/

/#	PrintLn( "ZM >> Zombiemode Server Scripts Init (_zm_bot.gsc)" );	#/
/#		
	thread debug_coop_bot_test();
#/		
}

/#		
function debug_coop_bot_test()
{
    botCount = 0;
    
    AddDebugCommand( "set bot_AllowMovement 1; set bot_PressAttackBtn 1; set bot_PressMeleeBtn 1; set scr_botsAllowKillstreaks 0; set bot_AllowGrenades 1" );
    
    while ( true )
    {
    	if ( GetDvarInt( "debug_coop_bot_joinleave" ) > 0 )
    	{
		    while ( GetDvarInt( "debug_coop_bot_joinleave" ) > 0 )
		    {
		        if ( botCount > 0 && RandomInt( 100 ) > 60 )
		        {
		            AddDebugCommand( "set devgui_bot remove" );
		            botCount--;
		            DebugMsg( "Bot is being removed.   Count=" + botCount );
		        }
		        else if ( botCount < GetDvarInt( "debug_coop_bot_joinleave" ) && RandomInt( 100 ) > 50 )
		        {
		            AddDebugCommand( "set devgui_bot add" );
		            botCount++;
		            DebugMsg( "Bot is being added.  Count=" + botCount );
		        }
		     
		        wait RandomIntRange( 1, 3 );
		    }
    	}
    	else
    	{
    		//remove any bots that are left after this is turned off
    		while ( botCount > 0 )
    		{
    			AddDebugCommand( "set devgui_bot remove" );
		        botCount--;
		        DebugMsg( "Bot is being removed.   Count=" + botCount );
		        
		        wait 1; // delay the disconnections
    		}
    	}
    	
    	wait 1; // occasionally check the dvar
    }
}

#/		
	
function debugMsg( str_txt )
{
    /#
        IPrintLnBold( str_txt );
	    if ( isdefined( level.name ) ) //not defeind for testmaps
	    {
     		PrintLn( "[" + level.name + "] " + str_txt );
	    }
    #/
}


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
		self thread bot_main( bot::get_host_player() );
	}
}


function bot_main( host )
{
	self endon( "death" );

	self thread bot_loadout(host); 
	
	for ( ;; )
	{
		self bot_combat::combat_think( undefined );

		self bot_update_goal( host );
		self bot_update_lookat( host );
		self bot_update_revive( host );

		{wait(.05);};
	}
}

function bot_loadout( host )
{
	wait 1; 
	if ( IsDefined( host ) && IsDefined( self ) )
	{
		loadout = host zm_weapons::player_get_loadout();
		self zm_weapons::player_give_loadout( loadout );
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
		enemy = bot::get_closest_enemy( self.origin );

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




