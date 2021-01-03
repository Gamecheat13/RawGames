#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_globallogic_ui;
#using scripts\mp\gametypes\_persistence;
#using scripts\mp\gametypes\_spectating;

#using scripts\mp\_util;

#precache( "material", "mpflag_spectator" );
#precache( "string", "MP_AUTOBALANCE_NOW" );

#namespace teams;

function autoexec __init__sytem__() {     system::register("teams",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
	
	level.getEnemyTeam = &getEnemyTeam;
}

function init()
{
	game["strings"]["autobalance"] = &"MP_AUTOBALANCE_NOW";

	if(GetDvarString( "scr_teambalance") == "")
		SetDvar("scr_teambalance", "0");
	level.teambalance = GetDvarint( "scr_teambalance");
	level.teambalancetimer = 0;
	
	if(GetDvarString( "scr_timeplayedcap") == "")
		SetDvar("scr_timeplayedcap", "1800");
	level.timeplayedcap = int(GetDvarint( "scr_timeplayedcap"));

	level.freeplayers = [];

	if( level.teamBased )
	{
		level.alliesplayers = [];
		level.axisplayers = [];

		callback::on_connect( &on_player_connect );
		callback::on_joined_team( &on_joined_team );
		callback::on_joined_spectate( &on_joined_spectators );
		level thread update_balance_dvar();
	
		wait .15;
		if ( level.rankedMatch || level.leagueMatch )
		{
			level thread update_player_times();
		}
	}
	else
	{
		callback::on_connect( &on_free_player_connect );
	
		wait .15;
		if ( level.rankedMatch || level.leagueMatch )
		{
			level thread update_player_times();
		}
	}
}

function on_player_connect()
{
	self thread track_played_time();
}

function on_free_player_connect()
{
	self thread track_free_played_time();
}

function on_joined_team()
{
	/#println( "joined team: " + self.pers["team"] );#/
	self update_time();
}

function on_joined_spectators()
{
	self.pers["teamTime"] = undefined;
}

function track_played_time()
{
	self endon( "disconnect" );

	foreach ( team in level.teams )
	{
		self.timePlayed[team] = 0;
	}
	self.timePlayed["free"] = 0;
	self.timePlayed["other"] = 0;
	self.timePlayed["alive"] = 0;

	// dont reset time played in War when going into final fight, this is used for calculating match bonus
	if ( !isdefined( self.timePlayed["total"] ) || !( (level.gameType == "twar") && (0 < game["roundsplayed"]) && (0 < self.timeplayed["total"]) ) )
		self.timePlayed["total"] = 0;
	
	while ( level.inPrematchPeriod )
		{wait(.05);};

	for ( ;; )
	{
		if ( game["state"] == "playing" )
		{
			if ( isdefined( level.teams[self.sessionteam] ) )
			{
				self.timePlayed[self.sessionteam]++;
				self.timePlayed["total"]++;
				
				if ( level.mpCustomMatch )
				{
					self.pers["sbtimeplayed"] = self.timeplayed["total"];
					self.sbtimeplayed = self.pers["sbtimeplayed"];
				}
				
				if ( IsAlive( self ) )
					self.timePlayed["alive"]++;
			}
			else if ( self.sessionteam == "spectator" )
			{
				self.timePlayed["other"]++;
			}	
		}
		
		wait ( 1.0 );
	}
}


function update_player_times()
{
	nextToUpdate = 0;
	for ( ;; )
	{
		nextToUpdate++;
		if ( nextToUpdate >= level.players.size )
			nextToUpdate = 0;

		if ( isdefined( level.players[nextToUpdate] ) )
		{
			level.players[nextToUpdate] update_played_time();
			level.players[nextToUpdate] persistence::check_contract_expirations();
		}

		wait ( 1.0 );
	}
}

function update_played_time()
{
	pixbeginevent("updatePlayedTime");

	foreach( team in level.teams )
	{
		if ( self.timePlayed[team] )
		{
			self AddPlayerStat( "time_played_"+team, int( min( self.timePlayed[team], level.timeplayedcap ) ) );
			self AddPlayerStatWithGameType( "time_played_total", int( min( self.timePlayed[team], level.timeplayedcap ) ) );
		}
	}
		
	if ( self.timePlayed["other"] )
	{
		self AddPlayerStat( "time_played_other", int( min( self.timePlayed["other"], level.timeplayedcap ) ) );			
		self AddPlayerStatWithGameType( "time_played_total", int( min( self.timePlayed["other"], level.timeplayedcap ) ) );
	}
	
	if ( self.timePlayed["alive"] )
	{
		timeAlive = int( min( self.timePlayed["alive"], level.timeplayedcap ) );
		self persistence::increment_contract_times( timeAlive );
		self AddPlayerStat( "time_played_alive", timeAlive );			
	}
	
	pixendevent();
	
	if ( game["state"] == "postgame" )
		return;

	foreach( team in level.teams )
	{
		self.timePlayed[team] = 0;
	}
	self.timePlayed["other"] = 0;
	self.timePlayed["alive"] = 0;
}


function update_time()
{
	if ( game["state"] != "playing" )
		return;
		
	self.pers["teamTime"] = getTime();
}

function update_balance_dvar()
{
	for(;;)
	{
		teambalance = GetDvarint( "scr_teambalance");
		if(level.teambalance != teambalance)
			level.teambalance = GetDvarint( "scr_teambalance");

		timeplayedcap = GetDvarint( "scr_timeplayedcap");
		if(level.timeplayedcap != timeplayedcap)
			level.timeplayedcap = int(GetDvarint( "scr_timeplayedcap"));

		wait 1;
	}
}

function change( team )
{
	if (self.sessionstate != "dead")
	{
		// Set a flag on the player to they aren't robbed points for dying - the callback will remove the flag
		self.switching_teams = true;
		self.switchedTeamsResetGadgets = true;
		self.joining_team = team;
		self.leaving_team = self.pers["team"];
		
		// Suicide the player so they can't hit escape and fail the team balance
		self suicide();
	}

	self.pers["team"] = team;
	self.team = team;
	self.pers["weapon"] = undefined;
	self.pers["spawnweapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self.pers["teamTime"] = undefined;
	self.sessionteam = self.pers["team"];
	if ( !level.teamBased ) 
		self.ffateam = team;

	self globallogic_ui::updateObjectiveText();
	
	// update spectator permissions immediately on change of team
	self spectating::set_permissions();
	
	self SetClientScriptMainMenu( game[ "menu_start_menu" ] );
	self openMenu(game[ "menu_start_menu" ]);
	
	self notify("end_respawn");
}

function count_players()
{
	players = level.players;
	
	playerCounts = [];
	foreach( team in level.teams )
	{
		playerCounts[team] = 0;
	}
	
	foreach( player in level.players )
	{
		if( player == self )
			continue;
		
		team = player.pers["team"];
		if( isdefined(team) && isdefined( level.teams[team] ) )
			playerCounts[team]++;
	}
	return playerCounts;
}


function track_free_played_time()
{
	self endon( "disconnect" );

	foreach( team in level.teams )
	{
		self.timePlayed[team] = 0;
	}

	self.timePlayed["other"] = 0;
	self.timePlayed["total"] = 0;
	self.timePlayed["alive"] = 0;

	for ( ;; )
	{
		if ( game["state"] == "playing" )
		{
			team = self.pers["team"];
			if ( isdefined( team ) && isdefined( level.teams[team] ) && self.sessionteam != "spectator" )
			{
				self.timePlayed[team]++;
				self.timePlayed["total"]++;
				if ( IsAlive( self ) )
					self.timePlayed["alive"]++;
			}
			else
			{
				self.timePlayed["other"]++;
			}
		}
		
		wait ( 1.0 );
	}
}

function set_player_model( team, weapon )
{
	self DetachAll();
	self SetMoveSpeedScale( 1 );
	self SetSprintDuration( 4 );
	self SetSprintCooldown( 0 );
}

function get_flag_model( teamRef )
{
	assert(isdefined(game["flagmodels"]));
	assert(isdefined(game["flagmodels"][teamRef]));
	return ( game["flagmodels"][teamRef] );
}

function get_flag_carry_model( teamRef )
{
	assert(isdefined(game["carry_flagmodels"]));
	assert(isdefined(game["carry_flagmodels"][teamRef]));
	return ( game["carry_flagmodels"][teamRef] );
}

function get_flag_icon( teamRef )
{
	assert(isdefined(game["carry_icon"]));
	assert(isdefined(game["carry_icon"][teamRef]));
	return ( game["carry_icon"][teamRef] );
}

function getEnemyTeam( player_team )
{
	foreach( team in level.teams )
	{
		if ( team == player_team )
			continue;
		
		if ( team == "spectator" )
			continue;
		
		return team;
	}
	
	return util::getOtherTeam( player_team );
}

function GetEnemyPlayers()
{
	enemies = [];
	
	foreach( player in level.players )
	{
		if( player.team == "spectator" )
		{
			continue;
		}
		
		if( ( level.teamBased && player.team != self.team ) || ( !level.teamBased && player != self ) )
		{
			if ( !isdefined( enemies ) ) enemies = []; else if ( !IsArray( enemies ) ) enemies = array( enemies ); enemies[enemies.size]=player;;
		}
	}
	
	return enemies;
}

function GetFriendlyPlayers()
{
	friendlies = [];
	
	foreach( player in level.players )
	{
		if( ( player.team == self.team ) && ( player != self ) )
		{
			if ( !isdefined( friendlies ) ) friendlies = []; else if ( !IsArray( friendlies ) ) friendlies = array( friendlies ); friendlies[friendlies.size]=player;;
		}
	}
	
	return friendlies;
}

function WaitUntilTeamChange( player, callback, arg, end_condition1, end_condition2, end_condition3 )
{
	if( isdefined( end_condition1 ) )
		self endon( end_condition1 );
	if( isdefined( end_condition2 ) )
		self endon( end_condition2 );
	if( isdefined( end_condition3 ) )
		self endon( end_condition3 );
	
	event = player util::waittill_any( "joined_team", "disconnect", "joined_spectators" );
	
	if( isdefined( callback ) )
	{
		self [[ callback ]]( arg, event );
	}
}

function HideToSameTeam()
{
	if( level.teambased )
	{
		self SetVisibleToAllExceptTeam( self.team );
	}
	else
	{
		self SetVisibleToAll();
		self SetInvisibleToPlayer( self.owner );
	}
}

