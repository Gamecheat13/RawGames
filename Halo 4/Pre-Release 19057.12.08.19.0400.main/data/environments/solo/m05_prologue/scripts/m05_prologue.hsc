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

script startup m05_prologue()
	
	thread (m05_prologue_play());

end

script static void m05_prologue_play()
	
	dprint ("playing");
	cinematic_enter( cin_m005_prologue, FALSE );
        cinematic_outro_start();
	f_start_mission( cin_m005_prologue );
	cinematic_exit_no_fade( cin_m005_prologue, FALSE );
	dprint( "Cinematic exited!" );
        fade_out( 0, 0, 0, 0 );
        sleep( 1 );
        game_won( );
        sleep( 0 );

end

; Zone Set Index
global short zs_prologue_idx 			    = 0;	// default / start

; Insertion Index
global short prologue_ins_idx 			  = 0;	// default / start

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
 
 if (s_insertion == prologue_ins_idx) then
  b_started = TRUE;
  ins_prologue();
 end
 
 if ( not b_started ) then
  dprint( "f_insertion_index_load: ERROR: Failed to find insertion point index to load" );
  inspect( s_insertion );
 end

end

script static zone_set f_zoneset_get( short s_index )
local zone_set zs_return = "prologue"; 

 if ( s_index == zs_prologue_idx ) then
  zs_return = "prologue";
 end

 zs_return;
end

; =================================================================================================
; INSERTION
; =================================================================================================

script static void ipro()
	f_insertion_reset( prologue_ins_idx );
end

script static void ins_prologue()

	f_insertion_begin( "PROLOGUE" );
	f_insertion_zoneload( zs_prologue_idx, FALSE );
	f_insertion_playerwait();
	//f_insertion_teleport( ps_insertion_py1_start.p0, ps_insertion_py1_start.p1, ps_insertion_py1_start.p2, ps_insertion_py1_start.p3 );
	f_insertion_end();
	
	thread (m05_prologue_play());
	dprint ("start playing here");

end