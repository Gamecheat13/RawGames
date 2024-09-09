#include maps\mp\_utility;
#include common_scripts\utility;


init()
{
	initLaserFX();
	initLaserSound();
	initLaser();
	initLaserEnts();
	level.killstreakFuncs["mp_laser2"] = ::tryUseMPLaser;
}

initLaserFX()
{
	level.laser_fx["beahm"] = LoadFX( "vfx/map/mp_solar/solar_lightbeam" );
	level.laser_fx["laser_charge"] = LoadFX( "vfx/map/mp_laser2/laser_core" );
	level.laser_fx["laser_steam"] = LoadFX( "vfx/steam/steam_pipe_leak_lrg" );
}

initLaserSound()
{
	level.laser_sfx = "orbital_laser";	//TODO: request new sfx.
	game["dialog"]["laser_deactivated"] = "laser_deactivated";
}

initLaser()
{
	laser = spawnStruct();
	laser.health =					999999; // keep it from dying anywhere in code
	laser.maxHealth =				1000; // this is the health we'll check
	laser.burstMin =				20;
	laser.burstMax =				120;
	laser.pauseMin =				0.15;
	laser.pauseMax =				0.35;	
	laser.sentryModeOn =			"sentry";	
	laser.sentryModeOff =			"sentry_offline";	
	laser.timeOut =					60.0;	
	laser.spinupTime =				0.05;	
	laser.overheatTime =			8.0;	
	laser.cooldownTime =			0.1;	
	laser.fxTime =					0.3;	
	laser.streakName =				"sky_laser_turret";
	laser.weaponInfo =				"sky_laser_mp";
	laser.useweaponinfo =			"killstreak_laser2_mp";
	laser.modelBase =				"mp_sky_laser_turret";
	laser.modelPlacement =			"mp_sam_turret_placement";
	laser.modelPlacementFailed = 	"mp_sam_turret_placement_failed";
	laser.modelDestroyed =			"mp_sky_laser_turret";	
	//laser.hintString =				&"SENTRY_PICKUP";	
	laser.headIcon =				true;	
	laser.teamSplash =				"used_sam_turret";	
	laser.shouldSplash =			false;	
	laser.voDestroyed =				"laser_deactivated";
	laser.coreShellshock =			"default";//"radiation_high";//"mp_prison_gas";
	
	precacheshellshock( laser.coreShellshock );
	PreCacheItem( laser.useweaponinfo );
	precacheItem( laser.weaponInfo );
	precacheModel( laser.modelBase );		
	precacheModel( laser.modelPlacement );		
	precacheModel( laser.modelPlacementFailed );		
	precacheModel( laser.modelDestroyed );		
	//PreCacheString( laser.hintString );
	if( IsDefined( laser.ownerHintString ) )
		PreCacheString( laser.ownerHintString );
	
	PreCacheString( &"MP_LASERTURRET_HACK" );
	PreCacheString( &"MP_LASERTURRET_ALREADY_YOURS" );
	PreCacheString( &"MP_LASERTURRET_TEAM" );
	PreCacheString( &"MP_LASERTURRET_ENEMY" );
	
	PreCacheItem( "sky_laser_projectile_mp" );
	
	SetDvarIfUninitialized( "scr_laser2_killstreak_duration", laser.timeOut );
	
	level.sentrySettings[ "sky_laser_turret" ] = laser;
}

initLaserEnts()
{
	sentryType = "sky_laser_turret";
	
	PreCacheModel( "mp_laser_command_switch_01_obj" );
	
	laserEnt = GetEnt( "lasergun", "targetname");
	laserLifterEnts = GetEntArray( "laser_lifter", "targetname");
	laserEnt.lifter = laserLifterEnts[0];
	laserEnt.moveOrgs = laserEnt.lifter laser_initMoveOrgs();
	laserEnt.FxEnts = laserEnt laser_initFxEnts();
	laserEnt.offSwitch = laserEnt laser_initOffSwitch();
	laserEnt.coreDamageTrigs = getentarray( "trig_laserCore", "targetname" );
	
	for( i=0; i<laserLifterEnts.size; i++ )
	{
		if( i != 0 )
		{
			laserLifterEnts[i] linkto( laserEnt.lifter );
		}
	}
	
	laserEnt linkto( laserEnt.lifter );
	
	level.sentryGun = laserEnt;
	level.sentryGun laser_initSentry( sentryType );
}

laser_initMoveOrgs()
{
	locEnt_top = getStruct( "laser_lifter_top_loc", "targetname" );
	locEnt_bottom = getStruct( "laser_lifter_bottom_loc", "targetname" );
	locEnt_dist = locEnt_top.origin - locEnt_bottom.origin;
	
	moveOrgs = [];
	moveOrgs["bottom"] = self.origin;
	moveOrgs["top"] = self.origin + locEnt_dist;
	
	return moveOrgs;
}

laser_initFxEnts()
{
	charge_up = undefined;
	steam = [];
	lights = undefined;
	
	coreStruct = getstruct( "laser_core_fx_pos", "targetname" );
	steamStructs = getstructarray( "laser_steam_fx_pos", "targetname" );
	cautionLights = getent( "warning_lights", "targetname" );
	
	if( isDefined( coreStruct ) )
	{
		charge_up = coreStruct spawn_tag_origin();
		charge_up show();
	}
	
	if( isDefined( steamStructs ) )
	{
		for( i=0; i<steamStructs.size; i++ )
		{
			steam[i] = steamStructs[i] spawn_tag_origin();
			steam[i] show();
		}
	}
	
	if( isDefined( cautionLights ) )
	{
		lights = cautionLights;
		lights hide();
	}
	
	FxEnts = [];
	FxEnts["charge_up"] = charge_up;
	FxEnts["steam"] = steam;
	FxEnts["lights"] = lights;
	
	return FxEnts;
}

laser_initOffSwitch()
{
	trigger = GetEnt( "laser_use_trig", "targetname" );
	offSwitchEnt = GetEnt( "laser_switch", "targetname" );
	visuals = [offSwitchEnt];
	
	offSwitch = [];
	
	switch_obj = spawn( "script_model", offSwitchEnt.origin );
	switch_obj.angles = offSwitchEnt.angles;
	switch_obj setmodel( "mp_laser_command_switch_01_obj" );
	switch_obj hide();

	use_zone = maps\mp\gametypes\_gameobjects::createUseObject( "none", trigger, visuals, (0,0,64) );
	use_zone maps\mp\gametypes\_gameobjects::allowUse( "none" );
	use_zone maps\mp\gametypes\_gameobjects::setUseTime( 5 );
	use_zone maps\mp\gametypes\_gameobjects::setUseText( "Shutting off Laser Air Defense" );
	use_zone maps\mp\gametypes\_gameobjects::setUseHintText( &"MP_LASERTURRET_HACK" );
	
	use_zone.onBeginUse = ::laser_offSwitch_onBeginUse;
	use_zone.onEndUse = ::laser_offSwitch_onEndUse;
	use_zone.onUse = ::laser_offSwitch_onUsePlantObject;
	use_zone.onCantUse = ::laser_offSwitch_onCantUse;
	use_zone.useWeapon = "briefcase_bomb_mp";
	
	offSwitch = [];
	offSwitch["switch_obj"] = switch_obj;
	offSwitch["use_zone"] = use_zone;
	
	return offSwitch;
}

laser_offSwitch_onBeginUse( player )
{
	//
}

laser_offSwitch_onEndUse( team, player, result )
{
	//
}

laser_offSwitch_onUsePlantObject( player )
{
	level.sentryGun endon ( "death" );
	level endon ( "game_ended" );
	

	if ( IsDefined( level.sentryGun.owner ) )
	{
		level.sentryGun.owner thread leaderDialogOnPlayer( "sam_gone" );
	}
	
	player playSound( "mp_bomb_plant" );
	damage = level.sentrySettings[ "sky_laser_turret" ].maxhealth;
	level.sentryGun notify
		( "damage", 		//"damage"
		damage, 			//damage
		player,				//attacker
		( 0, 0, 0 ), 		//direction_vec
		( 0, 0, 0 ), 		//point
		"MOD_UNKNOWN",		//meansOfDeath
		undefined, 			//modelName
		undefined,			//tagName
		undefined,			//partName
		undefined,			//iDFlags
		"none" );//weapon
}

laser_offSwitch_onCantUse( player )
{
	//
}

laser_initSentry( sentryType ) // self == sentry, turret, sam
{
	self.sentryType = sentryType;

	self setModel( level.sentrySettings[ self.sentryType ].modelBase );
	self.shouldSplash = true; // we only want to splash on the first placement

	self setCanDamage( true );

	self makeTurretInoperable();
	self SetLeftArc( 180 );
	self SetRightArc( 180 );
	self SetTopArc( 80 );
	self SetDefaultDropPitch( 40 );	// setting this mainly prevents Turret_RestoreDefaultDropPitch() from running
	self.laser_on = false;
	
	// needs a kill cam ent
	killCamEnt = Spawn( "script_model", self GetTagOrigin( "tag_laser" ) );
	killCamEnt LinkTo( self );
	self.killCamEnt = killCamEnt;
	self.killCamEnt SetScriptMoverKillCam( "explosive" );
	
	//HINT: this is different than other autosentries since the turret isn't placed it should be solid all the time
	self maps\mp\killstreaks\_autosentry::sentry_makeSolid();
	
	self setTurretModeChangeWait( true );
	self laser_setInactive();
	
	//TODO: don't need to do fakedeath. Do real death but modify maps/_autosentry::sentry_handleDeath function to not delete the turret
	self thread laser_handleDamage();
	self thread laser_handleFakeDeath();
	self thread maps\mp\killstreaks\_autosentry::sentry_beepSounds();
	
	//self makeUsable();
}

laser_handleDamage()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	while ( true )
	{
		self.health = level.sentrySettings[ self.sentryType ].health;
		self.maxHealth = level.sentrySettings[ self.sentryType ].maxHealth;
		self.damageTaken = 0; // how much damage has it taken
	
		self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath, modelName, tagName, partName, iDFlags, weapon );
		
		// don't allow people to destroy equipment on their team if FF is off
		if ( !maps\mp\gametypes\_weapons::friendlyFireCheck( self.owner, attacker ) )
			continue;

		if ( IsDefined( iDFlags ) && ( iDFlags & level.iDFLAGS_PENETRATION ) )
			self.wasDamagedFromBulletPenetration = true;

		// up the damage for airstrikes, stealth bombs, and bomb sites
		switch( weapon )
		{
		case "artillery_mp":
		case "stealth_bomb_mp":
			damage *= 4;
			break;
		case "bomb_site_mp":
			damage = self.maxHealth;
			break;
		}

		if ( meansOfDeath == "MOD_MELEE" )
			self.damageTaken += self.maxHealth;

		modifiedDamage = damage;
		if ( isPlayer( attacker ) )
		{
			attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "sentry" );

			if ( attacker _hasPerk( "specialty_armorpiercing" ) )
			{
				modifiedDamage = damage * level.armorPiercingMod;			
			}			
		}

		// in case we are shooting from a remote position, like being in the osprey gunner shooting this
		if( IsDefined( attacker.owner ) && IsPlayer( attacker.owner ) )
		{
			attacker.owner maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "sentry" );
		}
		
		if( IsDefined( weapon ) )
		{
			switch( weapon )
			{
			case "ac130_105mm_mp":
			case "ac130_40mm_mp":
			case "stinger_mp":
			case "javelin_mp":
			case "remote_mortar_missile_mp":		
			case "remotemissile_projectile_mp":
				self.largeProjectileDamage = true;
				modifiedDamage = self.maxHealth + 1;
				break;

			case "artillery_mp":
			case "stealth_bomb_mp":
				self.largeProjectileDamage = false;
				modifiedDamage += ( damage * 4 );
				break;

			case "bomb_site_mp":
			case "emp_grenade_mp":
				self.largeProjectileDamage = false;
				modifiedDamage = self.maxHealth + 1;
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
		
			self notify ( "fakedeath" );
		}
	}
}

laser_handleFakeDeath()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	for ( ;; )
	{
		self waittill ( "fakedeath" );
		
		// this handles cases of deletion
		if ( !IsDefined( self ) )
			return;
	
		self laser_setInactive();
		self SetSentryOwner( undefined );
		if ( level.teamBased )
		{
			self.team = undefined;
		}
		
		if( IsDefined( self.ownerTrigger ) )
			self.ownerTrigger delete();
	
		self playSound( "sentry_explode" );		
	
		if ( IsDefined( self.inUseBy ) )//TODO: I don't think I'm using this. take it out.
		{
			playFxOnTag( common_scripts\utility::getFx( "sentry_explode_mp" ), self, "tag_origin" );
			playFxOnTag( common_scripts\utility::getFx( "sentry_smoke_mp" ), self, "tag_aim" );
			
			self.inUseBy.turret_overheat_bar maps\mp\gametypes\_hud_util::destroyElem();
			self.inUseBy maps\mp\killstreaks\_autosentry::restorePerks();
			self.inUseBy maps\mp\killstreaks\_autosentry::restoreWeapons();				
			
			self notify( "deleting" );
			wait ( 1.0 );
			StopFXOnTag( common_scripts\utility::getFx( "sentry_explode_mp" ), self, "tag_origin" );
			StopFXOnTag( common_scripts\utility::getFx( "sentry_smoke_mp" ), self, "tag_aim" );
		}	
		else
		{		
			playFxOnTag( common_scripts\utility::getFx( "sentry_explode_mp" ), self, "tag_aim" );
			wait ( 1.5 );		
			self playSound( "sentry_explode_smoke" );
			for ( smokeTime = 8; smokeTime > 0; smokeTime -= 0.4 )
			{
				playFxOnTag( common_scripts\utility::getFx( "sentry_smoke_mp" ), self, "tag_aim" );
				wait ( 0.4 );
			}
		}
	}
}

/*
=============
///ScriptDocBegin
"Name: tryUseMPLaser( <lifeId> )"
"Summary: function called when a player tries to use the mp_laser2 map-based killstreak"
"Module: Entity"
"CallOn: a player"
"MandatoryArg: <lifeId>: "
"Example: level.killstreakFuncs["mp_laser2"] = ::tryUseMPLaser;"
"SPMP: MP"
///ScriptDocEnd
=============
*/
tryUseMPLaser( lifeId )
{
	if ( isDefined( level.mp_laser_owner ) )
	{
		self iPrintLnBold( &"MP_LASER_IN_USE" );
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

	result = setMPLaserPlayer( self );
	
	if ( IsDefined( result ) && result )
	{
		self maps\mp\_matchdata::logKillstreakEvent( "mp_laser2", self.origin );
		
		if ( IsDefined( level.sentryGun ) )
		{
			
			level.sentryGun SetDefaultDropPitch( 5 );
			level.sentryGun laser_setOwner( self );
			self laser_setPlaceSentry( level.sentryGun, level.sentryGun.sentryType );
			level.sentryGun thread laser_sentry_timeOut();
		}
	}

	return ( IsDefined( result ) && result );
}


setMPLaserPlayer( player )
{
	if( IsDefined( level.mp_laser_owner ) )
		return false;
	
	level.mp_laser_owner = player;
	
	thread teamPlayerCardSplash( "used_mp_laser2", player );
	
	return true;
}

laser_setOwner( owner )
{
	assertEx( IsDefined( owner ), "laser_setOwner() called without owner specified" );
	assertEx( isPlayer( owner ), "laser_setOwner() called on non-player entity type: " + owner.classname );

	self.owner = owner;

	self SetSentryOwner( self.owner );
	self SetTurretMinimapVisible( true, "sam_turret" );
	
	if ( level.teamBased )
	{
		self.team = self.owner.team;
		self setTurretTeam( self.team );
	}
	
	self thread laser_handleOwnerDisconnect();
}

laser_handleOwnerDisconnect()
{
	self endon ( "death" );
	self endon ( "fakedeath" );
	level endon ( "game_ended" );
	
	self notify ( "laser_handleOwnerDisconnect" );
	self endon ( "laser_handleOwnerDisconnect" );//only have one of these threads running at a time
	
	self.owner common_scripts\utility::waittill_any( "disconnect", "joined_team", "joined_spectators" );
	
	self notify( "fakedeath" );
}

laser_setPlaceSentry( sentryGun, sentryType )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	player = self;
	
	if ( ! player maps\mp\_utility::validateUseStreak() )
	return false;
	
	player.last_sentry = sentryType;
	sentryGun laser_setPlaced( self );		
	return true;
}

laser_setPlaced( player )
{
	//TODO: don't need this since the model is the same //self setModel( level.sentrySettings[ self.sentryType ].modelBase );

	// failsafe check, for some reason this could be manual and setSentryCarried doesn't like that
	if( self GetMode() == "manual" )
		self SetMode( level.sentrySettings[ self.sentryType ].sentryModeOff );

	self setSentryCarrier( undefined );
	self setCanDamage( true );

	//TODO: do we need to define this? is it false by default? will killstreaks  work correctly without this?
	if( IsDefined( self.owner ) )
		self.owner.isCarrying = false;

	self laser_setActive( player );
	
	self thread playLaserCoreEvent();
	self playSound( "sentry_gun_plant" );

	self notify ( "placed" );
}

playLaserCoreEvent()
{
	if( isDefined( self.FxEnts["steam"] ) )
	{
		for( i=0; i<self.FxEnts["steam"].size; i++ )
		{
			PlayFXOnTag( level.laser_fx[ "laser_steam" ], self.FxEnts["steam"][i], "tag_origin" );
		}
	}
	
	if( isDefined( self.fxEnts["lights"] ) )
		self.fxEnts["lights"] show();
}

StopLaserCoreEvent()
{
	if( isDefined( self.fxEnts["steam"] ) )
	{
		for( i=0; i<self.fxEnts["steam"].size; i++ )
		{
			StopFXOnTag( level.laser_fx[ "laser_steam" ], self.fxEnts["steam"][i], "tag_origin" );
		}
	}
	
	if( isDefined( self.fxEnts["lights"] ) )
		self.fxEnts["lights"] hide();
}

laser_setInactive()
{
	self setMode( level.sentrySettings[ self.sentryType ].sentryModeOff );
	
	//self makeUnusable();
	entNum = self GetEntityNumber();
	switch( self.sentryType )
	{
	case "gl_turret":
		break;
	default:
		self maps\mp\killstreaks\_autosentry::removeFromTurretList( entNum );
		break;
	}

	if ( level.teamBased )
	{
		self setTeamHeadIcon_large( "none", (0,0,0) );
	}
	else if ( IsDefined( self.owner ) )
	{
		self setTeamHeadIcon_large( "none", (0,0,0) );
	}
	
	if( isDefined( self.lifter ) )
	{
		self.lifter moveto( self.moveOrgs["bottom"], 7, 2, 2 );
	}
	
	laser_usableOffSwitch_off();
	
	self thread StopLaserCoreEvent();
	
	self SetDefaultDropPitch( 40 );
	level.mp_laser_owner = undefined;
	level.sentryGun SetTurretMinimapVisible( false );
	self SetTurretMinimapVisible( false );
	self setCanDamage( false );
}

laser_sentry_timeOut()
{
	self endon ( "death" );
	self endon ( "fakedeath" );
	level endon ( "game_ended" );
	
	lifeSpan = level.sentrySettings[ self.sentryType ].timeOut;
/#
	if( self.sentryType == "sky_laser_turret" )	
		lifeSpan = GetDvarInt( "scr_laser2_killstreak_duration", 60 );
#/
	
	while ( lifeSpan )
	{
		wait ( 1.0 );
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
		
		lifeSpan = max( 0, lifeSpan - 1.0 );
	}
	
	if ( IsDefined( self.owner ) )
	{
		self.owner thread leaderDialogOnPlayer( "sam_gone" );
	}
	self notify ( "fakedeath" );
}

laser_setActive( player )
{
	self SetMode( level.sentrySettings[ self.sentryType ].sentryModeOn );
	
	//self setCursorHint( "HINT_NOICON" );
	//self setHintString( level.sentrySettings[ self.sentryType ].hintString );
	
	if( level.sentrySettings[ self.sentryType ].headIcon )
	{
		if ( level.teamBased )
		{
			self setTeamHeadIcon_large( self.team, (0,0,600) );
			//level thread printAndSoundOnEveryone( player.team, getOtherTeam( player.team ), &"MP_LASERTURRET_TEAM", &"MP_LASERTURRET_ENEMY", "mp_laser_team_owns", "mp_laser_enemy_owns", "" );
		}
		else
		{
			self setTeamHeadIcon_large( self.team, (0,0,600) );
			//level thread printAndSoundOnEveryone( player.team, getOtherTeam( player.team ), &"MP_LASERTURRET_TEAM", &"MP_LASERTURRET_ENEMY", "mp_laser_team_owns", "mp_laser_enemy_owns", "" );
		}
	}

	//self makeUsable();

	foreach ( player in level.players )
	{
		entNum = self GetEntityNumber();
		self maps\mp\killstreaks\_autosentry::addToTurretList( entNum );
	}	

	if( self.shouldSplash )
	{
		level thread maps\mp\_utility::teamPlayerCardSplash( level.sentrySettings[ self.sentryType ].teamSplash, self.owner, self.owner.team );
		self.shouldSplash = false;
	}
	
	self thread laser_attackTargets();
	self thread laser_watchDisabled();
}

laser_usableOffSwitch_off()
{
	level.sentryGun.offSwitch["use_zone"] maps\mp\gametypes\_gameobjects::allowUse( "none" );
	level.sentryGun.offSwitch["switch_obj"] hide();
}

laser_usableOffSwitch_on()
{
	laserOwner = "none";
	if( isDefined( level.sentryGun.owner ) && isDefined( level.sentryGun.owner.team ) )
	{
		laserOwner = level.sentryGun.owner.team;
	}
	
	level.sentryGun.offSwitch["use_zone"].interactTeam = "enemy";
	level.sentryGun.offSwitch["use_zone"] maps\mp\gametypes\_gameobjects::setOwnerTeam( laserOwner );
	
	foreach( player in level.players )
	{
		if( player.team != laserOwner && laserOwner != "none" )
		{
			player.laserOffSwitch_isVisible = true;
			level.sentryGun.offSwitch["switch_obj"] showtoplayer( player );
		}
	}
}

setTeamHeadIcon_large( team, offset ) // "allies", "axis", "all", "none"
{
	if ( !level.teamBased )
		return;

	if ( !isDefined( self.entityHeadIconTeam ) ) 
	{
		self.entityHeadIconTeam = "none";
		self.entityHeadIcon = undefined;
	}

	shader = game["entity_headicon_" + team];	

	self.entityHeadIconTeam = team;
	
	if ( isDefined( offset ) )
		self.entityHeadIconOffset = offset;
	else
		self.entityHeadIconOffset = (0,0,0);

	self notify( "kill_entity_headicon_thread" );

	if ( team == "none" )
	{
		if ( isDefined( self.entityHeadIcon ) )
			self.entityHeadIcon destroy();
		return;
	}
	
	headIcon = newTeamHudElem( team );
	headIcon.archived = true;
	headIcon.x = self.origin[0] + self.entityHeadIconOffset[0];
	headIcon.y = self.origin[1] + self.entityHeadIconOffset[1];
	headIcon.z = self.origin[2] + self.entityHeadIconOffset[2];
	headIcon.alpha = 1;
	headIcon setShader( shader, 50, 50 );
	headIcon setWaypoint( false, false, false, true );
	self.entityHeadIcon = headIcon; 

	self thread maps\mp\_entityheadicons::keepIconPositioned();
	self thread maps\mp\_entityheadicons::destroyHeadIconsOnDeath();
}

setPlayerHeadIcon_large( player, offset ) // "allies", "axis", "all", "none"
{
	if ( level.teamBased )
		return;
	
	if ( !isDefined( self.entityHeadIconTeam ) ) 
	{
		self.entityHeadIconTeam = "none";
		self.entityHeadIcon = undefined;
	}

	self notify( "kill_entity_headicon_thread" );

	if ( !isDefined( player ) )
	{
		if ( isDefined( self.entityHeadIcon ) )
			self.entityHeadIcon destroy();
		return;
	}

	team = player.team;		
	self.entityHeadIconTeam = team;
	
	if ( isDefined( offset ) )
		self.entityHeadIconOffset = offset;
	else
		self.entityHeadIconOffset = (0,0,0);

	shader = game["entity_headicon_" + team];	
	
	headIcon = newClientHudElem( player );
	headIcon.archived = true;
	headIcon.x = self.origin[0] + self.entityHeadIconOffset[0];
	headIcon.y = self.origin[1] + self.entityHeadIconOffset[1];
	headIcon.z = self.origin[2] + self.entityHeadIconOffset[2];
	headIcon.alpha = 1;
	headIcon setShader( shader, 50, 50 );
	headIcon setWaypoint( false, false, false, true );
	self.entityHeadIcon = headIcon; 

	self thread maps\mp\_entityheadicons::keepIconPositioned();
	self thread maps\mp\_entityheadicons::destroyHeadIconsOnDeath();
}

laser_watchDisabled()
{
	self endon ( "death" );
	self endon ( "fakedeath" );
	level endon ( "game_ended" );
	
	self notify ( "laser_watchDisabled" );
	self endon ( "laser_watchDisabled" );//only have one of these threads running at a time

	while( true )
	{
		// this handles any flash or concussion damage
		self waittill( "emp_damage", attacker, duration );//TODO: rename "emp_damage". It is really poorly named. It actually is coming from concussion and frags but not the emp. look at laser_handleDamage or sentry_handleDamage for the real emp damage.

		PlayFXOnTag( common_scripts\utility::getfx( "sentry_explode_mp" ), self, "tag_aim" );

		self SetDefaultDropPitch( 40 );
		self SetMode( level.sentrySettings[ self.sentryType ].sentryModeOff );
		laser_usableOffSwitch_off();

		wait( duration );

		self SetDefaultDropPitch( 5 );
		self SetMode( level.sentrySettings[ self.sentryType ].sentryModeOn );
		laser_usableOffSwitch_on();
	}
}

laser_attackTargets() // self == sam
{
	self endon ( "death" );
	self endon ( "fakedeath" );
	level endon ( "game_ended" );
	
	self notify ( "laser_attackTargets" );
	self endon ( "laser_attackTargets" );//only have one of these threads running at a time

	self.samTargetEnt = undefined;
	self.samMissileGroups = [];
	
	if( isDefined( self.lifter ) )
	{
		self setCanDamage( false );
		self.lifter moveto(  self.moveOrgs["top"], 7, 2, 2 );
		self.lifter waittill( "movedone" );
		self setCanDamage( true );
	}
	
	laser_usableOffSwitch_on();

	while( true )
	{
		self.samTargetEnt = maps\mp\killstreaks\_autosentry::sam_acquireTarget();
		self sam_fireOnTarget();
		wait( 0.05 );
	}
}


/*
=============
///ScriptDocBegin
"Name: fireLaserBeam()"
"Summary: Performs a trace and creates a damage radius at the point of contact."
"Module: Entity"
"CallOn: a sentry, turret, or sam"
"Example: sentry thread fireLaserBeam()"
"SPMP: MP"
///ScriptDocEnd
=============
*/

//Ripped this out of _autosentry.gsc and added playing of FX.
sam_watchLaser() // self == sam turret
{
	self endon( "death" );
	level endon( "game_ended" );
	
	self LaserOn();
	self.laser_on = true;
	
	//Start the deadly laser beam's FX.
	wait ( 0.5 );
	PlayFXOnTag( level.laser_fx[ "beahm" ], self, "tag_laser" );
	PlayFXOnTag( level.laser_fx[ "laser_charge" ], self.FxEnts["charge_up"], "tag_origin" );
	level thread laserCoreDamageArea_activated();
	
	//Play the laser sound effect.
	self thread play_loop_sound_on_entity( level.laser_sfx );

	while( IsDefined( self.samTargetEnt ) && IsDefined( self GetTurretTarget( true ) ) && self GetTurretTarget( true ) == self.samTargetEnt )
	{
		wait( 0.05 );
	}

	self LaserOff();
	self.laser_on = false;
	
	//Stop the deadly laser beam's FX.
	StopFXOnTag( level.laser_fx[ "beahm" ], self, "tag_laser" );
	StopFXOnTag( level.laser_fx[ "laser_charge" ], self.FxEnts[ "charge_up" ], "tag_origin" );
	level thread laserCoreDamageArea_deactivated();
	//Stop the laser sound effect.
	self stop_loop_sound_on_entity( level.laser_sfx );
}


sam_fireOnTarget() // self == sam turret
{
	// locked on to target, turn on laser and fire
	if( IsDefined( self.samTargetEnt ) )
	{
		// because we hide the ac130 and don't really delete it
		if( self.samTargetEnt == level.ac130.planemodel && !IsDefined( level.ac130player ) )
		{
			self.samTargetEnt = undefined;
			self ClearTargetEntity();
			return;
		}

		self SetTargetEntity( self.samTargetEnt );
		self waittill( "turret_on_target" );
		if( !IsDefined( self.samTargetEnt ) )
			return;
		
		// turn on the laser, also watch for if the target is crashing or leaving
		if( !self.laser_on )
		{
			self thread sam_watchLaser();
			self thread maps\mp\killstreaks\_autosentry::sam_watchCrashing();
			self thread maps\mp\killstreaks\_autosentry::sam_watchLeaving();
			self thread maps\mp\killstreaks\_autosentry::sam_watchLineOfSight();
		}

		wait( 0.5 );

		if( !IsDefined( self.samTargetEnt ) )
			return;

		// because we hide the ac130 and don't really delete it
		if( self.samTargetEnt == level.ac130.planemodel && !IsDefined( level.ac130player ) )
		{
			self.samTargetEnt = undefined;
			self ClearTargetEntity();
			return;
		}
		
		// need to shoot the turret so it'll show up on the mini-map as it shoots, it will shoot blanks
		self ShootTurret();
		
		//Use a damage radius to deal damage to aerial targets.
		self fireLaserBeam();
	}
}

fireLaserBeam()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	trace_start = self GetTagOrigin( "tag_laser" );
	trace_vector = AnglesToForward( self GetTagAngles( "tag_laser" ) );
	trace_end = trace_start + 15000 * trace_vector;
	LaserTraceData = BulletTrace( trace_start, trace_end, true, self );
	
	//HACK: The target is an AC-130. Place a RadiusDamage directly on the AC-130's position because the BulletTrace is not hitting the AC-130.
	if ( self.samTargetEnt == level.ac130.planemodel && IsDefined( level.ac130player ) )
	{
		//TODO: add some VO notifying the AC-130 user that they are getting shot down by a LAZER!
		RadiusDamage( level.ac130.planeModel.origin, 512, 100, 100, self.owner, "MOD_EXPLOSIVE", "killstreak_laser2_mp" );
	}
	else
	{
		RadiusDamage( LaserTraceData[ "position" ], 512, 200, 200, self.owner, "MOD_EXPLOSIVE", "killstreak_laser2_mp" );
	}
}

//Laser Power Core stuff

laserCoreDamageArea_activated()
{
	level endon( "game_ended" );
	
	level notify( "laserCore_activated" );
	
	if( isDefined( level.sentryGun.coreDamageTrigs ) )
	{
		foreach ( trig in level.sentryGun.coreDamageTrigs )
		{
			trig thread watchPlayerEnterLaserCore();
			trig trigger_on();
		}
	}
}

laserCoreDamageArea_deactivated()
{
	level endon( "game_ended" );
	
	level notify( "laserCore_deactivated" );
	
	if( isDefined( level.sentryGun.coreDamageTrigs ) )
	{
		foreach ( trig in level.sentryGun.coreDamageTrigs )
		{
			trig trigger_off();
		}
	}
	
}

watchPlayerEnterLaserCore()
{
	//self is trigger
	
	level endon( "game_ended" );
	level endon( "laserCore_deactivated" );
	
	while( true )
	{
		self waittill( "trigger", ent );
		if ( !isPlayer( ent ) )
			continue;
		
		if ( !isAlive( ent ) )
			continue;
		
		if( isDefined( ent.inLaserCore ) && ent.inLaserCore )
		{
			continue;
		}

		if ( !isDefined( ent.inLaserCore ) || ent.inLaserCore == false )
		{
			ent.inLaserCore = true;
			self thread watchPlayerLeaveLaserCore( ent );
			ent thread laserCoreEffect( self );
			ent thread WatchPlayerDeath();
		}
	}
		
}

watchPlayerLeaveLaserCore( player )
{
	//self is trigger
	
	player endon( "death" );
	player endon( "disconnect" );
	level endon( "game_ended" );
	
	while( player isTouching( self ) )
	{
		wait( .05 );
	}
	
	player resetPlayerLaserCoreValues();
}

laserCoreEffect( trig )
{
	//self is player
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	self endon( "left_LaserCoreTrigger" );
	
	self.poison = 0;
	shellshockName = level.sentrySettings[ "sky_laser_turret" ].coreShellshock;
	//self thread soundWatcher( self );
	
	self VisionSetNakedForPlayer( "mpnuke", .5 );
	self shellshock( shellshockName, 60);
	
	while (1)
	{
		self.poison ++;
		
		switch( self.poison )
		{
			case 1:				  

				self ViewKick( 1, self.origin );
				break;
			case 3:				  
				self ViewKick( 3, self.origin );
				self dolaserCoreDamage(15);
				break;
			case 4:
				self ViewKick( 15, self.origin );
				self dolaserCoreDamage(25);
				break;
			case 6:
				self ViewKick( 75, self.origin );
				self dolaserCoreDamage(45);
				break;
			case 8:
				self ViewKick( 127, self.origin );
				self dolaserCoreDamage(175);

				break;
		}
		wait(1);
	}
	wait(5);
}

WatchPlayerDeath()
{
	self common_scripts\utility::waittill_any( "disconnect", "joined_team", "joined_spectators" );
	
	level notify( "laserCore_deactivated" );
	self resetPlayerLaserCoreValues();
}

resetPlayerLaserCoreValues()
{
	self notify( "left_LaserCoreTrigger" );
	if( isDefined( self.inLaserCore ) )
		self.inLaserCore = undefined;
	self stopShellShock();
	self VisionSetNakedForPlayer( "", .5 );
}

dolaserCoreDamage( iDamage )
{
	if( !isdefined( level.sentryGun.owner ) )
		return;
	
	//TODO:Handle friendly fire
	//TODO: change the weapon to the laser2 weapon and update matchdata.def
	
	self thread [[ level.callbackPlayerDamage ]](
	self,// eInflictor The entity that causes the damage.( e.g. a turret )
	level.sentryGun.owner,// eAttacker The entity that is attacking.
	iDamage,// iDamage Integer specifying the amount of damage done
	0,// iDFlags Integer specifying flags that are to be applied to the damage
	"MOD_GRENADE",// sMeansOfDeath Integer specifying the method of death
	"killstreak_laser2_mp",// sWeapon The weapon number of the weapon used to inflict the damage
	self.origin,// vPoint The point the damage is from?
	( 0,0,0 ) - self.origin,// vDir The direction of the damage
	"none",// sHitLoc The location of the hit
	0// psOffsetTime The time offset for the damage
	);
}