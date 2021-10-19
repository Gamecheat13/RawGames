;========================================================================================
;======================================== MUSIC =========================================
;========================================================================================

;(print "startup 020_base_ambient")



;========================================================================================
;==================================== CHAPTER TITLES ====================================
;========================================================================================
;"Know Your Role..."
(script dormant 020_title1
	(cinematic_set_title title_1)
	(cinematic_title_to_gameplay)
)

;"Free Gift with Purchase"
(script dormant 020_title2
	(if (= (game_insertion_point_get) 0)
		(chapter_start)
		(sleep 30)
	)
	(cinematic_set_title title_2)
	(if (= (game_insertion_point_get) 0)
		(begin
			(sleep 150)
			(chapter_stop)
		)
		(cinematic_title_to_gameplay)
	)

	; stop music 06 
	(set g_music_020_06 FALSE)
)

;"Last One Out, Get the Lights"
(script dormant 020_title3
	(if (<= (game_insertion_point_get) 1)
		(chapter_start)
		(sleep 30)
	)
	(cinematic_set_title title_3)
	(if (<= (game_insertion_point_get) 1)
		(begin
			(sleep 150)
			(chapter_stop)
		)
		(cinematic_title_to_gameplay)
	)
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

command_center and hangar_a 
----------------
020_music_01 
020_music_02
020_music_03
020_music_04
020_music_05

buggers 
----------------
020_music_06

brute_intro/motorpool 
----------------
020_music_07
020_music_08

scary_hole (pre-sewers)
----------------
020_music_02
020_music_09
020_music_10 

brute jetpack 
----------------
020_music_11 

escape/exit_cave/hangar_a_return 
----------------
020_music_12
020_music_13
020_music_14

++++++++++++++++++++
*;

(global boolean g_music_020_01 FALSE)
(global boolean g_music_020_02 FALSE)
(global boolean g_music_020_02b FALSE) ;085
(global boolean g_music_020_03 FALSE)
(global boolean g_music_020_04 FALSE)
(global boolean g_music_020_05 FALSE)
(global boolean g_music_020_06 FALSE)
(global boolean g_music_020_065 FALSE)
(global boolean g_music_020_07 FALSE)
(global boolean g_music_020_08 FALSE)
(global boolean g_music_020_09 FALSE)
(global boolean g_music_020_10 FALSE)
(global boolean g_music_020_105 FALSE)
(global boolean g_music_020_106 FALSE)
(global boolean g_music_020_11 FALSE)
(global boolean g_music_020_114 FALSE)
(global boolean g_music_020_115 FALSE)
(global boolean g_music_020_12 FALSE)
(global boolean g_music_020_13 FALSE)
(global boolean g_music_020_135 FALSE)
(global boolean g_music_020_14 FALSE)

; =======================================================================================================================================================================
(script dormant 020_music_01
	(sleep_until g_music_020_01)
	(if debug (print "start music 020_01"))
	(sound_looping_start levels\solo\020_base\music\020_music_01 NONE 1)

	(sleep_until (not g_music_020_01))
	(if debug (print "stop music 020_01"))
	(sound_looping_stop levels\solo\020_base\music\020_music_01)
)
(script dormant 020_music_02
	(sleep_until g_music_020_02)
	(if debug (print "start music 020_02"))
	(sound_looping_start levels\solo\020_base\music\020_music_02 NONE 1)

	(sleep_until (not g_music_020_02))
	(if debug (print "stop music 020_02"))
	(sound_looping_stop levels\solo\020_base\music\020_music_02)
)
(script dormant 020_music_03
	(sleep_until g_music_020_03)
	(if debug (print "start music 020_03"))
	(sound_looping_start levels\solo\020_base\music\020_music_03 NONE 1)

	(sleep_until (not g_music_020_03))
	(if debug (print "stop music 020_03"))
	(sound_looping_stop levels\solo\020_base\music\020_music_03)
)
(script dormant 020_music_04
	(sleep_until g_music_020_04)
	(if debug (print "start music 020_04"))
	(sound_looping_start levels\solo\020_base\music\020_music_04 NONE 1)

	(sleep_until (not g_music_020_04))
	(if debug (print "stop music 020_04"))
	(sound_looping_stop levels\solo\020_base\music\020_music_04)
)
(script dormant 020_music_05
	(sleep_until g_music_020_05)
	(if debug (print "start music 020_05"))
	(sound_looping_start levels\solo\020_base\music\020_music_05 NONE 1)

	(sleep_until (not g_music_020_05))
	(if debug (print "stop music 020_05"))
	(sound_looping_stop levels\solo\020_base\music\020_music_05)
)
(script dormant 020_music_06
	(sleep_until g_music_020_06)
	(if debug (print "start music 020_06"))
	(sound_looping_start levels\solo\020_base\music\020_music_06 NONE 1)

	(sleep_until (not g_music_020_06))
	(if debug (print "stop music 020_06"))
	(sound_looping_stop levels\solo\020_base\music\020_music_06)
)
(script dormant 020_music_065
	(sleep_until g_music_020_065)
	(if debug (print "start music 020_065"))
	(sound_looping_start levels\solo\020_base\music\020_music_065 NONE 1)

	(sleep_until (not g_music_020_065))
	(if debug (print "stop music 020_065"))
	(sound_looping_stop levels\solo\020_base\music\020_music_065)
)
(script dormant 020_music_07
	(sleep_until g_music_020_07)
	(if debug (print "start music 020_07"))
	(sound_looping_start levels\solo\020_base\music\020_music_07 NONE 1)

	(sleep_until (not g_music_020_07))
	(if debug (print "stop music 020_07"))
	(sound_looping_stop levels\solo\020_base\music\020_music_07)
)
(script dormant 020_music_08
	(sleep_until g_music_020_08)
	(if debug (print "start music 020_08"))
	(sound_looping_start levels\solo\020_base\music\020_music_08 NONE 1)
	(sleep_until (= (device_get_position motor_pool_exit_door) 1) 5)
	(sleep_until (or (volume_test_players sewer01_trig) (= (ai_living_count motor_pool_all) 0))5)
	;(not g_music_020_08)
	(if debug (print "stop music 020_08"))
	(sound_looping_stop levels\solo\020_base\music\020_music_08)
)
(script dormant 020_music_02b
	(sleep_until (or (volume_test_players sewer01_trig) (= (ai_living_count motor_pool_all) 0))5)
	(if debug (print "start music 020_02"))
	(sound_looping_start levels\solo\020_base\music\020_music_085 NONE 1)
	(set g_music_020_02b TRUE)
	
	(sleep_until (not g_music_020_02b))
	(if (= random_bool 1)
		(sleep 30)
	)
	(if debug (print "stop music 020_02"))
	(sound_looping_stop levels\solo\020_base\music\020_music_085)
)
(script dormant 020_music_09
	(sleep_until g_music_020_09)
	(if debug (print "start music 020_09"))
	(sound_looping_start levels\solo\020_base\music\020_music_09 NONE 1)

	(sleep_until (not g_music_020_09))
	(if debug (print "stop music 020_09"))
	(sound_looping_stop levels\solo\020_base\music\020_music_09)
)
(script dormant 020_music_10
	(sleep_until g_music_020_10)
	(if debug (print "start music 020_10"))
	(sound_looping_start levels\solo\020_base\music\020_music_10 NONE 1)

	(sleep_until (not g_music_020_10))
	(if debug (print "stop music 020_10"))
	(sound_looping_stop levels\solo\020_base\music\020_music_10)
)
(script dormant 020_music_105
	(sleep_until g_music_020_105)
	(if debug (print "start music 020_105"))
	(sound_looping_start levels\solo\020_base\music\020_music_105 NONE 1)
)
(script dormant 020_music_106
	(sleep_until g_music_020_106)
	(sleep 1080)
	(if debug (print "start music 020_106"))
	(sound_looping_start levels\solo\020_base\music\020_music_106 NONE 1)

	(sleep_until (not g_music_020_106))
	(if debug (print "stop music 020_106"))
	(sound_looping_stop levels\solo\020_base\music\020_music_106)
)
(script dormant 020_music_11
	(sleep_until g_music_020_11)
	(if debug (print "start music 020_11"))
	(sound_looping_start levels\solo\020_base\music\020_music_11 NONE 1)

	(sleep_until (not g_music_020_11))
	(if debug (print "stop music 020_11"))
	(sound_looping_stop levels\solo\020_base\music\020_music_11)
)
(script dormant 020_music_114
	(sleep_until g_music_020_114)
	(if debug (print "start music 020_114"))
	(sound_looping_start levels\solo\020_base\music\020_music_114 NONE 1)

	(sleep_until (not g_music_020_114))
	(if debug (print "stop music 020_114"))
	(sound_looping_stop levels\solo\020_base\music\020_music_114)
)
(script dormant 020_music_115
	(if debug (print "start music 020_115"))
	(sound_looping_start levels\solo\020_base\music\020_music_115 NONE 1)
	(set g_music_020_115 true)
	(wake 020_music_115_alt)
	
	(sleep_until (or (< (ai_living_count cortana_highway_all) 1) 
					(= g_music_020_115 FALSE)
					(volume_test_players motor_pool_start_trig))5)
	(if debug (print "stop music 020_115"))
	(sound_looping_stop levels\solo\020_base\music\020_music_115)
)
(script dormant 020_music_115_alt
	(sleep_until (volume_test_players cortana_highway_turret_end)1)
	(if debug (print "start music 020_115_alt"))	
	(sound_looping_set_alternate levels\solo\020_base\music\020_music_115 TRUE)
)
(script dormant 020_music_12
	(sleep_until g_music_020_12)
	(if debug (print "start music 020_12"))
	(sound_looping_start levels\solo\020_base\music\020_music_12 NONE 1)

	(sleep_until (not g_music_020_12))
	(if debug (print "stop music 020_12"))
	(sound_looping_stop levels\solo\020_base\music\020_music_12)

)
(script dormant 020_music_13
	(sleep_until g_music_020_13)
	(if debug (print "start music 020_13"))
	(sound_looping_start levels\solo\020_base\music\020_music_13 NONE 1)

	(sleep_until (not g_music_020_13))
	(if debug (print "stop music 020_13"))
	(sound_looping_stop levels\solo\020_base\music\020_music_13)
)
(script dormant 020_music_135
	(sleep_until (volume_test_players hangar_a_start_trig) 5)
	(set g_music_020_135 TRUE)
	(if debug (print "start music 020_135"))
	(sound_looping_start levels\solo\020_base\music\020_music_135 NONE 1)
	(sleep 1)

	(sleep_until (not g_music_020_135))
	(if debug (print "stop music 020_135"))
	(sound_looping_stop levels\solo\020_base\music\020_music_135)
)
(script dormant 020_music_14
	(sleep_until g_music_020_14)
	(if debug (print "start music 020_14"))
	(sound_looping_start levels\solo\020_base\music\020_music_14 NONE 1)

	(sleep_until (not g_music_020_14))
	(if debug (print "stop music 020_14"))
	(sound_looping_stop levels\solo\020_base\music\020_music_14)
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

md_01_command_objectives
md_01_command_terminals
md_01_command_followers
md_01_cave_miranda_pa
md_01_cave_marines
md_01_cave_radio
md_01_cave_followers
br_01_hw_seal_base
md_01_hw_followers
md_01_hw_encounter
md_02_armory_marines_init
md_02_armory_marines_tut
md_02_armory_miranda_pa
md_02_armory_joh_explosives
md_02_armory_reinf
br_03_hw_seal_hanger
md_03_hw_followers
vt_03_bugger_attack
md_03_bugger_marine
md_03_bugger_miranda_pa
md_03_bugger_followers
md_04_hangar_a_combat
md_04_hangar_miranda_pa
md_05_cave_marines
md_05_cave_miranda_pa
md_05_command_objectives
md_05_command_marines_joh
md_06_motorpool_brutes
md_06_motorpool_johnson_pa
br_06_sewer_rescue
md_06_hw_joh
md_07_evac_arbiter
vt_07_barracks_01
md_07_barracks_rescue
md_07_barracks_miranda_pa
md_07_barracks_marines
md_07_joh_reward
md_08_evac_pelican_01
md_08_evac_marines
md_08_evac_pelican_02
md_08_evac_pelican_03
br_08_evac_destroy_base
md_08_evac_pelican_exit
md_08_evac_pelican_exit_arbiter
md_08_evac_joh_exit
md_09_cortana_brute_pa
ca_09_cortana
md_09_cortana_joh
md_09_motorpool_brute_pa
md_09_motorpool_joh
br_10_command_objective
md_11_cave_hangar_joh
am_00_base
+++++++++++++++++++++++
*;

(global boolean dialogue TRUE)

(global ai miranda NONE)
(global ai arbiter NONE)
(global object obj_arbiter none)
(global ai johnson NONE)
(global ai bugger NONE)
(global ai follower_marine_A NONE)
(global ai follower_marine_B NONE)
(global ai 01_marine_A NONE)
(global ai 01_marine_B NONE)
(global ai 01_marine_C NONE)
(global ai 01_marine_D NONE)
(global ai 01_marine_E NONE)
(global ai 01_marine_F NONE)
(global ai 01_marine_E1 NONE)
(global ai 01_marine_F1 NONE)
(global ai 01_marine_G NONE)
(global ai 01_marine_H NONE)
(global ai 01_marine_I NONE)
(global ai 01_marine_J NONE)
(global ai 01_marine_K NONE)
(global ai 01_marine_L NONE)
(global ai 01_marine_M NONE)
(global ai 01_sergeant NONE)

(global ai 03_marine_A NONE)
(global ai 03_marine_C NONE)
(global ai 03_marine_D NONE)
(global ai 03_marine_E NONE)
(global ai 03_marine_F NONE)
(global ai 03_sergeant_A NONE)

(global ai 04_marine_A NONE)
(global ai 04_marine_B NONE)

(global ai 05_marine_A NONE)
(global ai 05_sergeant NONE)

(global ai 06_brute_A NONE)
(global ai 06_sergeant NONE)

(global ai 07_brute_A NONE)
(global ai 07_brute_B NONE)
(global ai 07_brute_C NONE)
(global ai 07_brute_D NONE)
(global ai 07_brute_E NONE)
(global ai 07_brute_F NONE)

(global ai 07_marine_A NONE)
(global ai 07_marine_B NONE)
(global ai 07_marine_C NONE)

(global ai 08_marine_A NONE)
(global ai 08_marine_B NONE)

(global ai 10_brute_A NONE)
(global ai 10_truth NONE)

(global ai rvb_actor NONE)

(global boolean objective_br08_updated FALSE)

(global short rand 0)

(script dormant cin_base_insertion
	(data_mine_set_mission_segment "020la_Secret_Base")
	
	(cinematic_snap_to_black)

	(if (cinematic_skip_start)
		(begin
			
			(if debug (print "020la_secret_base"))
			(020la_secret_base)
		)
	)
	(cinematic_skip_stop)

	(020la_secret_base_cleanup)

		; teleport players to the proper locations 
		(object_teleport (player0) player0_start)
		(object_teleport (player1) player1_start)
		(object_teleport (player2) player2_start)
		(object_teleport (player3) player3_start)

	(ai_place command_center_marines01)
	(ai_place command_center_marines02/05)
	(ai_place command_center_marines02/10)
	(ai_place command_center_marines02/jon)
	(ai_place command_center_marines02/actor_miranda)
	(if (= (game_coop_player_count) 1)
		(ai_place command_center_marines02/arby)
	)
	(ai_place command_center_marines03)
;	(ai_place command_center_marines04)
	(ai_place command_center_marines05)
	(ai_place command_center_marines06)
	(wake 020_title1)
	(wake obj_init_set)	
	
	(device_set_position_immediate command_center_cin_door 0)
	(cinematic_fade_to_title)
		; unhide the players 
;	(object_hide elevator_evac_02 FALSE)
)


(script static void md_cleanup
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_01_command_objectives_01
	(if debug (print "mission dialogue:01:command:objectives_01"))
		; cast the actors
		(vs_cast command_center_marines02 TRUE 5 "020VA_020" "020VA_010")
			(set miranda (vs_role 1))
			(set 01_marine_A (vs_role 2))
		(vs_cast command_center_marines02 FALSE 5 "020VA_120" "020MJ_010")
			(set johnson (vs_role 1))
			(set arbiter (vs_role 2))		
		(sleep 60)
		(vs_look_object johnson TRUE (ai_get_object miranda))
		(vs_look_object arbiter TRUE (ai_get_object miranda))
		(vs_look_object 01_marine_A TRUE (ai_get_object miranda))
		
		(vs_set_cleanup_script md_cleanup)
		(ai_dialogue_enable FALSE)
		
		(if dialogue (print "OFFICER 1: Ma'am! We just lost the perimeter cameras!"))
		(vs_play_line 01_marine_A TRUE 020VA_010)
		(sleep 10)

		(vs_go_to miranda FALSE command_center_patrols/mir0)
		(if dialogue (print "MIRANDA: Motion trackers?"))
		(sleep (ai_play_line miranda 020VA_020))
		(sleep 10)

		(if dialogue (print "OFFICER 1: They're down or we're not receiving. Can't tell."))
		(vs_play_line 01_marine_A TRUE 020VA_030)
		(vs_look_object 01_marine_A FALSE (ai_get_object miranda))
		
		(sleep 45)
		(ai_dialogue_enable TRUE)
)
	
(script dormant md_01_command_objectives_02
	(sleep_until (= (script_started md_01_command_objectives_01) TRUE))
	(sleep 1)
	(sleep_until (= (script_finished md_01_command_objectives_01) TRUE))
	(if debug (print "mission dialogue:01:command:objectives_02"))
		; cast the actors
		(vs_cast command_center_marines02 TRUE 10 "020VA_020")
			(set miranda (vs_role 1))
		(vs_cast command_center_marines02 FALSE 10 "020VA_120" "020MJ_010")
			(set johnson (vs_role 1))
			(set arbiter (vs_role 2))		

		(vs_look_object johnson TRUE (ai_get_object miranda))
		(vs_look_object arbiter TRUE (ai_get_object miranda))
		(vs_look_object miranda TRUE (ai_get_object 01_marine_B))
		
		(vs_set_cleanup_script md_cleanup)
		(ai_dialogue_enable FALSE)
		
		(if dialogue (print "MIRANDA: Any of our birds squawking?"))
		(sleep (ai_play_line miranda 020VA_040))
		(sleep 10)	

		(vs_cast command_center_marines02 TRUE 10 "020VA_050")
			(set 01_marine_B (vs_role 1))
		(vs_look_object 01_marine_B TRUE (ai_get_object miranda))
		(if dialogue (print "OFFICER 2: No ma'am…"))
		(vs_play_line 01_marine_B TRUE 020VA_050)
		(sleep 10)

		(vs_look_object miranda FALSE (ai_get_object 01_marine_B))
		(vs_approach miranda FALSE (ai_get_object 01_marine_B) 1 100 100)
		(vs_look_object 01_marine_B FALSE (ai_get_object miranda))
		(if dialogue (print "OFFICER 2: Wait. Overwatch has contacts…"))
		(vs_play_line 01_marine_B TRUE 020VA_060)
		(sleep 10)

		(if dialogue (print "OFFICER 2: Phantoms! Closing on our position!"))
		(vs_play_line 01_marine_B TRUE 020VA_070)
		(sleep 10)
		(vs_release_all)
		(ai_dialogue_enable TRUE)
		(sleep 1)
)		
		
(script dormant md_01_command_objectives_03
	(sleep_until (= (script_started md_01_command_objectives_02) TRUE))
	(sleep 1)
	(sleep_until (= (script_finished md_01_command_objectives_02) TRUE))
	(if debug (print "mission dialogue:01:command:objectives_03"))

		; cast the actors
		(vs_cast command_center_marines02 TRUE 15 "020VA_020")
			(set miranda (vs_role 1))
		(vs_cast command_center_marines02 FALSE 15 "020VA_120" "020MJ_010")
			(set johnson (vs_role 1))
			(set arbiter (vs_role 2))		

		(vs_look_object johnson TRUE (ai_get_object miranda))
		(vs_look_object arbiter TRUE (ai_get_object miranda))
		(vs_look_object miranda TRUE (ai_get_object 01_marine_B))
		
		(vs_set_cleanup_script md_cleanup)
		(ai_dialogue_enable FALSE)
		
;		(if dialogue (print "OFFICER 1: Trackers are up!  We've got movement inside the perimeter!"))
;		(vs_play_line miranda TRUE 020VA_090)
;		(sleep 10)	
		
		(if dialogue (print "MIRANDA: Any birds less than five minutes out? Bring them in."))
		(sleep (ai_play_line miranda 020VA_090))
		(sleep 10)	

		(if dialogue (print "MIRANDA: Tell everything else to scatter!"))
		(sleep (ai_play_line miranda 020VA_100))
		(sleep 10)

		(vs_cast command_center_marines02 TRUE 10 "020VA_050")
			(set 01_marine_B (vs_role 1))
		(if dialogue (print "OFFICER 2: Aye-aye!"))
		(vs_play_line 01_marine_B TRUE 020VA_110)
		(sleep 10)
		(ai_dialogue_enable TRUE)
		(vs_release_all)
		(sleep 1)
)
; CUT 06/25
(script dormant md_01_command_objectives_04
	(sleep_until (= (script_started md_01_command_objectives_03) TRUE))
	(sleep 1)
	(sleep_until (= (script_finished md_01_command_objectives_03) TRUE))
	(vs_set_cleanup_script make_arby_leave)
	(if debug (print "mission dialogue:01:command:objectives_04"))

		; cast the actors
		(vs_cast command_center_marines02 TRUE 10 "020VA_020" "020VA_120")
			(set miranda (vs_role 1))
			(set johnson (vs_role 2))
		(vs_cast command_center_marines02 FALSE 10 "020MJ_010")
			(set arbiter (vs_role 1))		

		(vs_look_object johnson TRUE (ai_get_object miranda))
		(vs_look_object arbiter TRUE (ai_get_object miranda))
		
		(vs_set_cleanup_script md_cleanup)
		(ai_dialogue_enable FALSE)

		(if (not (game_is_cooperative))
			(begin
				(if dialogue (print "JOHNSON: Want the Arbiter back in ops-center?"))
				(vs_play_line johnson TRUE 020VA_120)
				(sleep 10)
		
				(vs_approach_stop miranda)
				(vs_look_object miranda TRUE (ai_get_object johnson))
				(if dialogue (print "MIRANDA: No. North Hangar. We're short in that sector."))
				(vs_play_line miranda TRUE 020VA_130)
				(sleep 10)
				(vs_look_object miranda FALSE (ai_get_object johnson))
				(sleep 10)
			)
			
			(begin
				(if dialogue (print "JOHNSON: Should we split the Chief and Arbiter up?"))
				(vs_play_line johnson TRUE 020VA_140)
				(sleep 10)
		
				(vs_approach_stop miranda)
				(vs_look_object miranda TRUE (ai_get_object johnson))
				(if dialogue (print "MIRANDA: No. They'll be more effective together."))
				(vs_play_line miranda TRUE 020VA_150)
				(sleep 10)
				(vs_look_object miranda FALSE (ai_get_object johnson))
				(sleep 10)
			)			
		)
		(ai_dialogue_enable TRUE)
		(vs_release_all)
		
)

(script static void make_arby_leave
	(sleep 30)
	(object_create_containing arb_sphere)
	(cs_run_command_script command_center_marines02/arby arby_leaves_cc)
)
(script static void test_arby_leave
	(ai_place command_center_marines02/arby)
	(sleep 30)
	(object_create_containing arb_sphere)
	(cs_run_command_script command_center_marines02/arby arby_leaves_cc)
)
(script static void test_mir_draw
	(ai_place command_center_marines02/actor_miranda)
	(sleep 1)
	(vs_draw command_center_marines02/actor_miranda)
)
(script command_script arby_leaves_cc
;	(cs_abort_on_alert TRUE)
	(cs_abort_on_damage TRUE)
	(cs_look_object FALSE (ai_get_object miranda))
	;(if dialogue (print "ARBITER: Half-wit insects!"))
	;(cs_play_line TRUE 020MI_010)
;	(cs_movement_mode 1)
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe TRUE)
	(unit_set_active_camo (unit (ai_get_object arbiter)) TRUE 2)
	(cs_go_to command_center_patrols/arb01)
	(cs_go_to command_center_patrols/arb02)
	(object_destroy_containing arb_sphere)
	(cs_go_to command_center_patrols/arb03)
	(cs_go_to command_center_patrols/arb04)
	(cs_go_to command_center_intro/p19)
	(sleep_until 
		(AND
			(= (objects_can_see_object (players) (ai_get_object arbiter) 45) FALSE)
			(= (volume_test_players vol_arbiter_vanish) FALSE)
		)
	)
	(ai_erase command_center_marines02/arby)
)
(global boolean miranda_done FALSE)
(script dormant md_01_command_objectives_05
	(sleep_until (= (script_started md_01_command_objectives_03) TRUE))
	(sleep 1)
	(sleep_until (= (script_finished md_01_command_objectives_03) TRUE))
	(if debug (print "mission dialogue:01:command:objectives_05"))

		; cast the actors
		(vs_cast command_center_marines02 TRUE 10 "020VA_020")
			(set miranda (vs_role 1))
		(vs_cast command_center_marines02 FALSE 10 "020VA_010")
			(set 01_marine_A (vs_role 1))
		(vs_go_to_and_face miranda FALSE command_center_intro/p20 command_center_intro/p19)

		(vs_look_object 01_marine_A TRUE (ai_get_object miranda))		
		(vs_set_cleanup_script md_cleanup)
		(ai_dialogue_enable FALSE)
		(if dialogue (print "OFFICER 1: Never thought we'd have this many wounded…"))
		(vs_play_line 01_marine_A TRUE 020VA_160)
		(sleep 10)

		(vs_cast command_center_marines02 FALSE 10 "020VA_050")
			(set 01_marine_B (vs_role 1))
		(vs_look_object 01_marine_B TRUE (ai_get_object miranda))		
		(if dialogue (print "OFFICER 2: Pelican's are gonna take extra time to load…"))
		(vs_play_line 01_marine_B TRUE 020VA_170)
		(sleep 10)
		
		(if dialogue (print "MIRANDA: We knew they find us eventually..."))
		(vs_play_line miranda TRUE 020VA_180)
		(sleep 10)

		(vs_cast command_center_marines05 FALSE 10 "020VA_200" "020VA_200" "020VA_200" "020VA_200" "020VA_200" "020VA_200" "020VA_200")
			(set 01_marine_C (vs_role 1))
			(set 01_marine_D (vs_role 2))
			(set 01_marine_E (vs_role 3))
			(set 01_marine_F (vs_role 4))
			(set 01_marine_G (vs_role 5))
			(set 01_marine_H (vs_role 6))
			(set 01_marine_I (vs_role 7))
		(vs_cast command_center_marines05 FALSE 10 "020VA_200" "020VA_200")
			(set 01_marine_J (vs_role 1))
			(set 01_marine_K (vs_role 2))

		(if dialogue (print "MIRANDA: But we have a plan. Let's make it happen!"))
		(vs_play_line miranda TRUE 020VA_190)
		(sleep 10)
		(set miranda_done TRUE)

		(vs_look_object 01_marine_A TRUE (ai_get_object miranda))		
		(vs_look_object 01_marine_B TRUE (ai_get_object miranda))		
		(vs_look_object 01_marine_C TRUE (ai_get_object miranda))		
		(vs_look_object 01_marine_D TRUE (ai_get_object miranda))		
		(vs_look_object 01_marine_E TRUE (ai_get_object miranda))		
		(vs_look_object 01_marine_F TRUE (ai_get_object miranda))		
		(vs_look_object 01_marine_G TRUE (ai_get_object miranda))		
		(vs_look_object 01_marine_H TRUE (ai_get_object miranda))		
		(vs_look_object 01_marine_I TRUE (ai_get_object miranda))		
		(vs_look_object 01_marine_J TRUE (ai_get_object miranda))		
		(vs_look_object 01_marine_K TRUE (ai_get_object miranda))		
			; marines respond to miranda 
			(begin_random
				(begin
					(if dialogue (print "MARINE: Yes, ma'am! Aye-aye, Commander!"))
					(vs_play_line 01_marine_A FALSE 020VA_200)
					(sleep (random_range 0 3))
				)
				(begin
					(vs_play_line 01_marine_B FALSE 020VA_200)
					(sleep (random_range 0 3))
				)
				(begin
					(vs_play_line 01_marine_C FALSE 020VA_200)
					(vs_action_at_object 01_marine_C FALSE (ai_get_object miranda) ai_action_cheer)
					(sleep (random_range 0 3))
				)
				(begin
					(vs_play_line 01_marine_D FALSE 020VA_200)
					(vs_action_at_object 01_marine_D FALSE (ai_get_object miranda) ai_action_cheer)
					(sleep (random_range 0 3))
				)
				(begin
					(vs_play_line 01_marine_E FALSE 020VA_200)
					(vs_action_at_object 01_marine_E FALSE (ai_get_object miranda) ai_action_cheer)
					(sleep (random_range 0 3))
				)
				(begin
					(vs_play_line 01_marine_F FALSE 020VA_200)
					(vs_action_at_object 01_marine_F FALSE (ai_get_object miranda) ai_action_cheer)
					(sleep (random_range 0 3))
				)
				(begin
					(vs_play_line 01_marine_G FALSE 020VA_200)
					(vs_action_at_object 01_marine_G FALSE (ai_get_object miranda) ai_action_cheer)
					(sleep (random_range 0 3))
				)
				(begin
					(vs_play_line 01_marine_H FALSE 020VA_200)
					(vs_action_at_object 01_marine_H FALSE (ai_get_object miranda) ai_action_cheer)
					(sleep (random_range 0 3))
				)
				(begin
					(vs_play_line 01_marine_I FALSE 020VA_200)
					(vs_action_at_object 01_marine_I FALSE (ai_get_object miranda) ai_action_cheer)
					(sleep (random_range 0 3))
				)
				(begin
					(vs_play_line 01_marine_J FALSE 020VA_200)
					(vs_action_at_object 01_marine_J FALSE (ai_get_object miranda) ai_action_cheer)
					(sleep (random_range 0 3))
				)
				(begin
					(vs_play_line 01_marine_K FALSE 020VA_200)
					(vs_action_at_object 01_marine_K FALSE (ai_get_object miranda) ai_action_cheer)
					(sleep (random_range 0 3))
				)
			)

		(sleep 30)
		(vs_look_object 01_marine_A FALSE (ai_get_object miranda))		
		(vs_look_object 01_marine_B FALSE (ai_get_object miranda))		
		(vs_look_object 01_marine_C FALSE (ai_get_object miranda))		
		(vs_look_object 01_marine_D FALSE (ai_get_object miranda))		
		(vs_look_object 01_marine_E FALSE (ai_get_object miranda))		
		(vs_look_object 01_marine_F FALSE (ai_get_object miranda))		
		(vs_look_object 01_marine_G FALSE (ai_get_object miranda))		
		(vs_look_object 01_marine_H FALSE (ai_get_object miranda))		
		(vs_look_object 01_marine_I FALSE (ai_get_object miranda))		
		(vs_look_object 01_marine_J FALSE (ai_get_object miranda))		
		(vs_look_object 01_marine_K FALSE (ai_get_object miranda))
		(ai_dialogue_enable TRUE)
			
		(sleep 60)
		
		(wake md_01_command_followers)

		(wake 01_johnson_reminder)
		(wake miranda_terminals)
		(vs_release_all)
		(sleep 1)
		
		(cs_run_command_script command_center_marines05 stand_gun_down)
		(sleep 1)
		(cs_run_command_script command_center_marines05/pat01 pat_wander_01)
		(cs_run_command_script command_center_marines05/pat02 pat_wander_02)
)

; ===================================================================================================================================================

(script command_script pat_wander_01
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
;	(cs_force_combat_status 2)
	(cs_draw)
	(cs_walk TRUE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to command_center_patrols/p7)
					(cs_face_object TRUE (ai_get_object command_center_marines05/post02))
					(sleep (random_range 150 300))
					(cs_face_object FALSE (ai_get_object command_center_marines05/post02))
				)
				(begin
					(cs_go_to command_center_patrols/p2)
					(cs_face_object TRUE (ai_get_object command_center_marines05/post05))
					(sleep (random_range 150 300))
					(cs_face_object FALSE (ai_get_object command_center_marines05/post05))
				)
				(begin
					(cs_go_to command_center_patrols/p8)
					(cs_face_object TRUE ops_shelf)
					(sleep (random_range 150 300))
					(cs_face_object FALSE ops_shelf)
				)
				(begin
					(cs_go_to command_center_patrols/p3)
					;(cs_face_object TRUE cc_computer07)
					(sleep (random_range 150 300))
					;(cs_face_object FALSE cc_computer07)
				)
				(begin
					(cs_go_to command_center_patrols/p11)
					;(cs_face_object TRUE cc_computer22)
					(sleep (random_range 150 300))
					;(cs_face_object FALSE cc_computer22)
				)
				(begin
					(cs_go_to command_center_patrols/p12)
					;(cs_face_object TRUE cc_computer10)
					(sleep (random_range 150 300))
					;(cs_face_object FALSE cc_computer10)
				)
				(begin
					(cs_go_to command_center_patrols/p5)
					;(cs_face_object TRUE cc_computer10)
					(sleep (random_range 150 300))
					;(cs_face_object FALSE cc_computer10)
				)
			)
			FALSE
		)
	)
)
(script command_script pat_wander_02
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
;	(cs_force_combat_status 2)
	(cs_draw)
	(cs_walk TRUE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to command_center_patrols/p1)
					;(cs_face_object TRUE cc_computer07)
					(sleep (random_range 150 300))
					;(cs_face_object FALSE cc_computer07)
				)
				(begin
					(cs_go_to command_center_patrols/p9)
					;(cs_face_object TRUE cc_computer07)
					(sleep (random_range 150 300))
					;(cs_face_object FALSE cc_computer07)
				)
				(begin
					(cs_go_to command_center_patrols/p3)
					;(cs_face_object TRUE cc_computer07)
					(sleep (random_range 150 300))
					;(cs_face_object FALSE cc_computer07)
				)
				(begin
					(cs_go_to command_center_patrols/p11)
					;(cs_face_object TRUE cc_computer22)
					(sleep (random_range 150 300))
					;(cs_face_object FALSE cc_computer22)
				)
				(begin
					(cs_go_to command_center_patrols/p12)
					;(cs_face_object TRUE cc_computer10)
					(sleep (random_range 150 300))
					;(cs_face_object FALSE cc_computer10)
				)
				(begin
					(cs_go_to command_center_patrols/p5)
					;(cs_face_object TRUE cc_computer10)
					(sleep (random_range 150 300))
					;(cs_face_object FALSE cc_computer10)
				)
				(begin
					(cs_go_to command_center_patrols/p0)
					;(cs_face_object TRUE cc_computer10)
					(sleep (random_range 150 300))
					;(cs_face_object FALSE cc_computer10)
				)
				(begin
					(cs_go_to command_center_patrols/p4)
					;(cs_face_object TRUE cc_computer10)
					(sleep (random_range 150 300))
					;(cs_face_object FALSE cc_computer10)
				)
			)
			FALSE
		)
	)
)
(script command_script pat_wander_03
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to_and_posture cc_crash_pts_03/cc20 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(cs_go_to_and_posture cc_crash_pts_03/cc12 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(cs_go_to_and_posture cc_crash_pts_03/cc13 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(cs_go_to_and_posture cc_crash_pts_03/cc14 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(cs_go_to_and_posture cc_crash_pts_03/cc18 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
			)
			FALSE
		)
	)
)
(script command_script pat_wander_04
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to_and_posture cc_crash_pts_01/cc02 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(cs_go_to_and_posture cc_crash_pts_01/cc03 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(cs_go_to_and_posture cc_crash_pts_01/cc04 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(cs_go_to_and_posture cc_crash_pts_01/cc05 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(cs_go_to_and_posture cc_crash_pts_01/cc06 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(cs_go_to_and_posture cc_crash_pts_01/cc16 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(cs_go_to_and_posture cc_crash_pts_02/cc08 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(cs_go_to_and_posture cc_crash_pts_02/cc09 "act_typing")
					(sleep (random_range 300 600))
					(cs_posture_exit)
				)
			)
			FALSE
		)
	)
)


(script dormant 01_johnson_reminder
		(sleep_until (volume_test_players command_center_terminal_trig))
		(vs_set_cleanup_script md_cleanup)
		(ai_dialogue_enable FALSE)
		(if (not (game_is_cooperative))
			(begin
				(vs_look_player johnson TRUE) 
				(if dialogue (print "JOHNSON: I'll stay here, Chief. Guard the ops-center…"))
				(vs_play_line johnson TRUE 020MX_010)
				(vs_look_player johnson FALSE)
				(sleep 30)
				
				(sleep_until (volume_test_players command_center_terminal_trig))
				(vs_look_object johnson TRUE (ai_get_object miranda))
				(if dialogue (print "JOHNSON: Keep my eye on the Commander."))
				(vs_play_line johnson TRUE 020MX_020)
				(sleep 30)
				
				(sleep_until (volume_test_players command_center_terminal_trig))
				(vs_look_object johnson FALSE (ai_get_object miranda))
				(vs_look_player johnson TRUE) 
				(if dialogue (print "JOHNSON: But the marines downstairs could use your help."))
				(vs_play_line johnson TRUE 020MA_050)	
				(vs_look_player johnson FALSE) 
				(set ops_johnson_done TRUE)
		(ai_dialogue_enable TRUE)				
				(sleep 300)
			)
		)
				
		
		(sleep_until (volume_test_players command_center_terminal_trig))
		(set ops_johnson_done FALSE)
		(vs_face_player johnson TRUE)		
			(cond
				((= (game_coop_player_count) 1) 
					(begin
						(if dialogue (print "JOHNSON: Chief. Move out!"))
						(vs_play_line johnson TRUE 020MA_060)
					)
				)
				((= (game_coop_player_count) 2) 
					(begin
						(if dialogue (print "JOHNSON: Chief. Move out!"))
						(vs_play_line johnson TRUE 020MA_060)
											
						(if dialogue (print "JOHNSON: You too, Arbiter!"))
						(vs_play_line johnson TRUE 020MA_070)
					)
				)
				((= (game_coop_player_count) 3) 
					(begin
						(if dialogue (print "JOHNSON: Get a move on! Spartans and Elites!"))
						(vs_play_line johnson TRUE 020MA_080) 
					)
				)
				((= (game_coop_player_count) 4) 
					(begin
						(if dialogue (print "JOHNSON: Get a move on! Spartans and Elites!"))
						(vs_play_line johnson TRUE 020MA_080) 
					)
				)
			)
		(sleep 20)
	
		(if dialogue (print "JOHNSON: The Commander will brief you as you go."))
		(vs_play_line johnson TRUE 020MA_090)
		(vs_face_player johnson FALSE)		
		(set ops_johnson_done TRUE)
)

(global boolean miranda_flee FALSE)

(script dormant miranda_movement
	(sleep_until 
		(OR
			(volume_test_players command_center_intro_trig)
			(= ops_mir_done TRUE)
		)
	1)
	(set miranda_flee TRUE)
	(sleep_forever miranda_terminals)
	(sleep 1)
	(vs_cast command_center_marines02 TRUE 100 "020VA_020")
	(set miranda (vs_role 1))
	(vs_enable_pathfinding_failsafe miranda TRUE)
	(vs_go_to miranda TRUE command_center_intro/p8)
	(device_set_position command_miranda_door 0)
	(vs_go_to miranda TRUE command_center_intro/p7)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p21 command_center_intro/p22)
					(vs_face miranda TRUE command_center_intro/p22)
;					(ai_activity_set miranda "typing")
					(sleep (random_range 90 300))
;					(ai_activity_abort miranda)
					(vs_face miranda FALSE command_center_intro/p22)
				)
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p23 command_center_intro/p24)
					(vs_face miranda TRUE command_center_intro/p24)
					(sleep (random_range 90 300))
					(vs_face miranda FALSE command_center_intro/p24)
				)
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p25 command_center_intro/p26)
					(vs_face miranda TRUE command_center_intro/p26)
					(sleep (random_range 90 300))
					(vs_face miranda FALSE command_center_intro/p26)
				)
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p27 command_center_intro/p28)
					(vs_face miranda TRUE command_center_intro/p28)
					(sleep (random_range 90 300))
					(vs_face miranda FALSE command_center_intro/p28)
				)
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p29 command_center_intro/p30)
					(vs_face miranda TRUE command_center_intro/p30)
					(sleep (random_range 90 300))
					(vs_face miranda FALSE command_center_intro/p30)
				)
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p31 command_center_intro/p24)
					(vs_face miranda TRUE command_center_intro/p24)
					(sleep (random_range 90 300))
					(vs_face miranda FALSE command_center_intro/p24)
				)
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p31 command_center_intro/p26)
					(vs_face miranda TRUE command_center_intro/p26)
					(sleep (random_range 90 300))
					(vs_face miranda FALSE command_center_intro/p26)
				)
			)
			(>= base_obj_control 30)
		)
	)
)

(script static void test_miranda_movement
	(ai_place command_center_marines02/actor_miranda)
	(vs_cast command_center_marines02 TRUE 100 "020VA_020")
	(set miranda (vs_role 1))
	(vs_enable_pathfinding_failsafe miranda TRUE)
	(vs_go_to miranda TRUE command_center_intro/p8)
	(device_set_position command_miranda_door 0)
	(vs_go_to miranda TRUE command_center_intro/p7)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p21 command_center_intro/p22)
					(vs_face miranda TRUE command_center_intro/p22)
;					(vs_posture_set miranda "typing" FALSE)
					(sleep (random_range 90 300))
;					(ai_activity_abort miranda)
					(vs_face miranda FALSE command_center_intro/p22)
				)
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p23 command_center_intro/p24)
					(vs_face miranda TRUE command_center_intro/p24)
					(sleep (random_range 90 300))
					(vs_face miranda FALSE command_center_intro/p24)
				)
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p25 command_center_intro/p26)
					(vs_face miranda TRUE command_center_intro/p26)
					(sleep (random_range 90 300))
					(vs_face miranda FALSE command_center_intro/p26)
				)
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p27 command_center_intro/p28)
					(vs_face miranda TRUE command_center_intro/p28)
					(sleep (random_range 90 300))
					(vs_face miranda FALSE command_center_intro/p28)
				)
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p29 command_center_intro/p30)
					(vs_face miranda TRUE command_center_intro/p30)
					(sleep (random_range 90 300))
					(vs_face miranda FALSE command_center_intro/p30)
				)
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p31 command_center_intro/p24)
					(vs_face miranda TRUE command_center_intro/p24)
					(sleep (random_range 90 300))
					(vs_face miranda FALSE command_center_intro/p24)
				)
				(begin
					(vs_go_to_and_face miranda TRUE command_center_intro/p31 command_center_intro/p26)
					(vs_face miranda TRUE command_center_intro/p26)
					(sleep (random_range 90 300))
					(vs_face miranda FALSE command_center_intro/p26)
				)
			)
			(>= base_obj_control 30)
		)
	)
)

(global boolean ops_reply_1 FALSE)
(global boolean ops_reply_2 FALSE)
(global boolean ops_reply_3 FALSE)
(global boolean ops_reply_4 FALSE)
(global boolean ops_mir_done FALSE)
(global boolean ops_recent_check FALSE)
(global boolean ops_johnson_done FALSE)
(script dormant miranda_terminals
	(sleep_until (= ops_johnson_done TRUE))
	(sleep (random_range 90 150))
	(begin_random
		(if (= miranda_flee FALSE)
			(begin
				(sleep_until (= ops_johnson_done TRUE))
				(sleep (random_range 60 120))
				(vs_cast command_center_marines02 FALSE 10 "020MA_100")
				(set 01_marine_A (vs_role 1))
				(if dialogue (print "MARINE: Ma'am?"))
				(vs_play_line 01_marine_A TRUE 020MA_100)
				(sleep (random_range 15 45))
				(vs_approach miranda TRUE (ai_get_object 01_marine_A) .5 100 100)
				(sleep (random_range 60 90))
				(sleep_until (= ops_johnson_done TRUE))
				(sleep (random_range 30 60)); marty brought this up in music review today.
				(begin_random
					(if 
						(AND
							(= ops_reply_1 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_1 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Keep me posted."))	
								(vs_play_line miranda TRUE 020MA_140)
							)
					)
					(if 
						(AND
							(= ops_reply_2 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_2 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Let me know if something changes."))	
								(vs_play_line miranda TRUE 020MA_150)
							)
					)
					(if 
						(AND
							(= ops_reply_3 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_3 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Should be alright, but stay sharp."))	
								(vs_play_line miranda TRUE 020MA_160)
							)
					)
					(if 
						(AND
							(= ops_reply_4 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_4 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Good catch. Send the word."))	
								(vs_play_line miranda TRUE 020MA_170)
							)
					)
				)
				(vs_approach_stop miranda)
				(sleep_until (= miranda_flee TRUE) 5 (random_range 30 60)) 
				(set ops_recent_check FALSE)
				(vs_release 01_marine_A)
				(sleep 1)
			)
		)
		(if (= miranda_flee FALSE)
			(begin
				(sleep_until (= ops_johnson_done TRUE))
				(sleep (random_range 60 120))
				(vs_cast command_center_marines02 FALSE 10 "020MA_110")
				(set 01_marine_A (vs_role 1))
				(if dialogue (print "MARINE: Commander?"))
				(vs_play_line 01_marine_A TRUE 020MA_110)
				(sleep (random_range 15 45))
				(vs_approach miranda TRUE (ai_get_object 01_marine_A) .5 100 100)
				(sleep (random_range 30 60))
				(sleep_until (= ops_johnson_done TRUE))
				(sleep (random_range 30 60))
				(begin_random
					(if 
						(AND
							(= ops_reply_1 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_1 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Keep me posted."))	
								(vs_play_line miranda TRUE 020MA_140)
							)
					)
					(if 
						(AND
							(= ops_reply_2 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_2 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Let me know if something changes."))	
								(vs_play_line miranda TRUE 020MA_150)
							)
					)
					(if 
						(AND
							(= ops_reply_3 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_3 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Should be alright, but stay sharp."))	
								(vs_play_line miranda TRUE 020MA_160)
							)
					)
					(if 
						(AND
							(= ops_reply_4 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_4 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Good catch. Send the word."))	
								(vs_play_line miranda TRUE 020MA_170)
							)
					)
				)
				(vs_approach_stop miranda)
				(sleep_until (= miranda_flee TRUE) 5 (random_range 60 120)) 
				(set ops_recent_check FALSE)
				(vs_release 01_marine_A)
				(sleep 1)
			)
		)
		(if (= miranda_flee FALSE)
			(begin
				(sleep_until (= ops_johnson_done TRUE))
				(sleep (random_range 60 120))
				(vs_cast command_center_marines02 FALSE 10 "020MA_120")
				(set 01_marine_A (vs_role 1))
				(if dialogue (print "MARINE: Have a look at this, ma'am."))
				(vs_play_line 01_marine_A TRUE 020MA_120)
				(sleep (random_range 15 45))
				(vs_approach miranda TRUE (ai_get_object 01_marine_A) .5 100 100)
				(sleep (random_range 30 60))
				(sleep_until (= ops_johnson_done TRUE))
				(sleep (random_range 30 60))
				(begin_random
					(if 
						(AND
							(= ops_reply_1 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_1 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Keep me posted."))	
								(vs_play_line miranda TRUE 020MA_140)
							)
					)
					(if 
						(AND
							(= ops_reply_2 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_2 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Let me know if something changes."))	
								(vs_play_line miranda TRUE 020MA_150)
							)
					)
					(if 
						(AND
							(= ops_reply_3 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_3 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Should be alright, but stay sharp."))	
								(vs_play_line miranda TRUE 020MA_160)
							)
					)
					(if 
						(AND
							(= ops_reply_4 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_4 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Good catch. Send the word."))	
								(vs_play_line miranda TRUE 020MA_170)
							)
					)
				)
				(vs_approach_stop miranda)
				(sleep_until (= miranda_flee TRUE) 5 (random_range 60 120)) 
				(set ops_recent_check FALSE)
				(vs_release 01_marine_A)
				(sleep 1)
			)
		)
		(if (= miranda_flee FALSE)
			(begin
				(sleep_until (= ops_johnson_done TRUE))
				(sleep (random_range 60 120))
				(vs_cast command_center_marines02 FALSE 10 "020MA_130")
				(set 01_marine_A (vs_role 1))
				(if dialogue (print "MARINE: Commander, you'll want to see this."))
				(vs_play_line 01_marine_A TRUE 020MA_130)
				(sleep (random_range 15 45))
				(vs_approach miranda TRUE (ai_get_object 01_marine_A) .5 100 100)
				(sleep (random_range 30 60))
				(sleep_until (= ops_johnson_done TRUE))
				(sleep (random_range 30 60))
				(begin_random
					(if 
						(AND
							(= ops_reply_1 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_1 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Keep me posted."))	
								(vs_play_line miranda TRUE 020MA_140)
							)
					)
					(if 
						(AND
							(= ops_reply_2 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_2 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Let me know if something changes."))	
								(vs_play_line miranda TRUE 020MA_150)
							)
					)
					(if 
						(AND
							(= ops_reply_3 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_3 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Should be alright, but stay sharp."))	
								(vs_play_line miranda TRUE 020MA_160)
							)
					)
					(if 
						(AND
							(= ops_reply_4 FALSE)
							(= ops_recent_check FALSE)
						)
							(begin
								(set ops_reply_4 TRUE)
								(set ops_recent_check TRUE)
								(if dialogue (print "Good catch. Send the word."))	
								(vs_play_line miranda TRUE 020MA_170)
							)
					)
					
				)
				(vs_approach_stop miranda)
				(sleep_until (= miranda_flee TRUE) 5 (random_range 60 120)) 
				(set ops_recent_check FALSE)
				(vs_release 01_marine_A)
				(sleep 1)
			)
		)		
	)
	
	(sleep_until (= miranda_flee TRUE) 5 (random_range 60 120))
	(set ops_mir_done TRUE)
)

; ===================================================================================================================================================

(global ai big_bad_brute NONE)
(script dormant 020_05_PA_talking

	(sleep_until (= (volume_test_players loop01_return_miranda_pa_trig) TRUE) 15 (random_range 450 900))
		(ai_dialogue_enable false)					
;		(sleep (ai_play_line_on_point_set 020MZ_140 miranda_PA_pts_01 7))
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_140_mir spkr_mir_01 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_140_mir spkr_mir_02 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_140_mir spkr_mir_03 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_140_mir spkr_mir_04 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_140_mir spkr_mir_05 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_140_mir spkr_mir_06 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_140_mir spkr_mir_07 1 1)
		(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MZ_140_mir)) ; 53962
		(sleep 20)
		(ai_dialogue_enable true)					

	(sleep_until (= (volume_test_players highway_a_start_trig) TRUE) 15 (random_range 450 900))
		(ai_dialogue_enable false)					
;		(sleep (ai_play_line_on_point_set 020MZ_220 miranda_PA_pts_01 7))
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_220_mir spkr_mir_01 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_220_mir spkr_mir_02 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_220_mir spkr_mir_03 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_220_mir spkr_mir_04 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_220_mir spkr_mir_05 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_220_mir spkr_mir_06 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_220_mir spkr_mir_07 1 1)
		(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MZ_220_mir)) ; 53962
		(sleep 20)
		(ai_dialogue_enable true)						

	(sleep_until (= (volume_test_players cave_a_hwy_marines01_trig) TRUE) 15 (random_range 450 900))
		(ai_dialogue_enable false)					
;		(sleep (ai_play_line_on_point_set 020MZ_230 miranda_PA_pts_01 7))
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_230_mir spkr_mir_01 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_230_mir spkr_mir_02 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_230_mir spkr_mir_03 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_230_mir spkr_mir_04 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_230_mir spkr_mir_05 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_230_mir spkr_mir_06 1 1)
			(sound_impulse_trigger sound\dialog\020_base\mission\020MZ_230_mir spkr_mir_07 1 1)
		(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MZ_230_mir)) ; 53962
		(sleep 20)
		(ai_dialogue_enable true)						
)

; ===================================================================================================================================================

(script dormant md_01_command_followers

	(if debug (print "mission dialogue:01:command:followers"))
		(vs_cast command_center_marines03/02 FALSE 11 "020MA_020")
			(set 01_marine_L (vs_role 1))
		(vs_cast command_center_marines03/01 FALSE 11 "020MA_010")
			(set 01_marine_M (vs_role 1))

	(vs_enable_pathfinding_failsafe 01_marine_L TRUE)
	(vs_enable_pathfinding_failsafe 01_marine_M TRUE)
	(sleep 5)
	(sleep_until	(OR
					(< (objects_distance_to_object (players) (ai_get_object 01_marine_L)) 2.5)
					(< (objects_distance_to_object (players) (ai_get_object 01_marine_M)) 2.5)
				)
	5)
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(if dialogue (print "MARINE: Follow me, sir!"))
		(vs_play_line 01_marine_M TRUE 020MA_010)
	(if dialogue (print "MARINE: Perimeter's this way!"))
		(vs_play_line 01_marine_L TRUE 020MA_020)
	(ai_dialogue_enable TRUE)		
	(vs_movement_mode 01_marine_M 1)		
	(vs_movement_mode 01_marine_L 1)
	(vs_go_to 01_marine_L FALSE command_center_intro/p0)
	(vs_go_to 01_marine_M TRUE command_center_intro/p3)
	(vs_go_to_and_face 01_marine_L FALSE command_center_intro/p5 command_center_intro/p6)
	(vs_go_to_and_face 01_marine_M TRUE command_center_intro/p6 command_center_intro/p5)
	(sleep_forever)
)

(script dormant md_01_command_followers02
			; cast the actors
		(vs_cast command_center_marines03/03 FALSE 10 "020MB_140")
			(set 01_marine_E1 (vs_role 1))
;		(vs_cast command_center_marines03/04 FALSE 10 "020MB_170")
;			(set 01_marine_F1 (vs_role 1))
	(vs_enable_pathfinding_failsafe 01_marine_E1 TRUE)
	(vs_enable_pathfinding_failsafe 01_marine_F1 TRUE)
	(sleep_until (volume_test_players command_center_intro_trig) 1)
			
	(sleep_until	(OR
					(< (objects_distance_to_object (players) (ai_get_object 01_marine_E1)) 4.5)
					(< (objects_distance_to_object (players) (ai_get_object 01_marine_F1)) 4.5)
				)
	1)
				  
	(if dialogue (print "MARINE: Come on, sir! I'll show you the way!"))
	(ai_play_line 01_marine_E1 020MB_140)
	(sleep 20)
	(vs_aim_object 01_marine_E1 TRUE command_door_init)
	(vs_go_to 01_marine_E1 TRUE command_center_intro/p2)
	
	(if dialogue (print "MARINE: Base was built for some 20th century war…"))
	(ai_play_line 01_marine_E1 020MB_150)
	(vs_go_to 01_marine_E1 TRUE command_center_intro/p4 0.1)		
	(sleep 45)
	
;	(vs_go_to_and_posture 01_marine_F1 FALSE command_center_intro/p1 "bunker_open")
;	(vs_go_to 01_marine_F1 FALSE command_center_intro/p1)
	(if (= (device_get_position command_door_init) 0)
		(begin
				(if dialogue (print "MARINE: It's full of old tech, like these door controls."))
				(vs_play_line 01_marine_E1 TRUE 020MB_160)
				(wake cave_a_door_lock)
				(if (= (device_get_position command_door_init) 0)
 					(begin
						(vs_custom_animation 01_marine_E1 false objects\characters\marine\marine "combat:rifle:base_button" TRUE command_center_intro/p4)
						(sleep 30)
						(device_set_position 020_01_c1a 1)
						(sleep 30)
						(vs_stop_custom_animation 01_marine_E1)
					)
				)
;				(sleep 1)
;				(device_ignore_player_set cave_a_door_command TRUE)
		
				(sleep 10)
				(sleep_until (= (vs_running_atom_dialogue 01_marine_E1) FALSE)1)
				
;				(vs_go_to_and_posture 01_marine_E1 FALSE command_center_intro/p2 "bunker_open")
;				(vs_go_to 01_marine_E1 FALSE command_center_intro/p2)				
			;	(if dialogue (print "MARINE: World War two, man. Learn some history."))
			;	(vs_play_line 01_marine_F1 TRUE 020MB_170)			
		)
		(begin
;			(vs_go_to_and_posture 01_marine_E1 FALSE command_center_intro/p2 "bunker_open")
			(vs_go_to 01_marine_E1 FALSE command_center_intro/p2)
		)
	)

	(sleep_forever)
)

(script dormant cave_a_door_lock
	(sleep_until (= (device_get_position command_door_init) 1)1)
	(device_set_power 020_01_c1a 0)
)

; ===================================================================================================================================================

(global boolean 01_sergeant_speaks FALSE)

(script dormant md_01_cave_marines
	(if debug (print "mission dialogue:01:cave:marines"))
		(wake 01_cave_entry)
		(wake 01_sergeant_dialog)
		(wake 01_follower_dialog)
;		(wake 01_door_repair)
)

(script command_script cs_turret_test_a
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_abort_on_damage TRUE)
	(cs_walk 1)
	(cs_go_by cave_a_patrols/t01a cave_a_patrols/t01a_p)
	(cs_go_by cave_a_patrols/t02a cave_a_patrols/t02a_p)
	(cs_go_to_and_face cave_a_patrols/t03a cave_a_patrols/t04a)
	(sleep 30)
	(cs_deploy_turret cave_a_turrets/p0)
	(cs_enable_targeting TRUE)
	(sleep_forever)
)
(script command_script cs_turret_test_b
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_abort_on_damage TRUE)
	(cs_walk 1)
	(cs_go_to_and_face cave_a_patrols/t01b cave_a_patrols/t02b)
	(sleep 30)
	(cs_deploy_turret cave_a_turrets/p1)
	(cs_enable_targeting TRUE)
	(sleep_forever)
)

(script command_script cave_a_pos_01
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_face cave_a_positions/aim_01 cave_a_positions/aim_here)
	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_pos_02
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_face cave_a_positions/aim_02 cave_a_positions/aim_here)
	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_pos_03
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_face cave_a_positions/aim_03 cave_a_positions/aim_here)
	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_pos_04
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_face cave_a_positions/aim_04 cave_a_positions/aim_here)
	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_pos_05
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_face cave_a_positions/aim_05 cave_a_positions/aim_here)
	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_pos_06
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_face cave_a_positions/aim_06 cave_a_positions/aim_here)
	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_pos_07
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_face cave_a_positions/aim_07 cave_a_positions/aim_here)
	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_pos_08
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_face cave_a_positions/aim_08 cave_a_positions/aim_here)
	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_pos_10
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_face cave_a_positions/aim_10 cave_a_positions/aim_here)
	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_pos_11
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_face cave_a_positions/aim_11 cave_a_positions/aim_here)
	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_corner_L01
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
;	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_posture cave_a_positions/corner_left_01 "corner_cover_left")
;	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_corner_L02
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
;	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_posture cave_a_positions/corner_left_02 "corner_cover_left")
;	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_corner_R01
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
;	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_posture cave_a_positions/corner_right_01 "corner_cover_right")
;	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_corner_R02
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
;	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_posture cave_a_positions/corner_right_02 "corner_cover_right")
;	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_bunker_01
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
;	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_posture cave_a_positions/bunker_01 "bunker_cover")
;	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_bunker_02
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
;	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_posture cave_a_positions/bunker_02 "bunker_cover")
;	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_bunker_03
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
;	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_posture cave_a_positions/bunker_03 "bunker_cover")
;	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_bunker_04
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
;	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_posture cave_a_positions/bunker_04 "bunker_cover")
;	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_bunker_05
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
;	(cs_draw)
;	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_posture cave_a_positions/bunker_05 "bunker_cover")
;	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_pos_sg1
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_face cave_a_positions/sg_1 cave_a_positions/aim_here)
	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)
(script command_script cave_a_pos_sg2
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_movement_mode 1)
;	(cs_force_combat_status 2)
	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(cs_go_to_and_face cave_a_positions/sg_2 cave_a_positions/aim_here)
	(cs_face TRUE cave_a_positions/aim_here)
	(sleep_forever)
)

(script dormant 01_sergeant_dialog
	(sleep_until (volume_test_players command_exit_trig)1)
	(vs_cast cave_a_marines04 TRUE 2 "020MB_010" "020MB_030" "020MB_040")
		(set 01_sergeant (vs_role 1))
		(set 01_marine_G (vs_role 2))
		(set 01_marine_H (vs_role 3))		
		(vs_enable_looking 01_marine_G TRUE)
		(vs_enable_looking 01_marine_H TRUE)
		(vs_enable_looking 01_sergeant  TRUE)	
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
		
	(if dialogue (print "Get those turrets up!"))
	(vs_play_line 01_sergeant TRUE 020MB_010)
	(sleep 10)
	
	(if dialogue (print "Watch your fields of fire!"))
	(vs_play_line 01_sergeant TRUE 020MB_020)
	(sleep 30)

	(if dialogue (print "MARINE: How'd they find us?"))
	(vs_play_line 01_marine_G TRUE 020MB_030)
	(sleep 10)
	
	(if dialogue (print "MARINE: Probably just smelled you, man."))
	(vs_face_object 01_marine_H TRUE (ai_get_object 01_marine_G))
	(vs_play_line 01_marine_H TRUE 020MB_040)		
	(sleep 10)

	(if dialogue (print "MARINE: Bite me. Was sick of hiding anyways…"))
	(vs_face_object 01_marine_G TRUE (ai_get_object 01_marine_H))
	(vs_play_line 01_marine_G TRUE 020MB_050)
	(sleep 10)

	(vs_face_object 01_marine_H FALSE (ai_get_object 01_marine_G))
	(vs_face_object 01_marine_G FALSE (ai_get_object 01_marine_H))

	(if dialogue (print "Quiet! Cut the chatter!"))
	(vs_play_line 01_sergeant TRUE 020MB_060)

	(sleep 30)

	(if dialogue (print "What is it Sergeant?"))
	(vs_play_line 01_marine_H TRUE 020MB_070)
	(sleep 20)

	(if dialogue (print "Calm before the storm, Marine..."))
	(vs_play_line 01_sergeant TRUE 020MB_080)
	(sleep 10)

	(if dialogue (print "Enjoy it"))
	(vs_play_line 01_sergeant TRUE 020MB_090)	
	
	(ai_dialogue_enable TRUE)	
	
	(vs_release_all)					
)

(script dormant 01_follower_dialog
	(sleep_until (volume_test_players cave_a_marine_1) 1)

	(vs_cast players_marines/actor01 FALSE 10 "020MB_180")
		(set follower_marine_A (vs_role 1))
	(vs_cast players_marines/actor02 FALSE 10 "020MB_190")
		(set follower_marine_B (vs_role 1))
		
	(vs_approach_player follower_marine_A FALSE 2 50 20)
	(vs_approach_player follower_marine_B TRUE 2 50 20)

	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
		
	(if dialogue (print "MARINE: We're with you, Chief!"))
	(vs_play_line follower_marine_A TRUE 020MB_180)
	(sleep 10)
	(if dialogue (print "MARINE: Yeah! Get some!"))
	(vs_play_line follower_marine_B TRUE 020MB_190)
	(ai_dialogue_enable TRUE)

	(vs_go_to follower_marine_A FALSE cave_a_patrols/p22)
	(vs_go_to follower_marine_B TRUE cave_a_patrols/p23)
	
	
	(if (volume_test_players cave_a_hwy_marines_trig)
		(begin
			(if dialogue (print "MARINE: Squad guarding the hangar's real short-handed, Chief…"))
			(sleep (ai_play_line follower_marine_A 020MB_220))
			
			(if (volume_test_players cave_a_hwy_marines_trig)
				(begin
					(if dialogue (print "MARINE: We don't get there quick, they're gonna get rolled!"))
					(ai_play_line follower_marine_B 020MB_230)
				)
			)		
		)
	)
	


	
)

; ===================================================================================================================================================

(script dormant 01_take_positions
	(sleep 60)
	(begin_random
		(if (!= cave_a_marines01/lefty02 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines01/lefty02 cave_a_corner_L02)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines01/lefty03 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines01/lefty03 cave_a_bunker_03)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines01/righty01 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines01/righty01 cave_a_corner_L01)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines01/righty02 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines01/righty02 cave_a_bunker_01)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines02/01 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines02/01 cave_a_bunker_02)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines02/02 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines02/02 cave_a_pos_08)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines02/03 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines02/03 cave_a_pos_07)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines03/01 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines03/01 cave_a_pos_04)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines03/02 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines03/02 cave_a_pos_05)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines04/01 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines04/01 cave_a_pos_06)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines04/02 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines04/02 cave_a_pos_sg1)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines04/03 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines04/03 cave_a_pos_sg2)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines05/01 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines05/01 cave_a_pos_11)
				(sleep (random_range 1 3))
			)
		)
		(if (!= cave_a_marines05/02 01_marine_G)
			(begin
				(cs_run_command_script cave_a_marines05/02 cave_a_pos_10)
				(sleep (random_range 1 3))
			)
		)
	)
)

(global boolean start_PA_system FALSE)
(script dormant 01_cave_entry
	(sleep_until (volume_test_players command_exit_trig) 5)
	(sleep_until (volume_test_players cave_a_entry_trig) 5 900)
	(wake 01_rumble_event_medium)
	(sound_impulse_stop "sound\dialog\020_base\mission\020MB_010_sg1.sound")
	(sound_impulse_stop "sound\dialog\020_base\mission\020MB_010_sg2.sound")
	(sound_impulse_stop "sound\dialog\020_base\mission\020MB_020_sg1.sound")
	(sound_impulse_stop "sound\dialog\020_base\mission\020MB_020_sg2.sound")	
	(sound_impulse_stop "sound\dialog\020_base\mission\020MB_030_ods.sound")
	(sound_impulse_stop "sound\dialog\020_base\mission\020MB_030_ma3.sound")
	(sound_impulse_stop "sound\dialog\020_base\mission\020MB_040_ma2.sound")
	(sound_impulse_stop "sound\dialog\020_base\mission\020MB_040_ma4.sound")	
	(sound_impulse_stop "sound\dialog\020_base\mission\020MB_050_ods.sound")
	(sound_impulse_stop "sound\dialog\020_base\mission\020MB_050_ma3.sound")
	(sound_impulse_stop "sound\dialog\020_base\mission\020MB_060_sg1.sound")
	(sound_impulse_stop "sound\dialog\020_base\mission\020MB_060_sg2.sound")
	(sleep_forever md_01_command_followers02)
	(sleep_forever 01_sergeant_dialog)
	(sleep 90)
		
	(wake 01_take_positions)

	(vs_cast cave_a_marines04 TRUE 10 "020MB_100")
		(set 01_sergeant (vs_role 1))
	(vs_cast cave_a_marines01/lefty01 TRUE 10 "020MB_110")
		(set 01_marine_G (vs_role 1))
	
	(if debug (print "mission dialogue:01:cave:entry"))

	(vs_enable_looking 01_sergeant TRUE)

	(vs_draw 01_sergeant)
	(vs_draw 01_marine_G)
	(vs_go_to 01_sergeant FALSE cave_a_positions/sarge)
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	
	(if dialogue (print "SERGEANT: Point of entry! Best assessment!"))
	(vs_play_line 01_sergeant TRUE 020MB_100)
	(sleep 10)

	(vs_face_object 01_marine_G TRUE (ai_get_object 01_sergeant))
	(if dialogue (print "MARINE: South hangar, Sergeant!"))
	(vs_play_line 01_marine_G TRUE 020MB_110)
	(sleep 10)
	(vs_face_object 01_marine_G FALSE (ai_get_object 01_sergeant))
	(vs_go_to_and_face 01_marine_G FALSE cave_a_positions/aim_03 cave_a_positions/aim_here)
;	(vs_release 01_marine_G)
	
	(vs_look_player 01_sergeant TRUE)
	(if (not (game_is_cooperative))
		(begin
			(if dialogue (print "SERGEANT: Agreed. Master Chief? Get there!"))
			(vs_play_line 01_sergeant TRUE 020MB_120)
		)
		(begin
								
			(if dialogue (print "SERGEANT: Agreed. Chief? Arbiter? Get there!"))
			(vs_play_line 01_sergeant TRUE 020MB_130)
		)
	)
	(ai_dialogue_enable TRUE)
	(wake obj_init_clear)
	(wake obj_hangar_a_set)		
	(vs_look_player 01_sergeant FALSE)
	(vs_face 01_marine_G TRUE cave_a_positions/aim_here)
	(ai_set_weapon_up 01_marine_G 1)
	(set start_PA_system TRUE)

	(sleep 300)
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object 01_sergeant)) 2))
	(ai_dialogue_enable FALSE)
	
	(if dialogue (print "SERGEANT: We'll guard the ops-center, Master Chief!"))
	(vs_look_player 01_sergeant TRUE)
	(vs_play_line 01_sergeant TRUE 020MB_200)	
	(sleep 10)

	(if dialogue (print "SERGEANT: You clear the Covenant out of the hangar!"))
	(vs_play_line 01_sergeant TRUE 020MB_210)
	(vs_look_player 01_sergeant FALSE)
	(ai_dialogue_enable TRUE)
	
	(vs_face 01_sergeant TRUE cave_a_positions/aim_here)
	
	(sleep_forever)	
)


; ===================================================================================================================================================

(script dormant 01_door_repair
	
	(sleep_until (volume_test_players cave_a_door_repair_trig) 1)

	(vs_cast cave_a_marines07/actor FALSE 10 "020MC_010")
		(set 01_marine_J (vs_role 1))
	(vs_cast cave_a_marines07/actor02 FALSE 10 "")
		(set 01_marine_K (vs_role 1))		

	(vs_enable_looking players_marines  TRUE)

    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

	(if dialogue (print "MARINE: Door's jammed, sir!"))
	(vs_play_line 01_marine_J TRUE 020MC_010)

	(if dialogue (print "MARINE: You'll have to head the other way to the hangar!"))		
	(vs_play_line 04_marine_A TRUE 020MC_011)
	(ai_dialogue_enable TRUE)
		
	
)
; ===================================================================================================================================================

(global short cave_a_rand01 0)
(global short cave_a_rand02 0)


(script command_script 01_cave_a_runner01
	(set cave_a_rand01 (random_range 1 5))
	(cs_enable_pathfinding_failsafe TRUE)
;	(cs_movement_mode 1)	
	(sleep_until
		(begin
			(cond
				((= cave_a_rand01 2)
					(begin
						(cs_go_to cave_a_patrols/p2)
						(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)1 300)
						(set cave_a_rand01 (random_range 1 5))
					)
				)
				((= cave_a_rand01 3)
					(begin
						(cs_go_to cave_a_patrols/p7)
						(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)1 300)
						(set cave_a_rand01 (random_range 1 5))
					)
				)
				((= cave_a_rand01 4)
					(begin
						(cs_go_to cave_a_patrols/p0)
						(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)1 300)
						(set cave_a_rand01 (random_range 1 5))
					)
				)				
				((= cave_a_rand01 5)
					(begin
						(cs_go_to cave_a_patrols/p9)
						(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)1 300)
						(set cave_a_rand01 (random_range 1 5))
					)
				)
			)
		FALSE)
	1)												
)


(script command_script 01_cave_a_runner02
	(set cave_a_rand02 (random_range 1 5))
	(cs_enable_pathfinding_failsafe TRUE)
;	(cs_movement_mode 1)	
	(sleep_until
		(begin
			(cond
				((= cave_a_rand02 1)
					(begin
						(cs_go_to cave_a_patrols/p10)
						(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)1 300)
						(set cave_a_rand02 (random_range 1 5))
					)
				)
				((= cave_a_rand02 2)
					(begin
						(cs_go_to cave_a_patrols/p11)
						(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)1 300)
						(set cave_a_rand02 (random_range 1 5))
					)
				)
				((= cave_a_rand02 3)
					(begin
						(cs_go_to cave_a_patrols/p3)
						(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)1 300)
						(set cave_a_rand02 (random_range 1 5))
					)
				)
				((= cave_a_rand02 4)
					(begin
						(cs_go_to cave_a_patrols/p6)
						(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)1 300)
						(set cave_a_rand02 (random_range 1 5))
					)
				)				
				((= cave_a_rand02 5)
					(begin
						(cs_go_to cave_a_patrols/p12)
						(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)1 300)
						(set cave_a_rand02 (random_range 1 5))
					)
				)
			)
		FALSE)
	1)												
)
		
; ===================================================================================================================================================

(script dormant md_01_hw_followers
	(sleep_until (volume_test_players cave_a_hwy_marines02_trig) 1)
	(sleep_until (= briefing_play FALSE))
	(sleep_forever 01_follower_dialog)

	(vs_cast players_marines/actor01 FALSE 5 "020MC_010")
		(set follower_marine_A (vs_role 1))
	(vs_cast players_marines/actor02 FALSE 5 "020MC_030")
		(set follower_marine_B (vs_role 1))	
	
	(if debug (print "mission dialogue:01:hw:followers"))
	; movement properties
	(vs_enable_pathfinding_failsafe players_marines TRUE)
	(vs_enable_looking players_marines  TRUE)
	(vs_enable_targeting players_marines TRUE)
	(vs_enable_moving players_marines TRUE)
	
	(vs_set_cleanup_script md_cleanup)

	(sleep 1)
		(ai_dialogue_enable false)						
		(if dialogue (print "MARINE: If they secure the hangar…"))
		(sleep (ai_play_line follower_marine_A 020MC_020))

		(if dialogue (print "MARINE: They can fly their Phantoms right into the base!"))
		(sleep (ai_play_line follower_marine_A 020MC_021))

		(if dialogue (print "MARINE: No way the Chief's gonna let that happen!"))
		(sleep (ai_play_line follower_marine_A 020MC_030))
		(ai_dialogue_enable true)						

	; cleanup
	(vs_release_all)

)

; ===================================================================================================================================================

(script dormant md_04_hangar_a_combat
	(if debug (print "mission dialogue:04:hw:joh:radio"))
	(sleep_until (= var_hangar_a_pos 1))	
	(sleep 1)
	(vs_cast players_marines FALSE 10 "020ME_030")
	(set 04_marine_A (vs_role 1))	
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable false)									
	(if dialogue (print "MARINE: Wipe those bastards off the deck!"))		
	(vs_play_line 04_marine_A TRUE 020ME_030)	
	(ai_dialogue_enable true)										

	(sleep_until (= var_hangar_a_pos 2)5 600)
	(sleep 1)

;	(vs_cast players_marines FALSE 10 "020ME_010")
;	(set 04_marine_A (vs_role 1))	
;	(ai_dialogue_enable false)												
;	(if dialogue (print "MARINE: Use the turret, Chief!"))
;	(vs_play_line 04_marine_A TRUE 020ME_010)
;	(sleep 10)
;	(ai_dialogue_enable true)										

;*
	(sleep 600)
	
	(vs_cast players_marines FALSE 10 "020ME_070")
	(set 04_marine_A (vs_role 1))
	;swapped around with the one above
	(if dialogue (print "MARINE: Nail the Phantom's chin-gun!"))					
	(vs_play_line 04_marine_A TRUE 020ME_070)
	(sleep 10)		
*;		
	(sleep_until (= var_hangar_a_pos 3))	
	(sleep 1)
	(vs_cast players_marines FALSE 10 "020ME_040")
	(set 04_marine_A (vs_role 1))
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable false)											
	(if dialogue (print "MARINE: Pelicans can't launch until the hangar's clear!"))					
	(vs_play_line 04_marine_A TRUE 020ME_040)
	(sleep 10)								
	(ai_dialogue_enable true)										

)

(script dormant md_04_hangar_a_pelican
; look into trigger volume here
	(ai_dialogue_enable false)										
	(if dialogue (print "PILOT: Need you to step aside, sir! Can't lower the Pelican 'til you do!"))				
	(sleep (ai_play_line_on_object NONE 020ME_090))
	(sleep 10)
	(ai_dialogue_enable true)											
)

(script dormant md_hangar_a_radio_johnson
	(sleep (* 30 10))
;		(if dialogue (print "JOHNSON (radio): Chief? I'm getting the Commander out of here…"))
;		(sleep (ai_play_line_on_object NONE 020ME_130))
;		(sleep 10)

	(if (<= base_obj_control 40)
		(begin
			(ai_dialogue_enable false)
													
			(if dialogue (print "JOHNSON (radio): Chief! Ops-center! Double-time!"))
			(sleep (ai_play_line_on_object NONE 020ME_170))
			(sleep 10)
			(if dialogue (print "JOHNSON (radio): Brutes are pressing hard."))
			(sleep (ai_play_line_on_object NONE 020ME_140))
			(sleep 10)
			
			(ai_dialogue_enable true)										
		)
	)

	
;		(if dialogue (print "JOHNSON (radio): Come on back to the ops-center!"))
;		(sleep (ai_play_line_on_object NONE 020ME_150))
		(wake obj_hangar_a_clear)
		(wake obj_return_command_center_set)
		(sleep (* 30 60 1))

	(if (<= base_obj_control 40)
		(begin
			(ai_dialogue_enable false)
													
			(if dialogue (print "JOHNSON (radio): C'mon, Chief! Hustle on back!"))
			(sleep (ai_play_line_on_object NONE 020ME_160))
			
			(ai_dialogue_enable true)										
		)
	)
)
;* REMOVED
(script command_script help_player
	(sleep_until
		(begin
			(cs_movement_mode 1)
			(cs_approach_player 2 50 20)
			(sleep_until (< (objects_distance_to_object (players) (ai_get_object hangar_a_helper)) 1))
			(cs_play_line 020me_220)
			(cs_approach_stop)		
			(cs_go_to hangar_a_patrol/p13)
		FALSE)
	120)
)
			
(script command_script end_help
	(cs_play_line 020me_240)
	(ai_set_objective hangar_a_helper loop01_return_obj)
)
*;
(script dormant md_04_hangar_miranda_pa
	(sleep_until (players_not_in_combat))
	(if debug (print "mission dialogue:04:hangar:miranda:pa"))
	(ai_dialogue_enable false)												
		
	(if dialogue (print "MIRANDA (PA system): All personnel, this is Commander Keyes."))
	(sleep (ai_play_line_on_object NONE 020ME_180))
	(sleep 10)

	(if dialogue (print "MIRANDA (PA system): Covenant have breached the base."))
	(sleep (ai_play_line_on_object NONE 020ME_190))
	(sleep 10)

	(if dialogue (print "MIRANDA (PA system): I repeat: we have Covenant inside the base!"))
	(sleep (ai_play_line_on_object NONE 020ME_200))
	(sleep 10)

	(if dialogue (print "MIRANDA (PA system): Fall back, prepare for evac!"))
	(sleep (ai_play_line_on_object NONE 020ME_210))
	(ai_dialogue_enable true)												
	
	(sleep 300)
		
)

; ===================================================================================================================================================

(script dormant md_05_bugger_marine
	(sleep_until (= bugger_attack true)5)

	(if debug (print "mission dialogue:03:bugger:marine"))

		; cast the actors
		(vs_cast bugger_intro_hum01/actor01 FALSE 10 "020MF_010")
			(set 03_marine_C (vs_role 1))
		(vs_cast bugger_intro_hum01/actor03 FALSE 10 "020MF_020")
			(set 03_marine_D (vs_role 1))
		(vs_cast bugger_intro_hum01/sergeant01 TRUE 10 "020MF_040")
			(set 03_sergeant_A (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe bugger_intro_hum01 TRUE)
	(vs_enable_looking bugger_intro_hum01  TRUE)
	(vs_enable_targeting bugger_intro_hum01 TRUE)
	(vs_enable_moving bugger_intro_hum01 TRUE)

	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable false)												

	(if dialogue (print "MARINE 01: Look! Coming out of the vents!"))
	(vs_play_line 03_marine_C TRUE 020MF_010)
	(sleep 10)
	(sound_looping_set_alternate levels\solo\020_base\music\020_music_06 TRUE)

	(if dialogue (print "MARINE 02: Light 'em up! Light 'em up!"))
	(vs_play_line 03_marine_D TRUE 020MF_020)
	(sleep 10)

	(if dialogue (print "MARINE 01: What the hell are these things, Sergeant?!"))
	(vs_play_line 03_marine_C TRUE 020MF_030)
	(sleep 10)

	(if dialogue (print "SERGEANT: Drones! A whole swarm!"))
	(vs_play_line 03_sergeant_A TRUE 020MF_040)
	(sleep 10)

	(if dialogue (print "SERGEANT: Take 'em down! Short, controlled bursts!"))
	(vs_play_line 03_sergeant_A TRUE 020MF_050)
		(sleep 10)		
	(ai_dialogue_enable true)
	(ai_disregard (ai_actors bugger_squad00) FALSE)	
	(ai_disregard (ai_actors bugger_intro_hum01) FALSE)													

)
(script dormant md_05_bugger_marine01

	(if debug (print "mission dialogue:03:bugger:marine"))

		; cast the actors
		(vs_cast bugger_intro_hum01/sergeant01 TRUE 10 "020MF_040")
			(set 03_sergeant_A (vs_role 1))
	(sleep_until (< (ai_living_count bugger_intro_cov) 1)1)
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object 03_sergeant_A)) 2))
    
    (vs_set_cleanup_script md_cleanup)

	(ai_dialogue_enable false)													
	(if dialogue (print "SERGEANT: We're good for now, Chief…"))
	(vs_play_line 03_sergeant_A TRUE 020MF_060)
	(ai_dialogue_enable true)													
	(sleep 300)

	(sleep_until (< (objects_distance_to_object (players) (ai_get_object 03_sergeant_A)) 2))
	(ai_dialogue_enable false)												
	(if dialogue (print "SERGEANT: Go on. Sergeant Major's waiting for you upstairs!"))
	(vs_play_line 03_sergeant_A TRUE 020MF_070)
	(ai_dialogue_enable true)													
	(sleep 600)

	(sleep_until (< (objects_distance_to_object (players) (ai_get_object 03_sergeant_A)) 2))
	(ai_dialogue_enable false)												
	(if dialogue (print "SERGEANT: Go on, Chief! Sergeant Major's waiting!"))
	(vs_play_line 03_sergeant_A TRUE 020MF_100)
	(sleep 10)	
	(ai_dialogue_enable true)
)
(script dormant md_06_bugger_marine02
	
	(sleep_until (volume_test_players highway_second_part_trig)5)
	(sleep 60)
	(ai_dialogue_enable false)												
	(if dialogue (print "SERGEANT: Hey. You hear that?"))
	(sleep (ai_play_line loop01_return_hw01/03 020MX_030))
	(if dialogue (print "SERGEANT: Yeah. And I don’t like it."))
	(sleep (ai_play_line loop01_return_hw01/04 020MX_040))
	(set g_music_020_06	TRUE)
	(ai_dialogue_enable true)	
	(sleep_forever)
)
; ===================================================================================================================================================

(script dormant md_05_bugger_miranda_pa

	(if debug (print "mission dialogue:03:bugger:miranda:pa"))
	
	(sleep 1)
	(ai_dialogue_enable false)												

		(if dialogue (print "MIRANDA (PA system): Medical teams: re-route to the north hangar!"))
		(sleep (ai_play_line_on_object NONE 020MF_120))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Fire teams: plant your packages, and fall back!"))
		(sleep (ai_play_line_on_object NONE 020MF_130))
		(sleep 10)
	(ai_dialogue_enable true)												
		
)


; ===================================================================================================================================================

(script dormant md_05_cave_marines
	(sleep_until (= (device_get_position cave_a_door_command) 1)1)
	(vs_cast Loop02_Begin_Vig03 TRUE 10 "020MF_060")
		(set 05_marine_A (vs_role 1))
	(if debug (print "mission dialogue:05:cave:marines"))

	; movement properties
	(vs_enable_pathfinding_failsafe Loop02_Begin_Vig03 TRUE)
	(vs_movement_mode 05_marine_A 1)	
	(vs_set_cleanup_script md_cleanup)
	(sleep 900)
	(sleep 1)
	(sleep_until (volume_test_players command_exit_trig)1)
	(if (< (ai_living_count bugger_intro_cov) 1)
		(begin
		(ai_dialogue_enable false)												
	
			(if dialogue (print "MARINE: Cleaned those bugs out good, sir…"))
			(vs_play_line 05_marine_A TRUE 020MF_060)
			(sleep 10)

			(if dialogue (print "MARINE: Sergeant Major's waiting for you upstairs!"))
			(vs_play_line 05_marine_A TRUE 020MF_070)
		(ai_dialogue_enable true)												
		
		)
	)
	
	
;	(sleep 600)
;	(sleep_until (< (objects_distance_to_object (players) (ai_get_object 05_marine_A)) 2))
;	(if dialogue (print "MARINE: Head on up, sir! Sergeant Major's waiting!"))
;	(vs_play_line 05_marine_A TRUE 020MF_110)
;	(sleep 10)
	(vs_release_all)
)
; ===================================================================================================================================================


(script dormant md_06_motorpool_brutes
	(sleep_until (> (device_get_position motor_pool_start_door) 0))
	(set g_music_020_07 TRUE)
	(set g_music_020_065 FALSE)
	(if debug (print "mission dialogue:06:motorpool:brutes"))

		; cast the actors
		(vs_cast motor_pool_armor_chieftain TRUE 10 "020MH_010")
			(set 06_brute_A (vs_role 1))		
	(vs_abort_on_alert TRUE)
	(vs_set_cleanup_script MotorPool_Abort)

	(sleep (random_range 30 90))
	(ai_dialogue_enable false)												

		(if dialogue (print "BRUTE: (sniffs) A fresh scent! It must be close…"))
		(vs_play_line 06_brute_A TRUE 020MH_010)
		(sleep 10)

		(if dialogue (print "BRUTE: Spread out! Track it down!"))
		(vs_play_line 06_brute_A TRUE 020MH_020)
		(sleep 10)
		(set g_music_020_07 FALSE)
		(set g_music_020_08 true)
		
	(ai_dialogue_enable true)														
		
	(cs_run_command_script motor_pool_brute02/01 motor_patrol01)
	(cs_run_command_script motor_pool_brute02/02 motor_patrol02)
	(cs_run_command_script motor_pool_brute02/03 motor_patrol03)	
)

(script static void MotorPool_Abort
		(set g_music_020_07 FALSE)
		(set g_music_020_08 true)
		(ai_dialogue_enable TRUE)
)

(global short rand_patrol01 0)
(global short rand_patrol02 0)

(script command_script motor_patrol01
	(cs_movement_mode ai_movement_combat)
	(cs_abort_on_alert true)
	(sleep (random_range 5 60))
	(cs_draw)
	(cs_go_to motor_pool_patrol/p23)
	(cs_walk true)	
	(sleep_until
		(begin
			(set rand_patrol01 (random_range 0 6))
			(cond 
				((= rand_patrol01 0) (cs_go_to_and_posture motor_pool_patrol/p13 "act_examine_1"))
				((= rand_patrol01 1) (cs_go_to motor_pool_patrol/p10))
				((= rand_patrol01 2) (cs_go_to motor_pool_patrol/p18))
				((= rand_patrol01 3) (cs_go_to_and_posture motor_pool_patrol/p12 "act_examine_1"))
				((= rand_patrol01 4) (cs_go_to motor_pool_patrol/p11))
				((= rand_patrol01 5) (cs_go_to motor_pool_patrol/p21))
			)
		false)
	)
)
(script command_script motor_patrol02
	(cs_movement_mode 2)
	(cs_abort_on_alert true)
	(sleep (random_range 5 60))	
	(cs_draw)	
	(cs_go_to motor_pool_patrol/p22)
	(cs_walk true)
	(sleep_until
		(begin
			(set rand_patrol02 (random_range 0 6))
			(cond 
				((= rand_patrol02 0) (cs_go_to motor_pool_patrol/p14))
				((= rand_patrol02 1) (cs_go_to_and_posture motor_pool_patrol/p19 "act_examine_1"))
				((= rand_patrol02 2) (cs_go_to motor_pool_patrol/p15))
				((= rand_patrol02 3) (cs_go_to_and_posture motor_pool_patrol/p16 "act_examine_1"))
				((= rand_patrol02 4) (cs_go_to motor_pool_patrol/p17))
				((= rand_patrol02 5) (cs_go_to motor_pool_patrol/p20))
			)
		false)
	))
(script command_script motor_patrol03
	(cs_movement_mode 2)
	(cs_abort_on_alert true)	
	(sleep (random_range 5 60))	
	(cs_draw)	
	(cs_go_to_and_posture motor_pool_patrol/p24 "act_guard_1")	
	(sleep_forever)
)
; ===================================================================================================================================================
(script dormant md_06_hw_joh
	(sleep_until (or (< (ai_living_count motor_pool_all) 1) (volume_test_players sewer01_trig))1)
	(if debug (print "mission dialogue:06:hw:joh"))
		(sleep 1800)
	;	(wake 020BD_briefing)
		(sleep_until (= cortana_talking false)5)	

		(ai_dialogue_enable false)												
			
		(if dialogue (print "JOHNSON (radio): Covenant bombers are hitting the base, Chief…"))
		(sleep (ai_play_line_on_object NONE 020MH_030))
		(sleep 10)

		(if dialogue (print "JOHNSON (radio): Most direct route to the barracks has been cut off."))
		(sleep (ai_play_line_on_object NONE 020MH_040))
		(sleep 10)

		(if dialogue (print "JOHNSON (radio): Gonna have to find another way down there…"))
		(sleep (ai_play_line_on_object NONE 020MH_050))
		(sleep 10)
	(ai_dialogue_enable true)												
											
)

; ===================================================================================================================================================

(script dormant md_06_motorpool_johnson_pa

	(if debug (print "mission dialogue:06:motorpool:johnson:pa"))

;		(if dialogue (print "JOHNSON (PA system): All teams: fall back to the north hangar!."))
;		(sleep (ai_play_line_on_object NONE 020MH_080))
;		(sleep 20)
		(sleep_until (= cortana_talking false)5)
	(ai_dialogue_enable false)												

		(if dialogue (print "JOHNSON (PA system): We're abandoning the base!"))
		(sleep (ai_play_line_on_object NONE 020MH_090))
		(sleep 20)

		(if dialogue (print "JOHNSON (PA system): Get to the hangar, or you will be left behind!"))
		(sleep (ai_play_line_on_object NONE 020MH_100))
		(sleep 20)
	(ai_dialogue_enable true)												

)

; ===================================================================================================================================================

(script dormant md_07_evac_arbiter
	(if debug (print "mission dialogue:07:evac:arbiter"))
	
	
	(if (not (game_is_cooperative))
		(begin
			(vs_cast 020_arbiter TRUE 10 "020MI_010")
				(set arbiter (vs_role 1))
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable false)												

				(vs_enable_pathfinding_failsafe 020_arbiter TRUE)
				(vs_enable_looking 020_arbiter  TRUE)
				(vs_enable_targeting 020_arbiter TRUE)
				(vs_enable_moving 020_arbiter TRUE)

			(if (= (device_get_position 020_06_d1) 0)
				(begin	
					(if dialogue (print "ARBITER: Half-wit insects!"))
					(vs_play_line arbiter TRUE 020MI_010)
					(sleep 10)
				)
			)
			(if (= (device_get_position 020_06_d1) 0)
				(begin	
					(if dialogue (print "ARBITER: The Prophets use you like they used me!"))
					(vs_play_line arbiter TRUE 020MI_020)
					(sleep 10)
				)
			)
			(if (= (device_get_position 020_06_d1) 0)
				(begin	
					(if dialogue (print "ARBITER: Reject their lies! Rebel!"))
					(vs_play_line arbiter TRUE 020MI_030)
					(sleep 10)
				)
			)
			(if (= (device_get_position 020_06_d1) 0)
				(begin	
					(if dialogue (print "ARBITER: Or all your hives will perish!"))
					(vs_play_line arbiter TRUE 020MI_040)
					(sleep 10)
				)
			)
				(set g_music_020_09 FALSE)
				(set g_music_020_10 FALSE)			
			
		
			(sleep_until	(or
							(> (device_get_position 020_06_d1) 0)
							(volume_test_players sewer_vignette_trig)
						)
			)
			(sleep_until	(or 
							(> (device_get_position 020_06_d1) 0)
							(< (ai_living_count arbiter_buggers01) 1)
						)
			)
		
				(vs_enable_pathfinding_failsafe 020_arbiter FALSE)
				(vs_enable_looking 020_arbiter FALSE)
				(vs_enable_targeting 020_arbiter FALSE)
				(vs_enable_moving 020_arbiter FALSE)
				(sleep (random_range 45 75))
	
			(if (= (device_get_position 020_06_d1) 0)
				(begin	
					(vs_aim_player arbiter true)
						(sleep 15)
					(if dialogue (print "ARBITER: Spartan. The Brutes have taken your soldiers…"))
					(vs_play_line arbiter TRUE 020MJ_010)
					(sleep 10)
				)
			)
			(if (= (device_get_position 020_06_d1) 0)
				(begin	
					(if dialogue (print "ARBITER: As prisoners or meat for their bellies, I do not know."))
					(vs_play_line arbiter TRUE 020MJ_020)
					(sleep 10)
				)
			)
			(if (= (device_get_position 020_06_d1) 0)
				(begin	
					(if dialogue (print "ARBITER: In case some yet live…Let us be careful what we shoot.."))
					(vs_play_line arbiter TRUE 020MJ_030)
					(sleep 10)
				)
			)
				(sleep 30)
				(vs_aim_player arbiter false)											
				(wake obj_evacuate_set)
				(vs_lower_weapon arbiter TRUE)
				(vs_go_to_and_posture arbiter FALSE arbiter_vignette/p0 "crouch")
				(sleep_until (= (device_get_position 020_06_d1) 1))
				(vs_lower_weapon arbiter FALSE)
	(ai_dialogue_enable true)				
	(vs_release arbiter)
		)
	)
)

; ===================================================================================================================================================



(script static void Barracks_Marine01_Anim
	(sleep 1)
	(if (OR (< var_barracks_pos 5)(> (ai_living_count barracks_cov_all) 0))
		(cs_run_command_script barracks_marine01 barracks_marine01_flee)
		(begin
			(unit_add_equipment (ai_get_unit barracks_marine01) barracks_marine01_profile TRUE TRUE)
			(ai_set_blind barracks_marine01 FALSE)
			(ai_set_deaf barracks_marine01 FALSE)	
			(ai_disregard (ai_actors barracks_marine01) FALSE)		
			(ai_set_objective barracks_marine01 barracks_marine_obj)	
		)
	)
	(sleep_until (= (device_get_position barracks_door_end) 1) 1)
	(sleep 60)
	(ai_migrate barracks_marine01 evac_hangar_marine01)		
)


(script command_script barracks_marine01_flee 
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_flee)
	(ai_disregard (ai_actors barracks_marine01) FALSE)
	(cs_go_to barracks_first_save/p0)
	(ai_play_line barracks_marine01 020MJ_040)						
	(cs_go_to barracks_first_save/p1)
	; check to see if the player is close to this actor
	(cs_crouch TRUE 60)
	(unit_add_equipment (ai_get_unit barracks_marine01) barracks_marine01_profile TRUE TRUE)
	(ai_set_blind barracks_marine01 FALSE)
	(ai_set_deaf barracks_marine01 FALSE)	
	(ai_set_objective barracks_marine01 barracks_marine_obj)
)

(script static void Barracks_Marine02_Anim
	(sleep 15)
	(if (OR (< var_barracks_pos 5)(> (ai_living_count barracks_cov_all) 0))
		(cs_run_command_script barracks_marine02 barracks_marine02_flee)
		(begin
			(unit_add_equipment (ai_get_unit barracks_marine02) barracks_marine02_profile TRUE TRUE)
			(ai_set_blind barracks_marine02 FALSE)
			(ai_set_deaf barracks_marine02 FALSE)	
			(ai_disregard (ai_actors barracks_marine02) FALSE)		
			(ai_set_objective barracks_marine02 barracks_marine_obj)	
		)
	)
	(sleep_until (= (device_get_position barracks_door_end) 1) 1)
	(sleep 60)	
	(ai_migrate barracks_marine02 evac_hangar_marine02)		
)

(script command_script barracks_marine02_flee 
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_flee)
	(ai_disregard (ai_actors barracks_marine02) FALSE)
	(cs_go_to barracks_second_save/p0)
	(ai_play_line barracks_marine02 020MJ_050)										
	; check to see if the player is close to this actor
	(cs_crouch TRUE 60)
	(unit_add_equipment (ai_get_unit barracks_marine02) barracks_marine02_profile TRUE TRUE)
	(ai_set_blind barracks_marine02 FALSE)
	(ai_set_deaf barracks_marine02 FALSE)	
	(ai_set_objective barracks_marine02 barracks_marine_obj)	
)

(script static void Barracks_Marine03_Anim
	(sleep 30)
	(if (OR (< var_barracks_pos 5)(> (ai_living_count barracks_cov_all) 0))
		(cs_run_command_script barracks_marine03 barracks_marine03_flee)
		(begin
			(unit_add_equipment (ai_get_unit barracks_marine03) barracks_marine05_profile TRUE TRUE)
			(ai_disregard (ai_actors barracks_marine03) FALSE)						
			(ai_set_blind barracks_marine03 FALSE)
			(ai_set_deaf barracks_marine03 FALSE)			
			(ai_set_objective barracks_marine03 barracks_marine_obj)	
		)
	)
	(sleep_until (= (device_get_position barracks_door_end) 1) 1)
	(sleep 60)	
	(ai_migrate barracks_marine03 evac_hangar_marine03)	
)

(script command_script barracks_marine03_flee 
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_flee)
	(ai_disregard (ai_actors barracks_marine03) FALSE)
	(cs_go_to barracks_second_save/p1)
	; check to see if the player is close to this actor
	(cs_crouch TRUE 60)
	(unit_add_equipment (ai_get_unit barracks_marine03) barracks_marine05_profile TRUE TRUE)
	(ai_set_blind barracks_marine03 FALSE)
	(ai_set_deaf barracks_marine03 FALSE)	
	(ai_set_objective barracks_marine03 barracks_marine_obj)	
)


(script dormant Barracks_Marine04_Anim
	(sleep_until (AND (< (ai_living_count barracks_pack1_01) 1)(< (ai_living_count barracks_pack2_01) 1)) 1)
	(sleep 5)
	(ai_activity_abort barracks_marine04)		
	(if (OR (< var_barracks_pos 5)(> (ai_living_count barracks_cov_all) 0))
		(cs_run_command_script barracks_marine04 barracks_marine04_flee)
		(begin
			(unit_add_equipment (ai_get_unit barracks_marine04) barracks_marine03_profile TRUE TRUE)
			(ai_set_blind barracks_marine04 FALSE)
			(ai_set_deaf barracks_marine04 FALSE)	
			(ai_disregard (ai_actors barracks_marine04) FALSE)			
			(ai_set_objective barracks_marine04 barracks_marine_obj)	
		)
	)
	(sleep_until (= (device_get_position barracks_door_end) 1) 1)
	(sleep 60)	
	(ai_migrate barracks_marine04 evac_hangar_marine04)	
)

(script command_script barracks_marine04_flee 
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_flee)
	(ai_disregard (ai_actors barracks_marine04) FALSE)				
	(cs_go_to barracks_second_save/p2)
	(cs_crouch TRUE 60)
	(unit_add_equipment (ai_get_unit barracks_marine04) barracks_marine03_profile TRUE TRUE)
	(ai_set_blind barracks_marine04 FALSE)
	(ai_set_deaf barracks_marine04 FALSE)	
	(ai_set_objective barracks_marine04 barracks_marine_obj)	
)

(script dormant Barracks_Marine05_Anim
	(sleep_until (or (< (ai_living_count barracks_pack4_01) 1)(volume_test_players barracks_marine05_rescue_trig))5)
	(sleep 30)			
	(ai_activity_abort barracks_marine05)
	(ai_play_line barracks_marine05 020MJ_110)								
	;this checks to see if the player has made it to the end of the barracks or killed the brutes, if not, then play their 'hostage actions'
	(if (OR (< var_barracks_pos 5)(> (ai_living_count barracks_cov_all) 0))
		(cs_run_command_script barracks_marine05 barracks_marine05_flee)
		(begin
			(unit_add_equipment (ai_get_unit barracks_marine05) barracks_marine04_profile TRUE TRUE)
			(ai_set_blind barracks_marine05 FALSE)
			(ai_set_deaf barracks_marine05 FALSE)	
			(ai_disregard (ai_actors barracks_marine05) FALSE)				
			(ai_set_objective barracks_marine05 barracks_marine_obj)	
		)
	)
	(sleep_until (= (device_get_position barracks_door_end) 1) 1)
	(sleep 60)	
	(ai_migrate barracks_marine05 evac_hangar_marine05)	
)

(script command_script barracks_marine05_flee
;	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_flee)
	(ai_disregard (ai_actors barracks_marine05) FALSE)				
	(cs_go_to barracks_third_save/p0)
	; check to see if the player is close to this actor
	(cs_crouch TRUE 60)
	(unit_add_equipment (ai_get_unit barracks_marine05) barracks_marine04_profile TRUE TRUE)
	(ai_set_blind barracks_marine05 FALSE)
	(ai_set_deaf barracks_marine05 FALSE)	
	(ai_set_objective barracks_marine05 barracks_marine_obj)	
)

(script dormant Barracks_Marine06_Anim
	(sleep_until (or (< (ai_living_count barracks_pack4_01) 1)(volume_test_players barracks_marine05_rescue_trig))5)
	(ai_activity_abort barracks_marine06)	
	(sleep 5)
	(ai_play_line barracks_marine06 020MJ_100)	;52857								
	;this checks to see if the player has made it to the end of the barracks or killed the brutes, if not, then play their 'hostage actions'	
	(if (OR (< var_barracks_pos 5)(> (ai_living_count barracks_cov_all) 0))
		(cs_run_command_script barracks_marine06 barracks_marine06_flee)
		(begin	
			(unit_add_equipment (ai_get_unit barracks_marine06) barracks_marine02_profile TRUE TRUE)
			(ai_set_blind barracks_marine06 FALSE)
			(ai_set_deaf barracks_marine06 FALSE)
			(ai_disregard (ai_actors barracks_marine06) FALSE)				
			(ai_set_objective barracks_marine06 barracks_marine_obj)	
		)
	)
	(sleep_until (= (device_get_position barracks_door_end) 1) 1)
	(sleep 60)	
	(ai_migrate barracks_marine06 evac_hangar_marine06)	
)

(script command_script barracks_marine06_flee
;	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_flee)
	(ai_disregard (ai_actors barracks_marine06) FALSE)
	(cs_go_to barracks_third_save/p1)
	; check to see if the player is close to this actor
	(cs_crouch TRUE 60)
	(unit_add_equipment (ai_get_unit barracks_marine06) barracks_marine02_profile TRUE TRUE)
	(ai_set_blind barracks_marine06 FALSE)
	(ai_set_deaf barracks_marine06 FALSE)
	(ai_set_objective barracks_marine06 barracks_marine_obj)	
	
)

(script dormant Barracks_Marine07_Anim
	(sleep_until (or (< (ai_living_count barracks_pack4_01) 1)(volume_test_players barracks_marine05_rescue_trig))5)
	(sleep 15)			
	(ai_activity_abort barracks_marine07)
	(ai_play_line barracks_marine07 020MJ_120) ;52857											
	;this checks to see if the player has made it to the end of the barracks or killed the brutes, if not, then play their 'hostage actions'	
	(if (OR (< var_barracks_pos 5)(> (ai_living_count barracks_cov_all) 0))
		(cs_run_command_script barracks_marine07 barracks_marine07_flee)
		(begin
			(ai_set_blind barracks_marine07 FALSE)
			(ai_set_deaf barracks_marine07 FALSE)	
			(ai_disregard (ai_actors barracks_marine07) FALSE)			
			(unit_add_equipment (ai_get_unit barracks_marine07) barracks_marine03_profile TRUE TRUE)
			(ai_set_objective barracks_marine07 barracks_marine_obj)	
		)
		
	)
	(sleep_until (= (device_get_position barracks_door_end) 1) 1)
	(sleep 60)	
	(ai_migrate barracks_marine07 evac_hangar_marine07)	
)

(script command_script barracks_marine07_flee
;	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_flee)
	(ai_disregard (ai_actors barracks_marine07) FALSE)
	(cs_go_to barracks_third_save/p2)
	(cs_crouch TRUE 60)
	(unit_add_equipment (ai_get_unit barracks_marine07) barracks_marine03_profile TRUE TRUE)
	(ai_set_blind barracks_marine07 FALSE)
	(ai_set_deaf barracks_marine07 FALSE)	
	(ai_set_objective barracks_marine07 barracks_marine_obj)	
				
)
; ===================================================================================================================================================

(script dormant md_07_barracks_exit
	(sleep_until	(and
					(>= var_barracks_pos 4)
					(or
						(> (device_get_position barracks_door_end) 0)
						(<= (ai_living_count barracks_cov_all) 0)
					)
				)
	)
	(if (= (device_get_position barracks_door_end) 0)
		(begin
			(sleep (random_range 120 150))
			(set g_music_020_106 TRUE)	
			(if (not (game_is_cooperative))
				(begin
					(vs_cast arbiter_group FALSE 10 "020MJ_130")
					(set arbiter (vs_role 1))
					(vs_enable_pathfinding_failsafe arbiter TRUE)
					(vs_enable_looking arbiter  TRUE)
					(vs_enable_targeting arbiter TRUE)
					(vs_enable_moving arbiter TRUE)
		
			(vs_set_cleanup_script md_cleanup)
			(ai_dialogue_enable false)												
					(vs_face_player arbiter true)			
					(if dialogue (print "ARBITER: We did all we could."))
					(sleep (ai_play_line arbiter 020MJ_130))
					(sleep 15)
					
					(if dialogue (print "ARBITER: Let us move the survivors up to the hangar."))
					(sleep (ai_play_line arbiter 020MJ_140))
					(sleep 30)
		
					(if dialogue (print "ARBITER: There is a lift outside."))
					(sleep (ai_play_line arbiter 020MJ_150))
					(sleep 15)
					(vs_face_player arbiter false)					
			(ai_dialogue_enable true)															
					(vs_release_all)			
										
				)
				(begin
					(vs_cast barracks_marine06 TRUE 10 "020MJ_160")
					(set 06_sergeant (vs_role 1))
		
					(vs_enable_pathfinding_failsafe 06_sergeant TRUE)
					(vs_enable_looking 06_sergeant  TRUE)
					(vs_enable_targeting 06_sergeant TRUE)
					(vs_enable_moving 06_sergeant TRUE)
				(ai_dialogue_enable false)												
					(vs_face_player 06_sergeant true)		
					(if dialogue (print "SERGEANT: You did the best you could, Sir."))
					(sleep (ai_play_line 06_sergeant 020MJ_160))
					(sleep 15)
					
					(if dialogue (print "SERGEANT: Let's get the survivors up to the hangar."))
					(sleep (ai_play_line 06_sergeant 020MJ_170))
					(sleep 30)
		
					(if dialogue (print "SERGEANT: There's an elevator just outside the barracks."))
					(sleep (ai_play_line 06_sergeant 020MJ_180))
					(sleep 15)
					(vs_face_player 06_sergeant false)		
					
				(ai_dialogue_enable true)												
				
					(vs_release_all)
				)
						
			)
		)
	)
)

; ===================================================================================================================================================

(script dormant md_07_barracks_marines
	(if debug (print "mission dialogue:07:barracks:marines"))

		; cast the actors
	(vs_cast evac_hangar_marines TRUE 10 "020MJ_190" "020MJ_200")
		(set 08_marine_A (vs_role 1))
		(set 08_marine_B (vs_role 2))

	; movement properties
	(vs_enable_pathfinding_failsafe evac_hangar_marines TRUE)
	(vs_enable_looking evac_hangar_marines  TRUE)
	(vs_enable_targeting evac_hangar_marines TRUE)
	(vs_enable_moving evac_hangar_marines TRUE)

    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable false)												

	(if dialogue (print "MARINE 01: Chief and the Arbiter make a pretty good team."))
	(vs_play_line 08_marine_A TRUE 020MJ_190)
	(sleep 10)

	(if dialogue (print "MARINE 02: He's still an Elite. One of them."))
	(vs_play_line 08_marine_B TRUE 020MJ_200)
	(sleep 10)

	(if dialogue (print "MARINE 01: Well, he saved our asses. That's gotta count for something…"))
	(vs_play_line 08_marine_A TRUE 020MJ_210)
	(sleep 10)
	(ai_dialogue_enable true)												

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_08_evac_pelican_01

	(if debug (print "mission dialogue:08:evac:pelican:02"))
	(ai_dialogue_enable false)												
		(if dialogue (print "HOCUS (radio): Ma'am. I've got movement. Above and below…"))
		(sleep (ai_play_line_on_object NONE 020MK_010))
		(sleep 10)

		(if dialogue (print "HOCUS (radio): Brutes! They've got jump-packs!"))
		(sleep (ai_play_line_on_object NONE 020MK_020))
		(sleep 10)		

		(if dialogue (print "MIRANDA (radio): They're going after the thrusters!"))
		(sleep (ai_play_line_on_object NONE 020MK_030))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Shake them off, Lieutenant!"))
		(sleep (ai_play_line_on_object NONE 020MK_040))
	(ai_dialogue_enable true)												
		
)
; ===================================================================================================================================================

(script dormant md_08_joh_cc_retreat
		(sleep_until (volume_test_players cool_cam_trig08) 5)
		(sleep (* (random_range 1 4) 30))
	(ai_dialogue_enable false)														
		(if debug (print "mission dialogue:08:evac:pelican:03"))
		(if dialogue (print "JOHNSON (radio): (Static) Commander? We lost the (ops-center)."))
		(sleep (ai_play_line_on_object NONE 020MK_050))
		(sleep 10)

		(if dialogue (print "JOHNSON (radio): Brutes (attacked in force). Couldn't hold them off."))
		(sleep (ai_play_line_on_object NONE 020MK_060))
		(sleep 10)

		(if dialogue (print "JOHNSON (radio): We're falling back to the hangar, but don't (wait for us)!"))
		(sleep (ai_play_line_on_object NONE 020MK_070))
		(sleep 10)
	
;		(if dialogue (print "MIRANDA (radio): Sergeant Major? Johnson?!"))
;		(sleep (ai_play_line_on_object NONE 020MK_080))
;		(sleep 10)

		(if dialogue (print "HOCUS (radio): What should I do, ma'am?"))
		(sleep (ai_play_line_on_object NONE 020MK_090))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Hold position! I'm not leaving without him!"))
		(sleep (ai_play_line_on_object NONE 020MK_100))
	(ai_dialogue_enable true)												
		
)
; ===================================================================================================================================================

(script dormant md_08_joh_evac_arrives
	(vs_cast evac_hangar_johnson TRUE 10 "")
		(set johnson (vs_role 1))
		(vs_enable_pathfinding_failsafe evac_hangar_johnson TRUE)
		(vs_enable_looking evac_hangar_johnson  TRUE)
		(vs_enable_targeting evac_hangar_johnson TRUE)
		(vs_enable_moving evac_hangar_johnson TRUE)
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable false)												

		(if dialogue (print "JOHNSON : Drones! Go! I'll cover you!"))
		(vs_play_line johnson TRUE 020MK_110)
		(sleep 10)
		
		(sleep_until (< (ai_living_count evac_hangar_cov_buggers) 1)30 900)
		(cs_run_command_script evac_safe_marines evac_pelican_load)		
		
		(vs_go_to_nearest johnson TRUE evac_johnson)
		(vs_face_object johnson TRUE (ai_get_object evac_hangar_hum_pelican02))

		(if dialogue (print "JOHNSON : Brutes. In the ops-center. They disarmed the bomb."))
		(sleep (ai_play_line johnson 020MK_130))
		(sleep 15)

		(if dialogue (print "JOHNSON : I'm sorry, commander. There were too many. Even for me."))
		(sleep (ai_play_line johnson 020MK_140))					
	(ai_dialogue_enable true)
												
		(wake md_08_evac_pelican_exit); briefing
	
		(sleep_until (< (ai_living_count evac_safe_marines) 1)30 600)
		(sleep 60)
		(vs_release johnson)
		(cs_run_command_script evac_hangar_johnson evac_pelican_load_johnson)
)

; ===================================================================================================================================================
(global boolean self_destruct_objective FALSE)
(script dormant md_08_evac_pelican_exit ;54295
		(sleep_until (= cortana_talking false)5)
	(ai_dialogue_enable false)														
		(if dialogue (print "MIRANDA (radio): Agreed. Chief? Go back to the ops-center…"))
		(sleep (ai_play_line evac_hangar_hum_pelican02/pilot 020BC_010)) ;52863
		(sleep 10)
	(ai_dialogue_enable true)												

		(sleep_until (= cortana_talking false)5)
	(ai_dialogue_enable false)																	
		(if dialogue (print "MIRANDA (radio): Kill those Brutes. Re-arm the bomb."))
		(sleep (ai_play_line evac_hangar_hum_pelican02/pilot 020BC_020)) ;52863
		(sleep 10)
		(wake obj_self_destruct_set)
		(sleep_forever obj_self_destruct_set_ins)
	(ai_dialogue_enable true)												
						
		(sleep_until (= cortana_talking false)5)
	(ai_dialogue_enable false)																	
		(if dialogue (print "MIRANDA (radio): I've got to get these men out of here…"))
		(sleep (ai_play_line evac_hangar_hum_pelican02/pilot 020BC_030)) ;52863
		(sleep 10)
	(ai_dialogue_enable true)												
		
		(sleep_until (= cortana_talking false)5)
	(ai_dialogue_enable false)																		
		(if dialogue (print "MIRANDA (radio): But I'll radio with another exit."))
		(sleep (ai_play_line evac_hangar_hum_pelican02/pilot 020BC_040))
		(sleep 10)
	(ai_dialogue_enable true)												
		
)
; ===================================================================================================================================================

(script command_script evac_pelican_load
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location evac_hangar_hum_pelican02/pilot))
	(sleep_until
		(begin
			(sleep 300)
			(cs_go_to_vehicle (ai_vehicle_get_from_starting_location evac_hangar_hum_pelican02/pilot))
			(vehicle_test_seat evac_hangar_hum_pelican02 "" ai_current_actor)
		)
	)
)

(script command_script evac_pelican_load_arbiter
	(ai_vehicle_reserve_seat evac_hangar_hum_pelican02 "pelican_p_l01" FALSE)	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location evac_hangar_hum_pelican02/pilot))
	(ai_vehicle_enter evac_arbiter evac_hangar_hum_pelican02/pilot "pelican_p_l01")		
	(sleep_until
		(begin
			(sleep 90)
			(cs_go_to_vehicle (ai_vehicle_get_from_starting_location evac_hangar_hum_pelican02/pilot))
			(ai_vehicle_enter evac_arbiter evac_hangar_hum_pelican02/pilot "pelican_p_l01")				
			(vehicle_test_seat evac_hangar_hum_pelican02 "" ai_current_actor)
		)
	5 300)

	(cs_enable_moving FALSE)
)

(script command_script evac_pelican_load_johnson
	(ai_vehicle_reserve_seat evac_hangar_hum_pelican02 "pelican_e" FALSE)	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location evac_hangar_hum_pelican02/pilot))
	(ai_vehicle_enter evac_hangar_johnson evac_hangar_hum_pelican02/pilot "pelican_e")		
	(sleep_until
		(begin
			(sleep 90)
			(cs_go_to_vehicle (ai_vehicle_get_from_starting_location evac_hangar_hum_pelican02/pilot))
			(ai_vehicle_enter evac_hangar_johnson evac_hangar_hum_pelican02/pilot "pelican_e")				
			(vehicle_test_seat evac_hangar_hum_pelican02 "" ai_current_actor)
		)
	)
	(cs_enable_moving FALSE)
)

; ================================================================================================================================================

(script dormant md_08_joh_reminder
	(wake md_08_joh_reminder_a)
	(wake md_08_joh_reminder_b)
	(wake md_08_joh_reminder_c)
)

(script dormant md_08_joh_reminder_a
	(sleep 1800)
	(sleep_until (= cortana_talking false)5)		
	(ai_dialogue_enable false)												
	(if dialogue (print "JOHNSON (radio): Fastest way to the ops-center is they way I came in, Chief…"))
	(sleep (ai_play_line_on_object NONE 020MK_200))
	(sleep 10)
	(sleep_until (= cortana_talking false)5)	
	(if dialogue (print "JOHNSON (radio): Downstairs, through the service tunnel."))
	(sleep (ai_play_line_on_object NONE 020MK_210))
	(sleep 10)
	(ai_dialogue_enable true)												
	
)
(script dormant md_08_joh_reminder_b
	(sleep_until (volume_test_players cortana_highway_enc_trig)5)
	(sleep_forever md_08_joh_reminder_a)
	(ai_dialogue_enable true)															
	(sleep 1800)
	(sleep_until (= cortana_talking false)5)			
	(ai_dialogue_enable false)														
	(if dialogue (print "JOHNSON (radio): Chief, follow the service tunnel to the motor-pool!"))
	(sleep (ai_play_line_on_object NONE 020MK_220))
	(ai_dialogue_enable true)														
	(sleep 10)
	(sleep 1800)
	(sleep_until (= cortana_talking false)5)			
	(ai_dialogue_enable false)														
	(if dialogue (print "JOHNSON (radio): Follow the tunnel to the motor-pool, Chief!"))
	(sleep (ai_play_line_on_object NONE 020ML_010))
	(sleep 10)	
	(ai_dialogue_enable true)													
)
(script dormant md_08_joh_reminder_c
	(sleep_until (volume_test_players cortana_highway_var_trig03)5)
	(sleep_forever md_08_joh_reminder_b)
	(ai_dialogue_enable true)													
	(sleep 1800)
	(sleep_until (players_not_in_combat))
	(sleep_until (= cortana_talking false)5)				
	(ai_dialogue_enable false)															
	(if dialogue (print "JOHNSON (radio): Head through the motor-pool to get to the ops-center!"))
	(sleep (ai_play_line_on_object NONE 020MK_230))
	(set g_music_020_115 FALSE)
	(sleep 10)
	(ai_dialogue_enable true)
	(sleep 1800)
	(sleep_until (players_not_in_combat))
	(sleep_until (= cortana_talking false)5)				
	(ai_dialogue_enable false)														
	(if dialogue (print "JOHNSON (radio): Get back to the ops-center, arm that bomb!"))
	(sleep (ai_play_line_on_object NONE 020ML_020))
	(sleep 10)
	(ai_dialogue_enable true)
	(sleep 1800)
	(sleep_until (players_not_in_combat))
	(sleep_until (= cortana_talking false)5)				
	(ai_dialogue_enable false)												
	(if dialogue (print "JOHNSON (radio): Ops-center, Chief! Hurry!"))
	(sleep (ai_play_line_on_object NONE 020MM_010))
	(sleep 10)
	(ai_dialogue_enable true)												
	(sleep 1800)
	(sleep_until (players_not_in_combat))	
	(sleep_until (= cortana_talking false)5)
	(ai_dialogue_enable false)															
	(if dialogue (print "JOHNSON (radio): Blow this base to kingdom come!"))
	(sleep (ai_play_line_on_object NONE 020MM_020))
	(ai_dialogue_enable true)												
)

; ================================================================================================================================================
; CUT
(script dormant md_09_motorpool_brute_pa
	(sleep_until (> (device_get_position cortana_encounter_door) 0))	
	(sleep (random_range 600 1200))
	(sleep_until (players_not_in_combat))
	(ai_dialogue_enable false)
	(ai_play_line_on_point_set 020ML_030 miranda_PA_pts_02 3)
	(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020ML_030_bch))
;	(sleep (ai_play_line big_bad_brute 020ML_030))
	(sleep 10)
	(ai_play_line_on_point_set 020ML_040 miranda_PA_pts_02 3)
	(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020ML_040_bch))
;	(sleep (ai_play_line big_bad_brute 020ML_040))
	(sleep 10)
	(ai_play_line_on_point_set 020ML_050 miranda_PA_pts_02 3)
	(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020ML_050_bch))
;	(sleep (ai_play_line big_bad_brute 020ML_050))
	(sleep 10)
	(ai_play_line_on_point_set 020ML_060 miranda_PA_pts_02 3)
	(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020ML_060_bch))
;	(sleep (ai_play_line big_bad_brute 020ML_060))
	(ai_dialogue_enable true)						
	(sleep_until (= (volume_test_players self_destruct_start_trig) TRUE) 15 (random_range 600 1800)) 
	(if (= (volume_test_players self_destruct_start_trig) FALSE)
		(begin
			(ai_dialogue_enable false)								
			(ai_play_line_on_point_set 020MM_030 miranda_PA_pts_02 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MM_030_bch))
;			(sleep (ai_play_line big_bad_brute 020MM_030))
			(sleep 10)
			(ai_dialogue_enable true)									
		)
	)
	(if (= (volume_test_players self_destruct_start_trig) FALSE)
		(begin
		(ai_dialogue_enable false)								
			(ai_play_line_on_point_set 020MM_040 miranda_PA_pts_02 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MM_040_bch))
;			(sleep (ai_play_line big_bad_brute 020MM_040))
			(sleep 10)
		(ai_dialogue_enable true)									
		)
	)
	(if (= (volume_test_players self_destruct_start_trig) FALSE)
		(begin
		(ai_dialogue_enable false)								
			(ai_play_line_on_point_set 020MM_050 miranda_PA_pts_02 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MM_050_bch))
;			(sleep (ai_play_line big_bad_brute 020MM_050))
			(sleep 10)
		(ai_dialogue_enable true)									
		)
	)
	(if (= (volume_test_players self_destruct_start_trig) FALSE)
		(begin
		(ai_dialogue_enable false)								
			(ai_play_line_on_point_set 020MM_060 miranda_PA_pts_02 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MM_060_bch))
;			(sleep (ai_play_line big_bad_brute 020MM_060))
		(ai_dialogue_enable true)						
		)
	)												
		
)

(script dormant md_10_self_destruct_joh
	(sleep_until (< (ai_living_count self_destruct_all) 1))
	(sleep 300)
	(ai_dialogue_enable false)												
	(sleep_until (= cortana_talking false)5)															
	(if dialogue (print "JOHNSON (radio): Hit the switch, Chief! Arm that bomb!"))
	(sleep (ai_play_line_on_object NONE 020MN_010))
	(sleep 10)
	(ai_dialogue_enable true)												

	(sleep 900)
	(sleep_until (= cortana_talking false)5)																
	(ai_dialogue_enable false)												
	(if dialogue (print "JOHNSON (radio): The switch is on the bomb, Chief. Find it!"))
	(sleep (ai_play_line_on_object NONE 020MN_020))
	(sleep 10)
	(ai_dialogue_enable true)												
	
)

; ===================================================================================================================================================

(script dormant md_11_cave_hangar_joh
	(if debug (print "mission dialogue:11:cave:hangar:joh"))
	
	(wake md_11_cave_hangar_joh02)
	(wake md_11_cave_hangar_joh03)

	(sleep_until (volume_test_players blow_up_safe_zone)5)
	(sleep_forever md_11_cave_hangar_joh02)
	(sleep_forever md_11_cave_hangar_joh03)
	(ai_dialogue_enable true)														
)

(script dormant md_11_cave_hangar_joh02

	(sleep_until (volume_test_players command_exit_trig)1)
	
	(sleep 900)
	(sleep_until (= cortana_talking false)5)																
	(ai_dialogue_enable false)													
	(if dialogue (print "JOHNSON (radio): South hangar! It's straight through the cave, Chief!"))
	(sleep (ai_play_line_on_object NONE 020MO_020))
	(ai_dialogue_enable true)												
	
)

(script dormant md_11_cave_hangar_joh03
	(sleep_until (volume_test_players hangar_a_entrance_trig)1)
	
	(sleep 900)
	(sleep_until (= cortana_talking false)5)																
	(ai_dialogue_enable false)												
	(if dialogue (print "JOHNSON (radio): There isn't much time, Chief! Find that elevator!"))
	(sleep (ai_play_line_on_object NONE 020MO_030))
	(ai_dialogue_enable true)												
	
	(sleep 1200)
	(sleep_until (= cortana_talking false)5)																
	(ai_dialogue_enable false)												
	(if dialogue (print "JOHNSON (radio): The bomb's about to blow! Go, go, go!"))
	(sleep (ai_play_line_on_object NONE 020MO_040))
	(ai_dialogue_enable true)												
	
	(sleep 1200)
	(sleep_until (= cortana_talking false)5)																
	(ai_dialogue_enable false)												
	(if dialogue (print "JOHNSON (radio): Get on the elevator, Chief! You’re out of time!"))
	(sleep (ai_play_line_on_object NONE 020MO_050))
	(ai_dialogue_enable true)												
	
)
					
; ===================================================================================================================================================

(script dormant am_00_base
;================= AMBIENT BASE PREPARING FOR ATTACK

		(if dialogue (print "MIRANDA (PA system): Alert: Ops-center is closed to all non-essential personnel!"))
		(sleep (ai_play_line_on_object NONE 020MZ_010))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Alpha-six, reinforce blue sector!"))
		(sleep (ai_play_line_on_object NONE 020MZ_020))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Charlie-two, report to green sector!"))
		(sleep (ai_play_line_on_object NONE 020MZ_030))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Confirm: all combat teams in position, over?"))
		(sleep (ai_play_line_on_object NONE 020MZ_040))
		(sleep 10)
	; miranda in base
		(if dialogue (print "MIRANDA (PA system): Report any change in sector status to the ops-center!"))
		(sleep (ai_play_line_on_object NONE 020MZ_050))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Charlie-two, any movement in your sector?"))
		(sleep (ai_play_line_on_object NONE 020MZ_060))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Only verified contacts, alpha-six. Keep the channel clear!"))
		(sleep (ai_play_line_on_object NONE 020MZ_070))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): All units: alpha through echo, prepare for enemy contacts!"))
		(sleep (ai_play_line_on_object NONE 020MZ_080))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Combat teams lima through sierra, look sharp!"))
		(sleep (ai_play_line_on_object NONE 020MZ_090))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Medical teams: prepare wounded for transport. South hangar!"))
		(sleep (ai_play_line_on_object NONE 020MZ_100))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): All non-combat personnel: report to south hangar for immediate evac!"))
		(sleep (ai_play_line_on_object NONE 020MZ_110))
		(sleep 10)
;================= AMBIENT BASE UNDER ATTACK
		(if dialogue (print "MIRANDA (PA system): Alert! Covenant have breached the base!"))
		(sleep (ai_play_line_on_object NONE 020MZ_120))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Confirmed: Phantoms approaching the south hangar!"))
		(sleep (ai_play_line_on_object NONE 020MZ_130))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Attention: hostiles reported outside the barracks!"))
		(sleep (ai_play_line_on_object NONE 020MZ_140))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Combat teams: hold positions, await further orders!"))
		(sleep (ai_play_line_on_object NONE 020MZ_150))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Combat teams: report all contact to the Ops-Center!"))
		(sleep (ai_play_line_on_object NONE 020MZ_160))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Maintain your zones. Drive them toward the exits!"))
		(sleep (ai_play_line_on_object NONE 020MZ_170))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Confirmed: hostile contacts in south hangar!"))
		(sleep (ai_play_line_on_object NONE 020MZ_180))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Can anyone confirm hostile contacts in north hangar, over?"))
		(sleep (ai_play_line_on_object NONE 020MZ_190))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): North hangar has been cleared! Proceed with evac!"))
		(sleep (ai_play_line_on_object NONE 020MZ_200))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): All available combat teams! Get to the barracks!"))
		(sleep (ai_play_line_on_object NONE 020MZ_210))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Barracks are under attack! All available combat teams respond!"))
		(sleep (ai_play_line_on_object NONE 020MZ_220))
		(sleep 10)

		(if dialogue (print "MIRANDA (PA system): Anyone in the barracks, I need a sitrep! Now!"))
		(sleep (ai_play_line_on_object NONE 020MZ_230))
		(sleep 10)
;================= AMBIENT BASE LOST

		(if dialogue (print "JOHNSON (PA system): All personnel: the base is overrun!"))
		(sleep (ai_play_line_on_object NONE 020MZ_240))
		(sleep 10)

		(if dialogue (print "JOHNSON (PA system): Everyone still in the base, get to the north hangar! Now!"))
		(sleep (ai_play_line_on_object NONE 020MZ_250))
		(sleep 10)

		(if dialogue (print "JOHNSON (PA system): Fire team alpha-six: we are leaving! Fall back!"))
		(sleep (ai_play_line_on_object NONE 020MZ_260))
		(sleep 10)

		(if dialogue (print "JOHNSON (PA system): Negative, charlie-two! Prepare for evac! That's an order!."))
		(sleep (ai_play_line_on_object NONE 020MZ_270))
		(sleep 10)

		(if dialogue (print "JOHNSON (PA system): All Pelicans: go to ground. There's no one left, over!"))
		(sleep (ai_play_line_on_object NONE 020MZ_280))
		(sleep 10)

		(if dialogue (print "JOHNSON (PA system): All UNSC assets in grind one-one-four: forest fire. I repeat: forest fire!"))
		(sleep (ai_play_line_on_object NONE 020MZ_290))
		(sleep 10)

		(if dialogue (print "JOHNSON (PA system): Everyone get to minimum safe distance! Now!"))
		(sleep (ai_play_line_on_object NONE 020MZ_300))
		(sleep 10)

		(if dialogue (print "JOHNSON (PA system): Alert: final countdown has begun! I say again: final countdown has begun!"))
		(sleep (ai_play_line_on_object NONE 020MZ_310))
		(sleep 10)
)


; ===================================================================================================================================================
; ===================================================================================================================================================
; VIGNETTES 
; ===================================================================================================================================================
; ===================================================================================================================================================


(global boolean bugger_attack FALSE)
(global boolean marine_grabbed FALSE)

(script dormant 020VB_BUGGER_V_MARINE
	(if debug (print "vt:03:bugger:attack"))
	(vs_cast bugger_intro_hum01/actor02 TRUE 10 "020VB_010" )
		(set 03_marine_A (vs_role 1))
	(vs_set_cleanup_script Bugger_Vignette_Abort)
	(vs_face_player 03_marine_A TRUE)
;	(vs_stow 03_marine_A)
	(sleep_until (volume_test_players loop01_return_bugger_trig)1)
	(sleep_forever 020_05_PA_talking)		
	
	(if dialogue (print "MARINE 01: Sir! This way --"))
	(vs_play_line 03_marine_A FALSE 020VB_010)
	(vs_custom_animation 03_marine_A FALSE objects\characters\marine\marine "combat:rifle:wave" TRUE bugger_intro_vignette/p2)
	(object_create_anew pipeburst01)	
	(object_damage_damage_section bugger_vent "all" 1)
	(ai_place bugger_squad00)
	(vs_cast bugger_squad00/01 TRUE 10 "")
		(set bugger (vs_role 1))
	(ai_disregard (ai_actors bugger_squad00) TRUE)	
	(ai_disregard (ai_actors bugger_intro_hum01) TRUE)

	(vs_enable_pathfinding_failsafe bugger TRUE)
	(vs_go_to bugger TRUE bugger_intro_vignette/p2)
	(set bugger_attack TRUE)
	(object_destroy pipeburst01)

;	(vs_custom_animation bugger TRUE objects\characters\bugger\cinematics\vignettes\0x0vc_bugger_pickup_marine\0x0vc_bugger_pickup_marine "bug_pounce_intro" TRUE bugger_intro_vignette/p2)
	
	(if dialogue (print "MARINE 01: No! Help!"))
	(vs_play_line 03_marine_A FALSE 020VB_030)

	(vs_custom_animation 03_marine_A FALSE objects\characters\marine\cinematics\vignettes\0x0vc_bugger_pickup_marine\0x0vc_bugger_pickup_marine "picked_up_by_bug" false  bugger_intro_vignette/p2)	
	
	(vs_custom_animation bugger TRUE objects\characters\bugger\cinematics\vignettes\0x0vc_bugger_pickup_marine\0x0vc_bugger_pickup_marine "bug_pounce_lift" false  bugger_intro_vignette/p2)
	(if dialogue (print "MARINE 01: (bloodcurdling scream)"))
	(vs_play_line 03_marine_A FALSE 020VB_040)
	(vs_custom_animation 03_marine_A FALSE objects\characters\marine\cinematics\vignettes\0x0vc_bugger_pickup_marine\0x0vc_bugger_pickup_marine "held_by_bug" false  bugger_intro_vignette/p2)	
	(vs_custom_animation bugger TRUE objects\characters\bugger\cinematics\vignettes\0x0vc_bugger_pickup_marine\0x0vc_bugger_pickup_marine "hold_marine" false  bugger_intro_vignette/p2)
	(set marine_grabbed true)
	(ai_disregard (ai_actors bugger_squad00) FALSE)	
	(ai_disregard (ai_actors bugger_intro_hum01) FALSE)		
	(ai_magically_see bugger_intro_hum01 bugger_squad00)
	(vs_release 03_marine_A)
 	(ai_kill 03_marine_A)
	(sleep 1)
	(vs_release_all)	
	
)

(script static void Bugger_Vignette_Abort
	(print "VIGNETTE ABORTED")
	(set bugger_attack TRUE)
	(if (> (ai_living_count bugger_squad00) 0)
		(begin
			(object_damage_damage_section bugger_vent "all" 1)
			(ai_place bugger_squad00)
		)
	)
	(ai_disregard (ai_actors bugger_squad00) FALSE)	
	(ai_disregard (ai_actors bugger_intro_hum01) FALSE)	
	(ai_magically_see bugger_intro_hum01 bugger_squad00)
	(if marine_grabbed (unit_kill bugger_intro_hum01/actor02))
)

(script command_script 020_03_bugger_in_the_vents
	(cs_draw)
	(cs_abort_on_damage TRUE)	
	(cs_aim TRUE bugger_intro_vignette/p3)
	(sleep_until bugger_attack)
)

(script command_script 020_03_bugger_in_the_vents02
	(cs_draw)
	(cs_abort_on_damage TRUE)
	(cs_aim TRUE bugger_intro_vignette/p5)
	(sleep_until bugger_attack)
)
(script command_script 020_03_bugger_in_the_vents03
	(cs_draw)
	(cs_abort_on_damage TRUE)
	(sleep_until
		(begin
			(cs_aim TRUE loop01_return_points_bugger/p13)
			(sleep (random_range 90 180))
			(cs_aim TRUE loop01_return_points_bugger/p11)
			(sleep (random_range 120 300))			
		FALSE)
	1)
	(ai_set_objective loop01_return_hw01/03 loop01_return_highway)
)
(script command_script 020_03_bugger_in_the_vents04
	(cs_draw)
	(cs_abort_on_damage TRUE)
	(sleep_until
		(begin
			(cs_aim TRUE loop01_return_points_bugger/p13)
			(sleep (random_range 90 180))
			(cs_aim TRUE loop01_return_points_bugger/p12)
			(sleep (random_range 120 300))			
		FALSE)
	1)
	(ai_set_objective loop01_return_hw01/04 loop01_return_highway)
	
)

; ===================================================================================================================================================

(script static void monitors_standby
	(object_set_function_variable cc_monitor01 "screen_control" .2 0)
	(object_set_function_variable cc_monitor02 "screen_control" .2 0)
	(object_set_function_variable cc_monitor03 "screen_control" .2 0)
	(object_set_function_variable cc_monitor04 "screen_control" .2 0)
	(object_set_function_variable cc_monitor05 "screen_control" .2 0)
	(object_set_function_variable cc_monitor06 "screen_control" .2 0)
	(object_set_function_variable cc_monitor07 "screen_control" .2 0)
	(object_set_function_variable cc_monitor08 "screen_control" .2 0)
	(object_set_function_variable cc_monitor09 "screen_control" .2 0)
	(object_set_function_variable cc_monitor10 "screen_control" .2 0)
	(object_set_function_variable cc_monitor11 "screen_control" .2 0)
	(object_set_function_variable cc_monitor12 "screen_control" .2 0)
	(object_set_function_variable cc_monitor_new12 "screen_control" .2 0)
	(object_set_function_variable cc_monitor_new14 "screen_control" .2 0)
	(object_set_function_variable cc_monitor_mir_01 "screen_control" .2 0)
	(object_set_function_variable cc_monitor_mir_02 "screen_control" .2 0)
	(object_set_function_variable cc_monitor_mir_03 "screen_control" .2 0)
)

(script command_script cc_return_helper
	(cs_abort_on_damage TRUE)
	(cs_enable_targeting TRUE)
;	(cs_force_combat_status 2)
	(cs_draw)
	(cs_crouch TRUE)
	(ai_set_weapon_up ai_current_actor 1)
	(sleep_until (volume_test_players vol_cc_return)1)
	(sleep 1800)
	(sleep_until (volume_test_players vol_cc_return)1)	
	(cs_lower_weapon TRUE)
	(sleep 30)
	(cs_crouch FALSE)
	(cs_approach_player 1 10 10)
	
	(if (< (ai_living_count bugger_intro_cov) 1)
		(begin
			(if dialogue (print "MARINE: Cleaned those bugs out good, sir…"))
			(cs_play_line 020MF_060)
			(sleep 10)
		)
	)

	(if dialogue (print "MARINE: Sergeant Major's waiting for you upstairs!"))
	(cs_play_line 020MF_070)
	(sleep 10)
	
	(cs_go_to cc_crash_pts_01/p0)
	(cs_face_object TRUE loop01_return_crate_bomb)
	(sleep_forever)
)

(script command_script stand_gun_down
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
;	(cs_force_combat_status 2)
;	(cs_draw)
;	(ai_set_weapon_up ai_current_actor 0)
	(sleep_forever)
)
(script command_script stand_gun_up
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
;	(cs_force_combat_status 2)
	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(sleep_forever)
)
(script command_script crouch_gun_down
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
;	(cs_force_combat_status 2)
	(cs_draw)
	(cs_crouch TRUE)
	(ai_set_weapon_up ai_current_actor 0)
	(sleep_forever)
)
(script command_script crouch_gun_up
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
;	(cs_force_combat_status 2)
	(cs_draw)
	(cs_crouch TRUE)
	(ai_set_weapon_up ai_current_actor 1)
	(sleep_forever)
)
(script command_script crouch_gun_up_hack
	(cs_abort_on_damage TRUE)
	(cs_enable_targeting TRUE)
;	(cs_force_combat_status 2)
	(cs_draw)
	(cs_crouch TRUE)
	(ai_set_weapon_up ai_current_actor 1)
	(sleep_forever)
)
(script command_script stand_gun_up_hack
	(cs_abort_on_damage TRUE)
	(cs_enable_targeting TRUE)
;	(cs_force_combat_status 2)
	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(sleep_forever)
)
(script command_script cc2_pat_01
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
;	(cs_force_combat_status 2)
	(cs_draw)
	(cs_walk 1)
;	(ai_set_weapon_up ai_current_actor 1)
	(sleep_until
		(begin
			(cs_go_to command_center_patrols/p19)
			(cs_go_to command_center_patrols/p18)
			(cs_go_to command_center_patrols/p17)
			(cs_go_to command_center_patrols/p16)
			FALSE
		)
	)
)

(script command_script cc_wiper_01
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_stow)
	(begin_random
		(begin
			(if (> (object_get_health cc2_computer01) 0)
				(cs_go_to_and_posture cc_crash_pts_01/cc01 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer01) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer01) 0)
				(begin
					(object_create_anew cc_crashed01)
					(object_destroy cc2_computer01)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer02) 0)
				(cs_go_to_and_posture cc_crash_pts_01/cc02 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer02) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer02) 0)
				(begin
					(object_create_anew cc_crashed02)
					(object_destroy cc2_computer02)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer03) 0)
				(cs_go_to_and_posture cc_crash_pts_01/cc03 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer03) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer03) 0)
				(begin
					(object_create_anew cc_crashed03)
					(object_destroy cc2_computer03)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer04) 0)
				(cs_go_to_and_posture cc_crash_pts_01/cc04 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer04) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer04) 0)
				(begin
					(object_create_anew cc_crashed04)
					(object_destroy cc2_computer04)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer05) 0)
				(cs_go_to_and_posture cc_crash_pts_01/cc05 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer05) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer05) 0)
				(begin
					(object_create_anew cc_crashed05)
					(object_destroy cc2_computer05)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer06) 0)
				(cs_go_to_and_posture cc_crash_pts_01/cc06 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer06) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer06) 0)
				(begin
					(object_create_anew cc_crashed06)
					(object_destroy cc2_computer06)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer15) 0)
				(cs_go_to_and_posture cc_crash_pts_01/cc15 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer15) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer15) 0)
				(begin
					(object_create_anew cc_crashed15)
					(object_destroy cc2_computer15)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer16) 0)
				(cs_go_to_and_posture cc_crash_pts_01/cc16 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer16) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer16) 0)
				(begin
					(object_create_anew cc_crashed16)
					(object_destroy cc2_computer16)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer23) 0)
				(cs_go_to_and_posture cc_crash_pts_01/cc23 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer23) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer23) 0)
				(begin
					(object_create_anew cc_crashed23)
					(object_destroy cc2_computer23)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer24) 0)
				(cs_go_to_and_posture cc_crash_pts_01/cc24 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer24) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer24) 0)
				(begin
					(object_create_anew cc_crashed24)
					(object_destroy cc2_computer24)
				)
			)
			(cs_posture_exit)
		)
	)
	(cs_go_to cc_crash_pts_01/done01)
	(cs_face_object TRUE loop01_return_crate_bomb)
;	(cs_force_combat_status 2)
	(cs_walk 1)
	(cs_draw)
	(sleep_forever)
)
(script command_script cc_wiper_02
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_stow)
	(begin_random
		(begin
			(if (> (object_get_health cc2_computer07) 0)
				(cs_go_to_and_posture cc_crash_pts_02/cc07 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer07) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer07) 0)
				(begin
					(object_create_anew cc_crashed07)
					(object_destroy cc2_computer07)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer08) 0)
				(cs_go_to_and_posture cc_crash_pts_02/cc08 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer08) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer08) 0)
				(begin
					(object_create_anew cc_crashed08)
					(object_destroy cc2_computer08)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer09) 0)
				(cs_go_to_and_posture cc_crash_pts_02/cc09 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer09) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer09) 0)
				(begin
					(object_create_anew cc_crashed09)
					(object_destroy cc2_computer09)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer10) 0)
				(cs_go_to_and_posture cc_crash_pts_02/cc10 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer10) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer10) 0)
				(begin
					(object_create_anew cc_crashed10)
					(object_destroy cc2_computer10)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer17) 0)
				(cs_go_to_and_posture cc_crash_pts_02/cc17 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer17) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer17) 0)
				(begin
					(object_create_anew cc_crashed17)
					(object_destroy cc2_computer17)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer21) 0)
				(cs_go_to_and_posture cc_crash_pts_02/cc21 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer21) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer21) 0)
				(begin
					(object_create_anew cc_crashed21)
					(object_destroy cc2_computer21)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer22) 0)
				(cs_go_to_and_posture cc_crash_pts_02/cc22 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer22) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer22) 0)
				(begin
					(object_create_anew cc_crashed22)
					(object_destroy cc2_computer22)
				)
			)
			(cs_posture_exit)
		)
	)
	(cs_go_to cc_crash_pts_02/done02)
	(cs_face_object TRUE loop01_return_crate_bomb)
;	(cs_force_combat_status 2)
	(cs_walk 1)
	(cs_draw)
	(sleep_forever)
)
(script command_script cc_wiper_03
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_stow)
	(begin_random
		(begin
			(if (> (object_get_health cc2_computer11) 0)
				(cs_go_to_and_posture cc_crash_pts_03/cc11 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer11) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer11) 0)
				(begin
					(object_create_anew cc_crashed11)
					(object_destroy cc2_computer11)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer20) 0)
				(cs_go_to_and_posture cc_crash_pts_03/cc20 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer20) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer20) 0)
				(begin
					(object_create_anew cc_crashed20)
					(object_destroy cc2_computer20)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer12) 0)
				(cs_go_to_and_posture cc_crash_pts_03/cc12 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer12) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer12) 0)
				(begin
					(object_create_anew cc_crashed12)
					(object_destroy cc2_computer12)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer13) 0)
				(cs_go_to_and_posture cc_crash_pts_03/cc13 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer13) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer13) 0)
				(begin
					(object_create_anew cc_crashed13)
					(object_destroy cc2_computer13)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer14) 0)
				(cs_go_to_and_posture cc_crash_pts_03/cc14 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer14) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer14) 0)
				(begin
					(object_create_anew cc_crashed14)
					(object_destroy cc2_computer14)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer18) 0)
				(cs_go_to_and_posture cc_crash_pts_03/cc18 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer18) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer18) 0)
				(begin
					(object_create_anew cc_crashed18)
					(object_destroy cc2_computer18)
				)
			)
			(cs_posture_exit)
		)
		(begin
			(if (> (object_get_health cc2_computer19) 0)
				(cs_go_to_and_posture cc_crash_pts_03/cc19 "act_typing")
			)
			(sleep_until (<= (object_get_health cc2_computer19) 0) 30 (random_range 150 300))
			(if (> (object_get_health cc2_computer19) 0)
				(begin
					(object_create_anew cc_crashed19)
					(object_destroy cc2_computer19)
				)
			)
			(cs_posture_exit)
		)
	)
	(cs_go_to cc_crash_pts_03/done03)
	(cs_face_object TRUE command_center_cin_door)
;	(cs_force_combat_status 2)
	(cs_walk 1)
	(cs_draw)
	(ai_set_weapon_up ai_current_actor 1)
	(sleep_forever)
)
;*
(script command_script cc_medic_01
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(object_create_anew pda_02)
	(objects_attach (ai_get_object Loop02_Begin_Vig07/medic_01) "right_hand" pda_02 "hand")
	(cs_stow)
	(sleep_until
		(begin
			(begin_random
				(begin
					(if (> (ai_living_count loop02_begin_vig07/injured_01) 0)
						(cs_go_to_and_posture cc_med_pts/p1 "act_medic")
					)
					(sleep_until (<= (ai_living_count loop02_begin_vig07/injured_01) 0) 30 (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(if (> (ai_living_count loop02_begin_vig07/injured_02) 0)
						(cs_go_to_and_posture cc_med_pts/p2 "act_medic")
					)
					(sleep_until (<= (ai_living_count loop02_begin_vig07/injured_02) 0) 30 (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(if (> (ai_living_count loop02_begin_vig07/injured_03) 0)
						(cs_go_to_and_posture cc_med_pts/p3 "act_medic")
					)
					(sleep_until (<= (ai_living_count loop02_begin_vig07/injured_03) 0) 30 (random_range 300 600))
					(cs_posture_exit)
				)
				(begin
					(if (> (ai_living_count loop02_begin_vig07/injured_05) 0)
						(cs_go_to_and_posture cc_med_pts/p5 "act_medic")
					)
					(sleep_until (<= (ai_living_count loop02_begin_vig07/injured_05) 0) 30 (random_range 300 600))
					(cs_posture_exit)
				)
			)
			(< 
				(+ 
					(ai_living_count loop02_begin_vig07/injured_01)  
					(ai_living_count loop02_begin_vig07/injured_02)  
					(ai_living_count loop02_begin_vig07/injured_03)  
					(ai_living_count loop02_begin_vig07/injured_05)
				)
			3)  
		)
	)
	(cs_go_to cc_med_pts/done01)
	(cs_face_object TRUE loop01_return_crate_bomb)
	(cs_draw)
	(sleep_forever)
)
*;

(script command_script cc_medic_02
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_stow)
	(cs_go_to_and_posture cc_med_pts/p4 "act_medic")
	(sleep_until (<= (ai_living_count loop02_begin_vig07/injured_04) 0) (random_range 150 300))
	(cs_posture_exit)
	(cs_go_to cc_med_pts/done02)
	(cs_face_object TRUE loop01_return_crate_bomb)
	(cs_draw)
	(sleep_forever)
)

(script dormant 020VC_setup
	(ai_kill_silent bugger_intro_cov)
	(ai_place Loop02_Begin_Vig01)
	(ai_place Loop02_Begin_Vig02)
	(ai_place Loop02_Begin_Vig05)
	(ai_place Loop02_Begin_Vig06)
	(ai_place Loop02_Begin_Vig07)
	(ai_set_targeting_group loop02_begin_hum 7 TRUE)
	(object_create_anew fake_mir_pel_01)
	(sleep 1)
	(device_set_position_immediate command_center_cin_door 0)
	(object_create_anew_containing cc_monitor)
	(object_create_anew_containing big_screeen_tv)
	(sleep 1)
	(object_create gift_cigar)
;	(objects_attach grav_throne "driver_cinematic" (ai_get_object fake_truth/truth) "driver")
	
;	(objects_attach (ai_get_object Loop02_Begin_Vig06/joh) "cigar" gift_cigar "cigar")
	(object_destroy cc_fakebomb)
	(object_destroy cc_toolbox)
	(object_destroy cc_tarpstack)
	(object_destroy cc_pathfinder)
	(object_destroy_containing cc_monitor_destroy)
	(object_destroy_containing cc_computer)
	(object_create_anew_containing cc2_computer)
	(object_create_anew_containing loop01_return_crate)
	(object_create_anew cc_crashed29)
	(object_create_anew cc_med_console)
	(monitors_standby)
	(ai_place fake_miranda_01)
	(ai_force_active fake_miranda_01 TRUE)
	(sleep_until (volume_test_players loop02_begin_sgt_trig) 1)
	(object_create_anew cin_main_screen)
	(object_create_anew big_screen_tv)		
	(object_destroy default_monitor)		
	(texture_camera_on)
	(sleep 1)
	(texture_camera_set_object_marker gift_cam "marker" 40)
;	(texture_camera_near_plane .1)
	

)
(global short gift_var 0)

(script dormant 020VC_Miranda_anim
	(vs_cast fake_miranda_01/mir FALSE 10 "020VC_030")		
		(set miranda (vs_role 1))
	(vs_custom_animation_loop miranda objects\characters\miranda\cinematics\vignettes\020ve_gift_with_purchase\020ve_gift_with_purchase "020VE_Gift_With_Purchase_miranda_var1" TRUE)
	(sleep_until (= gift_var 1)1)
	(vs_custom_animation miranda TRUE objects\characters\miranda\cinematics\vignettes\020ve_gift_with_purchase\020ve_gift_with_purchase "020VE_Gift_With_Purchase_miranda_var5" TRUE)
	(vs_stop_custom_animation miranda)	
	(vs_custom_animation_loop miranda objects\characters\miranda\cinematics\vignettes\020ve_gift_with_purchase\020ve_gift_with_purchase "020VE_Gift_With_Purchase_miranda_var3" TRUE)
	(sleep 1)
	(sleep_until (= gift_var 2)1)
	(vs_custom_animation miranda TRUE objects\characters\miranda\cinematics\vignettes\020ve_gift_with_purchase\020ve_gift_with_purchase "020VE_Gift_With_Purchase_miranda_var4" TRUE)
	(vs_custom_animation_loop miranda objects\characters\miranda\cinematics\vignettes\020ve_gift_with_purchase\020ve_gift_with_purchase "020VE_Gift_With_Purchase_miranda_var1" TRUE)	
	(sleep_forever)
)

(script dormant 020VC_01
	(wake 020VC_Miranda_anim)
	(ai_dialogue_enable false)					

	(vs_cast Loop02_Begin_Vig01 FALSE 10 "020VC_010")
		(set 05_sergeant (vs_role 1))

	(vs_cast Loop02_Begin_Vig06/joh FALSE 10 "")
		(set johnson (vs_role 1))
;(vs_custom_animation_loop Loop02_Begin_Vig06/joh objects\characters\marine\cinematics\vignettes\020ve_gift_with_purchase\020ve_gift_with_purchase "020ve_gift_with_purchase_cigar_idle_var3" TRUE loop01_return_points/p30)

;		(scenery_animation_start_relative_loop gift_cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\020ve_gift_with_purchase\020ve_gift_with_purchase "020ve_gift_with_purchase_cigar_idle_var3" johnson_cigar_anchor)
;		(vs_custom_animation_loop johnson objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "020ve_gift_with_purchase_cigar_idle_var3" TRUE loop01_return_points/p30)		

;*
	(if dialogue (print "SERGEANT : This thing isn't old, Ma'am, it's ancient."))
	(vs_face_object 05_sergeant TRUE big_screen_tv)
	(vs_play_line 05_sergeant TRUE 020VC_010)
	(sleep 10)
*;
	(if (= (game_insertion_point_get) 0)
		(begin
			(if dialogue (print "SERGEANT : If I try and hook up a timer…It might go off all by itself."))
			(vs_play_line 05_sergeant TRUE 020VC_020)
			(sleep 10)
			(vs_face_object 05_sergeant FALSE big_screen_tv)
		
			(if dialogue (print "MIRANDA : Johnson?"))
;			(ai_play_line_on_object default_monitor 020VC_030)
			(sound_impulse_trigger sound\dialog\020_base\vignette\020vc_030_mir big_screen_spkr 1 1)
			(sleep (ai_play_line miranda 020VC_035))		
		
			(if dialogue (print "Johnson : Mmm-hmm?"))
			(vs_play_line johnson TRUE 020VC_040)
			(sleep 10)
			(vs_stop_custom_animation johnson)
		)
		(sleep 15)
	)

	(if dialogue (print "MIRANDA : You might want to put that out."))
;	(ai_play_line_on_object default_monitor 020VC_050)
	(sound_impulse_trigger sound\dialog\020_base\vignette\020vc_050_mir big_screen_spkr 1 1)
	(sleep (ai_play_line miranda 020VC_055))
	(set gift_var 1)
	(scenery_animation_start_relative gift_cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\020ve_gift_with_purchase\020ve_gift_with_purchase "020ve_gift_with_purchase_cigar_putout" johnson_cigar_anchor)
	(vs_custom_animation johnson FALSE objects\characters\marine\cinematics\vignettes\020ve_gift_with_purchase\020ve_gift_with_purchase "020ve_gift_with_purchase_cigar_putout" TRUE loop01_return_points/p30)
	(wake johnson_stop_animating)



	(if dialogue (print "MIRANDA (Monitor): Chief? Have a look…"))
;	(ai_play_line_on_object default_monitor 020VC_060)
	(sound_impulse_trigger sound\dialog\020_base\vignette\020vc_060_mir big_screen_spkr 1 1)
	(sleep (ai_play_line miranda 020VC_065))	
	(sleep 10)
			
	(if dialogue (print "MIRANDA (Monitor): A little going away gift for the Covenant."))
;	(ai_play_line_on_object default_monitor 020VC_080)
	(sound_impulse_trigger sound\dialog\020_base\vignette\020vc_080_mir big_screen_spkr 1 1)
	(sleep (ai_play_line miranda 020VC_085))
	(sleep 10)
			
	(if dialogue (print "MIRANDA (Monitor): We've linked it to smaller charges throughout the base…"))
;	(ai_play_line_on_object default_monitor 020VC_090)
	(sound_impulse_trigger sound\dialog\020_base\vignette\020vc_090_mir big_screen_spkr 1 1)
	(sleep (ai_play_line miranda 020VC_095))
	(sleep 10)
	(set gift_var 2)

	(vs_look_object miranda TRUE gift_look_center)
	(if dialogue (print "MIRANDA (Monitor): Johnson? Soon as the evacuation is complete? Start the timer."))
;	(ai_play_line_on_object default_monitor 020VC_100)
	(sound_impulse_trigger sound\dialog\020_base\vignette\020vc_100_mir big_screen_spkr 1 1)
	(sleep (ai_play_line miranda 020VC_105))
	(sleep 10)
	
	(if dialogue (print "JOHNSON: Understood."))
	(sleep (ai_play_line johnson 020VC_110))
	(sleep 10)

	(if dialogue (print "MIRANDA (Monitor): Good luck everyone. See you on the last Pelican out."))
;	(ai_play_line_on_object default_monitor 020VC_120)
	(sound_impulse_trigger sound\dialog\020_base\vignette\020vc_120_mir big_screen_spkr 1 1)
	(sleep (ai_play_line miranda 020VC_125))
	(sleep 10)
	(vs_look_object miranda FALSE gift_look_center)
	(texture_camera_off)
	(object_destroy cin_main_screen)
	(object_destroy big_screen_tv)		
	(object_create_anew default_monitor)
	(sleep 1)
	(vs_release miranda)
	(ai_erase fake_miranda_01)
	(object_destroy fake_mir_pel_01)
	(vs_enable_pathfinding_failsafe johnson TRUE)					
	(if
		(AND
			(not (game_is_cooperative))
			(= (volume_test_players vol_near_cc_exit) FALSE)
		)
			(begin
				(sleep 30)
				(vs_face_object johnson TRUE (player0))
				(if dialogue (print "JOHNSON: Follow me, Chief."))
				(vs_play_line johnson TRUE 020VC_130)
				(sleep 10)
				(vs_face_object johnson FALSE (player0)) ;50361				
			)
	)
	(if
		(AND
			(game_is_cooperative)
			(= (volume_test_players vol_near_cc_exit) FALSE)
			(not (vs_running_atom_movement johnson))			
			
		)
			(begin
				(sleep 30)
				(vs_face_object johnson TRUE (player0))
				(if dialogue (print "JOHNSON: Chief? Arbiter? Follow me."))
				(vs_play_line johnson TRUE 020VC_140)
				(sleep 10)
				(vs_face_object johnson FALSE (player0)) ;50361
;(vs_custom_animation johnson TRUE objects\characters\marine\cinematics\vignettes\020ve_gift_with_purchase\020ve_gift_with_purchase "020ve_gift_with_purchase_follow" TRUE)	

			)
	)
	(vs_face_object johnson FALSE big_screen_tv)
	(vs_movement_mode johnson 2)
	(vs_go_to johnson TRUE loop01_return_points/p28)
	
	(vs_enable_moving johnson false)
	(sleep_until (not (vs_running_atom_movement johnson))5)				
	(vs_face_player johnson TRUE)
	
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object johnson)) 1.5))
	
	(if dialogue (print "JOHNSON: Brutes have taken the barracks. Marines are trapped inside."))
	(vs_play_line johnson TRUE 020MG_020)
	(sleep 10)

	(if dialogue (print "JOHNSON: Those apes ain't much for mercy, Chief…"))
	(vs_play_line johnson TRUE 020MG_030)
	(sleep 10)
	
	(if dialogue (print "JOHNSON: We both know what they do with prisoners."))
	(vs_play_line johnson TRUE 020MG_040)
	(wake obj_barracks_set)
	(set loop02_navpoint_bool true)
	(sleep 90)

	(if dialogue (print "JOHNSON: Get to the barracks. Save those men."))
	(vs_play_line johnson TRUE 020MG_050)
	(sleep 10)	

	(if dialogue (print "JOHNSON: Then escort them up to the north hangar for immediate evac!"))
	(vs_play_line johnson TRUE 020MG_060)
	
	(ai_dialogue_enable TRUE)
					
	(sleep 900)
	(vs_face_player johnson FALSE)
	(vs_enable_moving johnson true)
	(vs_walk johnson TRUE)	
	(vs_go_to johnson TRUE loop01_return_points/p30)
	(vs_enable_moving johnson FALSE)	

	(sleep_until 
		(AND
			(< (objects_distance_to_object (players) (ai_get_object johnson)) 2)
			(= (vs_running_atom_movement johnson) FALSE)
		)
	)

	(vs_face_player johnson TRUE)	

	(sleep_until (< (objects_distance_to_object (players) (ai_get_object johnson)) 2))
	(if dialogue (print "JOHNSON: I'll guard the bomb, Chief! Get yourself to the barracks!"))
	(vs_play_line johnson TRUE 020MG_070)
	(sleep 900)
	
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object johnson)) 2))

			(if dialogue (print "JOHNSON: Fastest way to the barracks is out this door, through the motor-pool."))
			(vs_play_line johnson TRUE 020ML_080)
			(sleep 10)
	(sleep 900)
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object johnson)) 2))
			(if dialogue (print "JOHNSON: Chief! Go! Or those marines are gonna die!"))
			(vs_play_line johnson TRUE 020ML_090)
			(sleep 10)
)

(script dormant player_allegiance_broken
	(sleep_until (or (ai_allegiance_broken player human)
				(ai_allegiance_broken human player)
				)5)
	(ai_dialogue_enable true)
)					
	

(script dormant johnson_stop_animating
	(sleep_until (not (unit_is_playing_custom_animation johnson))1)
	(vs_stop_custom_animation johnson)
	(vs_face_object johnson TRUE big_screen_tv)		
)


(script dormant 020VC_GIFT_WITH_PURCHASE
	(wake player_allegiance_broken)
	(wake 020VC_setup)

	(sleep_until (volume_test_players loop02_begin_sgt_trig))
	(wake 020VC_01)
						
)
;*
(script static void test_anim_01
	
	(vs_custom_animation_loop miranda objects\characters\marine\cinematics\vignettes\020VE_Gift_With_Purchase\animations "020VE_Gift_Purchase_cigar_idle_var1" FALSE loop01_return_points/p2)
;	(vs_custom_animation 07_marine_B TRUE objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_exec_1_kill" TRUE barracks_vignette/p1)
	(cs_custom_animation objects\characters\marine\cinematics\vignettes\120vb_door_opens\120vb_door_opens "johnson:120_halo_jump" TRUE)

)
*;
; ===================================================================================================================================================

(script dormant 020VE_MARINE_DIES
	(sleep_until (volume_test_players barracks_vignette_start_trig)1)
	(object_create_anew thrown_marine)
	(object_set_velocity thrown_marine -5 0 2)
	(sound_impulse_start "sound\dialog\combat\marine3\02_danger\thrwn.sound"thrown_marine 1)
	(sleep 30)
	(sound_impulse_start "sound\dialog\combat\marine3\02_danger\thrwn.sound"thrown_marine 1)	
	(effect_new_at_ai_point "fx\material_effects\objects\weapons\impact\impact_bullet_medium\soft_organic_flesh.effect" barracks_vignette/p3)
)

(script dormant 020VE_BRUTE_THROW_MARINE
	(if debug (print "vt:07:barracks:01"))
		; cast the actors
		(ai_place barracks_pack1_01)
		(ai_place barracks_marine01)
		(ai_place barracks_marine02)
		(ai_place barracks_marine03)
		(ai_place barracks_marine04)
		(wake Barracks_Marine04_Anim)
			
		(wake 020_07_Disregard_Marines)
			
		(vs_cast barracks_pack1_01/01 TRUE 10 "020VE_010")
			(set 07_brute_A (vs_role 1))
		(vs_cast barracks_pack1_01/02 FALSE 10 "020VE_030")
			(set 07_brute_B (vs_role 1))				
		(vs_cast barracks_marine01 FALSE 10 "020VE_020")
			(set 07_marine_A (vs_role 1))
								
		(vs_set_cleanup_script Barracks_Marine01_Anim)	
		(vs_abort_on_damage TRUE)		
		(vs_stow 07_brute_A)
		(vs_custom_animation_loop 07_marine_A objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "020vb_vict_idle" FALSE barracks_vignette/p0)
		(vs_custom_animation_loop 07_brute_A objects\characters\brute\cinematics\vignettes\010va_brute_intro\010va_brute_intro "020vb_exec_idle" FALSE barracks_vignette/p0)
				
		(vs_look_object 07_brute_B TRUE (ai_get_object 07_brute_A))
		(vs_look_object 07_brute_F TRUE (ai_get_object 07_brute_A))
							
	(sleep_until (volume_test_players barracks_vignette_start_trig)1 )
		(sleep (random_range 90 120))

		(if dialogue (print "BRUTE: (growl)"))
		(ai_play_line 07_brute_B 020VE_010)
		(sleep 10)

			(if (<= (ai_combat_status barracks_pack1_01) 4)
				(begin
					(if dialogue (print "MARINE: No! Please!"))
					(vs_play_line 07_marine_A TRUE 020VE_020)
					(sleep 10)
				)
				(vs_release 07_brute_B)
			)
			(if (<= (ai_combat_status barracks_pack1_01) 4)
				(begin
					(if dialogue (print "BRUTE: Look! It has soiled itself!"))
					(vs_play_line 07_brute_A TRUE 020VE_030)
					(sleep 10)
				)
				(vs_release 07_brute_B)
			)
			(if (<= (ai_combat_status barracks_pack1_01) 4)
				(begin
					(if dialogue (print "BRUTE: These are whelps not warriors!"))
					(vs_play_line 07_brute_B TRUE 020VE_040)
					(sleep 10)		
					(vs_release 07_brute_B)
				)
				(vs_release 07_brute_B)
			)
				
		(if debug (print "kill animation"))
		(vs_custom_animation 07_brute_A FALSE objects\characters\brute\cinematics\vignettes\010va_brute_intro\010va_brute_intro "020vb_exec_kill" TRUE barracks_vignette/p0)		
		(vs_custom_animation_death 07_marine_A TRUE objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "020vb_vict_kill" TRUE barracks_vignette/p0)
		; custom_animate_to_death
;		(ai_kill_silent 07_marine_A)		
;		(vs_release 07_marine_A)
		(vs_abort_on_alert TRUE)					
		(vs_abort_on_damage TRUE)		
				
			(if (<= (ai_combat_status barracks_pack1_01) 4)
				(begin
					(if dialogue (print "BRUTE: Got some on my pelt…"))
					(vs_play_line 07_brute_A FALSE 020VE_050)
				)
				(vs_release 07_brute_B)
			)
			(if (<= (ai_combat_status barracks_pack1_01) 4)
				(begin
					(if dialogue (print "BRUTE: (laughter)"))
					(vs_play_line 07_brute_A FALSE 020VE_060)			
					(sleep 60)
				)
				(vs_release 07_brute_B)
			)

		(ai_activity_abort barracks_pack1_01/01)		
		(ai_activity_abort barracks_pack1_01/02)		
		(ai_activity_abort barracks_pack1_01/03)
			
		(sleep_until (not (unit_is_playing_custom_animation 07_brute_A)) 1)
		(vs_release_all)
		
)

(script command_script cs_brute_look
	(sleep_until (volume_test_players barracks_vignette_start_trig)1)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(sleep 90)
	(cs_walk TRUE)
	(cs_go_to barracks_patrol/p19)
	(cs_look_object TRUE (ai_get_object barracks_pack1_01/01))
	(sleep_forever)
)
(script dormant vt_07_barracks_02

	(if debug (print "vt:07:barracks:02"))
		
		(vs_set_cleanup_script Barracks_Marine02_Anim)
		
		(vs_cast barracks_marine02 FALSE 10 "")
			(set 07_marine_B (vs_role 1))
		(vs_cast barracks_pack1_01/captain TRUE 10 "020VE_010")
			(set 07_brute_C (vs_role 1))
		(vs_abort_on_damage TRUE)
		(vs_stow 07_brute_C)

	(vs_custom_animation_loop 07_brute_C objects\characters\brute\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_exec_1_idle" FALSE barracks_vignette/p1)		
	(vs_custom_animation_loop 07_marine_B objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_exec_1_idle" FALSE barracks_vignette/p1)
		(sleep_until (volume_test_players vt_barracks02_trig) 5)
		(vs_abort_on_damage FALSE)
	
		(vs_custom_animation 07_brute_C FALSE objects\characters\brute\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_exec_1_kill" TRUE barracks_vignette/p1)				
		(vs_custom_animation_death 07_marine_B TRUE objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_exec_1_kill" TRUE barracks_vignette/p1)
;		(vs_release 07_marine_B)
;		(ai_kill_silent 07_marine_B)
		
		(sleep_until (not (unit_is_playing_custom_animation 07_brute_C)) 1)
		(vs_release_all)		
					
)

(script static void barracks_test
	(ai_place barracks_pack1_01/03)
	(ai_place barracks_marine03)
		(wake 020_07_Disregard_Marines)
	(if debug (print "vt:07:barracks:03"))
		; cast the actors
		(vs_cast barracks_pack1_01/03 TRUE 10 "")
			(set 07_brute_D (vs_role 1))
			
		(vs_set_cleanup_script Barracks_Marine03_Anim)			
			
		(vs_cast barracks_marine03 TRUE 10 "")
			(set 07_marine_C (vs_role 1))

		(vs_abort_on_damage TRUE)
		(vs_stow 07_brute_D)

	(vs_custom_animation_loop 07_marine_C objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_vict_idle" FALSE barracks_vignette/p2)
	(vs_custom_animation_loop 07_brute_D objects\characters\brute\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_exec_idle" FALSE barracks_vignette/p2)


		
		(vs_custom_animation 07_marine_C FALSE objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_vict_kill" FALSE barracks_vignette/p2)
		(vs_custom_animation 07_brute_D TRUE objects\characters\brute\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_exec_kill" TRUE barracks_vignette/p2)	
		(vs_custom_animation 07_marine_C FALSE objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_vict_dead" FALSE barracks_vignette/p2)
		(vs_custom_animation 07_brute_D TRUE objects\characters\brute\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_exec_dead" TRUE barracks_vignette/p2)		
;		(vs_release 07_marine_C)
;		(sleep 1)
;		(ai_kill_silent 07_marine_C)

;		(sleep_until (> (ai_combat_status barracks_pack1_01)1)1)		
		(sleep_until (not (unit_is_playing_custom_animation 07_brute_D)) 1)
		(vs_release_all)		
)

(script dormant vt_07_barracks_03

	(if debug (print "vt:07:barracks:03"))
		; cast the actors
		(vs_cast barracks_pack1_01/03 TRUE 10 "")
			(set 07_brute_D (vs_role 1))
		(vs_set_cleanup_script Barracks_Marine03_Anim)			
			
		(vs_cast barracks_marine03 FALSE 10 "")
			(set 07_marine_C (vs_role 1))

		(vs_abort_on_damage TRUE)

	(vs_custom_animation_loop 07_marine_C objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_vict_idle" FALSE barracks_vignette/p2)
	(vs_custom_animation_loop 07_brute_D objects\characters\brute\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_exec_idle" FALSE barracks_vignette/p2)

		(sleep_until (volume_test_players vt_barracks02_trig) 5)

		(vs_abort_on_damage FALSE)		
		(vs_custom_animation 07_marine_C FALSE objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_vict_kill" FALSE barracks_vignette/p2)
		(vs_custom_animation 07_brute_D TRUE objects\characters\brute\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_exec_kill" TRUE barracks_vignette/p2)
		(vs_custom_animation 07_brute_D FALSE objects\characters\brute\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_exec_dead" TRUE barracks_vignette/p2)		
		(vs_custom_animation_death 07_marine_C TRUE objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "010va_vict_dead" FALSE barracks_vignette/p2)
;		(vs_release 07_marine_C)
		(ai_kill_silent 07_marine_C)

;		(sleep_until (> (ai_combat_status barracks_pack1_01)1)1)
		(sleep_until (not (unit_is_playing_custom_animation 07_brute_D)) 1)
		(vs_release_all)
	
					
)

(script dormant 020VF_TRUTH_REPRIMAND
	(if debug (print "020VF_TRUTH_REPRIMAND"))
	(if debug (print "vt:07:barracks:03"))
	(vs_set_cleanup_script 020VF_TRUTH_ABORT)		
	(object_create_anew grav_throne)
	(sleep 1)
	(ai_place fake_truth)
	(ai_force_active fake_truth TRUE)
	(objects_attach grav_throne "driver_cinematic" (ai_get_object fake_truth/truth) "driver")
	(sleep 1)
	(object_create_anew cin_main_screen)
	(object_create_anew big_screen_tv)		
	(object_destroy default_monitor)		
	(texture_camera_on)
	(sleep 1)
	(texture_camera_set_object_marker truth_cam "marker" 40)
;	(texture_camera_near_plane .1)

		; cast the actors
		(vs_cast self_destruct_cov03/chieftain TRUE 10 "020VF_010")
			(set 10_brute_A (vs_role 1))
		(vs_cast fake_truth/truth TRUE 10 "020VF_020")
			(set 10_truth (vs_role 1))

	(vs_abort_on_alert TRUE)
	
	(if dialogue (print "CHIEFTAIN: Success, Holy One! We have taken their command center!"))
	(vs_play_line 10_brute_A TRUE 020VF_010)
	(sleep 10)

	(if dialogue (print "TRUTH: Have you discovered how they plan to stop me?"))
	(sound_impulse_trigger sound\dialog\020_base\vignette\020vf_020_pot big_screen_spkr 1 1)
	(vs_play_line 10_truth TRUE 020VF_025)
	(sleep 10)

	(if dialogue (print "CHIEFTAIN: Not… as yet, noble Prophet."))
	(vs_play_line 10_brute_A TRUE 020VF_030)
	(sleep 10)

	(if dialogue (print "TRUTH: Find me what I need to know. Or your place on the path is forfeit."))
	(sound_impulse_trigger sound\dialog\020_base\vignette\020vf_040_pot big_screen_spkr 1 1)
	(vs_play_line 10_truth TRUE 020VF_045)
	(sleep 10)	

	(if dialogue (print "TRUTH: Tell me you understand."))
	(sound_impulse_trigger sound\dialog\020_base\vignette\020vf_050_pot big_screen_spkr 1 1)
	(vs_play_line 10_truth TRUE 020VF_055)
	(sleep 10)		
	
	(if dialogue (print "CHIEFTAIN: Yes, Holy One! It shall be done!"))
	(vs_play_line 10_brute_A TRUE 020VF_060)
	(sleep 30)				

	(texture_camera_off)
	(object_destroy cin_main_screen)
	(object_destroy big_screen_tv)		
	(object_create_anew default_monitor)
;	(if dialogue (print "CHIEFTAIN: (angry growl)"))
;	(vs_play_line 10_brute_A TRUE 020VF_070)
;	(sleep 10)

	(if dialogue (print "CHIEFTAIN: Bring in the drones! Have them scour these machines!"))
	(vs_play_line 10_brute_A TRUE 020VF_080)
	(sleep 10)

	(if dialogue (print "CHIEFTAIN: Find out what these heathens know about the Ark!"))
	(vs_play_line 10_brute_A TRUE 020MX_050)
	(sleep 10)
	(ai_activity_abort self_destruct_cov01)
	(ai_activity_abort self_destruct_cov02)
)
(script static void 020VF_TRUTH_ABORT
	(texture_camera_off)
	(object_destroy cin_main_screen)
	(object_destroy big_screen_tv)		
	(object_create_anew default_monitor)

)
(global boolean rvb_end false)
(global boolean rvb_var false)

(script dormant 020VG_RVB_EASTER_EGG
	(sleep_until (volume_test_players easter_egg_trig01)5)
	(ai_place rvb_marine)
	(vs_cast rvb_marine TRUE 10 "")
		(set rvb_actor (vs_role 1))
	(vs_enable_pathfinding_failsafe rvb_actor TRUE)
	(vs_go_to rvb_actor TRUE highway_a_warthog/p13)
	;(vs_custom_animation rvb_actor TRUE objects\characters\marine\marine "combat:rifle:base_button" TRUE)
	(vs_stop_custom_animation rvb_actor)
;	(vs_go_to_and_face rvb_actor TRUE highway_a_warthog/p12 highway_a_warthog/p14)
	(wake 020VG_RVB_EASTER_DIALOG)
	(vs_custom_animation rvb_actor TRUE objects\characters\marine\cinematics\vignettes\040VA_Password\040VA_Password "040VA_password_enter" TRUE highway_a_warthog/p13)
	(vs_custom_animation_loop rvb_actor objects\characters\marine\cinematics\vignettes\040VA_Password\040VA_Password "040VA_password_loop_var4" TRUE highway_a_warthog/p13)
;	(sleep_until (= rvb_var TRUE)1)
	(sleep_until (= rvb_end TRUE)1)
	(vs_custom_animation_loop rvb_actor objects\characters\marine\cinematics\vignettes\040VA_Password\040VA_Password "040VA_password_loop_var3" TRUE highway_a_warthog/p13)	
;	(vs_custom_animation rvb_actor TRUE objects\characters\marine\cinematics\vignettes\040VA_Password\040VA_Password "040VA_password_exit" TRUE highway_a_warthog/p13)
	(sleep_forever)
)
(script dormant 020VG_RVB_EASTER_DIALOG
	(if (<= (game_difficulty_get_real) normal)
		(begin

			(print "Hey! Open up!")	
			(sleep (ai_play_line rvb_marine/01 020MQ_010))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin
					(ai_play_line_on_point_set 020MQ_020 rvb_dialog 1)
					(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_020_ma3))
					(print "Password?")
				)
			)
			(print "You gotta be kidding me...What password?")
			(sleep (ai_play_line rvb_marine/01 020MQ_030))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin						
					(ai_play_line_on_point_set 020MQ_040 rvb_dialog 3)
					(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_040_ma3))
					(print "The password so we don't open the door for Brutes.")
				)
			)
			(print "Do I sound like a Brute to you?")
			(sleep (ai_play_line rvb_marine/01 020MQ_050))
			(sleep 10)
			
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin			
					(ai_play_line_on_point_set 020MQ_060 rvb_dialog 3)
					(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_060_ma3))
					(print "You could be held prisoner by Brutes.")
				)
			)
			(sleep (ai_play_line rvb_marine/01 020MQ_070))																
			(print "If I was held prisoner by Brutes and knew the password, then the Brutes could just force me to tell you the password and you would open the door for them.")
			(set rvb_var TRUE)
			
			(sleep 60)
			
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin
					(ai_play_line_on_point_set 020MQ_080 rvb_dialog 3)
					(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_080_ma3))
					(print "OK, well now I'm definitely not opening the door.")
				)
			)
			(print "We need ammo!")
			(sleep (ai_play_line rvb_marine/01 020MQ_090))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin			
					(ai_play_line_on_point_set 020MQ_100 rvb_dialog 3)
					(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_100_ma3))
					(print "Well, maybe you should ask your Brute buddies then.")
					(set rvb_end TRUE)
				)
			)
		)
	)
	(if (= (game_difficulty_get_real) heroic)
		(begin
			(print "Hey! Open up!")
			(sleep (ai_play_line rvb_marine/01 020MQ_110))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin						
			(ai_play_line_on_point_set 020MQ_120 rvb_dialog 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_120_ma3))			
			(print "Password?")
				)
			)
			(print "What?")
			(sleep (ai_play_line rvb_marine/01 020MQ_130))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin							
			(ai_play_line_on_point_set 020MQ_140 rvb_dialog 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_140_ma3))			
			(print "Need the password.")
				)
			)
			(print "You gotta be kidding me...What password?")
			(sleep (ai_play_line rvb_marine/01 020MQ_150))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin							
			(ai_play_line_on_point_set 020MQ_160 rvb_dialog 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_160_ma3))			
			(print "The one they gave out at the staff meeting 15 minutes ago.")
				)
			)
			(print "What meeting? I was out here.")
			(sleep (ai_play_line rvb_marine/01 020MQ_170))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin				
			(ai_play_line_on_point_set 020MQ_180 rvb_dialog 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_180_ma3))			
			(print "Not supposed to let anybody in without the password.")
			(set rvb_var TRUE)
				)
			)
			(print "If the staff meeting just ended, no one outside is going to know the freaking password. Now open up. We need ammo and the Chief is out here!")
			(sleep (ai_play_line rvb_marine/01 020MQ_190))
			(sleep 60)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin
			(ai_play_line_on_point_set 020MQ_200 rvb_dialog 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_200_ma3))			
			(print "Does he know the password?")
				)
			)
			(ai_play_line rvb_marine/01 020MQ_210)																	
			(print "He wasn't at the meeting!")
			(set rvb_end TRUE)
						
		)
	)
	(if (= (game_difficulty_get_real) legendary)
		(begin
			(print "Hey! Open up!")
			(sleep (ai_play_line rvb_marine/01 020MQ_220))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin				
			(ai_play_line_on_point_set 020MQ_230 rvb_dialog 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_230_ma3))				
			(print "What's the password?")
				)
			)
			(print "Password? Oh man. I forgot.")
			(sleep (ai_play_line rvb_marine/01 020MQ_240))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin				
			(ai_play_line_on_point_set 020MQ_250 rvb_dialog 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_250_ma3))				
			(print "Forgot... what?")
				)
			)
			(print "I forgot the password.")
			(sleep (ai_play_line rvb_marine/01 020MQ_260))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin				
			(ai_play_line_on_point_set 020MQ_270 rvb_dialog 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_270_ma3))				
			(print "That was almost right. The password begins with I forgot... but ends differently. Try again. ")
				)
			)
			(print "No, I mean I forgot the password")
			(sleep (ai_play_line rvb_marine/01 020MQ_280))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin				
			(ai_play_line_on_point_set 020MQ_290 rvb_dialog 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_290_ma3))				
			(print "If I was held prisoner by Brutes and knew the password, then the Brutes could just force me to tell you the password and you would open the door for them.")					
			(set rvb_var TRUE)			
			(sleep 60)
				)
			)
			(print "I am being serious! I don't know the password.")
			(sleep (ai_play_line rvb_marine/01 020MQ_300))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin				
			(ai_play_line_on_point_set 020MQ_310 rvb_dialog 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_310_ma3))				
			(print "No, no. You changed the first part. That was part was right. Now you got the whole thing wrong.")
				)
			)
			(print "Listen to me. I forgot what the password is and I just need you to open the door.")
			(sleep (ai_play_line rvb_marine/01 020MQ_320))
			(sleep 10)
			(if (= (ai_living_count rvb_marine/01) 1)
				(begin				
			(ai_play_line_on_point_set 020MQ_330 rvb_dialog 3)
			(sleep (sound_impulse_language_time sound\dialog\020_base\mission\020MQ_330_ma3))				
			(print "Come on, man. Now you're just guessing.")
			(set rvb_end TRUE)
				)
			)		
		)
	)			
)
; ===================================================================================================================================================
; ===================================================================================================================================================
; BRIEFINGS
; ===================================================================================================================================================
; ===================================================================================================================================================
(global boolean briefing_play FALSE)

(script dormant bb_miranda
	; this script is for coop players who hang around while Miranda makes this announcement.
	(if (or (volume_test_players g_command_center_trig_a)
			(volume_test_players g_command_center_trig_b)
			(volume_test_players g_command_center_trig_c)
		)
		(begin		
			(sleep (ai_play_line miranda 020BB_010))
			(sleep 10)
			(sleep (ai_play_line miranda 020BB_030))
			(sleep 10)
			(sleep (ai_play_line miranda 020BB_040))
			(sleep 10)
		)
	)
	
)

(script dormant br_bb_hangar_a
	(sleep_until (= (volume_test_players cave_a_hwy_marines01_trig) TRUE) 5)
	(texture_camera_off)
	(object_destroy cin_main_screen)
	(object_destroy big_screen_tv)		
	(object_create_anew default_monitor)	
	(sleep 1)
;	(wake 020BB_briefing)

	(set briefing_play TRUE)
	(ai_dialogue_enable false)												
	(wake bb_miranda)
	(if dialogue (print "MIRANDA: Chief? Good. This channel is secure."))
	(sleep (ai_play_line_on_object NONE 020BB_010))
	(sleep 10)

	(if dialogue (print "MIRANDA: My fire teams are spread thin. We can't hold the base forever."))
	(sleep (ai_play_line_on_object NONE 020BB_030))
	(sleep 10)

	(if dialogue (print "MIRANDA: I need that hangar cleared for evac A-SAP!"))
	(sleep (ai_play_line_on_object NONE 020BB_040))
	(sleep 10)
	(ai_dialogue_enable true)												
						 	
	(set briefing_play FALSE)


)

(script dormant br_10_command_objective

	(set briefing_play TRUE)

	(if debug (print "playing 020BE_ELEVATOR"))
	(ai_dialogue_enable false)												
	
	(if dialogue (print "MIRANDA (radio): That did it, Chief! Bomb's armed!"))
	(sleep (ai_play_line_on_object NONE 020MN_030))
	(ai_dialogue_enable true)
	(set g_music_020_13 TRUE)
													
;	(sleep 150)
 	(sleep_until (= cortana_talking false)5)
	
	(ai_dialogue_enable false)													
	(if dialogue (print "JOHNSON (radio): We got your exit: a service elevator in the hangar!"))
	(sleep (ai_play_line_on_object NONE 020MX_060))
	(sleep 10)
	(ai_dialogue_enable TRUE)										
	
 	(sleep_until (= cortana_talking false)5)
 	(ai_dialogue_enable false)														
	(if dialogue (print "JOHNSON (radio): Head downstairs, cut through the caves!"))
	(sleep (ai_play_line_on_object NONE 020MX_070))	
	(sleep 10)
	(set g_music_020_12 FALSE)	
	(ai_dialogue_enable TRUE)										
	
	(set briefing_play FALSE)

	(wake md_11_cave_hangar_joh)


)

	

; ===================================================================================================================================================
; ===================================================================================================================================================
; CORTANA MOMENT 
; ===================================================================================================================================================
; ===================================================================================================================================================
(global boolean cortana_talking false)
;020CA Cortana transmission
(global boolean static_end FALSE)

(script dormant cortana_moment_a	

;	(sleep_until (volume_test_players highway_a_rumble_trig) 1)
	(sleep_until (volume_test_players cortana_moment_sewer_trig) 1)
	(set cortana_talking true)
	(wake 020cb_called_upon) 
	(set cortana_talking false)

)

(script dormant cortana_moment_b
	(sleep_until (volume_test_players vol_cortana_hall_start) 1)
	
	; stop music 114
	(set g_music_020_114 FALSE)


	
	(wake 10_rumble_event_strong)
	(set cortana_talking true)	
	(wake 020cc_protectors)
	(sleep 164)
	(set cortana_talking false)
	(wake 020_music_115)
)

(script dormant cortana_moment_c
	(sleep_until (volume_test_players cave_a_hwy_marines00_trig) 1)
	(wake 12_rumble_event_strong)
	(set cortana_talking true)	
	(wake 020cd_hardship) 
	(set cortana_talking false)
	(game_save)	
)


(script dormant cortana_moment_e
	(sleep_until (volume_test_players hangar_a_entrance_trig) 1)
	(wake 15_rumble_event_strong)	
	(set cortana_talking true)	
	(wake 020cg_become)
	(set cortana_talking false)
	
)

(script dormant cortana_moment_f
	(sleep_until (> (device_get_position exit_elev_switch02) 0)1)
		(device_set_position exit_elev_top 0)
		(device_set_position exit_elev_front 0)
		
		; turn off music 
		(set g_music_020_13 FALSE)
		(set g_music_020_135 FALSE)
		(set g_music_020_14 FALSE)
		
	(sleep_until (= (device_get_position exit_elev_front) 0)1)
	(exit_door_break)
	(volume_teleport_players_not_inside blow_up_safe_zone exit_navpoint01)
	
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)
	
	(object_create_anew door_flames)
	(player_effect_start 0.60 0.25)

	(sleep 60)
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	
	(sleep 60)
	(set cortana_talking true)	
	(wake 020cf_your_tomb)	
	(set cortana_talking false)
	;(damage_players levels\solo\020_base\fx\base_destruction\base_destruction)
	(sleep 30)
	(device_set_position elevator_exit 1)

;	(wake explosion_death)
	(sleep 145)
	(sound_impulse_start "sound\levels\020_base\sound_scenery\base_blowed_up.sound" NONE 1)	
	(sound_class_set_gain device_door 0 240)
	(sleep 95)
	
	(effect_new levels\solo\020_base\fx\bombing\bombing_end.effect exit_navpoint01)			
	(player_effect_stop 0.25)					

	(object_create_anew shaft_explosion_side)
	(object_create_anew shaft_explosion_down)
	
	
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)
	(player_effect_start 0.75 0)
	

	(sleep 60)
	(fade_out 0 0 0 5)
	
	(player_effect_stop 5)	
	(sleep 180)
	(sound_class_set_gain ambient 0 60)
	(sleep 60)
	
	(set cortana_talking true)	
	(sound_impulse_start sound\dialog\020_base\cortana\020cx_045_cor NONE 1)
		(sleep (sound_impulse_language_time sound\dialog\020_base\cortana\020cx_045_cor))
	
	(player_effect_stop 0.5)	
	
	(sleep_forever rumble_event_strong_loop)
	(sleep_forever rumble_cave_a)
	(sleep_forever rumble_command_center)
	(sleep_forever rumble_hangar_a)
	(sleep_forever rumble_hallway_a)
	(sleep_forever rumble_hallway_b)
	(sleep_forever rumble_highway_a)
	;(sound_class_set_gain ambient 1 15)
	(sleep 30)
	(sound_class_set_gain "" 0 90) ;55197 
	(sleep 150)
	(cinematic_snap_to_black)
	(game_award_level_complete_achievements)
	(sleep 5)		;for harold 
	(end_mission)	
)

(script static void exit_door_break
	(device_set_position exit_elev_front 0)
	(device_set_position exit_elev_top	0.4)
		(sleep (random_range 5 10))
	(device_set_position exit_elev_top	0.45)
		(sleep (random_range 5 10))
	(device_set_position exit_elev_top	0.35)
		(sleep (random_range 5 10))
	(device_set_position exit_elev_top	0.4)
		(sleep (random_range 5 10))
)
;*
(script dormant explosion_death
	(ai_kill all)
	(if
		(not (volume_test_object blow_up_safe_zone (player0)))
		(begin
			(effect_new_on_ground \levels\solo\020_base\fx\base_destruction\base_destruction (player0))
			(sleep 30)
			(damage_object_effect \levels\solo\020_base\fx\base_destruction\base_destruction (player1))					
			(sleep 30)
			(unit_kill (unit (player0)))		
		)

	)
	(if
		(not (volume_test_object blow_up_safe_zone (player1)))
		(begin
			(effect_new_on_ground \levels\solo\020_base\fx\base_destruction\base_destruction (player1))
			(sleep 30)
			(damage_object_effect \levels\solo\020_base\fx\base_destruction\base_destruction (player1))					
			(sleep 30)			
			(unit_kill (unit (player1)))
		)
	)
	(if
		(not (volume_test_object blow_up_safe_zone (player2)))
		(begin
			(effect_new_on_ground \levels\solo\020_base\fx\base_destruction\base_destruction (player2))
			(sleep 30)
			(damage_object_effect \levels\solo\020_base\fx\base_destruction\base_destruction (player2))					
			(sleep 30)
			(unit_kill (unit (player2)))
		)
	)
	(if
		(not (volume_test_object blow_up_safe_zone (player3)))
		(begin
			(effect_new_on_ground \levels\solo\020_base\fx\base_destruction\base_destruction (player3))
			(sleep 30)
			(damage_object_effect \levels\solo\020_base\fx\base_destruction\base_destruction (player3))					
			(sleep 30)
			(unit_kill (unit (player3)))
		)
	)
)
*;
(script dormant cor_pa_static01
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
	(set static_end TRUE)
	
)
(script dormant cor_pa_static02
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
	(set static_end TRUE)	
)
(script dormant cor_pa_static03
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
	(set static_end TRUE)	
)
(script dormant cor_pa_static04
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
	(set static_end TRUE)	
)
(script dormant cor_pa_static05
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
	(set static_end TRUE)		
)
(script dormant cor_pa_static06
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
	(set static_end TRUE)	
)
(script static void hud_flicker_out
	(chud_cinematic_fade 0 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.05))
)

; ========================================== Ambient Rumble Scripts===============================================================================
;*

Script Data Points
fx_command_center_low
fx_command_center_high
fx_cave_a_high
fx_cave_a_med
fx_cave_a_low
fx_hallway_a_01_low
fx_hallway_a_02_low
fx_hallway_a_03_low
fx_highway_a_01_high
fx_highway_a_02_high
fx_hallway_b_low
fx_hangar_a_01_low
fx_hangar_a_02_low
fx_hangar_a_03_low
fx_hangar_a_04_low
fx_hangar_a_01_mid
fx_hangar_a_01_high
fx_motor_pool_01_low
fx_motor_pool_02_low
fx_motor_pool_03_low
fx_motor_pool_04_low
fx_motor_pool_01_high
fx_sewer_01_low
fx_evac_bottom_01_mid
fx_barracks_01_mid
fx_barracks_02_mid
fx_barracks_03_mid
fx_barracks_04_mid
fx_barracks_01_low
fx_barracks_02_low
fx_barracks_03_low
fx_barracks_04_low
fx_barracks_05_low
fx_evac_bottom_01_low
fx_evac_top_01_low
fx_evac_top_02_low
fx_cortana_01_mid
fx_cortana_05_high
fx_cortana_01_high
fx_cortana_02_high
fx_cortana_03_high
fx_cortana_04_high

Trigger Volumes
g_command_center_trig_a
g_command_center_trig_b
g_command_center_trig_c
g_cave_a_trig_a
g_cave_a_trig_b
g_hallway_a_trig_a
g_hallway_a_trig_b
g_hallway_a_trig_c
g_hallway_a_trig_d
g_highway_trig_a
g_highway_trig_b
g_hallway_b_trig_a
g_hangar_a_trig_a
g_motor_pool_trig_a
g_motor_pool_trig_b
g_motor_hallway_trig_a
g_sewer_trig_a
g_evac_bottom_trig_a
g_evac_bottom_trig_b
g_evac_bottom_trig_c
g_evac_top_trig_a
g_cortana_highway_trig_a
g_cortana_highway_trig_b
g_cortana_highway_trig_c
g_barracks_trig_a
g_barracks_trig_b
g_barracks_trig_c
*;
(global point_reference temp_point fx_command_center_01_low/p0)

(script static void (fx_dust_low (point_reference location))
	(effect_new_random "fx\scenery_fx\ceiling_dust\human_dust_fall_small\human_dust_fall_small.effect" location)
	(set temp_point (ai_random_smart_point location 0.25 30 60))	
	(effect_new_at_ai_point "fx\scenery_fx\ceiling_dust\human_dust_fall_small\human_dust_fall_small.effect" temp_point)
)

(script static void (fx_dust_mid (point_reference location))
	(effect_new_random "fx\scenery_fx\ceiling_dust\human_dust_fall_medium\human_dust_fall_medium.effect" location)
	(set temp_point (ai_random_smart_point location 0.25 30 60))	
	(effect_new_at_ai_point "fx\scenery_fx\ceiling_dust\human_dust_fall_medium\human_dust_fall_medium.effect" temp_point)
)

(script static void (fx_dust_high (point_reference location))
	(effect_new_random "fx\scenery_fx\ceiling_dust\human_dust_fall_large\human_dust_fall_large.effect" location)
	(set temp_point (ai_random_smart_point location 0.25 30 60))	
	(effect_new_at_ai_point "fx\scenery_fx\ceiling_dust\human_dust_fall_large\human_dust_fall_large.effect" temp_point)
)

(script static void (fx_debris_low (point_reference location))
	(effect_new_random "fx\scenery_fx\ceiling_dust\human_debris_fall_small\human_debris_fall_small.effect" location)
	(set temp_point (ai_random_smart_point location 0.25 30 60))	
	(effect_new_at_ai_point "fx\scenery_fx\ceiling_dust\human_debris_fall_small\human_debris_fall_small.effect" temp_point)
)

(script static void (fx_debris_mid (point_reference location))
	(effect_new_random "fx\scenery_fx\ceiling_dust\human_debris_fall_medium\human_debris_fall_medium.effect" location)
	(set temp_point (ai_random_smart_point location 0.25 30 60))	
	(effect_new_at_ai_point "fx\scenery_fx\ceiling_dust\human_debris_fall_medium\human_debris_fall_medium.effect" temp_point)
)

(script static void (fx_debris_high (point_reference location))
	(effect_new_random "fx\scenery_fx\ceiling_dust\human_debris_fall_large\human_debris_fall_large.effect" location)
	(set temp_point (ai_random_smart_point location 0.25 30 60))	
	(effect_new_at_ai_point "fx\scenery_fx\ceiling_dust\human_debris_fall_large\human_debris_fall_large.effect" temp_point)
)

(global short rumble_var 0)
(global short intensity_var 3)
;*
				((= rumble_var 0) (print "000000000000000000"))
				((= rumble_var 1) (print "111111111111111111"))
				((= rumble_var 2) (print "222222222222222222"))
				((= rumble_var 3) (print "333333333333333333"))
				((= rumble_var 4) (print "444444444444444444"))
				((= rumble_var 5) (print "555555555555555555"))
*;
(script continuous rumble_cave_a
	(if
		(or (volume_test_players g_cave_a_trig_a) 
			(volume_test_players g_cave_a_trig_b)
		)		
		(begin
		(print "rumble_cave_a")		
			(set rumble_var (random_range 0 6))
			(cond 
				((= rumble_var 0) (fx_dust_high fx_cave_a_high))
				((= rumble_var 1) (fx_debris_mid fx_cave_a_mid))
				((= rumble_var 2) (fx_debris_high fx_cave_a_high))
				((= rumble_var 3) (fx_dust_low fx_cave_a_low))
				((= rumble_var 4) (fx_dust_mid fx_cave_a_mid))
				((= rumble_var 5) (fx_dust_high fx_cave_a_high))
			
			)
			(cond 
				((= intensity_var 1) (sleep (random_range 30 45)))
				((= intensity_var 2) (sleep (random_range 15 30)))
				((= intensity_var 3) (sleep (random_range 0 15)))
			)
		)
	)
)


(script continuous rumble_command_center
	(if
		(or (volume_test_players g_command_center_trig_a) 
			(volume_test_players g_command_center_trig_b)
			(volume_test_players g_command_center_trig_c)
		)
		(begin
		(print "rumble_command_center")				
		(fx_dust_high fx_command_center_high)
		(fx_dust_high fx_command_center_high)
		
			(cond 
				((= intensity_var 1) (sleep (random_range 30 45)))
				((= intensity_var 2) (sleep (random_range 15 30)))
				((= intensity_var 3) (sleep (random_range 0 15)))
			)
		)
	)		
)

(script continuous rumble_hallway_a
	(if
		(or (volume_test_players g_hallway_a_trig_a) 
			(volume_test_players g_hallway_a_trig_b)
			(volume_test_players g_hallway_a_trig_c) 
			(volume_test_players g_hallway_a_trig_d)
			(volume_test_players g_hallway_a_trig_e)				
		)
		(begin
			(print "rumble_hallway_a")						
			(set rumble_var (random_range 0 4))
			(cond 

				((= rumble_var 0) (fx_dust_low fx_hallway_a_01_low))
				((= rumble_var 1) (fx_dust_low fx_hallway_a_02_low))
				((= rumble_var 2) (fx_dust_low fx_hallway_a_03_low))
				((= rumble_var 3) (fx_dust_low fx_hallway_a_04_low))
			)
			(set rumble_var (random_range 0 4))
			(cond 

				((= rumble_var 0) (fx_dust_low fx_hallway_a_01_low))
				((= rumble_var 1) (fx_dust_low fx_hallway_a_02_low))
				((= rumble_var 2) (fx_dust_low fx_hallway_a_03_low))
				((= rumble_var 3) (fx_dust_low fx_hallway_a_04_low))
			)
						
			(cond 
				((= intensity_var 1) (sleep (random_range 30 45)))
				((= intensity_var 2) (sleep (random_range 15 30)))
				((= intensity_var 3) (sleep (random_range 0 15)))
			)
		)		
	)
)

(script continuous rumble_highway_a
	(if
		(or (volume_test_players g_highway_trig_a) 
			(volume_test_players g_highway_trig_b)			
		)
		(begin
			(print "rumble_highway_a")						
			(set rumble_var (random_range 0 2))
			(cond 

				((= rumble_var 0) (fx_dust_high fx_highway_a_01_high))
				((= rumble_var 1) (fx_dust_high fx_highway_a_02_high))
				
			
			)
			(set rumble_var (random_range 0 2))			
			(cond 

				((= rumble_var 0) (fx_dust_high fx_highway_a_01_high))
				((= rumble_var 1) (fx_dust_high fx_highway_a_02_high))				
			
			)			
			(cond 
				((= intensity_var 1) (sleep (random_range 30 45)))
				((= intensity_var 2) (sleep (random_range 15 30)))
				((= intensity_var 3) (sleep (random_range 0 15)))
			)
		)		
	)
)


(script continuous rumble_hallway_b
	(if
		(volume_test_players g_hallway_b_trig_a) 
		(begin
			(print "rumble_hallway_b")								
			(fx_dust_low fx_hallway_b_low)
			(fx_dust_low fx_hallway_b_low)
			
			(cond 
				((= intensity_var 1) (sleep (random_range 30 45)))
				((= intensity_var 2) (sleep (random_range 15 30)))
				((= intensity_var 3) (sleep (random_range 0 15)))
			)
		)
	)
)
(script continuous rumble_hangar_a
	(if
		(volume_test_players g_hangar_a_trig_a) 
		(begin
			(print "rumble_hangar_a")										
			(set rumble_var (random_range 0 7))
			(cond 
				((= rumble_var 0) (fx_dust_mid fx_hangar_a_01_mid))
				((= rumble_var 1) (fx_dust_mid fx_hangar_a_01_mid))
				((= rumble_var 2) (fx_dust_high fx_hangar_a_01_high))
				((= rumble_var 3) (fx_dust_low fx_hangar_a_01_low))
				((= rumble_var 4) (fx_dust_low fx_hangar_a_02_low))
				((= rumble_var 5) (fx_dust_low fx_hangar_a_03_low))
				((= rumble_var 6) (fx_dust_high fx_hangar_a_01_high))
			
			)
			(set rumble_var (random_range 0 7))
			(cond 
				((= rumble_var 0) (fx_dust_mid fx_hangar_a_01_mid))
				((= rumble_var 1) (fx_dust_mid fx_hangar_a_01_mid))
				((= rumble_var 2) (fx_dust_high fx_hangar_a_01_high))
				((= rumble_var 3) (fx_dust_low fx_hangar_a_01_low))
				((= rumble_var 4) (fx_dust_low fx_hangar_a_02_low))
				((= rumble_var 5) (fx_dust_low fx_hangar_a_03_low))
				((= rumble_var 6) (fx_dust_high fx_hangar_a_01_high))
			
			)
					
			(cond 
				((= intensity_var 1) (sleep (random_range 30 45)))
				((= intensity_var 2) (sleep (random_range 15 30)))
				((= intensity_var 3) (sleep (random_range 0 15)))
			)
		)			
	)
)

(script continuous rumble_motor_pool

	(if
		(or (volume_test_players g_motor_pool_trig_a) 
			(volume_test_players g_motor_pool_trig_b)
			(volume_test_players g_motor_hallway_trig_a)
		)
		(begin
			(print "rumble_motor_pool")												
			(set rumble_var (random_range 0 6))
			(cond 

				((= rumble_var 0) (fx_dust_low fx_motor_pool_01_low))
				((= rumble_var 1) (fx_dust_low fx_motor_pool_02_low))
				((= rumble_var 2) (fx_dust_low fx_motor_pool_03_low))
				((= rumble_var 3) (fx_dust_high fx_motor_pool_01_high))
				((= rumble_var 4) (fx_dust_high fx_motor_pool_01_high))
				((= rumble_var 5) (fx_dust_low fx_motor_pool_04_low))				
			)
			(set rumble_var (random_range 0 6))
			(cond 

				((= rumble_var 0) (fx_dust_low fx_motor_pool_01_low))
				((= rumble_var 1) (fx_dust_low fx_motor_pool_02_low))
				((= rumble_var 2) (fx_dust_low fx_motor_pool_03_low))
				((= rumble_var 3) (fx_dust_high fx_motor_pool_01_high))
				((= rumble_var 4) (fx_dust_high fx_motor_pool_01_high))
				((= rumble_var 5) (fx_dust_low fx_motor_pool_04_low))
				
			
			)									
			(cond 
				((= intensity_var 1) (sleep (random_range 30 45)))
				((= intensity_var 2) (sleep (random_range 15 30)))
				((= intensity_var 3) (sleep (random_range 0 15)))
			)
		)		
	)
)

(script continuous rumble_sewer
	(if
		(volume_test_players g_sewer_trig_a)
		(begin
			(print "rumble_sewer")														
			(fx_dust_low fx_sewer_01_low)
			(fx_dust_low fx_sewer_01_low)
			
			(cond 
				((= intensity_var 1) (sleep (random_range 30 45)))
				((= intensity_var 2) (sleep (random_range 15 30)))
				((= intensity_var 3) (sleep (random_range 0 15)))
			)
		)		
	)
)

(script continuous rumble_barracks
	(if
		(or
			(volume_test_players g_barracks_trig_a)
			(volume_test_players g_barracks_trig_b)
			(volume_test_players g_barracks_trig_c)
		)
		(begin
			(print "rumble_barracks")																
			(set rumble_var (random_range 0 4))
			(cond 
				((= rumble_var 0) (begin
							   	(fx_dust_low fx_barracks_01_low)
							   	(fx_dust_low fx_barracks_01_mid))
							   )
				((= rumble_var 1) (begin
							   	(fx_dust_low fx_barracks_02_low)
							   	(fx_dust_low fx_barracks_02_mid))
							   )
				((= rumble_var 2) (begin
							   	(fx_dust_low fx_barracks_03_low)
							   	(fx_dust_low fx_barracks_03_mid))
							   )
				((= rumble_var 3) (begin
							   	(fx_dust_low fx_barracks_04_low)
							   	(fx_dust_low fx_barracks_04_mid))
							   )		
			)
			(set rumble_var (random_range 0 4))
			(cond 
				((= rumble_var 0) (begin
							   	(fx_dust_low fx_barracks_01_low)
							   	(fx_dust_low fx_barracks_01_mid))
							   )
				((= rumble_var 1) (begin
							   	(fx_dust_low fx_barracks_02_low)
							   	(fx_dust_low fx_barracks_02_mid))
							   )
				((= rumble_var 2) (begin
							   	(fx_dust_low fx_barracks_03_low)
							   	(fx_dust_low fx_barracks_03_mid))
							   )
				((= rumble_var 3) (begin
							   	(fx_dust_low fx_barracks_04_low)
							   	(fx_dust_low fx_barracks_04_mid))
							   )		
			)		
			(cond 
				((= intensity_var 1) (sleep (random_range 30 45)))
				((= intensity_var 2) (sleep (random_range 15 30)))
				((= intensity_var 3) (sleep (random_range 0 15)))
			)
		)
	)		
)

(script continuous rumble_evac_hangar
	(if
		(or
			(volume_test_players g_evac_bottom_trig_a)
			(volume_test_players g_evac_bottom_trig_b)
			(volume_test_players g_evac_bottom_trig_c)
			(volume_test_players g_evac_top_trig_a)			
		)
		(begin
			(print "rumble_evac_hangar")																		
			(set rumble_var (random_range 0 4))
			(cond 
				((= rumble_var 0) (begin
								(fx_dust_low fx_evac_bottom_01_low)
								(fx_dust_low fx_evac_top_01_low)
							   )
				)
				((= rumble_var 1) (begin
								(fx_dust_low fx_evac_bottom_01_low)
								(fx_dust_low fx_evac_top_02_low)
							   )
				)
				((= rumble_var 2) (begin
								(fx_dust_low fx_evac_bottom_01_low)
								(fx_dust_low fx_evac_top_02_low)
							   )
				)
				((= rumble_var 3) (begin
								(fx_dust_low fx_evac_bottom_01_low)
								(fx_dust_low fx_evac_top_01_low)
							   )
				)			
			)
			(set rumble_var (random_range 0 4))
			(cond 
				((= rumble_var 0) (begin
								(fx_dust_low fx_evac_bottom_01_low)
								(fx_dust_low fx_evac_top_01_low)
							   )
				)
				((= rumble_var 1) (begin
								(fx_dust_low fx_evac_bottom_01_low)
								(fx_dust_low fx_evac_top_02_low)
							   )
				)
				((= rumble_var 2) (begin
								(fx_dust_low fx_evac_bottom_01_low)
								(fx_dust_low fx_evac_top_02_low)
							   )
				)
				((= rumble_var 3) (begin
								(fx_dust_low fx_evac_bottom_01_low)
								(fx_dust_low fx_evac_top_01_low)
							   )
				)			
			)			
			(cond 
				((= intensity_var 1) (sleep (random_range 30 45)))
				((= intensity_var 2) (sleep (random_range 15 30)))
				((= intensity_var 3) (sleep (random_range 0 15)))
			)
		)		
	)
)

(script continuous rumble_cortana_highway
	(if
		(or
			(volume_test_players g_cortana_highway_trig_a)
			(volume_test_players g_cortana_highway_trig_b)
			(volume_test_players g_cortana_highway_trig_c)
		)
		
		(begin
			(print "rumble_cortana_highway")																				
			(set rumble_var (random_range 0 6))
			(cond 
				((= rumble_var 0) (fx_dust_mid fx_cortana_01_mid))
				((= rumble_var 1) (fx_dust_high fx_cortana_01_high))
				((= rumble_var 2) (fx_dust_high fx_cortana_02_high))
				((= rumble_var 3) (fx_dust_high fx_cortana_03_high))
				((= rumble_var 4) (fx_dust_high fx_cortana_04_high))
				((= rumble_var 5) (fx_dust_high fx_cortana_05_high))						
			
			)
			(set rumble_var (random_range 0 6))
			(cond 
				((= rumble_var 0) (fx_dust_mid fx_cortana_01_mid))
				((= rumble_var 1) (fx_dust_high fx_cortana_01_high))
				((= rumble_var 2) (fx_dust_high fx_cortana_02_high))
				((= rumble_var 3) (fx_dust_high fx_cortana_03_high))
				((= rumble_var 4) (fx_dust_high fx_cortana_04_high))
				((= rumble_var 5) (fx_dust_high fx_cortana_05_high))						
			
			)							
			(cond 
				((= intensity_var 1) (sleep (random_range 30 45)))
				((= intensity_var 2) (sleep (random_range 15 30)))
				((= intensity_var 3) (sleep (random_range 0 15)))
			)
		)		
	)
)

(script static void rumble_event_all
	(wake rumble_command_center)
	(wake rumble_cave_a)
	(wake rumble_hallway_a)
	(wake rumble_highway_a)
	(wake rumble_hallway_b)	
	(wake rumble_hangar_a)
	(wake rumble_motor_pool)
	(wake rumble_sewer)
	(wake rumble_evac_hangar)
	(wake rumble_barracks)
	(wake rumble_cortana_highway)
)
(script dormant 01_rumble_event_medium
	(print "01_rumble_event_medium")
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	(set intensity_var 2)
	(wake rumble_command_center)
	(wake rumble_cave_a)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.50 1)
	(rumble_shake_actors)			
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_cave_a)
	(sleep_forever rumble_command_center)
)


(script dormant 02_rumble_event_weak
	(print "02_rumble_event_weak")
	(sleep (random_range 30 90))
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl2.sound" NONE 1)
	(set intensity_var 1)	
	(wake rumble_command_center)
	(wake rumble_cave_a)
	(wake rumble_hallway_a)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.25 1)
	(rumble_shake_actors)				
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_command_center)
	(sleep_forever rumble_cave_a)
	(sleep_forever rumble_hallway_a)	
	
)


(script dormant 03_rumble_event_weak
	(print "03_rumble_event_weak")
	(sleep (random_range 30 90))
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl2.sound" NONE 1)
	(set intensity_var 1)
	(wake rumble_hallway_a)
	(wake rumble_highway_a)
	(wake rumble_hallway_b)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.25 1)
	(rumble_shake_actors)					
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_hallway_a)
	(sleep_forever rumble_highway_a)
	(sleep_forever rumble_hallway_b)	
)

(script dormant 04_rumble_event_medium
	(print "04_rumble_event_medium")
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	(set intensity_var 2)		
	(wake rumble_hangar_a)
	(wake rumble_hallway_b)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.50 1)
	(rumble_shake_actors)					
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_hangar_a)
	(sleep_forever rumble_hallway_b)	
)


(script dormant 05_rumble_event_medium
	(print "05_rumble_event_strong")
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	(set intensity_var 2)
	(wake rumble_hangar_a)				
	(wake rumble_hallway_a)
	(wake rumble_highway_a)
	(wake rumble_hallway_b)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.50 1)
	(rumble_shake_actors)					
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_hangar_a)	
	(sleep_forever rumble_hallway_a)
	(sleep_forever rumble_highway_a)
	(sleep_forever rumble_hallway_b)		
)

(script dormant 06_rumble_event_weak
	(print "06_rumble_event_weak")

	(sound_impulse_start "sound\levels\020_base\base_scripted_expl2.sound" NONE 1)
	(set intensity_var 1)		
	(wake rumble_hangar_a)
	(wake rumble_hallway_a)
	(wake rumble_cave_a)
	(wake rumble_command_center)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.25 1)
	(rumble_shake_actors)					
	(sleep 150)
	(player_effect_stop 0.5)	
	(sleep_forever rumble_hangar_a)
	(sleep_forever rumble_hallway_a)
	(sleep_forever rumble_cave_a)
	(sleep_forever rumble_command_center)	
)

(script dormant 07_rumble_event_strong
	(print "07_rumble_event_strong")
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	(set intensity_var 3)			
	(wake rumble_cave_a)
	(wake rumble_command_center)
	(wake rumble_motor_pool)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.65 1)
	(rumble_shake_actors)					
	(sleep 15)
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	(rumble_shake_actors)					
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_cave_a)
	(sleep_forever rumble_command_center)
	(sleep_forever rumble_motor_pool)	
)



(script dormant 08_rumble_event_weak
	(sleep_until (volume_test_players sewer_obj_trig01))
	(print "08_rumble_event_weak")
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl2.sound" NONE 1)
	(set intensity_var 1)				
	(wake rumble_motor_pool)
	(wake rumble_sewer)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.25 1)
	(rumble_shake_actors)					
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_motor_pool)
	(sleep_forever rumble_sewer)			
)

(script dormant 09_rumble_event_weak
	(sleep_until (volume_test_players barracks_obj_end))
	(print "09_rumble_event_weak")
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl2.sound" NONE 1)
	(wake rumble_sewer)
	(wake rumble_evac_hangar)
	(wake rumble_barracks)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.25 1)
	(rumble_shake_actors)					
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_sewer)
	(sleep_forever rumble_evac_hangar)
	(sleep_forever rumble_barracks)			
)

(script dormant 10_rumble_event_strong
	(print "10_rumble_event_strong")
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	(set intensity_var 3)					
	(wake rumble_cortana_highway)
	(wake rumble_evac_hangar)
	(wake rumble_barracks)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.65 1)
	(rumble_shake_actors)						
	(sleep 15)
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)	
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_cortana_highway)
	(sleep_forever rumble_evac_hangar)
	(sleep_forever rumble_barracks)		
)

(script dormant 11_rumble_event_weak
	(print "11_rumble_event_weak")
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl2.sound" NONE 1)
	(set intensity_var 1)					
	(wake rumble_cortana_highway)
	(wake rumble_evac_hangar)
	(wake rumble_motor_pool)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.25 1)
	(rumble_shake_actors)					
	(sleep 150)
	(player_effect_stop 0.25)
	(sleep_forever rumble_cortana_highway)
	(sleep_forever rumble_evac_hangar)
	(sleep_forever rumble_motor_pool)	
)
(script dormant 12_rumble_event_strong
	(sleep_until (volume_test_players cortana_highway_var_trig02))
	(print "12_rumble_event_medium")
	(set intensity_var 3)					
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	(wake rumble_hallway_a)
	(wake rumble_cave_a)
	(wake rumble_command_center)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.65 1)	
	(rumble_shake_actors)
	(sleep 15)
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)							
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_hallway_a)
	(sleep_forever rumble_cave_a)
	(sleep_forever rumble_command_center)	
)

(script dormant 13_rumble_event_medium
	(print "13_rumble_event_medium")
	(set intensity_var 2)					
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	(wake rumble_cortana_highway)
	(wake rumble_motor_pool)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.50 1)
	(rumble_shake_actors)					
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_cortana_highway)
	(sleep_forever rumble_motor_pool)	
)
(script dormant 14_rumble_event_medium
	(sleep_until (volume_test_players command_center_terminal_trig))
	(set intensity_var 2)					
	(print "14_rumble_event_medium")
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	(wake rumble_cortana_highway)
	(wake rumble_motor_pool)
	(wake rumble_command_center)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.50 1)
	(rumble_shake_actors)					
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_cortana_highway)
	(sleep_forever rumble_motor_pool)
	(sleep_forever rumble_command_center)	
)

(script dormant 15_rumble_event_strong
	(sleep_until (volume_test_players cave_a_dia03_trig))
	(print "15_rumble_event_strong")
	(set intensity_var 3)					
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	(wake rumble_cave_a)
	(wake rumble_command_center)
	(wake rumble_motor_pool)
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)	
	(player_effect_start 0.65 1)
	(rumble_shake_actors)					
	(sleep 15)
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	(rumble_shake_actors)					
	(sleep 150)
	(player_effect_stop 0.5)
	(sleep_forever rumble_cave_a)
	(sleep_forever rumble_command_center)
	(sleep_forever rumble_motor_pool)			
)


(script dormant rumble_event_strong_loop
	(sleep_until
		(begin
			(wake rumble_cave_a)
			(wake rumble_command_center)
			(wake rumble_hangar_a)
			(wake rumble_hallway_a)			
			(wake rumble_hallway_b)			
			(wake rumble_highway_a)			
			(print "rumble_event_strong_loop")
			(set intensity_var 3)					
			(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
			(if (not (volume_test_players g_hangar_a_trig_a))
			(effect_new levels\solo\020_base\fx\bombing\bombing_long.effect bombing_fx))			
			(set 16_rumble_bool TRUE)
			(player_effect_set_max_rotation 0 1 0.25)
			(player_effect_set_max_rumble 1 1)	
			(player_effect_start 0.65 1)
			(sleep 5)
			(rumble_shake_actors)							 			
			(set 16_rumble_bool FALSE)
			(sleep 10)
			(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
			(rumble_shake_actors)							
			(sleep 150)
			(player_effect_stop 0.5)
			(sleep_forever rumble_cave_a)
			(sleep_forever rumble_command_center)
			(sleep_forever rumble_hangar_a)
			(sleep_forever rumble_hallway_a)			
			(sleep_forever rumble_hallway_b)		
			(sleep_forever rumble_highway_a)							
		(volume_test_players base_exit))
	(* 30 (random_range 8 14)))
)
(global boolean 16_rumble_bool FALSE)

(global object_list shake_var (players))

(script static void rumble_shake_actors
	(set shake_var (ai_actors all))
	
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 0)) 20)
		(unit_play_random_ping (unit (list_get shake_var 0)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 1)) 20)
		(unit_play_random_ping (unit (list_get shake_var 1)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 2)) 20)
		(unit_play_random_ping (unit (list_get shake_var 2)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 3)) 20)
		(unit_play_random_ping (unit (list_get shake_var 3)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 4)) 20)
		(unit_play_random_ping (unit (list_get shake_var 4)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 5)) 20)
		(unit_play_random_ping (unit (list_get shake_var 5)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 6)) 20)
		(unit_play_random_ping (unit (list_get shake_var 6)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 7)) 20)
		(unit_play_random_ping (unit (list_get shake_var 7)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 8)) 20)
		(unit_play_random_ping (unit (list_get shake_var 8)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 9)) 20)
		(unit_play_random_ping (unit (list_get shake_var 9)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 10)) 20)
		(unit_play_random_ping (unit (list_get shake_var 10)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 11)) 20)
		(unit_play_random_ping (unit (list_get shake_var 11)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 12)) 20)
		(unit_play_random_ping (unit (list_get shake_var 12)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 13)) 20)
		(unit_play_random_ping (unit (list_get shake_var 13)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 14)) 20)
		(unit_play_random_ping (unit (list_get shake_var 14)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 15)) 20)
		(unit_play_random_ping (unit (list_get shake_var 15)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 16)) 20)
		(unit_play_random_ping (unit (list_get shake_var 16)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 17)) 20)
		(unit_play_random_ping (unit (list_get shake_var 17)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 18)) 20)
		(unit_play_random_ping (unit (list_get shake_var 18)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 19)) 20)
		(unit_play_random_ping (unit (list_get shake_var 19)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 20)) 20)
		(unit_play_random_ping (unit (list_get shake_var 20)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 21)) 20)
		(unit_play_random_ping (unit (list_get shake_var 21)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 22)) 20)
		(unit_play_random_ping (unit (list_get shake_var 22)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 23)) 20)
		(unit_play_random_ping (unit (list_get shake_var 23)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 24)) 20)
		(unit_play_random_ping (unit (list_get shake_var 24)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 25)) 20)
		(unit_play_random_ping (unit (list_get shake_var 25)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 26)) 20)
		(unit_play_random_ping (unit (list_get shake_var 26)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 27)) 20)
		(unit_play_random_ping (unit (list_get shake_var 27)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 28)) 20)
		(unit_play_random_ping (unit (list_get shake_var 28)))
	)
	(if 	(<= (objects_distance_to_object (players) (list_get shake_var 29)) 20)
		(unit_play_random_ping (unit (list_get shake_var 29)))
	)
)

