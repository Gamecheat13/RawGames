

main()
{
	self.animTree = "";
	self.AiCoreId = "Civilian";
	self.AiAlsId = "CivilianMale";
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

	character\character_casino_male_1::main();
}

spawner()
{
	self setspawnerteam("neutral");
}

precache()
{
	character\character_casino_male_1::precache();

}
