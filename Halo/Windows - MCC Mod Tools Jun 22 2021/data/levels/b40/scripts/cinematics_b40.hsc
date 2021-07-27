;	b40 Cinematics

(script dormant pelican_up
	
	(object_destroy insertion_pelican)
	(object_create insertion_pelican)
	(object_teleport insertion_pelican insertion_pelican_1)
	(recording_play insertion_pelican insertion_pelican_in)
	
	(unit_enter_vehicle (player0) insertion_pelican "P-riderLF")
	(unit_enter_vehicle (player1) insertion_pelican "P-riderRF")
)

(script dormant intro_dialogue

	(sound_impulse_start sound\dialog\b40\B40_insert_010_Pilot none 1)
	(print "Pilot: [Radio] This is as far as I can go.")
	(sleep (sound_impulse_time sound\dialog\b40\B40_insert_010_Pilot))
	
	(sound_impulse_start sound\dialog\b40\B40_insert_020_Cortana none 1)
	(print "Cortana: [Radio] Roger that. We'll be able to find our way to the control center from here.")
	(sleep (sound_impulse_time sound\dialog\b40\B40_insert_020_Cortana))
	
	(sound_impulse_start sound\dialog\b40\B40_insert_020_Pilot none 1)
	(print "Pilot: [Radio] Good Luck. Foehammer out.")
	(sleep (sound_impulse_time sound\dialog\b40\B40_insert_020_Pilot))
	
	(sound_class_set_gain vehicle 1 6)
)

(script static void cutscene_insertion_a

	(sound_looping_start sound\sinomatixx_foley\b40_insertion_foley none 1)
	(sound_class_set_gain vehicle .3 0)

	(objects_predict insertion_pelican)
	(objects_predict awake_1)
	
	(object_beautify awake_1 true)
	
	(fade_out 0 0 0 0)
	
	(switch_bsp 3)
	
	(object_teleport (player0) player0_insertion_safe)
	(object_teleport (player1) player1_insertion_safe)
	
	(cinematic_start)
	(show_hud 0)
	(camera_control on)

	(camera_set insertion_1a 0)
	
	(fade_in 0 0 0 60)
	
	(object_destroy awake_1)
	(object_destroy sleepy_1)
	(object_destroy sleepy_1)
	(object_create awake_1)
	(object_create sleepy_1)
	(object_create sleepy_2)
	
	(object_teleport awake_1 grunt_walk_1)
	
	(object_pvs_activate awake_1)
	
	(camera_set insertion_1b 300)
	
	(unit_set_seat awake_1 crouch)
	(recording_play awake_1 grunt_walk_1)
	
	(sleep 300)
	
	(cinematic_set_near_clip_distance .01)
	
	(camera_set gah_1a 0)
	(camera_set gah_1b 120)
	
	(wake pelican_up)
	
	(recording_kill awake_1)
	(object_teleport awake_1 grunt_panic_base)
	(custom_animation awake_1 cinematics\animations\grunt\level_specific\b40\b40 "b40_runaway" false)
	
	(sleep 150)
	
	(camera_set sleepers_rev_1a 0)
	(camera_set sleepers_rev_1b 120)
	(sleep 60)
	(camera_set sleepers_rev_1c 60)
	
	(sleep (camera_time))
	
	(recording_kill awake_1)
	
	(object_destroy awake_1)
	(object_destroy sleepy_1)
	(object_destroy sleepy_2)
)

(script static void cutscene_insertion_b
	(object_pvs_activate none)
	
	(fade_in 1 1 1 60)
	(camera_control off)
	
;	(object_set_facing (player0) initial_facing)
;	(object_set_facing (player1) initial_facing)
	
	(wake intro_dialogue)

	(sleep (recording_time insertion_pelican))
	
	(vehicle_hover insertion_pelican 1)
	(unit_exit_vehicle (player0))
	(unit_exit_vehicle (player1))
	(cinematic_stop)
	(show_hud 1)
	
	(sleep 60)
	(unit_set_enterable_by_player insertion_pelican false)
	
;	(set global_mission_start true)
;	(sleep 30)
	(vehicle_unload insertion_pelican "rider")
	
;	(sleep_until (not (volume_test_objects mission_start (players))))
	(sleep 30)
	(vehicle_hover insertion_pelican 0)
	(recording_play_and_delete insertion_pelican insertion_pelican_out)
)

(script static void grunt_test
(object_teleport awake_1 grunt_panic_base)
(custom_animation awake_1 cinematics\animations\grunt\level_specific\b40\b40 "b40_runaway" true)
)

(script static void pelican
	
	(object_create insertion_pelican)
	(object_teleport insertion_pelican insertion_pelican_1)
	(recording_play insertion_pelican insertion_pelican_in)
	(sleep (recording_time insertion_pelican))
	
	(unit_enter_vehicle (player0) insertion_pelican "P-riderLF")
	(unit_enter_vehicle (player1) insertion_pelican "P-riderRF")
	
	(vehicle_hover insertion_pelican 1)
	(unit_exit_vehicle (player0))
	(unit_exit_vehicle (player1))
	(cinematic_stop)
	(show_hud 1)
;	(set global_mission_start true)
	(sleep 30)
	(vehicle_unload insertion_pelican "rider")
	
;	(sleep_until (not (volume_test_objects mission_start (players))))
	(sleep 120)
	(vehicle_hover insertion_pelican 0)
	(recording_play_and_delete insertion_pelican insertion_pelican_out)
)

(script dormant extraction_music
	(sleep 40)
	(sound_looping_start sound\sinomatixx_music\b40_extraction_music none 1)
)

(script static void cutscene_extraction

	(wake extraction_music)

	(objects_predict chief)
	(objects_predict cortana)
	
	(object_beautify chief true)

;	(fade_out 1 1 1 30)
;	(sleep 30) 
	
	(rasterizer_model_ambient_reflection_tint 1 1 1 1)
	
	(cinematic_start)
	(camera_control on)

	(switch_bsp 2)
	(object_teleport (player0) player0_extraction_safe)
	(object_teleport (player1) player1_extraction_safe)
	
	(camera_set chief_zoom_1a 0)
	(camera_set chief_zoom_1b 180)

	(object_destroy chief)
	(object_destroy rifle)
	
	(object_create chief)
	(object_create rifle)
	
	(unit_set_seat chief alert)
	
	(object_teleport chief chief_walk_1_start)
	(object_beautify chief true)
	(object_pvs_activate chief)
	(objects_attach chief "right hand" rifle "")
	
	(recording_play chief chief_walk_1)
	(sleep 5)
	
	(fade_in 1 1 1 30)
	(sleep 180)
		
	(sound_impulse_start sound\dialog\b40\B40_extract_010_CORTANA none 1)
	(print "Cortana: This is it. Halo's Control Center.")
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_010_CORTANA))
	
	(camera_set chief_walk_rev_1b 0)
	(camera_set chief_walk_rev_1a 180)
	(sleep 180)

	(camera_set control_crane_1a 0)
	(camera_set control_crane_1b 500)
	(sleep 450)
	
	(camera_set cortana_insert_1a 0)
	(camera_set cortana_insert_1b 300)
	
	(object_teleport chief chief_walk_1_stop)
	(recording_play chief chief_walk_2)
	
	(sleep (- (recording_time chief) 15))
	
	(camera_set plugin_1a 0)
	(camera_set plugin_1b 200)
	
	(sound_looping_start sound\sinomatixx_foley\b40_extraction_foley none 1)
	
	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip01-thisisit" true)
	(sleep 60)
	(sound_impulse_start sound\dialog\b40\B40_extract_020_CORTANA none 1)
	(print "Cortana: That terminal. Try there.")
	
	(sleep 84)
	
	(effect_new_on_object_marker "cinematics\effects\cyborg chip insertion" chief "left hand")
	
	(object_destroy cortana_chip)
	(object_create cortana_chip)
	(objects_attach chief "left hand" cortana_chip "")
	(sleep 30)
	(object_destroy cortana_chip)
	
	(sleep (camera_time))
	
	(camera_set cortana_appearance_1b 0)
	(camera_set cortana_appearance_1a 90)
	
	(object_destroy cortana)
	(object_create cortana)
	(object_beautify cortana true)
	
	(unit_suspended cortana true)
	(object_set_scale cortana 7 60)
	
	(unit_set_emotion cortana 2)
	
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip00-intronodialoge" true)
	(sleep (unit_get_custom_animation_time cortana))
	
	(sound_impulse_start sound\dialog\b40\B40_extract_030_CHIEF chief 1)
	(print "Chief: You alright?")
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_030_CHIEF))

	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip01-neverbeen" true)
	
	(camera_set cant_imagine_1a 0)
	(camera_set cant_imagine_1b 250)
	
	(sound_impulse_start sound\dialog\b40\B40_extract_040_CORTANA cortana 1)
	(print "Cortana: Never been better.")
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_040_CORTANA))
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip04-loop" true)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip02-youcantimagine" true)
	(sound_impulse_start sound\dialog\b40\B40_extract_050_CORTANA cortana 1)
	(print "Cortana: You can't imagine the wealth of information--the knowledge! So much! So fast! It's glorious!")

	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_050_CORTANA))
	
	(camera_set what_sort_1a 0)
	(camera_set what_sort_1b 90)
	
	(object_set_scale cortana 5 0)
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip02-sowhatsort" false)
	
	(sound_impulse_start sound\dialog\b40\B40_extract_060_CHIEF chief 1)
	(print "Chief: So, what sort of weapon is it?")
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_060_CHIEF))
	
	(unit_set_emotion cortana 4)
	
	(camera_set what_talking 0)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip03-whatareyou" false)
	
	(sound_impulse_start sound\dialog\b40\B40_extract_070_CORTANA cortana 1)
	(print "Cortana: What are you talking about?")
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_070_CORTANA))
	
	(camera_set how_do_we_1a 0)
	(camera_set how_do_we_1b 180)
	
;	(object_set_scale cortana 7 0)
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip03-letsstayfocused" true)
	
	(sound_impulse_start sound\dialog\b40\B40_extract_080_CHIEF chief 1)
	(print "Chief: Let's stay focused. Halo. How do we use it against the Covenant?")
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_080_CHIEF))
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip04-loop" false)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip04thisringisnt" false)
	
	(camera_set chief_rev_1a 0)
	(camera_set chief_rev_1b 200)
	
	(sound_impulse_start sound\dialog\b40\B40_extract_090_CORTANA cortana 1)
	(print "Cortana: This ring isn't a cudgel, you barbarian. It's something else...something much more important. ")
	(sleep (- (sound_impulse_time sound\dialog\b40\B40_extract_090_CORTANA) 120))
	(unit_set_emotion cortana 6)
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_090_CORTANA))

	(camera_set cortana_cu_2a 0)
	(camera_set access_cu 200)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip05theconvenent" true)
	
	(sound_impulse_start sound\dialog\b40\B40_extract_100_CORTANA cortana 1)
	(print "Cortana: The Covenant were right! This ring...it's Forerunner! Give me a second to access...yes! The Forerunner built this place, what they called a 'fortress world' in order to--wait. No, that can't be...")
	
	(camera_set cortana_rev_2a 0)
	(camera_set cortana_rev_2b 390)
	
	(sleep 390)
	
	(unit_set_emotion cortana 8)
	
	(camera_set wait_1a 0)
	(camera_set wait_1b 180)
	
	(sleep (unit_get_custom_animation_time cortana))
	(unit_set_emotion cortana 5)

	(camera_set oh_1a 0)
	(camera_set oh_1b 30)

	(unit_set_emotion cortana 3)

	(sound_impulse_start sound\dialog\b40\B40_extract_101_CORTANA cortana 1)
	(print "Cortana: Ohh!")
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip06-ohhh" false)
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_101_CORTANA))
	
	(unit_stop_custom_animation cortana)
	
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip07-thosecovenant" true)
	
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_101_CORTANA))
	
	(sound_impulse_start sound\dialog\b40\B40_extract_110_CORTANA cortana 1)
	(print "Cortana: Those Covenant fools! They must have known! There must have been signs!")
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_110_CORTANA))
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip05-slowdownyour" true)
	
	(camera_set slow_down_1b 0)
	(camera_set slow_down_1a 60)

	(sound_impulse_start sound\dialog\b40\B40_extract_120_CHIEF chief 1)
	(print "Chief: Slow down. You're losing me.")
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_120_CHIEF))
	
	(camera_set cortana_cu_2a 0)
	(camera_set cortana_cu_2b 180)
	(unit_set_emotion cortana 6)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip08-thecovenant" true)
	(sound_impulse_start sound\dialog\b40\B40_extract_130_CORTANA cortana 1)
	(print "Cortana: The Covenant found something. Buried in this ring. Something horrible. And now...they're afraid.")
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_130_CORTANA))
	
	(camera_set something_buried_1a 0)
;	(camera_set something_buried_1a 0)
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip06-somethingburied" true)

	(sound_impulse_start sound\dialog\b40\B40_extract_140_CHIEF chief 1)
	(print "Chief: Something buried? Where?")
	(sleep (- (sound_impulse_time sound\dialog\b40\B40_extract_140_CHIEF) 15))

	(camera_set the_captain_1a 0)
	(camera_set the_captain_1b 30)
	
	(unit_set_emotion cortana 5)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip09-thecaptin" true)
	(sound_impulse_start sound\dialog\b40\B40_extract_150_CORTANA cortana 1)
	(print "Cortana: The Captain! We've got to stop the Captain!")
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_150_CORTANA))
	
	(camera_set chief_captain_1a 0)
	(camera_set chief_captain_1b 30)
	
	(object_set_scale cortana 7 0)
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip07-keys" true)
	
	(sound_impulse_start sound\dialog\b40\B40_extract_160_CHIEF chief 1)
	(print "Chief: Keyes? What--")
	(sleep (- (sound_impulse_time sound\dialog\b40\B40_extract_160_CHIEF) 15))
	
	(camera_set keyes_what 0)
	(camera_set keyes_what_1b 120)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip10-theweapons" true)
	
	(sound_impulse_start sound\dialog\b40\B40_extract_170_CORTANA cortana 1)
	(print "Cortana: The weapons cache he's looking for, it's not really--we can't let him get inside!")
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_170_CORTANA))
	
	(camera_set dont_1a 0)
	(camera_set dont_1b 30)
	
	(object_set_scale cortana 5 0)
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip08-idontunder" true)
	
	(sound_impulse_start sound\dialog\b40\B40_extract_180_CHIEF chief 1)
	(print "Chief: I don't--")
	(sleep (- (sound_impulse_time sound\dialog\b40\B40_extract_180_CHIEF) 15))
	
	(camera_set final_run_1a 0)
	(camera_set final_run_1b 180)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip11-theresnotime" true)

	(sound_impulse_start sound\dialog\b40\B40_extract_190_CORTANA cortana 1)
	(print "Cortana: There's no time! Get out of here! Find Keyes! Stop him!")
	(sleep 15)
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip09-theresnotime" true)
	
	(sleep (sound_impulse_time sound\dialog\b40\B40_extract_190_CORTANA))
	
	(camera_set too_late_1a 0)
	(camera_set too_late_1b 180)
	(unit_set_emotion cortana 3)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip12-beforeitstoolate" true)
	
	(sound_impulse_start sound\dialog\b40\B40_extract_200_CORTANA cortana 1)
	(print "Cortana: Before it's too late!")

	(sleep 90)
	
	(fade_out 0 0 0 15)
	
	(sleep 92)
	
	(unit_stop_custom_animation chief)
	(unit_stop_custom_animation cortana)
	
	(object_destroy chief)
	(object_destroy cortana)
	(object_destroy rifle)
	
	(rasterizer_model_ambient_reflection_tint 0 0 0 0)
	
	(game_won)
)

(script static void test
(custom_animation cortana cinematics\animations\cortana\level_specific\b40\b40 "clip06-ohhh" false)
;	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip01-thisisit" true)
;	(sleep (unit_get_custom_animation_time chief))
;	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip02-loop01-22" true)
;	(sleep (unit_get_custom_animation_time chief))
;	(custom_animation chief cinematics\animations\chief\level_specific\b40\b40 "b40-clip03-whatdowe" true)
)
