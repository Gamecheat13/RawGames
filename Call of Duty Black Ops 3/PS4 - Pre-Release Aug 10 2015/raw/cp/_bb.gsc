#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\bb_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace bb;

function autoexec __init__sytem__() {     system::register("bb",&__init__,undefined,undefined);    }

function __init__()
{
	bb::init_shared();;
}

function logObjectiveStatusChange(objectiveName, player, status)
{
	playerId = -1;
	if ( isPlayer(player) )
	{
		playerId = getplayerspawnid( player );
	}
	else
	{
		return; 	
	}
	
	bbPrint	( 	"cpcheckpoints", 
			    "gametime %d spawnid %d username %s checkpointname %s eventtype %s playerx %d playery %d playerz %d kills %d revives %d deathcount %d deaths %d headshots %d hits %d score %d shotshit %d shotsmissed %d suicides %d downs %d difficulty %s",
				gettime(),					//gametime
				playerId,					//spawnid
				player.name,
				objectiveName,				//checkpointname
				status,						//eventtype
				player.origin,				
				player.kills,				//kills
				player.revives,				//revives
				player.deathcount,			//deathcount
				player.deaths,				//deaths
				player.headshots,			//headshots
				player.hits,				//hits
				player.score,				//score
				player.shotshit,			//shotshit,
				player.shotsmissed,			//shotsmissed
				player.suicides,			//suicides
				player.downs,				//downs
				level.currentdifficulty		//difficulty
			);
}

function logDamage(attacker, victim, weapon, damage, damageType, hitLocation, victimKilled, victimDowned)
{
	victimID = -1;
	victimName = "";
	victimType = "";
	victimOrigin = (0, 0, 0);
	victimIgnoreMe = false;
	victimIgnoreAll = false;
	victimFovCos = 0;
	victimMaxSightDistSqrd = 0;
	victimAnimName = "";
	victimLastStand = 0;
	
	attackerID = -1;
	attackerName = "";
	attackerType = "";
	attackerOrigin = (0, 0, 0);
	attackerIgnoreMe = false;
	attackerIgnoreAll = false;
	attackerFovCos = 0;
	attackerMaxSightDistSqrd = 0;
	attackerAnimName = "";
	attackerLastStand = 0;
	
	aiVictimType = "";
	aiVictimRank = "";
	aiVictimCombatMode = "";
	
	aiAttackerType = "";
	aiAttackerRank = "";
	aiAttackerCombatMode = "";
	
	if ( isDefined(attacker) )
	{
		if( isPlayer(attacker) )
		{
			attackerID = getplayerspawnid( attacker );
			attackerType = "_player";
			attackername = attacker.name;
		}
		else if ( IsAI(attacker) )
		{
			attackertype 			= "_ai";
			aiAttackerCombatMode	= attacker.combatmode;
			attackerID 				= attacker.actor_id;
		}
		else
		{
			attackerType = "_other";
		}
		
		attackerOrigin = attacker.origin;
		attackerignoreme = attacker.ignoreme;
		attackerFovCos = attacker.fovcosine;
		attackerMaxSightDistSqrd = attacker.maxsightdistsqrd;
		
		if ( isDefined(attacker.animname) )
		{
			attackerAnimName = attacker.animname;
		}
		
		if ( isDefined( attacker.laststand) )
		{
			attackerlaststand = attacker.laststand;
		}
	}
	
	if ( isDefined(victim) )
	{
		//Get Victim stats
		if ( isPlayer(victim) )
		{
			victimID = getplayerspawnid( victim );
			victimType = "_player";
			victimName = victim.name;
		}
		else if ( IsAi(victim) )
		{
			victimType 			= "_ai";
			aiVictimCombatMode 	= victim.combatmode;
			victimID 			= victim.actor_id;
		}
		else
		{
			victimType = "_other";
		}
		
		victimOrigin = victim.origin;
		victimignoreme = victim.ignoreme;
		victimFovCos = victim.fovcosine;
		victimMaxSightDistSqrd = victim.maxsightdistsqrd;
		
		if ( isDefined( victim.animname ) )
		{
			victimAnimName = victim.animname;
		}
		
		if ( isDefined( victim.laststand) )
		{
			victimlaststand = victim.laststand;
		}
	}
	
	bbPrint( 		"cpattacks", 
		        	"gametime %d attackerid %d attackertype %s attackername %s attackerweapon %s attackerx %d attackery %d attackerz %d aiattckercombatmode %s attackerignoreme %d attackerignoreall %d attackerfovcos %d attackermaxsightdistsqrd %d attackeranimname %s attackerlaststand %d victimid %d victimtype %s victimname %s victimx %d victimy %d victimz %d aivictimcombatmode %s victimignoreme %d victimignoreall %d victimfovcos %d victimmaxsightdistsqrd %d victimanimname %s victimlaststand %d damage %d damagetype %s damagelocation %s death %d victimdowned %d",
			    	gettime(),					//gametime
		        	attackerID,					//attackerid
			    	attackerType,				//attackertype
			    	attackerName,
			        weapon.name, 				//attackerweapon
			        attackerOrigin,				//attackerx, attackery, attackerz
			        aiAttackerCombatMode,		//aiattckercombatmode
			        attackerignoreme,
					attackerignoreall,	
					attackerFovCos,
					attackerMaxSightDistSqrd,
					attackerAnimName,
					attackerLastStand,						
			        victimID, 					//victimid
			        victimType,					//victimType
			        victimName,
			        victimOrigin, 				//victimx, victimy, victimz
			        aiVictimCombatMode,			//aicombatmode	
			        victimignoreme,
			        victimignoreall,
					victimFovCos,
					victimMaxSightDistSqrd,
					victimAnimName,
					victimlaststand,					
			        damage, 					//damage
			        damageType, 				//damagetype
			        hitLocation, 				//damagelocation
			        victimKilled,				//death
			        victimDowned
		  );
}

function logAISpawn(aiEnt, spawner)
{
	bbPrint( 		"cpaispawn",
	        		"gametime %d actorid %d aitype %s archetype %s airank %s accuracy %d originx %d originy %d originz %d weapon %s team %s alertlevel %s grenadeawareness %d canflank %d engagemaxdist %d engagemaxfalloffdist %d engagemindist %d engageminfalloffdist %d health %d",
	        		gettime(),
	        		aiEnt.actor_id,
	        		aiEnt.aitype,
	        		aiEnt.archetype,
	        		aiEnt.airank,
	        		aiEnt.accuracy,
	        		aiEnt.origin,
	        		aiEnt.primaryweapon.name,
	        		aiEnt.team,
	        		aiEnt.alertlevel,
	        		aiEnt.grenadeawareness,
	        		aiEnt.canflank,
	        		aiEnt.engagemaxdist,
	        		aiEnt.engagemaxfallofdist,
	        		aiEnt.engagemindist,
	        		aiEnt.engageminfalloffdist,
	        		aiEnt.health
	        );
}

function logPlayerMapNotification(notificationType, player)
{
	playerID = -1;
	playerType = "";
	playerPosition = (0, 0, 0);
	playername = "";
	
	if ( IsAI( player ) )
	{
		playerID = player.actor_id;
		playerType = "_ai";
		playerPosition = player.origin;
	}
	else if ( IsPlayer ( player) )
	{
		playerID = GetPlayerSpawnId( player );
		playerType = "_player";
		playerPosition = player.origin;
		playername = player.name;
	}
	
	bbPrint( 	"cpnotifications",
	        	"gametime %d notificationtype %s spawnid %d username %s spawnidtype %s locationx %d locationy %d locationz %d",
	        	GetTime(),
	        	notificationType,
	        	playerID,
	        	playername,
	        	playerType,
	        	playerPosition
	       );
}

function logCybercomEvent(player, event, gadget)
{
	userID = -1;
	userType = "";
	userPosition = (0, 0, 0);
	userName = "";
	
	if ( IsAI( player ) )
	{
		userID = player.actor_id;
		userType = "_ai";
		userPosition = player.origin;
	}
	else if ( IsPlayer ( player) )
	{
		userID = GetPlayerSpawnId( player );
		userType = "_player";
		userPosition = player.origin;
		userName = player.name;
	}
	
	
	bbPrint(	"cpcybercomevents",
	        	"gametime %d userid %d username %s usertype %s eventtype %s gadget %s locationx %d locationy %d locationz %d",
	        	gettime(),
	        	userID,
	        	userName,
	        	userType,
	        	event,
	        	gadget,
	        	userPosition
	        );
}

function logExplosionEvent(destructible_ent, attacker, logExplosionEvent, radius)
{
	attackerID = -1;
	attackerType = "";
	attackerPosition = (0, 0, 0);
	attackerUserName = "";
	
	if ( IsAI( attacker ) )
	{
		attackerID = attacker.actor_id;
		attackerType = "_ai";
		attackerPosition = attacker.origin;
	}
	else if ( IsPlayer ( attacker) )
	{
		attackerID = GetPlayerSpawnId( attacker );
		attackerType = "_player";
		attackerPosition = attacker.origin;
		attackerUserName = attacker.name;
	}
	
	bbPrint(	"cpexplosionevents",
	        	"gametime %d explosiontype %s objectname %s attackerid %d attackerusername %s attackertype %s locationx %d locationy %d locationz %d radius %d attackerx %d attackery %d attackerz %d",
	        	gettime(),
	        	logExplosionEvent,
	        	destructible_ent.classname,
	        	attackerID,
	        	attackerUserName,
	        	attackerType,
	        	destructible_ent.origin, 
	        	radius,
	        	attackerPosition
	        );
}