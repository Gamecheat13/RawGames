;	X10 CINEMATIC SCRIPT
;	...component scripts up top, 
;	the whole she-bang at the bottom...

(script static void battle_start
	
	(object_create_anew_containing x10_battle)
	
	(device_set_position x10_battle_1 1)
	(device_set_position x10_battle_2 1)
	(device_set_position x10_battle_3 1)
	(device_set_position x10_battle_4 1)
	(device_set_position x10_battle_5 1)
	(device_set_position x10_battle_6 1)
	(device_set_position x10_battle_7 1)
	(device_set_position x10_battle_8 1)
	(device_set_position x10_battle_9 1)
	(device_set_position x10_battle_10 1)
	(device_set_position x10_battle_11 1)
	(device_set_position x10_battle_12 1)
)

(script static void battle_stop
	
	(object_destroy_containing x10_battle)
;	(object_destroy x10_battle_1)
;	(object_destroy x10_battle_2)
;	(object_destroy x10_battle_3)
;	(object_destroy x10_battle_4)
;	(object_destroy x10_battle_5)
;	(object_destroy x10_battle_6)
)

(script static void bomber_setup

	(object_create_anew_containing space_bomber)
;	(object_create_anew space_bomber_1)
;	(object_create_anew space_bomber_2)
;	(object_create_anew space_bomber_3)
;	(object_create_anew space_bomber_4)
;	(object_create_anew space_bomber_5)
;	(object_create_anew space_bomber_6)

	(object_set_scale space_bomber_1 .35 0)
	(object_set_scale space_bomber_2 .35 0)
	(object_set_scale space_bomber_3 .35 0)
	(object_set_scale space_bomber_4 .35 0)
	(object_set_scale space_bomber_5 .35 0)
	(object_set_scale space_bomber_6 .35 0)
)

(script static void bomber_cleanup

	(object_destroy_containing space_bomber)
;	(object_destroy space_bomber_1)
;	(object_destroy space_bomber_2)
;	(object_destroy space_bomber_3)
;	(object_destroy space_bomber_4)
;	(object_destroy space_bomber_5)
;	(object_destroy space_bomber_6)
)

(script static void bomber_flight_1
	(object_teleport space_bomber_1 bomber_base_6)
	(object_teleport space_bomber_2 bomber_base_7)
	
	(recording_play space_bomber_1 fly_straight)
	(recording_play space_bomber_2 fly_straight)
)

(script static void bomber_flight_2
	(object_teleport space_bomber_3 bomber_base_1)
	(object_teleport space_bomber_4 bomber_base_2)
	(object_teleport space_bomber_5 bomber_base_9)
	
	(recording_play space_bomber_3 fly_straight)
	(recording_play space_bomber_4 fly_straight)
	(recording_play space_bomber_5 fly_straight)	
)
	
(script static void bomber_flight_3
	(object_teleport space_bomber_1 bomber_base_5)
	(object_teleport space_bomber_2 bomber_base_4)
	(object_teleport space_bomber_3 bomber_base_3)
	
	(recording_play space_bomber_1 fly_straight)
	(recording_play space_bomber_2 fly_straight)
	(recording_play space_bomber_3 fly_straight)	
)

(script static void bomber_flight_4
	(object_teleport space_bomber_1 bomber_base_3)
	(object_teleport space_bomber_2 bomber_base_4)
	(recording_play space_bomber_1 fly_straight)
	(recording_play space_bomber_2 fly_straight)
)

(script static void bomber_flight_5
	(object_teleport space_bomber_4 bomber_base_8)
	(recording_play space_bomber_4 fly_straight)
)

(script static void bomber_flight_6
	(object_teleport space_bomber_4 bomber_base_5)
	(recording_play space_bomber_4 fly_straight)
)

(script static void flight_cleanup
	(recording_kill space_bomber_1)
	(recording_kill space_bomber_2)
	(recording_kill space_bomber_3)
	(recording_kill space_bomber_4)
	(recording_kill space_bomber_5)
	(recording_kill space_bomber_6)
)

(script static void autumn_glory_1

	(object_create_anew glory_halo)
	(object_pvs_set_camera autumn_glory_1a)
	
	(bomber_setup)
	
	(camera_set autumn_glory_1a2 0)
	
	(fade_in 0 0 0 90)

	(sleep 180)
	
	(camera_set autumn_glory_1b 200)
	
	(sleep 100)
	
	(bomber_flight_1)
	
	(camera_set autumn_glory_1c 200)
	
	(sleep 100)

	(object_destroy glory_halo)
	
	(camera_set autumn_glory_1f 375)
		
	(bomber_flight_2)
	
	(sleep 250)
	
;	(print "shot end")
	(object_destroy glory_halo)
)

(script static void autumn_glory_2

	(bomber_cleanup)
	(bomber_setup)
	(bomber_flight_3)

	(object_create_anew keyes_x10_space)
	(object_create_anew space_crew_1)
	(object_create_anew space_crew_2)
	(object_create_anew space_crew_3)
	(object_create_anew space_chair_1)
	(object_create_anew space_chair_2)
	(object_create_anew space_display)
	
	(object_pvs_activate keyes_x10_space)
	
	(vehicle_load_magic space_chair_1 "" space_crew_1)
	(vehicle_load_magic space_chair_2 "" space_crew_2)
	
	(custom_animation space_crew_1 characters\marine\marine "pchair-driver unarmed idle%0" false)
	(custom_animation space_crew_2 characters\marine\marine "pchair-driver unarmed idle%2" false)
	
	(unit_set_seat keyes_x10_space alert)
	
	(object_teleport space_crew_3 space_walk_base)
	
	(rasterizer_lights_reset_for_new_map)
	
	(camera_set autumn_glory_2a 0)
	(camera_set autumn_glory_2b 300)
	(sleep 150)

	(camera_set autumn_glory_2c 300)
	(sleep 100)
	
	(bomber_flight_6)
	
	(sleep 50)
	
	(flight_cleanup)
	
	(bomber_flight_4)
	
	(camera_set autumn_glory_2d 300)
	
	(objects_predict keyes_x10)
	(objects_predict x10_chair_1r)
	(objects_predict x10_chair_pr)
	(objects_predict x10_crew_1r)

	(sleep 50)
	
	(sound_impulse_start sound\dialog\x10\keyes01 none 1)
;	(print "keyes: where are we?")
;	(sleep (sound_impulse_time sound\dialog\x10\keyes01))
	
	(recording_play space_crew_3 space_walk_1)
	
	(sleep 100)
	
	(sound_impulse_start sound\dialog\x10\cor01 none 1)
;	(print "cortana: does it really matter?")
;	(sleep (sound_impulse_time sound\dialog\x10\cor01))
	
	(bomber_flight_5)
	
	(sleep 150)
	
	(fade_out 0 0 0 15)
	(sleep 15)
	
	(object_destroy keyes_x10_space)
	(object_destroy_containing space_crew)
;	(object_destroy space_crew_1)
;	(object_destroy space_crew_2)
;	(object_destroy space_crew_3)
	(object_destroy_containing space_chair)
;	(object_destroy space_chair_1)
;	(object_destroy space_chair_2)
	(object_destroy space_display)
	
	(flight_cleanup)
)

(script dormant x10_crew_salute_1
	(object_create_anew x10_crew_panic_1)
	(object_teleport x10_crew_panic_1 x10_salute_base_1)
	(custom_animation x10_crew_panic_1 cinematics\animations\crewman\x10\x10 stand_salute true)
	(unit_get_custom_animation_time x10_crew_panic_1)
	(recording_play_and_delete x10_crew_panic_1 x10_salute_1_finish)
)

(script dormant x10_crew_salute_2
	(object_create_anew x10_crew_panic_2)
	(object_teleport x10_crew_panic_2 x10_salute_base_2)
	(recording_play x10_crew_panic_2 x10_salute_2_start)
	(sleep (- (recording_time x10_crew_panic_2) 60))
	(custom_animation x10_crew_panic_2 cinematics\animations\crewman\x10\x10 stand_salute true)
	(unit_get_custom_animation_time x10_crew_panic_2)
	(recording_kill x10_crew_panic_2)
	(recording_play_and_delete x10_crew_panic_2 x10_salute_2_finish)
)

(script dormant x10_crew_panic_1
	(object_create_anew x10_crew_panic_1)
	(object_teleport x10_crew_panic_1 x10_panic_1_base)
	(custom_animation x10_crew_panic_1 cinematics\animations\crewman\x10\x10 crew_panic1 true)
	(sleep (unit_get_custom_animation_time x10_crew_panic_1))
	(object_destroy x10_crew_panic_1)
)

(script dormant x10_crew_panic_2
	(object_create_anew x10_crew_panic_2)
	(object_teleport x10_crew_panic_2 x10_panic_2_base)
	(custom_animation x10_crew_panic_2 cinematics\animations\crewman\x10\x10 crew_panic2 true)
	(sleep (unit_get_custom_animation_time x10_crew_panic_2))
	(object_destroy x10_crew_panic_2)
)

(script dormant x10_crew_panic_3
	(object_create_anew x10_crew_panic_3)
	(object_teleport x10_crew_panic_3 x10_panic_3_base)
	(recording_play x10_crew_panic_3 x10_panic_run_3)
	(sleep 90)
	(object_destroy x10_crew_panic_3)
)

(script dormant x10_crew_panic_4
	(object_create_anew x10_crew_panic_4)
	(object_teleport x10_crew_panic_4 x10_panic_4_base)
	(recording_play x10_crew_panic_4 x10_panic_run_4)
	(sleep (recording_time x10_crew_panic_4))
	(object_destroy x10_crew_panic_4)
)

(script dormant x10_crew_panic_5
	(object_create_anew x10_crew_panic_1)
	(object_teleport x10_crew_panic_1 x10_panic_5_base)
	(recording_play x10_crew_panic_1 x10_panic_run_5)
	(sleep (recording_time x10_crew_panic_1))
	(object_destroy x10_crew_panic_1)
)

(script dormant x10_crew_panic_6
	(object_create_anew x10_crew_panic_2)
	(object_teleport x10_crew_panic_2 x10_panic_6_base)
	(recording_play x10_crew_panic_2 x10_panic_run_6)
	(sleep (recording_time x10_crew_panic_2))
	(object_destroy x10_crew_panic_2)
)

(script dormant x10_crew_walk_1
	(object_create_anew x10_crew_panic_1)
	(object_teleport x10_crew_panic_1 x10_walk_1_base)
	(recording_play x10_crew_panic_1 x10_crew_walk_1)
	(sleep (recording_time x10_crew_panic_1))
	(object_destroy x10_crew_panic_1)
)

(script dormant x10_crew_walk_2
	(object_create_anew x10_crew_panic_2)
	(object_teleport x10_crew_panic_2 x10_walk_2_base)
	(recording_play x10_crew_panic_2 x10_crew_walk_2_start)
	(sleep (recording_time x10_crew_panic_2))
	(custom_animation x10_crew_panic_2 cinematics\animations\crewman\x10\x10 stand_salute true)
	(sleep (unit_get_custom_animation_time x10_crew_panic_2))
	(recording_play x10_crew_panic_2 x10_crew_walk_2_finish)
	(sleep (recording_time x10_crew_panic_2))
	(object_destroy x10_crew_panic_2)
)

(script dormant x10_crew_walk_3
	(object_create_anew x10_crew_panic_3)
	(object_teleport x10_crew_panic_3 x10_walk_3_base)
	(recording_play x10_crew_panic_3 x10_crew_walk_3)
	(sleep (recording_time x10_crew_panic_3))
	(object_destroy x10_crew_panic_3)
)

(script dormant x10_crew_walk_4
	(object_create_anew x10_crew_panic_4)
	(object_teleport x10_crew_panic_4 x10_walk_4_base)
	(recording_play x10_crew_panic_4 x10_crew_walk_4)
	(sleep (recording_time x10_crew_panic_4))
	(object_destroy x10_crew_panic_4)
)
	
(script static void peer_start
	(vehicle_load_magic x10_chair_1l "" x10_crew_1l)
	(object_teleport keyes_x10 keyes_peer)
	(custom_animation x10_crew_1l characters\marine\marine pilot_fidget02 true)
	(custom_animation keyes_x10 cinematics\animations\captain\x10\x10 inspect_console_a true)
	)

(script static void peer_stop
	(unit_stop_custom_animation keyes_x10)
	(object_teleport keyes_x10 keyes_peer_stop)
	(custom_animation keyes_x10 cinematics\animations\captain\x10\x10 inspect_console_b true)
	(custom_animation x10_crew_1l characters\marine\marine pilot_fidget03 true)
	)
	
(script static void x10_chair_load
	(object_create_anew_containing x10_chair)
;	(object_create_anew x10_chair_1l)
;	(object_create_anew x10_chair_2l)
;	(object_create_anew x10_chair_3l)
;	(object_create_anew x10_chair_1r)
;	(object_create_anew x10_chair_pl)
;	(object_create_anew x10_chair_pr)
	(object_create_anew_containing x10_crew)
;	(object_create_anew x10_crew_1l)
;	(object_create_anew x10_crew_2l)
;	(object_create_anew x10_crew_3l)
;	(object_create_anew x10_crew_1r)
;	(object_create_anew x10_crew_pl)
;	(object_create_anew x10_crew_pr)

	(vehicle_load_magic x10_chair_1l "" x10_crew_1l)
	(vehicle_load_magic x10_chair_2l "" x10_crew_2l)
	(vehicle_load_magic x10_chair_3l "" x10_crew_3l)
	(vehicle_load_magic x10_chair_1r "" x10_crew_1r)
	(vehicle_load_magic x10_chair_pl "" x10_crew_pl)
	(vehicle_load_magic x10_chair_pr "" x10_crew_pr)
	
	(custom_animation x10_crew_1l characters\marine\marine "pchair-driver unarmed idle%0" false)
	(custom_animation x10_crew_2l characters\marine\marine "pchair-driver unarmed idle%2" false)
	(custom_animation x10_crew_3l characters\marine\marine "pchair-driver unarmed idle%0" false)
	(custom_animation x10_crew_1r characters\marine\marine "pchair-driver unarmed idle%0" false)
	(custom_animation x10_crew_pl characters\marine\marine "pchair-driver unarmed idle%2" false)
	(custom_animation x10_crew_pr characters\marine\marine "pchair-driver unarmed idle%0" false)
)

(script static void x10_chair_cleanup
	(object_destroy_containing x10_chair)
;	(object_destroy x10_chair_1l)
;	(object_destroy x10_chair_2l)
;	(object_destroy x10_chair_3l)
;	(object_destroy x10_chair_1r)
;	(object_destroy x10_chair_pl)
;	(object_destroy x10_chair_pr)
	(object_destroy_containing x10_crew)
;	(object_destroy x10_crew_1l)
;	(object_destroy x10_crew_2l)
;	(object_destroy x10_crew_3l)
;	(object_destroy x10_crew_1r)
;	(object_destroy x10_crew_pl)
;	(object_destroy x10_crew_pr)
	(object_destroy_containing x10_crew_panic)
;	(object_destroy x10_crew_panic_1)
;	(object_destroy x10_crew_panic_2)
;	(object_destroy x10_crew_panic_3)
;	(object_destroy x10_crew_panic_4)
)

(script static void light_switch
	(object_create_anew_containing x10_light)
;	(object_create_anew x10_light_1)
;	(object_create_anew x10_light_2)
;	(object_create_anew x10_light_3)
;	(object_create_anew x10_light_4)
)

(script static void bridge

	(cinematic_start)
	(camera_control on)
	(unit_suspended (player0) true)
	
	(switch_bsp 1)

	(x10_chair_load)
	(object_destroy x10_crew_panic_1)
	
	(object_create_anew keyes_x10)
;	(object_create_anew x10_display)
	(object_create_anew pipe_x10)
	
	(object_destroy_containing x10_crew_panic)
	
	(object_teleport keyes_x10 keyes_deck)
	(objects_attach keyes_x10 pipe_in_hand pipe_x10 "")
	(unit_set_emotion keyes_x10 3)
	(unit_set_seat keyes_x10 alert)
	(object_pvs_activate keyes_x10)
	
	(recording_play keyes_x10 keyes_look_1)
	(sleep 5)
	(fade_in 0 0 0 30)
	
	(camera_set keyes_x10_deck_1a 0)
	(camera_set keyes_x10_deck_1b 200)
	(sleep 200)
	
	(custom_animation keyes_x10 cinematics\animations\captain\x10\x10 "how_did_they" true)
	(camera_set keyes_x10_deck_2a 0)
	(camera_set keyes_react_1a 180)
	
	(sound_impulse_start sound\dialog\x10\keyes02 keyes_x10 1)
;	(print "keyes: We made a blind jump. How did they--")
	(sleep (- (sound_impulse_time sound\dialog\x10\keyes02) 15))
	
	(sound_impulse_start sound\dialog\x10\cor02 none 1)
;	(print "cortana: Get here first? They've always been faster.")
	(sleep (sound_impulse_time sound\dialog\x10\cor02))
	
	(recording_kill keyes_x10)
	
	(recording_play keyes_x10 keyes_walk_1)
	
	(camera_set keyes_peer_walk_1 0)
	(camera_set keyes_x10_peer_walk_1 200)
	
	(sound_impulse_start sound\dialog\x10\cor03 none 1)
;	(print "cortana: As for predicting our destination, at light speed my maneuvering options were...limited.")
	
	(sleep 100)
	(camera_set keyes_x10_peer_walk_2 120)

	(sleep 60)
	
	(wake x10_crew_salute_1)
	
	(camera_set keyes_x10_peer_walk_3 200)
	
	(sleep (sound_impulse_time sound\dialog\x10\cor03))
	
	(wake x10_crew_salute_2)
	
	(sound_impulse_start sound\dialog\x10\keyes03 keyes_x10 1)
;	(print "keyes: We were running dark, yes?")
	(sleep (sound_impulse_time sound\dialog\x10\keyes03))
	
	(sound_impulse_start sound\dialog\x10\cor04 none 1)
;	(print "cortana: We were. Until we decelerated. No one could have missed the hole we tore in sub-space.")
	(sleep (recording_time keyes_x10))
	
	(objects_detach keyes_x10 pipe_x10)
	
	(camera_set keyes_x10_peer_1a 0)
	(camera_set keyes_peer_2a 120)
	(object_teleport keyes_x10 keyes_peer)
	(custom_animation keyes_x10 cinematics\animations\captain\x10\x10 inspect_console_a true)
	
	(custom_animation x10_crew_1l characters\marine\marine "pilot_fidget01" true)
	
	(sleep 120)
	
	(object_teleport keyes_x10 keyes_deck)
	(unit_stop_custom_animation keyes_x10)
	
	(sound_looping_start sound\sinomatixx_foley\x10_foley1 none 1)	
	
	(camera_set keyes_peer_2b 0)
	(camera_set keyes_x10_peer_1b 90)
	
	(custom_animation x10_crew_1l characters\marine\marine "pilot_fidget03" true)
	
	(sleep (sound_impulse_time sound\dialog\x10\cor04))
	
	(sound_impulse_start sound\dialog\x10\cor04b none 1)
;	(print "cortana: Besides, they were waiting for us.")

	(sleep 60)

	(object_teleport keyes_x10 keyes_peer_stop)
	(objects_attach keyes_x10 pipe_in_hand pipe_x10 "")
	(recording_play keyes_x10 keyes_walk_2)
	
	(sleep 60)
	
	(camera_set keyes_x10_display_walk_1a 0)	
	(camera_set keyes_x10_display_walk_1b 200)
	
	(sleep (sound_impulse_time sound\dialog\x10\cor04b))
	
	(wake x10_crew_walk_1)
	(wake x10_crew_walk_2)
	(wake x10_crew_walk_3)
	(wake x10_crew_walk_4)
	
	(sound_impulse_start sound\dialog\x10\keyes04 keyes_x10 1)
;	(print "keyes: So where do we stand?")
	(sleep (sound_impulse_time sound\dialog\x10\keyes04))
	
	(sound_impulse_start sound\dialog\x10\cor05 none 1)
;	(print "cortana: I'm mopping up the last of their recon picket now. Nothing serious.")
	(sleep (sound_impulse_time sound\dialog\x10\cor05))
	
	(sleep (camera_time))
	
	(camera_set display_rev_1a 0)
	(object_teleport keyes_x10 keyes_x10_display)
	
	(cinematic_set_near_clip_distance .01)
	
	(custom_animation keyes_x10 cinematics\animations\captain\x10\x10 well_thats_it_then true)
	
	(sound_impulse_start sound\dialog\x10\cor05b none 1)
;	(print "cortana: But I've isolated approach signatures for multiple CCS-class battle-groups. Make it three capitol ships per group, and in about 90 seconds this neighborhood's going to get a lot more crowded.")
	
	(sleep 21)
	(objects_detach keyes_x10 pipe_x10)
	(objects_attach keyes_x10 pipe_in_hand pipe_x10 "")
	
	(camera_set display_rev_1b 200)
	
	(sleep 150)
	
	(unit_set_emotion keyes_x10 5)
	
	(sleep (- (sound_impulse_time sound\dialog\x10\cor05b) 60))
	
	(unit_set_emotion keyes_x10 3)
	
	(sleep (sound_impulse_time sound\dialog\x10\cor05b))
	
	(camera_set thats_it_then_1a 0)
	(camera_set thats_it_then_1b 120)
	
	(sound_impulse_start sound\dialog\x10\keyes05 keyes_x10 1)
;	(print "keyes: Well. That's it then. Bring the ship back up to combat alert alpha.")
	
	(sleep (sound_impulse_time sound\dialog\x10\keyes05))
	
	(camera_set keyes_x10_alert_1a 0)
	(camera_set keyes_x10_alert_1b 180)
	
	(light_switch)
	
	(wake x10_crew_panic_1)
	(wake x10_crew_panic_3)
	
	(sleep (sound_impulse_time sound\dialog\x10\keyes05))
	
	(objects_predict cortana_x10)
	
	(sound_impulse_start sound\dialog\x10\keyes06 keyes_x10 1)
;	(print "keyes: I want everyone at their stations.")

	(sleep (sound_impulse_time sound\dialog\x10\keyes06))
	
	(wake x10_crew_panic_4)
	
	(sound_impulse_start sound\dialog\x10\cor06 none 1)
;	(print "cortana: Everyone, Sir?")
	(sleep (sound_impulse_time sound\dialog\x10\cor06))
	
	(sound_impulse_start sound\dialog\x10\keyes07 keyes_x10 1)
;	(print "keyes: Everyone.")
	
	(wake x10_crew_panic_2)
	
	(sleep (sound_impulse_time sound\dialog\x10\keyes07))
		
	(unit_stop_custom_animation keyes_x10)
	(object_teleport keyes_x10 keyes_face_cortana)
	(recording_play keyes_x10 keyes_x10_look_at_cortana)
	
	(sleep (camera_time))
	
	(object_destroy x10_crew_panic_1)
	(object_destroy x10_crew_panic_2)

	(camera_set keyes_to_cortana_1 0)
	
	(wake x10_crew_panic_5)
	
	(sound_impulse_start sound\dialog\x10\keyes08 keyes_x10 1)
;	(print "keyes: And cortana...")
	(sleep (sound_impulse_time sound\dialog\x10\keyes08))
	
	(effect_new "cinematics\effects\cortana effects\cortana on off" x10_cortana_effect)
	(sleep 30)
	
	(object_destroy cortana_x10)
	(object_create cortana_x10)
	(object_teleport cortana_x10 cortana_face_keyes)
	(unit_set_emotion cortana_x10 6)
	
	(sound_impulse_start sound\dialog\x10\cor07 cortana_x10 1)
;	(print "cortana: Hmmm?")
	(sleep (sound_impulse_time sound\dialog\x10\cor07))
	
	(sleep 30)
	
	(camera_set keyes_to_cortana_2 0)
	
	(object_type_predict vehicles\pelican\pelican)
	(object_type_predict vehicles\fighterbomber\fighterbomber)
	(object_type_predict vehicles\scorpion\scorpion)
	(object_type_predict characters\marine_armored\marine_armored)
	(object_type_predict "levels\a10\devices\h gun rack\h gun rack")
	(object_type_predict "levels\a10\devices\h oxy tank\h oxy tank")
	
;	(objects_predict hangar_marine_1)
;	(objects_predict x10_pelican_1)
;	(objects_predict x10_scorpion_1)
;	(objects_predict x10_warthog_1)
;	(objects_predict scenery_pelican_1)
;	(objects_predict scenery_bomber)
;	(objects_predict x10_oxy_1a)
;	(objects_predict x10_rack_1a)
	
	(sound_impulse_start sound\dialog\x10\keyes09 keyes_x10 1)
	(sleep 30)
	(unit_set_emotion keyes_x10 1)
;	(print "keyes: Let's give our old friends a warm welcome.")
	(sleep (sound_impulse_time sound\dialog\x10\keyes09))
	
	(camera_set keyes_to_cortana_3a 0)
	
	(wake x10_crew_panic_6)
	
	(sound_impulse_start sound\dialog\x10\cor08 cortana_x10 1)
;	(print "cortana: I've already begun.")
	(sleep (sound_impulse_time sound\dialog\x10\cor08))
	
	(camera_set keyes_to_cortana_3b 30)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_convolution 3 2 .001 10 1)
	(cinematic_screen_effect_set_filter_desaturation_tint .8 0 1)
	(cinematic_screen_effect_set_filter 0 1 0 1 true 1)
	
	(sleep 15)
	
	(fade_out .8 0 1 15)
	(sleep 15)
	
	(object_destroy cortana_x10)
	(object_destroy keyes_x10)
	
	(x10_chair_cleanup)
	
	(cinematic_screen_effect_stop)
)

(script dormant x10_hog_1
	(object_create_anew x10_warthog_1)
	(object_create_anew hog_1_driver)
	(object_create_anew hog_1_passenger)
	(object_create_anew hog_1_gunner)
	
	(vehicle_load_magic x10_warthog_1 "W-driver" hog_1_driver)
	(vehicle_load_magic x10_warthog_1 "W-passenger" hog_1_passenger)
	(vehicle_load_magic x10_warthog_1 "W-gunner" hog_1_gunner)
	
	(object_teleport x10_warthog_1 x10_hog_1)
	(recording_play x10_warthog_1 x10_hog_1_run)
	
	(sleep (recording_time x10_warthog_1))
	(object_destroy x10_warthog_1)
	(object_destroy hog_1_driver)
	(object_destroy hog_1_passenger)
	(object_destroy hog_1_gunner)
)

(script dormant x10_hog_2
	(object_create_anew x10_warthog_2)
	(object_create_anew hog_2_driver)
	(vehicle_load_magic x10_warthog_2 "W-driver" hog_2_driver)
	(object_teleport x10_warthog_2 x10_hog_2_base)
	(recording_play x10_warthog_2 x10_hog_2_run)
	(sleep (recording_time x10_warthog_2))
	(object_destroy x10_warthog_2)
	(object_destroy hog_2_driver)
)

(script dormant x10_hog_3
	(object_create_anew x10_warthog_3)
	(object_create_anew hog_3_driver)
	(vehicle_load_magic x10_warthog_3 "W-driver" hog_3_driver)
	(object_teleport x10_warthog_3 x10_hog_3_base)
	(recording_play x10_warthog_3 x10_hog_3_run)
	(sleep (recording_time x10_warthog_3))
	(object_destroy x10_warthog_3)
	(object_destroy hog_3_driver)
)

(script dormant tank_run_1
	(object_create_anew x10_run_1a)
	(object_create_anew x10_run_1b)
	(object_create_anew x10_run_1c)
	(object_create_anew x10_run_1d)
	(object_teleport x10_run_1a x10_run_1a_base)
	(object_teleport x10_run_1b x10_run_1b_base)
	(object_teleport x10_run_1c x10_run_1a_base)
	(object_teleport x10_run_1d x10_run_1b_base)
	(recording_play_and_delete x10_run_1a x10_run_1a)
	(recording_play_and_delete x10_run_1b x10_run_1b)
	(sleep 60)
	(recording_play_and_delete x10_run_1c x10_run_1a)
	(recording_play_and_delete x10_run_1d x10_run_1b)
)

(script dormant tank_run_2
	(object_create_anew x10_run_2a)
	(object_create_anew x10_run_2b)
	(object_create_anew x10_run_2c)
	(object_create_anew x10_run_2d)
	(object_teleport x10_run_2a x10_run_2a_base)
	(object_teleport x10_run_2b x10_run_2b_base)
	(object_teleport x10_run_2c x10_run_2a_base)
	(object_teleport x10_run_2d x10_run_2b_base)
	(recording_play_and_delete x10_run_2a x10_run_2b)
	(recording_play_and_delete x10_run_2b x10_run_2a)
	(sleep 60)
	(recording_play_and_delete x10_run_2c x10_run_2b)
	(recording_play_and_delete x10_run_2d x10_run_2a)
)

(script static void dressing_1
	(object_create_anew_containing x10_rack_1)
;	(object_create_anew x10_rack_1a)
;	(object_create_anew x10_rack_1b)
	(object_create_anew_containing x10_oxy_1)
;	(object_create_anew x10_oxy_1a)
;	(object_create_anew x10_oxy_1b)
;	(object_create_anew x10_oxy_1c)
	(object_create_anew x10_warthog_1a)
	(object_create_anew x10_warthog_1b)
	(object_create_anew x10_warthog_1c)
	(object_create_anew x10_warthog_1d)
	(object_create_anew x10_tank_1a)
)

(script static void dressing_1_cleanup
	(object_destroy_containing x10_rack_1)
;	(object_destroy x10_rack_1a)
;	(object_destroy x10_rack_1b)
	(object_destroy_containing x10_oxy_1)
;	(object_destroy x10_oxy_1a)
;	(object_destroy x10_oxy_1b)
;	(object_destroy x10_oxy_1c)
	(object_destroy x10_warthog_1a)
	(object_destroy x10_warthog_1b)
	(object_destroy x10_warthog_1c)
	(object_destroy x10_warthog_1d)
)

(script static void dressing_2
	(object_create_anew_containing x10_oxy_2)
;	(object_create_anew x10_oxy_2a)
;	(object_create_anew x10_oxy_2b)
;	(object_create_anew x10_oxy_2c)
	(object_create_anew_containing x10_warthog_2)
;	(object_create_anew x10_warthog_2a)
;	(object_create_anew x10_warthog_2b)
	(object_create_anew x10_tank_2a)
)

(script static void dressing_2_cleanup
	(object_destroy_containing x10_oxy_2)
;	(object_destroy x10_oxy_2a)
;	(object_destroy x10_oxy_2b)
;	(object_destroy x10_oxy_2c)
	(object_destroy_containing x10_warthog_2)
;	(object_destroy x10_warthog_2a)
;	(object_destroy x10_warthog_2b)
	(object_destroy x10_tank_2a)
)

(script static void dressing_3
	(object_create_anew_containing x10_rack_3)
;	(object_create_anew x10_rack_3a)
;	(object_create_anew x10_rack_3b)
;	(object_create_anew x10_rack_3c)
	(object_create_anew x10_pel_3a)
	(object_create_anew_containing x10_tank_3)
;	(object_create_anew x10_tank_3a)
;	(object_create_anew x10_tank_3b)
)

(script static void dressing_3_cleanup
	(object_destroy_containing x10_rack_3)
;	(object_destroy x10_rack_3a)
;	(object_destroy x10_rack_3b)
;	(object_destroy x10_rack_3c)
	(object_destroy x10_pel_3a)
	(object_destroy_containing x10_tank_3)
;	(object_destroy x10_tank_3a)
;	(object_destroy x10_tank_3b)
)

(script dormant x10_hog_4
	(object_create_anew x10_warthog_2)
	(object_create_anew hog_2_driver)
	(vehicle_load_magic x10_warthog_2 "W-driver" hog_2_driver)
	(object_teleport x10_warthog_2 x10_hog_4_base)
	(recording_play x10_warthog_2 x10_hog_4_run)
	(sleep (recording_time x10_warthog_2))
	(object_destroy x10_warthog_2)
	(object_destroy hog_2_driver)
)

(script dormant x10_hog_5
	(object_create_anew x10_warthog_3)
	(object_create_anew hog_3_driver)
	(vehicle_load_magic x10_warthog_3 "W-driver" hog_3_driver)
	(object_teleport x10_warthog_3 x10_hog_5_base)
	(recording_play x10_warthog_3 x10_hog_5_run)
	(sleep (recording_time x10_warthog_3))
	(object_destroy x10_warthog_3)
	(object_destroy hog_3_driver)
)

(script dormant x10_tankpel
	(object_create_anew x10_pelican_3)
	(object_create_anew x10_tank_3a)
	(object_teleport x10_tank_3a x10_tank_1_base)
	(object_teleport x10_pelican_3 x10_pelican_3_base)
	(recording_play x10_tank_3a x10_tank_1_move)
	(recording_play x10_pelican_3 x10_pelican_3_drop)
	(sleep (recording_time x10_pelican_3))
	(object_destroy x10_pelican_3)
	(object_destroy x10_tank_3a)
)

(script static void hangar_1_cleanup_a
	(object_destroy_containing hangar_marine)
;	(object_destroy hangar_marine_1)
;	(object_destroy hangar_marine_2)
;	(object_destroy hangar_marine_3)
;	(object_destroy hangar_marine_4)
	(object_destroy_containing baton)
;	(object_destroy baton_r)
;	(object_destroy baton_l)
)

(script static void hangar_1_cleanup_b
	(object_destroy_containing scenery)
;	(object_destroy scenery_pelican_1)
;	(object_destroy scenery_pelican_2)
;	(object_destroy scenery_bomber)
	(object_destroy_containing x10_pelican)
;	(object_destroy x10_pelican_1)
;	(object_destroy x10_pelican_2)
)

(script static void hangar_1

	(sound_class_set_gain device_machinery 1 0)

	(render_lights off)

	(dressing_3)
	
	(object_create_anew x10_pelican_1)
	(object_create_anew x10_pelican_2)
	(object_create_anew x10_scorpion_1)
	(object_create_anew x10_scorpion_2)
	(object_create_anew hangar_marine_1)
	(object_create_anew hangar_marine_2)
	(object_create_anew hangar_marine_3)
	(object_create_anew hangar_marine_4)
	(object_create_anew scenery_pelican_1)
	(object_create_anew scenery_pelican_2)
	(object_create_anew scenery_bomber)
	(object_create_anew baton_r)
	(object_create_anew baton_l)
	
	(object_beautify hangar_marine_1 true)
	
	(unit_set_seat hangar_marine_1 alert)
	
	(object_pvs_activate scenery_bomber)
	
	(camera_set baton_1 0)
	(camera_set baton_2 120)
	
	(object_teleport hangar_marine_1 hangar_marine_1_base)
	(recording_play_and_delete hangar_marine_1 hangar_marine_1_walk)
	
	(object_teleport hangar_marine_3 hangar_marine_3_base)
	(recording_play_and_delete hangar_marine_3 hangar_marine_3_walk)
	
	(object_teleport hangar_marine_4 hangar_marine_4_base)
	(custom_animation hangar_marine_4 cinematics\animations\marines\x10\x10 standing_prep2 true)
	
	(recording_play x10_scorpion_1 scorpion_idle)
	(recording_play x10_scorpion_2 scorpion_idle)
	
	(objects_attach hangar_marine_2 "right hand" baton_r "right hand baton")
	(objects_attach hangar_marine_2 "left hand" baton_l "left hand baton")
	
	(custom_animation hangar_marine_2 cinematics\animations\marines\x10_normal\x10_normal X10GroundCrew true)
	
	(fade_in .8 0 1 30)
	
	(sound_looping_start sound\sinomatixx\x10_music02 none 1)
	
	(sleep 120)
	
	(camera_set hangar_1a 0)
	(camera_set hangar_1c 500)
	
	(sound_looping_start sound\sinomatixx_foley\x10_foley2 none 1)
	
	(sound_impulse_start sound\dialog\x10\cor09 none 1)
	
	(object_teleport x10_pelican_1 x10_pelican_1)
	(recording_play_and_delete x10_pelican_1 x10_pelican_1_out)
	
	(sleep 100)
	
	(wake x10_tankpel)
	
	(sleep 125)
	
	(wake x10_hog_2)
	(wake x10_hog_3)
	
	(object_teleport x10_pelican_2 x10_pelican_2)
	(recording_play_and_delete x10_pelican_2 x10_pelican_2_in)
	
	(sleep 100)
	
	(sleep (- (camera_time) 60))
	
	(wake x10_hog_1)
	
	(sleep (camera_time))
	
	(sound_impulse_start sound\dialog\x10\cor10 none 1)
	
	(camera_set hangar_2a 0)
	(camera_set hangar_2b 300)
	
	(hangar_1_cleanup_a)
	(dressing_3_cleanup)
	(dressing_2)
	(dressing_1)
	
	(wake tank_run_1)
	
	(sleep 100)
	
	(wake tank_run_2)
	
	(sleep 200)
)

(script static void pep_run

	(sound_impulse_start sound\dialog\x10\cor11 none 1)

	(recording_kill johnson)
	(unit_stop_custom_animation johnson)
	
	(camera_set run_cu_1a 0)
	(camera_set run_cu_1b 250)
	
	(object_destroy grunt_5)
	(object_destroy grunt_6)
	(object_destroy grunt_7)
	(object_destroy grunt_8)

	(object_create_anew grunt_10)
	(object_create_anew grunt_11)
	(object_create_anew grunt_1)
	(object_create_anew grunt_2)
	(object_create_anew grunt_3)
	(object_create_anew grunt_4)
	
	(object_teleport grunt_10 grunt_10_pep_run)
	(object_teleport grunt_11 grunt_11_pep_run)
	(object_teleport grunt_1 grunt_1_pep_run)
	(object_teleport grunt_2 grunt_2_pep_run)
	(object_teleport grunt_3 grunt_3_pep_run)
	(object_teleport grunt_4 grunt_4_pep_run)
	
	(recording_play grunt_10 pep_run)
	(sleep 30)
	(recording_play grunt_11 pep_run)
	(sleep 15)
	(recording_play grunt_1 pep_run)
	(sleep 30)
	(recording_play grunt_2 pep_run)
	(sleep 45)
	(recording_play grunt_3 pep_run)
	(sleep 30)
	(recording_play grunt_4 pep_run)
	
	(sleep (- (camera_time) 30))
)

(script static void hangar_2_cleanup
	(object_destroy johnson)
	(object_destroy_containing grunt)
;	(object_destroy grunt_1)
;	(object_destroy grunt_2)
;	(object_destroy grunt_3)
;	(object_destroy grunt_4)
;	(object_destroy grunt_5)
;	(object_destroy grunt_6)
;	(object_destroy grunt_7)
;	(object_destroy grunt_8)
;	(object_destroy grunt_9)
;	(object_destroy grunt_10)
;	(object_destroy grunt_11)
;	(object_destroy grunt_12)
)
	
(script static void hangar_2

	(object_destroy x10_scorpion_1)
	(object_destroy x10_scorpion_2)

	(render_lights on)

	(hangar_1_cleanup_b)

	(object_pvs_activate johnson)
	
	(object_create_anew johnson)
	(object_create_anew grunt_1)
	(object_create_anew grunt_2a)
	(object_create_anew grunt_3a)
	(object_create_anew grunt_4)
	(object_create_anew grunt_5)
	(object_create_anew grunt_6)
	(object_create_anew grunt_7)
	(object_create_anew grunt_8)
	
	(object_create_anew x10_hangar_light_1)
	(object_create_anew x10_hangar_light_2)
	
	(object_teleport johnson johnson_base)
	(object_teleport grunt_1 grunt_1_base)
	(object_teleport grunt_2a grunt_2_base)
	(object_teleport grunt_3a grunt_3_base)
	(object_teleport grunt_4 grunt_4_base)
	(object_teleport grunt_5 grunt_5_base)
	(object_teleport grunt_6 grunt_6_base)
	(object_teleport grunt_7 grunt_7_base)
	(object_teleport grunt_8 grunt_8_base)
	
	(custom_animation grunt_2a cinematics\animations\marines\x10\x10 sitting_prep1 true)
	(custom_animation grunt_3a cinematics\animations\marines\x10\x10 sitting_prep2 true)
	(custom_animation grunt_4 cinematics\animations\marines\x10\x10 standing_prep2 true)
	(custom_animation grunt_6 cinematics\animations\marines\x10\x10 standing_prep2 true)
	(custom_animation grunt_8 cinematics\animations\marines\x10\x10 standing_prep2 true)

	(recording_play grunt_1 grunt_idle_1)
	(recording_play grunt_5 grunt_idle_1)
	(recording_play grunt_7 grunt_idle_1)
	
	(unit_set_seat johnson alert)
	
	(game_skip_ticks 5)
	
	(camera_set hangar_3a 0)
	
	(recording_play johnson johnson_enter)
	
	(sleep 60)
	
	(camera_set hangar_3b 90)
	(sleep 90)

	(camera_set you_heard_1a 0)
	(camera_set you_heard_1b 90)
	
	(recording_kill johnson)
	
	(custom_animation johnson cinematics\animations\marines\x10\x10 "sarge_you heard the lady" true)
	
	(sound_impulse_start sound\dialog\x10\sgt01 johnson 1)
;	(print "johnson: You heard the lady. Move like you got a purpose!")
	(sleep (sound_impulse_time sound\dialog\x10\sgt01))
	
	(object_destroy grunt_2a)
	(object_destroy grunt_3a)
	
	(pep_run)
	
	(recording_kill grunt_1)
	(recording_kill grunt_2)
	(recording_kill grunt_3)
	(recording_kill grunt_4)
	(recording_kill grunt_5)
	(recording_kill grunt_6)
	(recording_kill grunt_7)
	(recording_kill grunt_8)
	(recording_kill grunt_9)
	(recording_kill grunt_10)
	(recording_kill grunt_11)
	(recording_kill grunt_12)
	
	(object_create_anew_containing grunt)
;	(object_create_anew grunt_1)
;	(object_create_anew grunt_2)
;	(object_create_anew grunt_3)
;	(object_create_anew grunt_4)
;	(object_create_anew grunt_5)
;	(object_create_anew grunt_6)
;	(object_create_anew grunt_7)
;	(object_create_anew grunt_8)
;	(object_create_anew grunt_9)
;	(object_create_anew grunt_10)
;	(object_create_anew grunt_11)
;	(object_create_anew grunt_12)
	
	(object_teleport grunt_1 grunt_1_pep)
	(object_teleport grunt_2 grunt_2_pep)
	(object_teleport grunt_3 grunt_3_pep)
	(object_teleport grunt_4 grunt_4_pep)
	(object_teleport grunt_5 grunt_5_pep)
	(object_teleport grunt_6 grunt_6_pep)
	(object_teleport grunt_7 grunt_7_pep)
	(object_teleport grunt_8 grunt_8_pep)
	(object_teleport grunt_9 grunt_9_pep)
	(object_teleport grunt_10 grunt_10_pep)
	(object_teleport grunt_11 grunt_11_pep)
	(object_teleport grunt_12 grunt_12_pep)
	
	(unit_set_seat grunt_1 alert)
	(unit_set_seat grunt_2 alert)
	(unit_set_seat grunt_3 alert)
	(unit_set_seat grunt_4 alert)
	(unit_set_seat grunt_5 alert)
	(unit_set_seat grunt_6 alert)
	(unit_set_seat grunt_7 alert)
	(unit_set_seat grunt_8 alert)
	(unit_set_seat grunt_9 alert)
	(unit_set_seat grunt_10 alert)
	(unit_set_seat grunt_11 alert)
	(unit_set_seat grunt_12 alert)
	
	(game_skip_ticks 5)
	
;	GLORIOUS JOHNSON FLAVOR

	(if (= "easy" (game_difficulty_get_real))
	(begin
	
		(camera_set pep_run_2a 0)
		(camera_set pep_run_2b 200)
		
		(object_teleport johnson johnson_pep_easy_base)
		(recording_play johnson johnson_pep_easy)
		
		(sound_impulse_start sound\dialog\x10\sgt05g johnson 1)
		
		(sleep (sound_impulse_time sound\dialog\x10\sgt05g))
		
		(recording_kill johnson)
		(object_teleport johnson johnson_right_base)
		(camera_set johnson_right_1a 0)
		(camera_set johnson_right_zoom 30)
		(custom_animation johnson cinematics\animations\marines\x10\x10 "sarge_am I right marines" true)
	
		(sound_impulse_start sound\dialog\x10\sgt05h johnson 1)
	;	(print "johnson: Am I right, marines?")
		(sleep (sound_impulse_time sound\dialog\x10\sgt05h))
	)
	)
	
	(if (= "normal" (game_difficulty_get_real))
	(begin
	
		(camera_set pep_run_1a 0)
		(camera_set pep_run_1b 200)
		
		(object_teleport johnson johnson_pep_base)
		(recording_play johnson johnson_pep_5a)
		
		(sound_impulse_start sound\dialog\x10\sgt05 johnson 1)
		
		(sleep (camera_time))
		
		(camera_set pep_run_2a 0)
		(camera_set pep_run_2b 250)
		
		(sleep (sound_impulse_time sound\dialog\x10\sgt05))
		
		(recording_kill johnson)
		(object_teleport johnson johnson_right_base)
		(camera_set johnson_right_1a 0)
		(camera_set johnson_right_zoom 30)
		(custom_animation johnson cinematics\animations\marines\x10\x10 "sarge_am I right marines" true)
	
		(sound_impulse_start sound\dialog\x10\sgt05b johnson 1)
	;	(print "johnson: Am I right, marines?")
		(sleep (sound_impulse_time sound\dialog\x10\sgt05b))
	)
	)
	
	(if (= "hard" (game_difficulty_get_real))
	(begin
		(camera_set pep_run_1a 0)
		(camera_set pep_run_1b 200)
	
		(object_teleport johnson johnson_pep_base)
		(recording_play johnson johnson_pep_5a)
		
		(sound_impulse_start sound\dialog\x10\sgt05c johnson 1)
		
		(sleep (camera_time))
		
		(camera_set pep_run_2a 0)
		(camera_set pep_run_2b 250)
		
		(sleep (sound_impulse_time sound\dialog\x10\sgt05c))
		
		(recording_kill johnson)
		(object_teleport johnson johnson_right_base)
		(camera_set johnson_right_1a 0)
		(camera_set johnson_right_zoom 30)
		(custom_animation johnson cinematics\animations\marines\x10\x10 "sarge_am I right marines" true)
	
		(sound_impulse_start sound\dialog\x10\sgt05d johnson 1)
;		(print "johnson: Am I right, marines?")
		(sleep (sound_impulse_time sound\dialog\x10\sgt05d))
	)
	)
	
	(if (= "impossible" (game_difficulty_get_real))
	(begin
		(camera_set pep_run_1a 0)
		(camera_set pep_run_1b 300)
	
		(object_teleport johnson johnson_pep_base)
		(recording_play johnson johnson_pep_5e)
	
		(sound_impulse_start sound\dialog\x10\sgt05e johnson 1)
		
		(sleep (camera_time))
		
		(camera_set pep_run_2a 0)
		(camera_set johnson_close_impossible 300)
		
		(sleep (sound_impulse_time sound\dialog\x10\sgt05e))
		
		(recording_kill johnson)
		(object_teleport johnson johnson_right_base)
		(camera_set johnson_right_1a 0)
		(camera_set johnson_right_zoom 30)
		(custom_animation johnson cinematics\animations\marines\x10\x10 "sarge_am I right marines" true)
		(wake x10_hog_4)
		(sound_impulse_start sound\dialog\x10\sgt05f johnson 1)
	;	(print "johnson: Am I right, marines?")
		(sleep (sound_impulse_time sound\dialog\x10\sgt05f))
	)
	)
	
	(wake x10_hog_4)
	
	(camera_set johnson_right_1b 0)
	(camera_set johnson_right_1c 60)
	
	(sound_impulse_start sound\dialog\x10\mar01 grunt_1 1)
	(sound_impulse_start sound\dialog\x10\mar01 grunt_2 1)
	(sound_impulse_start sound\dialog\x10\mar01 grunt_3 1)	
	(sound_impulse_start sound\dialog\x10\mar01 grunt_4 1)
	(sound_impulse_start sound\dialog\x10\mar01 grunt_5 1)
	(sound_impulse_start sound\dialog\x10\mar01 grunt_6 1)
	(sound_impulse_start sound\dialog\x10\mar01 grunt_7 1)
	(sound_impulse_start sound\dialog\x10\mar01 grunt_8 1)
	(sleep (sound_impulse_time sound\dialog\x10\mar01))
	
	(camera_set johnson_right_2a 0)
	(camera_set johnson_right_2b 120)
	
	(unit_stop_custom_animation johnson)
	(custom_animation johnson cinematics\animations\marines\x10\x10 "sarge_damn right i am" false)

	(sound_impulse_start sound\dialog\x10\sgt06 johnson 1)
;	(print "johnson: Mmm-hmm. Damn right I am. Now move it out! Double-time!")
	(sleep (sound_impulse_time sound\dialog\x10\sgt06))
	
	(object_destroy grunt_9)
	(object_destroy grunt_10)
	(object_destroy grunt_11)
	(object_destroy grunt_12)
	
	(unit_stop_custom_animation johnson)
	(recording_kill johnson)
	(recording_kill grunt_1)
	(recording_kill grunt_2)
	(recording_kill grunt_3)
	(recording_kill grunt_4)
	(recording_kill grunt_5)
	(recording_kill grunt_6)
	(recording_kill grunt_7)
	(recording_kill grunt_8)
	
	(unit_set_seat grunt_1 combat)
	(unit_set_seat grunt_2 combat)
	(unit_set_seat grunt_3 combat)
	(unit_set_seat grunt_4 combat)
	(unit_set_seat grunt_5 combat)
	(unit_set_seat grunt_6 combat)
	(unit_set_seat grunt_7 combat)
	(unit_set_seat grunt_8 combat)
	
	(recording_play grunt_1 grunt_1_run)
	(recording_play grunt_2 grunt_2_run)
	(recording_play grunt_3 grunt_3_run)
	(recording_play grunt_4 grunt_4_run)
	(recording_play grunt_5 grunt_5_run)
	(recording_play grunt_6 grunt_6_run)
	(recording_play grunt_7 grunt_7_run)
	(recording_play grunt_8 grunt_8_run)
	(recording_play johnson johnson_saunter)
	
	(object_destroy x10_scorpion_1)
	(object_destroy x10_scorpion_2)
	
	(camera_set pep_over_1a 0)
	
	(sound_looping_start sound\sinomatixx\x10_music03 none 1)
	
	(camera_set pep_over_1c 200)
	
	(sound_impulse_start sound\dialog\x10\cor12 none 1)
;	(print "cortana: Attention, all personnel. We are re-engaging the enemy. External and internal contact imminent.")
	
	(sleep 100)
	(camera_set pep_over_1b 200)

	(sleep (recording_time johnson))

	(custom_animation johnson cinematics\animations\marines\x10\x10 "sarge_todays your lucky day" true)
	
	(wake x10_hog_5)

	(sound_impulse_start sound\dialog\x10\sgt07 johnson 1)
;	(print "johnson: All you greenhorns who wanted to see Covenant up close--")
	(sleep (sound_impulse_time sound\dialog\x10\sgt07))
	
	(object_destroy_containing grunt)
;	(object_destroy grunt_1)
;	(object_destroy grunt_2)
;	(object_destroy grunt_3)
;	(object_destroy grunt_4)
;	(object_destroy grunt_5)
;	(object_destroy grunt_6)
;	(object_destroy grunt_7)
;	(object_destroy grunt_8)

	(sound_impulse_start sound\dialog\x10\sgt08 johnson 1)
;	(print "johnson: --this is gonna be your lucky day.")
	(sleep (sound_impulse_time sound\dialog\x10\sgt08))
	
	(sound_looping_start sound\sinomatixx_foley\x10_foley3 none 1)
	
	(fade_out 0 0 0 15)
	(sleep 15)
	
	(dressing_1_cleanup)
	(dressing_2_cleanup)
	(hangar_1_cleanup_a)
	(hangar_1_cleanup_b)
	(hangar_2_cleanup)
)
	
;(script static void platoon_run
;	(object_teleport grunt_1 grunt_1_pep)
;	(object_teleport grunt_2 grunt_2_pep)
;	(object_teleport grunt_3 grunt_3_pep)
;	(object_teleport grunt_4 grunt_4_pep)
;	(object_teleport grunt_5 grunt_5_pep)
;	(object_teleport grunt_6 grunt_6_pep)
;	(object_teleport grunt_7 grunt_7_pep)
;	(object_teleport grunt_8 grunt_8_pep)
;	(recording_play grunt_1 grunt_1_run)
;	(recording_play grunt_2 grunt_2_run)
;	(recording_play grunt_3 grunt_3_run)
;	(recording_play grunt_4 grunt_4_run)
;	(recording_play grunt_5 grunt_5_run)
;	(recording_play grunt_6 grunt_6_run)
;	(recording_play grunt_7 grunt_7_run)
;	(recording_play grunt_8 grunt_8_run)
;)

(script static void cryo

	(switch_bsp 0)
	
	(camera_set screen_ecu_1a 0)
	(camera_set screen_ecu_1b 120)
	
	(sound_looping_start sound\sinomatixx\x10_music04 none 1)
	
	(fade_in 0 0 0 15)

	(sleep 15)
	
	(object_create_anew casket_1)
	
	(sleep 60)
	
	(object_destroy casket_1)
	(object_create_anew casket_2)
	
	(sleep 60)
	
	(object_create_anew technician)
	(object_create_anew assistant)
	
	(object_beautify technician true)
	(object_beautify assistant true)

	(object_pvs_activate technician)
	
	(object_teleport assistant asst_base)
	(custom_animation assistant cinematics\animations\crewman\x10\x10 cryo_assistant true)
	
	(object_teleport technician tech_base)
	(custom_animation technician cinematics\animations\crewman\x10\x10 cryo_technician true)
	(sleep 5)
	
	(camera_set assistant_react 0)

	(sound_impulse_start sound\dialog\x10\ass01 assistant 1)
;	(print "Assistant: Whoa. Sir?")
	(sleep (sound_impulse_time sound\dialog\x10\ass01))
	
	(sleep 30)
	
	(sound_impulse_start sound\dialog\x10\tec01 technician 1)
;	(print "Tech: Right. Let's thaw him out.")
	(sleep (sound_impulse_time sound\dialog\x10\tec01))
	
	(camera_set keyboard_med 0)
	
	(object_create_anew x10_tube)
	(object_create_anew x10_chief)
	
	(objects_attach x10_tube "driver" x10_chief "")
	(custom_animation x10_chief characters\cyborg\cyborg "ct-driver unarmed idle" true)
	
	(sound_impulse_start sound\dialog\x10\ass02 assistant 1)
;	(print "Assistant: OK. Bringing low-level systems online. His vitals look good.")
	(sleep (- (sound_impulse_time sound\dialog\x10\ass02) 60))
	
	(camera_set booth_hi_1 0)
	(camera_set booth_hi_2 200)
	
	(sound_impulse_start sound\dialog\x10\ass03 assistant 1)
;	(print "Assistant: Cracking the case in 30 seconds.")
	(sleep (camera_time))
	
	(camera_set tube_1a 0)
	(camera_set tube_1b 300)
	
	(sleep 90)
	
	(object_create_anew_containing x10_cryo_steam)
;	(object_create_anew x10_cryo_steam_1a)
;	(object_create_anew x10_cryo_steam_1b)
;	(object_create_anew x10_cryo_steam_2a)
;	(object_create_anew x10_cryo_steam_2b)
	
	(sound_impulse_start sound\dialog\x10\ass04 none 1)
;	(print "Assistant: He's hot! Blowing the pins in 5.")
	
	(sleep (camera_time))

	(fade_out 1 1 1 15)
	(sleep 15)
	
	(object_destroy assistant)
	(object_destroy technician)
	(object_destroy x10_chief)
	(object_destroy x10_tube)
	(object_destroy casket_1)
	(object_destroy casket_2)

	(object_destroy_containing x10_cryo_steam)
;	(object_destroy x10_cryo_steam_1a)
;	(object_destroy x10_cryo_steam_1b)
;	(object_destroy x10_cryo_steam_2a)
;	(object_destroy x10_cryo_steam_2b)
	
	(camera_control off)
	(cinematic_stop)
	
	(unit_suspended (player0) false)
	(unit_suspended (player1) false)
	
	(object_pvs_activate none)
	)
	
(script static void hangar_total
	(hangar_1)
	(hangar_2)
)	
	
(script static void hangar_cryo
	(hangar_1)
	(hangar_2)
	(cryo)
)

(script static void x10_cleanup
	(object_destroy hangar_marine_1)
	(object_destroy hangar_marine_2)
	(object_destroy hog_1_driver)
	(object_destroy hog_1_gunner)
	(object_destroy hog_2_driver)
	(object_destroy hog_3_driver)
	(object_destroy x10_pelican_1)
	(object_destroy x10_pelican_2)
	(object_destroy x10_warthog_1)
	(object_destroy x10_scorpion_1)
	(object_destroy x10_scorpion_2)
	(object_destroy x10_warthog_2)
	(object_destroy x10_warthog_3)
	(object_destroy x10_warthog_1a)
	(object_destroy x10_warthog_1b)
	(object_destroy x10_warthog_1c)
	(object_destroy x10_warthog_1d)
	(object_destroy x10_warthog_2a)
	(object_destroy x10_warthog_2b)
	(object_destroy x10_tank_1a)
	(object_destroy x10_tank_2a)
	(object_destroy x10_tank_3a)
	(object_destroy x10_tank_3b)
	(object_destroy x10_pelican_3)
	(object_destroy scenery_bomber)
	)

(script static void x10

	(sound_class_set_gain device_machinery 0 0)

	(fade_out 0 0 0 0)

	(object_teleport (player0) player0_x10_base)
	(object_teleport (player1) player1_x10_base)
	
	(unit_suspended (player0) true)
	(unit_suspended (player1) true)

	(switch_bsp 7)

	(object_type_predict levels\a10\devices\space_battle\space_battle)
	(object_type_predict vehicles\fighterbomber\fighterbomber)
	(object_type_predict characters\captain\captain)
	(object_type_predict characters\cortana\cortana)
	(object_type_predict  "levels\a10\devices\chairs\chair pilot\chair pilot")
	(object_type_predict  "levels\a10\devices\chairs\chair pod\chair pod")
	
	(sound_looping_start sound\sinomatixx\x10_music01 none 1)
	
	(cinematic_start)
	(camera_control on)
	
	(sleep 60)
	
;	BEGIN "AUTUMN GLORY 1" SCENE
	(autumn_glory_1)
	
;	BEGIN "AUTUMN GLORY 2" SCENE
	(autumn_glory_2)
	
	(fade_out 0 0 0 0)
	
	(switch_bsp 1)
	
;	BEGIN "BRIDGE" SCENE
	
	(bridge)
	
	(switch_bsp 8)
	
	(cinematic_set_near_clip_distance .0625)
	
;	(object_destroy x10_display)
	
;	BEGIN MRIPTING
	
	(if (= "easy" (game_difficulty_get_real))
	(begin
		(hangar_cryo)
	)
	)

	(if (= "normal" (game_difficulty_get_real))
	(begin
		(hangar_cryo)
	)
	)
	
	(if (= "hard" (game_difficulty_get_real))
	(begin
		(hangar_cryo)
	)
	)
	
	(if (= "impossible" (game_difficulty_get_real))
	(begin
		(hangar_cryo)
	)
	)

	(x10_cleanup)
	(x10_chair_cleanup)
	(bomber_cleanup)
)
