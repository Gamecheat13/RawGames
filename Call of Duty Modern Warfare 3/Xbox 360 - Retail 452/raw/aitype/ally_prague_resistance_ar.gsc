// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_ally_prague_resistance_AR (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE PERFECTENEMYINFO DONTSHAREENEMYINFO
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

	switch( codescripts\character::get_random_character(18) )
	{
	case 0:
		character\character_prague_civilian_male_a::main();
		break;
	case 1:
		character\character_prague_civilian_male_b::main();
		break;
	case 2:
		character\character_prague_civilian_male_c::main();
		break;
	case 3:
		character\character_prague_civilian_male_d::main();
		break;
	case 4:
		character\character_prague_civilian_male_e::main();
		break;
	case 5:
		character\character_prague_civilian_male_f::main();
		break;
	case 6:
		character\character_prague_civilian_male_aa::main();
		break;
	case 7:
		character\character_prague_civilian_male_bb::main();
		break;
	case 8:
		character\character_prague_civilian_male_cc::main();
		break;
	case 9:
		character\character_prague_civilian_male_dd::main();
		break;
	case 10:
		character\character_prague_civilian_male_ee::main();
		break;
	case 11:
		character\character_prague_civilian_male_ff::main();
		break;
	case 12:
		character\character_prague_civilian_male_aaa::main();
		break;
	case 13:
		character\character_prague_civilian_male_bbb::main();
		break;
	case 14:
		character\character_prague_civilian_male_ccc::main();
		break;
	case 15:
		character\character_prague_civilian_male_ddd::main();
		break;
	case 16:
		character\character_prague_civilian_male_eee::main();
		break;
	case 17:
		character\character_prague_civilian_male_fff::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\character_prague_civilian_male_a::precache();
	character\character_prague_civilian_male_b::precache();
	character\character_prague_civilian_male_c::precache();
	character\character_prague_civilian_male_d::precache();
	character\character_prague_civilian_male_e::precache();
	character\character_prague_civilian_male_f::precache();
	character\character_prague_civilian_male_aa::precache();
	character\character_prague_civilian_male_bb::precache();
	character\character_prague_civilian_male_cc::precache();
	character\character_prague_civilian_male_dd::precache();
	character\character_prague_civilian_male_ee::precache();
	character\character_prague_civilian_male_ff::precache();
	character\character_prague_civilian_male_aaa::precache();
	character\character_prague_civilian_male_bbb::precache();
	character\character_prague_civilian_male_ccc::precache();
	character\character_prague_civilian_male_ddd::precache();
	character\character_prague_civilian_male_eee::precache();
	character\character_prague_civilian_male_fff::precache();

	precacheItem("ak47");
	precacheItem("ak74u");
	precacheItem("glock");
	precacheItem("fraggrenade");

	//----------------
	maps\_rambo::main();
	//----------------
}
