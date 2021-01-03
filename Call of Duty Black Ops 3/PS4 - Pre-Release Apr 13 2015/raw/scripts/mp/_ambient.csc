#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\teams\_teams;

#namespace arena;

function autoexec __init__sytem__() {     system::register("arena",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_connect( &on_connect );
}

function on_connect()
{
	if( isdefined( self.pers["arenaInit"] ) && self.pers["arenaInit"] == 1 )
		return;

	self ArenaBeginMatch();
	self.pers["arenaInit"] = 1;
}

function match_end( winner )
{
	for( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];

		if( isdefined( player.pers["arenaInit"] ) && player.pers["arenaInit"] == 1 )
		{
			if( winner == "tie" )
			{
				player ArenaEndMatch( 0 );
			}
			else if( winner == player.pers["team"] )
			{
				player ArenaEndMatch( 1 );
			}
			else
			{
				player ArenaEndMatch( -1 );
			}
		}
	}		
}


