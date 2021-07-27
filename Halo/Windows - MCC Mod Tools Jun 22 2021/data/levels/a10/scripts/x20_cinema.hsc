;	X20 CINEMATIC SCRIPT
;	...component scripts up top, 
;	the whole she-bang at the bottom...

(script static void no_keyes_for_you
	(object_destroy keyes)
)

(script static void halo_setup

	(object_destroy x20_halo)
	(object_create x20_halo)
)

(script static void capt_keyes

	(sound_looping_start sound\music\x20_music\x20_music_1 none 1)

	(switch_bsp 1)
	
	(object_teleport (player0) player0_base)
	(object_teleport (player1) player1_base)
	
	(object_create_anew chief)
	(object_create_anew keyes)
	(object_create_anew cortana_effect)
;	(object_create_anew x20_display)
	
	(unit_set_seat keyes alert)
	(unit_set_seat chief alert)
	
	(object_teleport chief chief_shake)
	(object_teleport keyes keyes_base)
	
	(unit_suspended keyes true)
	(unit_suspended chief true)
	
	(object_beautify chief true)
	(object_beautify keyes true)
	
	(objects_predict keyes)
	(objects_predict cortana_x20)
	
	(unit_set_emotion keyes 3)
	
	(object_create dave)
	(object_create pilot_chair)
	(vehicle_load_magic pilot_chair "" dave)
	
	(object_create cortana_effect)
	
	(camera_set capt_keyes_1a 0)
	(camera_set capt_keyes_1b 180)
	(fade_in 1 1 1 15)

	(sleep 60)
	
	(sound_impulse_start sound\dialog\x20\chief01 chief 1)
;	(print "chief: Captain Keyes?")	
	(sleep (sound_impulse_time sound\dialog\x20\chief01))
	
	(camera_set good_to_1a 0)
	(camera_set good_to_1b 200)
		
	(custom_animation keyes cinematics\animations\captain\x20\x20 "shake hands" false)
	(custom_animation chief cinematics\animations\chief\x20\x20 "shake hands" false)
	
	(sleep 60)
	
	(sound_impulse_start sound\dialog\x20\keyes01 keyes 1)
;	(print "keyes: good to see you master chief.")
	(sleep (sound_impulse_time sound\dialog\x20\keyes01))
	
	(sound_impulse_start sound\dialog\x20\keyes02 keyes 1)
;	(print "keyes: things aren't going well.")
	(sleep (sound_impulse_time sound\dialog\x20\keyes02))
	
	(camera_set cortana_best_1a 0)
;	(camera_set cortana_best_1b 200)
	
	(custom_animation keyes cinematics\animations\captain\x20\x20 "X20nochance" false)
	
	(object_teleport keyes keyes_face_chief)
	(object_teleport chief chief_base)
	
	(sound_impulse_start sound\dialog\x20\keyes02b keyes 1)
;	(print "keyes: cortana did her best, but we never really had a chance.")
	(sleep (sound_impulse_time sound\dialog\x20\keyes02b))
	
	(object_create_anew pipe)
	(objects_attach keyes pipe_in_hand pipe "")

	(cinematic_set_near_clip_distance .01)

	(camera_set cortana_appear_1a 0)
	(camera_set cortana_appear_1b 120)
	
;	CREATE CORTANA EFFECT
	(effect_new "cinematics\effects\cortana effects\cortana on off" cortana_effect_base)
	
	(sound_impulse_start sound\dialog\x20\cor01 cortana_x20 1)
;	(print "cortana: A dozen superior battle-ships against a single halcyon-class cruiser.")
	
	(sleep 30)
	
	(object_create_anew cortana_x20)
	(object_beautify cortana_x20 true)
	
	(object_teleport cortana_x20 cortana_face_display)
	(unit_suspended cortana_x20 true)
	
	(custom_animation cortana_x20 cinematics\animations\cortana\x20\x20 "X20cortana01" false)
	
	(unit_set_emotion cortana_x20 6)
	
	(sleep (sound_impulse_time sound\dialog\x20\cor01))

	(object_teleport chief chief_face_cortana)
	
	(camera_set those_odds_1a 0)
	(camera_set those_odds_1b 200)
	
	(sound_impulse_start sound\dialog\x20\cor01b cortana_x20 1)
;	(print "cortana: With those odds, I'm content with three...")	
	(sleep (- (sound_impulse_time sound\dialog\x20\cor01b) 30))

	(unit_set_emotion cortana_x20 8)
	
	(sleep (+ (sound_impulse_time sound\dialog\x20\cor01b) 15))
	
	(sound_impulse_start sound\dialog\x20\cor01c cortana_x20 1)
;	(print "cortana: make that four kills")	
	(sleep (sound_impulse_time sound\dialog\x20\cor01c))

	(unit_set_emotion cortana_x20 6)
	
	(sleep (sound_impulse_time sound\dialog\x20\cor01))

	(camera_set cortana_cu 0)
	
	(sleep 30)

	(sound_impulse_start sound\dialog\x20\cor02 cortana_x20 1)
;	(print "cortana: sleep well?")
	(sleep (sound_impulse_time sound\dialog\x20\cor02))
	
	(sleep 30)
	
	(object_teleport keyes keyes_base)
	(unit_suspended keyes false)
	
	(camera_set no_thanks_1a 0)
;	(camera_set no_thanks_1b 90)
	
	(custom_animation chief cinematics\animations\chief\x20\x20 "X20nothanks" false)
		
	(sound_impulse_start sound\dialog\x20\chief02 chief 1)
;	(print "chief: No thanks to your driving, yes.")
	(sleep (sound_impulse_time sound\dialog\x20\chief02))
	
	(unit_set_emotion cortana_x20 2)
		
	(camera_set miss_me_1a 0)
	(camera_set miss_me_1b 90)
	
	(sound_impulse_start sound\dialog\x20\cor03 cortana_x20 1)
;	(print "cortana: so you did miss me.")
	(sleep (sound_impulse_time sound\dialog\x20\cor03))
	
	(sleep 30)
)

(script static void explosion

	(switch_bsp 1)
	
	(object_teleport chief chief_shake)
	
	(sound_impulse_start sound\dialog\x20\bigboom none .5)
	(unit_set_emotion keyes 7)
	
	(player_effect_set_max_rotation 0 0 0)
	(player_effect_set_max_translation 0 0 0)
	(player_effect_set_max_vibrate 0 0)
	
	(player_effect_set_max_rotation 0 .25 .25)
	(player_effect_set_max_vibrate .4 .4)
	(player_effect_start 1 0)
	
	(sound_impulse_start sound\sfx\ambience\a10\pillarhits none 1)
	
	(object_teleport cortana_x20 cortana_face_display)
	(effect_new "cinematics\effects\cortana effects\cortana on off" cortana_effect_base)
	
	(custom_animation keyes cinematics\animations\captain\x20\x20 explosion1 true)
	(custom_animation chief cinematics\animations\chief\x20\x20 explosion1 true)
	
	(camera_set explosion_1a 0)
	(camera_set explosion_1b 60)
	(sleep 60)
	(camera_set explosion_2a 0)
	
	(sound_looping_start sound\music\x20_music\x20_music_2 none 1)
	
	(camera_set explosion_2b 60)

;	(sleep 60)
	
	(unit_set_emotion keyes 3)
	
	(unit_stop_custom_animation cortana_x20)
	
	(sound_impulse_start sound\dialog\x20\keyes03 keyes 1)
	(print "keyes: report!")
	(sleep (sound_impulse_time sound\dialog\x20\keyes03))
	
	(player_effect_stop 2)
	
	(unit_stop_custom_animation keyes)
	
	(unit_set_emotion cortana_x20 3)
	
	(sound_impulse_start sound\dialog\x20\cor04 cortana_x20 1)
	(print "cortana: It must have been one of their boarding parties. I'd guess an anti-matter charge.")
	
	(camera_set explosion_3a 0)
	(camera_set explosion_3b 60)
	
	(sleep (- (sound_impulse_time sound\dialog\x20\cor04) 15))
		
	(object_teleport keyes keyes_base)
		
	(sound_impulse_start sound\dialog\x20\flightofficer01 dave 1)
;	(print "dave: I'm not going to say anything until Jay tags my new line!")
	(sleep 30)
	
	(camera_set officer_zoom_1 0)	
	(camera_set officer_zoom_2 60)
	
	(object_teleport cortana_x20 cortana_face_keyes)
	(object_teleport keyes keyes_face_cortana)
	
	(custom_animation dave cinematics\animations\crewman\x10\x10 "sitting_turn02" true)
	
	(sleep (sound_impulse_time sound\dialog\x20\flightofficer01))

	(camera_set last_option_1a 0)
	(camera_set last_option_1b 60)
	(sound_impulse_start sound\dialog\x20\cor05 cortana_x20 1)
;	(print "cortana: Captain, the cannon was my last offensive option...")
	(sleep (sound_impulse_time sound\dialog\x20\cor05))
	
	(custom_animation keyes cinematics\animations\captain\x20\x20 captin_lookingdowngesture true)
	
	(camera_set cole_protocol_1a 0)
	(camera_set cole_protocol_1b 200)
	(sound_impulse_start sound\dialog\x20\keyes04 keyes 1)
;	(print "keyes: Allright then. I'm initiating...")
	(sleep (sound_impulse_time sound\dialog\x20\keyes04))
	
	(camera_set you_too_2a 0)
;	(camera_set you_too_2b 120)
	
	(custom_animation keyes cinematics\animations\captain\x20\x20 gesture1 true)
	
	(sound_impulse_start sound\dialog\x20\keyes05 keyes 1)
;	(print "keyes: That means you too, Cortana.")
	(sleep (sound_impulse_time sound\dialog\x20\keyes05))		

	(unit_set_emotion cortana_x20 11)
	(custom_animation cortana_x20 cinematics\animations\cortana\x20\x20 cortana_gesture2 true)
		
	(camera_set do_what_1a 0)
	(camera_set do_what_1b 180)
	
	(object_teleport keyes keyes_base)
	
	(objects_detach keyes pipe)
	(objects_attach keyes mouth01 pipe "")
	
	(sound_impulse_start sound\dialog\x20\cor06 cortana_x20 1)
;	(print "cortana: While you do what, go down with the ship?")
	(sleep (sound_impulse_time sound\dialog\x20\cor06))
	
	(camera_set manner_1a 0)
	(camera_set manner_1b 180)

	(sound_looping_start sound\music\x20_music\x20_music_3 none 1)
	
	(custom_animation keyes cinematics\animations\captain\x20\x20 "pipe point" true)
	
	(sound_impulse_start sound\dialog\x20\keyes06 keyes 1)
	(print "keyes: In a manner of speaking")

	(sleep 50)
	(objects_detach keyes pipe)
	(objects_attach keyes pipe_in_hand pipe "")

	(sleep (sound_impulse_time sound\dialog\x20\keyes06))

	(camera_set pipe_point_rev 0)

	(camera_set manner_2a 0)
	(camera_set manner_2b 200)				

	(sound_impulse_start sound\dialog\x20\keyes07 keyes 1)
;	(print "keyes: The object we found, I'm going to try and land the Autumn on it.")	
	(sleep (sound_impulse_time sound\dialog\x20\keyes07))
		
	(sound_impulse_start sound\dialog\x20\cor07 cortana_x20 1)
	(print "cortana: With all due respect, Sir...")
	
	(sleep 60)
	(camera_set due_respect_1a 0)
	(camera_set due_respect_1b 120)
	
	(object_teleport keyes keyes_face_cortana)
	
	(unit_stop_custom_animation keyes)
	(sleep (sound_impulse_time sound\dialog\x20\cor07))
	
	(sleep 15)
	
	(camera_set appreciate_1a 0)
	(camera_set appreciate_1b 500)
	
	(custom_animation keyes cinematics\animations\captain\x20\x20 gesture2 true)

	(sound_impulse_start sound\dialog\x20\keyes08 keyes 1)
;	(print "keyes: I appreciate your concern, cortana, but it's not up to me.")
	(sleep (sound_impulse_time sound\dialog\x20\keyes08))
	
	(sound_impulse_start sound\dialog\x20\keyes09 keyes 1)
;	(print "keyes: protocol is clear, destruction or capture of...")

	(sleep (unit_get_custom_animation_time keyes))
	(custom_animation keyes cinematics\animations\captain\x20\x20 captin_gesturetoside true)
		
	(sleep (- (sound_impulse_time sound\dialog\x20\keyes09) 90))
	
	(camera_set aye_aye_1a 0)
	(camera_set aye_aye_1b 180)
	
	(ai_detach keyes)
	
	(object_teleport keyes keyes_face_chief)
	
	(sleep 15)
	
	(unit_set_emotion cortana_x20 6)
	(custom_animation cortana_x20 cinematics\animations\cortana\x20\x20 cortana_cross_arms true)
	
	(sleep (sound_impulse_time sound\dialog\x20\keyes09))
	
	(sound_impulse_start sound\dialog\x20\cor08 cortana_x20 1)
;	(print "cortana: aye-aye, sir.")
	(sleep (sound_impulse_time sound\dialog\x20\cor08))
	
	(effect_new "cinematics\effects\cortana effects\cortana on off" cortana_effect_base)
	
	(sleep 30)
	
	(unit_stop_custom_animation keyes)

	(object_destroy cortana_x20)
	(sleep 30)
)

(script static void final_words

	(switch_bsp 1)
		
	(camera_set you_come_1a 0)
	(camera_set you_come_1b 350)
	
;	CUE "x20_music_4"
	(sound_looping_start sound\music\x20_music\x20_music_4 none 1)
	
;	(camera_set shake_1b 240)
	(sleep 30)	
	
	(sound_impulse_start sound\dialog\x20\keyes10 keyes 1)
;	(print "keyes: Which is where you come in, Chief...")
	(sleep (- (sound_impulse_time sound\dialog\x20\keyes10) 30))
	
	(camera_set earth_1a 0)
	(camera_set earth_1b 30)
	
	(sleep 30)
	
	(sound_impulse_start sound\dialog\x20\keyes10b keyes 1)
;	(print "keyes: Earth.")
	(sleep (sound_impulse_time sound\dialog\x20\keyes10b))
		
	(camera_set understand_1a 0)
	
	(custom_animation chief cinematics\animations\chief\x20\x20 "X20yes" false)
	
	(sound_impulse_start sound\dialog\x20\chief03 chief 1)
;	(print "chief: I understand.")
	(sleep (sound_impulse_time sound\dialog\x20\chief03))
	
	(sleep 30)
		
	(camera_set evasive_1a 0)
	(camera_set evasive_1b 300)
	
;	CREATE CORTANA EFFECT
	(effect_new "cinematics\effects\cortana effects\cortana on off" cortana_effect_base)
	(sleep 30)
	
	(object_destroy cortana_x20)
	(object_create cortana_x20)
	
	(unit_suspended cortana_x20 true)
	
	(object_teleport cortana_x20 cortana_face_keyes)
	(object_teleport keyes keyes_face_cortana)
	(object_teleport chief chief_face_cortana)
	
	(unit_set_emotion cortana_x20 9)

	(sound_impulse_start sound\dialog\x20\cor09 cortana_x20 1)
;	(print "cortana: The Autumn will continue evasive manuevers...")
	(sleep (sound_impulse_time sound\dialog\x20\cor09))
	
	(custom_animation cortana_x20 cinematics\animations\cortana\x20\x20 cortana_gesture1 false)
	
	(camera_set not_listen_1a 0)
	(camera_set not_listen_1b 200)
	
	(sound_impulse_start sound\dialog\x20\cor09b cortana_x20 1)
;	(print "cortana: Not that you'll listen...")
	(sleep (sound_impulse_time sound\dialog\x20\cor09b))
	
	(camera_set keyes_chip_1a 0)
	(camera_set keyes_chip_1b 200)
	
	(sound_impulse_start sound\dialog\x20\keyes12 keyes 1)
;	(print "keyes: excellent work, cortana.") 
	(sleep (sound_impulse_time sound\dialog\x20\keyes12))
	
;	(custom_animation keyes cinematics\animations\captain\x20\x20 captin_nodgesture true)

	(sound_impulse_start sound\dialog\x20\keyes12b keyes 1)
;	(print "keyes: Are you ready?")
	(sleep (sound_impulse_time sound\dialog\x20\keyes12b))

	(camera_set yank_me_1a 0)
	(camera_set yank_me_1b 180)
	(custom_animation cortana_x20 cinematics\animations\cortana\x20\x20 cortana_lookaround false)
	
	(ai_detach keyes)
	
	(sleep 150)
	(sound_impulse_start sound\dialog\x20\cor10 cortana_x20 1)
;	(print "cortana: yank me.")	
	(sleep (sound_impulse_time sound\dialog\x20\cor10))

	(object_teleport keyes keyes_chip)
	(object_teleport chief chief_base)
	
	(camera_set chip_1a 0)
	(custom_animation keyes cinematics\animations\captain\x20\x20 "remove chip" true)
	
	(sleep 19)

	(sound_impulse_start sound\dialog\x20\x20_unique1 none 1)
	
	(sleep 60)
	
	(custom_animation chief cinematics\animations\chief\x20\x20 "take chip" true)
	
	(sleep 41)
	
	(camera_set chip_1b 0)
	(camera_set chip_1b2 90)
	
	(sleep 10)

	(sound_impulse_start sound\dialog\x20\x20_unique2 none 1)
	
	(effect_new "cinematics\effects\cortana effects\cortana on off" cortana_effect_base)
	
	(sleep 30)
	
	(object_destroy cortana_x20)
	
	(sleep 50)
	
	(objects_detach keyes pipe)
	(object_destroy pipe)
	
	(object_destroy cortana_chip)
	(object_create cortana_chip)
	
	(objects_attach keyes "right hand" cortana_chip "")
	
	(camera_set chip_1c 0)
	(camera_set chip_1c2 180)

	(sleep 30)
	
	(objects_detach keyes cortana_chip)
	(objects_attach keyes "left hand" cortana_chip "")
	
	(sound_impulse_start sound\dialog\x20\keyes14 keyes 1)
	(print "keyes: Good luck, Master-chief.")
;	(sleep (sound_impulse_time sound\dialog\x20\keyes13))

	(sleep 120)
		
	(camera_set chip_2a 0)
	
	(objects_detach keyes cortana_chip)
	(objects_attach chief "left hand" cortana_chip "")
	
	(sleep 60)

	(sound_impulse_start sound\dialog\x20\x20_unique3 none 1)
	
	(camera_set chip_2b 30)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_convolution 3 2 1 10 1)
	
	(fade_out 1 1 1 30)	
	
	(sleep 15)
	(effect_new_on_object_marker "cinematics\effects\cyborg chip insertion" chief "left hand")
	(sleep 15)
)

(script static void cortana_test
	(effect_new "cinematics\effects\cortana effects\cortana on off" cortana_effect_base)
)

(script static void dave_test
	(custom_animation dave cinematics\animations\crewman\x10\x10 "sitting_turn02" true)
)

(script static void X20

	(player_effect_set_max_translation 0 0 0)
	(player_effect_set_max_rotation 0 0 0)
	(player_effect_set_max_vibrate 0 0)

	(fade_out 1 1 1 0)
	(sleep 30)
	
	(object_destroy chief)
	 
	(cinematic_start)
	(camera_control on)

	(switch_bsp 1)
	
	(halo_setup)
	
;	BEGIN "capt_keyes" SCENE
	(capt_keyes)
	
;	BEGIN "explosion" SCENE
	(explosion)
	
;	BEGIN "final_words" SCENE
	(final_words)
	
	(objects_detach chief cortana_chip)
	(object_destroy cortana_chip)

;	(sound_class_set_gain music .25 1)
	
	(sound_impulse_start sound\dialog\a10\A10_flavor_340_Cortana none 1)
	(sleep (sound_impulse_time sound\dialog\a10\A10_flavor_340_Cortana))
	
	(sound_impulse_start sound\dialog\a10\A10_flavor_350_Chief none 1)
	(sleep (sound_impulse_time sound\dialog\a10\A10_flavor_350_Chief))

	(cinematic_stop)
	(camera_control off)
	(object_destroy chief)
	(object_destroy keyes)
	
	(object_destroy dave)
	(object_destroy pilot_chair)
	
	(cinematic_screen_effect_stop)
	
	(sound_class_set_gain music 1 0)
	
	(cinematic_set_near_clip_distance .0625)
)
