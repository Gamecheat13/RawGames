

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
	self.weapon = "p99";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeWeapon = "concussion_grenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	character\character_lc_thug_casino::main();
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_lc_thug_casino::precache();

	precacheItem("p99");
	precacheItem("concussion_grenade");
}
