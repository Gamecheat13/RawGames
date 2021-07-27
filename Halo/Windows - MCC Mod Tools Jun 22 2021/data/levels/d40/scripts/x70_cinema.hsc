;	X70 CINEMATIC SCRIPT
;	...component scripts up top, 
;	the whole she-bang at the bottom...

;	(unit_stop_custom_animation chief_x30)
;	(custom_animation chief cinematics\animations\chief\x70\x70 "" true)
;	(sleep (unit_get_custom_animation_time chief))

(script static void bridge_1
	
	(cinematic_set_near_clip_distance .01)

	(object_create_anew chief_armed)
	(object_create_anew cortana_chip)
	(object_teleport chief_armed chief_bridge_base)
	
	(camera_set plugin_1a 0)
	(camera_set plugin_1b 200)
	
	(object_pvs_activate chief_armed)
	
	(object_teleport chief_armed chief_plugin_base)
	(custom_animation chief_armed cinematics\animations\chief\x70\x70 "x70_0210" false)
	
	(fade_in 1 1 1 30)
	(sleep 60)
	
;	(print "chip effect")
	(objects_attach chief_armed "left hand" cortana_chip "")
	(effect_new_on_object_marker "cinematics\effects\cyborg chip insertion" chief_armed "left hand")
	
	(sleep 50)
	
;	(print "chip destroy")
	(objects_detach chief_armed cortana_chip)
	(object_destroy cortana_chip)
	
	(unit_stop_custom_animation chief_armed)
	
	(camera_set leave_home_1a 0)
	(camera_set leave_home_1b 180)
	
	(effect_new "cinematics\effects\cortana effects\cortana on off" cortana_effect_base)
	(sleep 30)
	
	(object_destroy cortana)
	(object_create cortana)
	(unit_set_emotion cortana 6)
	
	(custom_animation cortana cinematics\animations\cortana\x70\x70 "x70_1_0-409" true)
	(sound_impulse_start sound\dialog\x70\cor_01 cortana 1)
;	(print "cortana: I leave home for a few days, and look what happens. This won't take long.")
	(sleep (- (sound_impulse_time sound\dialog\x70\cor_01) 60))
	
	(unit_set_emotion cortana 0)
	
	(sleep (sound_impulse_time sound\dialog\x70\cor_01))
	(sleep 30)
	
	(camera_set there_1a 0)
	
	(object_create_anew display_back)
	(object_create_anew display_count)
	(numeric_countdown_timer_set 12000000 true)
	
	(custom_animation chief_armed cinematics\animations\chief\x70\x70 "x70_0430" false)
	
	(unit_set_emotion cortana 6)
	
	(sound_impulse_start sound\dialog\x70\cor_02 cortana 1)
;	(print "cortana: There. That should give us enough time to make it to a lifeboat, and put some distance between ourselves and Halo before the detonation.")
	(sleep (- (sound_impulse_time sound\dialog\x70\cor_02) 150))
	
	(camera_set countdown_1a 0)
	(camera_set countdown_1b 150)
	
	(sleep (camera_time))
	
	(custom_animation chief_armed cinematics\animations\chief\x70\x70 "x70_0435" true)
	
	(camera_set remove_1a 0)
	(camera_set remove_1b 90)
	
	(sleep 90)
	
	(sound_impulse_start sound\dialog\x70\mon_01 none 1)
;	(print "monitor: I'm afraid that's out of the question, really.")
	
	(sleep 15)
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\x70\x70 "x70_1B" true)
	
	(sleep (sound_impulse_time sound\dialog\x70\mon_01))
	
	(custom_animation cortana cinematics\animations\cortana\x70\x70 "x70_2_410-725" true)
	(camera_set oh_hell_1a 0)
	(camera_set oh_hell_1b 30)
	
	(unit_set_emotion cortana 7)
	
	(sound_impulse_start sound\dialog\x70\cor_03 cortana 1)
;	(print "cortana: Oh, hell.")
	(sleep (sound_impulse_time sound\dialog\x70\cor_03))
	
	(camera_set hes_back_1a 0)
	(camera_set hes_back_1b 120)

	(sound_impulse_start sound\dialog\x70\mon_02 none 1)
;	(print "monitor: Ridiculous! That you would imbue a warship's AI with such a wealth of knowledge...Weren't you worried it might be captured, or destroyed?.")
	(sleep 60)
	(camera_set hes_back_1c 120)
	(sleep (sound_impulse_time sound\dialog\x70\mon_02))
	
	(camera_set cortana_1 0)
	(camera_set cortana_tap_1a 30)
	
	(unit_set_emotion cortana 1)

	(custom_animation chief_armed cinematics\animations\chief\x70\x70 "x70_1210" true)
	
	(custom_animation cortana cinematics\animations\cortana\x70\x70 "x70_3_726-1512" false)
	(sound_impulse_start sound\dialog\x70\cor_04 cortana 1)
;	(print "cortana: He's in my data-arrays! A local tap!")
	(sleep (sound_impulse_time sound\dialog\x70\cor_04))
	
	(fade_out 0 0 0 15)
	(sleep 15)
)

(script dormant engine_sentinels_1
	(object_create_anew_containing engine_sentinel_1)
	(object_teleport engine_sentinel_1a engine_sentinel_1a)
	(object_teleport engine_sentinel_1b engine_sentinel_1b)
	(ai_attach_free engine_sentinel_1a characters\monitor\monitor)
	(ai_attach_free engine_sentinel_1b characters\monitor\monitor)
	(ai_command_list_by_unit engine_sentinel_1b engine_sentinel_1b_fly)
	(sleep 30)
	(ai_command_list_by_unit engine_sentinel_1a engine_sentinel_1a_fly)
)
	 
(script dormant engine_sentinels_2
	(object_destroy_containing engine_sentinel_1)
	(object_create_anew_containing engine_sentinel_2)
	(object_teleport engine_sentinel_2a engine_sentinel_2a)
	(object_teleport engine_sentinel_2b engine_sentinel_2b)
	(ai_attach_free engine_sentinel_2a characters\monitor\monitor)
	(ai_attach_free engine_sentinel_2b characters\monitor\monitor)
	(ai_command_list_by_unit engine_sentinel_2a engine_sentinel_2a_fly)
	(sleep 60)
	(ai_command_list_by_unit engine_sentinel_2b engine_sentinel_2b_fly)
)

(script static void monitor_1

	(object_create_anew monitor)
	
	(object_teleport monitor monitor_base_1)
	
	(ai_attach_free monitor characters\monitor\monitor)

	(object_pvs_activate monitor)
	
	(sleep 10)
	
	(fade_in 0 0 0 15)

	(camera_set monitor_work_1a 0)
	(camera_set monitor_work_1b 150)
	
	(sleep 5)
	
	(sound_impulse_start sound\dialog\x70\mon_03 monitor 1)
	
	(sleep 75)
	(camera_set monitor_work_1c 150)
	
	(object_set_permutation monitor "unamed" "lightning-100")
	(custom_animation monitor cinematics\animations\monitor\x70\x70 "workingB" true)
	
	(sleep (unit_get_custom_animation_time monitor))
	
	(object_set_permutation monitor "unamed" "monitor")
	
	(camera_set monitor_work_2a 0)
	(camera_set monitor_work_2b 120)
	
	(ai_command_list_by_unit monitor fly_to_console)
	
	(sleep 60)
	(camera_set monitor_work_2c 120)
	
	(wake engine_sentinels_1)
	
	(sleep 60)
	(camera_set monitor_work_2d 120)
	(sleep 60)
	(camera_set monitor_work_2e 120)
	(sleep 120)
	
	(camera_set monitor_work_3a 0)
	(camera_set monitor_work_3b 200)
	
	(object_teleport monitor monitor_base_2)
	(object_set_permutation monitor "unamed" "lightning-100")
	
	(ai_detach monitor)
	
	(custom_animation monitor cinematics\animations\monitor\x70\x70 "workingC" true)
	
	(sound_impulse_start sound\dialog\x70\mon_04 monitor 1)
;	(print "monitor: Oh how I will enjoy every moment of it's categorization!")
	
	(sleep 200)
	
	(wake engine_sentinels_2)
	
	(object_teleport monitor monitor_base_3)
	(object_set_permutation monitor "unamed" "monitor")
	
	(camera_set monitor_work_3c 0)
	(camera_set monitor_work_3d 200)
	
	(sleep (sound_impulse_time sound\dialog\x70\mon_04))
;	(print "monitor done")

	(fade_out 0 0 0 15)
	(sleep 15)

	(object_destroy_containing engine_sentinel)
)

(script dormant sentinels_enter_1
	(object_create_anew_containing bridge_sentinel)
	(object_teleport bridge_sentinel_1 sentinel_1_in)
	(object_teleport bridge_sentinel_2 sentinel_2_in)
	(ai_attach_free bridge_sentinel_1 characters\monitor\monitor)
	(ai_attach_free bridge_sentinel_2 characters\monitor\monitor)
	(ai_command_list_by_unit bridge_sentinel_1 sentinel_1_enter)
	(ai_command_list_by_unit bridge_sentinel_2 sentinel_2_enter)
)

(script dormant sentinels_enter_2
	(object_teleport bridge_sentinel_3 sentinel_3_in)		
	(object_teleport bridge_sentinel_4 sentinel_4_in)
	(ai_attach_free bridge_sentinel_3 characters\monitor\monitor)
	(ai_attach_free bridge_sentinel_4 characters\monitor\monitor)
	(ai_command_list_by_unit bridge_sentinel_3 sentinel_3_enter)
	(ai_command_list_by_unit bridge_sentinel_4 sentinel_4_enter)
)

(script dormant sentinels_fire
	(ai_command_list_by_unit bridge_sentinel_1 sentinel_3_fire)
	(ai_command_list_by_unit bridge_sentinel_2 sentinel_1_fire)
	(sleep 30)
	(ai_command_list_by_unit bridge_sentinel_3 sentinel_2_fire)
	(sleep 30)
	(ai_command_list_by_unit bridge_sentinel_4 sentinel_4_fire)
)


(script dormant chief_duck
	
	(effect_new "cinematics\effects\cortana effects\cortana on off" cortana_effect_base)
	(object_destroy cortana)
	
	(custom_animation chief_armed cinematics\animations\chief\x70\x70 "x70_1255" true)
	
	(sleep 40)
	(object_create_anew cortana_chip)
	(objects_attach chief_armed "left hand" cortana_chip "")
	(sleep 17)
	(effect_new_on_object_marker "cinematics\effects\cyborg chip insertion" chief_armed "left hand")
	(objects_detach chief_armed cortana_chip)
	(object_destroy cortana_chip)
	
	(sleep (unit_get_custom_animation_time chief_armed))
;	(print "chief pull done")

	(custom_animation chief_armed cinematics\animations\chief\x70\x70 "x70_1260" true)
	(sleep (unit_get_custom_animation_time chief_armed))
;	(print "chief duck done")
)

(script static void bridge_2
	
	(cinematic_set_near_clip_distance .01)
	
	(object_create_anew chief_armed)
	(object_create_anew cortana)
	
	(object_teleport chief_armed chief_plugin_base)

	(object_pvs_activate chief_armed)

	(custom_animation chief_armed cinematics\animations\chief\x70\x70 "x70_1220" true)
	
	(object_create_anew display_abort)
	(numeric_countdown_timer_stop)
	
	(camera_set hes_stopped_1a 0)
	
	(fade_in 0 0 0 15)
	
	(unit_set_emotion cortana 3)
	
	(custom_animation cortana cinematics\animations\cortana\x70\x70 "x70_4_1513-1659" false)
	
	(sleep 15)

	(sound_impulse_start sound\dialog\x70\cor_05 cortana 1)
;	(print "cortana: He's stopped the self-destruct sequence.")
	(sleep (sound_impulse_time sound\dialog\x70\cor_05))
	
	(camera_set why_fight_1a 0)
	(camera_set why_fight_1b 300)
	
	(sound_impulse_start sound\dialog\x70\mon_05 none 1)
;	(print "monitor: Why do you continue to fight us, Reclaimer? You cannot win. ")
	(sleep (- (sound_impulse_time sound\dialog\x70\mon_05) 30))
	
	(camera_set at_least_1a 0)
	(camera_set at_least_1b 30)
	
	(unit_set_emotion cortana 6)
	
	(custom_animation cortana cinematics\animations\cortana\x70\x70 "x70_5_1857-1969" false)
	(sound_impulse_start sound\dialog\x70\cor_06 cortana 1)
;	(print "cortana: At least I still have control over the comm-channels.")
	(sleep (sound_impulse_time sound\dialog\x70\cor_06))
	
	(camera_set where_is_1a 0)
	(camera_set where_is_1b 300)
	
	(unit_custom_animation_at_frame chief_armed cinematics\animations\chief\x70\x70 "x70_1230" false 15)
	
	(sound_impulse_start sound\dialog\x70\che_01 chief_armed 1)
;	(print "chief: Where is he?")
	(sleep (sound_impulse_time sound\dialog\x70\che_01))
	
	(custom_animation cortana cinematics\animations\cortana\x70\x70 "x70_6_1970-2524" true)
	(unit_set_emotion cortana 8)
	
	(sound_impulse_start sound\dialog\x70\cor_07 cortana 1)
;	(print "cortana: I'm detecting taps throughout the ship--Sentinels most likely. As for the Monitor...")
	(sleep (sound_impulse_time sound\dialog\x70\cor_07))
	
	(camera_set core_offline_1a 0)
	(camera_set core_offline_1b 400)
	
	(unit_set_emotion cortana 3)
	
	(sleep 30)
	
	(sound_impulse_start sound\dialog\x70\cor_08 cortana 1)
;	(print "cortana: Engineering!")
	(sleep (sound_impulse_time sound\dialog\x70\cor_08))

	(sound_impulse_start sound\dialog\x70\cor_09 cortana 1)
;	(print "cortana: He must be trying to take the core offline. Even if I could get the countdown restarted...I don't know what to do.  ")
	(sleep (sound_impulse_time sound\dialog\x70\cor_09))
	
	(camera_set firepower_1a 0)
	(camera_set firepower_1b 180)
	
	(unit_custom_animation_at_frame chief_armed cinematics\animations\chief\x70\x70 "x70_1240" false 15)
	(sound_impulse_start sound\dialog\x70\che_02 chief_armed 1)
;	(print "chief: How much firepower would you need to crack one of the engine's manifolds?")
	(sleep (sound_impulse_time sound\dialog\x70\che_02))
	
	(unit_set_emotion cortana 6)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\x70\x70 "x70_7_2525-2604" false)
	
	(sleep 5)
	
	(camera_set dont_know_1a 0)
	(camera_set but_why_1a 90)
	
	(sound_impulse_start sound\dialog\x70\cor_10 cortana 1)
;	(print "cortana: Not much. A well placed grenade perhaps. But why...")
	(sleep (sound_impulse_time sound\dialog\x70\cor_10))
	
	(sound_looping_start sound\sinomatixx_music\d40_bridge_music02 none 1)
	(sound_looping_start sound\sinomatixx_foley\d40_bridge_foley3 none 1)
	
	(camera_set grenade_toss_1a 0)
	(camera_set grenade_toss_1b 180)
	
	(sound_looping_start sound\sinomatixx_music\d40_bridge_music02 none 1)
	
	(unit_stop_custom_animation chief_armed)
	
	(object_create_anew grenade)
	
	(object_teleport chief_armed chief_plugin_base)
	(object_teleport grenade chief_plugin_base)

	(custom_animation chief_armed cinematics\animations\chief\x70\x70 "x70_1245" false)
	(scenery_animation_start grenade cinematics\animations\grenade\x70\x70 "grenade_juggle")
	
	(sleep 125)
	
	(unit_set_emotion cortana 11)
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\x70\x70 "x70_8_2604-2696" false)

	(camera_set coming_with_1a 0)
	(camera_set coming_with_1b 120)

	(sleep 40)
	
	(object_destroy grenade)
	
	(wake sentinels_enter_1)
		
	(sound_impulse_start sound\dialog\x70\cor_11 cortana 1)
;	(print "cortana: OK, I'm coming with you.")
	(sleep (sound_impulse_time sound\dialog\x70\cor_11))
	
	(custom_animation chief_armed cinematics\animations\chief\x70\x70 "x70_1250" false)
	
	(camera_set pull_out_2a 0)
	(camera_set pull_out_2b 120)
	
	(sleep 60)
	
	(custom_animation cortana cinematics\animations\cortana\x70\x70 "x70_9_2697-2800" true)
	
	(sound_impulse_start sound\dialog\x70\cor_12 none 1)
;	(print "cortana: Chief! Sentinels!")
	(sleep (sound_impulse_time sound\dialog\x70\cor_12))
	
	(wake sentinels_enter_2)
	
	(camera_set sentinels_pan_1a 0)
	(camera_set sentinels_pan_1b 120)
	
	(sleep 120)
	
	(wake sentinels_fire)
	(wake chief_duck)
	
	(object_destroy_containing display)
	
	(camera_set chief_duck_1a 0)
	(camera_set chief_duck_1b 60)
	(sleep 30)
	(camera_set chief_duck_1c 60)
	(sleep 60)
	
	(unit_stop_custom_animation chief_armed)
	(custom_animation chief_armed cinematics\animations\chief\x70\x70 "x70_1265" true)
	
	(sleep 30)
	
	(camera_set chief_spring_1a 0)
	(camera_set chief_spring_1b 30)
	(sleep 30)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_convolution 3 2 1 10 1)
	
	(fade_out 1 1 1 15)
	
	(sleep 15)
	
	(object_destroy chief_armed)
	(object_destroy monitor)
	(object_destroy grenade)
	
	(object_destroy_containing bridge_sentinel)
	(cinematic_screen_effect_stop)
)

(script static void flood_pursuit
	(object_create_anew_containing hangar_flood)
	
	(object_teleport hangar_flood_1 hangar_flood_1_base)
	(object_teleport hangar_flood_2 hangar_flood_2_base)
	(object_teleport hangar_flood_3 hangar_flood_3_base)
	(object_teleport hangar_flood_4 hangar_flood_4_base)
	(object_teleport hangar_flood_5 hangar_flood_5_base)
	(object_teleport hangar_flood_6 hangar_flood_6_base)
	(object_teleport hangar_flood_7 hangar_flood_7_base)
	(object_teleport hangar_flood_8 hangar_flood_8_base)
	(object_teleport hangar_flood_9 hangar_flood_9_base)
	(object_teleport hangar_flood_10 hangar_flood_10_base)
	
	(ai_attach_free hangar_flood_1 characters\captain\captain)
	(ai_attach_free hangar_flood_2 characters\captain\captain)
	(ai_attach_free hangar_flood_3 characters\captain\captain)
	(ai_attach_free hangar_flood_4 characters\captain\captain)
	(ai_attach_free hangar_flood_5 characters\captain\captain)
	(ai_attach_free hangar_flood_6 characters\captain\captain)
	(ai_attach_free hangar_flood_7 characters\captain\captain)
	(ai_attach_free hangar_flood_8 characters\captain\captain)
	(ai_attach_free hangar_flood_9 characters\captain\captain)
	(ai_attach_free hangar_flood_10 characters\captain\captain)
	
	(ai_command_list_by_unit hangar_flood_1 hangar_flood_run_l1)
	(ai_command_list_by_unit hangar_flood_2 hangar_flood_run_l1)
	(ai_command_list_by_unit hangar_flood_3 hangar_flood_run_l1)
	(ai_command_list_by_unit hangar_flood_4 hangar_flood_run_l1)
	(ai_command_list_by_unit hangar_flood_5 hangar_flood_run_l1)
	
	(ai_command_list_by_unit hangar_flood_6 hangar_flood_run_r1)
	(ai_command_list_by_unit hangar_flood_7 hangar_flood_run_r1)
	(ai_command_list_by_unit hangar_flood_8 hangar_flood_run_r1)
	(ai_command_list_by_unit hangar_flood_9 hangar_flood_run_r1)
	(ai_command_list_by_unit hangar_flood_10 hangar_flood_run_r1)
)

(script dormant flood_chase
	(ai_command_list_by_unit hangar_flood_1 flood_ship_chase_1)
	(ai_command_list_by_unit hangar_flood_2 flood_ship_chase_2)
	(ai_command_list_by_unit hangar_flood_3 flood_ship_chase_1)
	(ai_command_list_by_unit hangar_flood_4 flood_ship_chase_2)
	(ai_command_list_by_unit hangar_flood_5 flood_ship_chase_1)
	
	(ai_command_list_by_unit hangar_flood_6 flood_ship_chase_2)
	(ai_command_list_by_unit hangar_flood_7 flood_ship_chase_1)
	(ai_command_list_by_unit hangar_flood_8 flood_ship_chase_2)
	(ai_command_list_by_unit hangar_flood_9 flood_ship_chase_1)
	(ai_command_list_by_unit hangar_flood_10 flood_ship_chase_2)
)

(script static void hangar_1

	(object_create_anew_containing hangar_fire_1)
	(object_create_anew_containing hangar_tank)
	
	(object_create_anew chief_unarmed)
	(object_create_anew fighter_hangar)
	
	(scenery_animation_start fighter_hangar cinematics\animations\h_fighter\x70\x70 "stand opening")
	
	(object_teleport chief_unarmed chief_hangar_run_base)	
	(recording_play chief_unarmed chief_hangar_run)
	
	(object_pvs_activate chief_unarmed)
	
	(camera_set hangar_run_1a 0)	
	(camera_set hangar_run_1b 90)
	
	(fade_in 1 1 1 15)
	
	(flood_pursuit)
	
	(sleep 90)

	(camera_set chief_run_1a 0)
	(camera_set chief_run_1b 120)
	
	(recording_kill chief_unarmed)
	
	(flood_pursuit)
	
	(object_teleport chief_unarmed chief_hangar_run_base)	
	(recording_play chief_unarmed chief_hangar_run)
	
	(sleep 90)
	
	(flood_pursuit)
	
	(objects_attach fighter_hangar "positionchief" chief_unarmed "")
	(objects_detach fighter_hangar chief_unarmed)
	(unit_suspended chief_unarmed true)
	(custom_animation chief_unarmed cinematics\animations\chief\x70\x70 "x70_5000" false)
	
	(sound_looping_start sound\sinomatixx_foley\x70_foley1b none 1)
	
	(camera_set gangway_1a 0)
	(camera_set gangway_1b 30)
	(sleep 30)
	
	(scenery_animation_start fighter_hangar cinematics\animations\h_fighter\x70\x70 "stand closing")
	
	(camera_set door_close_1a 0)
	(camera_set door_close_1b 60)
	
	(sleep 60)
	
	(sound_impulse_start sound\dialog\x70\cor_13 none 1)
;	(print "cortana: We're cutting it close...")
	
	(sleep 30)
)

(script dormant sit_pyrotechnics
	(effect_new "effects\explosions\large explosion" sit_down_pyro_1)
	(sleep 30)
	(effect_new "effects\explosions\medium explosion" sit_down_pyro_2)
)

(script static void hangar_2

	(object_create_anew chief_unarmed)
	(object_pvs_activate chief_unarmed)
	
	(object_teleport chief_unarmed chief_5100)
	(unit_suspended chief_unarmed true)
	(custom_animation chief_unarmed cinematics\animations\chief\x70\x70 "x70_5100" true)
	
	(camera_set hall_walk_1a 0)
	(camera_set hall_walk_1b 90)
	
	(sleep 15)
	
;	(print "explosion")
	
	(player_effect_set_max_rotation 0 .5 .5)
	(player_effect_start 1 0)
	(player_effect_stop 2)
	
	(sleep 75)
	
	(wake sit_pyrotechnics)
	
	(unit_stop_custom_animation chief_unarmed)
	(objects_attach fighter_hangar "positionchief" chief_unarmed "")
	(objects_detach fighter_hangar chief_unarmed)
	(unit_suspended chief_unarmed true)
	(custom_animation chief_unarmed cinematics\animations\chief\x70\x70 "x70_5100-2" false)
	
	(sleep 15)
	
	(camera_set sit_down_1a 0)
	(camera_set sit_down_1b 60)
	
	(sleep (camera_time))
	
	(unit_stop_custom_animation chief_unarmed)
	(objects_attach fighter_hangar "positionchief" chief_unarmed "")
	(objects_detach fighter_hangar chief_unarmed)
	(unit_suspended chief_unarmed true)
	(custom_animation chief_unarmed cinematics\animations\chief\x70\x70 "x70_5130" false)
	
	(sound_looping_start sound\sinomatixx_foley\x70_foley1c none 1)

	(camera_set here_we_go_1a 0)
	(camera_set here_we_go_1b 90)
	
	(sleep (- (unit_get_custom_animation_time chief_unarmed) 90))
	
	(camera_set here_we_go_2a 0)
	(camera_set here_we_go_2b 60)
	
	(sleep (- (unit_get_custom_animation_time chief_unarmed) 60))
		
	(sound_impulse_start sound\dialog\x70\che_03 chief_unarmed 1)
;	(print "chief: Here we go.")
		
	(custom_animation chief_unarmed cinematics\animations\chief\x70\x70 "x70_5140" true)
	
	(sleep (sound_impulse_time sound\dialog\x70\che_03))
)

(script static void hangar_seat

	(object_create_anew chief_unarmed)
	(object_teleport chief_unarmed chief_hangar_seat)
	(unit_suspended chief_unarmed true)
	(custom_animation chief_unarmed cinematics\animations\chief\x70\x70 "x70_5130" false)
)

(script dormant hangar_pyrotechnics_1
	(effect_new "effects\explosions\large explosion" hangar_pyro_1)
	(sleep 30)
	(effect_new "effects\explosions\medium explosion" hangar_pyro_2)
)

(script dormant hangar_pyrotechnics_2
	(effect_new "effects\explosions\large explosion" hangar_pyro_3)
	(sleep 30)
	(effect_new "effects\explosions\medium explosion" hangar_pyro_4)
	(sleep 30)
	(effect_new "effects\explosions\large explosion" hangar_pyro_5)
	(sleep 30)
	(effect_new "effects\explosions\large explosion" hangar_pyro_6)
)

(script static void hangar_3

	(wake flood_chase)

	(object_create_anew_containing hangar_fire_2)

	(player_effect_set_max_rotation 0 .25 .25)
	(player_effect_start 1 0)
	
	(object_destroy chief_unarmed)
	(object_create_anew fighter_hangar)
	
	(object_pvs_activate fighter_hangar)
	
	(object_teleport fighter_hangar fighter_hangar_base)
	
	(scenery_animation_start fighter_hangar cinematics\animations\h_fighter\x70\x70 x70_1)
	
	(camera_set takeoff_1a 0)
	(camera_set takeoff_1b 200)
	
	(sleep 60)
	
	(wake hangar_pyrotechnics_1)
	
	(sleep 140)
	
	(wake hangar_pyrotechnics_2)
	
;	(object_create_anew tunnel_fire)
	
	(camera_set takeoff_1c 0)
	(sleep 30)
	(camera_set takeoff_1d 60)
	
	(player_effect_set_max_rotation 0 .4 .4)

	(sleep 65)
	
	(fade_out 0 0 0 15)
	(sleep 15)
	
	(object_destroy_containing hangar_fire)
	(object_destroy_containing hangar_tank)
	(object_destroy fighter_hangar)
	
	(player_effect_stop 1)
)

(script dormant x80_elite_speech
	(sound_impulse_start sound\dialog\elite\conditional\combat2\involuntary\painminor x80_elite 1)
	(sleep 60)
	(sound_impulse_start sound\dialog\elite\conditional\combat2\beinghurt\hurtenemy x80_elite 1)
)

(script static void happy_easter

	(object_create_anew x80_johnson)
	(object_create_anew x80_elite)
	(object_create_anew johnson_rifle)
	(object_create_anew_containing easter_flood)
	
	(objects_attach x80_johnson "right hand" johnson_rifle "")
	
	(object_beautify x80_johnson true)
	(object_beautify x80_elite true)
	
	(object_pvs_activate x80_johnson)
	
	(object_teleport x80_johnson x80_johnson_base)
	(object_teleport x80_elite x80_elite_base)
	(unit_suspended x80_elite true)
	
	(sleep 15)
	
	(custom_animation x80_johnson cinematics\animations\marines\x70\x70 "easter egg_marine" true)
	(custom_animation x80_elite cinematics\animations\elite\x70\x70 "easter egg_elite" true)
	
	(camera_set x80_1a 0)
	(camera_set x80_1b 180)
	
	(sound_class_set_gain music .4 6)
	(sound_class_set_gain ambient_machinery 0 0)
	
	(fade_in 0 0 0 15)
	
	(sleep 5)
	
	(wake x80_elite_speech)
	
	(sound_looping_start sound\sinomatixx_foley\d40_easter_foley none 1)
	
	(sound_impulse_start sound\dialog\x70\sgt_easter_01 x80_johnson 1)
;	(print "johnson: come here you mother--!")
	
	(sleep 100)
	
	(player_effect_start 1 4)
	
	(sleep 100)
	
	(camera_set x80_2a 0)
	(camera_set x80_2b 90)
	
	(object_create_anew poa_explosion)
	
	(sleep 120)
	
	(player_effect_set_max_rotation 0 .3 .3)
	
	(camera_set x80_3a 0)
	(camera_set x80_3b 150)
	
	(sound_impulse_start sound\dialog\x70\sgt_easter_02 x80_johnson 1)
;	(print "johnson: this is it, baby.")
	(sleep (sound_impulse_time sound\dialog\x70\sgt_easter_02))
	
	(camera_set x80_4a 0)
	(camera_set x80_4b 120)
	
	(player_effect_set_max_rotation 0 .5 .5)
	
	(sound_class_set_gain music 1 3)
	
	(sleep 107)
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(object_destroy x80_johnson)
	(object_destroy x80_elite)
	(object_destroy johnson_rifle)
	(object_destroy poa_explosion)
	(object_destroy_containing easter_flood)
	
	(player_effect_stop 0)
	
	(switch_bsp 9)
)

(script dormant flood_army_pyros
	(effect_new "effects\explosions\large explosion" final_pyro_1a)
	(sleep 30)
	(effect_new "effects\explosions\large explosion" final_pyro_1g)
	(sleep 30)
	(effect_new "effects\explosions\medium explosion" final_pyro_1b)
	(effect_new "effects\explosions\large explosion" final_pyro_1f)
	(effect_new "effects\explosions\medium explosion" final_pyro_3a)
	(sleep 30)
	(effect_new "effects\explosions\large explosion" final_pyro_1c)
	(effect_new "effects\explosions\large explosion" final_pyro_1h)
	(sleep 30)
	(effect_new "effects\explosions\large explosion" final_pyro_3b)
	(sleep 60)
	(effect_new "effects\explosions\medium explosion" final_pyro_1d)
	(sleep 30)
	(effect_new "effects\explosions\large explosion" final_pyro_1e)
)

(script static void launch_1

	(time_code_show on)
	(time_code_start on)
	
	(object_create_anew_containing flood)
	(object_create_anew_containing engine_fire_1)
	
	(object_teleport flood_1 flood_1_base)
	(object_teleport flood_2 flood_2_base)
	(object_teleport flood_3 flood_3_base)
	(object_teleport flood_4 flood_4_base)
	(object_teleport flood_5 flood_5_base)
	(object_teleport flood_6 flood_6_base)
	(object_teleport flood_7 flood_7_base)
	(object_teleport flood_8 flood_8_base)
	(object_teleport flood_9 flood_9_base)
	(object_teleport flood_10 flood_10_base)
	(object_teleport flood_11 flood_11_base)
	
	(ai_attach_free flood_1 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_2 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_3 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_4 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_5 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_6 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_7 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_8 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_9 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_10 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_11 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_12 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_13 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_14 "characters\floodcombat elite\floodcombat elite unarmed")
	(ai_attach_free flood_15 "characters\floodcombat elite\floodcombat elite unarmed")
	
	(object_pvs_activate flood_1)
	
	(fade_in 0 0 0 15)
	
	(camera_set watcher_1a 0)
	(camera_set watcher_1b 300)
	
	(wake flood_army_pyros)
	
	(ai_command_list_by_unit flood_1 flood_1_march)
	(sleep 5)
	(ai_command_list_by_unit flood_2 flood_2_march)
	(sleep 5)
	(ai_command_list_by_unit flood_3 flood_3_march)
	(sleep 5)
	(ai_command_list_by_unit flood_4 flood_4_march)
	(sleep 30)
	(ai_command_list_by_unit flood_5 flood_5_march)
	(sleep 5)
	(ai_command_list_by_unit flood_6 flood_6_march)
	(sleep 5)
	(ai_command_list_by_unit flood_7 flood_7_march)
	(sleep 30)
	(ai_command_list_by_unit flood_8 flood_8_march)
	(ai_command_list_by_unit flood_9 flood_9_march)
	(sleep 10)
	(ai_command_list_by_unit flood_10 flood_10_march)
	(ai_command_list_by_unit flood_11 flood_11_march)
	(sleep 5)
	
	(object_teleport flood_12 flood_5_base)
	(object_teleport flood_13 flood_6_base)
	(object_teleport flood_14 flood_7_base)
	(object_teleport flood_15 flood_8_base)
	
	(ai_command_list_by_unit flood_12 flood_8_march)
	(ai_command_list_by_unit flood_13 flood_9_march)
	(ai_command_list_by_unit flood_14 flood_10_march)
	(ai_command_list_by_unit flood_15 flood_11_march)
	
	(sleep 120)

	(object_create_anew fighter_launch)
	(object_set_scale fighter_launch .2 0)
	(scenery_animation_start fighter_launch cinematics\animations\h_fighter\x70\x70 x70_2)
	
	(effect_new "effects\explosions\large explosion" launch_pyro_base)
	
	(sleep 120)

	(object_destroy_containing flood)
)

(script dormant launch_2_pyro
	(effect_new "effects\explosions\large explosion" final_pyro_2a)
	(effect_new "effects\explosions\large explosion" final_pyro_2b)
	(effect_new "effects\explosions\large explosion" final_pyro_2c)
	(sleep 60)
	(object_create engine_fire_2a)
	(effect_new "effects\explosions\large explosion" final_pyro_3a)
	(effect_new "effects\explosions\large explosion" final_pyro_3b)
	(sleep 15)
	(effect_new "effects\explosions\large explosion" final_pyro_3c)
	(sleep 30)
	(object_create engine_fire_2c)
	(effect_new "effects\explosions\large explosion" final_pyro_3d)
	(effect_new "effects\explosions\large explosion" final_pyro_3e)
	(object_create engine_fire_2b)
	(sleep 60)
	(effect_new "effects\explosions\large explosion" final_pyro_4a)
	(sleep 30)
	(object_create engine_fire_3a)
	(effect_new "effects\explosions\large explosion" final_pyro_4b)
	(effect_new "effects\explosions\large explosion" final_pyro_4c)
)

(script static void launch_2

	(wake launch_2_pyro)

	(player_effect_set_max_rotation 0 .25 .25)
	(player_effect_start 1 0)
	
	(object_create_anew fighter_launch)
	(object_set_scale fighter_launch .25 0)
	(scenery_animation_start_at_frame fighter_launch cinematics\animations\h_fighter\x70\x70 x70_2 100)
	
	(object_pvs_activate fighter_launch)
	
	(camera_set launch_2_1a 0)
	(camera_set launch_2_1b 200)
	
	(sleep 185)
	
	(fade_out 1 1 1 15)
	
	(sleep 15)
	
	(object_destroy_containing engine_fire)
)

(script static void int_1

	(object_destroy fighter_launch)

	(player_effect_set_max_rotation 0 .4 .4)
	(player_effect_start 1 0)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_filter_desaturation_tint 1 1 1)
	(cinematic_screen_effect_set_filter 1 0 1 0 true 5)
	(cinematic_screen_effect_set_convolution 1 2 10 .001 5)
	
	(object_create_anew fighter_clouds)
	(object_pvs_activate fighter_clouds)
	
	(scenery_animation_start fighter_clouds cinematics\animations\h_fighter\x70\x70 x70_3)
	
	(camera_set haul_ass_1a 0)
	(camera_set haul_ass_1b 90)
	
	(fade_in 1 1 1 15)
	
	(sleep 90)
	
	(camera_set count_1c 0)
	(camera_set count_1d 60)
	
	(object_create_anew chief_unarmed)
	(object_create_anew fighter_space)
	
	(object_pvs_activate fighter_space)
	
	(objects_attach fighter_space "positionchief" chief_unarmed "")
	(objects_detach fighter_space chief_unarmed)
	(unit_suspended chief_unarmed true)
	(custom_animation chief_unarmed cinematics\animations\chief\x70\x70 "x70_5140" false)

	(sleep 90)
)

(script static void space_1

	(object_destroy fighter_clouds)

	(object_create_anew halo_1)
	(object_create_anew fighter_flee)
	(object_set_scale fighter_flee .1 0)

	(object_pvs_activate fighter_flee)
	(scenery_animation_start_at_frame fighter_flee cinematics\animations\h_fighter\x70\x70 x70_1 240)

	(camera_set halo_flee_1a 0)
	(camera_set halo_flee_1b 120)
	
	(sleep 90)
	
	(device_set_power halo_1 1)
	
	(sleep 45)
	
	(sound_looping_start sound\sinomatixx_foley\x70_foley2 none 1)
	
	(sleep 45)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_filter_desaturation_tint 1 1 1)
	(cinematic_screen_effect_set_filter 0 1 0 1 true 1)
	
	(sleep 30)
	
	(fade_out 1 1 1 15)
	(sleep 15)
)

(script static void int_2

	(object_pvs_activate chief_unarmed)

	(object_create_anew fighter_space)
	(object_create_anew chief_unarmed)
	(object_create_anew warning_panel)

	(object_pvs_activate chief_unarmed)

	(objects_attach fighter_space "positionchief" chief_unarmed "")
	(objects_detach fighter_space chief_unarmed)
	(unit_suspended chief_unarmed true)

	(camera_set temp_critical_1a 0)
	(camera_set temp_critical_1b 60)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_filter_desaturation_tint 1 1 1)
	(cinematic_screen_effect_set_filter 1 0 1 0 true 1)
	
	(fade_in 1 1 1 15)
	
	(sleep 60)
	
	(sound_impulse_start sound\dialog\x70\cor_18 none 1)
;	(print "cortana: Shut it down. We'll need them later.")
	
	(unit_stop_custom_animation chief_unarmed)
	(custom_animation chief_unarmed cinematics\animations\chief\x70\x70 "X70_5110" false)
	
	(camera_set temp_critical_2a 0)
	(camera_set temp_critical_2b 120)
	
	(sleep 120)
)

(script static void space_2

	(object_destroy chief_unarmed)
	(object_destroy warning_panel)
	(object_create_anew fighter_space)
	(object_create_anew_containing space_sparks_1)
	
	(object_set_scale fighter_space .25 0)

	(camera_set decel_1a 0)
	(camera_set decel_1b 180)
	
;	250 total
	(scenery_animation_start_at_frame fighter_space cinematics\animations\h_fighter\x70\x70 x70_4 40)
	
	(sleep (camera_time))
	
	(cinematic_screen_effect_stop)
	(object_destroy_containing space_sparks_1)
	
;	(print "shot done")
)

(script static void int_3

	(player_effect_set_max_rotation 0 .1 .1)

	(object_create_anew fighter_space)
	(object_create_anew chief_unarmed)
	
	(objects_attach fighter_space "positionchief" chief_unarmed "")
	(objects_detach fighter_space chief_unarmed)
	(unit_suspended chief_unarmed true)
	(custom_animation chief_unarmed cinematics\animations\chief\x70\x70 "x70_6000" false)
	
	(camera_set halo_look_a 0)
	(camera_set halo_look_b 250)
	
	(sleep 30)
	
	(sound_impulse_start sound\dialog\x70\cor_19 none 1)
;	(print "cortana: Fancy a look?")
	
	(sleep (- (camera_time) 150))
	
	(object_create_anew halo_1)
	(device_set_power halo_1 1)
	
	(sleep (camera_time))
)

(script static void space_3

	(player_effect_set_max_rotation 0 0 0)
	
	(object_destroy fighter_flee)
	(object_destroy fighter_space)
	(object_destroy chief_unarmed)
	
	(camera_set halo_fucked_1a 0)
	(camera_set halo_fucked_1b 400)
	(sleep 200)
	(camera_set halo_fucked_1c 250)
	(sleep 305)
	
	(sound_impulse_start sound\dialog\x70\che_03b chief_unarmed 1)
;	(print "chief: Did anyone else make it?")
;	(sleep (sound_impulse_time sound\dialog\x70\che_03b))
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_filter_desaturation_tint 1 1 1)
	(cinematic_screen_effect_set_filter 0 1 0 1 true 1)
	(sleep 30)
	
	(fade_out 1 1 1 15)
	(sleep 15)
)

(script dormant helmet
	(sleep 140)
	(object_create_anew x70_helmet)
	(objects_attach chief_unarmed "right hand" x70_helmet "cyborghelmet")
)

(script static void int_4

	(player_effect_set_max_rotation 0 .1 .1)

	(object_destroy halo_1)
	(object_destroy fighter_flee)

	(object_create_anew fighter_space)
	(object_create_anew chief_unarmed)
	
	(objects_attach fighter_space "positionchief" chief_unarmed "")
	(objects_detach fighter_space chief_unarmed)
	(unit_suspended chief_unarmed true)
	
	(object_beautify chief_unarmed true)
	
	(custom_animation chief_unarmed cinematics\animations\chief\x70\x70 "x70_6010" false)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_filter_desaturation_tint 1 1 1)
	(cinematic_screen_effect_set_filter 1 0 1 0 true 1)
	
	(sleep 30)
	
	(fade_in 1 1 1 15)

	(camera_set anyone_else_1a 0)
	(camera_set anyone_else_1b 250)
	
	(sound_impulse_start sound\dialog\x70\cor_21 none 1)
;	(print "cortana: Scanning...just dust and echoes....we're all that's left.")
;	(sleep (sound_impulse_time sound\dialog\x70\cor_21))
	
	(sleep 210)
	
	(camera_set chief_resolve_1a 0)
	(camera_set chief_resolve_1b 60)
	
	(sleep (sound_impulse_time sound\dialog\x70\cor_21))
	
	(sleep 30)
	
	(sound_impulse_start sound\dialog\x70\cor_23 none 1)
;	(print "cortana: We did what we had to do. For Earth. An entire Covenant armada--obliterated! And the Flood...we had no choice.")
;	(sleep (sound_impulse_time sound\dialog\x70\cor_23))

	(sleep 60)
	(camera_set slight_pull_1a 180)
	
	(sleep (unit_get_custom_animation_time chief_unarmed))
	
	(camera_set long_walk_1a 0)
	(camera_set long_walk_1b 200)
	
	(objects_attach fighter_space "positionchief" chief_unarmed "")
	(objects_detach fighter_space chief_unarmed)
	(unit_suspended chief_unarmed true)
	(custom_animation chief_unarmed cinematics\animations\chief\x70\x70 "x70_7000" false)
	
	(sleep (sound_impulse_time sound\dialog\x70\cor_23))
	
	(camera_set its_finished_1a 0)
	(camera_set its_finished_1b 120)
	(sleep 30)
	
	(sound_impulse_start sound\dialog\x70\cor_24 none 1)
;	(print "cortana: Halo...it's finished.")
	(sleep (sound_impulse_time sound\dialog\x70\cor_24))
	
	(objects_attach fighter_space "positionchief" chief_unarmed "")
	(objects_detach fighter_space chief_unarmed)
	(unit_suspended chief_unarmed true)
	
	(custom_animation chief_unarmed cinematics\animations\chief\x70\x70 "x70_7200" false)
	
	(sound_impulse_start sound\dialog\x70\che_05 none 1)
;	(print "chief: No. Our battle has just begun. ")
;	(sleep (sound_impulse_time sound\dialog\x70\che_05))

	(sound_looping_start sound\sinomatixx_foley\x70_helmet none 1)

	(wake helmet)
	
	(player_effect_stop 10) 
	
	(object_create_anew_containing space_sparks_2)
	
	(camera_set pull_back_1a 0)
	(camera_set pull_back_1b 200)
	
;	(object_create_anew space_debris_2)
	
	(sleep 100)
	(camera_set pull_back_1c 200)
	(sleep 100)
	(camera_set pull_back_1d 150)
	(sleep 75)
	(camera_set pull_back_1e 150)
	(sleep 75)
	(camera_set pull_back_1f 150)
	(sleep 75)
	(camera_set pull_back_1g 150)
	(sleep 75)
	(camera_set pull_back_1h 150)
	(sleep 150)
	(camera_set pull_back_1i 600)
	(sleep 100)
)


(script static void ring_test
	(int_3)
	(space_3)
)

(script dormant bridge_music_1
	(sleep 25)
	(sound_looping_start sound\sinomatixx_music\d40_bridge_music01 none 1)
)

(script static void x70_bridge

	(wake bridge_music_1)
	(sound_looping_start sound\sinomatixx_foley\d40_bridge_foley1 none 1)

	(fade_out 1 1 1 30)
	(sleep 30) 
	
;	(cinematic_screen_effect_start 1)
;	(cinematic_screen_effect_set_convolution 3 2 .25 .25 1)
	
	(cinematic_start)
	(camera_control on)
	
	(switch_bsp 1)
	
	(object_teleport (player0) player0_bridge_pause)
	(object_teleport (player1) player1_bridge_pause)
	
	(unit_suspended (player0) true) 
	(unit_suspended (player1) true) 
	
	(cinematic_set_near_clip_distance .01)

;	BEGIN "BRIDGE_1" SCENE
	(bridge_1)
	
	(switch_bsp 4)
	
;	BEGIN "MONITOR_1" SCENE
	(monitor_1)

	(switch_bsp 1)
	
	(breakable_surfaces_enable true)
	
	(sound_looping_start sound\sinomatixx_foley\d40_bridge_foley2 none 1)
	
;	BEGIN "BRIDGE_2" SCENE
	(bridge_2)
	
	(cinematic_screen_effect_stop)
	(cinematic_set_near_clip_distance .0625)
	
	(object_teleport (player0) player0_playon_base)
	(object_teleport (player1) player1_playon_base)
	
	(unit_suspended (player0) false) 
	(unit_suspended (player1) false) 
	
	(camera_control off)
	(cinematic_stop)
	
	(sleep 15)	
	
	(fade_in 1 1 1 15)
	(sleep 15)
)
	
(script static void x70_finale

	(cinematic_suppress_bsp_object_creation on)

	(player_effect_start 1 0)
	(player_effect_set_max_translation 0 0 0)
	(player_effect_set_max_rotation 0 0 0)
	(player_effect_set_max_vibrate 0 0)

	(sound_looping_start sound\sinomatixx_music\x70_music none 1)
	(sound_looping_start sound\sinomatixx_foley\x70_foley1 none 1)
	
	(object_destroy_containing nipple)
	
	(fade_out 1 1 1 50)
	(sleep 30)	
	(cinematic_start)
	(camera_control on)
	
	(switch_bsp 7)
	
	(object_teleport (player0) player0_finale_pause)
	(object_teleport (player1) player1_finale_pause)
	
	(unit_suspended (player0) true) 
	(unit_suspended (player1) true) 
	
;	BEGIN "HANGAR_1" SCENE
	(hangar_1)
	
;	BEGIN "HANGAR_2" SCENE
	(hangar_2)
	
	(sound_class_set_gain weapon_fire 0 0)
	(sound_class_set_gain projectile_detonation 0 0)
	(sound_class_set_gain projectile_impact 0 0)
	(sound_class_set_gain unit_dialog 0 0)
	
;	BEGIN "HANGAR_3" SCENE
	(hangar_3)
	
;	BEGIN MORE BLAM-PAIN THAN I EVER IMAGINED

	(if (= "easy" (game_difficulty_get_real))
	(begin
		(switch_bsp 8)
		(launch_1)
		(sound_class_set_gain unit_footsteps 0 0)
		(launch_2)
		(fade_out 0 0 0 0)
		(switch_bsp 9)
		(fade_in 0 0 0 0)
		(rasterizer_model_ambient_reflection_tint 1 1 1 1)
		(int_1)
		(space_1)
		(fade_in 1 1 1 15)
		(int_2)
		(space_2)
		(int_3)
		(space_3)
		(int_4)
		(fade_out 0 0 0 120)
		(sleep 520)
		(cinematic_screen_effect_stop)
		(rasterizer_model_ambient_reflection_tint 0 0 0 0)
		(print "cue credits")
	)
	)
	
	(if (= "normal" (game_difficulty_get_real))
	(begin
		(switch_bsp 8)
		(launch_1)
		(sound_class_set_gain unit_footsteps 0 0)
		(launch_2)
		(fade_out 0 0 0 0)
		(switch_bsp 9)
		(fade_in 0 0 0 0)
		(rasterizer_model_ambient_reflection_tint 1 1 1 1)
		(int_1)
		(space_1)
		(fade_in 1 1 1 15)
		(int_2)
		(space_2)
		(int_3)
		(space_3)
		(int_4)
		(fade_out 0 0 0 120)
		(sleep 520)
		(cinematic_screen_effect_stop)
		(rasterizer_model_ambient_reflection_tint 0 0 0 0)
		(print "cue credits")
	)
	)
	
	(if (= "hard" (game_difficulty_get_real))
	(begin
		(switch_bsp 8)
		(launch_1)
		(sound_class_set_gain unit_footsteps 0 0)
		(launch_2)
		(fade_out 0 0 0 0)
		(switch_bsp 9)
		(fade_in 0 0 0 0)
		(rasterizer_model_ambient_reflection_tint 1 1 1 1)
		(int_1)
		(space_1)
		(fade_in 1 1 1 15)
		(int_2)
		(space_2)
		(int_3)
		(space_3)
		(int_4)
		(fade_out 0 0 0 120)
		(sleep 520)
		(cinematic_screen_effect_stop)
		(rasterizer_model_ambient_reflection_tint 0 0 0 0)
		(print "cue credits")
	)
	)
	
;	HAPPY EASTER!
	
	(if (= "impossible" (game_difficulty_get_real))
	(begin
		(print "happy easter")
		(switch_bsp 8)
		(happy_easter)
		(switch_bsp 9)
		(fade_in 0 0 0 0)
		(rasterizer_model_ambient_reflection_tint 1 1 1 1)
		(int_1)
		(space_1)
		(fade_in 1 1 1 15)
		(int_2)
		(space_2)
		(int_3)
		(space_3)
		(int_4)
		(fade_out 0 0 0 120)
		(sleep 520)
		(cinematic_screen_effect_stop)
		(rasterizer_model_ambient_reflection_tint 0 0 0 0)
		(print "cue credits")
	)
	)
)

(script static void insertion_1

	(fade_out 0 0 0 0)

	(camera_set flyin_1 0)
	(camera_set flyin_2 200)
	
	(object_type_predict vehicles\banshee\banshee_cinematic)
	
	(sleep 60)
	
	(fade_in 0 0 0 60)
	
	(sleep 40)
	
	(camera_set flyin_3 200)
	(sleep 100)
	(camera_set flyin_4 200)
	(sleep 100)
	(camera_set flyin_5 200)
	(sleep 100)
	(camera_set flyin_6 200)
	(sleep 100)
	(camera_set flyin_7 200)
	(sleep 100)
	(camera_set flyin_8 250)
	(sleep 125)
	(camera_set flyin_9 250)
	(sleep 125)
	(camera_set flyin_10 250)
	(sleep 125)
	(camera_set flyin_11 250)
	(sleep 125)
	(camera_set flyin_12 200)
	(sleep 100)
	
	(object_create_anew intro_banshee)
	(unit_close intro_banshee)
	(object_teleport intro_banshee intro_banshee_base)
	(recording_play intro_banshee intro_banshee_flight)
	
	(sleep 100)
	
	(camera_set flyin_13 150)
	
	(sleep (- (camera_time) 30))
	
	(fade_out 0 0 0 30)
	
	(sleep 15)
	
	(recording_kill intro_banshee)
	(object_destroy intro_banshee)
)

(script dormant insertion_dialog
	(sound_impulse_start sound\dialog\d40\d40_insert_020_cortana none 1)
;	(print "cortana: This thing is about to fall-apart!")
	(sleep (sound_impulse_time sound\dialog\d40\d40_insert_020_cortana))

	(sound_impulse_start sound\dialog\d40\d40_insert_030_chief none 1)
;	(print "chief: It'll hold.")
	(sleep (sound_impulse_time sound\dialog\d40\d40_insert_030_chief))
	
	(sound_impulse_start sound\dialog\d40\d40_insert_040_cortana none 1)
;	(print "cortana: We're not going to make it!")
	(sleep (- (sound_impulse_time sound\dialog\d40\d40_insert_040_cortana) 15))

	(sound_impulse_start sound\dialog\d40\d40_insert_050_chief none 1)
;	(print "chief: We'll make it.")
	(sleep (sound_impulse_time sound\dialog\d40\d40_insert_050_chief))

	(sound_impulse_start sound\dialog\d40\d40_insert_060_cortana none 1)
;	(print "cortana: Pull up! Pull up!")
)

(script static void insertion_2
	
	(object_create_anew intro_banshee)
	(unit_close intro_banshee)
	
	(objects_predict chief_insertion)
	
	(camera_set chief_climb_1a 0)
	(camera_set chief_climb_1b 300)
	
	(object_pvs_activate intro_banshee)
	
	(sound_looping_start sound\sinomatixx_foley\d40_insertion_foley none 1) 
	
	(fade_in 0 0 0 30)
	
	(object_create_anew_containing banshee_fire)
	
	(sleep 75)
	
	(object_teleport intro_banshee banshee_base)
	(recording_kill intro_banshee)
	(recording_play intro_banshee banshee_approach)
	
	(sleep 75)
	
	(wake insertion_dialog)

	(camera_set chief_climb_2a 400)

	(sleep (- (camera_time) 150))
	
;	(print "boom")
	
	(sound_class_set_gain vehicle_engine 0 0)
	
	(player_effect_set_max_rotation 0 .3 .3)
	(player_effect_start 1 0)
	(effect_new "effects\explosions\large explosion" banshee_explosion)
	(sound_impulse_start sound\sfx\impulse\impacts\jeep_hit_solid none 1)
	(player_effect_stop 4)

	(object_destroy intro_banshee)
	
	(object_create_anew chief_insertion)
	(object_beautify chief_insertion true)
	
	(object_pvs_activate chief_insertion)
	
	(sleep 60)
	
	(sound_impulse_start sound\dialog\d40\d40_insert_070_cortana none 1)
;	(print "cortana: You did that on purpose, didn't you.")

	(sleep 40)
	
	(object_create_anew chief_insertion)
	(object_teleport chief_insertion chief_climbup_base)
	(unit_suspended chief_insertion true)
	(custom_animation chief_insertion cinematics\animations\chief\level_specific\d40\d40 d40climbup true)
	
	(sleep 180)
	
	(camera_set chief_climb_2b 0)
	(camera_set chief_climb_2c 120)
	(sleep (- (unit_get_custom_animation_time chief_insertion) 30))
)

(script startup food_nipple_test
	(sleep_until (volume_test_objects nipple_place (players)) 5)
	(object_create_anew nipple_grunt)
	(object_create_anew_containing nipple_flood)
	(object_create_anew_containing nipple_fire)
	(unit_set_seat nipple_grunt noncombat)
	(ai_attach_free nipple_grunt characters\captain\captain)
	(ai_command_list_by_unit nipple_grunt nipple_look)

	(sleep_until (volume_test_objects nipple_trigger (players)) 5)
	(sleep 150)
	(custom_animation nipple_grunt characters\grunt\grunt "stand pistol surprise-front" false)
	(sound_impulse_start sound\dialog\grunt\scripted\grunty_thirst nipple_grunt 1)
	(sleep (sound_impulse_time sound\dialog\grunt\scripted\grunty_thirst))
)

(script dormant insertion_music
	(sleep 26)
	(sound_looping_start sound\sinomatixx_music\d40_insertion_music none 1)
)

(script static void cutscene_insertion

	(fade_out 0 0 0 0)

	(camera_control on)
	(cinematic_start)
	
	(object_teleport (player0) player0_intro_base)
	(object_teleport (player1) player1_intro_base)
	
	(unit_suspended (player0) true)
	(unit_suspended (player1) true)
	
	(switch_bsp 8)
	
	(wake insertion_music)
	
;	BEGIN "INSERTION_1" SCENE
	(insertion_1)
	
	(switch_bsp 0)
	
; 	BEGIN "INSERTION_2" SCENE
	(insertion_2)
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(unit_suspended (player0) false)
	(unit_suspended (player1) false)
	
	(object_teleport (player0) player0_intro_done)
	(object_teleport (player1) player1_intro_done)
	
	(object_destroy chief_insertion)
	(object_destroy intro_banshee)
	
	(camera_control off)
	(cinematic_stop)

	(fade_in 1 1 1 15)
	
	(breakable_surfaces_reset)
	(breakable_surfaces_enable false)
	(sound_class_set_gain vehicle_engine 1 5)
)

(script static void cutscene_lose

	(sound_looping_stop levels\d40\music\d40_07)
	(sound_looping_stop levels\d40\music\d40_08)

	(sound_looping_start sound\sinomatixx_music\d40_lose_music none 1)
	(sound_looping_start sound\sinomatixx_foley\d40_lose_foley none 1)

	(fade_out 1 1 1 15)
	
	(sleep 15)
	
;	(cinematic_screen_effect_start 1)
;	(cinematic_screen_effect_set_convolution 3 2 .25 .25 1)
	
	(camera_control on)
	(cinematic_start)
	
	(unit_suspended (player0) true)
	(unit_suspended (player1) true)
	
	(switch_bsp 8)
	
	(camera_set game_lose_1a 0)
	(camera_set game_lose_1c 300)
	
	(fade_in 1 1 1 15)
	
	(sleep 30)
	
	(object_destroy poa_explosion)
	(object_create poa_explosion)
	
	(object_pvs_activate poa_explosion)
	
	(sleep 120)
	
	(player_effect_set_max_rotation 0 .5 .5)
	(player_effect_start 1 2 )
	 
	(sleep 120)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_filter_desaturation_tint 1 1 1)
	(cinematic_screen_effect_set_filter 0 1 0 1 true 1)
	
	(sleep 30)
	
	(fade_out 1 1 1 15)
	(sleep 30) 
	
	(cinematic_screen_effect_stop)
	
	(player_effect_stop 4)
	(object_destroy poa_explosion)
	
	(game_lost)
)
