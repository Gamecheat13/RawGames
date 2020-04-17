

main()
{
	self.animTree = "";
	self.AiCoreId = "Soldier";
	self.AiAlsId = "Thug";
	self.gdt_combatrole = "";
	self.team = "allies";
	self.type = "human";
	self.accuracy = 0.2;
	self.health = 80;
	self.weapon = "p99";
	self.secondaryweapon = "";
	self.sidearm = "p99";
	self.grenadeWeapon = "";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	character\character_carter::main();
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\character_carter::precache();

	precacheItem("p99");
	precacheItem("p99");
}
