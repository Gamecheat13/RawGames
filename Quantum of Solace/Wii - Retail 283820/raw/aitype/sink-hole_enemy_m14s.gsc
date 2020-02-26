

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
	self.weapon = "M14_Sink";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeWeapon = "frag_grenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	switch(randomint(4))
	{
	case 0:
		character\character_thug_1_sinkhole::main();
		break;
	case 1:
		character\character_thug_2_sinkhole::main();
		break;
	case 2:
		character\character_thug_3_sinkhole::main();
		break;
	case 3:
		character\character_thug_4_sinkhole::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_thug_1_sinkhole::precache();
	character\character_thug_2_sinkhole::precache();
	character\character_thug_3_sinkhole::precache();
	character\character_thug_4_sinkhole::precache();

	precacheItem("M14_Sink");
	precacheItem("frag_grenade");
}
