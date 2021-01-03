#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\bb_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace bb;

function autoexec __init__sytem__() {     system::register("bb",&__init__,undefined,undefined);    }

function __init__()
{
	bb::init_shared();
}

function logDamage(attacker, victim, weapon, damage, damageType, hitLocation, victimKilled, victimDowned)
{
	victimID = -1;
	victimType = "";
	victimOrigin = (0, 0, 0);
	victimIgnoreMe = false;
	victimIgnoreAll = false;
	victimFovCos = 0;
	victimMaxSightDistSqrd = 0;
	victimAnimName = "";
	victimName = "";
	
	attackerID = -1;
	attackerType = "";
	attackerOrigin = (0, 0, 0);
	attackerIgnoreMe = false;
	attackerIgnoreAll = false;
	attackerFovCos = 0;
	attackerMaxSightDistSqrd = 0;
	attackerAnimName = "";
	attackerName = "";
	
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
			attackerName = attacker.name;
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
	}
	
	bbPrint( 		"zmattacks", 
		        	"gametime %d roundnumber %d attackerid %d attackername %s attackertype %s attackerweapon %s attackerx %d attackery %d attackerz %d aiattckercombatmode %s attackerignoreme %d attackerignoreall %d attackerfovcos %d attackermaxsightdistsqrd %d attackeranimname %s victimid %d victimname %s victimtype %s victimx %d victimy %d victimz %d aivictimcombatmode %s victimignoreme %d victimignoreall %d victimfovcos %d victimmaxsightdistsqrd %d victimanimname %s damage %d damagetype %s damagelocation %s death %d downed %d",
			    	gettime(),					//gametime
			    	level.round_number,
		        	attackerID,					//attackerid
		        	attackerName,
			    	attackerType,				//attackertype
			        weapon.name, 				//attackerweapon
			        attackerOrigin,				//attackerx, attackery, attackerz
			        aiAttackerCombatMode,		//aiattckercombatmode
			        attackerignoreme,
					attackerignoreall,	
					attackerFovCos,
					attackerMaxSightDistSqrd,
					attackerAnimName,					
			        victimID, 					//victimid
			        victimName,
			        victimType,					//victimType
			        victimOrigin, 				//victimx, victimy, victimz
			        aiVictimCombatMode,			//aicombatmode	
			        victimignoreme,
			        victimignoreall,
					victimFovCos,
					victimMaxSightDistSqrd,
					victimAnimName,					
			        damage, 					//damage
			        damageType, 				//damagetype
			        hitLocation, 				//damagelocation
			        victimKilled,				//death
			        victimDowned
		  );
	
}

function logAISpawn(aiEnt, spawner)
{
	bbPrint( 		"zmaispawn",
	        		"gametime %d actorid %d aitype %s archetype %s airank %s accuracy %d originx %d originy %d originz %d weapon %s melee_weapon %s health %d roundNum %d",
	        		gettime(),
	        		aiEnt.actor_id,
	        		aiEnt.aitype,
	        		aiEnt.archetype,
	        		aiEnt.airank,
	        		aiEnt.accuracy,
	        		aiEnt.origin,
	        		aiEnt.primaryweapon.name,
	        		aiEnt.meleeWeapon.name,
	        		aiEnt.health,
	        		level.round_number
	        );
}

function logPlayerEvent(player, eventName)
{
	currentWeapon = "";
	beastModeActive = 0;
	if (isDefined(player.currentweapon))
	{
		currentWeapon = player.currentweapon.name;
	}
	
	if (isDefined(player.beastmode))
	{
		beastmodeactive = player.beastmode;		
	}
	
	bbPrint	( 	"zmplayerevents",
	        	"gametime %d roundnumber %d eventname %s spawnid %d username %s originx %d originy %d originz %d health %d beastlives %d currentweapon %s kills %d zone_name %s sessionstate %s currentscore %d totalscore %d beastmodeon %d",
	        	gettime(),
	        	level.round_number,
	        	eventName,
	        	getplayerspawnid( player ),
	        	player.name,
	        	player.origin,
	        	player.health,
	        	player.beastlives,
	        	currentWeapon,
	        	player.kills,
	        	player.zone_name,
	        	player.sessionstate,
	        	player.score,
	        	player.score_total,
	        	beastModeActive
	        );
}

function logRoundEvent(eventName)
{
	bbPrint( 		"zmroundevents",
	        		"gametime %d roundnumber %d eventname %s",
	        		gettime(),
	        		level.round_number,
	        		eventName
	        );
	
	foreach (player in level.players)
	{
		bb::logPlayerEvent(player, eventname);
	}
}

function logPurchaseEvent(player, sellerEnt, cost, itemName, itemUpgraded, itemType, eventName)
{
	bbPrint( 		"zmpurchases",
	        		"gametime %d roundnumber %d playerspawnid %d username %s itemname %s isupgraded %d itemtype %s purchasecost %d playeroriginx %d playeroriginy %d playeroriginz %d selleroriginx %d selleroriginy %d selleroriginz %d playerkills %d playerhealth %d playercurrentscore %d playertotalscore %d zone_name %s",
	        		gettime(),
	        		level.round_number,
	        		getplayerspawnid( player ),
	        		player.name,
	        		itemName,
	        		itemUpgraded,
	        		itemType,
	        		cost,
	        		player.origin,
	        		sellerent.origin,
	        		player.kills,
	        		player.health,
	        		player.score,
	        		player.score_total,
	        		player.zone_name
	        );
}

function logPowerupEvent(powerup, optPlayer, eventName)
{
	playerspawnid = -1;
	playername = "";
	if (isDefined(optPlayer) && IsPlayer(optPlayer))
	{
		playerspawnid = GetPlayerSpawnId(optplayer);
		playername = optPlayer.name;
	}
	
	bbPrint( 		"zmpowerups",
	        		"gametime %d roundnumber %d powerupname %s powerupx %d powerupy %d powerupz %d, eventname %s playerspawnid %d playername %s",
	        		gettime(),
	        		level.round_number,
	        		powerup.powerup_name,
	        		powerup.origin,
	        		eventName,
	        		playerspawnid,
	        		playername
	        );
	
	foreach (player in level.players)
	{
		bb::logPlayerEvent(player, "powerup_" + powerup.powerup_name + "_" + eventName);
	}
}

