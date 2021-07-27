; A50 Cinematics Script v.2!

(script static void cutscene_rescue
	
; Joe, I've taken control of this stuff because I'm teleporting
; and moving marines around right before the cinematic triggers	
;	(fade_out 1 1 1 30)
;	(sleep 30) 
	
;	Paul, leave this bsp switch in. It doesn't do anything if the Player's already there. But it helps me a lot.	
	(switch_bsp 3)
	
	(sound_looping_start sound\sinomatixx_music\a50_rescue_music none 1)
	(sound_looping_start sound\sinomatixx_foley\a50_rescue_foley1 none 1)
	
	(sound_class_set_gain device_door 0 0)
	
	(cinematic_start)
	(camera_control on)
	
;	Commented this line out for building
;	(volume_teleport_players_not_inside null prison_player_teleport)

;	(object_destroy keyes)
;	(object_destroy chief)
;	(object_destroy chief_ar)

	(object_create_anew keyes)
	(object_create_anew chief)
	(object_create_anew chief_ar)
	
	(object_pvs_activate chief)
	(object_beautify chief true)
	(object_beautify keyes true)
	
	(unit_set_emotion keyes 1)
	
	(object_teleport keyes keyes_rescue_base)
	
	(objects_attach chief "right hand" chief_ar "")

;	(camera_set rescue_1a 0)
	(camera_set rescue_1b 0)
	
	(custom_animation keyes cinematics\animations\captain\level_specific\a50\a50 "a50_prison1" false)
	(custom_animation chief cinematics\animations\chief\level_specific\a50\a50 "a50helpkeyesup" false)

	(object_teleport chief chief_helpup_base)

	(fade_in 1 1 1 15)

	(sleep 15)
	
	(sound_impulse_start sound\dialog\a50\a50_prison_020_captkeyes keyes 1)
	(print "keyes: Coming here was reckless. You two know better than this. Thank you.")
	
	(sleep 45)
	(camera_set rescue_1c 0)
	(sleep 60)
	(camera_set rescue_1d 0)
	(camera_set rescue_1e 90)

	(sleep (sound_impulse_time sound\dialog\a50\a50_prison_020_captkeyes))
	
;	(object_destroy marine_speech_1)
;	(object_destroy marine_speech_2)
;	(object_destroy marine_speech_3)
;	(object_destroy marine1_plasma)
;	(object_destroy marine2_plasma)
;	(object_destroy marine3_plasma)
;	(object_destroy keyes_needler)
	
	(object_create_anew_containing marine_speech)
;	(object_create marine_speech_2)
;	(object_create marine_speech_3)
	(object_create_anew marine1_plasma)
	(object_create_anew marine2_plasma)
	(object_create_anew marine3_plasma)
	(object_create_anew keyes_needler)
	
	(object_beautify marine_speech_1 true)
	(object_beautify marine1_plasma true)
	(object_beautify keyes_needler true)
	
	(objects_attach marine_speech_1 "right hand" marine1_plasma "")
	(objects_attach marine_speech_2 "right hand" marine2_plasma "")
	(objects_attach marine_speech_3 "right hand" marine3_plasma "")
	
	(unit_stop_custom_animation keyes)
	
	(object_teleport keyes keyes_walk_base)
	(object_teleport chief chief_walk_base)
	
	(recording_play keyes keyes_walk_1)
	
	(camera_set keyes_walk_1a 0)
	(camera_set keyes_walk_1b 250)
	
	(sleep 60)
	
	(recording_play chief chief_walk_1)
	
	(sleep 30)

	(sound_impulse_start sound\dialog\a50\a50_prison_030_captkeyes keyes 1)
	(print "keyes: Marines!  Secure weapons and get ready to move A-sap!")
	
	(camera_set keyes_walk_1c 250)
	
	(sleep (sound_impulse_time sound\dialog\a50\a50_prison_030_captkeyes)) 
	
	(sound_impulse_start sound\dialog\a50\a50_prison_040_marines marine_speech_1 1)
	(sound_impulse_start sound\dialog\a50\a50_prison_040_marines marine_speech_2 1)
	(sound_impulse_start sound\dialog\a50\a50_prison_040_marines marine_speech_3 1)
	
	(object_teleport marine_speech_1 marine1_run_base)
	(object_teleport marine_speech_2 marine2_run_base)
	(object_teleport marine_speech_3 marine3_run_base)
	
	(recording_play marine_speech_1 marine1_run)
	(recording_play marine_speech_2 marine2_run)
	(recording_play marine_speech_3 marine3_run)
	
	(sleep 30)

	(sleep (- (recording_time keyes) 150))
	
	(custom_animation keyes cinematics\animations\captain\level_specific\a50\a50 "a50_prison2" false)
	
	(camera_set let_slip_1a 0)
	(camera_set let_slip_1b 300)
	
	(unit_set_emotion keyes 3)
	
	(sleep 20)
	
	(sound_impulse_start sound\dialog\a50\a50_prison_060_captkeyes keyes 1)
	(print "keyes: While the Covenant had us locked up in here the guards let slip some intel about this ring world. They call it Halo")
	
	(sleep 200)
	
	(recording_kill chief)
	(object_teleport chief chief_speech_base)
	(unit_set_seat chief alert)
	
	(sleep (- (sound_impulse_time sound\dialog\a50\a50_prison_060_captkeyes) 15))
	
	(object_teleport marine_speech_1 marine1_speech_base)
	(object_teleport marine_speech_2 marine2_speech_base)
	(object_teleport marine_speech_3 marine3_speech_base)
	
	(recording_play marine_speech_1 marine1_look_keyes)
	(recording_play marine_speech_2 marine2_look_keyes)
	(recording_play marine_speech_3 marine3_look_keyes)
	
;	(recording_play chief chief_listen_1)
	
	(camera_set one_moment_1a 0)
	(camera_set one_moment_1b 400)
	
	(sound_looping_start sound\sinomatixx_foley\a50_rescue_foley2 none 1)

	(sound_impulse_start sound\dialog\a50\a50_prison_070_cortana chief 1)
	(print "cortana: One moment, sir. Accessing the Covenant battle net. According to the data in their networks, the ring has some kind of deep religious significance.")
	
	(sleep 90)
	
	(custom_animation chief cinematics\animations\chief\level_specific\a50\a50 "idle_shoulder gun" true)
	
	(sleep 110)
	(camera_set one_moment_1c 400)
	
	(sleep (- (sound_impulse_time sound\dialog\a50\a50_prison_070_cortana) 30))

	(camera_set then_its_1a 0)
	(camera_set then_its_1b 90)

	(unit_custom_animation_at_frame keyes cinematics\animations\captain\level_specific\a50\a50 "a50_prison3" false 7)
	
	(sound_impulse_start sound\dialog\a50\a50_prison_080_captkeyes keyes 1)
	(print "keyes: Then it's true. The Covenant kept saying that 'whomever controls Halo controls the fate of the universe'")
	(sleep (sound_impulse_time sound\dialog\a50\a50_prison_080_captkeyes))
	
	(camera_set long_shot_1a 0)
	(camera_set long_shot_1b 600)
	
	(object_teleport keyes keyes_chief_look_base)
	(recording_play keyes keyes_look_at_chief)

	(sound_impulse_start sound\dialog\a50\a50_prison_090_cortana chief 1)
	(print "cortana: Now I see. I have intercepted a number of message about a Covenant search team, scouting for a 'control room'. I thought they were looking for the bridge of a cruiser that I damaged during the battle above the ring. But they  must be looking for HALO'S control room.")
	(sleep (- (sound_impulse_time sound\dialog\a50\a50_prison_090_cortana) 15))
	
	(object_teleport keyes keyes_speech_base)
	
	(unit_custom_animation_at_frame keyes cinematics\animations\captain\level_specific\a50\a50 "a50_prison4" false 11)
	
	(camera_set bad_news_1a 0)
	(camera_set bad_news_1b 300)
	
	(unit_set_emotion keyes 3)

	(unit_stop_custom_animation chief)
	
	(sound_impulse_start sound\dialog\a50\a50_prison_100_captkeyes keyes 1)
	(print "keyes: That's bad news. If Halo is a weapon, and the Covenant gain control of it, they'll use it against us and will wipe the human race out, once and for all.")
	(sleep (sound_impulse_time sound\dialog\a50\a50_prison_100_captkeyes))

	(camera_set mission_1d 0)
	(camera_set mission_1e 300)

	(custom_animation keyes cinematics\animations\captain\level_specific\a50\a50 "a50_prison5" true)
	(sleep 32)
	
	(sound_impulse_start sound\dialog\a50\a50_prison_110_captkeyes keyes 1)
	(print "keyes: Chief, Cortana. I have a new mission for you. We need to beat the Covenant to Halo's control room.")
	
	(sleep (sound_impulse_time sound\dialog\a50\a50_prison_110_captkeyes))
	
	(camera_set lets_move_1a 0)
	(camera_set lets_move_1b 200)

	(unit_custom_animation_at_frame keyes cinematics\animations\captain\level_specific\a50\a50 "a50_prison6" true 23)

	(sound_impulse_start sound\dialog\a50\a50_prison_120_captkeyes keyes 1)
	(print "keyes: We need to get out of here. Marines: let's move.")
	(sleep (sound_impulse_time sound\dialog\a50\a50_prison_120_captkeyes))

	(sound_impulse_start sound\dialog\a50\a50_prison_130_marine1 marine_speech_1 1)
	(sleep 5)
	(sound_impulse_start sound\dialog\a50\a50_prison_130_marine2 marine_speech_2 1)
	(sleep 5)
	(sound_impulse_start sound\dialog\a50\a50_prison_130_marine3 marine_speech_3 1)
	(sleep (sound_impulse_time sound\dialog\a50\a50_prison_130_marine3))

	(camera_set chief_point_1a 0)
	(camera_set chief_point_1b 60)
	
	(sound_looping_start sound\sinomatixx_foley\a50_rescue_foley3 none 1)
	
	(unit_stop_custom_animation keyes)
	(custom_animation keyes cinematics\animations\captain\level_specific\a50\a50 "a50_prison7" true)
	
	(cinematic_set_title shut_up)
	(sleep 30)

	(objects_attach keyes "right hand" keyes_needler "")
	
	(sleep 30)
	(cinematic_set_title sir)

	(sound_impulse_start sound\dialog\a50\a50_prison_140_captkeyes keyes 1)
	(print "keyes: Chief, you have the point.")
	(sleep (sound_impulse_time sound\dialog\a50\a50_prison_140_captkeyes))

	(fade_out 1 1 1 15)

	(sleep (- 120 (sound_impulse_time sound\dialog\a50\a50_prison_140_captkeyes)))
;	(sleep 15)
	
	(object_destroy keyes)
	(object_destroy chief)
	(object_destroy_containing marine_speech)
;	(object_destroy marine_speech_2)
;	(object_destroy marine_speech_3)
	(object_destroy marine1_plasma)
	(object_destroy marine2_plasma)
	(object_destroy marine3_plasma)
	(object_destroy keyes_needler)

	(object_pvs_activate none)
	
;	(show_hud 0)

;	(fade_in 1 1 1 15)

	(sound_class_set_gain device_door 1 3)
	
	(sleep 120)
	(cinematic_stop)
	(camera_control off)
	(show_hud 1)
)
	
(script static void run_setup

	(object_teleport marine_speech_1 marine1_run_base)
	(object_teleport marine_speech_2 marine2_run_base)
	(object_teleport marine_speech_3 marine3_run_base)
	
	(recording_play marine_speech_1 marine1_run)
	(recording_play marine_speech_2 marine2_run)
	(recording_play marine_speech_3 marine3_run)
)

(script static void cutscene_extraction

	(sound_looping_start sound\sinomatixx\a50_extraction_foley none 1)
	
;	(fade_out 1 1 1 15)
	
;	(sleep 15)
	
	(cinematic_start)
	(camera_control on)
	
	(switch_bsp 2)
	
	(object_teleport (player0) player0_extract_base)
	(object_teleport (player1) player1_extract_base)

;	(object_destroy chief)
;	(object_destroy chief_ar)
;	(object_destroy extraction_dropship)

	(object_create_anew chief)
	(object_create_anew chief_ar)
	(object_create_anew extraction_dropship)
	
	(object_pvs_activate extraction_dropship)
	
	(object_teleport chief chief_extraction_base)
	(objects_attach chief "right hand" chief_ar "")

	(camera_set chief_push_1a 0)
	(camera_set chief_push_1b 60)
	
	(unit_custom_animation_at_frame chief cinematics\animations\chief\level_specific\b30\b30 "B30HoloMap" true 130)

	(fade_in 1 1 1 15)
	
	(sound_looping_start sound\sinomatixx\a50_extraction_music none 1)
	
	(sleep 60)
	
	(object_teleport extraction_dropship extraction_dropship_base)
	(scenery_animation_start extraction_dropship cinematics\animations\c_dropship\level_specific\a50\a50 "a50_dropship")
	
	(camera_set loose_1a 0)
	
	(sound_impulse_start sound\dialog\a50\a50_extract_010_cortana none 1)
	(print "cortana: That's it, the dropship is loose.")
	
	(sleep 60)
	(camera_set loose_1b 340)
	
	(sleep (sound_impulse_time sound\dialog\a50\a50_extract_010_cortana))
	
	(sound_impulse_start sound\dialog\a50\a50_extract_020_captkeyes none 1)
	(print "keyes: Everyone get aboard!")
	(sleep (sound_impulse_time sound\dialog\a50\a50_extract_020_captkeyes))
	
	(object_destroy chief)
	(object_destroy chief_ar)

	(sleep (camera_time))
	
	(ai_erase_all)
	(camera_set interface_1a 0)
	(camera_set interface_1b 180)
	
	(sound_impulse_start sound\dialog\a50\a50_extract_030_cortana none 1)
	(print "cortana: Give me a minute to interface with the ship's controls...")
	(sleep (- (sound_impulse_time sound\dialog\a50\a50_extract_030_cortana) 15))
	
	(sound_impulse_start sound\dialog\a50\a50_extract_040_captkeyes none 1)
	(print "keyes: No, I'll take this bird out myself.")
;	(sleep (sound_impulse_time sound\dialog\a50\a50_extract_040_captkeyes))
	
	(sleep 60)
	
	(object_create_anew final_hunter_1)
	(object_create_anew final_hunter_2)
	
	(object_teleport final_hunter_1 final_hunter_1_base)
	(object_teleport final_hunter_2 final_hunter_2_base)
	
	(recording_play final_hunter_1 hunter_1_run)
	(recording_play final_hunter_2 hunter_2_run)
	
	(sleep 60)
	
	(ai_attach final_hunter_1 hunters/hunters)
	(ai_attach final_hunter_2 hunters/hunters)
	
	(sound_impulse_start sound\dialog\a50\a50_extract_050_cortana none 1)
	(print "cortana: Captain! Hunters!")
;	(sleep (sound_impulse_time sound\dialog\a50\a50_extract_050_cortana))
	
	(camera_set capt_hunters_1a 0)
	(camera_set capt_hunters_1b 120)
	
	(sleep 120)
	
	(sound_impulse_start sound\dialog\a50\a50_extract_060_captkeyes none 1)
	(print "keyes: Hang on!")
;	(sleep (sound_impulse_time sound\dialog\a50\a50_extract_060_captkeyes))
	
	(camera_set hang_on_1a 0)
	(camera_set hang_on_1b 90)
	
	(sound_looping_start sound\sinomatixx\a50_extraction_foley2 none 1)
	
	(sleep 90)

	(camera_set hunter_smash_1a 0)
	(camera_set hunter_smash_1b 90)
	
	(player_effect_set_max_rotation 0 .5 .5)
	(player_effect_set_max_vibrate .5 .5)
	(player_effect_start 1 0)
	(player_effect_stop 4)
	
	(sleep 30)
	
	(ai_kill hunters)
	(print "hunters die horribly")
	
	(sleep 60)
	
	(camera_set final_flight_1a 0)
	(camera_set final_flight_1b 250)
	
	(sound_impulse_start sound\dialog\a50\a50_extract_070_aussie none 1)
	(print "marine: Nice one, Sir!")
	(sleep (sound_impulse_time sound\dialog\a50\a50_extract_070_aussie))
	
	(sound_impulse_start sound\dialog\a50\a50_extract_080_captkeyes none 1)
	(print "keyes: Time for a little payback!")
	(sleep (sound_impulse_time sound\dialog\a50\a50_extract_080_captkeyes))
	
	(print "marine chorus: hooray!")
	
	(sleep (camera_time))
	
	(fade_out 0 0 0 30)
	
	(sleep 30)
	
	(cinematic_stop)
	(camera_control off)
	
	(cinematic_screen_effect_stop)
	
;	(game_won)
)
	
(script static void flight_check

	(object_teleport extraction_dropship extraction_dropship_base)
;	(unit_suspended extraction_dropship true)
	(scenery_animation_start extraction_dropship cinematics\animations\c_dropship\level_specific\a50\a50 "a50_dropship")
)
	
	
