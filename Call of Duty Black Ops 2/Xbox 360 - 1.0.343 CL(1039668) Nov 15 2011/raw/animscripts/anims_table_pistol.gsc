// Here be where all animations shall one day live.
#include common_scripts\Utility;

#using_animtree ("generic_human");

setup_pistol_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_forward"]		= array( %ai_pistol_idle_strafe_forward_a,
//																					 %ai_pistol_idle_strafe_forward_b,
//																					 %ai_pistol_idle_strafe_forward_c );
//
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_right"]		= array( %ai_pistol_idle_strafe_right_a,
//																					 %ai_pistol_idle_strafe_right_b,
//																					 %ai_pistol_idle_strafe_right_c );
//
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_left"]		= array( %ai_pistol_idle_strafe_left_a,
//																					 %ai_pistol_idle_strafe_left_b,
//																					 %ai_pistol_idle_strafe_left_c );
//
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_stop_2_r"]	= %ai_pistol_idle_strafe_exposed_to_right;
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_stop_2_l"]	= %ai_pistol_idle_strafe_exposed_to_left;
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_stop_2_f"]	= %ai_pistol_idle_strafe_exposed_to_forward;
//
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_l_2_stop"]	= %ai_pistol_idle_strafe_left_to_exposed;
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_r_2_stop"]	= %ai_pistol_idle_strafe_right_to_exposed;
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_f_2_stop"]	= %ai_pistol_idle_strafe_forward_to_exposed;
//
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_aim_up"]		= %ai_pistol_idle_strafe_forward_aim8;
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_aim_down"]	= %ai_pistol_idle_strafe_forward_aim2;
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_aim_left"]	= %ai_pistol_idle_strafe_forward_aim4;
//	array[animType]["combat"]["stand"]["pistol"]["idle_strafe_aim_right"]	= %ai_pistol_idle_strafe_forward_aim6;

	array[animType]["combat"]["stand"]["pistol"]["crouch_2_stand"]			= %ai_pistol_crouch_2_stand;
	array[animType]["combat"]["stand"]["pistol"]["stand_2_crouch"]			= %ai_pistol_stand_2_crouch;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Crouch Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["crouch"]["pistol"]["exposed_idle"]			= array( %ai_pistol_crouch_exposed_idle );
	array[animType]["combat"]["crouch"]["pistol"]["exposed_idle_noncombat"]	= array( %ai_pistol_crouch_exposed_idle );

	array[animType]["combat"]["crouch"]["pistol"]["fire"]					= %ai_pistol_crouch_exposed_shoot_semi1;
	array[animType]["combat"]["crouch"]["pistol"]["single"]					= array( %ai_pistol_crouch_exposed_shoot_semi1 );
	array[animType]["combat"]["crouch"]["pistol"]["semi2"]					= %ai_pistol_crouch_exposed_shoot_semi2;
	array[animType]["combat"]["crouch"]["pistol"]["semi3"]					= %ai_pistol_crouch_exposed_shoot_semi3;
	array[animType]["combat"]["crouch"]["pistol"]["semi4"]					= %ai_pistol_crouch_exposed_shoot_semi4;
	array[animType]["combat"]["crouch"]["pistol"]["semi5"]					= %ai_pistol_crouch_exposed_shoot_semi5;

	array[animType]["combat"]["crouch"]["pistol"]["reload"]					= array( %ai_pistol_crouch_exposed_reload );
	array[animType]["combat"]["crouch"]["pistol"]["reload_crouchhide"]		= array();

	array[animType]["combat"]["crouch"]["pistol"]["turn_left_45"]			= %ai_pistol_crouch_exposed_turn_45_l;
	array[animType]["combat"]["crouch"]["pistol"]["turn_right_45"]			= %ai_pistol_crouch_exposed_turn_45_r;
	array[animType]["combat"]["crouch"]["pistol"]["turn_left_90"]			= %ai_pistol_crouch_exposed_turn_90_l;
	array[animType]["combat"]["crouch"]["pistol"]["turn_right_90"]			= %ai_pistol_crouch_exposed_turn_90_r;
	array[animType]["combat"]["crouch"]["pistol"]["turn_left_135"]			= %ai_pistol_crouch_exposed_turn_135_l;
	array[animType]["combat"]["crouch"]["pistol"]["turn_right_135"]			= %ai_pistol_crouch_exposed_turn_135_r;
	array[animType]["combat"]["crouch"]["pistol"]["turn_left_180"]			= %ai_pistol_crouch_exposed_turn_180_l;
	array[animType]["combat"]["crouch"]["pistol"]["turn_right_180"]			= %ai_pistol_crouch_exposed_turn_180_r;

	array[animType]["combat"]["crouch"]["pistol"]["straight_level"]			= %ai_pistol_crouch_exposed_aim_5;
	array[animType]["combat"]["crouch"]["pistol"]["add_aim_up"]				= %ai_pistol_crouch_exposed_aim_8;
	array[animType]["combat"]["crouch"]["pistol"]["add_aim_down"]			= %ai_pistol_crouch_exposed_aim_2;
	array[animType]["combat"]["crouch"]["pistol"]["add_aim_left"]			= %ai_pistol_crouch_exposed_aim_4;
	array[animType]["combat"]["crouch"]["pistol"]["add_aim_right"]			= %ai_pistol_crouch_exposed_aim_6;  

	array[animType]["combat"]["crouch"]["pistol"]["add_turn_aim_up"]		= %ai_pistol_crouch_exposed_aim_8;
	array[animType]["combat"]["crouch"]["pistol"]["add_turn_aim_down"]		= %ai_pistol_crouch_exposed_aim_2;
	array[animType]["combat"]["crouch"]["pistol"]["add_turn_aim_left"]		= %ai_pistol_crouch_exposed_aim_4;
	array[animType]["combat"]["crouch"]["pistol"]["add_turn_aim_right"]		= %ai_pistol_crouch_exposed_aim_6;

	array[animType]["combat"]["crouch"]["pistol"]["crouch_2_stand"]			= %ai_pistol_crouch_2_stand;
	array[animType]["combat"]["crouch"]["pistol"]["stand_2_crouch"]			= %ai_pistol_stand_2_crouch;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Crouch Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Melee Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["stand"]["pistol"]["melee"]					= %ai_pistol_melee;
	array[animType]["combat"]["stand"]["pistol"]["stand_2_melee"]			= %ai_pistol_stand_2_melee;
	array[animType]["combat"]["stand"]["pistol"]["run_2_melee"]				= %ai_pistol_run_2_melee_charge;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Melee Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Arrival Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// indicies indicate the keyboard numpad directions (8 is forward)
	// 7  8  9
	// 4     6	 <- 5 is invalid
	// 1  2  3

	array[animType]["move"]["stand"]["pistol"]["arrive_right"][1]			= %ai_pistol_cornerstand_right_arrive_1;
	array[animType]["move"]["stand"]["pistol"]["arrive_right"][2]			= %ai_pistol_cornerstand_right_arrive_2;
	array[animType]["move"]["stand"]["pistol"]["arrive_right"][3]			= %ai_pistol_cornerstand_right_arrive_3;
	array[animType]["move"]["stand"]["pistol"]["arrive_right"][4]			= %ai_pistol_cornerstand_right_arrive_4;
	array[animType]["move"]["stand"]["pistol"]["arrive_right"][6]			= %ai_pistol_cornerstand_right_arrive_6;
	//array[animType]["move"]["stand"]["pistol"]["arrive_right"][7]			= can't approach from this direction
	array[animType]["move"]["stand"]["pistol"]["arrive_right"][8]			= %ai_pistol_cornerstand_right_arrive_8;
	array[animType]["move"]["stand"]["pistol"]["arrive_right"][9]			= %ai_pistol_cornerstand_right_arrive_9;

	array[animType]["move"]["stand"]["pistol"]["arrive_right_crouch"][1]	= %ai_pistol_cornercrouch_right_arrive_1;
	array[animType]["move"]["stand"]["pistol"]["arrive_right_crouch"][2]	= %ai_pistol_cornercrouch_right_arrive_2;
	array[animType]["move"]["stand"]["pistol"]["arrive_right_crouch"][3]	= %ai_pistol_cornercrouch_right_arrive_3;
	array[animType]["move"]["stand"]["pistol"]["arrive_right_crouch"][4]	= %ai_pistol_cornercrouch_right_arrive_4;
	array[animType]["move"]["stand"]["pistol"]["arrive_right_crouch"][6]	= %ai_pistol_cornercrouch_right_arrive_6;
	//array[animType]["move"]["stand"]["pistol"]["arrive_right_crouch"][7]	= can't approach from this direction
	array[animType]["move"]["stand"]["pistol"]["arrive_right_crouch"][8]	= %ai_pistol_cornercrouch_right_arrive_8;
	array[animType]["move"]["stand"]["pistol"]["arrive_right_crouch"][9]	= %ai_pistol_cornercrouch_right_arrive_9;

	array[animType]["move"]["stand"]["pistol"]["arrive_left"][1]			= %ai_pistol_cornerstand_left_arrive_1;
	array[animType]["move"]["stand"]["pistol"]["arrive_left"][2]			= %ai_pistol_cornerstand_left_arrive_2;
	array[animType]["move"]["stand"]["pistol"]["arrive_left"][3]			= %ai_pistol_cornerstand_left_arrive_3;
	array[animType]["move"]["stand"]["pistol"]["arrive_left"][4]			= %ai_pistol_cornerstand_left_arrive_4;
	array[animType]["move"]["stand"]["pistol"]["arrive_left"][6]			= %ai_pistol_cornerstand_left_arrive_6;
	array[animType]["move"]["stand"]["pistol"]["arrive_left"][7]			= %ai_pistol_cornerstand_left_arrive_7;
	array[animType]["move"]["stand"]["pistol"]["arrive_left"][8]			= %ai_pistol_cornerstand_left_arrive_8;
	//array[animType]["move"]["stand"]["pistol"]["arrive_left"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["pistol"]["arrive_left_crouch"][1]		= %ai_pistol_cornercrouch_left_arrive_1;
	array[animType]["move"]["stand"]["pistol"]["arrive_left_crouch"][2]		= %ai_pistol_cornercrouch_left_arrive_2;
	array[animType]["move"]["stand"]["pistol"]["arrive_left_crouch"][3]		= %ai_pistol_cornercrouch_left_arrive_3;
	array[animType]["move"]["stand"]["pistol"]["arrive_left_crouch"][4]		= %ai_pistol_cornercrouch_left_arrive_4;
	array[animType]["move"]["stand"]["pistol"]["arrive_left_crouch"][6]		= %ai_pistol_cornercrouch_left_arrive_6;
	array[animType]["move"]["stand"]["pistol"]["arrive_left_crouch"][7]		= %ai_pistol_cornercrouch_left_arrive_7;
	array[animType]["move"]["stand"]["pistol"]["arrive_left_crouch"][8]		= %ai_pistol_cornercrouch_left_arrive_8;
	//array[animType]["move"]["stand"]["pistol"]["arrive_left_crouch"][9]	= can't approach from this direction

	array[animType]["move"]["stand"]["pistol"]["arrive_crouch"][1]			= %ai_pistol_crouchcover_hide_arrive_1;
	array[animType]["move"]["stand"]["pistol"]["arrive_crouch"][2]			= %ai_pistol_crouchcover_hide_arrive_2;
	array[animType]["move"]["stand"]["pistol"]["arrive_crouch"][3]			= %ai_pistol_crouchcover_hide_arrive_3;
	array[animType]["move"]["stand"]["pistol"]["arrive_crouch"][4]			= %ai_pistol_crouchcover_hide_arrive_4;
	array[animType]["move"]["stand"]["pistol"]["arrive_crouch"][6]			= %ai_pistol_crouchcover_hide_arrive_6;
	//array[animType]["move"]["stand"]["pistol"]["arrive_crouch"][7]		= can't approach from this direction
	//array[animType]["move"]["stand"]["pistol"]["arrive_crouch"][8]		= can't approach from this direction
	//array[animType]["move"]["stand"]["pistol"]["arrive_crouch"][9]		= can't approach from this direction

	array[animType]["move"]["stand"]["pistol"]["arrive_stand"][1]			= %ai_pistol_standcover_hide_arrive_1;
	array[animType]["move"]["stand"]["pistol"]["arrive_stand"][2]			= %ai_pistol_standcover_hide_arrive_2;
	array[animType]["move"]["stand"]["pistol"]["arrive_stand"][3]			= %ai_pistol_standcover_hide_arrive_3;
	array[animType]["move"]["stand"]["pistol"]["arrive_stand"][4]			= %ai_pistol_standcover_hide_arrive_4;
	array[animType]["move"]["stand"]["pistol"]["arrive_stand"][6]			= %ai_pistol_standcover_hide_arrive_6;
	//array[animType]["move"]["stand"]["pistol"]["arrive_stand"][7]			= can't approach from this direction
	//array[animType]["move"]["stand"]["pistol"]["arrive_stand"][8]			= can't approach from this direction
	//array[animType]["move"]["stand"]["pistol"]["arrive_stand"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["pistol"]["arrive_exposed"][1]			= %ai_pistol_run_to_exposed_1;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed"][2]			= %ai_pistol_run_to_exposed_2;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed"][3]			= %ai_pistol_run_to_exposed_3;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed"][4]			= %ai_pistol_run_to_exposed_4;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed"][6]			= %ai_pistol_run_to_exposed_6;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed"][7]			= %ai_pistol_run_to_exposed_7;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed"][8]			= %ai_pistol_run_to_exposed_8;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed"][9]			= %ai_pistol_run_to_exposed_9;

	array[animType]["move"]["stand"]["pistol"]["arrive_exposed_crouch"][1]	= %ai_pistol_run_2_crouch_exposed_1;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed_crouch"][2]	= %ai_pistol_run_2_crouch_exposed_2;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed_crouch"][3]	= %ai_pistol_run_2_crouch_exposed_3;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed_crouch"][4]	= %ai_pistol_run_2_crouch_exposed_4;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed_crouch"][6]	= %ai_pistol_run_2_crouch_exposed_6;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed_crouch"][7]	= %ai_pistol_run_2_crouch_exposed_7;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed_crouch"][8]	= %ai_pistol_run_2_crouch_exposed_8;
	array[animType]["move"]["stand"]["pistol"]["arrive_exposed_crouch"][9]	= %ai_pistol_run_2_crouch_exposed_9;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Arrival Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Exit Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//
	// TODO: remove all this since AI shouldn't be leaving cover with a pistol
	//

	array[animType]["move"]["stand"]["pistol"]["exit_right"][1]				= %ai_pistol_cornerstand_right_exit_1;
	array[animType]["move"]["stand"]["pistol"]["exit_right"][2]				= %ai_pistol_cornerstand_right_exit_2;
	array[animType]["move"]["stand"]["pistol"]["exit_right"][3]				= %ai_pistol_cornerstand_right_exit_3;
	array[animType]["move"]["stand"]["pistol"]["exit_right"][4]				= %ai_pistol_cornerstand_right_exit_4;
	array[animType]["move"]["stand"]["pistol"]["exit_right"][6]				= %ai_pistol_cornerstand_right_exit_6;
	//array[animType]["move"]["stand"]["pistol"]["exit_right"][7]			= can't approach from this direction
	array[animType]["move"]["stand"]["pistol"]["exit_right"][8]				= %ai_pistol_cornerstand_right_exit_8;
	array[animType]["move"]["stand"]["pistol"]["exit_right"][9]				= %ai_pistol_cornerstand_right_exit_9;

	array[animType]["move"]["stand"]["pistol"]["exit_right_crouch"][1]		= %ai_pistol_cornercrouch_right_exit_1;
	array[animType]["move"]["stand"]["pistol"]["exit_right_crouch"][2]		= %ai_pistol_cornercrouch_right_exit_2;
	array[animType]["move"]["stand"]["pistol"]["exit_right_crouch"][3]		= %ai_pistol_cornercrouch_right_exit_3;
	array[animType]["move"]["stand"]["pistol"]["exit_right_crouch"][4]		= %ai_pistol_cornercrouch_right_exit_4;
	array[animType]["move"]["stand"]["pistol"]["exit_right_crouch"][6]		= %ai_pistol_cornercrouch_right_exit_6;
	//array[animType]["move"]["stand"]["pistol"]["exit_right_crouch"][7]	= can't approach from this direction
	array[animType]["move"]["stand"]["pistol"]["exit_right_crouch"][8]		= %ai_pistol_cornercrouch_right_exit_8;
	array[animType]["move"]["stand"]["pistol"]["exit_right_crouch"][9]		= %ai_pistol_cornercrouch_right_exit_9;

	array[animType]["move"]["stand"]["pistol"]["exit_left"][1]				= %ai_pistol_cornerstand_left_exit_1;
	array[animType]["move"]["stand"]["pistol"]["exit_left"][2]				= %ai_pistol_cornerstand_left_exit_2;
	array[animType]["move"]["stand"]["pistol"]["exit_left"][3]				= %ai_pistol_cornerstand_left_exit_3;
	array[animType]["move"]["stand"]["pistol"]["exit_left"][4]				= %ai_pistol_cornerstand_left_exit_4;
	array[animType]["move"]["stand"]["pistol"]["exit_left"][6]				= %ai_pistol_cornerstand_left_exit_6;
	array[animType]["move"]["stand"]["pistol"]["exit_left"][7]				= %ai_pistol_cornerstand_left_exit_7;
	array[animType]["move"]["stand"]["pistol"]["exit_left"][8]				= %ai_pistol_cornerstand_left_exit_8;
	//array[animType]["move"]["stand"]["pistol"]["exit_left"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["pistol"]["exit_left_crouch"][1]		= %ai_pistol_cornercrouch_left_exit_1;
	array[animType]["move"]["stand"]["pistol"]["exit_left_crouch"][2]		= %ai_pistol_cornercrouch_left_exit_2;
	array[animType]["move"]["stand"]["pistol"]["exit_left_crouch"][3]		= %ai_pistol_cornercrouch_left_exit_3;
	array[animType]["move"]["stand"]["pistol"]["exit_left_crouch"][4]		= %ai_pistol_cornercrouch_left_exit_4;
	array[animType]["move"]["stand"]["pistol"]["exit_left_crouch"][6]		= %ai_pistol_cornercrouch_left_exit_6;
	array[animType]["move"]["stand"]["pistol"]["exit_left_crouch"][7]		= %ai_pistol_cornercrouch_left_exit_7;
	array[animType]["move"]["stand"]["pistol"]["exit_left_crouch"][8]		= %ai_pistol_cornercrouch_left_exit_8;
	//array[animType]["move"]["stand"]["pistol"]["exit_left_crouch"][9]		= can't approach from this direction

	array[animType]["move"]["stand"]["pistol"]["exit_crouch"][1]			= %ai_pistol_crouchcover_hide_exit_1;
	array[animType]["move"]["stand"]["pistol"]["exit_crouch"][2]			= %ai_pistol_crouchcover_hide_exit_2;
	array[animType]["move"]["stand"]["pistol"]["exit_crouch"][3]			= %ai_pistol_crouchcover_hide_exit_3;
	array[animType]["move"]["stand"]["pistol"]["exit_crouch"][4]			= %ai_pistol_crouchcover_hide_exit_4;
	array[animType]["move"]["stand"]["pistol"]["exit_crouch"][6]			= %ai_pistol_crouchcover_hide_exit_6;
	//array[animType]["move"]["stand"]["pistol"]["exit_crouch"][7]			= can't approach from this direction
	//array[animType]["move"]["stand"]["pistol"]["exit_crouch"][8]			= can't approach from this direction
	//array[animType]["move"]["stand"]["pistol"]["exit_crouch"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["pistol"]["exit_stand"][1]				= %ai_pistol_standcover_hide_exit_1;
	array[animType]["move"]["stand"]["pistol"]["exit_stand"][2]				= %ai_pistol_standcover_hide_exit_2;
	array[animType]["move"]["stand"]["pistol"]["exit_stand"][3]				= %ai_pistol_standcover_hide_exit_3;
	array[animType]["move"]["stand"]["pistol"]["exit_stand"][4]				= %ai_pistol_standcover_hide_exit_4;
	array[animType]["move"]["stand"]["pistol"]["exit_stand"][6]				= %ai_pistol_standcover_hide_exit_6;
	//array[animType]["move"]["stand"]["pistol"]["exit_stand"][7]			= can't approach from this direction
	//array[animType]["move"]["stand"]["pistol"]["exit_stand"][8]			= can't approach from this direction
	//array[animType]["move"]["stand"]["pistol"]["exit_stand"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["pistol"]["exit_exposed"][1]			= %ai_pistol_exposed_to_run_1;
	array[animType]["move"]["stand"]["pistol"]["exit_exposed"][2]			= %ai_pistol_exposed_to_run_2;
	array[animType]["move"]["stand"]["pistol"]["exit_exposed"][3]			= %ai_pistol_exposed_to_run_3;
	array[animType]["move"]["stand"]["pistol"]["exit_exposed"][4]			= %ai_pistol_exposed_to_run_4;
	array[animType]["move"]["stand"]["pistol"]["exit_exposed"][6]			= %ai_pistol_exposed_to_run_6;
	array[animType]["move"]["stand"]["pistol"]["exit_exposed"][7]			= %ai_pistol_exposed_to_run_7;
	array[animType]["move"]["stand"]["pistol"]["exit_exposed"][8]			= %ai_pistol_exposed_to_run_8;
	array[animType]["move"]["stand"]["pistol"]["exit_exposed"][9]			= %ai_pistol_exposed_to_run_9;

//	array[animType]["move"]["stand"]["pistol"]["exit_exposed_crouch"][1]	= %ai_pistol_run_2_crouch_exposed_1;
//	array[animType]["move"]["stand"]["pistol"]["exit_exposed_crouch"][2]	= %ai_pistol_run_2_crouch_exposed_2;
//	array[animType]["move"]["stand"]["pistol"]["exit_exposed_crouch"][3]	= %ai_pistol_run_2_crouch_exposed_3;
//	array[animType]["move"]["stand"]["pistol"]["exit_exposed_crouch"][4]	= %ai_pistol_run_2_crouch_exposed_4;
//	array[animType]["move"]["stand"]["pistol"]["exit_exposed_crouch"][6]	= %ai_pistol_run_2_crouch_exposed_6;
//	array[animType]["move"]["stand"]["pistol"]["exit_exposed_crouch"][7]	= %ai_pistol_run_2_crouch_exposed_7;
//	array[animType]["move"]["stand"]["pistol"]["exit_exposed_crouch"][8]	= %ai_pistol_run_2_crouch_exposed_8;
//	array[animType]["move"]["stand"]["pistol"]["exit_exposed_crouch"][9]	= %ai_pistol_run_2_crouch_exposed_9;

	// ALEXP_TODO: figure out how to do this without duplicating these large arrays to save scriptVars
	arrivalKeys = getArrayKeys( array[animType]["move"]["stand"]["pistol"] );
	for( i=0; i < arrivalKeys.size; i++ )
	{
		arrivalType = arrivalKeys[i];

		// only arrival and exits are arrays
		if( IsArray( array[animType]["move"]["stand"]["pistol"][arrivalType] ) )
		{
			array[animType]["move"]["crouch"]["pistol"][arrivalType] = array[animType]["move"]["stand"]["pistol"][arrivalType];
		}
	}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Exit Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Run Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["pistol"]["combat_run_f"]				= %ai_pistol_run_lowready_f;
	array[animType]["move"]["stand"]["pistol"]["combat_run_r"]				= %ai_pistol_run_r;
	array[animType]["move"]["stand"]["pistol"]["combat_run_l"]				= %ai_pistol_run_l;
	array[animType]["move"]["stand"]["pistol"]["combat_run_b"]				= %ai_pistol_run_b;
	
	// PISTOL_TODO - replace this with real sprint animation
	array[animType]["move"]["stand"]["pistol"]["sprint"]					= %ai_pistol_sprint_f;
	
	array[animType]["move"]["stand"]["pistol"]["tactical_walk_f"]			= %ai_tactical_walk_pistol_f;
	array[animType]["move"]["stand"]["pistol"]["tactical_walk_r"]			= %ai_tactical_walk_pistol_l;
	array[animType]["move"]["stand"]["pistol"]["tactical_walk_l"]			= %ai_tactical_walk_pistol_r;
	array[animType]["move"]["stand"]["pistol"]["tactical_walk_b"]			= %ai_tactical_walk_pistol_b;

	array[animType]["move"]["stand"]["pistol"]["tactical_f_aim_up"]			= %ai_tactical_walk_pistol_f_aim8;
	array[animType]["move"]["stand"]["pistol"]["tactical_f_aim_down"]		= %ai_tactical_walk_pistol_f_aim2;
	array[animType]["move"]["stand"]["pistol"]["tactical_f_aim_left"]		= %ai_tactical_walk_pistol_f_aim4;
	array[animType]["move"]["stand"]["pistol"]["tactical_f_aim_right"]		= %ai_tactical_walk_pistol_f_aim6;

	array[animType]["move"]["stand"]["pistol"]["tactical_b_aim_up"]			= %ai_tactical_walk_pistol_f_aim8;
	array[animType]["move"]["stand"]["pistol"]["tactical_b_aim_down"]		= %ai_tactical_walk_pistol_f_aim2;
	array[animType]["move"]["stand"]["pistol"]["tactical_b_aim_left"]		= %ai_tactical_walk_pistol_f_aim4;
	array[animType]["move"]["stand"]["pistol"]["tactical_b_aim_right"]		= %ai_tactical_walk_pistol_f_aim6;

	array[animType]["move"]["stand"]["pistol"]["tactical_l_aim_up"]			= %ai_tactical_walk_pistol_l_aim8;
	array[animType]["move"]["stand"]["pistol"]["tactical_l_aim_down"]		= %ai_tactical_walk_pistol_l_aim2;
	array[animType]["move"]["stand"]["pistol"]["tactical_l_aim_left"]		= %ai_tactical_walk_pistol_l_aim4;
	array[animType]["move"]["stand"]["pistol"]["tactical_l_aim_right"]		= %ai_tactical_walk_pistol_l_aim6;


//	array[animType]["move"]["stand"]["pistol"]["run_f_to_bR"]				= %ai_pistol_run_to_exposed_8;
//	array[animType]["move"]["stand"]["pistol"]["run_f_to_bL"]				= %ai_pistol_run_to_exposed_8;

	array[animType]["move"]["stand"]["pistol"]["run_n_gun_f"]				= %ai_pistol_run_n_gun_f;
	array[animType]["move"]["stand"]["pistol"]["run_n_gun_r"]				= %ai_pistol_run_n_gun_r;
	array[animType]["move"]["stand"]["pistol"]["run_n_gun_l"]				= %ai_pistol_run_n_gun_l;
	array[animType]["move"]["stand"]["pistol"]["run_n_gun_b"]				= %ai_pistol_run_n_gun_b;

	array[animType]["move"]["stand"]["pistol"]["add_f_aim_up"]				= %ai_pistol_run_f_aim_8;
	array[animType]["move"]["stand"]["pistol"]["add_f_aim_down"]			= %ai_pistol_run_f_aim_2;
	array[animType]["move"]["stand"]["pistol"]["add_f_aim_left"]			= %ai_pistol_run_f_aim_4;
	array[animType]["move"]["stand"]["pistol"]["add_f_aim_right"]			= %ai_pistol_run_f_aim_6;

	array[animType]["move"]["stand"]["pistol"]["start_stand_run_f"]			= %ai_pistol_run_lowready_f;
	array[animType]["move"]["crouch"]["pistol"]["start_stand_run_f"]		= %ai_pistol_run_lowready_f;
	array[animType]["move"]["prone"]["pistol"]["start_stand_run_f"]			= %ai_pistol_run_lowready_f;

	array[animType]["move"]["stand"]["pistol"]["run_f_to_bR"]				= %ai_pistol_run_f2b_a;
	array[animType]["move"]["stand"]["pistol"]["run_f_to_bL"]				= %ai_pistol_run_f2b;

	array[animType]["move"]["stand"]["pistol"]["fire"]						= %pistol_stand_fire_A;
	array[animType]["move"]["stand"]["pistol"]["single"]					= array( %pistol_stand_fire_A );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Run Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Turn Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// run forward turns
	array[animType]["turn"]["stand"]["pistol"]["turn_f_l_45"]				= %ai_pistol_run_f_turn_45_l;
	array[animType]["turn"]["stand"]["pistol"]["turn_f_l_90"]				= %ai_pistol_run_f_turn_90_l;
	array[animType]["turn"]["stand"]["pistol"]["turn_f_l_135"]				= %ai_pistol_run_f_turn_180_l;
	array[animType]["turn"]["stand"]["pistol"]["turn_f_l_180"]				= %ai_pistol_run_f_turn_180_l;
	array[animType]["turn"]["stand"]["pistol"]["turn_f_r_45"]				= %ai_pistol_run_f_turn_45_r;
	array[animType]["turn"]["stand"]["pistol"]["turn_f_r_90"]				= %ai_pistol_run_f_turn_90_r;
	array[animType]["turn"]["stand"]["pistol"]["turn_f_r_135"]				= %ai_pistol_run_f_turn_180_r;
	array[animType]["turn"]["stand"]["pistol"]["turn_f_r_180"]				= %ai_pistol_run_f_turn_180_r;

	// run backward turns
	array[animType]["turn"]["stand"]["pistol"]["turn_b_l_180"]				= %ai_pistol_run_b2f;
	array[animType]["turn"]["stand"]["pistol"]["turn_b_r_180"]				= %ai_pistol_run_b2f_a;

	array[animType]["turn"]["stand"]["pistol"]["turn_b_l_180_sprint"]		= %ai_pistol_run_b2f;
	array[animType]["turn"]["stand"]["pistol"]["turn_b_r_180_sprint"]		= %ai_pistol_run_b2f_a;

	// aims
	array[animType]["turn"]["stand"]["pistol"]["add_aim_up"]				= %ai_pistol_run_f_aim_8;
	array[animType]["turn"]["stand"]["pistol"]["add_aim_down"]				= %ai_pistol_run_f_aim_2;
	array[animType]["turn"]["stand"]["pistol"]["add_aim_left"]				= %ai_pistol_run_f_aim_4;
	array[animType]["turn"]["stand"]["pistol"]["add_aim_right"]				= %ai_pistol_run_f_aim_6;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Turn Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_left"]["stand"]["pistol"]["alert_idle"]			= %ai_pistol_cornerstand_left_idle_d;
	array[animType]["cover_left"]["stand"]["pistol"]["alert_idle_twitch"]	= array( %ai_pistol_cornerstand_left_twitch_v1 );
	array[animType]["cover_left"]["stand"]["pistol"]["alert_idle_flinch"]	= array( %ai_pistol_cornerstand_left_idle_d );

	array[animType]["cover_left"]["stand"]["pistol"]["alert_to_lean"]		= array( %ai_pistol_cornerstand_left_to_aim5 );
	array[animType]["cover_left"]["stand"]["pistol"]["lean_to_alert"]		= array( %ai_pistol_cornerstand_aim5_to_left );

	array[animType]["cover_left"]["stand"]["pistol"]["lean_idle"]			= array( %ai_pistol_cornerstand_left_aim_5_add );

	array[animType]["cover_left"]["stand"]["pistol"]["lean_aim_straight"]	= %ai_pistol_cornerstand_left_aim_5;
	array[animType]["cover_left"]["stand"]["pistol"]["lean_aim_up"]			= %ai_pistol_cornerstand_left_aim_8;
	array[animType]["cover_left"]["stand"]["pistol"]["lean_aim_down"]		= %ai_pistol_cornerstand_left_aim_2;
	array[animType]["cover_left"]["stand"]["pistol"]["lean_aim_left"]		= %ai_pistol_cornerstand_left_aim_4;
	array[animType]["cover_left"]["stand"]["pistol"]["lean_aim_right"]		= %ai_pistol_cornerstand_left_aim_6;

	array[animType]["cover_left"]["stand"]["pistol"]["lean_single"]			= array( %ai_pistol_cornerstand_left_shoot_semi1 );
	array[animType]["cover_left"]["stand"]["pistol"]["lean_semi2"]			= %ai_pistol_cornerstand_left_shoot_semi2;
	array[animType]["cover_left"]["stand"]["pistol"]["lean_semi3"]			= %ai_pistol_cornerstand_left_shoot_semi3;
	array[animType]["cover_left"]["stand"]["pistol"]["lean_semi4"]			= %ai_pistol_cornerstand_left_shoot_semi4;
	array[animType]["cover_left"]["stand"]["pistol"]["lean_semi5"]			= %ai_pistol_cornerstand_left_shoot_semi5;

	array[animType]["cover_left"]["stand"]["pistol"]["blind_fire"]			= array( %ai_pistol_cornerstand_left_blindfire );
	array[animType]["cover_left"]["stand"]["pistol"]["reload"]				= array( %ai_pistol_cornerstand_left_reload );

	array[animType]["cover_left"]["stand"]["pistol"]["look"]				= %ai_pistol_cornerstand_left_peek;
	array[animType]["cover_left"]["stand"]["pistol"]["stance_change"]		= %ai_pistol_cornerl_stand_2_alert;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_right"]["stand"]["pistol"]["alert_idle"]			= %ai_pistol_cornerstand_right_idle_d;
	array[animType]["cover_right"]["stand"]["pistol"]["alert_idle_twitch"]	= array( %ai_pistol_cornerstand_right_twitch_v1 );
	array[animType]["cover_right"]["stand"]["pistol"]["alert_idle_flinch"]	= array( %ai_pistol_cornerstand_right_idle_d );

	array[animType]["cover_right"]["stand"]["pistol"]["lean_to_alert"]		= array( %ai_pistol_cornerstand_aim5_to_right );
	array[animType]["cover_right"]["stand"]["pistol"]["alert_to_lean"]		= array( %ai_pistol_cornerstand_right_to_aim5 );

	array[animType]["cover_right"]["stand"]["pistol"]["lean_idle"]			= array( %ai_pistol_cornerstand_right_aim_5_add );

	array[animType]["cover_right"]["stand"]["pistol"]["lean_aim_down"]		= %ai_pistol_cornerstand_right_aim_2;
	array[animType]["cover_right"]["stand"]["pistol"]["lean_aim_left"]		= %ai_pistol_cornerstand_right_aim_4;
	array[animType]["cover_right"]["stand"]["pistol"]["lean_aim_straight"]	= %ai_pistol_cornerstand_right_aim_5;
	array[animType]["cover_right"]["stand"]["pistol"]["lean_aim_right"]		= %ai_pistol_cornerstand_right_aim_6;
	array[animType]["cover_right"]["stand"]["pistol"]["lean_aim_up"]		= %ai_pistol_cornerstand_right_aim_8;

	array[animType]["cover_right"]["stand"]["pistol"]["lean_semi2"]			= %ai_pistol_cornerstand_right_shoot_semi2;
	array[animType]["cover_right"]["stand"]["pistol"]["lean_semi3"]			= %ai_pistol_cornerstand_right_shoot_semi3;
	array[animType]["cover_right"]["stand"]["pistol"]["lean_semi4"]			= %ai_pistol_cornerstand_right_shoot_semi4;
	array[animType]["cover_right"]["stand"]["pistol"]["lean_semi5"]			= %ai_pistol_cornerstand_right_shoot_semi5;
	array[animType]["cover_right"]["stand"]["pistol"]["lean_single"]		= array( %ai_pistol_cornerstand_right_shoot_semi1 );

	array[animType]["cover_right"]["stand"]["pistol"]["blind_fire"]			= array( %ai_pistol_cornerstand_right_blindfire );
	array[animType]["cover_right"]["stand"]["pistol"]["reload"]				= array( %ai_pistol_cornerstand_right_reload );

	array[animType]["cover_right"]["stand"]["pistol"]["look"]				= %ai_pistol_cornerstand_right_peek;
	array[animType]["cover_right"]["stand"]["pistol"]["stance_change"]		= %ai_pistol_cornerr_stand_2_alert;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_left"]["crouch"]["pistol"]["exposed_idle"]       	= array( %ai_pistol_crouch_exposed_idle );
	array[animType]["cover_left"]["crouch"]["pistol"]["exposed_idle_noncombat"] = array( %ai_pistol_crouch_exposed_idle );
	
	array[animType]["cover_left"]["crouch"]["pistol"]["alert_idle"]			= %ai_pistol_cornercrouch_left_idle_d;
	array[animType]["cover_left"]["crouch"]["pistol"]["alert_idle_twitch"]	= array( %ai_pistol_cornercrouch_left_twitch_v1 );
	array[animType]["cover_left"]["crouch"]["pistol"]["alert_idle_flinch"]	= array( %ai_pistol_cornercrouch_left_idle_d );

	array[animType]["cover_left"]["crouch"]["pistol"]["alert_to_lean"]		= array( %ai_pistol_crouchcorner_left_to_aim5 );
	array[animType]["cover_left"]["crouch"]["pistol"]["lean_to_alert"]		= array( %ai_pistol_crouchcorner_aim5_to_left );

	array[animType]["cover_left"]["crouch"]["pistol"]["lean_idle"]			= array( %ai_pistol_crouchcorner_left_aim_5_add );

	array[animType]["cover_left"]["crouch"]["pistol"]["lean_aim_straight"]	= %ai_pistol_crouchcorner_left_aim_5;
	array[animType]["cover_left"]["crouch"]["pistol"]["lean_aim_up"]		= %ai_pistol_crouchcorner_left_aim_8;
	array[animType]["cover_left"]["crouch"]["pistol"]["lean_aim_down"]		= %ai_pistol_crouchcorner_left_aim_2;
	array[animType]["cover_left"]["crouch"]["pistol"]["lean_aim_left"]		= %ai_pistol_crouchcorner_left_aim_4;
	array[animType]["cover_left"]["crouch"]["pistol"]["lean_aim_right"]		= %ai_pistol_crouchcorner_left_aim_6;

	array[animType]["cover_left"]["crouch"]["pistol"]["lean_single"]		= array( %ai_pistol_crouchcorner_left_shoot_semi1 );
	array[animType]["cover_left"]["crouch"]["pistol"]["lean_semi2"]			= %ai_pistol_crouchcorner_left_shoot_semi2;
	array[animType]["cover_left"]["crouch"]["pistol"]["lean_semi3"]			= %ai_pistol_crouchcorner_left_shoot_semi3;
	array[animType]["cover_left"]["crouch"]["pistol"]["lean_semi4"]			= %ai_pistol_crouchcorner_left_shoot_semi4;
	array[animType]["cover_left"]["crouch"]["pistol"]["lean_semi5"]			= %ai_pistol_crouchcorner_left_shoot_semi5;

	array[animType]["cover_left"]["crouch"]["pistol"]["over_to_alert"]		= array( %ai_pistol_cornercrl_over_2_alert );
	array[animType]["cover_left"]["crouch"]["pistol"]["alert_to_over"]		= array( %ai_pistol_cornercrl_alert_2_over );	
	
	array[animType]["cover_left"]["crouch"]["pistol"]["over_aim_straight"]	= %ai_pistol_crouch_exposed_aim_5;
	array[animType]["cover_left"]["crouch"]["pistol"]["over_aim_up"]		= %ai_pistol_crouch_exposed_aim_8;
	array[animType]["cover_left"]["crouch"]["pistol"]["over_aim_down"]		= %ai_pistol_crouch_exposed_aim_2;
	array[animType]["cover_left"]["crouch"]["pistol"]["over_aim_left"]		= %ai_pistol_crouch_exposed_aim_4;
	array[animType]["cover_left"]["crouch"]["pistol"]["over_aim_right"]		= %ai_pistol_crouch_exposed_aim_6;  
	
	array[animType]["cover_left"]["crouch"]["pistol"]["blind_fire"]			= array( %ai_pistol_cornercrouch_left_blindfire );
	array[animType]["cover_left"]["crouch"]["pistol"]["reload"]				= array( %ai_pistol_cornercrouch_left_reload );

	array[animType]["cover_left"]["crouch"]["pistol"]["look"]				= %ai_pistol_cornercrouch_left_peek;
	array[animType]["cover_left"]["crouch"]["pistol"]["stance_change"]		= %ai_pistol_cornerl_alert_2_stand;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_right"]["crouch"]["pistol"]["exposed_idle"]       	 = array( %ai_pistol_crouch_exposed_idle );
	array[animType]["cover_right"]["crouch"]["pistol"]["exposed_idle_noncombat"] = array( %ai_pistol_crouch_exposed_idle );

	array[animType]["cover_right"]["crouch"]["pistol"]["alert_idle"]		= %ai_pistol_cornercrouch_right_idle_d;
	array[animType]["cover_right"]["crouch"]["pistol"]["alert_idle_twitch"]	= array( %ai_pistol_cornercrouch_right_twitch_v1 );
	array[animType]["cover_right"]["crouch"]["pistol"]["alert_idle_flinch"]	= array( %ai_pistol_cornercrouch_right_idle_d );

	array[animType]["cover_right"]["crouch"]["pistol"]["alert_to_lean"]		= array( %ai_pistol_crouchcorner_right_to_aim5 );
	array[animType]["cover_right"]["crouch"]["pistol"]["lean_to_alert"]		= array( %ai_pistol_crouchcorner_aim5_to_right );

	array[animType]["cover_right"]["crouch"]["pistol"]["lean_idle"]			= array( %ai_pistol_crouchcorner_right_aim_5_add );

	array[animType]["cover_right"]["crouch"]["pistol"]["lean_aim_straight"]	= %ai_pistol_crouchcorner_right_aim_5;
	array[animType]["cover_right"]["crouch"]["pistol"]["lean_aim_up"]		= %ai_pistol_crouchcorner_right_aim_8;
	array[animType]["cover_right"]["crouch"]["pistol"]["lean_aim_down"]		= %ai_pistol_crouchcorner_right_aim_2;
	array[animType]["cover_right"]["crouch"]["pistol"]["lean_aim_left"]		= %ai_pistol_crouchcorner_right_aim_4;
	array[animType]["cover_right"]["crouch"]["pistol"]["lean_aim_right"]	= %ai_pistol_crouchcorner_right_aim_6;

	array[animType]["cover_right"]["crouch"]["pistol"]["lean_single"]		= array( %ai_pistol_crouchcorner_right_shoot_semi1 );
	array[animType]["cover_right"]["crouch"]["pistol"]["lean_semi2"]		= %ai_pistol_crouchcorner_right_shoot_semi2;
	array[animType]["cover_right"]["crouch"]["pistol"]["lean_semi3"]		= %ai_pistol_crouchcorner_right_shoot_semi3;
	array[animType]["cover_right"]["crouch"]["pistol"]["lean_semi4"]		= %ai_pistol_crouchcorner_right_shoot_semi4;
	array[animType]["cover_right"]["crouch"]["pistol"]["lean_semi5"]		= %ai_pistol_crouchcorner_right_shoot_semi5;
	
	array[animType]["cover_right"]["crouch"]["pistol"]["over_to_alert"]		= array( %ai_pistol_cornercrr_over_2_alert );
	array[animType]["cover_right"]["crouch"]["pistol"]["alert_to_over"]		= array( %ai_pistol_cornercrr_alert_2_over );	
	
	array[animType]["cover_right"]["crouch"]["pistol"]["over_aim_straight"]	= %ai_pistol_crouch_exposed_aim_5;
	array[animType]["cover_right"]["crouch"]["pistol"]["over_aim_up"]		= %ai_pistol_crouch_exposed_aim_8;
	array[animType]["cover_right"]["crouch"]["pistol"]["over_aim_down"]		= %ai_pistol_crouch_exposed_aim_2;
	array[animType]["cover_right"]["crouch"]["pistol"]["over_aim_left"]		= %ai_pistol_crouch_exposed_aim_4;
	array[animType]["cover_right"]["crouch"]["pistol"]["over_aim_right"]	= %ai_pistol_crouch_exposed_aim_6;  
	
	array[animType]["cover_right"]["crouch"]["pistol"]["blind_fire"]		= array( %ai_pistol_cornercrouch_right_blindfire );
	array[animType]["cover_right"]["crouch"]["pistol"]["reload"]			= array( %ai_pistol_cornercrouch_right_reload );

	array[animType]["cover_right"]["crouch"]["pistol"]["look"]				= %ai_pistol_cornercrouch_right_peek;
	array[animType]["cover_right"]["crouch"]["pistol"]["stance_change"]		= %ai_pistol_cornerr_alert_2_stand;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_stand"]["stand"]["pistol"]["hide_idle"]			= %ai_pistol_standcover_hide_idle_d;
	array[animType]["cover_stand"]["stand"]["pistol"]["hide_idle_twitch"]	= array( %ai_pistol_standcover_hide_twitch_v1 );
	array[animType]["cover_stand"]["stand"]["pistol"]["hide_idle_flinch"]	= array( %ai_pistol_standcover_hide_idle_d );

	array[animType]["cover_stand"]["stand"]["pistol"]["hide_2_stand"]		= %ai_pistol_standcover_hide_to_aim5;
	array[animType]["cover_stand"]["stand"]["pistol"]["stand_2_hide"]		= %ai_pistol_standcover_aim5_to_hide;
	array[animType]["cover_stand"]["stand"]["pistol"]["hide_2_over"]		= %ai_pistol_standcover_hide_to_aim5;
	array[animType]["cover_stand"]["stand"]["pistol"]["over_2_hide"]		= %ai_pistol_standcover_aim5_to_hide;
		
	array[animType]["cover_stand"]["stand"]["pistol"]["stand_aim"]			= %ai_pistol_standcover_hide_aim_5;
	array[animType]["cover_stand"]["stand"]["pistol"]["crouch_aim"]			= %ai_pistol_crouchcover_hide_aim_5;
	array[animType]["cover_stand"]["stand"]["pistol"]["lean_aim"]			= %ai_pistol_standcover_hide_aim_5;
	array[animType]["cover_stand"]["stand"]["pistol"]["over_aim"]			= %ai_pistol_standcover_hide_aim_5;

	array[animType]["cover_stand"]["stand"]["pistol"]["over_add_aim_up"]	= %ai_pistol_standcover_hide_aim_8;
	array[animType]["cover_stand"]["stand"]["pistol"]["over_add_aim_down"]	= %ai_pistol_standcover_hide_aim_2;
	array[animType]["cover_stand"]["stand"]["pistol"]["over_add_aim_left"]	= %ai_pistol_standcover_hide_aim_4;
	array[animType]["cover_stand"]["stand"]["pistol"]["over_add_aim_right"]	= %ai_pistol_standcover_hide_aim_6;

	array[animType]["cover_stand"]["stand"]["pistol"]["add_aim_up"]			= %ai_pistol_standcover_hide_aim_8;
	array[animType]["cover_stand"]["stand"]["pistol"]["add_aim_down"]		= %ai_pistol_standcover_hide_aim_2;
	array[animType]["cover_stand"]["stand"]["pistol"]["add_aim_left"]		= %ai_pistol_standcover_hide_aim_4;
	array[animType]["cover_stand"]["stand"]["pistol"]["add_aim_right"]		= %ai_pistol_standcover_hide_aim_6;

	array[animType]["cover_stand"]["stand"]["pistol"]["single"]				= array( %ai_pistol_standcover_hide_shoot_semi1 );
	array[animType]["cover_stand"]["stand"]["pistol"]["semi2"]				= %ai_pistol_standcover_hide_shoot_semi2;
	array[animType]["cover_stand"]["stand"]["pistol"]["semi3"]				= %ai_pistol_standcover_hide_shoot_semi3;
	array[animType]["cover_stand"]["stand"]["pistol"]["semi4"]				= %ai_pistol_standcover_hide_shoot_semi4;
	array[animType]["cover_stand"]["stand"]["pistol"]["semi5"]				= %ai_pistol_standcover_hide_shoot_semi5;

	array[animType]["cover_stand"]["stand"]["pistol"]["blind_fire"]			= array( %ai_pistol_standcover_hide_blindfire );
	array[animType]["cover_stand"]["stand"]["pistol"]["reload"]				= array( %ai_pistol_standcover_hide_reload );

	array[animType]["cover_stand"]["stand"]["pistol"]["look"]				= %ai_pistol_standcover_hide_peek;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Stand (Crouch) Actions (same as cover crouch)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_stand"]["crouch"]["pistol"]["hide_idle"]				= %ai_pistol_crouchcover_hide_idle_d;
	array[animType]["cover_stand"]["crouch"]["pistol"]["hide_idle_twitch"]		= array( %ai_pistol_crouchcover_hide_twitch_v1 );
	array[animType]["cover_stand"]["crouch"]["pistol"]["hide_idle_flinch"]		= array( %ai_pistol_crouchcover_hide_idle_d );

	array[animType]["cover_stand"]["crouch"]["pistol"]["hide_2_stand"]			= %ai_pistol_standcover_hide_to_aim5;
	array[animType]["cover_stand"]["crouch"]["pistol"]["stand_2_hide"]			= %ai_pistol_standcover_aim5_to_hide;

	array[animType]["cover_stand"]["crouch"]["pistol"]["hide_2_crouch"]			= %ai_pistol_crouchcover_hide_to_aim5;
	array[animType]["cover_stand"]["crouch"]["pistol"]["crouch_2_hide"]			= %ai_pistol_crouchcover_aim5_to_hide;

	array[animType]["cover_stand"]["crouch"]["pistol"]["crouch_aim"]			= %ai_pistol_crouchcover_hide_aim_5;
	array[animType]["cover_stand"]["crouch"]["pistol"]["add_aim_up"]			= %ai_pistol_crouchcover_hide_aim_8;
	array[animType]["cover_stand"]["crouch"]["pistol"]["add_aim_down"]			= %ai_pistol_crouchcover_hide_aim_2;
	array[animType]["cover_stand"]["crouch"]["pistol"]["add_aim_left"]			= %ai_pistol_crouchcover_hide_aim_4;
	array[animType]["cover_stand"]["crouch"]["pistol"]["add_aim_right"]			= %ai_pistol_crouchcover_hide_aim_6;

	array[animType]["cover_stand"]["crouch"]["pistol"]["single"]				= array( %ai_pistol_crouchcover_hide_shoot_semi1 );
	array[animType]["cover_stand"]["crouch"]["pistol"]["semi2"]					= %ai_pistol_crouchcover_hide_shoot_semi2;
	array[animType]["cover_stand"]["crouch"]["pistol"]["semi3"]					= %ai_pistol_crouchcover_hide_shoot_semi3;
	array[animType]["cover_stand"]["crouch"]["pistol"]["semi4"]					= %ai_pistol_crouchcover_hide_shoot_semi4;
	array[animType]["cover_stand"]["crouch"]["pistol"]["semi5"]					= %ai_pistol_crouchcover_hide_shoot_semi5;

	array[animType]["cover_stand"]["crouch"]["pistol"]["blind_fire"]			= array( %ai_pistol_crouchcover_hide_blindfire );
	array[animType]["cover_stand"]["crouch"]["pistol"]["reload"]				= array( %ai_pistol_crouchcover_hide_reload );

	array[animType]["cover_stand"]["crouch"]["pistol"]["look"]					= %ai_pistol_crouchcover_hide_peek;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Stand (Crouch) Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_crouch"]["crouch"]["pistol"]["hide_idle"]			= %ai_pistol_crouchcover_hide_idle_d;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["hide_idle_twitch"]		= array( %ai_pistol_crouchcover_hide_twitch_v1 );
	array[animType]["cover_crouch"]["crouch"]["pistol"]["hide_idle_flinch"]		= array( %ai_pistol_crouchcover_hide_idle_d );

	array[animType]["cover_crouch"]["crouch"]["pistol"]["hide_2_stand"]			= %ai_pistol_standcover_hide_to_aim5;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["stand_2_hide"]			= %ai_pistol_standcover_aim5_to_hide;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["hide_2_crouch"]		= %ai_pistol_crouchcover_hide_to_aim5;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["crouch_2_hide"]		= %ai_pistol_crouchcover_aim5_to_hide;
	
	array[animType]["cover_crouch"]["crouch"]["pistol"]["hide_2_left"]			= %ai_pistol_covercrouch_hide_2_left;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["hide_2_right"]			= %ai_pistol_covercrouch_hide_2_right;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["left_2_hide"]			= %ai_pistol_covercrouch_left_2_hide;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["right_2_hide"]			= %ai_pistol_covercrouch_right_2_hide;

	array[animType]["cover_crouch"]["crouch"]["pistol"]["crouch_aim"]			= %ai_pistol_crouchcover_hide_aim_5;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["add_aim_up"]			= %ai_pistol_crouchcover_hide_aim_8;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["add_aim_down"]			= %ai_pistol_crouchcover_hide_aim_2;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["add_aim_left"]			= %ai_pistol_crouchcover_hide_aim_4;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["add_aim_right"]		= %ai_pistol_crouchcover_hide_aim_6;

	array[animType]["cover_crouch"]["crouch"]["pistol"]["single"]				= array( %ai_pistol_crouchcover_hide_shoot_semi1 );
	array[animType]["cover_crouch"]["crouch"]["pistol"]["semi2"]				= %ai_pistol_crouchcover_hide_shoot_semi2;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["semi3"]				= %ai_pistol_crouchcover_hide_shoot_semi3;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["semi4"]				= %ai_pistol_crouchcover_hide_shoot_semi4;
	array[animType]["cover_crouch"]["crouch"]["pistol"]["semi5"]				= %ai_pistol_crouchcover_hide_shoot_semi5;

	array[animType]["cover_crouch"]["crouch"]["pistol"]["blind_fire"]			= array( %ai_pistol_crouchcover_hide_blindfire );
	array[animType]["cover_crouch"]["crouch"]["pistol"]["reload"]				= array( %ai_pistol_crouchcover_hide_reload );

	array[animType]["cover_crouch"]["crouch"]["pistol"]["look"]					= %ai_pistol_crouchcover_hide_peek;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Start Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	array[animType]["move"]["stand"]["pistol"]["mantle_over_96"]				= %ai_mantle_over_96_pistol;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["pistol"]["cover_left_head"]				= %ai_pistol_cornerstand_left_pain_head;
	array[animType]["pain"]["stand"]["pistol"]["cover_left_groin"]				= %ai_pistol_cornerstand_left_pain_groin;
	array[animType]["pain"]["stand"]["pistol"]["cover_left_chest"]				= %ai_pistol_cornerstand_left_pain_chest;
	array[animType]["pain"]["stand"]["pistol"]["cover_left_left_leg"]			= %ai_pistol_cornerstand_left_pain_leftleg;
	array[animType]["pain"]["stand"]["pistol"]["cover_left_right_leg"]			= %ai_pistol_cornerstand_left_pain_rightleg;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Left Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["pistol"]["cover_right_chest"]				= %ai_pistol_cornerstand_right_pain_chest;
	array[animType]["pain"]["stand"]["pistol"]["cover_right_groin"]				= %ai_pistol_cornerstand_right_pain_groin;
	array[animType]["pain"]["stand"]["pistol"]["cover_right_right_leg"]			= %ai_pistol_cornerstand_right_pain_rightleg;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Right Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Crouch Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["crouch"]["pistol"]["cover_left_head"]				= %ai_pistol_cornercrouch_left_pain_head;
	array[animType]["pain"]["crouch"]["pistol"]["cover_left_groin"]				= %ai_pistol_cornercrouch_left_pain_groin;
	array[animType]["pain"]["crouch"]["pistol"]["cover_left_chest"]				= %ai_pistol_cornercrouch_left_pain_chest;
	array[animType]["pain"]["crouch"]["pistol"]["cover_left_left_leg"]			= %ai_pistol_cornercrouch_left_pain_leftleg;
	array[animType]["pain"]["crouch"]["pistol"]["cover_left_right_leg"]			= %ai_pistol_cornercrouch_left_pain_rightleg;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Left Crouch Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Crouch Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["crouch"]["pistol"]["cover_right_chest"]			= %ai_pistol_cornercrouch_right_pain_chest;
	array[animType]["pain"]["crouch"]["pistol"]["cover_right_groin"]			= %ai_pistol_cornercrouch_right_pain_groin;
	array[animType]["pain"]["crouch"]["pistol"]["cover_right_right_leg"]		= %ai_pistol_cornercrouch_right_pain_rightleg;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Right Crouch Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Stand Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["pistol"]["cover_stand_chest"]				= %ai_pistol_standcover_hide_pain_chest;
	array[animType]["pain"]["stand"]["pistol"]["cover_stand_groin"]				= %ai_pistol_standcover_hide_pain_groin;
	array[animType]["pain"]["stand"]["pistol"]["cover_stand_left_leg"]			= %ai_pistol_standcover_hide_pain_groin;
	array[animType]["pain"]["stand"]["pistol"]["cover_stand_right_leg"]			= %ai_pistol_standcover_hide_pain_groin;
	
	array[animType]["pain"]["stand"]["pistol"]["cover_stand_aim"]				= array( %ai_pistol_coverstand_aim_pain_2_hide_01, 
	                                                                        			 %ai_pistol_coverstand_aim_pain_2_hide_02 );

	array[animType]["pain"]["crouch"]["pistol"]["cover_stand_chest"]			= %ai_pistol_standcover_hide_pain_chest;
	array[animType]["pain"]["crouch"]["pistol"]["cover_stand_groin"]			= %ai_pistol_standcover_hide_pain_groin;
	array[animType]["pain"]["crouch"]["pistol"]["cover_stand_left_leg"]			= %ai_pistol_standcover_hide_pain_groin;
	array[animType]["pain"]["crouch"]["pistol"]["cover_stand_right_leg"]		= %ai_pistol_standcover_hide_pain_groin;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Stand Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Crouch Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["pistol"]["cover_crouch_front"]			= %ai_pistol_crouchcover_hide_pain_chest;
	array[animType]["pain"]["stand"]["pistol"]["cover_crouch_left"]				= %ai_pistol_crouchcover_hide_pain_leftleg;
	array[animType]["pain"]["stand"]["pistol"]["cover_crouch_right"]			= %ai_pistol_crouchcover_hide_pain_rightleg;
	array[animType]["pain"]["stand"]["pistol"]["cover_crouch_back"]				= %ai_pistol_crouchcover_hide_pain_groin;
	
	array[animType]["pain"]["crouch"]["pistol"]["cover_crouch_front"]			= %ai_pistol_crouchcover_hide_pain_chest;
	array[animType]["pain"]["crouch"]["pistol"]["cover_crouch_left"]			= %ai_pistol_crouchcover_hide_pain_leftleg;
	array[animType]["pain"]["crouch"]["pistol"]["cover_crouch_right"]			= %ai_pistol_crouchcover_hide_pain_rightleg;
	array[animType]["pain"]["crouch"]["pistol"]["cover_crouch_back"]			= %ai_pistol_crouchcover_hide_pain_groin;

	array[animType]["pain"]["crouch"]["pistol"]["cover_crouch_aim"]				= %ai_pistol_crouchcover_hide_pain_groin;
	array[animType]["pain"]["crouch"]["pistol"]["cover_crouch_aim_right"]		= %ai_pistol_covercrouch_pain_aim_2_hide_01_r;
	array[animType]["pain"]["crouch"]["pistol"]["cover_crouch_aim_left"]		= %ai_pistol_covercrouch_pain_aim_2_hide_01_l;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Crouch Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Stop Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["stop"]["stand"]["pistol"]["idle_trans_in"]					= %ai_pistol_casual_stand_idle_trans_in;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Stop Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["react"]["stand"]["pistol"]["run_head"]		             = %ai_pistol_run_lowready_f_miss_detect_head; 
	array[animType]["react"]["stand"]["pistol"]["run_lower_torso_fast"]      = %ai_pistol_run_lowready_f_miss_detect_legs;
	array[animType]["react"]["stand"]["pistol"]["run_lower_torso_stop"]      = %ai_pistol_run_lowready_f_miss_detect_torso;


	return array;
}