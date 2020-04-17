; =================================================================================================
; MUSIC
; =================================================================================================

(global sound			sound_mule_roar		none)
(global looping_sound	mus_01 				levels\solo\m30\music\m30_music01.sound_looping)
(global looping_sound	mus_02				levels\solo\m30\music\m30_music02.sound_looping)
(global looping_sound 	mus_03				levels\solo\m30\music\m30_music03.sound_looping)
(global looping_sound	mus_04				levels\solo\m30\music\m30_music04.sound_looping)
(global looping_sound	mus_05				levels\solo\m30\music\m30_music05.sound_looping)
(global looping_sound	mus_06				levels\solo\m30\music\m30_music06.sound_looping)
(global looping_sound	mus_07				levels\solo\m30\music\m30_music07.sound_looping)
(global looping_sound	mus_08				levels\solo\m30\music\m30_music08.sound_looping)
(global looping_sound	mus_09				levels\solo\m30\music\m30_music09.sound_looping)
(global looping_sound	mus_10				levels\solo\m30\music\m30_music10.sound_looping)
(global looping_sound	mus_11				levels\solo\m30\music\m30_music11.sound_looping)
(global looping_sound	mus_12				levels\solo\m30\music\m30_music12.sound_looping)
(global looping_sound	mus_13				levels\solo\m30\music\m30_music13.sound_looping)

; =================================================================================================
; MUSIC
; =================================================================================================
(script static void (mus_start (looping_sound s))
	(sound_looping_start s NONE 1))
	
(script static void (mus_stop (looping_sound s))
	(sound_looping_stop s))
	
	
(script static void music_kill_all
	(sound_looping_stop_immediately mus_01)
	(sound_looping_stop_immediately mus_02)
	(sound_looping_stop_immediately mus_03)
	(sound_looping_stop_immediately mus_04)
	(sound_looping_stop_immediately mus_05)
	(sound_looping_stop_immediately mus_06)
	(sound_looping_stop_immediately mus_07)
	(sound_looping_stop_immediately mus_08)
	(sound_looping_stop_immediately mus_09)
	(sound_looping_stop_immediately mus_10)
	(sound_looping_stop_immediately mus_11)
	(sound_looping_stop_immediately mus_12)
	(sound_looping_stop_immediately mus_13)
)


; =================================================================================================
; CINEMATICS
; =================================================================================================

; =================================================================================================
; MISSION OBJECTIVES
; =================================================================================================
(script static void (new_mission_objective (string_id screen) (string_id start_menu))
	;(objectives_clear)
	(sound_impulse_start sound\game_sfx\fireteam\issue_directive.sound NONE 1)
	(f_hud_obj_new screen start_menu)
	;(cinematic_set_chud_objective t)
	;(if debug (print "objectives: adding objective to the start menu tray..."))
	;(objectives_show objective_index))
)

(script static void clear_mission_objectives
	(objectives_clear)
)


(script dormant show_objective_1
	(new_mission_objective ct_primary_objective_1 PRIMARY_OBJECTIVE_1))

(script dormant show_objective_2
	(new_mission_objective ct_primary_objective_2 PRIMARY_OBJECTIVE_2))
	
(script dormant show_objective_3
	(new_mission_objective ct_primary_objective_3 PRIMARY_OBJECTIVE_3))
	
(script dormant show_objective_3_insertion
	(sleep 90)
	(new_mission_objective ct_primary_objective_3 PRIMARY_OBJECTIVE_3))
	
(script dormant show_objective_4
	(new_mission_objective ct_primary_objective_4 PRIMARY_OBJECTIVE_4))
	
(script dormant show_objective_5
	(new_mission_objective ct_primary_objective_5 PRIMARY_OBJECTIVE_5))
	
(script dormant show_objective_5_insertion
	(sleep 90)
	(new_mission_objective ct_primary_objective_5 PRIMARY_OBJECTIVE_5))
	
(script dormant show_objective_6
	(new_mission_objective ct_primary_objective_6 PRIMARY_OBJECTIVE_6))
	
(script dormant show_objective_7
	(new_mission_objective ct_primary_objective_7 PRIMARY_OBJECTIVE_7))
	
(script dormant show_objective_8
	(new_mission_objective ct_primary_objective_8 PRIMARY_OBJECTIVE_8))

(script dormant show_tutorial_nightvision
	(if (not (difficulty_is_heroic_or_higher))
		(begin
			(f_hud_training player0 tutorial_nightvision)
			(f_hud_training player1 tutorial_nightvision)
			(f_hud_training player2 tutorial_nightvision)
			(f_hud_training player3 tutorial_nightvision)
		)
	)
)

(script dormant show_tutorial_assassination
	(if (not (difficulty_is_heroic_or_higher))
		(begin
			(f_hud_training player0 tutorial_assassination)
			(f_hud_training player1 tutorial_assassination)
			(f_hud_training player2 tutorial_assassination)
			(f_hud_training player3 tutorial_assassination)
		)
	)
)

(script dormant chapter_title_start
	(f_hud_chapter ct_quiet))

(script dormant chapter_title_mule
	(f_hud_chapter ct_mule))

(script dormant chapter_title_settlement
	(f_hud_chapter ct_settlement))


; =================================================================================================
; MISSION DIALOGUE: MAIN SCRIPTS
; =================================================================================================

(global boolean 	b_dialogue_playing false)
(global short 		s_md_duration 0)

(global ai 			ai_jun none)
(global ai			ai_cv1 none)
(global ai 			ai_cv2 none)
(global ai			ai_cvf none)

; -------------------------------------------------------------------------------------------------
(script static void (md_play (short delay) (sound line))
	(sleep delay)
	(sound_impulse_start line NONE 1)
	(sleep (sound_impulse_language_time line)))

(script static void (md_print (string line))
	(if dialogue (print line)))
	
(script static void md_start
	(sleep_until (not b_dialogue_playing) 1)
	(ai_dialogue_enable false)
	(set b_dialogue_playing TRUE))
	
(script static void md_stop
	(ai_dialogue_enable true)
	(set b_dialogue_playing FALSE))

(script static void (md_ai_play (short delay) (ai char) (ai_line line))
	(set s_md_duration (ai_play_line char line))
	(sleep s_md_duration)
	(sleep delay)
)

(script static void (md_object_play (short delay) (object obj) (ai_line line))
	(set s_md_duration (ai_play_line_on_object obj line))
	(sleep s_md_duration)
	(sleep delay)
)

(script static void md_abort
	(sleep s_md_duration)
	(if debug (print "!!! mission dialogue aborted !!!"))
	(set b_dialogue_playing FALSE)
)


; -------------------------------------------------------------------------------------------------
; MISC LINES			
; -------------------------------------------------------------------------------------------------
(script dormant md_jun_mule_roar_1
	(sleep_until (= b_mule_has_roared true))
	
	(md_start)
	
		(md_print "JUN: The hell is that?") 
		(md_ai_play 0 ai_jun m30_0050)

	(md_stop)
	
	(set b_mule_has_roared false)
	(wake md_jun_mule_roar_2)
)

(script dormant md_jun_mule_roar_2
	(sleep_until (= b_mule_has_roared true))
	
	(md_start)
	
		(md_print "JUN: Sounds big, whatever it is...")
		(md_ai_play 0 ai_jun m30_0060)
		
	(md_stop)
)

(script dormant md_jun_stay_outta_sight
	(md_start)
	
		(md_print "JUN: Stay outta sight, Six. Watch those lights.")
		(md_ai_play 0 ai_jun m30_0070)
	
	(md_stop)
)

(script dormant md_jun_dead_civilians
	(md_start)
	
		(md_print "JUN: Kat, we've got dead civilians... For farmers they're pretty well armed.")
		(md_ai_play 0 ai_jun m30_0220)
		
		(md_print "KAT: Sounds like militia. Weapons shipments routinely go missing and turn up in rebel hands on Reach.")
		(md_object_play 0 NONE m30_0230)
		
		(md_print "KAT: You see something you like, take it.")
		(md_object_play 0 NONE m30_0240)
	
	(md_stop)
)

(script dormant md_jun_really_pissed_them_off
	(branch 
		(= b_slo_started true) (md_abort)
	)
	
	(ai_dialogue_enable false)
	(sleep 30)
	
	(md_start)
	
		(md_print "JUN: Incoming. Looks like you really pissed them off.")
		(md_ai_play 0 ai_jun m30_0250)
	
	(md_stop)
	
	
	
	(mus_stop mus_01)
	(mus_start mus_02)
	
	(f_callout_object (ai_vehicle_get sq_cov_fkv_phantom_reinforce/pilot) blip_hostile_vehicle)
)

(script dormant md_jun_shoot_light_1
	(md_start)
	
		(md_print "JUN: Six, take out the searchlight on that dropship!")
		(md_ai_play 0 ai_jun m30_0260)
		
	(md_stop)
)

(script dormant md_jun_shoot_light_2
	(md_start)
		
		(md_print "JUN: Take out that Phantom light, Six!")
		(md_ai_play 0 ai_jun m30_0270)
			
	(md_stop)
)

(script dormant md_jun_shoot_light_3
	(md_start)
	
		(md_print "JUN: Shoot the searchlight!")
		(md_ai_play 0 ai_jun m30_0280)
		
	(md_stop)
)

(script dormant md_jun_shoot_light_success_1
	(md_start)
	
		(md_print "JUN: They're blind and bugging out!")
		(md_ai_play 0 ai_jun m30_0290)
		
	(md_stop)
)

(script dormant md_jun_shoot_light_success_2
	(md_start)
	
		(md_print "JUN: Let's see how they do without air support! Re-engaging!")
		(md_ai_play 0 ai_jun m30_0300)
		
	(md_stop)
)

(script dormant md_jun_shoot_light_success_3
	(md_start)
	
		(md_print "JUN: Always hated the spotlight...")
		(md_ai_play 0 ai_jun m30_0310)
		
	(md_stop)
)

(script dormant md_kat_stealth_training
	(md_start)
		
		(md_print "KAT: Six, that's an unidentified piece of Covenant gear. Go ahead and activate it so I can get more data.")
		(md_object_play 0 NONE m30_0110)
	
	(md_stop)
	
	; tutorial goes here
	
	(md_start)
	
		; alt
		;(md_print "KAT: Interesting... I read negative light refraction from your shields.")
		;(md_object_play 0 NONE m30_0120)
	
		(md_print "DOT: How very interesting. Armor diagnostics show negative light refraction from Noble Six's shields.")
		(md_object_play 0 NONE m30_0130)
		
		(md_print "JUN: Active camo? The next one's mine.")
		(md_object_play 0 ai_jun m30_0140)
		
	(md_stop)
)

(global boolean b_rvr_dropship_is_overhead false)
(script dormant md_jun_dropship_overhead_1	
	(sleep_until (<= (objects_distance_to_object (ai_actors sq_cov_rvr_phantom0) (player0)) 50))
	
	(md_start)
		
		(sleep 20)
		
		(set b_rvr_dropship_is_overhead true)
		(cs_run_command_script gr_militia cs_rvr_dropship_overhead)
		(cs_run_command_script ai_jun cs_rvr_dropship_overhead)
		
		(md_print "JUN: Hold up! Covey dropship! Take cover!")
		(md_ai_play 0 ai_jun m30_0880)
		
		
		(sleep_until (> (objects_distance_to_object (ai_actors sq_cov_rvr_phantom0) (player0)) 30))
		
		(md_print "JUN: Okay, clear! Let's move.")
		(md_ai_play 0 ai_jun m30_0910)
		
		(set b_rvr_dropship_is_overhead false)
		
	(md_stop)
)

(script command_script cs_rvr_dropship_overhead
	(cs_enable_moving 1)
	(cs_enable_looking 1)
	(cs_enable_targeting 1)
	(sleep (random_range 15 30))
	
	(cs_crouch 1)
	(cs_enable_moving 1)
	(cs_aim_object true (ai_vehicle_get sq_cov_rvr_phantom0/pilot))
	
	(sleep_until 
		(or 
			(>= s_objcon_rvr 60)
			(= b_rvr_dropship_is_overhead false)
		)
	)
	(sleep (random_range 15 45))
)

(script dormant md_jun_dropship_overhead_2
	(md_start)
	
		(md_print "JUN: Dropship overhead! Stay out of sight!")
		(md_ai_play 0 ai_jun m30_0890)
		
	(md_stop)
)

(script dormant md_jun_dropship_overhead_3
	(md_start)
	
		(md_print "JUN: We got another dropship! Stick to the shadows!")
		(md_ai_play 0 ai_jun m30_0900)
		
	(md_stop)
)

(script dormant md_jun_dropship_clear_1
	(md_start)
	
		(md_print "JUN: Okay, clear! Let's move.")
		(md_ai_play 0 ai_jun m30_0910)
		
	(md_stop)
)

(script dormant md_jun_dropship_clear_2
	(md_start)
	
		(md_print "JUN: Dropship's gone. Move out.")
		(md_ai_play 0 ai_jun m30_0920)
		
	(md_stop)
)

(script dormant md_jun_dropship_clear_3
	(md_start)
	
		(md_print "JUN: We're clear! Hit the trail!")
		(md_ai_play 0 ai_jun m30_0930)
		
	(md_stop)
)


; -------------------------------------------------------------------------------------------------
; INSERTION
; -------------------------------------------------------------------------------------------------
(script dormant md_start_jun_intro
	(ai_dialogue_enable false)
	
	(sleep 90)
		
	(md_start)
		
		(md_print "KAT: Recon Bravo: The sector ahead is dark to electronic surveillance.")
		(md_object_play 20 NONE m30_0010)
		
		(md_print "JUN: Covenant can block our instruments?")
		(md_ai_play 15 ai_jun m30_0020)
		
		(md_print "KAT: So it would seem.  And Command wants to know what they're hiding.")
		(md_object_play 0 NONE m30_0030)
		
		(wake show_objective_1)
				
		;(md_print "JUN: Understood. Six: You sweep the cliffside. I'll keep you covered from up top.")
		;(md_ai_play 0 ai_jun m30_0040)
		
	(md_stop)
)

(global ai ai_assassination_target none)
(script dormant md_start_jun_stealth_kill
	
	;(sleep_until
		;(objects_can_see_object (players) (ai_get_object sq_cov_ovr_high_elites0) 20) 1)
	
	(sleep_until (>= s_objcon_ovr 30) 1)
		
	(if (and
			(> (ai_living_count ai_assassination_target) 0)
			(< (ai_combat_status gr_cov_ovr) 4))
		; target is living
		; -------------------------------------------------
		(begin
			(md_start)
				
				(md_print "JUN: Elite. He's yours. Do it quiet.")
				(md_ai_play 0 ai_jun m30_0080)
				
				(wake show_tutorial_assassination)
				
				(f_callout_ai ai_assassination_target blip_neutralize)
				
			(md_stop)
			
			(sleep_until
				(or
					(<= (ai_living_count ai_assassination_target) 0)
					(> s_objcon_fkv 40)
					(> (ai_combat_status gr_cov_ovr) 3)
				)
			)
			
			(if 
				(and 
					(< (ai_combat_status gr_cov_ovr) 4)
					(<= (ai_living_count ai_assassination_target) 0)
				)
					; player successfully stealth-killed the target
					; -------------------------------------------------
					(begin
						(sleep 30)
						(md_start)
							(md_print "JUN: Not bad.")
							(md_ai_play 0 ai_jun m30_0090)
						(md_stop)
					)
					; -------------------------------------------------
			)
		)
		; -------------------------------------------------
	)
)


; -------------------------------------------------------------------------------------------------
; FIRST KIVA
; -------------------------------------------------------------------------------------------------
(script dormant md_fkv_jun_sitrep
	(sleep_until 
		(or
			(volume_test_object tv_fkv_jun_start_sitrep (ai_get_object ai_jun))
			(volume_test_players tv_fkv_jun_start_sitrep)
		)
	)
	
	(ai_dialogue_enable false)
	(sleep 45)
	
	
	(md_start)
	
		(md_print "JUN: Recon Bravo to Noble Two.  Stand by for contact report.")
		(md_ai_play 0 ai_jun m30_0150)
	
		(md_print "KAT: Standing by to copy, over.")
		(md_object_play 0 NONE m30_0160)
	
		;(wake fkv_hud_flash_silo)
		;(wake fkv_blip_enemies)
		
		(md_print "JUN: We have eyes on multiple hostiles patrolling a settlement. This what we're looking for, Kat?")
		(md_ai_play 0 ai_jun m30_0170)

		(md_print "KAT: Negative. Too small, and you're not in the dark zone yet. Engage at your discretion, but keep moving.")
		(md_object_play 0 NONE m30_0180)

		
		;(if (< s_objcon_fkv 10)
			(if (>= (ai_combat_status gr_cov_fkv) 3)
				(begin
					(md_print "JUN: Already engaged!")
					(md_ai_play 0 ai_jun m30_0200)
				)
				
				(begin
					(md_print "JUN: You heard her, Six. Drop those tangos. Stay away from the lights.")
					(md_ai_play 0 ai_jun m30_0190)
				)
			)
		;)
		
	(md_stop)
)

(script dormant fkv_blip_enemies
	(sleep 90)
	(f_callout_ai_fast gr_cov_fkv_jetpacks blip_hostile)
	(f_callout_ai_fast gr_cov_fkv_highvalue blip_hostile)
)


(script dormant md_fkv_jun_player_spotted
	(md_start)
	
		(md_print "JUN: Now you've done it!")
		(md_ai_play 0 ai_jun m30_0210)
		
	(md_stop)
)

(global boolean b_slo_jun_leave false)
(script dormant md_slo_jun_use_gate
	(sleep_until (<= (ai_task_count obj_cov_slo/gate_main) 0))

			
	(md_start)
	
		(md_print "JUN: There's a path to the southeast; I'm gonna head that way. Use the gate and meet me on the other side.")
		(md_ai_play 0 ai_jun m30_0320)
		
	(md_stop)
	
	(set b_slo_jun_leave true)
)


; -------------------------------------------------------------------------------------------------
; FIELDS
; -------------------------------------------------------------------------------------------------
(script dormant md_fld_jun_mule_intro
	(sleep_until (>= s_objcon_fld 1))
	
	(md_start)
	
		(md_print "JUN: Look at that...")
		(md_ai_play 60 ai_jun m30_0330)

		;(md_print "JUN: Might wanna stay outta sight, Six.")
		;(md_ai_play 0 ai_jun m30_0340)
	
		;(md_print "JUN: Looks like the Coveys are having some personnel issues.")
		;(md_print "JUN: What the hell ARE those things? And and the hell are they doing to 'em?")
		;(md_ai_play 0 ai_jun m30_0350)
		
		
	(md_stop)
	
	(mus_start mus_04)
)

(script dormant md_fld_jun_stay_outta_sight
	(md_start)
	
		(md_print "JUN: Might wanna stay outta sight, Six.")
		(md_ai_play 0 ai_jun m30_0340)
	
		(md_print "JUN: Looks like the Coveys are having some personnel issues.")
		(md_print "JUN: What the hell ARE those things? And and the hell are they doing to 'em?")
		(md_ai_play 0 ai_jun m30_0350)
		
	(md_stop)
	
	
)

(script dormant md_fld_jun_mule_dies
	(md_start)
	
		(md_print "JUN: Aww, that ain't right.")
		(md_ai_play 0 ai_jun m30_0360)
		
	(md_stop)
)

(script dormant md_fld_jun_dont_do_anything
	(md_start)
	
		(md_print "JUN: Easy! Don't do anything to set it off!")
		(md_ai_play 0 ai_jun m30_0370)
	
	(md_stop)
)

(script dormant md_fld_jun_put_that_thing_down
	(md_start)
	
		(md_print "JUN: No choice; you gotta put that thing down!")
		(md_ai_play 0 ai_jun m30_0380)
	
	(md_stop)
)

(script dormant md_fld_jun_headshot_six
	(md_start)
	
		(md_print "JUN: Headshot, Six! Go for the head!")
		(md_ai_play 0 ai_jun m30_0390)
		
	(md_stop)
)

(script dormant md_fld_jun_just_walk_away
	(md_start)
	
		(md_print "JUN: That's right, big fella. Just walk away...")
		(md_ai_play 0 ai_jun m30_0400)
		
	(md_stop)
)

(script dormant md_fld_jun_asks_kat_about_mule
	(ai_dialogue_enable false)
	
	(sleep 90)
	
	(md_start)
	
		(md_print "JUN: Kat, you pick any of that up?")
		(md_ai_play 35 ai_jun m30_0410)
		
		(md_print "KAT: Affirmative, Recon Bravo. It's an indigenous creature called a Gueta.")
		(md_object_play 15 NONE m30_0420)
		
		;(md_print "JUN: Coveys are trying to use'em as draft animals. Not with much success.")
		;(md_ai_play 35 ai_jun m30_0430)
		
		;(md_print "KAT: Odd. I'll report it.")
		;(md_object_play 0 NONE m30_0440)
	
	(md_stop)
	
	(sleep 60)
	
	(if (not b_pmp_started)
		(wake md_fld_jun_trail_up_ahead))
)

(script dormant md_fld_jun_trail_up_ahead
	(ai_dialogue_enable false)
	(sleep 30)
	
	(md_start)
	
		(md_print "JUN: Six, there's a trail up ahead, through the rocks. Let's take it.")
		(md_ai_play 0 ai_jun m30_0450)
	
	(md_stop)
	
	(ai_dialogue_enable true)
)


; -------------------------------------------------------------------------------------------------
; PUMPSTATION
; -------------------------------------------------------------------------------------------------
(script static void md_pmp_kill_dialogue
	(if debug (print "pmp: killing a mission dialogue script..."))
	(md_stop)
	(sleep 60)
)

(script dormant sfx_pmp_magnum_burst
	(if debug (print "bang!"))
	(sound_impulse_start sound\weapons\magnum\magnum_fire.sound sfx_magnum0 1)
	(sleep 5)
	(if debug (print "bang!"))
	(sound_impulse_start sound\weapons\magnum\magnum_fire.sound sfx_magnum0 1)
	(sleep 8)
	(if debug (print "bang!"))
	(sound_impulse_start sound\weapons\magnum\magnum_fire.sound sfx_magnum0 1)
	
	(sleep 12)
	
	(if debug (print "bang!"))
	(sound_impulse_start sound\weapons\magnum\magnum_fire.sound sfx_magnum1 1)
	(sleep 9)
	(if debug (print "bang!"))
	(sound_impulse_start sound\weapons\magnum\magnum_fire.sound sfx_magnum1 1)
	(sleep 15)
	(if debug (print "bang!"))
	(sound_impulse_start sound\weapons\magnum\magnum_fire.sound sfx_magnum0 1)
)

(script dormant md_pmp_jun_magnums
	(pmp_jun_failsafe)
	
	(sound_impulse_start sound\levels\solo\m30\magnums_in_distance.sound sfx_magnum0 1)
	
	(sleep (random_range 20 40))
	(md_start)
	
		(md_print "JUN: Gunfire! Magnums -- security sidearms, standard issue...")
		(md_ai_play 0 ai_jun m30_0470)
	
	(md_stop)
	
	(mus_stop mus_03)
)

(script dormant md_pmp_jun_sees_militia
	(sleep_until (>= s_objcon_pmp 10))
	
	(sleep_until
		(or 
			(>= s_objcon_pmp 20)
			(volume_test_object tv_pmp_jun_sees_militia (ai_get_object ai_jun))
		)
	30 (* 30 20))
	
	(ai_dialogue_enable false)
	(sleep 30)

	(md_start)
	
		(md_print "JUN: Noble 2, we're at some sort of pump station. Got eyes on civilians -- I'm thinking more local militia. They've engaged hostiles.")
		(md_ai_play 0 ai_jun m30_0480)
		
		(md_print "KAT: Move to assist; they may have intel we need.")
		(md_object_play 20 NONE m30_0490)
		
		(md_print "JUN: You heard her, Six. Keep those civilians alive!")
		(md_ai_play 30 ai_jun m30_0500)
		
	(md_stop)
	
	(mus_start mus_06)
			;(new_mission_objective ct_primary_objective_4 PRIMARY_OBJECTIVE_4)
	(wake show_objective_4)
	(f_blip_ai sq_unsc_pmp_militia0 5)
	(f_blip_ai sq_unsc_pmp_militia1 5)
	(f_blip_ai sq_unsc_pmp_militia2 5)
			
	
	(wake md_pmp_lost_civilians)
	(wake md_pmp_cv1_give_us_a_hand)
)

(script dormant md_pmp_jun_dropship_another
	(md_start)
	
		(md_print "JUN: Another dropship coming in!")
		(md_ai_play 0 ai_jun m30_0510)
		
	(md_stop)
)

(script dormant md_pmp_jun_dropship_two_more
	(md_start)
	
		(md_print "JUN: Two more Covenant dropships inbound!")
		(md_ai_play 0 ai_jun m30_0520)
		
	(md_stop)
)

(script dormant md_pmp_jun_dropship_three_inbound
	(md_start)
	
		(md_print "JUN: I make three dropships coming in!")
		(md_ai_play 0 ai_jun m30_0530)
		
	(md_stop)
)

(script dormant md_pmp_cv1_give_us_a_hand
	(branch
		(or
			(<= (ai_living_count gr_militia) 0) 
			(= b_pmp_assault_started true)
			(= b_rvr_started true)
		)
			
				; -------------------------------------------------	
				(md_abort)
				; -------------------------------------------------
	)
	
	(sleep_until 
		(or
			(< (objects_distance_to_object (ai_actors gr_militia) (player0)) 5)
			(< (objects_distance_to_object (ai_actors gr_militia) (player1)) 5)
			(< (objects_distance_to_object (ai_actors gr_militia) (player2)) 5)
			(< (objects_distance_to_object (ai_actors gr_militia) (player3)) 5)
		)
	)

	(vs_cast gr_militia true 10 m30_0540)
	(set ai_cv1 (vs_role 1))
	
	(md_start)
	
		(md_print "CIVILIAN 1: Give us a hand! Bastards just keep coming!")
		(md_ai_play 0 ai_cv1 m30_0540)
	
	(md_stop)
)

(script dormant md_pmp_cv2_give_us_a_hand
	(md_start)
	
		(md_print "CIVILIAN 2: Give us a hand! Bastards just keep coming!")
		;(md_ai_play 0 ai_cv2 m30_0550)
		(md_object_play 0 NONE m30_0550)
	
	(md_stop)
)

; unused -- can't afford female militia here, maybe later
(script dormant md_pmp_cvf_give_us_a_hand
	(md_start)
	
		(md_print "CIVILIAN FEMALE: Give us a hand! Bastards just keep coming!")
		(md_ai_play 0 ai_cvf m30_0560)
	
	(md_stop)
)

;*
(script dormant md_pmp_postcombat
	(branch
		(= b_pmp_player_skips_encounter true) (md_pmp_kill_dialogue))
	
	(if debug (print "pmp: postcombat conversation started..."))
	(sleep 60)

	; move everyone 
	(if (> (ai_living_count gr_militia) 0)
		(md_pmp_jun_hydro_civs_alive)
		(md_pmp_jun_hydro_civs_dead))

	;(new_mission_objective ct_primary_objective_5 PRIMARY_OBJECTIVE_5)
	(wake show_objective_5)
	
	
	
	(sleep_until (volume_test_object tv_pmp_jun_sees_river (ai_get_object ai_jun)) 1 (* 30 120))
	
		(if (<= (ai_living_count gr_militia) 0)
			(wake md_pmp_jun_theres_the_riverbed))
)
*;


(script dormant md_pmp_lost_civilians
	(sleep_until (<= (ai_living_count gr_militia) 0))
	
	(sleep 45)
	
	(md_start)
		
		;(md_print "JUN: No movement. Nothing else alive, human OR Covenant.")
		;(md_ai_play 0 ai_jun m30_0570)
	
		(md_print "JUN: Recon Bravo to Noble Two. We lost the civilians.")
		(md_ai_play 0 ai_jun m30_0580)
		
		;(md_print "KAT: Okay, keep moving. You're almost to the dark zone.")
		;(md_object_play 0 NONE m30_0590)
		
	(md_stop)

	;(set b_pmp_go_to_gate true)
)

(global ai ai_civilian2 none)


(global boolean b_pmp_stash_convo_active false)
(global boolean b_pmp_stash_convo_completed false)
(script dormant md_pmp_stash_convo
	(md_start)
	
		(if debug (print "::: starting pumpstation initial postcombat conversation..."))
		
		(vs_cast gr_militia true 10 m30_0600)
		(set ai_civilian2 (vs_role 1))
				
		(branch
			(or
				(= b_pmp_player_skips_encounter true)
				(<= (object_get_health (ai_get_object ai_civilian2)) 0)
			)
						; -------------------------------------------------
						 (md_pmp_kill_stash_dialogue)
						; -------------------------------------------------
		)
		
		(if debug (print "we're now past the branch..."))
		
		(md_print "CIVILIAN 2: Little more action than we're used to. You Spartans are good in a fight.")
		(md_ai_play 20 ai_civilian2 m30_0600)
		;(md_object_play 25 NONE m30_0600)
		
		(md_print "JUN: What are you doing here? Whole area's supposed to be evacuated.")
		(md_ai_play 25 ai_jun m30_0610)
		
		
		
		(md_print "CIVILIAN 2: Didn't like leaving it to someone else to protect our home.")
		(md_ai_play 0 ai_civilian2 m30_0620)
		;(md_object_play 15 NONE m30_0620)
		
		(set b_pmp_assault_start_dropships true)
		
		(md_print "CIVILIAN 2: So we came back... for this.")
		(md_ai_play 30 ai_civilian2 m30_0630)
		;(md_object_play 35 NONE m30_0630)
		
				; -------------------------------------------------
				;(device_set_power dm_pmp_stash0 1)
				;(device_set_power dm_pmp_stash1 1)
				(device_set_position dm_pmp_stash0 1)
				(device_set_position dm_pmp_stash1 1)
				
				(wake pmp_callout_stash)
				
				; -------------------------------------------------
				
		(md_print "CIVILIAN 2: We have them hidden all over the territory.")
		(md_ai_play 0 ai_civilian2 m30_0640)
		;(md_object_play 20 NONE m30_0640)
		
		(md_print "JUN: You know this stuff is stolen.")
		(md_ai_play 10 ai_jun m30_0650)
		
		(md_print "CIVILIAN 2: You going to arrest me?")
		(md_ai_play 30 ai_civilian2 m30_0660)
		;(md_object_play 0 NONE m30_0660)
		
		(md_print "JUN: No. Gonna steal it back.")
		(md_ai_play 10 ai_jun m30_0670)
		
		(set b_pmp_stash_convo_active false)
		(set b_pmp_stash_convo_completed true)
		
	(md_stop)
)


(script command_script cs_pmp_stash_convo_mil0
	(cs_push_stance alert)
	(cs_go_to pts_thespian_pmp_stash/mil0_dest)
	(cs_face_object true (ai_get_object ai_jun))
	(cs_look_object true (ai_get_object ai_jun))
	(sleep_until b_pmp_stash_convo_completed)
)

(script command_script cs_pmp_stash_convo_mil1
	(cs_push_stance alert)
	(cs_go_to pts_thespian_pmp_stash/mil1_dest)
	(cs_face_object true (ai_get_object ai_jun))
	(cs_look_object true (ai_get_object ai_jun))
	(sleep_until b_pmp_stash_convo_completed)
)

(script command_script cs_pmp_stash_convo_mil2
	(cs_push_stance alert)
	(cs_go_to pts_thespian_pmp_stash/mil2_dest)
	(cs_face_object true (ai_get_object ai_jun))
	(cs_look_object true (ai_get_object ai_jun))
	(sleep_until b_pmp_stash_convo_completed)
)

(script command_script cs_pmp_stash_convo_mil3
	(cs_push_stance alert)
	(cs_go_to pts_thespian_pmp_stash/mil3_dest)
	(cs_face_object true (ai_get_object ai_jun))
	(cs_look_object true (ai_get_object ai_jun))
	(sleep_until b_pmp_stash_convo_completed)
)

(script command_script cs_pmp_stash_convo_jun
	(cs_push_stance alert)
	(cs_go_to pts_thespian_pmp_stash/jun_dest)
	(cs_face true pts_thespian_pmp_stash/jun_face)
	(sleep_until b_pmp_stash_convo_completed)
)


(script dormant md_pmp_jun_dropship_control
	(sleep_until b_pmp_charlie_enroute)
	(md_pmp_jun_another_dropship)
	(mus_stop mus_06)
	(f_callout_object (ai_vehicle_get sq_cov_pmp_charlie_ds/pilot) blip_hostile_vehicle)
	
	(sleep_until b_pmp_bravo_enroute)
	(md_pmp_jun_dropship_got_company)
	(f_callout_object (ai_vehicle_get sq_cov_pmp_bravo_ds/pilot) blip_hostile_vehicle)
	
	(sleep_until b_pmp_alpha_enroute)
	(md_set_jun_dropship_more_inbound)
	(mus_start mus_07)
	(f_callout_object (ai_vehicle_get sq_cov_pmp_alpha_ds/pilot) blip_hostile_vehicle)
)

(script static void md_pmp_jun_another_dropship
	(md_start)
	
		(md_print "JUN: Another dropship coming in!")
		(md_ai_play 0 ai_jun m30_0510)
		
	(md_stop)
)

(script static void md_pmp_jun_dropship_got_company
	(md_start)
	
		(md_print "JUN: We got company!")
		(md_ai_play 0 ai_jun m30_1050)
		
	(md_stop)
)

(script static void md_set_jun_dropship_more_inbound
	(md_start)
	
		(md_print "JUN: More inbound!")
		(md_ai_play 0 ai_jun m30_1060)
		
	(md_stop)
)



(script static void md_pmp_kill_stash_dialogue
	(if debug (print "pmp: killing a stash dialogue script..."))
	(set b_pmp_stash_convo_active false)
	(set b_pmp_stash_convo_completed true)
	(set b_pmp_assault_start_dropships true)
	(md_stop)
	(sleep 60)
)

(script dormant pmp_callout_stash
	(f_callout_object dm_pmp_stash0 blip_ordnance)
	(f_callout_object dm_pmp_stash1 blip_ordnance)
)

;*
(script static void md_pmp_cv2_little_more_action
	(branch
		(= b_pmp_player_skips_encounter true) (md_pmp_kill_dialogue))
		
	(md_start)
	
		(md_print "CIVILIAN 2: Little more action than we're used to. You Spartans are good in a fight.")
		;(md_ai_play 0 ai_cv2 m30_0600)
		(md_object_play 0 NONE m30_0600)
		
		(md_print "JUN: What are you doing here? Whole area's supposed to be evacuated.")
		(md_ai_play 0 ai_jun m30_0610)
		
		(md_print "CIVILIAN 2: Didn't like leaving it to someone else to protect our home.")
		;(md_ai_play 0 ai_cv2 m30_0620)
		(md_object_play 0 NONE m30_0620)
		
		(md_print "CIVILIAN 2: So we came back... for this.")
		;(md_ai_play 0 ai_cv2 m30_0630)
		(md_object_play 0 NONE m30_0630)
		
				; -------------------------------------------------
				;(device_set_power dm_pmp_stash0 1)
				;(device_set_power dm_pmp_stash1 1)
				(device_set_position dm_pmp_stash0 1)
				(device_set_position dm_pmp_stash1 1)
				
				(f_callout_object dm_pmp_stash0 blip_ordnance)
				(f_callout_object dm_pmp_stash1 blip_ordnance)
				; -------------------------------------------------
		
		(md_print "CIVILIAN 2: We have them hidden all over the territory.")
		;(md_ai_play 0 ai_cv2 m30_0640)
		(md_object_play 0 NONE m30_0640)
		
		(md_print "JUN: You know this stuff is stolen.")
		(md_ai_play 0 ai_jun m30_0650)
		
		(md_print "CIVILIAN 2: You going to arrest me?")
		;(md_ai_play 0 ai_cv2 m30_0660)
		(md_object_play 0 NONE m30_0660)
		
		(md_print "JUN: No. Gonna steal it back.")
		(md_ai_play 0 ai_jun m30_0670)
		
		;(md_print "JUN: Noble Six, take whatever you like.")
		;(md_ai_play 0 ai_jun m30_0680)
		
		(md_print "JUN: As for you, fall in. We're heading into the dark zone -- and you're our new tour guide.")
		(md_ai_play 0 ai_jun m30_0690)
		
		(set b_pmp_move_to_river true)
		
		;(fireteam_setup)
		;(ai_set_fireteam_absorber sq_unsc_pmp_militia0 true)
		;(ai_set_fireteam_absorber sq_unsc_pmp_militia1 true)
		;(ai_set_fireteam_absorber sq_unsc_pmp_militia2 true)
		
		;(ai_set_objective fireteam_player0 obj_unsc_pmp)
		;(ai_migrate sq_unsc_pmp_militia0 fireteam_player0)
		;(fireteam_setup)
		
	(md_stop)
)
*;

(global boolean b_pmp_post_convo_active false)
(global boolean b_pmp_post_convo_completed false)
(global boolean b_pmp_post_convo_goto_river false)
(script dormant md_pmp_jun_hydro_civs_alive
	(md_start)
	
		
		
		(vs_cast gr_militia true 10 m30_0710)
		(set ai_civilian2 (vs_role 1))
		
		(branch
			(or
				(= b_pmp_player_skips_encounter true)
				(<= (object_get_health (ai_get_object ai_civilian2)) 0)
				(angry_halo)
			)	
					; -------------------------------------------------
					(pmp_postcombat_abort)
					; -------------------------------------------------
		)
		
		
		
		(md_print "JUN: Nothing here but that lake.")
		(md_ai_play 30 ai_jun m30_0700)

		(md_print "CIVILIAN 2: Road leads to a hydroelectric plant, but the gate doesn't work.")
		(md_ai_play 25 ai_civilian2 m30_0710)
		
		(md_print "JUN: Alternate route?")
		(md_ai_play 15 ai_jun m30_0720)
		
		(md_print "CIVILIAN 2: We use the riverbed to smuggle rations, weapons...")
		(md_ai_play 10 ai_civilian2 m30_0730)
		
		(md_print "JUN: Basically, anything the UNSC considers contraband.")
		(md_ai_play 35 ai_jun m30_0740)
		
		(md_print "CIVILIAN 2: Basically.")
		(md_ai_play 35 ai_civilian2 m30_0750)
		
		(md_print "JUN: Show us.")
		(md_ai_play 30 ai_jun m30_0760)
		
		(fireteam_setup)
		
		(set b_pmp_post_convo_goto_river true)
		
		(ai_set_fireteam_absorber sq_unsc_pmp_militia0 true)
		(ai_set_fireteam_absorber sq_unsc_pmp_militia1 true)
		(ai_set_fireteam_absorber sq_unsc_pmp_militia2 true)
		(ai_set_objective fireteam_player0 obj_unsc_pmp)
		
		(wake md_pmp_jun_theres_the_riverbed)
		
		(set b_pmp_post_convo_completed true)
		(set b_pmp_post_convo_active false)
	
	(md_stop)
	
	(game_save)
)


(script command_script cs_pmp_post_convo_mil0
	(cs_push_stance alert)
	(cs_go_to pts_thespian_pmp_postencounter/mil0_dest)
	(cs_face_object true (ai_get_object ai_jun))
	(cs_look_object true (ai_get_object ai_jun))
	
	(sleep_until 
		(or 
			b_pmp_post_convo_completed
			(volume_test_players tv_pmp_players_move_to_exit)
		)
	)
	
	
)

(script command_script cs_pmp_post_convo_mil1
	(cs_push_stance alert)
	(cs_go_to pts_thespian_pmp_postencounter/mil1_dest)
	(cs_face_object true (ai_get_object ai_jun))
	(cs_look_object true (ai_get_object ai_jun))
	
	(sleep_until 
		(or 
			b_pmp_post_convo_completed
			(volume_test_players tv_pmp_players_move_to_exit)
		)
	)
)

(script command_script cs_pmp_post_convo_mil2
	(cs_push_stance alert)
	(cs_go_to pts_thespian_pmp_postencounter/mil2_dest)
	(cs_face_object true (ai_get_object ai_jun))
	(cs_look_object true (ai_get_object ai_jun))
	
	(sleep_until 
		(or 
			b_pmp_post_convo_completed
			(volume_test_players tv_pmp_players_move_to_exit)
		)
	)
)

(script command_script cs_pmp_post_convo_mil3
	(cs_push_stance alert)
	(cs_go_to pts_thespian_pmp_postencounter/mil3_dest)
	(cs_face_object true (ai_get_object ai_jun))
	(cs_look_object true (ai_get_object ai_jun))
	
	(sleep_until 
		(or 
			b_pmp_post_convo_completed
			(volume_test_players tv_pmp_players_move_to_exit)
		)
	)
)

(script command_script cs_pmp_post_convo_jun
	(cs_push_stance alert)
	(cs_go_to pts_thespian_pmp_postencounter/jun_dest)
	(cs_face true pts_thespian_pmp_postencounter/jun_face)
	
	(sleep_until 
		(or 
			b_pmp_post_convo_completed
			(volume_test_players tv_pmp_players_move_to_exit)
		)
	)
)

(script command_script cs_pmp_post_convo_jun_nomilitia
	(cs_push_stance alert)
	(cs_go_to pts_thespian_pmp_postencounter/jun_dest_nomilitia)
	(cs_face true pts_thespian_pmp_postencounter/jun_face_nomilitia)
	(cs_look true pts_thespian_pmp_postencounter/jun_face_nomilitia)
	
	(sleep_until 
		(or 
			b_pmp_post_convo_completed
			(volume_test_players tv_pmp_players_move_to_exit)
		)
	)
)

(script static void md_pmp_jun_hydro_civs_dead
	(branch	(= b_pmp_player_skips_encounter true) (md_pmp_postcombat_abort))
	
	(set b_pmp_post_convo_goto_river true)
	
	(md_start)
	
		(md_print "JUN: No movement. Nothing else alive, human OR Covenant.")
		(md_ai_play 90 ai_jun m30_0570)
	
		(md_print "JUN: Nothing here but that lake... Kat, where we going?")
		(md_ai_play 0 ai_jun m30_0810)
		
		(md_print "KAT: Should be a hydroelectric plant nearby.")
		(md_object_play 30 NONE m30_0820)
		
		(md_print "JUN: Front gate looks locked... is there another way in?")
		(md_ai_play 15 ai_jun m30_0830)
		
		(md_print "KAT: Stand by; I'll check with Recon Alpha.")
		(md_object_play (* 30 6) NONE m30_0840)
		
		(md_print "KAT: Jorge said settlers dammed a nearby river. Was a few years back. Dry riverbed might be your best route.")
		(md_object_play 30 NONE m30_0850)
		
		(md_print "JUN: Copy, thanks.")
		(md_ai_play 10 ai_jun m30_0860)
	
	(md_stop)
	
	(set b_pmp_post_convo_completed true)
	(set b_pmp_post_convo_active false)
	(set b_pmp_move_to_river true)
	(game_save)
	
	(wake pmp_exit_reminder)
	(wake md_pmp_jun_theres_the_riverbed)
)

(script static void md_pmp_postcombat_abort
	(set b_pmp_post_convo_completed true)
)

(script dormant md_pmp_jun_theres_the_riverbed
	(branch
		(= b_rvr_started true) (md_abort))
	
	(sleep_until (volume_test_object tv_rvr_jun_reaches_riverbed (ai_get_object ai_jun)))
	
	(if	(not (= b_rvr_started true))
		
		;(and
			
			;(not (volume_test_players tv_rvr_jun_reaches_riverbed))
		;)
		
		(begin
			(md_start)
					
				(md_print "JUN: There's the riverbed, Six. Let's see where it goes.")
				(md_ai_play 30 ai_jun m30_0870)
				
			(md_stop)
			
			(if 
				(and
					(not (= b_rvr_started true))
					(not (volume_test_players tv_rvr_jun_reaches_riverbed))
				)
			
					(f_blip_flag fl_rvr_entrance 21)
			)
		)
	)
)


; -------------------------------------------------------------------------------------------------
; RIVER
; -------------------------------------------------------------------------------------------------
(script dormant md_rvr_jun_where_does_riverbed_lead
	(md_start)
	
		(vs_cast gr_militia true 10 m30_0780)
		(set ai_civilian2 (vs_role 1))
		
		(branch
			(or
				(= b_pmp_player_skips_encounter true)
				(<= (object_get_health (ai_get_object ai_civilian2)) 0)
			)	
					; -------------------------------------------------
					(md_pmp_kill_dialogue)
					; -------------------------------------------------
		)
		
		(md_print "JUN: Where does this riverbed lead?")
		(md_ai_play 20 ai_jun m30_0770)
		
		(md_print "CIVILIAN 2: Straight to the hydro plant. We dammed this river up 45 years ago. Plant powers every settlement in the territory.")
		(md_ai_play 15 ai_civilian2 m30_0780)
		
		(md_print "CIVILIAN 2: Shame if it all gets wasted.")
		(md_ai_play 40 ai_civilian2 m30_0790)
		
		(md_print "JUN: Doing what we can.")
		(md_ai_play 0 ai_jun m30_0800)
	
	(md_stop)
)

(script dormant md_rvr_jun_settlement_history	
	(if 
		(and 
			(> (ai_living_count gr_militia) 0)
			(> (ai_task_count obj_unsc_rvr/gate_militia) 0))
		(wake md_rvr_jun_where_does_riverbed_lead))
)


; -------------------------------------------------------------------------------------------------
; SETTLEMENT
; -------------------------------------------------------------------------------------------------
(script dormant md_set_jun_kat_you_seeing

	(sleep_until
		(or
			(volume_test_object tv_set_jun_sees_pylon (ai_get_object ai_jun))
			(>= s_objcon_set 10)
		)
	)
	
	(ai_dialogue_enable false)
	(sleep 60)
	

	(md_start)
	
		(md_print "JUN: Kat, are you seeing this")
		(md_ai_play 40 ai_jun m30_0940)
		
		;(wake set_hud_flash_pylon)
	
		;(md_print "KAT: I'm not seeing anything but static.")
		;(md_object_play 0 NONE m30_0950)
		
		(md_print "JUN: Covenant structure. Some kind of big pylon -- heavily fortified.")
		(md_ai_play 25 ai_jun m30_0960)
		
		(md_print "KAT: That's the source of our dark zone.")
		(md_object_play 15 NONE m30_0970)
		
		(set b_set_unsc_advance true)
		
		(md_print "JUN: Okay. Consider it gone...")
		(md_ai_play 0 ai_jun m30_0980)
		
		(md_print "KAT: Negative. Stick a remote det charge on it. Command is planning something big. They say the pylon dies at dawn.")
		(md_object_play 0 NONE m30_0990)
		
		;(md_print "JUN: Interesting... Noble 3 out.")
		;(md_ai_play 0 ai_jun m30_1000)
			
	(md_stop)
	
	(if (and 
			(> (ai_living_count gr_militia) 0)
			(<= (ai_combat_status gr_cov_set) 2)) 
		(md_set_cv2_we_gonna_blow_it))
	
	(wake set_save_postintro)
		
	;(new_mission_objective ct_primary_objective_6 PRIMARY_OBJECTIVE_6)
	(wake show_objective_6)
	(mus_stop mus_08)
	
)

(script static void md_set_cv2_we_gonna_blow_it
	(sleep 90)
	
	(md_start)
	
		(vs_cast gr_militia FALSE 10 m30_1010)
		(set ai_civilian2 (vs_role 1))
	
		(md_print "CIVILIAN 2: We gonna blow it?")
		(md_ai_play 30 ai_civilian2 m30_1010)
		
		(md_print "JUN: We're gonna clear the area, then I'm gonna plant a remote det-charge. You wanna provide some cover, go right ahead.")
		(md_ai_play 0 ai_jun m30_1020)
		
	(md_stop)
	
)

(script dormant set_save_postintro
	(game_save_no_timeout))

(script static void md_set_jun_cover_me
	(md_start)
		
		(md_print "JUN: All clear, Six. Cover me while I plant the charge.")
		(md_ai_play 30 ai_jun m30_1030)
		
		(md_print "JUN: This is gonna take a minute. Keep your eyes peeled!")
		(md_ai_play 0 ai_jun m30_1040)
		
		;(new_mission_objective ct_primary_objective_7 PRIMARY_OBJECTIVE_7)
		(wake show_objective_7)
		(mus_start mus_09)
		
	(md_stop)
)

(script dormant md_set_jun_dropship_callout_1
	(md_start)
	
		(md_print "JUN: We got company!")
		(md_ai_play 0 ai_jun m30_1050)
		
	(md_stop)
)

(script dormant md_set_jun_dropship_callout_2
	(md_start)
	
		(md_print "JUN: More inbound!")
		(md_ai_play 0 ai_jun m30_1060)
		
	(md_stop)
)

(script dormant md_set_jun_dropship_callout_3
	(md_start)
	
		(md_print "JUN: Here they come!")
		(md_ai_play 0 ai_jun m30_1070)
		
	(md_stop)
)

(script dormant md_set_jun_dropship_callout_4
	(md_start)
	
		(md_print "JUN: Fun never ends!")
		(md_ai_play 0 ai_jun m30_1080)
		
	(md_stop)
)

(script dormant md_set_jun_dropship_callout_5
	(md_start)
	
		(md_print "JUN: Coveys inbound!")
		(md_ai_play 0 ai_jun m30_1090)
		
	(md_stop)
)

(script dormant md_set_jun_still_working_1
	(md_start)

		(md_print "JUN: Keep me covered...")
		(md_ai_play 0 ai_jun m30_1100)
	
	(md_stop)
)

(script dormant md_set_jun_still_working_2
	(md_start)

		(md_print "JUN: Still working...")
		(md_ai_play 0 ai_jun m30_1110)
	
	(md_stop)
)

(script dormant md_set_jun_still_working_3
	(md_start)

		(md_print "JUN: Need a little more time...")
		(md_ai_play 0 ai_jun m30_1120)
	
	(md_stop)
)

(script dormant md_set_jun_still_working_4
	(md_start)

		(md_print "JUN: Almost finished...")
		(md_ai_play 0 ai_jun m30_1130)
	
	(md_stop)
)

(script dormant md_set_jun_finished
	(md_start)

		(md_print "JUN: Done! Charge planted!")
		(md_ai_play 0 ai_jun m30_1140)
	
	(md_stop)
)

(script static void md_set_jun_charge_placed
	(md_start)
	
		(md_print "JUN: Recon Bravo to Noble 2, charge placed.")
		(md_ai_play 15 ai_jun m30_1150)
		
		(md_print "KAT: Somewhere inconspicuous, I hope.")
		(md_object_play 10 NONE m30_1160)
		
		(md_print "JUN: Stuck it inside the pylon's power supply. They'll never know it's there.")
		(md_ai_play 35 ai_jun m30_1170)
		
		(md_print "KAT: All right, keep pushing into the dark zone. Command wants to know what the Covenant are hiding.")
		(md_object_play 0 NONE m30_1180)
		
		;(new_mission_objective ct_primary_objective_8 PRIMARY_OBJECTIVE_8)
		(wake show_objective_8)
		
	(md_stop)
)


; -------------------------------------------------------------------------------------------------
; CLIFFSIDE
; -------------------------------------------------------------------------------------------------
(script static void md_clf_jun_gate
	(md_start)
	
		(md_print "JUN: There's a gate to the southeast of the hydro plant.")
		(md_ai_play 0 ai_jun m30_1190)
		
		(f_blip_flag fl_clf_gate blip_recon)
		
		(md_print "KAT: Copy. Uploading security codes to you now.")
		(md_object_play 0 NONE m30_1200)
		
		(mus_stop mus_09)
		(mus_start mus_10)
		
		;(sleep_until (volume_test_players tv_clf_gate) 30 (* 30 45))
		
	
	(md_stop)
	
	
	
	
)

(script dormant md_clf_jun_opens_gate
	(sleep 30)
	
	(md_start)
		
		(f_unblip_flag fl_clf_gate)
		
		(md_print "JUN: Okay, got 'em. Unlocking the gate...")
		(md_ai_play 0 ai_jun m30_1210)
		
	(md_stop)
	
	(md_clf_kat_gate_open)
)	

(script static void md_clf_kat_gate_open
	(md_start)
		
		(md_print "KAT: Recon Bravo, you're heading into the dark zone now.")
		(md_object_play 0 NONE m30_1220)
		
		(md_print "JUN: Understood.")
		(md_ai_play 0 ai_jun m30_1230)
	
	(md_stop)
)

(script dormant md_clf_jun_phantom_too_close
	(md_start)
	
		(md_print "JUN: Phantom! Little too close for comfort!")
		(md_ai_play 0 ai_jun m30_1240)
	
	(md_stop)
)

(script dormant md_clf_jun_shade
	(md_start)

		(if (> (ai_living_count sq_cov_clf_center_shade0) 0)
			(begin
				(md_print "JUN: Shade! Fire and maneuver, Six! Hit'em from the side!")
				(md_ai_play 0 ai_jun m30_1250)
			)
		)
	
	(md_stop)
	
	(mus_stop mus_10)
	(mus_start mus_11)
)

(script dormant md_clf_jun_beckon_1
	(md_start)
	
		(md_print "JUN: Come on, Six!")
		(md_ai_play 0 ai_jun m30_1260)
		
	(md_stop)
)

(script dormant md_clf_jun_beckon_2
	(md_start)
	
		(md_print "JUN: Noble Six, on me!")
		(md_ai_play 0 ai_jun m30_1270)
		
	(md_stop)
)

(script dormant md_clf_jun_beckon_3
	(md_start)
	
		(md_print "JUN: Stay with me, Lieutenant!")
		(md_ai_play 0 ai_jun m30_1280)
		
	(md_stop)
)

(script dormant md_clf_jun_lotta_air_traffic
	(sleep_until 
		(or
			(<= (ai_living_count gr_cov_clf_center) 0)
			(>= s_objcon_clf 110)
		)
	)
	
	(wake clf_airtraffic_control)
	(sleep (random_range 150 210))
	(md_start)
	
		(md_print "JUN: Lotta air traffic around here, Six. I think we're getting warm.")
		(md_ai_play 0 ai_jun m30_1290)
		
	(md_stop)
)

(script dormant md_clf_jun_eyes_on_capital_ship
	(if (> (ai_living_count gr_cov_clf) 0)
		(wake md_clf_jun_eyes_on_combat)
		(wake md_clf_jun_eyes_on_postcombat))
)

(script dormant md_clf_jun_eyes_on_postcombat
	(md_start)
	
		(md_print "JUN: Noble 2, we have eyes on at least one Covenant ship...")
		(md_ai_play 0 ai_jun m30_1300)
		
		(md_clf_kat_solid_copy)
	
	(md_stop)		
)

(script dormant md_clf_jun_eyes_on_combat
	(md_start)
	
		(md_print "JUN: Noble 2, we have eyes on at least one Covenant ship...")
		(md_ai_play 0 ai_jun m30_1310)
		
		(md_clf_kat_solid_copy)
	
	(md_stop)	
)	

(script static void md_clf_kat_solid_copy
	(md_print "KAT: Solid copy. Don't stop now.")
	(md_object_play 0 NONE m30_1320)
)

(script static void md_clf_jun_cave_ahead
	(md_start)
	
		(md_print "JUN: Cave ahead. Good cover, better view. Meet you inside.")
		(md_ai_play 0 ai_jun m30_1320)
	
	(md_stop)
)


; -------------------------------------------------------------------------------------------------
; WEATHER
; -------------------------------------------------------------------------------------------------
(global boolean b_weather_debug				false)
(global boolean b_rain_is_active 			false)
(global boolean b_rain_thunderclap			false)
(global boolean b_rain_always_on			false)
(global boolean b_rain_change_state			false)
(global short s_rain_min_on_time 			60)
(global short s_rain_max_on_time 			180)
(global short s_rain_min_off_time 			30)
(global short s_rain_max_off_time 			45)
(global short s_rain_min_ramp_up_time 		2)
(global short s_rain_max_ramp_up_time 		10)
(global short s_rain_min_ramp_down_time 	6)
(global short s_rain_max_ramp_down_time 	12)
(global short s_rain_min_lightning_delay 	5)
(global short s_rain_max_lightning_delay 	20)
(global short s_rain_min_thunder_delay 		1)
(global short s_rain_max_thunder_delay 		3)
(global real r_rain_min_force				1)
(global real r_rain_max_force				1)

(global ai ai_to_deafen NONE)
; -------------------------------------------------------------------------------------------------
(script static void weather_set_theme_default
	(if debug (print "weather: default theme starting"))
	(set b_rain_thunderclap			false)
	(set s_rain_min_on_time 		60)
	(set s_rain_max_on_time 		180)
	(set s_rain_min_off_time 		30)
	(set s_rain_max_off_time 		45)
	(set s_rain_min_ramp_up_time 	2)
	(set s_rain_max_ramp_up_time 	10)
	(set s_rain_min_ramp_down_time 	6)
	(set s_rain_max_ramp_down_time 	12)
	(set s_rain_min_lightning_delay 5)
	(set s_rain_max_lightning_delay 20)
	(set s_rain_min_thunder_delay 	1)
	(set s_rain_max_thunder_delay 	3)
	(set r_rain_min_force			1)
	(set r_rain_max_force			1)
)

(script static void weather_set_theme_storm
	(if debug (print "weather: storm theme starting"))
	(set b_rain_thunderclap			true)
	(set s_rain_min_on_time 		300)
	(set s_rain_max_on_time 		600)
	(set s_rain_min_off_time 		60)
	(set s_rain_max_off_time 		120)
	(set s_rain_min_ramp_up_time 	15)
	(set s_rain_max_ramp_up_time 	45)
	(set s_rain_min_ramp_down_time 	50)
	(set s_rain_max_ramp_down_time 	120)
	(set s_rain_min_lightning_delay 3)
	(set s_rain_max_lightning_delay 15)
	(set s_rain_min_thunder_delay 	1)
	(set s_rain_max_thunder_delay 	2)
	(set r_rain_min_force			1)
	(set r_rain_max_force			1)
)

(script static void weather_set_theme_light
	(if debug (print "weather: light rain theme starting"))
	(set b_rain_thunderclap			false)
	(set s_rain_min_on_time 		80)
	(set s_rain_max_on_time 		180)
	(set s_rain_min_off_time 		120)
	(set s_rain_max_off_time 		120)
	(set s_rain_min_ramp_up_time 	15)
	(set s_rain_max_ramp_up_time 	45)
	(set s_rain_min_ramp_down_time 	50)
	(set s_rain_max_ramp_down_time 	80)
	(set s_rain_min_lightning_delay 20)
	(set s_rain_max_lightning_delay 45)
	(set s_rain_min_thunder_delay 	3)
	(set s_rain_max_thunder_delay 	6)
	(set r_rain_min_force			0.2)
	(set r_rain_max_force			0.6)
)

; -------------------------------------------------------------------------------------------------

(script startup weather_rain
	(weather_animate_force off 1 0)
	(sleep_until
		(begin
			(sleep_range_seconds s_rain_min_off_time s_rain_max_off_time)
			(weather_rain_start)
			(sleep_range_seconds s_rain_min_on_time s_rain_max_on_time)
			(weather_rain_stop)
		0)
	1)
)

(script static void weather_rain_start
	(if b_weather_debug (print "weather: rain starting..."))
	(weather_animate_force 
		light_rain 
		(real_random_range r_rain_min_force r_rain_max_force)
		(random_range s_rain_min_ramp_up_time s_rain_max_ramp_up_time)
	)
	(set b_rain_is_active true)
)

(script static void weather_rain_stop
	(if b_weather_debug (print "weather: rain stopping..."))
	(weather_animate_force off 1 (random_range s_rain_min_ramp_down_time s_rain_max_ramp_down_time))
	(set b_rain_is_active false)
)

(script startup weather_lightning
	(branch 
		(= b_mission_complete true) (branch_abort)
	)
	
	(weather_lightning_flash)
	(sleep_until (= b_ovr_started true))
	(sleep_until
		(begin
			(sleep_range_seconds s_rain_min_lightning_delay s_rain_max_lightning_delay)
			(weather_lightning_flash)
			;*
			(if b_rain_is_active
				(sleep_range_seconds s_rain_min_thunder_delay s_rain_max_thunder_delay)
				(sleep_range_seconds (* 3 s_rain_min_thunder_delay) (* 3 s_rain_max_thunder_delay)))
			*;
			(sleep_range_seconds s_rain_min_thunder_delay s_rain_max_thunder_delay)
			(weather_thunder_clap)
		0)
	60)
)

(script static void weather_lightning_flash
	(if b_weather_debug (print "weather: flash!"))
	(interpolator_start lightning))
	
(script static void weather_thunder_clap
	(if b_rain_thunderclap
		(begin
			(if b_weather_debug (print "weather: thunder clap!"))
			(sound_impulse_start sound\levels\solo\weather\thunder_claps.sound NONE 1)
			(ai_thunder_deafen ai_to_deafen true)
			(sleep (* 30 2.5))
			(ai_thunder_deafen ai_to_deafen false)
		)	
		(begin
			(if b_weather_debug (print "weather: rolling thunder..."))		
			(sound_impulse_start sound\levels\solo\weather\rain\details\thunder.sound NONE 1)
		)
	)
)

(script static void (ai_thunder_deafen (ai actors) (boolean deafen))
	(if deafen
		(begin
			(if (< (ai_combat_status actors) 4)
				(begin
					(if b_weather_debug (print "deafening the ai..."))
					(ai_set_blind actors true)
					(ai_set_deaf actors true)))
		)
		
		(begin
			(if b_weather_debug (print "ai now have their vision and hearing again..."))
			(ai_set_blind actors false)
			(ai_set_deaf actors false)
		)
	)
)

(script static void (sleep_range_seconds (short minsleep) (short maxsleep))
	(sleep (random_range (* 30 minsleep) (* 30 maxsleep))))
	

; BODIES
; -------------------------------------------------------------------------------------------------
(global short pose_against_wall_var1 	0)
(global short pose_against_wall_var2 	1)
(global short pose_against_wall_var3	2)
(global short pose_against_wall_var4 	3)
(global short pose_on_back_var1 		4)
(global short pose_on_back_var2			5)
(global short pose_on_side_var1			6)
(global short pose_on_side_var2			7)
(global short pose_on_back_var3			8)
(global short pose_face_down_var1		9)
(global short pose_face_down_var2		10)
(global short pose_on_side_var3			11)
(global short pose_on_side_var4			12)
(global short pose_face_down_var3		13)
(global short pose_on_side_var5			14)


(script static void (pose_body (object_name body_name) (short pose))
	(object_create body_name)
	(cond
		((= pose pose_against_wall_var1) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_01))
		((= pose pose_against_wall_var2) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_02))
		((= pose pose_against_wall_var3) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_03))
		((= pose pose_against_wall_var4) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_04))
		((= pose pose_on_back_var1) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_05))
		((= pose pose_on_back_var2) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_06))
		((= pose pose_on_side_var1) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_07))
		((= pose pose_on_side_var2) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_08))
		((= pose pose_on_back_var3) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_09))
		((= pose pose_face_down_var1) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_10))
		((= pose pose_face_down_var2) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_11))
		((= pose pose_on_side_var3) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_12))
		((= pose pose_on_side_var4) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_13))
		((= pose pose_face_down_var3) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_14))
		((= pose pose_on_side_var5) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_15))
	)		
)



;*
(script static void slo_setup_bodies
	(object_create_folder sc_slo_bodies)
	(scenery_animation_start body2 objects\characters\marine\marine e3_deadbody_02)
	(scenery_animation_start body3 objects\characters\marine\marine e3_deadbody_03)
	(scenery_animation_start body4 objects\characters\marine\marine e3_deadbody_04)
	(scenery_animation_start body5 objects\characters\marine\marine e3_deadbody_05)
	(scenery_animation_start body6 objects\characters\marine\marine e3_deadbody_06)
	(scenery_animation_start body7 objects\characters\marine\marine e3_deadbody_07)
	(scenery_animation_start body8 objects\characters\marine\marine e3_deadbody_08)
	(scenery_animation_start body9 objects\characters\marine\marine e3_deadbody_09)
	(scenery_animation_start body10 objects\characters\marine\marine e3_deadbody_10)
	(scenery_animation_start body11 objects\characters\marine\marine e3_deadbody_11)
	(scenery_animation_start body12 objects\characters\marine\marine e3_deadbody_12)
	(scenery_animation_start body13 objects\characters\marine\marine e3_deadbody_13)
	(scenery_animation_start body14 objects\characters\marine\marine e3_deadbody_14)
	(scenery_animation_start body15 objects\characters\marine\marine e3_deadbody_15)
	(scenery_animation_start body16 objects\characters\marine\marine e3_deadbody_16)
	(scenery_animation_start body17 objects\characters\marine\marine e3_deadbody_17)
	(scenery_animation_start body18 objects\characters\marine\marine e3_deadbody_18)
	(scenery_animation_start body19 objects\characters\marine\marine e3_deadbody_19)
	(scenery_animation_start body20 objects\characters\marine\marine e3_deadbody_20)
)
*;