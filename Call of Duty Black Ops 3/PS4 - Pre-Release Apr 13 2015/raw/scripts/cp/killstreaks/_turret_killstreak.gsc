#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_scrambler;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_weapons;

#using scripts\cp\_challenges;
#using scripts\cp\_hacker_tool;
#using scripts\cp\_mgturret;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_ai_tank;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\killstreaks\_remote_weapons;
#using scripts\cp\killstreaks\_supplydrop;

                                                                       

#precache( "string", "KILLSTREAK_AUTO_TURRET_CRATE" );
#precache( "string", "KILLSTREAK_MICROWAVE_TURRET_CRATE" );
#precache( "string", "KILLSTREAK_EARNED_AUTO_TURRET" );
#precache( "string", "KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_AIRSPACE_FULL" );
#precache( "string", "KILLSTREAK_EARNED_MICROWAVE_TURRET" );
#precache( "string", "KILLSTREAK_MICROWAVE_TURRET_NOT_AVAILABLE" );
#precache( "eventstring", "mpl_killstreak_turret" );
#precache( "eventstring", "mpl_killstreak_auto_turret" );
#precache( "fx", "_t6/weapon/sentry_gun/fx_sentry_gun_emp_stun" );
#precache( "fx", "_t6/weapon/sentry_gun/fx_sentry_gun_damage_state" );
#precache( "fx", "_t6/weapon/sentry_gun/fx_sentry_gun_death_state" );
#precache( "fx", "_t6/weapon/sentry_gun/fx_sentry_gun_exp" );
#precache( "fx", "_t6/weapon/grenade/fx_spark_disabled_weapon_lg" );
#precache( "fx", "_t6/weapon/silent_gaurdian/fx_sg_emp_stun" );
#precache( "fx", "_t6/weapon/silent_gaurdian/fx_sg_damage_state" );
#precache( "fx", "_t6/weapon/silent_gaurdian/fx_sg_death_state" );
#precache( "fx", "_t6/weapon/silent_gaurdian/fx_sg_exp" );
#precache( "fx", "_t6/weapon/silent_gaurdian/fx_sg_distortion_cone_ash" );
#precache( "fx", "explosions/fx_exp_equipment_lg" );
	
#using_animtree ( "mp_microwaveturret" );

#namespace turret_killstreak;

//AUTO_TURRET_TIMEOUT = 90.0;
///////////////////////////////////////////////////////
//		Turret Initialization Functions
///////////////////////////////////////////////////////
function init()
{
	thread _mgturret::init_turret_difficulty_settings();
	level.auto_turret_timeout = 240.0;
	level.microwave_radius = 750;
	level.microwave_turret_cone_dot = cos( 45 );
	level.microwave_turret_angle = 90;
	level.microwave_turret_damage = 10;
	level.microwave_fx_size = 150;
	level flag::init("end_target_confirm");
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
	level.auto_turret_settings["sentry"].stunFX = "_t6/weapon/sentry_gun/fx_sentry_gun_emp_stun";
	level.auto_turret_settings["sentry"].stunFXTag = "tag_origin";
	level.auto_turret_settings["sentry"].damageFX = "_t6/weapon/sentry_gun/fx_sentry_gun_damage_state";
	level.auto_turret_settings["sentry"].disableFX = "_t6/weapon/sentry_gun/fx_sentry_gun_death_state";
	level.auto_turret_settings["sentry"].explodeFX = "_t6/weapon/sentry_gun/fx_sentry_gun_exp";	
	//level.auto_turret_settings["sentry"].laserFX = "_t6/weapon/sentry_gun/fx_sentry_gun_laser";
	level.auto_turret_settings["sentry"].stunFXFrequencyMin = 0.1;
	level.auto_turret_settings["sentry"].stunFXFrequencyMax = 0.75;
	level.auto_turret_settings["sentry"].turretInitDelay = 1.6;
	level.auto_turret_settings["sentry"].hackerToolRadius = level.sentryHackerToolRadius;
	level.auto_turret_settings["sentry"].hackerToolTimeMs = level.sentryHackerToolTimeMs;

	level.auto_turret_settings["tow"] = spawnStruct();
	level.auto_turret_settings["tow"].hintString = &"KILLSTREAK_TOW_TURRET_PICKUP";
	level.auto_turret_settings["tow"].hackerHintString = &"KILLSTREAK_TURRET_HACKING";
	level.auto_turret_settings["tow"].hintIcon = "hud_ks_sam_turret";
	level.auto_turret_settings["tow"].modelBase = "t6_wpn_turret_sam";
	level.auto_turret_settings["tow"].modelGoodPlacement = "t6_wpn_turret_sam_yellow";
	level.auto_turret_settings["tow"].modelBadPlacement = "t6_wpn_turret_sam_red";
	level.auto_turret_settings["tow"].stunFX = "_t6/weapon/grenade/fx_spark_disabled_weapon_lg";
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
	level.auto_turret_settings["microwave"].stunFX = "_t6/weapon/silent_gaurdian/fx_sg_emp_stun";
	level.auto_turret_settings["microwave"].loopSoundFX = "wpn_sguard_beam";
	level.auto_turret_settings["microwave"].stunFXTag = "tag_origin";
	level.auto_turret_settings["microwave"].damageFX = "_t6/weapon/silent_gaurdian/fx_sg_damage_state";
	level.auto_turret_settings["microwave"].disableFX = "_t6/weapon/silent_gaurdian/fx_sg_death_state";
	level.auto_turret_settings["microwave"].explodeFX = "_t6/weapon/silent_gaurdian/fx_sg_exp";	
	level.auto_turret_settings["microwave"].stunFXFrequencyMin = 0.1;
	level.auto_turret_settings["microwave"].stunFXFrequencyMax = 0.75;
	level.auto_turret_settings["microwave"].turretInitDelay = 1.0;
	level.auto_turret_settings["microwave"].timeout = 240.0;
	level.auto_turret_settings["microwave"].fxchecktime = 5.0;
	level.auto_turret_settings["microwave"].hackerToolRadius = level.microwaveHackerToolRadius;
	level.auto_turret_settings["microwave"].hackerToolTimeMs = level.microwaveHackerToolTimeMs;

	level.auto_turret_settings["microwave"].microwave_radius_1 = Int( level.microwave_radius / 8 );
	level.auto_turret_settings["microwave"].microwave_radius_2 = Int( level.microwave_radius / 2 );
	level.auto_turret_settings["microwave"].microwave_radius_3 = Int( level.microwave_radius * 3 / 4 );
	level.auto_turret_settings["microwave"].microwave_radius_4 = Int( level.microwave_radius );
	level.auto_turret_settings["microwave"].fx = "_t6/weapon/silent_gaurdian/fx_sg_distortion_cone_ash";

	level._turret_explode_fx = "explosions/fx_exp_equipment_lg";

	//Used later to check if turret is in trigger_hurt's or minefields
	minefields = GetEntarray( "minefield", "targetname" );
	hurt_triggers = GetEntArray( "trigger_hurt","classname" );
	level.fatal_triggers = ArrayCombine( minefields, hurt_triggers, true, false );
	level.noTurretPlacementTriggers = getEntArray( "no_turret_placement", "targetname" );
	level notify( "no_turret_trigger_created" );

	// register the auto turret hardpoint
	if ( tweakables::getTweakableValue( "killstreak", "allowauto_turret" ) )
	{
		//Sentry version
		killstreaks::register("autoturret", "autoturret", "killstreak_auto_turret", "auto_turret_used",&useSentryTurretKillstreak );
		killstreaks::register_alt_weapon( "autoturret", "auto_gun_turret" );
		killstreaks::register_remote_override_weapon( "autoturret", "killstreak_remote_turret" );
		killstreaks::register_strings("autoturret", &"KILLSTREAK_EARNED_AUTO_TURRET", &"KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE");
		killstreaks::register_dialog("autoturret", "mpl_killstreak_auto_turret", "kls_turret_used", "","kls_turret_enemy", "", "kls_turret_ready");
		killstreaks::register_dev_dvar("autoturret", "scr_giveautoturret");

		killstreaks::register("turret_drop", "turret_drop", "killstreak_auto_turret_drop", "auto_turret_used",&useKillstreakTurretDrop, undefined, true );
		killstreaks::register_remote_override_weapon( "turret_drop", "killstreak_remote_turret" );
		killstreaks::register_strings("turret_drop", &"KILLSTREAK_EARNED_AUTO_TURRET", &"KILLSTREAK_AIRSPACE_FULL");
		killstreaks::register_dialog("turret_drop", "mpl_killstreak_turret", "kls_turret_used", "","kls_turret_enemy", "", "kls_turret_ready");
		killstreaks::register_dev_dvar("turret_drop", "scr_giveautoturretdrop");

		supplydrop::registerCrateType( "turret_drop", "killstreak", "autoturret", 1, &"KILLSTREAK_AUTO_TURRET_CRATE", undefined, "MEDAL_SHARE_PACKAGE_AUTO_TURRET", &supplydrop::giveCrateKillstreak );
		level.killStreakIcons["autoturret"] = "hud_ks_auto_turret";

		// Microwave version
		killstreaks::register("microwaveturret", "microwaveturret", "killstreak_microwave_turret", "microwave_turret_used",&useMicrowaveTurretKillstreak );
		killstreaks::register_alt_weapon( "microwaveturret", "microwave_turret" );
		killstreaks::register_alt_weapon( "microwaveturret", "microwave_turret_damage" );
		killstreaks::register_strings("microwaveturret", &"KILLSTREAK_EARNED_MICROWAVE_TURRET", &"KILLSTREAK_MICROWAVE_TURRET_NOT_AVAILABLE");
		killstreaks::register_dialog("microwaveturret", "mpl_killstreak_auto_turret", "kls_microwave_used", "","kls_microwave_enemy", "", "kls_microwave_ready");
		killstreaks::register_dev_dvar("microwaveturret", "scr_givemicrowaveturret");
		killstreaks::set_team_kill_penalty_scale( "microwaveturret", level.teamKillReducedPenalty );

		killstreaks::register("microwaveturret_drop", "microwaveturret_drop", "killstreak_microwave_turret_drop", "microwave_turret_used",&useKillstreakTurretDrop, undefined, true );
		killstreaks::register_strings("microwaveturret_drop", &"KILLSTREAK_EARNED_MICROWAVE_TURRET", &"KILLSTREAK_AIRSPACE_FULL");
		killstreaks::register_dialog("microwaveturret_drop", "mpl_killstreak_turret", "kls_microwave_used", "","kls_microwave_enemy", "", "kls_microwave_ready");
		killstreaks::register_dev_dvar("microwaveturret_drop", "scr_givemicrowaveturretdrop");

		supplydrop::registerCrateType( "microwaveturret_drop", "killstreak", "microwaveturret", 1, &"KILLSTREAK_MICROWAVE_TURRET_CRATE", undefined, "MEDAL_SHARE_PACKAGE_MICROWAVE_TURRET", &supplydrop::giveCrateKillstreak );
		level.killStreakIcons["microwaveturret"] = "hud_ks_microwave_turret";
	}

	level.turrets_headicon_offset = [];
	level.turrets_headicon_offset["default"] = (0, 0, 70); 
	level.turrets_headicon_offset["sentry"] = (0, 0, 70); 
	level.turrets_headicon_offset["tow"] = (0, 0, 65); 
	level.turrets_headicon_offset["microwave"] = (0, 0, 80); 

	level.turrets_hacker_trigger_width = 72; 
	level.turrets_hacker_trigger_height = 96; 
	SetDvar("scr_turret_no_timeout", 0);
	SetDvar("turret_sentryTargetTime", 1500);
	SetDvar("turret_TargetLeadBias", 1.5);

	//clientfield::register( "turret", "turret_microwave_open", VERSION_SHIP, 1, "int" );
	//clientfield::register( "turret", "turret_microwave_close", VERSION_SHIP, 1, "int" );
	//clientfield::register( "turret", "turret_microwave_destroy", VERSION_SHIP, 1, "int" );	
	//clientfield::register( "turret", "turret_microwave_sounds", VERSION_SHIP, 1, "int" );
}

///////////////////////////////////////////////////////
//		Turret Supply Drop Functions
///////////////////////////////////////////////////////
function useKillstreakTurretDrop(hardpointType)
{
	if( self supplydrop::isSupplyDropGrenadeAllowed(hardpointType) == false )
		return false;
	
	result = self supplydrop::useSupplyDropMarker();
	
	self notify( "supply_drop_marker_done" );

	if ( !isdefined(result) || !result )
	{
		return false;
	}

	return result;
}

function useSentryTurretKillstreak( hardpointType )
{
	if ( self killstreaks::is_interacting_with_object() )
		return false;
		
	if ( self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	killstreak_id = self killstreakrules::killstreakStart( hardpointType, self.team );
	if (  killstreak_id == -1 )
		return false;

	turret = self useSentryTurret( hardpointType );
	turret.killstreak_id = killstreak_id;
	killstreakWeapon = killstreaks::get_killstreak_weapon( hardpointType );

	event = turret util::waittill_any_return( "turret_placed", "destroy_turret", "death", "turret_emped" );
	if ( event == "turret_placed" )
	{
		level.globalKillstreaksCalled++;
		self AddWeaponStat( killstreakWeapon, "used", 1 );
		return true;
	}
	if ( event == "death" ) 
	{
		returnTurretToInventory( turret );
		return false;
	}
	if ( event == "turret_emped" ) 
	{
		level.globalKillstreaksCalled++;
		self AddWeaponStat( killstreakWeapon, "used", 1 );
		turret notify( "destroy_turret", false );
		return true;
	}

	return false;

}

function useTowTurretKillstreak( hardpointType )
{
	if ( self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	killstreak_id = self killstreakrules::killstreakStart( hardpointType, self.team );
	if (  killstreak_id == -1 )
		return false;

	turret = self useTowTurret( hardpointType );
	turret.killstreak_id = killstreak_id;

	event = turret util::waittill_any_return( "turret_placed", "destroy_turret", "death", "turret_emped" );
	if ( event == "turret_placed" )
	{
		return true;
	}
	if ( event == "death" ) 
	{
		returnTurretToInventory( turret );
		return false;
	}
	if ( event == "turret_emped" ) 
	{
		turret notify( "destroy_turret", false );
		return true;
	}

	return false;
}

function useMicrowaveTurretKillstreak( hardpointType )
{
	if ( self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	if ( self killstreaks::is_interacting_with_object() )
		return false;
	
	killstreak_id = self killstreakrules::killstreakStart( hardpointType, self.team );
	if (  killstreak_id == -1 )
		return false;

	turret = self useMicrowaveTurret( hardpointType );
	turret.killstreak_id = killstreak_id;
	killstreakWeapon = killstreaks::get_killstreak_weapon( hardpointType );

	event = turret util::waittill_any_return( "turret_placed", "destroy_turret", "death", "turret_emped" );
	if ( event == "turret_placed" )
	{
		level.globalKillstreaksCalled++;
		self AddWeaponStat( killstreakWeapon, "used", 1 );
		return true;
	}
	if ( event == "death" ) 
	{
		returnTurretToInventory( turret );
		return false;
	}
	if ( event == "turret_emped" ) 
	{
		level.globalKillstreaksCalled++;
		self AddWeaponStat( killstreakWeapon, "used", 1 );
		turret notify( "destroy_turret", false );
		return true;
	}

	return false;
}

function useSentryTurret( hardpointType )
{
	self killstreaks::switch_to_last_non_killstreak_weapon();
	killstreakWeapon = killstreaks::get_killstreak_weapon( hardpointType );

	if( !( isdefined( level.usingMomentum ) && level.usingMomentum ) && !self killstreaks::get_if_top_killstreak_has_been_used() )
	{
		//self AddPlayerStat( "AUTO_TURRET_USED", 1 );
		level.globalKillstreaksCalled++;
		self AddWeaponStat( killstreakWeapon, "used", 1 );
	}

	//Spawn a turret at this location 
	turret = spawnTurret( "auto_turret", self.origin, GetWeapon( "auto_gun_turret" ) );
	turret.turretType = "sentry";
	turret SetTurretType(turret.turretType);

	turret SetModel( level.auto_turret_settings[turret.turretType].modelGoodPlacement );
	turret.angles = self.angles;
	turret.hardPointWeapon = killstreakWeapon;
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

 
	turret.controlled = false;
	//set up number for this turret
	if (!isdefined(self.numTurrets))
		self.numTurrets=1;
	else
		self.numTurrets++;
	turret.ownerNumber = self.numTurrets;
	
	if( level.teamBased )
	{
		turret.team = self.team;
	}
	else
	{
		turret.team = "free";
	}
	
	//Set up turret health and damage modifiers
	setupTurretHealth( turret );
	//Set the turret's lifespan
	turret.carried = true;
	turret.curr_time = 0;
	turret.stunDuration = 5.0;

	turret.remoteControlled = false;


	//Wait until turret's lifespan is used and remove the turret
	turret thread watchTurretLifespan();

	self thread watchOwnerDisconnect( turret );
	self thread watchOwnerTeamKillKicked( turret );
	turret thread destroyTurret();
	turret thread turret_target_aquired_watch( self );
	turret thread turret_target_lost_watch( self );


	//Setup the turret for carrying
	self thread startCarryTurret( turret );
	
	return turret;
}

function useTowTurret( hardpointType )
{
	self killstreaks::switch_to_last_non_killstreak_weapon();
	killstreakWeapon = killstreaks::get_killstreak_weapon( hardpointType );
	
	if ( !( isdefined( level.usingMomentum ) && level.usingMomentum ) && !self killstreaks::get_if_top_killstreak_has_been_used() )
	{
		level.globalKillstreaksCalled++;
		self AddWeaponStat( killstreakWeapon, "used", 1 );
	}
	
	//Spawn a turret at this location 
	turret = spawnTurret( "auto_turret", self.origin, GetWeapon( "tow_turret" ) );
	turret.turretType = "tow";
	turret SetTurretType(turret.turretType);

	turret SetModel( level.auto_turret_settings[turret.turretType].modelGoodPlacement );
	turret.angles = self.angles;
	turret.hardPointWeapon = killstreakWeapon;
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
		turret.team = self.team;
	}
	else
	{
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
	self thread watchOwnerTeamKillKicked( turret );
	turret thread destroyTurret();


	//Setup the turret for carrying
	self thread startCarryTurret( turret );
	
	return turret;
}

function useMicrowaveTurret( hardpointType )
{
	self killstreaks::switch_to_last_non_killstreak_weapon();
	killstreakWeapon = killstreaks::get_killstreak_weapon( hardpointType );
	
	if ( !( isdefined( level.usingMomentum ) && level.usingMomentum ) && !self killstreaks::get_if_top_killstreak_has_been_used() )
	{
		//self AddPlayerStat( "MICROWAVE_TURRET_USED", 1 );
		level.globalKillstreaksCalled++;
		self AddWeaponStat( killstreakWeapon, "used", 1 );
	}

	//Spawn a turret at this location 
	turret = spawnTurret( "auto_turret", self.origin, GetWeapon( "microwave_turret" ) );
	turret.turretType = "microwave";
	turret SetTurretType(turret.turretType);

	turret SetModel( level.auto_turret_settings[turret.turretType].modelGoodPlacement );
	turret.angles = self.angles;
	turret.hardPointWeapon = killstreakWeapon;
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
		turret.team = self.team;
	}
	else
	{
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

function watchRoundAndGameEnd( turret )
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

function giveTurretBack( turret )
{
	if ( !( isdefined( level.usingMomentum ) && level.usingMomentum ) || ( isdefined( turret.isFromInventory ) && turret.isFromInventory ) )
	{
		killstreaks::give( killstreaks::get_killstreak_for_weapon( turret.hardPointWeapon ), undefined, undefined, true );
	}
}

function watchOwnerDeath( turret )
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
			//ensure proper placememt
			placement = self canPlayerPlaceTurret( );

			if( placement["result"] )
			{
				turret.origin = placement["origin"];
				turret.angles = placement["angles"];
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
	else
	{
		if( isdefined( turret ) ) 
		{
			self stopCarryTurret( turret );
			turret notify( "destroy_turret", false );
		}
	}
}

function returnTurretToInventory( turret )
{
	//Check for player changing teams
		if( level.teamBased && self.team != turret.team )
		{
			if ( isdefined( turret ) )
			{
				self stopCarryTurret( turret );
				turret notify( "destroy_turret", false );
			}
		}
		else
		{
			//giveTurretBack( turret );
			if ( isdefined( turret ) )
			{
				turret setTurretCarried( false );
				self stopCarryTurret( turret );
				turret notify( "destroy_turret", false );
			}
			self util::_enableWeapon();
		}
}

function watchOwnerEMP( turret )
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
			self util::_enableWeapon();
			self TakeWeapon( turret.hardPointWeapon );
			turret notify( "turret_emped" );
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
				turret notify( "turret_emped", false );
			}
		}
	}
}

function watchOwnerTeamKillKicked( turret )
{
	turret endon("turret_deactivated");
	turret endon("hacked");
	turret endon("destroy_turret");

	self waittill( "teamKillKicked" );

	if( isdefined( turret ) ) 
		turret notify( "destroy_turret", false );
}

function watchOwnerDisconnect( turret )
{
	turret endon("turret_deactivated");
	turret endon("hacked");
	self util::waittill_any( "disconnect", "joined_team" );

	if( isdefined( turret ) ) 
		turret notify( "destroy_turret", true );
}

///////////////////////////////////////////////////////
//		Turret Carry Functions
///////////////////////////////////////////////////////

function startCarryTurret( turret )
{
	turret maketurretunusable();
	turret setTurretCarried( true );
	self util::_disableWeapon();
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
	turret entityheadicons::destroyEntityHeadIcons();
	turret SetTurretOwner( self );
	turret SetDefaultDropPitch(-90.0);

	if( !turret.hasBeenPlanted )
		self thread watchReturnTurretToInventory( turret );

	//Watch turret placement
	self thread updateTurretPlacement( turret );
	self thread watchTurretPlacement( turret );

	if ( turret.turretType == "microwave" )
	{
		turret clientfield::set( "turret_microwave_open", 0 );
		turret clientfield::set( "turret_microwave_close", 1 );
		self playsoundtoplayer ( "mpl_turret_micro_startup", self );
		
	}
	//Ensure pickup trigger is cleaned up
	turret notify( "turret_carried" );
	turret notify( "turret_target_lost" );
}

function watchReturnTurretToInventory( turret )
{
  self endon( "death" );
  self endon( "entering_last_stand" );
  self endon( "disconnect" );
  turret endon( "turret_placed" );
  turret endon( "turret_deactivated" );

  {wait(.05);};
  
  while( 1 )
  {
	  if( self actionSlotFourButtonPressed() )
	  {
		  returnTurretToInventory( turret );
		  return;
	  }

	  {wait(.05);};
  }
}

function updateTurretPlacement( turret )
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
		placement = self canPlayerPlaceTurret( );

		turret.origin = placement["origin"];
		turret.angles = placement["angles"];
		//'good_spot_check' is only true if the placement result returns true and the turret in hurt trigger returns false
		good_spot_check = placement["result"] & !(turret turretInHurtTrigger()) & !(turret turretInNoTurretPlacementTrigger());
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

		{wait(.05);};
	}
}

//'Self' is the turret. Function checks to see if turret is in minefield or hurt trigger.
//level.fatal_triggers is defined in the init function.
function turretInHurtTrigger()
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

function turretInNoTurretPlacementTrigger()
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

function watchTurretPlacement( turret )
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "entering_last_stand" );
	turret endon( "turret_placed" );
	turret endon( "turret_deactivated" );

	while( self AttackButtonPressed() )
	{
		{wait(.05);};
	}
	while(1)
	{
		if( self attackbuttonpressed() && turret.canBePlaced )
		{
			//ensure proper placememt
			placement = self canPlayerPlaceTurret( );

			if( placement["result"] )
			{
				turret.origin = placement["origin"];
				turret.angles = placement["angles"];
				self placeTurret( turret );
			}
		}

		{wait(.05);};

	}
}

function placeTurret( turret )
{

	if( !turret.carried || !turret.canBePlaced )
		return;

	turret setTurretCarried( false );
	self stopCarryTurret( turret, turret.origin, turret.angles );
	turret spawnTurretPickUpTrigger( self );
	//turret spawnTurretHackerTrigger( self ); // TFLAME - taking out for now
	
	turret hacker_tool::registerWithHackerTool( level.auto_turret_settings[turret.turretType].hackerToolRadius, level.auto_turret_settings[turret.turretType].hackerToolTimeMs );

	//turret spawnTurretDisableTrigger( self );
	self thread initTurret( turret );
	self util::_enableWeapon();
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

function initTurret( turret )
{
	_mgturret::turret_set_difficulty( turret, "fu" );
	turret SetModel( level.auto_turret_settings[turret.turretType].modelBase );
	if ( turret.turretType == "microwave" )
	{
		turret clientfield::set( "turret_microwave_close", 0 );
		turret clientfield::set( "turret_microwave_open", 1 );
	}
	turret SetForceNoCull();
	turret PlaySound ("mpl_turret_startup");
	
	if( level.teambased )
	{
		offset = level.turrets_headicon_offset[ "default" ];
		if( isdefined( level.turrets_headicon_offset[ turret.turretType ] ) )
		{
			offset = level.turrets_headicon_offset[ turret.turretType ];
		}
		turret entityheadicons::setEntityHeadIcon( self.pers["team"], self, offset );
	}

	//Make it automated
	turret maketurretunusable();
	turret SetMode( "auto_nonai" );
	turret SetTurretOwner( self );
	turret.owner = self;
	turret SetDefaultDropPitch(45.0);
	turret.dangerous_nodes = [];
	
	if( turret.turretType == "sentry" )
		turret thread turret_sentry_think( self );
	else if( turret.turretType == "tow" )
		turret thread turret_tow_think( self );
	else if ( turret.turretType == "microwave" )
		turret thread turret_microwave_think( self );

	turret.turret_active = true;

	// Create the spawn influencer	
	create_turret_influencer( "turret" );
	create_turret_influencer( "turret_close" );
	
	//Track the turret's health
	turret thread watchDamage();

	wait(1.0);
	level flag::set("end_target_confirm");
}

function create_turret_influencer( name )
{
	preset = GetInfluencerPreset( name );
	
	if ( !IsDefined( preset ) )
		return;
		
	// place the influencer out infront of the turret
	projected_point = self.origin + VectorScale( AnglesToForward( self.angles ), preset["radius"] * 0.7 );

	return spawning::create_enemy_influencer( name, projected_point, self.team );
	
}

function setupTurretHealth( turret )
{
	turret.health = 100000;	
	turret.maxHealth = 650;
	turret.bulletDamageReduction = 0.6;
	turret.explosiveDamageReduction = 2.0;
}

///////////////////////////////////////////////////////
//		Turret Watcher Functions
///////////////////////////////////////////////////////
function watchDamage()
{
	self endon( "turret_deactivated" );
	
	medalGiven = false;
	
	if ( !isdefined( self.damageTaken ) )
		self.damageTaken = 0;
	
	low_health = false;
	
	if ( self.damageTaken > self.maxHealth / 1.8 )
	{
		PlayFXOnTag( level.auto_turret_settings[self.turretType].damageFX, self, level.auto_turret_settings[self.turretType].stunFxTag );
		low_health = true;
	}

	for( ;; )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon );

		if ( type == "MOD_CRUSH" )
		{
			self.skipFutz = true;
			self notify( "destroy_turret", false );
			return;
		}

		if( !isdefined( attacker ) )
			continue;
		
		allowPerks = true;

		if ( !isPlayer( attacker ) )
		{
			if ( isdefined( attacker.owner ) && isPlayer( attacker.owner ) ) 
			{
				attacker = attacker.owner;
				allowPerks = false;
			}
		}

		if( isPlayer( attacker ) && level.teambased && isdefined( attacker.team ) && self.team == attacker.team && level.friendlyfire == 0 )
			continue;

		if ( !level.teambased && !level.hardcoreMode )
		{
			if ( self.owner == attacker )
			{
				continue;
			}
		}

		// Microwave turret's shield blocks all damage (not working)
		if ( self.turretType == "microwave" && partName == "tag_shield" )
		{
			self.health += damage;
			continue;
		}
		else
		{
			damageTakenBefore = self.damageTaken;
			if ( ( type == "MOD_PISTOL_BULLET" ) || ( type == "MOD_RIFLE_BULLET" ) || (type == "MOD_PROJECTILE_SPLASH" && weapon.bulletImpactExplode) )
			{
				if ( allowPerks && attacker HasPerk( "specialty_armorpiercing" ) )
					damage += int( damage * level.cac_armorpiercing_data );
				
				if ( weapon.weapClass == "spread")
					damage = damage * 5;
	
				self.damageTaken += self.bulletDamageReduction * damage;
			}
			else if ( weapon.name == "remote_missile_missile" || weapon.name == "remote_mortar" || weapon.name == "missile_drone_projectile" )
			{
				self.damageTaken += damage * 10;	
			}
			else if ( type == "MOD_PROJECTILE" && weapon.requireLockonToFire )
			{
				self.damageTaken += 200 * self.explosiveDamageReduction;	
			}
			else if ( ( type == "MOD_PROJECTILE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_PROJECTILE_SPLASH" ) && damage != 0 && !weapon.isEmp && !weapon.bulletImpactExplode )
			{
				self.damageTaken += self.explosiveDamageReduction * damage;
			}
			else if ( type == "MOD_MELEE" )
			{
				//self.damageTaken += self.maxHealth;
				if ( IsPlayer( attacker ) )
				{
					//attacker iprintlnbold( &"KILLSTREAK_TURRET_KNIFED" );
					attacker playLocalSound( "fly_riotshield_impact_knife" );
				}
				continue;
			}
			else if ( weapon.isEmp && (type == "MOD_GRENADE_SPLASH"))
			{
				self.damageTaken += self.maxHealth;
			}
			else
			{
				self.damageTaken += damage;
			}
			
			damageDealt = self.damageTaken - damageTakenBefore;
			if ( ( damageDealt > 0 ) && ( isdefined( self.controlled ) && self.controlled ) )
			{
				self.owner SendKillstreakDamageEvent( int(damageDealt) );
			}
		}

		// most equipment should be flash/concussion-able, so it'll disable for a short period of time
		// check to see if the equipment has been flashed/concussed and disable it (checking damage < 5 is a bad idea, so check the weapon name)
		// we're currently allowing the owner/teammate to flash their own
		if ( weapon.isEmp && type == "MOD_GRENADE_SPLASH" )
		{
			if( !self.stunnedByTacticalGrenade )
			{
				self thread stunTurretTacticalGrenade( self.stunDuration );
			}

			// if we're not on the same team then show damage feedback
			if( level.teambased && self.owner.team != attacker.team )
			{
				if( damagefeedback::doDamageFeedback( weapon, attacker ) )
					attacker damagefeedback::update( type );
			}
			// for ffa just make sure the owner isn't the same
			else if( !level.teambased && self.owner != attacker )
			{
				if( damagefeedback::doDamageFeedback( weapon, attacker ) )
					attacker damagefeedback::update( type );
			}
		}
		else if ( weapon != level.weaponNone )
		{
			if ( damagefeedback::doDamageFeedback( weapon, attacker ) )
				attacker damagefeedback::update( type );	
		}

		if ( self.damageTaken >= self.maxHealth )
		{
			if ( self util::IsEnemyPlayer( attacker ) && self.owner != attacker )
			{
				// per feedback we want to see a medal pop up even if killstreaks destroy stuff (SAM Turret shooting things down, etc.)
				if ( self.turretType == "sentry" )
				{
					scoreevents::processScoreEvent( "destroyed_sentry_gun", attacker, self, weapon );
				}
				else if ( self.turretType == "microwave" )
				{
					scoreevents::processScoreEvent( "destroyed_microwave_turret", attacker, self, weapon );
				}
				attacker challenges::destroyedTurret( weapon );

				if ( self.hardPointWeapon != level.weaponNone )
				{
					level.globalKillstreaksDestroyed++;
					attacker AddWeaponStat( self.hardPointWeapon, "destroyed", 1 );
				}

				if ( ( isdefined( self.controlled ) && self.controlled ) )
				{
					attacker AddWeaponStat( weapon, "destroyed_controlled_killstreak", 1 );
				}		
			}

			//Inform the player that their turret was destroyed
			owner = self.owner;

			//Ensure that the player isn't trying to pick up the turret at the same time.
			owner stopCarryTurret( self );

			self.damageTaken = self.health;
			self.dead = true;
			self notify( "destroy_turret", true );
		}
				
		if ( !low_health && self.damageTaken > self.maxHealth / 1.8 )
		{
			PlayFXOnTag( level.auto_turret_settings[self.turretType].damageFX, self, level.auto_turret_settings[self.turretType].stunFxTag );
			low_health = true;
		}
	}

}

function watchTurretLifespan( turret )
{

	self endon( "turret_deactivated" );
	self endon( "death" );	

	while(1)
	{
		 timeout = level.auto_turret_timeout;
		 if ( isdefined( turret ) && isdefined( level.auto_turret_settings[turret.turretType].timeout ) )
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
	shouldTimeout = GetDvarString("scr_turret_no_timeout");
	if (shouldTimeout == "1")
	{
		return;
	}	
	self notify( "destroy_turret", true );
}

function stunTurretTacticalGrenade( duration )
{

	self endon( "turret_deactivated" );
	
	self SetMode( "auto_ai" );
	self notify( "stop_burst_fire_unmanned" );

	if ( self weaponobjects::isStunned() )
	{
		return;
	}

	self.stunnedByTacticalGrenade = true;
	self thread stunTurretFx( duration, false, true );

	if (self.turretType == "microwave")
	{
		self clientfield::set( "turret_microwave_open", 0 );
		self clientfield::set( "turret_microwave_close", 1 );
		self notify( "microwave_end_fx" );
	}
	
	if (isdefined(self.controlled) && self.controlled )
	{
		self.owner FreezeControls( true );
	}
	
	if (isdefined(self.owner.fullscreen_static))
	{	
		self.owner thread remote_weapons::stunStaticFX( duration );
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

	if (isdefined(self.controlled) && self.controlled )
	{
		self.owner FreezeControls( false );
	}

	if( !self.carried )
		self SetMode( "auto_nonai" );

	if( self.turretType != "tow" && !self.carried && !self.controlled )
		self thread _mgturret::burst_fire_unmanned();

	if( self.turretType == "microwave" && !self.carried)
	{
		self clientfield::set( "turret_microwave_close", 0 );
		self clientfield::set( "turret_microwave_open", 1 );
		wait( 0.5 );
		self thread microwave_fx();
	}

	self notify("turret_stun_ended");
}

function stunTurret( duration, isDead, isEMP )
{
	self endon( "turret_deactivated" );

	self SetMode( "auto_ai" );
	self notify( "stop_burst_fire_unmanned" );
	self thread stunTurretFx( duration, isDead, isEMP );
	
	if (isdefined(self.controlled) && self.controlled && isdefined( self.owner ))
	{
		self.owner FreezeControls( true );
	}
	
	if (self.turretType == "microwave")
	{
		self clientfield::set( "turret_microwave_open", 0 );
		self clientfield::set( "turret_microwave_destroy", 1 );
	}
	
	if ( isdefined( duration ) )
	{
		wait( duration );
	}
	else
	{
		return;
	}
	
	if (isdefined(self.controlled) && self.controlled && isdefined( self.owner ))
	{
		self.owner FreezeControls( false );
	}
	
	if( !self.carried )
		self SetMode( "auto_nonai" );

	if( self.turretType != "tow" && !self.carried && !self.controlled )
		self thread _mgturret::burst_fire_unmanned();
	
	self notify("turret_stun_ended");
	level notify( "turret_stun_ended", self );
}

function stunFxThink( fx )
{
	fx endon("death");
	self StopLoopSound();
	
	self util::waittill_any( "death", "turret_stun_ended", "turret_deactivated", "hacked", "turret_carried" );
	
	if ( isdefined( self ) ) 
	{
		if ( isdefined( level.auto_turret_settings[self.turretType].loopSoundFX ) )
			self playloopsound ( level.auto_turret_settings[self.turretType].loopSoundFX );
	}
	
	fx delete();
}

function stunTurretFx( duration, isDead, isEMP )
{
	self endon( "turret_deactivated" );
	self endon( "death" );
	self endon( "turret_stun_ended" );

	origin = self GetTagOrigin( level.auto_turret_settings[self.turretType].stunFxTag );
 
	self.stun_fx = spawn( "script_model", origin );
	self.stun_fx SetModel( "tag_origin" );
	self thread stunFxThink( self.stun_fx );
	wait ( 0.1 );
	
	self.stun_fx PlaySound ( "dst_disable_spark" );
	time = 0;
	while( time < duration )
	{
		if ( int(time * 10) % 20 == 0 )
		{
			if( isdefined(isDead) && isDead )
			{
				PlayFXOnTag( level.auto_turret_settings[self.turretType].disableFX, self.stun_fx, "tag_origin" );
			}
			if( isdefined(isEMP) && isEMP )
			{
				PlayFXOnTag( level.auto_turret_settings[self.turretType].stunFX, self.stun_fx, "tag_origin" );		
			}
		}
		wait ( 0.25 );
		time += 0.25;
	}
}

function scramblerStun( stun )
{
	if ( stun )
	{
		self thread stunTurret( false, true );
	}
	else
	{
		self SetMode( "auto_nonai" );

		if( self.turretType != "tow" && !self.controlled )
			self thread _mgturret::burst_fire_unmanned();

		self notify("turret_stun_ended");
		level notify( "turret_stun_ended", self );
	}
}

function watchScramble()
{
	self endon( "death" );
	self endon( "turret_deactivated" );
	self endon( "turret_carried" );

	if ( self scrambler::checkScramblerStun() )
	{
		self thread scramblerStun( true );
	}

	for ( ;; )
	{
		level util::waittill_any( "scrambler_spawn", "scrambler_death", "hacked", "turret_stun_ended" );
		{wait(.05);};

		if ( self scrambler::checkScramblerStun() )
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
function destroyTurret()
{
	self waittill( "destroy_turret", playDeathAnim );
	self remove_turret_dangerous_nodes();

	if( self.turretType == "sentry" )
	{
		killstreakrules::killstreakStop( "autoturret", self.team, self.killstreak_id );
		if( isdefined( self.owner ) && isdefined( self.owner.remoteWeapon ))
		{
			if ( self == self.owner.remoteWeapon )
			{
				self notify( "removed_on_death" );
				self.owner notify( "remove_remote_weapon", true );
			}
		}
		else if( isdefined( self.owner )  && !isdefined( self.owner.remoteWeapon ) )
		{
			self.owner notify( "find_remote_weapon" );
		}
	}
	else if ( self.turretType == "tow" )
	{
		killstreakrules::killstreakStop( "auto_tow", self.team, self.killstreak_id );
	}
	else if ( self.turretType == "microwave" )
	{
		self notify ( "microwave_end_fx" );
		killstreakrules::killstreakStop( "microwaveturret", self.team, self.killstreak_id );
	}

	if ( isdefined(self.controlled) && self.controlled == true && isdefined( self.owner ))
	{
		self.owner SendKillstreakDamageEvent( 600 );
		self.owner ai_tank::destroy_remote_hud();	
	}
	
	//Turn off the turret
	self.turret_active = false;
	self.curr_time = -1;
	self SetMode( "auto_ai" );
	self notify( "stop_burst_fire_unmanned" );
	self notify( "turret_deactivated" );
	self DeleteTurretUseTrigger();
	
	if( isdefined( playDeathAnim ) && playDeathAnim && !self.carried )
	{
		// show like it's stunned before we blow it up & play some sound
		self playsound ("dst_equipment_destroy");
		self stunTurret( self.stunDuration, true, self.stunnedByTacticalGrenade );
	}

	//Drop any ballistic knives that may be attached to the turret.
	level notify( "drop_objects_to_ground", self.origin, 80 );
	
	self spawning::remove_influencers();

	self SetTurretMinimapVisible( false );
	self LaserOff();
	
	wait( 0.1 );

	if( isdefined( self ) ) 
	{
		if( self.hasBeenPlanted )
		{
			PlayFX( level.auto_turret_settings[self.turretType].explodeFX, self.origin, self.angles );
			self playsound ("mpl_turret_exp");
		}

		if( self.carried && isdefined( self.owner ) )
		{
			self.owner stopCarryTurret( self );
			self.owner util::_enableWeapon();
		}
		self Delete();
	}
}

//Delete the turret retrieve trigger
function DeleteTurretUseTrigger()
{
	self remove_turret_dangerous_nodes();
		
	if( isdefined( self.pickUpTrigger ) )
		self.pickUpTrigger delete();
	if( isdefined( self.hackerTrigger ) )
	{
		if ( isdefined( self.hackerTrigger.progressBar ) )
		{
			self.hackerTrigger.progressBar hud::destroyElem();
			self.hackerTrigger.progressText hud::destroyElem();
		}
		self.hackerTrigger delete();
	}
	if( isdefined( self.disableTrigger ) )
	{
		if ( isdefined( self.disableTrigger.progressBar ) )
		{
			self.disableTrigger.progressBar hud::destroyElem();
			self.disableTrigger.progressText hud::destroyElem();
		}
		self.disableTrigger delete();
	}
}


///////////////////////////////////////////////////////
//		Turret Use Trigger Functions
///////////////////////////////////////////////////////

//Spawn a radius trigger so the player can retrieve their turret
function spawnTurretPickUpTrigger( player )
{
	pos = self.origin + (0,0,15);
	self.pickUpTrigger = spawn( "trigger_radius_use", pos );
	
	self.pickUpTrigger SetCursorHint( "HINT_NOICON", self );
	
	if( isdefined(level.auto_turret_settings[self.turretType].hintString) )
		self.pickUpTrigger SetHintString( level.auto_turret_settings[self.turretType].hintString );
	else
		self.pickUpTrigger SetHintString( &"MP_GENERIC_PICKUP" );

	if ( level.teamBased )
		self.pickUpTrigger SetTeamForTrigger( player.team );
	player ClientClaimTrigger( self.pickUpTrigger );
	self thread watchTurretUse( self.pickUpTrigger );
}

//Watch to see if the player wishes to pick up their turret
function watchTurretUse( trigger )
{
	self endon( "delete" );
	self endon( "turret_deactivated" );
	self endon( "turret_carried" );
	
	while ( true )
	{
		trigger waittill( "trigger", player );
			
		if ( !isAlive( player ) )
			continue;
		
		if ( player isUsingOffhand() )
			continue;

		if ( !player isOnGround() )
			continue;
			
		if ( isdefined( trigger.triggerTeam ) && ( player.team != trigger.triggerTeam ) )
			continue;
			
		if ( isdefined( trigger.claimedBy ) && ( player != trigger.claimedBy ) )
			continue;
			
		if ( player useButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed() && !player attackButtonPressed() && !( player killstreaks::is_interacting_with_object() ) && !player IsRemoteControlling() )
		{
			self spawning::remove_influencers();
			
			// rumble on pickup
			player PlayRumbleOnEntity( "damage_heavy" );
			self PlaySound ("mpl_turret_down");
			self DeleteTurretUseTrigger();			
			if (self.turretType == "microwave")
			{
				self notify ( "microwave_end_fx" );
			}

			if ( isdefined( player.remoteWeapon ) && player.remoteWeapon == self )
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
function turret_target_aquired_watch( player )
{
	level endon( "game_ended" );
	self endon( "death" );
	self endon( "destroy_turret" );
	player endon( "disconnect" );

	for(;;)
	{
		self waittill( "turret_target_aquired" );

		if( !self.remoteControlled )
			self LaserOn();
	}
}

function turret_target_lost_watch( player )
{
	level endon( "game_ended" );
	self endon( "death" );
	self endon( "destroy_turret" );
	player endon( "disconnect" );


	for(;;)
	{
		self waittill( "turret_target_lost" );

		if( !self.remoteControlled )
			self LaserOff();
	}
}

function turret_sentry_think( player )
{
	self endon ( "destroy_turret" );
	self.pickUpTrigger endon ( "trigger" );

	player remote_weapons::initRemoteWeapon( self, "killstreak_remote_turret");

	//Wait for turret to get set and placed before allowing it to fire
	wait( level.auto_turret_settings[self.turretType].turretInitDelay );

	self thread _mgturret::burst_fire_unmanned();
}

function turret_tow_think( player )
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

function deleteTriggerOnParentDeath( trigger )
{
	self waittill( "death" );
	if ( isdefined( trigger ) )
	{
		trigger delete();
	}
}

function doesMicrowaveTurretAffectEntity( entity )
{
	if ( !IsAlive( entity ) )
		return false;
		
	if ( !IsPlayer( entity ) && !IsAi(entity))
		return false;
		
	if ( isdefined(self.carried) && self.carried )
		return false;
		
	if ( self weaponobjects::isStunned() )
		return false;
	
	if ( isdefined( self.owner ) && entity == self.owner )
		return false;
	
	if ( !weaponobjects::friendlyFireCheck( self.owner, entity, 0 ) )
		return false;
	
	if ( DistanceSquared( entity.origin, self.origin ) > level.microwave_radius * level.microwave_radius )
		return false;
		
	entDirection = vectornormalize( entity.origin - self.origin );
	forward = anglesToForward( self.angles );
	dot = vectorDot( entDirection, forward );
	if ( dot < level.microwave_turret_cone_dot )
		return false;
	
	pitchDifference =  int( abs( vectortoangles(entDirection)[0] - self.angles[0])) % 360;
	if ( pitchDifference > 15 && pitchDifference < 345 )
		return false;
	
	if ( entity damageConeTrace( self.origin + (0,0,40), self ) <= 0 )
		return false;
	
	return true;
}

function microwaveEntity( entity )
{
	entity endon( "disconnect" );
	
	entity.beingMicrowaved = true;
	entity.beingMicrowavedBy = self.owner;
	entity.microwaveEffect = 0;
	
	for ( ;; )
	{
		if ( !isdefined( self ) || !self doesMicrowaveTurretAffectEntity( entity ))
		{
			if( !isdefined(entity))
			{
				return;
			}
			entity.beingMicrowaved = false;
			entity.beingMicrowavedBy = undefined;
			
			if ( isdefined( entity.microwavePoisoning ) && entity.microwavePoisoning )
			{
				entity.microwavePoisoning = false;
			}
			return;
		}
		
		damage = level.microwave_turret_damage;
		
		if ( level.hardcoreMode )
		{
			damage = damage / 2;	
		}
		
		if ( !IsAi(entity) && entity util::mayApplyScreenEffect() )
		{
			if ( !isdefined( entity.microwavePoisoning ) || !entity.microwavePoisoning )
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
			GetWeapon( "microwave_turret" ) // Weapon The weapon used to inflict the damage
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
			if( entity.microwaveEffect % 3 == 2 )
			{
				scoreevents::processScoreEvent( "hpm_suppress", self.owner, entity );
			}
		}
		
		wait 0.5;
	}
}

function turret_microwave_think( player )
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
	self thread turret_microwave_watchForDogs( trigger, player );

	for ( ;; )
	{
		trigger waittill( "trigger", ent );
		
		if ( !isdefined( ent.beingMicrowaved ) || !ent.beingMicrowaved )
		{
			self thread microwaveEntity( ent );
		}
	}
}

function turret_microwave_watchForDogs( trigger, player )
{
	self endon( "death" ); 
	level endon( "game_ended" );
	self endon( "stop_microwave" );
	self endon( "destroy_turret" );
	damage = level.microwave_turret_damage;

	for(;;)
	{
		dogs = GetEntArray( "attack_dog", "targetname" );
		foreach( dog in dogs )
		{
			if ( dog.team == player.team ) 
				continue;
			
			if ( dog IsTouching( trigger ) == false )
				continue;
			
			if ( self doesMicrowaveTurretAffectDog( dog ) == false ) 
				continue;

			dog.flashduration = 1000;
			
			dog DoDamage(
				damage, // iDamage Integer specifying the amount of damage done
				self.origin, // vPoint The point the damage is from?
				self.owner, // eAttacker The entity that is attacking.
				self, // eInflictor The entity that causes the damage.(e.g. a turret)
				0, 
				"MOD_TRIGGER_HURT", // sMeansOfDeath Integer specifying the method of death
				0, // iDFlags Integer specifying flags that are to be applied to the damage
				GetWeapon( "microwave_turret" ) // sWeapon The weapon used to inflict the damage
			);	
		}
		wait( 0.5 );
	}
}

function doesMicrowaveTurretAffectDog( entity )
{
	if ( !IsAlive( entity ) )
		return false;
		
	if ( !IsPlayer( entity ) && !IsAi(entity))
		return false;
		
	if ( isdefined(self.carried) && self.carried )
		return false;
		
	if ( self weaponobjects::isStunned() )
		return false;
	
	if ( isdefined( self.owner ) && entity == self.owner )
		return false;
	
	if ( DistanceSquared( entity.origin, self.origin ) > level.microwave_radius * level.microwave_radius )
		return false;
		
	entDirection = vectornormalize( entity.origin - self.origin );
	forward = anglesToForward( self.angles );
	dot = vectorDot( entDirection, forward );
	if ( dot < level.microwave_turret_cone_dot )
		return false;
	
	pitchDifference =  int( abs( vectortoangles(entDirection)[0] - self.angles[0])) % 360;
	if ( pitchDifference > 15 && pitchDifference < 345 )
		return false;
	
	if ( entity damageConeTrace( self.origin + (0,0,40), self ) <= 0 )
		return false;
	
	return true;
}

function microwave_fx()
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

function waitTillEndFX()
{
	self endon( "death" );
	self waittill( "microwave_end_fx" );
	
	self clientfield::set( "turret_microwave_sounds", 0 );
}

function update_microwave_fx()
{
	angles = self GetTagAngles( "tag_flash" );
	origin = self GetTagOrigin( "tag_flash" );
	forward = AnglesToForward( angles );
	forward = VectorScale( forward, level.microwave_radius );
	forwardRight = AnglesToForward( angles - (0, level.microwave_turret_angle / 3, 0) );
	forwardRight = VectorScale( forwardRight, level.microwave_radius );
	forwardLeft = AnglesToForward( angles + (0, level.microwave_turret_angle / 3, 0) );
	forwardLeft = VectorScale( forwardLeft, level.microwave_radius );

	trace = BulletTrace( origin, origin + forward, false, self );
	traceRight = BulletTrace( origin, origin + forwardRight, false, self );
	traceLeft = BulletTrace( origin, origin + forwardLeft, false, self );
	
	FXHash = self microwave_fx_hash( trace, origin );
	FXHashRight = self microwave_fx_hash( traceRight, origin );
	FXHashLeft = self microwave_fx_hash( traceLeft, origin );
	if ( isdefined( self.microwaveFXHash ) && self.microwaveFXHash == FXHash &&  
	     isdefined( self.microwaveFXHashRight ) && self.microwaveFXHashRight == FXHashRight && 
	     isdefined( self.microwaveFXHashLeft ) && self.microwaveFXHashLeft == FXHashLeft )
	{
		return;
	}
	
	if ( isdefined ( self.microwaveFXEnt ) ) 
	{
		 self.microwaveFXEnt util::deleteAfterTime( 0.1 );
	}
	
	self.microwaveFXEnt = spawn("script_model", origin);
	self.microwaveFXEnt SetModel("tag_microwavefx");
	self.microwaveFXEnt.angles = angles;
	self thread deleteOnEndFX();
		
	self.microwaveFXHash = FXHash;
	self.microwaveFXHashRight = FXHashRight;
	self.microwaveFXHashLeft = FXHashLeft;
	
	wait( 0.1 );
	
	self.microwaveFXEnt microwave_play_fx( trace, traceRight, TraceLeft, origin );
	
	self clientfield::set( "turret_microwave_sounds", 1 );
}


function deleteOnEndFX()
{
	self.microwaveFXEnt endon( "death" );
	self waittill ( "microwave_end_fx" );
	self.microwaveFXHash = undefined;
	self.microwaveFXHashRight = undefined;
	self.microwaveFXHashLeft = undefined;
	if ( isdefined( self.microwaveFXEnt ) )
	{
		self.microwaveFXEnt delete();
	}
}

function microwave_fx_hash( trace, origin )
{
	hash = 0;
	counter = 1;
	for ( i = 0; i < 5; i++ )
	{
		distSq = ( i * level.microwave_fx_size ) * ( i * level.microwave_fx_size );

		if ( DistanceSquared( origin, trace[ "position" ] ) >= distSq )
		{
			hash += counter;
		}
		counter *= 2;
	}
	return hash;
}

function microwave_play_fx( trace, traceRight, traceLeft, origin )
{
	rows = 5;
	
	for ( i = 0; i < rows; i++ )
	{
		distSq = ( i * level.microwave_fx_size ) * ( i * level.microwave_fx_size );

		if ( DistanceSquared( origin, trace[ "position" ] ) >= distSq )
		{
			switch ( i )
			{
				case 0:
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx11" );
					{wait(.05);};
					break;					
				case 1:
					break;
				case 2:
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx32" );
					{wait(.05);};
					break;
				case 3:
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx42" );
					{wait(.05);};
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx43" );
					{wait(.05);};
					break;
				case 4:
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx53" );
					{wait(.05);};
					break;
			}
		}
		
		if ( DistanceSquared( origin, traceLeft[ "position" ] ) >= distSq )
		{
			switch ( i )
			{
				case 0:
					break;					
				case 1:
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx22" );
					{wait(.05);};
					break;
				case 2:
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx33" );
					{wait(.05);};
					break;
				case 3:
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx44" );
					{wait(.05);};
					break;
				case 4:
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx54" );	
					{wait(.05);};				
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx55" );
					{wait(.05);};
					break;
			}
		}
		
		if ( DistanceSquared( origin, traceRight[ "position" ] ) >= distSq )
		{
			switch ( i )
			{
				case 0:
					break;					
				case 1:
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx21" );
					{wait(.05);};
					break;
				case 2:
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx31" );
					{wait(.05);};
					break;
				case 3:
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx41" );
					{wait(.05);};
					break;
				case 4:
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx51" );	
					{wait(.05);};				
					PlayFxOnTag( level.auto_turret_settings["microwave"].fx, self, "tag_fx52" );
					{wait(.05);};
					break;
			}
		}
	}
}

function do_tow_shoot( player )
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

function missile_fired_notify() // self == tow turret
{
	self endon( "turret_deactivated" );
	self endon( "death" );
	level endon( "game_ended" );
	if( isdefined( self.owner ) )
	{
		self.owner endon( "disconnect" );
	}

	while ( true )
	{
		self waittill( "missile_fire", missile, weapon, target );

		if( isdefined( target ) )
		{
			target notify( "stinger_fired_at_me", missile, weapon, self.owner );
		}
	}
}

///////////////////////////////////////////////////////
//		Turret Hacking Functions
///////////////////////////////////////////////////////
function spawnTurretHackerTrigger( player )
{
	triggerOrigin = self.origin + ( 0, 0, 10 );

	// set up a trigger for a hacker
	self.hackerTrigger = spawn( "trigger_radius_use", triggerOrigin, level.weaponobjects_hacker_trigger_width, level.weaponobjects_hacker_trigger_height );

	/#
		//_teargrenades::drawcylinder( self.hackerTrigger.origin, level.weaponobjects_hacker_trigger_width, level.weaponobjects_hacker_trigger_height, 0, "hacker_debug" );	
	#/

	self.hackerTrigger SetCursorHint( "HINT_NOICON", self );

	self.hackerTrigger SetIgnoreEntForTrigger( self );
	self.hackerTrigger SetHintString( level.auto_turret_settings[ self.turretType ].hackerHintString );
	
	self.hackerTrigger SetPerkForTrigger( "specialty_disarmexplosive" );
	self.hackerTrigger thread weaponobjects::hackerTriggerSetVisibility( player );

	self thread hackerThink( self.hackerTrigger, player );
}

function hackerThink( trigger, owner ) // self == turret entity
{
	self endon( "death" );

	for ( ;; )
	{
		trigger waittill( "trigger", player, instant );

		if ( !isdefined( instant ) && !trigger weaponobjects::hackerResult( player, owner )  )
		{
			continue;
		}

		// stop and start the killstreak rules before we change the team for the turret
		if( self.turretType == "sentry" )
		{
			killstreakrules::killstreakStop( "autoturret", self.team, self.killstreak_id );
			killstreak_id = player killstreakrules::killstreakStart( "autoturret", player.team, true );
			self.killstreak_id = killstreak_id;
		}
		else if ( self.turretType == "tow" )
		{
			killstreakrules::killstreakStop( "auto_tow", self.team, self.killstreak_id );
			killstreak_id = player killstreakrules::killstreakStart( "auto_tow", player.team, true );
			self.killstreak_id = killstreak_id;
		}
		else if ( self.turretType == "microwave" )
		{
			killstreakrules::killstreakStop( "microwaveturret", self.team, self.killstreak_id );
			killstreak_id = player killstreakrules::killstreakStart( "microwaveturret", player.team, true );
			self.killstreak_id = killstreak_id;
		}

		scoreevents::processScoreEvent( "hacked", player, self );
		
		// change the owner and team for the turret
		if( level.teamBased )
		{
			self.team = player.team;
		}
		else
		{
			self.team = "free";
		}
		
		if( isdefined( self.owner ) && isdefined( self.owner.remoteWeapon ))
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

		self thread stunTurretTacticalGrenade( 1.5 );
		wait( 1.5 );

		if ( isdefined( player ) && player.sessionstate == "playing" )
		{
			player thread watchOwnerDisconnect( self );
			player thread watchOwnerTeamKillKicked( self );
		}

		offset = level.turrets_headicon_offset[ "default" ];
		if( isdefined( level.turrets_headicon_offset[ self.turretType ] ) )
		{
			offset = level.turrets_headicon_offset[ self.turretType ];
		}
		self entityheadicons::setEntityHeadIcon( player.pers["team"], player, offset );

		self spawnTurretHackerTrigger( player );
		if( self.turretType == "sentry" )
		{
			player remote_weapons::initRemoteWeapon( self, "killstreak_remote_turret");
		}		
		return;
	}
}

//Turret disable Trigger
function spawnTurretDisableTrigger( player )
{
	triggerOrigin = self.origin + ( 0, 0, 10 );

	// set up a trigger for disable
	self.disableTrigger = spawn( "trigger_radius_use", triggerOrigin, level.weaponobjects_hacker_trigger_width, level.weaponobjects_hacker_trigger_height );

	self.disableTrigger SetCursorHint( "HINT_NOICON", self );

	self.disableTrigger SetIgnoreEntForTrigger( self );
	self.disableTrigger SetHintString( level.auto_turret_settings[ self.turretType ].disableHintString );
	
	self.disableTrigger thread weaponobjects::hackerTriggerSetVisibility( player );

	self thread disableTriggerThink( self.disableTrigger, player );
}

function disableTriggerThink( trigger, owner ) // self == turret entity
{
	self endon( "death" );

	for ( ;; )
	{
		trigger waittill( "trigger", attacker );
		
		if ( !trigger disableResult( attacker, owner )  )
		{
			continue;
		}

		if ( self util::IsEnemyPlayer( attacker ) )
		{
			// per feedback we want to see a medal pop up even if killstreaks destroy stuff (SAM Turret shooting things down, etc.)
			if ( self.turretType == "sentry" )
			{
				scoreevents::processScoreEvent( "destroyed_sentry_gun", attacker, self, "knife" );
			}
			else if ( self.turretType == "microwave" )
			{
				scoreevents::processScoreEvent( "destroyed_microwave_turret", attacker, self, "knife" );
			}

			if ( self.hardPointWeapon != level.weaponNone )
			{
				level.globalKillstreaksDestroyed++;
				attacker AddWeaponStat( self.hardPointWeapon, "destroyed", 1 );
			}
		}

		//Inform the player that their turret was destroyed
		if ( isdefined(self.owner) && IsPlayer(self.owner))
		{
			owner = self.owner;
		}
		self notify( "destroy_turret", true );
	}
	
}

function disableResult( player, owner ) // self == trigger_radius
{
	success = true;
	time = GetTime();
	hackTime = GetDvarfloat( "perk_disarmExplosiveTime" );

	if ( !canDisable( player, owner, true ) )
	{
		return false;
	}

	self thread weaponobjects::hackerUnfreezePlayer( player );

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

		if ( !isdefined( self ) )
		{
			success = false;
			break;
		}

		player util::freeze_player_controls( true );
		player DisableWeapons();

		if ( !isdefined( self.progressBar ) )
		{
			self.progressBar = player hud::createPrimaryProgressBar();
			self.progressBar.lastUseRate = -1;
			self.progressBar hud::showElem();
			self.progressBar hud::updateBar( 0.01, 1 / hackTime );

			self.progressText = player hud::createPrimaryProgressBarText();
			self.progressText setText( &"MP_DISABLING" );
			self.progressText hud::showElem();
			player PlayLocalSound ( "evt_hacker_hacking" );
		}
		
		{wait(.05);};
	}

	if ( isdefined( player ) )
	{
		player util::freeze_player_controls( false );
		player EnableWeapons();
	}

	if ( isdefined( self.progressBar ) )
	{
		self.progressBar hud::destroyElem();
		self.progressText hud::destroyElem();
	}

	if ( isdefined( self ) )
	{
		self notify( "hack_done" );
	}

	return success;
}

function canDisable( player, owner, weapon_check )
{
	if ( !isdefined( player ) )
		return false;
	
	if ( !IsPlayer( player ) )
		return false;

	if ( !IsAlive( player ) )
		return false;

	if ( !isdefined( owner ) )
		return false;

	if ( owner == player )
		return false;
		
	if ( level.teambased && player.team == owner.team )
		return false;

	if ( ( isdefined( player.isDefusing ) && player.isDefusing ) )
		return false;

	if ( ( isdefined( player.isPlanting ) && player.isPlanting ) )
		return false;

	if ( isdefined( player.proxBar ) && !player.proxBar.hidden )
		return false;

	if ( isdefined( player.revivingTeammate ) && player.revivingTeammate == true )
		return false;

	if ( !player IsOnGround() )
		return false;
		
	if ( player IsInVehicle() )
		return false;

	if ( player IsWeaponViewOnlyLinked() )
		return false;

	if ( player HasPerk( "specialty_disarmexplosive" ) )
		return false;

	if ( isdefined( player.laststand ) && player.laststand )
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

		if ( weapon == level.weaponNone )
			return false;

		if ( weapon.isEquipment && player IsFiring() )
			return false;

		if ( weapon.isSpecificUse )
			return false;
	}

	return true;
}

///////////////////////////////////////////////////////
//		Turret Scanning Functions
///////////////////////////////////////////////////////
function TurretScanStartWaiter()
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

function TurretScanStopWaiter(ent)
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
function TurretScanStopWaiterCleanup(ent)
{
	level endon( "game_ended" );
	
	self util::waittill_any( "death", "disconnect", "turret_deactivated" );
	
	self notify ("turret_sound_cleanup");
	
	wait .1;
/#	println ("snd scan delete");		#/	
	
	if ( isdefined (ent))
	{	
			ent delete();
	}
	
}
function turretScanStopNotify()
{
	
}		

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function startTurretRemoteControl( turret ) // self == player
{
	self.killstreak_waitamount = level.auto_turret_timeout * 1000;
	turret MakeTurretUsable();

	arc_limits = turret GetTurretArcLimits();

	self PlayerLinkWeaponViewToDelta( turret, "tag_player", 0, arc_limits[ "arc_max_yaw" ], -arc_limits[ "arc_min_yaw" ], -arc_limits[ "arc_min_pitch" ], arc_limits[ "arc_max_pitch" ] );
	self PlayerLinkedSetUseBaseAngleForViewClamp( true );

	self RemoteControlTurret( turret );
	turret LaserOn();
	turret.remoteControlled = true;

	turret SetMode( "manual" );

	self thread watchRemoteSentryFire( turret );
	//self thread create_remote_turret_hud( turret );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchRemoteSentryFire( turret ) // self == player
{
	self endon("stopped_using_remote");
	turret endon("death");
	self endon("disconnect");
	level endon ( "game_ended" );
	
	while( true )
	{
		if ( self AttackButtonPressed() && turret.stunnedByTacticalGrenade == false )
		{
			weapon = GetWeapon( "auto_gun_turret" );
			fireTime = weapon.fireTime;
			
			Earthquake( 0.15, 0.2, turret.origin, 200 );
			
			wait( fireTime );
		}
		else
		{
			{wait(.05);}; 				
		}
	}
}

function endRemoteTurret( turret, isDead ) // self == player
{
	if( isdefined( self ) && isdefined( turret ) && turret.remoteControlled )
	{
		self RemoteControlTurretOff( turret );
		self remove_turret_hint_hud();
	}
	turret MakeTurretUnusable();
	turret LaserOff();
	turret.remoteControlled = false;

	turret SetMode( "auto_nonai" );

	if ( !isDead )
	{
		turret thread _mgturret::burst_fire_unmanned();
		//PlayFXOnTag( level.auto_turret_settings[turret.turretType].laserFX, turret, "tag_laser" );
	}
}

function stop_remote()
{
	if ( !isdefined( self ) )
		return;

	self killstreaks::clear_using_remote();
	self.killstreak_waitamount = undefined;
	self ai_tank::destroy_remote_hud();
	self remove_turret_hint_hud();
}

//******************************************************************
//     Turret Tutorial HUD                                                            *
//                                                                 *
//******************************************************************

function create_remote_turret_hud( remote )
{
	self.fire_turret_hud = newclienthudelem( self );
	self.fire_turret_hud.alignX = "left";
	self.fire_turret_hud.alignY = "bottom";
	self.fire_turret_hud.horzAlign = "user_left";
	self.fire_turret_hud.vertAlign = "user_bottom";
	self.fire_turret_hud.font = "small";
	self.fire_turret_hud SetText( &"MP_FIRE_SENTRY_GUN" );
	self.fire_turret_hud.hidewheninmenu = true;
	self.fire_turret_hud.hideWhenInDemo = true;
	self.fire_turret_hud.archived = false;
	self.fire_turret_hud.x = 25;
	self.fire_turret_hud.y = -25;
	self.fire_turret_hud.fontscale = 1.25;

	self.zoom_turret_hud = newclienthudelem( self );
	self.zoom_turret_hud.alignX = "left";
	self.zoom_turret_hud.alignY = "bottom";
	self.zoom_turret_hud.horzAlign = "user_left";
	self.zoom_turret_hud.vertAlign = "user_bottom";
	self.zoom_turret_hud.font = "small";
	self.zoom_turret_hud SetText( &"KILLSTREAK_INCREASE_ZOOM" );
	self.zoom_turret_hud.hidewheninmenu = true;
	self.zoom_turret_hud.hideWhenInDemo = true;
	self.zoom_turret_hud.archived = false;
	self.zoom_turret_hud.x = 25;
	self.zoom_turret_hud.y = -40;
	self.zoom_turret_hud.fontscale = 1.25;
	
	self thread fade_out_hint_hud();
}

function fade_out_hint_hud()
{
	wait( 8 );
	time = 0;
	while (time < 2)
	{
		if ( !isdefined(self.fire_turret_hud))
		{
			return;	
		}
		self.fire_turret_hud.alpha -= 0.025;
		self.zoom_turret_hud.alpha -= 0.025;
		time += 0.05;
		{wait(.05);};
	}
	
	self.fire_turret_hud.alpha = 0;
	self.zoom_turret_hud.alpha = 0;
}

function remove_turret_hint_hud()
{
	if ( isdefined(self.fire_turret_hud) )
		self.fire_turret_hud destroy();
	if ( isdefined(self.zoom_turret_hud) )
		self.zoom_turret_hud destroy();	
}

function remove_turret_dangerous_nodes()
{
	if ( isdefined( self.dangerous_nodes ) )
	{
		foreach( node in self.dangerous_nodes )
		{
			foreach( team in level.teams )
			{
				node SetDangerous( team, false );
			}
		}
	}

	self.dangerous_nodes = [];
}

//This function needs to be used in the main function in level scripts to place triggers post ship
function addNoTurretTrigger( position, radius, height )
{
    level waittill( "no_turret_trigger_created" );
                    
    trigger = Spawn( "trigger_radius", position, 0, radius, height );
    
    level.noTurretPlacementTriggers[level.noTurretPlacementTriggers.size] = trigger;
}

///////////////////////////////////////////////////////
//		Turret Debug Functions
///////////////////////////////////////////////////////
function turret_debug_box( origin, mins, maxs, color )
{
/#
	debug_turret = GetDvarString( "debug_turret" );
	if ( debug_turret == "1" )
	{
		box( origin, mins, maxs, 0, color, 1, 1, 300 );
	}
#/
}

function turret_debug_line( start, end, color )
{
/#
	debug_turret = GetDvarString( "debug_turret" );
	if ( debug_turret == "1" )
	{
			line(start, end, color, 1, 1, 300);
	}
#/
}
