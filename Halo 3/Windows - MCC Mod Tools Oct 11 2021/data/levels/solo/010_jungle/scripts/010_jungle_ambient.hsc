; =======================================================================================================================================================================
; =======================================================================================================================================================================
; END MISSION CONDITIONS  
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global boolean g_dam_player_in_pelican FALSE)

(script dormant 010_jungle_mission_won
	; sleep until any player is in the pelican 
	(sleep_until	(or
					(vehicle_test_seat dam_pelican "" (unit (player0)))
					(vehicle_test_seat dam_pelican "" (unit (player1)))
					(vehicle_test_seat dam_pelican "" (unit (player2)))
					(vehicle_test_seat dam_pelican "" (unit (player3)))
				)
	5)

	; sound glue 
	(sound_looping_start sound\cinematics\070_waste\070ld_pelican_pickup\070ld_pelican_glue\070ld_pelican_glue dam_pelican_location 1)
	(sound_class_set_gain veh 0 60)
		
	(sleep 45)
					
		; set current mission segment 
		(data_mine_set_mission_segment "010lb_extraction")

		; turn off all navigation points 
		(gs_nav_off)
		
		; turn off mission dialogue reminder 
		(set g_dam_player_in_pelican TRUE)
		
		; set current objective 
		(wake obj_extraction_clear)

		; fade to black 
		(cinematic_fade_to_black)
		
		; turn off all music 
		(gs_music_off)
		
		; award mission achievement 
		(game_award_level_complete_achievements)
		
	; teleport all players 
	(object_teleport (player0) player0_end_teleport)
	(object_teleport (player1) player1_end_teleport)
	(object_teleport (player2) player2_end_teleport)
	(object_teleport (player3) player3_end_teleport)
		(sleep 1)
	
	; erase all ai 
	(ai_erase gr_all)
	
	; switch zone sets 
	(switch_zone_set set_cin_outro_01)
	
		; play cinematic 
		(if (= g_play_cinematics TRUE)
			(begin
				(if (cinematic_skip_start)
					(begin
						(if debug (print "010lb_extraction_01"))
						(010lb_extraction_01)
						
						; cinematic snap to black 
						(cinematic_snap_to_black)
						
						; cleanup cinematic scripts 
						(010lb_extraction_01_cleanup)
						
						; switch zone sets (only drops out bsp's) 
						(switch_zone_set set_cin_outro_02)
							
							; start second half of cinematic 
							(if (cinematic_skip_start)
								(begin
									(if debug (print "010lb_extraction_02"))
									(010lb_extraction_02)
								)
							)
					)
				)
				(cinematic_skip_stop)
				
				; cleanup cinematic scripts 
				(010lb_extraction_01_cleanup)
				(010lb_extraction_02_cleanup)
				
				; turn off all game sounds 
				(sound_class_set_gain "" 0 0)
			)
		)
		
	(sleep 5)
	(end_mission)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; primary objectives  
; =======================================================================================================================================================================
; =======================================================================================================================================================================

(script dormant obj_substation_set
	(sleep_until (>= g_cc_obj_control 2) 5 300)

	(if debug (print "new objective set:"))
	(if debug (print "Make your way back to the Sub-station for extraction."))
	(objectives_show_up_to 0)
	(cinematic_set_chud_objective obj_0)
)
(script dormant obj_substation_clear
		(sleep 30)
	(if debug (print "objective complete:"))
	(if debug (print "Make your way back to the Sub-station for extraction."))
	(objectives_finish_up_to 0)
)

; =======================================================================================================================================================================

(script dormant obj_locate_pelican_set
		(sleep 120)
	(if debug (print "new objective set:"))
	(if debug (print "Search the jungle for Johnson's crashed Pelican."))
	(objectives_show_up_to 1)
	(cinematic_set_chud_objective obj_1)
)
(script dormant obj_locate_pelican_clear
	(sleep_until g_ba_johnson_objective 1)
		(sleep 30)
	(if debug (print "objective complete:"))
	(if debug (print "Search the jungle for Johnson's crashed Pelican."))
	(objectives_finish_up_to 1)
)

; =======================================================================================================================================================================

(script dormant obj_get_to_johnson_set
	(sleep_until g_ba_johnson_objective 1)
		(sleep 30)
	(if debug (print "new objective set:"))
	(if debug (print "Get to Johnson before he's captured."))
	(objectives_show_up_to 2)
	(cinematic_set_chud_objective obj_2)
)
(script dormant obj_get_to_johnson_clear
		(sleep 210)
	(if debug (print "objective complete:"))
	(if debug (print "Get to Johnson before he's captured."))
	(objectives_finish_up_to 2)
)

; =======================================================================================================================================================================

(script dormant obj_rescue_johnson_set
		(sleep 210)
	(if debug (print "new objective set:"))
	(if debug (print "Free Johnson from his Prison."))
	(objectives_show_up_to 3)
	(cinematic_set_chud_objective obj_3)
)
(script dormant obj_rescue_johnson_clear
		(sleep 30)
	(if debug (print "objective complete:"))
	(if debug (print "Free Johnson from his Prison."))
	(objectives_finish_up_to 3)
)

; =======================================================================================================================================================================

(script dormant obj_extraction_set
		(sleep 60)
	(if debug (print "new objective set:"))
	(if debug (print "Stay Alive! A Pelican is on the way."))
	(objectives_show_up_to 4)
	(cinematic_set_chud_objective obj_4)
)
(script dormant obj_extraction_clear
		(sleep 30)
	(if debug (print "objective complete:"))
	(if debug (print "Stay Alive! A Pelican is on the way."))
	(objectives_finish_up_to 4)
)
; =======================================================================================================================================================================
; =======================================================================================================================================================================
; secondary objectives  
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global boolean g_marines_dead FALSE)

(script dormant obj_2nd_save_marines
	(sleep 30)
	(if debug (print "new secondary objective set:"))
	(if debug (print "keep all your marines alive."))
	(objectives_secondary_show 0)
	
	(sleep_until g_null)
)

; =======================================================================================================================================================================

(script dormant obj_2nd_unavailable_set
	(sleep 30)
	(if debug (print "new secondary objective set:"))
	(if debug (print "unavailable"))
	(objectives_secondary_show 1)
)
(script dormant obj_2nd_unavailable_unavailable
	(sleep 30)
	(if debug (print "secondary objective unavailable:"))
	(if debug (print "unavailable"))
	(objectives_secondary_unavailable 1)
)
; =======================================================================================================================================================================
; =======================================================================================================================================================================
; chapter titles  
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global boolean chapter_finished FALSE)

; walk it off ============================
(script dormant chapter_walk
		(sleep 30)
	(cinematic_set_title title_1)
	(cinematic_title_to_gameplay)
)

; charlie foxtrot ========================

(script dormant chapter_charlie
	(chapter_start)
	(cinematic_set_title title_2)
		(sleep 150)
	(chapter_stop)
)

(script dormant chapter_charlie_insert
		(sleep 30)
	(cinematic_set_title title_2)
	(cinematic_title_to_gameplay)
)

; quid pro quo ===========================
(script dormant chapter_favor
		(sleep 30)
	(cinematic_set_title title_3)
		(sleep 150)
	(if (= perspective_running FALSE) (chapter_stop))
	(set chapter_finished TRUE)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; nav points   
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global short g_nav_sleep (* 30 60 2))
(global short g_nav_sleep_dam (* 30 60 0.5))
(global real g_nav_offset 0.55)

(global boolean g_nav_cc FALSE)
(global boolean g_nav_jw FALSE)
(global boolean g_nav_gc FALSE)
(global boolean g_nav_pa FALSE)
(global boolean g_nav_ss FALSE)
(global boolean g_nav_pb FALSE)
(global boolean g_nav_ba FALSE)
(global boolean g_nav_dam FALSE)


; chief crater nav point ================================================================
(script dormant nav_cc
	(sleep_until g_nav_cc)
	(sleep g_nav_sleep)
	(if (<= g_cc_obj_control 2)
		(begin
			(hud_activate_team_nav_point_flag player nav_cc g_nav_offset)
			(sleep_until (>= g_cc_obj_control 3) 1)
			(hud_deactivate_team_nav_point_flag player nav_cc)
		)
	)
)

; jungle walk nav point =================================================================
(script dormant nav_jw
	(sleep_until	(or
					(and
						g_nav_jw
						(<= (ai_living_count obj_jw_upper_covenant) 0)
						(<= (ai_living_count obj_jw_lower_covenant) 0)
					)
					(>= g_ta_obj_control 1)
				)
	)
	(if (<= g_ta_obj_control 0) (sleep g_nav_sleep))
	(if (<= g_ta_obj_control 0)
		(begin
			(hud_activate_team_nav_point_flag player nav_jw g_nav_offset)
			(sleep_until (>= g_ta_obj_control 1) 1)
			(hud_deactivate_team_nav_point_flag player nav_jw)
		)
	)
)

; grunt camp nav point ==================================================================
(script dormant nav_gc
	(sleep_until	(or
					(and
						g_nav_gc
						(<= (ai_living_count obj_gc_covenant) 0)
					)
					(>= g_pa_obj_control 1)
				)
	)
	(if (<= g_pa_obj_control 0) (sleep g_nav_sleep))
	(if (<= g_pa_obj_control 0)
		(begin
			(hud_activate_team_nav_point_flag player nav_gc g_nav_offset)
			(sleep_until (>= g_pa_obj_control 1) 1)
			(hud_deactivate_team_nav_point_flag player nav_gc)
		)
	)
)

; path a nav point ======================================================================
(script dormant nav_pa
	(sleep_until	(or
					(and
						g_nav_pa
						(<= (ai_living_count obj_pa_covenant) 0)
					)
					(>= g_pa_obj_control 5)
				)
	)
	(if (<= g_pa_obj_control 4) (sleep g_nav_sleep))
	(if (<= g_pa_obj_control 4)
		(begin
			(hud_activate_team_nav_point_flag player nav_pa g_nav_offset)
			(sleep_until (>= g_pa_obj_control 5) 1)
			(hud_deactivate_team_nav_point_flag player nav_pa)
		)
	)
)

; substation nav point =================================================================
(script dormant nav_ss
	(sleep_until	(or
					(and
						g_nav_ss
						(<= (ai_living_count obj_ss_covenant) 0)
					)
					(>= g_pb_obj_control 1)
				)
	)
	(if (<= g_pb_obj_control 0) (sleep g_nav_sleep))
	(if (<= g_pb_obj_control 0)
		(begin
			(hud_activate_team_nav_point_flag player nav_ss g_nav_offset)
			(sleep_until (>= g_pb_obj_control 1) 1)
			(hud_deactivate_team_nav_point_flag player nav_ss)
		)
	)
)
			
; path b nav point ====================================================================
(script dormant nav_pb
	(sleep_until	(or
					(and
						g_nav_pb
						(<= (ai_living_count obj_pb_covenant) 0)
					)
					(>= g_ba_obj_control 1)
				)
	)
	(if (<= g_ba_obj_control 0) (sleep g_nav_sleep))
	(if (<= g_ba_obj_control 0)
		(begin
			(hud_activate_team_nav_point_flag player nav_pb g_nav_offset)
			(sleep_until (>= g_ba_obj_control 1) 1)
			(hud_deactivate_team_nav_point_flag player nav_pb)
		)
	)
)

; brute ambush nav point =============================================================
(script dormant nav_ba
	(sleep_until	(or
					(and
						g_nav_ba
						(<= (ai_living_count obj_ba_covenant) 0)
					)
					(>= g_dam_obj_control 1)
				)
	)
	(if (<= g_dam_obj_control 0) (sleep g_nav_sleep))
	(if (<= g_dam_obj_control 0)
		(begin
			(hud_activate_team_nav_point_flag player nav_ba g_nav_offset)
			(sleep_until (>= g_tb_obj_control 1) 1)
			(hud_deactivate_team_nav_point_flag player nav_ba)
		)
	)
)

; dam nav point =====================================================================
(script dormant nav_dam
	(sleep_until	(or
					(and
						g_nav_dam
						(<= (ai_living_count obj_dam_00_04_covenant) 0)
						(<= (ai_living_count obj_dam_05_06_covenant) 0)
						(<= (ai_living_count obj_dam_07_covenant) 0)
					)
					g_dam_prisoners_free
				)
	)
	(if (not g_dam_prisoners_free) (sleep g_nav_sleep_dam))
	(if (not g_dam_prisoners_free)
		(begin
			(hud_activate_team_nav_point_flag player nav_dam g_nav_offset)
			(sleep_until g_dam_prisoners_free 1)
			(hud_deactivate_team_nav_point_flag player nav_dam)
		)
	)
)

(script dormant nav_dam_pelican
	(sleep_until (>= g_dam_extraction_location 1))
	(sleep g_nav_sleep_dam)
	(hud_activate_team_nav_point_flag player nav_dam_extract g_nav_offset)
)


(script static void gs_nav_off
	(hud_deactivate_team_nav_point_flag player nav_cc)
	(hud_deactivate_team_nav_point_flag player nav_jw)
	(hud_deactivate_team_nav_point_flag player nav_gc)
	(hud_deactivate_team_nav_point_flag player nav_pa)
	(hud_deactivate_team_nav_point_flag player nav_ss)
	(hud_deactivate_team_nav_point_flag player nav_pb)
	(hud_deactivate_team_nav_point_flag player nav_ba)
	(hud_deactivate_team_nav_point_flag player nav_dam)
	(hud_deactivate_team_nav_point_flag player nav_dam_extract)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; music 
; =======================================================================================================================================================================
; =======================================================================================================================================================================

;*
++++++++++++++++++++
music index 
++++++++++++++++++++

enc_chief_crater 
----------------
music_010_01 
music_010_02 

enc_jungle_walk 
----------------
music_010_03 
music_010_04 

enc_grunt_camp 
----------------
music_010_05 

enc_path_a 
----------------
music_010_06 
music_010_075 

enc_substation 
----------------
music_010_065 

enc_path_b 
----------------
music_010_07 

enc_brute_ambush 
----------------
music_010_076 

enc_dam 
----------------
music_010_08 

++++++++++++++++++++
*;

(global boolean g_music_010_01 FALSE)
(global boolean g_music_010_02 FALSE)
(global boolean g_music_010_03 FALSE)
(global boolean g_music_010_04 FALSE)
(global boolean g_music_010_05 FALSE)
(global boolean g_music_010_06 FALSE)
(global boolean g_music_010_06_alt FALSE)
(global boolean g_music_010_065 FALSE)
(global boolean g_music_010_07 FALSE)
(global boolean g_music_010_075 FALSE)
(global boolean g_music_010_076 FALSE)
(global boolean g_music_010_08 FALSE)

; =======================================================================================================================================================================
(script dormant music_010_01
	(sleep_until g_music_010_01 1)
	(if music (print "start music 010_01"))
	(sound_looping_start levels\solo\010_jungle\music\010_music_01 NONE 1)

	(sleep_until (not g_music_010_01) 1)
	(if music (print "stop music 010_01"))
	(sound_looping_stop levels\solo\010_jungle\music\010_music_01)
)
; =======================================================================================================================================================================
(script dormant music_010_02
	(sleep_until g_music_010_02 1)
	(if music (print "start music 010_02"))
	(sound_looping_start levels\solo\010_jungle\music\010_music_02 NONE 1)

	(sleep_until (not g_music_010_02) 1)
	(if music (print "stop music 010_02"))
	(sound_looping_stop levels\solo\010_jungle\music\010_music_02)
)
; =======================================================================================================================================================================
(script dormant music_010_03
	(sleep_until g_music_010_03 1)
	(if music (print "start music 010_03"))
	(sound_looping_start levels\solo\010_jungle\music\010_music_03 NONE 1)

	(sleep_until (not g_music_010_03) 1)
	(if music (print "stop music 010_03"))
	(sound_looping_stop levels\solo\010_jungle\music\010_music_03)
)
; =======================================================================================================================================================================
(script dormant music_010_04
	(sleep_until g_music_010_04 1)
	(if music (print "start music 010_04"))
	(sound_looping_start levels\solo\010_jungle\music\010_music_04 NONE 1)

	(sleep_until (not g_music_010_04) 1)
	(if music (print "stop music 010_04"))
	(sound_looping_stop levels\solo\010_jungle\music\010_music_04)
)
; =======================================================================================================================================================================
(script dormant music_010_05
	(sleep_until g_music_010_05 1)
	(if music (print "start music 010_05"))
	(sound_looping_start levels\solo\010_jungle\music\010_music_05 NONE 1)

	(sleep_until (not g_music_010_05) 1)
	(if music (print "stop music 010_05"))
	(sound_looping_stop levels\solo\010_jungle\music\010_music_05)
)
; =======================================================================================================================================================================
(script dormant music_010_06
	(sleep_until g_music_010_06 1)
	(if music (print "start music 010_06"))
	(sound_looping_start levels\solo\010_jungle\music\010_music_06 NONE 1)
		
		(sleep_until g_music_010_06_alt 1)
		(if music (print "alternate music 010_06"))
		(sound_looping_set_alternate levels\solo\010_jungle\music\010_music_06 TRUE)

	(sleep_until (not g_music_010_06) 1)
	(if music (print "stop music 010_06"))
	(sound_looping_stop levels\solo\010_jungle\music\010_music_06)
)
; =======================================================================================================================================================================
(script dormant music_010_065
	(sleep_until g_music_010_065 1)
	(if music (print "start music 010_065"))
	(sound_looping_start levels\solo\010_jungle\music\010_music_065 NONE 1)

	(sleep_until (not g_music_010_065) 1)
	(if music (print "stop music 010_065"))
	(sound_looping_stop levels\solo\010_jungle\music\010_music_065)
)
; =======================================================================================================================================================================
(script dormant music_010_07
	(sleep_until g_music_010_07 1)
	(if music (print "start music 010_07"))
	(sound_looping_start levels\solo\010_jungle\music\010_music_07 NONE 1)

	(sleep_until (not g_music_010_07) 1)
	(if music (print "stop music 010_07"))
	(sound_looping_stop levels\solo\010_jungle\music\010_music_07)
)
; =======================================================================================================================================================================
(script dormant music_010_075
	(sleep_until g_music_010_075 1)
	(if music (print "start music 010_075"))
	(sound_looping_start levels\solo\010_jungle\music\010_music_075 NONE 1)

	(sleep_until (not g_music_010_075) 1)
	(if debug (print "stop music 010_075"))
	(sound_looping_stop levels\solo\010_jungle\music\010_music_075)
)
; =======================================================================================================================================================================
(script dormant music_010_076
	(sleep_until g_music_010_076 1)
	(if music (print "start music 010_076"))
	(sound_looping_start levels\solo\010_jungle\music\010_music_076 NONE 1)

	(sleep_until (not g_music_010_076) 1)
	(if music (print "stop music 010_076"))
	(sound_looping_stop levels\solo\010_jungle\music\010_music_076)
)
; =======================================================================================================================================================================
(script dormant music_010_08
	(sleep_until g_music_010_08 1)
	(if music (print "start music 010_08"))
	(sound_looping_start levels\solo\010_jungle\music\010_music_08 NONE 1)
;*
	(sleep_until (not g_music_010_08) 1)
	(if music (print "stop music 010_08"))
	(sound_looping_stop levels\solo\010_jungle\music\010_music_08)
*;
)
; =======================================================================================================================================================================
(script static void gs_music_off
	(sound_looping_stop levels\solo\010_jungle\music\010_music_01)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_02)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_03)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_04)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_05)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_06)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_07)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_075)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_076)
;	(sound_looping_stop levels\solo\010_jungle\music\010_music_08)
)

(script static void gs_all_music_off
	(sound_looping_stop levels\solo\010_jungle\music\010_music_01)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_02)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_03)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_04)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_05)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_06)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_07)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_075)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_076)
	(sound_looping_stop levels\solo\010_jungle\music\010_music_08)
)

; =======================================================================================================================================================================

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; mission_dialogue 
; =======================================================================================================================================================================
; =======================================================================================================================================================================

;*
+++++++++++++++++++++++
mission_dialogue index 
+++++++++++++++++++++++

enc_chief_crater 
----------------
010tr_look 
md_cc_joh_move_out  
md_cc_joh_reminder 
010tr_jump 
md_cc_joh_extract 
md_cc_brute_howl 
md_cc_bravo_advised 


enc_jungle_walk 
----------------
vs_jw_joh_phantom 
md_jw_joh_bravo 
md_jw_mar_brute 
md_jw_mar_power_armor 
md_jw_arb_prophets 
md_jw_river 
010pa_brute_chieftain 
md_jw_post_combat 


enc_grunt_camp 
----------------
md_gc_mar_sleepers 
md_gc_mar_jackals 
md_gc_joh_enroute 
md_gc_post_combat 

enc_path_a 
----------------
vs_pa_brute_01 
md_pa_sport 
md_pa_joh_company 
md_pa_post_combat 

enc_substation 
----------------
010tr_grenades 
vs_ss_banshee_ambush 
md_ss_turrets 
md_ss_joh_alright 
md_ss_post_combat 

enc_path_b 
----------------
md_pb_move_forward 

enc_brute_ambush 
----------------
md_ba_joh_dumb_apes 
vs_ba_bunkered_down 

enc_dam 
----------------
010pb_johnson_captured 
vs_dam_joh_ironic 
vs_dam_pelican_attack 
ms_dam_joh_pile_in 
vs_dam_joh_leave 

+++++++++++++++++++++++
*;

(global boolean g_playing_dialogue FALSE)

(global ai arbiter NONE)
(global ai tech NONE)
(global ai pilot_01 NONE)
(global ai pilot_02 NONE)
(global ai chieftain NONE)

(global ai johnson NONE)
(global ai joh_marine_01 NONE)
(global ai joh_marine_02 NONE)
(global ai joh_marine_03 NONE)

(global ai sarge NONE)
(global ai marine_01 NONE)
(global ai marine_02 NONE)
(global ai marine_03 NONE)
(global ai marine_04 NONE)

(global ai sarge_sv NONE)
(global ai marine_sv_01 NONE)
(global ai marine_sv_02 NONE)
(global ai marine_sv_03 NONE)

(global ai brute_01 NONE)
(global ai brute_02 NONE)

(global ai grunt_01 NONE)
(global ai grunt_02 NONE)
(global ai grunt_03 NONE)
(global ai grunt_04 NONE)

(global object cin_brute_guard NONE)
(global object dead_brute NONE)
; =======================================================================================================================================================================
(script static void md_cleanup
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; =======================================================================================================================================================================
(script dormant md_cc_fade_in
	; fade to chapter title 
		(sleep 15)
	(if debug (print "cinematic_fade_to_title"))
	(cinematic_fade_to_title)
)

; =======================================================================================================================================================================
; johnson orders the group to split up into two 
(script dormant md_cc_johnson_move_out
	(if debug (print "mission_dialogue : chief_crater : johnson : move_out"))
	
		; cast all the appropriate roles 
		(if debug (print "casting call..."))
	
		(if (not (game_is_cooperative))
				(begin
					(vs_cast gr_arbiter TRUE 0 "010ma_010")
						(set arbiter (vs_role 1))
				)
		)
		; cast johnson and his marines 
		(vs_cast gr_johnson_marines TRUE 0 "010ma_030")
			(set johnson (vs_role 1))
;		(vs_cast gr_johnson_marines TRUE 0 "" "" "")
;			(set joh_marine_01 (vs_role 1))
;			(set joh_marine_02 (vs_role 2))
;			(set joh_marine_03 (vs_role 3))
		
	; don't allow combat dialogue 
	(ai_dialogue_enable FALSE)
	
	; turn off foot registration 
	(biped_force_ground_fitting_on johnson TRUE)

	(vs_stow arbiter)
	(vs_stow johnson)
	(vs_look_player johnson TRUE)
		(sleep 5)
	
	(if debug (print "begin talking"))

		(if (not (game_is_cooperative))
				; game is not cooperative then play arbiter lines 
				(begin
;*
					(vs_go_to arbiter TRUE ps_cc/arb01)
					(vs_face arbiter TRUE ps_cc/arb_look)
					(sleep 30)

					(if dialogue (print "arbiter: the brutes love easy prey"))
					(vs_play_line arbiter TRUE 010ma_010)
					(sleep 15)

					(if dialogue (print "arbiter: we should not linger."))
					(vs_play_line arbiter TRUE 010ma_020)
					(sleep 30)
*;
					
					; move arbiter up (walking) 
					(vs_movement_mode arbiter 0)
					(vs_go_to arbiter FALSE ps_cc/arb02)
					(sleep 5)
				)
		)
	
			(sleep 45)
		(ai_activity_abort johnson)
		(vs_look_player johnson FALSE)
			(sleep 15)

		(vs_custom_animation johnson TRUE objects\characters\marine\marine "patrol:rifle:turn180_johnson" TRUE)
		(vs_stop_custom_animation johnson)

;		(vs_face johnson TRUE ps_cc/1st_squad)
;		(sleep 15)
		(if dialogue (print "johnson: first squad, you're my scouts!"))
		(sleep (ai_play_line johnson 010ma_030))
;			(sleep 5)
		(vs_action johnson FALSE ps_cc/1st_squad ai_action_advance)
			(sleep 10)
		
	; allow the marines with the arbiter to move out 
	(sleep (random_range 10 20))
	(if debug (print "abort marine activities"))
	(ai_activity_abort gr_marines)

	; set the current objective (in the hud) 
	(wake obj_substation_set)

	; wake chapter title 
	(wake chapter_walk)

	; slow down players movement through movement_training canyon 
	(if
		(or
			(= (game_is_cooperative) TRUE)
			(= (game_difficulty_get) legendary)
			(= (campaign_metagame_enabled) TRUE)
		)
		(player_control_scale_all_input 1 0)
		(player_control_scale_all_input 0.775 0)
	)

	; final lines of johnson dialogue 
	(if (>= (game_difficulty_get) heroic) (chud_show_grenades TRUE))
		(cond
			((= (game_coop_player_count) 2)	(begin
											(if dialogue (print "johnson: arbiter, watch the chief's back."))
											(vs_play_line johnson TRUE 010ma_050)
											(sleep 15)
										)
			)
			((>= (game_coop_player_count) 3)	(begin
											(if dialogue (print "johnson: as for you..."))
											(vs_play_line johnson TRUE 010ma_060)
											(sleep 15)
									
											(if dialogue (print "johnson: just try not to wreck my planet."))
											(vs_play_line johnson TRUE 010ma_070)
											(sleep 15)
										)
			)
			(TRUE (if debug (print "game is not cooperative")))
		)
			
	(if dialogue (print "johnson: move out. quiet as you can!"))
	(vs_play_line johnson FALSE 010ma_040)

	(sleep (random_range 10 20))

	(if debug (print "release johnson marines"))
	(ai_activity_abort sq_johnson_marines/mar_01)
	(ai_activity_abort sq_johnson_marines/mar_02)
	(ai_activity_abort sq_johnson_marines/mar_03)
		(sleep 15)
	
	; release johnson 
	(sleep_until (not (vs_running_atom johnson)))
	(if debug (print "release johnson"))
	(vs_release johnson)
	
	(vs_go_to arbiter FALSE ps_cc/arb03)
	
	(game_save)
		(sleep 15)
	
	; enable combat dialogue 
	(ai_dialogue_enable TRUE)
	
	; turn off foot registration 
	(biped_force_ground_fitting_on johnsoN FALSE)

	(sleep_until (>= g_cc_obj_control 2))
)

; =======================================================================================================================================================================
(script dormant md_cc_johnson_reminder
	(sleep (* 30 25))

	(if	(and
			(not g_playing_dialogue)
			(<= g_cc_obj_control 1)
		)
		(begin
			(if debug (print "mission_dialogue : chief_crater : johnson : reminder"))
		
				; cast the actors
				(vs_cast gr_johnson_marines TRUE 0 "010ma_080")
					(set johnson (vs_role 1))
					
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)

		
			(if debug (print "begin talking"))
			(vs_face_player johnson TRUE)
		
				(if dialogue (print "johnson: best get moving, chief."))
				(sleep (ai_play_line johnson 010ma_080))
				(sleep 15)
		
				(set g_cc_obj_control 1)
				(vs_face_player johnson FALSE)
				(vs_enable_moving johnson TRUE)
				
				(if dialogue (print "johnson: come on. i'll lead you out."))
				(sleep (ai_play_line johnson 010ma_090))
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
)

; =======================================================================================================================================================================
(script dormant md_cc_joh_extract
	(sleep_until	(or
					(and
						(not g_playing_dialogue)
						(>= g_cc_obj_control 3)
					)
					(>= g_jw_obj_control 1)
				)
	)
	(sleep_random)
	
	(if (<= g_cc_obj_control 5)
		(begin
			(if debug (print "mission_dialogue : chief_crater : johnson : extract"))
		
				; cast the actors 
				(vs_cast sq_johnson_marines/johnson TRUE 0 "010mb_010")
					(set johnson (vs_role 1))
					
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)
			
			; movement properties 
			(vs_enable_moving johnson TRUE)
		
			(sleep 1)
		
				(if dialogue (print "johnson (radio): bravo team, this is johnson. we got him."))
				(sleep (ai_play_line johnson 010mb_010))
				(sleep 15)
		
				(if dialogue (print "johnson (radio): fall back to the extraction point, over?"))
				(sleep (ai_play_line johnson 010mb_020))
				(sleep 15)
		
				(if dialogue (print "sergeant (radio): roger that, stacker out!"))
				(sleep (ai_play_line_on_object NONE 010mb_030))
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
)

; =======================================================================================================================================================================
(script dormant md_cc_brute_howl
	(sleep_until	(or
					(and
						(not g_playing_dialogue)
						(>= g_cc_obj_control 6)
					)
					(>= g_jw_obj_control 1)
				)
	)
	(sleep_random)
	
	(if (<= g_cc_obj_control 7)
		(begin
			(if debug (print "mission_dialogue : chief_crater : brute_howl"))
		
				; cast the actors 
				(vs_cast gr_johnson_marines TRUE 0 "010mb_060" "010mb_070")
					(set marine_01 (vs_role 1))
					(set marine_02 (vs_role 2))
					
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)
		
			; movement properties 
			(vs_enable_pathfinding_failsafe marine_01 TRUE)
			(vs_enable_looking marine_01  TRUE)
			(vs_enable_targeting marine_01 TRUE)
			(vs_enable_moving marine_01 TRUE)
			
			(vs_enable_pathfinding_failsafe marine_02 TRUE)
			(vs_enable_looking marine_02  TRUE)
			(vs_enable_targeting marine_02 TRUE)
			(vs_enable_moving marine_02 TRUE)
		
			(sleep 1)
		
				(if dialogue (print "brute: (distant howl -- a call)"))
				(sleep (ai_play_line_on_object brute_howl 010mb_040))
				(sleep 15)
		
				(if dialogue (print "brute: (distant howl -- a response)"))
				(sleep (ai_play_line_on_object brute_howl 010mb_050))
				(sleep 10)
		
					; start music 01 
					(set g_music_010_01 TRUE)
				
				(if dialogue (print "marine: that sounded close"))
				(sleep (ai_play_line marine_01 010mb_060))
				(sleep 15)
		
				(if dialogue (print "marine: too close"))
				(sleep (ai_play_line marine_02 010mb_070))
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
	
	
)

; =======================================================================================================================================================================
(script dormant md_cc_bravo_advised
	(sleep_until	(or
					(and 
						(not g_playing_dialogue)
						(>= g_cc_obj_control 9)
					)
					(>= g_jw_obj_control 1)
				)
	)
	(sleep_random)
	
	(if (<= g_cc_obj_control 10)
		(begin
			(if debug (print "mission_dialogue : chief_crater : bravo_advised"))
;*		
				; cast the actors
				(if (not (game_is_cooperative))
						(begin
							(vs_cast gr_arbiter TRUE 0 "010mb_110")
								(set arbiter (vs_role 1))
						)
				)
				(vs_cast gr_johnson_marines TRUE 0 "010mb_100")
					(set johnson (vs_role 1))
*;			
				(vs_cast gr_johnson_marines TRUE 0 "010mb_100")
					(set johnson (vs_role 1))

			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)
		
			; movement properties
			(vs_enable_pathfinding_failsafe arbiter TRUE)
			(vs_enable_looking arbiter  TRUE)
			(vs_enable_targeting arbiter TRUE)
			(vs_enable_moving arbiter TRUE)
			
			(vs_enable_pathfinding_failsafe johnson TRUE)
			(vs_enable_looking johnson  TRUE)
			(vs_enable_targeting johnson TRUE)
			(vs_enable_moving johnson TRUE)
		
			(sleep 1)
		
				(if dialogue (print "sergeant (radio, static): johnson? be advised. hostiles (are on the move)."))
				(sleep (ai_play_line_on_object NONE 010mb_080))
				(sleep 30)
		
				(if dialogue (print "sergeant (radio): i've got eyes on (a brute pack), over?"))
				(sleep (ai_play_line_on_object NONE 010mb_090))
				(sleep 10)

				(if dialogue (print "johnson (radio): say again, gunny? you're breaking up."))
				(sleep (ai_play_line johnson 010mb_100))
;*		
				(if (not (game_is_cooperative))
						(begin
							(if dialogue (print "arbiter: the brutes begin their hunt."))
							(sleep (ai_play_line arbiter 010mb_110))
						)
						(begin
							(if dialogue (print "johnson (radio): say again, gunny? you're breaking up."))
							(sleep (ai_play_line johnson 010mb_100))
						)
				)
*;

			; start music 02 
			(set g_music_010_02 TRUE)
		
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
)

; =======================================================================================================================================================================
(script dormant md_jw_mar_brute
	(sleep_until	(or
					(and
						g_jw_brute01
						(>= g_jw_obj_control 5)
					)
					(>= g_jw_obj_control 7)
				)
	)
	
	(if	(and 
			(<= g_jw_obj_control 6)
			(<= (ai_combat_status gr_jw_upper_cov) 4)
		)
		(begin
			(if debug (print "mission_dialogue : jungle_walk : marine : brute"))
		
				; cast the actors
				(vs_cast gr_marines TRUE 10 "010mb_210")
					(set marine_01 (vs_role 1))
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)

			; movement properties
			(vs_enable_looking marine_01  TRUE)
			(vs_enable_targeting marine_01 TRUE)
			(vs_enable_moving marine_01 TRUE)
		
			(sleep 1)
		
				(if dialogue (print "marine (whisper): up ahead!"))
				(sleep (ai_play_line marine_01 010mb_210))
				(sleep 15)
				
				(if dialogue (print "marine (whisper): single brute! plus backup!."))
				(sleep (ai_play_line marine_01 010mb_220))
			
;			(sleep_until (>= (ai_combat_status obj_jw_upper_covenant) 4))
;			(vs_crouch gr_marines FALSE)
;			(vs_crouch gr_arbiter FALSE)
			
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
)

; =======================================================================================================================================================================
(script dormant md_jw_mar_power_armor
	(sleep_until	(or
					(and
						(>= g_jw_obj_control 4)
						(>= (ai_combat_status gr_marines) 4)
						(>= (ai_combat_status gr_jw_upper_cov) 4)
						(< (unit_get_shield sq_jw_u_cov_01/brute) 1)
					)
					(>= g_jw_obj_control 9)
				)
	)
	(sleep (random_range 30 60))


	(if	(and
			(<= g_jw_obj_control 7)
			(>= (ai_living_count sq_jw_u_cov_01/brute) 1)
		)
		(begin
			(if debug (print "mission_dialogue : jungle_walk : marine : power armor"))
		
				; cast the actors 
				(vs_cast gr_marines TRUE 10 "010mb_210")
					(set marine_01 (vs_role 1))
					
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)

			; movement properties 
			(vs_enable_pathfinding_failsafe marine_01 TRUE)
			(vs_enable_looking marine_01  TRUE)
			(vs_enable_targeting marine_01 TRUE)
			(vs_enable_moving marine_01 TRUE)
			(sleep 1)
		
				(if dialogue (print "marine: they've got power-armor, chief!"))
				(sleep (ai_play_line marine_01 010mb_230))
				(sleep 15)
		
			(if 	(and
					(>= (ai_living_count sq_jw_u_cov_01/brute) 1)
					(> (object_get_shield sq_jw_u_cov_01/brute) 0)
				)
				(begin
					(if dialogue (print "marine: take down its shields before you close!"))
					(sleep (ai_play_line marine_01 010mb_240))
				)
			)
			
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
)

; =======================================================================================================================================================================
(script dormant md_jw_arb_prophets
	(sleep_until	(or
					(and
						(>= g_jw_obj_control 5)
						(<= (ai_living_count obj_jw_upper_covenant) 0)
					)
					(>= g_jw_obj_control 9)
				)
	)
	(sleep (random_range 15 30))
	
	(if (<= g_jw_obj_control 7)
		(begin
			(if debug (print "mission_dialogue : jungle_walk : arbiter : prophets"))

				; cast the actors 
				(vs_cast gr_arbiter TRUE 0 "010mb_250")
					(set arbiter (vs_role 1))
		
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)

			(vs_approach arbiter FALSE dead_brute 1.5 100 100)
				(sleep 1)
			(sleep_until (not (vs_running_atom arbiter)) 1 (* 30 5))
				(sleep 1)
			(vs_face_object arbiter TRUE dead_brute)
			(sleep 1)
		
				(if (<= (objects_distance_to_object arbiter dead_brute) 2)
					(begin
						(if dialogue (print "arbiter: the prophets are liars"))
						(vs_play_line arbiter TRUE 010mb_250)
						(sleep 10)
				
						(if dialogue (print "arbiter: but you are fools to do their bidding."))
						(vs_play_line arbiter TRUE 010mb_260)
					)
				)
				
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
	(game_save)
)

; =======================================================================================================================================================================
(global boolean g_md_jw_river FALSE)

(script dormant md_jw_river
	(sleep_until	(or
					(and
						(>= g_jw_obj_control 7)
						(<= (ai_living_count gr_jw_upper_cov) 0)
					)
					(>= g_jw_obj_control 9)
				)
	)
	(sleep (* 30 20))

	(if (<= g_jw_obj_control 7)
		(begin
			(if debug (print "mission_dialogue : jungle_walk : river"))
		
				(if (not (game_is_cooperative))
						(begin
							(vs_cast gr_arbiter TRUE 5 "010mb_270")
								(set arbiter (vs_role 1))
						)
						(begin
							(vs_cast gr_marines TRUE 5 "010mb_280")
								(set marine_01 (vs_role 1))
						)
				)
		
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)
			
				(if (not (game_is_cooperative))
						(begin
							; movement properties 
							(vs_enable_pathfinding_failsafe arbiter TRUE)
							(vs_enable_looking arbiter  TRUE)
							(vs_enable_targeting arbiter TRUE)
							(vs_enable_moving arbiter TRUE)
								(sleep 1)
							
							(if dialogue (print "arbiter: come. let us hurry to the river!"))
							(sleep (ai_play_line arbiter 010mb_270))
						)
						(begin			
							; movement properties 
							(vs_enable_pathfinding_failsafe marine_01 TRUE)
							(vs_enable_looking marine_01  TRUE)
							(vs_enable_targeting marine_01 TRUE)
							(vs_enable_moving marine_01 TRUE)
								(sleep 1)
							
							(if dialogue (print "marine: come on, chief. river's this way!"))
							(sleep (ai_play_line marine_01 010mb_280))
						)
				)
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
	(set g_md_jw_river TRUE)
	(game_save)
)
; =======================================================================================================================================================================
(script dormant md_jw_phantoms
	(sleep_until (>= g_jw_obj_control 8))
		(sleep 90)
	(if debug (print "mission_dialogue : jungle_walk : river"))

		(if (not (game_is_cooperative))
				(begin
					(vs_cast gr_allies FALSE 10 "010mq_010" "010mq_030")
						(set arbiter (vs_role 1))
						(set marine_01 (vs_role 2))
				)
				(begin
					(vs_cast gr_marines FALSE 10 "010mq_050" "010mq_030")
						(set sarge (vs_role 1))
						(set marine_01 (vs_role 2))
				)
		)
		
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(set g_playing_dialogue TRUE)
	(ai_dialogue_enable FALSE)

	; movement properties 
	(vs_enable_pathfinding_failsafe arbiter TRUE)
	(vs_enable_looking arbiter  TRUE)
	(vs_enable_targeting arbiter TRUE)
	(vs_enable_moving arbiter TRUE)
	
	(vs_enable_pathfinding_failsafe marine_01 TRUE)
	(vs_enable_looking marine_01  TRUE)
	(vs_enable_targeting marine_01 TRUE)
	(vs_enable_moving marine_01 TRUE)
		
	(vs_enable_pathfinding_failsafe sarge TRUE)
	(vs_enable_looking sarge  TRUE)
	(vs_enable_targeting sarge TRUE)
	(vs_enable_moving sarge TRUE)
		(sleep 1)
				
			(if (not (game_is_cooperative))
					(begin
;*
						(if dialogue (print "arbiter: they've sent a phantom!"))
						(ai_play_line arbiter 010mq_010)
							(sleep 5)
*;
						(if dialogue (print "marine: phantom inbound!"))
						(sleep (ai_play_line marine_01 010mq_030))
					)
					(begin
;*			
						(if dialogue (print "sarge: phantom inbound!"))
						(ai_play_line sarge 010mq_050)
							(sleep 5)
*;						
						(if dialogue (print "marine: phantom inbound!"))
						(sleep (ai_play_line arbiter 010mq_030))
					)
			)
		(set g_playing_dialogue FALSE)
		(ai_dialogue_enable TRUE)

	(set g_md_jw_river TRUE)
	(game_save)
)


; =======================================================================================================================================================================
(script dormant md_jw_post_combat
	(sleep_until	(or
					(and
						(>= g_jw_obj_control 10)
						(<= (ai_task_count obj_jw_lower_covenant/lower_gate_00) 0)
						(<= (ai_task_count obj_jw_lower_covenant/lower_gate_01) 0)
						(<= (ai_task_count obj_jw_lower_covenant/lower_gate_02) 0)
						(<= (ai_task_count obj_jw_lower_covenant/leftover_gate) 0)
					)
					(>= g_ta_obj_control 1)
				)
	)
	
	(sleep (random_range 60 120))
	
	(if (= g_ta_obj_control 0)
		(begin
			(if debug (print "mission_dialogue : jungle_walk : post_combat"))
				
				; cast the actors
				(if (not (game_is_cooperative))
					(begin
						(vs_cast gr_arbiter TRUE 0 "010MC_050")
							(set arbiter (vs_role 1))
						(vs_cast gr_marines FALSE 0 "010MC_010" "010MC_030")
							(set marine_01 (vs_role 1))
							(set marine_02 (vs_role 2))
					)
					(begin
						(vs_cast gr_marines TRUE 0 "010MC_010")
							(set marine_01 (vs_role 1))
						(vs_cast gr_marines FALSE 0 "010MC_030")
							(set marine_02 (vs_role 1))
					)
				)
		
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)

			; movement properties
			(vs_enable_pathfinding_failsafe gr_arbiter TRUE)
			(vs_enable_looking gr_arbiter  TRUE)
			(vs_enable_targeting gr_arbiter TRUE)
			(vs_enable_moving gr_arbiter TRUE)
			
			(vs_enable_pathfinding_failsafe marine_01 TRUE)
			(vs_enable_looking marine_01  TRUE)
			(vs_enable_targeting marine_01 TRUE)
			(vs_enable_moving marine_01 TRUE)
			
			(vs_enable_pathfinding_failsafe marine_02 TRUE)
			(vs_enable_looking marine_02  TRUE)
			(vs_enable_targeting marine_02 TRUE)
			(vs_enable_moving marine_02 TRUE)
			(sleep 1)
		
				(if dialogue (print "MARINE A: These Brutes are tough"))
				(sleep (ai_play_line marine_01 010MC_010))
				(sleep 15)
;*		
				(if (game_is_cooperative)
					(begin
						(if dialogue (print "MARINE A: Almost makes me wish we were still fighting the Elites."))
						(sleep (ai_play_line marine_01 010MC_020))
						(sleep 15)
					)
				)
*;		
				(if dialogue (print "MARINE B: Grunts ain't no slouches either"))
				(sleep (ai_play_line marine_02 010MC_030))
				(sleep 15)
		
				(if (game_is_cooperative)
					(begin
						(if dialogue (print "MARINE B: Maybe the Brutes put something in their tanks?"))
						(sleep (ai_play_line marine_02 010MC_040))
						(sleep 15)
					)
				)
				
				(if (>= (ai_living_count marine_02) 1)
					(begin
						(if dialogue (print "ARBITER: The Grunts' newfound courage is but fear."))
						(sleep (ai_play_line arbiter 010MC_050))
						(sleep 30)
					)
				)
		
				(if dialogue (print "ARBITER: When we are victorious"))
				(sleep (ai_play_line arbiter 010MC_060))
				(sleep 15)
		
				(if dialogue (print "ARBITER: All who serve the Prophets will be punished!"))
				(sleep (ai_play_line arbiter 010MC_070))
				
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
	(game_save)
)

; =======================================================================================================================================================================
(script dormant md_gc_mar_sleepers
	(sleep_until (volume_test_players tv_gc_ini_01))
	(sleep (* 30 5.5))

	(if debug (print "mission_dialogue : grunt_camp : marine : sleepers"))
	
		; cast the actors
		(vs_cast gr_marines TRUE 0 "010MD_010")
			(set marine_01 (vs_role 1))

	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(set g_playing_dialogue TRUE)
	(ai_dialogue_enable FALSE)

	; movement properties
	(vs_enable_pathfinding_failsafe marine_01 TRUE)
	(vs_enable_looking marine_01  TRUE)
	(vs_enable_targeting marine_01 TRUE)
	(vs_enable_moving marine_01 TRUE)
	(sleep 1)

	(sleep_until 
		(or
			(volume_test_objects tv_gc_md_sleepers marine_01)
			(> g_gc_obj_control 0)
		)
	5)
	
	; don't play dialogue if the player is hard charging 
	(if	(and
			(= g_gc_obj_control 0)
			(<= (ai_combat_status gr_gc_covenant) 4)
		)
		(begin
			(if dialogue (print "MARINE: Sleepers!"))
			(sleep (ai_play_line marine_01 010MD_010))
			(sleep 15)
	
			(if dialogue (print "MARINE: Take 'em out. Nice and quiet!"))
			(sleep (ai_play_line marine_01 010MD_020))
			(sleep 90)
		)
	)
		
	; stop music 04 
	(set g_music_010_04 FALSE)

	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; =======================================================================================================================================================================
(script dormant md_gc_mar_jackals
	(sleep_until	(or
					(and
						(not g_playing_dialogue)
						(>= g_gc_obj_control 1)
					)
					(and
						(not g_playing_dialogue)
						(volume_test_players tv_gc_ini_03)
					)
					(>= g_gc_obj_control 4)
				)
	)
	
	(if (<= g_gc_obj_control 3)
		(begin
			(if debug (print "mission_dialogue : grunt_camp : marine : jackals"))
		
				; cast the actors
				(vs_cast gr_marines TRUE 0 "010MD_030")
					(set marine_01 (vs_role 1))
				
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)
		
			; movement properties
			(vs_enable_pathfinding_failsafe marine_01 TRUE)
			(vs_enable_looking marine_01  TRUE)
			(vs_enable_targeting marine_01 TRUE)
			(vs_enable_moving marine_01 TRUE)
			(sleep 1)
		
			(if (<= (ai_combat_status gr_gc_covenant) 4)
				; if covenant are not activated 
				(begin
					(if dialogue (print "MARINE: Jackals! On the ridge!"))
					(sleep (ai_play_line marine_01 010MD_030))
					(sleep 15)
			
					(if dialogue (print "MARINE: Stay low. Looks like they've got carbines"))
					(sleep (ai_play_line marine_01 010MD_040))
					(sleep 15)
			
					; sleep until jackals are activated (or timeout) 
					(sleep_until (>= (ai_combat_status gr_gc_jackals) 5) 30 (* 30 2))
					(if (>= (ai_combat_status gr_gc_jackals) 5)
						(begin
							(if dialogue (print "MARINE: I hate it when I'm right!"))
							(sleep (ai_play_line marine_01 010MD_050))
						)
					)
				)
				
				; if covenant are activated 
				(begin
					(if dialogue (print "MARINE: Jackals! On the ridge!"))
					(sleep (ai_play_line marine_01 010MD_060))
					(sleep 15)
			
					(if dialogue (print "MARINE: They've got carbines!"))
					(sleep (ai_play_line marine_01 010MD_070))
				)
			)
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
)

; =======================================================================================================================================================================
(script dormant md_gc_joh_enroute
	(sleep_until	(or
					(and
						(not g_playing_dialogue)
						(>= g_gc_obj_control 6)
						(<= (ai_living_count obj_gc_covenant) 0)
					)
					(>= g_pa_obj_control 1)
				)
	)
	(if (= g_pa_obj_control 0)
		(begin
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)
			(sleep (random_range 120 150))
		
			(if debug (print "mission_dialogue : grunt_camp : johnson : enroute"))
		
				(if dialogue (print "JOHNSON: Pelicans are en route, Chief. But I can't raise Bravo"))
				(sleep (ai_play_line_on_object NONE 010MD_080))
				(sleep 15)
				
					; start music 05 
					(set g_music_010_05 TRUE)
			
				(if dialogue (print "JOHNSON: You find 'em? Get 'em to the extraction point."))
				(sleep (ai_play_line_on_object NONE 010MD_090))
				(sleep 15)
;*		
				(if dialogue (print "JOHNSON: Don't want our birds to roost any longer than they have too."))
				(sleep (ai_play_line_on_object NONE 010MD_100))
*;				
			(sleep 60)
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
	(game_save)
)

; ===================================================================================================================================================
(script dormant md_gc_post_combat
	(sleep_until	(or
					(and
						(not g_playing_dialogue)
						(>= g_gc_obj_control 7)
						(<= (ai_living_count obj_gc_covenant) 0)
					)
					(>= g_pa_obj_control 1)
				)
	)
	(sleep (* 30 10))
	(if (= g_pa_obj_control 0)
		(begin
			(if debug (print "mission_dialogue : grunt_camp : post_combat"))
				; cast the actors
				(if (not (game_is_cooperative))
					(begin
						(vs_cast gr_arbiter TRUE 0 "010MD_110")
							(set arbiter (vs_role 1))
					)
					(begin
						(vs_cast gr_marines TRUE 0 "010MD_120")
							(set marine_01 (vs_role 1))
					)
				)
		
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)

			; movement properties
			(vs_enable_pathfinding_failsafe gr_arbiter TRUE)
			(vs_enable_looking gr_arbiter  TRUE)
			(vs_enable_targeting gr_arbiter TRUE)
			(vs_enable_moving gr_arbiter TRUE)

			(vs_enable_pathfinding_failsafe marine_01 TRUE)
			(vs_enable_looking marine_01  TRUE)
			(vs_enable_targeting marine_01 TRUE)
			(vs_enable_moving marine_01 TRUE)
			(sleep 1)
		
			(if (not (game_is_cooperative))
				(begin
					(if dialogue (print "ARBITER: Come. The landing zone is this way!"))
					(sleep (ai_play_line arbiter 010MD_110))
				)
				(begin
					(if dialogue (print "MARINE: This way to the LZ, Chief!"))
					(sleep (ai_play_line marine_01 010MD_120))
				)
			)
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
	(game_save)
)

; ===================================================================================================================================================
(script dormant md_pa_joh_company
	(sleep_until	(or
					(and
						(not g_playing_dialogue)
						(>= g_pa_obj_control 9)
					)
					(>= g_ss_obj_control 1)
				)
	)
	(sleep (* 30 5))
	(if (= g_ss_obj_control 0)
		(begin
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)

			(if debug (print "mission_dialogue : path_a : johnson : company"))

			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)

			(if dialogue (print "JOHNSON: Chief? Pelicans are at the river!"))
			(sleep (ai_play_line_on_object NONE 010ME_010))
			(sleep 15)
	
			(if dialogue (print "JOHNSON: We got company, so hustle up!"))
			(sleep (ai_play_line_on_object NONE 010ME_020))
			(sleep 15)
			
				; set music 06 alternate 
				(set g_music_010_06_alt TRUE)

;*
			(if dialogue (print "JOHNSON: I wanna be gone most ricky-tick!"))
			(sleep (ai_play_line_on_object NONE 010ME_030))
			(sleep 15)
*;			
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
	(game_save)
)

; ===================================================================================================================================================
(script dormant md_pa_post_combat
	(sleep_until	(or
					(and
						(not g_playing_dialogue)
						(>= g_pa_obj_control 4)
						(<= (ai_living_count gr_pa_covenant) 0)
					)
					(>= g_pa_obj_control 8)
				)
	)
	(sleep 90)
	
	(if (<= g_pa_obj_control 5)
		(begin
			(if debug (print "mission_dialogue : path_a : post_combat"))
		
				; cast the actors
				(if (not (game_is_cooperative))
					(begin
						(vs_cast gr_arbiter TRUE 0 "010ME_040")
							(set arbiter (vs_role 1))
					)
					(begin
						(vs_cast gr_marines TRUE 0 "010ME_050")
							(set marine_01 (vs_role 1))
					)
				)
		
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)
		
			; movement properties
			(vs_enable_pathfinding_failsafe gr_arbiter TRUE)
			(vs_enable_looking gr_arbiter  TRUE)
			(vs_enable_targeting gr_arbiter TRUE)
			(vs_enable_moving gr_arbiter TRUE)
			
			(vs_enable_pathfinding_failsafe marine_01 TRUE)
			(vs_enable_looking marine_01  TRUE)
			(vs_enable_targeting marine_01 TRUE)
			(vs_enable_moving marine_01 TRUE)
			(sleep 1)
		
			(if (= g_ss_obj_control 0)
				(begin
					(if (not (game_is_cooperative))
						(begin
							(if dialogue (print "ARBITER: The river! Hurry!"))
							(sleep (ai_play_line arbiter 010ME_040))
						)
						(begin
							(if dialogue (print "MARINE: We gotta get to the river, Chief!"))
							(sleep (ai_play_line marine_01 010ME_050))
						)
					)
				)
			)
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
	(game_save)
)

; ===================================================================================================================================================
(script dormant md_ss_turrets
	(sleep_until	(or
					(and
						(not g_playing_dialogue)
						(>= g_ss_obj_control 4)
						(= (ai_combat_status gr_ss_turrets) 8)
					)
					(>= g_ss_obj_control 8)
				)
	)

	(if	(and
			(<= g_ss_obj_control 7)
			(>= (ai_living_count gr_ss_turrets) 1)
		)
		(begin
			(if debug (print "mission_dialogue : substation : turrets"))
		
				; cast the actors
				(if (not (game_is_cooperative))
					(begin
						(vs_cast gr_arbiter TRUE 0 "010MF_050")
							(set arbiter (vs_role 1))
					)
					(begin
						(vs_cast gr_marines TRUE 0 "010MF_070")
							(set marine_01 (vs_role 1))
					)
				)
		
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)
		
			; movement properties
			(vs_enable_pathfinding_failsafe gr_arbiter TRUE)
			(vs_enable_looking gr_arbiter  TRUE)
			(vs_enable_targeting gr_arbiter TRUE)
			(vs_enable_moving gr_arbiter TRUE)
			
			(vs_enable_pathfinding_failsafe marine_01 TRUE)
			(vs_enable_looking marine_01  TRUE)
			(vs_enable_targeting marine_01 TRUE)
			(vs_enable_moving marine_01 TRUE)
			(sleep 1)
			
			(if (not (game_is_cooperative))
				(begin
					(if dialogue (print "ARBITER: Grunt! With a turret!"))
					(sleep (ai_play_line arbiter 010MF_050))
					(sleep 15)
			
					(if dialogue (print "ARBITER: You flank! I'll draw its fire!"))
					(sleep (ai_play_line arbiter 010MF_060))
				)
				(begin		
					(if dialogue (print "MARINE: Grunt! Dropping a turret!"))
					(sleep (ai_play_line marine_01 010MF_070))
					(sleep 15)
			
					(if dialogue (print "MARINE: We'll flank! Chief, go right at it!"))
					(sleep (ai_play_line marine_01 010MF_080))
				)
			)
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
)

; ===================================================================================================================================================
(script dormant md_ss_post_combat
	(sleep_until	(or
					(and
						(not g_playing_dialogue)
						(>= g_ss_obj_control 9)
						(<= (ai_living_count obj_ss_covenant) 0)
					)
					(>= g_pb_obj_control 1)
				)
	)
	
	(if (= g_pb_obj_control 0)
		(begin
			(set g_playing_dialogue TRUE)
			(sleep (random_range 45 75))
			(if debug (print "mission_dialogue : substation : post_combat"))
		
				; cast the actors
				(if (not (game_is_cooperative))
					(begin
						(vs_cast gr_arbiter TRUE 0 "010MF_140")
							(set arbiter (vs_role 1))
					)
					(begin
						(vs_cast gr_marines TRUE 0 "010MF_160")
							(set marine_01 (vs_role 1))
					)
				)
		
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(ai_dialogue_enable FALSE)
				
			; movement properties
			(vs_enable_pathfinding_failsafe gr_arbiter TRUE)
			(vs_enable_looking gr_arbiter  TRUE)
			(vs_enable_targeting gr_arbiter TRUE)
			(vs_enable_moving gr_arbiter TRUE)
			
			(vs_enable_pathfinding_failsafe marine_01 TRUE)
			(vs_enable_looking marine_01  TRUE)
			(vs_enable_targeting marine_01 TRUE)
			(vs_enable_moving marine_01 TRUE)
		
			(sleep 1)
		
				(if (not (game_is_cooperative))
					(begin
						(if dialogue (print "ARBITER: The Banshees will return"))
						(sleep (ai_play_line arbiter 010MF_140))
						(sleep 15)
				
						(if dialogue (print "ARBITER: Hurry! Back into the jungle!"))
						(sleep (ai_play_line arbiter 010MF_150))
					)
					(begin		
						(if dialogue (print "MARINE: Banshees are gonna circle back"))
						(sleep (ai_play_line marine_01 010MF_160))
						(sleep 15)
				
						(if dialogue (print "MARINE: Let's head into the jungle, Sir!"))
						(sleep (ai_play_line marine_01 010MF_170))
					)
				)
				
		; start music 075 
		(set g_music_010_075 TRUE)

		; stop music 065 
		(set g_music_010_065 FALSE)

		(set g_playing_dialogue FALSE)
		(ai_dialogue_enable TRUE)
		)
	)
	
	; put allies in their proper objective
	(ai_set_objective gr_allies obj_pb_allies)
	(if debug (print "set ally objective"))
	
	(game_save)
)

; ===================================================================================================================================================
(script dormant md_pb_move_forward
	(sleep_until	(and
					g_pb_joh_alright
					(not g_playing_dialogue)
					(>= g_pb_obj_control 3)
				)
	)
	
	(if (<= g_pb_obj_control 5)
		(begin
			(if debug (print "mission_dialogue : path_b : move_forward"))
		
				; cast the actors
				(if (not (game_is_cooperative))
					(begin
						(vs_cast gr_arbiter TRUE 0 "010MG_010")
							(set arbiter (vs_role 1))
					)
					(begin
						(vs_cast gr_marines TRUE 0 "010MG_030")
							(set marine_01 (vs_role 1))
					)
				)
		
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)
				
			; movement properties
			(vs_enable_pathfinding_failsafe gr_arbiter TRUE)
			(vs_enable_looking gr_arbiter  TRUE)
			(vs_enable_targeting gr_arbiter TRUE)
			(vs_enable_moving gr_arbiter TRUE)
			
			(vs_enable_pathfinding_failsafe marine_01 TRUE)
			(vs_enable_looking marine_01  TRUE)
			(vs_enable_targeting marine_01 TRUE)
			(vs_enable_moving marine_01 TRUE)
		
			(sleep 1)
		
				(if (not (game_is_cooperative))
					(begin
						(if dialogue (print "ARBITER: Let us move forward"))
						(sleep (ai_play_line arbiter 010MG_010))
						(sleep 15)
				
						(if dialogue (print "ARBITER: This ravine will lead us to your Sergeant."))
						(sleep (ai_play_line arbiter 010MG_020))

					)
					(begin
						(if dialogue (print "MARINE: Keep going, Chief"))
						(sleep (ai_play_line marine_01 010MG_030))
					)
				)
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
	(game_save)
)

; ===================================================================================================================================================
(global boolean g_pb_joh_alright FALSE)

(script dormant md_pb_joh_alright
	(sleep_until (>= g_pb_obj_control 1))
	(sleep (random_range 15 60))
	(if debug (print "mission_dialogue : substation : johnson : alright"))

		(vs_set_cleanup_script md_cleanup)
		(set g_playing_dialogue TRUE)

			(if dialogue (print "JOHNSON: (Static) Chief? Can you hear me?"))
			(sleep (ai_play_line_on_object NONE 010MF_090))
			(sleep 60)
	
			(if dialogue (print "JOHNSON: My bird's down. Half a click down river from your position"))
			(sleep (ai_play_line_on_object NONE 010MF_100))
			(sleep 15)

		(set g_playing_dialogue FALSE)
		(set g_pb_joh_alright TRUE)

	(game_save)
)

; =======================================================================================================================================================================

(script dormant md_pb_mar_jackals
	(sleep_until	(and
					(not g_playing_dialogue)
					(>= g_pb_obj_control 2)
				)
	)
	
	(if (<= g_pb_obj_control 2)
		(begin
			(if debug (print "mission_dialogue : path_b : marine : jackals"))
		
				; cast the actors
				(vs_cast gr_marines TRUE 0 "010MD_030")
					(set marine_01 (vs_role 1))
				
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)
		
			; movement properties
			(vs_enable_pathfinding_failsafe marine_01 TRUE)
			(vs_enable_looking marine_01  TRUE)
			(vs_enable_targeting marine_01 TRUE)
			(vs_enable_moving marine_01 TRUE)
			(sleep (random_range 30 60))
		
			(if (<= (ai_combat_status gr_pb_covenant) 4)
				; if covenant are not activated 
				(begin
					(if dialogue (print "MARINE: Jackals! On the ridge!"))
					(sleep (ai_play_line marine_01 010MD_030))
					(sleep 15)
			
					(if dialogue (print "MARINE: Stay low. Looks like they've got carbines"))
					(sleep (ai_play_line marine_01 010MD_040))
					(sleep 15)
				)
				
				; if covenant are activated 
				(begin
					(if dialogue (print "MARINE: Jackals! On the ridge!"))
					(sleep (ai_play_line marine_01 010MD_060))
					(sleep 15)
			
					(if dialogue (print "MARINE: They've got carbines!"))
					(sleep (ai_play_line marine_01 010MD_070))
				)
			)
		
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
)

; ===================================================================================================================================================

(script dormant md_ba_pelican
	(sleep_until (volume_test_players tv_ba_pelican))
	(if debug (print "ambient : brute_ambush : pelican"))
	(sleep (random_range 45 75))
	
		(if dialogue (print "MARINE: Echo five-one, this is crows nest!"))
		(sleep (ai_play_line_on_object ba_pelican_radio 010mx_160))
			(sleep 30)

		(if dialogue (print "MARINE: Echo five-one, please respond!"))
		(sleep (ai_play_line_on_object ba_pelican_radio 010mx_170))
			(sleep 30)

		(if dialogue (print "MARINE: Hocus. Five-one is down. Divert for emergency evac, over?"))
		(sleep (ai_play_line_on_object ba_pelican_radio 010mx_180))

	; start music 076 
	(set g_music_010_076 TRUE)
)

; ===================================================================================================================================================

(script dormant md_ba_post_combat
	(sleep_until	(or
					(and
						(not g_playing_dialogue)
						(>= g_ba_obj_control 4)
						(<= (ai_living_count obj_ba_covenant) 0)
					)
					(>= g_dam_obj_control 1)
				)
	)
	(sleep (random_range 30 90))

	(if (<= g_dam_obj_control 1)
		(begin
			(if debug (print "mission_dialogue : brute_ambush : bunkered_down"))
		
				; cast the actors
				(vs_cast gr_marines TRUE 0 "010mx_190")
					(set marine_01 (vs_role 1))
		
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(set g_playing_dialogue TRUE)
			(ai_dialogue_enable FALSE)
				
		
				(if dialogue (print "MARINE: Sergeant Major went this way, Chief! Through the cave!"))
				(sleep (ai_play_line marine_01 010mx_190))
				(sleep 15)
			
			(ai_dialogue_enable TRUE)
			(set g_playing_dialogue FALSE)
		)
	)
)

; ===================================================================================================================================================

(script dormant md_dam_pelican_attack
	(sleep_until g_dam_pelican_arrive)

	(if debug (print "mission_dialogue : dam : pelican_attack"))

		; cast marines 
		(vs_cast sq_dam_joh_marines TRUE 10 "010MI_090")
			(set johnson (vs_role 1))

			(sleep 1)
		
			; movement properties
			(vs_enable_pathfinding_failsafe johnson TRUE)
			(vs_enable_looking johnson  TRUE)
			(vs_enable_targeting johnson TRUE)
			(vs_enable_moving johnson TRUE)

			; if either phantom is alive then speak this dialogue 
			(if	(or
					(>= (ai_living_count sq_dam_phantom_03) 1)
					(>= (ai_living_count sq_dam_phantom_04) 1)
				)
				(begin
				
					(if dialogue (print "JOHNSON (radio): Hocus! Phantom!"))
					(sleep (ai_play_line johnson 010MI_090))
					(sleep 10)
			
					(if dialogue (print "HOCUS (radio): I see him! Standby!"))
					(sleep (ai_play_line_on_object NONE 010MI_100))
					(sleep 10)
		
					(sleep_until g_dam_pelican_attack01 1)
				)
			)

			; if near phantom is alive then speak this dialogue 
			(if (>= (ai_living_count sq_dam_phantom_03) 1)
				(begin

					(sleep (random_range 30 45))
						(if dialogue (print "HOCUS (radio): Going loud! Everyone down!"))
						(sleep (ai_play_line_on_object NONE 010MI_080))
						(sleep 10)
				
					(sleep_until (<= (ai_living_count sq_dam_phantom_03) 0) 1)
					
						(if dialogue (print "HOCUS (radio): Scratch one Phantom!"))
						(sleep (ai_play_line_on_object NONE 010MI_110))
						(sleep 10)
				)
			)
		
;			(sleep_until g_dam_pelican_attack02 1)
;*		
				(if dialogue (print "JOHNSON (radio): Another one, Hocus! Stay sharp!"))
				(sleep (ai_play_line_on_object NONE 010MI_120))
				(sleep 10)
		
				(if dialogue (print "HOCUS (radio): Roger that!"))
				(sleep (ai_play_line_on_object NONE 010MI_130))
				(sleep 10)
*;		

			; if far phantom is alive then speak this dialogue (after it's dead) 
			(if (>= (ai_living_count sq_dam_phantom_04) 1)
				(begin
					(sleep_until (<= (ai_living_count sq_dam_phantom_04) 0) 1)

					(sleep (random_range 30 45))
						(if dialogue (print "HOCUS (radio): Scratch two!"))
						(sleep (ai_play_line_on_object NONE 010MI_140))
				)
			)
)

; ===================================================================================================================================================
(global boolean g_johnson_pile_in FALSE)

(script dormant md_dam_joh_pile_in
	(sleep_until g_johnson_pile_in)
	(sleep 90)
	(cs_run_command_script johnson abort)
	(sleep 1)
	
	(if debug (print "mission_dialogue : dam : johnson_pile_in"))

		; cast the actors
		(vs_cast gr_allies TRUE 10 "010MI_150")
			(set johnson (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe johnson TRUE)
	(vs_enable_looking johnson  TRUE)
	(vs_enable_targeting johnson TRUE)
	(vs_enable_moving johnson TRUE)

	(sleep 1)

		(vs_go_to_vehicle johnson FALSE dam_pelican "pelican_p")
		
		(vs_set_cleanup_script md_cleanup)
		(set g_playing_dialogue TRUE)
		(ai_dialogue_enable FALSE)
	
		(if dialogue (print "JOHNSON: That's the way to do it!"))
		(sleep (ai_play_line johnson 010MI_150))
		(sleep 10)

		(if dialogue (print "JOHNSON: Everyone pile in!"))
		(sleep (ai_play_line johnson 010MI_160))
		(sleep 10)
		
		(ai_dialogue_enable TRUE)
	
	(cs_run_command_script johnson cs_dam_marines_to_pelican)
)

; ===================================================================================================================================================
(script dormant md_dam_joh_leave
	(sleep_until (or g_johnson_pile_in g_dam_player_in_pelican))
	(sleep (* 30 30))
	(cs_run_command_script johnson abort)
	(sleep 1)

	(if (not g_dam_player_in_pelican)
		(begin
			(if debug (print "mission_dialogue : dam : johson_leave"))
		
				; cast the actors
				(vs_cast gr_allies TRUE 10 "010MI_170")
					(set johnson (vs_role 1))
		
			; movement properties
			(vs_enable_pathfinding_failsafe johnson TRUE)
			(vs_enable_looking johnson  TRUE)
			(vs_enable_targeting johnson TRUE)
			(vs_enable_moving johnson TRUE)
		
			(sleep 1)
			
			(vs_go_to_vehicle johnson FALSE dam_pelican "pelican_p")
			
			(vs_set_cleanup_script md_cleanup)
	    	(set g_playing_dialogue TRUE)
    		(ai_dialogue_enable FALSE)
		
				(if dialogue (print "JOHNSON: Come on, Chief! Commander Keyes is waiting!"))
				(sleep (ai_play_line johnson 010MI_170))
				(sleep 10)
		
				(if dialogue (print "JOHNSON: Don't got no time to sight-see. Let's go!"))
				(sleep (ai_play_line johnson 010MI_180))
				(sleep 10)
				(cs_run_command_script gr_allies cs_dam_marines_to_pelican)
		
			(sleep (* 30 15))
				
			(if (not g_dam_player_in_pelican)
				(begin

					(vs_go_to_vehicle johnson FALSE dam_pelican "pelican_p")
					
					(if dialogue (print "JOHNSON: Earth isn't gonna save itself, Chief. Step on up!"))
					(sleep (ai_play_line johnson 010MI_190))
					(sleep 10)
			
					(if dialogue (print "JOHNSON: Do you, or do you not want to finish the fight?"))
					(sleep (ai_play_line johnson 010MI_200))
					(sleep 10)
					(cs_run_command_script gr_allies cs_dam_marines_to_pelican)
				)
			)
			
			(ai_dialogue_enable TRUE)
			
		(cs_run_command_script johnson cs_dam_marines_to_pelican)
		)
	)
)

; =======================================================================================================================================================================
; randon arbiter dialogue 
; =======================================================================================================================================================================

; =======================================================================================================================================================================
; randon marine dialogue 
; =======================================================================================================================================================================


; =======================================================================================================================================================================
; =======================================================================================================================================================================
; vignettes 
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global boolean g_jw_joh_phantom_arb TRUE)
(global boolean g_jw_joh_phantom_joh TRUE)
(global boolean g_jw_joh_phantom_mar TRUE)

(script dormant vs_jw_joh_phantom
	(sleep_until (>= g_jw_obj_control 3))
	(sleep (* 30 3))
	(if debug (print "vignette : jungle_walk : johnson : phantom"))

		; cast all actors  
		(vs_cast gr_arbiter FALSE 10 "")
			(set arbiter (vs_role 1))
		(vs_cast gr_johnson_marines FALSE 10 "010mb_130")
			(set johnson (vs_role 1))
		(vs_cast gr_johnson_marines FALSE 10 "" "" "")
			(set joh_marine_01 (vs_role 1))
			(set joh_marine_02 (vs_role 2))
			(set joh_marine_03 (vs_role 3))
		(vs_cast gr_marines FALSE 10 "")
			(set sarge (vs_role 1))
		(vs_cast gr_marines FALSE 10 "010mb_120" "" "")
			(set marine_01 (vs_role 1))
			(set marine_02 (vs_role 2))
			(set marine_03 (vs_role 3))
	
	(ai_disregard (ai_actors sq_jw_phantom_01/phantom) TRUE)
	(ai_disregard (ai_actors sq_jw_phantom_05/phantom) TRUE)
	
	(vs_enable_moving gr_marines TRUE)
	(vs_enable_targeting gr_marines TRUE)
	(vs_enable_moving gr_arbiter TRUE)
	(vs_enable_targeting gr_arbiter TRUE)
	(vs_enable_moving gr_johnson_marines TRUE)
	(vs_enable_targeting gr_johnson_marines TRUE)
	
		(if (<= g_jw_obj_control 3)
			(begin
				(if (volume_test_object tv_jw_03 johnson) (vs_crouch johnson TRUE))
				(if (volume_test_object tv_jw_03 joh_marine_01) (vs_crouch joh_marine_01 TRUE))
				(if (volume_test_object tv_jw_03 joh_marine_02) (vs_crouch joh_marine_02 TRUE))
				(if (volume_test_object tv_jw_03 joh_marine_03) (vs_crouch joh_marine_03 TRUE))
				(if (volume_test_object tv_jw_03 sarge) (vs_crouch sarge TRUE))
				(if (volume_test_object tv_jw_03 marine_01) (vs_crouch marine_01 TRUE))
				(if (volume_test_object tv_jw_03 marine_02) (vs_crouch marine_02 TRUE))
				(if (volume_test_object tv_jw_03 marine_03) (vs_crouch johnson TRUE))

				(if dialogue (print "marine (whisper): sergeant major! phantom inbound!"))
				(sleep (ai_play_line marine_01 010mb_120))

					; start music 03 
					(set g_music_010_03 TRUE)
		
				(sleep (* 30 2))
			)
		)

		(if (>= g_jw_obj_control 4)
			(begin
				(vs_crouch gr_marines FALSE)
				(vs_crouch gr_johnson_marines FALSE)
			)
			(begin
				(if dialogue (print "johnson (whisper): we stick together, and we're gonna get spotted."))
				(sleep (ai_play_line johnson 010mb_130))
				(sleep 20)
			)
		)
		(if (<= g_jw_obj_control 3)
			(begin
				(if dialogue (print "johnson (whisper): let's split up. meet back at the lz."))
				(ai_play_line johnson 010mb_140)
			)
		)
	
	; release marines 
	(if (<= g_jw_obj_control 3) (sleep 30))
	(vs_crouch gr_marines FALSE)
	(set g_jw_joh_phantom_mar FALSE)
	(if (<= g_jw_obj_control 3) (sleep (* 30 2)))

	(if (<= g_jw_obj_control 3)
		(begin
			(vs_crouch johnson FALSE)
			(vs_face_player johnson TRUE)
			(vs_look_player johnson TRUE)
			(sleep 30)
			(if	(not (game_is_cooperative))
					(begin
						(if dialogue (print "johnson (whisper): chief, go with the arbiter. head toward the river."))
						(ai_play_line johnson 010mb_150)
					)
					(begin
						(if dialogue (print "johnson (whisper): chief, you and the arbiter head toward the river."))
						(ai_play_line johnson 010mb_160)
					)
			)
		)
	)

	; release arbiter 
	(if (<= g_jw_obj_control 3) (sleep 30))
	(set g_jw_joh_phantom_arb FALSE)

		; throttle back up player input 
		(player_control_scale_all_input 1.0 3)

	(if (<= g_jw_obj_control 3) (sleep 90))

	(if (<= g_jw_obj_control 3)
		(begin
			(if dialogue (print "johnson: second squad, you're with me!"))
			(ai_play_line johnson 010mb_170)
		)
	)

	(vs_release joh_marine_01)
	(vs_release joh_marine_02)
	(vs_release joh_marine_03)
	(sleep 1)
	(cs_run_command_script joh_marine_01 cs_jw_climb_mar_01)
	(cs_run_command_script joh_marine_02 cs_jw_climb_mar_02)
	(cs_run_command_script joh_marine_03 cs_jw_climb_mar_03)
	
	(if (<= g_jw_obj_control 3) (vs_action johnson FALSE ps_jw/waterfall_johnson ai_action_point))

	(if (<= g_jw_obj_control 3) (sleep 30))
	(vs_release johnson)
	(cs_run_command_script johnson cs_jw_climb_johnson)
	(set g_jw_joh_phantom_joh FALSE)
)

(global boolean g_jw_johnson_past FALSE)
(global short g_jw_marines_climbing 0) 

; johnson and marines climbing out of the jungle 
(script command_script cs_jw_climb_johnson
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ps_jw/joh00)
		(set g_jw_johnson_past TRUE)
	(cs_go_to ps_jw/mar02)
	(cs_go_to ps_jw/mar00)
	(cs_go_to ps_jw/ground_jon)
	(cs_face_player TRUE)
	
	(sleep_until (>= g_jw_marines_climbing 3))
	(cs_face_player FALSE)
	(sleep (random_range 60 75))
	(cs_go_to ps_jw/ground_02)
	(cs_stow)
		(sleep 5)
	(biped_force_ground_fitting_on ai_current_actor TRUE)
	(cs_custom_animation objects\characters\marine\cinematics\vignettes\010vc_climbing_wall\010vc_climbing_wall "010vc_johnson_climb_var2" TRUE ps_jw/ground_02)
	(cs_stop_custom_animation)
	(biped_force_ground_fitting_on ai_current_actor FALSE)
	(sleep 1)
	(cs_force_combat_status 3)
	(cs_draw)
	
	(cs_go_to ps_jw/waterfall_johnson)
	
	(if (volume_test_players tv_jw_climb_out)
		(begin
			(cs_face_player TRUE)
			(cs_look_player TRUE)
			(sleep 30)
			
			(if dialogue (print "johnson: keep an eye out for bravo team, chief."))
			(cs_play_line 010mb_180)
			(sleep 10)
	
			(if dialogue (print "johnson: if the brutes do have our scent"))
			(cs_play_line 010mb_190)
			(sleep 10)
	
			(if dialogue (print "johnson: those boys are in a lot of trouble."))
			(cs_play_line 010mb_200)
			(sleep 10)
			
			(cs_face_player FALSE)
			(cs_look_player FALSE)
		)
	)
			
	(cs_look_player FALSE)
	(cs_go_to ps_jw/climb_out)
	(ai_erase ai_current_actor)
)
(script command_script cs_jw_climb_mar_01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ps_jw/mar01)
	(cs_go_to ps_jw/mar00)
	(cs_go_to ps_jw/ground_01)
	(cs_stow)
		(sleep 5)
	(set g_jw_marines_climbing (+ g_jw_marines_climbing 1))
	(biped_force_ground_fitting_on ai_current_actor TRUE)
	(cs_custom_animation objects\characters\marine\cinematics\vignettes\010vc_climbing_wall\010vc_climbing_wall "010vc_johnson_climb:var1" TRUE ps_jw/ground_01)
	(cs_stop_custom_animation)
	(biped_force_ground_fitting_on ai_current_actor FALSE)
	(sleep 1)
	(cs_force_combat_status 3)
	(cs_draw)
	(cs_go_to ps_jw/climb_out)
	(ai_erase ai_current_actor)
)
(script command_script cs_jw_climb_mar_02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ps_jw/mar02)
	(cs_go_to ps_jw/mar00)
	(cs_go_to ps_jw/ground_02)
	(cs_stow)
		(sleep 5)
	(set g_jw_marines_climbing (+ g_jw_marines_climbing 1))
	(biped_force_ground_fitting_on ai_current_actor TRUE)
	(cs_custom_animation objects\characters\marine\cinematics\vignettes\010vc_climbing_wall\010vc_climbing_wall "010vc_johnson_climb_var2" TRUE ps_jw/ground_02)
	(cs_stop_custom_animation)
	(biped_force_ground_fitting_on ai_current_actor FALSE)
	(sleep 1)
	(cs_force_combat_status 3)
	(cs_draw)
	(cs_go_to ps_jw/climb_out)
	(ai_erase ai_current_actor)
)
(script command_script cs_jw_climb_mar_03
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ps_jw/mar03)
	(cs_go_to ps_jw/mar00)
	(cs_go_to ps_jw/ground_03)
	(cs_stow)
		(sleep 5)
	(set g_jw_marines_climbing (+ g_jw_marines_climbing 1))
	(biped_force_ground_fitting_on ai_current_actor TRUE)
	(cs_custom_animation objects\characters\marine\cinematics\vignettes\010vc_climbing_wall\010vc_climbing_wall "010vc_johnson_climb_var3" TRUE ps_jw/ground_03)
	(cs_stop_custom_animation)
	(biped_force_ground_fitting_on ai_current_actor FALSE)
	(sleep 1)
	(cs_force_combat_status 3)
	(cs_draw)
	(cs_go_to ps_jw/climb_out)
	(ai_erase ai_current_actor)
)

(script static void test_jw_climb
	(ai_erase_all)
	(sleep 1)
	(ai_place sq_jw_johnson_marines)
	(sleep 1)

		(vs_cast gr_johnson_marines TRUE 0 "010mb_130")
			(set johnson (vs_role 1))
		(vs_cast gr_johnson_marines TRUE 0 "" "" "")
			(set joh_marine_01 (vs_role 1))
			(set joh_marine_02 (vs_role 2))
			(set joh_marine_03 (vs_role 3))

	(vs_teleport johnson ps_jw/test04 ps_jw/ground_jon)
	(vs_teleport joh_marine_01 ps_jw/test01 ps_jw/ground_01)
	(vs_teleport joh_marine_02 ps_jw/test02 ps_jw/ground_02)
	(vs_teleport joh_marine_03 ps_jw/test03 ps_jw/ground_03)
	(sleep 1)
	(vs_release_all)
	(sleep 1)

	(cs_run_command_script johnson cs_jw_climb_johnson)
	(cs_run_command_script joh_marine_01 cs_jw_climb_mar_01)
	(cs_run_command_script joh_marine_02 cs_jw_climb_mar_02)
	(cs_run_command_script joh_marine_03 cs_jw_climb_mar_03)
)


; =======================================================================================================================================================================
; ===================================================================================================================================================
; ===================================================================================================================================================
(global boolean g_jw_brute01 FALSE)
(global boolean g_jw_grunt_move FALSE)
(global boolean g_jw_phantom_02_drop FALSE)

(global short g_jw_brute_sleep (* 30 50))
(global short g_jw_grunt_sleep (* 30 60))

(global vehicle jw_phantom_01 NONE)
(global vehicle jw_phantom_02 NONE)
(global vehicle jw_phantom_04 NONE)
(global vehicle jw_phantom_05 NONE)

(script dormant vs_jw_brute_squad
	(sleep_until (>= g_jw_obj_control 3))

		; cast all actors  
		(vs_cast sq_jw_u_cov_01/brute TRUE 10 "010mx_010")
			(set brute_01 (vs_role 1))
		(vs_cast sq_jw_u_cov_01/grunt01 FALSE 10 "010mx_020")
			(set grunt_01 (vs_role 1))
		(vs_cast sq_jw_u_cov_01/grunt02 FALSE 10 "")
			(set grunt_02 (vs_role 1))

		(vs_enable_pathfinding_failsafe brute_01 TRUE)
		(vs_enable_pathfinding_failsafe grunt_01 TRUE)
		(vs_enable_pathfinding_failsafe grunt_02 TRUE)
		(vs_abort_on_damage brute_01 TRUE)
		(vs_stow brute_01)
		
	(vs_posture_set brute_01 "act_guard_1" TRUE)
		
	(sleep_until (>= g_jw_obj_control 4))
	(sleep_until (>= g_jw_obj_control 5) 5 g_jw_brute_sleep)
	(sleep (random_range 15 30))

		(vs_look_object brute_01 TRUE grunt_01)
		(vs_abort_on_combat_status brute_01 8)
		
		(set g_jw_grunt_move TRUE)
		(vs_force_combat_status grunt_01 3)
		(vs_force_combat_status grunt_02 3)
		(vs_go_to grunt_01 FALSE ps_jw_cov/grunt03_01)
		(vs_go_to grunt_02 FALSE ps_jw_cov/grunt04_01)

			(if dialogue (print "BRUTE: Spread out you whelps! Find Them!"))
			(sleep (ai_play_line brute_01 010mx_010))
			(sleep 15)
;*
			(if dialogue (print "GRUNT: As you command!"))
			(sleep (ai_play_line grunt_01 010mx_020))
			(sleep 15)
*;			
	(cs_run_command_script grunt_01 cs_jw_grunt_04)
;*
			(if dialogue (print "GRUNT: Who die and make HIM pack-leader?"))
			(sleep (ai_play_line grunt_02 010mx_030))
			(sleep 15)
*;
	(cs_run_command_script grunt_02 cs_jw_grunt_03)
		
	(sleep_random)

		; allows marines to comment on the brute 
		(set g_jw_brute01 TRUE)

		(vs_posture_exit brute_01)
	(vs_go_to_and_posture brute_01 TRUE ps_jw_cov/brute02 "act_kneel_1")
		(vs_abort_on_alert brute_01 FALSE)
		(vs_abort_on_damage brute_01 FALSE)
		(vs_abort_on_combat_status brute_01 100)
	(sleep_until (>= (ai_combat_status obj_jw_upper_covenant) 4) 1)
		(vs_posture_exit brute_01)
		(sleep 14)
		(vs_face_player brute_01 TRUE)
		(vs_draw brute_01)
		(sleep 15)
	(vs_action_at_player brute_01 TRUE ai_action_point)
)

(script command_script cs_jw_grunt_01
		(cs_enable_pathfinding_failsafe TRUE)
		(cs_movement_mode ai_movement_combat)
		(cs_abort_on_damage TRUE)
	(sleep_until	(or
					g_jw_grunt_move
					(>= g_jw_obj_control 6)
					(>= (ai_combat_status sq_jw_u_cov_01/brute) 4)
				)
	5)
		(cs_abort_on_combat_status 8)
	(cs_go_to ps_jw_cov/grunt01_01)
	(sleep_random)
		(cs_enable_targeting TRUE)
		(cs_enable_looking TRUE)
	(sleep_random)
	(cs_go_to ps_jw_cov/grunt01_02)
	(sleep_random)
	(sleep_random)
)
(script command_script cs_jw_grunt_02
		(cs_enable_pathfinding_failsafe TRUE)
		(cs_movement_mode ai_movement_combat)
		(cs_abort_on_damage TRUE)
	(sleep_until	(or
					g_jw_grunt_move
					(>= g_jw_obj_control 6)
					(>= (ai_combat_status sq_jw_u_cov_01/brute) 4)
				)
	5)
		(cs_abort_on_combat_status 8)
	(cs_go_to ps_jw_cov/grunt02_01)
	(sleep_random)
		(cs_enable_targeting TRUE)
		(cs_enable_looking TRUE)
	(sleep_random)
	(cs_go_to ps_jw_cov/grunt02_02)
	(sleep_random)
	(sleep_random)
	(cs_go_to ps_jw_cov/grunt02_03)
	(sleep_random)
)
(script command_script cs_jw_grunt_03
		(cs_enable_pathfinding_failsafe TRUE)
		(cs_movement_mode ai_movement_combat)
		(cs_abort_on_damage TRUE)
		(cs_abort_on_combat_status 8)
	(cs_go_to ps_jw_cov/grunt03_01)
		(cs_enable_targeting TRUE)
		(cs_enable_looking TRUE)
		(sleep_random)
	(if (<= (game_difficulty_get) normal) (cs_go_to ps_jw_cov/grunt03_02))
	(sleep_until g_null)
)
(script command_script cs_jw_grunt_04
		(cs_enable_pathfinding_failsafe TRUE)
		(cs_movement_mode ai_movement_combat)
		(cs_abort_on_damage TRUE)
		(cs_abort_on_combat_status 8)
	(cs_go_to ps_jw_cov/grunt04_01)
		(cs_enable_targeting TRUE)
		(cs_enable_looking TRUE)
		(sleep_random)
	(if (<= (game_difficulty_get) normal) (cs_go_to ps_jw_cov/grunt04_02))
	(sleep_until g_null)
)
(script command_script cs_jw_grunt_05
		(cs_enable_pathfinding_failsafe TRUE)
		(cs_movement_mode ai_movement_combat)
		(cs_abort_on_damage TRUE)
	(sleep_until	(or
					g_jw_grunt_move
					(>= g_jw_obj_control 6)
					(>= (ai_combat_status sq_jw_u_cov_01/brute) 4)
				)
	5)
		(cs_abort_on_combat_status 8)
	(cs_go_to ps_jw_cov/grunt05_01)
	(sleep_random)
		(cs_enable_targeting TRUE)
		(cs_enable_looking TRUE)
	(sleep_random)
	(cs_go_to ps_jw_cov/grunt05_02)
	(sleep_random)
	(sleep_random)
	(cs_go_to ps_jw_cov/grunt05_03)
	(sleep_random)
)
(script command_script cs_jw_grunt_06
		(cs_enable_pathfinding_failsafe TRUE)
		(cs_movement_mode ai_movement_combat)
		(cs_abort_on_damage TRUE)
	(sleep_until	(or
					g_jw_grunt_move
					(>= g_jw_obj_control 6)
					(>= (ai_combat_status sq_jw_u_cov_01/brute) 4)
				)
	5)
		(cs_abort_on_combat_status 8)
	(cs_go_to ps_jw_cov/grunt06_01)
	(sleep_random)
		(cs_enable_targeting TRUE)
		(cs_enable_looking TRUE)
	(cs_go_to ps_jw_cov/grunt06_02)
	(sleep_random)
)
(script command_script cs_jw_grunt_07
		(cs_enable_pathfinding_failsafe TRUE)
		(cs_movement_mode ai_movement_combat)
		(cs_abort_on_damage TRUE)
	(sleep_until	(or
					g_jw_grunt_move
					(>= g_jw_obj_control 6)
					(>= (ai_combat_status sq_jw_u_cov_01/brute) 4)
				)
	5)
		(cs_abort_on_combat_status 8)
	(cs_go_to ps_jw_cov/grunt07_01)
	(sleep_random)
		(cs_enable_targeting TRUE)
		(cs_enable_looking TRUE)
	(cs_go_to ps_jw_cov/grunt07_02)
	(sleep_random)
)



; ===================================================================================================================================================
; ===================================================================================================================================================
; ===================================================================================================================================================
(global object obj_sarge NONE)

(script dormant vs_pa_brute_slam
	(if debug (print "vignette : path_a : brute_slam"))

		; casting call
		(if debug (print "casting call..."))
	
		; marine 
		(vs_cast sq_pa_vs_marines/slam FALSE 0 "010VA_030")
			(set sarge (vs_role 1))
	
		; brute 
		(vs_cast sq_pa_cov_01/brute TRUE 0 "010VA_010")
			(set brute_01 (vs_role 1))

	; set the sarge to a global object 
	(set obj_sarge sarge)
	
	; the sarge cannot die 
	(ai_cannot_die sarge TRUE)
	
	; abort on damage 
	(vs_abort_on_damage brute_01 TRUE)
	(vs_set_cleanup_script vs_pa_brute_slam_cleanup)
	(vs_enable_dialogue sarge TRUE)

	; stow the brutes weapon 
	(vs_stow brute_01)
		(sleep 1)

	(vs_custom_animation_loop sarge objects\characters\marine\cinematics\vignettes\0x0vb_brute_throw_marine\0x0vb_brute_throw_marine "010va_vict_idle" FALSE ps_pa/slam)
	(vs_custom_animation_loop brute_01 objects\characters\brute\cinematics\vignettes\0x0vb_brute_throw_marine\0x0vb_brute_throw_marine "010va_exec_idle" FALSE ps_pa/slam)
	
		; sleep until covenant are activated, player approaches or script times out 
		(sleep_until	(or
						(>= g_pa_obj_control 1)
						(>= (ai_combat_status obj_pa_covenant) 4)
					)
		 5 (* 30 10))
		 
		; if the player activates the covenant from a distance sleep an additional n-seconds 
		(if (and (<= g_pa_obj_control 1) (>= (ai_combat_status obj_pa_covenant) 4)) (sleep (random_range 30 45)))

		(if dialogue (print "BRUTE: Tell me its location"))
		(vs_play_line brute_01 TRUE 010VA_010)
		(sleep 15)
;*
		(if dialogue (print "BRUTE1: Or die like the others!"))
		(vs_play_line brute_01 TRUE 010VA_020)
		(sleep 15)
*;
		(if dialogue (print "SERGEANT: Kiss. My. Ass."))
		(vs_play_line sarge TRUE 010VA_030)

	; the sarge cannot die 
	(ai_cannot_die sarge FALSE)
	
	; kill animation 
	(vs_abort_on_damage brute_01 FALSE)
	(vs_custom_animation_death sarge FALSE objects\characters\marine\cinematics\vignettes\0x0vb_brute_throw_marine\0x0vb_brute_throw_marine "010va_vict_kill" TRUE ps_pa/slam)
	(vs_custom_animation brute_01 FALSE objects\characters\brute\cinematics\vignettes\0x0vb_brute_throw_marine\0x0vb_brute_throw_marine "010va_exec_kill" TRUE ps_pa/slam)
	
		(sleep 5)
		(if dialogue (print "BRUTE: (angry roar)"))
		(vs_play_line brute_01 FALSE 010MD_130)

	(sleep_until (not (vs_running_atom brute_01)) 1)
	(vs_abort_on_damage brute_01 TRUE)

	; brute laugh 
	(vs_custom_animation brute_01 FALSE objects\characters\brute\cinematics\vignettes\0x0vb_brute_throw_marine\0x0vb_brute_throw_marine "010va_exec_post_kill" TRUE ps_pa/slam)

		(if dialogue (print "BRUTE: (angry roar)"))
		(vs_play_line brute_01 FALSE 010MD_130)

	(begin_random
		(begin
			(ai_activity_abort sq_pa_cov_01/grunt_01)
			(sleep (random_range 0 5))
		)
		(begin
			(ai_activity_abort sq_pa_cov_01/grunt_02)
			(sleep (random_range 0 5))
		)
		(begin
			(ai_activity_abort sq_pa_cov_01/grunt_03)
			(sleep (random_range 0 5))
		)
	)
	
	(sleep_until (not (vs_running_atom brute_01)))
	(vs_stop_custom_animation brute_01)

)

(script static void vs_pa_brute_slam_cleanup
	(if debug (print "brute slam cleanup script"))
	(vs_stop_custom_animation brute_01)
	(vs_stop_custom_animation sarge)
	(sleep 1)
	
	; damage the sarge to get him to stop his dialogue 
	(damage_object sarge "" 10)
	(ai_play_line sarge "")

	(vs_reserve brute_01 TRUE 0)

	(sleep 1)

	; the sarge can die 
	(ai_cannot_die sarge FALSE)

	; brute draws his weapon 
	(vs_draw brute_01)
	(wake md_pa_sarge)
)
	
(script dormant md_pa_sarge
				; marine 
				(vs_cast sq_pa_vs_marines/slam TRUE 0 "010VA_030")
					(set sarge (vs_role 1))
			
			(vs_enable_pathfinding_failsafe sarge TRUE)
			(vs_force_combat_status sarge 3)
			(vs_go_to sarge TRUE ps_pa/ar01)
			(vs_crouch sarge TRUE)
			(sleep 15)
			(unit_add_equipment sarge marine_ar TRUE TRUE)
			(object_destroy pa_ar)
			(sleep 5)
			(vs_crouch sarge FALSE)
			(print "disregard")
			(ai_disregard (ai_actors sq_pa_vs_marines/slam) FALSE)
		
			(vs_enable_moving sarge TRUE)
			(vs_enable_targeting sarge TRUE)
		
	(sleep_until	(or
					(>= g_pa_obj_control 3)
					(and
						(<= (ai_task_count obj_pa_covenant/bottom_cov_02) 0)
						(<= (ai_task_count obj_pa_covenant/jackal_ini_gate) 0)
					)
				)
	)

	(if (<= g_pa_obj_control 2)
		(begin
			(sleep (random_range 45 60))
			(vs_aim_player sarge TRUE)
			(vs_approach_player sarge TRUE 3 20 20)

			(if dialogue (print "SERGEANT: Brute Chieftain. Phantom."))
			(vs_play_line sarge TRUE 010MD_140)
			(sleep 15)
			
			(if dialogue (print "SERGEANT: Pinned us down. Killed my men."))
			(vs_play_line sarge TRUE 010MD_150)
	
		(vs_aim_player sarge FALSE)
		)
	)
)

(script static void test_pa_brute_slam
	(ai_place sq_pa_cov_01)

	; placing vignette marine 
	(ai_place sq_pa_vs_marines)
	(ai_disregard (ai_actors sq_pa_vs_marines) TRUE)
	(sleep 1)
	(wake vs_pa_brute_slam)
)

; ===================================================================================================================================================
; ===================================================================================================================================================
; ===================================================================================================================================================
(global boolean g_ss_banshee_ambush FALSE)

(global vehicle ss_pelican_01 NONE)
(global vehicle ss_pelican_02 NONE)

(global vehicle ss_banshee_01 NONE)
(global vehicle ss_banshee_02 NONE)

(global boolean g_ss_kill_pelicans FALSE)
(global boolean g_ss_pelican01_hit FALSE)
(global boolean g_ss_pelican02_hit FALSE)

(script dormant vs_ss_banshee_ambush
		(sleep 10) ; so ai are spawned in the world 
	(if debug (print "vignette : substation : banshee_ambush"))

	(set ss_pelican_01 (ai_vehicle_get_from_starting_location sq_ss_pelican_01/pilot))
	(set ss_pelican_02 (ai_vehicle_get_from_starting_location sq_ss_pelican_02/pilot))
		(sleep 1)

	; set ai deathless parameters 
	(ai_cannot_die sq_ss_pelican_02/johnson TRUE)

	(custom_animation_relative_loop ss_pelican_01 objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash "pelican1_loop" FALSE ss_pelican_anchor)
	(custom_animation_relative_loop ss_pelican_02 objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash "pelican2_loop" FALSE ss_pelican_anchor)
		; cast the actors 
		(vs_cast sq_ss_pelican_02 FALSE 0 "010VB_010")
			(set johnson (vs_role 1))
;		(vs_cast sq_ss_pelican_01/pilot TRUE 0 "")
;			(set pilot_01 (vs_role 1))
;		(vs_cast sq_ss_pelican_02/pilot TRUE 0 "")
;			(set pilot_02 (vs_role 1))

	; place johnson in the back of the pelican 
	(objects_attach (ai_vehicle_get_from_starting_location sq_ss_pelican_02/pilot) "machinegun_turret" (ai_vehicle_get_from_starting_location sq_ss_pelican_02/johnson) "")
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_ss_pelican_02/johnson))
	(object_cannot_take_damage (ai_get_object sq_ss_pelican_02/johnson))
	
	; enable targeting for johnson 
	(vs_enable_targeting johnson TRUE) 
	(vs_enable_looking johnson TRUE)

	(sleep_until (>= g_ss_obj_control 1))
	
;*
		(if dialogue (print "JOHNSON: Keep her steady"))
		(sleep (ai_play_line_on_object NONE 010VB_010))
		(sleep 15)

		(if dialogue (print "JOHNSON: Got 'em right where I want em!"))
		(sleep (ai_play_line_on_object NONE 010VB_020))
		(sleep 15)

		(if dialogue (print "PILOT 01: Will do, Sergeant Major..."))
		(sleep (ai_play_line_on_object NONE 010VB_030))
		(sleep 15)

		(if dialogue (print "PILOT 01: Light 'em up!"))
		(sleep (ai_play_line_on_object NONE 010VB_040))
*;
	(sleep_until	(or
					(>= g_ss_obj_control 3)
					(<= (ai_task_count obj_ss_covenant/d_cov_01) 1)
				)
	5 (* 30 30))
	
		(ai_place sq_ss_banshees)

		(if dialogue (print "PILOT 02: Hold on got a contact"))
		(sleep (ai_play_line_on_object NONE 010VB_050))
		(sleep 90)

		(if dialogue (print "PILOT 02: Banshees! Fast and low!"))
		(sleep (ai_play_line_on_object NONE 010VB_060))
		(sleep 15)

		(if dialogue (print "PILOT 01: Break-off! Now!"))
		(ai_play_line_on_object NONE 010VB_070)


		(sleep_until g_ss_pelican01_hit 1)
			(if debug (print "Pelican 01 hit animation"))
			(custom_animation_relative ss_pelican_01 objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash "pelican1_1" TRUE ss_pelican_anchor)
		
	(wake md_ss_pelican01_hit)

		(sleep_until g_ss_pelican02_hit 1)
			(if debug (print "Pelican 02 hit animation"))
			(custom_animation_relative ss_pelican_02 objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash "pelican2_1" TRUE ss_pelican_anchor)

		; stop music 06 
		(set g_music_010_06 FALSE)

		(if dialogue (print "PILOT 02: Lost a thruster! Hang on!"))
		(sleep (ai_play_line_on_object NONE 010VB_110))
		(sleep 15)

		(if dialogue (print "JOHNSON: Get a hold of her!"))
		(vs_play_line johnson TRUE 010VB_120)
		(sleep 10)

		(if dialogue (print "PILOT 02: Negative! We're going down!"))
		(ai_play_line_on_object NONE 010VB_130)

	(if
		(and
			(>= (game_difficulty_get) heroic)
			(<= g_ss_obj_control 4)
		)
		(ai_place sq_ss_phantom_01)
	)

	(sleep (unit_get_custom_animation_time ss_pelican_01))
	(vs_release pilot_01)
		(sleep 1)
	(if debug (print "erasing pelican 01"))
	(ai_erase sq_ss_pelican_01)



	(sleep (unit_get_custom_animation_time ss_pelican_02))
	(set g_ss_banshee_ambush TRUE)
		(sleep 1)
	(wake obj_locate_pelican_set)
	(if debug (print "erasing pelican 02"))
	(ai_erase sq_ss_pelican_02)

)

(script dormant md_ss_pelican01_hit
	(sleep 20)
	(if dialogue (print "PILOT 01: I'm hit! I'm hit!"))
	(ai_play_line_on_object NONE 010VB_080)
	(sleep 15)

		; stop music 05 
		(set g_music_010_05 FALSE)

	(if dialogue (print "PILOT 01: Watch yourself!"))
	(ai_play_line_on_object NONE 010VB_090)
	(sleep 5)

	(if dialogue (print "PILOT 01: (death scream)"))
	(ai_play_line_on_object NONE 010VB_100)
)

(script command_script cs_ss_banshee_01
	(set ss_banshee_01 (ai_vehicle_get_from_starting_location sq_ss_banshees/banshee01))
		(sleep 1)
	(object_cannot_take_damage ss_banshee_01)
		(cs_enable_pathfinding_failsafe TRUE)
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_ss_banshee/b1_0)
	(cs_fly_by ps_ss_banshee/b1_1)
		(cs_vehicle_boost FALSE)
		(cs_shoot_point TRUE ps_ss_banshee/b1_shoot)
	(cs_fly_by ps_ss_banshee/b1_2)
		(cs_shoot_point FALSE ps_ss_banshee/b1_shoot)
			(sleep 1)
		(cs_shoot_point TRUE ps_ss_banshee/b1_shoot)
		(cs_shoot_secondary_trigger TRUE)
		
		(sleep 32)
	(set g_ss_pelican01_hit TRUE)
		
	(cs_fly_by ps_ss_banshee/b1_3)
		(cs_shoot_point FALSE ps_ss_banshee/b1_shoot)
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_ss_banshee/b1_4 5)
	(cs_fly_by ps_ss_banshee/b1_5 5)
	(cs_fly_by ps_ss_banshee/b1_6 5)
	(cs_fly_by ps_ss_banshee/b1_7 5)
	(cs_fly_by ps_ss_banshee/b1_erase 2)
	(ai_erase ai_current_actor)
)
(script command_script cs_ss_banshee_02
	(set ss_banshee_02 (ai_vehicle_get_from_starting_location sq_ss_banshees/banshee02))
	(vehicle_hover ai_current_actor TRUE)
		(sleep 150)
	(vehicle_hover ai_current_actor FALSE)
	(object_cannot_take_damage ss_banshee_02)
		(cs_enable_pathfinding_failsafe TRUE)
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_ss_banshee/b2_0)
	(cs_fly_by ps_ss_banshee/b2_1)
		(cs_vehicle_boost FALSE)
		(cs_shoot_point TRUE ps_ss_banshee/b2_shoot)
	(cs_fly_by ps_ss_banshee/b2_2)
		(cs_shoot_point FALSE ps_ss_banshee/b2_shoot)
			(sleep 1)
		(cs_shoot_point TRUE ps_ss_banshee/b2_shoot)
		(cs_shoot_secondary_trigger TRUE)
		
		(sleep 45)
	(set g_ss_pelican02_hit TRUE)
		
	(cs_fly_by ps_ss_banshee/b2_3)
		(cs_shoot_point FALSE ps_ss_banshee/b2_shoot)
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_ss_banshee/b2_4 5)
	(cs_fly_by ps_ss_banshee/b2_5 5)
	(cs_fly_by ps_ss_banshee/b2_6 5)
	(cs_fly_by ps_ss_banshee/b2_7 5)
	(cs_fly_by ps_ss_banshee/b2_erase 2)
	(ai_erase ai_current_actor)
)

(script static void test_ss_banshee_ambush
	(ai_place sq_ss_pelican_01)
	(ai_place sq_ss_pelican_02)
	(ai_place sq_ss_cov_01)
	(ai_place sq_ss_cov_02)
	(ai_place sq_ss_cov_03)
		(sleep 1)
	(wake vs_ss_banshee_ambush)
	(set g_ss_obj_control 4)
)

(script static void test_ss_banshees
	(ai_place sq_ss_banshees/banshee01)
	(ai_place sq_ss_banshees/banshee02)
		(sleep 1)
	(set ss_banshee_01 (ai_vehicle_get_from_starting_location sq_ss_banshees/banshee01))
	(set ss_banshee_02 (ai_vehicle_get_from_starting_location sq_ss_banshees/banshee02))
)

(script static void test_ss_pelicans
	(ai_place sq_ss_pelican_01)
	(ai_place sq_ss_pelican_02)
		(sleep 1)
	(set ss_pelican_01 (ai_vehicle_get_from_starting_location sq_ss_pelican_01/pilot))
	(set ss_pelican_02 (ai_vehicle_get_from_starting_location sq_ss_pelican_02/pilot))
		(sleep 10)
	(unit_open ss_pelican_01)
	(unit_open ss_pelican_02)
	(vs_look pilot_01 TRUE ps_ss_pelican/pel01_look)
	(vs_look pilot_02 TRUE ps_ss_pelican/pel02_look)
	(vs_enable_moving pilot_01 TRUE)
	(vs_enable_moving pilot_02 TRUE)
	
	(custom_animation_relative_loop ss_pelican_01 objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash "pelican1_loop" FALSE ss_pelican_anchor)
	(custom_animation_relative_loop ss_pelican_02 objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash "pelican2_loop" FALSE ss_pelican_anchor)
)
; ===================================================================================================================================================
; ===================================================================================================================================================
; ===================================================================================================================================================
(global boolean g_ba_dumb_apes_continue FALSE)
(global boolean g_ba_phantom_stop FALSE)
(global boolean g_ba_ph01_shoot_loop TRUE)
(global boolean g_ba_ph02_shoot_loop TRUE)
(global boolean g_ba_marine_03 FALSE)


(script dormant vs_ba_joh_dumb_apes
	(sleep 5)
	(if debug (print "vignette : brute_ambush : johnson : dumb_apes"))

		; cast the actors
		(vs_cast gr_johnson_marines TRUE 10 "010MH_010")
			(set johnson (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe gr_johnson_marines TRUE)
	(vs_enable_looking gr_johnson_marines  TRUE)
	(vs_enable_targeting gr_johnson_marines TRUE)
	(vs_force_combat_status johnson 3)

	(ai_cannot_die johnson TRUE)
	(vs_aim johnson TRUE ps_ba/joh_look)

		(sleep_until (volume_test_players tv_ba_ledge) 1 (* 30 30))
		(set g_ba_dumb_apes_continue TRUE)

		(if dialogue (print "JOHNSON: Come on, you dumb apes!"))
		(ai_play_line johnson 010MH_010)
	
	(vs_go_to johnson TRUE ps_ba/joh1)

		(if dialogue (print "JOHNSON: You want breakfast, you gotta catch it!"))
		(ai_play_line johnson 010MH_020)
		(sleep 15)

		(set g_ba_marine_03 TRUE)
	(vs_aim johnson TRUE ps_dam_ba/joh_exit)
	(vs_go_to johnson TRUE ps_ba/joh2)
	(vs_go_to johnson TRUE ps_ba/joh3)

		; set objective variable true 
		(set g_ba_johnson_objective TRUE)
		
	(vs_go_to johnson TRUE ps_ba/joh4)
		(set g_ba_phantom_stop TRUE)
	(vs_go_to johnson TRUE ps_dam_ba/joh_exit)

	(ai_erase johnson)
)

(script command_script cs_ba_marine_01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_force_combat_status 3)
	(ai_cannot_die ai_current_actor TRUE)

	(cs_aim TRUE ps_ba/joh_look)
		(sleep_until g_ba_dumb_apes_continue 5)
		(ai_cannot_die ai_current_actor FALSE)
	(cs_go_to ps_ba/mar01_02)
		(sleep (random_range 0 15))
	(cs_grenade ps_ba/gr01 1)
		(sleep (random_range 0 15))
	(cs_aim TRUE ps_dam_ba/joh_exit)
	(cs_go_to ps_ba/joh2)
	(cs_go_to ps_ba/joh3)
	(cs_go_to ps_ba/joh4)
		(set g_ba_phantom_stop TRUE)
	(cs_go_to ps_dam_ba/joh_exit)
		(ai_erase ai_current_actor)
)

(script command_script cs_ba_marine_02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_force_combat_status 3)
	(ai_cannot_die ai_current_actor TRUE)

	(cs_aim TRUE ps_ba/joh_look)
		(sleep_until g_ba_dumb_apes_continue 5)
		(ai_cannot_die ai_current_actor FALSE)
	(cs_go_to ps_ba/mar02_02)
		(sleep (random_range 0 15))
	(cs_grenade ps_ba/gr02 1)
		(sleep (random_range 0 15))
	(cs_aim TRUE ps_dam_ba/joh_exit)
	(cs_go_to ps_ba/joh2)
	(cs_go_to ps_ba/joh3)
	(cs_go_to ps_ba/joh4)
		(set g_ba_phantom_stop TRUE)
	(cs_go_to ps_dam_ba/joh_exit)
		(ai_erase ai_current_actor)
)

(script command_script cs_ba_marine_03
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_moving TRUE)
	(cs_force_combat_status 3)
	(ai_cannot_die ai_current_actor TRUE)

	(cs_crouch TRUE)
		(sleep_until g_ba_marine_03 5)
		(sleep (random_range 5 20))
	(ai_cannot_die ai_current_actor FALSE)
	(cs_crouch FALSE)
	(cs_go_to ps_ba/joh2)
	(cs_go_to ps_ba/joh3)
	(cs_go_to ps_ba/joh4)
		(set g_ba_phantom_stop TRUE)
	(cs_go_to ps_dam_ba/joh_exit)
		(ai_erase ai_current_actor)
)

(script command_script cs_ba_joh_brute
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_force_combat_status 3)

	(cs_go_to ps_ba/br00)
		(sleep_until g_ba_dumb_apes_continue 5)
		(sleep (random_range 30 45))
	(cs_go_to ps_ba/br01)
		(sleep (random_range 30 45))
	(cs_grenade ps_ba/br_gr01 1)
		(sleep 75)
	(cs_go_to ps_ba/joh1)
	(cs_go_to ps_ba/joh2)
		(sleep 75)
	(cs_face TRUE ps_dam_ba/joh_exit)
	(cs_go_to ps_ba/joh3)
	(cs_go_to ps_ba/joh4)
;	(cs_go_to ps_dam_ba/joh_exit)
;		(ai_erase ai_current_actor)
)

(script command_script cs_ba_joh_grunts
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_force_combat_status 3)

	(cs_go_to ps_ba/gr00)
		(sleep_until g_ba_dumb_apes_continue 5)
		(sleep (random_range 30 45))
	(cs_go_to ps_ba/joh1)
	(cs_go_to ps_ba/joh2)
	(cs_go_to ps_ba/joh3)
	(cs_go_to ps_ba/joh4)
;	(cs_go_to ps_dam_ba/joh_exit)
;		(ai_erase ai_current_actor)
)

(script command_script cs_ba_ph01_shoot
	(cs_force_combat_status 3)
	(sleep_until
		(begin
			(begin_random
				(if g_ba_ph01_shoot_loop
					(begin
						(cs_shoot_point TRUE ps_ba/ph_shoot01)
						(sleep (random_range 45 75))
						(cs_shoot_point FALSE ps_ba/ph_shoot01)
						(set g_ba_ph01_shoot_loop FALSE)
					)
				)
				(if g_ba_ph01_shoot_loop
					(begin
						(cs_shoot_point TRUE ps_ba/ph_shoot02)
						(sleep (random_range 45 75))
						(cs_shoot_point FALSE ps_ba/ph_shoot02)
						(set g_ba_ph01_shoot_loop FALSE)
					)
				)
				(if g_ba_ph01_shoot_loop
					(begin
						(cs_shoot_point TRUE ps_ba/ph_shoot03)
						(sleep (random_range 45 75))
						(cs_shoot_point FALSE ps_ba/ph_shoot03)
						(set g_ba_ph01_shoot_loop FALSE)
					)
				)
				(if g_ba_ph01_shoot_loop
					(begin
						(cs_shoot_point TRUE ps_ba/ph_shoot04)
						(sleep (random_range 45 75))
						(cs_shoot_point FALSE ps_ba/ph_shoot04)
						(set g_ba_ph01_shoot_loop FALSE)
					)
				)
			)
			(set g_ba_ph01_shoot_loop TRUE)
		g_ba_phantom_stop)
	)
)

(script command_script cs_ba_ph02_shoot
	(cs_force_combat_status 3)
	(sleep_until
		(begin
			(begin_random
				(if g_ba_ph02_shoot_loop
					(begin
						(cs_shoot_point TRUE ps_ba/ph_shoot01)
						(sleep (random_range 45 75))
						(cs_shoot_point FALSE ps_ba/ph_shoot01)
						(set g_ba_ph02_shoot_loop FALSE)
					)
				)
				(if g_ba_ph02_shoot_loop
					(begin
						(cs_shoot_point TRUE ps_ba/ph_shoot02)
						(sleep (random_range 45 75))
						(cs_shoot_point FALSE ps_ba/ph_shoot02)
						(set g_ba_ph02_shoot_loop FALSE)
					)
				)
				(if g_ba_ph02_shoot_loop
					(begin
						(cs_shoot_point TRUE ps_ba/ph_shoot03)
						(sleep (random_range 45 75))
						(cs_shoot_point FALSE ps_ba/ph_shoot03)
						(set g_ba_ph02_shoot_loop FALSE)
					)
				)
				(if g_ba_ph02_shoot_loop
					(begin
						(cs_shoot_point TRUE ps_ba/ph_shoot04)
						(sleep (random_range 45 75))
						(cs_shoot_point FALSE ps_ba/ph_shoot04)
						(set g_ba_ph02_shoot_loop FALSE)
					)
				)
			)
			(set g_ba_ph02_shoot_loop TRUE)
		g_ba_phantom_stop)
	)
)

(script static void test_ba_dumb_apes
	(ai_place sq_ba_johnson_marines)
	(ai_place sq_ba_cov_01)
	(ai_place sq_ba_phantom_01)
	(ai_place sq_ba_phantom_02)
	(sleep 5)
	
	(wake vs_ba_joh_dumb_apes)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; perspectives 
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global unit obj_arbiter NONE)
(global unit obj_johnson NONE)
(global unit obj_chieftain NONE)

(global boolean g_010pb_finished FALSE)
(global boolean g_dam_prisoners_free FALSE)
(global boolean g_dam_prisoners_speak FALSE)
(global boolean g_dam_follow_objective FALSE)

; main perspective thread 
(script dormant 010pb_johnson_captured
	(sleep_until (>= g_dam_obj_control 1) 1)
	
	(if debug (print "perspective : dam : johnson_captured"))

		; cast the actors 
		(if (not (game_is_cooperative))
				(begin
					(vs_cast gr_arbiter FALSE 10 "")
						(set arbiter (vs_role 1))
				)
		)
		(set obj_arbiter arbiter)

	; all marines with the player will approach and crouch 
	(cs_run_command_script gr_marines cs_dam_marines_approach)
	
	; set ai to be blind and deaf 
	(ai_set_blind gr_covenant TRUE)
	(ai_set_deaf gr_covenant TRUE)

	; lock gaze  
	(player_control_lock_gaze (player0) ps_dam/phantom 40)
	(player_control_lock_gaze (player1) ps_dam/phantom 40)
	(player_control_lock_gaze (player2) ps_dam/phantom 40)
	(player_control_lock_gaze (player3) ps_dam/phantom 40)

	; fade out input 
	(player_control_scale_all_input 0.25 0.5)

		; start perspective 
		(perspective_start)
		(sleep 5)
		
		; wake chapter title 
		(wake chapter_favor)

		; camera animation 
		(010pa_jail_bait)
		
		; cut to black 
		(fade_out 0 0 0 0)
		
		; set perspective_running false (used for chapter title letterboxes) 
		(set perspective_running FALSE)

	; teleport players 
	(object_teleport (player0) 010pa_player0)
	(object_teleport (player1) 010pa_player1)
	(object_teleport (player2) 010pa_player2)
	(object_teleport (player3) 010pa_player3)
		
		; set player pitch 
		(player0_set_pitch g_player_start_pitch 0)
		(player1_set_pitch g_player_start_pitch 0)
		(player2_set_pitch g_player_start_pitch 0)
		(player3_set_pitch g_player_start_pitch 0)
		(sleep 1)
		
	; prepare to switch zone sets 
	(prepare_to_switch_to_zone_set set_dam)
		
	(vs_teleport arbiter ps_dam/010pa_arb_teleport ps_dam/jail_hover)
	(vs_release gr_arbiter)
	(ai_set_blind gr_covenant FALSE)
	(ai_set_deaf gr_covenant FALSE)
	
	(object_create_containing eq_dam_cover)

		; if perspective ends cinematic_fade... 
		; if player skips while chapter title is up 
		; if player skips after chapter title is done  
		(if	(or
				perspective_finished
				chapter_finished
			)
			(cinematic_fade_to_gameplay)
			(perspective_skipped)
		)
		
	; set current objective 
	(wake obj_get_to_johnson_clear)
	(wake obj_rescue_johnson_set)

	(set g_010pb_finished TRUE)
)

(script dormant vs_dam_jail_bait
		; set ai deathless parameters 
		(ai_cannot_die sq_dam_joh_marines/johnson TRUE)
		(ai_cannot_die sq_dam_chieftain/chieftain TRUE)
	
	(sleep_until (>= g_dam_obj_control 1) 1)
	
		(vs_cast sq_dam_joh_marines/johnson TRUE 10 "")
                (set johnson (vs_role 1))
		(vs_cast sq_dam_chieftain/chieftain TRUE 10 "")
                (set chieftain (vs_role 1))
		(sleep 45)
	
	(vs_custom_animation chieftain FALSE objects\characters\brute\cinematics\perspectives\010pa_jail_bait\010pa_jail_bait "010pa_brute_guard_1" FALSE ps_dam/010pa_brute)
	(vs_custom_animation johnson TRUE objects\characters\marine\cinematics\perspectives\010pa_jail_bait\010pa_jail_bait "010pa_johnson_1" FALSE ps_dam/010pa_brute)
	
	(vs_stop_custom_animation chieftain)
	(vs_release chieftain)
	
		; abort activities and run command scirpt 
		(cs_run_command_script sq_dam_bodyguards abort)
			(sleep 1)

		; set ai deathless parameters 
		(ai_cannot_die sq_dam_chieftain/chieftain FALSE)
	
	(vs_teleport johnson ps_dam/johnson ps_dam/jail_hover)
		(sleep 5)
	(vs_posture_set johnson "act_captured_kneel" FALSE)
		(sleep 120)
	(device_set_position dam_jail 1)
		(sleep 60)
	(device_group_change_only_once_more_set dg_cov_dam_generator TRUE)
	
	(sleep_until (>= g_dam_obj_control 8) 1)
)

(script dormant vs_dam_jail_rescue
	(sleep_until (>= g_dam_obj_control 8) 1)

		(vs_cast sq_dam_joh_marines/johnson TRUE 20 "")
                (set johnson (vs_role 1))

;*
		(if	(and
				(= (device_group_get dg_cov_dam_generator) 1)
				(<= (ai_task_count obj_dam_08_evac_covenant/infantry_gate) 0)
			)
			(begin
				(if dialogue (print "JOHNSON: Well, isn't this ironic"))
				(sleep (ai_play_line johnson 010MI_010))
				(sleep 15)
			)
		)
*;		
		(sleep (random_range 15 45))
		(if (= (device_group_get dg_cov_dam_generator) 1)
			(begin
				(if dialogue (print "JOHNSON: This isn't as fun as it looks. Cut the power!"))
				(sleep (ai_play_line johnson 010MX_210))
			)
		)
		(set g_dam_prisoners_speak TRUE)

	(sleep_until (<= (device_group_get dg_cov_dam_generator) 0) 1)
		(sleep (random_range 5 15))

		; set clear previous objective 
		(wake obj_rescue_johnson_clear)

		; allow covenant to attack the marines 
		(ai_disregard (ai_actors sq_dam_joh_marines) FALSE)
		(ai_set_blind sq_dam_joh_marines FALSE)
		(ai_set_deaf sq_dam_joh_marines FALSE)

	(set g_dam_prisoners_free TRUE)

		(set g_dam_place_phantom_03 TRUE)
	
	(sleep (random_range 30 45))
	(vs_posture_exit johnson)

		(if dialogue (print "JOHNSON: I guess we're even as long as we're only counting today."))
		(ai_play_line johnson 010MI_020)
		(sleep 45)

	; allow allies to follow the player 
	(set g_dam_follow_objective TRUE)
	
	; suppress combat dialogue
	(ai_dialogue_enable FALSE)

	(vs_enable_pathfinding_failsafe johnson TRUE)
	(vs_movement_mode johnson 2)
	(vs_go_to johnson FALSE ps_dam/joh_00)

			(sleep 90)
			(if dialogue (print "JOHNSON (radio): Kilo two three, what's your ETA?"))
			(ai_play_line johnson 010MI_030)

	(vs_go_to johnson TRUE ps_dam/joh_01)
		(sleep 5)
	(unit_add_equipment johnson marine_needler TRUE TRUE)
	(vs_enable_targeting johnson TRUE)
	(vs_enable_moving johnson TRUE)
		(sleep 75)
	
			(if dialogue (print "HOCUS (radio): Imminent, Sergeant."))
			(sleep (ai_play_line_on_object NONE 010MI_040))
			(sleep 10)
	
			(if dialogue (print "HOCUS (radio): Find some cover. Gotta clear a path!"))
			(sleep (ai_play_line_on_object NONE 010MI_050))
			(sleep 10)
	
			(if dialogue (print "JOHNSON (radio): Roger that, Hocus."))
			(sleep (ai_play_line johnson 010MI_060))
			(sleep 10)
	
			(if dialogue (print "JOHNSON: Friendly gunship! Coming in hot!"))
			(sleep (ai_play_line johnson 010MI_070))
			(sleep 10)

	; migrate all allies into the current objective again 
	(ai_set_objective gr_allies obj_dam_allies)
	
	; re-enable comabt dialogue 
	(ai_dialogue_enable TRUE)
	
		; set current objective 
		(wake obj_extraction_set)
	
		; start music 08 
		(set g_music_010_08 TRUE)
	
	; game save 
	(game_save)
)

(script command_script cs_dam_ini_chieftain
	(sleep 1)
	(sleep_until g_null)
)

(script command_script cs_dam_marines_approach
	; approach the player and crouch 
	(cs_approach_player 5 40 40)
	(cs_face_player TRUE)
		(sleep 5)
	(cs_crouch TRUE)
	
	;sleep until the perspective is done 
	(sleep_until g_010pb_finished)
	(cs_run_command_script gr_marines abort)
)

(script command_script cs_dam_mar_01
;	(cs_posture_set "act_captured_sit_wall" TRUE)
	(cs_enable_dialogue TRUE)
	(sleep_until g_dam_prisoners_free 1)
		(sleep (random_range 30 90))
	(cs_posture_exit)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_combat)
	(cs_go_to ps_dam/fem_01)
		(sleep 5)
	(unit_add_equipment sq_dam_joh_marines/mar_01 marine_carbine TRUE TRUE)
		(sleep 5)
	(cs_face_object FALSE jail_crate02)
)
(script command_script cs_dam_mar_02
;	(cs_posture_set "act_captured_kneel" TRUE)
	(cs_enable_dialogue TRUE)
	(sleep_until g_dam_prisoners_speak 1)
	(sleep (random_range 30 60))
	
		(if (= (device_group_get dg_cov_dam_generator) 1)
			(begin
				(if dialogue (print "MARINE: Brutes were gonna gut us, sir!"))
				(cs_play_line 010MX_230)
				(sleep 15)
			)
		)
	
	(sleep_until g_dam_prisoners_free 1)
		(sleep (random_range 30 90))
	(cs_posture_exit)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_combat)
	(cs_go_to ps_dam/fem_02)
		(sleep 5)
	(unit_add_equipment sq_dam_joh_marines/mar_02 marine_spike TRUE TRUE)
		(sleep 5)
	(cs_face_object FALSE jail_crate03)
)
(script command_script cs_dam_mar_03
;	(cs_posture_set "act_captured_sit_wall" TRUE)
	(cs_enable_dialogue TRUE)
	(sleep_until g_dam_prisoners_free 1)
		(sleep (random_range 30 90))
	(cs_posture_exit)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_combat)
	(cs_go_to ps_dam/mar_01)
		(sleep 5)
	(unit_add_equipment sq_dam_joh_marines/mar_03 marine_spike TRUE TRUE)
		(sleep 5)
	(cs_face_object FALSE jail_crate02)
)

(script command_script cs_dam_chieftain
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ps_dam/chief01)
	(cs_go_to ps_dam/chief02)
)

(script static void test_dam_perspective
	(ai_erase_all)
	(player_disable_movement FALSE)
;	(sleep_until (volume_test_players tv_dam_01) 1)
	(ai_place sq_dam_arbiter)
	(ai_place sq_dam_chieftain)
	(ai_place sq_dam_joh_marines)
	(set g_dam_obj_control 1)
	(sleep 1)
	(ai_disregard (ai_actors gr_johnson_marines) TRUE)
	
	(wake vs_dam_jail_bait)
	(wake vs_dam_jail_rescue)

;	(wake 010pb_johnson_captured)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; cortana moment  
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global boolean g_pa_cortana FALSE)
(global boolean g_pa_cortana_dialogue FALSE)

;*
NOTES 
----- 
- (render_exposure -4 5) to darken the screen 
- flicker the HUD using (chud_cinematic_fade <real> <real>) 


*;
(script dormant cor_path_a
	(sleep_until (volume_test_players tv_cortana_01) 1)
	(if debug (print "cortana : path_a : crazy"))
		(set g_pa_cortana TRUE)

	; wake cortana channel script 
	(wake 010ca_sacrifice_me)
)

(script dormant md_pa_mar_chief_ok
	(sleep_until g_pa_cortana_dialogue)

	(if debug (print "cortana : path_a : marine : chief_ok"))
		; cast the actors 
		(vs_cast gr_marines TRUE 0 "010mx_060" "010mx_150")
			(set marine_01 (vs_role 1))
			(set marine_02 (vs_role 2))
		(vs_cast gr_arbiter FALSE 0 "")
			(set arbiter (vs_role 1))
		(vs_cast gr_allies FALSE 0 "" "" "")
			(set sarge (vs_role 1))
			(set marine_03 (vs_role 2))
			(set marine_04 (vs_role 3))
		
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(set g_playing_dialogue TRUE)
	(ai_dialogue_enable FALSE)

	; movement properties 
	(vs_enable_pathfinding_failsafe marine_01 TRUE)
	(vs_enable_moving marine_01 TRUE)

	; face the player 
	(vs_face_player arbiter TRUE)
	(vs_face_player sarge TRUE)
	(vs_face_player marine_01 TRUE)
	(vs_face_player marine_02 TRUE)
	(vs_face_player marine_03 TRUE)
	(vs_face_player marine_04 TRUE)
		(sleep 15)

		(if dialogue (print "MARINE: Chief? You OK?"))
		(sleep (ai_play_line marine_01 010mx_060))
		(sleep 10)

		(if dialogue (print "MARINE: Weird. Your vitals just pinged KIA..."))
		(sleep (ai_play_line marine_02 010mx_150))
		(sleep 30)

	(begin_random
		(begin
			(vs_release arbiter)
			(sleep (random_range 0 5))
		)
		(begin
			(vs_release sarge)
			(sleep (random_range 0 5))
		)
		(begin
			(vs_release marine_02)
			(sleep (random_range 0 5))
		)
		(begin
			(vs_release marine_03)
			(sleep (random_range 0 5))
		)
		(begin
			(vs_release marine_04)
			(sleep (random_range 0 5))
		)
	)
	
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; test mission_dialogue and vignettes  
; =======================================================================================================================================================================
; =======================================================================================================================================================================

(script static void cin_intro_jon_diff
(cond
	((<= (game_difficulty_get) normal) (sleep (ai_play_line_on_object (cinematic_object_get cin_johnson) 010la2_061)))
	((<= (game_difficulty_get) heroic) (sleep (ai_play_line_on_object (cinematic_object_get cin_johnson) 010la2_063)))
	((<= (game_difficulty_get) legendary) (sleep (ai_play_line_on_object (cinematic_object_get cin_johnson) 010la2_064)))
)
(sleep 15)
)
