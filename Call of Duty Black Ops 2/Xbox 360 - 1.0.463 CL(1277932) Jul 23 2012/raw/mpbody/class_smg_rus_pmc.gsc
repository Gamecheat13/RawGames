// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
// Asset: class_smg
// Convert Time: 07/19/2012 23:09:52
#include common_scripts\utility;

precache()
{
	PrecacheModel( "c_mul_mp_pmc_smg_fb" );
	PrecacheModel( "c_mul_mp_pmc_shortsleeve_viewhands" );

	if ( level.multiTeam )	
	{
		game["set_player_model"]["team4"]["smg"] = ::set_player_model;
	}
	else
	{
		game["set_player_model"]["axis"]["smg"] = ::set_player_model;
	}
}

set_player_model()
{
	self SetModel( "c_mul_mp_pmc_smg_fb" );
	self SetViewModel( "c_mul_mp_pmc_shortsleeve_viewhands" );

	heads = [];
}
