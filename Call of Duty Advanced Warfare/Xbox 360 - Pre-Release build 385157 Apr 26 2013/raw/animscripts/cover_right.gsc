#include maps\_utility;
#include animscripts\Combat_utility;
#include animscripts\utility;
#using_animtree( "generic_human" );

// (Note that animations called left are used with right corner nodes, and vice versa.)

init_animset_cover_right()
{
	initAnimSet = [];


	initAnimSet[ "alert_idle" ] = %corner_standR_alert_idle;
	initAnimSet[ "alert_idle_twitch" ] = [
		%corner_standR_alert_twitch01,
		%corner_standR_alert_twitch02,
		%corner_standR_alert_twitch04,
		%corner_standR_alert_twitch05,
		%corner_standR_alert_twitch06,
		%corner_standR_alert_twitch07
	];
	initAnimSet[ "alert_idle_flinch" ] = [ %corner_standR_flinch, %corner_standR_flinchB ];

	//initAnimSet["alert_to_C"] = %corner_standR_trans_alert_2_C;
	//initAnimSet["B_to_C"] = %corner_standR_trans_B_2_C;
	//initAnimSet["C_to_alert"] = %corner_standR_trans_C_2_alert;
	//initAnimSet["C_to_B"] = %corner_standR_trans_C_2_B;
	initAnimSet[ "alert_to_A" ] = [ %corner_standR_trans_alert_2_A, %corner_standR_trans_alert_2_A_v2 ];
	initAnimSet[ "alert_to_B" ] = [ %corner_standR_trans_alert_2_B, %corner_standR_trans_alert_2_B_v2, %corner_standR_trans_alert_2_B_v3 ];
	initAnimSet[ "A_to_alert" ] = [ %corner_standR_trans_A_2_alert_v2 ];
	initAnimSet[ "A_to_alert_reload" ] = [ ];
	initAnimSet[ "A_to_B" ] = [ %corner_standR_trans_A_2_B, %corner_standR_trans_A_2_B_v2 ];
	initAnimSet[ "B_to_alert" ] = [ %corner_standR_trans_B_2_alert, %corner_standR_trans_B_2_alert_v2, %corner_standR_trans_B_2_alert_v3 ];
 	initAnimSet[ "B_to_alert_reload" ] = [ %corner_standR_reload_B_2_alert ];
	initAnimSet[ "B_to_A" ] = [ %corner_standR_trans_B_2_A, %corner_standR_trans_B_2_A_v2 ];
	initAnimSet[ "lean_to_alert" ] = [ %CornerStndR_lean_2_alert ];
	initAnimSet[ "alert_to_lean" ] = [ %CornerStndR_alert_2_lean ];
	initAnimSet[ "look" ] = %corner_standR_look;
	initAnimSet[ "reload" ] = [ %corner_standR_reload_v1 ];// , %corner_standR_reload_v2 );// v2 isn't finished, it seems
	initAnimSet[ "grenade_exposed" ] = %corner_standR_grenade_A;
	initAnimSet[ "grenade_safe" ] = %corner_standR_grenade_B;

	initAnimSet[ "blind_fire" ] = [ %corner_standR_blindfire_v1, %corner_standR_blindfire_v2 ];

	initAnimSet[ "alert_to_look" ] = %corner_standR_alert_2_look;
	initAnimSet[ "look_to_alert" ] = %corner_standR_look_2_alert;
	initAnimSet[ "look_to_alert_fast" ] = %corner_standR_look_2_alert_fast;
	initAnimSet[ "look_idle" ] = %corner_standR_look_idle;
	initAnimSet[ "stance_change" ] = %CornerCrR_stand_2_alert;

	initAnimSet[ "lean_aim_down" ] = %CornerStndR_lean_aim_2;
	initAnimSet[ "lean_aim_left" ] = %CornerStndR_lean_aim_4;
	initAnimSet[ "lean_aim_straight" ] = %CornerStndR_lean_aim_5;
	initAnimSet[ "lean_aim_right" ] = %CornerStndR_lean_aim_6;
	initAnimSet[ "lean_aim_up" ] = %CornerStndR_lean_aim_8;
	initAnimSet[ "lean_reload" ] = %CornerStndR_lean_reload;

	initAnimSet[ "lean_idle" ] = [ %CornerStndR_lean_idle ];

	initAnimSet[ "lean_single" ] = %CornerStndR_lean_fire;
	//initAnimSet["lean_burst"] = %CornerStndR_lean_autoburst;
	initAnimSet[ "lean_fire" ] = %CornerStndR_lean_auto;

	assert( !isdefined( anim.archetypes["soldier"]["cover_right_stand"] ) );
	anim.archetypes[ "soldier" ]["cover_right_stand"] = initAnimSet;



	initAnimSet = [];

	initAnimSet[ "alert_idle" ] = %CornerCrR_alert_idle;
	//initAnimSet[ "alert_idle_back" ] = %cover_multi_idle_back;
	initAnimSet[ "alert_idle_twitch" ] = [
		%CornerCrR_alert_twitch_v1,
		%CornerCrR_alert_twitch_v2,
		%CornerCrR_alert_twitch_v3
	 ];
	initAnimSet[ "alert_idle_flinch" ] = [ ];

	//initAnimSet["alert_to_C"] = %CornerCrR_trans_alert_2_C;
	//initAnimSet["B_to_C"] = %CornerCrR_trans_B_2_C;
	//initAnimSet["C_to_alert"] = %CornerCrR_trans_C_2_alert;
	//initAnimSet["C_to_B"] = %CornerCrR_trans_C_2_B;
	initAnimSet[ "alert_to_A" ] = [ %CornerCrR_trans_alert_2_A ];
	initAnimSet[ "alert_to_B" ] = [ %CornerCrR_trans_alert_2_B ];
	initAnimSet[ "A_to_alert" ] = [ %CornerCrR_trans_A_2_alert ];
	initAnimSet[ "A_to_alert_reload" ] = [ ];
	initAnimSet[ "A_to_B" ] = [ %CornerCrR_trans_A_2_B ];
	initAnimSet[ "B_to_alert" ] = [ %CornerCrR_trans_B_2_alert ];
 	initAnimSet[ "B_to_alert_reload" ] = [ ];
	initAnimSet[ "B_to_A" ] = [ %CornerCrR_trans_B_2_A ];
	initAnimSet[ "lean_to_alert" ] = [ %CornerCrR_lean_2_alert ];
	initAnimSet[ "alert_to_lean" ] = [ %CornerCrR_alert_2_lean ];
	//initAnimSet[ "alert_back_to_A" ] = [];
	//initAnimSet[ "alert_back_to_B" ] = [];
	//initAnimSet[ "A_to_alert_back" ] = [];
	//initAnimSet[ "B_to_alert_back" ] = [];

	//initAnimSet[ "back_reload" ] = [];
	initAnimSet[ "reload" ] = [ %CornerCrR_reloadA, %CornerCrR_reloadB ];
	initAnimSet[ "grenade_exposed" ] = %CornerCrR_grenadeA;
	initAnimSet[ "grenade_safe" ] = %CornerCrR_grenadeA;// TODO: need a unique animation for this; use the exposed throw because not having it limits the options of the AI too much

	initAnimSet[ "alert_to_over" ] = [ %CornerCrR_alert_2_over ];
	initAnimSet[ "over_to_alert" ] = [ %CornerCrR_over_2_alert ];
	initAnimSet[ "over_to_alert_reload" ] = [ ];

	initAnimSet[ "blind_fire" ] = [ ];

	initAnimSet[ "rambo90" ] = [ ];
	initAnimSet[ "rambo45" ] = [ ];

	initAnimSet[ "alert_to_look" ] = %CornerCrR_alert_2_look;
	initAnimSet[ "look_to_alert" ] = %CornerCrR_look_2_alert;
	initAnimSet[ "look_to_alert_fast" ] = %CornerCrR_look_2_alert_fast;// there's a v2 we could use for this also if we want
	initAnimSet[ "look_idle" ] = %CornerCrR_look_idle;
	initAnimSet[ "stance_change" ] = %CornerCrR_alert_2_stand;

	initAnimSet[ "lean_aim_down" ] = %CornerCrR_lean_aim_2;
	initAnimSet[ "lean_aim_left" ] = %CornerCrR_lean_aim_4;
	initAnimSet[ "lean_aim_straight" ] = %CornerCrR_lean_aim_5;
	initAnimSet[ "lean_aim_right" ] = %CornerCrR_lean_aim_6;
	initAnimSet[ "lean_aim_up" ] = %CornerCrR_lean_aim_8;
	//initAnimSet["lean_reload"] = %CornerStndR_lean_reload;

	initAnimSet[ "lean_idle" ] = [ %CornerCrR_lean_idle ];

	initAnimSet[ "lean_single" ] = %CornerCrR_lean_fire;
	initAnimSet[ "lean_fire" ] = %CornerCrR_lean_auto;

	assert( !isdefined( anim.archetypes["soldier"]["cover_right_crouch"] ) );
	anim.archetypes[ "soldier" ]["cover_right_crouch"] = initAnimSet;

}

main()
{
	self.animArrayFuncs = [];
	self.animArrayFuncs[ "hiding" ][ "stand" ] = ::set_animarray_standing_right;
	self.animArrayFuncs[ "hiding" ][ "crouch" ] = ::set_animarray_crouching_right;

	self endon( "killanimscript" );
    animscripts\utility::initialize( "cover_right" );

	animscripts\corner::corner_think( "right", -90 );
}

end_script()
{
	animscripts\corner::end_script_corner();
	animscripts\cover_behavior::end_script( "right" );
}


set_animarray_standing_right() /* void */
{
	self.hideYawOffset = -90;
	self.a.array = self lookupAnimArray( "cover_right_stand" );

	if ( isDefined( anim.ramboAnims ) )
	{
		//self.a.array[ "rambo" ] = array( %corner_standL_rambo_set, %corner_standL_rambo_jam );
		self.a.array[ "rambo90" ] = anim.ramboAnims.coverright90;
		self.a.array[ "rambo45" ] = anim.ramboAnims.coverright45;
		self.a.array[ "grenade_rambo" ] = anim.ramboAnims.coverrightgrenade;
	}
}

set_animarray_crouching_right()
{
	self.hideYawOffset = -90;
	self.a.array = self lookupAnimArray( "cover_right_crouch" );
}


