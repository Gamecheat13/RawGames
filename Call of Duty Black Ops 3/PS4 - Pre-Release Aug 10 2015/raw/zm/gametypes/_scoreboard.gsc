#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace scoreboard;

function autoexec __init__sytem__() {     system::register("scoreboard",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &main );
}

function main()
{
	SetDvar("g_ScoresColor_Spectator", ".25 .25 .25");
	SetDvar("g_ScoresColor_Free", ".76 .78 .10");

	SetDvar("g_teamColor_MyTeam", ".4 .7 .4" );	
	SetDvar("g_teamColor_EnemyTeam", "1 .315 0.35" );	
	SetDvar("g_teamColor_MyTeamAlt", ".35 1 1" ); //cyan
	SetDvar("g_teamColor_EnemyTeamAlt", "1 .5 0" ); //orange	

	SetDvar("g_teamColor_Squad", ".315 0.35 1" );

	if ( SessionModeIsZombiesGame() )
	{
		SetDvar( "g_TeamIcon_Axis", "faction_cia" );
		SetDvar( "g_TeamIcon_Allies", "faction_cdc" );
	}
	else
	{
		SetDvar( "g_TeamIcon_Axis", game["icons"]["axis"] );
		SetDvar( "g_TeamIcon_Allies", game["icons"]["allies"] );
		// TODO MTEAM - setup the team icons for team3-8
	}
}
