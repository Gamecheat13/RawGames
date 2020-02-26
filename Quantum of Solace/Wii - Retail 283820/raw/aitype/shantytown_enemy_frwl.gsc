

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
	self.weapon = "FRWL_Shanty";
	self.secondaryweapon = "";
	self.sidearm = "p99";
	self.grenadeWeapon = "frag_grenade_shantytown";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	switch(randomint(3))
	{
	case 0:
		character\character_thug_1_shanty::main();
		break;
	case 1:
		character\character_thug_2_shanty::main();
		break;
	case 2:
		character\character_thug_3_shanty::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_thug_1_shanty::precache();
	character\character_thug_2_shanty::precache();
	character\character_thug_3_shanty::precache();

	precacheItem("FRWL_Shanty");
	precacheItem("p99");
	precacheItem("frag_grenade_shantytown");
}
