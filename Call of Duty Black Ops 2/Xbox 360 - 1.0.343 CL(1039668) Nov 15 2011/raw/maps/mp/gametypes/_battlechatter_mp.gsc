#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	if ( level.createFX_enabled )
		return;

	// these are defined in the teamset file
	Assert( IsDefined( level.teamPrefix["allies"] ) );
	Assert( IsDefined( level.teamPostfix["allies"] ) );
	Assert( IsDefined( level.teamPrefix["axis"] ) );
	Assert( IsDefined( level.teamPostfix["axis"] ) );
	
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
	level.bcSounds["kill"] = "inform_kill";
	level.bcSounds["casualty"] = "inform_casualty_gen";
	level.bcSounds["flare_out"] = "inform_attack_flare";
	level.bcSounds["gas_out"] = "inform_attack_gas";
	level.bcSounds["betty_plant"] = "inform_plant";
	level.bcSounds["landmark"] = "landmark";
	level.bcSounds["taunt"] = "taunt";
	level.bcSounds["killstreak_enemy"] = "kls_enemy";
	level.bcSounds["killstreak_taunt"] = "taunt_kls";
	level.bcSounds["kill_killstreak"] = "kill_killstreak";
	level.bcSounds["destructible"] = "destructible_near";
	level.bcSounds["teammate"] = "teammate_near";
//	level.bcSounds["grenade"] = "inform_attack";
	level.bcSounds["grenade_incoming"] = "inform_incoming";
	level.bcSounds["gametype"] = "gametype";
	level.bcSounds["squad"] = "squad";
	level.bcSounds["enemy"] = "threat";
	level.bcSounds["sniper"] = "sniper";
	level.bcSounds["gametype"] = "gametype";
	level.bcSounds["perk"] = "perk_equip";
	level.bcSounds["pain"] = "pain";
	level.bcSounds["death"] = "death";
	level.bcSounds["breathing"] = "breathing";
	level.bcSounds["inform_attack"] = "inform_attack";
	level.bcSounds["inform_need"] = "inform_need";	
	level.bcSounds["revive"] = "revive";
	level.bcSounds["scream"] = "scream";
	level.bcSounds["fire"] = "fire";

	//Timer and probability dvars
	SetDvar ( "bcmp_weapon_delay", "2000" );				//The time to wait between weapon fire to check if to say BC
	SetDvar ( "bcmp_weapon_fire_probability", "80" );		//a number between this and a hundred will pass
	SetDvar ( "bcmp_weapon_reload_probability", "60" );
	SetDvar ( "bcmp_weapon_fire_threat_probability", "80" );
	SetDvar ( "bcmp_sniper_kill_probability", "20" );
	SetDvar ( "bcmp_ally_kill_probability", "60" );	
	SetDvar ( "bcmp_killstreak_incoming_probability", "100" );
	SetDvar ( "bcmp_perk_call_probability", "100" );
	SetDvar ( "bcmp_incoming_grenade_probability", "5" ); 
	SetDvar ( "bcmp_toss_grenade_probability", "20" ); 
	SetDvar ( "bcmp_kill_inform_probability", "40" );
	SetDvar ( "bcmp_pain_small_probability", "0" );
	SetDvar ( "bcmp_breathing_probability", "0" );	
	SetDvar ( "bcmp_pain_delay", ".5" );	
	SetDvar ( "bcmp_last_stand_delay", "3");
	SetDvar ( "bcmp_breathing_delay", "3");
	SetDvar ( "bcmp_enemy_contact_delay", "30");
	SetDvar ( "bcmp_enemy_contact_level_delay", "15");	

	level.bcWeaponDelay = GetDvarint( "bcmp_weapon_delay" );
	level.bcWeaponFireProbability = GetDvarint( "bcmp_weapon_fire_probability" );
	level.bcWeaponReloadProbability = GetDvarint( "bcmp_weapon_reload_probability" );	
	level.bcWeaponFireThreatProbability = GetDvarint( "bcmp_weapon_fire_threat_probability" );	
	level.bcSniperKillProbability = GetDvarint( "bcmp_sniper_kill_probability" );
	level.bcAllyKillProbability = GetDvarint( "bcmp_ally_kill_probability" );
	level.bcKillstreakIncomingProbability = GetDvarint( "bcmp_killstreak_incoming_probability" );
	level.bcPerkCallProbability = GetDvarint( "bcmp_perk_call_probability" );
	level.bcIncomingGrenadeProbability = GetDvarint( "bcmp_incoming_grenade_probability" );
	level.bcTossGrenadeProbability = GetDvarint( "bcmp_toss_grenade_probability" );
	level.bcKillInformProbability = GetDvarint( "bcmp_kill_inform_probability" );
	level.bcPainSmallProbability = GetDvarint( "bcmp_pain_small_probability" );
	level.bcPainDelay = GetDvarint( "bcmp_pain_delay" );	
	level.bcLastStandDelay = GetDvarInt ( "bcmp_last_stand_delay" );
	level.bcmp_breathing_delay = GetDvarInt ( "bcmp_breathing_delay" );	
	level.bcmp_enemy_contact_delay = GetDvarInt ( "bcmp_enemy_contact_delay" );		
	level.bcmp_enemy_contact_level_delay = GetDvarInt ( "bcmp_enemy_contact_level_delay" );			
	level.bcmp_breathing_probability = GetDvarint( "bcmp_breathing_probability" );

	level.bcGlobalProbability = GetDvarint( "scr_"+level.gametype+"_globalbattlechatterprobability" );
	level.allowBattleChatter = GetDvarint( "scr_allowbattlechatter" );

	level.landmarks = getentarray ("trigger_landmark", "targetname");
	level.enemySpottedDialog = true;

	level thread enemyContactLevelDelay();
	level thread onPlayerConnect();	
	level thread UpdateBCDvars();
	
	level.battlechatter_init = true;
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );

		player thread onJoinedTeam();		
		player thread onPlayerSpawned();

//		player thread onJoinedSpectators();
	}
}

UpdateBCDvars()
{
	level endon( "game_ended" );

	for(;;)
	{
		level.bcWeaponDelay = GetDvarint ( "bcmp_weapon_delay" );
		level.bcKillInformProbability = GetDvarint ( "bcmp_kill_inform_probability" );
		level.bcWeaponFireProbability = GetDvarint ( "bcmp_weapon_fire_probability" );
		level.bcSniperKillProbability = GetDvarint ( "bcmp_sniper_kill_probability" );
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

		self.pers["bcVoiceNumber"] = randomIntRange( 0, 3 );
	}
}


onJoinedSpectators()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "joined_spectators" );
	}
}


onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );

		self.lastBCAttemptTime = 0;
		self.heartbeatsnd = false; 
		
		self.bcVoiceNumber = self.pers["bcVoiceNumber"];
		
		// help players be stealthy in splitscreen by not announcing their intentions
		if ( level.splitscreen )
			continue;

		//self thread shoeboxTracking();
		self thread reloadTracking();
		self thread grenadeTracking();
		//self thread weaponFired();
		self thread enemyThreat();		
		self thread StickyGrenadeTracking();
		self thread painVox();
		self thread allyRevive();		
		//self thread lastStandVox();
		self thread breathingHurtVox();		
		self thread breathingBetterVox();	
		self thread onFireScream();
		self thread deathVox();												
	}
}
enemyContactLevelDelay()
{
	while (1)
	{
		level waittill ( "level_enemy_spotted");
		level.enemySpottedDialog = false;
		wait (level.bcmp_enemy_contact_level_delay);
		level.enemySpottedDialog = true;
	}	
}	

breathingHurtVox()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	
	// TODO finish notifies and expland to DTP, Cough etc
	for( ;; )
	{
		self waittill ( "snd_breathing_hurt" );		
		//make sure he is still alive
		if( randomIntRange( 0, 100 ) >= level.bcmp_breathing_probability )
		{	  		
			wait (.5);
			if ( IsAlive( self ) )
					level thread mpSayLocalSound( self, "breathing", "hurt", false, true );
	
		}
		wait (level.bcmp_breathing_delay);
	
	}	
}

onFireScream()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	// TODO finish notifies and expland to DTP, Cough etc
	for( ;; )
	{
		self waittill ( "snd_burn_scream" );		
		//make sure he is still alive
		if( randomIntRange( 0, 100 ) >= level.bcmp_breathing_probability )
		{	  		
			wait (.5);
			if ( IsAlive( self ) )
					level thread mpSayLocalSound( self, "fire", "scream" );
		}
		wait (level.bcmp_breathing_delay);
	
	}	
}		
breathingBetterVox()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	// TODO finish notifies and expland to DTP, Cough etc
	
	for( ;; )
	{
		self waittill ( "snd_breathing_better" );		
		//make sure he is still alive
		if ( IsAlive( self ) )
					level thread mpSayLocalSound( self, "breathing", "better", false, true );
		
		//wait (level.bcLastStandDelay);
	
	}	
}	
lastStandVox()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	// wait for player to enter last stand
	self waittill ( "snd_last_stand" );
	
	for( ;; )
	{
		// wait for bleed out begin
		//self waittill ( "snd_last_stand" );
		// wait for player to fire weapon
		// Change to Need help VOX
		self waittill ( "weapon_fired" );		
		//make sure he is still alive
		if ( IsAlive( self ) )
					level thread mpSayLocalSound( self, "perk", "laststand" );
		
		wait (level.bcLastStandDelay);
	
	}	
}	
allyRevive()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	for( ;; )
	{
		// wait for revive
		self waittill ( "snd_ally_revive" );

		if ( IsAlive( self ) )
					level thread mpSayLocalSound( self, "inform_attack", "revive" );
		
		wait (level.bcLastStandDelay);
	
	}	
}	
painVox ()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	for( ;; )
	{
		// wait for pain
		self waittill ( "snd_pain_player" );

		if( randomIntRange( 0, 100 ) >= level.bcPainSmallProbability )
		{
			if ( IsAlive( self ) )
					level thread mpSayLocalSound( self, "pain", "small" );
		}
		
		wait (level.bcPainDelay);
	
	}
}
deathVox ()
{

	self endon ( "disconnect" );	

	self waittill ( "death" );
	//self waittill ( "killed_player" );

	//level thread mpSayLocalSound( self, "pain", "death" );
	
	if( self.team != "spectator" )
	{
		soundAlias = level.teamPrefix[self.team] + "_" + self.bcVoiceNumber + "_" + level.bcSounds["pain"] + "_" + "death";

		self thread doSound( soundAlias );
	}
	
}		
StickyGrenadeTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "sticky_explode" );

	for( ;; )
	{
		self waittill ( "grenade_stuck", grenade );

		if ( IsDefined( grenade ) )
		{
			grenade.stuckToPlayer = self;
		}

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

	if( !isdefined(level.battlechatter_init) )
		return;

	if( !level.teamBased )
		return;
	
	myTeam = player.team;

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
	/*
	// make sure that this does not execute in the player killed callback time
	waittillframeend;
	
	if( !isdefined(level.battlechatter_init) )
		return;
		
	if( randomIntRange( 0, 100 ) >= level.bcKillInformProbability )
	{
		if( player.pers["cur_kill_streak"] >= 15 )
		{
 			level thread mpSayLocalSound( player, "killstreak_taunt", "fifteen" );
		}
		else if( player.pers["cur_kill_streak"] >= 10 )
		{
			level thread mpSayLocalSound( player, "killstreak_taunt", "ten" );
		}
		else if( player.pers["cur_kill_streak"] >= 5 )
		{
			level thread mpSayLocalSound( player, "killstreak_taunt", "five" );
		}
	}
	*/
}

onKillstreakUsed( killstreak, team )
{
	/*
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
 */
}

onPlayerNearExplodable( object,  type )
{
	self endon ( "disconnect" );
	self endon ( "explosion_started" );
/*

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
*/
}

shoeboxTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
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
	self endon ( "death" );
	self endon ( "disconnect" );

	for( ;; )
	{
		self waittill ( "reload_start" );

		//Probability check
		if( randomIntRange( 0, 100 ) >= level.bcWeaponReloadProbability )
		{
			level thread mpSayLocalSound( self, "reload", "gen" );
		}
	}
}

perkSpecificBattleChatter( type, checkDistance )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "perk_done" );
/*

	// make sure that this does not execute in the player killed callback time
	waittillframeend;
	
	if( !isdefined(level.battlechatter_init) )
		return;

	for( ;; )
	{
		//Probability check
		if (false)//if( randomIntRange( 0, 100 ) >= level.bcPerkCallProbability )
		{
			if( isDefined( checkDistance ) )
			{
				index = CheckDistanceToEvent( self, 1000 * 1000 );
				if( isDefined( index ) )
					level thread mpSayLocalSound( level.alivePlayers[self.team][index], "perk", type );
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

*/
}
enemyThreat()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	for( ;; )
	{
		self waittill ( "weapon_fired" );
		
		if (level.enemySpottedDialog)		
		{
			
			if( getTime() - self.lastBCAttemptTime > level.bcmp_enemy_contact_delay )
			{
	
				//println ("battlechatter - enemyThreat passed check ");
				shooter = self;
				myTeam = self.team;
				enemyTeam = getOtherTeam( myTeam );	
				keys = getarraykeys( level.squads[enemyTeam] );
				
				closest_enemy = shooter get_closest_player_enemy();
				
				self.lastBCAttemptTime = getTime();
				//Probability check
				if (isdefined (closest_enemy))
				{
					if( randomIntRange( 0, 100 ) >= level.bcWeaponFireThreatProbability )
					{
						//println ("battlechatter - enemyThreat random chance passed check");
						area = 600 * 600;
		
						if ( DistanceSquared( closest_enemy.origin, self.origin ) < area )
						{
							//println ("battlechatter - enemyThreat random chance passed check played sound");
							level thread mpSayLocalSound( closest_enemy, "enemy", "infantry", false );
							level notify ( "level_enemy_spotted");
						}			
					}	
				}
			}
		}
	}
}	
weaponFired()
{
	self endon ( "death" );
	self endon ( "disconnect" );

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
					myTeam = self.team;
					enemyTeam = getOtherTeam( myTeam );
					
					keys = getarraykeys( level.squads[enemyTeam] );

					//Give each squad a shot at saying it
					for( i = 0; i < keys.size; i++ )
					{
						if( level.squads[enemyTeam][keys[i]].size )
						{
							index = randomIntRange( 0, level.squads[enemyTeam][keys[i]].size );
;
							level thread mpSayLocalSound( level.squads[enemyTeam][keys[i]][index], "enemy", "infantry" );
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
	
	if( !isdefined(level.battlechatter_init) )
		return;
		
	victim = self;
	
	if ( level.hardcoreMode || !level.teamBased )
		return;
		
	//Probability check
	if( randomIntRange( 0, 100 ) >= level.bcSniperKillProbability )
	{
		sniperTeam = sniper.team;
		victimTeam = getOtherTeam( sniperTeam );

		index = CheckDistanceToEvent( victim, 1000 * 1000 );
		if( isDefined( index ) )
		{
			level thread mpSayLocalSound( level.alivePlayers[victimTeam][index], "enemy", "sniper", false );
		}
	}
}
PlayerKilled(attacker)
{
	self endon("disconnect");
	
	if (!isplayer (attacker))
	{
		return;
	}

	// make sure that this does not execute in the player killed callback time
	waittillframeend;
	
	if( !isdefined(level.battlechatter_init) )
		return;
	
	victim = self;
	
	//println ("battlechatter - playerkilled");
	if ( level.hardcoreMode )
		return;
		
	//Probability check
	if( randomIntRange( 0, 100 ) >= level.bcAllyKillProbability )
	{
		//println ("battlechatter - playerkilled passed check");
		attackerTeam = attacker.team;
		victimTeam = getOtherTeam( attackerTeam );

		closest_ally = victim get_closest_player_ally();
		
		area = 1000 * 1000;
		if (isdefined (closest_ally))
		{
			if ( DistanceSquared( closest_ally.origin, self.origin ) < area )		
			{
				//println ("battlechatter - playerkilled passed check played sound");
				level thread mpSayLocalSound( closest_ally, "inform_need", "medic", false );
    	}
	}	
	}
}

grenadeTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	for( ;; )
	{
		self waittill ( "grenade_fire", grenade, weaponName );


		if ( weaponName == "frag_grenade_mp" )
		{
			//println ("battlechatter - frag_grenade_mp");
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
			{
				//println ("battlechatter - frag_grenade_mp check passed");
				level thread mpSayLocalSound( self, "inform_attack", "grenade" );
			}
			level thread incomingGrenadeTracking( self, grenade, "grenade" );
		}
/* removed 		
		else if ( weaponName == "acoustic_sensor_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "acoustic_sensor" );
		}
*/		
		else if ( weaponName == "c4_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "inform_attack", "c4" );
		}
/* removed camera spike chatter 
		else if ( weaponName == "camera_spike_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "camera_spike" );
		}
*/
		else if ( weaponName == "claymore_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "inform_attack", "claymore" );
		}
		else if ( weaponName == "flash_grenade_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "inform_attack", "flash" );
		}
/* removed 		
		else if ( weaponName == "satchel_charge_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "satchel" );

			level thread incomingGrenadeTracking( self, grenade, "satchel" );
		}
		else if ( weaponName == "scrambler_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "scrambler" );

			level thread incomingGrenadeTracking( self, grenade, "scrambler" );
		}		
		else if ( weaponName == "signal_flare_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "flare" );
		}
*/		
		else if ( weaponName == "sticky_grenade_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "inform_attack", "sticky" );
		}
		else if ( weaponName == "tabun_gas_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "inform_attack", "gas" );
		}
/* removed 		
		else if ( weaponName == "tactical_insertion_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "grenade", "tactical_insertion" );
		}		
*/					
		else if ( weaponName == "willy_pete_mp" )
		{
			if( randomIntRange( 0, 100 ) >= level.bcTossGrenadeProbability )
				level thread mpSayLocalSound( self, "inform_attack", "smoke" );
		}	
			
	}
}

incomingGrenadeTracking( thrower, grenade, type )
{
	//Probability check
	//if( randomIntRange( 0, 100 ) >= level.bcIncomingGrenadeProbability )
	{
		//Give it a bit of a delay 
		wait( 1.0 );
		//Check if player threw grenade and then quit
		if( !isDefined( thrower ) )
		{
			return;
		}
		//Added to prevent potential bug if player switches to spectate during wait
		if(thrower.team == "spectator")
		{
			return;
		}
		enemyTeam = thrower.team;

		if( level.teamBased )
			myTeam = getOtherTeam( enemyTeam );
		else
			myTeam = undefined;

		if( ( !level.teamBased && level.players.size ) || level.alivePlayers[myTeam].size )
		{
			player = CheckDistanceToObject( 500 * 500, grenade, myTeam, thrower );
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
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "grenade_ended" );

	for(;;)
	{
		//Probability check
		if( randomIntRange( 0, 100 ) >= level.bcIncomingGrenadeProbability )
		{
			if( level.alivePlayers[self.team].size || (!level.teamBased && level.players.size) )
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

	self endon ( "death" );
	self endon ( "disconnect" );
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
	player endon ( "death" );
	player endon ( "disconnect" );
	
	if( !isdefined(level.battlechatter_init) )
		return;
		
	wait ( delay );
	mpSayLocalSound( player, soundType1, soundType2 );
}


sayLocalSound( player, soundType )
{
	player endon ( "death" );
	player endon ( "disconnect" );

	if ( isSpeakerInRange( player ) )
		return;
		
	if( player.team != "spectator" )
	{
		soundAlias = level.teamPrefix[player.team] + "_" + player.bcVoiceNumber + "_" + level.bcSounds[soundType];
		//player thread doSound( soundAlias );
	}
}

mpSayLocalSound( player, partOne, partTwo, checkSpeakers, is2d )
{
	player endon ( "death" );
	player endon ( "disconnect" );


	//Ensure there is more than one player in the game
	if( level.players.size <= 1 )
		return;

		if( !isDefined( checkSpeakers ) )
		{
			if ( isSpeakerInRange( player ) )
			{
				//println ("battlechatter - speaker is not in range");
 				return;
			}	
		}

// Removed Check CDC 
//	if( player.leaderDialogActive )
//		return;

 //no chatter if you have dead silence CDC 2/16/10 changed to pro version.
	if ( player HasPerk( "Specialty_loudenemies" ) )
	{
		//println ("battlechatter - speaker specialty_quieter");	
		return;
	}
	//println ("battlechatter - mpSayLocalSound");
			
	if( player.team != "spectator" )
	{
		soundAlias = level.teamPrefix[player.team] + "_" + player.bcVoiceNumber + "_" + level.bcSounds[partOne] + "_" + partTwo;
		if (isdefined(is2d))
		{
			player thread doSound( soundAlias, is2d );
			//println ("battlechatter - speaker playing 2d " + soundAlias);					
		}
		else
		{
			player thread doSound( soundAlias );
			//println ("battlechatter - speaker playing 3d " + soundAlias);				
		}	
	}
}

mpSayLocationalLocalSound( player, prefix, partOne, partTwo )
{
	player endon ( "death" );
	player endon ( "disconnect" );

	//Ensure there is more than one player in the game
	if( level.players.size <= 1 )
		return;

	if ( isSpeakerInRange( player ) )
		return;

// Removed Check CDC
//	if( player.leaderDialogActive )
//		return;
		
	if( player.team != "spectator" )
	{
		soundAlias1 = level.teamPrefix[player.team] + "_" + player.bcVoiceNumber + "_" + level.bcSounds[prefix];
		soundAlias2 = level.teamPrefix[player.team] + "_" + player.bcVoiceNumber + "_" + level.bcSounds[partOne] + "_" + partTwo;
		player thread doLocationalSound( soundAlias1, soundAlias2 );
	}
}


doSound( soundAlias, is2d  )
{
	team = self.team;
	level addSpeaker( self, team );

	
	if (isdefined(is2d))
	{
		self playLocalSound(soundAlias);
	}	
	else if ( level.allowBattleChatter && randomIntRange( 0, 100 ) >= level.bcGlobalProbability )
	{	
		self playSoundToTeam( soundAlias, team );
	}	
	
	self thread timeHack( soundAlias ); // workaround because soundalias notify isn't happening
	self waittill_any( soundAlias, "death", "disconnect" );
	level removeSpeaker( self, team );
}

doLocationalSound( soundAlias1, soundAlias2 )
{
	team = self.team;
	level addSpeaker( self, team );

	if( level.allowBattleChatter && randomIntRange( 0, 100 ) >= level.bcGlobalProbability )
	{
		self playBattleChatterToTeam( soundAlias1, soundAlias2, team, self );
	}
	self thread timeHack( soundAlias1 ); // workaround because soundalias notify isn't happening
	self waittill_any( soundAlias1, "death", "disconnect" );
	level removeSpeaker( self, team );
}


timeHack( soundAlias )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	wait ( 1.0 );
	self notify ( soundAlias );
}


isSpeakerInRange( player )
{
	player endon ( "death" );
	player endon ( "disconnect" );

	distSq = 1000 * 1000;

	// to prevent player switch to spectator after throwing a granade causing damage to someone and result in attacker.team = "spectator"
	if( isdefined( player ) && isdefined( player.team ) && player.team != "spectator" )
	{
		for ( index = 0; index < level.speakers[player.team].size; index++ )
		{
			teammate = level.speakers[player.team][index];
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

CheckDistanceToEvent( player, area )
{
	if ( !isDefined( player ) )
		return undefined;
		
	for ( index = 0; index < level.alivePlayers[player.team].size; index++ )
	{
		teammate = level.alivePlayers[player.team][index];

		if ( !isDefined( teammate ) )
			continue;
			
		if( teammate == player )
			continue;

		if ( DistanceSquared( teammate.origin, player.origin ) < area )
			return index;
	}
}

CheckDistanceToEnemy( enemy, area, team )
{
	if ( !isDefined( enemy ) )
		return undefined;
		
	for ( index = 0; index < level.alivePlayers[team].size; index++ )
	{
		player = level.alivePlayers[team][index];
		if ( DistanceSquared( enemy.origin, player.origin ) < area )
				return index;
	}
}

CheckDistanceToObject( area, object, team, ignoreEnt )
{
	if( isDefined( team ) )
	{
		for( i = 0; i < level.alivePlayers[team].size; i++ )
		{
			player = level.alivePlayers[team][i];

			if( isDefined(ignoreEnt) && player == ignoreEnt )
				continue;

			 if ( isDefined( object ) && distancesquared( player.origin, object.origin ) < area )
				 return player;
		}
	}
	else
	{
		for( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			
			if( isDefined(ignoreEnt) && player == ignoreEnt )
				continue;

			if( isAlive( player ) )
			{
				 if ( isDefined( object ) && distancesquared( player.origin, object.origin ) < area )
					 return player;
			}
		}
	}
}
get_closest_player_enemy()
{
  enemies = [];
  players = GET_PLAYERS();
  myteam = self.pers[ "team" ];

  for ( i = 0; i < players.size; i++ )
  {
	  player = players[i];
	
	  if ( !IsDefined( player ) || !IsAlive( player ) )
	  {
      continue;
	  }
	
	  if ( player.sessionstate != "playing" )
	  {
      continue;
	  }
	
	  if ( player == self )
	  {
      continue;
}
	
	  if ( level.teambased )
	  {
	    if ( myteam == player.team )
	    {
        continue;
	    }
	  }
	
	  enemies[ enemies.size ] = player;
  }

  if ( enemies.size <= 0 )
  {
		return undefined;
  }

  closest_enemy = getClosest( self.origin, enemies );
  return closest_enemy;
}
get_closest_player_ally()
{
  allies = [];
  players = GET_PLAYERS();
  myteam = self.pers[ "team" ];
	enemyTeam = getOtherTeam( myTeam );	  

  for ( i = 0; i < players.size; i++ )
  {
	  player = players[i];
	
	  if ( !IsDefined( player ) || !IsAlive( player ) )
	  {
      continue;
	  }
	
	  if ( player.sessionstate != "playing" )
	  {
      continue;
	  }
	
	  if ( player == self )
	  {
      continue;
}
	
	  if ( level.teambased )
	  {
	    if ( enemyTeam == player.team )
	    {
        continue;
	    }
	  }
	
	  allies[ allies.size ] = player;
  }

  if ( allies.size <= 0 )
  {
		return undefined;
  }

  closest_ally = getClosest( self.origin, allies );
  return closest_ally;
}