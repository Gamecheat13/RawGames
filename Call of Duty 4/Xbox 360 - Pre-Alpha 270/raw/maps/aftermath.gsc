#include maps\_utility;

main()
{
	maps\aftermath_fx::main();
	maps\createart\aftermath_art::main();
	maps\_load::main();
	playerInit();
}

playerInit()
{	
	level.player takeAllWeapons();
	level.player giveWeapon("Beretta");
	//level.player giveWeapon("M14_Scoped");
	level.player giveWeapon("m16_grenadier");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("smoke_grenade_american");	
	level.player switchToWeapon("m16_grenadier");
}