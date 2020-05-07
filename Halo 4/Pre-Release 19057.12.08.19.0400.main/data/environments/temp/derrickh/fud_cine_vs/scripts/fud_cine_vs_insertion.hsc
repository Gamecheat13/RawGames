//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_insertion
//	Insertion Points:	start (or icr)	- Beginning
//										ila							- Lab / Armory
//										iob							- Observation Deck
//										ifl							- Flank / Prep Room
//										ibe							- Beacon
//										ibr							- Broken Floor
//										ivb							- Vehicle Bay
//										iju							- Jump Debris
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343


// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

// Debug Options
global boolean b_debug 							= TRUE;
global boolean b_breakpoints				= FALSE;
global boolean b_md_print						= TRUE;
global boolean b_debug_objectives		= FALSE;
global boolean b_editor 						= editor_mode();
global boolean b_game_emulate				= TRUE;
global boolean b_cinematics 				= TRUE;
global boolean b_editor_cinematics 	= TRUE;
global boolean b_encounters					= TRUE;
global boolean b_dialogue 					= TRUE;
global boolean b_skip_intro					= FALSE;
global boolean s_insertion_index		= 0;

// Mission Started
global boolean b_mission_started 		= FALSE;

// Insertion
// These indices reflect the ORDER of the Zones in Sapien. So, 0 is the first, 1 is the second, and so on.
global short s_cinvs_ins_idx 				= 0;		// intro

// Zone Sets

// =================================================================================================
// =================================================================================================
// *** INSERTIONS ***
// =================================================================================================
// =================================================================================================

// =================================================================================================
// CINEMATICS VERTICAL SLICE
// =================================================================================================
script static void icm()
	ins_cin_vs();
end

script static void ins_cin_vs()
	if b_debug then
		print ("*** INSERTION POINT: CIN VS ***");
	end

	s_insertion_index = s_cinvs_ins_idx;

	// Play the intro cinematics here when we get one
	if (b_cinematics and ((not b_editor) or (b_editor_cinematics))) then
			if (b_debug) then 
				print ("starting with intro cinematic...");
			end
			f_start_mission (cin_vs);
	end
	
	sleep (1);

	b_mission_started = TRUE;
end
