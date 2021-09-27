// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_ally_rangers_M4 (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE PERFECTENEMYINFO DONTSHAREENEMYINFO
defaultmdl="body_rangers_bdu_assault_a"
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
	self.team = "allies";
	self.type = "human";
	self.subclass = "regular";
	self.accuracy = 0.2;
	self.health = 100;
	self.secondaryweapon = "";
	self.sidearm = "usp";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	if ( isAI( self ) )
	{
		self setEngagementMinDist( 256.000000, 0.000000 );
		self setEngagementMaxDist( 768.000000, 1024.000000 );
	}

	switch( codescripts\character::get_random_weapon(2) )
	{
	case 0:
		self.weapon = "m4_grenadier";
		break;
	case 1:
		self.weapon = "m4_grunt";
		break;
	}

	character\character_rangers_bdu_assault_a::main();
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\character_rangers_bdu_assault_a::precache();

	precacheItem("m4_grenadier");
	precacheItem("m203_m4");
	precacheItem("m4_grunt");
	precacheItem("usp");
	precacheItem("fraggrenade");
}
