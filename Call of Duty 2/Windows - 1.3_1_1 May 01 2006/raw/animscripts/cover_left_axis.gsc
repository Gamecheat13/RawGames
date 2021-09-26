#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");

// (Note that animations called left are used with right corner nodes, and vice versa.)
main()
{
	self endon("killanimscript");
    self trackScriptState( "Cover Left", "code" );
    animscripts\utility::initialize("cover_left");
    
    array["stand"] = ::Anims_standing;
    array["crouch"] = ::Anims_crouching;
	animscripts\corner_axis::coverThink( array );
}

nowall()
{
	self endon("killanimscript");
    self trackScriptState( "Cover Left", "code" );
    animscripts\utility::initialize("cover_left");
    
    array["stand"] = ::Anims_standing_nowall;
    array["crouch"] = ::Anims_crouching_nowall;
	animscripts\corner_axis::coverThink( array );
}


getHideYawOffset()
{
	return 90;
}

Anims_Standing()
{
	animarray["look_func"]					= animscripts\corner_axis::lookForEnemyAndIdleOriginDoesntMove;
	animarray["direction"]					= "left";
	animarray["hideYawOffset"]				= getHideYawOffset();
	animarray["angle_aim"]["left"]			= -45;
	animarray["angle_aim"]["right"]			= 45;
	animarray["anim_blend"]["left"]			= %corner_45_left;
	animarray["anim_blend"]["right"]		= %corner_45_right;
	animarray["angle_step_out"]["left"]		= 45;
	animarray["angle_step_out"]["right"]	= -45;
	animarray["angle_step_out"]["straight"]	= 0;
	animarray["angle_step_out"]["behind"]	= 180;

	animarray["anim_behind_to_alert"]		= %corner_left_stand_aimbehind2alert;
	animarray["anim_right_to_alert"]		= %corner_left_stand_aimright2alert;
	animarray["anim_left_to_alert"]			= %corner_left_stand_aimleft2alert;
	animarray["anim_straight_to_alert"]		= %corner_left_stand_aimstraight2alert;
	animarray["anim_alert_to_behind"]		= %corner_left_stand_alert2aimbehind;
	animarray["anim_alert_to_right"]		= %corner_left_stand_alert2aimright;
	animarray["anim_alert_to_left"]			= %corner_left_stand_alert2aimleft;
	animarray["anim_alert_to_straight"]		= %corner_left_stand_alert2aimstraight;
	animarray["anim_straight_to_right"]		= %corner_left_stand_straight2right;
	animarray["anim_straight_to_left"]		= %corner_left_stand_straight2left;
	animarray["anim_left_to_straight"]		= %corner_left_stand_left2straight;
	animarray["anim_left_to_behind"]		= %corner_left_stand_left2behind;
	animarray["anim_right_to_straight"]		= %corner_left_stand_right2straight;
	animarray["anim_behind_to_left"]		= %corner_left_stand_behind2left;

	animarray["anim_aim"]["left"]			= %corner_left_stand_aim_45left;
	animarray["anim_aim"]["right"]			= %corner_left_stand_aim_45right;
	animarray["anim_autofire"]["left"]		= %corner_left_stand_autofire_45left;
	animarray["anim_autofire"]["right"]		= %corner_left_stand_autofire_45right;
	animarray["autofire_end"]["left"]		= %corner_left_stand_autofireend_45left;
	animarray["autofire_end"]["right"]		= %corner_left_stand_autofireend_45right;
	animarray["anim_semiautofire"]["left"]	= %corner_left_stand_semiauto_45left;
	animarray["anim_semiautofire"]["right"]	= %corner_left_stand_semiauto_45right;
	animarray["anim_boltfire"]["left"]		= %corner_left_stand_semiauto_45left;
	animarray["anim_boltfire"]["right"]		= %corner_left_stand_semiauto_45right;
	animarray["anim_rechamber"]["left"]		= %corner_left_stand_rechamber_45left;
	animarray["anim_rechamber"]["right"]	= %corner_left_stand_rechamber_45right;

	animarray["anim_alert"]					= %corner_left_stand_alertidle;
	animarray["anim_transition_into_pose"]	= %corner_left_crouch2stand;
	animarray["anim_look_idle"][0]			= %corner_left_stand_alertidle;
	animarray["anim_look_idle"]["weight"][0] = 3.5;
	animarray["anim_look_idle"][1]			= %corner_left_stand_alerttwitch1;
	animarray["anim_look_idle"]["weight"][1] = 1;
	animarray["anim_look_idle"][2]			= %corner_left_stand_alerttwitch2;
	animarray["anim_look_idle"]["weight"][2] = 1;

	animarray["anim_alert_to_look"]["hat"]		= %corner_left_stand_alert2look;
	animarray["anim_look_to_alert_fast"]["hat"]	= %corner_left_stand_look_duck;
	animarray["anim_look_to_alert"]["hat"]		= %corner_left_stand_look2alert;
	animarray["anim_look"]["hat"]				= %corner_left_stand_alertlookidle;

	animarray["anim_alert_to_look"]["no_hat"]	= %corner_left_stand_alert2quicklook;
	animarray["anim_look_to_alert"]["no_hat"]	= %corner_left_stand_quicklook2alert;
	animarray["anim_look"]["no_hat"]			= %corner_left_stand_quicklookidle;
	
	
	animarray["anim_reload"][0]				= %corner_left_stand_alertreload;
	animarray["anim_reload"][1]				= %corner_left_stand_alertreload_helmet;
	

	animarray["offset_grenade"]				= (32,20,64);
	animarray["anim_grenade"]				= %corner_left_stand_alertgrenadeleft;
	animarray["gunhand_grenade"]			= "left";
	animarray["stance"] 					= "stand";

	self.animarray = animArray;
}

Anims_Standing_nowall()
{
	animarray["direction"]					= "left";
	animarray["hideYawOffset"]				= getHideYawOffset();
	animarray["angle_aim"]["left"]			= -45;
	animarray["angle_aim"]["right"]			= 45;
	animarray["anim_blend"]["left"]			= %corner_45_left;
	animarray["anim_blend"]["right"]		= %corner_45_right;
	animarray["angle_step_out"]["left"]		= 45;
	animarray["angle_step_out"]["right"]	= -45;
	animarray["angle_step_out"]["straight"]	= 0;
	animarray["angle_step_out"]["behind"]	= 180;

	animarray["anim_behind_to_alert"]		= %corner_left_stand_aimbehind2alert;
	animarray["anim_right_to_alert"]		= %corner_left_stand_aimright2alert;
	animarray["anim_left_to_alert"]			= %corner_left_stand_aimleft2alert;
	animarray["anim_straight_to_alert"]		= %corner_left_stand_aimstraight2alert;
	animarray["anim_alert_to_behind"]		= %corner_left_stand_alert2aimbehind;
	animarray["anim_alert_to_right"]		= %corner_left_stand_alert2aimright;
	animarray["anim_alert_to_left"]			= %corner_left_stand_alert2aimleft;
	animarray["anim_alert_to_straight"]		= %corner_left_stand_alert2aimstraight;
	animarray["anim_straight_to_right"]		= %corner_left_stand_straight2right;
	animarray["anim_straight_to_left"]		= %corner_left_stand_straight2left;
	animarray["anim_left_to_straight"]		= %corner_left_stand_left2straight;
	animarray["anim_left_to_behind"]		= %corner_left_stand_left2behind;
	animarray["anim_right_to_straight"]		= %corner_left_stand_right2straight;
	animarray["anim_behind_to_left"]		= %corner_left_stand_behind2left;

	animarray["anim_aim"]["left"]			= %corner_left_stand_aim_45left;
	animarray["anim_aim"]["right"]			= %corner_left_stand_aim_45right;
	animarray["anim_autofire"]["left"]		= %corner_left_stand_autofire_45left;
	animarray["anim_autofire"]["right"]		= %corner_left_stand_autofire_45right;
	animarray["autofire_end"]["left"]		= %corner_left_stand_autofireend_45left;
	animarray["autofire_end"]["right"]		= %corner_left_stand_autofireend_45right;
	animarray["anim_semiautofire"]["left"]	= %corner_left_stand_semiauto_45left;
	animarray["anim_semiautofire"]["right"]	= %corner_left_stand_semiauto_45right;
	animarray["anim_boltfire"]["left"]		= %corner_left_stand_semiauto_45left;
	animarray["anim_boltfire"]["right"]		= %corner_left_stand_semiauto_45right;
	animarray["anim_rechamber"]["left"]		= %corner_left_stand_rechamber_45left;
	animarray["anim_rechamber"]["right"]	= %corner_left_stand_rechamber_45right;

	animarray["offset_grenade"]				= (32,20,64);
	animarray["gunhand_grenade"]			= "left";
	animarray["stance"] 					= "stand";

	animarray["look_func"]					= animscripts\corner_axis::lookForEnemyAndIdleOriginMoves;
	animarray["anim_transition_into_pose"]	= %corner_left_crouch2nowall_l_stand_alert;
	animarray["anim_look_idle"]				= undefined;
	animarray["anim_alert_to_straight"]		= %corner_nowall_l_stand_alert2aimstraight;
	animarray["anim_straight_to_alert"]		= %corner_nowall_l_stand_aimstraight2alert;

	animarray["anim_alert_to_right"]		= %corner_nowall_l_stand_alert2right;
	animarray["anim_right_to_alert"]		= %corner_nowall_l_stand_right2alert;
	animarray["anim_alert_to_left"]			= %corner_nowall_l_stand_alert2left;
	animarray["anim_left_to_alert"]			= %corner_nowall_l_stand_left2alert;

	animarray["anim_alert"]					= %corner_nowall_l_stand_idle;
	
	animarray["anim_look"]["hat"]				= %corner_nowall_l_stand_lookidle;
	animarray["anim_alert_to_look"]["hat"]		= %corner_nowall_l_stand_alert2look;
	animarray["anim_look_to_alert"]["hat"]		= %corner_nowall_l_stand_look2alert;
	animarray["anim_look"]["no_hat"]			= %corner_nowall_l_stand_lookidle;
	animarray["anim_alert_to_look"]["no_hat"]	= %corner_nowall_l_stand_alert2look;
	animarray["anim_look_to_alert"]["no_hat"]	= %corner_nowall_l_stand_look2alert;

	animarray["anim_look_idle"][0]			= %corner_nowall_l_stand_idle;
	animarray["anim_look_idle"]["weight"][0] = 3.5;
	animarray["anim_look_idle"][1]			= %corner_nowall_l_stand_idle;
	animarray["anim_look_idle"]["weight"][1] = 3.5;
	animarray["anim_look_idle"][2]			= %corner_nowall_l_stand_idle;
	animarray["anim_look_idle"]["weight"][2] = 3.5;
	animarray["anim_reload"][0]				= %corner_nowall_l_stand_reload;
	animarray["anim_grenade"]				= %corner_nowall_l_stand_grenade_throw;

	self.animarray = animArray;
}


Anims_Crouching()
{
	animarray["look_func"]					= animscripts\corner_axis::lookForEnemyAndIdleOriginMoves;
	animarray["direction"]					= "left";
	animarray["hideYawOffset"]				= getHideYawOffset();
	animarray["angle_aim"]["left"]			= -46.8;
	animarray["angle_aim"]["right"]			= 43.5;
	animarray["anim_blend"]["left"]			= %corner_45_left;
	animarray["anim_blend"]["right"]		= %corner_45_right;
	animarray["angle_step_out"]["left"]		= 45;
	animarray["angle_step_out"]["right"]	= -45;
	animarray["angle_step_out"]["straight"]	= 0;
	animarray["angle_step_out"]["behind"]	= 180;

	animarray["anim_behind_to_alert"]		= %corner_left_crouch_aimbehind2alert;
	animarray["anim_right_to_alert"]		= %corner_left_crouch_aimright2alert;
	animarray["anim_left_to_alert"]			= %corner_left_crouch_aimleft2alert;
	animarray["anim_straight_to_alert"]		= %corner_left_crouch_aimstraight2alert;
	animarray["anim_alert_to_behind"]		= %corner_left_crouch_alert2aimbehind;
	animarray["anim_alert_to_right"]		= %corner_left_crouch_alert2aimright;
	animarray["anim_alert_to_left"]			= %corner_left_crouch_alert2aimleft;
	animarray["anim_alert_to_straight"]		= %corner_left_crouch_alert2aimstraight;
	animarray["anim_straight_to_right"]		= %corner_left_crouch_straight2right;
	animarray["anim_straight_to_left"]		= %corner_left_crouch_straight2left;
	animarray["anim_left_to_straight"]		= %corner_left_crouch_left2straight;
	animarray["anim_left_to_behind"]		= %corner_left_crouch_left2behind;
	animarray["anim_right_to_straight"]		= %corner_left_crouch_right2straight;
	animarray["anim_behind_to_left"]		= %corner_left_crouch_behind2left;

	animarray["anim_aim"]["left"]			= %corner_left_crouch_aim_45left;
	animarray["anim_aim"]["right"]			= %corner_left_crouch_aim_45right;
	animarray["anim_autofire"]["left"]		= %corner_left_crouch_autofire_45left;
	animarray["anim_autofire"]["right"]		= %corner_left_crouch_autofire_45right;
	animarray["autofire_end"]["left"]		= %corner_left_crouch_autoend_45left;
	animarray["autofire_end"]["right"]		= %corner_left_crouch_autoend_45right;
	animarray["anim_semiautofire"]["left"]	= %corner_left_crouch_semiauto_45left;
	animarray["anim_semiautofire"]["right"]	= %corner_left_crouch_semiauto_45right;
	animarray["anim_boltfire"]["left"]		= %corner_left_crouch_semiauto_45left;
	animarray["anim_boltfire"]["right"]		= %corner_left_crouch_semiauto_45right;
	animarray["anim_rechamber"]["left"]		= %corner_left_crouch_rechamber_45left;
	animarray["anim_rechamber"]["right"]	= %corner_left_crouch_rechamber_45right;

	animarray["anim_alert"]					= %corner_left_crouch_alertidle;
	animarray["anim_transition_into_pose"]	= %corner_left_stand2crouch;

	animarray["anim_look"]["hat"]				= %corner_left_crouch_alertlookidle;
	animarray["anim_alert_to_look"]["hat"]		= %corner_left_crouch_alert2look;
	animarray["anim_look_to_alert"]["hat"]		= %corner_left_crouch_look2alert;
	animarray["anim_look"]["no_hat"]			= %corner_left_crouch_alertlookidle;
	animarray["anim_alert_to_look"]["no_hat"]	= %corner_left_crouch_alert2look;
	animarray["anim_look_to_alert"]["no_hat"]	= %corner_left_crouch_look2alert;

	animarray["anim_look_idle"][0]			= %corner_left_crouch_alertidle;
	animarray["anim_look_idle"][1]			= %corner_left_crouch_alerttwitch1;
	animarray["anim_look_idle"][2]			= %corner_left_crouch_alerttwitch2;
	animarray["anim_look_idle"]["weight"][0] = 3.5;
	animarray["anim_look_idle"]["weight"][1] = 1;
	animarray["anim_look_idle"]["weight"][2] = 1;
	animarray["anim_reload"][0]				= %corner_left_crouch_alertreload;
	animarray["offset_grenade"]				= (32,20,32);
	animarray["anim_grenade"]				= %corner_left_crouch_alertgrenadeleft;
	animarray["gunhand_grenade"]			= "left";
	animarray["stance"] 					= "crouch";
	self.animarray = animArray;
}

Anims_Crouching_nowall()
{
	animarray["look_func"]					= animscripts\corner_axis::lookForEnemyAndIdleOriginMoves;
	animarray["direction"]					= "left";
	animarray["hideYawOffset"]				= getHideYawOffset();
	animarray["angle_aim"]["left"]			= -45;
	animarray["angle_aim"]["right"]			= 45;
	animarray["anim_blend"]["left"]			= %corner_45_left;
	animarray["anim_blend"]["right"]		= %corner_45_right;
	animarray["angle_step_out"]["left"]		= 45;
	animarray["angle_step_out"]["right"]	= -45;
	animarray["angle_step_out"]["straight"]	= 0;
	animarray["angle_step_out"]["behind"]	= 180;

	animarray["anim_behind_to_alert"]		= %corner_left_crouch_aimbehind2alert;
	animarray["anim_right_to_alert"]		= %corner_left_crouch_aimright2alert;
	animarray["anim_left_to_alert"]			= %corner_left_crouch_aimleft2alert;
	animarray["anim_straight_to_alert"]		= %corner_left_crouch_aimstraight2alert;
	animarray["anim_alert_to_behind"]		= %corner_left_crouch_alert2aimbehind;
	animarray["anim_alert_to_right"]		= %corner_left_crouch_alert2aimright;
	animarray["anim_alert_to_left"]			= %corner_left_crouch_alert2aimleft;
	animarray["anim_alert_to_straight"]		= %corner_left_crouch_alert2aimstraight;
	animarray["anim_straight_to_right"]		= %corner_left_crouch_straight2right;
	animarray["anim_straight_to_left"]		= %corner_left_crouch_straight2left;
	animarray["anim_left_to_straight"]		= %corner_left_crouch_left2straight;
	animarray["anim_left_to_behind"]		= %corner_left_crouch_left2behind;
	animarray["anim_right_to_straight"]		= %corner_left_crouch_right2straight;
	animarray["anim_behind_to_left"]		= %corner_left_crouch_behind2left;

	animarray["anim_aim"]["left"]			= %corner_left_crouch_aim_45left;
	animarray["anim_aim"]["right"]			= %corner_left_crouch_aim_45right;
	animarray["autofire_end"]["left"]		= %corner_left_crouch_autoend_45left;
	animarray["autofire_end"]["right"]		= %corner_left_crouch_autoend_45right;
	animarray["anim_autofire"]["left"]		= %corner_left_crouch_autofire_45left;
	animarray["anim_autofire"]["right"]		= %corner_left_crouch_autofire_45right;
	animarray["anim_semiautofire"]["left"]	= %corner_left_crouch_semiauto_45left;
	animarray["anim_semiautofire"]["right"]	= %corner_left_crouch_semiauto_45right;
	animarray["anim_boltfire"]["left"]		= %corner_left_crouch_semiauto_45left;
	animarray["anim_boltfire"]["right"]		= %corner_left_crouch_semiauto_45right;
	animarray["anim_rechamber"]["left"]		= %corner_left_crouch_rechamber_45left;
	animarray["anim_rechamber"]["right"]	= %corner_left_crouch_rechamber_45right;

	animarray["anim_alert"]					= %corner_left_crouch_alertidle;
	animarray["anim_transition_into_pose"]	= %corner_left_stand2crouch;
	animarray["anim_look"]["hat"]				= %corner_left_crouch_alertlookidle;
	animarray["anim_alert_to_look"]["hat"]		= %corner_left_crouch_alert2look;
	animarray["anim_look_to_alert"]["hat"]		= %corner_left_crouch_look2alert;
	animarray["anim_look"]["no_hat"]			= %corner_left_crouch_alertlookidle;
	animarray["anim_alert_to_look"]["no_hat"]	= %corner_left_crouch_alert2look;
	animarray["anim_look_to_alert"]["no_hat"]	= %corner_left_crouch_look2alert;

	animarray["anim_look_idle"][0]			= %corner_left_crouch_alertidle;
	animarray["anim_look_idle"][1]			= %corner_left_crouch_alerttwitch1;
	animarray["anim_look_idle"][2]			= %corner_left_crouch_alerttwitch2;
	animarray["anim_look_idle"]["weight"][0] = 3.5;
	animarray["anim_look_idle"]["weight"][1] = 1;
	animarray["anim_look_idle"]["weight"][2] = 1;
	animarray["anim_reload"][0]				= %corner_left_crouch_alertreload;
	animarray["offset_grenade"]				= (32,20,32);
	animarray["anim_grenade"]				= %corner_left_crouch_alertgrenadeleft;
	animarray["gunhand_grenade"]			= "left";
	animarray["stance"] 					= "crouch";

	// no wall
	animarray["anim_transition_into_pose"]	= %corner_nowall_l_stand2corner_crouch_l;
	self.animarray = animArray;
}
