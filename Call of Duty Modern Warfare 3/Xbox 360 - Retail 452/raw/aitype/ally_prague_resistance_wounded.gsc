// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_ally_prague_resistance_wounded (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE PERFECTENEMYINFO DONTSHAREENEMYINFO
defaultmdl="body_prague_civ_male_a"
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
	self.additionalAssets = "common_rambo_anims.csv";
	self.team = "allies";
	self.type = "human";
	self.subclass = "militia";
	self.accuracy = 0.12;
	self.health = 150;
	self.secondaryweapon = "";
	self.sidearm = "glock";
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
		self.weapon = "ak47";
		break;
	case 1:
		self.weapon = "ak74u";
		break;
	}

	character\character_prague_males_unarmed::main();
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\character_prague_males_unarmed::precache();

	precacheItem("ak47");
	precacheItem("ak74u");
	precacheItem("glock");
	precacheItem("fraggrenade");

	//----------------
	maps\_rambo::main();
	//----------------
}
