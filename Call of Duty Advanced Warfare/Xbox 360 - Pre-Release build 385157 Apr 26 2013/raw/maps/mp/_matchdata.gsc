#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	if ( !isDefined( game["gamestarted"] ) )
	{
		//setMatchDataDef( "mp/matchdata_" + level.gametype + ".def" );
		setMatchDataDef( "mp/matchdata.def" );
		setMatchData( "map", level.script );
		if( level.hardcoremode )
		{
			tmp = level.gametype + " hc";
			setMatchData( "gametype", tmp );
		}
		else
		{
			setMatchData( "gametype", level.gametype );
		}
		setMatchData( "buildVersion", getBuildVersion() );
		setMatchData( "buildNumber", getBuildNumber() );
		setMatchData( "dateTime", getSystemTime() );
		setMatchDataID();
	}

	level.MaxLives = 285; // must match MaxKills in matchdata definition
	level.MaxNameLength = 26; // must match Player xuid size in clientmatchdata definition
	level.MaxEvents = 150;
	level.MaxKillstreaks = 125;
	level.MaxLogClients = 30;
	level.MaxNumChallengesPerPlayer = 10;
	level.MaxNumAwardsPerPlayer = 10;
	
	level thread gameEndListener();
	level thread endOfGameSummaryLogger();
	/#
	level thread breadCrumbAllPlayers();
	#/
}

getMatchDateTime()
{
	return GetMatchData( "dateTime" );
}

logKillstreakEvent( event, position )
{
	assertEx( isPlayer( self ), "self is not a player: " + self.code_classname );
	
	if ( !canLogClient( self ) || !canLogKillstreak() )
		return;

	eventId = getMatchData( "killstreakCount" );
	setMatchData( "killstreakCount", eventId+1 );
	
	setMatchData( "killstreaks", eventId, "eventType", event );
	setMatchData( "killstreaks", eventId, "player", self.clientid );
	setMatchData( "killstreaks", eventId, "eventTime", getTime() );	
	setMatchData( "killstreaks", eventId, "eventPos", 0, int( position[0] ) );	
	setMatchData( "killstreaks", eventId, "eventPos", 1, int( position[1] ) );	
	setMatchData( "killstreaks", eventId, "eventPos", 2, int( position[2] ) );	
	/#
	ReconSpatialEvent( position, "script_mp_killstreak: eventType %s, player_name %s, player %d, eventTime %d", event, self.name, self.clientid, getTime() );
	#/
}


logGameEvent( event, position )
{
	assertEx( isPlayer( self ), "self is not a player: " + self.code_classname );

	if ( !canLogClient( self ) || !canLogEvent() )
		return;
		
	eventId = getMatchData( "eventCount" );
	setMatchData( "eventCount", eventId+1 );
	
	setMatchData( "events", eventId, "eventType", event );
	setMatchData( "events", eventId, "player", self.clientid );
	setMatchData( "events", eventId, "eventTime", getTime() );	
	setMatchData( "events", eventId, "eventPos", 0, int( position[0] ) );	
	setMatchData( "events", eventId, "eventPos", 1, int( position[1] ) );	
	setMatchData( "events", eventId, "eventPos", 2, int( position[2] ) );	
	/#
	ReconSpatialEvent( position, "script_mp_event: event_type %s, player_name %s, player %d, event_time %d", event, self.name, self.clientid, getTime() );
	#/
}


logKillEvent( lifeId, eventRef )
{
	if ( !canLogLife( lifeId ) )
		return;

	setMatchData( "lives", lifeId, "modifiers", eventRef, true );
}


logMultiKill( lifeId, multikillCount )
{
	if ( !canLogLife( lifeId ) )
		return;

	setMatchData( "lives", lifeId, "multikill", multikillCount );
}


logPlayerLife( died )
{
	if ( !canLogClient( self ) || !canLogLife( self.lifeId ) )
		return;

	lifeDuration = getTime() - self.spawnTime;
	self.totalLifeTime += lifeDuration;
		
	setMatchData( "lives", self.lifeId, "player", self.clientid );
	setMatchData( "lives", self.lifeId, "spawnPos", 0,  int( self.spawnPos[0] ) );
	setMatchData( "lives", self.lifeId, "spawnPos", 1,  int( self.spawnPos[1] ) );
	setMatchData( "lives", self.lifeId, "spawnPos", 2,  int( self.spawnPos[2] ) );
	setMatchData( "lives", self.lifeId, "wasTacticalInsertion", self.wasTI );
	setMatchData( "lives", self.lifeId, "team", self.team );
	setMatchData( "lives", self.lifeId, "spawnTime", self.spawnTime );	
	setMatchData( "lives", self.lifeId, "duration", lifeDuration );
		
	self logLoadout( self.lifeId );
	/#
	ReconSpatialEvent( self.spawnPos, "script_mp_playerspawn: player_name %s, player %d, life_id %d, was_tactical_insertion %b, team %s, spawn_time %d, duration %d, was_death %b", self.name, self.clientid, self.lifeId, self.wasTI, self.team, self.spawnTime, getTime() - self.spawnTime, died );
	#/
		
	lootServiceOnLogPlayerLife( self.xuid, lifeDuration );
}

logPlayerXP( xp, xpName  )
{
	if ( !canLogClient( self ) )
		return;
	setMatchData( "players", self.clientid, xpName, xp );
}


logLoadout( lifeId )
{
	if ( !canLogClient( self ) || !canLogLife( lifeId ) || self.curClass == "gamemode" )
		return;

	class = self.curClass;

	loadoutKillstreak1 = "";
	loadoutKillstreak2 = "";
	loadoutKillstreak3 = "";
	loadoutKillstreak4 = "";
	//loadoutDeathStreak = "";

	loadoutPerks = [];
	
	if ( class == "copycat" )
	{
		clonedLoadout = self.pers["copyCatLoadout"];

		loadoutPrimary = clonedLoadout["loadoutPrimary"];
		loadoutPrimaryAttachment = clonedLoadout["loadoutPrimaryAttachment"];
		loadoutPrimaryAttachment2 = clonedLoadout["loadoutPrimaryAttachment2"] ;
		loadoutPrimaryCamo = clonedLoadout["loadoutPrimaryCamo"];
		for (i=0; i<6; i++)
		{
			loadoutPerks[i] = clonedLoadout["loadoutPerks"][i];
		}
		loadoutSecondary = clonedLoadout["loadoutSecondary"];
		loadoutSecondaryAttachment = clonedLoadout["loadoutSecondaryAttachment"];
		loadoutSecondaryAttachment2 = clonedLoadout["loadoutSecondaryAttachment2"];
		loadoutSecondaryCamo = clonedLoadout["loadoutSecondaryCamo"];
		loadoutEquipment = clonedLoadout["loadoutEquipment"];
		loadoutOffhand = clonedLoadout["loadoutOffhand"];
		//loadoutDeathStreak = clonedLoadout["loadoutDeathstreak"];
		loadoutStreakType = clonedLoadout["loadoutStreakType"];
		loadoutKillstreak1 = clonedLoadout["loadoutKillstreak1"];
		loadoutKillstreak2 = clonedLoadout["loadoutKillstreak2"];
		loadoutKillstreak3 = clonedLoadout["loadoutKillstreak3"];
		loadoutKillstreak4 = clonedLoadout["loadoutKillstreak4"];
	}
	else if( isSubstr( class, "custom" ) )
	{
		class_num = maps\mp\gametypes\_class::getClassIndex( class );

		loadoutPrimary = maps\mp\gametypes\_class::cac_getWeapon( class_num, 0 );
		loadoutPrimaryAttachment = maps\mp\gametypes\_class::cac_getWeaponAttachment( class_num, 0 );
		loadoutPrimaryAttachment2 = maps\mp\gametypes\_class::cac_getWeaponAttachmentTwo( class_num, 0 );
		for (i=0; i<6; i++)
		{
			loadoutPerks[i] = maps\mp\gametypes\_class::cac_getPerk( class_num, i );
		}

		loadoutSecondary = maps\mp\gametypes\_class::cac_getWeapon( class_num, 1 );
		loadoutSecondaryAttachment = maps\mp\gametypes\_class::cac_getWeaponAttachment( class_num, 1 );
		loadoutSecondaryAttachment2 = maps\mp\gametypes\_class::cac_getWeaponAttachmentTwo( class_num, 1 );

		loadoutOffhand = maps\mp\gametypes\_class::cac_getOffhand( class_num );

		loadoutEquipment = maps\mp\gametypes\_class::cac_getEquipment( class_num, 0 );

		loadoutStreakType = maps\mp\gametypes\_class::cac_getStreaktype( class_num );
		//loadoutDeathStreak = maps\mp\gametypes\_class::cac_getDeathstreak( class_num );
		loadoutKillstreak1 = maps\mp\gametypes\_class::cac_getKillstreak( class_num, loadoutStreakType, 0 );
		loadoutKillstreak2 = maps\mp\gametypes\_class::cac_getKillstreak( class_num, loadoutStreakType, 1 );
		loadoutKillstreak3 = maps\mp\gametypes\_class::cac_getKillstreak( class_num, loadoutStreakType, 2 );
		loadoutKillstreak4 = maps\mp\gametypes\_class::cac_getKillstreak( class_num, loadoutStreakType, 3 );
	}
	else
	{
		class_num = maps\mp\gametypes\_class::getClassIndex( class );
		
		loadoutPrimary = maps\mp\gametypes\_class::table_getWeapon( level.classTableName, class_num, 0 );
		loadoutPrimaryAttachment = maps\mp\gametypes\_class::table_getWeaponAttachment( level.classTableName, class_num, 0 , 0);
		loadoutPrimaryAttachment2 = maps\mp\gametypes\_class::table_getWeaponAttachment( level.classTableName, class_num, 0, 1 );
		for (i=0; i<6; i++)
		{
			loadoutPerks[i] = maps\mp\gametypes\_class::table_getPerk( level.classTableName, class_num, i );
		}

		loadoutSecondary = maps\mp\gametypes\_class::table_getWeapon( level.classTableName, class_num, 1 );
		loadoutSecondaryAttachment = maps\mp\gametypes\_class::table_getWeaponAttachment( level.classTableName, class_num, 1 , 0);
		loadoutSecondaryAttachment2 = maps\mp\gametypes\_class::table_getWeaponAttachment( level.classTableName, class_num, 1, 1 );;

		loadoutOffhand = maps\mp\gametypes\_class::table_getOffhand( level.classTableName, class_num );
		loadoutEquipment = maps\mp\gametypes\_class::table_getEquipment( level.classTableName, class_num, 0 );

		loadoutStreakType = maps\mp\gametypes\_class::table_getStreaktype( level.classTableName, class_num );
		//loadoutDeathStreak = maps\mp\gametypes\_class::table_getDeathstreak( level.classTableName, class_num );
		loadoutKillstreak1 = maps\mp\gametypes\_class::table_getKillstreak( level.classTableName, class_num, 1 );
		loadoutKillstreak2 = maps\mp\gametypes\_class::table_getKillstreak( level.classTableName, class_num, 2 );
		loadoutKillstreak3 = maps\mp\gametypes\_class::table_getKillstreak( level.classTableName, class_num, 3 );
		loadoutKillstreak4 = "none"; // assuming default classes cannot have the extra killstreak.
	}
	
	loadoutPrimaryAttachment = validateAttachment( loadoutPrimaryAttachment );
	loadoutPrimaryAttachment2 = validateAttachment( loadoutPrimaryAttachment2 );
	loadoutSecondaryAttachment = validateAttachment( loadoutSecondaryAttachment );
	loadoutSecondaryAttachment2 = validateAttachment( loadoutSecondaryAttachment2 );
	
	setMatchData( "lives", lifeId, "primaryWeapon", loadoutPrimary );
	setMatchData( "lives", lifeId, "primaryAttachments", 0, loadoutPrimaryAttachment );
	setMatchData( "lives", lifeId, "primaryAttachments", 1, loadoutPrimaryAttachment2 );
	for (i=0; i<6; i++)
	{
		setMatchData( "lives", lifeId, "perkSlots", i, loadoutPerks[i] );
	}

	setMatchData( "lives", lifeId, "secondaryWeapon", loadoutSecondary );
	setMatchData( "lives", lifeId, "secondaryAttachments", 0,  loadoutSecondaryAttachment );
	setMatchData( "lives", lifeId, "secondaryAttachments", 1,  loadoutSecondaryAttachment2 );

	setMatchData( "lives", lifeId, "offhandWeapon", loadoutOffhand );

	setMatchData( "lives", lifeId, "equipment", loadoutEquipment );
	
	setMatchData( "lives", lifeId, "strikePackage", loadoutStreakType );
	//setMatchData( "lives", lifeId, "deathstreak", loadoutDeathStreak );
	switch( loadoutStreakType )
	{
	case "streaktype_assault":
		setMatchData( "lives", lifeId, "assaultStreaks", 0, loadoutKillstreak1 );
		setMatchData( "lives", lifeId, "assaultStreaks", 1, loadoutKillstreak2 );
		setMatchData( "lives", lifeId, "assaultStreaks", 2, loadoutKillstreak3 );
		setMatchData( "lives", lifeId, "assaultStreaks", 3, loadoutKillstreak4 );
		break;
	case "streaktype_support":
		setMatchData( "lives", lifeId, "defenseStreaks", 0, loadoutKillstreak1 );
		setMatchData( "lives", lifeId, "defenseStreaks", 1, loadoutKillstreak2 );
		setMatchData( "lives", lifeId, "defenseStreaks", 2, loadoutKillstreak3 );
		setMatchData( "lives", lifeId, "defenseStreaks", 3, loadoutKillstreak4 );
		break;
	case "streaktype_specialist":
		setMatchData( "lives", lifeId, "specialistStreaks", 0, loadoutKillstreak1 );
		setMatchData( "lives", lifeId, "specialistStreaks", 1, loadoutKillstreak2 );
		setMatchData( "lives", lifeId, "specialistStreaks", 2, loadoutKillstreak3 );
		setMatchData( "lives", lifeId, "specialistStreaks", 3, loadoutKillstreak4 );
		break;
	case "none":
		break;
	}
	/#
		// TODO: Fill out this recon event with all of the weapon and equipment perks.
		ReconEvent( "script_mp_loadout: player_name %s, player %d, life_id %d, primary_weapon %s, primary_attach1 %s, primary_attach2 %s, primary_buff %s, secondary_weapon %s, secondary_attach1 %s, equipment %s, perk1 %s, perk2 %s, perk3 %s, offhand %s, streak_type %s, ks1 %s, ks2 %s, ks3 %s, ks4 %s", self.name, self.clientid, lifeId, loadoutPrimary, loadoutPrimaryAttachment, loadoutPrimaryAttachment2, loadoutPerks[3], loadoutSecondary, loadoutSecondaryAttachment, loadoutEquipment, loadoutPerks[0], loadoutPerks[1], loadoutPerks[2], loadoutOffhand, loadoutStreakType, loadoutKillstreak1, loadoutKillstreak2, loadoutKillstreak3, loadoutKillstreak4 );
	#/
}


logPlayerDeath( lifeId, attacker, iDamage, sMeansOfDeath, sWeapon, sPrimaryWeapon, sHitLoc )
{	
	if ( !canLogClient( self ) || ( isPlayer( attacker ) && !canLogClient( attacker ) ) || !canLogLife( lifeId ) )
		return;
	
	if ( lifeId >= level.MaxLives )
		return;
	
	if ( sWeapon == "none" )
	{
		sWeaponType = "none";
		sWeaponClass = "none";
	}
	else
	{
		sWeaponType = weaponInventoryType( sWeapon );
		sWeaponClass = weaponClass( sWeapon );
	}
	
	if ( isSubstr( sWeapon, "destructible" ) )
		sWeapon = "destructible";
	
	attachment0 = "None";
	attachment1 = "None";
	weaponName = "";
	
	if ( isDefined( sWeaponType ) && (sWeaponType == "primary" || sWeaponType == "altmode") && (sWeaponClass == "pistol" || sWeaponClass == "smg" || sWeaponClass == "rifle" || sWeaponClass == "spread" || sWeaponClass == "mg" || sWeaponClass == "grenade" || sWeaponClass == "rocketlauncher" || sWeaponClass == "sniper" || sWeaponClass == "energy" ) )
	{
		sWeaponOriginal = undefined;
		
		if ( sWeaponType == "altmode" )
		{
			sWeaponOriginal = sWeapon;
			if ( isDefined(sPrimaryWeapon) )
			sWeapon = sPrimaryWeapon;
			
			setMatchData( "lives", lifeId, "altMode", true );
		}
		
		assertEx( isDefined(sWeapon), "No weapon defined in log player death" );
		
		weaponTokens = getWeaponNameTokens( sWeapon );
		weaponName = getBaseWeaponName( sWeapon );

		/#
		if ( !(weaponTokens.size > 1 && weaponTokens.size <= 4) )
		{
			PrintLn( "attacker: ", attacker );
			PrintLn( "iDamage: ", iDamage );
			PrintLn( "sMeansOfDeath: ", sMeansOfDeath );
			
			if ( isDefined( sWeaponOriginal ) )
				PrintLn( "sWeaponOriginal: ", sWeaponOriginal );
				
			PrintLn( "sWeapon: ", sWeapon );
			PrintLn( "sPrimaryWeapon: ", sPrimaryWeapon );
			PrintLn( "--------------------------------" );
			PrintLn( "sWeaponType: ", sWeaponType );
			PrintLn( "sWeaponClass: ", sWeaponClass );
			PrintLn( "--------------------------------" );
			PrintLn( "weaponTokens.size: ", weaponTokens.size );

			tokenCount = 0;
			foreach ( token in weaponTokens )
			{
				PrintLn( "weaponTokens[", tokenCount, "]: ", weaponTokens[tokenCount] );
				tokenCount++;
			}
		}
		#/
		
		if ( weaponTokens[0] == "iw5" || weaponTokens[0] == "iw6" )
		{
			assert( weaponTokens.size > 1 );
			
			/*
			if ( isSubStr( baseMW5WeaponName, "akimbo" ) )
			{
				baseMW5WeaponName = fixAkimboString( baseMW5WeaponName, false );
			}
			*/
			if( isDefined( weaponTokens[3] ) && isSubStr( weaponTokens[3], "scope" ) && isSubStr( weaponTokens[3], "vz" ) )
					weaponTokens[3] = "vzscope";
					
			if( isDefined( weaponTokens[4] ) && isSubStr( weaponTokens[4], "scope" ) && isSubStr( weaponTokens[4], "vz" ) )
					weaponTokens[4] = "vzscope";
			
			if( isDefined( weaponTokens[3] ) && isSubStr( weaponTokens[3], "scope" ) && !isSubStr( weaponTokens[3], "vz" ) )
				weaponTokens[3] = undefined;
					
			if( isDefined( weaponTokens[4] ) && isSubStr( weaponTokens[4], "scope" ) && !isSubStr( weaponTokens[4], "vz" ) )
				weaponTokens[4] = undefined;
			
			
			if ( isDefined( weaponTokens[3] ) && isAttachment( weaponTokens[3] ) )
			{
				attachment0 = validateAttachment( weaponTokens[3] );
				setMatchData( "lives", lifeId, "attachments", 0, attachment0 );
			}
				
			if ( isDefined( weaponTokens[4] ) && isAttachment( weaponTokens[4] ) )
			{
				attachment1 = validateAttachment( weaponTokens[4] );
				setMatchData( "lives", lifeId, "attachments", 1, attachment1 );
			}
		}
		else if( weaponTokens[0] == "alt" )	
		{
			assert( weaponTokens.size > 1 );
			
			if ( isDefined( weaponTokens[4] ) && isAttachment( weaponTokens[4] ) )	
			{
				attachment0 = validateAttachment( weaponTokens[4] );
				setMatchData( "lives", lifeId, "attachments", 0, attachment0 );
			}
				
			if ( isDefined( weaponTokens[5] ) && isAttachment( weaponTokens[5] ) )
			{
				attachment1 = validateAttachment( weaponTokens[5] );
				setMatchData( "lives", lifeId, "attachments", 1, attachment1 );
			}
		}
		else
		{
			assert( weaponTokens.size > 1 && weaponTokens.size <= 4 );
	
			assertEx( weaponTokens[weaponTokens.size - 1] == "mp", "weaponTokens[weaponTokens.size - 1]: " + weaponTokens[weaponTokens.size - 1] );
			weaponTokens[weaponTokens.size - 1] = undefined; // remove the trailing "mp"
					
	
			if ( isDefined( weaponTokens[1] ) && sWeaponType != "altmode" )// && !isLootWeapon( weaponTokens ) )
			{
				attachment0 = validateAttachment( weaponTokens[1] );
				setMatchData( "lives", lifeId, "attachments", 0, attachment0 );
			}
		
			if ( isDefined( weaponTokens[2] ) && sWeaponType != "altmode" )
			{
				attachment1 = validateAttachment( weaponTokens[2] );
				setMatchData( "lives", lifeId, "attachments", 1, attachment1 );
			}
		
		}
	}
	else if ( sWeaponType == "item" || sWeaponType == "offhand" )
	{
		weaponName = strip_suffix( sWeapon, "_mp" );
	}
	else
	{
		weaponName = sWeapon;
	}
	
	setMatchData( "lives", lifeId, "weapon", weaponName );
	
	if ( isKillstreakWeapon( sWeapon ) )
		setMatchData( "lives", lifeId, "modifiers", "killstreak", true );
		
	setMatchData( "lives", lifeId, "mod", sMeansOfDeath );
	deathDot = 2;
	if ( isPlayer( attacker ) )
	{
		setMatchData( "lives", lifeId, "attacker", attacker.clientid );
		setMatchData( "lives", lifeId, "attackerPos", 0, int( attacker.origin[0] ) );
		setMatchData( "lives", lifeId, "attackerPos", 1, int( attacker.origin[1] ) );
		setMatchData( "lives", lifeId, "attackerPos", 2, int( attacker.origin[2] ) );

		victimForward = anglesToForward( (0,self.angles[1],0) );
		attackDirection = (self.origin - attacker.origin);
		attackDirection = VectorNormalize( (attackDirection[0], attackDirection[1], 0) );
		deathDot = VectorDot( victimForward, attackDirection );
		setMatchData( "lives", lifeId, "dotOfDeath", deathDot );

		if( attacker isJuggernaut() )
			SetMatchData( "lives", lifeId, "attackerIsJuggernaut", true );
	}
	else
	{
		// 255 is world
		setMatchData( "lives", lifeId, "attacker", 255 );
		setMatchData( "lives", lifeId, "attackerPos", 0, int( self.origin[0] ) );
		setMatchData( "lives", lifeId, "attackerPos", 1, int( self.origin[1] ) );
		setMatchData( "lives", lifeId, "attackerPos", 2, int( self.origin[2] ) );
	}
	
	setMatchData( "lives", lifeId, "player", self.clientid );
	setMatchData( "lives", lifeId, "deathPos", 0, int( self.origin[0] ) );
	setMatchData( "lives", lifeId, "deathPos", 1, int( self.origin[1] ) );
	setMatchData( "lives", lifeId, "deathPos", 2, int( self.origin[2] ) );

	setMatchData( "lives", lifeId, "deathAngles", 0, int( self.angles[0] ) );
	setMatchData( "lives", lifeId, "deathAngles", 1, int( self.angles[1] ) );
	setMatchData( "lives", lifeId, "deathAngles", 2, int( self.angles[2] ) );	
	
	/#
	attacker_name = "world";
	if( IsPlayer( attacker ) )
		attacker_name = attacker.name;
	ReconSpatialEvent( self.origin, "script_mp_playerdeath: player_name %s, player %d, angles %v, attacker_name %s, attacker_pos %v, death_dot %f, is_jugg %b, is_killstreak %b, weapon_type %s, weapon_name %s, weapon %s, attachment0 %s, attachment1 %s, mod %s", self.name, self.clientid, self.angles, attacker_name, attacker.origin, deathDot, attacker isJuggernaut(), isKillstreakWeapon(sWeapon), sWeaponType, weaponName, sWeapon, attachment0, attachment1, sMeansOfDeath);
	#/
}


logPlayerData()
{
	if ( !canLogClient( self ) )
		return;
		
	setMatchData( "players", self.clientid, "score", self getPersStat( "score" ) );
	
	if( self getPersStat( "assists" ) > 255 )
		setMatchData( "players", self.clientid, "assists", 255 );
	else
		setMatchData( "players", self.clientid, "assists", self getPersStat( "assists" ) );
		
	if( self getPersStat( "longestStreak" ) > 255 )
		setMatchData( "players", self.clientid, "longestStreak", 255 );
	else
		setMatchData( "players", self.clientid, "longestStreak", self getPersStat( "longestStreak" ) );
}


// log the weapons and weaponXP to playerdata.
endOfGameSummaryLogger()
{
	level waittill ( "game_ended" );
	
	foreach ( player in level.players )
	{	
		wait( 0.05 );
		
		//player may disconnect during waits
		if ( !isdefined( player ) )
			continue;
		
		if ( isDefined ( player.weaponsUsed ) )
		{
			player doubleBubbleSort();
			counter = 0;
			
			if ( player.weaponsUsed.size > 3 )
			{
				for ( i = (player.weaponsUsed.size - 1); i > (player.weaponsUsed.size - 3); i-- )
				{
					player setPlayerData( "round", "weaponsUsed", counter, player.weaponsUsed[i] );
					player setPlayerData( "round", "weaponXpEarned", counter, player.weaponXpEarned[i] );
					counter++;
				}
			}
			else
			{
				for ( i = (player.weaponsUsed.size - 1); i >= 0; i-- )
				{
					player setPlayerData( "round", "weaponsUsed", counter, player.weaponsUsed[i] );
					player setPlayerData( "round", "weaponXpEarned", counter, player.weaponXpEarned[i] );
					counter++;
				}
			}
		}
		else
		{
			player setPlayerData( "round", "weaponsUsed", 0, "none" );
			player setPlayerData( "round", "weaponsUsed", 1, "none" );
			player setPlayerData( "round", "weaponsUsed", 2, "none" );
			player setPlayerData( "round", "weaponXpEarned", 0, 0 );
			player setPlayerData( "round", "weaponXpEarned", 1, 0 );
			player setPlayerData( "round", "weaponXpEarned", 2, 0 );
		}
		
		if ( isDefined ( player.challengesCompleted ) )
		{	
			player setPlayerData( "round", "challengeNumCompleted", player.challengesCompleted.size );
		}
		else 
		{
			player setPlayerData( "round", "challengeNumCompleted", 0 );
		}	
		
		for ( i = 0; i < 20; i++ )
		{
			if ( isDefined( player.challengesCompleted ) && isDefined( player.challengesCompleted[i] ) && player.challengesCompleted[i] != "ch_prestige" && !IsSubStr( player.challengesCompleted[i], "_daily" ) && !IsSubStr( player.challengesCompleted[i], "_weekly" ) )		
				player setPlayerData( "round", "challengesCompleted", i, player.challengesCompleted[i] );
			else
				player setPlayerData( "round", "challengesCompleted", i, "" );
		}
	}
	
}

doubleBubbleSort()
{
	A = self.weaponXpEarned;
	n = self.weaponXpEarned.size;
  
  	for (i =(n-1); i > 0; i--)
    { 
    	for (j = 1; j <= i; j++)
        {
        	if( A[j-1] < A[j] )
           	{
           		temp = self.weaponsUsed[j];          
				self.weaponsUsed[j] = self.weaponsUsed[j-1];     
				self.weaponsUsed[j-1] = temp; 
				
				temp2 = self.weaponXpEarned[j];          
				self.weaponXpEarned[j] = self.weaponXpEarned[j-1];     
				self.weaponXpEarned[j-1] = temp2; 
				A = self.weaponXpEarned;
        	}
        }
    }
}


/*Recursive nonsense sorts based on array 1 and sorts array 2's indexes (should be logn)
quickDoubleSort() 
{
	quickDoubleSortMid( 0, self.weaponsUsed.size -1 );
}
quickDoubleSortMid( start, end )
{
	i = start;
	k = end;

	if (end - start >= 1)
    {
        pivot = self.weaponXpEarned[start];  

        while (k > i)         
        {
	        while (self.weaponXpEarned[i] <= pivot && i <= end && k > i)  
	        	i++;                                 
	        while (self.weaponXpEarned[k] > pivot && k >= start && k >= i) 
	            k--;                                      
	        if (k > i)                                 
	           self.weaponXpEarned = doubleSwap( i, k );                    
        }
        array = doubleSwap( start, k );                                               
        array = quickDoubleSortMid(start, k - 1); 
        array = quickDoubleSortMid(k + 1, end);   
    }
}
doubleSwap(index1, index2) 
{
	temp = self.weaponsUsed[index1];          
	self.weaponsUsed[index1] = self.weaponsUsed[index2];     
	self.weaponsUsed[index2] = temp; 
	
	temp2 = self.weaponXpEarned[index1];          
	self.weaponXpEarned[index1] = self.weaponXpEarned[index2];     
	self.weaponXpEarned[index2] = temp2;     
}
*///end recursive nightmare sort.


// log the lives of players who are still alive at match end.
gameEndListener()
{
	level waittill ( "game_ended" );
	
	foreach ( player in level.players )
	{		
		player logPlayerData();
		
		if ( !isAlive( player ) )
			continue;
			
		player logPlayerLife( false );
	}

	// compute the players score per minute
	foreach ( player in level.players )
	{
		// report the player spm
		scoreperminute = player getPersStat( "score" ) / ( player.totalLifeTime / 60000 );
		tournamentreportplayerspm( player.xuid, scoreperminute, player.team );
		
		// reset the player total life time
		player.totalLifeTime = 0;
	}
}

canLogClient( client )
{
	assertEx( isPlayer( client ) , "Client is not a player: " + client.code_classname );
	return ( client.clientid < level.MaxLogClients );
}

canLogEvent()
{
	return ( getMatchData( "eventCount" ) < level.MaxEvents );
}

canLogKillstreak()
{
	return ( getMatchData( "killstreakCount" ) < level.MaxKillstreaks );
}

canLogLife( lifeId )
{
	return ( getMatchData( "lifeCount" ) < level.MaxLives );
}

logWeaponStat( weaponName, statName, incValue )
{
	if ( !canLogClient( self ) )
		return;
	
	if( isKillstreakWeapon( weaponName ) )
		return;

	oldValue = getMatchData( "players", self.clientid, "weaponStats", weaponName, statName );
	if( statName == "kills" || statName == "deaths" || statName == "headShots" )
	{
		if( oldValue+incValue > 255 )
		{
			setMatchData( "players", self.clientid, "weaponStats", weaponName, statName, 255 );	
		}
		else
		{
			setMatchData( "players", self.clientid, "weaponStats", weaponName, statName, oldValue+incValue );	
		} 
	}
	setMatchData( "players", self.clientid, "weaponStats", weaponName, statName, oldValue+incValue );	
}

logAttachmentStat( weaponName, statName, incValue )
{
	if ( !canLogClient( self ) )
		return;
	
	oldValue = getMatchData( "players", self.clientid, "attachmentsStats", weaponName, statName );
	setMatchData( "players", self.clientid, "attachmentsStats", weaponName, statName, oldValue+incValue );	
}

buildBaseWeaponList()
{
	baseWeapons = [];
	max_weapon_num = 149;
	for( weaponId = 0; weaponId <= max_weapon_num; weaponId++ )
	{
		weapon_name = tablelookup( "mp/statstable.csv", 0, weaponId, 4 );
		if( weapon_name == "" )
			continue;
		
		if ( !isSubStr( tableLookup( "mp/statsTable.csv", 0, weaponId, 2 ), "weapon_" ) )
			continue;
		
		if ( tableLookup( "mp/statsTable.csv", 0, weaponId, 2 ) == "weapon_other" )
			continue;
			 
		baseWeapons[baseWeapons.size] = weapon_name;
	}
	return baseWeapons;
}

logChallenge( challengeName, tier )
{
	if ( !canLogClient( self ) )
		return;
	
	// we don't want to log daily and weekly challenges
	if( IsSubStr( challengeName, "_daily" ) || IsSubStr( challengeName, "_weekly" ) )
		return;

	challengeCount = getMatchData( "players", self.clientid, "challengeCount" );
	if( challengeCount < level.MaxNumChallengesPerPlayer )
	{
		setMatchData( "players", self.clientid, "challenge", challengeCount, challengeName );
		setMatchData( "players", self.clientid, "tier", challengeCount, tier );
		setMatchData( "players", self.clientid, "challengeCount", challengeCount + 1 );
	}
}

logAward( awardName )
{
	if ( !canLogClient( self ) )
		return;
	
	awardCount = getMatchData( "players", self.clientid, "awardCount" );
	if( awardCount < level.MaxNumAwardsPerPlayer )
	{
		setMatchData( "players", self.clientid, "awards", awardCount, awardName );
		setMatchData( "players", self.clientid, "awardCount", awardCount + 1 );
	}
}

logKillsConfirmed()
{
	if ( !canLogClient( self ) )
		return;
	
	setMatchData( "players", self.clientid, "killsConfirmed", self.pers["confirmed"] );
}

logKillsDenied()
{
	if ( !canLogClient( self ) )
		return;
		
	setMatchData( "players", self.clientid, "killsDenied", self.pers["denied"] );
}

/#
breadCrumbAllPlayers()
{
	while (true)
	{
		if (getdvarint("cl_freemove")==0)
		{
			foreach (player in level.players)
			{
				if ( IsBot( player ) )
					continue;	// for now, don't record bots
				ReconSpatialEvent( player.origin, "script_mp_playerpos: player_name %s, player %d, angles %v, event_time %d", player.name, player.clientid, player.angles, getTime());
			}
		}
		wait 0.2;
	}
}
#/
