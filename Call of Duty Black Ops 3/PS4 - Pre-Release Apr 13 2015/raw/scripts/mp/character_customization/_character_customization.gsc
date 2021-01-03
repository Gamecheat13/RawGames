#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#using scripts\mp\gametypes\_globallogic;

#using scripts\mp\killstreaks\_killstreaks;

#namespace battlechatter;

function autoexec __init__sytem__() {     system::register("battlechatter",&__init__,undefined,undefined);    }










	
	// ALL + INTERRUPT
	// ALL + INTERRUPT + UNDERWATER
	

	




	
function __init__()
{
	callback::on_start_gametype( &init );

	level.heroPlayDialog = &play_dialog;
	level.playHeroweaponReady = &play_heroweapon_ready;
	level.playHeroabilityReady = &play_heroability_ready;
	level.playHeroabilitySuccess = &play_heroability_success;
}

function init()
{			
	level.bcSounds = [];
	level.bcSounds[ "incoming_alert" ] = [];
	level.bcSounds[ "incoming_alert" ][ "frag_grenade" ] = 74;
	level.bcSounds[ "incoming_alert" ][ "incendiary_grenade" ] = 76;
	level.bcSounds[ "incoming_alert" ][ "sticky_grenade" ] = 78;
	level.bcSounds[ "incoming_alert" ][ "launcher_standard" ] = 54;
	
	
	level.bcSounds[ "incoming_delay" ] = [];
	level.bcSounds[ "incoming_delay" ][ "incendiary_grenade" ] = 0.2;
	level.bcSounds[ "incoming_delay" ][ "launcher_standard" ] = 0.2;
	
	level.bcSounds[ "kill_dialog" ] = [];
	level.bcSounds[ "kill_dialog" ][ 0 ] = 86;
	level.bcSounds[ "kill_dialog" ][ 1 ] = 82;
	level.bcSounds[ "kill_dialog" ][ 2 ] = 87;
	level.bcSounds[ "kill_dialog" ][ 3 ] = 85;
	level.bcSounds[ "kill_dialog"][ 4 ] = 89;
	level.bcSounds[ "kill_dialog"][ 5 ] = 84;
	level.bcSounds[ "kill_dialog"][ 6 ] = 88;
	level.bcSounds[ "kill_dialog"][ 7 ] = 83;
	level.bcSounds[ "kill_dialog"][ 8 ] = 90;

	
	level.bcSounds[ "boost_response_dialog" ] = [];
	level.bcSounds[ "boost_response_dialog" ][ 0 ] = 34;
	level.bcSounds[ "boost_response_dialog" ][ 1 ] = 18;
	level.bcSounds[ "boost_response_dialog" ][ 2 ] = 38;
	level.bcSounds[ "boost_response_dialog" ][ 3 ] = 30;
	level.bcSounds[ "boost_response_dialog"][ 4 ] = 46;
	level.bcSounds[ "boost_response_dialog"][ 5 ] = 26;
	level.bcSounds[ "boost_response_dialog"][ 6 ] = 42;
	level.bcSounds[ "boost_response_dialog"][ 7 ] = 22;
	level.bcSounds[ "boost_response_dialog"][ 8 ] = 50;

	
	level.bcCommander = [];
	level.bcCommander["allies"] = "blops_commander";
	level.bcCommander["axis"] = "cdp_commander";
	
	level.bcTaacom = [];
	level.bcTaacom["allies"] = "blops_taacom";
	level.bcTaacom["axis"] = "cdp_taacom";
	
	SetDvar( "bcmp_enemy_contact_level_delay", "3"); // 15

	level.allowbattlechatter["bc"] = GetGametypeSetting( "allowBattleChatter" );

	level.enemyContactOk = true;

	level thread enemy_contact_level_delay();
	
	callback::on_joined_team( &on_joined_team );
	callback::on_spawned( &on_player_spawned);
	
	level thread update_bc_dvars();
	
	level.battlechatter_init = true;
	
	//enable battle chatter for debug purposes.
	level.allowbattlechatter["bc"] = true;
}

function update_bc_dvars()
{
/#
	dev_update = true;
#/
	
	level endon( "game_ended" );
	for(;;)
	{	
		level.bcPainSmallProbability = GetDvarint( "bcmp_pain_small_probability", 100 );
		level.bcBreathingProbability = GetDvarint( "bcmp_breathing_probability", 100 );
		level.bcBreathingDelay = GetDvarInt ( "bcmp_breathing_delay", 0 );
		
		level.bcIncomingGrenadeProbability = GetDvarint( "bcmp_incoming_grenade_probability", 100 );
		level.bcIncomingGrenadeRadiusSq = GetDvarint( "bcmp_incoming_grenade_radius", 500 );
		level.bcIncomingGrenadeRadiusSq *= level.bcIncomingGrenadeRadiusSq;
		
		level.bcHeroWeaponKillCountSuccess = GetDvarint( "bcmp_hero_weapon_kill_count_success", 2 );
		
		level.bcSniperKillProbability = GetDvarint ( "bcmp_sniper_kill_probability", 100 );
		level.bcSniperKillRadiusSq = GetDvarint( "bcmp_sniper_kill_radius", 1000 );
		level.bcSniperKillRadiusSq *= level.bcSniperKillRadiusSq;
		
		level.bcAllyKillProbability = GetDvarint ( "bcmp_ally_kill_probability", 100 );
		level.bcAllyKillRadiusSq = GetDvarint( "bcmp_ally_kill_radius", 500 );
		level.bcAllyKillRadiusSq *= level.bcAllyKillRadiusSq;
		
		level.bcEnemyKillProbability = GetDvarint( "bcmp_enemy_kill_probability", 100 );
		level.bcEnemyKillHeroProbability = GetDvarint( "bcmp_enemy_kill_hero_probability", 25 );

		level.bcKillDelay = GetDvarfloat( "bcmp_kill_delay", 0.8 );
		
		level.bcKillInformProbability = GetDvarint( "bcmp_kill_inform_probability", 100 );
		
		level.bcSpeedburstKillDistSq = GetDvarint( "bcmp_speedburst_kill_dist", 400 );
		level.bcSpeedburstKillDistSq *= level.bcSpeedburstKillDistSq;
		
		level.bcEnemyContactProbability = GetDvarint( "bcmp_enemy_contact_probability", 100 );
		level.bcEnemyContactDistance = GetDvarint( "bcmp_enemy_contact_distance", 2000 );
		level.bcEnemyContactRadiusSq = GetDvarint( "bcmp_enemy_contact_radius", 500 );
		level.bcEnemyContactRadiusSq *= level.bcEnemyContactRadiusSq;
		level.bcEnemyContactDelay = GetDvarint( "bcmp_enemy_contact_delay", 5 ); // 30
		
		level.bcLastStandDelay = GetDvarfloat( "bcmp_last_stand_delay", 3 );
		
		level thread globallogic::updateTeamStatus();
		
		if ( !isdefined( dev_update ) )
		{
			return;
		}
		
		wait( 2.0 );
	}
}

function bc_chance( bc_probability )
{
	if ( !isdefined( level.battlechatter_init) )
		return false;
	else if ( bc_probability >= 100 )
		return true;
	else if ( bc_probability <= 0 )
		return false;
	else
		return ( RandomInt(100 ) < bc_probability );
}

//TODO T7 - add this into the callback system if it's actually needed
function on_joined_spectators()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "joined_spectators" );
	}
}

function on_joined_team()
{
	self endon( "disconnect" );
	
	if ( level.teambased )
	{
		if ( self.team == "allies" )
		{
			self set_blops_dialog();
		}
		else
		{
			self set_cdp_dialog();
		}
	}
	else
	{
		if ( randomIntRange( 0, 2 ) )
		{
			self set_blops_dialog();
		}
		else
		{
			self set_cdp_dialog();
		}
	}
}

function set_blops_dialog()
{
	self.pers["mptaacom"] = "blops_taacom";
	self.pers["mpcommander"] = "blops_commander";
}

function set_cdp_dialog()
{
	self.pers["mptaacom"] = "cdp_taacom";
	self.pers["mpcommander"] = "cdp_commander";
}
function on_player_spawned()
{
	self endon( "disconnect" );
	
	self.lastBCAttemptTime = 0;
	self.heartbeatsnd = false; 
	
	self.soundMod = "player";
	self.voxShouldGasp = 0;
	self.voxShouldGaspLoop = 1;
	
	self.pilotisSpeaking = false;
	self.playingDialog = false;
	
	// help players be stealthy in splitscreen by not announcing their intentions
	if ( level.splitscreen )
	{
		return;
	}

	self thread pain_vox();
//	self thread breathing_hurt_vox();
//	self thread breathing_better_vox();
//	self thread on_fire_scream();
//	self thread water_gasp();	
	
//	self thread vocal_grunt();
	
	self thread grenade_tracking();
	self thread missile_tracking();
	self thread sticky_grenade_tracking();
	
	self thread enemy_threat();
	
	//self thread ally_revive();
	//self thread last_stand_vox();
}

function enemy_contact_level_delay()
{
	while (1)
	{
		level waittill ( "level_enemy_spotted");
		level.enemyContactOk = false;
		wait ( GetDvarint( "bcmp_enemy_contact_level_delay" ) );
		level.enemyContactOk = true;
	}	
}


function breathing_hurt_vox()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	
	// TODO finish notifies and expland to DTP, Cough etc
	for( ;; )
	{
		self waittill ( "snd_breathing_hurt" );		
		//make sure he is still alive
		if( bc_chance( level.bcBreathingProbability ) )
		{	  		
			wait (.5);
			if ( IsAlive( self ) )
			{
				self play_dialog( 2, undefined, 1 );
			}	
		}
		wait ( level.bcBreathingDelay );
	}	
}

function vocal_grunt()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	
	// TODO finish notifies and expland to DTP, Cough etc
	for( ;; )
	{
		self waittill ( "snd_vox_grunt" );
		//self waittill ( "traversesound" );	
		//make sure he is still alive
		if( bc_chance( level.bcBreathingProbability ) )
		{	  		
			wait (.5);
			if ( IsAlive( self ) )
			{
				self play_dialog( 2, undefined, 1 );
			}
		}
		wait ( level.bcBreathingDelay );
	}	
}


function on_fire_scream()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	// TODO finish notifies and expland to DTP, Cough etc
	for( ;; )
	{
		self waittill ( "snd_burn_scream" );		
		//make sure he is still alive
		if( bc_chance( level.bcBreathingProbability ) )
		{	  		
			wait (.5);
			if ( IsAlive( self ) )
			{
				self play_dialog( 129, 6 );
			}
		}
		wait ( level.bcBreathingDelay );	
	}	
}

function breathing_better_vox()
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
		{
			self play_dialog( 1, undefined, 1 );
		}
		
		wait ( level.bcLastStandDelay );	
	}	
}	

function last_stand_vox()
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
		{
			//soundAlias = self GetMpDialogPlayer( MPD_PLAYER_ );
			//self thread do_sound( soundAlias, false, true );
			//level thread mp_say_socal_sound( self, "perk", "laststand" );
		}
		
		wait ( level.bcLastStandDelay );	
	}	
}

function ally_revive()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	for( ;; )
	{
		// wait for revive
		self waittill ( "snd_ally_revive" );

		if ( IsAlive( self ) )
		{
			// TODO: Temp Event
			self play_dialog( 6 );
			//soundAlias = self GetMpDialogPlayer( MPD_PLAYER_ );
			//self thread do_sound( soundAlias, false, true );
			//level thread mp_say_socal_sound( self, "inform_attack", "revive" );
		}
		
		wait ( level.bcLastStandDelay );	
	}	
}
function water_gasp()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "snd_gasp" );	
	level endon ( "game_ended" );

	self.voxShouldGaspLoop = 0;
			
	while (1)
	{
//		if ( self IsPlayerUnderwater() && !self.voxShouldGasp)
//		{
//			wait (.5);
//			
//			if (self IsPlayerUnderwater())
//			{
//				self.voxShouldGasp = 1;
//			}
//			
//		}
		if ( !self IsPlayerUnderwater() && self.voxShouldGasp)
		{
			self.voxShouldGasp = 0;
			self.voxShouldGaspLoop = 1;
			self play_dialog( 6 );
			self notify ( "snd_gasp" );
			
		}
		wait (.5);
	}
}
function pain_vox()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	for( ;; )
	{
		// wait for pain
		self waittill ( "snd_pain_player", meansOfDeath );

		if( bc_chance( level.bcPainSmallProbability ) )
		{
			if ( IsAlive( self ) )
			{	
				if( meansOfDeath == "MOD_DROWN" )
				{
					self.voxShouldGasp = 1;
					if (self.voxShouldGaspLoop)
					{
						self thread water_gasp();
					}
					self play_dialog( 127, 14, 1 );				
				}
				else
				{
					self play_dialog( 7, 14, 1 );
				}
			}
		}
		
		wait (.5);	
	}
}

function play_death_vox( body, attacker, meansOfDeath )
{
	if( meansOfDeath === "MOD_DROWN" )
	{
		dialogIndex = 127;
	}
	else
	{
		dialogIndex = 3;
	}
	
	soundId = self GetMpDialogPlayer( dialogIndex );
	
	if ( isdefined( soundId ) )
	{
		body PlaySoundOnTag( soundId, "J_Head" );
	}
}

function on_player_suicide_or_team_kill( player, type )
{
	self endon ("disconnect");
	
	// make sure that this does not execute in the player killed callback time
	waittillframeend;

	if( !isdefined(level.battlechatter_init) )
	{
		return;
	}

	if( !level.teamBased )
	{
		return;
	}
}

function on_player_killstreak( player )
{
	player endon ("disconnect");

	// make sure that this does not execute in the player killed callback time
	waittillframeend;	
		
	if( bc_chance ( level.bcKillInformProbability ) )
	{
		if( player.pers["cur_kill_streak"] >= 15 )
		{
 			//Hell yeah
			//level thread mp_say_socal_sound( player, "killstreak_taunt", "fifteen" );
		}
		else if( player.pers["cur_kill_streak"] >= 10 )
		{
			//Keep pushing
			//level thread mp_say_socal_sound( player, "killstreak_taunt", "ten" );
		}
		else if( player.pers["cur_kill_streak"] >= 5 )
		{
			//They are taking a beating
			//level thread mp_say_socal_sound( player, "killstreak_taunt", "five" );
		}
	}
	
}

// Only called by dogs for now
function on_killstreak_used( killstreak, team )
{
	level endon( "game_ended" );
}

function on_player_near_explodable( object,  type )
{
	player = get_closest_player( object );
	
	player = check_distance_to_object( 500 * 500, object );
	if( isdefined( player ) )
	{
		wait (randomfloatrange (.1, .4));
		// TODO: type -> explodable index
	}
	wait( 0.5 );
}

function enemy_threat()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	// Don't bother in non-team games
	if ( !level.teambased )
	{
		return;
	}
	
	for( ;; )
	{
		self waittill ( "weapon_ads" );
		
		if ( !level.enemyContactOk )		
		{
			continue;
		}
		
		if ( self HasPerk( "specialty_quieter" ) )
		{
			continue;
		}
		
		if( self.lastBCAttemptTime + level.bcEnemyContactDelay >= getTime() )
		{
			continue;
		}
		
		closest_ally = self get_closest_player_ally( true );
				
		if ( !isdefined ( closest_ally ) )
		{
			continue;
		}
		
		if ( DistanceSquared( self.origin, closest_ally.origin ) < level.bcEnemyContactRadiusSq )
		{
			eyePoint = self getEye();
			dir = AnglesToForward( self.angles );
			
			dir = dir * level.bcEnemyContactDistance;
			
			endPoint = eyePoint + dir;
			
			traceResult = BulletTrace( eyePoint, endPoint, true, self );
			
			if ( isdefined( traceResult["entity"] ) && traceResult["entity"].className == "player" && traceResult["entity"].team != self.team )
			{
				self.lastBCAttemptTime = getTime();
			
				if( bc_chance( level.bcEnemyContactProbability ) )
				{		
					self play_dialog( 55, 1 );
					
					level notify ( "level_enemy_spotted");
				}	
			}
		}
	}
}	


// self is killed
function killed_by_sniper( sniper )
{
	self endon("disconnect");
	sniper endon("disconnect");
	level endon( "game_ended" );
	
	if ( level.hardcoreMode || !level.teamBased )
	{
		return false;
	}
	
	// make sure that this does not execute in the player killed callback time
	waittillframeend;
	
	if( bc_chance( level.bcSniperKillProbability ) )
	{
		closest_ally = self get_closest_player_ally();	
	
		if( isdefined( closest_ally ) && DistanceSquared( self.origin, closest_ally.origin ) < level.bcSniperKillRadiusSq )
		{
			sniper.isSniperSpotted = true;
			closest_ally play_dialog( 56, 1 );
		}
	}
}

// self is killed
function player_killed( attacker )
{
	return;
	
	self endon("disconnect");
	level endon( "game_ended" );
	
	if ( !isplayer (attacker) )
	{
		return;
	}

	if ( level.hardcoreMode || !level.teamBased )
	{
		return false;
	}
	
	// make sure that this does not execute in the player killed callback time
	waittillframeend;
	
	if( bc_chance( level.bcAllyKillProbability ) )
	{
		closest_ally = self get_closest_player_ally();	
	
		if( isdefined( closest_ally ) && DistanceSquared( self.origin, closest_ally.origin ) < level.bcAllyKillRadiusSq )
		{
			// TODO: Some other kind of audio, having to do with a revive?
			closest_ally play_dialog( 55 );
		}
	}
}

function say_kill_battle_chatter( attacker, weapon, victim )
{
	if ( weapon.skipBattlechatterKill )
	{
		return;
	}
	
	if ( weapon.inventorytype == "hero" )
	{
		attacker.heroweaponKillCount += 1;
		
		if ( attacker.heroweaponKillCount == level.bcHeroWeaponKillCountSuccess )
		{
			killDialog = 64;
		}
	}
	else if ( isdefined(attacker.speedburstOn ) && attacker.speedburstOn && !attacker.speedburstDialogSuccess )
	{
		if ( DistanceSquared( attacker.origin, victim.origin ) < level.bcSpeedburstKillDistSq )
		{
			killDialog = 62;
			attacker.speedburstDialogSuccess = true;
		}
	}
	else if ( bc_chance( level.bcEnemyKillProbability ) )
	{	
		if ( bc_chance( level.bcEnemyKillHeroProbability ) )
		{
			bodyType = victim GetCharacterBodyType();
			killDialog = level.bcSounds[ "kill_dialog" ][ bodyType ];
		}
		else
		{
			killDialog = 80;
		}
	}

	if ( !isdefined( killDialog ) )
	{
		return;
	}

	attacker thread wait_play_dialog( level.bcKillDelay, killDialog, 1, undefined, victim );
}


function grenade_tracking()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	for( ;; )
	{
		self waittill ( "grenade_fire", grenade, weapon );

		if ( !isdefined( grenade.weapon ) || !isdefined( grenade.weapon.rootweapon ) )
			continue;
		
		if( !bc_chance( level.bcIncomingGrenadeProbability ) )
			continue;
		
		dialogIndex = level.bcSounds[ "incoming_alert" ][ grenade.weapon.rootweapon.name ];
		waittime = level.bcSounds[ "incoming_delay" ][ grenade.weapon.rootweapon.name ];
		
		if ( isdefined( dialogIndex ) )
		{
			level thread incoming_projectile_alert( self, grenade, dialogIndex, waittime );
		}
	}
}

function missile_tracking()
{
	self endon( "death" );
	level endon( "game_ended" );

	for ( ;; )
	{	
		self waittill ( "missile_fire", missile, weapon );
		
		if ( !isdefined( missile.item ) || !isdefined( missile.item.rootweapon ) )
			continue;
		
		if( !bc_chance( level.bcIncomingGrenadeProbability ) )
			continue;
		
		dialogIndex = level.bcSounds[ "incoming_alert" ][ missile.item.rootweapon.name ];
		waittime = level.bcSounds[ "incoming_delay" ][ missile.item.rootweapon.name ];
		
		if ( isdefined ( dialogIndex ) )
		{
			level thread incoming_projectile_alert( self, missile, dialogIndex, waittime );	
		}
	}
}

function incoming_projectile_alert( thrower, projectile, dialogIndex, waittime )
{	
	level endon( "game_ended" );
	
	if ( !isdefined( waittime ) )
	{
		waittime = 1.0;
	}
	
	for ( ;; )
	{
		wait( waittime );
		
		// HACK: This is a crazy way to try and trigger the warning more often
		if ( waittime > 0.2 )
		{
			waittime = waittime / 2;
		}
		
		// The projectile may have blown up or the like while waiting
		if ( !isdefined( projectile ) )
		{
			return;
		}
		
		//Check if player threw grenade and then quit or switched to spectator
		if( !isdefined( thrower ) || thrower.team == "spectator" )
		{
			return;
		}
	
		if( ( level.players.size ) )			
		{
			closest_enemy = projectile get_closest_player_enemy();
	
			if( isdefined( closest_enemy ) && DistanceSquared( projectile.origin, closest_enemy.origin ) < level.bcIncomingGrenadeRadiusSq )
			{		
				closest_enemy play_dialog( dialogIndex, 6 );
				return;
			}
		}
	}
}

function sticky_grenade_tracking()
{
	self endon( "death" );
	level endon( "game_ended" );

	for( ;; )
	{
		self waittill ( "grenade_stuck", grenade );

		if ( isdefined( grenade ) )
		{
			grenade.stuckToPlayer = self;
		}

		if ( IsAlive( self ) )
		{
			self play_dialog( 130, 6 );
		}
	}
}

function gametype_specific_battle_chatter( event, team )
{

	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "event_ended" );

	for(;;)
	{
		if( isdefined( team ) )
		{
			index = check_distance_to_event( self, 300 * 300 );
			if( isdefined( index ) )
			{
				//level thread mp_say_socal_sound( level.alivePlayers[team][index], "gametype", event );
				self notify( "event_ended" );
			}
		}
		else
		{
			foreach ( team in level.teams )
			{
				//index = randomIntRange( 0, level.alivePlayers[team].size );
				//level thread mp_say_socal_sound( level.alivePlayers[team][index], "gametype", event );
			}
		}

		wait( 1.0 );
	}
}

function wait_play_dialog( waitTime, dialogIndex, dialogFlags, dialogBuffer, enemy )
{
	self endon( "death" );
	level endon( "game_ended" );
	
	wait ( waitTime );
	
	if ( !self.playingDialog )
	{
		self play_dialog( dialogIndex, dialogFlags, dialogBuffer, enemy );
	}
}

function play_dialog( dialogIndex, dialogFlags, dialogBuffer, enemy )
{
	if ( !isdefined( dialogIndex ) )
	{
		return;
	}
	
	if ( !isdefined( dialogFlags ) )
	{
		dialogFlags = 0;
	}
	
	if ( !isdefined( dialogBuffer ) )
	{
		dialogBuffer = 3.5;
	}
	
	soundId = self GetMpDialogPlayer( dialogIndex );

 	if ( !isdefined( soundId ) )
 	{
 		return;
 	}

 	if ( self IsPlayerUnderwater() && !( dialogFlags & 8 ) )
	{
		return;
	}
	
	if ( self.playingDialog )
	{
		if ( dialogFlags & 4 )
		{
			self StopSounds();
		}
		else
		{
			return;
		}
	}

	if ( dialogFlags & 2 )
	{
		// Plays to all teams
		self PlaySoundOnTag( soundId, "J_Head" );	
	}
	else if ( dialogFlags & 1 )
	{
		// Plays to current team
		if ( isdefined( enemy ) )
		{
			// And the specified enemy
			self PlaySoundOnTag( soundId, "J_Head", self.team, enemy );
		}
		else
		{
			self PlaySoundOnTag( soundId, "J_Head", self.team );
		}
	}
	else
	{
		self PlayLocalSound( soundId );
	}
	
	self.playingDialog = true;
	self thread wait_dialog_buffer( dialogBuffer );
}

function wait_dialog_buffer( dialogBuffer )
{
	self endon( "death" );
	level endon( "game_ended" );
	
	wait ( dialogBuffer );
	
	self.playingDialog = false;
}

function wait_playback_time( soundAlias )
{
	self endon( "death" );
	level endon( "game_ended" );
}
	

// These are called from shared scripts via function pointers
function play_heroweapon_ready()
{
	self play_dialog( 63 );
}

function play_heroability_ready()
{
	self play_dialog( 61 );
}

function play_heroability_success( waitTime )
{
	if ( isdefined( waitTime ) )
	{
		self thread wait_play_dialog( waitTime, 62, 2 );
	}
	else
	{
		self play_dialog( 62, 2 );
	}
}

function check_distance_to_event( player, area )
{
	if ( !isdefined( player ) )
	{
		return undefined;
	}
		
	for ( index = 0; index < level.alivePlayers[player.team].size; index++ )
	{
		teammate = level.alivePlayers[player.team][index];

		if ( !isdefined( teammate ) )
		{
			continue;
		}
			
		if( teammate == player )
		{
			continue;
		}

		if ( DistanceSquared( teammate.origin, player.origin ) < area )
		{
			return index;
		}
	}
}

function check_distance_to_enemy( enemy, area, team )
{
	if ( !isdefined( enemy ) )
	{
		return undefined;
	}
		
	for ( index = 0; index < level.alivePlayers[team].size; index++ )
	{
		player = level.alivePlayers[team][index];
		if ( DistanceSquared( enemy.origin, player.origin ) < area )
		{
				return index;
		}
	}
}

function check_distance_to_object( area, object, ignoreteam, ignoreEnt )
{
	if( isdefined( ignoreteam ) )
	{
		foreach( team in level.teams )
		{
			for( i = 0; i < level.alivePlayers[team].size; i++ )
			{
				player = level.alivePlayers[team][i];
	
				if( isdefined(ignoreEnt) && player == ignoreEnt )
				{
					continue;
				}
	
				 if ( isdefined( object ) && distancesquared( player.origin, object.origin ) < area )
				 {
					 return player;
				 }
			}
		}
	}
	else
	{
		for( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			
			if( isdefined(ignoreEnt) && player == ignoreEnt )
			{
				continue;
			}

			if( isAlive( player ) )
			{
				 if ( isdefined( object ) && distancesquared( player.origin, object.origin ) < area )
				 {
					 return player;
				 }
			}
		}
	}
}

function get_closest_player_enemy( teamOnly )
{
	players = GetPlayers();
	players = ArraySort( players, self.origin );

	foreach( player in players )
	{
		if ( !isdefined( player ) || !IsAlive( player ) )
		{
			continue;
		}

		if ( player.sessionstate != "playing" )
		{
			continue;
		}

		if ( player.playingDialog )
		{
			continue;
		}
		
		if ( player == self )
		{
			continue;
		}

		if ( level.teambased && self.team == player.team )
		{
			continue;
		}

		if ( player IsPlayerUnderwater() )
		{
			continue;
		}
		
		if ( !isdefined( teamOnly) || !teamOnly )
		{
			if ( player HasPerk( "specialty_quieter" ) )
			{
				continue;
			}
		}
		
		return player;
	}

	return undefined;
}

function get_closest_player_ally( teamOnly )
{
	if ( !level.teambased )
	{
		return undefined;
	}

	players = GetPlayers( self.team );
	players = ArraySort( players, self.origin );

	foreach( player in players )
	{
		if ( !isdefined( player ) || !IsAlive( player ) )
		{
			continue;
		}

		if ( player.sessionstate != "playing" )
		{
			continue;
		}

		if ( player.playingDialog )
		{
			continue;
		}
		
		if ( player == self )
		{
			continue;
		}

		if ( player IsPlayerUnderwater() )
		{
			continue;
		}
		
		if ( !isdefined( teamOnly) || !teamOnly )
		{
			if ( player HasPerk( "specialty_quieter" ) )
			{
				continue;
			}
		}
		
		return player;
	}

	return undefined;
}

function get_closest_player( object )
{

	if ( !isdefined( object ))
	{
		object = self;    	
	}
	
	players = GetPlayers();
	players = ArraySort( players, object.origin );

	foreach( player in players )
	{
		if ( !isdefined( player ) || !IsAlive( player ) )
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

		return player;
	}

	return undefined;
}
