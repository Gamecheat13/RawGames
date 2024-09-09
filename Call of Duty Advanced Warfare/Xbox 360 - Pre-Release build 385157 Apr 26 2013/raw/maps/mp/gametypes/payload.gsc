#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Payload
	Objective: 	Win by moving objective marker to the cap point.
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
		issue with timelimit end if in the first round someone one then the next round runs out of time, it displays an extra point for the team who one the first round.
*/

/*QUAKED mp_ctf_spawn_axis (0.75 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_ctf_spawn_allies (0.0 0.75 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_ctf_spawn_axis_start (1.0 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_ctf_spawn_allies_start (0.0 1.0 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	if(getdvar("mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	/*
 	* 	types supported
 	* 	tug = flag in the middle both teams can push
 	* 	original = flag starts at 0 only attackers can push
	*/
	level.payload_type_default = "original";
	SetDvarIfUninitialized( "scr_payload_type", level.payload_type_default );
	level.payload_type = GetDvar( "scr_payload_type", level.payload_type_default );
	
	
	if ( isUsingMatchRulesData() )
	{
		level.initializeMatchRules = ::initializeMatchRules;
		[[level.initializeMatchRules]]();
		level thread reInitializeMatchRulesOnMigration();		
	}
	else
	{
		if( level.payload_type == "original" )
		{
			registerRoundSwitchDvar( level.gameType, 2, 0, 9 );
			registerTimeLimitDvar( level.gameType, 4 );
			registerScoreLimitDvar( level.gameType, 4 );
			registerRoundLimitDvar( level.gameType, 2 );
			registerWinLimitDvar( level.gameType, 0 );
			registerNumLivesDvar( level.gameType, 0 );
			registerHalfTimeDvar( level.gameType, 0 );
		}
		else
		{
		registerRoundSwitchDvar( level.gameType, 2, 0, 9 );
		registerTimeLimitDvar( level.gameType, 4 );
		registerScoreLimitDvar( level.gameType, 1 );
		registerRoundLimitDvar( level.gameType, 3 );
		registerWinLimitDvar( level.gameType, 2 );
		registerNumLivesDvar( level.gameType, 0 );
		registerHalfTimeDvar( level.gameType, 0 );
		}
		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;
	}
	
	setOverTimeLimitDvar( 4 );

	
	level.teamBased = true;
	level.objectiveBased = true;
	level.overtimeScoreWinOverride = true;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onNormalDeath = ::onNormalDeath;
	level.onTimeLimit = ::onTimeLimit;
	level.onRespawnDelay = ::onRespawnDelay;


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
	
	if( level.payload_type == "original" )
	{
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	SetDynamicDvar( "scr_payload_roundswitch", 2 );
	registerRoundSwitchDvar( "payload", 2, 0, 9 );
		SetDynamicDvar( "scr_payload_roundlimit", 2 );
		registerRoundLimitDvar( "payload", 2 );		
		SetDynamicDvar( "scr_payload_winlimit", 0 );
		registerWinLimitDvar( "payload", 0 );			
		SetDynamicDvar( "scr_payload_halftime", 0 );
		registerHalfTimeDvar( "payload", 0 );
		SetDynamicDvar( "scr_payload_scorelimit", 4 );
		registerScoreLimitDvar( "payload", 4 );
	}
	else
	{
		//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
		SetDynamicDvar( "scr_payload_roundswitch", 2 );
		registerRoundSwitchDvar( "payload", 2, 0, 9 );
	SetDynamicDvar( "scr_payload_roundlimit", 3 );
	registerRoundLimitDvar( "payload", 3 );		
	SetDynamicDvar( "scr_payload_winlimit", 2 );
	registerWinLimitDvar( "payload", 2 );			
	SetDynamicDvar( "scr_payload_halftime", 0 );
	registerHalfTimeDvar( "payload", 0 );
	}
		
	SetDynamicDvar( "scr_payload_promode", 0 );	
}


onStartGameType()
{
	if( inOvertime() )
		game["switchedsides"] = !game["switchedsides"];
	
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
		
	if( level.payload_type == "tug" )
	{
	//	set scores to zero at beginning of every round, round wins is what counts to game win
	game["teamScores"][game["attackers"]] = 0;		
	setTeamScore( game["attackers"], 0 );	
	game["teamScores"][game["defenders"]] = 0;		
	setTeamScore( game["defenders"], 0 );	
	}
	
	setObjectiveText( "allies", &"OBJECTIVES_PAYLOAD" );
	setObjectiveText( "axis", &"OBJECTIVES_PAYLOAD" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_PAYLOAD" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_PAYLOAD" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_PAYLOAD_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_PAYLOAD_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_PAYLOAD_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_PAYLOAD_HINT" );

	initSpawns();
	
	level thread onPlayerConnect();	
	
	allowed[0] = level.gameType;
	allowed[1] = "airdrop_pallet";
	
	maps\mp\gametypes\_gameobjects::main(allowed);	
	thread payload();
}

initSpawns()
{
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_ctf_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_ctf_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_ctf_spawn_allies" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_ctf_spawn_axis" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
}


getSpawnPoint()
{
	if ( self.team == "allies" )
	{
		spawnTeam = game["attackers"];
	}
	else
	{
		spawnTeam = game["defenders"];
	}

	if ( level.inGracePeriod )
	{
		spawnPoints = getentarray("mp_ctf_spawn_" + spawnteam + "_start", "classname");		
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	return spawnPoint;
}

onRespawnDelay()
{
	if( level.payload_type_default != "original" )
		return;
	
	if( self.team == game["attackers"] )
	{
		return level.attacker_respawn_delay;
	}
	else
	{
		return level.defender_respawn_delay;
	}	
}
	
onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );
		
		//player setupObjectiveVFX();
	}
}

payload()
{
	level.attacker_respawn_delay = GetDvarInt( "scr_payload_attacker_respawn_delay", 2 );
	level.defender_respawn_delay = GetDvarInt( "scr_payload_attacker_respawn_delay", 7 );
	level.roundMod = game["roundsPlayed"] % 2;
	SetDvarIfUninitialized( "scr_payload_move_rate", 2 );
	

	level.checkpoint_index = 0;
	level.path_obj_start_index = 0;
	
	level.cover_drone = SpawnStruct();
	level.cover_drone.model = "moving_cover_standing_01";
	level.cover_drone.vehicleInfo = "cover_drone_mp";
	PreCacheModel( level.cover_drone.model );
	
	level.iconCaptureFlag3D = "waypoint_captureneutral";
	level.iconCaptureFlag2D = "waypoint_captureneutral";
	precacheShader( level.iconCaptureFlag3D );
	precacheShader( level.iconCaptureFlag2D );


	level.iconDefendFlag3D = "waypoint_escort";
	level.iconDefendFlag2D = "waypoint_escort";
	precacheShader( level.iconDefendFlag3D );
	precacheShader( level.iconDefendFlag2D );
	
	
	level.iconTarget3D = "waypoint_targetneutral";
	level.iconTarget2D = "waypoint_targetneutral";
	precacheShader( level.iconTarget3D );
	precacheShader( level.iconTarget2D );
	
	level.iconKill3D = "waypoint_target";
	level.iconKill2D = "waypoint_target";
	precacheShader( level.iconKill3D );
	precacheShader( level.iconKill2D );
	
	
	game["flagmodels"] = [];
	game["flagmodels"]["none"] = "prop_flag_neutral";
	game["flagmodels"]["neutral"] = "prop_flag_neutral";
	game["flagmodels"]["axis"] = maps\mp\gametypes\_teams::getTeamFlagModel( "axis" );
	game["flagmodels"]["allies"] = maps\mp\gametypes\_teams::getTeamFlagModel( "allies" );
	precacheModel( game["flagmodels"]["allies"] );
	precacheModel( game["flagmodels"]["axis"] );
	precacheModel( game["flagmodels"]["neutral"] );
	
	level._effect[ "path_vfx_greeen" ] 					= loadfx( "misc/ui_payload_path_green" );
	
	path = getObjectivePath();

	//thread showObjectivePath( path );
	setupEndPoints( path );
	
	obj_start_point = ( 0,0,0 );
	path_obj_start_index = 0;
	
	if( level.payload_type == "tug" )
	{
	for ( i = 0; i < path.size; i++ ) 
	{
		if( isdefined( path[ i ].script_noteworthy ) && path[ i ].script_noteworthy == "payload_obj_start_origin" )
		{
			obj_start_point = path[ i ].origin;
			path_obj_start_index = i;
			continue;
		}
	}
	}
	else if( level.payload_type == "original" )
	{
		obj_start_point = path[ 0 ].origin;
	}
	
	level.path_obj_start_index = path_obj_start_index;
	
	level.path_segments = getPathDistanceSegments( path, path_obj_start_index );
	
	level.path_distance = [];
	level.path_distance = getTotalPathDistances( path_obj_start_index );
	
	trigger = getEnt( "payload_obj", "targetname" );
	if( isdefined( obj_start_point ) )
		trigger.origin = obj_start_point;
	visuals[0] = getEnt( "payload_obj", "targetname" );
	visuals[0] = spawn( "script_model", trigger.origin );
	visuals[0].angles = VectorToAngles( path[1].origin - path[0].origin );
	//visuals[0] setModel( game["flagmodels"]["neutral"] );
	visuals[0] setModel( level.cover_drone.model );
	visuals[0] Solid();
	
	visuals[1] = spawn_tag_origin();
	visuals[1] show();
	visuals[1].origin = visuals[0].origin + ( 0, 0, 100 );
	visuals[1] LinkTo( visuals[0] );

	//missing a required tag
	//visuals[2] = SpawnVehicle( level.cover_drone.model, "cover_drone_mp", level.cover_drone.vehicleInfo, visuals[0].origin, visuals[0].origin );
	
	
	switch( level.payload_type )
	{
		case "tug":
			owner_team = "neutral";
			interact_team = "any";
			break;
		case "original":
			owner_team = game["attackers"];
			interact_team = "friendly";
			break;
		default:
			owner_team = "neutral";
			interact_team = "any";
			break;
	}
	
	objective = maps\mp\gametypes\_gameobjects::createUseObject( owner_team, trigger, visuals, (0,0,100) );
	objective maps\mp\gametypes\_gameobjects::allowUse( interact_team );
	objective maps\mp\gametypes\_gameobjects::setUseTime( 99999 );
	objective.noUseBar = true;
	objective maps\mp\gametypes\_gameobjects::setUseText( &"MP_SECURING_POSITION" );
	//label = domFlag maps\mp\gametypes\_gameobjects::getLabel();
	label = "_flag";
	objective.label = label;
	objective set2DIcon( "friendly", level.iconCaptureFlag2D );
	objective set3DIcon( "friendly", level.iconCaptureFlag2D );
	objective set2DIcon( "enemy", level.iconTarget2D );
	objective set3DIcon( "enemy", level.iconTarget3D );
	
	objective setVisibleTeam( "any" );
	objective.onUse = ::onUse;
	objective.onBeginUse = ::onBeginUse;
	objective.onUseUpdate = ::onUseUpdate;
	objective.onEndUse = ::onEndUse;
	
	objective.path = path;
	objective.path_current_index = path_obj_start_index;
	objective.path_next_index = path_obj_start_index + 1;
	objective.dist_from_start = 0;
	
	if( level.payload_type == "tug" )
		objective.icon = setupUI();
	
	level.objective = objective;
	
	thread setupPathVfx( path );
}


getDistanceFromCenterToCurrent( current_index, inc_to_next )
{
	dist = 0;
	path = level.path_segments;

	if( current_index > level.path_obj_start_index )
	{
		//on right 
		if( inc_to_next == 1 )
		{
			//moving right
			for( i = level.path_obj_start_index; i < current_index + 1; i++ )
			{
				dist += path[ i ][ i + 1 ];
			}
		}
		else
		{
			//moving left
			for( i = level.path_obj_start_index; i < current_index - 1; i++ )
			{
				dist += path[ i ][ i + 1 ];
			}
		}
	}
	else if( current_index < level.path_obj_start_index )
	{
		//on left
		if( inc_to_next == 1 )
		{
			//moving right
			for( i = current_index; i < level.path_obj_start_index; i++ )
			{
				dist += path[ i ][ i + 1 ];
			}
		}
		else
		{
			//moving left
			for( i = current_index - 1; i < level.path_obj_start_index; i++ )
			{
				dist += path[ i ][ i + 1 ];
			}
		}
	}
	else
	{
		//center
		if( inc_to_next == 1 )
		{
			//moving right
			//moving right
			for( i = level.path_obj_start_index; i < current_index + 1; i++ )
			{
				dist += path[ i ][ i + 1 ];
			}
		}
		else
		{
			//moving left
			for( i = current_index - 1; i < level.path_obj_start_index; i++ )
			{
				dist += path[ i ][ i + 1 ];
			}
		}
}

	return dist;
	
}

getObjectivePath()
{
	//needs "payload_obj_start_path", "targetname"
	//needs "payload_obj_start_origin", "script_noteworthy"
	
	path = [];
	
	path_start = getstruct( "payload_obj_start_path", "targetname" );
	
	path[ path.size ] = path_start;
	
	path_node = path_start;
	while( isdefined( path_node.target ) )
	{
		next_node = getstruct( path_node.target, "targetname" );
		path[ path.size ] = next_node;
		
		path_node = next_node;
	}
	
	return path;
}

getPathDistanceSegments( path, path_obj_start_index )
{
	path_distance = [];
	path_distance[0][1] = 0;

	for( i = 0; i < path.size - 1; i++ )
	{
		seg_dist = distance( path[ i ].origin, path[ i + 1 ].origin );
		path_distance[ i ][ i + 1 ] = seg_dist;
	}
	
	return path_distance;
}

getTotalPathDistances( path_obj_start_index )
{
	path_distance = [];
	path_distance[0] = 0;
	path_distance[1] = 0;
	
	path = level.path_segments;
	
	for( i = path_obj_start_index; i < path.size; i++ )
	{
		path_distance[ 1 ] += path[ i ][ i + 1 ];
	}
	
	//for axis path 0 - startpoint
	for( i = 0; i < path_obj_start_index; i++ )
	{
		path_distance[ 0 ] += path[ i ][ i + 1 ];
	}
	
	return path_distance;
}

checkPath( team )
{
	
	
	if( !isdefined( self.lastteamclaim ) )
    {
		if( level.roundMod == 0 )
   			self.lastteamclaim = "allies";
		else 
			self.lastteamclaim = "axis";
	}

	
	//if it's a new team flip the indexes.
	if( team != self.lastteamclaim )
	{
	   old_next = self.path_next_index;
	   old_current = self.path_current_index;
	   self.path_next_index = old_current;
	   self.path_current_index = old_next;
	   self.lastteamclaim = team;
	}

	if( level.payload_type == "tug" )
	{
		if( team == "axis" && level.roundMod == 0 || team == "allies" && level.roundMod == 1 )
			inc_to_next = -1;
		else
			inc_to_next = 1;
	}
	else if( level.payload_type == "original" )
	{
		if( team == "none" )
			inc_to_next = -1;
		else
			inc_to_next = 1;
	}
	else
	{
		if( team == "axis" && level.roundMod == 0 || team == "allies" && level.roundMod == 1 )
			inc_to_next = -1;
		else
			inc_to_next = 1;
	}
	
	
	//team check before getting distance
	dist_to_node = Distance( self.path[ self.path_next_index ].origin, self.visuals[0].origin );

	//Print3d( self.path[self.path_next_index ].origin,"dist: " + dist_to_node, ( 1, 1, 1 ), 1, 1, 1 );
	
	//update the ui icon on the bar.
	if( level.payload_type == "tug" )
		self.icon updateIconPos( dist_to_node, inc_to_next, self.path_current_index );
	
	if(  dist_to_node < 20 )
	{
		if( isdefined( self.path[ self.path_next_index + inc_to_next ] ) )
		{
			//objective has reached a new path node in the middle of the path.
			self.path_current_index = self.path_next_index;
			self.path_next_index = self.path_next_index + inc_to_next;
			
			if( level.payload_type == "original" )
			{
				if( isdefined( self.path[ self.path_current_index ].script_noteworthy ) && self.path[ self.path_current_index ].script_noteworthy == "payload_obj_checkpoint" )
				{
					if( level.checkpoint_index != self.path_current_index )
					{
						//give score
						self thread reachedCheckpoint();
						//grab index so it can't go back past the checkpoint.
						level.checkpoint_index = self.path_current_index;
					}
				}
			}
			return true;
		}
		else
		{
			//objective has reached the end of the path.
			if( level.payload_type == "original" )
			{
				if( team  == game["attackers"] )
					scorePoint( team );
			}
			else
			{
				scorePoint( team );
			}
			return true;
		}
	}
	
	if( self.path_current_index == level.checkpoint_index && self.path_next_index < self.path_current_index ) 
	{
		return true;
	}
	
	return false;

}

moveObjPoint( team, progress, change )
{
	//move obj to the nearest node for the correct team.
	//default to towards start node.
	
	moveRateMult = GetDvarFloat( "scr_payload_move_rate", 2 );
	
	if( !isdefined( self.claimTeamLast ) )
	{
		self.claimTeamLast = "none";
	}
	
	if( self.claimTeam != self.claimTeamLast )
	{
		if( level.payload_type == "tug" )
		{
			self setOwnerTeam( self.claimTeam );
			self set2DIcon( "enemy", level.iconCaptureFlag2D );
			self set3DIcon( "enemy", level.iconCaptureFlag3D );
		}
			
		if( level.payload_type == "original" )
		{
			if( self.claimTeam == "none" )
			{
				self set2DIcon( "friendly", level.iconCaptureFlag2D );
				self set3DIcon( "friendly", level.iconCaptureFlag2D );
				self set2DIcon( "enemy", level.iconTarget2D );
				self set3DIcon( "enemy", level.iconTarget3D );
			}
			else
			{
				self set2DIcon( "friendly", level.iconDefendFlag2D );
				self set3DIcon( "friendly", level.iconDefendFlag2D );
				self set2DIcon( "enemy", level.iconKill2D );
				self set3DIcon( "enemy", level.iconKill3D );
			}
		}
		
		//self.visuals[0] setModel( game["flagmodels"][self.claimTeam] );
		
		self.claimTeamLast = self.claimTeam;
	}
	

	move_to_current_node_org = self checkPath( self.claimTeam );//need to set up team
	
	
	dest = self.path[ self.path_current_index ].origin;
	
	if( level.payload_type == "original" && move_to_current_node_org == true )
	{
		if(  self.path_next_index == 0 ||  self.path_current_index == level.checkpoint_index && self.path_next_index < self.path_current_index )
			return;
	}
	
	if( IsDefined( move_to_current_node_org ) && move_to_current_node_org == false )
	{
		//get direction from path_current_index to path_next_index
		//move at X rate on the vector.
		vecNorm = VectorNormalize(  self.path[ self.path_next_index ].origin - self.path[ self.path_current_index ].origin );
		
		if( self.claimTeam == "none" )
		{
			numpts = moveRateMult;
		}
		else
		{
			numpts = self.useRate * moveRateMult;
		}
		
		dest = numpts * vecNorm + self.visuals[0].origin;
	}
	
	
	//trace = setPointToGround( dest, self.visuals[0] );
	
	//move the objective directly to the current node if we are within 20
	self.visuals[0] moveto( dest, .05 );
	self.trigger.origin = self.visuals[0].origin;
	
	if( self.path_current_index  < self.path_next_index )
	{
		angles = VectorToAngles( self.path[ self.path_next_index ].origin - self.path[ self.path_current_index ].origin );
	}
	else
	{
		angles = VectorToAngles( self.path[ self.path_current_index ].origin - self.path[ self.path_next_index ].origin );
	}
	
	self.visuals[0].angles = angles;
}

monitor_roll_back_timer()
{
	self endon( "stop_roll_back_timer" );
	
	wait 4;
	
	while( 1 )
	{
		moveObjPoint( "none", undefined, undefined );
		wait .05;
	}
	
}


//----UI----//


setupUI()
{
	//bar
	//payload location indicator.
	//payload start is considered the middle of the bar.
	//distance from payload start to beginning, distance to end
	//moved along path	
	
	bar = maps\mp\gametypes\_hud_util::createTeamProgressBar();
	icon = maps\mp\gametypes\_hud_util::createServerIcon( "waypoint_captureneutral", 10, 10 );
	icon setPoint( "center", "TOP", 0, 0, 0 );
	icon maps\mp\gametypes\_hud_util::setParent( bar );
	
	
	icon setupIcon( bar );
	
	return icon;
}

setupIcon( bar )
{
	width = bar.width;
	teamwidth = width/2;

	self.movement_limit = teamwidth - 10;  //-10 so it's not going all the way to the end of the bar
	
	self.move_rate_left = teamwidth / level.path_distance[ 0 ];
	self.move_rate_right = teamwidth / level.path_distance[ 1 ];
}

updateIconPos( seg_dist_to_next_node, inc_to_next, current_index )
{
	move_rate = 0;
	total_dist_to_next_point = getDistanceFromCenterToCurrent( current_index, inc_to_next );
	total_dist = 0;
	
	if( current_index > level.path_obj_start_index )
	{
		if( inc_to_next == 1 )
		{
			//moving right
			total_dist = total_dist_to_next_point - seg_dist_to_next_node;
		}
		else
		{
			//moving left
			total_dist = total_dist_to_next_point + seg_dist_to_next_node;	
		}
		
		//use move_rate_right
		move_rate = self.move_rate_right;
		position_on_bar = total_dist * move_rate;
	}
	else if( current_index < level.path_obj_start_index )
	{
		if( inc_to_next == 1 )
		{
			//moving right
			total_dist = total_dist_to_next_point + seg_dist_to_next_node;
		}
		else
		{
			//moving left
			total_dist = total_dist_to_next_point - seg_dist_to_next_node;
		}
		
		//use move_rate_left
		move_rate = self.move_rate_left;
		position_on_bar = total_dist * move_rate;
		position_on_bar *= -1;
	}
	else
	{
		total_dist = total_dist_to_next_point - seg_dist_to_next_node;
		
		if( inc_to_next == 1 )
		{
			//use move_rate_right
			move_rate = self.move_rate_right;
			position_on_bar = total_dist * move_rate;
		}
		else
		{
			//use move_rate_left
			move_rate = self.move_rate_left;
			position_on_bar = total_dist * move_rate;
			position_on_bar *= -1;
		}
	}
	self setPoint( "center", "TOP", position_on_bar, 0 );
}



//----VFX----//


showObjectivePath( path )
{
	while( 1 )
	{
		for( i = 0; i < path.size - 1; i++ )
		{
			Line( path[i].origin, path[ i + 1 ].origin, ( 1, 0, 0 ), 1, true, 1 );
		}
		wait .05;
	}
}

setupEndPoints( path )
{

	if( level.roundMod == 0 )
	{
		//original team - allies move towards 0
		team = "axis";
	}
	else
	{
		team = "allies";
	}
	
	if( level.payload_type == "original" )
	{
		setupEndPointVFX( path[ 0 ], getOtherTeam( team ) );
		setupEndPointVFX( path[ path.size - 1 ], getOtherTeam( team ) );
		foreach( node in path )
		{
			if( IsDefined( node.script_noteworthy ) && node.script_noteworthy == "payload_obj_checkpoint" )
			{
				setupEndPointVFX( node, getOtherTeam( team ) );
			}
		}
	}
	else
	{
	setupEndPointVFX( path[ 0 ], team );
	setupEndPointVFX( path[ path.size - 1 ], getOtherTeam( team ) );
}

}

setupEndPointVFX( point, team )
{
	trace = setPointToGround( point.origin );
	
	fx = maps\mp\gametypes\_teams::getTeamFlagFX( team );
	fxid = loadfx( fx );
	
	upangles = vectorToAngles( trace["normal"] );
	forward = anglesToForward( upangles );
	right = anglesToRight( upangles );
	
	thread spawnFxDelay( fxid, trace["position"], forward, right, 0.5 );
}

setPointToGround( point, ent_to_ignore )
{
	traceStart = point + (0,0,32);
	traceEnd = point + (0,0,-32);
	trace = bulletTrace( traceStart, traceEnd, false, ent_to_ignore );
	return trace;
}

spawnFxDelay( fxid, pos, forward, right, delay )
{
	wait delay;
	effect = spawnFx( fxid, pos, forward, right );
	triggerFx( effect );
}

setupObjectiveVFX()
{
	fx = maps\mp\gametypes\_teams::getTeamFlagFX( "axis" );
	fxid = loadfx( fx );
	wait 1;
	PlayFXOnTagForClients( fxid, level.objective.visuals[1], "tag_origin", self );
}


setupPathVfx( path )
{
		wait 5;
		drawVFXLine( path );
}
	
drawVFXLine( path )
{
	//how much space between fx there is
	distance_delta = 64;
	
	if( !isdefined( level.path_vfx ) )
		level.path_vfx = [];

	count = 0;
	
	for( i = 0; i < level.path_segments.size; i++ )
{
		dist_max = level.path_segments[ i ][ i + 1 ];
	
		//how far from the start point the fx should appear
		//starts at 64 because we already place an fx at the start point
		current_distance = 64;
	
		path_first_point = path[ i ].origin;
		path_second_point = path[ i + 1 ].origin;

		line_distance = dist_max;
		angles = vectortoangles( path_second_point - path_first_point );
		forward = anglestoforward( angles );
		vfx_angle = angles + (270,0,0);
		
		//spawn the vfx in the segment
		while(current_distance < line_distance)
    {
			count ++;
			fx_point = path_first_point + forward * current_distance;
	
			new_fx = spawn_tag_origin();
			new_fx show();
			new_fx.origin = fx_point + ( 0, 0, 10 );
			new_fx.angles = vfx_angle;
			//this is effectively the index in the line ( / distance_delta
			new_fx.dist = current_distance;
			new_fx.segment = i;
			array_idx = count;

			new_fx GetLineFx( );
			
			new_fx.start_delay = .1 * array_idx;
			
			if( current_distance == distance_delta && i == 0 ) //first thing in the line
			{
				level.path_vfx_start_time = GetTime();
   	}
	
			new_fx thread DelayedStartLineFx( array_idx );
			
			level.path_vfx[ level.path_vfx.size ] = new_fx;

			current_distance += distance_delta;
		}
	}
}

GetLineFx(  )
	{
		self.lineType = "green";
		self.vfx = "path_vfx_greeen";
		
	}

	
DelayedStartLineFx( line_idx )
	{
	assert( isdefined( self.start_delay ) );
	
	//if the lifetime of the vfx we are playing changes this fx_lifetime_sec must be updated!
	fx_lifetime_sec = 1;
	fx_lifetime_ms = fx_lifetime_sec * 1000;
	assert( isdefined( self.start_delay < fx_lifetime_sec ) );
	
	curr_time = GetTime();
	cycle_time_ms = curr_time - level.path_vfx_start_time;
	cycle_modded_ms = cycle_time_ms % fx_lifetime_ms;
	
	if( cycle_modded_ms > ( 1000 * self.start_delay ) )
		self.start_delay += fx_lifetime_sec;
	
	self.start_delay -= cycle_modded_ms / 1000;
		
	//to confirm we have a zero time not a negative time being generated
	//PS3 one time returned -5.96046e-08 so as long as the start delay is less than one frame in the past we're cool
	AssertEx( self.start_delay >= -0.05, "start_delay " + self.start_delay + " GetTime " + curr_time + " level.direction_line_start_time " + level.path_vfx_start_time + " cycle_modded_time_ms " + cycle_modded_ms + " line_idx " + line_idx );
	actual_wait = self.start_delay;
	
	if( actual_wait > 0  ) //its possible to generate a zero wait time
		wait actual_wait;
	
	if( isdefined( self ) )
		{
		assert( isdefined( self.vfx ) );
		//while( 1 )
		//{
		PlayFXOnTag( getfx( self.vfx ), self, "tag_origin" );
			//wait 4;
		//}
		}
}


//----Scoring----//

reachedCheckpoint()
{
	//score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	
	event = "kill_banked";
	splash = "CHECKPOINT REACHED";
	
	self.trigger playSound( "mp_killconfirm_tags_pickup" );
	
	foreach( guid in self.touchList[ game["attackers"] ] )
		{
		guid.player thread maps\mp\gametypes\_rank::xpEventPopup( splash );
		}

	maps\mp\gametypes\_gamescore::giveTeamScoreForObjective(  game["attackers"], 1 );
	setTeamScore( game[ "attackers" ], game[ "teamScores" ][ game["attackers"] ] );
}

scorePoint( team )
{
	maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( team, 1 );
	if( level.payload_type == "tug" )
	{
	checkRoundWin( team );
}
	else if( level.payload_type == "original" )
	{
		setTeamScore( game[ "attackers" ], game[ "teamScores" ][ game["attackers"] ] );
		checkRoundEnd( team );
	}
}


checkRoundWin( team )
{
	if ( inOvertime() )
	{
		level.finalKillCam_winner = team;
		thread maps\mp\gametypes\_gamelogic::endGame( team, game["strings"]["score_limit_reached"] );
	}	
	else if ( game["switchedsides"] )
	{
		if ( game["teamScores"][team] == getWatchedDvar( "scorelimit" ) )
		{				
			if ( game["roundsWon"][team] + 1 > game["roundsWon"][level.otherTeam[team]] )
			{				
				level.finalKillCam_winner = team;							
				thread maps\mp\gametypes\_gamelogic::endGame( team, game["strings"]["score_limit_reached"] );
			}
			else  
			{	
				//give winning team there round score since endgame doesn't do it for overtime/halftime.
				game["roundsWon"][team]++;
				game["roundsPlayed"]++;
				level.finalKillCam_winner = team;
				
				//probably don't need to do the set scores since we reset them after the map reset
				game["teamScores"]["axis"] = game["roundsWon"]["axis"];
				game["teamScores"]["allies"] = game["roundsWon"]["allies"];	
				setTeamScore( "axis", game["teamScores"]["axis"] );
				setTeamScore( "allies", game["teamScores"]["allies"] );					
				//	tie, go into overtime	
				level.finalKillCam_winner = "none";				
				thread maps\mp\gametypes\_gamelogic::endGame( "overtime", game["strings"]["score_limit_reached"] );
			}
		}
	}
	else
	{
		if ( game["teamScores"][team] == getWatchedDvar( "scorelimit" ) )
		{
			game["roundsWon"][team]++;	
			game["roundsPlayed"]++;			
			level.finalKillCam_winner = team;
			game["teamScores"]["axis"] = game["roundsWon"]["axis"];
			game["teamScores"]["allies"] = game["roundsWon"]["allies"];
			setTeamScore( "axis", game["teamScores"]["axis"] );
			setTeamScore( "allies", game["teamScores"]["allies"] );	
			
			thread maps\mp\gametypes\_gamelogic::endGame( "halftime", game["strings"]["score_limit_reached"] );	
		}	
	}
}

checkRoundEnd( team )
{
	//give winning team there round score since endgame doesn't do it for overtime/halftime.
	game["roundsWon"]["axis"] = game["teamScores"]["axis"];
	game["roundsWon"]["allies"] = game["teamScores"]["allies"];

	if ( inOvertime() )
	{
		//should not happen
		level.finalKillCam_winner = team;		
		thread maps\mp\gametypes\_gamelogic::endGame( team, game["strings"]["score_limit_reached"] );
	}	
	else if ( game["switchedsides"] )
	{
		if ( game["teamScores"][team] == getWatchedDvar( "scorelimit" ) )
		{				
			if ( game["teamScores"][team] > game["teamScores"][level.otherTeam[team]] )
			{				
				game["roundsWon"][team] --;//removing a round because end game will add another one
				level.finalKillCam_winner = team;							
				thread maps\mp\gametypes\_gamelogic::endGame( team, game["strings"]["score_limit_reached"] );
			}
			else  
			{	
				game["roundsPlayed"]++;
				level.finalKillCam_winner = team;
				
				//	tie
				level.finalKillCam_winner = "none";				
				thread maps\mp\gametypes\_gamelogic::endGame( "tie", game["strings"]["score_limit_reached"] );
			}
		}
	}
	else
	{
		if ( game["teamScores"][team] == getWatchedDvar( "scorelimit" ) )
		{	
			game["roundsPlayed"]++;			
			level.finalKillCam_winner = team;
			
			thread maps\mp\gametypes\_gamelogic::endGame( "halftime", game["strings"]["score_limit_reached"] );	
		}	
	}
}


onTimeLimit()
{
	switch( level.payload_type )
	{
		case "tug":
			onTimelimitTug();
			break;
		case "original":
			onTimelimitOriginal();
			break;
		default:
			onTimelimitTug();
			break;
	}
}
	
onTimelimitTug()
{
	if ( inOvertime() )
	{
		game["teamScores"]["axis"] = game["roundsWon"]["axis"];
		game["teamScores"]["allies"] = game["roundsWon"]["allies"];	
		setTeamScore( "axis", game["teamScores"]["axis"] );
		setTeamScore( "allies", game["teamScores"]["allies"] );				
		level.finalKillCam_winner = "none";
		thread maps\mp\gametypes\_gamelogic::endGame( "tie", game["strings"]["time_limit_reached"] );
	}	
	else if ( game["switchedsides"] )
	{
		//	whoever is winning wins the round //should never happen
		if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
			game["roundsWon"]["axis"]++;
		else if ( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
			game["roundsWon"]["allies"]++;	
			
		game["teamScores"]["axis"] = game["roundsWon"]["axis"];
		game["teamScores"]["allies"] = game["roundsWon"]["allies"];		
		setTeamScore( "axis", game["teamScores"]["axis"] );
		setTeamScore( "allies", game["teamScores"]["allies"] );
		
		if ( game["roundsWon"]["axis"] > game["roundsWon"]["allies"] )
		{
			//	win game
			level.finalKillCam_winner = "axis";
			thread maps\mp\gametypes\_gamelogic::endGame( "axis", game["strings"]["time_limit_reached"] );
			return;
		}
		else if ( game["roundsWon"]["allies"] > game["roundsWon"]["axis"] )	
		{
			//	win game
			level.finalKillCam_winner = "allies";
			thread maps\mp\gametypes\_gamelogic::endGame( "allies", game["strings"]["time_limit_reached"] );
			return;
		}
		else
		{
			//	tie, go into overtime
			game["roundsPlayed"]++;  //adding here since halftime does not tick rounds played
			level.finalKillCam_winner = "none";
			thread maps\mp\gametypes\_gamelogic::endGame( "overtime", game["strings"]["time_limit_reached"] );			
		}					
	}
	else
	{
		//	whoever is winning wins the round, tie goes to neither, endgame( "overtime" ) doesn't touch rounds won so update them
		if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		{
			game["roundsWon"]["axis"]++;
			level.finalKillCam_winner = "axis";
		}
		else if ( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
		{			
			game["roundsWon"]["allies"]++;
			level.finalKillCam_winner = "allies";
		}
		else
		{		
			level.finalKillCam_winner = "none";
			game["roundsPlayed"]++; //adding here since halftime does not tick rounds played
		}		
		game["teamScores"]["axis"] = game["roundsWon"]["axis"];
		game["teamScores"]["allies"] = game["roundsWon"]["allies"];
		setTeamScore( "axis", game["teamScores"]["axis"] );
		setTeamScore( "allies", game["teamScores"]["allies"] );
		thread maps\mp\gametypes\_gamelogic::endGame( "halftime", game["strings"]["time_limit_reached"] );				
	}
}

onTimelimitOriginal()
{
	//give winning team there round score since endgame doesn't do it for overtime/halftime.
	game["roundsWon"]["axis"] = game["teamScores"]["axis"];
	game["roundsWon"]["allies"] = game["teamScores"]["allies"];

	if ( inOvertime() )
{
		//should not get here
		/*
		game["teamScores"]["axis"] = game["roundsWon"]["axis"];
		game["teamScores"]["allies"] = game["roundsWon"]["allies"];	
		setTeamScore( "axis", game["teamScores"]["axis"] );
		setTeamScore( "allies", game["teamScores"]["allies"] );				
		level.finalKillCam_winner = "none";
		thread maps\mp\gametypes\_gamelogic::endGame( "tie", game["strings"]["time_limit_reached"] );
		*/
}
	else if ( game["switchedsides"] )
{
		//	whoever is winning wins the round
		if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		{
			game["roundsWon"]["axis"]--;
			level.finalKillCam_winner = "axis";
			thread maps\mp\gametypes\_gamelogic::endGame( "axis", game["strings"]["time_limit_reached"] );
			return;
		}
		else if ( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
		{
			game["roundsWon"]["allies"]--;	
			level.finalKillCam_winner = "allies";
			thread maps\mp\gametypes\_gamelogic::endGame( "allies", game["strings"]["time_limit_reached"] );
			return;
		}
		else
		{
			game["roundsPlayed"]++;  //adding here since halftime does not tick rounds played
			level.finalKillCam_winner = "none";
			thread maps\mp\gametypes\_gamelogic::endGame( "tie", game["strings"]["time_limit_reached"] );	
		}		
	}
	else
	{
		//	whoever is winning wins the round, tie goes to neither, endgame( "overtime" ) doesn't touch rounds won so update them
		if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		{
			//game["roundsWon"]["axis"]--;
			level.finalKillCam_winner = "axis";
		}
		else if ( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
		{			
			//game["roundsWon"]["allies"]--;
			level.finalKillCam_winner = "allies";
		}
		else
		{		
			level.finalKillCam_winner = "none";
			
		}		
		 //adding here since halftime does not tick rounds played
		game["roundsPlayed"]++;
		thread maps\mp\gametypes\_gamelogic::endGame( "halftime", game["strings"]["time_limit_reached"] );				
	}
}
	
	
//----Call backs from gameobject ----//
	
onUse( player )
	{
	
	}
	
onBeginUse( player )
	{
	self notify( "stop_roll_back_timer" );
	player NearObjectiveBonusGive();
	}
	
onUseUpdate( team, progress, change )
{
	self notify( "stop_roll_back_timer" );
	moveObjPoint( team, progress, change );
}
	
onEndUse( team, player, success )
{
	if( level.payload_type == "original" )
	{
		self thread monitor_roll_back_timer();
	
		player notify( "near_objective_bonus_remove" );
	}
	
}


onNormalDeath( victim, attacker, lifeId )
{

}


NearObjectiveBonusGive()
{
	self notify( "near_objective_bonus" );
	if( !isdefined( self.hasObjectiveBonus ) )
	{
		self thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( "all_perks_bonus" );
		self maps\mp\killstreaks\_killstreaks::giveAllPerks();
	}
	self thread NearObjectiveBonusRemove();

}

NearObjectiveBonusRemove()
{
	self endon( "near_objective_bonus" );
	self.hasObjectiveBonus = true;
	
	self waittill( "near_objective_bonus_remove" );
	
	wait 2; //give the player a little time if he is out of the radius so it doesn't constantly ping
	
	self.hasObjectiveBonus = undefined;
}

//ICONS
//wholesale copy from _gameobjects to get rid of the carryobject

setOwnerTeam( team )
{
	self.ownerTeam = team;
	//self updateTrigger();	
	self updateCompassIcons();
	self updateWorldIcons();
}


set2DIcon( relativeTeam, shader )
{
	self.compassIcons[relativeTeam] = shader;
	updateCompassIcons();
}

set3DIcon( relativeTeam, shader )
{
	self.worldIcons[relativeTeam] = shader;
	updateWorldIcons();
}

setVisibleTeam( relativeTeam )
{
	self.visibleTeam = relativeTeam;

	updateCompassIcons();
	updateWorldIcons();
}

updateCompassIcons()
{
	if ( self.visibleTeam == "any" )
	{
		updateCompassIcon( "friendly", true );
		updateCompassIcon( "enemy", true );
	}
	else if ( self.visibleTeam == "friendly" )
	{
		updateCompassIcon( "friendly", true );
		updateCompassIcon( "enemy", false );
	}
	else if ( self.visibleTeam == "enemy" )
	{
		updateCompassIcon( "friendly", false );
		updateCompassIcon( "enemy", true );
	}
	else
	{
		updateCompassIcon( "friendly", false );
		updateCompassIcon( "enemy", false );
	}
}


updateCompassIcon( relativeTeam, showIcon )
{
	updateTeams = maps\mp\gametypes\_gameobjects::getUpdateTeams( relativeTeam );
	
	for ( index = 0; index < updateTeams.size; index++ )
	{
		showIconThisTeam = showIcon;
		if ( !showIconThisTeam && maps\mp\gametypes\_gameobjects::shouldShowCompassDueToRadar( updateTeams[ index ] ) )
			showIconThisTeam = true;
		
		objId = self.objIDAllies;
		if ( updateTeams[ index ] == "axis" )
			objId = self.objIDAxis;
		
		if ( !isDefined( self.compassIcons[relativeTeam] ) || !showIconThisTeam )
		{
			objective_state( objId, "invisible" );
			continue;
		}
		
		objective_icon( objId, self.compassIcons[relativeTeam] );
		objective_state( objId, "active" );
		
		objective_onentity( objId, self.visuals[0] );
		
	}
}



updateWorldIcons()
{
	if ( self.visibleTeam == "any" )
	{
		updateWorldIcon( "friendly", true );
		updateWorldIcon( "enemy", true );
	}
	else if ( self.visibleTeam == "friendly" )
	{
		updateWorldIcon( "friendly", true );
		updateWorldIcon( "enemy", false );
	}
	else if ( self.visibleTeam == "enemy" )
	{
		updateWorldIcon( "friendly", false );
		updateWorldIcon( "enemy", true );
	}
	else
	{
		updateWorldIcon( "friendly", false );
		updateWorldIcon( "enemy", false );
	}
}


updateWorldIcon( relativeTeam, showIcon )
{
	if ( !isDefined( self.worldIcons[relativeTeam] ) )
		showIcon = false;
	
	updateTeams = maps\mp\gametypes\_gameobjects::getUpdateTeams( relativeTeam );
	
	for ( index = 0; index < updateTeams.size; index++ )
	{
		opName = "objpoint_" + updateTeams[index] + "_" + self.entNum;			
		objPoint = maps\mp\gametypes\_objpoints::getObjPointByName( opName );
		
		objPoint notify( "stop_flashing_thread" );
		objPoint thread maps\mp\gametypes\_objpoints::stopFlashing();
		
		if ( showIcon )
		{
			objPoint setShader( self.worldIcons[relativeTeam], level.objPointSize, level.objPointSize );
			objPoint fadeOverTime( 0.05 ); // overrides old fadeOverTime setting from flashing thread
			objPoint.alpha = objPoint.baseAlpha;
			objPoint.isShown = true;

			if ( isDefined( self.compassIcons[relativeTeam] ) )
				objPoint setWayPoint( true, true );
			else
				objPoint setWayPoint( true, false );
				
			if ( isDefined( self.visuals[1] ) )
				objPoint SetTargetEnt( self.visuals[1] );
			else
				objPoint ClearTargetEnt();
			
		}
		else
		{
			objPoint fadeOverTime( 0.05 );
			objPoint.alpha = 0;
			objPoint.isShown = false;
			objPoint ClearTargetEnt();
		}
		
		objPoint thread maps\mp\gametypes\_gameobjects::hideWorldIconOnGameEnd();
	}
}
