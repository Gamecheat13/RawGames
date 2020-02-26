#include common_scripts\utility;
#include maps\_utility;

main()
{

//////////Rim Lighting//////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 15 );
    

VisionSetNaked( "sp_pakistan_default", 2 );

}


set_water_dvars_street()
{
	SetDvar( "r_waterwavespeed", "1.092 1.060 1.085 1.045" );
	SetDvar( "r_waterwaveamplitude", "3.0 1.25 2.69307 2.95" ); 
	SetDvar( "r_waterwavewavelength", "111.9 77 187.6 245" );	
	SetDvar( "r_waterwaveangle", "70.6 46.9 117.1 179.67" );
	SetDvar( "r_waterwavephase", "0 0 0 0" );
	SetDvar( "r_waterwavesteepness", "1 1 1 1" );
}

set_water_dvars_flatten_surface()
{
	SetDvar( "r_waterwaveamplitude", "0 0 0 0" );
}

//-- Claw Vision Set Control

turn_on_claw_vision()
{
	level.vision_set_preclaw = level.player GetVisionSetNaked();
	level.player VisionSetNaked( "claw_base", 0 );	
}

turn_off_claw_vision()
{
	if(!IsDefined(level.vision_set_preclaw))
	{
		level.vision_set_preclaw = "default";	
	}
	
	level.player VisionSetNaked( level.vision_set_preclaw, 0 );	
}
