#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\weapons\_smokegrenade;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_callbacks;
#using scripts\cp\_challenges;
#using scripts\cp\_hacker_tool;
#using scripts\cp\_scoreevents;
#using scripts\cp\_tacticalinsertion;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_ai_tank;
#using scripts\cp\killstreaks\_airsupport;
#using scripts\cp\killstreaks\_emp;
#using scripts\cp\killstreaks\_helicopter;
#using scripts\cp\killstreaks\_killstreak_weapons;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\killstreaks\_supplydrop;

#using_animtree ( "mp_vehicles" );

#precache( "material", "compass_supply_drop_black" );
#precache( "material", "compass_supply_drop_green" );
#precache( "material", "compass_supply_drop_red" );
#precache( "material", "waypoint_recon_artillery_strike" );

// TODO: this is a placeholder head icon for when a supply drop is hacked and a booby trap is made
#precache( "material", "headicon_dead" );
#precache( "string", "KILLSTREAK_CAPTURING_CRATE" );
#precache( "string", "KILLSTREAK_SUPPLY_DROP_DISARM_HINT" );
#precache( "string", "KILLSTREAK_SUPPLY_DROP_DISARMING_CRATE" );

#precache( "string", "KILLSTREAK_AI_TANK_CRATE" );
#precache( "string", "KILLSTREAK_MINIGUN_CRATE" );
#precache( "string", "PLATFORM_MINIGUN_GAMBLER" );
#precache( "string", "KILLSTREAK_M32_CRATE" );
#precache( "string", "PLATFORM_M32_GAMBLER" );
#precache( "string", "KILLSTREAK_AMMO_CRATE" );
#precache( "string", "PLATFORM_AMMO_CRATE_GAMBLER" );
#precache( "string", "KILLSTREAK_RADAR_CRATE" );
#precache( "string", "PLATFORM_RADAR_GAMBLER" );
#precache( "string", "KILLSTREAK_RCBOMB_CRATE" );
#precache( "string", "PLATFORM_RCBOMB_GAMBLER" );
#precache( "string", "KILLSTREAK_MISSILE_DRONE_CRATE" );
#precache( "string", "PLATFORM_MISSILE_DRONE_GAMBLER" );
#precache( "string", "KILLSTREAK_COUNTERU2_CRATE" );
#precache( "string", "PLATFORM_COUNTERU2_GAMBLER" );
#precache( "string", "KILLSTREAK_REMOTE_MISSILE_CRATE" );
#precache( "string", "PLATFORM_REMOTE_MISSILE_GAMBLER" );
#precache( "string", "KILLSTREAK_PLANE_MORTAR_CRATE");
#precache( "string", "PLATFORM_PLANE_MORTAR_GAMBLER" );
#precache( "string", "KILLSTREAK_AUTO_TURRET_CRATE" );
#precache( "string", "PLATFORM_AUTO_TURRET_GAMBLER" );
#precache( "string", "KILLSTREAK_MICROWAVE_TURRET_CRATE" );
#precache( "string", "PLATFORM_MICROWAVE_TURRET_GAMBLER" );
#precache( "string", "KILLSTREAK_MINIGUN_CRATE" );
#precache( "string", "PLATFORM_MINIGUN_GAMBLER" );
#precache( "string", "KILLSTREAK_M32_CRATE" );
#precache( "string", "PLATFORM_M32_GAMBLER" );
#precache( "string", "KILLSTREAK_HELICOPTER_GUARD_CRATE" );
#precache( "string", "PLATFORM_HELICOPTER_GUARD_GAMBLER" );
#precache( "string", "KILLSTREAK_SATELLITE_CRATE" );
#precache( "string", "PLATFORM_SATELLITE_GAMBLER" );
#precache( "string", "KILLSTREAK_QRDRONE_CRATE" );
#precache( "string", "PLATFORM_QRDRONE_GAMBLER" );
#precache( "string", "KILLSTREAK_AI_TANK_CRATE" );
#precache( "string", "PLATFORM_AI_TANK_GAMBLER" );
#precache( "string", "KILLSTREAK_HELICOPTER_CRATE" );
#precache( "string", "PLATFORM_HELICOPTER_GAMBLER" );
#precache( "string", "KILLSTREAK_EMP_CRATE" );
#precache( "string", "PLATFORM_EMP_GAMBLER" );
#precache( "string", "KILLSTREAK_REMOTE_MORTAR_CRATE" );
#precache( "string", "PLATFORM_REMOTE_MORTAR_GAMBLER" );
#precache( "string", "KILLSTREAK_HELICOPTER_GUNNER_CRATE" );
#precache( "string", "PLATFORM_HELICOPTER_GUNNER_GAMBLER" );
#precache( "string", "KILLSTREAK_DOGS_CRATE" );
#precache( "string", "PLATFORM_DOGS_GAMBLER" );
#precache( "string", "KILLSTREAK_STRAFERUN_CRATE" );
#precache( "string", "PLATFORM_STRAFERUN_GAMBLER" );
#precache( "string", "KILLSTREAK_MISSILE_SWARM_CRATE" );
#precache( "string", "PLATFORM_MISSILE_SWARM_GAMBLER" );
#precache( "string", "KILLSTREAK_EARNED_SUPPLY_DROP" );
#precache( "string", "KILLSTREAK_AIRSPACE_FULL" );
#precache( "string", "KILLSTREAK_SUPPLY_DROP_INBOUND" );
#precache( "eventstring", "mpl_killstreak_supply" );
#precache( "fx", "_t6/env/smoke/fx_smoke_supply_drop_blue_mp" );
//#precache( "fx", "_t6/explosions/fx_grenadeexp_default" );//TODO T7 - contact FX team to get proper replacement

#namespace supplydrop;

function init()
{
	level.crateModelFriendly = "t6_wpn_supply_drop_ally";
	level.crateModelEnemy = "t6_wpn_supply_drop_axis";	
	level.crateModelHacker = "t6_wpn_supply_drop_detect";
	level.crateModelTank = "t6_wpn_drop_box";
	level.crateModelBoobyTrapped = "t6_wpn_supply_drop_trap";
	level.supplyDropHelicopterFriendly = "veh_t6_drone_supply";
	level.supplyDropHelicopterEnemy = "veh_t6_drone_supply_alt";
	level.suppyDropHelicopterVehicleInfo = "heli_supplydrop_mp";
	
	level.crateOwnerUseTime = 500;
	level.crateNonOwnerUseTime = GetGametypeSetting("crateCaptureTime") * 1000;
	level.crate_headicon_offset = (0, 0, 15);
	level.supplyDropDisarmCrate = &"KILLSTREAK_SUPPLY_DROP_DISARM_HINT";
	level.disarmingCrate = &"KILLSTREAK_SUPPLY_DROP_DISARMING_CRATE";
	
	level.supplydropCarePackageIdleAnim = %o_drone_supply_care_idle;
	level.supplydropCarePackageDropAnim = %o_drone_supply_care_drop;
	level.supplydropAiTankIdleAnim = %o_drone_supply_agr_idle;
	level.supplydropAiTankDropAnim = %o_drone_supply_agr_drop;
	
	clientfield::register( "helicopter", "supplydrop_care_package_state", 1, 1, "int" );
	clientfield::register( "helicopter", "supplydrop_ai_tank_state", 1, 1, "int" );

	level._supply_drop_smoke_fx = "_t6/env/smoke/fx_smoke_supply_drop_blue_mp";
	level._supply_drop_explosion_fx = "_t6/explosions/fx_grenadeexp_default";

	killstreaks::register("inventory_supply_drop", "inventory_supplydrop", "killstreak_supply_drop", "supply_drop_used",&useKillstreakSupplyDrop, undefined, true );
	killstreaks::register_strings("inventory_supply_drop", &"KILLSTREAK_EARNED_SUPPLY_DROP", &"KILLSTREAK_AIRSPACE_FULL", &"KILLSTREAK_SUPPLY_DROP_INBOUND");
	killstreaks::register_dialog("inventory_supply_drop", "mpl_killstreak_supply", "kls_supply_used", "","kls_supply_enemy", "", "kls_supply_ready");
	killstreaks::register_alt_weapon("inventory_supply_drop", "mp40_blinged" );
	killstreaks::allow_assists("inventory_supply_drop", true);	
	killstreaks::register_dev_dvar("inventory_supply_drop", "scr_givesupplydrop");
	
	killstreaks::register("supply_drop", "supplydrop", "killstreak_supply_drop", "supply_drop_used",&useKillstreakSupplyDrop, undefined, true );
	killstreaks::register_strings("supply_drop", &"KILLSTREAK_EARNED_SUPPLY_DROP", &"KILLSTREAK_AIRSPACE_FULL", &"KILLSTREAK_SUPPLY_DROP_INBOUND");
	killstreaks::register_dialog("supply_drop", "mpl_killstreak_supply", "kls_supply_used", "","kls_supply_enemy", "", "kls_supply_ready");
	killstreaks::register_alt_weapon("supply_drop", "mp40_blinged" );
	killstreaks::allow_assists("supply_drop", true);

	level.crateTypes = [];
	level.categoryTypeWeight = [];
	
	// NOTE: Precache the strings in the top of the file
	registerCrateType( "ai_tank_drop", "killstreak", "ai_tank", 1, &"KILLSTREAK_AI_TANK_CRATE", undefined, undefined, undefined, &ai_tank::crateLand );
	registerCrateType( "inventory_ai_tank_drop", "killstreak", "ai_tank", 1, &"KILLSTREAK_AI_TANK_CRATE", undefined, undefined, undefined, &ai_tank::crateLand );
	
	registerCrateType( "minigun_drop", "killstreak", "minigun", 1, &"KILLSTREAK_MINIGUN_CRATE", &"PLATFORM_MINIGUN_GAMBLER", "share_package_death_machine",&giveCrateWeapon );
	registerCrateType( "inventory_minigun_drop", "killstreak", "minigun", 1, &"KILLSTREAK_MINIGUN_CRATE", &"PLATFORM_MINIGUN_GAMBLER", "share_package_death_machine",&giveCrateWeapon );
	
	registerCrateType( "m32_drop", "killstreak", "m32", 1, &"KILLSTREAK_M32_CRATE", &"PLATFORM_M32_GAMBLER", "share_package_multiple_grenade_launcher",&giveCrateWeapon );
	registerCrateType( "inventory_m32_drop", "killstreak", "m32", 1, &"KILLSTREAK_M32_CRATE", &"PLATFORM_M32_GAMBLER", "share_package_multiple_grenade_launcher",&giveCrateWeapon );
	
	// percentage of drop explanation:
	//		add all of the numbers up: 15 + 2 + 3 + etc. = 80 for example
	//		now if you want to know the percentage of the minigun_mp drop, you'd do (minigun_mp number / total) or 2/80 = 2.5% chance of dropping
	// right now this is at a perfect 1000, so the percentages are easy to understand
	//registerCrateType( "supplydrop", "ammo", "ammo", 0, &"KILLSTREAK_AMMO_CRATE", &"PLATFORM_AMMO_CRATE_GAMBLER", "share_package_ammo",&giveCrateAmmo );
	registerCrateType( "supplydrop", "killstreak", "radar", 100, &"KILLSTREAK_RADAR_CRATE", &"PLATFORM_RADAR_GAMBLER", "share_package_uav",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "rcbomb", 100, &"KILLSTREAK_RCBOMB_CRATE", &"PLATFORM_RCBOMB_GAMBLER", "share_package_rcbomb",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "inventory_missile_drone", 100, &"KILLSTREAK_MISSILE_DRONE_CRATE", &"PLATFORM_MISSILE_DRONE_GAMBLER", "share_package_missile_drone",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "counteruav", 100, &"KILLSTREAK_COUNTERU2_CRATE", &"PLATFORM_COUNTERU2_GAMBLER", "share_package_counter_uav",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "remote_missile", 85, &"KILLSTREAK_REMOTE_MISSILE_CRATE", &"PLATFORM_REMOTE_MISSILE_GAMBLER", "share_package_remote_missile",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "planemortar", 80, &"KILLSTREAK_PLANE_MORTAR_CRATE", &"PLATFORM_PLANE_MORTAR_GAMBLER", "share_package_plane_mortar",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "autoturret", 80, &"KILLSTREAK_AUTO_TURRET_CRATE", &"PLATFORM_AUTO_TURRET_GAMBLER", "share_package_sentry_gun",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "microwaveturret", 120, &"KILLSTREAK_MICROWAVE_TURRET_CRATE", &"PLATFORM_MICROWAVE_TURRET_GAMBLER", "share_package_microwave_turret",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "inventory_minigun", 60, &"KILLSTREAK_MINIGUN_CRATE", &"PLATFORM_MINIGUN_GAMBLER", "share_package_death_machine",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "inventory_m32", 60, &"KILLSTREAK_M32_CRATE", &"PLATFORM_M32_GAMBLER", "share_package_multiple_grenade_launcher",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "helicopter_guard", 20, &"KILLSTREAK_HELICOPTER_GUARD_CRATE", &"PLATFORM_HELICOPTER_GUARD_GAMBLER", "share_package_helicopter_guard",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "radardirection", 20, &"KILLSTREAK_SATELLITE_CRATE", &"PLATFORM_SATELLITE_GAMBLER", "share_package_satellite",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "qrdrone", 20, &"KILLSTREAK_QRDRONE_CRATE", &"PLATFORM_QRDRONE_GAMBLER", "share_package_qrdrone",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "inventory_ai_tank_drop", 20, &"KILLSTREAK_AI_TANK_CRATE", &"PLATFORM_AI_TANK_GAMBLER", "share_package_aitank",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "helicopter_comlink", 20, &"KILLSTREAK_HELICOPTER_CRATE", &"PLATFORM_HELICOPTER_GAMBLER", "share_package_helicopter_comlink",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "emp", 5, &"KILLSTREAK_EMP_CRATE", &"PLATFORM_EMP_GAMBLER", "share_package_emp",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "remote_mortar", 2, &"KILLSTREAK_REMOTE_MORTAR_CRATE", &"PLATFORM_REMOTE_MORTAR_GAMBLER", "share_package_remote_mortar",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "helicopter_player_gunner", 2, &"KILLSTREAK_HELICOPTER_GUNNER_CRATE", &"PLATFORM_HELICOPTER_GUNNER_GAMBLER", "share_package_helicopter_gunner",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "dogs", 2, &"KILLSTREAK_DOGS_CRATE", &"PLATFORM_DOGS_GAMBLER", "share_package_dogs",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "straferun", 2, &"KILLSTREAK_STRAFERUN_CRATE", &"PLATFORM_STRAFERUN_GAMBLER", "share_package_strafe_run",&giveCrateKillstreak );
	registerCrateType( "supplydrop", "killstreak", "missile_swarm", 2, &"KILLSTREAK_MISSILE_SWARM_CRATE", &"PLATFORM_MISSILE_SWARM_GAMBLER", "share_package_missile_swarm",&giveCrateKillstreak );

	//registerCrateType( "inventory_supplydrop", "ammo", "ammo", 20, &"KILLSTREAK_AMMO_CRATE", &"PLATFORM_AMMO_CRATE_GAMBLER", "share_package_ammo",&giveCrateAmmo );
	registerCrateType( "inventory_supplydrop", "killstreak", "radar", 100, &"KILLSTREAK_RADAR_CRATE", &"PLATFORM_RADAR_GAMBLER", "share_package_uav",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "counteruav", 100, &"KILLSTREAK_COUNTERU2_CRATE", &"PLATFORM_COUNTERU2_GAMBLER", "share_package_counter_uav",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "rcbomb", 100, &"KILLSTREAK_RCBOMB_CRATE", &"PLATFORM_RCBOMB_GAMBLER", "share_package_rcbomb",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "inventory_missile_drone", 100, &"KILLSTREAK_MISSILE_DRONE_CRATE", &"PLATFORM_MISSILE_DRONE_GAMBLER", "share_package_missile_drone",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "qrdrone", 20, &"KILLSTREAK_QRDRONE_CRATE", &"PLATFORM_QRDRONE_GAMBLER", "share_package_qrdrone",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "remote_missile", 85, &"KILLSTREAK_REMOTE_MISSILE_CRATE", &"PLATFORM_REMOTE_MISSILE_GAMBLER", "share_package_remote_missile",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "planemortar", 80, &"KILLSTREAK_PLANE_MORTAR_CRATE", &"PLATFORM_PLANE_MORTAR_GAMBLER", "share_package_plane_mortar",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "autoturret", 80, &"KILLSTREAK_AUTO_TURRET_CRATE", &"PLATFORM_AUTO_TURRET_GAMBLER", "share_package_sentry_gun",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "microwaveturret", 120, &"KILLSTREAK_MICROWAVE_TURRET_CRATE", &"PLATFORM_MICROWAVE_TURRET_GAMBLER", "share_package_microwave_turret",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "inventory_minigun", 60, &"KILLSTREAK_MINIGUN_CRATE", &"PLATFORM_MINIGUN_GAMBLER", "share_package_death_machine",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "inventory_m32", 60, &"KILLSTREAK_M32_CRATE", &"PLATFORM_M32_GAMBLER", "share_package_multiple_grenade_launcher",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "remote_mortar", 2, &"KILLSTREAK_REMOTE_MORTAR_CRATE", &"PLATFORM_REMOTE_MORTAR_GAMBLER", "share_package_remote_mortar",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "helicopter_guard", 20, &"KILLSTREAK_HELICOPTER_GUARD_CRATE", &"PLATFORM_HELICOPTER_GUARD_GAMBLER", "share_package_helicopter_guard",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "radardirection", 20, &"KILLSTREAK_SATELLITE_CRATE", &"PLATFORM_SATELLITE_GAMBLER", "share_package_satellite",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "inventory_ai_tank_drop", 20, &"KILLSTREAK_AI_TANK_CRATE", &"PLATFORM_AI_TANK_GAMBLER", "share_package_aitank",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "helicopter_comlink", 20, &"KILLSTREAK_HELICOPTER_CRATE", &"PLATFORM_HELICOPTER_GAMBLER", "share_package_helicopter_comlink",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "emp", 5, &"KILLSTREAK_EMP_CRATE", &"PLATFORM_EMP_GAMBLER", "share_package_emp",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "helicopter_player_gunner", 2, &"KILLSTREAK_HELICOPTER_GUNNER_CRATE", &"PLATFORM_HELICOPTER_GUNNER_GAMBLER", "share_package_helicopter_gunner",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "dogs", 2, &"KILLSTREAK_DOGS_CRATE", &"PLATFORM_DOGS_GAMBLER", "share_package_dogs",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "straferun", 2, &"KILLSTREAK_STRAFERUN_CRATE", &"PLATFORM_STRAFERUN_GAMBLER", "share_package_strafe_run",&giveCrateKillstreak );
	registerCrateType( "inventory_supplydrop", "killstreak", "missile_swarm", 2, &"KILLSTREAK_MISSILE_SWARM_CRATE", &"PLATFORM_MISSILE_SWARM_GAMBLER", "share_package_missile_swarm",&giveCrateKillstreak );
	
	// for the gambler perk, have its own crate types with a greater chance to get good stuff
	// right now this is at a perfect 1000, so the percentages are easy to understand
	//registerCrateType( "gambler", "ammo", "ammo", 0, &"KILLSTREAK_AMMO_CRATE", undefined, "share_package_ammo",&giveCrateAmmo );
	registerCrateType( "gambler", "killstreak", "radar", 80, &"KILLSTREAK_RADAR_CRATE", undefined, "share_package_uav",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "counteruav", 80, &"KILLSTREAK_COUNTERU2_CRATE", undefined, "share_package_counter_uav",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "rcbomb", 80, &"KILLSTREAK_RCBOMB_CRATE", undefined, "share_package_rcbomb",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "inventory_missile_drone", 90, &"KILLSTREAK_MISSILE_DRONE_CRATE", undefined, "share_package_missile_drone",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "qrdrone", 30, &"KILLSTREAK_QRDRONE_CRATE", undefined, "share_package_qrdrone",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "microwaveturret", 100, &"KILLSTREAK_MICROWAVE_TURRET_CRATE", undefined, "share_package_microwave_turret",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "remote_missile", 90, &"KILLSTREAK_REMOTE_MISSILE_CRATE", undefined, "share_package_remote_missile",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "planemortar", 90, &"KILLSTREAK_PLANE_MORTAR_CRATE", undefined, "share_package_plane_mortar",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "autoturret", 90, &"KILLSTREAK_AUTO_TURRET_CRATE", undefined, "share_package_sentry_gun",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "inventory_minigun", 60, &"KILLSTREAK_MINIGUN_CRATE", undefined, "share_package_death_machine",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "inventory_m32", 60, &"KILLSTREAK_M32_CRATE", undefined, "share_package_multiple_grenade_launcher",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "remote_mortar", 2, &"KILLSTREAK_REMOTE_MORTAR_CRATE", undefined, "share_package_remote_mortar",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "helicopter_guard", 30, &"KILLSTREAK_HELICOPTER_GUARD_CRATE", undefined, "share_package_helicopter_guard",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "radardirection", 30, &"KILLSTREAK_SATELLITE_CRATE", undefined, "share_package_satellite",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "inventory_ai_tank_drop", 30, &"KILLSTREAK_AI_TANK_CRATE", undefined, "share_package_aitank",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "helicopter_comlink", 30, &"KILLSTREAK_HELICOPTER_CRATE", undefined, "share_package_helicopter_comlink",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "straferun", 2, &"KILLSTREAK_STRAFERUN_CRATE", undefined, "share_package_strafe_run",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "emp", 10, &"KILLSTREAK_EMP_CRATE", undefined, "share_package_emp",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "helicopter_player_gunner", 2, &"KILLSTREAK_HELICOPTER_GUNNER_CRATE", undefined, "share_package_helicopter_gunner",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "dogs", 2, &"KILLSTREAK_DOGS_CRATE", undefined, "share_package_dogs",&giveCrateKillstreak );
	registerCrateType( "gambler", "killstreak", "missile_swarm", 2, &"KILLSTREAK_MISSILE_SWARM_CRATE", undefined, "share_package_missile_swarm",&giveCrateKillstreak );
			
	level.crateCategoryWeights = [];
	level.crateCategoryTypeWeights = [];
	
	foreach( categoryKey, category in level.crateTypes )
	{
		finalizeCrateCategory( categoryKey );
	}

	/#
		level thread supply_drop_dev_gui();
		GetDvarInt( "scr_crate_notimeout", 0 ); 
	#/
}

function finalizeCrateCategory( category )
{
	level.crateCategoryWeights[category] = 0;

	crateTypeKeys = getarraykeys( level.crateTypes[category] );
	
	// must leave this as a for loop not a foreach loop
	// it must match the loop in getRandomCrateType
	for ( crateType = 0; crateType < crateTypeKeys.size; crateType++ )
	{
		typeKey = crateTypeKeys[crateType];
		level.crateTypes[category][typeKey].previousWeight = level.crateCategoryWeights[category];
		level.crateCategoryWeights[category] += level.crateTypes[category][typeKey].weight;
		level.crateTypes[category][typeKey].weight = level.crateCategoryWeights[category];
	}
}

function advancedFinalizeCrateCategory( category )
{
	level.crateCategoryTypeWeights[category] = 0;
	crateTypeKeys = getarraykeys( level.categoryTypeWeight[category] );
	
	// must leave this as a for loop not a foreach loop
	// it must match the loop in getRandomCrateType
	for ( crateType = 0; crateType < crateTypeKeys.size; crateType++ )
	{
		typeKey = crateTypeKeys[crateType];
		level.crateCategoryTypeWeights[category] += level.categoryTypeWeight[category][typeKey].weight;
		level.categoryTypeWeight[category][typeKey].weight = level.crateCategoryTypeWeights[category];
	}
	
	finalizeCrateCategory( category );
}

function setCategoryTypeWeight( category, type, weight )
{
	if ( !isdefined(level.categoryTypeWeight[category]) )
	{
		level.categoryTypeWeight[category] = [];
	}
	
	level.categoryTypeWeight[category][type] = SpawnStruct();
	
	level.categoryTypeWeight[category][type].weight = weight;
	
	count = 0;
	totalWeight = 0;
	startIndex = undefined;
	finalIndex = undefined;
	
	crateNameKeys = getarraykeys( level.crateTypes[category] );
	
	// must leave this as a for loop not a foreach loop
	// it must match the loop in getRandomCrateType
	for ( crateName = 0; crateName < crateNameKeys.size; crateName++ )
	{
		nameKey = crateNameKeys[crateName];

		if ( level.crateTypes[category][nameKey].type == type )
		{
			count++;
			totalWeight = totalWeight + level.crateTypes[category][nameKey].weight;
			
			if ( !isdefined( startIndex ) )
			{
				startIndex = crateName;
			}
			
			if ( isdefined( finalIndex ) && (( finalIndex + 1 ) != crateName ) )
			{
				/#util::error("Crate type declaration must be contiguous");#/
				callback::abort_level();
				
				return;
			}
			
			finalIndex = crateName;
		} 
	}
	
	level.categoryTypeWeight[category][type].totalCrateWeight = totalWeight; 
	level.categoryTypeWeight[category][type].crateCount = count;
	level.categoryTypeWeight[category][type].startIndex = startIndex;
	level.categoryTypeWeight[category][type].finalIndex = finalIndex;
}

function registerCrateType( category, type, name, weight, hint, hint_gambler, shareStat, giveFunction, landFunctionOverride )
{
	// SJC: CP doesn't have supply drop crates, so I'm removing this since it requires unnecessary materials
}

function getRandomCrateType( category, gambler_crate_name )
{
	Assert( isdefined(level.crateTypes) );
	Assert( isdefined(level.crateTypes[category]) );
	Assert( isdefined(level.crateCategoryWeights[category]) );

	typeKey = undefined;
	crateTypeStart = 0;	
	randomWeightEnd = RandomIntRange( 1, level.crateCategoryWeights[category] + 1 );
	find_another = false;

	crateNameKeys = getarraykeys( level.crateTypes[category] );

	if ( isdefined( level.categoryTypeWeight[category] ) )
	{
		randomWeightEnd = RandomInt(level.crateCategoryTypeWeights[category] ) + 1;
		crateTypeKeys = getarraykeys( level.categoryTypeWeight[category] );
		
		for ( crateType = 0; crateType < crateTypeKeys.size; crateType++ )
		{
			typeKey = crateTypeKeys[crateType];
			
			if ( level.categoryTypeWeight[category][typeKey].weight < randomWeightEnd )
				continue;
				
			crateTypeStart = level.categoryTypeWeight[category][typeKey].startIndex;
			randomWeightEnd = RandomInt( level.categoryTypeWeight[category][typeKey].totalCrateWeight) + 1;
			randomWeightEnd += level.crateTypes[category][crateNameKeys[crateTypeStart]].previousWeight;
			break;
		}
	}
	
	for ( crateType = crateTypeStart; crateType < crateNameKeys.size; crateType++ )
	{
		typeKey = crateNameKeys[crateType];
		
		if ( level.crateTypes[category][typeKey].weight < randomWeightEnd )
			continue;
		
		// if we have the gambler perk then make sure we aren't getting the same thing again
		if( isdefined( gambler_crate_name ) && level.crateTypes[category][typeKey].name == gambler_crate_name )
		{
			find_another = true;
		}

		// go find another crate
		if( find_another )
		{
			if( crateType < crateNameKeys.size - 1 )
			{
				crateType++;
			}
			else if( crateType > 0 )
			{
				crateType--;
			}
			typeKey = crateNameKeys[crateType];
		}

		break;
	}

	/#
	if( isdefined(level.dev_gui_supply_drop) && level.dev_gui_supply_drop != "random" )
	{
		typeKey = level.dev_gui_supply_drop;
	}
	#/

	return level.crateTypes[category][typeKey];
}

function giveCrateItem( crate )
{
	if ( !IsAlive( self ) ) 
		return;
		
	return [[crate.crateType.giveFunction]]( crate.crateType.weapon );
}

function giveCrateKillstreakWaiter( event, removeCrate, extraEndon )
{
	self endon( "give_crate_killstreak_done" );
	if ( isdefined( extraEndon ) )
	{
		self endon( extraEndon );
	}
	self waittill( event );
	self notify( "give_crate_killstreak_done", removeCrate );
}

function giveCrateKillstreak( killstreak )
{
	self killstreaks::give( killstreak );
}

function giveSpecializedCrateWeapon( weapon )
{
	switch ( weapon.name )
	{
	case "minigun":
		level thread popups::DisplayTeamMessageToAll( &"KILLSTREAK_MINIGUN_INBOUND", self );
		level weapons::add_limited_weapon( weapon, self, 3 );
		break;
	case "m32":
		level thread popups::DisplayTeamMessageToAll( &"KILLSTREAK_M32_INBOUND", self );
		level weapons::add_limited_weapon( weapon, self, 3 );
		break;
	case "m202_flash":
		level thread popups::DisplayTeamMessageToAll( &"KILLSTREAK_M202_FLASH_INBOUND", self );
		level weapons::add_limited_weapon( weapon, self, 3 );
		break;
	case "m220_tow":
		level thread popups::DisplayTeamMessageToAll( &"KILLSTREAK_M220_TOW_INBOUND", self );
		level weapons::add_limited_weapon( weapon, self, 3 );
		break;
	case "mp40_blinged":
		level thread popups::DisplayTeamMessageToAll( &"KILLSTREAK_MP40_INBOUND", self );
		level weapons::add_limited_weapon( weapon, self, 3 );
		break;

	default:
		break;
	}
	
}

function giveCrateWeapon( weapon )
{
	currentWeapon = self GetCurrentWeapon();

	if ( currentWeapon == weapon || self HasWeapon( weapon ) ) 
	{
		self GiveMaxAmmo( weapon );
		return true;
	}
	
	// if the player is holding anything other than primary or secondary weapons, 
	// take away the last primary or secondary weapon the player was holding before giving the crate weapon. 
	if ( currentWeapon.isSupplyDropWeapon || isdefined( level.grenade_array[currentWeapon] )|| isdefined( level.inventory_array[currentWeapon] ) ) 
	{
		self TakeWeapon( self.lastdroppableweapon );
		self GiveWeapon( weapon );
		self switchToWeapon( weapon );
		return true;
	}
	
	self AddWeaponStat( weapon, "used", 1 );

	giveSpecializedCrateWeapon( weapon );	
	
	self GiveWeapon( weapon );
	self switchToWeapon( weapon );

	self waittill( "weapon_change", newWeapon );
	
	self killstreak_weapons::useKillstreakWeaponFromCrate( weapon );
	
	return true;
}

function useSupplyDropMarker( package_contents_id )
{
	//self endon("death");
	self endon("disconnect");
	self endon("spawned_player");
	
	self thread supplyDropWatcher( package_contents_id );

	self.supplyGrenadeDeathDrop = false;

	supplyDropWeapon = level.weaponNone;
	currentWeapon = self GetCurrentWeapon();
	prevWeapon = currentWeapon;
	if ( currentWeapon.isSupplyDropWeapon )
	{
		supplyDropWeapon = currentWeapon;
	}
		
	notifyString = self util::waittill_any_return( "weapon_change", "grenade_fire" );
	
	if ( notifyString != "grenade_fire" )
		return false; 
	
	// for some reason we never had the supply drop weapon
	if ( supplyDropWeapon == level.weaponNone )
		return false;
	
	if ( isdefined( self ) )
	{
		// don't take the supplyDropWeapon until the throwing (firing) state is completed
		notifyString = self util::waittill_any_return( "weapon_change", "death" );
		
		self TakeWeapon( supplyDropWeapon );
	
		// if we no longer have the supply drop weapon in our inventory then 
		// it must have been successful
		if ( self HasWeapon( supplyDropWeapon ) || self GetAmmoCount( supplyDropWeapon ) )
			return false;
	}
	
	return true;
}

function isSupplyDropGrenadeAllowed( hardpointType )
{
	if ( !self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) )
	{
		self switchToWeapon( self util::getLastWeapon() );
	
		return false;
	}

	return true;
}
function useKillstreakSupplyDrop(hardpointType)
{
	if ( !self isSupplyDropGrenadeAllowed( hardpointType ) )
		return false;

	result = self useSupplyDropMarker();
	
	self notify( "supply_drop_marker_done" );

	if ( !isdefined(result) || !result )
	{
		return false;
	}

	return result;
}

function use_killstreak_death_machine( hardpointType )
{
	if ( !self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) )
		return false;

	weapon = GetWeapon( "minigun" );
	currentWeapon = self GetCurrentWeapon();

	// if the player is holding anything other than primary or secondary weapons, 
	// take away the last primary or secondary weapon the player was holding before giving the crate weapon. 
	if ( currentWeapon.isSupplyDropWeapon || isdefined( level.grenade_array[currentWeapon] ) || isdefined( level.inventory_array[currentWeapon] ) ) 
	{
		self TakeWeapon( self.lastdroppableweapon );
		self GiveWeapon( weapon );
		self SwitchToWeapon( weapon );

		//This will make it so the player cannot pick up weapons while using this weapon for the first time.
		self setBlockWeaponPickup( weapon, true );
		return true;
	}

	level thread popups::DisplayTeamMessageToAll( &"KILLSTREAK_MINIGUN_INBOUND", self );
	level weapons::add_limited_weapon( weapon, self, 3 );

	self TakeWeapon( currentWeapon );
	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );

	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
	self setBlockWeaponPickup( weapon, true );
	return true;
}

function use_killstreak_grim_reaper( hardpointType )
{
	if ( !self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) )
		return false;

	weapon = GetWeapon( "m202_flash" );
	currentWeapon = self GetCurrentWeapon();

	// if the player is holding anything other than primary or secondary weapons, 
	// take away the last primary or secondary weapon the player was holding before giving the crate weapon. 
	if ( currentWeapon.isSupplyDropWeapon || isdefined( level.grenade_array[currentWeapon] ) || isdefined( level.inventory_array[currentWeapon] ) ) 
	{
		self TakeWeapon( self.lastdroppableweapon );
		self GiveWeapon( weapon );
		self SwitchToWeapon( weapon );

		//This will make it so the player cannot pick up weapons while using this weapon for the first time.
		self setBlockWeaponPickup( weapon, true );
		return true;
	}

	level thread popups::DisplayTeamMessageToAll( &"KILLSTREAK_M202_FLASH_INBOUND", self );
	level weapons::add_limited_weapon( weapon, self, 3 );

	self TakeWeapon( currentWeapon );
	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );
	
	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
	self setBlockWeaponPickup( weapon, true );
	return true;
}

function use_killstreak_tv_guided_missile(hardpointType)
{
	if ( !killstreakrules::isKillstreakAllowed( hardpointType, self.team ) )
	{
		self iPrintLnBold( level.killstreaks[hardpointType].notAvailableText );

		return false;
	}

	weapon = GetWeapon( "m220_tow" );
	currentWeapon = self GetCurrentWeapon();

	// if the player is holding anything other than primary or secondary weapons, 
	// take away the last primary or secondary weapon the player was holding before giving the crate weapon. 
	if ( currentWeapon.isSupplyDropWeapon || isdefined( level.grenade_array[currentWeapon] ) || isdefined( level.inventory_array[currentWeapon] ) ) 
	{
		self TakeWeapon( self.lastdroppableweapon );
		self GiveWeapon( weapon );
		self SwitchToWeapon( weapon );

		//This will make it so the player cannot pick up weapons while using this weapon for the first time.
		self setBlockWeaponPickup( weapon, true );
		return true;
	}

	level thread popups::DisplayTeamMessageToAll( &"KILLSTREAK_M220_TOW_INBOUND", self );
	level weapons::add_limited_weapon( weapon, self, 3 );

	self TakeWeapon( currentWeapon );
	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );
	
	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
	self setBlockWeaponPickup( weapon, true );
	return true;
}

function use_killstreak_mp40( hardpointType )
{
	if ( !killstreakrules::isKillstreakAllowed( hardpointType, self.team ) )
	{
		self iPrintLnBold( level.killstreaks[hardpointType].notAvailableText );

		return false;
	}

	weapon = GetWeapon( "mp40_blinged" );
	currentWeapon = self GetCurrentWeapon();

	// if the player is holding anything other than primary or secondary weapons, 
	// take away the last primary or secondary weapon the player was holding before giving the crate weapon. 
	if ( currentWeapon.isSupplyDropWeapon || isdefined( level.grenade_array[currentWeapon] ) || isdefined( level.inventory_array[currentWeapon] ) ) 
	{
		self TakeWeapon( self.lastdroppableweapon );
		self GiveWeapon( weapon );
		self SwitchToWeapon( weapon );
		
		//This will make it so the player cannot pick up weapons while using this weapon for the first time.
		self setBlockWeaponPickup( weapon, true );
		return true;
	}

	level thread popups::DisplayTeamMessageToAll( &"KILLSTREAK_MP40_INBOUND", self );
	level weapons::add_limited_weapon( weapon, self, 3 );

	self TakeWeapon( currentWeapon );
	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );
	
	//This will make it so the player cannot pick up weapons while using this weapon for the first time.
	self setBlockWeaponPickup( weapon, true );
	return true;
}

function cleanUpWatcherOnDeath( team, killstreak_id )
{
	self endon( "disconnect" );
	self endon( "supplyDropWatcher" );
	self endon( "grenade_fire" );
	self endon( "spawned_player" );
	self endon( "weapon_change" );
	
	self waittill( "death" );
	
	killstreakrules::killstreakStop( "supply_drop", team, killstreak_id );
}

function supplyDropWatcher( package_contents_id )
{
	self notify("supplyDropWatcher");
	
	self endon( "supplyDropWatcher" );
	self endon( "spawned_player" );
	self endon( "disconnect" );
	self endon( "weapon_change" );
	
	team = self.team;

	killstreak_id = killstreakrules::killstreakStart( "supply_drop", team, false, false );
	if ( killstreak_id == -1 )
		return;

	self thread checkForEmp();
	
	self thread checkWeaponChange( team, killstreak_id );

	self thread cleanUpWatcherOnDeath( team, killstreak_id ); 
	
	self waittill( "grenade_fire", weapon_instance, weapon );
		
	if ( isdefined( self ) && weapon.isSupplyDropWeapon )
	{
		self thread doSupplyDrop( weapon_instance, weapon, self, killstreak_id, package_contents_id );
		weapon_instance thread do_supply_drop_detonation( weapon, self );
		weapon_instance thread supplyDropGrenadeTimeout( team, killstreak_id, weapon );
		self killstreaks::switch_to_last_non_killstreak_weapon();
	}
	else
	{
		killstreakrules::killstreakStop( "supply_drop", team, killstreak_id );
	}
}

function checkForEmp()
{
	self endon( "supplyDropWatcher" );
	self endon( "spawned_player" );
	self endon( "disconnect" );
	self endon( "weapon_change" );
	self endon( "death" );
	self endon( "grenade_fire" );
	
	self waittill( "emp_jammed" );
	
	self killstreaks::switch_to_last_non_killstreak_weapon();
}

function supplyDropGrenadeTimeout( team, killstreak_id, weapon )
{
	self endon( "death" );
	self endon("stationary");
	
	GRENADE_LIFETIME = 10;

	//If the grenade hasn't stopped moving after a certain time delete it.
	wait( GRENADE_LIFETIME );
	
	if( !isdefined( self ) )
		return;

	self notify( "grenade_timeout" );
	killstreakrules::killstreakStop( "supply_drop", team, killstreak_id );

	if ( weapon.name == "ai_tank_drop" )
	{
		killstreakrules::killstreakStop( "ai_tank_drop", team, killstreak_id );
	}
	else if ( weapon.name == "inventory_ai_tank_drop" )
	{
		killstreakrules::killstreakStop( "inventory_ai_tank_drop", team, killstreak_id );
	}

	self delete();
}

function checkWeaponChange( team, killstreak_id )
{
	self endon( "supplyDropWatcher" );
	self endon( "spawned_player" );
	self endon( "disconnect" );
	self endon( "grenade_fire" );
	self endon( "death" );
	
	self waittill( "weapon_change" );
	killstreakrules::killstreakStop( "supply_drop", team, killstreak_id );	
}

function supplyDropGrenadePullWatcher( killstreak_id )
{
	self endon( "disconnect" );
	self endon( "weapon_change" );

	self waittill ( "grenade_pullback", weapon );

	self util::_disableUsability();

	self thread watchForGrenadePutDown();
	
	self waittill ( "death" );
	
	killstreak = "supply_drop";
	self.supplyGrenadeDeathDrop = true;

	if( weapon.isSupplyDropWeapon )
	{
		killstreak = killstreaks::get_killstreak_for_weapon( weapon );
	}

	if ( !( isdefined( self.usingKillstreakFromInventory ) && self.usingKillstreakFromInventory ) ) 
	{
		self killstreaks::change_killstreak_quantity( weapon, -1 );
	}
	else
	{
		killstreaks::remove_used_killstreak( killstreak, killstreak_id );
	}
}

function watchForGrenadePutDown()
{
	self notify( "watchForGrenadePutDown" );
	self endon( "watchForGrenadePutDown" );
	self endon( "death" );
	self endon( "disconnect" );

	self util::waittill_any( "grenade_fire", "weapon_change" );
	self util::_enableUsability();
}

function abortSupplyDropMarkerWaiter( waitTillString )
{
	self endon( "supply_drop_marker_done" );
	
	self waittill( waitTillString );

	self notify( "supply_drop_marker_done" );
}

function playerChangeWeaponWaiter()
{
	self endon( "supply_drop_marker_done" );

	self endon( "disconnect" );
	self endon( "spawned_player" );

	currentWeapon = self GetCurrentWeapon();
	
	while ( currentWeapon.isSupplyDropWeapon )
	{
		self waittill( "weapon_change", currentWeapon );
	}

	// if the killstreak ended because of a weapon change
	// give a frame to allow the weapon_change to trigger in other scripts
	waittillframeend;

	self notify( "supply_drop_marker_done" );
}

function getIconForCrate()
{
	icon = undefined;
	
	switch ( self.crateType.type )
	{
		case "killstreak":
			{
				if (self.crateType.name == "inventory_ai_tank_drop" )
					icon = "hud_ks_ai_tank";
				else
				{
					killstreak = killstreaks::get_menu_name( self.crateType.name );
					icon = level.killStreakIcons[killstreak];
				}
			}
			break;
		
		case "weapon":
			{
				switch( self.crateType.name )
				{
				case "minigun":
					icon = "hud_ks_minigun";
					break;
				case "m32":
					icon = "hud_ks_m32";
					break;
				case "m202_flash":
					icon = "hud_ks_m202";
					break;
				case "m220_tow":
					icon = "hud_ks_tv_guided_missile";
					break;
				case "mp40_drop":
					icon = "hud_mp40";
						break;
				default:
					icon = "waypoint_recon_artillery_strike";
					break;
				}
			}
			break;
		
		case "ammo":
			{
				icon = "hud_ammo_refill";
			}
			break;

		default:
				return undefined;
			break;
	}
	
	return icon + "_drop";
}

function crateActivate( hacker )
{
	self MakeUsable();
	self SetCursorHint("HINT_NOICON");

	self setHintString( self.crateType.hint );	
	if ( isdefined( self.crateType.hint_gambler ) )
	{
		self setHintStringForPerk( "specialty_showenemyequipment", self.crateType.hint_gambler );
	}

	crateObjID = gameobjects::get_next_obj_id();	
	objective_add( crateObjID, "invisible", self.origin );
	objective_icon( crateObjID, "compass_supply_drop_green" );
	objective_state( crateObjID, "active" );
	self.friendlyObjID = crateObjID;
	self.enemyObjID = [];
	
	icon = self getIconForCrate();
	
	if (isdefined( hacker ))
	{
		self thread attachReconModel( level.crateModelHacker, hacker );
	}
	
	if ( level.teambased )
	{
		objective_team( crateObjID, self.team );

		foreach( team in level.teams )
		{
			if ( self.team == team )
				continue;
				
			crateObjID = gameobjects::get_next_obj_id();	
			objective_add( crateObjID, "invisible", self.origin );
			if( isdefined( self.hacker ) )
			{
				objective_icon( crateObjID, "compass_supply_drop_black" );
			}
			else
			{
				objective_icon( crateObjID, "compass_supply_drop_red" );
			}
			objective_team( crateObjID, team );
			objective_state( crateObjID, "active" );
			self.enemyObjID[self.enemyObjID.size] = crateObjID;	
		}
	}
	else
	{
		if ( !self.visibleToAll )
		{
			Objective_SetInvisibleToAll( crateObjID );
	
			enemyCrateObjID = gameobjects::get_next_obj_id();	
			objective_add( enemyCrateObjID, "invisible", self.origin );
			objective_icon( enemyCrateObjID, "compass_supply_drop_red" );
			objective_state( enemyCrateObjID, "active" );
			if ( isplayer( self.owner ) )
			{
				Objective_SetInvisibleToPlayer( enemyCrateObjID, self.owner );
			}
			self.enemyObjID[self.enemyObjID.size] = enemyCrateObjID;
		}
		
		if ( isplayer( self.owner ) )
		{
			Objective_SetVisibleToPlayer( crateObjID, self.owner );
		}
		
		if( isdefined( self.hacker ) )
		{
			Objective_SetInvisibleToPlayer( crateObjID, self.hacker );
			
			crateObjID = gameobjects::get_next_obj_id();	
			objective_add( crateObjID, "invisible", self.origin );
			objective_icon( crateObjID, "compass_supply_drop_black" );
			objective_state( crateObjID, "active" );
			Objective_SetInvisibleToAll( crateObjID );
			Objective_SetVisibleToPlayer( crateObjID, self.hacker );
			self.hackerObjID = crateObjID;
		}
	}
	
	if ( !self.visibleToAll && isdefined(icon) )
	{
		self thread entityheadIcons::setEntityHeadIcon( self.team, self, level.crate_headicon_offset, icon, true );	
	}
	
	if ( isdefined( self.owner ) && IsPlayer(self.owner) && self.owner util::is_bot() )
	{
		self.owner notify( "bot_crate_landed", self );
	}

	if ( isdefined( self.owner ) )
	{
		self.owner notify( "crate_landed", self );
	}
}

function crateDeactivate( )
{
	self makeunusable();

	if ( isdefined(self.friendlyObjID) )
	{
		Objective_Delete( self.friendlyObjID );
		gameobjects::release_obj_id(self.friendlyObjID);
		self.friendlyObjID = undefined;
	}
	
	if ( isdefined(self.enemyObjID) )
	{
		foreach( objId in self.enemyObjID )
		{
			Objective_Delete( objId );
			gameobjects::release_obj_id(objId);
		}
		self.enemyObjID = [];
	}
	
	if ( isdefined(self.hackerObjID) )
	{
		Objective_Delete( self.hackerObjID );
		gameobjects::release_obj_id(self.hackerObjID);
		self.hackerObjID = undefined;
	}
}


function ownerTeamChangeWatcher()
{
	self endon("death");

	if ( !level.teamBased || !isdefined( self.owner ) )
		return;

	self.owner waittill("joined_team");

	self.owner = undefined;
}

function dropAllToGround( origin, radius, stickyObjectRadius )
{
	PhysicsExplosionSphere( origin, radius, radius, 0 );
	{wait(.05);};
	weapons::drop_all_to_ground( origin, radius );

	supplydrop::dropCratesToGround( origin, radius );
	level notify( "drop_objects_to_ground", origin, stickyObjectRadius );
}

function dropEverythingTouchingCrate( origin )
{
	// a sphere with a radius of 44 covers the current supply drop exactly
	dropAllToGround( origin, 70, 70 );
}

function dropAllToGroundAfterCrateDelete( crate, crate_origin )
{
	crate waittill("death");
	wait( 0.1 );
	
	crate dropEverythingTouchingCrate( crate_origin );
}

function dropCratesToGround( origin, radius )
{
	crate_ents = GetEntArray( "care_package", "script_noteworthy" );
	radius_sq = radius * radius;
	for ( i = 0 ; i < crate_ents.size ; i++ )
	{
		if ( DistanceSquared( origin, crate_ents[i].origin ) < radius_sq )
		{
			crate_ents[i] thread dropCrateToGround();
		}
	}
}

function dropCrateToGround()
{
	self endon("death");
	
	if ( isdefined( self.droppingToGround ) )
		return;
		
	self.droppingToGround = true;
	
	// we need to recursively have this crate trigger a drop to ground as well
	dropEverythingTouchingCrate( self.origin );
	
	self crateDeactivate();
	self thread crateDropToGroundKill();
	self crateRedoPhysics();
	self crateActivate();
		
	self.droppingToGround = undefined;
}

function crateSpawn( category, owner, team, drop_origin, drop_angle )
{
	crate = spawn( "script_model", drop_origin, 1 );
	crate.angles = drop_angle;
	crate.team = team;
	crate.visibleToAll = false;
	crate SetTeam(team);
	if ( isplayer( owner ) )
	{
		crate SetOwner( owner );
	}
	crate.script_noteworthy = "care_package";

	if ( !level.teamBased || ( isdefined(owner) && owner.team == team ) )
	crate.owner = owner;

	crate thread ownerTeamChangeWatcher();
	
	if ( category == "ai_tank_drop" || category == "inventory_ai_tank_drop" )
	{
		crate setModel( level.crateModelTank );
		crate setEnemyModel( level.crateModelTank );
	}
	else
	{
		crate setModel( level.crateModelFriendly );
		crate setEnemyModel( level.crateModelEnemy );
	}
	
	switch( category )
	{
	case "turret_drop":
		crate.crateType = level.crateTypes[ category ][ "autoturret" ];
		break;
	case "tow_turret_drop":
		crate.crateType = level.crateTypes[ category ][ "auto_tow" ];
		break;
	case "m220_tow_drop":
		crate.crateType = level.crateTypes[ category ][ "m220_tow" ];
		break;
	case "ai_tank_drop":
	case "inventory_ai_tank_drop":
		crate.crateType = level.crateTypes[ category ][ "ai_tank" ];
		break;	
	case "minigun_drop":
	case "inventory_minigun_drop":
		crate.crateType = level.crateTypes[ category ][ "minigun" ];
		break;	
	case "m32_drop":
	case "inventory_m32_drop":
		crate.crateType = level.crateTypes[ category ][ "m32" ];
		break;	
	default:
		crate.crateType = getRandomCrateType( category );
		break;
	}

	return crate;
}

function crateDelete( drop_all_to_ground )
{
	if( !isdefined( drop_all_to_ground ) )
	{
		drop_all_to_ground = true;
	}
	
	if ( isdefined(self.friendlyObjID) )
	{
		Objective_Delete( self.friendlyObjID );
		gameobjects::release_obj_id(self.friendlyObjID);
		self.friendlyObjID = undefined;
	}
	
	if ( isdefined(self.enemyObjID) )
	{
		foreach( objId in self.enemyObjID )
		{
			Objective_Delete( objId );
			gameobjects::release_obj_id(objId);
		}
		self.enemyObjID = undefined;
	}
	
	if ( isdefined(self.hackerObjID) )
	{
		Objective_Delete( self.hackerObjID );
		gameobjects::release_obj_id(self.hackerObjID);
		self.hackerObjID = undefined;
	}
	
	if( drop_all_to_ground )
	{
		level thread dropAllToGroundAfterCrateDelete( self, self.origin );
	}

	self Delete();
}

function timeoutCrateWaiter()
{
	self endon("death");
	self endon("stationary");
	
	// if the crate has not stopped moving for some time just get rid of it
	wait( 20 );
	
	self crateDelete();
}

function cratePhysics()
{
	forcePointVariance = 200.0;
	vertVelocityMin = -100.0;
	vertVelocityMax = 100.0;
	
	forcePointX = RandomFloatRange( 0-forcePointVariance, forcePointVariance );
	forcePointY = RandomFloatRange( 0-forcePointVariance, forcePointVariance );
	forcePoint = ( forcePointX, forcePointY, 0 );
	forcePoint += self.origin;
	
	initialVelocityZ = RandomFloatRange( vertVelocityMin, vertVelocityMax );
	initialVelocity = ( 0, 0, initialVelocityZ );

	self PhysicsLaunch(forcePoint,initialVelocity);
	
	self thread timeoutCrateWaiter();

	self thread update_crate_velocity();
	self thread play_impact_sound();

	self waittill("stationary");
}

function play_impact_sound() //self == crate
{
	self endon( "entityshutdown" );
	self endon( "stationary" );
	self endon( "death" );

	wait( 0.5 ); //this wait is to delay the fall speed check

	while( abs( self.velocity[2] ) > 5 ) //this is not 0 since the crate will sometimes rock a bit before it stops moving
	{
		wait( 0.1 );
	}

	self PlaySound( "phy_impact_supply" );
}

function update_crate_velocity() //self == crate
{
	self endon( "entityshutdown" );
	self endon( "stationary" );

	self.velocity = ( 0,0,0 );
	self.old_origin = self.origin;

	while( isdefined( self ) )
	{
		self.velocity = ( self.origin - self.old_origin );
		self.old_origin = self.origin;

		{wait(.05);};
	}
}


function crateRedoPhysics()
{
	forcePoint = self.origin;
	
	initialVelocity = ( 0, 0, 0 );

	self PhysicsLaunch(forcePoint,initialVelocity);
	
	self thread timeoutCrateWaiter();
	self waittill("stationary");
}

function do_supply_drop_detonation( weapon, owner ) // self == weapon_instance
{
	self notify("supplyDropWatcher");

	self endon( "supplyDropWatcher" );
	self endon( "spawned_player" );
	self endon( "disconnect" );
	self endon( "death" );
	self endon ( "grenade_timeout" );

	// control the explosion events to circumvent the code cleanup
	self util::waitTillNotMoving();
	self.angles = ( 0, self.angles[1], 90 );
	fuse_time = weapon.fuseTime / 1000; // fuse time comes back in milliseconds
	wait( fuse_time );
	
	if ( !isdefined( owner ) || !owner emp::isEnemyEMPKillstreakActive() )
	{
		thread smokegrenade::playSmokeSound( self.origin, 6, level.sound_smoke_start, level.sound_smoke_stop, level.sound_smoke_loop );
		PlayFXOnTag( level._supply_drop_smoke_fx, self, "tag_fx" );
		proj_explosion_sound = weapon.projExplosionSound;
		sound::play_in_space( proj_explosion_sound, self.origin );
	}
	
	// need to clean up the canisters
	wait( 3 );
	self delete();
}

function doSupplyDrop( weapon_instance, weapon, owner, killstreak_id, package_contents_id )
{
	weapon endon ( "explode" );
	weapon endon ( "grenade_timeout" );
	self endon( "disconnect" );
	team = owner.team;
	weapon_instance thread watchExplode( weapon, owner, killstreak_id, package_contents_id );
	weapon_instance util::waitTillNotMoving();
	weapon_instance notify( "stoppedMoving" );
	
	self thread heliDeliverCrate( weapon_instance.origin, weapon, owner, team, killstreak_id, package_contents_id );
}

function watchExplode( weapon, owner, killstreak_id, package_contents_id )
{
	self endon( "stoppedMoving" );
	team = owner.team;
	self waittill( "explode", position ); 
	
	owner thread heliDeliverCrate( position, weapon, owner, team, killstreak_id, package_contents_id );
}

function crateTimeOutThreader()
{
/#
	if ( GetDvarInt( "scr_crate_notimeout", 0 ) ) 
		return;
#/
	self thread crateTimeOut(90);
}

function dropCrate( origin, angle, category, owner, team, killstreak_id, package_contents_id, crate )
{
	angle = ( angle[0] * 0.5, angle[1] * 0.5, angle[2] * 0.5 );
	
	if ( isdefined( crate ) )
	{
		origin = crate.origin;
		angle = crate.angles;
		crate delete();
	}
	crate = crateSpawn( category, owner, team, origin, angle );
	crate.killstreak_id = killstreak_id;
	crate.package_contents_id = package_contents_id;
	
	crate endon("death");
	
	crate thread crateKill();

	crate cratePhysics();	
	
	crate crateTimeOutThreader();

	crate thread hacker_tool::registerWithHackerTool( level.carePackageHackerToolRadius, level.carePackageHackerToolTimeMs );

	if ( isdefined( crate.crateType.landFunctionOverride ) )
	{
		[[crate.crateType.landFunctionOverride]]( crate, category, owner, team );
	}
	else
	{
		crate crateActivate();
	
		crate thread crateUseThink();
		crate thread crateUseThinkOwner();
		
		if( isdefined( crate.crateType.hint_gambler )) 
		{
			crate thread crateGamblerThink();
		}

		default_land_function( crate, category, owner, team );
	}

}

function unlinkOnRotation( crate )
{
	self endon( "delete" );
	crate endon( "entityshutdown" );
	crate endon( "stationary" );
	
	waitBeforeRotationCheck = GetDvarFloat( "scr_supplydrop_killcam_rot_wait", 0.5 );
	wait( waitBeforeRotationCheck ); //this wait is to delay the fall speed check

	minCos = GetDvarInt( "scr_supplydrop_killcam_max_rot", 0.999 );
		
	cosine = 1;

	currentDirection = VectorNormalize( AnglesToForward( crate.angles ) );

	while( cosine > minCos  ) 
	{
		oldDirection = currentDirection;
		{wait(.05);};
		currentDirection = VectorNormalize( AnglesToForward( crate.angles ) );
		cosine = vectordot( oldDirection, currentDirection );
	}
	self unlink();
}


function default_land_function( crate, category, owner, team ) 
{
	while ( 1 )
	{
		crate waittill("captured", player, remote_hack );

		player challenges::capturedCrate();
		deleteCrate = player giveCrateItem( crate );
		if ( isdefined( deleteCrate ) && !deleteCrate )
		{
			continue;
		}
		
		// added functionality to specialty_showenemyequipment to create a booby trapped supply crate once this is captured
		if( (player HasPerk( "specialty_showenemyequipment" ) || remote_hack==true )&& 
			owner != player &&
			((level.teambased && team != player.team) || !level.teambased) )
		{
			// spawn an explosive crate right before we delete the other
			spawn_explosive_crate( crate.origin, crate.angles, category, owner, team, player );
			crate crateDelete( false );
		}
		else
		{
			crate crateDelete();
		}
		return;
	}
}

function spawn_explosive_crate( origin, angle, category, owner, team, hacker ) // self == crate
{
	crate = crateSpawn( category, owner, team, origin, angle );
	crate SetOwner( owner );
	crate SetTeam( team );

	if ( level.teambased )
	{
		crate setEnemyModel( level.crateModelBoobyTrapped );
		crate MakeUsable( team );
	}
	else
	{
		crate setEnemyModel( level.crateModelEnemy );
	}
	
	crate.hacker = hacker;
	crate.visibleToAll = false;
	crate crateActivate( hacker );
	crate setHintStringForPerk( "specialty_showenemyequipment", level.supplyDropDisarmCrate );
	crate thread crateUseThink();
	crate thread crateUseThinkOwner();
	crate thread watch_explosive_crate();
	crate crateTimeOutThreader();
}

function watch_explosive_crate() // self == crate
{
	self waittill( "captured", player, remote_hack );
	
	// give warning and then explode if the capturer didnt have hacker perk
	if ( !player HasPerk( "specialty_showenemyequipment" ) && !remote_hack )
	{
		self thread entityheadIcons::setEntityHeadIcon( player.team, player, level.crate_headicon_offset, "headicon_dead", true );	
		self loop_sound( "wpn_semtex_alert", 0.15 );
	
		if( !isdefined( self.hacker ) )
		{
			self.hacker = self;
		}
		self RadiusDamage( self.origin, 256, 300, 75, self.hacker, "MOD_EXPLOSIVE", GetWeapon( "supplydrop" ) );
		PlayFX( level._supply_drop_explosion_fx, self.origin );
		PlaySoundAtPosition( "wpn_grenade_explode", self.origin );
	}
	else
	{
		PlaySoundAtPosition ( "mpl_turret_alert", self.origin );
		scoreevents::processScoreEvent( "disarm_hacked_care_package", player );
		player challenges::disarmedHackedCarepackage();
	}
	wait ( 0.1 );
	self crateDelete();
}

function loop_sound( alias, interval ) // self == crate
{
	self endon( "death" );
	while( 1 )
	{
		PlaySoundAtPosition( alias, self.origin );

		wait interval;
		interval = (interval / 1.2);

		if (interval < .08)
		{
			break;
		}	
	}
}

function crateKill() // self == crate
{
	self endon( "death" );

	// kill anyone under it
	stationaryThreshold = 2;
	killThreshold = 15;
	maxFramesTillStationary = 20;
	numFramesStationary = 0;
	while( true )
	{	
		vel = 0;
		if ( isdefined( self.velocity ) )
			vel = abs( self.velocity[2] );
		
		if ( vel > killThreshold )
			self is_touching_crate();

		if ( vel < stationaryThreshold )
			numFramesStationary++;
		else
			numFramesStationary = 0;

		if ( numFramesStationary >= maxFramesTillStationary )
			break;
		
		wait 0.01;
	}
}

function crateDropToGroundKill()
{
	self endon( "death" );
	self endon( "stationary" );

	for ( ;; )
	{
		players = GetPlayers();
		doTrace = false;

		for ( i = 0; i < players.size; i++ )
		{
			if ( players[i].sessionstate != "playing" )
				continue;

			if ( players[i].team == "spectator" )
				continue;

			//Check if any equipment gets landed on
			self is_equipment_touching_crate( players[i] );

			if ( !IsAlive( players[i] ) )
				continue;
			
			flattenedSelfOrigin = (self.origin[0], self.origin[1], 0 );
			flattenedPlayerOrigin = (players[i].origin[0], players[i].origin[1], 0 );
			
			if ( DistanceSquared( flattenedSelfOrigin, flattenedPlayerOrigin ) > 64 * 64 )
				continue;

			doTrace = true;
			break;
		}

		// do the trace
		if ( doTrace )
		{
			start = self.origin;
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( 1.0, 0.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( -1.0, 0.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( 0.0, -1.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( 0.0, 1.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( 1.0, 1.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( -1.0, 1.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( 1.0, -1.0, 0.0 );
			crateDropToGroundTrace( start );

			start = self GetPointInBounds( -1.0, -1.0, 0.0 );
			crateDropToGroundTrace( start );

			wait( 0.2 );
		}
		else
		{
			wait( 0.5 );
		}
	}
}

function crateDropToGroundTrace( start )
{
	end = start + ( 0, 0, -8000 );

	trace = BulletTrace( start, end, true, self, true, true );

	if ( isdefined( trace[ "entity" ] ) && IsPlayer( trace[ "entity" ] ) && IsAlive( trace[ "entity" ] ) )
	{
		player = trace[ "entity" ];

		if ( player.sessionstate != "playing" )
			return;

		if ( player.team == "spectator" )
			return;

		if ( DistanceSquared( start, trace[ "position" ] ) < 12 * 12 || self IsTouching( player ) )
		{
			player DoDamage( player.health + 1, player.origin, self.owner, self, "none", "MOD_HIT_BY_OBJECT", 0, GetWeapon( "supplydrop" ) );
			player playsound ( "mpl_supply_crush" );
			player playsound ( "phy_impact_supply" );			
		}
	}
}

function is_touching_crate() // self == crate
{
	extraBoundary = ( 10, 10, 10 );
	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		if( isdefined( players[i] ) && IsAlive( players[i] ) && self IsTouching( players[i], extraBoundary ) )
		{
			attacker = ( isdefined( self.owner ) ? self.owner : self );
			
			players[i] DoDamage( players[i].health + 1, players[i].origin, attacker, self, "none", "MOD_HIT_BY_OBJECT", 0, GetWeapon( "supplydrop" ) );
			players[i] playsound ("mpl_supply_crush");
			players[i] playsound ("phy_impact_supply");			
		}

		self is_equipment_touching_crate( players[i] );
	}
}

function is_equipment_touching_crate( player ) // self == crate, player is passed to access their equipment
{
	extraBoundary = ( 10, 10, 10 );
	if( isdefined( player ) && isdefined( player.weaponObjectWatcherArray ) )
	{
		for( watcher = 0; watcher < player.weaponObjectWatcherArray.size; watcher++ )
		{ 
			objectWatcher = player.weaponObjectWatcherArray[watcher];
			objectArray = objectWatcher.objectArray;
			
			if( isdefined( objectArray ) )
			{
				for( weaponObject = 0; weaponObject < objectArray.size; weaponObject++ )
				{
					if( isdefined(objectArray[weaponObject]) && self IsTouching( objectArray[weaponObject], extraBoundary ) )
					{
						if( isdefined(objectWatcher.onDetonateCallback) )
						{
							objectWatcher thread weaponobjects::waitAndDetonate( objectArray[weaponObject], 0 );
						}
						else
						{
							weaponobjects::deleteWeaponObject( objectWatcher, objectArray[weaponObject] );
						}
					}
				}
			}
		}
	}

	//Check for tactical insertion
	extraBoundary = ( 15, 15, 15 );
	if( isdefined( player ) && isdefined( player.tacticalInsertion ) && self IsTouching( player.tacticalInsertion, extraBoundary ) )
	{
		player.tacticalInsertion thread tacticalinsertion::fizzle();
	}
}

function crateTimeOut( time )
{
	self endon("death");
	wait (time);
	self crateDelete( );
}
	


function spawnUseEnt()
{
	useEnt = spawn( "script_origin", self.origin );
	useEnt.curProgress = 0;
	useEnt.inUse = false;
	useEnt.useRate = 0;
	useEnt.useTime = 0;
	useEnt.owner = self;
	
	useEnt thread useEntOwnerDeathWaiter( self );

	return useEnt;
}

function useEntOwnerDeathWaiter( owner )
{
	self endon ( "death" );
	owner waittill ( "death" );
	
	self delete();
}

// taken from _gameobject maybe we can just use the _gameobject code
function crateUseThink() // self == crate
{
	while( isdefined(self) )
	{
		self waittill("trigger", player );
		
		if ( !isAlive( player ) )
			continue;
			
		if ( !player isOnGround() )
			continue;
		
		if ( isdefined( self.owner ) && self.owner == player )
			continue;
			
		useEnt = self spawnUseEnt();
		result = false;
		
		// if the crate has been hacked then we'll need to know later on the useEnt
		if( isdefined( self.hacker ) )
		{
			useEnt.hacker = self.hacker;
		}
		
		self.useEnt = useEnt;

		result = useEnt useHoldThink( player, level.crateNonOwnerUseTime );
		
		if ( isdefined( useEnt ) )
		{
			useEnt Delete();
		}
		
		if ( result )
		{
			scoreevents::giveCrateCaptureMedal( self, player );
			self notify("captured", player, false );
		}
	}
}

function crateUseThinkOwner() // self == crate
{
	self endon("joined_team");

	while( isdefined(self) )
	{
		self waittill("trigger", player );
		
		if ( !isAlive( player ) )
			continue;
			
		if ( !player isOnGround() )
			continue;
		
		if ( !isdefined( self.owner ) )
			continue;

		if ( self.owner != player )
			continue;
			
		result = self useHoldThink( player, level.crateOwnerUseTime );

		if ( result )
		{
			self notify("captured", player, false );
		}
	}
}

function useHoldThink( player, useTime ) // self == a script origin (useEnt) or the crate
{
	player notify ( "use_hold" );
	player util::freeze_player_controls( true );

	player util::_disableWeapon();

	self.curProgress = 0;
	self.inUse = true;
	self.useRate = 0;
	self.useTime = useTime;
	
	player thread personalUseBar( self );

	result = useHoldThinkLoop( player );
	
	if ( isdefined( player ) )
	{
		player notify( "done_using" );
	}
	
	if ( isdefined( player ) )
	{
		
		if ( IsAlive(player) )
		{
			player util::_enableWeapon();
	
			player util::freeze_player_controls( false );
		}
	}
	
	if ( isdefined( self ) )
	{
		self.inUse = false;
	}

	// result may be undefined if useholdthinkloop hits an endon
	if ( isdefined( result ) && result )
		return true;
	
	return false;
}

function continueHoldThinkLoop( player )
{
	if ( !isdefined(self ) )
		return false;
		
	if ( self.curProgress >= self.useTime )
		return false;
		
	if ( !IsAlive( player ) )
		return false;

	if ( player.throwingGrenade )
		return false;

	if ( !(player useButtonPressed()) )
		return false;

	if ( player meleeButtonPressed() )
		return false;
		
	if ( player IsInVehicle() )
		return false;
	
	if ( player IsWeaponViewOnlyLinked() )
		return false;

	if ( player IsRemoteControlling() )
		return false;

	return true;
}

function useHoldThinkLoop( player )
{
	level endon ( "game_ended" );
	self endon("disabled");
	self.owner endon( "crate_use_interrupt" );
	
	timedOut = 0;
	
	while( self continueHoldThinkLoop( player ) )
	{
		timedOut += 0.05;

		self.curProgress += (50 * self.useRate);
		self.useRate = 1;

		if ( self.curProgress >= self.useTime )
		{
			self.inUse = false;
						
			wait .05;
			
			return isAlive( player );
		}
		
		{wait(.05);};
		hostmigration::waitTillHostMigrationDone();
	}
	
	return false;
}

function crateGamblerThink()
{
	self endon( "death" );

	for ( ;; )
	{

		self waittill( "trigger_use_doubletap", player );

			
		if ( !player HasPerk( "specialty_showenemyequipment" ))
		{
			continue;
		}
		if( isdefined( self.useEnt ) && self.useEnt.inUse )
		{
			// TODO: get a fail sound for this
			if(  IsDefined( self.owner ) && self.owner != player )
				continue;
		}
		
		player playlocalsound ("uin_gamble_perk");
		
		self.crateType = getRandomCrateType( "gambler", self.crateType.name );
		self crateReactivate();
		self setHintStringForPerk( "specialty_showenemyequipment", self.crateType.hint );

		self notify( "crate_use_interrupt" );
		level notify( "use_interrupt", self );
		
		return;
	}
}

function crateReactivate()
{
	self setHintString( self.crateType.hint );

	icon = self getIconForCrate();
	
	self thread entityheadIcons::setEntityHeadIcon( self.team, self, level.crate_headicon_offset, icon, true );
}

function personalUseBar( object ) // self == player, object == a script origin (useEnt) or the crate
{
	self endon("disconnect");

	if( isdefined( self.useBar ) )
		return;
	
	self.useBar = hud::createSecondaryProgressBar();
	self.useBarText = hud::createSecondaryProgressBarText();

	if( self HasPerk( "specialty_showenemyequipment" ) && 
		object.owner != self && 
		!isdefined( object.hacker ) &&
		( ( level.teambased && object.owner.team != self.team ) || !level.teambased ) )
	{
		self.useBarText setText( &"KILLSTREAK_HACKING_CRATE" );
		self PlayLocalSound ( "evt_hacker_hacking" );
	}
	else if( self HasPerk( "specialty_showenemyequipment" ) &&
		isdefined( object.hacker ) &&
		(object.owner == self || 
		( level.teambased && object.owner.team == self.team ) ) )
	{
		self.useBarText setText( level.disarmingCrate );
		self PlayLocalSound ( "evt_hacker_hacking" );
	}
	else
	{
		self.useBarText setText( &"KILLSTREAK_CAPTURING_CRATE" );
	}

	lastRate = -1;
	while ( isAlive( self ) && isdefined(object) && object.inUse && !level.gameEnded )
	{
		if ( lastRate != object.useRate )
		{
			if( object.curProgress > object.useTime)
				object.curProgress = object.useTime;

			self.useBar hud::updateBar( object.curProgress / object.useTime, (1000 / object.useTime) * object.useRate );

			if ( !object.useRate )
			{
				self.useBar hud::hideElem();
				self.useBarText hud::hideElem();
			}
			else
			{
				self.useBar hud::showElem();
				self.useBarText hud::showElem();
			}
		}	
		lastRate = object.useRate;
		{wait(.05);};
	}
	
	self.useBar hud::destroyElem();
	self.useBarText hud::destroyElem();
}

function spawn_helicopter( owner, team, origin, angles, model, targetname, killstreak_id )
{
	chopper = spawnHelicopter( owner, origin, angles, model, targetname );
	if ( !isdefined( chopper ) )
	{
		if ( isplayer( owner ) )
		{
			killstreakrules::killstreakStop( "supply_drop", team, killstreak_id );
		}
		return undefined;
	}

	chopper.owner = owner;
	chopper.maxhealth = 1500;								// max health
	chopper.health = 999999;								// we check against maxhealth in the damage monitor to see if this gets destroyed, so we don't want this to die prematurely			
	chopper.rocketDamageOneShot = chopper.maxhealth + 1;	// Make it so the heatseeker blows it up in one hit for now
	chopper.damageTaken = 0;
	chopper thread helicopter::heli_damage_monitor( "supply_drop" );	
	chopper.spawnTime = GetTime();
	
	supplydropSpeed = GetDvarInt( "scr_supplydropSpeedStarting", 125 ); // 250);
	supplydropAccel = GetDvarInt( "scr_supplydropAccelStarting", 100 ); //175);
	chopper SetSpeed( supplydropSpeed, supplydropAccel );	

	maxPitch = GetDvarInt( "scr_supplydropMaxPitch", 25);
	maxRoll = GetDvarInt( "scr_supplydropMaxRoll", 45 ); // 85);
	chopper SetMaxPitchRoll( 0, maxRoll );	
	
	chopper.team = team;
	chopper SetDrawInfrared( true );
	
	Target_Set(chopper, ( 0, 0, -25 ));
	
	if ( isplayer( owner ) )
	{
		chopper thread refCountDecChopper(team, killstreak_id);
	}
	chopper thread heliDestroyed();

	return chopper;
}

function getDropHeight(origin)
{
	return airsupport::getMinimumFlyHeight();
}

function getDropDirection()
{
	return (0, RandomInt(360), 0);
}

function getNextDropDirection( drop_direction, degrees )
{
	drop_direction = (0, drop_direction[1] + degrees, 0 );

	if( drop_direction[1] >= 360 )
		drop_direction = (0, drop_direction[1] - 360, 0 );

	return drop_direction;
}

function getHeliStart( drop_origin, drop_direction )
{
	dist = -1 * GetDvarInt( "scr_supplydropIncomingDistance", 10000 ); // 15000);
	pathRandomness = 100;
	direction = drop_direction + (0, RandomIntRange( -2, 3 ), 0);
	
	start_origin = drop_origin + ( AnglesToForward( direction ) * dist );
	start_origin += ( (randomfloat(2) - 1)*pathRandomness, (randomfloat(2) - 1)*pathRandomness, 0 );
/#
	if ( GetDvarInt( "scr_noflyzones_debug", 0 ) ) 
	{
		if ( level.noFlyZones.size )
		{
			index = RandomIntRange( 0, level.noFlyZones.size );
			delta = drop_origin - level.noFlyZones[index].origin;
			delta = ( delta[0] + RandomInt(10), delta[1] + RandomInt(10), 0 );
			delta = VectorNormalize( delta );
			start_origin = drop_origin + ( delta * dist );
		}
	}
#/
	return start_origin;
}

function getHeliEnd( drop_origin, drop_direction )
{
	pathRandomness = 150;
	dist = -1 * GetDvarInt( "scr_supplydropOutgoingDistance", 15000);
	
	// have the heli do a sharp turn when leaving
	if ( RandomIntRange(0,2) == 0 )
		turn = RandomIntRange( 60,121);
	else
		turn = -1 * RandomIntRange( 60,121);
		
	direction = drop_direction + (0, turn, 0);
	
	end_origin = drop_origin + ( AnglesToForward( direction ) * dist );
	end_origin += ( (randomfloat(2) - 1)*pathRandomness  , (randomfloat(2) - 1)*pathRandomness  , 0 );

	return end_origin;
}

function addOffsetOntoPoint( point, direction, offset )
{
	angles = VectorToAngles( (direction[0], direction[1], 0) );
	
	offset_world = RotatePoint( offset, angles );
	
	return (point + offset_world);			
}

function supplyDropHeliStartPath(goal, goal_offset)
{
	total_tries = 12;
	tries = 0;
	
	goalPath = SpawnStruct();
	drop_direction = getDropDirection();
	
	
	while ( tries < total_tries )
	{
		goalPath.start = getHeliStart( goal, drop_direction );
		
		goalPath.path = airsupport::getHeliPath( goalPath.start, goal );
		
		startNoFlyZones = airsupport::insideNoFlyZones( goalPath.start, false );
		
		if ( IsDefined( goalPath.path ) && startNoFlyZones.size == 0 )
		{
			if ( goalPath.path.size > 1 )
			{
				direction = ( goalPath.path[goalPath.path.size - 1] - goalPath.path[goalPath.path.size - 2] );
			}
			else
			{
				direction = ( goalPath.path[goalPath.path.size - 1] - goalPath.start );
			}
			goalPath.path[goalPath.path.size - 1] = addOffsetOntoPoint(goalPath.path[goalPath.path.size - 1], direction, goal_offset);
/#
			sphere( goalPath.path[goalPath.path.size - 1], 10, (0,0,1), 1, true, 10, 1000 );
#/
			return goalPath;
		}
		
		//Couldn't find a path that didn't cross a no fly zone picking random directions, so try the last tried direction plus 30 degrees
		drop_direction = getNextDropDirection( drop_direction, 30 );
		
		tries++;
	}

	//Couldn't find a valid direction, so just bring it in even if it will fly through something
	drop_direction = getDropDirection();
	goalPath.start = getHeliStart( goal, drop_direction );
	
	direction = ( goal - goalPath.start );
	goalPath.path = [];
	goalPath.path[0] = addOffsetOntoPoint( goal, direction, goal_offset );
	
	return goalPath;
}

function supplyDropHeliEndPath(origin, drop_direction)
{
	total_tries = 5;
	tries = 0;
	
	goalPath = SpawnStruct();
	
	while ( tries < total_tries )
	{
		goal = getHeliEnd( origin, drop_direction );
		
		goalPath.path = airsupport::getHeliPath( origin, goal );
		
		if ( isdefined( goalPath.path ) )
		{
			return goalPath;
		}
		
		tries++;
	}
	
	// could not locate a clear path try the leave nodes
	leave_nodes = getentarray( "heli_leave", "targetname" ); 		
	foreach ( node in leave_nodes )
	{
		goalPath.path = airsupport::getHeliPath( origin, node.origin );
		
		if ( isdefined( goalPath.path ) )
		{
			return goalPath;
		}
	}
	
	// points where the helicopter leaves to
	goalPath.path = [];
	goalPath.path[0] = getHeliEnd( origin, drop_direction );
	
	return goalPath;
}

function incCrateKillstreakUsageStat(weapon)
{
	if ( weapon == level.weaponNone )
		return;

	switch ( weapon.name )
	{
	case "turret_drop":
		self killstreaks::play_killstreak_start_dialog( "turret_drop", self.pers["team"] );
		break;
	case "tow_turret_drop":
		self killstreaks::play_killstreak_start_dialog( "tow_turret_drop", self.pers["team"] );
		break;
	case "supplydrop":
	case "inventory_supplydrop":
		self killstreaks::play_killstreak_start_dialog( "supply_drop", self.pers["team"] );
		level thread popups::DisplayKillstreakTeamMessageToAll( "supply_drop", self );
		self challenges::calledInCarePackage();
		level.globalKillstreaksCalled++;
		self AddWeaponStat( GetWeapon( "supplydrop" ), "used", 1 );
		break;
	case "ai_tank_drop":
	case "inventory_ai_tank_drop":
		self killstreaks::play_killstreak_start_dialog( "ai_tank_drop", self.pers["team"] );
		level thread popups::DisplayKillstreakTeamMessageToAll( "ai_tank_drop", self );
		level.globalKillstreaksCalled++;
		self AddWeaponStat( GetWeapon( "ai_tank_drop" ), "used", 1 );
		break;
	case "inventory_minigun_drop":
	case "minigun_drop":
		self killstreaks::play_killstreak_start_dialog( "minigun", self.pers["team"] );
		break;
	case "m32_drop":
	case "inventory_m32_drop":
		self killstreaks::play_killstreak_start_dialog( "m32", self.pers["team"] );
		break;
	}
}

function heliDeliverCrate( origin, weapon, owner, team, killstreak_id, package_contents_id, exact )
{
	if ( owner emp::isEnemyEMPKillstreakActive() && !owner hasperk("specialty_immuneemp") )
	{
		killstreakrules::killstreakStop( "supply_drop", team, killstreak_id );
		return;
	}

	incCrateKillstreakUsageStat( weapon );

	rear_hatch_offset_local = GetDvarInt( "scr_supplydropOffset", 0);

	drop_origin = origin;
	drop_height = getDropHeight(drop_origin);

	heli_drop_goal = ( drop_origin[0], drop_origin[1], drop_height ); //  + rear_hatch_offset_world;
	
/#
	sphere( heli_drop_goal, 10, (0,1,0), 1, true, 10, 1000 );
#/

	goalPath = supplyDropHeliStartPath(heli_drop_goal, (rear_hatch_offset_local, 0, 0 ));
	drop_direction = VectorToAngles( (heli_drop_goal[0], heli_drop_goal[1], 0) - (goalPath.start[0], goalPath.start[1], 0));
	
	chopper = spawn_helicopter( owner, team, goalPath.start, drop_direction, level.suppyDropHelicopterVehicleInfo, level.supplyDropHelicopterFriendly, killstreak_id);
	chopper setenemymodel( level.supplyDropHelicopterEnemy );
	chopper SetTeam( team );
	chopper.numFlares = 0;
	
	if ( isplayer( owner ) )
	{
		chopper SetOwner( owner );
	}
	
	//Wait until the chopper is within the map bounds or within a certain distance of it's target before the SAM turret can target it
	if ( isplayer( owner ) )
	{
		Target_SetTurretAquire( self, false );
		chopper thread SAMTurretWatcher( drop_origin );
	}
	
	if ( !isdefined( chopper ) )
		return;
	
	chopper thread heliDropCrate( weapon, owner, rear_hatch_offset_local, killstreak_id, package_contents_id );
	chopper endon("death");
	
	chopper thread airsupport::followPath( goalPath.path, "drop_goal", true);

	chopper thread speedRegulator(heli_drop_goal);

	chopper waittill( "drop_goal" );
	
/#
	PrintLn("Chopper Incoming Time: " + ( GetTime() - chopper.spawnTime ) );
#/
	wait ( 1.2 );
	chopper notify("drop_crate", chopper.origin, chopper.angles);
	chopper.dropTime = GetTime();
	chopper playsound ("veh_supply_drop");
	
	wait ( 0.7 );
	
	supplydropSpeed = GetDvarInt( "scr_supplydropSpeedLeaving", 150 ); 
	supplydropAccel = GetDvarInt( "scr_supplydropAccelLeaving", 40 );
	chopper setspeed( supplydropSpeed, supplydropAccel );	

	goalPath = supplyDropHeliEndPath(chopper.origin, ( 0, chopper.angles[1], 0 ) );
	
	chopper airsupport::followPath( goalPath.path, undefined, false );

/#
	PrintLn("Chopper Outgoing Time: " + ( GetTime() - chopper.dropTime ) );
#/
	chopper notify( "leaving" );
	chopper Delete();
}

function SAMTurretWatcher( destination )
{
	self endon( "leaving" );
	self endon( "helicopter_gone" );
	self endon( "death" );

	SAM_TURRET_AQUIRE_DIST = 1500;

	while(1)
	{
		if( Distance( destination, self.origin ) < SAM_TURRET_AQUIRE_DIST )
			break;

		if( self.origin[0] > level.spawnMins[0] && self.origin[0] < level.spawnMaxs[0] &&
			self.origin[1] > level.spawnMins[1] && self.origin[1] < level.spawnMaxs[1] )
			break;

		wait( 0.1 );
	}

	Target_SetTurretAquire( self, true );
}

function speedRegulator( goal )
{
	self endon("drop_goal");
	self endon("death");
	
	wait (3);

	supplydropSpeed = GetDvarInt( "scr_supplydropSpeed", 75);
	supplydropAccel = GetDvarInt( "scr_supplydropAccel", 40);
	self SetYawSpeed( 100, 60, 60 );
	self SetSpeed( supplydropSpeed, supplydropAccel );	

	wait (1);
	maxPitch = GetDvarInt( "scr_supplydropMaxPitch", 25);
	maxRoll = GetDvarInt( "scr_supplydropMaxRoll", 35 ); // 85);
	self SetMaxPitchRoll( maxPitch, maxRoll );	
}

function heliDropCrate( category, owner, offset, killstreak_id, package_contents_id )
{
	owner endon ( "disconnect" );
	
	crate = crateSpawn( category, owner, self.team, self.origin, self.angles );
	
    if ( category == "inventory_supplydrop" || category == "supplydrop" )
    {
    	crate LinkTo( self, "tag_care_package", ( 0, 0, 0 ) );
    	self clientfield::set( "supplydrop_care_package_state", 1 );
    }
    else if ( category == "inventory_ai_tank_drop" || category == "ai_tank_drop" )
    {
    	crate LinkTo( self, "tag_drop_box", ( 0, 0, 0 ) );
    	self clientfield::set( "supplydrop_ai_tank_state", 1 );
    }
	
    team = self.team;
    
	self waittill("drop_crate", origin, angles);
	
	if ( isdefined( self ) )
	{
		if ( category == "inventory_supplydrop" || category == "supplydrop" )
	    {
	    	self clientfield::set( "supplydrop_care_package_state", 0 );
	    }
	    else if ( category == "inventory_ai_tank_drop" || category == "ai_tank_drop" )
	    {
	    	self clientfield::set( "supplydrop_ai_tank_state", 0 );
	    }
	}
	
	//ideally we can not respawn a new crate, but unlink the old crate then zero out the velocity
	rear_hatch_offset_height = GetDvarInt( "scr_supplydropOffsetHeight", 200);
	rear_hatch_offset_world = RotatePoint( ( offset, 0, 0), angles );
	drop_origin = origin - (0,0,rear_hatch_offset_height) - rear_hatch_offset_world;
	thread dropCrate(drop_origin, angles, category, owner, team, killstreak_id, package_contents_id, crate );
}

function heliDestroyed()
{
	self endon( "leaving" );
	self endon( "helicopter_gone" );
	self endon( "death" );
	
	while( true )
	{
		if( self.damageTaken > self.maxhealth )
			break;

		{wait(.05);};
	}

	if (! isdefined(self) )
		return;
		
	self SetSpeed( 25, 5 );
	self thread lbSpin( RandomIntRange(180, 220) );
	
	wait( RandomFloatRange( .5, 1.5 ) );
	
	self notify( "drop_crate", self.origin, self.angles );
	
	lbExplode();
}

// crash explosion
function lbExplode()
{
	forward = ( self.origin + ( 0, 0, 1 ) ) - self.origin;
	playfx ( level.chopper_fx["explode"]["death"], self.origin, forward );
	
	// play heli explosion sound
	self playSound( level.heli_sound["crash"] );
	self notify ( "explode" );

	self delete();
}


function lbSpin( speed )
{
	self endon( "explode" );
	
	// tail explosion that caused the spinning
	playfxontag( level.chopper_fx["explode"]["large"], self, "tail_rotor_jnt" );
	playfxontag( level.chopper_fx["fire"]["trail"]["large"], self, "tail_rotor_jnt" );
	
	self setyawspeed( speed, speed, speed );
	while ( isdefined( self ) )
	{
		self settargetyaw( self.angles[1]+(speed*0.9) );
		wait ( 1 );
	}
}

function refCountDecChopper( team, killstreak_id )
{
	self waittill("death");
	killstreakrules::killstreakStop( "supply_drop", team, killstreak_id );
}

function attachReconModel( modelName, owner )
{
	if ( !isdefined( self ) )
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

function resetReconModelVisibility( owner ) // self == reconModel
{	
	if ( !isdefined( self ) )
		return;
	
	self SetInvisibleToAll();
	self SetForceNoCull();

	if ( !isdefined( owner ) )
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

function watchReconModelForDeath( parentEnt ) // self == reconModel
{
	self endon( "death" );
	
	parentEnt util::waittill_any( "death", "captured" );
	self delete();
}

function resetReconModelOnEvent( eventName, owner ) // self == reconModel
{
	self endon( "death" );
	
	for ( ;; )
	{
		level waittill( eventName, newOwner );
		if( isdefined( newOwner ) )
		{
			owner = newOwner;
		}
		self resetReconModelVisibility( owner );
	}
}

/#
//Adds functionality so we can drop specific supply drops when we want for development purposes
function supply_drop_dev_gui()
{	
	//Init my dvar
	SetDvar("scr_supply_drop_gui", "");

	while(1)
	{
		wait(0.5);

		//Grab my dvar every frame
		devgui_string = GetDvarString( "scr_supply_drop_gui");

		//This  can happen in the dev gui. Look at devgui_mp.cfg.
		switch(devgui_string)
		{
		case "ammo":
			level.dev_gui_supply_drop = "ammo";
			break;
		case "spyplane":
			level.dev_gui_supply_drop = "radar";
			break;
		case "counter_u2":
			level.dev_gui_supply_drop = "counteruav";
			break;
		case "airstrike":
			level.dev_gui_supply_drop = "airstrike";
			break;
		case "artillery":
			level.dev_gui_supply_drop = "artillery";
			break;
		case "autoturret":
			level.dev_gui_supply_drop = "autoturret";
			break;
		case "microwave_turret":
			level.dev_gui_supply_drop = "microwaveturret";
			break;
		case "tow_turret":
			level.dev_gui_supply_drop = "auto_tow";
			break;
		case "dogs":
			level.dev_gui_supply_drop = "dogs";
			break;
		case "rc_bomb":
			level.dev_gui_supply_drop = "rcbomb";
			break;
		case "plane_mortar":
			level.dev_gui_supply_drop = "planemortar";
			break;
		case "heli":
			level.dev_gui_supply_drop = "helicopter_comlink";
			break;
		case "heli_gunner":
			level.dev_gui_supply_drop = "helicopter_player_gunner";
			break;
		case "straferun":
			level.dev_gui_supply_drop = "straferun";
			break;
		case "missile_swarm":
			level.dev_gui_supply_drop = "missile_swarm";
			break;
		case "missile_drone":
			level.dev_gui_supply_drop = "inventory_missile_drone";
			break;
		case "satellite":
			level.dev_gui_supply_drop = "radardirection";
			break;
		case "remote_missile":
			level.dev_gui_supply_drop = "remote_missile";
			break;
		case "helicopter_guard":
			level.dev_gui_supply_drop = "helicopter_guard";
			break;
		case "emp":
			level.dev_gui_supply_drop = "emp";
			break;
		case "remote_mortar":
			level.dev_gui_supply_drop = "remote_mortar";
			break;
		case "qrdrone":
			level.dev_gui_supply_drop = "qrdrone";
			break;			
		case "ai_tank":
			level.dev_gui_supply_drop = "inventory_ai_tank_drop";
			break;
		case "minigun":
			level.dev_gui_supply_drop = "inventory_minigun";
			break;
		case "m32":
			level.dev_gui_supply_drop = "inventory_m32";
			break;
		case "random":
			level.dev_gui_supply_drop = "random";
			break;
		default:
			break;
		}	
	}
}
#/
