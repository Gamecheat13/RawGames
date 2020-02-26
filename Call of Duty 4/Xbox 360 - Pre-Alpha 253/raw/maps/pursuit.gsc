#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#using_animtree("generic_human");


main()
{
	maps\_load::main();
	//level thread maps\pursuit_amb::main();
	playerInit();

	setExpFog(0, 4000, 80.0/255, 80.0/255 , 90.0/255, 0); 
	VisionSetNaked( "ambush" );

   	
   	
   	       
}

playerInit()
{	
	level.player takeAllWeapons();
	level.player giveWeapon("usp");
	level.player giveWeapon("m4_grunt");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("smoke_grenade_american");	
	level.player switchToWeapon("m4_grunt");
}


