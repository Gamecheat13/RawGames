; =======================================================================================================================================================================
; =======================================================================================================================================================================
; MUSIC 
; =======================================================================================================================================================================
; =======================================================================================================================================================================

;*
++++++++++++++++++++
MUSIC INDEX 
++++++++++++++++++++

++++++++++++++++++++
*;

(global boolean b_070_music_01 FALSE)
(global boolean b_070_music_02 FALSE)
(global boolean b_070_music_03 FALSE)
(global boolean b_070_music_04 FALSE)
(global boolean b_070_music_05 FALSE)
(global boolean b_070_music_06 FALSE)
(global boolean b_070_music_07 FALSE)
(global boolean b_070_music_08 FALSE)
(global boolean b_070_music_085 FALSE)
(global boolean b_070_music_086 FALSE)
(global boolean b_070_music_09 FALSE)
(global short s_070_music_10 0)
(global boolean b_070_music_11 FALSE)
(global boolean b_070_music_12 FALSE)
(global boolean b_070_music_13 FALSE)
(global boolean b_070_music_14 FALSE)
(global boolean b_070_music_15 FALSE)

; =======================================================================================================================================================================
;Start 070_music_01.sound_looping when entering cave to bowl 2
;Stop 070_music_01.sound_looping when hunters arrive
(script dormant 070_music_01
	(sleep_until b_070_music_01)
	(if b_debug (print "start music 070_01"))
	(sound_looping_start levels\solo\070_waste\music\070_music_01 NONE 1)

	(sleep_until (not b_070_music_01))
	(if b_debug (print "stop music 070_01"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_01)
)

; =======================================================================================================================================================================
;Start 070_music_02.sound_looping when 1st shot is fired in bowl 2
;Start_alt 070_music_02.sound_looping when hunters arrive
;Stop 070_music_02.sound_looping end hill encounter (start of Miranda's briefing)
(script dormant 070_music_02
	(sleep_until b_070_music_02)
	(if b_debug (print "start music 070_02"))
	(sound_looping_start levels\solo\070_waste\music\070_music_02 NONE 1)

	(sleep_until (not b_070_music_02))
	(if b_debug (print "stop music 070_02"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_02)
)

; =======================================================================================================================================================================
;Start 070_music_03.sound_looping when hunters arrive
;Stop 070_music_03.sound_looping both hunters dead - end encounter at bowl 2
(script dormant 070_music_03
	(sleep_until b_070_music_03)
	(if b_debug (print "start music 070_03"))
	(sound_looping_start levels\solo\070_waste\music\070_music_03 NONE 1)

	(sleep_until (not b_070_music_03))
	(if b_debug (print "stop music 070_03"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_03)
)

; =======================================================================================================================================================================
;Start 070_music_04.sound_looping when 1st hunter dead
;Stop 070_music_04.sound_looping when longsword crashes
(script dormant 070_music_04
	(sleep_until b_070_music_04 10)
	(if b_debug (print "start music 070_04"))
	(sound_looping_start levels\solo\070_waste\music\070_music_04 NONE 1)

	(sleep_until (not b_070_music_04))
	(if b_debug (print "stop music 070_04"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_04)
)

; =======================================================================================================================================================================
;Start 070_music_05.sound_looping when both hunters dead - end encounter at bowl 2
;Stop 070_music_05.sound_looping when longsword crashes
(script dormant 070_music_05
	(sleep_until b_070_music_05)
	(if b_debug (print "start music 070_05"))
	(sound_looping_start levels\solo\070_waste\music\070_music_05 NONE 1)

	(sleep_until (not b_070_music_05))
	(if b_debug (print "stop music 070_05"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_05)
)

; =======================================================================================================================================================================
;Start 070_music_06.sound_looping when you start moving in a vehicle after "all the way down this canyon"
;Stop 070_music_06.sound_looping Time out or start encounter at cave before lz, or "follow my pelican chief"
(script dormant 070_music_06
	(sleep_until b_070_music_06)
	(if b_debug (print "start music 070_06"))
	(sound_looping_start levels\solo\070_waste\music\070_music_06 NONE 1)

	(sleep_until (not b_070_music_06) 5)
	(if b_debug (print "stop music 070_06"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_06)
)

; =======================================================================================================================================================================
;Start 070_music_065.sound_looping at start lz encounter
;Stop 070_music_065.sound_looping at 1st wraith dead or progress near AA wraiths
(script dormant 070_music_065
	(sleep_until (>= s_aw_progression 20))
	(if b_debug (print "start music 070_065"))
	(sound_looping_start levels\solo\070_waste\music\070_music_065 NONE 1)

	(sleep_until 
		(or
			(>= s_aw_progression 30)
			(<= (ai_living_count cov_aw_wraith_0) 0)
			(<= (ai_living_count cov_aw_wraith_1) 0)
			(<= (ai_living_count cov_aw_wraith_2) 0)
		)
	)
	(if b_debug (print "stop music 070_065"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_065)
)

; =======================================================================================================================================================================
;Start 070_music_07.sound_looping before Johnson "commander? Bring her down! Or end of lz encounter
;Stop 070_music_07.sound_looping after Miranda "beginning my descent."
(script dormant 070_music_07
	(sleep_until b_070_music_07)
	(if b_debug (print "start music 070_07"))
	(sound_looping_start levels\solo\070_waste\music\070_music_07 NONE 1)

	(sleep_until (not b_070_music_07))
	(if b_debug (print "stop music 070_07"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_07)
)

; =======================================================================================================================================================================
;Start 070_music_08.sound_looping after Miranda "beginning my descent."
;Stop 070_music_08.sound_looping when longsword crashes
(script dormant 070_music_08
	(sleep_until b_070_music_08)
	(if b_debug (print "start music 070_08"))
	(sound_looping_start levels\solo\070_waste\music\070_music_08 NONE 1)

	(sleep_until (not b_070_music_08))
	(if b_debug (print "stop music 070_08"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_08)
)

; =======================================================================================================================================================================
;Start 070_music_085.sound_looping at Defend the Wall encounter
;Stop 070_music_085.sound_looping at end of wall encounter (before spark opens the door)
(script dormant 070_music_085
	(sleep_until 
		(or
			(volume_test_players vol_dw_turn_corner)
			(>= s_dw_progression 20)
			b_070_music_085
		)
	)
	(if b_debug (print "start music 070_085"))
	(sound_looping_start levels\solo\070_waste\music\070_music_085 NONE 1)
	(set b_070_music_085 1)

	(sleep_until 
		(or
			(not b_070_music_085)
			b_dw_combat_finished
		)
	)
	(if b_debug (print "stop music 070_085"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_085)
)

; =======================================================================================================================================================================
;Start 070_music_086.sound_looping after "…reclaimer's progress." (have your robot pick this lock)
;Stop 070_music_086.sound_looping at end of wall encounter (before spark opens the door)
(script dormant 070_music_086
	(sleep_until b_070_music_086)
	(if b_debug (print "start music 070_086"))
	(sound_looping_start levels\solo\070_waste\music\070_music_086 NONE 1)

	(sleep_until (not b_070_music_086))
	(if b_debug (print "stop music 070_086"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_086)
)

; =======================================================================================================================================================================
;Start 070_music_09.sound_looping when entering the wall
;Stop 070_music_09.sound_looping when "you got trouble"
(script dormant 070_music_09
	(sleep_until b_070_music_09)
	(if b_debug (print "start music 070_09"))
	(sound_looping_start levels\solo\070_waste\music\070_music_09 NONE 1)

	(sleep_until (not b_070_music_09))
	(if b_debug (print "stop music 070_09"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_09)
)

; =======================================================================================================================================================================
;Start 070_music_10.sound_looping when the big part of the door opens
;Start alt when 1st line clear
;Stop alt when 2nd line clear
;Start alt when scarab on its knees
;Stop 070_music_10.sound_looping scarab going to blow (before it actually explodes)
(script dormant 070_music_10
	(sleep_until (>= s_070_music_10 1) 1)
	(if b_debug (print "start music 070_10"))
	(sound_looping_start levels\solo\070_waste\music\070_music_10 NONE 1)

	;1st line Clear!
	(sleep_until (>= s_070_music_10 2) 1)
	(if b_debug (print "start alternate music 070_10"))
	(sound_looping_set_alternate levels\solo\070_waste\music\070_music_10 TRUE)
	(if b_debug (print "start music 070_101"))
	(sound_looping_start levels\solo\070_waste\music\070_music_101 NONE 1)
	
	;2nd line Clear!
	(sleep_until (>= s_070_music_10 3) 1)
	(if b_debug (print "stop alternate music 070_10"))
	(sound_looping_set_alternate levels\solo\070_waste\music\070_music_10 FALSE)
	(if b_debug (print "start music 070_102"))
	(sound_looping_start levels\solo\070_waste\music\070_music_102 NONE 1)
	(if b_debug (print "stop music 070_101"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_101)
	
	;Scarab on its knees
	(sleep_until (>= s_070_music_10 4) 1)
	(if b_debug (print "start alternate music 070_10"))
	(sound_looping_set_alternate levels\solo\070_waste\music\070_music_10 TRUE)
	(if b_debug (print "start music 070_103"))
	(sound_looping_start levels\solo\070_waste\music\070_music_103 NONE 1)
			
	;Scarab going to blow!
	(sleep_until (>= s_070_music_10 5) 1)
	(if b_debug (print "stop music 070_10"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_10)
	(if b_debug (print "stop music 070_102"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_102)
	(if b_debug (print "stop music 070_103"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_103)
)

; =======================================================================================================================================================================
;Start 070_music_11.sound_looping when the scarab actually explodes
;Stop 070_music_11.sound_looping when you reach the top and greet the pelican
(script dormant 070_music_11
	(sleep_until b_070_music_11)
	(if b_debug (print "start music 070_11"))
	(sound_looping_start levels\solo\070_waste\music\070_music_11 NONE 1)

	(sleep_until (not b_070_music_11))
	(if b_debug (print "stop music 070_11"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_11)
)

; =======================================================================================================================================================================
;Start 070_music_12.sound_looping when going thru the door after the sleeping grunt encounter
;Stop 070_music_12.sound_looping when you activate the cartographer (start 070lc)
(script dormant 070_music_12
	(sleep_until b_070_music_12)
	(if b_debug (print "start music 070_12"))
	(sound_looping_start levels\solo\070_waste\music\070_music_12 NONE 1)

	(sleep_until (not b_070_music_12))
	(if b_debug (print "stop music 070_12"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_12)
)

; =======================================================================================================================================================================
;Start 070_music_13.sound_looping when going into the room with the active cammo brutes (after 070lc)
;Stop 070_music_13.sound_looping after "hang tight chief, we're on our way" or 1st shot last encounter
(script dormant 070_music_13
	(sleep_until b_070_music_13)
	(if b_debug (print "start music 070_13"))
	(sound_looping_start levels\solo\070_waste\music\070_music_13 NONE 1)

	(sleep_until (not b_070_music_13))
	(if b_debug (print "stop music 070_13"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_13)
)

; =======================================================================================================================================================================
;Start 070_music_14.sound_looping when 1st shot last encounter
;Stop 070_music_14.sound_looping at end of last encounter (kill last brute)
(script dormant 070_music_14
	(sleep_until b_070_music_14)
	(if b_debug (print "start music 070_14"))
	(sound_looping_start levels\solo\070_waste\music\070_music_14 NONE 1)

	(sleep_until (not b_070_music_14))
	(if b_debug (print "stop music 070_14"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_14)
)

; =======================================================================================================================================================================
;Start 070_music_15.sound_looping when 1st shot last encounter (stops in cine 070ld)
;Stop 070_music_15.sound_looping when longsword crashes
(script dormant 070_music_15
	(sleep_until b_070_music_15)
	(if b_debug (print "start music 070_15"))
	(sound_looping_start levels\solo\070_waste\music\070_music_15 NONE 1)

	(sleep_until (not b_070_music_15))
	(if b_debug (print "stop music 070_15"))
	(sound_looping_stop levels\solo\070_waste\music\070_music_15)
)

; ===================================================================================================================================================
; ===================================================================================================================================================
; MISSION DIALOGUE 
; ===================================================================================================================================================
; ===================================================================================================================================================

;*
+++++++++++++++++++++++
 DIALOGUE INDEX 
+++++++++++++++++++++++
md_lz_pelican_arrives
md_lz_odst_explore
md_b1_allies_prepare
md_b1_allies_next
md_b2_allies_prepare
md_b2_allies_next
md_fp_allies_next
md_ex_marines_intro
md_ex_marines_thanks
md_sd_sentinels_intro
md_sd_sentinels_attack
md_sd_sentinels_clean
md_sd_sentinels_exit
md_sd_aa_intro
md_sd_aa_dead
md_sd_allies_next
md_ex_allies_next
md_ex_marines_cave
md_aw_aa_intro
md_aw_aa_dead
md_fl_allies_wait
md_fl_allies_come_back
md_fl_set_objective
md_fl_tank_intro
md_fl_pick_tank
md_la_tank_advance
md_la_gs_cautious
md_dw_go_to_door
md_dw_allies_next
md_lb_open_door
md_lb_gs_go_to_switch
md_lb_gs_next
md_bb_gs_battle
md_bb_marine_hop_in
md_bb_gs_next
md_bb_marine_advance_0
md_bb_marine_advance_1
md_bb_marine_phantom
md_bb_marine_infantry
md_bb_marine_advance_2
md_bb_marine_advance_3
md_bb_scarab_intro
md_bb_gs_panic
md_bb_scarab_hints
md_abb_scarab_dead
md_abb_shipmaster_reward
md_abb_jon_bring_arb
md_abb_gs_opens_door
md_abb_alies_next
md_f1_sleeping_grunts
md_f1_after_f1
md_f2_allies_explore
md_f2_gs_next
md_f3_gs_hit_switch
md_f3_arb_boards_banshee
md_f3_jon_next
md_f3_gs_secret_dialog
md_f5_jon_pelican_eta
md_flavor_mir_01
md_flavor_mir_02
md_flavor_mir_03
md_flavor_mir_04
md_flavor_mir_05
md_flavor_mir_06
md_flavor_mir_07
md_flavor_mir_08
md_flavor_mir_09
md_flavor_mir_10
md_flavor_fp_01
md_flavor_fp_02
md_flavor_fp_03
md_flavor_fp_04
md_flavor_fp_05
md_flavor_fp_06
md_flavor_fp_07
md_flavor_fp_08
md_flavor_fp_09
md_flavor_fp_10
md_flavor_sm_01
md_flavor_sm_02
md_flavor_sm_03
md_flavor_sm_04
md_flavor_sm_05
md_flavor_sm_06
md_flavor_sm_07
md_flavor_sm_08
md_flavor_sm_09
md_flavor_sm_10
md_flavor_sm_11


ba_gain_foothold
va_crashing_longsword
pa_fg_radio_bring_frigate
vb_fg_sgt_briefing
bc_wait_for_key
vc_scarab_over_wall
bd_get_inside_shaft
vd_343_door_shocker
+++++++++++++++++++++++
*;

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; chapter titles  
; =======================================================================================================================================================================
; =======================================================================================================================================================================

;Installation 00
(script dormant 070_chapter_installation	
	(chapter_start)
	(cinematic_set_title title_1)
	(cinematic_title_to_gameplay)
	
	;Give the objective to destroy the AA wraiths
	(objective_1_set)
	(cinematic_set_chud_objective obj_0)
)

;Forward unto the Dawn
(script dormant 070_chapter_forward
	;Clear the objective to destroy the AA wraiths
	(objective_1_clear)
	;Set the objective to get through the forerunner wall
	(objective_2_set)
	;Set the objective to get to the cartographer
	(objective_3_set)
	
	;Unlock that insertion point
	(game_insertion_point_unlock 1)
	
	(if (= (game_insertion_point_get) 0)
		(chapter_start)
		(sleep 30)
	)
	
	; set chapter title 
	(cinematic_set_title title_2)
	
	(if (= (game_insertion_point_get) 0)
		(begin
			(sleep 150)
			(chapter_stop)
		)
		(cinematic_title_to_gameplay)
	)
	
	(sleep_until b_fl_070bb_done 30 660)
	(cinematic_set_chud_objective obj_1)
	(sleep 360)
	(cinematic_set_chud_objective obj_2)	
)

;Real men don't need directions
(script dormant 070_chapter_real_men
	;Unlock that insertion point
	(game_insertion_point_unlock 2)
		
	(if (<= (game_insertion_point_get) 1)
		(chapter_start)
		(sleep 30)
	)
	
	; set chapter title 
	(cinematic_set_title title_3)
	
	(if (<= (game_insertion_point_get) 1)
		(begin
			(sleep 150)
			(chapter_stop)
		)
		(cinematic_title_to_gameplay)
	)
)

;Not a real chapter, but display an objective anyway
(script dormant 070_evac_objective
	;Set the objective to get to the extraction point
	(objective_4_set)
	
	(sleep_until 
		(or
			b_f3_objective_dialog_done
			(>= s_f3_p2_progression 30)
		)
	30 1800)
	(cinematic_set_chud_objective obj_3)
)

; =======================================================================================================================================================================

(global ai arbiter NONE)
(global ai elite NONE)
(global ai female_marine NONE)
(global ai guilty_spark NONE)
(global ai johnson NONE)
(global ai hocus NONE)
(global ai marine NONE)
(global ai marine_01 NONE)
(global ai marine_02 NONE)
(global ai marine_03 NONE)
(global ai marine_04 NONE)
(global ai marine_05 NONE)
(global ai marine_06 NONE)
(global ai marine_07 NONE)
(global ai marine_08 NONE)
(global ai odst NONE)
(global ai odst_01 NONE)
(global ai odst_02 NONE)
(global ai odst_03 NONE)
(global ai pilot NONE)
(global ai sergeant NONE)
(global boolean b_playing_dialogue 0)

; =======================================================================================================================================================================

(script static void md_cleanup
	(print "md_cleanup")
	(set b_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; =======================================================================================================================================================================

(script static void md_dialogue_start
	(print "md_dialogue_start")
	(set b_playing_dialogue TRUE)
	(ai_dialogue_enable FALSE)
	(sleep 15)
)

; =======================================================================================================================================================================

(script static void md_dialogue_stop
	(print "md_dialogue_stop")
	(set b_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================
(script dormant 070va_ark_arrival	
	(if b_debug (print "vignette:070VA_ARK_ARRIVAL"))
	
		; cast the actors
		(vs_cast ai_fly_johnson FALSE 10 "070VA_130")
			(set johnson (vs_role 1))
		(vs_cast ai_fly_pelican_marines_0 FALSE 10 "070MX_010")
			(set odst_01 (vs_role 1))
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	(sleep 15)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies FALSE)
	(vs_enable_targeting gr_allies FALSE)
	(vs_enable_moving gr_allies FALSE)

	(sleep 1)

		
		(if b_dialogue (print "ODST_1: That's some view..."))
		(vs_play_line odst_01 TRUE 070MX_010)
		(sleep 4)
		
		(if b_dialogue (print "JOHNSON: Enjoy it while you can, marines."))
		(vs_play_line johnson TRUE 070VA_130)
		(sleep 4)
		
		(if b_dialogue (print "JOHNSON: Soon as we land, we're right back to it!"))
		(vs_play_line johnson TRUE 070VA_135)
		(sleep 15)
		
		(if b_dialogue (print "JOHNSON: Priority one: secure a landing-zone for the Commander's frigate."))
		(vs_play_line johnson TRUE 070VA_140)
		(sleep 4)
		
		(if b_dialogue (print "JOHNSON: But keep your eyes and ears open"))
		(vs_play_line johnson TRUE 070VA_150)
		(sleep 4)
		
		(if b_dialogue (print "JOHNSON: We need all the intel we can get -- on wherever the hell we are!"))
		(vs_play_line johnson TRUE 070VA_160)
		(sleep 4)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_lz_pelican_arrives
	(sleep_until 
		(and
			b_lz_pelican_0_arrived
			(not b_playing_dialogue)
		)
	10)
	(if b_debug (print "mission dialogue:lz:pelican:arrives"))

		; cast the actors
		(vs_cast ai_fly_johnson TRUE 10 "070MA_010")
			(set johnson (vs_role 1))
		(vs_cast ai_fly_pelican_marines_0 FALSE 10 "070MA_020")
			(set odst_01 (vs_role 1))
		(vs_cast ai_fly_pelican_marines_1 FALSE 10 "070MA_020")
			(set odst_02 (vs_role 1))
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies TRUE)
	(vs_enable_targeting gr_allies TRUE)
	(vs_enable_moving gr_allies TRUE)

	(sleep 1)

		(if b_dialogue (print "JOHNSON: Stand to, Marines!"))
		(vs_play_line johnson TRUE 070MA_010)
		(sleep 10)

		(if b_dialogue (print "ODST(S): Ooh-rah!"))
		(ai_play_line odst_01 070MA_020)
		(ai_play_line odst_02 070MA_020)
		(sleep 60)
		
		(if b_dialogue (print "JOHNSON: Go! Go! Go!"))
		(vs_play_line johnson TRUE 070MA_030)
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
(global vehicle obj_lz_pelican_0 NONE)
(global vehicle obj_lz_pelican_1 NONE)

(script command_script cs_lz_pelican_0_landing
	(set obj_lz_pelican_0 (ai_vehicle_get_from_starting_location allies_lz_pelican_0/pilot))
	
	(sound_impulse_trigger sound\levels\070_waste\070va\070va_pelican_insertion NONE 1 1)

	(custom_animation_relative obj_lz_pelican_0 objects\vehicles\pelican\cinematics\vignettes\070va_pelican_intro\070va_pelican_intro "070vd_pelican_intro" FALSE cin_pelican_anchor)
	(sleep_until (not (unit_is_playing_custom_animation obj_lz_pelican_0)) 30 570)
	
	(set b_lz_pelican_0_arrived 1)
	
	(sleep_until (not (unit_is_playing_custom_animation obj_lz_pelican_0)) 1)
	(custom_animation_relative_loop obj_lz_pelican_0 objects\vehicles\pelican\cinematics\vignettes\070va_pelican_intro\070va_pelican_intro "070vd_pelican_idle" false cin_pelican_anchor)
	(sleep_forever)
)

(script command_script cs_lz_pelican_1_landing
	(set obj_lz_pelican_1 (ai_vehicle_get_from_starting_location allies_lz_pelican_1/pilot))

	(custom_animation_relative obj_lz_pelican_1 objects\vehicles\pelican\cinematics\vignettes\070va_pelican_intro\070va_pelican_intro "070vd_pelican_intro-co-op" FALSE cin_pelican_anchor_coop)
	(sleep_until (not (unit_is_playing_custom_animation obj_lz_pelican_1)) 30 690)
	
	(set b_lz_pelican_1_arrived 1)
	
	(sleep_until (not (unit_is_playing_custom_animation obj_lz_pelican_1)) 1)
	(custom_animation_relative_loop obj_lz_pelican_1 objects\vehicles\pelican\cinematics\vignettes\070va_pelican_intro\070va_pelican_intro "070vd_pelican_idle_co_op" false cin_pelican_anchor_coop)
	(sleep_forever)
)

(script dormant md_lz_exit_pelican_0
	(sleep_until b_lz_pelican_0_arrived 10 1800)
	(wake 070_chapter_installation)
	
	(sleep 90)
	(ai_vehicle_exit ai_fly_pelican_marines_0)
	(sleep 30)
	(ai_vehicle_exit ai_fly_pelican_marines_1)	
	(sleep 30)
	(unit_exit_vehicle (player0))
	(unit_exit_vehicle (player1))		
	
	;Player can now shoot and move
	(player_disable_movement false)
	(campaign_metagame_time_pause false)
	
	(sleep 30)
	
	;Create a false physic so you can't go back in the pelican
	(object_create lz_pelican_0_shunt)
			
	(sleep 90)
	
	(cs_run_command_script allies_lz_pelican_0/pilot cs_lz_pelican_0_exits)
	
	(sleep 30)
	(object_destroy lz_pelican_0_shunt)
)

(script command_script cs_lz_pelican_0_exits
	(sleep (unit_get_custom_animation_time obj_lz_pelican_0))
	(custom_animation_relative obj_lz_pelican_0 objects\vehicles\pelican\cinematics\vignettes\070va_pelican_intro\070va_pelican_intro "070vd_pelican_exit" false cin_pelican_anchor)
	(sleep_until (not (unit_is_playing_custom_animation obj_lz_pelican_0)) 30 150)
	(kill_players_in_volume vol_lz_kill_players)
	(sleep_until (not (unit_is_playing_custom_animation obj_lz_pelican_0)))
	(ai_cannot_die ai_current_actor false)
	(ai_cannot_die ai_fly_johnson false)
	(ai_erase ai_fly_johnson)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script dormant md_lz_exit_pelican_1
	(sleep_until b_lz_pelican_1_arrived 30 1800)
	(ai_vehicle_exit ai_fly_pelican_commander)
	(sleep 30)
	(ai_vehicle_exit ai_fly_pelican_marines_2)
	(sleep 30)
	(unit_exit_vehicle (player2))
	(unit_exit_vehicle (player3))
	
	(sleep 30)
	;Create a false physic so you can't go back in the pelican
	(object_create lz_pelican_1_shunt)
	
	(sleep 90)
	
	(cs_run_command_script allies_lz_pelican_1/pilot cs_lz_pelican_1_exits)
	
	(sleep 30)
	(object_destroy lz_pelican_1_shunt)
)

(script command_script cs_lz_pelican_1_exits
	(sleep (unit_get_custom_animation_time obj_lz_pelican_1))
	(custom_animation_relative obj_lz_pelican_1 objects\vehicles\pelican\cinematics\vignettes\070va_pelican_intro\070va_pelican_intro "070vd_pelican_exit_co-op" false cin_pelican_anchor_coop)
	(sleep_until (not (unit_is_playing_custom_animation obj_lz_pelican_1)) 30 210)
	(kill_players_in_volume vol_lz_kill_players)
	(sleep_until (not (unit_is_playing_custom_animation obj_lz_pelican_1)))
	(ai_cannot_die ai_current_actor false)
	(ai_erase (ai_get_squad ai_current_actor))
)

; ===================================================================================================================================================

(script dormant md_lz_odst_explore
	(if b_debug (print "mission dialogue:lz:odst:explore"))
	
	(sleep_until (>= s_lz_progression 20) 15)
	
	(sleep_until (not b_playing_dialogue))

		; cast the actors
		(vs_cast allies_lz_marines_0 TRUE 10 "070MB_090" "070MB_100")
			(set odst_01 (vs_role 1))
			(set odst_02 (vs_role 2))
			
			
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies TRUE)
	(vs_enable_targeting gr_allies TRUE)
	(vs_enable_moving gr_allies TRUE)

	(sleep 1)

		(if b_dialogue (print "ODST: Check it out. In the sky. Is that --"))
		(sleep (ai_play_line odst_01 070MB_090))

		(if b_dialogue (print "ODST: Hey. Focus. We got a job to do."))
		(sleep (ai_play_line odst_02 070MB_100))
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
(script dormant md_b1_stop_allies_prepare
	(sleep_until 
		(or
			(> (ai_combat_status cov_b1_ini) 2)
			(> (ai_combat_status cov_b1_ini_jackals_0) 2)
			(> (ai_combat_status cov_b1_ini_jackals_1) 2)
			(> (ai_combat_status cov_b1_ini_jackals_2) 2)
			(> (ai_combat_status cov_b1_ini_brutes_0) 2)
			(> (ai_combat_status cov_b1_ini_grunts_0) 2)
			(> (ai_combat_status cov_b1_watchtower) 2)
			(<= (ai_living_count cov_b1_ini) 0)
		)
	5)
	(if b_debug (print "md_b1_stop_allies_prepare"))
	
	(sleep_forever md_b1_allies_prepare)
	(cs_run_command_script allies_b1_intro_marine cs_end)
	(md_dialogue_stop)
)

(script dormant md_b1_allies_prepare	
	(vs_cast allies_b1_intro_marine FALSE 20 "070MB_110")
		(set odst_03 (vs_role 1))
		
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking odst_03 FALSE)
	(vs_enable_targeting odst_03 FALSE)
	(vs_enable_moving odst_03 FALSE)
	(vs_shoot gr_allies FALSE)
	
	(sleep 1)
	
	(vs_go_to odst_03 FALSE pts_b1_allies/p4)
	(sleep 30)
	(sleep_until (>= s_lz_progression 40) 10)
	(vs_crouch odst_03 true)
	(vs_face_player odst_03 true)
	
	(sleep_until (>= s_b1_progression 20) 10)
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	(if b_dialogue (print "ODST (whisper): Chief! Eyes on!"))
	(vs_play_line odst_03 TRUE 070MB_110)
	(vs_face_player odst_03 false)
	(vs_crouch odst_03 false)	
	
	(vs_go_to_and_posture odst_03 FALSE pts_b1_allies/p0 "corner_open_left")	
	
	(wake md_b1_stop_allies_prepare)
	
	(sleep_until (not (vs_running_atom_movement odst_03)) 30 120)
	
	(if b_dialogue (print "ODST (whisper): Got a good angle"))
	(vs_play_line odst_03 TRUE 070MB_120)
	(sleep 10)	
	
	(sleep 120)
	
	(if b_dialogue (print "ODST (whisper): You take the first shot!"))
	(vs_play_line odst_03 TRUE 070MB_140)
	(sleep 10)
	
	;Don't release anybody until the covenant get in combat
	(sleep_until 
		(or
			(> (ai_combat_status cov_b1_ini) 2)
			(> (ai_combat_status cov_b1_ini_jackals_0) 2)
			(> (ai_combat_status cov_b1_ini_jackals_1) 2)
			(> (ai_combat_status cov_b1_ini_jackals_2) 2)
			(> (ai_combat_status cov_b1_ini_brutes_0) 2)
			(> (ai_combat_status cov_b1_ini_grunts_0) 2)
			(> (ai_combat_status cov_b1_watchtower) 2)
			(<= (ai_living_count cov_b1_ini) 0)
		)
	)
	
	(vs_release_all)
)

; ===================================================================================================================================================
(global boolean b_truth_speech_finished 0)

(script dormant b1_stop_truth_halogram
	(sleep_until 
		(or
			(<= (object_get_health b1_holo_generator) 0)
			b_truth_speech_finished
		)
	10)
	(sleep_forever b1_truth_halogram)
	(sound_impulse_stop "sound\dialog\070_waste\mission\070my_060_pot.sound")
	(sound_impulse_stop "sound\dialog\070_waste\mission\070my_071_pot.sound")
)

(script dormant b1_truth_halogram
	(wake b1_stop_truth_halogram)
	
	(object_create_anew b1_truth_scenery)
	(object_create_anew b1_grav_throne)
	(object_create_anew b1_holo_generator)
	
	(object_set_function_variable b1_truth_scenery bloom 0.8 30)
	(object_set_function_variable b1_grav_throne bloom 0.8 30)
	
	(objects_attach b1_truth_scenery "driver" b1_grav_throne "driver")	
	(objects_attach b1_holo_generator "attach_marker" b1_truth_scenery "")
	
	;(objects_attach truth_biped "driver_hologram" b1_grav_throne "driver_cinematic")	
	;(objects_attach b1_holo_generator "attach_marker" truth_biped "")
	
	(sleep_until 
		(or
			(volume_test_players vol_b1_activate_halogram)
			(>= s_b2_progression 20)
		)
	)
	
	(sleep 15)
	
	(if b_dialogue (print "TRUTH: My dreadnought cannot rise! Even now it is engaged -- turns deftly in the wards of this new world!"))
	(scenery_animation_start b1_truth_scenery objects\characters\truth\cinematics\truth_holos\070_truth_a\070_truth_a.model_animation_graph "070_truth_a")
	(sound_impulse_start sound\dialog\070_waste\mission\070MY_060_pot b1_truth_scenery 1)
	(sleep (sound_impulse_language_time sound\dialog\070_waste\mission\070MY_060_pot))
	
	(sleep 30)
	
	(if b_dialogue (print "TRUTH: Do not relent until the heretics' ships are smashed!"))
	(scenery_animation_start b1_truth_scenery objects\characters\truth\cinematics\truth_holos\070_truth_a\070_truth_a.model_animation_graph "070_truth_a2")
	(sound_impulse_start sound\dialog\070_waste\mission\070MY_071_pot b1_truth_scenery 1)
	(sleep (sound_impulse_language_time sound\dialog\070_waste\mission\070MY_071_pot))
	
	(sleep 45)		
	(070_truth_flicker b1_grav_throne b1_truth_scenery)
	(object_destroy b1_truth_scenery)
	(object_destroy b1_grav_throne)
	
	(set b_truth_speech_finished 1)
)

; ===================================================================================================================================================

(script dormant md_b1_allies_next
	(vs_set_cleanup_script md_cleanup)
	
	(sleep_until 
		(and
			(or
				(>= s_b2_progression 10)
				b_b1_finished
			)
			(not b_playing_dialogue)
		)
	)
	
	(sleep_until (>= s_b2_progression 10) 30 600)
	
	;Did the player advance or did he stayed behind?
	(if 
		(and
			(< s_b2_progression 10)
			(not b_playing_dialogue)
		)
		(begin
			(if b_debug (print "mission dialogue:b1:allies:next"))
		
			; block all other mission dialogue scripts 
			(md_dialogue_start)
	
			; cast the actors
			(vs_cast allies_b1_marines_0 FALSE 10 "070MB_180")
				(set odst (vs_role 1))
			(sleep 1)
			(vs_face_player odst true)
			(if b_dialogue (print "ODST: We got more enemy contacts ahead! Move out!"))
			(vs_play_line odst TRUE 070MB_180)
			(sleep 10)
			
			; cleanup
			(md_dialogue_stop)
			(vs_release_all)
		)
	)
			
	(sleep_until (>= s_b2_progression 20) 30 1800)
	
	(if 
		(and
			(< s_b2_progression 20)
			(not b_playing_dialogue)
		)
		(begin
			; block all other mission dialogue scripts
			(md_dialogue_start)
			(if b_dialogue (print "JOHNSON (radio): Get going, Chief! Find the Commander her LZ!"))
			(sleep (ai_play_line_on_object NONE 070MB_190))
			(sleep 10)
			; cleanup
			(md_dialogue_stop)
		)
	)

	(sleep_until (>= s_b2_progression 20) 30 600)
	
	(if 
		(and
			(< s_b2_progression 20)
			(not b_playing_dialogue)
		)
		(begin
			; block all other mission dialogue scripts
			(md_dialogue_start)
			(if b_dialogue (print "JOHNSON (radio): I'm counting on you to lead the way, Chief! Move out!"))
			(sleep (ai_play_line_on_object NONE 070MB_200))
			(sleep 10)
			
			; cleanup
			(md_dialogue_stop)
			
			(hud_activate_team_nav_point_flag player flg_b1_next 0)
			
			(sleep_until (>= s_b2_progression 20) 10)
			(hud_deactivate_team_nav_point_flag player flg_b1_next)
		)
	)
)

; ===================================================================================================================================================
(script dormant md_b2_stop_allies_prepare
	;Don't release anybody until the covenant get in combat
	(sleep_until b_b2_combat_started)
	(sleep_forever md_b2_allies_prepare)
	(cs_run_command_script gr_allies cs_end)
	(md_dialogue_stop)
)

(script dormant md_b2_allies_prepare
	(sleep_until b_b1_finished)
	(wake md_b2_stop_allies_prepare)
	
	(if (> (ai_living_count allies_b1_intro_marine) 0)
		(begin
			(vs_cast allies_b1_intro_marine FALSE 10 "070MC_010")
				(set odst_01 (vs_role 1))
		)
		(begin
			(vs_cast gr_marines FALSE 10 "070MC_010")
				(set odst_01 (vs_role 1))
		)
	)
				
	(vs_enable_pathfinding_failsafe gr_marines TRUE)
	(vs_enable_looking gr_marines TRUE)
	(vs_enable_targeting gr_marines FALSE)
	(vs_enable_moving gr_marines TRUE)
	
	(vs_enable_moving odst_01 FALSE)
	
	(sleep 1)
	
	(vs_go_to_and_posture odst_01 FALSE pts_b2_allies/p7 "corner_open_left")
	
	(sleep_until
		(or
			(volume_test_players vol_b1_cave_out)
			(>= s_b2_progression 10)
		)
	10)
	
	(vs_go_to_and_posture odst_01 FALSE pts_b2_allies/p0 "corner_open_left")
	
	(sleep_until 
		(or
			(not (vs_running_atom_movement odst_01))
			(volume_test_object vol_b2_cave_1 odst_01)
		)
	)
	
	(sleep_until (>= s_b2_progression 20))
	
	(sleep_until (not b_playing_dialogue) 10)
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	(if (not b_b2_combat_started)
		(begin	
			(if b_dialogue (print "ODST (whisper): They're setting up an AA battery!"))
			(sleep (ai_play_line odst_01 070MC_010))
			(sleep 10)
		
			(if b_dialogue (print "ODST (whisper): That thing will tear the Dawn apart!"))
			(sleep (ai_play_line odst_01 070MC_020))
			(sleep 10)
		)
	)
	
	;Don't release anybody until the covenant get in combat
	(sleep_until b_b2_combat_started 30 300)
	
	(if (not b_b2_combat_started)
		(begin		
			(if b_dialogue (print "ODST (whisper): Waiting for you to take the shot!"))
			(sleep (ai_play_line odst_01 070MC_040))
			(sleep 10)
		)
	)
	
	(sleep_forever)
)

; ===================================================================================================================================================
(script dormant ba_gain_foothold
	(sleep_until 
		(or
			(and
				(>= s_b2_progression 27)
				b_b2_finished
			)
			(>= s_fp_progression 15)
		)
	)
	
	(sleep_until (>= s_b2_progression 40) 10 (random_range 90 150))
	(sleep_until (not b_playing_dialogue))
	
	;Stop 070_music_02
	(set b_070_music_02 0)
	
	(if b_b2_finished
		(begin
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
			
			(if b_debug (print "ba_gain_foothold"))
		
			(sleep 15)
		
			(if b_dialogue (print "MIRANDA : Chief, I'm giving the Brutes all I've got."))
			(sleep (ai_play_line_on_object NONE 070BA_010))
			(sleep 10)
		
			(if b_dialogue (print "MIRANDA : But this is a heavy-weight fight"))
			(sleep (ai_play_line_on_object NONE 070BA_020))
			(sleep 10)
		
			(if b_dialogue (print "MIRANDA : Dawn's only got the tonnage to last a few rounds."))
			(sleep (ai_play_line_on_object NONE 070BA_030))
			(sleep 10)
			
			(if b_dialogue (print "MIRANDA : Find me a place to set her down, over? "))
			(sleep (ai_play_line_on_object NONE 070BA_040))
			(sleep 10)
		)
	)
)

; ===================================================================================================================================================

(script dormant md_b2_allies_next
	(vs_set_cleanup_script md_cleanup)
	
	(sleep_until b_b2_finished)
	
	(sleep_until (>= s_fp_progression 15) 30 1800)
	
	;Did the player advance or did he stayed behind?
	(if 
		(and 
			(< s_fp_progression 15)
			(not b_playing_dialogue)
		)
		(begin
			; block all other mission dialogue scripts
			(md_dialogue_start)
	
			(if b_debug (print "mission dialogue:b2:allies:next"))
		
			; cast the actors
			(vs_cast gr_allies_b2_marine FALSE 10 "070MC_060")
				(set odst (vs_role 1))
			(sleep 1)
			(vs_face_player odst true)
			(if b_dialogue (print "ODST: Area secure! Let's go!"))
			(vs_play_line odst TRUE 070MC_060)
			(sleep 10)
		
			; cleanup
			(md_dialogue_stop)
			(vs_release_all)
		)
	)

	(sleep_until (>= s_fp_progression 15) 30 600)
	
	(if 
		(and
			(< s_fp_progression 15)
			(not b_playing_dialogue)
		)
		(begin
			; block all other mission dialogue scripts 
			(md_dialogue_start)
			
			(if b_dialogue (print "JOHNSON (radio): You're done here, Chief! Go, go, go!"))
			(sleep (ai_play_line_on_object NONE 070MC_070))
			(sleep 10)
			
			; cleanup
			(md_dialogue_stop)
		)
	)

	(sleep_until (>= s_fp_progression 15) 30 600)
			
	(if 
		(and 
			(< s_fp_progression 15)
			(not b_playing_dialogue)
		)
		(begin
			; block all other mission dialogue scripts 
			(md_dialogue_start)
			
			(if b_dialogue (print "JOHNSON (radio): Chief! Stay with the others! They need your help!"))
			(sleep (ai_play_line_on_object NONE 070MC_080))
			(sleep 10)
			
			; cleanup
			(md_dialogue_stop)
			
			(hud_activate_team_nav_point_flag player flg_b2_next 0)
			
			(sleep_until (>= s_fp_progression 15) 10)
			(hud_deactivate_team_nav_point_flag player flg_b2_next)
		)
	)
)

; ===================================================================================================================================================

(script dormant md_fp_allies_next
	(vs_set_cleanup_script md_cleanup)
	
	(sleep_until (>= s_ex_progression 10) 30 3600)
	(if 	(and
			(< s_ex_progression 10)
			(not b_playing_dialogue)
		)
		(begin		
			(if b_debug (print "mission dialogue:fp:allies:next"))
	
			; cast the actors
			(vs_cast gr_allies_fp_marines FALSE 10 "070MD_140")
				(set odst (vs_role 1))
			
			; movement properties
			(vs_enable_pathfinding_failsafe gr_allies TRUE)
			(vs_enable_looking gr_allies TRUE)
			(vs_enable_targeting gr_allies TRUE)
			(vs_enable_moving gr_allies TRUE)
			
			(md_dialogue_start)
			(vs_face_player odst true)
			
			(if b_dialogue (print "ODST: The Commander's counting on us to secure her LZ!"))
			(sleep (ai_play_line_at_player odst 070MD_150))
			(sleep 10)
			(vs_face_player odst false)
			
			; cleanup
			(vs_release_all)	
			
			(hud_activate_team_nav_point_flag player flg_fp_next 0)
			(sleep_until (>= s_ex_progression 10))
			(hud_deactivate_team_nav_point_flag player flg_fp_next)
		)
	)
)

; ===================================================================================================================================================
(script dormant va_crashing_longsword
	(va_crashing_longsword_static)
)

(script static void va_crashing_longsword_static
	(if b_debug (print "vignette:ex:va_crashing_longsword"))
	
	(sound_impulse_start "sound\levels\070_waste\070_longsword_crash\longsword_lead_in.sound" ex_longsword_intro_sound 1)
	(sleep 15)
	
	(md_dialogue_start)
	(if b_dialogue (print "Fighter Pilot (radio): Thrusters are gone! Can't control it! "))
	(ai_play_line_on_object NONE 070MZ_190)
	(md_dialogue_stop)
	
	(object_create cin_longsword)
	(sleep 1)
	(ai_disregard cin_longsword true)
	(scenery_animation_start_relative cin_longsword objects\vehicles\longsword\cinematics\vignettes\070vc_crashing_longsword\070vc_crashing_longsword "070vc_crashing_longsword" 070va_anchor)
	(sleep 120)
	(object_destroy cin_longsword)
	
	(player_effect_set_max_rotation 0 0.5 0.5)
	(player_effect_set_max_rumble 1 1)
	(player_effect_start 0.50 0.05)
	(sleep 20)
	(player_effect_stop 0.5)
	
	;Stop 070_music_04
	(set b_070_music_04 0)
	;Stop 070_music_05
	(set b_070_music_05 0)
)

; ===================================================================================================================================================

(script dormant md_ex_marines_intro
	(sleep_until 
		(or
			(>= (device_get_position fp_exit_door) 0.01)
			(>= s_ex_progression 10)
		)
	10)
	
	(if b_debug (print "mission dialogue:ex:marines:intro"))

	(vs_cast allies_ex_on_foot_1 TRUE 10 "070MX_060")
		(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies TRUE)
	(vs_enable_targeting gr_allies TRUE)
	(vs_enable_moving gr_allies FALSE)

	(vs_face marine true pts_ex_patrol/warthog)
	(unit_lower_weapon marine 15)
	(sleep 15)
	(vs_crouch marine true)
	(sleep 150)
	(vs_crouch marine false 2)
	(vs_face marine false pts_ex_patrol/warthog)
	(vs_approach_player marine false 3 20 20)
	
	(sleep_until (not (vs_running_atom_movement marine)) 30 90)
	(vs_face_player marine true)
	(vs_approach_stop marine)
	(vs_face_player marine true)
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

		(if b_dialogue (print "MARINE: Flak got our Pelican too, sir!"))
		(sleep (ai_play_line_at_player marine 070MX_060))
		(sleep 10)

		(if b_dialogue (print "MARINE: But before we went down, we spotted a good LZ."))
		(sleep (ai_play_line_at_player marine 070MX_070))
		(sleep 10)

		(if b_dialogue (print "MARINE: If we can get to our vehicles, we'll get you to it"))
		(sleep (ai_play_line_at_player marine 070MX_080))
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_ex_marines_thanks
	(sleep_until 
		(or
			b_ex_p1_finished
			(>= s_ex_progression 30)
		)
	10)
	
	(sleep (random_range 90 150))
	
	(sleep_until (not b_playing_dialogue) 30 300)
	
	(if 
		(and
			(< s_ex_progression 30)
			(not (player_in_a_vehicle))
		)
		(begin
			(if b_debug (print "mission dialogue:ex:marines:thanks"))
		
			(vs_cast allies_ex_on_foot_1 FALSE 10 "070MX_090")
				(set marine (vs_role 1))
		
			; movement properties
			(vs_enable_pathfinding_failsafe gr_allies TRUE)
			(vs_enable_looking gr_allies TRUE)
			(vs_enable_targeting gr_allies TRUE)
			(vs_enable_moving gr_allies TRUE)
			
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
				
				;(vs_stow marine)
				(vs_face_player marine true)
		
				(if b_dialogue (print "MARINE: Mount up! Let's find that LZ!"))
				(sleep (ai_play_line_at_player marine 070MX_090))
				(sleep 60)
		
				(if b_dialogue (print "MARINE: Follow us, sir! All the way down this canyon!"))
				(sleep (ai_play_line_at_player marine 070MX_100))
				(sleep 10)
		
			; cleanup
			(vs_release_all)
		)
	)
	
	(sleep_until
		(or
			(>= s_ex_progression 30)
			(player_in_a_vehicle)			
		)
	)
	
	;Start 070_music_06
	(set b_070_music_06 1)
)

; ===================================================================================================================================================
(script dormant md_sd_stop_sentinels_intro
	(sleep_until (>= s_aw_progression 10))
	(sleep_forever md_sd_sentinels_intro)
	(md_dialogue_stop)
)

(script dormant md_sd_sentinels_intro
	(wake md_sd_stop_sentinels_intro)
	(sleep_until (>= s_sd_progression 30) 10)
	(sleep_until b_sd_more_sentinel_spawned)
	
	(sleep (random_range 120 180))
	(sleep_until (not b_playing_dialogue))
	
	(if b_debug (print "mission dialogue:sd:sentinels:intro"))

	; cast the actors
	(if (player_in_a_vehicle_with_ai)
		(begin
			(vs_cast (get_ai_in_player_vehicle) FALSE 10 "070ME_200")
			(set marine (vs_role 1))
		)
		(begin
			(vs_cast (get_ai_not_in_vehicle gr_allies_ex) FALSE 10 "070ME_200")
			(set marine (vs_role 1))
		)
	)
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies TRUE)
	(vs_enable_targeting gr_allies TRUE)
	(vs_enable_moving gr_allies TRUE)

	(sleep 1)

		;(if b_dialogue (print "SERGEANT: Brutes must have tripped a defensive system!"))
		;(vs_play_line sergeant TRUE 070ME_200)
		;(sleep 10)
		;(if b_dialogue (print "SERGEANT: So far those things don't seem to care about us"))
		;(vs_play_line sergeant TRUE 070ME_210)
		;(sleep 10)
		;(if b_dialogue (print "SERGEANT: And I'd like to keep it that way, marines!"))
		;(vs_play_line sergeant TRUE 070ME_220)
		;(sleep 10)

		(if b_dialogue (print "MARINES: Careful, sir!  Brutes must have tripped a defensive system!"))
		(sleep (ai_play_line_at_player marine 070ME_200))
		(sleep 10)

		(if b_dialogue (print "MARINES: Whatever those things are, let's leave 'em alone!"))
		(sleep (ai_play_line_at_player marine 070ME_210))
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
(script dormant md_sd_stop_sentinels_attack
	(sleep_until b_la_can_start)
	(sleep_forever md_sd_sentinels_attack)
	(md_dialogue_stop)
)

(script dormant md_sd_sentinels_attack
	(wake md_sd_stop_sentinels_attack)
	(sleep_until b_sd_more_sentinel_spawned)
	
	(if b_debug (print "mission dialogue:sd:sentinels:attack"))

	; cast the actors
	(if (player_in_a_vehicle_with_ai)
		(begin
			(vs_cast (get_ai_in_player_vehicle) FALSE 20 "070ME_250")
			(set marine (vs_role 1))
		)
		(begin
			(vs_cast (get_ai_not_in_vehicle gr_allies_ex) FALSE 20 "070ME_250")
			(set marine (vs_role 1))
		)
	)

	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies TRUE)
	(vs_enable_targeting gr_allies TRUE)
	(vs_enable_moving gr_allies TRUE)

	(sleep 1)
	
		;DIALOG_TEMP
		;(if b_dialogue (print "SERGEANT (sarcastic): Nice work, Chief! Now they think we're the enemy!"))
		;(vs_play_line sergeant TRUE 070ME_250)
		;(sleep 10)

		(if b_dialogue (print "MARINE (sarcastic): Oh, great!  Now they think we're the enemy!"))
		(sleep (ai_play_line_at_player marine 070ME_250))
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
(global object_list ol_ex_temp_list (players))

(script dormant md_sd_stop_sentinels_clean
	(sleep_until b_la_can_start)
	(sleep_forever md_sd_sentinels_clean)
	(md_dialogue_stop)
)

(script dormant md_sd_sentinels_clean
	(wake md_sd_stop_sentinels_clean)
	(sleep_until b_sd_more_sentinel_spawned)
	(sleep_until b_sd_finished)
	(sleep 300)
	(sleep_until (volume_test_players vol_sd_bridge))	
	(sleep_until (not b_playing_dialogue))	
	
	(if (> (ai_living_count gr_for_sd) 0)
		(begin
			(if b_debug (print "mission dialogue:sd:sentinels:clean"))
		
			; cast the actors
			(if (player_in_a_vehicle_with_ai)
				(begin
					(set ol_ex_temp_list (get_ai_in_player_vehicle))
					(if (>= (list_count ol_ex_temp_list) 2)
						(begin
							(vs_cast (get_ai_in_player_vehicle) TRUE 10 "070ME_270" "070ME_280")
								(set marine_01 (vs_role 1))
								(set marine_02 (vs_role 2))
						)
						(begin
							(vs_cast (get_ai_in_player_vehicle) TRUE 10 "070ME_270")
								(set marine_01 (vs_role 1))
							(vs_cast gr_allies_ex TRUE 10 "070ME_280")
								(set marine_02 (vs_role 1))
						)
					)
				)
				(begin
					(vs_cast gr_allies_ex TRUE 10 "070ME_270" "070ME_280")
						(set marine_01 (vs_role 1))
						(set marine_02 (vs_role 2))
				)
			)
				
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
					
			; movement properties
			(vs_enable_pathfinding_failsafe gr_allies TRUE)
			(vs_enable_looking gr_allies TRUE)
			(vs_enable_targeting gr_allies TRUE)
			(vs_enable_moving gr_allies TRUE)
			
			(sleep 90)
		
				(if b_dialogue (print "MARINE: Tidy little bastards"))
				(sleep (ai_play_line_at_player marine_01 070ME_270))
				(sleep 10)
		
				(if b_dialogue (print "MARINE: Hope they never decide to clean us up."))
				(sleep (ai_play_line_at_player marine_02 070ME_280))
				(sleep 10)
		
			; cleanup
			(vs_release_all)
			
			(wake md_sd_sentinels_exit)
		)
	)

)

; ===================================================================================================================================================

(script dormant md_sd_sentinels_exit
	(sleep_until (volume_test_players vol_sd_bridge))
	(sleep_until (not b_playing_dialogue))
	
	(if b_debug (print "mission dialogue:sd:sentinels:exit"))

	; cast the actors
	(if (player_in_a_vehicle_with_ai)
		(begin
			(set ol_ex_temp_list (get_ai_in_player_vehicle))
			(if (>= (list_count ol_ex_temp_list) 2)
				(begin
					(vs_cast (get_ai_in_player_vehicle) TRUE 10 "070ME_290" "070ME_300")
						(set marine_01 (vs_role 1))
						(set marine_02 (vs_role 2))
				)
				(begin
					(vs_cast (get_ai_in_player_vehicle) TRUE 10 "070ME_290")
						(set marine_01 (vs_role 1))
					(vs_cast gr_allies_ex TRUE 10 "070ME_300")
						(set marine_02 (vs_role 1))
				)
			)
		)
		(begin
			(vs_cast gr_allies_ex TRUE 10 "070ME_290" "070ME_300")
				(set marine_01 (vs_role 1))
				(set marine_02 (vs_role 2))
		)
	)

	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies TRUE)
	(vs_enable_targeting gr_allies TRUE)
	(vs_enable_moving gr_allies TRUE)

	(sleep 1)

		(if b_dialogue (print "MARINE: It's like they don't even see us"))
		(sleep (ai_play_line_at_player marine_01 070ME_290))
		(sleep 10)

		(if b_dialogue (print "MARINE: Oh they see us, alright"))
		(sleep (ai_play_line_at_player marine_02 070ME_300))
		(sleep 10)

		(if b_dialogue (print "MARINE: They just haven't decided what to do with us yet."))
		(sleep (ai_play_line_at_player marine_02 070ME_310))
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_sd_allies_next
	(sleep_until
		(or
			(volume_test_players vol_sd_near_wall)
			b_fl_frigate_arrives
		)
	)
	
	;Place pelican only if the fight is nearly finished
	(sleep_until (<= (ai_living_count gr_cov_sd) 3) 30 3600)
	
	;Place only if players need direction
	(if 
		(and
			(not b_fl_frigate_arrives)
			(volume_test_players vol_sd_need_pelican)
		)
		(begin
			(ai_place allies_sd_pelican)
			(sleep 1)
			(ai_cannot_die allies_sd_pelican true)
			
			(sleep_until b_sd_finished 30 (* 30 20))
			
			;Stop 070_music_06
			(set b_070_music_06 0)
			
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
			
			(sleep (random_range 90 120))
			
			(vs_cast allies_sd_johnson/johnson TRUE 20 "070ME_400")
				(set johnson (vs_role 1))
			
			(if b_debug (print "mission dialogue:sd:allies:next"))
		
			(sleep 1)
		
			(if b_dialogue (print "JOHNSON (radio): Ma'am? Hocus almost got her wings shot off..."))
			(sleep (ai_play_line_at_player johnson 070ME_400))
			(sleep 10)
		
			(if b_dialogue (print "JOHNSON (radio): But we spotted a structure on the other side of this wall."))
			(sleep (ai_play_line_at_player johnson 070ME_410))
			(sleep 10)
		
			(if b_dialogue (print "JOHNSON (radio): It matches Cortana's description of the map room on the first Halo ring!"))
			(sleep (ai_play_line_at_player johnson 070ME_420))
			(sleep 10)
		
			(if b_dialogue (print "MIRANDA (radio): A cartographer? Good. Should help us fix Truth's location."))
			(sleep (ai_play_line_on_object NONE 070ME_430))
			(sleep 10)
		
			(if b_dialogue (print "MIRANDA (radio): Secure the LZ, then we'll push through that wall."))
			(sleep (ai_play_line_on_object NONE 070ME_440))
			(sleep 10)
		
			(if b_dialogue (print "JOHNSON (radio): Roger that. Follow my Pelican, Chief! LZ's this way!"))
			(sleep (ai_play_line_at_player johnson 070ME_450))
			(sleep 10)
			
			(vs_release_all)
			
			(cs_run_command_script allies_sd_johnson/johnson cs_johnson_stay_in_turret)
			
			(set b_sd_cartographer_hint 1)			
		)
	)
)

; ===================================================================================================================================================

(script dormant md_ex_allies_next
	(vs_set_cleanup_script md_cleanup)
	
	(sleep_until 
		(or
			(>= s_sd_progression 20)
			(>= s_aw_progression 10)
		)
	)
	(sleep_until 
		(or
			(>= s_aw_progression 10)
			b_sd_finished
		)
	30 7200)
	
	(sleep_until (>= s_aw_progression 10) 30 1800)
	
	(if (volume_test_players vol_sd_near_wall)
		(begin
			(sleep_until (not b_playing_dialogue) 30 450)
			
			(md_dialogue_start)
			
			;(if b_dialogue (print "JOHNSON (radio): Don't worry about that door, Chief!"))
			;(sleep (ai_play_line_on_object NONE 070MX_160))
			;(sleep 10)
	
			(if b_dialogue (print "JOHNSON (radio): Let's get the Commander down safe, then we'll worry about getting through that wall!"))
			(sleep (ai_play_line_on_object NONE 070MX_170))
			(sleep 10)
			
			(md_dialogue_stop)
		)
	)
	
	(sleep_until (>= s_aw_progression 10) 30 900)
	
	(if 
		(and
			(< s_aw_progression 10)
			(not b_playing_dialogue)
		)
		(begin
			(if b_debug (print "mission dialogue:ex:allies:next"))
		
			; cast the actors
			(if (player_in_a_vehicle_with_ai)
				(begin
					(vs_cast (get_ai_in_player_vehicle) FALSE 20 "070MF_050")
					(set marine (vs_role 1))
				)
				(begin
					(vs_cast (get_ai_not_in_vehicle gr_allies_ex) FALSE 20 "070MF_050")
					(set marine (vs_role 1))
				)
			)
			
			; block all other mission dialogue scripts
			(md_dialogue_start)
		
			; movement properties
			(vs_enable_pathfinding_failsafe gr_allies_ex TRUE)
			(vs_enable_looking gr_allies_ex TRUE)
			(vs_enable_targeting gr_allies_ex TRUE)
			(vs_enable_moving gr_allies_ex TRUE)
		
			(sleep 1)
			
				(if b_dialogue (print "MARINE: Let's find that LZ, sir!"))
				(sleep (ai_play_line_at_player marine 070MF_050))
				(sleep 10)
		
				(if b_dialogue (print "MARINE: Commander Keyes can't land until we clear those Wraiths!"))
				(sleep (ai_play_line_at_player marine 070MF_060))
				(sleep 10)
				
			; cleanup
			(md_dialogue_stop)
			(vs_release_all)				
		)
	)
	
	(sleep_until (>= s_aw_progression 10) 30 3600)
	(if 
		(and
			(< s_aw_progression 10)
			(not b_playing_dialogue)
		)
		(begin
			; block all other mission dialogue scripts 
			(md_dialogue_start)
			
			(if b_dialogue (print "JOHNSON (radio): Chief? Look for a break in the rocks!"))
			(sleep (ai_play_line_on_object NONE 070MF_010))
			(sleep 10)
	
			(if b_dialogue (print "JOHNSON (radio): There's a nice wide cliff on the other side"))
			(sleep (ai_play_line_on_object NONE 070MF_020))
			(sleep 10)
			
			(hud_activate_team_nav_point_flag player flg_ex_near_aw 0)
	
			(if b_dialogue (print "JOHNSON (radio): Should have enough room for the Dawn."))
			(sleep (ai_play_line_on_object NONE 070MF_030))
			(sleep 10)
	
			(if b_dialogue (print "JOHNSON (radio): You see any Wraiths? Clear 'em out!"))
			(sleep (ai_play_line_on_object NONE 070MF_040))
			(sleep 10)
			
			(md_dialogue_stop)
			
			(sleep_until (>= s_ex_progression 70) 10)	
			(hud_deactivate_team_nav_point_flag player flg_ex_near_aw)
		)
	)
)

; ===================================================================================================================================================

(script dormant md_ex_marines_cave
	(sleep_until 
		(or
			b_ex_cave_finished
			(>= s_aw_progression 10)
		)
	10)
	
	(sleep (random_range 60 120))
	
	(sleep_until (not b_playing_dialogue) 30 300)
	
	(if (< s_aw_progression 10)
		(begin
			(if b_debug (print "mission dialogue:ex:marines:cave"))
		
			(vs_cast gr_marines TRUE 10 "070MX_180")
				(set marine (vs_role 1))
		
			; movement properties
			(vs_enable_pathfinding_failsafe gr_allies TRUE)
			(vs_enable_looking gr_allies TRUE)
			(vs_enable_targeting gr_allies TRUE)
			(vs_enable_moving gr_allies TRUE)
			
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
				
				;(vs_stow marine)
				(vs_face_player marine true)
		
				(if b_dialogue (print "MARINE: LZ's through the cave, sir!"))
				(sleep (ai_play_line_at_player marine 070MX_180))
				(sleep 10)
		
				(if b_dialogue (print "MARINE: Watch yourself! Got Covenant heavy armor!"))
				(sleep (ai_play_line_at_player marine 070MX_185))
				(sleep 10)
		
			; cleanup
			(vs_release_all)
		)
	)
	
	(set b_ex_cave_dialog_finished 1)
)

; ===================================================================================================================================================

(script dormant md_aw_aa_intro
	(sleep_until 
		(or
			(>= s_aw_progression 20)
			(and
				(<= (ai_living_count gr_cov_aw_aa_wraiths) 0)
				(<= (ai_living_count gr_cov_aw_wraiths_mortar) 0)	
			)
		)
	)
	
	;Use this dialog only if the player isn't going for the AA wraith
	(sleep_until 
		(or
			(not (volume_test_players vol_aw_all))
			(and
				(<= (ai_living_count gr_cov_aw_aa_wraiths) 0)
				(<= (ai_living_count gr_cov_aw_wraiths_mortar) 0)	
			)
		)
	)
	
	(sleep 300)
	
	(if 
		(and
			(not (volume_test_players vol_aw_all))
			(and
				(<= (ai_living_count gr_cov_aw_aa_wraiths) 0)
				(<= (ai_living_count gr_cov_aw_wraiths_mortar) 0)	
			)
		)
		(begin
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
			
			(if b_debug (print "mission dialogue:aw:aa:intro"))
		
			; cast the actors
			;*
			(if (player_in_a_vehicle_with_ai)
				(begin
					(vs_cast (get_ai_in_player_vehicle) FALSE 20 "070MF_070")
					(set marine (vs_role 1))
					
					; movement properties
					(vs_enable_pathfinding_failsafe gr_allies TRUE)
					(vs_enable_looking gr_allies TRUE)
					(vs_enable_targeting gr_allies TRUE)
					(vs_enable_moving gr_allies TRUE)
					
					(sleep 1)
					
					(if b_dialogue (print "MARINE: There! Covenant AA!"))
					(sleep (ai_play_line_on_object marine 070MF_070))
			
					(if b_dialogue (print "MARINE: Let's take it out!"))
					(sleep (ai_play_line_on_object marine 070MF_080))
					
					; cleanup
					(vs_release_all)								
				)
				(begin*;
					(if b_dialogue (print "JOHNSON (radio): Chief, you got Covenant AA!"))
					(sleep (ai_play_line_on_object NONE 070MF_130))
					(sleep 10)
			
					(if b_dialogue (print "JOHNSON (radio): Take it out!"))
					(sleep (ai_play_line_on_object NONE 070MF_140))
					(sleep 10)
					
					(hud_activate_team_nav_point_flag player flg_fl_frigate_landing 0)
					(sleep_until 
						(or
							(volume_test_players vol_aw_pass_bridge)
							(and
								(<= (ai_living_count gr_cov_aw_aa_wraiths) 0)
								(<= (ai_living_count gr_cov_aw_wraiths_mortar) 0)	
							)
						)
					10)
					(hud_deactivate_team_nav_point_flag player flg_fl_frigate_landing)
				;)
			;)
		)
	)
)

(script dormant md_aw_aa_dead
	(sleep_until (>= s_aw_progression 10))
	(sleep_until (<= (ai_living_count gr_cov_aw) 1))
	(sleep_until (<= (ai_living_count gr_cov_aw) 0) 30 600)
	(sleep (random_range 60 120))
	
	(sleep_until (not b_playing_dialogue) 30 600)
	
	(if (not 070pa_dialog_done)
		(begin
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
			
			(if b_debug (print "mission dialogue:aw:aa:intro"))
			; cast the actors
			(if (player_in_a_vehicle_with_ai)
				(begin
					(vs_cast (get_ai_in_player_vehicle) FALSE 20 "070MF_120")
					(set marine (vs_role 1))
					
					; movement properties
					(vs_enable_pathfinding_failsafe gr_allies TRUE)
					(vs_enable_looking gr_allies TRUE)
					(vs_enable_targeting gr_allies TRUE)
					(vs_enable_moving gr_allies TRUE)
					
					(sleep 1)
					
					(if b_dialogue (print "MARINE: Ooh-rah! The LZ's clear!"))
					(sleep (ai_play_line_at_player marine 070MF_120))
					(sleep 10)
					
					; cleanup
					(vs_release_all)								
				)
				(begin
					(if b_dialogue (print "JOHNSON (radio): That did it! LZ's clear!"))
					(sleep (ai_play_line_on_object NONE 070MF_180))
					(sleep 10)
				)
			)
		)
	)
)

; ===================================================================================================================================================

(script dormant md_fl_allies_wait
	(sleep 60)
	(sleep_until 070pa_dialog_done)
	
	(sleep_until
		(or
			(<= s_fl_position 10)
			b_fl_frigate_arrives
		)
	)
	
	(if (not b_fl_frigate_arrives)
		(begin
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
			
			(if b_debug (print "mission dialogue:fl:allies:wait"))
		
			; cast the actors
			(if (player_in_a_vehicle_with_ai)
				(begin
					(vs_cast (get_ai_in_player_vehicle) FALSE 20 "070MF_190")
					(set marine (vs_role 1))
					
					; movement properties
					(vs_enable_pathfinding_failsafe gr_allies TRUE)
					(vs_enable_looking gr_allies TRUE)
					(vs_enable_targeting gr_allies TRUE)
					(vs_enable_moving gr_allies TRUE)
					
					(sleep 1)
					
					(if b_dialogue (print "MARINE: Hold here for the Dawn, sir!"))
					(sleep (ai_play_line_at_player marine 070MF_190))
					(sleep 10)
					
					; cleanup
					(vs_release_all)								
				)
				(begin
					(vs_cast ai_fl_johnson TRUE 10 "070MF_200")
						(set johnson (vs_role 1))
					
					(if b_dialogue (print "JOHNSON (radio): Hang on, Chief! Wait for the Commander to land!"))
					(sleep (ai_play_line johnson 070MF_200))
					(sleep 10)
					
					(cs_run_command_script allies_fl_johnson/johnson cs_johnson_stay_in_turret)
				)
			)
		)
	)
)

; ===================================================================================================================================================

(script dormant md_fl_allies_come_back
	(if b_debug (print "mission dialogue:fl:allies:come:back"))
	
	(sleep_until (volume_test_players vol_fl_up) 30 900)
	
	(if (not (volume_test_players vol_fl_up))
		(begin
			(vs_cast ai_fl_johnson TRUE 10 "070MF_230")
				(set johnson (vs_role 1))
			
			; block all other mission dialogue scripts 
			(md_dialogue_start)
			
			(if b_dialogue (print "JOHNSON (radio): Chief! Double-time it back to my Pelican!"))
			(sleep (ai_play_line johnson 070MF_230))
			(sleep 10)
	
			(if b_dialogue (print "JOHNSON (re Tanks): Let's see what the Commander's got for us!"))
			(sleep (ai_play_line johnson 070MF_240))
			(sleep 10)
			
			(cs_run_command_script allies_fl_johnson/johnson cs_johnson_stay_in_turret)
		)
	)
)

; ===================================================================================================================================================

(script dormant 070pa_dialog
	(sleep_until (not b_playing_dialogue) 30 90)
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	(if b_debug (print "Perspective:fl:070pa:dialog"))
	
	(if b_dialogue (print "JOHNSON (radio): Commander? Bring her down!"))
	(sleep (ai_play_line_on_object NONE 070pa_010))
	(sleep 30)
	
	(if b_dialogue (print "MIRANDA (radio): Roger that. Beginning my descent..."))
	(sleep (ai_play_line_on_object NONE 070pa_020))
	(sleep 30)	
	
	(set 070pa_dialog_done 1)
	
	(sleep_until b_fl_frigate_arrives)
	
	; cast the actors
	(if (player_in_a_vehicle_with_ai)
		(begin
			(set ol_ex_temp_list (get_ai_in_player_vehicle))
			(if (>= (list_count ol_ex_temp_list) 2)
				(begin
					(vs_cast (get_ai_in_player_vehicle) TRUE 10 "070MX_015" "070MX_020")
						(set marine_01 (vs_role 1))
						(set marine_02 (vs_role 2))
				)
				(begin
					(vs_cast (get_ai_in_player_vehicle) TRUE 10 "070MX_015")
						(set marine_01 (vs_role 1))
					(vs_cast gr_allies_before_fl TRUE 10 "070MX_020")
						(set marine_02 (vs_role 1))
				)
			)
		)
		(begin
			(vs_cast gr_allies_before_fl TRUE 10 "070MX_015" "070MX_020")
				(set marine_01 (vs_role 1))
				(set marine_02 (vs_role 2))
		)
	)

	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies TRUE)
	(vs_enable_targeting gr_allies TRUE)
	(vs_enable_moving gr_allies TRUE)

	(sleep 1)

		(if b_dialogue (print "MARINE: Look! Up high! Here she comes!"))
		(sleep (ai_play_line_at_player marine_01 070MX_015))
		(sleep 10)

		(if b_dialogue (print "MARINE: Is the Dawn rated for atmosphere?"))
		(sleep (ai_play_line_at_player marine_02 070MX_020))
		(sleep 10)

		(if b_dialogue (print "MARINE: Guess we're gonna find out! Take cover!"))
		(sleep (ai_play_line_at_player marine_01 070MX_030))
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_fl_set_objective
	(sleep_until 070pa_dialog_done)
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	(if b_debug (print "mission dialogue:fl:set:objective"))
	
	(vs_cast ai_fl_johnson TRUE 20 "070MF_260")
		(set johnson (vs_role 1))
		
	(sleep 1)
	(vs_enable_looking ai_fl_johnson false)
	(vs_enable_moving ai_fl_johnson false)
	(vs_enable_targeting ai_fl_johnson false)
	
	(if b_dialogue (print "MIRANDA (radio): Thanks, Chief. Wouldn't have lasted much longer up there."))
	(sleep (ai_play_line_on_object NONE 070pa_040))
	(sleep 10)
	
	(if b_dialogue (print "MIRANDA (radio): Come to the back of the frigate"))
	(sleep (ai_play_line_on_object NONE 070MF_210))
	(sleep 45)
	
	(if b_sd_cartographer_hint
		(begin
			(if b_dialogue (print "MIRANDA (radio): Did the Elites get a fix on the Cartographer?"))
			(sleep (ai_play_line_on_object NONE 070MF_250))
			(sleep 10)
		
			(if b_dialogue (print "JOHNSON (radio): Yes, ma'am. Just on the other side of the wall"))
			(sleep (ai_play_line johnson 070MF_260))
			(sleep 10)
		)
		(begin
			(if b_dialogue (print "MIRANDA (radio): Johnson? Have the Elites found anything?"))
			(sleep (ai_play_line_on_object NONE 070MF_270))
			(sleep 10)
		
			(if b_dialogue (print "JOHNSON (radio): A structure on the other side of the wall, ma'am"))
			(sleep (ai_play_line johnson 070MF_280))
			(sleep 10)
		
			;(if b_dialogue (print "JOHNSON (radio): Matches Cortana's description of the Cartographer on the first Halo."))
			;(sleep (ai_play_line_on_object NONE 070MF_290))
			;(sleep 10)
		
			;(if b_dialogue (print "JOHNSON (radio): It should help us pinpoint Truth's location."))
			;(sleep (ai_play_line_on_object NONE 070MF_300))
			;(sleep 10)
		
		)
	)
	(if b_dialogue (print "JOHNSON (radio): But it's surrounded by Brute heavy armor."))
	(sleep (ai_play_line johnson 070MF_310))
	(sleep 10)

	;(if b_dialogue (print "JOHNSON (radio): Hocus did a recon pass. Nearly got our wings blown off."))
	;(sleep (ai_play_line_on_object NONE 070MF_320))
	;(sleep 10)

	(if b_dialogue (print "MIRANDA (radio): Don't worry. I've got a plan."))
	(sleep (ai_play_line_on_object NONE 070MF_330))
	
	(set b_fl_briefing_finished 1)
	
	(cs_run_command_script allies_fl_johnson/johnson cs_johnson_stay_in_turret)
)

; ===================================================================================================================================================
(script dormant 070bb_dialog
	(sleep_until b_fl_briefing_finished 15 2400)
	(sleep (random_range 30 45))
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	(if b_debug (print "Perspective:fl:070bb:dialog"))
	
	(vs_cast gr_guilty_spark FALSE 10 "070MF_340")
		(set guilty_spark (vs_role 1))
	
	(if (< g_insertion_index 9)
		(begin
			(vs_cast ai_fl_johnson TRUE 20 "070MF_360")
				(set johnson (vs_role 1))
		)
	)
		
	(vs_enable_moving gr_guilty_spark TRUE)
	(vs_enable_pathfinding_failsafe gr_guilty_spark TRUE)
	(vs_enable_looking gr_guilty_spark TRUE)
	(vs_enable_targeting gr_guilty_spark TRUE)		
	
	(sleep 1)
	
	(if b_dialogue (print "MIRANDA (radio): If we can't fly over the wall? We'll go right through it."))
	(sleep (ai_play_line_on_object NONE 070bb_010))
	(sleep 10)
	
	(if b_dialogue (print "MIRANDA (radio): Chief, take one of the tanks. Lead the way."))
	(sleep (ai_play_line_on_object NONE 070bb_020))
	(sleep 10)
	
	(set b_fl_070bb_done 1)
	
	(if b_dialogue (print "MIRANDA (radio): You find any locked doors? Spark will be happy to pry them open."))
	(sleep (ai_play_line_on_object NONE 070bb_030))
	(sleep 10)
	
	(if b_dialogue (print "GUILTY: I will certainly try my best"))
	(sleep (ai_play_line_on_object guilty_spark 070MF_340))
	(sleep 10)
		
	(if b_dialogue (print "GUILTY: Though I am unfamiliar with this facility."))
	(sleep (ai_play_line_on_object guilty_spark 070MF_350))
	(sleep 10)
	
	(if b_dialogue (print "JOHNSON (radio): Alright then. You heard the lady"))
	(if (< g_insertion_index 9)
		(sleep (ai_play_line johnson 070MF_360))
		(sleep (ai_play_line_on_object NONE 070MF_360))
	)
	(sleep 10)
	
	(set b_070_music_08 TRUE)
	
	(md_dialogue_stop)
	
	(cs_run_command_script allies_fl_johnson/johnson cs_johnson_stay_in_turret)
)

; ===================================================================================================================================================
(global ai md_fl_cheer_marine_0 NONE)
(global ai md_fl_cheer_marine_1 NONE)
(global ai md_fl_cheer_marine_2 NONE)
(global ai md_fl_cheer_marine_3 NONE)
(global ai md_fl_cheer_marine_4 NONE)
(global ai md_fl_cheer_marine_5 NONE)
(global ai md_fl_cheer_marine_6 NONE)
(global ai md_fl_cheer_marine_7 NONE)
(global ai md_fl_cheer_marine_8 NONE)

(script dormant md_fl_marine_tank_intro
	(sleep_until b_fl_frigate_unloading)
	(if b_debug (print "mission dialogue:fg:marine:tank:intro"))

		; cast the actors			
		(vs_cast allies_fl_warthog/driver FALSE 20 "")
			(set marine (vs_role 1))		
		(vs_cast allies_fl_scorpion_0/driver FALSE 20 "")
			(set marine_01 (vs_role 1))
		(vs_cast allies_fl_scorpion_1/driver FALSE 20 "")
			(set marine_02 (vs_role 1))
		(vs_cast allies_fl_scorpion_2/driver FALSE 20 "")
			(set marine_03 (vs_role 1))		
		
		(vs_cast gr_allies_la_scorpions FALSE 10 "070MF_380")
			(set md_fl_cheer_marine_0 (vs_role 1))
			(set md_fl_cheer_marine_1 (vs_role 2))
			(set md_fl_cheer_marine_2 (vs_role 3))
			(set md_fl_cheer_marine_3 (vs_role 4))
			(set md_fl_cheer_marine_4 (vs_role 5))
		(vs_cast gr_allies_fl FALSE 10 "070MF_380")
			(set md_fl_cheer_marine_5 (vs_role 1))
			(set md_fl_cheer_marine_6 (vs_role 2))
			(set md_fl_cheer_marine_7 (vs_role 3))
			(set md_fl_cheer_marine_8 (vs_role 4))

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies TRUE)
	(vs_enable_targeting gr_allies TRUE)
	(vs_enable_moving marine FALSE)
	(vs_enable_moving marine_01 FALSE)
	(vs_enable_moving marine_02 FALSE)
	(vs_enable_moving marine_03 FALSE)

	(sleep 1)
	
	(sleep_until b_fl_070bb_done)
	
	(sleep_until (volume_test_object vol_fl_tanks_on_ground allies_fl_scorpion_0/driver) 30 900)
	
	(vs_move_in_direction marine_01 FALSE 0 5 0)
	(sleep 15)
	(vs_move_in_direction marine_02 FALSE 180 4 0)
	(sleep 30)
	(vs_move_in_direction marine_03 FALSE 0 5 0)
	(sleep 15)
	(vs_move_in_direction marine FALSE 0 5 0)

	(sleep_until (not (volume_test_object vol_fl_tanks_on_ground allies_fl_scorpion_0/driver)) 30 300)
	(sleep 60)
	(set b_fl_tanks_available 1)
	
	(vs_enable_moving marine true)
	(vs_enable_moving marine_02 true)
	(vs_enable_moving marine_03 true)
	(vs_enable_moving marine_01 true)
	
	(ai_vehicle_reserve_seat obj_fl_scorpion_0 "scorpion_d" true)
	(ai_vehicle_exit marine_01)
	
	(wake md_fl_pick_tank)
	
	(sleep_until b_fl_chief_in_vehicle)
	(sleep_until (not b_playing_dialogue))
	
	(if (< g_insertion_index 9)
		(begin
			(vs_cast ai_fl_johnson TRUE 20 "070MF_370")
				(set johnson (vs_role 1))	
		)
	)
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	(sleep 60)
	
	(if b_dialogue (print "JOHNSON (radio): Mount up! Let's roll!"))
	(if (< g_insertion_index 9)
		(sleep (ai_play_line johnson 070MF_370))
		(sleep (ai_play_line_on_object NONE 070MF_370))
	)
	(sleep 10)	

	(if b_dialogue (print "MARINES: (various) Ooh-rah! Alright! Get some!"))
	(vs_play_line md_fl_cheer_marine_0 FALSE 070MF_380)
	(sleep 10)
	(vs_play_line md_fl_cheer_marine_1 FALSE 070MF_380)
	(vs_play_line md_fl_cheer_marine_2 FALSE 070MF_380)
	(vs_play_line md_fl_cheer_marine_3 FALSE 070MF_380)
	(sleep 10)
	(vs_play_line md_fl_cheer_marine_4 FALSE 070MF_380)
	(vs_play_line md_fl_cheer_marine_5 FALSE 070MF_380)
	(vs_play_line md_fl_cheer_marine_6 FALSE 070MF_380)
	(sleep 10)
	(vs_play_line md_fl_cheer_marine_7 FALSE 070MF_380)
	(vs_play_line md_fl_cheer_marine_8 FALSE 070MF_380)
	(sleep 120)

	(if (>= (game_difficulty_get) legendary)
		(begin
			(if b_dialogue (print "MARINES: (Hum/sing 'Flight of the Valkyries')"))
			(vs_play_line marine_03 TRUE 070MF_390)
			(sleep 10)
		)
	)

	; cleanup
	(vs_release_all)
	
	(cs_run_command_script allies_fl_johnson/johnson cs_johnson_stay_in_turret)
)

; ===================================================================================================================================================
(script dormant md_fl_stop_pick_tank
	(sleep_until b_fl_chief_in_vehicle)

	(sleep_forever md_fl_pick_tank)
	
	;Have GS guide you with exterior distance values
	(set s_gs_walkup_dist 5)
	(set s_gs_talking_dist 7)
	(set g_gs_1st_line 070MH_450)
	(set g_gs_2nd_line 070MK_150)
	(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
)

(script dormant md_fl_pick_tank
	(wake md_fl_stop_pick_tank)
	(sleep_until (not b_playing_dialogue))
	
	(if b_debug (print "mission dialogue:fl:pick:tank"))

	; cast the actors
	(vs_cast gr_guilty_spark TRUE 10 "070MF_400")
		(set guilty_spark (vs_role 1))
	(vs_cast ai_fl_johnson TRUE 20 "070MF_430")
		(set johnson (vs_role 1))
			
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_guilty_spark TRUE)
	(vs_enable_looking gr_guilty_spark TRUE)
	(vs_enable_targeting gr_guilty_spark TRUE)
	(vs_enable_moving gr_guilty_spark TRUE)

	(sleep 1)

		(if b_dialogue (print "GUILTY: Shall I help you choose a vehicle, Reclaimer?"))
		(sleep (ai_play_line_on_object guilty_spark 070MF_400))
		(sleep 10)

		(if b_dialogue (print "GUILTY: This one seems in very good condition"))
		(sleep (ai_play_line_on_object guilty_spark 070MF_410))
		(sleep 10)

		(if b_dialogue (print "GUILTY: Primitive armament notwithstanding."))
		(sleep (ai_play_line_on_object guilty_spark 070MF_420))
		(sleep 10)
		
		(if b_dialogue (print "JOHNSON (radio): Tank's a tank, light bulb."))
		(sleep (ai_play_line johnson 070MF_430))
		(sleep 10)

		(if b_dialogue (print "JOHNSON (radio): Pick one, Chief! Get back to the wall!"))
		(sleep (ai_play_line johnson 070MF_440))
		(sleep 10)

		(if b_dialogue (print "JOHNSON (radio): I'll help the Commander secure the Dawn"))
		(sleep (ai_play_line johnson 070MF_450))
		(sleep 10)

		(if b_dialogue (print "JOHNSON (radio): Then we'll meet you at the Cartographer!"))
		(sleep (ai_play_line johnson 070MF_460))
		(sleep 10)	

	; cleanup
	(vs_release_all)
	
	(cs_run_command_script allies_fl_johnson/johnson cs_johnson_stay_in_turret)
)

; ===================================================================================================================================================

(script dormant 070pa_start
	;*(perspective_start)
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 2)
	(cinematic_show_letterbox_immediate TRUE)
	(070pa_frigate_lands)
	(fl_create_frigate)
	(cinematic_stop)
	(camera_control off)
	(perspective_stop)*;
	
	(fl_create_frigate)
	(object_cinematic_visibility fl_frigate_scenery true)
	(scenery_animation_start fl_frigate_scenery "objects\cinematics\human\frigate\frigate\cinematics\perspectives\070pa_frigate_lands\070pa_frigate_lands" "070pa_cin_frigate_1")
	
	;Create two sounds - one for the frigate itself, the other one to predict the frigate arrival
	(sound_impulse_start "sound\levels\070_waste\070_frigate_landing\070_frigate_landing.sound" fl_frigate_sound_start 1)
	
	(objects_attach fl_frigate_scenery marker_backelevator02 fl_frigate_sound "")
	(sound_looping_start "sound\levels\070_waste\070_frigate_landing\frigate_loop\frigate_loop.sound_looping" fl_frigate_sound 1.0)
	
	(sleep (min (scenery_get_animation_time fl_frigate_scenery) 900))
	(fl_replace_elevators)
)

(script command_script cs_fl_get_to_briefing	
	(cs_enable_moving true)
	(cs_enable_looking true)
	(sleep_until 
		(or
			(and
				(volume_test_object vol_aw_pass_bridge ai_current_actor)
				(not (any_players_in_vehicle))
			)
			(>= s_la_progression 10)
		)
	15 1800)
	(sleep_until 
		(or
			(and
				(volume_test_object vol_aw_all ai_current_actor)
				(not (any_players_in_vehicle))
			)
			(>= s_la_progression 10)
		)
	15)
	
	(if (not (any_players_in_vehicle))	
		(unit_exit_vehicle ai_current_actor)
	)
	(sleep_until 
		(or
			(volume_test_object vol_fl_sgt_briefing ai_current_actor)
			(>= s_la_progression 10)
		)
	30 1800)
	(cs_movement_mode ai_movement_patrol)
	(sleep 150)
	(cs_stow)
	(cs_posture_set "patrol:unarmed:look" true)
	(cs_enable_moving false)
	(cs_face true pts_fl_sgt_briefing/face_0)
	(cs_draw)
	(sleep_until b_fl_tanks_available 30 3600)
	(sleep (random_range 0 60))
)

(script dormant fl_stop_briefing
	(sleep_until b_fl_pelican_unloaded)
	(sleep_forever vb_fg_sgt_briefing)
	(cs_run_command_script allies_fl_pelican_marines cs_draw_weapon)
	(ai_enter_squad_vehicles allies_fl_pelican_marines)
)

(script dormant vb_fg_sgt_briefing
	(sleep_until b_fl_pelican_arrived)
	
	(if b_debug (print "vb:fg:marine:briefing"))

	; cast the actors			
	;(vs_cast ai_fl_sergeant FALSE 10 "070VB_010")
	(vs_cast ai_fl_sergeant FALSE 10 "")
		(set sergeant (vs_role 1))
	;(vs_cast ai_fl_pelican_marines_0 FALSE 10 "070VB_040")
	(vs_cast ai_fl_pelican_marines_0 FALSE 10 "")
		(set marine_05 (vs_role 1))
	;(vs_cast ai_fl_pelican_marines_1 FALSE 10 "070VB_110")
	(vs_cast ai_fl_pelican_marines_1 FALSE 10 "")
		(set marine_06 (vs_role 1))
	(vs_cast ai_fl_pelican_marines_2 FALSE 10 "")
		(set marine_07 (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe allies_fl_pelican_marines TRUE)
	(vs_enable_looking allies_fl_pelican_marines TRUE)
	(vs_enable_targeting allies_fl_pelican_marines TRUE)
	;(vs_enable_moving allies_fl_pelican_marines TRUE)
	(vs_movement_mode sergeant ai_movement_patrol)
	(vs_movement_mode marine_05 ai_movement_patrol)
	(vs_movement_mode marine_06 ai_movement_patrol)
	(vs_movement_mode marine_07 ai_movement_patrol)
	
	(ai_vehicle_exit sergeant)
	(sleep 90)
	(vs_go_to_and_face sergeant FALSE pts_fl_sgt_briefing/sgt_p0 pts_fl_sgt_briefing/sgt_face_0)
	(ai_vehicle_exit marine_05)
	(sleep 90)
	(vs_go_to_and_face marine_05 FALSE pts_fl_sgt_briefing/p2 pts_fl_sgt_briefing/face_0)
	(ai_vehicle_exit marine_06)
	(sleep 90)
	(vs_go_to_and_face marine_06 FALSE pts_fl_sgt_briefing/p1 pts_fl_sgt_briefing/face_0)
	(ai_vehicle_exit marine_07)
	(sleep 90)
	(set b_fl_pelican_unloaded 1)
	(vs_go_to_and_face marine_07 TRUE pts_fl_sgt_briefing/p0 pts_fl_sgt_briefing/face_0)
	(cs_run_command_script allies_fl_pelican/pilot cs_fl_pelican_exits)
		
		(vs_stow sergeant)
		(sleep 60)
		(vs_face marine_05 true pts_fl_sgt_briefing/face_0)		
		(vs_stow marine_05)
		(sleep 7)
		(vs_stow marine_07)
		(vs_face marine_07 true pts_fl_sgt_briefing/face_0)
		(sleep 7)
		(vs_stow marine_06)
		(vs_face marine_06 true pts_fl_sgt_briefing/face_0)
		(sleep 10)

		(sleep 60)
		(sleep 10)

		(vs_go_to_and_face sergeant TRUE pts_fl_sgt_briefing/sgt_p1 pts_fl_sgt_briefing/sgt_face_1)
		(vs_face sergeant true pts_fl_sgt_briefing/sgt_face_1)
		;(vs_face sergeant true pts_fl_sgt_briefing/sgt_face_0)
		(sleep 60)
		(sleep 10)

		(sleep 60)
		(sleep 10)
		
		(vs_go_to_and_face sergeant false pts_fl_sgt_briefing/sgt_p0 pts_fl_sgt_briefing/sgt_face_0)
		(vs_face sergeant true pts_fl_sgt_briefing/sgt_face_0)

		(sleep 60)
		(sleep 10)
		(vs_go_to_and_face sergeant false pts_fl_sgt_briefing/sgt_p1 pts_fl_sgt_briefing/sgt_face_1)
		(vs_face sergeant true pts_fl_sgt_briefing/sgt_face_1)
	
	(sleep_forever)
)

; ===================================================================================================================================================
(script static boolean la_tank_living
	(or
		(> (unit_get_health (ai_vehicle_get_from_starting_location allies_la_scorpion_0/driver)) 0)
		(> (unit_get_health (ai_vehicle_get_from_starting_location allies_la_scorpion_1/driver)) 0)
		(> (unit_get_health (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank)) 0)
	)
)

(script dormant md_la_stop_tank_advance
	(sleep_until 
		(or 
			(>= s_dw_progression 10)
			(not (la_tank_living))
		)
	)
	(sleep_forever md_la_tank_advance)
	(cs_run_command_script gr_allies_la_scorpions cs_end)
	(md_dialogue_stop)
)

(script dormant md_la_tank_advance
	(wake md_la_stop_tank_advance)
	(sleep_until (<= (ai_living_count gr_cov_la_p1_ghosts) 3))
	(sleep_until (not b_playing_dialogue))

	(if b_debug (print "mission dialogue:la:tank:advance:0"))

		; cast the actors
		(vs_cast gr_allies_la_scorpions FALSE 10 "070MG_010")
			(set sergeant (vs_role 1))
			
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies_la_scorpions TRUE)
	(vs_enable_looking gr_allies_la_scorpions TRUE)
	(vs_enable_targeting gr_allies_la_scorpions TRUE)
	(vs_enable_moving gr_allies_la_scorpions TRUE)

	(sleep 1)

		(if b_dialogue (print "SERGEANT (radio, over tank): Ha!  How does 90 millimeters of tungsten strike you?"))
		;DIALOG_TEMP how are we doing radio 3D for tanks?
		;(vs_play_line sergeant TRUE 070MG_010)
		(sleep (ai_play_line_on_object NONE 070MG_010))
		(sleep 10)

	; cleanup
	(md_dialogue_stop)
	(vs_release_all)
	
	(sleep_until (<= (ai_living_count gr_cov_la_p1_ghosts) 1) 30 1800)
	(sleep_until (<= (ai_living_count gr_cov_la_p1_ghosts) 0) 30 150)
	(sleep_until (not b_playing_dialogue))
	
	(if (<= (ai_living_count gr_cov_la_p1_ghosts) 1)
		(begin
			(if b_debug (print "mission dialogue:la:tank:advance:1"))
		
				; cast the actors
				(vs_cast gr_allies_la_scorpions FALSE 10 "070MG_020")
					(set marine (vs_role 1))
		
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
		
			; movement properties
			(vs_enable_pathfinding_failsafe gr_allies_la_scorpions TRUE)
			(vs_enable_looking gr_allies_la_scorpions TRUE)
			(vs_enable_targeting gr_allies_la_scorpions TRUE)
			(vs_enable_moving gr_allies_la_scorpions TRUE)
		
			(sleep 30)
		
				(if b_dialogue (print "MARINE (radio, over tank): Tank beats Ghost!"))
				(sleep (ai_play_line_on_object NONE 070MG_020))
				;(vs_play_line marine TRUE 070MG_020)
				(sleep 10)
		
			; cleanup
			(md_dialogue_stop)
			(vs_release_all)
		)
	)
	
	(sleep_until (>= s_la_progression 22))
	(sleep 60)
	
	(sleep_until
		(or
			(<= (ai_living_count cov_la_p1_hunters) 0)
			(>= s_la_progression 35)
		)
	30 1800)
	(sleep_until (not b_playing_dialogue))
	
	(if (<= (ai_living_count cov_la_p1_hunters) 0)
		(begin
			(if b_debug (print "mission dialogue:la:tank:advance:2"))
		
				; cast the actors
				(vs_cast gr_allies_la_scorpions FALSE 10 "070MG_030")
					(set marine (vs_role 1))
		
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
		
			; movement properties
			(vs_enable_pathfinding_failsafe gr_allies_la_scorpions TRUE)
			(vs_enable_looking gr_allies_la_scorpions TRUE)
			(vs_enable_targeting gr_allies_la_scorpions TRUE)
			(vs_enable_moving gr_allies_la_scorpions TRUE)
		
			(sleep 30)
		
				(if b_dialogue (print "MARINE (radio, over tank): Tank beats Hunter!"))
				(sleep (ai_play_line_on_object NONE 070MG_030))
				;(vs_play_line marine TRUE 070MG_030)
				(sleep 10)
		
			; cleanup
			(md_dialogue_stop)
			(vs_release_all)
		)
	)
	
	(sleep_until (>= s_la_progression 30))
	(sleep 60)
	(sleep_until (<= (ai_living_count cov_la_p2_1st_tower) 1))
	(sleep_until (not b_playing_dialogue))
	
	(if b_debug (print "mission dialogue:la:tank:advance:3"))

		; cast the actors
		(vs_cast gr_allies_la_scorpions FALSE 10 "070MG_040")
			(set marine (vs_role 1))

	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies_la_scorpions TRUE)
	(vs_enable_looking gr_allies_la_scorpions TRUE)
	(vs_enable_targeting gr_allies_la_scorpions TRUE)
	(vs_enable_moving gr_allies_la_scorpions TRUE)

	(sleep 45)

		(if b_dialogue (print "MARINE (radio, over tank): Tank beats everything!"))
		(sleep (ai_play_line_on_object NONE 070MG_040))
		;(vs_play_line marine TRUE 070MG_040)
		(sleep 10)

		(if b_dialogue (print "MARINE (radio, over tank): Oh, man! I could do this all day!"))
		(sleep (ai_play_line_on_object NONE 070MG_050))
		;(vs_play_line marine TRUE 070MG_050)
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_la_gs_cautious
	(sleep_until (>= s_dw_progression 50))
	
	(sleep_until 
		(or
			(<= (objects_distance_to_object (player0) obj_guilty_spark) 6)
			(<= (objects_distance_to_object (player1) obj_guilty_spark) 6)
			(<= (objects_distance_to_object (player2) obj_guilty_spark) 6)
			(<= (objects_distance_to_object (player3) obj_guilty_spark) 6)
		)
	15)
	
	(if b_debug (print "mission dialogue:la:gs:cautious"))

		; cast the actors
		(vs_cast gr_guilty_spark TRUE 10 "070MG_060")
			(set guilty_spark (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe gr_guilty_spark TRUE)
	(vs_enable_looking gr_guilty_spark TRUE)
	(vs_enable_targeting gr_guilty_spark TRUE)
	(vs_enable_moving gr_guilty_spark FALSE)

	(sleep 1)
	
	(vs_approach_player guilty_spark FALSE 5 40 40)
	
	(sleep_until 
		(or
			(<= (objects_distance_to_object (player0) obj_guilty_spark) 7)
			(<= (objects_distance_to_object (player1) obj_guilty_spark) 7)
			(<= (objects_distance_to_object (player2) obj_guilty_spark) 7)
			(<= (objects_distance_to_object (player3) obj_guilty_spark) 7)
		)
	15 150)
	
	(sleep_until (not b_playing_dialogue))
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

		(if b_dialogue (print "GUILTY: Please! Use caution!"))
		(sleep (ai_play_line_on_object guilty_spark 070MG_060))
		(sleep 10)

		(if b_dialogue (print "GUILTY: Avoid collateral damage!"))
		(sleep (ai_play_line_on_object guilty_spark 070MG_070))
		(sleep 10)

		(if b_dialogue (print "GUILTY: While this facility looks quite hardy on the surface"))
		(sleep (ai_play_line_on_object guilty_spark 070MG_080))
		(sleep 10)

		(if b_dialogue (print "GUILTY: There are undoubtedly delicate structures below the facade!"))
		(sleep (ai_play_line_on_object guilty_spark 070MG_090))
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
(script dormant md_dw_stop_go_to_door
	(sleep_until (>= (device_get_position lb_first_door) 0.1))
	(sleep_forever md_dw_go_to_door)
	(md_dialogue_stop)
)

;DIALOG_TEMP: This needs to be radio, everybody is far. Johnson?
(script dormant md_dw_go_to_door
	(wake md_dw_stop_go_to_door)
	(sleep_until (>= s_dw_progression 20))
	(sleep_until (not b_playing_dialogue))
	
	(if b_debug (print "mission dialogue:dw:go:to:door"))

		; cast the actors
		(vs_cast gr_guilty_spark TRUE 10 "070MG_120")
			(set guilty_spark (vs_role 1))

	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_guilty_spark TRUE)
	(vs_enable_looking gr_guilty_spark TRUE)
	(vs_enable_targeting gr_guilty_spark TRUE)
	(vs_enable_moving gr_guilty_spark TRUE)

	(sleep 1)

		(if b_dialogue (print "SERGEANT (radio, over tank): All armor: form up on the lower doorway!"))
		(sleep (ai_play_line_on_object NONE 070MG_100))
		(sleep 10)

		(if b_dialogue (print "SERGEANT (radio, over tank): Chief! Get upstairs, have your robot pick that lock!"))
		(sleep (ai_play_line_on_object NONE 070MG_110))
		(sleep 10)

		(if b_dialogue (print "GUILTY (miffed): I beg your pardon?"))
		(sleep (ai_play_line_on_object NONE 070MG_120))
		(sleep 10)

		(if b_dialogue (print "GUILTY (miffed): I am 343 Guilty Spark. Monitor of installation zero-four!"))
		(sleep (ai_play_line_on_object NONE 070MG_130))
		(sleep 10)

		(if b_dialogue (print "SERGEANT (radio, over tank): Yeah, well you're also our ticket through this wall"))
		(sleep (ai_play_line_on_object NONE 070MG_140))
		(sleep 10)

		(if b_dialogue (print "SERGEANT (radio, over tank): So, if you don't mind --"))
		(sleep (ai_play_line_on_object NONE 070MG_150))
		(sleep 10)

		(if b_dialogue (print "GUILTY (a little saucy): I will gladly aid the Reclaimer's progress."))
		(sleep (ai_play_line_on_object NONE 070MG_160))
		(sleep 10)

	; cleanup
	(vs_release_all)
	
	;Start 070_music_086
	(set b_070_music_086 1)
)

; ===================================================================================================================================================
(script dormant md_dw_stop_allies_next
	(sleep_until (>= s_lb_progression 20))
	(sleep_forever md_dw_allies_next)
	(md_dialogue_stop)
)

(script dormant md_dw_allies_next
	(wake md_dw_stop_allies_next)
	(sleep_until (volume_test_players vol_dw_near_door) 30 300)
	
	(if (not (volume_test_players vol_dw_near_door))
		(begin
			(sleep_until (not b_playing_dialogue))
			
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)

			(if b_debug (print "mission dialogue:dw:gs:go:to:door"))
		
			(sleep 1)
		
			(if b_dialogue (print "GUILTY (radio): Reclaimer? Come to the upper doorway"))
			(sleep (ai_play_line_on_object NONE 070MG_170))
			(sleep 10)
	
			(if b_dialogue (print "GUILTY (radio): The others can take the lower route."))
			(sleep (ai_play_line_on_object NONE 070MG_180))
			(sleep 10)
			
			(md_dialogue_stop)
		)
		;If the player was inside the volume, wait until he's out of it
		;so that we can play the next message, in case he backtracks
		(sleep_until (not (volume_test_players vol_dw_near_door)))
	)
	
	(sleep_until (volume_test_players vol_dw_near_door) 30 600)

	(if (not (volume_test_players vol_dw_near_door))
		(begin
			(sleep_until (not b_playing_dialogue))
			
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
	
			(if b_dialogue (print "SERGEANT (radio): We'll go low, Chief! You check the upper floor"))
			(sleep (ai_play_line_on_object NONE 070MG_230))
			(sleep 10)
	
			(if b_dialogue (print "SERGEANT (radio): Make sure we got a path through the wall!"))
			(sleep (ai_play_line_on_object NONE 070MG_240))
			(sleep 10)
			
			(md_dialogue_stop)
		)
		;If the player was inside the volume, wait until he's out of it
		;so that we can play the next message, in case he backtracks
		(sleep_until (not (volume_test_players vol_dw_near_door)))
	)
	
	(sleep_until (volume_test_players vol_dw_near_door) 30 1200)

	(if (not (volume_test_players vol_dw_near_door))
		(begin
			(sleep_until (not b_playing_dialogue))
			
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)

			(if b_dialogue (print "JOHNSON (radio): Heavy armor's gotta go low, Chief! You check the upper floor"))
			(sleep (ai_play_line_on_object NONE 070MG_250))
			(sleep 10)
			
			(hud_activate_team_nav_point_flag player flg_dw_wall_door 0)
			
			(if b_dialogue (print "JOHNSON (radio): Make sure they have a path through the wall!"))
			(sleep (ai_play_line_on_object NONE 070MG_260))
			(sleep 10)
			
			(md_dialogue_stop)

			(sleep_until 
				(or
					(volume_test_players vol_dw_near_door)
					(>= s_lb_progression 20)
				)
			5)
			(hud_deactivate_team_nav_point_flag player flg_dw_wall_door)
		)
	)
)

; ===================================================================================================================================================
(script dormant md_dw_stop_open_door
	(sleep_until (>= (device_get_position ex_wall_door) 0.1) 10)
	
	(sleep_until (script_finished md_dw_open_door) 30 300)
	
	(if (not (script_finished md_dw_open_door))
		(begin
			(sleep_forever md_dw_open_door)
			(cs_run_command_script gr_guilty_spark cs_end)
			(unit_add_equipment (unit obj_guilty_spark) no_weapon_profile true false)
			(md_dialogue_stop)
		)
	)
)

(script dormant md_dw_open_door
	(wake md_dw_stop_open_door)
	(sleep_until (volume_test_players vol_dw_near_door) 10)
	;When player is near, make sure GS is within that area
	(ai_bring_forward obj_guilty_spark 10)
	
	(sleep_until (volume_test_object vol_dw_near_door obj_guilty_spark) 10)
	
	(sleep_until (not b_playing_dialogue) 30 300)
	
	(sleep 60)
	
	;Stop 070_music_085
	(set b_070_music_085 0)
	;Stop 070_music_086
	(set b_070_music_086 0)
	
	; cast the actors
	(vs_cast gr_guilty_spark TRUE 20 "070MG_190")
		(set guilty_spark (vs_role 1))
		
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe guilty_spark TRUE)
	(vs_enable_looking guilty_spark FALSE)
	(vs_enable_targeting guilty_spark FALSE)
	(vs_enable_moving guilty_spark FALSE)

	(sleep 1)
	
		(vs_fly_to guilty_spark false pts_dw_gs/p0 0.2)
		
		(if b_dialogue (print "GUILTY: Odd. For a doorway to abide such robust security protocols"))
		(sleep (ai_play_line_on_object guilty_spark 070MG_190))
		(sleep 10)

		(if b_dialogue (print "GUILTY: One moment, Reclaimer"))
		(sleep (ai_play_line_on_object guilty_spark 070MG_200))
		(sleep 10)
		
		(unit_add_equipment (unit obj_guilty_spark) gs_profile true false)
		(sleep 1)
		(vs_shoot_point guilty_spark true pts_dw_gs/shoot_at)
		(vs_fly_to guilty_spark false pts_dw_gs/p1)
		
		(sleep 60)
		(set b_dw_gs_open_door 1)
		
		(if b_dialogue (print "GUILTY: (hums)"))
		(ai_play_line_on_object guilty_spark 070MG_210)
		(sleep 10)
		
		(sleep_until (>= (device_get_position ex_wall_door) 0.1) 10 150)
		
		(vs_shoot_point guilty_spark false pts_dw_gs/shoot_at)
		(sleep 1)
		(unit_add_equipment (unit obj_guilty_spark) no_weapon_profile true false)
		
		(vs_enable_moving guilty_spark TRUE)

		(if b_dialogue (print "GUILTY: There we are! Please follow me!"))
		(sleep (ai_play_line_on_object guilty_spark 070MG_220))
		(sleep 10)
				
	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
(script dormant md_lb_stop_open_door
	(sleep_until (>= (device_get_position lb_first_door) 0.1) 10)
	
	(sleep_until (script_finished md_lb_open_door) 30 1200)
	
	(if (not (script_finished md_lb_open_door))
		(begin
			(sleep_forever md_lb_open_door)
			(cs_run_command_script gr_guilty_spark cs_end)
			(unit_add_equipment (unit obj_guilty_spark) no_weapon_profile true false)
			(md_dialogue_stop)
		)
	)
)

(script dormant md_lb_open_door
	(wake md_lb_stop_open_door)
	(sleep_until (volume_test_players vol_lb_gs_open_door) 10)
	
	(sleep_until (volume_test_object vol_lb_gs_open_door obj_guilty_spark) 10 150)
	
	;When player is near, make sure GS is within that area
	(ai_bring_forward obj_guilty_spark 10)
	
	(sleep_until (volume_test_object vol_lb_gs_open_door obj_guilty_spark) 10)
	
	; cast the actors
	(vs_cast gr_guilty_spark FALSE 20 "")
		(set guilty_spark (vs_role 1))
		
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe guilty_spark TRUE)
	(vs_enable_looking guilty_spark FALSE)
	(vs_enable_targeting guilty_spark FALSE)
	(vs_enable_moving guilty_spark FALSE)

	(sleep 1)
	
		(vs_fly_to guilty_spark FALSE pts_lb_gs/p0 0.2)
		
		(sleep_until (not (vs_running_atom_movement guilty_spark)) 30 150)
		
		(unit_add_equipment (unit obj_guilty_spark) gs_profile true false)
		(sleep 1)
		(vs_shoot_point guilty_spark true pts_lb_gs/shoot_at)
		(vs_fly_to_and_face guilty_spark false pts_lb_gs/p1 pts_lb_gs/shoot_at)
		
		(sleep_until (>= (device_get_power lb_first_door) 0.1) 10 180)
		(set b_lb_gs_open_door 1)
		
		(vs_shoot_point guilty_spark false pts_lb_gs/shoot_at)
		(sleep 1)
		(unit_add_equipment (unit obj_guilty_spark) no_weapon_profile true false)
		
		(sleep_until (>= (device_get_position lb_first_door) 0.1) 10 150)
				
	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
(script dormant md_lb_stop_gs_go_to_switch
	(sleep_until 
		(or
			(<= (device_get_position lb_lightbridge_switch) 0.9)
			b_lb_lightbridge_on
		)
	5)
	(sleep_forever md_lb_gs_go_to_switch)	
	(md_dialogue_stop)
	
	(sleep 1)
	(cs_run_command_script gr_guilty_spark cs_end)
)

(script dormant md_lb_gs_go_to_switch
	(sleep_until (>= s_lb_progression 20))
	(wake md_lb_stop_gs_go_to_switch)
	
	(sleep_until (volume_test_object vol_lb_switch_room obj_guilty_spark) 10)
	(sleep 60)
	
	(if b_debug (print "mission dialogue:lb:gs:go:to:switch"))

		; cast the actors
		(vs_cast gr_guilty_spark TRUE 20 "070MH_050")
			(set guilty_spark (vs_role 1))
			
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_guilty_spark TRUE)
	(vs_enable_looking gr_guilty_spark TRUE)
	(vs_enable_targeting gr_guilty_spark TRUE)
	(vs_enable_moving gr_guilty_spark TRUE)

	(sleep 1)

		(if b_dialogue (print "GUILTY: Here! This panel will activate a bridge"))
		(sleep (ai_play_line_on_object guilty_spark 070MH_050))
		(sleep 10)
		
		(sleep 120)
		
		(if b_dialogue (print "GUILTY: Allow your companions to cross below!"))
		(sleep (ai_play_line_on_object guilty_spark 070MH_060))
		(sleep 10)
		
		(sleep 60)
		
	; cleanup
	(vs_release_all)
	
	(sleep 1)
	
	;Have GS guide you with interior distance values
	(set s_gs_walkup_dist 3)
	(set s_gs_talking_dist 4)
	;"GUILTY: Place your hand on the pad, Reclaimer!"
	(set g_gs_1st_line 070MH_070)
	(set g_gs_2nd_line 070MH_070)
	(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
)

; ===================================================================================================================================================

(script dormant md_lb_gs_next
	(sleep_until b_lb_lightbridge_on)
	(sleep 30)
	
	(sleep_until (not b_playing_dialogue) 30 300)
	
	(if b_debug (print "mission dialogue:lb:gs:next"))

		; cast the actors
		(vs_cast gr_guilty_spark TRUE 20 "070MH_080")
			(set guilty_spark (vs_role 1))
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_guilty_spark TRUE)
	(vs_enable_looking gr_guilty_spark TRUE)
	(vs_enable_targeting gr_guilty_spark TRUE)
	(vs_enable_moving gr_guilty_spark TRUE)

	(sleep 1)

		(if b_dialogue (print "GUILTY: Excellent! This way!"))
		(sleep (ai_play_line_on_object guilty_spark 070MH_080))
		(sleep 10)

	; cleanup
	(vs_release_all)
	
	;Have GS guide you with interior distance values
	(set s_gs_walkup_dist 3)
	(set s_gs_talking_dist 4)
	;"GUILTY: We must move on, Reclaimer!"
	(set g_gs_1st_line 070MH_090)
	;"GUILTY: Hurry! To the Cartographer!"
	(set g_gs_2nd_line 070MH_100)
	(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
	
	
	;Say lines about the covenant only if the player linger in that space for a minute
	(sleep_until (>= s_lb_progression 40) 30 300)
	(if (< s_lb_progression 40)
		(begin
			(sleep_until (not b_playing_dialogue) 30 300)
			
			(if b_debug (print "mission dialogue:lb:gs:next"))

			; cast the actors
			(vs_cast gr_guilty_spark TRUE 20 "070MH_010")
				(set guilty_spark (vs_role 1))
		
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
		
			; movement properties
			(vs_enable_pathfinding_failsafe gr_guilty_spark TRUE)
			(vs_enable_looking gr_guilty_spark TRUE)
			(vs_enable_targeting gr_guilty_spark TRUE)
			(vs_enable_moving gr_guilty_spark TRUE)
			
			(if b_dialogue (print "GUILTY: Sudden clarity!"))
			(sleep (ai_play_line_on_object guilty_spark 070MH_010))
			(sleep 10)
	
			(if b_dialogue (print "GUILTY: These Sentinels were trying to deny the meddlers' access to the lower levels of this facility."))
			(sleep (ai_play_line_on_object guilty_spark 070MH_020))
			(sleep 15)
			
			(if b_dialogue (print "GUILTY: A wise decision, given their predilection for destructive acquisition."))
			(sleep (ai_play_line_on_object guilty_spark 070MH_030))
			(sleep 10)
			
			; cleanup
			(vs_release_all)
			
			;Have GS guide you with interior distance values
			(set s_gs_walkup_dist 3)
			(set s_gs_talking_dist 4)
			;"GUILTY: We must move on, Reclaimer!"
			(set g_gs_1st_line 070MH_090)
			;"GUILTY: Hurry! To the Cartographer!"
			(set g_gs_2nd_line 070MH_100)
			(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
		)
	)
)

(script dormant bd_get_inside_shaft
	(sleep_until 
		(and
			(>= s_lb_progression 30)
			b_lb_lightbridge_on
		)
	)
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	(if b_debug (print "mission dialogue:bd_get_inside_shaft"))

	(if b_dialogue (print "MIRANDA (radio): Good work, Chief!"))
	(sleep (ai_play_line_on_object NONE 070BC_010))
	(sleep 10)
	
	(if b_dialogue (print "MIRANDA (radio): Link up with our armor on the far side of the wall"))
	(sleep (ai_play_line_on_object NONE 070BC_020))
	(sleep 10)
	
	(if b_dialogue (print "MIRANDA (radio): Make your way down to the Cartographer!"))
	(sleep (ai_play_line_on_object NONE 070BC_030))
	(sleep 10)
)

; ===================================================================================================================================================
(global boolean b_vd_warthogs_advance 0)
(global boolean b_vd_phantom_advance 0)


(script command_script cs_bb_wraith_0
	(cs_enable_moving true)
	(cs_shoot false)
	(cs_enable_targeting false)
	(cs_enable_looking true)
	(cs_abort_on_damage true)
	(sleep_forever)
)

(script command_script cs_bb_wraith_1
	(cs_face true pts_bb_wraiths/face)
	(sleep_until b_vd_warthogs_advance 5)
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_shoot true)
	(cs_shoot true allies_bb_warthog_entrance_1/driver)
	(cs_go_to pts_bb_wraiths/p1)
	(cs_shoot true allies_bb_warthog_entrance_1/driver)
)

(script command_script cs_bb_wraith_2
	(cs_face true pts_bb_wraiths/face)
	(sleep_until b_vd_warthogs_advance 5)
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_shoot true)
	(cs_shoot true allies_bb_warthog_entrance_0/driver)
	(cs_go_to pts_bb_wraiths/p2)
	(cs_shoot true allies_bb_warthog_entrance_0/driver)
)

(script command_script cs_bb_wraith_3
	(cs_face true pts_bb_wraiths/face)
	(sleep_until b_vd_warthogs_advance 5)
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_shoot true)
	(cs_shoot true allies_bb_warthog_entrance_0/driver)
	(cs_go_to pts_bb_wraiths/p3)
	(cs_shoot true allies_bb_warthog_entrance_0/driver)
)

(script command_script cs_bb_poor_aiming_0
	(cs_enable_targeting true)
	(cs_enable_looking true)	
	(cs_shoot true)
	(cs_abort_on_vehicle_exit true)
	
	(if 
		(or
			(vehicle_test_seat (ai_vehicle_get ai_current_actor) "warthog_g" ai_current_actor)
			(vehicle_test_seat (ai_vehicle_get ai_current_actor) "mauler_g" ai_current_actor)
		)
		(begin
			(sleep_until
				(begin				
					(cs_shoot_point true pts_bb_kill_warthog_0/shoot_at_0)
					(cs_shoot_point true pts_bb_kill_warthog_0/shoot_at_1)
					(cs_shoot_point true pts_bb_kill_warthog_0/shoot_at_2)
					(sleep (random_range 150 300))
					(>= s_bb_progression 20)
				)
			)
		)
	)	
)

(script command_script cs_bb_poor_aiming_1
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_shoot true)
	(cs_abort_on_vehicle_exit true)
	(if 
		(or
			(vehicle_test_seat (ai_vehicle_get ai_current_actor) "warthog_g" ai_current_actor)
			(vehicle_test_seat (ai_vehicle_get ai_current_actor) "mauler_g" ai_current_actor)
		)
		(begin
			(sleep_until
				(begin				
					(cs_shoot_point true pts_bb_kill_warthog_1/shoot_at_0)
					(cs_shoot_point true pts_bb_kill_warthog_1/shoot_at_1)
					(cs_shoot_point true pts_bb_kill_warthog_1/shoot_at_2)
					(sleep (random_range 150 300))
					(>= s_bb_progression 20)
				)
			)
		)
	)
)

(script command_script cs_bb_kill_warthog_0
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to pts_bb_kill_warthog_0/p6)
	(unit_kill (ai_vehicle_get_from_starting_location allies_bb_warthog_entrance_0/driver))
	(ai_kill allies_bb_warthog_entrance_0)	
)

(script command_script cs_bb_kill_warthog_1
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to pts_bb_kill_warthog_1/p7)
	(unit_kill (ai_vehicle_get_from_starting_location allies_bb_warthog_entrance_1/driver))
	(ai_kill allies_bb_warthog_entrance_1)	
)

(script command_script cs_bb_phantom_arrive
	(cs_shoot false)
	(ai_set_blind ai_current_actor true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(sleep_until b_vd_phantom_advance 5)
	(cs_fly_to pts_bb_front_phantom/p6)
	(cs_fly_to_and_face pts_bb_front_phantom/drop pts_bb_front_phantom/face)
	(sleep 60)
	(vehicle_unload (ai_vehicle_get_from_starting_location cov_bb_front_phantom/pilot) "phantom_lc")
	(sleep 60)
	(set b_bb_wraith_dropped 1)
	(cs_vehicle_speed 0.7)
	(cs_face_player true)
	(cs_fly_to pts_bb_front_phantom/p8)
	(sleep_until (>= s_bb_progression 40))
	(ai_set_blind ai_current_actor false)
)

(script dormant bb_scarab_over_wall
	(object_create bb_scarab)
	(sleep 1)
	(set b_bb_scarab_over_head_created 1)
	(object_cannot_take_damage bb_scarab)
	(object_cannot_die bb_scarab true)
	(custom_animation bb_scarab "objects\giants\scarab\cinematics\vignettes\070vd_scarab_over_wall\070vd_scarab_over_wall" "070vd_scarab_over_wall" false)	
	(sleep_until (not (unit_is_playing_custom_animation bb_scarab)) 1)
	(object_cannot_die bb_scarab false)
	(object_can_take_damage bb_scarab)
	(object_destroy bb_scarab)
	
	(sleep_until 
		(or
			(>= s_bb_progression 70)
			(>= (ai_task_count obj_bb_allies/3rd_floor) 1)
		)
	15)
	
	(ai_place cov_bb_scarab)
	(sleep 1)
	(object_cannot_take_damage bb_scarab)
	(object_cannot_die bb_scarab true)
	(set obj_bb_scarab (ai_get_object cov_bb_scarab))
	
	(wake md_bb_scarab_radio)	
	(sleep 90)
	(wake 070vf_scarab_return)
	
	(sleep_until (not (unit_is_playing_custom_animation bb_scarab)) 1 900)
	
	(object_cannot_die bb_scarab false)
	(object_can_take_damage bb_scarab)
)

(script dormant 070VD_scarab_over_wall_intro
	(sleep_until (>= (device_get_position bb_player_door) 0.01) 5)
	
	(sleep_until
		(or
			(and
				(volume_test_players vol_lb_scarab_view)
				(objects_can_see_flag (players) flg_bb_outside 20)
			)
			(volume_test_players vol_bb_vd_start)
		)
	5)
	
	(game_save)
	
	(wake bb_scarab_over_wall)
	
	(wake md_bb_scarab_intro)
	
	(sleep_until (>= s_bb_progression 10) 5)
	
	(wake bb_manage_intro_battle)
	
	;Allies close to you can now advance	
	(ai_migrate lb_guilty_spark bb_guilty_spark)
	
	;A beat, then spawn the warthog / phantom
	(sleep_until (>= s_bb_progression 20) 15 60)
	;Phantom advances and drops wraith_0
	(set b_vd_phantom_advance 1)
	
	(wake bb_manage_intro_warthog)
	
	(ai_place cov_bb_canyon_0)
	(ai_place cov_bb_canyon_1)
)

(script dormant bb_manage_intro_battle
	;Place the intro warthogs	
	(set b_vd_warthogs_advance 1)
	(if (<= (ai_in_vehicle_count allies_bb_warthog_entrance_0) 0)
		(ai_place allies_bb_warthog_entrance_0)
	)
	(if (<= (ai_in_vehicle_count allies_bb_warthog_entrance_1) 0)
		(ai_place allies_bb_warthog_entrance_1)
	)
	
	(cs_run_command_script allies_bb_warthog_entrance_0 cs_bb_poor_aiming_0)
	(cs_run_command_script allies_bb_warthog_entrance_1 cs_bb_poor_aiming_1)
		
	(sleep_until (>= s_bb_progression 20) 10 450)
	
	;Tell them to Kill themselves after a while
	(cs_run_command_script allies_bb_warthog_entrance_0 cs_bb_kill_warthog_0)
	(cs_run_command_script allies_bb_warthog_entrance_1 cs_bb_kill_warthog_1)
)

; ===================================================================================================================================================

(script dormant md_bb_marine_hop_in
	(sleep_until (not (unit_in_vehicle (player0))) 30 300)

	(if 
		(and
			(not (unit_in_vehicle (player0)))
			(volume_test_players vol_bb_arrival)
		)
		(begin
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
			
			(if b_debug (print "mission dialogue:bb:marine:hop:in"))
		
				; cast the actors
				(vs_cast allies_bb_player_warthog TRUE 10 "070MI_040")
					(set marine (vs_role 1))
		
			; movement properties
			(vs_enable_pathfinding_failsafe allies_bb_player_warthog TRUE)
			(vs_enable_looking allies_bb_player_warthog TRUE)
			(vs_enable_targeting allies_bb_player_warthog TRUE)
			(vs_enable_moving allies_bb_player_warthog TRUE)
		
			(sleep 1)
				(vs_face_player marine TRUE)
				
				(if b_dialogue (print "MARINE: Sir! Hog's all yours!"))
				(vs_play_line marine TRUE 070MI_040)
				(sleep 10)
				
				(if b_dialogue (print "MARINE: Get on the turret, sir! Let's clear a path!"))
				(vs_play_line marine TRUE 070MI_050)
				(sleep 10)
								
				(vs_face_player marine FALSE)
		
			; cleanup
			(vs_release_all)
		)
	)
)

; ===================================================================================================================================================
;*
(script dormant md_bb_gs_next
	(sleep_until (>= s_bb_progression 30) 30 900)
	
	(sleep_until 
		(or
			(<= (objects_distance_to_object (player0) obj_guilty_spark) 6)
			(<= (objects_distance_to_object (player1) obj_guilty_spark) 6)
			(<= (objects_distance_to_object (player2) obj_guilty_spark) 6)
			(<= (objects_distance_to_object (player3) obj_guilty_spark) 6)
		)
	15 300)
	
	(if b_debug (print "mission dialogue:bb:gs:next"))

		; cast the actors
		(vs_cast gr_guilty_spark TRUE 10 "070MI_060")
			(set guilty_spark (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe gr_guilty_spark TRUE)
	(vs_enable_looking gr_guilty_spark TRUE)
	(vs_enable_targeting gr_guilty_spark TRUE)
	(vs_enable_moving gr_guilty_spark TRUE)

	(sleep 1)

		(vs_approach_player guilty_spark FALSE 2 40 40)
		(sleep_until 
			(or
				(<= (objects_distance_to_object (player0) obj_guilty_spark) 3)
				(<= (objects_distance_to_object (player1) obj_guilty_spark) 3)
				(<= (objects_distance_to_object (player2) obj_guilty_spark) 3)
				(<= (objects_distance_to_object (player3) obj_guilty_spark) 3)
			)
		15 150)
		
		(sleep_until (not b_playing_dialogue))
		
		; block all other mission dialogue scripts 
		(sleep 1)
		(vs_set_cleanup_script md_cleanup)
		(md_dialogue_start)
		
		(if b_dialogue (print "GUILTY: Hurry down the slope, Reclaimer!"))
		(sleep (ai_play_line_on_object guilty_spark 070MI_060))
		(sleep 10)

		(if b_dialogue (print "GUILTY: The Cartographer is somewhere inside that spire!"))
		(sleep (ai_play_line_on_object guilty_spark 070MI_070))
		(sleep 10)

	; cleanup
	(vs_release_all)
)*;

; ===================================================================================================================================================
(script command_script cs_bb_tank_advance_0
	;Are you a tank driver?
	(if (vehicle_test_seat (ai_vehicle_get ai_current_actor) "scorpion_d" ai_current_actor)
		(begin
			(cs_enable_pathfinding_failsafe TRUE)
			(cs_enable_looking TRUE)
			(cs_enable_targeting TRUE)
			(cs_abort_on_vehicle_exit true)
			;(cs_move_in_direction -90 5 0)
			(cs_go_to_and_face pts_bb_scorpions/p0 pts_bb_scorpions/face)
			(sleep_until (<= (ai_task_count obj_bb_cov/entrance) 2))
		)
	)
)

(script command_script cs_bb_tank_advance_1
	;Are you a tank driver?
	(if (vehicle_test_seat (ai_vehicle_get ai_current_actor) "scorpion_d" ai_current_actor)
		(begin
			(cs_enable_pathfinding_failsafe TRUE)
			(cs_enable_looking TRUE)
			(cs_enable_targeting TRUE)
			(cs_abort_on_vehicle_exit true)
			;(cs_move_in_direction -90 5 0)
			(cs_go_to_and_face pts_bb_scorpions/p1 pts_bb_scorpions/face)
			(sleep_until (<= (ai_task_count obj_bb_cov/entrance) 2))
		)
	)
)

(script command_script cs_bb_tank_advance_2
	;Are you a tank driver?
	(if (vehicle_test_seat (ai_vehicle_get ai_current_actor) "scorpion_d" ai_current_actor)
		(begin
			(cs_enable_pathfinding_failsafe TRUE)
			(cs_enable_looking TRUE)
			(cs_enable_targeting TRUE)
			(cs_abort_on_vehicle_exit true)
			;(cs_move_in_direction -90 5 0)
			(cs_go_to_and_face pts_bb_scorpions/p2 pts_bb_scorpions/face)
			(sleep_until (<= (ai_task_count obj_bb_cov/entrance) 2))
		)
	)
)

(script dormant md_bb_marine_advance_0
	(sleep_until (>= s_bb_progression 50) 10)

	(cs_run_command_script allies_bb_scorpion_0 cs_bb_tank_advance_0)
	(cs_run_command_script allies_bb_scorpion_1 cs_bb_tank_advance_1)
	(cs_run_command_script allies_bb_scorpion_2 cs_bb_tank_advance_2)
	
	(if b_debug (print "mission dialogue:bb:marine:advance"))

	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	(if b_dialogue (print "SERGEANT (radio, over tank): All armor! Form up!"))
	(sleep (ai_play_line_on_object NONE 070MI_080))
	(sleep 15)
	
	(if b_dialogue (print "SERGEANT (radio, over tank): Hit 'em where it hurts!"))
	(sleep (ai_play_line_on_object NONE 070MI_090))
	(sleep 10)	
	
	(sleep_until (<= (ai_task_count obj_bb_cov/entrance) 2))
	
	;Make sure tanks are not stuck in the command scripts
	(if (script_started md_bb_marine_advance_1) (sleep_until (script_finished md_bb_marine_advance_1)))
	(cs_run_command_script allies_bb_scorpion_0 cs_end)
	(cs_run_command_script allies_bb_scorpion_1 cs_end)
	(cs_run_command_script allies_bb_scorpion_2 cs_end)
)

; ===================================================================================================================================================
(script dormant md_bb_marine_advance_1
	(sleep_until (>= (ai_task_count obj_bb_allies/entrance_vehicle_front) 1))
	
	(sleep_until (not b_playing_dialogue) 30 150)
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	(if (> (ai_living_count gr_allies_bb_scorpion) 0)
		(begin		
			(if b_debug (print "mission dialogue:bb:marine:advance"))
		
			(if b_dialogue (print "MARINE (radio, over tank): Target those Wraiths!"))
			(sleep (ai_play_line_on_object NONE 070MI_100))
		)
	)
)

(script dormant md_bb_marine_advance_2
	(sleep_until (>= (ai_task_count obj_bb_allies/2nd_floor) 1))
	
	(sleep_until (not b_playing_dialogue) 30 150)
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	(sleep (random_range 30 90))
	(if (> (ai_living_count gr_allies_bb_scorpion) 0)
		(begin
			(if b_debug (print "mission dialogue:bb:marine:advance"))
			
			(if b_dialogue (print "SERGEANT (radio, over tank): First line clear! Move up!"))
			(sleep (ai_play_line_on_object NONE 070MI_160))
		)
	)
	
	(if (not b_bb_scarab_battle_begun)
		(begin
			;1st line clear
			(set s_070_music_10 (max s_070_music_10 2))
		)
	)
)

(script dormant md_bb_marine_advance_3
	(sleep_until (>= (ai_task_count obj_bb_allies/3rd_floor) 1))
	
	(sleep (random_range 30 90))
	
	(sleep_until (not b_playing_dialogue) 30 300)
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	(if (> (ai_living_count gr_allies_bb_scorpion) 0)
		(begin
			(if b_debug (print "mission dialogue:bb:marine:advance"))
			
			(if b_dialogue (print "SERGEANT (radio, over tank): Second line clear! Push forward!"))
			(sleep (ai_play_line_on_object NONE 070MI_170))
		)
	)
	
	;2nd line clear
	(set s_070_music_10 (max s_070_music_10 3))
)

(script dormant md_bb_scarab_intro
	(sleep_until (not b_playing_dialogue) 30 150)
		(sleep (random_range 150 180))
	; block all other mission dialogue scripts
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
		
	(if b_dialogue (print "JOHNSON (radio): Heads up, marines! You got trouble!"))
	(sleep (ai_play_line_on_object NONE 070VE_010))
	
	;Stop 070_music_9
	(set b_070_music_09 0)
)

(script dormant 070vf_scarab_return
	(sleep_until (not b_playing_dialogue) 30 150)
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	(if b_debug (print "mission dialogue:bb:070vf_scarab_return"))

	(if b_dialogue (print "MARINE (radio, over tank): Scarab's back!"))
	(sleep (ai_play_line_on_object NONE 070VF_010))
	(sleep 10)
	
	(if b_dialogue (print "MARINE (radio, over tank): This time it means business!"))
	(sleep (ai_play_line_on_object NONE 070VF_020))
	(sleep 10)
	
	(if b_dialogue (print "SERGEANT (radio, over tank): Bravo! Flank and cover!"))
	(sleep (ai_play_line_on_object NONE 070VF_040))
	(sleep 10)
	
	(if b_dialogue (print "SERGEANT (radio, over tank): Everyone support the Chief! He'll take it down!"))
	(sleep (ai_play_line_on_object NONE 070VF_050))
	(sleep 10)
)

; ===================================================================================================================================================

(script dormant md_bb_stop_gs_panic
	(sleep_until 
		(and
			(<= (ai_living_count cov_bb_scarab) 0)
			bb_scarab_spawned
		)
	)
	
	(sleep_forever md_bb_gs_panic)
	;(cs_run_command_script gr_guilty_spark cs_end)
)

(script dormant md_bb_gs_panic
	(wake md_bb_stop_gs_panic)
	
	(sleep_until 
		(or
			(<= (objects_distance_to_object (player0) obj_guilty_spark) 10)
			(<= (objects_distance_to_object (player1) obj_guilty_spark) 10)
			(<= (objects_distance_to_object (player2) obj_guilty_spark) 10)
			(<= (objects_distance_to_object (player3) obj_guilty_spark) 10)
		)
	15 1800)
	
	(if b_debug (print "mission dialogue:bb:gs:panic:p1"))

	; cast the actors
	(vs_cast gr_guilty_spark TRUE 10 "070MI_230")
		(set guilty_spark (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe gr_guilty_spark TRUE)
	(vs_enable_looking gr_guilty_spark TRUE)
	(vs_enable_targeting gr_guilty_spark TRUE)
	(vs_enable_moving gr_guilty_spark TRUE)

	(sleep 1)
	
	(vs_approach_player guilty_spark FALSE 2 40 40)
	
	(sleep_until 
		(or
			(<= (objects_distance_to_object (player0) obj_guilty_spark) 3)
			(<= (objects_distance_to_object (player1) obj_guilty_spark) 3)
			(<= (objects_distance_to_object (player2) obj_guilty_spark) 3)
			(<= (objects_distance_to_object (player3) obj_guilty_spark) 3)
		)
	15 150)
	
	(sleep_until (not b_playing_dialogue))
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

		(if b_dialogue (print "GUILTY: This just won't do!"))
		(sleep (ai_play_line_on_object guilty_spark 070MI_230))
		(sleep 10)

		(if b_dialogue (print "GUILTY: Oh, my! Oh, my!"))
		(sleep (ai_play_line_on_object guilty_spark 070MI_240))
		(sleep 10)

		(if b_dialogue (print "GUILTY: You will damage the Cartographer!"))
		(sleep (ai_play_line_on_object guilty_spark 070MI_250))
		(sleep 10)
		
	; cleanup
	(vs_release_all)
	
	(sleep 600)
	
	(sleep_until 
		(or
			(<= (objects_distance_to_object (player0) obj_guilty_spark) 10)
			(<= (objects_distance_to_object (player1) obj_guilty_spark) 10)
			(<= (objects_distance_to_object (player2) obj_guilty_spark) 10)
			(<= (objects_distance_to_object (player3) obj_guilty_spark) 10)
		)
	15 1800)
	
	(if b_debug (print "mission dialogue:bb:gs:panic:p2"))

	; cast the actors
	(vs_cast gr_guilty_spark TRUE 10 "070MI_260")
		(set guilty_spark (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe gr_guilty_spark TRUE)
	(vs_enable_looking gr_guilty_spark TRUE)
	(vs_enable_targeting gr_guilty_spark TRUE)
	(vs_enable_moving gr_guilty_spark TRUE)

	(sleep 1)
	
	(vs_approach_player guilty_spark FALSE 2 40 40)
	
	(sleep_until 
		(or
			(<= (objects_distance_to_object (player0) obj_guilty_spark) 3)
			(<= (objects_distance_to_object (player1) obj_guilty_spark) 3)
			(<= (objects_distance_to_object (player2) obj_guilty_spark) 3)
			(<= (objects_distance_to_object (player3) obj_guilty_spark) 3)
		)
	15 150)
	
	(sleep_until (not b_playing_dialogue))
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
		(if b_dialogue (print "GUILTY: Meddlers, please! Put down your weapons!"))
		(sleep (ai_play_line_on_object guilty_spark 070MI_260))
		(sleep 10)

		(if b_dialogue (print "GUILTY: This is precisely why you are a tier three species!"))
		(sleep (ai_play_line_on_object guilty_spark 070MI_270))
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(global short s_abb_guilty_dialog 0)
(global short s_abb_guilty_speak_frequence 10)

(script command_script cs_abb_guilty_spark_wait
	(cs_enable_moving false)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(sleep_until (volume_test_object vol_abb_pelican_lz ai_current_actor) 10)
	(cs_fly_to pts_abb_gs/p0)
	(cs_fly_to pts_abb_gs/p1 0.5)
	(unit_add_equipment (unit obj_guilty_spark) gs_profile true false)
	(sleep 1)
	(cs_shoot_point true pts_abb_gs/shoot_at)
	(sleep_forever)
)

(script dormant md_abb_gs_tries_to_close_door
	(sleep_until (volume_test_object vol_abb_storm_in obj_guilty_spark) 10)
	
	(ai_set_objective gr_guilty_spark obj_f1_gs)

	(if b_debug (print "mission dialogue:abb:gs:opens:door"))

	; cast the actors
	(vs_cast gr_guilty_spark TRUE 10 "070MG_210")
		(set guilty_spark (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe guilty_spark TRUE)
	(vs_enable_looking guilty_spark FALSE)
	(vs_enable_targeting guilty_spark FALSE)
	(vs_enable_moving guilty_spark FALSE)

	(sleep 1)
	
		(vs_fly_to guilty_spark TRUE pts_abb_gs/p1)
		(vs_fly_to guilty_spark TRUE pts_abb_gs_inside/p4)
		(vs_fly_to guilty_spark TRUE pts_abb_gs_inside/p5)
		(vs_fly_to guilty_spark FALSE pts_abb_gs_inside/p0)
		(vs_fly_to guilty_spark FALSE pts_abb_gs_inside/p1 0.2)
		(unit_add_equipment (unit obj_guilty_spark) gs_profile true false)
		(sleep 1)
		(vs_shoot_point guilty_spark true pts_abb_gs_inside/shoot_at)
		
		(if b_dialogue (print "GUILTY: (hums)"))
		(sleep (ai_play_line_on_object guilty_spark 070MG_210))
		(sleep 10)
		
		(sleep_forever)
		
	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
(global boolean b_bb_stop_scarab_hint false)

(script dormant md_bb_stop_scarab_hint
	(sleep_until
		(and
			(object_model_target_destroyed bb_scarab "indirect_engine")
			bb_scarab_spawned
		)
	10)
	
	(sleep_forever md_bb_scarab_hint_interior)
	(sleep_forever md_bb_scarab_hint)
)

(script dormant md_bb_scarab_hint	
	(vs_set_cleanup_script md_cleanup)
	(wake md_bb_stop_scarab_hint)
	
	(wake md_bb_scarab_hint_interior)
	(sleep (random_range 1200 1800))
	(begin_random
		(begin
			(sleep (random_range 420 600))
			;Don't say anything if the player is on top of the scarab
			(sleep_until 
				(or
					(not b_bb_stop_scarab_hint)
					(not (volume_test_players vol_bb_scarab))
				)
			)
			(sleep_until (not b_playing_dialogue) 30 150)
			; block all other mission dialogue scripts			
			(md_dialogue_start)
			(if b_dialogue (print "JOHNSON (radio): Hit it in the knees, Chief!"))
			(sleep (ai_play_line_on_object NONE 070MI_320))
			(md_dialogue_stop)
		)
		(begin
			(sleep (random_range 420 600))
			;Don't say anything if the player is on top of the scarab
			(sleep_until 
				(or
					(not b_bb_stop_scarab_hint)
					(not (volume_test_players vol_bb_scarab))
				)
			)
			(sleep_until (not b_playing_dialogue) 30 150)
			; block all other mission dialogue scripts			
			(md_dialogue_start)
			(if b_dialogue (print "JOHNSON (radio): Take out its legs! Climb onboard!"))
			(sleep (ai_play_line_on_object NONE 070MI_330))
			(md_dialogue_stop)
		)
		(begin
			(sleep (random_range 420 600))
			;Don't say anything if the player is on top of the scarab
			(sleep_until 
				(or
					(not b_bb_stop_scarab_hint)
					(not (volume_test_players vol_bb_scarab))
				)
			)
			(sleep_until (not b_playing_dialogue) 30 150)
			; block all other mission dialogue scripts			
			(md_dialogue_start)
			(if b_dialogue (print "JOHNSON (radio): Back plating looks vulnerable! Light it up!"))
			(sleep (ai_play_line_on_object NONE 070MI_340))
			(md_dialogue_stop)
		)
	)
	
	(sleep (random_range 1200 1800))
	
	(begin_random
		(begin
			(sleep (random_range 420 600))
			;Don't say anything if the player is on top of the scarab
			(sleep_until 
				(or
					(not b_bb_stop_scarab_hint)
					(not (volume_test_players vol_bb_scarab))
				)
			)
			(sleep_until (not b_playing_dialogue) 30 150)
			; block all other mission dialogue scripts			
			(md_dialogue_start)
			(if b_dialogue (print "SERGEANT (radio, over tank): Hit it in the knees, Chief!"))
			(sleep (ai_play_line_on_object NONE 070MI_280))
			(md_dialogue_stop)
		)
		(begin
			(sleep (random_range 420 600))
			;Don't say anything if the player is on top of the scarab
			(sleep_until 
				(or
					(not b_bb_stop_scarab_hint)
					(not (volume_test_players vol_bb_scarab))
				)
			)
			(sleep_until (not b_playing_dialogue) 30 150)
			; block all other mission dialogue scripts			
			(md_dialogue_start)
			(if b_dialogue (print "SERGEANT (radio, over tank): Take out its legs! Climb onboard!"))
			(sleep (ai_play_line_on_object NONE 070MI_290))
			(md_dialogue_stop)
		)
		(begin
			(sleep (random_range 420 600))
			;Don't say anything if the player is on top of the scarab
			(sleep_until 
				(or
					(not b_bb_stop_scarab_hint)
					(not (volume_test_players vol_bb_scarab))
				)
			)
			(sleep_until (not b_playing_dialogue) 30 150)
			; block all other mission dialogue scripts			
			(md_dialogue_start)
			(if b_dialogue (print "SERGEANT (radio, over tank): Back plating looks vulnerable! Light it up!"))
			(sleep (ai_play_line_on_object NONE 070MI_300))
			(md_dialogue_stop)
		)
	)
	
	;DIALOG_TEMP	
	;(if b_dialogue (print "SERGEANT (radio, over tank): Find that power-core, Chief!"))
	;(vs_play_line sergeant TRUE 070MI_310)
	;(sleep 10)
)

(script dormant md_bb_scarab_hint_interior
	(sleep_until (volume_test_players vol_bb_scarab))
	(set b_bb_stop_scarab_hint 1)
	(sleep (random_range 90 150))
	(if b_dialogue (print "JOHNSON (radio): Find that power-core, Chief!"))
	(sleep (ai_play_line_on_object NONE 070MI_350))
	(sleep (random_range 300 600))
	(set b_bb_stop_scarab_hint 0)
)

; ===================================================================================================================================================

(script dormant md_bb_scarab_radio
	(object_create bb_truth_radio_0)
	(object_create bb_truth_radio_1)
	
	(objects_attach (ai_get_object cov_bb_scarab/scarab) "control_panel04" bb_truth_radio_0 "")
	(objects_attach (ai_get_object cov_bb_scarab/scarab) "control_panel02" bb_truth_radio_1 "")
	
	(sleep_until 
		(or
			(volume_test_players vol_bb_scarab_bottom)
			(object_model_target_destroyed bb_scarab "indirect_engine")
		)
	)
	
	(sleep_until (not b_playing_dialogue) 30 300)
	(sleep (random_range 90 150))
	
	(if (not (object_model_target_destroyed bb_scarab "indirect_engine"))
		(begin					
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)

			(if b_dialogue (print "TRUTH: I opened the portal to this hallowed place -- this shelter from Halo’s fire -- in the hopes that more of our Covenant would follow."))
			;(ai_play_line_on_object bb_truth_radio_0 070MQ_010)
			;(sleep 3)
			(sleep (ai_play_line_on_object bb_truth_radio_0 070MQ_010))
			(sleep 15)
			
			(if b_dialogue (print "TRUTH: Alas, save for a rabble of heretics and their demon allies, we are all that made the passage."))
			;(ai_play_line_on_object bb_truth_radio_0 070MQ_020)
			;(sleep 3)
			(sleep (ai_play_line_on_object bb_truth_radio_0 070MQ_020))
			(sleep 10)
			
			(if b_dialogue (print "TRUTH: And thus we must temper joy with sorrow -- keep in our hearts those left behind."))
			;(ai_play_line_on_object bb_truth_radio_0 070MQ_030)
			;(sleep 3)
			(sleep (ai_play_line_on_object bb_truth_radio_0 070MQ_030))
			(sleep 60)
		)
	)
	
	(object_destroy bb_truth_radio_0)
	(object_destroy bb_truth_radio_1)
)

; ===================================================================================================================================================

(script dormant md_abb_scarab_dead
	(sleep_until (and
			(<= (ai_living_count cov_bb_scarab) 0)
			bb_scarab_spawned
			(<= (ai_living_count gr_cov_bb_ghosts) 0)
		)
	)
	
	(sleep (random_range 30 90))
	
	(if b_debug (print "mission dialogue:abb:marine:next:01"))

	; cast the actors
	(vs_cast gr_allies_bb FALSE 10 "070MI_360" "070MI_370";*"070MI_390"*;)
		(set marine_01 (vs_role 1))
		(set marine_02 (vs_role 2))
		;(set sergeant (vs_role 3))

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies_bb TRUE)
	(vs_enable_looking gr_allies_bb  TRUE)
	(vs_enable_targeting gr_allies_bb TRUE)
	(vs_enable_moving gr_allies_bb TRUE)

	(sleep 1)
	
	;Everybody exit their vehicle and look at the scarab dying
	(ai_vehicle_exit gr_allies_bb)
	;Vehicles are reserved so that AIs don't enter them right away
	(bb_reserve_all_vehicles true)
	
	(vs_enable_moving gr_allies_bb FALSE)
	
	(sleep 60)
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	;(md_dialogue_start)
	
	(vs_face_object gr_allies_bb true obj_bb_scarab)
		
		;(if b_dialogue (print "MARINE: Down for the count!"))
		;(vs_play_line marine_01 TRUE 070MI_360)
		;(sleep 10)

		;(if b_dialogue (print "MARINE: Burn, baby, burn!"))
		;(vs_play_line marine_02 TRUE 070MI_370)
		;(sleep 10)

		;(vs_face_player marine_02 true)
		;(if b_dialogue (print "MARINE: And they call that thing a tank!"))
		;(vs_play_line marine_02 TRUE 070MI_380)
		;(sleep 10)
		;(vs_face_player marine_02 false)
		
		(sleep 300)
		
	;(md_dialogue_stop)
				
	;Vehicles are not reserved anymore
	(bb_reserve_all_vehicles false)
	
	(sleep 30)
	(vs_face_object gr_allies_bb false cov_bb_scarab)
	(vs_enable_moving gr_allies_bb TRUE)
	
	;Attack the main structure!
	(ai_set_objective gr_allies_bb obj_abb_allies)

	; cleanup
	(vs_release_all)	
	
	;Give the guys time to get back into their vehicle
	(ai_enter_squad_vehicles gr_allies_bb)
	(sleep 150)
	
	;HACK - guys keep entering their vehicle, so we need to tell them
	;to exit them repetively
	(sleep_until
		(begin
			(cs_run_command_script gr_allies_bb cs_abb_exit_vehicle)
			;Keep doing that until the shaft started
			b_f1_has_started
		)
	120)
)

;Guys exit their vehicle when they arrive at destination
(script command_script cs_abb_exit_vehicle
	(if (unit_in_vehicle ai_current_actor)
		(begin
			(cs_shoot true)
			(cs_enable_targeting true)
			(cs_enable_looking true)
			(cs_enable_moving true)
			(sleep_until (volume_test_object vol_bb_base_entrance ai_current_actor) 10)
			(sleep 30)
			;Only exit if you're not in a vehicle with the player
			(if (not (player_in_vehicle (ai_vehicle_get ai_current_actor)))			
				(begin
					(ai_vehicle_reserve (ai_vehicle_get ai_current_actor) true)
					(ai_vehicle_exit ai_current_actor)
				)
			)
		)
	)
)

; ===================================================================================================================================================

(script dormant 070_shipmaster_arrives
	(object_create_anew abb_capital_ship)
	(object_cinematic_visibility abb_capital_ship true)
	(object_set_always_active abb_capital_ship 1)
	(scenery_animation_start abb_capital_ship objects\vehicles\cov_capital_ship\cinematics\vignette\070_shipmaster_arrives\070_shipmaster_arrives "070_shipmaster_arrives")
	(sleep (scenery_get_animation_time abb_capital_ship))
	(scenery_animation_start_loop abb_capital_ship objects\vehicles\cov_capital_ship\cinematics\vignette\070_shipmaster_arrives\070_shipmaster_arrives "070_shipmaster_idle")
)

(script dormant md_abb_shipmaster_reward
	(sleep_until 
		(and
			(<= (ai_living_count cov_bb_scarab) 0)
			bb_scarab_spawned
			(or
				(<= (ai_living_count gr_cov_bb_ghosts) 0)
				(>= s_abb_progression 10)
			)
		)
	)
	
	(sleep (random_range 60 120))
	
	(wake 070_shipmaster_arrives)	
	(sleep (random_range 150 180))

	(if (< s_abb_progression 10)
		(begin
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
			
			(if b_debug (print "mission dialogue:abb:jon:bring:arb"))
	
			(if b_dialogue (print "SHIPMASTER (radio): Not bad, Spartan. I saw that explosion from orbit"))
			(sleep (ai_play_line_on_object NONE 070MI_430))
			(sleep 30)
	
			(if b_dialogue (print "SHIPMASTER (radio): Truth's fleet lies in ruin!"))
			(sleep (ai_play_line_on_object NONE 070MI_440))
			(sleep 10)
	
			(if b_dialogue (print "SHIPMASTER (radio): Find where the liar hides"))
			(sleep (ai_play_line_on_object NONE 070MI_450))
			(sleep 10)
	
			(if b_dialogue (print "SHIPMASTER (radio): So I may place my boot between his gums!"))
			(sleep (ai_play_line_on_object NONE 070MI_460))
			(sleep 10)
	
			(if b_dialogue (print "MIRANDA (radio): We'll know soon enough, Shipmaster."))
			(sleep (ai_play_line_on_object NONE 070MI_470))
			(sleep 90)
			
			(if b_dialogue (print "JOHNSON (radio): Infantry on the spire!"))
			(sleep (ai_play_line_on_object NONE 070MI_410))
			(sleep 10)
			
			(sleep 30)
	
			(if b_dialogue (print "JOHNSON (radio): Mop 'em up!"))
			(sleep (ai_play_line_on_object NONE 070MI_420))
			(sleep 10)
			
			(md_dialogue_stop)
		)
	)
		
	(set b_bb_shipmaster_dialog_finished 1)		
	
	(sleep_until (>= s_bb_progression 90) 30 900)	
	
	(sleep_until (>= s_abb_progression 10) 30 1800)
	
	(if 
		(and
			(< s_abb_progression 10)
			(not (game_is_cooperative))
		)
		(begin	
			; block all other mission dialogue scripts 
			(md_dialogue_start)
			(if b_dialogue (print "JOHNSON (radio): Meet the Arbiter at the top of the spire, Chief!"))
			(sleep (ai_play_line_on_object NONE 070MI_490))
			(md_dialogue_stop)
		)
	)
	
	(sleep_until (>= s_abb_progression 10) 30 1800)
	
	(if (< s_abb_progression 10)
		(begin	
			; block all other mission dialogue scripts 
			(md_dialogue_start)
			(if b_dialogue (print "JOHNSON (radio): Chief! Spark's found an entrance up top! Follow him inside!"))
			(sleep (ai_play_line_on_object NONE 070MI_500))
			(md_dialogue_stop)
			(hud_activate_team_nav_point_flag player flg_shaft_door 0)
			(sleep_until (>= (device_get_position shaft_door) 0.5) 5)
			(hud_deactivate_team_nav_point_flag player flg_shaft_door)
		)
	)
)

; ===================================================================================================================================================
(script command_script cs_abb_pelican_arrives
	(cs_fly_to pts_abb_pelican/p0)
	(cs_fly_to pts_abb_pelican/p1)
	(cs_fly_to pts_abb_pelican/p2)
	(unit_open (ai_vehicle_get ai_current_actor))
	(cs_fly_to pts_abb_pelican/p3)
	(cs_vehicle_speed 0.7)
	(cs_fly_to_and_face pts_abb_pelican/hover_cache pts_abb_pelican/p4)
	(sleep_until 
		(or
			b_bb_shipmaster_dialog_finished
			(volume_test_players vol_abb_halfway_ramp)
		)
	)
	(sleep_until (volume_test_players vol_abb_halfway_ramp) 30 90)
	(sleep_until 
		(or
			(<= (ai_task_count obj_abb_cov/defend_base) 2)
			(volume_test_players vol_abb_halfway_ramp)
		)
	)
	(cs_fly_to pts_abb_pelican/p4)
	(cs_vehicle_speed 0.4)
	(cs_fly_to_and_face pts_abb_pelican/p5 pts_abb_pelican/face)	
	(cs_fly_to_and_face pts_abb_pelican/p6 pts_abb_pelican/face 1)
	(set b_abb_pelican_arrived 1)
	(sleep_forever)
)

(script command_script cs_abb_pelican_exits
	(cs_vehicle_speed 1)
	(cs_fly_to_and_face pts_abb_pelican/p5 pts_abb_pelican/p4)
	(cs_fly_to pts_abb_pelican/p4)
	(cs_fly_to pts_abb_pelican/p8)
	(kill_players_in_volume vol_abb_kill_players)
	(cs_fly_to pts_abb_pelican/p9)
	(cs_fly_to pts_abb_pelican/p10)
	(ai_kill ai_current_actor)
)

(script command_script cs_abb_arbiter_greeting
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_enable_pathfinding_failsafe true)
	
	(sleep_until (>= s_abb_progression 10) 5)
	
	(if 
		(and
			(not (volume_test_players vol_f1_start))
			(<= (objects_distance_to_object (players) ai_current_actor) 8)
		)
		(begin
			(cs_approach_player 2.5 10 10)
			(sleep (ai_play_line_at_player ai_current_actor 070MQ_050))
		)
	)
)

(script dormant md_abb_jon_bring_arb
	(sleep_until b_abb_pelican_arrived)
	
	(vehicle_unload (ai_vehicle_get_from_starting_location allies_abb_pelican/pilot) "pelican_p_r03")
	(vehicle_unload (ai_vehicle_get_from_starting_location allies_abb_pelican/pilot) "pelican_p_r04")
	(vehicle_unload (ai_vehicle_get_from_starting_location allies_abb_pelican/pilot) "pelican_p_r05")
	
	(if (not (game_is_cooperative))
		(cs_run_command_script gr_arbiter cs_abb_arbiter_greeting)
	)
	
	(sleep_until (volume_test_players vol_abb_storm_in) 15)
	
	(set b_abb_pelican_marines_moving 1)
	
	(sleep_until (>= (device_get_power shaft_door) 0.5) 5)
	
	(ai_set_objective gr_arbiter obj_f1_allies)
	(ai_set_objective gr_abb_pelican_marines obj_f1_allies)
	
	(sleep 150)
	
	;Pelican flies away
	(cs_run_command_script allies_abb_pelican/pilot cs_abb_pelican_exits)
)

;*(script dormant md_abb_jon_bring_arb
	(sleep_until b_abb_pelican_arrived)
	(sleep_until (volume_test_players vol_abb_pelican_lz) 15 600)
	(sleep_until (volume_test_players vol_abb_storm_in) 15)
	
	(cs_run_command_script allies_abb_pelican cs_end)
	(cs_run_command_script allies_abb_pelican/pilot cs_abb_pelican_hovers)

	(if b_debug (print "mission dialogue:abb:jon:bring:arb"))

	; cast the actors
	(vs_cast ai_abb_johnson TRUE 10 "")
		(set johnson (vs_role 1))
	(if (not (game_is_cooperative))
		(begin
			(vs_cast ai_abb_arbiter TRUE 10 "")
				(set arbiter (vs_role 1))
		)
	)
	(vs_cast ai_abb_pelican_marines_0 FALSE 10 "")
		(set marine_01 (vs_role 1))
	(vs_cast ai_abb_pelican_marines_1 FALSE 10 "")
		(set marine_02 (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies TRUE)
	(vs_enable_targeting gr_allies TRUE)
	(vs_enable_moving gr_allies FALSE)

	(sleep 1)
	
		;Everybody exits the pelican
		(vs_movement_mode gr_allies 1)
		(ai_vehicle_exit marine_01)
		(sleep 60)
		(vs_go_to_and_face marine_01 FALSE pts_abb_ground_troops/p1 pts_abb_ground_troops/face_center)
		(ai_vehicle_exit marine_02)
		(sleep 60)
		(vs_go_to_and_face marine_02 FALSE pts_abb_ground_troops/p3 pts_abb_ground_troops/face_center)
		
		; set music 02 alternate
		(if b_debug (print "music 02 alternate"))
		(sound_looping_set_alternate levels\solo\070_waste\music\070_music_02 TRUE)
		
		(if (not (game_is_cooperative))
			(begin
				(sleep 60)
				(ai_vehicle_exit arbiter)
			)
		)
		
		(sleep 10)
		
		(set b_abb_pelican_marines_moving 1)
		(vs_face marine_01 true pts_abb_ground_troops/face_door)
		(vs_face marine_02 true pts_abb_ground_troops/face_door)
		(vs_face arbiter true pts_abb_ground_troops/face_door)
		(sleep 30)
		
		(vs_movement_mode gr_allies 2)
		(vs_go_to_and_posture arbiter FALSE pts_abb_ground_troops/p4 "corner_open_right")
		(sleep 7)
		(vs_go_to_and_posture marine_01 FALSE pts_abb_ground_troops/p0 "corner_open_left")
		(sleep 3)
		(vs_go_to_and_posture marine_02 FALSE pts_abb_ground_troops/p2 "corner_open_right")
		
		(sleep_until (not (vs_running_atom_movement gr_allies)) 30 150)
		(cs_run_command_script allies_abb_pelican/pilot cs_abb_pelican_exits)
				
		(sleep_until (volume_test_players vol_abb_storm_in) 15 150)
		
		(sleep_until (volume_test_players vol_abb_shaft_entrance) 5 120)
		
		(vs_movement_mode gr_allies 2)
		(vs_face marine_01 true pts_abb_ground_troops_inside/face_inside)
		(vs_face marine_02 true pts_abb_ground_troops_inside/face_inside)
		(vs_face arbiter true pts_abb_ground_troops_inside/face_inside)		
		(vs_go_to_and_face marine_01 FALSE pts_abb_ground_troops_inside/p5 pts_abb_ground_troops_inside/face_inside)
		(sleep 30)
		(vs_go_to_and_face marine_02 FALSE pts_abb_ground_troops_inside/p3 pts_abb_ground_troops_inside/face_inside)
		(sleep 20)
		(vs_go_to_and_face arbiter FALSE pts_abb_ground_troops_inside/p1 pts_abb_ground_troops_inside/face_inside)
		(sleep_until (not (vs_running_atom_movement gr_allies)) 30 300)

	; cleanup
	(vs_release_all)
)*;

; ===================================================================================================================================================
(script dormant vd_stop_343_door_shocker
	(sleep_until 
		(or
			(script_finished vd_343_door_shocker)
			b_f1_ambiant_finished
		)
	)
	
	(if (not b_f1_ambiant_finished)
		(begin
			(vs_cast gr_guilty_spark TRUE 20 "")
			(set guilty_spark (vs_role 1))
			
			(vs_fly_to guilty_spark false pts_f1_waiting/p9)
			(unit_add_equipment (unit obj_guilty_spark) gs_profile true false)
			(sleep 1)
			(vs_shoot_point guilty_spark true pts_f1_waiting/shoot_at)
			
			(sleep 120)
			
			(vs_shoot_point guilty_spark false pts_f1_waiting/shoot_at)
			
			(set b_f1_ambiant_finished 1)
			
			(vs_release_all)
		)
	)
	
	(unit_add_equipment (unit obj_guilty_spark) no_weapon_profile true false)	
)

(script dormant vd_343_door_shocker
	(wake vd_stop_343_door_shocker)
	
	(if b_debug (print "vd:343:door:shocker"))

	; cast the actors
	(vs_cast ai_abb_pelican_marines_0 TRUE 20 "070VG_010")
		(set marine_01 (vs_role 1))
	(vs_cast ai_abb_pelican_marines_1 FALSE 20 "")
		(set marine_02 (vs_role 1))
	(vs_cast gr_guilty_spark TRUE 20 "070VG_020")
		(set guilty_spark (vs_role 1))
	(vs_cast gr_arbiter FALSE 20 "070VG_050")
		(set arbiter (vs_role 1))

	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies FALSE)
	(vs_enable_targeting gr_allies FALSE)
	(vs_enable_moving gr_allies FALSE)
	(vs_enable_pathfinding_failsafe guilty_spark TRUE)
	(vs_enable_looking guilty_spark FALSE)
	(vs_enable_targeting guilty_spark FALSE)
	(vs_enable_moving guilty_spark TRUE)

	(sleep 1)

		(vs_face arbiter TRUE pts_f1_waiting/face_door)
		(vs_go_to_and_face marine_01 FALSE pts_f1_waiting/p1 pts_f1_waiting/face_door)
		(vs_face marine_02 TRUE pts_f1_waiting/face_door)
		
		(vs_fly_to guilty_spark false pts_f1_waiting/p9)
		(unit_add_equipment (unit obj_guilty_spark) gs_profile true false)
		(sleep 1)
		(vs_shoot_point guilty_spark true pts_f1_waiting/shoot_at)
		
		(sleep_until (not (unit_is_playing_custom_animation marine_02)) 15 60)
		(vs_stop_custom_animation marine_02)
		(if b_dialogue (print "MARINE: Hey! What gives!"))
		(vs_play_line marine_01 TRUE 070VG_010)
				
		(set b_f1_allies_wait 1)
		(vs_shoot_point guilty_spark false pts_f1_waiting/shoot_at)
		
		(vs_go_to_and_face marine_01 FALSE pts_f1_waiting/p7 pts_f1_waiting/p3)
		(vs_go_to_and_face marine_02 FALSE pts_f1_waiting/p2 pts_f1_waiting/p3)
		(vs_face_object gr_allies true (ai_get_object guilty_spark))
		(sleep 10)
		
		(vs_face_object guilty_spark true (ai_get_object marine_01))
		
		(if b_dialogue (print "GUILTY: It seems I've crossed a circuit."))
		(sleep (ai_play_line_on_object guilty_spark 070VG_020))
		(sleep 10)
		
		(vs_draw marine_01)
		(if b_dialogue (print "MARINE: Well, let me have a look."))
		(vs_play_line marine_01 FALSE 070VG_030)
		(sleep 10)
		
		(vs_go_to marine_01 FALSE pts_f1_waiting/p8)
				
		(sleep_until (<= (objects_distance_to_object (ai_actors marine_01) guilty_spark) 1.5) 10 150)
				
		;Only play the shocker part if the marine made it to that area
		(if (<= (objects_distance_to_object (ai_actors marine_01) (unit guilty_spark)) 2)
			(begin
				;GS SHOCKING EFFECT
				(vs_shoot guilty_spark true marine_01)
				;(sound_impulse_start "sound\characters\sentinel\sent_laser_impact" gs_shocker 10)
				(sleep 20)
				(if b_dialogue (print "MARINE: (yelp)"))
				(vs_play_line marine_01 FALSE 070VG_040)
				(vs_stow marine_01)
				(sleep 1)
				(vs_custom_animation marine_01 TRUE "objects\characters\marine\marine" "combat:rifle:stunned_back" false)
				(vs_stop_custom_animation marine_01)
				(vs_shoot guilty_spark false marine_01)
				(sound_impulse_stop "sound\characters\sentinel\sent_laser_impact")
				(sleep 30)
				(vs_stop_custom_animation marine_01)
		
				(vs_face_object gr_allies true (ai_get_object guilty_spark))
				
				(if (not (game_is_cooperative))
					(begin
						(vs_go_to_and_face arbiter FALSE pts_f1_waiting/p11 pts_f1_waiting/p10)
						(if b_dialogue (print "ARBITER: Oracle!"))
						(vs_play_line arbiter TRUE 070VG_050)
						(sleep 10)
					)
				)
				
				(vs_go_to_and_face marine_02 FALSE pts_f1_waiting/p12 pts_f1_waiting/p10)
				
				(if b_dialogue (print "MARINE: Little bastard stung me!"))
				(vs_play_line marine_01 TRUE 070VG_060)
				(sleep 10)
		
				(if b_dialogue (print "GUILTY: I did not want you to come to any harm."))
				(sleep (ai_play_line_on_object guilty_spark 070VG_080))
				(sleep 10)
		
				(vs_shoot_point guilty_spark true pts_f1_waiting/shoot_at)
				
				(if b_dialogue (print "MARINE: Got a funny way of showing it..."))
				(vs_play_line marine_01 TRUE 070VG_090)
				(sleep 90)
				
				(vs_shoot_point guilty_spark false pts_f1_waiting/shoot_at)
			)
		)
		
	(unit_add_equipment (unit obj_guilty_spark) no_weapon_profile true false)

	; cleanup
	(vs_release_all)
	
	(set b_f1_ambiant_finished 1)
)

; ===================================================================================================================================================
(global boolean b_f1_gs_advance 0)

(script dormant f1_stop_sleeping_grunts
	(sleep_until
		(or
			(> (ai_combat_status cov_f1_grt_pack) 2)
			(<= (ai_living_count cov_f1_grt_pack) 0)
		)
	)
		
	(sleep_forever md_f1_sleeping_grunts)
	(cs_run_command_script gr_guilty_spark cs_end)
	(cs_run_command_script gr_allies cs_end)
)

(script dormant md_f1_sleeping_grunts
	(if b_debug (print "mission dialogue:f1:sleeping:grunts"))
	(wake f1_stop_sleeping_grunts)
	
	; cast the actors
	(vs_cast gr_allies FALSE 10 "070ML_010" "070ML_030" "")
		(set arbiter (vs_role 1))
		(set marine_01 (vs_role 2))
		(set marine_02 (vs_role 3))
	(vs_cast gr_guilty_spark FALSE 20 "070MH_080")
		(set guilty_spark (vs_role 1))
		
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies TRUE)
	(vs_enable_targeting gr_allies FALSE)
	(vs_enable_moving gr_allies FALSE)
	(vs_shoot gr_allies FALSE)
		
	(sleep 1)
	
		(if b_dialogue (print "GUILTY: Excellent! This way!"))
		(sleep (ai_play_line_on_object guilty_spark 070MH_080))
		(sleep 10)
		
		(vs_enable_moving gr_guilty_spark TRUE)
	
		(vs_draw marine_01)
		(sleep 6)
		(vs_draw marine_02)
		(sleep 8)
		(vs_draw arbiter)
		
		(set b_f1_gs_advance 1)
	
		;(vs_abort_on_combat_status 4)
		
		(sleep 90)
		
		(if (not (game_is_cooperative))
			(begin			
				(if b_dialogue (print "ARBITER (whisper): Slothful runts"))
				(vs_play_line arbiter TRUE 070ML_010)
				(sleep 10)
		
				(if b_dialogue (print "ARBITER (whisper): Kill them as they sleep."))
				(vs_play_line arbiter TRUE 070ML_020)
				(sleep 10)
			)
			
			(begin
				(if b_dialogue (print "MARINE (whisper): We got sleepers!"))
				(vs_play_line marine_01 TRUE 070ML_030)
			)
		)
		
		(vs_crouch gr_allies true 2)
		
		(sleep 30)

		(if b_dialogue (print "MARINE (whisper): Chief! Tap 'em out!"))
		(vs_play_line marine_01 TRUE 070ML_040)
		(sleep 7)
		
		(vs_enable_moving gr_allies TRUE)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_f1_after_f1
	(sleep_until 
		(or
			b_f1_combat_finished
			(>= s_f1_progression 30)
		)
	)
	
	;Have GS guide you with interior distance values
	(set s_gs_walkup_dist 3)
	(set s_gs_talking_dist 4)
	(if b_dialogue (print "GUILTY: The Cartographer is a few floors down!"))
	(set g_gs_1st_line 070MJ_090)
	(if b_dialogue (print "GUILTY: Come, Reclaimer! All you seek is close at hand!"))
	(set g_gs_2nd_line 070MJ_100)
	(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
	
	(sleep_until b_f2_has_started 30 3600)
	(if (not b_f2_has_started)
		(begin
			(sleep_until (not b_playing_dialogue))
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
			
			(if b_debug (print "mission dialogue:f1:jon:next"))
		
			(if b_dialogue (print "JOHNSON (radio): Keep going, Chief! Meet you further down the spire!"))
			(sleep (ai_play_line_on_object NONE 070MJ_050))
			(sleep 10)
		
			(if b_dialogue (print "JOHNSON (radio): Commander rounded up some air-support"))
			(sleep (ai_play_line_on_object NONE 070MJ_060))
			(sleep 10)
		
			(if b_dialogue (print "JOHNSON (radio): They'll stop any hostile reinforcements"))
			(sleep (ai_play_line_on_object NONE 070MJ_070))
			(sleep 10)
		
			(if b_dialogue (print "JOHNSON (radio): But the Brutes already inside? They're all yours!"))
			(sleep (ai_play_line_on_object NONE 070MJ_080))
			(md_dialogue_stop)
		
		
			(hud_activate_team_nav_point_flag player flg_f1_next 0)
			(sleep_until b_f2_has_started)
			(hud_deactivate_team_nav_point_flag player flg_f1_next)
		)
	)
	
	;GS doesn't guide the player anymore
	(cs_run_command_script gr_guilty_spark cs_end)
	(set b_gs_follow_player 0)
)

; ===================================================================================================================================================
;*DIALOG_TEMP
(script dormant md_f2_allies_explore
	(if b_debug (print "mission dialogue:f2:allies:explore"))

		; cast the actors
		(vs_cast SQUAD TRUE 10 "070MK_010" "070MK_040")
			(set marine (vs_role 1))
			(set arbiter (vs_role 2))

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies TRUE)
	(vs_enable_targeting gr_allies TRUE)
	(vs_enable_moving gr_allies TRUE)

	(sleep 1)

		(if b_dialogue (print "MARINE: Whoa! What's that smell?"))
		(vs_play_line marine TRUE 070MK_010)
		(sleep 10)

		(if b_dialogue (print "MARINE: Brutes, man. Must be where they...eat."))
		(vs_play_line marine TRUE 070MK_020)
		(sleep 10)

		(if b_dialogue (print "MARINE: Yeah? Then where are they?"))
		(vs_play_line marine TRUE 070MK_030)
		(sleep 10)

		(if b_dialogue (print "ARBITER: Close. This stench is fresh."))
		(vs_play_line arbiter TRUE 070MK_040)
		(sleep 10)

		(if b_dialogue (print "ARBITER: Watch the exits!"))
		(vs_play_line arbiter TRUE 070MK_050)
		(sleep 10)

		(if b_dialogue (print "MARINE: Dunno. But I'd watch those doors!"))
		(vs_play_line marine TRUE 070MK_060)
		(sleep 10)

	; cleanup
	(vs_release_all)
)
*;
; ===================================================================================================================================================

(script dormant f2_intro_stop_dialogs
	(ai_dialogue_enable false)
	(sleep_until 
		(or
			(>= (ai_combat_status gr_cov_f2) 2)
			(<= (ai_living_count gr_cov_f2) 0)
			(>= s_f3_p1_progression 10)
		)
	)
	(ai_dialogue_enable true)
	(set b_f2_combat_started 1)
)

; ===================================================================================================================================================
(script command_script cs_070vh_access_denied
	(cs_enable_moving true)
	(sleep_until (volume_test_object vol_f2_near_terminal obj_guilty_spark) 30 1800)
	
	(if (volume_test_object vol_f2_near_terminal obj_guilty_spark)
		(begin
			(sleep 300)
			
			(if b_dialogue (print "GUILTY: Sincere apology. But how did you survive?"))
			(cs_play_line 070VH_020)
			(sleep 10)
			
			(if b_dialogue (print "GUILTY: The archive is intact?! Then our makers’ plan --"))
			(cs_play_line 070VH_030)
			(sleep 10)
			
			(if b_dialogue (print "GUILTY: A what?"))
			(cs_play_line 070VH_040)
			(sleep 10)
			
			(if b_dialogue (print "GUILTY: A Foundry? For what purpose?"))
			(cs_play_line 070VH_050)
			(sleep 10)
		)
	)
		
	(set b_f2_gs_terminal 0)
)
; ===================================================================================================================================================

(script dormant md_f2_gs_next
	;Have GS guide you...
	(sleep_until
		(or
			;if his dialog is said
			(not b_f2_gs_terminal)
			;or if the player reached the terminal
			(volume_test_players vol_f2_terminal)
			;or if everyone is dead
			(<= (ai_living_count gr_cov_f2) 1)
			;or if he continued too far
			(>= s_f2_progression 60)
		)
	)
	
	(if b_debug (print "mission dialogue:f2:gs:next"))
	
	;Have GS guide you with interior distance values
	(set s_gs_walkup_dist 3)
	(set s_gs_talking_dist 4)
	(if b_dialogue (print "GUILTY: Reclaimer? Continue downward!"))
	(set g_gs_1st_line 070MK_070)
	(if b_dialogue (print "GUILTY: Your goal is just below!"))
	(set g_gs_2nd_line 070MK_080)
	(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
	
	(sleep_until b_f3_has_started 30 3600)
	(if (not b_f3_has_started)
		(begin
			(hud_activate_team_nav_point_flag player flg_f2_next 0)
			(sleep_until b_f3_has_started)
			(hud_deactivate_team_nav_point_flag player flg_f2_next)
		)
	)
	
	;GS doesn't guide the player anymore
	(cs_run_command_script gr_guilty_spark cs_end)
	(set b_gs_follow_player 0)
)

; ===================================================================================================================================================

(script dormant md_f3_gs_hit_switch
	(sleep_until 
		(and 
			(>= s_f3_p1_progression 40)
			(volume_test_object vol_f3_outside obj_guilty_spark)
			(not (volume_test_object vol_f3_outside gr_cov_f3))
		)
	)
	
	(sleep (random_range 60 120))

	(if b_debug (print "mission dialogue:f3:gs:hit:switch"))

	; cast the actors
	(vs_cast gr_guilty_spark TRUE 20 "070ML_050")
		(set guilty_spark (vs_role 1))
	(vs_cast gr_arbiter FALSE 10 "")
		(set arbiter (vs_role 1))
		
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)

	; movement properties
	(vs_enable_pathfinding_failsafe arbiter TRUE)
	(vs_enable_looking arbiter TRUE)
	(vs_enable_targeting arbiter TRUE)
	(vs_enable_moving arbiter TRUE)
	(vs_enable_pathfinding_failsafe guilty_spark TRUE)
	(vs_enable_looking guilty_spark TRUE)
	(vs_enable_targeting guilty_spark TRUE)
	(vs_enable_moving guilty_spark TRUE)

	(sleep 1)
		
		(if (<= (ai_living_count obj_f3_cov_p1) 0)
			(begin
				(vs_enable_moving arbiter FALSE)
				(vs_go_to_and_face arbiter FALSE pts_f3_arbiter/guide pts_f3_arbiter/face_at)
			)
		)
		
		(if b_dialogue (print "GUILTY: The Cartographer!"))
		(sleep (ai_play_line_on_object guilty_spark 070ML_050))
		(sleep 10)		

		(if b_dialogue (print "GUILTY: Come! It awaits your approval!"))
		(sleep (ai_play_line_on_object guilty_spark 070ML_060))

	; cleanup
	(vs_release guilty_spark)
	
	;Have GS guide you with exterior distance values
	(set s_gs_walkup_dist 4)
	(set s_gs_talking_dist 6)
	(set g_gs_1st_line 070ML_080)
	(if b_dialogue (print "GUILTY: You must activate the Cartographer, Reclaimer."))
	(set g_gs_2nd_line 070ML_080)
	(cs_run_command_script f3_p1_guilty_spark cs_guilty_spark_lead_player)
	
	(sleep_until 
		(or
			(< (device_get_position 070LC_start) 0.95)
			b_f3_p2_started
		)
	)
)

; ===================================================================================================================================================

(script dormant f3_shutdown_halogram
	(sleep 90)
	;Place back the halogram in place
	(device_operates_automatically_set f3_cartographer_device 0)
	(device_set_position f3_cartographer_device 0)
)

;Wait until a player activates the cinematic
(script dormant f3_070LC_start
	;Wait until player is outside
	(sleep_until 
		(and
			(= (current_zone_set_fully_active) 10)
			(>= s_f3_p1_progression 40)
		)
	)
	
	(sleep_until (< (device_get_position 070LC_start) 0.95) 1 3600)
	(if (>= (device_get_position 070LC_start) 0.95)
		(begin
			(hud_activate_team_nav_point_flag player flg_f3_switch 0)		
			(sleep_until (< (device_get_position 070LC_start) 0.95) 1)
			(hud_deactivate_team_nav_point_flag player flg_f3_switch)
		)
	)
	
	;Stop 070_music_12
	(set b_070_music_12 0)
	
	(sleep_forever md_f3_gs_hit_switch)
	(sleep_forever md_f3_gs_secret_dialog)
	
	;Register how much marines we had left before killing them
	(set s_f3_marine_count (ai_living_count gr_marines))	
	(ai_erase allies_f3_arbiter_follow)
	(ai_erase gr_guilty_spark)
	
	(wake f3_shutdown_halogram)
	
	(if b_debug (print "070LC_waypoint_reveal"))
	(cinematic_fade_to_black)
	; hide everybody
	(object_hide gr_guilty_spark TRUE)
	(object_hide gr_arbiter TRUE)
	(object_hide allies_f3_p1_mar_0 true)
	(object_hide allies_f3_p1_mar_1 true)
	
	(if b_cinematic 
		(begin
			(if (cinematic_skip_start)
				(begin
					(data_mine_set_mission_segment "070_LC_waypoint_reveal")										
					(070lc_waypoint_reveal)									
				)
			)
			(cinematic_skip_stop)
			(070lc_waypoint_reveal_cleanup)					
		)
	)
	
	(cinematic_stop)
	(camera_control off)
	
	; show everybody		
	(object_hide gr_guilty_spark FALSE)
	(object_hide gr_arbiter FALSE)
	(object_hide allies_f3_p1_mar_0 false)
	(object_hide allies_f3_p1_mar_1 false)	
	(object_teleport (player0) flg_f3_after_070LC_0)
	(object_teleport (player1) flg_f3_after_070LC_1)
	(object_teleport (player2) flg_f3_after_070LC_2)
	(object_teleport (player3) flg_f3_after_070LC_3)
	
	(wake f3_070LC_after)
)

; ===================================================================================================================================================

(global ai phantom NONE)

(script dormant md_f3_arb_boards_banshee
	;DIALOG_TEMP - account for Coop
	
	(if b_debug (print "mission dialogue:f3:arb:boards:banshee"))

	; cast the actors
	(vs_cast gr_arbiter FALSE 10 "070ML_110")
		(set arbiter (vs_role 1))

	; movement properties
	(vs_enable_looking arbiter TRUE)
	
	(sleep 1)
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
			
	(if b_dialogue (print "JOHNSON (radio): Chief! You got a whole mess of hostile air inbound!"))
	(ai_play_line_on_object NONE 070ML_090)

	(ai_magically_see arbiter cov_f3_banshee_0)
	(vs_shoot arbiter true (ai_get_object cov_f3_phantom))
	(vs_go_to arbiter TRUE pts_f3_arbiter/p0)
	(sleep 45)
		
	(if b_dialogue (print "JOHNSON (radio): Get back inside while we take 'em out!"))
	(ai_play_line_on_object NONE 070ML_100)
	(vs_go_to arbiter TRUE pts_f3_arbiter/p1)
	(sleep 45)
	
	(if b_dialogue (print "ARBITER (radio): Follow the Oracle, Spartan!"))
	(ai_play_line_on_object NONE 070ML_110)
	(vs_shoot arbiter true (ai_get_object cov_f3_banshee_0))
	(vs_go_to arbiter TRUE pts_f3_arbiter/p2)
	(sleep 40)
	
	;Phantom stops shooting so you can see the arbiter board
	(cs_run_command_script (ai_get_turret_ai cov_f3_phantom 0) cs_do_nothing)
	(cs_run_command_script cov_f3_phantom/grunt_0 cs_do_nothing)
	(cs_run_command_script cov_f3_phantom/grunt_1 cs_do_nothing)
		
	(vs_jump arbiter FALSE 85 2)
	(sleep 20)
	(if b_dialogue (print "ARBITER (radio): I will help your Sergeant clear the skies!"))
	(ai_play_line_on_object NONE 070ML_120)	
	
	(md_dialogue_stop)
	
	(unit_enter_vehicle (ai_get_unit arbiter) (ai_vehicle_get_from_starting_location cov_f3_banshee_0/pilot) "banshee_b_d")
	(sleep 45)
	(unit_board_vehicle (ai_get_unit arbiter) "banshee_b_d")
	(ai_cannot_die cov_f3_banshee_0 false)
	(ai_kill cov_f3_banshee_0)
	(chud_show_arbiter_ai_navpoint false)
	
	;Did the arbiter make it in the banshee?
	(if (unit_in_vehicle arbiter)
		(begin
			(vs_enable_pathfinding_failsafe arbiter true)
			(vs_fly_to arbiter TRUE pts_f3_arbiter/p3)
			(set b_f3_p2_gs_guide 1)
			(vs_shoot arbiter true)
			(vs_enable_targeting arbiter TRUE)
			
			(vs_cast cov_f3_phantom/pilot TRUE 10 "")
				(set phantom (vs_role 1))
			(vs_vehicle_speed phantom 0.3)
			(vs_fly_to_and_face phantom FALSE pts_f3_phantom/p2 pts_f3_phantom/face_0 1)
			
			
			;Flyout - the arbiter chases the phantom
			;phantom retreats...	
			(vs_enable_pathfinding_failsafe phantom true)
			(vs_enable_looking phantom true)
			(vs_vehicle_speed phantom 0.8)
			(vs_vehicle_speed arbiter 0.5)
			(vs_shoot arbiter true (ai_get_object cov_f3_phantom))
			(vs_fly_to arbiter FALSE pts_f3_banshee/p6)
			
			(sleep 60)	
			(vs_fly_to phantom TRUE pts_f3_phantom/p3 1)
			(kill_players_in_volume vol_f3_kill_players)
			
			(vs_face phantom true pts_f3_phantom/p4)
		
			(if (<= s_f3_p2_progression 20)
				(begin
					;Have GS guide you with exterior distance values
					(set s_gs_walkup_dist 4)
					(set s_gs_talking_dist 6)
					(set g_gs_1st_line 070ML_250)
					(set g_gs_2nd_line 070ML_260)
					(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
				)
			)
			
				
			;Arbiter chases the phantom	
			(vs_vehicle_speed phantom 0.8)
			(vs_vehicle_speed arbiter 1)
			(vs_fly_to arbiter FALSE pts_f3_banshee/p4)
			(vs_fly_to phantom FALSE pts_f3_phantom/p4 1)
			
			(sleep_until 
				(and
					(not (vs_running_atom_movement arbiter))
					(not (vs_running_atom_movement phantom))
				)
			10 900)
			
			(vs_fly_to arbiter FALSE pts_f3_banshee/p5)
			(vs_fly_to phantom FALSE pts_f3_phantom/p5 1)
			
			(sleep_until 
				(and
					(not (vs_running_atom_movement arbiter))
					(not (vs_running_atom_movement phantom))
				)
			30 1800)	
			
			(ai_erase cov_f3_banshee_0)
			(ai_erase allies_f3_arbiter)
			(ai_erase cov_f3_phantom)
		
		)
		(begin
			;Arbiter didn't make it in his banshee, make him disappear
			(vs_shoot arbiter false (ai_get_object cov_f3_banshee_0))
			(unit_set_active_camo arbiter true 5)
			(chud_show_arbiter_ai_navpoint false)
			(sleep 150)
			(ai_erase allies_f3_arbiter)
			
			(set b_f3_p2_gs_guide 1)
			
			(vs_cast cov_f3_phantom/pilot TRUE 10 "")
				(set phantom (vs_role 1))
			(vs_vehicle_speed phantom 0.3)
			(vs_fly_to_and_face phantom FALSE pts_f3_phantom/p2 pts_f3_phantom/face_0 1)
			
			
			;Flyout - the phantom retreats alone...	
			(vs_enable_pathfinding_failsafe phantom true)
			(vs_enable_looking phantom true)
			(vs_vehicle_speed phantom 0.8)
			
			(sleep 60)	
			(vs_fly_to phantom TRUE pts_f3_phantom/p3 1)
			(kill_players_in_volume vol_f3_kill_players)
			
			(vs_face phantom true pts_f3_phantom/p4)
		
			(if (<= s_f3_p2_progression 20)
				(begin
					;Have GS guide you with exterior distance values
					(set s_gs_walkup_dist 4)
					(set s_gs_talking_dist 6)
					(set g_gs_1st_line 070ML_250)
					(set g_gs_2nd_line 070ML_260)
					(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
				)
			)
			
				
			;Arbiter chases the phantom	
			(vs_vehicle_speed phantom 0.8)
			(vs_fly_to phantom FALSE pts_f3_phantom/p4 1)
			
			(sleep_until (not (vs_running_atom_movement phantom)) 10 900)
			
			(vs_fly_to phantom FALSE pts_f3_phantom/p5 1)
			
			(sleep_until (not (vs_running_atom_movement phantom)) 30 1800)	
			
			(ai_erase cov_f3_banshee_0)			
			(ai_erase cov_f3_phantom)		
		)
	)	
	
	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_f3_marines_ambushed
	(if b_debug (print "mission dialogue:f3:marines:ambushed"))	

	; cast the actors
	(vs_cast allies_f3_marine TRUE 10 "070MX_040")
		(set marine_01 (vs_role 1))
		
	; movement properties
	(vs_enable_looking marine_01 false)
	(vs_enable_targeting marine_01 false)
	(vs_enable_moving marine_01 false)
	
	(sleep_until
		(or
			(>= s_f3_p2_progression 10)
			b_f3_p2_take_combat_outside
		)
	30 900)
	
	; movement properties
	(vs_enable_pathfinding_failsafe marine_01 true)
	(vs_enable_looking marine_01 true)
	(vs_enable_targeting marine_01 false)
	(vs_enable_moving marine_01 true)

	(sleep 150)
	
	(sleep_until (not b_playing_dialogue) 30 300)	
	
	; block all other mission dialogue scripts 
	(sleep 30)
	(vs_set_cleanup_script md_cleanup)
	(md_dialogue_start)
	
	(if b_dialogue (print "MARINE: Sir! Pelican's gonna land one level down!"))
	(sleep (ai_play_line_at_player marine_01 070MX_040))
	(sleep 4)
	
	(md_dialogue_stop)
	
	(set b_f3_objective_dialog_done 1)
	
	(sleep_until 
		(or
			(>= s_f3_p2_progression 20)
			b_f3_p2_take_combat_outside
		)
	)
	
	(sleep 60)
	
	(vs_enable_targeting marine_01 true)
	
	(if (< s_f3_p2_progression 30)
		(begin
			(sleep_until (not b_playing_dialogue) 30 150)
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
			
			(if b_dialogue (print "MARINE (whisper): Tracker's reading multiple contacts"))
			(sleep (ai_play_line marine 070MJ_010))
			(sleep 10)
		
			(if b_dialogue (print "MARINE (whisper): We got a welcome party!"))
			(sleep (ai_play_line marine 070MJ_020))
			(sleep 10)
		)
	)	
	(vs_release_all)	
)

; ===================================================================================================================================================

(global ai brute NONE)

(script dormant md_f3_marine_stuck
	(if b_debug (print "mission dialogue:f3:marine:stuck"))

	; cast the actors
	(vs_cast allies_f3_mar_wasted false 10 "")
		(set marine_02 (vs_role 1))
	(vs_cast cov_f3_p2_pack/intro_grunt true 10 "")
		(set brute (vs_role 1))
	
	(if (>= (ai_living_count allies_f3_mar_wasted) 0)
		(begin
			; movement properties
			(vs_enable_pathfinding_failsafe marine_02 TRUE)
			(vs_enable_looking marine_02 FALSE)
			(vs_enable_targeting marine_02 FALSE)
			(vs_enable_moving marine_02 FALSE)
			(vs_enable_looking brute FALSE)
			(vs_enable_targeting brute FALSE)
			(vs_enable_moving brute FALSE)	
		
			(vs_face marine_02 true pts_f3_marine_1/face)
			
			(sleep_until 
				(or
					(>= s_f3_p2_progression 10)
					b_f3_p2_take_combat_outside
				)
			1)
			
			(vs_go_to marine_02 false pts_f3_marine_1/start)
			
			(vs_face marine_02 false pts_f3_marine_1/face)
			(vs_crouch marine_02 true)
			(vs_shoot_point marine_02 true pts_f3_stuck_vignette/shoot_at)
		
			(sleep_until 
				(or
					(>= s_f3_p2_progression 20)
					b_f3_p2_take_combat_outside
				)
			1)
			
			(sleep 15)
			
			;Throw a grenade at the marine
			(vs_grenade brute FALSE pts_f3_stuck_vignette/throw_at 1)
			(sleep 60)
			(vs_shoot marine_02 false)
			(vs_crouch marine_02 false)
			
			(vs_enable_looking brute true)
			(vs_enable_targeting brute true)
			
			(sleep 45)
			
			; cleanup
			(vs_release_all)
		)
	)
)

; ===================================================================================================================================================

(script dormant md_f3_jon_next
	(sleep_until 
		(or
			b_f3_p2_take_combat_outside
			(>= s_f3_p2_progression 40)
		)
	)
	
	(if (< s_f3_p2_progression 40)
		(begin
			(sleep_until (not b_playing_dialogue) 30 150)
			; block all other mission dialogue scripts 
			(sleep 1)
			(vs_set_cleanup_script md_cleanup)
			(md_dialogue_start)
	
			(if b_debug (print "mission dialogue:f3:jon:next"))
			
			(if b_dialogue (print "JOHNSON (radio): Head downstairs, Chief!"))
			(sleep (ai_play_line_on_object NONE 070ML_130))
			(sleep 10)
	
			(if b_dialogue (print "JOHNSON (radio): We'll have to land on the ledge below!"))
			(sleep (ai_play_line_on_object NONE 070ML_140))
		)
	)
)

; ===================================================================================================================================================

(script dormant md_f3_gs_secret_dialog
	(sleep_until (>= s_f3_p2_progression 40) 5)
	
	(sleep (random_range 30 180))
	
	(if b_debug (print "mission dialogue:f3:gs:secret:dialog"))

	; cast the actors
	(vs_cast gr_guilty_spark TRUE 10 "070MM_010")
		(set guilty_spark (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe guilty_spark TRUE)
	(vs_enable_looking guilty_spark TRUE)
	(vs_enable_targeting guilty_spark TRUE)
	(vs_enable_moving guilty_spark TRUE)

	(sleep 1)

		(if b_dialogue (print "GUILTY (quiet, excited): Protocol dictates action! "))
		(sleep (ai_play_line_on_object guilty_spark 070MM_010))
		(sleep 10)

		(if b_dialogue (print "GUILTY (quiet, excited): The installation was my responsibility..."))
		(sleep (ai_play_line_on_object guilty_spark 070MM_020))
		(sleep 10)

		(if b_dialogue (print "GUILTY (quiet, excited): If my suspicions are correct"))
		(sleep (ai_play_line_on_object guilty_spark 070MM_030))
		(sleep 10)

		(if b_dialogue (print "GUILTY (quiet, excited): No! I must not leap to any conclusions!"))
		(sleep (ai_play_line_on_object guilty_spark 070MM_040))

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
(script dormant f5_stop_truth_halogram
	(sleep_until 
		(or
			(<= (object_get_health f5_holo_generator) 0)
			b_truth_speech_finished
		)
	10)
	(sleep_forever f5_truth_halogram)
	(sound_impulse_stop "sound\dialog\070_waste\mission\070MY_070_pot.sound")
	(sound_impulse_stop "sound\dialog\070_waste\mission\070my_080_pot.sound")
)

(script dormant f5_truth_halogram
	(set b_truth_speech_finished 0)
	(wake f5_stop_truth_halogram)
	
	(object_create_anew f5_truth_scenery)
	(object_create_anew f5_grav_throne)
	(object_create_anew f5_holo_generator)
	
	(object_set_function_variable f5_truth_scenery bloom 0.5 30)
	(object_set_function_variable f5_grav_throne bloom 0.5 30)
	
	(objects_attach f5_truth_scenery "driver" f5_grav_throne "driver")
	(objects_attach f5_holo_generator "attach_marker" f5_truth_scenery "")	
	
	;(objects_attach f5_holo_generator "attach_marker" truth_biped "")
	;(objects_attach truth_biped "driver" f5_grav_throne "driver")
	
	(sleep_until 
		(or
			(volume_test_players vol_f5_challenge_ring)
			(>= s_f5_progression 30)
			b_f5_chieftain_charge
		)
	)
	
	(sleep (random_range 90 150))
	
	(if b_dialogue (print "TRUTH: You must win this fight on your own!"))
	(scenery_animation_start f5_truth_scenery objects\characters\truth\cinematics\truth_holos\070_truth_c\070_truth_c.model_animation_graph "070_truth_c")
	(sound_impulse_start sound\dialog\070_waste\mission\070MY_070_pot f5_truth_scenery 1)
	(sleep (sound_impulse_language_time sound\dialog\070_waste\mission\070MY_070_pot))
	
	(sleep 30)
	
	(if b_dialogue (print "TRUTH: Failure will bring a fate worse than death: abandonment as we step forward without you!"))
	(scenery_animation_start f5_truth_scenery objects\characters\truth\cinematics\truth_holos\070_truth_c\070_truth_c.model_animation_graph "070_truth_c2")
	(sound_impulse_start sound\dialog\070_waste\mission\070MY_080_pot f5_truth_scenery 1)
	(sleep (sound_impulse_language_time sound\dialog\070_waste\mission\070MY_080_pot))
	
	(sleep 45)	
	(070_truth_flicker f5_grav_throne f5_truth_scenery)
	(object_destroy f5_truth_scenery)
	(object_destroy f5_grav_throne)
	
	(set b_truth_speech_finished 1)
)

; ===================================================================================================================================================

(script dormant md_f5_jon_pelican_eta
	(sleep_until (<= (ai_living_count cov_f5_brt_chieftain) 0) 30 600)
	
	(if b_debug (print "mission dialogue:f5:jon:pelican:eta"))

	(sleep 1)
	
	; block all other mission dialogue scripts 
	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	
	(md_dialogue_start)
	(if b_dialogue (print "JOHNSON (radio): Hang tight, Chief! We're on our way!"))
	(sleep (ai_play_line_on_object NONE 070MM_070))
	(md_dialogue_stop)
	
	;Stop 070_music_13
	(set b_070_music_13 0)
	
	(sleep_until b_f5_combat_finished)
	
	(sleep (random_range 30 150))
	
	(md_dialogue_start)
	(if b_dialogue (print "JOHNSON (radio): ETA: damn quick! Standby for pickup!"))
	(sleep (ai_play_line_on_object NONE 070MM_080))
	(md_dialogue_stop)
)

; ===================================================================================================================================================

;Wait until a player activates the cinematic
(script dormant f5_070LD_start	
	(objective_4_clear)
	
	(data_mine_set_mission_segment "070_LD_pelican_pickup")										
					
	;(object_teleport (player0) flg_teleport_player_0)  ;Put the players somewhere safe and hide them
	;(object_teleport (player1) flg_teleport_player_1)
	;(object_teleport (player2) flg_teleport_player_2)
	;(object_teleport (player3) flg_teleport_player_3)	
	
	(cinematic_fade_to_black)
	
	(game_award_level_complete_achievements)
	
	(ai_erase gr_npc)
	
	;Delete the flocks for cinematic
	(background_shaft_cleanup)
	
	;Cleanup goes here
	(add_recycling_volume vol_f5_cin_cleanup 0 0)
	
	(if b_cinematic
		(begin			
			(if (cinematic_skip_start)
				(begin
					(070ld_pelican_pickup)
				)
			)
			(cinematic_skip_stop)
			(070ld_pelican_pickup_cleanup)
		)
	)	

	;Stop music F5 03
	;(set b_070_music_f5_03 0)
	;Start music F5 05
	;(set b_070_music_f5_05 1)
	
	(sound_class_set_gain "" 0 0)
	
	(sleep 5)
	(end_mission)
)

; ===================================================================================================================================================


; ===================================================================================================================================================
; AMBIANT RADIO
; ===================================================================================================================================================
(script static void sleep_ex_radio_delay
	(sleep (random_range 90 450))
)

(script static boolean ex_play_radio_0_condition
	(and
		(<= (objects_distance_to_object (players) ex_radio_0) 12)
		(> (objects_distance_to_object (players) ex_radio_0) 0)
	)
)

(script static boolean ex_play_radio_1_condition	
	(and
		(<= (objects_distance_to_object (players) ex_radio_1) 15)
		(> (objects_distance_to_object (players) ex_radio_1) 0)
	)
)

(script static boolean ex_play_brute_radio_condition	
	(and
		(<= (objects_distance_to_object (players) ex_brute_radio) 15)
		(> (objects_distance_to_object (players) ex_brute_radio) 0)
	)
)

(script static boolean ex_play_radio_condition
	(or
		(ex_play_radio_0_condition)
		(ex_play_radio_1_condition)
 	)
)

(script static void (ex_play_radio (ai_line line))
	(if (ex_play_radio_0_condition)
		(sleep (ai_play_line_on_object ex_radio_0 line))
	)
	(if (ex_play_radio_1_condition)
		;Sleep only once (ugly!)
		(if (ex_play_radio_0_condition)
			(ai_play_line_on_object ex_radio_1 line)
			(sleep (ai_play_line_on_object ex_radio_1 line))
		)
	)	
)

(script static void (ex_play_brute_radio (ai_line line))
	(ai_play_line_on_object ex_brute_radio line)
	(sleep (ai_play_line_on_object ex_brute_radio line))
)

(script dormant md_ambiant_radio_stop
	(sleep_until b_fl_frigate_arrived)
	
	(sleep_forever md_ambiant_radio)
)

(script dormant md_ambiant_radio
	(wake md_ambiant_radio_stop)
	
	(object_create_anew ex_radio_0)
	(object_create_anew ex_radio_1)
	(sleep 1)
	
	(sound_looping_start sound\materials\gear\high_ground_radio\high_ground_radio ex_radio_0 1)
	(sound_looping_start sound\materials\gear\high_ground_radio\high_ground_radio ex_radio_1 1)
	
	(sleep_until (ex_play_radio_condition))
	
	(begin_random
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Got a lock! Fox-fox!"))
			(ex_play_radio 070MZ_130)
			(sleep 15)
			(if b_debug (print "Negative! Protect the Pelicans!"))
			(ex_play_radio 070MZ_080)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Fire pods one through twelve! Archers away!"))
			(ex_play_radio 070MZ_030)
		)				
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "New contacts at point two three eight!"))
			(ex_play_radio 070MZ_060)
			(sleep 30)
			(if b_debug (print "Affirmative! I see it!"))
			(ex_play_radio 070MZ_120)
			(sleep 15)
			(if b_debug (print "No! I will handle those myself!"))
			(ex_play_radio 070MZ_220)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Stay away from those cruisers!"))
			(ex_play_radio 070MZ_150)
			(sleep 15)
			(if b_debug (print "Understood! Engage those Seraphs!"))
			(ex_play_radio 070MZ_070)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Let the Elites handle the cruisers!"))
			(ex_play_radio 070MZ_090)
			(sleep 60)
			(if b_debug (print "Full shields! Ramming speed!"))
			(ex_play_radio 070MZ_260)
		)		
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Seraphs! On my six!"))
			(ex_play_radio 070MZ_110)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Splash one! Coming about!"))
			(ex_play_radio 070MZ_140)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Hit them again! And again! And again!"))
			(ex_play_radio 070MZ_280)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Let your cannons roar!"))
			(ex_play_radio 070MZ_210)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Broadside! What fools to face our guns!"))
			(ex_play_radio 070MZ_300)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Now! Close and finish!"))
			(ex_play_radio 070MZ_270)
			(sleep 20)
			(if b_debug (print "Negative! Get out of there!"))
			(ex_play_radio 070MZ_160)
		)
	)
	;Trouble begins...
	(begin_random
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Watch your fire! Watch your fire!"))
			(ex_play_radio 070MZ_100)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Point-laser fire! Break off!"))
			(ex_play_radio 070MZ_170)
			(sleep 60)
			(if b_debug (print "I'm hit! I'm hit!"))
			(ex_play_radio 070MZ_180)
		)		
	)
	
	;The fighter pilot dies...
	(begin
		(sleep_until (ex_play_radio_condition))
		(sleep_ex_radio_delay)
		(if b_debug (print "Lost avionics. Gonna try and hit their carrier. Good luck, people."))
		(ex_play_radio 070MZ_200)
	)
	
	(begin_random		
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Charge the MAC! Give me a firing solution!"))
			(ex_play_radio 070MZ_010)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "All squadrons! Form up! Form up!"))
			(ex_play_radio 070MZ_050)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Standby to jettison the HEVs! On my mark!"))
			(ex_play_radio 070MZ_040)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Forward lances! Draw their fire!"))
			(ex_play_radio 070MZ_230)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Suppress with main point-laser batteries!"))
			(ex_play_radio 070MZ_240)
		)
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "A mark of honor for that kill!"))
			(ex_play_radio 070MZ_250)			
		)		
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Look at it blister and burn!"))
			(ex_play_radio 070MZ_290)
			(sleep 30)
			(if b_debug (print "Affirmative! That's a hit!"))
			(ex_play_radio 070MZ_020)
		)		
		(begin
			(sleep_until (ex_play_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "They have been gutted! Stem to stern!"))
			(ex_play_radio 070MZ_310)
		)
	)
)


(script dormant md_ambiant_brute_radio_stop
	(sleep_until b_fl_frigate_arrived)
	
	(sleep_forever md_ambiant_brute_radio)
)

(script dormant md_ambiant_brute_radio
	(wake md_ambiant_brute_radio_stop)
	
	(sound_looping_start sound\materials\gear\high_ground_radio\high_ground_radio ex_brute_radio 1)
	
	(sleep_until (ex_play_brute_radio_condition))
	
	(begin_random
		(begin
			(sleep_until (ex_play_brute_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Keep them off this hallowed ground! Drive the heretics' ships back through the portal!"))
			(ex_play_brute_radio 070MX_110)
		)
		(begin
			(sleep_until (ex_play_brute_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Do not fear the Prophet's wrath. If you fail I will have your hide!"))
			(ex_play_brute_radio 070MX_120)
		)
		(begin
			(sleep_until (ex_play_brute_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "Their cruisers mix with ours! Watch your fire!"))
			(ex_play_brute_radio 070MX_130)
		)
		(begin
			(sleep_until (ex_play_brute_radio_condition))
			(sleep_ex_radio_delay)
			(if b_debug (print "No! Shoot the carrier! Kill that half-jaw and his crew!"))
			(ex_play_brute_radio 070MX_140)
		)
	)
)