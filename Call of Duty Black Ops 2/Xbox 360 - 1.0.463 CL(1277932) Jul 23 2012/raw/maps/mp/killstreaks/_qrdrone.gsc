#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

#insert raw\maps\mp\_clientflags.gsh;
	
#define UAV_REMOTE_FLY_TIME 60
#define UAV_REMOTE_AIM_ASSIST_RANGE 200
#define UAV_REMOTE_MAX_PAST_RANGE 200
#define UAV_REMOTE_MIN_HELI_PROXIMITY 150
#define UAV_REMOTE_MAX_HELI_PROXIMITY 300
#define UAV_REMOTE_PAST_RANGE_COUNTDOWN 3
#define UAV_REMOTE_HELI_RANGE_COUNTDOWN 3
#define UAV_REMOTE_COLLISION_RADIUS 18
#define UAV_REMOTE_Z_OFFSET -9
#define UAV_REMOTE_MODEL "veh_t6_drone_quad_rotor_mp"
#define UAV_REMOTE_MODEL_ENEMY "veh_t6_drone_quad_rotor_mp_alt"
#define UAV_DEATH_MODEL "veh_t6_drone_quad_rotor_mp"
#define QRDRONE_MAX_HEALTH 175

init()
{	
	precacheModel( UAV_REMOTE_MODEL );
	precacheModel( UAV_REMOTE_MODEL_ENEMY );
	precacheModel( UAV_DEATH_MODEL );
	
	level.qrdrone_vehicle = "qrdrone_mp";
	
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
	
	loadfx( "weapon/qr_drone/fx_qr_light_green_3p" );
	loadfx( "weapon/qr_drone/fx_qr_light_red_3p" );
	loadfx( "weapon/qr_drone/fx_qr_light_green_1p" );
	
	level.ai_tank_stun_fx = loadfx( "weapon/talon/fx_talon_emp_stun" );

	level.QRDrone_minigun_flash = loadfx("weapon/muzzleflashes/fx_muz_mg_flash_3p");
	level.QRDrone_fx["explode"] = loadfx( "weapon/qr_drone/fx_exp_qr_drone" );	
	
//	level._effect[ "quadrotor_crash" ]	= LoadFX( "destructibles/fx_quadrotor_crash01" );
	level._effect[ "quadrotor_nudge" ]	= LoadFX( "weapon/qr_drone/fx_qr_drone_impact_sparks" );
	level._effect[ "quadrotor_damage" ]	= LoadFX( "weapon/qr_drone/fx_qr_drone_damage_state" );
//	level._effect[ "quadrotor_death" ]	= LoadFX( "destructibles/fx_quadrotor_death01" );

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
	
	level._effect["qrdrone_prop"] = loadfx( "weapon/qr_drone/fx_qr_wash_3p" );

	maps\mp\_treadfx::preloadtreadfx(level.qrdrone_vehicle);
	
/#
	set_dvar_if_unset( "scr_QRDroneFlyTime", 60 );
#/
	shouldTimeout = SetDvar("scr_qrdrone_no_timeout", 0);	

	maps\mp\killstreaks\_killstreaks::registerKillstreak( "qrdrone_mp", "killstreak_qrdrone_mp", "killstreak_qrdrone", "qrdrone_used", ::tryUseQRDrone );
	maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon( "qrdrone_mp", "qrdrone_turret_mp" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakStrings( "qrdrone_mp", &"KILLSTREAK_EARNED_QRDRONE", &"KILLSTREAK_QRDRONE_NOT_AVAILABLE", &"KILLSTREAK_QRDRONE_INBOUND" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakDialog( "qrdrone_mp", "mpl_killstreak_qrdrone", "kls_recondrone_used", "", "kls_recondrone_enemy", "", "kls_recondrone_ready" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar( "qrdrone_mp", "scr_giveqrdrone" );
	maps\mp\killstreaks\_killstreaks::overrideEntityCameraInDemo("qrdrone_mp", true);
}	

anyTeamHasQRDrones()
{
	foreach( team in level.teams )
	{
		if ( isDefined( level.qrdrone[team] ) )
			return true;
	}
	
	return false;
}

exceededMaxQRDrones( team )
{
	if ( level.gameType == "dm" )
	{
		if ( anyTeamHasQRDrones() )
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
			
	streakName = "TODO";
	result = self giveCarryQRDrone( lifeId, streakName );
		
	self.isCarrying = false;
	return ( result );
}


giveCarryQRDrone( lifeId, streakName )
{
	//	create carry object
	carryQRDrone = createCarryQRDrone( streakName, self );	
	
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
	carryQRDrone makeUnusable();	
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
				//	if they're holding it in launch position just launch now
				if ( self attackButtonPressed() )
					self notify( "place_carryQRDrone" );				
			}
			else
			{
			}
		}
		
		lastCanPlaceCarryQRDrone = carryQRDrone.canBePlaced;		
		wait ( 0.05 );
	}
}


carryQRDrone_handleExistence()
{
	level endon ( "game_ended" );
	self endon("death");
	self.owner endon ( "place_carryQRDrone" );
	self.owner endon ( "cancel_carryQRDrone" );

	self.owner waittill_any( "death", "disconnect", "joined_team", "joined_spectators" );

	if ( isDefined( self ) )
	{
		self delete();
	}
}

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
	self freezeControlsWrapper( true );
		
	result = self maps\mp\killstreaks\_killstreaks::initRideKillstreak( "qrdrone" );		
	
	if ( result != "success" )
	{
		if ( result != "disconnect" )
		{
			self freezeControlsWrapper( false );
			self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( "qrdrone_mp", self.team );
			self notify( "qrdrone_unlock" );
			self clearUsingRemote();
		}
		return false;
	}	

	team = self.team;
	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( "qrdrone_mp", team, false, true );
	if ( killstreak_id == -1 )
	{
		self notify( "qrdrone_unlock" );
		self freezeControlsWrapper( false );
		self clearUsingRemote();
		return false;
	}

	self notify( "qrdrone_unlock" );
	QRDrone = createQRDrone( lifeId, self, streakName, origin, angles );
	self freezeControlsWrapper( false );
	if ( isDefined( QRDrone ) )
	{
		self thread QRDrone_Ride( lifeId, QRDrone, streakName );
		QRDrone waittill( "end_remote" );

		maps\mp\killstreaks\_killstreakrules::killstreakStop( "qrdrone_mp", team, killstreak_id );
		return true;
	}
	else
	{
		self iPrintLnBold( &"MP_TOO_MANY_VEHICLES" );
		self clearUsingRemote();
		maps\mp\killstreaks\_killstreakrules::killstreakStop( "qrdrone_mp", team, killstreak_id );
		return false;	
	}		
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
	
	lockSpot delete();
}


createQRDrone( lifeId, owner, streakName, origin, angles, killstreak_id )
{
	QRDrone = spawnHelicopter( owner, origin, angles, level.qrdrone_vehicle, UAV_REMOTE_MODEL );	
	if ( !isDefined( QRDrone ) )
		return undefined;
			
	QRDrone.lifeId = lifeId;
	QRDrone.team = owner.team;
	QRDrone.pers["team"] = owner.team;	
	QRDrone.owner = owner;

	QRDrone.health = 999999; // keep it from dying anywhere in code
	QRDrone.maxHealth = 250; // this is the health we'll check
	QRDrone.damageTaken = 0;	
	QRDrone.destroyed = false;
	QRDrone setCanDamage( true );
		
	QRDrone.smoking = false;
	QRDrone.inHeliProximity = false;		
	QRDrone.heliType = "qrdrone";	
	QRDrone.markedPlayers = [];
	QRDrone.isStunned = false;
	QRDrone SetEnemyModel( UAV_REMOTE_MODEL_ENEMY );
	QRDrone SetDrawInfrared( true );
	
	QRDrone.killCamEnt = QRDrone.owner;
		
	owner maps\mp\gametypes\_weaponobjects::addWeaponObjectToWatcher( "qrdrone", QRDrone );
	QRDrone thread QRDrone_explode_on_notify(killstreak_id);
	QRDrone thread QRDrone_explode_on_game_end();

	QRDrone thread QRDrone_leave_on_timeout();
	QRDrone thread QRDrone_watch_distance();
	
	QRDrone thread deleteOnKillbrush( owner );

	// make the qrdrone targetable
	Target_Set( QRDrone, (0,0,0) );
	Target_SetTurretAquire( QRDrone, false );
	
	QRDrone.numFlares = 0;
	QRDrone.flareOffset = (0,0,-100);						
	QRDrone thread maps\mp\_heatseekingmissile::MissileTarget_LockOnMonitor( self, "end_remote" );				// monitors missle lock-ons
	QRDrone thread maps\mp\_heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "crashing" );

	// create the influencers
	QRDrone maps\mp\gametypes\_spawning::create_qrdrone_influencers( QRDrone.team );
	
	level.qrdrone[QRDrone.team] = QRDrone;
	return QRDrone;
}


QRDrone_ride( lifeId, QRDrone, streakName )
{		
	self.killstreak_waitamount = QRDrone.flyTime * 1000;
	QRDrone.playerLinked = true;
	self.restoreAngles = self.angles;
		
	QRDrone usevehicle( self, 0 );
	self ClientNotify( "qrfutz" );	
	self maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "qrdrone_mp", self.pers["team"] );

	self.qrdrone_rideLifeId = lifeId;
	self.QRDrone = QRDrone;
	
	self thread QRDrone_delayLaunchDialog( QRDrone );
	self thread QRDrone_fireGuns( QRDrone );
		
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
		
		if ( IsDefined( self.viewlockedentity ) )
		{
			self Unlink();
			if ( isdefined(level.gameEnded) && level.gameEnded )
			{
				self freezecontrolswrapper( true );
			}	
		}
		
		self.killstreak_waitamount = undefined;
		self setPlayerAngles( self.restoreAngles );	
		
		if ( isalive(self) )
		{
			self switchToWeapon( self getLastWeapon() );
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

deleteOnKillbrush(player)
{
	player endon("disconnect");
	self endon("death");
		
	killbrushes = GetEntArray( "trigger_hurt","classname" );

	while(1)
	{
		for (i = 0; i < killbrushes.size; i++)
		{
			if (self istouching(killbrushes[i]) )
			{
				
				if( self.origin[2] > player.origin[2] )
					break;

				if ( isdefined(self) )
				{
					watcher =  self.owner maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "qrdrone" );
					watcher thread waitAndDetonate( self, 0.0);	
				}

				return;
			}
		}
		wait( 0.1 );
	}
	
}

QRDrone_get_damage_effect( health_pct )
{
	if( health_pct > .5 )
	{
		return level._effect[ "quadrotor_damage" ];
	}
	
	return undefined;
}

QRDrone_play_single_fx_on_tag( effect, tag )
{	
	if( IsDefined( self.damage_fx_ent ) )
	{
		if( self.damage_fx_ent.effect == effect )
		{
			// already playing
			return;
		}
		self.damage_fx_ent delete();
	}
	
	
//	ent = Spawn( "script_model", ( 0, 0, 0 ) );
//	ent SetModel( "tag_origin" );
//	ent.origin = self GetTagOrigin( tag );
//	ent.angles = self GetTagAngles( tag );
//	ent NotSolid();
//	ent Hide();
//	ent LinkTo( self, tag );
//	ent.effect = effect;
//	playfxontag( effect, ent, "tag_origin" );
//	ent playsound("veh_qrdrone_sparks");
//
//		
//	self.damage_fx_ent = ent;
	
	playfxontag( effect, self, "tag_origin" );

}

QRDrone_update_damage_fx( health_percent )
{	
	effect = QRDrone_get_damage_effect( health_percent );
	if( IsDefined( effect ) )
	{
		QRDrone_play_single_fx_on_tag( effect, "tag_origin" );	
	}
	else
	{
		if( IsDefined( self.damage_fx_ent ) )
		{
			self.damage_fx_ent delete();
		}
	}
}

QRDrone_damageWatcher()
{
	self endon( "death" );

	self.maxhealth = 999999;
	self.health = self.maxhealth;
	
	low_health = false;
	damage_taken = 0;

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, dir, point, mod, model, tag, part, weapon, flags );
		
		if( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;

		self.maxhealth = 999999;
		self.health = self.maxhealth;
		
		self.owner playrumbleonentity("damage_heavy");

/#
		self.damage_debug = ( damage + " (" + weapon + ")" );
#/
		
		if ( mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET")
		{
			if ( isPlayer( attacker ) )
			{
			    if ( attacker HasPerk( "specialty_armorpiercing" ) )
			    {
					damage += int( damage * level.cac_armorpiercing_data );
			    }
			}
		}	
			
		if ( weapon == "emp_grenade_mp" && (mod == "MOD_GRENADE_SPLASH"))
		{
			damage_taken += ( QRDRONE_MAX_HEALTH );
			damage = 0;
		}
		
		if (!self.isStunned)
		{
			if ( (weapon == "proximity_grenade_mp" || weapon == "proximity_grenade_aoe_mp" ) && (mod == "MOD_GRENADE_SPLASH" || mod == "MOD_GAS") )
			{
				self.isStunned = true;
				self QRDrone_stun( 2 );
			}
		}
		
		self.attacker = attacker;

		damage_taken += damage;

			
		if ( damage_taken >= QRDRONE_MAX_HEALTH )
		{
			self QRDrone_death( attacker, weapon, dir );
			return;
		}
		else 
		{
			QRDrone_update_damage_fx( float(damage_taken) / QRDRONE_MAX_HEALTH );
		}
	}
}

QRDrone_stun( duration )
{	
	self endon( "death" );
	self notify( "stunned" );
	
	//PlayFX( level.ai_tank_stun_fx, self.origin + (0,0,-20) + AnglesToForward(self.angles) * 6, AnglestoForward(self.angles) );
	
	self.owner freezeControlsWrapper( true );
	
	if (isDefined(self.owner.fullscreen_static))
	{
		self.owner thread maps\mp\killstreaks\_remote_weapons::stunStaticFX( duration );
	}
	wait ( duration );
	
	self.owner freezeControlsWrapper( false );

	self.isStunned = false;
}

QRDrone_death( attacker, weapon, dir )
{
	if( IsDefined( self.damage_fx_ent ) )
	{
		self.damage_fx_ent delete();
	}
	
	if ( isDefined(attacker) && IsPlayer(attacker) && attacker != self.owner)
	{
		level thread maps\mp\_popups::DisplayTeamMessageToAll( &"SCORE_DESTROYED_QRDRONE", attacker ); 
		maps\mp\_scoreevents::processScoreEvent( "destroyed_qrdrone", attacker, self.owner, weapon );
	}
		
	self thread QRDrone_crash_movement( attacker, dir );
	if ( weapon == "emp_grenade_mp" )
	{
		self.emp_fx = Spawn("script_model", self.origin);
		self.emp_fx SetModel("tag_origin");
		self.emp_fx LinkTo(self, "tag_origin", (0,0,-20) + AnglesToForward(self.angles) * 6);
		wait(0.1);
		PlayFXOnTag( level.ai_tank_stun_fx, self.emp_fx, "tag_origin");
	}
	
	self waittill( "crash_done" );
	
	if ( isDefined(self.emp_fx) )
	{
		self.emp_fx delete();
	}
	// A dynEnt will be spawned in the collision thread when it hits the ground and "crash_done" notify will be sent
	//self freeVehicle();
	//wait 20;
	watcher =  self.owner maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "qrdrone" );
	watcher thread waitAndDetonate( self, 0.0, attacker, weapon );
}

death_fx()
{
	playfxontag( self.deathfx, self, self.deathfxtag );
	self playsound("veh_qrdrone_sparks");
}

QRDrone_crash_movement( attacker, hitdir )
{
	self endon( "crash_done" );
	self endon( "death" );
	self notify( "crashing" );
	
	// take away driver control
	self takeplayercontrol();
	
	self SetMaxPitchRoll( 90, 180 );
	self SetPhysAcceleration( ( 0, 0, -800 ) );

	side_dir = VectorCross( hitdir, (0,0,1) );
	side_dir_mag = RandomFloatRange( -100, 100 );
	side_dir_mag += Sign( side_dir_mag ) * 80;
	side_dir *= side_dir_mag;
	
	velocity = self GetVelocity();
	self SetVehVelocity( velocity + (0,0,100) + VectorNormalize( side_dir ) );

	ang_vel = self GetAngularVelocity();
	ang_vel = ( ang_vel[0] * 0.3, ang_vel[1], ang_vel[2] * 0.3 );
	
	yaw_vel = RandomFloatRange( 0, 210 ) * Sign( ang_vel[1] );
	yaw_vel += Sign( yaw_vel ) * 180;
	
	ang_vel += ( RandomFloatRange( -100, 100 ), yaw_vel, RandomFloatRange( -200, 200 ) );
	
	self SetAngularVelocity( ang_vel );
	
	self.crash_accel = RandomFloatRange( 75, 110 );
	
	self thread QRDrone_crash_accel();
	self thread QRDrone_collision();
	
	//drone death sounds JM - play 1 shot hit, turn off main loop, thread dmg loop
	self playsound("veh_qrdrone_dmg_hit");
	self thread QRDrone_dmg_snd();

	wait 0.1;
	//Eckert - failsfae to turn off damage loop sound
	level notify ("stop_failsafe");
	
	if( RandomInt( 100 ) < 40 )
	{
		self thread QRDrone_fire_for_time( RandomFloatRange( 0.7, 2.0 ) );
	}
	
	wait 2;
	
	// failsafe notify
	self notify( "crash_done" );
}


QRDrone_dmg_snd()
{
	self endon( "crash_done" );
	self endon( "death" );
	
	dmg_ent = spawn("script_origin", self.origin);
	dmg_ent linkto (self);
	dmg_ent PlayLoopSound ("veh_qrdrone_dmg_loop");
	self thread failsafe(dmg_ent);
	self waittill("crash_done");
	dmg_ent stoploopsound(.2);
	wait (2);
	dmg_ent delete();
}

failsafe(dmg_ent)
{
	level waittill ("stop_failsafe");
	wait 1;
	//iprintlnbold ("Failsafe stopsound");
	dmg_ent stoploopsound(.5);
	dmg_ent delete();
}

QRDrone_fire_for_time( totalFireTime )
{
	self endon( "crash_done" );
	self endon( "change_state" );
	self endon( "death" );
	
	weaponName = self SeatGetWeapon( 0 );
	fireTime = WeaponFireTime( weaponName );
	time = 0;
	
	fireCount = 1;
	
	while( time < totalFireTime )
	{
		self FireWeapon( undefined, undefined, fireCount % 2 );
		fireCount++;
		wait fireTime;
		time += fireTime;
	}
}

QRDrone_crash_accel()
{
	self endon( "crash_done" );
	self endon( "death" );
	
	count = 0;
	
	while( 1 )
	{
		velocity = self GetVelocity();
		self SetVehVelocity( velocity + AnglesToUp( self.angles ) * self.crash_accel );
		self.crash_accel *= 0.98;
		
		wait 0.1;
		
		count++;
		if( count % 8 == 0 )
		{
			if( RandomInt( 100 ) > 40 )
			{
				if( velocity[2] > 150.0 )
				{
					self.crash_accel *= 0.75;
				}
				else if( velocity[2] < 40.0 && count < 60 )
				{
					if( Abs( self.angles[0] ) > 30 || Abs( self.angles[2] ) > 30 )
					{
						self.crash_accel = RandomFloatRange( 160, 200 );
					}
					else
					{
						self.crash_accel = RandomFloatRange( 85, 120 );
					}
				}
			}
		}
	}
}

QRDrone_collision()
{
	self endon( "crash_done" );
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "veh_collision", velocity, normal );
		ang_vel = self GetAngularVelocity() * 0.5;
		self SetAngularVelocity( ang_vel );
		
		velocity = self GetVelocity();
		
		// bounce off walls
		if( normal[2] < 0.7 )	
		{
			self SetVehVelocity( velocity + normal * 70 );
			self playsound ("veh_qrdrone_wall");
			PlayFX( level._effect[ "quadrotor_nudge" ], self.origin );
		}
		else
		{
			//self.crash_accel *= 0.5;
			//self SetVehVelocity( self.velocity * 0.8 );
//			CreateDynEntAndLaunch( self.deathmodel, self.origin, self.angles, self.origin, velocity * 0.03, level._effect[ "quadrotor_crash" ], 1 );
			self playsound ("veh_qrdrone_explo");
			self notify( "crash_done" );
		}
	}
}

QRDrone_watch_distance()
{
	self endon ("death" );
	
	self.owner inithud();

	qrdrone_height = getstruct( "qrdrone_height", "targetname");
	if ( IsDefined(qrdrone_height) )
	{
		self.maxHeight = qrdrone_height.origin[2];
	}
	else
	{
		self.maxHeight = int(maps\mp\killstreaks\_airsupport::getMinimumFlyHeight());
	}
	
	self.maxDistance = 12800;		
	
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
					staticAlpha = min( .7, dist/UAV_REMOTE_MAX_PAST_RANGE );					
				}
				
				self.owner set_static_alpha( staticAlpha );
				
				wait ( 0.05 );
			}
			
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


QRDrone_explode_on_notify( killstreak_id )
{
	self endon ( "death" );	

	self.owner waittill_any( "disconnect", "joined_team", "joined_spectators" );
	
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "qrdrone_mp", self.team, killstreak_id );
	self.owner clearUsingRemote();
	self.owner destroyHud();
	self.owner.killstreak_waitamount = 0;
	watcher =  self.owner maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "qrdrone" );
	watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate(self,0);
}


QRDrone_explode_on_game_end()
{
	self endon ( "death" );	

	level waittill( "game_ended" );
	
	watcher =  self.owner maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "qrdrone" );
	watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate(self,0);
}


QRDrone_leave_on_timeout()
{
	self endon ( "death" );	
	
	if ( !level.vehiclesTimed ) 
		return;

	self.flyTime = 60.0;
	waittime = self.flyTime - 10;
/#
	set_dvar_int_if_unset( "scr_QRDroneFlyTime", self.flyTime );
	self.flyTime = GetDvarInt( "scr_QRDroneFlyTime" );
	waittime = self.flyTime - 10;
	if( waittime < 0 )
	{
		wait( self.flyTime );
		watcher =  self.owner maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "qrdrone" );
		watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate(self,0);
		return;
	}
#/	
	
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( waittime );
	shouldTimeout = GetDvar("scr_qrdrone_no_timeout");	
	if (shouldTimeout == "1")
	{
		return;
	}
	self SetClientFlag( CLIENT_FLAG_COUNTDOWN );
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( 6 );
	self SetClientFlag( CLIENT_FLAG_TIMEOUT );
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( 4 );
		
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

QRDrone_cleanup()
{	
	if ( self.playerLinked == true && isDefined( self.owner ) )
		self.owner QRDrone_endride( self );	
		
	if ( isDefined( self.scrambler ) )
		self.scrambler delete();
		
	if ( isdefined(self) && isDefined( self.centerRef ) )
		self.centerRef delete();
	
	Target_SetTurretAquire( self, false );
		
	level.qrdrone[self.team] = undefined;

	if( IsDefined( self.damage_fx_ent ) )
	{
		self.damage_fx_ent delete();
	}
	
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

	self playLocalSound( soundAlias );
}

QRDrone_watchHeliProximity()
{
	level endon( "game_ended" );
	self  endon( "death" );
	self  endon( "end_remote" );
	
	while( true )
	{
		inHeliProximity = false;
		
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


QRDrone_detonateWaiter()
{
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

QRDrone_fireGuns( QRDrone )
{
	self endon ( "disconnect" );
	QRDrone endon ( "death" );
	QRDrone endon ( "blowup" );
	QRDrone endon ( "crashing" );
	level endon ( "game_ended" );
	QRDrone endon ( "end_remote" );	
	
	//	transition into remote
	wait( 1 );
	
	while ( true )
	{	
		if ( self AttackButtonPressed() )
		{
			QRDrone FireWeapon( "tag_flash");
			fireTime = WeaponFireTime( "qrdrone_turret_mp" );
			
			wait( fireTime );			
		}
		else
		{
			wait( 0.05 ); 				
		}
	}
}

QRDrone_blowup(attacker, weaponName)
{
	self.owner endon("disconnect");
	self endon ("death");

	self notify("blowup");
	
	explosionOrigin = self.origin;
	explosionAngles = self.angles;
	
	if ( !IsDefined( attacker ) )
	{
		attacker = self.owner;
	}

	from_emp = maps\mp\killstreaks\_emp::isEmpWeapon( weaponName );
	
	origin = self.origin + (0,0,10);
	radius = 256;
	min_damage = 10;
	max_damage = 35;

	if ( !from_emp )
	{
		if ( isDefined(attacker) )
		{
			self radiusDamage( origin, radius, max_damage, min_damage, attacker,"MOD_EXPLOSIVE", "qrdrone_turret_mp");
		}
		PhysicsExplosionSphere( origin, radius, radius, 1, max_damage, min_damage );
		maps\mp\gametypes\_shellshock::rcbomb_earthquake( origin );

		// CDC - play rc car exlposion sound TO DO replace with final explo sound after effects are in 
		playsoundatposition("veh_qrdrone_explo", self.origin);

		PlayFX( level.QRDrone_fx["explode"] , explosionOrigin, (0, 0, 1 ));
	}

	self Hide();
	if( isDefined(self.owner))
	{
		self.owner clientnotify("qrdrone_blowup");

		if ( attacker != self.owner )
		{	
			//attacker maps\mp\_properks::destroyedKillstreak();
	
			if( IsDefined( weaponName ) )
			{
				weaponStatName = "destroyed";
				switch( weaponName )
				{
					// SAM Turrets keep the kills stat for shooting things down because we used destroyed for when you destroy a SAM Turret
				case "auto_tow_mp":
				case "tow_turret_mp":
				case "tow_turret_drop_mp":
					weaponStatName = "kills";
					break;
				}
				attacker AddWeaponStat( weaponName, weaponStatName, 1 );
				level.globalKillstreaksDestroyed++;
				// increment the destroyed stat for this, we aren't using the weaponStatName variable from above because it could be "kills" and we don't want that
				attacker AddWeaponStat( "qrdrone_turret_mp", "destroyed", 1 );
			}
		}	
		self.owner maps\mp\killstreaks\_ai_tank::destroy_remote_hud();
		
		self.owner freezeControlsWrapper( true );	
		self.owner thread maps\mp\killstreaks\_remotemissile::staticEffect( 1.0 );
		wait(0.75);
		self.owner thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0, 0.25, 0.1, 0.25 );
		wait(0.25);
		self.owner freezeControlsWrapper( false );

		if ( isDefined( self.neverDelete ) && self.neverDelete )
		{
			return;
		}	
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
	
	self maps\mp\killstreaks\_ai_tank::destroy_remote_hud();
	self ClientNotify( "nofutz" );
}

set_static_alpha( alpha )
{
	if ( isDefined(self.fullscreen_static) && isDefined(self.leaving_play_area) )
	{
		self.fullscreen_static.alpha = alpha;
		if ( alpha > 0 )
			self.leaving_play_area.alpha = 1;
		else
			self.leaving_play_area.alpha = alpha;
	}
}