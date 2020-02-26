

main()
{
	self.animTree = "";
	self.AiCoreId = "Civilian";
	self.AiAlsId = "Thug";
	self.gdt_combatrole = "";
	self.team = "neutral";
	self.type = "human";
	self.accuracy = 1;
	self.health = 80;
	self.weapon = "TND16_Sink";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeWeapon = "frag_grenade";
	self.grenadeAmmo = 1;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	character\character_camille_sinkhole::main();
}

spawner()
{
	self setspawnerteam("neutral");
}

precache()
{
	character\character_camille_sinkhole::precache();

	precacheItem("TND16_Sink");
	precacheItem("frag_grenade");
}
