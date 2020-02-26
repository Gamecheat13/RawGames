#include common_scripts\Utility;
#insert raw\common_scripts\utility.gsh;

#using_animtree ("generic_human");

setup_wounded_anims()
{
	// don't do anything if already wounded
	if( self.isWounded )
		return;

	if( IS_TRUE(self.noWoundedRushing) )
		return;

	switch( self.animType )
	{
		// stop doing the spets rolls
		case "spetsnaz":
			self.animType = "default";
			self.lastAnimType = "spetsnaz"; // save it for other behaviors

		default:
			self setup_default_wounded_anim_array();
			break;
	}

	self animscripts\anims::clearAnimCache();
}

setup_default_wounded_anim_array()
{
	if( !IsDefined( self.anim_array ) )
	{
		self.anim_array					= [];
	}

	if( !IsDefined( self.pre_move_delta_array ) )
	{
		self.pre_move_delta_array		= [];
		self.move_delta_array			= [];
		self.post_move_delta_array		= [];
		self.angle_delta_array			= [];
		self.notetrack_array			= [];
		self.longestExposedApproachDist	= [];
		self.longestApproachDist		= [];
	}

	self.isWounded = true;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	self.anim_array[self.animType]["stop"]["stand"]["rifle"]["idle"]						= array( array( %ai_wounded_exposed_idle ) );

	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["exposed_idle"]				= array( %ai_wounded_exposed_idle );
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["exposed_idle_noncombat"]	= array( %ai_wounded_exposed_idle );

	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["fire"]						= %ai_wounded_exposed_auto;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["single"]					= array( %ai_wounded_exposed_semi_1 );
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst2"]					= %ai_wounded_exposed_burst_3; // ( will be stopped after second bullet)
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst3"]					= %ai_wounded_exposed_burst_3;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst4"]					= %ai_wounded_exposed_burst_4;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst5"]					= %ai_wounded_exposed_burst_5;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst6"]					= %ai_wounded_exposed_burst_6;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["semi2"]						= %ai_wounded_exposed_semi_2;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["semi3"]						= %ai_wounded_exposed_semi_3;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["semi4"]						= %ai_wounded_exposed_semi_4;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["semi5"]						= %ai_wounded_exposed_semi_5;

	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["reload"]					= array( %ai_wounded_exposed_reload_01, %ai_wounded_exposed_reload_03 ); 
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["reload_crouchhide"]			= array( %ai_wounded_exposed_reload_03 );

	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_45"]				= %ai_wounded_exposed_tracking_turn45l;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_90"]				= %ai_wounded_exposed_tracking_turn90l;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_135"]				= %ai_wounded_exposed_tracking_turn135l;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_180"]				= %ai_wounded_exposed_tracking_turn180l;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_45"]				= %ai_wounded_exposed_tracking_turn45r;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_90"]				= %ai_wounded_exposed_tracking_turn90r;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_135"]			= %ai_wounded_exposed_tracking_turn135r;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_180"]			= %ai_wounded_exposed_tracking_turn180l;		

	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["straight_level"]			= %ai_wounded_exposed_idle_aim5;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_up"]				= %ai_wounded_exposed_idle_aim8;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_down"]				= %ai_wounded_exposed_idle_aim2;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_left"]				= %ai_wounded_exposed_idle_aim4;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_right"]				= %ai_wounded_exposed_idle_aim6;  

	// WOUNDED_AI_TODO - grenade throws
	//self.anim_array[self.animType]["combat"]["stand"]["rifle"]["grenade_throw_1"]			= %ai_viet_exposed_grenadeThrowB;
	//self.anim_array[self.animType]["combat"]["stand"]["rifle"]["grenade_throw_2"]			= %ai_viet_exposed_grenadeThrowC;

	// WOUNDED_AI_TODO - stand<->crouch transitions
	//self.anim_array[self.animType]["combat"]["stand"]["rifle"]["crouch_2_stand"]			= %ai_viet_exposed_crouch_2_stand;
	//self.anim_array[self.animType]["combat"]["stand"]["rifle"]["stand_2_crouch"]			= %exposed_stand_2_crouch;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][1]			= %ai_wounded_exposed_arrive_1;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][2]			= %ai_wounded_exposed_arrive_2;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][3]			= %ai_wounded_exposed_arrive_3;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][4]			= %ai_wounded_exposed_arrive_4;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][6]			= %ai_wounded_exposed_arrive_6;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][7]			= %ai_wounded_exposed_arrive_7;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][8]			= %ai_wounded_exposed_arrive_8;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][9]			= %ai_wounded_exposed_arrive_9;

	// WOUNDED_AI_TODO - New wounded animations for exposed crouch arrivals
	//self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][2]	= %ai_viet_run_2_crouch_f_wounded;
	//self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][4]	= %ai_viet_run_2_crouch_90_l_wounded;
	//self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][6]	= %ai_viet_run_2_crouch_90_r_wounded;
	//self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][8]	= %ai_viet_run_2_crouch_180_l_wounded;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Exit Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][1]				= %ai_wounded_exposed_exit_1;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][2]				= %ai_wounded_exposed_exit_2;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][3]				= %ai_wounded_exposed_exit_3;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][4]				= %ai_wounded_exposed_exit_4;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][6]				= %ai_wounded_exposed_exit_6;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][7]				= %ai_wounded_exposed_exit_7;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][8]				= %ai_wounded_exposed_exit_8;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][9]				= %ai_wounded_exposed_exit_9;

	// WOUNDED_AI_TODO - New wounded animations for exposed crouch exits
	//self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][2]		= %ai_viet_crouch_2_run_180_l_wounded;
	//self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][4]		= %ai_viet_crouch_2_run_l_wounded;
	//self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][6]		= %ai_viet_crouch_2_run_r_wounded;
	//self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][8]		= %ai_viet_crouch_2_run_f_wounded;
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// End Cover Exit Actions
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Begin Turn Actions
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// run forward turns
	self.anim_array[self.animType]["turn"]["stand"]["rifle"]["turn_f_l_45"]					= %ai_wounded_run_turn_45_l;
	self.anim_array[self.animType]["turn"]["stand"]["rifle"]["turn_f_l_90"]					= %ai_wounded_run_turn_90_l;
	self.anim_array[self.animType]["turn"]["stand"]["rifle"]["turn_f_l_180"]				= %ai_wounded_run_turn_180_l;
	self.anim_array[self.animType]["turn"]["stand"]["rifle"]["turn_f_r_45"]					= %ai_wounded_run_turn_45_r;
	self.anim_array[self.animType]["turn"]["stand"]["rifle"]["turn_f_r_90"]					= %ai_wounded_run_turn_90_r;
	self.anim_array[self.animType]["turn"]["stand"]["rifle"]["turn_f_r_180"]				= %ai_wounded_run_turn_180_r;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Turn Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Run Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["reload"]						= %ai_wounded_run_f_reload;

	self.anim_array[self.animType]["move"]["stand"]["rifle"]["combat_run_f"]				= %ai_wounded_run_f_01;

	// WOUNDED_AI_TODO - do we need these animations? 
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["combat_run_r"]				= %ai_viet_run_lowready_r_wounded;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["combat_run_l"]				= %ai_viet_run_lowready_l_wounded;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["combat_run_b"]				= %ai_viet_run_b_wounded;	

	self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_f"]					= %ai_wounded_run_n_gun_f;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_r"]					= %ai_wounded_run_n_gun_r;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_l"]					= %ai_wounded_run_n_gun_l;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_b"]					= %ai_wounded_run_n_gun_b;

	self.anim_array[self.animType]["move"]["stand"]["rifle"]["add_f_aim_up"]				= %ai_wounded_run_n_gun_f_aim8;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["add_f_aim_down"]				= %ai_wounded_run_n_gun_f_aim2;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["add_f_aim_left"]				= %ai_wounded_run_n_gun_f_aim4;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["add_f_aim_right"]				= %ai_wounded_run_n_gun_f_aim6;

	self.anim_array[self.animType]["move"]["stand"]["rifle"]["add_l_aim_up"]				= %ai_wounded_run_n_gun_l_aim8;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["add_l_aim_down"]				= %ai_wounded_run_n_gun_l_aim2;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["add_l_aim_left"]				= %ai_wounded_run_n_gun_l_aim4;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["add_l_aim_right"]				= %ai_wounded_run_n_gun_l_aim6;

	self.anim_array[self.animType]["move"]["stand"]["rifle"]["add_r_aim_up"]				= %ai_wounded_run_n_gun_r_aim8;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["add_r_aim_down"]				= %ai_wounded_run_n_gun_r_aim2;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["add_r_aim_left"]				= %ai_wounded_run_n_gun_r_aim4;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["add_r_aim_right"]				= %ai_wounded_run_n_gun_r_aim6;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Run Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	animscripts\anims_table::setup_delta_arrays( self.anim_array, self );
}
