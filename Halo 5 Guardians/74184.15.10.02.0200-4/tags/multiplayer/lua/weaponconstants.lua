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

--
-- Damage Sources
--

-- Spartan Damage source (for all spartan abilities)
SpartanDamageSource = ResolveString("spartan");

-- Guardians (jump off map)
fallingDamageSource = ResolveString("teh_guardians");

-- pistols
MagnumObjectName = ResolveString("magnum");
MagnumDamageSource = ResolveString("magnum");

FlagnumObjectName = ResolveString("magnum");
FlagnumDamageSource = ResolveString("magnum_pistol_ctf");

PlasmaPistolObjectName = ResolveString("plasma_pistol");
PlasmaPistolDamageSource = ResolveString("plasma_pistol")

BoltShotObjectName = ResolveString("bolt_pistol");
BoltShotDamageSource = ResolveString("bolt_pistol");

BattleRifleObjectName = ResolveString("battle_rifle");
BattleRifleDamageSource = ResolveString("battle_rifle");

AssaultRifleObjectName = ResolveString("assault_rifle");
AssaultRifleDamageSource = ResolveString("assault_rifle");

SmgObjectName = ResolveString("repeater");
SmgDamageSource = ResolveString("smg");

DmrObjectName = ResolveString("dmr");
DmrDamageSource = ResolveString("dmr");

CarbineObjectName = ResolveString("covenant_carbine");
CarbineDamageSource = ResolveString("covenant_carbine");

StormRifleObjectName = ResolveString("assault_carbine");
StormRifleDamageSource = ResolveString("storm_rifle")

LightRifleObjectName = ResolveString("light_rifle");
LightRifleDamageSource = ResolveString("light_rifle");

SuppressorObjectName = ResolveString("smg");
SuppressorDamageSource = ResolveString("suppressor");

NeedlerObjectName = ResolveString("needler");
NeedlerDamageSource = ResolveString("needler");

--shotguns
ShotgunObjectName = ResolveString("shotgun");
ShotgunDamageSource = ResolveString("shotgun");

ScattershotObjectName = ResolveString("spread_gun");
ScattershotDamageSource = ResolveString("scattershot");

-- power Weapons
RocketLauncherObjectName = ResolveString("rocket_launcher");
RocketLauncherDamageSource = ResolveString("rocket launcher");

HydraObjectName = ResolveString("mlrs");
HydraDamageSource = ResolveString("hydra_launcher");

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

SwordObjectName = ResolveString("energy_sword");
SwordDamageSource = ResolveString("energy_sword");
SwordObjectClassName = ResolveString("sword");

ArbiterSwordObjectName = ResolveString("energy_sword_arbiter");
ArbiterSwordDamageSource = ResolveString("energy_sword_arbiter");

SniperObjectName = ResolveString("sniper_rifle");
SniperDamageSource = ResolveString("sniper_rifle");

BeamRifleObjectName = ResolveString("beam_sniper_rifle");
BeamRifleDamageSource = ResolveString("beam_rifle");

BinaryRifleObjectName = ResolveString("attach_beam");
BinaryRifleDamageSource = ResolveString("binary_rifle");

SawObjectName = ResolveString("lmg");
SawDamageSource = ResolveString("saw");

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

--
-- Vehicle Damage Sources
--

BansheeDamageSource = ResolveString("banshee");

GhostDamageSource = ResolveString("ghost");

MantisDamageSource = ResolveString("mantis");

MongooseDamageSource = ResolveString("mongoose");

PhaetonDamageSource = ResolveString("vtol");

ScorpionDamageSource = ResolveString("scorpion");

WarthogDamageSource = ResolveString("warthog");

WraithDamageSource = ResolveString("wraith");

PhantomDamageSource = ResolveString("phantom");

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
	BinaryRifleObjectName,
	FuelRodObjectName,
	PlasmaCasterObjectName,
	HydraObjectName,
	IncinerationCannonObjectName,
	RailGunObjectName,
	RocketLauncherObjectName,
	SawObjectName,
	ScattershotObjectName,
	ShotgunObjectName,
	SniperObjectName,
	SpartanLaserObjectName,
	SwordObjectName
};

PowerWeaponDamageSources = 
{
	ArbiterSwordDamageSource,
	BeamRifleDamageSource,
	BinaryRifleDamageSource,
	FuelRodDamageSource,
	PlasmaCasterDamageSource,
	HydraDamageSource,
	IncinerationCannonDamageSource,
	RailGunDamageSource,
	RocketLauncherDamageSource,
	SawDamageSource,
	ScattershotDamageSource,
	ShotgunDamageSource,
	SniperDamageSource,
	SpartanLaserDamageSource,
	SwordDamageSource
};

NonPowerWeaponNames = 
{
	AssaultRifleObjectName,
	BattleRifleObjectName,
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
	SuppressorObjectName
};

NonPowerWeaponDamageSources =
{
	AssaultRifleDamageSource,
	BattleRifleDamageSource,
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
	SuppressorDamageSource
};

EnergyWeaponNames = 
{
	BeamRifleObjectName,
	IncinerationCannonObjectName,
	PlasmaPistolObjectName,
	SpartanLaserObjectName,
	StormRifleObjectName
}

EnergyWeaponDamageSources = 
{
	BeamRifleDamageSource,
	IncinerationCannonDamageSource,
	PlasmaPistolDamageSource,
	SpartanLaserDamageSource,
	StormRifleDamageSource
}

SniperDamageSources = 
{
	BeamRifleDamageSource,
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
	BeamRifleDamageSource,
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
	SuppressorDamageSource,
};

AllTurretDamageSources = 
{
	ChaingunTurretDamageSource,
	GaussTurretDamageSource,
	RocketPodTurretDamageSource,
	PlasmaTurretDamageSource,
	ShadeTurretDamageSource,
	SplinterTurretDamageSource
};

AllVehicleDamageSources = 
{
	BansheeDamageSource,
	GhostDamageSource,
	MantisDamageSource,
	MongooseDamageSource,
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
	PhantomDamageSource
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
	{"beamrifle", 			BeamRifleObjectName},
	{"binaryrifle", 		BinaryRifleObjectName},
	{"boltshot", 			BoltShotObjectName},
	{"carbine", 			CarbineObjectName},
	{"dmr", 				DmrObjectName},
	{"fuelrod", 			FuelRodObjectName},
	{"hydra",    			HydraObjectName},
	{"incinerationcannon",  IncinerationCannonObjectName},
	{"lightrifle", 			LightRifleObjectName},
	{"magnum",				MagnumObjectName},
	{"needler", 			NeedlerObjectName},
	{"plasmacaster", 		PlasmaCasterObjectName},
	{"plasmapistol", 		PlasmaPistolObjectName},
	{"railgun", 			RailGunObjectName},
	{"rocketlauncher",		RocketLauncherObjectName},
	{"saw", 				SawObjectName},
	{"scattershot", 		ScattershotObjectName},
	{"shotgun",				ShotgunObjectName},
	{"smg", 				SmgObjectName},
	{"sniperrifle",     	SniperObjectName},
	{"spartanlaser", 		SpartanLaserObjectName},
	{"stormrifle", 			StormRifleObjectName},
	{"suppressor", 			SuppressorObjectName},
	{"energysword", 		SwordObjectName},
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
	{FuelRodDamageSource,				"fuel_rod_cannon"},
	{HydraDamageSource,					"hydra"},
	{IncinerationCannonDamageSource,	"incineration_cannon"},
	{PlasmaCasterDamageSource, 			"plasma_caster"},
	{RailGunDamageSource,				"rail_gun"},
	{RocketLauncherDamageSource,		"rocket_launcher"},
	{ScattershotDamageSource,			"scattershot"},
	{ShotgunDamageSource,				"shotgun"},
	{SniperDamageSource,				"sniper"},
	{SpartanLaserDamageSource,			"spartan_laser"},
	{SwordDamageSource,					"sword"},
	-- Non Power Weapons
	{AssaultRifleDamageSource,			"assault_rifle"},
	{BattleRifleDamageSource,			"battle_rifle"},
	{BoltShotDamageSource,				"bolt_shot"},
	{CarbineDamageSource,				"carbine"},
	{DmrDamageSource,					"dmr"},
	{FlagnumDamageSource,				"flagnum"},
	{LightRifleDamageSource,			"light_rifle"},
	{MagnumDamageSource,				"magnum"},
	{NeedlerDamageSource,				"needler"},
	{PlasmaPistolDamageSource,			"plasma_pistol"},
	{SawDamageSource,					"saw"},
	{SmgDamageSource,					"smg"},
	{StormRifleDamageSource,			"storm_rifle"},
	{SuppressorDamageSource,			"suppressor"},
	-- Grenades	
	{ForerunnerGrenadeDamageSource,		"forerunner_grenade"},
	{FragGrenadeDamageSource,			"frag_grenade"},
	{PlasmaGrenadeDamageSource,			"plasma_grenade"},
	-- Vehicles
	{BansheeDamageSource,				"banshee"},
	{GhostDamageSource, 				"ghost"},
	{MantisDamageSource,				"mantis"},
	{MongooseDamageSource,				"mongoose"},
	{PhaetonDamageSource,				"phaeton"},
	{ScorpionDamageSource,				"scorpion"},
	{WarthogDamageSource,				"warthog"},
	{WraithDamageSource,				"wraith"},
	{PhantomDamageSource, 				"phantom"},
	-- Turrets
	{ChaingunTurretDamageSource,		"chain_gun_turret"},
	{GaussTurretDamageSource,			"gauss_turret"},
	{RocketPodTurretDamageSource,		"rocket_pod_turret"},
	{PlasmaTurretDamageSource,			"plasma_turret"},
	{ShadeTurretDamageSource,			"shade_turret"},
	{SplinterTurretDamageSource,		"splinter_turret"}
};

KillFeedItemReferenceDamageTypes = 
{
	{MeleeDamageType,					"melee"},
	{GroundPoundDamageType,				"ground_pound"},
	{ShoulderBashDamageType,			"shoulder_bash"},
	{SwordDamageType,					"sword"}
}