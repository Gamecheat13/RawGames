#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\mp\_clientflags.gsh;

/*
	Hacker

	Objective: 	Hack talons to kill enemy players
	Map ends:	Score / Time Limit
	Respawning:	Deathmatch rules
*/

#define AI_TANK_PATH_TIMEOUT			45

#define HEAD_ICON_SHOW_MINE		0
#define HEAD_ICON_SHOW_ENEMY	1
#define HEAD_ICON_SHOW_BOTH		2
	
main()
{
	if(GetDvar( "mapname") == "mp_background")
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	registerTimeLimit( 0, 1440 );
	registerScoreLimit( 0, 50000 );
	registerRoundLimit( 0, 10 );
	registerRoundWinLimit( 0, 10 );
	registerNumLives( 0, 10 );

	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );

	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );
	
	level.scoreRoundBased = ( GetGametypeSetting( "roundscorecarry" ) == false );
	level.teamBased = false;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onEndGame= ::onEndGame;
	level.onRoundEndGame = ::onRoundEndGame;
	level.giveCustomLoadout = ::giveCustomLoadout;
	level.customLoadoutScavenge = ::customLoadoutScavenge;
	level.onPlayerScore = ::onPlayerScore;
	level.onPlayerDamage = ::onPlayerDamage;

	game["dialog"]["gametype"] = "hack_start";
	game["dialog"]["offense_obj"] = "hack_obj";
	game["dialog"]["defense_obj"] = "hack_obj";
	game["dialog"]["hack_link"] = "hack_link";
	game["dialog"]["hack_hacked"] = "hack_hacked";

	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths", "agrkills", "hacks" ); 
}


onPrecacheGameType()
{
	precacheShader( "compass_waypoint_captureneutral" );
	precacheShader( "compass_waypoint_capture_white" );
	precacheShader( "compass_waypoint_defend_white" );

	precacheShader( "waypoint_captureneutral" );
	precacheShader( "waypoint_capture" );
	precacheShader( "waypoint_defend" );

	precacheShader( "hud_waypoint_capture_team1" );
	precacheShader( "hud_waypoint_capture_team2" );
	precacheShader( "hud_waypoint_capture_team3" );
	precacheShader( "hud_waypoint_capture_team4" );
	precacheShader( "hud_waypoint_defend_team1" );
	precacheShader( "hud_waypoint_defend_team2" );
	precacheShader( "hud_waypoint_defend_team3" );
	precacheShader( "hud_waypoint_defend_team4" );

	precacheShader( "hud_waypoint_capture_white" );
	precacheShader( "hud_waypoint_defend_white" );

	PrecacheVehicle( "ai_tank_drone_nondrivable_mp" );
	PrecacheModel( "veh_t6_drone_tank" );
	PrecacheItem( "ai_tank_drone_rocket_mp" );

	precacheString( &"MP_DRONE_HACKED" );
	precacheString( &"MP_DRONE_KILL" );
	precacheString( &"MP_KILL" );
	precacheString( &"MP_DRONE_DESTROYED" );
	precacheString( &"MP_YOUR_DRONE_DESTROYED" );
	precacheString( &"MP_DRONES_ACTIVE_IN" );
}


onStartGameType()
{	
	level.drone_count			= GetGametypeSetting( "objectiveSpawnTime" );
	level.drone_hack_time		= GetGametypeSetting( "crateCaptureTime" );
	level.drone_active_time		= GetGametypeSetting( "captureTime" );
	level.drone_stun_time		= GetGametypeSetting( "flagRespawnTime" );
	level.drone_destroy_unowned	= GetGametypeSetting( "hotPotato" );
	level.drone_head_icon		= GetGametypeSetting( "enemyCarrierVisible" );
	level.drone_min_emps		= GetGametypeSetting( "destroyTime" );
	level.drone_spawn_emps		= GetGametypeSetting( "idleFlagResetTime" );
	
	setClientNameMode("auto_change");
	level.disableCAC = 1;

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );

	setObjectiveText( "allies", &"OBJECTIVES_TDM" );
	setObjectiveText( "axis", &"OBJECTIVES_TDM" );
	setObjectiveHintText( "allies", &"OBJECTIVES_HACKER_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_HACKER_HINT" );
	setObjectiveScoreText( "allies", &"OBJECTIVES_TDM_SCORE" );
	setObjectiveScoreText( "axis", &"OBJECTIVES_TDM_SCORE" );

	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();

	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );

	level.useStartSpawns = false;
	
	allowed[0] = "hq";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();
		
	if ( !isOneRound() && isScoreRoundBased() )
	{
		maps\mp\gametypes\_globallogic_score::resetTeamScores();
	}

	bwars_init();
}

bwars_get_spawnpoint( team )
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( team );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	return spawnPoint;
}

giveCustomLoadout()
{
	if ( !IsDefined( self.emp_count ) )
	{
		self.emp_count = level.drone_spawn_emps;
	}
	else if ( self.emp_count < level.drone_min_emps )
	{
		self.emp_count = level.drone_min_emps;
	}
			
	self TakeAllWeapons();
	self ClearPerks();

	self GiveWeapon( "kard_mp" );
	self GiveWeapon( "knife_mp" );

	self GiveStartAmmo( "kard_mp" );
	self SwitchToWeapon( "kard_mp" );

	self GiveWeapon( level.weapons["frag"] );
	self SetWeaponAmmoClip( level.weapons["frag"], 0 );
	self.grenadeTypePrimary = level.weapons["frag"];

	self GiveWeapon( "emp_grenade_mp" );
	self SetWeaponAmmoClip( "emp_grenade_mp", self.emp_count );
	self SetOffhandSecondaryClass( "emp_grenade_mp" );

	self SetPerk( "specialty_scavenger" );
	self SetPerk( "specialty_movefaster" );
	self SetPerk( "specialty_longersprint" );
	
	self SetActionSlot( 1, "" );
	self SetActionSlot( 2, "" );
	self SetActionSlot( 3, "" );
	self SetActionSlot( 4, "" );
}

customLoadoutScavenge( weapon )
{
	if ( weapon == level.weapons["frag"] )
	{
		return 0;
	}

	return( WeaponMaxAmmo( weapon ) );
}

maySpawn()
{
	if ( is_true( level.drones_spawned ) && self.bwars_drone_count == 0 )
	{
		return false;
	}

	return true;
}

player_spawn()
{
	if ( !IsDefined( self.bwars_drone_count ) )
	{
		self.bwars_drone_count = 0;
	}

	self player_tank_hud_init();

	if ( is_true( level.drones_spawned ) && self.bwars_drone_count == 0 )
	{
		//self thread maps\mp\gametypes\_hud_message::hintMessage( &"OBJECTIVES_LAST_LIFE_HINT" );
	}
}

onSpawnPlayerUnified()
{
	self player_spawn();
		
	if ( level.useStartSpawns && !level.inGracePeriod && !level.playerQueuedRespawn )
	{
		level.useStartSpawns = false;
	}

	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}

onSpawnPlayer(predictedSpawn)
{
	self player_spawn();

	spawnpoint = self bwars_get_spawnpoint( self.pers["team"] );
			
	if ( predictedSpawn )
	{
		self predictSpawnPoint( spawnpoint.origin, spawnpoint.angles );
	}
	else
	{
		self Spawn( spawnpoint.origin, spawnpoint.angles, "bwars" );
	}
}

onEndGame( winningTeam )
{
}

onTimeLimit()
{
	foreach( team in level.alivePlayers )
	{
		foreach( player in team )
		{
			player thread maps\mp\gametypes\_hud_message::hintMessage( &"MP_DRONES_ACTIVE" );
		}
	}

	if ( level.drone_destroy_unowned )
	{
		drones = GetEntArray( "talon", "targetname" );

		foreach( drone in drones )
		{
			drone tank_stop();
		}
	}

	wait( 0.5 );
	self maps\mp\gametypes\_globallogic_audio::leaderDialog( "hack_link" );

	drones = GetEntArray( "talon", "targetname" );

	foreach( drone in drones )
	{
		drone tank_start();
	}

	level.drones_spawned = true;

	players = GET_PLAYERS();

	foreach( player in players )
	{
		player player_tank_hud_update();
	}
}

onRoundEndGame( roundWinner )
{
	if ( level.roundScoreCarry == false ) 
	{
		[[level._setTeamScore]]( "allies", game["roundswon"]["allies"] );
		[[level._setTeamScore]]( "axis", game["roundswon"]["axis"] );
	
		if ( game["roundswon"]["allies"] == game["roundswon"]["axis"] )
			winner = "tie";
		else if ( game["roundswon"]["axis"] > game["roundswon"]["allies"] )
			winner = "axis";
		else
			winner = "allies";
	}
	else
	{
        axisScore = [[level._getTeamScore]]( "axis" );
	    alliedScore = [[level._getTeamScore]]( "allies" );

		if ( axisScore == alliedScore )
		{
			winner = "tie";
		}
		else if ( axisScore > alliedScore )
		{
			winner = "axis";
		}
		else
		{
			winner = "allies";
		}

	}
	
	return winner;
}

bubblesort_structs( structs )
{
	while( true )
	{
		swapped = false;

		for ( i = 1; i < structs.size; i++ )
		{
			if ( int( structs[i-1].script_index ) > int( structs[i].script_index ) )
			{
				t = structs[i-1];
				structs[i-1] = structs[i];
				structs[i] = t;

				swapped = true;
			}
		}

		if ( !swapped )
		{
			break;
		}
	}

	return structs;
}

spawn_from_structs()
{
	structs = GetStructArray( "hacker_agr_spawn", "script_noteworthy" );

	if ( !structs.size )
	{
		return false;
	}

	structs = bubblesort_structs( structs );

/*
	foreach( s in structs )
	{
		Print3d( s.origin, s.script_index, (1, 0, 0), 1, 1, 30000 );
	}
*/

	spawned = 0;

	for ( i = 0; i < structs.size; i++ )
	{
		drone = SpawnVehicle( "veh_t6_drone_tank", "talon", "ai_tank_drone_nondrivable_mp", structs[i].origin, ( 0, RandomIntRange( 0, 360 ), 0 ) );
		drone ai_tank_init();

		forward = AnglesToForward( drone.angles );
		forward = drone.origin + forward * 128;
		forward = forward - ( 0, 0, 64 );

		drone SetTurretTargetVec( forward );
		drone SetVehicleAvoidance( true );

		trigger = Spawn( "trigger_radius_use", drone.origin, 16, 16 );

		visuals[0] = Spawn( "script_model", drone.origin );
		use = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", trigger, visuals, ( 0, 0, 0 ) );
		use maps\mp\gametypes\_gameobjects::allowUse( "any" );
		use maps\mp\gametypes\_gameobjects::setUseTime( level.drone_hack_time );
		use maps\mp\gametypes\_gameobjects::setUseText( &"MP_HACKING" );
		use maps\mp\gametypes\_gameobjects::setUseHintText( &"MP_TALON_HACKING" );
		use maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );

		use.onBeginUse = ::onBeginUse;
		use.onUse = ::onUse;
		use.onEndUse = ::onEndUse;

		trigger SetCursorHint( "HINT_NOICON" );
		trigger EnableLinkTo();
		trigger LinkTo( drone );
		trigger TriggerIgnoreTeam();
		//trigger UseTriggerRequireLookAt();
		trigger SetVisibleToAll();
		trigger SetTeamForTrigger( "none" );

		use.drone = drone;
		drone.trigger = trigger;
		drone.use = use;
		// Setting default value for objective Index as 0. 
		// This value is used for game modes like domination where we update the status of specific objective points.
		drone.objectiveIndex = 0;
		drone.objectiveType = "hacker_agr";

		spawned++;

		if ( spawned == level.drone_count )
		{
			break;
		}
	}

	return true;
}

bwars_init()
{
	SetDvar( "scavenger_tactical_proc", "1" );

	allowed[0] = "";
	maps\mp\gametypes\_gameobjects::main( allowed );

	level thread bwars_time_think();

	if ( spawn_from_structs() )
	{
		return;
	}
	
	nodes = GetAllNodes();
	node = GetClosest( level.mapCenter, nodes );

	nodes = GetNodesInRadius( node.origin, 1024, 0, 512, "Path" );
	nodes = array_randomize( nodes );

	spawned = 0;
	
	for ( i = 0; i < nodes.size; i++ )
	{
		if ( !valid_location( nodes[i] ) )
		{
			continue;
		}

		nodes[i].drone = true;

		drone = SpawnVehicle( "veh_t6_drone_tank", "talon", "ai_tank_drone_nondrivable_mp", nodes[i].origin, ( 0, RandomIntRange( 0, 360 ), 0 ) );
		drone ai_tank_init();

		forward = AnglesToForward( drone.angles );
		forward = drone.origin + forward * 128;
		forward = forward - ( 0, 0, 64 );

		drone SetTurretTargetVec( forward );
		drone SetVehicleAvoidance( true );

		trigger = Spawn( "trigger_radius_use", drone.origin, 16, 16 );

		visuals[0] = Spawn( "script_model", drone.origin );
		use = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", trigger, visuals, ( 0, 0, 0 ) );
		use maps\mp\gametypes\_gameobjects::allowUse( "any" );
		use maps\mp\gametypes\_gameobjects::setUseTime( level.drone_hack_time );
		use maps\mp\gametypes\_gameobjects::setUseText( &"MP_HACKING" );
		use maps\mp\gametypes\_gameobjects::setUseHintText( &"MP_TALON_HACKING" );
		use maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );

		use.onBeginUse = ::onBeginUse;
		use.onUse = ::onUse;
		use.onEndUse = ::onEndUse;

		trigger SetCursorHint( "HINT_NOICON" );
		trigger EnableLinkTo();
		trigger LinkTo( drone );
		trigger TriggerIgnoreTeam();
		//trigger UseTriggerRequireLookAt();
		trigger SetVisibleToAll();
		trigger SetTeamForTrigger( "none" );

		use.drone = drone;
		drone.trigger = trigger;
		drone.use = use;
		// Setting default value for objective Index as 0. 
		// This value is used for game modes like domination where we update the status of specific objective points.
		drone.objectiveIndex = 0;
		drone.objectiveType = "hacker_agr";		

		spawned++;

		if ( spawned == level.drone_count )
		{
			break;
		}
	}
}

valid_node( nodes )
{
	foreach( node in nodes )
	{
		if ( FindPath( node.origin, self.origin, false ) )
		{
			return node;
		}
	}

	return undefined;
}

tank_move_think()
{
	self endon( "death" );
	self endon( "stunned" );
	self endon( "remote_start" );
	level endon ( "game_ended" );

	for ( ;; )
	{
		wait( RandomFloatRange( 1, 4 ) );

		if ( !tank_valid_location() )
		{
			self notify( "death" );
			return;
		}

		if ( !tank_is_idle() )
		{
			enemy = tank_get_target();

			if ( valid_target( enemy, self.team, self.owner ) )
			{
				if ( self SetVehGoalPos( enemy.origin, true, 2 ) )
				{
					self wait_endon( 3, "reached_end_node" );
					continue;
				}
			}
		}

		angles = self GetTagAngles( "tag_turret" );
		forward = AnglesToForward( angles );

		origin = VectorScale( forward, RandomIntRange( 512, 1024 ) );

		nodes = GetNodesInRadius( origin, 256, 0, 512, "Path", 8 );
		node = valid_node( nodes );

		if ( IsDefined( node ) && self SetVehGoalPos( node.origin, true, 2 ) )
		{
			self wait_endon( AI_TANK_PATH_TIMEOUT, "reached_end_node" );
		}
		else
		{
			origin = random( level.ai_tank_valid_locations );

			if ( self SetVehGoalPos( origin, true, 2 ) )
			{
				self wait_endon( AI_TANK_PATH_TIMEOUT, "reached_end_node" );
			}
		}
		
		if ( self.aim_entity.delay > 0 )
		{
			self wait_endon( self.aim_entity.delay, "reached_end_node" );
		}
	}
}

/*
bwars_init()
{
	models = GetEntArray( "script_model", "classname" );
	hq_models = [];

	foreach( object in models )
	{
		if ( object.model == "t6_wpn_supply_drop_hq" )
		{
			ARRAY_ADD( hq_models, object );
		}
	}
	
	foreach( hq in hq_models )
	{
		nodes = GetNodesInRadius( hq.origin, 512, 0, 128, "Path" );
		nodes = array_randomize( nodes );
		spawned = 0;

		for ( i = 0; i < nodes.size; i++ )
		{
			if ( !valid_location( nodes[i] ) )
			{
				continue;
			}

			nodes[i].drone = true;
			drone = SpawnVehicle( "veh_t6_drone_asd", "talon", "ai_tank_drone_mp", nodes[i].origin, ( 0, RandomIntRange( 0, 360 ), 0 ) );
			drone ai_tank_init();
			
			forward = AnglesToForward( drone.angles );
			forward = drone.origin + forward * 128;
			forward = forward - ( 0, 0, 64 );

			drone SetTurretTargetVec( forward );

			trigger = Spawn( "trigger_radius_use", drone.origin, 16, 16 );
			
			visuals[0] = Spawn( "script_model", drone.origin );
			use = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", trigger, visuals, ( 0, 0, 0 ) );
			use maps\mp\gametypes\_gameobjects::allowUse( "any" );
			use maps\mp\gametypes\_gameobjects::setUseTime( 3 );
			use maps\mp\gametypes\_gameobjects::setUseText( &"MP_HACKING" );
			use maps\mp\gametypes\_gameobjects::setUseHintText( &"MP_GENERIC_HACKING" );
			use maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );

			use.onUse = ::onUse;
			
			trigger SetCursorHint( "HINT_NOICON" );
			trigger EnableLinkTo();
			trigger LinkTo( drone );
			trigger TriggerIgnoreTeam();
			//trigger UseTriggerRequireLookAt();
			trigger SetVisibleToAll();
			trigger SetTeamForTrigger( "none" );

			use.drone = drone;
			drone.trigger = trigger;
			drone.use = use;
			spawned++;

			//DebugStar( drone.origin, 100000, (1,0,0) );

			if ( spawned == 2 )
			{
				break;
			}

			nodes = GetNodesInRadius( nodes[i].origin, 1024, 512, 128, "Path" );
			i = -1;
		}
	}

	SetDvar( "scavenger_tactical_proc", "1" );

	allowed[0] = "";
	maps\mp\gametypes\_gameobjects::main( allowed );

	level thread bwars_time_think();
}
*/

bwars_time_think()
{
	level waittill( "prematch_over" );

	while ( level.inPrematchPeriod )
		wait ( 0.05 );

	time = int( level.drone_active_time );

	for ( ; time > 0; time-- )
	{
		if ( time == level.drone_active_time - 3 )
		{
			level.timerDisplay = createServerTimer( "objective", 1.4 );
			level.timerDisplay setPoint( "TOPRIGHT", "TOPRIGHT", 0, 40 );
			level.timerDisplay.label = &"MP_DRONES_ACTIVE_IN";
			level.timerDisplay.alpha = 1;
			level.timerDisplay.archived = false;
			level.timerDisplay.hideWhenInMenu = true;
			level.timerDisplay setTimer( level.drone_active_time - 3 );
		}
		wait( 1 );
	}

	onTimeLimit();

	if ( IsDefined( level.timerDisplay ) )
	{
		level.timerDisplay destroyElem();
	}
	
/*
	for ( ;; )
	{
		wait( 1 );

		alive = 0;

		players = GET_PLAYERS();

		foreach( player in players )
		{
			if ( !IsDefined( player.bwars_drone_count ) )
			{
				continue;
			}

			if ( player.bwars_drone_count > 0 )
			{
				alive++;
			}
			else if ( player.sessionstate == "playing" )
			{
				alive++;
			}
		}

		if ( alive == 1 )
		{
			winner = getHighestScoringPlayer();
			thread maps\mp\gametypes\_globallogic::endGame( winner, &"MP_ENEMIES_ELIMINATED" );
			return;
		}
	}
*/
}

valid_location( node )
{
	if ( IsDefined( node.drone ) )
	{
		return false;
	}

	drones = GetEntArray( "talon", "targetname" );

	foreach( drone in drones )
	{
		if ( DistanceSquared( drone.origin, node.origin ) < 256 * 256 )
		{
			return false;
		}
	}
		
	level.ai_tank_valid_locations = array_randomize( level.ai_tank_valid_locations );

	count = Min( level.ai_tank_valid_locations.size, 5 );

	for ( i = 0; i < count; i++ )
	{
		if ( FindPath( node.origin, level.ai_tank_valid_locations[ i ], false ) )
		{
			return true;
		}
	}

	return false;
}

ai_tank_init()
{
	self.maxhealth = 999999;
	self.health = self.maxhealth;
	self SetTeam( "team8" );

	self.isStunned = false;
	self.controlled = false;

	self.numberRockets = 3;
	self.warningShots = 6;
}

players_on_team( team )
{
	players = [];
	all = GET_PLAYERS();

	foreach( player in all )
	{
		if ( !IsDefined( player.team ) )
		{
			continue;
		}
		
		if ( player.team == team )
		{
			players[ players.size ] = player;
		}
	}

	return players;
}

player_tank_hud_init()
{
	if ( IsDefined( self.bwars_hud ) )
	{
		return;
	}

	x = -40;
	y = 150;

	hud = NewClientHudElem( self );

	hud.alignX = "left";
	hud.alignY = "middle";
	hud.foreground = 1;
	hud.fontScale = 1;
	hud.alpha = 0;
	hud.x = x;
	hud.y = y;
	hud.hidewhendead = 1;
	hud.hidewheninkillcam = 1;

	hud.score = NewClientHudElem( self );

	hud.score.alignX = "left";
	hud.score.alignY = "middle";
	hud.score.foreground = 1;
	hud.score.fontScale = 1;
	hud.score.alpha = 0;
	hud.score.x = x + 80;
	hud.score.y = y;
	hud.score.hidewhendead = 1;
	hud.score.hidewheninkillcam = 1;

	self.bwars_hud = hud;

	self player_tank_hud_update();

	drones = GetEntArray( "talon", "targetname" );

	self.icons = [];

	foreach( drone in drones )
	{
		entity = drone;
		
		headicon = newClientHudElem(self);
		headicon.archived = true;
		headicon.x = 0;
		headicon.y = 0;
		headicon.z = 60;
		headicon.alpha = 0;
		headicon setShader("waypoint_capture", 6, 6);
		headicon setwaypoint( false ); // false = uniform size in 3D instead of uniform size in 2D
		headicon SetTargetEnt( entity );

		self.icons[ drone GetEntityNumber() ] = headicon;

		if ( level.drone_head_icon == HEAD_ICON_SHOW_ENEMY || level.drone_head_icon == HEAD_ICON_SHOW_BOTH )
		{
			if ( IsDefined( drone.owner ) && drone.owner != self )
			{
				headicon.alpha = 0.8;
			}
		}
	}
}

player_tank_hud_update()
{
	if ( self.team == "spectator" )
	{
		return;
	}

/*	if ( is_true( level.drones_spawned ) && self.bwars_drone_count == 0 )
	{
		self.bwars_hud.score SetText( "" );
		self.bwars_hud SetText( "LAST LIFE" );
		self.bwars_hud.color = ( 0.85, 0, 0 );
		self thread maps\mp\gametypes\_hud_message::hintMessage( &"OBJECTIVES_LAST_LIFE_HINT" );
	}
	else*/
	{
		self.bwars_hud SetText( "Hacked AGRs:" );
		self.bwars_hud.score SetValue( self.bwars_drone_count );

		if ( self.bwars_drone_count == 0 )
		{
			self.bwars_hud.color = ( 0.85, 0, 0 );
			self.bwars_hud.score.color = ( 0.85, 0, 0 );
		}
		else
		{
			self.bwars_hud.color = ( 1, 1, 1 );
			self.bwars_hud.score.color = ( 1, 1, 1 );
		}
	}
}

onBeginUse( user )
{
	self.drone.being_hacked = true;
	user SetPlayerCurrentObjective( self.drone.objectiveIndex, self.drone.objectiveType );
}

onUseUpdate( team, progress, change )
{
}

onEndUse( team, player, success )
{
	self.drone.being_hacked = false;
	player SetPlayerCurrentObjective( 0, "none" );
}

onUse( player )
{
	//ScoreEvent( player, &"MP_DRONE_HACKED", 250, undefined, 0 );
	maps\mp\gametypes\_globallogic_score::givePlayerScore( "hacker_drone_hacked", player );
		
	self.trigger SetVisibleToAll();
	self.trigger SetInvisibleToPlayer( player );

	player maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "ai_tank_drop_mp" );

	player.pers["hacks"]++;
	player.hacks = player.pers["hacks"];

	if ( IsDefined( self.drone.owner ) )
	{
		self.drone.owner iPrintLn( player.name + " hacked your drone!" );
		player iPrintLn( "You hacked " + self.drone.owner.name + "'s drone!" );
		self.drone.owner maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "hack_hacked" );
		
		self.drone.owner.bwars_drone_count--;
		self.drone.owner player_tank_hud_update();
	}

	needs_start = false;

	if ( !IsDefined( self.drone.owner ) )
	{
		needs_start = true;
	}
	
	self.drone SetOwner( player );
	self.drone SetTeam( "free" );
	self.drone.owner = player;
	self.drone.team = player.team;
	self.drone.aiteam = player.team;

	if ( needs_start && is_true( level.drones_spawned ) )
	{
		self.drone tank_start();
	}

	if ( level.drone_head_icon == HEAD_ICON_SHOW_MINE || level.drone_head_icon == HEAD_ICON_SHOW_BOTH )
	{
		self.drone maps\mp\_entityheadicons::setEntityHeadIcon( self.drone.team, player, ( 0, 0, 60 ), "waypoint_defend" );
	}
	
	player.icons[ self.drone GetEntityNumber() ].alpha = 0;

	if ( level.drone_head_icon == HEAD_ICON_SHOW_ENEMY || level.drone_head_icon == HEAD_ICON_SHOW_BOTH )
	{
		all = GET_PLAYERS();

		foreach( p in all )
		{
			if ( p == player )
			{
				continue;
			}

			if ( p.team == "spectator" )
			{
				continue;
			}

			p.icons[ self.drone GetEntityNumber() ].alpha = 0.8;
		}
	}

	player.bwars_drone_count++;
	player player_tank_hud_update();

	self.drone.stunFinishTime = 0;

	self.drone notify( "drone_hacked" );
	self.drone thread tank_abort_think();
}

tank_start()
{
	if ( is_true( self.dead ) )
	{
		return;
	}

	if ( !IsDefined( self.owner ) )
	{
		return;
	}

	self SetClientField( "ai_tank_hack_spawned", 1 );
	self SetClientField( "ai_tank_death", 0 );
	self.trigger SetInvisibleToAll();

	// create the influencers
	self maps\mp\gametypes\_spawning::create_aitank_influencers( self.team );

	self thread tank_move_think();
	self thread maps\mp\killstreaks\_ai_tank::tank_aim_think();
	self thread maps\mp\killstreaks\_ai_tank::tank_combat_think();
	self thread maps\mp\killstreaks\_ai_tank::tank_rocket_watch();
	self thread tank_damage_think();
	self thread tank_death_think();
}

tank_stop()
{
	if ( !IsDefined( self.owner ) )
	{
		self notify( "death" );
	}
}

tank_death_think()
{
	self endon( "drone_abort" );
	
	team = self.team;
	self waittill( "death", attacker );
	self.dead = true;

	for (i = 0; i < self.entityHeadIcons.size; i++) 
	{
		if (isdefined(self.entityHeadIcons[i]))
			self.entityHeadIcons[i] destroy();
	}

	all = GET_PLAYERS();

	foreach( p in all )
	{
		if ( IsDefined( p.icons ) && IsDefined( p.icons[ self GetEntityNumber() ] ) )
		{
			p.icons[ self GetEntityNumber() ] Destroy();
		}
	}

	self.use maps\mp\gametypes\_gameobjects::disableObject();
	self.trigger SetInvisibleToAll();

	self ClearVehGoalPos();
	
	if ( self.controlled == true )
	{
		self.owner thread maps\mp\killstreaks\_remotemissile::staticEffect( 1.0 );
		self.owner destroy_remote_hud();	
	}
/*
	if (self.isStunned)
	{
		stunned = true;
		self thread emp_crazy_death();
		wait( 1.55 );
	}
	else
*/
	{
		stunned = false;
		PlayFX( level._effect[ "rcbombexplosion" ], self.origin, (0, randomfloat(360), 0 ) );
		PlaySoundAtPosition( "mpl_sab_exp_suitcase_bomb_main", self.origin );
		wait( 0.05 );
		self hide();
		if (isDefined(self.stun_fx))
		{
			self.stun_fx delete();
		}
	}
	
	wait( 0.95 );

	if ( IsDefined( self.aim_entity ) )
		self.aim_entity delete();

	self delete();

	if (stunned == false )
	{
		//self.owner stop_remote();	
		//self.owner destroy_action_prompt_hud( self );
	}
}

tank_damage_think()
{
	self endon( "death" );
	self endon( "drone_abort" );

	self.maxhealth = 999999;
	self.health = self.maxhealth;
	self.isStunned = false;
	self.stunFinishTime = 0;

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, dir, point, mod, model, tag, part, weapon, flags );

		self.maxhealth = 999999;
		self.health = self.maxhealth;

		if ( weapon == "emp_grenade_mp" && mod == "MOD_GRENADE_SPLASH" )
		{
			self.stunStartTime = getTime();
			self.stunFinishTime = getTime() + ( level.drone_stun_time * 1000 ) + 500;

			if ( !self.isStunned )
			{
				self thread tank_stun();
				self.isStunned = true;
			}
		}
	}
}

tank_abort_think()
{
	self endon( "death" );
	self endon( "drone_hacked" );

	self.owner waittill_any( "disconnect", "joined_team", "joined_spectators" );

	self SetTeam( "team8" );
	self.owner = undefined;
	self.team = undefined;
	self.aiteam = undefined;

	angles = self GetTagAngles( "tag_turret" );
	forward = AnglesToForward( angles );
	forward = self.origin + forward * 128;
	forward = forward - ( 0, 0, 64 );

	self SetTurretTargetVec( forward );
	self ClearVehGoalPos();

	self.trigger SetVisibleToAll();

	for (i = 0; i < self.entityHeadIcons.size; i++) 
	{
		if (isdefined(self.entityHeadIcons[i]))
			self.entityHeadIcons[i] destroy();
	}

	all = GET_PLAYERS();

	foreach( p in all )
	{
		if ( IsDefined( p.icons ) && IsDefined( p.icons[ self GetEntityNumber() ] ) )
		{
			p.icons[ self GetEntityNumber() ].alpha = 0;
		}
	}
	
	self notify( "stunned" );
	self notify( "drone_abort" );
	self SetClientField( "ai_tank_death", 1 );
	self SetClientField( "ai_tank_hack_spawned", 0 );
}

tank_stun_abort()
{
	self endon( "death" );
	self endon( "stun_done" );

	self waittill( "drone_hacked" );
	self.stunFinishTime = 0;
}

tank_stun()
{	
	self endon( "death" );
	self notify( "stunned" );

	self.isStunned = true;
	self SetClientFlag( CLIENT_FLAG_STUN );

	angles = self GetTagAngles( "tag_turret" );
	forward = AnglesToForward( angles );
	forward = self.origin + forward * 128;
	forward = forward - ( 0, 0, 64 );

	self SetTurretTargetVec( forward );
	self ClearVehGoalPos();

	self.trigger SetVisibleToAll();
	self.trigger SetInvisibleToPlayer( self.owner );

	self thread tank_stun_abort();

	//Ensure that a tank stays stunned the full stun time of the last EMP grenade it got hit by.
	current = GetTime();

	while( self.stunFinishTime > current )
	{
		wait( 0.05 );

		self SetClientField( "ai_tank_hack_rebooting", 0 );

		if ( !is_true( self.being_hacked ) )
		{
			reboot_time = ( self.stunFinishTime - self.stunStartTime ) * 0.5;
			reboot_time = self.stunStartTime + reboot_time;

			if ( current >= reboot_time )
			{
				self SetClientField( "ai_tank_hack_rebooting", 1 );
			}
		}

		current = GetTime();
	}

	while( is_true( self.being_hacked ) )
	{
		self SetClientField( "ai_tank_hack_rebooting", 0 );
		wait( 0.05 );
	}

	self thread tank_move_think();
	self thread maps\mp\killstreaks\_ai_tank::tank_aim_think();
	self thread maps\mp\killstreaks\_ai_tank::tank_combat_think();

	self.isStunned = false;
	self ClearClientFlag( CLIENT_FLAG_STUN );
	self SetClientField( "ai_tank_hack_rebooting", 0 );

	self.trigger SetInvisibleToAll();

	self notify( "stun_done" );
}

tank_valid_location()
{
	nodes = GetNodesInRadius( self.origin, 512, 8, 128, "Path" );
	return ( nodes.size > 0 );
}

get_winning_team()
{
	highest = 0;
	winner = "";
	tied = false;

	players = GET_PLAYERS();

	foreach( player in players )
	{
		if ( !player is_bot() )
		{
			if ( player.score > highest )
			{
				winner = player.team;
				highest = player.score;
				tied = false;
			}
			else if ( player.score == highest )
			{
				tied = true;
			}
		}
	}

	if ( tied )
	{
		return "";
	}

	return winner;
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self.emp_count = self GetWeaponAmmoStock( "emp_grenade_mp" );
	
	drone_kill = false;

	if ( IsDefined( sWeapon ) && sWeapon == "ai_tank_drone_rocket_mp" )
	{
		drone_kill = true;
	}
	else if ( IsDefined( eInflictor ) && IsDefined( eInflictor.targetname ) && eInflictor.targetname == "talon" )
	{
		drone_kill = true;
	}

	if ( drone_kill )
	{
		if ( IsDefined( attacker ) && IsPlayer( attacker ) && attacker != self )
		{
			maps\mp\gametypes\_globallogic_score::givePlayerScore( "hacker_drone_killed", attacker );
			attacker.pers["agrkills"]++;
			attacker.agrkills = attacker.pers["agrkills"];
		}
	}
}

get_highest_scoring_player()
{
	highest = undefined;

	players = GET_PLAYERS();

	foreach( player in players )
	{
		if ( !IsDefined( player.score ) )
		{
			continue;
		}

		if ( player.score < 0 )
		{
			continue;
		}
				
		if ( !IsDefined( highest ) )
		{
			highest = player;
			continue;
		}

		if ( player.score == highest.score )
		{
			// tie
			return undefined;
		}
				
		if ( player.score > highest.score )
		{
			highest = player;
		}
	}

	return highest;
}

onPlayerScore( event, player, victim )
{
	maps\mp\gametypes\_globallogic_score::default_onPlayerScore( event, player, victim );
	
	player = get_highest_scoring_player();

	if ( !IsDefined( player ) )
	{
		if ( IsDefined( level.bwars_last_highest ) )
		{
			// tie
			level.bwars_last_highest maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "lead_lost" );
			level.bwars_last_highest = undefined;
		}
	}
	else
	{
		if ( player.score > 0 )
		{
			if ( IsDefined( level.bwars_last_highest ) && player != level.bwars_last_highest )
			{
				player maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "lead_taken" );
				level.bwars_last_highest maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "lead_lost" );
				level.bwars_last_highest = player;
			}
			else if ( !IsDefined( level.bwars_last_highest ) )
			{
				player maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "lead_taken" );
				level.bwars_last_highest = player;
			}
		}
	}
}

onPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( sMeansOfDeath == "MOD_CRUSH" )
	{
		if ( IsDefined( eInflictor.targetname ) && eInflictor.targetname == "talon" )
		{
			if ( eInflictor.isStunned )
			{
				return 0;
			}

			if ( !is_true( level.drones_spawned ) )
			{
				return 0;
			}

			speed = eInflictor GetSpeed();

			if ( speed <= 1 )
			{
				return 0;
			}
		}
	}

	return undefined;
}
