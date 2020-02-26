// Here be where all animations shall one day live.
#include common_scripts\Utility;
#include maps\_utility;
#include animscripts\anims_table;

#using_animtree ("generic_human");

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

//-------------------------------------------------------------------------------------
// Some of the CQB anims are stored on the AI itself, so that we can vary them a little 
// and the animation lookup will not play combat animations in cover
//-------------------------------------------------------------------------------------
setup_cqb_anim_array()
{
	if( !ISCQB(self) )
		return;

	self animscripts\anims::clearAnimCache();

	if( !IsDefined( self.anim_array ) )
		self.anim_array = [];
		
	// Use smaller set for exposed idles ( without movement animations ) as they dont blend well with CQB pose
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["exposed_idle"]				= array( %cqb_stand_exposed_idle );
		
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["straight_level"]			= %CQB_stand_aim5;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_up"]				= %CQB_stand_aim8;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_down"]				= %CQB_stand_aim2;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_left"]				= %CQB_stand_aim4;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_right"]				= %CQB_stand_aim6;
	
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["reload"]					= array( %CQB_stand_reload_steady ); 
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["reload_crouchhide"]			= array( %CQB_stand_reload_knee );
	
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_45"]				= %ai_cqb_exposed_turn_l_45;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_90"]				= %ai_cqb_exposed_turn_l_90;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_135"]				= %ai_cqb_exposed_turn_l_135;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_180"]				= %ai_cqb_exposed_turn_l_180;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_45"]				= %ai_cqb_exposed_turn_r_45;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_90"]				= %ai_cqb_exposed_turn_r_90;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_135"]			= %ai_cqb_exposed_turn_r_135;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_180"]			= %ai_cqb_exposed_turn_r_180;		
	
}

reset_cqb_anim_array()
{
	// re-initialize heat if it was on before we went CQB
	if( ISHEAT(self) )
	{
		reset_heat_anim_array();
		setup_heat_anim_array();
	}
	else
	{
		self.anim_array = undefined;
	}
}

set_cqb_run_anim( runAnim, walkAnim, sprintAnim )
{
	if( !ISCQB(self) )
		return;

	self animscripts\anims::clearAnimCache();

	if( !IsDefined( self.anim_array ) )
		self.anim_array = [];
	
	if( IsDefined(runAnim) )
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["cqb_run_f"]	= array( runAnim );
	
	if( IsDefined(walkAnim) )
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["cqb_walk_f"]	= array( walkAnim );
	
	if( IsDefined(sprintAnim) )
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["cqb_sprint_f"]	= array( sprintAnim );
}

clear_cqb_run_anim()
{
	if( !ISCQB(self) )
		return;

	self animscripts\anims::clearAnimCache();

	if( !IsDefined( self.anim_array ) )
		return;
	
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["cqb_run_f"]		= undefined;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["cqb_walk_f"]		= undefined;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["cqb_sprint_f"]	= undefined;
}

setup_default_cqb_anim_array( animType, array )
{

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Stop Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	array[animType]["stop"]["stand"]["rifle"]["idle_cqb"]					= array( array(%cqb_stand_idle, %cqb_stand_idle, %cqb_stand_twitch) );	

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Stop Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Run Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	array[animType]["move"]["stand"]["rifle"]["cqb_reload_walk"]			= %ai_cqb_walk_f_reload;
	array[animType]["move"]["stand"]["rifle"]["cqb_reload_run"]				= %ai_cqb_run_f_reload;
	
	array[animType]["move"]["stand"]["rifle"]["run_f_to_bR_cqb"]			= %ai_cqb_run_f_2_b_right;
	array[animType]["move"]["stand"]["rifle"]["run_f_to_bL_cqb"]			= %ai_cqb_run_f_2_b_left;
	
	array[animType]["move"]["stand"]["rifle"]["cqb_sprint_f"]				= %ai_cqb_sprint;
	
	array[animType]["move"]["stand"]["rifle"]["cqb_walk_f"]					= array( %walk_CQB_F, %walk_CQB_F_search_v1, %walk_CQB_F_search_v2 );
	array[animType]["move"]["stand"]["rifle"]["cqb_walk_r"]					= %walk_left;
	array[animType]["move"]["stand"]["rifle"]["cqb_walk_l"]					= %walk_right;
	array[animType]["move"]["stand"]["rifle"]["cqb_walk_b"]					= %walk_backward;

	array[animType]["move"]["stand"]["rifle"]["cqb_run_f"]					= array( %run_CQB_F_search_v1 );
	array[animType]["move"]["stand"]["rifle"]["cqb_run_r"]					= %walk_left;
	array[animType]["move"]["stand"]["rifle"]["cqb_run_l"]					= %walk_right;
	array[animType]["move"]["stand"]["rifle"]["cqb_run_b"]					= %walk_backward;

	array[animType]["move"]["stand"]["rifle"]["cqb_f_aim_up"]				= %walk_aim_8;
	array[animType]["move"]["stand"]["rifle"]["cqb_f_aim_down"]				= %walk_aim_2;
	array[animType]["move"]["stand"]["rifle"]["cqb_f_aim_left"]				= %walk_aim_4;
	array[animType]["move"]["stand"]["rifle"]["cqb_f_aim_right"]			= %walk_aim_6;
	
	array[animType]["move"]["stand"]["rifle"]["start_cqb_run_f"]			= %run_CQB_F_search_v1;
	array[animType]["move"]["crouch"]["rifle"]["start_cqb_run_f"]			= %run_CQB_F_search_v1;
	array[animType]["move"]["prone"]["rifle"]["start_cqb_run_f"]			= %run_CQB_F_search_v1;
	
	array[animType]["move"]["stand"]["rifle"]["cqb_run_n_gun_f"]				= %run_CQB_F_search_v1;
	array[animType]["move"]["stand"]["rifle"]["cqb_run_n_gun_r"]				= %ai_cqb_run_R;
	array[animType]["move"]["stand"]["rifle"]["cqb_run_n_gun_l"]				= %ai_cqb_run_l;
	array[animType]["move"]["stand"]["rifle"]["cqb_run_n_gun_b"]				= %run_n_gun_B;
	
	array[animType]["move"]["stand"]["rifle"]["cqb_add_f_aim_up"]				= %walk_aim_8;
	array[animType]["move"]["stand"]["rifle"]["cqb_add_f_aim_down"]				= %walk_aim_2;
	array[animType]["move"]["stand"]["rifle"]["cqb_add_f_aim_left"]				= %walk_aim_4;
	array[animType]["move"]["stand"]["rifle"]["cqb_add_f_aim_right"]			= %walk_aim_6;

	array[animType]["move"]["stand"]["rifle"]["cqb_add_l_aim_up"]				= %ai_cqb_run_l_aim_8;
	array[animType]["move"]["stand"]["rifle"]["cqb_add_l_aim_down"]				= %ai_cqb_run_l_aim_2;
	array[animType]["move"]["stand"]["rifle"]["cqb_add_l_aim_left"]				= %ai_cqb_run_l_aim_4;
	array[animType]["move"]["stand"]["rifle"]["cqb_add_l_aim_right"]			= %ai_cqb_run_l_aim_6;

	array[animType]["move"]["stand"]["rifle"]["cqb_add_r_aim_up"]				= %ai_cqb_run_r_aim_8;
	array[animType]["move"]["stand"]["rifle"]["cqb_add_r_aim_down"]				= %ai_cqb_run_r_aim_2;
	array[animType]["move"]["stand"]["rifle"]["cqb_add_r_aim_left"]				= %ai_cqb_run_r_aim_4;
	array[animType]["move"]["stand"]["rifle"]["cqb_add_r_aim_right"]			= %ai_cqb_run_r_aim_6;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Run Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Move Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//array[animType]["move"]["stand"]["rifle"]["weapon_switch"]				= %ai_cqbrun_weaponswitch;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Move Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Turn Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// CQB forward turns
	// AI_TODO - Get 180L and 180R versions
	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_45_cqb"]			= %CQB_walk_turn_7;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_90_cqb"]			= %CQB_walk_turn_4;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_135_cqb"]			= %CQB_walk_turn_1;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_180_cqb"]			= %CQB_walk_turn_2;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_45_cqb"]			= %CQB_walk_turn_9;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_90_cqb"]			= %CQB_walk_turn_6;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_135_cqb"]			= %CQB_walk_turn_3;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_180_cqb"]			= %CQB_walk_turn_2;
	
	// cqb run backwards turns
	array[animType]["turn"]["stand"]["rifle"]["turn_b_l_180_cqb"]			= %ai_cqb_run_b_2_f_left;
	array[animType]["turn"]["stand"]["rifle"]["turn_b_r_180_cqb"]			= %ai_cqb_run_b_2_f_right;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Turn Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// indicies indicate the keyboard numpad directions (8 is forward)
	// 7  8  9
	// 4     6	 <- 5 is invalid
	// 1  2  3
	
	// CQB arrival right
	array[animType]["move"]["stand"]["rifle"]["arrive_right_cqb"][1]			= %corner_standR_trans_CQB_IN_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_cqb"][2]			= %corner_standR_trans_CQB_IN_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_cqb"][3]			= %corner_standR_trans_CQB_IN_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_cqb"][4]			= %corner_standR_trans_CQB_IN_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_cqb"][6]			= %corner_standR_trans_CQB_IN_6;
	//array[animType]["move"]["stand"]["rifle"]["arrive_right_cqb"][7]			= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["arrive_right_cqb"][8]			= %corner_standR_trans_CQB_IN_8;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_cqb"][9]			= %corner_standR_trans_CQB_IN_9;

	// CQB arrival right crouch
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch_cqb"][1]		= %CornerCrR_CQB_trans_IN_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch_cqb"][2]		= %CornerCrR_CQB_trans_IN_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch_cqb"][3]		= %CornerCrR_CQB_trans_IN_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch_cqb"][4]		= %CornerCrR_CQB_trans_IN_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch_cqb"][6]		= %CornerCrR_CQB_trans_IN_6;
	//array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch_cqb"][7]	= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch_cqb"][8]		= %CornerCrR_CQB_trans_IN_8;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch_cqb"][9]		= %CornerCrR_CQB_trans_IN_9;
	
	// CQB arrive left
	array[animType]["move"]["stand"]["rifle"]["arrive_left_cqb"][1]				= %corner_standL_trans_CQB_IN_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_cqb"][2]				= %corner_standL_trans_CQB_IN_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_cqb"][3]				= %corner_standL_trans_CQB_IN_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_cqb"][4]				= %corner_standL_trans_CQB_IN_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_cqb"][6]				= %corner_standL_trans_CQB_IN_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_cqb"][7]				= %corner_standL_trans_CQB_IN_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_cqb"][8]				= %corner_standL_trans_CQB_IN_8;
	//array[animType]["move"]["stand"]["rifle"]["arrive_left_cqb"][9]			= can't approach from this direction
	
	// CQB arrive left crouch	
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch_cqb"][1]		= %CornerCrL_CQB_trans_IN_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch_cqb"][2]		= %CornerCrL_CQB_trans_IN_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch_cqb"][3]		= %CornerCrL_CQB_trans_IN_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch_cqb"][4]		= %CornerCrL_CQB_trans_IN_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch_cqb"][6]		= %CornerCrL_CQB_trans_IN_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch_cqb"][7]		= %CornerCrL_CQB_trans_IN_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch_cqb"][8]		= %CornerCrL_CQB_trans_IN_8;
	//array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch_cqb"][9]	= can't approach from this direction
	
	// CQB exposed arrivals
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_cqb"][1]		= %CQB_stop_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_cqb"][2]		= %CQB_stop_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_cqb"][3]		= %CQB_stop_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_cqb"][4]		= %CQB_stop_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_cqb"][6]		= %CQB_stop_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_cqb"][7]		= %CQB_stop_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_cqb"][8]		= %CQB_stop_8;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_cqb"][9]		= %CQB_stop_9;	

	// CQB exposed arrivals crouch
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch_cqb"][1]	= %CQB_crouch_stop_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch_cqb"][2]	= %CQB_crouch_stop_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch_cqb"][3]	= %CQB_crouch_stop_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch_cqb"][4]	= %CQB_crouch_stop_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch_cqb"][6]	= %CQB_crouch_stop_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch_cqb"][7]	= %CQB_crouch_stop_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch_cqb"][8]	= %CQB_crouch_stop_8;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch_cqb"][9]	= %CQB_crouch_stop_9;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Exit Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// CQB exit right
	array[animType]["move"]["stand"]["rifle"]["exit_right_cqb"][1]				= %corner_standR_trans_CQB_OUT_1;
	array[animType]["move"]["stand"]["rifle"]["exit_right_cqb"][2]				= %corner_standR_trans_CQB_OUT_2;
	array[animType]["move"]["stand"]["rifle"]["exit_right_cqb"][3]				= %corner_standR_trans_CQB_OUT_3;
	array[animType]["move"]["stand"]["rifle"]["exit_right_cqb"][4]				= %corner_standR_trans_CQB_OUT_4;
	array[animType]["move"]["stand"]["rifle"]["exit_right_cqb"][6]				= %corner_standR_trans_CQB_OUT_6;
	//array[animType]["move"]["stand"]["rifle"]["exit_right_cqb"][7]			= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["exit_right_cqb"][8]				= %corner_standR_trans_CQB_OUT_8;
	array[animType]["move"]["stand"]["rifle"]["exit_right_cqb"][9]				= %corner_standR_trans_CQB_OUT_9;

	// CQB exit right crouch	
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch_cqb"][1]		= %CornerCrR_CQB_trans_OUT_1;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch_cqb"][2]		= %CornerCrR_CQB_trans_OUT_2;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch_cqb"][3]		= %CornerCrR_CQB_trans_OUT_3;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch_cqb"][4]		= %CornerCrR_CQB_trans_OUT_4;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch_cqb"][6]		= %CornerCrR_CQB_trans_OUT_6;
	//array[animType]["move"]["stand"]["rifle"]["exit_right_crouch_cqb"][7]		= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch_cqb"][8]		= %CornerCrR_CQB_trans_OUT_8;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch_cqb"][9]		= %CornerCrR_CQB_trans_OUT_9;
	
		// CQB exit left
	array[animType]["move"]["stand"]["rifle"]["exit_left_cqb"][1]				= %corner_standL_trans_CQB_OUT_1;
	array[animType]["move"]["stand"]["rifle"]["exit_left_cqb"][2]				= %corner_standL_trans_CQB_OUT_2;
	array[animType]["move"]["stand"]["rifle"]["exit_left_cqb"][3]				= %corner_standL_trans_CQB_OUT_3;
	array[animType]["move"]["stand"]["rifle"]["exit_left_cqb"][4]				= %corner_standL_trans_CQB_OUT_4;
	array[animType]["move"]["stand"]["rifle"]["exit_left_cqb"][6]				= %corner_standL_trans_CQB_OUT_6;
	array[animType]["move"]["stand"]["rifle"]["exit_left_cqb"][7]				= %corner_standL_trans_CQB_OUT_7;
	array[animType]["move"]["stand"]["rifle"]["exit_left_cqb"][8]				= %corner_standL_trans_CQB_OUT_8;
	//array[animType]["move"]["stand"]["rifle"]["exit_left_cqb"][9]				= can't approach from this direction

	// CQB exit left crouch	
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch_cqb"][1]		= %CornerCrL_CQB_trans_OUT_1;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch_cqb"][2]		= %CornerCrL_CQB_trans_OUT_2;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch_cqb"][3]		= %CornerCrL_CQB_trans_OUT_3;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch_cqb"][4]		= %CornerCrL_CQB_trans_OUT_4;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch_cqb"][6]		= %CornerCrL_CQB_trans_OUT_6;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch_cqb"][7]		= %CornerCrL_CQB_trans_OUT_7;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch_cqb"][8]		= %CornerCrL_CQB_trans_OUT_8;
	//array[animType]["move"]["stand"]["rifle"]["exit_left_crouch_cqb"][9]		= can't approach from this direction
	
	// CQB exposed exits
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_cqb"][1]			= %CQB_start_1;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_cqb"][2]			= %CQB_start_2;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_cqb"][3]			= %CQB_start_3;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_cqb"][4]			= %CQB_start_4;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_cqb"][6]			= %CQB_start_6;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_cqb"][7]			= %CQB_start_7;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_cqb"][8]			= %CQB_start_8;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_cqb"][9]			= %CQB_start_9;

	// CQB exposed exits crouch
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch_cqb"][1]		= %CQB_crouch_start_1;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch_cqb"][2]		= %CQB_crouch_start_2;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch_cqb"][3]		= %CQB_crouch_start_3;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch_cqb"][4]		= %CQB_crouch_start_4;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch_cqb"][6]		= %CQB_crouch_start_6;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch_cqb"][7]		= %CQB_crouch_start_7;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch_cqb"][8]		= %CQB_crouch_start_8;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch_cqb"][9]		= %CQB_crouch_start_9;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Exit Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	return array;
}