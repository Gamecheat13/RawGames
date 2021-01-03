#using scripts\codescripts\struct;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\callbacks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                     	   	                                                                      	  	  	

#namespace challenges;

function init_shared()
{	
}

function pickedUpBallisticKnife()
{
	self.retreivedBlades++;
}

// used to be in _helicopter.gsc
function trackAssists( attacker, damage, isFlare )
{
	if ( !isdefined( self.flareAttackerDamage ) )
	{
		self.flareAttackerDamage = [];
	}

	if ( isdefined ( isFlare ) && isFlare == true ) 
	{
		self.flareAttackerDamage[attacker.clientid] = true;
	}
	else
	{
		self.flareAttackerDamage[attacker.clientid] = false;
	}
}

function destroyedEquipment( weapon )
{
	if ( IsDefined( weapon ) && weapon.isEmp )
	{
		self AddPlayerStat( "destroy_equipment_with_emp_grenade", 1 );
		self AddWeaponStat( weapon, "combatRecordStat", 1 );
	}
	self AddPlayerStat( "destroy_equipment", 1 );

	self challenges::hackedOrDestroyedEquipment();
}

function destroyedTacticalInsert()
{
	if ( !isdefined( self.pers["tacticalInsertsDestroyed"] ) )
	{
		self.pers["tacticalInsertsDestroyed"] = 0;
	}
	self.pers["tacticalInsertsDestroyed"]++;
	if ( self.pers["tacticalInsertsDestroyed"] >= 5 ) 
	{
		self.pers["tacticalInsertsDestroyed"] = 0;
		self AddPlayerStat( "destroy_5_tactical_inserts", 1 );
	}
}

function addFlySwatterStat( weapon, aircraft )
{
		if ( !isdefined( self.pers[ "flyswattercount" ] ) )
		{
			self.pers[ "flyswattercount" ] = 0;
		}
		
		self AddWeaponStat( weapon, "destroyed_aircraft", 1 );
		
		self.pers[ "flyswattercount" ]++;
		
		if ( self.pers[ "flyswattercount" ] == 5 )
		{
			self AddWeaponStat( weapon, "destroyed_5_aircraft", 1 );
		}
		
		if ( isdefined( aircraft ) && isdefined( aircraft.birthTime ) )
		{
			if ( ( GetTime() - aircraft.birthTime ) < 20000 )
			{
				self AddWeaponStat( weapon, "destroyed_aircraft_under20s", 1 );
			}
		}

		if ( !isdefined( self.destroyedAircraftTime ) )
		{
			self.destroyedAircraftTime = [];
		}
		
		if ( ( isdefined( self.destroyedAircraftTime[ weapon ] ) ) && ( ( GetTime() - self.destroyedAircraftTime[ weapon ] ) < 10000 ) )
		{
			self AddWeaponStat( weapon, "destroyed_2aircraft_quickly", 1 );
			self.destroyedAircraftTime[ weapon ] = undefined;
		}
		else
		{
			self.destroyedAircraftTime[ weapon ] = GetTime();
		}
}

function canProcessChallenges()
{
/#	
	if ( GetDvarInt( "scr_debug_challenges", 0 ) ) 
		return true;
#/

	if ( level.rankedMatch || level.wagerMatch  )
	{
		return true;
	}
	
	return false;
}


function initTeamChallenges( team )
{
	if ( !isdefined( game["challenge"] ) ) 
	{
		game["challenge"] = [];
	}
	
	if ( !isdefined ( game["challenge"][team] ) )
	{
		game["challenge"][team] = [];
		game["challenge"][team]["plantedBomb"] = false;
		game["challenge"][team]["destroyedBombSite"] = false;
		game["challenge"][team]["capturedFlag"] = false;
	}
	game["challenge"][team]["allAlive"] = true;
}

function registerChallengesCallback(callback, func)
{
	if (!isdefined(level.ChallengesCallbacks[callback]))
		level.ChallengesCallbacks[callback] = [];
	level.ChallengesCallbacks[callback][level.ChallengesCallbacks[callback].size] = func;
}

function doChallengeCallback( callback, data )
{
	if ( !isdefined( level.ChallengesCallbacks ) )
		return;		
			
	if ( !isdefined( level.ChallengesCallbacks[callback] ) )
		return;
	
	if ( isdefined( data ) ) 
	{
		for ( i = 0; i < level.ChallengesCallbacks[callback].size; i++ )
			thread [[level.ChallengesCallbacks[callback][i]]]( data );
	}
	else 
	{
		for ( i = 0; i < level.ChallengesCallbacks[callback].size; i++ )
			thread [[level.ChallengesCallbacks[callback][i]]]();
	}
}

function on_player_connect()
{
	self thread initChallengeData();
	self thread spawnWatcher();
	self thread monitorReloads();
}

function monitorReloads()
{
	self endon("disconnect");
	self endon("killMonitorReloads");
	
	while(1)
	{
		self waittill("reload");
		currentWeapon = self getCurrentWeapon();
		if ( currentWeapon == level.weaponNone ) 
		{
			continue;
		}
		
		time = getTime();
		self.lastReloadTime = time;
		
		if ( WeaponHasAttachment( currentWeapon, "supply", "dualclip" ) )
		{
			self thread reloadThenKill( currentWeapon );
		}
	}
}

function reloadThenKill( reloadWeapon )
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "reloadThenKillTimedOut" );
	self notify( "reloadThenKillStart" ); // kill dupliate self and duplicate timeout
	self endon( "reloadThenKillStart" ); // Singleton

	self thread reloadThenKillTimeOut( 5 );	

	for( ;; )
	{
		self waittill ("killed_enemy_player", time, weapon );
		if ( reloadWeapon == weapon )
		{
			self AddPlayerStat( "reload_then_kill_dualclip", 1 );
		}
	}
}

	
function reloadThenKillTimeOut( time )
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "reloadThenKillStart" );
	wait( time );
	self notify( "reloadThenKillTimedOut" );
}

function initChallengeData()
{	
	self.pers["bulletStreak"] = 0;
	self.pers["lastBulletKillTime"] = 0;
	self.pers["stickExplosiveKill"] = 0;
	self.pers["carepackagesCalled"] = 0;
	self.explosiveInfo = [];
}


function isDamageFromPlayerControlledAITank( eAttacker, eInflictor, weapon )
{
	if ( weapon.name == "ai_tank_drone_gun" ) 
	{
		if ( isdefined( eAttacker ) && isdefined( eAttacker.remoteWeapon ) && isdefined( eInflictor ) )
		{
			if ( ( isdefined( eInflictor.controlled ) && eInflictor.controlled ) )
			{
				if ( eAttacker.remoteWeapon	== eInflictor )
				{
					return true;
				}
			}
		}
	}
	else if ( weapon.name == "ai_tank_drone_rocket" )
	{
		if ( isdefined( eInflictor ) && !isdefined( eInflictor.from_ai ) )
		{
			return true;
		}
	}
	return false;
}

function isDamageFromPlayerControlledSentry( eAttacker, eInflictor, weapon )
{
	if ( weapon.name == "auto_gun_turret" )
	{
		if ( isdefined( eAttacker ) && isdefined( eAttacker.remoteWeapon ) && isdefined( eInflictor ) )
		{
			if ( eAttacker.remoteWeapon	== eInflictor )
			{
				if ( ( isdefined( eInflictor.controlled ) && eInflictor.controlled ) )
				{
					return true;
				}
			}
		}
	}
	return false;
}

function perkKills( victim, isStunned, time )
{
	player = self;
	if ( player hasPerk( "specialty_movefaster" ) )
	{
		player AddPlayerStat( "perk_movefaster_kills", 1 );
	}
	if ( player hasPerk( "specialty_noname" ) )
	{
		player AddPlayerStat( "perk_noname_kills", 1 );
	}
	if ( player hasPerk( "specialty_quieter" ) )
	{
		player AddPlayerStat( "perk_quieter_kills", 1 );
	}
	if ( player hasPerk( "specialty_longersprint" ) )
	{
		if ( isdefined ( player.lastSprintTime ) && ( GetTime() - player.lastSprintTime ) < 2500 )
		{
			player AddPlayerStat( "perk_longersprint", 1 );
		}
	}
	if ( player hasPerk( "specialty_fastmantle" ) )
	{
		if ( ( isdefined ( player.lastSprintTime ) && ( GetTime() - player.lastSprintTime ) < 2500 ) && ( player PlayerAds() >= 1 ) )
		{
			player AddPlayerStat( "perk_fastmantle_kills", 1 );
		}
	}
	if ( player hasPerk( "specialty_loudenemies" ) )
	{
		player AddPlayerStat( "perk_loudenemies_kills", 1 );
	}

	if ( isStunned == true && player hasPerk( "specialty_stunprotection" ) )
	{
		player AddPlayerStat( "perk_protection_stun_kills", 1 );
	}
	
	activeEnemyEmp = false;
	activeCUAV = false ;
	if ( level.teambased ) 
	{
		foreach( team in level.teams )
		{
			assert( isdefined( level.activeCounterUAVs[ team ] ) );
			assert( isdefined( level.ActiveEMPs[ team ] ) );

			if ( team == player.team )
			{
				continue;
			}
			
			if ( level.activeCounterUAVs[team] > 0 )
			{
				activeCUAV = true;
			}
			
			if( level.ActiveEMPs[ team ] > 0 )
			{
				activeEnemyEmp = true;
			}
		}
	}
	else
	{
		assert( isdefined( level.activeCounterUAVs[ victim.entNum ] ) );
		assert( isdefined( level.ActiveEMPs[ victim.entNum ] ) );
	
		players = level.players;
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[i] != player ) 
			{	
				if ( isdefined( level.activeCounterUAVs[players[i].entNum] ) && level.activeCounterUAVs[players[i].entNum] > 0 )
				{
					activeCUAV = true;
				}
				
				if( isdefined( level.ActiveEMPs[ players[ i ].entNum ] ) && level.ActiveEMPs[ players[ i ].entNum ] > 0 )
				{
					activeEnemyEmp = true;
				}
			}
		}	
	}

	if ( activeCUAV == true || activeEnemyEmp == true )
	{
		if ( player hasPerk( "specialty_immunecounteruav" ) )
		{
			player AddPlayerStat( "perk_immune_cuav_kills", 1 );
		}
	}

	activeUAVVictim = false;
	if ( level.teambased ) 
	{
		if ( level.activeUAVs[victim.team] > 0 )
		{
			activeUAVVictim = true;
		}
	}
	else
	{
		activeUAVVictim = ( isdefined( level.activeUAVs[victim.entNum] ) && level.activeUAVs[victim.entNum] > 0 );
	}


	if ( activeUAVVictim == true )
	{
		if ( player hasPerk( "specialty_gpsjammer" ) )
		{
			player AddPlayerStat( "perk_gpsjammer_immune_kills", 1 );
		}
	}

	if ( player.lastWeaponChange + 5000 > time ) 
	{
		if ( player hasPerk( "specialty_fastweaponswitch" ) )
		{
			player AddPlayerStat( "perk_fastweaponswitch_kill_after_swap", 1 );
		}
	}
	
	if ( player.scavenged == true ) 
	{
		if ( player hasPerk( "specialty_scavenger" ) )
		{
			player AddPlayerStat( "perk_scavenger_kills_after_resupply", 1 );
		}
	}
}

function flakjacketProtected( weapon, attacker )
{
	if ( weapon.name == "claymore" )
	{
		self.flakJacketClaymore[ attacker.clientid ] = true;
	}
	self AddPlayerStat( "perk_flak_survive", 1 );
}

function earnedKillstreak()
{
	if ( self hasPerk( "specialty_earnmoremomentum" ) )
	{
		self AddPlayerStat( "perk_earnmoremomentum_earn_streak", 1 );
	}
}

function genericBulletKill( data, victim, weapon ) 
{
	player = self;
	time = data.time;
	
	if ( player.pers["lastBulletKillTime"] == time )
		player.pers["bulletStreak"]++;
	else
		player.pers["bulletStreak"] = 1;
	
	player.pers["lastBulletKillTime"] = time;

	if ( data.victim.iDFlagsTime == time )
	{
		if ( data.victim.iDFlags & 8 )
		{
			player AddPlayerStat( "kill_enemy_through_wall", 1 );
			if ( isdefined( weapon ) && weaponHasAttachment( weapon, "damage", "fmj" ) )
			{
				player AddPlayerStat( "kill_enemy_through_wall_with_fmj", 1 );		
			}
		}
	}
	
}


function isHighestScoringPlayer( player )
{
	if ( !isdefined( player.score ) || player.score < 1 )
		return false;

	players = level.players;
	if ( level.teamBased )
		team = player.pers["team"];
	else
		team = "all";

	highScore = player.score;

	for( i = 0; i < players.size; i++ )
	{
		if ( !isdefined( players[i].score ) )
			continue;
			
		if ( players[i] == player )
			continue;

		if ( players[i].score < 1 )
			continue;

		if ( team != "all" && players[i].pers["team"] != team )
			continue;
		// tied for first is no longer counted
		if ( players[i].score >= highScore )
			return false;
	}
	
	return true;
}

function spawnWatcher()
{
	self endon("disconnect");
	self endon("killSpawnMonitor");
	self.pers["stickExplosiveKill"] = 0;
	self.pers["pistolHeadshot"] = 0;
	self.pers["assaultRifleHeadshot"] = 0;
	self.pers["killNemesis"] = 0;
	while(1)
	{
		self waittill("spawned_player");
		self.pers["longshotsPerLife"] = 0;
		self.flakJacketClaymore = [];
		self.weaponKills = [];
		self.attachmentKills = [];
		self.retreivedBlades = 0;
		self.lastReloadTime = 0;
		self.crossbowClipKillCount = 0;
		self thread watchForDTP();
		self thread watchForMantle();
		self thread monitor_player_sprint();
	}
}

function watchForDTP()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ("killDTPMonitor");
	
	self.dtpTime = 0;
	while(1)
	{
		self waittill( "dtp_end" );
		self.dtpTime = getTime() + 4000;
	}
}


function watchForMantle()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ("killMantleMonitor");

	self.mantleTime = 0;
	while(1)
	{
		self waittill( "mantle_start", mantleEndTime );
		self.mantleTime = mantleEndTime;
	}
}

function disarmedHackedCarepackage()
{
	self AddPlayerStat( "disarm_hacked_carepackage", 1 );	
}

function destroyed_car()
{
	if ( !isdefined( self ) || !isplayer( self ) )
		return;

	self AddPlayerStat( "destroy_car", 1 );	
}


function killedNemesis()
{
	self.pers["killNemesis"]++;
	if ( self.pers["killNemesis"] >= 5 )
	{
		self.pers["killNemesis"] = 0;
		self AddPlayerStat( "kill_nemesis", 1 );	
	}
}

function killWhileDamagingWithHPM()
{
	self AddPlayerStat( "kill_while_damaging_with_microwave_turret", 1 );	
}

function longDistanceHatchetKill()
{
	self AddPlayerStat( "long_distance_hatchet_kill", 1 );	
}

function blockedSatellite()
{
	self AddPlayerStat( "activate_cuav_while_enemy_satelite_active", 1 );	
}

function longDistanceKill()
{
	self.pers["longshotsPerLife"]++;
	if ( self.pers["longshotsPerLife"] >= 3 )
	{
		self.pers["longshotsPerLife"] = 0;
		self AddPlayerStat( "longshot_3_onelife", 1 );	
	}
}


function challengeRoundEnd( data )
{
	player = data.player;
	winner = data.winner;
	
	if ( endedEarly( winner ) )
		return;
	
	if ( level.teambased )
	{
		winnerScore = game["teamScores"][winner];
		loserScore = getLosersTeamScores( winner );
	}
	
	switch ( level.gameType )
	{

		case "sd":
			{
				if ( player.team == winner )
				{					
					if ( game["challenge"][winner]["allAlive"] ) 
					{
						player AddGameTypeStat( "round_win_no_deaths", 1 );	
					}	
					if ( isdefined ( player.lastManSDDefeat3Enemies ) ) 
					{
						player AddGameTypeStat( "last_man_defeat_3_enemies", 1 );
					}
				}
			}
			break;
		default:
			break;
	}
}


function roundEnd( winner )
{
	{wait(.05);};
	data = spawnstruct();
	data.time = getTime();
	if ( level.teamBased )
	{
		if ( isdefined( winner ) && isdefined( level.teams[winner] ) ) 
		{
			data.winner = winner;
		}
	}
	else
	{
		if ( isdefined( winner ) ) 
		{
			data.winner = winner;
		}
	}
	
	
	for ( index = 0; index < level.placement["all"].size; index++ )
	{
		data.player = level.placement["all"][index];
		if ( isdefined( data.player ) )
		{
			data.place = index;
			doChallengeCallback( "roundEnd", data );
		}
	}		
}

function gameEnd( winner )
{
	{wait(.05);};
	data = spawnstruct();
	data.time = getTime();
	if ( level.teamBased )
	{
		if ( isdefined( winner ) && isdefined( level.teams[winner] ) ) 
		{ 
			data.winner = winner;
		}
	}
	else
	{
		if ( isdefined( winner ) && isplayer( winner) ) 
		{
			data.winner = winner;
		}
	}
	
	
	for ( index = 0; index < level.placement["all"].size; index++ )
	{
		data.player = level.placement["all"][index];
		data.place = index;

		if ( isdefined( data.player ) )
		{
			doChallengeCallback( "gameEnd", data );
		}
		data.player.completedGame = true;
	}
	
	for( index = 0; index < level.players.size; index++ )
	{
		if ( !isdefined( level.players[index].completedGame ) || level.players[index].completedGame != true )
		{
			scoreevents::processScoreEvent( "completed_match", level.players[index] );
		}
	}
}

function getFinalKill( player )
{
	// if the crates in dockside get the final killcam. 
	if ( isplayer ( player ) ) 
	{
		player AddPlayerStat( "get_final_kill", 1 );
	}
}

function destroyRCBomb( weapon )
{
	self destroyScoreStreak( weapon );
	if ( weapon.name == "hatchet" )
	{
		self AddPlayerStat( "destroy_rcbomb_with_hatchet", 1 );
	}
}

function capturedCrate()
{
	if ( isdefined ( self.lastRescuedBy ) && isdefined ( self.lastRescuedTime ) ) 
	{
		if ( self.lastRescuedTime + 5000 > getTime() )
		{
			self.lastRescuedBy AddPlayerStat( "defend_teammate_who_captured_package", 1 );
		}
	}
}


function destroyScoreStreak( weapon )
{
	if ( weapon.name == "qrdrone_turret" )
	{
		self AddPlayerStat( "destroy_score_streak_with_qrdrone", 1 );	
	}

}

function capturedObjective( captureTime )
{
	if ( isdefined( self.smokeGrenadeTime ) && isdefined( self.smokeGrenadePosition ) )
	{
		if ( self.smokeGrenadeTime + 14000 >  captureTime ) 
		{
			distSq = distanceSquared( self.smokeGrenadePosition, self.origin );

			if ( distSq < 57600 ) // 20 feet
			{
				self AddPlayerStat( "capture_objective_in_smoke", 1 );
				self AddWeaponStat( GetWeapon( "willy_pete" ), "CombatRecordStat", 1 );
				break;
			}
		}
	}

	if ( isdefined( self.heroAbilityActive ) 
			|| ( isdefined( self.heroAbilityDectivateTime ) && self.heroAbilityDectivateTime > gettime() - 3000 ) )
	{
		self scoreevents::processscoreevent( "optic_camo_capture_objective", 1 );
	}
}

function hackedOrDestroyedEquipment()
{
	if ( self hasPerk( "specialty_showenemyequipment" ) )
	{
		self AddPlayerStat( "perk_hacker_destroy", 1 );
	}
}

function bladeKill()
{
	if ( !isdefined( self.pers["bladeKills"] ) )
	{
		self.pers["bladeKills"] = 0;
	}
	self.pers["bladeKills"]++;
	if ( self.pers["bladeKills"] >= 15 ) 
	{
		self.pers["bladeKills"] = 0;
		self AddPlayerStat( "kill_15_with_blade", 1 );
	}
}
		
function destroyedExplosive( weapon )
{
	self destroyedEquipment( weapon );
	self AddPlayerStat( "destroy_explosive", 1 );
}

function assisted()
{
	self AddPlayerStat( "assist", 1 );
}

function earnedMicrowaveAssistScore( score )
{
	self AddPlayerStat( "assist_score_microwave_turret", score );
	self AddPlayerStat( "assist_score_killstreak", score );
}

function earnedCUAVAssistScore( score )
{
	self AddPlayerStat( "assist_score_cuav", score );
	self AddPlayerStat( "assist_score_killstreak", score );
	self AddWeaponStat( GetWeapon( "counteruav" ), "assists", 1 );
}

function earnedUAVAssistScore( score )
{
	self AddPlayerStat( "assist_score_uav", score );
	self AddPlayerStat( "assist_score_killstreak", score );
	self AddWeaponStat( GetWeapon( "radar" ), "assists", 1 );
}

function earnedSatelliteAssistScore( score )
{
	self AddPlayerStat( "assist_score_satellite", score );
	self AddPlayerStat( "assist_score_killstreak", score );
	self AddWeaponStat( GetWeapon( "radardirection" ), "assists", 1 );
}

function earnedEMPAssistScore( score )
{
	self AddPlayerStat( "assist_score_emp", score );
	self AddPlayerStat( "assist_score_killstreak", score );
	self AddWeaponStat( GetWeapon( "emp" ), "assists", 1 );
}



function teamCompletedChallenge( team, challenge ) 
{	
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if (isdefined( players[i].team ) && players[i].team == team )
		{		
			players[i] AddGameTypeStat( challenge, 1 );
		}
	}	
}

function endedEarly( winner )
{
	if ( level.hostForcedEnd )
		return true;
	
	if ( !isdefined( winner ) ) 
		return true;

	if ( level.teambased ) 
	{	
		if ( winner == "tie" )
			return true;
	}

	return false;
}

function getLosersTeamScores( winner )
{
	teamScores = 0;
	
	foreach ( team in level.teams )
	{
		if ( team == winner )
			continue;
			
		teamScores += game["teamScores"][team];
	}
	
	return teamScores;
}

function didLoserFailChallenge( winner, challenge )
{
	foreach ( team in level.teams )
	{
		if ( team == winner )
			continue;

		if ( game["challenge"][team][challenge] )
			return false;
	}
	
	return true;
}

function challengeGameEnd( data )
{
	player = data.player;
	winner = data.winner;
	
	if ( endedEarly( winner ) )
		return;

	if ( level.teambased )
	{
		winnerScore = game["teamScores"][winner];
		loserScore = getLosersTeamScores( winner );
	}
	
	switch ( level.gameType )
	{
		case "tdm":
			{
				if ( player.team == winner )
				{
					if ( winnerScore >= loserScore + 20 )
					{
						player AddGameTypeStat( "CRUSH", 1 );	
					}
				}

				mostKillsLeastDeaths = true;
								
				for ( index = 0; index < level.placement["all"].size; index++ )
				{
					if ( level.placement["all"][index].deaths < player.deaths )
					{
						mostKillsLeastDeaths = false;
					}
					if ( level.placement["all"][index].kills > player.kills )
					{
						mostKillsLeastDeaths = false;
					}
				}
				
				if ( mostKillsLeastDeaths && player.kills > 0 && level.placement["all"].size > 3 )
				{
					player AddGameTypeStat( "most_kills_least_deaths", 1 );	
				}
			}
			break;
		case "dm":
			{
				if ( player == winner )
				{
					if ( level.placement["all"].size >= 2 )
					{
						secondPlace = level.placement["all"][1];
						if ( player.kills >= ( secondPlace.kills + 7 ) )
						{
							player AddGameTypeStat( "CRUSH", 1 );	
						}
					}	
				}
			}
			break;
		case "ctf":
			{
				if ( player.team == winner )
				{
					if ( loserScore == 0 )
					{	
						player AddGameTypeStat( "SHUT_OUT", 1 );
					}	
				}
			}
			break;
		case "dom":
			{
				if ( player.team == winner )
				{
					if ( winnerScore >= loserScore + 70 )
					{
						player AddGameTypeStat( "CRUSH", 1 );	
					}
				}	
			}
			break;
		case "hq":
			{
				if ( player.team == winner && winnerScore > 0 )
				{
					if ( winnerScore >= loserScore + 70 )
					{
						player AddGameTypeStat( "CRUSH", 1 );	
					}
				}
			}
			break;
		case "koth":
			{
				if ( player.team == winner && winnerScore > 0 )
				{
					if ( winnerScore >= loserScore + 70 )
					{
						player AddGameTypeStat( "CRUSH", 1 );	
					}
				}
				if ( player.team == winner && winnerScore > 0 )
				{
					if ( winnerScore >= loserScore + 110 )
					{
						player AddGameTypeStat( "ANNIHILATION", 1 );	
					}
				}
			}
			break;
		case "dem":
			{
				if ( player.team == game["defenders"] && player.team == winner )
				{
					if ( loserScore == 0 )
					{	
						player AddGameTypeStat( "SHUT_OUT", 1 );
					}	
				}
			}
			break;
		case "sd":
			{
				if ( player.team == winner )
				{
					if ( loserScore <= 1 )
					{
						player AddGameTypeStat( "CRUSH", 1 );	
					}
				}
			}
		default:
			break;
	}
}

function multiKill( killCount, weapon )
{
	if ( killCount >= 3 && isdefined( self.lastKillWhenInjured ) )
	{
		if ( self.lastKillWhenInjured + 5000 > getTime() )
		{
			self AddPlayerStat( "multikill_3_near_death", 1 );
		}
	}

	self AddWeaponStat( weapon, "doublekill", int( killCount / 2 ) );
	self AddWeaponStat( weapon, "triplekill", int( killCount / 3 ) );
}

function domAttackerMultiKill( killCount )
{
	self AddGameTypeStat( "kill_2_enemies_capturing_your_objective", 1 );
}
	

function totalDomination( team ) 
{
	teamCompletedChallenge( team, "control_3_points_3_minutes" );
}

function holdFlagEntireMatch( team, label )
{
	switch( label )
	{
		case "_a":
			event = "hold_a_entire_match";
			break;
		case "_b":
			event = "hold_b_entire_match";
			break;
		case "_c":
			event = "hold_c_entire_match";
			break;
		default:
			return;
	}
			
	teamCompletedChallenge( team, event );
}

function capturedBFirstMinute()
{
	self AddGameTypeStat( "capture_b_first_minute", 1 );
}

function controlZoneEntirely( team )
{
	teamCompletedChallenge( team, "control_zone_entirely" ) ;
}

function multi_LMG_SMG_Kill()
{
	self AddPlayerStat( "multikill_3_lmg_or_smg_hip_fire", 1 );
}

function killedZoneAttacker( weapon )
{
	if ( weapon.name == "planemortar" || weapon.name ==  "remote_missile_missile" ||  weapon.name == "remote_missile_bomblet" )
	{
		self thread updatezonemultikills();
	}
}

function killedDog()
{
	origin = self.origin;
	if ( level.teambased )
	{
		teammates = util::get_team_alive_players_s( self.team );
		foreach( player in teammates.a )
		{
			if ( player == self )
				continue;
			distSq = distanceSquared( origin, player.origin );

			if ( distSq < 57600 ) // 20 feet
			{
				self AddPlayerStat( "killed_dog_close_to_teammate", 1 );
				break;
			}
		}
	}
}

function updatezonemultikills()
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self notify ( "updateRecentZoneKills" );
	self endon ( "updateRecentZoneKills" );
	if ( !isdefined (self.recentZoneKillCount) )
		self.recentZoneKillCount = 0;
	self.recentZoneKillCount++;

	wait ( 4.0 );

	if ( self.recentZoneKillCount > 1 )
	{
		self AddPlayerStat( "multikill_2_zone_attackers", 1 );
	}

	self.recentZoneKillCount = 0;
}

function multi_RCBomb_Kill()
{
	self AddPlayerStat( "muiltikill_2_with_rcbomb", 1 );
}

function multi_RemoteMissile_Kill()
{
	self AddPlayerStat( "multikill_3_remote_missile", 1 );
}


function multi_MGL_Kill()
{
	self AddPlayerStat( "multikill_3_with_mgl", 1 );
}


function immediateCapture()
{
	self AddGameTypeStat( "immediate_capture", 1 );	
}


function killedLastContester()
{
	self AddGameTypeStat( "contest_then_capture", 1 );	
}


function bothBombsDetonateWithinTime()
{
	self AddGameTypeStat( "both_bombs_detonate_10_seconds", 1 );	
}

function destroyedTurret( weapon )
{
	self destroyScoreStreak( weapon );
	self AddPlayerStat( "destroy_turret", 1 );
}

function calledInCarePackage()
{
	self.pers["carepackagesCalled"]++;
	
	if ( self.pers["carepackagesCalled"] >= 3 )
	{
		self AddPlayerStat( "call_in_3_care_packages", 1 );
		self.pers["carepackagesCalled"] = 0;
	}
}

function destroyedHelicopter( attacker, weapon, damageType, playerControlled )
{
	attacker destroyScoreStreak( weapon );
	if ( damageType == "MOD_RIFLE_BULLET" ||  damageType =="MOD_PISTOL_BULLET" )
	{
		attacker AddPlayerStat( "destroyed_helicopter_with_bullet", 1 );
	}
}


function destroyedQRDrone( damageType, weapon )
{
	self destroyScoreStreak( weapon );

	self AddPlayerStat( "destroy_qrdrone", 1 );

	if ( damageType == "MOD_RIFLE_BULLET" ||  damageType =="MOD_PISTOL_BULLET" )
	{
		self AddPlayerStat( "destroyed_qrdrone_with_bullet", 1 );
	}
	
	self destroyedPlayerControlledAircraft();
}

// chopper hunter challenge renamed aircraft hunter
function destroyedPlayerControlledAircraft()
{
	if ( self hasPerk( "specialty_noname" ) )
	{
		self AddPlayerStat( "destroy_helicopter", 1 );
	}
}

function destroyedAircraft( attacker, weapon )
{
	attacker destroyScoreStreak( weapon );
	
	if ( isdefined( weapon ) )
	{
		if ( weapon.isEmp )
		{
			attacker AddPlayerStat( "destroy_aircraft_with_emp", 1 );
		}
		else if ( weapon.name == "missile_drone_projectile" || weapon.name == "missile_drone" )
		{
			attacker AddPlayerStat( "destroy_aircraft_with_missile_drone", 1 );
		}
	}

	if ( attacker hasPerk( "specialty_nottargetedbyairsupport" ) )
	{
		attacker AddPlayerStat( "perk_nottargetedbyairsupport_destroy_aircraft", 1 );
	}

	attacker AddPlayerStat( "destroy_aircraft", 1 );
}

function killstreakTen()
{
	if ( !IsDefined( self.class_num ) )
	{
		return;
	}
	
	primary = self GetLoadoutItem( self.class_num, "primary" );
	if ( primary != 0 )
	{
		return;
	}
	secondary = self GetLoadoutItem( self.class_num, "secondary" );
	if ( secondary != 0 )
	{
		return;
	}
	primarygrenade = self GetLoadoutItem( self.class_num, "primarygrenade" );
	if ( primarygrenade != 0 )
	{
		return;
	}
	specialgrenade = self GetLoadoutItem( self.class_num, "specialgrenade" );
	if ( specialgrenade != 0 )
	{
		return;
	}

	for ( numSpecialties = 0; numSpecialties < level.maxSpecialties; numSpecialties++ )
	{
		perk = self GetLoadoutItem( self.class_num, "specialty" + ( numSpecialties + 1 ) );
		if ( perk != 0 )
		{
			return;
		}
	}

	self  AddPlayerStat( "killstreak_10_no_weapons_perks", 1 );
}

function scavengedGrenade()
{
	self endon("disconnect");
	self endon("death");
	self notify("scavengedGrenade");
	self endon("scavengedGrenade");

	for(;;)
	{
		self waittill( "lethalGrenadeKill" );	
		self AddPlayerStat( "kill_with_resupplied_lethal_grenade", 1 );
	}
}

function stunnedTankWithEMPGrenade( attacker )
{
	attacker AddPlayerStat( "stun_aitank_wIth_emp_grenade", 1 );
}


function playerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, sHitLoc, attackerStance, bledOut )
{
/#	print(level.gameType);	#/
	self.anglesOnDeath = self getPlayerAngles();
	if ( isdefined( attacker ) )
		attacker.anglesOnKill = attacker getPlayerAngles();
	if ( !isdefined( weapon ) )
		weapon = level.weaponNone;
	
	self endon("disconnect");

	data = spawnstruct();

	data.victim = self;
	data.victimStance = self getStance();
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.attackerStance = attackerStance;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.weapon = weapon;
	data.sHitLoc = sHitLoc;
	data.time = gettime();
	data.bledOut = false;
	if ( isdefined( bledOut ) )
	{
		data.bledOut = bledOut;
	}
		
	if ( isdefined( eInflictor ) && isdefined( eInflictor.lastWeaponBeforeToss ) ) 
	{
		data.lastWeaponBeforeToss = eInflictor.lastWeaponBeforeToss;
	}
	if ( isdefined( eInflictor ) && isdefined( eInflictor.ownerWeaponAtLaunch ) ) 
	{
		data.ownerWeaponAtLaunch = eInflictor.ownerWeaponAtLaunch;
	}

	
	wasLockingOn = 0;
	washacked = false;
	if ( isdefined( eInflictor ) )
	{
		if ( isdefined ( eInflictor.locking_on ) )
		{
			wasLockingOn |= eInflictor.locking_on;
		}
	
		if ( isdefined ( eInflictor.locked_on ) )
		{
			wasLockingOn |= eInflictor.locked_on;
		}		
		
		wasHacked = einflictor util::isHacked();
	}
	
	wasLockingOn &= ( 1 << data.victim.entnum );
	if ( wasLockingOn != 0 )
	{	
		data.wasLockingOn = true;
	}
	else 
	{
		data.wasLockingOn = false;
	}
	data.wasHacked = washacked;
	data.wasPlanting = data.victim.isplanting;
	data.wasUnderwater = data.victim IsPlayerUnderwater();
	if ( !isdefined( data.wasPlanting ) ) 
	{
		data.wasPlanting = false;
	}
	data.wasDefusing = data.victim.isdefusing;
	if ( !isdefined( data.wasDefusing ) ) 
	{
		data.wasDefusing = false;
	}	
	data.victimWeapon = data.victim.currentWeapon;
	data.victimOnGround = data.victim isOnGround();
	data.victimWasWallRunning = data.victim isWallRunning();
	data.victimWasDoubleJumping = data.victim IsDoubleJumping();
	data.victimCombatEfficiencyLastOnTime = data.victim.combatEfficiencyLastOnTime;
	data.victimSpeedburstLastOnTime = data.victim.speedburstLastOnTime;
	data.victimCombatEfficieny = data.victim ability_util::gadget_is_active( 15 );
	data.victimflashbackTime = data.victim.flashbackTime;
	data.victimheroAbilityActive = ability_player::gadget_CheckHeroAbilityKill( data.victim );
	data.victimElectrifiedBy = data.victim.electrifiedBy;
	data.victimHeroAbility = data.victim.heroAbility;
	data.victimWasInSlamState = data.victim IsSlamming();
	if ( !isdefined( data.victimflashbackTime ) ) 
	{
		data.victimflashbackTime = 0;
	}
	if ( !isdefined( data.victimCombatEfficiencyLastOnTime ) ) 
	{
		data.victimCombatEfficiencyLastOnTime = 0;
	}	
	if ( !isdefined( data.victimSpeedburstLastOnTime ) )
	{
		data.victimSpeedburstLastOnTime = 0;
	}
	data.victimVisionPulseActivateTime = data.victim.visionPulseActivateTime;
	if ( !isdefined( data.victimVisionPulseActivateTime ) )
	{
		data.victimVisionPulseActivateTime = 0;
	}
	data.victimVisionPulseArray = data.victim.visionPulseArray;
	data.victimVisionPulseOrigin = data.victim.visionPulseOrigin;
	data.victimVisionPulseOriginArray = data.victim.visionPulseOriginArray;

	if ( isPlayer( attacker ) )
	{
		data.attackerOnGround = data.attacker isOnGround();
		data.attackerWallRunning = data.attacker isWallRunning();
		data.attackerDoubleJumping = data.attacker IsDoubleJumping();
		data.attackerTraversing = data.attacker IsTraversing();
		data.attackerSliding = data.attacker IsSliding();
		data.attackerSpeedburst = data.attacker ability_util::gadget_is_active( 13 );
		data.attackerflashbackTime = data.attacker.flashbackTime;
		data.attackerHeroAbilityActive = ability_player::gadget_CheckHeroAbilityKill( data.attacker );
		data.attackerHeroAbility = data.attacker.heroAbility;
		
		if ( !isdefined( data.attackerflashbackTime ) ) 
		{
			data.attackerflashbackTime = 0;
		}
		data.attackerVisionPulseActivateTime = attacker.visionPulseActivateTime;
		if ( !isdefined( data.attackerVisionPulseActivateTime ) )
		{
			data.attackerVisionPulseActivateTime = 0;
		}
		data.attackerVisionPulseArray = attacker.visionPulseArray;
		data.attackerVisionPulseOrigin = attacker.visionPulseOrigin;
		if ( !isdefined( data.attackerStance ) ) 
		{
			data.attackerStance = data.attacker getStance();
		}
		data.attackerVisionPulseOriginArray = attacker.visionPulseOriginArray;
		
		data.attackerWasFlashed = data.attacker isFlashbanged();
		data.attackerWasConcussed = ( isdefined( data.attacker.concussionEndTime ) && data.attacker.concussionEndTime > gettime() );
	}
	else
	{
		data.attackerOnGround = false;
		data.attackerWallRunning = false;
		data.attackerDoubleJumping = false;
		data.attackerTraversing = false;
		data.attackerSliding = false;
		data.attackerSpeedburst = false;
		data.attackerflashbackTime = 0;
		data.attackerVisionPulseActivateTime = 0;
		data.attackerWasFlashed = false;
		data.attackerWasConcussed = false;
		data.attackerHeroAbilityActive = false;
		data.attackerStance = "stand";
	}
	
	waitAndProcessPlayerKilledCallback( data );
	
	data.attacker notify( "playerKilledChallengesProcessed" );
}

function doScoreEventCallback( callback, data )
{
	if ( !isdefined( level.scoreEventCallbacks ) )
		return;		
			
	if ( !isdefined( level.scoreEventCallbacks[callback] ) )
		return;
	
	if ( isdefined( data ) ) 
	{
		for ( i = 0; i < level.scoreEventCallbacks[callback].size; i++ )
			thread [[level.scoreEventCallbacks[callback][i]]]( data );
	}
	else 
	{
		for ( i = 0; i < level.scoreEventCallbacks[callback].size; i++ )
			thread [[level.scoreEventCallbacks[callback][i]]]();
	}
}

function waitAndProcessPlayerKilledCallback( data )
{
	if ( isdefined( data.attacker ) )
		data.attacker endon("disconnect");
	
	wait .05;
	util::WaitTillSlowProcessAllowed();
	
	level thread doChallengeCallback( "playerKilled", data );
	level thread doScoreEventCallback( "playerKilled", data );
}

function weaponIsKnife( weapon ) 
{
	if ( weapon == level.weaponBaseMelee || weapon == level.weaponBaseMeleeHeld || weapon == level.weaponBallisticKnife )
	{
		return true;
	}

	return false;
}

function eventReceived( eventName )
{
	self endon( "disconnect" );
	
	util::WaitTillSlowProcessAllowed();
	
	switch ( level.gameType )
	{
		case "tdm":
			{
				if ( eventName == "killstreak_10" )
				{
					self AddGameTypeStat( "killstreak_10", 1 );
				}
				else if ( eventName == "killstreak_15" )
				{
					self AddGameTypeStat( "killstreak_15", 1 );
				}
				else if ( eventName == "killstreak_20" )
				{
					self AddGameTypeStat( "killstreak_20", 1 );
				}
				else if ( eventName == "multikill_3" )
				{
					self AddGameTypeStat( "multikill_3", 1 );
				}
				else if ( eventName == "kill_enemy_who_killed_teammate" )
				{
					self AddGameTypeStat( "kill_enemy_who_killed_teammate", 1 );
				}
				else if ( eventName == "kill_enemy_injuring_teammate" )
				{
					self AddGameTypeStat( "kill_enemy_injuring_teammate", 1 );
				}
			}
			break;
		case "dm":
			{
				if ( eventName == "killstreak_10" )
				{
					self AddGameTypeStat( "killstreak_10", 1 );
				}
				else if ( eventName == "killstreak_15" )
				{
					self AddGameTypeStat( "killstreak_15", 1 );
				}
				else if ( eventName == "killstreak_20" )
				{
					self AddGameTypeStat( "killstreak_20", 1 );
				}
				else if ( eventName == "killstreak_30" )
				{
					self AddGameTypeStat( "killstreak_30", 1 );
				}
			}
			break;
		case "sd":
			{
				if ( eventName == "defused_bomb_last_man_alive" )
				{
					self AddGameTypeStat( "defused_bomb_last_man_alive", 1 );
				}
				else if ( eventName == "elimination_and_last_player_alive" )
				{
					self AddGameTypeStat( "elimination_and_last_player_alive", 1 );
				}
				else if ( eventName == "killed_bomb_planter" )
				{
					self AddGameTypeStat( "killed_bomb_planter", 1 );
				}
				else if ( eventName == "killed_bomb_defuser" )
				{
					self AddGameTypeStat( "killed_bomb_defuser", 1 );
				}
			}
			break;
		case "ctf":
			{
				if ( eventName == "kill_flag_carrier" )
				{
					self AddGameTypeStat( "kill_flag_carrier", 1 );
				}
				else if ( eventName == "defend_flag_carrier" )
				{
					self AddGameTypeStat( "defend_flag_carrier", 1 );
				}
			}
			break;
		case "dem":
			{
				if ( eventName == "killed_bomb_planter" )
				{
					self AddGameTypeStat( "killed_bomb_planter", 1 );
				}
				else if ( eventName == "killed_bomb_defuser" )
				{
					self AddGameTypeStat( "killed_bomb_defuser", 1 );
				}
			}
			break;
		default:
			break;
	}
}

function monitor_player_sprint()
{
	self endon("disconnect");
	self endon("killPlayerSprintMonitor");
	self endon ( "death" );
	
	self.lastSprintTime = undefined;
	
	while(1)
	{
		self waittill("sprint_begin");
        
		self waittill ("sprint_end");
        
		self.lastSprintTime = GetTime();
	}
}


function isFlashbanged()
{
	return isdefined( self.flashEndTime ) && gettime() < self.flashEndTime;
}
