main()
{
	maps\scriptgen\airplane_scriptgen::main();
//	maps\_load::main(1);
	playerInit();
}

playerInit()
{	
	level.player takeAllWeapons();
	level.player giveWeapon("Beretta");
	level.player giveWeapon("mp5_silencer");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("smoke_grenade_american");	
	level.player switchToWeapon("mp5_silencer");
}