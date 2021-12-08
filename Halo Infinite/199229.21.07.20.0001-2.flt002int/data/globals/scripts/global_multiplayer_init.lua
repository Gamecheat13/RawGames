-- Copyright (C) Microsoft. All rights reserved.

REQUIRES('globals/scripts/callbacks/GlobalCallbacks.lua')
REQUIRES('globals/scripts/global_academy.lua')
REQUIRES('globals/scripts/global_multiplayer_medals.lua')
REQUIRES('scripts/AirDrop/AirDrop.lua')
REQUIRES('globals/scripts/global_multiplayer_navpoint_states.lua')
REQUIRES('globals/scripts/global_mp_spawn_influencers.lua') 

-------------------------------------------------
----------------- TAG TABLES --------------------
--    These need to be on client and server    --
-------------------------------------------------
global WeaponTags:table = {
	-- Release 1
	assault_rifle 			= TAG('objects\weapons\rifle\assault_rifle\assault_rifle.weapon'),
	battle_rifle			= TAG('objects\weapons\rifle\br\br.weapon');
	commando_rifle			= TAG('objects\weapons\rifle\commando_rifle\commando_rifle.weapon'),
	energy_sword			= TAG('objects\weapons\melee\energy_sword\energy_sword.weapon'),
	gravity_hammer			= TAG('objects\weapons\melee\gravity_hammer\gravity_hammer.weapon'),
	hotrod					= TAG('objects\weapons\proto\proto_hotrod_gun\proto_hotrod_gun.weapon'),
	hydra					= TAG('objects\weapons\rifle\mlrs\mlrs.weapon'),
	needler					= TAG('objects\weapons\pistol\needler\needler.weapon'),
	plasma_blaster			= TAG('objects\weapons\proto\proto_plasma_plasmablaster\proto_plasma_plasmablaster.weapon'),
	plasma_pistol			= TAG('objects\weapons\pistol\plasma_pistol\plasma_pistol.weapon'),
	proto_combat_shotgun	= TAG('objects\weapons\proto\proto_combat_shotgun\proto_combat_shotgun.weapon'),
	proto_heatwave			= TAG('objects\weapons\proto\proto_heatwave\proto_heatwave.weapon'),
	proto_arc_zapper		= TAG('objects\weapons\proto\proto_arc_zapper\proto_arc_zapper.weapon'),
	proto_plasma_wetwork	= TAG('objects\weapons\proto\proto_plasma_wetwork\proto_plasma_wetwork.weapon'),
	proto_volt_action		= TAG('objects\weapons\proto\proto_volt_action\proto_volt_action.weapon'),	
	proto_spiker_revolver	= TAG('objects\weapons\proto\proto_spike_revolver\proto_spike_revolver.weapon'),
	provoker				= TAG('objects\weapons\rifle\provoker\provoker.weapon'),
	rocket_launcher			= TAG('objects\weapons\support_high\spnker_rocket_launcher_olympus\spnker_rocket_launcher_olympus.weapon'),
	sentinel_beam			= TAG('objects\weapons\proto\proto_hardlight_sentinel_beam\proto_hardlight_sentinel_beam.weapon'),
	sidearm_pistol 			= TAG('objects\weapons\pistol\sidearm_pistol\sidearm_pistol.weapon'),
	skewer					= TAG('objects\weapons\proto\proto_skewer\proto_skewer.weapon'),
	sniper_rifle			= TAG('objects\weapons\rifle\sniper_rifle\sniper_rifle.weapon'),
	
	-- Future Releases/Prototype
	unarmed					= TAG('objects\weapons\melee\unarmed\unarmed.weapon'),
};

global MPWeaponVariantTags = {
	assault_rifle_longshot 		= TAG('objects\weapons\rifle\assault_rifle\configurations\ar_tactical.weapon_configuration'),
	battle_rifle_breacher 		= TAG('objects\weapons\rifle\br\configurations\br_scout.weapon_configuration'),
	bulldog_convergence 		= TAG('objects\weapons\proto\proto_combat_shotgun\configurations\choke_shotgun.weapon_configuration'),
	cindershot_backdraft 		= TAG('objects\weapons\proto\proto_heatwave\configurations\overcooked_heatwave.weapon_configuration'),
	commando_rifle_impact 		= TAG('objects\weapons\rifle\commando_rifle\configurations\suburban_commando.weapon_configuration'),
	disrupter_calcine	 		= TAG('objects\weapons\proto\proto_arc_zapper\configurations\discharge_arc_zapper.weapon_configuration'),
	energy_sword_duelist 		= TAG('objects\weapons\melee\energy_sword\configurations\striker_energy_sword.weapon_configuration'),
	gravity_hammer_rushdown		= TAG('objects\weapons\melee\gravity_hammer\configurations\frontlines_gavity_hammer.weapon_configuration'),
	heatwave_scatterbound 		= TAG('objects\weapons\proto\proto_hotrod_gun\configurations\smartbounce_hotrod.weapon_configuration'),
	hydra_pursuit				= TAG('objects\weapons\rifle\mlrs\configurations\surgical_strike_hydra.weapon_configuration'),
	mangler_riven				= TAG('objects\weapons\proto\proto_spike_revolver\configurations\blaster_spike_revolver.weapon_configuration'),
	needler_pinpoint			= TAG('objects\weapons\pistol\needler\configurations\seeker_needler.weapon_configuration'),
	plasma_pistol_unbound		= TAG('objects\weapons\pistol\plasma_pistol\configurations\unlocked_plasma_pistol.weapon_configuration'),
	pulse_carbine_rapidfire		= TAG('objects\weapons\proto\proto_plasma_wetwork\configurations\auto_wetwork.weapon_configuration'),
	ravager_rebound				= TAG('objects\weapons\rifle\provoker\configurations\bouncing_provoker.weapon_configuration'),
	rocket_launcher_tracker		= TAG('objects\weapons\support_high\spnker_rocket_launcher_olympus\configurations\tracking_rocket_launcher.weapon_configuration'),
	sentinel_beam_heatrod		= TAG('objects\weapons\proto\proto_hardlight_sentinel_beam\configurations\heatrod_hardlight_sentinel_beam.weapon_configuration'),
	shock_rifle_purging			= TAG('objects\weapons\proto\proto_volt_action\configurations\overclocked_volt_action.weapon_configuration'),
	sidekick_striker			= TAG('objects\weapons\pistol\sidearm_pistol\configurations\elite_sidearm_pistol.weapon_configuration'),
	skewer_volatile				= TAG('objects\weapons\proto\proto_skewer\configurations\explosive_skewer.weapon_configuration'),
	sniper_rifle_flexfire		= TAG('objects\weapons\rifle\sniper_rifle\configurations\dmr_sniper.weapon_configuration'),
	stalker_rifle_ultra			= TAG('objects\weapons\proto\proto_plasma_plasmablaster\configurations\commando_plasma_blaster.weapon_configuration'),
};

global MPFlightingProhibitedWeapons = {
	MP_WEAPON_IDENTIFIER.Cindershot,	
	MP_WEAPON_IDENTIFIER.Disruptor,
	MP_WEAPON_IDENTIFIER.EnergySword,
	MP_WEAPON_IDENTIFIER.Hydra,
	MP_WEAPON_IDENTIFIER.Mangler,
	MP_WEAPON_IDENTIFIER.SentinelBeam,
	MP_WEAPON_IDENTIFIER.ShockRifle,
	MP_WEAPON_IDENTIFIER.StalkerRifle,
};

global MPWeaponClassFallbacks = {
	[MP_WEAPON_TIER.Base] = {
		[MP_WEAPON_CLASS.Pistol] = MP_WEAPON_CLASS.AssaultRifle,
		[MP_WEAPON_CLASS.AssaultRifle] = MP_WEAPON_CLASS.Pistol,
		[MP_WEAPON_CLASS.TacticalRifle] = MP_WEAPON_CLASS.AssaultRifle,
		[MP_WEAPON_CLASS.SMG] = MP_WEAPON_CLASS.Shotgun,
		[MP_WEAPON_CLASS.Shotgun] = MP_WEAPON_CLASS.SMG,
		[MP_WEAPON_CLASS.SniperRifle] = MP_WEAPON_CLASS.TacticalRifle,
		[MP_WEAPON_CLASS.Launcher] = MP_WEAPON_CLASS.SMG,
	},

	[MP_WEAPON_TIER.Power] = {
		[MP_WEAPON_CLASS.SniperRifle] = MP_WEAPON_CLASS.Launcher,
		[MP_WEAPON_CLASS.Launcher] = MP_WEAPON_CLASS.SniperRifle,
		[MP_WEAPON_CLASS.Melee] = MP_WEAPON_CLASS.Launcher,
	},
};

global EquipmentTags:table = {
	--Equipment
	evade 				= TAG('objects\armor\attachments\ability_pickups\evade_pickup.equipment'),
	grapple 			= TAG('objects\armor\attachments\ability_pickups\grapple_hook_pickup.equipment'),
	knockback	 		= TAG('objects\armor\attachments\ability_pickups\knockback_pickup.equipment'),
	loc_sensor			= TAG('objects\armor\attachments\ability_pickups\loc_sensor_pickup.equipment'),
	wall		 		= TAG('objects\armor\attachments\attachment_abilities\spartan_equipment\deployable_wall\deployable_wall_pickup.equipment'),

	-- Grenade
	frag_grenade 			= TAG('objects\weapons\grenade\frag_grenade\frag_grenade.equipment'),
	lightning_grenade 		= TAG('objects\weapons\proto\proto_lightning_grenade\proto_lightning_grenade.equipment'),
	plasma_grenade 			= TAG('objects\weapons\grenade\plasma_grenade\plasma_grenade.equipment'),
	spike_grenade 			= TAG('objects\weapons\grenade\spike_grenade\spike_grenade.equipment'),

	-- Power Up
	camo 				= TAG('objects\equipment\unsc\active_camo\active_camo_pickup.equipment'),
	overshield 			= TAG('objects\equipment\unsc\overshield\overshield_pickup.equipment'),
};

global MPEquipVariantTags = {
	shockwall 					= TAG('objects\armor\attachments\attachment_abilities\spartan_equipment\deployable_wall\legendary\deployable_wall_legendary_pickup.equipment'),
	grapple_strike 				= TAG('objects\armor\attachments\attachment_abilities\ability_grapple_hook\legendary\grapple_hook_legendary_pickup.equipment'),
	long_range_threat_sensor	= TAG('objects\armor\attachments\attachment_abilities\ability_location_sensor_drone\legendary\loc_sensor_legendary_pickup.equipment'),
	cloaked_thruster			= TAG('objects\armor\attachments\attachment_abilities\ability_evade\legendary\evade_legendary_pickup.equipment'),
};

global MPEquipVariantAttachmentTags = {
	shockwall 					= TAG('objects\armor\attachments\attachment_abilities\spartan_equipment\deployable_wall\legendary\deployable_wall_legendary.equipment'),
	grapple_strike 				= TAG('objects\armor\attachments\attachment_abilities\ability_grapple_hook\legendary\ability_grapple_hook_legendary.grapplehookdefinitiontag'),
	long_range_threat_sensor	= TAG('objects\armor\attachments\attachment_abilities\ability_location_sensor_drone\legendary\ability_location_sensor_legendary.equipment'),
	cloaked_thruster			= TAG('objects\armor\attachments\attachment_abilities\ability_evade\legendary\ability_evade_legendary.evadedefinitiontag'),
};

global MPEquipmentAttachmentNames:table = {
	evade 					= TAG('objects\armor\attachments\attachment_abilities\ability_evade\ability_evade.evadedefinitiontag'),
	grapple 				= TAG('objects\armor\attachments\attachment_abilities\ability_grapple_hook\spartan_ability\ability_grapple_hook.grapplehookdefinitiontag'),
	knockback	 			= TAG('objects\armor\attachments\attachment_abilities\ability_knockback\ability_knockback.equipment'),
	loc_sensor				= TAG('objects\armor\attachments\attachment_abilities\ability_location_sensor_drone\ability_location_sensor_sticky.equipment'),
	wall					= TAG('objects\armor\attachments\attachment_abilities\spartan_equipment\deployable_wall\deployable_wall.equipment'),
							  
	frag_grenade 			= TAG('objects\armor\attachments\attachment_abilities\ability_frag_grenade\ability_frag_grenade.equipment'),
	lightning_grenade 		= TAG('objects\armor\attachments\attachment_abilities\ability_lightning_grenade\ability_lightning_grenade.equipment'),
	plasma_grenade 			= TAG('objects\armor\attachments\attachment_abilities\ability_plasma_grenade\ability_plasma_grenade.equipment'),
	spike_grenade 			= TAG('objects\armor\attachments\attachment_abilities\ability_spike_grenade\ability_spike_grenade.equipment'),
							  
	camo					= TAG('objects\equipment\unsc\active_camo\active_camo.equipment'),
	overshield				= TAG('objects\equipment\unsc\overshield\overshield.equipment'),
};

global FrameAttachmentTags:table = {
	evade 					= TAG('objects\armor\attachments\attachment_abilities\ability_evade\ability_evade.frameattachmentdefinition'),
	grapple_hook 			= TAG('objects\armor\attachments\attachment_abilities\ability_grapple_hook\ability_grapple_hook.frameattachmentdefinition'),
	knockback	 			= TAG('objects\armor\attachments\ability_knockback.frameattachmentdefinition'),
	loc_sensor				= TAG('objects\armor\attachments\attachment_abilities\ability_location_sensor_drone\ability_location_sensor_sticky.frameattachmentdefinition'),
	wall					= TAG('objects\armor\attachments\attachment_abilities\spartan_equipment\deployable_wall\deployable_wall.frameattachmentdefinition'),

	frag_grenade 			= TAG('objects\armor\attachments\ability_frag_grenade.frameattachmentdefinition'),
	lightning_grenade 		= TAG('objects\armor\attachments\ability_lightning_grenade.frameattachmentdefinition'),
	plasma_grenade 			= TAG('objects\armor\attachments\ability_plasma_grenade.frameattachmentdefinition'),
	spike_grenade 			= TAG('objects\armor\attachments\ability_spike_grenade.frameattachmentdefinition'),
	
	camo					= TAG('objects\equipment\unsc\active_camo\active_camo.frameattachmentdefinition'),
	overshield				= TAG('objects\equipment\unsc\overshield\overshield.frameattachmentdefinition'),
};

global MPFlightingProhibitedEquipment = {
	MP_EQUIPMENT_IDENTIFIER.Evade,
	MP_EQUIPMENT_IDENTIFIER.Knockback,
	MP_EQUIPMENT_IDENTIFIER.DynamoGrenade,
};

global MPEquipmentItemFallbacks = {
	[MP_EQUIPMENT_IDENTIFIER.Evade] = MP_EQUIPMENT_IDENTIFIER.Wall,
	[MP_EQUIPMENT_IDENTIFIER.Grapple] = MP_EQUIPMENT_IDENTIFIER.Knockback,
	[MP_EQUIPMENT_IDENTIFIER.Knockback] = MP_EQUIPMENT_IDENTIFIER.Wall,
	[MP_EQUIPMENT_IDENTIFIER.LocSensor] = MP_EQUIPMENT_IDENTIFIER.Evade,
	[MP_EQUIPMENT_IDENTIFIER.Wall] = MP_EQUIPMENT_IDENTIFIER.Evade,
	[MP_EQUIPMENT_IDENTIFIER.Camo] = MP_EQUIPMENT_IDENTIFIER.OverShield,
	[MP_EQUIPMENT_IDENTIFIER.OverShield] = MP_EQUIPMENT_IDENTIFIER.Camo,
	[MP_EQUIPMENT_IDENTIFIER.FragGrenade] = MP_EQUIPMENT_IDENTIFIER.PlasmaGrenade,
	[MP_EQUIPMENT_IDENTIFIER.DynamoGrenade] = MP_EQUIPMENT_IDENTIFIER.SpikeGrenade,
	[MP_EQUIPMENT_IDENTIFIER.PlasmaGrenade] = MP_EQUIPMENT_IDENTIFIER.SpikeGrenade,
	[MP_EQUIPMENT_IDENTIFIER.SpikeGrenade] = MP_EQUIPMENT_IDENTIFIER.PlasmaGrenade,
};

global MPVehicleTags:table = {
	mongoose				= TAG('objects\vehicles\human\mongoose\mongoose.vehicle'),
	ghost					= TAG('objects\vehicles\covenant\ghost\ghost.vehicle'),
	chopper					= TAG('objects\vehicles\covenant\brute_chopper\brute_chopper.vehicle'),
	warthog					= TAG('objects\vehicles\human\warthog\warthog.vehicle'),
	wraith					= TAG('objects\vehicles\covenant\wraith\wraith.vehicle'),
	scorpion				= TAG('objects\vehicles\human\scorpion\scorpion.vehicle'),
	wasp					= TAG('objects\vehicles\human\wasp\wasp.vehicle'),
	banshee					= TAG('objects\vehicles\covenant\banshee\banshee.vehicle'),
}

global MPVehicleConfigs:table = {
	mongoose				= TAG('objects\vehicles\human\mongoose\configurations\default_goose.vehicleconfiguration'),
	gungoose				= TAG('objects\vehicles\human\mongoose\configurations\gun_goose.vehicleconfiguration'),
	ghost					= TAG('objects\vehicles\covenant\ghost\configurations\banished_ghost.vehicleconfiguration'),
	chopper					= TAG('objects\vehicles\covenant\brute_chopper\configurations\default_chopper.vehicleconfiguration'),
	razorback				= TAG('objects\vehicles\human\warthog\configurations\unarmed_warthog.vehicleconfiguration'),
	rockethog				= TAG('objects\vehicles\human\warthog\configurations\rocket_warthog.vehicleconfiguration'),
	warthog					= TAG('objects\vehicles\human\warthog\configurations\default_warthog.vehicleconfiguration'),
	wraith					= TAG('objects\vehicles\covenant\wraith\configurations\banished_wraith.VehicleConfiguration'),
	scorpion				= TAG('objects\vehicles\human\scorpion\configurations\default_scorpion.vehicleconfiguration'),
	wasp					= TAG('objects\vehicles\human\wasp\configurations\default_wasp.vehicleconfiguration'),
	banshee					= TAG('objects\vehicles\covenant\banshee\configurations\banished_banshee.vehicleconfiguration'),
}

global MPVehicleVariantTags:table = {
	chopper_boss			= TAG('objects\vehicles\covenant\brute_chopper\configurations\boss_01_chopper.vehicleconfiguration'),
}

global MPFlightingProhibitedVehicles = {
};

global MPVehicleClassFallbacks = {
	[MP_VEHICLE_CLASS.Support] = MP_VEHICLE_CLASS.Cavalry,
	[MP_VEHICLE_CLASS.Duelist] = MP_VEHICLE_CLASS.Cavalry,
	[MP_VEHICLE_CLASS.Cavalry] = MP_VEHICLE_CLASS.Duelist,
	[MP_VEHICLE_CLASS.Siege] = MP_VEHICLE_CLASS.Cavalry,
};

-- For fast checks if the weapon is a horn
global MPVehicleHornTags:table = {
	[TAG('objects\vehicles\human\warthog\weapons\hog_horn.weapon')] = true,
	[TAG('objects\vehicles\human\mongoose\weapons\mongoose_horn\mongoose_horn.weapon')] = true,
}

-- Convenience table for checking for additional seats on vehicles that 
-- have more than a driver seat.
global MPVehicleConfigTagToSeats = 
{
	[MPVehicleConfigs.mongoose] = {
		[1] = "mongoose_d",
		[2] = "mongoose_p"
	},
	[MPVehicleConfigs.warthog] = {
		[1] = "warthog_d",
		[2] = "warthog_p",
		[3] = "warthog_g",
	},
	[MPVehicleConfigs.rockethog] = {
		[1] = "warthog_d",
		[2] = "warthog_p",
		[3] = "warthog_g",
	},
	[MPVehicleConfigs.razorback] = {
		[1] = "warthog_d",
		[2] = "warthog_p",
		[3] = "warthog_p_lb",
		[4] = "warthog_p_rb"
	},
	[MPVehicleConfigs.wraith] = {
		[1] = "wraith_d",
		[2] = "wraith_p"
	},
	[MPVehicleConfigs.scorpion] = {
		[1] = "scorpion_d",
		[2] = "scorpion_p"
	}
}

global MPOrdnanceDropAssets:table = {
	podMoverTag				= TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpod_mover_a\unsc_wo_weaponpod_mover_a__dm.device_machine'),
	entryEffectTag			= TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpod_a\garbage\unsc_wo_weaponpod_a_garbage_a\unsc_wo_weaponpod_a_entry.effect'),
	impactEffectGenericTag	= TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpod_a\fx\unsc_wo_weaponpod_a_impact_generic.effect'),
	impactEffectSoftTag		= TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpod_a\fx\unsc_wo_weaponpod_a_impact_soft.effect'),
	impactEffectHardTag		= TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpod_a\fx\unsc_wo_weaponpod_a_impact_hard.effect'),
	impactEffectWaterTag	= TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpod_a\fx\unsc_wo_weaponpod_a_impact_water.effect'),
	beaconEffectTag			= TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpod_a\garbage\unsc_wo_weaponpod_a_garbage_a\unsc_wo_weaponpod_a_beacon.effect'),
	beaconLightEffectTag	= TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpod_a\garbage\unsc_wo_weaponpod_a_garbage_a\unsc_wo_weaponpod_a_beacon_light.effect'),
}

function GetDropPodMaterialImpactEffect(materialType:number):tag
	if (materialType == PhysicsMaterialType.Dirt or
			materialType == PhysicsMaterialType.Mud or
			materialType == PhysicsMaterialType.Sand or
			materialType == PhysicsMaterialType.Gravel or
			materialType == PhysicsMaterialType.Vegetation) then
		return MPOrdnanceDropAssets.impactEffectSoftTag;
	elseif (materialType == PhysicsMaterialType.Metal or
			materialType == PhysicsMaterialType.Rock or
			materialType == PhysicsMaterialType.Concrete) then
		return MPOrdnanceDropAssets.impactEffectHardTag;
	elseif (materialType == PhysicsMaterialType.ShallowWater or 
			materialType == PhysicsMaterialType.DeepWater) then
		return MPOrdnanceDropAssets.impactEffectWaterTag;
	end

	return MPOrdnanceDropAssets.impactEffectGenericTag;
end

global MPItemSpawnerAudioAssets:table = {
	restrictedLoop			= TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_itemspawner_state_unavailable.sound_looping'),
	incomingLoop			= TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_itemspawner_state_incoming.sound_looping'),
	weaponHologramLoop		= TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_weaponpad_hologram_loop.sound_looping'),
	equipmentHologramLoop	= TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_poweruppad_hologram_loop.sound_looping'),
	vehicleHologramLoop		= TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_vehiclepad_hologram_loop.sound_looping'),
	vehicleRestrictedLoop	= TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_vehiclepad_inactive_loop.sound_looping'),
}

global MPItemSpawnerRezInEffects:table = {
	baseItem			= TAG('fx\library_olympus\sandbox\objects\global\object_medium_spawn_master.effect'),
	powerItem			= TAG('fx\library_olympus\sandbox\objects\global\object_medium_spawn_master.effect'),	-- change this to a new tag if we can support 2 effects in the future
}

global MPPersonalAIConfigs:table = {
	avatarTag				= TAG('objects\characters\spartan_ai_helper\spartan_ai_helper.device_machine'),
	loopingEffect			= TAG('fx\library_olympus\objects\dynamic_objects\shared\spartan_ai_hologram_rays.effect'),
	oneShotSpawnEffect		= TAG('fx\library_olympus\objects\dynamic_objects\shared\spartan_ai_dissolve_in.effect'),
	oneShotDespawnEffect	= TAG('fx\library_olympus\objects\dynamic_objects\shared\spartan_ai_dissolve_out.effect'),

	avatarSoundTags = 
	{
		-- temporary... prism is new '0th' element now that cube is gone. upon green build post 5/5/21, remove this line	
		[PERSONAL_AI_AVATAR_TYPE[0]] = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_ai_cube_idle_loop.sound_looping'),

		[PERSONAL_AI_AVATAR_TYPE.Prism] = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_ai_prism_idle_loop.sound_looping'),
		[PERSONAL_AI_AVATAR_TYPE.Pyramid] = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_ai_pyramid_idle_loop.sound_looping'),
		[PERSONAL_AI_AVATAR_TYPE.Sphere] = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_ai_sphere_idle_loop.sound_looping'),
		[PERSONAL_AI_AVATAR_TYPE.Teardrop] = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_ai_teardrop_idle_loop.sound_looping'),

		-- Premium Characters
		[PERSONAL_AI_AVATAR_TYPE.Superintendent] = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_ai_superintendant_idle_loop.sound_looping'),
		[PERSONAL_AI_AVATAR_TYPE.MisterChief] = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_ai_misterchief_idle_loop.sound_looping'),
	}
}

global MPVOTest:table = {
	mp_test_dsd						= TAG('dialogue_system\mp_test.dialogue_system_data'),
	mp_announcer_dsd				= TAG('dialogue_system\mp_announcer.dialogue_system_data'),
	mp_commander_dsd				= TAG('dialogue_system\mp_commander.dialogue_system_data'),
	mp_personalai_dsd				= TAG('dialogue_system\mp_personalai.dialogue_system_data'),
	mp_test_dialogue				= TAG('sound\001_vo\ai\001_vo_ai_mptest.dialogue'),
	mp_commander_dialogue			= TAG('sound\001_vo\ai\001_vo_ai_academycommander.dialogue'),
	mp_announcer_dialogue			= TAG('sound\001_vo\ai\001_vo_ai_announcer.dialogue'),
	mp_announcerstacker_dialogue	= TAG('sound\001_vo\ai\001_vo_ai_announcerstacker.dialogue'),
	mp_mpsuitaibuttler_dialogue		= TAG('sound\001_vo\ai\001_vo_ai_mpsuitaibutler.dialogue'),
	mp_mpsuitpyramid_dialogue		= TAG('sound\001_vo\ai\001_vo_ai_mpsuitaipyramid.dialogue'),
	mp_mpsuitai3d_dialogue			= TAG('sound\001_vo\ai\001_vo_ai_mpsuitai3d.dialogue'),
	mp_mpsuitaimisterchief_dialogue	= TAG('sound\001_vo\ai\001_vo_ai_mpsuitaimisterchief.dialogue'),
	mp_mpsuitaiprism_dialogue		= TAG('sound\001_vo\ai\001_vo_ai_mpsuitaiprism.dialogue'),
	mp_mpsuitaisphere_dialogue		= TAG('sound\001_vo\ai\001_vo_ai_mpsuitaisphere.dialogue'),
	mp_mpsuitaisuper_dialogue		= TAG('sound\001_vo\ai\001_vo_ai_mpsuitaisuperintendent.dialogue'),
	mp_mpsuitaiteardrop_dialogue	= TAG('sound\001_vo\ai\001_vo_ai_mpsuitaiteardrop.dialogue'),	
}

global PersonalAIVisualToDialog = {

	-- temporary... prism is new '0th' element now that cube is gone. upon green build post 5/5/21, remove this line	
	[PERSONAL_AI_AVATAR_TYPE[0]] = MPVOTest.mp_mpsuitaibuttler_dialogue,

	--Starting Characters
	[PERSONAL_AI_AVATAR_TYPE.Prism] = MPVOTest.mp_mpsuitaibuttler_dialogue,
	[PERSONAL_AI_AVATAR_TYPE.Pyramid] = MPVOTest.mp_mpsuitpyramid_dialogue,
	[PERSONAL_AI_AVATAR_TYPE.Sphere] = MPVOTest.mp_mpsuitaisphere_dialogue,
	[PERSONAL_AI_AVATAR_TYPE.Teardrop] = MPVOTest.mp_mpsuitaiteardrop_dialogue,
	-- Premium Characters
	[PERSONAL_AI_AVATAR_TYPE.MisterChief] = MPVOTest.mp_mpsuitaimisterchief_dialogue,
	[PERSONAL_AI_AVATAR_TYPE.Superintendent] = MPVOTest.mp_mpsuitaisuper_dialogue,
}

global MPSpartanChatter:table = {
	mp_spartanchatter_dialogue 	= TAG('dialogue_system\mp_spartan_chatter.dialogue_system_data'),
	mp_spartan_characters = {
		mp_spartan_01		= TAG('sound\001_vo\ai\001_vo_ai_mpspartan01.dialogue'),
		mp_spartan_02		= TAG('sound\001_vo\ai\001_vo_ai_mpspartan02.dialogue'),
		mp_spartan_03		= TAG('sound\001_vo\ai\001_vo_ai_mpspartan03.dialogue'),
		mp_spartan_04		= TAG('sound\001_vo\ai\001_vo_ai_mpspartan04.dialogue'),
		mp_spartan_05		= TAG('sound\001_vo\ai\001_vo_ai_mpspartan05.dialogue'),
		mp_spartan_06		= TAG('sound\001_vo\ai\001_vo_ai_mpspartan06.dialogue'),
		mp_spartan_07		= TAG('sound\001_vo\ai\001_vo_ai_mpspartan07.dialogue'),
		mp_spartan_08		= TAG('sound\001_vo\ai\001_vo_ai_mpspartan08.dialogue'),
	},
}
	
global MPTeamDesignatorNameToValue:table = {
	["Defender"] = MP_TEAM_DESIGNATOR.First,
	["Attacker"] = MP_TEAM_DESIGNATOR.Second,
	["First Party"] = MP_TEAM_DESIGNATOR.First,
	["Second Party"] = MP_TEAM_DESIGNATOR.Second,
	["Third Party"] = MP_TEAM_DESIGNATOR.Third,
	["Fourth Party"] = MP_TEAM_DESIGNATOR.Fourth,
	["Fifth Party"] = MP_TEAM_DESIGNATOR.Fifth,
	["Sixth Party"] = MP_TEAM_DESIGNATOR.Sixth,
	["Seventh Party"] = MP_TEAM_DESIGNATOR.Seventh,
	["Eighth Party"] = MP_TEAM_DESIGNATOR.Eighth,
	["Neutral"] = MP_TEAM_DESIGNATOR.Neutral
};

global MPSquadNameToValue:table = {
	["None"] = -1,
	["Alpha"] = MP_SQUAD.Alpha,
	["Bravo"] = MP_SQUAD.Bravo,
	["Charlie"] = MP_SQUAD.Charlie,
	["Delta"] = MP_SQUAD.Delta,
	["Echo"] = MP_SQUAD.Echo,
	["Foxtrot"] = MP_SQUAD.Foxtrot,
	["Gamma"] = MP_SQUAD.Gamma,
	["Hotel"] = MP_SQUAD.Hotel
};

global MPTeamIntroCompositions = {
	TAG('compositions\multiplayer\global\mpi emote emote1name.composition'),
	TAG('compositions\multiplayer\global\mpi emote emote1name_camera.composition'),
	TAG('compositions\multiplayer\global\mpi emote emote1name_idle.composition'),
	TAG('compositions\multiplayer\global\mpi emote emote1name_turn.composition'),
	TAG('compositions\multiplayer\global\mpi emote emote1name_turn_var1.composition'),
	TAG('compositions\multiplayer\global\mpi emote emote1name_waiting.composition'),
};

global MPTeamOutroCompositions = {
	TAG('compositions\multiplayer\global\team_outro.composition'),
};

global MPMatchFlowPlayerAnimGraph = TAG('objects\characters\spartan_armor\spartan_armor.model_animation_graph');

global MPGlobalEffectTags:table =
{
    spawnPingDefinition = TAG('globals\globals\mpcustomping.spartantrackingpingdefinition'),
};

global MPVisorAttachmentTags:table = 
{
	visorScanDefinition = TAG('objects\armor\attachments\visor\visor_equipment_scan.equipment');
};

global MPAcademyOutlineTags:table =
{
	ghostHoloEffect =	TAG('objects\characters\spartan_armor\holo\fx\hologram_persistent_iff.effect');
	ghostOutline =		TAG('globals\outlines\default_friendly_outline.outlinetypedefinition');
	defaultHostile =	TAG('globals\outlines\default_enemy_outline.outlinetypedefinition');
};

global MPAcademyTargetSpawnTags:table =
{
	targetSpawnEffect = TAG('fx\library_olympus\sandbox\spartans\global\spartan_spawn_master.effect');
};

-- ** This function must be defined on both the client and server! Don't move it below the SERVER directive! **
-- 		We need some way to have a "Neutral" team.. let's pick Grey for now.
function GetNeutralMPTeam():mp_team
	return MP_TEAM.mp_team_grey;
end

global s_mpWeaponPlacementTable:table = nil;

function GetMPWeaponPlacementTable():table
	if (s_mpWeaponPlacementTable == nil) then
		local weaponTable:table = {};

-- //////////////////////////////
-- //////////// PISTOL //////////
-- //////////////////////////////	

		-- DISRUPTOR
		weaponTable[MP_WEAPON_IDENTIFIER.Disruptor] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.proto_arc_zapper,
				identifier = MP_WEAPON_IDENTIFIER.Disruptor,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.Pistol,
				antivehicle = true,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = 1,
				hologramIconPos = 0.15,
				navpointStringId = "arc_zapper",
				legendaryVariants = {
					MPWeaponVariantTags.disrupter_calcine,
				},
		};

		-- PLASMA PISTOL
		weaponTable[MP_WEAPON_IDENTIFIER.PlasmaPistol] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.plasma_pistol,
				identifier = MP_WEAPON_IDENTIFIER.PlasmaPistol,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.Pistol,
				antivehicle = false,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = 1,
				hologramIconPos = 0.25,
				navpointStringId = "plasma_pistol",
				legendaryVariants = {
					MPWeaponVariantTags.plasma_pistol_unbound,
				},
		};

		-- MANGLER
		weaponTable[MP_WEAPON_IDENTIFIER.Mangler] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.proto_spiker_revolver,
				identifier = MP_WEAPON_IDENTIFIER.Mangler,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.Pistol,
				antivehicle = false,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = .85,
				hologramIconPos = 0.35,
				navpointStringId = "spike_revolver",
				legendaryVariants = {
					MPWeaponVariantTags.mangler_riven,
				},
		};

		-- Mk50 SIDEKICK
		weaponTable[MP_WEAPON_IDENTIFIER.SideKick] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.sidearm_pistol,
				identifier = MP_WEAPON_IDENTIFIER.SideKick,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.Pistol,
				antivehicle = false,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = 1.2,
				hologramIconPos = 0.45,
				navpointStringId = "sidearm_pistol",
				legendaryVariants = {
					MPWeaponVariantTags.sidekick_striker,
				},
		};

-- ////////////////////////////////////
-- //////////// ASSAULT RIFLE /////////
-- ////////////////////////////////////	

		-- M40 AR
		weaponTable[MP_WEAPON_IDENTIFIER.AssaultRifle] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.assault_rifle,
				identifier = MP_WEAPON_IDENTIFIER.AssaultRifle,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.AssaultRifle,
				antivehicle = false,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = 1,
				hologramIconPos = 0.15,
				navpointStringId = "assault_rifle",
				legendaryVariants = {
					MPWeaponVariantTags.assault_rifle_longshot,
				},
		};

		-- PULSE CARBINE
		weaponTable[MP_WEAPON_IDENTIFIER.PulseCarbine] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.proto_plasma_wetwork,
				identifier = MP_WEAPON_IDENTIFIER.PulseCarbine,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.AssaultRifle,
				antivehicle = false,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = 1.05,
				hologramIconPos = 0.25,
				navpointStringId = "wetwork",
				legendaryVariants = {
					MPWeaponVariantTags.pulse_carbine_rapidfire,
				},
		};

-- /////////////////////////////////////
-- //////////// TACTICAL RIFLE /////////
-- /////////////////////////////////////	

		-- BR75
		weaponTable[MP_WEAPON_IDENTIFIER.BattleRifle] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.battle_rifle,
				identifier = MP_WEAPON_IDENTIFIER.BattleRifle,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.TacticalRifle,
				antivehicle = false,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = 1,
				hologramIconPos = 0.15,
				navpointStringId = "battle_rifle",
				legendaryVariants = {
					MPWeaponVariantTags.battle_rifle_breacher,
				},
		};

 		-- VK78 COMMANDO
		weaponTable[MP_WEAPON_IDENTIFIER.CommandoRifle] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.commando_rifle,
				identifier = MP_WEAPON_IDENTIFIER.CommandoRifle,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.TacticalRifle,
				antivehicle = false,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = .95,
				hologramIconPos = 0.25,
				navpointStringId = "commando_rifle",
				legendaryVariants = {
					MPWeaponVariantTags.commando_rifle_impact,
				},
		};

-- /////////////////////////////
-- //////////// SMG ////////////
-- /////////////////////////////	

		-- NEEDLER
		weaponTable[MP_WEAPON_IDENTIFIER.Needler] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.needler,
				identifier = MP_WEAPON_IDENTIFIER.Needler,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.SMG,
				antivehicle = false,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = .9,
				hologramIconPos = 0.15,
				navpointStringId = "needler",
				legendaryVariants = {
					MPWeaponVariantTags.needler_pinpoint,
				},
		};

		-- SENTINEL BEAM
		weaponTable[MP_WEAPON_IDENTIFIER.SentinelBeam] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.sentinel_beam,
				identifier = MP_WEAPON_IDENTIFIER.SentinelBeam,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.SMG,
				antivehicle = false,
				faction = MP_ITEM_FACTION.Forerunner,
				containerScale = 1,
				hologramIconPos = 0.25,
				navpointStringId = "sentinel_beam",
				legendaryVariants = {
					MPWeaponVariantTags.sentinel_beam_heatrod,
				},
		};

-- /////////////////////////////////
-- //////////// SHOTGUN ////////////
-- /////////////////////////////////	

		-- BULLDOG
		weaponTable[MP_WEAPON_IDENTIFIER.Bulldog] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.proto_combat_shotgun,
				identifier = MP_WEAPON_IDENTIFIER.Bulldog,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.Shotgun,
				antivehicle = false,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = 1,
				hologramIconPos = 0.15,
				navpointStringId = "combat_shotgun",
				legendaryVariants = {
					MPWeaponVariantTags.bulldog_convergence,
				},
		};

		-- HEATWAVE
		weaponTable[MP_WEAPON_IDENTIFIER.Heatwave] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.hotrod,
				identifier = MP_WEAPON_IDENTIFIER.Heatwave,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.Shotgun,
				antivehicle = false,
				faction = MP_ITEM_FACTION.Forerunner,
				containerScale = 1,
				hologramIconPos = 0.25,
				navpointStringId = "hotrod",
				legendaryVariants = {
					MPWeaponVariantTags.heatwave_scatterbound,
				},
		};

-- /////////////////////////////////////
-- //////////// SNIPER RIFLE ///////////
-- /////////////////////////////////////	

		-- S7 SNIPER
		weaponTable[MP_WEAPON_IDENTIFIER.SniperRifle] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.sniper_rifle,
				identifier = MP_WEAPON_IDENTIFIER.SniperRifle,
				tier = MP_WEAPON_TIER.Power,
				class = MP_WEAPON_CLASS.SniperRifle,
				antivehicle = false,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = 1,
				hologramIconPos = 0.15,
				navpointStringId = "sniper_rifle",
				legendaryVariants = {
					MPWeaponVariantTags.sniper_rifle_flexfire,
				},
		};

		-- SHOCK RIFLE
		weaponTable[MP_WEAPON_IDENTIFIER.ShockRifle] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.proto_volt_action,
				identifier = MP_WEAPON_IDENTIFIER.ShockRifle,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.SniperRifle,
				antivehicle = true,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = 0.75,
				hologramIconPos = 0.25,
				navpointStringId = "volt_action",
				legendaryVariants = {
					MPWeaponVariantTags.shock_rifle_purging,
				},
		};

		-- SKEWER
		weaponTable[MP_WEAPON_IDENTIFIER.Skewer] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.skewer,
				identifier = MP_WEAPON_IDENTIFIER.Skewer,
				tier = MP_WEAPON_TIER.Power,
				class = MP_WEAPON_CLASS.SniperRifle,
				antivehicle = true,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = 1,
				hologramIconPos = 0.35,
				navpointStringId = "skewer",
				legendaryVariants = {
					MPWeaponVariantTags.skewer_volatile,
				},
		};

		-- STALKER RIFLE
		weaponTable[MP_WEAPON_IDENTIFIER.StalkerRifle] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.plasma_blaster,
				identifier = MP_WEAPON_IDENTIFIER.StalkerRifle,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.SniperRifle,
				antivehicle = false,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = 0.83,
				hologramIconPos = 0.45,
				navpointStringId = "plasma_blaster",
				legendaryVariants = {
					MPWeaponVariantTags.stalker_rifle_ultra,
				},
		};

-- //////////////////////////////////
-- //////////// LAUNCHER ////////////
-- //////////////////////////////////	

		-- HYDRA
		weaponTable[MP_WEAPON_IDENTIFIER.Hydra] = hmake MPWeaponTableEntry
		{
				tag =WeaponTags.hydra,
				identifier = MP_WEAPON_IDENTIFIER.Hydra,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.Launcher,
				antivehicle = true,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = 1,
				hologramIconPos = 0.15,
				navpointStringId = "mlrs",
				legendaryVariants = {
					MPWeaponVariantTags.hydra_pursuit,
				},
		};

		-- RAVAGER
		weaponTable[MP_WEAPON_IDENTIFIER.Ravager] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.provoker,
				identifier = MP_WEAPON_IDENTIFIER.Ravager,
				tier = MP_WEAPON_TIER.Base,
				class = MP_WEAPON_CLASS.Launcher,
				antivehicle = false,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = .95,
				hologramIconPos = 0.25,
				navpointStringId = "slag_maker",
				legendaryVariants = {
					MPWeaponVariantTags.ravager_rebound,
				},
		};

		-- CINDERSHOT
		weaponTable[MP_WEAPON_IDENTIFIER.Cindershot] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.proto_heatwave,
				identifier = MP_WEAPON_IDENTIFIER.Cindershot,
				tier = MP_WEAPON_TIER.Power,
				class = MP_WEAPON_CLASS.Launcher,
				antivehicle = false,
				faction = MP_ITEM_FACTION.Forerunner,
				containerScale = 1,
				hologramIconPos = 0.35,
				navpointStringId = "heatwave",
				legendaryVariants = {
					MPWeaponVariantTags.cindershot_backdraft,
				},
		};

		-- M41 SPNKr
		weaponTable[MP_WEAPON_IDENTIFIER.RocketLauncher] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.rocket_launcher,
				identifier = MP_WEAPON_IDENTIFIER.RocketLauncher,
				tier = MP_WEAPON_TIER.Power,
				class = MP_WEAPON_CLASS.Launcher,
				antivehicle = true,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = 1,
				hologramIconPos = 0.45,
				navpointStringId = "spnkr_rocket_launcher",
				legendaryVariants = {
					MPWeaponVariantTags.rocket_launcher_tracker,
				},
		};
	
-- ////////////////////////////
-- ////////// MELEE ///////////
-- ////////////////////////////	

		-- ENERGY SWORD
		weaponTable[MP_WEAPON_IDENTIFIER.EnergySword] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.energy_sword,
				identifier = MP_WEAPON_IDENTIFIER.EnergySword,
				tier = MP_WEAPON_TIER.Power,
				class = MP_WEAPON_CLASS.Melee,
				antivehicle = false,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = 1,
				hologramIconPos = 0.15,
				navpointStringId = "energy_sword",
				legendaryVariants = {
					MPWeaponVariantTags.energy_sword_duelist,
				},
		};

		-- GRAVITY HAMMER
		weaponTable[MP_WEAPON_IDENTIFIER.GravityHammer] = hmake MPWeaponTableEntry
		{
				tag = WeaponTags.gravity_hammer,
				identifier = MP_WEAPON_IDENTIFIER.GravityHammer,
				tier = MP_WEAPON_TIER.Power,
				class = MP_WEAPON_CLASS.Melee,
				antivehicle = false,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = 0.9,
				--navpointOffset = 0.5,
				hologramIconPos = 0.25,
				navpointStringId = "gravity_hammer",
				legendaryVariants = {
					MPWeaponVariantTags.gravity_hammer_rushdown,
				},
		};

		s_mpWeaponPlacementTable = weaponTable;
	end

	return s_mpWeaponPlacementTable;
end

global s_mpGrenadePlacementTable:table = nil;
global s_mpEquipmentPlacementTable:table = nil;

function GetMPEquipmentPlacementTable(equipmentType:mp_equipment_class):table
-- //////////////////////////////
-- ///////// GRENADES ///////////
-- //////////////////////////////

	if (equipmentType == MP_EQUIPMENT_CLASS.Grenade) then

		if (s_mpGrenadePlacementTable == nil) then
			local grenadeTable:table = {};

			grenadeTable[MP_EQUIPMENT_IDENTIFIER.FragGrenade] = hmake MPEquipmentTableEntry
			{
				tag = EquipmentTags.frag_grenade,
				navpointStringId = "frag_grenade",
				identifier = MP_EQUIPMENT_IDENTIFIER.FragGrenade,
				class = MP_EQUIPMENT_CLASS.Grenade,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = 1,
				attachmentTag = MPEquipmentAttachmentNames.frag_grenade,
				frameAttachmentTag = FrameAttachmentTags.frag_grenade,
				legendaryVariants = nil,			-- unsupported
				legendaryVariantAttachments = nil,	-- unsupported
			};
		
			grenadeTable[MP_EQUIPMENT_IDENTIFIER.DynamoGrenade] = hmake MPEquipmentTableEntry
			{
				tag = EquipmentTags.lightning_grenade,
				navpointStringId = "lightning_grenade",
				identifier = MP_EQUIPMENT_IDENTIFIER.DynamoGrenade,
				class = MP_EQUIPMENT_CLASS.Grenade,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = 1,
				attachmentTag = MPEquipmentAttachmentNames.lightning_grenade,
				frameAttachmentTag = FrameAttachmentTags.lightning_grenade,
				legendaryVariants = nil,			-- unsupported
				legendaryVariantAttachments = nil,	-- unsupported
			};

			grenadeTable[MP_EQUIPMENT_IDENTIFIER.PlasmaGrenade] = hmake MPEquipmentTableEntry
			{
				tag = EquipmentTags.plasma_grenade,
				navpointStringId = "plasma_grenade",
				identifier = MP_EQUIPMENT_IDENTIFIER.PlasmaGrenade,
				class = MP_EQUIPMENT_CLASS.Grenade,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = 1,
				attachmentTag = MPEquipmentAttachmentNames.plasma_grenade,
				frameAttachmentTag = FrameAttachmentTags.plasma_grenade,
				legendaryVariants = nil,			-- unsupported
				legendaryVariantAttachments = nil,	-- unsupported
			};

			grenadeTable[MP_EQUIPMENT_IDENTIFIER.SpikeGrenade] = hmake MPEquipmentTableEntry
			{
				tag = EquipmentTags.spike_grenade,
				navpointStringId = "spike_grenade",
				identifier = MP_EQUIPMENT_IDENTIFIER.SpikeGrenade,
				class = MP_EQUIPMENT_CLASS.Grenade,
				faction = MP_ITEM_FACTION.Banished,
				containerScale = .8,
				attachmentTag = MPEquipmentAttachmentNames.spike_grenade,
				frameAttachmentTag = FrameAttachmentTags.spike_grenade,
				legendaryVariants = nil,			-- unsupported
				legendaryVariantAttachments = nil,	-- unsupported
			};

			s_mpGrenadePlacementTable = grenadeTable;
		end

		return s_mpGrenadePlacementTable;

-- //////////////////////////////
-- ///////// EQUIPMENT //////////
-- //////////////////////////////

	else
		if (s_mpEquipmentPlacementTable == nil) then
			local equipmentTable:table = {};

			equipmentTable[MP_EQUIPMENT_IDENTIFIER.Evade] = hmake MPEquipmentTableEntry
			{
				tag = EquipmentTags.evade,
				navpointStringId = "evade",
				identifier = MP_EQUIPMENT_IDENTIFIER.Evade,
				class = MP_EQUIPMENT_CLASS.Equipment,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = 1.5,
				attachmentTag = MPEquipmentAttachmentNames.evade,
				frameAttachmentTag = FrameAttachmentTags.evade,
				legendaryVariants = {
					MPEquipVariantTags.cloaked_thruster,
				},
				legendaryVariantAttachments = {
					MPEquipVariantAttachmentTags.cloaked_thruster,
				},
			};

			equipmentTable[MP_EQUIPMENT_IDENTIFIER.Grapple] = hmake MPEquipmentTableEntry
			{
				tag = EquipmentTags.grapple,
				navpointStringId = "grapple",
				identifier = MP_EQUIPMENT_IDENTIFIER.Grapple,
				class = MP_EQUIPMENT_CLASS.Equipment,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = 2,
				attachmentTag = MPEquipmentAttachmentNames.grapple,
				frameAttachmentTag = FrameAttachmentTags.grapple_hook,
				legendaryVariants = {
					MPEquipVariantTags.grapple_strike,
				},
				legendaryVariantAttachments = {
					MPEquipVariantAttachmentTags.grapple_strike,
				},
			};

			equipmentTable[MP_EQUIPMENT_IDENTIFIER.Knockback] = hmake MPEquipmentTableEntry
			{
				tag = EquipmentTags.knockback,
				navpointStringId = "knockback",
				identifier = MP_EQUIPMENT_IDENTIFIER.Knockback,
				class = MP_EQUIPMENT_CLASS.Equipment,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = 1.3,
				attachmentTag = MPEquipmentAttachmentNames.knockback,
				frameAttachmentTag = FrameAttachmentTags.knockback,
				legendaryVariants = {},
				legendaryVariantAttachments = {},
			};

			equipmentTable[MP_EQUIPMENT_IDENTIFIER.LocSensor] = hmake MPEquipmentTableEntry
			{
				tag = EquipmentTags.loc_sensor,
				navpointStringId = "loc_sensor",
				identifier = MP_EQUIPMENT_IDENTIFIER.LocSensor,
				class = MP_EQUIPMENT_CLASS.Equipment,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = 1.4,
				attachmentTag = MPEquipmentAttachmentNames.loc_sensor,
				frameAttachmentTag = FrameAttachmentTags.loc_sensor,
				legendaryVariants = {
					MPEquipVariantTags.long_range_threat_sensor,
				},
				legendaryVariantAttachments = {
					MPEquipVariantAttachmentTags.long_range_threat_sensor,
				},
			};

			equipmentTable[MP_EQUIPMENT_IDENTIFIER.Wall] = hmake MPEquipmentTableEntry
			{
				tag = EquipmentTags.wall,
				navpointStringId = "wall",
				identifier = MP_EQUIPMENT_IDENTIFIER.Wall,
				class = MP_EQUIPMENT_CLASS.Equipment,
				faction = MP_ITEM_FACTION.UNSC,
				containerScale = .8,
				attachmentTag = MPEquipmentAttachmentNames.wall,
				frameAttachmentTag = FrameAttachmentTags.wall,
				legendaryVariants = {
					MPEquipVariantTags.shockwall,
				},
				legendaryVariantAttachments = {
					MPEquipVariantAttachmentTags.shockwall,
				},
			};

-- //////////////////////////////
-- ////////// POWER UP //////////
-- //////////////////////////////

			equipmentTable[MP_EQUIPMENT_IDENTIFIER.Camo] = hmake MPEquipmentTableEntry
			{
				tag = EquipmentTags.camo,
				navpointStringId = "active_camo",
				identifier = MP_EQUIPMENT_IDENTIFIER.Camo,
				class = MP_EQUIPMENT_CLASS.PowerUp,
				faction = MP_ITEM_FACTION.UNSC,
				attachmentTag = MPEquipmentAttachmentNames.camo,
				containerScale = 1.75,
				legendaryVariants = {},
				legendaryVariantAttachments = {},
			};

			equipmentTable[MP_EQUIPMENT_IDENTIFIER.OverShield] = hmake MPEquipmentTableEntry
			{
				tag = EquipmentTags.overshield,
				navpointStringId = "overshield",
				identifier = MP_EQUIPMENT_IDENTIFIER.OverShield,
				class = MP_EQUIPMENT_CLASS.PowerUp,
				faction = MP_ITEM_FACTION.UNSC,
				attachmentTag = MPEquipmentAttachmentNames.overshield,
				containerScale = 1.75,
				legendaryVariants = {},
				legendaryVariantAttachments = {},
			};

			s_mpEquipmentPlacementTable = equipmentTable;
		end

		return s_mpEquipmentPlacementTable;
	end
end

global s_mpVehiclePlacementTable:table = nil;

function GetMPVehiclePlacementTable():table
	if (s_mpVehiclePlacementTable == nil) then
		local vehicleTable:table = {};

		vehicleTable[MP_VEHICLE_IDENTIFIER.Mongoose] = hmake MPVehicleTableEntry
		{
				tag = MPVehicleTags.mongoose,
				config = MPVehicleConfigs.mongoose,
				identifier = MP_VEHICLE_IDENTIFIER.Mongoose,
				class = MP_VEHICLE_CLASS.Support,
				terrain = MP_VEHICLE_TERRAIN_TYPE.Land,
				faction = MP_ITEM_FACTION.UNSC,
				clearance = 1.25,
				hologramScale = 0.5,
				verticalOffset = 0.1,
				navpointStringId = "mongoose",
				legendaryVariants = {},
		};

		vehicleTable[MP_VEHICLE_IDENTIFIER.Razorback] = hmake MPVehicleTableEntry
		{
				tag = MPVehicleTags.warthog,
				config = MPVehicleConfigs.razorback,
				identifier = MP_VEHICLE_IDENTIFIER.Razorback,
				class = MP_VEHICLE_CLASS.Support,
				terrain = MP_VEHICLE_TERRAIN_TYPE.Land,
				faction = MP_ITEM_FACTION.UNSC,
				clearance = 2,
				hologramScale = 0.5,
				navpointStringId = "razorbackhog",
				legendaryVariants = {},
		};

		vehicleTable[MP_VEHICLE_IDENTIFIER.Gungoose] = hmake MPVehicleTableEntry
		{
				tag = MPVehicleTags.mongoose,
				config = MPVehicleConfigs.gungoose,
				identifier = MP_VEHICLE_IDENTIFIER.Gungoose,
				class = MP_VEHICLE_CLASS.Duelist,
				terrain = MP_VEHICLE_TERRAIN_TYPE.Land,
				faction = MP_ITEM_FACTION.UNSC,
				clearance = 1.25,
				hologramScale = 0.5,
				verticalOffset = 0.1,
				navpointStringId = "gungoose",
				legendaryVariants = {},
		};

		vehicleTable[MP_VEHICLE_IDENTIFIER.Ghost] = hmake MPVehicleTableEntry
		{
				tag = MPVehicleTags.ghost,
				config = MPVehicleConfigs.ghost,
				identifier = MP_VEHICLE_IDENTIFIER.Ghost,
				class = MP_VEHICLE_CLASS.Duelist,
				terrain = MP_VEHICLE_TERRAIN_TYPE.Land,
				faction = MP_ITEM_FACTION.Banished,
				clearance = 2,
				hologramScale = 0.5,
				verticalOffset = 0.1,
				navpointStringId = "ghost",
				legendaryVariants = {},
		};

		vehicleTable[MP_VEHICLE_IDENTIFIER.Chopper] = hmake MPVehicleTableEntry
		{
				tag = MPVehicleTags.chopper,
				config = MPVehicleConfigs.chopper,
				identifier = MP_VEHICLE_IDENTIFIER.Chopper,
				class = MP_VEHICLE_CLASS.Duelist,
				terrain = MP_VEHICLE_TERRAIN_TYPE.Land,
				faction = MP_ITEM_FACTION.Banished,
				clearance = 2.5,
				hologramScale = 0.5,
				verticalOffset = 0.2,
				navpointStringId = "chopper",
				legendaryVariants = {
					MPVehicleVariantTags.chopper_boss,
				},
		};


		vehicleTable[MP_VEHICLE_IDENTIFIER.Wasp] = hmake MPVehicleTableEntry
		{
				tag = MPVehicleTags.wasp,
				config = MPVehicleConfigs.wasp,
				identifier = MP_VEHICLE_IDENTIFIER.Wasp,
				class = MP_VEHICLE_CLASS.Duelist,
				terrain = MP_VEHICLE_TERRAIN_TYPE.Air,
				faction = MP_ITEM_FACTION.UNSC,
				clearance = 2,
				hologramScale = 0.5,
				verticalOffset = -0.1,
				navpointStringId = "wasp",
				legendaryVariants = {},
		};

		vehicleTable[MP_VEHICLE_IDENTIFIER.Banshee] = hmake MPVehicleTableEntry
		{
				tag = MPVehicleTags.banshee,
				config = MPVehicleConfigs.banshee,
				identifier = MP_VEHICLE_IDENTIFIER.Banshee,
				class = MP_VEHICLE_CLASS.Duelist,
				terrain = MP_VEHICLE_TERRAIN_TYPE.Air,
				faction = MP_ITEM_FACTION.Banished,
				clearance = 3,
				hologramScale = 0.5,
				navpointStringId = "banshee",
				legendaryVariants = {},
		};

		vehicleTable[MP_VEHICLE_IDENTIFIER.Warthog] = hmake MPVehicleTableEntry
		{
				tag = MPVehicleTags.warthog,
				config = MPVehicleConfigs.warthog,
				identifier = MP_VEHICLE_IDENTIFIER.Warthog,
				class = MP_VEHICLE_CLASS.Cavalry,
				terrain = MP_VEHICLE_TERRAIN_TYPE.Land,
				faction = MP_ITEM_FACTION.UNSC,
				clearance = 2,
				hologramScale = 0.5,
				navpointStringId = "warthog",
				legendaryVariants = {},
		};

		vehicleTable[MP_VEHICLE_IDENTIFIER.Rockethog] = hmake MPVehicleTableEntry
		{
				tag = MPVehicleTags.warthog,
				config = MPVehicleConfigs.rockethog,
				identifier = MP_VEHICLE_IDENTIFIER.Rockethog,
				class = MP_VEHICLE_CLASS.Cavalry,
				terrain = MP_VEHICLE_TERRAIN_TYPE.Land,
				faction = MP_ITEM_FACTION.UNSC,
				clearance = 2,
				hologramScale = 0.5,
				navpointStringId = "rockethog",
				legendaryVariants = {},
		};

		vehicleTable[MP_VEHICLE_IDENTIFIER.Wraith] = hmake MPVehicleTableEntry
		{
				tag = MPVehicleTags.wraith,
				config = MPVehicleConfigs.wraith,
				identifier = MP_VEHICLE_IDENTIFIER.Wraith,
				class = MP_VEHICLE_CLASS.Siege,
				terrain = MP_VEHICLE_TERRAIN_TYPE.Land,
				faction = MP_ITEM_FACTION.Banished,
				clearance = 3.5,
				hologramScale = 0.4,
				verticalOffset = 0.2,
				navpointStringId = "wraith",
				legendaryVariants = {},
		};

		vehicleTable[MP_VEHICLE_IDENTIFIER.Scorpion] = hmake MPVehicleTableEntry
		{
				tag = MPVehicleTags.scorpion,
				config = MPVehicleConfigs.scorpion,
				identifier = MP_VEHICLE_IDENTIFIER.Scorpion,
				class = MP_VEHICLE_CLASS.Siege,
				terrain = MP_VEHICLE_TERRAIN_TYPE.Land,
				faction = MP_ITEM_FACTION.UNSC,
				clearance = 5,
				hologramScale = 0.4,
				verticalOffset = 0.2,
				navpointStringId = "scorpion",
				legendaryVariants = {},
		};

		s_mpVehiclePlacementTable = vehicleTable;
	end

	return s_mpVehiclePlacementTable;
end

--## SERVER

-------------------------------------------------
------------ GLOBAL CONFIG FLAGS ----------------
-------------------------------------------------

global RegisterCallbackAssertsDisabled = true;
global ShouldApplyOutlinesInAcademy = false;

------------------------------------------------------
------------ MODE FRAMEWORK INIT ARGS ----------------
------------------------------------------------------

function GetZonesetSwitchingEnabledForMap():boolean
	-- Return false unless a map specifically opts into zone set switching
	local getZonesetSwitchingEnabledMapOverrideFunction = _G["GetZonesetSwitchingEnabledMapOverride"];
	if (getZonesetSwitchingEnabledMapOverrideFunction ~= nil) then
		return getZonesetSwitchingEnabledMapOverrideFunction();
	end

	return false;
end

function CreateEmptyMapZoneOverrideTable():table
	local overrides = {};
	for i = 0, #MAP_ZONE - 1 do
		overrides[MAP_ZONE[i]] = {};
	end
	
	return overrides;
end

global MPInitHelpers:table = {};

function MPInitHelpers:AddModeFrameworkData(modeFramework:table, defaults:table, overrideFunctionName:string):void
	-- Get overrides for this version of mode framework if specified by the level
	local overrides = nil;
	if(_G[overrideFunctionName] ~= nil) then
		overrides = _G[overrideFunctionName]();
	end	

	-- iterate over the defaults and overrides, merging them were necessary,
	-- then call AddFrameworkData on the merged results

	-- nil in the override table means "use the default"
	-- NONE in the override table means "ignore the default and don't override it with anything"	
		-- i.e., NONE in the overrides table will suppress a value in the default table
	
	for i = 0, #MAP_ZONE - 1 do
		for j = 0, #MAP_ZONE_CONFIGURATION - 1 do
			local mapZone:map_zone = MAP_ZONE[i];
			local mapZoneConfig:map_zone_configuration = MAP_ZONE_CONFIGURATION[j];
			
			local startupData = nil;
			-- If no overrides were defined at all, just use the defaults
			if (overrides == nil) then
				startupData = defaults[mapZone][mapZoneConfig];
			-- Otherwise parse the overrides and use those, filling in nil entries with values from the default tables
			else
				if (overrides[mapZone][mapZoneConfig] == NONE) then
					-- do nothing, NONE means we want nothing defined for this mapZone and mapZoneConfig
				else
					-- Otherwise use what's given in the overrides, or fall back to the defaults
					startupData = overrides[mapZone][mapZoneConfig] or defaults[mapZone][mapZoneConfig];
				end
			end
			
			if (startupData ~= nil) then
				startupData = self:GetObjAsTable(startupData);
				for _, item in hpairs(startupData) do
					modeFramework:AddFrameworkData(mapZone, mapZoneConfig, item);
				end
			end
		end
	end
end

function MPInitHelpers:GetObjAsTable(obj):table
	if (type(obj) == "table") then
		return obj;
	end
	
	return { obj };
end

-- returns a copy of the src, as the same type that was passed in (only structs or tables allowed as parent src)
function MPInitHelpers:DeepCopyNoMetatable(src)
	return table.simpleDeepCopyWithHstructs(src);
end

-- Returns a copy of the given argument structure, with all instances of the passed in hstruct types having the ".owningTeam" value flipped (Red/Blue-wise)
-- 		hstructTypes:  table of strings representing the names of hstructures for which team flipping is desired
function MPInitHelpers:FlipArgsOwningTeamsImpl(src, hstructTypes:table):void
	local function GetReversedMPTeam(team:mp_team):mp_team
		if (team == MP_TEAM.mp_team_red) then
			return MP_TEAM.mp_team_blue;
		elseif (team == MP_TEAM.mp_team_blue) then
			return MP_TEAM.mp_team_red;
		end

		return team;
	end

	--
	-- Walk every element, recursing on tables or hstructs, and any time we encounter CTFFlagStand args, flip the teams on them
	--

	-- If we've encountered a primitive, return and walk back up the stack, no need to touch those
	if (type(src) ~= "struct" and type(src) ~= "table") then
		return;
	end

	-- If we found one of the specified struct types, flip the teams now
	if (type(src) == "struct" and table.contains(hstructTypes, struct.name(src))) then
		if (src.owningTeam ~= nil) then
			src.owningTeam = GetReversedMPTeam(src.owningTeam);
		end
		return;
	-- Otherwise keep recursing down over all of the keys of this struct/table
	else
		for key, value in hpairs(src) do
			self:FlipArgsOwningTeamsImpl(value, hstructTypes);
		end
	end

end

-- Helper for flipping the owning teams (red -> blue, blue -> red) on CTFFlagStand args inside of CTFInitArgs (or a containing struct of CTFInitArgs)
function MPInitHelpers:FlagArgTeamFlipper(src)
	local returnVal = self:DeepCopyNoMetatable(src);
	self:FlipArgsOwningTeamsImpl(returnVal, { "CTFFlagStand" });

	return returnVal;
end

-- Helper for flipping the owning teams (red -> blue, blue -> red) on BombSpawnArgs and ArmzoneArgs args inside of AssaultInitArgs (or a containing struct of AssaultInitArgs)
function MPInitHelpers:AssaultArgTeamFlipper(src)
	local returnVal = self:DeepCopyNoMetatable(src);
	self:FlipArgsOwningTeamsImpl(returnVal, { "BombSpawnArgs", "ArmzoneArgs", "BombRespawnPointArgs" });

	return returnVal;
end

-- Helper for flipping the owning teams (red -> blue, blue -> red) on StrongholdAreaArgs args inside of StrongholdsInitArgs (or a containing struct of StrongholdsInitArgs)
function MPInitHelpers:StrongholdArgTeamFlipper(src)
	local returnVal = self:DeepCopyNoMetatable(src);
	self:FlipArgsOwningTeamsImpl(returnVal, { "StrongholdAreaArgs" });

	return returnVal;
end

-- Accepts an arbitrarily ordered array of BastionAreaArgs or StrongholdAreaArgs, and returns a new table with the elements ordered by groupIndex (optionally with random ordering within a group)
function MPInitHelpers:GenerateNewOrderedStrongholdArray(areaInitArgs:table, shuffleSubGroups:boolean):table
	local acceptedInputHstructTypes:table = { "BastionAreaArgs", "StrongholdAreaArgs", "LandGrabAreaArgs"};
	local outputArgsArray:table = table.simpleCopy(areaInitArgs);

	if (not shuffleSubGroups) then
		-- table.sort is not a stable sort, so we will need to keep track of the initial indices for each hstruct as a tie-break sort to enforce sort-stability
		-- note that this sorting approach requires all unique elements, but we are guaranteed that in this case since hstruct instances are inherently unique
		local initialIndices:table = {};
		for idx, args in ipairs(outputArgsArray) do
			initialIndices[args] = idx;
		end

		-- Sort the area args by group index, tie-breaking by initial index ordering
		table.sort(outputArgsArray,
			function (a, b)
				if (a.groupIndex < b.groupIndex) then
					return true;
				elseif (a.groupIndex == b.groupIndex) then
					return initialIndices[a] < initialIndices[b];
				else
					return false;
				end
			end);
	else
		-- Since sub-group shuffling is desired, we don't care about sort stability; simply sort the area args by group index
		table.sort(outputArgsArray,
			function (a, b)
				return a.groupIndex < b.groupIndex;
			end);

		-- Now, explicitly shuffle all of the group subranges
		-- 		Note: we only need to scan to the N-1th elem because if the last elem is in its own new group, we can just leave it be and we are done.
		-- 		Note: we can't use a pairs iterator because we're modifying the array as we iterate it
		local areaCount:number = #outputArgsArray;
		local prevGroupIndex:number = nil;

		for idx = 1, areaCount - 1 do
			local areaArgs = outputArgsArray[idx];
			assert(type(areaArgs) == "struct" and table.contains(acceptedInputHstructTypes, struct.name(areaArgs)), "An invalid type was encountered for an entry of areaInitArgs!");

			-- If this is the beginning of a new group, discover its range and shuffle that subrange; otherwise we'll keep scanning until we hit an unhandled group
			if (prevGroupIndex == nil or areaArgs.groupIndex > prevGroupIndex) then
				local firstSubIdx:number = idx;
				local lastSubIdx:number = idx;

				for subIdx = firstSubIdx + 1, areaCount do
					if (outputArgsArray[subIdx].groupIndex == areaArgs.groupIndex) then
						lastSubIdx = subIdx;
					else
						break;
					end
				end

				table.shuffleRange(outputArgsArray, firstSubIdx, lastSubIdx);
				prevGroupIndex = areaArgs.groupIndex;
			end
		end
	end

	return outputArgsArray;
end

-- Given an inputted area capture object name (as a string!), e.g. "threehold_red", this will return the table
--   { OBJECT_NAMES["threehold_red_spawn"], OBJECT_NAMES["threehold_red_spawn_01"], ...,  OBJECT_NAMES["threehold_red_spawn_04"] }
--
-- This is useful because...
-- 1) no need to type that list every time, 
-- 2) if none of those objects exist in content, there is automatic fallback behavior
-- 3) Because it's behind a function, it's more efficient since otherwise OBJECT_NAMES has to resolve immediately to get written to the table

function MPInitHelpers:AutoGenAreaCapSpawnObjectNames(areaCaptureObjectName:string):table
	return
	{
		OBJECT_NAMES[areaCaptureObjectName .. "_spawn"],
		OBJECT_NAMES[areaCaptureObjectName .. "_spawn_01"],
		OBJECT_NAMES[areaCaptureObjectName .. "_spawn_02"],
		OBJECT_NAMES[areaCaptureObjectName .. "_spawn_03"],
		OBJECT_NAMES[areaCaptureObjectName .. "_spawn_04"],
	};
end

-- Table of TagReferences to be used for initArgs
global GameModeTagReferences:table =
{
	Universal =
	{
		HackDevice = TAG('levels\assets\shiva\designer\des_pawren\tow_control\tow_control.device_control'),
		InvisibleCrate = TAG('objects\multi\generic\invisible_crate\invisible_crate.crate'),
		ReviveDevice = TAG('objects\multi\elimination\revive_device\revive_device.device_control'),
		ExecuteDevice = TAG('objects\multi\elimination\execution_device\execution_device.device_control'),
		ReviveCrate = TAG('fx\library_olympus\levels\mp\game_objects\personal_ai\crate\ai_bubble_crate.crate'),
		ReviveLoop = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_elimination\004_mod_mp_elimination_revive_loop.sound_looping'),
		ExecuteLoop = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_elimination\004_mod_mp_elimination_aiexecute_loop.sound_looping'),
		DeathVolumeDamageEffect = TAG('globals\damage_effects\mp_elimination_mode_damage.damage_effect'),
		suddenDeathCaptureLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_suddendeath_zone_captureloop_team.sound_looping'),
		suddenDeathCaptureLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_suddendeath_zone_captureloop_enemy.sound_looping'),
		suddenDeathCaptureLoopTeamReverse = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_suddendeath_zone_capturereverseloop_team.sound_looping'),
		suddenDeathCaptureLoopEnemyReverse = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_suddendeath_zone_capturereverseloop_enemy.sound_looping'),
		GameModeObjectSpawnEffect = TAG('fx\library_olympus\levels\mp\game_modes\general\generic_object_spawn.effect'),
		DynamicSpawnInfluencerTag = TAG('levels\assets\shiva\forge_gameplay\spawns\respawn_zone\ff_respawn_zone.crate'),
		HackableObjectHackingLoop = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_hackingterminal_hacking_loop.sound_looping'),
		HackableObjectResettingLoop = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_mp_shared_hackingterminal_resetting_loop.sound_looping'),
	},

	CTF =
	{
		FlagObjectTag = TAG('objects\weapons\multiplayer\proto_flag\proto_flag.weapon'),
		FlagStandScreenFlash = TAG('objects\multi\ctf\ctf_flag_stand\fx\ctf_stand_screen_flash.effect'),
		FlagStandSparks = TAG('objects\multi\ctf\ctf_flag_stand\fx\ctf_stand_sparks_lg_01.effect'),
		FlagStandLightFlash = TAG('objects\multi\ctf\ctf_flag_stand\fx\ctf_stand_light_flash.effect'),

		--Arena Flag Return Loops
		flagReturnLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_ctf\004_mod_mp_ctf_flag_returnloop_enemy.sound_looping'),
		flagReturnLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_ctf\004_mod_mp_ctf_flag_returnloop_team.sound_looping'),
		flagResetLoop = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_ctf\004_mod_mp_ctf_flag_returnloop_passive.sound_looping'),

		--BTB Flag Return Loops
		flagBTBReturnLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbctf\004_mod_mp_btbctf_flag_returnloop_enemy.sound_looping'),
		flagBTBReturnLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbctf\004_mod_mp_btbctf_flag_returnloop_team.sound_looping'),
		flagBTBResetLoop = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbctf\004_mod_mp_btbctf_flag_returnloop_passive.sound_looping'),
	},

	Ball =
	{
		BallObjectTag = TAG('objects\weapons\multiplayer\ball\ball.weapon'),
	},

	Oddball =
	{
		OddballObjectTag = TAG('objects\weapons\multiplayer\skull\skull.weapon'),
		OddballSpawnObjectTag = TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_ballspawn_a\unsc_wo_ballspawn_a__dm.device_machine');
	},

	Bastion =
	{
		CapturingLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_areacapture\004_mod_mp_areacapture_zone_captureloop_enemy.sound_looping'),
		CapturingLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_areacapture\004_mod_mp_areacapture_zone_captureloop_team.sound_looping'),
		ReverseCapturingLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_areacapture\004_mod_mp_areacapture_zone_capturereverse_enemy_loop.sound_looping'),
		ReverseCapturingLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_areacapture\004_mod_mp_areacapture_zone_capturereverse_team_loop.sound_looping'),
		ScoringLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_areacapture\004_mod_mp_areacapture_zone_scoringloop_enemy.sound_looping'),
		ScoringLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_areacapture\004_mod_mp_areacapture_zone_scoringloop_team.sound_looping'),

		PlateScoreVFX = TAG('fx\library_olympus\levels\mp\game_modes\area_capture\area_capture_score_stronghold.effect'),
		PlateFanfareVFX = TAG('fx\library_olympus\levels\mp\game_modes\area_capture\area_capture_score.effect'),
	},

	Strongholds =
	{
		CapturingLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_strongholds\004_mod_mp_strongholds_zone_captureloop_enemy.sound_looping'),
		CapturingLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_strongholds\004_mod_mp_strongholds_zone_captureloop_team.sound_looping'),
		ScoringLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_strongholds\004_mod_mp_strongholds_zone_controlledloop_enemy.sound_looping'),
		ScoringLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_strongholds\004_mod_mp_strongholds_zone_controlledloop_team.sound_looping'),
	},

	Armzone =
	{
		ArmingTag = TAG('levels\assets\shiva\designer\des_zaboy\hackable_zone\hackable_zone.device_control'),
		PlantedTag = TAG('levels\assets\shiva\designer\des_pawren\armzone_control\armzone_control.device_control'),
	},

	Assault =
	{
		BombTag = TAG('objects\primitives\carriable\primitive_carriable_bomb.weapon'),
		ArmingDeviceTag = TAG('objects\multi\assault\bomb_armsite\bomb_armsite.device_control'),
		DefuseDeviceTag = TAG('objects\multi\assault\planted_bomb\planted_bomb.device_control'),

		-- VFX
		SmokeEffect = TAG('fx\library_olympus\smoke\smoke_damaged_residual_01.effect'),

		-- LOOPS
		AssaultLoopArmTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_assault\004_mod_mp_assault_bomb_armloop_team.sound_looping'),
		AssaultLoopArmEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_assault\004_mod_mp_assault_bomb_armloop_enemy.sound_looping'),
		AssaultLoopDisarm = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_assault\004_mod_mp_assault_bomb_disarm_loop.sound_looping'),
		AssaultLoopPlanted = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_assault\004_mod_mp_assault_bomb_planted_loop.sound_looping'),
		AssaultLoopResetting = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_assault\004_mod_mp_assault_bomb_resetting_loop.sound_looping'),

		-- BTB Loops
		BTBAssaultLoopArmTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbassault\004_mod_mp_btbassault_bomb_armloop_team.sound_looping'),
		BTBAssaultLoopArmEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbassault\004_mod_mp_btbassault_bomb_armloop_enemy.sound_looping'),
		BTBAssaultLoopDisarm = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbassault\004_mod_mp_btbassault_bomb_disarm_loop.sound_looping'),
		BTBAssaultLoopPlanted = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbassault\004_mod_mp_btbassault_bomb_planted_loop.sound_looping'),
		BTBAssaultLoopResetting = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbassault\004_mod_mp_btbassault_bomb_resetting_loop.sound_looping'),
	},

	Grifball = 
	{
		BombTag = TAG('objects\weapons\multiplayer\assault_bomb\assault_bomb.weapon'),
		OutlineTag = TAG('globals\forge\outlines\weldedgroup_child_highlighted_grabbed.outlinetypedefinition'),
		GoalScreenFlash = TAG('objects\multi\ctf\ctf_flag_stand\fx\ctf_stand_screen_flash.effect'),
		GoalPlate = TAG('fx\library_olympus\levels\mp\game_modes\area_capture\area_capture_score.effect'),
	},

	Extraction =
	{
		ExtractionInteractWeapon = TAG('objects\primitives\extraction_device\extraction_device.weapon'),
		InitializationDevice = TAG('objects\multi\extraction\extraction_initialization_control.device_control'),
		ConversionDevice = TAG('objects\multi\extraction\extraction_deactivation_control.device_control'),

		ZoneExtractingLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_extraction\004_mod_mp_extraction_zone_extractingloop_enemy.sound_looping'),
		ZoneExtractingLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_extraction\004_mod_mp_extraction_zone_extractingloop_team.sound_looping'),

		ZoneHackLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_extraction\004_mod_mp_extraction_zone_hackloop_enemy.sound_looping'),
		ZoneHackLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_extraction\004_mod_mp_extraction_zone_hackloop_team.sound_looping'),

		ZoneConvertingLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_extraction\004_mod_mp_extraction_zone_convertingloop_enemy.sound_looping'),
		ZoneConvertingLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_extraction\004_mod_mp_extraction_zone_convertingloop_team.sound_looping'),
	
		ExtractionPulseEffect = TAG('fx\library_olympus\levels\mp\game_modes\extraction\extraction_device_pulse.effect'),
	},

	Stockpile =
	{
		-- NOTE: This capacitor tag MUST match the one defined in GameModeClientTagReferences.Stockpile
		CapacitorTag = TAG('objects\primitives\carriable\primitive_carriable.weapon'),
		StealLoop = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbstockpile\004_mod_mp_btbstockpile_capacitor_steal_loop.sound_looping'),
	},

	BTS =
	{
		VehicleRunActivityNodeTag = TAG('objects\temp\fereyesm\bts_ring\bts_ring.crate'),
		SkullTag = TAG('levels\assets\shiva\lookdev\ensrude\test_assets\map_objects\bto_spartan_chip\bto_spartan_chip.crate'),
		FlagTag = TAG('objects\weapons\multiplayer\proto_flag\proto_flag.weapon'),
		StockpileCompleteFX = TAG('fx\library_olympus\levels\mp\bto\general\stockpile_delivered.effect'),
		HackCompleteFX = TAG('fx\library_olympus\levels\mp\bto\general\stockpile_delivered.effect'),
		TerritoryCompleteFX = TAG('fx\library_olympus\levels\mp\bto\general\stockpile_delivered.effect'),
	},
	
	Juggernaut =
	{
		JuggernautEffectTag = TAG('fx\scratch\matthewb\gnr8tr_shield_test.effect'),
	},

	KingOfTheHill =
	{
		HillContestedSound = TAG('sound\001_vo\multiplayer\001_vo_mul_announcer\001_vo_mul_mp_announcer_koth_hillcontested_00100.sound'),
		HillMovedSound = TAG('sound\001_vo\multiplayer\001_vo_mul_announcer\001_vo_mul_mp_announcer_koth_hillmoved_00100.sound'),
	},

	TotalControl =
	{
		CapturingLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbterritories\004_mod_mp_btbterritories_zone_captureloop_enemy.sound_looping'),
		CapturingLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbterritories\004_mod_mp_btbterritories_zone_captureloop_team.sound_looping'),
		ControlledLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbterritories\004_mod_mp_btbterritories_zone_controlledloop_enemy.sound_looping'),
		ControlledLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbterritories\004_mod_mp_btbterritories_zone_controlledloop_team.sound_looping'),
		ReverseCapturingLoopEnemy = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbterritories\004_mod_mp_btbterritories_zone_capturereverseloop_enemy.sound_looping'),
		ReverseCapturingLoopTeam = TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_btbterritories\004_mod_mp_btbterritories_zone_capturereverseloop_team.sound_looping'),
	},
};

function GetObjectPlacementByLabelOrName(objectLabelAndNameString:string):object_name
	return ObjectPlacements_GetFirstByMultiplayerLabel(objectLabelAndNameString) or OBJECT_NAMES[objectLabelAndNameString];
end

function GetObjectPlacementByLabelOrNameFunc(objectLabelAndNameString:string):ifunction
	return
		function()
			return GetObjectPlacementByLabelOrName(objectLabelAndNameString);
		end
end

function GetOvertimeZoneObjectPlacement():object_name
	return GetObjectPlacementByLabelOrName("attrition_overtime_zone");
end

global GeneralParcelArgs:table =
{
	LifepoolArgs =
		hmake LifePoolInitArgs
		{
			instanceName = "Lifepool",
			lifePoolSizePerTeam = 20,
			overtimeZoneName = GetOvertimeZoneObjectPlacement,
		},

	LifepoolFFAArgs =
		hmake LifePoolInitArgs
		{
			instanceName = "LifepoolFFA",
			lifePoolSizePerTeam = 8,
			overtimeZoneName = GetOvertimeZoneObjectPlacement,
		},

	LifepoolDodgeballArgs =
		hmake LifePoolInitArgs
		{
			instanceName = "LifepoolDodgeball",
			lifePoolSizePerTeam = 4,
			overtimeZoneName = GetOvertimeZoneObjectPlacement,
		},

	LifepoolDodgeballElimOnlyArgs =
		hmake LifePoolInitArgs
		{
			instanceName = "LifepoolDodgeballElimOnly",
			lifePoolSizePerTeam = 8,
			overtimeZoneName = GetOvertimeZoneObjectPlacement,
		},

	LifepoolDodgeballFFAArgs =
		hmake LifePoolInitArgs
		{
			instanceName = "LifepoolDodgeballFFA",
			lifePoolSizePerTeam = 2,
			overtimeZoneName = GetOvertimeZoneObjectPlacement,
		},

	EliminationArgs =
		hmake LifePoolInitArgs
		{
			instanceName = "Elimination",
			lifePoolSizePerTeam = 0,
			overtimeZoneName = GetOvertimeZoneObjectPlacement,
		},
};

function GetBombInitialSpawnRedFunc(num:number):ifunction
	if (num == 1) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_initial_red_01");
	elseif (num == 2) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_initial_red_02");
	elseif (num == 3) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_initial_red_03");
	end
	
	return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_initial_red");
end

function GetBombInitialSpawnBlueFunc(num:number):ifunction
	if (num == 1) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_initial_blue_01");
	elseif (num == 2) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_initial_blue_02");
	elseif (num == 3) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_initial_blue_03");
	end
	
	return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_initial_blue");
end

function GetBombSpawnRespawnFunc(num:number):ifunction
	if (num == 1) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_respawn_01");
	elseif (num == 2) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_respawn_02");
	elseif (num == 3) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_respawn_03");
	elseif (num == 4) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_respawn_04");
	end

	return GetObjectPlacementByLabelOrNameFunc("bomb_spawn_respawn");
end

function GetBombsiteBlueFunc(num:number):ifunction
	if (num == 1) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_site_blue_01");
	elseif (num == 2) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_site_blue_02");
	elseif (num == 3) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_site_blue_03");
	end
	
	return GetObjectPlacementByLabelOrNameFunc("bomb_site_blue");
end

function GetBombsiteRedFunc(num:number):ifunction
	if (num == 1) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_site_red_01");
	elseif (num == 2) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_site_red_02");
	elseif (num == 3) then
		return GetObjectPlacementByLabelOrNameFunc("bomb_site_red_03");
	end

	return GetObjectPlacementByLabelOrNameFunc("bomb_site_red");
end

function GetFlagStandRedFunc(num:number):ifunction
	if (num == 1) then
		return GetObjectPlacementByLabelOrNameFunc("red_flag_stand_01");
	elseif (num == 2) then
		return GetObjectPlacementByLabelOrNameFunc("red_flag_stand_02");
	elseif (num == 3) then
		return GetObjectPlacementByLabelOrNameFunc("red_flag_stand_03");
	end

	return GetObjectPlacementByLabelOrNameFunc("red_flag_stand");
end

function GetFlagStandBlueFunc(num:number):ifunction
	if (num == 1) then
		return GetObjectPlacementByLabelOrNameFunc("blue_flag_stand_01");
	elseif (num == 2) then
		return GetObjectPlacementByLabelOrNameFunc("blue_flag_stand_02");
	elseif (num == 3) then
		return GetObjectPlacementByLabelOrNameFunc("blue_flag_stand_03");
	end

	return GetObjectPlacementByLabelOrNameFunc("blue_flag_stand");
end

function GetFlagDeliveryPlacementRed():object_name
	return GetObjectPlacementByLabelOrName("red_flag_deliver");
end

function GetFlagDeliveryPlacementBlue():object_name
	return GetObjectPlacementByLabelOrName("blue_flag_deliver");
end

-- InitArgs for legacy style modes go here!
global LegacyModeInitData:table =
{
	Assault =
	{
		-- Asym
		OneBombArgs =
			hmake AssaultInitArgs
			{
				instanceName = "AssaultOneBomb",
				bombSpawnArgs = {
					hmake BombSpawnArgs
					{
						objectName = GetObjectPlacementByLabelOrNameFunc("bomb_spawn"),
						owningTeam = MP_TEAM.mp_team_blue,
					},
				},
				armzoneArgs = {
					hmake ArmzoneArgs
					{
						objectName = GetObjectPlacementByLabelOrNameFunc("bomb_site_a"),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake ArmzoneArgs
					{
						objectName = GetObjectPlacementByLabelOrNameFunc("bomb_site_b"),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				bombTag = GameModeTagReferences.Assault.BombTag,
				armingDeviceTag = GameModeTagReferences.Assault.ArmingDeviceTag,
				defuseDeviceTag = GameModeTagReferences.Assault.DefuseDeviceTag,
				smokeEffect = GameModeTagReferences.Assault.SmokeEffect,
				LoopArmTeam = GameModeTagReferences.Assault.AssaultLoopArmTeam,
				LoopArmEnemy = GameModeTagReferences.Assault.AssaultLoopArmEnemy,
				LoopDisarm = GameModeTagReferences.Assault.AssaultLoopDisarm,
				LoopPlanted	= GameModeTagReferences.Assault.AssaultLoopPlanted,
				LoopResetting = GameModeTagReferences.Assault.AssaultLoopResetting	

			},

		NeutralBombArgs =
			hmake AssaultInitArgs
			{
				instanceName = "AssaultNeutralBomb",
				bombSpawnArgs = {
					-- owningTeam is implicitly nil for these args (meaning Neutral objects)
					hmake BombSpawnArgs 
					{ 
						objectName = GetObjectPlacementByLabelOrNameFunc("neutral_bomb_spawn")
					},
				},
				armzoneArgs = {
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				bombTag = GameModeTagReferences.Assault.BombTag,
				armingDeviceTag = GameModeTagReferences.Assault.ArmingDeviceTag,
				defuseDeviceTag = GameModeTagReferences.Assault.DefuseDeviceTag,
				smokeEffect = GameModeTagReferences.Assault.SmokeEffect,
				LoopArmTeam = GameModeTagReferences.Assault.AssaultLoopArmTeam,
				LoopArmEnemy = GameModeTagReferences.Assault.AssaultLoopArmEnemy,
				LoopDisarm = GameModeTagReferences.Assault.AssaultLoopDisarm,
				LoopPlanted	= GameModeTagReferences.Assault.AssaultLoopPlanted,
				LoopResetting = GameModeTagReferences.Assault.AssaultLoopResetting	
			},

		MultiBombArgs =
			hmake AssaultInitArgs
			{
				instanceName = "AssaultMultiBomb",
				bombSpawnArgs = {
					hmake BombSpawnArgs
					{
						objectName = GetBombInitialSpawnRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake BombSpawnArgs
					{
						objectName = GetBombInitialSpawnBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
				},
				armzoneArgs = {
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
				},
				bombTag = GameModeTagReferences.Assault.BombTag,
				armingDeviceTag = GameModeTagReferences.Assault.ArmingDeviceTag,
				defuseDeviceTag = GameModeTagReferences.Assault.DefuseDeviceTag,
				smokeEffect = GameModeTagReferences.Assault.SmokeEffect,
				LoopArmTeam = GameModeTagReferences.Assault.AssaultLoopArmTeam,
				LoopArmEnemy = GameModeTagReferences.Assault.AssaultLoopArmEnemy,
				LoopDisarm = GameModeTagReferences.Assault.AssaultLoopDisarm,
				LoopPlanted	= GameModeTagReferences.Assault.AssaultLoopPlanted,
				LoopResetting = GameModeTagReferences.Assault.AssaultLoopResetting	
			},
		
		BTBNeutralBombArgs =
			hmake AssaultInitArgs
			{
				instanceName = "AssaultNeutralBomb",
				bombSpawnArgs = {
					-- owningTeam is implicitly nil for these args (meaning Neutral objects)
					-- Note that we will only use as many of these spawns as determined by Assault.CONFIG.desiredNumBombsPerTeam
					hmake BombSpawnArgs { objectName = GetObjectPlacementByLabelOrNameFunc("neutral_bomb_spawn") },
				},
				bombRespawnPointArgs = {
					-- owningTeam is implicitly nil for these args (meaning Neutral objects)
					-- Note that we will only attempt to use respawn points if Assault.CONFIG.prioritizeBombRespawnPointsOnReset == true
					hmake BombRespawnPointArgs { objectName = GetObjectPlacementByLabelOrNameFunc("neutral_bomb_spawn") },
					hmake BombRespawnPointArgs { objectName = GetBombSpawnRespawnFunc(1) },
					hmake BombRespawnPointArgs { objectName = GetBombSpawnRespawnFunc(2) },
					hmake BombRespawnPointArgs { objectName = GetBombSpawnRespawnFunc(3) },
					hmake BombRespawnPointArgs { objectName = GetBombSpawnRespawnFunc(4) },
				},
				armzoneArgs = { 
					-- Note that we will only use as many of these armzone locations as determined by Assault.CONFIG.desiredArmzonesPerTeam
					hmake ArmzoneArgs
					{
						objectName = function() return OBJECT_NAMES["bomb_site_blue"]; end,
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteBlueFunc(1),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteBlueFunc(2),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteRedFunc(1),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteRedFunc(2),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				bombTag = GameModeTagReferences.Assault.BombTag,
				armingDeviceTag = GameModeTagReferences.Assault.ArmingDeviceTag,
				defuseDeviceTag = GameModeTagReferences.Assault.DefuseDeviceTag,
				smokeEffect = GameModeTagReferences.Assault.SmokeEffect,
				LoopArmTeam = GameModeTagReferences.Assault.BTBAssaultLoopArmTeam,
				LoopArmEnemy = GameModeTagReferences.Assault.BTBAssaultLoopArmEnemy,
				LoopDisarm = GameModeTagReferences.Assault.BTBAssaultLoopDisarm,
				LoopPlanted	= GameModeTagReferences.Assault.BTBAssaultLoopPlanted,
				LoopResetting = GameModeTagReferences.Assault.BTBAssaultLoopResetting	
			},

		BTBMultiNeutralBombArgs =
			hmake AssaultInitArgs
			{
				instanceName = "AssaultMultiNeutralBomb",
				bombRespawnPointArgs = {
					-- owningTeam is implicitly nil for these args (meaning Neutral objects)
					-- Note that we will only attempt to use respawn points if Assault.CONFIG.prioritizeBombRespawnPointsOnReset == true
					hmake BombRespawnPointArgs { objectName = GetBombSpawnRespawnFunc(0) },
					hmake BombRespawnPointArgs { objectName = GetBombSpawnRespawnFunc(1) },
					hmake BombRespawnPointArgs { objectName = GetBombSpawnRespawnFunc(2) },
					hmake BombRespawnPointArgs { objectName = GetBombSpawnRespawnFunc(3) },
					hmake BombRespawnPointArgs { objectName = GetBombSpawnRespawnFunc(4) },
				},
				bombSpawnArgs = {
					-- owningTeam is implicitly nil for these args (meaning Neutral objects)
					-- Note that we will only use as many of these spawns as determined by Assault.CONFIG.desiredNumBombsPerTeam
					hmake BombSpawnArgs { objectName = GetBombInitialSpawnRedFunc(0) },
					hmake BombSpawnArgs { objectName = GetBombInitialSpawnBlueFunc(0) },
					hmake BombSpawnArgs { objectName = GetBombInitialSpawnRedFunc(1) },
					hmake BombSpawnArgs { objectName = GetBombInitialSpawnBlueFunc(1) },
					hmake BombSpawnArgs { objectName = GetBombInitialSpawnRedFunc(2) },
					hmake BombSpawnArgs { objectName = GetBombInitialSpawnBlueFunc(2) },
				},
				armzoneArgs = { 
					-- Note that we will only use as many of these armzone locations as determined by Assault.CONFIG.desiredArmzonesPerTeam
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteBlueFunc(1),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteBlueFunc(2),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteRedFunc(1),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake ArmzoneArgs
					{
						objectName = GetBombsiteRedFunc(2),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				bombTag = GameModeTagReferences.Assault.BombTag,
				armingDeviceTag = GameModeTagReferences.Assault.ArmingDeviceTag,
				defuseDeviceTag = GameModeTagReferences.Assault.DefuseDeviceTag,
				smokeEffect = GameModeTagReferences.Assault.SmokeEffect,
				LoopArmTeam = GameModeTagReferences.Assault.BTBAssaultLoopArmTeam,
				LoopArmEnemy = GameModeTagReferences.Assault.BTBAssaultLoopArmEnemy,
				LoopDisarm = GameModeTagReferences.Assault.BTBAssaultLoopDisarm,
				LoopPlanted	= GameModeTagReferences.Assault.BTBAssaultLoopPlanted,
				LoopResetting = GameModeTagReferences.Assault.BTBAssaultLoopResetting	
			},
	},

	Grifball = 
	{
		BombArgs =
			hmake GrifballInitArgs
			{
				instanceName = "GrifballBomb",
				bombSpawnArgs = {
					hmake BombSpawnArgs
					{
						objectName = GetObjectPlacementByLabelOrNameFunc("ball_spawn"),
						owningTeam = GetNeutralMPTeam(),
					},
				},
				armzoneArgs = {
					hmake ArmzoneArgs
					{
						objectName = GetObjectPlacementByLabelOrNameFunc("defender_bombsite"),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake ArmzoneArgs
					{
						objectName = GetObjectPlacementByLabelOrNameFunc("attacker_bombsite"),
						owningTeam = MP_TEAM.mp_team_blue,
					},
				},

				bombTag = GameModeTagReferences.Ball.BallObjectTag,
				outlineTag = GameModeTagReferences.Grifball.OutlineTag,
				goalScreenFlash = GameModeTagReferences.Grifball.GoalScreenFlash,
				goalPlate = GameModeTagReferences.Grifball.GoalPlate,

			},
	},

	Extraction =
	{
		DefaultArgs =
			hmake ExtractionInitArgs
			{
				instanceName = "extraction";
				extractionZones =
				function ()
					return
					{
						OBJECT_NAMES["extraction_zone"],
						OBJECT_NAMES["extraction_zone01"],
						OBJECT_NAMES["extraction_zone02"],
						OBJECT_NAMES["extraction_zone03"],
						OBJECT_NAMES["extraction_zone04"],
						OBJECT_NAMES["extraction_zone05"],
					};
				end,
				extractionFloodPods =
				function()
					return
					{ 
						OBJECT_NAMES["extraction_blob"],
						OBJECT_NAMES["extraction_blob01"],
						OBJECT_NAMES["extraction_blob02"],
						OBJECT_NAMES["extraction_blob03"],
						OBJECT_NAMES["extraction_blob04"],
						OBJECT_NAMES["extraction_blob05"],
					}
				end,
				extractionWeaponTag = GameModeTagReferences.Extraction.ExtractionInteractWeapon,
				initializationDeviceTag = GameModeTagReferences.Extraction.InitializationDevice,
				conversionDeviceTag = GameModeTagReferences.Extraction.ConversionDevice,

				extractionPulseEffect = GameModeTagReferences.Extraction.ExtractionPulseEffect,
			},
	},

	VIP =
	{
		EscortArgs =
			hmake EscortInitArgs
			{
				instanceName = "Escort",
				checkpoints = {
					OBJECT_NAMES["center_zone_01"],
					OBJECT_NAMES["center_zone_02"],
					OBJECT_NAMES["center_zone_03"],
				};
			},

		KillArgs =
			hmake VipKillInitArgs
			{
				instanceName = "VIPKill",
			},
	},

	Oddball =
	{
		ClassicArgs =
			hmake OddballInitArgs
			{
				instanceName = "Oddball",
				objectTag = GameModeTagReferences.Oddball.OddballObjectTag,
				objectSpawnLocation = GetObjectPlacementByLabelOrNameFunc("oddball_spawn"),
				objectSpawnMarker = "mkr_spawn",
			},
	},

	Bastion =
	{

	},

	Strongholds =
	{

	},

	CTF =
	{
		MultiFlagArgs =
			hmake CTFInitArgs
			{
				instanceName = "MultiFlag_CTF",
				flagObjectTag = GameModeTagReferences.CTF.FlagObjectTag,
				flagSpawns = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagDeliveryStands = {
					hmake CTFFlagStand
					{
						objectName = GetFlagDeliveryPlacementBlue,
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagDeliveryPlacementRed,
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagStandScreenFlash = GameModeTagReferences.CTF.FlagStandScreenFlash,
				flagStandSparks = GameModeTagReferences.CTF.FlagStandSparks,
				flagStandLightFlash = GameModeTagReferences.CTF.FlagStandLightFlash,
			},

		DoubleMultiFlagArgs =
			hmake CTFInitArgs
			{
				instanceName = "MultiFlag_CTF",
				flagObjectTag = GameModeTagReferences.CTF.FlagObjectTag,
				flagSpawns = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(1),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(1),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagDeliveryStands = {
					hmake CTFFlagStand
					{
						objectName = GetFlagDeliveryPlacementBlue,
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagDeliveryPlacementRed,
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagStandScreenFlash = GameModeTagReferences.CTF.FlagStandScreenFlash,
				flagStandSparks = GameModeTagReferences.CTF.FlagStandSparks,
				flagStandLightFlash = GameModeTagReferences.CTF.FlagStandLightFlash,
			},
		
		TripleMultiFlagArgs  =
			hmake CTFInitArgs
			{
				instanceName = "MultiFlag_CTF",
				flagObjectTag = GameModeTagReferences.CTF.FlagObjectTag,
				flagSpawns = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(2),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(1),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(2),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(1),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagDeliveryStands = {
					hmake CTFFlagStand
					{
						objectName = GetFlagDeliveryPlacementBlue,
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagDeliveryPlacementRed,
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagStandScreenFlash = GameModeTagReferences.CTF.FlagStandScreenFlash,
				flagStandSparks = GameModeTagReferences.CTF.FlagStandSparks,
				flagStandLightFlash = GameModeTagReferences.CTF.FlagStandLightFlash,
			},

		SequentialMultiFlagArgs =
			hmake CTFInitArgs
			{
				instanceName = "MultiFlag_CTF",
				flagObjectTag = GameModeTagReferences.CTF.FlagObjectTag,
				flagSpawns = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(2), 
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(1),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(2),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(1),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagDeliveryStands = {
				hmake CTFFlagStand
					{
						objectName = GetFlagDeliveryPlacementBlue,
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagDeliveryPlacementRed,
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagStandScreenFlash = GameModeTagReferences.CTF.FlagStandScreenFlash,
				flagStandSparks = GameModeTagReferences.CTF.FlagStandSparks,
				flagStandLightFlash = GameModeTagReferences.CTF.FlagStandLightFlash,
			},

		OneFlagArgs =
			hmake CTFInitArgs
			{
				instanceName = "OneFlag_CTF",
				flagObjectTag = GameModeTagReferences.CTF.FlagObjectTag,
				flagSpawns = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagDeliveryStands = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
				},
				flagStandScreenFlash = GameModeTagReferences.CTF.FlagStandScreenFlash,
				flagStandSparks = GameModeTagReferences.CTF.FlagStandSparks,
				flagStandLightFlash = GameModeTagReferences.CTF.FlagStandLightFlash,
			},

		BTBFlagArgs =
			hmake CTFInitArgs
			{
				instanceName = "BTB_CTF",
				flagObjectTag = GameModeTagReferences.CTF.FlagObjectTag,
				flagSpawns = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagDeliveryStands = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagStandScreenFlash = GameModeTagReferences.CTF.FlagStandScreenFlash,
				flagStandSparks = GameModeTagReferences.CTF.FlagStandSparks,
				flagStandLightFlash = GameModeTagReferences.CTF.FlagStandLightFlash,
			},

		ThreeFlagArgs =
			hmake CTFInitArgs
			{
				instanceName = "ThreeFlag_CTF",
				flagObjectTag = GameModeTagReferences.CTF.FlagObjectTag,
				flagSpawns = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(1),
						owningTeam = MP_TEAM.mp_team_red,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(2),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagDeliveryStands = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
				},
				flagStandScreenFlash = GameModeTagReferences.CTF.FlagStandScreenFlash,
				flagStandSparks = GameModeTagReferences.CTF.FlagStandSparks,
				flagStandLightFlash = GameModeTagReferences.CTF.FlagStandLightFlash,
			},

		NeutralFlagArgs =
			hmake CTFInitArgs
			{
				instanceName = "NeutralFlag_CTF",
				flagObjectTag = GameModeTagReferences.CTF.FlagObjectTag,
				flagDeliveryStands = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagSpawns = {
					hmake CTFFlagStand
					{
						objectName = GetObjectPlacementByLabelOrNameFunc("neutral_flag_stand"),
						owningTeam = GetNeutralMPTeam(),
						isNeutralStand = true,
					},
				},
				flagStandScreenFlash = GameModeTagReferences.CTF.FlagStandScreenFlash,
				flagStandSparks = GameModeTagReferences.CTF.FlagStandSparks,
				flagStandLightFlash = GameModeTagReferences.CTF.FlagStandLightFlash,
			},

		TestFlagArgs = 
			hmake CTFInitArgs
			{
				-- May want a more elaborate framework later but for now, mimic multiflag
				instanceName = "TestFlag_CTF",
				flagObjectTag = GameModeTagReferences.CTF.FlagObjectTag,
				flagSpawns = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagDeliveryStands = {
					hmake CTFFlagStand
					{
						objectName = GetFlagStandBlueFunc(0),
						owningTeam = MP_TEAM.mp_team_blue,
					},
					hmake CTFFlagStand
					{
						objectName = GetFlagStandRedFunc(0),
						owningTeam = MP_TEAM.mp_team_red,
					},
				},
				flagStandScreenFlash = GameModeTagReferences.CTF.FlagStandScreenFlash,
				flagStandSparks = GameModeTagReferences.CTF.FlagStandSparks,
				flagStandLightFlash = GameModeTagReferences.CTF.FlagStandLightFlash,
			},
	},

	Stockpile =
	{
		BTBStockpile = 
			hmake StockpileInitArgs
			{
				instanceName = "BTBStockpile",

				capacitorLocations = {
					"btb_stockpile_seed_spawner_01",
					"btb_stockpile_seed_spawner_02",
					"btb_stockpile_seed_spawner_03",
				},

				redNavpointParent = OBJECT_NAMES["red_socket_area"],
				blueNavpointParent = OBJECT_NAMES["blue_socket_area"],

				redSockets = {
					hmake StockpileSocket
					{
						channel = "stockpile_red_socket_01",
						object = OBJECT_NAMES["stockpile_red_socket_01"],
					},
					hmake StockpileSocket
					{
						channel = "stockpile_red_socket_02",
						object = OBJECT_NAMES["stockpile_red_socket_02"],
					},
					hmake StockpileSocket
					{
						channel = "stockpile_red_socket_03",
						object = OBJECT_NAMES["stockpile_red_socket_03"],
					},
					hmake StockpileSocket
					{
						channel = "stockpile_red_socket_04",
						object = OBJECT_NAMES["stockpile_red_socket_04"],
					},
					hmake StockpileSocket
					{
						channel = "stockpile_red_socket_05",
						object = OBJECT_NAMES["stockpile_red_socket_05"],
					},
				},

				blueSockets = {
					hmake StockpileSocket
					{
						channel = "stockpile_blue_socket_01",
						object = OBJECT_NAMES["stockpile_blue_socket_01"],
					},
					hmake StockpileSocket
					{
						channel = "stockpile_blue_socket_02",
						object = OBJECT_NAMES["stockpile_blue_socket_02"],
					},
					hmake StockpileSocket
					{
						channel = "stockpile_blue_socket_03",
						object = OBJECT_NAMES["stockpile_blue_socket_03"],
					},
					hmake StockpileSocket
					{
						channel = "stockpile_blue_socket_04",
						object = OBJECT_NAMES["stockpile_blue_socket_04"],
					},
					hmake StockpileSocket
					{
						channel = "stockpile_blue_socket_05",
						object = OBJECT_NAMES["stockpile_blue_socket_05"],
					},
				},
			},

		ArenaStockpile = 
			hmake StockpileInitArgs
			{
				instanceName = "ArenaStockpile",

				capacitorLocations = {
					"btb_stockpile_seed_spawner_01",
					"btb_stockpile_seed_spawner_02",
					"btb_stockpile_seed_spawner_03",
				},

				redNavpointParent = OBJECT_NAMES["red_socket_area"],
				blueNavpointParent = OBJECT_NAMES["blue_socket_area"],

				redSockets = {
					hmake StockpileSocket
					{
						channel = "stockpile_red_socket_01",
						object = OBJECT_NAMES["stockpile_red_socket_01"],
					},
					hmake StockpileSocket
					{
						channel = "stockpile_red_socket_02",
						object = OBJECT_NAMES["stockpile_red_socket_02"],
					},
					hmake StockpileSocket
					{
						channel = "stockpile_red_socket_03",
						object = OBJECT_NAMES["stockpile_red_socket_03"],
					},
				},

				blueSockets = {
					hmake StockpileSocket
					{
						channel = "stockpile_blue_socket_01",
						object = OBJECT_NAMES["stockpile_blue_socket_01"],
					},
					hmake StockpileSocket
					{
						channel = "stockpile_blue_socket_02",
						object = OBJECT_NAMES["stockpile_blue_socket_02"],
					},
					hmake StockpileSocket
					{
						channel = "stockpile_blue_socket_03",
						object = OBJECT_NAMES["stockpile_blue_socket_03"],
					},
				},
			},
	},

	Territories =
	{
		DefaultArgs =
			hmake TerritoriesInitArgs
			{
				instanceName = "Territories",
				zoneSetsKit = "btb_totalcontrol_zonesets",
				redZones = { OBJECT_NAMES["red_zone_01"], OBJECT_NAMES["red_zone_02"], OBJECT_NAMES["red_zone_03"] },
				blueZones = { OBJECT_NAMES["blue_zone_01"], OBJECT_NAMES["blue_zone_02"], OBJECT_NAMES["blue_zone_03"] },
				centerZones = { OBJECT_NAMES["center_zone_01"], OBJECT_NAMES["center_zone_02"], OBJECT_NAMES["center_zone_03"] },
			},
	},

	Attrition =
	{
		DefaultArgs =
			hmake AttritionInitArgs
			{
				instanceName = "Attrition",
				overtimeZoneObject = GetOvertimeZoneObjectPlacement,
			},
	},

	Jailbreak =
	{
		DefaultArgs = 
			hmake JailBreakInitArgs
			{
				instanceName = "Jailbreak",
				jailAtkDoors = { OBJECT_NAMES["jail_a_door01"], OBJECT_NAMES["jail_a_door02"], OBJECT_NAMES["jail_a_door03"] },
				jailDefDoors = { OBJECT_NAMES["jail_d_door01"], OBJECT_NAMES["jail_d_door02"], OBJECT_NAMES["jail_d_door03"] },
				jailAtkHackingTerminal = OBJECT_NAMES["jail_control_a"],
				jailDefHackingTerminal = OBJECT_NAMES["jail_control_d"],
				jailVolumeAtk = "jailvolumea",
				jailVolumeDef = "jailvolumed",
			},
	},

	Juggernaut =
	{
		DefaultArgs =
			hmake JuggernautInitArgs
			{
				instanceName = "Juggernaut",
				juggernautEffectTag = GameModeTagReferences.Juggernaut.JuggernautEffectTag,
			},
	},

	KingOfTheHill =
	{
		DefaultArgs = 
			hmake KingOfTheHillInitArgs
			{
				instanceName = "kingofthehill",
				kingOfTheHillObjectNames = { OBJECT_NAMES["threehold_blue"], OBJECT_NAMES["threehold_neutral"], OBJECT_NAMES["threehold_red"] },
				hillContestedAnnouncerVOTag = GameModeTagReferences.KingOfTheHill.HillContestedSound,
				hillMovedAnnouncerVOTag = GameModeTagReferences.KingOfTheHill.HillMovedSound,
			},
	},

	Infection =
	{
		DefaultArgs =
			hmake InfectionInitArgs
			{
				instanceName = "Infection",
			},
	}
};

global AcademyModeInitData:table =
{
	Practice =
	{
		DefaultArgs =
			hmake AcademyPracticeInitArgs
			{
				instanceName = "summary_faceoff_title",
			},
	},
};

-- The keys here correspond to the string_ids used in weaponconstants.lua
global EquipmentAbilityData:table =
{
	evade = TAG('objects\armor\attachments\attachment_abilities\ability_evade\ability_evade.EvadeDefinitionTag'),
	knockback = TAG('objects\armor\attachments\attachment_abilities\ability_knockback\ability_knockback.equipment'),
	wall = TAG('objects\armor\attachments\attachment_abilities\spartan_equipment\deployable_wall\deployable_wall.equipment'),
	loc_sensor = TAG('objects\armor\attachments\attachment_abilities\ability_location_sensor_drone\ability_location_sensor_sticky.equipment'),
	active_camo = TAG('objects\equipment\unsc\active_camo\active_camo.equipment'),
	overshield = TAG('objects\equipment\unsc\overshield\overshield.equipment'),

	-- We only want the grapple VO firing when the player actually latches to a wall so we'll have to handle grapple activation separately.
	grapple = nil,
};

---------------------------------------------------
------------ GENERAL PARCEL ARGUMENTS -------------
---------------------------------------------------

function startup.MPBotTagRefInitialization()
	-- Artifact from when we had multiple characters per difficulty level. Right now they're all the same so this looks kinda silly.
	Bot_SetDifficultyTagRef(BOT_DIFFICULTY.Adaptive, TAG('objects\characters\spartans\ai\multiplayer_bots\bot_multiplayer_shared.character'));
	Bot_SetDifficultyTagRef(BOT_DIFFICULTY.WeaponDrill, TAG('objects\characters\spartans\ai\multiplayer_bots\bot_multiplayer_shared.character'));
	Bot_SetDifficultyTagRef(BOT_DIFFICULTY.Recruit, TAG('objects\characters\spartans\ai\multiplayer_bots\bot_multiplayer_shared.character'));
	Bot_SetDifficultyTagRef(BOT_DIFFICULTY.Marine, TAG('objects\characters\spartans\ai\multiplayer_bots\bot_multiplayer_shared.character'));
	Bot_SetDifficultyTagRef(BOT_DIFFICULTY.ODST, TAG('objects\characters\spartans\ai\multiplayer_bots\bot_multiplayer_shared.character'));
	Bot_SetDifficultyTagRef(BOT_DIFFICULTY.Spartan, TAG('objects\characters\spartans\ai\multiplayer_bots\bot_multiplayer_shared.character'));
end

--
-- MP AI Parcel
--

function startup.MPAIGlobals()
	PersonalAI_SetAvatarTagRef(MPPersonalAIConfigs.avatarTag);
	PersonalAI_SetEffectTagReferences(MPPersonalAIConfigs.loopingEffect, MPPersonalAIConfigs.oneShotSpawnEffect, MPPersonalAIConfigs.oneShotDespawnEffect);

	for i = 0, #PERSONAL_AI_AVATAR_TYPE - 1 do
		PersonalAI_SetAvatarAudioTagRef(PERSONAL_AI_AVATAR_TYPE[i], MPPersonalAIConfigs.avatarSoundTags[PERSONAL_AI_AVATAR_TYPE[i]]);
	end
end

function PersonalAIAnimationTypeIsDespawn(animType:personal_ai_animation_type):boolean
	return animType == PERSONAL_AI_ANIMATION_TYPE.Despawn or 
		   animType == PERSONAL_AI_ANIMATION_TYPE.DespawnSad or 
		   animType == PERSONAL_AI_ANIMATION_TYPE.DespawnNegative;
end

-- DEBUG for changing personal AI and setting the correct voice with visual
function DebugChangePersonalAIForPlayer(player:player, aiAvatar:personal_ai_avatar_type):void
	PersonalAI_SetAvatarType(player, aiAvatar)
	RegisterDialogueTagFor2DSpeaker(player, PersonalAIVisualToDialog[aiAvatar]);
end

--
-- Pelican Drop
-- 
function GetGlobalPelicanDropInits():PelicanDropExternalInitArgs
	return hmake PelicanDropExternalInitArgs
	{
		instanceName = "pelican_drop",
		pilotTag = TAG('objects\characters\null\ai\null_human_flying.character'),
		vehicleTag = TAG('objects\vehicles\human\scorpion\scorpion.vehicle'),
		pelicanTag = TAG('objects\vehicles\human\pelican\pelican.vehicle'),
	};
end

--
-- Vehicle Air Drop Ship
-- 
function GetGlobalVehicleAirDropShipInits():AirDropShip
	return hmake AirDropShip
	{
		vehicleDefinition = TAG('objects\vehicles\human\pelican\pelican.vehicle'),
		vehicleConfiguration = TAG('objects\vehicles\human\pelican\configurations\no_interior_pelican.vehicleconfiguration'),
		pilotDefinition = TAG('objects\characters\null\ai\null_human_flying.character')
	};
end

--
-- Ordnance
--

function GetLocalOrdnanceDeliveryServiceInitArgs():OrdnanceDeliveryServiceInitArgs
	return hmake OrdnanceDeliveryServiceInitArgs
	{
		instanceName = "ordnance_delivery_service",
		ordnanceDropPodTag = TAG('objects\vehicles\weapon\unsc_droppod_mover\ordnance_pod_mover.device_machine'),
		deliveryZoneControlTag = TAG('levels\assets\shiva\designer\v-theriv\delivery_zone.device_control'),
		tempUIBarTag = TAG('ui\wpf\anubisui\hud\scripted\prototype\horizontalbar.cui_screen'),
		tempUILabelTag = TAG('ui\wpf\anubisui\hud\scripted\prototype\label.cui_screen'),
		flareTag = TAG('levels\assets\shiva\lookdev\ryoun\unsc\ordnance_flare\ordnance_flare.crate'),
		deliveryZoneData = {},
	};
end


function GetLocalOrdnanceDeliveryServiceName():string
	return "ordnance_delivery_service";
end

function GetLocalBTSargs():BTSInitArgs
	return hmake BTSInitArgs
	{
		instanceName = "BTS";
		flyingBasesIds = {"ship_02", "ship_03"},
		outpostIds = { "bts_outpost_barracks", "bts_outpost_bunker", "bts_outpost_cargo", "bts_outpost_comms", "bts_outpost_fuel", "bts_outpost_garage", "bts_outpost_landing", "bts_att_outpost", "bts_def_outpost"},
		bombArmsiteTag = TAG('objects\multi\assault\bomb_armsite\bomb_armsite.device_control'),
		bombPlantedTag = TAG('objects\multi\assault\planted_bomb\planted_bomb.device_control'),
		bombTag = TAG('objects\weapons\multiplayer\ball\ball.weapon'),
		beamFXTag = TAG('fx\library\energy\energy_beam_blue_lg.effect'),
		explosionEffect = TAG('levels\assets\shiva\designer\des_zaboy\bto_proto_bomb_explosion\bto_proto_bomb_explosion.effect'),
		internalWeakpointTag = TAG('levels\assets\shiva\designer\des_pawren\ship_weak_points\ship_weak_point_int\ship_weak_point_int.crate'),
		weakpointTag = TAG('levels\assets\shiva\designer\des_pawren\ship_weak_points\ship_weak_point_ext\ship_weak_point_ext.crate')
	}
end

--
-- Supply Drops
--

function GetSupplyDropWeaponTable():table
	local weaponTable:table = {};

	-- Add back weapons if Supply Drops return
	
	return weaponTable;
end

-- ////////////////////////////////////////
-- ////// Item Spawner VO Scheduling //////
-- ////////////////////////////////////////

global MPItemGroupType = table.makeAutoEnum
{
	"Weapon",
	"Equipment",
	"Vehicle",
	"Ordnance",
};

global MPItemVOType = table.makeAutoEnum
{
	"Incoming",
	"Ready",
};

-- ////////////////////////////////////////
-- //////// Item Spawner Presets //////////
-- ////////////////////////////////////////

global ItemPresetGameMode = table.makeAutoEnum
{
	"Arena",
	"BTB",
};

function GetItemSpawnerPresetGameModeType():number		
	if (Variant_GetUseSecondaryItemSpawnerPresets()) then
		return ItemPresetGameMode.BTB;
	else
		return ItemPresetGameMode.Arena;
	end
end

function GetMPWeaponSpawnerPresets():table
	local presets:table = {};

	presets[ItemPresetGameMode.Arena] = {};	-- Primary

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Base] = {};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.Pistol] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 30,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.AssaultRifle] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 30,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.TacticalRifle] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 30,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.SMG] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnExpire,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 15,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.Shotgun] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnExpire,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 15,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.SniperRifle] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnExpire,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 15,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.Launcher] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnExpire,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 15,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.AntiVehicle] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnExpire,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 15,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Power] = {};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Power][MP_WEAPON_CLASS.SniperRifle] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 180,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Power][MP_WEAPON_CLASS.Launcher] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 120,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Power][MP_WEAPON_CLASS.Melee] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 240,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_WEAPON_TIER.Power][MP_WEAPON_CLASS.AntiVehicle] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 120,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};


	presets[ItemPresetGameMode.BTB] = {};	-- Secondary

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Base] = {};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.Pistol] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 30,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.AssaultRifle] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 30,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.TacticalRifle] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 30,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.SMG] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnExpire,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 15,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.Shotgun] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnExpire,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 15,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.SniperRifle] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnExpire,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 15,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.Launcher] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnExpire,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 15,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Base][MP_WEAPON_CLASS.AntiVehicle] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnExpire,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 15,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Power] = {};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Power][MP_WEAPON_CLASS.SniperRifle] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 180,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Power][MP_WEAPON_CLASS.Launcher] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 120,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Power][MP_WEAPON_CLASS.Melee] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 240,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_WEAPON_TIER.Power][MP_WEAPON_CLASS.AntiVehicle] = hmake MPWeaponPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 120,
		maxDeployedItemCount = 0,
		ammoModifier = 1,
	};

	return presets;
end

function GetMPEquipmentSpawnerPresets():table
	local presets:table = {};

	presets[ItemPresetGameMode.Arena] = {};	-- Primary

	presets[ItemPresetGameMode.Arena][MP_EQUIPMENT_CLASS.Equipment] = hmake MPEquipmentPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 60,
		maxDeployedItemCount = 0,
		energyModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_EQUIPMENT_CLASS.PowerUp] = hmake MPEquipmentPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 120,
		maxDeployedItemCount = 0,
		energyModifier = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_EQUIPMENT_CLASS.Grenade] = hmake MPEquipmentPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 30,
		maxDeployedItemCount = 0,
		energyModifier = 1,
		spawnGrenadesCyclically = false,
	};

	presets[ItemPresetGameMode.BTB] = {};	-- Secondary

	presets[ItemPresetGameMode.BTB][MP_EQUIPMENT_CLASS.Equipment] = hmake MPEquipmentPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 60,
		maxDeployedItemCount = 0,
		energyModifier = math.huge,
	};

	presets[ItemPresetGameMode.BTB][MP_EQUIPMENT_CLASS.PowerUp] = hmake MPEquipmentPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 120,
		maxDeployedItemCount = 0,
		energyModifier = math.huge,
	};

	presets[ItemPresetGameMode.BTB][MP_EQUIPMENT_CLASS.Grenade] = hmake MPEquipmentPropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		initialSpawnDelay = 0,
		respawnTime = 30,
		maxDeployedItemCount = 0,
		energyModifier = 1,
		spawnGrenadesCyclically = false,
	};

	return presets;
end

function GetMPVehicleSpawnerPresets():table
	local presets:table = {};

	presets[ItemPresetGameMode.Arena] = {};	-- Primary

	presets[ItemPresetGameMode.Arena][MP_VEHICLE_CLASS.Support] = hmake MPVehiclePropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		terrainType = nil,
		initialSpawnDelay = 0,
		respawnTime = 60,
		maxDeployedItemCount = 0,
	};

	presets[ItemPresetGameMode.Arena][MP_VEHICLE_CLASS.Duelist] = hmake MPVehiclePropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		terrainType = nil,
		initialSpawnDelay = 0,
		respawnTime = 120,
		maxDeployedItemCount = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_VEHICLE_CLASS.Cavalry] = hmake MPVehiclePropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		terrainType = nil,
		initialSpawnDelay = 0,
		respawnTime = 120,
		maxDeployedItemCount = 1,
	};

	presets[ItemPresetGameMode.Arena][MP_VEHICLE_CLASS.Siege] = hmake MPVehiclePropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		terrainType = nil,
		initialSpawnDelay = 0,
		respawnTime = 240,
		maxDeployedItemCount = 1,
	};

	presets[ItemPresetGameMode.BTB] = {};	-- Secondary

	presets[ItemPresetGameMode.BTB][MP_VEHICLE_CLASS.Support] = hmake MPVehiclePropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.DynamicOnPickup,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		terrainType = nil,
		initialSpawnDelay = 0,
		respawnTime = 60,
		maxDeployedItemCount = 0,
	};

	presets[ItemPresetGameMode.BTB][MP_VEHICLE_CLASS.Duelist] = hmake MPVehiclePropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		terrainType = nil,
		initialSpawnDelay = 0,
		respawnTime = 120,
		maxDeployedItemCount = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_VEHICLE_CLASS.Cavalry] = hmake MPVehiclePropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		terrainType = nil,
		initialSpawnDelay = 0,
		respawnTime = 120,
		maxDeployedItemCount = 1,
	};

	presets[ItemPresetGameMode.BTB][MP_VEHICLE_CLASS.Siege] = hmake MPVehiclePropertyPreset
	{
		spawnLogic = MP_SPAWN_LOGIC.FixedInterval,
		randomizeFreq = MP_RANDOMIZE_FREQUENCY.Game,
		faction = nil,
		terrainType = nil,
		initialSpawnDelay = 0,
		respawnTime = 240,
		maxDeployedItemCount = 1,
	};

	return presets;
end

-- //////////////////////////////
-- ////////// Big Team //////////
-- //////////////////////////////

global BTSActivityTrackingType = table.makeAutoEnum
{
	"Zone",
	"GameObjectInteraction",
	"Ping",
};

global BTSActivityCategories = table.makeAutoEnum
{
	"Scavenge",
	"Control",
	"Hack",
	"Destroy",
	"Kill",
	"Scout",
	"Deliver",
	"Defend",
};

function GetBTSCoinTierTypeTable():table
	local objectTable:table = {
		["primary"] = TAG('objects\multi\bts\bts_coin_primary\bts_coin_primary.weapon'),
		["secondary"] = TAG('objects\multi\bts\bts_coin_secondary\bts_coin_secondary.weapon'),
		["heavy"] = TAG('objects\multi\bts\bts_coin_heavy\bts_coin_heavy.weapon'),
		["power"] = TAG('objects\multi\bts\bts_coin_power\bts_coin_power.weapon'),
	};

	return objectTable;
end

function AddDeliveryPoints(deliveryPointData:table, mapZone:map_zone, mapZoneConfigs:table, deliveryPoints:table):void
	for _, mapZoneConfig in ipairs(mapZoneConfigs) do
		deliveryPointData[#deliveryPointData + 1] =
			hmake OrdnanceDeliveryPointZoneData
			{
				mapZone = mapZone,
				mapZoneConfig = mapZoneConfig,
				deliveryPoints = deliveryPoints,
			};
	end
end

function AddDeliveries(
	scheduleData:table,
	mapZone:map_zone,
	mapZoneConfigs:table,
	deliveries:table,
	eventName:string,
	targetObject:object_name,
	brTierDeliveriesEnabled:boolean):void

	for _, mapZoneConfig in ipairs(mapZoneConfigs) do
		scheduleData[#scheduleData + 1] =
			hmake SupplyDropDeliveryScheduleData
			{
				mapZone = mapZone,
				mapZoneConfig = mapZoneConfig,
				eventName = eventName,
				eventObjectName = targetObject,
				deliveries = deliveries,
				brTierDeliveriesEnabled = brTierDeliveriesEnabled,
			};
	end
end

global TurretVehicleTags:table = 
{
	TAG('objects\vehicles\covenant\turrets\gatling_mortar\gatling_mortar.vehicle'),
	TAG('objects\vehicles\human\turrets\unsc_turret\unsc_turret.vehicle'),
	TAG('objects\vehicles\covenant\turrets\shade\shade.vehicle'),
	TAG('objects\vehicles\covenant\turrets\plasma_turret\plasma_turret_mounted.vehicle')
};

global CalloutObjectWhitelist:table = 
{
	GameModeTagReferences.Oddball.OddballSpawnObjectTag,
	TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_equipmentpad_a\unsc_wo_equipmentpad_a.device_machine'),
	TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_flagspawn_a\unsc_wo_flagspawn_a__dm.device_machine'),
	TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_poweruppad_a\unsc_wo_poweruppad_a.device_machine'),
	TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_grenadedispenser_a\unsc_wo_grenadedispenser_a.device_machine'),
	TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpad_a\unsc_wo_weaponpad_a__dm.device_machine'),
	TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpad_b\unsc_wo_weaponpad_b.device_machine'),
	TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponrack_a\unsc_wo_weaponrack_a.device_machine'),
	TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponrack_b\unsc_weapons_rack_test_b.device_machine'),
	TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weapontrunk_a\unsc_wo_weapontrunk_a.device_machine'),
	TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weapontrunk_b\unsc_wo_weapontrunk_b.device_machine'),
	TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_areacapture_a\unsc_wo_areacapture_a.device_machine')
}

global DropPodDispenserTag = TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_weaponpod_a\unsc_wo_weaponpod_a.device_machine');

--## CLIENT

------------------------------------------
-- Game Mode Client-only tag references --
------------------------------------------

global GameModeClientTagReferences:table =
{
	Universal =
	{
		ReviveEffect = TAG('fx\scratch\edreyes\mp\revive_success.effect'),
		ReviveAiIdleEffect = TAG('fx\library_olympus\levels\mp\game_objects\personal_ai\ai_bubble_idle.effect'),
		ReviveAiDissolveEffect = TAG('fx\library_olympus\levels\mp\game_objects\personal_ai\ai_bubble_dissolve.effect'),
		DeathVolumeAreaScreenEffect = TAG('fx\library_olympus\levels\mp\game_modes\elimination\mp_elimination_player_volume.effect'),
		DeathVolumeDamageBipedEffect = TAG('fx\library_olympus\levels\mp\game_modes\elimination\mp_elimination_player_damage.effect'),
	},

	TotalControl =
	{
		PlateFanfareVFX = TAG('fx\library_olympus\levels\mp\game_modes\area_capture\area_capture_score.effect'),
		DeliveredVFX = TAG('fx\library_olympus\levels\mp\bto\general\totalcontrol_delivered.effect'),
		PylonDespawnVFX = TAG('fx\library_olympus\levels\mp\bto\general\totalcontrol_pylon_despawn.effect'),
		CapturedVFX = TAG('fx\library_olympus\levels\mp\bto\general\totalcontrol_captured.effect'),
	},

	Stockpile = 
	{
		ScoreFX = TAG('fx\library_olympus\levels\mp\bto\general\stockpile_score.effect'),
		DepositSeedFX = TAG('fx\library_olympus\levels\mp\bto\general\stockpile_powercell_insert.effect'),
		SpawnZoneFX = TAG('fx\library_olympus\levels\mp\bto\general\stockpile_zone_spawn.effect'),
		DeliverOutline = TAG('globals\outlines\interaction_spartan_tracking_outline_active.outlinetypedefinition'),
		StealOutline = TAG('globals\outlines\interaction_spartan_tracking_outline_fill.outlinetypedefinition'),
		CapacitorTag = TAG('objects\primitives\carriable\primitive_carriable.weapon'), -- used for determining on the client whether or not a player is holding a power seed (for outlines)
	},
};

---------------------------------------------
-- Misc. global Client-only tag references --
---------------------------------------------

global LargeObjectiveOutlineTypes:table =
{
	neutralObjectOutline 		= TAG('globals\outlines\objective_neutral.outlinetypedefinition'),
	contestedObjectOutline 		= TAG('globals\outlines\objective_contested.outlinetypedefinition'),
	friendlyObjectOutline 		= TAG('globals\outlines\objective_friendly.outlinetypedefinition'),
	hostileObjectOutline 		= TAG('globals\outlines\objective_hostile.outlinetypedefinition'),
};

global HackerRevealedOutlineTypes:table =
{
	hackerOutline 		= TAG('globals\outlines\spartan_enemy_reveal.outlinetypedefinition'),
	hackerVisorPing 	= TAG('fx\scratch\jasonyacalis\olympus\sandbox\visor_ping_enemy.effect'),
};

global TargetingEffectTags:table =
{
	targetedEffect 		= TAG('objects\armor\attachments\attachment_abilities\fx\equipment_targeted_base_iff.effect'),
	lockedOnEffect 		= TAG('objects\armor\attachments\attachment_abilities\fx\equipment_locked_on_base_iff.effect'),
};

global CageCameraTags:table =
{
	globalCageDefinition 		= TAG('globals\cage_system\global.cagedefinition'),	
	mpIntroCageDefinition 		= TAG('globals\cage_system\mp_intro.cagedefinition'),
	introToHelmetScreenFX 		= TAG('fx\library_olympus\sandbox\spartans\global\spartan_helmet_transition.effect'),
	mpNarrativeCageDefinition 	= TAG('globals\cage_system\mp_narrative.cagedefinition'),
	deathCamCageDefinition 		= TAG('globals\cage_system\deathcam.cagedefinition'),
	deathCamSelectSwitchSound 	= TAG('sound\004_modes\004_mod_multiplayer\004_mod_mp_shared\004_mod_hud_mp_death_camera_switch.sound'),
};
