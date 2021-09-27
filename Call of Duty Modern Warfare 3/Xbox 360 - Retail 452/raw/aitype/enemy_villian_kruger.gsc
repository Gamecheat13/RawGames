// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_enemy_villian_Kruger (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE PERFECTENEMYINFO DONTSHAREENEMYINFO
defaultmdl="body_russian_navy_coat"
"count" -- max AI to ever spawn from this spawner
SPAWNER -- makes this a spawner instead of a guy
FORCESPAWN -- will try to delete an AI if spawning fails from too many AI
UNDELETABLE -- this AI (or AI spawned from here) cannot be deleted to make room for FORCESPAWN guys
PERFECTENEMYINFO -- this AI when spawned will get a snapshot of perfect info about all enemies
DONTSHAREENEMYINFO -- do not get shared info about enemies at spawn time from teammates
*/
main()
{
	self.animTree = "";
	self.additionalAssets = "";
	self.team = "axis";
	self.type = "human";
	self.subclass = "regular";
	self.accuracy = 0.12;
	self.health = 150;
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	if ( isAI( self ) )
	{
		self setEngagementMinDist( 256.000000, 0.000000 );
		self setEngagementMaxDist( 512.000000, 1024.000000 );
	}

	self.weapon = "usp";

	character\character_vil_kruger::main();
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_vil_kruger::precache();

	precacheItem("usp");
	precacheItem("fraggrenade");
}
