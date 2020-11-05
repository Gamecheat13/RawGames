// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
// Asset: class_smg
// Convert Time: 10/31/2011 06:34:42
#include common_scripts\utility;

precache()
{
	PrecacheModel( "iw5_usa_sog_mp_body_utility" );
	PrecacheModel( "iw5_viewmodel_usa_sog_standard_arms" );
	PrecacheModel( "iw5_usa_sog_mp_head_1" );
	PrecacheModel( "iw5_usa_sog_mp_head_2" );
	PrecacheModel( "iw5_usa_sog_mp_head_3" );

	game["set_player_model"]["allies"]["smg"] = ::set_player_model;
}

set_player_model()
{
	self SetModel( "iw5_usa_sog_mp_body_utility" );
	self SetViewModel( "iw5_viewmodel_usa_sog_standard_arms" );

	heads = [];
	heads[ 0 ] = "iw5_usa_sog_mp_head_1";
	heads[ 1 ] = "iw5_usa_sog_mp_head_2";
	heads[ 2 ] = "iw5_usa_sog_mp_head_3";

	head = random( heads );
	self Attach( head, "", true );
}
