//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

main()
{
	level.tweakfile = true;
	
	//////////Rim Lighting//////////
    SetSavedDvar( "r_rimIntensity_debug", 1 );
    SetSavedDvar( "r_rimIntensity", 8 );
    SetSavedDvar( "r_lightTweakSunLight", (5) );
    
    
 
	// *intro section*

		VisionSetNaked( "sp_panama_house", 0.5 );
}

house()
{

    SetSavedDvar( "r_rimIntensity", 8 );
		VisionSetNaked( "sp_panama_house", 0.5 );
}
beach()
{
		SetSavedDvar( "r_rimIntensity", 12 );
		VisionSetNaked( "sp_panama_airstrip", 0.5 );
}
airfield()
{

    SetSavedDvar( "r_rimIntensity", 10 );
		VisionSetNaked( "sp_panama_airstrip", 0.5 );
}
learjet()
{

    SetSavedDvar( "r_rimIntensity", 8 );
		VisionSetNaked( "sp_panama_airstrip", 0.5 );
}
motel()
{

    SetSavedDvar( "r_rimIntensity", 8 );
		VisionSetNaked( "sp_panama_airstrip", 0.5 );
}

slums_start()
{
	VisionSetNaked( "sp_panama_slums", 0.5 );
	SetSavedDvar( "r_rimIntensity", 10 );
	
}

burning_building()
{
	VisionSetNaked( "sp_panama_slums", 0.5 );
	SetSavedDvar( "r_rimIntensity", 10 );
	
}

slums()
{
	VisionSetNaked( "sp_panama_slums", 0.5 );
	SetSavedDvar( "r_rimIntensity", 10 );
	
}

set_water_dvar()
{
	SetSavedDvar( "r_waterwaveangle", "0 130 0 0" );
	SetSavedDvar( "r_waterwavewavelength", "230 321 0 0" );
//	SetSavedDvar( "r_waterwaveamplitude", "0.62 0.58 0 0" );
	SetSavedDvar( "r_waterwavespeed", "0.39 0.54 0 0" );
}