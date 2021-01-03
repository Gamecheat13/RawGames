#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace spectating;

function autoexec __init__sytem__() {     system::register("spectating",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
	callback::on_spawned( &set_permissions );
	callback::on_joined_team( &set_permissions_for_machine );
	callback::on_joined_spectate( &set_permissions_for_machine );
}

function init()
{
	foreach( team in level.teams )
	{
		level.spectateOverride[team] = spawnstruct();
	}
}

function update_settings()
{
	level endon ( "game_ended" );
	
	for ( index = 0; index < level.players.size; index++ )
		level.players[index] set_permissions();
}


function get_splitscreen_team()
{
	for ( index = 0; index < level.players.size; index++ )
	{
		if ( !isdefined(level.players[index]) )
			continue;
			
		if ( level.players[index] == self )
			continue;
			
		if ( !(self IsPlayerOnSameMachine( level.players[index] )) )
			continue;
			
		team = level.players[index].sessionteam;

		// going to assume first non-spectator 
		if ( team != "spectator" )
			return team;
	}
	
	return self.sessionteam;
}

function other_local_player_still_alive()
{
	for ( index = 0 ; index < level.players.size ; index++ )
	{
		if ( !isdefined( level.players[index] ) )
			continue;
			
		if ( level.players[index] == self )
			continue;
			
		if ( !( self IsPlayerOnSameMachine( level.players[index] ) ) )
			continue;
		
		if ( IsAlive( level.players[index] ) )
			return true;
	}
	
	return false;
}

function allow_all_teams( allow )
{
	foreach( team in level.teams )
	{
		self allowSpectateTeam( team, allow );
	}
}

function allow_all_teams_except( skip_team, allow )
{
	foreach( team in level.teams )
	{
		if ( team == skip_team )
			continue;
		self allowSpectateTeam( team, allow );
	}
}

function set_permissions()
{
	team = self.sessionteam;
	
	if ( team == "spectator" )
	{
		// in online splitscreen we are only going to allow spectators to 
		// spectate the team of the other player on splitscreen
		if ( self IsSplitScreen() && !level.splitscreen )
		{
			team = get_splitscreen_team();
		}
			
		if ( team == "spectator" )
		{
			self allow_all_teams( true );
			self allowSpectateTeam( "freelook", false );
			self allowSpectateTeam( "none", true );
			self allowSpectateTeam( "localplayers", true );
			return;
		}
	}
	
	spectateType = level.spectateType;
	
	switch( spectateType )
	{
		case 0: // disabled
			self allow_all_teams( false );
			self allowSpectateTeam( "freelook", false );
			self allowSpectateTeam( "none", true );
			self allowSpectateTeam( "localplayers", false );
			break;
		case 3: // team only - strict splitscreen
			// player can only spectate other local players
			if ( self IsSplitScreen() && self other_local_player_still_alive() )
			{
				self allow_all_teams( false );
				self allowSpectateTeam( "none", false );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "localplayers", true );
				break;
			}
			// fall through
		case 1: // team only
			if ( !level.teamBased )
			{
				self allow_all_teams( true );
				self allowSpectateTeam( "none", true );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "localplayers", true );
			}
			else if ( isdefined( team ) && isdefined( level.teams[team] ) )
			{
				self allowSpectateTeam( team, true );
				self allow_all_teams_except( team , false );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "none", false );
				self allowSpectateTeam( "localplayers", true );
			}
			else
			{
				self allow_all_teams( false );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "none", false );
				self allowSpectateTeam( "localplayers", true );
			}
			break;
		case 2: // free
			self allow_all_teams( true );
			self allowSpectateTeam( "freelook", true );
			self allowSpectateTeam( "none", true );
			self allowSpectateTeam( "localplayers", true );
			break;
	}
	
	if ( isdefined( team ) && isdefined( level.teams[team] ) )
	{
		if ( isdefined(level.spectateOverride[team].allowFreeSpectate) )
			self allowSpectateTeam( "freelook", true );
		
		if (isdefined(level.spectateOverride[team].allowEnemySpectate))
			self allow_all_teams_except( team, true );
	}
}

function set_permissions_for_machine()
{
//	error
	
	self set_permissions();
	
	if ( !self IsSplitScreen() )
		return;

	for ( index = 0; index < level.players.size; index++ )
	{
		if ( !isdefined(level.players[index]) )
			continue;
			
		if ( level.players[index] == self )
			continue;
			
		if ( !(self IsPlayerOnSameMachine( level.players[index] )) )
			continue;
		
		level.players[index] set_permissions();
	}
}