#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
/*
	Plunder
	Objective: 	
	Map ends:	
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
		registerScoreLimitDvar( level.gameType, 125 );
		registerRoundLimitDvar( level.gameType, 1 );
		registerWinLimitDvar( level.gameType, 1 );
		registerNumLivesDvar( level.gameType, 0 );
		registerHalfTimeDvar( level.gameType, 0 );
		
		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;
	}

	level.teamBased = true;
	level.initGametypeAwards = ::initGametypeAwards;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onNormalDeath = ::onNormalDeath;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onPlayerKilled = ::onPlayerKilled;
	
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
	
	level.conf_fx["vanish"] = loadFx( "impacts/small_snowhit" );
}


initializeMatchRules()
{
	//	set common values
	setCommonRulesFromMatchRulesData();
	
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	SetDynamicDvar( "scr_plunder_roundswitch", 0 );
	registerRoundSwitchDvar( "plunder", 0, 0, 9 );
	SetDynamicDvar( "scr_plunder_roundlimit", 1 );
	registerRoundLimitDvar( "plunder", 1 );		
	SetDynamicDvar( "scr_plunder_winlimit", 1 );
	registerWinLimitDvar( "plunder", 1 );			
	SetDynamicDvar( "scr_plunder_halftime", 0 );
	registerHalfTimeDvar( "plunder", 0 );
		
	SetDynamicDvar( "scr_plunder_promode", 0 );	
}

onPrecacheGameType()
{
	precachemodel( "prop_dogtags_friend" );
	precachemodel( "prop_dogtags_foe" );
	precachemodel( "prop_dogtags_misc" );
	precacheshader( "waypoint_dogtags" );
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

	setObjectiveText( "allies", &"OBJECTIVES_WAR" );
	setObjectiveText( "axis", &"OBJECTIVES_WAR" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_WAR" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_WAR" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_WAR_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_WAR_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_WAR_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_WAR_HINT" );
	
	initSpawns();
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "rare", 500 );
	maps\mp\gametypes\_rank::registerScoreInfo( "special", 250 );
	maps\mp\gametypes\_rank::registerScoreInfo( "common", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "once_only", 1000 );
	
	level.lootDrops = [];
	
	
	allowed[0] = level.gameType;
	allowed[1] = "airdrop_pallet";
	
	maps\mp\gametypes\_gameobjects::main(allowed);	
	
	generateLoot();
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


onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, lifeId )
{

	if( isdefined( self.perks[ "specialty_juiced" ] ))
	{
		self.perks[ "specialty_juiced" ] = undefined;
	} 

	
	maps\mp\_utility::_clearPerks();
	
	loadoutPerks = [];
	loadoutPerks[0] = self.loadoutPerks[0];
	loadoutPerks[1] = self.loadoutPerks[1];
	loadoutPerks[2] = self.loadoutPerks[2];

	if( loadoutPerks[0] != "specialty_null" )
		self givePerk( loadoutPerks[0], true );
	if( loadoutPerks[1] != "specialty_null" )
		self givePerk( loadoutPerks[1], true );
	if( loadoutPerks[2] != "specialty_null" )
		self givePerk( loadoutPerks[2], true );
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
	//score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	//assert( isDefined( score ) );

	//level thread spawnDogTags( victim, attacker );

	
	level thread spawnLoot( victim, attacker );
	
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

initGametypeAwards()
{
	//maps\mp\_awards::initStatAward( "killsconfirmed",		0, maps\mp\_awards::highestWins );
}



generateLoot()
{

	//doesn't work yet
	//   lootType    lootName 					   Weight    giveFunc   
	//addLootType( "killstreak", "specialty_c4death"		   , 25		 , ::givePerkLoot );
	//addLootType( "killstreak", "specialty_finalstand"	   , 25		 , ::givePerkLoot );
	//addLootType(	"killstreak",	"airdrop_juggernaut_recon",	4,		::juggernautCrateThink );
	//addLootType(	"killstreak",	"airdrop_trap",				11,		::trapCrateThink );	
	//addLootType(	"killstreak",	"airdrop_juggernaut",		1,		::juggernautCrateThink );
	//addLootType( "killstreak", "specialty_assists_ks"		 , 25	   , ::givePerkLoot );
	
	//Xp bonus
	
	//Score bonus
	
	//Mcguffin
		//gives the controlling team points
		//The killer of this player recieves the item
		//tells everyone that they have it.
		//shows up on the minimap

	//common
			 //   lootType 	    lootName 					    Weight    giveFunc 		   
	addLootType( "common", "specialty_blindeye_ks"		 , 25	   , ::givePerkLoot );
	addLootType( "common", "specialty_paint_ks"			 , 25	   , ::givePerkLoot );
	addLootType( "common", "uav"						 , 25	   , ::giveKillstreak );
	addLootType( "common", "_specialty_blastshield_ks"	 , 25	   , ::givePerkLoot );
	addLootType( "common", "specialty_detectexplosive_ks", 25	   , ::givePerkLoot );
	addLootType( "common", "specialty_autospot_ks"		 , 25	   , ::givePerkLoot );
	addLootType( "common", "counter_uav"				 , 25	   , ::giveKillstreak );
	addLootType( "common", "deployable_vest"			 , 21	   , ::giveKillstreak );
	addLootType( "common", "sentry"						 , 21	   , ::giveKillstreak );
	addLootType( "common", "remote_mg_turret"			 , 17	   , ::giveKillstreak );
	addLootType( "common", "specialty_bulletaccuracy_ks" , 17	   , ::givePerkLoot );
	addLootType( "common", "specialty_quieter_ks"		 , 17	   , ::givePerkLoot );
	addLootType( "common", "specialty_stalker_ks"		 , 17	   , ::givePerkLoot );
	addLootType( "common", "ims"						 , 17	   , ::giveKillstreak );
	addLootType( "common", "triple_uav"					 , 13	   , ::giveKillstreak );
	addLootType( "common", "predator_missile"			 , 13	   , ::giveKillstreak );
	addLootType( "common", "specialty_hardline_ks"		 , 13	   , ::givePerkLoot );
	addLootType( "common", "specialty_coldblooded_ks"	 , 13	   , ::givePerkLoot );
	addLootType( "common", "specialty_quickdraw_ks"		 , 13	   , ::givePerkLoot );
	
	//special
			 //   lootType 	    lootName 				     Weight    giveFunc 	  
	addLootType( "special", "specialty_longersprint_ks", 10		, ::givePerkLoot );
	addLootType( "special", "specialty_fastreload_ks"  , 10		, ::givePerkLoot );
	addLootType( "special", "specialty_scavenger_ks"	  , 10		, ::givePerkLoot );		 
	addLootType( "special", "precision_airstrike"	   , 9		 , ::giveKillstreak );
	addLootType( "special", "stealth_airstrike"		   , 9		 , ::giveKillstreak );
	addLootType( "special", "helicopter"				   , 9		 , ::giveKillstreak );
	addLootType( "special", "remote_tank"			   , 7		 , ::giveKillstreak );
	addLootType( "special", "sam_turret"				   , 7		 , ::giveKillstreak );
	addLootType( "special", "remote_uav"				   , 7		 , ::giveKillstreak );
	addLootType( "special", "littlebird_support"		   , 4		 , ::giveKillstreak );
	addLootType( "special", "specialty_revenge"		   , 4		 , ::givePerkLoot );
	addLootType( "special", "specialty_juiced"		   , 4		 , ::givePerkLoot );
	addLootType( "special", "specialty_stopping_power"  , 4		 , ::givePerkLoot );
	addLootType( "special", "specialty_grenadepulldeath", 4		 , ::givePerkLoot );
	//rare
			 //   lootType 	    lootName 		     Weight    giveFunc 	    
	addLootType( "rare", "littlebird_flock" , 2		, ::giveKillstreak );
	addLootType( "rare", "helicopter_flares", 2		, ::giveKillstreak );
	addLootType( "rare", "all_perks_bonus"  , 2		, ::givePerkLoot );
	addLootType( "rare", "remote_mortar"	  , 2		, ::giveKillstreak );
	addLootType( "rare", "ac130"			  , 2		, ::giveKillstreak );
	addLootType( "rare", "osprey_gunner"	  , 1		, ::giveKillstreak );
	addLootType( "rare", "emp"			  , 1		, ::giveKillstreak );
	
	addLootType( "once_only", "nuke"			  , 1		, ::giveKillstreak );
	

	
		// generate the max weighted value
	foreach( lootType, lootName in level.lootTypes )
	{
		level.LootMaxVal[lootType] = 0;	
		foreach( lootName, weight in level.lootTypes[lootType] )
		{
			if ( !weight )
				continue;

			level.lootMaxVal[lootType] += weight;
			level.lootTypes[lootType][lootName] = level.lootMaxVal[lootType];
		}
	}
	
}

addLootType( lootType, lootName, Weight, giveFunc )
{
	level.lootTypes[lootType][lootName] = Weight;
	level.lootFuncs[lootType][lootName] = giveFunc;
}


setupMcguffin()
{
	//display on players screen
	//generate points every 5 seconds
	//display as minimap objective
	//go to the attacking player on death
}

giveLoot( lootType )
{
	//lootType = "perk";
	//IPrintLnBold( lootType + " Drop" );
	//get loot item
	lootName = getRandomLootName( lootType );
	
	if( lootType == "once_only" )
	{
		level.lootTypes[lootType][lootName] = undefined;
	}
	
	actionData = SpawnStruct();
	actionData.name = lootName;//"selected_" + lootName;
	actionData.type = "killstreak_minisplash";	
	actionData.slot = 0;
	
	self thread maps\mp\gametypes\_hud_message::actionNotifyMessage( actionData );
		
	//give loot item
	self thread [[ level.lootFuncs[ lootType ][ lootName ] ]]( lootName );
}

giveKillstreak( lootName )
{
	self thread maps\mp\killstreaks\_killstreaks::giveKillstreak( lootName, false, false, self );
}

givePerkLoot( perkname )
{
	if( IsDefined( level.killstreakFuncs[ perkname ] ) )
			self [[ level.killstreakFuncs[ perkname ] ]]();
	else if( isdefined( level.perkSetFuncs[ perkname ] ))
	        self [[ level.perkSetFuncs[ perkname ] ]]();
	else
		self maps\mp\_utility::givePerk( perkname, false );
}

getRandomLootType( lootValue )
{
	//lootValue = victim.adrenaline;
	
	
	
	if( checkOnceOnly() )
	{
		return "once_only";
	}
	
	
	selectedLootType = "common";
	
	if( lootValue >= 47 )
	{
		selectedLootType = "rare";
	}
	else if( lootValue >= 30 )
	{
		selectedLootType = "special";
	}
	else
	{
		selectedLootType = "common";
	}
	
	return( selectedLootType );
	
}

checkOnceOnly()
{
	//has the once only been spawned with loot, has the once only been given to a player
	//check timer
	//check score
	//get random min value goes up to 100, based on score and time.
	
	prob = 0;
	once_only_drop_by_match_complete_percent = 95;
	
	if( level.lootTypes[ "once_only" ].size > 0 )
	{
		if( isDefined( level.lootOnceOnlySpawned ) )
		{
			//do nothing
		}
		else
		{
			if( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
			{
				high_score = game["teamScores"]["allies"];
			}
			else
			{
				high_score = game["teamScores"]["axis"];
			}
			
			score_max = getScoreLimit();
			
			score_percent = squared( high_score )/squared( score_max );
			
			timelimit = getTimeLimit();
			if( timelimit == 0 )
			{
				timelimit_percent = 0;
			}
			else
			{
				time_passed =  getMinutesPassed();
				time_passed_sq = squared( time_passed );
				timelimit_sq = squared( timelimit );
				timelimit_percent = time_passed_sq/timelimit_sq;
			}
			
			
			if( timelimit_percent >= score_percent  )
			{
				prob = timelimit_percent * 100;
			}
			else
			{
				prob = score_percent * 100;
			}
			
			if( isdefined ( prob ) && prob > 50 )
			{
				range = RandomFloatRange( prob, 100 );
				
				if( range >= once_only_drop_by_match_complete_percent )
				{
					level.lootOnceOnlySpawned = true;
					return true;
				}
			}
		}
	}
	return false;

}


getRandomLootName( lootType )
{
	value = randomInt( level.lootMaxVal[ lootType ] );
	
	if ( isDefined( self) && self _hasPerk("specialty_luckycharm") )
		charmed = true;
	else
		charmed = false;

	selectedLootName = undefined;
	foreach( lootName, weight in level.lootTypes[lootType] )
	{
		if ( !weight )
			continue;

		selectedLootName = lootName;

		if ( weight > value )
		{
			if ( charmed )
			{
				charmed = false;
				continue;
			}
			break;
		}
	}
	
	return( selectedLootName );
}


spawnLoot( victim, attacker)
{
	victim_guid = victim.guid;
	
	hintString = "Press and hold ^3&&1^7 to collect loot";
	useText = "Collecting Loot";
	
	lootValue = RandomIntRange( 0, 50 );
	lootType = getRandomLootType( lootValue );
	
	if ( isDefined( level.lootDrops[victim_guid] ) )
	{
		PlayFx( level.conf_fx["vanish"], level.lootDrops[victim_guid].origin );
		if( level.lootDrops[victim_guid].lootType == "once_only" )
		{
			lootType = "once_only";//keep the once only in play
		}
		level.lootDrops[victim_guid] removeLootDrop();
	}
	
	//lootValue = victim.killsThisLife.size;
	level.lootDrops[victim_guid] = spawn( "script_model", (0,0,0) );
	
	level.lootDrops[victim_guid] endon( "reset" );
	
	score = 1;
	switch( lootType )
	{
		case "rare":
			level.lootDrops[victim_guid] setModel( "prop_dogtags_foe" );
			score = 5;
			break;
		case "special":
			level.lootDrops[victim_guid] setModel( "prop_dogtags_friend" );
			score = 3;
			break;
		case "common":
			level.lootDrops[victim_guid] setModel( "prop_dogtags_misc" );
			score = 1;
			break;
		case "once_only":
			level.lootDrops[victim_guid] setModel( "prop_dogtags_foe" );
			score = 10;
			break;
		default:
			level.lootDrops[victim_guid] setModel( "prop_dogtags_misc" );
			score = 1;
			break;
	}
	level.lootDrops[victim_guid].lootType = lootType;
	level.lootDrops[victim_guid] setCursorHint( "HINT_NOICON" );
	level.lootDrops[victim_guid] setHintString( hintString );
	level.lootDrops[victim_guid] MakeUsable();

	level.lootDrops[victim_guid] thread collectLootThink( useText );
	
	level.lootDrops[victim_guid].origin = victim.origin + (0,0,14);
	

	level.lootDrops[victim_guid] waittill ( "captured", player );
	//IPrintLnBold( "captured" );
	
	player playLocalSound( "ammo_crate_use" );
	
	player giveLoot( lootType );
	
	splash = lootType + " Loot Collected";
	event = lootType;
	
	player thread maps\mp\gametypes\_rank::xpEventPopup( splash );
	maps\mp\gametypes\_gamescore::givePlayerScore( event, player, undefined, true );
	
	player maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( player.pers["team"], score );	
	
	level.lootDrops[victim_guid] delete();
	//level.lootDrops = array_remove( level.lootDrops, level.lootDrops[victim_guid] );
}

removeLootDrop()
{
	self notify( "reset" );
	//level.lootDrops = array_remove( level.lootDrops, self );
	self delete();
}

collectLootThink( useText )
{
	self endon( "reset");
	while ( isDefined( self ) )
	{
		self waittill ( "trigger", player );

		if ( isDefined( self.owner ) && player != self.owner )
			continue;
				
		//if ( !self validateOpenConditions( player ) )
		//	continue;

		player.isCapturingLoot = true;
		if ( !useHoldThink( player, 500, useText ) )
		{
			player.isCapturingCrate = false;
			continue;
		}
		
		player.isCapturingLoot = false;
		self notify ( "captured", player );
	}
}


useHoldThink( player, useTime, useText ) 
{
    player playerLinkTo( self );
    player playerLinkedOffsetEnable();
    
    player _disableWeapon();
    
    self.curProgress = 0;
    self.inUse = true;
    self.useRate = 0;
    
	if ( isDefined( useTime ) )
		self.useTime = useTime;
	else
		self.useTime = 3000;
    
    player thread personalUseBar( self, useText );
   
    result = useHoldThinkLoop( player );
	assert ( isDefined( result ) );
    
    if ( isAlive( player ) )
    {
        player _enableWeapon();
        player unlink();
    }
    
    if ( !isDefined( self ) )
    	return false;

    self.inUse = false;
	self.curProgress = 0;

	return ( result );
}


personalUseBar( object, useText )
{
    self endon( "disconnect" );
    
    useBar = createPrimaryProgressBar( 0, 25 );
    useBarText = createPrimaryProgressBarText( 0, 25 );
    if ( !isDefined( useText ) )
    	useText = &"MP_CAPTURING_CRATE";
    useBarText setText( useText );

    lastRate = -1;
    while ( isReallyAlive( self ) && isDefined( object ) && object.inUse && !level.gameEnded )
    {
        if ( lastRate != object.useRate )
        {
            if( object.curProgress > object.useTime)
                object.curProgress = object.useTime;
               
            useBar updateBar( object.curProgress / object.useTime, (1000 / object.useTime) * object.useRate );

            if ( !object.useRate )
            {
                useBar hideElem();
                useBarText hideElem();
            }
            else
            {
                useBar showElem();
                useBarText showElem();
            }
        }    
        lastRate = object.useRate;
        wait ( 0.05 );
    }
    
    useBar destroyElem();
    useBarText destroyElem();
}

useHoldThinkLoop( player )
{
    while( !level.gameEnded && isDefined( self ) && isReallyAlive( player ) && player useButtonPressed() && self.curProgress < self.useTime )
    {
        self.curProgress += (50 * self.useRate);
       
       	if ( isDefined(self.objectiveScaler) )
        	self.useRate = 1 * self.objectiveScaler;
		else
			self.useRate = 1;

        if ( self.curProgress >= self.useTime )
            return ( isReallyAlive( player ) );
       
        wait 0.05;
    } 
    
    return false;
}