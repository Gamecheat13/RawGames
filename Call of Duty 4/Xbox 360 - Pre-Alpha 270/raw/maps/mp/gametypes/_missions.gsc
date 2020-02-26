#include maps\mp\gametypes\_persistence_util;
#include maps\mp\gametypes\_hud_util;

init()
{
	level.missionCallbacks = [];

	precacheString(&"MP_CHALLENGE_COMPLETED");
	precacheString(&"MP_CURRENT_CHALLENGE");
	precacheString(&"MP_N_REMAINING");

	missionDataBlock = level.persistentDataInfo["missions"];
	
	// kill without dying mission init	
	precacheString(&"MP_CHALLENGE_GET_KILLS_WITHOUT_DYING");	
	missionDataBlock _addPersistentByte( "killWithoutDying_level" );
	registerMissionCallback( "playerKilled", ::killWithoutDyingPlayerKilled );
	level.killsWithoutDying[1] = 5;
	level.killsWithoutDying[2] = 10;
	level.killsWithoutDying[3] = 20;
	level.killsWithoutDying[4] = 30;

	missionDataBlock.checkSum = missionDataBlock generateCheckSum();
}

registerMissionCallback(callback, func)
{
	if (!isdefined(level.missionCallbacks[callback]))
		level.missionCallbacks[callback] = [];
	level.missionCallbacks[callback][level.missionCallbacks[callback].size] = func;
}

missionHUD()
{
	if (1) return; // disable hud stuff for now
	
	self.missionHUD1 = createFontString("default", 1.5);
	self.missionHUD1 setPoint("BOTTOMLEFT", undefined, 170, -60);
	self.missionHUD1 setText(&"MP_CURRENT_CHALLENGE");
	self.missionHUD2 = createFontString("default", 1.5);
	self.missionHUD2 setParent(self.missionHUD1);
	self.missionHUD2 setPoint("TOPLEFT", "BOTTOMLEFT", 0, 0);
	self.missionHUD3 = createFontString("default", 1.5);
	self.missionHUD3 setParent(self.missionHUD2);
	self.missionHUD3 setPoint("TOPLEFT", "BOTTOMLEFT", 0, 0);
	self thread updateMissionHUD();
}

updateMissionHUD()
{
	if (1) return; // disable hud stuff for now

	// this is kind of hardcoded to work with the kills without dying missions...
	/*
	missionIndex = self getPersistentData("killWithoutDyingCurrentMission");
	iprintln(missionIndex);
	if (missionIndex < 4) {
		self.missionHUD2 setText(&"MP_CHALLENGE_GET_KILLS_WITHOUT_DYING", (missionIndex + 1) * 4);
		self.missionHUD3 setText(&"MP_N_REMAINING", ((missionIndex + 1) * 4) - self getPersistentData("killsWithoutDying"));
	}
	else {
		self.missionHUD1 destroyElem();
		self.missionHUD2 destroyElem();
		self.missionHUD3 destroyElem();
	}
	*/
}

// ==========================================
// Mission callbacks
// Maybe these should be separated into a missions directory with one file per mission type.

// example mission: get X headshots
/*headshotMissionPlayerKilled(killData)
{
	if (killData.sMeansOfDeath != "MOD_HEAD_SHOT")
		return;
	
	if (!isdefined(killData.attacker) || !isalive(killData.attacker))
		return;

	// find the first incomplete headshot mission (0 to 3, or 4 if all are complete)
	missionIndex = killData.attacker getPersistentData("headshotCurrentMission");
	if (missionIndex >= 4)
		return;
	
	// increase number of head shots
	numHeadShots = killData.attacker incrementPersistentData("headshotNumHeadshots");
	
	// TODO: hud update
	
	if (numHeadShots >= (missionIndex+1)*5)
	{
		// completed headshot mission!
		killData.attacker iprintln(&"MP_CHALLENGE_COMPLETED");
		killData.attacker setPersistentData("headshotCurrentMission", missionIndex + 1);
		killData.attacker setPersistentData("headshotNumHeadshots", 0);
	}
}*/

killWithoutDyingPlayerKilled( killData )
{
	if ( !isDefined( killData.attacker ) || !isPlayer( killData.attacker ) || !isAlive( killData.attacker ) )
		return;

	// find the first incomplete headshot mission (0 to 3, or 4 if all are complete)
	missionIndex = killData.attacker statGet( "missions", "killWithoutDying_level" );
	if ( missionIndex < 1 )
	{
		killData.attacker statSet( "missions", "killWithoutDying_level", 1 );
		return;
	}
	
	// already completed mission
	if ( missionIndex > 4 )
		return;
	
	// increase number of head shots
		
	if ( killData.attacker.cur_kill_streak >= level.killsWithoutDying[missionIndex] )
	{
		killData.attacker iprintlnbold(&"MP_CHALLENGE_COMPLETED");
		killData.attacker iprintlnbold(&"MP_CHALLENGE_GET_KILLS_WITHOUT_DYING", level.killsWithoutDying[missionIndex] );
		killData.attacker statSet( "missions", "killWithoutDying_level", missionIndex + 1 );
		killData.attacker maps\mp\gametypes\_rank::giveRankXP( "challenge" );
	}	
//	killData.attacker thread updateMissionHUD();
}

/*
killWithoutDyingPlayerKilled( killData )
{
	killData.victim.killsWithoutDying = 0;
	killData.victim thread updateMissionHUD();
	
	if ( !isDefined( killData.attacker ) || !isAlive( killData.attacker ) )
		return;

	// find the first incomplete headshot mission (0 to 3, or 4 if all are complete)
	missionIndex = killData.attacker statGet( "missions", "killWithoutDying_level" )
	if ( missionIndex < 1 or missionIndex >= 4 )
		return;
	
	// increase number of head shots
	killsWithoutDying = killData.attacker incrementPersistentData("killsWithoutDying");
	
	if ( !isDefined( killData.attacker.killsWithoutDying ) )
		killData.attacker.killsWithoutDying = 0;
		
	if ( killsWithoutDying >= level.killsWithoutDying[missionIndex] )
	{
		killData.attacker iprintlnbold(&"MP_CHALLENGE_COMPLETED");
		killData.attacker iprintlnbold(&"MP_CHALLENGE_GET_KILLS_WITHOUT_DYING", level.killsWithoutDying[missionIndex] );
		killData.attacker statSet( "missions", "killWithoutDying_level", missionIndex + 1 );
		//killData.attacker [[level.updateScore]]("challenge_level_" + missionIndex);
	}
	
//	killData.attacker thread updateMissionHUD();
}
*/

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

