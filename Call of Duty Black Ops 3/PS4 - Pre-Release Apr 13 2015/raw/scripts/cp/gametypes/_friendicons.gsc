#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace friendicons;

function autoexec __init__sytem__() {     system::register("friendicons",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_start_gametype( &init );
}
	
function init()
{
	if ( !level.teamBased )
	{
		return;
	}
	
	// Draws a team icon over teammates
	if(GetDvarString( "scr_drawfriend") == "")
	{
		SetDvar("scr_drawfriend", "0");
	}
	
	level.drawfriend = GetDvarint( "scr_drawfriend");

	assert( isdefined(game["headicon_allies"]), "Allied head icons are not defined.  Check the team set for the level.");
	assert( isdefined(game["headicon_axis"]), "Axis head icons are not defined.  Check the team set for the level.");

	callback::on_spawned( &on_player_spawned );
	callback::on_player_killed( &on_player_killed );
	
	for(;;)
	{
		updateFriendIconSettings();
		wait 5;
	}
}

function on_player_spawned()
{
	self endon("disconnect");
	
	self thread showFriendIcon();
}

function on_player_killed()
{
	self endon("disconnect");
	
	self.headicon = "";
}	

function showFriendIcon()
{
	if(level.drawfriend)
	{
		team = self.pers["team"];
		self.headicon = game["headicon_" + team];
		self.headiconteam = team;
	}
}
	
function updateFriendIconSettings()
{
	drawfriend = GetDvarfloat( "scr_drawfriend");
	if(level.drawfriend != drawfriend)
	{
		level.drawfriend = drawfriend;

		updateFriendIcons();
	}
}

function updateFriendIcons()
{
	// for all living players, show the appropriate headicon
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
		{
			if(level.drawfriend)
			{
				team = self.pers["team"];
				self.headicon = game["headicon_" + team];
				self.headiconteam = team;
			}
			else
			{
				players = level.players;
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
	
					if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
						player.headicon = "";
				}
			}
		}
	}
}
