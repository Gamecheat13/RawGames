//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
/*
obj_<OBJECTIVE 1>				= "<OBJECTIVE TEXT>"
obj_<OBJECTIVE 2>				= "<OBJECTIVE TEXT>"
*/									

// =================================================================================================
// =================================================================================================
// OBJECTIVES
// =================================================================================================
// =================================================================================================

// Defines
global real DEF_R_OBJECTIVE_INFINITY_PELICAN											 = 0.1;

//FLIGHT
 script static real DEF_R_OBJECTIVE_FLIGHT_REVEAL()								 0.2; end
 script static real DEF_R_OBJECTIVE_FLIGHT_SPIRE_CHOOSE()					 0.3; end
 script static real DEF_R_OBJECTIVE_FLIGHT_SPIRE_01()							 0.4; end
 script static real DEF_R_OBJECTIVE_FLIGHT_SPIRE_02()							 0.5; end
 script static real DEF_R_OBJECTIVE_FLIGHT_SPIRE_03()							 0.6; end
 script static real DEF_R_OBJECTIVE_FLIGHT_SPIRE_DOOR()						 0.7; end
//SPIRE 03
 script static real DEF_R_OBJECTIVE_SPIRE_01_ENTER()							 1.0; end
 script static real DEF_R_OBJECTIVE_SPIRE_01_START()							 1.1; end
 script static real DEF_R_OBJECTIVE_SPIRE_01_RIDE_TW01()					 1.2; end
 script static real DEF_R_OBJECTIVE_SPIRE_01_SWITCH_TW01()				 1.3; end
 script static real DEF_R_OBJECTIVE_SPIRE_01_RIDE_TW02()					 1.4; end
 script static real DEF_R_OBJECTIVE_SPIRE_01_SWITCH_TW02()				 1.5; end
 script static real DEF_R_OBJECTIVE_SPIRE_01_SWITCH_MAIN()				 1.6; end
 script static real DEF_R_OBJECTIVE_SPIRE_01_RIDE_LAST()					 1.7; end
 script static real DEF_R_OBJECTIVE_SPIRE_01_EXIT()								 1.8; end
//SPIRE 02
 script static real DEF_R_OBJECTIVE_SPIRE_02_ENTER()							 2.0; end
 script static real DEF_R_OBJECTIVE_SPIRE_02_START()							 2.1; end
 script static real DEF_R_OBJECTIVE_SPIRE_02_SWITCH_CORES()				 2.2; end
 script static real DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_03()			 2.3; end
 script static real DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_02()			 2.4; end
 script static real DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_01()			 2.5; end
 script static real DEF_R_OBJECTIVE_SPIRE_02_CORE_DESTROYED()			 2.6; end
 script static real DEF_R_OBJECTIVE_SPIRE_02_END()								 2.7; end
 script static real DEF_R_OBJECTIVE_SPIRE_02_EXIT()								 2.8; end
//SPIRE 03
 script static real DEF_R_OBJECTIVE_SPIRE_03_ENTER()							 3.0; end
 script static real DEF_R_OBJECTIVE_SPIRE_03_START()							 3.1; end
 script static real DEF_R_OBJECTIVE_SPIRE_03_BOTTOM_FLOOR()				 3.2; end
 script static real DEF_R_OBJECTIVE_SPIRE_03_TOP_FLOOR()				 		3.3; end
 script static real DEF_R_OBJECTIVE_SPIRE_03_CONTROL_ROOM_ENTER()	 	3.4; end
 script static real DEF_R_OBJECTIVE_SPIRE_03_CONTROL_ROOM_SWITCH()			3.9; end

script static real DEF_R_OBJECTIVE_LICH()														4.0; end



/*
ct_obj_start				 	= "OBJECTIVE: BOARD THE PELICAN"
ct_obj_main 					= "OBJECTIVE: STOP THE DIDACT"
ct_obj_spire_start		= "OBJECTIVE: DISABLE THE TOWERS"
ct_obj_spire_01				= "OBJECTIVE: NEURTALIZE THE CARRIER WAVE GENERATOR"
ct_obj_spire_02				= "OBJECTIVE: DESTROY THE ATTENUATORS"
ct_obj_spire_final 		= "OBJECTIVE: ENTER THE PRODUCTION TOWER"
ct_obj_spire_03 			= "OBJECTIVE: REACH THE SPIRE CONTROLS"
ct_obj_pelican_return = "OBJECTIVE: RETURN TO THE PELICAN"
*/
//f_m70_objective_complete(ct_obj_main )
//f_m70_objective_set(ct_obj_main);
//f_m70_objective_set(ct_obj_reveal);

//f_m70_objective_complete(ct_obj_reveal )
//f_m70_objective_set(ct_obj_spire_start);
//f_m70_objective_complete(ct_obj_spire_start )
//f_m70_objective_set(ct_obj_spire_start);
//f_m70_objective_complete(ct_obj_spire_01 )
//f_m70_objective_set(ct_obj_spire_01);
//f_m70_objective_complete(ct_obj_main )
//f_m70_objective_set(ct_obj_main);
//f_m70_objective_complete(ct_obj_main )
//f_m70_objective_set(ct_obj_main);

script static void f_m70_objective_set(string_id str_obj)
	dprint ("objective update");
	cui_hud_set_new_objective (str_obj);
end

script static void f_m70_objective_complete(string_id str_obj )
	dprint ("objective complete");
	cui_hud_set_objective_complete(str_obj);
	
end
/*
//global short DEF_R_OBJECTIVE_<OBJECTIVE_2>									= 1;
global real DEF_R_OBJECTIVE_LICH_01														= 4.0;
global real DEF_R_OBJECTIVE_LICH_02														= 4.1;
global real DEF_R_OBJECTIVE_LICH_03														= 4.2;
global real DEF_R_OBJECTIVE_LICH_04														= 4.3;
global real DEF_R_OBJECTIVE_LICH_05														= 4.4;
*/



// variables
	/*
	// DEF_R_OBJECTIVE_<OBJECTIVE_2>
	if ( r_index == DEF_R_OBJECTIVE_<OBJECTIVE_2> ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end	
	*/
	
// functions
// === f_mission_objective_blip: Blips an objective index
script static boolean f_mission_objective_blip( real r_index, boolean b_blip )
static boolean b_blipped = FALSE;
	// set the default return value
	b_blipped = FALSE;

	//dprint( "::: f_mission_objective_blip :::" );
	inspect( r_index );
	
	// DEF_R_OBJECTIVE_INFINITY_PELICAN
	if ( r_index == DEF_R_OBJECTIVE_INFINITY_PELICAN ) then
		if ( b_blip ) then
			f_blip_object( inf_pelican_gunship, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_object( inf_pelican_gunship );
			b_blipped = TRUE;
		end
	end	

	// DEF_R_OBJECTIVE_FLIGHT_REVEAL
	if ( r_index == DEF_R_OBJECTIVE_FLIGHT_REVEAL() ) then
		if ( b_blip ) then
			//f_blip_flag( flg_didact_core_ship, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			//f_unblip_flag( flg_didact_core_ship );
			b_blipped = TRUE;
		end
	end	

		// DEF_R_OBJECTIVE_FLIGHT_SPIRE_CHOOSE
	if ( r_index == DEF_R_OBJECTIVE_FLIGHT_SPIRE_CHOOSE() ) then
		if ( b_blip ) then
//			f_blip_object( spire_exterior_door_01, "default" );
//			f_blip_object( spire_exterior_door_02, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
//			f_unblip_object( spire_exterior_door_01 );
	//		f_unblip_object( spire_exterior_door_02 );
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_FLIGHT_SPIRE_01
	if ( r_index == DEF_R_OBJECTIVE_FLIGHT_SPIRE_01() ) then
		if ( b_blip ) then
		//f_blip_object( spire_exterior_door_01, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
		//f_unblip_object( spire_exterior_door_01 );
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_FLIGHT_SPIRE_02
	if ( r_index == DEF_R_OBJECTIVE_FLIGHT_SPIRE_02() ) then
		if ( b_blip ) then
		//f_blip_object( spire_exterior_door_02, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
		//f_unblip_object( spire_exterior_door_02 );
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_FLIGHT_SPIRE_03
	if ( r_index == DEF_R_OBJECTIVE_FLIGHT_SPIRE_03() ) then
		if ( b_blip ) then
			//f_blip_object( spire_exterior_door_03, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			//f_unblip_object( spire_exterior_door_01 );
			b_blipped = TRUE;
		end
	end	

	// DEF_R_OBJECTIVE_FLIGHT_SPIRE_DOOR
	if ( r_index == DEF_R_OBJECTIVE_FLIGHT_SPIRE_DOOR() ) then
		if ( b_blip ) then
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_ENTER
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_01_ENTER() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_START
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_01_START() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_RIDE_TW01
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_01_RIDE_TW01() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_SWITCH_TW01
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_01_SWITCH_TW01() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_RIDE_TW02
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_01_RIDE_TW02() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_SWITCH_TW02
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_01_SWITCH_TW02() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_SWITCH_TW02
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_01_SWITCH_TW02() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_SWITCH_MAIN
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_01_SWITCH_MAIN() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_SWITCH_MAIN
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_01_SWITCH_MAIN() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	// DEF_R_OBJECTIVE_SPIRE_01_RIDE_LAST
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_01_RIDE_LAST() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	// DEF_R_OBJECTIVE_SPIRE_01_EXIT
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_01_EXIT() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	// DEF_R_OBJECTIVE_SPIRE_02_ENTER
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_02_ENTER() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	// DEF_R_OBJECTIVE_SPIRE_02_START
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_02_START() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	//DEF_R_OBJECTIVE_SPIRE_02_SWITCH_CORES
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_02_SWITCH_CORES()	) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	//DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_03
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_03()	) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	//DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_02
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_02() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	//DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_01
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_01() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	//DEF_R_OBJECTIVE_SPIRE_02_CORE_DESTROYED
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_02_CORE_DESTROYED() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	//DEF_R_OBJECTIVE_SPIRE_02_END
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_02_END() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	//DEF_R_OBJECTIVE_SPIRE_02_EXIT
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_02_EXIT() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end

	//DEF_R_OBJECTIVE_SPIRE_03_ENTER
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_03_ENTER() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	//DEF_R_OBJECTIVE_SPIRE_03_START
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_03_START() ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end
	
	//DEF_R_OBJECTIVE_SPIRE_03_BOTTOM_FLOOR
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_03_BOTTOM_FLOOR()	 ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end	

	//DEF_R_OBJECTIVE_SPIRE_03_BOTTOM_FLOOR
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_03_BOTTOM_FLOOR()	 ) then
		if ( b_blip ) then
			// XXX_TODO: BLIPPING CODE
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			// XXX_TODO: UNBLIPPING CODE
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_03_TOP_FLOOR
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_03_TOP_FLOOR()	 ) then
		if ( b_blip ) then
			f_blip_flag( flag_sp03_control, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_flag( flag_sp03_control );
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_03_CONTROL_ROOM_ENTER
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_03_CONTROL_ROOM_ENTER()	 ) then
		if ( b_blip ) then
			f_blip_object( top_spire_switch_01, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_object( top_spire_switch_01 );
			b_blipped = TRUE;
		end
	end	
	
		if ( r_index == DEF_R_OBJECTIVE_SPIRE_03_CONTROL_ROOM_SWITCH()	 ) then
		if ( b_blip ) then
			f_blip_object( top_spire_switch_01, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_object( top_spire_switch_01 );
			b_blipped = TRUE;
		end
	end	
	
	// DEF_R_OBJECTIVE_LICH
	if ( r_index == DEF_R_OBJECTIVE_LICH() ) then
		if ( b_blip ) then
			f_blip_flag( flg_lich_jump, "recon" ); 
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
		 	f_unblip_object( scn_lich_target_01 );
			b_blipped = TRUE;
		end
	end	
/*	
	// DEF_R_OBJECTIVE_LICH_01
	if ( r_index == DEF_R_OBJECTIVE_LICH_01 ) then
		if ( b_blip ) then
			f_blip_object( m_lich_01, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
		 	f_unblip_object( m_lich_01 );
			b_blipped = TRUE;
		end
	end	

	// DEF_R_OBJECTIVE_LICH_02
	if ( r_index == DEF_R_OBJECTIVE_LICH_02 ) then
		if ( b_blip ) then
			f_blip_object( m_lich_02, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_object( m_lich_02 );
			b_blipped = TRUE;
		end
	end	

	// DEF_R_OBJECTIVE_LICH_03
	if ( r_index == DEF_R_OBJECTIVE_LICH_03 ) then
		if ( b_blip ) then
			f_blip_object( m_lich_03, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_object( m_lich_03 );
			b_blipped = TRUE;
		end
	end	

	// DEF_R_OBJECTIVE_LICH_04
	if ( r_index == DEF_R_OBJECTIVE_LICH_04 ) then
		if ( b_blip ) then
			f_blip_object( m_lich_04, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_object( m_lich_04 );
			b_blipped = TRUE;
		end
	end	

	// DEF_R_OBJECTIVE_LICH_05
	if ( r_index == DEF_R_OBJECTIVE_LICH_05 ) then
		if ( b_blip ) then
			f_blip_object( m_lich_05, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_object( m_lich_05 );
			b_blipped = TRUE;
		end
	end	
*/
	// return if something was blipped
	b_blipped;

end

// === f_mission_objective_title: Returns the index title title
script static string_id f_mission_objective_title( real r_index )
local string_id sid_return = SID_objective_none;
	
	// DEF_R_OBJECTIVE_INFINITY_PELICAN
	if ( r_index == DEF_R_OBJECTIVE_INFINITY_PELICAN ) then
		sid_return = 'ct_obj_main';
	end	

	// DEF_R_OBJECTIVE_FLIGHT_REVEAL
	if ( r_index ==  DEF_R_OBJECTIVE_FLIGHT_REVEAL()	 ) then
		sid_return = 'ct_obj_spire_first';
	end	
	
	// DEF_R_OBJECTIVE_FLIGHT_SPIRE_CHOOSE
	if ( r_index ==  DEF_R_OBJECTIVE_FLIGHT_SPIRE_CHOOSE() ) then
		sid_return = 'ct_obj_spire_start';
	end	
	
	// DEF_R_OBJECTIVE_FLIGHT_SPIRE_01
	if ( r_index ==  DEF_R_OBJECTIVE_FLIGHT_SPIRE_01() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_FLIGHT_SPIRE_02
	if ( r_index ==  DEF_R_OBJECTIVE_FLIGHT_SPIRE_02() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_FLIGHT_SPIRE_03
	if ( r_index ==  DEF_R_OBJECTIVE_FLIGHT_SPIRE_03() ) then
		sid_return = 'ct_obj_spire_final';
	end	
	
	// DEF_R_OBJECTIVE_FLIGHT_SPIRE_DOOR
	if ( r_index ==    DEF_R_OBJECTIVE_FLIGHT_SPIRE_DOOR() ) then
		sid_return = SID_objective_none;
	end	

	// DEF_R_OBJECTIVE_FLIGHT_SPIRE_DOOR
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_01_ENTER() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_START
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_01_START() ) then
		sid_return = 'ct_obj_spire_01';
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_RIDE_TW01
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_01_RIDE_TW01() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_SWITCH_TW01
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_01_SWITCH_TW01() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_RIDE_TW02
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_01_RIDE_TW02() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_SWITCH_TW02
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_01_SWITCH_TW02() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_FLIGHT_SPIRE_DOOR
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_01_ENTER() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_SWITCH_MAIN
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_01_SWITCH_MAIN() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_RIDE_LAST
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_01_RIDE_LAST() ) then
		sid_return = 'ct_obj_pelican_return';
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_01_EXIT
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_01_EXIT() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_02_ENTER
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_02_ENTER() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_02_START
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_02_START() ) then
		sid_return = 'ct_obj_spire_02';
	end	

	// DEF_R_OBJECTIVE_SPIRE_02_SWITCH_CORES
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_02_SWITCH_CORES() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_03
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_03() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_02
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_02() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_01
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_02_CORE_COUNT_01() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_02_CORE_DESTROYED
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_02_CORE_DESTROYED() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_02_END
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_02_END() ) then
		sid_return = 'ct_obj_pelican_return';
	end	

	// DEF_R_OBJECTIVE_SPIRE_02_EXIT
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_02_EXIT() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_03_ENTER
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_03_ENTER() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_03_START
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_03_START() ) then
		sid_return = 'SID_objective_none';
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_03_BOTTOM_FLOOR
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_03_BOTTOM_FLOOR() ) then
		sid_return = SID_objective_none;
	end	
	
	// DEF_R_OBJECTIVE_SPIRE_03_TOP_FLOOR
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_03_TOP_FLOOR() ) then
		sid_return = SID_objective_none;
	end	

	// DEF_R_OBJECTIVE_SPIRE_03_CONTROL_ROOM_ENTER
	if ( r_index ==    DEF_R_OBJECTIVE_SPIRE_03_CONTROL_ROOM_ENTER() ) then
		sid_return = SID_objective_none;
	end	

	// DEF_R_OBJECTIVE_SPIRE_03_CONTROL_ROOM_SWITCH
	if ( r_index == DEF_R_OBJECTIVE_SPIRE_03_CONTROL_ROOM_SWITCH() ) then
		sid_return = SID_objective_none;	// XXX TODO - SETUP REAL TEXT ID
	end	

	// DEF_R_OBJECTIVE_LICH_01
	if ( r_index == DEF_R_OBJECTIVE_LICH() ) then
		sid_return = SID_objective_none;	// XXX TODO - SETUP REAL TEXT ID
	end	
	
	/*
	// DEF_R_OBJECTIVE_LICH_01
	if ( r_index == DEF_R_OBJECTIVE_LICH_01 ) then
		sid_return = SID_objective_none;	// XXX TODO - SETUP REAL TEXT ID
	end	

	// DEF_R_OBJECTIVE_LICH_02
	if ( r_index == DEF_R_OBJECTIVE_LICH_02 ) then
		sid_return = SID_objective_none;	// XXX TODO - SETUP REAL TEXT ID
	end	

	// DEF_R_OBJECTIVE_LICH_03
	if ( r_index == DEF_R_OBJECTIVE_LICH_03 ) then
		sid_return = SID_objective_none;	// XXX TODO - SETUP REAL TEXT ID
	end	

	// DEF_R_OBJECTIVE_LICH_04
	if ( r_index == DEF_R_OBJECTIVE_LICH_04 ) then
		sid_return = SID_objective_none;	// XXX TODO - SETUP REAL TEXT ID
	end	

	// DEF_R_OBJECTIVE_LICH_05
	if ( r_index == DEF_R_OBJECTIVE_LICH_05 ) then
		sid_return = SID_objective_none;	// XXX TODO - SETUP REAL TEXT ID
	end	
	*/

	// return
	sid_return;

	/*
	// DEF_R_OBJECTIVE_<OBJECTIVE_2>
	if ( r_index == DEF_R_OBJECTIVE_<OBJECTIVE_2> ) then
		sid_return = 'obj_<objective_2>';
	end	
	*/
end

// === f_mission_objective_missioncomplete::: Handles all the general mission complete
script static void f_mission_objective_missioncomplete()
	dprint( "::: f_mission_objective_missioncomplete :::" );

	// disable controls, etc
	player_action_test_reset();

	player_enable_input( 0 );
	camera_control( 1 );

	// complete current index
	f_objective_complete( f_objective_current_index(), FALSE, TRUE );
	
	// play end cinematic
	f_cinematic_close();
	
	// general mission complete
	f_objective_missioncomplete();

end
