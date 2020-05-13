//=============================================================================================================================
//============================================ E6M2 MEZZANINE NARRATIVE SCRIPT ================================================
//=============================================================================================================================

// ============================================	GLOBALS	========================================================
global boolean e6m2_narrative_is_on = FALSE;


// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================

script static void e6m2_vo_destroycomms()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_01);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end

script static void e6m2_vo_returnpatrols()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_01_75);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end

script static void e6m2_vo_killallcovies01()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_02);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end



script static void e6m2_vo_unscgear()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_02_5);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_opendoor01()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_03);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_killallcovies02()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_04);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_patrolgroup01()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_05);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_listeningdevice01()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_06);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_opendoor02()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_07);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_listeningdevice02()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_08);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_patrolgroup02()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_09);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_listeningdevice03()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_10);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_alarmsetoff()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_15);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_killallcovies03()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_11);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_patrolgroup03()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_12);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_patrolgroup03b()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_12b);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_useshadeturrets()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	
	cinematic_set_title (e6m2_chaptitle_12_5);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_useunscgear()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;
	
	cinematic_set_title (e6m2_chaptitle_12_75);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_killallcovies04()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_13);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end


script static void e6m2_vo_goodworkgohome()
	sleep_until (e6m2_narrative_is_on == FALSE, 1);
	e6m2_narrative_is_on = TRUE;

	cinematic_set_title (e6m2_chaptitle_14);
	sleep (30 * 4);
	
	e6m2_narrative_is_on = FALSE;
end

// ============================================	MISC SCRIPT	========================================================