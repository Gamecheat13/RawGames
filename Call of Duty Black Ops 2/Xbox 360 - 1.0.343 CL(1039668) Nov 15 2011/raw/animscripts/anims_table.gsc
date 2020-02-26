// Here be where all animations shall one day live.
#include common_scripts\Utility;
#include animscripts\anims_table_wounded;
#include animscripts\anims_table_rusher;
#using_animtree ("generic_human");

#insert raw\common_scripts\utility.gsh;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BEGIN PUBLIC FUCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

setup_anims()
{
	if( !IsDefined( anim.anim_array ) )
	{
		anim.anim_array					= [];
		anim.pre_move_delta_array		= [];
		anim.move_delta_array			= [];
		anim.post_move_delta_array		= [];
		anim.angle_delta_array			= [];
		anim.notetrack_array			= [];
		anim.longestExposedApproachDist	= [];
		anim.longestApproachDist		= [];
		
		// ALEXP_TODO: perhaps, use FindBestSplitTime to auto-generate these values? (look at init.gsc)
		anim.coverTransSplit["arrive_left"][7]				= 0.369369; // delta of (35.5356, 3.27114, 0)
		anim.coverTransSplit["arrive_left_crouch"][7]		= 0.277277; // delta of (38.5093, 6.37286, 0)
		anim.coverTransSplit["exit_left"][7]				= 0.646647; // delta of (36.3768, 4.37581, 0)
		anim.coverTransSplit["exit_left_crouch"][7]			= 0.764765; // delta of (36.7695, 4.82297, 0)
		anim.coverTransSplit["arrive_left"][8]				= 0.463463; // delta of (32.9564, 0.950555, 0)
		anim.coverTransSplit["arrive_left_crouch"][8]		= 0.339339; // delta of (35.0497, 3.12251, 0)
		anim.coverTransSplit["exit_left"][8]				= 0.677678; // delta of (34.3012, 2.25822, 0)
		anim.coverTransSplit["exit_left_crouch"][8]			= 0.58959;  // delta of (36.3154, 4.34119, 0)
		anim.coverTransSplit["arrive_right"][8]				= 0.458458; // delta of (35.6571, 3.63511, 0)
		anim.coverTransSplit["arrive_right_crouch"][8]		= 0.329329; // delta of (36.398, 4.45949, 0)
		anim.coverTransSplit["exit_right"][8]				= 0.457457; // delta of (36.3085, 4.34586, 0)
		anim.coverTransSplit["exit_right_crouch"][8]		= 0.636637; // delta of (40.441, 8.59943, -0.0001)
		anim.coverTransSplit["arrive_right"][9]				= 0.546547; // delta of (37.7732, 5.76641, 0)
		anim.coverTransSplit["arrive_right_crouch"][9]		= 0.349349; // delta of (36.0788, 3.95538, 0)
		anim.coverTransSplit["exit_right"][9]				= 0.521522; // delta of (35.3195, 3.24431, 0)
		anim.coverTransSplit["exit_right_crouch"][9]		= 0.664665; // delta of (33.4424, 1.40398, -0.0001)

		// CQB splits
		anim.coverTransSplit["arrive_left_cqb"][7]			= 0.451451; // delta of (33.1115, 1.05645, 0)
		anim.coverTransSplit["arrive_left_crouch_cqb"][7]	= 0.246246; // delta of (34.2986, 2.32586, 0)
		anim.coverTransSplit["exit_left_cqb"][7]			= 0.702703; // delta of (32.9692, 0.881301, 0)
		anim.coverTransSplit["exit_left_crouch_cqb"][7]		= 0.718719; // delta of (33.6642, 1.70904, 0)
		anim.coverTransSplit["arrive_left_cqb"][8]			= 0.431431; // delta of (34.0755, 2.01125, 0)
		anim.coverTransSplit["arrive_left_crouch_cqb"][8]	= 0.33033;  // delta of (35.8107, 3.70985, 0)
		anim.coverTransSplit["exit_left_cqb"][8]			= 0.451451; // delta of (33.0388, 0.964628, 0)
		anim.coverTransSplit["exit_left_crouch_cqb"][8]		= 0.603604; // delta of (33.0797, 1.14774, 0)
		anim.coverTransSplit["arrive_right_cqb"][8]			= 0.458458; // delta of (35.6571, 3.63511, 0)
		anim.coverTransSplit["arrive_right_crouch_cqb"][8]  = 0.311311; // delta of (34.2736, 2.32471, 0)
		anim.coverTransSplit["exit_right_cqb"][8]			= 0.540541; // delta of (33.0089, 1.0005, 0)
		anim.coverTransSplit["exit_right_crouch_cqb"][8]	= 0.399399; // delta of (34.7739, 2.41176, 0)
		anim.coverTransSplit["arrive_right_cqb"][9]			= 0.546547; // delta of( 37.7732, 5.76641, 0 )
		anim.coverTransSplit["arrive_right_crouch_cqb"][9]	= 0.232232; // delta of (35.8102, 3.81592, 0)
		anim.coverTransSplit["exit_right_cqb"][9]			= 0.565566; // delta of (35.4487, 3.42926, 0)
		anim.coverTransSplit["exit_right_crouch_cqb"][9]	= 0.518519; // delta of (35.4592, 1.47273, 0)

		// Pillar splits (probably incorrect, just copied from left and right, but it'll be ok with cover_split notetrack)
		anim.coverTransSplit["arrive_pillar"][7]			= 0.369369; // delta of (35.5356, 3.27114, 0)
		anim.coverTransSplit["arrive_pillar_crouch"][7]		= 0.277277; // delta of (38.5093, 6.37286, 0)
		anim.coverTransSplit["exit_pillar"][7]				= 0.646647; // delta of (36.3768, 4.37581, 0)
		anim.coverTransSplit["exit_pillar_crouch"][7]		= 0.764765; // delta of (36.7695, 4.82297, 0)
		anim.coverTransSplit["arrive_pillar"][8]			= 0.463463; // delta of (32.9564, 0.950555, 0)
		anim.coverTransSplit["arrive_pillar_crouch"][8]		= 0.339339; // delta of (35.0497, 3.12251, 0)
		anim.coverTransSplit["exit_pillar"][8]				= 0.677678; // delta of (34.3012, 2.25822, 0)
		anim.coverTransSplit["exit_pillar_crouch"][8]		= 0.58959;  // delta of (36.3154, 4.34119, 0)
		anim.coverTransSplit["arrive_pillar"][8]			= 0.458458; // delta of (35.6571, 3.63511, 0)
		anim.coverTransSplit["arrive_pillar_crouch"][8]		= 0.329329; // delta of (36.398, 4.45949, 0)
		anim.coverTransSplit["exit_pillar"][8]				= 0.457457; // delta of (36.3085, 4.34586, 0)
		anim.coverTransSplit["exit_pillar_crouch"][8]		= 0.636637; // delta of (40.441, 8.59943, -0.0001)
		anim.coverTransSplit["arrive_pillar"][9]			= 0.546547; // delta of (37.7732, 5.76641, 0)
		anim.coverTransSplit["arrive_pillar_crouch"][9]		= 0.349349; // delta of (36.0788, 3.95538, 0)
		anim.coverTransSplit["exit_pillar"][9]				= 0.521522; // delta of (35.3195, 3.24431, 0)
		anim.coverTransSplit["exit_pillar_crouch"][9]		= 0.664665; // delta of (33.4424, 1.40398, -0.0001)
		
		setup_anim_array( "default" );
	}
}

// precache the move/angle deltas
setup_delta_arrays( source_array, dest )
{
	assert( IsDefined(source_array) );
	assert( source_array.size > 0 );

	assert( IsDefined(dest.pre_move_delta_array)		&& IsArray(dest.pre_move_delta_array) );
	assert( IsDefined(dest.move_delta_array)			&& IsArray(dest.move_delta_array) );
	assert( IsDefined(dest.post_move_delta_array)		&& IsArray(dest.post_move_delta_array) );
	assert( IsDefined(dest.angle_delta_array)			&& IsArray(dest.angle_delta_array) );
	assert( IsDefined(dest.notetrack_array)				&& IsArray(dest.notetrack_array) );
	assert( IsDefined(dest.longestExposedApproachDist)	&& IsArray(dest.longestExposedApproachDist) );
	assert( IsDefined(dest.longestApproachDist)			&& IsArray(dest.longestApproachDist) );

	animTypeKeys = GetArrayKeys(source_array);
	for( animTypeIndex = 0; animTypeIndex < animTypeKeys.size; animTypeIndex++ )
	{
		animType = animTypeKeys[ animTypeIndex ];

		animType_array = source_array[ animType ];

		// only do the cover arrivals/exits for now
		if( IsArray(animType_array) && IsDefined(animType_array["move"]) )
		{
			script_array = animType_array["move"];

			poseKeys = GetArrayKeys(script_array);
			for( poseIndex = 0; poseIndex < poseKeys.size; poseIndex++ )
			{
				animPose = poseKeys[ poseIndex ];

				pose_array = script_array[animPose];

				weaponKeys = GetArrayKeys(pose_array);
				for( weaponIndex = 0; weaponIndex < weaponKeys.size; weaponIndex++ )
				{
					animWeapon = weaponKeys[ weaponIndex ];

					weapon_array = pose_array[animWeapon];

					animKeys = GetArrayKeys(weapon_array);
					for( animIndex = 0; animIndex < animKeys.size; animIndex++ )
					{
						animName = animKeys[ animIndex ];

						anim_array = weapon_array[animName];
						
						// only the arrivals/exits are arrays
						if( IsArray(anim_array) )
						{
							transKeys = GetArrayKeys( anim_array );
							for( transIndex = 0; transIndex < transKeys.size; transIndex++ )
							{
								trans = transKeys[transIndex];

								moveDelta	= getMoveDelta( anim_array[trans], 0, 1 );
								angleDelta	= getAngleDelta( anim_array[trans], 0, 1 );
								notetracks	= getNotetracksInDelta( anim_array[trans], 0, 9999 );

								// don't need to store everything
								if( isSubStr(animName, "exposed") || ( trans >= 1 && trans <= 9) )
								{
									dest.move_delta_array[animType]["move"][animPose][animWeapon][animName][trans]	= moveDelta;
									dest.angle_delta_array[animType]["move"][animPose][animWeapon][animName][trans]	= angleDelta;

									if( isSubStr(animName, "arrive") && trans >= 1 && trans <= 6 )
									{
										moveLength = length( moveDelta );

										// initialize
										if( !IsDefined( dest.longestApproachDist[animType] ) )
										{
											dest.longestApproachDist[animType] = [];
											dest.longestApproachDist[animType][animname] = 0;
										}

										if( !IsDefined( dest.longestApproachDist[animType][animname] ) )
										{
											Assert( IsDefined( dest.longestApproachDist[animType] ) );
											dest.longestApproachDist[animType][animname] = 0;			
										}

										// store the longest
										if( moveLength > dest.longestApproachDist[animType][animname] )
										{
											dest.longestApproachDist[animType][animname] = moveLength;
										}
									}
									
								}

								// TODO: see how expensive it is to generate this stuff at runtime
								//if( !isSubStr(animName, "mini") && notetracks.size > 0 )
								//{
								//	dest.notetrack_array[animType]["move"][animPose][animWeapon][animName][trans]	= notetracks;
								//}

								if( isSubStr(animName, "exposed") )
								{
									moveLength = length( moveDelta );

									// initialize
									if( !IsDefined(dest.longestExposedApproachDist[animType]) )
									{
										dest.longestExposedApproachDist[animType] = 0;
									}
									
									// store the longest
									if( moveLength > dest.longestExposedApproachDist[animType] )
									{
										dest.longestExposedApproachDist[animType] = moveLength;
									}
								}
								else if( isSubStr(animName, "left") || isSubStr(animName, "right") || isSubStr(animName, "pillar") )
								{
									// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
									if( trans >= 7 && trans <= 9 )
									{
										splitTime = dest.coverTransSplit[animName][trans];

										if( AnimHasNotetrack( anim_array[trans], "cover_split" ) )
										{
											times = GetNotetrackTimes( anim_array[trans], "cover_split" );

											assert(times.size > 0);
											splitTime = times[0];
										}

										preMoveDelta	= getMoveDelta( anim_array[trans], 0, splitTime );
										postMoveDelta	= moveDelta - preMoveDelta;

										if( isSubStr(animName, "arrive") )
										{
											dest.pre_move_delta_array[animType]["move"][animPose][animWeapon][animName][trans]	= preMoveDelta;
											dest.move_delta_array[animType]["move"][animPose][animWeapon][animName][trans]		= postMoveDelta;
										}
										else // exit
										{											
											dest.move_delta_array[animType]["move"][animPose][animWeapon][animName][trans]		= preMoveDelta;
											dest.post_move_delta_array[animType]["move"][animPose][animWeapon][animName][trans]	= postMoveDelta;
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

setup_default_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["stand"]["rifle"]["exposed_idle"]				= array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 ); 
	array[animType]["combat"]["stand"]["rifle"]["exposed_idle_noncombat"]	= array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 ); 
	
	array[animType]["combat"]["stand"]["rifle"]["idle_trans_out"]			= %ai_casual_stand_v2_idle_trans_out;

//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_forward"]		= array( %ai_idle_strafe_forward_a,
//																					 %ai_idle_strafe_forward_b,
//																					 %ai_idle_strafe_forward_c );
//
//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_right"]		= array( %ai_idle_strafe_right_a,
//																					 %ai_idle_strafe_right_b,
//																					 %ai_idle_strafe_right_c );
//
//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_left"]			= array( %ai_idle_strafe_left_a,
//																					 %ai_idle_strafe_left_b,
//																					 %ai_idle_strafe_left_c );
//
//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_stop_2_r"]		= %ai_idle_strafe_exposed_to_right;
//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_stop_2_l"]		= %ai_idle_strafe_exposed_to_left;
//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_stop_2_f"]		= %ai_idle_strafe_exposed_to_forward;
//
//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_l_2_stop"]		= %ai_idle_strafe_left_to_exposed;
//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_r_2_stop"]		= %ai_idle_strafe_right_to_exposed;
//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_f_2_stop"]		= %ai_idle_strafe_forward_to_exposed;

	array[animType]["combat"]["stand"]["rifle"]["fire"]						= %exposed_shoot_auto_v3;
	array[animType]["combat"]["stand"]["rifle"]["single"]					= array( %exposed_shoot_semi1 );
	array[animType]["combat"]["stand"]["rifle"]["burst2"]					= %exposed_shoot_burst3; // ( will be stopped after second bullet)
	array[animType]["combat"]["stand"]["rifle"]["burst3"]					= %exposed_shoot_burst3;
	array[animType]["combat"]["stand"]["rifle"]["burst4"]					= %exposed_shoot_burst4;
	array[animType]["combat"]["stand"]["rifle"]["burst5"]					= %exposed_shoot_burst5;
	array[animType]["combat"]["stand"]["rifle"]["burst6"]					= %exposed_shoot_burst6;
	array[animType]["combat"]["stand"]["rifle"]["semi2"]					= %exposed_shoot_semi2;
	array[animType]["combat"]["stand"]["rifle"]["semi3"]					= %exposed_shoot_semi3;
	array[animType]["combat"]["stand"]["rifle"]["semi4"]					= %exposed_shoot_semi4;
	array[animType]["combat"]["stand"]["rifle"]["semi5"]					= %exposed_shoot_semi5;

	array[animType]["combat"]["stand"]["rifle"]["reload"]					= array( %exposed_reload ); 
	array[animType]["combat"]["stand"]["rifle"]["reload_crouchhide"]		= array( %exposed_reloadb );

	array[animType]["combat"]["stand"]["rifle"]["weapon_switch"]			= %ai_stand_exposed_weaponswitch;
	
	array[animType]["combat"]["stand"]["rifle"]["turn_left_45"]				= %exposed_tracking_turn45L;
	array[animType]["combat"]["stand"]["rifle"]["turn_left_90"]				= %exposed_tracking_turn90L;
	array[animType]["combat"]["stand"]["rifle"]["turn_left_135"]			= %exposed_tracking_turn135L;
	array[animType]["combat"]["stand"]["rifle"]["turn_left_180"]			= %exposed_tracking_turn180L;
	array[animType]["combat"]["stand"]["rifle"]["turn_right_45"]			= %exposed_tracking_turn45R;
	array[animType]["combat"]["stand"]["rifle"]["turn_right_90"]			= %exposed_tracking_turn90R;
	array[animType]["combat"]["stand"]["rifle"]["turn_right_135"]			= %exposed_tracking_turn135R;
	array[animType]["combat"]["stand"]["rifle"]["turn_right_180"]			= %exposed_tracking_turn180L;		
	
	array[animType]["combat"]["stand"]["rifle"]["straight_level"]			= %exposed_aim_5;
	array[animType]["combat"]["stand"]["rifle"]["add_aim_up"]				= %exposed_aim_8;
	array[animType]["combat"]["stand"]["rifle"]["add_aim_down"]				= %exposed_aim_2;
	array[animType]["combat"]["stand"]["rifle"]["add_aim_left"]				= %exposed_aim_4;
	array[animType]["combat"]["stand"]["rifle"]["add_aim_right"]			= %exposed_aim_6;  
	
	array[animType]["combat"]["stand"]["rifle"]["add_turn_aim_up"]			= %exposed_turn_aim_8;
	array[animType]["combat"]["stand"]["rifle"]["add_turn_aim_down"]		= %exposed_turn_aim_2;
	array[animType]["combat"]["stand"]["rifle"]["add_turn_aim_left"]		= %exposed_turn_aim_4;
	array[animType]["combat"]["stand"]["rifle"]["add_turn_aim_right"]		= %exposed_turn_aim_6;
//
//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_aim_up"]		= %walk_aim_8;
//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_aim_down"]		= %walk_aim_2;
//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_aim_left"]		= %walk_aim_4;
//	array[animType]["combat"]["stand"]["rifle"]["idle_strafe_aim_right"]	= %walk_aim_6;
//	
	array[animType]["combat"]["stand"]["rifle"]["crouch_2_stand"]			= %exposed_crouch_2_stand;
	array[animType]["combat"]["stand"]["rifle"]["stand_2_crouch"]			= %exposed_stand_2_crouch;

	array[animType]["combat"]["stand"]["rifle"]["crouch_2_prone"]			= %crouch_2_prone;
	array[animType]["combat"]["stand"]["rifle"]["stand_2_prone"]			= %stand_2_prone_nodelta;
	array[animType]["combat"]["stand"]["rifle"]["prone_2_crouch"]			= %prone_2_crouch;
	array[animType]["combat"]["stand"]["rifle"]["prone_2_stand"]			= %prone_2_stand_nodelta;

	array[animType]["combat"]["stand"]["rifle"]["rechamber"]				= %exposed_rechamber;

	array[animType]["combat"]["stand"]["rifle"]["grenade_throw"]			= %ai_stand_exposed_grenade_throwa;
	array[animType]["combat"]["stand"]["rifle"]["grenade_throw_1"]			= %exposed_grenadeThrowB;
	array[animType]["combat"]["stand"]["rifle"]["grenade_throw_2"]			= %exposed_grenadeThrowC;

	array[animType]["combat"]["stand"]["rifle"]["pistol_pullout"]			= %pistol_stand_pullout;

	array[animType]["combat"]["stand"]["rifle"]["throw_down_weapon"]		= %RPG_stand_throw;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["stand"]["pistol"]["exposed_idle"]			= array( %pistol_stand_idle_alert );
	array[animType]["combat"]["stand"]["pistol"]["exposed_idle_noncombat"]	= array( %pistol_stand_idle_alert );

	array[animType]["combat"]["stand"]["pistol"]["fire"]					= %ai_tactical_walk_pistol_f_auto;
	array[animType]["combat"]["stand"]["pistol"]["single"]					= array( %pistol_stand_fire_A );
	array[animType]["combat"]["stand"]["pistol"]["semi2"]					= %ai_tactical_walk_pistol_f_semi_2;
	array[animType]["combat"]["stand"]["pistol"]["semi3"]					= %ai_tactical_walk_pistol_f_semi_3;
	array[animType]["combat"]["stand"]["pistol"]["semi4"]					= %ai_tactical_walk_pistol_f_semi_4;
	array[animType]["combat"]["stand"]["pistol"]["semi5"]					= %ai_tactical_walk_pistol_f_semi_5;

	array[animType]["move"]["stand"]["pistol"]["fire"]						= %ai_tactical_walk_pistol_f_auto;
	array[animType]["move"]["stand"]["pistol"]["burst2"]					= %ai_tactical_walk_pistol_f_burst_3;
	array[animType]["move"]["stand"]["pistol"]["burst3"]					= %ai_tactical_walk_pistol_f_burst_3;
	array[animType]["move"]["stand"]["pistol"]["burst4"]					= %ai_tactical_walk_pistol_f_burst_4;
	array[animType]["move"]["stand"]["pistol"]["burst5"]					= %ai_tactical_walk_pistol_f_burst_5;
	array[animType]["move"]["stand"]["pistol"]["burst6"]					= %ai_tactical_walk_pistol_f_burst_6;
	array[animType]["move"]["stand"]["pistol"]["semi2"]						= %ai_tactical_walk_pistol_f_semi_2;
	array[animType]["move"]["stand"]["pistol"]["semi3"]						= %ai_tactical_walk_pistol_f_semi_3;
	array[animType]["move"]["stand"]["pistol"]["semi4"]						= %ai_tactical_walk_pistol_f_semi_4;
	array[animType]["move"]["stand"]["pistol"]["semi5"]						= %ai_tactical_walk_pistol_f_semi_2;
	array[animType]["move"]["stand"]["pistol"]["single"]					= array( %pistol_stand_fire_A );

	array[animType]["combat"]["stand"]["pistol"]["reload"]					= array( %pistol_stand_reload_A, %ai_pistol_stand_exposed_reload );
	array[animType]["combat"]["stand"]["pistol"]["reload_crouchhide"]		= array( %ai_pistol_stand_exposed_reload );

	array[animType]["combat"]["stand"]["pistol"]["turn_left_45"]			= %pistol_stand_turn45L;
	array[animType]["combat"]["stand"]["pistol"]["turn_right_45"]			= %pistol_stand_turn45R;
	array[animType]["combat"]["stand"]["pistol"]["turn_left_90"]			= %pistol_stand_turn90L;
	array[animType]["combat"]["stand"]["pistol"]["turn_right_90"]			= %pistol_stand_turn90R;
	array[animType]["combat"]["stand"]["pistol"]["turn_left_135"]			= %pistol_stand_turn180L;
	array[animType]["combat"]["stand"]["pistol"]["turn_right_135"]			= %pistol_stand_turn180R;
	array[animType]["combat"]["stand"]["pistol"]["turn_left_180"]			= %pistol_stand_turn180L;
	array[animType]["combat"]["stand"]["pistol"]["turn_right_180"]			= %pistol_stand_turn180R;

	array[animType]["combat"]["stand"]["pistol"]["straight_level"]			= %pistol_stand_aim_5;
	array[animType]["combat"]["stand"]["pistol"]["add_aim_up"]				= %pistol_stand_aim_8_add;
	array[animType]["combat"]["stand"]["pistol"]["add_aim_down"]			= %pistol_stand_aim_2_add;
	array[animType]["combat"]["stand"]["pistol"]["add_aim_left"]			= %pistol_stand_aim_4_add;
	array[animType]["combat"]["stand"]["pistol"]["add_aim_right"]			= %pistol_stand_aim_6_add;  

	array[animType]["combat"]["stand"]["pistol"]["add_turn_aim_up"]			= %pistol_stand_aim_8_alt;
	array[animType]["combat"]["stand"]["pistol"]["add_turn_aim_down"]		= %pistol_stand_aim_2_alt;
	array[animType]["combat"]["stand"]["pistol"]["add_turn_aim_left"]		= %pistol_stand_aim_4_alt;
	array[animType]["combat"]["stand"]["pistol"]["add_turn_aim_right"]		= %pistol_stand_aim_6_alt;

	array[animType]["combat"]["stand"]["pistol"]["pistol_putaway"]			= %pistol_stand_switch;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Pistol Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Rocket Launcher Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["stand"]["rocketlauncher"]["straight_level"]	= %RPG_stand_aim_5;
	array[animType]["combat"]["stand"]["rocketlauncher"]["add_aim_up"]		= %RPG_stand_aim_8;
	array[animType]["combat"]["stand"]["rocketlauncher"]["add_aim_down"]	= %RPG_stand_aim_2;
	array[animType]["combat"]["stand"]["rocketlauncher"]["add_aim_left"]	= %RPG_stand_aim_4;
	array[animType]["combat"]["stand"]["rocketlauncher"]["add_aim_right"]	= %RPG_stand_aim_6;  

	array[animType]["combat"]["stand"]["rocketlauncher"]["fire"]			= %RPG_stand_fire;
	array[animType]["combat"]["stand"]["rocketlauncher"]["single"]			= array( %RPG_stand_fire );
	array[animType]["combat"]["stand"]["rocketlauncher"]["reload"]			= array( %RPG_stand_reload );
	array[animType]["combat"]["stand"]["rocketlauncher"]["reload_crouchhide"]	= array();

	array[animType]["combat"]["stand"]["rocketlauncher"]["exposed_idle"]			= array( %RPG_stand_idle );
	array[animType]["combat"]["stand"]["rocketlauncher"]["exposed_idle_noncombat"]	= array( %RPG_stand_idle );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Rocket Launcher Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Flamethrower Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["stand"]["gas"]["exposed_idle"]				= array( %ai_flamethrower_stand_idle_alert_v1 );	
	array[animType]["combat"]["stand"]["gas"]["exposed_idle_noncombat"]		= array( %ai_flamethrower_stand_idle_alert_v1 );	
	array[animType]["combat"]["stand"]["gas"]["idle1"]						= %ai_flamethrower_stand_idle_alert_v1;

	array[animType]["combat"]["stand"]["gas"]["fire"]						= %ai_flame_fire_center;
	array[animType]["combat"]["stand"]["gas"]["single"]						= %ai_flame_fire_center;

	array[animType]["combat"]["stand"]["gas"]["turn_left_45"]				= %ai_flamethrower_turn45l;
	array[animType]["combat"]["stand"]["gas"]["turn_left_90"]				= %ai_flamethrower_turn90l;
	array[animType]["combat"]["stand"]["gas"]["turn_left_135"]				= %ai_flamethrower_turn135l;
	array[animType]["combat"]["stand"]["gas"]["turn_left_180"]				= %ai_flamethrower_turn180;
	array[animType]["combat"]["stand"]["gas"]["turn_right_45"]				= %ai_flamethrower_turn45r;
	array[animType]["combat"]["stand"]["gas"]["turn_right_90"]				= %ai_flamethrower_turn90r;
	array[animType]["combat"]["stand"]["gas"]["turn_right_135"]				= %ai_flamethrower_turn135r;
	array[animType]["combat"]["stand"]["gas"]["turn_right_180"]				= %ai_flamethrower_turn180;

	array[animType]["combat"]["stand"]["gas"]["straight_level"]				= %ai_flamethrower_aim_5;		
	array[animType]["combat"]["stand"]["gas"]["add_aim_up"]					= %ai_flamethrower_aim_8;
	array[animType]["combat"]["stand"]["gas"]["add_aim_down"]				= %ai_flamethrower_aim_2;
	array[animType]["combat"]["stand"]["gas"]["add_aim_left"]				= %ai_flamethrower_aim_4;
	array[animType]["combat"]["stand"]["gas"]["add_aim_right"]				= %ai_flamethrower_aim_6;  

	array[animType]["combat"]["stand"]["gas"]["crouch_2_stand"]				= %ai_flamethrower_crouch_2_stand;
	array[animType]["combat"]["stand"]["gas"]["stand_2_crouch"]				= %ai_flamethrower_stand_2_crouch;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Flamethrower Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Shotgun Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["stand"]["spread"]["single"]					= array( %shotgun_stand_fire_1A, %shotgun_stand_fire_1B );

	// CCheng (8/22/2008): Anims are chosen at random from this array, so adding duplicate entries presumably signifies
	// the intention of increasing the odds that that anim is chosen. 
	array[animType]["combat"]["stand"]["spread"]["reload"]					= array( %shotgun_stand_reload_C );
	array[animType]["combat"]["stand"]["spread"]["reload_crouchhide"]		= array( %shotgun_stand_reload_A,%shotgun_stand_reload_B );

	array[animType]["combat"]["stand"]["spread"]["straight_level"]			= %shotgun_aim_5;

	// ALEXP_TODO: investigate this comment
	// CCheng (8/22/2008): shotgun_aim_4 and shotgun_aim_6 are swapped in the GDT, but that's because 
	// the animations themselves are labelled wrong (the actual shotgun_aim_4 animation is an aim right 
	// and the actual shotgun_aim_6 animation is an aim left). Two wrongs make a right - so DON'T SWAP
	// THEM HERE to try to fix something that is working (but for all the wrong reasons).
	array[animType]["combat"]["stand"]["spread"]["add_aim_up"]				= %shotgun_aim_8;
	array[animType]["combat"]["stand"]["spread"]["add_aim_down"]			= %shotgun_aim_2;
	array[animType]["combat"]["stand"]["spread"]["add_aim_left"]			= %shotgun_aim_4;
	array[animType]["combat"]["stand"]["spread"]["add_aim_right"]			= %shotgun_aim_6;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Shotgun Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand CQB Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ALEXP_TODO: hook this up // if ( self isCQB() )
	array[animType]["combat"]["stand"]["cqb"]["reload"]						= array( %CQB_stand_reload_steady );
	array[animType]["combat"]["stand"]["cqb"]["reload_crouchhide"]			= array( %CQB_stand_reload_knee );

	array[animType]["combat"]["stand"]["cqb"]["straight_level"]				= %CQB_stand_aim5;
	array[animType]["combat"]["stand"]["cqb"]["add_aim_up"]					= %CQB_stand_aim8;
	array[animType]["combat"]["stand"]["cqb"]["add_aim_down"]				= %CQB_stand_aim2;
	array[animType]["combat"]["stand"]["cqb"]["add_aim_left"]				= %CQB_stand_aim4;
	array[animType]["combat"]["stand"]["cqb"]["add_aim_right"]				= %CQB_stand_aim6;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand CQB Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Melee Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["stand"]["rifle"]["melee"]					= %melee_1;
	array[animType]["combat"]["stand"]["rifle"]["stand_2_melee"]			= %stand_2_melee_1;
	array[animType]["combat"]["stand"]["rifle"]["run_2_melee"]				= %run_2_melee_charge;

	array[animType]["combat"]["stand"]["pistol"]["melee"]					= %ai_pistol_melee;
	array[animType]["combat"]["stand"]["pistol"]["stand_2_melee"]			= %ai_pistol_stand_2_melee;
	array[animType]["combat"]["stand"]["pistol"]["run_2_melee"]				= %ai_pistol_run_2_melee_charge;
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Melee Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Crouch Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["crouch"]["rifle"]["exposed_idle"]			= array( %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 );
	array[animType]["combat"]["crouch"]["rifle"]["exposed_idle_noncombat"]	= array( %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 );
	
	array[animType]["combat"]["crouch"]["rifle"]["fire"]					= %exposed_crouch_shoot_auto_v2;
	array[animType]["combat"]["crouch"]["rifle"]["single"]					= array( %exposed_crouch_shoot_semi1 );
	array[animType]["combat"]["crouch"]["rifle"]["burst2"]					= %exposed_crouch_shoot_burst3; // ( will be stopped after second bullet)
	array[animType]["combat"]["crouch"]["rifle"]["burst3"]					= %exposed_crouch_shoot_burst3;
	array[animType]["combat"]["crouch"]["rifle"]["burst4"]					= %exposed_crouch_shoot_burst4;
	array[animType]["combat"]["crouch"]["rifle"]["burst5"]					= %exposed_crouch_shoot_burst5;
	array[animType]["combat"]["crouch"]["rifle"]["burst6"]					= %exposed_crouch_shoot_burst6;
	array[animType]["combat"]["crouch"]["rifle"]["semi2"]					= %exposed_crouch_shoot_semi2;
	array[animType]["combat"]["crouch"]["rifle"]["semi3"]					= %exposed_crouch_shoot_semi3;
	array[animType]["combat"]["crouch"]["rifle"]["semi4"]					= %exposed_crouch_shoot_semi4;
	array[animType]["combat"]["crouch"]["rifle"]["semi5"]					= %exposed_crouch_shoot_semi5;

	array[animType]["combat"]["crouch"]["rifle"]["reload"]					= array( %exposed_crouch_reload );

	array[animType]["combat"]["crouch"]["rifle"]["weapon_switch"]			= %ai_crouch_exposed_weaponswitch;
	
	array[animType]["combat"]["crouch"]["rifle"]["turn_left_45"]			= %exposed_crouch_turn_left;
	array[animType]["combat"]["crouch"]["rifle"]["turn_left_90"]			= %exposed_crouch_turn_left;
	array[animType]["combat"]["crouch"]["rifle"]["turn_left_135"]			= %exposed_crouch_turn_left;
	array[animType]["combat"]["crouch"]["rifle"]["turn_left_180"]			= %exposed_crouch_turn_left;
	array[animType]["combat"]["crouch"]["rifle"]["turn_right_45"]			= %exposed_crouch_turn_right;
	array[animType]["combat"]["crouch"]["rifle"]["turn_right_90"]			= %exposed_crouch_turn_right;
	array[animType]["combat"]["crouch"]["rifle"]["turn_right_135"]			= %exposed_crouch_turn_right;
	array[animType]["combat"]["crouch"]["rifle"]["turn_right_180"]			= %exposed_crouch_turn_right;		
	
	array[animType]["combat"]["crouch"]["rifle"]["straight_level"]			= %exposed_crouch_aim_5;
	array[animType]["combat"]["crouch"]["rifle"]["add_aim_up"]				= %exposed_crouch_aim_8;
	array[animType]["combat"]["crouch"]["rifle"]["add_aim_down"]			= %exposed_crouch_aim_2;
	array[animType]["combat"]["crouch"]["rifle"]["add_aim_left"]			= %exposed_crouch_aim_4;
	array[animType]["combat"]["crouch"]["rifle"]["add_aim_right"]			= %exposed_crouch_aim_6;  
	
	array[animType]["combat"]["crouch"]["rifle"]["add_turn_aim_up"]			= %exposed_crouch_turn_aim_8;
	array[animType]["combat"]["crouch"]["rifle"]["add_turn_aim_down"]		= %exposed_crouch_turn_aim_2;
	array[animType]["combat"]["crouch"]["rifle"]["add_turn_aim_left"]		= %exposed_crouch_turn_aim_4;
	array[animType]["combat"]["crouch"]["rifle"]["add_turn_aim_right"]		= %exposed_crouch_turn_aim_6;
	
	array[animType]["combat"]["crouch"]["rifle"]["crouch_2_stand"]			= %exposed_crouch_2_stand;
	array[animType]["combat"]["crouch"]["rifle"]["stand_2_crouch"]			= %exposed_stand_2_crouch;

	array[animType]["combat"]["crouch"]["rifle"]["crouch_2_prone"]			= %crouch_2_prone;
	array[animType]["combat"]["crouch"]["rifle"]["stand_2_prone"]			= %stand_2_prone_nodelta;
	array[animType]["combat"]["crouch"]["rifle"]["prone_2_crouch"]			= %prone_2_crouch;
	array[animType]["combat"]["crouch"]["rifle"]["prone_2_stand"]			= %prone_2_stand_nodelta;

	array[animType]["combat"]["crouch"]["rifle"]["rechamber"]				= %covercrouch_rechamber;

	array[animType]["combat"]["crouch"]["rifle"]["grenade_throw"]			= %crouch_grenade_throw;

	array[animType]["combat"]["crouch"]["rifle"]["throw_down_weapon"]		= %RPG_crouch_throw;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Crouch Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Crouch Rocket Launcher Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	array[animType]["combat"]["crouch"]["rocketlauncher"]["straight_level"]	= %RPG_crouch_aim_5;
	array[animType]["combat"]["crouch"]["rocketlauncher"]["add_aim_up"]		= %RPG_crouch_aim_8;
	array[animType]["combat"]["crouch"]["rocketlauncher"]["add_aim_down"]	= %RPG_crouch_aim_2;
	array[animType]["combat"]["crouch"]["rocketlauncher"]["add_aim_left"]	= %RPG_crouch_aim_4;
	array[animType]["combat"]["crouch"]["rocketlauncher"]["add_aim_right"]	= %RPG_crouch_aim_6;  

	array[animType]["combat"]["crouch"]["rocketlauncher"]["fire"]			= %RPG_crouch_fire;
	array[animType]["combat"]["crouch"]["rocketlauncher"]["single"]			= array( %RPG_crouch_fire );
	array[animType]["combat"]["crouch"]["rocketlauncher"]["reload"]			= array( %RPG_crouch_reload );

	array[animType]["combat"]["crouch"]["rocketlauncher"]["exposed_idle"]			= array( %RPG_crouch_idle );
	array[animType]["combat"]["crouch"]["rocketlauncher"]["exposed_idle_noncombat"]	= array( %RPG_crouch_idle );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Crouch Rocket Launcher Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Crouch Flamethrower Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["crouch"]["gas"]["exposed_idle"]				= array( %ai_flamethrower_crouch_idle_a_alert_v1 );	
	array[animType]["combat"]["crouch"]["gas"]["exposed_idle_noncombat"]	= array( %ai_flamethrower_crouch_idle_a_alert_v1 );	

	array[animType]["combat"]["crouch"]["gas"]["fire"]						= %ai_flame_crouch_fire_center;
	array[animType]["combat"]["crouch"]["gas"]["single"]					= %ai_flame_crouch_fire_center;

	array[animType]["combat"]["crouch"]["gas"]["turn_left_45"]				= %ai_flamethrower_crouch_turn90l;
	array[animType]["combat"]["crouch"]["gas"]["turn_left_90"]				= %ai_flamethrower_crouch_turn90l;
	array[animType]["combat"]["crouch"]["gas"]["turn_left_135"]				= %ai_flamethrower_crouch_turn90l;
	array[animType]["combat"]["crouch"]["gas"]["turn_left_180"]				= %ai_flamethrower_crouch_turn90l;
	array[animType]["combat"]["crouch"]["gas"]["turn_right_45"]				= %ai_flamethrower_crouch_turn90r;
	array[animType]["combat"]["crouch"]["gas"]["turn_right_90"]				= %ai_flamethrower_crouch_turn90r;
	array[animType]["combat"]["crouch"]["gas"]["turn_right_135"]			= %ai_flamethrower_crouch_turn90r;
	array[animType]["combat"]["crouch"]["gas"]["turn_right_180"]			= %ai_flamethrower_crouch_turn90r;

	array[animType]["combat"]["crouch"]["gas"]["straight_level"]			= %ai_flamethrower_crouch_aim_5;		
	array[animType]["combat"]["crouch"]["gas"]["add_aim_up"]				= %ai_flamethrower_crouch_aim_8;
	array[animType]["combat"]["crouch"]["gas"]["add_aim_down"]				= %ai_flamethrower_crouch_aim_2;
	array[animType]["combat"]["crouch"]["gas"]["add_aim_left"]				= %ai_flamethrower_crouch_aim_4;
	array[animType]["combat"]["crouch"]["gas"]["add_aim_right"]				= %ai_flamethrower_crouch_aim_6;  

	array[animType]["combat"]["crouch"]["gas"]["crouch_2_stand"]			= %ai_flamethrower_crouch_2_stand;
	array[animType]["combat"]["crouch"]["gas"]["stand_2_crouch"]			= %ai_flamethrower_stand_2_crouch;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Crouch Flamethrower Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Crouch Shotgun Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["crouch"]["spread"]["single"]					= array( %shotgun_crouch_fire );
	array[animType]["combat"]["crouch"]["spread"]["reload"]					= array( %shotgun_crouch_reload );

	array[animType]["combat"]["crouch"]["spread"]["straight_level"]			= %shotgun_crouch_aim_5;
	array[animType]["combat"]["crouch"]["spread"]["add_aim_up"]				= %shotgun_crouch_aim_8;
	array[animType]["combat"]["crouch"]["spread"]["add_aim_down"]			= %shotgun_crouch_aim_2;
	array[animType]["combat"]["crouch"]["spread"]["add_aim_left"]			= %shotgun_crouch_aim_4;
	array[animType]["combat"]["crouch"]["spread"]["add_aim_right"]			= %shotgun_crouch_aim_6;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Crouch Shotgun Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Prone Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["prone"]["rifle"]["add_aim_up"]				= %prone_aim_8_add;
	array[animType]["combat"]["prone"]["rifle"]["add_aim_down"]				= %prone_aim_2_add;
	array[animType]["combat"]["prone"]["rifle"]["add_aim_left"]				= %prone_aim_4_add;
	array[animType]["combat"]["prone"]["rifle"]["add_aim_right"]			= %prone_aim_6_add;

	array[animType]["combat"]["prone"]["rifle"]["straight_level"]			= %prone_aim_5;
	array[animType]["combat"]["prone"]["rifle"]["fire"]						= %prone_fire_1;

	array[animType]["combat"]["prone"]["rifle"]["single"]					= array( %prone_fire_1 );
	array[animType]["combat"]["prone"]["rifle"]["reload"]					= array( %prone_reload );
//	array[animType]["combat"]["prone"]["rifle"]["reload_2"]					= array( %reload_prone_rifle ); // Don't know what the diff is between these two

	array[animType]["combat"]["prone"]["rifle"]["burst2"]					= %prone_fire_burst;
	array[animType]["combat"]["prone"]["rifle"]["burst3"]					= %prone_fire_burst;
	array[animType]["combat"]["prone"]["rifle"]["burst4"]					= %prone_fire_burst;
	array[animType]["combat"]["prone"]["rifle"]["burst5"]					= %prone_fire_burst;
	array[animType]["combat"]["prone"]["rifle"]["burst6"]					= %prone_fire_burst;

	array[animType]["combat"]["prone"]["rifle"]["semi2"]					= %prone_fire_burst;
	array[animType]["combat"]["prone"]["rifle"]["semi3"]					= %prone_fire_burst;
	array[animType]["combat"]["prone"]["rifle"]["semi4"]					= %prone_fire_burst;
	array[animType]["combat"]["prone"]["rifle"]["semi5"]					= %prone_fire_burst;

	array[animType]["combat"]["prone"]["rifle"]["exposed_idle"]				= array( %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 );
	array[animType]["combat"]["prone"]["rifle"]["exposed_idle_noncombat"]	= array( %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 );
	
	array[animType]["combat"]["prone"]["rifle"]["crouch_2_prone"]			= %crouch_2_prone;
	array[animType]["combat"]["prone"]["rifle"]["crouch_2_stand"]			= %exposed_crouch_2_stand;
	array[animType]["combat"]["prone"]["rifle"]["stand_2_crouch"]			= %exposed_stand_2_crouch;

	array[animType]["combat"]["prone"]["rifle"]["stand_2_prone"]			= %stand_2_prone_nodelta;
	array[animType]["combat"]["prone"]["rifle"]["prone_2_crouch"]			= %prone_2_crouch;
	array[animType]["combat"]["prone"]["rifle"]["prone_2_stand"]			= %prone_2_stand_nodelta;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Prone Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Run Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["rifle"]["combat_run_f"]				= %run_lowready_F;
	array[animType]["move"]["stand"]["rifle"]["combat_run_r"]				= %run_lowready_R;
	array[animType]["move"]["stand"]["rifle"]["combat_run_l"]				= %run_lowready_L;
	array[animType]["move"]["stand"]["rifle"]["combat_run_b"]				= %run_lowready_B;
	array[animType]["move"]["stand"]["rifle"]["crouch_run_f"]				= %crouch_fastwalk_F;
	
	array[animType]["move"]["stand"]["rifle"]["run_f_to_bR"]				= %ai_run_f2b_a;
	array[animType]["move"]["stand"]["rifle"]["run_f_to_bL"]				= %ai_run_f2b;

	array[animType]["move"]["stand"]["rifle"]["cqb_run_f_to_bR"]			= %ai_cqb_run_f_2_b_right;
	array[animType]["move"]["stand"]["rifle"]["cqb_run_f_to_bL"]			= %ai_cqb_run_f_2_b_left;

	array[animType]["move"]["stand"]["rifle"]["walk_f"]						= %walk_lowready_F;
	array[animType]["move"]["stand"]["rifle"]["walk_r"]						= %walk_lowready_R;
	array[animType]["move"]["stand"]["rifle"]["walk_l"]						= %walk_lowready_L;
	array[animType]["move"]["stand"]["rifle"]["walk_b"]						= %walk_lowready_B;

	array[animType]["move"]["stand"]["rifle"]["sprint"]						= array( %ai_sprint_f, %sprint1_loop, %heat_run_loop ); //, %ai_sprint_f_02, %ai_sprint_f_03 );

	array[animType]["move"]["stand"]["rifle"]["reload"]						= %run_lowready_reload;
	array[animType]["move"]["stand"]["rifle"]["cqb_reload_walk"]			= %ai_cqb_walk_f_reload;
	array[animType]["move"]["stand"]["rifle"]["cqb_reload_run"]				= %ai_cqb_run_f_reload;

	array[animType]["move"]["stand"]["rifle"]["run_n_gun_f"]				= %run_n_gun_F;
	array[animType]["move"]["stand"]["rifle"]["run_n_gun_r"]				= %run_n_gun_R;
	array[animType]["move"]["stand"]["rifle"]["run_n_gun_l"]				= %run_n_gun_L;
	array[animType]["move"]["stand"]["rifle"]["run_n_gun_b"]				= %run_n_gun_B;
	array[animType]["move"]["stand"]["rifle"]["run_n_gun_l_120"]			= %ai_run_n_gun_l_120;
	array[animType]["move"]["stand"]["rifle"]["run_n_gun_r_120"]			= %ai_run_n_gun_r_120;

	array[animType]["move"]["stand"]["rifle"]["add_f_aim_up"]				= %ai_run_n_gun_f_aim_8;
	array[animType]["move"]["stand"]["rifle"]["add_f_aim_down"]				= %ai_run_n_gun_f_aim_2;
	array[animType]["move"]["stand"]["rifle"]["add_f_aim_left"]				= %ai_run_n_gun_f_aim_4;
	array[animType]["move"]["stand"]["rifle"]["add_f_aim_right"]			= %ai_run_n_gun_f_aim_6;

	array[animType]["move"]["stand"]["rifle"]["add_l_aim_up"]				= %run_n_gun_l_aim8;
	array[animType]["move"]["stand"]["rifle"]["add_l_aim_down"]				= %run_n_gun_l_aim2;
	array[animType]["move"]["stand"]["rifle"]["add_l_aim_left"]				= %run_n_gun_l_aim4;
	array[animType]["move"]["stand"]["rifle"]["add_l_aim_right"]			= %run_n_gun_l_aim6;

	array[animType]["move"]["stand"]["rifle"]["add_r_aim_up"]				= %run_n_gun_r_aim8;
	array[animType]["move"]["stand"]["rifle"]["add_r_aim_down"]				= %run_n_gun_r_aim2;
	array[animType]["move"]["stand"]["rifle"]["add_r_aim_left"]				= %run_n_gun_r_aim4;
	array[animType]["move"]["stand"]["rifle"]["add_r_aim_right"]			= %run_n_gun_r_aim6;

	array[animType]["move"]["stand"]["rifle"]["add_l_120_aim_up"]			= %ai_run_n_gun_l_120_aim8;
	array[animType]["move"]["stand"]["rifle"]["add_l_120_aim_down"]			= %ai_run_n_gun_l_120_aim2;
	array[animType]["move"]["stand"]["rifle"]["add_l_120_aim_left"]			= %ai_run_n_gun_l_120_aim4;
	array[animType]["move"]["stand"]["rifle"]["add_l_120_aim_right"]		= %ai_run_n_gun_l_120_aim6;

	array[animType]["move"]["stand"]["rifle"]["add_r_120_aim_up"]			= %ai_run_n_gun_r_120_aim8;
	array[animType]["move"]["stand"]["rifle"]["add_r_120_aim_down"]			= %ai_run_n_gun_r_120_aim2;
	array[animType]["move"]["stand"]["rifle"]["add_r_120_aim_left"]			= %ai_run_n_gun_r_120_aim4;
	array[animType]["move"]["stand"]["rifle"]["add_r_120_aim_right"]		= %ai_run_n_gun_r_120_aim6;

	array[animType]["move"]["stand"]["rifle"]["cqb_sprint_f"]				= %ai_cqb_sprint;
	array[animType]["move"]["stand"]["rifle"]["cqb_sprint_r"]				= %walk_left;
	array[animType]["move"]["stand"]["rifle"]["cqb_sprint_l"]				= %walk_right;
	array[animType]["move"]["stand"]["rifle"]["cqb_sprint_b"]				= %walk_backward;

	array[animType]["move"]["stand"]["rifle"]["cqb_walk_f"]					= array( %walk_CQB_F, %walk_CQB_F_search_v1, %walk_CQB_F_search_v2 );
	array[animType]["move"]["stand"]["rifle"]["cqb_walk_r"]					= %walk_left;
	array[animType]["move"]["stand"]["rifle"]["cqb_walk_l"]					= %walk_right;
	array[animType]["move"]["stand"]["rifle"]["cqb_walk_b"]					= %walk_backward;

	array[animType]["move"]["stand"]["rifle"]["cqb_run_f"]					= array( %run_CQB_F_search_v1 );
	array[animType]["move"]["stand"]["rifle"]["cqb_run_r"]					= %walk_left;
	array[animType]["move"]["stand"]["rifle"]["cqb_run_l"]					= %walk_right;
	array[animType]["move"]["stand"]["rifle"]["cqb_run_b"]					= %walk_backward;

	array[animType]["move"]["stand"]["rifle"]["tactical_walk_f"]			= %ai_tactical_walk_f;
	array[animType]["move"]["stand"]["rifle"]["tactical_walk_r"]			= %ai_tactical_walk_l;
	array[animType]["move"]["stand"]["rifle"]["tactical_walk_l"]			= %ai_tactical_walk_r;
	array[animType]["move"]["stand"]["rifle"]["tactical_walk_b"]			= %ai_tactical_walk_b;

	array[animType]["move"]["stand"]["rifle"]["tactical_b_aim_up"]			= %ai_tactical_walk_b_aim8;
	array[animType]["move"]["stand"]["rifle"]["tactical_b_aim_down"]		= %ai_tactical_walk_b_aim2;
	array[animType]["move"]["stand"]["rifle"]["tactical_b_aim_left"]		= %ai_tactical_walk_b_aim4;
	array[animType]["move"]["stand"]["rifle"]["tactical_b_aim_right"]		= %ai_tactical_walk_b_aim6;

	array[animType]["move"]["stand"]["rifle"]["tactical_f_aim_up"]			= %ai_tactical_walk_f_aim8;
	array[animType]["move"]["stand"]["rifle"]["tactical_f_aim_down"]		= %ai_tactical_walk_f_aim2;
	array[animType]["move"]["stand"]["rifle"]["tactical_f_aim_left"]		= %ai_tactical_walk_f_aim4;
	array[animType]["move"]["stand"]["rifle"]["tactical_f_aim_right"]		= %ai_tactical_walk_f_aim6;

	array[animType]["move"]["stand"]["rifle"]["tactical_l_aim_up"]			= %ai_tactical_walk_l_aim8;
	array[animType]["move"]["stand"]["rifle"]["tactical_l_aim_down"]		= %ai_tactical_walk_l_aim2;
	array[animType]["move"]["stand"]["rifle"]["tactical_l_aim_left"]		= %ai_tactical_walk_l_aim4;
	array[animType]["move"]["stand"]["rifle"]["tactical_l_aim_right"]		= %ai_tactical_walk_l_aim6;

	array[animType]["move"]["stand"]["rifle"]["cqb_f_aim_up"]				= %walk_aim_8;
	array[animType]["move"]["stand"]["rifle"]["cqb_f_aim_down"]				= %walk_aim_2;
	array[animType]["move"]["stand"]["rifle"]["cqb_f_aim_left"]				= %walk_aim_4;
	array[animType]["move"]["stand"]["rifle"]["cqb_f_aim_right"]			= %walk_aim_6;

	array[animType]["move"]["stand"]["gas"]["combat_run_f"]					= %ai_flamethrower_combatrun_c;

	array[animType]["move"]["crouch"]["rifle"]["combat_run_f"]				= %crouch_fastwalk_F;
	array[animType]["move"]["crouch"]["rifle"]["combat_run_r"]				= %crouch_fastwalk_R;
	array[animType]["move"]["crouch"]["rifle"]["combat_run_l"]				= %crouch_fastwalk_L;
	array[animType]["move"]["crouch"]["rifle"]["combat_run_b"]				= %crouch_fastwalk_B;
	array[animType]["move"]["crouch"]["rifle"]["crouch_run_f"]				= %crouch_fastwalk_F;

	array[animType]["move"]["crouch"]["rifle"]["add_f_aim_up"]				= %ai_crouch_fastwalk_f_aim_8;
	array[animType]["move"]["crouch"]["rifle"]["add_f_aim_down"]			= %ai_crouch_fastwalk_f_aim_2;
	array[animType]["move"]["crouch"]["rifle"]["add_f_aim_left"]			= %ai_crouch_fastwalk_f_aim_4;
	array[animType]["move"]["crouch"]["rifle"]["add_f_aim_right"]			= %ai_crouch_fastwalk_f_aim_6;

	array[animType]["move"]["stand"]["rifle"]["start_stand_run_f"]			= %run_lowready_F;
	array[animType]["move"]["crouch"]["rifle"]["start_stand_run_f"]			= %crouch_fastwalk_F;
	array[animType]["move"]["prone"]["rifle"]["start_stand_run_f"]			= %run_lowready_F;

	array[animType]["move"]["stand"]["rifle"]["start_crouch_run_f"]			= %crouch_fastwalk_F;
	array[animType]["move"]["crouch"]["rifle"]["start_crouch_run_f"]		= %crouch_fastwalk_F;
	array[animType]["move"]["prone"]["rifle"]["start_crouch_run_f"]			= %crouch_fastwalk_F;

	array[animType]["move"]["stand"]["rifle"]["start_cqb_run_f"]			= %walk_CQB_F;
	array[animType]["move"]["crouch"]["rifle"]["start_cqb_run_f"]			= %walk_CQB_F;
	array[animType]["move"]["prone"]["rifle"]["start_cqb_run_f"]			= %walk_CQB_F;
	
	array[animType]["move"]["crouch"]["rifle"]["walk_f"]					= %crouch_fastwalk_F;
	array[animType]["move"]["crouch"]["rifle"]["walk_r"]					= %crouch_fastwalk_R;
	array[animType]["move"]["crouch"]["rifle"]["walk_l"]					= %crouch_fastwalk_L;
	array[animType]["move"]["crouch"]["rifle"]["walk_b"]					= %crouch_fastwalk_B;

	array[animType]["move"]["stand"]["rifle"]["run_2_prone_dive"]			= %crouch_2_prone;
	array[animType]["move"]["stand"]["rifle"]["run_2_prone_gunsupport"]		= %crouch2prone_gunsupport;

	array[animType]["move"]["crouch"]["rifle"]["run_2_prone_dive"]			= %crouch_2_prone;
	array[animType]["move"]["crouch"]["rifle"]["run_2_prone_gunsupport"]	= %crouch2prone_gunsupport;

	array[animType]["move"]["crouch"]["pistol"]["crouch_2_stand"]			= %pistol_crouchaimstraight2stand;
	array[animType]["move"]["crouch"]["rifle"]["crouch_2_stand"]			= %exposed_crouch_2_stand;
	array[animType]["move"]["crouch"]["rifle"]["crouch_2_prone"]			= %crouch_2_prone;

	array[animType]["move"]["prone"]["rifle"]["combat_run_f"]				= %prone_crawl;
	array[animType]["move"]["prone"]["rifle"]["prone_2_crouch_run"]			= %prone2crouchrun_straight;
	array[animType]["move"]["prone"]["rifle"]["prone_2_crouch"]				= %prone_2_crouch;
	array[animType]["move"]["prone"]["rifle"]["prone_2_stand"]				= %prone_2_stand;
	array[animType]["move"]["prone"]["rifle"]["crouch_run_f"]				= %crouch_fastwalk_F;
	array[animType]["move"]["prone"]["rifle"]["aim_2_crawl"]				= %prone_aim2crawl;
	array[animType]["move"]["prone"]["rifle"]["crawl_2_aim"]				= %prone_crawl2aim;

	array[animType]["move"]["stand"]["rifle"]["stand_2_prone_onehand"]		= %stand2prone_onehand;
	array[animType]["move"]["stand"]["rifle"]["stand_2_prone"]				= %stand_2_prone;
	array[animType]["move"]["stand"]["rifle"]["stand_2_crouch"]				= %exposed_stand_2_crouch;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Run Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Walk Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Walk Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Move Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["rifle"]["fire"]						= %exposed_shoot_auto_v3;
	array[animType]["move"]["stand"]["rifle"]["burst2"]						= %exposed_shoot_burst3;
	array[animType]["move"]["stand"]["rifle"]["burst3"]						= %exposed_shoot_burst3;
	array[animType]["move"]["stand"]["rifle"]["burst4"]						= %exposed_shoot_burst4;
	array[animType]["move"]["stand"]["rifle"]["burst5"]						= %exposed_shoot_burst5;
	array[animType]["move"]["stand"]["rifle"]["burst6"]						= %exposed_shoot_burst6;
	array[animType]["move"]["stand"]["rifle"]["semi2"]						= %exposed_shoot_semi2;
	array[animType]["move"]["stand"]["rifle"]["semi3"]						= %exposed_shoot_semi3;
	array[animType]["move"]["stand"]["rifle"]["semi4"]						= %exposed_shoot_semi4;
	array[animType]["move"]["stand"]["rifle"]["semi5"]						= %exposed_shoot_semi5;
	array[animType]["move"]["stand"]["rifle"]["single"]						= array( %exposed_shoot_semi1 );

	array[animType]["move"]["stand"]["spread"]["single"]					= array( %shotgun_stand_fire_1A, %shotgun_stand_fire_1B );

	array[animType]["move"]["stand"]["rifle"]["throw_down_weapon"]			= %RPG_stand_throw;
	array[animType]["move"]["crouch"]["rifle"]["throw_down_weapon"]			= %RPG_crouch_throw;

	//array[animType]["move"]["stand"]["rifle"]["weapon_switch"]				= %ai_cqbrun_weaponswitch;
	array[animType]["move"]["stand"]["rifle"]["weapon_switch"]				= %ai_run_lowready_f_weaponswitch;

	array[animType]["move"]["crouch"]["rifle"]["fire"]						= %exposed_shoot_auto_v3;
	array[animType]["move"]["crouch"]["rifle"]["burst2"]					= %exposed_shoot_burst3;
	array[animType]["move"]["crouch"]["rifle"]["burst3"]					= %exposed_shoot_burst3;
	array[animType]["move"]["crouch"]["rifle"]["burst4"]					= %exposed_shoot_burst4;
	array[animType]["move"]["crouch"]["rifle"]["burst5"]					= %exposed_shoot_burst5;
	array[animType]["move"]["crouch"]["rifle"]["burst6"]					= %exposed_shoot_burst6;
	array[animType]["move"]["crouch"]["rifle"]["semi2"]						= %exposed_shoot_semi2;
	array[animType]["move"]["crouch"]["rifle"]["semi3"]						= %exposed_shoot_semi3;
	array[animType]["move"]["crouch"]["rifle"]["semi4"]						= %exposed_shoot_semi4;
	array[animType]["move"]["crouch"]["rifle"]["semi5"]						= %exposed_shoot_semi5;
	array[animType]["move"]["crouch"]["rifle"]["single"]					= array( %exposed_shoot_semi1 );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Move Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// indicies indicate the keyboard numpad directions (8 is forward)
	// 7  8  9
	// 4     6	 <- 5 is invalid
	// 1  2  3

	array[animType]["move"]["stand"]["rifle"]["arrive_stand_mini_1"]		= %coverstand_mini_approach_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_stand_mini_2"]		= %coverstand_mini_approach_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_stand_mini_3"]		= %coverstand_mini_approach_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_stand_mini_4"]		= %coverstand_mini_approach_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_stand_mini_6"]		= %coverstand_mini_approach_6;

	array[animType]["move"]["stand"]["rifle"]["arrive_right"][1]			= %corner_standR_trans_IN_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][2]			= %corner_standR_trans_IN_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][3]			= %corner_standR_trans_IN_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][4]			= %corner_standR_trans_IN_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][6]			= %corner_standR_trans_IN_6;
	//array[animType]["move"]["stand"]["rifle"]["arrive_right"][7]			= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][8]			= %corner_standR_trans_IN_8;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][9]			= %corner_standR_trans_IN_9;

	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][1]		= %CornerCrR_trans_IN_ML;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][2]		= %CornerCrR_trans_IN_M;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][3]		= %CornerCrR_trans_IN_MR;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][4]		= %CornerCrR_trans_IN_L;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][6]		= %CornerCrR_trans_IN_R;
	//array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][7]	= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][8]		= %CornerCrR_trans_IN_F;
	array[animType]["move"]["stand"]["rifle"]["arrive_right_crouch"][9]		= %CornerCrR_trans_IN_MF;

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


	array[animType]["move"]["stand"]["rifle"]["arrive_left"][1]				= %corner_standL_trans_IN_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][2]				= %corner_standL_trans_IN_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][3]				= %corner_standL_trans_IN_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][4]				= %corner_standL_trans_IN_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][6]				= %corner_standL_trans_IN_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][7]				= %corner_standL_trans_IN_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][8]				= %corner_standL_trans_IN_8;
	//array[animType]["move"]["stand"]["rifle"]["arrive_left"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][1]		= %CornerCrL_trans_IN_ML;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][2]		= %CornerCrL_trans_IN_M;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][3]		= %CornerCrL_trans_IN_MR;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][4]		= %CornerCrL_trans_IN_L;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][6]		= %CornerCrL_trans_IN_R;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][7]		= %CornerCrL_trans_IN_MF;
	array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][8]		= %CornerCrL_trans_IN_F;
	//array[animType]["move"]["stand"]["rifle"]["arrive_left_crouch"][9]	= can't approach from this direction

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


	array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][1]			= %covercrouch_run_in_ML;
	array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][2]			= %covercrouch_run_in_M;
	array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][3]			= %covercrouch_run_in_MR;
	array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][4]			= %covercrouch_run_in_L;
	array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][6]			= %covercrouch_run_in_R;
	//array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][7]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][8]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["arrive_crouch"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["arrive_stand"][1]			= %coverstand_trans_IN_ML;
	array[animType]["move"]["stand"]["rifle"]["arrive_stand"][2]			= %coverstand_trans_IN_M;
	array[animType]["move"]["stand"]["rifle"]["arrive_stand"][3]			= %coverstand_trans_IN_MR;
	array[animType]["move"]["stand"]["rifle"]["arrive_stand"][4]			= %coverstand_trans_IN_L;
	array[animType]["move"]["stand"]["rifle"]["arrive_stand"][6]			= %coverstand_trans_IN_R;
	//array[animType]["move"]["stand"]["rifle"]["arrive_stand"][7]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["arrive_stand"][8]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["arrive_stand"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["arrive_pillar"][1]			= %ai_pillar2_stand_arrive_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar"][2]			= %ai_pillar2_stand_arrive_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar"][3]			= %ai_pillar2_stand_arrive_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar"][4]			= %ai_pillar2_stand_arrive_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar"][6]			= %ai_pillar2_stand_arrive_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar"][7]			= %ai_pillar2_stand_arrive_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar"][8]			= %ai_pillar2_stand_arrive_8r;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar"][9]			= %ai_pillar2_stand_arrive_9;

	array[animType]["move"]["stand"]["rifle"]["arrive_pillar_crouch"][1]	= %ai_pillar2_crouch_arrive_1;//%ai_pillar_crouch_arrive_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar_crouch"][2]	= %ai_pillar2_crouch_arrive_2;//%ai_pillar_crouch_arrive_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar_crouch"][3]	= %ai_pillar2_crouch_arrive_3;//%ai_pillar_crouch_arrive_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar_crouch"][4]	= %ai_pillar2_crouch_arrive_4;//%ai_pillar_crouch_arrive_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar_crouch"][6]	= %ai_pillar2_crouch_arrive_6;//%ai_pillar_crouch_arrive_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar_crouch"][7]	= %ai_pillar2_crouch_arrive_7;//%ai_pillar_crouch_arrive_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar_crouch"][8]	= %ai_pillar2_crouch_arrive_8r;//%ai_pillar_crouch_arrive_8r;
	array[animType]["move"]["stand"]["rifle"]["arrive_pillar_crouch"][9]	= %ai_pillar2_crouch_arrive_9;//%ai_pillar_crouch_arrive_9;

	array[animType]["move"]["stand"]["mg"]["arrive_stand"][1]				= %saw_gunner_runin_ML;
	array[animType]["move"]["stand"]["mg"]["arrive_stand"][2]				= %saw_gunner_runin_M;
	array[animType]["move"]["stand"]["mg"]["arrive_stand"][3]				= %saw_gunner_runin_MR;
	array[animType]["move"]["stand"]["mg"]["arrive_stand"][4]				= %saw_gunner_runin_L;
	array[animType]["move"]["stand"]["mg"]["arrive_stand"][6]				= %saw_gunner_runin_R;

	array[animType]["move"]["stand"]["mg"]["arrive_crouch"][1]				= %saw_gunner_lowwall_runin_ML;
	array[animType]["move"]["stand"]["mg"]["arrive_crouch"][2]				= %saw_gunner_lowwall_runin_M;
	array[animType]["move"]["stand"]["mg"]["arrive_crouch"][3]				= %saw_gunner_lowwall_runin_MR;
	array[animType]["move"]["stand"]["mg"]["arrive_crouch"][4]				= %saw_gunner_lowwall_runin_L;
	array[animType]["move"]["stand"]["mg"]["arrive_crouch"][6]				= %saw_gunner_lowwall_runin_R;

	array[animType]["move"]["stand"]["mg"]["arrive_prone"][1]				= %saw_gunner_prone_runin_ML;
	array[animType]["move"]["stand"]["mg"]["arrive_prone"][2]				= %saw_gunner_prone_runin_M;
	array[animType]["move"]["stand"]["mg"]["arrive_prone"][3]				= %saw_gunner_prone_runin_MR;

	// we need 45 degree angle approaches for exposed...

	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][1]			= %CQB_stop_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][2]			= %run_2_stand_F_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][3]			= %CQB_stop_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][4]			= %run_2_stand_90L;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][6]			= %run_2_stand_90R;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][7]			= %CQB_stop_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][8]			= %run_2_stand_180L;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][9]			= %CQB_stop_9;

	// we need 45 degree angle approaches for exposed...
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][1]	= %CQB_crouch_stop_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][2]	= %run_2_crouch_F;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][3]	= %CQB_crouch_stop_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][4]	= %run_2_crouch_90L;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][6]	= %run_2_crouch_90R;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][7]	= %CQB_crouch_stop_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][8]	= %run_2_crouch_180L;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][9]	= %CQB_crouch_stop_9;

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
	array[animType]["move"]["stand"]["rifle"]["exit_right"][1]				= %corner_standR_trans_OUT_1;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][2]				= %corner_standR_trans_OUT_2;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][3]				= %corner_standR_trans_OUT_3;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][4]				= %corner_standR_trans_OUT_4;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][6]				= %corner_standR_trans_OUT_6;
	//array[animType]["move"]["stand"]["rifle"]["exit_right"][7]			= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["exit_right"][8]				= %corner_standR_trans_OUT_8;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][9]				= %corner_standR_trans_OUT_9;

	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][1]		= %CornerCrR_trans_OUT_ML;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][2]		= %CornerCrR_trans_OUT_M;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][3]		= %CornerCrR_trans_OUT_MR;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][4]		= %CornerCrR_trans_OUT_L;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][6]		= %CornerCrR_trans_OUT_R;
	//array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][7]		= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][8]		= %CornerCrR_trans_OUT_F;
	array[animType]["move"]["stand"]["rifle"]["exit_right_crouch"][9]		= %CornerCrR_trans_OUT_MF;

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


	array[animType]["move"]["stand"]["rifle"]["exit_left"][1]				= %corner_standL_trans_OUT_1;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][2]				= %corner_standL_trans_OUT_2;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][3]				= %corner_standL_trans_OUT_3;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][4]				= %corner_standL_trans_OUT_4;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][6]				= %corner_standL_trans_OUT_6;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][7]				= %corner_standL_trans_OUT_7;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][8]				= %corner_standL_trans_OUT_8;
	//array[animType]["move"]["stand"]["rifle"]["exit_left"][9]				= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][1]		= %CornerCrL_trans_OUT_ML;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][2]		= %CornerCrL_trans_OUT_M;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][3]		= %CornerCrL_trans_OUT_MR;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][4]		= %CornerCrL_trans_OUT_L;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][6]		= %CornerCrL_trans_OUT_R;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][7]		= %CornerCrL_trans_OUT_MF;
	array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][8]		= %CornerCrL_trans_OUT_M;
	//array[animType]["move"]["stand"]["rifle"]["exit_left_crouch"][9]		= can't approach from this direction

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


	array[animType]["move"]["stand"]["rifle"]["exit_crouch"][1]				= %covercrouch_run_out_ML;
	array[animType]["move"]["stand"]["rifle"]["exit_crouch"][2]				= %covercrouch_run_out_M;
	array[animType]["move"]["stand"]["rifle"]["exit_crouch"][3]				= %covercrouch_run_out_MR;
	array[animType]["move"]["stand"]["rifle"]["exit_crouch"][4]				= %covercrouch_run_out_L;
	array[animType]["move"]["stand"]["rifle"]["exit_crouch"][6]				= %covercrouch_run_out_R;
	//array[animType]["move"]["stand"]["rifle"]["exit_crouch"][7]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["exit_crouch"][8]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["exit_crouch"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["exit_stand"][1]				= %coverstand_trans_OUT_ML;
	array[animType]["move"]["stand"]["rifle"]["exit_stand"][2]				= %coverstand_trans_OUT_M;
	array[animType]["move"]["stand"]["rifle"]["exit_stand"][3]				= %coverstand_trans_OUT_MR;
	array[animType]["move"]["stand"]["rifle"]["exit_stand"][4]				= %coverstand_trans_OUT_L;
	array[animType]["move"]["stand"]["rifle"]["exit_stand"][6]				= %coverstand_trans_OUT_R;
	//array[animType]["move"]["stand"]["rifle"]["exit_stand"][7]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["exit_stand"][8]			= can't approach from this direction
	//array[animType]["move"]["stand"]["rifle"]["exit_stand"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["exit_pillar"][1]				= %ai_pillar2_stand_exit_1;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar"][2]				= %ai_pillar2_stand_exit_2;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar"][3]				= %ai_pillar2_stand_exit_3;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar"][4]				= %ai_pillar2_stand_exit_4;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar"][6]				= %ai_pillar2_stand_exit_6;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar"][7]				= %ai_pillar2_stand_exit_7;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar"][8]				= %ai_pillar2_stand_exit_8r;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar"][9]				= %ai_pillar2_stand_exit_9;

	array[animType]["move"]["stand"]["rifle"]["exit_pillar_crouch"][1]		= %ai_pillar2_crouch_exit_1;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar_crouch"][2]		= %ai_pillar2_crouch_exit_2;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar_crouch"][3]		= %ai_pillar2_crouch_exit_3;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar_crouch"][4]		= %ai_pillar2_crouch_exit_4;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar_crouch"][6]		= %ai_pillar2_crouch_exit_6;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar_crouch"][7]		= %ai_pillar2_crouch_exit_7;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar_crouch"][8]		= %ai_pillar2_crouch_exit_8r;
	array[animType]["move"]["stand"]["rifle"]["exit_pillar_crouch"][9]		= %ai_pillar2_crouch_exit_9;

	array[animType]["move"]["stand"]["mg"]["exit_stand"][1]					= %saw_gunner_runout_ML;
	array[animType]["move"]["stand"]["mg"]["exit_stand"][2]					= %saw_gunner_runout_M;
	array[animType]["move"]["stand"]["mg"]["exit_stand"][3]					= %saw_gunner_runout_MR;
	array[animType]["move"]["stand"]["mg"]["exit_stand"][4]					= %saw_gunner_runout_L;
	array[animType]["move"]["stand"]["mg"]["exit_stand"][6]					= %saw_gunner_runout_R;

	array[animType]["move"]["stand"]["mg"]["exit_crouch"][1]				= %saw_gunner_lowwall_runout_ML;
	array[animType]["move"]["stand"]["mg"]["exit_crouch"][2]				= %saw_gunner_lowwall_runout_M;
	array[animType]["move"]["stand"]["mg"]["exit_crouch"][3]				= %saw_gunner_lowwall_runout_MR;
	array[animType]["move"]["stand"]["mg"]["exit_crouch"][4]				= %saw_gunner_lowwall_runout_L;
	array[animType]["move"]["stand"]["mg"]["exit_crouch"][6]				= %saw_gunner_lowwall_runout_R;

	array[animType]["move"]["stand"]["mg"]["exit_prone"][2]					= %saw_gunner_prone_runout_M;
	array[animType]["move"]["stand"]["mg"]["exit_prone"][4]					= %saw_gunner_prone_runout_L;
	array[animType]["move"]["stand"]["mg"]["exit_prone"][6]					= %saw_gunner_prone_runout_R;
	array[animType]["move"]["stand"]["mg"]["exit_prone"][8]					= %saw_gunner_prone_runout_F;

	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][1]			= %ai_stand_exposed_exit_1;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][2]			= %ai_stand_exposed_exit_2;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][3]			= %ai_stand_exposed_exit_3;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][4]			= %ai_stand_exposed_exit_4;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][6]			= %ai_stand_exposed_exit_6;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][7]			= %ai_stand_exposed_exit_7;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][8]			= %ai_stand_exposed_exit_8;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][9]			= %ai_stand_exposed_exit_9;
	
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][1]		= %CQB_crouch_start_1;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][2]		= %crouch_2run_180;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][3]		= %CQB_crouch_start_3;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][4]		= %crouch_2run_L;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][6]		= %crouch_2run_R;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][7]		= %CQB_crouch_start_7;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][8]		= %crouch_2run_F;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][9]		= %CQB_crouch_start_9;

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
// Begin Cover Shuffle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["rifle"]["shuffleR_start"]			= %ai_coverstand_hide_2_shuffleR;
	array[animType]["move"]["stand"]["rifle"]["shuffleR"]				= %ai_coverstand_shuffleR;
	array[animType]["move"]["stand"]["rifle"]["shuffleR_end"]			= %ai_coverstand_shuffleR_2_hide;	

	array[animType]["move"]["stand"]["rifle"]["shuffleL_start"]			= %ai_coverstand_hide_2_shuffleL;
	array[animType]["move"]["stand"]["rifle"]["shuffleL"]				= %ai_coverstand_shuffleL;
	array[animType]["move"]["stand"]["rifle"]["shuffleL_end"]			= %ai_coverstand_shuffleL_2_hide;

	array[animType]["move"]["stand"]["rifle"]["corner_door_R2L"]		= %ai_corner_standR_Door_R2L;
	array[animType]["move"]["stand"]["rifle"]["corner_door_L2R"]		= %ai_corner_standL_Door_L2R;

	array[animType]["move"]["crouch"]["rifle"]["corner_door_R2L"]		= %ai_corner_standR_Door_R2L;
	array[animType]["move"]["crouch"]["rifle"]["corner_door_L2R"]		= %ai_corner_standL_Door_L2R;

	array[animType]["move"]["crouch"]["rifle"]["shuffleR_start"]		= %ai_covercrouch_hide_2_shuffleR;
	array[animType]["move"]["crouch"]["rifle"]["shuffleR"]				= %ai_covercrouch_shuffleR;
	array[animType]["move"]["crouch"]["rifle"]["shuffleR_end"]			= %ai_covercrouch_shuffleR_2_hide;	

	array[animType]["move"]["crouch"]["rifle"]["shuffleL_start"]		= %ai_covercrouch_hide_2_shuffleL;
	array[animType]["move"]["crouch"]["rifle"]["shuffleL"]				= %ai_covercrouch_shuffleL;
	array[animType]["move"]["crouch"]["rifle"]["shuffleL_end"]			= %ai_covercrouch_shuffleL_2_hide;

	array[animType]["move"]["crouch"]["rifle"]["cornerL_shuffle_start"]	= %ai_CornerCrL_alert_2_shuffle;
	array[animType]["move"]["crouch"]["rifle"]["cornerL_shuffle_end"]	= %ai_CornerCrL_shuffle_2_alert;

	array[animType]["move"]["crouch"]["rifle"]["cornerR_shuffle_start"]	= %ai_CornerCrR_alert_2_shuffle;
	array[animType]["move"]["crouch"]["rifle"]["cornerR_shuffle_end"]	= %ai_CornerCrR_shuffle_2_alert;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Shuffle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Stop Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["stop"]["stand"]["rifle"]["stand_2_crouch"]				= %exposed_stand_2_crouch;
	array[animType]["stop"]["stand"]["rifle"]["stand_2_prone_onehand"]		= %stand2prone_onehand;
	array[animType]["stop"]["stand"]["rifle"]["stand_2_prone"]				= %stand_2_prone;

	array[animType]["stop"]["stand"]["rifle"]["idle_trans_in"]					= %casual_stand_idle_trans_in;
	array[animType]["stop"]["stand"]["rifle"]["idle"]						= array(
																				array(%casual_stand_idle, %casual_stand_idle, %casual_stand_idle_twitch, %casual_stand_idle_twitchB),
																				array(%casual_stand_v2_idle, %casual_stand_v2_idle, %casual_stand_v2_twitch_radio, %casual_stand_v2_twitch_shift, %casual_stand_v2_twitch_shift, %casual_stand_v2_twitch_talk)
																			  );
	array[animType]["stop"]["stand"]["rifle"]["idle_cqb"]					= array( array(%cqb_stand_idle, %cqb_stand_idle, %cqb_stand_twitch) );	

	array[animType]["stop"]["stand"]["rifle"]["idle_trans_hmg"]				= %ai_mg_shoulder_run2stand;
	array[animType]["stop"]["stand"]["rifle"]["idle_hmg"]					= array( array(%ai_mg_shoulder_stand_idle) );

	array[animType]["stop"]["stand"]["gas"]["idle"]							= array( array(%ai_flamethrower_stand_idle_casual_v1, %ai_flamethrower_stand_idle_casual_v1, %ai_flamethrower_stand_idle_casual_v1, %ai_flamethrower_stand_twitch) );
	
	array[animType]["stop"]["crouch"]["rifle"]["idle_trans_in"]				= %casual_crouch_idle_in;
	array[animType]["stop"]["crouch"]["rifle"]["idle"]						= array( array(%casual_crouch_idle, %casual_crouch_idle, %casual_crouch_idle, %casual_crouch_idle, %casual_crouch_twitch, %casual_crouch_twitch, %casual_crouch_point) );

	array[animType]["stop"]["crouch"]["rifle"]["idle_trans_hmg"]			= %ai_mg_shoulder_run2crouch;
	array[animType]["stop"]["crouch"]["rifle"]["idle_hmg"]					= array( array(%ai_mg_shoulder_crouch_idle) );

	array[animType]["stop"]["crouch"]["gas"]["idle"]						= array( array(%ai_flamethrower_crouch_idle_a, %ai_flamethrower_crouch_idle_a, %ai_flamethrower_crouch_idle_a, %ai_flamethrower_crouch_idle_b, %ai_flamethrower_crouch_idle_b, %ai_flamethrower_crouch_idle_b, %ai_flamethrower_crouch_twitch) );	

	array[animType]["stop"]["crouch"]["pistol"]["crouch_2_stand"]			= %pistol_crouchaimstraight2stand;
	array[animType]["stop"]["crouch"]["rifle"]["crouch_2_stand"]			= %exposed_crouch_2_stand;
	array[animType]["stop"]["crouch"]["rifle"]["crouch_2_prone"]			= %crouch_2_prone;

	array[animType]["stop"]["prone"]["rifle"]["crawl_2_aim"]				= %prone_crawl2aim;

	array[animType]["stop"]["prone"]["rifle"]["prone_2_crouch"]				= %prone_2_crouch;
	array[animType]["stop"]["prone"]["rifle"]["prone_2_stand"]				= %prone_2_stand;

	array[animType]["stop"]["prone"]["rifle"]["twitch"]						= array(%prone_twitch_ammocheck, %prone_twitch_ammocheck2, %prone_twitch_look, %prone_twitch_lookfast, %prone_twitch_lookup, %prone_twitch_scan, %prone_twitch_scan2);
	array[animType]["stop"]["prone"]["rifle"]["straight_level"]				= %prone_aim_5;
	array[animType]["stop"]["prone"]["rifle"]["idle"]						= array( array(%prone_idle) );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Stop Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Turret Weapon Animations
///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	array[animType]["stop"]["stand"]["bipod"]["aim"]		= %standSAWgunner_aim;
	array[animType]["stop"]["stand"]["bipod"]["idle"]		= %saw_gunner_idle;
	array[animType]["stop"]["stand"]["bipod"]["fire"]		= %saw_gunner_firing_add;
	
	array[animType]["stop"]["crouch"]["bipod"]["aim"]		= %crouchSAWgunner_aim;
	array[animType]["stop"]["crouch"]["bipod"]["idle"]		= %saw_gunner_idle;
	array[animType]["stop"]["crouch"]["bipod"]["fire"]		= %saw_gunner_firing_add;
	
	array[animType]["stop"]["prone"]["bipod"]["aim"]		= %proneSAWgunner_aim;
	array[animType]["stop"]["prone"]["bipod"]["idle"]		= %saw_gunner_idle;
	array[animType]["stop"]["prone"]["bipod"]["fire"]		= %saw_gunner_firing_add;
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Turret Weapon Animations
///////////////////////////////////////////////////////////////////////////////////////////////////////////

// ALEXP_TODO: maybe the exposed anim shouldn't be duplicated for all cover types.. revert to default if missing?
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_left"]["stand"]["rifle"]["reload"]				= array( %corner_standL_reload_v1 );

	// cover-left specific

	// ALEXP_TODO: make these lean anims work
	array[animType]["cover_left"]["stand"]["rifle"]["lean_fire"]			= %CornerStndL_lean_auto;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_semi2"]			= %CornerStndL_lean_auto;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_semi3"]			= %CornerStndL_lean_auto;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_semi4"]			= %CornerStndL_lean_auto;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_semi5"]			= %CornerStndL_lean_auto;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_burst2"]			= %CornerStndL_lean_auto;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_burst3"]			= %CornerStndL_lean_auto;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_burst4"]			= %CornerStndL_lean_auto;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_burst5"]			= %CornerStndL_lean_auto;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_burst6"]			= %CornerStndL_lean_auto;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_single"]			= array( %CornerStndL_lean_fire );
	array[animType]["cover_left"]["stand"]["rifle"]["lean_rechamber"]		= %CornerStndL_lean_rechamber;

	array[animType]["cover_left"]["stand"]["rifle"]["lean_aim_down"]		= %CornerStndL_lean_aim_2;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_aim_left"]		= %CornerStndL_lean_aim_4;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_aim_straight"]	= %CornerStndL_lean_aim_5;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_aim_right"]		= %CornerStndL_lean_aim_6;
	array[animType]["cover_left"]["stand"]["rifle"]["lean_aim_up"]			= %CornerStndL_lean_aim_8;
	
	array[animType]["cover_left"]["stand"]["rifle"]["lean_idle"]			= array( %CornerStndL_lean_idle );

	array[animType]["cover_left"]["stand"]["rifle"]["alert_idle"]			= %corner_standL_alert_idle;
	array[animType]["cover_left"]["stand"]["rifle"]["alert_idle_twitch"]	= array(
																					%corner_standL_alert_twitch01,
																					%corner_standL_alert_twitch02,
																					%corner_standL_alert_twitch03,
																					%corner_standL_alert_twitch04,
																					%corner_standL_alert_twitch05,
																					%corner_standL_alert_twitch06,
																					%corner_standL_alert_twitch07
																				);
	array[animType]["cover_left"]["stand"]["rifle"]["alert_idle_flinch"]	= array( %corner_standL_flinch );

	array[animType]["cover_left"]["stand"]["rifle"]["alert_to_A"]			= array( %corner_standL_trans_alert_2_A, %corner_standL_trans_alert_2_A_v2, %corner_standL_trans_alert_2_A_v3 );
	array[animType]["cover_left"]["stand"]["rifle"]["alert_to_B"]			= array( %corner_standL_trans_alert_2_B, %corner_standL_trans_alert_2_B_v2 );
	array[animType]["cover_left"]["stand"]["rifle"]["A_to_alert"]			= array( %corner_standL_trans_A_2_alert, %corner_standL_trans_A_2_alert_v2 );
	array[animType]["cover_left"]["stand"]["rifle"]["A_to_alert_reload"]	= array();
	array[animType]["cover_left"]["stand"]["rifle"]["A_to_B"    ]			= array( %corner_standL_trans_A_2_B,     %corner_standL_trans_A_2_B_v2     );
	array[animType]["cover_left"]["stand"]["rifle"]["B_to_alert"]			= array( %corner_standL_trans_B_2_alert, %corner_standL_trans_B_2_alert_v2 );
	array[animType]["cover_left"]["stand"]["rifle"]["B_to_alert_reload"]	= array( %corner_standL_reload_B_2_alert );
 	array[animType]["cover_left"]["stand"]["rifle"]["B_to_A"    ]			= array( %corner_standL_trans_B_2_A,     %corner_standL_trans_B_2_A_v2     );
	array[animType]["cover_left"]["stand"]["rifle"]["lean_to_alert"]		= array( %CornerStndL_lean_2_alert );
	array[animType]["cover_left"]["stand"]["rifle"]["alert_to_lean"]		= array( %CornerStndL_alert_2_lean );
	
	// AI_TODO - Fix these animations
	//array[animType]["cover_left"]["stand"]["rifle"]["look"]					= %corner_standL_look;

	array[animType]["cover_left"]["stand"]["rifle"]["grenade_exposed"]		= %corner_standL_grenade_A;
	array[animType]["cover_left"]["stand"]["rifle"]["grenade_safe"]			= %corner_standL_grenade_B;
	array[animType]["cover_left"]["stand"]["rifle"]["grenade_throw"]		= %stand_grenade_throw;
	
	array[animType]["cover_left"]["stand"]["rifle"]["blind_fire"]			= array( %corner_standL_blindfire_v1, %corner_standL_blindfire_v2 );

	array[animType]["cover_left"]["stand"]["rifle"]["blind_fire_add_aim_up"]	= %ai_cornerstndl_blindfire_v2_aim8;
	array[animType]["cover_left"]["stand"]["rifle"]["blind_fire_add_aim_down"]	= %ai_cornerstndl_blindfire_v2_aim2;
	array[animType]["cover_left"]["stand"]["rifle"]["blind_fire_add_aim_left"]	= %ai_cornerstndl_blindfire_v2_aim4;
	array[animType]["cover_left"]["stand"]["rifle"]["blind_fire_add_aim_right"]	= %ai_cornerstndl_blindfire_v2_aim6;
	
	array[animType]["cover_left"]["stand"]["rifle"]["alert_to_look"]		= %corner_standL_alert_2_look;
	array[animType]["cover_left"]["stand"]["rifle"]["look_to_alert"]		= %corner_standL_look_2_alert;
	array[animType]["cover_left"]["stand"]["rifle"]["look_to_alert_fast"]	= %corner_standL_look_2_alert_fast_v1;
	array[animType]["cover_left"]["stand"]["rifle"]["look_idle"]			= %corner_standL_look_idle;
	array[animType]["cover_left"]["stand"]["rifle"]["stance_change"]		= %CornerCrL_stand_2_alert;

	array[animType]["cover_left"]["stand"]["rifle"]["weapon_switch"]		= %ai_stand_exposed_weaponswitch; 
	array[animType]["cover_left"]["stand"]["rifle"]["weapon_switch_cover"]	= %ai_corner_left_weaponswitch; 
		
	array[animType]["cover_left"]["stand"]["rifle"]["death_react"]			= array( %ai_exposed_backpedal );
	array[animType]["cover_left"]["stand"]["rifle"]["death_react_ik"]		= array( %ai_look_at_corner_stand_left_flinch );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Left Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_left"]["crouch"]["rifle"]["reload"]				= array( %CornerCrL_reloadA, %CornerCrL_reloadB );

	// cover-left specific
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_fire"]			= %CornerCrL_lean_auto;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_semi2"]			= %CornerCrL_lean_auto;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_semi3"]			= %CornerCrL_lean_auto;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_semi4"]			= %CornerCrL_lean_auto;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_semi5"]			= %CornerCrL_lean_auto;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_burst2"]			= %CornerCrL_lean_auto;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_burst3"]			= %CornerCrL_lean_auto;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_burst4"]			= %CornerCrL_lean_auto;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_burst5"]			= %CornerCrL_lean_auto;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_burst6"]			= %CornerCrL_lean_auto;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_single"]			= array( %CornerCrL_lean_fire );

	array[animType]["cover_left"]["crouch"]["rifle"]["lean_aim_down"]		= %ai_CornerCrL_lean_aim_2;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_aim_left"]		= %ai_CornerCrL_lean_aim_4;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_aim_straight"]	= %ai_CornerCrL_lean_aim_5;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_aim_right"]		= %ai_CornerCrL_lean_aim_6;
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_aim_up"]			= %ai_CornerCrL_lean_aim_8;
	
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_idle"]			= array( %CornerCrL_lean_idle );

	array[animType]["cover_left"]["crouch"]["rifle"]["over_aim_straight"]	= %covercrouch_aim5;
	array[animType]["cover_left"]["crouch"]["rifle"]["over_aim_up"]			= %covercrouch_aim2_add;
	array[animType]["cover_left"]["crouch"]["rifle"]["over_aim_down"]		= %covercrouch_aim4_add;
	array[animType]["cover_left"]["crouch"]["rifle"]["over_aim_left"]		= %covercrouch_aim6_add;
	array[animType]["cover_left"]["crouch"]["rifle"]["over_aim_right"]		= %covercrouch_aim8_add;

	array[animType]["cover_left"]["crouch"]["rifle"]["alert_idle"]			= %CornerCrL_alert_idle;
	array[animType]["cover_left"]["crouch"]["rifle"]["alert_idle_twitch"]	= array();
	array[animType]["cover_left"]["crouch"]["rifle"]["alert_idle_flinch"]	= array();

	array[animType]["cover_left"]["crouch"]["rifle"]["alert_to_A"]			= array( %CornerCrL_trans_alert_2_A );
	array[animType]["cover_left"]["crouch"]["rifle"]["alert_to_B"]			= array( %CornerCrL_trans_alert_2_B );
	array[animType]["cover_left"]["crouch"]["rifle"]["A_to_alert"]			= array( %CornerCrL_trans_A_2_alert );
	array[animType]["cover_left"]["crouch"]["rifle"]["A_to_alert_reload"]	= array();
	array[animType]["cover_left"]["crouch"]["rifle"]["A_to_B"    ]			= array( %CornerCrL_trans_A_2_B     );
	array[animType]["cover_left"]["crouch"]["rifle"]["B_to_alert"]			= array( %CornerCrL_trans_B_2_alert );
 	array[animType]["cover_left"]["crouch"]["rifle"]["B_to_alert_reload"]	= array();
	array[animType]["cover_left"]["crouch"]["rifle"]["B_to_A"    ]			= array( %CornerCrL_trans_B_2_A     );
	array[animType]["cover_left"]["crouch"]["rifle"]["lean_to_alert"]		= array( %CornerCrL_lean_2_alert );
	array[animType]["cover_left"]["crouch"]["rifle"]["alert_to_lean"]		= array( %ai_CornerCrL_alert_2_lean );
	array[animType]["cover_left"]["crouch"]["rifle"]["over_to_alert"]		= array( %CornerCrL_over_2_alert );
	array[animType]["cover_left"]["crouch"]["rifle"]["alert_to_over"]		= array( %CornerCrL_alert_2_over );

	array[animType]["cover_left"]["crouch"]["rifle"]["look"]				= %CornerCrL_look_fast;
//	array[animType]["cover_right"]["crouch"]["rifle"]["alert_to_look"]		= %CornerCrR_alert_2_look; // TODO
//	array[animType]["cover_right"]["crouch"]["rifle"]["look_to_alert"]		= %CornerCrR_look_2_alert; // TODO
//	array[animType]["cover_right"]["crouch"]["rifle"]["look_to_alert_fast"]	= %CornerCrR_look_2_alert_fast; // TODO
//	array[animType]["cover_right"]["crouch"]["rifle"]["look_idle"]			= %CornerCrR_look_idle; // TODO

	array[animType]["cover_left"]["crouch"]["rifle"]["grenade_safe"]		= %CornerCrL_grenadeA;
	array[animType]["cover_left"]["crouch"]["rifle"]["grenade_exposed"]		= %CornerCrL_grenadeB;
	array[animType]["cover_left"]["crouch"]["rifle"]["grenade_throw"]		= %crouch_grenade_throw;

	array[animType]["cover_left"]["crouch"]["rifle"]["blind_over"]			 	 = array( %ai_cornercrl_blindfire_over );
	array[animType]["cover_left"]["crouch"]["rifle"]["blind_over_add_aim_up"]	 = %ai_cornercrl_blindfire_over_aim8;
	array[animType]["cover_left"]["crouch"]["rifle"]["blind_over_add_aim_down"]	 = %ai_cornercrl_blindfire_over_aim2;
	array[animType]["cover_left"]["crouch"]["rifle"]["blind_over_add_aim_left"]	 = %ai_cornercrl_blindfire_over_aim4;
	array[animType]["cover_left"]["crouch"]["rifle"]["blind_over_add_aim_right"] = %ai_cornercrl_blindfire_over_aim6;
		
	array[animType]["cover_left"]["crouch"]["rifle"]["blind_fire"]			= array( %ai_cornercrl_blindfire );
	array[animType]["cover_left"]["crouch"]["rifle"]["blind_fire_add_aim_up"]	= %ai_cornercrl_blindfire_aim8;
	array[animType]["cover_left"]["crouch"]["rifle"]["blind_fire_add_aim_down"]	= %ai_cornercrl_blindfire_aim2;
	array[animType]["cover_left"]["crouch"]["rifle"]["blind_fire_add_aim_left"]	= %ai_cornercrl_blindfire_aim4;
	array[animType]["cover_left"]["crouch"]["rifle"]["blind_fire_add_aim_right"] = %ai_cornercrl_blindfire_aim6;
	
	array[animType]["cover_left"]["crouch"]["rifle"]["stance_change"]		= %CornerCrL_alert_2_stand;

	array[animType]["cover_left"]["crouch"]["rifle"]["weapon_switch"]		= %ai_crouch_exposed_weaponswitch; 
	array[animType]["cover_left"]["crouch"]["rifle"]["weapon_switch_cover"]	= %ai_crouch_corner_left_weaponswitch;	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Left Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_right"]["stand"]["rifle"]["reload"]				= array( %corner_standR_reload_v1 );

	// cover-right specific

	// ALEXP_TODO: make these lean anims work
	array[animType]["cover_right"]["stand"]["rifle"]["lean_fire"]			= %CornerStndR_lean_auto;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_semi2"]			= %CornerStndR_lean_auto;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_semi3"]			= %CornerStndR_lean_auto;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_semi4"]			= %CornerStndR_lean_auto;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_semi5"]			= %CornerStndR_lean_auto;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_burst2"]			= %CornerStndR_lean_auto;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_burst3"]			= %CornerStndR_lean_auto;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_burst4"]			= %CornerStndR_lean_auto;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_burst5"]			= %CornerStndR_lean_auto;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_burst6"]			= %CornerStndR_lean_auto;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_single"]			= array( %CornerStndR_lean_fire );
	array[animType]["cover_right"]["stand"]["rifle"]["lean_rechamber"]		= %CornerStndR_lean_rechamber;

	array[animType]["cover_right"]["stand"]["rifle"]["lean_aim_down"]		= %CornerStndR_lean_aim_2;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_aim_left"]		= %CornerStndR_lean_aim_4;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_aim_straight"]	= %CornerStndR_lean_aim_5;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_aim_right"]		= %CornerStndR_lean_aim_6;
	array[animType]["cover_right"]["stand"]["rifle"]["lean_aim_up"]			= %CornerStndR_lean_aim_8;
	
	array[animType]["cover_right"]["stand"]["rifle"]["lean_idle"]			= array( %CornerStndR_lean_idle );

	array[animType]["cover_right"]["stand"]["rifle"]["alert_idle"]			= %corner_standR_alert_idle;
	array[animType]["cover_right"]["stand"]["rifle"]["alert_idle_twitch"]	= array(
																					%corner_standR_alert_twitch01,
																					%corner_standR_alert_twitch02,
																					%corner_standR_alert_twitch03,
																					%corner_standR_alert_twitch04,
																					%corner_standR_alert_twitch05,
																					%corner_standR_alert_twitch06,
																					%corner_standR_alert_twitch07
																				);
	array[animType]["cover_right"]["stand"]["rifle"]["alert_idle_flinch"]	= array( %corner_standR_flinch, %corner_standR_flinchB );

	array[animType]["cover_right"]["stand"]["rifle"]["alert_to_A"]			= array( %corner_standR_trans_alert_2_A, %corner_standR_trans_alert_2_A_v2 );
	array[animType]["cover_right"]["stand"]["rifle"]["alert_to_B"]			= array( %corner_standR_trans_alert_2_B, %corner_standR_trans_alert_2_B_v2, %corner_standR_trans_alert_2_B_v3 );
	array[animType]["cover_right"]["stand"]["rifle"]["A_to_alert"]			= array( %corner_standR_trans_A_2_alert, %corner_standR_trans_A_2_alert_v2 );
	array[animType]["cover_right"]["stand"]["rifle"]["A_to_alert_reload"]	= array();
	array[animType]["cover_right"]["stand"]["rifle"]["A_to_B"    ]			= array( %corner_standR_trans_A_2_B    , %corner_standR_trans_A_2_B_v2     );
	array[animType]["cover_right"]["stand"]["rifle"]["B_to_alert"]			= array( %corner_standR_trans_B_2_alert, %corner_standR_trans_B_2_alert_v2, %corner_standR_trans_B_2_alert_v3 );
	array[animType]["cover_right"]["stand"]["rifle"]["B_to_alert_reload"]	= array( %corner_standR_reload_B_2_alert );
 	array[animType]["cover_right"]["stand"]["rifle"]["B_to_A"    ]			= array( %corner_standR_trans_B_2_A );
	array[animType]["cover_right"]["stand"]["rifle"]["lean_to_alert"]		= array( %CornerStndR_lean_2_alert );
	array[animType]["cover_right"]["stand"]["rifle"]["alert_to_lean"]		= array( %CornerStndR_alert_2_lean );
	
	// AI_TODO - Fix these animations
	//array[animType]["cover_right"]["stand"]["rifle"]["look"]				= %corner_standR_look;

	array[animType]["cover_right"]["stand"]["rifle"]["grenade_exposed"]		= %corner_standR_grenade_A;
	array[animType]["cover_right"]["stand"]["rifle"]["grenade_safe"]		= %corner_standR_grenade_B;
	array[animType]["cover_right"]["stand"]["rifle"]["grenade_throw"]		= %stand_grenade_throw;
	
	array[animType]["cover_right"]["stand"]["rifle"]["blind_fire"]			= array( %corner_standR_blindfire_v1, %corner_standR_blindfire_v2 );	

	array[animType]["cover_right"]["stand"]["rifle"]["blind_fire_add_aim_up"]	= %ai_cornerstndr_blindfire_v2_aim8;
	array[animType]["cover_right"]["stand"]["rifle"]["blind_fire_add_aim_down"]	= %ai_cornerstndr_blindfire_v2_aim2;
	array[animType]["cover_right"]["stand"]["rifle"]["blind_fire_add_aim_left"]	= %ai_cornerstndr_blindfire_v2_aim4;
	array[animType]["cover_right"]["stand"]["rifle"]["blind_fire_add_aim_right"]	= %ai_cornerstndr_blindfire_v2_aim6;
		
	array[animType]["cover_right"]["stand"]["rifle"]["alert_to_look"]		= %corner_standR_alert_2_look;
	array[animType]["cover_right"]["stand"]["rifle"]["look_to_alert"]		= %corner_standR_look_2_alert;
	array[animType]["cover_right"]["stand"]["rifle"]["look_to_alert_fast"]	= %corner_standR_look_2_alert_fast;
	array[animType]["cover_right"]["stand"]["rifle"]["look_idle"]			= %corner_standR_look_idle;
	array[animType]["cover_right"]["stand"]["rifle"]["stance_change"]		= %CornerCrR_stand_2_alert;

	array[animType]["cover_right"]["stand"]["rifle"]["weapon_switch"]		= %ai_stand_exposed_weaponswitch; 
	array[animType]["cover_right"]["stand"]["rifle"]["weapon_switch_cover"]	= %ai_corner_right_weaponswitch; 
		
	array[animType]["cover_right"]["stand"]["rifle"]["death_react"]			= array( %ai_exposed_backpedal );
	array[animType]["cover_right"]["stand"]["rifle"]["death_react_ik"]		= array( %ai_look_at_corner_stand_right_flinch );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Right Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_right"]["crouch"]["rifle"]["reload"]				= array( %CornerCrR_reloadA, %CornerCrR_reloadB );

	// cover-right specific
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_fire"]			= %CornerCrR_lean_auto;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_semi2"]			= %CornerCrR_lean_auto;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_semi3"]			= %CornerCrR_lean_auto;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_semi4"]			= %CornerCrR_lean_auto;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_semi5"]			= %CornerCrR_lean_auto;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_burst2"]		= %CornerCrR_lean_auto;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_burst3"]		= %CornerCrR_lean_auto;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_burst4"]		= %CornerCrR_lean_auto;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_burst5"]		= %CornerCrR_lean_auto;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_burst6"]		= %CornerCrR_lean_auto;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_single"]		= array( %CornerCrR_lean_fire );

	array[animType]["cover_right"]["crouch"]["rifle"]["lean_aim_down"]		= %ai_CornerCrR_lean_aim_2;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_aim_left"]		= %ai_CornerCrR_lean_aim_4;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_aim_straight"]	= %ai_CornerCrR_lean_aim_5;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_aim_right"]		= %ai_CornerCrR_lean_aim_6;
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_aim_up"]		= %ai_CornerCrR_lean_aim_8;
	
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_idle"]			= array( %CornerCrR_lean_idle );

	array[animType]["cover_right"]["crouch"]["rifle"]["over_aim_straight"]	= %covercrouch_aim5;
	array[animType]["cover_right"]["crouch"]["rifle"]["over_aim_up"]		= %covercrouch_aim2_add;
	array[animType]["cover_right"]["crouch"]["rifle"]["over_aim_down"]		= %covercrouch_aim4_add;
	array[animType]["cover_right"]["crouch"]["rifle"]["over_aim_left"]		= %covercrouch_aim6_add;
	array[animType]["cover_right"]["crouch"]["rifle"]["over_aim_right"]		= %covercrouch_aim8_add;

	array[animType]["cover_right"]["crouch"]["rifle"]["alert_idle"]			= %CornerCrR_alert_idle;
	array[animType]["cover_right"]["crouch"]["rifle"]["alert_idle_twitch"]	= array(
																					%CornerCrR_alert_twitch_v1,
																					%CornerCrR_alert_twitch_v2,
																					%CornerCrR_alert_twitch_v3
																				);
	array[animType]["cover_right"]["crouch"]["rifle"]["alert_idle_flinch"]	= array();

	array[animType]["cover_right"]["crouch"]["rifle"]["alert_to_A"]			= array( %CornerCrR_trans_alert_2_A );
	array[animType]["cover_right"]["crouch"]["rifle"]["alert_to_B"]			= array( %CornerCrR_trans_alert_2_B );
	array[animType]["cover_right"]["crouch"]["rifle"]["A_to_alert"]			= array( %CornerCrR_trans_A_2_alert );
	array[animType]["cover_right"]["crouch"]["rifle"]["A_to_alert_reload"]	= array();
	array[animType]["cover_right"]["crouch"]["rifle"]["A_to_B"    ]			= array( %CornerCrR_trans_A_2_B     );
	array[animType]["cover_right"]["crouch"]["rifle"]["B_to_alert"]			= array( %CornerCrR_trans_B_2_alert );
 	array[animType]["cover_right"]["crouch"]["rifle"]["B_to_alert_reload"]	= array( %CornerCrR_reload_B_2_alert );
	array[animType]["cover_right"]["crouch"]["rifle"]["B_to_A"    ]			= array( %CornerCrR_trans_B_2_A     );
	array[animType]["cover_right"]["crouch"]["rifle"]["lean_to_alert"]		= array( %CornerCrR_lean_2_alert );
	array[animType]["cover_right"]["crouch"]["rifle"]["alert_to_lean"]		= array( %ai_CornerCrR_alert_2_lean );
	array[animType]["cover_right"]["crouch"]["rifle"]["over_to_alert"]		= array( %CornerCrR_over_2_alert );
	array[animType]["cover_right"]["crouch"]["rifle"]["alert_to_over"]		= array( %CornerCrR_alert_2_over );

	array[animType]["cover_right"]["crouch"]["rifle"]["alert_to_look"]		= %CornerCrR_alert_2_look;
	array[animType]["cover_right"]["crouch"]["rifle"]["look_to_alert"]		= %CornerCrR_look_2_alert;
	array[animType]["cover_right"]["crouch"]["rifle"]["look_to_alert_fast"]	= %CornerCrR_look_2_alert_fast; // there's a v2 we could use for this also if we want
	array[animType]["cover_right"]["crouch"]["rifle"]["look_idle"]			= %CornerCrR_look_idle;

	array[animType]["cover_right"]["crouch"]["rifle"]["grenade_safe"]		= %CornerCrR_grenadeA;
	array[animType]["cover_right"]["crouch"]["rifle"]["grenade_exposed"]	= %CornerCrR_grenadeA; // TODO: need a unique animation for this; use the exposed throw because not having it limits the options of the AI too much
	array[animType]["cover_right"]["crouch"]["rifle"]["grenade_throw"]		= %crouch_grenade_throw;
	
	array[animType]["cover_right"]["crouch"]["rifle"]["blind_over"]		 		    = array( %ai_cornercrr_blindfire_over );
	array[animType]["cover_right"]["crouch"]["rifle"]["blind_over_add_aim_up"]	    = %ai_cornercrr_blindfire_over_aim8;
	array[animType]["cover_right"]["crouch"]["rifle"]["blind_over_add_aim_down"]    = %ai_cornercrr_blindfire_over_aim2;
	array[animType]["cover_right"]["crouch"]["rifle"]["blind_over_add_aim_left"]    = %ai_cornercrr_blindfire_over_aim4;
	array[animType]["cover_right"]["crouch"]["rifle"]["blind_over_add_aim_right"]   = %ai_cornercrr_blindfire_over_aim6;
		
	array[animType]["cover_right"]["crouch"]["rifle"]["blind_fire"]		 		    = array( %ai_cornercrr_blindfire );
	array[animType]["cover_right"]["crouch"]["rifle"]["blind_fire_add_aim_up"]	    = %ai_cornercrr_blindfire_aim8;
	array[animType]["cover_right"]["crouch"]["rifle"]["blind_fire_add_aim_down"]    = %ai_cornercrr_blindfire_aim2;
	array[animType]["cover_right"]["crouch"]["rifle"]["blind_fire_add_aim_left"]    = %ai_cornercrr_blindfire_aim4;
	array[animType]["cover_right"]["crouch"]["rifle"]["blind_fire_add_aim_right"]   = %ai_cornercrr_blindfire_aim6;
				
	array[animType]["cover_right"]["crouch"]["rifle"]["stance_change"]		= %CornerCrR_alert_2_stand;

	array[animType]["cover_right"]["crouch"]["rifle"]["weapon_switch"]			= %ai_crouch_exposed_weaponswitch; 
	array[animType]["cover_right"]["crouch"]["rifle"]["weapon_switch_cover"]	= %ai_crouch_corner_right_weaponswitch;	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Right Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	array[animType]["cover_stand"]["stand"]["rifle"]["hide_idle"]			= %coverstand_hide_idle;
	array[animType]["cover_stand"]["stand"]["rifle"]["hide_idle_twitch"]	= array(
																					%coverstand_hide_idle_twitch01,
																					%coverstand_hide_idle_twitch02,
																					%coverstand_hide_idle_twitch03,
																					%coverstand_hide_idle_twitch04,
																					%coverstand_hide_idle_twitch05
																				  );

	array[animType]["cover_stand"]["stand"]["rifle"]["hide_idle_flinch"]	= array(
																					%coverstand_react01,
																					%coverstand_react02,
																					%coverstand_react03,
																					%coverstand_react04
																				  );

	array[animType]["cover_stand"]["stand"]["rifle"]["hide_2_stand"]		= %coverstand_hide_2_aim;
	array[animType]["cover_stand"]["stand"]["rifle"]["stand_2_hide"]		= %coverstand_aim_2_hide;
	array[animType]["cover_stand"]["stand"]["rifle"]["hide_2_over"]			= %ai_coverstand_2_coverstandaim;
	array[animType]["cover_stand"]["stand"]["rifle"]["over_2_hide"]			= %ai_coverstandaim_2_coverstand;

	array[animType]["cover_stand"]["stand"]["rifle"]["stand_aim"]			= %exposed_aim_5;
	array[animType]["cover_stand"]["stand"]["rifle"]["crouch_aim"]			= %covercrouch_aim5;
	array[animType]["cover_stand"]["stand"]["rifle"]["lean_aim"]			= %exposed_aim_5;
	array[animType]["cover_stand"]["stand"]["rifle"]["over_aim"]			= %ai_coverstandaim_aim5;

	array[animType]["cover_stand"]["stand"]["rifle"]["over_add_aim_up"]		= %ai_coverstandaim_aim8_add;
	array[animType]["cover_stand"]["stand"]["rifle"]["over_add_aim_down"]	= %ai_coverstandaim_aim2_add;
	array[animType]["cover_stand"]["stand"]["rifle"]["over_add_aim_left"]	= %ai_coverstandaim_aim4_add;
	array[animType]["cover_stand"]["stand"]["rifle"]["over_add_aim_right"]	= %ai_coverstandaim_aim6_add;

	// AI_TODO: these shouldn't be overriding the exposed shoot anims when the AI steps out.
	array[animType]["cover_stand"]["stand"]["rifle"]["fire"]				= %ai_coverstandaim_fire;
	array[animType]["cover_stand"]["stand"]["rifle"]["single"]				= array( %ai_coverstandaim_fire );
	array[animType]["cover_stand"]["stand"]["rifle"]["burst2"]				= %ai_coverstandaim_autofire; // ( will be stopped after second bullet)
	array[animType]["cover_stand"]["stand"]["rifle"]["burst3"]				= %ai_coverstandaim_autofire;
	array[animType]["cover_stand"]["stand"]["rifle"]["burst4"]				= %ai_coverstandaim_autofire;
	array[animType]["cover_stand"]["stand"]["rifle"]["burst5"]				= %ai_coverstandaim_autofire;
	array[animType]["cover_stand"]["stand"]["rifle"]["burst6"]				= %ai_coverstandaim_autofire;
	array[animType]["cover_stand"]["stand"]["rifle"]["semi2"]				= %ai_coverstandaim_autofire;
	array[animType]["cover_stand"]["stand"]["rifle"]["semi3"]				= %ai_coverstandaim_autofire;
	array[animType]["cover_stand"]["stand"]["rifle"]["semi4"]				= %ai_coverstandaim_autofire;
	array[animType]["cover_stand"]["stand"]["rifle"]["semi5"]				= %ai_coverstandaim_autofire;

	array[animType]["cover_stand"]["stand"]["rifle"]["blind_fire"]			= array( %coverstand_blindfire_1, %coverstand_blindfire_2 /*, %coverstand_blindfire_3*/ ); // #3 looks silly

	array[animType]["cover_stand"]["stand"]["rifle"]["blind_fire_add_aim_up"]	= %ai_coverstand_blindfire_2_aim8;
	array[animType]["cover_stand"]["stand"]["rifle"]["blind_fire_add_aim_down"]	= %ai_coverstand_blindfire_2_aim2;
	array[animType]["cover_stand"]["stand"]["rifle"]["blind_fire_add_aim_left"]	= %ai_coverstand_blindfire_2_aim4;
	array[animType]["cover_stand"]["stand"]["rifle"]["blind_fire_add_aim_right"]	= %ai_coverstand_blindfire_2_aim6;

	array[animType]["cover_stand"]["stand"]["rifle"]["look"]				= array( %coverstand_look_quick, %coverstand_look_quick_v2 );
	array[animType]["cover_stand"]["stand"]["rifle"]["hide_to_look"]		= %coverstand_look_moveup;
	array[animType]["cover_stand"]["stand"]["rifle"]["look_idle"]			= %coverstand_look_idle;
	array[animType]["cover_stand"]["stand"]["rifle"]["look_to_hide"]		= %coverstand_look_movedown;
	array[animType]["cover_stand"]["stand"]["rifle"]["look_to_hide_fast"]	= %coverstand_look_movedown_fast;

	array[animType]["cover_stand"]["stand"]["rifle"]["grenade_safe"]		= array( %coverstand_grenadeA, %coverstand_grenadeB );
	array[animType]["cover_stand"]["stand"]["rifle"]["grenade_exposed"]		= array( %coverstand_grenadeA, %coverstand_grenadeB );
	array[animType]["cover_stand"]["stand"]["rifle"]["grenade_throw"]		= %stand_grenade_throw;

	array[animType]["cover_stand"]["stand"]["rifle"]["reload"]				= %coverstand_reloadA;

	array[animType]["cover_stand"]["stand"]["rifle"]["weapon_switch"]			= %ai_stand_exposed_weaponswitch; 
	array[animType]["cover_stand"]["stand"]["rifle"]["weapon_switch_cover"]		= %ai_stand_cover_hide_weaponswitch;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Stand (Crouch) Actions (same as cover crouch)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	array[animType]["cover_stand"]["crouch"]["rifle"]["hide_idle"]			= %covercrouch_hide_idle;
	array[animType]["cover_stand"]["crouch"]["rifle"]["hide_idle_twitch"]	= array(
																					%covercrouch_twitch_1,
																					%covercrouch_twitch_2,
																					%covercrouch_twitch_3,
																					%covercrouch_twitch_4																					
																					//%covercrouch_twitch_5 // excluding #5 because it's a wave to someone behind him, and in idle twitches we don't know if that makes sense at the time
																				  );

	array[animType]["cover_stand"]["crouch"]["rifle"]["hide_idle_flinch"]	= array();

	array[animType]["cover_stand"]["crouch"]["rifle"]["hide_2_crouch"]		= %covercrouch_hide_2_aim;
	array[animType]["cover_stand"]["crouch"]["rifle"]["hide_2_stand"]		= %covercrouch_hide_2_stand;
	array[animType]["cover_stand"]["crouch"]["rifle"]["hide_2_lean"]		= %covercrouch_hide_2_lean;
	array[animType]["cover_stand"]["crouch"]["rifle"]["hide_2_left"]		= %ai_covercrouch_hide_2_left;
	array[animType]["cover_stand"]["crouch"]["rifle"]["hide_2_right"]		= %ai_covercrouch_hide_2_right;

	array[animType]["cover_stand"]["crouch"]["rifle"]["crouch_2_hide"]		= %covercrouch_aim_2_hide;
	array[animType]["cover_stand"]["crouch"]["rifle"]["stand_2_hide"]		= %covercrouch_stand_2_hide;
	array[animType]["cover_stand"]["crouch"]["rifle"]["lean_2_hide"]		= %covercrouch_lean_2_hide;
	array[animType]["cover_stand"]["crouch"]["rifle"]["left_2_hide"]		= %ai_covercrouch_left_2_hide;
	array[animType]["cover_stand"]["crouch"]["rifle"]["right_2_hide"]		= %ai_covercrouch_right_2_hide;

	array[animType]["cover_stand"]["crouch"]["rifle"]["stand_aim"]			= %exposed_aim_5;
	array[animType]["cover_stand"]["crouch"]["rifle"]["crouch_aim"]			= %covercrouch_aim5;
	array[animType]["cover_stand"]["crouch"]["rifle"]["lean_aim"]			= %exposed_aim_5;

	array[animType]["cover_stand"]["crouch"]["rifle"]["add_aim_up"]			= %covercrouch_aim2_add;
	array[animType]["cover_stand"]["crouch"]["rifle"]["add_aim_down"]		= %covercrouch_aim4_add;
	array[animType]["cover_stand"]["crouch"]["rifle"]["add_aim_left"]		= %covercrouch_aim6_add;
	array[animType]["cover_stand"]["crouch"]["rifle"]["add_aim_right"]		= %covercrouch_aim8_add;

	array[animType]["cover_stand"]["crouch"]["rifle"]["blind_fire"]			= array( %covercrouch_blindfire_1, %covercrouch_blindfire_2, %covercrouch_blindfire_3, %covercrouch_blindfire_4 );

	array[animType]["cover_stand"]["crouch"]["rifle"]["look"]				= array( %covercrouch_hide_look );

	array[animType]["cover_stand"]["crouch"]["rifle"]["grenade_safe"]		= array( %covercrouch_grenadeA, %covercrouch_grenadeB );
	array[animType]["cover_stand"]["crouch"]["rifle"]["grenade_exposed"]	= array( %covercrouch_grenadeA, %covercrouch_grenadeB );
	array[animType]["cover_stand"]["crouch"]["rifle"]["grenade_throw"]		= %crouch_grenade_throw;

	array[animType]["cover_stand"]["crouch"]["rifle"]["reload"]				= %covercrouch_reload_hide;

	array[animType]["cover_stand"]["crouch"]["rifle"]["weapon_switch"]			= %ai_crouch_exposed_weaponswitch; 
	array[animType]["cover_stand"]["crouch"]["rifle"]["weapon_switch_cover"]	= %ai_crouch_cover_hide_weaponswitch;

	array[animType]["cover_stand"]["crouch"]["rifle"]["rechamber"]			= %covercrouch_rechamber;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Stand (Crouch) Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	array[animType]["cover_crouch"]["crouch"]["rifle"]["hide_idle"]			= %covercrouch_hide_idle;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["hide_idle_twitch"]	= array(
																					%covercrouch_twitch_1,
																					%covercrouch_twitch_2,
																					%covercrouch_twitch_3,
																					%covercrouch_twitch_4																					
																					//%covercrouch_twitch_5 // excluding #5 because it's a wave to someone behind him, and in idle twitches we don't know if that makes sense at the time
																				  );

	array[animType]["cover_crouch"]["crouch"]["rifle"]["hide_idle_flinch"]	= array();

	array[animType]["cover_crouch"]["crouch"]["rifle"]["exposed_idle"]				= array( %covercrouch_hide_idlea, %covercrouch_hide_idleb );
	array[animType]["cover_crouch"]["crouch"]["rifle"]["exposed_idle_noncombat"]	= array( %covercrouch_hide_idlea, %covercrouch_hide_idleb );

	array[animType]["cover_crouch"]["crouch"]["rifle"]["fire"]				= %covercrouch_hide_burst6;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["single"]			= array( %covercrouch_hide_burst1 );
	array[animType]["cover_crouch"]["crouch"]["rifle"]["burst2"]			= %covercrouch_hide_semiauto_burst2; // ( will be stopped after second bullet)
	array[animType]["cover_crouch"]["crouch"]["rifle"]["burst3"]			= %covercrouch_hide_burst3;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["burst4"]			= %covercrouch_hide_burst4;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["burst5"]			= %covercrouch_hide_burst5;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["burst6"]			= %covercrouch_hide_burst6;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["semi2"]				= %covercrouch_hide_semiauto_burst2;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["semi3"]				= %covercrouch_hide_burst3;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["semi4"]				= %covercrouch_hide_burst4;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["semi5"]				= %covercrouch_hide_burst5;

	array[animType]["cover_crouch"]["crouch"]["rifle"]["hide_2_crouch"]		= %covercrouch_hide_2_aim;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["hide_2_stand"]		= %covercrouch_hide_2_stand;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["hide_2_lean"]		= %covercrouch_hide_2_lean;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["hide_2_left"]		= %ai_covercrouch_hide_2_left;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["hide_2_right"]		= %ai_covercrouch_hide_2_right;

	array[animType]["cover_crouch"]["crouch"]["rifle"]["crouch_2_hide"]		= %covercrouch_aim_2_hide;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["stand_2_hide"]		= %covercrouch_stand_2_hide;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["lean_2_hide"]		= %covercrouch_lean_2_hide;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["left_2_hide"]		= %ai_covercrouch_left_2_hide;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["right_2_hide"]		= %ai_covercrouch_right_2_hide;

	array[animType]["cover_crouch"]["crouch"]["rifle"]["stand_aim"]			= %exposed_aim_5;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["crouch_aim"]		= %covercrouch_aim5;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["lean_aim"]			= %exposed_aim_5;

	array[animType]["cover_crouch"]["crouch"]["rifle"]["add_aim_up"]		= %covercrouch_aim2_add;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["add_aim_down"]		= %covercrouch_aim4_add;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["add_aim_left"]		= %covercrouch_aim6_add;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["add_aim_right"]		= %covercrouch_aim8_add;

	array[animType]["cover_crouch"]["crouch"]["rifle"]["blind_fire"]				= array( %covercrouch_blindfire_1, %covercrouch_blindfire_2 );
	array[animType]["cover_crouch"]["crouch"]["rifle"]["blind_fire_add_aim_up"]		= %ai_covercrouch_blindfire_1_aim8;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["blind_fire_add_aim_down"]	= %ai_covercrouch_blindfire_1_aim2;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["blind_fire_add_aim_left"]	= %ai_covercrouch_blindfire_1_aim4;
	array[animType]["cover_crouch"]["crouch"]["rifle"]["blind_fire_add_aim_right"]	= %ai_covercrouch_blindfire_1_aim6;
		
	array[animType]["cover_crouch"]["crouch"]["rifle"]["look"]				= array( %covercrouch_hide_look );

	array[animType]["cover_crouch"]["crouch"]["rifle"]["grenade_safe"]		= array( %covercrouch_grenadeA, %covercrouch_grenadeB );
	array[animType]["cover_crouch"]["crouch"]["rifle"]["grenade_exposed"]	= array( %covercrouch_grenadeA, %covercrouch_grenadeB );
	array[animType]["cover_crouch"]["crouch"]["rifle"]["grenade_throw"]		= %crouch_grenade_throw;

	array[animType]["cover_crouch"]["crouch"]["rifle"]["reload"]			= %covercrouch_reload_hide;

	array[animType]["cover_crouch"]["crouch"]["rifle"]["weapon_switch"]			= %ai_crouch_exposed_weaponswitch; 
	array[animType]["cover_crouch"]["crouch"]["rifle"]["weapon_switch_cover"]	= %ai_crouch_cover_hide_weaponswitch;

	array[animType]["cover_crouch"]["crouch"]["rifle"]["rechamber"]			= %covercrouch_rechamber;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Crouch (Crouch) Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Crouch (Stand) Actions (same as cover stand)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_crouch"]["stand"]["rifle"]["hide_idle"]			= %coverstand_hide_idle;
	array[animType]["cover_crouch"]["stand"]["rifle"]["hide_idle_twitch"]	= array(
																					%coverstand_hide_idle_twitch01,
																					%coverstand_hide_idle_twitch02,
																					%coverstand_hide_idle_twitch03,
																					%coverstand_hide_idle_twitch04,
																					%coverstand_hide_idle_twitch05
																				  );

	array[animType]["cover_crouch"]["stand"]["rifle"]["hide_idle_flinch"]	= array(
																					%coverstand_react01,
																					%coverstand_react02,
																					%coverstand_react03,
																					%coverstand_react04
																				  );

	array[animType]["cover_crouch"]["stand"]["rifle"]["hide_2_crouch"]		= %covercrouch_hide_2_aim;
	array[animType]["cover_crouch"]["stand"]["rifle"]["hide_2_stand"]		= %coverstand_hide_2_aim;
	array[animType]["cover_crouch"]["stand"]["rifle"]["hide_2_lean"]		= %covercrouch_hide_2_lean;

	array[animType]["cover_crouch"]["stand"]["rifle"]["crouch_2_hide"]		= %covercrouch_aim_2_hide;
	array[animType]["cover_crouch"]["stand"]["rifle"]["stand_2_hide"]		= %covercrouch_stand_2_hide;
	array[animType]["cover_crouch"]["stand"]["rifle"]["lean_2_hide"]		= %covercrouch_lean_2_hide;

	array[animType]["cover_crouch"]["stand"]["rifle"]["stand_aim"]			= %exposed_aim_5;
	array[animType]["cover_crouch"]["stand"]["rifle"]["crouch_aim"]			= %covercrouch_aim5;
	array[animType]["cover_crouch"]["stand"]["rifle"]["lean_aim"]			= %exposed_aim_5;

	array[animType]["cover_crouch"]["stand"]["rifle"]["blind_fire"]			= array( %coverstand_blindfire_1, %coverstand_blindfire_2 /*, %coverstand_blindfire_3*/ ); // #3 looks silly

	array[animType]["cover_crouch"]["stand"]["rifle"]["look"]				= array( %coverstand_look_quick, %coverstand_look_quick_v2 );
	array[animType]["cover_crouch"]["stand"]["rifle"]["hide_to_look"]		= %coverstand_look_moveup;
	array[animType]["cover_crouch"]["stand"]["rifle"]["look_idle"]			= %coverstand_look_idle;
	array[animType]["cover_crouch"]["stand"]["rifle"]["look_to_hide"]		= %coverstand_look_movedown;
	array[animType]["cover_crouch"]["stand"]["rifle"]["look_to_hide_fast"]	= %coverstand_look_movedown_fast;

	array[animType]["cover_crouch"]["stand"]["rifle"]["grenade_safe"]		= array( %coverstand_grenadeA, %coverstand_grenadeB );
	array[animType]["cover_crouch"]["stand"]["rifle"]["grenade_exposed"]	= array( %coverstand_grenadeA, %coverstand_grenadeB );
	array[animType]["cover_crouch"]["stand"]["rifle"]["grenade_throw"]		= %stand_grenade_throw;

	array[animType]["cover_crouch"]["stand"]["rifle"]["reload"]				= %coverstand_reloadA;

	array[animType]["cover_crouch"]["stand"]["rifle"]["weapon_switch"]		= %ai_stand_exposed_weaponswitch; 
	array[animType]["cover_crouch"]["stand"]["rifle"]["weapon_switch_cover"]= %ai_stand_cover_hide_weaponswitch;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Crouch (Stand) Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Prone Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	array[animType]["cover_prone"]["prone"]["rifle"]["straight_level"]		= %prone_aim_5;
	
	array[animType]["cover_prone"]["prone"]["rifle"]["fire"]				= %prone_fire_1;
	array[animType]["cover_prone"]["prone"]["rifle"]["semi2"]				= %prone_fire_burst;
	array[animType]["cover_prone"]["prone"]["rifle"]["semi3"]				= %prone_fire_burst;
	array[animType]["cover_prone"]["prone"]["rifle"]["semi4"]				= %prone_fire_burst;
	array[animType]["cover_prone"]["prone"]["rifle"]["semi5"]				= %prone_fire_burst;

	array[animType]["cover_prone"]["prone"]["rifle"]["single"]				= array( %prone_fire_1 );

	array[animType]["cover_prone"]["prone"]["rifle"]["burst2"]				= %prone_fire_burst; // (will be limited to 2 shots)
	array[animType]["cover_prone"]["prone"]["rifle"]["burst3"]				= %prone_fire_burst;
	array[animType]["cover_prone"]["prone"]["rifle"]["burst4"]				= %prone_fire_burst;
	array[animType]["cover_prone"]["prone"]["rifle"]["burst5"]				= %prone_fire_burst;
	array[animType]["cover_prone"]["prone"]["rifle"]["burst6"]				= %prone_fire_burst;
	
	array[animType]["cover_prone"]["prone"]["rifle"]["reload"]				= %prone_reload;

	array[animType]["cover_prone"]["prone"]["rifle"]["straight_level"]		= %prone_aim_5;
	array[animType]["cover_prone"]["prone"]["rifle"]["add_aim_up"]			= %prone_aim_8_add;
	array[animType]["cover_prone"]["prone"]["rifle"]["add_aim_down"]		= %prone_aim_2_add;
	array[animType]["cover_prone"]["prone"]["rifle"]["add_aim_left"]		= %prone_aim_4_add;
	array[animType]["cover_prone"]["prone"]["rifle"]["add_aim_right"]		= %prone_aim_6_add;  
	
	array[animType]["cover_prone"]["prone"]["rifle"]["look"]				= array( %prone_twitch_look, %prone_twitch_lookfast, %prone_twitch_lookup );
							
	array[animType]["cover_prone"]["prone"]["rifle"]["grenade_safe"]		= array( %prone_grenade_A, %prone_grenade_A );
	array[animType]["cover_prone"]["prone"]["rifle"]["grenade_exposed"]		= array( %prone_grenade_A, %prone_grenade_A );
							
	array[animType]["cover_prone"]["prone"]["rifle"]["prone_idle"]			= array( %prone_idle );
		
	array[animType]["cover_prone"]["prone"]["rifle"]["hide_to_look"]		= %coverstand_look_moveup;
	array[animType]["cover_prone"]["prone"]["rifle"]["look_idle"]			= %coverstand_look_idle;
	array[animType]["cover_prone"]["prone"]["rifle"]["look_to_hide"]		= %coverstand_look_movedown;
	array[animType]["cover_prone"]["prone"]["rifle"]["look_to_hide_fast"]	= %coverstand_look_movedown_fast;
	
	array[animType]["cover_prone"]["stand"]["rifle"]["stand_2_prone"]		= %stand_2_prone_nodelta;
	array[animType]["cover_prone"]["crouch"]["rifle"]["crouch_2_prone"]		= %crouch_2_prone;
	array[animType]["cover_prone"]["prone"]["rifle"]["prone_2_stand"]		= %prone_2_stand_nodelta;
	array[animType]["cover_prone"]["prone"]["rifle"]["prone_2_crouch"]		= %prone_2_crouch;

	array[animType]["cover_prone"]["stand"]["rifle"]["stand_2_prone_firing"]	= %stand_2_prone_firing;
	array[animType]["cover_prone"]["crouch"]["rifle"]["crouch_2_prone_firing"]	= %crouch_2_prone_firing;
	array[animType]["cover_prone"]["prone"]["rifle"]["prone_2_stand_firing"]	= %prone_2_stand_firing;
	array[animType]["cover_prone"]["prone"]["rifle"]["prone_2_crouch_firing"]	= %prone_2_crouch_firing;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Prone Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Transitions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// these should travel 83 units (door width is 56, plus 16 offset on both sides for the cover nodes)

//	array[animType]["cover_left"]["prone"]["rifle"]["trans1"]					= %ai_corner_r_2_crouch_corner_r;			// stand to crouch
//	array[animType]["cover_left"]["prone"]["rifle"]["trans2"]					= %ai_corner_r_2_crouch_corner_l;			// doorway stand right to crouch left
//	array[animType]["cover_left"]["prone"]["rifle"]["trans6"]					= %ai_corner_r_2_corner_l;					// doorway stand right to stand left
//
//	array[animType]["cover_left"]["prone"]["rifle"]["trans7"]					= %ai_corner_l_2_crouch_corner_l;			// stand to crouch
//	array[animType]["cover_left"]["prone"]["rifle"]["trans8"]					= %ai_corner_l_2_crouch_corner_r;			// doorway stand left to crouch right
//	array[animType]["cover_left"]["prone"]["rifle"]["trans5"]					= %ai_corner_l_2_corner_r;					// doorway stand left to stand right
//
//	array[animType]["cover_left"]["prone"]["rifle"]["trans4"]					= %ai_crouch_corner_l_2_corner_l;			// crouch to stand
//	array[animType]["cover_left"]["prone"]["rifle"]["trans9"]					= %ai_crouch_corner_l_2_corner_r;			// doorway crouch left to stand right
//	array[animType]["cover_left"]["prone"]["rifle"]["trans10"]					= %ai_crouch_corner_l_2_crouch_corner_r;	// doorway crouch left to crouch right
//
//	array[animType]["cover_left"]["prone"]["rifle"]["trans3"]					= %ai_crouch_corner_r_2_corner_r;			// crouch to stand
//	array[animType]["cover_left"]["prone"]["rifle"]["trans11"]					= %ai_crouch_corner_r_2_corner_l;			// doorway crouch right to stand left
//	array[animType]["cover_left"]["prone"]["rifle"]["trans12"]					= %ai_crouch_corner_r_2_crouch_corner_l;	// doorway crouch right to crouch left
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Transitions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Pillar Left Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_fire"]				= %ai_pillar2_stand_alert_l_auto;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_semi2"]			= %ai_pillar2_stand_alert_l_semi_2;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_semi3"]			= %ai_pillar2_stand_alert_l_semi_3;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_semi4"]			= %ai_pillar2_stand_alert_l_semi_4;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_semi5"]			= %ai_pillar2_stand_alert_l_semi_5;

	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_burst2"]			= %ai_pillar2_stand_alert_l_burst_3;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_burst3"]			= %ai_pillar2_stand_alert_l_burst_3;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_burst4"]			= %ai_pillar2_stand_alert_l_burst_4;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_burst5"]			= %ai_pillar2_stand_alert_l_burst_5;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_burst6"]			= %ai_pillar2_stand_alert_l_burst_6;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_single"]			= array( %ai_pillar2_stand_alert_l_semi_1 );

	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_aim_down"]			= %ai_pillar2_stand_alert_l_aim2;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_aim_left"]			= %ai_pillar2_stand_alert_l_aim4;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_aim_straight"]		= %ai_pillar2_stand_alert_l_aim5;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_aim_right"]		= %ai_pillar2_stand_alert_l_aim6;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_aim_up"]			= %ai_pillar2_stand_alert_l_aim8;

	array[animType]["cover_pillar_left"]["stand"]["rifle"]["alert_to_A"]			= array( %ai_pillar2_stand_idle_2_a_left );
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["alert_to_B"]			= array( %ai_pillar2_stand_idle_2_b_left );
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["A_to_alert"]			= array( %ai_pillar2_stand_a_left_2_idle );
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["A_to_alert_reload"]		= array();
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["A_to_B"    ]			= array( %ai_pillar2_stand_a_left_2_b_left     );
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["B_to_alert"]			= array( %ai_pillar2_stand_b_left_2_idle );
 	array[animType]["cover_pillar_left"]["stand"]["rifle"]["B_to_alert_reload"]		= array();
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["B_to_A"    ]			= array( %ai_pillar2_stand_b_left_2_a_left     );
	
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["alert_idle"]			= %ai_pillar2_stand_idle;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["alert_idle_twitch"]		= array(
																						%ai_pillar2_stand_idle_twitch_01,
																						%ai_pillar2_stand_idle_twitch_02,
																						%ai_pillar2_stand_idle_twitch_03,
																						%ai_pillar2_stand_idle_twitch_04,
																						%ai_pillar2_stand_idle_twitch_05,
																						%ai_pillar2_stand_idle_twitch_06,
																						%ai_pillar2_stand_idle_twitch_07,
																						%ai_pillar2_stand_idle_twitch_08,
																						%ai_pillar2_stand_idle_twitch_09,
																						%ai_pillar2_stand_idle_twitch_10,
																						%ai_pillar2_stand_idle_twitch_11
																					);
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_idle"]				= array( %ai_pillar2_stand_alert_l_idle );

	array[animType]["cover_pillar_left"]["stand"]["rifle"]["alert_to_lean"]			= array( %ai_pillar2_stand_idle_2_alert_l );
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["lean_to_alert"]			= array( %ai_pillar2_stand_alert_l_2_idle );
	
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["over_to_alert"]		= array( %ai_pillar2_stand_alert_o_2_idle );
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["alert_to_over"]		= array( %ai_pillar2_stand_idle_2_alert_o );
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["over_idle"]			= array( %ai_pillar2_stand_alert_o_idle );

	array[animType]["cover_pillar_left"]["stand"]["rifle"]["over_aim_straight"]	= %ai_pillar2_stand_alert_o_aim5;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["over_aim_up"]		= %ai_pillar2_stand_alert_o_aim2;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["over_aim_down"]		= %ai_pillar2_stand_alert_o_aim8;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["over_aim_left"]		= %ai_pillar2_stand_alert_o_aim4;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["over_aim_right"]	= %ai_pillar2_stand_alert_o_aim6;
		
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["blind_fire"]				= array( %ai_pillar2_stand_alert_l_blindfire );
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["blind_fire_add_aim_up"]		= %ai_pillar2_stand_alert_l_blindfire_aim8;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["blind_fire_add_aim_down"]	= %ai_pillar2_stand_alert_l_blindfire_aim2;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["blind_fire_add_aim_left"]	= %ai_pillar2_stand_alert_l_blindfire_aim4;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["blind_fire_add_aim_right"]	= %ai_pillar2_stand_alert_l_blindfire_aim6;
	
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["look"]					= array( %ai_pillar2_stand_idle_peek_l_01, %ai_pillar2_stand_idle_peek_l_02 );
	
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["reload"]				= array( %ai_pillar2_stand_reload_01, %ai_pillar2_stand_reload_02, %ai_pillar2_stand_reload_03 );
	
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["stance_change"]			= %ai_pillar2_stand_2_crouch;

	array[animType]["cover_pillar_left"]["stand"]["rifle"]["grenade_exposed"]		= %ai_pillar2_stand_idle_grenade_throw_l_01;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["grenade_safe"]			= %ai_pillar2_stand_idle_grenade_throw_l_02;
	array[animType]["cover_pillar_left"]["stand"]["rifle"]["grenade_throw"]			= %stand_grenade_throw;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Pillar Left Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Pillar Left Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_fire"]			= %ai_pillar2_crouch_alert_l_auto;   
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_semi2"]			= %ai_pillar2_crouch_alert_l_semi_2;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_semi3"]			= %ai_pillar2_crouch_alert_l_semi_3;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_semi4"]			= %ai_pillar2_crouch_alert_l_semi_4;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_semi5"]			= %ai_pillar2_crouch_alert_l_semi_5;

	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_burst2"]			= %ai_pillar2_crouch_alert_l_burst_3;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_burst3"]			= %ai_pillar2_crouch_alert_l_burst_3;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_burst4"]			= %ai_pillar2_crouch_alert_l_burst_4;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_burst5"]			= %ai_pillar2_crouch_alert_l_burst_5;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_burst6"]			= %ai_pillar2_crouch_alert_l_burst_6;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_single"]			= array( %ai_pillar2_crouch_alert_l_semi_1 );

	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_aim_down"]		= %ai_pillar2_crouch_alert_l_aim2;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_aim_left"]		= %ai_pillar2_crouch_alert_l_aim4;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_aim_straight"]	= %ai_pillar2_crouch_alert_l_aim5;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_aim_right"]		= %ai_pillar2_crouch_alert_l_aim6;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_aim_up"]			= %ai_pillar2_crouch_alert_l_aim8;

	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["alert_to_A"]			= array(%ai_pillar2_crouch_idle_2_a_left);
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["alert_to_B"]			= array(%ai_pillar2_crouch_idle_2_b_left);
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["A_to_alert"]			= array(%ai_pillar2_crouch_a_left_2_idle);
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["A_to_alert_reload"]	= array();
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["A_to_B"    ]			= array(%ai_pillar2_crouch_a_left_2_b_left);
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["B_to_alert"]			= array(%ai_pillar2_crouch_b_left_2_idle);
 	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["B_to_alert_reload"]	= array();
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["B_to_A"    ]			= array(%ai_pillar2_crouch_b_left_2_a_left);
	
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["alert_idle"]			= %ai_pillar2_crouch_idle;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["alert_idle_twitch"]	= array(
																						%ai_pillar2_crouch_idle_twitch_01,
																						%ai_pillar2_crouch_idle_twitch_02,
																						%ai_pillar2_crouch_idle_twitch_03,
																						%ai_pillar2_crouch_idle_twitch_04
																					);
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_idle"]			= array( %ai_pillar2_crouch_alert_l_idle ); 

	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["reload"]				= array( %ai_pillar2_crouch_reload_01, %ai_pillar2_crouch_reload_02, %ai_pillar2_crouch_reload_03 ); //array( %ai_pillar_crouch_reload_01, %ai_pillar_crouch_reload_02, %ai_pillar_crouch_reload_03 );

	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["alert_to_lean"]		= array( %ai_pillar2_crouch_idle_2_alert_l );
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["lean_to_alert"]		= array( %ai_pillar2_crouch_alert_l_2_idle );
	
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["over_to_alert"]		= array( %ai_pillar2_crouch_alert_o_2_idle );
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["alert_to_over"]		= array( %ai_pillar2_crouch_idle_2_alert_o );
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["over_idle"]			= array( %ai_pillar2_crouch_alert_o_idle );

	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["over_aim_straight"]	= %ai_pillar2_crouch_alert_o_aim5;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["over_aim_up"]			= %ai_pillar2_crouch_alert_o_aim2;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["over_aim_down"]		= %ai_pillar2_crouch_alert_o_aim8;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["over_aim_left"]		= %ai_pillar2_crouch_alert_o_aim4;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["over_aim_right"]		= %ai_pillar2_crouch_alert_o_aim6;


	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["look"]					= array( %ai_pillar2_crouch_idle );

	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["stance_change"]		= %ai_pillar2_crouch_2_stand; 

	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["grenade_exposed"]		= %ai_pillar2_crouch_idle_grenade_throw_l_01;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["grenade_safe"]			= %ai_pillar2_crouch_idle_grenade_throw_l_02;
	array[animType]["cover_pillar_left"]["crouch"]["rifle"]["grenade_throw"]		= %crouch_grenade_throw;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Pillar Left Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Pillar Right Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_fire"]			= %ai_pillar2_stand_alert_r_auto;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_semi2"]			= %ai_pillar2_stand_alert_r_semi_2;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_semi3"]			= %ai_pillar2_stand_alert_r_semi_3;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_semi4"]			= %ai_pillar2_stand_alert_r_semi_4;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_semi5"]			= %ai_pillar2_stand_alert_r_semi_5;

	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_burst2"]			= %ai_pillar2_stand_alert_r_burst_3;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_burst3"]			= %ai_pillar2_stand_alert_r_burst_3;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_burst4"]			= %ai_pillar2_stand_alert_r_burst_4;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_burst5"]			= %ai_pillar2_stand_alert_r_burst_5;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_burst6"]			= %ai_pillar2_stand_alert_r_burst_6;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_single"]			= array( %ai_pillar2_stand_alert_r_semi_1 );

	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_aim_down"]		= %ai_pillar2_stand_alert_r_aim2;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_aim_left"]		= %ai_pillar2_stand_alert_r_aim4;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_aim_straight"]	= %ai_pillar2_stand_alert_r_aim5;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_aim_right"]		= %ai_pillar2_stand_alert_r_aim6;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_aim_up"]			= %ai_pillar2_stand_alert_r_aim8;

	array[animType]["cover_pillar_right"]["stand"]["rifle"]["alert_to_A"]			= array( %ai_pillar2_stand_idle_2_a_right );
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["alert_to_B"]			= array( %ai_pillar2_stand_idle_2_b_right );
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["A_to_alert"]			= array( %ai_pillar2_stand_a_right_2_idle );
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["A_to_alert_reload"]	= array();
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["A_to_B"    ]			= array( %ai_pillar2_stand_a_right_2_b_right);
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["B_to_alert"]			= array( %ai_pillar2_stand_b_right_2_idle);
 	array[animType]["cover_pillar_right"]["stand"]["rifle"]["B_to_alert_reload"]	= array();
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["B_to_A"    ]			= array( %ai_pillar2_stand_b_right_2_a_right);

	array[animType]["cover_pillar_right"]["stand"]["rifle"]["alert_idle"]			= %ai_pillar2_stand_idle;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["alert_idle_twitch"]	= array(
																						%ai_pillar2_stand_idle_twitch_01,
																						%ai_pillar2_stand_idle_twitch_02,
																						%ai_pillar2_stand_idle_twitch_03,
																						%ai_pillar2_stand_idle_twitch_04,
																						%ai_pillar2_stand_idle_twitch_05,
																						%ai_pillar2_stand_idle_twitch_06,
																						%ai_pillar2_stand_idle_twitch_07,
																						%ai_pillar2_stand_idle_twitch_08,
																						%ai_pillar2_stand_idle_twitch_09,
																						%ai_pillar2_stand_idle_twitch_10,
																						%ai_pillar2_stand_idle_twitch_11
																					);

	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_idle"]			= array( %ai_pillar2_stand_alert_r_idle );

	array[animType]["cover_pillar_right"]["stand"]["rifle"]["alert_to_lean"]		= array( %ai_pillar2_stand_idle_2_alert_r );
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["lean_to_alert"]		= array( %ai_pillar2_stand_alert_r_2_idle );
	
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["over_to_alert"]		= array( %ai_pillar2_stand_alert_o_2_idle );
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["alert_to_over"]		= array( %ai_pillar2_stand_idle_2_alert_o );
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["over_idle"]			= array( %ai_pillar2_stand_alert_o_idle );

	array[animType]["cover_pillar_right"]["stand"]["rifle"]["over_aim_straight"]	= %ai_pillar2_stand_alert_o_aim5;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["over_aim_up"]			= %ai_pillar2_stand_alert_o_aim2;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["over_aim_down"]		= %ai_pillar2_stand_alert_o_aim8;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["over_aim_left"]		= %ai_pillar2_stand_alert_o_aim4;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["over_aim_right"]		= %ai_pillar2_stand_alert_o_aim6;
	
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["blind_fire"]				= array( %ai_pillar2_stand_alert_r_blindfire );
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["blind_fire_add_aim_up"]	= %ai_pillar2_stand_alert_r_blindfire_aim8;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["blind_fire_add_aim_down"]	= %ai_pillar2_stand_alert_r_blindfire_aim2;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["blind_fire_add_aim_left"]	= %ai_pillar2_stand_alert_r_blindfire_aim4;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["blind_fire_add_aim_right"]	= %ai_pillar2_stand_alert_r_blindfire_aim6;

	array[animType]["cover_pillar_right"]["stand"]["rifle"]["look"]					= array( %ai_pillar2_stand_idle_peek_l_01, %ai_pillar2_stand_idle_peek_l_02 );
	
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["reload"]				= array( %ai_pillar2_stand_reload_01, %ai_pillar2_stand_reload_02, %ai_pillar2_stand_reload_03 );
	
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["stance_change"]		= %ai_pillar2_stand_2_crouch;

	array[animType]["cover_pillar_right"]["stand"]["rifle"]["grenade_exposed"]		= %ai_pillar2_stand_idle_grenade_throw_r_01;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["grenade_safe"]			= %ai_pillar2_stand_idle_grenade_throw_r_02;
	array[animType]["cover_pillar_right"]["stand"]["rifle"]["grenade_throw"]		= %stand_grenade_throw;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Pillar Right Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Pillar Right Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_fire"]			= %ai_pillar2_crouch_alert_r_auto;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_semi2"]			= %ai_pillar2_crouch_alert_r_semi_2;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_semi3"]			= %ai_pillar2_crouch_alert_r_semi_3;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_semi4"]			= %ai_pillar2_crouch_alert_r_semi_4;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_semi5"]			= %ai_pillar2_crouch_alert_r_semi_5;

	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_burst2"]			= %ai_pillar2_crouch_alert_r_burst_3;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_burst3"]			= %ai_pillar2_crouch_alert_r_burst_3;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_burst4"]			= %ai_pillar2_crouch_alert_r_burst_4;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_burst5"]			= %ai_pillar2_crouch_alert_r_burst_5;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_burst6"]			= %ai_pillar2_crouch_alert_r_burst_6;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_single"]			= array(%ai_pillar2_crouch_alert_r_semi_1);

	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_aim_down"]		= %ai_pillar2_crouch_alert_r_aim2;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_aim_left"]		= %ai_pillar2_crouch_alert_r_aim4;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_aim_straight"]	= %ai_pillar2_crouch_alert_r_aim5;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_aim_right"]		= %ai_pillar2_crouch_alert_r_aim6;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_aim_up"]			= %ai_pillar2_crouch_alert_r_aim8;

	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["alert_to_A"]			= array(%ai_pillar2_crouch_idle_2_a_right);
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["alert_to_B"]			= array(%ai_pillar2_crouch_idle_2_b_right);
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["A_to_alert"]			= array(%ai_pillar2_crouch_a_right_2_idle);
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["A_to_alert_reload"]	= array();
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["A_to_B"    ]			= array(%ai_pillar2_crouch_a_right_2_b_right);
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["B_to_alert"]			= array(%ai_pillar2_crouch_b_right_2_idle);
 	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["B_to_alert_reload"]	= array();
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["B_to_A"    ]			= array(%ai_pillar2_crouch_b_right_2_a_right);

	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["alert_idle"]			= %ai_pillar2_crouch_idle;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["alert_idle_twitch"]	= array(
																						%ai_pillar2_crouch_idle_twitch_01,
																						%ai_pillar2_crouch_idle_twitch_02,
																						%ai_pillar2_crouch_idle_twitch_03,
																						%ai_pillar2_crouch_idle_twitch_04
																					 );
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_idle"]			= array( %ai_pillar2_crouch_alert_r_idle );

	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["reload"]				= array( %ai_pillar2_crouch_reload_01 ); //, %ai_pillar2_crouch_reload_02, %ai_pillar2_crouch_reload_03 );

	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["alert_to_lean"]		= array( %ai_pillar2_crouch_idle_2_alert_r );
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["lean_to_alert"]		= array( %ai_pillar2_crouch_alert_r_2_idle );
	
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["over_to_alert"]		= array( %ai_pillar2_crouch_alert_o_2_idle );
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["alert_to_over"]		= array( %ai_pillar2_crouch_idle_2_alert_o );
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["over_idle"]			= array( %ai_pillar2_crouch_alert_o_idle );

	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["over_aim_straight"]	= %ai_pillar2_crouch_alert_o_aim5;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["over_aim_up"]			= %ai_pillar2_crouch_alert_o_aim2;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["over_aim_down"]		= %ai_pillar2_crouch_alert_o_aim8;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["over_aim_left"]		= %ai_pillar2_crouch_alert_o_aim4;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["over_aim_right"]		= %ai_pillar2_crouch_alert_o_aim6;

	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["look"]				= %ai_pillar2_crouch_idle_twitch_01;

	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["stance_change"]		= %ai_pillar2_crouch_2_stand; 

	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["grenade_exposed"]		= %ai_pillar2_crouch_idle_grenade_throw_r_01;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["grenade_safe"]		= %ai_pillar2_crouch_idle_grenade_throw_r_02;
	array[animType]["cover_pillar_right"]["crouch"]["rifle"]["grenade_throw"]		= %crouch_grenade_throw;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Pillar Right Crouch Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Pillar Deaths and Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Making another block as pillar_left and pillar_right share some death/pain animations and ease of reading.
	// AI_TODO - We cant use remain animations as AI cant remember its cornermode 
	// while transitioning back to cover from pain.

	// pains
	array[animType]["pain"]["stand"]["rifle"]["cover_pillar_idle"]					= array( %ai_pillar2_stand_idle_pain, %ai_pillar2_stand_idle_pain_02, %ai_pillar2_stand_idle_pain_03 );
	array[animType]["pain"]["crouch"]["rifle"]["cover_pillar_idle"]					= array( %ai_pillar2_crouch_idle_pain, %ai_pillar2_crouch_idle_pain_02, %ai_pillar2_crouch_idle_pain_03 );

	array[animType]["pain"]["stand"]["rifle"]["cover_pillar_l_remain"]				= array( %ai_pillar2_stand_alert_l_pain_remain, %ai_pillar2_stand_alert_l_pain_remain_02, %ai_pillar2_stand_alert_l_pain_remain_03 );
	array[animType]["pain"]["stand"]["rifle"]["cover_pillar_l_return"]				= array( %ai_pillar2_stand_alert_l_pain_return, %ai_pillar2_stand_alert_l_pain_return_02, %ai_pillar2_stand_alert_l_pain_return_03 );
	array[animType]["pain"]["crouch"]["rifle"]["cover_pillar_l_remain"]				= array( %ai_pillar2_crouch_alert_l_pain_remain, %ai_pillar2_crouch_alert_l_pain_remain_02, %ai_pillar2_crouch_alert_l_pain_remain_03 );//%ai_pillar_crouch_pain_l_remain;
	array[animType]["pain"]["crouch"]["rifle"]["cover_pillar_l_return"]				= array( %ai_pillar2_crouch_alert_l_pain_return, %ai_pillar2_crouch_alert_l_pain_return_02, %ai_pillar2_crouch_alert_l_pain_return_03 );//%ai_pillar_crouch_pain_l_return;

	array[animType]["pain"]["stand"]["rifle"]["cover_pillar_r_remain"]				= array( %ai_pillar2_stand_alert_r_pain_remain, %ai_pillar2_stand_alert_r_pain_remain_02, %ai_pillar2_stand_alert_r_pain_remain_03 );
	array[animType]["pain"]["stand"]["rifle"]["cover_pillar_r_return"]				= array( %ai_pillar2_stand_alert_r_pain_return, %ai_pillar2_stand_alert_r_pain_return_02, %ai_pillar2_stand_alert_r_pain_return_03 );
	array[animType]["pain"]["crouch"]["rifle"]["cover_pillar_r_remain"]				= array( %ai_pillar2_crouch_alert_r_pain_remain, %ai_pillar2_crouch_alert_r_pain_remain_02, %ai_pillar2_crouch_alert_r_pain_remain_03 );//%ai_pillar_crouch_pain_r_remain;
	array[animType]["pain"]["crouch"]["rifle"]["cover_pillar_r_return"]				= array( %ai_pillar2_crouch_alert_r_pain_return, %ai_pillar2_crouch_alert_r_pain_return_02, %ai_pillar2_crouch_alert_r_pain_return_03 );//%ai_pillar_crouch_pain_r_return;
	
	// deaths
	array[animType]["death"]["stand"]["rifle"]["cover_pillar_front"]				= array( %ai_pillar2_stand_idle_death_01, %ai_pillar2_stand_idle_death_02 );
	array[animType]["death"]["crouch"]["rifle"]["cover_pillar_front"]				= array( %ai_pillar2_crouch_idle_death_01, %ai_pillar2_crouch_idle_death_02 );//array( %ai_pillar_crouch_death_idle_01, %ai_pillar_crouch_death_idle_02 );

	array[animType]["death"]["stand"]["rifle"]["cover_pillar_left"]					= array( %ai_pillar2_stand_alert_l_death_01, %ai_pillar2_stand_alert_l_death_02 );
	array[animType]["death"]["crouch"]["rifle"]["cover_pillar_left"]				= array( %ai_pillar2_crouch_alert_l_death_01, %ai_pillar2_crouch_alert_l_death_02 );//array( %ai_pillar_crouch_death_left_01, %ai_pillar_crouch_death_left_02 );

	array[animType]["death"]["crouch"]["rifle"]["cover_pillar_right"]				= array( %ai_pillar2_crouch_alert_r_death_01, %ai_pillar2_crouch_alert_r_death_02 );//array( %ai_pillar_crouch_death_right_01, %ai_pillar_crouch_death_right_02 );
	array[animType]["death"]["stand"]["rifle"]["cover_pillar_right"]				= array( %ai_pillar2_stand_alert_r_death_01, %ai_pillar2_stand_alert_r_death_02 );
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Pillar Deaths and Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Exposed Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["pistol"]["chest"]						= %pistol_stand_pain_chest;
	array[animType]["pain"]["stand"]["pistol"]["groin"]						= %pistol_stand_pain_groin; // %ai_pistol_stand_exposed_pain_groin;
	array[animType]["pain"]["stand"]["pistol"]["head"]						= %pistol_stand_pain_head;
	array[animType]["pain"]["stand"]["pistol"]["left_arm"]					= %pistol_stand_pain_leftshoulder;
	array[animType]["pain"]["stand"]["pistol"]["right_arm"]					= %pistol_stand_pain_rightshoulder;
	array[animType]["pain"]["stand"]["pistol"]["leg"]						= array( %pistol_stand_pain_groin );
	
	array[animType]["pain"]["stand"]["gas"]["chest"]						= %ai_flamethrower_stand_pain;

	array[animType]["pain"]["stand"]["rifle"]["big"]						= %exposed_pain_2_crouch;
	array[animType]["pain"]["stand"]["rifle"]["drop_gun"]					= %exposed_pain_dropgun;
	array[animType]["pain"]["stand"]["rifle"]["chest"]						= %exposed_pain_back;
	array[animType]["pain"]["stand"]["rifle"]["groin"]						= %exposed_pain_groin;
	array[animType]["pain"]["stand"]["rifle"]["left_arm"]					= %exposed_pain_left_arm;
	array[animType]["pain"]["stand"]["rifle"]["right_arm"]					= %exposed_pain_right_arm;
	array[animType]["pain"]["stand"]["rifle"]["leg"]						= %exposed_pain_leg;
	
	array[animType]["pain"]["crouch"]["gas"]["chest"]						= %ai_flamethrower_crouch_pain;

	array[animType]["pain"]["crouch"]["rifle"]["chest"]						= %exposed_crouch_pain_chest;
	array[animType]["pain"]["crouch"]["rifle"]["head"]						= %exposed_crouch_pain_headsnap;
	array[animType]["pain"]["crouch"]["rifle"]["left_arm"]					= %exposed_crouch_pain_left_arm;
	array[animType]["pain"]["crouch"]["rifle"]["right_arm"]					= %exposed_crouch_pain_right_arm;
	array[animType]["pain"]["crouch"]["rifle"]["flinch"]					= %exposed_crouch_pain_flinch;

	array[animType]["pain"]["prone"]["rifle"]["chest"]						= array(%prone_reaction_A, %prone_reaction_B);

	array[animType]["pain"]["back"]["rifle"]["chest"]						= %back_pain;

	array[animType]["pain"]["stand"]["rifle"]["burn_chest"]					= array( %ai_flame_wounded_stand_a, %ai_flame_wounded_stand_b, %ai_flame_wounded_stand_c, %ai_flame_wounded_stand_d );
	array[animType]["pain"]["stand"]["gas"]["burn_chest"]					= array( %ai_flamethrower_wounded_stand_arm, %ai_flamethrower_wounded_stand_chest, %ai_flamethrower_wounded_stand_head, %ai_flamethrower_wounded_stand_leg );
	array[animType]["pain"]["crouch"]["rifle"]["burn_chest"]				= array( %ai_flame_wounded_crouch_a, %ai_flame_wounded_crouch_b, %ai_flame_wounded_crouch_c, %ai_flame_wounded_crouch_d );

	// SUMEET_TODO- Do we need these in common? Prob not.
	array[animType]["pain"]["stand"]["pistol"]["run_long"]					= array( %ai_pistol_run_lowready_f_pain_head, %ai_pistol_run_lowready_f_pain_chest );
	array[animType]["pain"]["stand"]["pistol"]["run_medium"]				= array( %ai_pistol_run_lowready_f_pain_groin );
	array[animType]["pain"]["stand"]["pistol"]["run_short"]					= array( %ai_pistol_run_lowready_f_pain_groin );
		
	// may be we need better runblendout function.
	array[animType]["pain"]["stand"]["rifle"]["run_long"]					= array( %ai_run_pain_leg, %ai_run_pain_stomach_stumble, %ai_run_pain_head, %ai_run_pain_shoulder );
	array[animType]["pain"]["stand"]["rifle"]["run_medium"]					= array( %run_pain_fallonknee_02, %run_pain_stomach, %ai_run_pain_stomach_fast, %ai_run_pain_leg_fast, %ai_run_pain_fall );
	array[animType]["pain"]["stand"]["rifle"]["run_short"]					= array( %run_pain_fallonknee, %run_pain_fallonknee_03 );

	// extended pains
	array[animType]["pain"]["stand"]["rifle"]["upper_torso_extended"]		= array( %ai_stand_exposed_pain_face, %ai_stand_exposed_extendedpain_b );
	array[animType]["pain"]["stand"]["rifle"]["lower_torso_extended"]		= array( %ai_stand_exposed_extendedpain_hip_2_crouch, %ai_stand_exposed_extendedpain_gut );
	array[animType]["pain"]["stand"]["rifle"]["legs_extended"]				= array( %ai_stand_exposed_extendedpain_thigh, %ai_stand_exposed_extendedpain_hip );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Exposed Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Balcony
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	array[animType]["combat"]["stand"]["rifle"]["balcony"]
	= array(
				%ai_balcony_death_01,
				%ai_balcony_death_02,
				%ai_balcony_death_03,
				%ai_balcony_death_04,
				%ai_balcony_death_05
			);
	
	array[animType]["combat"]["stand"]["rifle"]["balcony_norailing"]
	= array(
				%ai_roof_death_01,
				%ai_roof_death_02,
				//%ai_roof_death_03,	// bad anim
				%ai_roof_death_04,
				%ai_roof_death_05,
				%ai_roof_death_06,
				%ai_roof_death_07
			);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Balcony
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Crawl Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["rifle"]["stand_2_crawl"]				= array( %dying_stand_2_crawl_v1, %dying_stand_2_crawl_v2, %dying_stand_2_crawl_v3 );
	array[animType]["pain"]["crouch"]["rifle"]["crouch_2_crawl"]			= array( %dying_crouch_2_crawl );
	
	array[animType]["pain"]["prone"]["rifle"]["prone_2_back"]				= array( %dying_crawl_2_back );
	array[animType]["pain"]["stand"]["rifle"]["stand_2_back"]				= array( %dying_stand_2_back_v1, %dying_stand_2_back_v2, %dying_stand_2_back_v3 );
	array[animType]["pain"]["crouch"]["rifle"]["crouch_2_back"]				= array( %dying_crouch_2_back );
	
	array[animType]["pain"]["back"]["rifle"]["back_idle"]					= %dying_back_idle;
	array[animType]["pain"]["back"]["rifle"]["back_idle_twitch"]			= array( %dying_back_twitch_A, %dying_back_twitch_B );
	array[animType]["pain"]["back"]["rifle"]["back_crawl"]					= %dying_crawl_back;
	array[animType]["pain"]["back"]["rifle"]["back_fire"]					= %dying_back_fire;	
	array[animType]["pain"]["back"]["rifle"]["back_death"]					= array( %dying_back_death_v1, %dying_back_death_v2, %dying_back_death_v3 );

	array[animType]["pain"]["prone"]["rifle"]["crawl"]						= %dying_crawl;	
	array[animType]["pain"]["prone"]["rifle"]["death"]						= array( %dying_crawl_death_v1, %dying_crawl_death_v2 );

	array[animType]["pain"]["back"]["pistol"]["aim_left"]					= %dying_back_aim_4;
	array[animType]["pain"]["back"]["pistol"]["aim_right"]					= %dying_back_aim_6;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Crawl Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["rifle"]["cover_left_head"]			= %corner_standl_pain; // dizzy fall against wall
	array[animType]["pain"]["stand"]["rifle"]["cover_left_groin"]			= %corner_standl_painB;
	array[animType]["pain"]["stand"]["rifle"]["cover_left_chest"]			= %corner_standl_painC;
	array[animType]["pain"]["stand"]["rifle"]["cover_left_left_leg"]		= %corner_standl_painD;
	array[animType]["pain"]["stand"]["rifle"]["cover_left_right_leg"]		= %corner_standl_painE;
	
	array[animType]["pain"]["stand"]["rifle"]["cover_left_stand_A"]			= %ai_cornerstnd_l_pain_a_2_alert;
	array[animType]["pain"]["stand"]["rifle"]["cover_left_stand_B"]			= %ai_cornerstnd_l_pain_b_2_alert;

	array[animType]["pain"]["crouch"]["rifle"]["cover_left"]				= %ai_cornercrl_pain_b;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Left Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["rifle"]["cover_right_chest"]			= %corner_standr_pain;	// right shoulder hit
	array[animType]["pain"]["stand"]["rifle"]["cover_right_groin"]			= %corner_standr_painC;	// groin hit
	array[animType]["pain"]["stand"]["rifle"]["cover_right_right_leg"]		= %corner_standr_painB;	// right leg hit
		
	//array[animType]["pain"]["stand"]["rifle"]["cover_right_stand_A"]		= %ai_cornerstnd_r_pain_a_2_alert;
	array[animType]["pain"]["stand"]["rifle"]["cover_right_stand_B"]		= %ai_cornerstnd_r_pain_b_2_alert;

	array[animType]["pain"]["crouch"]["rifle"]["cover_right"]				= array( %ai_cornercrr_alert_pain_a, %ai_cornercrr_alert_pain_c );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Right Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Stand Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["rifle"]["cover_stand_chest"]			= %coverstand_pain_groin;
	array[animType]["pain"]["stand"]["rifle"]["cover_stand_groin"]			= %coverstand_pain_groin;
	array[animType]["pain"]["stand"]["rifle"]["cover_stand_left_leg"]		= %coverstand_pain_leg;
	array[animType]["pain"]["stand"]["rifle"]["cover_stand_right_leg"]		= %coverstand_pain_leg;

	array[animType]["pain"]["stand"]["rifle"]["cover_stand_aim"]			= array( %ai_coverstand_aim_pain_2_hide_01, %ai_coverstand_aim_pain_2_hide_02 );

	array[animType]["pain"]["crouch"]["rifle"]["cover_stand_chest"]			= %coverstand_pain_groin;
	array[animType]["pain"]["crouch"]["rifle"]["cover_stand_groin"]			= %coverstand_pain_groin;
	array[animType]["pain"]["crouch"]["rifle"]["cover_stand_left_leg"]		= %coverstand_pain_leg;
	array[animType]["pain"]["crouch"]["rifle"]["cover_stand_right_leg"]		= %coverstand_pain_leg;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Stand Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Crouch Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["rifle"]["cover_crouch_front"]			= %covercrouch_pain_front;
	array[animType]["pain"]["stand"]["rifle"]["cover_crouch_left"]			= %covercrouch_pain_left_3;
	array[animType]["pain"]["stand"]["rifle"]["cover_crouch_right"]			= %covercrouch_pain_right;
	array[animType]["pain"]["stand"]["rifle"]["cover_crouch_back"]			= %covercrouch_pain_right_2;
	
	array[animType]["pain"]["crouch"]["rifle"]["cover_crouch_front"]		= %covercrouch_pain_front;
	array[animType]["pain"]["crouch"]["rifle"]["cover_crouch_left"]			= %covercrouch_pain_left_3;
	array[animType]["pain"]["crouch"]["rifle"]["cover_crouch_right"]		= %covercrouch_pain_right;
	array[animType]["pain"]["crouch"]["rifle"]["cover_crouch_back"]			= %covercrouch_pain_right_2;

	array[animType]["pain"]["crouch"]["rifle"]["cover_crouch_aim"]			= %ai_covercrouch_pain_aim_2_hide_01;
	array[animType]["pain"]["crouch"]["rifle"]["cover_crouch_aim_right"]	= %ai_covercrouch_pain_aim_2_hide_01_r;
	array[animType]["pain"]["crouch"]["rifle"]["cover_crouch_aim_left"]		= %ai_covercrouch_pain_aim_2_hide_01_l;

//	array[animType]["pain"]["stand"]["rifle"]["asdf"]						= %ai_covercrouch_aim_death_fetal;
//	array[animType]["pain"]["stand"]["rifle"]["asdf"]						= %ai_covercrouch_aim_death_flip;
//	array[animType]["pain"]["stand"]["rifle"]["asdf"]						= %ai_covercrouch_aim_death_twist;
//	array[animType]["pain"]["stand"]["rifle"]["asdf"]						= %ai_covercrouch_aim_pain_chest;
//	array[animType]["pain"]["stand"]["rifle"]["asdf"]						= %ai_covercrouch_aim_pain_flinch;
//	array[animType]["pain"]["stand"]["rifle"]["asdf"]						= %ai_covercrouch_aim_pain_headsnap;
//	array[animType]["pain"]["stand"]["rifle"]["asdf"]						= %ai_covercrouch_aim_pain_left;
//	array[animType]["pain"]["stand"]["rifle"]["asdf"]						= %ai_covercrouch_aim_pain_right;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Crouch Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin SAW Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ALEXP_TODO: verify this works
	array[animType]["pain"]["stand"]["rifle"]["saw_chest"]					= %saw_gunner_pain;
	array[animType]["pain"]["crouch"]["rifle"]["saw_chest"]					= %saw_gunner_lowwall_pain_02;
	array[animType]["pain"]["prone"]["rifle"]["saw_chest"]					= %saw_gunner_prone_pain;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End SAW Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Crossbow Pains (deaths, really)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["rifle"]["crossbow_back_explode_v1"]		= %ai_death_crossbow_back_panic_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_back_explode_v2"]		= %ai_death_crossbow_back_reach_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_front_explode_v1"]		= %ai_death_crossbow_front_panic_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_front_explode_v2"]		= %ai_death_crossbow_front_warn_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_l_arm_explode_v1"]		= %ai_death_crossbow_l_arm_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_l_arm_explode_v2"]		= %ai_death_crossbow_l_arm_panic_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_l_leg_explode_v1"]		= %ai_death_crossbow_l_leg_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_l_leg_explode_v2"]		= %ai_death_crossbow_l_leg_hop_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_r_arm_explode_v1"]		= %ai_death_crossbow_r_arm_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_r_arm_explode_v2"]		= %ai_death_crossbow_r_arm_panic_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_r_leg_explode_v1"]		= %ai_death_crossbow_r_leg_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_r_leg_explode_v2"]		= %ai_death_crossbow_r_leg_hop_explode;

	array[animType]["pain"]["stand"]["rifle"]["crossbow_run_back_explode"]		= %ai_death_crossbow_run_back_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_run_front_explode"]		= %ai_death_crossbow_run_front_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_run_l_arm_explode"]		= %ai_death_crossbow_run_l_arm_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_run_l_leg_explode"]		= %ai_death_crossbow_run_l_leg_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_run_r_arm_explode"]		= %ai_death_crossbow_run_r_arm_explode;
	array[animType]["pain"]["stand"]["rifle"]["crossbow_run_r_leg_explode"]		= %ai_death_crossbow_run_r_leg_explode;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Crossbow Pains
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Reacts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	array[animType]["react"]["stand"]["rifle"]["cover_left_ne"]				= array( %ai_corner_stand_l_react_a );
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Left Reacts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Crouch Reacts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	array[animType]["react"]["stand"]["rifle"]["cover_crouch_ne"]			= array( %ai_crouch_cover_reaction_a, %ai_crouch_cover_reaction_b );
	array[animType]["react"]["crouch"]["rifle"]["cover_crouch_ne"]			= array( %ai_crouch_cover_reaction_a, %ai_crouch_cover_reaction_b );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Crouch Reacts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Reacts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	array[animType]["react"]["stand"]["rifle"]["cover_right_ne"]		= array( %ai_corner_stand_r_react_a );
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Right Reacts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover stand Reacts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	array[animType]["react"]["stand"]["rifle"]["cover_stand_ne"]		= array( %ai_stand_cover_reaction_a, %ai_stand_cover_reaction_b );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover stand Reacts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Exposed Reacts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	array[animType]["react"]["stand"]["rifle"]["exposed_left_head"]			= %ai_stand_exposed_miss_detect_left_head; 
//	array[animType]["react"]["stand"]["rifle"]["exposed_left_upper_torso"]  = %ai_stand_exposed_miss_detect_left_torso;
//	array[animType]["react"]["stand"]["rifle"]["exposed_left_lower_torso"]	= %ai_stand_exposed_miss_detect_left_legs;
//
//	array[animType]["react"]["stand"]["rifle"]["exposed_right_head"]		= %ai_stand_exposed_miss_detect_right_head; 
//	array[animType]["react"]["stand"]["rifle"]["exposed_right_upper_torso"] = %ai_stand_exposed_miss_detect_right_torso;
//	array[animType]["react"]["stand"]["rifle"]["exposed_right_lower_torso"]	= %ai_stand_exposed_miss_detect_right_legs;
//
//	array[animType]["react"]["crouch"]["rifle"]["exposed_left_head"]		= %ai_crouch_exposed_miss_detect_left_head; 
//	array[animType]["react"]["crouch"]["rifle"]["exposed_left_upper_torso"] = %ai_crouch_exposed_miss_detect_left_torso;
//	array[animType]["react"]["crouch"]["rifle"]["exposed_left_lower_torso"]	= %ai_crouch_exposed_miss_detect_left_legs;
//
//	array[animType]["react"]["crouch"]["rifle"]["exposed_right_head"]		= %ai_crouch_exposed_miss_detect_right_head; 
//	array[animType]["react"]["crouch"]["rifle"]["exposed_right_upper_torso"]= %ai_crouch_exposed_miss_detect_right_torso;
//	array[animType]["react"]["crouch"]["rifle"]["exposed_right_lower_torso"]= %ai_crouch_exposed_miss_detect_right_legs;
	
	array[animType]["react"]["stand"]["rifle"]["run_head"]		            = %ai_run_lowready_f_miss_detect_head; 
	array[animType]["react"]["stand"]["rifle"]["run_lower_torso_fast"]      = %ai_run_lowready_f_miss_detect_legs;
	array[animType]["react"]["stand"]["rifle"]["run_lower_torso_stop"]      = %ai_run_lowready_f_miss_detect_stop;

	array[animType]["react"]["stand"]["rifle"]["sprint_head"]		        = %ai_sprint_f_miss_detect_head; 
	array[animType]["react"]["stand"]["rifle"]["sprint_lower_torso_fast"]   = %ai_sprint_f_miss_detect_legs;
	array[animType]["react"]["stand"]["rifle"]["sprint_lower_torso_stop"]   = %ai_sprint_f_miss_detect_stop;
	
	array[animType]["react"]["stand"]["rifle"]["combat_ne"]					= array( %ai_exposed_backpedal, %ai_exposed_idle_react_b );
	array[animType]["react"]["crouch"]["rifle"]["combat_ne"]				= array( %ai_exposed_backpedal, %ai_exposed_idle_react_b );
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Exposed Reacts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["pain"]["stand"]["rifle"]["cover_right_corner_hit"]		= %corner_standR_death_grenade_hit;
	array[animType]["pain"]["crouch"]["rifle"]["cover_right_corner_hit"]	= %corner_standR_death_grenade_hit;
	array[animType]["pain"]["back"]["rifle"]["cover_right_corner_idle"]		= %corner_standR_death_grenade_idle;
	array[animType]["pain"]["back"]["rifle"]["cover_right_corner_slump"]	= %corner_standR_death_grenade_slump;
	array[animType]["death"]["back"]["rifle"]["cover_right_corner_death"]	= array( %dying_back_death_v1, %dying_back_death_v2, %dying_back_death_v3, %dying_back_death_v4 );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Right Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Exposed Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["death"]["stand"]["pistol"]["front"]					= %pistol_death_1; // falls backwards
	array[animType]["death"]["stand"]["pistol"]["back"]						= %pistol_death_2; // falls forwards
	array[animType]["death"]["stand"]["pistol"]["groin"]					= %pistol_death_3; // hit in groin from front
	array[animType]["death"]["stand"]["pistol"]["head"]						= %pistol_death_4; // hit at top and falls backwards, but more dragged out

	array[animType]["death"]["stand"]["gas"]["front"]						= %ai_flamethrower_stand_death;
	array[animType]["death"]["stand"]["gas"]["back"]						= %death_explosion_up10;
	array[animType]["death"]["crouch"]["gas"]["front"]						= %ai_flamethrower_crouch_death;

	array[animType]["death"]["stand"]["saw"]["front"]						= %saw_gunner_death;
	array[animType]["death"]["crouch"]["saw"]["front"]						= %saw_gunner_lowwall_death;
	array[animType]["death"]["prone"]["saw"]["front"]						= %saw_gunner_prone_death;

	array[animType]["death"]["stand"]["rifle"]["front"]						= %exposed_death;
	array[animType]["death"]["stand"]["rifle"]["back"]						= %exposed_death;
	array[animType]["death"]["stand"]["rifle"]["front_2"]					= %exposed_death_02;
	array[animType]["death"]["stand"]["rifle"]["firing_1"]					= %exposed_death_firing;
	array[animType]["death"]["stand"]["rifle"]["firing_2"]					= %exposed_death_firing;//%exposed_death_firing_02;
	array[animType]["death"]["stand"]["rifle"]["groin"]						= %exposed_death_groin;
	array[animType]["death"]["stand"]["rifle"]["left_leg_start"]			= %ai_deadly_wounded_leg_L_hit;
	array[animType]["death"]["stand"]["rifle"]["left_leg_loop"]				= %ai_deadly_wounded_leg_L_loop;
	array[animType]["death"]["stand"]["rifle"]["left_leg_end"]				= %ai_deadly_wounded_leg_L_die;
	array[animType]["death"]["stand"]["rifle"]["right_leg_start"]			= %ai_deadly_wounded_leg_R_hit;
	array[animType]["death"]["stand"]["rifle"]["right_leg_loop"]			= %ai_deadly_wounded_leg_R_loop;
	array[animType]["death"]["stand"]["rifle"]["right_leg_end"]				= %ai_deadly_wounded_leg_R_die;
	array[animType]["death"]["stand"]["rifle"]["torso_start"]				= %ai_deadly_wounded_torso_hit;
	array[animType]["death"]["stand"]["rifle"]["torso_loop"]				= %ai_deadly_wounded_torso_loop;
	array[animType]["death"]["stand"]["rifle"]["torso_end"]					= %ai_deadly_wounded_torso_die;
	array[animType]["death"]["stand"]["rifle"]["head_1"]					= %exposed_death_headshot;
	array[animType]["death"]["stand"]["rifle"]["head_2"]					= %exposed_death_headtwist;
	array[animType]["death"]["stand"]["rifle"]["nerve"]						= %exposed_death_nerve;
	array[animType]["death"]["stand"]["rifle"]["neckgrab"]					= %exposed_death_neckgrab;
	array[animType]["death"]["stand"]["rifle"]["fall_to_knees_1"]			= %exposed_death_falltoknees;
	array[animType]["death"]["stand"]["rifle"]["fall_to_knees_2"]			= %exposed_death_falltoknees_02;
	array[animType]["death"]["stand"]["rifle"]["twist"]						= %exposed_death_twist;

	array[animType]["death"]["stand"]["rifle"]["armslegsforward"]			= %ai_death_armslegsforward;		// explosive/shotgun front hit, fly backwards
	array[animType]["death"]["stand"]["rifle"]["flyback"]					= array( %ai_death_flyback, %ai_death_shotgun_back_v1 );	// explosive/shotgun front hit, fly backwards
	array[animType]["death"]["stand"]["rifle"]["flyback_far"]				= array( %ai_death_flyback_far, %ai_death_shotgun_back_v2, %ai_death_sniper_2 );// explosive/shotgun front hit, fly backwards
	array[animType]["death"]["stand"]["rifle"]["jackiespin_inplace"]		= %ai_death_jackiespin_inplace;		// explosive/shotgun front hit, fly backwards
	array[animType]["death"]["stand"]["rifle"]["jackiespin_left"]			= array( %ai_death_jackiespin_left, %ai_death_shotgun_spinr );		// explosive/shotgun right hit, fly left
	array[animType]["death"]["stand"]["rifle"]["jackiespin_right"]			= array( %ai_death_jackiespin_right, %ai_death_shotgun_spinl );		// explosive/shotgun left hit, fly right
	array[animType]["death"]["stand"]["rifle"]["jackiespin_vertical"]		= array( %ai_death_jackiespin_vertical, %ai_death_sniper_4 );	// explosive/shotgun back hit, fly forward
	array[animType]["death"]["stand"]["rifle"]["heavy_flyback"]				= array( %ai_death_stand_heavyshot_back, %ai_death_shotgun_back_v2, %ai_stand_exposed_death_blowback );	// explosive/shotgun back hit, fall forward	

	array[animType]["death"]["stand"]["rifle"]["faceplant"]					= %ai_death_faceplant;												// sniper hit back/legs, fall forward
	array[animType]["death"]["stand"]["rifle"]["flatonback"]				= array( %ai_death_flatonback, %ai_stand_exposed_death_blowback );	// sniper hit front, fall backward
	array[animType]["death"]["stand"]["rifle"]["legsout_left"]				= array( %ai_death_legsout_left, %ai_death_shotgun_legs );			// sniper hit left, fall right
	array[animType]["death"]["stand"]["rifle"]["legsout_right"]				= array( %ai_death_legsout_right, %ai_death_shotgun_legs );			// sniper hit right, fall left
	array[animType]["death"]["stand"]["rifle"]["upontoback"]				= array( %ai_death_flatonback, %ai_stand_exposed_death_blowback );	// sniper hit headshot, fall backward

	array[animType]["death"]["stand"]["rifle"]["collapse"]					= %ai_death_collapse_in_place;		// bullet hit (headshot), fall left
	array[animType]["death"]["stand"]["rifle"]["deadfallknee"]				= %ai_death_deadfallknee;			// bullet hit (chest), fall forward
	array[animType]["death"]["stand"]["rifle"]["fallforward"]				= %ai_death_fallforward;			// bullet hit (right torso), fall forward
	array[animType]["death"]["stand"]["rifle"]["fallforward_b"]				= %ai_death_fallforward_b;			// bullet hit (left torso), fall forward
	array[animType]["death"]["stand"]["rifle"]["forwardtoface"]				= %ai_death_forwardtoface;			// bullet hit (chest), fall forward
	array[animType]["death"]["stand"]["rifle"]["gutshot"]					= %ai_death_gutshot_fallback;		// bullet gut/chest, fall backward
	array[animType]["death"]["stand"]["rifle"]["stumblefall"]				= %ai_death_stumblefall;			// bullet hit back, fall forward far
	array[animType]["death"]["stand"]["rifle"]["neckgrab2"]					= %ai_death_throathit_collapse;		// bullet hit chest/head, fall forward

	array[animType]["death"]["stand"]["rifle"]["crossbow_back"]				= %ai_death_crossbow_back;	
	array[animType]["death"]["stand"]["rifle"]["crossbow_front"]			= %ai_death_crossbow_front;	
	array[animType]["death"]["stand"]["rifle"]["crossbow_l_arm"]			= %ai_death_crossbow_l_arm;	
	array[animType]["death"]["stand"]["rifle"]["crossbow_l_leg"]			= %ai_death_crossbow_l_leg;	
	array[animType]["death"]["stand"]["rifle"]["crossbow_r_arm"]			= %ai_death_crossbow_r_arm;	
	array[animType]["death"]["stand"]["rifle"]["crossbow_r_leg"]			= %ai_death_crossbow_r_leg;

	array[animType]["death"]["stand"]["rifle"]["crossbow_run_back"]			= %ai_death_crossbow_run_back;	
	array[animType]["death"]["stand"]["rifle"]["crossbow_run_front"]		= %ai_death_crossbow_run_front;	
	array[animType]["death"]["stand"]["rifle"]["crossbow_run_l_arm"]		= %ai_death_crossbow_run_l_arm;	
	array[animType]["death"]["stand"]["rifle"]["crossbow_run_l_leg"]		= %ai_death_crossbow_run_l_leg;	
	array[animType]["death"]["stand"]["rifle"]["crossbow_run_r_arm"]		= %ai_death_crossbow_run_r_arm;	
	array[animType]["death"]["stand"]["rifle"]["crossbow_run_r_leg"]		= %ai_death_crossbow_run_r_leg;	

	array[animType]["death"]["crouch"]["rifle"]["front"]					= %exposed_crouch_death_fetal;
	array[animType]["death"]["crouch"]["rifle"]["front_2"]					= %exposed_crouch_death_twist;
	array[animType]["death"]["crouch"]["rifle"]["front_3"]					= %exposed_crouch_death_flip;

	array[animType]["death"]["prone"]["rifle"]["front"]						= %prone_death_quickdeath;
	array[animType]["death"]["prone"]["rifle"]["crawl"]						= array( %dying_crawl_death_v1, %dying_crawl_death_v2 ); 

	array[animType]["death"]["back"]["rifle"]["front"]						= array( %dying_back_death_v1, %dying_back_death_v2, %dying_back_death_v3, %dying_back_death_v4 );
	array[animType]["death"]["back"]["rifle"]["crawl"]						= array( %dying_back_death_v2, %dying_back_death_v3, %dying_back_death_v4 ); 

	array[animType]["death"]["stand"]["rifle"]["run_front_1"]				= %run_death_fallonback;
	array[animType]["death"]["stand"]["rifle"]["run_front_2"]				= %run_death_fallonback_02;
	array[animType]["death"]["stand"]["rifle"]["run_front_3"]				= %run_death_flop;
	array[animType]["death"]["stand"]["rifle"]["run_back_1"]				= %run_death_facedown;
	array[animType]["death"]["stand"]["rifle"]["run_back_2"]				= %run_death_roll;
	
	array[animType]["death"]["stand"]["rocketlauncher"]["front"]			= %RPG_stand_death;
	array[animType]["death"]["stand"]["rocketlauncher"]["stagger"]			= %RPG_stand_death_stagger;
	array[animType]["death"]["crouch"]["rocketlauncher"]["front"]			= %RPG_stand_death;
	array[animType]["death"]["crouch"]["rocketlauncher"]["stagger"]			= %RPG_stand_death_stagger;
	array[animType]["death"]["prone"]["rocketlauncher"]["front"]			= %RPG_stand_death;
	array[animType]["death"]["prone"]["rocketlauncher"]["stagger"]			= %RPG_stand_death_stagger;
	array[animType]["death"]["back"]["rocketlauncher"]["front"]				= %RPG_stand_death;
	array[animType]["death"]["back"]["rocketlauncher"]["stagger"]			= %RPG_stand_death_stagger;
	array[animType]["death"]["stand"]["rocketlauncher"]["firing_1"]			= %RPG_stand_death;
	array[animType]["death"]["stand"]["rocketlauncher"]["firing_2"]			= %RPG_stand_death;

	// mw2 death anims
	array[animType]["death"]["stand"]["rifle"]["chest_blowback"]			= %stand_death_chest_blowback;				// shotgun front, fall on to back
	array[animType]["death"]["stand"]["rifle"]["chest_spin"]				= %stand_death_chest_spin;					// shotgun front, spin
	array[animType]["death"]["stand"]["rifle"]["chest_stunned"]				= %stand_death_chest_stunned;				// regular chest hit 
	array[animType]["death"]["stand"]["rifle"]["crotch"]					= %stand_death_crotch;						// regular crotch hit
	array[animType]["death"]["stand"]["rifle"]["face"]						= %stand_death_face;						// regular front headshot
	array[animType]["death"]["stand"]["rifle"]["fallside"]					= %stand_death_fallside;					// regular front hit
	array[animType]["death"]["stand"]["rifle"]["guts"]						= %stand_death_guts;						// regular front crotch
	array[animType]["death"]["stand"]["rifle"]["head_straight_back"]		= %stand_death_head_straight_back;			// regular front headshot
	array[animType]["death"]["stand"]["rifle"]["headshot_slowfall"]			= %stand_death_headshot_slowfall;			// regular front headshot
	array[animType]["death"]["stand"]["rifle"]["leg"]						= %stand_death_leg;							// regular left leg
	array[animType]["death"]["stand"]["rifle"]["shoulder_spin"]				= %stand_death_shoulder_spin;				// regular front left shoulder
	array[animType]["death"]["stand"]["rifle"]["shoulder_stumble"]			= %stand_death_shoulder_stumble;			// regular front left side
	array[animType]["death"]["stand"]["rifle"]["shoulderback"]				= %stand_death_shoulderback;				// regular front left shoulder 
	array[animType]["death"]["stand"]["rifle"]["tumbleback"]				= %stand_death_tumbleback;					// regular front midsection
	array[animType]["death"]["stand"]["rifle"]["tumbleforward"]				= %stand_death_tumbleforward;				// regular front headshot
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Exposed Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["death"]["stand"]["rifle"]["cover_right_front"]			= array(%corner_standr_deathA, %corner_standr_deathB);
	array[animType]["death"]["crouch"]["rifle"]["cover_right_front"]		= array(%ai_cornercrr_alert_death_back, %ai_cornercrr_alert_death_slideout);

	array[animType]["death"]["stand"]["rifle"]["cover_left_front"]			= array(%corner_standl_deathA, %corner_standl_deathB);
	array[animType]["death"]["crouch"]["rifle"]["cover_left_front"]			= array(%ai_cornercrl_death_back, %ai_cornercrl_death_side);

	array[animType]["death"]["stand"]["rifle"]["cover_stand_front"]			= array(%coverstand_death_left, %coverstand_death_right);

	array[animType]["death"]["stand"]["rifle"]["cover_crouch_front_1"]		= %covercrouch_death_1;
	array[animType]["death"]["stand"]["rifle"]["cover_crouch_front_2"]		= %covercrouch_death_2;
	array[animType]["death"]["stand"]["rifle"]["cover_crouch_back"]			= %covercrouch_death_3;

	array[animType]["death"]["crouch"]["rifle"]["cover_crouch_front_1"]		= %covercrouch_death_1;
	array[animType]["death"]["crouch"]["rifle"]["cover_crouch_front_2"]		= %covercrouch_death_2;
	array[animType]["death"]["crouch"]["rifle"]["cover_crouch_back"]		= %covercrouch_death_3;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Exposed Flame Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["death"]["stand"]["rifle"]["flame_front_1"]				= %ai_flame_death_A;
	array[animType]["death"]["stand"]["rifle"]["flame_front_2"]				= %ai_flame_death_B;
	array[animType]["death"]["stand"]["rifle"]["flame_front_3"]				= %ai_flame_death_C;
	array[animType]["death"]["stand"]["rifle"]["flame_front_4"]				= %ai_flame_death_D;
	array[animType]["death"]["stand"]["rifle"]["flame_front_5"]				= %ai_flame_death_E;
	array[animType]["death"]["stand"]["rifle"]["flame_front_6"]				= %ai_flame_death_F;
	array[animType]["death"]["stand"]["rifle"]["flame_front_7"]				= %ai_flame_death_G;
	array[animType]["death"]["stand"]["rifle"]["flame_front_8"]				= %ai_flame_death_H;
	
	array[animType]["death"]["stand"]["rifle"]["flameA_start"]				= %ai_deadly_wounded_flamedA_hit;
	array[animType]["death"]["stand"]["rifle"]["flameA_loop"]				= %ai_deadly_wounded_flamedA_loop;
	array[animType]["death"]["stand"]["rifle"]["flameA_end"]				= %ai_deadly_wounded_flamedA_die;
	array[animType]["death"]["stand"]["rifle"]["flameB_start"]				= %ai_deadly_wounded_flamedB_hit;
	array[animType]["death"]["stand"]["rifle"]["flameB_loop"]				= %ai_deadly_wounded_flamedB_loop;
	array[animType]["death"]["stand"]["rifle"]["flameB_end"]				= %ai_deadly_wounded_flamedB_die;

	array[animType]["death"]["crouch"]["gas"]["flame_front_1"]				= %ai_flame_death_crouch_a;
	array[animType]["death"]["crouch"]["gas"]["flame_front_2"]				= %ai_flame_death_crouch_b;
	array[animType]["death"]["crouch"]["gas"]["flame_front_3"]				= %ai_flame_death_crouch_c;
	array[animType]["death"]["crouch"]["gas"]["flame_front_4"]				= %ai_flame_death_crouch_d;
	array[animType]["death"]["crouch"]["gas"]["flame_front_5"]				= %ai_flame_death_crouch_e;
	array[animType]["death"]["crouch"]["gas"]["flame_front_6"]				= %ai_flame_death_crouch_f;
	array[animType]["death"]["crouch"]["gas"]["flame_front_7"]				= %ai_flame_death_crouch_g;
	array[animType]["death"]["crouch"]["gas"]["flame_front_8"]				= %ai_flame_death_crouch_h;

	array[animType]["death"]["crouch"]["rifle"]["flame_front_1"]			= %ai_flame_death_crouch_a;
	array[animType]["death"]["crouch"]["rifle"]["flame_front_2"]			= %ai_flame_death_crouch_b;
	array[animType]["death"]["crouch"]["rifle"]["flame_front_3"]			= %ai_flame_death_crouch_c;
	array[animType]["death"]["crouch"]["rifle"]["flame_front_4"]			= %ai_flame_death_crouch_d;
	array[animType]["death"]["crouch"]["rifle"]["flame_front_5"]			= %ai_flame_death_crouch_e;
	array[animType]["death"]["crouch"]["rifle"]["flame_front_6"]			= %ai_flame_death_crouch_f;
	array[animType]["death"]["crouch"]["rifle"]["flame_front_7"]			= %ai_flame_death_crouch_g;
	array[animType]["death"]["crouch"]["rifle"]["flame_front_8"]			= %ai_flame_death_crouch_h;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Exposed Flame Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Exposed Gas Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["death"]["stand"]["rifle"]["gas_front_1"]				= %ai_gas_death_a;
	array[animType]["death"]["stand"]["rifle"]["gas_front_2"]				= %ai_gas_death_b;
	array[animType]["death"]["stand"]["rifle"]["gas_front_3"]				= %ai_gas_death_c;
	array[animType]["death"]["stand"]["rifle"]["gas_front_4"]				= %ai_gas_death_d;
	array[animType]["death"]["stand"]["rifle"]["gas_front_5"]				= %ai_gas_death_e;
	array[animType]["death"]["stand"]["rifle"]["gas_front_6"]				= %ai_gas_death_f;
	array[animType]["death"]["stand"]["rifle"]["gas_front_7"]				= %ai_gas_death_g;
	array[animType]["death"]["stand"]["rifle"]["gas_front_8"]				= %ai_gas_death_h;
	
	array[animType]["death"]["stand"]["rifle"]["gasA_start"]				= %ai_deadly_wounded_gassedA_hit;
	array[animType]["death"]["stand"]["rifle"]["gasA_loop"]					= %ai_deadly_wounded_gassedA_loop;
	array[animType]["death"]["stand"]["rifle"]["gasA_end"]					= %ai_deadly_wounded_gassedA_die;
	array[animType]["death"]["stand"]["rifle"]["gasB_start"]				= %ai_deadly_wounded_gassedB_hit;
	array[animType]["death"]["stand"]["rifle"]["gasB_loop"]					= %ai_deadly_wounded_gassedB_loop;
	array[animType]["death"]["stand"]["rifle"]["gasB_end"]					= %ai_deadly_wounded_gassedB_die;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Exposed Gas Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Exposed Gib Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["death"]["stand"]["rifle"]["gib_guts_start"]			= %ai_gib_torso_gib;
	array[animType]["death"]["stand"]["rifle"]["gib_guts_loop"]				= %ai_gib_torso_loop;
	array[animType]["death"]["stand"]["rifle"]["gib_guts_end"]				= %ai_gib_torso_death;

	array[animType]["death"]["stand"]["rifle"]["gib_no_legs_start"]			= %ai_gib_bothlegs_gib;
	array[animType]["death"]["stand"]["rifle"]["gib_no_legs_loop"]			= %ai_gib_bothlegs_loop;
	array[animType]["death"]["stand"]["rifle"]["gib_no_legs_end"]			= %ai_gib_bothlegs_death;

	array[animType]["death"]["stand"]["rifle"]["gib_left_leg_front_start"]	= %ai_gib_leftleg_front_gib;
	array[animType]["death"]["stand"]["rifle"]["gib_left_leg_front_loop"]	= %ai_gib_leftleg_front_loop;
	array[animType]["death"]["stand"]["rifle"]["gib_left_leg_front_end"]	= %ai_gib_leftleg_front_death;

	array[animType]["death"]["stand"]["rifle"]["gib_left_leg_back_start"]	= %ai_gib_leftleg_back_gib;
	array[animType]["death"]["stand"]["rifle"]["gib_left_leg_back_loop"]	= %ai_gib_leftleg_back_loop;
	array[animType]["death"]["stand"]["rifle"]["gib_left_leg_back_end"]		= %ai_gib_leftleg_back_death;

	array[animType]["death"]["stand"]["rifle"]["gib_right_leg_front_start"]	= %ai_gib_rightleg_front_gib;
	array[animType]["death"]["stand"]["rifle"]["gib_right_leg_front_loop"]	= %ai_gib_rightleg_front_loop;
	array[animType]["death"]["stand"]["rifle"]["gib_right_leg_front_end"]	= %ai_gib_rightleg_front_death;

	array[animType]["death"]["stand"]["rifle"]["gib_right_leg_back_start"]	= %ai_gib_rightleg_back_gib;
	array[animType]["death"]["stand"]["rifle"]["gib_right_leg_back_loop"]	= %ai_gib_rightleg_back_loop;
	array[animType]["death"]["stand"]["rifle"]["gib_right_leg_back_end"]	= %ai_gib_rightleg_back_death;

	array[animType]["death"]["stand"]["rifle"]["gib_left_arm_front_start"]	= %ai_gib_leftarm_front_gib;
	array[animType]["death"]["stand"]["rifle"]["gib_left_arm_front_loop"]	= %ai_gib_leftarm_front_loop;
	array[animType]["death"]["stand"]["rifle"]["gib_left_arm_front_end"]	= %ai_gib_leftarm_front_death;

	array[animType]["death"]["stand"]["rifle"]["gib_left_arm_back_start"]	= %ai_gib_leftarm_back_gib;
	array[animType]["death"]["stand"]["rifle"]["gib_left_arm_back_loop"]	= %ai_gib_leftarm_back_loop;
	array[animType]["death"]["stand"]["rifle"]["gib_left_arm_back_end"]		= %ai_gib_leftarm_back_death;

	array[animType]["death"]["stand"]["rifle"]["gib_right_arm_front_start"]	= %ai_gib_rightarm_front_gib;
	array[animType]["death"]["stand"]["rifle"]["gib_right_arm_front_loop"]	= %ai_gib_rightarm_front_loop;
	array[animType]["death"]["stand"]["rifle"]["gib_right_arm_front_end"]	= %ai_gib_rightarm_front_death;

	array[animType]["death"]["stand"]["rifle"]["gib_right_arm_back_start"]	= %ai_gib_rightarm_back_gib;
	array[animType]["death"]["stand"]["rifle"]["gib_right_arm_back_loop"]	= %ai_gib_rightarm_back_loop;
	array[animType]["death"]["stand"]["rifle"]["gib_right_arm_back_end"]	= %ai_gib_rightarm_back_death;

	array[animType]["death"]["crouch"]["rifle"]["gib_guts_start"]			= %ai_gib_torso_gib;
	array[animType]["death"]["crouch"]["rifle"]["gib_guts_loop"]			= %ai_gib_torso_loop;
	array[animType]["death"]["crouch"]["rifle"]["gib_guts_end"]				= %ai_gib_torso_death;

	array[animType]["death"]["crouch"]["rifle"]["gib_no_legs_start"]		= %ai_gib_bothlegs_gib;
	array[animType]["death"]["crouch"]["rifle"]["gib_no_legs_loop"]			= %ai_gib_bothlegs_loop;
	array[animType]["death"]["crouch"]["rifle"]["gib_no_legs_end"]			= %ai_gib_bothlegs_death;

	array[animType]["death"]["crouch"]["rifle"]["gib_left_leg_front_start"]	= %ai_gib_leftleg_front_gib;
	array[animType]["death"]["crouch"]["rifle"]["gib_left_leg_front_loop"]	= %ai_gib_leftleg_front_loop;
	array[animType]["death"]["crouch"]["rifle"]["gib_left_leg_front_end"]	= %ai_gib_leftleg_front_death;

	array[animType]["death"]["crouch"]["rifle"]["gib_left_leg_back_start"]	= %ai_gib_leftleg_back_gib;
	array[animType]["death"]["crouch"]["rifle"]["gib_left_leg_back_loop"]	= %ai_gib_leftleg_back_loop;
	array[animType]["death"]["crouch"]["rifle"]["gib_left_leg_back_end"]	= %ai_gib_leftleg_back_death;

	array[animType]["death"]["crouch"]["rifle"]["gib_right_leg_front_start"]= %ai_gib_rightleg_front_gib;
	array[animType]["death"]["crouch"]["rifle"]["gib_right_leg_front_loop"]	= %ai_gib_rightleg_front_loop;
	array[animType]["death"]["crouch"]["rifle"]["gib_right_leg_front_end"]	= %ai_gib_rightleg_front_death;

	array[animType]["death"]["crouch"]["rifle"]["gib_right_leg_back_start"]	= %ai_gib_rightleg_back_gib;
	array[animType]["death"]["crouch"]["rifle"]["gib_right_leg_back_loop"]	= %ai_gib_rightleg_back_loop;
	array[animType]["death"]["crouch"]["rifle"]["gib_right_leg_back_end"]	= %ai_gib_rightleg_back_death;

	array[animType]["death"]["crouch"]["rifle"]["gib_left_arm_front_start"]	= %ai_gib_leftarm_front_gib;
	array[animType]["death"]["crouch"]["rifle"]["gib_left_arm_front_loop"]	= %ai_gib_leftarm_front_loop;
	array[animType]["death"]["crouch"]["rifle"]["gib_left_arm_front_end"]	= %ai_gib_leftarm_front_death;

	array[animType]["death"]["crouch"]["rifle"]["gib_left_arm_back_start"]	= %ai_gib_leftarm_back_gib;
	array[animType]["death"]["crouch"]["rifle"]["gib_left_arm_back_loop"]	= %ai_gib_leftarm_back_loop;
	array[animType]["death"]["crouch"]["rifle"]["gib_left_arm_back_end"]	= %ai_gib_leftarm_back_death;

	array[animType]["death"]["crouch"]["rifle"]["gib_right_arm_front_start"]= %ai_gib_rightarm_front_gib;
	array[animType]["death"]["crouch"]["rifle"]["gib_right_arm_front_loop"]	= %ai_gib_rightarm_front_loop;
	array[animType]["death"]["crouch"]["rifle"]["gib_right_arm_front_end"]	= %ai_gib_rightarm_front_death;

	array[animType]["death"]["crouch"]["rifle"]["gib_right_arm_back_start"]	= %ai_gib_rightarm_back_gib;
	array[animType]["death"]["crouch"]["rifle"]["gib_right_arm_back_loop"]	= %ai_gib_rightarm_back_loop;
	array[animType]["death"]["crouch"]["rifle"]["gib_right_arm_back_end"]	= %ai_gib_rightarm_back_death;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Exposed Gib Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Exposed Explosive Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["death"]["stand"]["rifle"]["explode_up_1"]				= %death_explosion_stand_UP_v1;
	array[animType]["death"]["stand"]["rifle"]["explode_up_2"]				= %death_explosion_stand_UP_v2;

	array[animType]["death"]["stand"]["rifle"]["explode_front_1"]			= %death_explosion_stand_B_v1;
	array[animType]["death"]["stand"]["rifle"]["explode_front_2"]			= %death_explosion_stand_B_v2;
	array[animType]["death"]["stand"]["rifle"]["explode_front_3"]			= %death_explosion_stand_B_v3;
	array[animType]["death"]["stand"]["rifle"]["explode_front_4"]			= %death_explosion_stand_B_v4;

	array[animType]["death"]["stand"]["rifle"]["explode_right_1"]			= %death_explosion_stand_L_v1;
	array[animType]["death"]["stand"]["rifle"]["explode_right_2"]			= %death_explosion_stand_L_v2;
	array[animType]["death"]["stand"]["rifle"]["explode_right_3"]			= %death_explosion_stand_L_v3;

	array[animType]["death"]["stand"]["rifle"]["explode_back_1"]			= %death_explosion_stand_F_v1;
	array[animType]["death"]["stand"]["rifle"]["explode_back_2"]			= %death_explosion_stand_F_v2;
	array[animType]["death"]["stand"]["rifle"]["explode_back_3"]			= %death_explosion_stand_F_v3;
	array[animType]["death"]["stand"]["rifle"]["explode_back_4"]			= %death_explosion_stand_F_v3;

	array[animType]["death"]["stand"]["rifle"]["explode_left_1"]			= %death_explosion_stand_R_v1;
	array[animType]["death"]["stand"]["rifle"]["explode_left_2"]			= %death_explosion_stand_R_v2;

	array[animType]["death"]["crouch"]["rifle"]["explode_up_1"]				= %death_explosion_stand_UP_v1;
	array[animType]["death"]["crouch"]["rifle"]["explode_up_2"]				= %death_explosion_stand_UP_v2;

	array[animType]["death"]["crouch"]["rifle"]["explode_front_1"]			= %death_explosion_stand_B_v1;
	array[animType]["death"]["crouch"]["rifle"]["explode_front_2"]			= %death_explosion_stand_B_v2;
	array[animType]["death"]["crouch"]["rifle"]["explode_front_3"]			= %death_explosion_stand_B_v3;
	array[animType]["death"]["crouch"]["rifle"]["explode_front_4"]			= %death_explosion_stand_B_v4;

	array[animType]["death"]["crouch"]["rifle"]["explode_right_1"]			= %death_explosion_stand_L_v1;
	array[animType]["death"]["crouch"]["rifle"]["explode_right_2"]			= %death_explosion_stand_L_v2;
	array[animType]["death"]["crouch"]["rifle"]["explode_right_3"]			= %death_explosion_stand_L_v3;

	array[animType]["death"]["crouch"]["rifle"]["explode_back_1"]			= %death_explosion_stand_F_v1;
	array[animType]["death"]["crouch"]["rifle"]["explode_back_2"]			= %death_explosion_stand_F_v2;
	array[animType]["death"]["crouch"]["rifle"]["explode_back_3"]			= %death_explosion_stand_F_v3;
	array[animType]["death"]["crouch"]["rifle"]["explode_back_4"]			= %death_explosion_stand_F_v3;

	array[animType]["death"]["crouch"]["rifle"]["explode_left_1"]			= %death_explosion_stand_R_v1;
	array[animType]["death"]["crouch"]["rifle"]["explode_left_2"]			= %death_explosion_stand_R_v2;

	array[animType]["death"]["prone"]["rifle"]["explode_up_1"]				= %death_explosion_stand_UP_v1;
	array[animType]["death"]["prone"]["rifle"]["explode_up_2"]				= %death_explosion_stand_UP_v2;

	array[animType]["death"]["prone"]["rifle"]["explode_front_1"]			= %death_explosion_stand_B_v1;
	array[animType]["death"]["prone"]["rifle"]["explode_front_2"]			= %death_explosion_stand_B_v2;
	array[animType]["death"]["prone"]["rifle"]["explode_front_3"]			= %death_explosion_stand_B_v3;
	array[animType]["death"]["prone"]["rifle"]["explode_front_4"]			= %death_explosion_stand_B_v4;

	array[animType]["death"]["prone"]["rifle"]["explode_right_1"]			= %death_explosion_stand_L_v1;
	array[animType]["death"]["prone"]["rifle"]["explode_right_2"]			= %death_explosion_stand_L_v2;
	array[animType]["death"]["prone"]["rifle"]["explode_right_3"]			= %death_explosion_stand_L_v3;

	array[animType]["death"]["prone"]["rifle"]["explode_back_1"]			= %death_explosion_stand_F_v1;
	array[animType]["death"]["prone"]["rifle"]["explode_back_2"]			= %death_explosion_stand_F_v2;
	array[animType]["death"]["prone"]["rifle"]["explode_back_3"]			= %death_explosion_stand_F_v3;
	array[animType]["death"]["prone"]["rifle"]["explode_back_4"]			= %death_explosion_stand_F_v3;

	array[animType]["death"]["prone"]["rifle"]["explode_left_1"]			= %death_explosion_stand_R_v1;
	array[animType]["death"]["prone"]["rifle"]["explode_left_2"]			= %death_explosion_stand_R_v2;

	array[animType]["death"]["back"]["rifle"]["explode_up_1"]				= %death_explosion_stand_UP_v1;
	array[animType]["death"]["back"]["rifle"]["explode_up_2"]				= %death_explosion_stand_UP_v2;

	array[animType]["death"]["back"]["rifle"]["explode_front_1"]			= %death_explosion_stand_B_v1;
	array[animType]["death"]["back"]["rifle"]["explode_front_2"]			= %death_explosion_stand_B_v2;
	array[animType]["death"]["back"]["rifle"]["explode_front_3"]			= %death_explosion_stand_B_v3;
	array[animType]["death"]["back"]["rifle"]["explode_front_4"]			= %death_explosion_stand_B_v4;

	array[animType]["death"]["back"]["rifle"]["explode_right_1"]			= %death_explosion_stand_L_v1;
	array[animType]["death"]["back"]["rifle"]["explode_right_2"]			= %death_explosion_stand_L_v2;
	array[animType]["death"]["back"]["rifle"]["explode_right_3"]			= %death_explosion_stand_L_v3;

	array[animType]["death"]["back"]["rifle"]["explode_back_1"]				= %death_explosion_stand_F_v1;
	array[animType]["death"]["back"]["rifle"]["explode_back_2"]				= %death_explosion_stand_F_v2;
	array[animType]["death"]["back"]["rifle"]["explode_back_3"]				= %death_explosion_stand_F_v3;
	array[animType]["death"]["back"]["rifle"]["explode_back_4"]				= %death_explosion_stand_F_v3;

	array[animType]["death"]["back"]["rifle"]["explode_left_1"]				= %death_explosion_stand_R_v1;
	array[animType]["death"]["back"]["rifle"]["explode_left_2"]				= %death_explosion_stand_R_v2;

	array[animType]["death"]["stand"]["rifle"]["explode_run_front_1"]		= %death_explosion_run_B_v1;
	array[animType]["death"]["stand"]["rifle"]["explode_run_front_2"]		= %death_explosion_run_B_v2;

	array[animType]["death"]["stand"]["rifle"]["explode_run_right_1"]		= %death_explosion_run_L_v1;
	array[animType]["death"]["stand"]["rifle"]["explode_run_right_2"]		= %death_explosion_run_L_v2;

	array[animType]["death"]["stand"]["rifle"]["explode_run_left_1"]		= %death_explosion_run_R_v1;
	array[animType]["death"]["stand"]["rifle"]["explode_run_left_2"]		= %death_explosion_run_R_v2;

	array[animType]["death"]["stand"]["rifle"]["explode_run_back_1"]		= %death_explosion_run_F_v1;
	array[animType]["death"]["stand"]["rifle"]["explode_run_back_2"]		= %death_explosion_run_F_v2;
	array[animType]["death"]["stand"]["rifle"]["explode_run_back_3"]		= %death_explosion_run_F_v3;
	array[animType]["death"]["stand"]["rifle"]["explode_run_back_4"]		= %death_explosion_run_F_v4;

	array[animType]["death"]["crouch"]["rifle"]["explode_run_front_1"]		= %death_explosion_run_B_v1;
	array[animType]["death"]["crouch"]["rifle"]["explode_run_front_2"]		= %death_explosion_run_B_v2;

	array[animType]["death"]["crouch"]["rifle"]["explode_run_right_1"]		= %death_explosion_run_L_v1;
	array[animType]["death"]["crouch"]["rifle"]["explode_run_right_2"]		= %death_explosion_run_L_v2;

	array[animType]["death"]["crouch"]["rifle"]["explode_run_left_1"]		= %death_explosion_run_R_v1;
	array[animType]["death"]["crouch"]["rifle"]["explode_run_left_2"]		= %death_explosion_run_R_v2;

	array[animType]["death"]["crouch"]["rifle"]["explode_run_back_1"]		= %death_explosion_run_F_v1;
	array[animType]["death"]["crouch"]["rifle"]["explode_run_back_2"]		= %death_explosion_run_F_v2;
	array[animType]["death"]["crouch"]["rifle"]["explode_run_back_3"]		= %death_explosion_run_F_v3;
	array[animType]["death"]["crouch"]["rifle"]["explode_run_back_4"]		= %death_explosion_run_F_v4;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Exposed Explosive Deaths
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Flashbanged Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["flashed"]["stand"]["rifle"]["flashed"]					= array( %exposed_flashbang_v1, %exposed_flashbang_v2, %exposed_flashbang_v3, %exposed_flashbang_v4, %exposed_flashbang_v5 );
	array[animType]["flashed"]["crouch"]["rifle"]["flashed"]				= array( %exposed_flashbang_v1, %exposed_flashbang_v2, %exposed_flashbang_v3, %exposed_flashbang_v4, %exposed_flashbang_v5 );
	array[animType]["flashed"]["prone"]["rifle"]["flashed"]					= array( %exposed_flashbang_v1, %exposed_flashbang_v2, %exposed_flashbang_v3, %exposed_flashbang_v4, %exposed_flashbang_v5 );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Flashbanged Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Grenade Cower Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["grenadecower"]["stand"]["rifle"]["cower_start"]		= %exposed_squat_down_grenade_F;
	array[animType]["grenadecower"]["stand"]["rifle"]["dive_backward"]		= %exposed_dive_grenade_F;
	array[animType]["grenadecower"]["stand"]["rifle"]["dive_forward"]		= %exposed_dive_grenade_B;

	array[animType]["grenadecower"]["crouch"]["rifle"]["cower_idle"]		= %exposed_squat_idle_grenade_F;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Grenade Cower Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Grenade Return Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["grenade_return_throw"]["stand"]["rifle"]["throw_short"]		= %grenade_return_running_throw_forward;
	array[animType]["grenade_return_throw"]["stand"]["rifle"]["throw_medium"]		= %grenade_return_standing_throw_forward_1;
	array[animType]["grenade_return_throw"]["stand"]["rifle"]["throw_far"]			= %grenade_return_standing_throw_forward_2;
	array[animType]["grenade_return_throw"]["stand"]["rifle"]["throw_very_far"]		= %grenade_return_standing_throw_overhand_forward;

	array[animType]["grenade_return_throw"]["crouch"]["rifle"]["throw_short"]		= %grenade_return_running_throw_forward;
	array[animType]["grenade_return_throw"]["crouch"]["rifle"]["throw_medium"]		= %grenade_return_standing_throw_forward_1;
	array[animType]["grenade_return_throw"]["crouch"]["rifle"]["throw_far"]			= %grenade_return_standing_throw_forward_2;
	array[animType]["grenade_return_throw"]["crouch"]["rifle"]["throw_very_far"]	= %grenade_return_standing_throw_overhand_forward;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Grenade Return Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Turn Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// run forward turns
	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_45"]				= %ai_run_lowready_f_turn_45_l;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_90"]				= %ai_run_lowready_f_turn_90_l;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_135"]				= %ai_run_lowready_f_turn_135_l;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_180"]				= %ai_run_lowready_f_turn_180_l_02;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_45"]				= %ai_run_lowready_f_turn_45_r;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_90"]				= %ai_run_lowready_f_turn_90_r;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_135"]				= %ai_run_lowready_f_turn_135_r;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_180"]				= %ai_run_lowready_f_turn_180_r_02;

	// CQB forward turns
	// SUMEET_TODO - Get 180L and 180R versions
	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_45_cqb"]			= %CQB_walk_turn_7;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_90_cqb"]			= %CQB_walk_turn_4;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_180_cqb"]			= %CQB_walk_turn_2;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_45_cqb"]			= %CQB_walk_turn_9;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_90_cqb"]			= %CQB_walk_turn_6;
	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_180_cqb"]			= %CQB_walk_turn_2;

// sprint forward turns - using regular turns for sprint as well as they are faster, support 135l/r and this also saves memory.
//	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_45_sprint"]			= %ai_sprint_turn_45_l;
//	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_90_sprint"]			= %ai_sprint_turn_90_l;
//	array[animType]["turn"]["stand"]["rifle"]["turn_f_l_180_sprint"]		= %ai_sprint_turn_180_l;
//	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_45_sprint"]			= %ai_sprint_turn_45_r;
//	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_90_sprint"]			= %ai_sprint_turn_90_r;
//	array[animType]["turn"]["stand"]["rifle"]["turn_f_r_180_sprint"]		= %ai_sprint_turn_180_r;

	// run backward turns
	array[animType]["turn"]["stand"]["rifle"]["turn_b_l_180"]				= %ai_run_b2f;
	array[animType]["turn"]["stand"]["rifle"]["turn_b_r_180"]				= %ai_run_b2f_a;

	// cqb run backwards turns
	array[animType]["turn"]["stand"]["rifle"]["turn_b_l_180_cqb"]			= %ai_cqb_run_b_2_f_left;
	array[animType]["turn"]["stand"]["rifle"]["turn_b_r_180_cqb"]			= %ai_cqb_run_b_2_f_right;

	array[animType]["turn"]["stand"]["rifle"]["turn_b_l_180_sprint"]		= %ai_run_b2f;
	array[animType]["turn"]["stand"]["rifle"]["turn_b_r_180_sprint"]		= %ai_run_b2f_a;

	// aims
	array[animType]["turn"]["stand"]["rifle"]["add_aim_up"]					= %ai_run_f_aim_8;
	array[animType]["turn"]["stand"]["rifle"]["add_aim_down"]				= %ai_run_f_aim_2;
	array[animType]["turn"]["stand"]["rifle"]["add_aim_left"]				= %ai_run_f_aim_4;
	array[animType]["turn"]["stand"]["rifle"]["add_aim_right"]				= %ai_run_f_aim_6;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Turn Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["rifle"]["dive_over_40"]				= %ai_dive_over_40;

//  These are all legacy/inherited and missing for now
//	array[animType]["move"]["stand"]["rifle"]["fenceclimb"]					= %fenceclimb;

//	array[animType]["move"]["stand"]["rifle"]["fenceover_start"]			= %ladder_climbon_bottom_walk;
//	array[animType]["move"]["stand"]["rifle"]["fenceover_start2"]			= %ladder_climbon;
//	array[animType]["move"]["stand"]["rifle"]["fenceover_climb"]			= %ladder_climbup;
//	array[animType]["move"]["stand"]["rifle"]["fenceover_down"]				= %ladder_climbdown;
//	array[animType]["move"]["stand"]["rifle"]["fenceover_end"]				= %ladder_climboff;

//	array[animType]["move"]["stand"]["rifle"]["window_climb_start"]			= %windowclimb_fall;
//	array[animType]["move"]["stand"]["rifle"]["window_climb_end"]			= %windowclimb_land;

	array[animType]["move"]["stand"]["rifle"]["jump_across_72"]				= %ai_jump_across_72;
	array[animType]["move"]["stand"]["rifle"]["jump_across_120"]			= %ai_jump_across_120;

	array[animType]["move"]["stand"]["rifle"]["jump_down_36"]				= %ai_jump_down_36;
	array[animType]["move"]["stand"]["rifle"]["jump_down_40"]				= %ai_jump_down_40;
	array[animType]["move"]["stand"]["rifle"]["jump_down_56"]				= %ai_jump_down_56;
	array[animType]["move"]["stand"]["rifle"]["jump_down_96"]				= %ai_jump_down_96;

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

	array[animType]["move"]["stand"]["rifle"]["climbstairs_down"]			= %climbstairs_down;
	array[animType]["move"]["stand"]["rifle"]["climbstairs_down_armed"]		= %climbstairs_down_armed;
	
	array[animType]["move"]["stand"]["rifle"]["hill_down_20"] = %ai_run_slope_down_20;
	array[animType]["move"]["stand"]["rifle"]["hill_down_in_20"] = %ai_run_slope_down_20_in;
	array[animType]["move"]["stand"]["rifle"]["hill_down_out_20"] = %ai_run_slope_down_20_out;
	array[animType]["move"]["stand"]["rifle"]["hill_down_25"] = %ai_run_slope_down_25;
	array[animType]["move"]["stand"]["rifle"]["hill_down_in_25"] = %ai_run_slope_down_25_in;
	array[animType]["move"]["stand"]["rifle"]["hill_down_out_25"] = %ai_run_slope_down_25_out;
	array[animType]["move"]["stand"]["rifle"]["hill_down_30"] = %ai_run_slope_down_30;
	array[animType]["move"]["stand"]["rifle"]["hill_down_in_30"] = %ai_run_slope_down_30_in;
	array[animType]["move"]["stand"]["rifle"]["hill_down_out_30"] = %ai_run_slope_down_30_out;
	array[animType]["move"]["stand"]["rifle"]["hill_down_35"] = %ai_run_slope_down_35;
	array[animType]["move"]["stand"]["rifle"]["hill_down_in_35"] = %ai_run_slope_down_35_in;
	array[animType]["move"]["stand"]["rifle"]["hill_down_out_35"] = %ai_run_slope_down_35_out;
	array[animType]["move"]["stand"]["rifle"]["hill_up_20"] = %ai_run_slope_up_20;
	array[animType]["move"]["stand"]["rifle"]["hill_up_in_20"] = %ai_run_slope_up_20_in;
	array[animType]["move"]["stand"]["rifle"]["hill_up_out_20"] = %ai_run_slope_up_20_out;
	array[animType]["move"]["stand"]["rifle"]["hill_up_25"] = %ai_run_slope_up_25;
	array[animType]["move"]["stand"]["rifle"]["hill_up_in_25"] = %ai_run_slope_up_25_in;
	array[animType]["move"]["stand"]["rifle"]["hill_up_out_25"] = %ai_run_slope_up_25_out;
	array[animType]["move"]["stand"]["rifle"]["hill_up_30"] = %ai_run_slope_up_30;
	array[animType]["move"]["stand"]["rifle"]["hill_up_in_30"] = %ai_run_slope_up_30_in;
	array[animType]["move"]["stand"]["rifle"]["hill_up_out_30"] = %ai_run_slope_up_30_out;
	array[animType]["move"]["stand"]["rifle"]["hill_up_35"] = %ai_run_slope_up_35;
	array[animType]["move"]["stand"]["rifle"]["hill_up_in_35"] = %ai_run_slope_up_35_in;
	array[animType]["move"]["stand"]["rifle"]["hill_up_out_35"] = %ai_run_slope_up_35_out;

	/* STAIRS 8x8 ----------------------------------------------------------
	---------------------------------------------------------------------- */
	/* UP */
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x8_in"]			= %ai_staircase_sprint_up_8x8_in;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x8_in_even"]		= %ai_staircase_sprint_up_8x8_in_even;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x8_out"]			= %ai_staircase_sprint_up_8x8_out;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x8_2"]			= %ai_staircase_sprint_up_8x8_1;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x8_4"]			= %ai_staircase_sprint_up_8x8_2;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x8_6"]			= %ai_staircase_sprint_up_8x8_3;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x8_7"]			= %ai_staircase_sprint_up_8x8_4;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x8_10"]			= %ai_staircase_sprint_up_8x8_5;

	/* DOWN */
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x8_in"]		= %ai_staircase_sprint_down_8x8_in;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x8_out"]		= %ai_staircase_sprint_down_8x8_out;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x8_out_even"]	= %ai_staircase_sprint_down_8x8_out_even;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x8_2"]			= %ai_staircase_sprint_down_8x8_1;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x8_4"]			= %ai_staircase_sprint_down_8x8_2;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x8_6"]			= %ai_staircase_sprint_down_8x8_3;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x8_8"]			= %ai_staircase_sprint_down_8x8_4;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x8_10"]		= %ai_staircase_sprint_down_8x8_5;

	/* STAIRS 8x12 ----------------------------------------------------------
	---------------------------------------------------------------------- */
	/* UP */
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_in"]			= %ai_staircase_run_up_8x12_in;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_in_even"]		= %ai_staircase_run_up_8x12_in_even;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_out"]			= %ai_staircase_run_up_8x12_out;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_2"]			= %ai_staircase_run_up_8x12_1;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_4"]			= %ai_staircase_run_up_8x12_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_6"]			= %ai_staircase_run_up_8x12_3;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_8"]			= %ai_staircase_run_up_8x12_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x12_10"]			= %ai_staircase_run_up_8x12_5;

	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_in"]			= %ai_staircase_sprint_up_8x12_in;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_in_even"]	= %ai_staircase_sprint_up_8x12_in_even;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_out"]		= %ai_staircase_sprint_up_8x12_out;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_2"]			= %ai_staircase_sprint_up_8x12_1;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_4"]			= %ai_staircase_sprint_up_8x12_2;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_6"]			= %ai_staircase_sprint_up_8x12_3;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_7"]			= %ai_staircase_sprint_up_8x12_4;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x12_10"]			= %ai_staircase_sprint_up_8x12_5;

	/* DOWN */
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_in"]			= %ai_staircase_run_down_8x12_in;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_out"]		= %ai_staircase_run_down_8x12_out;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_out_even"]	= %ai_staircase_run_down_8x12_out_even;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_2"]			= %ai_staircase_run_down_8x12_1;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_4"]			= %ai_staircase_run_down_8x12_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_6"]			= %ai_staircase_run_down_8x12_3;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_8"]			= %ai_staircase_run_down_8x12_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x12_10"]			= %ai_staircase_run_down_8x12_5;

	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_in"]		= %ai_staircase_sprint_down_8x12_in;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_out"]		= %ai_staircase_sprint_down_8x12_out;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_out_even"]	= %ai_staircase_sprint_down_8x12_out_even;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_2"]		= %ai_staircase_sprint_down_8x12_1;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_4"]		= %ai_staircase_sprint_down_8x12_2;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_6"]		= %ai_staircase_sprint_down_8x12_3;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_8"]		= %ai_staircase_sprint_down_8x12_4;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x12_10"]		= %ai_staircase_sprint_down_8x12_5;

	/* STAIRS 8x16 ----------------------------------------------------------
	---------------------------------------------------------------------- */
	/* UP */
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_in"]			= %ai_staircase_run_up_8x16_in;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_in_even"]		= %ai_staircase_run_up_8x16_in_even;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_out"]			= %ai_staircase_run_up_8x16_out;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_2"]			= %ai_staircase_run_up_8x16_1;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_4"]			= %ai_staircase_run_up_8x16_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_6"]			= %ai_staircase_run_up_8x16_3;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_8"]			= %ai_staircase_run_up_8x16_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_up_8x16_10"]			= %ai_staircase_run_up_8x16_5;

	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_in"]			= %ai_staircase_sprint_up_8x16_in;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_in_even"]	= %ai_staircase_sprint_up_8x16_in_even;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_out"]		= %ai_staircase_sprint_up_8x16_out;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_2"]			= %ai_staircase_sprint_up_8x16_1;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_4"]			= %ai_staircase_sprint_up_8x16_2;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_6"]			= %ai_staircase_sprint_up_8x16_3;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_8"]			= %ai_staircase_sprint_up_8x16_4;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_up_8x16_10"]			= %ai_staircase_sprint_up_8x16_5;

	/* DOWN */
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_in"]			= %ai_staircase_run_down_8x16_in;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_out"]		= %ai_staircase_run_down_8x16_out;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_out_even"]	= %ai_staircase_run_down_8x16_out_even;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_2"]			= %ai_staircase_run_down_8x16_1;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_4"]			= %ai_staircase_run_down_8x16_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_6"]			= %ai_staircase_run_down_8x16_3;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_8"]			= %ai_staircase_run_down_8x16_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_down_8x16_10"]			= %ai_staircase_run_down_8x16_5;

	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_in"]		= %ai_staircase_sprint_down_8x16_in;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_out"]		= %ai_staircase_sprint_down_8x16_out;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_out_even"]	= %ai_staircase_sprint_down_8x16_out_even;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_2"]		= %ai_staircase_sprint_down_8x16_1;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_4"]		= %ai_staircase_sprint_down_8x16_2;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_6"]		= %ai_staircase_sprint_down_8x16_3;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_8"]		= %ai_staircase_sprint_down_8x16_4;
	array[animType]["sprint"]["stand"]["rifle"]["staircase_down_8x16_10"]		= %ai_staircase_sprint_down_8x16_5;

	/* AIMING */
	array[animType]["move"]["stand"]["rifle"]["staircase_aim_up"]				= %ai_stair_run_f_aim_8;
	array[animType]["move"]["stand"]["rifle"]["staircase_aim_down"]				= %ai_stair_run_f_aim_2;
	array[animType]["move"]["stand"]["rifle"]["staircase_aim_left"]				= %ai_stair_run_f_aim_4;
	array[animType]["move"]["stand"]["rifle"]["staircase_aim_right"]			= %ai_stair_run_f_aim_6;

	array[animType]["move"]["stand"]["rifle"]["step_up"]						= %step_up_low_wall;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Unarmed Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/* STAIRS 8x12 ----------------------------------------------------------
	---------------------------------------------------------------------- */
	/* UP */
	array[animType]["sprint"]["stand"]["none"]["staircase_up_8x12_in"]			= %ai_staircase_sprint_unarmed_up_8x12_in;
	array[animType]["sprint"]["stand"]["none"]["staircase_up_8x12_in_even"]		= %ai_staircase_sprint_unarmed_up_8x12_in_even;
	array[animType]["sprint"]["stand"]["none"]["staircase_up_8x12_out"]			= %ai_staircase_sprint_unarmed_up_8x12_out;
	array[animType]["sprint"]["stand"]["none"]["staircase_up_8x12_2"]			= %ai_staircase_sprint_unarmed_up_8x12_1;
	array[animType]["sprint"]["stand"]["none"]["staircase_up_8x12_4"]			= %ai_staircase_sprint_unarmed_up_8x12_2;
	array[animType]["sprint"]["stand"]["none"]["staircase_up_8x12_6"]			= %ai_staircase_sprint_unarmed_up_8x12_3;
	array[animType]["sprint"]["stand"]["none"]["staircase_up_8x12_8"]			= %ai_staircase_sprint_unarmed_up_8x12_4;
	array[animType]["sprint"]["stand"]["none"]["staircase_up_8x12_10"]			= %ai_staircase_sprint_unarmed_up_8x12_5;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Unarmed Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Pistol Traversals
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/* STAIRS 8x12 ----------------------------------------------------------
	---------------------------------------------------------------------- */
	/* UP */

	/* looks like crap
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Aim Awareness
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// SUMEET_TODO - Remove these animations
//	array[animType]["combat"]["stand"]["rifle"]["aim_aware_reaction"]		= array( %ai_spets_aim_aware_stand_1_a,
//																					 %ai_spets_aim_aware_stand_1_b,
//																					 %ai_spets_aim_aware_stand_3_a,
//																					 %ai_spets_aim_aware_stand_3_b,
//																					 %ai_spets_aim_aware_stand_4_a,
//																					 %ai_spets_aim_aware_stand_4_b,
//																					 %ai_spets_aim_aware_stand_6_a,
//																					 %ai_spets_aim_aware_stand_6_b,
//																					 %ai_spets_aim_aware_stand_7_a,
//																					 %ai_spets_aim_aware_stand_7_b,
//																					 %ai_spets_aim_aware_stand_9_a,
//																					 %ai_spets_aim_aware_stand_9_b );
//
//	array[animType]["combat"]["crouch"]["rifle"]["aim_aware_reaction"]		= array( %ai_spets_aim_aware_crouch_1_a,
//																					 %ai_spets_aim_aware_crouch_3_a,
//																					 %ai_spets_aim_aware_crouch_4_a,
//																					 %ai_spets_aim_aware_crouch_6_a,
//																					 %ai_spets_aim_aware_crouch_7_a,
//																					 %ai_spets_aim_aware_crouch_9_a );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Aim Awareness
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// add pistol anims
	if( IS_TRUE(level.supportsPistolAnimations) )
	{
		array = animscripts\anims_table_pistol::setup_pistol_anim_array( animType, array );
	}

	return array;
}

setup_barnes_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );

	// replace the base run
	array[animType]["move"]["stand"]["rifle"]["combat_run_f"]						= %ai_barnes_run_f;

	return array;
}

setup_reznov_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );

	// replace the base run
	array[animType]["move"]["stand"]["rifle"]["combat_run_f"]						= %ai_reznov_run_f;

	return array;
}

setup_anim_array( animType )
{
	assert( IsDefined(anim.anim_array) && IsArray(anim.anim_array) );

	// check if it's already been initialized
	if( IsDefined(anim.anim_array[animType]) )
	{
		return;
	}

	switch( animType )
	{
		case "default":
			anim.anim_array = setup_default_anim_array( animType, anim.anim_array );
			break;

		case "civilian":
			anim.anim_array = animscripts\anims_table_civilian::setup_civilian_anim_array( animType, anim.anim_array );
			break;
		
		case "female":
			//anim.anim_array = animscripts\anims_table_fem::setup_female_anim_array( animType, anim.anim_array );
			break;

		case "woods":
		case "barnes":
			anim.anim_array = setup_barnes_anim_array( animType, anim.anim_array );
			break;
		
		case "reznov":
			anim.anim_array = setup_reznov_anim_array( animType, anim.anim_array );
			break;

		case "vc":
			anim.anim_array = animscripts\anims_table_vc::setup_vc_anim_array( animType, anim.anim_array );
			break;

		case "digbat":
			anim.anim_array = animscripts\anims_table_digbats::setup_digbat_anim_array( animType, anim.anim_array );
			break;

		case "spetsnaz":
			anim.anim_array = animscripts\anims_table_spetsnaz::setup_spetsnaz_anim_array( animType, anim.anim_array );
			break;

		default:
			println( "^3Unknown animType: " + animType + ". Can't setup anim array" );
			return;
	}

	// precache the cover arrival/exit move and angle deltas
	setup_delta_arrays( anim.anim_array, anim );
}

try_heat()
{
	// try setting heat
	randomChance = 0;
	switch( self.animType )
	{		
		case "default":
			randomChance = 33;
			break;

		case "spetsnaz":
			randomChance = 66;
			break;
	}

	if( RandomInt(100) < randomChance )
	{
		self setup_heat_anim_array();
	}
}

setup_heat_anim_array()
{
	// if already in heat animations then dont do anything
	if( IS_TRUE( self.heat ) )
		return;

	// heat is only for enemies
	if( self.team == "allies" )
		return;

	if( IS_TRUE( self.noHeatAnims ) )
		return;

	self animscripts\anims::clearAnimCache();

	if( !IsDefined( self.anim_array ) )
	{
		self.anim_array = [];
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

	self.heat = true;

	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["straight_level"]	= %heat_stand_aim_5;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_up"]		= %heat_stand_aim_8;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_down"]		= %heat_stand_aim_2;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_left"]		= %heat_stand_aim_4;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_right"]		= %heat_stand_aim_6;

	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["reload"]			= array( %heat_exposed_reload ); 
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["reload_crouchhide"]	= array( %heat_exposed_reload ); 

	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["fire"]				= %heat_stand_fire_auto;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["single"]			= array( %heat_stand_fire_single );
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst2"]			= %heat_stand_fire_burst; // ( will be stopped after second bullet)
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst3"]			= %heat_stand_fire_burst;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst4"]			= %heat_stand_fire_burst;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst5"]			= %heat_stand_fire_burst;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["burst6"]			= %heat_stand_fire_burst;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["semi2"]				= %heat_stand_fire_burst;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["semi3"]				= %heat_stand_fire_burst;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["semi4"]				= %heat_stand_fire_burst;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["semi5"]				= %heat_stand_fire_burst;

	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["exposed_idle"]				= array( %heat_stand_idle );
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["exposed_idle_noncombat"]	= array( %heat_stand_twitchA, %heat_stand_twitchB, %heat_stand_scanA, %heat_stand_scanB );

	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_45"]		= %exposed_tracking_turn45L;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_90"]		= %heat_stand_turn_L;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_135"]		= %exposed_tracking_turn135L;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_left_180"]		= %heat_stand_turn_180;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_45"]		= %exposed_tracking_turn45R;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_90"]		= %heat_stand_turn_R;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_135"]	= %exposed_tracking_turn135R;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["turn_right_180"]	= %heat_stand_turn_180;

	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][1]	= %heat_approach_1;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][2]	= %heat_approach_2;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][3]	= %heat_approach_3;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][4]	= %heat_approach_4;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][6]	= %heat_approach_6;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["arrive_exposed"][8]	= %heat_approach_8;
	
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][1]		= %heat_exit_1;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][2]		= %heat_exit_2;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][3]		= %heat_exit_3;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][4]		= %heat_exit_4;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][6]		= %heat_exit_6;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][7]		= %heat_exit_7;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][8]		= %heat_exit_8;
	self.anim_array[self.animType]["move"]["stand"]["rifle"]["exit_exposed"][9]		= %heat_exit_9;

	self.anim_array[self.animType]["cover_left"]["stand"]["rifle"]["straight_level"]			= %heat_stand_aim_5;
	self.anim_array[self.animType]["cover_right"]["stand"]["rifle"]["straight_level"]			= %heat_stand_aim_5;
	self.anim_array[self.animType]["cover_pillar_left"]["stand"]["rifle"]["straight_level"]		= %heat_stand_aim_5;
	self.anim_array[self.animType]["cover_pillar_right"]["stand"]["rifle"]["straight_level"]	= %heat_stand_aim_5;

	self.anim_array[self.animType]["cover_stand"]["stand"]["rifle"]["stand_aim"]	= %heat_stand_aim_5;
	self.anim_array[self.animType]["cover_stand"]["stand"]["rifle"]["lean_aim"]		= %heat_stand_aim_5;

	self.anim_array[self.animType]["cover_stand"]["crouch"]["rifle"]["stand_aim"]	= %heat_stand_aim_5;
	self.anim_array[self.animType]["cover_stand"]["crouch"]["rifle"]["lean_aim"]	= %heat_stand_aim_5;

	self.anim_array[self.animType]["cover_crouch"]["stand"]["rifle"]["stand_aim"]	= %heat_stand_aim_5;
	self.anim_array[self.animType]["cover_crouch"]["stand"]["rifle"]["lean_aim"]	= %heat_stand_aim_5;

	self.anim_array[self.animType]["cover_crouch"]["crouch"]["rifle"]["stand_aim"]	= %heat_stand_aim_5;
	self.anim_array[self.animType]["cover_crouch"]["crouch"]["rifle"]["lean_aim"]	= %heat_stand_aim_5;

	self.anim_array[self.animType]["cover_left"]["stand"]["rifle"]["alert_to_A"]			= array( %heat_cornerstndl_trans_alert_2_a );
	self.anim_array[self.animType]["cover_left"]["stand"]["rifle"]["alert_to_B"]			= array( %heat_cornerstndl_trans_alert_2_b );
	self.anim_array[self.animType]["cover_left"]["stand"]["rifle"]["A_to_alert"]			= array( %heat_cornerstndl_trans_a_2_alert );
	self.anim_array[self.animType]["cover_left"]["stand"]["rifle"]["A_to_alert_reload"]		= array();
	self.anim_array[self.animType]["cover_left"]["stand"]["rifle"]["A_to_B"    ]			= array( %heat_cornerstndl_trans_a_2_b     );
	self.anim_array[self.animType]["cover_left"]["stand"]["rifle"]["B_to_alert"]			= array( %heat_cornerstndl_trans_b_2_alert );
 	self.anim_array[self.animType]["cover_left"]["stand"]["rifle"]["B_to_alert_reload"]		= array( %heat_cornerstndl_reload_b_2_alert );
	self.anim_array[self.animType]["cover_left"]["stand"]["rifle"]["B_to_A"    ]			= array( %heat_cornerstndl_trans_b_2_a     );

	self.anim_array[self.animType]["cover_right"]["stand"]["rifle"]["alert_to_A"]			= array( %heat_cornerstndr_trans_alert_2_a );
	self.anim_array[self.animType]["cover_right"]["stand"]["rifle"]["alert_to_B"]			= array( %heat_cornerstndr_trans_alert_2_b );
	self.anim_array[self.animType]["cover_right"]["stand"]["rifle"]["A_to_alert"]			= array( %heat_cornerstndr_trans_a_2_alert );
	self.anim_array[self.animType]["cover_right"]["stand"]["rifle"]["A_to_alert_reload"]	= array();
	self.anim_array[self.animType]["cover_right"]["stand"]["rifle"]["A_to_B"    ]			= array( %heat_cornerstndr_trans_a_2_b     );
	self.anim_array[self.animType]["cover_right"]["stand"]["rifle"]["B_to_alert"]			= array( %heat_cornerstndr_trans_b_2_alert );
 	self.anim_array[self.animType]["cover_right"]["stand"]["rifle"]["B_to_alert_reload"]	= array( %heat_cornerstndr_reload_b_2_alert );
	self.anim_array[self.animType]["cover_right"]["stand"]["rifle"]["B_to_A"    ]			= array( %heat_cornerstndr_trans_b_2_a     );

	animscripts\anims_table::setup_delta_arrays( self.anim_array, self );

	// remove, this is just for the anim_test map
//	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["asdf"]				= %heat_cover_reload_L;
//	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["asdf"]				= %heat_cover_reload_R;
//	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["asdf"]				= %heat_run_loop;
}

reset_heat_anim_array()
{
	if( IsDefined( self.heat ) && self.heat )
	{
		self.heat = false;
		self.anim_array = undefined;
		self.pre_move_delta_array		= undefined;
		self.move_delta_array			= undefined;
		self.post_move_delta_array		= undefined;
		self.angle_delta_array			= undefined;
		self.notetrack_array			= undefined;
		self.longestExposedApproachDist	= undefined;
		self.longestApproachDist		= undefined;

		self animscripts\anims::clearAnimCache();
	}
}

setup_cqb_anim_array()
{
	if( !self animscripts\utility::isCQB() )
		return;

	self animscripts\anims::clearAnimCache();

	if( !IsDefined( self.anim_array ) )
	{
		self.anim_array = [];
	}
	
	// Use smaller set for exposed idles ( without movement animations ) as they dont blend well with CQB pose
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["exposed_idle"]				= array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 );
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["exposed_idle_noncombat"]	= array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 );
	
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["straight_level"]			= %CQB_stand_aim5;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_up"]				= %CQB_stand_aim8;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_down"]				= %CQB_stand_aim2;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_left"]				= %CQB_stand_aim4;
	self.anim_array[self.animType]["combat"]["stand"]["rifle"]["add_aim_right"]				= %CQB_stand_aim6;
}

reset_cqb_anim_array()
{
	// re-initialize heat if it was on before we went CQB
	if( IsDefined(self.heat) && self.heat )
	{
		reset_heat_anim_array();
		setup_heat_anim_array();
	}
	else
	{
		self.anim_array = undefined;
	}
}
