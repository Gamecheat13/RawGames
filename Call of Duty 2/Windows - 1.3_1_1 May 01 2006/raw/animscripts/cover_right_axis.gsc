#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");

// (Note that animations called left are used with right corner nodes, and vice versa.)
main()
{
	self endon("killanimscript");
    self trackScriptState( "Cover Right", "code" );
    animscripts\utility::initialize("cover_right");
    
    array["stand"] = ::Anims_standing;
    array["crouch"] = ::Anims_crouching;
	animscripts\corner_axis::coverThink( array );
}

nowall()
{
	self endon("killanimscript");
    self trackScriptState( "Cover Right", "code" );
    animscripts\utility::initialize("cover_right");
    
    array["stand"] = ::Anims_standing_nowall;
    array["crouch"] = ::Anims_crouching_nowall;
	animscripts\corner_axis::coverThink( array );
}

getHideYawOffset()
{
	return 270;
}

Anims_Standing()
{
	animarray["look_func"]					= animscripts\corner_axis::lookForEnemyAndIdleOriginDoesntMove;
	animarray["direction"]					= "right";
	animarray["hideYawOffset"]				= getHideYawOffset();
	animarray["angle_aim"]["left"]			= -45;
	animarray["angle_aim"]["right"]			= 45;
	animarray["anim_blend"]["left"]			= %corner_45_left;
	animarray["anim_blend"]["right"]		= %corner_45_right;
	animarray["angle_step_out"]["left"]		= 45;
	animarray["angle_step_out"]["right"]	= -45;
	animarray["angle_step_out"]["straight"]	= 0;
	animarray["angle_step_out"]["behind"]	= 180;

	animarray["anim_behind_to_alert"]		= %corner_right_stand_aimbehind2alert;
	animarray["anim_left_to_alert"]			= %corner_right_stand_aimleft2alert;
	animarray["anim_right_to_alert"]		= %corner_right_stand_aimright2alert;
	animarray["anim_straight_to_alert"]		= %corner_right_stand_aimstraight2alert;
	animarray["anim_alert_to_behind"]		= %corner_right_stand_alert2aimbehind;
	animarray["anim_alert_to_left"]			= %corner_right_stand_alert2aimleft;
	animarray["anim_alert_to_right"]		= %corner_right_stand_alert2aimright;
	animarray["anim_alert_to_straight"]		= %corner_right_stand_alert2aimstraight;
	animarray["anim_straight_to_left"]		= %corner_right_stand_straight2left;
	animarray["anim_straight_to_right"]		= %corner_right_stand_straight2right;
	animarray["anim_right_to_straight"]		= %corner_right_stand_right2straight;
	animarray["anim_right_to_behind"]		= %corner_right_stand_right2behind;
	animarray["anim_left_to_straight"]		= %corner_right_stand_left2straight;
	animarray["anim_behind_to_right"]		= %corner_right_stand_behind2right;

	animarray["anim_aim"]["left"]			= %corner_right_stand_aim_45left;
	animarray["anim_aim"]["right"]			= %corner_right_stand_aim_45right;
	animarray["anim_autofire"]["left"]		= %corner_right_stand_autofire_45left;
	animarray["anim_autofire"]["right"]		= %corner_right_stand_autofire_45right;
	animarray["autofire_end"]["left"]		= %corner_right_stand_autofireend_45left;
	animarray["autofire_end"]["right"]		= %corner_right_stand_autofireend_45right;
	animarray["anim_semiautofire"]["left"]	= %corner_right_stand_semiauto_45left;
	animarray["anim_semiautofire"]["right"]	= %corner_right_stand_semiauto_45right;
	animarray["anim_boltfire"]["left"]		= %corner_right_stand_semiauto_45left;
	animarray["anim_boltfire"]["right"]		= %corner_right_stand_semiauto_45right;
	animarray["anim_rechamber"]["left"]		= %corner_right_stand_rechamber_45left;
	animarray["anim_rechamber"]["right"]	= %corner_right_stand_rechamber_45right;

	animarray["anim_alert"]					= %corner_right_stand_alertidle;
	animarray["anim_transition_into_pose"]	= %corner_right_crouch2stand;
	animarray["anim_alert2rambo"]			= %corner2rambo_left;
	animarray["anim_rambo2alert"]			= %rambo2corner_left;
	animarray["anim_look_idle"][0]			= %corner_right_stand_alertidle;
	animarray["anim_look_idle"][1]			= %corner_right_stand_alerttwitch1;
	animarray["anim_look_idle"][2]			= %corner_right_stand_alerttwitch2;
	animarray["anim_look_idle"]["weight"][0] = 3.5;
	animarray["anim_look_idle"]["weight"][1] = 1;
	animarray["anim_look_idle"]["weight"][2] = 1;
	animarray["anim_reload"][0]				= %corner_right_stand_alertreload;
	animarray["anim_reload"][1]				= %corner_right_stand_alertreload_helmet;

	animarray["anim_alert_to_look"]["hat"]		= %corner_right_stand_alert2look;
	animarray["anim_look_to_alert_fast"]["hat"]	= %corner_right_stand_look_duck;
	animarray["anim_look_to_alert"]["hat"]		= %corner_right_stand_look2alert;
	animarray["anim_look"]["hat"]				= %corner_right_stand_alertlookidle;

	animarray["anim_alert_to_look"]["no_hat"]	= %corner_right_stand_alert2quicklook;
	animarray["anim_look_to_alert"]["no_hat"]	= %corner_right_stand_quicklook2alert;
	animarray["anim_look"]["no_hat"]			= %corner_right_stand_quicklookidle;
	
	animarray["offset_grenade"]				= (32,0,64);
	animarray["anim_grenade"]				= %corner_right_stand_alertgrenaderight;
	animarray["gunhand_grenade"]			= "left";
	animarray["stance"] 					= "stand";
	
	self.animarray = animArray;
}

Anims_Standing_nowall()
{
	animarray["look_func"]					= animscripts\corner_axis::lookForEnemyAndIdleOriginDoesntMove;
	animarray["direction"]					= "right";
	animarray["hideYawOffset"]				= getHideYawOffset();
	animarray["angle_aim"]["left"]			= -45;
	animarray["angle_aim"]["right"]			= 45;
	animarray["anim_blend"]["left"]			= %corner_45_left;
	animarray["anim_blend"]["right"]		= %corner_45_right;
	animarray["angle_step_out"]["left"]		= 45;
	animarray["angle_step_out"]["right"]	= -45;
	animarray["angle_step_out"]["straight"]	= 0;
	animarray["angle_step_out"]["behind"]	= 180;

	animarray["anim_behind_to_alert"]		= %corner_right_stand_aimbehind2alert;
	animarray["anim_left_to_alert"]			= %corner_right_stand_aimleft2alert;
	animarray["anim_right_to_alert"]		= %corner_right_stand_aimright2alert;
	animarray["anim_straight_to_alert"]		= %corner_right_stand_aimstraight2alert;
	animarray["anim_alert_to_behind"]		= %corner_right_stand_alert2aimbehind;
	animarray["anim_alert_to_left"]			= %corner_right_stand_alert2aimleft;
	animarray["anim_alert_to_right"]		= %corner_right_stand_alert2aimright;
	animarray["anim_alert_to_straight"]		= %corner_right_stand_alert2aimstraight;
	animarray["anim_straight_to_left"]		= %corner_right_stand_straight2left;
	animarray["anim_straight_to_right"]		= %corner_right_stand_straight2right;
	animarray["anim_right_to_straight"]		= %corner_right_stand_right2straight;
	animarray["anim_right_to_behind"]		= %corner_right_stand_right2behind;
	animarray["anim_left_to_straight"]		= %corner_right_stand_left2straight;
	animarray["anim_behind_to_right"]		= %corner_right_stand_behind2right;

	animarray["anim_aim"]["left"]			= %corner_right_stand_aim_45left;
	animarray["anim_aim"]["right"]			= %corner_right_stand_aim_45right;
	animarray["anim_autofire"]["left"]		= %corner_right_stand_autofire_45left;
	animarray["anim_autofire"]["right"]		= %corner_right_stand_autofire_45right;
	animarray["autofire_end"]["left"]		= %corner_right_stand_autofireend_45left;
	animarray["autofire_end"]["right"]		= %corner_right_stand_autofireend_45right;
	animarray["anim_semiautofire"]["left"]	= %corner_right_stand_semiauto_45left;
	animarray["anim_semiautofire"]["right"]	= %corner_right_stand_semiauto_45right;
	animarray["anim_boltfire"]["left"]		= %corner_right_stand_semiauto_45left;
	animarray["anim_boltfire"]["right"]		= %corner_right_stand_semiauto_45right;
	animarray["anim_rechamber"]["left"]		= %corner_right_stand_rechamber_45left;
	animarray["anim_rechamber"]["right"]	= %corner_right_stand_rechamber_45right;

	animarray["anim_alert2rambo"]			= %corner2rambo_left;
	animarray["anim_rambo2alert"]			= %rambo2corner_left;
	animarray["offset_grenade"]				= (32,0,64);
	animarray["gunhand_grenade"]			= "left";
	animarray["stance"] 					= "stand";
	

	animarray["look_func"]					= animscripts\corner_axis::lookForEnemyAndIdleOriginMoves;
	animarray["anim_transition_into_pose"]	= %corner_right_crouch2nowall_r_stand_alert;
	animarray["anim_look_idle"]				= undefined;
	animarray["anim_alert_to_straight"]		= %corner_nowall_r_stand_alert2aimstraight;
	animarray["anim_straight_to_alert"]		= %corner_nowall_r_stand_aimstraight2alert;
	animarray["anim_alert_to_right"]		= %corner_nowall_r_stand_alert2right;
	animarray["anim_right_to_alert"]		= %corner_nowall_r_stand_right2alert;
	animarray["anim_alert_to_left"]			= %corner_nowall_r_stand_alert2left;
	animarray["anim_left_to_alert"]			= %corner_nowall_r_stand_left2alert;

	animarray["anim_alert"]					= %corner_nowall_r_stand_idle;

	animarray["anim_look"]["hat"]				= %corner_nowall_r_stand_lookidle;
	animarray["anim_alert_to_look"]["hat"]		= %corner_nowall_r_stand_alert2look;
	animarray["anim_look_to_alert"]["hat"]		= %corner_nowall_r_stand_look2alert;
	animarray["anim_look"]["no_hat"]			= %corner_nowall_r_stand_lookidle;
	animarray["anim_alert_to_look"]["no_hat"]	= %corner_nowall_r_stand_alert2look;
	animarray["anim_look_to_alert"]["no_hat"]	= %corner_nowall_r_stand_look2alert;

	animarray["anim_look_idle"][0]			= %corner_nowall_r_stand_idle;
	animarray["anim_look_idle"]["weight"][0] = 3.5;
	animarray["anim_look_idle"][1]			= %corner_nowall_r_stand_idle;
	animarray["anim_look_idle"]["weight"][1] = 3.5;
	animarray["anim_look_idle"][2]			= %corner_nowall_r_stand_idle;
	animarray["anim_look_idle"]["weight"][2] = 3.5;
	animarray["anim_reload"][0]				= %corner_nowall_r_stand_reload;
	animarray["anim_grenade"]				= %corner_nowall_r_stand_grenade_throw;

	self.animarray = animArray;
}

Anims_Crouching()
{
	animarray["look_func"]					= animscripts\corner_axis::lookForEnemyAndIdleOriginMoves;
	animarray["direction"]					= "right";
	animarray["hideYawOffset"]				= getHideYawOffset();
	animarray["angle_aim"]["left"]			= -38.5;
	animarray["angle_aim"]["right"]			= 46.5;
	animarray["anim_blend"]["left"]			= %corner_45_left;
	animarray["anim_blend"]["right"]		= %corner_45_right;
	animarray["angle_step_out"]["left"]		= 45;
	animarray["angle_step_out"]["right"]	= -45;
	animarray["angle_step_out"]["straight"]	= 0;
	animarray["angle_step_out"]["behind"]	= 180;

	animarray["anim_behind_to_alert"]		= %corner_right_crouch_aimbehind2alert;
	animarray["anim_left_to_alert"]			= %corner_right_crouch_aimleft2alert;
	animarray["anim_right_to_alert"]		= %corner_right_crouch_aimright2alert;
	animarray["anim_straight_to_alert"]		= %corner_right_crouch_aimstraight2alert;
	animarray["anim_alert_to_behind"]		= %corner_right_crouch_alert2aimbehind;
	animarray["anim_alert_to_left"]			= %corner_right_crouch_alert2aimleft;
	animarray["anim_alert_to_right"]		= %corner_right_crouch_alert2aimright;
	animarray["anim_alert_to_straight"]		= %corner_right_crouch_alert2aimstraight;
	animarray["anim_straight_to_left"]		= %corner_right_crouch_straight2left;
	animarray["anim_straight_to_right"]		= %corner_right_crouch_straight2right;
	animarray["anim_right_to_straight"]		= %corner_right_crouch_right2straight;
	animarray["anim_right_to_behind"]		= %corner_right_crouch_right2behind;
	animarray["anim_left_to_straight"]		= %corner_right_crouch_left2straight;
	animarray["anim_behind_to_right"]		= %corner_right_crouch_behind2right;

	animarray["anim_aim"]["left"]			= %corner_right_crouch_aim_45left;
	animarray["anim_aim"]["right"]			= %corner_right_crouch_aim_45right;
	animarray["anim_autofire"]["left"]		= %corner_right_crouch_autofire_45left;
	animarray["anim_autofire"]["right"]		= %corner_right_crouch_autofire_45right;
	animarray["autofire_end"]["left"]		= %corner_right_crouch_autoend_45left;
	animarray["autofire_end"]["right"]		= %corner_right_crouch_autoend_45right;
	animarray["anim_semiautofire"]["left"]	= %corner_right_crouch_semiauto_45left;
	animarray["anim_semiautofire"]["right"]	= %corner_right_crouch_semiauto_45right;
	animarray["anim_boltfire"]["left"]		= %corner_right_crouch_semiauto_45left;
	animarray["anim_boltfire"]["right"]		= %corner_right_crouch_semiauto_45right;
	animarray["anim_rechamber"]["left"]		= %corner_right_crouch_rechamber_45left;
	animarray["anim_rechamber"]["right"]	= %corner_right_crouch_rechamber_45right;

	animarray["anim_alert"]					= %corner_right_crouch_alertidle;
	animarray["anim_transition_into_pose"]	= %corner_right_stand2crouch;
	animarray["anim_alert2rambo"]			= %corner2rambo_left;
	animarray["anim_rambo2alert"]			= %rambo2corner_left;

	animarray["anim_look"]["hat"]				= %corner_right_crouch_alertlookidle;
	animarray["anim_alert_to_look"]["hat"]		= %corner_right_crouch_alert2look;
	animarray["anim_look_to_alert"]["hat"]		= %corner_right_crouch_look2alert;
	animarray["anim_look"]["no_hat"]			= %corner_right_crouch_alertlookidle;
	animarray["anim_alert_to_look"]["no_hat"]	= %corner_right_crouch_alert2look;
	animarray["anim_look_to_alert"]["no_hat"]	= %corner_right_crouch_look2alert;

	animarray["anim_look_idle"][0]			= %corner_right_crouch_alertidle;
	animarray["anim_look_idle"][1]			= %corner_right_crouch_alerttwitch1;
	animarray["anim_look_idle"][2]			= %corner_right_crouch_alerttwitch2;
	animarray["anim_look_idle"]["weight"][0] = 3.5;
	animarray["anim_look_idle"]["weight"][1] = 1;
	animarray["anim_look_idle"]["weight"][2] = 1;
	animarray["anim_reload"][0]				= %corner_right_crouch_alertreload;
	animarray["offset_grenade"]				= (32,0,32);
	animarray["anim_grenade"]				= %corner_right_crouch_alertgrenaderight;
	animarray["gunhand_grenade"]			= "left";
	animarray["stance"] 					= "crouch";

	self.animarray = animArray;
}

Anims_Crouching_nowall()
{
	animarray["look_func"]					= animscripts\corner_axis::lookForEnemyAndIdleOriginMoves;
	animarray["direction"]					= "right";
	animarray["hideYawOffset"]				= getHideYawOffset();
	animarray["angle_aim"]["left"]			= -45;
	animarray["angle_aim"]["right"]			= 45;
	animarray["anim_blend"]["left"]			= %corner_45_left;
	animarray["anim_blend"]["right"]		= %corner_45_right;
	animarray["angle_step_out"]["left"]		= 45;
	animarray["angle_step_out"]["right"]	= -45;
	animarray["angle_step_out"]["straight"]	= 0;
	animarray["angle_step_out"]["behind"]	= 180;

	animarray["anim_behind_to_alert"]		= %corner_right_crouch_aimbehind2alert;
	animarray["anim_left_to_alert"]			= %corner_right_crouch_aimleft2alert;
	animarray["anim_right_to_alert"]		= %corner_right_crouch_aimright2alert;
	animarray["anim_straight_to_alert"]		= %corner_right_crouch_aimstraight2alert;
	animarray["anim_alert_to_behind"]		= %corner_right_crouch_alert2aimbehind;
	animarray["anim_alert_to_left"]			= %corner_right_crouch_alert2aimleft;
	animarray["anim_alert_to_right"]		= %corner_right_crouch_alert2aimright;
	animarray["anim_alert_to_straight"]		= %corner_right_crouch_alert2aimstraight;
	animarray["anim_straight_to_left"]		= %corner_right_crouch_straight2left;
	animarray["anim_straight_to_right"]		= %corner_right_crouch_straight2right;
	animarray["anim_right_to_straight"]		= %corner_right_crouch_right2straight;
	animarray["anim_right_to_behind"]		= %corner_right_crouch_right2behind;
	animarray["anim_left_to_straight"]		= %corner_right_crouch_left2straight;
	animarray["anim_behind_to_right"]		= %corner_right_crouch_behind2right;

	animarray["anim_aim"]["left"]			= %corner_right_crouch_aim_45left;
	animarray["anim_aim"]["right"]			= %corner_right_crouch_aim_45right;
	animarray["anim_autofire"]["left"]		= %corner_right_crouch_autofire_45left;
	animarray["anim_autofire"]["right"]		= %corner_right_crouch_autofire_45right;
	animarray["autofire_end"]["left"]		= %corner_right_crouch_autoend_45left;
	animarray["autofire_end"]["right"]		= %corner_right_crouch_autoend_45right;
	animarray["anim_semiautofire"]["left"]	= %corner_right_crouch_semiauto_45left;
	animarray["anim_semiautofire"]["right"]	= %corner_right_crouch_semiauto_45right;
	animarray["anim_boltfire"]["left"]		= %corner_right_crouch_semiauto_45left;
	animarray["anim_boltfire"]["right"]		= %corner_right_crouch_semiauto_45right;
	animarray["anim_rechamber"]["left"]		= %corner_right_crouch_rechamber_45left;
	animarray["anim_rechamber"]["right"]	= %corner_right_crouch_rechamber_45right;

	animarray["anim_alert"]					= %corner_right_crouch_alertidle;
	animarray["anim_transition_into_pose"]	= %corner_right_stand2crouch;
	animarray["anim_alert2rambo"]			= %corner2rambo_left;
	animarray["anim_rambo2alert"]			= %rambo2corner_left;

	animarray["anim_look"]["hat"]				= %corner_right_crouch_alertlookidle;
	animarray["anim_alert_to_look"]["hat"]		= %corner_right_crouch_alert2look;
	animarray["anim_look_to_alert"]["hat"]		= %corner_right_crouch_look2alert;
	animarray["anim_look"]["no_hat"]			= %corner_right_crouch_alertlookidle;
	animarray["anim_alert_to_look"]["no_hat"]	= %corner_right_crouch_alert2look;
	animarray["anim_look_to_alert"]["no_hat"]	= %corner_right_crouch_look2alert;

	animarray["anim_look_idle"][0]			= %corner_right_crouch_alertidle;
	animarray["anim_look_idle"][1]			= %corner_right_crouch_alerttwitch1;
	animarray["anim_look_idle"][2]			= %corner_right_crouch_alerttwitch2;
	animarray["anim_look_idle"]["weight"][0] = 3.5;
	animarray["anim_look_idle"]["weight"][1] = 1;
	animarray["anim_look_idle"]["weight"][2] = 1;
	animarray["anim_reload"][0]				= %corner_right_crouch_alertreload;
	animarray["offset_grenade"]				= (32,0,32);
	animarray["anim_grenade"]				= %corner_right_crouch_alertgrenaderight;
	animarray["gunhand_grenade"]			= "left";
	animarray["stance"] 					= "crouch";

	// no wall
	animarray["anim_transition_into_pose"]	= %corner_nowall_r_stand2corner_crouch_r;

	self.animarray = animArray;
}
