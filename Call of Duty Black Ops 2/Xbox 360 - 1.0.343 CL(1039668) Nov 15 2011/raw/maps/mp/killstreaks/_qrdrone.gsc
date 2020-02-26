#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

#define UAV_REMOTE_FLY_TIME 60
#define UAV_REMOTE_AIM_ASSIST_RANGE 200
#define UAV_REMOTE_MAX_PAST_RANGE 200
#define UAV_REMOTE_MIN_HELI_PROXIMITY 150
#define UAV_REMOTE_MAX_HELI_PROXIMITY 300
#define UAV_REMOTE_PAST_RANGE_COUNTDOWN 6
#define UAV_REMOTE_HELI_RANGE_COUNTDOWN 3
#define UAV_REMOTE_COLLISION_RADIUS 18
#define UAV_REMOTE_Z_OFFSET -9

init()
{	
	// these looked like they were macros in IW script

	precacheModel( "veh_t6_drone_t_hawk_mp" );
	
	level.qrdrone_vehicle = "qrdrone_mp";
//	level.qrdrone_vehicle = "qrdrone_test_mp";
	
	precacheVehicle( level.qrdrone_vehicle );
	precacheItem( "killstreak_qrdrone_mp" );
	
	precacheShader( "veh_hud_target" );
	precacheShader( "veh_hud_target_marked" );
	precacheShader( "veh_hud_target_unmarked" );
	precacheShader( "compassping_sentry_enemy" );
	precacheShader( "compassping_enemy_uav" );
	precacheShader( "hud_fofbox_hostile_vehicle" );
	
	precacheRumble( "damage_light" );
	
	precacheString( &"MP_REMOTE_UAV_PLACE" );
	precacheString( &"MP_REMOTE_UAV_CANNOT_PLACE" );
	precacheString( &"SPLASHES_DESTROYED_REMOTE_UAV" );
	precacheString( &"SPLASHES_MARKED_BY_REMOTE_UAV" );
	precacheString( &"SPLASHES_REMOTE_UAV_MARKED" );
	precacheString( &"SPLASHES_TURRET_MARKED_BY_REMOTE_UAV" );
	precacheString( &"SPLASHES_REMOTE_UAV_ASSIST" );

//	level.QRDrone_fx["hit"] = loadfx("impacts/large_metal_painted_hit");
//	level.QRDrone_fx["smoke"] = loadfx( "smoke/remote_heli_damage_smoke_runner" );
	level.QRDrone_fx["explode"] = loadfx( "weapon/qr_drone/fx_exp_qr_drone" );	
//	level.QRDrone_fx["missile_explode"] = loadfx( "explosions/stinger_explosion" );
	
	level.QRDrone_dialog["launch"][0] = "ac130_plt_yeahcleared";
	level.QRDrone_dialog["launch"][1] = "ac130_plt_rollinin";
	level.QRDrone_dialog["launch"][2] = "ac130_plt_scanrange";
	
	level.QRDrone_dialog["out_of_range"][0] = "ac130_plt_cleanup";
	level.QRDrone_dialog["out_of_range"][1] = "ac130_plt_targetreset";	
	
	level.QRDrone_dialog["track"][0] = "ac130_fco_moreenemy";
	level.QRDrone_dialog["track"][1] = "ac130_fco_getthatguy";
	level.QRDrone_dialog["track"][2] = "ac130_fco_guymovin";
	level.QRDrone_dialog["track"][3] = "ac130_fco_getperson";
	level.QRDrone_dialog["track"][4] = "ac130_fco_guyrunnin";
	level.QRDrone_dialog["track"][5] = "ac130_fco_gotarunner";
	level.QRDrone_dialog["track"][6] = "ac130_fco_backonthose";
	level.QRDrone_dialog["track"][7] = "ac130_fco_gonnagethim";
	level.QRDrone_dialog["track"][8] = "ac130_fco_personnelthere";
	level.QRDrone_dialog["track"][9] = "ac130_fco_rightthere";
	level.QRDrone_dialog["track"][10] = "ac130_fco_tracking";

	level.QRDrone_dialog["tag"][0] = "ac130_fco_nice";
	level.QRDrone_dialog["tag"][1] = "ac130_fco_yougothim";
	level.QRDrone_dialog["tag"][2] = "ac130_fco_yougothim2";
	level.QRDrone_dialog["tag"][3] = "ac130_fco_okyougothim";	
	
	level.QRDrone_dialog["assist"][0] = "ac130_fco_goodkill";
	level.QRDrone_dialog["assist"][1] = "ac130_fco_thatsahit";
	level.QRDrone_dialog["assist"][2] = "ac130_fco_directhit";
	level.QRDrone_dialog["assist"][3] = "ac130_fco_rightontarget";
	
	level.QRDrone_lastDialogTime = 0;
	
	level.QRDrone_noDeployZones = GetEntArray( "no_vehicles", "targetname" );

	level.qrdrone = [];	
	
	level._effect["qrdrone_prop"] = loadfx( "weapon/qr_drone/fx_qr_drone_rotar_wash_parent" );

	maps\mp\_treadfx::preloadtreadfx(level.qrdrone_vehicle);

/#
	set_dvar_if_unset( "scr_QRDroneFlyTime", 60 );
#/

	maps\mp\killstreaks\_killstreaks::registerKillstreak( "qrdrone_mp", "killstreak_qrdrone_mp", "killstreak_qrdrone", "qrdrone_used", ::tryUseQRDrone );
	maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon( "qrdrone_mp", "qrdrone_turret_mp" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakStrings( "qrdrone_mp", &"KILLSTREAK_EARNED_QRDRONE", &"KILLSTREAK_QRDRONE_NOT_AVAILABLE", &"KILLSTREAK_QRDRONE_INBOUND" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakDialog( "qrdrone_mp", "mpl_killstreak_qrdrone", "kls_recondrone_used", "", "kls_recondrone_enemy", "", "kls_recondrone_ready" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar( "qrdrone_mp", "scr_giveqrdrone" );

// Uncomment next line to override the default visionset when using the qr drone
//	level.qrdrone_vision = "remote_mortar_infrared";
}	


exceededMaxQRDrones( team )
{
	if ( level.gameType == "dm" )
	{
		if ( isDefined( level.qrdrone[team] ) || isDefined( level.qrdrone[level.otherTeam[team]] ) )
			return true;
		else
			return false;
	}
	else
	{
		if ( isDefined( level.qrdrone[team] ) )
			return true;
		else
			return false;
	}
}


tryUseQRDrone( lifeId )
{ 
	if ( self isUsingRemote() || isDefined( level.nukeIncoming ) )
	{
		return false;
	}	
	
	if (!self IsOnGround())
	{
		self iPrintLnBold( &"KILLSTREAK_QRDRONE_NOT_PLACEABLE" );
		return false;
	}
			
/*	numIncomingVehicles = 1;
	if ( exceededMaxQRDrones( self.team ) || level.littleBirds.size >= 4 )
	{
		self iPrintLnBold( &"MP_AIR_SPACE_TOO_CROWDED" );
		return false;
	}		
	else if( currentActiveVehicleCount() >= maxVehiclesAllowed() || level.fauxVehicleCount + numIncomingVehicles >= maxVehiclesAllowed() )
	{
		self iPrintLnBold( &"MP_TOO_MANY_VEHICLES" );
		return false;
	}		
*/	
	
	//	ui vars		
//	self setPlayerData( "reconDroneState", "staticAlpha", 0 );
//	self setPlayerData( "reconDroneState", "incomingMissile", false );	
		
	// increment the faux vehicle count before we spawn the vehicle so no other vehicles try to spawn
//	incrementFauxVehicleCount();

	streakName = "TODO";
	result = self giveCarryQRDrone( lifeId, streakName );
	if ( result )
	{
//		self maps\mp\_matchdata::logKillstreakEvent( streakName, self.origin );
//		self thread teamPlayerCardSplash( "used_qrdrone", self );
	}
	else
	{
		// decrement the faux vehicle count since this failed to spawn
//		decrementFauxVehicleCount();
	}
	
	self.isCarrying = false;
	return ( result );
}


giveCarryQRDrone( lifeId, streakName )
{
	//	create carry object
	carryQRDrone = createCarryQRDrone( streakName, self );	
	
	//	get rid of clicker and give hand model
//	self takeWeapon( "killstreak_uav_mp" );
//	self giveWeapon( "killstreak_qrdrone_mp" );
//	self SwitchToWeaponImmediate( "killstreak_qrdrone_mp" );		
	
	//	give carry object and wait for placement (blocking loop)
	self setCarryingQRDrone( carryQRDrone );
	
	//	we're back, what happened?
	if ( isAlive( self ) && isDefined( carryQRDrone ) )
	{		
		//	if it placed, start the killstreak at that location
		origin = carryQRDrone.origin;
		angles = self.angles;
		carryQRDrone.soundEnt delete();
		carryQRDrone delete();		
		
		result = self startQRDrone( lifeId, streakName, origin, angles );		
	}	
	else
	{
		//	cancelled placement or died
		result = false;
//		if ( isAlive( self ) )
//		{							
//			//	get rid of hand model
//			self takeWeapon( "killstreak_qrdrone_mp" );
//			
//			//	give back the clicker to be able to active killstreak again
//			self giveWeapon( "killstreak_uav_mp" );		
//		}	
	}
	
	return result;
}


//	Carry Remote UAV


createCarryQRDrone( streakName, owner )
{
	pos = owner.origin + ( anglesToForward( owner.angles ) * 4 ) + ( anglesToUp( owner.angles ) * 50 );	

	carryQRDrone = spawnTurret( "misc_turret", pos, "auto_gun_turret_mp" );
	carryQRDrone.turretType = "sentry";
	carryQRDrone SetTurretType(carryQRDrone.turretType);
	carryQRDrone.origin = pos;
	carryQRDrone.angles = owner.angles;	
	
	carryQRDrone.canBePlaced = true;
//	carryQRDrone setTurretModeChangeWait( true );
//	carryQRDrone setMode( "sentry_offline" );
	carryQRDrone makeUnusable();	
//	carryQRDrone makeTurretInoperable();
	carryQRDrone.owner = owner;
	carryQRDrone SetOwner( carryQRDrone.owner );
	carryQRDrone.scale = 3;
	carryQRDrone.inHeliProximity = false;

	carryQRDrone thread carryQRDrone_handleExistence();
	
	carryQRDrone.rangeTrigger = GetEnt( "qrdrone_range", "targetname" );
	if ( !isDefined( carryQRDrone.rangeTrigger ) )
	{
		carryQRDrone.maxHeight = int(maps\mp\killstreaks\_airsupport::getMinimumFlyHeight());
		carryQRDrone.maxDistance = 3600;		
	}	
	carryQRDrone.minHeight = level.mapCenter[2] - 800;		
	
	//	apparently can't call playLoopSound on a turret?
	carryQRDrone.soundEnt = spawn( "script_origin", carryQRDrone.origin );
	carryQRDrone.soundEnt.angles = carryQRDrone.angles;
	carryQRDrone.soundEnt.origin = carryQRDrone.origin;
	carryQRDrone.soundEnt linkTo( carryQRDrone );
	carryQRDrone.soundEnt playLoopSound( "recondrone_idle_high" );		

	return carryQRDrone;	
}

watchForAttack( )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "place_carryQRDrone" );
	self endon ( "cancel_carryQRDrone" );
	
	for ( ;; )
	{
		wait(0.05);
	
		if ( self attackButtonPressed() )
		{
				self notify( "place_carryQRDrone" );		
		}		
	}
}

//setCarryingQRDrone( carryQRDrone )
//{
//	self endon ( "death" );
//	self endon ( "disconnect" );
//	
//	carryQRDrone thread carryQRDrone_setCarried( self );		
//
////	self notifyOnPlayerCommand( "place_carryQRDrone", "+attack" );
////	self notifyOnPlayerCommand( "place_carryQRDrone", "+attack_akimbo_accessible" ); // support accessibility control scheme
////	self notifyOnPlayerCommand( "cancel_carryQRDrone", "+actionslot 4" );
//	
//	self thread watchForAttack();
//	
//	for ( ;; )
//	{
//		result = waittill_any_return( "place_carryQRDrone", "cancel_carryQRDrone", "weapon_switch_started" );
//
//		//self forceUseHintOff();
//		
//		if ( result != "place_carryQRDrone" )
//		{							
//			self.isCarrying = false;
//			if ( isdefined( carryQRDrone.soundEnt ) )
//				carryQRDrone.soundEnt delete();	
//			carryQRDrone delete();		
//			break;
//		}
//
//		if ( !carryQRDrone.canBePlaced )
//		{
////			if ( self.team != "spectator" )
////				self ForceUseHintOn( &"MP_REMOTE_UAV_CANNOT_PLACE" );
//			continue;	
//		}					
//		
///*		if( isDefined( level.nukeIncoming ) || 
//			self IsEMPJammed() || 
//			exceededMaxQRDrones( self.team ) || 
//			currentActiveVehicleCount() >= maxVehiclesAllowEd() || 
//			level.fauxVehicleCount >= maxVehiclesAllowed() )
//		{
//			if ( isDefined( level.nukeIncoming ) || self IsEMPJammed() )
//				self iPrintLnBold( &"MP_UNAVAILABLE_FOR_N_WHEN_EMP", level.empTimeRemaining );
//			else
//				self iPrintLnBold( &"MP_TOO_MANY_VEHICLES" );
//			self.isCarrying = false;
//			carryQRDrone.soundEnt delete();	
//			carryQRDrone delete();		
//			break;
//		}		
//*/
//		self.isCarrying = false;
//		carryQRDrone.carriedBy = undefined;		
//	
//		carryQRDrone playSound( "sentry_gun_plant" );	
//		carryQRDrone notify ( "placed" );		
//		break;
//	}
//}

setCarryingQRDrone( carryQRDrone )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	carryQRDrone thread carryQRDrone_setCarried( self );		

	if ( !carryQRDrone.canBePlaced )
	{
			if ( self.team != "spectator" )
				self iPrintLnBold( &"KILLSTREAK_QRDRONE_NOT_PLACEABLE" );
			if ( isdefined( carryQRDrone.soundEnt ) )
				carryQRDrone.soundEnt delete();	
			carryQRDrone delete();		
			return;
	}					
	
	self.isCarrying = false;
	carryQRDrone.carriedBy = undefined;		

	carryQRDrone playSound( "sentry_gun_plant" );	
	carryQRDrone notify ( "placed" );		
}

carryQRDrone_setCarried( carrier )
{
	self setCanDamage( false );
//	self setSentryCarrier( carrier );
	self setContents( 0 );

	self.carriedBy = carrier;
	carrier.isCarrying = true;

	carrier thread updateCarryQRDronePlacement( self );
	self notify ( "carried" );	
}


isInRemoteNoDeploy()
{
	if ( isDefined( level.QRDrone_noDeployZones ) && level.QRDrone_noDeployZones.size )
	{
		foreach( zone in level.QRDrone_noDeployZones )
		{
			if ( self isTouching( zone ) )
				return true;
		}
	}
	return false;
}


updateCarryQRDronePlacement( carryQRDrone )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	carryQRDrone endon ( "placed" );
	carryQRDrone endon ( "death" );
	
	carryQRDrone.canBePlaced = true;
	lastCanPlaceCarryQRDrone = -1; // force initial update

	for( ;; )
	{		
		heightOffset = UAV_REMOTE_COLLISION_RADIUS;
		switch( self getStance() )
		{
			case "stand":
				heightOffset = 40;
				break;
			case "crouch":
				heightOffset = 25;
				break;
			case "prone":
				heightOffset = 10;
				break;
		}
		
		placement = self CanPlayerPlaceVehicle( 22, 22, 50, heightOffset, 0, 0 );
		carryQRDrone.origin = placement[ "origin" ] + ( anglesToUp(self.angles) * ( UAV_REMOTE_COLLISION_RADIUS - UAV_REMOTE_Z_OFFSET ) );
		carryQRDrone.angles = placement[ "angles" ];		
		carryQRDrone.canBePlaced = self isOnGround() && placement[ "result" ] && carryQRDrone QRDrone_in_range() && !carryQRDrone isInRemoteNoDeploy();			
	
		if ( carryQRDrone.canBePlaced != lastCanPlaceCarryQRDrone )
		{
			if ( carryQRDrone.canBePlaced )
			{
//				if ( self.team != "spectator" )
//					self ForceUseHintOn( &"MP_REMOTE_UAV_PLACE" );
				
				//	if they're holding it in launch position just launch now
				if ( self attackButtonPressed() )
					self notify( "place_carryQRDrone" );				
			}
			else
			{
//				if ( self.team != "spectator" )
//					self ForceUseHintOn( &"MP_REMOTE_UAV_CANNOT_PLACE" );
			}
		}
		
		lastCanPlaceCarryQRDrone = carryQRDrone.canBePlaced;		
		wait ( 0.05 );
	}
}


carryQRDrone_handleExistence()
{
	level endon ( "game_ended" );
	self.owner endon ( "place_carryQRDrone" );
	self.owner endon ( "cancel_carryQRDrone" );

	self.owner waittill_any( "death", "disconnect", "joined_team", "joined_spectators" );

	if ( isDefined( self ) )
	{
		//	can't see viewmodel heli in player's hand from other player's perspective so no point blowing it up
		//playFX( level.QRDrone_fx["explode"], self.origin );		
		self delete();
	}
}


//	Remote UAV


removeRemoteWeapon()
{
	level endon( "game_ended" );
	self endon ( "disconnect" );
	
	wait(0.7);
	
}


startQRDrone( lifeId, streakName, origin, angles )
{		
	self lockPlayerForQRDroneLaunch();
	self setUsingRemote( streakName );
	
//	self giveWeapon("killstreak_qrdrone_mp");
//	self SwitchToWeaponImmediate("killstreak_qrdrone_mp");	
//	self VisionSetNakedForPlayer( "black_bw", 0.0 );	
	result = self maps\mp\killstreaks\_killstreaks::initRideKillstreak( "qrdrone" );		
	
	if ( result != "success" )
	{
		if ( result != "disconnect" )
		{
			self notify( "qrdrone_unlock" );
//			self takeWeapon("killstreak_qrdrone_mp");
			self clearUsingRemote();
		}
		return false;
	}	
	
/*	if( exceededMaxQRDrones( self.team ) || 
		currentActiveVehicleCount() >= maxVehiclesAllowed() || 
		level.fauxVehicleCount >= maxVehiclesAllowed() )
	{
		self iPrintLnBold( &"MP_TOO_MANY_VEHICLES" );
		self notify( "qrdrone_unlock" );
		self takeWeapon("killstreak_qrdrone_mp");
		self clearUsingRemote();
		return false;
	}		
	*/

	if ( !self maps\mp\killstreaks\_killstreakrules::killstreakStart( "qrdrone_mp", self.team, false, true ) )
	{
		return false;
	}

	self notify( "qrdrone_unlock" );
	QRDrone = createQRDrone( lifeId, self, streakName, origin, angles );
	if ( isDefined( QRDrone ) )
	{
		self thread QRDrone_Ride( lifeId, QRDrone, streakName );
		QRDrone waittill( "end_remote" );

		return true;
	}
	else
	{
		self iPrintLnBold( &"MP_TOO_MANY_VEHICLES" );
//		self takeWeapon("killstreak_qrdrone_mp");
		self clearUsingRemote();
		return false;	
	}		
}


QRDrone_clearRideIntro()
{
//	if ( IsDefined( level.nukeDetonated ) )
//		self VisionSetNakedForPlayer( level.nukeVisionSet, 0 );
//	else
//		self VisionSetNakedForPlayer( "", 0 ); // go to default visionset	
}


lockPlayerForQRDroneLaunch()
{
	//	lock
	lockSpot = spawn( "script_origin", self.origin );
	lockSpot hide();	
	self playerLinkTo( lockSpot );	
	
	//	wait for unlock
	self thread clearPlayerLockFromQRDroneLaunch( lockSpot );
}


clearPlayerLockFromQRDroneLaunch( lockSpot )
{
	level endon( "game_ended" );
	
	msg = self waittill_any_return( "disconnect", "death", "qrdrone_unlock" );
	
	//	do unlock stuff
//	if ( msg != "disconnect" )
//		self unlink();
	lockSpot delete();
}


createQRDrone( lifeId, owner, streakName, origin, angles )
{
	QRDrone = spawnHelicopter( owner, origin, angles, level.qrdrone_vehicle, "veh_t6_drone_t_hawk_mp" );	
	if ( !isDefined( QRDrone ) )
		return undefined;
	
//	QRDrone maps\mp\killstreaks\_helicopter::addToLittleBirdList();
//	QRDrone thread maps\mp\killstreaks\_helicopter::removeFromLittleBirdListOnDeath();

	//radius and offset should match vehHelicopterBoundsRadius (GDT) and bg_vehicle_sphere_bounds_offset_z.
//	QRDrone MakeVehicleSolidCapsule( UAV_REMOTE_COLLISION_RADIUS, UAV_REMOTE_Z_OFFSET, UAV_REMOTE_COLLISION_RADIUS ); 
		
	QRDrone.lifeId = lifeId;
	QRDrone.team = owner.team;
	QRDrone.pers["team"] = owner.team;	
	QRDrone.owner = owner;

	QRDrone.health = 999999; // keep it from dying anywhere in code
	QRDrone.maxHealth = 250; // this is the health we'll check
	QRDrone.damageTaken = 0;	
	QRDrone.destroyed = false;
	QRDrone setCanDamage( true );
	QRDrone.specialDamageCallback = ::Callback_VehicleDamage;
	//QRDrone ThermalDrawEnable();
	
	//	scrambler
	//QRDrone.scrambler = spawn( "script_model", origin );
	//QRDrone.scrambler linkTo( QRDrone, "tag_origin", (0,0,-160), (0,0,0) );
	//QRDrone.scrambler makeScrambler( owner );
	
	QRDrone.smoking = false;
	QRDrone.inHeliProximity = false;		
	QRDrone.heliType = "qrdrone";	
	QRDrone.markedPlayers = [];
		
	owner maps\mp\gametypes\_weaponobjects::addWeaponObjectToWatcher( "qrdrone", QRDrone );

	//QRDrone thread QRDrone_light_fx();
	QRDrone thread QRDrone_explode_on_disconnect();
	QRDrone thread QRDrone_explode_on_changeTeams();
	//QRDrone thread QRDrone_explode_on_death();
	QRDrone thread QRDrone_detonateWaiter();

	QRDrone thread QRDrone_clear_marked_on_gameEnded();
	QRDrone thread QRDrone_leave_on_timeout();
	QRDrone thread QRDrone_watch_distance();
//	QRDrone thread QRDrone_watchHeliProximity();	
//	QRDrone thread outOfBoundsWatcher( );

	QRDrone thread QRDrone_handleDamage();
	
	QRDrone.numFlares = 2;
	QRDrone.hasIncoming = false;
	QRDrone.incomingMissiles = [];	
	QRDrone thread QRDrone_clearIncomingWarning();
	QRDrone thread QRDrone_handleIncomingStinger();
	QRDrone thread QRDrone_handleIncomingSAM();
	
	level.qrdrone[QRDrone.team] = QRDrone;
	return QRDrone;
}


QRDrone_ride( lifeId, QRDrone, streakName )
{		
	self.killstreak_waitamount = QRDrone.flyTime * 1000;
	QRDrone.playerLinked = true;
	self.restoreAngles = self.angles;
	
//	if ( getDvarInt( "camera_thirdPerson" ) )
//		self setThirdPersonDOF( false );	
		
//	if( self isJuggernaut() )
//		self.juggernautOverlay.alpha = 0;		
	
//	self CameraLinkTo( QRDrone, "tag_origin" );	
//	self RemoteControlVehicle( QRDrone );	
		QRDrone usevehicle( self, 0 );

	self thread QRDrone_playerExit( QRDrone );
	//self thread QRDrone_Track( QRDrone );
	self thread QRDrone_Fire( QRDrone );
	//self thread QRDrone_operationRumble( QRDrone );

	self.qrdrone_rideLifeId = lifeId;
	self.QRDrone = QRDrone;
	
	self thread QRDrone_delayLaunchDialog( QRDrone );
	
//	self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0, 1.0, 0, 1.0 );
//	self VisionSetNakedForPlayer( "black_bw", 0.0 );
//	if ( IsDefined( level.nukeDetonated ) )
//		self VisionSetNakedForPlayer( level.nukeVisionSet, 1 );
//	else
//		self VisionSetNakedForPlayer( "", 1 ); // go to default visionset	
	
	if ( IsDefined( level.qrdrone_vision ) )
		self setVisionsetWaiter();
}


QRDrone_delayLaunchDialog( QRDrone )
{
	level endon( "game_ended" );
	self endon ( "disconnect" );
	QRDrone endon ( "death" );
	QRDrone endon ( "end_remote" );
	QRDrone endon ( "end_launch_dialog" );	
	
	wait( 3 );
	self QRDrone_dialog( "launch" );
}


QRDrone_endride( QRDrone )
{
	if ( isDefined( QRDrone ) )
	{		
		QRDrone.playerLinked = false;
		
		QRDrone notify( "end_remote" );
		
		self clearUsingRemote();
		
		self destroyHud();
		
//		if ( getDvarInt( "camera_thirdPerson" ) )
//			self setThirdPersonDOF( true );			
			
//		if( self isJuggernaut() )
//			self.juggernautOverlay.alpha = 1;				
		
//		self CameraUnlink( QRDrone );
//		self RemoteControlVehicleOff( QRDrone );
		if ( IsDefined( self.viewlockedentity ) )
			self Unlink();
		
		//self ThermalVisionOff();
		
		self.killstreak_waitamount = undefined;
		self setPlayerAngles( self.restoreAngles );	
		
		if ( isalive(self) )
		{
			self switchToWeapon( self getLastWeapon() );
//			self TakeWeapon( "killstreak_qrdrone_mp" );
		}
			
		self thread QRDrone_freezeBuffer();
	}
	self.QRDrone = undefined;
}


QRDrone_freezeBuffer()
{
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "game_ended" );
	
	self freezeControlsWrapper( true );
	wait( 0.5 );
	self freezeControlsWrapper( false );
}


QRDrone_playerExit( QRDrone )
{
	level endon( "game_ended" );
	self endon ( "disconnect" );
	QRDrone endon ( "death" );
	QRDrone endon ( "end_remote" );
	
	//	delay exit for transition into remote
	wait( 2 );
	
	while( true )
	{
		timeUsed = 0;
		while(	self UseButtonPressed() )
		{	
			timeUsed += 0.05;
			if( timeUsed > 0.75 )
			{	
				QRDrone thread QRDrone_leave();
				return;
			}
			wait( 0.05 );
		}
		wait( 0.05 );
	}
}


QRDrone_Track( QRDrone )
{
	level endon ( "game_ended" );
	self endon ( "disconnect" );
	QRDrone endon ( "death" );
	QRDrone endon ( "end_remote" );	
	
	QRDrone.lastTrackingDialogTime = 0;
	
	self.lockedTarget = undefined;
	self weaponLockFree();
	
	//	finish transitioning into remote
	wait( 1 );
	
	//	now loop and track
	while( true )
	{		
		//	aim assist 'lock on' target for radius check
		pos = QRDrone getTagOrigin( "tag_turret" );		
		forward = anglesToForward( self getPlayerAngles() );
		endpos = pos + forward * 1024;				
		trace = bulletTrace( pos, endpos, true, QRDrone );
		if ( isDefined( trace["position"] ) )
			targetPos = trace["position"];
		else
		{
			targetPos = endpos;		
			trace["endpos"] = endpos;
		}
		QRDrone.trace = trace;
				
		//	track all targetable entities, update head icons, check lock-on
		lockedPlayer = self QRDrone_trackEntities( QRDrone, level.players, targetPos );
		lockedTurret = self QRDrone_trackEntities( QRDrone, level.turrets, targetPos );
		lockedUAV = undefined;
		if ( level.teamBased )
			lockedUAV = self QRDrone_trackEntities( QRDrone, level.uavmodels[level.otherTeam[self.team]], targetPos );
		else
			lockedUAV = self QRDrone_trackEntities( QRDrone, level.uavmodels, targetPos );
		
		lockedTarget = undefined;
		if ( isDefined( lockedPlayer ) )
			lockedTarget = lockedPlayer;
		else if ( isDefined( lockedTurret ) )
			lockedTarget = lockedTurret;
		else if ( isDefined( lockedUAV ) )
			lockedTarget = lockedUAV;

		if ( isDefined( lockedTarget ) )
		{
			if ( !isDefined( self.lockedTarget ) || ( isDefined( self.lockedTarget ) && self.lockedTarget != lockedTarget ) )
			{			
				self weaponLockFinalize( lockedTarget );
				self.lockedTarget = lockedTarget;
				
				//	do vo for players
				if ( isDefined( lockedPlayer ) )
				{
					//	cancels the launch dialog delay if we get a target before then
					QRDrone notify( "end_launch_dialog" );
					self QRDrone_dialog( "track" );					
				}
			}
		}		
		else
		{
			self weaponLockFree();
			self.lockedTarget = undefined;
		}
		
		wait( 0.05 );	
	}	
}


QRDrone_trackEntities( QRDrone, entities, targetPos )
{
	level endon( "game_ended" );
	
	lockedTarget = undefined;
	foreach ( entity in entities )
	{
		if ( level.teamBased && entity.team == self.team )
			continue;
			
		if ( isPlayer( entity ) )
		{
			if ( !isAlive( entity ) )
				continue;
			
			if ( entity == self )
				continue;	
				
			id = entity GetGuid();	
		}
		else
			id = entity.birthtime;
			
		//	offset
		if ( isDefined( entity.sentryType ) || isDefined( entity.turretType ) )
		{
			offset = (0,0,32);
			unmarkedShader = "hud_fofbox_hostile_vehicle";
		}
		else if ( isDefined( entity.uavType ) )
		{
			offset = (0,0,-52);
			unmarkedShader = "hud_fofbox_hostile_vehicle";
		}
		else
		{
			offset = (0,0,26);
			unmarkedShader = "veh_hud_target_unmarked";
		}
	
		//	already marked
		if ( isDefined( entity.QRDroneMarkedBy ) )
		{
			//	marked, but no headicon yet
			if ( !isDefined( QRDrone.markedPlayers[id] ) )
			{
				QRDrone.markedPlayers[id] = [];		
				QRDrone.markedPlayers[id]["player"] = entity;
//				QRDrone.markedPlayers[id]["icon"] = entity maps\mp\_entityheadIcons::setHeadIcon( self, "veh_hud_target_marked", offset, 10, 10, false, 0.05, false, false, false, false );		
				QRDrone.markedPlayers[id]["icon"].shader = "veh_hud_target_marked";
				
				if ( !isDefined( entity.sentryType ) || !isDefined( entity.turretType ) )
					QRDrone.markedPlayers[id]["icon"] SetTargetEnt( entity );			
			}
			//	headicon hasn't been switched to marked yet
			else if ( isDefined( QRDrone.markedPlayers[id] ) && isDefined( QRDrone.markedPlayers[id]["icon"] ) && isDefined( QRDrone.markedPlayers[id]["icon"].shader ) && QRDrone.markedPlayers[id]["icon"].shader != "veh_hud_target_marked" )
			{
				QRDrone.markedPlayers[id]["icon"].shader = "veh_hud_target_marked";
				QRDrone.markedPlayers[id]["icon"] setShader( "veh_hud_target_marked", 10, 10 );
				QRDrone.markedPlayers[id]["icon"] setWaypoint( false );				
			}
		}
		//	not marked yet
		else 
		{
			//	exceptions
			if ( isPlayer( entity ) )
			{
				spawnProtected = ( isDefined( entity.spawntime ) && ( getTime() - entity.spawntime )/1000 <= 5 );
				hudTargetProtected = entity HasPerk( "specialty_blindeye" );
				carried = false;
				leaving = false;
			}
			else
			{
				spawnProtected = false;
				hudTargetProtected = false;
				carried = isDefined( entity.carriedBy );
				leaving = ( isDefined( entity.isLeaving ) && entity.isLeaving == true );
			}
			
			//	no headicon yet
			if ( !isDefined( QRDrone.markedPlayers[id] ) && !spawnProtected && !hudTargetProtected && !carried && !leaving )					 
			{
				QRDrone.markedPlayers[id] = [];		
				QRDrone.markedPlayers[id]["player"] = entity;
//				QRDrone.markedPlayers[id]["icon"] = entity maps\mp\_entityheadIcons::setHeadIcon( self, unmarkedShader, offset, 10, 10, false, 0.05, false, false, false, false );
				QRDrone.markedPlayers[id]["icon"].shader = unmarkedShader;	
				
				if ( !isDefined( entity.sentryType ) || !isDefined( entity.turretType ) )
					QRDrone.markedPlayers[id]["icon"] SetTargetEnt( entity );		
			}			
			
			//	lock on? (don't allow aim assist for spawn campers)
			if ( ( !isDefined( lockedTarget ) || lockedTarget != entity ) &&
				 ( isDefined( QRDrone.trace["entity"] ) && QRDrone.trace["entity"] == entity && !carried && !leaving ) || 
			     ( distance( entity.origin, targetPos ) < UAV_REMOTE_AIM_ASSIST_RANGE * QRDrone.trace[ "fraction" ] && !spawnProtected && !carried && !leaving ) ||
			     ( !leaving && QRDrone_canTargetUAV( QRDrone, entity ) ) )
			{
				//	final check, make sure there is line of sight
				trace = bulletTrace( QRDrone.origin, entity.origin + (0,0,32), true, QRDrone );
				if ( ( isDefined( trace["entity"] ) && trace["entity"] == entity ) || trace["fraction"] == 1 )
				{
					self playLocalSound( "recondrone_lockon" );
					lockedTarget = entity;
				}				
			}	
		}
	}
	return lockedTarget;	
}


QRDrone_canTargetUAV( QRDrone, uav )
{
	//	lenient targeting for other uavs, just point in the correct direction and ignore range to keep players flying low
	if ( isDefined( uav.uavType ) )
	{
		forward = anglesToForward( self getPlayerAngles() );
		toUAV = vectorNormalize( uav.origin - QRDrone getTagOrigin( "tag_turret" ) );
		dot = vectorDot( forward, toUAV );
		if ( dot > 0.985 )
			return true;
	}
	return false;
}


QRDrone_Fire( QRDrone )
{
	self endon ( "disconnect" );
	QRDrone endon ( "death" );
	level endon ( "game_ended" );
	QRDrone endon ( "end_remote" );	
	
	//	transition into remote
	wait( 1 );
	
	//self notifyOnPlayerCommand( "QRDrone_tag", "+attack" );
	//self notifyOnPlayerCommand( "QRDrone_tag", "+attack_akimbo_accessible" ); // support accessibility control scheme	
	
	while ( true )
	{		
		self waittill( "QRDrone_tag" ); 
		
		if ( isDefined( self.lockedTarget ) )
		{
			self playLocalSound( "recondrone_tag" );
			
			//	hit FX
			self maps\mp\gametypes\_damagefeedback::updateDamageFeedback( false );
			//	mark target
			self thread QRDrone_markPlayer( self.lockedTarget );
			//	feedback
			self thread QRDrone_Rumble( QRDrone, 3 );
			
			wait( 0.25 );			
		}
		else
		{
			wait( 0.05 );	
		}		
	}
}


QRDrone_Rumble( QRDrone, amount )
{
	self      endon ( "disconnect" );
	QRDrone endon ( "death" );
	level     endon ( "game_ended" );
	QRDrone endon ( "end_remote" );
	QRDrone notify( "end_rumble" );
	QRDrone endon ( "end_rumble" );
	
	for( i=0; i<amount; i++ )
	{
		self playRumbleOnEntity( "damage_heavy" );
		wait( 0.05 );
	}	
}


QRDrone_markPlayer( targetPlayer )
{	
	level endon( "game_ended" );
	
	//	set the target player as marked by RC driver
	targetPlayer.QRDroneMarkedBy = self;
		
	//	hit and notify target player
	if ( isPlayer( targetPlayer ) && !targetPlayer isUsingRemote() )
	{
		targetPlayer playLocalSound( "player_hit_while_ads_hurt" );
		targetPlayer thread maps\mp\_flashgrenades::applyFlash(2.0, 1.0);
//		targetPlayer thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_MARKED_BY_REMOTE_UAV" );
	}
	//	hack for uav, removed entity on death has no .birthtime
	else if ( isDefined( targetPlayer.uavType ) )
	{
		targetPlayer.birth_time = targetPlayer.birthtime; 
	}
	//	turret, notify owner
	else if ( isDefined( targetPlayer.owner ) && isAlive( targetPlayer.owner ) )
	{
//		targetPlayer.owner thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_TURRET_MARKED_BY_REMOTE_UAV" );
	}	
	
	//	notify operator
	self QRDrone_dialog( "tag" );
//	self thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_REMOTE_UAV_MARKED" );
	if ( level.gameType != "dm" )
	{
		maps\mp\gametypes\_globallogic_score::givePlayerScore( "kill", self, undefined );
	}
	
	//	put em on the minimap	
	if ( isPlayer( targetPlayer ) )
		targetPlayer setPerk( "specialty_radarblip" );
	else
	{
		if ( isDefined( targetPlayer.uavType ) )
			shaderName = "compassping_enemy_uav";
		else
			shaderName = "compassping_sentry_enemy";
		if ( level.teamBased )
		{
			curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
			objective_add( curObjID, "invisible", (0,0,0) );
			objective_OnEntity( curObjID, targetPlayer );
			objective_state( curObjID, "active" );
			objective_team( curObjID, self.team );
			objective_icon( curObjID, shaderName );
			targetPlayer.QRDroneMarkedObjID01 = curObjID;
		}
		else
		{
			curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
			objective_add( curObjID, "invisible", (0,0,0) );
			objective_OnEntity( curObjID, targetPlayer );
			objective_state( curObjID, "active" );
			objective_team( curObjID, level.otherTeam[self.team] );
			objective_icon( curObjID, shaderName );
			targetPlayer.QRDroneMarkedObjID02 = curObjID;
			
			curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
			objective_add( curObjID, "invisible", (0,0,0) );
			objective_OnEntity( curObjID, targetPlayer );
			objective_state( curObjID, "active" );
			objective_team( curObjID, self.team );
			objective_icon( curObjID, shaderName );
			targetPlayer.QRDroneMarkedObjID03 = curObjID;
		}	
	}
	
	
	//	track their existence to remove from marked players list and minimap
	targetPlayer thread QRDrone_unmarkRemovedPlayer( self.QRDrone );
}


QRDrone_processTaggedAssist( victim )
{
	self QRDrone_dialog( "assist" );
	//self thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_REMOTE_UAV_ASSIST" );
	
	if ( level.gameType != "dm" )
	{
		if ( isDefined( victim ) )
			self thread maps\mp\gametypes\_globallogic_score::processAssist( victim );	
		else
		{
			maps\mp\gametypes\_globallogic_score::givePlayerScore( "assist", self, undefined, true );
		}
	}
}


QRDrone_unmarkRemovedPlayer( QRDrone )
{
	level endon( "game_ended" );
	
	msg = self waittill_any_return( "death", "disconnect", "carried", "leaving" );
	
	//	hack for uavs
	if ( msg == "leaving" || !isDefined( self.uavType ) )
		self.QRDroneMarkedBy = undefined;
	if ( isDefined( QRDrone ) )
	{
		if ( isPlayer( self ) )
			id = self GetGuid();
		else if ( isDefined( self.birthtime ) )
			id = self.birthtime;
		else
			id = self.birth_time; // hack for uav, removed entity on death has no .birthtime
				
		if ( msg == "carried" || msg == "leaving" )
		{
			QRDrone.markedPlayers[id]["icon"] destroy();
			QRDrone.markedPlayers[id]["icon"] = undefined;			
		}				
		if ( isDefined( id ) && isDefined( QRDrone.markedPlayers[id] ) )
		{
			QRDrone.markedPlayers[id] = undefined;
			QRDrone.markedPlayers = array_removeUndefined( QRDrone.markedPlayers );
		}
	}
	
	if ( isPlayer( self ) )
		self unsetPerk( "specialty_radarblip" );
	else 
	{
		if( isDefined( self.QRDroneMarkedObjID01 ) )
			objective_delete( self.QRDroneMarkedObjID01 );	
		if( isDefined( self.QRDroneMarkedObjID02 ) )
			objective_delete( self.QRDroneMarkedObjID02 );	
		if( isDefined( self.QRDroneMarkedObjID03 ) )
			objective_delete( self.QRDroneMarkedObjID03 );
	}
}


QRDrone_clearMarkedForOwner()
{	
	foreach( markedPlayer in self.markedPlayers )
	{
		if ( isDefined( markedPlayer["icon"] ) )
		{
			markedPlayer["icon"] destroy();
			markedPlayer["icon"] = undefined;
		}	
	}
	self.markedPlayers = undefined;
}


QRDrone_operationRumble( QRDrone )
{
	self      endon ( "disconnect" );
	QRDrone endon ( "death" );
	level     endon ( "game_ended" );
	QRDrone endon ( "end_remote" );
	
	while( true )
	{
		//	JDS TODO: make a light, subtle buzzing
		self PlayRumbleOnEntity( "damage_light" );
		wait( 0.5 );
	}	
}

QRDrone_watch_distance()
{
	self endon ("death" );
	
	self.owner inithud();

	//	script distance and airstrike height until in range triggers are created for levels
//	self.rangeTrigger = GetEnt( "qrdrone_range", "targetname" );
//	if ( !isDefined( self.rangeTrigger ) )
	{
		self.maxHeight = int(maps\mp\killstreaks\_airsupport::getMinimumFlyHeight());
		self.maxDistance = 12800;		
	}	
	
	self.minHeight = level.mapCenter[2] - 800;		

	//	ent to put headicon on for pointing to inside of map when they go out of range
	self.centerRef = Spawn( "script_model", level.mapCenter );
	
	//	shouldn't be possible to start out of range, but just in case
	inRangePos = self.origin;		
	
	self.rangeCountdownActive = false;
	
	//	loop
	while ( true )
	{
		if ( !self QRDrone_in_range() )
		{
			//	increase static with distance from exit point or distance to heli in proximity
			staticAlpha = 0;		
			while ( !self QRDrone_in_range() )
			{
				self SetClientFlag( level.const_flag_outofbounds );

//				self.owner QRDrone_dialog( "out_of_range" );
				if ( !self.rangeCountdownActive )
				{
					self.rangeCountdownActive = true;
					self thread QRDrone_rangeCountdown();
				}
				if ( isDefined( self.heliInProximity ) )
				{
					dist = distance( self.origin, self.heliInProximity.origin );
					staticAlpha = 1 - ( (dist-UAV_REMOTE_MIN_HELI_PROXIMITY) / (UAV_REMOTE_MAX_HELI_PROXIMITY-UAV_REMOTE_MIN_HELI_PROXIMITY) );
				}
				else
				{
					dist = distance( self.origin, inRangePos );
					staticAlpha = min( 1, dist/UAV_REMOTE_MAX_PAST_RANGE );					
				}
				
				self.owner set_static_alpha( staticAlpha );
//				self.owner setPlayerData( "reconDroneState", "staticAlpha", staticAlpha );				
				
				wait ( 0.05 );
			}
			
			self ClearClientFlag( level.const_flag_outofbounds );

			//	end countdown
			self notify( "in_range" );
			self.rangeCountdownActive = false;
			
			//	fade out static
			self thread QRDrone_staticFade( staticAlpha );
		}		
		inRangePos = self.origin;
		wait ( 0.05 );
	}
}


QRDrone_in_range()
{
	if ( self.origin[2] < self.maxHeight && self.origin[2] > self.minHeight &&  !self.inHeliProximity )
	{
		if ( self isMissileInsideHeightLock() )
		{
				return true;
		}
	}
	return false;
}


QRDrone_staticFade( staticAlpha )
{
	self endon ( "death" );
	while( self QRDrone_in_range() )
	{
		staticAlpha -= 0.05;
		if ( staticAlpha < 0 )
		{
			self.owner set_static_alpha( staticAlpha );
			break;
		}
		self.owner set_static_alpha( staticAlpha );
		
		wait( 0.05 );
	}
}


QRDrone_rangeCountdown()
{
	self endon( "death" );
	self endon( "in_range" );
	
	if ( isDefined( self.heliInProximity ) )
		countdown = UAV_REMOTE_HELI_RANGE_COUNTDOWN;
	else
		countdown = UAV_REMOTE_PAST_RANGE_COUNTDOWN;
	
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( countdown );
	
	watcher =  self.owner maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "qrdrone" );
	watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate(self,0);
}


QRDrone_explode_on_disconnect()
{
	self endon ( "death" );	

	self.owner waittill( "disconnect" );
	
	watcher =  self.owner maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "qrdrone" );
	watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate(self,0);
}


QRDrone_explode_on_changeTeams()
{
	self endon ( "death" );	

	self.owner waittill_any( "joined_team", "joined_spectators" );
	
	watcher =  self.owner maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "qrdrone" );
	watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate(self,0);
}


QRDrone_clear_marked_on_gameEnded()
{
	self endon ( "death" );
	
	level waittill( "game_ended" );
	
	self QRDrone_clearMarkedForOwner();
}


QRDrone_leave_on_timeout()
{
	self endon ( "death" );	
	
	self.flyTime = 60.0;
/#
	set_dvar_int_if_unset( "scr_QRDroneFlyTime", self.flyTime );
	self.flyTime = GetDvarInt( "scr_QRDroneFlyTime" );
#/	
	
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( self.flyTime );
	
//	self thread QRDrone_leave();
	watcher =  self.owner maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "qrdrone" );
	watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate(self,0);
}


QRDrone_leave()
{
	level endon( "game_ended" );
	self endon( "death" );
	
	//	disengage player
	self notify( "leaving" );
	self.owner QRDrone_endride( self );

	//	remove	
	self notify( "death" );
}


//QRDrone_explode_on_death()
//{
//	level endon( "game_ended" );
//	
//	self waittill( "death" );			
//		
//	watcher =  self.owner maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "qrdrone" );
//	watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate(self,0);
//}


QRDrone_cleanup()
{
	if ( self.playerLinked == true && isDefined( self.owner ) )
		self.owner QRDrone_endride( self );		
		
	if ( isDefined( self.scrambler ) )
		self.scrambler delete();
		
	if ( isdefined(self) && isDefined( self.centerRef ) )
		self.centerRef delete();
	
	self QRDrone_clearMarkedForOwner();
	
	// probably want to port this functionality over
//	stopFXOnTag( level.QRDrone_fx["smoke"], self, "tag_origin" );
	
	level.qrdrone[self.team] = undefined;

	// decrement the faux vehicle count right before it is deleted this way we know for sure it is gone
//	decrementFauxVehicleCount();

	self delete();	
}


QRDrone_light_fx()
{
	playFXOnTag( level.chopper_fx["light"]["belly"], self, "tag_light_nose" );
	wait ( 0.05 );
	playFXOnTag( level.chopper_fx["light"]["tail"], self, "tag_light_tail1" );	
}


QRDrone_dialog( dialogGroup )
{
	if ( dialogGroup == "tag" )
		waitTime = 1000;
	else
		waitTime = 5000;
	
	if ( getTime() - level.QRDrone_lastDialogTime < waitTime )
		return;
	
	level.QRDrone_lastDialogTime = getTime();
	
	randomIndex = randomInt( level.QRDrone_dialog[ dialogGroup ].size );
	soundAlias = level.QRDrone_dialog[ dialogGroup ][ randomIndex ];
	
	//fullSoundAlias = maps\mp\gametypes\_teams::getTeamVoicePrefix( self.team ) + soundAlias;
	
	//self playLocalSound( fullSoundAlias );
	self playLocalSound( soundAlias );
}


QRDrone_handleIncomingStinger()
{
	level endon ( "game_ended" );
	self endon ( "death" );
	self endon ( "end_remote" );

	while ( true )
	{
		level waittill ( "stinger_fired", player, missile, lockTarget );
		
		if ( !isDefined( missile ) || !IsDefined( lockTarget ) || (lockTarget != self) )
			continue;
		
		//	notify owner
		self.owner PlayLocalSound( "javelin_clu_lock" );
//		self.owner setPlayerData( "reconDroneState", "incomingMissile", true );		
		self.hasIncoming = true;
		self.incomingMissiles[self.incomingMissiles.size] = missile;		
		
		//	track missile
		missile.owner = player;
		missile thread watchStingerProximity( lockTarget );
	}	
}


QRDrone_handleIncomingSAM()
{
	level endon ( "game_ended" );
	self endon ( "death" );
	self endon ( "end_remote" );		

	while ( true )
	{
		level waittill ( "sam_fired", player, missileGroup, lockTarget );

		if ( !IsDefined( lockTarget ) || ( lockTarget != self ) )
			continue;
		
		numIncomming = 0;
		foreach ( missile in missileGroup )
		{
			if ( isDefined( missile ) )
			{
				self.incomingMissiles[self.incomingMissiles.size] = missile;	
				missile.owner = player;
				numIncomming++;
			}
		}	
		
		if ( numIncomming )
		{
			//	notify owner
			self.owner PlayLocalSound( "javelin_clu_lock" );
//			self.owner setPlayerData( "reconDroneState", "incomingMissile", true );	
			self.hasIncoming = true;
			
			//	track missile
			level thread watchSAMProximity( lockTarget, missileGroup );
		}
	}
}


watchStingerProximity( missileTarget )
{
	level endon( "game_ended" );
	self endon ( "death" );
	
	self SetTargetEntity( missileTarget );

	lastVecToTarget = vectorNormalize( missileTarget.origin - self.origin );
	
	while( isDefined( missileTarget ) )
	{			
		center = missileTarget GetPointInBounds( 0, 0, 0 );
		curDist = distance( self.origin, center );

		//	flares?
		if ( missileTarget.numFlares > 0 && curDist < 4000 )
		{
			newTarget = missileTarget deployFlares();
			self SetTargetEntity( newTarget );	
			return;
		}
		//	still on target?
		else
		{
			curVecToTarget = vectorNormalize( missileTarget.origin - self.origin );
			if ( vectorDot( curVecToTarget, lastVecToTarget ) < 0 )
			{
				self playSound( "exp_stinger_armor_destroy" );
				playFX( level.QRDrone_fx["missile_explode"], self.origin );
				if ( isDefined( self.owner ) )
					RadiusDamage( self.origin, 400, 1000, 1000, self.owner, "MOD_EXPLOSIVE", "strela_mp" );
				else
					RadiusDamage( self.origin, 400, 1000, 1000, undefined, "MOD_EXPLOSIVE", "strela_mp" );
				self hide();
				wait ( 0.05 );
				self delete();
			}
			else
				lastVecToTarget = curVecToTarget;
		}			
			
		wait ( 0.05 );
	}	
}


watchSAMProximity( missileTarget, missileGroup )
{
	level endon ( "game_ended" );
	missileTarget endon( "death" );	

	foreach ( missile in missileGroup )
	{
		if ( isDefined( missile ) )
		{
			missile SetTargetEntity( missileTarget );
			missile.lastVecToTarget = vectorNormalize( missileTarget.origin - missile.origin );
		}
	}

	while( missileGroup.size && isDefined( missileTarget ) )
	{
		center = missileTarget GetPointInBounds( 0, 0, 0 );
		foreach ( missile in missileGroup )
		{
			if ( isDefined( missile ) )
			{
				if ( isDefined( self.markForDetete ) )
				{
					self delete();
					continue;
				}					
				
				//	flares?
				if ( missileTarget.numFlares > 0 )
				{
					distToTarget = distance( missile.origin, center );
					if ( distToTarget < 4000 )
					{
						newTarget = missileTarget deployFlares();
						foreach ( missileToRedirect in missileGroup )					
							if ( IsDefined( missileToRedirect ) )
								missileToRedirect SetTargetEntity( newTarget );
						return;						
					}					
				}
				//	still on target?
				else
				{
					curVecToTarget = vectorNormalize( missileTarget.origin - missile.origin );
					if ( vectorDot( curVecToTarget, missile.lastVecToTarget ) < 0 )
					{
						missile playSound( "exp_stinger_armor_destroy" );
						playFX( level.QRDrone_fx["missile_explode"], missile.origin );
						if ( isDefined( missile.owner ) )
							RadiusDamage( missile.origin, 400, 1000, 1000, missile.owner, "MOD_EXPLOSIVE", "strela_mp" );
						else
							RadiusDamage( missile.origin, 400, 1000, 1000, undefined, "MOD_EXPLOSIVE", "strela_mp" );
						missile hide();
						missile.markForDetete = true;					
					}
					else
						missile.lastVecToTarget = curVecToTarget;					
				}
			}
		}
		missileGroup = array_removeUndefined( missileGroup );
		
		wait ( 0.05 );
	}	
}


deployFlares()
{
	//	decrement
	self.numFlares--;
	
	//	player feedback
	self.owner thread QRDrone_Rumble( self, 6 );	
	self playSound( "WEAP_SHOTGUNATTACH_FIRE_NPC" );	
	
	//	fx
	self thread playFlareFx();			
	
	//	flare
	spawnPos = self.origin + (0,0,-100);
	flareObject = spawn( "script_origin", spawnPos );
	flareObject.angles = self.angles;	
	flareObject moveGravity( (0,0,-1), 5.0 );	
	flareObject thread deleteAfterTime( 5.0 );

	return flareObject;
}


playFlareFx()
{
	for ( i = 0; i < 5; i++ )
	{
		if ( !isDefined( self ) )
			return;
		PlayFXOnTag( level._effect[ "ac130_flare" ], self, "TAG_FLARE" );
		wait ( 0.15 );
	}
}


deleteAfterTime( delay )
{
	wait ( delay );
	
	self delete();
}


QRDrone_clearIncomingWarning()
{
	level endon ( "game_ended" );
	self endon ( "death" );
	self endon ( "end_remote" );	
	
	while( true )
	{		
		numIncoming = 0;
		for ( i=0; i<self.incomingMissiles.size; i++ )
		{
			if ( isDefined( self.incomingMissiles[i] ) && missile_isIncoming( self.incomingMissiles[i], self ) )
				numIncoming++;
		}		
		if ( self.hasIncoming && !numIncoming )
		{
			self.hasIncoming = false;
//			self.owner setPlayerData( "reconDroneState", "incomingMissile", false );			
		}
		self.incomingMissiles = array_removeUndefined( self.incomingMissiles );
		wait( 0.05 );		
	}
}


missile_isIncoming( missile, QRDrone )
{
	vecToRemote = vectorNormalize( QRDrone.origin - missile.origin );
	vecToFacing = anglesToForward( missile.angles );
	
	return ( vectorDot( vecToRemote, vecToFacing ) > 0 );
}


QRDrone_watchHeliProximity()
{
	level endon( "game_ended" );
	self  endon( "death" );
	self  endon( "end_remote" );
	
	while( true )
	{
		inHeliProximity = false;
//		foreach( heli in level.helis )
//		{
//			if ( distance( heli.origin, self.origin ) < UAV_REMOTE_MAX_HELI_PROXIMITY )
//			{
//				inHeliProximity = true;
//				self.heliInProximity = heli;
//			}
//		}
//		foreach( littlebird in level.littleBirds )
//		{
//			if ( littlebird != self && ( !isDefined(littlebird.heliType) || littlebird.heliType != "qrdrone" ) && distance( littlebird.origin, self.origin ) < UAV_REMOTE_MAX_HELI_PROXIMITY )
//			{
//				inHeliProximity = true;
//				self.heliInProximity = littlebird;	
//			}
//		}
		
		if ( !self.inHeliProximity && inHeliProximity )
			self.inHeliProximity = true;
		else if ( self.inHeliProximity && !inHeliProximity )
		{
			self.inHeliProximity = false;
			self.heliInProximity = undefined;
		}
		
		wait( 0.05 );
	}
}


QRDrone_handleDamage() // self == heli
{
	level endon( "game_ended" );
	self  endon( "death" );
	self  endon( "end_remote" );

	while( true )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath, modelName, tagName, partname, weapon, iDFlags );		

		if( IsDefined( self.specialDamageCallback ) )
			self [[self.specialDamageCallback]]( undefined, attacker, damage, iDFlags, meansOfDeath, weapon, point, direction_vec, undefined, undefined, modelName, partName );
	}
}


Callback_VehicleDamage( inflictor, attacker, damage, iDFlags, meansOfDeath, weapon, point, dir, hitLoc, timeOffset, modelIndex, partName )
{
	if ( self.destroyed == true )
		return;
		
	team = self.team;
	if ( isDefined( attacker.team ) )
		otherTeam = attacker.team;
	else
		otherTeam = "none";		
	
	//	allow owner but not team to damage
	if ( !isDefined( attacker ) || ( attacker != self.owner && level.teamBased && otherTeam == team ) )
		return;
		
	if ( IsDefined( iDFlags ) && ( iDFlags & level.iDFLAGS_PENETRATION ) )
		self.wasDamagedFromBulletPenetration = true;

	modifiedDamage = damage;

	if ( isPlayer( attacker ) )
	{
		attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( false );		

		if ( attacker HasPerk( "specialty_armorpiercing" ) )
		{
			modifiedDamage = damage * level.armorPiercingMod;			
		}
	}
	
	// in case we are shooting from a remote position, like being in the osprey gunner shooting this
	if( IsDefined( attacker.owner ) && IsPlayer( attacker.owner ) )
	{
		attacker.owner maps\mp\gametypes\_damagefeedback::updateDamageFeedback( false );
	}

	if( IsDefined( weapon ) )
	{
		if ( maps\mp\gametypes\_weapons::isLauncherWeapon( weapon ) )
		{
			self.largeProjectileDamage = true;
			modifiedDamage = self.maxHealth + 1;
		}
		else
		{
			switch( weapon )
			{
			case "bomb_site_mp":
			case "emp_grenade_mp":
				self.largeProjectileDamage = false;
				modifiedDamage = self.maxHealth + 1;
				break;
			}
		}
	}
	
	if ( isDefined( meansOfDeath ) && meansOfDeath == "MOD_MELEE" )
	{
		modifiedDamage = self.maxHealth + 1;
	}

	self.damageTaken += modifiedDamage;		
	//PlayFXOnTagForClients( level.QRDrone_fx["hit"], self, "tag_origin", self.owner );
	self playsound( "recondrone_damaged" );
	
	if ( self.smoking == false && self.damageTaken >= self.maxhealth/2 )
	{
		self.smoking = true;

		playFxOnTag( level.QRDrone_fx["smoke"], self, "tag_origin" );
		println( "QR Drone at half health: starting smoke" );
	}
	
	if ( self.damageTaken >= self.maxhealth  && ( (level.teamBased && team != otherTeam) || !level.teamBased) )
	{
		self.destroyed = true;
//		validAttacker = undefined;
//		if ( isDefined( attacker.owner ) && (!isDefined(self.owner) || attacker.owner != self.owner) )
//			validAttacker = attacker.owner;				
//		else if ( !isDefined(self.owner) || attacker != self.owner )
//			validAttacker = attacker;
//			
//		//	sanity checks	
//		if ( !isDefined(attacker.owner) && attacker.classname == "script_vehicle" )
//				validAttacker = undefined;
//		if ( isDefined( attacker.class ) && attacker.class == "worldspawn" )
//				validAttacker = undefined;	
//		if ( attacker.classname == "trigger_hurt" )
//				validAttacker = undefined;		
//
//		if ( isDefined( validAttacker ) )
//		{
////			validAttacker notify( "destroyed_killstreak", weapon );
////			thread teamPlayerCardSplash( "callout_destroyed_qrdrone", validAttacker );			
////			validAttacker AddRankXPValue( "kill", 50 );			
////			validAttacker thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_DESTROYED_REMOTE_UAV" );
////			thread maps\mp\gametypes\_missions::vehicleKilled( self.owner, self, undefined, validAttacker, damage, meansOfDeath, weapon );	
//		}
	}			
}

QRDrone_detonateWaiter()
{
	//self endon("death"); 
	self.owner endon("disconnect"); 
	self endon("death"); 
	
	while( self.owner attackbuttonpressed() ) 
		wait 0.05;

	watcher = self.owner maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "qrdrone" );
		
	while( !self.owner attackbuttonpressed() ) 
		wait 0.05;
		
	watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate(self,0);
	
	self.owner thread maps\mp\gametypes\_hud::fadeToBlackForXSec( GetDvarfloat( "scr_rcbomb_fadeOut_delay" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeIn" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeBlack" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeOut" ) );
}

QRDrone_blowup(attacker)
{
	self.owner endon("disconnect");
	self endon ("death");
	 
	explosionOrigin = self.origin;
	explosionAngles = self.angles;
	
	if ( !IsDefined( attacker ) )
	{
		attacker = self.owner;
	}
	
	origin = self.origin + (0,0,10);
	radius = 256;
	min_damage = 25;
	max_damage = 350;
	self radiusDamage( origin, radius, max_damage, min_damage, attacker,"MOD_EXPLOSIVE", "qrdrone_turret_mp");
	PhysicsExplosionSphere( origin, radius, radius, 1, max_damage, min_damage );
	maps\mp\gametypes\_shellshock::rcbomb_earthquake( origin );

	// CDC - play rc car exlposion sound TO DO replace with final explo sound after effects are in 
	playsoundatposition("mpl_sab_exp_suitcase_bomb_main", self.origin);

	PlayFX( level.QRDrone_fx["explode"] , explosionOrigin, (0, randomfloat(360), 0 ));

	//self SetModel( self.death_model );
	self Hide();

	if ( attacker != self.owner )
	{	
		attacker AddRankXP( "qrdronedestroy" );
		attacker maps\mp\_medals::destroyerQRDrone();
		attacker maps\mp\_properks::destroyedKillstreak();

		if( IsDefined( attacker.weaponUsedToDamage ) )
		{
			weapon = attacker.weaponUsedToDamage;
			weaponStatName = "destroyed";
			switch( weapon )
			{
				// SAM Turrets keep the kills stat for shooting things down because we used destroyed for when you destroy a SAM Turret
			case "auto_tow_mp":
			case "tow_turret_mp":
			case "tow_turret_drop_mp":
				weaponStatName = "kills";
				break;
			}
			attacker AddWeaponStat( weapon, weaponStatName, 1 );
			level.globalKillstreaksDestroyed++;
			// increment the destroyed stat for this, we aren't using the weaponStatName variable from above because it could be "kills" and we don't want that
			attacker AddWeaponStat( "qrdrone_turret_mp", "destroyed", 1 );
		}
	}

	wait(1);
	if ( isDefined( self.neverDelete ) && self.neverDelete )
	{
		return;
	}
	
	QRDrone_cleanup();
}

// self == player
setVisionsetWaiter()
{
	self endon("disconnect"); 
	
	self UseServerVisionset( true );
	self SetVisionSetForPlayer( level.qrdrone_vision, 1 );

	self.QRDrone waittill("end_remote"); 
	
	self UseServerVisionset( false );
}

inithud()
{
	self.leaving_play_area = newclienthudelem( self );
	self.leaving_play_area.fontScale = 1.25;
	self.leaving_play_area.x = 0;
	self.leaving_play_area.y = 50; 
	self.leaving_play_area.alignX = "center";
	self.leaving_play_area.alignY = "top";
	self.leaving_play_area.horzAlign = "center";
	self.leaving_play_area.vertAlign = "top";
	self.leaving_play_area.foreground = true;
	self.leaving_play_area.hidewhendead = false;
	self.leaving_play_area.hidewheninmenu = true;
	self.leaving_play_area.archived = false;
	self.leaving_play_area.alpha = 0.0;
	self.leaving_play_area SetText( &"MP_GUIDED_MISSILE_LOSING_SIGNAL" );
	
	self.fullscreen_static = newclienthudelem( self );
	self.fullscreen_static.x = 0;
	self.fullscreen_static.y = 0; 
	self.fullscreen_static.horzAlign = "fullscreen";
	self.fullscreen_static.vertAlign = "fullscreen";
	self.fullscreen_static.foreground = false;
	self.fullscreen_static.hidewhendead = false;
	self.fullscreen_static.hidewheninmenu = true;
	self.fullscreen_static.sort = 0; 
	self.fullscreen_static SetShader( "tow_filter_overlay_no_signal", 640, 480 ); 
	self.fullscreen_static.alpha = 0;
}

destroyHud()
{
	if ( isdefined( self.leaving_play_area ) )
		self.leaving_play_area destroy();
	
	if ( isdefined( self.fullscreen_static ) )
		self.fullscreen_static destroy();
}

set_static_alpha( alpha )
{
	self.fullscreen_static.alpha = alpha;
}