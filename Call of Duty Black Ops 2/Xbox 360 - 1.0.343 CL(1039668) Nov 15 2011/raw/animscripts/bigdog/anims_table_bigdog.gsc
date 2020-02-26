#include common_scripts\Utility;

#using_animtree ("bigdog");

setup_bigdog_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );

	// locomotion
	array[animType]["move"]["stand"]["none"]["walk_f"]						= %ai_claw_walk_f;
	array[animType]["move"]["stand"]["none"]["walk_b"]						= %ai_claw_walk_b;
	array[animType]["move"]["stand"]["none"]["walk_r"]						= %ai_claw_walk_l;
	array[animType]["move"]["stand"]["none"]["walk_l"]						= %ai_claw_walk_r;
	
	array[animType]["move"]["stand"]["none"]["walk_f_frontlegs"]			= %ai_claw_walk_f_gib_frontlegs;
	array[animType]["move"]["stand"]["none"]["walk_b_frontlegs"]			= %ai_claw_walk_b_gib_frontlegs;
	array[animType]["move"]["stand"]["none"]["walk_r_frontlegs"]			= %ai_claw_walk_r_gib_frontlegs;
	array[animType]["move"]["stand"]["none"]["walk_l_frontlegs"]			= %ai_claw_walk_l_gib_frontlegs;
	
	array[animType]["move"]["stand"]["none"]["walk_f_rearlegs"]				= %ai_claw_walk_f_gib_rearlegs;
	array[animType]["move"]["stand"]["none"]["walk_b_rearlegs"]				= %ai_claw_walk_b_gib_rearlegs;
	array[animType]["move"]["stand"]["none"]["walk_r_rearlegs"]				= %ai_claw_walk_r_gib_rearlegs;
	array[animType]["move"]["stand"]["none"]["walk_l_rearlegs"]				= %ai_claw_walk_l_gib_rearlegs;
	
	array[animType]["move"]["stand"]["none"]["walk_f_frontleft"]			= %ai_claw_walk_f_gib_frontleft_leg;
	array[animType]["move"]["stand"]["none"]["walk_b_frontleft"]			= %ai_claw_walk_b_gib_frontleft_leg;
	array[animType]["move"]["stand"]["none"]["walk_r_frontleft"]			= %ai_claw_walk_r_gib_frontleft_leg;
	array[animType]["move"]["stand"]["none"]["walk_l_frontleft"]			= %ai_claw_walk_l_gib_frontleft_leg;
	
	array[animType]["move"]["stand"]["none"]["walk_f_frontright"]			= %ai_claw_walk_f_gib_frontright_leg;
	array[animType]["move"]["stand"]["none"]["walk_b_frontright"]			= %ai_claw_walk_b_gib_frontright_leg;
	array[animType]["move"]["stand"]["none"]["walk_r_frontright"]			= %ai_claw_walk_r_gib_frontright_leg;
	array[animType]["move"]["stand"]["none"]["walk_l_frontright"]			= %ai_claw_walk_l_gib_frontright_leg;
	
	array[animType]["move"]["stand"]["none"]["walk_f_rearleft"]				= %ai_claw_walk_f_gib_rearleft_leg;
	array[animType]["move"]["stand"]["none"]["walk_b_rearleft"]				= %ai_claw_walk_b_gib_rearleft_leg;
	array[animType]["move"]["stand"]["none"]["walk_r_rearleft"]				= %ai_claw_walk_r_gib_rearleft_leg;
	array[animType]["move"]["stand"]["none"]["walk_l_rearleft"]				= %ai_claw_walk_l_gib_rearleft_leg;

	array[animType]["move"]["stand"]["none"]["walk_f_rearright"]			= %ai_claw_walk_f_gib_rearright_leg;
	array[animType]["move"]["stand"]["none"]["walk_b_rearright"]			= %ai_claw_walk_b_gib_rearright_leg;
	array[animType]["move"]["stand"]["none"]["walk_r_rearright"]			= %ai_claw_walk_r_gib_rearright_leg;
	array[animType]["move"]["stand"]["none"]["walk_l_rearright"]			= %ai_claw_walk_l_gib_rearright_leg;	
	
	array[animType]["move"]["stand"]["none"]["canter_f"]					= %ai_claw_canter_f;
	array[animType]["move"]["stand"]["none"]["trot_f"]						= %ai_claw_trot_f;	
	array[animType]["move"]["stand"]["none"]["sprint_f"]					= %ai_claw_sprint_f;

	// turns
	array[animType]["combat"]["stand"]["none"]["turn_l"]					= %ai_claw_turn_l;
	array[animType]["combat"]["stand"]["none"]["turn_r"]					= %ai_claw_turn_r;

	array[animType]["combat"]["stand"]["none"]["turn_l_rearlegs"]			= %ai_claw_turn_l_gib_rearlegs;
	array[animType]["combat"]["stand"]["none"]["turn_r_rearlegs"]			= %ai_claw_turn_r_gib_rearlegs;
	
	array[animType]["combat"]["stand"]["none"]["turn_l_frontlegs"]			= %ai_claw_turn_l_gib_frontlegs;
	array[animType]["combat"]["stand"]["none"]["turn_r_frontlegs"]			= %ai_claw_turn_r_gib_frontlegs;
	
	array[animType]["combat"]["stand"]["none"]["turn_l_frontleft"]			= %ai_claw_turn_l_gib_frontleft_leg;
	array[animType]["combat"]["stand"]["none"]["turn_r_frontleft"]			= %ai_claw_turn_r_gib_frontleft_leg;
	
	array[animType]["combat"]["stand"]["none"]["turn_l_frontright"]			= %ai_claw_turn_l_gib_frontright_leg;
	array[animType]["combat"]["stand"]["none"]["turn_r_frontright"]			= %ai_claw_turn_r_gib_frontright_leg;
	
	array[animType]["combat"]["stand"]["none"]["turn_l_rearleft"]			= %ai_claw_turn_l_gib_rearleft_leg;
	array[animType]["combat"]["stand"]["none"]["turn_r_rearleft"]			= %ai_claw_turn_r_gib_rearleft_leg;
	
	array[animType]["combat"]["stand"]["none"]["turn_l_rearright"]			= %ai_claw_turn_l_gib_rearright_leg;
	array[animType]["combat"]["stand"]["none"]["turn_r_rearright"]			= %ai_claw_turn_r_gib_rearright_leg;

	// combat
	array[animType]["combat"]["stand"]["none"]["fire"]						= %ai_claw_fire;
	array[animType]["combat"]["stand"]["none"]["fire_frontlegs"]			= %ai_claw_fire_damaged;
	array[animType]["combat"]["stand"]["none"]["fire_rearlegs"]				= %ai_claw_fire_damaged;

	// stop
	array[animType]["stop"]["stand"]["none"]["idle"]						= %ai_claw_idle;
	array[animType]["stop"]["stand"]["none"]["idle_frontlegs"]				= %ai_claw_idle_gib_frontlegs;
	array[animType]["stop"]["stand"]["none"]["idle_rearlegs"]				= %ai_claw_idle_gib_rearlegs;
	array[animType]["stop"]["stand"]["none"]["idle_leftlegs"]				= %ai_claw_idle_gib_leftlegs;
	array[animType]["stop"]["stand"]["none"]["idle_rightlegs"]				= %ai_claw_idle_gib_rightlegs;
	array[animType]["stop"]["stand"]["none"]["idle_frontleft"]				= %ai_claw_idle_gib_frontleft_leg;
	array[animType]["stop"]["stand"]["none"]["idle_frontright"]				= %ai_claw_idle_gib_frontright_leg;
	array[animType]["stop"]["stand"]["none"]["idle_rearleft"]				= %ai_claw_idle_gib_rearleft_leg;
	array[animType]["stop"]["stand"]["none"]["idle_rearright"]				= %ai_claw_idle_gib_rearright_leg;

	// pain
	array[animType]["pain"]["stand"]["none"]["idle_stunned"]				= %ai_claw_stunned_idle;
	
	array[animType]["pain"]["stand"]["none"]["stun_recover_f"]				= %ai_claw_stun_recover_f;
	array[animType]["pain"]["stand"]["none"]["stun_recover_b"]				= %ai_claw_stun_recover_b;
	array[animType]["pain"]["stand"]["none"]["stun_recover_r"]				= %ai_claw_stun_recover_r;
	array[animType]["pain"]["stand"]["none"]["stun_recover_l"]				= %ai_claw_stun_recover_l;
	
	array[animType]["pain"]["stand"]["none"]["stun_recover_f_frontlegs"]	= %ai_claw_stun_recover_f_gib_frontlegs;
	array[animType]["pain"]["stand"]["none"]["stun_recover_f_rearlegs"]		= %ai_claw_stun_recover_f_gib_rearlegs;
	array[animType]["pain"]["stand"]["none"]["stun_recover_f_frontleft"]	= %ai_claw_stun_recover_f_gib_frontleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_f_frontright"]	= %ai_claw_stun_recover_f_gib_frontright_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_f_rearleft"]		= %ai_claw_stun_recover_f_gib_rearleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_f_rearright"]	= %ai_claw_stun_recover_f_gib_rearright_leg;
	
	array[animType]["pain"]["stand"]["none"]["stun_recover_b_frontlegs"]	= %ai_claw_stun_recover_b_gib_frontlegs;
	array[animType]["pain"]["stand"]["none"]["stun_recover_b_rearlegs"]		= %ai_claw_stun_recover_b_gib_rearlegs;
	array[animType]["pain"]["stand"]["none"]["stun_recover_b_frontleft"]	= %ai_claw_stun_recover_b_gib_frontleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_b_frontright"]	= %ai_claw_stun_recover_b_gib_frontright_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_b_rearleft"]		= %ai_claw_stun_recover_b_gib_rearleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_b_rearright"]	= %ai_claw_stun_recover_b_gib_rearright_leg;
	
	array[animType]["pain"]["stand"]["none"]["stun_recover_r_frontlegs"]	= %ai_claw_stun_recover_r_gib_frontlegs;
	array[animType]["pain"]["stand"]["none"]["stun_recover_r_rearlegs"]		= %ai_claw_stun_recover_r_gib_rearlegs;
	array[animType]["pain"]["stand"]["none"]["stun_recover_r_frontleft"]	= %ai_claw_stun_recover_r_gib_frontleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_r_frontright"]	= %ai_claw_stun_recover_r_gib_frontright_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_r_rearleft"]		= %ai_claw_stun_recover_r_gib_rearleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_r_rearright"]	= %ai_claw_stun_recover_r_gib_rearright_leg;
	
	array[animType]["pain"]["stand"]["none"]["stun_recover_l_frontlegs"]	= %ai_claw_stun_recover_l_gib_frontlegs;
	array[animType]["pain"]["stand"]["none"]["stun_recover_l_rearlegs"]		= %ai_claw_stun_recover_l_gib_rearlegs;
	array[animType]["pain"]["stand"]["none"]["stun_recover_l_frontleft"]	= %ai_claw_stun_recover_l_gib_frontleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_l_frontright"]	= %ai_claw_stun_recover_l_gib_frontright_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_l_rearleft"]		= %ai_claw_stun_recover_l_gib_rearleft_leg;
	array[animType]["pain"]["stand"]["none"]["stun_recover_l_rearright"]	= %ai_claw_stun_recover_l_gib_rearright_leg;

	array[animType]["pain"]["stand"]["none"]["body_pain_f"]					= %ai_claw_pain_f;
	array[animType]["pain"]["stand"]["none"]["body_pain_b"]					= %ai_claw_pain_b;
	array[animType]["pain"]["stand"]["none"]["body_pain_r"]					= %ai_claw_pain_r;
	array[animType]["pain"]["stand"]["none"]["body_pain_l"]					= %ai_claw_pain_l;

	array[animType]["pain"]["stand"]["none"]["leg_pain_fl"]					= %ai_claw_pain_leg_leftfront;
	array[animType]["pain"]["stand"]["none"]["leg_pain_fr"]					= %ai_claw_pain_leg_rightfront;
	array[animType]["pain"]["stand"]["none"]["leg_pain_rl"]					= %ai_claw_pain_leg_leftrear;
	array[animType]["pain"]["stand"]["none"]["leg_pain_rr"]					= %ai_claw_pain_leg_rightrear;

	// death
	array[animType]["death"]["stand"]["none"]["stun_fall_f"]				= %ai_claw_stun_fall_f;
	array[animType]["death"]["stand"]["none"]["stun_fall_b"]				= %ai_claw_stun_fall_b;
	array[animType]["death"]["stand"]["none"]["stun_fall_r"]				= %ai_claw_stun_fall_r;
	array[animType]["death"]["stand"]["none"]["stun_fall_l"]				= %ai_claw_stun_fall_l;
	
	array[animType]["death"]["stand"]["none"]["stun_fall_f_frontlegs"]		= %ai_claw_stun_fall_f_gib_frontlegs;
	array[animType]["death"]["stand"]["none"]["stun_fall_f_rearlegs"]		= %ai_claw_stun_fall_f_gib_rearlegs;
	array[animType]["death"]["stand"]["none"]["stun_fall_f_frontleft"]		= %ai_claw_stun_fall_f_gib_frontleft_leg;
	array[animType]["death"]["stand"]["none"]["stun_fall_f_frontright"]		= %ai_claw_stun_fall_f_gib_frontright_leg;
	array[animType]["death"]["stand"]["none"]["stun_fall_f_rearleft"]		= %ai_claw_stun_fall_f_gib_rearleft_leg;
	array[animType]["death"]["stand"]["none"]["stun_fall_f_rearright"]		= %ai_claw_stun_fall_f_gib_rearright_leg;
	
	array[animType]["death"]["stand"]["none"]["stun_fall_b_frontlegs"]		= %ai_claw_stun_fall_b_gib_frontlegs;
	array[animType]["death"]["stand"]["none"]["stun_fall_b_rearlegs"]		= %ai_claw_stun_fall_b_gib_rearlegs;
	array[animType]["death"]["stand"]["none"]["stun_fall_b_frontleft"]		= %ai_claw_stun_fall_b_gib_frontleft_leg;
	array[animType]["death"]["stand"]["none"]["stun_fall_b_frontright"]		= %ai_claw_stun_fall_b_gib_frontright_leg;
	array[animType]["death"]["stand"]["none"]["stun_fall_b_rearleft"]		= %ai_claw_stun_fall_b_gib_rearleft_leg;
	array[animType]["death"]["stand"]["none"]["stun_fall_b_rearright"]		= %ai_claw_stun_fall_b_gib_rearright_leg;
	
	array[animType]["death"]["stand"]["none"]["stun_fall_r_frontlegs"]		= %ai_claw_stun_fall_r_gib_frontlegs;
	array[animType]["death"]["stand"]["none"]["stun_fall_r_rearlegs"]		= %ai_claw_stun_fall_r_gib_rearlegs;
	array[animType]["death"]["stand"]["none"]["stun_fall_r_frontleft"]		= %ai_claw_stun_fall_r_gib_frontleft_leg;
	array[animType]["death"]["stand"]["none"]["stun_fall_r_frontright"]		= %ai_claw_stun_fall_r_gib_frontright_leg;
	array[animType]["death"]["stand"]["none"]["stun_fall_r_rearleft"]		= %ai_claw_stun_fall_r_gib_rearleft_leg;
	array[animType]["death"]["stand"]["none"]["stun_fall_r_rearright"]		= %ai_claw_stun_fall_r_gib_rearright_leg;
	
	array[animType]["death"]["stand"]["none"]["stun_fall_l_frontlegs"]		= %ai_claw_stun_fall_l_gib_frontlegs;
	array[animType]["death"]["stand"]["none"]["stun_fall_l_rearlegs"]		= %ai_claw_stun_fall_l_gib_rearlegs;
	array[animType]["death"]["stand"]["none"]["stun_fall_l_frontleft"]		= %ai_claw_stun_fall_l_gib_frontleft_leg;
	array[animType]["death"]["stand"]["none"]["stun_fall_l_frontright"]		= %ai_claw_stun_fall_l_gib_frontright_leg;
	array[animType]["death"]["stand"]["none"]["stun_fall_l_rearleft"]		= %ai_claw_stun_fall_l_gib_rearleft_leg;
	array[animType]["death"]["stand"]["none"]["stun_fall_l_rearright"]		= %ai_claw_stun_fall_l_gib_rearright_leg;

	array[animType]["death"]["stand"]["none"]["explosive_death_f"]			= %ai_claw_explosive_death_from_back;
	array[animType]["death"]["stand"]["none"]["explosive_death_b"]			= %ai_claw_explosive_death_from_front;
	array[animType]["death"]["stand"]["none"]["explosive_death_r"]			= %ai_claw_explosive_death_from_left;
	array[animType]["death"]["stand"]["none"]["explosive_death_l"]			= %ai_claw_explosive_death_from_right;

	return array;
}