// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_Hero_Farid_Karma (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER MAKEROOM UNDELETABLE ENEMYINFO SCRIPT_FORCESPAWN SM_PRIORITY
defaultmdl="c_usa_jungmar_1_fb"
"count" -- max AI to ever spawn from this spawner
SPAWNER -- makes this a spawner instead of a guy
MAKEROOM -- will try to delete an AI if spawning fails from too many AI
UNDELETABLE -- this AI (or AI spawned from here) cannot be deleted to make room for MAKEROOM guys
ENEMYINFO -- this AI when spawned will get a snapshot of perfect info about all enemies
SCRIPT_FORCESPAWN -- this AI will spawned even if players can see him spawning.
SM_PRIORITY -- Make the Spawn Manager spawn from this spawner before other spawners.
*/
main()
{
	self.accuracy = 1;
	self.animTree = "generic_human.atr";
	self.csvInclude = "";
	self.grenadeAmmo = 0;
	self.grenadeWeapon = "frag_grenade_sp";
	self.health = 100;
	self.precacheScript = "";
	self.secondaryweapon = "";
	self.sidearm = "fiveseven_sp";
	self.subclass = "regular";
	self.team = "allies";
	self.type = "human";
	self.weapon = "hk416_sp";

	self setEngagementMinDist( 250.000000, 0.000000 );
	self setEngagementMaxDist( 700.000000, 1000.000000 );

	character\c_rus_kravchenko_jacket_bandolier::main();
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\c_rus_kravchenko_jacket_bandolier::precache();

	precacheItem("hk416_sp");
	precacheItem("fiveseven_sp");
	precacheItem("frag_grenade_sp");
}