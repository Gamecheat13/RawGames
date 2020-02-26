

main()
{
	self.animTree = "";
	self.AiCoreId = "Civilian";
	self.AiAlsId = "Thug";
	self.gdt_combatrole = "";
	self.team = "neutral";
	self.type = "human";
	self.accuracy = 1;
	self.health = 150;
	self.weapon = "";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeWeapon = "";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	switch(randomint(3))
	{
	case 0:
		character\character_tourist_1_venice::main();
		break;
	case 1:
		character\character_tourist_2_venice::main();
		break;
	case 2:
		character\character_tourist_3_venice::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("neutral");
}

precache()
{
	character\character_tourist_1_venice::precache();
	character\character_tourist_2_venice::precache();
	character\character_tourist_3_venice::precache();

}
