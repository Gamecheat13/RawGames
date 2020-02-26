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
	local long prologue_bink_thread = thread( f_prologue_bink() );
	f_start_mission( cin_m005_prologue );
	kill_thread( prologue_bink_thread );
	cinematic_exit_no_fade( cin_m005_prologue, FALSE );
	dprint( "Cinematic exited!" );
        fade_out( 0, 0, 0, 0 );
        sleep( 1 );
        game_won( );
        sleep( 0 );

end

script static void f_prologue_bink()
	sleep_until(bink_is_playing() == TRUE, 1);
	sleep_s(17.5);
	cinematic_subtitle(C_prologue_00100, 1.3); // "Oni Agent: Tell me about the children."
	//17.5 seconds – 18.8 seconds
	sleep_s(7.5);
	cinematic_subtitle(C_prologue_00200, 1.0); // "Oni Agent: Doctor Halsey?"
	//25 seconds - 26 seconds
	sleep_s(4.5);
	cinematic_subtitle(C_prologue_00300, 2.4); // "Dr. Catherine Halsey: You already know everything."
	//29.5 seconds - 31.9 seconds
	sleep_s(5.0);
	cinematic_subtitle(C_prologue_00400, 1.0); // "Oni Agent: You kidnapped them."
	//34.5 seconds - 35.5 seconds
	sleep_s(2.7);
	cinematic_subtitle(C_prologue_00500, 8.7); // "Dr. Halsey: Children's minds are more easily accepting of indoctrination. Their bodies more adaptable to augmentation."
	//37.2 seconds - 45.9
	sleep_s(8.8);
	cinematic_subtitle(C_prologue_00600, 3.1); // "Dr. Halsey: The result was the ultimate soldier."
	//46 seconds - 49.1 seconds
	sleep_s(5.0);
	cinematic_subtitle(C_prologue_00700, 5.0); // "Dr. Halsey: And because of our success, when the Covenant invaded, we were ready."
	//51 seconds - 56 seconds
	sleep_s(8.8);
	cinematic_subtitle(C_prologue_00800, 3.0); // "Oni Agent: Doctor Halsey, you're bending history to your own favor and you know it."
	//59.8 seconds - 62.8
	sleep_s(4.3);
	cinematic_subtitle(C_prologue_00801, 3.9); // "Oni Agent: You developed the Spartans to crush human rebellion, not to fight the Covenant."
	//64.1 seconds - 68 seconds
	sleep_s(6.9);
	cinematic_subtitle(C_prologue_00900, 2.0); // "Dr. Halsey: When one human world after another fell..."
	//71 seconds - 73 seconds
	sleep_s(2.5);
	cinematic_subtitle(C_prologue_01000, 5.0); // "Dr. Halsey: When my Spartans were all that stood between humanity and extinction..."
	//73.5 seconds - 78.5 seconds
	sleep_s(5.4);
	cinematic_subtitle(C_prologue_01100, 3.9); // "Dr. Halsey: Nobody was concerned about why they were originally built."
	//78.9 seconds - 82.8 seconds
	sleep_s(5.3);
	cinematic_subtitle(C_prologue_01200, 2.8); // "Oni Agent: So you feel that, in the end, your choices were justified."
	//84.2 seconds - 87 seconds
	sleep_s(6.4);
	cinematic_subtitle(C_prologue_01300, 3.4); // "Dr. Halsey: My work saved the human race."
	//90.6 seconds - 94 seconds
	sleep_s(7.4);
	cinematic_subtitle(C_prologue_01400, 3.6); // "Oni Agent: Do you think the Spartans' lack of basic humanity helped?"
	//98 seconds - 101.6 seconds
	sleep_s(6.7);
	cinematic_subtitle(C_prologue_01500, 8.4); // "Dr. Halsey: What are you after? The others before you were Naval Intelligence, but you... You're something else."
	//104.7 seconds - 113.1 seconds
	sleep_s(9.4);
	cinematic_subtitle(C_prologue_01600, 5.0); // "Oni Agent: Records show Spartans routinely exhibited mildly sociopathic tendencies: difficulty with socialization and verbalization..."
	//114.1 seconds - 119.1 seconds
	sleep_s(5.0);
	cinematic_subtitle(C_prologue_01700, 5.8); // "Dr. Halsey: The records show efficient behavior operating in hazardous situations."
	//119.1 seconds - 124.9
	sleep_s(7.0);
	cinematic_subtitle(C_prologue_01800, 4.3); // "Dr. Halsey: I supplied the tools to maintain that efficiency."
	//126.1 seconds - 130.4 seconds
	sleep_s(5.4);
	cinematic_subtitle(C_prologue_01900, 4.9); // "Oni Agent: But do you believe the Master Chief succeeded because he was, at his core, broken?"
	//131.5 seconds - 136.4 seconds
	sleep_s(6.1);
	cinematic_subtitle(C_prologue_02000, 1.7); // "Dr. Halsey: What does John have to do with this?"
	//137.6 seconds - 139.3 seconds
	sleep_s(5.2);
	cinematic_subtitle(C_prologue_02100, 1.2); // "Dr. Halsey: You want to replace him."
	//142.8 seconds - 144 seconds
	sleep_s(4.2);
	cinematic_subtitle(C_prologue_02200, 1.4); // "Oni Agent: The Master Chief is dead."
	//147 seconds - 148.4 seconds
	sleep_s(2.5);
	cinematic_subtitle(C_prologue_02300, 3.3); // "Dr. Halsey: His file reads Missing In Action."
	//149.5 seconds - 152.8 seconds
	sleep_s(4.3);
	cinematic_subtitle(C_prologue_02400, 3.4); // "Oni Agent: Catherine? Spartans never die?"
	//153.8 seconds - 157.2 seconds
	sleep_s(5.2);
	cinematic_subtitle(C_prologue_02500, 4.5); // "Dr. Halsey: Your mistake is seeing Spartans as military hardware."
	//159 seconds - 163.5 seconds
	sleep_s(5.7);
	cinematic_subtitle(C_prologue_02600, 6.4); // "Dr. Halsey: My Spartans are humanity's next step. Our destiny as a species."
	//164.7 seconds - 171.1 seconds
	sleep_s(7.8);
	cinematic_subtitle(C_prologue_02700, 3.7); // "Dr. Halsey: Do not underestimate them. But most of all..."
	//172.5 seconds - 176.2 seconds
	sleep_s(4.6);
	cinematic_subtitle(C_prologue_02800, 4.0); // "Dr. Halsey: Do not underestimate him."
	//177.1 seconds - 181.1 seconds
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