#include maps\_utility;
#include maps\_anim;

main()
{
	level.xenon = false;
    
	if (isdefined( getdvar("xenonGame") ) && getdvar("xenonGame") == "true" )
		level.xenon = true;
	
	maps\createart\village_assault_art::main();
	maps\village_assault_fx::main();
	maps\_load::main();
	level thread maps\village_assault_amb::main();
	maps\_compass::setupMiniMap("compass_map_village_assault");
	
	setSavedDvar("r_specularColorScale", "1.8");
	
	playerInit();
}

playerInit()
{	
	level.player takeAllWeapons();
	level.player giveWeapon("USP");
	level.player giveWeapon("m4_silencer");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("smoke_grenade_american");	
	level.player switchToWeapon("m4_silencer");
	
	thread maps\_utility::PlayerUnlimitedAmmoThread();
}

