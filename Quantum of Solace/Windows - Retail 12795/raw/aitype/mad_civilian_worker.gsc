// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_MAD_civilian_worker (0.5 0.5 0.5) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
defaultmdl="cons_worker_1_complete"
"count" -- max AI to ever spawn from this spawner
SPAWNER -- makes this a spawner instead of a guy
FORCESPAWN -- will try to delete an AI if spawning fails from too many AI
UNDELETABLE -- this AI (or AI spawned from here) cannot be deleted to make room for FORCESPAWN guys
ENEMYINFO -- this AI when spawned will get a snapshot of perfect info about all enemies
*/
main()
{
	self.animTree = "";
	self.AiCoreId = "Civilian";
	self.AiAlsId = "Thug";
	self.gdt_combatrole = "";
	self.team = "neutral";
	self.type = "human";
	self.health = 100;
	self.weapon = "";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeWeapon = "";
	self.grenadeAmmo = 0;

	//In 007 mode, override to always be 1 accuracy
	if( getdvarint( "level_gameskill" ) > 2 )
	{
		self.accuracy = 1;
	}
	else
	{
		self.accuracy = 0.7;
	}
	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	character\character_worker_cons::main();
}

spawner()
{
	self setspawnerteam("neutral");
}

precache()
{
	character\character_worker_cons::precache();

}