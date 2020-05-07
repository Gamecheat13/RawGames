//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m05_prologue
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

; Mission Started
global boolean b_mission_started 		=	FALSE;
global boolean b_game_emulate				= FALSE;

script startup m95_epilogue()
	
	thread (m95_epilogue_play());
	dprint ("start playing here");

end

script dormant title_test
	
	cinematic_set_title (thank_you_1);
	dprint ("thanks 1 placed");
	sleep (45);
	cinematic_set_title (thank_you_2);
	dprint ("thanks 2 placed");
	sleep (45);
	cinematic_set_title (thank_you_3);
	dprint ("thanks 3 placed");
	sleep (45);
	cinematic_set_title (thank_you_4);
	dprint ("thanks 4 placed");
	sleep (45);
	cinematic_set_title (thank_you_5);
	dprint ("thanks 5 placed");
	sleep (45 * 2);
	
end

script static void m95_epilogue_play()
	
	dprint ("playing ending");
	
	cinematic_enter( cin_m095_ending, FALSE );
	f_start_mission( cin_m095_ending );
	cinematic_exit_no_fade( cin_m095_ending, FALSE );
	dprint( "Cinematic exited!" );
	
	player_enable_input (FALSE);
	dprint ("disabling player input");
	
	sleep (30);
	
	dprint ("playing thank you message");
	
	//cinematic_set_title (thank_you_1);
	//sleep (30);
	//cinematic_set_title (thank_you_2);
	//sleep (30);
	//cinematic_set_title (thank_you_3);
	//sleep (30);
	//cinematic_set_title (thank_you_4);
	//sleep (30);
	//cinematic_set_title (thank_you_5);
	

	cinematic_set_title (thank_you_full);
	sleep (30);
	cinematic_set_title (thank_you_343);
	sleep (30 * 16);
	player_enable_input (TRUE);
	dprint ("enabling player input");
	
	//cinematic_enter( cin_m095_credits, FALSE );
	//f_start_mission( cin_m095_credits );
	//cinematic_exit_no_fade( cin_m095_credits, FALSE );
	//dprint( "Cinematic exited!" );	
	
	dprint ("playing credits");
	
	cinematic_enter( m095_credits, FALSE );
	f_start_mission( m095_credits );
	cinematic_exit_no_fade( m095_credits, FALSE );
	dprint( "Cinematic exited!" );
	
	sleep (30);
	
	if game_difficulty_get_real() <= heroic then
	
		dprint ("playing normal epilogue");
		
		cinematic_enter( cin_m095_epilogue, FALSE );
		f_start_mission( cin_m095_epilogue );
		cinematic_exit_no_fade( cin_m095_epilogue, FALSE );
		dprint( "Cinematic exited!" );

	elseif game_difficulty_get_real() >= legendary then
	
		dprint ("playing legendary epilogue");
		
		cinematic_enter( cin_m095_epilogue_legendary, FALSE );
		f_start_mission( cin_m095_epilogue_legendary );
		cinematic_exit_no_fade( cin_m095_epilogue_legendary, FALSE );
		dprint( "Cinematic exited!" );
		
	end
	
	sleep (30);
	
	dprint ("thanks for playing halo 4: the halolololing");
	
	game_won();
	
		
end

; Zone Set Index
global short zs_epilogue_idx 			    = 0;	// default / start

; Insertion Index
global short epilogue_ins_idx 			  = 0;	// default / start

; Zone Sets
global short s_zoneset_all					  = 0;

; =================================================================================================
; =================================================================================================
; *** INSERTIONS ***
; =================================================================================================
; =================================================================================================

script static void f_insertion_index_load( short s_insertion )
local boolean b_started = FALSE;
 //dprint( "::: f_insertion_index_load :::" );
 inspect( s_insertion );
 
 if (s_insertion == epilogue_ins_idx) then
  b_started = TRUE;
  ins_epilogue();
 end
 
 if ( not b_started ) then
  dprint( "f_insertion_index_load: ERROR: Failed to find insertion point index to load" );
  inspect( s_insertion );
 end

end

script static zone_set f_zoneset_get( short s_index )
local zone_set zs_return = "epilogue"; 

 if ( s_index == zs_epilogue_idx ) then
  zs_return = "epilogue";
 end

 zs_return;
end




; =================================================================================================
; PORTAL
; =================================================================================================

script static void iend()
	f_insertion_reset( epilogue_ins_idx );
end

script static void ins_epilogue()

	f_insertion_begin( "EPILOGUE" );
	f_insertion_zoneload( zs_epilogue_idx, FALSE );
	f_insertion_playerwait();
	//f_insertion_teleport( ps_insertion_py1_start.p0, ps_insertion_py1_start.p1, ps_insertion_py1_start.p2, ps_insertion_py1_start.p3 );
	f_insertion_end();
	
	thread (m95_epilogue_play());
	dprint ("start playing here");

end

script dormant msg_test

	cinematic_set_title (thank_you_full);
	sleep (30);
	cinematic_set_title (thank_you_343);
	sleep (30 * 14);

end