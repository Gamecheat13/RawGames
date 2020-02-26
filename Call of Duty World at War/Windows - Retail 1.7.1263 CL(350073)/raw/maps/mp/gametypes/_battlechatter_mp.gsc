#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	if ( game["allies"] == "russian" )
		level.teamPrefix["allies"] = "RU";
	else
	level.teamPrefix["allies"] = "US";

	if ( game["axis"] == "japanese" )
		level.teamPrefix["axis"] = "JA";
	else
	level.teamPrefix["axis"] = "GE";
	
	level.isTeamSpeaking["allies"] = false;
	level.isTeamSpeaking["axis"] = false;
	
	level.speakers["allies"] = [];
	level.speakers["axis"] = [];
	
	level.bcSounds = [];
	level.bcSounds["reload"] = "inform_reloading";
	level.bcSounds["frag_out"] = "inform_attack_grenade";
	level.bcSounds["smoke_out"] = "inform_attack_smoke";
	level.bcSounds["conc_out"] = "inform_attack_stun";
	level.bcSounds["satchel_plant"] = "inform_attack_throwsatchel";
	level.bcSounds["kill"] = "inform_killfirm";
	level.bcSounds["casualty"] = "inform_casualty_generic";
	level.bcSounds["flare_out"] = "inform_attack_flare";
	level.bcSounds["gas_out"] = "inform_attack_gas";
	level.bcSounds["betty_plant"] = "inform_plant";
	level.bcSounds["landmark"] = "landmark";
	level.bcSounds["taunt"] = "taunt";
	level.bcSounds["killstreak_enemy"] = "killstreak_enemy";
	level.bcSounds["killstreak_taunt"] = "taunt_killstreak";
	level.bcSounds["kill_killstreak"] = "taunt_kill";
	level.bcSounds["perk"] = "perk_loadout";
	level.bcSounds["destructible"] = "destructible_near";
	level.bcSounds["teammate"] = "teammate_near";
	level.bcSounds["grenade"] = "inform_attack";
	level.bcSounds["grenade_incoming"] = "inform_incoming";
	level.bcSounds["gametype"] = "gametype";
	level.bcSounds["squad"] = "squad";
	level.bcSounds["enemy"] = "threat_infantry";
	level.bcSounds["sniper"] = "threat_sniper";
	level.bcSounds["gametype"] = "gametype";
	level.bcSounds["perk"] = "perk_loadout";
	level.bcSounds["perk"] = "perk_loadout";

	//Timer and probability dvars
	setdvar ( "bcmp_weapon_delay", "2000" );				//The time to wait between weapon fire to check if to say BC
	setdvar ( "bcmp_weapon_fire_probability", "90" );		//a number between this and a hundred will pass
	setdvar ( "bcmp_sniper_kill_probability", "25" );
	setdvar ( "bcmp_killstreak_incoming_probability", "50" );
	setdvar ( "bcmp_perk_call_probability", "50" );
	setdvar ( "bcmp_incoming_grenade_probability", "50" );
	setdvar ( "bcmp_toss_grenade_probability", "50" );
	setdvar ( "bcmp_kill_inform_probability", "50" );

	level.bcWeaponDelay = getdvarint( "bcmp_weapon_delay" );
	level.bcWeaponFireProbability = getdvarint( "bcmp_weapon_fire_probability" );
	level.bcSniperKillProbability = getdvarint( "bcmp_sniper_kill_probability" );
	level.bcKillstreakIncomingProbability = getdvarint( "bcmp_killstreak_incoming_probability" );
	level.bcPerkCallProbability = getdvarint( "bcmp_perk_call_probability" );
	level.bcIncomingGrenadeProbability = getdvarint( "bcmp_incoming_grenade_probability" );
	level.bcTossGrenadeProbability = getdvarint( "bcmp_toss_grenade_probability" );
	level.bcKillInformProbability = getdvarint( "bcmp_kill_inform_probability" );

	level.bcGlobalProbability = getdvarint( "scr_"+level.gametype+"_globalbattlechatterprobability" );
	level.allowBattleChatter = getdvarint( "scr_allowbattlechatter" );

	level.landmarks = getentarray ("trigger_landmark", "targetname");


	level thread onPlayerConnect();	
	level thread UpdateBCDvars();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );


		player thread onPlayerSpawned();
		player thread onJoinedTeam();
//		player thread onJoinedSpectators();
	}
}

UpdateBCDvars()
{
	level endon( "game_ended" );

	for(;;)
	{
		level.bcWeaponDelay = getdvarint ( "bcmp_weapon_delay" );
		level.bcWeaponFireProbability = getdvarint ( "bcmp_weapon_fire_probability" );
		level.bcSniperKillProbability = getdvarint ( "bcmp_sniper_kill_probability" );
		level thread maps\mp\gametypes\_globallogic::updateTeamStatus();

		wait( 2.0 );
	}
}

onJoinedTeam()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "joined_team" );

		if( self.pers["team"] == "axis" )
			self.pers["bcVoiceNumber"] = randomIntRange( 0, 2 );
		else
			self.pers["bcVoiceNumber"] = randomIntRange( 0, 3 );
	}
}


//onJoinedSpectators()
//{
//	self endon( "disconnect" );
//	
//	for(;;)
//	{
//		self waittill( "joined_spectators" );
//	}
//}
	

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );

		self.lastBCAttemptTime = 0;

		
		// help players be stealthy in splitscreen by not announcing their intentions
		if ( level.splitscreen )
			continue;
		
		self thread shoeboxTracking();
		self thread reloadTracking();
		self thread grenadeTracking();
		self thread weaponFired();
		self thread StickyGrenadeTracking();
	}
}

StickyGrenadeTracking()
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon ( "death_or_disconnect" );
	self endon ( "sticky_explode" );

	for( ;; )
	{
		self waittill ( "sticky_grenade" );

		if ( IsAlive( self ) )
				level thread mpSayLocalSound( self, "grenade_incoming", "sticky" );

		self notify( "sticky_explode" );
	}
}

onPlayerSuicideOrTeamKill( player, type )
{
	self endon ("disconnect");
	
	// make sure that this does not execute in the player killed callback time
	waittillframeend;
	
	myTeam = player.pers["team"];

	if( level.alivePlayers[myTeam].size )
	{
		index = CheckDistanceToEvent( player, 1000 * 1000 );
		if( isDefined( index ) )
		{
			//Give it a bit of a delay 
			wait( 1.0 );

			if ( IsAlive( level.alivePlayers[myTeam][index] ) )
				level thread mpSayLocalSound( level.alivePlayers[myTeam][index], "teammate", type );
		}
	}
}

onPlayerKillstreak( player )
{
	player endon ("disconnect");
	
	// make sure that this does not execute in the player killed callback time
	waittillframeend;
	
	if( randomIntRange( 0, 100 ) >= level.bcKillInformProbability )
	{
		if( player.cur_kill_streak >= 15 )
		{
 			level thread mpSayLocalSound( player, "killstreak_taunt", "15friendly" );
		}
		else if( player.cur_kill_streak >= 10 )
		{
			level thread mpSayLocalSound( player, "killstreak_taunt", "10friendly" );
		}
		else if( player.cur_kill_streak >= 5 )
		{
			level thread mpSayLocalSound( player, "killstreak_taunt", "5friendly" );
		}
	}
}

onKillstreakUsed( killstreak, team )
{
	wait( 3.0 );
	for( i = 0; i < level.alivePlayers[team].size; i++ )
	{
		//Probability check
		if( randomIntRange( 0, 100 ) >= level.bcKillstreakIncomingProbability )
		{
			if( isDefined( level.alivePlayers[team][i] ) && isAlive( level.alivePlayers[team][i] ) )
			{
				level thread mpSayLocalSound( level.alivePlayers[team][i], "killstreak_enemy", killstreak, "true" );
				wait( 0.75 );
			}
		}
	}
}

onPlayerNearExplodable( object,  type )
{
	self endon ( "disconnect" );
	self endon ( "explosion_started" );


	for(;;)
	{
		player = CheckDistanceToObject( 500 * 500, object );
		if( isDefined( player ) )
		{
			level thread mpSayLocalSound( player, "destructible", type );
			level notify( "explosion_started" );
		}
		wait( 0.5 );
	}
}

shoeboxTracking()
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon ( "death_or_disconnect" );
	
	while(1)
	{
		self waittill( "begin_firing" );
		weaponName = self getCurrentWeapon();
		if ( weaponName == "mine_shoebox_mp" )
			level thread mpSayLocalSound( self, "satchel_plant", "shoebox" );
	}
}


reloadTracking()
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon ( "death_or_disconnect" );

	for( ;; )
	{
		self waittill ( "reload_start" );

		//Probability check
		if( randomIntRange( 0, 100 ) >= level.bcWeaponFireProbability )
		{
			level thread mpSayLocalSound( self, "reload", "generic" );
		}
	}
}

perkSpecificBattleChatter( type, checkDistance )
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon ( "death_or_disconnect" );
	self endon ( "perk_done" );

	// make sure that this does not execute in the player killed callback time
	waittillframeend;

	for( ;; )
	{
		//Probability check
		if( randomIntRange( 0, 100 ) >= level.bcPerkCallProbability )
		{
			if( isDefined( checkDistance ) )
			{
				index = CheckDistanceToEvent( self, 1000 * 1000 );
				if( isDefined( index ) )
					level thread mpSayLocalSound( level.alivePlayers[self.pers["team"]][index], "perk", type );
			}
			else
			{
				if( isPlayer( self ) ) 
					level thread mpSayLocalSound( self, "perk", type );
			}
		}

		wait( 3.0 );
		self notify( "perk_done" );
	}
}

weaponFired()
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon ( "death_or_disconnect" );

	for( ;; )
	{
		self waittill ( "weapon_fired" );

		//Check to make sure the last attempt has been a while
		if( getTime() - self.lastBCAttemptTime > level.bcWeaponDelay )
		{

			self.lastBCAttemptTime = getTime();

			//Probability check
			if( randomIntRange( 0, 100 ) >= level.bcWeaponFireProbability )
			{
				//see if the shot occured in a locational landmark
				self.landmarkEnt = self getLandmark();
				if( isdefined (self.landmarkEnt) )
				{
					myTeam = self.pers["team"];
					enemyTeam = getOtherTeam( myTeam );
					
					keys = getarraykeys( level.squads[enemyTeam] );

					//Give each squad a shot at saying it
					for( i = 0; i < keys.size; i++ )
					{
						if( level.squads[enemyTeam][keys[i]].size )
						{
							index = randomIntRange( 0, level.squads[enemyTeam][keys[i]].size );

							level thread mpSayLocationalLocalSound( level.squads[enemyTeam][keys[i]][index], "enemy", "landmark", self.landmarkEnt.script_landmark );
						}
					}
				}
			}
		}
	}
}


KilledBySniper( sniper )
{
	self endon("disconnect");
	sniper endon("disconnect");
	
	// make sure that this does not execute in the player killed callback time
	waittillframeend;
	
	victem = self;
	
	//Probability check
	if( randomIntRange( 0, 100 ) >= level.bcSniperKillProbability )
	{
		sniper.landmarkEnt = sniper getLandmark();
		if( isdefined (sniper.landmarkEnt) )
		{
			myTeam = sniper.pers["team"];
			enemyTeam = getOtherTeam( myTeam );
		
			keys = getarraykeys( level.squads[enemyTeam] );
			//Give each squad a shot at saying it
			for( i = 0; i < keys.size; i++ )
			{
				if( level.squads[enemyTeam][keys[i]].size )
				{
					index = CheckDistanceToEvent( victem, 1000 * 1000, keys[i], enemyTeam );
					if( isDefined( index ) )
					{
						level thread mpSayLocationalLocalSound( level.squads[enemyTeam][keys[i]][index], "sniper", "landmark", sniper.landmarkEnt.script_landmark );
					}
				}
			}
		}
	}
}


grenadeTracking()
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon ( "death_or_disconnect" );

	for( ;; )
	{
		self waittill ( "grenade_fire", grenade, weaponName );

		if ( weaponName == "frag_grenade_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "grenade" );

			level thread incomingGrenadeTracking( self, grenade, "grenade" );
		}
		else if ( weaponName == "m8_white_smoke_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "smoke" );
		}
		else if ( weaponName == "napalmblob_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "molotov" );
		}
		else if ( weaponName == "satchel_charge_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "satchel" );

			level thread incomingGrenadeTracking( self, grenade, "satchel" );
		}
		else if ( weaponName == "tabun_gas_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "gas" );
		}
		else if ( weaponName == "mine_bouncing_betty_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "betty_plant", "shoebox" );
		}
		else if ( weaponName == "signal_flare_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "flare" );
		}
		else if ( weaponName == "sticky_grenade_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "sticky" );
		}
	}
}

incomingGrenadeTracking( thrower, grenade, type )
{
	//Probability check
	if( randomIntRange( 0, 100 ) >= level.bcIncomingGrenadeProbability )
	{
		//Give it a bit of a delay 
		wait( 1.0 );
		enemyTeam = thrower.pers["team"];
		myTeam = getOtherTeam( enemyTeam );

		if( level.alivePlayers[myTeam].size )
		{
			player = CheckDistanceToObject( 500 * 500, grenade, myTeam );
			if( isDefined( player ) )
			{
				//index = randomIntRange( 0, level.alivePlayers[myTeam].size );
				level thread mpSayLocalSound( player, "grenade_incoming", type );
			}
		}
	}
}

incomingSpecialGrenadeTracking( type )
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon ( "death_or_disconnect" );
	self endon ( "grenade_ended" );

	for(;;)
	{
		//Probability check
		if( randomIntRange( 0, 100 ) >= level.bcIncomingGrenadeProbability )
		{
			if( level.alivePlayers[self.pers["team"]].size )
			{
				level thread mpSayLocalSound(  self, "grenade_incoming", type );
				self notify( "grenade_ended" );
			}
		}
		wait( 3.0 );
	}
}

gametypeSpecificBattleChatter( event, team )
{

	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon ( "death_or_disconnect" );
	self endon ( "event_ended" );

	for(;;)
	{
		if( isDefined( team ) )
		{

			index = CheckDistanceToEvent( self, 300 * 300 );
			if( isDefined( index ) )
			{
				level thread mpSayLocalSound( level.alivePlayers[team][index], "gametype", event );
				self notify( "event_ended" );
			}
		}
		else
		{
			index = randomIntRange( 0, level.alivePlayers["allies"].size );
			level thread mpSayLocalSound( level.alivePlayers["allies"][index], "gametype", event );
			index = randomIntRange( 0, level.alivePlayers["axis"].size );
			level thread mpSayLocalSound( level.alivePlayers["axis"][index], "gametype", event );
		}

		wait( 1.0 );
	}
}


sayLocalSoundDelayed( player, soundType1, soundType2, delay )
{
	//player endon ( "death" );
	//player endon ( "disconnect" );
	player endon ( "death_or_disconnect" );
	
	wait ( delay );
	
	mpSayLocalSound( player, soundType1, soundType2 );
}


sayLocalSound( player, soundType )
{
	//player endon ( "death" );
	//player endon ( "disconnect" );
	player endon ( "death_or_disconnect" );

	if ( isSpeakerInRange( player ) )
		return;
		
	if( player.pers["team"] != "spectator" )
	{
		soundAlias = level.teamPrefix[player.pers["team"]] + "_" + player.pers["bcVoiceNumber"] + "_" + level.bcSounds[soundType];
		//player thread doSound( soundAlias );
	}
}

mpSayLocalSound( player, partOne, partTwo, checkSpeakers )
{
	//player endon ( "death" );
	//player endon ( "disconnect" );
	player endon ( "death_or_disconnect" );

	if( !isDefined( checkSpeakers ) )
	{
		if ( isSpeakerInRange( player ) )
			return;
	}

	if( player.leaderDialogActive )
		return;

		
	if( player.pers["team"] != "spectator" )
	{
		soundAlias = level.teamPrefix[player.pers["team"]] + "_" + player.pers["bcVoiceNumber"] + "_" + level.bcSounds[partOne] + "_" + partTwo;
		player thread doSound( soundAlias );
	}
}

mpSayLocationalLocalSound( player, prefix, partOne, partTwo )
{
	//player endon ( "death" );
	//player endon ( "disconnect" );
	player endon ( "death_or_disconnect" );

	if ( isSpeakerInRange( player ) )
		return;

	if( player.leaderDialogActive )
		return;
		
	if( player.pers["team"] != "spectator" )
	{
		soundAlias1 = level.teamPrefix[player.pers["team"]] + "_" + player.pers["bcVoiceNumber"] + "_" + level.bcSounds[prefix];
		soundAlias2 = level.teamPrefix[player.pers["team"]] + "_" + player.pers["bcVoiceNumber"] + "_" + level.bcSounds[partOne] + "_" + partTwo;
		player thread doLocationalSound( soundAlias1, soundAlias2 );
	}
}


doSound( soundAlias )
{
	team = self.pers["team"];
	level addSpeaker( self, team );

	if( level.allowBattleChatter && randomIntRange( 0, 100 ) >= level.bcGlobalProbability )
		self playSoundToTeam( soundAlias, team, self );
	
	self thread timeHack( soundAlias ); // workaround because soundalias notify isn't happening
	self waittill_any( soundAlias, "death", "disconnect" );
	level removeSpeaker( self, team );
}

doLocationalSound( soundAlias1, soundAlias2 )
{
	team = self.pers["team"];
	level addSpeaker( self, team );

	if( level.allowBattleChatter && randomIntRange( 0, 100 ) >= level.bcGlobalProbability )
		self playBattleChatterToTeam( soundAlias1, soundAlias2, team, self );

	self thread timeHack( soundAlias1 ); // workaround because soundalias notify isn't happening
	self waittill_any( soundAlias1, "death", "disconnect" );
	level removeSpeaker( self, team );
}


timeHack( soundAlias )
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon ( "death_or_disconnect" );

	wait ( 2.0 );
	self notify ( soundAlias );
}


isSpeakerInRange( player )
{
	//player endon ( "death" );
	//player endon ( "disconnect" );
	player endon ( "death_or_disconnect" );

	distSq = 1000 * 1000;

	// to prevent player switch to spectator after throwing a granade causing damage to someone and result in attacker.pers["team"] = "spectator"
	if( isdefined( player ) && isdefined( player.pers["team"] ) && player.pers["team"] != "spectator" )
	{
		for ( index = 0; index < level.speakers[player.pers["team"]].size; index++ )
		{
			teammate = level.speakers[player.pers["team"]][index];
			if ( teammate == player )
				return true;
				
			if ( distancesquared( teammate.origin, player.origin ) < distSq )
				return true;
		}
	}

	return false;
}


addSpeaker( player, team )
{
	level.speakers[team][level.speakers[team].size] = player;
}


// this is lazy... fix up later by tracking ID's and doing array slot swapping
removeSpeaker( player, team )
{
	newSpeakers = [];
	for ( index = 0; index < level.speakers[team].size; index++ )
	{
		if ( level.speakers[team][index] == player )
			continue;
			
		newSpeakers[newSpeakers.size] = level.speakers[team][index]; 
	}
	
	level.speakers[team] = newSpeakers;
}


getLandmark()
{
	landmarks = level.landmarks;
	for (i = 0; i < landmarks.size; i++)
	{
		if (self istouching (landmarks[i]) && isdefined (landmarks[i].script_landmark))
			return (landmarks[i]);
	}
	return (undefined);
}

CheckDistanceToEvent( player, area, squadIndex, squadEnemyTeam )
{
	if( isDefined( squadIndex ) )
	{
		for ( index = 0; index < level.squads[squadEnemyTeam][squadIndex].size; index++ )
		{
			squadMember = level.squads[squadEnemyTeam][squadIndex][index];

			if( isDefined( squadMember ) && squadMember == player )
				continue;

			if ( isAlive( player ) && distancesquared( squadMember.origin, player.origin ) < area )
					return index;
		}

	}
	else
	{
		for ( index = 0; index < level.alivePlayers[player.pers["team"]].size; index++ )
		{
			teammate = level.alivePlayers[player.pers["team"]][index];

			if( isDefined( teammate ) && teammate == player )
				continue;

			if ( isAlive( player ) && distancesquared( teammate.origin, player.origin ) < area )
				return index;
		}

	}
}

CheckDistanceToEnemy( enemy, area, team )
{
	for ( index = 0; index < level.alivePlayers[team].size; index++ )
	{
		player = level.alivePlayers[team][index];
		if ( isAlive( enemy ) && distancesquared( enemy.origin, player.origin ) < area )
				return index;
	}
}

CheckDistanceToObject( area, object, team )
{
	if( isDefined( team ) )
	{
		for( i = 0; i < level.alivePlayers[team].size; i++ )
		{
			player = level.alivePlayers[team][i];

			 if ( isDefined( object ) && distancesquared( player.origin, object.origin ) < area )
				 return player;
		}
	}
	else
	{
		for( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if( isAlive( player ) )
			{
				 if ( isDefined( object ) && distancesquared( player.origin, object.origin ) < area )
					 return player;
			}
		}
	}
}
