// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
// Asset: class_lmg
// Convert Time: 11/11/2011 04:51:49
#include common_scripts\utility;

precache()
{
	PrecacheModel( "c_usa_mp_sealteam6_lmg_body" );
	PrecacheModel( "c_usa_mp_sealteam6_assault_viewhands" );
	PrecacheModel( "c_usa_mp_sealteam6_lmg_head1" );
	PrecacheModel( "c_usa_mp_sealteam6_lmg_head2" );
	PrecacheModel( "c_usa_mp_sealteam6_lmg_head3" );

	game["set_player_model"]["allies"]["mg"] = ::set_player_model;
}

set_player_model()
{
	self SetModel( "c_usa_mp_sealteam6_lmg_body" );
	self SetViewModel( "c_usa_mp_sealteam6_assault_viewhands" );

	heads = [];
	heads[ 0 ] = "c_usa_mp_sealteam6_lmg_head1";
	heads[ 1 ] = "c_usa_mp_sealteam6_lmg_head2";
	heads[ 2 ] = "c_usa_mp_sealteam6_lmg_head3";

	head = random( heads );
	self Attach( head, "", true );
}
