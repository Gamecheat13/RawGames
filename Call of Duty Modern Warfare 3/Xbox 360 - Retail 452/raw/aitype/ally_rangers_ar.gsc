// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_ally_rangers_AR (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE PERFECTENEMYINFO DONTSHAREENEMYINFO
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
	self.sidearm = "beretta";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	if ( isAI( self ) )
	{
		self setEngagementMinDist( 256.000000, 0.000000 );
		self setEngagementMaxDist( 768.000000, 1024.000000 );
	}

	switch( codescripts\character::get_random_weapon(8) )
	{
	case 0:
		self.weapon = "m16_basic";
		break;
	case 1:
		self.weapon = "scar_h";
		break;
	case 2:
		self.weapon = "m16_grenadier";
		break;
	case 3:
		self.weapon = "m4_grunt";
		break;
	case 4:
		self.weapon = "m16_acog";
		break;
	case 5:
		self.weapon = "scar_h_reflex";
		break;
	case 6:
		self.weapon = "m4_grenadier";
		break;
	case 7:
		self.weapon = "scar_h_grenadier";
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

	precacheItem("m16_basic");
	precacheItem("scar_h");
	precacheItem("m16_grenadier");
	precacheItem("m203");
	precacheItem("m4_grunt");
	precacheItem("m16_acog");
	precacheItem("scar_h_reflex");
	precacheItem("m4_grenadier");
	precacheItem("m203_m4");
	precacheItem("scar_h_grenadier");
	precacheItem("SCAR_H_M203");
	precacheItem("beretta");
	precacheItem("fraggrenade");
}
