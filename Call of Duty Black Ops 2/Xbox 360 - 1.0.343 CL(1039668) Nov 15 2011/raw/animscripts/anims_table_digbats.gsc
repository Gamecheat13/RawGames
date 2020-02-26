#include common_scripts\Utility;

#using_animtree ("generic_human");

setup_digbat_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// DIGBAT_TODO - trans in actually a trans out animation
	array[animType]["stop"]["stand"]["rifle"]["idle_trans_in"]					= %ai_digbat_casual_stand_idle_trans_in;
	array[animType]["stop"]["stand"]["rifle"]["idle"]						= array(
																				array(%ai_digbat_casual_stand_idle, %ai_digbat_casual_stand_idle, %ai_digbat_casual_stand_idle_twitch, %ai_digbat_casual_stand_idle_twitchB),
																				array(%ai_digbat_casual_stand_v2_idle, %ai_digbat_casual_stand_v2_twitch_shift)
																			  );

	// DIGBAT_TODO
	// %ai_digbat_exposed_idle_alert_v4 - Not setup yet
	// %ai_digbat_exposed_idle_alert_v5 - Not setup yet
	// %ai_digbat_exposed_idle_alert_v6 - Not setup yet
	array[animType]["combat"]["stand"]["rifle"]["idle_trans_out"]			= %ai_digbat_casual_stand_idle_trans_in;
	array[animType]["combat"]["stand"]["rifle"]["exposed_idle"]				= array( %ai_digbat_exposed_idle_alert_v2, %ai_digbat_exposed_idle_alert_v3 );
	array[animType]["combat"]["stand"]["rifle"]["exposed_idle_noncombat"]	= array( %ai_digbat_exposed_idle_alert_v1, %ai_digbat_exposed_idle_alert_v2, %ai_digbat_exposed_idle_alert_v3 );
	
	array[animType]["combat"]["stand"]["rifle"]["fire"]						= %ai_digbat_exposed_shoot_auto_v3;
	array[animType]["combat"]["stand"]["rifle"]["single"]					= array( %ai_digbat_exposed_shoot_semi2 );
	array[animType]["combat"]["stand"]["rifle"]["burst2"]					= %ai_digbat_exposed_shoot_burst3; // ( will be stopped after second bullet)
	array[animType]["combat"]["stand"]["rifle"]["burst3"]					= %ai_digbat_exposed_shoot_burst3;
	array[animType]["combat"]["stand"]["rifle"]["burst4"]					= %ai_digbat_exposed_shoot_burst4;
	array[animType]["combat"]["stand"]["rifle"]["burst5"]					= %ai_digbat_exposed_shoot_burst5;
	array[animType]["combat"]["stand"]["rifle"]["burst6"]					= %ai_digbat_exposed_shoot_burst6;
	array[animType]["combat"]["stand"]["rifle"]["semi2"]					= %ai_digbat_exposed_shoot_semi2;
	array[animType]["combat"]["stand"]["rifle"]["semi3"]					= %ai_digbat_exposed_shoot_semi3;
	array[animType]["combat"]["stand"]["rifle"]["semi4"]					= %ai_digbat_exposed_shoot_semi4;
	array[animType]["combat"]["stand"]["rifle"]["semi5"]					= %ai_digbat_exposed_shoot_semi5;
	
	array[animType]["combat"]["stand"]["rifle"]["exposed_rambo"]			= %ai_digbat_stand_exposed_rambo_1;

	array[animType]["combat"]["stand"]["rifle"]["reload"]					= array( %ai_digbat_exposed_reload ); 
	array[animType]["combat"]["stand"]["rifle"]["reload_crouchhide"]		= array( %ai_digbat_exposed_reload );

	// DIGBAT_TODO
	array[animType]["combat"]["stand"]["rifle"]["turn_left_45"]				= %ai_digbat_exposed_tracking_turn45L;
	array[animType]["combat"]["stand"]["rifle"]["turn_left_90"]				= %ai_digbat_exposed_tracking_turn90L;
	array[animType]["combat"]["stand"]["rifle"]["turn_left_135"]			= %ai_digbat_exposed_tracking_turn135L;
	array[animType]["combat"]["stand"]["rifle"]["turn_left_180"]			= %ai_digbat_exposed_tracking_turn180L;
	array[animType]["combat"]["stand"]["rifle"]["turn_right_45"]			= %ai_digbat_exposed_tracking_turn45R;
	array[animType]["combat"]["stand"]["rifle"]["turn_right_90"]			= %ai_digbat_exposed_tracking_turn90R;
	array[animType]["combat"]["stand"]["rifle"]["turn_right_135"]			= %ai_digbat_exposed_tracking_turn135R;
	array[animType]["combat"]["stand"]["rifle"]["turn_right_180"]			= %ai_digbat_exposed_tracking_turn180L;		
	
	array[animType]["combat"]["stand"]["rifle"]["straight_level"]			= %ai_digbat_exposed_aim_5;
	array[animType]["combat"]["stand"]["rifle"]["add_aim_up"]				= %ai_digbat_exposed_aim_8;
	array[animType]["combat"]["stand"]["rifle"]["add_aim_down"]				= %ai_digbat_exposed_aim_2;
	array[animType]["combat"]["stand"]["rifle"]["add_aim_left"]				= %ai_digbat_exposed_aim_4;
	array[animType]["combat"]["stand"]["rifle"]["add_aim_right"]			= %ai_digbat_exposed_aim_6;  
	
	// DIGBAT_TODO - We dont need these
	//array[animType]["combat"]["stand"]["rifle"]["add_turn_aim_up"]		= %ai_digbat_exposed_turn_aim_8;
	//array[animType]["combat"]["stand"]["rifle"]["add_turn_aim_down"]		= %ai_digbat_exposed_turn_aim_2;
	//array[animType]["combat"]["stand"]["rifle"]["add_turn_aim_left"]		= %ai_digbat_exposed_turn_aim_4;
	//array[animType]["combat"]["stand"]["rifle"]["add_turn_aim_right"]		= %ai_digbat_exposed_turn_aim_6;

	// DIGBAT_TODO
	// ai_digbat_exposed_grenadethrowc is not setup
	array[animType]["combat"]["stand"]["rifle"]["grenade_throw_1"]			= %ai_digbat_exposed_grenadeThrowB;
	array[animType]["combat"]["stand"]["rifle"]["grenade_throw_2"]			= %ai_digbat_exposed_grenadeThrowB;

	// DIGBAT_TODO
	array[animType]["combat"]["stand"]["rifle"]["crouch_2_stand"]			= %ai_digbat_exposed_crouch_2_stand;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Crouch Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// DIGBAT_TODO - We dont need these
//	array[animType]["combat"]["crouch"]["rifle"]["straight_level"]			= %ai_digbat_exposed_crouch_aim_5;
//	array[animType]["combat"]["crouch"]["rifle"]["add_aim_up"]				= %ai_digbat_exposed_crouch_aim_8;
//	array[animType]["combat"]["crouch"]["rifle"]["add_aim_down"]			= %ai_digbat_exposed_crouch_aim_2;
//	array[animType]["combat"]["crouch"]["rifle"]["add_aim_left"]			= %ai_digbat_exposed_crouch_aim_4;
//	array[animType]["combat"]["crouch"]["rifle"]["add_aim_right"]			= %ai_digbat_exposed_crouch_aim_6;  
//	
//	array[animType]["combat"]["crouch"]["rifle"]["add_turn_aim_up"]			= %ai_digbat_exposed_crouch_turn_aim_8;
//	array[animType]["combat"]["crouch"]["rifle"]["add_turn_aim_down"]		= %ai_digbat_exposed_crouch_turn_aim_2;
//	array[animType]["combat"]["crouch"]["rifle"]["add_turn_aim_left"]		= %ai_digbat_exposed_crouch_turn_aim_4;
//	array[animType]["combat"]["crouch"]["rifle"]["add_turn_aim_right"]		= %ai_digbat_exposed_crouch_turn_aim_6;
//
//	array[animType]["combat"]["crouch"]["rifle"]["exposed_idle"]			= array( %ai_digbat_exposed_crouch_idle_alert_v1, %ai_digbat_exposed_crouch_idle_alert_v2, %ai_digbat_exposed_crouch_idle_alert_v3 );
//	array[animType]["combat"]["crouch"]["rifle"]["exposed_idle_noncombat"]	= array( %ai_digbat_exposed_crouch_idle_alert_v1, %ai_digbat_exposed_crouch_idle_alert_v2, %ai_digbat_exposed_crouch_idle_alert_v3 );
//
//	array[animType]["combat"]["crouch"]["rifle"]["fire"]					= %ai_digbat_exposed_crouch_shoot_auto_v2;
//	array[animType]["combat"]["crouch"]["rifle"]["single"]					= array( %ai_digbat_exposed_crouch_shoot_semi1 );
//	array[animType]["combat"]["crouch"]["rifle"]["burst2"]					= %ai_digbat_exposed_crouch_shoot_burst3; // ( will be stopped after second bullet)
//	array[animType]["combat"]["crouch"]["rifle"]["burst3"]					= %ai_digbat_exposed_crouch_shoot_burst3;
//	array[animType]["combat"]["crouch"]["rifle"]["burst4"]					= %ai_digbat_exposed_crouch_shoot_burst4;
//	array[animType]["combat"]["crouch"]["rifle"]["burst5"]					= %ai_digbat_exposed_crouch_shoot_burst5;
//	array[animType]["combat"]["crouch"]["rifle"]["burst6"]					= %ai_digbat_exposed_crouch_shoot_burst6;
//	array[animType]["combat"]["crouch"]["rifle"]["semi2"]					= %ai_digbat_exposed_crouch_shoot_semi2;
//	array[animType]["combat"]["crouch"]["rifle"]["semi3"]					= %ai_digbat_exposed_crouch_shoot_semi3;
//	array[animType]["combat"]["crouch"]["rifle"]["semi4"]					= %ai_digbat_exposed_crouch_shoot_semi4;
//	array[animType]["combat"]["crouch"]["rifle"]["semi5"]					= %ai_digbat_exposed_crouch_shoot_semi5;
//
//	array[animType]["combat"]["crouch"]["rifle"]["reload"]					= array( %ai_digbat_exposed_crouch_reload );
//
//	array[animType]["combat"]["crouch"]["rifle"]["turn_left_45"]			= %ai_digbat_exposed_crouch_turn_left;
//	array[animType]["combat"]["crouch"]["rifle"]["turn_left_90"]			= %ai_digbat_exposed_crouch_turn_left;
//	array[animType]["combat"]["crouch"]["rifle"]["turn_left_135"]			= %ai_digbat_exposed_crouch_turn_left;
//	array[animType]["combat"]["crouch"]["rifle"]["turn_left_180"]			= %ai_digbat_exposed_crouch_turn_left;
//	array[animType]["combat"]["crouch"]["rifle"]["turn_right_45"]			= %ai_digbat_exposed_crouch_turn_right;
//	array[animType]["combat"]["crouch"]["rifle"]["turn_right_90"]			= %ai_digbat_exposed_crouch_turn_right;
//	array[animType]["combat"]["crouch"]["rifle"]["turn_right_135"]			= %ai_digbat_exposed_crouch_turn_right;
//	array[animType]["combat"]["crouch"]["rifle"]["turn_right_180"]			= %ai_digbat_exposed_crouch_turn_right;	

	array[animType]["combat"]["crouch"]["rifle"]["crouch_2_stand"]			= %ai_digbat_exposed_crouch_2_stand;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Crouch Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Exposed Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["death"]["crouch"]["rifle"]["front"]					= %ai_digbat_exposed_crouch_death_fetal;
	array[animType]["death"]["crouch"]["rifle"]["front_2"]					= %ai_digbat_exposed_crouch_death_twist;
	array[animType]["death"]["crouch"]["rifle"]["front_3"]					= %ai_digbat_exposed_crouch_death_flip;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Exposed Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Exposed Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["rifle"]["big"]						= %ai_digbat_exposed_pain_dropgun;
	array[animType]["pain"]["stand"]["rifle"]["drop_gun"]					= %ai_digbat_exposed_pain_dropgun;
	array[animType]["pain"]["stand"]["rifle"]["chest"]						= %ai_digbat_exposed_pain_back;
	array[animType]["pain"]["stand"]["rifle"]["groin"]						= %ai_digbat_exposed_pain_groin;
	array[animType]["pain"]["stand"]["rifle"]["left_arm"]					= %ai_digbat_exposed_pain_left_arm;
	array[animType]["pain"]["stand"]["rifle"]["right_arm"]					= %ai_digbat_exposed_pain_right_arm;
	array[animType]["pain"]["stand"]["rifle"]["leg"]						= %ai_digbat_exposed_pain_leg;
	
	// DIGBAT_TODO - We dont need these animations
//	array[animType]["pain"]["crouch"]["rifle"]["chest"]						= %ai_digbat_exposed_crouch_pain_chest;
//	array[animType]["pain"]["crouch"]["rifle"]["head"]						= %ai_digbat_exposed_crouch_pain_headsnap;
//	array[animType]["pain"]["crouch"]["rifle"]["left_arm"]					= %ai_digbat_exposed_crouch_pain_left_arm;
//	array[animType]["pain"]["crouch"]["rifle"]["right_arm"]					= %ai_digbat_exposed_crouch_pain_right_arm;
//	array[animType]["pain"]["crouch"]["rifle"]["flinch"]					= %ai_digbat_exposed_crouch_pain_flinch;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Exposed Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// DIGBAT_TODO - new animations
	//array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][2]			= %ai_digbat_run_2_stand_f;
	//array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][4]			= %ai_digbat_run_2_stand_l;
	//array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][6]			= %ai_digbat_run_2_stand_r;
	//array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][8]			= %ai_digbat_run_2_stand_b;
	
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][1]			= %ai_digbat_exposed_arrival_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][2]			= %ai_digbat_exposed_arrival_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][3]			= %ai_digbat_exposed_arrival_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][4]			= %ai_digbat_exposed_arrival_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][6]			= %ai_digbat_exposed_arrival_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][7]			= %ai_digbat_exposed_arrival_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][8]			= %ai_digbat_exposed_arrival_8;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][9]			= %ai_digbat_exposed_arrival_9;

	// DIGBAT_TODO - we dont need these
	//array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][2]	= %ai_digbat_run_2_crouch_f;
	//array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][4]	= %ai_digbat_run_2_crouch_l;
	//array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][6]	= %ai_digbat_run_2_crouch_r;
	//array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][8]	= %ai_digbat_run_2_crouch_b;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Exit Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	ai_digbat_run_2_stand_f
//	ai_digbat_run_2_stand_l
//	ai_digbat_run_2_stand_r
//	ai_digbat_run_2_stand_b


	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][1]			= %ai_digbat_exposed_exit_1;	
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][2]			= %ai_digbat_exposed_exit_2;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][3]			= %ai_digbat_exposed_exit_3;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][4]			= %ai_digbat_exposed_exit_4;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][6]			= %ai_digbat_exposed_exit_6;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][7]			= %ai_digbat_exposed_exit_7;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][8]			= %ai_digbat_exposed_exit_8;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][9]			= %ai_digbat_exposed_exit_9;

	// DIGBAT_TODO - we dont need these
	//array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][2]		= %ai_digbat_crouch_2_run_b;
	//array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][4]		= %ai_digbat_crouch_2_run_L;
	//array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][6]		= %ai_digbat_crouch_2_run_R;
	//array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][8]		= %ai_digbat_crouch_2_run_F;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Exit Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Turn Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// DIGBAT_TODO - we dont need these
	//array[animType]["turn"]["stand"]["rifle"]["turn_f_l_45"]				= %ai_digbat_run_lowready_f_turn_45l;
	//aray[animType]["turn"]["stand"]["rifle"]["turn_f_l_90"]				= %ai_digbat_run_lowready_f_turn_90l;
	//array[animType]["turn"]["stand"]["rifle"]["turn_f_l_180"]				= %ai_digbat_run_lowready_f_turn_180l;
	//array[animType]["turn"]["stand"]["rifle"]["turn_f_r_45"]				= %ai_digbat_run_lowready_f_turn_45r;
	//array[animType]["turn"]["stand"]["rifle"]["turn_f_r_90"]				= %ai_digbat_run_lowready_f_turn_90r;
	//array[animType]["turn"]["stand"]["rifle"]["turn_f_r_180"]				= %ai_digbat_run_lowready_f_turn_180r;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Turn Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Run Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["rifle"]["combat_run_f"]				= %ai_digbat_run_lowready_f;
	array[animType]["move"]["stand"]["rifle"]["combat_run_r"]				= %ai_digbat_run_lowready_r;
	array[animType]["move"]["stand"]["rifle"]["combat_run_l"]				= %ai_digbat_run_lowready_l;
	array[animType]["move"]["stand"]["rifle"]["combat_run_b"]				= %ai_digbat_run_lowready_b;
	
	array[animType]["move"]["stand"]["rifle"]["reload"]						= array( %ai_digbat_run_twitch_1, %ai_digbat_run_twitch_2, %run_lowready_reload );
	
	//array[animType]["move"]["stand"]["rifle"]["run_n_gun_f"]				= %ai_viet_run_n_gun_F;
	//array[animType]["move"]["stand"]["rifle"]["run_n_gun_r"]				= %ai_viet_run_n_gun_R;
	//array[animType]["move"]["stand"]["rifle"]["run_n_gun_l"]				= %ai_viet_run_n_gun_L;
	//array[animType]["move"]["stand"]["rifle"]["run_n_gun_b"]				= %ai_viet_run_n_gun_B;

	//array[animType]["move"]["stand"]["rifle"]["add_f_aim_up"]				= %ai_viet_run_n_gun_F_aim_8;
	//array[animType]["move"]["stand"]["rifle"]["add_f_aim_down"]			= %ai_viet_run_n_gun_F_aim_2;
	//array[animType]["move"]["stand"]["rifle"]["add_f_aim_left"]			= %ai_viet_run_n_gun_F_aim_4;
	//array[animType]["move"]["stand"]["rifle"]["add_f_aim_right"]			= %ai_viet_run_n_gun_F_aim_6;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Run Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	return array;
}


setup_melee_digbat_anim_array()
{
	self animscripts\anims::clearAnimCache();

	if( !IsDefined( self.anim_array ) )
	{
		self.anim_array = [];
	}

	self.anim_array[self.animType]["combat"]["stand"]["none"]["melee"]					= %ai_digbat_melee_1; 
	self.anim_array[self.animType]["combat"]["stand"]["none"]["stand_2_melee"]			= %ai_digbat_melee_1;
	self.anim_array[self.animType]["combat"]["stand"]["none"]["run_2_melee"]			= %ai_digbat_melee_1;

	self.anim_array[self.animType]["combat"]["stand"]["none"]["run_n_gun_f"]			= %ai_digbat_melee_run_f;
	self.anim_array[self.animType]["combat"]["stand"]["none"]["combat_run_f"]			= %ai_digbat_melee_run_f;

	self.anim_array[self.animType]["stop"]["stand"]["none"]["idle_trans_in"]			= %ai_digbat_melee_casual_idle;
	self.anim_array[self.animType]["stop"]["stand"]["none"]["idle"]						= array( array(%ai_digbat_melee_casual_idle) );
	self.anim_array[self.animType]["combat"]["stand"]["none"]["exposed_idle"]			= array( %ai_digbat_melee_idle );
	self.anim_array[self.animType]["combat"]["stand"]["none"]["exposed_idle_noncombat"]	= array( %ai_digbat_melee_idle );
	self.anim_array[self.animType]["combat"]["stand"]["none"]["straight_level"]			= %ai_digbat_melee_casual_idle;
}



