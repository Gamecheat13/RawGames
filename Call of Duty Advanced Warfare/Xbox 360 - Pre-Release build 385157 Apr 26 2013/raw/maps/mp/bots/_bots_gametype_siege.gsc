#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_strategy;

// This is called directly from native code on game startup after the _bots::main() is executed

//===========================================
// 				AI types
//===========================================
TYPE_GRUNT 			= 0;
TYPE_GUARD			= 1;
TYPE_HUNTER			= 2;
TYPE_BOSS			= 3;


//===========================================
// 				objective types
//===========================================
TYPE_GOAL 			= 0;
TYPE_BOSS_BATTLE	= 1;
TYPE_CUSTOM			= 2;


//=======================================================
//						main
//=======================================================
main()
{
	setup_callbacks();
	level thread start_AI_director();
}


//=======================================================
//					setup_callbacks
//=======================================================
setup_callbacks()
{	
	level.bot_funcs["gametype_think"]		= ::bot_siege_think;
	level.bot_funcs["should_do_killcam"]	= ::bot_siege_should_do_killcam;
	level.bot_funcs["on_killed"]			= ::on_bot_killed;
}


//=======================================================
//					setup_callbacks
//=======================================================
bot_siege_should_do_killcam()
{
	return false;
}


//=======================================================
//					bot_siege_think
//=======================================================
bot_siege_think()
{
	self notify( "bot_siege_think" );
	self endon(  "bot_siege_think" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	self childthread bot_ammo_refill();
	
	switch( self.siege_ai_type )
	{
		case TYPE_GRUNT:
		{
			self childthread update_grunt();
			break;
		}
		case TYPE_GUARD:
		{
			self childthread update_guard();
			break;
		}
		case TYPE_HUNTER:
		{
			self childthread update_hunter();
			break;
		}
		case TYPE_BOSS:
		{
			self childthread update_boss();
			break;
		}
		default:
			break;
	}
}


//=======================================================
//					update_grunt
//=======================================================
update_grunt()
{	
	self thread deathEvent();
	
	// find and attack the nearest player
	while( true )
	{
		closestPlayer = self findClosestPLayer();
		
		// attack the nearest player
		if( isDefined( closestPlayer ) )
		{
			self BotSetAttacker( closestPlayer );
			level waittill_any_timeout( 4.5, "zone_change" );
		}
		else
		{
			level waittill_any_timeout( 3.5, "zone_change" );	
		}
	}
}


//=======================================================
//					deathEvent
//=======================================================
deathEvent()
{
	self endon( "disconnect" );
	
	self waittill( "death" );
	
	deathLocation = self.origin;
	wait( 0.25 );
	self playSound( "detpack_explo_default" );
	playFX( level.spawnFire, deathLocation);
	RadiusDamage( deathLocation, 64, 100, 100, self );
}


//=======================================================
//					findClosestPLayer
//=======================================================
findClosestPLayer()
{
	closestPlayer 	= undefined;
	closestDistance = 100000 * 100000;
			
	// find the nearest player
	foreach( player in level.players )
	{
		if( isAlive( player ) && isOnHumanTeam( player ) )
		{
			distSquared = DistanceSquared( player.origin, self.origin ); 
			
			if ( distSquared < closestDistance )
			{
				closestPlayer = player;
				closestDistance = distSquared;
			}
		}
	}
	
	return closestPlayer;
}


//=======================================================
//					isOnHumanTeam
//=======================================================
isOnHumanTeam( player )
{
	return player.team == "allies";
}


//=======================================================
//					update_guard
//=======================================================
update_guard()
{
	// fixes undefined SRE
	self.cur_defend_stance = "stand";
	self.cur_defend_loc = undefined;
	
	while( true )
	{
		currentZone = level.siege_zones[level.siege_currentZoneIndex];
		
		if( IsDefined(currentZone.guardLocations) && ( currentZone.guardLocations.size > 0 ) )
		{
			if ( !IsDefined( self.cur_defend_loc ) )
				self.cur_defend_loc = currentZone.guardLocations[RandomInt(currentZone.guardLocations.size)];
			
			assert( IsDefined( self.cur_defend_loc ) );
			self bot_capture_point( self.cur_defend_loc.origin, self.cur_defend_loc.radius, undefined, "critical", currentZone.entrancePoints );

			// If the zone changes, re-evaluate the defend location			
			result = level waittill_any_timeout( 10, "zone_change" );
			if ( result != "timeout" )
				self.cur_defend_loc = undefined;
		}
		else
		{
			closestPlayer = self findClosestPLayer();
			
			if( IsDefined(closestPlayer) )
			{
				self bot_capture_point( closestPlayer.origin, 150, undefined, "critical" );
				level waittill_any_timeout( 4.5, "zone_change" );
			}
			else
			{
				level waittill_any_timeout( 2.0, "zone_change" );	
			}
		}
	}
}
	

//=======================================================
//					update_hunter
//=======================================================
update_hunter()
{
	while( true )
	{
		wait( 5 );
	}
}


//=======================================================
//					update_boss
//=======================================================
update_boss()
{
	self thread bossDeathEvent();
	
	while( true )
	{
		wait( 5 );
	}
}


//=======================================================
//					bossDeathNotify
//=======================================================
bossDeathEvent()
{
	self endon( "disconnect" );
	
	self waittill( "death" );
	
	level notify( "boss_killed" );
}


//=======================================================
//					bot_ammo_refill
//=======================================================
bot_ammo_refill()
{
	while( true )
	{
		self giveMaxAmmo( self.primaryWeapon );
		wait( 25 );
	}
}


//=======================================================
//					start_AI_director
//=======================================================
start_AI_director()
{
	//	AI lists
	level.siege_ai 	= [];
	level.siege_ai[TYPE_GRUNT] 	= [];
	level.siege_ai[TYPE_GUARD] 	= [];
	level.siege_ai[TYPE_HUNTER] = [];
	level.siege_ai[TYPE_BOSS] 	= [];
	
	level.botTeam = "axis";
	level waittill( "spawned_player" );
	
	update_AI_director();
}


//=======================================================
//					update_AI_director
//=======================================================
update_AI_director()
{
	level.pauseEnemySpawning = false;
	
	numPlayers 	= get_number_of_players();
	numGrunts 	= 0;
	numGuards 	= 0;
	numHunters 	= 0;
	numBosses	= 0;
	
	switch( numPlayers )
	{
		case 1:
		{
			switch( level.siege_currentObjectiveType )
			{
				case TYPE_BOSS_BATTLE:
				{	
					numGrunts 	= 0;
					numGuards 	= 0;
					numHunters 	= 0;
					numBosses	= 1;
					break;
				}
				default:
				{
					numGrunts 	= 1;
					numGuards 	= 2;
					numHunters 	= 0;
					break;
				}
			}
			break;
		}
		case 2:
		{
			switch( level.siege_currentObjectiveType )
			{
				case TYPE_BOSS_BATTLE:
				{	
					numGrunts 	= 0;
					numGuards 	= 0;
					numHunters 	= 0;
					numBosses	= 1;
					break;
				}
				default:
				{
					numGrunts 	= 2;
					numGuards 	= 3;
					numHunters 	= 0;
					break;
				}
			}
			break;
		}
		case 3:
		{
			switch( level.siege_currentObjectiveType )
			{
				case TYPE_BOSS_BATTLE:
				{	
					numGrunts 	= 0;
					numGuards 	= 0;
					numHunters 	= 0;
					numBosses	= 1;
					break;
				}
				default:
				{
					numGrunts 	= 3;
					numGuards 	= 5;
					numHunters 	= 0;
					break;
				}
			}
			break;
		}
		case 4:
		default:
		{
			switch( level.siege_currentObjectiveType )
			{
				case TYPE_BOSS_BATTLE:
				{	
					numGrunts 	= 0;
					numGuards 	= 0;
					numHunters 	= 0;
					numBosses	= 1;
					break;
				}
				default:
				{
					numGrunts 	= 4;
					numGuards 	= 6;
					numHunters 	= 0;
					break;
				}
			}
			break;
		}
	}
	
	if( level.siege_currentObjectiveType == TYPE_BOSS_BATTLE )
	{
		level.pauseEnemySpawning = true;
	}
	
	foreach( player in level.players )
	{
		if( player.team == "allies" )
		{
			continue;
		}
		
		player.spawnDelay = 0;
	}
	
	synchAI( TYPE_GRUNT, numGrunts );
	synchAI( TYPE_GUARD, numGuards );
	synchAI( TYPE_HUNTER, numHunters );
	synchAI( TYPE_BOSS, numBosses );
}


//=======================================================
//					synchAI
//=======================================================
synchAI( type, totalNumber )
{
	// remove any AI that may have been disconnected
	level.siege_ai[type] = array_removeundefined( level.siege_ai[type] );
	
	currentNumber = level.siege_ai[type].size;
	level.siege_ai_type = type;
	
	// the correct number of bots already exists
	if( currentNumber == totalNumber )
	{
		return;
	}
	
	// we need to add more bots
	if( currentNumber < totalNumber )
	{
		numberToAdd = totalNumber - currentNumber;
		maps\mp\bots\_bots::spawn_bots( numberToAdd, level.botTeam, ::init_bot );
		return;
	}
	
	// we need to remove some bots
	if( currentNumber > totalNumber )
	{
		numberToRemove = currentNumber - totalNumber;
		level thread removeAI( type, numberToRemove );
		return;
	}
}


//=======================================================
//					removeAI
//=======================================================
removeAI( type, numToRemove )
{
	aiToRemove = [];

	for( i = 0; i < numToRemove; i++ )
	{
		aiToRemove[aiToRemove.size] = level.siege_ai[type][i];
	}
	
	foreach( ai in aiToRemove )
	{
		level.siege_ai[type] = array_remove( level.siege_ai[type], ai );
	}
	
	// kick ai
	foreach( ai in aiToRemove )
	{		
		level thread removeOnDeath( ai );
	}
}


//=======================================================
//					removeOnDeath
//=======================================================
removeOnDeath( ai )
{
	if( ai.sessionstate == "playing" )
	{
		ai waittill( "death" );
	}
	
	kick( ai getEntityNumber(), "EXE_PLAYERKICKED_INACTIVE" );
}


//=======================================================
//						init_bot
//=======================================================
init_bot()
{
	// set the bot's AI type
	self.siege_ai_type = level.siege_ai_type;
	self.spawnDelay = 0;
	
	// save the bot in a global array
	currentIndex = level.siege_ai[level.siege_ai_type].size;
	level.siege_ai[level.siege_ai_type][currentIndex] = self;
	
	//Commented out BotSetDifficultySetting because the exe isnt checked in yet and we need to playtest
	//-Jordan
	switch( self.siege_ai_type )
	{
		case TYPE_GRUNT:
		{
			self BotSetDifficulty( "recruit" );
			//self BotSetDifficultySetting( "adsAllowed", 1 );
			//self BotSetDifficultySetting( "allowGrenades", 1 );
			self bot_set_personality( "run_and_gun" );
			break;
		}
		case TYPE_GUARD:
		{
			self BotSetDifficulty( "recruit" );
			//self BotSetDifficultySetting( "adsAllowed", 1 );
			//self BotSetDifficultySetting( "allowGrenades", 1 );
			self bot_set_personality( "camper" );
			break;
		}
		case TYPE_HUNTER:
		{
			self BotSetDifficulty( "recruit" );
			//self BotSetDifficultySetting( "adsAllowed", 1 );
			//self BotSetDifficultySetting( "allowGrenades", 1 );
			self bot_set_personality( "camper" );
			break;
		}
		case TYPE_BOSS:
		{
			self BotSetDifficulty( "recruit" );
			//self BotSetDifficultySetting( "adsAllowed", 1 );
			//self BotSetDifficultySetting( "allowGrenades", 1 );
			self bot_set_personality( "camper" );
			break;
		}
		default:
			break;
	}
	
	self.personalityManuallySet = true;
	self.difficultyManuallySet 	= true;
 }


//=======================================================
//					on_bot_killed
//=======================================================
on_bot_killed( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, killId )
{
	self.wasKilled = true;
	maps\mp\bots\_bots::on_bot_killed();
}


//=======================================================
//					onSpawnAI
//=======================================================
onSpawnAI()
{
	// this function call happens before giveLoadout()
	// great place to change bot settings like loadout or difficulty
	
	self thread scriptedPathingStyle();
}


//=======================================================
//				scriptedPathingStyle
//=======================================================
scriptedPathingStyle()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self BotSetPathingStyle( "scripted" );
	wait( 5.0 );
	self BotSetPathingStyle( undefined );
}


//=======================================================
//				get_number_of_players
//=======================================================
get_number_of_players()
{
	numPlayers = 0;
	
	foreach( player in level.players )
	{
		if ( player.team == "allies" )
		{
			numPlayers++;
		}
	}
	
	return numPlayers;
}