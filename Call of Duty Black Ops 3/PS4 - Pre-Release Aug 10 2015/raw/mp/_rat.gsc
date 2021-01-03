#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\rat_shared;
#using scripts\shared\array_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\_util;
#using scripts\mp\bots\_bot;
#using scripts\mp\gametypes\_dev;

/#
#namespace rat;

function autoexec __init__sytem__() {     system::register("rat",&__init__,undefined,undefined);    }
	
function __init__()
{
	rat_shared::init();
	
	// Set up common function for the shared rat script commands to call
	level.rat.common.gethostplayer = &util::getHostPlayer;
	level.rat.deathCount = 0;
	rat_shared::addRATScriptCmd( "addenemy", &rscAddEnemy );
	SetDvar( "rat_death_count", 0 );

}

function rscAddEnemy( params )
{
	player = [[level.rat.common.gethostplayer]]();
	team = "axis";
	
	if( isdefined( player.pers["team"] ) )
	{
		team = util::getOtherTeam( player.pers["team"] );
	}

	bot = dev::getOrMakeBot( team );
	if ( !isdefined( bot ) ) {
		println("Could not add test client");
		RatReportCommandResult( params._id, 0, "Could not add test client" );
		return;
	}
	
	bot thread TestEnemy( team );
	bot thread DeathCounter();
	
	// waiting for bot to respawn
	wait 2;
	
	pos = ( Float(params.x), Float(params.y), Float(params.z) );
	bot SetOrigin(pos);

	if( isdefined( params.ax ) )
	{
		angles = ( Float(params.ax), Float(params.ay), Float(params.az) );
		bot SetPlayerAngles(angles);
	}
	
	RatReportCommandResult( params._id, 1 );
}

function TestEnemy(team) // self == test client
{
	self endon( "disconnect" );
	
	while(!isdefined(self.pers["team"]))
		wait .05;
	
	if ( level.teambased )
	{
		self notify("menuresponse", game["menu_team"], team);
	}
}

function DeathCounter()
{
	self waittill("death");
	level.rat.deathCount++;
	SetDvar( "rat_death_count", level.rat.deathCount );
}

#/	



