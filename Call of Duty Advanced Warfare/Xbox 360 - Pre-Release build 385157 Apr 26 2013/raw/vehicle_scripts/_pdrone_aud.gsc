#include soundscripts\_snd;
#include soundscripts\_audio_vehicle_manager;
#include vehicle_scripts\_pdrone;


/**************************************************************************************************************************************/
/**************************************************************************************************************************************/
/**************************************************************************************************************************************/

/*
 ********************************************************************************************
 * 
 *	VEHICLE PRESET:  PDRONE ATLAS LARGE
 * 
 ********************************************************************************************
 */
 
////////////////////////
// PRESET CONSTRUCTOR //
////////////////////////
snd_adrone_constructor()
{
	/////////////////////////////////////////////////////////////////////////
	// NOTE:  Speed constants are in MPH; distance constants are in yards. //
	/////////////////////////////////////////////////////////////////////////
	/// 
	kADrn_MinSpeed				= 0;
	kADrn_NomSpeed				= 10;
	kADrn_MaxSpeed				= 30;
	kADrn_SpeedRange			= kADrn_MaxSpeed - kADrn_MinSpeed;
	
	kADrn_RealHelo_MinVol		= 0.40;
	kADrn_RealHelo_MaxVol		= 0.40;
	kADrn_RealHelo_VolRange		= kADrn_RealHelo_MaxVol - kADrn_RealHelo_MinVol;
	kADrn_RealHelo_MinPch		= 1.5;
	kADrn_RealHelo_MaxPch		= 1.9;
	kADrn_RealHelo_PchRange		= kADrn_RealHelo_MaxPch - kADrn_RealHelo_MinPch;
	
	kADrn_SnthHelo_MinDist		= 36 * 7.5;
	kADrn_SnthHelo_MaxDist		= 36 * 30;
	kADrn_SnthHelo_MinVol		= 0.0;
	kADrn_SnthHelo_MaxVol		= 1.0; //0.5; //1.0;
	kADrn_SnthHelo_VolRange		= kADrn_SnthHelo_MaxVol - kADrn_SnthHelo_MinVol;
	kADrn_SnthHelo_MinPch		= 1.0;
	kADrn_SnthHelo_MaxPch		= 2.0;
	kADrn_SnthHelo_PchRange		= kADrn_SnthHelo_MaxPch - kADrn_SnthHelo_MinPch;
	
	kADrn_Hover_MinVol			= 0.0; //0.0; //0.2;
	kADrn_Hover_MaxVol			= 0.45; //0.0; //0.5;
	kADrn_Hover_VolRange		= kADrn_Hover_MaxVol - kADrn_Hover_MinVol;
	kADrn_Hover_MinPch			= 0.9;
	kADrn_Hover_MaxPch			= 1.4;
	kADrn_Hover_PchRange		= kADrn_Hover_MaxPch - kADrn_Hover_MinPch;
	
	kADrn_TravelSlw_MinVol		= 0.0;
	kADrn_TravelSlw_MaxVol		= 0.5; //0.4; //1.0;
	kADrn_TravelSlw_MinSpeed	= kADrn_MaxSpeed * 0.00;
	kADrn_TravelSlw_MaxSpeed	= kADrn_MaxSpeed * 0.65;
	
	kADrn_TravelFst_MinDist		= 36 * 8;
	kADrn_TravelFst_MaxDist		= 36 * 20;
	kADrn_TravelFst_MinVol		= 0.0;
	kADrn_TravelFst_MaxVol		= 1.0; //0.0; //0.6;
	kADrn_TravelFst_MinSpeed	= kADrn_MaxSpeed * 0.6;	//kADrn_MaxSpeed * 0.35;
	kADrn_TravelFst_MaxSpeed	= kADrn_MaxSpeed * 1.00;
	kADrn_TravelFst_SpeedRange	= kADrn_TravelFst_MaxSpeed - kADrn_TravelFst_MinSpeed;
	kADrn_TravelFst_MinPch		= 0.85;
	kADrn_TravelFst_MaxPch		= 1.25;
	
	kADrn_Flyover_Radius		= 30;
	kADrn_Flyby_MinVol			= 0.0;
	kADrn_Flyby_MaxVol			= 1.0;
	kADrn_Flyby_MinPch			= 0.50;
	kADrn_Flyby_MaxPch			= 1.50;
	kADrn_Flyby_RadiusNear		= 100;
	kADrn_Flyby_RadiusMid		= 200;
	kADrn_Flyby_RadiusFar		= 500;
	kADrn_Flyby_DistThreshold	= 6.0;
	
	kADrn_Dist_Threshold		= 20.0;
	kADrn_Speed_HoverThreshold	= 5.0;
	
	kADrn_UseDefaultParam		= undefined;
	kADrn_Loop_SmoothUp			= 0.60;
	kADrn_Loop_SmoothDown		= 0.50;
	
	/***** DEFINE LOOPS *****/
	VM2_begin_preset_def("pdrone_atlas_large");												

		VM2_begin_loop_data(kADrn_UseDefaultParam, kADrn_Loop_SmoothUp, kADrn_Loop_SmoothDown);
	
			VM2_begin_loop_def("adrn_real_helo_lp");
				VM2_begin_param_map("SPEED");
					VM2_add_param_map_env("volume",	"adrn_realhelo_spd2vol");
					VM2_add_param_map_env("pitch",	"adrn_realhelo_spd2pch");
				VM2_end_param_map();
				VM2_begin_param_map("DOPPLER_EXAGGERATED");
					VM2_add_param_map_env("pitch", "adrn_doppler2pch");
				VM2_end_param_map();	
			VM2_end_loop_def();		
			
			VM2_begin_loop_def("adrn_snth_helo_lp");
				VM2_begin_param_map("DISTANCE");
					VM2_add_param_map_env("volume",	"adrn_snthhelo_dst2vol");
				VM2_end_param_map();
				VM2_begin_param_map("SPEED");
					VM2_add_param_map_env("volume",	"adrn_snthhelo_spd2vol");
					VM2_add_param_map_env("pitch",	"adrn_snthhelo_spd2pch");
				VM2_end_param_map();
				VM2_begin_param_map("DOPPLER");
					VM2_add_param_map_env("pitch", "adrn_doppler2pch");
				VM2_end_param_map();	
			VM2_end_loop_def();		
			
			VM2_begin_loop_def("adrn_hover_lp");								
				VM2_begin_param_map("SPEED");
					VM2_add_param_map_env("volume",	"adrn_hover_spd2vol");
					VM2_add_param_map_env("pitch",	"adrn_hover_spd2pch");
				VM2_end_param_map();	
			VM2_end_loop_def();	
			
//			VM2_begin_loop_def( "adrn_travel_slw_lp" );								
//				VM2_begin_param_map("SPEED");
//					VM2_add_param_map_env("volume",	"adrn_travelslw_spd2vol");
//					VM2_add_param_map_env("pitch",	"adrn_hover_spd2pch");
//				VM2_end_param_map();
//				VM2_begin_param_map("DOPPLER");
//					VM2_add_param_map_env("pitch", "adrn_doppler2pch");
//				VM2_end_param_map();	
//			VM2_end_loop_def();	
			
			VM2_begin_loop_def("adrn_travel_fst_lp");								
				VM2_begin_param_map("DISTANCE2D");
					VM2_add_param_map_env("volume",	"adrn_travelfst_dst2vol");
				VM2_end_param_map();
				VM2_begin_param_map("SPEED");
					VM2_add_param_map_env("volume",		"adrn_travelfst_spd2vol");
					//VM2_add_param_map_env("pitch",		"adrn_travelfst_spd2pch");
				VM2_end_param_map();
				VM2_begin_param_map("DOPPLER");
					VM2_add_param_map_env("pitch", "adrn_doppler2pch");
				VM2_end_param_map();					
			VM2_end_loop_def();	
			
		VM2_end_loop_data();
		
		/***** DEFINE ONESHOTS *****/
		VM2_begin_oneshot_data();
			
			VM2_begin_oneshot_def("adrn_flyby1", "adrn_flyby_duck_envelope", 0.25);
				VM2_begin_param_map("SPEED", 1.00, 1.00);
					VM2_add_param_map_env("pitch", "adrn_flyby_vel2pch");
					VM2_add_param_map_env("volume", "adrn_flyby_vel2vol");
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
		VM2_end_oneshot_data();
		
		/***** DEFINE BEHAVIORS *****/
		VM2_begin_behavior_data();

			VM2_begin_behavior_def("to_state_hover",		::adrone_condition_callback_to_state_hover,		["speed", "distance2d"]);
				VM2_add_loops("ALL");
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def("to_state_flying",		::adrone_condition_callback_to_state_flying,	["speed", "distance2d"]);
				VM2_add_loops("ALL");
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def("to_state_distant",		::adrone_condition_callback_to_state_distant,	["distance2d"]);
				VM2_add_loops("NONE");
			VM2_end_behavior_def();				
				
			VM2_begin_behavior_def("to_state_flyby",		::adrone_condition_callback_to_state_flyby,		["distance2d"]);
				VM2_add_loops("ALL");
				VM2_add_oneshots("adrn_flyby1");
			VM2_end_behavior_def();	
			
			VM2_begin_behavior_def("to_state_deathspin",	::adrone_condition_callback_to_state_deathspin);	// Stub.
				VM2_add_loops("NONE");
			VM2_end_behavior_def();	
			
			VM2_begin_behavior_def("to_state_destruct",		::adrone_condition_callback_to_state_destruct);		// Stub.
				VM2_add_loops("NONE");
			VM2_end_behavior_def();	
			
			VM2_begin_behavior_def("to_state_off",			::adrone_condition_callback_to_state_off);			// Stub.
				VM2_add_loops("NONE");
			VM2_end_behavior_def();	
			
		VM2_end_behavior_data();		
		
		/***** DEFINE STATES *****/
		VM2_begin_state_data(0.25, 50);
		
			VM2_begin_state_group("main_oneshots", "state_hover", "to_state_hover", 50, 1.0);
			
				VM2_begin_state_def("state_off");
					VM2_add_state_transition("state_hover",		"to_state_hover");
					VM2_add_state_transition("state_distant",	"to_state_distant");
				VM2_end_state_def();
			
				VM2_begin_state_def("state_hover");
					VM2_add_state_transition("state_flyby",		"to_state_flyby");
					VM2_add_state_transition("state_flying",	"to_state_flying");
					VM2_add_state_transition("state_distant",	"to_state_distant");
					VM2_add_state_transition("state_deathspin",	"to_state_deathspin");
					VM2_add_state_transition("state_destruct",	"to_state_destruct");
				VM2_end_state_def();

				VM2_begin_state_def("state_flying");
					VM2_add_state_transition("state_flyby",		"to_state_flyby");
					VM2_add_state_transition("state_distant",	"to_state_distant");
					VM2_add_state_transition("state_deathspin",	"to_state_deathspin");
					VM2_add_state_transition("state_destruct",	"to_state_destruct");
				VM2_end_state_def();
				
				VM2_begin_state_def("state_distant");
					VM2_add_state_transition("state_hover",		"to_state_hover");
					VM2_add_state_transition("state_flying",	"to_state_flying");
					VM2_add_state_transition("state_flyby",		"to_state_flyby");
					VM2_add_state_transition("state_deathspin",	"to_state_deathspin");
					VM2_add_state_transition("state_destruct",	"to_state_destruct");
				VM2_end_state_def();
				
				VM2_begin_state_def("state_flyby", 3.0);
					VM2_add_state_transition("state_hover",		"to_state_hover");
					VM2_add_state_transition("state_flying",	"to_state_flying");
					VM2_add_state_transition("state_flyby",		"to_state_flyby");
					VM2_add_state_transition("state_distant",	"to_state_distant");
					VM2_add_state_transition("state_deathspin",	"to_state_deathspin");
					VM2_add_state_transition("state_destruct",	"to_state_destruct");
				VM2_end_state_def();
						
				VM2_begin_state_def("state_deathspin");
					VM2_add_state_transition("state_destruct",	"to_state_destruct");
				VM2_end_state_def();
						
				VM2_begin_state_def("state_destruct");
					VM2_add_state_transition("state_off",		"to_state_off");
				VM2_end_state_def();
					
			VM2_end_state_group();
		
		VM2_end_state_data();
		
		
		/***** DEFINE ENVELOPES *****/
//		VM2_add_envelope("adrn_realhelo_spd2pch",
//			[
//			 	[kADrn_MaxSpeed * 0.0000,	kADrn_RealHelo_MinPch + 0.0000 * kADrn_RealHelo_PchRange],
//				[kADrn_MaxSpeed * 0.0204,	kADrn_RealHelo_MinPch + 0.0330 * kADrn_RealHelo_PchRange],
//				[kADrn_MaxSpeed * 0.0816,	kADrn_RealHelo_MinPch + 0.0587 * kADrn_RealHelo_PchRange],
//				[kADrn_MaxSpeed * 0.1836,	kADrn_RealHelo_MinPch + 0.1111 * kADrn_RealHelo_PchRange],
//				[kADrn_MaxSpeed * 0.3265,	kADrn_RealHelo_MinPch + 0.2214 * kADrn_RealHelo_PchRange],
//				[kADrn_MaxSpeed * 0.5102,	kADrn_RealHelo_MinPch + 0.4444 * kADrn_RealHelo_PchRange],
//				[kADrn_MaxSpeed * 0.7346,	kADrn_RealHelo_MinPch + 0.7901 * kADrn_RealHelo_PchRange],
//				[kADrn_MaxSpeed * 1.0000,	kADrn_RealHelo_MinPch + 1.0000 * kADrn_RealHelo_PchRange]
//			]
//		);
		
		VM2_add_envelope("adrn_realhelo_spd2vol",
			[
			 	[kADrn_MinSpeed,	kADrn_RealHelo_MinVol],
				[kADrn_MaxSpeed ,	kADrn_RealHelo_MaxVol]
			]
		);
		
		VM2_add_envelope("adrn_realhelo_spd2pch",
			[
			 	[kADrn_MinSpeed,	kADrn_RealHelo_MinPch],
				[kADrn_MaxSpeed ,	kADrn_RealHelo_MaxPch]
			]
		);
		
		VM2_add_envelope("adrn_snthhelo_spd2pch",
			[
			 	[kADrn_MaxSpeed * 0.0000,	kADrn_SnthHelo_MinPch + 0.0000 * kADrn_SnthHelo_PchRange],
				[kADrn_MaxSpeed * 0.0204,	kADrn_SnthHelo_MinPch + 0.0330 * kADrn_SnthHelo_PchRange],
				[kADrn_MaxSpeed * 0.0816,	kADrn_SnthHelo_MinPch + 0.0587 * kADrn_SnthHelo_PchRange],
				[kADrn_MaxSpeed * 0.1836,	kADrn_SnthHelo_MinPch + 0.1111 * kADrn_SnthHelo_PchRange],
				[kADrn_MaxSpeed * 0.3265,	kADrn_SnthHelo_MinPch + 0.2214 * kADrn_SnthHelo_PchRange],
				[kADrn_MaxSpeed * 0.5102,	kADrn_SnthHelo_MinPch + 0.4444 * kADrn_SnthHelo_PchRange],
				[kADrn_MaxSpeed * 0.7346,	kADrn_SnthHelo_MinPch + 0.7901 * kADrn_SnthHelo_PchRange],
				[kADrn_MaxSpeed * 1.0000,	kADrn_SnthHelo_MinPch + 1.0000 * kADrn_SnthHelo_PchRange]
			]
		);
		
		VM2_add_envelope("adrn_snthhelo_dst2vol",
			[
			 	[kADrn_SnthHelo_MinDist,	kADrn_SnthHelo_MaxVol],
				[kADrn_SnthHelo_MaxDist ,	kADrn_SnthHelo_MinVol]
			]
		);	
		
		VM2_add_envelope("adrn_snthhelo_spd2vol",
			[
			 	[kADrn_MinSpeed,	kADrn_SnthHelo_MinVol],
				[kADrn_MaxSpeed,	kADrn_SnthHelo_MaxVol]
			]
		);		
		
		
		VM2_add_envelope("adrn_hover_spd2pch",
			[
			 	[kADrn_MinSpeed,	kADrn_Hover_MinPch],
				[kADrn_MaxSpeed ,	kADrn_Hover_MaxPch]
			]
		);	
		
		VM2_add_envelope("adrn_hover_spd2vol",
			[
			 	[kADrn_MinSpeed,	kADrn_Hover_MaxVol],
				[kADrn_MaxSpeed,	kADrn_Hover_MinVol]
			]
		);		
		
		VM2_add_envelope("adrn_travelslw_spd2vol",
			[
			 	[kADrn_TravelSlw_MinSpeed,	kADrn_TravelSlw_MaxVol],
			 	[kADrn_TravelSlw_MaxSpeed,	kADrn_TravelSlw_MinVol]
			]
		);
		
		VM2_add_envelope("adrn_travelfst_dst2vol",
			[
			 	[kADrn_TravelFst_MinDist,	kADrn_TravelFst_MaxVol],
				[kADrn_TravelFst_MaxDist ,	kADrn_TravelFst_MinVol]
			]
		);	
		
		VM2_add_envelope("adrn_travelfst_spd2vol",
			[
				[kADrn_TravelFst_MinSpeed + kADrn_TravelFst_SpeedRange * 0.0000,	kADrn_TravelFst_MaxVol * 0.0000],
				[kADrn_TravelFst_MinSpeed + kADrn_TravelFst_SpeedRange * 0.0204,	kADrn_TravelFst_MaxVol * 0.0330],
				[kADrn_TravelFst_MinSpeed + kADrn_TravelFst_SpeedRange * 0.0816,	kADrn_TravelFst_MaxVol * 0.0587],
				[kADrn_TravelFst_MinSpeed + kADrn_TravelFst_SpeedRange * 0.1836,	kADrn_TravelFst_MaxVol * 0.1111],
				[kADrn_TravelFst_MinSpeed + kADrn_TravelFst_SpeedRange * 0.3265,	kADrn_TravelFst_MaxVol * 0.2214],
				[kADrn_TravelFst_MinSpeed + kADrn_TravelFst_SpeedRange * 0.5102,	kADrn_TravelFst_MaxVol * 0.4444],
				[kADrn_TravelFst_MinSpeed + kADrn_TravelFst_SpeedRange * 0.7346,	kADrn_TravelFst_MaxVol * 0.7901],
				[kADrn_TravelFst_MinSpeed + kADrn_TravelFst_SpeedRange * 1.0000,	kADrn_TravelFst_MaxVol * 1.0000]
			]
		);
		
		VM2_add_envelope("adrn_travelfst_spd2pch",
			[
			 	[kADrn_MinSpeed,	kADrn_TravelFst_MinPch],
				[kADrn_MaxSpeed ,	kADrn_TravelFst_MaxPch]
			]
		);	
		
		VM2_add_envelope("adrn_flyby_vel2vol",
			[
				[kADrn_MinSpeed,			kADrn_Flyby_MinVol],
				[kADrn_SpeedRange * 0.25,	kADrn_Flyby_MaxVol * 0.50],
				[kADrn_MaxSpeed,			kADrn_Flyby_MaxVol]
			]
		);
		
		VM2_add_envelope("adrn_flyby_vel2pch",
			[
				[kADrn_MinSpeed,	kADrn_Flyby_MinPch],
				[kADrn_MaxSpeed,	kADrn_Flyby_MaxPch]
			]
		);
		
		VM2_add_envelope("adrn_doppler2pch",
			[
			 	[0.00,	0.00],
				[2.00,	2.00]
			]
		);
		
		VM2_add_envelope("adrn_flyby_duck_envelope",
			[
				[0.00,  1.00],
				[0.40,  0.70],
				[0.60,  0.50],
				[0.80,  0.70],
				[1.00,  1.00]
			]
		);
		
	VM2_end_preset_def();
}

////////////////////////
// BEHAVIOR CALLBACKS //
////////////////////////
kADrn_Speed_HoverThreshold	= 5.1;	// MPH
kADrn_Dist_Threshold		= 20.0;	// yards
kADrn_Flyby_DistThreshold	= 6.0;	// yards
kADrn_Flyover_Radius		= 30;

adrone_condition_callback_to_state_off()
{
	return false;	
}
	
adrone_condition_callback_to_state_hover(curr_smoothed_input_keyed_values, vars)
{
	result		= false;
	//velo 		= curr_smoothed_input_keyed_values["relative_speed"];
	velo 		= curr_smoothed_input_keyed_values["speed"];
	dist		= curr_smoothed_input_keyed_values["distance2d"];
	curr_yards	= dist2yards(dist);
	
	// STATE TRIGGER CONDITION.
	if (velo <= kADrn_Speed_HoverThreshold  && curr_yards < kADrn_Dist_Threshold)
	{
		result = true;
	}
	
	return result;
}

adrone_condition_callback_to_state_flying(curr_smoothed_input_keyed_values, vars)
{
	result		= false;
	//velo 		= curr_smoothed_input_keyed_values["relative_speed"];
	velo 		= curr_smoothed_input_keyed_values["speed"];
	dist		= curr_smoothed_input_keyed_values["distance2d"];
	curr_yards	= dist2yards(dist);
	
	// STATE TRIGGER CONDITION.
	if (velo > kADrn_Speed_HoverThreshold && curr_yards < kADrn_Dist_Threshold)
	{
		result = true;
	}
	
	return result;
}

adrone_condition_callback_to_state_distant(curr_smoothed_input_keyed_values, vars)
{
	result		= false;
	dist		= curr_smoothed_input_keyed_values["distance2d"];
	curr_yards	= dist2yards(dist);
	
	// STATE TRIGGER CONDITION.
	if (curr_yards >= kADrn_Dist_Threshold)	
	{
		result = true;
	}
	
	return result;
}

adrone_condition_callback_to_state_flyby(curr_smoothed_input_keyed_values, vars)
{
	result		= false;
	dist		= curr_smoothed_input_keyed_values["distance2d"];
	curr_yards	= dist2yards(dist);

	if (!IsDefined(vars.flyby))
    {
		vars.flyby = SpawnStruct();
    	vars.flyby.prev_yards = curr_yards;
    	vars.flyby.prev_dx = 0;
    }
	else
	{
		curr_dx = curr_yards - vars.flyby.prev_yards;
		
		// STATE TRIGGER CONDITION.
		if (curr_dx < 0 && curr_yards < kADrn_Flyby_DistThreshold)	
		{
			result = true;					
		}
		
		vars.flyby.prev_yards	= curr_yards;
    	vars.flyby.prev_dx		= curr_dx;
	}
	
	return result;
}

adrone_condition_callback_to_state_flyover(curr_smoothed_input_keyed_values, vars)
{
	result = false;
	dist = curr_smoothed_input_keyed_values["distance2d"];
	velo = curr_smoothed_input_keyed_values["relative_speed"];
	yards = dist2yards(dist);
	
	if (yards < kADrn_Flyover_Radius)
	{
		result = true;
	}
	
	return result;
}

adrone_condition_callback_to_state_deathspin(curr_smoothed_input_keyed_values, vars)
{
	return false;	
}

adrone_condition_callback_to_state_destruct(curr_smoothed_input_keyed_values, vars)
{
	return false;	
}

/**************************************************************************************************************************************/
/**************************************************************************************************************************************/
/**************************************************************************************************************************************/

/*
 ********************************************************************************************
 * 
 *	VEHICLE PRESET:  PDRONE ATLAS LARGE
 * 
 ********************************************************************************************
 */
// PDrone-Global constants (used in preset constructor and callbacks).
kPDrn_Test_RetFlyByOnTheFly	= false;
	
////////////////////////
// PRESET CONSTRUCTOR //`
////////////////////////
// Called on Vehicle Instance (by Vehicle Manager).
snd_pdrone_constructor()
{
	// Constants used in preset constructor only.
	kPDrn_WindWand_Scalar		= 1.0;
	kPDrn_Helo_Scalar			= 0.8;
	kPDrn_MinSpeed				= 0;
	kPDrn_NomSpeed				= 10;
	kPDrn_MaxSpeed				= 15;
	kPDrn_SpeedRange			= kPDrn_MaxSpeed - kPDrn_MinSpeed;
	kPDrn_Rotor_MinVol			= 0.7;
	kPDrn_Rotor_MaxVol			= 1.0;
	kPDrn_Rotor_MinPch			= 0.8;
	kPDrn_Rotor_NomPch			= 1.0;
	kPDrn_Rotor_MaxPch			= 1.1;
	kPDrn_Whine_MinVol			= 0.0;
	kPDrn_Whine_MaxVol			= 0.5;
	kPDrn_Whine_MinPch			= 0.85;
	kPDrn_Whine_MaxPch			= 1.0;
	kPDrn_Noise_MinVol			= 0.0;
	kPDrn_NoiseLo_MaxVol		= 0.5;
	kPDrn_NoiseHi_MaxVol		= 1.00;
	kPDrn_Noise_MinPch			= 0.8;
	kPDrn_Noise_MaxPch			= 1.1;
	kPDrn_Flyby_MinVol			= 0.0;
	kPDrn_Flyby_MaxVol			= 1.0;
	kPDrn_Flyby_MinPch			= 0.50;	//0.4;
	kPDrn_Flyby_MaxPch			= 1.50;	//2.0;

	/***** DEFINE LOOPS *****/
	VM2_begin_preset_def("pdrone");												// presetName

		VM2_begin_loop_data();
	
			VM2_begin_loop_def("pdrn_rotor_ww_lw");								// assetName,  optoinalLoopInstanceName (required if using mulitple instances of assetName), optoinalAssetType (required if assetName is not an alias name [e.g. alias vs. damb]
				VM2_begin_param_map("speed");									// inputName/func, optionalSmoothUp (overrides default), optionalSmoothDown (if different from smoothUp)
					VM2_add_param_map_env("volume", "pdrn_rotor_ww_lw");		// outputName, envAssetName/func, optoinalEnvInstanceName (required if using mulitple instances of envAssetName/func) 
					VM2_add_param_map_env("volume", "pdrn_loopset_vol_env");
				VM2_end_param_map();
				
				VM2_begin_param_map("doppler_exaggerated");
					VM2_add_param_map_env("pitch", "pdrn_doppler2pch");
				VM2_end_param_map();	
			VM2_end_loop_def();
			
			VM2_begin_loop_def("pdrn_rotor_ww_md");
				VM2_begin_param_map("speed");
					VM2_add_param_map_env("volume", "pdrn_rotor_ww_hi");
					VM2_add_param_map_env("volume", "pdrn_loopset_vol_env");
				VM2_end_param_map();
				
				VM2_begin_param_map("doppler_exaggerated");
					VM2_add_param_map_env("pitch", "pdrn_doppler2pch");
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def("pdrn_rotor_ww_hi");
				VM2_begin_param_map("speed");
					VM2_add_param_map_env("volume", "pdrn_rotor_ww_md");
					VM2_add_param_map_env("volume", "pdrn_loopset_vol_env");
				VM2_end_param_map();
				
				VM2_begin_param_map("doppler_exaggerated");
					VM2_add_param_map_env("pitch", "pdrn_doppler2pch");
				VM2_end_param_map();	
			VM2_end_loop_def();
			
			VM2_begin_loop_def("pdrn_rotor_main_lp");
				VM2_begin_param_map("speed", 0.65, 0.30);
					VM2_add_param_map_env("volume", "pdrn_rotor_vel2vol");
					VM2_add_param_map_env("volume", "pdrn_loopset_vol_env");
				VM2_end_param_map();
				
				VM2_begin_param_map("doppler_exaggerated", 0.65, 0.30);
					VM2_add_param_map_env("pitch", "pdrn_doppler2pch");
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def("pdrn_whine_lp");
				VM2_begin_param_map("speed", 0.65, 0.30);
					VM2_add_param_map_env("volume", "pdrn_whine_vel2vol");
				VM2_end_param_map();
				
				VM2_begin_param_map("doppler_exaggerated", 0.65, 0.30);
					VM2_add_param_map_env("pitch", "pdrn_doppler2pch");
				VM2_end_param_map();
			VM2_end_loop_def();			
			
			VM2_begin_loop_def("pdrn_pink_hipass_lp");
			
				VM2_begin_param_map("speed");
					VM2_add_param_map_env("volume", "pdrn_noise_hi_vel2vol");
				VM2_end_param_map();
				
				VM2_begin_param_map("distance");
					VM2_add_param_map_env("volume", "pdrn_noise_hi_dist2vol");
				VM2_end_param_map();
				
				VM2_begin_param_map("doppler_exaggerated", 0.65, 0.30);
					VM2_add_param_map_env("pitch", "pdrn_doppler2pch");
				VM2_end_param_map();
			VM2_end_loop_def();			
			
			VM2_begin_loop_def("pdrn_pink_lopass_lp");
				VM2_begin_param_map("speed");
					VM2_add_param_map_env("volume", "pdrn_noise_lo_vel2vol");
				VM2_end_param_map();
				
				VM2_begin_param_map("distance");
					VM2_add_param_map_env("volume", "pdrn_noise_lo_dist2vol");
				VM2_end_param_map();
				
				VM2_begin_param_map("doppler_exaggerated", 0.65, 0.30);
					VM2_add_param_map_env("pitch", "pdrn_doppler2pch");
				VM2_end_param_map();
			VM2_end_loop_def();				

		VM2_end_loop_data();
		
		/***** DEFINE ONESHOTS *****/
		VM2_begin_oneshot_data();
			
			VM2_begin_oneshot_def("pdrone_flyby", "pdrn_flyby_duck_envelope", 0.25, true, ["pdrn_by_1", "pdrn_by_2"]);
				VM2_begin_param_map("speed", 1.00, 1.00); //.65, .30);
					VM2_add_param_map_env("pitch", "pdrn_flyby_vel2pch");
					VM2_add_param_map_env("volume", "pdrn_flyby_vel2vol");
				VM2_end_param_map();
				
				VM2_begin_param_map("doppler_exaggerated", 1.00, 1.00); //.65, .30);
					VM2_add_param_map_env("pitch", "pdrn_doppler2pch");
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			
			VM2_begin_oneshot_def("foo_oneshot", "pdrn_flyby_duck_envelope", 0.25, true, ["pdrn_by_1", "pdrn_by_2"]);
				VM2_begin_param_map("speed", 1.00, 1.00); //.65, .30);
					VM2_add_param_map_env("pitch", "pdrn_flyby_vel2pch");
					VM2_add_param_map_env("volume", "pdrn_flyby_vel2vol");
				VM2_end_param_map();
				
				VM2_begin_param_map("doppler_exaggerated", 1.00, 1.00); //.65, .30);
					VM2_add_param_map_env("pitch", "pdrn_doppler2pch");
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
		VM2_end_oneshot_data();
		
		/***** DEFINE BEHAVIORS *****/
		// To Specify loop playback:
		//	1)	Have no affect on loops at all:						Do not call VM2_add_loops() at all in the behavior def block.
		//	2)	Turn on all loops:									VM2_add_loops("ALL");
		//	3)	Turn off all loops:									VM2_add_loops("NONE"), or VM2_add_loops([]), or VM2_add_loops();
		//	4)	Play only specific loops and turn off all others:	VM2_add_loops( [ <loop1_name>, <loop2_name>, <loop3_name> ] );
		VM2_begin_behavior_data();

			VM2_begin_behavior_def("to_state_hover",		::pdrone_condition_callback_to_state_hover,		["speed", "distance2d"]);
				VM2_add_loops("ALL"); // Leave this for testing: VM2_add_loops(["pdrn_rotor_ww_lw", "pdrn_rotor_ww_md", "pdrn_rotor_ww_hi"]);
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def("to_state_flying",		::pdrone_condition_callback_to_state_flying,	["speed", "distance2d"]);
				VM2_add_loops("ALL");
				VM2_add_oneshots("foo_oneshot");	//TESTING - returning a oneshot list on-the-fly.
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def("to_state_distant",		::pdrone_condition_callback_to_state_distant,	["distance2d"]);
				VM2_add_loops("NONE");
			VM2_end_behavior_def();				
				
			VM2_begin_behavior_def("to_state_flyby",		::pdrone_condition_callback_to_state_flyby,		["distance2d"]);
				VM2_add_loops("ALL");
				if (!kPDrn_Test_RetFlyByOnTheFly)
				{
					VM2_add_oneshots("pdrone_flyby");
				}
			VM2_end_behavior_def();	
			
			VM2_begin_behavior_def("to_state_deathspin",	::pdrone_condition_callback_to_state_deathspin);	// Stub.
				VM2_add_loops("NONE");
			VM2_end_behavior_def();	
			
			VM2_begin_behavior_def("to_state_destruct",		::pdrone_condition_callback_to_state_destruct);		// Stub.
				VM2_add_loops("NONE");
			VM2_end_behavior_def();	
			
			VM2_begin_behavior_def("to_state_off",			::pdrone_condition_callback_to_state_off);			// Stub.
				VM2_add_loops("NONE");
			VM2_end_behavior_def();	
			
		VM2_end_behavior_data();		
		
		/***** DEFINE STATES *****/
		VM2_begin_state_data(0.25, 50);
		
			VM2_begin_state_group("main_oneshots", "state_hover", "to_state_hover", 50, 1.0);
			
				VM2_begin_state_def("state_off");
					VM2_add_state_transition("state_hover",		"to_state_hover");
					VM2_add_state_transition("state_distant",	"to_state_distant");
				VM2_end_state_def();
			
				VM2_begin_state_def("state_hover");
					VM2_add_state_transition("state_flyby",		"to_state_flyby");
					VM2_add_state_transition("state_flying",	"to_state_flying");
					VM2_add_state_transition("state_distant",	"to_state_distant");
					VM2_add_state_transition("state_deathspin",	"to_state_deathspin");
					VM2_add_state_transition("state_destruct",	"to_state_destruct");
				VM2_end_state_def();

				VM2_begin_state_def("state_flying");
					VM2_add_state_transition("state_flyby",		"to_state_flyby");
					VM2_add_state_transition("state_distant",	"to_state_distant");
					VM2_add_state_transition("state_deathspin",	"to_state_deathspin");
					VM2_add_state_transition("state_destruct",	"to_state_destruct");
				VM2_end_state_def();
				
				VM2_begin_state_def("state_distant");
					VM2_add_state_transition("state_hover",		"to_state_hover");
					VM2_add_state_transition("state_flying",	"to_state_flying");
					VM2_add_state_transition("state_flyby",		"to_state_flyby");
					VM2_add_state_transition("state_deathspin",	"to_state_deathspin");
					VM2_add_state_transition("state_destruct",	"to_state_destruct");
				VM2_end_state_def();
				
				VM2_begin_state_def("state_flyby", 3.0);
					VM2_add_state_transition("state_hover",		"to_state_hover");
					VM2_add_state_transition("state_flying",	"to_state_flying");
					VM2_add_state_transition("state_flyby",		"to_state_flyby");
					VM2_add_state_transition("state_distant",	"to_state_distant");
					VM2_add_state_transition("state_deathspin",	"to_state_deathspin");
					VM2_add_state_transition("state_destruct",	"to_state_destruct");
				VM2_end_state_def();
						
				VM2_begin_state_def("state_deathspin");
					VM2_add_state_transition("state_destruct",	"to_state_destruct");
				VM2_end_state_def();
						
				VM2_begin_state_def("state_destruct");
					VM2_add_state_transition("state_off",		"to_state_off");
				VM2_end_state_def();
					
			VM2_end_state_group();
		
		VM2_end_state_data();
		
		
		/***** DEFINE ENVELOPES *****/
		VM2_add_envelope("pdrn_foo_env_function", ::foo_env_function);	// Can be a function.
		VM2_add_envelope("pdrn_loopset_vol_env",
			[
				[kPDrn_MaxSpeed * 0.0000,	(0.65 + 0.35 * 0.0000) * kPDrn_WindWand_Scalar],
				[kPDrn_MaxSpeed * 0.0204,	(0.65 + 0.35 * 0.0330) * kPDrn_WindWand_Scalar],
				[kPDrn_MaxSpeed * 0.0816,	(0.65 + 0.35 * 0.0587) * kPDrn_WindWand_Scalar],
				[kPDrn_MaxSpeed * 0.1836,	(0.65 + 0.35 * 0.1111) * kPDrn_WindWand_Scalar],
				[kPDrn_MaxSpeed * 0.3265,	(0.65 + 0.35 * 0.2214) * kPDrn_WindWand_Scalar],
				[kPDrn_MaxSpeed * 0.5102,	(0.65 + 0.35 * 0.4444) * kPDrn_WindWand_Scalar],
				[kPDrn_MaxSpeed * 0.7346,	(0.65 + 0.35 * 0.7901) * kPDrn_WindWand_Scalar],
				[kPDrn_MaxSpeed * 1.0000,	(0.65 + 0.35 * 1.0000) * kPDrn_WindWand_Scalar]
			]
		);
		
		VM2_add_envelope("pdrn_rotor_ww_lw",
			[
				[kPDrn_MaxSpeed * 0.000,	1.00],
				[kPDrn_MaxSpeed * 0.333,	1.00],
				[kPDrn_MaxSpeed * 0.666,	0.00],
				[kPDrn_MaxSpeed * 1.000,	0.00]
			]
		);
		
		VM2_add_envelope("pdrn_rotor_ww_md",
			[
				[kPDrn_MaxSpeed * 0.000,	0.00],
				[kPDrn_MaxSpeed * 0.333,	1.00],
				[kPDrn_MaxSpeed * 0.666,	1.00],
				[kPDrn_MaxSpeed * 1.000,	0.00]
			]
		);

		VM2_add_envelope("pdrn_rotor_ww_hi",
			[
				[kPDrn_MaxSpeed * 0.000,	0.00],
				[kPDrn_MaxSpeed * 0.333,	0.00],
				[kPDrn_MaxSpeed * 0.666,	1.00],
				[kPDrn_MaxSpeed * 1.000,	1.00]
			]
		);
		
		VM2_add_envelope("pdrn_rotor_vel2vol",
			[
				[kPDrn_MinSpeed,	kPDrn_Rotor_MinVol],
				[kPDrn_MaxSpeed,	kPDrn_Rotor_MaxVol]
			]
		);

		VM2_add_envelope("pdrn_rotor_vel2pch",
			[
				[kPDrn_MinSpeed,	kPDrn_Rotor_MinPch],
				[kPDrn_NomSpeed,	kPDrn_Rotor_NomPch],
				[kPDrn_MaxSpeed,	kPDrn_Rotor_MaxPch]
			]
		);
		
		VM2_add_envelope("pdrn_whine_vel2vol",
			[
				[kPDrn_MinSpeed,											kPDrn_Whine_MinVol],
				[kPDrn_MinSpeed + (kPDrn_MaxSpeed-kPDrn_MinSpeed)*0.666,	kPDrn_Whine_MinVol + (kPDrn_Whine_MaxVol-kPDrn_Whine_MinVol)*0.0],
				[kPDrn_MaxSpeed,											kPDrn_Whine_MaxVol]
			]
		);

		VM2_add_envelope("pdrn_whine_vel2pch",
			[
				[kPDrn_MinSpeed,	kPDrn_Whine_MinPch],
				[kPDrn_MaxSpeed,	kPDrn_Whine_MaxPch]
			]
		);
	
		VM2_add_envelope("pdrn_noise_lo_vel2vol",
			[
				[kPDrn_MinSpeed,										kPDrn_Noise_MinVol],
				[kPDrn_MinSpeed + (kPDrn_MaxSpeed-kPDrn_MinSpeed)*0.66,	kPDrn_Whine_MinVol],
				[kPDrn_MaxSpeed,										kPDrn_NoiseLo_MaxVol]
			]
		);
		
		VM2_add_envelope("pdrn_noise_hi_vel2vol",
			[
				[kPDrn_MinSpeed,										kPDrn_Noise_MinVol],
				[kPDrn_MinSpeed + (kPDrn_MaxSpeed-kPDrn_MinSpeed)*0.66,	kPDrn_Whine_MinVol],
				[kPDrn_MaxSpeed,										kPDrn_NoiseHi_MaxVol]
			]
		);
		
		VM2_add_envelope("pdrn_noise_vel2pch",
			[
				[kPDrn_MinSpeed,	kPDrn_Noise_MinPch],
				[kPDrn_MaxSpeed,	kPDrn_Noise_MinPch]
			]
		);
		
		VM2_add_envelope("pdrn_noise_hi_dist2vol",
			[
				[yards2dist(0),		kPDrn_NoiseHi_MaxVol],		// Closest, full on.
				[yards2dist(4),		kPDrn_NoiseHi_MaxVol*0.25],	// Med close, still kind of low.
				[yards2dist(6),		kPDrn_NoiseHi_MaxVol*0.4],	// Med close2, still kind of low.
				[yards2dist(8),		kPDrn_Noise_MinVol]			// Far, full off.
			]
		);

		VM2_add_envelope("pdrn_noise_lo_dist2vol",
			[
				[yards2dist(3),		kPDrn_NoiseLo_MaxVol],	// Start xfade in
				[yards2dist(12),	kPDrn_Noise_MinVol]		// Full off.
			]
		);
		
		VM2_add_envelope("pdrn_flyby_vel2vol",
			[
				[kPDrn_MinSpeed,	kPDrn_Flyby_MinVol],
				//[kPDrn_MinSpeed + (kPDrn_MaxSpeed-kPDrn_MaxSpeed)*0.5,	kPDrn_Flyby_MaxVol*0.666],
				[kPDrn_MaxSpeed,	kPDrn_Flyby_MaxVol]
			]
		);
		
		VM2_add_envelope("pdrn_flyby_vel2pch",
			[
				[kPDrn_MinSpeed,	kPDrn_Flyby_MinPch],
				[kPDrn_MaxSpeed,	kPDrn_Flyby_MaxPch]
			]
		);
		
		VM2_add_envelope("pdrn_flyby_duck_envelope",
			[
				[0.00,  1.00],
				[0.33,  0.33],
				[0.66,  0.33],
				[1.33,  1.00]
			]
		);

		VM2_add_envelope("pdrn_doppler2pch",
			[
				[0.00,	0.00],
				[2.00,	2.00]
			]
		);

	VM2_end_preset_def();
}

foo_env_function()
{
	return 1.0;
}

////////////////////////
// BEHAVIOR CALLBACKS //
////////////////////////

// Constants used in callbacks only.
kPDrn_Speed_HoverThreshold	= 5.1;	// MPH
kPDrn_Dist_Threshold		= 20.0;	// yards
kPDrn_Flyby_DistThreshold	= 6.0;	// yards
kPDrn_Flyover_Radius		= 30;

pdrone_condition_callback_to_state_off()
{
	return false;	
}
	
pdrone_condition_callback_to_state_hover(curr_smoothed_input_keyed_values, vars)
{
	result		= false;
	//velo 		= curr_smoothed_input_keyed_values["relative_speed"];
	velo 		= curr_smoothed_input_keyed_values["speed"];
	dist		= curr_smoothed_input_keyed_values["distance2d"];
	curr_yards	= dist2yards(dist);
	
	// STATE TRIGGER CONDITION.
	if (velo <= kPDrn_Speed_HoverThreshold  && curr_yards < kPDrn_Dist_Threshold)
	{
		result = true;
	}
	
	return result;
}

pdrone_condition_callback_to_state_flying(curr_smoothed_input_keyed_values, vars)
{
	result		= false;
	//velo 		= curr_smoothed_input_keyed_values["relative_speed"];
	velo 		= curr_smoothed_input_keyed_values["speed"];
	dist		= curr_smoothed_input_keyed_values["distance2d"];
	curr_yards	= dist2yards(dist);
	
	// STATE TRIGGER CONDITION.
	if (velo > kPDrn_Speed_HoverThreshold && curr_yards < kPDrn_Dist_Threshold)
	{
		result = true;
	}
	
	return result;
}

pdrone_condition_callback_to_state_distant(curr_smoothed_input_keyed_values, vars)
{
	result		= false;
	dist		= curr_smoothed_input_keyed_values["distance2d"];
	curr_yards	= dist2yards(dist);
	
	// STATE TRIGGER CONDITION.
	if (curr_yards >= kPDrn_Dist_Threshold)	
	{
		result = true;
	}
	
	return result;
}

pdrone_condition_callback_to_state_flyby(curr_smoothed_input_keyed_values, vars)
{
	result		= false;
	dist		= curr_smoothed_input_keyed_values["distance2d"];
	curr_yards	= dist2yards(dist);

	if (!IsDefined(vars.flyby))
    {
		vars.flyby = SpawnStruct();
    	vars.flyby.prev_yards = curr_yards;
    	vars.flyby.prev_dx = 0;
    }
	else
	{
		curr_dx = curr_yards - vars.flyby.prev_yards;
		
		// STATE TRIGGER CONDITION.
		if (curr_dx < 0 && curr_yards < kPDrn_Flyby_DistThreshold)	
		{
			if (kPDrn_Test_RetFlyByOnTheFly)
			{
				// TESTING:  testing the return of an oneshot reference, rather than returning true and embedding the reference in the behavior.
				result = ["pdrone_flyby"];
			}
			else
			{
				result = true;
				//IPrintLn("state_flyby returning true");
			}					
		}
		
		vars.flyby.prev_yards	= curr_yards;
    	vars.flyby.prev_dx		= curr_dx;
	}
	
	return result;
}

pdrone_condition_callback_to_state_flyover(curr_smoothed_input_keyed_values, vars)
{
	result = false;
	dist = curr_smoothed_input_keyed_values["distance2d"];
	velo = curr_smoothed_input_keyed_values["relative_speed"];
	yards = dist2yards(dist);
	
	if (yards < kPDrn_Flyover_Radius)
	{
		result = true;
	}
	
	return result;
}

pdrone_condition_callback_to_state_deathspin(curr_smoothed_input_keyed_values, vars)
{
	return false;	
}

pdrone_condition_callback_to_state_destruct(curr_smoothed_input_keyed_values, vars)
{
	return false;	
}
		
//////////////////////////////
// INPUT MODIFIER CALLBACKS //
//////////////////////////////
pdrone_speed_modifier_callback_smoother(actual_speed, vars)
{	
	// First time?  Init...
	if ( !IsDefined( vars.input_scalar_target ) )
	{	
		vars.input_scalar_target	= 1.0;
		vars.input_scalar_actual	= 1.0;
		vars.min_range				= 0.7;
		vars.max_range				= 1.2;
		vars.smooth_up				= 0.65;
		vars.smooth_down			= 0.30;
	}

	// Time to get new target value to use next time around?
	if ( abs( vars.input_scalar_actual - vars.input_scalar_target ) < 0.0001 )
	{
		vars.input_scalar_target = RandomFloatRange( vars.min_range, vars.max_range );
	}
	
	if ( vars.input_scalar_target > vars.input_scalar_actual )	// Scaling input going up, or going down?
	{
		smooth_operator =  vars.smooth_up;
	}
	else
	{
		smooth_operator =  vars.smooth_down;
	}
	
	vars.input_scalar_actual = vars.input_scalar_actual + smooth_operator * ( vars.input_scalar_target - vars.input_scalar_actual );
	

	return actual_speed * vars.input_scalar_actual;
}

kPDrn_InputModifier_Perlin_NoiseFrq	= 1.0;	// Hertz.
kPDrn_InputModifier_Perlin_NoiseAmp	= 1.0;	// Degrees.
// See so_spotlight_castle.gsc for PerlinNoise2D() use case.
pdrone_speed_modifier_callback_perlin_noise(actual_speed, vars)
{	
	// Init persitent vars first time through.
	if ( !IsDefined( vars.input_scalar_target ) )
	{
		vars.world_x = 0;
	}
	vars.world_x += 1;
	
	// world_x		= vars.world_x; //GetTime() * 0.001;
	world_x		= GetTime() * 0.001;
	world_y		= 0;
	octaves		= 2;
	lacunarity	= 2;
	gain		= 1;
	noise		= PerlinNoise2D(world_x, world_y, octaves, lacunarity, 1);
	
	return actual_speed * 1;
}

kPDrn_InputModifier_Linear_MinScalar	= 0.7;	// Mulitplier.
kPDrn_InputModifier_Linear_MaxScalar	= 1.2;	// Mulitplier.
kPDrn_InputModifier_Linear_MinTime	= 500;	// MSecs.
kPDrn_InputModifier_Linear_MaxTime	= 2000;	// MSces.
pdrone_speed_modifier_callback_linear(actual_speed, vars)
{	
	// Init persitent vars first time through.
	if ( !IsDefined( vars.input_scalar_target ) || ( GetTime() >= vars.input_start_time + vars.input_delta_time) )
	{	
		vars.input_scalar_actual	= 1.0;
		vars.input_scalar_target	= RandomFloatRange(	kPDrn_InputModifier_Linear_MinScalar,	kPDrn_InputModifier_Linear_MaxScalar );
		vars.input_start_time		= GetTime();
		vars.input_delta_time		= RandomIntRange(	kPDrn_InputModifier_Linear_MinTime,	kPDrn_InputModifier_Linear_MinTime );
	}
	
	inc = (vars.input_scalar_target - vars.input_scalar_actual) / vars.input_delta_time;
	vars.input_scalar_actual += inc;
	
	return actual_speed * 1;
}







