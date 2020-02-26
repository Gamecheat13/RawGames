;========== GLOBALS =========================================================================================
(global boolean debug 1)
(global boolean dialogue 1)
(global boolean g_play_cinematics 1)

(global short g_sleep_lower_bound 60)
(global short g_sleep_upper_bound 80)
(global short g_emitter_delay 180)

(global boolean g_cons_open_ins 0)

(global boolean g_enc_insertion 0)
(global boolean g_hall_a 0)
(global boolean g_conduit_a 0)
(global boolean g_hall_b 0)
(global boolean g_plug_launch 0)
(global boolean g_plug_landing 0)
(global boolean g_hall_c 0)
(global boolean g_ledge_a 0)
(global boolean g_conduit_b 0)
(global boolean g_ledge_b 0)
(global boolean g_ledge_c 0)
(global boolean g_qz_initial 0)
(global boolean g_cov_defense 0)

; cinematic stub scripts  
(script stub void x06 (print "x06"))
(script stub void C06_intro (print "C06_intro"))

(script dormant difficulty_settings
	(cond
		((difficulty_heroic)	(begin
								(set g_sleep_lower_bound 45)
								(set g_sleep_upper_bound 65)
								(set g_emitter_delay 120)
							)
		)
		((difficulty_legendary)	(begin
								(set g_sleep_lower_bound 25)
								(set g_sleep_upper_bound 45)
								(set g_emitter_delay 60)
							)
		)
	)
)

(script static void test_locks
	(device_set_position_immediate plug 1)
	(device_set_position plug_lock_a 1)
	(device_set_position plug_lock_b 1)
	(device_set_position plug_lock_c 1)
	(device_set_position plug_lock_d 1)
	(device_set_position plug_lock_e 1)
	(device_set_position plug_lock_f 1)
	(device_set_position plug_door_b 1)
)

(script command_script die
	(ai_kill_silent ai_current_squad)
)

(script dormant ice_cream_mythic
	(object_create ice_cream_head)
	
	(sleep_until 
		(or
                (unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
                (unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
		)
	5)
	
	(if debug (print "you're going to get fat!!!!! or dead..."))
	(if debug (print "because now everyone is mythic!!!!"))
	(ice_cream_flavor_stock 12)
)

;= CHAPTER TITLES ========================================================================

(script dormant chapter_silence
	(sleep 30)
	(cinematic_set_title title_1)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)

(script dormant chapter_remorse
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title_2)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)

(script dormant chapter_war
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title_3)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)

;= OBJECTIVES ============================================================================

(script dormant objective_lower_set
	(sleep 30)
	(print "new objective set:")
	(print "Lower the Containment-Shield.")
	(objectives_show_up_to 0)
)

(script dormant objective_lower_clear
	(print "objective complete:")
	(print "Lower the Containment-Shield.")
;	(objectives_finish_up_to 0)  commented out so that both get checked off at the same time BUG: 27421 
)
(script dormant objective_lower_specific_set
	(sleep 30)
	(print "new objective set:")
	(print "Power-up the four Absorbers to lower the Containment-Shield.")
	(objectives_show_up_to 1)
)

(script dormant objective_lower_specific_clear
	(print "objective complete:")
	(print "Power-up the four Absorbers to lower the Containment-Shield.")
	(objectives_finish_up_to 1)
)

(script dormant objective_floodwall_set
	(sleep 30)
	(print "new objective set:")
	(print "Make your way through the Flood-infested Wall.")
	(objectives_show_up_to 2)
)

(script dormant objective_floodwall_clear
	(print "objective complete:")
	(print "Make your way through the Flood-infested Wall.")
	(objectives_finish_up_to 2)
)

(script dormant objective_rendezvous_set
	(sleep 30)
	(print "new objective set:")
	(print "Rendezvous with your allies in the Covenant camp.")
	(objectives_show_up_to 3)
)

(script dormant objective_rendezvous_clear
	(print "objective complete:")
	(print "Rendezvous with your allies in the Covenant camp.")
	(objectives_finish_up_to 3)
)

;(script dormant training_absorber
;	(hud_set_training_text training_absorber)
;	(hud_show_training_text 1)
	
;	(sleep_until (>= (device_get_position piston_ins) 0))
;	(sleep 15)
;	(hud_show_training_text 0)
;)

; =====  !!!! MUSIC !!!! ===========================================================================
;(global boolean g_music_06a_01 1)
;(global boolean g_music_06a_02 0)
(global boolean g_music_06a_03 0)
(global boolean g_music_06a_04 0)
(global boolean g_music_06a_05 0)
(global boolean g_music_06a_06 0)
(global boolean g_music_06a_07 0)
(global boolean g_music_06a_08 1)
(global boolean g_music_06a_09 0)
(global boolean g_music_06a_10 1)

(script dormant music_06a_01
	(sleep_until (volume_test_objects tv_insertion_tube (players)) 1)
	(if debug (print "start music 06a_01"))
	(sound_looping_start scenarios\solo\06a_sentinelwalls\06a_music\06a_01 none 1)
	(sleep 30)
	(if debug (print "start music 06a_02"))
	(sound_looping_start scenarios\solo\06a_sentinelwalls\06a_music\06a_02 none 1)

	(sleep_until (volume_test_objects tv_ins_slide_bottom (players)))
	(if debug (print "stop music 06a_01"))
	(sound_looping_stop scenarios\solo\06a_sentinelwalls\06a_music\06a_01)
)
	
(script dormant music_06a_03
	(sleep_until g_music_06a_03 1)
	(if debug (print "start music 06a_03"))
	(sound_looping_start scenarios\solo\06a_sentinelwalls\06a_music\06a_03 none 1)

	(sleep_until (not g_music_06a_03))
	(if debug (print "stop music 06a_03"))
	(sound_looping_stop scenarios\solo\06a_sentinelwalls\06a_music\06a_03)
)

(script dormant music_06a_04
	(sleep_until g_music_06a_04)
	(if debug (print "start music 06a_04"))
	(sound_looping_start scenarios\solo\06a_sentinelwalls\06a_music\06a_04 none 1)

	(sleep_until (not g_music_06a_04))
	(if debug (print "stop music 06a_04"))
	(sound_looping_stop scenarios\solo\06a_sentinelwalls\06a_music\06a_04)
)

(script dormant music_06a_05
	(sleep_until g_music_06a_05)
	(if debug (print "start music 06a_05"))
	(sound_looping_start scenarios\solo\06a_sentinelwalls\06a_music\06a_05 none 1)
	
	
	(sleep_until (not g_music_06a_05))
	(if debug (print "stop music 06a_05"))
	(sound_looping_stop scenarios\solo\06a_sentinelwalls\06a_music\06a_05)
)

(script dormant music_06a_06
	(sleep_until g_music_06a_06)
	(if debug (print "start music 06a_06"))
	(sound_looping_start scenarios\solo\06a_sentinelwalls\06a_music\06a_06 none 1)
	
	
	(sleep_until (not g_music_06a_06))
	(if debug (print "stop music 06a_06"))
	(sound_looping_stop scenarios\solo\06a_sentinelwalls\06a_music\06a_06)
)

(script dormant music_06a_07
	(sleep_until g_music_06a_07)
	(if debug (print "start music 06a_07"))
	(sound_looping_start scenarios\solo\06a_sentinelwalls\06a_music\06a_07 none 1)
	
	
	(sleep_until (not g_music_06a_07))
	(if debug (print "stop music 06a_07"))
	(sound_looping_stop scenarios\solo\06a_sentinelwalls\06a_music\06a_07)
)

(script dormant music_06a_08
	(sleep_until (volume_test_objects tv_slide_a (players)))
	(if debug (print "start music 06a_08"))
	(sound_looping_start scenarios\solo\06a_sentinelwalls\06a_music\06a_08 none 1)
	
	
	(sleep_until (not g_music_06a_08))
	(if debug (print "stop music 06a_08"))
	(sound_looping_stop scenarios\solo\06a_sentinelwalls\06a_music\06a_08)
)

(script dormant music_06a_09
;	(sleep_until g_music_06a_09)
	(sleep_until (volume_test_objects tv_ledge_c_fr (players)) 5)
	(if debug (print "start music 06a_09"))
	(sound_looping_start scenarios\solo\06a_sentinelwalls\06a_music\06a_09 none 1)
	
	(set g_music_06a_08 0)
)

(script dormant music_06a_10
	(sleep_until (volume_test_objects tv_music_06a_10 (players)))
	(if debug (print "start music 06a_10"))
	(sound_looping_start scenarios\solo\06a_sentinelwalls\06a_music\06a_10 none 1)
	
	(sleep_until (not g_music_06a_10))
	(if debug (print "stop music 06a_10"))
	(sound_looping_stop scenarios\solo\06a_sentinelwalls\06a_music\06a_10)
)



; =====  DIALOGUE SCENES ===========================================================================
(global boolean g_plug_ride_enforcer 0)
;(global boolean g_four_locks_down 0)
(global boolean g_hall_b_sen_dialogue 0)
(global boolean g_enforcer 0)
(global boolean g_final_lock 0)
(global boolean g_flip_switch 0)
(global short dialogue_pause 7)


(script command_script sc_cond_cov
	(sleep 60)
	
	(cs_switch grunt)
	
	(if dialogue (print "GRUNT: Arbiter our savior!"))
	(sleep (ai_play_line_at_player cond_a_cov 0400))
	(sleep (* dialogue_pause 3))

	(if dialogue (print "GRUNT: Stupid Jackal, say thank you!"))
	(sleep (ai_play_line_at_player cond_a_cov 0410))
	(sleep dialogue_pause)

	(cs_switch jackal)

	(if dialogue (print "JACKAL: Hissss....."))
	(sleep (ai_play_line_at_player cond_a_cov 0420))
	(sleep dialogue_pause)
)

(script dormant ai_sc_cond_a_cov
	(sleep_until (ai_scene sc_cond_a_cov sc_cond_cov cond_a_cov))
)

(script dormant sc_tartarus_reminder
;	(sleep 30)
	(game_save_cancel)

	(if dialogue (print "TARTARUS: You're getting close to one of the shield-generators…"))
	(sleep (ai_play_line_on_object none 0430))
	(sleep dialogue_pause)

	(if dialogue (print "TARTARUS: Many of my Brutes have fallen attempting to take it down."))
	(sleep (ai_play_line_on_object none 0440))
	(sleep dialogue_pause)

	(if dialogue (print "TARTARUS: Let's see if you fare better."))
	(sleep (ai_play_line_on_object none 0450))
	(sleep dialogue_pause)
	
	(game_save_no_timeout)
)

(script command_script sc_fleeing_grunts
	(if dialogue (print "GRUNT: Big, scary thing! Run away!"))
	(sleep (ai_play_line_at_player ai_current_actor 0460))
	(sleep dialogue_pause)

	(if dialogue (print "GRUNT: Please! No make go back!"))
	(sleep (ai_play_line_at_player ai_current_actor 0470))
	(sleep dialogue_pause)

	(sleep_until g_hall_b_sen_dialogue)
	(sleep 90)

	(if dialogue (print "GRUNT: (shriek) More bad things!"))
	(sleep (ai_play_line_at_player ai_current_actor 0480))
	(sleep dialogue_pause)

	(if dialogue (print "GRUNT: Arbiter! Protect! Protect!"))
	(sleep (ai_play_line_at_player ai_current_actor 0490))
	(sleep dialogue_pause)
)

(script dormant ai_sc_hall_b_grunts
;	(sleep_until (ai_scene sc_hall_b_grunts sc_fleeing_grunts hall_b_cov))
	(sleep_until (ai_trigger_test scene_trigger_4 hall_b_cov))
	(cs_run_command_script hall_b_cov/wimp sc_fleeing_grunts)
)

(script dormant sc_enforcer
	(sleep_until g_enforcer)
	(game_save_cancel)
	(sleep 60)

	(if dialogue (print "TARTARUS: It's useless to attack an Enforcer from the front."))
	(if dialogue (print "TARTARUS: Especially when their shields are up."))
	(sleep (ai_play_line_on_object none 0500))
	(sleep dialogue_pause)

	(if dialogue (print "TARTARUS: Stay in the shadows. Wait 'til it loses interest…"))
	(sleep (ai_play_line_on_object none 0510))
	(sleep dialogue_pause)

	(if dialogue (print "TARTARUS: Then strike the beast when it it's back is turned!"))
	(sleep (ai_play_line_on_object none 0520))
	(sleep dialogue_pause)
	
	(game_save_no_timeout)
)

(script dormant sc_plug_launch
	(game_save_cancel)
	(set g_music_06a_03 0)
	
	(if dialogue (print "TARTARUS: You've reached the shield's power-source, Arbiter."))
	(if dialogue (print "TARTARUS: Overload the locks holding it in place!"))
	(sleep (ai_play_line_on_object none 0010))
	(sleep dialogue_pause)
	
	(set g_enforcer 1)

;*	(sleep_until g_four_locks_down)

	(if dialogue (print "TARTARUS: Four locks to go!"))
	(sleep (ai_play_line_on_object none 0020))
	(sleep dialogue_pause)
*;
	(sleep_until g_final_lock)

	(if dialogue (print "TARTARUS: One more, Arbiter!"))
	(sleep (ai_play_line_on_object none 0030))
	(sleep dialogue_pause)

	(sleep_until g_flip_switch)
	(sleep 60)

	(if dialogue (print "TARTARUS: You've released the power source!"))
	(if dialogue (print "Now find a way to remove it from its cradle."))
	(sleep (ai_play_line_on_object none 0040))
;	(sleep dialogue_pause)
	(game_save_no_timeout)
)

(script dormant sc_plug_ride
	(if dialogue (print "TARTARUS: Our path to the Library is clear."))
	(if dialogue (print "TARTARUS: I'll pick you up on the ledge ahead."))
	(sleep (ai_play_line_on_object none 0050))
	(sleep dialogue_pause)
	
	(sleep_until g_plug_ride_enforcer)
	
	(if dialogue (print "TARTARUS: (angry growl) Blasted machines!"))
	(sleep (ai_play_line_on_object none 0070))
	(sleep dialogue_pause)

	(if dialogue (print "TARTARUS: Make your own way through the wall, Arbiter!"))
	(sleep (ai_play_line_on_object none 0080))
	(sleep dialogue_pause)
)

(script dormant sc_marines_a
	(if dialogue (print "MARINE: Negative, Ma'am. They aren't Covenant!"))
	(sleep (ai_play_line_on_object conduit_b_sound 0090))
	(sleep dialogue_pause)

	(if dialogue (print "SARG: Cover that doorway!"))
	(sleep (ai_play_line_on_object conduit_b_sound 0100))
	(sleep dialogue_pause)
)

(script dormant sc_marines_b
	(if dialogue (print "MARINE: Proceed to the objective! We'll hold out as long as we can!"))
	(sleep (ai_play_line_on_object hall_c_sound 0110))
	(sleep dialogue_pause)

	(if dialogue (print "MARINE: Aaa! Get it off of me!"))
	(sleep (ai_play_line_on_object hall_c_sound 0120))
	(sleep dialogue_pause)

	(if dialogue (print "SARG: Suppressive fire! Suppressive fi -"))
	(sleep (ai_play_line_on_object hall_c_sound 0130))
	(sleep dialogue_pause)
)

(script command_script cs_sc_qz_ini
	(if dialogue (print "SPEC-OPS: Forerunners be praised! The Arbiter!"))
	(sleep (ai_play_line_at_player qz_ini_ins_pods 0530))
	(sleep dialogue_pause)

	(if dialogue (print "SPEC-OPS: This Quarantine-Zone has been compromised!"))
	(if dialogue (print "SPEC-OPS: We must do what we can against the Flood!"))
	(sleep (ai_play_line_at_player qz_ini_ins_pods 0540))
	(sleep (* dialogue_pause 4))

	(if dialogue (print "SPEC-OPS: Our Commander has landed further in."))
	(if dialogue (print "SPEC-OPS: Let us join him!"))
	(sleep (ai_play_line_at_player qz_ini_ins_pods 0550))
	(sleep dialogue_pause)
)

(script dormant sc_qz_initial
	(sleep_until (ai_scene sc_qz_ini cs_sc_qz_ini qz_ini_ins_pods))
)

(global boolean g_qz_cov_camp_progress 0)
(global boolean g_sc_cov_camp_done 0)

;*
(script command_script cs_cov_camp_elite1

(script command_script cs_cov_camp_elite2

(script command_script cs_cov_camp_elite3

(script command_script cs_cov_camp_elite4

(script command_script cs_cov_camp_elite5

(script command_script cs_cov_camp_elite6

(script command_script cs_cov_camp_comm
*;

(script command_script cs_cov_camp_elites
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_nearest qz_cov_def)
	(cs_face_player true)

	(sleep_until g_sc_cov_camp_done)
)

(script command_script cs_cov_camp_soc
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to qz_cov_def/soc)
	(cs_face_player true)
	
	(sleep_until g_sc_cov_camp_done)
)

(script dormant sc_qz_cov_camp
	(ai_vehicle_exit qz_cov_def_cov)
	(ai_vehicle_exit qz_cov_def_soc)
	
	(sleep 30)
	
;	(ai_scene sc_qz_cov_camp cs_cov_camp_soc qz_cov_def_soc qz_cov_def_cov)
	(cs_run_command_script qz_cov_def_cov cs_cov_camp_elites)
	(cs_run_command_script qz_cov_def_soc cs_cov_camp_soc)

	(sleep_until (volume_test_objects tv_qz_cov_def_hill (players)) 30 450)
	(sleep 15)
	
	(if dialogue (print "COMMANDER: Arbiter! What are you doing here?"))
	(sleep (ai_play_line qz_cov_def_soc 0170))
	(sleep dialogue_pause)

	(set g_qz_cov_camp_progress 1)
	(sleep 90)

	(if dialogue (print "SPEC-OPS: The Flood is upon us!"))
	(sleep (ai_play_line qz_cov_def_cov 0190))
	(sleep dialogue_pause)

	(if dialogue (print "COMMANDER: We must hold this camp until reinforcements arrive!"))
	(sleep (ai_play_line qz_cov_def_soc 0200))
	(sleep dialogue_pause)

	(if dialogue (print "SPEC-OPS: May our footsteps never fade!"))
	(sleep (ai_play_line qz_cov_def_cov 0210))
	(sleep dialogue_pause)
	
	(sleep 30)
	(set g_sc_cov_camp_done 1)
	(game_save_no_timeout)
)

;========== POSTON CONTROL SCRIPTS ===============================================================
(global boolean g_piston_control 0)
(global short piston_open_time 150)

(script dormant attach_absorbers_1
	(objects_attach piston_ins "absorber_a" absorber_ins "absorber_a")
	(objects_attach piston_a "absorber_a" absorber_a "absorber_a")
	(objects_attach piston_b "absorber_a" absorber_b "absorber_a")
	(objects_attach piston_c "absorber_a" absorber_c "absorber_a")
	(objects_attach piston_d "absorber_a" absorber_d "absorber_a")
	(objects_attach piston_plug_landing "absorber_a" absorber_plug_landing "absorber_a")
)

(script dormant attach_absorbers_1b
	(objects_attach piston_e "absorber_a" absorber_e "absorber_a")
	(objects_attach piston_f "absorber_a" absorber_f "absorber_a")
	(objects_attach piston_g "absorber_a" absorber_g "absorber_a")
	(objects_attach piston_h "absorber_a" absorber_h "absorber_a")
	(objects_attach piston_i "absorber_a" absorber_i "absorber_a")
	(objects_attach piston_ledge_b "absorber_a" absorber_ledge_b "absorber_a")
	(objects_attach piston_ledge_c "absorber_a" absorber_ledge_c "absorber_a")
)

(script dormant attach_controls_1
	(if	(or
			(difficulty_heroic)
			(difficulty_legendary)
		)
		(begin
			(object_destroy_containing switch_a)
			(object_destroy_containing switch_b)
			(object_destroy_containing switch_c)
			(object_destroy_containing switch_d)
		)
	)

	(objects_attach piston_ins "absorber_a" ins_switch_a "switch")
	(objects_attach piston_ins "absorber_b" ins_switch_b "switch")
	(objects_attach piston_ins "absorber_c" ins_switch_c "switch")
	(objects_attach piston_ins "absorber_d" ins_switch_d "switch")

	(objects_attach piston_a "absorber_a" a_switch_a "switch")
	(objects_attach piston_a "absorber_b" a_switch_b "switch")
	(objects_attach piston_a "absorber_c" a_switch_c "switch")
	(objects_attach piston_a "absorber_d" a_switch_d "switch")

	(objects_attach piston_b "absorber_a" b_switch_a "switch")
	(objects_attach piston_b "absorber_b" b_switch_b "switch")
	(objects_attach piston_b "absorber_c" b_switch_c "switch")
	(objects_attach piston_b "absorber_d" b_switch_d "switch")

	(objects_attach piston_c "absorber_a" c_switch_a "switch")
	(objects_attach piston_c "absorber_b" c_switch_b "switch")
	(objects_attach piston_c "absorber_c" c_switch_c "switch")
	(objects_attach piston_c "absorber_d" c_switch_d "switch")

	(objects_attach piston_d "absorber_a" d_switch_a "switch")
	(objects_attach piston_d "absorber_b" d_switch_b "switch")
	(objects_attach piston_d "absorber_c" d_switch_c "switch")
	(objects_attach piston_d "absorber_d" d_switch_d "switch")

	(objects_attach piston_plug_landing "absorber_a" plug_landing_switch_a "switch")
	(objects_attach piston_plug_landing "absorber_b" plug_landing_switch_b "switch")
	(objects_attach piston_plug_landing "absorber_c" plug_landing_switch_c "switch")
	(objects_attach piston_plug_landing "absorber_d" plug_landing_switch_d "switch")
)

(script dormant attach_controls_1b
	(objects_attach piston_e "absorber_a" e_switch_a "switch")
	(objects_attach piston_e "absorber_b" e_switch_b "switch")
	(objects_attach piston_e "absorber_c" e_switch_c "switch")
	(objects_attach piston_e "absorber_d" e_switch_d "switch")

	(objects_attach piston_f "absorber_a" f_switch_a "switch")
	(objects_attach piston_f "absorber_b" f_switch_b "switch")
	(objects_attach piston_f "absorber_c" f_switch_c "switch")
	(objects_attach piston_f "absorber_d" f_switch_d "switch")

	(objects_attach piston_g "absorber_a" g_switch_a "switch")
	(objects_attach piston_g "absorber_b" g_switch_b "switch")
	(objects_attach piston_g "absorber_c" g_switch_c "switch")
	(objects_attach piston_g "absorber_d" g_switch_d "switch")

	(objects_attach piston_h "absorber_a" h_switch_a "switch")
	(objects_attach piston_h "absorber_b" h_switch_b "switch")
	(objects_attach piston_h "absorber_c" h_switch_c "switch")
	(objects_attach piston_h "absorber_d" h_switch_d "switch")

	(objects_attach piston_i "absorber_a" i_switch_a "switch")
	(objects_attach piston_i "absorber_b" i_switch_b "switch")
	(objects_attach piston_i "absorber_c" i_switch_c "switch")
	(objects_attach piston_i "absorber_d" i_switch_d "switch")

	(objects_attach piston_ledge_b "absorber_a" ledge_b_switch_a "switch")
	(objects_attach piston_ledge_b "absorber_b" ledge_b_switch_b "switch")
	(objects_attach piston_ledge_b "absorber_c" ledge_b_switch_c "switch")
	(objects_attach piston_ledge_b "absorber_d" ledge_b_switch_d "switch")

	(objects_attach piston_ledge_c "absorber_a" ledge_c_switch_a "switch")
	(objects_attach piston_ledge_c "absorber_b" ledge_c_switch_b "switch")
	(objects_attach piston_ledge_c "absorber_c" ledge_c_switch_c "switch")
	(objects_attach piston_ledge_c "absorber_d" ledge_c_switch_d "switch")
)

(script dormant open_piston_ins
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_ins) 0)
							(<= (object_get_shield absorber_ins) 0)
						)
			1)
			(device_set_position piston_ins 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_ins)
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_ins (players))))
			(device_set_position piston_ins 0)
			(device_group_set_immediate group_ins 0)
		(= (structure_bsp_index) 1))
	)
)
(script dormant open_piston_a
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_a) 0)
							(<= (object_get_shield absorber_a) 0)
						)
			1)
			(device_set_position piston_a 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_a)
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_a (players))))
			(device_set_position piston_a 0)
			(device_group_set_immediate group_a 0)
		(= (structure_bsp_index) 1))
	)
)
(script dormant open_piston_b
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_b) 0)
							(<= (object_get_shield absorber_b) 0)
						)
			1)
			(device_set_position piston_b 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_b)
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_b (players))))
			(device_set_position piston_b 0)
			(device_group_set_immediate group_b 0)
		(= (structure_bsp_index) 1))
	)
)
(script dormant open_piston_c
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_c) 0)
							(<= (object_get_shield absorber_c) 0)
						)
			1)
			(device_set_position piston_c 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_c)
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_c (players))))
			(device_set_position piston_c 0)
			(device_group_set_immediate group_c 0)
		(= (structure_bsp_index) 1))
	)
)
(script dormant open_piston_d
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_d) 0)
							(<= (object_get_shield absorber_d) 0)
						)
			1)
			(device_set_position piston_d 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_d)
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_d (players))))
			(device_set_position piston_d 0)
			(device_group_set_immediate group_d 0)
		(= (structure_bsp_index) 1))
	)
)
(script dormant open_piston_plug_landing
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_plug_landing) 0)
							(<= (object_get_shield absorber_plug_landing) 0)
						)
			1)
			(device_set_position piston_plug_landing 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_plug_landing)
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_plug_landing (players))))
			(device_set_position piston_plug_landing 0)
			(device_group_set_immediate group_plug_landing 0)
		(= (structure_bsp_index) 1))
	)
)
(script dormant open_piston_e
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_e) 0)
							(<= (object_get_shield absorber_e) 0)
						)
			1)
			(device_set_position piston_e 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_e)
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_e (players))))
			(device_set_position piston_e 0)
			(device_group_set_immediate group_e 0)
		g_piston_control)
	)
)
(script dormant open_piston_f
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_f) 0)
							(<= (object_get_shield absorber_f) 0)
						)
			1)
			(device_set_position piston_f 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_f)
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_f (players))))
			(device_set_position piston_f 0)
			(device_group_set_immediate group_f 0)
		g_piston_control)
	)
)
(script dormant open_piston_g
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_g) 0)
							(<= (object_get_shield absorber_g) 0)
						)
			1)
			(device_set_position piston_g 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_g)
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_g (players))))
			(device_set_position piston_g 0)
			(device_group_set_immediate group_g 0)
		g_piston_control)
	)
)
(script dormant open_piston_h
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_h) 0)
							(<= (object_get_shield absorber_h) 0)
						)
			1)
			(device_set_position piston_h 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_h)
			(if g_music_06a_07 (set g_music_06a_07 0))
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_h (players))))
			(device_set_position piston_h 0)
			(device_group_set_immediate group_h 0)
		g_piston_control)
	)
)
(script dormant open_piston_i
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_i) 0)
							(<= (object_get_shield absorber_i) 0)
						)
			1)
			(device_set_position piston_i 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_i)
			(if g_music_06a_06 (set g_music_06a_06 0))
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_i (players))))
			(device_set_position piston_i 0)
			(device_group_set_immediate group_i 0)
		g_piston_control)
	)
)
(script dormant open_piston_ledge_b
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_ledge_b) 0)
							(<= (object_get_shield absorber_ledge_b) 0)
						)
			1)
			(device_set_position piston_ledge_b 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_ledge_b)
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_ledge_b (players))))
			(device_set_position piston_ledge_b 0)
			(device_group_set_immediate group_ledge_b 0)
		g_piston_control)
	)
)
(script dormant open_piston_ledge_c
	(sleep_until
		(begin
			(sleep_until	(or
							(> (device_group_get group_ledge_c) 0)
							(<= (object_get_shield absorber_ledge_c) 0)
						)
			1)
			(device_set_position piston_ledge_c 1)
			(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber absorber_ledge_c)
			(sleep piston_open_time)
			(sleep_until (not (volume_test_objects_all tv_piston_ledge_c (players))))
			(device_set_position piston_ledge_c 0)
			(device_group_set_immediate group_ledge_c 0)
		g_piston_control)
	)
)

(script dormant piston_control
	(wake attach_absorbers_1) ; attaches absorbers to pistons in first bsp 
	(wake attach_controls_1) ; attaches controls to pistons in first bsp 
	
	(wake open_piston_ins)
	(wake open_piston_a)
	(wake open_piston_b)
	(wake open_piston_c)
	(wake open_piston_d)
	(wake open_piston_plug_landing)
	
	(sleep_until (= (structure_bsp_index) 1))

	(if debug (print "creating bsp 1 objects...")) ; this is a great spot for this! 
;	(object_create_anew_containing "bsp1_body")
	(object_create_anew_containing "bsp1_weapon")
	(object_create_anew_containing "bsp1_equip")

	
	(wake attach_absorbers_1b) ; attaches absorbers to pistons in second bsp 
	(wake attach_controls_1b) ; attaches controls to pistons in second bsp 

	(sleep_forever open_piston_ins)
	(sleep_forever open_piston_a)
	(sleep_forever open_piston_b)
	(sleep_forever open_piston_c)
	(sleep_forever open_piston_d)
	(sleep_forever open_piston_plug_landing)

	(wake open_piston_e)
	(wake open_piston_f)
	(wake open_piston_g)
	(wake open_piston_h)
	(wake open_piston_i)
	(wake open_piston_ledge_b)
	(wake open_piston_ledge_c)

	(sleep_until (= (structure_bsp_index) 2))
	
	(object_destroy_containing "bsp1_body")
	(object_destroy_containing "bsp1_weapon")
	(object_destroy_containing "bsp1_equip")

	(sleep_forever open_piston_e)
	(sleep_forever open_piston_f)
	(sleep_forever open_piston_g)
	(sleep_forever open_piston_h)
	(sleep_forever open_piston_i)
	(sleep_forever open_piston_ledge_b)
	(sleep_forever open_piston_ledge_c)
)

;*	(sleep_until ; controls pistons in first bsp 
		(begin
			(if (<= (object_get_shield  absorber_ins) 0) (device_set_position piston_ins 1))
			(if (<= (object_get_shield absorber_a) 0) (device_set_position piston_a 1))
			(if (<= (object_get_shield absorber_b) 0) (device_set_position piston_b 1))
			(if (<= (object_get_shield absorber_c) 0) (device_set_position piston_c 1))
			(if (<= (object_get_shield absorber_d) 0) (device_set_position piston_d 1))
			(if (<= (object_get_shield absorber_plug_landing) 0) (device_set_position piston_plug_landing 1))
		(= (structure_bsp_index) 1))
	1)
	
	(wake attach_absorbers_1b) ; attaches absorbers to pistons in second bsp 
	
	(sleep_until ; controls pistons in second bsp 
		(begin
			(if (<= (object_get_shield absorber_e) 0) (device_set_position piston_e 1))
			(if (<= (object_get_shield absorber_f) 0) (device_set_position piston_f 1))
			(if (<= (object_get_shield absorber_g) 0) (device_set_position piston_g 1))
			(if (<= (object_get_shield absorber_h) 0) (device_set_position piston_h 1))
			(if (<= (object_get_shield absorber_i) 0) (device_set_position piston_i 1))
			(if (<= (object_get_shield absorber_ledge_b) 0) (device_set_position piston_ledge_b 1))
			(if (<= (object_get_shield absorber_ledge_c) 0) (device_set_position piston_ledge_c 1))
		g_piston_control)
	1)*;

;================================================================================================================
;========== INSERTION SCRIPTS ===================================================================================
(global boolean g_pussy_grunt 0)

(script command_script cs_pussy_grunt_abort
	(sleep 1)
	(object_can_take_damage (ai_actors pussy_grunt))
	(ai_set_orders pussy_grunt hall_a_cov)

)

(script dormant pussy_grunt_abort
	(sleep_until (volume_test_objects tv_ins_slide_bottom (ai_actors pussy_grunt)))
	(cs_run_command_script pussy_grunt cs_pussy_grunt_abort)
)

(script command_script pussy_grunt_down
	(wake pussy_grunt_abort)
	(cs_enable_dialogue true)
	(cs_enable_pathfinding_failsafe true)
	(cs_movement_mode 2)
	(cs_crouch false)
	(object_cannot_take_damage (ai_actors pussy_grunt))
	
	(sleep_until (>= (device_get_position piston_ins) .5) 10)
	(cs_go_to_and_face insertion/grunt_stand insertion/grunt_shoot)
	(cs_jump 0 1)
	(sleep 15)
	(cs_move_in_direction 0 5 0)
;	(sleep 150)
;	(cs_move_in_direction 180 5 180)
;	(sleep 150)
;	(cs_move_in_direction 0 5 0)
;	(sleep 210)
)

(script command_script pussy_grunt_shoot
	(cs_movement_mode 2)
	(cs_crouch false)
	(cs_go_to_and_face insertion/grunt_stand insertion/grunt_shoot)
	(sleep 15)
	(cs_shoot_point true insertion/grunt_shoot)
	(sleep_until (<= (object_get_shield absorber_ins) 0) 5)
	(sleep 15)
	(cs_shoot_point false insertion/grunt_shoot)
	(cs_run_command_script pussy_grunt pussy_grunt_down)
)

(script dormant pussy_grunt
	(if (>= (ai_combat_status insertion_sen) ai_combat_status_active)
		(sleep_until	(and
						(<= (object_get_health ins_em_a) 0)
						(<= (object_get_health ins_em_b) 0)
						(<= (object_get_health ins_em_c) 0)
					)
		)
	)
	(sleep 45)
	(if (= (device_get_position piston_ins) 0)
			(cs_run_command_script pussy_grunt pussy_grunt_shoot)
	)
	
	(sleep_until (volume_test_objects tv_insertion_tube (players)) 5)
	(cs_run_command_script pussy_grunt pussy_grunt_down)
)

(script command_script cs_pussy_grunt
	(cs_movement_mode 3)
	(cs_crouch true)
	(ai_disregard (ai_actors constructors) true)
	(sleep_until	(or
					(volume_test_objects tv_pussy_grunt (players))
					(< (ai_strength pussy_grunt) 1)
;					(> (device_get_position piston_ins) 0)
				)
	)
	(cs_movement_mode 2)
	(cs_crouch false)
	(wake pussy_grunt)
)

(script dormant pussy_grunt_reminder
	(sleep (* 30 60 5))
	
	(if (not g_pussy_grunt)
		(begin
			(sleep_until (volume_test_objects tv_ins_bk (players)))
			(if (>= (ai_combat_status insertion_sen) ai_combat_status_active)
				(sleep_until	(and
								(<= (object_get_health ins_em_a) 0)
								(<= (object_get_health ins_em_b) 0)
								(<= (object_get_health ins_em_c) 0)
							)
				)
			)
			(sleep 45)
			(if (= (device_get_position piston_ins) 1) (cs_run_command_script pussy_grunt pussy_grunt_shoot))
		)
	)
)

(script command_script cs_miniaturize
	(object_set_scale (ai_get_object ai_current_actor) .3 0)
)

(script command_script cs_big
	(cs_enable_moving true)
	(sleep (* 30  10))
	(object_set_scale (ai_get_object ai_current_actor) 2.1 0)
)

(script command_script cs_ins_weld_a
	(cs_abort_on_damage true)
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to_and_face insertion/p3 insertion/p4)
	(cs_shoot_point true insertion/p4)
	(sleep (random_range 300 450))
	(cs_shoot_point false insertion/p4)
)

(script command_script cs_ins_weld_b
	(cs_abort_on_damage true)
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to_and_face insertion/p5 insertion/p6)
	(cs_shoot_point true insertion/p6)
	(sleep (random_range 150 300))
	(cs_shoot_point false insertion/p6)
)

(script command_script cs_ins_weld_c
	(cs_abort_on_damage true)
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to_and_face insertion/p7 insertion/p8)
	(cs_shoot_point true insertion/p8)
	(sleep (random_range 45 60))
	(cs_shoot_point false insertion/p8)
	
	(cs_fly_to_and_face insertion/p9 insertion/p10)
	(cs_shoot_point true insertion/p10)
	(sleep (random_range 45 60))
	(cs_shoot_point false insertion/p10)
)


(script command_script cs_ins_shoot_absorber_slide
	(cs_abort_on_damage true)
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to_and_face insertion/shoot_slide insertion/target_slide .25)
	(sleep 15)
	(cs_shoot_point true insertion/target_slide)
	
	(sleep_until (<= (object_get_shield absorber_a) 0) 5)
	(sleep 15)
	(cs_shoot_point false insertion/target_slide)
)

(script dormant ins_open_door_slide
	(ai_place ins_con_slide)
	(if (= (ai_strength ins_cons) 1)
		(begin
			(ai_set_orders ins_con_mid ins_sen_slide)
			(ai_set_orders ins_con_bk ins_sen_slide)
		  )
	)

	(sleep_until	(and
					(volume_test_objects tv_ins_slide_bottom (players))
					(objects_can_see_object (players) piston_a 180)
				)
	)

	(cs_run_command_script ins_con_slide/shooter cs_ins_shoot_absorber_slide)
)
	
(script command_script cs_ins_runaway
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to insertion/p0)
	(cs_fly_to insertion/p1)
	(cs_fly_to insertion/p2)
	(ai_erase ai_current_actor)
)

(script command_script cs_ins_shoot_absorber
	(cs_abort_on_damage true)
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to_and_face insertion/shoot_ins insertion/target_ins .25)
	(sleep 15)
	(cs_shoot_point true insertion/target_ins)
	
	(sleep_until (<= (object_get_shield absorber_ins) 0) 5)
	(wake ins_open_door_slide)
	(sleep 15)
	(cs_shoot_point false insertion/target_ins)
)

(script dormant ins_open_door
	(sleep_until	(and
					(volume_test_objects tv_ins_bk (players))
					(objects_can_see_object (players) piston_ins 180)
				)
	)
	(if (= (ai_strength ins_cons) 1)
			(begin
				(cs_run_command_script ins_con_bk/shooter cs_ins_shoot_absorber)
				(set g_cons_open_ins 1)
			)
	)
)

(global boolean g_insertion_spawn 0)
; used to reset the loop 
(global boolean g_insertion_wave 0)
; counts the number spawned per wave 
(global short g_insertion_counter 0)
; max number spawned per wave 
(global short g_insertion_index 0)
; when # alive drops below this spawn another wave
(global short g_insertion_limit 0)


(script dormant ai_insertion_emitters
; set spawning script variables based on difficulty levels 
	(cond
		((difficulty_normal) (begin (set g_insertion_limit 0) (set g_insertion_index 1)))
		((difficulty_heroic) (begin (set g_insertion_limit 0) (set g_insertion_index 2)))
		((difficulty_legendary) (begin (set g_insertion_limit 1) (set g_insertion_index 3)))
	)
; spawner loop 
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count insertion_sentinels) g_insertion_limit))
			(if g_insertion_spawn (sleep_forever))
			(sleep g_emitter_delay)
			(set g_insertion_counter 0)
			(set g_insertion_wave 0)

			(sleep_until ; wave loop 
				(begin
					(ai_place insertion_sen 1)
					(set g_insertion_counter (+ g_insertion_counter 1))
					(if (= g_insertion_counter g_insertion_index) (set g_insertion_wave 1))
					(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
				g_insertion_wave)
			)
		g_insertion_spawn)
	)
)

;========== HALL A SCRIPTS ===================================================================================
(global boolean g_hall_a_loops 0)
(global boolean g_hall_a_wave 0)
(global short g_hall_a_em_count 0)
(global short g_hall_a_em_index 0)
(global short g_hall_a_sen_limit 0)

(script static void ai_hall_a_em_c
	(if debug (print "c"))
	(ai_place hall_a_sen/c)
	(set g_hall_a_em_count (+ g_hall_a_em_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_hall_a_em_d
	(if debug (print "d"))
	(ai_place hall_a_sen/d)
	(set g_hall_a_em_count (+ g_hall_a_em_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_hall_a_em_g
	(if debug (print "g"))
	(ai_place hall_a_sen/g)
	(set g_hall_a_em_count (+ g_hall_a_em_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_hall_a_em_h
	(if debug (print "h"))
	(ai_place hall_a_sen/h)
	(set g_hall_a_em_count (+ g_hall_a_em_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)

(script dormant ai_hall_a_emitters
	(cond ; set variables 
		((difficulty_normal) (begin (set g_hall_a_sen_limit 0) (set g_hall_a_em_index 2)))
		((difficulty_heroic) (begin (set g_hall_a_sen_limit 0) (set g_hall_a_em_index 3)))
		((difficulty_legendary) (begin (set g_hall_a_sen_limit 1) (set g_hall_a_em_index 4)))
	)

	(sleep_until ; loop spawner 
		(begin
			(sleep_until (<= (ai_living_count hall_a_sentinels) g_hall_a_sen_limit))
			(if g_hall_a_loops (sleep_forever))
			(sleep g_emitter_delay)
			(set g_hall_a_em_count 0)
			(set g_hall_a_wave 0)
			
			(sleep_until ; wave spawner 
				(begin
					(cond
						((and
							(not (unit_is_emitting hall_a_em_c))
							(> (object_get_health hall_a_em_c) 0)
							(> (objects_distance_to_object (players) hall_a_em_c) 0)
							(< (objects_distance_to_object (players) hall_a_em_c) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_hall_a_em_c))
						((and
							(not (unit_is_emitting hall_a_em_d))
							(> (object_get_health hall_a_em_d) 0)
							(> (objects_distance_to_object (players) hall_a_em_d) 0)
							(< (objects_distance_to_object (players) hall_a_em_d) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_hall_a_em_d))
						((and
							(not (unit_is_emitting hall_a_em_g))
							(> (object_get_health hall_a_em_g) 0)
							(> (objects_distance_to_object (players) hall_a_em_g) 0)
							(< (objects_distance_to_object (players) hall_a_em_g) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_hall_a_em_g))
						((and
							(not (unit_is_emitting hall_a_em_h))
							(> (object_get_health hall_a_em_h) 0)
							(> (objects_distance_to_object (players) hall_a_em_h) 0)
							(< (objects_distance_to_object (players) hall_a_em_h) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_hall_a_em_h))

						(true (begin (ai_place hall_a_sen) (set g_hall_a_em_count (+ g_hall_a_em_count 1))))
					)
					(if (= g_hall_a_em_count g_hall_a_em_index) (set g_hall_a_wave 1))
					(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
				g_hall_a_wave)
			)
		g_hall_a_loops)
	)
)

(script dormant ai_hall_a_const
	(ai_place hall_a_con_ini)
	(ai_place hall_a_con_bk)
	(sleep 30)
	(sleep_until (< (ai_strength hall_a_cons) 0.8))
	(sleep 30)
	(if debug (print "hall a constructors running away"))
	(ai_set_orders constructors hall_a_runway)
)
	
												
; ========== CONDUIT A SCRIPTS ===================================================================================
(global boolean g_cond_a_front 0)
(global boolean g_cond_a_back 0)
	(global boolean g_cond_a_wave 0)
		(global short g_cond_a_count 0)
		(global short g_cond_a_index 0)
		(global short g_cond_a_limit 0)

; conduit a front room emitters 
(script static void ai_cond_a_em_a
	(if debug (print "a"))
	(ai_place cond_a_sen_a/a)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_cond_a_em_c
	(if debug (print "c"))
	(ai_place cond_a_sen_a/c)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_cond_a_em_e
	(if debug (print "e"))
	(ai_place cond_a_sen_a/e)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_cond_a_em_f
	(if debug (print "f"))
	(ai_place cond_a_sen_a/f)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_cond_a_em_g
	(if debug (print "g"))
	(ai_place cond_a_sen_a/g)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_cond_a_em_h
	(if debug (print "h"))
	(ai_place cond_a_sen_a/h)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)

; conduit a back room emitters 
(script static void ai_cond_a_em_i
	(if debug (print "i"))
	(ai_place cond_a_sen_b/i)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_cond_a_em_j
	(if debug (print "j"))
	(ai_place cond_a_sen_b/j)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_cond_a_em_k
	(if debug (print "k"))
	(ai_place cond_a_sen_b/k)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_cond_a_em_l
	(if debug (print "l"))
	(ai_place cond_a_sen_b/l)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_cond_a_em_m
	(if debug (print "m"))
	(ai_place cond_a_sen_b/m)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_cond_a_em_n
	(if debug (print "n"))
	(ai_place cond_a_sen_b/n)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_cond_a_em_o
	(if debug (print "o"))
	(ai_place cond_a_sen_b/o)
	(set g_cond_a_count (+ g_cond_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)

(script dormant ai_cond_a_emitters_fr
	(cond ; set variables 
		((difficulty_normal) (begin (set g_cond_a_limit 0) (set g_cond_a_index 2)))
		((difficulty_heroic) (begin (set g_cond_a_limit 0) (set g_cond_a_index 3)))
		((difficulty_legendary) (begin (set g_cond_a_limit 1) (set g_cond_a_index 4)))
	)

	(sleep_until ; loop spawner 
		(begin
			(sleep_until (<= (ai_living_count cond_a_sentinels) g_cond_a_limit))
			(if (difficulty_legendary) (sleep g_emitter_delay) (sleep (* g_emitter_delay 2)))
			(if g_cond_a_front (sleep_forever))
			(set g_cond_a_count 0)
			(set g_cond_a_wave 0)

			(sleep_until ; wave spawner 
				(begin
					(cond
						((and
							(not (unit_is_emitting cond_a_em_c))
							(> (object_get_health cond_a_em_c) 0)
							(> (objects_distance_to_object (players) cond_a_em_c) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_c))
						((and
							(not (unit_is_emitting cond_a_em_f))
							(> (object_get_health cond_a_em_f) 0)
							(> (objects_distance_to_object (players) cond_a_em_f) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_f))
						((and
							(not (unit_is_emitting cond_a_em_g))
							(> (object_get_health cond_a_em_g) 0)
							(> (objects_distance_to_object (players) cond_a_em_g) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_g))
						((and
							(not (unit_is_emitting cond_a_em_e))
							(> (object_get_health cond_a_em_e) 0)
							(> (objects_distance_to_object (players) cond_a_em_e) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_e))
						((and
							(not (unit_is_emitting cond_a_em_h))
							(> (object_get_health cond_a_em_h) 0)
							(> (objects_distance_to_object (players) cond_a_em_h) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_h))
						((and
							(not (unit_is_emitting cond_a_em_a))
							(> (object_get_health cond_a_em_a) 0)
							(> (objects_distance_to_object (players) cond_a_em_a) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_a))
						(true (begin (ai_place cond_a_sen_a) (set g_cond_a_count (+ g_cond_a_count 1))))
					)

					(if (= g_cond_a_count g_cond_a_index) (set g_cond_a_wave 1))
					(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
				g_cond_a_wave)
			)
		g_cond_a_front)
	)
)

; player passes through the middle conduit (this turns off the previous space emitters) 

(script dormant ai_cond_a_emitters_bk			
	(sleep_until ; loop spawner 
		(begin
			(sleep_until (<= (ai_living_count cond_a_sentinels) g_cond_a_limit))
			(if (difficulty_legendary) (sleep g_emitter_delay) (sleep (* g_emitter_delay 2)))
			(if g_cond_a_back (sleep_forever))
			(set g_cond_a_count 0)
			(set g_cond_a_wave 0)

			(sleep_until ; wave spawner 
				(begin
					(cond
						((and
							(not (unit_is_emitting cond_a_em_k))
							(> (object_get_health cond_a_em_k) 0)
							(> (objects_distance_to_object (players) cond_a_em_k) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_k))
						((and
							(not (unit_is_emitting cond_a_em_o))
							(> (object_get_health cond_a_em_o) 0)
							(> (objects_distance_to_object (players) cond_a_em_o) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_o))
						((and
							(not (unit_is_emitting cond_a_em_n))
							(> (object_get_health cond_a_em_n) 0)
							(> (objects_distance_to_object (players) cond_a_em_n) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_n))
						((and
							(not (unit_is_emitting cond_a_em_j))
							(> (object_get_health cond_a_em_j) 0)
							(> (objects_distance_to_object (players) cond_a_em_j) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_j))
						((and
							(not (unit_is_emitting cond_a_em_l))
							(> (object_get_health cond_a_em_l) 0)
							(> (objects_distance_to_object (players) cond_a_em_l) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_l))
						((and
							(not (unit_is_emitting cond_a_em_m))
							(> (object_get_health cond_a_em_m) 0)
							(> (objects_distance_to_object (players) cond_a_em_m) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_m))
						((and
							(not (unit_is_emitting cond_a_em_i))
							(> (object_get_health cond_a_em_i) 0)
							(> (objects_distance_to_object (players) cond_a_em_i) 5)
							(<= (random_range 0 10) 3)
						)
						(ai_cond_a_em_i))

						(true (begin (ai_place cond_a_sen_b) (set g_cond_a_count (+ g_cond_a_count 1))))
					)
					
					(if (= g_cond_a_count g_cond_a_index) (set g_cond_a_wave 1))
					(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
				g_cond_a_wave)
			)
		g_cond_a_back)
	)
)

(global short g_cond_a_bk_count 0)
(global short g_cond_a_bk_limit 0)

(script dormant ai_cond_a_back_ini
	(cond ; set variables 
		((difficulty_normal) (set g_cond_a_bk_limit 2))
		((difficulty_heroic) (set g_cond_a_bk_limit 3))
		((difficulty_legendary) (set g_cond_a_bk_limit 4))
	)

	(sleep 180)
	(begin_random
		(begin
			(ai_place cond_a_sen_b/j)
			(set g_cond_a_bk_count (+ g_cond_a_bk_count 1))
			(sleep (random_range 5 15))
			(if (= g_cond_a_bk_count g_cond_a_bk_limit) (sleep_forever))
		)
		(begin
			(ai_place cond_a_sen_b/k)
			(set g_cond_a_bk_count (+ g_cond_a_bk_count 1))
			(sleep (random_range 5 15))
			(if (= g_cond_a_bk_count g_cond_a_bk_limit) (sleep_forever))
		)
		(begin
			(ai_place cond_a_sen_b/m)
			(set g_cond_a_bk_count (+ g_cond_a_bk_count 1))
			(sleep (random_range 5 15))
			(if (= g_cond_a_bk_count g_cond_a_bk_limit) (sleep_forever))
		)
		(begin
			(ai_place cond_a_sen_b/o)
			(set g_cond_a_bk_count (+ g_cond_a_bk_count 1))
			(if (= g_cond_a_bk_count g_cond_a_bk_limit) (sleep_forever))
			(sleep (random_range 5 15))
		)
	)
)

(script command_script cs_cond_a_sen_e
	(cs_fly_to cond_a/p0)
)

(global boolean g_cond_a_continue 0)

(script dormant cond_a_delay
	(sleep 90)
	(set g_cond_a_continue 1)
)

(script dormant cond_a_initial_delay
	(sleep_until
		(begin
			(cond
				((not (volume_test_objects_all tv_conduit_a (players))) (set g_cond_a_continue 1))
				((<= (ai_living_count cond_a_sentinels) 0) (wake cond_a_delay))
			)
		g_cond_a_continue)
	)
)

;========== HALL B SCRIPTS ===================================================================================
(global boolean g_hall_b_loops 0)
	(global boolean g_hall_b_wave 0)
		(global short g_hall_b_em_count 0)
		(global short g_hall_b_em_index 0)
		(global short g_hall_b_sen_limit 0)

(script static void ai_hall_b_em_b
	(if debug (print "b"))
	(ai_place hall_b_sen/b)
	(set g_hall_b_em_count (+ g_hall_b_em_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_hall_b_em_d
	(if debug (print "d"))
	(ai_place hall_b_sen/d)
	(set g_hall_b_em_count (+ g_hall_b_em_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_hall_b_em_e
	(if debug (print "e"))
	(ai_place hall_b_sen/e)
	(set g_hall_b_em_count (+ g_hall_b_em_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_hall_b_em_f
	(if debug (print "f"))
	(ai_place hall_b_sen/f)
	(set g_hall_b_em_count (+ g_hall_b_em_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_hall_b_em_g
	(if debug (print "g"))
	(ai_place hall_b_sen/g)
	(set g_hall_b_em_count (+ g_hall_b_em_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)

(script dormant ai_hall_b_emitters
	(cond ; set variables 
		((difficulty_normal) (begin (set g_hall_b_sen_limit 0) (set g_hall_b_em_index 3)))
		((difficulty_heroic) (begin (set g_hall_b_sen_limit 0) (set g_hall_b_em_index 4)))
		((difficulty_legendary) (begin (set g_hall_b_sen_limit 1) (set g_hall_b_em_index 5)))
	)

	(sleep_until ; loop spawner 
		(begin
			(sleep_until (<= (ai_living_count hall_b_sentinels) g_hall_b_sen_limit))
			(if g_hall_b_loops (sleep_forever))
			(sleep g_emitter_delay)
			(set g_hall_b_em_count 0)
			(set g_hall_b_wave 0)
			
			(sleep_until ; wave spawner 
				(begin
					(cond
						((and
							(not (unit_is_emitting hall_b_em_b))
							(> (object_get_health hall_b_em_b) 0)
							(> (objects_distance_to_object (players) hall_b_em_b) 0)
							(< (objects_distance_to_object (players) hall_b_em_b) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_hall_b_em_d))
						((and
							(not (unit_is_emitting hall_b_em_d))
							(> (object_get_health hall_b_em_d) 0)
							(> (objects_distance_to_object (players) hall_b_em_d) 0)
							(< (objects_distance_to_object (players) hall_b_em_d) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_hall_b_em_d))
						((and
							(not (unit_is_emitting hall_b_em_e))
							(> (object_get_health hall_b_em_e) 0)
							(> (objects_distance_to_object (players) hall_b_em_e) 0)
							(< (objects_distance_to_object (players) hall_b_em_e) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_hall_b_em_e))
						((and
							(not (unit_is_emitting hall_b_em_f))
							(> (object_get_health hall_b_em_f) 0)
							(> (objects_distance_to_object (players) hall_b_em_f) 0)
							(< (objects_distance_to_object (players) hall_b_em_f) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_hall_b_em_f))
						((and
							(not (unit_is_emitting hall_b_em_g))
							(> (object_get_health hall_b_em_g) 0)
							(> (objects_distance_to_object (players) hall_b_em_g) 0)
							(< (objects_distance_to_object (players) hall_b_em_g) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_hall_b_em_g))
					
						(true (begin (ai_place hall_b_sen) (set g_hall_b_em_count (+ g_hall_b_em_count 1))))
					)
					(if (= g_hall_b_em_count g_hall_b_em_index) (set g_hall_b_wave 1))
					(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
				g_hall_b_wave)
			)
		g_hall_b_loops)
	)
)

;========== PLUG LAUNCH SCRIPTS ==============================================================================

(script command_script cs_plug_launch_enforcer
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to plug_launch/p0)
)

(global boolean g_plug_launch_loops 0)
	(global boolean g_plug_launch_wave 0)
		(global short g_plug_launch_count 0) ; keeps track of the number spawned per wave
		(global short g_plug_launch_index 0) ; number spawned per wave
		(global short g_plug_launch_limit 0) ; max number alive at one time

(script static void ai_plug_launch_em_a
	(if debug (print "a"))
	(ai_place plug_launch_sen/a)
	(set g_plug_launch_count (+ g_plug_launch_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_launch_em_b
	(if debug (print "b"))
	(ai_place plug_launch_sen/b)
	(set g_plug_launch_count (+ g_plug_launch_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_launch_em_c
	(if debug (print "c"))
	(ai_place plug_launch_sen/c)
	(set g_plug_launch_count (+ g_plug_launch_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_launch_em_d
	(if debug (print "d"))
	(ai_place plug_launch_sen/d)
	(set g_plug_launch_count (+ g_plug_launch_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_launch_em_e
	(if debug (print "e"))
	(ai_place plug_launch_sen/e)
	(set g_plug_launch_count (+ g_plug_launch_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_launch_em_f
	(if debug (print "f"))
	(ai_place plug_launch_sen/f)
	(set g_plug_launch_count (+ g_plug_launch_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_launch_em_g
	(if debug (print "g"))
	(ai_place plug_launch_sen/g)
	(set g_plug_launch_count (+ g_plug_launch_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_launch_em_h
	(if debug (print "h"))
	(ai_place plug_launch_sen/h)
	(set g_plug_launch_count (+ g_plug_launch_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)

(global boolean g_plug_launch_em_heroic 0)

(script dormant ai_plug_launch_em
	(cond ; g_plug_launch_index is increased when 4 absorbers are destroyed 
		((difficulty_normal)	(begin
								(set g_plug_launch_limit 0)
								(set g_plug_launch_index 2)
								(if debug (print "emitters off"))
								(sleep_forever)
							)
		)
		((difficulty_heroic)	(begin
								(set g_plug_launch_limit 0)
								(set g_plug_launch_index 3)
								(sleep_until g_plug_launch_em_heroic)
								(if debug (print "emitters on"))
							)
		)
		((difficulty_legendary)	(begin
								(set g_plug_launch_limit 0)
								(set g_plug_launch_index 4)
								(if debug (print "emitters on"))
							)
		)
	)

	(sleep_until ; loop spawner 
		(begin
			(sleep_until (<= (ai_living_count plug_launch_sentinels) g_plug_launch_limit))
			(if g_plug_launch_loops (sleep_forever))
			(sleep g_emitter_delay)
			(set g_plug_launch_count 0)
			(set g_plug_launch_wave 0)
			
			(sleep_until ; wave spawner 
				(begin
					(cond
						((and
							(not (unit_is_emitting plug_launch_em_a))
							(> (object_get_health plug_launch_em_a) 0)
							(> (objects_distance_to_object (players) plug_launch_em_a) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_launch_em_a))
						((and
							(not (unit_is_emitting plug_launch_em_b))
							(> (object_get_health plug_launch_em_b) 0)
							(> (objects_distance_to_object (players) plug_launch_em_b) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_launch_em_b))
						((and
							(not (unit_is_emitting plug_launch_em_c))
							(> (object_get_health plug_launch_em_c) 0)
							(> (objects_distance_to_object (players) plug_launch_em_c) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_launch_em_c))
						((and
							(not (unit_is_emitting plug_launch_em_d))
							(> (object_get_health plug_launch_em_d) 0)
							(> (objects_distance_to_object (players) plug_launch_em_d) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_launch_em_d))
						((and
							(not (unit_is_emitting plug_launch_em_e))
							(> (object_get_health plug_launch_em_e) 0)
							(> (objects_distance_to_object (players) plug_launch_em_e) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_launch_em_e))
						((and
							(not (unit_is_emitting plug_launch_em_f))
							(> (object_get_health plug_launch_em_f) 0)
							(> (objects_distance_to_object (players) plug_launch_em_f) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_launch_em_f))
						((and
							(not (unit_is_emitting plug_launch_em_g))
							(> (object_get_health plug_launch_em_g) 0)
							(> (objects_distance_to_object (players) plug_launch_em_g) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_launch_em_g))
						((and
							(not (unit_is_emitting plug_launch_em_g))
							(> (object_get_health plug_launch_em_g) 0)
							(> (objects_distance_to_object (players) plug_launch_em_g) 10)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_launch_em_g))
						
						(true (begin (ai_place plug_launch_sen) (set g_plug_launch_count (+ g_plug_launch_count 1))))
					)
					(if (= g_plug_launch_count g_plug_launch_index) (set g_plug_launch_wave 1))
					(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
				g_plug_launch_wave)
			)
		g_plug_launch_loops)
	)
)



;========== PLUG LOCKING MECHANISM ==========
;*
(script static short absorber01_count
	(if (<= (object_get_shield plugabsorber01) 0) 0 1))

(script static short absorber02_count
	(if (<= (object_get_shield plugabsorber02) 0) 0 1))

(script static short absorber03_count
	(if (<= (object_get_shield plugabsorber03) 0) 0 1))

(script static short absorber04_count
	(if (<= (object_get_shield plugabsorber04) 0) 0 1))
*;
(script static short absorber05_count
	(if (<= (object_get_shield plugabsorber05) 0) 0 1))

(script static short absorber06_count
	(if (<= (object_get_shield plugabsorber06) 0) 0 1))

(script static short absorber07_count
	(if (<= (object_get_shield plugabsorber07) 0) 0 1))

(script static short absorber08_count
	(if (<= (object_get_shield plugabsorber08) 0) 0 1))

(script static short absorber_totalcount
	(+
;*		(absorber01_count)
		(absorber02_count)
		(absorber03_count)
		(absorber04_count)*;
		(absorber05_count)
		(absorber06_count)
		(absorber07_count)
		(absorber08_count)				
	)
)

(script dormant plug_rods08
	(sleep_until	(or
					(> (device_group_get group_plug_c) 0)
					(<= (object_get_shield plugabsorber08) 0)
				)
	5)
	(device_set_position plug_thin_fr 1)
	(device_set_position plug_thick_fr 1)
	(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber plugabsorber08)
)

(script dormant plug_rods07
	(sleep_until	(or
					(> (device_group_get group_plug_d) 0)
					(<= (object_get_shield plugabsorber07) 0)
				)
	5)
	(device_set_position plug_thin_br 1)
	(device_set_position plug_thick_br 1)
	(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber plugabsorber07)
)

(script dormant plug_rods06
	(sleep_until	(or
					(> (device_group_get group_plug_a) 0)
					(<= (object_get_shield plugabsorber06) 0)
				)
	5)
	(device_set_position plug_thin_bl 1)
	(device_set_position plug_thick_bl 1)
	(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber plugabsorber06)
)

(script dormant plug_rods05
	(sleep_until	(or
					(> (device_group_get group_plug_b) 0)
					(<= (object_get_shield plugabsorber05) 0)
				)
	5)
	(device_set_position plug_thin_fl 1)
	(device_set_position plug_thick_fl 1)
	(damage_object scenarios\objects\solo\sentinelhq\door_piston_absorber\damage_effects\damage_absorber plugabsorber05)
)
;*
(script dormant plug_rods04
	(sleep_until (<= (object_get_shield plugabsorber04) 0) 5)
	(device_set_position plug_thick_fl 1)
;	(object_destroy plugabsorber04)
)

(script dormant plug_rods03
	(sleep_until (<= (object_get_shield plugabsorber03) 0) 5)
	(device_set_position plug_thick_bl 1)
;	(object_destroy plugabsorber03)
)


(script dormant plug_rods02
	(sleep_until (<= (object_get_shield plugabsorber02) 0) 5)
	(device_set_position plug_thick_br 1)
;	(object_destroy plugabsorber02)
)

(script dormant plug_rods01
	(sleep_until (<= (object_get_shield plugabsorber01) 0) 5)
	(device_set_position plug_thick_fr 1)
;	(object_destroy plugabsorber01)
)
*;
(script static void test_ab
	(object_set_shield plugabsorber08 0)
;	(sleep 30)
	(object_set_shield plugabsorber07 0)
;	(sleep 30)
	(object_set_shield plugabsorber06 0)
;	(sleep 30)
	(object_set_shield plugabsorber05 0)
;	(sleep 30)
;	(object_set_shield plugabsorber04 0)
;	(sleep 30)
;	(object_set_shield plugabsorber03 0)
;	(sleep 30)
;	(object_set_shield plugabsorber02 0)
;	(sleep 30)
;	(object_set_shield plugabsorber01 0)
)

(global boolean g_plug_move 0)

(script dormant plug_absorbers

;	(sleep_until (volume_test_objects plug_intro (players))15)
	
	(objects_attach plug "absorber_a01" plugabsorber06 "absorber")
	(objects_attach plug "absorber_b01" plugabsorber05 "absorber")
	(objects_attach plug "absorber_c01" plugabsorber08 "absorber")
	(objects_attach plug "absorber_d01" plugabsorber07 "absorber")
	(objects_attach plug "switch" plug_switch_housing "")

	(objects_attach plug "absorber_a01" plug_switch_a "switch")
	(objects_attach plug "absorber_b01" plug_switch_b "switch")
	(objects_attach plug "absorber_c01" plug_switch_c "switch")
	(objects_attach plug "absorber_d01" plug_switch_d "switch")

;	(device_set_position_immediate plug_holder_lock_lt 1)
;	(device_set_position_immediate plug_holder_lock_rt 1)

	(game_save)
	
	(wake plug_rods08)
	(wake plug_rods07)
	(wake plug_rods06)
	(wake plug_rods05)
;	(wake plug_rods04)
;	(wake plug_rods03)
;	(wake plug_rods02)
;	(wake plug_rods01)
	
	(wake sc_plug_launch)
;*
	(sleep_until (<= (absorber_totalcount) 7))
	(if dialogue (print "absorber activated!"))
	
	(sleep_until (<= (absorber_totalcount) 6))
	(if dialogue (print "absorber activated!"))
	
	(sleep_until (<= (absorber_totalcount) 5))
	(if dialogue (print "absorber activated!"))

	(sleep_until (<= (absorber_totalcount) 4))
	(set g_four_locks_down 1)
	
	(cond
		((difficulty_normal) (begin (set g_plug_launch_limit 2) (set g_plug_launch_index 4)))
		((difficulty_heroic) (begin (set g_plug_launch_limit 3) (set g_plug_launch_index 6)))
		((difficulty_legendary) (begin (set g_plug_launch_limit 4) (set g_plug_launch_index 8)))
	)
*;
	(sleep 90)
	(if debug (print "Only 4 more to go!!"))
	
	(sleep_until (<= (absorber_totalcount) 3))
	(if debug (print "absorber activated!"))
	
	(sleep_until (<= (absorber_totalcount) 2))
	(if debug (print "absorber activated!"))
	(set g_plug_launch_em_heroic 1)
	
	(sleep_until (<= (absorber_totalcount) 1))
	(if debug (print "absorber activated!"))
	(set g_final_lock 1)

	(sleep_until (<= (absorber_totalcount) 0))
	(if debug (print "absorber activated!"))
	
	(set g_flip_switch 1)
	(device_set_position plug_switch_housing 1)
	(ai_set_orders covenant plug_cov)
	
	(sleep_until (>= (device_get_position plug_switch_housing) 1) 1 120)
	(sleep 30)
	(object_create plug_switch)
	(objects_attach plug_switch_housing "switch" plug_switch "")
	(device_set_power plug_switch 1)
	(device_set_position plug_switch 1)
	(sleep 30)
	
	(sleep_until (>= (device_get_position plug_switch) 1) 1)
	(device_group_change_only_once_more_set plug true)
	
	(sleep_until (<= (device_get_position plug_switch) 0) 1)
	(sleep 60)
	(device_set_power plug_switch 0)
	(set g_plug_move 1)

)

;========== PLUG RIDE SCRIPTS ============================================================================

(script command_script cs_gap_phantom
	(cs_enable_pathfinding_failsafe 1)
;	(cs_fly_by wall_gap/p0)
	(cs_vehicle_speed 1)
	(cs_fly_by wall_gap/p1 4)
	(cs_fly_by wall_gap/p2 4)
	
	(wake sc_plug_ride)
	(cs_fly_by wall_gap/p3 4)
;	(cs_fly_by wall_gap/p4 5)
;	(cs_fly_by wall_gap/p5 5)
;	(cs_fly_to wall_gap/p6 5)
;	(cs_fly_by wall_gap/p7 5)
;	(cs_fly_by wall_gap/p8 5)
	(cs_fly_by wall_gap/p9 7)

	(if debug (print "placing enforcer..."))
	(ai_place plug_holder_enforcer)

	(cs_fly_to_and_face wall_gap/p10 wall_gap/p20 3)
	
	(device_group_change_only_once_more_set plug_door_a 0)
	(sleep 1)
	
	(if debug (print "opening door... (closing the one behind you)"))
	(device_set_position plug_door_a 0)
	(device_set_position plug_door_b 1)
	(sleep 1)
	(if debug (print "placing eliminators..."))
	(ai_place plug_holder_sen_elim 2)
	(sleep 1)

	(sleep (* 30 5))
	(if debug (print "placing initial flood..."))
	(ai_place plug_holder_flood_a 1)
	(ai_place plug_holder_flood_d)
	(ai_place plug_holder_flood_c)
	(ai_place plug_holder_flood_d 1)

	(set g_plug_ride_enforcer 1)
	
	(cs_vehicle_speed .4)
	(cs_fly_by wall_gap/p11 2)
	(cs_fly_by wall_gap/p12 2)
	(cs_fly_to_and_face wall_gap/p13 wall_gap/p15 10)
;	(cs_fly_by wall_gap/p14 5)
	(cs_vehicle_speed 1)
	(wake objective_floodwall_set)

	(cs_fly_by wall_gap/p15 10)
	(cs_fly_by wall_gap/p16 10)
	(ai_erase ai_current_squad)
)

(script static void test_phantom
	(ai_place gap_phantom)
	(sleep 1)
	(cs_run_command_script gap_phantom cs_gap_phantom)
)

(global boolean g_lower_shield 0)

(script dormant lower_shield
	(if debug (print "containment-field created"))
	(object_create containment_field)

	(sleep_until g_lower_shield 5)
	(if debug (print "lowering the containment-shield"))
	(device_set_position containment_field 1)
	
	(sleep_until (>= (device_get_position containment_field) 1))
	(object_destroy containment_field)
)

(script dormant bsp0_cleanup
	(if debug (print "bsp 0 cleanup..."))
	(object_destroy_containing "bsp0_body")
	(object_destroy_containing "bsp0_weapon")
	(object_destroy_containing "bsp0_equip")
	(object_destroy_containing "bsp0_crate")
	(object_destroy_containing "ins_em")
	(object_destroy_containing "hall_a_em")
	(object_destroy_containing "cond_a_em")
	(object_destroy_containing "hall_b_em")
	(object_destroy_containing "plug_launch_em")
	(object_destroy piston_ins)
	(object_destroy piston_a)
	(object_destroy piston_b)
	(object_destroy piston_c)
	(object_destroy absorber_ins)
	(object_destroy absorber_a)
	(object_destroy absorber_a)
	(object_destroy absorber_b)
	(object_destroy absorber_c)
	(ai_erase insertion_sentinels)
	(ai_erase hall_a_sentinels)
	(ai_erase cond_a_sentinels)
	(ai_erase hall_b_sentinels)
)

(script dormant cs_move_plug
	(wake lower_shield)
	(sound_impulse_start sound\visual_effects\sentinel_wall_power_down none 1)
	(ai_kill plug_launch_sen)
	(ai_kill plug_launch_enforcer)
	
	(begin_random
		(begin
			(sleep (random_range 0 10))
			(object_damage_damage_section plug_launch_em_a "emitter" 2)
		)
		(begin
			(sleep (random_range 0 10))
			(object_damage_damage_section plug_launch_em_b "emitter" 2)
		)
		(begin
			(sleep (random_range 0 10))
			(object_damage_damage_section plug_launch_em_c "emitter" 2)
		)
		(begin
			(sleep (random_range 0 10))
			(object_damage_damage_section plug_launch_em_d "emitter" 2)
		)
		(begin
			(sleep (random_range 0 10))
			(object_damage_damage_section plug_launch_em_e "emitter" 2)
		)
		(begin
			(sleep (random_range 0 10))
			(object_damage_damage_section plug_launch_em_f "emitter" 2)
		)
		(begin
			(sleep (random_range 0 10))
			(object_damage_damage_section plug_launch_em_g "emitter" 2)
		)
		(begin
			(sleep (random_range 0 10))
			(object_damage_damage_section plug_launch_em_h "emitter" 2)
		)
	)
	
	(sleep 30)
;	(device_set_position plug_keylock_a 1)
;	(device_set_position plug_keylock_b 1)
	(device_set_position plug_keylock_c 1)
	(device_set_position plug_keylock_d 1)

	(if debug (print "opening door..."))
	(device_set_position plug_door_a 1)
	(object_create plug_doors_open)
	
	(sleep_until (>= (device_get_position plug_door_a) .5) 10)
	(data_mine_set_mission_segment enc_plug_across)
	(sleep 15)
	(set g_music_06a_04 1)
	(if debug (print "plug down..."))

	(object_dynamic_simulation_disable plug false)

	(sleep 1)
	(device_set_position_track plug plug_down 0)
	(device_animate_position plug 1 2 .05 .25 false)
	
	(sleep_until (and
				(>= (device_get_position plug_door_a) 1)
				(volume_test_objects_all tv_plug_down (players))))
	(object_destroy plug_keylock_c)
	(object_destroy plug_keylock_d)

	(wake chapter_remorse)
	(wake objective_lower_specific_clear)
	
		(sleep 30)
		(device_set_power plug_switch 0)
		(device_set_position plug_switch_housing 0)
		(object_destroy plug_switch)
		(sleep 30)

	(sleep_until (volume_test_objects_all tv_plug_down (ai_actors covenant)) 30 (* 30 10))

	(if debug (print "initializing tartersauce..."))
	(ai_place gap_phantom)
	(game_save)

	(if debug (print "plug across..."))
	(device_set_position_track plug plug_across 0)
	(device_animate_position plug 1 60 5 5 false)
	(sleep 5)
	
	(sleep_until (>= (device_get_position plug) .035) 1)
	(if debug (print "g_lower_shield set to 1"))

	(sleep_until (>= (device_get_position plug) .15) 5)
	(set g_lower_shield 1)

	(sleep_until (>= (device_get_position plug) .5) 5)
	(game_save_no_timeout)
	(wake bsp0_cleanup)

	(sleep_until (>= (device_get_position plug) 1))
	(sleep 30)

	(if debug (print "plug up..."))
	(device_set_position_track plug plug_up 0)
	(device_animate_position plug 1 3 .1 1 false)
	(ai_set_orders plug_holder_enforcer plugholder_enforcer)

	(sleep_until (>= (device_get_position plug) 1) 10)

	(sleep 1)
	(object_dynamic_simulation_disable plug true)

	(set g_music_06a_05 1)

	(device_set_position plug_lock_a 1)
	(device_set_position plug_lock_b 1)
	(device_set_position plug_lock_c 1)
	(device_set_position plug_lock_d 1)
	(device_set_position plug_lock_e 1)
	(device_set_position plug_lock_f 1)
)

(script command_script cs_gap_flood_jump
	(cs_enable_moving true)
;	(cs_move_in_direction -90 3 0)
	(sleep (random_range 20 50))
	(cs_jump 30 5)
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	(sleep (* 30 3))
	(object_can_take_damage (ai_get_object ai_current_actor))
)

(script static void gap_flood_jump
	(cs_run_command_script ai_current_squad cs_gap_flood_jump)
)

;========== PLUGHOLDER SCRIPTS ============================================================================

(script command_script invulnerable
	(cs_enable_moving 1)
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	(sleep_until (>= (ai_combat_status ai_current_actor) ai_combat_status_certain))
	(sleep (* 30 1))
	(object_can_take_damage (ai_get_object ai_current_actor))
)

(script static void make_invulnerable
	(cs_run_command_script ai_current_squad invulnerable)
)

; === players through back walls ======
(script dormant close_plugholder_door
	(sleep 150)
	(sleep_until	(and
					(not (volume_test_objects tv_plugholder_a (players)))
					(not (volume_test_objects tv_plugholder_b (players)))
				)
	)
	(device_set_position plugholder_door 0)
)

;========== Plugholder Spawn Scripts ==========
(global boolean g_plugholder_progress 0)

(global short g_plug_holder_wave_count 0)
(global short g_plug_holder_wave_limit 0)

(global boolean g_plug_holder_loops 0)
	(global boolean g_plug_holder_wave 0)
		(global short g_plug_holder_count 0)
		(global short g_plug_holder_index 0)
		(global short g_plug_holder_limit 0)

(script static void ai_plug_holder_em_a
	(if debug (print "a"))
	(ai_place plug_holder_sen/a)
	(set g_plug_holder_count (+ g_plug_holder_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_holder_em_b
	(if debug (print "b"))
	(ai_place plug_holder_sen/b)
	(set g_plug_holder_count (+ g_plug_holder_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_holder_em_d
	(if debug (print "d"))
	(ai_place plug_holder_sen/d)
	(set g_plug_holder_count (+ g_plug_holder_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_holder_em_f
	(if debug (print "f"))
	(ai_place plug_holder_sen/f)
	(set g_plug_holder_count (+ g_plug_holder_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_holder_em_h
	(if debug (print "h"))
	(ai_place plug_holder_sen/h)
	(set g_plug_holder_count (+ g_plug_holder_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_holder_em_i
	(if debug (print "i"))
	(ai_place plug_holder_sen/i)
	(set g_plug_holder_count (+ g_plug_holder_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)

(script dormant ai_plug_holder_em
	(cond ; g_plug_launch_index is increased when 4 absorbers are destroyed 
		((difficulty_normal) (begin (set g_plug_holder_limit 0) (set g_plug_holder_index 2) (set g_plug_holder_wave_limit 1)))
		((difficulty_heroic) (begin (set g_plug_holder_limit 0) (set g_plug_holder_index 3) (set g_plug_holder_wave_limit 2)))
		((difficulty_legendary) (begin (set g_plug_holder_limit 1) (set g_plug_holder_index 4) (set g_plug_holder_wave_limit 3)))
	)

	(sleep_until ; loop spawner 
		(begin
			(sleep_until (<= (ai_living_count plug_holder_sentinels) g_plug_holder_limit))
			(if g_plugholder_progress (sleep_forever))
			(sleep g_emitter_delay)
			(set g_plug_holder_count 0)
			(set g_plug_holder_wave 0)
			
			(sleep_until ; wave spawner 
				(begin
					(cond
						((and
							(not (unit_is_emitting plug_holder_em_a))
							(> (object_get_health plug_holder_em_a) 0)
							(> (objects_distance_to_object (players) plug_holder_em_a) 6)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_holder_em_a))
						((and
							(not (unit_is_emitting plug_holder_em_b))
							(> (object_get_health plug_holder_em_b) 0)
							(> (objects_distance_to_object (players) plug_holder_em_b) 6)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_holder_em_b))
						((and
							(not (unit_is_emitting plug_holder_em_d))
							(> (object_get_health plug_holder_em_d) 0)
							(> (objects_distance_to_object (players) plug_holder_em_d) 6)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_holder_em_d))
						((and
							(not (unit_is_emitting plug_holder_em_f))
							(> (object_get_health plug_holder_em_f) 0)
							(> (objects_distance_to_object (players) plug_holder_em_f) 6)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_holder_em_f))
						((and
							(not (unit_is_emitting plug_holder_em_h))
							(> (object_get_health plug_holder_em_h) 0)
							(> (objects_distance_to_object (players) plug_holder_em_h) 6)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_holder_em_h))
						((and
							(not (unit_is_emitting plug_holder_em_i))
							(> (object_get_health plug_holder_em_i) 0)
							(> (objects_distance_to_object (players) plug_holder_em_i) 6)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_holder_em_i))
						
						(true	(begin
									(ai_place plug_holder_sen)
									(set g_plug_holder_count (+ g_plug_holder_count 1))
									(if debug (print "placing random sentinel (or none at all)..."))
								)
						)
					)
					(if (= g_plug_holder_count g_plug_holder_index) (set g_plug_holder_wave 1))
					(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
				g_plug_holder_wave)
			)
			(set g_plug_holder_wave_count (+ g_plug_holder_wave_count 1))
			(if (= g_plug_holder_wave_count g_plug_holder_wave_limit) (set g_plugholder_progress 1))
		g_plugholder_progress)
	)
)

(script dormant ai_plug_holder_em_elim
	(sleep_until (<= (ai_living_count plug_holder_enforcer) 0)) ; wake when enforcer is dead 
	(if debug (print "plug holder enforcer dead. initializing eliminators..."))
	(sleep g_emitter_delay)
	
	(sleep_until ; begin eliminator loop 
		(begin
			(sleep_until (<= (ai_living_count plug_holder_sen_elim) 0))
			(if g_plugholder_progress (sleep_forever))
			(if debug (print "eliminator!"))
			(ai_place plug_holder_sen_elim)
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
		g_plugholder_progress)
	)
)

(script dormant ai_plug_holder_flood
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count plug_holder_flood) 1))
			(if g_plugholder_progress (sleep_forever))
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
			(cond
				((volume_test_objects tv_plugholder_a (players))
					(begin
						(if debug (print "placing flood a..."))
						(ai_place plug_holder_flood_c)
						(ai_place plug_holder_flood_d)
					)
				)
				((volume_test_objects tv_plugholder_b (players))
					(begin
						(if debug (print "placing flood b..."))
						(ai_place plug_holder_flood_a)
						(ai_place plug_holder_flood_b)
					)
				)
			)
		g_plugholder_progress)
	)
)

(global boolean g_plug_holder_bk_loops 0)
	(global boolean g_plug_holder_bk_wave 0)
		(global short g_plug_holder_bk_count 0)
		(global short g_plug_holder_bk_index 0)
		(global short g_plug_holder_bk_limit 0)

(script static void ai_plug_holder_bk_em_a
	(if debug (print "a back"))
	(ai_place plug_holder_bk_sen/a)
	(set g_plug_holder_bk_count (+ g_plug_holder_bk_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_holder_bk_em_b
	(if debug (print "b back"))
	(ai_place plug_holder_bk_sen/b)
	(set g_plug_holder_bk_count (+ g_plug_holder_bk_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_holder_bk_em_c
	(if debug (print "c back"))
	(ai_place plug_holder_bk_sen/c)
	(set g_plug_holder_bk_count (+ g_plug_holder_bk_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_holder_bk_em_d
	(if debug (print "d back"))
	(ai_place plug_holder_bk_sen/d)
	(set g_plug_holder_bk_count (+ g_plug_holder_bk_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_holder_bk_em_e
	(if debug (print "e back"))
	(ai_place plug_holder_bk_sen/e)
	(set g_plug_holder_bk_count (+ g_plug_holder_bk_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_plug_holder_bk_em_f
	(if debug (print "f back"))
	(ai_place plug_holder_bk_sen/f)
	(set g_plug_holder_bk_count (+ g_plug_holder_bk_count 1))
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)

(script dormant ai_plug_holder_bk_em
	(sleep_until (<= (ai_living_count plug_holder_sentinels) 2))
	
	(cond ; g_plug_launch_index is increased when 4 absorbers are destroyed 
		((difficulty_normal) (begin (set g_plug_holder_bk_limit 0) (set g_plug_holder_bk_index 1)))
		((difficulty_heroic) (begin (set g_plug_holder_bk_limit 0) (set g_plug_holder_bk_index 2)))
		((difficulty_legendary) (begin (set g_plug_holder_bk_limit 1) (set g_plug_holder_bk_index 2)))
	)

	(sleep_until ; loop spawner 
		(begin
			(sleep_until (<= (ai_living_count plug_holder_sentinels_bk) g_plug_holder_bk_limit))
			(if g_plug_holder_bk_loops (sleep_forever))
			(sleep g_emitter_delay)
			(set g_plug_holder_bk_count 0)
			(set g_plug_holder_bk_wave 0)
			
			(sleep_until ; wave spawner 
				(begin
					(cond
						((and
							(not (unit_is_emitting plug_holder_bk_em_a))
							(> (object_get_health plug_holder_bk_em_a) 0)
							(> (objects_distance_to_object (players) plug_holder_bk_em_a) 0)
							(> (objects_distance_to_object (players) plug_holder_bk_em_a) 8)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_holder_bk_em_a))
						((and
							(not (unit_is_emitting plug_holder_bk_em_b))
							(> (object_get_health plug_holder_bk_em_b) 0)
							(> (objects_distance_to_object (players) plug_holder_bk_em_b) 0)
							(> (objects_distance_to_object (players) plug_holder_bk_em_b) 8)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_holder_bk_em_b))
						((and
							(not (unit_is_emitting plug_holder_bk_em_c))
							(> (object_get_health plug_holder_bk_em_c) 0)
							(> (objects_distance_to_object (players) plug_holder_bk_em_c) 0)
							(> (objects_distance_to_object (players) plug_holder_bk_em_c) 8)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_holder_bk_em_c))
						((and
							(not (unit_is_emitting plug_holder_bk_em_d))
							(> (object_get_health plug_holder_bk_em_d) 0)
							(> (objects_distance_to_object (players) plug_holder_bk_em_d) 0)
							(> (objects_distance_to_object (players) plug_holder_bk_em_d) 8)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_holder_bk_em_d))
						((and
							(not (unit_is_emitting plug_holder_bk_em_e))
							(> (object_get_health plug_holder_bk_em_e) 0)
							(> (objects_distance_to_object (players) plug_holder_bk_em_e) 0)
							(> (objects_distance_to_object (players) plug_holder_bk_em_e) 8)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_holder_bk_em_e))
						((and
							(not (unit_is_emitting plug_holder_bk_em_f))
							(> (object_get_health plug_holder_bk_em_f) 0)
							(> (objects_distance_to_object (players) plug_holder_bk_em_f) 0)
							(> (objects_distance_to_object (players) plug_holder_bk_em_f) 8)
							(<= (random_range 0 10) 3)
						)
						(ai_plug_holder_bk_em_f))

						(true (begin (ai_place plug_holder_bk_sen) (set g_plug_holder_bk_count (+ g_plug_holder_bk_count 1))))
					)
					(if (= g_plug_holder_bk_count g_plug_holder_bk_index) (set g_plug_holder_bk_wave 1))
					(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
				g_plug_holder_bk_wave)
			)
		g_plug_holder_bk_loops)
	)
)

(global boolean g_plugholder_bk_spawn 0)
	(global short g_plugholder_bk_flood_count 0)
	(global short g_plugholder_bk_flood_limit 0)
	(global boolean g_plugholder_bk_a 0)
	(global boolean g_plugholder_bk_b 0)

(script dormant ai_plugholder_flood_bk
	(cond
		((difficulty_normal) (set g_plugholder_bk_flood_limit 4))
		((difficulty_heroic) (set g_plugholder_bk_flood_limit 5))
		((difficulty_legendary) (set g_plugholder_bk_flood_limit 6))
	)
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count plug_holder_flood_bk) 2))
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
			(ai_place plugholder_bk_flood_a)
			(ai_place plugholder_bk_infec_a)
			(set g_plugholder_bk_flood_count (+ g_plugholder_bk_flood_count 1))
			(if (= g_plugholder_bk_flood_count g_plugholder_bk_flood_limit) (set g_plugholder_bk_a 1))
		g_plugholder_bk_a)
	)
	
	(set g_plugholder_bk_flood_count 0)

	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count plug_holder_flood_bk) 2))
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
			(ai_place plugholder_bk_flood_b)
			(ai_place plugholder_bk_infec_b)
			(set g_plugholder_bk_flood_count (+ g_plugholder_bk_flood_count 1))
			(if (= g_plugholder_bk_flood_count g_plugholder_bk_flood_limit) (set g_plugholder_bk_b 1))
		g_plugholder_bk_b)
	)
)

; this script is no longer used because infection forms cannot
;open doors so I just spawn them when i spawn combat forms
(script dormant ai_plugholder_infec_bk_a
	(sleep_until (>= g_plugholder_bk_flood_count 2))
	(if debug (print "infection forms..."))
	(ai_place plugholder_bk_infec_a)

	(sleep_until (>= g_plugholder_bk_flood_count 4))
	(if debug (print "infection forms..."))
	(ai_place plugholder_bk_infec_a)

	(sleep_until (>= g_plugholder_bk_flood_count 6))
	(if debug (print "infection forms..."))
	(ai_place plugholder_bk_infec_a)
)

(script dormant ai_plugholder_infec_bk_b
	(sleep_until (>= g_plugholder_bk_flood_count 2))
	(if debug (print "infection forms..."))
	(ai_place plugholder_bk_infec_b)

	(sleep_until (>= g_plugholder_bk_flood_count 4))
	(if debug (print "infection forms..."))
	(ai_place plugholder_bk_infec_b)

	(sleep_until (>= g_plugholder_bk_flood_count 6))
	(if debug (print "infection forms..."))
	(ai_place plugholder_bk_infec_b)
)

;========== Hall C Scripts =================================================================================
(script dormant kill_hall_c_marines
	(begin_random
		(begin (ai_kill hall_c_marines/a) (sleep 5))
		(begin (ai_kill hall_c_marines/b) (sleep 5))
		(begin (ai_kill hall_c_marines/c) (sleep 5))
		(begin (ai_kill hall_c_marines/d) (sleep 5))
	)
)

(script dormant ai_hall_c_ini
	(ai_place hall_c_marines)
	(ai_place hall_c_flood_far)
	(wake sc_marines_b)
	(ai_place hall_c_infec)
)

(global short g_hall_c_flood_count 0)
(global short g_hall_c_flood_index 20)

(script static void ai_hall_c_flood_d
	(if (< (ai_living_count hall_c_flood) 3)
		(begin
			(ai_place hall_c_flood_d)
			(set g_hall_c_flood_count (+ g_hall_c_flood_count 1))
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
		))
)

(script static void ai_hall_c_flood_e
	(if (< (ai_living_count hall_c_flood) 3)
		(begin
			(ai_place hall_c_flood_e)
			(set g_hall_c_flood_count (+ g_hall_c_flood_count 1))
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
		))
)

(script static void ai_hall_c_flood_f
	(if (< (ai_living_count hall_c_flood) 3)
		(begin
			(ai_place hall_c_flood_f)
			(set g_hall_c_flood_count (+ g_hall_c_flood_count 1))
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
		))
)

(script dormant ai_hall_c_flood_spawn
	(sleep_until
		(begin
			(cond
				((volume_test_objects tv_hall_c_d (players)) (ai_hall_c_flood_e))
				((volume_test_objects tv_hall_c_e (players)) (ai_hall_c_flood_f))
;				((volume_test_objects tv_hall_c_f (players)) (ai_hall_c_flood_f))
			)
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
			(if (>= g_hall_c_flood_count g_hall_c_flood_index) true false)
		)
	)
)

;========== LEDGE A SCRIPTS ================================================================================
(script dormant ai_ledge_a_initial
	(ai_place ledge_a_enforcer)
	(ai_place ledge_a_sen_ini)
	(ai_place ledge_a_flood_ini)
)

(global short g_ledge_a_player_loc 0)

(script dormant ai_ledge_a_location
	(sleep_until
		(begin
			(cond
				((volume_test_objects tv_ledge_a (players)) (set g_ledge_a_player_loc 1))
				((volume_test_objects tv_ledge_a_top_b (players)) (set g_ledge_a_player_loc 2))
				((volume_test_objects tv_ledge_a_top_c (players)) (set g_ledge_a_player_loc 3))
				((volume_test_objects tv_ledge_a_top_d1 (players)) (set g_ledge_a_player_loc 4))
				((volume_test_objects tv_ledge_a_top_d2 (players)) (set g_ledge_a_player_loc 5))
				((volume_test_objects tv_ledge_a_top_e (players)) (set g_ledge_a_player_loc 6))
				((volume_test_objects tv_ledge_a_top_f (players)) (set g_ledge_a_player_loc 7))
				((volume_test_objects tv_ledge_a_top_g (players)) (set g_ledge_a_player_loc 8))
				((volume_test_objects tv_ledge_a_bot_a (players)) (set g_ledge_a_player_loc 9))
				((volume_test_objects tv_ledge_a_bot_b (players)) (set g_ledge_a_player_loc 10))
			)
		false)
	)
)

(script static void ai_ledge_a_flood_b
;	(if g_ledge_a_flood_spawn
;		(begin
			(if debug (print "flood b"))
			(ai_place ledge_a_flood_b)
;			(device_set_position ledge_a_door_a 1)
;			(device_set_position ledge_a_door_b 1)
;		)
;	)
)

(script static void ai_ledge_a_flood_c
;	(if g_ledge_a_flood_spawn
;		(begin
			(if debug (print "flood c"))
			(ai_place ledge_a_flood_c)
;			(device_set_position ledge_a_door_b 1)
;			(device_set_position ledge_a_door_c 1)
;		)
;	)
)

(script static void ai_ledge_a_flood_e
;	(if g_ledge_a_flood_spawn
;		(begin
			(if debug (print "flood e"))
			(ai_place ledge_a_flood_e)
;			(device_set_position ledge_a_door_d 1)
;			(device_set_position ledge_a_door_e 1)
;		)
;	)
)

(script static void ai_ledge_a_flood_f
;	(if g_ledge_a_flood_spawn
;		(begin
			(if debug (print "flood f"))
			(ai_place ledge_a_flood_f)
;			(device_set_position ledge_a_door_e 1)
;			(device_set_position ledge_a_door_f 1)
;		)
;	)
)

(global boolean g_ledge_a_spawn 0)
;(global short g_ledge_a_flood_limit 0)

(script dormant ai_ledge_a_flood_spawn
;*	(cond
		((difficulty_normal) (set g_ledge_a_flood_limit 2))
		((difficulty_heroic) (set g_ledge_a_flood_limit 4))
		((difficulty_legendary) (set g_ledge_a_flood_limit 6))
	)
*;
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count ledge_a_flood) 2))
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
			(cond
				((= g_ledge_a_player_loc 2) (ai_ledge_a_flood_b))
				((= g_ledge_a_player_loc 3) (ai_ledge_a_flood_c))
				((= g_ledge_a_player_loc 6) (ai_ledge_a_flood_e))
				((= g_ledge_a_player_loc 7) (ai_ledge_a_flood_f))
			)
			(or ; exit conditions 
				(>= (ai_spawn_count ledge_a_flood) 16)
				g_ledge_a_spawn
			)
		)
	)

	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count ledge_a_flood) 2))
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
			(cond
				((= g_ledge_a_player_loc 6) (ai_ledge_a_flood_e))
				((= g_ledge_a_player_loc 7) (ai_ledge_a_flood_f))
			)
			(or ; exit conditions 
				(>= (ai_spawn_count ledge_a_flood) 32)
				g_ledge_a_spawn
			)
		)
	)
)

(script dormant ai_ledge_a_flood_bot_a
	(sleep_until (volume_test_objects tv_ledge_a_bot_a (players)))
	(ai_place ledge_a_flood_bot_a)
)

(script dormant ai_ledge_a_flood_bot_b
	(sleep_until (volume_test_objects tv_ledge_a_bot_b (players)))
	(ai_place ledge_a_flood_bot_b)
)

(global boolean g_ledge_a_loops 0)
	(global boolean g_ledge_a_wave 0)
		(global short g_ledge_a_sen_limit 0)
		(global short g_ledge_a_count 0)
		(global short g_ledge_a_index 0)

(script static void ai_ledge_a_em_a
	(if debug (print "a"))
	(ai_place ledge_a_sen/a)
	(set g_ledge_a_count (+ g_ledge_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_ledge_a_em_b
	(if debug (print "b"))
	(ai_place ledge_a_sen/b)
	(set g_ledge_a_count (+ g_ledge_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_ledge_a_em_c
	(if debug (print "c"))
	(ai_place ledge_a_sen/c)
	(set g_ledge_a_count (+ g_ledge_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_ledge_a_em_d
	(if debug (print "d"))
	(ai_place ledge_a_sen/d)
	(set g_ledge_a_count (+ g_ledge_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_ledge_a_em_e
	(if debug (print "e"))
	(ai_place ledge_a_sen/e)
	(set g_ledge_a_count (+ g_ledge_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_ledge_a_em_f
	(if debug (print "f"))
	(ai_place ledge_a_sen/f)
	(set g_ledge_a_count (+ g_ledge_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_ledge_a_em_g
	(if debug (print "g"))
	(ai_place ledge_a_sen/g)
	(set g_ledge_a_count (+ g_ledge_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_ledge_a_em_h
	(if debug (print "h"))
	(ai_place ledge_a_sen/h)
	(set g_ledge_a_count (+ g_ledge_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)
(script static void ai_ledge_a_em_i
	(if debug (print "i"))
	(ai_place ledge_a_sen/i)
	(set g_ledge_a_count (+ g_ledge_a_count 1)) 
	(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
)

(script dormant ai_ledge_a_emitters
	(cond ; set variables 
		((difficulty_normal) (begin (set g_ledge_a_sen_limit 0) (set g_ledge_a_index 2)))
		((difficulty_heroic) (begin (set g_ledge_a_sen_limit 0) (set g_ledge_a_index 2)))
		((difficulty_legendary) (begin (set g_ledge_a_sen_limit 1) (set g_ledge_a_index 3)))
	)

	(sleep_until ; loop spawner 
		(begin
			(sleep_until (<= (ai_living_count ledge_a_sentinels) g_ledge_a_sen_limit))
			(sleep g_emitter_delay)
			(set g_ledge_a_count 0)
			(set g_ledge_a_wave 0)
			
			(sleep_until ; wave spawner 
				(begin
					(cond
						((and
							(not (unit_is_emitting ledge_a_em_a))
							(> (object_get_health ledge_a_em_a) 0)
							(> (objects_distance_to_object (players) ledge_a_em_a) 0)
							(< (objects_distance_to_object (players) ledge_a_em_a) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_ledge_a_em_a))
						((and
							(not (unit_is_emitting ledge_a_em_b))
							(> (object_get_health ledge_a_em_b) 0)
							(> (objects_distance_to_object (players) ledge_a_em_b) 0)
							(< (objects_distance_to_object (players) ledge_a_em_b) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_ledge_a_em_b))
						((and
							(not (unit_is_emitting ledge_a_em_c))
							(> (object_get_health ledge_a_em_c) 0)
							(> (objects_distance_to_object (players) ledge_a_em_c) 0)
							(< (objects_distance_to_object (players) ledge_a_em_c) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_ledge_a_em_c))
						((and
							(not (unit_is_emitting ledge_a_em_d))
							(> (object_get_health ledge_a_em_d) 0)
							(> (objects_distance_to_object (players) ledge_a_em_d) 0)
							(< (objects_distance_to_object (players) ledge_a_em_d) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_ledge_a_em_d))
						((and
							(not (unit_is_emitting ledge_a_em_e))
							(> (object_get_health ledge_a_em_e) 0)
							(> (objects_distance_to_object (players) ledge_a_em_e) 0)
							(< (objects_distance_to_object (players) ledge_a_em_e) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_ledge_a_em_e))
						((and
							(not (unit_is_emitting ledge_a_em_f))
							(> (object_get_health ledge_a_em_f) 0)
							(> (objects_distance_to_object (players) ledge_a_em_f) 0)
							(< (objects_distance_to_object (players) ledge_a_em_f) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_ledge_a_em_f))
						((and
							(not (unit_is_emitting ledge_a_em_g))
							(> (object_get_health ledge_a_em_g) 0)
							(> (objects_distance_to_object (players) ledge_a_em_g) 0)
							(< (objects_distance_to_object (players) ledge_a_em_g) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_ledge_a_em_g))
						((and
							(not (unit_is_emitting ledge_a_em_h))
							(> (object_get_health ledge_a_em_h) 0)
							(> (objects_distance_to_object (players) ledge_a_em_h) 0)
							(< (objects_distance_to_object (players) ledge_a_em_h) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_ledge_a_em_h))
						((and
							(not (unit_is_emitting ledge_a_em_i))
							(> (object_get_health ledge_a_em_i) 0)
							(> (objects_distance_to_object (players) ledge_a_em_i) 0)
							(< (objects_distance_to_object (players) ledge_a_em_i) 9)
							(<= (random_range 0 10) 3)
						)
						(ai_ledge_a_em_i))
					)
					(if (= g_ledge_a_count g_ledge_a_index) (set g_ledge_a_wave 1))
					(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
				g_ledge_a_wave)
			)
		g_ledge_a_loops)
	)
)

;========== CONDUIT B SCRIPTS ================================================================================
(global short cond_b_locator 0)
(global boolean cond_b_flood_a_spawn 0)
(global boolean cond_b_flood_b_spawn 0)
(global boolean cond_b_flood_c_spawn 0)
(global short cond_b_flood_count 0)
(global short cond_b_flood_limit 4) ; number of waves spawned 

(script dormant kill_cond_b_marines
	(begin_random
		(begin (ai_kill cond_b_humans/a) (sleep 5))
		(begin (ai_kill cond_b_humans/b) (sleep 5))
		(begin (ai_kill cond_b_humans/c) (sleep 5))
	)
)

(script dormant conduit_b_locator
	(sleep_until
		(begin
			(cond
				((volume_test_objects tv_cond_b_a1 (players)) (set cond_b_locator 1))
				((volume_test_objects tv_cond_b_a2 (players)) (set cond_b_locator 2))
				((volume_test_objects tv_cond_b_b1 (players)) (set cond_b_locator 3))
				((volume_test_objects tv_cond_b_b2 (players)) (set cond_b_locator 4))
				((volume_test_objects tv_cond_b_c (players)) (set cond_b_locator 5))
			)
		false)
	)
)

(script dormant ai_cond_b_carrier_a
	(sleep_until (or (= cond_b_flood_count 2) (volume_test_objects tv_cond_b_a2 (players))))
	(ai_place cond_b_carrier_a)
	
	(sleep_until (= cond_b_flood_count 4))
	(if (> cond_b_locator 1) (sleep_forever))
	(ai_place cond_b_carrier_a)

	(sleep_until (= cond_b_flood_count 6))
	(if (> cond_b_locator 1) (sleep_forever))
	(ai_place cond_b_carrier_a)
)	

(script command_script cs_cond_b_damage_enf
	(sleep 5)
	(object_damage_damage_section (ai_get_object cond_b_enforcer/a) "l_arm" 1)
	(object_damage_damage_section (ai_get_object cond_b_enforcer/a) "l_rocket" 1)
	(object_damage_damage_section (ai_get_object cond_b_enforcer/a) "l_thruster" 1)
	(object_damage_damage_section (ai_get_object cond_b_enforcer/a) "l_shield_gen" 1)
	(object_damage_damage_section (ai_get_object cond_b_enforcer/a) "r_arm" 1)
	(object_damage_damage_section (ai_get_object cond_b_enforcer/a) "r_rocket" 1)
	(object_damage_damage_section (ai_get_object cond_b_enforcer/a) "r_thruster" 1)
	(object_damage_damage_section (ai_get_object cond_b_enforcer/a) "r_shield_gen" 1)
	(sleep 1)
	(object_damage_damage_section (ai_get_object cond_b_enforcer/a) "r_shield_gen" 1)
	(object_damage_damage_section (ai_get_object cond_b_enforcer/a) "r_arm" 1)
	(object_damage_damage_section (ai_get_object cond_b_enforcer/a) "r_rocket" 1)
	(object_damage_damage_section (ai_get_object cond_b_enforcer/a) "l_thruster" 1)
)

(script dormant ai_cond_b_b_em
	(sleep_until (<= (ai_living_count cond_b_sen_b) 0))
	(sleep g_emitter_delay)
	(if (= (random_range 0 2) 0) (ai_place cond_b_sen_b/a) (ai_place cond_b_sen_b/b))
)

(script dormant ai_cond_b_flood_spawn
	(ai_place cond_b_flood_a_ini_a)
	(ai_place cond_b_flood_a_ini_b)
	(ai_place cond_b_flood_a_ini_c)

	(cond
		((difficulty_normal) (set cond_b_flood_limit 1))
		((difficulty_heroic) (set cond_b_flood_limit 2))
		((difficulty_legendary) (set cond_b_flood_limit 4))
	)

	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count cond_b_flood) 1))
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
			(if (= cond_b_locator 1)
				(begin
					(ai_place cond_b_flood_a)
					(set cond_b_flood_count (+ cond_b_flood_count 1))
					(if (= cond_b_flood_count cond_b_flood_limit) (set cond_b_flood_a_spawn 1))
					(sleep 30)
					(ai_magically_see_object cond_b_flood (player0))
					(ai_magically_see_object cond_b_flood (player1))
				)
			)
		cond_b_flood_a_spawn)
	)

	(set cond_b_flood_count 0)

	(sleep_until
	
		(begin
			(sleep_until (<= (ai_living_count cond_b_flood) 1))
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
			(if (= cond_b_locator 3)
				(begin
					(ai_place cond_b_flood_b)
					(set cond_b_flood_count (+ cond_b_flood_count 1))
					(if (= cond_b_flood_count cond_b_flood_limit) (set cond_b_flood_b_spawn 1))
					(sleep 30)
					(ai_magically_see_object cond_b_flood (player0))
					(ai_magically_see_object cond_b_flood (player1))
				)
			)
		cond_b_flood_b_spawn)
	)

	(set cond_b_flood_count 0)

	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count cond_b_flood) 1))
			(sleep (random_range g_sleep_lower_bound g_sleep_upper_bound))
			(if (= cond_b_locator 3)
				(begin
					(ai_place cond_b_flood_c)
					(set cond_b_flood_count (+ cond_b_flood_count 1))
					(if (= cond_b_flood_count cond_b_flood_limit) (set cond_b_flood_c_spawn 1))
					(sleep 30)
					(ai_magically_see_object cond_b_flood (player0))
					(ai_magically_see_object cond_b_flood (player1))
				)
			)
		cond_b_flood_c_spawn)
	)
)

(script command_script cs_cond_b_sen_tube_a
	(cs_enable_pathfinding_failsafe true)
;	(cs_set_pathfinding_radius .1)
	(cs_fly_to_and_face cond_b/p0 cond_b/p1)
	(cs_fly_to cond_b/p1)
	(cs_fly_to cond_b/p2)
	(cs_fly_to cond_b/p3)
)

(script command_script cs_cond_b_sen_tube_b
	(cs_enable_pathfinding_failsafe true)
;	(cs_set_pathfinding_radius .1)
	(cs_fly_to_and_face cond_b/p1 cond_b/p2)
	(cs_fly_to cond_b/p2)
	(cs_fly_to cond_b/p3)
)

(script dormant ai_cond_b_sen_tube_b
	(if (= (random_range 0 2) 0) (ai_place cond_b_sen_tube_b/a) (ai_place cond_b_sen_tube_b/b))
	(if (= (random_range 0 2) 0) (ai_place cond_b_sen_tube_b/c) (ai_place cond_b_sen_tube_b/d))
	(sleep 5)
	(cs_run_command_script cond_b_sen_tube_b/a cs_cond_b_sen_tube_a)
	(cs_run_command_script cond_b_sen_tube_b/b cs_cond_b_sen_tube_a)
	(cs_run_command_script cond_b_sen_tube_b/c cs_cond_b_sen_tube_b)
	(cs_run_command_script cond_b_sen_tube_b/d cs_cond_b_sen_tube_b)
)

;========= LEDGE C SCRIPTS =================================================================================
(script dormant slide_a_player0
	(sleep_until (volume_test_object tv_slide_a (player0)))
;	(set g_music_06a_09 1)
	(object_cannot_take_damage (player0))
	(sleep_until (not (volume_test_objects tv_slide_a (player0))))
	(object_can_take_damage (player0))
)
(script dormant slide_a_player1
	(sleep_until (volume_test_object tv_slide_a (player1)))
;	(set g_music_06a_09 1)
	(object_cannot_take_damage (player1))
	(sleep_until (not (volume_test_objects tv_slide_a (player1))))
	(object_can_take_damage (player1))
)
(script dormant slide_b_player0
	(sleep_until (volume_test_object tv_slide_b (player0)))
	(object_cannot_take_damage (player0))
	(sleep_until (not (volume_test_objects tv_slide_b (player0))))
	(object_can_take_damage (player0))
)
(script dormant slide_b_player1
	(sleep_until (volume_test_object tv_slide_b (player1)))
	(object_cannot_take_damage (player1))
	(sleep_until (not (volume_test_objects tv_slide_b (player1))))
	(object_can_take_damage (player1))
)

(global boolean ledge_c_spawn 1)

(script dormant ai_ledge_c_flood_ini
	(ai_place ledge_c_flood_fr)
	(ai_place ledge_c_flood_dead)
	(ai_kill_silent ledge_c_flood_dead)
	(sleep 1)
	
	(sleep_until (<= (ai_living_count ledge_c_flood) 0))
	(if (and ledge_c_spawn (volume_test_objects_all tv_ledge_c_fr (players))) (ai_place ledge_c_flood_bk))
)

(global short ledge_c_infec_count 0)
(global short ledge_c_infec_limit 3)

(script dormant ai_ledge_c_infection_spawn
	(cond
		((difficulty_normal) (set ledge_c_infec_limit 3))
		((difficulty_heroic) (set ledge_c_infec_limit 6))
		((difficulty_legendary) (set ledge_c_infec_limit 9))
	)
	
	(sleep_until (volume_test_objects_all tv_ledge_c_fr (players)))
	(sleep (random_range 120 180))
	
	(sleep_until
		(begin
			(ai_place ledge_c_infec_fr)
			(set ledge_c_infec_count (+ ledge_c_infec_count 1))
			(sleep_until (<= (ai_swarm_count ledge_c_infec_fr) 5))
			(= ledge_c_infec_count ledge_c_infec_limit)
		)
	)
)

(global boolean g_ledge_c_phantom_start 0)
(global boolean g_ledge_c_phantom_1 0)

(script command_script cs_ledge_c_phantom
	(cs_enable_pathfinding_failsafe 1)
	(cs_vehicle_speed 1)
;*	(cs_turn_sharpness true .3)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_shoot_point true ledge_c_phantom/shoot0)
					(sleep (random_range 30 90))
				)
				(begin
					(cs_shoot_point true ledge_c_phantom/shoot1)
					(sleep (random_range 30 90))
				)
				(begin
					(cs_shoot_point true ledge_c_phantom/shoot2)
					(sleep (random_range 30 90))
				)
			)
		g_ledge_c_phantom_start)
	)
*;
	(cs_look true ledge_c_phantom/p1)
	(sleep_until g_ledge_c_phantom_start)

	(cs_look false ledge_c_phantom/p1)
	(cs_turn_sharpness true .7)

	(sleep_until g_ledge_c_phantom_1 5 150)
;	(cs_look true ledge_c_phantom/p2)
	(cs_look true ledge_c_phantom/p3)
	(sleep 60)
	(cs_look false ledge_c_phantom/p3)
;	(cs_fly_to_and_face ledge_c_phantom/p3 ledge_c_phantom/p4)
	(cs_fly_by ledge_c_phantom/p2 4)
	(cs_fly_by ledge_c_phantom/p3 4)
	(cs_fly_by ledge_c_phantom/p4 6)
	(cs_fly_by ledge_c_phantom/p5 6)
	(cs_fly_by ledge_c_phantom/p6 10)
	(ai_erase ai_current_squad)
)

;========= 	QZ INITIAL SCRIPTS =============================================================================
(global boolean g_mortar_fire 0)

(script dormant cs_mortar_a
	(sleep_until	
		(begin
			(begin_random
				(begin
					(effect_new effects\design\mortar_emitter\mortar_emitter mortar_a)
					(sleep (random_range 15 45))
				)
				(begin
					(effect_new effects\design\mortar_emitter\mortar_emitter mortar_b)
					(sleep (random_range 15 45))
				)
				(begin
					(effect_new effects\design\mortar_emitter\mortar_emitter mortar_c)
					(sleep (random_range 15 45))
				)
				(begin
					(effect_new effects\design\mortar_emitter\mortar_emitter mortar_d)
					(sleep (random_range 15 45))
				)
				(begin
					(effect_new effects\design\mortar_emitter\mortar_emitter mortar_e)
					(sleep (random_range 15 45))
				)
				(begin
					(effect_new effects\design\mortar_emitter\mortar_emitter mortar_f)
					(sleep (random_range 15 45))
				)
			)
		g_mortar_fire)
	)
)

(script dormant cs_mortar_b
	(sleep_until	
		(begin
			(begin_random
				(begin
					(effect_new effects\design\mortar_emitter\mortar_emitter mortar_a)
					(sleep (random_range 15 45))
				)
				(begin
					(effect_new effects\design\mortar_emitter\mortar_emitter mortar_b)
					(sleep (random_range 15 45))
				)
				(begin
					(effect_new effects\design\mortar_emitter\mortar_emitter mortar_c)
					(sleep (random_range 15 45))
				)
				(begin
					(effect_new effects\design\mortar_emitter\mortar_emitter mortar_d)
					(sleep (random_range 15 45))
				)
				(begin
					(effect_new effects\design\mortar_emitter\mortar_emitter mortar_e)
					(sleep (random_range 15 45))
				)
				(begin
					(effect_new effects\design\mortar_emitter\mortar_emitter mortar_f)
					(sleep (random_range 15 45))
				)
			)
		g_mortar_fire)
	)
)

(script command_script cs_go_to_bridge
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to qz_ini/p0)
	(cs_go_to qz_ini/p1)
	(cs_go_to qz_ini/bridge)
)

(script dormant ai_cov_ins_pod_a
; insertion pod A 
	(ai_place qz_ini_ins_pods/a)
	(object_create qz_ent_pod_a)
	(objects_attach qz_ent_pod_a "pod_attach" (ai_vehicle_get qz_ini_ins_pods/a) "pod_attach")
	(sleep 1)
	
	(device_set_position qz_ent_pod_a 1)
	(sleep_until (>= (device_get_position qz_ent_pod_a) 1) 1)
	
	(objects_detach qz_ent_pod_a (ai_vehicle_get qz_ini_ins_pods/a))
	(object_destroy qz_ent_pod_a)
	
	(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get qz_ini_ins_pods/a) "door" 500)
	(sleep 15)
	(ai_vehicle_exit qz_ini_ins_pods/a)
)

(script dormant ai_cov_ins_pod_b
; insertion pod B 
	(ai_place qz_ini_ins_pods/b)
	(object_create qz_ent_pod_b)
	(objects_attach qz_ent_pod_b "pod_attach" (ai_vehicle_get qz_ini_ins_pods/b) "pod_attach")
	(sleep 1)
	
	(device_set_position qz_ent_pod_b 1)
	(sleep_until (>= (device_get_position qz_ent_pod_b) 1) 1)
	
	(objects_detach qz_ent_pod_b (ai_vehicle_get qz_ini_ins_pods/b))
	(object_destroy qz_ent_pod_b)
	
	(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get qz_ini_ins_pods/b) "door" 500)
	(sleep 15)
	(ai_vehicle_exit qz_ini_ins_pods/b)
)

(script dormant ai_cov_ins_pod_c
; insertion pod C 
	(ai_place qz_ini_ins_pods/c)
	(object_create qz_ent_pod_c)
	(objects_attach qz_ent_pod_c "pod_attach" (ai_vehicle_get qz_ini_ins_pods/c) "pod_attach")
	(sleep 1)
	
	(device_set_position qz_ent_pod_c 1)
	(sleep_until (>= (device_get_position qz_ent_pod_c) 1) 1)
	
	(objects_detach qz_ent_pod_c (ai_vehicle_get qz_ini_ins_pods/c))
	(object_destroy qz_ent_pod_c)
	
	(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get qz_ini_ins_pods/c) "door" 500)
	(sleep 15)
	(ai_vehicle_exit qz_ini_ins_pods/c)
	(sleep 30)
	(cs_run_command_script qz_ini_ins_pods/c cs_go_to_bridge)

)

(script dormant ai_cov_ins_pod_d
; insertion pod D 
	(ai_place qz_ini_ins_pods/d)
	(object_create qz_ent_pod_d)
	(objects_attach qz_ent_pod_d "pod_attach" (ai_vehicle_get qz_ini_ins_pods/d) "pod_attach")
	(sleep 1)
	
	(device_set_position qz_ent_pod_d 1)
	(sleep_until (>= (device_get_position qz_ent_pod_d) 1) 1)
	
	(objects_detach qz_ent_pod_d (ai_vehicle_get qz_ini_ins_pods/d))
	(object_destroy qz_ent_pod_d)
	
	(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get qz_ini_ins_pods/d) "door" 500)
	(sleep 15)
	(ai_vehicle_exit qz_ini_ins_pods/d)
	(sleep 30)
	(cs_run_command_script qz_ini_ins_pods/d cs_go_to_bridge)
	(unit_set_maximum_vitality (ai_get_unit qz_ini_ins_pods/d) 1 0)
;	(unit_set_current_vitality (ai_get_unit qz_ini_ins_pods/d) 1 0)
)

(script dormant ai_cov_ins_pod_e
; insertion pod E 
	(ai_place qz_ini_ins_pods/e)
	(object_create qz_ent_pod_e)
	(objects_attach qz_ent_pod_e "pod_attach" (ai_vehicle_get qz_ini_ins_pods/e) "pod_attach")
	(sleep 1)
	
	(device_set_position qz_ent_pod_e 1)
	(sleep_until (>= (device_get_position qz_ent_pod_e) 1) 1)
	
	(objects_detach qz_ent_pod_e (ai_vehicle_get qz_ini_ins_pods/e))
	(object_destroy qz_ent_pod_e)
	
	(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get qz_ini_ins_pods/e) "door" 500)
	(sleep 15)
	(ai_vehicle_exit qz_ini_ins_pods/e)
	(sleep 30)
	(cs_run_command_script qz_ini_ins_pods/e cs_go_to_bridge)
	(unit_set_maximum_vitality (ai_get_unit qz_ini_ins_pods/e) 1 0)
;	(unit_set_current_vitality (ai_get_unit qz_ini_ins_pods/e) 1 0)
)

(script dormant ai_qz_ini_turrets
	(ai_vehicle_enter qz_ini_flood (ai_get_unit  qz_ini_turrets))
)

(script dormant ai_cov_ins_pods
	(begin_random
		(begin (wake ai_cov_ins_pod_a) (sleep (random_range 0 15)))
		(begin (wake ai_cov_ins_pod_b) (sleep (random_range 0 15)))
;	)
;
;	(sleep_until (volume_test_objects tv_qz_bridge (players)) 10)
;	(begin_random
		(begin (wake ai_cov_ins_pod_c) (sleep (random_range 0 15)))
;		(begin (wake ai_cov_ins_pod_d) (sleep (random_range 0 15)))
		(begin (wake ai_cov_ins_pod_e) (sleep (random_range 0 15)))
	)
	
	(sleep 120)
	(wake sc_qz_initial)
)

(script dormant ai_qz_ini_exit_turrets
	(sleep_until (or (<= (ai_living_count qz_ini_flood) 1) (volume_test_objects tv_cov_defense (players))))
	(ai_vehicle_exit qz_ini_ins_pods)
)

(script dormant cs_crash_factory
	(sleep 90)
	(sleep_until	(or
					(objects_can_see_object (players) factory 30)
					(volume_test_objects tv_qz_camp (players))
				)
	30 180)
	(sleep 30)
	(device_set_position factory 1)
	(sound_impulse_start sound\visual_effects\shq_factory_explode\factory_explode factory_sound 1)
	(set g_mortar_fire 1)
	
	(sleep_until (>= (device_get_position factory) .025) 10)
	(wake ai_cov_ins_pods)
	
	(sleep_until (>= (device_get_position factory) .1))
	(object_destroy factory)
)

(global boolean g_qz_ini_cave 0)

(script dormant ai_qz_ini_flood
	(ai_place qz_initial_flood_camp)
	(ai_play_line_on_object qz_ini_sound_a 0180)
	(ai_play_line_on_object qz_ini_sound_b 0180)
	
	(sleep_until (<= (ai_living_count qz_initial_flood_camp) 2))
	(if (not g_qz_ini_cave)
						(begin
							(ai_place qz_initial_flood_camp)
							(ai_play_line_on_object qz_ini_sound_a 0180)
							(ai_play_line_on_object qz_ini_sound_b 0180)
						)
	)
)

;========= COVENANT DEFENSE SCRIPTS ==========================================================================
(global boolean g_qz_cov_def_spawn 1)
(global short g_qz_cov_def_limit 0)
(global short g_qz_cov_def_count 0)
(global short g_cov_def_flood_advance 2)

(script static void qz_cov_def_abc
	(if debug (print "wave abc"))
	(ai_place qz_cov_def_flood_a)
	(ai_place qz_cov_def_flood_b)
	(ai_place qz_cov_def_flood_c)
	(sleep 5)

	(ai_play_line_on_object qz_cov_def_sound_a 0180)
	(ai_play_line_on_object qz_cov_def_sound_b 0180)
	(ai_play_line_on_object qz_cov_def_sound_c 0180)

;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_a 0.75)
;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_b 0.75)
;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_c 0.75)
	(ai_set_orders qz_cov_def_cov qz_cov_def_cov_a)

	(sleep_until (<= (ai_nonswarm_count qz_cov_def_flood) g_cov_def_flood_advance) 30 (* 30 15))
	(ai_set_orders qz_cov_def_flood qz_cov_def_hill)
	
	(sleep_until (<= (ai_nonswarm_count qz_cov_def_flood) 1))
)

(script static void qz_cov_def_bcd
	(if debug (print "wave bcd"))
	(ai_place qz_cov_def_flood_b)
	(ai_place qz_cov_def_flood_c)
	(ai_place qz_cov_def_flood_d)
	(sleep 5)

	(ai_play_line_on_object qz_cov_def_sound_b 0180)
	(ai_play_line_on_object qz_cov_def_sound_c 0180)
	(ai_play_line_on_object qz_cov_def_sound_d 0180)

;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_b 0.75)
;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_c 0.75)
;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_d 0.75)
	(ai_set_orders qz_cov_def_cov qz_cov_def_cov_ab)

	(sleep_until (<= (ai_nonswarm_count qz_cov_def_flood) g_cov_def_flood_advance) 30 (* 30 15))
	(ai_set_orders qz_cov_def_flood qz_cov_def_hill)
	
	(sleep_until (<= (ai_nonswarm_count qz_cov_def_flood) 1))
)

(script static void qz_cov_def_def
	(if debug (print "wave def"))
	(ai_place qz_cov_def_flood_d)
	(ai_place qz_cov_def_flood_e)
	(ai_place qz_cov_def_flood_f)
	(sleep 5)

	(ai_play_line_on_object qz_cov_def_sound_d 0180)
	(ai_play_line_on_object qz_cov_def_sound_e 0180)
	(ai_play_line_on_object qz_cov_def_sound_f 0180)

;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_d 0.75)
;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_e 0.75)
;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_f 0.75)
	(ai_set_orders qz_cov_def_cov qz_cov_def_cov_bc)

	(sleep_until (<= (ai_nonswarm_count qz_cov_def_flood) g_cov_def_flood_advance) 30 (* 30 15))
	(ai_set_orders qz_cov_def_flood qz_cov_def_hill)
	
	(sleep_until (<= (ai_nonswarm_count qz_cov_def_flood) 1))
)

(script static void qz_cov_def_efg
	(if debug (print "wave efg"))
	(ai_place qz_cov_def_flood_e)
	(ai_place qz_cov_def_flood_f)
	(ai_place qz_cov_def_flood_g)
	(sleep 5)
	
	(ai_play_line_on_object qz_cov_def_sound_e 0180)
	(ai_play_line_on_object qz_cov_def_sound_f 0180)
	(ai_play_line_on_object qz_cov_def_sound_g 0180)

;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_e 0.75)
;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_f 0.75)
;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_g 0.75)
	(ai_set_orders qz_cov_def_cov qz_cov_def_cov_c)

	(sleep_until (<= (ai_nonswarm_count qz_cov_def_flood) g_cov_def_flood_advance) 30 (* 30 15))
	(ai_set_orders qz_cov_def_flood qz_cov_def_hill)
	
	(sleep_until (<= (ai_nonswarm_count qz_cov_def_flood) 1))
)

(script static void qz_cov_def_ag
	(if debug (print "wave ag"))
	(ai_place qz_cov_def_flood_a)
	(ai_place qz_cov_def_flood_g)
	(sleep 5)

	(ai_play_line_on_object qz_cov_def_sound_a 0180)
	(ai_play_line_on_object qz_cov_def_sound_g 0180)

;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_a 0.75)
;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_g 0.75)
	(ai_set_orders qz_cov_def_cov qz_cov_def_cov_ac)

	(sleep_until (<= (ai_nonswarm_count qz_cov_def_flood) g_cov_def_flood_advance) 30 (* 30 15))
	(ai_set_orders qz_cov_def_flood qz_cov_def_hill)
	
	(sleep_until (<= (ai_nonswarm_count qz_cov_def_flood) 1))
)

(script static void qz_cov_def_d
	(if debug (print "wave d"))
	(ai_place qz_cov_def_flood_d)
	(sleep 5)

	(ai_play_line_on_object qz_cov_def_sound_d 0180)

;	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0300_grv qz_cov_def_sound_d 0.75)
	(ai_set_orders qz_cov_def_cov qz_cov_def_cov_b)

	(sleep_until (<= (ai_nonswarm_count qz_cov_def_flood) g_cov_def_flood_advance) 30 (* 30 15))
	(ai_set_orders qz_cov_def_flood qz_cov_def_hill)
	
	(sleep_until (<= (ai_nonswarm_count qz_cov_def_flood) 1))
)

(script dormant ai_qz_cov_def_flood_spawn
	(cond
		((difficulty_normal) (set g_qz_cov_def_limit 2))
		((difficulty_heroic) (set g_qz_cov_def_limit 4))
		((difficulty_legendary) (set g_qz_cov_def_limit 6))
	)

	(begin_random
		(if g_qz_cov_def_spawn
			(begin
				(set g_qz_cov_def_count (+ g_qz_cov_def_count 1))
				(qz_cov_def_abc)
				(if (= g_qz_cov_def_count g_qz_cov_def_limit) (set g_qz_cov_def_spawn 0))
				(sleep (* 30 10))
			)
		)

		(if g_qz_cov_def_spawn
			(begin
				(set g_qz_cov_def_count (+ g_qz_cov_def_count 1))
				(qz_cov_def_bcd)
				(if (= g_qz_cov_def_count g_qz_cov_def_limit) (set g_qz_cov_def_spawn 0))
				(sleep (* 30 10))
			)
		)

		(if g_qz_cov_def_spawn
			(begin
				(set g_qz_cov_def_count (+ g_qz_cov_def_count 1))
				(qz_cov_def_def)
				(if (= g_qz_cov_def_count g_qz_cov_def_limit) (set g_qz_cov_def_spawn 0))
				(sleep (* 30 10))
			)
		)

		(if g_qz_cov_def_spawn
			(begin
				(set g_qz_cov_def_count (+ g_qz_cov_def_count 1))
				(qz_cov_def_efg)
				(if (= g_qz_cov_def_count g_qz_cov_def_limit) (set g_qz_cov_def_spawn 0))
				(sleep (* 30 10))
			)
		)
				
		(if g_qz_cov_def_spawn
			(begin
				(set g_qz_cov_def_count (+ g_qz_cov_def_count 1))
				(qz_cov_def_ag)
				(if (= g_qz_cov_def_count g_qz_cov_def_limit) (set g_qz_cov_def_spawn 0))
				(sleep (* 30 10))
			)
		)

		(if g_qz_cov_def_spawn
			(begin
				(set g_qz_cov_def_count (+ g_qz_cov_def_count 1))
				(qz_cov_def_d)
				(if (= g_qz_cov_def_count g_qz_cov_def_limit) (set g_qz_cov_def_spawn 0))
				(sleep (* 30 10))
			)
		)
	)
)

(script dormant ai_qz_cov_def_carrier
	(sleep_until (= g_qz_cov_def_count 2))
	(game_save_no_timeout)
	(ai_place qz_cov_def_carrier)

	(sleep_until (= g_qz_cov_def_count 4))
	(game_save_no_timeout)
	(ai_place qz_cov_def_carrier)

	(sleep_until (= g_qz_cov_def_count 6))
	(game_save_no_timeout)
	(ai_place qz_cov_def_carrier)
)

(global boolean g_qz_phantom 0)

(script dormant you_win
	(if debug (print "you win script called..."))
	(sleep_until g_qz_phantom 30 (* 30 60 2))
	(sleep 120)
	(playtest_mission)
	
	(sound_class_set_gain "" 0 15)
	(cinematic_fade_to_white)

	(game_won)
)

(script command_script cs_qz_phantom
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed 1)

	(cs_fly_by qz_phantom/p0 3)
	(cs_vehicle_boost true)

	(cs_fly_by qz_phantom/p1 3)
	(cs_vehicle_boost false)
;	(cs_fly_by qz_phantom/p2 3)
	(cs_fly_by qz_phantom/p3 5)
	(ai_magically_see covenant flood)

	(cs_vehicle_speed .75)
	(cs_fly_to_and_face qz_phantom/p4 qz_phantom/p5)

	(ai_magically_see covenant flood)
	(sleep_until (not (volume_test_objects tv_game_won (ai_actors qz_cov_def_flood))) 30 (* 30 30))
	(set g_qz_phantom 1)
)

;===========================================================================================================
;========== ENCOUNTER SCRIPTS ==============================================================================
;===========================================================================================================
(script dormant enc_insertion
	(if debug (print "initialize insertion scripts"))
	(game_save)
	(data_mine_set_mission_segment enc_insertion)

	(cond
		((difficulty_normal) (object_destroy ins_em_b))
		((difficulty_heroic) (object_destroy ins_em_b))
	)
	
	(ai_disregard (ai_actors constructors) true)
	(ai_place ins_con_mid)
	(ai_place ins_con_bk)
	(ai_place pussy_grunt)
	(wake ins_open_door)
	(wake pussy_grunt_reminder)
	(wake music_06a_01)
	(sleep 1)
	
	(if (not (difficulty_legendary))
			(sleep_until	(or
							(< (ai_strength ins_cons) 1)
							(volume_test_objects tv_insertion_tube (players))
						)
			5)
			(begin (sleep 150) (wake ai_insertion_emitters))
	)
	(if (< (ai_strength ins_cons) 1)
		(begin
			(wake ai_insertion_emitters)
;			(ai_disregard (ai_actors constructors) true)
			(if (= (device_get_position piston_ins) 0) (begin
												(ai_set_orders ins_con_mid ins_run_away)
												(ai_set_orders ins_con_bk ins_run_away)
											   ))
		)
	)
	(wake pussy_grunt)
	
)

(script dormant enc_hall_a
	(if g_hall_a (sleep_until (volume_test_objects tv_hall_a (players)) 10))
	(if debug (print "initialize hall a scripts"))
	(game_save)
	(data_mine_set_mission_segment enc_hall_a)

	(set g_insertion_spawn 1)
	(set g_pussy_grunt 1)
;	(set g_music_06a_01 0)
	
	(ai_disposable insertion_sentinels true)
	(ai_disposable ins_cons true)
	(ai_disposable pussy_grunt true)

	(ai_set_orders constructors hall_a_constructors)
	(ai_set_orders pussy_grunt hall_a_cov)
	(wake ai_hall_a_const)

	(if	(not (difficulty_legendary))
		(sleep_until	(or
						(< (ai_strength hall_a_cons) .8)
						(volume_test_objects tv_hall_a_bk (players))
					)
		)
	)
;	(ai_disregard (ai_actors constructors) true)
	(ai_place hall_a_sen/h)
	(sleep 30)
	(wake ai_hall_a_emitters)
)

(script dormant enc_conduit_a
	(if g_conduit_a (sleep_until (volume_test_objects tv_conduit_a (players)) 10))
	(if debug (print "initialize conduit a scripts"))
	(game_save)
	(data_mine_set_mission_segment enc_cond_a_sec_a)
	
	(ai_disposable hall_a_sentinels true)
	(ai_disposable hall_a_cons true)

	(ai_place cond_a_sen_ini)
	(ai_set_orders covenant cond_a_cov_follow)
	(sleep 1)

	(ai_place cond_a_cov)
	(sleep 1)
	(wake ai_sc_cond_a_cov)
	(wake cond_a_initial_delay)
	(wake music_06a_03)
	(sleep_forever ai_hall_a_emitters)
;	(set g_hall_a_loops 1)
	
	(sleep_until g_cond_a_continue)
		(ai_renew covenant)
		(wake ai_cond_a_emitters_fr)
	
	(sleep_until (volume_test_objects tv_cond_a_b (players)) 5)
;		(game_save)
		(ai_renew covenant)
		
		(wake sc_tartarus_reminder)
		(wake ai_cond_a_back_ini)
		(set g_music_06a_03 1)

	(sleep_until (volume_test_objects tv_cond_a_c (players)))
		(game_save)
		(data_mine_set_mission_segment enc_cond_a_sec_b)
		(ai_renew covenant)
		
		(wake ai_cond_a_emitters_bk)
		(sleep_forever ai_cond_a_emitters_fr)
)

(script dormant enc_hall_b
	(if g_hall_b (sleep_until (volume_test_objects tv_hall_b (players)) 10))
	(if debug (print "initialize hall b scripts"))
	(game_save)
	(data_mine_set_mission_segment enc_hall_b)
	
	(ai_disposable cond_a_sentinels true)
	(ai_disposable cond_a_cov true)

	(sleep_forever ai_cond_a_emitters_bk)

	(set g_cond_a_front 1)
	(set g_cond_a_back 1)
	
	(ai_place hall_b_cov (pin (- 4 (ai_living_count covenant)) 0 4))

	(wake ai_sc_hall_b_grunts)
	(ai_set_orders covenant hall_b_cov_follow)
	(sleep 1)
	(ai_set_orders covenant hall_b_cov_ini)
	(ai_renew covenant)
	
	(sleep_until (volume_test_objects tv_hall_b_fr (players)))
		(wake ai_hall_b_emitters)
		(ai_set_orders covenant hall_b_cov_follow)
		(set g_hall_b_sen_dialogue 1)
)

(script dormant enc_plug_launch
	(if g_plug_launch (sleep_until (volume_test_objects tv_plug_launch (players)) 10))
	(if debug (print "initialize plug launch scripts"))
	(wake plug_absorbers)
	(game_save)
	(data_mine_set_mission_segment enc_plug_launch)
	
	(ai_disposable hall_b_cov true)
	(ai_disposable hall_b_sentinels true)

	(object_dynamic_simulation_disable plug true)
	
	(wake objective_lower_clear)
	(wake objective_lower_specific_set)

;	(set g_hall_b_loops 1)
	(sleep_forever ai_hall_b_emitters)

	(ai_renew covenant)
	(ai_set_orders covenant plug_launch_cov_ini)
	(ai_place plug_launch_enforcer)

	(sleep_until (>= (ai_combat_status plug_launch_enforcer) ai_combat_status_active) 30 210)
		(wake sc_enforcer)
		(wake ai_plug_launch_em)
		(sleep 1)
		(ai_set_orders covenant plug_launch_cov_follow)
		
	(sleep_until g_plug_move)
		(set g_plug_launch_loops 1)
		(wake cs_move_plug)
		(wake music_06a_04)
)

(script dormant enc_plug_landing
	(if g_plug_landing (sleep_until (volume_test_objects tv_plug_land (players))))
	(sleep_until (>= (device_get_position plug) .75) 10)
	(if debug (print "initialize plug landing scripts"))
	(game_save_no_timeout)
	(data_mine_set_mission_segment enc_plug_landing)

	(ai_disposable plug_launch_enforcer true)
	(ai_disposable plug_launch_sentinels true)

	(wake music_06a_05)
	(wake ai_plug_holder_flood)
	(wake ai_plug_holder_em)
	(wake ai_plug_holder_em_elim)
	
	(sleep_until	(or
					g_plugholder_progress
					(<= (ai_living_count plug_holder_enforcer) 0)
				)
	30 (* 30 60 5)) ; move on after 5 minutes of being a cowering wimp (or not killing any sentinels 
		
		
		(game_save_no_timeout)
		(data_mine_set_mission_segment enc_plug_landing_bk)
		
		(sleep (* 30 5))
		(set g_music_06a_04 0)
		(set g_music_06a_05 0)
	
		(if debug (print "opening the escape hatch..."))
		
		(ai_place plugholder_sen_bk_ini)
		(sleep 30)
		(device_set_position plugholder_door 1)

	(sleep_until (volume_test_objects tv_plugholder_d (players)))
		(game_save_no_timeout)
		
		(set g_music_06a_05 0)

		(ai_disposable plug_holder_flood true)
		(ai_disposable plug_holder_sentinels true)
	
		(ai_set_orders plug_holder_sentinels plugholder_sen_bk)
		(ai_set_orders plug_holder_enforcer plugholder_enforcer_bk)
		(set g_plugholder_progress 1) ; set here incase the enforcer dies first 
	
		(wake close_plugholder_door)
		(wake ai_plugholder_flood_bk)
		(wake ai_plug_holder_bk_em)

	(sleep_until (volume_test_objects tv_plugholder_e (players)))
		(set g_plugholder_bk_a 1)
		(game_save_no_timeout)

	(sleep_until (volume_test_objects tv_plugholder_f (players)))
		(set g_plugholder_bk_b 1)
		(game_save_no_timeout)
		(data_mine_set_mission_segment enc_plug_landing_lower)
		
		(ai_place plugholder_lower_hall_flood)
		(ai_place plugholder_lower_hall_infec)
)

(script dormant enc_hall_c
	(if g_hall_c (sleep_until (volume_test_objects tv_hall_c (players)) 10))
	(if debug (print "initialize hall c scripts"))
	(game_save_no_timeout)
	(data_mine_set_mission_segment enc_hall_c_sec_a)
	
	(ai_disposable plug_holder_flood_bk true)
	(ai_disposable plugholder_bk_infec_a true)
	(ai_disposable plugholder_bk_infec_b true)

	(sleep_forever ai_plugholder_infec_bk_a)
	(sleep_forever ai_plugholder_infec_bk_b)
	
	(sleep_until (volume_test_objects tv_hall_c_a (players)) 5)
	(game_save_no_timeout)
		(wake ai_hall_c_ini)
	;	(ai_place hall_c_flood_near)
		(sleep 5)
		(ai_magically_see hall_c_marines hall_c_flood_far)
		(ai_magically_see hall_c_flood_far hall_c_marines)
	
	(sleep_until (volume_test_objects tv_hall_c_b (players)) 10)
		(game_save_no_timeout)
		(data_mine_set_mission_segment enc_hall_c_sec_b)
	
		(wake kill_hall_c_marines)
		(ai_place hall_c_flood_mid)
		(sleep 1)
		(ai_set_orders hall_c_flood hall_c_floor_b)

	(sleep_until (volume_test_objects tv_hall_c_c (players)) 10)
		(game_save_no_timeout)
	
;		(wake ai_hall_c_flood_spawn)
		(ai_place hall_c_flood_c (pin (- 8 (ai_nonswarm_count hall_c_flood)) 0 6))
		(ai_place hall_c_carrier_c)
		(ai_place hall_c_sen_tube)
		(sleep 1)
		(ai_set_orders hall_c_flood hall_c_floor_c)

	(sleep_until (volume_test_objects tv_hall_c_d (players)) 10)
		(game_save_no_timeout)
		(data_mine_set_mission_segment enc_hall_c_sec_c)

		(ai_place hall_c_flood_d (pin (- 8 (ai_nonswarm_count hall_c_flood)) 0 6))
		(ai_place hall_c_carrier_d)
		(sleep 1)
		(ai_set_orders hall_c_flood hall_c_floor_d)

	(sleep_until (volume_test_objects tv_hall_c_e (players)) 10)
		(game_save_no_timeout)
		(ai_place hall_c_flood_e (pin (- 8 (ai_nonswarm_count hall_c_flood)) 0 6))
		(ai_place hall_c_carrier_e)
		(sleep 1)
		(ai_set_orders hall_c_flood hall_c_floor_e)
)

(script dormant enc_ledge_a
	(if g_ledge_a (sleep_until (volume_test_objects tv_ledge_a (players)) 10))
	(if debug (print "initialize ledge a scripts"))
	(game_save_no_timeout)
	(data_mine_set_mission_segment enc_ledge_a_sec_a)

	(ai_disposable hall_c_flood true)
	
	(wake ai_ledge_a_initial)
	(ai_place ledge_a_flood_dead)
	
	(sleep_until (or (<= (ai_living_count ledge_a_flood_ini) 0) (volume_test_objects tv_ledge_a_top_b (players))))

	(sleep_until (volume_test_objects tv_ledge_a_top_b (players)))
	(game_save_no_timeout)
	(wake ai_ledge_a_location)
	(wake ai_ledge_a_emitters)
	(wake ai_ledge_a_flood_spawn)
	
	(sleep_until (volume_test_objects tv_ledge_a_top_d1 (players)))
	(game_save_no_timeout)
	(ai_place ledge_a_flood_d1)
	
	(sleep_until (volume_test_objects tv_ledge_a_top_d2 (players)))
	(game_save_no_timeout)
	(data_mine_set_mission_segment enc_ledge_a_sec_b)
	(ai_place ledge_a_flood_d2)
	
	(sleep_until (volume_test_objects tv_ledge_a_top_e (players)))
	(game_save_no_timeout)
	(ai_set_orders ledge_a_flood ledge_a_floor_follow)
)

(script dormant enc_conduit_b
	(if g_conduit_b (sleep_until (volume_test_objects tv_conduit_b (players)) 10))
	(if debug (print "initialize conduit b scripts"))
	(game_save_no_timeout)
	(data_mine_set_mission_segment enc_cond_b_sec_a)
	
	(ai_disposable ledge_a_sentinels true)
	(ai_disposable ledge_a_enforcer true)
	(ai_disposable ledge_a_flood true)
	
	(wake music_06a_06)
	(wake music_06a_07)

	(if (difficulty_legendary) (wake ice_cream_mythic))

	(set g_music_06a_06 1)
	(set g_ledge_a_spawn 1)
	(wake ai_cond_b_flood_spawn)
	(wake conduit_b_locator)
	(wake ai_cond_b_carrier_a)
	
	(sleep_until (volume_test_objects tv_cond_b_a2 (players)) 10)
		(game_save_no_timeout)
		(ai_place cond_b_flood_tube_a)
;		(ai_place cond_b_enforcer)
		(set cond_b_flood_a_spawn 1)
		(sleep 5)
		(ai_set_orders cond_b_flood cond_b_floor_follow_a)
	
	(sleep_until (volume_test_objects tv_cond_b_b1 (players)) 10)
		(game_save_no_timeout)
		(data_mine_set_mission_segment enc_cond_b_sec_b)

		(ai_set_orders cond_b_flood cond_b_floor_follow_b)
		(ai_place cond_b_sen_b/1)
;		(ai_place cond_b_sen_b/2)
		(ai_place cond_b_sen_b/3)
;		(ai_place cond_b_sen_b/4)
		(ai_place cond_b_flood_b_ini)
		(wake ai_cond_b_b_em)
		(sleep 5)

	(sleep_until (volume_test_objects tv_cond_b_b2 (players)) 10)
		(game_save_no_timeout)
		(set g_music_06a_07 1)
		(sleep_forever ai_cond_b_b_em)
		(wake ai_cond_b_sen_tube_b)
		
		(ai_set_orders cond_b_flood cond_b_floor_follow_c)
		(ai_disposable ledge_a_flood true)
		(ai_disposable ledge_a_sentinels true)
		(ai_disposable ledge_a_enforcer true)
		(ai_disposable cond_b_flood true)

	(sleep_until (volume_test_objects tv_cond_b_c (players)) 10)
		(game_save_no_timeout)
		(data_mine_set_mission_segment enc_cond_b_sec_c)
	
		(wake sc_marines_a)
		(set cond_b_flood_b_spawn 1)
		(ai_place cond_b_humans)
		(ai_place cond_b_flood_c_ini_a (pin (- 6 (ai_living_count cond_b_flood)) 0 4))
		(sleep 1)
		(ai_place cond_b_flood_c_ini_b (pin (- 6 (ai_living_count cond_b_flood)) 0 4))
		(ai_place cond_b_infection_c 2)
		(sleep 5)
;		(ai_migrate cond_b_flood cond_b_flood_c)
	
	(sleep_until (volume_test_objects tv_cond_b_hum_dead (players)) 10)
		(game_save_no_timeout)
		(wake kill_cond_b_marines)
)

(script dormant enc_ledge_b
	(if g_ledge_b (sleep_until (volume_test_objects tv_ledge_b (players)) 10))
	(if debug (print "initialize ledge b scripts"))
	(game_save)
	(data_mine_set_mission_segment enc_ledge_b)

	(ai_disposable cond_b_flood true)
	(ai_disposable cond_b_sentinels true)
	(ai_disposable cond_b_infection_c true)

	(set cond_b_flood_c_spawn 1)
;	(ai_place ledge_b_sen)
	(ai_place ledge_b_flood)
	(ai_place ledge_c_phantom)
	(wake slide_a_player0)
	(wake slide_a_player1)
	(wake music_06a_08)
	(wake music_06a_09)
	(wake music_06a_10)
)

(script dormant enc_ledge_c
	(if g_ledge_c (sleep_until (volume_test_objects tv_ledge_c (players)) 10))
	(if debug (print "initialize ledge c scripts"))
	(game_save_no_timeout)
	(data_mine_set_mission_segment enc_ledge_c)
	
	(ai_disposable ledge_b_sen true)
	
;	(wake music_06a_09)
	(wake ai_ledge_c_flood_ini)
	(wake ai_ledge_c_infection_spawn)
	
	(ai_magically_see ledge_c_flood ledge_c_phantom)
	
	(set g_ledge_c_phantom_start 1)

	(sleep_until (volume_test_objects tv_ledge_c_bk (players)))
	(game_save_no_timeout)
	(set ledge_c_spawn 0)
	(set g_ledge_c_phantom_1 1)
	(ai_place ledge_c_flood_bk (pin (- 6 (ai_living_count ledge_c_flood)) 0 6))
	(wake slide_b_player0)
	(wake slide_b_player1)
)
	
(script dormant enc_qz_initial
	(if g_qz_initial (sleep_until (volume_test_objects tv_qz_initial (players)) 10))
	(if debug (print "initialize quarantine zone initial scripts"))
	(game_save_no_timeout)
	(data_mine_set_mission_segment enc_qz_initial)

	(ai_disposable ledge_c_flood true)

	(wake cs_mortar_a)
	(wake cs_mortar_b)

	(sleep_until (> (device_get_position qz_door) 0) 1)
	(wake chapter_war)
	(wake objective_floodwall_clear)
	(wake objective_rendezvous_set)
	(wake cs_crash_factory)
	
	(set g_music_06a_10 0)

	(ai_place qz_initial_flood_ini)
	(ai_place qz_initial_flood_carrier_ini)
	(ai_place qz_initial_flood_bridge)
	(ai_place qz_initial_flood_carrier_camp)
	(if (difficulty_normal) (ai_place qz_ini_turrets/a) (ai_place qz_ini_turrets))

	(sleep_until (volume_test_objects tv_qz_camp (players)) 10)
	(if debug (print "camp"))
	(game_save_no_timeout)
	(data_mine_set_mission_segment enc_qz_initial_camp)
	(wake ai_qz_ini_flood)

	(sleep_until (volume_test_objects tv_qz_cave (players)) 10)
	(if debug (print "cave"))
	
	(set g_qz_ini_cave 1)
	
	(ai_place qz_initial_flood_cave)
	(ai_play_line_on_object qz_ini_sound_cave 0180)
	(wake ai_qz_ini_exit_turrets)
	(game_save_no_timeout)
)

(script dormant enc_cov_defense
	(if g_cov_defense (sleep_until (volume_test_objects tv_cov_defense (players)) 10))
	(if debug (print "initialize covenant defense scripts"))
	(game_save)
	(data_mine_set_mission_segment enc_covenant_defense)

	(ai_disposable qz_ini_flood true)
	(ai_disposable qz_cov_def_flood true)

	(ai_vehicle_reserve (ai_vehicle_get qz_ini_turrets) true)
	(ai_vehicle_exit qz_ini_ins_pods)
	
	(ai_migrate qz_ini_ins_pods qz_cov_def_cov)
	(ai_set_orders qz_ini_flood qz_cov_def_hill)
	
	(ai_place qz_cov_def_flood_ini)
	(ai_place qz_cov_def_flood_g)
	(ai_place qz_cov_def_cov (pin (- 3 (ai_living_count qz_cov_def_cov)) 0 2))
	(ai_place qz_cov_def_soc)
	(ai_place qz_camp_turrets)

	(object_cannot_die (ai_get_object qz_cov_def_soc/soc) true)
	(ai_set_orders covenant qz_cov_def_cov_ac)

	(sleep_until (<= (ai_living_count qz_cov_def_flood) 0))
	(ai_set_orders covenant qz_cov_def_hill)
	(sleep 1)
	(wake sc_qz_cov_camp)

	(sleep_until g_qz_cov_camp_progress)
	(wake ai_qz_cov_def_flood_spawn)
	(wake ai_qz_cov_def_carrier)
	(sleep 1)
	
	(sleep_until (= g_qz_cov_def_spawn 0))
	(if debug (print "last of the flood waves have spawned"))
	(sleep (* 30 5))
	(game_save_no_timeout)
	(ai_magically_see covenant flood)

	(if debug (print "phantom placed..."))
	(ai_place qz_phantom)
	
;*	(sleep_until	(and
					(not (volume_test_objects tv_game_won (ai_actors flood)))
					(<= (ai_nonswarm_count qz_cov_def_flood) 2)
					(game_safe_to_save)
				)
	30 (* 30 5))
*;
	(wake you_win)

)



;===========================================================================================================
;============= STARTUP SCRIPT ==============================================================================
;===========================================================================================================

(script dormant mission_sentinelwalls	
	(cinematic_snap_to_white)
	
	(switch_bsp 0)
	
	(if (= g_play_cinematics 1)
		(begin
			(sound_suppress_ambience_update_on_revert)
			(if (cinematic_skip_start)
				(begin
					(if debug (print "x06"))
					(x06)
				)
			)
			(cinematic_skip_stop)

			(if (cinematic_skip_start)
				(begin
					(if debug (print "intro"))
					(C06_intro)
				)
			)
			(cinematic_skip_stop)
		)
	)

	(sleep 2)
	
	(object_teleport (player0) player0_start)
	(object_teleport (player1) player1_start)

	(wake enc_insertion)
	(wake piston_control)
	(wake difficulty_settings)
	
	(player_training_activate_stealth)

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(cinematic_fade_from_white_bars)
	(wake chapter_silence)
	(wake objective_lower_set)

	(cond
		((difficulty_normal) (if debug (print "normal")))
		((difficulty_heroic) (if debug (print "heroic")))
		((difficulty_legendary) (if debug (print "legendary")))
	)

	(sleep_until (or g_hall_a (volume_test_objects tv_hall_a (players))) 10)
	(wake enc_hall_a)
	
	(sleep_until (or g_conduit_a (volume_test_objects tv_conduit_a (players))) 10)
	(wake enc_conduit_a)
	
	(sleep_until (or g_hall_b (volume_test_objects tv_hall_b (players))) 10)
	(wake enc_hall_b)
	
	(sleep_until (or g_plug_launch (volume_test_objects tv_plug_launch (players))) 10)
	(wake enc_plug_launch)
	
	(sleep_until (or g_plug_landing (volume_test_objects tv_plug_land (players))) 10)
	(wake enc_plug_landing)
	
	(sleep_until (or g_hall_c (volume_test_objects tv_hall_c (players))) 10)
	(wake enc_hall_c)

	(sleep_until (or g_ledge_a (volume_test_objects tv_ledge_a (players))) 10)
	(wake enc_ledge_a)

	(sleep_until (or g_conduit_b (volume_test_objects tv_conduit_b (players))) 10)
	(wake enc_conduit_b)

	(sleep_until (or g_ledge_b (volume_test_objects tv_ledge_b (players))) 10)
	(wake enc_ledge_b)

	(sleep_until (or g_ledge_c (volume_test_objects tv_ledge_c (players))) 10)
	(wake enc_ledge_c)

	(sleep_until (or g_qz_initial (volume_test_objects tv_qz_initial (players))) 10)
	(set g_piston_control 1)
	(wake enc_qz_initial)

	(sleep_until (or g_cov_defense (volume_test_objects tv_cov_defense (players))) 10)
	(wake enc_cov_defense)
)

(script static void start
	(wake mission_sentinelwalls)
)

(script startup mission_main

	; Necessary startup stuff
	(ai_allegiance covenant player)
	(ai_allegiance player covenant)
	(ai_allegiance prophet player)
	(ai_allegiance player prophet)
	(ai_allegiance covenant prophet)
	(ai_allegiance prophet covenant)

	; Begin the mission
	; Comment this out when you're testing individual encounters
	(if (> (player_count) 0) (start))
)
