; B30 Cinematic Script
; --------------------

;========== Cutscene Scripts ==========

(script dormant ledge_music
	(sleep 90)
	(sound_looping_start sound\sinomatixx_music\b30_ledge_music none 1)
)

(script static void cutscene_ledge
   (if (mcc_mission_segment "cine3_shafted") (sleep 1))

	(wake ledge_music)
	(set test_ledge true)
	(ai off)
	(fade_out 1 1 1 15)
	(sleep 15)
	(switch_bsp 1)
	(cinematic_start)
	(camera_control on)
	(object_teleport (player0) player0_ledge_wait)
	(object_teleport (player1) player1_ledge_wait)
	
	(object_create_anew chief)
	(object_create_anew rock_kick)
	(object_create_anew rock_still)
	(object_create_anew rifle)
	
	(unit_set_seat chief alert)
	
	(object_beautify chief true)	
	
	(camera_set ledge_1a 0) 
	(camera_set ledge_1b 180)
	
	(object_teleport chief ledge_walk)
	
	(objects_attach chief "right hand" rifle "")
	
	(recording_play chief chief_ledge_walk)
	
	(sleep 15)
	
	(fade_in 1 1 1 15)

	(sleep 90)
	(camera_set ledge_1c 210)
	(sleep 210)

	(object_teleport chief ledge_look)
	(custom_animation chief cinematics\animations\chief\level_specific\b30\b30 "B30ledge" false)
	(scenery_animation_start rock_kick scenery\cutscene_small_rock\cutscene_small_rock "clip01-rockfalling")
		
	(camera_set ledge_2a 0)
	(camera_set ledge_2b 250)
	
	(sound_looping_start sound\sinomatixx\b30_ledge_foley none 1)
	
	(sleep (- (camera_time) 15))

	(fade_out 1 1 1 15)
	
	(sleep 15)
	
	(object_teleport (player0) player0_ledge_done)
	(object_teleport (player1) player1_ledge_done)
	
	(object_destroy chief)
	(object_destroy rock_kick)
	(object_destroy rifle)

	(set test_ledge false)
	(show_hud 1)
	(camera_control off)
	(cinematic_stop)
	
	(fade_in 1 1 1 15)
	(ai on)
	(sleep 15)
	(game_save)
)

(script static void rock_test

	(object_create chief)
	(object_create rock_kick)

	(object_teleport chief ledge_look)
	(custom_animation chief cinematics\animations\chief\level_specific\b30\b30 "B30ledge" false)
	(scenery_animation_start rock_kick scenery\cutscene_small_rock\cutscene_small_rock "clip01-rockfalling")
	
	(sleep (unit_get_custom_animation_time chief))
		
	(object_destroy chief)
	(object_destroy rock_kick)
)

(script static void cutscene_map
   (if (mcc_mission_segment "cine4_activating_sc") (sleep 1))
  
	(sound_looping_start sound\sinomatixx_foley\b30_map_foley none 1)
	
	(ai off)
	
	(fade_out 1 1 1 15)
	
	(sleep 15)
	
	(switch_bsp 1)
	
	(cinematic_start)
	(camera_control on)
	
	(object_teleport (player0) player0_map_wait)
	(object_teleport (player1) player1_map_wait)
	
	(object_destroy chief)
	(object_destroy rifle)
	
	(object_create chief)
	(object_create rifle)	
	
	(unit_set_seat chief alert)

	(object_beautify chief true)	
	
	(object_teleport chief chief_map_activate)
	(objects_attach chief "right hand" rifle "")
		
	(unit_custom_animation_at_frame chief cinematics\animations\chief\level_specific\b30\b30 "B30HoloMap" true 130)
	
	(camera_set map_1a 0) 
	(camera_set map_1b 250)
	
	(fade_in 1 1 1 15)
	(set play_music_b30_04 true)
	
	(sleep 50)
	
	(device_set_position holohalo_1 1)
	
	(sound_impulse_start sound\dialog\b30\B30_580_Cortana none 1)
	(print "cortana: analyzing...halo's control center is located there. That structure appears to be some sort of temple...")
;	(sleep (sound_impulse_time sound\dialog\b30\B30_extract_010_Cortana))

	(sleep 75)
	
	(camera_set map_1c 250)
	
	(sleep 125)
	
	(camera_set map_1d 150)
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	
	(sleep 15)
	
	(object_teleport (player0) player0_map_done)
	(object_teleport (player1) player1_map_done)
	
	(object_destroy chief)
	
	(camera_control off)
	(cinematic_stop)
	
	(fade_in 1 1 1 15)
	
	(game_save)
	(ai_conversation shaftA_switch)
	(ai on)
)

(script static void extraction_build
	(switch_bsp 0)
	(set cheat_deathless_player on)
	(game_speed 5)
	(object_destroy shafta_inv_cship)
	(object_destroy lid_cship)
	(object_create_anew extraction_pelican)
	(object_teleport extraction_pelican extraction_pelican_flag_1)
	(recording_play_and_hover extraction_pelican extraction_pelican_1)
	(sleep (recording_time extraction_pelican))
	(game_speed 1)
	(print "foehammer done")
)
	
(script dormant pelican_fade
	(sleep 225)
	(sound_class_set_gain vehicle .3 0)
)	
	
(script dormant extraction_music
	(sleep 73)
	(sound_looping_start sound\sinomatixx_music\b30_extraction_music none 1)
)	
	
(script static void cutscene_extraction_exit

	(wake extraction_music)

	(sound_looping_start sound\sinomatixx_foley\b30_extraction_foley none 1)

	(wake pelican_fade)

	(object_pvs_activate extraction_pelican)

	(sleep (recording_time extraction_pelican))
	(sleep 30)
	
	(fade_out 0 0 0 15)
	(sleep 15)
	
	(cinematic_start)
	(camera_control on)
	
	(ai_kill valley_lid)
	(ai_kill valley_mouth)
	(ai_kill valley_canyon)
	(ai_kill valley_lid_inv)
	(ai off)
	
	(vehicle_hover extraction_pelican 0)
	(recording_play extraction_pelican extraction_pelican_2)
	
	(camera_set extraction_1c 0)
	(camera_set extraction_1a 210)
	
	(fade_in 0 0 0 15)
	
	(sound_impulse_start sound\dialog\b30\B30_extract_010_Cortana none 1)
	(print "cortana: Let's get moving! Foe Hammer: here are coordinates and I flight plan I've worked up.")
;	(sleep (sound_impulse_time sound\dialog\b30\B30_extract_010_Cortana))

	(sleep 105)
	(camera_set extraction_1b 120)

	(sleep (camera_time))

	(sleep (sound_impulse_time sound\dialog\b30\B30_extract_010_Cortana))
	(sound_impulse_start sound\dialog\b30\B30_extract_020_Pilot none 1)
	(print "foehammer: Uh, Cortana, these coordinates are underground.")

	(camera_set_relative extraction_follow_1a 0 extraction_pelican)
	(camera_set_relative extraction_follow_1b 240 extraction_pelican)
	
	(sleep (sound_impulse_time sound\dialog\b30\B30_extract_020_Pilot))
	
	(sound_impulse_start sound\dialog\b30\B30_extract_050_Cortana none 1)
	(print "cortana: The Covenant did a thorough seismic scan, and my analysis shows that Halo is honeycombed with deep tunnels which circle the whole ring.")
;	(sleep (sound_impulse_time sound\dialog\b30\B30_extract_050_Cortana))
	
	(sleep 200)

	(object_destroy shaft_box_1)
	(object_destroy shaft_box_2)
	(object_destroy shaft_box_3)
	
	(camera_set lid_1a 0)
	(camera_set lid_1b 150)
	
	(player_effect_set_max_rotation 0 .4 .4)
	(player_effect_set_max_vibrate .4 .4)
	(player_effect_start 1 2)
	
	(object_create_anew dust_1)
	(object_create_anew dust_2)
	(object_create_anew dust_3)
	(object_create_anew dust_4)

	(object_teleport dust_1 dust_1a)
	(object_teleport dust_2 dust_1b)
	(object_teleport dust_3 dust_1c)
	(object_teleport dust_4 dust_1d)

	(sleep (sound_impulse_time sound\dialog\b30\B30_extract_050_Cortana))
	(sound_impulse_start sound\dialog\b30\B30_extract_060_Pilot none 1)
	(print "foehammer: I hope you're analysis is on the money, Cortana. A Pelican won't turn on a dime especially not undground.")
;	(sleep (sound_impulse_time sound\dialog\b30\B30_extract_060_Pilot))
	
	(sleep 150)
	
	(fade_out 0 0 0 15)

	(sleep 15)
	
;	(sleep (recording_time extraction_pelican_2))
	
	(object_create extraction_pelican_2)
	
	(object_pvs_activate extraction_pelican_2)
	
	(object_teleport extraction_pelican_2 extraction_pelican_flag_2)
	(recording_play extraction_pelican_2 extraction_pelican_drop)
	
	(object_create_anew dust_1)
	(object_create_anew dust_2)
	(object_create_anew dust_3)
	(object_create_anew dust_4)

	(object_teleport dust_1 dust_2a)
	(object_teleport dust_2 dust_2b)
	(object_teleport dust_3 dust_2c)
	(object_teleport dust_4 dust_2d)

	(camera_set extraction_6a 0)
	
	(sound_class_set_gain vehicle_engine .3 0)
	
	(object_destroy extraction_pelican)
	(object_teleport falling_box_1 box_drop_flag_1)
	(object_teleport falling_box_2 box_drop_flag_2)
	(object_teleport falling_box_5 box_drop_flag_5)
	(camera_set extraction_6b 200)

	(fade_in 0 0 0 15)

	(sleep (sound_impulse_time sound\dialog\b30\B30_extract_060_Pilot))
	(sound_impulse_start sound\dialog\b30\B30_extract_070_Cortana none 1)
	
	(sleep 35)
	
	(print "cortana: Look on the bright side, Foehammer: the last thing the Covenant will expect is an aerial insertion... from underground.")
;	(sleep (sound_impulse_time sound\dialog\b30\B30_extract_070_Cortana))

	(sleep 200)
	
	(object_teleport falling_box_3 box_drop_flag_3)
	(object_teleport falling_box_4 box_drop_flag_4)
	(object_teleport falling_box_6 box_drop_flag_6)
	(sleep (camera_time))
	(object_teleport falling_box_7 box_drop_flag_7)
	
	(object_create lens_machine)
	(object_create lens_effect)
	(device_set_position lens_machine 0)
	
	(object_create_anew_containing dust)

	(object_teleport dust_1 dust_3a)
	(object_teleport dust_2 dust_3b)
	(object_teleport dust_3 dust_3c)
	(object_teleport dust_4 dust_3d)
	(object_teleport dust_5 dust_3e)
	(object_teleport dust_6 dust_3f)
	(object_teleport dust_7 dust_3g)
	(object_teleport dust_8 dust_3h)

	(camera_set extraction_7a 0)
	
	(camera_set extraction_7b 500)
	(sleep 300)
	(fade_out 0 0 0 30)
	(player_effect_stop 1)
	(sleep (camera_time))
	
	(sound_class_set_gain vehicle 1 0)
)

