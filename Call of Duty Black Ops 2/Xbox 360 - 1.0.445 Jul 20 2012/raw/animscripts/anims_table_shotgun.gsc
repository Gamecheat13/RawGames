// Here be where all animations shall one day live.
#include common_scripts\Utility;
#include maps\_utility;
#include animscripts\anims_table;

#using_animtree ("generic_human");

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

setup_shotgun_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Shotgun Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["stand"]["spread"]["single"]					= array( %shotgun_stand_fire_1A, %shotgun_stand_fire_1B );

	array[animType]["combat"]["stand"]["spread"]["reload"]					= array( %shotgun_stand_reload_C );
	array[animType]["combat"]["stand"]["spread"]["reload_crouchhide"]		= array( %shotgun_stand_reload_A,%shotgun_stand_reload_B );

	array[animType]["combat"]["stand"]["spread"]["straight_level"]			= %shotgun_aim_5;
	
	array[animType]["combat"]["stand"]["spread"]["exposed_idle"]			= array( %shotgun_stand_exposed_idle );

	array[animType]["combat"]["stand"]["spread"]["add_aim_up"]				= %shotgun_aim_8;
	array[animType]["combat"]["stand"]["spread"]["add_aim_down"]			= %shotgun_aim_2;
	array[animType]["combat"]["stand"]["spread"]["add_aim_left"]			= %shotgun_aim_4;
	array[animType]["combat"]["stand"]["spread"]["add_aim_right"]			= %shotgun_aim_6;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Shotgun Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Crouch Shotgun Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["crouch"]["spread"]["single"]					= array( %shotgun_crouch_fire );
	array[animType]["combat"]["crouch"]["spread"]["reload"]					= array( %shotgun_crouch_reload );

	array[animType]["combat"]["crouch"]["spread"]["exposed_idle"]			= array( %shotgun_crouch_exposed_idle );
	
	array[animType]["combat"]["crouch"]["spread"]["straight_level"]			= %shotgun_crouch_aim_5;
	array[animType]["combat"]["crouch"]["spread"]["add_aim_up"]				= %shotgun_crouch_aim_8;
	array[animType]["combat"]["crouch"]["spread"]["add_aim_down"]			= %shotgun_crouch_aim_2;
	array[animType]["combat"]["crouch"]["spread"]["add_aim_left"]			= %shotgun_crouch_aim_4;
	array[animType]["combat"]["crouch"]["spread"]["add_aim_right"]			= %shotgun_crouch_aim_6;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Crouch Shotgun Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Move Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	array[animType]["move"]["stand"]["spread"]["single"]					= array( %shotgun_stand_fire_1A, %shotgun_stand_fire_1B );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Move Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	return array;
}