

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
	self.weapon = "SAF9_Casino_s";
	self.secondaryweapon = "";
	self.sidearm = "p99";
	self.grenadeWeapon = "concussion_grenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	switch(randomint(3))
	{
	case 0:
		character\character_ob_thug_1_casino::main();
		break;
	case 1:
		character\character_ob_thug_2_casino::main();
		break;
	case 2:
		character\character_ob_thug_3_casino::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_ob_thug_1_casino::precache();
	character\character_ob_thug_2_casino::precache();
	character\character_ob_thug_3_casino::precache();

	precacheItem("SAF9_Casino_s");
	precacheItem("SAF9_Casino");
	precacheItem("p99");
	precacheItem("concussion_grenade");
}
