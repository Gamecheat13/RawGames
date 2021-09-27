// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_civilian_london_male (0.5 0.5 0.5) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE PERFECTENEMYINFO DONTSHAREENEMYINFO
defaultmdl="body_london_male_a"
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
	self.team = "neutral";
	self.type = "civilian";
	self.subclass = "regular";
	self.accuracy = 0.2;
	self.health = 30;
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeWeapon = "";
	self.grenadeAmmo = 0;

	if ( isAI( self ) )
	{
		self setEngagementMinDist( 256.000000, 0.000000 );
		self setEngagementMaxDist( 768.000000, 1024.000000 );
	}

	self.weapon = "none";

	switch( codescripts\character::get_random_character(3) )
	{
	case 0:
		character\character_civilian_london_male_a::main();
		break;
	case 1:
		character\character_civilian_london_male_b::main();
		break;
	case 2:
		character\character_civilian_london_male_c::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("neutral");
}

precache()
{
	character\character_civilian_london_male_a::precache();
	character\character_civilian_london_male_b::precache();
	character\character_civilian_london_male_c::precache();

}
