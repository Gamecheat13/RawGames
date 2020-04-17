

main()
{
	self.animTree = "";
	self.AiCoreId = "Civilian";
	self.AiAlsId = "CivilianMale";
	self.gdt_combatrole = "";
	self.team = "neutral";
	self.type = "human";
	self.accuracy = 1;
	self.health = 80;
	self.weapon = "";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeWeapon = "";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	switch(randomint(2))
	{
	case 0:
		character\character_civ_1_poison::main();
		break;
	case 1:
		character\character_civ_2_poison::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("neutral");
}

precache()
{
	character\character_civ_1_poison::precache();
	character\character_civ_2_poison::precache();

}
