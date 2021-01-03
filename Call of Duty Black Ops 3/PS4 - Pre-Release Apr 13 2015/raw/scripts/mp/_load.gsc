#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

    

#namespace medals;

function autoexec __init__sytem__() {     system::register("medals",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
}

function init()
{
	level.medalInfo = [];
	level.medalCallbacks = [];
	level.numKills = 0;	
	
	callback::on_connect( &on_player_connect );
}

function on_player_connect()
{
	self.lastKilledBy = undefined;
}

function setLastKilledBy( attacker )
{
	self.lastKilledBy = attacker;
}

function offenseGlobalCount()
{
	level.globalTeamMedals++;
}

function defenseGlobalCount()
{
	level.globalTeamMedals++;
}

function CodeCallback_Medal( medalIndex )
{
	self LUINotifyEvent( &"medal_received", 1, medalIndex );	
	self LUINotifyEventToSpectators( &"medal_received", 1, medalIndex );
}
