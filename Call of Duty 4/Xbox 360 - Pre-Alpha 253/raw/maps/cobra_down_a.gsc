#include maps\_utility;
#include common_scripts\utility;

main()
{
	maps\_load::main();
	level thread maps\cobra_down_a_amb::main();
	playerInit();


//	setExpFog(0, 6000, .583, .644 , .587, 0); 
	VisionSetNaked( "cobra_down" );

	setExpFog(0, 6000, 160.0/255, 131.0/255 , 88.0/255, 0); 
   	           

	if ( getdvarint("aitest") != 1 )
	{
		// delete AI
		array_thread( getaiarray(), ::del);
	}	
	else
	{
		// delete temp guy models
		array_thread( getentarray("demomodel", "targetname"), ::del);
	}
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

del()
{
	self delete();
}
