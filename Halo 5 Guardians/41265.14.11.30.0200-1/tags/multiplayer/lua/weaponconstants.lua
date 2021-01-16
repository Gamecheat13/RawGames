--
-- Damage Types
--

meleeDamageType = ResolveString("melee");

bulletDamageType = ResolveString("bullet");

explosionDamageType = ResolveString("explosion");

groundPoundDamageType = ResolveString("ground_pound");

shoulderBashDamageType = ResolveString("shoulder_bash");

grenadeImpactDamageType = ResolveString("grenade_impact");

collisionDamageType = ResolveString("collision");

instantKillDamageType = ResolveString("instant_kill");

--
-- Damage Sources
--

-- Spartan Damage source (for all spartan abilities)
spartanDamageSource = ResolveString("spartan");

-- Guardians (jump off map)
fallingDamageSource = ResolveString("teh_guardians");

-- pistols
magnumWeaponName = ResolveString("hp");
magnumDamageSource = ResolveString("magnum");

battleRifleWeaponName = ResolveString("br");
battleRifleDamageSource = ResolveString("battle_rifle");

assaultRifleWeaponName = ResolveString("ar");
assaultRifleDamageSource = ResolveString("assault_rifle");

plasmaPistolWeaponName = ResolveString("pp");
plasmaPistolDamageSource = ResolveString("plasma_pistol")

smgWeaponName = ResolveString("sub");
smgDamageSource = ResolveString("smg");

dmrWeaponName = ResolveString("dmr");
dmrDamageSource = ResolveString("dmr");

carbineWeaponName = ResolveString("cb");
carbineDamageSource = ResolveString("covenant_carbine");

stormRifleDamageSource = ResolveString("storm_rifle")

lightRifleWeaponName = ResolveString("frr");
lightRifleDamageSource = ResolveString("light_rifle");

suppressorDamageSource = ResolveString("suppressor");

needlerDamageSource = ResolveString("needler");

stickyDetonatorDamageSource = ResolveString("sticky_detonator");

sawDamageSource = ResolveString("saw");

--shotguns
shotgunWeaponName = ResolveString("sg");
shotgunDamageSource = ResolveString("shotgun")

scattershotDamageSource = ResolveString("scattershot");

-- power weapons
rocketLauncherWeaponName = ResolveString("rocket_launcher");
rocketLauncherDamageSource = ResolveString("rocket launcher");

hydraWeaponName = ResolveString("mlrs");
hydraDamageSource = ResolveString("hydra_launcher");

fuelRodWeaponName = ResolveString("fr");
fuelRodDamageSource = ResolveString("fuel rod cannon");

incinerationCannonDamageSource = ResolveString("incineration_cannon");

spartanLaserDamageSource = ResolveString("spartan_laser");

swordWeaponName = ResolveString("energy_sword");
swordDamageSource = ResolveString("energy_sword");
swordWeaponClassName = ResolveString("sword");

arbiterswordWeaponName = ResolveString("energy_sword_arbiter");
arbiterSwordDamageSource = ResolveString("energy_sword_arbiter");

gravityHammerDamageSource = ResolveString("gravity_hammer");

sniperWeaponName = ResolveString("sniper_rifle");
sniperDamageSource = ResolveString("sniper_rifle");

binaryRifleDamageSource = ResolveString("binary_rifle");

-- Grenades
plasmaGrenadeDamageSource = ResolveString("plasma_grenade");

fragGrenadeDamageSource = ResolveString("frag_grenade");

forerunnerGrenadeDamageSource = ResolveString("forerunner_grenade");

--
-- Weapon Sets
--

powerWeaponNames = 
{
	shotgunWeaponName,
	rocketLauncherWeaponName,
	fuelRodWeaponName,
	swordWeaponName,
	sniperWeaponName,
	hydraWeaponName
};

powerWeaponDamageSources = 
{
	shotgunDamageSource,
	rocketLauncherDamageSource,
	fuelRodDamageSource,
	swordDamageSource,
	arbiterSwordDamageSource,
	sniperDamageSource,
	hydraDamageSource
};

nonPowerWeaponNames = 
{
	magnumWeaponName,
	battleRifleWeaponName,
	assaultRifleWeaponName,
	plasmaPistolWeaponName,
	smgWeaponName,
	dmrWeaponName,
	carbineWeaponName,
	lightRifleWeaponName
};

nonPowerWeaponDamageSources =
{
	magnumDamageSource,
	battleRifleDamageSource,
	assaultRifleDamageSource,
	plasmaPistolDamageSource,
	smgDamageSource,
	dmrDamageSource,
	carbineDamageSource,
	lightRifleDamageSource
};

swordDamageSources = 
{
	swordDamageSource,
	arbiterSwordDamageSource
};

grenadeDamageSources = 
{
	plasmaGrenadeDamageSource,
	fragGrenadeDamageSource,
	forerunnerGrenadeDamageSource
};

-- need to add ALL weapons to this table as it is used to define Weapon Pad Events
weaponNames = 
{
	{"rocketlauncher",	rocketLauncherWeaponName},
	{"sniperrifle",     sniperWeaponName},
	{"shotgun",         shotgunWeaponName},
	{"energysword",     swordWeaponName},
	{"arbitersword",    arbiterswordWeaponName},
	{"hydra",    		hydraWeaponName} 
};
