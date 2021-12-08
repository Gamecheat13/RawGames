-- Copyright (c) Microsoft Corporation.  All rights reserved.

--## SERVER

-- typed hstructs containing trait definitions
hstructure TraitDefinition
	traitId:string;
	-- when custom games come online, variable names and
	-- descriptions should be defined here for UI
end

hstructure TraitDefinitionFloat:TraitDefinition
	-- float-specific defaults & min/max for custom games
end

hstructure TraitDefinitionInt:TraitDefinition
	-- int-specific defaults & min/max for custom games
end

hstructure TraitDefinitionBool:TraitDefinition
	-- bool-specific defaults for custom games
end

-- global table of enums corresponding to player traits and their data types
-- based on ManagedEngine\GameEngineVariant\PlayerTraitsDefinition.cs
--
-- if you add a new enum here, you must also add a new TraitDefinition to
-- the g_playerTraitDefinitions table below this one
global g_playerTraits:table = table.makeAutoEnum
{
	-- FLOAT VALUES
	"DirectDamageResistanceMultiplier",
	"GrenadeDamageResistanceMultiplier",
	"AOEDamageResistanceMultiplier",
	"HealthMultiplier",
	"ShieldMultiplier",
	"BodyStunDuration",
	"ShieldStunDuration",
	"BodyRechargeRate",
	"ShieldRechargeRate",
	"MovementSpeed",
	"GravityScalar",
	"JumpScalar",
	"ClamberScalar",
	"ForwardSpeedScalar",
	"StrafeSpeedScalar",
	"ForwardAccelerationScalar",
	"StrafeAccelerationScalar",
	"AirborneAccelerationScalar",
	"SlideMaxDistanceScalar",
	"SlideSpeedScalar",
	"WeaponDamageMultiplier",
	"MeleeDamageMultiplier",
	"MeleeKnockbackMultiplier",
	"MeleeRecoverySpeedScalar",
	"GrenadeDamageMultiplier",
	"GrenadeKnockbackMultiplier",
	"MotionTrackerThresholdSpeedFriends",
	"MotionTrackerThresholdSpeedEnemies",
	"MotionTrackerVisibilityScalar",
	"MotionTrackerRange",
	"MotionTrackerRangeExtended",
	"MotionTrackerRangeVehicle",
	"DamageOvershield",
	"WeaponSwitchSpeed",
	"EmptyReloadSpeed",
	"TacticalReloadSpeed",
	"MovementSpeedWithTurret",
	"AOERadius",
	"BodyVampirism",
	"ShieldVampirism",
	"EvadeSpeed",
	"SprintExitAnimSpeed",
	"SprintSecondsToFullSpeed",
	"SprintFullSpeed",
	"SpartanAbilityStabilizerTimeLimit",
	"SpartanAbilityStabilizerTimeScale",
	"SpartanAbilityShoulderBashKnockbackScalar",
	"SpartanAbilityShoulderBashDamageScalar",
	"SpartanAbilityShoulderBashTargetDistanceScalar",
	"SpartanAbilityGroundPoundKnockbackScalar",
	"SpartanAbilityGroundPoundDamageScalar",
	"SpartanAbilityGroundPoundAOERadiusScalar",
	"SpartanAbilityGroundPoundMinChargeTimeScalar",
	"SpartanAbilityGroundPoundAutoReleaseTimeScalar",
	"SpartanAbilityGroundPoundFallSpeed",
	"ActiveCamouflageIntensity",
	"ActiveCamouflageInterpolationTime",
	"ActiveCamouflageGrenadeThrowPenalty",
	"ActiveCamouflageMeleePenalty",
	"ActiveCamouflageMinimumDingedAmount",
	"AssassinationSpeed",
	"GrenadeThrowSpeed",

	-- INT VALUES
	"InitialFragGrenadeCountModifier",
	"MaxFragGrenadeCountModifier",
	"InitialPlasmaGrenadeCountModifier",
	"MaxPlasmaGrenadeCountModifier",
	"InitialForerunnerGrenadeCountModifier",
	"MaxForerunnerGrenadeCountModifier",

	-- BOOL VALUES
	"MotionTrackerEnabled",
	"MotionTrackerWhileZoomedEnabled",
	"MotionTrackerTracksNeutrals",
	"MotionTrackerTracksEnemies",
	"DirectionalDamageIndicatorEnabled",
	"ShieldHUDEnabled",
	"ShieldEffectsEnabled",
	"SprintEnableWhileReloading",
	"SprintEnableShieldStunReset",
	"SprintEnableStoppingPower",
	"InfiniteAmmo",
	"BottomlessClip",
	"Deathless",
	"AssassinationImmunity",
	"HeadshotImmunity",
	"SprintEnabled",
	"ClamberEnabled",
	"ThrustersEnabled",
	"StabilizerEnabled",
	"GroundPoundEnabled",
	"ShoulderBashEnabled",
	"CanOnlyEnterPassengerSeats",
	"WeaponThrowingEnabled",
	"CanWeaponsPersistAfterBeingDropped",
	"WeaponPickupAllowed",
	"GrenadePickupAllowed",
	"PowerupPickupAllowed",
	"EquipmentPickupAllowed",
};

-- global table of trait definitions indexed by the above g_playerTraits enum
-- uses TraitDefinition subclasses to allow struct.name() inspection in scripts
global g_playerTraitDefinitions:table = table.makePermanent
{
	-- FLOAT DEFINITIONS
	[g_playerTraits.DirectDamageResistanceMultiplier] = hmake TraitDefinitionFloat
	{
		traitId = "direct_damage_resistance",
	},
	[g_playerTraits.GrenadeDamageResistanceMultiplier] = hmake TraitDefinitionFloat
	{
		traitId = "grenade_damage_resistance",
	},
	[g_playerTraits.AOEDamageResistanceMultiplier] = hmake TraitDefinitionFloat
	{
		traitId = "aoe_damage_resistance",
	},
	[g_playerTraits.HealthMultiplier] = hmake TraitDefinitionFloat
	{
		traitId = "maximum_body_vitality",
	},
	[g_playerTraits.ShieldMultiplier] = hmake TraitDefinitionFloat
	{
		traitId = "maximum_shield_vitality",
	},
	[g_playerTraits.BodyStunDuration] = hmake TraitDefinitionFloat
	{
		traitId = "body_stun_duration",
	},
	[g_playerTraits.ShieldStunDuration] = hmake TraitDefinitionFloat
	{
		traitId = "shield_stun_duration",
	},
	[g_playerTraits.BodyRechargeRate] = hmake TraitDefinitionFloat
	{
		traitId = "body_recharge_rate_scalar",
	},
	[g_playerTraits.ShieldRechargeRate] = hmake TraitDefinitionFloat
	{
		traitId = "shield_recharge_rate_scalar",
	},
	[g_playerTraits.MovementSpeed] = hmake TraitDefinitionFloat
	{
		traitId = "biped_movement_speed_scalar",
	},
	[g_playerTraits.GravityScalar] = hmake TraitDefinitionFloat
	{
		traitId = "biped_movement_gravity_scalar",
	},
	[g_playerTraits.JumpScalar] = hmake TraitDefinitionFloat
	{
		traitId = "biped_movement_jump_scalar",
	},
	[g_playerTraits.ClamberScalar] = hmake TraitDefinitionFloat
	{
		traitId = "biped_movement_clamber_speed_scalar",
	},
	[g_playerTraits.ForwardSpeedScalar] = hmake TraitDefinitionFloat
	{
		traitId = "biped_speed_forward_scalar",
	},
	[g_playerTraits.StrafeSpeedScalar] = hmake TraitDefinitionFloat
	{
		traitId = "biped_speed_strafe_scalar",
	},
	[g_playerTraits.ForwardAccelerationScalar] = hmake TraitDefinitionFloat
	{
		traitId = "biped_acceleration_forward_scalar",
	},
	[g_playerTraits.StrafeAccelerationScalar] = hmake TraitDefinitionFloat
	{
		traitId = "biped_acceleration_strafe_scalar",
	},
	[g_playerTraits.AirborneAccelerationScalar] = hmake TraitDefinitionFloat
	{
		traitId = "biped_acceleration_airborne_scalar",
	},
	[g_playerTraits.SlideMaxDistanceScalar] = hmake TraitDefinitionFloat
	{
		traitId = "biped_slide_max_distance_scalar",
	},
	[g_playerTraits.SlideSpeedScalar] = hmake TraitDefinitionFloat
	{
		traitId = "biped_slide_speed_scalar",
	},
	[g_playerTraits.WeaponDamageMultiplier] = hmake TraitDefinitionFloat
	{
		traitId = "weapon_damage_scalar",
	},
	[g_playerTraits.MeleeDamageMultiplier] = hmake TraitDefinitionFloat
	{
		traitId = "melee_damage_scalar",
	},
	[g_playerTraits.MeleeKnockbackMultiplier] = hmake TraitDefinitionFloat
	{
		traitId = "melee_knockback_scalar",
	},
	[g_playerTraits.MeleeRecoverySpeedScalar] = hmake TraitDefinitionFloat
	{
		traitId = "melee_recovery_speed_scalar",
	},
	[g_playerTraits.GrenadeDamageMultiplier] = hmake TraitDefinitionFloat
	{
		traitId = "grenade_damage_scalar",
	},
	[g_playerTraits.GrenadeKnockbackMultiplier] = hmake TraitDefinitionFloat
	{
		traitId = "grenade_knockback_scalar",
	},
	[g_playerTraits.MotionTrackerThresholdSpeedFriends] = hmake TraitDefinitionFloat
	{
		traitId = "player_motion_tracker_threshold_speed_friends",
	},
	[g_playerTraits.MotionTrackerThresholdSpeedEnemies] = hmake TraitDefinitionFloat
	{
		traitId = "player_motion_tracker_threshold_speed_enemies",
	},
	[g_playerTraits.MotionTrackerVisibilityScalar] = hmake TraitDefinitionFloat
	{
		traitId = "player_motion_tracker_visibility_scalar",
	},
	[g_playerTraits.MotionTrackerRange] = hmake TraitDefinitionFloat
	{
		traitId = "player_motion_tracker_range",
	},
	[g_playerTraits.MotionTrackerRangeExtended] = hmake TraitDefinitionFloat
	{
		traitId = "player_motion_tracker_range_extended",
	},
	[g_playerTraits.MotionTrackerRangeVehicle] = hmake TraitDefinitionFloat
	{
		traitId = "player_motion_tracker_range_vehicle",
	},
	[g_playerTraits.DamageOvershield] = hmake TraitDefinitionFloat
	{
		traitId = "damage_overshield_max_scalar",
	},
	[g_playerTraits.WeaponSwitchSpeed] = hmake TraitDefinitionFloat
	{
		traitId = "unit_weapon_switch_speed_scalar",
	},
	[g_playerTraits.EmptyReloadSpeed] = hmake TraitDefinitionFloat
	{
		traitId = "unit_weapon_empty_reload_speed_scalar",
	},
	[g_playerTraits.TacticalReloadSpeed] = hmake TraitDefinitionFloat
	{
		traitId = "unit_weapon_tactical_reload_speed_scalar",
	},
	[g_playerTraits.MovementSpeedWithTurret] = hmake TraitDefinitionFloat
	{
		traitId = "unit_turret_movement_speed_scalar",
	},
	[g_playerTraits.AOERadius] = hmake TraitDefinitionFloat
	{
		traitId = "aoe_radius_scalar",
	},
	[g_playerTraits.BodyVampirism] = hmake TraitDefinitionFloat
	{
		traitId = "body_vampirism_scalar",
	},
	[g_playerTraits.ShieldVampirism] = hmake TraitDefinitionFloat
	{
		traitId = "shield_vampirism_scalar",
	},
	[g_playerTraits.EvadeSpeed] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_evade_speed_scalar",
	},
	[g_playerTraits.SprintExitAnimSpeed] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_sprint_exit_anim_speed_scalar",
	},
	[g_playerTraits.SprintSecondsToFullSpeed] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_sprint_seconds_to_full_speed",
	},
	[g_playerTraits.SprintFullSpeed] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_sprint_full_speed_scalar",
	},
	[g_playerTraits.SpartanAbilityStabilizerTimeLimit] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_stabilizer_time_limit",
	},
	[g_playerTraits.SpartanAbilityStabilizerTimeScale] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_stabilizer_time_scale",
	},
	[g_playerTraits.SpartanAbilityShoulderBashKnockbackScalar] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_shoulderbash_knockback_scalar",
	},
	[g_playerTraits.SpartanAbilityShoulderBashDamageScalar] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_shoulderbash_damage_scalar",
	},
	[g_playerTraits.SpartanAbilityShoulderBashTargetDistanceScalar] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_shoulderbash_target_distance_scalar",
	},
	[g_playerTraits.SpartanAbilityGroundPoundKnockbackScalar] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_groundpound_knockback_scalar",
	},
	[g_playerTraits.SpartanAbilityGroundPoundDamageScalar] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_groundpound_damage_scalar",
	},
	[g_playerTraits.SpartanAbilityGroundPoundAOERadiusScalar] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_groundpound_aoe_radius_scalar",
	},
	[g_playerTraits.SpartanAbilityGroundPoundMinChargeTimeScalar] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_groundpound_min_charge_time_scalar",
	},
	[g_playerTraits.SpartanAbilityGroundPoundAutoReleaseTimeScalar] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_groundpound_auto_release_time_scalar",
	},
	[g_playerTraits.SpartanAbilityGroundPoundFallSpeed] = hmake TraitDefinitionFloat
	{
		traitId = "spartan_ability_groundpound_fall_speed",
	},
	[g_playerTraits.ActiveCamouflageIntensity] = hmake TraitDefinitionFloat
	{
		traitId = "active_camouflage_intensity",
	},
	[g_playerTraits.ActiveCamouflageInterpolationTime] = hmake TraitDefinitionFloat
	{
		traitId = "active_camouflage_interpolation_time",
	},
	[g_playerTraits.ActiveCamouflageGrenadeThrowPenalty] = hmake TraitDefinitionFloat
	{
		traitId = "active_camouflage_grenade_throw_penalty",
	},
	[g_playerTraits.ActiveCamouflageMeleePenalty] = hmake TraitDefinitionFloat
	{
		traitId = "active_camouflage_melee_penalty",
	},
	[g_playerTraits.ActiveCamouflageMinimumDingedAmount] = hmake TraitDefinitionFloat
	{
		traitId = "active_camouflage_minimum_dinged_amount",
	},
	[g_playerTraits.AssassinationSpeed] = hmake TraitDefinitionFloat
	{
		traitId = "unit_weapon_assassination_speed_scalar",
	},
	[g_playerTraits.GrenadeThrowSpeed] = hmake TraitDefinitionFloat
	{
		traitId = "unit_grenade_throw_speed_scalar",
	},

	-- INT DEFINITIONS
	[g_playerTraits.InitialFragGrenadeCountModifier] = hmake TraitDefinitionInt
	{
		traitId = "initial_frag_grenade_count",
	},
	[g_playerTraits.MaxFragGrenadeCountModifier] = hmake TraitDefinitionInt
	{
		traitId = "max_frag_grenade_count",
	},
	[g_playerTraits.InitialPlasmaGrenadeCountModifier] = hmake TraitDefinitionInt
	{
		traitId = "initial_plasma_grenade_count",
	},
	[g_playerTraits.MaxPlasmaGrenadeCountModifier] = hmake TraitDefinitionInt
	{
		traitId = "max_plasma_grenade_count",
	},
	[g_playerTraits.InitialForerunnerGrenadeCountModifier] = hmake TraitDefinitionInt
	{
		traitId = "initial_forerunner_grenade_count",
	},
	[g_playerTraits.MaxForerunnerGrenadeCountModifier] = hmake TraitDefinitionInt
	{
		traitId = "max_forerunner_grenade_count",
	},

	-- BOOL DEFINITIONS
	[g_playerTraits.MotionTrackerEnabled] = hmake TraitDefinitionBool
	{
		traitId = "player_motion_tracker_enabled",
	},
	[g_playerTraits.MotionTrackerWhileZoomedEnabled] = hmake TraitDefinitionBool
	{
		traitId = "player_motion_tracker_while_zoom_enabled",
	},
	[g_playerTraits.MotionTrackerTracksNeutrals] = hmake TraitDefinitionBool
	{
		traitId = "player_motion_tracker_tracks_neutrals",
	},
	[g_playerTraits.MotionTrackerTracksEnemies] = hmake TraitDefinitionBool
	{
		traitId = "player_motion_tracker_tracks_enemies",
	},
	[g_playerTraits.DirectionalDamageIndicatorEnabled] = hmake TraitDefinitionBool
	{
		traitId = "player_directional_damage_indicator_enabled",
	},
	[g_playerTraits.ShieldHUDEnabled] = hmake TraitDefinitionBool
	{
		traitId = "player_shield_hud_enabled",
	},
	[g_playerTraits.ShieldEffectsEnabled] = hmake TraitDefinitionBool
	{
		traitId = "shield_effects_enabled",
	},
	[g_playerTraits.SprintEnableWhileReloading] = hmake TraitDefinitionBool
	{
		traitId = "spartan_ability_sprint_enable_while_reloading",
	},
	[g_playerTraits.SprintEnableShieldStunReset] = hmake TraitDefinitionBool
	{
		traitId = "spartan_ability_sprint_enable_shield_stun_reset",
	},
	[g_playerTraits.SprintEnableStoppingPower] = hmake TraitDefinitionBool
	{
		traitId = "spartan_ability_sprint_enable_stopping_power",
	},
	[g_playerTraits.InfiniteAmmo] = hmake TraitDefinitionBool
	{
		traitId = "unit_weapon_infinite_ammo",
	},
	[g_playerTraits.BottomlessClip] = hmake TraitDefinitionBool
	{
		traitId = "unit_weapon_bottomless_clip",
	},
	[g_playerTraits.Deathless] = hmake TraitDefinitionBool
	{
		traitId = "deathless",
	},
	[g_playerTraits.AssassinationImmunity] = hmake TraitDefinitionBool
	{
		traitId = "assassination_immunity",
	},
	[g_playerTraits.HeadshotImmunity] = hmake TraitDefinitionBool
	{
		traitId = "headshot_immunity",
	},
	[g_playerTraits.SprintEnabled] = hmake TraitDefinitionBool
	{
		traitId = "biped_sprint_enabled",
	},
	[g_playerTraits.ClamberEnabled] = hmake TraitDefinitionBool
	{
		traitId = "biped_clamber_enabled",
	},
	[g_playerTraits.ThrustersEnabled] = hmake TraitDefinitionBool
	{
		traitId = "biped_thrusters_enabled",
	},
	[g_playerTraits.StabilizerEnabled] = hmake TraitDefinitionBool
	{
		traitId = "biped_stabilizer_enabled",
	},
	[g_playerTraits.GroundPoundEnabled] = hmake TraitDefinitionBool
	{
		traitId = "biped_groundpound_enabled",
	},
	[g_playerTraits.ShoulderBashEnabled] = hmake TraitDefinitionBool
	{
		traitId = "biped_shoulderbash_enabled",
	},
	[g_playerTraits.CanOnlyEnterPassengerSeats] = hmake TraitDefinitionBool
	{
		traitId = "biped_can_only_enter_passenger_seats",
	},
	[g_playerTraits.WeaponThrowingEnabled] = hmake TraitDefinitionBool
	{
		traitId = "biped_inventory_weapon_throwing_enabled",
	},
	[g_playerTraits.CanWeaponsPersistAfterBeingDropped] = hmake TraitDefinitionBool
	{
		traitId = "biped_inventory_can_weapons_persist_after_being_dropped",
	},
	[g_playerTraits.WeaponPickupAllowed] = hmake TraitDefinitionBool
	{
		traitId = "unit_weapon_pickup_allowed",
	},
	[g_playerTraits.GrenadePickupAllowed] = hmake TraitDefinitionBool
	{
		traitId = "biped_inventory_grenade_pickup_allowed",
	},
	[g_playerTraits.PowerupPickupAllowed] = hmake TraitDefinitionBool
	{
		traitId = "biped_inventory_powerup_pickup_allowed",
	},
	[g_playerTraits.EquipmentPickupAllowed] = hmake TraitDefinitionBool
	{
		traitId = "biped_inventory_equipment_pickup_allowed",
	},
};
