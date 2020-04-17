

main()
{
	self.animTree = "";
	self.AiCoreId = "Soldier";
	self.AiAlsId = "Thug";
	self.gdt_combatrole = "";
	self.team = "axis";
	self.type = "human";
	self.accuracy = 1;
	self.health = 100;
	self.weapon = "A3Raker_Eco";
	self.secondaryweapon = "";
	self.sidearm = "1911";
	self.grenadeWeapon = "concussion_grenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	character\character_greene::main();
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_greene::precache();

	precacheItem("A3Raker_Eco");
	precacheItem("1911");
	precacheItem("concussion_grenade");
}
