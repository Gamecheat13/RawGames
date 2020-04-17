

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
	self.weapon = "TND16_Get";
	self.secondaryweapon = "";
	self.sidearm = "1911";
	self.grenadeWeapon = "concussion_grenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	switch(randomint(3))
	{
	case 0:
		character\character_thug_1_venice::main();
		break;
	case 1:
		character\character_thug_2_venice::main();
		break;
	case 2:
		character\character_thug_3_venice::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_thug_1_venice::precache();
	character\character_thug_2_venice::precache();
	character\character_thug_3_venice::precache();

	precacheItem("TND16_Get");
	precacheItem("1911");
	precacheItem("concussion_grenade");
}
