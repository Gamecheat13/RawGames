;	D20 CINEMATICS

(script dormant oops
	(sound_impulse_start sound\dialog\d20\D20_insert_052_cortana none 1)
	(print "cortana: Oh, I see! The coordinate data needs to be--")
	(sleep (sound_impulse_time sound\dialog\d20\D20_insert_052_cortana))
	(print "cortana done")
	
	(sleep 30)
	
	(sound_impulse_start sound\dialog\d20\D20_insert_053_cortana none 1)
	(print "cortana: Right. Sorry.")
)


(script static void cutscene_insertion
	
	(sound_class_set_gain weapon_fire .3 0)
	(sound_class_set_gain projectile_detonation .3 0)
	(sound_class_set_gain projectile_impact .3 0)
	(sound_class_set_gain unit_footsteps .3 0)
	(sound_class_set_gain unit_dialog 0 0)
	(sound_class_set_gain ambient_nature .3 0)
	(sound_class_set_gain ambient_machinery .3 0)
	
	(objects_predict chief)
	(objects_predict rifle)

	(fade_out 0 0 0 0)

	(camera_control on)
	(cinematic_start)

	(object_teleport (player0) player0_insert_base)
	(object_teleport (player1) player1_insert_base)

	(unit_suspended (player0) true)
	(unit_suspended (player1) true)
	
	(switch_bsp 1)	
	
	(camera_set fly_1a 0)
	(object_pvs_set_camera fly_1a)
	
	(sleep 5)
	
	(sound_looping_start sound\sinomatixx_music\d20_insertion_music none 1)
	(sound_looping_start sound\sinomatixx_foley\d20_insertion_foley none 1)

	(sleep 25)

	(camera_set fly_1b 250)
	(object_pvs_set_camera fly_1b)
	
	(fade_in 0 0 0 30)

	(sound_impulse_start sound\dialog\d20\D20_insert_010_cortana none 1)
;	(print "cortana: From what I've been able to piece together from the Covenant network, they ordered all their ships to lift off from Halo when they found the Flood. They were too late.")
;	(sleep (sound_impulse_time sound\dialog\d20\D20_insert_010_cortana))

	(sleep 125)
	
	(camera_set fly_1c 250)
	(object_pvs_set_camera fly_1c)
	(sleep 125)

	(camera_set fly_1d 250)
	(object_pvs_set_camera fly_1d)
	(sleep 125)
	
	(sound_impulse_start sound\dialog\d20\D20_insert_020_cortana none 1)
;	(print "cortana: The Flood captured a Covenant dropship and rammed one of the fleeing cruisers. The Flood boarded, and as a result of the battle, they crashed here.  The Flood and Covenant are locked in fierce fighting as they each try to repair the ship and get off Halo.")
;	(sleep (sound_impulse_time sound\dialog\d20\D20_insert_020_cortana))

	(camera_set fly_1e 250)
	(object_pvs_set_camera fly_1e)
	(sleep 125)
	
	(camera_set fly_1f 250)
	(object_pvs_set_camera fly_1f)
	(sleep 125)

	(camera_set fly_1g 250)
	(object_pvs_set_camera fly_1g)
	(sleep 125)
	
	(sound_impulse_start sound\dialog\d20\D20_insert_030_cortana none 1)
;	(print "cortana: I traced Captain Keyes' CNI transponder signal here. We need to recover his neural implants...they contain the codes that will allow us to initiate a cascade failure in the Pillar of Autumn's fusion drives. I can use Halo's teleporters to put us near his signal...but I must caution you: I'm reading interference from the Covenant ship's reactor...I'm not sure how close I can get us..")
;	(sleep (sound_impulse_time sound\dialog\d20\D20_insert_030_cortana))
	
	(camera_set fly_1h 250)
	(object_pvs_set_camera fly_1h)
	(sleep 125)
	(camera_set fly_1i 200)
	(object_pvs_set_camera fly_1i)
	(sleep 100)
	(camera_set fly_1j 200)

	(sleep 100)

	(object_create_anew chief_teleport_in)
	(device_set_position chief_teleport_in 1)
	
	(fade_out 1 1 1 15)
	(sleep 15)

	(object_destroy pvs_rifle)
	(object_create pvs_rifle)

	(object_pvs_set_object pvs_rifle)
	
	(switch_bsp 0)
	
	(object_create_anew chief_spot)
	(object_create_anew chief)
	(object_create_anew rifle)
	
	(object_set_scale chief .1 0)
	
	(object_beautify chief true)
	(rasterizer_model_ambient_reflection_tint 1 1 1 1)
	
	(objects_attach chief "right hand" rifle "")
	
	(camera_set teleport_1a 0)
	(camera_set teleport_1b 200)
	
;	(sound_looping_start sound\sinomatixx_foley\d20_insertion_foley2 none 1)
	
	(fade_in 1 1 1 15)
	(sleep 10)
	
	(sound_looping_start sound\sinomatixx_foley\d20_insertion_foley2 none 1)
	
	(sleep 5)
	
	(object_teleport chief chief_insert_base)
	(custom_animation chief cinematics\animations\chief\level_specific\d20\d20 d20badteleport false)
	
	(sleep 30)
	
	(object_set_scale chief 1 0)
	
	(sleep 30)
	
	(camera_set teleport_1c 30)
	(sleep 60)
	(camera_set teleport_1d 0)
	
	(camera_set teleport_1e 120)
	(sleep 80)
	
	(wake oops)
	
	(sleep 40)
	(camera_set teleport_1f 0)
	(camera_set teleport_1g 120)
	
	(sleep (- (unit_get_custom_animation_time chief) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(rasterizer_model_ambient_reflection_tint 0 0 0 0)
	
	(object_destroy chief)
	(object_destroy rifle)
	(object_destroy pvs_rifle)
	(object_destroy chief_spot)
	(object_pvs_clear)
	
	(object_teleport (player0) chief_insert_base)
	(object_teleport (player1) player1_start_base)

	(unit_suspended (player0) false)
	(unit_suspended (player1) false)

	(camera_control off)
	(cinematic_stop)
	
	(fade_in 1 1 1 30)
	
	(sound_class_set_gain weapon_fire 1 3)
	(sound_class_set_gain projectile_detonation 1 3)
	(sound_class_set_gain projectile_impact 1 3)
	(sound_class_set_gain unit_footsteps 1 3)
	(sound_class_set_gain unit_dialog 1 3)
	(sound_class_set_gain ambient_nature 1 3)
	(sound_class_set_gain ambient_machinery 1 3)
	
	(object_create keyes_flood)
)

(script static void teleport_test
	(object_destroy chief)
	(object_create chief)
	(object_teleport chief chief_insert_base)
	(custom_animation chief cinematics\animations\chief\level_specific\d20\d20 d20badteleport false)
	(sleep (- (unit_get_custom_animation_time chief) 15))
)

(script dormant captain_music
	(sleep 18)
	(sound_looping_start sound\sinomatixx_music\d20_captain_music none 1)
)

(script static void cutscene_captain
	
	(sound_looping_start sound\sinomatixx_foley\d20_captain_foley none 1)

	(wake captain_music)

	(objects_predict chief)
	(objects_predict rifle)
	(objects_predict keyes_flood)

	(fade_out 1 1 1 15)

	(camera_control on)
	(cinematic_start)

	(sleep 15)
	
	(switch_bsp 4)

	(object_teleport (player0) player0_capt_base)
	(object_teleport (player1) player1_capt_base)
	
	(object_create_anew chief_armed)
	(object_create_anew rifle)
	(object_create_anew keyes_flood)
	
	(object_teleport chief_armed chief_capt_base)
	(objects_attach chief_armed "right hand" rifle "")
	
	(object_beautify chief true)
	(object_beautify keyes_flood true)
	
	(recording_play chief_armed chief_walk_1)
	
	(sleep 30)
	
	(camera_set capt_wide_1a 0)
	(camera_set capt_wide_1b 300)
	
	(fade_in 1 1 1 15)
	
	(sleep 150)
	
	(camera_set capt_wide_1c 200)
	(sleep 100)
	
	(camera_set capt_wide_1d 180)
	(sleep 180)
	
	(recording_kill chief_armed)
	(object_teleport chief_armed chief_capt_look_base)
	(custom_animation chief_armed cinematics\animations\chief\level_specific\d20\d20 d20seekeyes false)
	
	(game_skip_ticks 15)
	
	(camera_set chief_close_1a 0)
	(camera_set chief_close_1b 180)
	
	(sound_impulse_start sound\dialog\d20\D20_captflood_030_cortana none 1)
	(print "cortana: No human life signs detected, Chief. The Captain, he's...one of them.")
;	(sleep (sound_impulse_time sound\dialog\d20\D20_captflood_030_cortana))
	
	(sleep 180)
	
	(camera_set capt_close_1a 0)
	(camera_set capt_close_1b 200)
	
	(sleep 60)
	
	(sound_impulse_start sound\dialog\d20\D20_captflood_050_cortana none 1)
	(print "cortana: We can't let the Flood get off this ring! you know what he'd expect--")
	(sleep (camera_time))
	
	(custom_animation chief_armed cinematics\animations\chief\level_specific\d20\d20 d20punchface false)
	
	(sleep 5)
	
	(camera_set punch_1 0)
	(camera_set punch_2 300)
	
	(sound_looping_start sound\sinomatixx_foley\d20_captain_foley2 none 1)
	
	(sleep 30)
	
	(sound_impulse_start sound\dialog\d20\D20_captflood_060_cortana none 1)
	(print "cortana: What he'd want us to do.")
;	(sleep (sound_impulse_time sound\dialog\d20\D20_captflood_060_cortana))
	
	(sleep 120)
	
	(print "rumble")
	
	(player_effect_set_max_rotation 0 .75 .75)
	(player_effect_set_max_vibrate .75 .75)
	(player_effect_start 1 0)
	(player_effect_stop 1)
	
	(object_set_permutation keyes_flood "head" "punched_head-100")
	
	(sleep 30)
	
	(object_destroy implants)
;	(object_destroy keyes_flood)
;	(object_destroy keyes_flood_punched)
	
	(object_create implants)
;	(object_create keyes_flood_punched)
	
;	(object_beautify keyes_flood_punched true)
	
	(objects_attach chief_armed "left hand" implants "")
	
	(camera_set punch_3 200)
	(sleep 100)
	
	(camera_set punch_4 180)
	
	(sleep 80)
	
	(effect_new_on_object_marker "cinematics\effects\cyborg chip insertion" chief_armed "left hand")
	(objects_detach chief implants)
	(object_destroy implants)
	
	(sleep 40)
	
	(sound_impulse_start sound\dialog\d20\D20_captflood_061_cortana none 1)
	(print "cortana: It's done. I have the code. We should go.")
;	(sleep (sound_impulse_time sound\dialog\d20\D20_captflood_061_cortana))
	
	(sleep (- (camera_time) 15))

	(fade_out 1 1 1 15)
	
	(sleep 15)
	
	(object_teleport (player0) player0_capt_done)
	(object_teleport (player1) player1_capt_done)
	
	(object_destroy chief_armed)
	(object_destroy implants)
	
	(cinematic_stop)
	(camera_control off)
	
	(fade_in 1 1 1 15)
)

(script static void captain_test
	(object_teleport chief_armed chief_capt_look_base)
;	(custom_animation chief_armed cinematics\animations\chief\level_specific\d20\d20 d20seekeyes false)
	(custom_animation chief_armed cinematics\animations\chief\level_specific\d20\d20 d20punchface false)
;	(custom_animation chief_armed cinematics\animations\chief\level_specific\d20\d20 d20jumpdown true)
)

(script dormant fall_music
	(sleep 30)
	(sound_looping_start sound\sinomatixx_music\d20_fall_music none 1)
)

(script static void cutscene_fall

	(wake fall_music)

	(objects_predict chief)
	(objects_predict rifle)

	(fade_out 1 1 1 0)

	(camera_control on)
	(cinematic_start)

	(sleep 15)
	
	(switch_bsp 1)

	(object_teleport (player0) player0_fall_base)
	(object_teleport (player1) player1_fall_base)
	
	(object_destroy chief)
	(object_destroy rifle)
	(object_create chief)
	(object_create rifle)
	
	(object_teleport chief chief_fall_base)
	(objects_attach chief "right hand" rifle "")
	
	(object_beautify chief true)
	
	(camera_set fall_1a 0)
	(camera_set fall_1b 240)
	
	(fade_in 1 1 1 15)
	
	(sleep 60)
	
	(custom_animation chief cinematics\animations\chief\level_specific\d20\d20 d20jumpdown false)
	
	(sleep 40)
	
	(sound_looping_start sound\sinomatixx_foley\d20_fall_foley none 1)
	
	(sleep 20)
	
	(camera_set fall_1c 0)
	(camera_set fall_1d 30)
	
	(sleep 15)
	
	(effect_new "effects\impact coolant splash" splash_base)
	
	(sleep 15)
	
	(player_effect_set_max_rotation 0 .75 .75)
	(player_effect_set_max_vibrate .75 .75)
	(player_effect_start 1 0)
	(player_effect_stop 1)
	
	(fade_out .0901 .2588 .2117 15)
	
	(sleep 15)	
	
	(object_destroy chief)
	(object_destroy rifle)
	
	(object_teleport (player0) player0_afterfall_base)
	(object_teleport (player1) player1_afterfall_base)
	
	(cinematic_stop)
	(camera_control off)

	(fade_in .0901 .2588 .2117 15)
)

(script static void cutscene_lift

	(sound_looping_start sound\sinomatixx_music\d20_lift_music none 1)
	(sound_looping_start sound\sinomatixx_foley\d20_lift_foley none 1)

	(objects_predict chief)
	(objects_predict rifle)

	(fade_out 1 1 1 15)

	(camera_control on)
	(cinematic_start)

	(sleep 15)
	
	(switch_bsp 1)

	(object_teleport (player0) player0_lift_base)
	(object_teleport (player1) player1_lift_base)
	
	(object_destroy chief)
	(object_destroy rifle)
	(object_create chief)
	(object_create rifle)
	
	(object_teleport chief chief_lift_base)
	(objects_attach chief "right hand" rifle "")
	
	(object_beautify chief true)

	(camera_set lift_1a 0)
	(camera_set lift_1c 120)

	(fade_in 1 1 1 15)
	
	(sleep 60)
	
	(camera_set lift_1b 60)

	(custom_animation chief cinematics\animations\chief\level_specific\a50\a50 a50energylift false)

	(sleep 30)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_convolution 3 2 .001 10 1)
	(cinematic_screen_effect_set_filter_desaturation_tint .8 0 1)
	(cinematic_screen_effect_set_filter 0 1 0 1 true 1)
	
	(sleep 15)
	
	(fade_out .8 0 1 15)
	
	(sleep 15)
	
	(switch_bsp 2)
	
;	I've added these flags Tyson. Change at will.
	(object_teleport (player0) player0_afterlift_base)
	(object_teleport (player1) player1_afterlift_base)
	
	(object_destroy chief)
	(object_destroy rifle)
	
	(cinematic_stop)
	(camera_control off)
	(cinematic_show_letterbox on)
	
	(sleep 60)

	(fade_in .8 0 1 15)
	
	(cinematic_screen_effect_set_convolution 3 2 10 .001 1)
	(cinematic_screen_effect_set_filter_desaturation_tint .8 0 1)
	(cinematic_screen_effect_set_filter 1 0 1 0 true 1)
	(sleep 30)
	(cinematic_screen_effect_stop)
)

(script static void create_flood_captain
	(object_create_anew keyes_flood)
)

