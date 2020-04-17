

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
	self.weapon = "SAF9_AIR_s";
	self.secondaryweapon = "";
	self.sidearm = "1911";
	self.grenadeWeapon = "flash_grenade";
	self.grenadeAmmo = 1;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	character\character_carlos::main();
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_carlos::precache();

	precacheItem("SAF9_AIR_s");
	precacheItem("SAF9_AIR");
	precacheItem("1911");
	precacheItem("flash_grenade");
}
