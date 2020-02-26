#include maps\_utility;
#include common_scripts\utility;
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
	/#println("****Coop CodeCallback_PlayerConnect****");#/
		
	// CODER_MOD: Jon E - This is needed for the SP_TOOL or MP_TOOL to work for MODS
	if ( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		maps\_callbackglobal::Callback_PlayerConnect();
		return; 
	}
	
/#
	if ( !isdefined( level.callbackPlayerConnect ) )
	{
		IPrintLnBold("_callbacksetup::SetupCallbacks() needs to be called in your main level function.");	
		maps\_callbackglobal::Callback_PlayerConnect();
		
		if(isdefined(level._gamemode_playerconnect))
		{
			[[level._gamemode_playerconnect]]();
		}
		
		return;
	}
#/

	[[level.callbackPlayerConnect]]();

	if(isdefined(level._gamemode_playerconnect))
	{
		self thread [[level._gamemode_playerconnect]]();
	}

}

/*================
Called when a player drops from the server.
Will not be called between levels.
self is the player that is disconnecting.
================*/
CodeCallback_PlayerDisconnect()
{
	self notify("disconnect");
	
	level notify ("player_disconnected");
	
	// CODER_MOD - DSL - 03/24/08
	// Tidy up ambient triggers.

	client_num = self getentitynumber();

/#
	println("****Coop CodeCallback_PlayerDisconnect****");

	if ( !isdefined( level.callbackPlayerDisconnect ) )
	{
		IPrintLnBold("_callbacksetup::SetupCallbacks() needs to be called in your main level function.");	
		maps\_callbackglobal::Callback_PlayerDisconnect();
		return;
	}
#/

	[[level.callbackPlayerDisconnect]]();
	
}

/*================
Called when a actor has spawned
self is the spawner 
spawn is ai spawned from spawner
================*/
CodeCallback_ActorSpawned( spawn )
{
	spawn thread maps\_spawner::spawn_think( self );
}

/*================
Called when a actor has taken damage.
self is the actor that took damage.
================*/
CodeCallback_ActorDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, timeOffset, boneName)
{
	self endon("disconnect");
/#
	if ( !isdefined( level.callbackActorDamage ) )
	{
		IPrintLnBold("_callbacksetup::SetupCallbacks() needs to be called in your main level function.");	
		maps\_callbackglobal::Callback_ActorDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, timeOffset, boneName);
		return;
	}
#/
	[[level.callbackActorDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, timeOffset, boneName);
}


/*================
Called when a player has taken damage.
self is the player that took damage.
================*/
CodeCallback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, timeOffset)
{
	self endon("disconnect");
	//println("****Coop CodeCallback_PlayerDamage****");
/#
	if ( !isdefined( level.callbackPlayerDamage ) )
	{
		IPrintLnBold("_callbacksetup::SetupCallbacks() needs to be called in your main level function.");	
		maps\_callbackglobal::Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, timeOffset);
		return;
	}
#/

	[[level.callbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, timeOffset);
}


/*================
Called when a player has been killed, but has last stand perk.
self is the player that was killed.
================*/
CodeCallback_PlayerRevive()
{
	self endon("disconnect");
	[[level.callbackPlayerRevive]]();
}

/*================
Called when a player has been killed, but has last stand perk.
self is the player that was killed.
================*/
CodeCallback_PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self endon("disconnect");
	[[level.callbackPlayerLastStand]]( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
}

/*================
Called when a player has been killed.
self is the player that was killed.
================*/
CodeCallback_PlayerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration)
{
	self endon("disconnect");
	/#println("****Coop CodeCallback_PlayerKilled****");#/

	// SUMEET - set missionfailed dvar so that we can hide bunch of hud elements when player dies
	SetSavedDvar( "hud_missionFailed", 1 );
	// delete any existing in-game instructions created by screen_message_create() functionality
	screen_message_delete();
}


/*================
Called when an actor has been killed.
self is the actor that was killed.
================*/
CodeCallback_ActorKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset)
{
	self endon("disconnect");
	[[level.callbackActorKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset);
}


/*================
Called when a vehicle has taken damage.
self is the vehicl that took damage.
================*/
CodeCallback_VehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, damageFromUnderneath, modelIndex, partName)
{
	[[level.callbackVehicleDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, damageFromUnderneath, modelIndex, partName);
}


/*================
Called when a save game has been restored.
self is the level.
================*/
CodeCallback_SaveRestored()
{
	self endon("disconnect");
	/#
	println("****Coop CodeCallback_SaveRestored****");

	if ( !isdefined( level.callbackSaveRestored ) )
	{
		IPrintLnBold("_callbacksetup::SetupCallbacks() needs to be called in your main level function.");	
		maps\_callbackglobal::Callback_SaveRestored();
		return;
	}
#/

	[[level.callbackSaveRestored]]();
}

/*================
Called from code when a client disconnects during load.
=================*/

CodeCallback_DisconnectedDuringLoad(name)
{
	if(!isdefined(level._disconnected_clients))
	{
		level._disconnected_clients = [];
	}
	
	level._disconnected_clients[level._disconnected_clients.size] = name;
}

// CODER_MOD - LDS - 06/02/10 - Callback to inform facial animation system of new event
CodeCallback_FaceEventNotify( notify_msg, ent )
{
	if( IsDefined( ent ) && IsDefined( ent.do_face_anims ) && ent.do_face_anims )
	{
		if( IsDefined( level.face_event_handler ) && IsDefined( level.face_event_handler.events[notify_msg] ) )
		{
			ent SendFaceEvent( level.face_event_handler.events[notify_msg] );
		}
	}
}


/*================
Called when a player has been killed, but has last stand perk.
self is the player that was killed.
================*/
CodeCallback_ActorShouldReact()
{
	self endon("disconnect");

	//PrintLn("****Coop CodeCallback_ActorShouldReact****");
	
	// Check if this AI should react
	if( self animscripts\react::shouldReact() )
	{
		// Call the code function to put the AI in reaction state
		self startactorreact();
	}
}

//=============================================================================

/*================
Setup any misc callbacks stuff like defines and default callbacks
================*/
SetupCallbacks()
{
	thread maps\_callbackglobal::SetupCallbacks();
	
	SetDefaultCallbacks();
	
	// code-defined:
	level.iDFLAGS_RADIUS						= 1;	// damage was indirect
	level.iDFLAGS_NO_ARMOR						= 2;	// armor does not protect from this damage
	level.iDFLAGS_NO_KNOCKBACK					= 4;	// do not affect velocity, just view angles
	level.iDFLAGS_PENETRATION					= 8;	// damage occurred after one or more penetrations
	level.iDFLAGS_DESTRUCTIBLE_ENTITY			= 16;	// force the destructible system to do damage to the entity
	level.iDFLAGS_SHIELD_EXPLOSIVE_IMPACT		= 32;	// missile impacted on the front of the victim's shield
	level.iDFLAGS_SHIELD_EXPLOSIVE_IMPACT_HUGE	= 64;	//   ...and was from a projectile with "Big Explosion" checked on.
	level.iDFLAGS_SHIELD_EXPLOSIVE_SPLASH		= 128;	// explosive splash, somewhat deflected by the victim's shield

	// script-defined:
	level.iDFLAGS_NO_TEAM_PROTECTION			= 256;
	level.iDFLAGS_NO_PROTECTION					= 512;
	level.iDFLAGS_PASSTHRU						= 1024;
}

CodeCallback_GlassSmash(pos, dir)
{
	level notify("glass_smash", pos, dir);
}

/*================
Called from the gametype script to store off the default callback functions.
This allows the callbacks to be overridden by level script, but not lost.
================*/
SetDefaultCallbacks()
{
	// probably want to change this start game type function to something like start level
	level.callbackStartGameType = maps\_callbackglobal::Callback_StartGameType;
	level.callbackSaveRestored = maps\_callbackglobal::Callback_SaveRestored;
	level.callbackPlayerConnect = maps\_callbackglobal::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = maps\_callbackglobal::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = maps\_callbackglobal::Callback_PlayerDamage;
	level.callbackActorDamage = maps\_callbackglobal::Callback_ActorDamage;
	level.callbackVehicleDamage = maps\_callbackglobal::Callback_VehicleDamage;
	level.callbackPlayerKilled = maps\_callbackglobal::Callback_PlayerKilled;
	level.callbackActorKilled = maps\_callbackglobal::Callback_ActorKilled;
	
	level.callbackPlayerLastStand = maps\_callbackglobal::Callback_PlayerLastStand;

	//level.callbackPlayerRevive = maps\_callbackglobal::Callback_RevivePlayer; // code doesn't seem to be calling this callback
}


/*================
================*/
callbackVoid()
{
}

