#include maps\mp\gametypes\_persistence_util;
#include maps\mp\gametypes\_hud_util;

init()
{
	level.missionCallbacks = [];

	precacheString(&"MP_CHALLENGE_COMPLETED");
	precacheString(&"MP_CURRENT_CHALLENGE");
	precacheString(&"MP_N_REMAINING");

//	registerMissionCallback( "playerKilled", ::ch_fragcook );	
	registerMissionCallback( "playerKilled", ::ch_grenadekill );
//	registerMissionCallback( "playerHardpoint", ::ch_radar );
	registerMissionCallback( "playerHardpoint", ::ch_uav );
	registerMissionCallback( "playerHardpoint", ::ch_airstrike );
	registerMissionCallback( "playerHardpoint", ::ch_chopper );
	registerMissionCallback( "playerAssist", ::ch_assists );	
}

registerMissionCallback(callback, func)
{
	if (!isdefined(level.missionCallbacks[callback]))
		level.missionCallbacks[callback] = [];
	level.missionCallbacks[callback][level.missionCallbacks[callback].size] = func;
}


getChallengeData( statsTable, name )
{
	data = spawnstruct();
	
	data.tierID = int(tableLookup( statsTable, 7, name, 1 ));
	data.stateNum = int(tableLookup( statsTable, 7, name, 2 ));
	data.statNum = int(tableLookup( statsTable, 7, name, 3 ));
	data.maxVal = int(tableLookup( statsTable, 7, name, 4 ));
	data.minVal = int(tableLookup( statsTable, 7, name, 5 ));
	data.name = tableLookup( statsTable, 7, name, 8 );
	data.progress = self getStat( data.statNum );
	
	return data;
}


getChallengeStatus( statsTable, name )
{
	return self getStat( int(tableLookup( statsTable, 7, name, 2 )) );
}

// statsTable, baseName, levels
processChallenge( statsTable, baseName, numLevels )
{
	if ( numLevels > 1 )
	{
		missionStatus = self getChallengeStatus( statsTable, (baseName + "1") );
		refString = (baseName + missionStatus);
	}	
	else
	{
		missionStatus = self getChallengeStatus( statsTable, baseName );
		refString = baseName;
	}
	
	if ( !missionStatus || missionStatus > numLevels || missionStatus >= 20 )
		return;

	challengeData = self getChallengeData( statsTable, refString );
	challengeData.progress++;
	
	self setStat( challengeData.statNum, challengeData.progress );

	if ( challengeData.progress >= challengeData.maxVal )
	{
		self thread challengeNotify( challengeData.name );
		self thread challengeUnlock( statsTable, refString );
		
		if ( missionStatus == numLevels )
		{
			missionStatus = 255;
		}
		else			
		{
			if ( missionStatus > 10 )
				missionStatus += 11;
			else
				missionStatus += 21;

//			missionStatus += 1;
		}

		self setStat( challengeData.stateNum, missionStatus );
		self maps\mp\gametypes\_rank::giveRankXP( "challenge" );		
	}
}

challengeNotify( challengeName )
{
	self maps\mp\gametypes\_hud_message::notifyMessage( &"MP_CHALLENGE_COMPLETED", challengeName, undefined, undefined, "mp_challenge_complete" );
}

// items unlocked by completing this challenge
challengeUnlock( tableName, string_ref )
{
	if( !isdefined( tableName) || !isdefined( string_ref ) )
		return;

	// unlock camo skins if any	
	unlockCamo = tableLookup( tableName, 7, string_ref, 12 );
	self maps\mp\gametypes\_rank::unlockCamoAttachment( unlockCamo, "camo", "player_unlockcamo" );
	
	// unlock weapon attachment if any
	unlockAttachment = tableLookup( tableName, 7, string_ref, 13 );
	self maps\mp\gametypes\_rank::unlockCamoAttachment( unlockAttachment, "attachment", "player_unlockattachment" );	
}

ch_radar( data )
{
	if ( data.hardpointType != "radar_mp" )
		return;

	player = data.player;
	player processChallenge( "mp/challengeTable_tier1.csv", "ch_radar", 3 );
}


ch_assists( data )
{
	player = data.player;
	player processChallenge( "mp/challengeTable_tier1.csv", "ch_radar", 3 );
}


ch_uav( data )
{
	if ( data.hardpointType != "radar_mp" )
		return;

	player = data.player;
	player processChallenge( "mp/challengeTable_tier1.csv", "ch_uav", 1 );
}

ch_chopper( data )
{
	if ( data.hardpointType != "helicopter_mp" )
		return;

	player = data.player;
	player processChallenge( "mp/challengeTable_tier1.csv", "ch_chopper", 1 );
}

ch_airstrike( data )
{
	if ( data.hardpointType != "airstrike_mp" )
		return;

	player = data.player;
	player processChallenge( "mp/challengeTable_tier1.csv", "ch_airstrike", 1 );
}

ch_fragcook( data )
{
	if ( !isDefined( data.attacker ) || !isPlayer( data.attacker ) )
		return;

	if ( !isSubStr( data.sMeansOfDeath, "MOD_GRENADE" ) || !isDefined( data.victim.wasCooked ) )
		return;	
		
	player = data.attacker;
	player processChallenge( "mp/challengeTable_tier1.csv", "ch_airstrike", 1 );
}


ch_grenadekill( data )
{
	if ( !isDefined( data.attacker ) || !isPlayer( data.attacker ) )
		return;

	if ( !isSubStr( data.sMeansOfDeath, "MOD_GRENADE" ) )
		return;	
		
	player = data.attacker;
	player processChallenge( "mp/challengeTable_tier1.csv", "ch_airstrike", 1 );
}

/*
char *modNames[MOD_NUM] =
{
	"MOD_UNKNOWN",
	"MOD_PISTOL_BULLET",
	"MOD_RIFLE_BULLET",
	"MOD_GRENADE",
	"MOD_GRENADE_SPLASH",
	"MOD_PROJECTILE",
	"MOD_PROJECTILE_SPLASH",
	"MOD_MELEE",
	"MOD_HEAD_SHOT",
	"MOD_CRUSH",
	"MOD_TELEFRAG",
	"MOD_FALLING",
	"MOD_SUICIDE",
	"MOD_TRIGGER_HURT",
	"MOD_EXPLOSIVE",
	"MOD_IMPACT",
};

static const char *g_HitLocNames[] =
{
	"none",
	"helmet",
	"head",
	"neck",
	"torso_upper",
	"torso_lower",
	"right_arm_upper",
	"left_arm_upper",
	"right_arm_lower",
	"left_arm_lower",
	"right_hand",
	"left_hand",
	"right_leg_upper",
	"left_leg_upper",
	"right_leg_lower",
	"left_leg_lower",
	"right_foot",
	"left_foot",
	"gun",
};

*/

// ==========================================
// Callback functions

playerDamaged( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc )
{
	data = spawnstruct();

	data.victim = self;
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.sWeapon = sWeapon;
	data.sHitLoc = sHitLoc;

	doMissionCallback("playerDamaged", data);
}

playerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc )
{
	data = spawnstruct();

	data.victim = self;
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.sWeapon = sWeapon;
	data.sHitLoc = sHitLoc;

	doMissionCallback( "playerKilled", data );
}

playerAssist()
{
	data = spawnstruct();

	data.player = self;

	doMissionCallback( "playerAssist", data );
}


useHardpoint( hardpointType )
{
	data = spawnstruct();

	data.player = self;
	data.hardpointType = hardpointType;

	doMissionCallback( "playerHardpoint", data );
}


roundBegin()
{
	doMissionCallback( "roundBegin" );
}

roundEnd()
{
	doMissionCallback( "roundEnd" );
}

doMissionCallback( callback, data )
{
	if ( !level.xboxlive )
		return;
	
	if ( !isDefined( level.missionCallbacks[callback] ) )
		return;
	
	if ( isDefined( data ) ) 
	{
		for ( i = 0; i < level.missionCallbacks[callback].size; i++ )
			thread [[level.missionCallbacks[callback][i]]]( data );
	}
	else 
	{
		for ( i = 0; i < level.missionCallbacks[callback].size; i++ )
			thread [[level.missionCallbacks[callback][i]]]();
	}
}

