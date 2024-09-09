#include maps\mp\_utility;
#include common_scripts\utility;


init()
{
	SetDvarIfUninitialized( "mp_refraction_killstreak_duration", 25 );
	
	level.mp_refraction_InUse = false;
	level.refraction_turrets_alive = 0;
	level.refraction_turrets_moved_down = 0;
	level.mp_refraction_owner = undefined;
	
	level.killstreakFuncs["mp_refraction"] = ::tryUseMPRefraction;
	
	level.sentrySettings[ "refraction_turret" ] = spawnStruct();
	level.sentrySettings[ "refraction_turret" ].health =				999999;		// keep it from dying anywhere in code
	level.sentrySettings[ "refraction_turret" ].maxHealth =				1000;		// this is the health we'll check
	level.sentrySettings[ "refraction_turret" ].burstMin =				20;
	level.sentrySettings[ "refraction_turret" ].burstMax =				120;
	level.sentrySettings[ "refraction_turret" ].pauseMin =				0.15;
	level.sentrySettings[ "refraction_turret" ].pauseMax =				0.35;
	level.sentrySettings[ "refraction_turret" ].sentryModeOn =			"sentry";
	level.sentrySettings[ "refraction_turret" ].sentryModeOff =			"sentry_offline";
	level.sentrySettings[ "refraction_turret" ].timeOut =				90.0;
	level.sentrySettings[ "refraction_turret" ].spinupTime =			0.05;
	level.sentrySettings[ "refraction_turret" ].overheatTime =			8.0;
	level.sentrySettings[ "refraction_turret" ].cooldownTime =			0.1;
	level.sentrySettings[ "refraction_turret" ].fxTime =				0.3;
	level.sentrySettings[ "refraction_turret" ].streakName =			"sentry";
	level.sentrySettings[ "refraction_turret" ].weaponInfo =			"refraction_turret_mp";
	level.sentrySettings[ "refraction_turret" ].modelBase =				"refraction_turret";
	level.sentrySettings[ "refraction_turret" ].modelPlacement =		"sentry_minigun_weak_obj";
	level.sentrySettings[ "refraction_turret" ].modelPlacementFailed =	"sentry_minigun_weak_obj_red";
	level.sentrySettings[ "refraction_turret" ].modelDestroyed =		"sentry_minigun_weak_destroyed";
	level.sentrySettings[ "refraction_turret" ].hintString =			&"SENTRY_PICKUP";
	level.sentrySettings[ "refraction_turret" ].headIcon =				true;
	level.sentrySettings[ "refraction_turret" ].teamSplash =			"used_sentry";
	level.sentrySettings[ "refraction_turret" ].shouldSplash =			false;
	level.sentrySettings[ "refraction_turret" ].voDestroyed =			"sentry_destroyed";
	
	level.refraction_turrets = turret_setup();
	
	//Spawn the 4 turrets that will remain in the level for the duration of the match.
	thread spawnRefractionTurrets();
	
	for ( i = 0; i < level.refraction_turrets.size; i++ )
	{
		thread turret_teleport_down( level.refraction_turrets[i] );
	}
	
	level.turret_movement_sound = "mp_refraction_turret_movement1";
	level.turret_movement2_sound = "mp_refraction_turret_movement2";
	level.turret_movement3_sound = "mp_refraction_turret_movement3";
}


/*
=============
///ScriptDocBegin
"Name: tryUseMPRefraction( <lifeId> )"
"Summary: function called when a player tries to use the mp_refraction map-based killstreak"
"Module: Entity"
"CallOn: a player"
"MandatoryArg: <lifeId>: "
"Example: level.killstreakFuncs["mp_refraction"] = ::tryUseMPRefraction;"
"SPMP: MP"
///ScriptDocEnd
=============
*/
tryUseMPRefraction( lifeId )
{
	if ( isDefined( level.mp_refraction_owner ) || level.mp_refraction_InUse )
	{
		self iPrintLnBold( &"MP_REFRACTION_IN_USE" );
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

	result = setRefractionTurretPlayer( self );
	
	if ( IsDefined( result ) && result )
	{
		self maps\mp\_matchdata::logKillstreakEvent( "mp_refraction", self.origin );
	}
	
	return result;
}


/*
=============
///ScriptDocBegin
"Name: refractionTurretTimer()"
"Summary: notifies after mp_refraction_killstreak_duration is up."
"Module: Entity"
"CallOn: the level"
"Example: level thread refractionTurretTimer();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
refractionTurretTimer()
{
	self endon( "game_ended" );
	
	wait_time = GetDvarInt( "mp_refraction_killstreak_duration", 25 );
	while ( wait_time > 0 )
	{
		wait( 1 );
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
		wait_time--;
		
		//End this thread if the killstreak is no longer in use. For example, end it if all the turrets are killed.
		if ( level.mp_refraction_InUse == false )
		{
			return;
		}
	}
	
	//If the killstreak ended because of time, some turrets might still be alive. Notify death for all turrets to deactivate them.
	for ( i = 0; i < level.refraction_turrets.size; i++ )
	{
		level.refraction_turrets[i]["spawned_turret"] notify( "fake_refraction_death" );			//Using "fake_refraction_death" instead of "death" because "death" would detrimentally end some functionality taken from _autosentry.gsc.
	}
}


/*
=============
///ScriptDocBegin
"Name: monitorRefractionKillstreakOwnership()"
"Summary: frees up the refraction killstreak when the killstreak time is up or all turrets are disabled."
"Module: Entity"
"CallOn: the level"
"Example: level thread monitorRefractionKillstreakOwnership()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
monitorRefractionKillstreakOwnership()
{
	level endon( "game_ended" );
	
	//If any turrets are alive or any turrets are up... wait!
	while ( level.refraction_turrets_alive > 0 || level.refraction_turrets_moved_down < level.refraction_turrets.size )
	{
		wait( 0.05 );
	}
	
	unsetRefractionTurretPlayer();
}


/*
=============
///ScriptDocBegin
"Name: turretAnimationSequence()"
"Summary: moves the turrets up, rotates the guns, and moves the turrets down."
"Module: Entity"
"CallOn: a refraction turret (the array of pieces, including the ["spawned_turret"]"
"Example: level.refraction_turrets[i] thread turretAnimationSequence();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
turretAnimationSequence()
{
	thread turret_moveUP( self );
	
	self["spawned_turret"] waittill( "refraction_turret_moved_up" );
	
	self["spawned_turret"] setCanDamage( true );		//Make the turrets damageable AFTER they have finished moving up.
	self["spawned_turret"] setCanRadiusDamage( true );
	
	self["spawned_turret"] waittill( "fake_refraction_death" );
	
	thread turret_moveDOWN( self );
}


/*
=============
///ScriptDocBegin
"Name: setRefractionTurretPlayer( <player> )"
"Summary: sets the owner of the Refraction turrets when a player uses the map-based killstreak."
"Module: Entity"
"CallOn: N/A"
"MandatoryArg: <player>: the player that used the killstreak"
"Example: result = setRefractionTurretPlayer( self );"
"SPMP: MP"
///ScriptDocEnd
=============
*/
setRefractionTurretPlayer( player )
{
	if( IsDefined( level.mp_refraction_owner ) )
		return false;
	
	level.mp_refraction_InUse = true;
	level.mp_refraction_owner = player;
	
	thread teamPlayerCardSplash( "used_mp_refraction", player );
	
	sentryType = "refraction_turret";
	
	for ( i = 0; i < level.refraction_turrets.size; i++ )
	{
		level.refraction_turrets_alive++;
		level.refraction_turrets_moved_down = 0;		//All the turrets will move up, so we're setting this value to zero. It will be incremented back up to 4 when all the turrets move back down, either via time or death.
		Assert( IsDefined( level.refraction_turrets[i]["spawned_turret"] ) );
		level.refraction_turrets[i] thread turretAnimationSequence();
		level.refraction_turrets[i]["spawned_turret"] sentry_setOwner( player );
		level.refraction_turrets[i]["spawned_turret"] SetLeftArc( 45 );
		level.refraction_turrets[i]["spawned_turret"] SetRightArc( 45 );
		level.refraction_turrets[i]["spawned_turret"] SetTopArc( 0 );
		level.refraction_turrets[i]["spawned_turret"].shouldSplash = false;
		level.refraction_turrets[i]["spawned_turret"].carriedBy = player;
		level.refraction_turrets[i]["spawned_turret"] sentry_setPlaced();
		level.refraction_turrets[i]["spawned_turret"] thread sentry_handleDamage();
		level.refraction_turrets[i]["spawned_turret"] thread sentry_handleDeath();
	}
	
	level thread refractionTurretTimer();
	level thread monitorRefractionKillstreakOwnership();

	return true;
}


/*
=============
///ScriptDocBegin
"Name: spawnRefractionTurrets()"
"Summary: uses SpawnTurret() to create a turret for each of the ground turrets in mp_refraction."
"Module: Entity"
"CallOn: N/A"
"Example: thread spawnRefractionTurrets();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
spawnRefractionTurrets()
{
	sentryType = "refraction_turret";
	
	for ( i = 0; i < level.refraction_turrets.size; i++ )
	{
		//TODO: place 4 sentry guns that will permanently stay in the map (they have no timeout and are invincible).
		level.refraction_turrets[i]["spawned_turret"] = SpawnTurret( "misc_turret", level.refraction_turrets[i]["turret_body"].origin, level.sentrySettings[ sentryType ].weaponInfo, false );
		level.refraction_turrets[i]["spawned_turret"] sentry_initSentry( sentryType );		//HACK: I'm calling sentry_initSentry() to do initial setup for the turrets. The turrets don't have an owner yet.
		level.refraction_turrets[i]["spawned_turret"] makeTurretSolid();			//We need to make turrets solid for them to be damageable...
		
		if ( level.refraction_turrets[i]["spawned_turret"].origin[0] < 0 )
		{
			//HACK: Danger, Will Robinson! Danger! Adding angle offsets based on where the turrets are positioned is janky!
			level.refraction_turrets[i]["spawned_turret"] LinkTo( level.refraction_turrets[i]["turret_body"], "", (0, 0, -10), (0, 180, 0) );
		}
		else
		{
			level.refraction_turrets[i]["spawned_turret"] LinkTo( level.refraction_turrets[i]["turret_body"], "", (0, 0, -10), (0, 0, 0)  );
		}
	}
}


/*
=============
///ScriptDocBegin
"Name: unsetRefractionTurretPlayer()"
"Summary: unsets the Refraction Turrets' owner - frees them up for someone else."
"Module: Entity"
"CallOn: N/A"
"Example: unsetRefractionTurretPlayer();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
unsetRefractionTurretPlayer()
{
	level.mp_refraction_owner = undefined;
	level.mp_refraction_InUse = false;
}


turret_setup()  //GET ALL FOUR TURRETS
{
	turrets = [];
	
	//HACK: handle situations where there are more or less than 4 turrets.
	for ( i = 0; i < 4; i++ )
	{
		turrets[i] = [];
		//get turret body, legs, and MoveTo positions for legs. HACK: using i as a char without a cast or something seems kinda dirty...
		turrets[i]["turret_body"] =						GetEnt("turret" + i + "_body_ks","targetname");
		turrets[i]["turret_body"].initial_origin =		turrets[i]["turret_body"].origin;
		
		turrets[i]["turret_head"] =						GetEnt("turret" + i + "_head_ks","targetname");
		turrets[i]["turret_head"].initial_origin =		turrets[i]["turret_head"].origin;
		
		turrets[i]["turret_leg0"] =						GetEnt("turret" + i + "_leg_ks0","targetname");
		turrets[i]["turret_leg0"].initial_origin =		turrets[i]["turret_leg0"].origin;
		turrets[i]["leg0_origin"] =						GetEnt(turrets[i]["turret_leg0"].target,"targetname");
		
		turrets[i]["turret_leg1"] =						GetEnt("turret" + i + "_leg_ks1","targetname");
		turrets[i]["turret_leg1"].initial_origin =		turrets[i]["turret_leg1"].origin;
		turrets[i]["leg1_origin"] =						GetEnt(turrets[i]["turret_leg1"].target,"targetname");
		
		turrets[i]["turret_leg2"] =						GetEnt("turret" + i + "_leg_ks2","targetname");
		turrets[i]["turret_leg2"].initial_origin =		turrets[i]["turret_leg2"].origin;
		turrets[i]["leg2_origin"] =						GetEnt(turrets[i]["turret_leg2"].target,"targetname");
		
		turrets[i]["turret_leg3"] =						GetEnt("turret" + i + "_leg_ks3","targetname");
		turrets[i]["turret_leg3"].initial_origin =		turrets[i]["turret_leg3"].origin;
		turrets[i]["leg3_origin"] =						GetEnt(turrets[i]["turret_leg3"].target,"targetname");
		
		//Get the sound origin location and spawn a tag_origin to play sounds on.
		sound_origin =									GetEnt("sound_movement" + i, "targetname");
		turrets[i]["sound_tag"] =						spawn_tag_origin();
		turrets[i]["sound_tag"].origin =				sound_origin.origin;
	}
	
	return turrets;
}


turret_moveUP(turret)  //TURRETS MOVE UP FROM UNDERGROUND
{
	IPrintLnBold("Bleed Time");

	turret["turret_body"] MoveZ(72,1,.3,.7);
	turret["turret_head"] MoveZ(72,1,.3,.7);
	turret["turret_leg0"] MoveZ(72,1,.3,.7);
	turret["turret_leg1"] MoveZ(72,1,.3,.7);
	turret["turret_leg2"] MoveZ(72,1,.3,.7);
	turret["turret_leg3"] MoveZ(72,1,.3,.7);
	
	
	turret["sound_tag"] thread Play_Sound_on_Tag( level.turret_movement_sound, "tag_origin" );
	
	
	level thread common_scripts\utility::activate_clientside_exploder(1); //smoke fx
	level thread common_scripts\utility::activate_clientside_exploder(2);
	level thread common_scripts\utility::activate_clientside_exploder(3);
	level thread common_scripts\utility::activate_clientside_exploder(4);
	level thread common_scripts\utility::activate_clientside_exploder(5);
	level thread common_scripts\utility::activate_clientside_exploder(6);
	level thread common_scripts\utility::activate_clientside_exploder(7);
	level thread common_scripts\utility::activate_clientside_exploder(8);
	
	
	wait(1);
	
	turret["sound_tag"] thread Play_Sound_on_Tag(level.turret_movement2_sound,"tag_origin");
	
	turret["turret_leg0"] MoveTo(turret["leg0_origin"].origin,1,.3,.7);
	turret["turret_leg1"] MoveTo(turret["leg1_origin"].origin,1,.3,.7);
	turret["turret_leg2"] MoveTo(turret["leg2_origin"].origin,1,.3,.7);
	turret["turret_leg3"] MoveTo(turret["leg3_origin"].origin,1,.3,.7);
	
	wait(1);
	
	turret["sound_tag"] thread Play_Sound_on_Tag(level.turret_movement3_sound,"tag_origin");
	
	turret["spawned_turret"] notify( "refraction_turret_moved_up" );
}


turret_moveDOWN(turret)
{
	turret["turret_leg0"] MoveTo((turret ["turret_leg0"].initial_origin[0],turret ["turret_leg0"].initial_origin[1],turret ["turret_leg0"].origin[2]),2,.5,1.5);
	turret["turret_leg1"] MoveTo((turret ["turret_leg1"].initial_origin[0],turret ["turret_leg1"].initial_origin[1],turret ["turret_leg1"].origin[2]),2,.5,1.5);
	turret["turret_leg2"] MoveTo((turret ["turret_leg2"].initial_origin[0],turret ["turret_leg2"].initial_origin[1],turret ["turret_leg2"].origin[2]),2,.5,1.5);
	turret["turret_leg3"] MoveTo((turret ["turret_leg3"].initial_origin[0],turret ["turret_leg3"].initial_origin[1],turret ["turret_leg3"].origin[2]),2,.5,1.5);
	
	wait( 2 );
	
	turret["turret_body"] MoveZ(-72,3,.5,1.5);
	turret["turret_head"] MoveZ(-72,3,.5,1.5);
	turret["turret_leg0"] MoveZ(-72,3,.5,1.5);
	turret["turret_leg1"] MoveZ(-72,3,.5,1.5);
	turret["turret_leg2"] MoveZ(-72,3,.5,1.5);
	turret["turret_leg3"] MoveZ(-72,3,.5,1.5);
	
	wait( 5 );			//Give a few seconds of buffer time before registering that the turret is down.
	
	level.refraction_turrets_moved_down++;
}


turret_teleport_down(turret)
{
	turret["turret_body"] MoveZ(-72,.05,0,0);
	turret["turret_head"] MoveZ(-72,.05,0,0);
	turret["turret_leg0"] MoveZ(-152,.05,0,0);
	turret["turret_leg1"] MoveZ(-152,.05,0,0);
	turret["turret_leg2"] MoveZ(-152,.05,0,0);
	turret["turret_leg3"] MoveZ(-152,.05,0,0);
}


////////////////////////////////////
//STUFF TAKEN FROM _autosentry.gsc
////////////////////////////////////

/*
=============
///ScriptDocBegin
"Name: sentry_setPlaced()"
"Summary: among other things, sets the sentry turret down and puts it into play."
"Module: Entity"
"CallOn: a turret"
"Example: refraction_turret["spawned_turret"] maps\mp\killstreaks\_autosentry::sentry_setPlaced();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
sentry_setPlaced()
{
//	self setModel( level.sentrySettings[ self.sentryType ].modelBase );			//Don't need this from original in _autosentry.gsc because I set the model ahead of time.

	// failsafe check, for some reason this could be manual and setSentryCarried doesn't like that
//	if( self GetMode() == "manual" )			//Don't need this from original in _autosentry.gsc.
//		self SetMode( level.sentrySettings[ self.sentryType ].sentryModeOff );
	
	self setSentryCarrier( undefined );
//	self setCanDamage( true );			//Don't need this from original in _autosentry.gsc.
	
	//	JDS TODO: - turret aligns to ground normal which the player will align to when they mount the turret
	//						- temp fix to keep up vertical
//	switch( self.sentryType )			//Don't need this from original in _autosentry.gsc.
//	{
//	case "minigun_turret":
//	case "gl_turret":
//		self.angles = self.carriedBy.angles;
//		// show the pickup message
//		if( IsAlive( self.originalOwner ) )
//			self.originalOwner setLowerMessage( "pickup_hint", level.sentrySettings[ self.sentryType ].ownerHintString, 3.0, undefined, undefined, undefined, undefined, undefined, true );
//		// spawn a trigger so we know if the owner is within range to pick it up
//		self.ownerTrigger = Spawn( "trigger_radius", self.origin + ( 0, 0, 1 ), 0, 105, 64 );
//		assert( IsDefined( self.ownerTrigger ) );
//		self.originalOwner thread turret_handlePickup( self );
//		self thread turret_handleUse();
//		break;
//	default:
//		break;
//	}
	
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
//	self setCursorHint( "HINT_NOICON" );
//	self setHintString( level.sentrySettings[ self.sentryType ].hintString );
	
	if( level.sentrySettings[ self.sentryType ].headIcon )
	{
		if ( level.teamBased )
			self maps\mp\_entityheadicons::setTeamHeadIcon( self.team, (0,0,65) );
		else
			self maps\mp\_entityheadicons::setPlayerHeadIcon( self.owner, (0,0,65) );
	}

//	self makeUsable();			//Don't need this from original in _autosentry.gsc.
//
//	foreach ( player in level.players )
//	{
//		switch( self.sentryType )
//		{
//		case "minigun_turret":
//		case "gl_turret":
//			self enablePlayerUse( player );
//			break;
//		default:
//			entNum = self GetEntityNumber();
//			self addToTurretList( entNum );
//			
//			if( player == self.owner )
//				self enablePlayerUse( player );
//			else
//				self disablePlayerUse( player );
//			break;
//		}
//	}	

//	if( self.shouldSplash )			//Don't need this from original in _autosentry.gsc.
//	{
//		level thread teamPlayerCardSplash( level.sentrySettings[ self.sentryType ].teamSplash, self.owner, self.owner.team );
//		self.shouldSplash = false;
//	}

//	if( self.sentryType == "sam_turret" )			//Don't need this from original in _autosentry.gsc.
//	{
//		self thread sam_attackTargets();
//	}

//	self thread sentry_watchDisabled();			//Don't need this from original in _autosentry.gsc.
}


//HACK: I removed all references to the owner argument. This is because the sentry doesn't have an owner when it is first created.
sentry_initSentry( sentryType ) // self == sentry, turret, sam
{
	self.sentryType = sentryType;
	self.canBePlaced = true;

	self setModel( level.sentrySettings[ self.sentryType ].modelBase );
//	self.shouldSplash = true; // we only want to splash on the first placement			//Don't need this from original in _autosentry.gsc.

//	self setCanDamage( true );			//Don't need this from original in _autosentry.gsc.
	switch( sentryType )
	{
//	case "minigun_turret":			//Don't need this from original in _autosentry.gsc.
//	case "gl_turret":
//		self SetLeftArc( 80 );
//		self SetRightArc( 80 );
//		self SetBottomArc( 50 );
//		self SetDefaultDropPitch( 0.0 );
//		self.originalOwner = owner;
//		break;
//	case "sam_turret":
//		self makeTurretInoperable();
//		self SetLeftArc( 180 );
//		self SetRightArc( 180 );
//		self SetTopArc( 80 );
//		self SetDefaultDropPitch( -89.0 );	// setting this mainly prevents Turret_RestoreDefaultDropPitch() from running
//		self.laser_on = false;
//		
//		// needs a kill cam ent
//		killCamEnt = Spawn( "script_model", self GetTagOrigin( "tag_laser" ) );
//		killCamEnt LinkTo( self );
//		self.killCamEnt = killCamEnt;
//		self.killCamEnt SetScriptMoverKillCam( "explosive" );
//		break;
	default:
		self makeTurretInoperable();
		self SetDefaultDropPitch( 0.0 );	// setting this mainly prevents Turret_RestoreDefaultDropPitch() from running
		break;
	}
	
	self setTurretModeChangeWait( true );
//	self setConvergenceTime( .25, "pitch" );
//	self setConvergenceTime( .25, "yaw" );
	self maps\mp\killstreaks\_autosentry::sentry_setInactive();
	
//	self sentry_setOwner( owner );			//Moving this out of init. Only want to set owner when someone calls the killstreak.
//	self thread sentry_handleDamage();		//Moving this out to setRefractionTurretPlayer( player ) - when the turrets are activated.
//	self thread sentry_handleDeath();		//Moving this out to setRefractionTurretPlayer( player ) - when the turrets are activated.
//	self thread sentry_timeOut();			//Don't need this from original in _autosentry.gsc.
	
	switch( sentryType )
	{
//	case "minigun_turret":			//Don't need this from original in _autosentry.gsc.
//		self.momentum = 0;
//		self.heatLevel = 0;
//		self.overheated = false;		
//		self thread sentry_heatMonitor();
//		break;
//	case "gl_turret":
//		self.momentum = 0;
//		self.heatLevel = 0;
//		self.cooldownWaitTime = 0;
//		self.overheated = false;		
//		self thread turret_heatMonitor();
//		self thread turret_coolMonitor();
//		break;
//	case "sam_turret":
//		self thread maps\mp\killstreaks\_autosentry::sentry_handleUse();
//		self thread maps\mp\killstreaks\_autosentry::sentry_beepSounds();
//		break;
	default:
		self thread maps\mp\killstreaks\_autosentry::sentry_handleUse();
		self thread maps\mp\killstreaks\_autosentry::sentry_attackTargets();
//		self thread maps\mp\killstreaks\_autosentry::sentry_beepSounds();
		break;
	}
}


sentry_handleDeath()
{
	self waittill ( "fake_refraction_death" );

	// this handles cases of deletion
	if ( !IsDefined( self ) )
		return;
	
//	self setModel( level.sentrySettings[ self.sentryType ].modelDestroyed );			//Don't need this from original in _autosentry.gsc.

	self maps\mp\killstreaks\_autosentry::sentry_setInactive();
//	self SetDefaultDropPitch( 40 );			//Don't need this from original in _autosentry.gsc.
	self SetSentryOwner( undefined );
	self SetTurretMinimapVisible( false );
	
	//Turning off the turrets' head icons. This is added functionality for the mp_refraction turrets.
	if( level.sentrySettings[ self.sentryType ].headIcon )
	{
		if ( level.teamBased )
			self maps\mp\_entityheadicons::setTeamHeadIcon( "none", (0,0,0) );
		else
			self maps\mp\_entityheadicons::setPlayerHeadIcon( "none", (0,0,0) );
	}
	
	level.refraction_turrets_alive--;
	
	self setCanDamage( false );		//Make the turrets non-damageable when they fake die.
	self setCanRadiusDamage( false );
	
//	if( IsDefined( self.ownerTrigger ) )			//Don't need this from original in _autosentry.gsc.
//		self.ownerTrigger delete();

//	self playSound( "sentry_explode" );
	
//	switch( self.sentryType )
//	{
//	case "minigun_turret":
//	case "gl_turret":
//		self.forceDisable = true;
//		self TurretFireDisable(); 
//		break;
//	default:
//		break;
//	}

//	if ( IsDefined( self.inUseBy ) )
//	{
//		playFxOnTag( getFx( "sentry_explode_mp" ), self, "tag_origin" );
//		playFxOnTag( getFx( "sentry_smoke_mp" ), self, "tag_aim" );
//		
//		self.inUseBy.turret_overheat_bar destroyElem();
//		self.inUseBy restorePerks();
//		self.inUseBy restoreWeapons();				
//		
//		self notify( "deleting" );
//		wait ( 1.0 );
//		StopFXOnTag( getFx( "sentry_explode_mp" ), self, "tag_origin" );
//		StopFXOnTag( getFx( "sentry_smoke_mp" ), self, "tag_aim" );
//	}	
//	else
//	{		
//		playFxOnTag( getFx( "sentry_explode_mp" ), self, "tag_aim" );
//		wait ( 1.5 );		
//		self playSound( "sentry_explode_smoke" );
//		for ( smokeTime = 8; smokeTime > 0; smokeTime -= 0.4 )
//		{
//			playFxOnTag( getFx( "sentry_smoke_mp" ), self, "tag_aim" );
//			wait ( 0.4 );
//		}
//		self notify( "deleting" );
//	}
		
//	if( IsDefined( self.killCamEnt ) )
//		self.killCamEnt delete();
//
//	self delete();
}


/*
=============
///ScriptDocBegin
"Name: sentry_setOwner( <owner> )"
"Summary: sets the owner of the spawned turret."
"Module: Entity"
"CallOn: a turret spawned by SpawnTurret()."
"MandatoryArg: <owner>: the player that used the refraction killstreak"
"Example: level.refraction_turrets[i]["spawned_turret"] sentry_setOwner( player );"
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
	self endon( "fake_refraction_death" );			//Ending this thread if the turret (self) dies by other means (damage, time).
	
	self.owner waittill_any( "disconnect", "joined_team", "joined_spectators" );
	
	self notify( "fake_refraction_death" );
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
	self endon( "fake_refraction_death" );
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
		
		// up the damage for airstrikes, stealth bombs, and bomb sites			//Don't need this from original in _autosentry.gsc.
//		switch( weapon )
//		{
//		case "artillery_mp":
//		case "stealth_bomb_mp":
//			damage *= 4;
//			break;
//		case "bomb_site_mp":
//			damage = self.maxHealth;
//			break;
//		}
//		
//		if ( meansOfDeath == "MOD_MELEE" )
//			self.damageTaken += self.maxHealth;
//		
//		modifiedDamage = damage;
//		if ( isPlayer( attacker ) )
//		{
//			attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "sentry" );
//			
//			if ( attacker _hasPerk( "specialty_armorpiercing" ) )
//			{
//				modifiedDamage = damage * level.armorPiercingMod;
//			}
//		}
		
//		// in case we are shooting from a remote position, like being in the osprey gunner shooting this
//		if( IsDefined( attacker.owner ) && IsPlayer( attacker.owner ) )
//		{
//			attacker.owner maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "sentry" );
//		}
		
		modifiedDamage = 0;
		
		if( IsDefined( weapon ) )
		{
			switch( weapon )
			{
//				case "ac130_105mm_mp":
//				case "ac130_40mm_mp":
//				case "stinger_mp":
//				case "javelin_mp":
//				case "remote_mortar_missile_mp":
//				case "remotemissile_projectile_mp":
//					self.largeProjectileDamage = true;
//					modifiedDamage = self.maxHealth + 1;
//					break;
//					
//				case "artillery_mp":
//				case "stealth_bomb_mp":
//					self.largeProjectileDamage = false;
//					modifiedDamage += ( damage * 4 );
//					break;
//				
//				case "bomb_site_mp":
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
			
			self notify( "fake_refraction_death" );
			return;
		}
	}
}
