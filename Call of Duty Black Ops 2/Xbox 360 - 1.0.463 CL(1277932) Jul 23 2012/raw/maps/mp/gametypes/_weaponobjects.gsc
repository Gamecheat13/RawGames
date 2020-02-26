#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#insert raw\maps\mp\_clientflags.gsh;

init()
{
	/#
	debug = weapons_get_dvar_int( "scr_weaponobject_debug", "0" );
	#/
	coneangle = weapons_get_dvar_int( "scr_weaponobject_coneangle", "70" );
	mindist = weapons_get_dvar_int( "scr_weaponobject_mindist", "20" );
	graceperiod = weapons_get_dvar( "scr_weaponobject_graceperiod", "0.6" );
	radius = weapons_get_dvar_int( "scr_weaponobject_radius", "192" );

	level thread onPlayerConnect();

	level.watcherWeapons = [];
	level.watcherWeapons = getWatcherWeapons();
	level.watcherWeaponNames = [];
	level.watcherWeaponNames = getWatcherNames( level.watcherWeapons );

	level.retrievableWeapons = [];
	level.retrievableWeapons = getRetrievableWeapons();
	level.retrievableWeaponNames = [];
	level.retrievableWeaponNames = getWatcherNames( level.retrievableWeapons );

	level.weaponobjects_headicon_offset = [];
	level.weaponobjects_headicon_offset["default"] = (0, 0, 20); 

	level.weaponobjectexplodethisframe = false;

	if ( GetDvar( "scr_deleteexplosivesonspawn") == "" )
		SetDvar("scr_deleteexplosivesonspawn", 1);
	
	level.deleteExplosivesOnSpawn = GetDvarInt( "scr_deleteexplosivesonspawn");

	if ( SessionModeIsZombiesGame() )
	{
		return;
	}

	PrecacheString( &"MP_DEFUSING_EXPLOSIVE" );

	level.claymoreFXid = loadfx( "weapon/claymore/fx_claymore_laser" );
	level._equipment_spark_fx = loadfx( "weapon/grenade/fx_spark_disabled_weapon" );
	level._equipment_emp_destroy_fx = loadfx( "weapon/emp/fx_emp_explosion_equip" );
	level._equipment_explode_fx = loadfx( "explosions/fx_exp_equipment" );
	level._effect[ "powerLight" ] = loadfx( "weapon/crossbow/fx_trail_crossbow_blink_red_os" );

	setUpRetrievableHintStrings();
	
	level.weaponobjects_headicon_offset["acoustic_sensor_mp"] = (0, 0, 25); 
	level.weaponobjects_headicon_offset["sensor_grenade_mp"] = (0, 0, 25); 
	level.weaponobjects_headicon_offset["camera_spike_mp"] = (0, 0, 35); 
	level.weaponobjects_headicon_offset["claymore_mp"] = (0, 0, 20); 
	level.weaponobjects_headicon_offset["bouncingbetty_mp"] = (0, 0, 20);
	level.weaponobjects_headicon_offset["satchel_charge_mp"] = (0, 0, 10); 
	level.weaponobjects_headicon_offset["scrambler_mp"] = (0, 0, 20); 
	level.weaponobjects_headicon_offset["trophy_system_mp"] = (0, 0, 20); 
	
	level.weaponobjects_hacker_trigger_width = 32; 
	level.weaponobjects_hacker_trigger_height = 32; 
	
}

getWatcherNames( weapons )
{
	names = [];
	
	foreach( index, weapon in weapons )
	{
		names[index] = getSubStr( weapon, 0, weapon.size - 3 );// the - 3 removes the _mp from the weapon name
	}
	return names;
}

// returns dvar value in int
weapons_get_dvar_int( dvar, def )
{
	return int( weapons_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
weapons_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
	{
		return getdvarfloat( dvar );
	}
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

setUpRetrievableHintStrings()
{
	createRetrievableHint("hatchet", &"MP_HATCHET_PICKUP");
	createRetrievableHint("claymore", &"MP_CLAYMORE_PICKUP");
	createRetrievableHint("bouncingbetty", &"MP_BOUNCINGBETTY_PICKUP");
	createRetrievableHint("trophy_system", &"MP_TROPHY_SYSTEM_PICKUP");
	createRetrievableHint("acoustic_sensor", &"MP_ACOUSTIC_SENSOR_PICKUP");
	//createRetrievableHint("sensor_grenade", &"MP_SENSOR_GRENADE_PICKUP");
	createRetrievableHint("camera_spike", &"MP_CAMERA_SPIKE_PICKUP");
	createRetrievableHint("satchel_charge", &"MP_SATCHEL_CHARGE_PICKUP");
	createRetrievableHint("scrambler", &"MP_SCRAMBLER_PICKUP");

	createDestroyHint( "trophy_system", &"MP_TROPHY_SYSTEM_DESTROY");
	createDestroyHint( "sensor_grenade", &"MP_SENSOR_GRENADE_DESTROY");

	createHackerHint("claymore_mp", &"MP_CLAYMORE_HACKING");
	createHackerHint("bouncingbetty_mp", &"MP_BOUNCINGBETTY_HACKING");
	createHackerHint("trophy_system_mp", &"MP_TROPHY_SYSTEM_HACKING");
	createHackerHint("acoustic_sensor_mp", &"MP_ACOUSTIC_SENSOR_HACKING");
	//createHackerHint("sensor_grenade_mp", &"MP_SENSOR_GRENADE_HACKING");
	createHackerHint("camera_spike_mp", &"MP_CAMERA_SPIKE_HACKING");
	createHackerHint("satchel_charge_mp", &"MP_SATCHEL_CHARGE_HACKING");
	createHackerHint("scrambler_mp", &"MP_SCRAMBLER_HACKING");
}

onPlayerConnect()
{
	if ( isdefined( level._weaponobjects_on_player_connect_override ) )
	{
		level thread [[level._weaponobjects_on_player_connect_override]]();
		return;
	}

	for(;;)
	{
		level waittill("connecting", player);

		player.usedWeapons = false;
		player.hits = 0;

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned() // self == player
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		pixbeginevent("onPlayerSpawned");		
		
		if ( !isdefined( self.watchersInitialized ) )
		{
			self createBaseWatchers();
	
			//Ensure that the watcher name is the weapon name minus _mp if you want to add weapon specific functionality.
			self maps\mp\_satchel_charge::createSatchelWatcher();
	//		self maps\mp\_decoy::createDecoyWatcher();
	//		self maps\mp\_scrambler::createScramblerWatcher();
	//		self maps\mp\_acousticsensor::createAcousticSensorWatcher();
	//		self maps\mp\_cameraspike::createCameraSpikeWatcher();
			self maps\mp\_proximity_grenade::createProximityGrenadeWatcher();
			self maps\mp\_bouncingbetty::createBouncingBettyWatcher();
			self maps\mp\_trophy_system::createTrophySystemWatcher();
			self maps\mp\_sensor_grenade::createSensorGrenadeWatcher();
			self createClaymoreWatcher();
			self createRCBombWatcher();
			self createQRDroneWatcher();
			self createPlayerHelicopterWatcher();
			self createBallisticKnifeWatcher();
			self createHatchetWatcher();
			self createTactInsertWatcher();
	
			//set up retrievable specific fields
			self setupRetrievableWatcher();
		
			self thread watchWeaponObjectUsage();
			
			self.watchersInitialized = true;
		}
		
		self resetWatchers();
		
		pixendevent();
	}
}

resetWatchers()
{
	if ( !IsDefined(self.weaponObjectWatcherArray) )
	{
		return undefined;
	}
	
	team = self.team;
	
	foreach( watcher in self.weaponObjectWatcherArray )
	{
		resetWeaponObjectWatcher( watcher, team );
	}	
}

createBaseWatchers()
{
	//Check for die on respawn weapons
	foreach( index, weapon in level.watcherWeapons )
	{
		self createWeaponObjectWatcher( level.watcherWeaponNames[index], weapon, self.team );
	}

	//Check for retrievable weapons
	foreach( index, weapon in level.retrievableWeapons )
	{
		self createWeaponObjectWatcher( level.retrievableWeaponNames[index], weapon, self.team );
	}
}

setupRetrievableWatcher()
{
	//Check for retrievable weapons
	for( i = 0; i < level.retrievableWeapons.size; i++ )
	{
		watcher = getWeaponObjectWatcherByWeapon( level.retrievableWeapons[i] );

		if( !isDefined( watcher.onSpawnRetrieveTriggers ) )
			watcher.onSpawnRetrieveTriggers = ::onSpawnRetrievableWeaponObject;

		if ( !isDefined( watcher.onDestroyed ))
			watcher.onDestroyed = ::onDestroyed;

		if( !isDefined( watcher.pickUp ) )
			watcher.pickUp = ::pickUp;
	}
}

createBallisticKnifeWatcher() // self == player
{
	watcher = self createUseWeaponObjectWatcher( "knife_ballistic", "knife_ballistic_mp", self.team );
	watcher.onSpawn = maps\mp\_ballistic_knife::onSpawn;
	watcher.detonate = ::deleteEnt;
	watcher.onSpawnRetrieveTriggers = maps\mp\_ballistic_knife::onSpawnRetrieveTrigger;
	watcher.storeDifferentObject = true;
}

createHatchetWatcher() // self == player
{
	watcher = self createUseWeaponObjectWatcher( "hatchet", "hatchet_mp", self.team );
	watcher.detonate = ::deleteEnt;
	watcher.onSpawn = ::voidOnSpawn;
	watcher.onSpawnRetrieveTriggers = ::onSpawnHatchetTrigger;
}

createTactInsertWatcher() // self == player
{
	watcher = self createUseWeaponObjectWatcher( "tactical_insertion", "tactical_insertion_mp", self.team );
	watcher.playDestroyedDialog = false;
}

createRCBombWatcher() // self == player
{
	watcher = self createUseWeaponObjectWatcher( "rcbomb", "rcbomb_mp", self.team );

	watcher.altDetonate = false;
	watcher.headIcon = false;
	watcher.isMovable = true;
	watcher.ownerGetsAssist = true;
	watcher.playDestroyedDialog = false;
	watcher.deleteOnKillbrush = false;

	watcher.detonate = maps\mp\killstreaks\_rcbomb::blowup;	
	// rc bomb does not use normal server side equipment stun fx
	//watcher.stun = ::weaponStun;
	watcher.stunTime = 2;
}

createQRDroneWatcher() // self == player
{
	watcher = self createUseWeaponObjectWatcher( "qrdrone", "qrdrone_turret_mp", self.team );

	watcher.altDetonate = false;
	watcher.headIcon = false;
	watcher.isMovable = true;
	watcher.ownerGetsAssist = true;
	watcher.playDestroyedDialog = false;
	watcher.deleteOnKillbrush = false;

	watcher.detonate = maps\mp\killstreaks\_qrdrone::QRDrone_blowup;
	watcher.onDamage = maps\mp\killstreaks\_qrdrone::QRDrone_damageWatcher;
	// rc bomb does not use normal server side equipment stun fx
	//watcher.stun = ::weaponStun;
	watcher.stunTime = 5;
}

createPlayerHelicopterWatcher() // self == player
{
	watcher = self createUseWeaponObjectWatcher( "helicopter_player", "helicopter_player_mp", self.team );

	watcher.altDetonate = true;
	watcher.headIcon = false;
	
	//watcher.detonate = maps\mp\killstreaks\_helicopter_player::blowup;
}

createClaymoreWatcher() // self == player
{
	watcher = self createProximityWeaponObjectWatcher( "claymore", "claymore_mp", self.team );
	watcher.watchForFire = true;
	watcher.detonate = ::claymoreDetonate;
	watcher.activateSound = "wpn_claymore_alert";
	watcher.hackable = true;
	watcher.reconModel = "t6_wpn_claymore_world_detect";
	watcher.ownerGetsAssist = true;

	detectionConeAngle = weapons_get_dvar_int( "scr_weaponobject_coneangle" );
	watcher.detectionDot = cos( detectionConeAngle );
	watcher.detectionMinDist = weapons_get_dvar_int( "scr_weaponobject_mindist" );
	watcher.detectionGracePeriod = weapons_get_dvar( "scr_weaponobject_graceperiod" );
	watcher.detonateRadius = weapons_get_dvar_int( "scr_weaponobject_radius" );
	watcher.stun = ::weaponStun;
	watcher.stunTime = 5;
}

waittillNotMoving_and_notStunned()
{
	prevorigin = self.origin;
	while(1)
	{
		wait .15;
		if ( self.origin == prevorigin && !(self isstunned()) )
			break;
		prevorigin = self.origin;
	}
}

voidOnSpawn( unused0, unused1 )
{
}


deleteEnt( attacker, emp )
{
	self delete();
}

clearFXOnDeath( fx )
{
	fx endon("death");
	self waittill_any( "death", "hacked" );
	fx delete();
}

//
// generic watcher code
//

deleteWeaponObjectArray() 
{
		if ( IsDefined(self.objectArray) ) 
		{
			for ( i = 0; i < self.objectArray.size; i++ )
			{
				if ( isdefined(self.objectArray[i]) )
					self.objectArray[i] delete();
				}
			}
		
		self.objectArray = [];
}

claymoreDetonate(attacker, weaponName)
{
	from_emp = maps\mp\killstreaks\_emp::isEmpWeapon( weaponName );

	if ( !IsDefined( from_emp ) || !from_emp )
	{
		if ( IsDefined( attacker ) )
		{
			if ( ( level.teambased && attacker.team != self.owner.team ) || ( attacker != self.owner ) ) 
			{
				attacker maps\mp\_challenges::destroyedExplosive();
				maps\mp\_scoreevents::processScoreEvent( "destroyed_claymore", attacker, self.owner, weaponName, true );
			}
		}
	}
	
	maps\mp\gametypes\_weaponobjects::weaponDetonate( attacker, weaponName );
}

weaponDetonate(attacker, weaponName )
{
	from_emp = maps\mp\killstreaks\_emp::isEmpWeapon( weaponName );

	if ( from_emp )
	{
		self delete();
		return;
	}
	
	if ( IsDefined( attacker ) )
	{
		self Detonate( attacker );
	}
	else if ( isdefined( self.owner ) && isplayer( self.owner ) )
	{	
		self Detonate( self.owner );
	}
	else
	{
		self Detonate();
	}
}

waitAndDetonate( object, delay, attacker, weaponName )
{
	object endon("death");
	object endon("hacked");

	from_emp = maps\mp\killstreaks\_emp::isEmpWeapon( weaponName );

	if ( from_emp )
	{
		object SetClientFlag( CLIENT_FLAG_EMP );
		object SetClientFlag( CLIENT_FLAG_STUNNED );
		object.stun_fx = true;

		if (isDefined(object.name ) && object.name == "qrdrone_turret_mp")
		{			
			PlayFX( level._equipment_emp_destroy_fx, object.origin + ( 0, 0, 0 ) , ( 0, RandomFloat( 360 ), 0 ) );
		}
		else
		{
			PlayFX( level._equipment_emp_destroy_fx, object.origin + ( 0, 0, 5 ) , ( 0, RandomFloat( 360 ), 0 ) );
		}
		delay = 1.1;
	}
	
	if ( delay )
		wait ( delay );

	// no double detonations
	if ( isDefined( object.detonated ) && object.detonated == true )
		return;

	if( !isDefined(self.detonate) )
		return;
			
	// "destroyed_explosive" notify, for challenges
	if ( isdefined( attacker ) && IsPlayer( attacker ) && isdefined( attacker.pers["team"] ) && isdefined( object.owner ) && isdefined( object.owner.pers["team"] ) )
	{
		if ( level.teambased )
		{
			if ( attacker.pers["team"] != object.owner.pers["team"] )
			{
				attacker notify("destroyed_explosive");
				//attacker maps\mp\_properks::destroyedEquipment();
			}
		}
		else
		{
			if ( attacker != object.owner )
			{
				attacker notify("destroyed_explosive");
				//attacker maps\mp\_properks::destroyedEquipment();
			}
		}
	}
	
	object.detonated = true;
	object [[self.detonate]](attacker, weaponName);
}

detonateWeaponObjectArray( forceDetonation, weapon ) 
{
	undetonated = [];
	if ( IsDefined(self.objectArray) ) 
	{
		for ( i = 0; i < self.objectArray.size; i++ )
		{
			if ( isdefined(self.objectArray[i]) )
			{
				// weapon is stunned, but can be detonated later
				if ( self.objectArray[i] isstunned() && forceDetonation == false )
				{
					undetonated[undetonated.size] = self.objectArray[i];
					continue;
				}
				if ( IsDefined( weapon ) )
				{
					// hacked weapon, don't destroy other weapons not of the same
					if ( weapon isHacked() && weapon.name != self.objectArray[i].name )
					{
						undetonated[undetonated.size] = self.objectArray[i];
						continue;
					}
					// planted weapon, don't destroy hacked weapons not of the same
					else if ( self.objectArray[i] isHacked() && weapon.name != self.objectArray[i].name )
					{
						undetonated[undetonated.size] = self.objectArray[i];
						continue;
					}
				}

				 self thread waitAndDetonate( self.objectArray[i], 0.1, undefined, weapon );
			}
		}
	}
	
	self.objectArray = undetonated;
}

addWeaponObjectToWatcher( watcherName, weapon )
{
	watcher = getWeaponObjectWatcher( watcherName );
	assert( IsDefined(watcher), "Weapon object watcher " + watcherName + " does not exist" );

	self addWeaponObject( watcher, weapon );
}

addWeaponObject(watcher, weapon)
{
	if( !isDefined( watcher.storeDifferentObject ) )
		watcher.objectArray[watcher.objectArray.size] = weapon;

	weapon.owner = self;
	weapon.detonated = false;
	weapon.name = watcher.weapon;
	
	if( IsDefined( watcher.onDamage ) )
	{
		weapon thread [[watcher.onDamage]]( watcher );
	}
	else
	{
		weapon thread weaponObjectDamage(watcher);
	}
	
	weapon.ownerGetsAssist = watcher.ownerGetsAssist;
	
	if ( IsDefined(watcher.onSpawn) )
		weapon thread [[watcher.onSpawn]](watcher, self);

	if ( IsDefined(watcher.onSpawnFX) )
		weapon thread [[watcher.onSpawnFX]]();
		
	if ( IsDefined( watcher.reconModel ) )
		weapon thread attachReconModel( watcher.reconModel, self );

	if( isDefined(watcher.onSpawnRetrieveTriggers) )
		weapon thread [[watcher.onSpawnRetrieveTriggers]](watcher, self);

	if ( watcher.hackable )
		weapon thread hackerInit( watcher );

	if ( IsDefined( watcher.stun ) )
	{
		weapon thread watchScramble( watcher );
	}

	if( watcher.playDestroyedDialog )
	{
		weapon thread playDialogOnDeath( self );
		weapon thread watchObjectDamage( self );
	}

	if( watcher.deleteOnKillbrush )
		weapon thread deleteOnKillbrush( self );
}

watchScramble( watcher )
{
	self endon( "death" );
	self endon( "hacked" );

	self waitTillNotMoving();

	if ( self maps\mp\_scrambler::checkScramblerStun() )
	{
		self thread stunStart( watcher );
	}
	else
	{
		self stunStop();
	}

	for ( ;; )
	{
		level waittill_any( "scrambler_spawn", "scrambler_death", "hacked" );

		if ( IsDefined( self.owner ) && self.owner IsEMPJammed() )
		{
			continue;
		}

		if ( self maps\mp\_scrambler::checkScramblerStun() )
		{
			self thread stunStart( watcher );
		}
		else
		{
			self stunStop();
		}
	}
}

// call on player
deleteWeaponObjectHelper( weapon_ent )
{
	if ( !IsDefined( weapon_ent.name ) )
	{
		return;
	}

	watcher = self getWeaponObjectWatcherByWeapon( weapon_ent.name );
	if ( !IsDefined( watcher ) )
	{
		return;
	}

	watcher.objectArray = deleteWeaponObject( watcher, weapon_ent );
}

deleteWeaponObject(watcher, weapon_ent)
{
	// remove the weapon object from the array
	temp_objectArray = watcher.objectArray;
	
	// clear out the object array
	watcher.objectArray = [];

	j = 0;
	for( i = 0; i < temp_objectArray.size; i++ )
	{
		if( !IsDefined( temp_objectArray[i] ) || temp_objectArray[i] == weapon_ent )
		{
			continue;
		}
		watcher.objectArray[j] = temp_objectArray[i];
		j++;
	}

	return watcher.objectArray;
}

weaponObjectDamage(watcher) // self == weapon object
{
	self endon( "death" );
	self endon( "hacked" );

	self setcandamage(true);
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	attacker = undefined;
	
	while(1)
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, weaponName, iDFlags );
		
		if( !IsPlayer(attacker) )
		{
			continue;
		}
		
		// most equipment should be flash/concussion-able, so it'll disable for a short period of time
		// check to see if the equipment has been flashed/concussed and disable it (checking damage < 5 is a bad idea, so check the weapon name)
		// we're currently allowing the owner/teammate to flash their own
		if ( IsDefined( weaponName ) )
		{
			// do damage feedback
			switch( weaponName )
			{
			case "concussion_grenade_mp":
			case "flash_grenade_mp":
			case "proximity_grenade_mp":
				if( watcher.stunTime > 0 )
				{
					self thread stunStart( watcher, watcher.stunTime ); 
				}
				
				// if we're not on the same team then show damage feedback
				if( level.teambased && self.owner.team != attacker.team )
				{
					if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
						attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback();
				}
				// for ffa just make sure the owner isn't the same
				else if( !level.teambased && self.owner != attacker )
				{
					if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
						attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback();
				}
				continue;

			case "willy_pete_mp":
				continue;

			case "emp_grenade_mp":
				// if we're not on the same team then show damage feedback
				if( level.teambased && self.owner.team != attacker.team )
				{
					if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
						attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback();
				}
				// for ffa just make sure the owner isn't the same
				else if( !level.teambased && self.owner != attacker )
				{
					if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
						attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback();
				}
				break;

			default:
				break;
			}
		}
		
		if ( level.teambased )
 		{
			// if we're not hardcore and the team is the same, do not destroy
			if( !level.hardcoreMode && self.owner.team == attacker.pers["team"] && self.owner != attacker )
			{
				continue;
			}
		}

		if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
			attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback();

		// TODO: figure out if this is needed anymore
		// don't allow people to destroy satchel on their team if FF is off
		// don't bother with the FF check on vehicles as it will already have been done in 
		// the vehicle damage callback
		if ( !isvehicle( self ) && !friendlyFireCheck( self.owner, attacker ) )
			continue;

		break;
	}
	
	if ( level.weaponobjectexplodethisframe )
		wait .1 + randomfloat(.4);
	else
		wait .05;
	
	if (!isdefined(self))
		return;
	
	level.weaponobjectexplodethisframe = true;
	
	thread resetWeaponObjectExplodeThisFrame();
	
	self maps\mp\_entityheadicons::setEntityHeadIcon("none");
	
	if ( isDefined( type ) && (isSubStr( type, "MOD_GRENADE_SPLASH" ) || isSubStr( type, "MOD_GRENADE" ) || isSubStr( type, "MOD_EXPLOSIVE" )) )
		self.wasChained = true;
	
	if ( isDefined( iDFlags ) && (iDFlags & level.iDFLAGS_PENETRATION) )
	{
		self.wasDamagedFromBulletPenetration = true;
		//attacker maps\mp\_properks::shotEquipment( self.owner, iDFlags );
	}
	
	self.wasDamaged = true;
	
	watcher thread waitAndDetonate( self, 0.0, attacker, weaponName );

	// won't get here; got death notify.
}

//Notify player that their equipment was destroyed
playDialogOnDeath( owner )
{
	owner endon("death");
	owner endon("disconnect");
	self endon( "hacked" );

	self waittill( "death" );

	if( isDefined(self.playDialog) && self.playDialog )
		owner maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "equipment_destroyed", "item_destroyed" );
}

watchObjectDamage( owner )
{
	owner endon("death");
	owner endon("disconnect");
	self endon( "hacked" );
	self endon( "death" );

	while(1)
	{
		self waittill( "damage", damage, attacker );

		if( isDefined(attacker) && isPlayer(attacker) && attacker != owner )
		{
			self.playDialog = true;
		}
		else
		{
			self.playDialog = false;
		}
	}
}

stunStart( watcher, time )
{
	self endon ( "death" );

	if ( self isStunned() )
	{
		return;
	}

	if ( IsDefined( self.cameraHead ) )
		self.cameraHead SetClientFlag( CLIENT_FLAG_STUNNED );
	self SetClientFlag( CLIENT_FLAG_STUNNED );
	
	// allow specific effects
	if ( IsDefined( watcher.stun ) )
		self thread [[watcher.stun]]();
	
	if ( watcher.name == "rcbomb" )
	{
		self.owner freezeControlsWrapper( true );
	}
	
	if ( IsDefined( time ) )
	{
		wait ( time );
	}
	else
	{
		return;
	}

	if ( watcher.name == "rcbomb" )
	{
		self.owner freezeControlsWrapper( false );
	}
	
	self stunStop();
}

stunStop()
{
	self notify ( "not_stunned" );
	if ( IsDefined( self.cameraHead ) )
		self.cameraHead ClearClientFlag( CLIENT_FLAG_STUNNED );
	self ClearClientFlag( CLIENT_FLAG_STUNNED );
}

weaponStun() // self == weapon object
{
	self endon( "death" );
	self endon( "not_stunned" );
	
	origin = self GetTagOrigin( "tag_fx" );

	if ( !IsDefined( origin ) )
	{
		origin = self.origin + ( 0, 0, 10 );
	}

	self.stun_fx = Spawn( "script_model", origin );
	self.stun_fx SetModel( "tag_origin" );
	self thread stunFxThink( self.stun_fx );
	wait ( 0.1 );

	PlayFXOnTag( level._equipment_spark_fx, self.stun_fx, "tag_origin" );
	self.stun_fx PlaySound ( "dst_disable_spark" );
}

stunFxThink( fx )
{
	fx endon("death");
	self waittill_any( "death", "not_stunned" );
	fx delete();
}

isStunned()
{
	return ( IsDefined( self.stun_fx ) );
}

resetWeaponObjectExplodeThisFrame()
{
	wait .05;
	level.weaponobjectexplodethisframe = false;
}

getWeaponObjectWatcher( name )
{
	if ( !IsDefined(self.weaponObjectWatcherArray) )
	{
		return undefined;
	}
	
	for ( watcher = 0; watcher < self.weaponObjectWatcherArray.size; watcher++ )
	{
		if ( self.weaponObjectWatcherArray[watcher].name == name )
		{
			return self.weaponObjectWatcherArray[watcher];
		}
	}
	
	return undefined;
}

getWeaponObjectWatcherByWeapon( weapon ) // self == player
{
	if ( !IsDefined(self.weaponObjectWatcherArray) )
	{
		return undefined;
	}
	
	for ( watcher = 0; watcher < self.weaponObjectWatcherArray.size; watcher++ )
	{
		if ( IsDefined(self.weaponObjectWatcherArray[watcher].weapon) && self.weaponObjectWatcherArray[watcher].weapon == weapon )
		{
			return self.weaponObjectWatcherArray[watcher];
		}
		if ( IsDefined(self.weaponObjectWatcherArray[watcher].weapon) && IsDefined(self.weaponObjectWatcherArray[watcher].altWeapon) && self.weaponObjectWatcherArray[watcher].altWeapon == weapon )
		{
			return self.weaponObjectWatcherArray[watcher];
		}
	}
	
	return undefined;
}

resetWeaponObjectWatcher( watcher, ownerTeam )
{
	if ( level.deleteExplosivesOnSpawn == 1 )
	{
		self notify( "weapon_object_destroyed" );
		watcher deleteWeaponObjectArray();
	}
	
	// player may have switched teams
	watcher.ownerTeam = ownerTeam;
}

createWeaponObjectWatcher( name, weapon, ownerTeam )
{
	if ( !IsDefined(self.weaponObjectWatcherArray) )
	{
		self.weaponObjectWatcherArray = [];
	}
	
	weaponObjectWatcher = getWeaponObjectWatcher( name );

	if ( !IsDefined( weaponObjectWatcher ) )
	{ 
		weaponObjectWatcher = SpawnStruct();
		self.weaponObjectWatcherArray[self.weaponObjectWatcherArray.size] = weaponObjectWatcher;
	
		weaponObjectWatcher.name = name;
		weaponObjectWatcher.type = "use";
		weaponObjectWatcher.weapon = weapon;
		weaponObjectWatcher.weaponIdx = GetWeaponIndexFromName( weapon );
		weaponObjectWatcher.watchForFire = false;
		weaponObjectWatcher.hackable = false;
		weaponObjectWatcher.altDetonate = false;
		weaponObjectWatcher.detectable = true;
		weaponObjectWatcher.headIcon = true;
		weaponObjectWatcher.stunTime = 0;
		weaponObjectWatcher.activateSound = undefined;
		weaponObjectWatcher.ignoreDirection = undefined;
		weaponObjectWatcher.immediateDetonation = undefined; 
		weaponObjectWatcher.deploySound = getWeaponFireSound( weaponObjectWatcher.weaponIdx );
		weaponObjectWatcher.deploySoundPlayer = getWeaponFireSoundPlayer( weaponObjectWatcher.weaponIdx );
		weaponObjectWatcher.pickUpSound = getWeaponPickupSound( weaponObjectWatcher.weaponIdx );
		weaponObjectWatcher.pickUpSoundPlayer = getWeaponPickupSoundPlayer( weaponObjectWatcher.weaponIdx );
		weaponObjectWatcher.altWeapon = undefined;
		weaponObjectWatcher.ownerGetsAssist = false;
		weaponObjectWatcher.playDestroyedDialog = true;
		weaponObjectWatcher.deleteOnKillbrush = true;
		weaponObjectWatcher.deleteOnDifferentObjectSpawn = true;
		weaponObjectWatcher.enemyDestroy = false;
	
		// calbacks
		weaponObjectWatcher.onSpawn = undefined;
		weaponObjectWatcher.onSpawnFX = undefined;
		weaponObjectWatcher.onSpawnRetrieveTriggers = undefined;
		weaponObjectWatcher.onDetonated = undefined;
		weaponObjectWatcher.detonate = undefined;
		weaponObjectWatcher.stun = undefined;
		weaponObjectWatcher.onDestroyed = undefined;
		
		if ( !IsDefined( weaponObjectWatcher.objectArray ) )
			weaponObjectWatcher.objectArray = [];
	}

	resetWeaponObjectWatcher( weaponObjectWatcher, ownerTeam );
	
	return weaponObjectWatcher;
}

createUseWeaponObjectWatcher( name, weapon, ownerTeam )
{
	weaponObjectWatcher = createWeaponObjectWatcher( name, weapon, ownerTeam );

	weaponObjectWatcher.type = "use";
	weaponObjectWatcher.onSpawn = ::onSpawnUseWeaponObject;

	return weaponObjectWatcher;
}

createProximityWeaponObjectWatcher( name, weapon, ownerTeam )
{
	weaponObjectWatcher = createWeaponObjectWatcher( name, weapon, ownerTeam );

	weaponObjectWatcher.type = "proximity";
	weaponObjectWatcher.onSpawn = ::onSpawnProximityWeaponObject;

	detectionConeAngle = weapons_get_dvar_int( "scr_weaponobject_coneangle" );
	weaponObjectWatcher.detectionDot = cos( detectionConeAngle );
	weaponObjectWatcher.detectionMinDist = weapons_get_dvar_int( "scr_weaponobject_mindist" );
	weaponObjectWatcher.detectionGracePeriod = weapons_get_dvar( "scr_weaponobject_graceperiod" );
	weaponObjectWatcher.detonateRadius = weapons_get_dvar_int( "scr_weaponobject_radius" );
	
	return weaponObjectWatcher;
}

commonOnSpawnUseWeaponObject( watcher, owner ) // self == weapon (for example: the claymore)
{
	if ( watcher.detectable )
	{
		if ( isdefined(watcher.isMovable) && watcher.isMovable )
			self thread weaponObjectDetectionMovable( owner.pers["team"] );
		else
			self thread weaponObjectDetectionTrigger_wait( owner.pers["team"] );
		
		if ( watcher.headIcon && level.teamBased )
		{
			self waitTillNotMoving();
			offset = level.weaponobjects_headicon_offset[ "default" ];
			if( IsDefined( level.weaponobjects_headicon_offset[ self.name ] ) )
			{
				offset = level.weaponobjects_headicon_offset[ self.name ];
			}
			self maps\mp\_entityheadicons::setEntityHeadIcon( owner.pers["team"], owner, offset );
		}
	}
}

onSpawnUseWeaponObject( watcher, owner ) // self == weapon (for example: the claymore)
{
	self commonOnSpawnUseWeaponObject(watcher, owner);
}

onSpawnProximityWeaponObject( watcher, owner ) // self == weapon (for example: the claymore)
{
	self thread commonOnSpawnUseWeaponObject(watcher, owner);
	self thread proximityWeaponObjectDetonation( watcher );

	/#
	if ( GetDvarint( "scr_weaponobject_debug") )
	{
		self thread proximityWeaponObjectDebug( watcher );
	}
	#/
}

watchWeaponObjectUsage() // self == player
{
	self endon( "disconnect" );
	
	if ( !IsDefined(self.weaponObjectWatcherArray) )
	{
		self.weaponObjectWatcherArray = [];
	}

	self thread watchWeaponObjectSpawn();
	self thread watchWeaponProjectileObjectSpawn();
	self thread watchWeaponObjectDetonation();
	self thread watchWeaponObjectAltDetonation();
	self thread watchWeaponObjectAltDetonate();
	self thread deleteWeaponObjectsOn();
}

// check for grenade type weapon objects spawning
watchWeaponObjectSpawn() // self == player
{
	self notify( "watchWeaponObjectSpawn" );
	self endon( "watchWeaponObjectSpawn" );
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "grenade_fire", weapon, weapname );
		
		//This switch and 'for' loop destroys any equipment the player has out in the world
		//This hard rule of one piece of equipment per player is to avoid having too many active at once -Leif
		switch( weapname )
		{
		case "claymore_mp":
		case "bouncingbetty_mp":
		case "camera_spike_mp":
		case "tactical_insertion_mp":
		case "acoustic_sensor_mp":
		case "scrambler_mp":

			break;
		case "proximity_grenade_mp":
		case "satchel_charge_mp":
		case "trophy_system_mp":
		case "bouncingbetty_mp":
		case "sensor_grenade_mp":
			for( i = 0; i < self.weaponObjectWatcherArray.size; i++)
			{
				if( self.weaponObjectWatcherArray[i].weapon != weapname )
					continue;

				// remove any empty objects
				objectArray_size = self.weaponObjectWatcherArray[i].objectarray.size;
				for( j = 0; j < objectArray_size; j++ )
				{
					if( !IsDefined( self.weaponObjectWatcherArray[i].objectarray[j] ) )
					{
						self.weaponObjectWatcherArray[i].objectarray = deleteWeaponObject( self.weaponObjectWatcherArray[i], weapon );
					}
				}

				numAllowed = 2;

				if( weapname == "proximity_grenade_mp" )
				{
					numAllowed = weapons_get_dvar_int( "scr_proximityGrenadeMaxInstances" );
				}

				// This allows you to place two C4's in the world. A third C4, though, will detonate the first thrown out.
				if( IsDefined( self.weaponObjectWatcherArray[i].Detonate ) && self.weaponObjectWatcherArray[i].objectarray.size > (numAllowed-1) )
				{
					self.weaponObjectWatcherArray[i] thread waitAndDetonate( self.weaponObjectWatcherArray[i].objectarray[0], 0.1, undefined, weapname );
				}
			}
			break;

		default:
			break;
		}

		// need to increment the used stat for claymore and c4
		if ( !self isHacked() )
		{
			if( weapname == "claymore_mp" || weapname == "satchel_charge_mp" || weapname == "bouncingbetty_mp" )
				self AddWeaponStat( weapname, "used", 1 );
		}

		watcher = getWeaponObjectWatcherByWeapon( weapname );
		if ( IsDefined(watcher) )
		{
			self addWeaponObject(watcher, weapon);
		}

	}
}

// check for projectile type weapon objects spawning
watchWeaponProjectileObjectSpawn() // self == player
{
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "missile_fire", weapon, weapname );

		watcher = getWeaponObjectWatcherByWeapon( weapname );
		if ( IsDefined(watcher) )
		{
			self addWeaponObject(watcher, weapon);
			// remove any empty objects
			objectArray_size = watcher.objectarray.size;
			for( j = 0; j < objectArray_size; j++ )
			{
				if( !IsDefined( watcher.objectarray[j] ) )
				{
					watcher.objectarray = deleteWeaponObject( watcher, weapon );
				}
			}

			// This allows you to place two ballistic knives in the world. A third ballistic knives, though, will detonate the first thrown out.
			if( IsDefined( watcher.Detonate ) && watcher.objectarray.size > 1 )
			{
				watcher thread waitAndDetonate( watcher.objectarray[0], 0.1 );
			}
		}
	}
}

/#
proximityWeaponObjectDebug( watcher )
{
	self waitTillNotMoving();
	self thread showCone( acos( watcher.detectionDot ), watcher.detonateRadius, (1,.85,0) );
	self thread showCone( 60, 256, (1,0,0) );
}

vectorcross( v1, v2 )
{
	return ( v1[1]*v2[2] - v1[2]*v2[1], v1[2]*v2[0] - v1[0]*v2[2], v1[0]*v2[1] - v1[1]*v2[0] );
}

showCone( angle, range, color )
{
	self endon("death");
	
	start = self.origin;
	forward = anglestoforward(self.angles);
	right = vectorcross( forward, (0,0,1) );
	up = vectorcross( forward, right );
	
	fullforward = forward * range * cos( angle );
	sideamnt = range * sin( angle );
	
	while(1)
	{
		prevpoint = (0,0,0);
		for ( i = 0; i <= 20; i++ )
		{
			coneangle = i/20.0 * 360;
			point = start + fullforward + sideamnt * (right * cos(coneangle) + up * sin(coneangle));
			if ( i > 0 )
			{
				line( start, point, color );
				line( prevpoint, point, color );
			}
			prevpoint = point;
		}
		wait .05;
	}
}
#/

weaponObjectDetectionMovable( ownerTeam ) // self == weapon (for example: the claymore)
{
	self endon ( "end_detection" );
	level endon ( "game_ended" );
	self endon ( "death" );
	self endon ( "hacked" );

	if ( level.oldschool )
		return;

	if ( !level.teambased )
		return;

	self.detectId = "rcBomb" + getTime() + randomInt( 1000000 );
	while( !level.gameEnded )
	{
		wait (1);

		players = GET_PLAYERS();

		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if ( isai( player ) )
				continue;
			
			// specialty_detectexplosive should see c4, claymore
			if( IsDefined( self.model_name ) && player HasPerk( "specialty_detectexplosive" )  )
			{
				switch( self.model_name )
				{
				case "t6_wpn_claymore_world_detect":
				case "t6_wpn_c4_world_detect":
					break;

				default:
					continue;
				}
			}
			else
			{
				continue;
			}
				
			if ( player.team == ownerTeam ) 
				continue;
				
			if ( isDefined( player.bombSquadIds[self.detectId] ) )
				continue;
		}
	}
}


setIconPos( item, icon, heightIncrease )
{
	icon.x = item.origin[0];
	icon.y = item.origin[1];
	icon.z = item.origin[2]+heightIncrease;
}

weaponObjectDetectionTrigger_wait( ownerTeam ) // self == weapon (for example: the claymore)
{
	self endon ( "death" );
	self endon ( "hacked" );
	waitTillNotMoving();

	if ( level.oldschool )
		return;

	self thread weaponObjectDetectionTrigger( ownerTeam );
}

weaponObjectDetectionTrigger( ownerTeam ) // self == weapon (for example: the claymore)
{
	trigger = spawn( "trigger_radius", self.origin-(0,0,128), 0, 512, 256 );
	trigger.detectId = "trigger" + getTime() + randomInt( 1000000 );
	
	trigger SetHintLowPriority( true );

	self waittill_any( "death", "hacked" );
	trigger notify ( "end_detection" );

	if ( isDefined( trigger.bombSquadIcon ) )
		trigger.bombSquadIcon destroy();
	
	trigger delete();	
}

hackerTriggerSetVisibility( owner )
{
	self endon( "death" );
	
	assert( IsPlayer( owner ) );

	ownerTeam = owner.pers["team"];

	for ( ;; )
	{
		if ( level.teamBased )
		{
			self SetVisibleToAllExceptTeam( ownerTeam );
			self SetExcludeTeamForTrigger( ownerTeam );
		}
		else
		{
			self SetVisibleToAll();
			self SetTeamForTrigger( "none" );
		}

		self SetInvisibleToPlayer( owner );
	
		level waittill_any( "player_spawned", "joined_team" );
	}
}

hackerNotMoving()
{
	self endon( "death" );
	self waitTillNotMoving();
	self notify( "landed" );
}

hackerInit( watcher )
{
	self thread hackerNotMoving();

	event = self waittill_any_return( "death", "landed" );

	if ( event == "death" )
	{
		return;
	}

	triggerOrigin = self.origin;

	if ( IsDefined( self.name ) && self.name == "satchel_charge_mp" )
	{
		triggerOrigin = self GetTagOrigin( "tag_fx" );
	}

	// set up a trigger for a hacker
	self.hackerTrigger = Spawn( "trigger_radius_use", triggerOrigin, level.weaponobjects_hacker_trigger_width, level.weaponobjects_hacker_trigger_height );

	/#
		//drawcylinder( self.hackerTrigger.origin, level.weaponobjects_hacker_trigger_width, level.weaponobjects_hacker_trigger_height, 0, "hacker_debug" );	
	#/

	self.hackerTrigger SetHintLowPriority( true );
	self.hackerTrigger SetCursorHint( "HINT_NOICON", watcher.weapon );
	self.hackerTrigger SetIgnoreEntForTrigger( self );

	self.hackerTrigger EnableLinkTo();
	self.hackerTrigger LinkTo( self );

	if( IsDefined( level.hackerHints[self.name] ) )
	{
		self.hackerTrigger SetHintString( level.hackerHints[self.name].hint );
	}
	else
	{
		self.hackerTrigger SetHintString( &"MP_GENERIC_HACKING" );
	}

	
	self.hackerTrigger SetPerkForTrigger( "specialty_disarmexplosive" );
	self.hackerTrigger thread hackerTriggerSetVisibility( self.owner );
	
	self thread hackerThink( self.hackerTrigger, watcher );
}

hackerThink( trigger, watcher ) // self == weapon
{
	self endon( "death" );

	for ( ;; )
	{
		trigger waittill( "trigger", player, instant );

		if ( !isDefined( instant ) && !trigger hackerResult( player, self.owner ) )
		{
			continue;
		}

		self.owner hackerRemoveWeapon( self );

		self.hacked = true;
		self SetMissileOwner( player );
		self SetTeam( player.pers["team"] );
		self.owner = player;

		
		if (  IsWeaponEquipment( self.name ) ) 
		{
			maps\mp\_scoreevents::processScoreEvent( "hacked", player, undefined, undefined, true );
		}

		// detonation info for the C4
		if ( self.name == "satchel_charge_mp" && IsDefined( player.lowerMessage ) )
		{
			player.lowerMessage SetText( &"PLATFORM_SATCHEL_CHARGE_DOUBLE_TAP" );
			player.lowerMessage.alpha = 1;
			player.lowerMessage FadeOverTime( 2.0 );
			player.lowerMessage.alpha = 0;
		}

		// kill the previous owner's threads
		self notify( "hacked", player );
		level notify( "hacked", self, player );

		if ( self.name == "camera_spike_mp" && IsDefined( self.cameraHead ) )
		{
			self.cameraHead notify( "hacked", player );
		}

		/#
			//level notify ( "hacker_debug" );
		#/

		if( IsDefined( watcher.stun ) )
		{
			self thread stunStart( watcher, 2.5 );
			wait( 2.5 );
		}
		else
		{
			wait ( 0.05 ); // let current threads clean up from the 'hacked' notify
		}

		if ( IsDefined( player ) && player.sessionstate == "playing" )
		{
			// this will re-initialize the watcher system for this equipment
			player notify( "grenade_fire", self, self.name );
		}
		else
		{
			watcher thread waitAndDetonate( self, 0.0 );
		}

		// the hacker thread will be respawned with the new owner, this thread can be killed
		return;
	}
}

isHacked()
{
	return ( IsDefined( self.hacked ) && self.hacked );
}

hackerUnfreezePlayer( player )
{
	self endon( "hack_done" );
	self waittill( "death" );

	if ( IsDefined( player ) )
	{
		player freeze_player_controls( false );
		player EnableWeapons();
	}
}

hackerResult( player, owner ) // self == trigger_radius
{
	success = true;
	time = GetTime();
	hackTime = GetDvarfloat( "perk_disarmExplosiveTime" );

	if ( !canHack( player, owner, true ) )
	{
		return false;
	}

	self thread hackerUnfreezePlayer( player );

	while ( time + ( hackTime * 1000 ) > GetTime() )
	{
		if ( !canHack( player, owner, false ) )
		{
			success = false;
			break;
		}

		if ( !player UseButtonPressed() )
		{
			success = false;
			break;
		}

		if ( !IsDefined( self ) )
		{
			success = false;
			break;
		}

	/*
		if ( !player IsTouching( self ) )
		{
			success = false;
			break;
		}
	*/

		player freeze_player_controls( true );
		player DisableWeapons();

		if ( !IsDefined( self.progressBar ) )
		{
			self.progressBar = player createPrimaryProgressBar();
			self.progressBar.lastUseRate = -1;
			self.progressBar showElem();
			self.progressBar updateBar( 0.01, 1 / hackTime );

			self.progressText = player createPrimaryProgressBarText();
			self.progressText setText( &"MP_HACKING" );
			self.progressText showElem();
			player PlayLocalSound ( "evt_hacker_hacking" );
		}
		
		wait( 0.05 );
	}

	if ( IsDefined( player ) )
	{
		player freeze_player_controls( false );
		player EnableWeapons();
	}

	if ( IsDefined( self.progressBar ) )
	{
		self.progressBar destroyElem();
		self.progressText destroyElem();
	}

	if ( IsDefined( self ) )
	{
		self notify( "hack_done" );
	}

	return success;
}

canHack( player, owner, weapon_check )
{
	if ( !IsDefined( player ) )
		return false;
	
	if ( !IsPlayer( player ) )
		return false;

	if ( !IsAlive( player ) )
		return false;

	if ( !IsDefined( owner ) )
		return false;

	if ( owner == player )
		return false;
		
	if ( level.teambased && player.team == owner.team )
		return false;

	if ( ( IsDefined( player.isDefusing ) && player.isDefusing ) )
		return false;

	if ( ( IsDefined( player.isPlanting ) && player.isPlanting ) )
		return false;

	if ( IsDefined( player.proxBar ) && !player.proxBar.hidden )
		return false;

	if ( IsDefined( player.revivingTeammate ) && player.revivingTeammate == true )
		return false;

	if ( !player IsOnGround() )
		return false;
		
	if ( player IsInVehicle() )
		return false;

	if ( player IsWeaponViewOnlyLinked() )
		return false;

	if ( !player HasPerk( "specialty_disarmexplosive" ) )
		return false;

	if ( player IsEMPJammed() )
		return false;

	if ( IsDefined( player.laststand ) && player.laststand )
		return false;

	if ( weapon_check )
	{
		if ( player IsThrowingGrenade() )
			return false;

		if ( player IsSwitchingWeapons() )
			return false;

		if ( player IsMeleeing() )
			return false;

		weapon = player GetCurrentWeapon(); 

		if ( !IsDefined( weapon ) )
			return false;

		if ( weapon == "none" )
			return false;

		if ( IsWeaponEquipment( weapon ) && player IsFiring() )
			return false;

		if ( IsWeaponSpecificUse( weapon ) )
			return false;
	}

	return true;
}

hackerRemoveWeapon( weapon )
{
	for( i = 0; i < self.weaponObjectWatcherArray.size; i++)
	{
		if( self.weaponObjectWatcherArray[i].weapon != weapon.name )
		{
			continue;
		}

		// remove any empty objects and the hacked object
		objectArray_size = self.weaponObjectWatcherArray[i].objectarray.size;
		for( j = 0; j < objectArray_size; j++ )
		{
			self.weaponObjectWatcherArray[i].objectarray = deleteWeaponObject( self.weaponObjectWatcherArray[i], weapon );
		}

		return;
	}
}

proximityWeaponObjectDetonation( watcher )
{
	self endon("death");
	self endon("hacked");
	
	self waitTillNotMoving();

	if ( isDefined( watcher.activationDelay ))
	{
		wait watcher.activationDelay;
	}
	
	damagearea = spawn("trigger_radius", self.origin + (0,0,0-watcher.detonateRadius), level.aiTriggerSpawnFlags | level.vehicleTriggerSpawnFlags, watcher.detonateRadius, watcher.detonateRadius*2);
	damagearea EnableLinkTo();
	damagearea LinkTo( self );

	self thread deleteOnDeath( damagearea );
	
	up = AnglesToUp( self.angles );
	traceOrigin = self.origin + up;
	
	while(1)
	{
		damagearea waittill("trigger", ent);
		
		if ( GetDvarint( "scr_weaponobject_debug") != 1 )
		{
			if ( isdefined( self.owner ) && ent == self.owner )
				continue;
			if ( IsDefined( self.owner ) && IsVehicle( ent ) && IsDefined( ent.owner ) && ( self.owner == ent.owner ) ) // owner's own vehicle
				continue;
			if ( !friendlyFireCheck( self.owner, ent, 0 ) )
				continue;
		}
		if ( ( lengthsquared( ent getVelocity() ) < 10 ) && !isDefined( watcher.immediateDetonation ) )
			continue;
		
		if ( !ent shouldAffectWeaponObject( self, watcher ) )
			continue;

		if ( self isstunned() ) 
			continue;

		//Make sure player watching their killcam won't set it off
		if( IsPlayer( ent ) && !IsAlive(ent) )
			continue;

		if ( ent damageConeTrace( traceOrigin, self ) > 0 )
			break;		
	}
	
	if ( IsDefined(watcher.activateSound) )
	{
		self playsound (watcher.activateSound);
	}
	
	if ( isDefined( watcher.activateFx ) )
	{
		self SetClientFlag( CLIENT_FLAG_PROXIMITY );
	}

	// check if ent has survived the betty for the challenges
	ent thread deathDodger(watcher.detectionGracePeriod);
	
	wait watcher.detectionGracePeriod;

	if ( IsPlayer( ent ) && ent HasPerk( "specialty_delayexplosive" ) )
	{
		wait( GetDvarfloat( "perk_delayExplosiveTime" ) );
	}
	
	self maps\mp\_entityheadicons::setEntityHeadIcon("none");
	
	// move up one unit
	self.origin = traceOrigin;
	
	if ( isdefined( self.owner ) && isplayer( self.owner ) )
	{	
		self [[watcher.detonate]](self.owner);
	}
	else
	{
		self [[watcher.detonate]]();
	}
}

shouldAffectWeaponObject( object, watcher )
{
	pos = self.origin + (0,0,32);
	
	if( IsDefined( watcher.ignoreDirection ) )
	{
		return true;
	}

	dirToPos = pos - object.origin;
	objectForward = anglesToForward( object.angles );
	
	dist = vectorDot( dirToPos, objectForward );
	if ( dist < watcher.detectionMinDist )
		return false;
	
	dirToPos = vectornormalize( dirToPos );
	
	dot = vectorDot( dirToPos, objectForward );
	return ( dot > watcher.detectionDot );
}

deathDodger( graceperiod )
{
	self endon("death");
	self endon("disconnect");
	
	wait(0.2 + graceperiod );
	self notify("death_dodger");
}
	
	

deleteOnDeath(ent)
{
	self waittill_any("death", "hacked");
		wait .05;
	if ( isdefined(ent) )
		ent delete();
}

deleteOnKillbrush(player)
{
	player endon("disconnect");
	self endon("death");
	self endon("stationary");
		
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
					self delete();

				return;
			}
		}
		wait( 0.1 );
	}
	
}


watchWeaponObjectAltDetonation() // self == player
{
	self endon("disconnect");

	while(1)
	{
		self waittill( "alt_detonate" );

		if ( !IsAlive(self) )
			continue;
		
		for ( watcher = 0; watcher < self.weaponObjectWatcherArray.size; watcher++ )
		{
			if ( self.weaponObjectWatcherArray[watcher].altDetonate )
			{
				self.weaponObjectWatcherArray[watcher] detonateWeaponObjectArray( false );
			}
		}
	}
}

watchWeaponObjectAltDetonate() // self == player
{
	//self endon("death");
	self endon( "disconnect" );	
	self endon( "detonated" );
	level endon( "game_ended" );
	
	buttonTime = 0;
	for( ;; )
	{
		self waittill( "doubletap_detonate" );
		
		if (! IsAlive( self )  )
			continue;
		self notify ( "alt_detonate" );
		wait ( 0.05 );
//		if ( self UseButtonPressed() )
//		{
//			buttonTime = 0;
//			while( self UseButtonPressed() )
//			{
//				buttonTime += 0.05;
//				wait( 0.05 );
//			}
//	
////			println( "pressTime1: " + buttonTime );
//			if ( buttonTime >= 0.5 )
//				continue;
//	
//			buttonTime = 0;				
//			while ( !self UseButtonPressed() && buttonTime < 0.5 )
//			{
//				buttonTime += 0.05;
//				wait( 0.05 );
//			}
//		
////			println( "delayTime: " + buttonTime );
//			if ( buttonTime >= 0.5 )
//			continue;
//		
//			self notify ( "alt_detonate" );
//		}
//		wait ( 0.05 );
	}
}

watchWeaponObjectDetonation() // self == player
{
	//self endon("death");
	self endon("disconnect");

	while(1)
	{
		self waittill( "detonate" );

		if ( self isUsingOffhand() )
		{
			weap = self getCurrentOffhand();
		}
		else
		{
			weap = self getCurrentWeapon();
		}

		watcher = getWeaponObjectWatcherByWeapon( weap );
		if ( IsDefined( watcher ) )
		{
			watcher detonateWeaponObjectArray( false );
		}
	}
}

deleteWeaponObjectsOn() // self == player
{
	self endon("spawned_player");
	self waittill_any( "disconnect", "joined_team", "joined_spectators" );	
	
	if ( !IsDefined(self.weaponObjectWatcherArray) )
		return;
		
	watchers = [];
	
	// make a psudo copy of the watchers out of the player 
	// so that when the player ent gets cleaned we still have
	// the object arrays to clean up
	for ( watcher = 0; watcher < self.weaponObjectWatcherArray.size; watcher++ )
	{
		weaponObjectWatcher = SpawnStruct();
		watchers[watchers.size] = weaponObjectWatcher;
		weaponObjectWatcher.objectArray = [];
		
		if ( IsDefined(  self.weaponObjectWatcherArray[watcher].objectArray ) )
		{
			weaponObjectWatcher.objectArray =  self.weaponObjectWatcherArray[watcher].objectArray;
		}
	}
	
	wait .05;
	
	for ( watcher = 0; watcher < watchers.size; watcher++ )
	{
		watchers[watcher] deleteWeaponObjectArray();
	}
}

saydamaged(orig, amount)
{
	/#
	for (i = 0; i < 60; i++)
	{
		print3d(orig, "damaged! " + amount);
		wait .05;
	}
	#/
}

showHeadIcon( trigger )
{
	triggerDetectId = trigger.detectId;
	useId = -1;
	for ( index = 0; index < 4; index++ )
	{
		detectId = self.bombSquadIcons[index].detectId;

		if ( detectId == triggerDetectId )
			return;
			
		if ( detectId == "" )
			useId = index;
	}
	
	if ( useId < 0 )
		return;

	self.bombSquadIds[triggerDetectId] = true;
	
	self.bombSquadIcons[useId].x = trigger.origin[0];
	self.bombSquadIcons[useId].y = trigger.origin[1];
	self.bombSquadIcons[useId].z = trigger.origin[2]+24+128;

	self.bombSquadIcons[useId] fadeOverTime( 0.25 );
	self.bombSquadIcons[useId].alpha = 1;
	self.bombSquadIcons[useId].detectId = trigger.detectId;
	
	while ( isAlive( self ) && isDefined( trigger ) && self isTouching( trigger ) )
		wait ( 0.05 );
		
	if ( !isDefined( self ) )
		return;
		
	self.bombSquadIcons[useId].detectId = "";
	self.bombSquadIcons[useId] fadeOverTime( 0.25 );
	self.bombSquadIcons[useId].alpha = 0;
	self.bombSquadIds[triggerDetectId] = undefined;
}

// returns true if damage should be done to the item given its owner and the attacker
friendlyFireCheck( owner, attacker, forcedFriendlyFireRule )
{
	if ( !isdefined(owner) ) // owner has disconnected? allow it
		return true;
	
	if ( !level.teamBased ) // not a team based mode? allow it
		return true;

	friendlyFireRule = level.friendlyfire;
	if ( isdefined( forcedFriendlyFireRule ) )
		friendlyFireRule = forcedFriendlyFireRule;
	
	if ( friendlyFireRule != 0 ) // friendly fire is on? allow it
		return true;
	
	if ( attacker == owner ) // owner may attack his own items
		return true;
	
	if ( isplayer( attacker ) )
	{
		if ( !isdefined(attacker.pers["team"])) // attacker not on a team? allow it
			return true;
		
		if ( attacker.pers["team"] != owner.pers["team"] ) // attacker not on the same team as the owner? allow it
			return true;
	}
	else if ( isai(attacker) )
	{
		if ( attacker.aiteam != owner.pers["team"] ) // attacker not on the same team as the owner? allow it
			return true; 
	}	
	else if ( isvehicle(attacker) )
	{
		if ( IsDefined(attacker.owner) && IsPlayer(attacker.owner) )
		{
			if ( attacker.owner.pers["team"] != owner.pers["team"] )
				return true;
		}
		else
		{
			occupant_team = attacker maps\mp\_vehicles::vehicle_get_occupant_team();
			if ( occupant_team != owner.pers["team"] ) // attacker not on the same team as the owner? allow it
				return true; 
		}
	}	

	return false; // disallow it
}

onSpawnHatchetTrigger( watcher, player ) // self == weapon (for example: the claymore)
{
	self endon( "death" );

	self SetOwner( player );
	self SetTeam( player.pers["team"] );
	self.owner = player;
	self.oldAngles = self.angles;

	self waitTillNotMoving();
	waittillframeend;

	if( player.pers["team"] == "spectator" )
	{
		return;
	}
	
	triggerOrigin = self.origin;
	triggerParentEnt = undefined;

	if ( IsDefined( self.stuckToPlayer ) )
	{
		if ( IsAlive( self.stuckToPlayer ) || !IsDefined( self.stuckToPlayer.body ) )
		{
			if ( IsAlive( self.stuckToPlayer ) )
			{
				// Drop the hatchet to the ground if it doesn't kill the player.
				triggerParentEnt = self;
				self Unlink();
				self.angles = self.oldAngles;
				self launch( (5,5,5) );
				self waitTillNotMoving();
				waittillframeend;
			}
			else
			{
				triggerParentEnt = self.stuckToPlayer;
			}
		}
		else
		{
			triggerParentEnt = self.stuckToPlayer.body;
		}
	}
	
	if ( IsDefined( triggerParentEnt ) )
		triggerOrigin = triggerParentEnt.origin + ( 0, 0, 10 );

	self.hatchetPickUpTrigger = Spawn( "trigger_radius", triggerOrigin, 0, 50, 50 );

	self.hatchetPickUpTrigger EnableLinkTo();
	self.hatchetPickUpTrigger LinkTo( self );

	if ( IsDefined( triggerParentEnt ) )
	{
		self.hatchetPickUpTrigger linkto( triggerParentEnt );
	}

	self thread watchHatchetTrigger( self.hatchetPickUpTrigger, watcher.pickUp, watcher.pickUpSoundPlayer, watcher.pickUpSound );

	/#
	thread switch_team( self, watcher.weapon, player );
	#/

	self thread watchShutdown( player );
}

watchHatchetTrigger( trigger, callback, playerSoundOnUse, npcSoundOnUse ) // self == weapon (for example: the claymore)
{
	self endon( "delete" );
	self endon( "hacked" );

	while ( true )
	{
		trigger waittill( "trigger", player );
			
		if ( !isAlive( player ) )
			continue;
			
		if ( !player isOnGround() )
			continue;
			
		if ( isDefined( trigger.claimedBy ) && ( player != trigger.claimedBy ) )
			continue;

		if ( !( player HasWeapon( self.name ) ) )
			continue;

		curr_ammo = player GetWeaponAmmoStock( "hatchet_mp" );

		maxAmmo = WeaponMaxAmmo( "hatchet_mp" );

		if ( player.grenadeTypePrimary == "hatchet_mp" )
		{
			maxAmmo = player.grenadeTypePrimaryCount;
		}
		else if ( IsDefined(player.grenadeTypeSecondary) && player.grenadeTypeSecondary == "hatchet_mp" )
		{
			maxAmmo = player.grenadeTypeSecondaryCount;
		}

		if ( curr_ammo >= maxAmmo )
			continue;

		if ( isdefined( playerSoundOnUse ) )
			player playLocalSound( playerSoundOnUse );
		if ( isdefined( npcSoundOnUse ) )
			player playSound( npcSoundOnUse );

		self thread [[callback]]( player );
	}
}

onSpawnRetrievableWeaponObject( watcher, player ) // self == weapon (for example: the claymore)
{
	self endon( "death" );
	self endon( "hacked" );

	if ( isHacked() ) 
	{
		self thread watchShutdown( player );
		return;
	}
	
	//self thread maps\mp\gametypes\_weaponobjects::onSpawnUseWeaponObject( watcher, player );
	
	self SetOwner( player );
	self SetTeam( player.pers["team"] );
	self.owner = player;
	self.oldAngles = self.angles;

	self waitTillNotMoving();

	if ( isDefined( watcher.activationDelay ))
	{
		wait watcher.activationDelay;
	}

	waittillframeend;

	if(player.pers["team"] == "spectator")
	{
		return;
	}
	
	triggerOrigin = self.origin;
	triggerParentEnt = undefined;
	if ( IsDefined( self.stuckToPlayer ) )
	{
		if ( IsAlive( self.stuckToPlayer ) || !IsDefined( self.stuckToPlayer.body ) )
		{
			triggerParentEnt = self.stuckToPlayer;
		}
		else
		{
			triggerParentEnt = self.stuckToPlayer.body;
		}
	}
	
	if ( IsDefined( triggerParentEnt ) )
	{
		triggerOrigin = triggerParentEnt.origin + ( 0, 0, 10 );
	}
	else
	{
		// move the trigger 1 unit along the up axis to prevent the it
		// from failing the sight trace in player_use
		up = AnglesToUp( self.angles );
		triggerOrigin = self.origin + up;
	}
	
	self.pickUpTrigger = Spawn( "trigger_radius_use", triggerOrigin );
	self.pickUpTrigger SetHintLowPriority( true );
	self.pickUpTrigger SetCursorHint( "HINT_NOICON", watcher.weapon );
	self.pickUpTrigger EnableLinkTo();
	self.pickUpTrigger LinkTo( self );
	self.pickUpTrigger SetInvisibleToAll();
	self.pickUpTrigger SetVisibleToPlayer( player );
	
	if( IsDefined(level.retrieveHints[watcher.name]) )
	{
		self.pickUpTrigger SetHintString( level.retrieveHints[watcher.name].hint );
	}
	else
	{
		self.pickUpTrigger SetHintString( &"MP_GENERIC_PICKUP" );
	}

	// if we're team based then set the team on the trigger
	if ( level.teamBased )
	{
		self.pickUpTrigger SetTeamForTrigger( player.pers["team"] );
	}
	else
	{
		self.pickUpTrigger SetTeamForTrigger( "none" );
	}
	
	if ( IsDefined( triggerParentEnt ) )
	{
		self.pickUpTrigger linkto( triggerParentEnt );
	}

	if ( watcher.enemyDestroy )
	{
		self.enemyTrigger = Spawn( "trigger_radius_use", triggerOrigin );
		self.enemyTrigger SetCursorHint( "HINT_NOICON", watcher.weapon );
		self.enemyTrigger EnableLinkTo();
		self.enemyTrigger LinkTo( self );
		self.enemyTrigger SetInvisibleToPlayer( player );

		if ( level.teamBased )
		{
			self.enemyTrigger SetExcludeTeamForTrigger( player.team );
			self.enemyTrigger.triggerTeamIgnore = self.team;
		}

		if( IsDefined(level.destroyHints[watcher.name]) )
		{
			self.enemyTrigger SetHintString( level.destroyHints[watcher.name].hint );
		}
		else
		{
			self.enemyTrigger SetHintString( &"MP_GENERIC_DESTROY" );
		}

		self thread watchUseTrigger( self.enemyTrigger, watcher.onDestroyed );
	}

	self thread watchUseTrigger( self.pickUpTrigger, watcher.pickUp, watcher.pickUpSoundPlayer, watcher.pickUpSound );

	/#
	thread switch_team( self, watcher.weapon, player );
	#/

	if ( isDefined( watcher.pickup_trigger_listener ) )
	{
		self thread [[watcher.pickup_trigger_listener]]( self.pickUpTrigger, player );
	}

	self thread watchShutdown( player );
}

watch_trigger_visibility( triggers, weap_name ) // self == weapon (for example: the hatchet)
{
	self notify( "watchTriggerVisibility" );
	self endon( "watchTriggerVisibility" );
	self endon( "death" );
	self endon( "hacked" );

	max_ammo = WeaponMaxAmmo( weap_name );
	start_ammo = WeaponStartAmmo( weap_name );
	ammo_to_check = 0;

	while( true )
	{
		players = level.players;
		for( i = 0; i < players.size; i++ )
		{
			// make sure the player has the weapon
			if( players[i] HasWeapon( weap_name ) )
			{
				ammo_to_check = max_ammo;

				// see if the player is the owner
				if( self.owner == players[i] )
				{
					// now we are the owner, if we have less than the max ammo then we should hide the enemy trigger so we can see the owner pick up trigger
					curr_ammo = players[i] GetWeaponAmmoStock( weap_name ) + players[i] GetWeaponAmmoClip( weap_name );
					if( weap_name == "hatchet_mp" )
					{
						curr_ammo = players[i] GetWeaponAmmoStock( weap_name );
					}

					if( curr_ammo < ammo_to_check )
					{
						triggers[ "owner_pickup" ] SetVisibleToPlayer( players[i] );
						triggers[ "enemy_pickup" ] SetInvisibleToPlayer( players[i] );
					}
					// we are the owner, so if we have the max ammo already then hide the triggers
					else
					{
						triggers[ "owner_pickup" ] SetInvisibleToPlayer( players[i] );
						triggers[ "enemy_pickup" ] SetInvisibleToPlayer( players[i] );
					}
				}
				// we aren't the owner
				else
				{
					// now we aren't the owner, if we have less than the max ammo then we should show the enemy trigger and hide the owner trigger
					curr_ammo = players[i] GetWeaponAmmoStock( weap_name ) + players[i] GetWeaponAmmoClip( weap_name );
					if( weap_name == "hatchet_mp" )
					{
						curr_ammo = players[i] GetWeaponAmmoStock( weap_name );
					}

					if( curr_ammo < ammo_to_check )
					{
						triggers[ "owner_pickup" ] SetInvisibleToPlayer( players[i] );
						triggers[ "enemy_pickup" ] SetVisibleToPlayer( players[i] );
					}
					// we aren't the owner, so if we have the max ammo already then hide the triggers
					else
					{
						triggers[ "owner_pickup" ] SetInvisibleToPlayer( players[i] );
						triggers[ "enemy_pickup" ] SetInvisibleToPlayer( players[i] );
					}
				}
			}
			// you don't have the weapon so hide the triggers
			else
			{
				triggers[ "owner_pickup" ] SetInvisibleToPlayer( players[i] );
				triggers[ "enemy_pickup" ] SetInvisibleToPlayer( players[i] );
			}
		}

		wait( 0.05);
	}
}

destroyEnt()
{
	self delete();
}

pickUp( player ) // self == weapon (for example: the claymore)
{
	if ( self.name != "hatchet_mp" && IsDefined( self.owner ) && self.owner != player )
	{
		return;
	}
	
	self.playDialog = false;
	self destroyEnt();
	player GiveWeapon( self.name );
	
	clip_ammo = player GetWeaponAmmoClip( self.name );
	clip_max_ammo = WeaponClipSize( self.name );

	//if( self.name == "hatchet_mp" && !player HasPerk( "specialty_twogrenades" ) )
	//{
	//	clip_max_ammo = WeaponStartAmmo( self.name );
	//}

	if( clip_ammo < clip_max_ammo )
	{
		clip_ammo++;
	}
	player setWeaponAmmoClip( self.name, clip_ammo );
}

onDestroyed( attacker ) // self == weapon object
{
	PlayFX( level._effect["tacticalInsertionFizzle"], self.origin );
	self playsound ("dst_tac_insert_break");

	self.owner maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "equipment_destroyed", "item_destroyed" );

	self delete(); // will call watchShutdow() to clean up the trigger ents
}

watchShutdown( player ) // self == weapon (for example: the claymore)
{
	self waittill_any( "death", "hacked" );

	pickUpTrigger = self.pickUpTrigger;
	hackerTrigger = self.hackerTrigger;
	hatchetPickUpTrigger = self.hatchetPickUpTrigger;
	enemyTrigger = self.enemyTrigger;
	
	if( IsDefined( pickUpTrigger ) )
		pickUpTrigger delete();

	if( IsDefined( hackerTrigger ) )
	{
		if ( IsDefined( hackerTrigger.progressBar ) )
		{
			hackerTrigger.progressBar destroyElem();
			hackerTrigger.progressText destroyElem();
		}
		hackerTrigger delete();
	}

	if( IsDefined( hatchetPickUpTrigger ) )
		hatchetPickUpTrigger delete();

	if ( IsDefined( enemyTrigger ))
	{
		enemyTrigger delete();
	}
}

watchUseTrigger( trigger, callback, playerSoundOnUse, npcSoundOnUse ) // self == weapon (for example: the claymore)
{
	self endon( "delete" );
	self endon( "hacked" );
	
	while ( true )
	{
		trigger waittill( "trigger", player );
			
		if ( !isAlive( player ) )
			continue;
			
		if ( !player isOnGround() )
			continue;
			
		if ( isDefined( trigger.triggerTeam ) && ( player.pers["team"] != trigger.triggerTeam ) )
			continue;
			
		if ( isDefined( trigger.triggerTeamIgnore ) && ( player.team == trigger.triggerTeamIgnore ) )
			continue;

		if ( isDefined( trigger.claimedBy ) && ( player != trigger.claimedBy ) )
			continue;

		grenade = player.throwingGrenade;
		isEquipment = IsWeaponEquipment( player GetCurrentWeapon() );

		if ( isDefined( isEquipment ) && isEquipment )
		{
			grenade = false;
		}
			
		if ( player useButtonPressed() && !grenade && !player meleeButtonPressed() )
		{
			if ( isdefined( playerSoundOnUse ) )
				player playLocalSound( playerSoundOnUse );
			if ( isdefined( npcSoundOnUse ) )
				player playSound( npcSoundOnUse );
			self thread [[callback]]( player );
		}
	}
}

createRetrievableHint(name, hint)
{
	retrieveHint = spawnStruct();

	retrieveHint.name = name;
	retrieveHint.hint = hint;

	level.retrieveHints[name] = retrieveHint;
}

createHackerHint(name, hint)
{
	hackerHint = spawnStruct();

	hackerHint.name = name;
	hackerHint.hint = hint;

	level.hackerHints[name] = hackerHint;
}

createDestroyHint(name, hint)
{
	destroyHint = spawnStruct();

	destroyHint.name = name;
	destroyHint.hint = hint;

	level.destroyHints[name] = destroyHint;
}

attachReconModel( modelName, owner )
{
	if ( !isDefined( self ) )
		return;
		
	reconModel = spawn( "script_model", self.origin );
	reconModel.angles = self.angles;
	reconModel SetModel( modelName );
	reconModel.model_name = modelName;
	reconModel linkto( self );
	reconModel SetContents( 0 );
	reconModel resetReconModelVisibility( owner );
	reconModel thread watchReconModelForDeath( self );
	reconModel thread resetReconModelOnEvent( "joined_team", owner );
	reconModel thread resetReconModelOnEvent( "player_spawned", owner );
}

resetReconModelVisibility( owner ) // self == reconModel
{	
	if ( !isDefined( self ) )
		return;
	
	self SetInvisibleToAll();
	self SetForceNoCull();

	if ( !isDefined( owner ) )
		return;
		
	for ( i = 0 ; i < level.players.size ; i++ )
	{		
		// if you don't have a perk that shows recon models, just continue
		if( !(level.players[i] HasPerk( "specialty_detectexplosive" )) &&
			!(level.players[i] HasPerk( "specialty_showenemyequipment" )) )
		{
			continue;
		}

		if ( level.players[i].team == "spectator" )
			continue;
		
		hasReconModel = false;
		// specialty_detectexplosive should see c4, claymore
		if( level.players[i] HasPerk( "specialty_detectexplosive" ) )
		{
			switch( self.model_name )
			{
			case "t6_wpn_claymore_world_detect": // tagTMR<TODO>: add betty model watcher when name is known
			case "t6_wpn_c4_world_detect":
				hasReconModel = true;
				break;
			
			default:
				break;
			}
		}

		// specialty_showenemyequipment should see jammer, motion sensor, camera spike, sentry gun, tow turret, tactical insertion
		// TODO: add sentry gun, tow turret, and tactical insertion recon models
		if( level.players[i] HasPerk( "specialty_showenemyequipment" ) )
		{
			switch( self.model_name )
			{
			case "t6_wpn_c4_world_detect":
			case "t5_weapon_scrambler_world_detect":
			case "t6_wpn_tac_insert_detect":
			case "t6_wpn_taser_mine_world_detect":
			case "t6_wpn_motion_sensor_world_detect":
			case "t6_wpn_trophy_system_world_detect":
			case "t6_wpn_bouncing_betty_world_detect":
			case "t6_wpn_claymore_world_detect":
				hasReconModel = true;
				break;

			default:
				break;
			}
		}
		
		if( !hasReconModel )
			continue;

		isEnemy = true;
				
		if ( level.teamBased )
		{
			if ( level.players[i].team == owner.team )
				isEnemy = false;
		}
		else
		{
			if ( level.players[i] == owner )
				isEnemy = false;
		}
		
		if ( isEnemy )
		{
			self SetVisibleToPlayer( level.players[i] );
		}
	}
}

watchReconModelForDeath( parentEnt ) // self == reconModel
{
	self endon( "death" );
	
	parentEnt waittill_any( "death", "hacked" );
	self delete();
}

resetReconModelOnEvent( eventName, owner ) // self == reconModel
{
	self endon( "death" );
	
	for ( ;; )
	{
		level waittill( eventName, newOwner );
		if( IsDefined( newOwner ) )
		{
			owner = newOwner;
		}
		self resetReconModelVisibility( owner );
	}
}

/#
switch_team( entity, weapon_name, owner ) // self == ??
{
	self notify( "stop_disarmthink" );
	self endon( "stop_disarmthink" );
	self endon( "death" );

	//Init my dvar
	SetDvar("scr_switch_team", "");

	while( true )
	{
		wait(0.5);

		//Grab my dvar every .5 seconds in the form of an int
		devgui_int = GetDvarint( "scr_switch_team");

		//"" returns as zero with GetDvarInt
		if(devgui_int != 0)
		{
			// spawn a larry to be the opposing team
			team = "autoassign";

			player = maps\mp\gametypes\_dev::getOrMakeBot(team);
			if( !isdefined( player ) ) 
			{
				println("Could not add test client");
				wait 1;
				continue;
			}

			entity.owner hackerRemoveWeapon( entity );

			entity.hacked = true;
			entity SetOwner( player );
			entity SetTeam( player.pers["team"] );
			entity.owner = player;
 
			// kill the previous owner's threads
			entity notify( "hacked", player );
			level notify( "hacked", entity, player );

			if ( entity.name == "camera_spike_mp" && IsDefined( entity.cameraHead ) )
			{
				entity.cameraHead notify( "hacked", player );
			}
			
			wait ( 0.05 ); // let current threads clean up from the 'hacked' notify

			if ( IsDefined( player ) && player.sessionstate == "playing" )
			{
				// this will re-initialize the watcher system for this equipment
				player notify( "grenade_fire", self, self.name );
			}

			SetDvar("scr_switch_team", "0");
		}
	}
}

#/