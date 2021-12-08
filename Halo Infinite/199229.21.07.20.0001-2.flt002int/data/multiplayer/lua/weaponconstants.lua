--Copyright (c) Microsoft. All rights reserved.

--## SERVER

-- //////////////////////////////
-- //////// DAMAGE TYPES ////////
-- //////////////////////////////	

	global MeleeDamageType = Engine_ResolveStringId("melee");

	global BulletDamageType = Engine_ResolveStringId("bullet");						-- kinetic weapons (UNSC rifles, Banished spike guns)

	global ExplosionDamageType = Engine_ResolveStringId("explosion");
	
	global ExplosiveDamageType = Engine_ResolveStringId("explosive");
	
	global PlasmaSweetHeatDamageType = Engine_ResolveStringId("plasma_sweetheat");	-- Powerful, red plasma that overheats quickly (Stalker Rifle)
	
	global PlasmaNoBurnDamageType = Engine_ResolveStringId("plasma_no_burn");		-- Default plasma weapon damage (Pulse Carbine, Plasma Pistol normal shot)

	global PlasmaExplosionDamageType = Engine_ResolveStringId("plasma_explosion");

	global PlasmaExplosionHeavyDamageType = Engine_ResolveStringId("plasma_explosion_heavy");

	global GrenadeImpactDamageType = Engine_ResolveStringId("grenade_impact");		-- Physical damage from hitting someone with a grenade (no explosion)

	global CollisionDamageType = Engine_ResolveStringId("collision");

	global InstantKillDamageType = Engine_ResolveStringId("instant_kill");

	global ChargedPlasmaDamageType = Engine_ResolveStringId("plasma_charged");		-- Plasma pistol's charged blast

	global SwordDamageType = Engine_ResolveStringId("sword");

	global BallDamageType = Engine_ResolveStringId("ball");

	global ChopperWheelDamageType = Engine_ResolveStringId("kinetic");

	global ShockDamageType = Engine_ResolveStringId("shock");

	global ShockStrongDamageType = Engine_ResolveStringId("shock_strong");

	global HighImpactDamageType = Engine_ResolveStringId("high_impact");

-- //////////////////////////////
-- //////// DAMAGE SOURCES //////
-- //////// & OBJECT NAMES //////
-- //////////////////////////////	

	-- WEAPONS: Assault Rifles
		global MA40ARObjectName = Engine_ResolveStringId("assault_rifle");
		global MA40ARDamageSource = Engine_ResolveStringId("assault_rifle");
	
		global PulseCarbineObjectName = Engine_ResolveStringId("wetwork");
		global PulseCarbineDamageSource = Engine_ResolveStringId("wetwork");

	-- WEAPONS: Launchers
		global CindershotObjectName = Engine_ResolveStringId("heatwave");
		global CindershotDamageSource = Engine_ResolveStringId("heatwave");

		global HydraObjectName = Engine_ResolveStringId("mlrs");
		global HydraDamageSource = Engine_ResolveStringId("hydra_launcher");

		global M41SPNKrObjectName = Engine_ResolveStringId("spnkr_rocket_launcher");
		global M41SPNKrDamageSource = Engine_ResolveStringId("spnkr_rocket_launcher_olympus");

		global RavagerObjectName = Engine_ResolveStringId("slag_maker");
		global RavagerDamageSource = Engine_ResolveStringId("slag_maker");

	-- WEAPONS: Melee
		global EnergySwordObjectName = Engine_ResolveStringId("energy_sword");
		global EnergySwordDamageSource = Engine_ResolveStringId("energy_sword");

		global GravityHammerObjectName = Engine_ResolveStringId("gravity_hammer");
		global GravityHammerDamageSource = Engine_ResolveStringId("gravity_hammer");

		global FlagMeleeDamageSource = Engine_ResolveStringId("magnum_pistol_ctf");
		global OddballMeleeDamageSource = Engine_ResolveStringId("mp_ball");

	-- WEAPONS: Pistols
		global DisruptorObjectName = Engine_ResolveStringId("arc_zapper");
		global DisruptorDamageSource = Engine_ResolveStringId("arc_zapper");

		global ManglerObjectName = Engine_ResolveStringId("spike_revolver");
		global ManglerDamageSource = Engine_ResolveStringId("spike_revolver");

		global Mk50SidekickObjectName = Engine_ResolveStringId("sidearm_pistol");
		global Mk50SidekickDamageSource = Engine_ResolveStringId("sidearm_pistol");

		global PlasmaPistolObjectName = Engine_ResolveStringId("plasma_pistol");
		global PlasmaPistolDamageSource = Engine_ResolveStringId("plasma_pistol");

	-- WEAPONS: Shotguns
		global CQS48BulldogObjectName = Engine_ResolveStringId("combat_shotgun");
		global CQS48BulldogDamageSource = Engine_ResolveStringId("combat_shotgun");

		global HeatwaveObjectName = Engine_ResolveStringId("hotrod");
		global HeatwaveDamageSource = Engine_ResolveStringId("hotrod");

	-- WEAPONS: SMGs
		global NeedlerObjectName = Engine_ResolveStringId("needler");
		global NeedlerDamageSource = Engine_ResolveStringId("needler");

		global SentinelBeamObjectName = Engine_ResolveStringId("sentinel_beam");
		global SentinelBeamDamageSource = Engine_ResolveStringId("sentinel_beam");
	
	-- WEAPONS: Tactical Rifles
		global BR75ObjectName = Engine_ResolveStringId("battle_rifle");
		global BR75DamageSource = Engine_ResolveStringId("battle_rifle");

		global VK78CommandoObjectName = Engine_ResolveStringId("commando_rifle");
		global VK78CommandoDamageSource = Engine_ResolveStringId("commando_rifle");

	-- WEAPONS: Sniper Rifles
		global S7SniperObjectName = Engine_ResolveStringId("sniper_rifle");
		global S7SniperDamageSource = Engine_ResolveStringId("sniper_rifle");

		global ShockRifleObjectName = Engine_ResolveStringId("volt_action");
		global ShockRifleDamageSource = Engine_ResolveStringId("volt_action");

		global SkewerObjectName = Engine_ResolveStringId("skewer");
		global SkewerDamageSource = Engine_ResolveStringId("skewer");

		global StalkerRifleObjectName = Engine_ResolveStringId("plasma_blaster");
		global StalkerRifleDamageSource = Engine_ResolveStringId("plasma_blaster");
	
	-- WEAPONS: Misc.
		global BallDamageSource = Engine_ResolveStringId("mp_ball");
		global SpartanDamageSource = Engine_ResolveStringId("spartan");	-- Spartan Damage source (for all spartan abilities)

	-- EQUIPMENT
		global ActiveCamoObjectName = Engine_ResolveStringId("active_camo");
		global DropWallObjectName = Engine_ResolveStringId("wall");
		global GrappleshotObjectName = Engine_ResolveStringId("grapple");
		global OvershieldObjectName = Engine_ResolveStringId("overshield");	
		global RepulsorObjectName = Engine_ResolveStringId("knockback");
		global RepulsorDamageSource = Engine_ResolveStringId("knockback");
		global ThreatSensorObjectName = Engine_ResolveStringId("loc_sensor");
		global ThrusterObjectName = Engine_ResolveStringId("evade");

	-- GRENADES
		global DynamoGrenadeObjectName = Engine_ResolveStringId("lightning_grenade");
		global FragGrenadeObjectName = Engine_ResolveStringId("frag_grenade");	
		global PlasmaGrenadeObjectName = Engine_ResolveStringId("plasma_grenade");
		global SpikeGrenadeObjectName = Engine_ResolveStringId("spike_grenade");


	-- GRENADES DAMAGE SOURCES
		global DynamoGrenadeDamageSource = Engine_ResolveStringId("proto_lightning_grenade");
		global FragGrenadeDamageSource = Engine_ResolveStringId("frag_grenade");	
		global PlasmaGrenadeDamageSource = Engine_ResolveStringId("plasma_grenade");
		global SpikeGrenadeDamageSource = Engine_ResolveStringId("spike_grenade");

	-- TURRETS
		global M247HmgDamageSource = Engine_ResolveStringId("turret_chaingun");
		global PlasmaCannonDamageSource = Engine_ResolveStringId("turret_plasma");
		global ScrapCannonDamageSource = Engine_ResolveStringId("gatling_mortar");
		global ShadeTurretDamageSource = Engine_ResolveStringId("turret_shade_plasma");

		global M247HmgObjectName = Engine_ResolveStringId("machine_gun");
		global PlasmaCannonObjectName = Engine_ResolveStringId("plasma_turret");
		global ScapCannonObjectName = Engine_ResolveStringId("gatling_mortar");
		global ShadeTurretObjectName = Engine_ResolveStringId("shade_turret");

	-- VEHICLES
		global BansheeDamageSource = Engine_ResolveStringId("banshee");
		global ChopperDamageSource = Engine_ResolveStringId("chopper");
		global GhostDamageSource = Engine_ResolveStringId("ghost");
		global MongooseDamageSource = Engine_ResolveStringId("mongoose");		
		global ScorpionDamageSource = Engine_ResolveStringId("scorpion");
		global WarthogDamageSource = Engine_ResolveStringId("warthog");
		global WaspDamageSource = Engine_ResolveStringId("wasp");
		global WraithDamageSource = Engine_ResolveStringId("wraith");
		global RocketHogDamageSource = Engine_ResolveStringId("mantis");

		global GunGooseVariantName = Engine_ResolveStringId("gun_goose");
		global RocketWarthogVariantName = Engine_ResolveStringId("rocket");
		global RazorbackVariantName = Engine_ResolveStringId("unarmed");

		global GunGooseObjectName = Engine_ResolveStringId("gungoose");
		global RocketWarthogObjectName = Engine_ResolveStringId("rockethog");
		global RazorbackObjectName = Engine_ResolveStringId("razorbackhog");

	-- Fusion Coils, exploding barrels, etc...
		global FusionCoilDamageSource = Engine_ResolveStringId("fusion_coil");

		global FusionCoilKineticVariant = Engine_ResolveStringId("banished_kinetic");
		global FusionCoilHardlightVariant = Engine_ResolveStringId("banished_hardlight");
		global FusionCoilPlasmaVariant = Engine_ResolveStringId("banished_plasma");
		global FusionCoilShockVariant = Engine_ResolveStringId("banished_shock");

	-- Guardians (jump off map)
		global fallingDamageSource = Engine_ResolveStringId("teh_guardians");

-- //////////////////////////////
-- ///////// ITEM SETS //////////
-- //////////////////////////////	
	
	global AllWeaponDamageSources = -- All weapons 
	{
		BR75DamageSource,
		CindershotDamageSource,
		CQS48BulldogDamageSource,
		DisruptorDamageSource,
		EnergySwordDamageSource,
		GravityHammerDamageSource,
		HeatwaveDamageSource,
		HydraDamageSource,
		M41SPNKrDamageSource,
		MA40ARDamageSource,
		ManglerDamageSource,
		Mk50SidekickDamageSource,
		NeedlerDamageSource,
		PlasmaPistolDamageSource,
		PulseCarbineDamageSource,
		RavagerDamageSource,
		S7SniperDamageSource,
		SentinelBeamDamageSource,
		ShockRifleDamageSource,
		SkewerDamageSource,
		StalkerRifleDamageSource,
		VK78CommandoDamageSource,
	};

	-- WEAPON CLASS SETS (Weapon groupings that seperate weapons by behavior)
		global AssaultRifleWeaponRoleDamageSources = -- Automatic or burst fire, faster rate of fire or bursts, mid-range
		{
			MA40ARDamageSource,
			PulseCarbineDamageSource
		};

		global LauncherWeaponRoleDamageSources = -- Area of effect, disruptive/high physics impulse
		{
			CindershotDamageSource,
			HydraDamageSource, 
			M41SPNKrDamageSource,
			RavagerDamageSource
		};

		global MeleeWeaponRoleDamageSources = -- Close quarters, high damage
		{
			EnergySwordDamageSource,
			GravityHammerDamageSource
		};

		global PistolWeaponRoleDamageSources = -- Quick equip time, versatile/specialized
		{
			DisruptorDamageSource,
			ManglerDamageSource,
			Mk50SidekickDamageSource,
			PlasmaPistolDamageSource
		};

		global ShotgunWeaponRoleDamageSources = -- Multiple projectiles, shorter range
		{
			CQS48BulldogDamageSource,
			HeatwaveDamageSource
		};

		global SMGWeaponRoleDamageSources = -- Automatic, faster rate of fire, shorter range 
		{
			NeedlerDamageSource,
			SentinelBeamDamageSource
		};

		global SniperRifleWeaponRoleDamageSources = -- Semi auto/breach load, 2 level zoom optic, long range
		{
			S7SniperDamageSource,
			ShockRifleDamageSource,
			SkewerDamageSource,
			StalkerRifleDamageSource
		};

		global TacticalRifleWeaponRoleDamageSources = -- Accurate, slower rate of fire or semi-auto/burst, mid-long range
		{
			BR75DamageSource,
			VK78CommandoDamageSource
		};

		global AntiVehicleWeaponClassDamageSources = -- Weapons from the Assault, Precision, and CQC classes that are intended to be direct counters to vehicles
		{
			DisruptorDamageSource, 
			HydraDamageSource,
			M41SPNKrDamageSource,
			ShockRifleDamageSource
		};

	-- WEAPON TIER SETS (MP's weapon groupings that seperate weapons by power)
		global BaseTierWeaponDamageSources = 
		{
			BR75DamageSource,
			CQS48BulldogDamageSource,
			DisruptorDamageSource,
			HeatwaveDamageSource,
			HydraDamageSource,
			MA40ARDamageSource,
			ManglerDamageSource,
			Mk50SidekickDamageSource,
			NeedlerDamageSource,
			PlasmaPistolDamageSource,
			PulseCarbineDamageSource,
			RavagerDamageSource,
			SentinelBeamDamageSource,
			ShockRifleDamageSource,
			StalkerRifleDamageSource,
			VK78CommandoDamageSource,
		};

		global PowerWeaponTierDamageSources = -- One-shot machines that create temporary power shifts
		{
			CindershotDamageSource,
			EnergySwordDamageSource,
			GravityHammerDamageSource,
			M41SPNKrDamageSource,
			S7SniperDamageSource,
			SkewerDamageSource
		};

	-- MISC. WEAPON SETS
		global EnergyWeaponDamageSources = 
		{
			PlasmaPistolDamageSource,
			PulseCarbineDamageSource,
			RavagerDamageSource,
			SentinelBeamDamageSource, 
			StalkerRifleDamageSource
		};

		global PowerSniperDamageSources = -- Sniper Rifles that can kill a player with a single shot to the head
		{
			S7SniperDamageSource,
			SkewerDamageSource
		};

		global RemoteDetonationDamageSources = -- Weapons that detonate grenades
		{
			BR75DamageSource,
			EnergySwordDamageSource,
			GravityHammerDamageSource,
			HydraDamageSource,
			M41SPNKrDamageSource,
			ManglerDamageSource,
			Mk50SidekickDamageSource,
			S7SniperDamageSource,
			ShockRifleDamageSource,
			SkewerDamageSource,
			StalkerRifleDamageSource,
			VK78CommandoDamageSource,
		};

		global RicochetDamageSources = -- Weapons with projectiles that can bounce off of surfaces. Launchers are omitted to prevent awarding Bank Shot for easy bounces.
		{
			HeatwaveDamageSource
		};

		global ShockDamageSources =
		{
			DisruptorDamageSource,
			DynamoGrenadeDamageSource,
			ShockRifleDamageSource,
		};

	-- GRENADE SETS
		global GrenadeDamageSources = 
		{
			DynamoGrenadeDamageSource,
			FragGrenadeDamageSource,
			PlasmaGrenadeDamageSource,
			SpikeGrenadeDamageSource
		};

		global GrenadeDamageTypes = 
		{
			ExplosionDamageType,
			PlasmaExplosionDamageType,
			PlasmaExplosionHeavyDamageType,
		};

	-- TURRET SETS
		global AllTurretDamageSources = 
		{
			M247HmgDamageSource,
			PlasmaCannonDamageSource,
			ShadeTurretDamageSource,
			ScrapCannonDamageSource
		};

	-- VEHICLE SETS
		global AllVehicleDamageSources = 
		{
			BansheeDamageSource,
			ChopperDamageSource,
			GhostDamageSource,
			MongooseDamageSource,
			RocketHogDamageSource,
			ScorpionDamageSource,
			WarthogDamageSource,
			WaspDamageSource,
			WraithDamageSource
		};

		global LandVehicleDamageSources = 
		{
			GhostDamageSource,
			MongooseDamageSource,
			ScorpionDamageSource,
			WarthogDamageSource,
			WraithDamageSource
		};

		global AirVehicleDamageSources = 
		{
			BansheeDamageSource,
			WaspDamageSource
		};

		global NonTankLandVehicleDamageSources = 
		{
			ChopperDamageSource,
			GhostDamageSource,
			MongooseDamageSource,
			WarthogDamageSource
		};

		global TankVehicleDamageSources = 
		{
			ScorpionDamageSource,
			WraithDamageSource
		};
