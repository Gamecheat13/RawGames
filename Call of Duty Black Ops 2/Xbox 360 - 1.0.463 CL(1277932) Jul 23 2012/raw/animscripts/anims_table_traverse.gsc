// Here be where all animations shall one day live.
#include common_scripts\Utility;

#using_animtree ("generic_human");

setup_traversal_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );
	
	// setup staircase animations
	array = setup_stairs_anim_array( animType, array );
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["rifle"]["dive_over_40"]				= %ai_dive_over_40;

	array[animType]["move"]["stand"]["rifle"]["jump_across_72"]				= %ai_jump_across_72;
	array[animType]["move"]["stand"]["rifle"]["jump_across_120"]			= %ai_jump_across_120;

	array[animType]["move"]["stand"]["rifle"]["jump_down_36"]				= %ai_jump_down_36;
	array[animType]["move"]["stand"]["rifle"]["jump_down_40"]				= %ai_jump_down_40;
	array[animType]["move"]["stand"]["rifle"]["jump_down_56"]				= %ai_jump_down_56;
	array[animType]["move"]["stand"]["rifle"]["jump_down_96"]				= %ai_jump_down_96;
	array[animType]["move"]["stand"]["rifle"]["jump_down_128"]				= %ai_jump_down_128;

	array[animType]["move"]["stand"]["rifle"]["jump_over_high_wall"]		= %jump_over_high_wall;

	array[animType]["move"]["stand"]["rifle"]["ladder_climbon"]				= %ladder_climbon;
	array[animType]["move"]["stand"]["rifle"]["ladder_climbdown"]			= %ladder_climbdown;

	array[animType]["move"]["stand"]["rifle"]["ladder_start"]				= %ladder_climbon_bottom_walk;
	array[animType]["move"]["stand"]["rifle"]["ladder_climb"]				= %ladder_climbup;
	array[animType]["move"]["stand"]["rifle"]["ladder_end"]					= %ladder_climboff;

	array[animType]["move"]["stand"]["rifle"]["traverse_40_death_start"]	= array( %traverse40_death_start, %traverse40_death_start_2);
	array[animType]["move"]["stand"]["rifle"]["traverse_40_death_end"]		= array( %traverse40_death_end, %traverse40_death_end_2);

	array[animType]["move"]["stand"]["rifle"]["traverse_90_death_start"]	= array( %traverse90_start_death );
	array[animType]["move"]["stand"]["rifle"]["traverse_90_death_end"]		= array( %traverse90_end_death );

	array[animType]["move"]["stand"]["rifle"]["mantle_on_36"]				= %ai_mantle_on_36;
	array[animType]["move"]["stand"]["rifle"]["mantle_on_40"]				= %ai_mantle_on_40;
	array[animType]["move"]["stand"]["rifle"]["mantle_on_48"]				= %ai_mantle_on_48;
	array[animType]["move"]["stand"]["rifle"]["mantle_on_52"]				= %ai_mantle_on_52;
	array[animType]["move"]["stand"]["rifle"]["mantle_on_56"]				= %ai_mantle_on_56;

	array[animType]["move"]["stand"]["rifle"]["mantle_over_36"]				= %ai_mantle_over_36;
	array[animType]["move"]["stand"]["rifle"]["mantle_over_40"]				= %ai_mantle_over_40;
	array[animType]["move"]["stand"]["rifle"]["mantle_over_40_to_cover"]	= %traverse40_2_cover;

	array[animType]["move"]["stand"]["rifle"]["mantle_over_40_down_80"]		= array( %ai_mantle_over_40_down_80, %ai_mantle_over_40_down_80_v2 );

	array[animType]["move"]["stand"]["rifle"]["mantle_over_96"]				= %ai_mantle_over_96;

	array[animType]["move"]["stand"]["rifle"]["mantle_window_36_run"]		= %ai_mantle_window_36_run;
	array[animType]["move"]["stand"]["rifle"]["mantle_window_36_stop"]		= %ai_mantle_window_36_stop;

	array[animType]["move"]["stand"]["rifle"]["mantle_window_dive_36"]		= %ai_mantle_window_dive_36;

	array[animType]["move"]["stand"]["rifle"]["slide_across_car"]			= %ai_slide_across_car;
	array[animType]["move"]["stand"]["rifle"]["slide_across_car_to_cover"]	= %slide_across_car_2_cover;
	array[animType]["move"]["stand"]["rifle"]["slide_across_car_death"]		= %slide_across_car_death;
	
	array[animType]["move"]["stand"]["rifle"]["step_up"]						= %step_up_low_wall;
	
	// AI_TODO - Clean up hill slope traversal related script and other files.
//	array[animType]["move"]["stand"]["rifle"]["hill_down_20"] = %ai_run_slope_down_20;
//	array[animType]["move"]["stand"]["rifle"]["hill_down_in_20"] = %ai_run_slope_down_20_in;
//	array[animType]["move"]["stand"]["rifle"]["hill_down_out_20"] = %ai_run_slope_down_20_out;
//	array[animType]["move"]["stand"]["rifle"]["hill_down_25"] = %ai_run_slope_down_25;
//	array[animType]["move"]["stand"]["rifle"]["hill_down_in_25"] = %ai_run_slope_down_25_in;
//	array[animType]["move"]["stand"]["rifle"]["hill_down_out_25"] = %ai_run_slope_down_25_out;
//	array[animType]["move"]["stand"]["rifle"]["hill_down_30"] = %ai_run_slope_down_30;
//	array[animType]["move"]["stand"]["rifle"]["hill_down_in_30"] = %ai_run_slope_down_30_in;
//	array[animType]["move"]["stand"]["rifle"]["hill_down_out_30"] = %ai_run_slope_down_30_out;
//	array[animType]["move"]["stand"]["rifle"]["hill_down_35"] = %ai_run_slope_down_35;
//	array[animType]["move"]["stand"]["rifle"]["hill_down_in_35"] = %ai_run_slope_down_35_in;
//	array[animType]["move"]["stand"]["rifle"]["hill_down_out_35"] = %ai_run_slope_down_35_out;
//	array[animType]["move"]["stand"]["rifle"]["hill_up_20"] = %ai_run_slope_up_20;
//	array[animType]["move"]["stand"]["rifle"]["hill_up_in_20"] = %ai_run_slope_up_20_in;
//	array[animType]["move"]["stand"]["rifle"]["hill_up_out_20"] = %ai_run_slope_up_20_out;
//	array[animType]["move"]["stand"]["rifle"]["hill_up_25"] = %ai_run_slope_up_25;
//	array[animType]["move"]["stand"]["rifle"]["hill_up_in_25"] = %ai_run_slope_up_25_in;
//	array[animType]["move"]["stand"]["rifle"]["hill_up_out_25"] = %ai_run_slope_up_25_out;
//	array[animType]["move"]["stand"]["rifle"]["hill_up_30"] = %ai_run_slope_up_30;
//	array[animType]["move"]["stand"]["rifle"]["hill_up_in_30"] = %ai_run_slope_up_30_in;
//	array[animType]["move"]["stand"]["rifle"]["hill_up_out_30"] = %ai_run_slope_up_30_out;
//	array[animType]["move"]["stand"]["rifle"]["hill_up_35"] = %ai_run_slope_up_35;
//	array[animType]["move"]["stand"]["rifle"]["hill_up_in_35"] = %ai_run_slope_up_35_in;
//	array[animType]["move"]["stand"]["rifle"]["hill_up_out_35"] = %ai_run_slope_up_35_out;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	
	return array;
}

setup_stairs_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );	
	
	// 8x8 ----------------------------------------------------------
	
	/* UP */
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x8_in"]			= %ai_staircase_run_up_8x8_in;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x8_in_even"]		= %ai_staircase_run_up_8x8_in_even;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x8_out"]			= %ai_staircase_run_up_8x8_out;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x8_2"]				= %ai_staircase_run_up_8x8_1;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x8_4"]				= %ai_staircase_run_up_8x8_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x8_6"]				= %ai_staircase_run_up_8x8_3;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x8_7"]				= %ai_staircase_run_up_8x8_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x8_10"]			= %ai_staircase_run_up_8x8_5;

	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x8_aim_up"]		= %ai_staircase_run_up_8x8_aim_8;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x8_aim_down"]		= %ai_staircase_run_up_8x8_aim_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x8_aim_left"]		= %ai_staircase_run_up_8x8_aim_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x8_aim_right"]		= %ai_staircase_run_up_8x8_aim_6;
	
	
	/* DOWN */
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x8_in"]			= %ai_staircase_run_down_8x8_in;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x8_out"]			= %ai_staircase_run_down_8x8_out;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x8_out_even"]	= %ai_staircase_run_down_8x8_out_even;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x8_2"]			= %ai_staircase_run_down_8x8_1;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x8_4"]			= %ai_staircase_run_down_8x8_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x8_6"]			= %ai_staircase_run_down_8x8_3;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x8_8"]			= %ai_staircase_run_down_8x8_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x8_10"]			= %ai_staircase_run_down_8x8_5;
	
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x8_aim_up"]		= %ai_staircase_run_down_8x8_aim_8;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x8_aim_down"]	= %ai_staircase_run_down_8x8_aim_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x8_aim_left"]	= %ai_staircase_run_down_8x8_aim_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x8_aim_right"]	= %ai_staircase_run_down_8x8_aim_6;
	

	/* STAIRS 8x12 ----------------------------------------------------------
	/* UP */
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_in"]			= %ai_staircase_run_up_8x12_in;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_in_even"]		= %ai_staircase_run_up_8x12_in_even;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_out"]			= %ai_staircase_run_up_8x12_out;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_2"]			= %ai_staircase_run_up_8x12_1;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_4"]			= %ai_staircase_run_up_8x12_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_6"]			= %ai_staircase_run_up_8x12_3;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_8"]			= %ai_staircase_run_up_8x12_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_10"]			= %ai_staircase_run_up_8x12_5;
	
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_aim_up"]		= %ai_staircase_run_up_8x12_aim_8;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_aim_down"]		= %ai_staircase_run_up_8x12_aim_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_aim_left"]		= %ai_staircase_run_up_8x12_aim_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_aim_right"]	= %ai_staircase_run_up_8x12_aim_6;


//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_in"]			= %ai_staircase_sprint_up_8x12_in;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_in_even"]	= %ai_staircase_sprint_up_8x12_in_even;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_out"]		= %ai_staircase_sprint_up_8x12_out;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_2"]			= %ai_staircase_sprint_up_8x12_1;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_4"]			= %ai_staircase_sprint_up_8x12_2;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_6"]			= %ai_staircase_sprint_up_8x12_3;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_7"]			= %ai_staircase_sprint_up_8x12_4;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_10"]			= %ai_staircase_sprint_up_8x12_5;

	/* DOWN */
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_in"]			= %ai_staircase_run_down_8x12_in;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_out"]		= %ai_staircase_run_down_8x12_out;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_out_even"]	= %ai_staircase_run_down_8x12_out_even;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_2"]			= %ai_staircase_run_down_8x12_1;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_4"]			= %ai_staircase_run_down_8x12_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_6"]			= %ai_staircase_run_down_8x12_3;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_8"]			= %ai_staircase_run_down_8x12_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_10"]			= %ai_staircase_run_down_8x12_5;
	
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_aim_up"]		= %ai_staircase_run_down_8x12_aim_8;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_aim_down"]	= %ai_staircase_run_down_8x12_aim_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_aim_left"]	= %ai_staircase_run_down_8x12_aim_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_aim_right"]	= %ai_staircase_run_down_8x12_aim_6;
	

//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_in"]		= %ai_staircase_sprint_down_8x12_in;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_out"]		= %ai_staircase_sprint_down_8x12_out;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_out_even"]	= %ai_staircase_sprint_down_8x12_out_even;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_2"]		= %ai_staircase_sprint_down_8x12_1;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_4"]		= %ai_staircase_sprint_down_8x12_2;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_6"]		= %ai_staircase_sprint_down_8x12_3;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_8"]		= %ai_staircase_sprint_down_8x12_4;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_10"]		= %ai_staircase_sprint_down_8x12_5;

	/* STAIRS 8x16 ----------------------------------------------------------
	/* UP */
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_in"]			= %ai_staircase_run_up_8x16_in;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_in_even"]		= %ai_staircase_run_up_8x16_in_even;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_out"]			= %ai_staircase_run_up_8x16_out;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_2"]			= %ai_staircase_run_up_8x16_1;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_4"]			= %ai_staircase_run_up_8x16_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_6"]			= %ai_staircase_run_up_8x16_3;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_8"]			= %ai_staircase_run_up_8x16_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_10"]			= %ai_staircase_run_up_8x16_5;
	
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_aim_up"]		= %ai_staircase_run_up_8x16_aim_8;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_aim_down"]		= %ai_staircase_run_up_8x16_aim_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_aim_left"]		= %ai_staircase_run_up_8x16_aim_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_aim_right"]	= %ai_staircase_run_up_8x16_aim_6;


//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_in"]			= %ai_staircase_sprint_up_8x16_in;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_in_even"]	= %ai_staircase_sprint_up_8x16_in_even;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_out"]		= %ai_staircase_sprint_up_8x16_out;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_2"]			= %ai_staircase_sprint_up_8x16_1;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_4"]			= %ai_staircase_sprint_up_8x16_2;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_6"]			= %ai_staircase_sprint_up_8x16_3;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_8"]			= %ai_staircase_sprint_up_8x16_4;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_10"]			= %ai_staircase_sprint_up_8x16_5;

	/* DOWN */
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_in"]			= %ai_staircase_run_down_8x16_in;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_out"]		= %ai_staircase_run_down_8x16_out;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_out_even"]	= %ai_staircase_run_down_8x16_out_even;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_2"]			= %ai_staircase_run_down_8x16_1;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_4"]			= %ai_staircase_run_down_8x16_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_6"]			= %ai_staircase_run_down_8x16_3;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_8"]			= %ai_staircase_run_down_8x16_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_10"]			= %ai_staircase_run_down_8x16_5;
	
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_aim_up"]		= %ai_staircase_run_down_8x16_aim_8;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_aim_down"]	= %ai_staircase_run_down_8x16_aim_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_aim_left"]	= %ai_staircase_run_down_8x16_aim_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_aim_right"]	= %ai_staircase_run_down_8x16_aim_6;
	

//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_in"]		= %ai_staircase_sprint_down_8x16_in;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_out"]		= %ai_staircase_sprint_down_8x16_out;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_out_even"]	= %ai_staircase_sprint_down_8x16_out_even;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_2"]		= %ai_staircase_sprint_down_8x16_1;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_4"]		= %ai_staircase_sprint_down_8x16_2;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_6"]		= %ai_staircase_sprint_down_8x16_3;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_8"]		= %ai_staircase_sprint_down_8x16_4;
//	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_10"]		= %ai_staircase_sprint_down_8x16_5;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Unarmed Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/* STAIRS 8x12 ----------------------------------------------------------
	---------------------------------------------------------------------- */
	/* UP */
//	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_in"]			= %ai_staircase_sprint_unarmed_up_8x12_in;
//	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_in_even"]		= %ai_staircase_sprint_unarmed_up_8x12_in_even;
//	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_out"]			= %ai_staircase_sprint_unarmed_up_8x12_out;
//	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_2"]				= %ai_staircase_sprint_unarmed_up_8x12_1;
//	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_4"]				= %ai_staircase_sprint_unarmed_up_8x12_2;
//	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_6"]				= %ai_staircase_sprint_unarmed_up_8x12_3;
//	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_8"]				= %ai_staircase_sprint_unarmed_up_8x12_4;
//	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_10"]			= %ai_staircase_sprint_unarmed_up_8x12_5;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Unarmed Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Pistol Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/* STAIRS 8x12 ----------------------------------------------------------
	---------------------------------------------------------------------- */
	/* UP */

	/*
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_in"]			= %ai_staircase_sprint_unarmed_up_8x12_in;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_in_even"]		= %ai_staircase_sprint_unarmed_up_8x12_in_even;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_out"]			= %ai_staircase_sprint_unarmed_up_8x12_out;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_2"]			= %ai_staircase_sprint_unarmed_up_8x12_1;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_4"]			= %ai_staircase_sprint_unarmed_up_8x12_2;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_6"]			= %ai_staircase_sprint_unarmed_up_8x12_3;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_8"]			= %ai_staircase_sprint_unarmed_up_8x12_4;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_10"]			= %ai_staircase_sprint_unarmed_up_8x12_5;
	*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Pistol Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if( IS_TRUE(level.supportsPistolAnimations) )
		array = setup_pistol_stairs_anim_array( animType, array );
	
	array = setup_civilian_stairs_anim_array( animType, array );
		
	return array;
}


setup_pistol_stairs_anim_array( animType, array )
{
	
	assert( IsDefined(array) && IsArray(array) );	
	
	// 8x8 ----------------------------------------------------------
	
	/* UP */
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x8_in"]			= %ai_pistol_staircase_run_up_8x8_in;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x8_in_even"]		= %ai_pistol_staircase_run_up_8x8_in_even;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x8_out"]			= %ai_pistol_staircase_run_up_8x8_out;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x8_2"]			= %ai_pistol_staircase_run_up_8x8_1;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x8_4"]			= %ai_pistol_staircase_run_up_8x8_2;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x8_6"]			= %ai_pistol_staircase_run_up_8x8_3;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x8_7"]			= %ai_pistol_staircase_run_up_8x8_4;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x8_10"]			= %ai_pistol_staircase_run_up_8x8_5;
	
	
	/* DOWN */
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x8_in"]			= %ai_pistol_staircase_run_down_8x8_in;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x8_out"]		= %ai_pistol_staircase_run_down_8x8_out;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x8_out_even"]	= %ai_pistol_staircase_run_down_8x8_out_even;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x8_2"]			= %ai_pistol_staircase_run_down_8x8_1;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x8_4"]			= %ai_pistol_staircase_run_down_8x8_2;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x8_6"]			= %ai_pistol_staircase_run_down_8x8_3;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x8_8"]			= %ai_pistol_staircase_run_down_8x8_4;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x8_10"]			= %ai_pistol_staircase_run_down_8x8_5;
	
	/* STAIRS 8x12 ----------------------------------------------------------
	/* UP */
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_in"]			= %ai_pistol_staircase_run_up_8x12_in;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_in_even"]		= %ai_pistol_staircase_run_up_8x12_in_even;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_out"]			= %ai_pistol_staircase_run_up_8x12_out;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_2"]			= %ai_pistol_staircase_run_up_8x12_1;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_4"]			= %ai_pistol_staircase_run_up_8x12_2;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_6"]			= %ai_pistol_staircase_run_up_8x12_3;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_8"]			= %ai_pistol_staircase_run_up_8x12_4;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x12_10"]			= %ai_pistol_staircase_run_up_8x12_5;

	/* DOWN */
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x12_in"]			= %ai_pistol_staircase_run_down_8x12_in;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x12_out"]		= %ai_pistol_staircase_run_down_8x12_out;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x12_out_even"]	= %ai_pistol_staircase_run_down_8x12_out_even;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x12_2"]			= %ai_pistol_staircase_run_down_8x12_1;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x12_4"]			= %ai_pistol_staircase_run_down_8x12_2;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x12_6"]			= %ai_pistol_staircase_run_down_8x12_3;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x12_8"]			= %ai_pistol_staircase_run_down_8x12_4;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x12_10"]			= %ai_pistol_staircase_run_down_8x12_5;
	
	/* STAIRS 8x16 ----------------------------------------------------------
	/* UP */
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x16_in"]			= %ai_pistol_staircase_run_up_8x16_in;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x16_in_even"]		= %ai_pistol_staircase_run_up_8x16_in_even;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x16_out"]			= %ai_pistol_staircase_run_up_8x16_out;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x16_2"]			= %ai_pistol_staircase_run_up_8x16_1;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x16_4"]			= %ai_pistol_staircase_run_up_8x16_2;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x16_6"]			= %ai_pistol_staircase_run_up_8x16_3;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x16_8"]			= %ai_pistol_staircase_run_up_8x16_4;
	array[animType]["move"]["stand"]["pistol"]["staircase_up_8x16_10"]			= %ai_pistol_staircase_run_up_8x16_5;

	/* DOWN */
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x16_in"]			= %ai_pistol_staircase_run_down_8x16_in;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x16_out"]		= %ai_pistol_staircase_run_down_8x16_out;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x16_out_even"]	= %ai_pistol_staircase_run_down_8x16_out_even;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x16_2"]			= %ai_pistol_staircase_run_down_8x16_1;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x16_4"]			= %ai_pistol_staircase_run_down_8x16_2;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x16_6"]			= %ai_pistol_staircase_run_down_8x16_3;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x16_8"]			= %ai_pistol_staircase_run_down_8x16_4;
	array[animType]["move"]["stand"]["pistol"]["staircase_down_8x16_10"]			= %ai_pistol_staircase_run_down_8x16_5;

	return array;
}



setup_civilian_stairs_anim_array( animType, array )
{
	
	assert( IsDefined(array) && IsArray(array) );	
	
	// 8x8 ----------------------------------------------------------
	
	/* UP */
	array[animType]["move"]["stand"]["none"]["staircase_up_8x8_in"]			= %ai_pistol_staircase_run_up_8x8_in;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x8_in_even"]		= %ai_pistol_staircase_run_up_8x8_in_even;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x8_out"]			= %ai_pistol_staircase_run_up_8x8_out;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x8_2"]			= %ai_pistol_staircase_run_up_8x8_1;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x8_4"]			= %ai_pistol_staircase_run_up_8x8_2;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x8_6"]			= %ai_pistol_staircase_run_up_8x8_3;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x8_7"]			= %ai_pistol_staircase_run_up_8x8_4;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x8_10"]			= %ai_pistol_staircase_run_up_8x8_5;
	
	
	/* DOWN */
	array[animType]["move"]["stand"]["none"]["staircase_down_8x8_in"]			= %ai_pistol_staircase_run_down_8x8_in;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x8_out"]		= %ai_pistol_staircase_run_down_8x8_out;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x8_out_even"]	= %ai_pistol_staircase_run_down_8x8_out_even;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x8_2"]			= %ai_pistol_staircase_run_down_8x8_1;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x8_4"]			= %ai_pistol_staircase_run_down_8x8_2;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x8_6"]			= %ai_pistol_staircase_run_down_8x8_3;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x8_8"]			= %ai_pistol_staircase_run_down_8x8_4;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x8_10"]			= %ai_pistol_staircase_run_down_8x8_5;
	
	/* STAIRS 8x12 ----------------------------------------------------------
	/* UP */
	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_in"]			= %ai_pistol_staircase_run_up_8x12_in;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_in_even"]		= %ai_pistol_staircase_run_up_8x12_in_even;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_out"]			= %ai_pistol_staircase_run_up_8x12_out;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_2"]			= %ai_pistol_staircase_run_up_8x12_1;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_4"]			= %ai_pistol_staircase_run_up_8x12_2;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_6"]			= %ai_pistol_staircase_run_up_8x12_3;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_8"]			= %ai_pistol_staircase_run_up_8x12_4;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x12_10"]			= %ai_pistol_staircase_run_up_8x12_5;

	/* DOWN */
	array[animType]["move"]["stand"]["none"]["staircase_down_8x12_in"]			= %ai_pistol_staircase_run_down_8x12_in;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x12_out"]		= %ai_pistol_staircase_run_down_8x12_out;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x12_out_even"]	= %ai_pistol_staircase_run_down_8x12_out_even;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x12_2"]			= %ai_pistol_staircase_run_down_8x12_1;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x12_4"]			= %ai_pistol_staircase_run_down_8x12_2;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x12_6"]			= %ai_pistol_staircase_run_down_8x12_3;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x12_8"]			= %ai_pistol_staircase_run_down_8x12_4;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x12_10"]			= %ai_pistol_staircase_run_down_8x12_5;
	
	/* STAIRS 8x16 ----------------------------------------------------------
	/* UP */
	array[animType]["move"]["stand"]["none"]["staircase_up_8x16_in"]			= %ai_pistol_staircase_run_up_8x16_in;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x16_in_even"]		= %ai_pistol_staircase_run_up_8x16_in_even;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x16_out"]			= %ai_pistol_staircase_run_up_8x16_out;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x16_2"]			= %ai_pistol_staircase_run_up_8x16_1;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x16_4"]			= %ai_pistol_staircase_run_up_8x16_2;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x16_6"]			= %ai_pistol_staircase_run_up_8x16_3;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x16_8"]			= %ai_pistol_staircase_run_up_8x16_4;
	array[animType]["move"]["stand"]["none"]["staircase_up_8x16_10"]			= %ai_pistol_staircase_run_up_8x16_5;

	/* DOWN */
	array[animType]["move"]["stand"]["none"]["staircase_down_8x16_in"]			= %ai_pistol_staircase_run_down_8x16_in;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x16_out"]		= %ai_pistol_staircase_run_down_8x16_out;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x16_out_even"]	= %ai_pistol_staircase_run_down_8x16_out_even;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x16_2"]			= %ai_pistol_staircase_run_down_8x16_1;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x16_4"]			= %ai_pistol_staircase_run_down_8x16_2;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x16_6"]			= %ai_pistol_staircase_run_down_8x16_3;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x16_8"]			= %ai_pistol_staircase_run_down_8x16_4;
	array[animType]["move"]["stand"]["none"]["staircase_down_8x16_10"]			= %ai_pistol_staircase_run_down_8x16_5;

	return array;
}
