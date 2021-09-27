// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_ally_intro_russian_AR (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE PERFECTENEMYINFO DONTSHAREENEMYINFO
defaultmdl="body_pmc_africa_assault_a"
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
	self.health = 150;
	self.secondaryweapon = "";
	self.sidearm = "mp412";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	if ( isAI( self ) )
	{
		self setEngagementMinDist( 256.000000, 0.000000 );
		self setEngagementMaxDist( 768.000000, 1024.000000 );
	}

	switch( codescripts\character::get_random_weapon(4) )
	{
	case 0:
		self.weapon = "ak47";
		break;
	case 1:
		self.weapon = "ak47_acog";
		break;
	case 2:
		self.weapon = "ak47_eotech";
		break;
	case 3:
		self.weapon = "ak47_reflex";
		break;
	}

	character\character_pmc_africa_assault_a::main();
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\character_pmc_africa_assault_a::precache();

	precacheItem("ak47");
	precacheItem("ak47_acog");
	precacheItem("ak47_eotech");
	precacheItem("ak47_reflex");
	precacheItem("mp412");
	precacheItem("fraggrenade");
}
