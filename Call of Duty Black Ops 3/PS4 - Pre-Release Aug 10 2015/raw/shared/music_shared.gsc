#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace music;

function autoexec __init__sytem__() {     system::register("music",&__init__,undefined,undefined);    }

function __init__()
{
	level.musicState = "";
	util::registerClientSys("musicCmd");
}

function setMusicState(state, player)
{
	if( ( SessionModeIsCampaignZombiesGame() ) )
	{
		state = "zm_"+state;
	}

	if (isdefined(level.musicState))
	{
		if( isdefined( player ) )
		{
				util::setClientSysState("musicCmd", state, player );
				//println ( "Music cl Number " + player getEntityNumber() );
				return;
		}
		else if(level.musicState != state)
		{
				util::setClientSysState("musicCmd", state );
		}
	}
	level.musicState = state;
}
