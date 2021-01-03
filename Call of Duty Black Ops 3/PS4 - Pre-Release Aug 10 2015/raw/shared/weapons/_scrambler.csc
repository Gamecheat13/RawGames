#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "_t6/misc/fx_equip_light_red" );
#precache( "client_fx", "_t6/misc/fx_equip_light_green" );

#namespace scrambler;

function init_shared()
{	
	level._effect["scrambler_enemy_light"] = "_t6/misc/fx_equip_light_red";
	level._effect["scrambler_friendly_light"] = "_t6/misc/fx_equip_light_green";

	level.scramblerHandle = 1;
	level.scramblerVOOuterRadius = 1200 * 1200;
	level.scramblerInnerRadius =  500 *  500;
	level.scramblesound = "mpl_scrambler_static";	
	level.globalscramblesound = "mpl_cuav_static";	
	level.scramblesoundalert = "mpl_scrambler_alert";	
	level.scramblesoundping = "mpl_scrambler_ping";		
	level.scramblesoundburst = "mpl_scrambler_burst";

	clientfield::register( "missile", "scrambler", 1, 1, "int", &spawnedScrambler,!true, !true );
	//TODO T7 - if this is going live again, the below 'counteruav' clientfield needs to get updated to be scrambler specific. In its current state it is shared with the counteruav
	//clientfield::register( "scriptmover", "counteruav", VERSION_SHIP, 1, "int", &spawnedGlobalScramber,!CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	level.scramblers = [];
	level.playerPersistent = [];
	localClientNum = 0;
	util::waitforclient( localClientNum );	
	
	level thread scramblerUpdate( localClientNum );
	level thread checkForPlayerSwitch();
}

function spawnedScrambler(localClientNum, set)
{
	if ( !set )
		return;
	
	if ( localClientNum != 0 )
		return;
	
	self spawned(localClientNum, set, true);	
}

function spawnedGlobalScramber( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !newVal )
		return;
	
	if ( localClientNum != 0 )
		return;
	
	self spawned(localClientNum, newVal, false);
}

function spawned(localClientNum, set, isLocalized)
{	
	if ( !set )
		return;
	
	if ( localClientNum != 0 )
		return;

	scramblerHandle = level.scramblerHandle;
	level.scramblerHandle++;
		
	size = level.scramblers.size;
	level.scramblers[size] = spawnstruct();
	level.scramblers[size].scramblerHandle = scramblerHandle;
	level.scramblers[size].cent =  self;
	level.scramblers[size].team =  self.team;
	level.scramblers[size].isLocalized =  isLocalized;
	level.scramblers[size].sndEnt = spawn( 0, self.origin, "script_origin" );
	level.scramblers[size].sndId = -1;
	level.scramblers[size].sndPingEnt = spawn( 0, self.origin, "script_origin" );
	level.scramblers[size].sndPingId = -1;	  	
		
	players = level.localPlayers;
	owner = self GetOwner( localClientNum );

	util::local_players_entity_thread( self,&spawnedPerClient, isLocalized, scramblerHandle );
	
	level thread cleanUpScramblerOnDelete( self, scramblerHandle, isLocalIzed, localClientNum );
}

function spawnedPerClient(localClientNum, isLocalized, scramblerHandle)
{
	player = GetLocalPlayer( localClientNum );
	isEnemy = self isEnemyScrambler( localClientNum );
	owner = self GetOwner( localClientNum );
	scramblerIndex = undefined;
	
	for ( i = 0; i < level.scramblers.size; i++ ) 
	{		
		if ( level.scramblers[i].scramblerHandle == scramblerHandle )
		{
			scramblerIndex = i;
			break;
		}
	}
	
	if ( !isdefined( scramblerIndex ) )
		return;
		
	if ( !isEnemy )
	{
		if ( isLocalized )
		{
			if ( owner == player && !IsSpectating( localClientNum, false ) )
			{
				player AddFriendlyScrambler( self.origin[0], self.origin[1], scramblerHandle );
			}
		
			//play ally sccramble sounds
			if ( isdefined( level.scramblers[scramblerIndex].sndEnt ) )
			{
				level.scramblers[scramblerIndex].sndId = level.scramblers[scramblerIndex].sndEnt  playloopsound(level.scramblesoundalert);
				playsound (0, level.scramblesoundburst, level.scramblers[scramblerIndex].sndEnt.origin);
			}
			if ( isdefined( level.scramblers[scramblerIndex].sndPingEnt ) )
				level.scramblers[scramblerIndex].sndPingId = level.scramblers[scramblerIndex].sndPingEnt  playloopsound(level.scramblesoundping); 						 			
			//iprintlnbold ("friendly Scrambler sound " + self.origin + level.scramblers[scramblerIndex].sndEnt.origin );		
		}
	}
	else
	{	
		scrambleSound = level.scramblesound;
		if ( isLocalized == false )
		{
			scrambleSound = level.globalscramblesound;
		}

		//play enemy sccramble sounds
		if ( isdefined( level.scramblers[scramblerIndex].sndEnt ) )
			level.scramblers[scramblerIndex].sndId = level.scramblers[scramblerIndex].sndEnt  playloopsound(scrambleSound); 	
	  //iprintlnbold ("enemy Scrambler sound " + self.origin + level.scramblers[scramblerIndex].sndEnt.origin );
	}			
	
	self thread fx::blinky_light( localClientNum, "tag_light", level._effect["scrambler_friendly_light"], level._effect["scrambler_enemy_light"] );
}

function scramblerUpdate( localClientNum )
{
	nearestEnemy = level.scramblerVOOuterRadius;
	nearestFriendly = level.scramblerVOOuterRadius;
			
	for ( ;; )
	{
		// NOTE: this functionality is reliant on the level.localPlayers[] being valid. First check this if anything
		// is reported as not working here.
		players = level.localPlayers;
		for (localClientNum = 0; localClientNum < players.size; localClientNum++)
		{
			player = players[localClientNum];
			
			if (!isdefined ( player.team ))
				continue;	// hopefully it'll show up soon, so just do nothing for now
				
			if (!isdefined ( level.playerPersistent[localClientNum] ) )
			{
				level.playerPersistent[localClientNum] = spawnStruct();
				level.playerPersistent[localClientNum].previousTeam = player.team;
				player removeallFriendlyScramblers();
			}
			
			if ( level.playerPersistent[localClientNum].previousTeam != player.team  )
			{
				teamChanged = true;
				level.playerPersistent[localClientNum].previousTeam = player.team;
			}
			else 
				teamChanged = false;
			
			enemyScramblerAmount = 0.0;
			friendlyScramblerAmount = 0.0;
			nearestEnemy = level.scramblerVOOuterRadius;
			nearestFriendly = level.scramblerVOOuterRadius;
			isGlobalScrambler = 0;
			distToScrambler = level.scramblerVOOuterRadius;
			nearestEnemyScramblerCent = undefined;
			
			for ( i = 0; i < level.scramblers.size; i++ ) 
			{			
				if (!isdefined( level.scramblers[i].cent ) )
					continue;
					
				if ( isdefined( level.scramblers[i].cent.stunned ) && level.scramblers[i].cent.stunned )
				{
					level.scramblers[i].cent.reenable = true;
					player RemoveFriendlyScrambler( level.scramblers[i].scramblerHandle );
					continue;
				}
				else if ( isdefined( level.scramblers[i].cent.reenable ) && level.scramblers[i].cent.reenable )
				{
					teamChanged = true;
					level.scramblers[i].cent.reenable = false;
				}
				
				if ( level.scramblers[i].isLocalized )
				{
					distToScrambler = distanceSquared( player.origin, level.scramblers[i].cent.origin );	
					
				}
				
				if ( !level.scramblers[i].isLocalized && level.scramblers[i].cent isEnemyScrambler( localClientNum ) )
				{
					isGlobalScrambler = 1;
				}
				
				isEnemy = level.scramblers[i].cent isEnemyScrambler( localClientNum );

				if ( level.scramblers[i].team != level.scramblers[i].cent.team )
				{
					scramblerTeamChanged = true;
					level.scramblers[i].team = level.scramblers[i].cent.team;
				}
				else
				{
					scramblerTeamChanged = false;
				}
				
				if ( teamChanged || scramblerTeamChanged )
					level.scramblers[i] restartSound( isEnemy );
				
				if ( isEnemy )
				{
					if ( nearestEnemy > distToScrambler )
					{
						nearestEnemyScramblerCent = level.scramblers[i].cent;
						nearestEnemy = distToScrambler;
					}
						
					if ( ( level.scramblers[i].isLocalized ) && ( teamChanged || scramblerTeamChanged ) )
						player RemoveFriendlyScrambler( level.scramblers[i].scramblerHandle );
				}
				else if ( level.scramblers[i].isLocalized )
				{
					if ( nearestFriendly > distToScrambler )
						nearestFriendly = distToScrambler;

					owner = level.scramblers[i].cent GetOwner( localClientNum );
						
					if ( owner == player && !IsSpectating( localClientNum, false ) )
					{
						if ( teamChanged || scramblerTeamChanged )
						{
							player AddFriendlyScrambler( level.scramblers[i].cent.origin[0], level.scramblers[i].cent.origin[1], level.scramblers[i].scramblerHandle );
						}
					}
				}
			}
			

			if ( nearestEnemy < level.scramblerVOOuterRadius )
				enemyVOScramblerAmount = 1 - ( ( nearestEnemy - level.scramblerInnerRadius ) / ( level.scramblerVOOuterRadius - level.scramblerInnerRadius ) );
			else 
				enemyVOScramblerAmount = 0;
			
			if ( nearestFriendly < level.scramblerInnerRadius ) 
				friendlyScramblerAmount = 1.0;
			else if ( nearestFriendly < level.scramblerVOOuterRadius )
				friendlyScramblerAmount = 1 - ( ( nearestFriendly - level.scramblerInnerRadius ) / ( level.scramblerVOOuterRadius - level.scramblerInnerRadius ) );
			player SetFriendlyScramblerAmount( friendlyScramblerAmount );
			
			if ( level.scramblers.size > 0 && isdefined(nearestEnemyScramblerCent) )
			{
				player SetNearestEnemyScrambler( nearestEnemyScramblerCent );
			}
			else
			{
				player ClearNearestEnemyScrambler();
			}
			
			//player SetEnemyScramblerAmount( enemyScramblerAmount );
			
			if ( isGlobalScrambler && ( player HasPerk( localClientNum, "specialty_immunecounteruav" ) == false ) )
				player SetEnemyGlobalScrambler( 1 );
			else
				player SetEnemyGlobalScrambler( 0 );

			if (enemyVOScramblerAmount > 1)
				enemyVOScramblerAmount = 1;
			
			if ( GetDvarfloat( "snd_futz" ) != enemyVOScramblerAmount )
				SetDvar( "snd_futz", enemyVOScramblerAmount );
		}
		
		wait( 0.25 );
		util::waitforallclients();
	}
}


function cleanUpScramblerOnDelete( scramblerEnt, scramblerHandle, isLocalized, localClientNum )
{
	scramblerEnt waittill( "entityshutdown" );
	players = level.localPlayers;

	for ( j = 0; j < level.scramblers.size; j++ ) 
	{
		size = level.scramblers.size;
		if ( scramblerHandle == level.scramblers[j].scramblerHandle )
		{
			playsound (0, level.scramblesoundburst, level.scramblers[j].sndEnt.origin);
			level.scramblers[j].sndEnt delete();
			level.scramblers[j].sndEnt = self.scramblers[size - 1].sndEnt;
			level.scramblers[j].sndPingEnt delete();
			level.scramblers[j].sndPingEnt = self.scramblers[size - 1].sndPingEnt;						
			level.scramblers[j].cent = level.scramblers[size - 1].cent;
			level.scramblers[j].scramblerHandle = level.scramblers[size - 1].scramblerHandle;
			level.scramblers[j].team = level.scramblers[size - 1].team;
			level.scramblers[j].isLocalized = level.scramblers[size - 1].isLocalized;
			level.scramblers[size - 1] = undefined;
			break;
		}
	}	
	
	if ( isLocalized )
	{
		for ( i = 0; i < players.size; i++ )
		{
			players[i] RemoveFriendlyScrambler( scramblerHandle );
		}
	}
}



function isEnemyScrambler( localClientNum )
{
	/#
	if ( GetDvarInt( "scr_forceEnemyScrambler", 0 ) ) 
		return true;
	#/
	enemy = !util::friend_not_foe(localClientNum);
	return enemy;
}

function checkForPlayerSwitch()
{
	while ( true )
	{
		level waittill( "player_switch" );
		waittillframeend;
		
		players = level.localPlayers;
		for (localClientNum = 0; localClientNum < players.size; localClientNum++)
		{
			for ( j = 0; j < level.scramblers.size; j++ )
			{
				ent = level.scramblers[j].cent;
				
				ent thread fx::stop_blinky_light( localClientNum );
	
				ent thread fx::blinky_light( localClientNum, "tag_light", level._effect["scrambler_friendly_light"], level._effect["scrambler_enemy_light"] );

				isEnemy = ent isEnemyScrambler( localClientNum );
				
				level.scramblers[j] restartSound( isEnemy );
			}

		}
	}
}

function restartSound( isEnemy )
{
	if ( self.sndId != -1 )
	{
		self.sndEnt StopAllLoopSounds( 0.1 );
		self.sndId = -1;
	}
				
	if ( !isEnemy )
	{
		if ( self.isLocalized )
		{
			self.sndId = self.sndEnt playloopsound( level.scramblesoundalert );
		}
	}
	else
	{
		isLocalized = self.isLocalized;
		scrambleSound = level.scramblesound;
		if ( isLocalized == false )
		{
			scrambleSound = level.globalscramblesound;
		}

		self.sndId = self.sndEnt playloopsound( scrambleSound );
	}
}