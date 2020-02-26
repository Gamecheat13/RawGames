//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

main()
{
	level.tweakfile = true;
	
//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 15 );	

////default vision set////
	VisionSetNaked( "sp_blackout_default", 2);
}

vision_set_default()
{
	VisionSetNaked( "sp_blackout_default", 2);
}

vision_set_interrogation()
{
	VisionSetNaked( "sp_blackout_interrogation", 1.0 );
}

vision_set_hallway()
{
	VisionSetNaked( "sp_blackout_hallway", 3.0 );
	///SUN SAMPLE SIZE////
	SetSavedDvar( "sm_sunSampleSizeNear", 1.9 );
}

vision_set_bridge()
{
	VisionSetNaked( "sp_blackout_bridge", 3.0 );
		///SUN SAMPLE SIZE////
	SetSavedDvar( "sm_sunSampleSizeNear", 1.9 );
	
}

vision_set_menendez()
{
	VisionSetNaked( "messiah_mode", 5.0 );
}

vision_set_vent()
{
	VisionSetNaked( "sp_blackout_vent", 0.0 );
}

vision_set_mason_serverroom()
{
	VisionSetNaked( "sp_backout_mason_serverroom", 3.0 );
}
