--
-- Damage Types
--

MeleeDamageType = ResolveString("melee");

BulletDamageType = ResolveString("bullet");

ExplosionDamageType = ResolveString("explosion");

GroundPoundDamageType = ResolveString("ground_pound");

ShoulderBashDamageType = ResolveString("shoulder_bash");

GrenadeImpactDamageType = ResolveString("grenade_impact");

CollisionDamageType = ResolveString("collision");

InstantKillDamageType = ResolveString("instant_kill");

ChargedPlasmaDamageType = ResolveString("charged_plasma");

SwordDamageType = ResolveString("sword");

BallDamageType = ResolveString("ball");
--
-- Damage Sources
--

-- Spartan Damage source (for all spartan abilities)
SpartanDamageSource = ResolveString("spartan");

-- Ball Damage Source
BallDamageSource = ResolveString("mp_ball");

-- Guardians (jump off map)
fallingDamageSource = ResolveString("teh_guardians");

-- pistols
MagnumObjectName = ResolveString("magnum");
MagnumDamageSource = ResolveString("magnum");

FlagnumObjectName = ResolveString("magnum");
FlagnumDamageSource = ResolveString("magnum_pistol_ctf");

H1MagnumObjectName = ResolveString("magnum_h1");
H1MagnumDamageSource = ResolveString("magnum_h1");

PlasmaPistolObjectName = ResolveString("plasma_pistol");
PlasmaPistolDamageSource = ResolveString("plasma_pistol")

BoltShotObjectName = ResolveString("bolt_pistol");
BoltShotDamageSource = ResolveString("bolt_pistol");

BattleRifleObjectName = ResolveString("battle_rifle");
BattleRifleDamageSource = ResolveString("battle_rifle");

H2BattleRifleObjectName = ResolveString("h2br");
H2BattleRifleDamageSource = ResolveString("battle_rifle_h2");

AssaultRifleObjectName = ResolveString("assault_rifle");
AssaultRifleDamageSource = ResolveString("assault_rifle");

SmgObjectName = ResolveString("repeater");
SmgDamageSource = ResolveString("smg");

DmrObjectName = ResolveString("dmr");
DmrDamageSource = ResolveString("dmr");

CarbineObjectName = ResolveString("covenant_carbine");
CarbineDamageSource = ResolveString("covenant_carbine");

StormRifleObjectName = ResolveString("assault_carbine");
StormRifleDamageSource = ResolveString("storm_rifle");

BrutePlasmaRifleObjectName = ResolveString("plasma_rifle");
BrutePlasmaRifleDamageSource = ResolveString("plasma_rifle");

LightRifleObjectName = ResolveString("light_rifle");
LightRifleDamageSource = ResolveString("light_rifle");

SuppressorObjectName = ResolveString("smg");
SuppressorDamageSource = ResolveString("suppressor");

SentinelBeamObjectName = ResolveString("sentinel_beam");
SentinelBeamDamageSource = ResolveString("sentinel_beam");

NeedlerObjectName = ResolveString("needler");
NeedlerDamageSource = ResolveString("needler");

--shotguns
ShotgunObjectName = ResolveString("shotgun");
ShotgunDamageSource = ResolveString("shotgun");

ScattershotObjectName = ResolveString("scattershot");
ScattershotDamageSource = ResolveString("scattershot");

-- power Weapons
RocketLauncherObjectName = ResolveString("rocket_launcher");
RocketLauncherDamageSource = ResolveString("rocket launcher");

SpnkrRocketLauncherObjectName = ResolveString("spnkr_rocket_launcher");
SpnkrRocketLauncherDamageSource = ResolveString("spnkr_rocket_launcher");

HydraObjectName = ResolveString("mlrs");
HydraDamageSource = ResolveString("hydra_launcher");

Hydra2ObjectName = ResolveString("mlrs2");
Hydra2DamageSource = ResolveString("hydra_launcher");

PlasmaCasterObjectName = ResolveString("plasma_caster");
PlasmaCasterDamageSource = ResolveString("covenant_grenade_launcher")

FuelRodObjectName = ResolveString("fuel_rod");
FuelRodDamageSource = ResolveString("fuel_rod_cannon");

RailGunObjectName = ResolveString("railgun");
RailGunDamageSource = ResolveString("rail_gun");

IncinerationCannonObjectName = ResolveString("incineration_cannon");
IncinerationCannonDamageSource = ResolveString("incineration_cannon");

SpartanLaserObjectName = ResolveString("spartan_laser");
SpartanLaserDamageSource = ResolveString("spartan_laser");

GravityHammerObjectName = ResolveString("gravity_hammer");
GravityHammerDamageSource = ResolveString("gravity_hammer");

SwordObjectName = ResolveString("energy_sword");
SwordDamageSource = ResolveString("energy_sword");
SwordObjectClassName = ResolveString("sword");

InfectedSwordObjectName = ResolveString("infected_energy_sword");

ArbiterSwordObjectName = ResolveString("energy_sword_arbiter");
ArbiterSwordDamageSource = ResolveString("energy_sword_arbiter");

SniperObjectName = ResolveString("sniper_rifle");
SniperDamageSource = ResolveString("sniper_rifle");

BeamRifleObjectName = ResolveString("beam_sniper_rifle");
BeamRifleDamageSource = ResolveString("beam_rifle");

H2BeamRifleObjectName = ResolveString("beam_rifle_h2_");
H2BeamRifleDamageSource = ResolveString("beam_rifle_h2");

BinaryRifleObjectName = ResolveString("attach_beam");
BinaryRifleDamageSource = ResolveString("binary_rifle");

SawObjectName = ResolveString("lmg");
SawDamageSource = ResolveString("saw");

GolfClubDamageSource = ResolveString("golf_club");

ReachGrenadeLauncherObjectName = ResolveString("reach_grenade_launcher");
ReachGrenadeLauncherDamageSource = ResolveString("reach_grenade_launcher");

-- Grenades
PlasmaGrenadeDamageSource = ResolveString("plasma_grenade");

FragGrenadeDamageSource = ResolveString("frag_grenade");

ForerunnerGrenadeDamageSource = ResolveString("forerunner_grenade");

--
-- Turret Damage Sources
--

ChaingunTurretDamageSource = ResolveString("turret_chaingun");

GaussTurretDamageSource = ResolveString("turret_gauss");

RocketPodTurretDamageSource = ResolveString("turret_rocket");

PlasmaTurretDamageSource = ResolveString("turret_plasma");

ShadeTurretDamageSource = ResolveString("turret_shade");

SplinterTurretDamageSource = ResolveString("turret_forerunner_beam");

JorgeChaingunTurretDamageSource = ResolveString("jorge_chaingun");

HunterArmDamageSource = ResolveString("hunter_arm");

--
-- Vehicle Damage Sources
--

BansheeDamageSource = ResolveString("banshee");

GhostDamageSource = ResolveString("ghost");

MantisDamageSource = ResolveString("mantis");

MongooseDamageSource = ResolveString("mongoose");

WaspDamageSource = ResolveString("wasp");

PhaetonDamageSource = ResolveString("vtol");

ScorpionDamageSource = ResolveString("scorpion");

WarthogDamageSource = ResolveString("warthog");

WraithDamageSource = ResolveString("wraith");

PhantomDamageSource = ResolveString("phantom");

-- Exploding thingiez damage source (Fusion Coils, exploding barrels, etc...)
DynamicPropExplosionDamageSource = ResolveString("dynamic_prop_explodable");

--Powerup names
ActiveCamoObjectName = ResolveString("active_camo");
DamageBoostObjectName = ResolveString("damage_boost");
OvershieldObjectName = ResolveString("overshield");
SpeedBoostObjectName = ResolveString("speed_boost");

--
-- Generic Object Name (this is used for triggering the generic weapon pad events)
--

GenericObjectName = ResolveString("generic");

--
-- Weapon Sets
--

PowerWeaponNames = 
{
	ArbiterSwordObjectName,
	BeamRifleObjectName,
	H2BeamRifleObjectName,
	BinaryRifleObjectName,
	FuelRodObjectName,
	PlasmaCasterObjectName,
	GravityHammerObjectName,
	HydraObjectName,
	Hydra2ObjectName,
	H1MagnumObjectName,
	IncinerationCannonObjectName,
	RailGunObjectName,
	RocketLauncherObjectName,
	SawObjectName,
	ScattershotObjectName,
	ShotgunObjectName,
	SniperObjectName,
	SpartanLaserObjectName,
	SpnkrRocketLauncherObjectName,
	SwordObjectName,
	InfectedSwordObjectName,
	ReachGrenadeLauncherObjectName
};

PowerWeaponDamageSources = 
{
	ArbiterSwordDamageSource,
	BeamRifleDamageSource,
	H2BeamRifleDamageSource,
	BinaryRifleDamageSource,
	FuelRodDamageSource,
	PlasmaCasterDamageSource,
	GravityHammerDamageSource,
	HydraDamageSource,
	H1MagnumDamageSource,
	IncinerationCannonDamageSource,
	RailGunDamageSource,
	RocketLauncherDamageSource,
	SawDamageSource,
	ScattershotDamageSource,
	ShotgunDamageSource,
	SniperDamageSource,
	SpartanLaserDamageSource,
	SpnkrRocketLauncherDamageSource,
	SwordDamageSource,
	GolfClubDamageSource, 
	ReachGrenadeLauncherDamageSource
};

NonPowerWeaponNames = 
{
	AssaultRifleObjectName,
	BattleRifleObjectName,
	H2BattleRifleObjectName,
	BoltShotObjectName,
	CarbineObjectName,
	DmrObjectName,
	FlagnumObjectName,
	LightRifleObjectName,
	MagnumObjectName,
	NeedlerObjectName,
	PlasmaPistolObjectName,
	SmgObjectName,
	StormRifleObjectName,
	BrutePlasmaRifleObjectName,
	SuppressorObjectName,
	SentinelBeamObjectName
};

NonPowerWeaponDamageSources =
{
	AssaultRifleDamageSource,
	BallDamageSource,
	BattleRifleDamageSource,
	H2BattleRifleDamageSource,
	BoltShotDamageSource,
	CarbineDamageSource,
	DmrDamageSource,
	FlagnumDamageSource,
	LightRifleDamageSource,
	MagnumDamageSource,
	NeedlerDamageSource,
	PlasmaPistolDamageSource,
	SmgDamageSource,
	StormRifleDamageSource,
	BrutePlasmaRifleDamageSource,
	SuppressorDamageSource,
	SentinelBeamDamageSource
};

EnergyWeaponNames = 
{
	BeamRifleObjectName,
	H2BeamRifleObjectName,
	IncinerationCannonObjectName,
	PlasmaPistolObjectName,
	SpartanLaserObjectName,
	StormRifleObjectName,
	BrutePlasmaRifleObjectName, 
	SentinelBeamObjectName
}

EnergyWeaponDamageSources = 
{
	BeamRifleDamageSource,
	H2BeamRifleDamageSource,
	IncinerationCannonDamageSource,
	PlasmaPistolDamageSource,
	SpartanLaserDamageSource,
	StormRifleDamageSource,
	BrutePlasmaRifleDamageSource,
	SentinelBeamDamageSource
}

SniperDamageSources = 
{
	BeamRifleDamageSource,
	H2BeamRifleDamageSource,
	SniperDamageSource
};

SwordDamageSources = 
{
	SwordDamageSource,
	ArbiterSwordDamageSource
};

GrenadeDamageSources = 
{
	ForerunnerGrenadeDamageSource,
	FragGrenadeDamageSource,
	PlasmaGrenadeDamageSource
};

HeadshotWeaponDamageSources = 
{
	BattleRifleDamageSource,
	H1MagnumDamageSource,
	H2BattleRifleDamageSource,
	BeamRifleDamageSource,
	H2BeamRifleDamageSource,
	CarbineDamageSource,
	DmrDamageSource,
	FlagnumDamageSource,
	LightRifleDamageSource,
	MagnumDamageSource,
	SniperDamageSource
};

NonSniperHeadshotDamageSoures = 
{
	BattleRifleDamageSource,
	H1MagnumDamageSource,
	H2BattleRifleDamageSource,
	CarbineDamageSource,
	DmrDamageSource,
	FlagnumDamageSource,
	LightRifleDamageSource,
	MagnumDamageSource,
};

AutomaticWeaponDamageSources =
{
	AssaultRifleDamageSource,
	SawDamageSource,
	SmgDamageSource,
	StormRifleDamageSource,
	BrutePlasmaRifleDamageSource,
	SuppressorDamageSource,
};

RocketWeaponDamageSources =
{
	RocketLauncherDamageSource,
	SpnkrRocketLauncherDamageSource,
};

BeamRifleDamageSources =
{
	BeamRifleDamageSource,
	H2BeamRifleDamageSource,
};

AllTurretDamageSources = 
{
	ChaingunTurretDamageSource,
	GaussTurretDamageSource,
	RocketPodTurretDamageSource,
	PlasmaTurretDamageSource,
	ShadeTurretDamageSource,
	SplinterTurretDamageSource,
	JorgeChaingunTurretDamageSource,
	HunterArmDamageSource
};

AllVehicleDamageSources = 
{
	BansheeDamageSource,
	GhostDamageSource,
	MantisDamageSource,
	MongooseDamageSource,
	WaspDamageSource,
	PhaetonDamageSource,
	ScorpionDamageSource,
	WarthogDamageSource,
	WraithDamageSource,
	PhantomDamageSource
}

LandVehicleDamageSources = 
{
	GhostDamageSource,
	MantisDamageSource,
	MongooseDamageSource,
	ScorpionDamageSource,
	WarthogDamageSource,
	WraithDamageSource
}

AirVehicleDamageSources = 
{
	BansheeDamageSource,
	PhaetonDamageSource,
	PhantomDamageSource,
	WaspDamageSource,
}

--
-- Killfeed damage source/type lists
--

WeaponPadObjectName_stringIndex = 1;
WeaponPadObjectName_objectNameIndex = 2;

-- need to add ALL weapons to this table as it is used to define Weapon Pad Events
WeaponPadObjectNames = 
{
	{"assaultrifle", 		AssaultRifleObjectName},
	{"arbitersword",    	ArbiterSwordObjectName},
	{"battlerifle", 		BattleRifleObjectName},
	{"battlerifle",			H2BattleRifleObjectName},
	{"beamrifle", 			BeamRifleObjectName},
	{"beamrifle",			H2BeamRifleObjectName},
	{"binaryrifle", 		BinaryRifleObjectName},
	{"boltshot", 			BoltShotObjectName},
	{"carbine", 			CarbineObjectName},
	{"dmr", 				DmrObjectName},
	{"fuelrod", 			FuelRodObjectName},
	{"hydra",    			HydraObjectName},
	{"hydra2",    			Hydra2ObjectName},
	{"incinerationcannon",  IncinerationCannonObjectName},
	{"lightrifle", 			LightRifleObjectName},
	{"magnum",				MagnumObjectName},
	{"magnum",				H1MagnumObjectName},
	{"needler", 			NeedlerObjectName},
	{"plasmacaster", 		PlasmaCasterObjectName},
	{"plasmapistol", 		PlasmaPistolObjectName},
	{"railgun", 			RailGunObjectName},
	{"rocketlauncher",		RocketLauncherObjectName},
	{"rocketlauncher",		SpnkrRocketLauncherObjectName},
	{"saw", 				SawObjectName},
	{"reachgrenade",		ReachGrenadeLauncherObjectName},
	{"scattershot", 		ScattershotObjectName},
	{"shotgun",				ShotgunObjectName},
	{"smg", 				SmgObjectName},
	{"sniperrifle",     	SniperObjectName},
	{"spartanlaser", 		SpartanLaserObjectName},
	{"stormrifle", 			StormRifleObjectName},
	{"bruteplasma",			BrutePlasmaRifleObjectName},
	{"suppressor", 			SuppressorObjectName},
	{"sentinelbeam",		SentinelBeamObjectName},
	{"energysword", 		SwordObjectName},
	{"infectedsword",		InfectedSwordObjectName},
	{"generic", 			GenericObjectName},
	--powerups
	{"activecamo",			ActiveCamoObjectName},
	{"overshield",			OvershieldObjectName},
	{"damageboost",			DamageBoostObjectName},
	{"speedboost",			SpeedBoostObjectName}
};

KillFeedItemReference_sourceIndex = 1;
KillFeedItemReference_refIndex = 2;

KillFeedItemReferenceDamageSources = 
{
	-- Power Weapons
	{ArbiterSwordDamageSource,			"arbiter_sword"},
	{BinaryRifleDamageSource,			"binary_rifle"},
	{BeamRifleDamageSource,				"beam_rifle"},
	{H2BeamRifleDamageSource,			"beam_rifle_h2"},
	{FuelRodDamageSource,				"fuel_rod_cannon"},
	{GravityHammerDamageSource,			"gravity_hammer"},
	{HydraDamageSource,					"hydra"},
	{H1MagnumDamageSource,				"magnum_h1"},
	{IncinerationCannonDamageSource,	"incineration_cannon"},
	{PlasmaCasterDamageSource, 			"plasma_caster"},
	{RailGunDamageSource,				"rail_gun"},
	{RocketLauncherDamageSource,		"rocket_launcher"},
	{SpnkrRocketLauncherDamageSource,	"spnkr_rocket_launcher"},
	{ScattershotDamageSource,			"scattershot"},
	{ShotgunDamageSource,				"shotgun"},
	{SniperDamageSource,				"sniper"},
	{SpartanLaserDamageSource,			"spartan_laser"},
	{SwordDamageSource,					"sword"},
	{SawDamageSource,					"saw"},
	{ReachGrenadeLauncherDamageSource,  "reachgrenade"},
	{GolfClubDamageSource,				"golf_club"},
	-- Non Power Weapons
	{AssaultRifleDamageSource,			"assault_rifle"},
	{BallDamageSource,					"ball"},
	{BattleRifleDamageSource,			"battle_rifle"},
	{H2BattleRifleDamageSource,			"battle_rifle_h2"},
	{BoltShotDamageSource,				"bolt_shot"},
	{CarbineDamageSource,				"carbine"},
	{DmrDamageSource,					"dmr"},
	{FlagnumDamageSource,				"flagnum"},
	{LightRifleDamageSource,			"light_rifle"},
	{MagnumDamageSource,				"magnum"},
	{NeedlerDamageSource,				"needler"},
	{PlasmaPistolDamageSource,			"plasma_pistol"},
	{SmgDamageSource,					"smg"},
	{StormRifleDamageSource,			"storm_rifle"},
	{BrutePlasmaRifleDamageSource,		"plasma_rifle_h2"},
	{SuppressorDamageSource,			"suppressor"},
	{SentinelBeamDamageSource, 			"sentinel_beam"},
	-- Grenades	
	{ForerunnerGrenadeDamageSource,		"forerunner_grenade"},
	{FragGrenadeDamageSource,			"frag_grenade"},
	{PlasmaGrenadeDamageSource,			"plasma_grenade"},
	-- Vehicles
	{BansheeDamageSource,				"banshee"},
	{GhostDamageSource, 				"ghost"},
	{MantisDamageSource,				"mantis"},
	{MongooseDamageSource,				"mongoose"},
	{WaspDamageSource,					"wasp"},
	{PhaetonDamageSource,				"phaeton"},
	{ScorpionDamageSource,				"scorpion"},
	{WarthogDamageSource,				"warthog"},
	{WraithDamageSource,				"wraith"},
	-- Turrets
	{ChaingunTurretDamageSource,		"chain_gun_turret"},
	{GaussTurretDamageSource,			"gauss_turret"},
	{RocketPodTurretDamageSource,		"rocket_pod_turret"},
	{PlasmaTurretDamageSource,			"plasma_turret"},
	{ShadeTurretDamageSource,			"shade_turret"},
	{SplinterTurretDamageSource,		"splinter_turret"},
	{JorgeChaingunTurretDamageSource,	"jorges_chaingun"},
	{HunterArmDamageSource,				"hunterarm"},
	-- Fusion Coils, exploding barrels, etc...
	{DynamicPropExplosionDamageSource,  "explosion"}
};

KillFeedItemReferenceDamageTypes = 
{
	{MeleeDamageType,					"melee"},
	{GroundPoundDamageType,				"ground_pound"},
	{ShoulderBashDamageType,			"shoulder_bash"},
	{SwordDamageType,					"sword"},
	{BallDamageType,					"ball"}
}