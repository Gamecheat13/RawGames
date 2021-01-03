    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\mp\gametypes\_dev;

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;

#using scripts\mp\killstreaks\_killstreaks;

#namespace battlechatter;

function autoexec __init__sytem__() {     system::register("battlechatter",&__init__,undefined,undefined);    }









	// Plays when VO is turned off
	
	// ALL + INTERRUPT
	// ALL + INTERRUPT + UNDERWATER + EXERT
	






	
function __init__()
{
	callback::on_joined_team( &on_joined_team );
	callback::on_spawned( &on_player_spawned);
	
	level.heroPlayDialog = &play_dialog;
	level.playHeroweaponReady = &play_heroweapon_ready;
	level.playHeroweaponActivate = &play_heroweapon_activate;
	level.playHeroabilityReady = &play_heroability_ready;
	level.playHeroabilityActivate = &play_heroability_activate;
	level.playHeroabilitySuccess = &play_heroability_success;
	level.playPromotionReaction = &play_promotion_reaction;
	level.playThrowHatchet = &play_throw_hatchet;
		
	level.bcSounds = [];
	level.bcSounds[ "incoming_alert" ] = [];
	level.bcSounds[ "incoming_alert" ][ "frag_grenade" ] = "incomingFrag";
	level.bcSounds[ "incoming_alert" ][ "incendiary_grenade" ] = "incomingIncendiary";
	level.bcSounds[ "incoming_alert" ][ "sticky_grenade" ] = "incomingSemtex";
	level.bcSounds[ "incoming_alert" ][ "launcher_standard" ] = "threatRpg";
	
	
	level.bcSounds[ "incoming_delay" ] = [];
	level.bcSounds[ "incoming_delay" ][ "frag_grenade" ] = "fragGrenadeDelay";
	level.bcSounds[ "incoming_delay" ][ "incendiary_grenade" ] = "incendiaryGrenadeDelay";
	level.bcSounds[ "incoming_alert" ][ "sticky_grenade" ] = "semtexDelay";
	level.bcSounds[ "incoming_delay" ][ "launcher_standard" ] = "missileDelay";
	
	level.bcSounds[ "kill_dialog" ] = [];
	level.bcSounds[ "kill_dialog" ][ "assassin" ] =	"killSpectre";
	level.bcSounds[ "kill_dialog" ][ "grenadier" ] =	"killGrenadier";
	level.bcSounds[ "kill_dialog" ][ "outrider" ] = 	"killOutrider";
	level.bcSounds[ "kill_dialog" ][ "prophet" ] = 	"killTechnomancer";
	level.bcSounds[ "kill_dialog" ][ "pyro" ] = 		"killFirebreak";
	level.bcSounds[ "kill_dialog" ][ "reaper" ] = 	"killReaper";
	level.bcSounds[ "kill_dialog" ][ "ruin" ] =		"killMercenary";
	level.bcSounds[ "kill_dialog" ][ "seraph" ] = 	"killEnforcer";
	level.bcSounds[ "kill_dialog" ][ "trapper" ] = 	"killTrapper";
	
	if ( level.teambased && !isdefined( game["boostPlayersPicked"] ) )
	{
		game["boostPlayersPicked"] = [];
		foreach ( team in level.teams )
		{
			game["boostPlayersPicked"][ team ] = false;
		}
	}
	
	level.allowbattlechatter["bc"] = GetGametypeSetting( "allowBattleChatter" );
		
/#
	//enable battle chatter for debug purposes.
	level.allowbattlechatter["bc"] = true;
#/
		
	clientfield::register( "world", "boost_number", 1, 2, "int" );
	clientfield::register( "allplayers", "play_boost", 1, 2, "int" );	
	
	level thread pick_boost_number();
	
	playerDialogBundles = struct::get_script_bundles( "mpdialog_player" );
	foreach( bundle in playerDialogBundles )
	{
		count_keys( bundle, "killGeneric" );
		count_keys( bundle, "killSniper" );
		count_keys( bundle, "heroWeaponSuccess" );
		count_keys( bundle, "heroAbilitySuccess" );
		
		count_keys( bundle, "killSpectre" );
		count_keys( bundle, "killGrenadier");
		count_keys( bundle, "killOutrider" );
		count_keys( bundle, "killTechnomancer" );
		count_keys( bundle, "killFirebreak" );
		count_keys( bundle, "killReaper" );
		count_keys( bundle, "killMercenary" );
		count_keys( bundle, "killEnforcer" );
		count_keys( bundle, "killTrapper" );
	}
		
	add_taunt( "tauntBoast", &switch_pressed );
	add_taunt( "tauntGeneric", &jump_pressed );
	add_taunt( "tauntGoodGame", &stance_pressed );
	add_taunt( "tauntThreaten", &reload_pressed );
	
 	SetDvar( "mpdialog_heroes", 		mpdialog_value( "enableHeroDialog", 	0 ) );
	SetDvar( "mpdialog_conversation",	mpdialog_value( "enableConversation",	0 ) );
    SetDvar( "mpdialog_endtaunt",		mpdialog_value( "enableEndTaunt", 		0 ) );
}

function pick_boost_number( )
{
	// Don't set client fields on the first frame
	wait( 5 );
	
	level clientfield::set( "boost_number", RandomInt( 4 ) );
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
	
	if ( level.disablePrematchMessages === true || self.pers["startGamePlayed"] === true )
	{
		return;
	}
	
	if ( self.pers["playedGameMode"] !== true && isdefined( level.leaderDialog ) && level.inPrematchPeriod !== false )
	{
		if( level.hardcoreMode )
			self globallogic_audio::leader_dialog_on_player( level.leaderDialog.startHcGameDialog );
		else
			self globallogic_audio::leader_dialog_on_player( level.leaderDialog.startGameDialog );
		
		self.pers["playedGameMode"] = true;
	}
	
	self.pers["startGamePlayed"] = true;
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
	self.enemyThreatTime = 0;
	self.heartbeatsnd = false; 
	
	self.soundMod = "player";
	
	self.voxUnderwaterTime = 0;
	self.voxEmergeBreath = false;
	self.voxDrowning = false;
	
	self.pilotisSpeaking = false;
	self.playingDialog = false;
	
	self.playedAbilitySuccessDialog = false;
	
	// help players be stealthy in splitscreen by not announcing their intentions
	if ( level.splitscreen )
	{
		return;
	}
	
	self thread water_vox();
	
	self thread grenade_tracking();
	self thread missile_tracking();
	self thread sticky_grenade_tracking();
	
	// Don't bother with these in non-team games
	if ( level.teambased )
	{
		self thread enemy_threat();
		self thread check_boost_start_conversation();		
	}
}

function dialog_chance( chanceKey )
{
	dialogChance = mpdialog_value( chanceKey );
	
	if ( !isdefined( dialogChance ) || dialogChance <= 0 )
	{
		return false;	
	}
	else if ( dialogChance >= 100 )
	{
		return true;
	}
	
	return ( RandomInt( 100 ) < dialogChance );
}

function mpdialog_value( mpdialogKey, defaultValue )
{
	if ( !isdefined( mpdialogKey ) )
	{
		return defaultValue;	
	}
	
	mpdialog = struct::get_script_bundle( "mpdialog", "mpdialog_default" );
	
	if ( !isdefined( mpdialog ) )
	{
		return defaultValue;
	}
	
	structValue = GetStructField( mpdialog, mpdialogKey );
	
	if ( !isdefined( structValue ) )
	{
		return defaultValue;
	}
	
	return structValue;
}

function water_vox()
{
	self endon ( "death" );
	level endon ( "game_ended" );

	while(1)
	{		
		interval = mpdialog_value( "underwaterInterval", .05 );
		
		if ( interval <= 0 )
		{
			assert( interval > 0, "underWaterInterval mpdialog scriptbundle value must be greater than 0" );
			return;
		}
		
		wait ( interval );
		
		if ( self IsPlayerUnderwater() )
		{
			if ( !self.voxUnderwaterTime && !self.voxEmergeBreath )
			{
				self StopSounds();
				self.voxUnderwaterTime = GetTime();
			}
			else if ( self.voxUnderwaterTime )
			{
				if ( GetTime() > self.voxUnderwaterTime + mpdialog_value( "underwaterBreathTime", 0 ) * 1000 )
				{
					self.voxUnderwaterTime = 0;
					self.voxEmergeBreath = true;				
				}
			}
		}
		else
		{
			if ( self.voxDrowning )
			{
				self thread play_dialog( "exertEmergeGasp", 4 | 16, mpdialog_value( "playerExertBuffer", 0 ) );
				
				self.voxDrowning = false;
				self.voxEmergeBreath = false;
			}
			else if ( self.voxEmergeBreath )
			{
				self thread play_dialog( "exertEmergeBreath", 4 | 16, mpdialog_value( "playerExertBuffer", 0 ) );
				self.voxEmergeBreath = false;
			}
		}
	}
}


function pain_vox(meansofDeath)
{
	if( dialog_chance( "smallPainChance" ) )
	{			
		if( meansOfDeath == "MOD_DROWN" )
		{
			dialogKey =  "exertPainDrowning";
			self.voxDrowning = true;					
		}
		else if ( meansofDeath == "MOD_FALLING" )
		{
			dialogKey = "exertPainFalling";
		}
		else if ( self IsPlayerUnderwater() )
		{
			dialogKey = "exertPainUnderwater";
		}
		else
		{
			dialogKey =  "exertPain";
		}
		
		exertBuffer = mpdialog_value( "playerExertBuffer", 0 );
		self thread play_dialog( dialogKey, 30, exertBuffer );
	}
}

function on_player_suicide_or_team_kill( player, type )
{
	self endon( "death" );
	level endon( "game_ended" );
	
	// make sure that this does not execute in the player killed callback time
	waittillframeend;

	if( !level.teamBased )
	{
		return;
	}
}

function on_player_near_explodable( object,  type )
{
	self endon( "death" );
	level endon( "game_ended" );
}

function enemy_threat()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	while(1)
	{
		self waittill ( "weapon_ads" );
		
		if ( self HasPerk( "specialty_quieter" ) )
		{
			continue;
		}
		
		if( self.enemyThreatTime + ( mpdialog_value( "enemyContactInterval", 0 ) * 1000 )  >= getTime() )
		{
			continue;
		}
		
		closest_ally = self get_closest_player_ally( true );
				
		if ( !isdefined ( closest_ally ) )
		{
			continue;
		}
		
		allyRadius = mpdialog_value( "enemyContactAllyRadius", 0 );
		
		if ( DistanceSquared( self.origin, closest_ally.origin ) < allyRadius * allyRadius )
		{
			eyePoint = self getEye();
			dir = AnglesToForward( self GetPlayerAngles() );
			
			dir = dir * mpdialog_value( "enemyContactDistance", 0 );
			
			endPoint = eyePoint + dir;
			
			traceResult = BulletTrace( eyePoint, endPoint, true, self );
			
			if ( isdefined( traceResult["entity"] ) && traceResult["entity"].className == "player" && traceResult["entity"].team != self.team )
			{
				if( dialog_chance( "enemyContactChance" ) )
				{		
					self thread play_dialog( "threatInfantry", 1 );
					
					level notify ( "level_enemy_spotted", self.team);
					
					self.enemyThreatTime = GetTime();
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
	
	if( dialog_chance( "sniperKillChance" ) )
	{
		closest_ally = self get_closest_player_ally();	
	
		allyRadius = mpdialog_value( "sniperKillAllyRadius", 0 );
		
		if( isdefined( closest_ally ) && DistanceSquared( self.origin, closest_ally.origin ) < allyRadius * allyRadius )
		{
			closest_ally thread play_dialog( "threatSniper", 1 );
			
			sniper.spottedTime = GetTime();
			sniper.spottedBy = [];
			
			players = self get_friendly_players();
			players = ArraySort( players, self.origin );
		
			voiceRadius = mpdialog_value( "playerVoiceRadius", 0 );
			voiceRadiusSq = voiceRadius * voiceRadius;
			
			foreach( player in players )
			{
				if ( DistanceSquared( closest_ally.origin, player.origin) <= voiceRadiusSq )
				{
					sniper.spottedBy[sniper.spottedBy.size] = player;
				}
			}
		}
	}
}

// self is killed
function player_killed( attacker, killstreakType )
{
	if ( level.hardcoreMode || !level.teamBased )
	{
		return false;
	}
	
	// make sure that this does not execute in the player killed callback time
	waittillframeend;
	
	if( isdefined( killstreakType ) )
	{
		if ( !isdefined( level.killstreaks[killstreakType] ) || 
		    !isdefined( level.killstreaks[killstreakType].threatOnKill ) ||
			!level.killstreaks[killstreakType].threatOnKill ||
		    !dialog_chance( "killstreakKillChance" ) )
		{
			return;
		}
		
		ally = battlechatter::get_closest_player_ally( true );
		allyRadius = mpdialog_value( "killstreakKillAllyRadius", 0 );
		
		if ( isdefined( ally ) && DistanceSquared( self.origin, ally.origin ) < allyRadius * allyRadius )
		{
			ally play_killstreak_threat( killstreakType );
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
		if(!isdefined(attacker.heroweaponKillCount))attacker.heroweaponKillCount=0;
		
		attacker.heroweaponKillCount++;
		
		if ( attacker.heroweaponKillCount === mpdialog_value( "heroWeaponKillCount", 0 ) )
		{
			killDialog = attacker get_random_key( "heroWeaponSuccess" );
			attacker thread hero_weapon_success_reaction();
		}
	}
	else if ( isdefined(attacker.speedburstOn ) && attacker.speedburstOn && !attacker.speedburstDialogSuccess )	// TODO: Should be some kind of gadget callback
	{
		speedBurstKillDist = mpdialog_value( "speedBurstKillDistance", 0 );
		if ( DistanceSquared( attacker.origin, victim.origin ) < speedBurstKillDist * speedBurstKillDist )
		{
			killDialog = attacker get_random_key( "heroAbilitySuccess" );
			attacker.speedburstDialogSuccess = true;
		}
	}
	else if ( !attacker.playedAbilitySuccessDialog && isdefined( attacker.gadget_camo_off_time ) && attacker.gadget_camo_off_time + ( mpdialog_value( "camoKillTime", 0 ) * 1000 ) >= GetTime() )// TODO: Should be some kind of gadget callback
	{
		killDialog = attacker get_random_key( "heroAbilitySuccess" );
		attacker.playedAbilitySuccessDialog = true;
	}
	else if ( dialog_chance( "enemyKillChance" ) )
	{	
		if ( isdefined( victim.spottedTime ) &&
	         victim.spottedTime + mpdialog_value( "enemySniperKillTime", 0 ) >= GetTime() &&
	         array::contains( victim.spottedBy, attacker ) &&
	         dialog_chance( "enemySniperKillChance" ) )
		{
			killDialog = attacker get_random_key( "killSniper" );
		}
		else if ( dialog_chance( "enemyHeroKillChance" ) )
		{
			victimDialogName = victim GetMpDialogName();
			killDialog = attacker get_random_key( level.bcSounds[ "kill_dialog" ][ victimDialogName ] );
		}
		else
		{
			killDialog = attacker get_random_key( "killGeneric" );
		}
	}

	// Clear sniper spotted fields
	victim.spottedTime = undefined;
	victim.spottedBy = undefined;
	
	if ( !isdefined( killDialog ) )
	{
		return;
	}

	attacker thread wait_play_dialog( mpdialog_value( "enemyKillDelay", 0 ), killDialog, 1, undefined, victim );
}


function grenade_tracking()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	while(1)
	{
		self waittill ( "grenade_fire", grenade, weapon );

		if ( !isdefined( grenade.weapon ) ||
		     !isdefined( grenade.weapon.rootweapon ) ||
		     !dialog_chance( "incomingProjectileChance" ) )
		{
			continue;
		}
		
		dialogKey = level.bcSounds[ "incoming_alert" ][ grenade.weapon.rootweapon.name ];
		
		if ( isdefined( dialogKey ) )
		{
			waittime = mpdialog_value( level.bcSounds[ "incoming_delay" ][ grenade.weapon.rootweapon.name ], .05 );
			level thread incoming_projectile_alert( self, grenade, dialogKey, waittime );
		}
	}
}

function missile_tracking()
{
	self endon( "death" );
	level endon( "game_ended" );

	while(1)
	{	
		self waittill ( "missile_fire", missile, weapon );
		
		if ( !isdefined( missile.item ) ||
		     !isdefined( missile.item.rootweapon ) ||
		     !dialog_chance( "incomingProjectileChance" ) )
		{
			continue;
		}
		
		dialogKey = level.bcSounds[ "incoming_alert" ][ missile.item.rootweapon.name ];
		
		if ( isdefined ( dialogKey ) )
		{
			waittime = mpdialog_value( level.bcSounds[ "incoming_delay" ][ missile.item.rootweapon.name ], .05 );
			level thread incoming_projectile_alert( self, missile, dialogKey, waittime );	
		}
	}
}

function incoming_projectile_alert( thrower, projectile, dialogKey, waittime )
{	
	level endon( "game_ended" );
	if ( waittime <= 0 )
	{
		assert( waittime > 0, "incoming_projectile_alert waittime must be greater than 0" );
		return;
	}
		
	while(1)
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
			closest_enemy = thrower get_closest_player_enemy( projectile.origin );
	
			incomingProjectileRadius = mpdialog_value( "incomingProjectileRadius", 0 );
			
			if( isdefined( closest_enemy ) && DistanceSquared( projectile.origin, closest_enemy.origin ) < incomingProjectileRadius * incomingProjectileRadius )
			{		
				closest_enemy thread play_dialog( dialogKey, 6 );
				return;
			}
		}
	}
}

function sticky_grenade_tracking()
{
	self endon( "death" );
	level endon( "game_ended" );

	while(1)
	{
		self waittill ( "grenade_stuck", grenade );

		if ( isdefined( grenade ) )
		{
			grenade.stuckToPlayer = self;
		}

		if ( IsAlive( self ) )
		{
			self thread play_dialog( "stuckSticky", 6 );
		}
	}
}

function hero_weapon_success_reaction()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	if ( !level.teambased )
	{
		return;
	}
	
	allies = [];
	
	allyRadiusSq = mpdialog_value( "playerVoiceRadius", 0 );
	allyRadiusSq *= allyRadiusSq;
	
	foreach( player in level.players )
	{
		if ( !isdefined( player ) ||
			 !IsAlive( player )	||
			 player.sessionstate != "playing" ||
 			 player == self	||
			 player.team != self.team )
		{
			continue;
		}
	
		distSq = DistanceSquared( self.origin, player.origin );
		
		if ( distSq > allyRadiusSq )
		{
			continue;
		}
		
		allies[allies.size] = player;	
	}
	
	// First do the kill delay wait
	wait( mpdialog_value( "enemyKillDelay", 0 ) + 0.1 );
	
	// Wait for the player to finish talking
	while ( self.playingDialog )
	{
		wait( 0.5 );
	}
	
	allies = ArraySort( allies, self.origin );
	
	foreach( player in allies )
	{
		if ( !IsAlive( player ) ||
		     player.sessionstate != "playing" ||
		     player.playingDialog ||
		     player IsPlayerUnderwater() ||
		     player IsRemoteControlling() ||
		     player IsInVehicle() ||
		     player IsWeaponViewOnlyLinked() )
		{
			continue;
		}
		
		distSq = DistanceSquared( self.origin, player.origin );
		
		if ( distSq > allyRadiusSq )
		{
			break;
		}
		
		player play_dialog( "heroWeaponSuccessReaction", 1 );
		break;
	}
}

function play_promotion_reaction()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	if ( !level.teambased )
	{
		return;
	}

	players = self get_friendly_players();
	players = ArraySort( players, self.origin );

	selfDialog = self GetMpDialogName();
	voiceRadius = mpdialog_value( "playerVoiceRadius", 0 );
	voiceRadiusSq = voiceRadius * voiceRadius;
	
	foreach( player in players )
	{
		if ( player == self ||
		     player GetMpDialogName() == selfDialog ||
			 !player can_play_dialog( true ) ||
			 DistanceSquared( self.origin, player.origin ) >= voiceRadiusSq )
		{
			continue;
		}
		
		dialogAlias = player get_player_dialog_alias( "promotionReaction" );
		
		if ( !isdefined( dialogAlias ) )
		{
			continue;
		}
		
		ally = player;
		break;
	}
	
	if ( isdefined( ally ) )
	{
		wait ( mpdialog_value( "enemyKillDelay", 0 ) );
		
		if ( isdefined( ally ) )
		{
			ally PlaySoundOnTag( dialogAlias, "J_Head", undefined, self );
			// The ally won't know why they can't talk, but they won't interrupt themselves either
			ally thread wait_dialog_buffer( mpdialog_value( "playerDialogBuffer", 0 ) );
		}
	}
}

function gametype_specific_battle_chatter( event, team )
{
	self endon ( "death" );
	level endon( "game_ended" );
}

function play_death_vox( body, attacker, weapon, meansOfDeath )
{
	if ( meansOfDeath === "MOD_MELEE" || // Offhand Knife and Armblades
	     ( isdefined( weapon ) && weapon.rootweapon.name == "hatchet" ) )
	{
		dialogKey = "exertDeathStabbed";
	}
	// MOD_MELEE_WEAPON_BUTT
	else if ( meansOfDeath === "MOD_BURNED" )
	{
		dialogKey = "exertDeathBurned";
	}
	else if ( isdefined( weapon ) && weapon.rootweapon.name == "hero_firefly_swarm" )
	{
		dialogKey = "exertDeathBurned";
	}
	else if ( isdefined( weapon ) && weapon.rootweapon.name == "hero_lightninggun_arc" )
	{
		dialogKey = "exertDeathElectrocuted";
	}
	else if( meansOfDeath === "MOD_DROWN" || self IsPlayerUnderwater() )
	{
		dialogKey = "exertDeathDrowned";
	}
	else
	{
		dialogKey = "exertDeath";
	}
	
	dialogAlias = self get_player_dialog_alias( dialogKey );
	
	if ( isdefined( dialogAlias ) )
	{
		body PlaySoundOnTag( dialogAlias, "J_Head" );
	}
}

function play_killstreak_threat( killstreakType )
{
	if ( !isdefined( killstreakType ) || !isdefined( level.killstreaks[killstreakType] ) )
	{
		return;
	}
	
	self thread play_dialog( level.killstreaks[killstreakType].threatDialogKey, 1 );
}

function wait_play_dialog( waitTime, dialogKey, dialogFlags, dialogBuffer, enemy )
{
	self endon( "death" );
	level endon( "game_ended" );
	
	if (isdefined( waitTime) && waitTime > 0 )
	{
		wait ( waitTime );
	}
	
	self thread play_dialog( dialogKey, dialogFlags, dialogBuffer, enemy );
}

function play_dialog( dialogKey, dialogFlags, dialogBuffer, enemy )
{
	if ( !level.allowbattlechatter["bc"] )
	{
		return;
	}
	
	if ( !isdefined( dialogKey ) )
	{
		return;
	}
	
	if ( !isdefined( dialogFlags ) )
	{
		dialogFlags = 0;
	}
	
	if ( !GetDvarInt( "mpdialog_heroes", 0 ) &&
	     ( dialogFlags & 16 ) == 0 )
	{
		return;
	}
	
	if ( !isdefined( dialogBuffer ) )
	{
		dialogBuffer = mpdialog_value( "playerDialogBuffer", 0 );
	}
	
	dialogAlias = self get_player_dialog_alias( dialogKey );
	
 	if ( !isdefined( dialogAlias ) )
 	{
 		return;
 	}

 	if ( self IsPlayerUnderwater() && !( dialogFlags & 8 ) )
	{
		return;
	}
	
	if ( self.playingDialog )
	{
		if ( !( dialogFlags & 4 ) )
		{
			return;
		}
		
		self StopSounds();
		
		{wait(.05);};
	}
	
	if ( dialogFlags & 2 )
	{
		// Plays to all teams
		self PlaySoundOnTag( dialogAlias, "J_Head" );	
	}
	else if ( dialogFlags & 1 )
	{
		// Plays to current team
		if ( isdefined( enemy ) )
		{
			// And the specified enemy
			self PlaySoundOnTag( dialogAlias, "J_Head", self.team, enemy );
		}
		else
		{
			self PlaySoundOnTag( dialogAlias, "J_Head", self.team );
		}
	}
	else
	{
		self PlayLocalSound( dialogAlias );
	}
	
	// FUTURE: Pass dialogKey, dialogBuffer if useful
	self notify( "played_dialog" );
	
	self thread wait_dialog_buffer( dialogBuffer );
}

function wait_dialog_buffer( dialogBuffer )
{
	self endon( "death" );
	self endon( "played_dialog" );
	level endon( "game_ended" );

	self.playingDialog = true;
	
	if ( isdefined( dialogBuffer ) && dialogBuffer > 0 )
	{
		wait ( dialogBuffer );
	}
	
	self.playingDialog = false;
}

function wait_playback_time( soundAlias )
{
	//self endon( "death" );
	//level endon( "game_ended" );
}

function get_player_dialog_alias( dialogKey )
{
	bundleName = self GetMpDialogName();
	
	if ( !isdefined( bundleName ) )
	{
		return undefined;
	}
	
	playerBundle = struct::get_script_bundle( "mpdialog_player", bundleName );
	
	if ( !isdefined( playerBundle ) )
	{
		return undefined;
	}
	
	return globallogic_audio::get_dialog_bundle_alias( playerBundle, dialogKey );
}

function count_keys( bundle, dialogKey )
{
	i = 0;
	field = dialogKey + i;
	fieldValue = GetStructField( bundle, field );
	
	while ( isdefined( fieldValue ) )
	{
		aliasArray[i] = fieldValue;
		
		i++;
		field = dialogKey + i;
		fieldValue = GetStructField( bundle, field );
	}
	
	if ( !isdefined( bundle.keyCounts ) )
	{
		bundle.keyCounts = [];
	}
	
	bundle.keyCounts[dialogKey] = i;
}

function get_random_key( dialogKey )
{
	bundleName = self GetMpDialogName();
	
	if ( !isdefined( bundleName ) )
	{
		return undefined;
	}
	
	playerBundle = struct::get_script_bundle( "mpdialog_player", bundleName );
	
	if ( !isdefined( playerBundle ) ||
	     !isdefined( playerBundle.keyCounts ) ||
	     !isdefined( playerBundle.keyCounts[dialogKey] ) )
    {
		return dialogKey;
    }
	
	return dialogKey + RandomInt( playerBundle.keyCounts[dialogKey] );
}

// These are called from shared scripts via function pointers
function play_heroweapon_ready()
{
	self thread play_dialog( "heroWeaponReady" );
}

function play_heroweapon_activate()
{
	// Play the Ruin 'Ruuuuraaagh!'
	self thread play_dialog( "heroWeaponUse", 6 | 16, 0.05 );
}

function play_heroability_ready()
{
	self thread play_dialog( "heroAbilityReady" );
}

function play_heroability_activate()
{
	self thread play_dialog( "heroAbilityUse" );
}

function play_heroability_success( waitKey )
{
	if ( isdefined( waitKey ) )
	{
		waitTime = mpdialog_value( waitKey, 0 );
	}

	self thread wait_play_dialog( waitTime, self get_random_key( "heroAbilitySuccess" ), 1 );
}

function play_throw_hatchet()
{
	self thread play_dialog( "exertAxeThrow", 1 | 4 | 16, mpdialog_value( "playerExertBuffer", 0 ) );
}

// Utils for getting enemies / allies

function get_enemy_players()
{
	players = [];
	
	if ( level.teambased )
	{
		foreach( team in level.teams )
		{
			if ( team == self.team )
			{
				continue;
			}
			
			foreach( player in level.alivePlayers[team] )
			{
				players[players.size] = player;
			}
		}
	}
	else
	{
		foreach( player in level.activeplayers )
		{
			if ( player != self )
			{
				players[players.size] = player;
			}
		}
	}
	
	return players;
}

function get_friendly_players()
{
	players = [];
	
	if ( level.teambased )
	{
		foreach( player in level.alivePlayers[self.team] )
		{
			players[players.size] = player;
		}
	}
	else
	{
		players[0] = self;
	}
	
	return players;
}

function can_play_dialog( teamOnly )
{
	if ( self.playingDialog === true ||
	     self IsPlayerUnderwater() ||
	     self IsRemoteControlling() ||
	     self IsInVehicle() ||
	     self IsWeaponViewOnlyLinked() )
	{
		return false;
	}

	if ( isdefined( teamOnly ) && !teamOnly && self HasPerk( "specialty_quieter" ) )
	{
		return false;
	}
	
	return true;
}

// Call this on the owning/controlling/attacking player to keep them from being picked in non-team games
function get_closest_player_enemy( origin, teamOnly )
{
	if(!isdefined(origin))origin=self.origin;
	
	players = self get_enemy_players();
	players = ArraySort( players, origin );

	foreach( player in players )
	{
		if( !player can_play_dialog( teamOnly ) )
		{
			continue;
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

	players = self get_friendly_players();
	players = ArraySort( players, self.origin );

	foreach( player in players )
	{
		if ( player == self ||
			!player can_play_dialog( teamOnly ) )
		{
			continue;
		}
		
		return player;
	}

	return undefined;
}

// Boost Start conversation

function check_boost_start_conversation()
{
	if ( !GetDvarInt( "mpdialog_conversation", 0 ) )
	{
		return;
	}
	
	if ( !level.inPrematchPeriod ||
	     !level.teambased ||
	     game["boostPlayersPicked"][ self.team ] )
	{
		return;
	}
	
	players = self get_friendly_players();
	
	// The spawned player isn't in level.alivePlayers yet
	array::add( players, self, false );

	players = array::randomize( players );
	
	playerIndex = 1;
	foreach( player in players )
	{	
		playerDialog = player GetMpDialogName();
		
		for( i = playerIndex; i < players.size; i++ )
		{
			playerI = players[i];
			
			if ( playerDialog != playerI GetMpDialogName() )
			{
				pick_boost_players( player, playerI );
				return;
			}
		}
		
		playerIndex++;
	}
}

function pick_boost_players( player1, player2 )
{	
	player1 clientfield::set( "play_boost", 1 );
	player2 clientfield::set( "play_boost", 2 );
	
	game["boostPlayersPicked"][player1.team] = true;
}

// Game end dialog

function game_end_vox( winner )
{
	foreach( player in level.players )
	{
		if ( isdefined( level.teams[ winner ] ) )
		{
			if ( player.team == winner )
			{
				dialogKey = "boostWin";
			}
			else
			{
				dialogKey = "boostLoss";
			}
		}
		else
		{
			dialogKey = "boostDraw";
		}
		
		dialogAlias = player get_player_dialog_alias( dialogKey );
		
		if ( isdefined( dialogAlias ) )
		{
			player PlayLocalSound( dialogAlias );
		}
	}
}

// Game End Taunts

function end_taunt_vox( position )
{
	if ( !GetDvarInt( "mpdialog_endtaunt", 0 ) )
	{
		return;
	}
	
	self endon ( "disconnect" );
	self endon ( "stop_end_taunt" );
	level endon ( "game_ended" );
	
	assert( isdefined( position ) );
	
	while (1)
	{
		//dev::draw_point( position, ( 1, 0, 1 ) );
		
		for ( i = 0; i < level.taunts.size; i++ )
		{
			if ( self [[level.taunts[i].checkFunc]]() )
			{
				dialogAlias = self get_player_dialog_alias( level.taunts[i].dialogKey );
	
				if ( isdefined( dialogAlias ) )
				{
					PlaySoundAtPosition( dialogAlias, position );
					return;
				}
			}
		}
		
		{wait(.05);};
	}
}

function add_taunt( dialogKey, checkFunc )
{
	if ( !isdefined( level.taunts ) )
	{
		level.taunts = [];
	}
	
	index = level.taunts.size;
	
	level.taunts[index] = SpawnStruct();
	level.taunts[index].dialogKey = dialogKey;
	level.taunts[index].checkFunc = checkFunc;
}

function jump_pressed()
{
	return self JumpButtonPressed();
}

function reload_pressed()
{
	return self ReloadButtonPressed();
}

function switch_pressed()
{
	return self WeaponSwitchButtonPressed();
}

function stance_pressed()
{
	return self StanceButtonPressed();
}
