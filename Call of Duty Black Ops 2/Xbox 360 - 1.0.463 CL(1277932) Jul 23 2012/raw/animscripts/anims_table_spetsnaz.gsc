#include common_scripts\Utility;

#using_animtree ("generic_human");

setup_spetsnaz_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );

	// ALEXP_TODO: this eats up script vars, find a way to only call this if spetznas are present

	// replace the base run
	array[animType]["move"]["stand"]["rifle"]["combat_run_f"]				= %ai_spetz_run_f;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Rush Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["rifle"]["step_left_rh"]				= array( %ai_spets_rusher_step_45l_2_run_01, %ai_spets_rusher_step_45l_2_run_02 );
	array[animType]["move"]["stand"]["rifle"]["step_left_lh"]				= array( %ai_spets_rusher_step_45l_2_run_a_01, %ai_spets_rusher_step_45l_2_run_a_02 );

	array[animType]["move"]["stand"]["rifle"]["step_right_rh"]				= array( %ai_spets_rusher_step_45r_2_run_01, %ai_spets_rusher_step_45r_2_run_02 );
	array[animType]["move"]["stand"]["rifle"]["step_right_lh"]				= array( %ai_spets_rusher_step_45r_2_run_a_01, %ai_spets_rusher_step_45r_2_run_a_02 );

	array[animType]["move"]["stand"]["rifle"]["roll_left_rh"]				= array( %ai_spets_rusher_roll_45l_2_run_01, %ai_spets_rusher_roll_45l_2_run_02);
	array[animType]["move"]["stand"]["rifle"]["roll_left_lh"]				= array( %ai_spets_rusher_roll_45l_2_run_a_01, %ai_spets_rusher_roll_45l_2_run_a_02 );

	array[animType]["move"]["stand"]["rifle"]["roll_right_rh"]				= array( %ai_spets_rusher_roll_45r_2_run_01, %ai_spets_rusher_roll_45r_2_run_02 );
	array[animType]["move"]["stand"]["rifle"]["roll_right_lh"]				= array( %ai_spets_rusher_roll_45r_2_run_a_01, %ai_spets_rusher_roll_45r_2_run_a_02 );

	array[animType]["move"]["stand"]["rifle"]["roll_forward_rh"]			= array( %ai_spets_rusher_roll_forward_01, %ai_spets_rusher_roll_forward_02 );
	array[animType]["move"]["stand"]["rifle"]["roll_forward_lh"]			= array( %ai_spets_rusher_roll_forward_01, %ai_spets_rusher_roll_forward_02 );

	array[animType]["move"]["stand"]["rifle"]["rusher_run_f_rh"]			= array( %ai_spets_rusher_run_f_01, %ai_spets_rusher_run_f_02, %ai_spets_rusher_run_f_03 );
	array[animType]["move"]["stand"]["rifle"]["rusher_run_f_lh"]			= array( %ai_spets_rusher_run_f_a_01, %ai_spets_rusher_run_f_a_02, %ai_spets_rusher_run_f_a_03 );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Rush Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Rush Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["pistol"]["step_left_rh"]				= array( %ai_spets_pistol_rusher_step_45l_2_run_01 );
	array[animType]["move"]["stand"]["pistol"]["step_left_lh"]				= array( %ai_spets_pistol_rusher_step_45l_2_run_01 );

	array[animType]["move"]["stand"]["pistol"]["step_right_rh"]				= array( %ai_spets_pistol_rusher_step_45r_2_run_01 );
	array[animType]["move"]["stand"]["pistol"]["step_right_lh"]				= array( %ai_spets_pistol_rusher_step_45r_2_run_01 );

	array[animType]["move"]["stand"]["pistol"]["roll_left_rh"]				= array( %ai_spets_pistol_rusher_roll_45l_2_run_01 );
	array[animType]["move"]["stand"]["pistol"]["roll_left_lh"]				= array( %ai_spets_pistol_rusher_roll_45l_2_run_01 );

	array[animType]["move"]["stand"]["pistol"]["roll_right_rh"]				= array( %ai_spets_pistol_rusher_roll_45r_2_run_01 );
	array[animType]["move"]["stand"]["pistol"]["roll_right_lh"]				= array( %ai_spets_pistol_rusher_roll_45r_2_run_01 );

	array[animType]["move"]["stand"]["pistol"]["roll_forward_rh"]			= array( %ai_spets_pistol_rusher_roll_forward_01 );
	array[animType]["move"]["stand"]["pistol"]["roll_forward_lh"]			= array( %ai_spets_pistol_rusher_roll_forward_01 );

	array[animType]["move"]["stand"]["pistol"]["rusher_run_f_rh"]			= array( %ai_pistol_rusher_run_f );
	array[animType]["move"]["stand"]["pistol"]["rusher_run_f_lh"]			= array( %ai_pistol_rusher_run_f );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Rush Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][1]				= %ai_spets_run_2_corner_stand_l_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][2]				= %ai_spets_run_2_corner_stand_l_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][3]				= %ai_spets_run_2_corner_stand_l_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][4]				= %ai_spets_run_2_corner_stand_l_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][6]				= %ai_spets_run_2_corner_stand_l_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][7]				= %ai_spets_run_2_corner_stand_l_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][8]				= %ai_spets_run_2_corner_stand_l_8;
	//array[animType]["move"]["stand"]["rifle"]["arrive_left"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][1]		= %ai_spets_run_2_corner_crouch_l_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][2]		= %ai_spets_run_2_corner_crouch_l_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][3]		= %ai_spets_run_2_corner_crouch_l_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][4]		= %ai_spets_run_2_corner_crouch_l_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][6]		= %ai_spets_run_2_corner_crouch_l_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][7]		= %ai_spets_run_2_corner_crouch_l_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][8]		= %ai_spets_run_2_corner_crouch_l_8;
	//array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][9]	= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["arrive_right"][1]			= %ai_spets_run_2_corner_stand_r_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][2]			= %ai_spets_run_2_corner_stand_r_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][3]			= %ai_spets_run_2_corner_stand_r_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][4]			= %ai_spets_run_2_corner_stand_r_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][6]			= %ai_spets_run_2_corner_stand_r_6;
	//array[animType]["move"]["stand"]["rifle"]["arrive_right"][7]			= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][8]			= %ai_spets_run_2_corner_stand_r_8;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][9]			= %ai_spets_run_2_corner_stand_r_9;

	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][1]		= %ai_spets_run_2_corner_crouch_r_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][2]		= %ai_spets_run_2_corner_crouch_r_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][3]		= %ai_spets_run_2_corner_crouch_r_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][4]		= %ai_spets_run_2_corner_crouch_r_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][6]		= %ai_spets_run_2_corner_crouch_r_6;
	//array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][7]	= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][8]		= %ai_spets_run_2_corner_crouch_r_8;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][9]		= %ai_spets_run_2_corner_crouch_r_9;

	array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][1]			= %ai_spets_run_2_crouch_cover_hide_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][2]			= %ai_spets_run_2_crouch_cover_hide_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][3]			= %ai_spets_run_2_crouch_cover_hide_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][4]			= %covercrouch_run_in_L;
	array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][6]			= %covercrouch_run_in_R;
	//array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][7]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][8]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["arrive_stand"][1]			= %ai_spets_run_2_stand_cover_hide_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_stand"][2]			= %ai_spets_run_2_stand_cover_hide_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_stand"][3]			= %ai_spets_run_2_stand_cover_hide_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_stand"][4]			= %ai_spets_run_2_stand_cover_hide_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_stand"][6]			= %ai_spets_run_2_stand_cover_hide_6;
	//array[animType]["move"]["stand"]["rifle"]["arrive_stand"][7]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["arrive_stand"][8]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["arrive_stand"][9]			= can't approach from this direction
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Exit Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["rifle"]["exit_right"][1]				= %corner_standR_trans_OUT_1;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][2]				= %corner_standR_trans_OUT_2;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][3]				= %corner_standR_trans_OUT_3;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][4]				= %ai_spets_corner_stand_r_2_run_4;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][6]				= %ai_spets_corner_stand_r_2_run_6;
	//array[animType]["move"]["stand"]["rifle"]["exit_right"][7]			= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["exit_right"][8]				= %corner_standR_trans_OUT_8;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][9]				= %corner_standR_trans_OUT_9;

	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][1]		= %CornerCrR_trans_OUT_ML;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][2]		= %CornerCrR_trans_OUT_M;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][3]		= %CornerCrR_trans_OUT_MR;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][4]		= %ai_spets_corner_crouch_r_2_run_4;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][6]		= %ai_spets_corner_crouch_r_2_run_6;
	//array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][7]		= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][8]		= %CornerCrR_trans_OUT_F;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][9]		= %CornerCrR_trans_OUT_MF;

	array[animType]["move"]["stand"]["rifle"]["exit_left"][1]				= %corner_standL_trans_OUT_1;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][2]				= %corner_standL_trans_OUT_2;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][3]				= %corner_standL_trans_OUT_3;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][4]				= %ai_spets_corner_stand_l_2_run_4;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][6]				= %ai_spets_corner_stand_l_2_run_6;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][7]				= %corner_standL_trans_OUT_7;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][8]				= %corner_standL_trans_OUT_8;
	//array[animType]["move"]["stand"]["rifle"]["exit_left"][9]				= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][1]		= %CornerCrL_trans_OUT_ML;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][2]		= %CornerCrL_trans_OUT_M;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][3]		= %CornerCrL_trans_OUT_MR;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][4]		= %ai_spets_corner_crouch_l_2_run_4;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][6]		= %ai_spets_corner_crouch_l_2_run_6;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][7]		= %CornerCrL_trans_OUT_MF;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][8]		= %CornerCrL_trans_OUT_M;
	//array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][9]		= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["exit_crouch"][1]				= %covercrouch_run_out_ML;
	array[animType]["move"]["stand"]["rifle"]["exit_crouch"][2]				= %covercrouch_run_out_M;
	array[animType]["move"]["stand"]["rifle"]["exit_crouch"][3]				= %covercrouch_run_out_MR;
	array[animType]["move"]["stand"]["rifle"]["exit_crouch"][4]				= %ai_spets_crouch_cover_hide_2_run_4;
	array[animType]["move"]["stand"]["rifle"]["exit_crouch"][6]				= %ai_spets_crouch_cover_hide_2_run_6;
	//array[animType]["move"]["stand"]["rifle"]["exit_crouch"][7]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["exit_crouch"][8]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["exit_crouch"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["exit_stand"][1]				= %coverstand_trans_OUT_ML;
	array[animType]["move"]["stand"]["rifle"]["exit_stand"][2]				= %coverstand_trans_OUT_M;
	array[animType]["move"]["stand"]["rifle"]["exit_stand"][3]				= %coverstand_trans_OUT_MR;
	array[animType]["move"]["stand"]["rifle"]["exit_stand"][4]				= %ai_spets_stand_cover_hide_2_run_4;
	array[animType]["move"]["stand"]["rifle"]["exit_stand"][6]				= %ai_spets_stand_cover_hide_2_run_6;
	//array[animType]["move"]["stand"]["rifle"]["exit_stand"][7]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["exit_stand"][8]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["exit_stand"][9]			= can't approach from this direction

	// ALEXP_TODO: figure out how to do this without duplicating these large arrays to save scriptVars
	arrivalKeys = getArrayKeys( array[animType]["move"]["stand"]["rifle"] );
	for( i=0; i < arrivalKeys.size; i++ )
	{
		arrivalType = arrivalKeys[i];

		// only arrival and exits are arrays
		if( IsArray( array[animType]["move"]["stand"]["rifle"][arrivalType] ) )
		{
			array[animType]["move"]["crouch"]["rifle"][arrivalType] = array[animType]["move"]["stand"]["rifle"][arrivalType];
		}
	}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Exit Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Aim Awareness
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// only add the rolling animations
//	array[animType]["combat"]["crouch"]["rifle"]["aim_aware_reaction"]		= array( %ai_spets_aim_aware_crouch_1_a,
//																					 %ai_spets_aim_aware_crouch_1_b,
//																					 %ai_spets_aim_aware_crouch_3_a,
//																					 %ai_spets_aim_aware_crouch_3_b,
//																					 %ai_spets_aim_aware_crouch_4_a,
//																					 %ai_spets_aim_aware_crouch_4_b,
//																					 %ai_spets_aim_aware_crouch_6_a,
//																					 %ai_spets_aim_aware_crouch_6_b,
//																					 %ai_spets_aim_aware_crouch_7_a,
//																					 %ai_spets_aim_aware_crouch_7_b,
//																					 %ai_spets_aim_aware_crouch_9_a,
//																					 %ai_spets_aim_aware_crouch_9_b );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Aim Awareness
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Melee Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["stand"]["rifle"]["melee_0"]					= %ai_spets_melee;
	array[animType]["combat"]["stand"]["rifle"]["stand_2_melee_0"]			= %ai_spets_stand_2_melee;
	array[animType]["combat"]["stand"]["rifle"]["run_2_melee_0"]			= %ai_spets_run_2_melee_charge;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Melee Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	return array;
}

setup_spetsnaz_rusher_anim_array()
{
	if( !IsDefined( self.anim_array ) )
	{
		self.anim_array = [];
	}

	// replace regular run and gun animations with faster versions
	assert( IsDefined( self.rusherType ), "Call this function after setting the rusherType on the AI" );

	if( self.rusherType == "default" || self.rusherType == "semi" )
	{	
		self.anim_array[self.animType]["move"]["stand"]["rifle"]["run_n_gun_f"]			= %ai_spets_rusher_run_f_01;
		self animscripts\anims_table_rusher::setup_default_rusher_anim_array();
	}
	else if( self.rusherType == "pistol" )
	{
		self animscripts\anims_table_rusher::setup_default_rusher_anim_array();
	}
}
