main()
{
	setExpFog( 100, 2300, .42,.41,.39, 0);

	maps\_load::main();
	level thread maps\chechnya_escape_amb::main();
	playerInit();
}


playerInit()
{
	level.player takeAllWeapons();
	level.player giveWeapon("Beretta");
	level.player giveWeapon("MP5");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("smoke_grenade_american");
}
