#using scripts\shared\demo_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_medals;
#using scripts\mp\_popups;
#using scripts\mp\_util;

/*
	Sabotage
	
	// ...etc...
*/

/*QUAKED mp_sab_spawn_axis (0.75 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_sab_spawn_allies (0.0 0.75 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_sab_spawn_axis_start (1.0 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_sab_spawn_allies_start (0.0 1.0 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

#precache( "material", "waypoint_bomb" );
#precache( "material", "waypoint_kill" );
#precache( "material", "waypoint_bomb_enemy" );
#precache( "material", "waypoint_defend" );
#precache( "material", "waypoint_defuse" );
#precache( "material", "waypoint_target" );
#precache( "material", "compass_waypoint_bomb" );
#precache( "material", "compass_waypoint_defend" );
#precache( "material", "compass_waypoint_defuse" );
#precache( "material", "compass_waypoint_target" );
#precache( "material", "hud_suitcase_bomb" );
#precache( "string", "OBJECTIVES_TDM" );
#precache( "string", "OBJECTIVES_SAB" );
#precache( "string", "OBJECTIVES_TDM_SCORE" );
#precache( "string", "OBJECTIVES_SAB_SCORE" );
#precache( "string", "OBJECTIVES_TDM_HINT" );
#precache( "string", "OBJECTIVES_SAB_HINT" );
#precache( "string", "MP_EXPLOSIVES_RECOVERED_BY");	
#precache( "string", "MP_EXPLOSIVES_RECOVERED_BY");
#precache( "string", "MP_EXPLOSIVES_DROPPED_BY");
#precache( "string", "MP_EXPLOSIVES_PLANTED_BY");
#precache( "string", "MP_EXPLOSIVES_DEFUSED_BY");
#precache( "string", "MP_YOU_HAVE_RECOVERED_THE_BOMB");
#precache( "string", "PLATFORM_HOLD_TO_PLANT_EXPLOSIVES");
#precache( "string", "PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES");
#precache( "string", "MP_PLANTING_EXPLOSIVE");
#precache( "string", "MP_DEFUSING_EXPLOSIVE");
#precache( "string", "MP_TARGET_DESTROYED");
#precache( "string", "MP_NO_RESPAWN");
#precache( "string", "MP_TIE_BREAKER");	
#precache( "string", "MP_NO_RESPAWN");
#precache( "string", "MP_SUDDEN_DEATH");
#precache( "fx", "_t6/maps/mp_maps/fx_mp_exp_bomb" );

function main()
{
	globallogic::init();
	
	level.teamBased = true;
	level.overrideTeamScore = true;

	util::registerRoundSwitch( 0, 9 );
	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 500 );
	util::registerRoundLimit( 0, 10 );
	util::registerNumLives( 0, 100 );
	util::registerRoundWinLimit( 0, 10 );

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );

	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onSpawnPlayerUnified =&onSpawnPlayerUnified;
	level.onRoundEndGame =&onRoundEndGame;

	if ( !game["tiebreaker"] )
	{
		level.onPrecacheGameType =&onPrecacheGameType;
		level.onTimeLimit =&onTimeLimit;
		level.onDeadEvent =&onDeadEvent;
		level.onRoundSwitch =&onRoundSwitch;
		level.onPlayerKilled =&onPlayerKilled;
	
		level.endGameOnScoreLimit = false;
		
		game["dialog"]["gametype"] = "sab_start";
		game["dialog"]["gametype_hardcore"] = "hcsab_start";
		game["dialog"]["offense_obj"] = "destroy_start";
		game["dialog"]["defense_obj"] = "destroy_start";
		game["dialog"]["sudden_death"] = "suddendeath";
		game["dialog"]["sudden_death_boost"] = "generic_boost";
	}
	else
	{
		level.onEndGame =&onEndGame;
	
		level.endGameOnScoreLimit = false;
		
		game["dialog"]["gametype"] = "sab_start";
		game["dialog"]["gametype_hardcore"] = "hcsab_start";
		game["dialog"]["offense_obj"] = "generic_boost";
		game["dialog"]["defense_obj"] = "generic_boost";
		game["dialog"]["sudden_death"] = "suddendeath";
		game["dialog"]["sudden_death_boost"] = "generic_boost";

		util::registerNumLives( 1, 1 );
		util::registerTimeLimit( 0, 0 );
	}

	badtrig = getent( "sab_bomb_defuse_allies", "targetname" );
	if ( isdefined( badtrig ) )
		badtrig delete();

	badtrig = getent( "sab_bomb_defuse_axis", "targetname" );
	if ( isdefined( badtrig ) )
		badtrig delete();

	level.lastDialogTime = 0;

	// Sets the scoreboard columns and determines with data is sent across the network
	globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths", "plants", "defuses" ); 
}

function onPrecacheGameType()
{
	game["bomb_dropped_sound"] = "mp_war_objective_lost";
	game["bomb_recovered_sound"] = "mp_war_objective_taken";
}


function onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["teamScores"]["allies"] == level.scorelimit - 1 && game["teamScores"]["axis"] == level.scorelimit - 1 )
	{
		level.halftimeType = "overtime";
		level.halftimeSubCaption = &"MP_TIE_BREAKER";
		game["tiebreaker"] = true;
	}
	else
	{
		level.halftimeType = "halftime";
		game["switchedsides"] = !game["switchedsides"];
	}
}


function onStartGameType()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	setClientNameMode("auto_change");
	
	game["strings"]["target_destroyed"] = &"MP_TARGET_DESTROYED";

	if ( !game["tiebreaker"] )
	{
		util::setObjectiveText( "allies", &"OBJECTIVES_SAB" );
		util::setObjectiveText( "axis", &"OBJECTIVES_SAB" );
	
		if ( level.splitscreen )
		{
			util::setObjectiveScoreText( "allies", &"OBJECTIVES_SAB" );
			util::setObjectiveScoreText( "axis", &"OBJECTIVES_SAB" );
		}
		else
		{
			util::setObjectiveScoreText( "allies", &"OBJECTIVES_SAB_SCORE" );
			util::setObjectiveScoreText( "axis", &"OBJECTIVES_SAB_SCORE" );
		}
		util::setObjectiveHintText( "allies", &"OBJECTIVES_SAB_HINT" );
		util::setObjectiveHintText( "axis", &"OBJECTIVES_SAB_HINT" );
	}
	else
	{
		util::setObjectiveText( "allies", &"OBJECTIVES_TDM" );
		util::setObjectiveText( "axis", &"OBJECTIVES_TDM" );
		
		if ( level.splitscreen )
		{
			util::setObjectiveScoreText( "allies", &"OBJECTIVES_TDM" );
			util::setObjectiveScoreText( "axis", &"OBJECTIVES_TDM" );
		}
		else
		{
			util::setObjectiveScoreText( "allies", &"OBJECTIVES_TDM_SCORE" );
			util::setObjectiveScoreText( "axis", &"OBJECTIVES_TDM_SCORE" );
		}
		util::setObjectiveHintText( "allies", &"OBJECTIVES_TDM_HINT" );
		util::setObjectiveHintText( "axis", &"OBJECTIVES_TDM_HINT" );
	}
	
	allowed[0] = "sab";
	gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	spawnlogic::place_spawn_points( "mp_sab_spawn_allies_start" );
	spawnlogic::place_spawn_points( "mp_sab_spawn_axis_start" );
	spawnlogic::add_spawn_points( "allies", "mp_sab_spawn_allies" );
	spawnlogic::add_spawn_points( "axis", "mp_sab_spawn_axis" );
	spawning::updateAllSpawnPoints();
	
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );

	level.spawn_axis = spawnlogic::get_spawnpoint_array( "mp_sab_spawn_axis" );
	level.spawn_allies = spawnlogic::get_spawnpoint_array( "mp_sab_spawn_allies" );
	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  spawnlogic::get_spawnpoint_array("mp_sab_spawn_" + team + "_start");
	}

	
	thread updateGametypeDvars();
	
	thread sabotage();
}


function onTimeLimit()
{
	if ( level.inOvertime )
		return;

	thread onOvertime();
}


function onOvertime()
{
	level endon ( "game_ended" );

	level.timeLimitOverride = true;
	level.inOvertime = true;
	globallogic_audio::leader_dialog( "sudden_death" );
	globallogic_audio::leader_dialog( "sudden_death_boost" );
	for ( index = 0; index < level.players.size; index++ )
	{
		level.players[index] notify("force_spawn");
		level.players[index] thread hud_message::oldNotifyMessage( &"MP_SUDDEN_DEATH", &"MP_NO_RESPAWN", undefined, (1, 0, 0), "mp_last_stand" );

		level.players[index] setClientUIVisibilityFlag( "g_compassShowEnemies", 1 );
	}

	SetMatchTalkFlag( "DeadChatWithDead", 1 );
	SetMatchTalkFlag( "DeadChatWithTeam", 0 );
	SetMatchTalkFlag( "DeadHearTeamLiving", 0 );
	SetMatchTalkFlag( "DeadHearAllLiving", 0 );
	SetMatchTalkFlag( "EveryoneHearsEveryone", 0 );

	waitTime = 0;
	while ( waitTime < 90 )
	{
		if ( !level.bombPlanted )
		{
			waitTime += 1;
			setGameEndTime( getTime() + ((90-waitTime)*1000) );
		}
		wait ( 1.0 );
	}

	thread globallogic::endGame( "tie", game["strings"]["tie"] );
}


function onDeadEvent( team )
{
	if ( level.bombExploded )
		return;
		
	if ( team == "all" )
	{
		if ( level.bombPlanted )
		{
			globallogic_score::giveTeamScoreForObjective( level.bombPlantedBy, 1 );
			thread globallogic::endGame( level.bombPlantedBy, game["strings"][level.bombPlantedBy+"_mission_accomplished"] );
		}
		else
		{
			thread globallogic::endGame( "tie", game["strings"]["tie"] );
		}
	}
	else if ( level.bombPlanted )
	{
		if ( team == level.bombPlantedBy )
		{
			level.plantingTeamDead = true;
			return;
		}
			
		otherTeam = util::getOtherTeam( level.bombPlantedBy )
		globallogic_score::giveTeamScoreForObjective( level.bombPlantedBy, 1 );
		thread globallogic::endGame( level.bombPlantedBy, game["strings"][otherTeam+"_eliminated"] );
	}
	else
	{
		otherTeam = util::getOtherTeam( team )
		globallogic_score::giveTeamScoreForObjective( otherTeam, 1 );
		thread globallogic::endGame( otherTeam, game["strings"][team+"_eliminated"] );
	}
}

function onSpawnPlayerUnified()
{
	self.isPlanting = false;
	self.isDefusing = false;
	self.isBombCarrier = false;

	if ( game["tiebreaker"] )
	{
		self thread hud_message::oldNotifyMessage( &"MP_TIE_BREAKER", &"MP_NO_RESPAWN", undefined, (1, 0, 0), "mp_last_stand" );
		
		self setClientUIVisibilityFlag( "g_compassShowEnemies", 1 );

		// this is being redundantly set everytime a player spawns 
		// need to move this to a once only for eveyone when tiebreaker round
		// starts
		SetMatchTalkFlag( "DeadChatWithDead", 1 );
		SetMatchTalkFlag( "DeadChatWithTeam", 0 );
		SetMatchTalkFlag( "DeadHearTeamLiving", 0 );
		SetMatchTalkFlag( "DeadHearAllLiving", 0 );
		SetMatchTalkFlag( "EveryoneHearsEveryone", 0 );
	}
	
	spawning::onSpawnPlayer_Unified();
}


function onSpawnPlayer(predictedSpawn)
{
	if (!predictedSpawn)
	{
		self.isPlanting = false;
		self.isDefusing = false;
		self.isBombCarrier = false;
	
		if ( game["tiebreaker"] )
		{
			self thread hud_message::oldNotifyMessage( &"MP_TIE_BREAKER", &"MP_NO_RESPAWN", undefined, (1, 0, 0), "mp_last_stand" );
		
			hintMessage = util::getObjectiveHintText( self.pers["team"] );
			//if ( isdefined( hintMessage ) )
			//	self DisplayGameModeMessage( hintMessage, "uin_alert_slideout" );
		
			self setClientUIVisibilityFlag( "g_compassShowEnemies", 1 );
			// this is being redundantly set everytime a player spawns 
			// need to move this to a once only for eveyone when tiebreaker round
			// starts
			SetMatchTalkFlag( "DeadChatWithDead", 1 );
			SetMatchTalkFlag( "DeadChatWithTeam", 0 );
			SetMatchTalkFlag( "DeadHearTeamLiving", 0 );
			SetMatchTalkFlag( "DeadHearAllLiving", 0 );
			SetMatchTalkFlag( "EveryoneHearsEveryone", 0 );
		}
	}

	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = util::getOtherTeam( spawnteam );

	if ( level.useStartSpawns )
	{
		spawnpoint = spawnlogic::get_spawnpoint_random(level.spawn_start[spawnteam]);
	}	
	else
	{
		if (spawnteam == "axis")
			spawnpoint = spawnlogic::get_spawnpoint_near_team(level.spawn_axis);
		else
			spawnpoint = spawnlogic::get_spawnpoint_near_team(level.spawn_allies);
	}

	assert( isdefined(spawnpoint) );

	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnpoint.origin, spawnpoint.angles );
	}
	else
	{
		self spawn( spawnpoint.origin, spawnpoint.angles, "sab" );
	}
}


function updateGametypeDvars()
{
	level.plantTime = GetGametypeSetting( "plantTime" );
	level.defuseTime = GetGametypeSetting( "defuseTime" );
	level.bombTimer = GetGametypeSetting( "bombTimer" );
	level.hotPotato = GetGametypeSetting( "hotPotato" );
}


function sabotage()
{
	level.bombPlanted = false;
	level.bombExploded = false;
		
	level._effect["bombexplosion"] = "_t6/maps/mp_maps/fx_mp_exp_bomb";

	trigger = getEnt( "sab_bomb_pickup_trig", "targetname" );
	if ( !isdefined( trigger ) ) 
	{
		util::error( "No sab_bomb_pickup_trig trigger found in map." );
		return;
	}

	visuals[0] = getEnt( "sab_bomb", "targetname" );
	if ( !isdefined( visuals[0] ) ) 
	{
		util::error( "No sab_bomb script_model found in map." );
		return;
	}
	
	//visuals[0] setModel( "t5_weapon_briefcase_world" );
	level.sabBomb = gameobjects::create_carry_object( "neutral", trigger, visuals, (0,0,32) );
	level.sabBomb gameobjects::allow_carry( "any" );
	level.sabBomb gameobjects::set_2d_icon( "enemy", "compass_waypoint_bomb" );
	level.sabBomb gameobjects::set_3d_icon( "enemy", "waypoint_bomb" );
	level.sabBomb gameobjects::set_2d_icon( "friendly", "compass_waypoint_bomb" );
	level.sabBomb gameobjects::set_3d_icon( "friendly", "waypoint_bomb" );
	level.sabBomb gameobjects::set_carry_icon( "hud_suitcase_bomb" );
	level.sabBomb gameobjects::set_visible_team( "any" );
	level.sabBomb.objIDPingEnemy = true;
	level.sabBomb.onPickup =&onPickup;
	level.sabBomb.onDrop =&onDrop;
	level.sabBomb.allowWeapons = true;
	level.sabBomb.objPoints["allies"].archived = true;
	level.sabBomb.objPoints["axis"].archived = true;
	level.sabBomb.autoResetTime = 60.0;
	
	if ( !isdefined( getEnt( "sab_bomb_axis", "targetname" ) ) ) 
	{
		/#util::error("No sab_bomb_axis trigger found in map.");#/
		return;
	}
	if ( !isdefined( getEnt( "sab_bomb_allies", "targetname" ) ) )
	{
		/#util::error("No sab_bomb_allies trigger found in map.");#/
		return;
	}

	if ( game["switchedsides"] )
	{
		level.bombZones["allies"] = createBombZone( "allies", getEnt( "sab_bomb_axis", "targetname" ) );
		level.bombZones["axis"] = createBombZone( "axis", getEnt( "sab_bomb_allies", "targetname" ) );
	}
	else
	{
		level.bombZones["allies"] = createBombZone( "allies", getEnt( "sab_bomb_allies", "targetname" ) );
		level.bombZones["axis"] = createBombZone( "axis", getEnt( "sab_bomb_axis", "targetname" ) );
	}
}


function createBombZone( team, trigger )
{
	visuals = getEntArray( trigger.target, "targetname" );
	
	bombZone = gameobjects::create_use_object( team, trigger, visuals, (0,0,64) );
	bombZone resetBombsite();
	bombZone.onUse =&onUse;
	bombZone.onBeginUse =&onBeginUse;
	bombZone.onEndUse =&onEndUse;
	bombZone.onCantUse =&onCantUse;
	bombZone.useWeapon = GetWeapon( "briefcase_bomb" );
	bombZone.visuals[0].killCamEnt = spawn( "script_model", bombZone.visuals[0].origin + (0,0,128) );
	
	for ( i = 0; i < visuals.size; i++ )
	{
		if ( isdefined( visuals[i].script_exploder ) )
		{
			bombZone.exploderIndex = visuals[i].script_exploder;
			break;
		}
	}
	
	return bombZone;
}


function onBeginUse( player )
{
	// planted the bomb
	if ( !self gameobjects::is_friendly_team( player.pers["team"] ) )
	{
		player.isPlanting = true;
		player thread battlechatter::gametype_specific_battle_chatter( "sd_friendlyplant", player.pers["team"] );
	}
	else
	{
		player.isDefusing = true;
		player thread battlechatter::gametype_specific_battle_chatter( "sd_enemyplant", player.pers["team"] );
	}
	
	player playSound( "fly_bomb_raise_plr" );
}

function onEndUse( team, player, result )
{
	if ( !isAlive( player ) )
		return;
	
	player.isPlanting = false;
	player.isDefusing = false;
	player notify( "event_ended" );
}


function onPickup( player )
{
	level notify ( "bomb_picked_up" );

	player RecordGameEvent("pickup"); 
	
	self.autoResetTime = 60.0;
	
	level.useStartSpawns = false;
	
	team = player.pers["team"];
	
	if ( team == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";
	
	//player iPrintLnBold( &"MP_YOU_HAVE_RECOVERED_THE_BOMB" );
	player playLocalSound( "mp_suitcase_pickup" );
	/#print( "bomb taken" );#/
	
	excludeList[0] = player;

	if( getTime() - level.lastDialogTime > 10000 )
	{
		globallogic_audio::leader_dialog( "bomb_acquired", team );
		player globallogic_audio::leader_dialog_on_player( "obj_destroy", "bomb" );


		if ( !level.splitscreen )
		{
			globallogic_audio::leader_dialog( "bomb_taken", otherTeam );
			globallogic_audio::leader_dialog( "obj_defend", otherTeam );
		}

		level.lastDialogTime = getTime();
	}
	player.isBombCarrier = true;

	player AddPlayerStatWithGameType( "PICKUPS", 1 );

	
	// recovered the bomb before abandonment timer elapsed
	if ( team == self gameobjects::get_owner_team() )
	{
		util::printOnTeamArg( &"MP_EXPLOSIVES_RECOVERED_BY", team, player );
		sound::play_on_players( game["bomb_recovered_sound"], team );
	}
	else
	{
		util::printOnTeamArg( &"MP_EXPLOSIVES_RECOVERED_BY", team, player );
//		util::printOnTeamArg( &"MP_EXPLOSIVES_RECOVERED_BY", otherTeam, &"MP_THE_ENEMY" );
		sound::play_on_players( game["bomb_recovered_sound"] );
	}
	
	self gameobjects::set_owner_team( team );
	self gameobjects::set_visible_team( "any" );
	self gameobjects::set_2d_icon( "enemy", "compass_waypoint_target" );
	self gameobjects::set_3d_icon( "enemy", "waypoint_kill" );
	self gameobjects::set_2d_icon( "friendly", "compass_waypoint_defend" );
	self gameobjects::set_3d_icon( "friendly", "waypoint_defend" );
		
	level.bombZones[team] gameobjects::set_visible_team( "none" );
	level.bombZones[otherTeam] gameobjects::set_visible_team( "any" );

	level.bombZones[otherTeam].trigger SetInvisibleToAll();
	level.bombZones[otherTeam].trigger SetVisibleToPlayer( player );
}


function onDrop( player )
{
	if ( level.bombPlanted )
	{
		
	}
	else
	{
		if ( isdefined( player ) )
			util::printOnTeamArg( &"MP_EXPLOSIVES_DROPPED_BY", self gameobjects::get_owner_team(), player );
//		else
//			util::printOnTeamArg( &"MP_EXPLOSIVES_DROPPED_BY", self gameobjects::get_owner_team(), &"MP_YOUR_TEAM" );
	
		sound::play_on_players( game["bomb_dropped_sound"], self gameobjects::get_owner_team() );
		/#
		if ( isdefined( player ) )
			print( "bomb dropped" );
		else
			print( "bomb dropped" );
		#/
			
		globallogic_audio::leader_dialog( "bomb_lost", self gameobjects::get_owner_team() );

		player notify( "event_ended" );

		level.bombZones["axis"].trigger SetInvisibleToAll();
		level.bombZones["allies"].trigger SetInvisibleToAll();

		thread abandonmentThink( 0.0 );
	}
}


function abandonmentThink( delay )
{
	level endon ( "bomb_picked_up" );
	
	wait ( delay );

	if ( isdefined( self.carrier ) )
		return;

	if ( self gameobjects::get_owner_team() == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";

//	util::printOnTeamArg( &"MP_EXPLOSIVES_DROPPED_BY", otherTeam, &"MP_THE_ENEMY" );
	sound::play_on_players( game["bomb_dropped_sound"], otherTeam );

	self gameobjects::set_owner_team( "neutral" );
	self gameobjects::set_visible_team( "any" );
	self gameobjects::set_2d_icon( "enemy", "compass_waypoint_bomb" );
	self gameobjects::set_3d_icon( "enemy", "waypoint_bomb" );
	self gameobjects::set_2d_icon( "friendly", "compass_waypoint_bomb" );
	self gameobjects::set_3d_icon( "friendly", "waypoint_bomb" );

	level.bombZones["allies"] gameobjects::set_visible_team( "none" );
	level.bombZones["axis"] gameobjects::set_visible_team( "none" );		
}


function onUse( player )
{
	team = player.pers["team"];
	otherTeam = util::getOtherTeam( team );
	
	// planted the bomb
	if ( !self gameobjects::is_friendly_team( player.pers["team"] ) )
	{
		player notify ( "bomb_planted" );
// removed old playsound entry CDC 2/18/10
//		player playSound( "mpl_sab_bomb_plant" );
		/# print( "bomb planted" );#/
		
		if( isdefined(player.pers["plants"]) )
		{
			player.pers["plants"]++;
			player.plants = player.pers["plants"];
		}

		demo::bookmark( "event", gettime(), player );

		player AddPlayerStatWithGameType( "PLANTS", 1 );
		
		level thread popups::DisplayTeamMessageToAll( &"MP_EXPLOSIVES_PLANTED_BY", player );
			
		//thread sound::play_on_players( "mus_sab_planted"+"_"+level.teamPostfix[team] );
		// Play Action music
		globallogic_audio::set_music_on_team( "ACTION", "both", true );			
		
		globallogic_audio::leader_dialog( "bomb_planted", team );

		globallogic_audio::leader_dialog( "bomb_planted", otherTeam );

		scoreevents::processScoreEvent( "planted_bomb", player );
		player RecordGameEvent("plant");
		
		level thread bombPlanted( self, player.pers["team"] );

		level.bombOwner = player;
		
		player.isBombCarrier = false;

//		self.keyObject gameobjects::disable_object();
		level.sabBomb.autoResetTime = undefined;
		level.sabBomb gameobjects::allow_carry( "none" );
		level.sabBomb gameobjects::set_visible_team( "none" );
		level.sabBomb gameobjects::set_dropped();
		self.useWeapon = GetWeapon( "briefcase_bomb_defuse" );
		
		self setUpForDefusing();
	}
	else // defused the bomb
	{
		player notify ( "bomb_defused" );
		/#print( "bomb defused" );#/
		
		if( isdefined(player.pers["defuses"]) )
		{
			player.pers["defuses"]++;
			player.defuses = player.pers["defuses"];
		}

		demo::bookmark( "event", gettime(), player );

		player AddPlayerStatWithGameType( "DEFUSES", 1 );

		level thread popups::DisplayTeamMessageToAll( &"MP_EXPLOSIVES_DEFUSED_BY", player );
		//thread sound::play_on_players( "mus_sab_defused"+"_"+level.teamPostfix[team] );
		
		globallogic_audio::leader_dialog( "bomb_defused" );

		scoreevents::processScoreEvent( "defused_bomb", player );
		player RecordGameEvent("defuse");

		level thread bombDefused( self );
		
		if ( level.inOverTime && isdefined( level.plantingTeamDead ) )
		{
			thread globallogic::endGame( player.pers["team"], game["strings"][level.bombPlantedBy+"_eliminated"] );
			return;
		}
		
		self resetBombsite();
		
		level.sabBomb gameobjects::allow_carry( "any" );
		level.sabBomb gameobjects::set_picked_up( player );
	}
}


function onCantUse( player )
{
	player iPrintLnBold( &"MP_CANT_PLANT_WITHOUT_BOMB" );
}


function bombPlanted( destroyedObj, team )
{
	game["challenge"][team]["plantedBomb"] = true;
	globallogic_utils::pauseTimer();
	level.bombPlanted = true;
	level.bombPlantedBy = team;
	level.timeLimitOverride = true;
	setMatchFlag( "bomb_timer", 1 );
	
	// communicate timer information to menus
	setGameEndTime( int( getTime() + (level.bombTimer * 1000) ) );
	
	destroyedObj.visuals[0] thread globallogic_utils::playTickingSound( "mpl_sab_ui_suitcasebomb_timer" );
	
	starttime = gettime();
	bombTimerWait();
	
	setMatchFlag( "bomb_timer", 0 );
	destroyedObj.visuals[0] globallogic_utils::stopTickingSound();

	if ( !level.bombPlanted )
	{
		if ( level.hotPotato )
		{
			timePassed = (gettime() - starttime) / 1000;
			level.bombTimer -= timePassed;
		}
		return;
	}
	/*
	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];
		if ( player.pers["team"] == team )
			player thread hud_message::oldNotifyMessage( "Your team scored!", undefined, undefined, (0, 1, 0) );
		else if ( player.pers["team"] != team )
			player thread hud_message::oldNotifyMessage( "Enemy team scored!", undefined, undefined, (1, 0, 0) );
	}
	*/
	explosionOrigin = level.sabBomb.visuals[0].origin+(0,0,12);
	level.bombExploded = true;	
	
	
	if ( isdefined( level.bombowner ) )
	{
		destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20, level.bombowner, "MOD_EXPLOSIVE", GetWeapon( "briefcase_bomb" ) );
		level thread popups::DisplayTeamMessageToAll( &"MP_EXPLOSIVES_BLOWUP_BY", level.bombowner );

		level.bombowner AddPlayerStatWithGameType( "DESTRUCTIONS", 1 );
		scoreevents::processScoreEvent( "bomb_detonated", level.bombowner );

	}
	else
		destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20, undefined, "MOD_EXPLOSIVE", GetWeapon( "briefcase_bomb" ) );
	
	rot = randomfloat(360);
	explosionEffect = spawnFx( level._effect["bombexplosion"], explosionOrigin + (0,0,50), (0,0,1), (cos(rot),sin(rot),0) );
	triggerFx( explosionEffect );
	
	thread sound::play_in_space( "mpl_sab_exp_suitcase_bomb_main", explosionOrigin );
	
	if ( isdefined( destroyedObj.exploderIndex ) )
		exploder::exploder( destroyedObj.exploderIndex );
	
	[[level._setTeamScore]]( team, [[level._getTeamScore]]( team ) + 1 );
	
	setGameEndTime( 0 );
	
	level.bombZones["allies"] gameobjects::set_visible_team( "none" );
	level.bombZones["axis"] gameobjects::set_visible_team( "none" );
	wait 3;
	
	// end the round without resetting the timer
	thread globallogic::endGame( team, game["strings"]["target_destroyed"] );
}

function bombTimerWait()
{
	level endon("bomb_defused");
	hostmigration::waitLongDurationWithGameEndTimeUpdate( level.bombTimer );
}


function resetBombsite()
{
	self gameobjects::allow_use( "enemy" );
	self gameobjects::set_use_time( level.plantTime );
	self gameobjects::set_use_text( &"MP_PLANTING_EXPLOSIVE" );
	self gameobjects::set_use_hint_text( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
	self gameobjects::set_key_object( level.sabBomb );
	self gameobjects::set_2d_icon( "friendly", "compass_waypoint_defend" );
	self gameobjects::set_3d_icon( "friendly", "waypoint_defend" );
	self gameobjects::set_2d_icon( "enemy", "compass_waypoint_target" );
	self gameobjects::set_3d_icon( "enemy", "waypoint_target" );
	self gameobjects::set_visible_team( "none" );
	self.trigger SetInvisibleToAll();
	self.useWeapon = GetWeapon( "briefcase_bomb" );
}

function setUpForDefusing()
{
	self gameobjects::allow_use( "friendly" );
	self gameobjects::set_use_time( level.defuseTime );
	self gameobjects::set_use_text( &"MP_DEFUSING_EXPLOSIVE" );
	self gameobjects::set_use_hint_text( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	self gameobjects::set_key_object( undefined );
	self gameobjects::set_2d_icon( "friendly", "compass_waypoint_defuse" );
	self gameobjects::set_3d_icon( "friendly", "waypoint_defuse" );
	self gameobjects::set_2d_icon( "enemy", "compass_waypoint_defend" );
	self gameobjects::set_3d_icon( "enemy", "waypoint_defend" );
	self gameobjects::set_visible_team( "any" );
	self.trigger SetVisibleToAll();
}

function bombDefused( object )
{
	setMatchFlag( "bomb_timer", 0 );
	globallogic_utils::resumeTimer();
	level.bombPlanted = false;
	if ( !level.inOvertime )
		level.timeLimitOverride = false;

	level notify("bomb_defused");	
}

function onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{	
	inBombZone = false;
	inBombZoneTeam = "none";
	
	if ( isdefined( level.bombZones["allies"] ) )
	{
		dist = Distance2d(self.origin, level.bombZones["allies"].curorigin);
		if ( dist < level.defaultOffenseRadius )
		{
			inBombZoneTeam = "allies";
			inBombZone = true;
		}
	}
	if ( isdefined( level.bombZones["axis"] ) )
	{
		dist = Distance2d(self.origin, level.bombZones["axis"].curorigin);
		if ( dist < level.defaultOffenseRadius )
		{
			inBombZoneTeam = "axis";
			inBombZone = true;
		}
	}
	
	if ( inBombZone && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
	{	
		if ( inBombZoneTeam == self.pers["team"] )
		{
			//attacker medals::offense( weapon );
			attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
			self RecordKillModifier("defending");
		}
		else
		{
			if( isdefined(attacker.pers["defends"]) )
			{
				attacker.pers["defends"]++;
				attacker.defends = attacker.pers["defends"];
			}

			attacker medals::defenseGlobalCount();
			attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
			self RecordKillModifier("assaulting");
		}
	}
	
	if ( isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] && isdefined( self.isBombCarrier ) && self.isBombCarrier == true )
	{
		self RecordKillModifier("carrying");
	}

	if( self.isPlanting == true )
		self RecordKillModifier("planting");

	if( self.isDefusing == true )
		self RecordKillModifier("defusing");
}

function onEndGame( winningTeam )
{
	if ( isdefined( winningTeam ) && (winningTeam == "allies" || winningTeam == "axis") )
		globallogic_score::giveTeamScoreForObjective( winningTeam, 1 );
}

function onRoundEndGame( roundWinner )
{
	winner = globallogic::determineTeamWinnerByGameStat( "roundswon" );
	
	return winner;
}