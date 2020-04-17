

main()
{
	self.animTree = "";
	self.AiCoreId = "Soldier";
	self.AiAlsId = "Thug";
	self.gdt_combatrole = "rusher";
	self.team = "axis";
	self.type = "human";
	self.accuracy = 1;
	self.health = 80;
	self.weapon = "GF18a_Train";
	self.secondaryweapon = "";
	self.sidearm = "p99";
	self.grenadeWeapon = "";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	switch(randomint(4))
	{
	case 0:
		character\character_thug_1_train::main();
		break;
	case 1:
		character\character_thug_2_train::main();
		break;
	case 2:
		character\character_thug_3_train::main();
		break;
	case 3:
		character\character_thug_4_train::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_thug_1_train::precache();
	character\character_thug_2_train::precache();
	character\character_thug_3_train::precache();
	character\character_thug_4_train::precache();

	precacheItem("GF18a_Train");
	precacheItem("p99");
}
