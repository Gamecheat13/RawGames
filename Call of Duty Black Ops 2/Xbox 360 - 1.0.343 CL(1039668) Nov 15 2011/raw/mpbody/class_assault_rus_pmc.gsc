// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
// Asset: class_assault
// Convert Time: 11/12/2011 11:30:30
#include common_scripts\utility;

precache()
{
	PrecacheModel( "c_mul_mp_manticore_assault_body" );
	PrecacheModel( "iw5_viewmodel_usa_sog_standard_arms" );
	PrecacheModel( "c_mul_mp_manticore_assault_head" );

	game["set_player_model"]["axis"]["default"] = ::set_player_model;
}

set_player_model()
{
	self SetModel( "c_mul_mp_manticore_assault_body" );
	self SetViewModel( "iw5_viewmodel_usa_sog_standard_arms" );

	heads = [];
	heads[ 0 ] = "c_mul_mp_manticore_assault_head";

	head = random( heads );
	self Attach( head, "", true );
}
