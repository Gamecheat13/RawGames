;	C20 CINEMATICS

(script static void cutscene_insertion

	(sound_looping_start sound\sinomatixx_foley\c20_insertion_foley none 1)
	(sound_class_set_gain ambient .5 0)

	(fade_out 0 0 0 0)

	(camera_control on)
	(cinematic_start)
	
	(switch_bsp 0)
	
	(object_teleport (player0) player0_pause_base)
	(object_teleport (player1) player1_pause_base)
	
	(object_create_anew index)
	(object_create_anew chief)
	(object_create_anew monitor)
	(object_create_anew rifle)
	
	(objects_predict chief)
	(objects_predict monitor)
	(objects_predict monitor_teleport_in)
	(object_beautify chief true)
	
	(objects_attach chief "right hand" rifle "")
	
	(object_set_scale chief .1 0)
	(object_set_scale monitor .1 0)
	
	(sleep 7)
	(sound_looping_start sound\sinomatixx_music\c20_insertion_music none 1)
	(sleep 23)
	
	(camera_set flyin_1a 0)
	(camera_set flyin_1b 300)
		
	(fade_in 0 0 0 30)
	
	(sleep 150)
	(camera_set flyin_1c 300)
	(sleep 150)
	(camera_set flyin_1d 300)
	(sleep 150)
	(object_pvs_set_camera flyin_1e)
	(camera_set flyin_1e 250)
	(sleep 125)
	(camera_set flyin_1f 250)
	(sleep 125)
	(camera_set flyin_1g 200)
	(sleep 50)
	(device_set_position spooky_door 1)
	(sleep 50)
	(camera_set flyin_1h 200)
	(sleep 100)
	(camera_set flyin_1i 150)
	
	(object_create_anew monitor_teleport_in)
	(device_set_position monitor_teleport_in 1)
	(sleep 30)
	(object_teleport monitor monitor_teleport_base)
	(object_set_scale monitor 1 15)
	
	(ai_attach_free monitor characters\monitor\monitor)
	(ai_command_list_by_unit monitor look_at_chief)
	
	(sound_impulse_start sound\dialog\c20\C20_insert_020_Monitor monitor 1)
	(print "monitor: We must collect the Index before we can activate the Installation.")
	
	(sleep 30)
	
	(object_create_anew chief_teleport_in)
	(device_set_position chief_teleport_in 1)
	(sleep 30)
	(object_teleport chief chief_teleport_base)
	(object_set_scale chief 1 15)

	(custom_animation chief cinematics\animations\chief\level_specific\c20\c20 c20chiefteleport false)

	(sleep (- (unit_get_custom_animation_time chief) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(object_destroy chief)
	(object_destroy monitor)
	(object_destroy rifle)
	
	(object_teleport (player0) chief_teleport_base)
	(object_teleport (player1) player1_start_base)

	(camera_control off)
	(cinematic_stop)
	
	(device_set_position_immediate spooky_door 0)
	(object_pvs_activate none)
	
	(fade_in 1 1 1 15)
	(sound_class_set_gain ambient 1 3)
)

(script static void cutscene_extraction

	(sound_looping_start sound\sinomatixx_foley\c20_extraction_foley none 1)
	(sound_class_set_gain device_machinery 0 0)
	(sound_class_set_gain ambient .5 0)

	(fade_out 1 1 1 15)
		
	(sleep 15)
	
	(device_set_position_immediate index_platform 0)

	(camera_control on)
	(cinematic_start)
	
	(object_create_anew monitor)
	(object_create_anew index)
	
	(object_pvs_activate monitor)
	
	(objects_predict chief)
	
	(object_teleport (player0) player0_pause_base)
	(object_teleport (player1) player1_pause_base)

	(ai_attach_free monitor characters\monitor\monitor)
	
	(object_teleport monitor monitor_index_fly_base)
	
	(camera_set platform_drop_1c 0)
	(camera_set platform_drop_1a 60)
	
	(fade_in 1 1 1 15)
	
	(sleep 3)
	(sound_looping_start sound\sinomatixx_music\c20_extraction_music none 1)
	(sleep 57)
	
	(print "rumble start")
	(player_effect_set_max_rotation 0 .25 .25)
	(player_effect_set_max_vibrate .3 .3)
	(player_effect_start 1 0)
	
	(camera_set platform_drop_1b 300)
	
	(device_set_position index_platform 1)
	
	(ai_command_list_by_unit monitor fly_down_shaft)
	
	(sleep 100)
	
	(sound_impulse_start sound\dialog\c20\C20_310_Monitor none 1)
	(print "monitor: The energy barrier surrounding the Index will deactivate when we reach the ground floor.")
;	(sleep (sound_impulse_time sound\dialog\c20\C20_310_Monitor))
	
	(player_effect_set_max_vibrate .2 .2)
	(player_effect_set_max_rotation 0 .1 .1)
	
	(sleep 260)
	
	(camera_set platform_drop_2a 0)
	(camera_set platform_drop_2b 300)

	(objects_predict chief)
	(objects_predict monitor)
	(objects_predict monitor_teleport_in)
	(object_beautify chief true)

	(sleep 235)
	
	(player_effect_set_max_vibrate .75 .75)
	(player_effect_set_max_rotation 0 .5 .5)
	(player_effect_stop 3)
	(print "rumble stop")
	
	(sleep 90)
	
	(camera_set grab_index_1a 0)
	(camera_set grab_index_1b 300)
	
	(object_teleport monitor monitor_index_base)
	
	(ai_command_list_by_unit monitor look_at_chief_index)
	
	(object_create_anew chief)
	(object_create_anew rifle)
	(objects_attach chief "right hand" rifle "")
	
	(object_beautify chief true)
	
	(time_code_show true)
	(time_code_start true)
	
	(custom_animation chief cinematics\animations\chief\level_specific\c20\c20 c20grabindex false)
	(scenery_animation_start index scenery\index\index C20GrabIndex)

	(camera_set grab_index_1a 0)
	(camera_set grab_index_1b 400)

	(sound_impulse_start sound\dialog\c20\C20_320_Monitor monitor 1)
	(print "monitor: You may now retrieve the Index.")
	
	(sleep 200)
	
	(camera_set grab_index_1c 200)
	
;	(405, chief grabs index)	
	(sleep 205)
	
	(camera_set inspect_index_1b 0)
;	(camera_set inspect_index_1a 180)
	
	(object_destroy index_shard)
	(object_create index_shard)
	(objects_attach chief "left hand" index_shard "left hand index")
	
;	(493, start monitor animation)
	(sleep 93)	
	
	(object_set_permutation monitor "unamed" "lightning-100")
	(custom_animation monitor cinematics\animations\monitor\level_specific\c20\c20 c20grabindex false)

;	(objects_detach chief index_shard)
;	(objects_attach monitor "monitor tendril" index_shard "left hand index")
	
	(camera_set index_steal_1a 0)
	(camera_set index_steal_1b 60)
	
;	(535, make index disappear)
	(sleep 42)
	
	(effect_new_on_object_marker "cinematics\effects\cyborg chip insertion" chief "left hand")
	(object_destroy index_shard)
	
	(sleep 18)
	
	(object_set_permutation monitor "unamed" "monitor")
	
	(camera_set monitor_babble_1a 0)
	(camera_set monitor_babble_1b 300)

	(sound_impulse_start sound\dialog\c20\C20_extract_020_Monitor monitor 1)
	(print "monitor: Protocol requires that I take possession of the Index for transport. Your organic form renders you vulnerable to infection. The Index must not fall into the hands of the Flood before we reach the control room and activate the Installation.")
	(sleep (- (sound_impulse_time sound\dialog\c20\C20_extract_020_Monitor) 60))
	
	(object_create_anew monitor_teleport_out)
	(device_set_position monitor_teleport_out 1)
	
	(sleep 30)
	
	(object_set_scale monitor .1 15)
	
	(sleep 30)
	
	(camera_set final_shot_1a 0)
	(camera_set final_shot_1b 300)
	
	(object_destroy monitor)
	
	(sound_impulse_start sound\dialog\c20\C20_extract_030_Monitor none 1)
;	(print "monitor: The Flood is spreading. We must hurry.")

	(sleep 135)

	(fade_out 0 0 0 15)
	(sleep 66)
	
	(object_destroy chief)
	(object_destroy index)
	(object_destroy index_shard)

	(camera_control off)
	(cinematic_stop)
	
	(sound_class_set_gain device_machinery 1 0)
	(sound_class_set_gain ambient 1 0)

	(game_won)
)

(script static void test 
	(object_teleport monitor monitor_index_base)
	(custom_animation monitor cinematics\animations\monitor\level_specific\c20\c20 c20grabindex false)
)

