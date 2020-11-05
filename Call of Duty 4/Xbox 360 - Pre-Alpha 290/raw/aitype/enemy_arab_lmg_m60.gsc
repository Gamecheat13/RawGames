// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_enemy_arab_LMG_m60 (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
defaultmdl="body_complete_sp_arab_regular_asad"
"count" -- max AI to ever spawn from this spawner
SPAWNER -- makes this a spawner instead of a guy
FORCESPAWN -- will try to delete an AI if spawning fails from too many AI
UNDELETABLE -- this AI (or AI spawned from here) cannot be deleted to make room for FORCESPAWN guys
ENEMYINFO -- this AI when spawned will get a snapshot of perfect info about all enemies
*/
main()
{
	self.animTree = "";
	self.team = "axis";
	self.type = "human";
	self.accuracy = 0.2;
	self.health = 150;
	self.weapon = "rpd";
	self.secondaryweapon = "deserteagle";
	self.sidearm = "beretta";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 512.000000, 400.000000 );
	self setEngagementMaxDist( 1024.000000, 1250.000000 );

	switch(randomint(2))
	{
	case 0:
		character\character_sp_arab_regular_asad::main();
		break;
	case 1:
		character\character_sp_arab_regular_ski_mask::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_sp_arab_regular_asad::precache();
	character\character_sp_arab_regular_ski_mask::precache();

	precacheItem("rpd");
	precacheItem("deserteagle");
	precacheItem("beretta");
	precacheItem("fraggrenade");
}