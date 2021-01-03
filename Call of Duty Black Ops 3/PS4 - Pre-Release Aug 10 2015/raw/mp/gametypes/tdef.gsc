#using scripts\codescripts\struct;

#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_util;
#using scripts\mp\teams\_teams;

/*
	Team Defender
	Objective: 	Score points for your team by eliminating players on the opposing team.
				Team with flag scores double kill points.
				First corpse spawns the flag.
	Map ends:	When one team reaches the score limit, or time limit is reached
	Respawning:	No wait / Near teammates

	Level requirementss
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of teammates and enemies
			at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.
*/


#precache( "string", "OBJECTIVES_TDEF" );
#precache( "string", "OBJECTIVES_TDEF_SCORE" );
#precache( "string", "OBJECTIVES_TDEF_ATTACKER_HINT" );
#precache( "string", "MP_NEUTRAL_FLAG_CAPTURED_BY" );
#precache( "string", "MP_NEUTRAL_FLAG_DROPPED_BY" );
#precache( "string", "MP_GRABBING_FLAG" );
#precache( "string", "OBJECTIVES_TDEF_ATTACKER_HINT" );
#precache( "string", "OBJECTIVES_TDEF_DEFENDER_HINT" );		
#precache( "string", "OBJECTIVES_TDEF" );	
#precache( "string", "OBJECTIVES_TDEF_SCORE" );	
#precache( "string", "OBJECTIVES_TDEF_HINT" );		
#precache( "string", "MP_FIRST_BLOOD" );		

function main()
{	
	globallogic::init();

	util::registerRoundSwitch( 0, 9 );
	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 10000 );
	util::registerRoundLimit( 0, 10 );
	util::registerNumLives( 0, 100 );
	
	level.matchRules_enemyFlagRadar = true;		
	level.matchRules_damageMultiplier = 0;
	level.matchRules_vampirism = 0;	
	
	setSpecialLoadouts();

	level.teamBased = true;
	level.initGametypeAwards =&initGametypeAwards;
	level.onPrecacheGameType =&onPrecacheGameType;
	level.onStartGameType =&onStartGameType;
	level.onPlayerKilled =&onPlayerKilled;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onRoundEndGame =&onRoundEndGame;
	level.onRoundSwitch =&onRoundSwitch;

	gameobjects::register_allowed_gameobject( level.gameType );
	gameobjects::register_allowed_gameobject( "tdm" );

	game["dialog"]["gametype"] = "team_def";
	if ( getDvarInt( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	
	game["dialog"]["got_flag"] = "ctf_wetake";
	game["dialog"]["enemy_got_flag"] = "ctf_theytake";
	game["dialog"]["dropped_flag"] = "ctf_wedrop";
	game["dialog"]["enemy_dropped_flag"] = "ctf_theydrop";

	game["strings"]["overtime_hint"] = &"MP_FIRST_BLOOD";
}


function onPrecacheGameType()
{

}


function onStartGameType()
{
	setClientNameMode("auto_change");

	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}

	util::setObjectiveText( "allies", &"OBJECTIVES_TDEF" );
	util::setObjectiveText( "axis", &"OBJECTIVES_TDEF" );
	
	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_TDEF" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_TDEF" );
	}
	else
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_TDEF_SCORE" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_TDEF_SCORE" );
	}
	util::setObjectiveHintText( "allies", &"OBJECTIVES_TDEF_ATTACKER_HINT" );
	util::setObjectiveHintText( "axis", &"OBJECTIVES_TDEF_ATTACKER_HINT" );
				
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	spawnlogic::place_spawn_points( "mp_tdm_spawn_allies_start" );
	spawnlogic::place_spawn_points( "mp_tdm_spawn_axis_start" );
	spawnlogic::add_spawn_points( "allies", "mp_tdm_spawn" );
	spawnlogic::add_spawn_points( "axis", "mp_tdm_spawn" );
	spawning::updateAllSpawnPoints();
	
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
		
	if ( !util::isOneRound() )
	{
		level.displayRoundEndText = true;
		if( level.scoreRoundWinBased )
		{
			globallogic_score::resetTeamScores();
		}
	}

	tdef();	
}

function tdef()
{	
//	level.icon2D["allies"] = teams::get_flag_icon( "allies" );
//	level.icon2D["axis"] = teams::get_flag_icon( "axis" );
	
	level.carryFlag["allies"] = teams::get_flag_carry_model( "allies" );
	level.carryFlag["axis"] = teams::get_flag_carry_model( "axis" );
	level.carryFlag["neutral"] = teams::get_flag_model( "neutral" );

	level.gameFlag = undefined;	
}


function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isPlayer( attacker ) || attacker.team == self.team )
		return;
		
	victim = self;
	
	score = rank::getScoreInfoValue( "kill" );
	assert( isdefined( score ) );
	
	//	we got the flag	- give bonus
	if ( isdefined( level.gameFlag ) && level.gameFlag gameobjects::get_owner_team() == attacker.team )
	{
		//	I'm the carrier
		if ( isdefined( attacker.carryFlag ) )
		{
			attacker AddPlayerStat( "KILLSASFLAGCARRIER", 1 );
		}
		//	someone else is
		else
		{
			//	give flag carrier a bonus for kills achieved by team
			//  scoreevents::processScoreEvent( "team_assist", level.gameFlag.carrier );
		}
		
		//scoreevents::processScoreEvent( "kill_bonus", attacker );	
		
		score *= 2;
	}
	//	no flag yet		- create it
	else if ( !isdefined( level.gameFlag ) && canCreateFlagAtVictimOrigin( victim ) )
	{
		level.gameFlag = createFlag( victim );
		
		score += rank::getScoreInfoValue( "MEDAL_FIRST_BLOOD" );								
	}
	//	killed carrier	- give bonus
	else if ( isdefined( victim.carryFlag ) )
	{
		killCarrierBonus = rank::getScoreInfoValue( "kill_carrier" );
		
		level thread popups::DisplayTeamMessageToAll( &"MP_KILLED_FLAG_CARRIER", attacker );
		scoreevents::processScoreEvent( "kill_flag_carrier", attacker );
		attacker RecordGameEvent("kill_carrier");	
		attacker AddPlayerStat( "FLAGCARRIERKILLS", 1 );
		attacker notify( "objective", "kill_carrier" );
		
		score += killCarrierBonus;			
	}

	attacker globallogic_score::giveTeamScoreForObjective( attacker.team, score );
	
	otherTeam = util::getOtherTeam( attacker.team );
	if ( game["state"] == "postgame" && game["teamScores"][attacker.team] > game["teamScores"][otherTeam] )
		attacker.finalKill = true;
}


function onDrop( player )
{
	// get the time when they dropped it
	if( isdefined( player ) && isdefined( player.tdef_flagTime ) )
	{
		flagTime = int( GetTime() - player.tdef_flagTime );
		player AddPlayerStat( "HOLDINGTEAMDEFENDERFLAG", flagTime );
		
		if ( ( flagTime/100 ) / 60 < 1 )
			flagMinutes = 0;
		else
			flagMinutes = int( ( flagTime/100 ) / 60 );
		
		player AddPlayerStatWithGameType( "DESTRUCTIONS", flagMinutes );
		
		player.tdef_flagTime = undefined;
		player notify( "dropped_flag" );
	}

	team = self gameobjects::get_owner_team();
	otherTeam = util::getOtherTeam( team );

	self.currentCarrier = undefined;

	self gameobjects::set_owner_team( "neutral" );
	self gameobjects::allow_carry( "any" );
	self gameobjects::set_visible_team( "any" );
	self gameobjects::set_2d_icon( "friendly", level.iconCaptureFlag2D );
	self gameobjects::set_3d_icon( "friendly", level.iconCaptureFlag3D );
	self gameobjects::set_2d_icon( "enemy", level.iconCaptureFlag2D );
	self gameobjects::set_3d_icon( "enemy", level.iconCaptureFlag3D );

	if ( isdefined( player ) )
	{
 		if ( isdefined( player.carryFlag ) )
			player detachFlag();
		
		util::printAndSoundOnEveryone( team, undefined, &"MP_NEUTRAL_FLAG_DROPPED_BY", &"MP_NEUTRAL_FLAG_DROPPED_BY", "mp_war_objective_lost", "mp_war_objective_lost", player );	
	}
	else
	{
		sound::play_on_players( "mp_war_objective_lost", team );
		sound::play_on_players( "mp_war_objective_lost", otherTeam );
	}

	globallogic_audio::leader_dialog( "dropped_flag", team);
	globallogic_audio::leader_dialog( "enemy_dropped_flag", otherTeam );
}


function onPickup( player )
{
	self notify ( "picked_up" );

	// get the time when they picked it up
	player.tdef_flagTime = GetTime();
	player thread watchForEndGame();

	score = rank::getScoreInfoValue( "capture" );
	assert( isdefined( score ) );	

	team = player.team;
	otherTeam = util::getOtherTeam( team );
			
	//	flag carrier class?  (do before attaching flag)
	if ( isdefined( level.tdef_loadouts ) && isdefined( level.tdef_loadouts[team] ) )
		player thread applyFlagCarrierClass(); // attaches flag
	else
		player attachFlag();
		
	self.currentCarrier = player;	
	player.carryIcon setShader( level.icon2D[team], player.carryIcon.width, player.carryIcon.height );	
	
	self gameobjects::set_owner_team( team );
	self gameobjects::set_visible_team( "any" );
	self gameobjects::set_2d_icon( "friendly", level.iconEscort2D );
	self gameobjects::set_3d_icon( "friendly", level.iconEscort2D );
	self gameobjects::set_2d_icon( "enemy", level.iconKill3D );
	self gameobjects::set_3d_icon( "enemy", level.iconKill3D );
	
	globallogic_audio::leader_dialog( "got_flag", team );
	globallogic_audio::leader_dialog( "enemy_got_flag", otherTeam );	

	level thread popups::DisplayTeamMessageToAll( &"MP_CAPTURED_THE_FLAG", player );
	scoreevents::processScoreEvent( "flag_capture", player );
	player RecordGameEvent("pickup");
	player AddPlayerStatWithGameType( "CAPTURES", 1 );
	player notify( "objective", "captured" );

	util::printAndSoundOnEveryone( team, undefined, &"MP_NEUTRAL_FLAG_CAPTURED_BY", &"MP_NEUTRAL_FLAG_CAPTURED_BY", "mp_obj_captured", "mp_enemy_obj_captured", player );
	
	//	give a capture bonus to the capturing team if the flag is changing hands
	if ( self.currentTeam == otherTeam )
		player globallogic_score::giveTeamScoreForObjective( team, score );
	self.currentTeam = team;
	
	//	activate portable radar on flag for the opposing team
	if ( level.matchRules_enemyFlagRadar )
		self thread flagAttachRadar( otherTeam );	
}


function applyFlagCarrierClass()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	//	remove placement item if carrying
	if ( isdefined( self.isCarrying ) && self.isCarrying == true )
	{
		self notify( "force_cancel_placement" );
		{wait(.05);};
	}	
	
	//	set the gamemodeloadout for loadout::giveLoadout() to use
	self.pers["gamemodeLoadout"] = level.tdef_loadouts[self.team];	
	
	//	set faux TI to respawn in place
	spawnPoint = spawn( "script_model", self.origin );
	spawnPoint.angles = self.angles;
	spawnPoint.playerSpawnPos = self.origin;
	spawnPoint.notTI = true;		
	self.setSpawnPoint = spawnPoint;
			
	//	globallogic_spawn::spawnPlayer() calls loadout::giveLoadout() passing the player's class
	//	save their chosen class and override their current and last class 
	//	- both so killstreaks don't get reset
	//	- this is automatically set back to chosen class within loadout::giveLoadout()
	self.gamemode_chosenClass = self.curClass;				
	self.pers["class"] = "gamemode";
	self.pers["lastClass"] = "gamemode";
	self.curClass = "gamemode";
	self.lastClass = "gamemode";		
		
	//	attach flag after faux spawn (model may change for sniper or juggernaut loadout)
	self thread waitAttachFlag();
}


function waitAttachFlag()
{
	level endon( "game_ende" );
	self endon( "disconnect" );
	self endon( "death" );
	
	self waittill( "spawned_player" );
	self attachFlag();
}


function watchForEndGame()
{
	self endon( "dropped_flag" );
	self endon( "disconnect" );

	level waittill( "game_ended" );

	if( isdefined( self ) )
	{
		if( isdefined( self.tdef_flagTime ) )
		{
			flagTime = int( GetTime() - self.tdef_flagTime );
			self AddPlayerStat( "HOLDINGTEAMDEFENDERFLAG", flagTime );
			
			if ( ( flagTime/100 ) / 60 < 1 )
				flagMinutes = 0;
			else
				flagMinutes = int( (flagTime/100)/60 );

			self AddPlayerStatWithGameType( "DESTRUCTIONS", flagMinutes );
		}
	}
}


function canCreateFlagAtVictimOrigin( victim )
{
	mineTriggers = getEntArray( "minefield", "targetname" );
	hurtTriggers = getEntArray( "trigger_hurt", "classname" );
	radTriggers = getEntArray( "radiation", "targetname" );
		
	for ( index = 0; index < radTriggers.size; index++ )
	{
		if ( victim isTouching( radTriggers[index] ) )
			return false;
	}

	for ( index = 0; index < mineTriggers.size; index++ )
	{
		if ( victim isTouching( mineTriggers[index] ) )
			return false;
	}

	for ( index = 0; index < hurtTriggers.size; index++ )
	{
		if ( victim isTouching( hurtTriggers[index] ) )
			return false;
	}	
	
	return true;
}


function createFlag( victim )
{	
	//	flag
	visuals[0] = spawn( "script_model", victim.origin );
	visuals[0] setModel( level.carryFlag["neutral"] );
	
	//	trigger	
	trigger = spawn( "trigger_radius", victim.origin, 0, 96, 72);	
	
	gameFlag = gameobjects::create_carry_object( "neutral", trigger, visuals, (0,0,85) );
	gameFlag gameobjects::allow_carry( "any" );
	
	gameFlag gameobjects::set_visible_team( "any" );
	gameFlag gameobjects::set_2d_icon( "enemy", level.iconCaptureFlag2D );
	gameFlag gameobjects::set_3d_icon( "enemy", level.iconCaptureFlag3D );
	gameFlag gameobjects::set_2d_icon( "friendly", level.iconCaptureFlag2D );
	gameFlag gameobjects::set_3d_icon( "friendly", level.iconCaptureFlag3D );

	gameFlag gameobjects::set_carry_icon( level.icon2D["axis"] ); //temp, manually changed after picked up
	
	gameFlag.allowWeapons = true;
	gameFlag.onPickup =&onPickup;
	gameFlag.onPickupFailed =&onPickup;
	gameFlag.onDrop =&onDrop;
	
	gameFlag.oldRadius = 96;	
	gameFlag.currentTeam = "none";
	gameFlag.requiresLOS = true;
	
	//	set it as flag trigger when on ground
	level.favorCloseSpawnEnt = gameFlag.trigger;
	level.favorCloseSpawnScalar = 3;	
	
	//	for this mode, the flag's home position is wherever its last safe position was, not where it was initially created
	gameFlag thread updateBasePosition();
	
	return gameFlag;
}


function updateBasePosition()
{
	level endon( "game_ended" );
	
	while( true )
	{
		if ( isdefined( self.safeOrigin ) )
		{
			self.baseOrigin = self.safeOrigin;
			self.trigger.baseOrigin = self.safeOrigin;
			self.visuals[0].baseOrigin = self.safeOrigin;
		}			
		{wait(.05);};
	}
}


function attachFlag()
{
	self attach( level.carryFlag[self.team], "J_spine4", true );
	self.carryFlag = level.carryFlag[self.team];
	
	//	set it as flag carrier when carried
	level.favorCloseSpawnEnt = self;	
}


function detachFlag()
{
	self detach( self.carryFlag, "J_spine4" );
	self.carryFlag = undefined;		
	
	//	set it as flag trigger when on ground
	level.favorCloseSpawnEnt = level.gameFlag.trigger;	
}


function flagAttachRadar( team )
{
	level endon("game_ended");
	self  endon( "dropped" );	
}


function getFlagRadarOwner( team )
{
	level endon("game_ended");
	self  endon( "dropped" );
	
	while ( true )
	{	
		foreach( player in level.players )
		{
			if ( isAlive( player ) && player.team == team )
				return player;
		}
		{wait(.05);};
	}
}


function flagRadarMover()
{
	level endon("game_ended");
	self  endon( "dropped" );
	self.portable_radar endon( "death" );
	
	for( ;; )
	{
		self.portable_radar MoveTo( self.currentCarrier.origin, .05 );
		{wait(.05);};
	}
}


function flagWatchRadarOwnerLost()
{
	level endon("game_ended");
	self  endon( "dropped" );
	
	radarTeam = self.portable_radar.team;
	
	self.portable_radar.owner util::waittill_any( "disconnect", "joined_team", "joined_spectators" );
	
	//	make a new one
	flagAttachRadar( radarTeam );
}

function onRoundEndGame( roundWinner )
{
	winner = globallogic::determineTeamWinnerByGameStat( "roundswon" );
	
	return winner;
}

function onSpawnPlayer(predictedSpawn)
{
	self.usingObj = undefined;
	
	if ( level.useStartSpawns && !level.inGracePeriod )
	{
		level.useStartSpawns = false;
	}
	
	spawning::onSpawnPlayer(predictedSpawn);
}

function onRoundSwitch()
{
	game["switchedsides"] = !game["switchedsides"];
}

function initGametypeAwards()
{
}


function setSpecialLoadouts()
{
}