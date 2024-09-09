#include maps\_utility;
#include animscripts\Combat_utility;
#include animscripts\utility;
#using_animtree( "generic_human" );

// (Note that animations called right are used with left corner nodes, and vice versa.)

init_animset_cover_left()
{
	initAnimSet = [];

	initAnimSet[ "alert_idle" ] = %corner_standL_alert_idle;
	initAnimSet[ "alert_idle_twitch" ] = [
		%corner_standL_alert_twitch01,
		%corner_standL_alert_twitch02,
		%corner_standL_alert_twitch03,
		%corner_standL_alert_twitch04,
		%corner_standL_alert_twitch05,
		%corner_standL_alert_twitch06,
		%corner_standL_alert_twitch07
	 ];
	initAnimSet[ "alert_idle_flinch" ] = [ %corner_standL_flinch ];

	//initAnimSet["alert_to_C"] = %corner_standL_trans_alert_2_C;
	//initAnimSet["B_to_C"] = %corner_standL_trans_B_2_C;
	//initAnimSet["C_to_alert"] = %corner_standL_trans_C_2_alert;
	//initAnimSet["C_to_B"] = %corner_standL_trans_C_2_B;
	initAnimSet[ "alert_to_A" ] = [ %corner_standL_trans_alert_2_A ];
	initAnimSet[ "alert_to_B" ] = [ %corner_standL_trans_alert_2_B_v2 ];
	initAnimSet[ "A_to_alert" ] = [ %corner_standL_trans_A_2_alert_v2 ];
	initAnimSet[ "A_to_alert_reload" ] = [ ];
	initAnimSet[ "A_to_B" ] = [ %corner_standL_trans_A_2_B_v2 ];
	initAnimSet[ "B_to_alert" ] = [ %corner_standL_trans_B_2_alert_v2 ];
	initAnimSet[ "B_to_alert_reload" ] = [ %corner_standL_reload_B_2_alert ];
 	initAnimSet[ "B_to_A" ] = [ %corner_standL_trans_B_2_A_v2 ];
	initAnimSet[ "lean_to_alert" ] = [ %CornerStndL_lean_2_alert ];
	initAnimSet[ "alert_to_lean" ] = [ %CornerStndL_alert_2_lean ];
	initAnimSet[ "look" ] = %corner_standL_look;
	initAnimSet[ "reload" ] = [ %corner_standL_reload_v1 ];// , %corner_standL_reload_v2 );
	initAnimSet[ "grenade_exposed" ] = %corner_standL_grenade_A;
	initAnimSet[ "grenade_safe" ] = %corner_standL_grenade_B;

	initAnimSet[ "blind_fire" ] = [ %corner_standL_blindfire_v1, %corner_standL_blindfire_v2 ];
	
	initAnimSet[ "alert_to_look" ] = %corner_standL_alert_2_look;
	initAnimSet[ "look_to_alert" ] = %corner_standL_look_2_alert;
	initAnimSet[ "look_to_alert_fast" ] = %corner_standl_look_2_alert_fast_v1;
	initAnimSet[ "look_idle" ] = %corner_standL_look_idle;
	initAnimSet[ "stance_change" ] = %CornerCrL_stand_2_alert;

	initAnimSet[ "lean_aim_down" ] = %CornerStndL_lean_aim_2;
	initAnimSet[ "lean_aim_left" ] = %CornerStndL_lean_aim_4;
	initAnimSet[ "lean_aim_straight" ] = %CornerStndL_lean_aim_5;
	initAnimSet[ "lean_aim_right" ] = %CornerStndL_lean_aim_6;
	initAnimSet[ "lean_aim_up" ] = %CornerStndL_lean_aim_8;
	initAnimSet[ "lean_reload" ] = %CornerStndL_lean_reload;

	initAnimSet[ "lean_idle" ] = [ %CornerStndL_lean_idle ];

	initAnimSet[ "lean_single" ] = %CornerStndL_lean_fire;
	//initAnimSet["lean_burst"] = %CornerStndL_lean_autoburst;
	initAnimSet[ "lean_fire" ] = %CornerStndL_lean_auto;

	assert( !isdefined( anim.archetypes["soldier"]["cover_left_stand"] ) );
	anim.archetypes[ "soldier" ]["cover_left_stand"] = initAnimSet;

	initAnimSet = [];
	initAnimSet[ "alert_idle" ] = %CornerCrL_alert_idle;
	initAnimSet[ "alert_idle_twitch" ] = [ ];
	initAnimSet[ "alert_idle_flinch" ] = [ ];

	//initAnimSet["alert_to_C"] = %CornerCrL_trans_alert_2_C;
	//initAnimSet["B_to_C"] = %CornerCrL_trans_B_2_C;
	//initAnimSet["C_to_alert"] = %CornerCrL_trans_C_2_alert;
	//initAnimSet["C_to_B"] = %CornerCrL_trans_C_2_B;
	initAnimSet[ "alert_to_A" ] = [ %CornerCrL_trans_alert_2_A ];
	initAnimSet[ "alert_to_B" ] = [ %CornerCrL_trans_alert_2_B ];
	initAnimSet[ "A_to_alert" ] = [ %CornerCrL_trans_A_2_alert ];
	initAnimSet[ "A_to_alert_reload" ] = [ ];
	initAnimSet[ "A_to_B" ] = [ %CornerCrL_trans_A_2_B ];
	initAnimSet[ "B_to_alert" ] = [ %CornerCrL_trans_B_2_alert ];
 	initAnimSet[ "B_to_alert_reload" ] = [ ];
	initAnimSet[ "B_to_A" ] = [ %CornerCrL_trans_B_2_A ];
	initAnimSet[ "lean_to_alert" ] = [ %CornerCrL_lean_2_alert ];
	initAnimSet[ "alert_to_lean" ] = [ %CornerCrL_alert_2_lean ];
	
	initAnimSet[ "look" ] = %CornerCrL_look_fast;
	initAnimSet[ "reload" ] = [ %CornerCrL_reloadA, %CornerCrL_reloadB ];
	initAnimSet[ "grenade_safe" ] = %CornerCrL_grenadeA;
	initAnimSet[ "grenade_exposed" ] = %CornerCrL_grenadeB;

	initAnimSet[ "alert_to_over" ] = [ %CornerCrL_alert_2_over ];
	initAnimSet[ "over_to_alert" ] = [ %CornerCrL_over_2_alert ];
	initAnimSet[ "over_to_alert_reload" ] = [ ];
	initAnimSet[ "blind_fire" ] = [ ];

	initAnimSet[ "rambo90" ] = [ ];
	initAnimSet[ "rambo45" ] = [ ];

	//initAnimSet["alert_to_look"] = %CornerCrL_alert_idle; // TODO
	//initAnimSet["look_to_alert"] = %CornerCrL_alert_idle; // TODO
	//initAnimSet["look_to_alert_fast"] = %CornerCrL_alert_idle; // TODO
	//initAnimSet["look_idle"] = %CornerCrL_alert_idle; // TODO
	initAnimSet[ "stance_change" ] = %CornerCrL_alert_2_stand;

	initAnimSet[ "lean_aim_down" ] = %CornerCrL_lean_aim_2;
	initAnimSet[ "lean_aim_left" ] = %CornerCrL_lean_aim_4;
	initAnimSet[ "lean_aim_straight" ] = %CornerCrL_lean_aim_5;
	initAnimSet[ "lean_aim_right" ] = %CornerCrL_lean_aim_6;
	initAnimSet[ "lean_aim_up" ] = %CornerCrL_lean_aim_8;

	initAnimSet[ "lean_idle" ] = [ %CornerCrL_lean_idle ];

	initAnimSet[ "lean_single" ] = %CornerCrL_lean_fire;
	initAnimSet[ "lean_fire" ] = %CornerCrL_lean_auto;

	assert( !isdefined( anim.archetypes["soldier"]["cover_left_crouch"] ) );
	anim.archetypes[ "soldier" ]["cover_left_crouch"] = initAnimSet;
}


main()
{
	self.animArrayFuncs = [];
	self.animArrayFuncs[ "hiding" ][ "stand" ] = ::set_animarray_standing_left;
	self.animArrayFuncs[ "hiding" ][ "crouch" ] = ::set_animarray_crouching_left;

	self endon( "killanimscript" );
    animscripts\utility::initialize( "cover_left" );

	animscripts\corner::corner_think( "left", 90 );
}

end_script()
{
	animscripts\corner::end_script_corner();
	animscripts\cover_behavior::end_script( "left" );
}

set_animarray_standing_left()
{
	self.hideYawOffset = 90;
	self.a.array = self lookupAnimArray( "cover_left_stand" );

	if ( isDefined( anim.ramboAnims ) )
	{
		//initAnimSet[ "rambo" ] = array( %corner_standL_rambo_set, %corner_standL_rambo_jam );
		self.a.array[ "rambo90" ] = anim.ramboAnims.coverleft90;
		self.a.array[ "rambo45" ] = anim.ramboAnims.coverleft45;
		self.a.array[ "grenade_rambo" ] = anim.ramboAnims.coverleftgrenade;
	}
}


set_animarray_crouching_left()
{
	self.hideYawOffset = 90;
	self.a.array = self lookupAnimArray( "cover_left_crouch" );
}

