#include maps\_utility;
#include common_scripts\utility;

preload()
{
	precacheturret( "auto_gun_turret_sp" );
	PrecacheModel( "t5_weapon_minigun_turret" );
	PrecacheModel( "t5_weapon_minigun_turret_yellow" );
	PrecacheModel( "t5_weapon_minigun_turret_red" );
	precacheturret( "tow_turret_sp" );

	
	PrecacheModel( "T6_wpn_turret_sam" );
	PrecacheModel( "T6_wpn_turret_sam_yellow" );
	PrecacheModel( "T6_wpn_turret_sam_red" );
	
	
	
	
	level._turret_explode_fx = loadfx( "explosions/fx_exp_equipment_lg" );
	level._turret_disable_fx = loadfx ("weapon/grenade/fx_spark_disabled_weapon_lg");
	
	//Sentry version
	maps\sp_killstreaks\_killstreaks::registerKillstreak("autoturret_sp", "autoturret_sp", "killstreak_auto_turret", "auto_turret_used", ::useSentryTurretKillstreak );
	maps\sp_killstreaks\_killstreaks::registerKillstreakAltWeapon( "autoturret_sp", "auto_gun_turret_sp" );
	maps\sp_killstreaks\_killstreaks::registerKillstreakStrings("autoturret_sp", &"KILLSTREAK_EARNED_AUTO_TURRET", &"KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDialog("autoturret_sp", "mpl_killstreak_auto_turret", "kls_turret_used", "","kls_turret_enemy", "", "kls_turret_drop");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDevDvar("autoturret_sp", "scr_giveautoturret");
/*
	maps\sp_killstreaks\_killstreaks::registerKillstreak("turret_drop_sp", "turret_drop_sp", "killstreak_auto_turret_drop", "auto_turret_used", ::useKillstreakTurretDrop, undefined, true );
	//maps\sp_killstreaks\_killstreaks::registerKillstreakAltWeapon( "autoturret_sp", "auto_gun_turret_sp" );
	maps\sp_killstreaks\_killstreaks::registerKillstreakStrings("turret_drop_sp", &"KILLSTREAK_EARNED_AUTO_TURRET", &"KILLSTREAK_AIRSPACE_FULL");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDialog("turret_drop_sp", "mpl_killstreak_turret", "kls_turret_used", "","kls_turret_enemy", "", "kls_turret_ready");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDevDvar("turret_drop_sp", "scr_giveautoturretdrop");

	// this causes the player to keep holding the weapon until the hardpoint is done
	maps\sp_killstreaks\_supplydrop::registerCrateType( "turret_drop_sp", "killstreak", "autoturret_sp", 1, &"KILLSTREAK_AUTO_TURRET_CRATE", undefined, "MEDAL_SHARE_PACKAGE_AUTO_TURRET", maps\sp_killstreaks\_supplydrop::giveCrateKillstreak );
*/	
	level.killStreakIcons["autoturret_sp"] = "hud_ks_auto_turret";
	
		//Tow version
	maps\sp_killstreaks\_killstreaks::registerKillstreak("auto_tow_sp", "auto_tow_sp", "killstreak_tow_turret", "tow_turret_used", ::useTowTurretKillstreak );
	maps\sp_killstreaks\_killstreaks::registerKillstreakAltWeapon( "auto_tow_sp", "tow_turret_sp" );
	maps\sp_killstreaks\_killstreaks::registerKillstreakStrings("auto_tow_sp", &"KILLSTREAK_EARNED_TOW_TURRET", &"KILLSTREAK_TOW_TURRET_NOT_AVAILABLE");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDialog("auto_tow_sp", "mpl_killstreak_auto_turret", "kls_tow_used", "","kls_tow_enemy", "", "kls_tow_drop");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDevDvar("auto_tow_sp", "scr_giveautotowturret");
	level.killStreakIcons["auto_tow_sp"] = "hud_ks_sam_turret";
	
/*
	maps\sp_killstreaks\_killstreaks::registerKillstreak("tow_turret_drop_sp", "tow_turret_drop_sp", "killstreak_tow_turret_drop", "tow_turret_used", ::useKillstreakTurretDrop, undefined, true );
	//maps\sp_killstreaks\_killstreaks::registerKillstreakAltWeapon( "autoturret_sp", "auto_gun_turret_sp" );
	maps\sp_killstreaks\_killstreaks::registerKillstreakStrings("tow_turret_drop_sp", &"KILLSTREAK_EARNED_TOW_TURRET", &"KILLSTREAK_AIRSPACE_FULL");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDialog("tow_turret_drop_sp", "mpl_killstreak_auto_turret", "kls_tow_used", "","kls_tow_enemy", "", "kls_tow_ready");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDevDvar("tow_turret_drop_sp", "scr_giveautotowturretdrop");


	// this causes the player to keep holding the weapon until the hardpoint is done
//		maps\sp_killstreaks\_killstreaks::setRemoveWeaponWhenUsed("autoturret_sp", true);
	maps\sp_killstreaks\_supplydrop::registerCrateType( "tow_turret_drop_sp", "killstreak", "auto_tow_sp", 1, &"KILLSTREAK_TOW_TURRET_CRATE", undefined, "MEDAL_SHARE_PACKAGE_TOW_TURRET", maps\sp_killstreaks\_supplydrop::giveCrateKillstreak );
	level.killStreakIcons["auto_tow_sp"] = "hud_ks_sam_turret";
*/
	
}



//AUTO_TURRET_TIMEOUT = 90.0;
///////////////////////////////////////////////////////
//		Turret Initialization Functions
///////////////////////////////////////////////////////
init()
{
	thread init_turret_difficulty_settings();
	level.auto_turret_timeout = 90.0;
	flag_init("end_target_confirm");
	level.auto_turret_settings = [];
	

	level.auto_turret_settings["sentry"] = spawnStruct();
	level.auto_turret_settings["sentry"].hintString = &"KILLSTREAK_SENTRY_TURRET_PICKUP";
	level.auto_turret_settings["sentry"].hackerHintString = &"KILLSTREAK_TURRET_HACKING";
	level.auto_turret_settings["sentry"].hintIcon = "hud_ks_auto_turret";
	level.auto_turret_settings["sentry"].modelBase = "t5_weapon_minigun_turret";
	level.auto_turret_settings["sentry"].modelGoodPlacement = "t5_weapon_minigun_turret_yellow";
	level.auto_turret_settings["sentry"].modelBadPlacement = "t5_weapon_minigun_turret_red";
	level.auto_turret_settings["sentry"].stunFX = level._turret_disable_fx;
	level.auto_turret_settings["sentry"].stunFXFrequencyMin = 0.1;
	level.auto_turret_settings["sentry"].stunFXFrequencyMax = 0.75;
	level.auto_turret_settings["sentry"].turretInitDelay = 1.0;

	level.auto_turret_settings["tow"] = spawnStruct();
	level.auto_turret_settings["tow"].hintString = &"KILLSTREAK_TOW_TURRET_PICKUP";
	level.auto_turret_settings["tow"].hackerHintString = &"KILLSTREAK_TURRET_HACKING";
	level.auto_turret_settings["tow"].hintIcon = "hud_ks_sam_turret";
	level.auto_turret_settings["tow"].modelBase = "T6_wpn_turret_sam";
	level.auto_turret_settings["tow"].modelGoodPlacement = "T6_wpn_turret_sam_yellow";
	level.auto_turret_settings["tow"].modelBadPlacement = "T6_wpn_turret_sam_red";
	level.auto_turret_settings["tow"].stunFX = level._turret_disable_fx;
	level.auto_turret_settings["tow"].stunFXFrequencyMin = 0.1;
	level.auto_turret_settings["tow"].stunFXFrequencyMax = 0.75;
	level.auto_turret_settings["tow"].turretInitDelay = 1.0;
	level.auto_turret_settings["tow"].turretFireDelay = 5.0;


	//Used later to check if turret is in trigger_hurt's or minefields
	minefields = GetEntarray( "minefield", "targetname" );
	hurt_triggers = GetEntArray( "trigger_hurt","classname" );
	level.fatal_triggers = ArrayCombine( minefields, hurt_triggers, true, false );
	level.noTurretPlacementTriggers = getEntArray( "no_turret_placement", "targetname" );


	level.turrets_headicon_offset = [];
	level.turrets_headicon_offset["default"] = (0, 0, 70); 
	level.turrets_headicon_offset["sentry"] = (0, 0, 70); 
	level.turrets_headicon_offset["tow"] = (0, 0, 65); 

	level.turrets_hacker_trigger_width = 72; 
	level.turrets_hacker_trigger_height = 96; 
}



///////////////////////////////////////////////////////
//		Turret Supply Drop Functions
///////////////////////////////////////////////////////
useKillstreakTurretDrop(hardpointType)
{
/*
	if( self maps\sp_killstreaks\_supplydrop::isSupplyDropGrenadeAllowed(hardpointType) == false )
		return false;

	self thread maps\sp_killstreaks\_supplydrop::refCountDecChopperOnDisconnect();
	
	result = self maps\sp_killstreaks\_supplydrop::useSupplyDropMarker();
	
	self notify( "supply_drop_marker_done" );

	if ( !IsDefined(result) || !result )
	{
		return false;
	}

	return result;
*/
	return false;
}

useSentryTurretKillstreak( hardpointType )
{
	if ( self maps\sp_killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	if ( self maps\sp_killstreaks\_killstreakrules::killstreakStart( hardpointType, self.team ) == false )
		return false;

	self thread useSentryTurret( hardpointType );

	return true;
}

useTowTurretKillstreak( hardpointType )
{
	if ( self maps\sp_killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	if ( self maps\sp_killstreaks\_killstreakrules::killstreakStart( hardpointType, self.team ) == false )
		return false;

	self thread useTowTurret( hardpointType );

	return true;
}

useSentryTurret( hardpointType )
{

	//self maps\sp_killstreaks\_killstreaks::printKillstreakStartText( hardpointType, self, self.team );
	level.globalKillstreaksCalled++;
	//self AddWeaponStat( hardpointType, "used", 1 );

	//Spawn a turret at this location 
	turret = spawnTurret( "auto_turret", self.origin, "auto_gun_turret_sp" );
	turret.turretType = "sentry";
	turret SetTurretType(turret.turretType);

	turret SetModel( level.auto_turret_settings[turret.turretType].modelGoodPlacement );
	turret.angles = self.angles;
	turret.hardPointWeapon = hardpointType;
	turret.hasBeenPlanted = false;
	turret.waitForTargetToBeginLifespan = false;
	self.turret_active = false;
	self.curr_time = -1;
	turret.stunnedByTacticalGrenade = false;
	turret.stunTime = 0.0;

	if( level.teamBased )
	{
		turret setturretteam( self.team );
		turret.team = self.team;
	}
	else
	{
		turret setturretteam( "free" );
		turret.team = "free";
	}
	
	//Set up turret health and damage modifiers
	setupTurretHealth( turret );
	self.carryingTurret = true;
	//Set the turret's lifespan
	turret.carried = true;
	turret.curr_time = 0;
	turret.stunDuration = 5.0;


	//Wait until turret's lifespan is used and remove the turret
	turret thread watchTurretLifespan();

	self thread watchOwnerDisconnect( turret );
	turret thread destroyTurret();


	//Setup the turret for carrying
	self thread startCarryTurret( turret );
	
}

useTowTurret( hardpointType )
{
	//self maps\sp_killstreaks\_killstreaks::printKillstreakStartText( hardpointType, self, self.team );
	level.globalKillstreaksCalled++;
	//self AddWeaponStat( hardpointType, "used", 1 );

	
	//Spawn a turret at this location 
	turret = spawnTurret( "auto_turret", self.origin, "tow_turret_sp" );
	turret.turretType = "tow";
	turret SetTurretType(turret.turretType);

	turret SetModel( level.auto_turret_settings[turret.turretType].modelGoodPlacement );
	turret.angles = self.angles;
	turret.hardPointWeapon = hardpointType;
	turret.hasBeenPlanted = false;
	turret.waitForTargetToBeginLifespan = false;
	turret.fireTime = level.auto_turret_settings["tow"].turretFireDelay;
	self.turret_active = false;
	turret.stunnedByTacticalGrenade = false;
	turret.stunTime = 0.0;

	if( level.teamBased )
	{
		turret setturretteam( self.team );
		turret.team = self.team;
	}
	else
	{
		turret setturretteam( "free" );
		turret.team = "free";
	}

	//Set up turret health and damage modifiers
	setupTurretHealth( turret );
	self.carryingTurret = true;
	//Set the turret's lifespan
	turret.carried = true;
	turret.curr_time = 0;
	turret.stunDuration = 5.0;

	//Set the scan angle to look at the sky.
	turret SetScanningPitch(-35.0);

	//Wait until turret's lifespan is used and remove the turret
	turret thread watchTurretLifespan();

	self thread watchOwnerDisconnect( turret );
	turret thread destroyTurret();


	//Setup the turret for carrying
	self thread startCarryTurret( turret );
	
}

///////////////////////////////////////////////////////
//		Turret Owner Functions
///////////////////////////////////////////////////////

watchRoundAndGameEnd( turret )
{
	self endon("disconnect");
	turret endon("turret_placed");
	turret endon("destroy_turret");
	turret endon("hacked");

	//Destroy the turret if we are still carrying it at round or game end.
	level waittill( "game_ended" );
	
	self stopCarryTurret( turret );
	turret notify( "destroy_turret", false );
}

watchOwnerDeath( turret )
{
	self endon("disconnect");
	turret endon("turret_placed");
	turret endon("destroy_turret");
	turret endon("hacked");
	
	self waittill("death");

	if( !turret.hasBeenPlanted )
	{
		//Check for player changing teams
		if( self.team != turret.team )
		{
			self stopCarryTurret( turret );
			turret notify( "destroy_turret", false );
		}
		else
		{
			maps\sp_killstreaks\_killstreaks::giveKillstreak( turret.hardPointWeapon, undefined, undefined, true );
			turret setTurretCarried( false );
			self stopCarryTurret( turret );
			self _enableWeapon();
			turret notify( "destroy_turret", false );
		}
	}
	else if( turret.canBePlaced && turret.carried )
	{
		//Check for player changing teams
		if( level.teamBased && self.team != turret.team )
		{
			self stopCarryTurret( turret );
			turret notify( "destroy_turret", false );
		}
		else
		{
			self placeTurret( turret );
		}
	}
	else
	{
		if( isdefined( turret ) ) 
		{
			self stopCarryTurret( turret );
			turret notify( "destroy_turret", false );
		}
	}
}

watchOwnerLastStand( turret )
{
	self endon("disconnect");
	self endon("death");
	turret endon("turret_placed");
	turret endon("destroy_turret");
	turret endon("hacked");

	while(1)
	{
		self waittill("entering_last_stand");

		if( !turret.hasBeenPlanted )
		{
			maps\sp_killstreaks\_killstreaks::giveKillstreak( turret.hardPointWeapon, undefined, undefined, true );
			turret setTurretCarried( false );
			self stopCarryTurret( turret );
			self _enableWeapon();
			self TakeWeapon(turret.hardPointWeapon);
			turret notify( "destroy_turret", false );
		}
		else if( turret.canBePlaced && turret.carried )
		{
			self placeTurret( turret );
		}
		else
		{
			if( isdefined( turret ) ) 
			{
				self stopCarryTurret( turret );
				turret notify( "destroy_turret", false );
			}
		}
	}
}

watchOwnerDisconnect( turret )
{
	turret endon("turret_deactivated");
	turret endon("hacked");
	self waittill_any( "disconnect", "joined_team" );

	if( isdefined( turret ) ) 
		turret notify( "destroy_turret", true );
}

///////////////////////////////////////////////////////
//		Turret Carry Functions
///////////////////////////////////////////////////////

startCarryTurret( turret )
{
	turret maketurretunusable();
	turret setTurretCarried( true );
	self _disableWeapon();
	turret SetMode( "auto_ai" );

	if( turret.turretType == "sentry" )
	{
		turret notify( "stop_burst_fire_unmanned" );
	}
	else if( turret.turretType == "tow" )
	{
		turret notify( "target_lost" );
	}
	turret.carried = true;
	self.carryingTurret = true;
	removeFromPlacedTurretList(turret);
	
	//Drop any ballistic knives that may be attached to the turret.
	if( turret.hasBeenPlanted )
		level notify( "drop_objects_to_ground", turret.origin, 80 );

	self CarryTurret( turret, (40,0,0), (0,0,0) );

	self thread watchOwnerDeath( turret );
	self thread watchOwnerLastStand( turret );
	self thread watchRoundAndGameEnd( turret );
	turret maps\sp_killstreaks\_entityheadicons::destroyEntityHeadIcons();
	turret SetDefaultDropPitch(-90.0);

	//Watch turret placement
	self thread updateTurretPlacement( turret );
	self thread watchTurretPlacement( turret );

	//Ensure pickup trigger is cleaned up
	turret notify( "turret_carried" );
}

updateTurretPlacement( turret )
{
  self endon( "death" );
  self endon( "entering_last_stand" );
  self endon( "disconnect" );
  turret endon( "turret_placed" );
  turret endon( "turret_deactivated" );

  lastPlacedTurret = -1;
  turret.canBePlaced = false;

	while( 1 )
	{
		placement = self canPlayerPlaceTurret();

		turret.origin = placement["origin"];
		turret.angles = placement["angles"];
		//'good_spot_check' is only true if the placement result returns true and the turret in hurt trigger returns false
		good_spot_check = placement["result"] & !(turret turretInHurtTrigger());
		good_spot_check = placement["result"] & !(turret turretInNoTurretPlacementTrigger());
		turret.canBePlaced = good_spot_check;

		if( turret.canBePlaced != lastPlacedTurret )
		{
			if( good_spot_check )
				turret SetModel( level.auto_turret_settings[turret.turretType].modelGoodPlacement );
			else
				turret SetModel( level.auto_turret_settings[turret.turretType].modelBadPlacement );

			lastPlacedTurret = turret.canBePlaced;
		}

		//self SetTurretHint( turret.canBePlaced );

		wait(0.05);
	}
}

//'Self' is the turret. Function checks to see if turret is in minefield or hurt trigger.
//level.fatal_triggers is defined in the init function.
turretInHurtTrigger()
{
	for( i = 0; i < level.fatal_triggers.size; i++ )
	{
		if( self IsTouching(level.fatal_triggers[i]) )
		{
			return true;
		}
	}
	return false;
}

turretInNoTurretPlacementTrigger()
{
	for( i = 0; i < level.noTurretPlacementTriggers.size; i++ )
	{
		if( self IsTouching(level.noTurretPlacementTriggers[i]) )
		{
			return true;
		}
	}
	return false;
}

watchTurretPlacement( turret )
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "entering_last_stand" );
	turret endon( "turret_placed" );
	turret endon( "turret_deactivated" );

	while(1)
	{
		if( !turret.hasBeenPlanted && self [[level.ActionSlotPressed]]() )
		{
			maps\sp_killstreaks\_killstreaks::giveKillstreak( turret.hardPointWeapon, undefined, undefined, true );
			turret setTurretCarried( false );
			self.carryingTurret = false;
			self stopCarryTurret( turret );
			self _enableWeapon();
			turret notify( "destroy_turret", false );
			break;
		}
		if( self attackbuttonpressed() && turret.canBePlaced )
		{
			//ensure proper placememt
			placement = self canPlayerPlaceTurret();

			if( placement["result"] )
			{
				turret.origin = placement["origin"];
				turret.angles = placement["angles"];
				self placeTurret( turret );
			}
		}

		wait(0.05);

	}
}

addToPlacedTurretList(turret)
{
	assert( !isTurretInPlacedTurretList(turret),"Turret already in the placed turret list" );
	if (!isDefined(level.placed_turrets))
	{
		level.placed_turrets = [];
	}
	level.placed_turrets[level.placed_turrets.size] = turret;
}
removeFromPlacedTurretList(turret)
{
	if (!isDefined(level.placed_turrets))
	{
		return;
	}

	ArrayRemoveValue(level.placed_turrets,turret);
}

isTurretInPlacedTurretList(turret)
{
	if ( !isDefined(level.placed_turrets) )
		return false;
	
	foreach (pturret in level.placed_turrets)
	{
		if (pturret == turret )
			return true;
	}
	return false;
}

getClosestPlaceTurret(origin,max_dist)
{
	assert( isDefined(origin),"Origin param cannot be undefined");
	assert( isDefined(max_dist),"max_dist param cannot be undefined");
	
	if ( !isDefined(level.placed_turrets) )
		return undefined;
	
	closestDist		= 99999999;
	closestTurret	= undefined;	
	
	foreach (pturret in level.placed_turrets)
	{
		distance = DistanceSquared(origin,pturret.origin);
		if ( distance > max_dist )
			continue;
		if ( distance < closestDist )
		{
			closestDist 	= distance;
			closestTurret	= pturret;
		}
	}

	return closestTurret;
}

placeTurret( turret )
{

	if( !turret.carried || !turret.canBePlaced )
		return;

	addToPlacedTurretList(turret);
	
	turret setTurretCarried( false );
	self stopCarryTurret( turret, turret.origin, turret.angles );
	turret spawnTurretPickUpTrigger( self );
//	turret spawnTurretHackerTrigger( self );
	self thread initTurret( turret );
	self _enableWeapon();
	turret.carried = false;
	self.carryingTurret = false;
	turret.hasBeenPlanted = true;

	turret thread watchScramble();

	//If turret was stunned before it was picked up, make it stunned again
	if( turret.stunnedByTacticalGrenade )
		turret thread stunTurretTacticalGrenade( turret.stunDuration );


	// rumble on placement
	self PlayRumbleOnEntity( "damage_heavy" );
	
	//Play scanning sounds
	turret thread TurretScanStartWaiter();
	//turret thread TurretScanStopWaiter();

	turret notify("turret_placed");
}

///////////////////////////////////////////////////////
//		Turret Setup Functions
///////////////////////////////////////////////////////

initTurret( turret )
{
	turret_set_difficulty( turret, "fu" );
	turret SetModel( level.auto_turret_settings[turret.turretType].modelBase );
	turret SetForceNoCull();
	turret PlaySound ("mpl_turret_startup");
	
	//Set the turret team
	//turret setturretteam( self.pers["team"] );
	//turret.team = self.pers["team"];
	
	if( level.teambased )
	{
		offset = level.turrets_headicon_offset[ "default" ];
		if( IsDefined( level.turrets_headicon_offset[ turret.turretType ] ) )
		{
			offset = level.turrets_headicon_offset[ turret.turretType ];
		}
		turret maps\sp_killstreaks\_entityheadicons::setEntityHeadIcon( self.pers["team"], self, offset );
	}

	//Make it automated
	turret maketurretunusable();
	turret SetMode( "auto_nonai", "scan" );
	turret.owner = self;
	turret SetDefaultDropPitch(45.0);


	if( turret.turretType == "sentry" )
		turret thread turret_sentry_think( self );
	else if( turret.turretType == "tow" )
		turret thread turret_tow_think( self );

	turret.turret_active = true;
	turret.takedamage = true;

	//Track the turret's health
	turret thread watchDamage();
	turret thread checkForStunDamage();

	wait(1.0);
	flag_set("end_target_confirm");
}

setupTurretHealth( turret )
{
	turret.health = 2000;
	turret.bulletDamageReduction = 0.3;
}

///////////////////////////////////////////////////////
//		Turret Watcher Functions
///////////////////////////////////////////////////////
watchDamage()
{
	self endon( "turret_deactivated" );
	
	medalGiven = false;
	self.damageTaken = 0;
	for( ;; )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName  );

		if( !isdefined( attacker ) )
			continue;

		if( isPlayer( attacker ) && level.teambased && isDefined( attacker.team ) && self.team == attacker.team && attacker != self.owner )
			continue;


		if ( ( type == "MOD_PISTOL_BULLET" ) || ( type == "MOD_RIFLE_BULLET" ) )
		{
			if ( isPlayer( attacker ) &&  attacker HasPerk( "specialty_armorpiercing" ) )
				damage += int( damage * level.armorpiercing_data  );

			self.damageTaken += self.bulletDamageReduction * damage;
		}
	/*	
		else if (( type == "MOD_MELEE" ) || ( IsDefined( weaponName ) && ( weaponName == "emp_grenade_sp" )))
			self.damageTaken = self.health;
*/
		else
			self.damageTaken += damage;

		// most equipment should be flash/concussion-able, so it'll disable for a short period of time
		// check to see if the equipment has been flashed/concussed and disable it (checking damage < 5 is a bad idea, so check the weapon name)
		// we're currently allowing the owner/teammate to flash their own
		if ( IsDefined( weaponName ) )
		{
			// do damage feedback
			switch( weaponName )
			{
			case "concussion_grenade_sp":
			case "flash_grenade_sp":
				if( !self.stunnedByTacticalGrenade )
				{
					self thread stunTurretTacticalGrenade( self.stunDuration );
				}
				break;

			default:
				break;
			}
		}

		if( self.damageTaken >= self.health )
		{
			self.damageTaken = self.health;
			self notify( "destroy_turret", true );
		}
	}

}

watchTurretLifespan()
{

	self endon( "turret_deactivated" );
	self endon( "death" );	

	while(1)
	{
		 if( self.curr_time > level.auto_turret_timeout )
			 break;

		 //Check if we want to delay starting the lifespan countdown for this turret
		 if( self.waitForTargetToBeginLifespan )
		 {
			wait(0.1);
			continue;
		 }

		 //Destroy the pick-up trigger a few seconds before the actual turret to avoid picking up a turret while it's getting destroyed
		 if( ( self.curr_time + 2.0 ) > level.auto_turret_timeout )
			 self DeleteTurretUseTrigger();

		 if( !self.carried )
			self.curr_time += 1.0;

		 wait(1.0);
	}
	self notify( "destroy_turret", true );
}

checkForStunDamage()
{
	self endon( "turret_deactivated" );

	while(1)
	{
		self waittill( "damage_caused_by", weapon );

		if( isStunWeapon(weapon) && !self.stunnedByTacticalGrenade )
		{
			self thread stunTurretTacticalGrenade( self.stunDuration );
		}
	}
}

stunTurretTacticalGrenade( duration )
{

	self endon( "turret_deactivated" );
	
	self SetMode( "auto_ai" );
	self notify( "stop_burst_fire_unmanned" );

	if ( self maps\_weaponobjects::isStunned() )
	{
		return;
	}

	self.stunnedByTacticalGrenade = true;
	self thread stunTurretFx();

	if( self.stunnedByTacticalGrenade  )
	{
		while( 1 )
		{
			if( self.stunTime >= duration )
				break;

			if( self.carried )
				return;


			//self.stunTime += 1.0;
			//wait( 1.0 );
			self.stunTime += 0.1;
			wait( 0.1 );
		}
	}

	self.stunnedByTacticalGrenade = false;
	self.stunTime = 0.0;

	/*if ( self maps\_weaponobjects::isStunned() )
	{
		return;
	}*/

	if( !self.carried )
		self SetMode( "auto_nonai" );

	if( self.turretType != "tow" && !self.carried )
		self thread burst_fire_unmanned();


	self notify("turret_stun_ended");
}

stunTurret( duration )
{
	self endon( "turret_deactivated" );

	if ( self maps\_weaponobjects::isStunned() && !self.stunnedByTacticalGrenade )
	{
		return;
	}
	
	self SetMode( "auto_ai" );
	self notify( "stop_burst_fire_unmanned" );
	self thread stunTurretFx();

	if ( IsDefined( duration ) )
	{
		wait( duration );
	}
	else
	{
		return;
	}
	
	if( !self.carried )
		self SetMode( "auto_nonai" );

	if( self.turretType != "tow" && !self.carried )
		self thread burst_fire_unmanned();

	self notify("turret_stun_ended");
	level notify( "turret_stun_ended", self );
}

stunFxThink( fx )
{
	fx endon("death");
	self waittill_any( "death", "turret_stun_ended", "turret_deactivated", "hacked", "turret_carried" );
	fx delete();
}

stunTurretFx()
{
	self endon( "turret_deactivated" );
	self endon( "death" );
	self endon( "turret_stun_ended" );

	if ( self maps\_weaponobjects::isStunned() )
	{
		return;
	}

	origin = self GetTagOrigin( "TAG_aim" );

	self.stun_fx = Spawn( "script_model", origin );
	self.stun_fx SetModel( "tag_origin" );
	self thread stunFxThink( self.stun_fx );
	wait ( 0.1 );

	PlayFXOnTag( level.auto_turret_settings[self.turretType].stunFX, self.stun_fx, "tag_origin" );
	self.stun_fx PlaySound ( "dst_disable_spark" );
}

isStunWeapon( weapon )
{
	switch( weapon )
	{
	case "concussion_grenade_sp":
		return true;
	case "flash_grenade_sp":
		return true;
	default:
		return false;
	}
}

scramblerStun( stun )
{
	if ( stun )
	{
		self thread stunTurret();
	}
	else
	{
		self SetMode( "auto_nonai" );

		if( self.turretType != "tow" )
			self thread burst_fire_unmanned();

		self notify("turret_stun_ended");
		level notify( "turret_stun_ended", self );
	}
}

watchScramble()
{
/*	
	self endon( "death" );
	self endon( "turret_deactivated" );
	self endon( "turret_carried" );

	if ( self maps\mp\_scrambler::checkScramblerStun() )
	{
		self thread scramblerStun( true );
	}

	for ( ;; )
	{
		level waittill_any( "scrambler_spawn", "scrambler_death", "hacked", "turret_stun_ended" );
		wait( 0.05 );

		if ( self maps\mp\_scrambler::checkScramblerStun() )
		{
			self thread scramblerStun( true );
		}
		else
		{
			self scramblerStun( false );
		}
	}
*/	
}

///////////////////////////////////////////////////////
//		Turret Destruction Functions
///////////////////////////////////////////////////////
destroyTurret()
{
	self waittill( "destroy_turret", playDeathAnim );

	if( self.turretType == "sentry" )
		maps\sp_killstreaks\_killstreakrules::killstreakStop( "autoturret_sp", self.team );
	else
		maps\sp_killstreaks\_killstreakrules::killstreakStop( "auto_tow_sp", self.team );

	removeFromPlacedTurretList(self);
	
	//Turn off the turret
	self.turret_active = false;
	self.curr_time = -1;
	self SetMode( "auto_ai" );
	self notify( "stop_burst_fire_unmanned" );
	self notify( "turret_deactivated" );
	self DeleteTurretUseTrigger();
	
	
	if( isDefined( playDeathAnim ) && playDeathAnim && !self.carried )
	{
		// show like it's stunned before we blow it up & play some sound
		self playsound ("dst_equipment_destroy");
		self stunTurret( self.stunDuration );
	}

	//Drop any ballistic knives that may be attached to the turret.
	level notify( "drop_objects_to_ground", self.origin, 80 );
	
	
	wait( 0.1 );

	if( isdefined( self ) ) 
	{
		if( self.hasBeenPlanted )
		{
			PlayFX( level._turret_explode_fx, self.origin + (0, 0, 20) );
			self playsound ("mpl_turret_exp");
		}

		
		if ( isDefined(self.owner) )
		{
			if( self.carried )
			{
				self.owner _enableWeapon();
			}
		}
		self Delete();
	}
}

//Delete the turret retrieve trigger
DeleteTurretUseTrigger()
{
	if( isDefined( self.pickUpTrigger ) )
		self.pickUpTrigger delete();

/*	if( isDefined( self.hackerTrigger ) )
	{
		if ( IsDefined( self.hackerTrigger.progressBar ) )
		{
			self.hackerTrigger.progressBar destroyElem();
			self.hackerTrigger.progressText destroyElem();
		}
		self.hackerTrigger delete();
	}
*/	
}


///////////////////////////////////////////////////////
//		Turret Use Trigger Functions
///////////////////////////////////////////////////////

//Spawn a radius trigger so the player can retrieve their turret
spawnTurretPickUpTrigger( player )
{
	pos = self.origin + (0,0,15);
	self.pickUpTrigger = spawn( "trigger_radius_use", pos );
	
	self.pickUpTrigger SetCursorHint( "HINT_NOICON" );
	
	if( isDefined(level.auto_turret_settings[self.turretType].hintString) )
		self.pickUpTrigger SetHintString( level.auto_turret_settings[self.turretType].hintString );
	else
		self.pickUpTrigger SetHintString( &"MP_GENERIC_PICKUP" );

	if ( level.teamBased )
		self.pickUpTrigger SetTeamForTrigger( player.team );
	player ClientClaimTrigger( self.pickUpTrigger );
	self thread watchTurretUse( self.pickUpTrigger );
}

//Watch to see if the player wishes to pick up their turret
watchTurretUse( trigger )
{
	self endon( "delete" );
	self endon( "turret_deactivated" );
	self endon( "turret_carried" );
	
	while ( true )
	{
		trigger waittill( "trigger", player );
			
		if ( !isAlive( player ) )
			continue;
			
		if ( !player isOnGround() )
			continue;
			
		if ( isDefined( trigger.triggerTeam ) && ( player.team != trigger.triggerTeam ) )
			continue;
			
		if ( isDefined( trigger.claimedBy ) && ( player != trigger.claimedBy ) )
			continue;
			
		if ( player useButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed() && !player attackButtonPressed() && !player.carryingTurret )
		{
			// rumble on pickup
			player PlayRumbleOnEntity( "damage_heavy" );
			self PlaySound ("mpl_turret_down");
			self DeleteTurretUseTrigger();
			player thread startCarryTurret( self );
			self DeleteTurretUseTrigger();
		}
	}
}

///////////////////////////////////////////////////////
//		Turret Firing functions
///////////////////////////////////////////////////////
turret_sentry_think( player )
{
	//Wait for turret to get set and placed before allowing it to fire
	wait( level.auto_turret_settings[self.turretType].turretInitDelay );

	self thread burst_fire_unmanned();
}

turret_tow_think( player )
{
	self endon( "turret_deactivated" );
	self endon( "death" );
	if (isDefined(player))
	{
		player endon( "disconnect" );
	}

	self.turretState = "started";

	self thread missile_fired_notify();

	//Wait for turret to get set and placed before allowing it to fire
	wait( level.auto_turret_settings[self.turretType].turretInitDelay );

	while(1)
	{
		if (isDefined(self.firingPointProcedure_override) )
		{
			self [[self.firingPointProcedure_override]](player);
		}
		else
		{
			if( self IsFiringTurret() && self.turretState != "firing" )
			{
				//self.waitForTargetToBeginLifespan = false;
				self.turretState = "firing";
				self playsound ("mpl_turret_alert"); // Play a state change sound CDC			
				self thread do_tow_shoot(player);
			}
			else
			{
				self notify( "target_lost" );
				self.turretState = "scanning";
			}
		}
		
		self waittill( "turretstatechange" ); // code or script

		self notify( "target_lost" );
	}
}

do_tow_shoot( player )
{
	self endon( "turret_deactivated" );
	self endon( "death" );
	if (isDefined(player))
	{
		player endon( "disconnect" );
	}
	
	self endon( "target_lost" );
	level endon( "game_ended" );

	//self playsound ("mpl_turret_alert"); // Play a state change sound CDC
		
	while(1)
	{
		if( self.fireTime < level.auto_turret_settings["tow"].turretFireDelay )
		{
			//wait( 1.0 );
			//self.fireTime += 1.0;
			wait( 0.1 );
			self.fireTime += 0.1;
			continue;
		}
		self ShootTurret();
		self.fireTime = 0.0;
		
	}
}

missile_fired_notify() // self == tow turret
{
	self endon( "turret_deactivated" );
	self endon( "death" );
	level endon( "game_ended" );
	if( IsDefined( self.owner ) )
	{
		self.owner endon( "disconnect" );
	}

	while ( true )
	{
		self waittill( "missile_fire", missile, weap, target );

		if( IsDefined( target ) )
		{
			target notify( "stinger_fired_at_me", missile, weap, self.owner );
		}

		level notify ( "missile_fired", self, missile, target, true );
	}
}


///////////////////////////////////////////////////////
//		Turret Scanning Functions
///////////////////////////////////////////////////////
TurretScanStartWaiter()
{
	self endon( "turret_deactivated" );
	self endon( "death" );
	self endon( "turret_carried" );
	level endon( "game_ended" );

	turret_scan_start_sound_ent = spawn( "script_origin", self.origin );
	turret_scan_start_sound_ent linkto( self, "tag_origin", (0,0,0), (0,0,0) );

	self thread TurretScanStopWaiter( turret_scan_start_sound_ent );
	self thread TurretScanStopWaiterCleanup( turret_scan_start_sound_ent );
	
	while(1)
	{
		self waittill( "turret_scan_start" );
		//println ("snd scan start");	
		turret_scan_start_sound_ent playloopsound ("mpl_turret_servo", 2);
		wait( 0.5 );
	}
}

TurretScanStopWaiter(ent)
{
//	self endon( "turret_deactivated" );
//	self endon( "death" );
	self endon( "turret_sound_cleanup" );
	level endon( "game_ended" );

	while(1)
	{
		//println ("snd scan stop");	
		self waittill( "turret_scan_stop" );

		ent playsound ("mpl_turret_servo_stop");
		
		//println ("snd scan stopping");	
		ent StopLoopSound( 0.5 );

		wait( 0.5 );

	}
}
TurretScanStopWaiterCleanup(ent)
{
	level endon( "game_ended" );
	
	self waittill_any( "death", "disconnect", "turret_deactivated" );
	
	self notify ("turret_sound_cleanup");
	
	wait .1;
	if ( isdefined (ent))
		ent delete();
	
}
turretScanStopNotify()
{
	
}		
///////////////////////////////////////////////////////
//		Turret Debug Functions
///////////////////////////////////////////////////////
turret_debug_box( origin, mins, maxs, color )
{
/#
	debug_turret = GetDvar( "debug_turret" );
	if ( debug_turret == "1" )
	{
		box( origin, mins, maxs, 0, color, 1, 1, 300 );
	}
#/
}

turret_debug_line( start, end, color )
{
/#
	debug_turret = GetDvar( "debug_turret" );
	if ( debug_turret == "1" )
	{
			line(start, end, color, 1, 1, 300);
	}
#/
}

set_difficulty( difficulty )
{
	init_turret_difficulty_settings();

	turrets = GetEntArray( "misc_turret", "classname" ); 

	for( index = 0; index < turrets.size; index++ )
	{
		if( IsDefined( turrets[index].script_skilloverride ) )
		{
			switch( turrets[index].script_skilloverride )
			{
			case "easy":
				difficulty = "easy"; 
				break; 
			case "medium":
				difficulty = "medium"; 
				break; 
			case "hard":
				difficulty = "hard"; 
				break; 
			case "fu":
				difficulty = "fu"; 
				break; 
			default:
				continue; 
			}
		}
		turret_set_difficulty( turrets[index], difficulty ); 
	}
}

init_turret_difficulty_settings()
{
	level.mgTurretSettings["easy"]["convergenceTime"] = 2.5; 
	level.mgTurretSettings["easy"]["suppressionTime"] = 3.0; 
	level.mgTurretSettings["easy"]["accuracy"] = 0.38; 
	level.mgTurretSettings["easy"]["aiSpread"] = 2; 
	level.mgTurretSettings["easy"]["playerSpread"] = 0.5; 	

	level.mgTurretSettings["medium"]["convergenceTime"] = 1.5; 
	level.mgTurretSettings["medium"]["suppressionTime"] = 3.0; 
	level.mgTurretSettings["medium"]["accuracy"] = 0.38; 
	level.mgTurretSettings["medium"]["aiSpread"] = 2; 
	level.mgTurretSettings["medium"]["playerSpread"] = 0.5; 	

	level.mgTurretSettings["hard"]["convergenceTime"] = .8; 
	level.mgTurretSettings["hard"]["suppressionTime"] = 3.0; 
	level.mgTurretSettings["hard"]["accuracy"] = 0.38; 
	level.mgTurretSettings["hard"]["aiSpread"] = 2; 
	level.mgTurretSettings["hard"]["playerSpread"] = 0.5; 	

	level.mgTurretSettings["fu"]["convergenceTime"] = .4; 
	level.mgTurretSettings["fu"]["suppressionTime"] = 3.0; 
	level.mgTurretSettings["fu"]["accuracy"] = 0.38; 
	level.mgTurretSettings["fu"]["aiSpread"] = 2; 
	level.mgTurretSettings["fu"]["playerSpread"] = 0.5; 	
}

turret_set_difficulty( turret, difficulty )
{
	turret.convergenceTime = level.mgTurretSettings[difficulty]["convergenceTime"]; 
	turret.suppressionTime = level.mgTurretSettings[difficulty]["suppressionTime"]; 
	turret.accuracy = level.mgTurretSettings[difficulty]["accuracy"]; 
	turret.aiSpread = level.mgTurretSettings[difficulty]["aiSpread"]; 
	turret.playerSpread = level.mgTurretSettings[difficulty]["playerSpread"]; 	
}

turret_suppression_fire( targets ) // self == turret
{
	self endon( "death" ); 
	self endon( "stop_suppression_fire" ); 
	if( !IsDefined( self.suppresionFire ) )
	{
		self.suppresionFire = true; 
	}

	for( ;; )
	{
		while( self.suppresionFire )
		{
			self SetTargetEntity( targets[RandomInt( targets.size )] ); 
			wait( 2 + RandomFloat( 2 ) ); 
		}

		self ClearTargetEntity(); 
		while( !self.suppresionFire )
		{
			wait( 1 ); 
		}
	}
}

// returns a time frame for the burst fire depending on the setting parameter
burst_fire_settings( setting )
{
	if( setting == "delay" )
	{
		return 0.2; 
	}
	else if( setting == "delay_range" )
	{
		return 0.5; 
	}
	else if( setting == "burst" )
	{
		return 0.5; 
	}
	else if( setting == "burst_range" )
	{
		return 4; 
	}
}

// makes the turret burst fire with delays in between
burst_fire( turret, manual_target )
{
	turret endon( "death" ); // MikeD: Incase we delete the turret.
	turret endon( "stopfiring" ); 
	self endon( "stop_using_built_in_burst_fire" ); 


	if( IsDefined( turret.script_delay_min ) )
	{
		turret_delay = turret.script_delay_min; 
	}
	else
	{
		turret_delay = burst_fire_settings( "delay" ); 
	}

	if( IsDefined( turret.script_delay_max ) ) 
	{
		turret_delay_range = turret.script_delay_max - turret_delay; 
	}
	else
	{
		turret_delay_range = burst_fire_settings( "delay_range" ); 
	}

	if( IsDefined( turret.script_burst_min ) )
	{
		turret_burst = turret.script_burst_min; 
	}
	else
	{
		turret_burst = burst_fire_settings( "burst" ); 
	}

	if( IsDefined( turret.script_burst_max ) ) 
	{
		turret_burst_range = turret.script_burst_max - turret_burst; 
	}
	else
	{
		turret_burst_range = burst_fire_settings( "burst_range" ); 
	}

	while( 1 )
	{	
		turret StartFiring(); 
		


		if( IsDefined( manual_target ) )
		{
			turret thread random_spread( manual_target ); 
		}
		turret do_shoot();

		wait( turret_burst + RandomFloat( turret_burst_range ) ); 

		turret StopShootTurret();

		turret StopFiring(); 

		wait( turret_delay + RandomFloat( turret_delay_range ) ); 
	}
}

// auto targeting and burst firing at the targets
burst_fire_unmanned() // self == turret
{
	self notify( "stop_burst_fire_unmanned" );
	self endon( "stop_burst_fire_unmanned" );
	self endon( "death" ); 
	level endon( "game_ended" );

	if( IsDefined( self.script_delay_min ) )
	{
		turret_delay = self.script_delay_min; 
	}
	else
	{
		turret_delay = burst_fire_settings( "delay" ); 
	}

	if( IsDefined( self.script_delay_max ) ) 
	{
		turret_delay_range = self.script_delay_max - turret_delay; 
	}
	else
	{
		turret_delay_range = burst_fire_settings( "delay_range" ); 
	}

	if( IsDefined( self.script_burst_min ) )
	{
		turret_burst = self.script_burst_min; 
	}
	else
	{
		turret_burst = burst_fire_settings( "burst" ); 
	}

	if( IsDefined( self.script_burst_max ) ) 
	{
		turret_burst_range = self.script_burst_max - turret_burst; 
	}
	else
	{
		turret_burst_range = burst_fire_settings( "burst_range" ); 
	}

	pauseUntilTime = GetTime(); 
	turretState = "start";
	// SRS 05/02/07 - added this for link_turrets() so we can accurately tell when the function is
	//  actually firing or just waiting between bursts (IsFiringTurret() returns true the whole time)
	self.script_shooting = false;

	for( ;; )
	{
		if( IsDefined( self.manual_targets ) )
		{
			self ClearTargetEntity();
			self SetTargetEntity( self.manual_targets[RandomInt( self.manual_targets.size )] );
		}

		duration = ( pauseUntilTime - GetTime() ) * 0.001; 
		if( self IsFiringTurret() && (duration <= 0) )
		{
			if( turretState != "fire" )
			{
				turretState = "fire";
				self playsound ("mpl_turret_alert"); // Play a state change sound CDC						

				self thread do_shoot();
				self.script_shooting = true;
			}

			duration = turret_burst + RandomFloat( turret_burst_range ); 

			//println( "fire duration: ", duration ); 
			self thread turret_timer( duration );

			self waittill( "turretstatechange" ); // code or script

			self.script_shooting = false;

			duration = turret_delay + RandomFloat( turret_delay_range ); 
			//println( "stop fire duration: ", duration ); 

			pauseUntilTime = GetTime() + Int( duration * 1000 ); 
		}
		else
		{
			if( turretState != "aim" )
			{
				turretState = "aim"; 
			}

			//println( "aim duration: ", duration ); 
			self thread turret_timer( duration );

			self waittill( "turretstatechange" ); // code or script
		}
	}
}

do_shoot()
{
	self endon( "death" ); 
	self endon( "turretstatechange" ); // code or script

	for( ;; )
	{
		self ShootTurret();
		wait( 0.112 ); 
	}
}

// waits for a duration and sends a turret state change notify
turret_timer( duration )
{
	if( duration <= 0 )
	{
		return; 
	}

	self endon( "turretstatechange" ); // code

	//println( "start turret timer" ); 

	wait( duration ); 
	if( IsDefined( self ) )
	{
		self notify( "turretstatechange" ); 
	}

	//println( "end turret timer" ); 
}

random_spread( ent )
{
	self endon( "death" ); 

	self notify( "stop random_spread" ); 
	self endon( "stop random_spread" ); 

	self endon( "stopfiring" ); 
	self SetTargetEntity( ent ); 

	self.manual_target = ent;

	while( 1 )
	{

		// SCRIPTER_MOD
		// MikeD( 3/21/2007 ): No more level.player
		//		if( ent == level.player )
		//			ent.origin = self.manual_target GetOrigin(); 
		//		else
		//			ent.origin = self.manual_target.origin; 

		if( IsPlayer( ent ) )
		{
			ent.origin = self.manual_target GetOrigin(); 
		}
		else
		{
			ent.origin = self.manual_target.origin; 
		}

		ent.origin += ( 20 - RandomFloat( 40 ), 20 - RandomFloat( 40 ), 20 - RandomFloat( 60 ) ); 
		wait( 0.2 ); 
	}
}