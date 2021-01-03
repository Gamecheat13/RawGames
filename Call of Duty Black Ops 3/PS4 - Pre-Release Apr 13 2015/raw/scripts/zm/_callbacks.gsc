#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_actor;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_globallogic_vehicle;
#using scripts\zm\gametypes\_hostmigration;
#using scripts\shared\bots\bot_traversals;

#namespace callback;

function autoexec __init__sytem__() {     system::register("callback",&__init__,undefined,undefined);    }
	
function __init__()
{
	level thread setup_callbacks();
}

//	Callback Setup
//	This script provides the hooks from code into script for the gametype callback functions.

//=============================================================================

/*================
Setup any misc callbacks stuff like defines and default callbacks
================*/
function setup_callbacks()
{
	SetDefaultCallbacks();
	
	//ID FLAGS
	//code-defined in g_local.h:
	//also matches shared/shared/gsh

	level.iDFLAGS_NOFLAG						= 0;
	level.iDFLAGS_RADIUS						= 1;	// damage was indirect
	level.iDFLAGS_NO_ARMOR						= 2;	// armor does not protect from this damage
	level.iDFLAGS_NO_KNOCKBACK					= 4;	// do not affect velocity, just view angles
	level.iDFLAGS_PENETRATION					= 8;	// damage occurred after one or more penetrations
	level.iDFLAGS_DESTRUCTIBLE_ENTITY			= 16;	// force the destructible system to do damage to the entity
	level.iDFLAGS_SHIELD_EXPLOSIVE_IMPACT		= 32;	// missile impacted on the front of the victim's shield
	level.iDFLAGS_SHIELD_EXPLOSIVE_IMPACT_HUGE	= 64;	//   ...and was from a projectile with "Big Explosion" checked on.
	level.iDFLAGS_SHIELD_EXPLOSIVE_SPLASH		= 128;	// explosive splash, somewhat deflected by the victim's shield
	level.iDFLAGS_HURT_TRIGGER_ALLOW_LASTSTAND	= 256;	// The trigger that applied the damage will ignore laststand
	level.iDFLAGS_DISABLE_RAGDOLL_SKIP			= 512;	// Don't go to ragdoll if got damage while playing death animation

	// script-defined:
	level.iDFLAGS_NO_TEAM_PROTECTION			= 1024;
	level.iDFLAGS_NO_PROTECTION					= 2048;
	level.iDFLAGS_PASSTHRU						= 4096;
}

/*================
Called from the gametype script to store off the default callback functions.
This allows the callbacks to be overridden by level script, but not lost.
================*/
function SetDefaultCallbacks()
{
	level.callbackStartGameType = &globallogic::Callback_StartGameType;
	level.callbackPlayerConnect = &globallogic_player::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = &globallogic_player::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = &globallogic_player::Callback_PlayerDamage;
	level.callbackPlayerKilled = &globallogic_player::Callback_PlayerKilled;
	level.callbackPlayerMelee = &globallogic_player::Callback_PlayerMelee;
	level.callbackPlayerLastStand = &globallogic_player::Callback_PlayerLastStand;
	level.callbackActorDamage = &globallogic_actor::Callback_ActorDamage;
	level.callbackActorSpawned = &globallogic_actor::Callback_ActorSpawned;
	level.callbackActorKilled = &globallogic_actor::Callback_ActorKilled;
	level.callbackVehicleSpawned = &globallogic_vehicle::Callback_VehicleSpawned;
	level.callbackVehicleDamage = &globallogic_vehicle::Callback_VehicleDamage;
	level.callbackVehicleRadiusDamage = &globallogic_vehicle::Callback_VehicleRadiusDamage;
	level.callbackPlayerMigrated = &globallogic_player::Callback_PlayerMigrated;
	level.callbackHostMigration = &hostmigration::Callback_HostMigration;
	level.callbackHostMigrationSave = &hostmigration::Callback_HostMigrationSave;
	level.callbackPreHostMigrationSave = &hostmigration::Callback_PreHostMigrationSave;
	level.callbackBotEnteredUserEdge = &bot::Callback_BotEnteredUserEdge;
	
	level._gametype_default = "zclassic";
}
