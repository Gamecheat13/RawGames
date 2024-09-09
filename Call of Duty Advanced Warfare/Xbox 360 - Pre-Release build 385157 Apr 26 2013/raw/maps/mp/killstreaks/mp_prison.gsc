#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	
	/************************
	//TODO//
	*************************/
	
	SetDvarIfUninitialized( "mp_prison_killstreak_duration", 25 );
	
	precacheLocationSelector( "map_artillery_selector" );
	precacheString( &"KILLSTREAKS_MP_PRISON" );
	
	PreCacheItem( "killstreak_prison_mp" );
	PreCacheItem( "prison_turret_mp" );
	
	level.mp_prison_InUse = false;
	level.prison_turrets_alive = 0;
	level.prison_turret_alarm_sfx		= "alarm_small_outside_loop_ver_01";						//TODO: request audio.
	level.prison_turret_burn_sfx		= "orbital_laser";											//TODO: request audio.
	level.prison_turret_beam 		= LoadFX( "vfx/beam/prison_turret_beam" );				//TODO: Request VFX.
	level.prison_turret_warning_light = LoadFX( "vfx/lights/light_red_blink_prison" );				//TODO: Request VFX.
	
	level.killStreakFuncs[ "mp_prison" ] = ::tryUseMpPrison;
		
	level.sentrySettings[ "prison_turret" ] = spawnStruct();
	level.sentrySettings[ "prison_turret" ].health =				999999;		// keep it from dying anywhere in code
	level.sentrySettings[ "prison_turret" ].maxHealth =				1000;		// this is the health we'll check
	level.sentrySettings[ "prison_turret" ].burstMin =				20;
	level.sentrySettings[ "prison_turret" ].burstMax =				120;
	level.sentrySettings[ "prison_turret" ].pauseMin =				0.15;
	level.sentrySettings[ "prison_turret" ].pauseMax =				0.35;
	level.sentrySettings[ "prison_turret" ].sentryModeOn =			"sentry";
	level.sentrySettings[ "prison_turret" ].sentryModeOff =			"sentry_offline";
	level.sentrySettings[ "prison_turret" ].timeOut =				90.0;
	level.sentrySettings[ "prison_turret" ].spinupTime =			0.05;
	level.sentrySettings[ "prison_turret" ].overheatTime =			8.0;
	level.sentrySettings[ "prison_turret" ].cooldownTime =			0.1;
	level.sentrySettings[ "prison_turret" ].fxTime =				0.3;
	level.sentrySettings[ "prison_turret" ].streakName =			"sentry";
	level.sentrySettings[ "prison_turret" ].weaponInfo =			"prison_turret_mp";
	level.sentrySettings[ "prison_turret" ].modelBase =				"prison_turret";
	level.sentrySettings[ "prison_turret" ].modelPlacement =		"sentry_minigun_weak_obj";
	level.sentrySettings[ "prison_turret" ].modelPlacementFailed =	"sentry_minigun_weak_obj_red";
	level.sentrySettings[ "prison_turret" ].modelDestroyed =		"sentry_minigun_weak_destroyed";
	level.sentrySettings[ "prison_turret" ].hintString =			&"SENTRY_PICKUP";
	level.sentrySettings[ "prison_turret" ].headIcon =				true;
	level.sentrySettings[ "prison_turret" ].teamSplash =			"used_sentry";
	level.sentrySettings[ "prison_turret" ].shouldSplash =			false;
	level.sentrySettings[ "prison_turret" ].voDestroyed =			"sentry_destroyed";
	
	level.prison_turrets = setupPrisonTurrets();
	
//	level thread handlePrisonTurretBlindness();
//	level thread prisonTurretFadeLoop();
}

tryUseMpPrison( lifeId )
{
	if ( level.mp_prison_InUse )
	{
		self iPrintLnBold( &"MP_PRISON_IN_USE" );
		return false;
	}

	if ( self isUsingRemote() )
	{
		return false;
	}
	
	if ( self isAirDenied() )
	{
		return false;
	}
	
	if ( self isEMPed() )
	{
		return false;
	}

	result = setPrisonTurretPlayer( self );
	
	if ( IsDefined( result ) && result )
	{
		self maps\mp\_matchdata::logKillstreakEvent( "mp_prison", self.origin );
	}
	
	return result;
	
	
	return true;
}

riotSuppersionSystem( lifeID )
{
	//self thread monitorRiotSuppressionSystem();

	return true;
}


setupPrisonTurrets()
{
	turrets = getentarray( "prison_turret", "targetname" );
	
	sentryType = "prison_turret";
	
	for ( i = 0; i < turrets.size; i++ )
	{
		turrets[i].spawned_turret = SpawnTurret( "misc_turret", turrets[i].origin, level.sentrySettings[ sentryType ].weaponInfo, false );
		turrets[i].spawned_turret makeTurretSolid();			//We need to make turrets solid for them to be damageable...
		turrets[i].spawned_turret  sentry_initSentry( sentryType );		//HACK: I'm calling sentry_initSentry() to do initial setup for the turrets. The turrets don't have an owner yet.
		turrets[i].spawned_turret.angles = turrets[i].angles;
	}
	
	return turrets;
}



//HACK: I removed all references to the owner argument. This is because the sentry doesn't have an owner when it is first created.
sentry_initSentry( sentryType ) // self == sentry, turret, sam
{
	self.sentryType = sentryType;
	self.canBePlaced = true;

	self setModel( level.sentrySettings[ self.sentryType ].modelBase );
	switch( sentryType )
	{
		default:
			self makeTurretInoperable();
			self SetDefaultDropPitch( 0.0 );	// setting this mainly prevents Turret_RestoreDefaultDropPitch() from running
			break;
	}
	
	self setTurretModeChangeWait( true );
	self maps\mp\killstreaks\_autosentry::sentry_setInactive();
	
	switch( sentryType )
	{
	default:
		self thread maps\mp\killstreaks\_autosentry::sentry_handleUse();
//		self thread maps\mp\killstreaks\_autosentry::sentry_attackTargets();		//Don't want the prison turrets to shoot bullets.
		break;
	}
}



/*
=============
///ScriptDocBegin
"Name: setPrisonTurretPlayer( <player> )"
"Summary: sets the owner of the Prison turrets when a player uses the map-based killstreak."
"Module: Entity"
"CallOn: N/A"
"MandatoryArg: <player>: the player that used the killstreak"
"Example: result = setPrisonTurretPlayer( self );"
"SPMP: MP"
///ScriptDocEnd
=============
*/
setPrisonTurretPlayer( player )
{
	if( level.mp_prison_InUse )
		return false;
	
	level.mp_prison_InUse = true;
	
	thread teamPlayerCardSplash( "mp_prison", player );
	
	sentryType = "prison_turret";
	
	for ( i = 0; i < level.prison_turrets.size; i++ )
	{
		level.prison_turrets_alive++;
		Assert( IsDefined( level.prison_turrets[i].spawned_turret ) );
		level.prison_turrets[i].spawned_turret sentry_setOwner( player );
		level.prison_turrets[i].spawned_turret.shouldSplash = false;
		level.prison_turrets[i].spawned_turret.carriedBy = player;
		level.prison_turrets[i].spawned_turret sentry_setPlaced();
		level.prison_turrets[i].spawned_turret LaserOn();
		level.prison_turrets[i].spawned_turret setCanDamage( true );
		level.prison_turrets[i].spawned_turret setCanRadiusDamage( true );
		level.prison_turrets[i].spawned_turret thread sentry_handleDamage();
		level.prison_turrets[i].spawned_turret thread sentry_handleDeath();
		level.prison_turrets[i].spawned_turret.alarm_on = false;
		level.prison_turrets[i].spawned_turret.burn_on = false;
		level.prison_turrets[i].spawned_turret.shocking_target = false;
//		level.prison_turrets[i].spawned_turret thread inflictPrisonTurretPressure();
//		level.prison_turrets[i].spawned_turret thread handlePrisonTurretLights();
	}
	
	level thread prisonTurretTimer();
	level thread monitorPrisonKillstreakOwnership();
	
	return true;
}


/*
=============
///ScriptDocBegin
"Name: prisonTurretTimer()"
"Summary: notifies after mp_prison_killstreak_duration is up."
"Module: Entity"
"CallOn: the level"
"Example: level thread prisonTurretTimer();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
prisonTurretTimer()
{
	level endon( "game_ended" );
	
	wait_time = GetDvarInt( "mp_prison_killstreak_duration", 25 );
	while ( wait_time > 0 )
	{
		wait( 1 );
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
		wait_time--;
		
		//End this thread if the killstreak is no longer in use. For example, end it if all the turrets are killed.
		if ( level.mp_prison_InUse == false )
		{
			return;
		}
	}
	
	//If the killstreak ended because of time, some turrets might still be alive. Notify death for all turrets to deactivate them.
	for ( i = 0; i < level.prison_turrets.size; i++ )
	{
		level.prison_turrets[i].spawned_turret notify( "fake_prison_death" );			//Using "fake_prison_death" instead of "death" because "death" would detrimentally end some functionality taken from _autosentry.gsc.
	}
}


/*
=============
///ScriptDocBegin
"Name: sentry_setOwner( <owner> )"
"Summary: sets the owner of the spawned turret."
"Module: Entity"
"CallOn: a turret spawned by SpawnTurret()."
"MandatoryArg: <owner>: the player that used the prison killstreak"
"Example: level.prison_turrets[i]["spawned_turret"] sentry_setOwner( player );"
"SPMP: MP"
///ScriptDocEnd
=============
*/
sentry_setOwner( owner )
{
	self.owner = owner;
	
	self SetSentryOwner( self.owner );
	self SetTurretMinimapVisible( true, self.sentryType );
	
	if ( level.teamBased && IsDefined( owner ) )
	{
		self.team = self.owner.team;
		self setTurretTeam( self.team );
	}
	
	self thread sentry_handleOwnerDisconnect();
}


/*
=============
///ScriptDocBegin
"Name: sentry_setPlaced()"
"Summary: among other things, sets the sentry turret down and puts it into play."
"Module: Entity"
"CallOn: a turret"
"Example: prison_turret["spawned_turret"] maps\mp\killstreaks\_autosentry::sentry_setPlaced();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
sentry_setPlaced()
{
	self setSentryCarrier( undefined );
	
	self.carriedBy forceUseHintOff();
	self.carriedBy = undefined;
	
	if( IsDefined( self.owner ) )
		self.owner.isCarrying = false;
	
	self sentry_setActive();
	
	self playSound( "sentry_gun_plant" );
	
	self notify ( "placed" );
}


/*
=============
///ScriptDocBegin
"Name: sentry_handleDamage()"
"Summary: handles the death of a turret spawned by SpawnTurret()"
"Module: Entity"
"CallOn: a turret spawned by SpawnTurret()."
"Example: self thread sentry_handleDamage();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
sentry_handleDamage()
{
	self endon( "fake_prison_death" );
	level endon( "game_ended" );
	
	self.health = level.sentrySettings[ self.sentryType ].health;
	self.maxHealth = level.sentrySettings[ self.sentryType ].maxHealth;
	self.damageTaken = 0; // how much damage has it taken
	
	while ( true )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath, modelName, tagName, partName, iDFlags, weapon );
		
		// don't allow people to destroy equipment on their team if FF is off
		if ( !maps\mp\gametypes\_weapons::friendlyFireCheck( self.owner, attacker ) )
			continue;
		
		if ( IsDefined( iDFlags ) && ( iDFlags & level.iDFLAGS_PENETRATION ) )
			self.wasDamagedFromBulletPenetration = true;
		
		modifiedDamage = 0;
		
		if( IsDefined( weapon ) )
		{
			switch( weapon )
			{
				case "emp_grenade_mp":
					self.largeProjectileDamage = false;
					modifiedDamage = self.maxHealth + 1;
					if ( isPlayer( attacker ) )
					{
						attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "sentry" );
					}
					break;
				default:
					modifiedDamage = 0;
					break;
			}
			
			maps\mp\killstreaks\_killstreaks::killstreakHit( attacker, weapon, self );
		}

		self.damageTaken += modifiedDamage;

		if ( self.damageTaken >= self.maxHealth )
		{
			thread maps\mp\gametypes\_missions::vehicleKilled( self.owner, self, undefined, attacker, damage, meansOfDeath, weapon );
			
			if ( isPlayer( attacker ) && (!IsDefined(self.owner) || attacker != self.owner) )
			{
				attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", 100, weapon, meansOfDeath );
				attacker notify( "destroyed_killstreak" );
				
				if ( IsDefined( self.UAVRemoteMarkedBy ) && self.UAVRemoteMarkedBy != attacker )
					self.UAVRemoteMarkedBy thread maps\mp\killstreaks\_remoteuav::remoteUAV_processTaggedAssist();
			}
			
			if ( IsDefined( self.owner ) )
				self.owner thread leaderDialogOnPlayer( level.sentrySettings[ self.sentryType ].voDestroyed, undefined, undefined, self.origin );
			
			self notify( "fake_prison_death" );
			
			return;
		}
	}
}


sentry_handleDeath()
{
	self waittill ( "fake_prison_death" );
	
	// this handles cases of deletion
	if ( !IsDefined( self ) )
		return;

	self maps\mp\killstreaks\_autosentry::sentry_setInactive();
	self SetSentryOwner( undefined );
	self SetTurretMinimapVisible( false );
	
	//Turning off the turrets' head icons. This is added functionality for the mp_prison turrets.
	if( level.sentrySettings[ self.sentryType ].headIcon )
	{
		if ( level.teamBased )
			self maps\mp\_entityheadicons::setTeamHeadIcon( "none", (0,0,0) );
		else
			self maps\mp\_entityheadicons::setPlayerHeadIcon( "none", (0,0,0) );
	}
	
	level.prison_turrets_alive--;
	
	self setCanDamage( false );		//Make the turrets non-damageable when they fake die.
	self setCanRadiusDamage( false );
	
	self LaserOff();
	
	
	//Cleaning up sound and damage stuff for the turret./////////
	if ( self.alarm_on == true )
	{
		self thread stop_loop_sound_on_entity( level.prison_turret_alarm_sfx );
		self.alarm_on = false;
	}
	if ( self.burn_on == true )
	{
		self thread stop_loop_sound_on_entity( level.prison_turret_burn_sfx );
		self.burn_on = false;
		StopFXOnTag( level.prison_turret_beam, self, "tag_weapon" );
	}
	if ( IsDefined( self.previous_turret_target ) )
	{
		self notify( "lost_or_changed_target" );
		self.previous_turret_target = undefined;
	}
	self.shocking_target = false;
	self.turret_on_target = undefined;
	/////////////////////////////////////////////////////////////
}


/*
=============
///ScriptDocBegin
"Name: sentry_setActive()"
"Summary: activates the sentry turret"
"Module: Entity"
"CallOn: a turret"
"Example: self sentry_setActive();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
sentry_setActive()
{
	self SetMode( level.sentrySettings[ self.sentryType ].sentryModeOn );
	
	if( level.sentrySettings[ self.sentryType ].headIcon )
	{
		if ( level.teamBased )
			self maps\mp\_entityheadicons::setTeamHeadIcon( self.team, (0,0,65) );
		else
			self maps\mp\_entityheadicons::setPlayerHeadIcon( self.owner, (0,0,65) );
	}
}


/*
=============
///ScriptDocBegin
"Name: sentry_handleOwnerDisconnect()"
"Summary: notifies death for this turret (self) if its owner disconnects."
"Module: Entity"
"CallOn: a turret spawned by SpawnTurret()."
"Example: self thread sentry_handleOwnerDisconnect();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
sentry_handleOwnerDisconnect()
{
	level endon ( "game_ended" );
	self endon( "fake_prison_death" );			//Ending this thread if the turret (self) dies by other means (damage, time).
	
	self.owner waittill_any( "disconnect", "joined_team", "joined_spectators" );
	
	self notify( "fake_prison_death" );
}


/*
=============
///ScriptDocBegin
"Name: monitorPrisonKillstreakOwnership()"
"Summary: frees up the prison killstreak when the killstreak time is up or all turrets are disabled."
"Module: Entity"
"CallOn: the level"
"Example: level thread monitorPrisonKillstreakOwnership()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
monitorPrisonKillstreakOwnership()
{
	level endon( "game_ended" );
	
	//If any turrets are alive or any turrets are up... wait!
	while ( level.prison_turrets_alive > 0 )
	{
		wait( 0.05 );
	}
	
	level.mp_prison_InUse = false;
}


/*
=============
///ScriptDocBegin
"Name: inflictPrisonTurretPressure()"
"Summary: applies a slow and distortion to players that a turret is pointing at."
"Module: Entity"
"CallOn: a turret spawned by SpawnTurret()."
"Example: thread level.prison_turrets[i] inflictPrisonTurretPressure();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
inflictPrisonTurretPressure()
{
	level endon( "game_ended" );
	self endon( "fake_prison_death" );
	
	self thread getPrisonTurretTarget();
	self thread prisonTurretShoot();
	self thread applyPrisonTurretBlindness();
}


/*
=============
///ScriptDocBegin
"Name: getPrisonTurretTarget()"
"Summary: a function to be threaded. Repeatedly gets a prison turret's target."
"Module: Entity"
"CallOn: a prison turret."
"Example: turret thread getPrisonTurretTarget();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
getPrisonTurretTarget()
{
	level endon( "game_ended" );
	self endon( "fake_prison_death" );
	
	while ( true )
	{
		self.turret_on_target = self GetTurretTarget( true );
		
		if ( IsDefined( self.previous_turret_target ) )
		{
			if ( IsDefined( self.turret_on_target ) )
			{
				if ( self.turret_on_target != self.previous_turret_target )
				{
					//End the previous victim's shock time thread because the turret has changed targets.
					self notify( "lost_or_changed_target" );
					self.previous_turret_target = undefined;
					self.shocking_target = false;
				}
			}
			else
			{
				//End the previous victim's shock time thread because the turret no longer has a target.
				self notify( "lost_or_changed_target" );
				self.previous_turret_target = undefined;
				self.shocking_target = false;
			}
		}
		
		//Refresh self.previous_turret_target only if the self.turret_on_target is defined and is a player. When the turret_on_target is undefined, we want to remember the previous, valid target.
		if ( IsDefined ( self.turret_on_target ) && IsPlayer( self.turret_on_target ) )
		{
			//Refresh the previous_turret_target. This only happens when self.turret_on_target is defined, maintaining that previou_turret_target is set equal to the last valid turret_on_target.
			self.previous_turret_target = self.turret_on_target;
			
			if ( self.alarm_on == false )
			{
				self thread play_loop_sound_on_entity( level.prison_turret_alarm_sfx );
				self.alarm_on = true;
			}
		}
		else if ( !IsDefined( self.turret_on_target ) )			//If the turret no longer has a target, end its sounds.
		{
			self thread stop_loop_sound_on_entity( level.prison_turret_alarm_sfx );
			self.alarm_on = false;
			
			self thread stop_loop_sound_on_entity( level.prison_turret_burn_sfx );
			self.burn_on = false;
			StopFXOnTag( level.prison_turret_beam, self, "tag_weapon" );
		}
		
		wait( 0.05 );
	}
}


/*
=============
///ScriptDocBegin
"Name: prisonTurretShoot()"
"Summary: a function to be threaded. Repeatedly checks if it should apply the appropriate shellshock and sounds to victims."
"Module: Entity"
"CallOn: a prison turret."
"Example: turret thread prisonTurretShoot();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
prisonTurretShoot()
{
	level endon( "game_ended" );
	self endon( "fake_prison_death" );
	
	while ( true )
	{
		if ( IsDefined ( self.turret_on_target ) && IsPlayer( self.turret_on_target ) )
		{
			self waittill( "turret_on_target" );
			
			//After the turret is on target, give players a minimum of 2 seconds to run.
			wait( 2 );
			
			
			self thread stop_loop_sound_on_entity( level.prison_turret_alarm_sfx );
			
			if ( IsDefined( self.turret_on_target ) && IsPlayer( self.turret_on_target ) )		//Have to check isDefined again because the self.turret_on_target might have become undefined in the 2 second wait above.
			{
				self.shocking_target = true;
				
				if ( self.burn_on == false )
				{
					self thread play_loop_sound_on_entity( level.prison_turret_burn_sfx );
					self.burn_on = true;
					PlayFXOnTag( level.prison_turret_beam, self, "tag_weapon" );
				}
				
				self.turret_on_target ShellShock( "prison_turret_mp", 2.5 );		//TODO: create a new .shock file for the prison turrets. This shock file should inclue sound that indicates that the player is being CC'd.
			}
		}
		
		wait( 0.05 );
	}
}


/*
=============
///ScriptDocBegin
"Name: applyPrisonTurretBlindness()"
"Summary: fades a player's screen to black while being suppressed by a prison turret."
"Module: Entity"
"CallOn: a prison turret"
"Example: turret thread applyPrisonTurretBlindness();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
applyPrisonTurretBlindness()
{
	level endon( "game_ended" );
	self endon( "fake_prison_death" );
	
	while ( true )
	{
		if ( self.shocking_target == true && IsDefined( self.turret_on_target ) && IsPlayer( self.turret_on_target ) )
		{
			if ( self.turret_on_target.new_blindness_alpha < 0.6 )
			{
				self.turret_on_target.new_blindness_alpha += 0.053;
			}
		}
		
		wait( 0.05 );
	}
}


/*
=============
///ScriptDocBegin
"Name: handlePrisonTurretBlindness()"
"Summary: handles the alpha of the blindness hud element for all players."
"Module: Entity"
"CallOn: level"
"Example: level thread handlePrisonTurretBlindness();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
handlePrisonTurretBlindness()
{
	level endon( "game_ended" );
	
	while ( true )
	{
		if ( IsDefined ( level.players ) )
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				//If the player doesn't have a prisonTurretOverlay, create one.
				if ( !isDefined( level.players[i].prisonTurretOverlay ) )
				{
					level.players[i].prisonTurretOverlay = newClientHudElem( level.players[i] );
					level.players[i].prisonTurretOverlay.x = 0;
					level.players[i].prisonTurretOverlay.y = 0;
					level.players[i].prisonTurretOverlay setshader( "black", 640, 480 );
					level.players[i].prisonTurretOverlay.alignX = "left";
					level.players[i].prisonTurretOverlay.alignY = "top";
					level.players[i].prisonTurretOverlay.horzAlign = "fullscreen";
					level.players[i].prisonTurretOverlay.vertAlign = "fullscreen";
					level.players[i].prisonTurretOverlay.alpha = 0;
					
					level.players[i].prev_blindness_alpha = 0;
					level.players[i].new_blindness_alpha = 0;
				}
				
				level.players[i].prev_blindness_alpha = level.players[i].prisonTurretOverlay.alpha;
				
				//Players constantly "heal" any blindness they may be experiencing. The healing rate is slower than the turret damage rate.
				if ( level.players[i].new_blindness_alpha > 0 )
				{
					level.players[i].new_blindness_alpha -= 0.05;
					if ( level.players[i].new_blindness_alpha < 0 )
					{
						level.players[i].new_blindness_alpha = 0;
					}
				}
			}
		}
		wait( 0.05 );
	}
}


/*
=============
///ScriptDocBegin
"Name: fadeBlackOut( <duration> , <alpha> )"
"Summary: gradually changes a hud element's alpha value over a duration of time in seconds."
"Module: Entity"
"CallOn: a hud element"
"MandatoryArg: <duration>: time spent fading"
"MandatoryArg: <alpha>: the new alpha to fade to"
"Example: self.prisonTurretOverlay fadeBlackOut( 1, 0.3 );"
"SPMP: MP"
///ScriptDocEnd
=============
*/
fadeBlackOut( duration, alpha )
{
	self fadeOverTime( duration );
	self.alpha = alpha;
	wait duration;
}


/*
=============
///ScriptDocBegin
"Name: prisonTurretFadeLoop()"
"Summary: handles the fading of each player's blindness HUD element."
"Module: Entity"
"CallOn: level"
"Example: level thread prisonTurretFadeLoop();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
prisonTurretFadeLoop()
{
	level endon( "game_ended" );
	
	while ( true )
	{
		if ( IsDefined ( level.players ) )
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				if ( level.players[i].prev_blindness_alpha != level.players[i].new_blindness_alpha )
				{
					level.players[i].prisonTurretOverlay fadeBlackOut( 0.05, level.players[i].new_blindness_alpha );
//					level.players[i].prisonTurretOverlay.alpha = level.players[i].new_blindness_alpha;
				}
			}
		}
		wait( 0.05 );
	}
}


/*
=============
///ScriptDocBegin
"Name: handlePrisonTurretLights()"
"Summary: turns on/off the prison turrets lights."
"Module: Entity"
"CallOn: a prison turret"
"Example: turret thread handlePrisonTurretLights();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
handlePrisonTurretLights()
{
	PlayFXOnTag( level.prison_turret_warning_light, self, "tag_weapon" );
	
	self waittill( "fake_prison_death" );
	
	StopFXOnTag( level.prison_turret_warning_light, self, "tag_weapon" );
}
