
(script stub void c07_intra1 (print "c07_intra1"))
(script stub void c07_intra2 (print "c07_intra2"))

(script stub void c07_outro (print "c07_outro")) ; Tyson

(script command_script cs_expand_cortana
	(object_set_scale (ai_get_object ai_current_actor) 0.01 0)
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	(ai_disregard (ai_get_object ai_current_actor) true)
	(sleep 5)
	(unit_set_emotional_state (ai_get_unit ai_current_actor) "disappointed" 0.5 0)
	(object_dynamic_simulation_disable (ai_get_object ai_current_actor) true)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 (ai_get_object ai_current_actor) "effect")
	(sleep 1)
	(object_hide (ai_get_object ai_current_actor) false)
	(object_set_scale (ai_get_object ai_current_actor) 0.65 20)
	(cs_face_player true)
	(sleep_forever)
)

;= REAL MUSIC ========================================================================


(script dormant music_07b_01_start
	; "Flood dropships all over the city..."
	(print "music 07b_01 start")
	(sound_looping_start "scenarios\solo\07b_forerunnership\07b_music\07b_01" none 1.0)
)


(script dormant music_07b_01_stop
	; "Get back inside the tower..."
	(print "music 07b_01 stop")
	(sound_looping_stop "scenarios\solo\07b_forerunnership\07b_music\07b_01")
)


(script static void test
	(objects_attach sanctum_lift "switch" sanctum_lift_control "")
)

(script dormant music_07b_02_start 	; No stop on this one
	; "Get back inside the tower..."
	(print "music 07b_02 start")
	(sound_looping_start "scenarios\solo\07b_forerunnership\07b_music\07b_02" none 1.0)
)


(script dormant music_07b_03_start 
	; "After the Plasma Chandelier... and into darkness!"
	(print "music 07b_03 start")
	(sound_looping_start "scenarios\solo\07b_forerunnership\07b_music\07b_03" none 1.0)
)


(script dormant music_07b_03_stop
	; As you begin the ride back up into the fresh air of the final battle!
	(print "music 07b_03 stop")
	(sound_looping_stop "scenarios\solo\07b_forerunnership\07b_music\07b_03")
)


(script dormant music_07b_04_start 
	; "After Gravemind says "The progress of infinitude!"
	(print "music 07b_04 start")
	(sound_looping_start "scenarios\solo\07b_forerunnership\07b_music\07b_04" none 1.0)
)


(script dormant music_07b_04_stop
	; Before Cotana says "Flood biomass..."
	(print "music 07b_04 stop")
	(sound_looping_stop "scenarios\solo\07b_forerunnership\07b_music\07b_04")
)


(script dormant music_07b_05_start 
	; After Cortana says "Override the lock...!"
	(print "music 07b_05 start")
	(sound_looping_start "scenarios\solo\07b_forerunnership\07b_music\07b_05" none 1.0)
)


(script dormant music_07b_05_stop
	; After Cortana says "This will take just a minute"
	(print "music 07b_05 stop")
	(sound_looping_stop "scenarios\solo\07b_forerunnership\07b_music\07b_05")
)


(script dormant music_07b_06_start 
	; As the lift starts to rise into the Inner Sanctum
	(print "music 07b_06 start")
	(sound_looping_start "scenarios\solo\07b_forerunnership\07b_music\07b_06" none 1.0)
)


(script dormant music_07b_06_stop
	; After you leave the Inner Sanctum
	(print "music 07b_06 stop")
	(sound_looping_stop "scenarios\solo\07b_forerunnership\07b_music\07b_06")
)


;= CHAPTER TITLES ========================================================================


(script dormant chapter_purposes
	(sleep 30)
	(cinematic_set_title title_1)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)


(script dormant chapter_please
	(sleep 30)
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title_2)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)


(script dormant chapter_sanctified
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title_3)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)


(script dormant chapter_feeling
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title_4)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)


;= OBJECTIVES ===========================================================================


;*
1 = "Fight your way back inside the Mausoleum-tower."
2 = "Stay ahead of the wave of Flood sweeping through High Charity."
3 = "Find a way onto the Forerunner Ship."
*;


(script dormant objective_enter_set
	(sleep 30)
	(print "new objective set:")
	(print "Fight your way back inside the Mausoleum-tower.")
	(objectives_show_up_to 0)
)


(script dormant objective_enter_clear
	(print "objective complete:")
	(print "You got inside the tower")
	(objectives_finish_up_to 0)
)


(script dormant objective_riptide_set
	(sleep 30)
	(print "new objective set:")
	(print "Survive the rising tide of the Flood.")
	(objectives_show_up_to 1)
)


(script dormant objective_riptide_clear
	(print "objective complete:")
	(print "You have reached the Inner Sanctum of the Covenant Homeworld")
	(objectives_finish_up_to 1)
)


(script dormant objective_exit_set
	(sleep 30)
	(print "new objective set:")
	(print "Find a way onto the Forerunner Ship.")
	(objectives_show_up_to 2)
)


(script dormant objective_exit_clear
	(print "objective complete:")
	(print "Ride that pipe.")
	(objectives_finish_up_to 2)
)


;=========================================================================================================================================
;= ENCOUNTER DIALOGUE ====================================================================================================================
;=========================================================================================================================================


(global boolean dialogue 1)

(global short dialogue_pause 7)

(global short g_dialogue_counter 0)

;= GENERIC FLAVOR DIALOGUE ====================================================================================================================


(script dormant gen_DIA_civil_war_a
	(if dialogue (print "CORTANA: Brute and Elite ships are engaging one-another all around High Charity!"))
	(sleep (ai_play_line_on_object none 2880))
	(sleep dialogue_pause)
)


(script dormant gen_DIA_civil_war_b
	(if dialogue (print "CORTANA: The Jackals and the Drones have declared themselves the servants of the Brutes. The Hunters have have sworn allegiance to the Elites."))
	(sleep (ai_play_line_on_object none 2890))
	(sleep dialogue_pause)
)


(script dormant gen_DIA_civil_war_c
	(if dialogue (print "CORTANA: The Grunts seem to be neutral, or, at least afraid to announce which side they support. Except for Truth, the Prophets aren't saying a word."))
	(sleep (ai_play_line_on_object none 2900))
	(sleep dialogue_pause)
)


(script dormant gen_DIA_locking_doors_behind
	(if dialogue (print "CORTANA: If it makes you feel any better, I'm locking the doors behind you. Should keep some of the Flood off your back."))
	(sleep (ai_play_line_on_object none 2840))
	(sleep dialogue_pause)
)


;= ENCOUNTER 1 DIALOG ====================================================================================================================

(script dormant e1_DIA_truth_holycity
	(if
		dialogue
		(print "TRUTH: Shall we let the Flood consume our holy-city? Turn High Charity into another of their wretched hives?")
	)
	(begin
;		(sleep (ai_play_line_on_object none 0280))
;*		(ai_play_line_on_object e1_broadcast2 0280)
		(ai_play_line_on_object e1_broadcast3 0280)
		(ai_play_line_on_object e1_broadcast4 0280)
		(ai_play_line_on_object e1_broadcast5 0280)
		(ai_play_line_on_object e1_broadcast6 0280)
*;	
		(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0280_pot" e5_speaker2 1.0 1)
		(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0280_pot" e5_speaker4 1.0 1)
		(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0280_pot" e5_speaker5 1.0 1)
		(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0280_pot" e5_speaker0 1.0 1)
		(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0280_pot" e5_speaker1 1.0 1)
		(sleep (ai_play_line_on_object e5_speaker3 0280))
	)
	(sleep 30)
	(if
		dialogue
		(print "TRUTH: No enemy has ever withstood our might - the Flood too shall fall!")
	)
	(begin
;		(sleep (ai_play_line_on_object none 0200))
;*		(ai_play_line_on_object e1_broadcast2 0200)
		(ai_play_line_on_object e1_broadcast3 0200)
		(ai_play_line_on_object e1_broadcast4 0200)
		(ai_play_line_on_object e1_broadcast5 0200)
		(ai_play_line_on_object e1_broadcast6 0200)
*;	
		(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0200_pot" e5_speaker2 1.0 1)
		(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0200_pot" e5_speaker4 1.0 1)
		(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0200_pot" e5_speaker5 1.0 1)
		(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0200_pot" e5_speaker0 1.0 1)
		(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0200_pot" e5_speaker1 1.0 1)
		(sleep (ai_play_line_on_object e5_speaker3 0200))
	)
)


;= ENCOUNTER 5 DIALOGUE ==================================================================================================================


(script dormant e5_DIA_get_to_conduit
	(if dialogue (print "CORTANA: No time to admire the view. Truth's Phantom has reached the Forerunner ship!"))
	(sleep (ai_play_line_on_object none 2730))
	(sleep dialogue_pause)
)

;= ENCOUNTER 8 DIALOG ====================================================================================================================


(script dormant e8_DIA_security_lock
	(if dialogue (print "CORTANA: The security systems in this part of the tower are particularly robust. Hang on while I override the lock."))
	(sleep (ai_play_line_on_object none 2760))
	(sleep dialogue_pause)
)


(script dormant e8_DIA_unlock_a
	(if dialogue (print "CORTANA: Hang on. This will just take a minute."))
	(sleep (ai_play_line_on_object none 2780))
	(sleep dialogue_pause)
)


(script dormant e8_DIA_unlock_b
	(if dialogue (print "CORTANA: Standby while I break the lock."))
	(sleep (ai_play_line_on_object none 2790))
	(sleep dialogue_pause)
)


(script dormant e8_DIA_unlock_c
	(if dialogue (print "CORTANA: I'm working as quickly as possible."))
	(sleep (ai_play_line_on_object none 2800))
	(sleep dialogue_pause)
)

(script dormant e8_DIA_unlock_d
	(if dialogue (print "CORTANA: Almost have it."))
	(sleep (ai_play_line_on_object none 2810))
	(sleep dialogue_pause)
)


(script dormant e8_DIA_unlock_e
	(if dialogue (print "CORTANA: Just a little more time..."))
	(sleep (ai_play_line_on_object none 2820))
	(sleep dialogue_pause)
)


(script dormant e8_DIA_unlock_f
	(if dialogue (print "CORTANA: A few more seconds..."))
	(sleep (ai_play_line_on_object none 2830))
	(sleep dialogue_pause)
)


;= ENCOUNTER 7 DIALOG ==========================================================================================================================


(script dormant e7_DIA_filtration_systems
	(if dialogue (print "CORTANA: Flood spores have contaminated the city's life-support infrastructure - the filtration systems are overloading!"))
;	(sleep (ai_play_line_on_object none 2850))
	(sleep (sound_impulse_language_time "sound\dialog\levels\07_highcharity\mission\l07_2850_cor"))
	(sleep dialogue_pause)
)


;= ENCOUNTER 10 DIALOGUE =====================================================================================================================


(script dormant e10_DIA_truth_theparasite ;in the lift leadingup to the fight
	(if dialogue (print "TRUTH: The Parasite did not defeat the Forerunners, and it shall not defeat us!"))
	(sleep (ai_play_line_on_object none 2910))
	(sleep dialogue_pause)
)


(script dormant e10_DIA_truth_grippedbyfear ;somewhere in the e10 encounter
	(if dialogue (print "TRUTH: Whosoever is gripped by fear, take heed: I am the Prophet of Truth, and I am not afraid!"))
	(sleep (ai_play_line_on_object none 0210))
	(sleep dialogue_pause)
)


(script dormant e10_DIA_truth_noblemercy ;somewhere in the e10 encounter
	(if dialogue (print "TRUTH: Noble Mercy is here, at my side - his wise counsel ever in my ears!"))
	(sleep (ai_play_line_on_object none 0270))
	(sleep dialogue_pause)
)

;============ in the council chambers


(script dormant e10_DIA_civilwar_a ;in the council chambers
	(if dialogue (print "CORTANA: Brute and Elite ships are engaging one-another all around High Charity!"))
	(sleep (ai_play_line_on_object none 2880))
	(sleep dialogue_pause)
)


(script dormant e10_DIA_civilwar_b ;in the council chambers
	(if dialogue (print "CORTANA: The Jackals and Drones have declared themselves the servants of the Brutes. The Hunters have sworn allegiance to the Elites."))
	(sleep (ai_play_line_on_object none 2890))
	(sleep dialogue_pause)
)


(script dormant e10_DIA_civilwar_c ;in the council chambers
	(if dialogue (print "CORTANA: The Grunts seem to be neutral, or at least afraid to announce which side they support. Except for Truth the Prophets aren't saying a word."))
	(sleep (ai_play_line_on_object none 2900))
	(sleep dialogue_pause)
)


;= ENCOUNTER 12 DIALOGUE =====================================================================================================================


(script dormant e12_DIA_tickle_a
	(if dialogue (print "CORTANA: Stopping Truth - that's all that matters!"))
	(sleep (ai_play_line_on_object none 2980))
	(sleep dialogue_pause)
)


(script dormant e12_DIA_truth_becomegods ;as the Flood attack 
	(if dialogue (print "TRUTH: Now is the time of our unworlding - the moment we shall all become as Gods!"))
	(sleep (ai_play_line_on_object none 0330))
	(sleep dialogue_pause)
)


(script dormant e12_DIA_truth_final ;right after the previous line 
	(if dialogue (print "TRUTH: If you would falter, know this: one final effort is all that remains!"))
	(sleep (ai_play_line_on_object none 0260))
	(sleep dialogue_pause)
)


(script dormant e12_DIA_go_conduit_a
	(if dialogue (print "CORTANA: Get to the conduit. I'll keep it attached to the ship as long as I can."))
	(sleep (ai_play_line_on_object none 2940))
	(sleep dialogue_pause)
)


(script dormant e12_DIA_go_conduit_b
	(if dialogue (print "CORTANA: I've lost control of the conduit! It's breaking away from the ship!"))
	(sleep (ai_play_line_on_object none 2950))
	(sleep dialogue_pause)
)


(script dormant e12_DIA_end_b
	(if dialogue (print "CORTANA: You know the plan. You've got to stop Truth. I've got to handle the Index. Go!"))
	(sleep (ai_play_line_on_object none 3030))
	(sleep dialogue_pause)
)


(script dormant e12_DIA_tickle_flood
	(if dialogue (print "CORTANA: Forget about the Flood! You've got to get aboard!"))
	(sleep (ai_play_line_on_object none 2960))
	(sleep dialogue_pause)
)


(script dormant e12_DIA_tickle_brutes
	(if dialogue (print "CORTANA: Ignore the Brutes! Get into the conduit!"))
	(sleep (ai_play_line_on_object none 2970))
	(sleep dialogue_pause)
)


(script dormant e12_DIA_tickle_d
	(if dialogue (print "CORTANA: I can't go with you!"))
	(sleep (ai_play_line_on_object none 3010))
	(sleep dialogue_pause)
)


(script dormant e12_DIA_end_a
	(if dialogue (print "CORTANA: I have to stay here, Chief!"))
	(sleep (ai_play_line_on_object none 3020))
	(sleep dialogue_pause)
)


(script dormant e12_DIA_end_c
	(if dialogue (print "CORTANA: We're out of time, Chief! Into the Conduit!"))
	(sleep (ai_play_line_on_object none 3040))
	(sleep dialogue_pause)
)


(script dormant e12_DIA_tickle_c
	(if dialogue (print "CORTANA: Chief! Leave me!"))
	(sleep (ai_play_line_on_object none 3000))
	(sleep dialogue_pause)
)


(script dormant e12_DIA_tickle_b
	(if dialogue (print "CORTANA: Jump in Chief, now!"))
	(sleep (ai_play_line_on_object none 2990))
	(sleep dialogue_pause)
)


;========================================================================================================================
;= END of ENCOUNTERS ====================================================================================================
;========================================================================================================================


(global short g_e12_talk 0)


(global boolean g_e12_go false) ; tyson: deprecated, unused


(script dormant e12_pelican_flyby
	(ai_place e12_CS_pelican1)
	(ai_place e12_CS_banshee1)
)

(script command_script e12_cs_pelican1
	;Pelican 1 flies in
	(cs_vehicle_speed .8)
	(cs_fly_by pelican3/p0)
	(cs_fly_by pelican3/p1)
	(cs_fly_by pelican3/p2)
	(cs_fly_to pelican3/p3)
	(cs_fly_by pelican3/p4)
	(cs_fly_by pelican3/p5)
	(ai_erase e12_CS_pelican1)
	(ai_erase e12_CS_banshee1)
)

(global boolean g_e12_started false)
(global boolean g_e12_final_battle_started false)
(global boolean g_e12_final_battle_ended false)
(global boolean g_e12_final_battle_mid false)
(global short dialogue_pause_long 60)

(script dormant e12_tickle
	(sleep_until (volume_test_objects tv_e12_tickle (players)) 15)

	(print "placing cortana...")
	(ai_place cortana)
	(wake music_07b_03_stop)
	(sleep_until (= g_dialogue_counter 8))
	
	(sleep 90)
	(if
		dialogue
		(print "CORTANA: I knew the Covenant was good at re-purposing Forerunner technology, but this is amazing. They've been using the Forerunner ship's engines as an energy-source for the city!")
	)

	; pbertone - if the player is greater than 7 WU from cortana then play the dialogue in your head 
	; pbertone - otherwise play the dialogue on cortana 
	(if (> (objects_distance_to_object (players) (ai_get_object cortana)) 7)
			(sleep (ai_play_line_on_object none 2920))
			(sleep (ai_play_line_at_player cortana 2920))
	)
;	(sleep (ai_play_line_on_object none 2920))
	(sleep (* dialogue_pause 2))
	(if
		dialogue
		(print "CORTANA: The ship isn't so much launching as it is disengaging - uncoupling itself from High Charity's power grid!")
	)
	; pbertone - if the player is greater than 7 WU from cortana then play the dialogue in your head 
	; pbertone - otherwise play the dialogue on cortana 
	(if (> (objects_distance_to_object (players) (ai_get_object cortana)) 7)
			(sleep (ai_play_line_on_object none 2930))
			(sleep (ai_play_line_at_player cortana 2930))
	)
;	(sleep (ai_play_line_on_object none 2930))
;	(sleep_until (= g_e12_talk 1))
	(sleep_until g_e12_started)	; tyson: more robust
;*	(if
		dialogue
		(print "CORTANA: Get to the conduit. I'll keep it attached to the ship as long as I can.")
	)
	(if (> (objects_distance_to_object (players) (ai_get_object cortana)) 7) ; pbertone 
			(sleep (ai_play_line_on_object none 2940))
			(sleep (ai_play_line_at_player cortana 2940))
	)
;	(sleep (ai_play_line_on_object none 2940))
	(sleep (* dialogue_pause 2))	*;
	(if
		dialogue
		(print "CORTANA: Stopping Truth - that's all that matters!")
	)
	(if (> (objects_distance_to_object (players) (ai_get_object cortana)) 7) ; pbertone 
			(sleep (ai_play_line_on_object none 2980))
			(sleep (ai_play_line_at_player cortana 2980))
	)
;	(sleep (ai_play_line_on_object none 2980))
	(sleep (* dialogue_pause 6))
	(if
		dialogue
		(print "TRUTH: Now is the time of our unworlding - the moment we shall all become as Gods!")
	)

	
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0330_pot" e12_speaker1 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0330_pot" e12_speaker2 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0330_pot" e12_speaker3 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0330_pot" e12_speaker4 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0330_pot" e12_speaker5 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0330_pot" e12_speaker6 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0330_pot" e12_speaker7 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0330_pot" e12_speaker8 1.0 1)
	(sleep (ai_play_line_on_object e12_speaker0 0330))

	(sleep dialogue_pause)
;	(sleep_until (= g_e12_talk 2))
	(sleep_until g_e12_final_battle_started)	; tyson: more robust
;*	(if
		(random_range 0 2)
		(begin
			(if
				dialogue
				(print "CORTANA: I've lost control of the conduit! It's breaking away from the ship!")
			)
			(if (> (objects_distance_to_object (players) (ai_get_object cortana)) 7) ; pbertone 
					(sleep (ai_play_line_on_object none 2950))
					(sleep (ai_play_line_at_player cortana 2950))
			)
;			(sleep (ai_play_line_on_object none 2950))
			(sleep dialogue_pause)
		)	*;
;		(begin
			(if
				dialogue
				(print "CORTANA: You know the plan. You've got to stop Truth. I've got to handle the Index. Go!")
			)
			(if (> (objects_distance_to_object (players) (ai_get_object cortana)) 7) ; pbertone 
					(sleep (ai_play_line_on_object none 3030))
					(sleep (ai_play_line_at_player cortana 3030))
			)
;			(sleep (ai_play_line_on_object none 3030))
			(sleep dialogue_pause)
;		)
;	)
;	(sleep_until (= g_e12_talk 3))
	(sleep_until g_e12_final_battle_mid)	; More robust

	(if
		dialogue
		(print "TRUTH: If you would falter, know this: one final effort is all that remains!") ; tyson: heh
	)

	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0260_pot" e12_speaker1 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0260_pot" e12_speaker2 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0260_pot" e12_speaker3 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0260_pot" e12_speaker4 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0330_pot" e12_speaker5 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0330_pot" e12_speaker6 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0330_pot" e12_speaker7 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0330_pot" e12_speaker8 1.0 1)
	(sleep (ai_play_line_on_object e12_speaker0 0260))

	(sleep dialogue_pause)
	(if
		dialogue
		(print "CORTANA: Forget about the Flood! You've got to get aboard!")
	)
	(if (> (objects_distance_to_object (players) (ai_get_object cortana)) 7) ; pbertone
			(sleep (ai_play_line_on_object none 2960))
			(sleep (ai_play_line_at_player cortana 2960))
	)
;	(sleep (ai_play_line_on_object none 2960))
	(sleep dialogue_pause)
	(sleep_until (volume_test_objects tv_e12_final_dialogue (players)))

	(if
		(random_range 0 2)
		(begin
			(if
				dialogue
				(print "CORTANA: I can't go with you!")
			)
			(if (> (objects_distance_to_object (players) (ai_get_object cortana)) 7) ; pbertone 
					(sleep (ai_play_line_on_object none 3010))
					(sleep (ai_play_line_at_player cortana 3010))
			)
;			(sleep (ai_play_line_on_object none 3010))
			(sleep dialogue_pause_long)
		)
		(begin
			(if
				dialogue
				(print "CORTANA: I have to stay here, Chief!")
			)
			(if (> (objects_distance_to_object (players) (ai_get_object cortana)) 7) ; pbertone 
					(sleep (ai_play_line_on_object none 3020))
					(sleep (ai_play_line_at_player cortana 3020))
			)
;			(sleep (ai_play_line_on_object none 3020))
			(sleep dialogue_pause_long)
		)
	)
	(sleep 90)
	(sleep_until (volume_test_objects tv_e12_final_dialogue (players)))
	(if
		(random_range 0 2)
		(begin
			(if
				dialogue
				(print "CORTANA: We're out of time, Chief! Into the Conduit!")
			)
			(if (> (objects_distance_to_object (players) (ai_get_object cortana)) 7)
					(sleep (ai_play_line_on_object none 3040))
					(sleep (ai_play_line_at_player cortana 3040))
			)
;			(sleep (ai_play_line_on_object none 3040))
			(sleep dialogue_pause_long)
		)
		(begin
			(if
				dialogue (print "CORTANA: Chief! Leave me!")
			)
			(if (> (objects_distance_to_object (players) (ai_get_object cortana)) 7)
					(sleep (ai_play_line_on_object none 3000))
					(sleep (ai_play_line_at_player cortana 3000))
			)
;			(sleep (ai_play_line_on_object none 3000))
			(sleep dialogue_pause_long)
		)
	)
	(sleep 20)
	(sleep_until (volume_test_objects tv_e12_final_dialogue (players)))
	(if
		dialogue
		(print "CORTANA: Jump in Chief, now!")
	)
	(if (> (objects_distance_to_object (players) (ai_get_object cortana)) 7)
			(sleep (ai_play_line_on_object none 2990))
			(sleep (ai_play_line_at_player cortana 2990))
	)
;	(sleep (ai_play_line_on_object none 2990))
)


;*(script dormant e12_stopper
	(sleep_until
		(or
			(volume_test_objects tv_e12_right_blocker (players))
			(volume_test_objects tv_e12_left_blocker (players))
			(volume_test_objects tv_e12_bottom_blocker (players))
		)
	10 360
	)
	(if
		(volume_test_objects tv_e12_right_blocker (players))
		(begin
			(ai_place e12_fld_inf2_right)
			(sleep 90)
			(ai_place e12_fld_inf2_right)
			(ai_set_orders e12_fld_inf2_right e12_fld_r_mid_back)
		)
	)
	(if
		(volume_test_objects tv_e12_left_blocker (players))
		(begin
			(ai_place e12_fld_inf2_left)
			(sleep 90)
			(ai_place e12_fld_inf2_left)
			(ai_set_orders e12_fld_inf2_left e12_fld_l_mid_back)
		)
	)
	(if
		(volume_test_objects tv_e12_bottom_blocker (players))
		(begin_random
		 	(begin
				(if
					(<= (ai_living_count e12_flood_rush) 2)
					(begin
						(ai_place e12_fld_inf1_right)
						(sleep 90)
						(ai_place e12_fld_inf1_right)
						(ai_set_orders e12_fld_inf1_right e12_fld_bot_back)
					)
				)
			)
		 	(begin
				(if
					(<= (ai_living_count e12_flood_rush) 2)
					(begin
						(ai_place e12_fld_inf1_left)
						(sleep 90)
						(ai_place e12_fld_inf1_left)
						(ai_set_orders e12_fld_inf1_left e12_fld_bot_back)
					)
				)
			)
		)
	)
	(set g_e12_go true)
)*;


;(sleep_until (<= (ai_living_count e12_flood_rush) 1)15 450)


(global boolean g_e12_side false)


(script static void e12_safe_to_spawn_flood
;	(sleep_until (<= (ai_strength e12_flood_rush) .5))
	(sleep_until (<= (ai_nonswarm_count e12_flood_rush) 4) 15)
)


(script dormant e12_final_battle
	(print "final battle started!!!!!!")
	(set g_e12_final_battle_started true)
	(if
		g_e12_side
		;DO THE RIGHT SIDE ENCOUNTERS
		(begin
			;(sleep_until (e12_safe_to_spawn_flood))		
			(begin_random
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf2_right)
					(sleep 1)
				)
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf3_right)
					(sleep 1)
				)
			)
			;(sleep_until (<= (ai_living_count e12_flood_rush) 1)15 600)
			(set g_e12_talk 2)	; tyson: deprecated, does nothing
			(begin_random
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf1_right)
					(sleep 1)
				)
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf2_right)
					(sleep 1)
				)
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf3_right)
					(sleep 1)
				)
			)
			(wake e12_pelican_flyby)
			(print "final battle midpoint...")
			(set g_e12_final_battle_mid true)
			(e12_safe_to_spawn_flood)
			(begin_random
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e12_howler1 1)
					(ai_place e12_fld_inf4/guy1)
					(ai_place e12_fld_inf4/guy2)
					(ai_place e12_fld_inf4/guya)
;					(sleep (random_range 150 300))
				)
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e12_howler2 1)
					(ai_place e12_fld_inf4/guy3)
					(ai_place e12_fld_inf4/guy4)
					(ai_place e12_fld_inf4/guyz)
;					(sleep (random_range 150 300))
				)
			)
			(begin_random
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf1_right)
					;(ai_set_orders e12_fld_inf1_right e12_get_the_player)
;					(sleep (random_range 150 300))
				)
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf2_right)
					;(ai_set_orders e12_fld_inf2_right e12_get_the_player)
;					(sleep (random_range 150 300))
				)
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf3_right)
					;(ai_set_orders e12_fld_inf3_right e12_get_the_player)
;					(sleep (random_range 150 300))
				)
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf2_left)
					;(ai_set_orders e12_fld_inf2_left e12_get_the_player)
;					(sleep (random_range 150 300))
				)
			)
			(ai_set_orders e12_flood_rush e12_get_the_player)
			(sleep_until
				(not
					(volume_test_objects_all tv_e12_conduit_check (ai_actors all_enemies))
				)
			)
			(set g_e12_talk 3)	; tyson: deprecated, does nothing
			(set g_e12_go true)	; tyson: deprecated, does nothing
		)
		
	;THE LEFT SIDE FLOOD SPAENING PATTERN
		(begin
			;(sleep_until (e12_safe_to_spawn_flood))		
			(begin_random
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf2_left)
					(sleep 1)
				)
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf3_left)
					(sleep 1)
				)
			)
			;(sleep_until (<= (ai_living_count e12_flood_rush) 1)15 600)
			(set g_e12_talk 2)	; tyson: deprecated, does nothing
			(begin_random
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf1_left)
					(sleep 1)
				)
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf2_left)
					(sleep 1)
				)
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf3_left)
					(sleep 1)
				)
			)			
			(wake e12_pelican_flyby)
			(print "final battle midpoint...")
			(set g_e12_final_battle_mid true)
			(e12_safe_to_spawn_flood)
			(begin_random
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e12_howler1 1)
					(ai_place e12_fld_inf4/guy1)
					(ai_place e12_fld_inf4/guy2)
;					(sleep (random_range 150 300))
				)
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e12_howler2 1)
					(ai_place e12_fld_inf4/guy3)
					(ai_place e12_fld_inf4/guy4)
;					(sleep (random_range 150 300))
				)
			)
			(begin_random
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf1_left)
					;(ai_set_orders e12_fld_inf1_right e12_get_the_player)
;					(sleep (random_range 150 300))
				)
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf2_left)
					;(ai_set_orders e12_fld_inf2_right e12_get_the_player)
;					(sleep (random_range 150 300))
				)
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf3_left)
					;(ai_set_orders e12_fld_inf3_right e12_get_the_player)
;					(sleep (random_range 150 300))
				)
				(begin
					(e12_safe_to_spawn_flood)
					(ai_place e12_fld_inf2_right)
					;(ai_set_orders e12_fld_inf2_left e12_get_the_player)
;					(sleep (random_range 150 300))
				)
			)
			(ai_set_orders e12_flood_rush e12_get_the_player)
			(sleep_until
				(not
					(volume_test_objects_all tv_e12_conduit_check (ai_actors all_enemies))
				)
			)
			(set g_e12_talk 3)	; tyson: deprecated, does nothing
			(set g_e12_go true)	; tyson: deprecated, does nothing
		)
	)
	
	(print "final battle ended...")
	(set g_e12_final_battle_ended true)
)


(script dormant e12_start
	(sleep_until (volume_test_objects tv_e12_trigger1 (players)) 5)
	(wake chapter_feeling)
	(data_mine_set_mission_segment last_room)
	(game_save_cancel)
	(sleep 1)
	(game_save_no_timeout)
	(set g_e12_talk 1)	; tyson: deprecated, does nothing
	(set g_e12_started true)
	
	(ai_disposable e10_pro_inf1 true)
	(ai_disposable e10_pro_inf1_a true)
	(ai_disposable e10_cov_inf1 true)
	(ai_disposable e10_fld_inf1 true)
	
	(if
		(random_range 0 2)
		;PLACE THE LEFT SIDE DEFENSES AND CRATES AND STUFF
		(begin
			(object_create_containing "e12_left")
			(ai_place e12_pro_inf2_left)
			(ai_place e12_pro_inf3_end)
			(ai_place e12_pro_inf4_left 1)
			;leave the side as false for the "dexter" encounters
			(wake e12_final_battle)
		)
		;PLACE THE RIGHT SIDE DEFENSES AND STUFF
		(begin
			(object_create_containing "e12_right")
			(ai_place e12_pro_inf2_right)
			(ai_place e12_pro_inf3_end)
			(ai_place e12_pro_inf4_right 1)
			;set the side as true for the "right" encounters
			(set g_e12_side true)
			(wake e12_final_battle)
		)
	)
	
	(sleep 120) ; pbertone 
)


(script dormant e12_main
	; tyson: prior initial conditions
	(sleep_until (volume_test_objects tv_e10_trigger5 (players)) 15)
	(sleep_until (volume_test_objects tv_e10_trigger6 (players)) 15)
	(wake e12_start)

	; Dispose
	(ai_disposable e10_fld_swarm1 true)
	(ai_disposable e10_cov_inf1 true)
	(ai_disposable e10_pro_inf1_a true)
	(ai_disposable e10_pro_inf1 true)
)


;===================================================================================
;= ENCOUNTER 12 - THE BIG SCREW ====================================================
;===================================================================================

(global short g_e10_talk 0) 


(global boolean g_e10_move_on 0)


(script dormant e10_sanctum2
	(sleep_until (volume_test_objects tv_e10_trigger6 (players)) 15)
	;(wake e10_tickle)
	(wake music_07b_06_stop)
; tyson	(wake e12_start)
	(wake e12_tickle)
	(game_save_no_timeout)
	(data_mine_set_mission_segment council_chamber)
;	(sleep_until g_dialogue_counter 7) ; tyson_note: probably a syntax error
	(sleep_until (= g_dialogue_counter 7))
	;DO THE SCREEN DIALOGUE
	(sleep_until (volume_test_objects tv_e10_screen (players)) 10)
	;Civil War
	(if
		dialogue (print "CORTANA: Brute and Elite ships are engaging one-another all around High Charity!")
	)
	(if
		(volume_test_objects tv_e10_screen (players))
		(begin
			(sleep (ai_play_line_on_object none 2880))
			(sleep dialogue_pause)
		)
	)
	(sleep_until (volume_test_objects tv_e10_screen (players)) 10)
	(if dialogue (print "CORTANA: The Jackals and Drones have declared themselves the servants of the Brutes. The Hunters have sworn allegiance to the Elites."))
	(if
		(volume_test_objects tv_e10_screen (players))
		(begin
;			(sleep (ai_play_line_on_object none 2890))
			(sleep (sound_impulse_language_time "sound\dialog\levels\07_highcharity\mission\l07_2890_cor"))
			(sleep (* dialogue_pause 2))
		)
	)
	(sleep_until (volume_test_objects tv_e10_screen (players)) 10)
	(if dialogue (print "CORTANA: The Grunts seem to be neutral, or at least afraid to announce which side they support. Except for Truth the Prophets aren't saying a word."))
	(if
		(volume_test_objects tv_e10_screen (players))
		(begin
;			(sleep (ai_play_line_on_object none 2900))
			(sleep (sound_impulse_language_time "sound\dialog\levels\07_highcharity\mission\l07_2900_cor"))
			(set g_e10_talk 9)
		)
	)
	(set g_dialogue_counter 8)
)


(script dormant e10_tickle
	(sleep_until 
		(or
			(volume_test_objects tv_e10_trigger9 (players))
			(= g_e10_talk 9)
		)
	)
	(sleep_forever e10_sanctum2)

	; tyson: backup music stop call
	(wake music_07b_06_stop)

	; tyson: guard to prevent Cortana's long lines from overlapping
	(if (not (= g_e10_talk 9)) (sleep 150))

	(if
		dialogue
		(print "CORTANA: I'm running out of options, Chief. I can't stall the launch sequence much longer. The next lift will take you up to the conduit. Hurry!")
	)
	(sleep (ai_play_line_on_object none 2910))
	(sleep dialogue_pause)
	(wake objective_exit_set)
	(set g_dialogue_counter 8)
	(if
		(= g_e10_talk 9)
		(begin
			(device_set_position e10_tube_door 1)
			(device_closes_automatically_set e10_tube_door false)
		)
	)
)


(script dormant e10_end_open
	(sleep_until 
		(and
			(= g_e10_move_on 1)
			(volume_test_objects tv_e10_trigger5 (players))
		)
	)
	(game_save)
	(wake e10_sanctum2)
	(wake e10_tickle)
	(device_operates_automatically_set e10_sanctum_door 1)
)


(script command_script e10_superflood
	(if
		(difficulty_legendary)
		(ai_set_active_camo ai_current_actor false)
	)
)


(script dormant e10_storm	;This controls the main battle in the Inner Sanctum
	(ai_place e10_pro_inf1)
	(ai_place e10_pro_inf1_a)
	(begin
		(if
			(random_range 0 2)
			(ai_place e10_cov_inf1 2)
			(ai_place e10_cov_inf1 3)
		)
	)
	(sleep_until (<= (ai_strength e10_pro_inner_sanctum) .8)15 600)
	;Start the Flood waves off real easy
	(begin_random
		(begin
			(if
				(<= (ai_living_count e10_flood_storm) 1)
				(begin 
					(ai_place e10_fld_inf1/guy1)
					(ai_place e10_fld_inf1/guy2)
					(sleep 1)
				)
			)
		)
		(begin
			(if
				(<= (ai_living_count e10_flood_storm) 1)
				(begin 
					(ai_place e10_fld_inf1/guy4)
					(ai_place e10_fld_inf1/guy5)
					(sleep 1)
				)
			)
		)
		(begin
			(if
				(<= (ai_living_count e10_flood_storm) 1)
				(begin 
					(ai_place e10_fld_inf1/guy3)
					(ai_place e10_fld_inf1/guy6)
					(sleep 1)
				)
			)
		)
	)
	;Wave two of the Flood after more Covenant are dead as well as all the previous Flood
	(sleep_until (<= (ai_strength e10_pro_inner_sanctum) .5) 15 600)
	(set g_e10_talk 1)
	(begin_random
		(begin
			(if
				(<= (ai_living_count e10_flood_storm) 2)
				(begin
					(ai_place e10_fld_inf1/guy1)
					(ai_place e10_fld_inf1/guy2)
					(ai_place e10_fld_inf1/guy3)
					(sleep 1)
				)
			)
		)
		(begin
			(if
				(<= (ai_living_count e10_flood_storm) 2)
				(begin
					(ai_place e10_fld_inf1/guy4)
					(ai_place e10_fld_inf1/guy5)
					(ai_place e10_fld_inf1/guy6)
					(sleep 1)
				)
			)
		)
		(begin
			(if
				(<= (ai_living_count e10_flood_storm) 2)
				(begin
					(ai_place e10_fld_inf1/guy1)
					(ai_place e10_fld_inf1/guy5)
					(ai_place e10_fld_inf1/guy6)
					(sleep 1)
				)
			)
		)		
		(begin
			(if
				(<= (ai_living_count e10_flood_storm) 2)
				(begin
					(ai_place e10_fld_inf1/guy2)
					(ai_place e10_fld_inf1/guy3)
					(ai_place e10_fld_inf1/guy4)
					(sleep 1)
				)
			)
		)
	)
	; Unleash the final wave(s?) of Flood after the last of the Covenant defenders are dead as disco! 
	(sleep_until (<= (ai_strength e10_pro_inner_sanctum) .3) 15 600)
;	(set g_e10_talk 2) ; tyson: never did anything except potentially break e10_talking_points
	(begin_random
		(begin
			(if
				(<= (ai_living_count e10_flood_storm) 3)
				;Wave on the right side of the Room
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e10_howler1 1)
					(ai_place e10_fld_inf1/guy1)
					(ai_place e10_fld_inf1/guy2)
					(ai_place e10_fld_inf1/guy3)
					(sleep (random_range 90 150))
					(sound_impulse_start sound\characters\flood\flood_howls e10_howler3 1)
					(ai_place e10_fld_inf1/guy7)
					(ai_place e10_fld_inf1/guy8)
					(ai_place e10_fld_inf1/guy9)
					(if
						(difficulty_legendary)
						(ai_set_orders e10_fld_inf1 e10_fld_storm_z)
					)
					(sleep 1)
				)
			)
		)
		(begin
			(if
				(<= (ai_living_count e10_flood_storm) 3)
				;Wave on the left side of the Room
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e10_howler2 1)
					(ai_place e10_fld_inf1/guy4)
					(ai_place e10_fld_inf1/guy5)
					(ai_place e10_fld_inf1/guy6)
					(sleep (random_range 90 150))
					(sound_impulse_start sound\characters\flood\flood_howls e10_howler4 1)
					(ai_place e10_fld_inf1/guy10)
					(ai_place e10_fld_inf1/guy11)
					(ai_place e10_fld_inf1/guy12)
					(sleep 1)
				)
			)
		)
		(begin
			(if
				(<= (ai_living_count e10_flood_storm) 3)
				;Wave diagonal front-right, back left
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e10_howler1 1)
					(ai_place e10_fld_inf1/guy1)
					(ai_place e10_fld_inf1/guy2)
					(ai_place e10_fld_inf1/guy3)
					(sleep (random_range 90 150))
					(sound_impulse_start sound\characters\flood\flood_howls e10_howler4 1)
					(ai_place e10_fld_inf1/guy10)
					(ai_place e10_fld_inf1/guy11)
					(ai_place e10_fld_inf1/guy12)
					(sleep 1)
				)
			)
		)
		(begin
			(if
				(<= (ai_living_count e10_flood_storm) 3)
				;Wave diagonal front-left, back right
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e10_howler2 1)
					(ai_place e10_fld_inf1/guy4)
					(ai_place e10_fld_inf1/guy5)
					(ai_place e10_fld_inf1/guy6)
					(sleep (random_range 90 150))
					(sound_impulse_start sound\characters\flood\flood_howls e10_howler3 1)
					(ai_place e10_fld_inf1/guy7)
					(ai_place e10_fld_inf1/guy8)
					(ai_place e10_fld_inf1/guy9)
					(sleep 1)
				)
			)
		)
	)
	(set g_e10_move_on 1)
	(game_save)
	(sleep 150)
;	(wake music_07b_06_stop)
)


(script dormant e10_infinite_save
	(game_save_no_timeout)
)

; tyson: lift recall script
(script dormant e10_sanctum_lift_recall
	(sleep_until (<= (device_get_position sanctum_lift) 1) 10)
	(sleep_until
		(begin
			; If a player is in the volume below the lift, send it down
			(if (volume_test_objects tv_sanctum_lift (players))
				(device_set_position sanctum_lift 1)
			)
		
			; Loop forever, safer at this point
			false
		)
		31
	)
)

; tyson: sanctum lift crusher kill volume
(script dormant e10_sanctum_lift_crusher
	(sleep_until
		(begin
			(if (>= (device_get_position sanctum_lift) 0.955)
				(kill_volume_enable kill_sanctum_crusher)
				(kill_volume_disable kill_sanctum_crusher)
			)
			
			; Just go forever
			false
		)
		3
	)
)

(script dormant e10_battle
	(sleep_until (volume_test_objects tv_e10_trigger2 (players)) 15)
	;(object_damage_damage_section e10_destroyed_column main 1)
	(wake e10_infinite_save)
	(data_mine_set_mission_segment inner_sanctum)
	(wake e10_storm)
	(sleep 90)
	(wake chapter_sanctified)
	(wake objective_riptide_clear)
	
	(ai_disposable e8_pro_inf1 true)
	(ai_disposable e8_fld_inf1 true)

	(sleep_until (<= (device_get_position sanctum_lift) 1) 10)
	(sleep_until (volume_test_objects tv_e10_trigger1 (players)) 15)
	(device_set_position sanctum_lift 0)
)


(script dormant e10_talking_points
	(sleep_until
		(and
			 (= g_e10_talk 1)
			 (= g_dialogue_counter 6)
		)
	) ; tyson_note: unsafe, dual conditions...
	(if dialogue (print "TRUTH: This crisis will not be the end of us! It is but one, last hurdle before the Journey and salvation!"))

	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0170_pot" e10_speaker1 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0170_pot" e10_speaker2 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0170_pot" e10_speaker3 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0170_pot" e10_speaker4 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0170_pot" e10_speaker5 1.0 1)
	(sleep (ai_play_line_on_object e10_speaker0 0170))

	(sleep dialogue_pause)
	(set g_dialogue_counter 7)
)


(script dormant e10_start
	(wake e10_battle)
	(wake e10_end_open)
	(wake e10_talking_points)
	(sleep_until (volume_test_objects_all tv_e10_trigger1 (players)) 15)
	;(sleep 60)
	;(device_set_position sanctum_lift 0)
; tyson: moved	(wake music_07b_06_start)
	(sleep (random_range 150 240))
;	(ai_place e10_fld_swarm1 2)
	(sleep (random_range 90 150))
;	(ai_place e10_fld_swarm1 3)
)

(script dormant e10_music_aux
	(sleep_until (>= (device_get_position sanctum_lift) 1) 10)	; Wait until it's in place to be sure
	(sleep_until (< (device_get_position sanctum_lift) 1) 10)	; Then wait for it to move
	(wake music_07b_06_start)
	(sleep 2)
	(game_save)
)

(script dormant e10_load
	(device_set_position_immediate sanctum_lift 1)
	(wake e10_sanctum_lift_recall)
	(wake e10_sanctum_lift_crusher)
	(wake e10_music_aux)
	(objects_attach sanctum_lift "switch" sanctum_lift_control "")
	(sleep_until (volume_test_objects tv_e9_end (players)) 15)
	(game_save_cancel)
	(sleep 6)
	(game_save)
	(wake e10_start)
)

(script dormant e10_key
	(if (not (difficulty_legendary)) (sleep_forever))
	(object_create key)
	(sleep_until 
		(or
			(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
			(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
		)
	)
	(ice_cream_flavor_stock 11) ; Iron
)

(script dormant e10_main
	; tyson: prior initial conditions
	(sleep_until (volume_test_objects tv_e9_trigger1 (players)) 15)
	(wake e10_load)
	(wake e10_key)
	
	; Start next encounter
	(wake e12_main)
	
	; Dispose
	(ai_disposable e9_fld_inf1 true)
)


;=======================================================================================================
;= ENCOUNTER 10 - LAST STAND IN THE INNER SANCTUM =======================================================
;=======================================================================================================


(script dormant e9_start
	(sleep_until (volume_test_objects tv_e9_trigger1 (players)) 15)
	(data_mine_set_mission_segment hallway_attack)
; tyson	(wake e10_load)
	(if
		(game_safe_to_save)
		(game_save)
	)
	(sleep 5)
	(if
		(game_safe_to_save)
		(begin
			(if
				(volume_test_objects_all tv_e9_trigger1 (players))
				(begin_random
					(begin
						(if
							(<= (ai_living_count e9_fld_inf1) 0)
							(begin
								(sleep_until (volume_test_objects tv_e9_surprise (players)))
								(ai_place e9_fld_inf1/guy1)
								(sound_impulse_start sound\characters\flood\flood_howls e9_howler1 1)
							)
						)
					)
					(begin
						(if
							(<= (ai_living_count e9_fld_inf1) 0)
							(ai_place e9_fld_inf1/guy2)
						)
					)
					(begin
						(if
							(<= (ai_living_count e9_fld_inf1) 0)
							(ai_place e9_fld_inf1/guy3)
						)
					)
				)
			)
		)
	)
)

(script dormant e9_main
	; tyson: prior initial conditions
	(sleep_until (volume_test_objects tv_e7_trigger2 (players)) 15)
	(game_save)
	(sleep_until (volume_test_objects tv_e8_end (players)) 15)
	(wake e9_start)
	
	; Start next encounter
	(wake e10_main)

	; Dispose
	(ai_disposable e8_fld_inf1 true)
	(ai_disposable e8_fld_swarm1 true)
	(ai_disposable e8_pro_inf1 true)
)


;============================================================================================================
;= ENCOUNTER 9 - A SCARY SNEAK ATTACK IN THE HALLWAY ========================================================
;============================================================================================================


(global short g_e8_counter 0)


(script dormant e8_end_open
;*	; tyson: making this more robust... tiny trigger volume, dialogue test, yuck
	(sleep_until
		(and
			(volume_test_objects tv_e8_end (players))
			(= g_dialogue_counter 5)
		)
	) ; tyson_note: unsafe because it combines with a location test
*;
	(sleep_until (volume_test_objects tv_e8_end (players)) 15)
	(sleep_until (= g_dialogue_counter 5) 15)

;	(wake e9_start) ; tyson: split this out of the dialogue flow
	(wake music_07b_05_stop)
	(sleep 120)
	(if
		dialogue
		(print "CORTANA: Apparently these are the Prophet Hierarch's private quarters - their Inner Sanctum.")
	)
	(sleep (ai_play_line_on_object none 2770))
	(set g_dialogue_counter 6)
	(game_save)
)


(script dormant e8_infinite_save
	(game_save_no_timeout)
)

; tyson: split out of main flow
(script dormant e8_sneaky_spawner_dialogue
	(sleep_until (= g_dialogue_counter 4))

	(if
		dialogue
		(print "TRUTH: Whosoever is gripped by fear, take heed: I am the Prophet of Truth, and I am not afraid!")
	)
		
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0210_pot" e8_speaker1 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0210_pot" e8_speaker2 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0210_pot" e8_speaker3 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0210_pot" e8_speaker4 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0210_pot" e8_speaker5 1.0 1)
	(sleep (ai_play_line_on_object e8_speaker0 0210))
	
	(sleep 20)
	(if
		dialogue
		(print "TRUTH: Noble Mercy is here, at my side - his wise counsel ever in my ears!")
	)

	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0270_pot" e8_speaker1 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0270_pot" e8_speaker2 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0270_pot" e8_speaker3 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0270_pot" e8_speaker4 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0270_pot" e8_speaker5 1.0 1)
	(sleep (ai_play_line_on_object e8_speaker0 0270))

	(sleep dialogue_pause)

	(if
		dialogue
		(print "GRAVEMIND: We exist together now. Two corpses in one grave.")
	)

	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_5000_grv" e8_speaker_gm1 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_5000_grv" e8_speaker_gm2 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_5000_grv" e8_speaker_gm3 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_5000_grv" e8_speaker_gm4 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_5000_grv" e8_speaker_gm5 1.0 1)
	(sleep (ai_play_line_on_object e8_speaker_gm0 5000))

	(game_save_no_timeout)
	(set g_dialogue_counter 5)
)

(script dormant e8_sneaky_spawner
	(sleep_until (volume_test_objects tv_e8_trigger2_a (players)))
	(if
		(or
			(difficulty_normal)
			(difficulty_heroic)
		)
		(ai_place e8_pro_inf1 2)
		(ai_place e8_pro_inf1 3)
	)
	(game_save_no_timeout)
	(wake e8_sneaky_spawner_dialogue)
;	(sleep_until (= g_dialogue_counter 4)) ; tyson_note: this is unsafe because it is followed by a test for a trigger volume, down a few pages
;*	; tyson: split out into e8_sneaky_spawner_dialogue
	(if
		dialogue
		(print "TRUTH: Whosoever is gripped by fear, take heed: I am the Prophet of Truth, and I am not afraid!")
	)
	(sleep (ai_play_line_on_object none 0210))
	(sleep 30)
	(if
		dialogue
		(print "TRUTH: Noble Mercy is here, at my side - his wise counsel ever in my ears!")
	)
*;	(if
		(volume_test_objects tv_e8_cave_check (players))
		(begin
			(if
				(or
					(difficulty_normal)
					(difficulty_heroic)
				)
				(ai_place e8_pro_inf1 2)
				(ai_place e8_pro_inf1 3)
			)
		)
	)
;*	; tyson: split out into e8_sneaky_spawner_dialogue
	(sleep (ai_play_line_on_object none 0270))
	(sleep dialogue_pause)
	(if
		dialogue
		(print "GRAVEMIND: We exist together now. Two corpses in one grave.")
	)
	(sleep (ai_play_line_on_object none 5000))
	(set g_dialogue_counter 5)
*;
	(if
		(or
			(difficulty_normal)
			(difficulty_heroic)
		)
;FOR NORMAL AND HEROIC
		(begin
			(begin_random
				(begin
					(if
						(and
							(<= (ai_living_count e8_fld_inf1) 3)
							(volume_test_objects tv_e8_cave_check (players))
						)
						(begin
							(if
								(random_range 0 2)
								(sound_impulse_start sound\characters\flood\flood_howls e8_howler1 1)
								(sound_impulse_start sound\characters\flood\flood_howls e8_howler3 1)
							)
							(ai_place e8_fld_inf1/guy10)
							(sleep (random_range 30 180))
						)
					)
				)
				(begin
					(if
						(and
							(<= (ai_living_count e8_fld_inf1) 3)
							(volume_test_objects tv_e8_cave_check (players))
						)
						(begin
							(if
								(random_range 0 2)
								(sound_impulse_start sound\characters\flood\flood_howls e8_howler1 1)
								(sound_impulse_start sound\characters\flood\flood_howls e8_howler3 1)
							)
							(ai_place e8_fld_inf1/guy9)
							(sleep (random_range 30 180))
						)
					)
				)
				(begin
					(if
						(and
							(<= (ai_living_count e8_fld_inf1) 3)
							(volume_test_objects tv_e8_cave_check (players))
						)
						(begin
							;(if
							;	(random_range 0 2)
							;	(sound_impulse_start sound\characters\flood\flood_howls e8_howler1 1)
							;	(sound_impulse_start sound\characters\flood\flood_howls e8_howler3 1)
							;)
							(ai_place e8_fld_inf1/guy8)
							(sleep (random_range 30 180))
						)
					)
				)
				(begin
					(if
						(and
							(<= (ai_living_count e8_fld_inf1) 3)
							(volume_test_objects tv_e8_cave_check (players))
						)
						(begin
							;(if
							;	(random_range 0 2)
							;	(sound_impulse_start sound\characters\flood\flood_howls e8_howler1 1)
							;	(sound_impulse_start sound\characters\flood\flood_howls e8_howler3 1)
							;)
							(ai_place e8_fld_inf1/guy7)
							(sleep (random_range 30 180))
						)
					)
				)
			)
			(sleep_until (<= (ai_strength e8_fld_inf1) .3) 15 1800)
			;(set g_e8_counter 3)
			(begin_random
				(begin
					(if
						(<= (ai_living_count e8_fld_inf1) 3)
						(begin
							(if
								(random_range 0 2)
								(sound_impulse_start sound\characters\flood\flood_howls e8_howler1 1)
								(sound_impulse_start sound\characters\flood\flood_howls e8_howler3 1)
							)
							(ai_place e8_fld_inf1/guy10)
							(sleep (random_range 30 180))
						)
					)
				)
				(begin
					(if
						(<= (ai_living_count e8_fld_inf1) 3)
						(begin
							(if
								(random_range 0 2)
								(sound_impulse_start sound\characters\flood\flood_howls e8_howler1 1)
								(sound_impulse_start sound\characters\flood\flood_howls e8_howler3 1)
							)
							(ai_place e8_fld_inf1/guy9)
							(sleep (random_range 30 180))
						)
					)
				)
				(begin
					(if
						(<= (ai_living_count e8_fld_inf1) 3)
						(begin
							(ai_place e8_fld_inf1/guy8)
							(sleep (random_range 30 180))
						)
					)
				)
				(begin
					(if
						(<= (ai_living_count e8_fld_inf1) 3)
						(begin
							(ai_place e8_fld_inf1/guy7)
							(sleep (random_range 30 180))
						)
					)
				)
			)
		)
; FOR LEGENDARY
		(begin
			(begin_random
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(ai_place e8_fld_inf1/guy10)
							(sleep (random_range 30 90))
						)
					)
				)
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(ai_place e8_fld_inf1/guy9)
							(sleep (random_range 30 90))
						)
					)
				)
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(ai_place e8_fld_inf1/guy8)
							(sleep (random_range 30 90))
						)
					)
				)
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(ai_place e8_fld_inf1/guy7)
							(sleep (random_range 30 90))
						)
					)
				)
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(ai_place e8_fld_inf1/guy12)
							(sleep (random_range 30 90))
						)
					)
				)
			)
			(sleep_until (<= (ai_strength e8_fld_inf1) .3) 15 450)
			;(set g_e8_counter 3)
			(begin_random
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(ai_place e8_fld_inf1/guy11)
							(sleep (random_range 30 90))
						)
					)
				)
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(ai_place e8_fld_inf1/guy9)
							(sleep (random_range 30 90))
						)
					)
				)
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(ai_place e8_fld_inf1/guy8)
							(sleep (random_range 30 90))
						)
					)
				)
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(ai_place e8_fld_inf1/guy7)
							(sleep (random_range 30 90))
						)
					)
				)
			)
			(sleep_until (<= (ai_strength e8_fld_inf1) .5) 15 450)
			(begin_random
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(if
								(random_range 0 2)
								(sound_impulse_start sound\characters\flood\flood_howls e8_howler1 1)
								(sound_impulse_start sound\characters\flood\flood_howls e8_howler3 1)
							)
							(ai_place e8_fld_inf1/guy9)
							(ai_set_orders e8_fld_inf1 e8_fld_inf1_z)
							(sleep (random_range 30 90))
						)
					)
				)
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(if
								(random_range 0 2)
								(sound_impulse_start sound\characters\flood\flood_howls e8_howler1 1)
								(sound_impulse_start sound\characters\flood\flood_howls e8_howler3 1)
							)
							(ai_place e8_fld_inf1/guy10)
							(ai_set_orders e8_fld_inf1 e8_fld_inf1_z)
							(sleep (random_range 30 90))
						)
					)
				)
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(ai_place e8_fld_inf1/guy11)
							(ai_set_orders e8_fld_inf1 e8_fld_inf1_z)
							(sleep (random_range 30 90))
						)
					)
				)
				(begin
					(if
						(volume_test_objects tv_e8_cave_check (players))
						(begin
							(ai_place e8_fld_inf1/guy12)
							(ai_set_orders e8_fld_inf1 e8_fld_inf1_z)
							(sleep (random_range 30 90))
						)
					)
				)
			)
		)
	)		
)


(script dormant e8_load
	(sleep_until (volume_test_objects tv_e7_trigger2 (players)) 15)
	(data_mine_set_mission_segment space_cave2)
;	(wake e8_talking)
	(ai_place e8_fld_swarm1)
	(ai_place e8_fld_inf1/guy5)
	(begin_random
		(begin
			(if
				(<= (ai_living_count e8_fld_inf1) 2)
				(ai_place e8_fld_inf1/guy1)
			)
		)
		(begin
			(if
				(<= (ai_living_count e8_fld_inf1) 2)
				(ai_place e8_fld_inf1/guy2)
			)
		)
		(begin
			(if
				(<= (ai_living_count e8_fld_inf1) 2)
				(ai_place e8_fld_inf1/guy3)
			)
		)
		(begin
			(if
				(<= (ai_living_count e8_fld_inf1) 2)
				(ai_place e8_fld_inf1/guy4)
			)
		)
		(begin
			(if
				(<= (ai_living_count e8_fld_inf1) 2)
				(ai_place e8_fld_inf1/guy6)
			)
		)
		; tyson_note: wtf? I'm sure he didn't mean to put this in here...
;*		(ai_disposable e6_fld_inf1 true)
		(ai_disposable e6_fld_inf1_a true)
		(ai_disposable e6_fld_inf2_a true)
		(ai_disposable e6_fld_inf2_b true)
		(ai_disposable e6_fld_inf2_c true)
		(ai_disposable e6_fld_inf2_d true)
		(ai_disposable e6_fld_inf2_z true)
		(ai_disposable e6_fld_inf3 true)
		(ai_disposable e6_fld_inf4 true)
		(ai_disposable e6_pro_inf2_a true)
		(ai_disposable e6_pro_inf2 true)
		(ai_disposable e6_pro_inf3 true)
		(ai_disposable e6_pro_inf3_a true)
*;
	)

	; tyson: moved from outside of the begin_random statement
	(ai_disposable e6_fld_inf1 true)
	(ai_disposable e6_fld_inf1_a true)
	(ai_disposable e6_fld_inf2_a true)
	(ai_disposable e6_fld_inf2_b true)
	(ai_disposable e6_fld_inf2_c true)
	(ai_disposable e6_fld_inf2_d true)
	(ai_disposable e6_fld_inf2_z true)
	(ai_disposable e6_fld_inf3 true)
	(ai_disposable e6_fld_inf4 true)
	(ai_disposable e6_pro_inf2_a true)
	(ai_disposable e6_pro_inf2 true)
	(ai_disposable e6_pro_inf3 true)
	(ai_disposable e6_pro_inf3_a true)

	(wake e8_sneaky_spawner)
	;(wake e8_flood_assault)
	(wake e8_end_open)
	(sleep_until (= g_dialogue_counter 3))	; tyson: again, this is simply delaying until previous dialogue is finished
	(if 
		dialogue
		(print "CORTANA: The security systems in this part of the tower are particularly robust.")
	)
	(sleep (ai_play_line_on_object none 2760))
	(set g_dialogue_counter 4)
	(wake music_07b_05_start)
)

(script dormant e8_main
	; tyson: prior initial conditions
	(sleep_until (volume_test_objects tv_e7_trigger1 (players)) 15)
	(wake e8_load)
	
	; Start next encounter
	(wake e9_main)
)

;==================================================================================================
;= ENCOUNTER 8 - BUGGERS COUNTERATTACK THE SECOND SPACE CAVE ======================================
;==================================================================================================


(script dormant e7_start
	(sleep_until (volume_test_objects tv_e7_trigger1 (players)) 15)
	(data_mine_set_mission_segment boobag_garden)
	(game_save_cancel)
	(sleep 6)
	(game_save) ; pbertone (put this save a bit later 
	;(game_can_use_flashlights 0)
; tyson	(wake e8_load)
	(wake music_07b_04_stop)
	(sleep_until (= g_dialogue_counter 9))	; tyson_note: this is probably OK... it's just going to delay the dialogue until previous dialogue is finished
	(sleep 150)
	;(game_can_use_flashlights 1)
	(if
		dialogue
		(print "CORTANA: The amount of Flood bio-mass is increasing exponentially. There are reports of infestations in every district!")
	)
;	(sleep (ai_play_line_on_object none 2860))
	(sleep (sound_impulse_language_time "sound\dialog\levels\07_highcharity\mission\l07_2860_cor"))
	(sleep dialogue_pause)
	(if 
		dialogue
		(print "CORTANA: If the speed of the Flood's spread in this tower is any indication, it won't take long for it to overrun the entire city!")
	)
;	(sleep (ai_play_line_on_object none 2870))
	(sleep (sound_impulse_language_time "sound\dialog\levels\07_highcharity\mission\l07_2870_cor"))
	(sleep dialogue_pause)
	(set g_dialogue_counter 3)
)

(script dormant e7_main
	; tyson: prior initial conditions
	(sleep_until (volume_test_objects tv_e6_trigger1 (players)) 15)
	(wake e7_start)
	(game_save_no_timeout)
	
	; Start next encounter
	(wake e8_main)

	; Dispose
	(ai_disposable e6_fld_inf1 true)
	(ai_disposable e6_fld_inf1_a true)
	(ai_disposable e6_fld_inf2_z true)
	(ai_disposable e6_fld_inf2_d true)
	(ai_disposable e6_fld_inf2_c true)
	(ai_disposable e6_fld_inf2_b true)
	(ai_disposable e6_fld_inf2_a true)
	(ai_disposable e6_pro_inf2_a true)
	(ai_disposable e6_pro_inf2 true)
	(ai_disposable e6_fld_inf4 true)
	(ai_disposable e6_fld_inf3 true)
	(ai_disposable e6_fld_inf5 true)
	(ai_disposable e6_pro_inf3_a true)
	(ai_disposable e6_pro_inf3 true)
)


;==================================================================================================
;= ENCOUNTER 7 - A QUIET GARDEN...OF BOO BAGS! ====================================================
;==================================================================================================


(global boolean g_e6_move_on 0)


(script dormant e6_talking
;*	(sleep_until
		(and
			(volume_test_objects tv_e6_talkbox (players))
			(= g_dialogue_counter 2)
		)
	)	; tyson_note: this is unsafe because the counter must be at a state and the player in the nonblocking volume
*;
	(sleep_until (volume_test_objects tv_e6_talkbox (players)) 15)
	(set g_dialogue_counter 9)
	(if
		dialogue
		(print "TRUTH: The Parasite did not defeat the Forerunners, and it shall not defeat us!")
	)

	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0190_pot" e6_speaker1 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0190_pot" e6_speaker2 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0190_pot" e6_speaker3 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0190_pot" e6_speaker4 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_0190_pot" e6_speaker5 1.0 1)
	(sleep (ai_play_line_on_object e6_speaker0 0190))

	(sleep 20)
	(if
		dialogue
		(print "GRAVEMIND: Arrogant creature! Your deaths will be instantaneous, while we shall suffer the progress of infinitude!")
	)

	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_5010_grv" e6_speaker1 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_5010_grv" e6_speaker2 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_5010_grv" e6_speaker3 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_5010_grv" e6_speaker4 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_5010_grv" e6_speaker5 1.0 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_5010_grv" e6_speaker_gm1 1.0 1)
	(sleep (ai_play_line_on_object e6_speaker_gm0 5010))

	(wake music_07b_04_start)
)

(script dormant e6_go_go_go ;All living Flood to the Space Cave please!
	(sleep_until (volume_test_objects tv_e6_cave_check (players)))
	(ai_migrate e6_flood_group_1 e6_flood_group_3)
	(sleep 10)
	(ai_migrate e6_flood_group_2 e6_flood_group_3)
	(sleep 10)
	(ai_migrate e6_flood_storm e6_flood_group_3)
	(sleep 10)
	(ai_set_orders e6_flood_group_3 e6_fld_go_go_go)
	(set g_e6_move_on 1)
)


(script dormant e6_final ;Final Prophet Squad in Space Cave 1
	(sleep_until (volume_test_objects tv_e6_final_start (players)))
	(data_mine_set_mission_segment space_cave1)
	(wake e6_talking)
	(wake e6_go_go_go)
	(ai_place e6_pro_inf3 2)
	(ai_place e6_pro_inf3_a 3)
	(sleep_until (<= (ai_strength e6_pro_cave1) .2)15 600)
	(if
		(volume_test_objects tv_e6_cave_check (players))
		(ai_place e6_fld_inf5)
	)
)


(script dormant e6_ambush ;Ambush at the Prophet hardpoint!
	(sleep_until (volume_test_objects tv_e6_ambusher (players)))
	(game_save)
	(sleep 15)
	(ai_place e6_fld_inf3)
	(begin_random
		(begin
			(if 
				(and
					(<= (ai_living_count e6_flood_storm) 5)
					(volume_test_objects tv_e6_ambusher (players))
				)
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e6_howler_spec1 1)
					(ai_place e6_fld_inf4/guy1)
					(if
						g_e6_move_on
						(ai_set_orders e6_fld_inf4 e6_fld_go_go_go)
					)
					(sleep (random_range 90 150))
					(ai_place e6_fld_inf4/guy2)
					(if
						g_e6_move_on
						(ai_set_orders e6_fld_inf4 e6_fld_go_go_go)
					)
					;(sleep (random_range 90 150))
					;(ai_place e6_fld_inf4/guy3)
				)
			)
		)
		(begin
			(if
				(and
					(<= (ai_living_count e6_flood_storm) 5)
					(volume_test_objects tv_e6_ambusher (players))
				)
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e6_howler_spec2 1)
					(ai_place e6_fld_inf4/guy4)
					(if
						g_e6_move_on
						(ai_set_orders e6_fld_inf4 e6_fld_go_go_go)
					)
					(sleep (random_range 90 150))
					(ai_place e6_fld_inf4/guy5)
					(if
						g_e6_move_on
						(ai_set_orders e6_fld_inf4 e6_fld_go_go_go)
					)
				)
			)
		)
		(begin
			(if
				(and
					(<= (ai_living_count e6_flood_storm) 5)
					(volume_test_objects tv_e6_ambusher (players))
				)
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e6_howler_spec3 1)
					(ai_place e6_fld_inf4/guy6)
					(if
						g_e6_move_on
						(ai_set_orders e6_fld_inf4 e6_fld_go_go_go)
					)
					(sleep (random_range 90 150))
					(ai_place e6_fld_inf4/guy7)
					(if
						g_e6_move_on
						(ai_set_orders e6_fld_inf4 e6_fld_go_go_go)
					)
					;(sleep (random_range 90 150))
				)
			)
		)
		(begin
			(if
				(and
					(<= (ai_living_count e6_flood_storm) 5)
					(volume_test_objects tv_e6_ambusher (players))
				)
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e6_howler_spec4 1)
					(ai_place e6_fld_inf4/guy8)
					(if
						g_e6_move_on
						(ai_set_orders e6_fld_inf4 e6_fld_go_go_go)
					)
					(sleep (random_range 90 150))
					(ai_place e6_fld_inf4/guy9)
					(if
						g_e6_move_on
						(ai_set_orders e6_fld_inf4 e6_fld_go_go_go)
					)
				;(sleep (random_range 90 150))
				;(ai_place e6_fld_inf4/guy10)
				)
			)		
		)
		(begin
			(if
				(and
					(<= (ai_living_count e6_flood_storm) 5)
					(volume_test_objects tv_e6_ambusher (players))
				)
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e6_howler_spec4 1)
					(ai_place e6_fld_inf2_z/guy1)
					(sleep 6)
					(ai_migrate e6_fld_inf2_z e6_fld_inf4)
					(sleep 6)
					(if
						g_e6_move_on
						(ai_set_orders e6_fld_inf4 e6_fld_go_go_go)
					)
					(sleep (random_range 90 150))
					(ai_place e6_fld_inf2_z/guy2)
					(sleep 6)
					(ai_migrate e6_fld_inf2_z e6_fld_inf4)
					(sleep 6)
					(if
						g_e6_move_on
						(ai_set_orders e6_fld_inf4 e6_fld_go_go_go)
					)
				;(sleep (random_range 90 150))
				;(ai_place e6_fld_inf4/guy10)
				)
			)		
		)
		(begin
			(if
				(and
					(<= (ai_living_count e6_flood_storm) 5)
					(volume_test_objects tv_e6_ambusher (players))
				)
				(begin
					(sound_impulse_start sound\characters\flood\flood_howls e6_howler_spec4 1)
					(ai_place e6_fld_inf2_z/guy3)
					(sleep 6)
					(ai_migrate e6_fld_inf2_z e6_fld_inf4)
					(sleep 6)
					(if
						g_e6_move_on
						(ai_set_orders e6_fld_inf4 e6_fld_go_go_go)
					)
					(sleep (random_range 90 150))
					(ai_place e6_fld_inf2_z/guy4)
					(sleep 6)
					(ai_migrate e6_fld_inf2_z e6_fld_inf4)
					(sleep 6)
					(if
						g_e6_move_on
						(ai_set_orders e6_fld_inf4 e6_fld_go_go_go)
					)
				;(sleep (random_range 90 150))
				;(ai_place e6_fld_inf4/guy10)
				)
			)		
		)
	)
)


(script command_script e6_cs_attack_the_prophetsCD ;WTF
; tyson: this doesn't work	(ai_set_blind ai_current_actor true)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(cs_force_combat_status 3)
	(cs_go_by e6_attack/p0 e6_attack/p1)
	(cs_go_by e6_attack/p2 e6_attack/p3)
; tyson: this doesn't work	(ai_set_blind ai_current_actor false)
)


(script command_script e6_cs_attack_the_prophetsAB ;WTF
; tyson: this doesn't work	(ai_set_blind ai_current_actor true)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(cs_force_combat_status 3)
	(cs_go_by e6_attack/p4 e6_attack/p5)
	(cs_go_by e6_attack/p2 e6_attack/p3)
; tyson: this doesn't work	(ai_set_blind ai_current_actor false)
)


(script dormant e6_flood_attack_2
	(sleep_until (volume_test_objects tv_e6_trigger3 (players)))
	(game_save_no_timeout)
	(data_mine_set_mission_segment riptide_ambush)

	(wake e6_ambush)
	(wake e6_final)

	(ai_place e6_pro_inf2 2)
	(ai_place e6_pro_inf2_a 2)

	(ai_disposable e5_pro_inf1 true)
	(ai_disposable e5_pro_bug2_c true)
	(ai_disposable e5_fld_inf1 true)
	(ai_disposable e5_fld_inf2 true)
	(ai_disposable e5_fld_inf2_z true)
	
	;(print "dialog")
	;Place Flood swarmin' down the halls
	(begin_random
		(begin
			(if
				(<= (ai_living_count e6_flood_group_2) 0)
				(begin
					(sleep 10)
					(ai_place e6_fld_inf2_a) ;three dudes
					(ai_place e6_fld_inf2_b) ;two dudes
					(sound_impulse_start sound\characters\flood\flood_howls e6_howler1 1)					
				)
			)
		)
		
		(begin
			(if
				(<= (ai_living_count e6_flood_group_2) 0)
				(begin
					(sleep 10)
					(ai_place e6_fld_inf2_c) ;three dudes
					(ai_place e6_fld_inf2_d) ;two dudes
					(sound_impulse_start sound\characters\flood\flood_howls e6_howler2 1)
				)
			)
		)
	)
	;(print "waiting on z conditions")
	(sleep_until (<= (ai_nonswarm_count e6_flood_group_2) 1)10 300)

	;(print "should place z guys")
	(ai_place e6_fld_inf2_z 1)

;	(print "placed a z guy")
	(sleep_until (<= (ai_nonswarm_count e6_flood_group_2) 0)10 450)
	(if 
		(volume_test_objects tv_e6_infinite2 (players))
		(ai_place e6_fld_inf2_z 1)
		;(print "placed a z guy")
	)
	(sleep_until (<= (ai_nonswarm_count e6_flood_group_2) 0)10 450)
	(if 
		(volume_test_objects tv_e6_infinite2 (players))
		(ai_place e6_fld_inf2_z 1)
		;(print "placed a z guy")
	)
)


(script dormant e6_infinite_save
	(game_save_no_timeout)
)


(script dormant e6_flood_attack_1
	(sleep_until (<= (ai_living_count e6_fld_inf1) 0)15 300)
	(game_save)
	;Place an assault Flood bustin' out of a hallway window
	(wake e7_DIA_filtration_systems)
	(begin_random
		(begin
			(if
				(and		
					(<= (ai_living_count e6_flood_group_1) 0)
					(volume_test_objects tv_e6_infinite1 (players))
				)
				(begin
					(ai_place e6_fld_inf1_a/guy1)
					;(sound_impulse_start sound\characters\flood\flood_howls e6_howler3 1)
				)
			)
		)
		(begin
			(if
				(and		
					(<= (ai_living_count e6_flood_group_1) 0)
					(volume_test_objects tv_e6_infinite1 (players))
				)
				(begin
					(sleep 10)
					(ai_place e6_fld_inf1_a/guy2)
					;(sound_impulse_start sound\characters\flood\flood_howls e6_howler3 1)
				)
			)
		)
		(begin
			(if
				(and		
					(<= (ai_living_count e6_flood_group_1) 0)
					(volume_test_objects tv_e6_infinite1 (players))
				)
				(begin
					(sleep 10)
					(ai_place e6_fld_inf1_a/guy3)
					;(sound_impulse_start sound\characters\flood\flood_howls e6_howler3 1)
				)
			)
		)
		(begin
			(if
				(and		
					(<= (ai_living_count e6_flood_group_1) 0)
					(volume_test_objects tv_e6_infinite1 (players))
				)
				(begin
					(sleep 10)
					(ai_place e6_fld_inf1_a/guy4)
					;(sound_impulse_start sound\characters\flood\flood_howls e6_howler3 1)
				)
			)
		)
	)
	(game_save)
)

(script dormant e6_start
	(sleep_until (volume_test_objects tv_e6_trigger1 (players)) 15)
	(wake chapter_please)
	(wake objective_riptide_set)
	(game_save_cancel)
	(data_mine_set_mission_segment riptide_start)
	(game_save)
	;(game_can_use_flashlights 0)
	;(sleep 6)
	;(game_can_use_flashlights 1)
	(ai_place e6_fld_inf1 2)
	(sleep 30)
	(wake music_07b_03_start)
	(wake e6_flood_attack_1)
	(wake e6_flood_attack_2)
; tyson	(wake e7_start)
)

(script dormant e6_main
	; tyson: prior initial conditions
	(sleep_until (volume_test_objects tv_e5_trigger1 (players)) 15)	
	(wake e6_start)
	(game_save)

	; Start next encounter
	(wake e7_main)

	; Dispose
	(ai_disposable e5_pro_inf1 true)
	(ai_disposable e5_fld_inf1 true)
	(ai_disposable e5_pro_bug1 true)
	(ai_disposable e5_pro_bug2_c true)
	(ai_disposable e5_fld_inf2 true)
	(ai_disposable e5_fld_inf2_z true)
)


;==================================================================================================
;= ENCOUNTER 6 - A RISING RIPTIDE OF FLOOD ======================================================== 
;==================================================================================================


(script dormant e5_platform_c
	;PLAY A PARTICLE EFFECT TO INDICATE THAT THE WHOLE THING IS NOW ACTIVE
	(sleep_until (volume_test_objects tv_e5_platform_c1 (players)) 15)
	(device_set_position maus_platform_d 0)
	(sleep_until (<= (device_get_position maus_platform_d) 0) 10)
	;PLAY A PARTICLE EFFECT TO INDICATE THE PLATFORM IS ACTIVATED
	;(print "particle effect on platform D")
	(device_set_position_immediate gravity_bridge_c1 1)
	(device_set_power gravity_bridge_c1 1)
	(sleep 1)
	;(print "particle effect on the gravity bridge")
	(sleep_until (volume_test_objects tv_e5_platform_c1 (players)) 15)
	(device_set_position gravity_bridge_c1 0)
	(sleep_until (<= (device_get_position gravity_bridge_c1) 0) 10)
	(device_set_power gravity_bridge_c1 0)
	(device_set_position_immediate gravity_bridge_c1 1)
)


(script dormant e5_platform_b
	(sleep_until
		(begin
			;PLAY A PARTICLE EFFECT TO INDICATE THAT THE WHOLE THING IS NOW ACTIVE
			(sleep_until (volume_test_objects tv_e5_platform_b1 (players)) 15)
			(device_set_position maus_platform_d 0)
			(sleep_until (<= (device_get_position maus_platform_d) 0) 10)
			;PLAY A PARTICLE EFFECT TO INDICATE THE PLATFORM IS ACTIVATED
			;(print "particle effect on platform D")
			(device_set_power gravity_bridge_b1 1)
			(sleep 30)
			;(print "particle effect on the gravity bridge")

			(sleep_until (volume_test_objects tv_e5_platform_b1 (players)) 15)
			(device_set_position gravity_bridge_b1 1)
			(sleep_until (>= (device_get_position gravity_bridge_b1) 1) 15)
			(device_set_power gravity_bridge_b1 0)
			(device_set_position_immediate gravity_bridge_b1 0)
		(= (structure_bsp_index) 2))
	)
)


(script dormant e5_platform_a2
	(sleep_until (volume_test_objects tv_e5_platform_a2 (players)) 15)
	(device_set_position maus_platform_c 0)
	(device_set_position_immediate gravity_bridge_a2 1)
	(sleep_until (<= (device_get_position maus_platform_c) 0) 15)
	;PLAY A PARTICLE EFFECT TO INDICATE THE PLATFORM IS ACTIVATED
	;(print "particle effect on platform C")
	(device_set_power gravity_bridge_a2 1)
	(sleep 1)
	;(print "particle effect on the gravity bridge")
	(sleep_until (volume_test_objects tv_e5_platform_a2 (players)) 15)
	(device_set_position gravity_bridge_a2 0)
	(sleep_until (<= (device_get_position gravity_bridge_a2) 0) 15)
	(device_set_power gravity_bridge_a2 0)
	(device_set_position_immediate gravity_bridge_a2 1)
	(wake e5_platform_c)
)


(script dormant e5_platform_a1
	;PLAY A PARTICLE EFFECT TO INDICATE THAT THE WHOLE THING IS NOW ACTIVE
	;(print "particle effect on the platform")
	(sleep_until
		(begin
			(sleep_until (volume_test_objects tv_e5_platform_a1 (players)) 15)
			;(device_set_position maus_platform_b 0)
			;(sleep_until (<= (device_get_position maus_platform_b) 0) 15)
			;PLAY A PARTICLE EFFECT TO INDICATE THE PLATFORM IS ACTIVATED
			;(print "particle effect on platform B")
			(device_set_power gravity_bridge_a1 1)
			(sleep 30)
			;(print "particle effect on the gravity bridge")

			(sleep_until (volume_test_objects tv_e5_platform_a1 (players)) 15)
			(device_set_position gravity_bridge_a1 1)
			(sleep_until (>= (device_get_position gravity_bridge_a1) 1) 15)
			(device_set_power gravity_bridge_a1 0)
			(device_set_position_immediate gravity_bridge_a1 0)
		(= (structure_bsp_index) 2))
	)
;	(wake e5_platform_b) this is woken at the same time "e5_platform_a1" is woken 
)


(script dormant e5_platform_begin
	(game_save)
	(device_set_power gravity_bridge_a1 0)
	(device_set_power gravity_bridge_a2 0)
	(device_set_power gravity_bridge_b1 0)
	(device_set_power gravity_bridge_c1 0)
	(device_set_position_immediate gravity_bridge_a1 0)
	(device_set_position_immediate gravity_bridge_a2 1)
	(device_set_position_immediate gravity_bridge_b1 0)
	(device_set_position_immediate gravity_bridge_c1 1)
	(object_create lift_effect_b)
	(sleep 1)
	(device_set_position lift_effect_b 1)
	(objects_attach maus_platform_b "lift_effect" lift_effect_b "lift_effect")
	(sleep_until (volume_test_objects tv_e5_platform_start (players)) 15)
	;(print "dropping the bridge")
	(device_set_position maus_platform_a 0)
	(object_create lift_effect_a)
	(sleep 1)
	(objects_attach maus_platform_a "lift_effect" lift_effect_a "lift_effect")
	(sleep_until (<= (device_get_position maus_platform_a) 0) 10)
	(device_set_position lift_effect_a 1)
	(wake e5_platform_a1)
	(wake e5_platform_b)
;	(wake e5_platform_a2)
)


(script command_script e5_cs_leave
	(cs_abort_on_damage true)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(cs_force_combat_status 3)
	(cs_go_to e5_leave/p0)
)


(script dormant e5_infinite_save
	(game_save_no_timeout)
)

(script dormant e5_fld_inf2_main
	(sleep_until (volume_test_objects tv_e5_trigger3 (players)) 15)
	(if
		(or
			(difficulty_normal)
			(difficulty_heroic)
		)
		(ai_place e5_fld_inf2 2)
		(ai_place e5_fld_inf2_z)
	)

	; Once the flood are dead, give a save point
	(sleep_until 
		(and
			(<= (ai_living_count e5_fld_inf2) 0)
			(<= (ai_living_count e5_fld_inf2_z) 0)
		)
	)
	(game_save)
)

(script dormant e5_start_the_other_fight
	(sleep_until (<= (device_get_position maus_platform_d) 0))
	(wake e5_infinite_save)
	(wake e5_fld_inf2_main)

	;(device_operates_automatically_set e5_plasma_door true)
	;(sleep 150)
	;(device_operates_automatically_set e5_plasma_door false)

	(sleep_until (volume_test_objects tv_e5_trigger_chase (players)))
;*	; The hard way
	(begin_random
		(begin
			(if
				(<= (ai_living_count e5_buggers) 5)
				(ai_place e5_pro_bug2_c/guy1)
			)
		)
		(begin
			(if
				(<= (ai_living_count e5_buggers) 5)
				(ai_place e5_pro_bug2_c/guy2)
			)
		)
		(begin
			(if
				(<= (ai_living_count e5_buggers) 5)
				(ai_place e5_pro_bug2_c/guy3)
			)
		)		
		(begin
			(if
				(<= (ai_living_count e5_buggers) 5)
				(ai_place e5_pro_bug2_c/guy4)
			)
		)
		(begin
			(if
				(<= (ai_living_count e5_buggers) 5)
				(ai_place e5_pro_bug2_c/guy5)
			)
		)
	)
*;
	; The easy way
	(ai_place e5_pro_bug2_c (pin (- 5 (ai_living_count e5_buggers)) 0 3))

	(ai_migrate e5_pro_bug1 e5_pro_bug2_c)
	(ai_set_orders e5_buggers e5_pro_bug2_c_attk)
	

;*
	(if		
		(and
			(volume_test_objects tv_e5_trigger_chase (players))
			(<= (ai_living_count e5_fld_inf2) 0)
		)		
	
		(ai_place e5_fld_inf2 2)
	)
	(sleep_until (<= (ai_living_count e5_fld_inf2) 0)15 450)
	(if		
		(volume_test_objects_all tv_e5_trigger_chase (players))
		(ai_place e5_fld_inf2 3)
	)
*;
)


(script dormant e5_bugger_spawner
;*	; tyson: this script is strangely written and I don't want to fix it
	(sleep_until
		(begin
			(begin_random
				(begin
					(if
						(<= (ai_living_count e5_buggers) 5)
						(ai_place e5_pro_bug2_c/guy1)
						(sleep (random_range 30 90))
					)
				)
				(begin
					(if
						(<= (ai_living_count e5_buggers) 5)
						(ai_place e5_pro_bug2_c/guy2)
						(sleep (random_range 30 90))
					)
				)
				(begin
					(if
						(<= (ai_living_count e5_buggers) 5)
						(ai_place e5_pro_bug2_c/guy3)
						(sleep (random_range 30 90))
					)
				)
				(begin
					(if
						(<= (ai_living_count e5_buggers) 5)
						(ai_place e5_pro_bug2_c/guy4)
						(sleep (random_range 30 90))
					)
				)
				(begin
					(if
						(<= (ai_living_count e5_buggers) 5)
						(ai_place e5_pro_bug2_c/guy5)
						(sleep (random_range 30 90))
					)
				)
			)
			(or
				(volume_test_objects tv_e5_plat_b (players))
				(volume_test_objects tv_e5_plat_c (players))
			)
		)
	)
*;

	; tyson: instead, a single wave of reinforcements
	(sleep_until (<= (ai_living_count e5_pro_bug1) 2))
	(ai_place e5_pro_bug2_c)
)
				

(script dormant e5_start_the_fight
	(sleep_until (volume_test_objects tv_e5_trigger2 (players)) 15)
	(ai_place e5_pro_bug1 6)
	(wake e5_bugger_spawner)
	(ai_place e5_fld_inf1 2)
	;(device_operates_automatically_set e5_plasma_door true)
	;(sleep 120)
	(sleep_until (<= (ai_living_count e5_fld_inf1) 0)15 450)
	(sleep (random_range 30 300))				
	(if
		(and
			(not
				(volume_test_objects tv_e5_plat_b (players))
			)
			(not
				(volume_test_objects tv_e5_plat_c (players))
			)
		)		
	
		(begin
			(ai_place e5_fld_inf1 3)
			;(device_operates_automatically_set e5_plasma_door true)
			;(sleep 120)
			;(device_operates_automatically_set e5_plasma_door false)
			(sleep_until (<= (ai_living_count e5_fld_inf1) 0))
			(sleep (random_range 30 150))			
		)
	)
	(if		
		(and
			(not
				(volume_test_objects tv_e5_plat_b (players))
			)
			(not
				(volume_test_objects tv_e5_plat_c (players))
			)
		)		
		(begin
			(ai_place e5_fld_inf1 3)
			;(device_operates_automatically_set e5_plasma_door true)
			;(sleep 120)
		;	(device_operates_automatically_set e5_plasma_door false)
		)
	)
	(sleep_until (<= (ai_living_count e5_fld_inf1) 0)15 450)
	(ai_set_orders e5_pro_inf1 e5_pro_inf1_leave)
	(ai_set_orders e5_fld_inf1 e5_pro_inf1_leave)
	;(device_operates_automatically_set e5_plasma_door true)
	;(sleep 180)
	;(device_operates_automatically_set e5_plasma_door false)
	(sleep 150)
	(ai_set_orders e5_buggers e5_pro_bug1_attk_player)
)


(script dormant e5_talking_points
	(wake e1_DIA_truth_holycity) ; tyson: repositioning
	(sleep 600)
	(if dialogue (print "CORTANA: I'll do what I can to slow the launch sequence, but there's something inside the ship... a presence... that's fighting back."))
	(sleep (ai_play_line_on_object none 2740))
	(sleep (* dialogue_pause 3))
	(if dialogue (print "CORTANA: For a Covenant construct it's unusually formidable."))
	(sleep (ai_play_line_on_object none 2750))
	(sleep (* dialogue_pause 5))
	(if
		(volume_test_objects tv_e5_trigger1 (players))
		(wake e5_DIA_get_to_conduit)
	)
)

;STARTING THE ENCOUNTER
(script dormant e5_start
	(sleep_until (volume_test_objects tv_e5_trigger1 (players)) 15)
	(device_set_position_immediate maus_platform_a 1)
	;(device_set_position_immediate maus_platform_b 1)
	;(device_set_position_immediate maus_platform_c 1)
	(device_set_position_immediate maus_platform_d 1)
	;(game_can_use_flashlights 0)
	;(sleep 6)
	;(game_can_use_flashlights 1)
	;(ai_place e5_pro_inf1)
	(data_mine_set_mission_segment plasma_chandelier)
	(game_save)
	(wake e5_platform_begin)
	(wake e5_start_the_fight)
	(wake e5_start_the_other_fight)
; tyson	(wake e6_start)
	(wake e5_talking_points)
	(ai_place e5_pro_inf1)
)

(script dormant e5_main
	; tyson: Initial conditions for e5_start
	(sleep_until (volume_test_objects tv_e1_trigger2 (players)) 15)
	(sleep_until (volume_test_objects tv_e2_trigger1 (players)) 15)
	(wake e5_start)
	
	; Start e6
	(wake e6_main)
	
	; Dispose
	(ai_disposable e1_fld_inf1 true)
	(ai_disposable e1_pro_inf1 true)
	(ai_disposable e1_fld_gitem1 true)
	(ai_disposable e1_fld_gitem2 true)
	(ai_disposable e1_pro_inf2 true)
	(ai_disposable e1_fld_inf2 true)
	(ai_disposable e1_fld_inf5 true)
	(ai_disposable e1_pro_inf3 true)
	(ai_disposable e1_fld_inf3 true)
)

(script dormant e2_cortana_intro
	(sleep_until (volume_test_objects tv_e2_trigger1 (players)) 15)
	(game_save_cancel)
	(sleep 6)
	(game_save_no_timeout)
; tyson	(wake e5_start)
	(sleep 150)
	(if
		dialogue
		(print "CORTANA: I'll disable this lift once you reach the top. That'll slow them down... I hope!")
	)
	(sleep (ai_play_line_on_object none 2720))
	(wake objective_enter_clear)
	(ai_disposable e1_fld_inf1 true)
	(ai_disposable e1_fld_inf2 true)
	(ai_disposable e1_fld_inf3 true)
	(ai_disposable e1_fld_inf4 true)
	(ai_disposable e1_fld_inf5 true)
	(ai_disposable e1_pro_inf1 true)
	(ai_disposable e1_pro_inf2 true)
	(ai_disposable e1_pro_inf3 true)
)


;==============================================================================================
;= ENCOUNTER 5 - BUGGERS DEFEND THE UPPER MAUSOLEUM ===========================================
;==============================================================================================

(global short g_e1_talk 0)	; tyson: deprecated, unused


(global boolean g_e1_music false)


(script command_script e1_cs_gitem1
	(ai_set_blind ai_current_actor true)
	(ai_set_deaf ai_current_actor true)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	;(cs_go_to_nearest gitem1)
	(cs_go_by gitem1/p1 gitem1/p2)
	(ai_set_blind ai_current_actor false)
	(ai_set_deaf ai_current_actor false)
)


(script command_script e1_cs_gitem2
	(ai_set_blind ai_current_actor true)
	(ai_set_deaf ai_current_actor true)	
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(cs_go_by gitem2/p1 gitem2/p2)
	(ai_set_blind ai_current_actor false)
	(ai_set_deaf ai_current_actor false)
)


(script command_script e1_cs_freakout
	(cs_movement_mode ai_movement_flee)
	(sleep_until
		(begin
			(begin_random
				(cs_go_to e1_panic/p0)
				(cs_go_to e1_panic/p1)
				(cs_go_to e1_panic/p2)
				(cs_go_to e1_panic/p3)
				(cs_go_to e1_panic/p4)
				(cs_go_to e1_panic/p5)
			)
		true
		)
	)
)


(script command_script e1_cs_teleport1
	(cs_teleport e1_drops/p1a e1_drops/p1b)
)


(script command_script e1_cs_teleport2
	(cs_teleport e1_drops/p2a e1_drops/p2b)
)


(global boolean g_e1_pelican2_entering false)
(script command_script e1_cs_pelican2
	;Pelican 2 starts it's fly in
	(cs_fly_by pelican2/p0)
	(set g_e1_talk 3)	; tyson: deprecated, does nothing
	(set g_e1_pelican2_entering true)
	(cs_fly_by pelican2/p1)
;	(cs_fly_to pelican2/p1)

;SPAWN REINFORCEMENTS AS REQUIRED AND TELEPORT THEM NEAR THE DROPSHIPS

;*	(if
		(<= (ai_living_count e1_flood_group_1) 3)
		(begin
			(sleep 150)
			(if
				(or
					(difficulty_normal)
					(difficulty_heroic)
				)
				(begin_random
					(begin
						(if
							(<= (ai_living_count e1_flood_group_1) 3)
							(ai_place e1_fld_inf4/guy1)
						)
						(sleep 30)
						;(ai_vehicle_enter_immediate e1_fld_inf4/guy1 (ai_vehicle_get ai_current_actor) "pelican_p_l05")
						;(vehicle_load_magic (ai_vehicle_get_from_starting_location e1_CS_pelican2/pilot) "pelican_p_l05" (ai_get_unit e1_fld_inf4/guy1))
						
					)
					(begin
						(if
							(<= (ai_living_count e1_flood_group_1) 3)
							(ai_place e1_fld_inf4/guy2)
						)
						(sleep 30)
						;(ai_vehicle_enter_immediate e1_fld_inf4/guy2 (ai_vehicle_get ai_current_actor) "pelican_p_r05")
						;(vehicle_load_magic (ai_vehicle_get_from_starting_location e1_CS_pelican2/pilot) "pelican_p_r05" (ai_get_unit e1_fld_inf4/guy2))
					)
			
						(begin
						(if
							(<= (ai_living_count e1_flood_group_1) 3)
							(ai_place e1_fld_inf4/guy3)
						)
						(sleep 30)
						;(ai_vehicle_enter_immediate e1_fld_inf4/guy3 (ai_vehicle_get ai_current_actor) "pelican_p_l04")
						;(vehicle_load_magic (ai_vehicle_get_from_starting_location e1_CS_pelican2/pilot) "pelican_p_l04" (ai_get_unit e1_fld_inf4/guy3))
					)
			
					(begin
						(if
							(<= (ai_living_count e1_flood_group_1) 3)
							(ai_place e1_fld_inf4/guy4)
						)
						(sleep 30)
						;(ai_vehicle_enter_immediate e1_fld_inf4/guy4 (ai_vehicle_get ai_current_actor) "pelican_p_r04")
						;(vehicle_load_magic (ai_vehicle_get_from_starting_location e1_CS_pelican2/pilot) "pelican_p_r04" (ai_get_unit e1_fld_inf4/guy4))
			
					)
					
					(begin
						(if
							(<= (ai_living_count e1_flood_group_1) 3)
							(ai_place e1_fld_inf4/guy5)
						)
						(sleep 30)
						;(ai_vehicle_enter_immediate e1_fld_inf4/guy5 (ai_vehicle_get ai_current_actor) "pelican_p_l03")
						;(vehicle_load_magic (ai_vehicle_get_from_starting_location e1_CS_pelican2/pilot) "pelican_p_l03" (ai_get_unit e1_fld_inf4/guy5))
					)
			
					(begin
						(if
							(<= (ai_living_count e1_flood_group_1) 3)
							(ai_place e1_fld_inf4/guy6)
						)
						(sleep 30)
						;(ai_vehicle_enter_immediate e1_fld_inf4/guy6 (ai_vehicle_get ai_current_actor) "pelican_p_r03")
						;(vehicle_load_magic (ai_vehicle_get_from_starting_location e1_CS_pelican2/pilot) "pelican_p_r03" (ai_get_unit e1_fld_inf4/guy6))
					)
				) ;end random
				(ai_place e1_fld_inf4_z)
			) ;end if
		;(sleep 150)
		)
	)
*;
	
	;Troop Drop
	;(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p")

	;Pelican 2 bug out
	(cs_fly_by pelican2/p2)
	(cs_fly_by pelican2/p3)
	
	(ai_erase e1_CS_pelican2)
)	

(script dormant e1_carrier_drop
	(object_set_velocity (ai_get_object e1_fld_inf3/carrier0) -5 0 0)
	(object_set_velocity (ai_get_object e1_fld_inf3/carrier1) -4 0 0)
	(sleep 30)
	(unit_set_current_vitality (ai_get_unit e1_fld_inf3/carrier0) .1 0)
	(unit_set_current_vitality (ai_get_unit e1_fld_inf3/carrier1) .1 0)
)

(global boolean g_e1_pelican1_entering false)
(global boolean g_e1_pelican1_unloaded false)
(script command_script e1_cs_pelican1
	; tyson: wasting my time being an idiot
	(ai_place e1_fld_inf3/carrier0)
	(ai_place e1_fld_inf3/carrier1)
	(sleep 1)
	(objects_attach (ai_vehicle_get ai_current_actor) "chief_rear" (ai_get_object e1_fld_inf3/carrier0) "")
	(objects_attach (ai_vehicle_get ai_current_actor) "pelican_e" (ai_get_object e1_fld_inf3/carrier1) "")

	;Pelican 1 flies in
	(cs_fly_by pelican1/p0)
	(set g_e1_talk 1)	; tyson: deprecated, does nothing
	(set g_e1_pelican1_entering true)
	
;	(cs_fly_to pelican1/p3)
	(cs_fly_by pelican1/p3)
	(objects_detach (ai_vehicle_get ai_current_actor) (ai_get_object e1_fld_inf3/carrier0))
	(objects_detach (ai_vehicle_get ai_current_actor) (ai_get_object e1_fld_inf3/carrier1))
	(sleep 1)
	(wake e1_carrier_drop)

	;Spawn reinforcements as required
	;(ai_place_in_vehicle e1_fld_inf3 e1_CS_pelican1)

	;Troop Drop!
;	(sleep 30)

;	(ai_place e1_fld_inf3/guy1)
;	(sleep 60)
;	(ai_place e1_fld_inf3/guy2)
;	(sleep 60)
;	(ai_place e1_fld_inf3/guy3)
;	(sleep 60)
;	(ai_place e1_fld_inf3/guy4)
	
		
	;(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p")
	(set g_e1_talk 2)	; tyson: deprecated, does nothing
	(set g_e1_pelican1_unloaded true)
	;(sleep 150)

	;Fly away
	(cs_fly_by pelican1/p4)
	(cs_fly_by pelican1/p5)
	(ai_erase e1_CS_pelican1)
)


(script dormant e1_infinite_save
	(game_save_no_timeout)
)

(global boolean g_e1_pro_inf3_spawned false)
(script dormant e1_pro_inf3_place
	(sleep_until (volume_test_objects tv_e1_trigger4 (players)) 15)
	(data_mine_set_mission_segment turbolift_base)
	(wake e1_infinite_save)
	(ai_place e1_pro_inf3)
	(sleep_until (= g_dialogue_counter 1))
	(set g_e1_talk 4)	; tyson: deprecated, does nothing
	(set g_e1_pro_inf3_spawned true)
	(sleep 150)
	(set g_e1_talk 5)	; tyson: deprecated, does nothing
	(sleep 150)
	(set g_e1_talk 6)	; tyson: deprecated, does nothing
	(set g_dialogue_counter 2)	; tyson: deprecated, does nothing
	(if
		(or
			(difficulty_normal)
			(difficulty_heroic)
		)
		(begin
			(sleep 450)
			(if
				(or
					(volume_test_objects_all tv_e1_trigger2 (players))
					(volume_test_objects_all tv_e1_trigger4 (players))
				)
				(ai_place e1_fld_inf5 (pin (- 8 (ai_living_count e1_flood_master)) 0 5))
			)
		)
		(begin
			(sleep 150)
			(if
				(or
					(volume_test_objects_all tv_e1_trigger2 (players))
					(volume_test_objects_all tv_e1_trigger4 (players))
				)
				(ai_place e1_fld_inf5 (pin (- 8 (ai_living_count e1_flood_master)) 0 5))
			)
			(sleep 150)
			(if
				(or
					(volume_test_objects_all tv_e1_trigger2 (players))
					(volume_test_objects_all tv_e1_trigger4 (players))
				)
				(ai_place e1_fld_inf5 (pin (- 8 (ai_living_count e1_flood_master)) 0 5))
			)
		)			
	)
)


(script command_script run_grunt_run
	(cs_movement_mode ai_movement_flee)
	(cs_go_to_nearest gitem1)
)

(script dormant e1_exterior_checkpoint
	(sleep_until 
		(or
			(volume_test_objects tv_e1_trigger4 (players))
			(and
				(<= (ai_nonswarm_count e1_fld_inf1) 0)
				(<= (ai_nonswarm_count e1_fld_inf2) 0)
				(<= (ai_nonswarm_count e1_pro_inf1) 0)
				(<= (ai_nonswarm_count e1_pro_inf2) 0)
			)
		)
		15
	)
	(game_save_no_timeout)
)

(script dormant e1_pro_inf2_place
	(sleep_until (volume_test_objects tv_e1_trigger2 (players)) 15)
	;(ai_playfight e1_pro_inf1 false)
	;(ai_playfight e1_fld_inf1 false)
	(ai_place e1_pro_inf2 2)
	(ai_place e1_fld_inf2 1)
	(if
		(difficulty_legendary)
		(begin_random
			(begin
				(if
					(<= (ai_living_count e1_flood_master) 5)
					(ai_place e1_fld_inf1/guy2)
				)
			)
			(begin
				(if
					(<= (ai_living_count e1_flood_master) 5)
					(ai_place e1_fld_inf1/guy3)
				)
	
			)
			(begin
				(if
					(<= (ai_living_count e1_flood_master) 5)
					(ai_place e1_fld_inf1/guy4)
				)
	
			)
			(begin
				(if
					(<= (ai_living_count e1_flood_master) 5)
					(ai_place e1_fld_inf1/guy5)
				)
			)
		)
	)
	
	(wake e1_exterior_checkpoint)
	(wake e1_pro_inf3_place)
; tyson	(wake e2_cortana_intro)
)


(global boolean g_e1_git_check 0)


(script dormant e1_gitem_2
	(sleep_until (volume_test_objects tv_e1_gitem2 (players)) 15)
	;place a nice personal Flood squad
	(set g_e1_git_check true)
	(begin_random
		(begin
			(ai_place e1_fld_gitem2/guy1)
			(sleep 90)
		)
		(begin
			(ai_place e1_fld_gitem2/guy2)
			(sleep 90)			
		)
	)
)


(script dormant e1_gitem_1
	(sleep_until (volume_test_objects tv_e1_gitem1 (players)) 15)
	;place a nice personal Flood squad
	(if
		(not
			g_e1_git_check
		)
		(begin
			(begin_random
				(begin
					(ai_place e1_fld_gitem1/guy1)
					(sleep 90)
				)
				(begin
					(ai_place e1_fld_gitem1/guy2)
					(sleep 90)
				)
			)
		)
	)
	(sleep_forever e1_gitem_2)
)


(script dormant e1_talking_points
;	(sleep_until (= g_e1_talk 1) 15 450) ; tyson: set by first pelican command script
	(sleep_until g_e1_pelican1_entering 15 450)
	(if
		dialogue
		(print "CORTANA: Flood-controlled dropships are touching down all over the city!")
	)
	(sleep (ai_play_line_on_object none 2680))
	(wake music_07b_01_start)
;	(sleep_until (= g_e1_talk 2) 15 600)	; tyson: set when first pelican unloads
;	(sleep_until g_e1_pelican1_unloaded 15 450)
	(sleep 25)
	(if
		dialogue
		(print "CORTANA: That creature beneath the Library; that Gravemind, used us! We were just a diversion. In Amber Clad was always it's intended vector!")
	)
	(sleep (ai_play_line_on_object none 2690))
	(game_save)
;	(sleep_until (= g_e1_talk 3) 15 600)	; tyson: unsafe, set when second pelican enters
	(sleep_until 
		(or
			g_e1_pelican2_entering
			(volume_test_objects tv_e1_trigger4 (players))
		)
		15 
		450
	)
	(sleep 25)
	(if dialogue
		(print "CORTANA: There's a conduit connecting this tower to the ship. Head back inside. I'll lead you to it.")
	)
	(sleep (ai_play_line_on_object none 2710))
	(game_save)
	(wake objective_enter_set)
	(wake music_07b_01_stop)
	(wake music_07b_02_start)	; tyson: music trigger moved here, unconditional
	(set g_dialogue_counter 1)
;*	; tyson: this music trigger wasn't specced as being conditional on player location
	(if
		(volume_test_objects_all tv_e1_ledge_check (players))
		(wake music_07b_02_start)
	)
*;

;	(sleep_until (= g_e1_talk 4))	; tyson: set when flood inf3 spawn
	(sleep_until g_e1_pro_inf3_spawned 15)
;*	(sleep_until 
		(and
			(= g_e1_talk 6)	; tyson: unsafe, trigger, set later when flood inf3 spawn
			(volume_test_objects tv_e1_trigger2 (players))
		)
	)
*;
	; tyson: The above was essentially controlled by a timer. This is more explicit
	(sleep 150)
	(sleep_until (volume_test_objects tv_e1_trigger2 (players)) 15)

	; tyson: we resume your regularly scheduled broadcast
	(if
		dialogue 
		(print "CORTANA: We don't have time for this Chief. Truth's Phantom is nearning the Forerunner ship!")
	)
	(sleep (ai_play_line_on_object none 2700))
	(if
		(volume_test_objects_all tv_e1_ledge_check (players))
		(wake music_07b_02_start)
	)
)

(script dormant e1_flashlight_training
	(sleep_until (volume_test_objects tv_e1_trigger5 (players)) 15)
	(sleep_until (game_safe_to_save))
	(player_training_activate_flashlight)
)

; tyson: set up mercy
(script dormant e1_mercy
	(object_create_anew ledge_99)
	(sleep 10)
	(scenery_animation_start_loop ledge_99 "objects\characters\prophet\prophet" "mercy_dead")
)

(script dormant e1_main
	(game_save)
	(data_mine_set_mission_segment phantom_ledge)
	(object_create_containing "ledge")
	(wake e1_pro_inf2_place)
	(wake e1_talking_points)
	(wake e1_gitem_1)
	(wake e1_gitem_2)
	(wake e1_flashlight_training)
	(wake e1_mercy)
	
	; tyson: robust trigger for e5_main
	(wake e5_main)
	(wake e2_cortana_intro)

	;Starts the encounter, places the squads at the end of the cinematice sequence.
	(ai_place e1_pro_inf1)
	(sleep 6)
	(units_set_current_vitality (ai_actors e1_pro_inf1) 100 0)
	(ai_place e1_fld_inf1 4)

	;(ai_playfight e1_pro_inf1 true)
	;(ai_playfight e1_fld_inf1 true)
	
	;Place Pelican 1
	(ai_place e1_CS_pelican1/pilot)
	(sleep 6)
	(cs_run_command_script e1_cs_pelican1/pilot e1_cs_pelican1)
	(sleep 180)
	(ai_place e1_CS_pelican2/pilot)
	(sleep 6)
	(cs_run_command_script e1_cs_pelican2/pilot e1_cs_pelican2)
)


;====================================================================================
;= ENCOUNTER 1 - FLOOD PELICANS DROP WAVES OF ATTACKERS ON THE PHANTOM LEDGE ========
;====================================================================================


(global boolean g_play_cinematics 1)


(script dormant mission_start
	(switch_bsp 0)
	; Run the cinematics
	(cinematic_snap_to_white)

	;(switch_bsp 0)
	(if (= g_play_cinematics 1)
		(begin
			(if (cinematic_skip_start)
              	(begin
              		; tyson: remove the Pelican for Joe's cinematic
              		(object_destroy ledge_1)
              		(object_destroy ledge_97)
              		(object_destroy ledge_98)
              		(object_destroy ledge_99)
              		
              		; Run cinematic
              		(print "c07_intra1")
              	 	(c07_intra1)                               
       			)
      		)
           (cinematic_skip_stop)
       	)
	)
	
	; For Mat and Co.
	(sound_suppress_ambience_update_on_revert)
	(sound_class_set_gain amb 0 0)
	(sleep 1)
	(sound_class_set_gain amb 1 15)	

	(sleep 2)

	(object_teleport (player0) player0_start)
	(object_teleport (player1) player1_start)

	; Wake the first encounter
	(wake e1_main)
	(sleep 10)	; tyson: To give Mercy some time to die
	
	; Fade in from white

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(cinematic_fade_from_white_bars)
	(wake chapter_purposes)

	; Wait for the mission to end
	(sleep_until
;		(and                                   pbertone 
;			g_e12_final_battle_ended
			(volume_test_objects tv_e12_end (players))
			;(= g_e12_go true)
;		)
		16
	)
	;(set g_mission_over true)

	; Fade to white and win
	(object_cannot_take_damage (players))
	(cinematic_fade_to_white)
	(ai_erase_all)

	; Stash the player
	(object_teleport (player0) player0_end)
	(object_teleport (player1) player1_end)
	(object_hide (player0) true)
	(object_hide (player1) true)

	; Sleep
	(sleep 15)
	(wake objective_exit_clear)
	
	; tyson
	(if (= g_play_cinematics 1)
		(begin
			(if (cinematic_skip_start)
              	(begin
              		(print "c07_outro")
              	 	(c07_outro)                               
       			)
      		)
           (cinematic_skip_stop)
       	)
	)
	; /tyson
	
	(game_won)
)


(script static void start
	(wake mission_start)
)


(script startup mission_main
	;(if (game_is_playtest) (begin (c07_intra1) (game_won)))

	; Necessary startup stuff
	(ai_allegiance player human)
	(ai_allegiance covenant prophet)
	(game_can_use_flashlights 1)

	; Begin the mission
	; Comment this out when you're testing individual encounters
	(if (> (player_count) 0 ) (start))
)

(script command_script cinematic_fld_inf0_0
	(cs_movement_mode ai_movement_combat)
	(cs_enable_pathfinding_failsafe true)
	(sleep 1)
	(object_set_velocity (ai_get_object ai_current_actor) 4 0 1.5)
	(cs_go_to cinematic_fld_inf0/p0)
	(ai_erase ai_current_actor)
)

(script command_script cinematic_fld_inf0_1
	(cs_movement_mode ai_movement_combat)
	(cs_enable_pathfinding_failsafe true)
	(sleep 1)
	(object_set_velocity (ai_get_object ai_current_actor) 4 0 1)
	(cs_go_to cinematic_fld_inf0/p1)
	(ai_erase ai_current_actor)
)

(script command_script cinematic_fld_inf1_0
	(cs_movement_mode ai_movement_combat)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to cinematic_fld_inf0/p2)
	(ai_erase ai_current_actor)
)

(script static void cinematic_pelican_unload
	(ai_place cinematic_fld_inf0/form0)
	(sleep 8)
	(ai_place cinematic_fld_inf0/form1)
	(sleep 4)
	(ai_place cinematic_fld_inf0/form0)
	(sleep 10)
	(ai_place cinematic_fld_inf0/form1)
)

(script static void cinematic_pelican_runby
	(ai_place cinematic_fld_inf1/form0)
)


;=========================================================================================
;= MISSION MAIN ==========================================================================
;=========================================================================================


;(script command_script cs_e5_cov_inf0_elite
;	(cs_abort_on_damage true)
;	(cs_crouch true)
;	(sleep_until 
;		(begin
;			(begin_random
;				(begin
;					(cs_aim true e5_cov_ambush/look0)
;					(sleep (random_range 100 150))
;				)
;				(begin
;					(cs_aim true e5_cov_ambush/look1)
;					(sleep (random_range 45 90))
;				)
;				(begin
;					(cs_aim true e5_cov_ambush/look2)
;					(sleep (random_range 45 90))
;				)
;			)
		
			; Sleep forever
;			false
;		)
;		5
;	)
;)


;*(script dormant e10_stuck_door
	(sleep_until
		(begin
			;(sleep 90)
			(if
				(volume_test_objects tv_e10_door_jam (players))
				(begin
					(device_operates_automatically_set e10_stuck_door true)
					(sleep_until
						(not
							(volume_test_objects tv_e10_door_jam (players))
						)
					)
					(device_operates_automatically_set e10_stuck_door false)
				)
			)
		(device_set_position e10_stuck_door 1)
			(sleep_until (>= (device_get_position e10_stuck_door) 1) 3)
;			(device_set_position e10_stuck_door .65)
			(sleep_until (<= (device_get_position e10_stuck_door) .3) 1)
			;(sleep 90)
			(if
				(not
					(and
						(volume_test_object tv_e10_door_jam e10_dead_body)
						(volume_test_objects tv_e10_door_jam (players))
					)
				)
				(device_operates_automatically_set e10_stuck_door true)
			)
			(not (volume_test_object tv_e10_door_jam e10_dead_body))
		)
		1
	)
)
*;



;= OLD SHIZZ ==============================================================================================



;(script command_script e10_cs_floorit1
;	(cs_vehicle_boost true)
;	(sleep 120)
;)


;(script dormant e10_ender
;	(sleep_until
;		(not
;			(volume_test_objects tv_e10_hall_check (ai_actors all_enemies))
;		)
;	15
;	)
;	(set g_e10_move_on 1)
;)


;===========================================================================================================
;============= STARTUP SCRIPT ==============================================================================
;===========================================================================================================
;(script static void run_me
;	(print "eat it")
;)

;(script dormant phantom_ledge
;	(sleep_until (volume_test_objects tv_phantom_ledge (players)))
;	(print "placing phantom ledge flood")
;	(ai_place phantom_ledge_flood)
;)


;(script dormant forerunnership	
;	(cinematic_snap_to_black)

;	(physics_set_gravity 1.6)

;	(fade_out 0 0 0 0)
;	(camera_control on)
	
;	(set play_cinematics 0)
	
;	(if (= play_cinematics 1)
;		(begin
	
;			(if (cinematic_skip_start)
;				(begin
;					(print "x06")
;					(x06)
;				)
;			)
;			(cinematic_skip_stop)

;			(sleep 30)
	
;			(if (cinematic_skip_start)
;				(begin
;					(print "intro")
;					(C06_intro)
;				)
;			)
;			(cinematic_skip_stop)
;		)
;	)
;	(sleep 1)
;	(switch_bsp 0)

;	(sleep 30)

;	(cinematic_fade_from_black)
;	(sleep 30)
	
;	(wake phantom_ledge)
;	(camera_control 0)
;	(cinematic_stop)
;	(fade_in 0 0 0 30)

	
; 	(sleep_until (volume_test_objects tv_hall_a (players)) 10)
;	(wake enc_hall_a)
	
;	(sleep_until (volume_test_objects tv_conduit_a (players)) 10)
;	(wake enc_conduit_a)
	
;	(sleep_until (volume_test_objects tv_hall_b (players)) 10)
;	(wake enc_hall_b)
	
;	(sleep_until (volume_test_objects tv_plug_launch (players)) 10)
;	(wake enc_plug_launch)
	
;	(sleep_until (volume_test_objects tv_plug_land (players)) 10)
;	(wake enc_plug_landing)
	
;	(sleep_until (volume_test_objects tv_hall_c (players)) 10)
;	(wake enc_hall_c)

;	(sleep_until (volume_test_objects tv_ledge_a (players)) 10)
;	(wake enc_ledge_a)

;	(sleep_until (volume_test_objects tv_conduit_b (players)) 10)
;	(wake enc_conduit_b)

;	(sleep_until (volume_test_objects tv_ledge_b (players)) 10)
;	(wake enc_ledge_b)

;	(sleep_until (volume_test_objects tv_ledge_c (players)) 10)
;	(wake enc_ledge_c)

;	(sleep_until (volume_test_objects tv_qz_initial (players)) 10)
;	(wake enc_qz_initial)

;	(sleep_until (volume_test_objects tv_cov_defense (players)) 10)
;	(wake enc_cov_defense)


;- Globals ---------------------------------------------------------------------
;- Command Scripts -------------------------------------------------------------
;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

;(script dormant example3
;	(sleep_until 
;		(or
;			(<= (ai_strength tomb_overlook_elite2) .4)
;			(<= (ai_strength tomb_overlook_brutes) .4)
;		)
;	)
;	(print "Here come the Flood again. Falling on your head like a memory.")
;	(sleep 300)
;	(ai_place tomb_overlook_infection1)
;	(wake example4)
;)

;- Squad Controls --------------------------------------------------------------
;- Init and Cleanup ------------------------------------------------------------



;(global boolean g_talk 0)

;(script dormant cortana_tomb4
;	(sleep_until (volume_test_objects tv_endroom (players)) 15)
;	(print "They've locked the doors!")
;)

;(script dormant cortana_tomb3
;	(sleep_until 
;		(and
;			(<= (ai_living_count tomb_overlook_flood2) 0)
;			(<= (ai_living_count tomb_overlook_flood3) 0)
;			g_talk
;		)
;		15
;	)
;	(sleep_forever cortana_tomb4)
;	(sleep_until (volume_test_objects tv_endroom (players)) 15)
;	(sleep 30)
;	(print "I'll get those doors open now.")
;)

;(script static void cortana_tomb2
;	(print "zealots are inbound")
;)

;(script dormant cortana_tomb1
;	(sleep_until (volume_test_objects cortana_trig1 (players)) 10)
;	(print "A civil war, and we're stuck in the middle")
;)

;(script dormant example5
;	(sleep_until (<= (ai_strength tomb_overlook_flood2) .5) 300)
;	(ai_place tomb_overlook_flood3)
;	(sleep 30)
;	;(set g_talk 1)
;)

;(script dormant example4
;	(sleep 300)
;	(ai_place tomb_overlook_flood2)
;	(print "We've got to kill these infection forms before they spread further!")
;		(wake example5)
;	(if
;		(<= (ai_swarm_count tomb_overlook_infection1) 10)
;		(ai_place tomb_overlook_infection2)
;	)
;)

;(script dormant example3
;	(sleep_until 
;		(or
;			(<= (ai_strength tomb_overlook_elite2) .4)
;			(<= (ai_strength tomb_overlook_brutes) .4)
;		)
;	)
;	(print "Here come the Flood again. Falling on your head like a memory.")
;	(sleep 300)
;	(ai_place tomb_overlook_infection1)
;	(wake example4)
;)

;(script dormant example2
;	(sleep_until (volume_test_objects tv_midroom (players)) 15)
;	(ai_place tomb_overlook_elite2)
;	(wake example3)
;)

;(script dormant example
;	(sleep_until (volume_test_objects tv_startme (players)) 15)
;	(ai_place tomb_overlook_elite)
;	(ai_place tomb_overlook_brutes)
;	(wake example2)
;	(wake cortana_tomb1)
;	(wake cortana_tomb3)
;	(wake cortana_tomb4)
;)

;= ENCOUNTER 1 ==========================================================================
;*
The initial encounter that kicks off after the opening cinematic. The Flood are launching multiple infection vectors
into the main towers of the city of High Charity.

The encounter begins after the movie ends, and terminates after the player escapes from the Phantom Ledge
via the turbolift inside the tower.

Flood Forces
	e1_fld_inf1 - placed by cinematic
		(e1_fld_inf1_hold) - Hold position in the Pelican wreckage
		(e1_fld_inf1_attack) - Clear the Phantom Ledge
		(e1_fld_inf1_enter) - Enter the tower rooms

	e1_fld_inf2 - dropped by 1st Pelican flyby
		(e1_fld_inf2_attack) - Clear the Phantom Ledge

	e1_fld_inf3 - dropped by 2nd Pelican
		(e1_fld_inf3_attack) - Clear the Phantom Ledge
		(e1_fld_inf3_enter) - Enter the tower rooms

	e1_fld_inf4 - Flood reinforcements (as required by circumstance)
		(e1_fld_inf4_enter) - Enter the tower rooms

	e1_fld_inf5 - Flood reinforcements (as required by circumstance)
		(e1_fld_inf5_enter) - Enter the tower rooms

	e1_fld_pelican1 - Flyover dropship that scatters Carrier forms 
	e1_fld_pelican2 - Dropship that delivers a Combat form squad 

Prophets Forces
	e1_pro_inf1 - Brute guards placed by cinematic
		(e1_pro_inf1_attack) - Attack the Flood positions in the Pelican wreckage
		(e1_pro_inf1_retreat) - Retreat to the interior of the tower
	
	e1_pro_inf2 - Guards inside the first hallway
		(e1_pro_inf2_attack) - Attack the Flood positions in the Pelican wreckage
		(e1_pro_inf2_retreat) - Retreat to the interior of the tower
	
	e1_pro_inf3 - Reinforcements from inside
		(e1_pro_inf3_attack) - Clear the Phantom Ledge
	
	e1_pro_inf4 - Last small squad that jumps out of the turbolifter
		(e1_pro_inf4_attack) - Clear the Phantom Ledge

	e1_pro_banshee1 - Fighter pursuit 1
	e1_pro_banshee2 - Fighter pursuit 2

	e10_mars_warthog0 - e9_mars_warthog0
		(engage0) - Engage e10_cov_inf0 until they are dead
		(engage1) - Engage e10_cov_inf1 until they are dead
		(continue) - Continue up the beach
	e10_mars_inf0 - Marines nearby, engaging the entrenched e9_cov_inf0
		(init) - Dug in and engaging
		(advance0) - Storming the e10_cov_inf0 position and flushing them out
		(advance2) - Storming the e10_cov_inf1 position and flushing them out

Open Issues
- As required
*;


;(script dormant dervish_ledge_lift
;	(sleep_until
;		(begin
;			(sleep_until (volume_test_objects tv_dervish_ledge_lift (players)) 5)
;			(player_enable_input false)
;			(bloom 1 1 1)
;			(sleep 15)
;			(device_set_position dervish_lift 1)
;			(sleep_until (>= (device_get_position dervish_lift) .9) 1)
;			(player_enable_input true)
;			(sleep 60)
;			(device_set_position_immediate dervish_lift 0)
;			(bloom 0 0 0)
;		false
;		)
;		1
;	)
;)

; ========= Room A Lift Scripts ==========================================================================

;(script static void room_a_lift_up
;	(player_enable_input false)
;	(device_set_position_immediate room_a_lift 0)
;	(sleep 1)
;	(device_set_position room_a_lift 1)
;	(sleep_until (>= (device_get_position room_a_lift) .9) 1)
;	(player_enable_input true)
;	(sleep 60)
;)


;(script static void room_a_lift_down
;	(player_enable_input false)
;	(device_set_position_immediate room_a_lift 1)
;	(sleep 1)
;	(device_set_position room_a_lift 0)
;	(sleep_until (<= (device_get_position room_a_lift) .1) 1)
;	(player_enable_input true)
;	(sleep 15)
;	(sleep_until (not (volume_test_objects tv_room_a_lift_bot (players))))
;	(device_set_position_immediate room_a_lift 1)
;)

 
;(script dormant room_a_lift
;	(sleep_until
;		(begin
;			(sleep_until
;				(or
;					(volume_test_objects tv_room_a_lift_top (players))
;					(volume_test_objects tv_room_a_lift_bot (players))
;                     )
;                 1
;                )
;                (sleep 30)
;			(cond
;				((volume_test_objects tv_room_a_lift_top (players)) (room_a_lift_down))
;				((volume_test_objects tv_room_a_lift_bot (players)) (room_a_lift_up))
;			)
;		false
;		)
;	1
;	)
;)


;(device_operates_automatically_set high_sanctum_door 1)


;======================================

;(script command_script e12_cs_floorit
;	(cs_vehicle_boost true)
;	(sleep 140)
;	(cs_vehicle_boost false)
;	(sleep 390)
;)

;(script dormant e12_interceptor_boost
;	(sleep_until (volume_test_objects tv_e12_trigger8 (players)) 15)
;	;(wake e13_load)
;)

;(script dormant e12_interceptors
;	(sleep_until (volume_test_objects tv_e12_trigger8 (players)) 15)
;	(ai_place e12_CS_banshee1)
	;(ai_place e12_CS_banshee2)
;	(ai_place e12_CS_banshee3)
	;(wake e13_load)
;)


;(vehicle_load_magic (ai_vehicle_get_from_starting_location e13_cov_creep0_1/creep0) "creep_sc01" (ai_vehicle_get_from_starting_location e13_cov_ghosts0/ghost1))


	;(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion e9_smasher1)
	;(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion e9_smasher2)
	;(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion e9_smasher3)
	;(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion e9_smasher4)
	;(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion e9_smasher5)
	;(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion e9_smasher6)
	;(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion e9_smasher7)
	;(wake e8_end_locked)
	;(wake e8_end_open)		

;(script dormant e6_end_locked
;	(sleep_until (volume_test_objects tv_e6_end (players)) 15)
;	(print "This door is still sealed!")
;)


;(script dormant e6_end_open
;	(sleep_until
;		(not
;			(volume_test_objects tv_e6_cave_check (ai_actors all_enemies))
;		)
;	15
;	)
;	(sleep_forever e6_end_locked)
;	(sleep_until (volume_test_objects tv_e6_end (players)) 15)
;	(sleep 60)
;	(print "I'll get this door open now.")
;	(device_operates_automatically_set e6_cave_door2 1)
;	(wake e7_start)
;)


;(script dormant e6_flood_final_rush
;	(sleep_until (volume_test_objects tv_e6_trigger9 (players)))
;	(ai_set_orders e6_flood_group_master e6_fld_master_rush)
;)

;= ENCOUNTER 5 - PLASMA CHANDELIER ROOM =================================================
;(script static void e5_safe_to_spawn_buggers_2
;	(sleep_until
;		(and
;			(volume_test_objects tv_e5_plat_c (players))
;			(<= (ai_living_count e5_buggers) 3)
;		)
;	)
;)

;(script dormant e5_bugger_reinf_2
	;Place more buggers as required
;	(sleep_until
;		(begin
;			(ai_place e5_pro_bug2_c/guy1)
;			(begin_random
;				(begin
;					(ai_place e5_pro_bug2_c/guy1)
;					(sleep 30)
;					(e5_safe_to_spawn_buggers_2)
;				)
;				(begin
;					(ai_place e5_pro_bug2_c/guy2)
;					(sleep 30)
;					(e5_safe_to_spawn_buggers_2)
;				)
;				(begin
;					(ai_place e5_pro_bug2_c/guy3)
;					(sleep 30)
;					(e5_safe_to_spawn_buggers_2)
;				)
;				(begin
;					(ai_place e5_pro_bug2_c/guy4)
;					(sleep 30)
;					(e5_safe_to_spawn_buggers_2)
;				)
;			)		
			;Keep spawing until the total number of Buggers equals 9
;			(>= (ai_spawn_count e5_buggers) 10)
;		)
;	)
;	(game_save)
;)


;(script static void e5_safe_to_spawn_buggers_1
;	(sleep_until
;		(and
;			(volume_test_objects tv_e5_plat_b (players))
;			(<= (ai_living_count e5_buggers) 3)
;		)
;	)
;)


;(script dormant e5_bugger_reinf_1
	;Place more buggers as required
;	(sleep_until
;		(begin
;			(ai_place e5_pro_bug2_b/guy1)
;			(begin_random
;				(begin
;					(ai_place e5_pro_bug2_b/guy1)
;					(sleep 30)
;					(e5_safe_to_spawn_buggers_1)
;				)
;				(begin
;					(ai_place e5_pro_bug2_b/guy2)
;					(sleep 30)
;					(e5_safe_to_spawn_buggers_1)
;				)
;				(begin
;					(ai_place e5_pro_bug2_b/guy3)
;					(sleep 30)
;					(e5_safe_to_spawn_buggers_1)
;				)
;				(begin
;					(ai_place e5_pro_bug2_b/guy4)
;					(sleep 30)
;					(e5_safe_to_spawn_buggers_1)
;				)
;			)		
			;Keep spawing until the total number of Buggers equals 9
;			(>= (ai_spawn_count e5_buggers) 9)
;		)
;	)
;)

;(script dormant e14_station_one
;	(game_save)
;	(ai_set_orders e14_pro_shadow1 e14_station_one)
;	(vehicle_unload (ai_vehicle_get_from_starting_location e14_pro_shadow1/shadow1) "creep_p_l01")
;	(vehicle_unload (ai_vehicle_get_from_starting_location e14_pro_shadow1/shadow1) "creep_p_l02")
;	(vehicle_unload (ai_vehicle_get_from_starting_location e14_pro_shadow1/shadow1) "creep_p_l03")
;	(vehicle_unload (ai_vehicle_get_from_starting_location e14_pro_shadow1/shadow1) "creep_p_l04")
;	(vehicle_unload (ai_vehicle_get_from_starting_location e14_pro_shadow1/shadow1) "creep_p_l05")
	;(vehicle_unload (ai_vehicle_get_from_starting_location e14_pro_shadow2/shadow2) "creep_sc01")
;)


;(script dormant e14_station_one_complete
;	(game_save)
;	(ai_enter_squad_vehicles e14_pro_shadow1)
;	(ai_enter_squad_vehicles e14_pro_shadow1)
;	(vehicle_load (ai_vehicle_get_from_starting_location e14_pro_shadow1/shadow1) "creep_p_l01")
;	(vehicle_load (ai_vehicle_get_from_starting_location e14_pro_shadow1/shadow1) "creep_p_r01")
;	(vehicle_load (ai_vehicle_get_from_starting_location e14_pro_shadow1/shadow1) "creep_p_l02")
;	(vehicle_load (ai_vehicle_get_from_starting_location e14_pro_shadow1/shadow1) "creep_p_r02")
;	(vehicle_load (ai_vehicle_get_from_starting_location e14_pro_shadow1/shadow1) "creep_p_l03")
	;(vehicle_unload (ai_vehicle_get_from_starting_location e14_pro_shadow2/shadow2) "creep_sc01")
;)


;(script dormant e14_start
;	(sleep_until (volume_test_objects tv_e14_trigger1 (players)) 15)
;	(game_save)
;	(ai_place e14_pro_shadow1)
;	(ai_place e14_pro_shadow2)
;	(ai_place e14_pro_ghost1)
;	(sleep 2)
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location e14_pro_shadow2/shadow2) "creep_sc01" (ai_vehicle_get_from_starting_location e14_pro_ghost1/ghost1))
	;(sleep 150)
	;(vehicle_unload (ai_vehicle_get_from_starting_location e14_pro_shadow2/shadow2) "creep_sc01")
;)
	

;(script dormant e13_tank_rush
;	(sleep_until (volume_test_objects tv_e13_trigger6_manhunt (players)) 15)
;	(ai_place e13_pro_inf3)
;	(ai_place e13_fld_inf2 5)
;	(ai_place e13_fld_inf2_a 1)
;	(wake e14_start)
;)


;(script dormant e13_manhunter
;	(sleep_until (volume_test_objects tv_e13_trigger6_manhunt (players)) 15)
;	(ai_renew e12_pro_inf2)
;	(ai_enter_squad_vehicles e12_pro_inf2)
;)


;(script dormant e13_start
;	(sleep_until (volume_test_objects tv_e13_trigger1 (players)) 15)
;	(ai_place e13_pro_inf2 2)
;	(ai_place e13_fld_inf1 2)
;	(wake e13_manhunter)
;	(wake e13_tank_rush)
;)


;(script static void e12_mount_up2
;	(sleep 10)
;	(ai_enter_squad_vehicles e12_pro_inf2)
;)


;(script dormant e12_chase_squad
;	(sleep_until (volume_test_objects tv_e12_trigger4 (players)) 15)
;	(ai_place e12_pro_inf2)
;	(wake e13_start)
;)


;(script static void e12_fld_inf4_go
;	(ai_set_orders e12_fld_inf4 e12_fld_inf4)
;)


;(script static void e12_mount_up1
;	(sleep 10)
;	(ai_enter_squad_vehicles e12_fld_inf4)
;)

;(script dormant e12_start
;	(sleep_until (volume_test_objects tv_e12_trigger1 (players)) 15)
;	(game_save)
;	(wake e12_chase_squad)
;	(ai_place e12_pro_inf1 2)
;	(ai_place e12_fld_inf4/ghost1)
;	(ai_place e12_fld_inf4/ghost2)
;	(ai_place e12_fld_inf4/ghost3)
;	(ai_place e12_fld_inf5 3)
;	(ai_place e12_fld_inf3)
;	(sleep 90)
;	(begin_random
;		(begin
;			(not
;				(volume_test_objects tv_e12_trigger2 (players))			
;			)
;			(ai_place e12_fld_inf2 4)
;			(sleep_until (<= (ai_strength e12_flood_rush) .4))
;		)
;		(begin
;			(not
;				(volume_test_objects tv_e12_trigger2 (players))			
;			)
;			(ai_place e12_fld_inf1 4)
;			(sleep_until (<= (ai_strength e12_flood_rush) .4))
;		)
;	)
;	(sleep_until
;		(or
;			 (<= (ai_strength e12_flood_rush) .6)
;			 (not 
;			 	(volume_test_objects_all tv_e12_trigger1 (players))
;			 )
;		)
;	)
;	(sound_impulse_start sound\characters\flood\flood_howls e12_howler1 1)
;	(begin_random
;		(begin
;			(not
;				(volume_test_objects tv_e12_trigger2 (players))
;			)
;			(ai_place e12_fld_inf4/guy1)
;			(print "ghost rider 1")
;			(sleep (random_range 30 150))
;		)
;		(begin
;			(not
;				(volume_test_objects tv_e12_trigger2 (players))
;			)
;			(ai_place e12_fld_inf4/guy2)
;			(print "ghost rider 2")
;			(sleep (random_range 30 150))
;		)
;		(begin
;			(not
;				(volume_test_objects tv_e12_trigger2 (players))
;			)
;			(ai_place e12_fld_inf4/guy3)
;			(print "ghost rider 3")
;			(sleep (random_range 30 150))
;		)
;	)
;)


;(script dormant e11_start
;	(sleep_until (volume_test_objects tv_e11_trigger1 (players)) 15)
;	(ai_place e11_pro_inf1 1)
;	(ai_place e11_fld_inf1 2)
;	(sleep 150)
;	(if (volume_test_objects_all tv_e11_trigger2 (players)) (ai_place e11_fld_inf1 3))
;)


;(script command_script swarm_chase
;	(cs_go_to e10_swarm_hunker/p0)
;	(cs_go_to e10_swarm_hunker/p1)
;)


;(script command_script run_grunt_run
;	(cs_movement_mode ai_movement_flee)
;)


;(script dormant e10_grunt_run
;	(sleep_until (volume_test_objects tv_e10_trigger7 (players)) 15)
;	(ai_place e10_pro_inf2)
;	(sleep 60)
;	(ai_place e10_fld_swarm2)
;)



;(script static void e9_safe_to_spawn_storm
;		(volume_test_objects tv_e9_hall_check (players))
;		(<= (ai_living_count e9_flood_master) 3)
;)


;(global boolean g_e8_move_on 0)


;(script dormant e8_end_locked
;	(sleep_until (volume_test_objects tv_e8_end (players)) 15)
;	(print "I'm still working on the door!")
;)


;(script dormant e8_end_open
;	(and
;		(= g_e8_move_on 1)
;		(volume_test_objects tv_e8_end (players))
;	)
;	(sleep_forever e8_end_locked)
;	(sleep 60)
;	(wake e9_start)
;	(game_save)
;	(device_operates_automatically_set e8_cave_door2 1)
;	(print "See? All you needed was patience.")
;)


;(script static void e8_safe_to_spawn_backup
;		(volume_test_objects tv_e8_cave_check (players))
;		(<= (ai_living_count e8_fld_inf1) 2)
;)



		
;	(set g_e6_move_on on)
;	(game_save)
;)

;(script dormant e6_unlock_the_door
;	(sleep_until (volume_test_objects tv_e6_trigger8 (players)))
;	(game_save)
;	(print "THIS ROOM IS SEALED")
;	(sleep 30)
;	(print "IT WILL TAKE ME SOME TIME TO OPEN THE DOOR")
;	(sleep 90)
;	(wake e6_flood_storm)

;	(sleep_until g_e6_move_on)

;	(ai_place e6_pro_inf3)
;	(ai_place e6_pro_inf3_a 4)
;	(print "THE DOOR IS OPEN")
;	(wake e6_flood_final_rush)
;	(wake e6_end_locked)
;	(wake e6_end_open)
;	(device_operates_automatically_set e6_cave_door1 1)
;)

;(global boolean g_e6_swarm_spawned2 0)
;(global boolean g_e6_swarm_spawned1 0)


;(script dormant e6_swarm_spawner2
;	(sleep_until 
;		(or
;			g_e6_swarm_spawned1
;			(volume_test_objects tv_e6_special_2 (players))
;		)
;	)
;	(sound_impulse_start sound\characters\flood\flood_howls e6_howler_spec2 1)
;	(if (not g_e6_swarm_spawned1)
;		(begin
;			(ai_place e6_fld_swarm2)
;			(set g_e6_swarm_spawned2 1)
;		)
;	)
;)

;(script dormant e6_swarm_spawner1
;	(sleep_until 
;		(or
;			g_e6_swarm_spawned2
;			(volume_test_objects tv_e6_special_1 (players))
;		)
;	)
;	(sound_impulse_start sound\characters\flood\flood_howls e6_howler_spec1 1)
;	(if (not g_e6_swarm_spawned2)
;		(begin
;			(ai_place e6_fld_swarm1)
;			(set g_e6_swarm_spawned1 1)
;		)
;	)
;)


;(script dormant e9_storm
;	(begin_random
;		(begin
			;Spawn 3
;			(ai_place e9_fld_inf3_a)
;			(sleep (random_range 30 90))
;			(e9_safe_to_spawn_storm)
;		)
;		(begin
			;Spawn 3
;			(ai_place e9_fld_inf3_b)
;			(sleep (random_range 30 90))
;			(e9_safe_to_spawn_storm)
;		)
;		(begin
			;Spawn 3
;			(ai_place e9_fld_inf3_c)
;			(sleep (random_range 30 90))
;			(e9_safe_to_spawn_storm)
;		)
;		(begin
			;Spawn 2
;			(ai_place e9_fld_inf3_d)
;			(sleep (random_range 30 90))
;			(e9_safe_to_spawn_storm)
;		)
;		(begin
			;Spawn 2
;			(ai_place e9_fld_inf3_e)
;			(sleep (random_range 30 90))
;			(e9_safe_to_spawn_storm)
;		)
;		(begin
			;Spawn 2
;			(ai_place e9_fld_inf3_f)
;			(sleep (random_range 30 90))
;			(e9_safe_to_spawn_storm)
;		)
;	)
;	(game_save)
;)


;(script dormant e9_room2
	;(wake e9_room2)
;	(ai_place e9_fld_inf2 2)
;	(sleep_until
;		(or
;			(volume_test_objects tv_e9_trigger2 (players))
;			(<= (ai_living_count e9_fld_inf2) 1)
;		)
;	)
;	(wake e9_storm)
;	(sleep 30)
;	(sound_impulse_start sound\characters\flood\flood_howls e9_howler1 1)
;	(sleep (random_range 30 300))
;	(sound_impulse_start sound\characters\flood\flood_howls e9_howler2 1)
;	(sleep (random_range 30 150))
;	(sound_impulse_start sound\characters\flood\flood_howls e9_howler3 1)
;	(sound_impulse_start sound\characters\flood\flood_howls e9_howler4 1)
;	(wake e10_load)
;)


;(script dormant e9_surprise

;	(ai_place e9_fld_swarm1)
;)


;(script dormant e10_crazy_rush
;	(sleep_until (>= (ai_spawn_count e10_fld_inf1) 9))
;	(ai_set_orders e10_fld_inf1 e10_fld_inf1_fallback)
;	(game_save)
;	(sleep_until (volume_test_objects_all tv_e10_hide (ai_actors e10_fld_inf1)))

	;send in some crazy Flood on Ghosts

;	(begin_random
;		(begin
;			(if (<= (ai_spawn_count e10_cs_ghost1) 2) (ai_place e10_CS_ghost1/pilot1))
;			(sound_impulse_start sound\characters\flood\flood_howls e10_howler1 1)
;			(sleep (random_range 30 150))
;		)
;		(begin
;			(if (<= (ai_spawn_count e10_cs_ghost1) 2) (ai_place e10_CS_ghost1/pilot2))
;			(sound_impulse_start sound\characters\flood\flood_howls e10_howler2 1)
;			(sleep (random_range 30 150))
;		)
;		(begin
;			(if (<= (ai_spawn_count e10_cs_ghost1) 2) (ai_place e10_CS_ghost1/pilot3))
;			(sound_impulse_start sound\characters\flood\flood_howls e10_howler3 1)
;			(sleep (random_range 30 150))
;		)
;		(begin
;			(if (<= (ai_spawn_count e10_cs_ghost1) 2) (ai_place e10_CS_ghost1/pilot4))
;			(sound_impulse_start sound\characters\flood\flood_howls e10_howler4 1)
;			(sleep (random_range 30 150))
;		)
;	)
;	(ai_set_orders e10_fld_inf1 e10_fld_storm)
;	(wake e10_ender)
;)


	;(begin_random
	;	(begin
	;		(sound_impulse_start sound\characters\flood\flood_howls e10_howler1 1)
	;		(sleep (random_range 90 150))
	;	)
	;	(begin
	;		(sound_impulse_start sound\characters\flood\flood_howls e10_howler2 1)
	;		(sleep (random_range 90 150))
	;	)
	;	(begin
	;		(sound_impulse_start sound\characters\flood\flood_howls e10_howler3 1)
	;		(sleep (random_range 90 150))
	;	)
	;	(begin
	;		(sound_impulse_start sound\characters\flood\flood_howls e10_howler4 1)
	;		(sleep (random_range 90 150))
	;	)
	;)


;(script static void e10_safe_to_spawn_storm
;	(sleep (random_range 30 150))
;	(<= (ai_living_count e10_flood_master) 6)
; 	(e10_safe_to_spawn_storm)
;)


;= ENCOUNTER 4 ==========================================================================

; -- ALL PLACED VIA ENCOUNTER 3 TRIGGER VOLUME --
;TV TO PLACE THE GUYS
;WAKE THE NEXT TV

;= ENCOUNTER 3 ==========================================================================

;TV TO PLACE THE GUYS

;(script dormant e5_load
;	(wake e5_start)
;	(game_save)
;)

;(script dormant e3_pro_inf1_start
;	(wake e5_load)
;	(sleep_until (volume_test_objects tv_e3_trigger1 (players)) 15)
;	(ai_place e3_pro_inf1)
;	(ai_place e3_pro_inf1_a 2)
;	(sleep_until (volume_test_objects tv_e3_trigger2 (players)) 15 450)
;	(game_save)
;	(ai_place e3_pro_inf2)
;)

;(script dormant start_e3
;	(game_save)
;	(wake e3_pro_inf1_start)
;	(wake e5_load)
;)

;= ENCOUNTER 2 ==========================================================================

;(script command_script e2_cs_hall_patrol
;	(cs_abort_on_alert true)
;	(cs_enable_pathfinding_failsafe 1)
;	(cs_ignore_obstacles 1)
;	(cs_force_combat_status 3)
;	(cs_go_to hallpatrol/p0)
;	(cs_look true hallpatrol/p1)
;	(sleep 60)
;	(cs_aim true hallpatrol/p2)
;	(sleep 75)
;	(cs_aim false hallpatrol/p2)
;	(cs_go_to hallpatrol/p3)
;)

;(script dormant e2_pro_inf1_hall_patrol
;	(sleep_until (volume_test_objects tv_e2_trigger2 (players)) 15)
;	(ai_place e2_pro_inf1)
;	(cs_run_command_script e2_pro_inf1/guy2 e2_cs_hall_patrol)
;	(wake e3_pro_inf1_start)
;)

;(script dormant e2_save_trigger
;	(sleep_until (volume_test_objects tv_e2_save (players)) 15)
;	(game_save)
;)




;(script dormant e12_you_win
;	(sleep_until (volume_test_objects tv_e12_end (players)) 15)
;	(game_won)
;)	

