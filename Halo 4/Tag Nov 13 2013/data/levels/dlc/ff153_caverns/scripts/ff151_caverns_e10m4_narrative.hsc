//=============================================================================================================================
//============================================ E10M4 CAVERNS NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================
global boolean e10m4_narrative_is_on = FALSE;


// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================

script static void e10m4_vo_aa_guns()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;

	cinematic_set_title (e10m4_chaptitle_01);
	sleep (30 * 4);
	
	cinematic_set_title (e10m4_chaptitle_02);
	sleep (30 * 4);
	
	e10m4_narrative_is_on = FALSE;
end


script static void e10m4_vo_gotomech()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;

	cinematic_set_title (e10m4_chaptitle_03);
	sleep (30 * 4);
	
	e10m4_narrative_is_on = FALSE;
end


script static void e10m4_vo_keepkilling()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;

	cinematic_set_title (e10m4_chaptitle_04);
	sleep (30 * 4);
	
	e10m4_narrative_is_on = FALSE;
end


script static void e10m4_vo_turnoffaaguns()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;

	cinematic_set_title (e10m4_chaptitle_05);
	sleep (30 * 4);
	
	e10m4_narrative_is_on = FALSE;
end


script static void e10m4_vo_killmore()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;

	cinematic_set_title (e10m4_chaptitle_06);
	sleep (30 * 4);
	
	e10m4_narrative_is_on = FALSE;
end


script static void e10m4_vo_doorswitch()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;

	cinematic_set_title (e10m4_chaptitle_07);
	sleep (30 * 4);
	
	e10m4_narrative_is_on = FALSE;
end


script static void e10m4_vo_beachfight()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;

	cinematic_set_title (e10m4_chaptitle_08);
	sleep (30 * 4);
	
	e10m4_narrative_is_on = FALSE;
end


script static void e10m4_vo_pelicanarrived()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;

	cinematic_set_title (e10m4_chaptitle_09);
	sleep (30 * 4);
	
	e10m4_narrative_is_on = FALSE;
end


script static void e10m4_vo_gettopelican()
	sleep_until (e10m4_narrative_is_on == FALSE, 1);
	e10m4_narrative_is_on = TRUE;

	cinematic_set_title (e10m4_chaptitle_10);
	sleep (30 * 4);
	
	e10m4_narrative_is_on = FALSE;
end


// ============================================	MISC SCRIPT	========================================================