// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_enemy_opforce_paris_ac130_AR (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE PERFECTENEMYINFO DONTSHAREENEMYINFO
defaultmdl="body_russian_military_assault_a_airborne"
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
	self.accuracy = 0.2;
	self.health = 150;
	self.secondaryweapon = "";
	self.sidearm = "pp2000";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	if ( isAI( self ) )
	{
		self setEngagementMinDist( 256.000000, 0.000000 );
		self setEngagementMaxDist( 768.000000, 1024.000000 );
	}

	self.weapon = "ak47_ac130";

	switch( codescripts\character::get_random_character(3) )
	{
	case 0:
		character\character_opforce_paris_assault_a::main();
		break;
	case 1:
		character\character_opforce_paris_assault_b::main();
		break;
	case 2:
		character\character_russian_military_rpg_a_a::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_opforce_paris_assault_a::precache();
	character\character_opforce_paris_assault_b::precache();
	character\character_russian_military_rpg_a_a::precache();

	precacheItem("ak47_ac130");
	precacheItem("pp2000");
	precacheItem("fraggrenade");
}
