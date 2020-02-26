main()
{
	maps\ambush_fx::main();
	maps\_load::main();
	level thread maps\ambush_amb::main();
	playerInit();

	setExpFog(250, 6000, .5, .5, .52, 0);
	VisionSetNaked( "ambush" );
}

playerInit()
{	
	level.player takeAllWeapons();
	level.player giveWeapon("Beretta");
	level.player giveWeapon("m16_grenadier");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("smoke_grenade_american");	
	level.player switchToWeapon("m16_grenadier");
}