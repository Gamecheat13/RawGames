#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Hunted
	Objective: 	Score points by eliminating other players.  Packages are dropped randomly
							which contain weapons and ammo.
	Map ends:	When one player reaches the score limit, or time limit is reached
	Respawning:	No wait / Away from other players

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_dm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of enemies at the time of spawn.
			Players generally spawn away from enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "nva";
			Because Deathmatch doesn't have teams with regard to gameplay or scoring, this effectively sets the available weapons.

		If using minefields or exploders:
			maps\mp\_load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["soldiertypeset"] = "seals";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				soldiertypeset	seals
*/

/*QUAKED mp_dm_spawn (1.0 0.5 0.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies at one of these positions.*/

main()
{
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

	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 0, 0, 1440 );

	level.scoreRoundBased = true;
	level.resetPlayerScoreEveryRound = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.giveCustomLoadout = ::giveCustomLoadout;

	level.heliTime = GetGametypeSetting( "objectiveSpawnTime" );

	game["dialog"]["gametype"] = "ffa_start";
	game["dialog"]["gametype_hardcore"] = "hcffa_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";

	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths", "kdratio", "headshots" ); 
	
}


onStartGameType()
{
	setClientNameMode("auto_change");

	setObjectiveText( "allies", &"OBJECTIVES_DM" );
	setObjectiveText( "axis", &"OBJECTIVES_DM" );

	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_DM" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_DM" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_DM_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_DM_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_DM_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_DM_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	// use the new spawn logic from the start
	level.useStartSpawns = false;
	
	allowed[0] = "dm";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();

	level.displayRoundEndText = false;
	
	level thread onScoreCloseMusic();

	if ( !isOneRound() )
	{
		level.displayRoundEndText = true;
	}
	
	level.heliOwner = spawn( "script_origin", (0,0,0) );
	initDropLocations();
	registerCrates();
	thread crateDropper();
}


onSpawnPlayerUnified()
{
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}

onSpawnPlayer(predictedSpawn)
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		self spawn( spawnPoint.origin, spawnPoint.angles, "dm" );
	}
}


onEndGame( winningPlayer )
{
	if ( isDefined( winningPlayer ) && isPlayer( winningPlayer ) )
		[[level._setPlayerScore]]( winningPlayer, winningPlayer [[level._getPlayerScore]]() + 1 );
}

// *******************************************************************
//                   Custom Loadout
// *******************************************************************
giveCustomLoadout()
{
	self takeAllWeapons();
	self ClearPerks();
	
	weapon = "judge_mp";

	self.primaryWeapon = "judge_mp";
	self.lethalGrenade = "hatchet_mp";
	self.tacticalGrenade = undefined;
	
	self GiveWeapon( weapon );
	self GiveWeapon( "knife_mp" );
	self GiveWeapon( "knife_held_mp" );
	self GiveWeapon( self.lethalGrenade );
	self SetWeaponAmmoStock( weapon, 0 );
	self SetWeaponAmmoClip( weapon, 5 );
	self switchToWeapon( weapon );
	
	self setSpawnWeapon( weapon );
	
	return weapon;
}

onScoreCloseMusic()
{
    while( !level.gameEnded )
    {
        scoreLimit = level.scoreLimit;
	    scoreThreshold = scoreLimit * .9;
        
        for(i=0;i<level.players.size;i++)
        {
            scoreCheck = [[level._getPlayerScore]]( level.players[i] );
            
            if( scoreCheck >= scoreThreshold )
            {
                thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "TIME_OUT", "both" );
                thread maps\mp\gametypes\_globallogic_audio::actionMusicSet();
                return;
            }
        }
        
        wait(.5);
    }
}

inside_bounds( node_origin, bounds )
{
	mins = level.mapCenter - bounds;
	maxs = level.mapCenter + bounds;
	
	if ( node_origin[0] > maxs[0] )
		return false;
	if ( node_origin[0] < mins[0] )
		return false;
	if ( node_origin[1] > maxs[1] )
		return false;
	if ( node_origin[1] < mins[1] )
		return false;
		
	return true;
}

initDropLocations()
{
	scalar = 0.8;
	
	bound = ( level.spawnMaxs - level.mapCenter ) * scalar ;
	
//	all_nodes = getallnodes();
	
//	center = (0,0,0);
	
//	foreach( node in all_nodes )
//	{
//		center = center + node.origin;
//	}
//	
//	center = center / all_nodes.size;
	
///#
//	mins = level.mapCenter - bound;
//	maxs = level.mapCenter + bound;
//
//	time = 10000;
//	box( level.mapCenter, -1 * bound, bound, 0, (1,1,0), 1, 1, time );
////	sphere( center, 20, (1,1,0), 1, true, 10, time );
//	sphere( level.mapCenter, 20, (1,1,1), 1, true, 10, time );
//	sphere( mins, 20, (0,1,0), 1, true, 10, time );
//	sphere( maxs, 20, (1,0,0), 1, true, 10, time );
//	sphere( level.spawnMins, 20, (0,1,0), 1, true, 10, time );
//	sphere( level.spawnMaxs, 20, (1,0,0), 1, true, 10, time );
//#/

	// get path nodes using the radius function to help trim out the nodes around the bounds
//	possible_nodes = GetNodesInRadius( level.mapCenter, Length( bound ), 0 ,level.spawnMaxs[2], "Path" );
	possible_nodes = getallnodes();
	nodes = [];
	
	count = 0;
	
	foreach( node in possible_nodes )
	{
		if ( inside_bounds( node.origin, bound ) )
		{
			nodes[nodes.size] = node;

//			debugstar(  node.origin, time, ( 1, 0, 1 ) );
			count++;
		}
	}
	
	level.dropNodes = nodes;
}

registerCrates()
{
	// weapons
	
	// smg
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "weapon", "qcw05_mp", 1, &"WEAPON_QCW05", undefined, undefined, ::giveHuntedWeapon, ::huntedCrateLandOverride );
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "weapon", "pdw57_mp", 1, &"WEAPON_PDW57", undefined, undefined, ::giveHuntedWeapon, ::huntedCrateLandOverride );
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "weapon", "evoskorpion_mp", 1, &"WEAPON_EVOSKORPION", undefined, undefined, ::giveHuntedWeapon, ::huntedCrateLandOverride );
	
	//	assault
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "weapon", "xm8_mp", 1, &"WEAPON_XM8", undefined, undefined, ::giveHuntedWeapon, ::huntedCrateLandOverride );
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "weapon", "type95_mp", 1, &"WEAPON_TYPE95", undefined, undefined, ::giveHuntedWeapon, ::huntedCrateLandOverride );

	// LMG
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "weapon", "lsat_mp", 1, &"WEAPON_LSAT", undefined, undefined, ::giveHuntedWeapon, ::huntedCrateLandOverride );

	// shotgun
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "weapon", "srm1216_mp", 1, &"WEAPON_SRM1216", undefined, undefined, ::giveHuntedWeapon, ::huntedCrateLandOverride );


	// pistol
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "weapon", "kard_mp", 1, &"WEAPON_KARD", undefined, undefined, ::giveHuntedWeapon, ::huntedCrateLandOverride );
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "weapon", "beretta93r_mp", 1, &"WEAPON_BERETTA93R", undefined, undefined, ::giveHuntedWeapon, ::huntedCrateLandOverride );
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "weapon", "fnp45_mp", 1, &"WEAPON_FNP45", undefined, undefined, ::giveHuntedWeapon, ::huntedCrateLandOverride );


	// killstreaks
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "killstreak", "radar_mp", 4, &"KILLSTREAK_RADAR_CRATE", "MEDAL_SHARE_PACKAGE_RECON", ::giveCrateKillstreak, ::huntedCrateLandOverride );
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "killstreak", "autoturret_mp", 3, &"KILLSTREAK_AUTO_TURRET_CRATE", "MEDAL_SHARE_PACKAGE_AUTO_TURRET", ::giveCrateKillstreak, ::huntedCrateLandOverride );
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "killstreak", "remote_missile_mp", 4, &"KILLSTREAK_REMOTE_MISSILE_CRATE", "MEDAL_SHARE_PACKAGE_REMOTE_MISSILE", ::giveCrateKillstreak, ::huntedCrateLandOverride );
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "killstreak", "planemortar_mp", 4, &"KILLSTREAK_PLANE_MORTAR_CRATE", "MEDAL_SHARE_PACKAGE_PLANE_MORTAR", ::giveCrateKillstreak, ::huntedCrateLandOverride );
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "killstreak", "rcbomb_mp", 4, &"KILLSTREAK_RCBOMB_CRATE","MEDAL_SHARE_PACKAGE_RCBOMB", ::giveCrateKillstreak, ::huntedCrateLandOverride );
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "killstreak", "radardirection_mp", 2, &"KILLSTREAK_SATELLITE_CRATE", "MEDAL_SHARE_PACKAGE_SATELLITE", ::giveCrateKillstreak, ::huntedCrateLandOverride );
	maps\mp\killstreaks\_supplydrop::registerCrateType("hunted", "killstreak", "inventory_ai_tank_drop_mp", 1, &"KILLSTREAK_AI_TANK_CRATE","MEDAL_SHARE_PACKAGE_AI_TANK", ::giveCrateKillstreak, ::huntedCrateLandOverride );

	maps\mp\killstreaks\_supplydrop::setCategoryTypeWeight( "hunted", "weapon", 4 );
	maps\mp\killstreaks\_supplydrop::setCategoryTypeWeight( "hunted", "killstreak", 1 );

	
	maps\mp\killstreaks\_supplydrop::advancedFinalizeCrateCategory( "hunted" );
}

giveHuntedWeapon( weapon )
{
	if ( isdefined( self.primaryWeapon ) )
	{
		self TakeWeapon(self.primaryWeapon);
	}
	
	self.primaryWeapon = weapon;
	self GiveWeapon(weapon);
	self switchToWeapon(weapon);
	self SetWeaponAmmoStock( Weapon, 0 );
}

giveHuntedLethalGrenade( weapon )
{
	if ( self.lethalGrenade == weapon )
	{
			currStock = self GetAmmoCount( weapon );
			
			self setweaponammostock( weapon, currStock + 1 );
			return;
	}
	
	if ( isdefined( self.lethalGrenade ) )
	{
		self takeweapon(self.lethalGrenade);
	}

	self.lethalGrenade = weapon;
	self GiveWeapon(weapon);
	self setOffhandPrimaryClass( weapon );
}

giveHuntedTacticalGrenade( weapon )
{
	if ( self.tacticalGrenade == weapon )
	{
			currStock = self GetAmmoCount( weapon );
			
			self setweaponammostock( weapon, currStock + 1 );
			return;
	}
	
	if ( isdefined( self.tacticalGrenade ) )
	{
		self takeweapon(self.tacticalGrenade);
	}

	self.tacticalGrenade = weapon;
	self GiveWeapon(weapon);
	self setOffhandSecondaryClass( weapon );
}

huntedCrateLandOverride( crate, category, owner, team )
{
	crate.visibleToAll = true;
	crate maps\mp\killstreaks\_supplydrop::crateActivate();

	crate thread maps\mp\killstreaks\_supplydrop::crateUseThink();
	crate thread maps\mp\killstreaks\_supplydrop::crateUseThinkOwner();
		
	maps\mp\killstreaks\_supplydrop::default_land_function( crate, category, owner, team );
}

getCrateDropOrigin()
{
	node = undefined;
	time = 10000;
	
	while ( !isdefined(node) )
	{
		random_index = RandomInt( level.dropNodes.size );
		
		if ( !isdefined(level.dropNodes[random_index]) )
			continue;
			
		node_origin = level.dropNodes[random_index].origin;
		
		if ( !bulletTracePassed( node_origin + (0,0,1000), node_origin, false, undefined ) )
		{
			level.dropNodes[random_index] = undefined;
//			debugstar(  node_origin, time, ( 1, 0, 0 ) );
			continue;
		}
		
		node = level.dropNodes[random_index];
		break;
	}
	
	return node.origin;
}

crateDropper()
{
	wait_time = level.heliTime;
	time = 10000;
	while (1)
	{
		wait( wait_time );
		origin = getCrateDropOrigin();
//		debugstar(  origin, time, ( 1, 0, 1 ) );
		self thread maps\mp\killstreaks\_supplydrop::heliDeliverCrate( origin, "hunted", level.heliOwner, "free", 0, 0 );
	}
}