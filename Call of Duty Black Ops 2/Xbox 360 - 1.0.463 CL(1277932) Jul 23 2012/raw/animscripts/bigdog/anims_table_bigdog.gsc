#include common_scripts\Utility;

#using_animtree ("bigdog");

setup_bigdog_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );

	// locomotion
	array[animType]["move"]["stand"]["none"]["walk_f"]						= %ai_claw_mk2_walk_f;
	array[animType]["move"]["stand"]["none"]["walk_b"]						= %ai_claw_mk2_walk_b;
	array[animType]["move"]["stand"]["none"]["walk_r"]						= %ai_claw_mk2_walk_l;
	array[animType]["move"]["stand"]["none"]["walk_l"]						= %ai_claw_mk2_walk_r;
	
	array[animType]["move"]["stand"]["none"]["walk_f_frontleft"]			= %ai_claw_mk2_walk_f_gib_frontleft_leg;
	array[animType]["move"]["stand"]["none"]["walk_b_frontleft"]			= %ai_claw_mk2_walk_b_gib_frontleft_leg;
	array[animType]["move"]["stand"]["none"]["walk_r_frontleft"]			= %ai_claw_mk2_walk_r_gib_frontleft_leg;
	array[animType]["move"]["stand"]["none"]["walk_l_frontleft"]			= %ai_claw_mk2_walk_l_gib_frontleft_leg;
	
	array[animType]["move"]["stand"]["none"]["walk_f_frontright"]			= %ai_claw_mk2_walk_f_gib_frontright_leg;
	array[animType]["move"]["stand"]["none"]["walk_b_frontright"]			= %ai_claw_mk2_walk_b_gib_frontright_leg;
	array[animType]["move"]["stand"]["none"]["walk_r_frontright"]			= %ai_claw_mk2_walk_r_gib_frontright_leg;
	array[animType]["move"]["stand"]["none"]["walk_l_frontright"]			= %ai_claw_mk2_walk_l_gib_frontright_leg;
	
	array[animType]["move"]["stand"]["none"]["walk_f_rearleft"]				= %ai_claw_mk2_walk_f_gib_rearleft_leg;
	array[animType]["move"]["stand"]["none"]["walk_b_rearleft"]				= %ai_claw_mk2_walk_b_gib_rearleft_leg;
	array[animType]["move"]["stand"]["none"]["walk_r_rearleft"]				= %ai_claw_mk2_walk_r_gib_rearleft_leg;
	array[animType]["move"]["stand"]["none"]["walk_l_rearleft"]				= %ai_claw_mk2_walk_l_gib_rearleft_leg;

	array[animType]["move"]["stand"]["none"]["walk_f_rearright"]			= %ai_claw_mk2_walk_f_gib_rearright_leg;
	array[animType]["move"]["stand"]["none"]["walk_b_rearright"]			= %ai_claw_mk2_walk_b_gib_rearright_leg;
	array[animType]["move"]["stand"]["none"]["walk_r_rearright"]			= %ai_claw_mk2_walk_r_gib_rearright_leg;
	array[animType]["move"]["stand"]["none"]["walk_l_rearright"]			= %ai_claw_mk2_walk_l_gib_rearright_leg;
	
	// hunker idles
	array[animType]["stop"]["stand"]["none"]["hunker_idle"]					= %ai_claw_mk2_hunker_down_idle;
	array[animType]["stop"]["stand"]["none"]["hunker_idle_fl_rr"]			= %ai_claw_mk2_hunker_down_idle_gib_diag_fl_rr;
	array[animType]["stop"]["stand"]["none"]["hunker_idle_fr_rl"]			= %ai_claw_mk2_hunker_down_idle_gib_diag_fr_rl;
	array[animType]["stop"]["stand"]["none"]["hunker_idle_frontleft"]		= %ai_claw_mk2_hunker_down_idle_gib_frontleft_leg;
	array[animType]["stop"]["stand"]["none"]["hunker_idle_frontlegs"]		= %ai_claw_mk2_hunker_down_idle_gib_frontlegs;
	array[animType]["stop"]["stand"]["none"]["hunker_idle_frontright"]		= %ai_claw_mk2_hunker_down_idle_gib_frontright_leg;
	array[animType]["stop"]["stand"]["none"]["hunker_idle_leftlegs"]		= %ai_claw_mk2_hunker_down_idle_gib_leftlegs;
	array[animType]["stop"]["stand"]["none"]["hunker_idle_rearleft"]		= %ai_claw_mk2_hunker_down_idle_gib_rearleft_leg;
	array[animType]["stop"]["stand"]["none"]["hunker_idle_rearlegs"]		= %ai_claw_mk2_hunker_down_idle_gib_rearlegs;
	array[animType]["stop"]["stand"]["none"]["hunker_idle_rearright"]		= %ai_claw_mk2_hunker_down_idle_gib_rearright_leg;
	array[animType]["stop"]["stand"]["none"]["hunker_idle_rightlegs"]		= %ai_claw_mk2_hunker_down_idle_gib_rightlegs;
	
	// hunker down
	array[animType]["stop"]["stand"]["none"]["hunker_down"]					= %ai_claw_mk2_hunker_down;
	array[animType]["stop"]["stand"]["none"]["hunker_down_frontleft"]		= %ai_claw_mk2_idle_gib_frontleft_leg_2_hunker_down;
	array[animType]["stop"]["stand"]["none"]["hunker_down_frontright"]		= %ai_claw_mk2_idle_gib_frontright_leg_2_hunker_down;
	array[animType]["stop"]["stand"]["none"]["hunker_down_rearleft"]		= %ai_claw_mk2_idle_gib_rearleft_leg_2_hunker_down;
	array[animType]["stop"]["stand"]["none"]["hunker_down_rearright"]		= %ai_claw_mk2_idle_gib_rearright_leg_2_hunker_down;
	array[animType]["stop"]["stand"]["none"]["hunker_down_fl_rr"]			= %ai_claw_mk2_hunker_down;
	array[animType]["stop"]["stand"]["none"]["hunker_down_fr_rl"]			= %ai_claw_mk2_hunker_down;
	array[animType]["stop"]["stand"]["none"]["hunker_down_leftlegs"]		= %ai_claw_mk2_hunker_down;
	array[animType]["stop"]["stand"]["none"]["hunker_down_rightlegs"]		= %ai_claw_mk2_hunker_down;
	array[animType]["stop"]["stand"]["none"]["hunker_down_frontlegs"]		= %ai_claw_mk2_hunker_down;
	array[animType]["stop"]["stand"]["none"]["hunker_down_rearlegs"]		= %ai_claw_mk2_hunker_down;
	
	// hunker up
	array[animType]["stop"]["stand"]["none"]["hunker_up"]					= %ai_claw_mk2_hunker_up_legsonly;
	array[animType]["stop"]["stand"]["none"]["hunker_up_turn"]				= %ai_claw_mk2_hunker_up;
	array[animType]["stop"]["stand"]["none"]["hunker_up_frontleft"]			= %ai_claw_mk2_idle_hunker_up_2_gib_frontleft_leg;
	array[animType]["stop"]["stand"]["none"]["hunker_up_frontright"]		= %ai_claw_mk2_idle_hunker_up_2_gib_frontright_leg;
	array[animType]["stop"]["stand"]["none"]["hunker_up_rearleft"]			= %ai_claw_mk2_idle_hunker_up_2_gib_rearleft_leg;
	array[animType]["stop"]["stand"]["none"]["hunker_up_rearright"]			= %ai_claw_mk2_idle_hunker_up_2_gib_rearright_leg;
	
	// move transitions
	array[animType]["move"]["stand"]["none"]["idle_to_walk"]				= %ai_claw_mk2_idle_2_walk;
	array[animType]["move"]["stand"]["none"]["walk_to_idle"]				= %ai_claw_mk2_walk_2_idle;
	
	// turns
	array[animType]["stop"]["stand"]["none"]["turn_up"]						= %ai_claw_mk2_piston_turn_up;
	array[animType]["stop"]["stand"]["none"]["turn_down"]					= %ai_claw_mk2_piston_turn_down;

	// combat
	array[animType]["combat"]["stand"]["none"]["fire"]						= %ai_claw_mk2_fire;
	array[animType]["combat"]["stand"]["none"]["fire_frontlegs"]			= %ai_claw_mk2_fire;
	array[animType]["combat"]["stand"]["none"]["fire_rearlegs"]				= %ai_claw_mk2_fire;

	// stop
	array[animType]["stop"]["stand"]["none"]["idle"]						= %ai_claw_mk2_idle;
	array[animType]["stop"]["stand"]["none"]["idle_frontleft"]				= %ai_claw_mk2_idle_gib_frontleft_leg;
	array[animType]["stop"]["stand"]["none"]["idle_frontright"]				= %ai_claw_mk2_idle_gib_frontright_leg;
	array[animType]["stop"]["stand"]["none"]["idle_rearleft"]				= %ai_claw_mk2_idle_gib_rearleft_leg;
	array[animType]["stop"]["stand"]["none"]["idle_rearright"]				= %ai_claw_mk2_idle_gib_rearright_leg;
	
	// flinch
	array[animType]["pain"]["stand"]["none"]["hunker_down_flinch_f"]		= %ai_claw_mk2_hunker_down_flinch_f;
	array[animType]["pain"]["stand"]["none"]["hunker_down_flinch_b"]		= %ai_claw_mk2_hunker_down_flinch_b;
	array[animType]["pain"]["stand"]["none"]["hunker_down_flinch_r"]		= %ai_claw_mk2_hunker_down_flinch_r;
	array[animType]["pain"]["stand"]["none"]["hunker_down_flinch_l"]		= %ai_claw_mk2_hunker_down_flinch_l;

	// pain	
	array[animType]["pain"]["stand"]["none"]["stun_recover_f"]				= %ai_claw_mk2_stun_recover_f;
	array[animType]["pain"]["stand"]["none"]["stun_recover_b"]				= %ai_claw_mk2_stun_recover_b;
	array[animType]["pain"]["stand"]["none"]["stun_recover_r"]				= %ai_claw_mk2_stun_recover_r;
	array[animType]["pain"]["stand"]["none"]["stun_recover_l"]				= %ai_claw_mk2_stun_recover_l;
	
	array[animType]["pain"]["stand"]["none"]["stun_recover_f_frontleft"]	= %ai_claw_mk2_stun_recover_f_gib_frontleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_f_frontright"]	= %ai_claw_mk2_stun_recover_f_gib_frontright_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_f_rearleft"]		= %ai_claw_mk2_stun_recover_f_gib_rearleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_f_rearright"]	= %ai_claw_mk2_stun_recover_f_gib_rearright_leg;
	
	array[animType]["pain"]["stand"]["none"]["stun_recover_b_frontleft"]	= %ai_claw_mk2_stun_recover_b_gib_frontleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_b_frontright"]	= %ai_claw_mk2_stun_recover_b_gib_frontright_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_b_rearleft"]		= %ai_claw_mk2_stun_recover_b_gib_rearleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_b_rearright"]	= %ai_claw_mk2_stun_recover_b_gib_rearright_leg;
	
	array[animType]["pain"]["stand"]["none"]["stun_recover_r_frontleft"]	= %ai_claw_mk2_stun_recover_r_gib_frontleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_r_frontright"]	= %ai_claw_mk2_stun_recover_r_gib_frontright_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_r_rearleft"]		= %ai_claw_mk2_stun_recover_r_gib_rearleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_r_rearright"]	= %ai_claw_mk2_stun_recover_r_gib_rearright_leg;
	
	array[animType]["pain"]["stand"]["none"]["stun_recover_l_frontleft"]	= %ai_claw_mk2_stun_recover_l_gib_frontleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_l_frontright"]	= %ai_claw_mk2_stun_recover_l_gib_frontright_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_l_rearleft"]		= %ai_claw_mk2_stun_recover_l_gib_rearleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_l_rearright"]	= %ai_claw_mk2_stun_recover_l_gib_rearright_leg;
	
	array[animType]["pain"]["stand"]["none"]["stun_fall_fl_rr"]				= %ai_claw_mk2_pain_frontleft_rearright_hunkerdown;
	array[animType]["pain"]["stand"]["none"]["stun_fall_frontlegs"]			= %ai_claw_mk2_pain_frontlegs_hunkerdown;
	array[animType]["pain"]["stand"]["none"]["stun_fall_fr_rl"]				= %ai_claw_mk2_pain_frontright_rearleft_hunkerdown;
	array[animType]["pain"]["stand"]["none"]["stun_fall_leftlegs"]			= %ai_claw_mk2_pain_leftlegs_hunkerdown;
	array[animType]["pain"]["stand"]["none"]["stun_fall_rearlegs"]			= %ai_claw_mk2_pain_rearlegs_hunkerdown;
	array[animType]["pain"]["stand"]["none"]["stun_fall_rightlegs"]			= %ai_claw_mk2_pain_rightlegs_hunkerdown;

	array[animType]["pain"]["stand"]["none"]["body_pain_f"]					= %ai_claw_mk2_pain_f;
	array[animType]["pain"]["stand"]["none"]["body_pain_b"]					= %ai_claw_mk2_pain_b;
	array[animType]["pain"]["stand"]["none"]["body_pain_r"]					= %ai_claw_mk2_pain_r;
	array[animType]["pain"]["stand"]["none"]["body_pain_l"]					= %ai_claw_mk2_pain_l;

	array[animType]["pain"]["stand"]["none"]["leg_pain_fl"]					= %ai_claw_mk2_pain_leg_leftfront;
	array[animType]["pain"]["stand"]["none"]["leg_pain_fr"]					= %ai_claw_mk2_pain_leg_rightfront;
	array[animType]["pain"]["stand"]["none"]["leg_pain_rl"]					= %ai_claw_mk2_pain_leg_leftrear;
	array[animType]["pain"]["stand"]["none"]["leg_pain_rr"]					= %ai_claw_mk2_pain_leg_rightrear;

	// death
	array[animType]["death"]["stand"]["none"]["death_f"]					= %ai_claw_mk2_stun_fall_f;
	array[animType]["death"]["stand"]["none"]["death_b"]					= %ai_claw_mk2_stun_fall_b;
	array[animType]["death"]["stand"]["none"]["death_r"]					= %ai_claw_mk2_stun_fall_r;
	array[animType]["death"]["stand"]["none"]["death_l"]					= %ai_claw_mk2_stun_fall_l;

	return array;
}