#include common_scripts\Utility;

#using_animtree ("generic_human");
setup_dualwield_anim_array()
{
	Assert( self.subclass == "dualwield" );

	subclassType = self.subclass;

	if( IsDefined( anim.anim_array[subclassType] ) )
		return;
	
	self animscripts\anims::clearAnimCache();

	anim.anim_array[subclassType] = [];

	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["fire"]				= %ai_dual_stand_exposed_shoot_semi1; 
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["single"]			= array( %ai_dual_stand_exposed_shoot_semi1 );
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["semi1"]				= %ai_dual_stand_exposed_shoot_semi1;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["semi2"]				= %ai_dual_stand_exposed_shoot_semi2;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["semi3"]				= %ai_dual_stand_exposed_shoot_semi3;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["semi4"]				= %ai_dual_stand_exposed_shoot_semi4;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["semi5"]				= %ai_dual_stand_exposed_shoot_semi5;

	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["straight_level"]	= %ai_dual_stand_exposed_aim5;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["add_aim_up"]		= %ai_dual_stand_exposed_aim8;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["add_aim_down"]		= %ai_dual_stand_exposed_aim2;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["add_aim_left"]		= %ai_dual_stand_exposed_aim4;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["add_aim_right"]		= %ai_dual_stand_exposed_aim6;  

	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["exposed_idle"]				= array( %ai_dual_stand_exposed_idle );
	
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["turn_left_45"]		= %ai_dual_stand_exposed_turn_45_l;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["turn_left_90"]		= %ai_dual_stand_exposed_turn_90_l;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["turn_left_135"]		= %ai_dual_stand_exposed_turn_135_l;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["turn_left_180"]		= %ai_dual_stand_exposed_turn_180_l;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["turn_right_45"]		= %ai_dual_stand_exposed_turn_45_r;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["turn_right_90"]		= %ai_dual_stand_exposed_turn_90_r;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["turn_right_135"]	= %ai_dual_stand_exposed_turn_135_r;
	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["turn_right_180"]	= %ai_dual_stand_exposed_turn_180_r;

	anim.anim_array[subclassType]["combat"]["stand"]["pistol"]["reload"]			= array( %ai_dual_stand_exposed_reload );

	anim.anim_array[subclassType]["pain"]["stand"]["pistol"]["chest"]				= %ai_dual_stand_exposed_pain_chest;
	anim.anim_array[subclassType]["pain"]["stand"]["pistol"]["groin"]				= %ai_dual_stand_exposed_pain_groin;
	anim.anim_array[subclassType]["pain"]["stand"]["pistol"]["head"]				= %ai_dual_stand_exposed_pain_head;
	anim.anim_array[subclassType]["pain"]["stand"]["pistol"]["left_arm"]			= %ai_dual_stand_exposed_pain_chest;
	anim.anim_array[subclassType]["pain"]["stand"]["pistol"]["right_arm"]			= %ai_dual_stand_exposed_pain_groin;
	anim.anim_array[subclassType]["pain"]["stand"]["pistol"]["leg"]					= array( %ai_dual_stand_exposed_pain_leftleg, %ai_dual_stand_exposed_pain_rightleg );

	anim.anim_array[subclassType]["pain"]["stand"]["pistol"]["run_long"]			= array( %ai_dual_run_f_pain_leftleg_stumble, %ai_dual_run_f_pain_rightleg_stumble );
	anim.anim_array[subclassType]["pain"]["stand"]["pistol"]["run_medium"]			= array( %ai_dual_run_f_pain_groin, %ai_dual_run_f_pain_leftleg, %ai_dual_run_f_pain_rightleg );
	anim.anim_array[subclassType]["pain"]["stand"]["pistol"]["run_short"]			= array( %ai_dual_run_f_pain_chest, %ai_dual_run_f_pain_head, %ai_dual_run_f_pain_rightleg, %ai_dual_run_f_pain_leftleg );

	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["reload"]				= %ai_dual_run_f_reload;	
	
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["run_n_gun_f"]			= %ai_dual_run_f;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["run_n_gun_r"]			= %ai_dual_run_r;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["run_n_gun_l"]			= %ai_dual_run_l;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["run_n_gun_b"]			= %ai_dual_strafe_walk_b;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["run_n_gun_l_120"]		= %ai_dual_run_l_120;
	anim.anim_array[subclassType]["move"]["stand"]["rifle"]["run_n_gun_r_120"]		= %ai_dual_run_r_120;
	
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_f_aim_up"]		= %ai_dual_run_f_aim8;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_f_aim_down"]		= %ai_dual_run_f_aim2;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_f_aim_left"]		= %ai_dual_run_f_aim4;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_f_aim_right"]		= %ai_dual_run_f_aim6;

	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_r_aim_up"]		= %ai_dual_run_r_aim8;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_r_aim_down"]		= %ai_dual_run_r_aim2;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_r_aim_left"]		= %ai_dual_run_r_aim4;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_r_aim_right"]		= %ai_dual_run_r_aim6;

	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_l_aim_up"]		= %ai_dual_run_l_aim8;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_l_aim_down"]		= %ai_dual_run_l_aim2;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_l_aim_left"]		= %ai_dual_run_l_aim4;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_l_aim_right"]		= %ai_dual_run_l_aim6;
	
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_l_120_aim_up"]	= %ai_dual_run_l_120_aim8;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_l_120_aim_down"]	= %ai_dual_run_l_120_aim2;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_l_120_aim_left"]	= %ai_dual_run_l_120_aim4;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_l_120_aim_right"]	= %ai_dual_run_l_120_aim6;

	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_r_120_aim_up"]	= %ai_dual_run_r_120_aim8;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_r_120_aim_down"]	= %ai_dual_run_r_120_aim2;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_r_120_aim_left"]	= %ai_dual_run_r_120_aim4;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["add_r_120_aim_right"]	= %ai_dual_run_r_120_aim6;

	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["sprint"]				= array( %ai_dual_sprint_f );
	
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["combat_run_f"]		= %ai_dual_run_lowready_f;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["combat_run_r"]		= %ai_dual_run_r;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["combat_run_l"]		= %ai_dual_run_l;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["combat_run_b"]		= %ai_dual_strafe_walk_b;
	
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["walk_f"]				= %ai_dual_strafe_walk_f;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["walk_r"]				= %ai_dual_run_r;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["walk_l"]				= %ai_dual_run_l;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["walk_b"]				= %ai_dual_strafe_walk_b;
	
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["start_stand_run_f"]	= %ai_dual_run_lowready_f;
	anim.anim_array[subclassType]["move"]["crouch"]["pistol"]["start_stand_run_f"]	= %ai_dual_run_lowready_f;
	anim.anim_array[subclassType]["move"]["prone"]["pistol"]["start_stand_run_f"]	= %ai_dual_run_lowready_f;

	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_walk_f"]		= %ai_dual_strafe_walk_f;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_walk_r"]		= %ai_dual_strafe_walk_l;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_walk_l"]		= %ai_dual_strafe_walk_r;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_walk_b"]		= %ai_dual_strafe_walk_b;

	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_b_aim_up"]		= %ai_dual_strafe_walk_f_aim8;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_b_aim_down"]		= %ai_dual_strafe_walk_f_aim2;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_b_aim_left"]		= %ai_dual_strafe_walk_f_aim4;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_b_aim_right"]	= %ai_dual_strafe_walk_f_aim6;

	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_f_aim_up"]		= %ai_dual_strafe_walk_f_aim8;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_f_aim_down"]		= %ai_dual_strafe_walk_f_aim2;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_f_aim_left"]		= %ai_dual_strafe_walk_f_aim4;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_f_aim_right"]	= %ai_dual_strafe_walk_f_aim6;

	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_l_aim_up"]		= %ai_dual_strafe_walk_f_aim8;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_l_aim_down"]		= %ai_dual_strafe_walk_f_aim2;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_l_aim_left"]		= %ai_dual_strafe_walk_f_aim4;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["tactical_l_aim_right"]	= %ai_dual_strafe_walk_f_aim6;
	
	anim.anim_array[subclassType]["turn"]["stand"]["pistol"]["turn_b_l_180"]			= %ai_dual_run_b2f;
	anim.anim_array[subclassType]["turn"]["stand"]["pistol"]["turn_b_r_180"]			= %ai_dual_run_b2f_a;
	
	// DUALAI_TODO, we need f2b
	
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["fire"]				= %ai_dual_stand_exposed_shoot_semi1;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["single"]				= array( %ai_dual_stand_exposed_shoot_semi1 );
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["semi1"]				= %ai_dual_stand_exposed_shoot_semi1;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["semi2"]				= %ai_dual_stand_exposed_shoot_semi2;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["semi3"]				= %ai_dual_stand_exposed_shoot_semi3;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["semi4"]				= %ai_dual_stand_exposed_shoot_semi4;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["semi5"]				= %ai_dual_stand_exposed_shoot_semi5;

	anim.anim_array[subclassType]["stop"]["stand"]["pistol"]["idle_trans_in"]		= %ai_dual_stand_exposed_aim5;
	anim.anim_array[subclassType]["stop"]["stand"]["pistol"]["idle"]				= array( array( %ai_dual_stand_exposed_aim5 ) );
	
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["exit_exposed"][1]		= %ai_dual_exposed_to_run_1;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["exit_exposed"][2]		= %ai_dual_exposed_to_run_2;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["exit_exposed"][3]		= %ai_dual_exposed_to_run_3;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["exit_exposed"][4]		= %ai_dual_exposed_to_run_4;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["exit_exposed"][6]		= %ai_dual_exposed_to_run_6;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["exit_exposed"][7]		= %ai_dual_exposed_to_run_7;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["exit_exposed"][8]		= %ai_dual_exposed_to_run_8;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["exit_exposed"][9]		= %ai_dual_exposed_to_run_9;
	
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["arrive_exposed"][1]	= %ai_dual_run_to_exposed_1; 
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["arrive_exposed"][2]	= %ai_dual_run_to_exposed_2;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["arrive_exposed"][3]	= %ai_dual_run_to_exposed_3;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["arrive_exposed"][4]	= %ai_dual_run_to_exposed_4;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["arrive_exposed"][6]	= %ai_dual_run_to_exposed_6;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["arrive_exposed"][7]	= %ai_dual_run_to_exposed_7;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["arrive_exposed"][8]	= %ai_dual_run_to_exposed_8;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["arrive_exposed"][9]	= %ai_dual_run_to_exposed_9;
	
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["run_f_to_bR"]			= %ai_dual_run_f_turn_180_r;
	anim.anim_array[subclassType]["move"]["stand"]["pistol"]["run_f_to_bL"]			= %ai_dual_run_f_turn_180_l;
	
	anim.anim_array[subclassType]["turn"]["stand"]["pistol"]["turn_f_l_45"]			= %ai_dual_run_f_turn_45_l;
	anim.anim_array[subclassType]["turn"]["stand"]["pistol"]["turn_f_l_90"]			= %ai_dual_run_f_turn_90_l;
	anim.anim_array[subclassType]["turn"]["stand"]["pistol"]["turn_f_l_135"]		= %ai_dual_run_f_turn_135_l;
	anim.anim_array[subclassType]["turn"]["stand"]["pistol"]["turn_f_l_180"]		= %ai_dual_run_f_turn_180_l;
	anim.anim_array[subclassType]["turn"]["stand"]["pistol"]["turn_f_r_45"]			= %ai_dual_run_f_turn_45_r;
	anim.anim_array[subclassType]["turn"]["stand"]["pistol"]["turn_f_r_90"]			= %ai_dual_run_f_turn_90_r;
	anim.anim_array[subclassType]["turn"]["stand"]["pistol"]["turn_f_r_135"]		= %ai_dual_run_f_turn_135_r;
	anim.anim_array[subclassType]["turn"]["stand"]["pistol"]["turn_f_r_180"]		= %ai_dual_run_f_turn_180_r;	
	
	anim.anim_array[subclassType]["react"]["stand"]["pistol"]["run_head"]		           = %ai_dual_run_f_miss_detect_head; 
	anim.anim_array[subclassType]["react"]["stand"]["pistol"]["run_lower_torso_fast"]      = %ai_dual_run_f_miss_detect_legs;
	anim.anim_array[subclassType]["react"]["stand"]["pistol"]["run_lower_torso_stop"]      = %ai_dual_run_f_miss_detect_torso;
	
	animscripts\anims_table::setup_delta_arrays( anim.anim_array, anim );
}
