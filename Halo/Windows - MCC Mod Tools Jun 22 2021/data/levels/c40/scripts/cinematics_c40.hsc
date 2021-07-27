;	c40 Cinematics

(script dormant chief_puzzled
	(sleep 60)
	(recording_play chief chief_puzzled)
)

(script dormant insertion_music_1
	(sleep 44)
	(sound_looping_start sound\sinomatixx_music\c40_insertion_music01 none 1)
)

(script static void return

	(wake insertion_music_1)
	
	(object_destroy chief)
	(object_destroy monitor)
	(object_destroy rifle)
	(object_destroy core)
	
	(object_create chief)
	(object_create monitor)
	(object_create rifle)
	
	(object_beautify chief true)
	(object_beautify monitor true)
	
	(objects_attach chief "right hand" rifle "")
	
	(object_set_scale chief .1 0)
	(object_set_scale monitor .1 0)
	
	(unit_set_seat chief alert)
	
	(camera_set enter_1a 0)
	(camera_set enter_1b 300)
	
	(fade_in 0 0 0 60)

	(sleep 150)
	
	(object_create_anew monitor_teleport_in)
	(device_set_position monitor_teleport_in 1)
	(sleep 15)
	(object_teleport monitor monitor_base)
	(object_set_scale monitor 1 15)
	
	(sound_class_set_gain vehicle .5 1)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_010_MONITOR none 1)
	(print "Monitor: ...which means that any organism with sufficient mass and cognitive capability is a potential vector.")
	(sleep (- (sound_impulse_time sound\dialog\c40\C40_insert_010_MONITOR) 90))
	
	(ai_attach_free monitor characters\monitor\monitor)
	(ai_command_list_by_unit monitor look_at_teleport)
	
	(object_create_anew chief_teleport_in)
	(device_set_position chief_teleport_in 1)
	(sleep 30)
	(object_teleport chief chief_base)
	(object_set_scale chief 1 15)
	
	(wake chief_puzzled)
	
	(sleep 90)

	(ai_command_list_by_unit monitor something_wrong)
	
	(camera_set something_wrong_1a 0)
	(camera_set something_wrong_1b 120)
	
	(sleep 60)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_030_MONITOR monitor 1)
	(print "Monitor: Is something wrong?")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_030_MONITOR))
	
	(camera_set chief_puzzled_1a 0)
	
	(sleep 30)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_040_CHIEF chief 1)
	(print "Chief: No...nothing.")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_040_CHIEF))
	
	(camera_set walk_1a 0)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_050_MONITOR monitor 1)
	(print "Monitor: Splendid! Shall we?")
	(sleep (- (sound_impulse_time sound\dialog\c40\C40_insert_050_MONITOR) 30))
	
	(ai_command_list_by_unit monitor monitor_fly_2)
	
	(camera_set walk_1b 300)
	
	(sleep 175)
	
	(sound_impulse_start "sound\dialog\monitor\monitor humming" monitor 1)
	
	(sleep 175)
	
	(camera_set walk_2a 0)
	(camera_set walk_2b 460)
	
	(recording_kill chief)
	(object_teleport chief chief_walk_cheat)
	(recording_play chief chief_walk_2)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_060_MONITOR none 1)
	(print "Monitor: Unfortunately, my usefulness to this particular endeavor has come to an end. Protocol does not allow units with my classification to perform a task as important as the reunification of the Index with the Core. ")
	
	(sleep_until (= 2 (ai_command_list_status monitor)) 1)
	(ai_command_list_by_unit monitor look_at_chief)
	
	
;	(sleep (camera_time))
	
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_060_MONITOR))
	
	(ai_command_list_by_unit monitor monitor_fly_3)
	
	(camera_set index_handoff_1a 0)
	(camera_set index_handoff_1b 120)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_070_MONITOR monitor 1)
	(print "Monitor: That final step is reserved for you, Reclaimer.")
	
	(recording_play chief chief_monitor_follow)
	(sleep_until (= 2 (ai_command_list_status monitor)) 1)
	(ai_command_list_by_unit monitor look_at_chief)
	
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_070_MONITOR))
)
	
(script static void handoff

	(object_pvs_activate chief)

	(object_destroy monitor)
	(object_create monitor)

	(object_teleport chief chief_console_base)
	(object_teleport monitor monitor_handoff_base)
	
	(ai_attach_free monitor characters\monitor\monitor)
	(ai_command_list_by_unit monitor look_at_chief)
	
	(camera_set index_handoff_2a 0)
	(camera_set index_handoff_2b 90)
	
	(sound_looping_start sound\sinomatixx_foley\c40_insertion_foley none 1)
	
	(recording_kill chief)
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip01-gettingindex" false)
	
	(sleep 30)
	(object_destroy index)
	(object_create index)
	(objects_attach chief "left hand" index "")
	(sleep 50)
	(object_destroy index)
	
	(camera_set false_glory_1a 0)
	(camera_set false_glory_1b 250)
	
	(ai_command_list_by_unit monitor watch_core)
	
	(recording_play chief core_look)
	
	(object_destroy core)
	(object_create core)
	(device_set_position core 1)
	(print "core up...")
	(sleep 200)
	(device_set_position core 0)
	(print "...core down")
	
	(sleep 60)
	
	(camera_set monitor_inspect_1a 0)
	(camera_set monitor_inspect_1b 120)
	
	(ai_command_list_by_unit monitor monitor_inspect)
	(sleep 60)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_080_MONITOR monitor 1)
	(print "Monitor: Odd. That wasn't supposed to happen.")
;	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_080_MONITOR))
	
	(sleep_until (= 2 (ai_command_list_status monitor)) 1)
	
	(object_create_anew cortana)
	(unit_set_emotion cortana 1)
	(unit_suspended cortana true)
	(object_set_scale cortana 5 60)
	
	(object_beautify cortana true)
	
	(object_teleport chief chief_console_base)
	(object_teleport monitor monitor_zap_end)
	
	(camera_set oh_really_1a 0)
	(camera_set oh_really_1b 60)
	
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip01-ohreally" true)
	(sound_impulse_start sound\dialog\c40\C40_insert_090_CORTANA cortana 1)
	(print "Cortana: Oh really? ")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_090_CORTANA))
	
	(ai_detach monitor)
	
	(object_destroy monitor)
	(object_create monitor)
	
	(object_teleport monitor monitor_zap_base)
	(unit_stop_custom_animation chief)
		
	(custom_animation monitor cinematics\animations\monitor\level_specific\c40\c40 "c40-clip01-monitorzapped" false)
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip02-monitorgettingzapped" false)
	
	(sound_impulse_start sound\sinomatixx\bash_monitor none 1)
	
	(fade_out 1 1 1 5)
	(device_set_position_immediate core 2)
	(player_effect_set_max_rotation 0 .4 .4)
	(player_effect_set_max_vibrate .5 .5)
	(player_effect_start 1 0)
	(player_effect_stop 4)
	(sleep 5)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_filter_desaturation_tint 1 1 0)
	(cinematic_screen_effect_set_filter 1 0 1 0 true 1)
	(cinematic_screen_effect_set_convolution 1 2 10 .001 1)
	(fade_in 1 1 1 15)
	
	(camera_set blow_back_1a 0)
	(camera_set blow_back_1b 30)
	(sleep 60)
	(cinematic_screen_effect_stop)
)

(script static void teleport
(effect_new cinematics\effects\teleportation\teleportation monitor_base)
)

(script static void handoff_test
(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip01-gettingindex" true)
)

(script static void zap
(object_teleport chief chief_console_base)
(object_teleport monitor monitor_zap_base)
(custom_animation monitor cinematics\animations\monitor\level_specific\c40\c40 "c40-clip01-monitorzapped" false)
(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip02-monitorgettingzapped" false)
)

(script dormant animation_fix_1
	(sleep (unit_get_custom_animation_time chief))
;	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip07-loopidle" false)
)

(script static void chill_woman

	(object_destroy core)
	
	(object_create_anew chief)
	(object_create_anew cortana)
	(object_create_anew monitor)
	(object_create_anew rifle)
	
	(object_beautify cortana true)
	
	(unit_set_seat chief alert)
	
	(object_teleport chief chief_console_base)
	(unit_set_emotion cortana 1)
	(unit_suspended cortana true)
	(object_set_scale cortana 5 0)
	(object_teleport monitor monitor_zap_end)
	
	(objects_attach chief "right hand" rifle "")

	(device_set_position core 0)
	
	(unit_stop_custom_animation chief)	
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip03-loopidle" false)
	
	(camera_set cortana_1a 0)
	(camera_set cortana_1b 30)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_100_CHIEF chief 1)
	(print "Chief: Cortana!")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_100_CHIEF))
	
	(sound_looping_start sound\sinomatixx_music\c40_insertion_music02 none 1)
	
	(camera_set throats_1a 0)
	(camera_set throats_1b 200)
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip02-ivespent" true)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_110_CORTANA cortana 1)
	(print "Cortana: I've spent the last 12 hours cooped up in here watching you toady about, helping that thing get set to slit our throats!")
	(sleep (- (sound_impulse_time sound\dialog\c40\C40_insert_110_CORTANA) 30))
	
	(ai_attach_free monitor characters\monitor\monitor)
	(ai_command_list_by_unit monitor a_little_woozy)
	
	(camera_set a_friend_1a 0)
	(camera_set a_friend_1b 120)
	
	(unit_stop_custom_animation chief)	
	(unit_custom_animation_at_frame chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip04-hesafriend" true 15)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_120_CHIEF chief 1)
	(print "Chief: Hold on--he's a friend.")
	(sleep (- (sound_impulse_time sound\dialog\c40\C40_insert_120_CHIEF) 15))
	
	(sleep 30)
	
	(camera_set cortana_cu_2b 0)
	(camera_set cortana_cu_2a 200)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip03-ohi" true)
	(sound_impulse_start sound\dialog\c40\C40_insert_130_CORTANA cortana 1)
	(print "Cortana: Oh! I didn't realize. He's your pal is he? Your chum?")
	(unit_set_emotion cortana 5)
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_130_CORTANA))
	
	(unit_stop_custom_animation chief)	
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip05-loopidle" true)
	
	(camera_set that_bastard_1b 0)
	(camera_set that_bastard_1a 60)
	
	(unit_set_emotion cortana 1)
	(sound_impulse_start sound\dialog\c40\C40_insert_140_CORTANA cortana 1)
	(print "Cortana: Do you have any idea what that bastard almost made you do?!")
	(sleep (- (sound_impulse_time sound\dialog\c40\C40_insert_140_CORTANA) 30))
	
	(unit_stop_custom_animation chief)	
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40yes" false)
	
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_140_CORTANA))
	
	(camera_set brought_index_1b 0)
	(camera_set brought_index_1a 250)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_150_CHIEF chief 1)
	(print "Chief: Yes. Activate Halo's defenses, and destroy the Flood. Which is why we brought the Index--")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_150_CHIEF))
	
	(object_create_anew index_holo)
	(objects_attach cortana "right hand" index_holo "")
	
	(camera_set you_mean_this_1a 0)
	(camera_set you_mean_this_1b 60)
	
	(unit_set_emotion cortana 4)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip04-youmean" true)
	(sound_impulse_start sound\dialog\c40\C40_insert_160_CORTANA cortana 1)
	(print "Cortana: You mean this?")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_160_CORTANA))
	
	(sleep 30)
	
	(camera_set a_construct_1a 0)
	(camera_set a_construct_1b 150)
	
	(ai_command_list_by_unit monitor look_at_cortana)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_170_MONITOR monitor 1)
	(print "Monitor: A construct? In the Core? That is absolutely unacceptable!")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_170_MONITOR))
	
	(camera_set sod_off_1a 0)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip05-sodoff" true)
	(sound_impulse_start sound\dialog\c40\C40_insert_180_CORTANA cortana 1)
	(print "Cortana: Sod off.")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_180_CORTANA))
	
	(ai_command_list_by_unit monitor impertinence)
	
	(unit_stop_custom_animation chief)
	(recording_play chief monitor_rise_look)
	
	(camera_set monitor_up_1a 0)
	(camera_set monitor_up_1b 90)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_190_MONITOR monitor 1)
	(print "Monitor: What impertinence! I shall purge you at once.")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_190_MONITOR))
	
	(camera_set you_sure_1a 0)
	(camera_set you_sure_1b 60)

	(unit_set_emotion cortana 2)
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip06-yousure" true)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_200_CORTANA cortana 1)
	(print "Cortana: You sure that's a good idea?")
	(sleep (- (sound_impulse_time sound\dialog\c40\C40_insert_200_CORTANA) 30))

	(object_set_scale index_holo .001 30) 
	(effect_new_on_object_marker "cinematics\effects\cyborg chip insertion" cortana "right hand")
	(sleep 30)	
	(object_destroy index_holo)
	
	(sleep 30)
	
	(camera_set how_dare_1a 0)
	(camera_set how_dare_1b 60)
	
	(recording_play chief monitor_angry_look)
	
	(ai_command_list_by_unit monitor how_dare)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_210_MONITOR monitor 1)
	(print "Monitor: How...how dare you?! I'll--")
	(sleep (- (sound_impulse_time sound\dialog\c40\C40_insert_210_MONITOR) 15))
	
	(unit_set_emotion cortana 1)
	(unit_stop_custom_animation cortana)
	
	
	(camera_set do_what_1a 0)
	(camera_set do_what_1b 150)
	
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip07-dowhat" true)
	(sound_impulse_start sound\dialog\c40\C40_insert_220_CORTANA cortana 1)
	(print "Cortana: Do what?! I have the Index. You can just float and sputter!")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_220_CORTANA))
	
	(unit_stop_custom_animation chief)
	(unit_custom_animation_at_frame chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip06-enough" true 30)
	
	(camera_set enough_1a 0)
	(camera_set enough_1b 120)
	
	(ai_command_list_by_unit monitor look_at_chief)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_230_CHIEF chief 1)
	(print "Chief: Enough!")

	(sleep 120)
	
;	(unit_stop_custom_animation chief)
;	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip07-loopidle" true)
	
	(camera_set flood_spread_1b 0)
	(camera_set flood_spread_1a 180)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_240_CHIEF chief 1)
	(print "Chief: The Flood is spreading. If we activate Halo's defenses we can wipe them out.")
	
	(wake animation_fix_1)
	
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_240_CHIEF))
	
	(camera_set chief_rev_2a 0)
	(camera_set chief_rev_2b 300)
	
	(ai_command_list_by_unit monitor monitor_shocked)
	(unit_set_emotion cortana 4)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip08-youhave" true)

	(sound_impulse_start sound\dialog\c40\C40_insert_250_CORTANA cortana 1)
	(print "Cortana: You have no idea how this ring works do you? Why the Forerunners built it? Halo doesn't kill Flood, it kills their food! ")
	(sleep (unit_get_custom_animation_time cortana))
	
	(camera_set equally_edible_1a 0)
	(camera_set equally_edible_1b 200)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip09-humans" true)
	(sound_impulse_start sound\dialog\c40\C40_insert_260_CORTANA cortana 1)
	(print "Cortana: Humans, Covenant--whatever! We're all equally edible. The only way to stop the flood is to starve them to death.")
	(sleep (unit_get_custom_animation_time cortana))
	
	(camera_set nice_ass_1a 0)
	(camera_set cortana_rev_1b 300)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip10-andthats" true)
	(sound_impulse_start sound\dialog\c40\C40_insert_270_CORTANA cortana 1)
	(print "Cortana: And that's exactly what Halo is designed to do: wipe the galaxy clean of all sentient life.")
	(sleep (unit_get_custom_animation_time cortana))
	
	(camera_set ask_him_1a 0)
	(camera_set ask_him_1b 60)
	
	(unit_set_emotion cortana 4)
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip11-youdont" true)
	(sound_impulse_start sound\dialog\c40\C40_insert_280_CORTANA cortana 1)
	(print "Cortana: You don't believe me? Ask him!")
	(sleep (- (sound_impulse_time sound\dialog\c40\C40_insert_280_CORTANA) 30))
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip08-isittrue" true)
		
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_280_CORTANA))
		
	(sound_impulse_start sound\sinomatixx_foley\c40_chief_shuffle none 1)
		
	(camera_set true_1a 0)
	(camera_set true_1b 150)
	
	(sleep 150)
	
	(object_teleport monitor monitor_explain)
	(ai_attach_free monitor characters\monitor\monitor)
	(ai_command_list_by_unit monitor look_at_chief)
		
	(sound_impulse_start sound\dialog\c40\C40_insert_290_CHIEF chief 1)
	(print "Chief: Is it true?")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_290_CHIEF))
)

(script dormant chip_insert
	(sleep 259)
	(object_destroy cortana_chip)
	(effect_new_on_object_marker "cinematics\effects\cyborg chip insertion" chief "left hand")
)

(script static void revelation

	(object_beautify chief true)
	(object_beautify monitor true)

	(unit_set_emotion cortana 1)
	(unit_suspended cortana true)
	(object_set_scale cortana 5 0)	
	
;	(objects_attach chief "right hand" rifle "")
	
	(object_pvs_activate chief)
	
	(camera_set monitor_moreorless_1 0)
	(camera_set monitor_moreorless_2 500)
	
	(sleep 30)
		
	(sound_impulse_start sound\dialog\c40\C40_insert_300_MONITOR monitor 1)
	(print "Monitor: More or less. Technically this installation's pulse has a maximum effective radius of 25,000 light-years. But once the others follow suit, this galaxy will be quite devoid of life--or at least any life with sufficient bio-mass to sustain the Flood.")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_300_MONITOR))
	
;	(unit_stop_custom_animation chief)
;	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip09-loopidle" true)
	
	(camera_set other_shoe_1a 0)
	(camera_set other_shoe_1b 60)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_310_MONITOR monitor 1)
	(print "Monitor: But you already knew that.")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_310_MONITOR))
	
	(sleep 20)
	
	(object_teleport chief chief_othershoe_base)
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip10-howcouldnt" false)
	
	(sleep 10)
	
	(camera_set couldnt_you_1a 0)
	(camera_set couldnt_you_1b 30)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_320_MONITOR monitor 1)
	(print "Monitor: I mean, how couldn't you?")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_320_MONITOR))
	
	(unit_set_emotion cortana 4)
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip12-leftout" false)
	
	(sleep 5)
	
	(camera_set little_detail_1a 0)
	(camera_set little_detail_1b 90)
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip11-loopidle" true)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_330_CORTANA cortana 1)
	(print "Cortana: Left out that little detail did he?")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_330_CORTANA))
	
	(camera_set et_tu_chief_1a 0)
	(camera_set et_tu_chief_1b 200)
	
	(sound_looping_start sound\sinomatixx_music\c40_insertion_music03 none 1)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_340_MONITOR monitor 1)
	(print "Monitor: We have followed outbreak-containment procedure to the letter....You were with me each step of the way as we managed this  crisis...")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_340_MONITOR))
	
;	(camera_set movement_1a 0)
	(camera_set movement_1b 0)

	(unit_set_emotion cortana 6)
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip13-chiefim" true)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_350_CORTANA cortana 1)
	(print "Cortana: Chief, I'm picking up movement...")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_350_CORTANA))
	
	(camera_set hesitate_1a 0)
	(camera_set hesitate_1b 120)
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip11-loopidle" true)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_360_MONITOR monitor 1)
	(print "Monitor: Why would you hesitate to do what you have already done?")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_360_MONITOR))
	
	(unit_set_emotion cortana 5)
	
	(camera_set out_right_now_1a 0)
	
	(unit_stop_custom_animation cortana)
	(custom_animation cortana cinematics\animations\cortana\level_specific\c40\c40 "c40-clip14-weneed" true)
	(sound_impulse_start sound\dialog\c40\C40_insert_370_CORTANA cortana 1)
	(print "Cortana: We need to go. Right now.")
	(sleep (- (sound_impulse_time sound\dialog\c40\C40_insert_370_CORTANA) 30))
	
	(unit_stop_custom_animation chief)
	(object_teleport chief chief_console_base)
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40-clip12-chiefimpickin" false)
	(wake chip_insert)
		
	(object_destroy sentinel_1)
	(object_destroy sentinel_2)
	(object_destroy sentinel_3)
	(object_destroy sentinel_4)
	
	(object_create sentinel_1)
	(object_create sentinel_2)
	(object_create sentinel_3)
	(object_create sentinel_4)
	
	(object_teleport sentinel_1 sentinel_1_base)
	(object_teleport sentinel_2 sentinel_2_base)
	(object_teleport sentinel_3 sentinel_3_base)		
	(object_teleport sentinel_4 sentinel_4_base)
	
	(ai_attach_free sentinel_1 characters\monitor\monitor)
	(ai_attach_free sentinel_2 characters\monitor\monitor)
	(ai_attach_free sentinel_3 characters\monitor\monitor)
	(ai_attach_free sentinel_4 characters\monitor\monitor)
	
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_370_CORTANA))
	
	(camera_set sentinels_1a 0)

	(sound_impulse_start sound\dialog\c40\C40_insert_380_MONITOR monitor 1)
	(print "Monitor: Last time you asked me: 'If it were my choice, would I do it?' Having had considerable time to ponder your query, my answer has not changed: there is no choice. We must activate the ring.")
	
	(object_set_scale cortana .1 15)
	(object_set_scale index_holo .1 15)
	
	(camera_set sentinels_1b 300)
	(ai_command_list_by_unit sentinel_1 sentinel_1)
	(sleep 25)
	
	(object_destroy cortana)
	(object_destroy index_holo)
	(cinematic_screen_effect_stop)
	
;	(ai_command_list_by_unit sentinel_3 sentinel_3)
	(sleep 25)
	(ai_command_list_by_unit sentinel_2 sentinel_2)
	(sleep 25)
;	(ai_command_list_by_unit sentinel_4 sentinel_4)
	(sleep 75)
	(camera_set sentinels_1c 200)
	
	(sleep 70)
	
	(ai_command_list_by_unit sentinel_3 sentinel_3)
	(ai_command_list_by_unit sentinel_4 sentinel_4)
	
	(object_destroy cortana)
	(object_destroy cortana_chip)
	(object_destroy index_holo)
	(object_create cortana_chip)
	(objects_attach chief "left hand" cortana_chip "")
	(sleep 30)
	(camera_set sentinels_1d 180)
	
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_380_MONITOR))
	
	(camera_set get_us_out_1a 0)
	(camera_set get_us_out_1b 60)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_390_CORTANA cortana 1)
	(print "Cortana: Get-us-out-of-here!")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_390_CORTANA))
	
	(camera_set unwilling_1b 0)
	(camera_set unwilling_1a 300)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_400_MONITOR monitor 1)
	(print "Monitor: If you are unwilling to help, I will simply find another. Still I must have the Index. Give your construct to me, or I will be forced to take her from you.")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_400_MONITOR))
	
	(camera_set not_happen_1a 0)
	(camera_set not_happen_1b 60)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_410_CHIEF chief 1)
	(print "Chief: That's not going to happen.")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_410_CHIEF))
	
	(camera_set final_words_1a 0)
	(camera_set final_words_1b 200)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_420_MONITOR monitor 1)
	(print "Monitor: So be it. ")
	(sleep (sound_impulse_time sound\dialog\c40\C40_insert_420_MONITOR))
	(sleep 30)
	
	(object_create_anew monitor_teleport_out)
	
	(sound_impulse_start sound\dialog\c40\C40_insert_430_MONITOR monitor 1)
	(print "Monitor: Save his head. Dispose of the rest.")
	(sleep (- (sound_impulse_time sound\dialog\c40\C40_insert_430_MONITOR) 30))
	
	(device_set_position monitor_teleport_out 1)
	(sleep 15)

	(object_set_scale monitor .1 15)
	(sleep 15)
	
	(object_destroy monitor)	
	
	(cinematic_set_near_clip_distance .01)
	
	(sleep 15)
	
	(camera_set chief_zoom_1a 0)
	(sleep 30)
	(camera_set chief_zoom_1b 30)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_convolution 3 2 1 10 1)
		
	(sleep 15)
	(fade_out 1 1 1 15)
	(sleep 30)
	
	(cinematic_set_near_clip_distance .0625)
	
	(camera_control off)
	(cinematic_stop)
)


(script static void cutscene_insertion

	(rasterizer_model_ambient_reflection_tint 1 1 1 1)
	(sound_class_set_gain ambient_nature 0 0)
	(sound_class_set_gain vehicle 0 0)

	(objects_predict chief)
	(objects_predict monitor)
	(objects_predict cortana)
	
	(object_beautify chief true)
	(object_beautify sentinel_1 true)

	(fade_out 0 0 0 0)
	
	(switch_bsp 2)
	
	(object_teleport (player0) player0_insertion_safe)
	(object_teleport (player1) player0_insertion_safe)
	
	(cinematic_start)
	(camera_control on)

;	BEGIN "INTRO_1" SCENE
	(return)
	
;	BEGIN "INTRO_1" SCENE
	(handoff)
	
;	BEGIN "INTRO_2" SCENE
	(chill_woman)
	
;	BEGIN "INTRO_3" SCENE
	(revelation)
	
	(camera_control off)
	(cinematic_stop)
	
	(object_destroy chief)
	(object_destroy sentinel_1)
	(object_destroy sentinel_2)
	(object_destroy sentinel_3)
	(object_destroy sentinel_4)
	(object_destroy rifle)
	
	(object_teleport (player0) player0_start)
	(object_teleport (player1) player1_start)
	
	(cinematic_screen_effect_stop)
	(rasterizer_model_ambient_reflection_tint 0 0 0 0)
	
	(sleep 15)
	
	(fade_in 1 1 1 15)
	
	(sound_class_set_gain ambient_nature 1 3)
)

(script dormant extraction_music
	(sleep 14)
	(sound_looping_start sound\sinomatixx_music\c40_extraction_music none 1)
)

(script static void cutscene_extraction

	(wake extraction_music)

	(fade_out 1 1 1 15)
	(sleep 15)
	
	(rasterizer_model_ambient_reflection_tint 1 1 1 1)
	
	(switch_bsp 5)
	
	(object_teleport (player0) player0_extract_base)
	(object_teleport (player1) player1_extract_base)
	
	(object_create_anew chief)
	(object_create_anew rifle)
	
	(object_beautify chief true)
	(objects_predict chief)
	
	(object_teleport chief chief_extraction_base)
	(objects_attach chief "right hand" rifle "")
	
	(cinematic_start)
	(camera_control on)
	
	(camera_set ex_zoom_1a 0)
	(camera_set ex_zoom_1b 120)
	
	(fade_in 1 1 1 15)
	
	(sleep (camera_time))
	
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40extract01" false)
	
	(sound_impulse_start sound\dialog\c40\C40_extract_010_Chief chief 1)
	(print "Chief: Let's find a ride, and get to the Captain.")
	
	(camera_set better_idea_1b 0)
	(camera_set better_idea_1a 180)
	
	(sleep (sound_impulse_time sound\dialog\c40\C40_extract_010_Chief))
	
	(sound_impulse_start sound\dialog\c40\C40_extract_020_Cortana none 1)
	(print "Cortana: No, that'll take too long.")
	(sleep (sound_impulse_time sound\dialog\c40\C40_extract_020_Cortana))
	
	(sound_impulse_start sound\dialog\c40\C40_extract_030_Chief chief 1)
	(print "Chief: You have a better idea?")
	(sleep (sound_impulse_time sound\dialog\c40\C40_extract_030_Chief))
	
	(camera_set grid_1a 0)
	(camera_set grid_1b 300)
	
	(sound_impulse_start sound\dialog\c40\C40_extract_040_Cortana none 1)
	(print "Cortana: There's a teleportation grid that runs throughout Halo. That's how the Monitor moves about so quickly.")
	
;	(sleep 150)
	
;	(custom_animation chief cinematics\animations\chief\level_specific\a50\a50 "idle_shoulder gun" true)
	
	(sleep (sound_impulse_time sound\dialog\c40\C40_extract_040_Cortana))
	
	(camera_set grid_1c 300)
		
	(sound_impulse_start sound\dialog\c40\C40_extract_050_Cortana none 1)
	(print "Cortana: I learned how to tap into the grid when I was in the Core. Unfortunately, each jump requires...")
	
	(sleep (sound_impulse_time sound\dialog\c40\C40_extract_050_Cortana))
	
	(camera_set tells_me_1a 0)
	(camera_set tells_me_1b 180)
	
	(unit_stop_custom_animation chief)
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40extract02" true)
	
	(sound_impulse_start sound\dialog\c40\C40_extract_060_Chief chief 1)
	(print "Chief: Something tells me I'm not going to like this.")
	(sleep (sound_impulse_time sound\dialog\c40\C40_extract_060_Chief))
	
	(sound_impulse_start sound\dialog\c40\C40_extract_070_Cortana none 1)
	(print "Cortana: -- but I'm pretty sure I can pull it from your suit without permanently damaging your shields.")
	(sleep (sound_impulse_time sound\dialog\c40\C40_extract_070_Cortana))
	
	(camera_set only_once_1a 0)
	(camera_set only_once_1b 120)
	
	(sound_impulse_start sound\dialog\c40\C40_extract_080_Cortana none 1)
	(print "Cortana: Needless to say, I think we should only try this once.")
	(sleep (sound_impulse_time sound\dialog\c40\C40_extract_080_Cortana))
	
	(custom_animation chief cinematics\animations\chief\level_specific\c40\c40 "c40yes" true)
	
	(camera_set do_it_1a 0)
	(camera_set do_it_1b 150)
	
	(sound_impulse_start sound\dialog\c40\C40_extract_090_Chief chief 1)
	(print "Chief: Do it.")
	(sleep (sound_impulse_time sound\dialog\c40\C40_extract_090_Chief))
	
	(object_create_anew chief_teleport_out)
	(device_set_position chief_teleport_out 1)
	
	(sleep 30)
	
	(object_set_scale chief .1 15)
	
	(sleep 30)
	
	(object_destroy chief)
	(object_destroy rifle)
	
	(sleep (- (camera_time) 15))

	(fade_out 0 0 0 15)
	(sleep 125)
	
	(rasterizer_model_ambient_reflection_tint 0 0 0 0)
	
;	(game_won)
)

;	BERNIE'S FIX
;	rasterizer_model_ambient_reflection_tint
;	<brightness>, <red>, <green>, <blue>
;	should set brightness to 1 and red green blue to whatever
;	all back to 0 when the cutscene ends!
