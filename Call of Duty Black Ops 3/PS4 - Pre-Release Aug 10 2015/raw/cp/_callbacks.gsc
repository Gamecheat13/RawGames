#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_actor;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\gametypes\_globallogic_vehicle;
#using scripts\cp\gametypes\_hostmigration;
#using scripts\shared\bots\bot_traversals;


#namespace callback;

function autoexec __init__sytem__() {     system::register("callback",&__init__,undefined,undefined);    }

function __init__()
{
	set_default_callbacks();
}

//	Callback Setup
//	This script provides the hooks from code into script for the gametype callback functions.

//=============================================================================

/*================
Setup any misc callbacks stuff like defines and default callbacks
================*/


/*================
Called from the gametype script to store off the default callback functions.
This allows the callbacks to be overridden by level script, but not lost.
================*/
function set_default_callbacks()
{
	level.callbackStartGameType = &globallogic::Callback_StartGameType;
	level.callbackPlayerConnect = &globallogic_player::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = &globallogic_player::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = &globallogic_player::Callback_PlayerDamage;
	level.callbackPlayerKilled = &globallogic_player::Callback_PlayerKilled;
	level.callbackPlayerMelee = &globallogic_player::Callback_PlayerMelee;
	level.callbackPlayerLastStand = &globallogic_player::Callback_PlayerLastStand;
	level.callbackActorSpawned = &globallogic_actor::Callback_ActorSpawned;
	level.callbackActorDamage = &globallogic_actor::Callback_ActorDamage;
	level.callbackActorKilled = &globallogic_actor::Callback_ActorKilled;
	level.callbackActorCloned = &globallogic_actor::Callback_ActorCloned;
	level.callbackVehicleSpawned = &globallogic_vehicle::Callback_VehicleSpawned;
	level.callbackVehicleDamage = &globallogic_vehicle::Callback_VehicleDamage;
	level.callbackVehicleKilled = &globallogic_vehicle::Callback_VehicleKilled;
	level.callbackVehicleRadiusDamage = &globallogic_vehicle::Callback_VehicleRadiusDamage;
	level.callbackPlayerMigrated = &globallogic_player::Callback_PlayerMigrated;
	level.callbackHostMigration = &hostmigration::Callback_HostMigration;
	level.callbackHostMigrationSave = &hostmigration::Callback_HostMigrationSave;
	level.callbackPreHostMigrationSave = &hostmigration::Callback_PreHostMigrationSave;
	level.callbackBotEnteredUserEdge = &bot::Callback_BotEnteredUserEdge;
	
	level._gametype_default = "coop";
}
