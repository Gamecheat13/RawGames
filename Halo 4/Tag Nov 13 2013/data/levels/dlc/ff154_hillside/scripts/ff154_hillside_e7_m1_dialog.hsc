//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E7M1 - Abort
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: DIALOG ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script dormant f_e7_m1_dialog_intro()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e7_m1_dialog_intro" );
					
	l_dialog_id = dialog_start_foreground( "e7_m1_dialog_intro", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: So yeah, some portals need to get blown up or something.", FALSE );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_e7_m1_dialog_start()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e7_m1_dialog_start" );
					
	l_dialog_id = dialog_start_foreground( "e7_m1_dialog_start", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
		dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Good luck bros.", FALSE );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_e7_m1_dialog_abort_start()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	dprint( "f_e7_m1_dialog_abort_start" );
					
	l_dialog_id = dialog_start_foreground( "e7_m1_dialog_abort_start", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), TRUE, "", 0.25 );                       
		dialog_line_radio( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "INFINITY: Shit got F'd in the A'.  You need to GTFO.", FALSE );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end
