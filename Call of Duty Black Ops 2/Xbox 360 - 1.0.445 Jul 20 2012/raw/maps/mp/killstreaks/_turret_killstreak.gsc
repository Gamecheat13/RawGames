#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_weapons;

#insert raw\maps\mp\_clientflags.gsh;

#using_animtree ( "mp_microwaveturret" );

//AUTO_TURRET_TIMEOUT = 90.0;
///////////////////////////////////////////////////////
//		Turret Initialization Functions
///////////////////////////////////////////////////////
init()
{
	precacheturret( "auto_gun_turret_mp" );
	precacheturret( "microwave_turret_mp" );
	PrecacheModel( "t6_wpn_turret_sentry_gun" );
	PrecacheModel( "t6_wpn_turret_sentry_gun_yellow" );
	PrecacheModel( "t6_wpn_turret_sentry_gun_red" );
	PrecacheModel( "t6_wpn_turret_ads_world" );
	PrecacheModel( "t6_wpn_turret_ads_carry" );
	PrecacheModel( "t6_wpn_turret_ads_carry_animate" );
	PrecacheModel( "t6_wpn_turret_ads_carry_animate_red" );
	PrecacheModel( "t6_wpn_turret_ads_carry_red" );
	PrecacheShellShock( "mp_radiation_high" );
	PrecacheShellShock( "mp_radiation_med" );
	PrecacheShellShock( "mp_radiation_low" );
	PrecacheItem( "killstreak_remote_turret_mp" );
	thread maps\mp\_mgturret::init_turret_difficulty_settings();
	level.auto_turret_timeout = 120.0;
	level.microwave_radius = 750;
	level.microwave_turret_cone_dot = cos( 45 );
	level.microwave_turret_angle = 90;
	level.microwave_turret_damage = 10;
	flag_init("end_target_confirm");
	level.auto_turret_settings = [];
	
	level.microwaveOpenAnim = %o_hpm_open;
	level.microwaveCloseAnim = %o_hpm_close;
	level.microwaveDestroyedAnim = %o_hpm_destroyed;

	level.auto_turret_settings["sentry"] = spawnStruct();
	level.auto_turret_settings["sentry"].hintString = &"KILLSTREAK_SENTRY_TURRET_PICKUP";
	level.auto_turret_settings["sentry"].hackerHintString = &"KILLSTREAK_TURRET_HACKING";
	level.auto_turret_settings["sentry"].disableHintString = &"KILLSTREAK_TURRET_SENTRY_DISABLE";
	level.auto_turret_settings["sentry"].hintIcon = "hud_ks_auto_turret";
	level.auto_turret_settings["sentry"].modelBase = "t6_wpn_turret_sentry_gun";
	level.auto_turret_settings["sentry"].modelGoodPlacement = "t6_wpn_turret_sentry_gun_yellow";
	level.auto_turret_settings["sentry"].modelBadPlacement = "t6_wpn_turret_sentry_gun_red";
	level.auto_turret_settings["sentry"].stunFX = loadfx("weapon/sentry_gun/fx_sentry_gun_emp_stun");
	level.auto_turret_settings["sentry"].stunFXTag = "tag_origin";
	level.auto_turret_settings["sentry"].damageFX = loadfx("weapon/sentry_gun/fx_sentry_gun_damage_state");
	level.auto_turret_settings["sentry"].disableFX = loadfx("weapon/sentry_gun/fx_sentry_gun_death_state");
	level.auto_turret_settings["sentry"].explodeFX = loadfx("weapon/sentry_gun/fx_sentry_gun_exp");	
	level.auto_turret_settings["sentry"].laserFX = loadfx("weapon/sentry_gun/fx_sentry_gun_laser");
	level.auto_turret_settings["sentry"].stunFXFrequencyMin = 0.1;
	level.auto_turret_settings["sentry"].stunFXFrequencyMax = 0.75;
	level.auto_turret_settings["sentry"].turretInitDelay = 3.0;

	level.auto_turret_settings["tow"] = spawnStruct();
	level.auto_turret_settings["tow"].hintString = &"KILLSTREAK_TOW_TURRET_PICKUP";
	level.auto_turret_settings["tow"].hackerHintString = &"KILLSTREAK_TURRET_HACKING";
	level.auto_turret_settings["tow"].hintIcon = "hud_ks_sam_turret";
	level.auto_turret_settings["tow"].modelBase = "t6_wpn_turret_sam";
	level.auto_turret_settings["tow"].modelGoodPlacement = "t6_wpn_turret_sam_yellow";
	level.auto_turret_settings["tow"].modelBadPlacement = "t6_wpn_turret_sam_red";
	level.auto_turret_settings["tow"].stunFX = loadfx("weapon/grenade/fx_spark_disabled_weapon_lg");
	level.auto_turret_settings["tow"].stunFXTag = "TAG_aim";
	level.auto_turret_settings["tow"].stunFXFrequencyMin = 0.1;
	level.auto_turret_settings["tow"].stunFXFrequencyMax = 0.75;
	level.auto_turret_settings["tow"].turretInitDelay = 3.0;
	level.auto_turret_settings["tow"].turretFireDelay = 5.0;
	
	level.auto_turret_settings["microwave"] = spawnStruct();
	level.auto_turret_settings["microwave"].hintString = &"KILLSTREAK_MICROWAVE_TURRET_PICKUP";
	level.auto_turret_settings["microwave"].hackerHintString = &"KILLSTREAK_TURRET_MICROWAVE_HACKING";
	level.auto_turret_settings["microwave"].disableHintString = &"KILLSTREAK_TURRET_MICROWAVE_DISABLE";
	level.auto_turret_settings["microwave"].hintIcon = "hud_ks_microwave_turret";
	level.auto_turret_settings["microwave"].modelBase = "t6_wpn_turret_ads_world";
	level.auto_turret_settings["microwave"].modelGoodPlacement = "t6_wpn_turret_ads_carry";
	level.auto_turret_settings["microwave"].modelGoodPlacementAnimate = "t6_wpn_turret_ads_carry_animate";
	level.auto_turret_settings["microwave"].modelBadPlacementAnimate = "t6_wpn_turret_ads_carry_animate_red";
	level.auto_turret_settings["microwave"].modelBadPlacement = "t6_wpn_turret_ads_carry_red";
	level.auto_turret_settings["microwave"].stunFX = loadfx("weapon/silent_gaurdian/fx_sg_emp_stun");
	level.auto_turret_settings["microwave"].loopSoundFX = "wpn_sguard_beam";
	level.auto_turret_settings["microwave"].stunFXTag = "tag_origin";
	level.auto_turret_settings["microwave"].damageFX = loadfx("weapon/silent_gaurdian/fx_sg_damage_state");
	level.auto_turret_settings["microwave"].disableFX = loadfx("weapon/silent_gaurdian/fx_sg_death_state");
	level.auto_turret_settings["microwave"].explodeFX = loadfx("weapon/silent_gaurdian/fx_sg_exp");	
	level.auto_turret_settings["microwave"].stunFXFrequencyMin = 0.1;
	level.auto_turret_settings["microwave"].stunFXFrequencyMax = 0.75;
	level.auto_turret_settings["microwave"].turretInitDelay = 2.0;
	level.auto_turret_settings["microwave"].timeout = 240.0;
	level.auto_turret_settings["microwave"].fxchecktime = 5.0;
	
	level.auto_turret_settings["microwave"].microwave_radius_1 = Int( level.microwave_radius / 8 );
	level.auto_turret_settings["microwave"].microwave_radius_2 = Int( level.microwave_radius / 2 );
	level.auto_turret_settings["microwave"].microwave_radius_3 = Int( level.microwave_radius * 3 / 4 );
	level.auto_turret_settings["microwave"].microwave_radius_4 = Int( level.microwave_radius );
	level.auto_turret_settings["microwave"].fx = [];
	level.auto_turret_settings["microwave"].fx[level.auto_turret_settings["microwave"].microwave_radius_1] = loadfx("weapon/silent_gaurdian/fx_sg_distortion_cone_a");
	level.auto_turret_settings["microwave"].fx[level.auto_turret_settings["microwave"].microwave_radius_2] = loadfx("weapon/silent_gaurdian/fx_sg_distortion_cone_b");
	level.auto_turret_settings["microwave"].fx[level.auto_turret_settings["microwave"].microwave_radius_3] = loadfx("weapon/silent_gaurdian/fx_sg_distortion_cone_c");
	level.auto_turret_settings["microwave"].fx[level.auto_turret_settings["microwave"].microwave_radius_4] = loadfx("weapon/silent_gaurdian/fx_sg_distortion_cone_d");

	level._turret_explode_fx = loadfx( "explosions/fx_exp_equipment_lg" );

	//Used later to check if turret is in trigger_hurt's or minefields
	minefields = GetEntarray( "minefield", "targetname" );
	hurt_triggers = GetEntArray( "trigger_hurt","classname" );
	level.fatal_triggers = ArrayCombine( minefields, hurt_triggers, true, false );
	level.noTurretPlacementTriggers = getEntArray( "no_turret_placement", "targetname" );

	// register the auto turret hardpoint
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "allowauto_turret" ) )
	{
		//Sentry version
		maps\mp\killstreaks\_killstreaks::registerKillstreak("autoturret_mp", "autoturret_mp", "killstreak_auto_turret", "auto_turret_used", ::useSentryTurretKillstreak );
		maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon( "autoturret_mp", "auto_gun_turret_mp" );
		maps\mp\killstreaks\_killstreaks::registerKillstreakRemoteOverrideWeapon( "autoturret_mp", "killstreak_remote_turret_mp" );
		maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("autoturret_mp", &"KILLSTREAK_EARNED_AUTO_TURRET", &"KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("autoturret_mp", "mpl_killstreak_auto_turret", "kls_turret_used", "","kls_turret_enemy", "", "kls_turret_ready");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("autoturret_mp", "scr_giveautoturret");

		maps\mp\killstreaks\_killstreaks::registerKillstreak("turret_drop_mp", "turret_drop_mp", "killstreak_auto_turret_drop", "auto_turret_used", ::useKillstreakTurretDrop, undefined, true );
		maps\mp\killstreaks\_killstreaks::registerKillstreakRemoteOverrideWeapon( "turret_drop_mp", "killstreak_remote_turret_mp" );
		maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("turret_drop_mp", &"KILLSTREAK_EARNED_AUTO_TURRET", &"KILLSTREAK_AIRSPACE_FULL");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("turret_drop_mp", "mpl_killstreak_turret", "kls_turret_used", "","kls_turret_enemy", "", "kls_turret_ready");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("turret_drop_mp", "scr_giveautoturretdrop");

		maps\mp\killstreaks\_supplydrop::registerCrateType( "turret_drop_mp", "killstreak", "autoturret_mp", 1, &"KILLSTREAK_AUTO_TURRET_CRATE", undefined, "MEDAL_SHARE_PACKAGE_AUTO_TURRET", maps\mp\killstreaks\_supplydrop::giveCrateKillstreak );
		level.killStreakIcons["autoturret_mp"] = "hud_ks_auto_turret";

		// Microwave version
		maps\mp\killstreaks\_killstreaks::registerKillstreak("microwaveturret_mp", "microwaveturret_mp", "killstreak_microwave_turret", "microwave_turret_used", ::useMicrowaveTurretKillstreak );
		maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon( "microwaveturret_mp", "microwave_turret_mp" );
		maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon( "microwaveturret_mp", "microwave_turret_damage_mp" );
		maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("microwaveturret_mp", &"KILLSTREAK_EARNED_MICROWAVE_TURRET", &"KILLSTREAK_MICROWAVE_TURRET_NOT_AVAILABLE");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("microwaveturret_mp", "mpl_killstreak_auto_turret", "kls_microwave_used", "","kls_microwave_enemy", "", "kls_microwave_ready");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("microwaveturret_mp", "scr_givemicrowaveturret");

		maps\mp\killstreaks\_killstreaks::registerKillstreak("microwaveturret_drop_mp", "microwaveturret_drop_mp", "killstreak_microwave_turret_drop", "microwave_turret_used", ::useKillstreakTurretDrop, undefined, true );
		maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("microwaveturret_drop_mp", &"KILLSTREAK_EARNED_MICROWAVE_TURRET", &"KILLSTREAK_AIRSPACE_FULL");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("microwaveturret_drop_mp", "mpl_killstreak_turret", "kls_microwave_used", "","kls_microwave_enemy", "", "kls_microwave_ready");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("microwaveturret_drop_mp", "scr_givemicrowaveturretdrop");

		maps\mp\killstreaks\_supplydrop::registerCrateType( "microwaveturret_drop_mp", "killstreak", "microwaveturret_mp", 1, &"KILLSTREAK_MICROWAVE_TURRET_CRATE", undefined, "MEDAL_SHARE_PACKAGE_MICROWAVE_TURRET", maps\mp\killstreaks\_supplydrop::giveCrateKillstreak );
		level.killStreakIcons["microwaveturret_mp"] = "hud_ks_microwave_turret";
	}

	level.turrets_headicon_offset = [];
	level.turrets_headicon_offset["default"] = (0, 0, 70); 
	level.turrets_headicon_offset["sentry"] = (0, 0, 70); 
	level.turrets_headicon_offset["tow"] = (0, 0, 65); 
	level.turrets_headicon_offset["microwave"] = (0, 0, 80); 

	level.turrets_hacker_trigger_width = 72; 
	level.turrets_hacker_trigger_height = 96; 
	SetDvar("scr_turret_no_timeout", 0);
}

///////////////////////////////////////////////////////
//		Turret Supply Drop Functions
///////////////////////////////////////////////////////
useKillstreakTurretDrop(hardpointType)
{
	if( self maps\mp\killstreaks\_supplydrop::isSupplyDropGrenadeAllowed(hardpointType) == false )
		return false;
	
	result = self maps\mp\killstreaks\_supplydrop::useSupplyDropMarker();
	
	self notify( "supply_drop_marker_done" );

	if ( !IsDefined(result) || !result )
	{
		return false;
	}

	return result;
}

useSentryTurretKillstreak( hardpointType )
{
	if ( self maps\mp\killstreaks\_killstreaks::isInteractingWithObject() )
		return false;
		
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( hardpointType, self.team );
	if (  killstreak_id == -1 )
		return false;

	turret = self useSentryTurret( hardpointType );
	turret.killstreak_id = killstreak_id;

	event = turret waittill_any_return( "turret_placed", "destroy_turret" );
	if ( event == "turret_placed" )
	{
		return true;
	}

	return false;
}

useTowTurretKillstreak( hardpointType )
{
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( hardpointType, self.team );
	if (  killstreak_id == -1 )
		return false;

	turret = self useTowTurret( hardpointType );
	turret.killstreak_id = killstreak_id;

	event = turret waittill_any_return( "turret_placed", "destroy_turret" );
	if ( event == "turret_placed" )
	{
		return true;
	}

	return false;
}

useMicrowaveTurretKillstreak( hardpointType )
{
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	if ( self maps\mp\killstreaks\_killstreaks::isInteractingWithObject() )
		return false;
	
	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( hardpointType, self.team );
	if (  killstreak_id == -1 )
		return false;

	turret = self useMicrowaveTurret( hardpointType );
	turret.killstreak_id = killstreak_id;

	event = turret waittill_any_return( "turret_placed", "destroy_turret" );
	if ( event == "turret_placed" )
	{
		return true;
	}

	return false;
}

useSentryTurret( hardpointType )
{
	self maps\mp\killstreaks\_killstreaks::switchToLastNonKillstreakWeapon();

	if( ( !IsDefined( level.usingMomentum ) || !level.usingMomentum ) && !self maps\mp\killstreaks\_killstreaks::getIfTopKillstreakHasBeenUsed() )
	{
		//self AddPlayerStat( "AUTO_TURRET_USED", 1 );
		level.globalKillstreaksCalled++;
		self AddWeaponStat( hardpointType, "used", 1 );
	}

	//Spawn a turret at this location 
	turret = spawnTurret( "auto_turret", self.origin, "auto_gun_turret_mp" );
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
	turret SetTurretOwner( self );
	turret SetTurretMinimapVisible( true );
	turret.isFromInventory = self.usingKillstreakFromInventory;
	turret SetDrawInfrared( true );
	Target_Set( turret, (0,0,40) );
	
	turret.killCamEntAI = Spawn( "script_model", turret.origin + ( AnglesToForward( turret.angles ) * -120 ) + ( 0, 0, 75 ) );
	turret.killCamEntAI.angles = turret.angles;
	turret.killCamEntAI LinkTo( turret, "tag_aim_pitch" );
	turret.killCamEnt = turret.killCamEntAI;

	turret.controlled = false;
	//set up number for this turret
	if (!isDefined(self.numTurrets))
		self.numTurrets=1;
	else
		self.numTurrets++;
	turret.ownerNumber = self.numTurrets;
	
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
	
	return turret;
}

useTowTurret( hardpointType )
{
	self maps\mp\killstreaks\_killstreaks::switchToLastNonKillstreakWeapon();
	
	if( ( !IsDefined( level.usingMomentum ) || !level.usingMomentum ) && !self maps\mp\killstreaks\_killstreaks::getIfTopKillstreakHasBeenUsed() )
	{
		level.globalKillstreaksCalled++;
		self AddWeaponStat( hardpointType, "used", 1 );
	}
	
	//Spawn a turret at this location 
	turret = spawnTurret( "auto_turret", self.origin, "tow_turret_mp" );
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

	turret SetTurretOwner( self );
	turret SetTurretMinimapVisible( true );
	turret.isFromInventory = self.usingKillstreakFromInventory;

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
	
	return turret;
}

useMicrowaveTurret( hardpointType )
{
	self maps\mp\killstreaks\_killstreaks::switchToLastNonKillstreakWeapon();
	
	if( ( !IsDefined( level.usingMomentum ) || !level.usingMomentum ) && !self maps\mp\killstreaks\_killstreaks::getIfTopKillstreakHasBeenUsed() )
	{
		//self AddPlayerStat( "MICROWAVE_TURRET_USED", 1 );
		level.globalKillstreaksCalled++;
		self AddWeaponStat( hardpointType, "used", 1 );
	}

	//Spawn a turret at this location 
	turret = spawnTurret( "auto_turret", self.origin, "microwave_turret_mp" );
	turret.turretType = "microwave";
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
	turret SetTurretOwner( self );
	turret SetTurretMinimapVisible( true );
	turret.isFromInventory = self.usingKillstreakFromInventory;
	turret SetDrawInfrared( true );
	turret.controlled = false;
	turret.soundMod = "hpm";	
	Target_Set( turret, (0,0,30) );

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

	return turret;	
}

///////////////////////////////////////////////////////
//		Turret Owner Functions
///////////////////////////////////////////////////////

watchRoundAndGameEnd( turret )
{
	self endon("disconnect");
	turret notify("watchRoundAndGameEnd");
	turret endon("watchRoundAndGameEnd");
	turret endon("destroy_turret");
	turret endon("hacked");
	turret endon("death");

	//Destroy the turret if we are still carrying it at round or game end.
	level waittill( "game_ended" );
	
	self stopCarryTurret( turret );
	turret notify( "destroy_turret", false );
}

giveTurretBack( turret )
{
	if ( !IsDefined( level.usingMomentum ) || !level.usingMomentum || 
	    ( IsDefined( turret.isFromInventory ) && turret.isFromInventory ) )
	{
		maps\mp\killstreaks\_killstreaks::giveKillstreak( turret.hardPointWeapon, undefined, undefined, true );
	}
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
		self returnTurretToInventory( turret );
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

returnTurretToInventory( turret )
{
	//Check for player changing teams
		if( self.team != turret.team )
		{
			self stopCarryTurret( turret );
			turret notify( "destroy_turret", false );
		}
		else
		{
			//giveTurretBack( turret );
			turret setTurretCarried( false );
			self stopCarryTurret( turret );
			self _enableWeapon();
			turret notify( "destroy_turret", false );
		}
}

watchOwnerEMP( turret )
{
	self endon("disconnect");
	self endon("death");
	turret endon("turret_placed");
	turret endon("destroy_turret");
	turret endon("hacked");

	while(1)
	{
		self waittill("emp_jammed");

		if( !turret.hasBeenPlanted )
		{
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
	turret stoploopsound();
	turret SetMode( "auto_ai" );

	if( turret.turretType == "sentry" )
	{
		turret notify( "stop_burst_fire_unmanned" );
	}
	else if( turret.turretType == "tow" )
	{
		turret notify( "target_lost" );
	}
	else if ( turret.turretType == "microwave" )
	{
		turret notify( "stop_microwave" );
	}
	turret.carried = true;

	//Drop any ballistic knives that may be attached to the turret.
	if( turret.hasBeenPlanted )
		level notify( "drop_objects_to_ground", turret.origin, 80 );

	self CarryTurret( turret, (40,0,0), (0,0,0) );

	self thread watchOwnerDeath( turret );
	self thread watchOwnerEMP( turret );
	self thread watchRoundAndGameEnd( turret );
	turret maps\mp\_entityheadicons::destroyEntityHeadIcons();
	turret SetTurretOwner( self );
	turret SetDefaultDropPitch(-90.0);

	if( !turret.hasBeenPlanted )
		self thread watchReturnTurretToInventory( turret );

	//Watch turret placement
	self thread updateTurretPlacement( turret );
	self thread watchTurretPlacement( turret );

	if ( turret.turretType == "microwave" )
	{
		turret clearClientFlag( CLIENT_FLAG_MICROWAVE_OPEN );	
		turret SetClientFlag( CLIENT_FLAG_MICROWAVE_CLOSE );
		self playsoundtoplayer ( "mpl_turret_micro_startup", self );
		
	}
	//Ensure pickup trigger is cleaned up
	turret notify( "turret_carried" );
}

watchReturnTurretToInventory( turret )
{
  self endon( "death" );
  self endon( "entering_last_stand" );
  self endon( "disconnect" );
  turret endon( "turret_placed" );
  turret endon( "turret_deactivated" );

  while( 1 )
  {
	  if( self actionSlotFourButtonPressed() )
	  {
		  returnTurretToInventory( turret );
	  }

	  wait( 0.05 );
  }
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
  firstModel = true;

	while( 1 )
	{
		placement = self canPlayerPlaceTurret();

		turret.origin = placement["origin"];
		turret.angles = placement["angles"];
		//'good_spot_check' is only true if the placement result returns true and the turret in hurt trigger returns false
		good_spot_check = placement["result"] & !(turret turretInHurtTrigger());
		good_spot_check = placement["result"] & !(turret turretInNoTurretPlacementTrigger());
		turret.canBePlaced = good_spot_check;
		
		if( turret.canBePlaced != lastPlacedTurret && !(turret.turretType == "microwave" && firstModel == true))
		{
			if( good_spot_check )
				turret SetModel( level.auto_turret_settings[turret.turretType].modelGoodPlacement );
			else
				turret SetModel( level.auto_turret_settings[turret.turretType].modelBadPlacement );
			
			lastPlacedTurret = turret.canBePlaced;
		}
		
		if( turret.turretType == "microwave" && firstModel == true)
		{		
			if ( turret.canBePlaced )
			{
				turret SetModel( level.auto_turret_settings[turret.turretType].modelGoodPlacementAnimate );	
			}
			else
			{
				turret SetModel( level.auto_turret_settings[turret.turretType].modelBadPlacementAnimate );	
			}
			firstModel = false;
			lastPlacedTurret = turret.canBePlaced;
		}

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

	while( self AttackButtonPressed() )
	{
		wait (0.05);
	}
	while(1)
	{
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

placeTurret( turret )
{

	if( !turret.carried || !turret.canBePlaced )
		return;

	turret setTurretCarried( false );
	self stopCarryTurret( turret, turret.origin, turret.angles );
	turret spawnTurretPickUpTrigger( self );
	turret spawnTurretHackerTrigger( self );
	//turret spawnTurretDisableTrigger( self );
	self thread initTurret( turret );
	self _enableWeapon();
	turret.carried = false;
	turret.hasBeenPlanted = true;

	//turret thread watchScramble();

	//If turret was stunned before it was picked up, make it stunned again
	if( turret.stunnedByTacticalGrenade )
		turret thread stunTurretTacticalGrenade( turret.stunDuration );

	if ( isdefined( level.auto_turret_settings[turret.turretType].loopSoundFX ) )
		turret playloopsound ( level.auto_turret_settings[turret.turretType].loopSoundFX );
	
	// rumble on placement
	self PlayRumbleOnEntity( "damage_heavy" );

	turret notify("turret_placed");
}

///////////////////////////////////////////////////////
//		Turret Setup Functions
///////////////////////////////////////////////////////

initTurret( turret )
{
	maps\mp\_mgturret::turret_set_difficulty( turret, "fu" );
	turret SetModel( level.auto_turret_settings[turret.turretType].modelBase );
	if ( turret.turretType == "microwave" )
	{
		turret clearClientFlag( CLIENT_FLAG_MICROWAVE_CLOSE );
		turret SetClientFlag( CLIENT_FLAG_MICROWAVE_OPEN );	

	}
	turret SetForceNoCull();
	turret PlaySound ("mpl_turret_startup");
	
	if( level.teambased )
	{
		offset = level.turrets_headicon_offset[ "default" ];
		if( IsDefined( level.turrets_headicon_offset[ turret.turretType ] ) )
		{
			offset = level.turrets_headicon_offset[ turret.turretType ];
		}
		turret maps\mp\_entityheadicons::setEntityHeadIcon( self.pers["team"], self, offset );
	}

	//Make it automated
	turret maketurretunusable();
	turret SetMode( "auto_nonai" );
	turret SetTurretOwner( self );
	turret.owner = self;
	turret SetDefaultDropPitch(45.0);


	if( turret.turretType == "sentry" )
		turret thread turret_sentry_think( self );
	else if( turret.turretType == "tow" )
		turret thread turret_tow_think( self );
	else if ( turret.turretType == "microwave" )
		turret thread turret_microwave_think( self );

	turret.turret_active = true;

	// Create the spawn influencer	
	turret.spawninfluencerid = maps\mp\gametypes\_spawning::create_auto_turret_influencer( turret.origin, turret.team, turret.angles );
	
	//Track the turret's health
	turret thread watchDamage();
	turret thread checkForStunDamage();

	wait(1.0);
	flag_set("end_target_confirm");
}

setupTurretHealth( turret )
{
	turret.health = 100000;	
	turret.maxHealth = 1000;
	if (turret.turretType == "microwave" )
	{
		turret.maxHealth = 700;
	}
	turret.bulletDamageReduction = 0.4;
	turret.explosiveDamageReduction = 1.8;
}

///////////////////////////////////////////////////////
//		Turret Watcher Functions
///////////////////////////////////////////////////////
watchDamage()
{
	self endon( "turret_deactivated" );
	
	medalGiven = false;
	self.damageTaken = 0;
	low_health = false;
	
	for( ;; )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName  );

		if ( type == "MOD_CRUSH" )
		{
			self notify( "destroy_turret", false );
			return;
		}

		if( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;

		if( isPlayer( attacker ) && level.teambased && isDefined( attacker.team ) && self.team == attacker.team && level.friendlyfire == 0 )
			continue;

		// Microwave turret's shield blocks all damage (not working)
		if ( self.turretType == "microwave" && partName == "tag_shield" )
		{
			self.health += damage;
			continue;
		}
		else
		{
			if ( ( type == "MOD_PISTOL_BULLET" ) || ( type == "MOD_RIFLE_BULLET" ) || (type == "MOD_PROJECTILE_SPLASH" && isExplosiveBulletWeapon(weaponName)) )
			{
				if ( attacker HasPerk( "specialty_armorpiercing" ) )
					damage += int( damage * level.cac_armorpiercing_data );
	
				self.damageTaken += self.bulletDamageReduction * damage;
			}
			else if ( weaponName == "remote_missile_missile_mp" || weaponName == "remote_mortar_mp" || weaponName == "missile_drone_projectile_mp" )
			{
				self.damageTaken += damage * 10;	
			}
			else if ( type == "MOD_PROJECTILE" && ( weaponName == "smaw_mp" || weaponName == "fhj18_mp" ) )
			{
				self.damageTaken += 150 * self.explosiveDamageReduction;	
			}
			else if ( ( type == "MOD_PROJECTILE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_PROJECTILE_SPLASH" ) && damage != 0 && weaponName != "emp_grenade_mp" && !isExplosiveBulletWeapon(weaponName) )
			{
				self.damageTaken += self.explosiveDamageReduction * damage;
			}
			else if ( type == "MOD_MELEE" )
			{
				//self.damageTaken += self.maxHealth;
				if ( IsPlayer( attacker ) )
				{
					attacker playLocalSound( "fly_riotshield_impact_knife" );
				}
				continue;
			}
			else if ( IsDefined( weaponName ) && ( weaponName == "emp_grenade_mp" ) && (type == "MOD_GRENADE_SPLASH"))
			{
				self.damageTaken += self.maxHealth;
			}
			else
				self.damageTaken += damage;
		}

		// most equipment should be flash/concussion-able, so it'll disable for a short period of time
		// check to see if the equipment has been flashed/concussed and disable it (checking damage < 5 is a bad idea, so check the weapon name)
		// we're currently allowing the owner/teammate to flash their own
		if ( IsDefined( weaponName )  && type == "MOD_GRENADE_SPLASH")
		{
			// do damage feedback
			switch( weaponName )
			{
			//Updated stuns so that only EMP (not flash/concussion) will stun turrets
			case "emp_grenade_mp":
				if( !self.stunnedByTacticalGrenade )
				{
					self thread stunTurretTacticalGrenade( self.stunDuration );
				}

				// if we're not on the same team then show damage feedback
				if( level.teambased && self.owner.team != attacker.team )
				{
					if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
						attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( type );
				}
				// for ffa just make sure the owner isn't the same
				else if( !level.teambased && self.owner != attacker )
				{
					if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
						attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( type );
				}
				break;

			default:
				if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
					attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( type );
				break;
			}
		}
		else if( IsDefined( weaponName ) )
		{
			if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
				attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( type );	
		}

		if( self.damageTaken >= self.maxHealth )
		{
			// need to make sure you don't get a medal for killing your own and teammates don't get it while in hardcore
			doMedal = false;
			if( level.teambased && attacker != self.owner && attacker.team != self.owner.team )
			{
				// team based and the owner or the same team is not destroying it
				doMedal = true;
			}
			else if( !level.teambased && attacker != self.owner )
			{
				// not team based and the owner is not destroying it
				doMedal = true;
			}

			if( doMedal )
			{
				// per feedback we want to see a medal pop up even if killstreaks destroy stuff (SAM Turret shooting things down, etc.)
				if ( self.turretType == "sentry" )
				{
					maps\mp\_scoreevents::processScoreEvent( "destroyed_sentry_gun", attacker, self, weaponName );
				}
				else if ( self.turretType == "microwave" )
				{
					maps\mp\_scoreevents::processScoreEvent( "destroyed_microwave_turret", attacker, self, weaponName );
				}

				if ( medalGiven == false )
				{
					//if ( self.turretType == "sentry" )
					//{
					//	attacker maps\mp\_properks::destroyedSentryTurret();
					//}
					//attacker maps\mp\_properks::destroyedKillstreak();
					if ( isDefined( self.hardPointWeapon ) )
					{
						level.globalKillstreaksDestroyed++;
						attacker AddWeaponStat( self.hardPointWeapon, "destroyed", 1 );
					}
					medalGiven = true;
				}
			}

			//Inform the player that their turret was destroyed
			owner = self.owner;
			if(self.turretType == "sentry")
				owner maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "sentry_destroyed", "item_destroyed" );
			else if(self.turretType == "microwave")
				owner maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "microwave_destroyed", "item_destroyed" );

			self.damageTaken = self.health;
			self notify( "destroy_turret", true );
		}
				
		if ( !low_health && self.damageTaken > self.maxHealth / 1.8 )
		{
			PlayFXOnTag( level.auto_turret_settings[self.turretType].damageFX, self, level.auto_turret_settings[self.turretType].stunFxTag );
			low_health = true;
		}
	}

}

watchTurretLifespan( turret )
{

	self endon( "turret_deactivated" );
	self endon( "death" );	

	while(1)
	{
		 timeout = level.auto_turret_timeout;
		 if ( IsDefined( turret ) && IsDefined( level.auto_turret_settings[turret.turretType].timeout ) )
		 {
		 	timeout = level.auto_turret_settings[turret.turretType].timeout;
		 }
		 if( self.curr_time > timeout )
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
	shouldTimeout = GetDvar("scr_turret_no_timeout");
	if (shouldTimeout == "1")
	{
		return;
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

	if ( self maps\mp\gametypes\_weaponobjects::isStunned() )
	{
		return;
	}

	self.stunnedByTacticalGrenade = true;
	self thread stunTurretFx( duration, false, true );

	if (self.turretType == "microwave")
	{
		self clearClientFlag( CLIENT_FLAG_MICROWAVE_OPEN );
		self SetClientFlag( CLIENT_FLAG_MICROWAVE_CLOSE );
		self notify( "microwave_end_fx" );
	}
	
	if (isDefined(self.controlled) && self.controlled )
	{
		self.owner FreezeControls( true );
	}
	
	if (isDefined(self.owner.fullscreen_static))
	{	
		self.owner thread maps\mp\killstreaks\_remote_weapons::stunStaticFX( duration );
	}
	
	if( self.stunnedByTacticalGrenade  )
	{
		while( 1 )
		{
			if( self.stunTime >= duration )
				break;

			if( self.carried )
				return;

			self.stunTime += 0.1;
			wait( 0.1 );
		}
	}

	self.stunnedByTacticalGrenade = false;
	self.stunTime = 0.0;

	if (isDefined(self.controlled) && self.controlled )
	{
		self.owner FreezeControls( false );
	}

	if( !self.carried )
		self SetMode( "auto_nonai" );

	if( self.turretType != "tow" && !self.carried && !self.controlled )
		self thread maps\mp\_mgturret::burst_fire_unmanned();

	if( self.turretType == "microwave" && !self.carried)
	{
		self ClearClientFlag( CLIENT_FLAG_MICROWAVE_CLOSE );
		self SetClientFlag( CLIENT_FLAG_MICROWAVE_OPEN );
		wait( 0.5 );
		self thread microwave_fx();
	}

	self notify("turret_stun_ended");
}

stunTurret( duration, isDead, isEMP )
{
	self endon( "turret_deactivated" );

	self SetMode( "auto_ai" );
	self notify( "stop_burst_fire_unmanned" );
	self thread stunTurretFx( duration, isDead, isEMP );
	
	if (isDefined(self.controlled) && self.controlled )
	{
		self.owner FreezeControls( true );
	}
	
	if (self.turretType == "microwave")
	{
		self clearClientFlag( CLIENT_FLAG_MICROWAVE_OPEN );
		self SetClientFlag( CLIENT_FLAG_MICROWAVE_DESTROY );
	}
	
	if ( IsDefined( duration ) )
	{
		wait( duration );
	}
	else
	{
		return;
	}
	
	if (isDefined(self.controlled) && self.controlled )
	{
		self.owner FreezeControls( false );
	}
	
	if( !self.carried )
		self SetMode( "auto_nonai" );

	if( self.turretType != "tow" && !self.carried && !self.controlled )
		self thread maps\mp\_mgturret::burst_fire_unmanned();
	
	self notify("turret_stun_ended");
	level notify( "turret_stun_ended", self );
}

stunFxThink( fx )
{
	fx endon("death");
	self StopLoopSound();
	
	self waittill_any( "death", "turret_stun_ended", "turret_deactivated", "hacked", "turret_carried" );
	
	if ( isdefined( self ) ) 
	{
		if ( isdefined( level.auto_turret_settings[self.turretType].loopSoundFX ) )
			self playloopsound ( level.auto_turret_settings[self.turretType].loopSoundFX );
	}
	
	fx delete();
}

stunTurretFx( duration, isDead, isEMP )
{
	self endon( "turret_deactivated" );
	self endon( "death" );
	self endon( "turret_stun_ended" );

	origin = self GetTagOrigin( level.auto_turret_settings[self.turretType].stunFxTag );
 
	self.stun_fx = Spawn( "script_model", origin );
	self.stun_fx SetModel( "tag_origin" );
	self thread stunFxThink( self.stun_fx );
	wait ( 0.1 );
	
	self.stun_fx PlaySound ( "dst_disable_spark" );
	time = 0;
	while( time < duration )
	{
		if ( int(time * 10) % 20 == 0 )
		{
			if( isDefined(isDead) && isDead )
			{
				PlayFXOnTag( level.auto_turret_settings[self.turretType].disableFX, self.stun_fx, "tag_origin" );
			}
			if( isDefined(isEMP) && isEMP )
			{
				PlayFXOnTag( level.auto_turret_settings[self.turretType].stunFX, self.stun_fx, "tag_origin" );		
			}
		}
		wait ( 0.25 );
		time += 0.25;
	}
}

isStunWeapon( weapon )
{
	switch( weapon )
	{
	case "emp_grenade_mp":
		return true;
	default:
		return false;
	}
}

scramblerStun( stun )
{
	if ( stun )
	{
		self thread stunTurret( false, true );
	}
	else
	{
		self SetMode( "auto_nonai" );

		if( self.turretType != "tow" && !self.controlled )
			self thread maps\mp\_mgturret::burst_fire_unmanned();

		self notify("turret_stun_ended");
		level notify( "turret_stun_ended", self );
	}
}

watchScramble()
{
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
}

///////////////////////////////////////////////////////
//		Turret Destruction Functions
///////////////////////////////////////////////////////
destroyTurret()
{
	self waittill( "destroy_turret", playDeathAnim );
	self.dead = true;

	if( self.turretType == "sentry" )
	{
		maps\mp\killstreaks\_killstreakrules::killstreakStop( "autoturret_mp", self.team, self.killstreak_id );
		if( isDefined( self.owner ) && isDefined( self.owner.remoteWeapon ))
		{
			if ( self == self.owner.remoteWeapon )
			{
				self.owner notify( "remove_remote_weapon", true );
			}
		}
	}
	else if ( self.turretType == "tow" )
	{
		maps\mp\killstreaks\_killstreakrules::killstreakStop( "auto_tow_mp", self.team, self.killstreak_id );
	}
	else if ( self.turretType == "microwave" )
	{
		self notify ( "microwave_end_fx" );
		maps\mp\killstreaks\_killstreakrules::killstreakStop( "microwaveturret_mp", self.team, self.killstreak_id );
	}

	if ( isDefined(self.controlled) && self.controlled == true )
	{
		self.owner thread maps\mp\killstreaks\_remotemissile::staticEffect( 1.0 );
		self.owner destroy_remote_hud();	
	}
	
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
		self stunTurret( self.stunDuration, true, self.stunnedByTacticalGrenade );
	}

	//Drop any ballistic knives that may be attached to the turret.
	level notify( "drop_objects_to_ground", self.origin, 80 );
	
	if( isDefined( self.spawninfluencerid ) )
	{
		RemoveInfluencer( self.spawninfluencerid );
		self.spawninfluencerid = undefined;
	}

	self SetTurretMinimapVisible( false );
	
	wait( 0.1 );

	if( isdefined( self ) ) 
	{
		if( self.hasBeenPlanted )
		{
			PlayFX( level.auto_turret_settings[self.turretType].explodeFX, self.origin, self.angles );
			self playsound ("mpl_turret_exp");
		}

		if( self.carried && isDefined( self.owner ) )
		{
			self.owner _enableWeapon();
		}
		self Delete();
	}
}

//Delete the turret retrieve trigger
DeleteTurretUseTrigger()
{
	if( isDefined( self.pickUpTrigger ) )
		self.pickUpTrigger delete();
	if( isDefined( self.hackerTrigger ) )
	{
		if ( IsDefined( self.hackerTrigger.progressBar ) )
		{
			self.hackerTrigger.progressBar destroyElem();
			self.hackerTrigger.progressText destroyElem();
		}
		self.hackerTrigger delete();
	}
	if( isDefined( self.disableTrigger ) )
	{
		if ( IsDefined( self.disableTrigger.progressBar ) )
		{
			self.disableTrigger.progressBar destroyElem();
			self.disableTrigger.progressText destroyElem();
		}
		self.disableTrigger delete();
	}
}


///////////////////////////////////////////////////////
//		Turret Use Trigger Functions
///////////////////////////////////////////////////////

//Spawn a radius trigger so the player can retrieve their turret
spawnTurretPickUpTrigger( player )
{
	pos = self.origin + (0,0,15);
	self.pickUpTrigger = spawn( "trigger_radius_use", pos );
	
	if( self.turretType == "sentry" )
		self.pickUpTrigger SetCursorHint( "HINT_NOICON", "auto_gun_turret_mp" );
	else if ( self.turretType == "tow" )
		self.pickUpTrigger SetCursorHint( "HINT_NOICON", "tow_turret_mp" );
	else
		self.pickUpTrigger SetCursorHint( "HINT_NOICON", "microwave_turret_mp" );
	
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
			
		if ( player useButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed() && !player attackButtonPressed() && !( player maps\mp\killstreaks\_killstreaks::isInteractingWithObject() ) && !player IsRemoteControlling() )
		{
			// rumble on pickup
			if( isDefined( self.spawninfluencerid ) )				
			{
				RemoveInfluencer( self.spawninfluencerid );
				self.spawninfluencerid = undefined;
			}
			
			player PlayRumbleOnEntity( "damage_heavy" );
			self PlaySound ("mpl_turret_down");
			self DeleteTurretUseTrigger();			
			if (self.turretType == "microwave")
			{
				self notify ( "microwave_end_fx" );
			}

			if ( IsDefined( player.remoteWeapon ) && player.remoteWeapon == self )
			{
				player notify( "remove_remote_weapon", false );
			}

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
	self endon ( "destroy_turret" ); 
	//Wait for turret to get set and placed before allowing it to fire
	wait( level.auto_turret_settings[self.turretType].turretInitDelay );

	player maps\mp\killstreaks\_remote_weapons::initRemoteWeapon( self, "killstreak_remote_turret_mp");

	self thread maps\mp\_mgturret::burst_fire_unmanned();
	
	PlayFXOnTag( level.auto_turret_settings[self.turretType].laserFX, self, "tag_laser" );
}

turret_tow_think( player )
{
	self endon( "turret_deactivated" );
	self endon( "death" );
	player endon( "disconnect" );
	level endon( "game_ended" );

	turretState = "started";

	self thread missile_fired_notify();

	//Wait for turret to get set and placed before allowing it to fire
	wait( level.auto_turret_settings[self.turretType].turretInitDelay );

	while(1)
	{
		if( self IsFiringTurret() && turretState != "firing" )
		{
			turretState = "firing";
			self playsound ("mpl_turret_alert"); // Play a state change sound CDC			
			self thread do_tow_shoot(player);
		}
		else
		{
			self notify( "target_lost" );
			turretState = "scanning";
		}
		
		self waittill( "turretstatechange" ); // code or script

		self notify( "target_lost" );
	}
}

deleteTriggerOnParentDeath( trigger )
{
	self waittill( "death" );
	if ( IsDefined( trigger ) )
	{
		trigger delete();
	}
}

doesMicrowaveTurretAffectEntity( entity )
{
	if ( !IsAlive( entity ) )
		return false;
		
	if ( !IsPlayer( entity ) && !IsAi(entity))
		return false;
		
	if ( isdefined(self.carried) && self.carried )
		return false;
		
	if ( self maps\mp\gametypes\_weaponobjects::isStunned() )
		return false;
	
	if ( IsDefined( self.owner ) && entity == self.owner )
		return false;
	
	if ( !maps\mp\gametypes\_weaponobjects::friendlyFireCheck( self.owner, entity, 0 ) )
		return false;
	
	if ( DistanceSquared( entity.origin, self.origin ) > level.microwave_radius * level.microwave_radius )
		return false;
		
	entDirection = vectornormalize( entity.origin - self.origin );
	forward = anglesToForward( self.angles );
	dot = vectorDot( entDirection, forward );
	if ( dot < level.microwave_turret_cone_dot )
		return false;
	
	pitchDifference =  int( abs( vectortoangles(entDirection)[0] - self.angles[0])) % 360;
	if ( pitchDifference > 20 && pitchDifference < 340 )
		return false;
	
	if ( entity damageConeTrace( self.origin + (0,0,40), self ) <= 0 )
		return false;
	
	return true;
}

microwaveEntity( entity )
{
	entity endon( "disconnect" );
	
	entity.beingMicrowaved = true;
	entity.beingMicrowavedBy = self.owner;
	entity.microwaveEffect = 0;
	
	for ( ;; )
	{
		if ( !IsDefined( self ) || !self doesMicrowaveTurretAffectEntity( entity ))
		{
			if( !isDefined(entity))
			{
				return;
			}
			entity.beingMicrowaved = false;
			entity.beingMicrowavedBy = undefined;
			
			if ( IsDefined( entity.microwavePoisoning ) && entity.microwavePoisoning )
			{
				entity.microwavePoisoning = false;
			}
			return;
		}
		
		damage = level.microwave_turret_damage;
		
		if ( !IsAi(entity) && entity mayApplyScreenEffect() )
		{
			if ( !IsDefined( entity.microwavePoisoning ) || !entity.microwavePoisoning )
			{
				entity.microwavePoisoning = true;
				entity.microwaveEffect = 0;
			}
		}
		
		entity DoDamage(
			damage, // iDamage Integer specifying the amount of damage done
			self.origin, // vPoint The point the damage is from?
			self.owner, // eAttacker The entity that is attacking.
			self, // eInflictor The entity that causes the damage.(e.g. a turret)
			0, 
			"MOD_TRIGGER_HURT", // sMeansOfDeath Integer specifying the method of death
			0, // iDFlags Integer specifying flags that are to be applied to the damage
			"microwave_turret_mp" // sWeapon The weapon number of the weapon used to inflict the damage
		);
		
		entity.microwaveEffect++;
		
		if( IsPlayer(entity) && !(entity IsRemoteControlling()) )
		{
			if( entity.microwaveEffect % 2 == 1 )
			{
				if ( DistanceSquared( entity.origin, self.origin ) > (level.microwave_radius * 2/3) * (level.microwave_radius * 2/3) )
				{			    
					entity shellshock( "mp_radiation_low", 1.5 );
					entity ViewKick( 25, self.origin );
				}
				else if ( DistanceSquared( entity.origin, self.origin ) > (level.microwave_radius * 1/3) * (level.microwave_radius * 1/3) )
				{			    
					entity shellshock( "mp_radiation_med", 1.5 );
					entity ViewKick( 50, self.origin );
				}
				else
				{
					entity shellshock( "mp_radiation_high", 1.5 );
					entity ViewKick( 75, self.origin );
				}
			}
			if( entity.microwaveEffect % 4 == 0 )
			{
				maps\mp\_scoreevents::processScoreEvent( "hpm_suppress", self.owner, entity );
			}
		}
		
		wait 0.5;
	}
}

turret_microwave_think( player )
{
	self endon( "death" ); 
	level endon( "game_ended" );
	self endon( "stop_microwave" );
	self endon( "destroy_turret" );
		
	//Wait for turret to get set and placed before allowing it to fire
	wait( level.auto_turret_settings[self.turretType].turretInitDelay );
	
	// Create trigger
	trigger = spawn("trigger_radius", self.origin + (0,0,-level.microwave_radius), level.aiTriggerSpawnFlags | level.vehicleTriggerSpawnFlags, level.microwave_radius, level.microwave_radius*2);
	trigger EnableLinkTo();
	trigger LinkTo( self );

	self thread deleteTriggerOnParentDeath( trigger );

	self thread microwave_fx();

	for ( ;; )
	{
		trigger waittill( "trigger", ent );
		
		if ( !IsDefined( ent.beingMicrowaved ) || !ent.beingMicrowaved )
		{
			self thread microwaveEntity( ent );
		}
	}
}

microwave_fx()
{
	self endon( "death" );
	self endon( "microwave_end_fx" );
	
	self thread waitTillEndFX();
	waitAmount = level.auto_turret_settings["microwave"].fxchecktime;
	for ( ;; )
	{
		update_microwave_fx();
		wait( waitAmount );
	}
	
}

waitTillEndFX()
{
	self endon( "death" );
	self waittill( "microwave_end_fx" );
	
	self ClearClientFlag( CLIENT_FLAG_MICROWAVE );
}

update_microwave_fx()
{
	angles = self GetTagAngles( "tag_flash" );
	origin = self GetTagOrigin( "tag_flash" );
	forward = AnglesToForward( angles );
	forward = VectorScale( forward, level.microwave_radius );

	trace = BulletTrace( origin, origin + forward, false, self );
	
	FXHash = self microwave_fx_hash( trace, origin );
	if ( isdefined( self.microwaveFXHash ) && self.microwaveFXHash == FXHash )
	{
		return;
	}
	
	if ( isdefined ( self.microwaveFXEnt ) ) 
	{
		 self.microwaveFXEnt deleteAfterTime( 0.1 );
	}
	
	self.microwaveFXEnt = spawn("script_model", origin);
	self.microwaveFXEnt SetModel("tag_origin");
	self.microwaveFXEnt.angles = angles;
	self thread deleteOnEndFX();
		
	self.microwaveFXHash = FXHash;
	
	wait( 0.1 );
	
	self.microwaveFXEnt microwave_play_fx( trace, origin );
	
	self SetClientFlag( CLIENT_FLAG_MICROWAVE );
}


deleteOnEndFX()
{
	self.microwaveFXEnt endon( "death" );
	self waittill ( "microwave_end_fx" );
	self.microwaveFXHash = undefined;
	if ( isdefined( self.microwaveFXEnt ) )
	{
		self.microwaveFXEnt delete();
	}
}

microwave_fx_hash( trace, origin )
{
	keys = GetArrayKeys( level.auto_turret_settings["microwave"].fx );
	hash = 0;
	counter = 1;
	for ( i = 0; i < keys.size; i++ )
	{
		distSq = keys[i] * keys[i];

		if ( DistanceSquared( origin, trace[ "position" ] ) >= distSq )
		{
			hash += counter;
		}
		counter *= 2;
	}
	return hash;
}

microwave_play_fx( trace, origin )
{
	keys = GetArrayKeys( level.auto_turret_settings["microwave"].fx );

	for ( i = 0; i < keys.size; i++ )
	{
		distSq = keys[i] * keys[i];

		if ( DistanceSquared( origin, trace[ "position" ] ) >= distSq )
		{
			PlayFxOnTag( level.auto_turret_settings["microwave"].fx[ keys[i] ], self, "tag_origin" );
		}
	}
}

do_tow_shoot( player )
{
	self endon( "turret_deactivated" );
	self endon( "death" );
	player endon( "disconnect" );
	self endon( "target_lost" );
	level endon( "game_ended" );
		
	while(1)
	{
		if( self.fireTime < level.auto_turret_settings["tow"].turretFireDelay )
		{
			wait( 0.1 );
			self.fireTime += 0.1;
			continue;
		}
		self playsound ("wpn_sam_launcher_rocket_npc");
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
//		Turret Hacking Functions
///////////////////////////////////////////////////////
spawnTurretHackerTrigger( player )
{
	triggerOrigin = self.origin + ( 0, 0, 10 );

	// set up a trigger for a hacker
	self.hackerTrigger = Spawn( "trigger_radius_use", triggerOrigin, level.weaponobjects_hacker_trigger_width, level.weaponobjects_hacker_trigger_height );

	/#
		//drawcylinder( self.hackerTrigger.origin, level.weaponobjects_hacker_trigger_width, level.weaponobjects_hacker_trigger_height, 0, "hacker_debug" );	
	#/

	if( self.turretType == "sentry" )
		self.hackerTrigger SetCursorHint( "HINT_NOICON", "auto_gun_turret_mp" );
	else if ( self.turretType == "tow" )
		self.hackerTrigger SetCursorHint( "HINT_NOICON", "tow_turret_mp" );
	else
		self.hackerTrigger SetCursorHint( "HINT_NOICON", "microwave_turret_mp" );

	self.hackerTrigger SetIgnoreEntForTrigger( self );
	self.hackerTrigger SetHintString( level.auto_turret_settings[ self.turretType ].hackerHintString );
	
	self.hackerTrigger SetPerkForTrigger( "specialty_disarmexplosive" );
	self.hackerTrigger thread maps\mp\gametypes\_weaponobjects::hackerTriggerSetVisibility( player );

	self thread hackerThink( self.hackerTrigger, player );
}

hackerThink( trigger, owner ) // self == turret entity
{
	self endon( "death" );

	for ( ;; )
	{
		trigger waittill( "trigger", player, instant );

		if ( !isDefined( instant ) && !trigger maps\mp\gametypes\_weaponobjects::hackerResult( player, owner )  )
		{
			continue;
		}

		// stop and start the killstreak rules before we change the team for the turret
		if( self.turretType == "sentry" )
		{
			maps\mp\killstreaks\_killstreakrules::killstreakStop( "autoturret_mp", self.team, self.killstreak_id );
			killstreak_id = player maps\mp\killstreaks\_killstreakrules::killstreakStart( "autoturret_mp", player.team, true );
			self.killstreak_id = killstreak_id;
		}
		else if ( self.turretType == "tow" )
		{
			maps\mp\killstreaks\_killstreakrules::killstreakStop( "auto_tow_mp", self.team, self.killstreak_id );
			killstreak_id = player maps\mp\killstreaks\_killstreakrules::killstreakStart( "auto_tow_mp", player.team, true );
			self.killstreak_id = killstreak_id;
		}
		else if ( self.turretType == "microwave" )
		{
			maps\mp\killstreaks\_killstreakrules::killstreakStop( "microwaveturret_mp", self.team, self.killstreak_id );
			killstreak_id = player maps\mp\killstreaks\_killstreakrules::killstreakStart( "microwaveturret_mp", player.team, true );
			self.killstreak_id = killstreak_id;
		}

		maps\mp\_scoreevents::processScoreEvent( "hacked", player, self );
		if(self.turretType == "sentry")
		{
			owner maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "sentry_hacked", "item_destroyed" );
		}
		
		// change the owner and team for the turret
		if( level.teamBased )
		{
			self SetTurretTeam( player.team );
			self.team = player.team;
		}
		else
		{
			self SetTurretTeam( "free" );
			self.team = "free";
		}
		
		if( isDefined( self.owner ) && isDefined( self.owner.remoteWeapon ))
		{
			if ( self.owner.remoteWeapon == self )
			{
				self.owner notify( "remove_remote_weapon", true );
			}
		}
		
		self.hacked = true;
		self SetTurretOwner( player );
		self.owner = player;

		self notify( "hacked", player );
		level notify( "hacked", self );
		self DeleteTurretUseTrigger();

		wait( 0.1 );

		self thread stunTurretTacticalGrenade( 2.5 );
		wait( 2.5 );

		if ( IsDefined( player ) && player.sessionstate == "playing" )
		{
			player thread watchOwnerDisconnect( self );
		}

		offset = level.turrets_headicon_offset[ "default" ];
		if( IsDefined( level.turrets_headicon_offset[ self.turretType ] ) )
		{
			offset = level.turrets_headicon_offset[ self.turretType ];
		}
		self maps\mp\_entityheadicons::setEntityHeadIcon( player.pers["team"], player, offset );

		self spawnTurretHackerTrigger( player );
		if( self.turretType == "sentry" )
		{
			player maps\mp\killstreaks\_remote_weapons::initRemoteWeapon( self, "killstreak_remote_turret_mp");
		}		
		return;
	}
}

//Turret disable Trigger
spawnTurretDisableTrigger( player )
{
	triggerOrigin = self.origin + ( 0, 0, 10 );

	// set up a trigger for disable
	self.disableTrigger = Spawn( "trigger_radius_use", triggerOrigin, level.weaponobjects_hacker_trigger_width, level.weaponobjects_hacker_trigger_height );

	if( self.turretType == "sentry" )
	{
		self.disableTrigger SetCursorHint( "HINT_NOICON", "auto_gun_turret_mp" );
	}
	else if ( self.turretType == "tow" )
	{
		self.disableTrigger SetCursorHint( "HINT_NOICON", "tow_turret_mp" );
	}
	else
	{
		self.disableTrigger SetCursorHint( "HINT_NOICON", "microwave_turret_mp" );
	}

	self.disableTrigger SetIgnoreEntForTrigger( self );
	self.disableTrigger SetHintString( level.auto_turret_settings[ self.turretType ].disableHintString );
	
	self.disableTrigger thread maps\mp\gametypes\_weaponobjects::hackerTriggerSetVisibility( player );

	self thread disableTriggerThink( self.disableTrigger, player );
}

disableTriggerThink( trigger, owner ) // self == turret entity
{
	self endon( "death" );

	for ( ;; )
	{
		trigger waittill( "trigger", attacker );
		
		if ( !trigger disableResult( attacker, owner )  )
		{
			continue;
		}
		
		medalGiven = false;
		doMedal = false;
		if( level.teambased && attacker != self.owner && attacker.team != self.owner.team )
		{
			// team based and the owner or the same team is not destroying it
			doMedal = true;
		}
		else if( !level.teambased && attacker != self.owner )
		{
			// not team based and the owner is not destroying it
			doMedal = true;
		}
		
		if( doMedal )
		{
			// per feedback we want to see a medal pop up even if killstreaks destroy stuff (SAM Turret shooting things down, etc.)
			if ( self.turretType == "sentry" )
			{
				maps\mp\_scoreevents::processScoreEvent( "destroyed_sentry_gun", attacker, self, "knife_mp" );
			}
			else if ( self.turretType == "microwave" )
			{
				maps\mp\_scoreevents::processScoreEvent( "destroyed_microwave_turret", attacker, self, "knife_mp" );
			}

			if ( medalGiven == false )
			{
				//if ( self.turretType == "sentry" )
				//{
				//	attacker maps\mp\_properks::destroyedSentryTurret();
				//}
				//attacker maps\mp\_properks::destroyedKillstreak();
				if ( isDefined( self.hardPointWeapon ) )
				{
					level.globalKillstreaksDestroyed++;
					attacker AddWeaponStat( self.hardPointWeapon, "destroyed", 1 );
				}
				medalGiven = true;
			}
		}

		//Inform the player that their turret was destroyed
		if ( isDefined(self.owner) && IsPlayer(self.owner))
		{
			owner = self.owner;
			if(self.turretType == "sentry")
				owner maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "sentry_destroyed", "item_destroyed" );
		}
		self notify( "destroy_turret", true );
	}
	
}

disableResult( player, owner ) // self == trigger_radius
{
	success = true;
	time = GetTime();
	hackTime = GetDvarfloat( "perk_disarmExplosiveTime" );

	if ( !canDisable( player, owner, true ) )
	{
		return false;
	}

	self thread hackerUnfreezePlayer( player );

	while ( time + ( hackTime * 1000 ) > GetTime() )
	{
		if ( !canDisable( player, owner, false ) )
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

		player freeze_player_controls( true );
		player DisableWeapons();

		if ( !IsDefined( self.progressBar ) )
		{
			self.progressBar = player createPrimaryProgressBar();
			self.progressBar.lastUseRate = -1;
			self.progressBar showElem();
			self.progressBar updateBar( 0.01, 1 / hackTime );

			self.progressText = player createPrimaryProgressBarText();
			self.progressText setText( &"MP_DISABLING" );
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

canDisable( player, owner, weapon_check )
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

	if ( player HasPerk( "specialty_disarmexplosive" ) )
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
		//turret_scan_start_sound_ent playloopsound ("mpl_turret_servo", 2);
		wait( 0.5 );
	}
}

TurretScanStopWaiter(ent)
{
	self endon( "turret_sound_cleanup" );
	level endon( "game_ended" );

	while(1)
	{
		self waittill( "turret_scan_stop" );

		//ent playsound ("mpl_turret_servo_stop");

		//ent StopLoopSound( 0.5 );

		wait( 0.5 );

	}
}
TurretScanStopWaiterCleanup(ent)
{
	level endon( "game_ended" );
	
	self waittill_any( "death", "disconnect", "turret_deactivated" );
	
	self notify ("turret_sound_cleanup");
	
	wait .1;
/#	println ("snd scan delete");		#/	
	
	if ( isdefined (ent))
	{	
			ent delete();
	}
	
}
turretScanStopNotify()
{
	
}		

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
startTurretRemoteControl( turret ) // self == player
{
	self.killstreak_waitamount = level.auto_turret_timeout * 1000;
	turret MakeTurretUsable();

	arc_limits = turret GetTurretArcLimits();

	self PlayerLinkWeaponViewToDelta( turret, "tag_player", 0, arc_limits[ "arc_max_yaw" ], -arc_limits[ "arc_min_yaw" ], -arc_limits[ "arc_min_pitch" ], arc_limits[ "arc_max_pitch" ] );
	self PlayerLinkedSetUseBaseAngleForViewClamp( true );

	self RemoteControlTurret( turret );

	self thread watchRemoteSentryFire( turret );
	self thread create_remote_turret_hud( turret );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRemoteSentryFire( turret ) // self == player
{
	self endon("stopped_using_remote");
	turret endon("death");
	self endon("disconnect");
	level endon ( "game_ended" );
	
	while( true )
	{
		if ( self AttackButtonPressed() && turret.stunnedByTacticalGrenade == false )
		{			
			fireTime = WeaponFireTime( "auto_gun_turret_mp" );
			
			Earthquake( 0.15, 0.2, turret.origin, 200 );
			
			wait( fireTime );
		}
		else
		{
			wait( 0.05 ); 				
		}
	}
}	

endRemoteTurret( turret, isDead ) // self == player
{
	if( isDefined( self ) )
	{
		self RemoteControlTurretOff( turret );
		self remove_turret_hint_hud();
	}
	turret MakeTurretUnusable();

	if ( !isDead )
	{
		turret thread maps\mp\_mgturret::burst_fire_unmanned();
		PlayFXOnTag( level.auto_turret_settings[turret.turretType].laserFX, turret, "tag_laser" );
	}
}

end_remote_control_turret( turret ) // dead
{
	self notify("end_remote_sentry");
	if( !isDefined(turret.dead) || !turret.dead)
	{
		self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0, 0.25, 0.1, 0.25 );
		wait( .3 );
	}
	else
	{
		wait( 0.75 );
		self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0, 0.25, 0.1, 0.25 );
		wait( 0.3 );
	}
	
	if ( turret.controlled )
	{
		if( isDefined( self ) )
			self RemoteControlTurretOff( turret );

		turret.controlled = false;
		turret MakeTurretUnusable();
		turret notify("remote_stop");
		turret.killCamEnt = turret.killCamEntAI;
		
		if( isDefined( self ) )
		{
			self unlink();
			self stop_remote();
		}
	}
	
	if( isDefined( self ) )
	{
		if ( isDefined(self.hud_prompt_control) && (!isDefined(turret.dead) || !turret.dead))
		{
			self.hud_prompt_control SetText("HOLD [{+activate}] TO CONTROL SENTRY GUN");	
			self.hud_prompt_exit SetText("");
		}
		self switchToLastNonKillstreakWeapon(); // tagTMR<NOTE>: this is a duplicate call the ClearRemote() stuff does this
		wait (.5);
		self takeweapon("killstreak_ai_tank_mp");
	}
				
	turret thread maps\mp\_mgturret::burst_fire_unmanned();
}

stop_remote()
{
	if ( !isDefined( self ) )
		return;

	self clearUsingRemote();
	self.killstreak_waitamount = undefined;
	self maps\mp\killstreaks\_ai_tank::destroy_remote_hud();
	self remove_turret_hint_hud();
}

//******************************************************************
//     Turret Tutorial HUD                                                            *
//                                                                 *
//******************************************************************

create_remote_turret_hud( remote )
{
	self.fire_turret_hud = newclienthudelem( self );
	self.fire_turret_hud.alignX = "left";
	self.fire_turret_hud.alignY = "bottom";
	self.fire_turret_hud.horzAlign = "user_left";
	self.fire_turret_hud.vertAlign = "user_bottom";
	self.fire_turret_hud.foreground = true;
	self.fire_turret_hud.font = "small";
	self.fire_turret_hud SetText("[{+attack}]" + "Fire Sentry Gun");
	self.fire_turret_hud.hidewheninmenu = true;
	self.fire_turret_hud.archived = false;
	
	if (level.ps3)
	{
		self.fire_turret_hud.x = 25;
		self.fire_turret_hud.y = -25;
		self.fire_turret_hud.fontscale = 1.25;
	}
	else
	{
		self.fire_turret_hud.x = 23;
		self.fire_turret_hud.y = -25;
		self.fire_turret_hud.fontscale = 1.25;
	}
	
	self thread fade_out_hint_hud();
}

fade_out_hint_hud()
{
	wait( 8 );
	time = 0;
	while (time < 2)
	{
		if ( !isDefined(self.fire_turret_hud))
		{
			return;	
		}
		self.fire_turret_hud.alpha -= 0.025;
		time += 0.05;
		wait (0.05);
	}
	
	self.fire_turret_hud.alpha = 0;
}

remove_turret_hint_hud()
{
	if ( isdefined(self.fire_turret_hud) )
		self.fire_turret_hud destroy();
	if ( isdefined(self.zoom_turret_hud) )
		self.zoom_turret_hud destroy();	
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
