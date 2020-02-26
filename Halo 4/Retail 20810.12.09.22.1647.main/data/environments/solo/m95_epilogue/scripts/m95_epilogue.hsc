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
	
	local long epilogue_bink_a_thread = thread( f_epilogue_part_a_bink() );
	f_start_mission( cin_m095_ending );
	cinematic_exit_no_fade( cin_m095_ending, FALSE );
	kill_thread( epilogue_bink_a_thread );
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

	music_set_state('Play_mus_epilogue_credits_01');
		
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

	music_set_state('Play_mus_epilogue_end');
	
	sleep (30);
	
	local boolean legendaryCompleted = TRUE;
	if (player_valid(player0) and not campaign_is_completed_on_legendary(player0)) then
		legendaryCompleted = FALSE;
	elseif (player_valid(player1) and not campaign_is_completed_on_legendary(player1)) then
		legendaryCompleted = FALSE;
	elseif (player_valid(player2) and not campaign_is_completed_on_legendary(player2)) then
		legendaryCompleted = FALSE;
	elseif (player_valid(player3) and not campaign_is_completed_on_legendary(player3)) then
		legendaryCompleted = FALSE;
	end
	
	local long epilogue_bink_b_thread = thread( f_epilogue_part_b_bink() );
	
	if (legendaryCompleted == FALSE) then
	
		dprint ("playing normal epilogue");
		
		cinematic_enter( cin_m095_epilogue, FALSE );
		f_start_mission( cin_m095_epilogue );
		cinematic_exit_no_fade( cin_m095_epilogue, FALSE );
		dprint( "Cinematic exited!" );

	else
	
		dprint ("playing legendary epilogue");
		
		cinematic_enter( cin_m095_epilogue_legendary, FALSE );
		f_start_mission( cin_m095_epilogue_legendary );
		cinematic_exit_no_fade( cin_m095_epilogue_legendary, FALSE );
		dprint( "Cinematic exited!" );
		
	end
	kill_thread( epilogue_bink_b_thread);
	
	sleep (30);
	
	dprint ("thanks for playing halo 4: the halolololing");
	
	game_won();
	
		
end

script static void f_epilogue_part_a_bink()
	
	sleep_until(bink_is_playing() == TRUE, 1);
	sleep_s(50.35);
	cinematic_subtitle( C_epilogue_00100 , 5.6 ); //  "Radio: Infinity actual? Pelican Nine Sixer. We found him."
	sleep_s(49.6);
	cinematic_subtitle( C_epilogue_00200 , 1.2 ); //  "Lasky: Mind if I join you?"
	sleep_s(3.7);
	cinematic_subtitle( C_epilogue_00300 , 1.2 ); //  "Master Chief: Of course not, Sir."
	sleep_s(2.5);
	cinematic_subtitle( C_epilogue_00400 , 3.8 ); //  "Lasky: At ease, Chief. It feels kind of odd for you to call me 'Sir.'"
	sleep_s(11.2);
	cinematic_subtitle( C_epilogue_00500 , 4.6 ); //  "Lasky: Beautiful, isn't she? I don't get to see her often enough."
	sleep_s(7.7);
	cinematic_subtitle( C_epilogue_00600 , 10.1 ); //  "Lasky: I grew up on New Harmony. Attended Corbulo Military Academy. Never saw Earth in person until I was an adult, but... I still think of her as home."
	sleep_s(18.2);
	cinematic_subtitle( C_epilogue_00700 , 1.7 ); //  "Lasky: You don't talk much, do you?"
	sleep_s(9.7);
	cinematic_subtitle( C_epilogue_00800 , 2.4 ); //  "Lasky: Chief... I won't pretend to know how you feel."
	sleep_s(3);
	cinematic_subtitle( C_epilogue_00900 , 6 ); //  "Lasky: I've lost people I care about, but... never anything like you're going through."
	sleep_s(7);
	cinematic_subtitle( C_epilogue_01000 , 5.6 ); //  "Master Chief: Our duty as soldiers is to protect humanity. Whatever the cost."
	sleep_s(9.2);
	cinematic_subtitle( C_epilogue_01100 , 9.1 ); //  "Lasky: You say that like soldiers and humanity are two different things. Soldiers aren't machines. We're just people."
	sleep_s(16.4);
	cinematic_subtitle( C_epilogue_01200 , .5 ); //  "Lasky: I'll let you have the deck to yourself."
	sleep_s(12.9);
	cinematic_subtitle( C_epilogue_01300 , 7.1 ); //  "Master Chief: She said that to me once. About being a machine."
end

script static void f_epilogue_part_b_bink()
	
	sleep_until(bink_is_playing() == TRUE, 1);
	sleep_s(8.5);
	cinematic_subtitle( C_epilogue_01400, 7.3 ); // "Didact: In this hour of victory, we taste only defeat. I ask why."
	sleep_s(8.9);
	cinematic_subtitle( C_epilogue_01500, 4.1 ); // "Didact: We are Forerunners. Guardians of all that exists."
	sleep_s(4.6);
	cinematic_subtitle( C_epilogue_01600, 10.8 ); // "Didact: The roots of the galaxy have grown deep under our careful tending. Where there is life, the wisdom of our countless generations has saturated the soil."
	sleep_s(11.8);
	cinematic_subtitle( C_epilogue_01700, 4.9 ); // "Didact: Our strength is a luminous sun towards which all intelligence blossoms..."
	sleep_s(5.8);
	cinematic_subtitle( C_epilogue_01800, 4.4 ); // "Didact: And the impervious shelter beneath which it has prospered."
	sleep_s(10);
	cinematic_subtitle( C_epilogue_01900, 1.4 ); // "Didact: I stand before you."
	sleep_s(2.8);
	cinematic_subtitle( C_epilogue_02000, 4.4 ); // "Didact: Accused of the sin of ensuring Forerunner ascendancy..."
	sleep_s(6);
	cinematic_subtitle( C_epilogue_02100, 8.8 ); // "Didact: Of attempting to save us from this fate where we are forced to... recede..."
	sleep_s(11.6);
	cinematic_subtitle( C_epilogue_02200, 3.6 ); // "Didact: Humanity stands as the greatest threat in the galaxy."
	sleep_s(3.3);
	cinematic_subtitle( C_epilogue_02300, 3.6 ); // "Didact: Refusing to eradicate them is a fool's gambit."
	sleep_s(4.1);
	cinematic_subtitle( C_epilogue_02400, 1.8 ); // "Didact: We squander eons in the darkness..."
	sleep_s(2.1);
	cinematic_subtitle( C_epilogue_02500, 2.4 ); // "Didact: ...while they seize our triumphs for their own."
	sleep_s(4.3);
	cinematic_subtitle( C_epilogue_02600, 8.9 ); // "Didact: The Mantle of Responsibility for all things belongs to Forerunners alone!"
	sleep_s(10.8);
	cinematic_subtitle( C_epilogue_02700, 3.6 ); // "Didact: Think of my acts as you will."
	sleep_s(5.4);
	cinematic_subtitle( C_epilogue_02800, 1.9 ); // "Didact: But do not doubt the reality."
	sleep_s(4.2);
	cinematic_subtitle( C_epilogue_02900, 3.7 ); // "Didact: The reclamation... has already begun."
	sleep_s(6);
	cinematic_subtitle( C_epilogue_03000, 2.2 ); // "Didact: And we are hopeless to stop it."
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
