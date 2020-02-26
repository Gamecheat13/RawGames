#include maps\mp\gametypes\_persistence_util;
#include maps\mp\gametypes\_hud_util;

init()
{
	level.missionCallbacks = [];

	precacheString(&"MP_CHALLENGE_COMPLETED");
	precacheString(&"MP_CURRENT_CHALLENGE");
	precacheString(&"MP_N_REMAINING");

	missionDataBlock = level.persistentDataInfo["missions"];
	
	
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
	if (1) return; 
	
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
	if (1) return; 

	
	
}








killWithoutDyingPlayerKilled( killData )
{
	if ( !isDefined( killData.attacker ) || !isAlive( killData.attacker ) )
		return;

	
	missionIndex = killData.attacker statGet( "missions", "killWithoutDying_level" );
	if ( missionIndex < 1 )
	{
		killData.attacker statSet( "missions", "killWithoutDying_level", 1 );
		return;
	}
	
	
	if ( missionIndex > 4 )
		return;
	
	
		
	if ( killData.attacker.cur_kill_streak >= level.killsWithoutDying[missionIndex] )
	{
		
	}	

}








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

