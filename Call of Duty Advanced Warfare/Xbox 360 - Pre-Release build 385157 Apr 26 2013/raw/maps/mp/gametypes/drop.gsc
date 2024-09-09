#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

/*
	Drop
	Objective: 	Score points for your team by collecting intel from drop pods
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

 	TODO:
 	------------------
 		Pods drop from sky
 		Collect intel from pods
 		Intel is a fixed value per pod
 		
 		Pick where to spawn the pods:
 			Close to other pods in play
			Close to players
 			Add a value to the drop_locs in radiant to increase the chances of picking an area in high traffic regions
 			Manage pod drop rate to create a climax and base it on how many points are available in the map
 
 		Messaging of incoming drop pods through text and audio que
 		Show drop pod location in minimap as it's coming down.
 
 */

/*QUAKED mp_tdm_spawn (0.0 0.0 1.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_tdm_spawn_axis_start (0.5 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_tdm_spawn_allies_start (0.0 0.5 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	if(getdvar("mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	if ( isUsingMatchRulesData() )
	{
		level.initializeMatchRules = ::initializeMatchRules;
		[[level.initializeMatchRules]]();
		level thread reInitializeMatchRulesOnMigration();		
	}
	else
	{
		registerRoundSwitchDvar( level.gameType, 0, 0, 9 );
		registerTimeLimitDvar( level.gameType, 10 );
		registerScoreLimitDvar( level.gameType, 200 );
		registerRoundLimitDvar( level.gameType, 1 );
		registerWinLimitDvar( level.gameType, 1 );
		registerNumLivesDvar( level.gameType, 0 );
		registerHalfTimeDvar( level.gameType, 0 );
		
		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;
	}

	level.teamBased = true;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onNormalDeath = ::onNormalDeath;
	
	if ( level.matchRules_damageMultiplier || level.matchRules_vampirism )
		level.modifyPlayerDamage = maps\mp\gametypes\_damage::gamemodeModifyPlayerDamage;

	game["dialog"]["gametype"] = "tm_death";
	
	if ( getDvarInt( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "camera_thirdPerson" ) )
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "scr_diehard" ) )
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	else if (getDvarInt( "scr_" + level.gameType + "_promode" ) )
		game["dialog"]["gametype"] = game["dialog"]["gametype"] + "_pro";
	
	game["strings"]["overtime_hint"] = &"MP_FIRST_BLOOD";
}


initializeMatchRules()
{
	//	set common values
	setCommonRulesFromMatchRulesData();
	
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	SetDynamicDvar( "scr_drop_roundswitch", 0 );
	registerRoundSwitchDvar( "drop", 0, 0, 9 );
	SetDynamicDvar( "scr_drop_roundlimit", 1 );
	registerRoundLimitDvar( "drop", 1 );		
	SetDynamicDvar( "scr_drop_winlimit", 1 );
	registerWinLimitDvar( "drop", 1 );			
	SetDynamicDvar( "scr_drop_halftime", 0 );
	registerHalfTimeDvar( "drop", 0 );
		
	SetDynamicDvar( "scr_drop_promode", 0 );	
}


onStartGameType()
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

	setObjectiveText( "allies", &"OBJECTIVES_DROP" );
	setObjectiveText( "axis", &"OBJECTIVES_DROP" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_DROP" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_DROP" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_DROP_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_DROP_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_DROP_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_DROP_HINT" );
	
	initSpawns();
	
	allowed[0] = level.gameType;
	allowed[1] = "airdrop_pallet";
	allowed[2] = "drop_obj";
	
	maps\mp\gametypes\_gameobjects::main(allowed);	
	
	thread drop();
}

initSpawns()
{
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_tdm_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
}


getSpawnPoint()
{
	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	if ( level.inGracePeriod )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_" + spawnteam + "_start" );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	return spawnPoint;
}


onNormalDeath( victim, attacker, lifeId )
{
	score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	assert( isDefined( score ) );

	//attacker maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( attacker.pers["team"], score );
	
	if ( game["state"] == "postgame" && game["teamScores"][attacker.team] > game["teamScores"][level.otherTeam[attacker.team]] )
		attacker.finalKill = true;
}


onTimeLimit()
{
	level.finalKillCam_winner = "none";
	if ( game["status"] == "overtime" )
	{
		winner = "forfeit";
	}
	else if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
	{
		winner = "overtime";
	}
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
	{
		level.finalKillCam_winner = "axis";
		winner = "axis";
	}
	else
	{
		level.finalKillCam_winner = "allies";
		winner = "allies";
	}
	
	thread maps\mp\gametypes\_gamelogic::endGame( winner, game["strings"]["time_limit_reached"] );
}


//---- Main Setup ----//
drop()
{
	SetDvarIfUninitialized( "scr_drop_prob_limit", 25 );
	
	//setup elements needed for gametype
	game["flagmodels"] = [];
	game["flagmodels"]["neutral"] = "prop_flag_neutral";

	game["flagmodels"]["allies"] = maps\mp\gametypes\_teams::getTeamFlagModel( "allies" );
	game["flagmodels"]["axis"] = maps\mp\gametypes\_teams::getTeamFlagModel( "axis" );
	
	level.icon2D["allies"] = maps\mp\gametypes\_teams::getTeamFlagIcon( "allies" );
	level.icon2D["axis"] = maps\mp\gametypes\_teams::getTeamFlagIcon( "axis" );
	
	precacheModel( game["flagmodels"]["neutral"] );
	precacheModel( game["flagmodels"]["allies"] );
	precacheModel( game["flagmodels"]["axis"] );
	
	precacheShader( "waypoint_captureneutral" );
	precacheShader( level.icon2D["axis"] );
	precacheShader( level.icon2D["allies"] );
	
	precacheShader( "remotemissile_target_hostile" );
	
	precacheString( &"MP_HACKING_DROP_POD" );
	precacheString( &"PLATFORM_HOLD_TO_HACK_DROP_POD" );
	precacheString( &"MP_INCOMING_DROP_POD" );
	
	
	//setup drop pod assets
	//setup all the drop pod objectives first, move them around, on move give them new resources
	setupObjectivePoints();
	

	
	
	//monitor current drop pod point values and know when to drop a new one
	gameFlagWait( "prematch_done" );
	
	//handle drop pod objective
	thread monitorObjectives();

}

//---- Drop Pod Launch ----//
monitorObjectives()
{
	initial_objectives_launched = false;
	last_drop_number = 0;
	drop_pods_to_drop = 0;
	pod_value = "1";
	
	while( 1 )
	{
		if( initial_objectives_launched == false )
		{
			//incoming drop pod UI
			thread incomingDropPodMessaging();
			
			wait 5;
			
			//get first objectives
			drop_locations_sorted = getValidDropLocation();
			initial_locations = getDropLocationsWithValue( drop_locations_sorted[1], "0" );
			
			initial_objectives_launched = true;
			
			foreach( drop_loc in initial_locations )
			{
				drop_loc.inPlay = true;
				
				//select point value
				total_resource = 45;
				
				//launch pod
				thread launchDropPod( drop_loc, total_resource );
				last_drop_number ++;
			}
			
			wait 15;
			continue;
		}
		else
		{
			//count current points available and how many objectives are in play
			drop_probability_info = getDropProbability();
			if( RandomFloat( 1 ) < drop_probability_info[1] )
			{
				//figure out how many pods should drop
				if( last_drop_number >= 3 )
				{
					drop_pods_to_drop = 1;
					last_drop_number = 1;
					pod_value = "1";
				}
				else if( last_drop_number == 1 )
				{
					drop_pods_to_drop = 2;
					last_drop_number = 2;
					pod_value = "2";
				}
				else if( last_drop_number == 2  )
				{
					drop_pods_to_drop = 4;
					last_drop_number = 4;
					pod_value = "3";
				}
//				else if( drop_probability_info[0] <= 1  )
//				{
//					drop_pods_to_drop = 5;
//					last_drop_number = 5;
//					pod_value = "3";
//				}
//				else if( drop_probability_info[0] >= 3 )
//				{
//					drop_pods_to_drop = 0;
//				}
			}
			else
			{
				drop_pods_to_drop = 0;
			}
			
			if( drop_pods_to_drop == 0 )
			{
				wait 1; 
				continue;
			}
		
			drop_locations_sorted = getValidDropLocation(); //returns inplay, valid location arrays
	
			//incoming drop pod UI
			thread incomingDropPodMessaging();
			
			wait 2;
				
			for( i = 0; i < drop_pods_to_drop; i++ )
			{
				//select location
				drop_loc = selectDropLocation( drop_locations_sorted[1], pod_value );
				
				if( !isdefined( drop_loc ) )
				{
					wait 1;				
					continue;
				}
				
				drop_loc.inPlay = true;
				drop_locations_sorted[1] = array_remove( drop_locations_sorted[1], drop_loc );
				
				total_resource = 10;
				
				//select point value
				switch( pod_value )
				{
					case "0":
					case "1":
						total_resource = 45;
						break;
					case "2":
						total_resource = 25;
						break;
					case "3":
						total_resource = 15;
						break;
					default:
						total_resource = 10;
						break;
				}

				//launch pod
				thread launchDropPod( drop_loc, total_resource );
				
				wait( RandomIntRange( 0, 4) );
			}

			wait 5;
		}
	}
}

getDropProbability()
{
	//returns 0 to 1. 1 is a must drop.
	prob = 0;
	//how many objectives are out
	obj_points = getObjectivePointsInPlay();
	
	if( !isdefined( obj_points ) )
	{
		prob = 1;
	}
	//what is the remaining points of the objectives out
	resources_remaining = 0;
	foreach( obj in obj_points )
	{
		resources_remaining += obj.totalResource;
	}
	
	//as the remaining resources approach zero, the chances of launching a pod goes up.
	
	//have up to 200 points out at a time.
	prob_limit = getDvarInt( "scr_drop_prob_limit", 25 );
	
	prob = 1 - ( resources_remaining/prob_limit );
	
	return [ obj_points.size, prob ];
	
	/*
	score_limit = getScoreLimit();
	axis_score = GetTeamScore( "axis" );
	allies_score = GetTeamScore( "allies" );
	total_score = axis_score + allies_score;
	
	total_resources = resources_remaining + total_score;
	
	percent_complete = 0;
	if( isdefined( score_limit ) && score_limit > 0 )
	{
		percent_complete = resources_remaining/score_limit;
	}		
	*/
	//how much time is left in the match
	
	
}

//put the drop locations into in play or not in play
getValidDropLocation()
{
	valid_loc = [];
	in_play_loc = [];
	
	//get the drop ents and put them in an array
	drop_loc_array = GetEntArray( "drop_loc", "targetname" );
	AssertEx( isdefined( drop_loc_array ), "Drop has not been setup in this map" );

	//sort the drop locations if they are in play or not
	foreach( loc in drop_loc_array )
	{
		if( isDefined( loc.inPlay ) )
			in_play_loc[ in_play_loc.size ] = loc;
		else
			valid_loc[ valid_loc.size ] = loc;
	}
	
	return [ in_play_loc, valid_loc ];
}

//take the drop locations and get ones with the set value
getDropLocationsWithValue( valid_loc, drop_value )
{
	loc_array = [];
		
	foreach( drop_loc in valid_loc)
	{
		if( drop_loc.script_parameters == drop_value )
		{
			loc_array[ loc_array.size ] = drop_loc;
		}
	}
	
	return loc_array;
}

selectDropLocation( valid_loc_array, value )
{
	//drop locations have priorities, level 1 - high traffic, 2 - around high traffic, 3 out of the way.
	//script_parameters = 1, 2, or 3
	//starting objectives are script_parameters 0
	drop_array = getDropLocationsWithValue( valid_loc_array, value );
	//could change this to be infulenced by where players are in the map.
	drop_loc = random( drop_array );
	return drop_loc;
}

launchDropPod( drop_loc, total_resource )
{
	source = getent( drop_loc.target, "targetname" );
	//drop_pod = MagicBullet( "orbital_drop_pod_mp", source.origin, drop_loc.origin );
	drop_pod = MagicBullet( "drop_pod_mp", source.origin, drop_loc.origin );
	
	drop_pod dropPodMinimapIcon();
	
	
	drop_pod waittill( "death" );
	
	if( IsDefined( drop_pod.objID ) )
		_objective_delete( drop_pod.objID );
	
	activateObjectivePoint( drop_loc, total_resource );
}

dropPodMinimapIcon()
{
	currentObj = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( currentObj, "invisible", (0,0,0) );
	objective_OnEntity( currentObj, self );
	objective_state( currentObj, "active" );
	objective_team( currentObj, "none" );
	objective_icon( currentObj, "remotemissile_target_hostile" );
	self.objID = currentObj;	
}



//---- Objective points ----//
setupObjectivePoints()
{
	//get the drop pod assets, max of 9 at the moment
	drop_pod_asset_array = getEntArray( "drop_obj", "targetname" );
	
	level.objectivePoints = [];
	
	foreach( drop_pod_asset in drop_pod_asset_array )
	{
		obj_point = objectivePointCreate( drop_pod_asset );
		
		level.objectivePoints[ level.objectivePoints.size ] = obj_point;
	}
	
}

getObjectivePoint()
{
	foreach( drop_pod in level.objectivePoints )
	{
		if( isdefined( drop_pod.inPlay ) )
			continue;
		
		return drop_pod;
	}
	
	AssertMsg( "All Drop Pods are in play, max count is 9" );
}

getObjectivePointsInPlay()
{
	obj_points_in_play = [];
	foreach( drop_pod in level.objectivePoints )
	{
		if( isdefined( drop_pod.inPlay ) )
			obj_points_in_play[obj_points_in_play.size] = drop_pod;
	}
	
	return obj_points_in_play;
}

activateObjectivePoint( drop_loc, totalResource )
{
	team = "neutral";

	obj_origin = setOriginOnGround( drop_loc.origin );
	
	if( !IsDefined( obj_origin ) )
	{
		return;
	}
	
	capture_point = getObjectivePoint();
	
	capture_point.inPlay = true;
	capture_point.drop_loc = drop_loc;
	capture_point setObjectivePosition( obj_origin );
	capture_point maps\mp\gametypes\_gameobjects::allowUse( "any" );
	capture_point maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	capture_point maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_captureneutral");
	capture_point maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_captureneutral" );
	capture_point maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_captureneutral");
	capture_point maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral");
	capture_point.totalResource = totalResource;
	capture_point thread monitorScoring();

	//TODO: need to spawn the fx
	/*
	traceStart = capture_point.visuals[0].origin + (0,0,32);
	traceEnd = capture_point.visuals[0].origin + (0,0,-32);
	trace = bulletTrace( traceStart, traceEnd, false, undefined );

	upangles = vectorToAngles( trace["normal"] );
	capture_point.baseeffectforward = anglesToForward( upangles );
	capture_point.baseeffectright = anglesToRight( upangles );
	
	capture_point.baseeffectpos = trace["position"];
	*/
}

deactivateObjectivePoint()
{
	
	self setObjectivePosition( self.inactive_location );
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
	self.inPlay = undefined;
	self.drop_loc.inPlay = undefined;
	self maps\mp\gametypes\_gameobjects::allowUse( "none" );		
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	
}


setOriginOnGround( origin )
{
	traceStart = origin + (0,0,32);
	traceEnd = origin + (0,0,-128);
	trace = bulletTrace( traceStart, traceEnd, false, undefined );
	
	if( trace[ "fraction" ] == 1 )
	{
		//trace ended without hitting anything
		return undefined;
	}
	else
	{
		return trace["position"];
	}
}


objectivePointCreate( drop_pod )
{
	team = "neutral";
	
	//	get the trigger and visuals for the bombsite
	trigger = drop_pod;
	visuals = getEntArray( drop_pod.target, "targetname" );
	usetrigger = getEnt( visuals[0].target, "targetname" );
	collision = getEnt( usetrigger.target, "targetname" );
	
	inactive_location = trigger.origin;
	
	capture_point = maps\mp\gametypes\_gameobjects::createUseObject( team, trigger, visuals, (0,0,100) );
	capture_point maps\mp\gametypes\_gameobjects::setUseTime( 1 );
	capture_point maps\mp\gametypes\_gameobjects::setUseText( &"MP_HACKING_DROP_POD" );
	capture_point maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_HACK_DROP_POD" );
	capture_point maps\mp\gametypes\_gameobjects::allowUse( "none" );		
	capture_point maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	
	capture_point.onUse = ::onUse;
	capture_point.onBeginUse = ::onBeginUse;
	capture_point.onUseUpdate = ::onUseUpdate;
	capture_point.onEndUse = ::onEndUse;
	capture_point.useWeapon = "briefcase_bomb_mp";
	capture_point.collision = collision;
	capture_point.inactive_location = inactive_location;
	
	return capture_point;
}

setObjectivePosition( new_pos )
{
	self.trigger.origin = new_pos;
	self.visuals[0].origin = new_pos;
	self.collision.origin = new_pos;
	self.curOrigin = new_pos;
	
	foreach( point in self.objpoints )
	{
		point maps\mp\gametypes\_objpoints::updateOrigin( ( new_pos[0], new_pos[1], new_pos[2] + 100 )  );
	}
	//update compass doesn't update the position unless it's a carryobj
	objective_position( self.objIDAxis, new_pos );
	objective_position( self.objIDAllies, new_pos );
}

onUse( player )
{

}

onBeginUse( player )
{
	team = player.pers["team"];

	//If the user of the flag is on the same team (the user is starting to score a point for their team).
	if (self.ownerTeam == player.pers["team"])
	{
		//"Your team is taking the enemy flag."
		//thread leaderDialog( "drop_hacking_drop_pod", team, "status" );
		//"The enemy is taking your flag."
		//thread leaderDialog( "enemy_taking_b", getOtherTeam(team ), "status" );
	}
	//Else the user of the flag is starting to reset the flag for their team.
	else
	{
		//"Your team is resetting its own flag."
		//thread leaderDialog( "securing_b", team, "status" );
		//"Your enemies are resetting their team's flag."
		//thread leaderDialog( "losing_a", getOtherTeam(team ), "status" );
		thread playSoundOnPlayers( "drop_hacking_drop_pod", team );
	}
}

onUseUpdate( team, progress, change )
{
	
}

onEndUse( team, player, success )
{
	if( success )
	{
		self maps\mp\gametypes\_gameobjects::setOwnerTeam( team );
		self maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		
		self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_defend" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );
	
		self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_capture");
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_capture");
		
		thread playSoundOnPlayers( "drop_secured_drop_pod", getOtherTeam(team ));
	}
}

onCantUse( player )
{
	player iPrintLnBold( &"MP_BOMBSITE_IN_USE" );
}


onUseObject( player )
{
	team = player.pers["team"];
	otherTeam = level.otherTeam[team];

	self.bombPlanted = true;
	player notify ( "bomb_planted" );
	player playSound( "mp_bomb_plant" );

	//thread teamPlayerCardSplash( "callout_bombplanted", player );
	
	//player notify ( "objective", "plant" );
	
	//iPrintLn( &"MP_EXPLOSIVES_PLANTED_BY", player );
	leaderDialog( "bomb_planted" );

	player thread maps\mp\gametypes\_hud_message::SplashNotify( "plant", maps\mp\gametypes\_rank::getScoreInfoValue( "plant" ) );
	player thread maps\mp\gametypes\_rank::giveRankXP( "plant" );
	maps\mp\gametypes\_gamescore::givePlayerScore( "plant", player );		
	player incPlayerStat( "bombsplanted", 1 );
	player thread maps\mp\_matchdata::logGameEvent( "plant", player.origin );
	player.bombPlantedTime = getTime();
	
	player incPersStat( "plants", 1 );
	player maps\mp\gametypes\_persistence::statSetChild( "round", "plants", player.pers["plants"] );

	//level thread bombPlanted( self, player );

	level.bombOwner = player;
	self.useWeapon = "briefcase_bomb_defuse_mp";
}


//---- Scoring ----//

monitorScoring()
{

	self thread showScoreHUD( "allies" );
	self thread showScoreHUD( "axis" );
	
	while( self.totalResource > 0 )
	{
		if( self.ownerTeam != "neutral" ) 
		{
			maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( self.ownerTeam, 1 );
			self.totalResource -= 1;
		}
		wait 1;
	}
	
	self notify( "drop_pod_secured" );		
	
	//remove the pod
	//move the assets back to the original location
	//set the inUse back to undefined
	self deactivateObjectivePoint();
	
}

showScoreHUD( team )
{
	hudElem = NewTeamHudElem( team );
	//hudElem = NewClientHudElem( player );
	hudElem.positioninworld = true;
	//hudElem.origin = self.curOrigin;
	//hudElem SetTargetEnt( self.drop_loc );
	//hudElem setWaypoint( true, true, true );
	hudElem.children = [];
	self.objPoints[ team ].children = [];
	self.objPoints[ team ].width = 32;
	self.objPoints[ team ].height = 32;
	hudElem.elemType = "value";
	hudElem.point = "TOP";
	hudElem.relativePoint = "BOTTOM";
	hudElem.xOffset =0;
	hudElem.yOffset =0;
	hudElem.width = 32;
	hudElem.height = 32;
	hudElem.team = team;
	//hudElem setParent( self.objPoints[ team ] );
	//hudElem.y -= 100;
	hudElem.x = self.objPoints[ team ].x;
	hudElem.y = self.objPoints[ team ].y;
	hudElem.z = self.objPoints[ team ].z;
	hudElem.fontscale = 1.5;
	self thread monitorScoreHUD( hudElem );
	
	self waittill( "drop_pod_secured" );
	hudElem destroy();
}


monitorScoreHUD( hudElem )
{
	self endon( "drop_pod_secured" );
	
	
	//hudElem childthread scale_3d_hud_elem( self.trigger, player );
	//hudElem childthread offset_3d_hud_elem( self.trigger, player );
	
//	max_value = self.TotalResource;
//	if( !max_value ) 
//		max_value = 1;
//	
	while( 1 )
	{
		//Print3d( self.trigger.origin + ( 0,0,75 ), self.totalResource, ( 1.0, 1.0, 1.0 ), 1, 1.5, 1 );
		//cur_val = self.totalResource;
		//ratio = cur_val / max_value;
		hudElem SetValue( self.totalResource );
		if( self.ownerTeam == "neutral" )
		{
			hudElem.color = ( 1, 1, 1 );
		}
		else if( self.ownerTeam == hudElem.team )
		{
			hudElem.color = ( 0, 1, 0 );
		}
		else
		{
			hudElem.color = ( 1, 0, 0 );
		}
		/*
		if( self.totalResource >= 75 )
			hudElem SetText( "FULL" );
		else if ( self.totalResource > 50 )
			hudElem SetText( "LOTS" );
		else if ( self.totalResource > 25 )
			hudElem SetText( "SOME" );
		else
			hudElem SetText( "FEW" );		
		*/
		//hudElem.x = self.trigger.origin[0];
		//hudElem.y = -100;
		//hudElem.z = self.trigger.origin[2] + 75;
		//hudElem.horzalign = "center";
		//hudElem.vertalign = "fullscreen";
		//hudElem.color = ( 1 - ratio, ratio, 0 );
		
		
		
		wait .1;
	}
	
}


incomingDropPodMessaging()
{
	//incoming drop pod
	incomingNotification = createServerFontString( "hudbig", 1 );
	incomingNotification settext( &"MP_INCOMING_DROP_POD" );
	incomingNotification setPoint( "TOP", "CENTER", 0, -100 );
	incomingNotification.sort = 1001;
	incomingNotification.color = (1,1,0);
	incomingNotification.foreground = false;
	incomingNotification.hidewheninmenu = true;
	
	incomingNotification maps\mp\gametypes\_hud::fontPulseInit( 1.5 );
	thread playSoundOnPlayers( "drop_incoming_drop_pods" );
	
	display_Internal( 3, incomingNotification );
	incomingNotification destroyElem();
}

display_Internal( countTime, matchStartTimer )
{
	waittillframeend; // wait till cleanup of previous start timer if multiple happen at once
	
	while ( countTime > 0 && !level.gameEnded )
	{
		matchStartTimer thread maps\mp\gametypes\_hud::fontPulse( level );
		wait ( matchStartTimer.inFrames * 0.05 );
		//matchStartTimer setValue( countTime );
		countTime--;
		wait ( 1 - (matchStartTimer.inFrames * 0.05) );
	}
}

/* 
 ============= 
///ScriptDocBegin
"Name: linear_map(<x>, <in_a>, <in_b>, <out_a>, <out_b>)"
"Summary: Returns <x>, linearly mapped such that <in_a> maps to <out_a>, <in_b> maps to <out_b>, and other values are interpolated."
"MandatoryArg: <x> : the input value, a float or int"
"MandatoryArg: <in_a> : one endpoint of the input range.  If x == in_a, the return value will be out_a"
"MandatoryArg: <in_b> : one endpoint of the input range.  If x == in_b, the return value will be out_b"
"MandatoryArg: <out_a> : one endpoint of the output range"
"MandatoryArg: <out_b> : one endpoint of the output range"
"Example: degrees_c = linear_map(degrees_f, 32, 212, 0, 100);"
"Module: Utility (SHG)"
"SPMP: both"
///ScriptDocEnd
 ============= 
*/
linear_map(x, in_a, in_b, out_a, out_b)
{
	AssertEx(in_b - in_a != 0, "input range must have nonzero length");
	return out_a + (x - in_a) * (out_b - out_a) / (in_b - in_a);
}

/* 
 ============= 
///ScriptDocBegin
"Name: linear_map_clamp(<x>, <in_a>, <in_b>, <out_a>, <out_b>)"
"Summary: Returns <x>, linearly mapped such that <in_a> maps to <out_a>, <in_b> maps to <out_b>, and other values are interpolated.  Will never return a value outside the range specified by <out_a> and <out_b> (inclusive)."
"MandatoryArg: <x> : the input value, a float or int"
"MandatoryArg: <in_a> : one endpoint of the input range.  If x == in_a, the return value will be out_a"
"MandatoryArg: <in_b> : one endpoint of the input range.  If x == in_b, the return value will be out_b"
"MandatoryArg: <out_a> : one endpoint of the output range"
"MandatoryArg: <out_b> : one endpoint of the output range"
"Example: damage = linear_map(distance, 0, max_dist, max_damage, 0);"
"Module: Utility (SHG)"
"SPMP: both"
///ScriptDocEnd
 ============= 
*/
linear_map_clamp(x, in_a, in_b, out_a, out_b)
{
	return clamp(linear_map(x, in_a, in_b, out_a, out_b), min(out_a, out_b), max(out_a, out_b));
}

scale_3d_hud_elem(elem_tag, player)
{	
    self endon( "death" );
    while( true )
    {    
    	eyePos = player GetEye();
    	dist = Distance( elem_tag.origin, eyePos );
        self.fontscale = linear_map_clamp( dist, 16, 1024, 2.5, 1.5 );
        waitframe();
    }
} 

offset_3d_hud_elem(elem_tag, player)
{
    self endon( "death" );
    while( true )
    {    
    	eyePos = player GetEye();
    	dist = Distance( elem_tag.origin, eyePos );
        self.y = -1 * linear_map_clamp( dist, 16, 2048, 200, 80 );
        
        waitframe();
    }
} 