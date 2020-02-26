#include common_scripts\utility;
#include maps\_utility;

main()
{

//////////Rim Lighting//////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 15 );
    

VisionSetNaked( "sp_pakistan_2_default", 2 );

}


set_water_dvars_street()
{
	SetDvar( "r_waterwavespeed", "0.470637 0.247217 1 1" );
	SetDvar( "r_waterwaveamplitude", "2.8911 0 0 0" );
	SetDvar( "r_waterwavewavelength", "9.71035 3.4 1 1" );	
	SetDvar( "r_waterwaveangle", "56.75 237.203 0 0" );
	SetDvar( "r_waterwavephase", "0 2.6 0 0" );
	SetDvar( "r_waterwavesteepness", "0 0 0 0" );
	SetDvar( "r_waterwavelength", "9.71035 3.40359 1 1" );
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

turn_on_trainyard_vision()
{
	level.vision_set_pretrainyard = level.player GetVisionSetNaked();
	level.player VisionSetNaked( "sp_pakistan_2_trainyard", 0 );	
}

turn_off_trainyard_vision()
{
	if(!IsDefined(level.vision_set_pretrainyard))
	{
		level.vision_set_pretrainyard = "default";	
	}
	
	level.player VisionSetNaked( level.vision_set_pretrainyard, 0 );	
}

underground_fire_fx_vision()
{
	level.player VisionSetNaked( "sp_pakistan2_underground_fire", 0);
}

turn_back_to_default()
{
	level.player VisionSetNaked( "sp_pakistan_2_default", 2);
}