//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

main()
{
	level.tweakfile = true;
	
	//////////Rim Lighting//////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 15 );
 
	// *default vision set*

		VisionSetNaked( "sp_panama_default", 5 );
}

clinic()
{

    
	VisionSetNaked( "sp_panama3_clinic", 0.5 );

}
chase()
{
    
	VisionSetNaked( "sp_panama3_chase", 0.5 );

}
checkpoint()
{
    
	VisionSetNaked( "sp_panama3_checkpoint", 0.5 );

}
docks()
{
     	//////////Rim Lighting//////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 8 );
    
    	//////////SUN SAMPLE SIZE//////////
	SetSavedDvar( "sm_sunSampleSizeNear", 1.9 );
	
	VisionSetNaked( "sp_panama3_docks", 0.5 );

}

sniper()
{
  	//////////Rim Lighting//////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 8 );
    
	VisionSetNaked( "sp_panama3_sniper", 0.5 );

}
walk()
{
    
	VisionSetNaked( "sp_panama3_sniper", 0.5 );

}
set_water_dvar()
{
	SetDvar( "r_waterwaveangle", "0 130 0 0" );
	SetDvar( "r_waterwavewavelength", "230 321 0 0" );
//	SetDvar( "r_waterwaveamplitude", "0.62 0.58 0 0" );
	SetDvar( "r_waterwavespeed", "0.39 0.54 0 0" );
}