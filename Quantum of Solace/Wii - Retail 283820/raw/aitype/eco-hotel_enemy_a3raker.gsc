

main()
{
	self.animTree = "";
	self.AiCoreId = "Soldier";
	self.AiAlsId = "Thug";
	self.gdt_combatrole = "";
	self.team = "axis";
	self.type = "human";
	self.accuracy = 1;
	self.health = 80;
	self.weapon = "A3Raker_Eco";
	self.secondaryweapon = "";
	self.sidearm = "p99";
	self.grenadeWeapon = "concussion_grenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	switch(randomint(4))
	{
	case 0:
		character\character_soldier_1_eco::main();
		break;
	case 1:
		character\character_soldier_2_eco::main();
		break;
	case 2:
		character\character_soldier_3_eco::main();
		break;
	case 3:
		character\character_soldier_4_eco::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_soldier_1_eco::precache();
	character\character_soldier_2_eco::precache();
	character\character_soldier_3_eco::precache();
	character\character_soldier_4_eco::precache();

	precacheItem("A3Raker_Eco");
	precacheItem("p99");
	precacheItem("concussion_grenade");
}
