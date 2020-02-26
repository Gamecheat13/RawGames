// Here be where all animations shall one day live.
#include common_scripts\Utility;

#using_animtree ("generic_human");

setup_smg_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand SMG Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["stand"]["smg"]["exposed_idle"]			= array( %SMG_stand_exposed_idle_alert, %SMG_stand_exposed_idle_alert_v2, %SMG_stand_exposed_idle_alert_v3 );

	array[animType]["combat"]["stand"]["smg"]["straight_level"]			= %SMG_stand_exposed_aim_5;
	array[animType]["combat"]["stand"]["smg"]["add_aim_up"]				= %SMG_stand_exposed_aim_8;
	array[animType]["combat"]["stand"]["smg"]["add_aim_down"]			= %SMG_stand_exposed_aim_2;
	array[animType]["combat"]["stand"]["smg"]["add_aim_left"]			= %SMG_stand_exposed_aim_4;
	array[animType]["combat"]["stand"]["smg"]["add_aim_right"]			= %SMG_stand_exposed_aim_6;  
	
	array[animType]["combat"]["stand"]["smg"]["melee_0"]				= %ai_melee_03;
	array[animType]["combat"]["stand"]["smg"]["stand_2_melee_0"]		= %ai_stand_2_melee_03;
	array[animType]["combat"]["stand"]["smg"]["run_2_melee_0"]			= %ai_run_2_melee_03_charge;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand SMG Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	return array;
}