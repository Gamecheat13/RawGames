//	Callback Setup
//	This script provides the hooks from code into script for the gametype callback functions.

//=============================================================================
// Code Callback functions

/*================
Called by code after the level's main script function has run.
================*/
CodeCallback_StartGameType()
{
	// If the gametype has not beed started, run the startup
	if(!isDefined(level.gametypestarted) || !level.gametypestarted)
	{
		[[level.callbackStartGameType]]();

		level.gametypestarted = true; // so we know that the gametype has been started up
	}
}

/*================
Called when a player begins connecting to the server.
Called again for every map change or tournement restart.

Return undefined if the client should be allowed, otherwise return
a string with the reason for denial.

Otherwise, the client will be sent the current gamestate
and will eventually get to ClientBegin.

firstTime will be qtrue the very first time a client connects
to the server machine, but qfalse on map changes and tournement
restarts.
================*/
CodeCallback_PlayerConnect()
{
	self endon("disconnect");
	println("****Coop CodeCallback_PlayerConnect****");
	
/#
	if ( !isdefined( level.callbackPlayerConnect ) )
	{
		assertMsg("_callbacksetup::SetupCallbacks() needs to be called in your main level function.");	
		maps\_callbackglobal::Callback_PlayerConnect();
		return;
	}
#/

	[[level.callbackPlayerConnect]]();
}

/*================
Called when a player drops from the server.
Will not be called between levels.
self is the player that is disconnecting.
================*/
CodeCallback_PlayerDisconnect()
{
	self notify("disconnect");
	println("****Coop CodeCallback_PlayerDisconnect****");
/#
	if ( !isdefined( level.callbackPlayerDisconnect ) )
	{
		assertMsg("_callbacksetup::SetupCallbacks() needs to be called in your main level function.");	
		maps\_callbackglobal::Callback_PlayerDisconnect();
		return;
	}
#/

	[[level.callbackPlayerDisconnect]]();
}

/*================
Called when a player has taken damage.
self is the player that took damage.
================*/
CodeCallback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset)
{
	self endon("disconnect");
	println("****Coop CodeCallback_PlayerDamage****");
/#
	if ( !isdefined( level.callbackPlayerDamage ) )
	{
		assertMsg("_callbacksetup::SetupCallbacks() needs to be called in your main level function.");	
		maps\_callbackglobal::Callback_PlayerDamage();
		return;
	}
#/

	[[level.callbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
}



/*================
Called when a player has been killed.
self is the player that was killed.
================*/
CodeCallback_PlayerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration)
{
	self endon("disconnect");
	println("****Coop CodeCallback_PlayerKilled****");
	println("----> Spawn 2 ");

/#
	if ( !isdefined( level.callbackPlayerKilled ) )
	{
		assertMsg("_callbacksetup::SetupCallbacks() needs to be called in your main level function.");	
		maps\_callbackglobal::Callback_PlayerKilled();
		return;
	}
#/

	[[level.callbackPlayerKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration);
}

/*================
Called when a save game has been restored.
self is the level.
================*/
CodeCallback_SaveRestored()
{
	self endon("disconnect");
	println("****Coop CodeCallback_SaveRestored****");

/#
	if ( !isdefined( level.callbackSaveRestored ) )
	{
		assertMsg("_callbacksetup::SetupCallbacks() needs to be called in your main level function.");	
		maps\_callbackglobal::Callback_SaveRestored();
		return;
	}
#/

	[[level.callbackSaveRestored]]();
}

//=============================================================================

/*================
Setup any misc callbacks stuff like defines and default callbacks
================*/
SetupCallbacks()
{
	thread maps\_callbackglobal::SetupCallbacks();
	
	SetDefaultCallbacks();
	
	// Set defined for damage flags used in the playerDamage callback
	level.iDFLAGS_RADIUS			= 1;
	level.iDFLAGS_NO_ARMOR			= 2;
	level.iDFLAGS_NO_KNOCKBACK		= 4;
	level.iDFLAGS_NO_TEAM_PROTECTION	= 8;
	level.iDFLAGS_NO_PROTECTION		= 16;
	level.iDFLAGS_PASSTHRU			= 32;
}


/*================
Called from the gametype script to store off the default callback functions.
This allows the callbacks to be overridden by level script, but not lost.
================*/
SetDefaultCallbacks()
{
	// probably want to change this start game type function to something like start level
//	level.callbackStartGameType = maps\_callbackglobal::Callback_StartGameType;
	level.callbackSaveRestored = maps\_callbackglobal::Callback_SaveRestored;
	level.callbackPlayerConnect = maps\_callbackglobal::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = maps\_callbackglobal::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = maps\_callbackglobal::Callback_PlayerDamage;
	level.callbackPlayerKilled = maps\_callbackglobal::Callback_PlayerKilled;
}

/*================
Called when a gametype is not supported.
================*/
AbortLevel()
{
	println("Aborting level - gametype is not supported");

	level.callbackSaveRestored = ::callbackVoid;
	level.callbackStartGameType = ::callbackVoid;
	level.callbackPlayerConnect = ::callbackVoid;
	level.callbackPlayerDisconnect = ::callbackVoid;
	level.callbackPlayerDamage = ::callbackVoid;
	level.callbackPlayerKilled = ::callbackVoid;
	
	setdvar("g_gametype", "dm");

	//exitLevel(false);
}

/*================
================*/
callbackVoid()
{
}
