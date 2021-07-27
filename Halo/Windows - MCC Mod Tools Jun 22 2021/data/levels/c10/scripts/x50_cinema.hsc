;	X50 CINEMATIC SCRIPT
;	...component scripts up top, 
;	the whole she-bang at the bottom...

;	Thanks Jaime and Paul!

(global boolean test_play_flash false)
(global boolean test_ffw_flash false)
	
(script continuous play_flash
	(sleep_until test_ffw_flash 1)
	(cinematic_set_title ffw)
	(sleep 60)
	)
	
(script continuous ffw_flash
	(sleep_until test_play_flash 1)
	(cinematic_set_title play)
	(sleep 60)
	(sound_impulse_start sound\sinomatixx_foley\x50_ffw none 1)
	)

;(script static void clean
;	(ai_erase_all)
;	(garbage_collect_now)
;	(ai_reconnect)
;	(cls)
;	)

(script dormant control_infection
	(ai_place infection/control_room_f)
	(sleep 1)
	(ai_set_blind infection 1)
	(ai_set_deaf infection 1)
	(sleep 90)
	(ai_place infection/control_room_f)
	(sleep 90)
	(ai_place infection/control_room_f)
	(sleep 90)
	(ai_place infection/back_r)
	(ai_place infection/back_l)
)

(script static void infection_awake
	(ai_set_blind infection 0)
	(ai_set_deaf infection 0)
)

(script static void all_kill
	(object_destroy keyes)		
	(object_destroy johnson)
	(object_destroy mendoza)
	(object_destroy bisenti)
	(object_destroy jenkins)
	(object_destroy marine_1)
	(object_destroy marine_2)
	(object_destroy marine_3)
	(object_destroy_containing elite_corpse)
)

(script static void all_create
	(object_create keyes)		
	(object_create johnson)
	(object_create mendoza)
	(object_create bisenti)
	(object_create jenkins)
	(object_create marine_1)
	(object_create marine_2)
	(object_create marine_3)
	(object_create_containing elite_corpse)
	
	(object_beautify chief true)
	(object_beautify keyes true)
	(object_beautify johnson true)
	(object_beautify mendoza true)
	(object_beautify bisenti true)
	(object_beautify jenkins true)
	(object_beautify marine_1 true)
	(object_beautify marine_2 true)
	(object_beautify marine_3 true)
)

(script static void setup	
	
	(object_create_anew chief)
	(object_create_anew mendoza_dead)
	(object_create_anew jenkins_helmet)
	(object_create_anew shotgun)
	(object_create_anew lockpick)
	(object_create_anew_containing blood)
	(object_create_anew_containing ar_)

	(object_beautify mendoza_dead true)

	(object_teleport chief chief_base)
	(object_teleport mendoza_dead mendoza_base)
	(objects_attach control_door_a "lockpick" lockpick "lockpick place")
)

(script static void intro
	
	(object_create_anew chief)
	(object_beautify chief true)

	(object_pvs_activate chief)

	(set rasterizer_near_clip_distance .01) 
	
	(objects_attach chief "right hand" shotgun "")
	(custom_animation chief cinematics\animations\chief\x50\x50 x50_0710 true)
	
	(fade_in 1 1 1 15)
	
	(camera_set chief_door_1a 0)
	(camera_set chief_door_1b 90)
	
	(sleep 90)
	(camera_set chief_listen 0)
	(sleep 75)
	(camera_set chief_button_1 0)
	(sleep 60)
	
	(objects_detach chief shotgun)
	(object_destroy shotgun)
	
	(camera_set chief_button_2b 0)
	(camera_set chief_button_2a 75)
	(sleep 75)
	
	(object_create_anew shotgun)
	(objects_attach chief "right hand" shotgun "")
	
	(camera_set chief_what_the 0)
	(camera_set what_the_1b 30)
	(sleep 60)
	(camera_set chief_turn_rev_1 0)
	(camera_set chief_turn_rev_2 60)
	(sleep 60)
	(camera_set chief_turn_rev_1 60)
	(sleep 50)
	
	(unit_stop_custom_animation chief)
	(unit_custom_animation_at_frame chief cinematics\animations\chief\x50\x50 x50_0710 false 350)
	
	(sleep 10)
	
	(camera_set chief_relax 0)
	(camera_set chief_relax_1b 60)
	(sleep 90)
	(camera_set chief_button_3 0)
	(camera_set shiny_red_button 60)
	
	(sleep (unit_get_custom_animation_time chief))
;	(custom_animation chief cinematics\animations\chief\x50\x50 x50_1010 true)
	(custom_animation mendoza_dead cinematics\animations\marines\x50\x50 x50_1010mendoza true)

	(object_pvs_activate mendoza_dead)
	(object_destroy chief)

	(camera_set mendoza_close 0)
	
	(device_set_position control_door_a 1)
	
	(camera_set mendoza_close_1b 45)
	(sleep 45)
	
	(object_create_anew chief)
	(object_create_anew shotgun)
	(objects_attach chief "right hand" shotgun "")
	(object_beautify chief true)
	
	(object_pvs_activate chief)

	(unit_stop_custom_animation mendoza_dead)	
	(unit_stop_custom_animation chief)
	(unit_custom_animation_at_frame chief cinematics\animations\chief\x50\x50 x50_1010 false 30)
	(unit_custom_animation_at_frame mendoza_dead cinematics\animations\marines\x50\x50 x50_1010mendoza false 30)
	
	(camera_set mendoza_catch_back 0)
	(camera_set sack_of_potatoes_1a 60)
	
	(sleep (- (unit_get_custom_animation_time chief) 15))
	
	(custom_animation chief cinematics\animations\chief\x50\x50 x50_1210 false)
	(custom_animation mendoza_dead cinematics\animations\marines\x50\x50 x50_1210mendoza false)
	
	(camera_set mendoza_swing_1a 0)
	(camera_set mendoza_swing_1b 60)
	
	(sleep (unit_get_custom_animation_time chief))
	
	(unit_custom_animation_at_frame chief cinematics\animations\chief\x50\x50 x50_1310 false 50)
	(unit_custom_animation_at_frame mendoza_dead cinematics\animations\marines\x50\x50 x50_1310mendoza false 50)

	(camera_set chief_rush_1 0)
	(camera_set chief_rush_2 90)
	(sleep 60)
	(device_set_position control_door_a 0)
	(sleep (camera_time))
	
;	(sleep (unit_get_custom_animation_time chief))
	
	(unit_stop_custom_animation chief)
	(unit_stop_custom_animation mendoza_dead)
	(custom_animation chief cinematics\animations\chief\x50\x50 x50_1410 true)
	(custom_animation mendoza_dead cinematics\animations\marines\x50\x50 x50_1410mendoza true)

	(camera_set chief_reveal_1 0)
	(camera_set chief_reveal_2 120)
	(sleep 150)
	(camera_set mendoza_drop_1 0)
	(camera_set mendoza_drop_2 90)
	(sleep 90)
	
;	(camera_set chief_close 0)
;	(sleep 60)
;	(sleep (- (unit_get_custom_animation_time chief) 30))
	
	(camera_set duck_walk_1b 0)
	(camera_set duck_walk_1c 90)
	
	(unit_stop_custom_animation chief)
	
	(object_destroy chief)
	(object_create_anew chief_crouch)
	(object_beautify chief_crouch true)
	(object_pvs_activate chief_crouch)
	
	(object_teleport chief_crouch chief_crouch_base)
	(recording_play chief_crouch chief_crouch_walk)
	
;	(camera_set duck_walk_1c 60)

	(sleep (- (recording_time chief_crouch) 15))
	
	(object_destroy chief_crouch)
	(object_create_anew chief)
	(object_create_anew shotgun)
	(objects_attach chief "right hand" shotgun "")
	(object_beautify chief true)
	(object_pvs_activate chief)
			
	(cinematic_set_near_clip_distance .01)
			
	(custom_animation chief cinematics\animations\chief\x50\x50 x50_1910 false)
	(camera_set helmet_close 0)
	
	(sleep 70)
	(objects_detach chief shotgun)
	(objects_attach chief "right hand" jenkins_helmet "right hand helmet")	
	(sleep (unit_get_custom_animation_time chief))
	(custom_animation chief cinematics\animations\chief\x50\x50 x50_2010 true)
	(sleep 90)
	(camera_set chip_inspect 0)
	
	(sleep 180)
	(camera_set helmet_closeup 0)
	
	(object_create_anew jenkins_chip)
	(objects_attach chief "left hand" jenkins_chip "chip in hand")
	
	(sleep 90)
	
	(camera_set chip_rush_2 30)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_convolution 3 2 1 10 1)
	
	(fade_out 1 1 1 30)
	
	(sleep 15)
	
	(effect_new_on_object_marker "cinematics\effects\cyborg chip insertion" chief "left hand")
	
	(sleep 15)
	
	(objects_detach chief jenkins_helmet)
	
	(object_pvs_activate none)
	(device_set_position control_door_a 0)
	(object_destroy lockpick)
	
	(cinematic_screen_effect_stop)
	(cinematic_set_near_clip_distance .0625)
	(sound_class_set_gain vehicle_engine 0 0)
)

(script static void pelican
	
	(cinematic_set_title postmortem)
	(sleep 120)
	(cinematic_set_title jenkins)
	(sleep 120)

	(object_create_anew johnson)
	(object_create_anew mendoza)
	(object_create_anew bisenti)
	(object_create_anew jenkins)
	(object_create_anew marine_2)
	(object_create_anew x50_pelican_1)
	
	(camera_set_first_person jenkins)
	(object_pvs_activate jenkins)
	(recording_play jenkins jenkins_pelican)
	
	(object_teleport x50_pelican_1 x50_pelican_1_in)
	(recording_play x50_pelican_1 x50_pelican_1_in)
	
	(unit_enter_vehicle johnson x50_pelican_1 "P-riderRB")
	(unit_enter_vehicle mendoza x50_pelican_1 "P-riderLB")
	(unit_enter_vehicle bisenti x50_pelican_1 "P-riderRM")
	(unit_enter_vehicle jenkins x50_pelican_1 "P-riderLM")
	(unit_enter_vehicle marine_2 x50_pelican_1 "P-riderRF")
	
	(ai_attach_free johnson characters\captain\captain)
	(ai_attach_free mendoza characters\captain\captain)
	(ai_attach_free bisenti characters\captain\captain)
	
	(ai_command_list_by_unit johnson look_at_mendoza)
	(ai_command_list_by_unit mendoza look_at_johnson)
	(ai_command_list_by_unit bisenti look_at_johnson)
	
	(set test_play_flash true)

	(sleep 90)
	
	(sound_looping_start sound\sinomatixx_music\x50_music02 none .7)
	
;	(fade_in 0 0 0 30)
	
	(sound_class_set_gain ambient_machinery 1 60)	
	(sound_class_set_gain ambient_nature 1 60)	
	
	(sleep 90)
	
	(sound_impulse_start sound\dialog\x50\men01 mendoza 1)
	(print "mendoza: hey sarge, why do we always have to listen to this old stuff?")
	(sleep (- (sound_impulse_time sound\dialog\x50\men01) 60))
	(print "mendoza done")
	
	(fade_in 0 0 0 30)
	(sound_class_set_gain vehicle_engine .6 3)
	
	(sleep (sound_impulse_time sound\dialog\x50\men01))
	
	(sound_impulse_start sound\dialog\x50\sgt01 johnson 1)
	(print "Johnson: watch yer mouth, boy! this 'stuff' is your history. it should remind you grunts what we're fighting to protect!")
	(sleep (sound_impulse_time sound\dialog\x50\sgt01))
	(print "johnson done")
	
	(ai_command_list_by_unit mendoza look_at_jenkins)
	
	(sound_impulse_start sound\dialog\x50\men02 mendoza 1)
	(print "mendoza: hey, if the covenant want to wipe out this particular part of my history, that's fine by me.")
	(sleep (- (sound_impulse_time sound\dialog\x50\men02) 15))
	(print "mendoza done")
	
	(ai_command_list_by_unit mendoza look_at_bisenti)
	(ai_command_list_by_unit bisenti look_at_mendoza)
	
	(sound_impulse_start sound\dialog\x50\bis01 bisenti 1)
	(print "bisenti: yeah. better it than us.")
	(sleep (sound_impulse_time sound\dialog\x50\bis01))
	(print "bisenti done")
	
	(ai_command_list_by_unit johnson look_at_bisenti)
	(ai_command_list_by_unit mendoza look_at_johnson)
	(ai_command_list_by_unit bisenti look_at_johnson)
	
	(sound_impulse_start sound\dialog\x50\sgt02 johnson 1)
	(print "johnson: you ask 'em real nice next time you see 'em, bisenti. i'm sure they'll be happy to oblige.")
	(sleep (sound_impulse_time sound\dialog\x50\sgt02))
	(print "johnson done")
	
	(sound_impulse_start sound\dialog\x50\pilot01 none 1)
	(print "pilot: LZ looks clean. i'm bringing us down.")
	(sleep (sound_impulse_time sound\dialog\x50\pilot01))
	(print "pilot done")
	(sleep 90)
	
;	(sleep (recording_time x50_pelican_1))
	(vehicle_hover x50_pelican_1 1)
	
	(sound_impulse_start sound\dialog\x50\sgt03 johnson 1)
	(print "go, go, go!")
	(sleep (sound_impulse_time sound\dialog\x50\sgt03))
	(print "johnson done")
	
	(sound_class_set_gain weapon_fire 0 0)
	(sound_class_set_gain projectile_detonation 0 0)
	(sound_class_set_gain projectile_impact 0 0)
	(sound_class_set_gain unit_footsteps 0 0)
	(sound_class_set_gain unit_dialog 0 0)
	(sound_class_set_gain ambient_nature 0 0)
	(sound_class_set_gain ambient_machinery 0 0)
	(sound_class_set_gain vehicle_engine 0 0)
	
	(sound_looping_stop sound\sinomatixx_music\x50_music02) 
)

(script static void door_setup	
	(object_create johnson)
	(object_create mendoza)
	(object_create bisenti)
	(object_create jenkins)
	(object_create marine_2)
	(object_teleport johnson johnson_ent)
	(object_teleport mendoza mendoza_ent)
	(object_teleport bisenti bisenti_ent)
	(object_teleport jenkins jenkins_ent)
	(object_teleport marine_2 marine_2_ent)
)


(script static void door

	(object_create_anew johnson)
	(object_create_anew mendoza)
	(object_create_anew bisenti)
	(object_create_anew jenkins)
	(object_create_anew marine_2)
	(object_destroy_containing blood)
	(object_destroy_containing ar_)
	(object_destroy_containing x50_rock)
	
	(object_teleport johnson johnson_ent)
	(object_teleport mendoza mendoza_ent)
	(object_teleport bisenti bisenti_ent)
	(object_teleport jenkins jenkins_ent)
	(object_teleport marine_2 marine_2_ent)
	
	(camera_set_first_person jenkins)
;	(print "(johnson starts running...)")
	
	(recording_play johnson johnson_door_run)
	(recording_play jenkins jenkins_ent_3)
	(recording_play mendoza mendoza_door_advance)
	(recording_play bisenti bisenti_door_guard)
	(recording_play marine_2 marine_2_door_advance)
	
	(sleep 80)
	
;	(sound_impulse_start sound\dialog\x50\x50_door_breathing none .5)
	(fade_in 0 0 0 30)
	
	(sound_class_set_gain weapon_fire 1 3)
	(sound_class_set_gain projectile_detonation 1 3)
	(sound_class_set_gain projectile_impact 1 3)
	(sound_class_set_gain unit_footsteps 1 3)
	(sound_class_set_gain unit_dialog 1 3)
	(sound_class_set_gain ambient_nature 1 3)
	(sound_class_set_gain ambient_machinery 1 3)
	(sound_class_set_gain vehicle_engine 1 3)
	
	(sleep 80)
	
	(sound_looping_start sound\sinomatixx_foley\x50_foley2 none 1)
	
	(sound_impulse_start sound\dialog\x50\sgt04 johnson 1)
;	(print "johnson: stay close, jenkins.")
	(sleep (sound_impulse_time sound\dialog\x50\sgt04))
;	(print "johnson: done")
	(sleep 150)

	(custom_animation johnson cinematics\animations\marines\x50\x50 x50_3210johnson true)
	(sound_impulse_start sound\dialog\x50\sgt04b johnson 1)
;	(print "johnson: mendoza--move it up!")
	(sleep (sound_impulse_time sound\dialog\x50\sgt04b))
;	(print "johnson: done")
	(sleep 120)
;	(print "(mendoza runs past...)")
	
	(sound_impulse_start sound\dialog\x50\sgt06 johnson 1)
;	(print "johnson: bisenti, wait here for the captain and his squad, then get your ass inside.")
	(sleep 60) 
	(sleep (sound_impulse_time sound\dialog\x50\sgt06))
;	(print "johnson: done")
	
	(sound_impulse_start sound\dialog\x50\bis02 bisenti 1)
;	(print "bisenti: yes, sir!")
	(sleep (sound_impulse_time sound\dialog\x50\bis02))
;	(print "johnson: done")
	(sleep 30)
	
	(sound_impulse_start sound\dialog\x50\sgt05 johnson 1)
;	(print "johnson: ok, let's move!")
	(sleep (sound_impulse_time sound\dialog\x50\sgt05))
;	(print "johnson: done")

	(sleep 60)
	(fade_out 0 0 0 15)
	(sleep 15)

	(sound_class_set_gain weapon_fire 0 0)
	(sound_class_set_gain projectile_detonation 0 0)
	(sound_class_set_gain projectile_impact 0 0)
	(sound_class_set_gain unit_footsteps 0 0)
	(sound_class_set_gain unit_dialog 0 0)
	(sound_class_set_gain ambient_nature 0 0)
	(sound_class_set_gain ambient_machinery 0 0)
	(sound_class_set_gain vehicle_engine 0 0)
	
	(recording_kill jenkins)
	(recording_kill johnson)
	(recording_kill mendoza)
	(recording_kill bisenti)
	(recording_kill marine_1)
	)

(script static void check_setup
	(object_teleport keyes keyes_check)		
	(object_teleport johnson johnson_check)
	(object_teleport mendoza mendoza_check)
	(object_teleport bisenti bisenti_check)
	(object_teleport jenkins jenkins_check)
	(object_teleport marine_2 marine_2_check)
)

(script static void check

	(object_create_anew keyes)
	(object_create_anew marine_1)
	(object_create_anew marine_3)
	(object_create_anew_containing elite_corpse)
	(object_create_anew johnson)
	(object_create_anew mendoza)
	(object_create_anew bisenti)
	(object_create_anew jenkins)
	(object_create_anew marine_2)
	
	(object_teleport keyes keyes_check)
	(object_teleport marine_1 marine_1_check)
	(object_teleport marine_3 marine_3_check)
	(object_teleport marine_2 marine_2_check)	
	
	(object_teleport johnson johnson_check)
	(object_teleport mendoza mendoza_check)
	(object_teleport bisenti bisenti_check)
	(object_teleport jenkins jenkins_check)
	
	(recording_play jenkins jenkins_check_3)
	(camera_set_first_person jenkins)
	(object_pvs_activate jenkins)
	
	(sleep 30)
	(recording_play marine_1 marine_1_check)
	(recording_play marine_3 marine_3_check)
	(sleep 30)
	(recording_play mendoza mendoza_check)
	(recording_play johnson johnson_check)
	(recording_play bisenti bisenti_check)
	(recording_play marine_2 marine_2_check)
	
	(unit_set_seat keyes alert)
	(recording_play keyes keyes_check_2)
	(sleep 60)
	
	(fade_in 0 0 0 15)
	
	(sound_class_set_gain weapon_fire 1 3)
	(sound_class_set_gain projectile_detonation 1 3)
	(sound_class_set_gain projectile_impact 1 3)
	(sound_class_set_gain unit_footsteps 1 3)
	(sound_class_set_gain unit_dialog 1 3)
	(sound_class_set_gain ambient_nature 1 3)
	(sound_class_set_gain ambient_machinery 1 3)
	(sound_class_set_gain vehicle_engine 1 3)
	 
	(sound_impulse_start sound\dialog\x50\men05 mendoza 1)
;	(print "mendoza: which is weird, right? I mean, look at it.")
	(sleep (sound_impulse_time sound\dialog\x50\men05))
	
	(custom_animation mendoza cinematics\animations\marines\x50\x50 x50_3410mendoza true)
	
	(sound_impulse_start sound\dialog\x50\men06 mendoza 1)
;	(print "mendoza: something tore open its chest, and scrambled the insides.")
	(sleep (sound_impulse_time sound\dialog\x50\men06))
	
	(sound_impulse_start sound\dialog\x50\sgt09 johnson 1)
;	(print "johnson: what's that? plasma scoring")
	(sleep (sound_impulse_time sound\dialog\x50\sgt09))
	
	(sound_impulse_start sound\dialog\x50\men07 mendoza 1)
;	(print "mendoza: yeah, i don't know. maybe there was an accident. you know, friendly-fire or something?")
	(sleep (sound_impulse_time sound\dialog\x50\men07))
	(sleep 30)
	
	(sound_impulse_start sound\dialog\x50\key01 keyes 1)
;	(print "keyes: what do we have, sargeant?")
	(sleep (sound_impulse_time sound\dialog\x50\key01))
	
	(sound_impulse_start sound\dialog\x50\sgt10 johnson 1)
;	(print "johnson: looks like a covenant patrol. bad-ass elite units, all KIA.")
	(sleep (sound_impulse_time sound\dialog\x50\sgt10))
	
	(sound_impulse_start sound\dialog\x50\key02 keyes 1)
;	(print "keyes: real pretty. friend of yours?")
	(sleep (sound_impulse_time sound\dialog\x50\key02))
	
	(sound_impulse_start sound\dialog\x50\men08 mendoza 1)
;	(print "mendoza: nah, we just met.")
	(sleep (sound_impulse_time sound\dialog\x50\men08))
	
	(sleep 15)
	(fade_out 0 0 0 15)
	(sleep 15)
		
	(recording_kill jenkins)
	(recording_kill johnson)
	(recording_kill mendoza)
	(recording_kill bisenti)
	(recording_kill keyes)
	(recording_kill marine_1)
	(recording_kill marine_2)
	(recording_kill marine_3)
	
	(sound_class_set_gain weapon_fire 0 0)
	(sound_class_set_gain projectile_detonation 0 0)
	(sound_class_set_gain projectile_impact 0 0)
	(sound_class_set_gain unit_footsteps 0 0)
	(sound_class_set_gain unit_dialog 0 0)
	(sound_class_set_gain ambient_nature 0 0)
	(sound_class_set_gain ambient_machinery 0 0)
	(sound_class_set_gain vehicle_engine 0 0)
	
)

(script static void lab_setup_1
	(object_create control_door_a)
	(object_teleport keyes keyes_lab)		
	(object_teleport johnson johnson_lab)
	(object_teleport mendoza mendoza_lab)
	(object_teleport bisenti bisenti_lab)
	(object_teleport jenkins jenkins_lab)
	(object_teleport marine_2 marine_2_lab)
	(object_teleport marine_1 marine_1_lab_1)
	(object_teleport marine_3 marine_3_lab_1)
)

(script static void lab_setup_2
	(object_teleport keyes keyes_lab_2)
	(object_teleport marine_1 marine_1_lab_2)
	(object_teleport marine_3 marine_3_lab_2)
	(object_teleport mendoza mendoza_flood)
	(object_teleport johnson johnson_flood)
)

(script static void lab_setup_3
	(object_teleport bisenti keyes_lab_2)
	(object_teleport marine_2 marine_1_lab_2)
)

(script dormant door_open
	(sleep 234)
;	(object_destroy control_door_a)
	(device_set_position control_door_a 1)
)

(script dormant the_horror
	(object_create_anew_containing jenkins_infection)
	(ai_attach_free jenkins_infection_1a characters\flood_infection\flood_infection)
	(ai_attach_free jenkins_infection_1b characters\flood_infection\flood_infection)
	(ai_attach_free jenkins_infection_1c characters\flood_infection\flood_infection)
	(ai_attach_free jenkins_infection_1d characters\flood_infection\flood_infection)
	(ai_attach_free jenkins_infection_1e characters\flood_infection\flood_infection)
	(ai_attach_free jenkins_infection_1f characters\flood_infection\flood_infection)
	(ai_attach_free jenkins_infection_1g characters\flood_infection\flood_infection)
	(ai_attach_free jenkins_infection_1h characters\flood_infection\flood_infection)
	(ai_attach_free jenkins_infection_1i characters\flood_infection\flood_infection)
	(object_teleport jenkins_infection_1a infection_jenkins_1a)
	(object_teleport jenkins_infection_1b infection_jenkins_1b)
	(object_teleport jenkins_infection_1c infection_jenkins_1c)
	(object_teleport jenkins_infection_1d infection_jenkins_1d)
	(object_teleport jenkins_infection_1e infection_jenkins_1e)
	(object_teleport jenkins_infection_1f infection_jenkins_1f)
	(object_teleport jenkins_infection_1g infection_jenkins_1g)
	(object_teleport jenkins_infection_1h infection_jenkins_1h)
	(object_teleport jenkins_infection_1i infection_jenkins_1i)
)

(script static void lab

	(sound_class_set_gain unit_dialog 0 0)
	(sound_class_set_gain music 1 0)

	(object_destroy mendoza_dead)
	(object_destroy chief)
	(object_destroy jenkins_helmet)
	(object_destroy shotgun)
	(object_destroy jenkins_chip)
	
	(object_create_anew keyes)
	(object_create_anew johnson)
	(object_create_anew mendoza)
	(object_create_anew bisenti)
	(object_create_anew jenkins)
	(object_create_anew marine_2)
	(object_create_anew infection_1)
	(object_create_anew control_door_a)

	(object_teleport keyes keyes_lab)		
	(object_teleport johnson johnson_lab)
	(object_teleport mendoza mendoza_lab)
	(object_teleport bisenti bisenti_lab)
	(object_teleport jenkins jenkins_lab)
	(object_teleport marine_2 marine_2_lab)
	
	(device_set_position control_door_a 0)
	
	(camera_set_first_person jenkins)
	(recording_play jenkins jenkins_lab_3)
	(object_pvs_activate jenkins)
	
	(sleep 60)
	
	(recording_play bisenti bisenti_lab_in)
	(recording_play mendoza mendoza_lab_in)
	(recording_play johnson johnson_lab_in)
	(recording_play marine_2 marine_2_lab_in)
	(recording_play marine_1 marine_1_lab_in)
	(recording_play marine_3 marine_3_lab_in)
	
	(sleep 30)
	
	(fade_in 0 0 0 30)

	(sound_class_set_gain weapon_fire 1 3)
	(sound_class_set_gain projectile_detonation 1 3)
	(sound_class_set_gain projectile_impact 1 3)
	(sound_class_set_gain unit_footsteps 1 3)
	(sound_class_set_gain unit_dialog .5 1)
	(sound_class_set_gain ambient_nature 1 3)
	(sound_class_set_gain ambient_machinery 1 3)
	(sound_class_set_gain vehicle_engine 1 3)
	
	(sound_impulse_start sound\dialog\x50\key03 keyes 1)
	(print "keyes: alright then, let's get this door open.")
	(sleep (sound_impulse_time sound\dialog\x50\key03))
	(print "done")
	
	(sound_impulse_start sound\dialog\x50\men09 mendoza 1)
	(print "mendoza: I'll try, sir. but it looks like these covenant tried pretty hard to lock it down.")
	(sleep (sound_impulse_time sound\dialog\x50\men09))
	(print "done")
	
	(sound_impulse_start sound\dialog\x50\key04 keyes 1)
	(print "keyes: just do it, son.")
	(sleep (sound_impulse_time sound\dialog\x50\key04))
	(print "done")
	
	(custom_animation mendoza cinematics\animations\marines\x50\x50 x50_3310bisenti true)
	(sound_impulse_start sound\sinomatixx_foley\x50_bisenti control_door_a 1)
	
	(wake door_open)
	
	(sound_impulse_start sound\dialog\x50\men10 mendoza 1)
	(print "mendoza: yes, sir.")
	(sleep (sound_impulse_time sound\dialog\x50\men10))
	(print "done")
	
	(object_create lockpick)
	(sleep 75)
	(objects_attach mendoza "left hand" lockpick "left hand lockpick")
;	(sleep 77)
;	(sleep 70)
	(sleep 63)
	(objects_detach mendoza lockpick)
	(objects_attach control_door_a "lockpick" lockpick "lockpick place")
	
	(sleep (unit_get_custom_animation_time mendoza))
;	(unit_stop_custom_animation mendoza)
	
	(print "mendoza done")
	(sleep 500)
	
	(recording_kill mendoza)
	(recording_kill johnson)
	(recording_kill marine_3)
	(recording_kill marine_1)
	
;	(script static void build

	(print "sleep done")

	(object_create_anew marine_1)
	(object_create_anew marine_3)
	(object_create_anew keyes_pistol)
	
	(object_teleport keyes_pistol keyes_lab_2)
	(object_teleport marine_1 marine_1_lab_2)
	(object_teleport marine_3 marine_3_lab_2)
	(object_teleport mendoza mendoza_flood)
	(object_teleport johnson johnson_flood)
	
	(recording_play keyes_pistol keyes_lab_2)
	(recording_play mendoza mendoza_lab_2)
	(recording_play johnson johnson_lab_2)
	(recording_play marine_3 marine_3_lab_2)
	(recording_play marine_1 marine_1_lab_2)

	(sound_impulse_start sound\dialog\x50\men11 mendoza 1)
	(print "mendoza: i got a bad feeling about this.")
	(sleep (sound_impulse_time sound\dialog\x50\men11))
	(print "done")
	
	(sound_impulse_start sound\dialog\x50\sgt11 johnson 1)
	(print "johnson: you always got a bad feeling about something, boy.")
	(sleep (- (sound_impulse_time sound\dialog\x50\sgt11) 30))
	(print "done")
	
	(sound_impulse_start sound\dialog\x50\mar101 none 1)
	(custom_animation johnson cinematics\animations\marines\x50\x50 x50_3810Johnson true)
	(print "marine 1: sarge? captain? <static> can you hear me?")
	(sleep (sound_impulse_time sound\dialog\x50\mar101))
	(print "done")
	
	(sound_impulse_start sound\dialog\x50\key05 keyes 1)
	(print "keyes: what's going on soldier?")
	(sleep (- (sound_impulse_time sound\dialog\x50\key05) 30))
	(print "done")
	
	(object_teleport bisenti bisenti_flood)
	(object_teleport marine_2 marine_2_flood)
	
	(sound_impulse_start sound\dialog\x50\mar102 none 1)
	(print "marine 1: we got contacts! lots of them! but they're not <static> just tearing through us!")
	(sleep (- (sound_impulse_time sound\dialog\x50\mar102) 30))
	(print "done")
	
	(sound_impulse_start sound\dialog\x50\sgt13 johnson 1)
	(print "johnson: corporal, do you copy? over? ")
	(sleep (sound_impulse_time sound\dialog\x50\sgt13))
	(print "done")
	(sleep 60)
	
	(sound_looping_start sound\sinomatixx_foley\x50_foley3 none 1)
	
	(sound_impulse_start sound\dialog\x50\sgt14 johnson 1)
	(print "johnson: mendoza, get your ass up to 2nd squad's position, and find out what the hell is going on.")
	(sleep (- (sound_impulse_time sound\dialog\x50\sgt14) 30))
	(print "done")
	
	(sound_impulse_start sound\dialog\x50\men12 mendoza 1)
	(print "mendoza: but, sir--")
	(sleep (- (sound_impulse_time sound\dialog\x50\men12) 15))
	(print "done")
	
	(sound_impulse_start sound\dialog\x50\sgt15 johnson 1)
	(print "johnson: i don't have time for your lip, soldier. i gave you an order!")
	(sleep (- (sound_impulse_time sound\dialog\x50\sgt15) 30))
	(print "done")
	
	(sound_impulse_start sound\dialog\x50\men13 mendoza 1)
	(print "mendoza: but, sarge, listen!")
	(sleep (sound_impulse_time sound\dialog\x50\men13))
	(print "done")
	
	(sleep 30)
	
	(sound_impulse_start sound\dialog\x50\key06 keyes 1)
	(print "keyes: what is that?")
	(sleep (sound_impulse_time sound\dialog\x50\key06))
	(print "done")
	
	(wake control_infection)
	
	(sound_impulse_start sound\dialog\x50\sgt16 johnson 1)
	(print "johnson: where's that coming from, mendoza?")
	(sleep (- (sound_impulse_time sound\dialog\x50\sgt16) 30))
	(print "done")
	
	(sound_impulse_start sound\dialog\x50\men14 mendoza 1)
	(print "mendoza: everywhere! i don't--")
	(sleep (sound_impulse_time sound\dialog\x50\men14))
	(print "done")
	
	(device_set_position control_door_bashed_f 1)	
	
	(sound_impulse_start sound\dialog\x50\men15 mendoza 1)
	(print "mendoza: there! mira!")
	(sleep (sound_impulse_time sound\dialog\x50\men15))
	(print "done")	
	
	(custom_animation mendoza characters\marine\marine "stand rifle warn%1" true)
	
	(sleep 30)
	
	(custom_animation infection_1 cinematics\animations\flood_infection\x50\x50 x50_4110flood true)
	(custom_animation marine_2 cinematics\animations\marines\x50_normal\x50_normal x50_4110mar2 true)
	
	(sleep 60)
	(sound_impulse_start sound\dialog\x50\mar201 marine_2 1)
	(print "marine 2: gaah!")
	(sleep 40)
	
	(custom_animation bisenti cinematics\animations\marines\x50\x50 x50_4110bisenti true)
	
	(sound_impulse_start sound\dialog\x50\mar202 marine_2 1)
	(print "marine 2: get it out! get-it-out!")
	(sleep (- (sound_impulse_time sound\dialog\x50\mar202) 60))
	(print "done")
	
	(sound_impulse_start sound\dialog\x50\bis04 bisenti 1)
	(print "bisenti: hold still! hold still!")
	(sleep (sound_impulse_time sound\dialog\x50\bis04))
	
	(sound_impulse_start sound\dialog\x50\sgt17 johnson 1)
	(print "johnson: let 'em have it!")
;	(sleep (sound_impulse_time sound\dialog\x50\sgt17))

	(sleep 30)
	
	(sound_impulse_start sound\dialog\x50\bis06 bisenti 1)
	(print "bisenti: aaargh!")
	(sleep (- (sound_impulse_time sound\dialog\x50\bis06) 30))
	
	(sleep (unit_get_custom_animation_time bisenti))
	
	(sound_impulse_start sound\dialog\x50\key07 keyes 1)
	(print "keyes: sargeant, we're surrounded!")
	(sleep (- (sound_impulse_time sound\dialog\x50\key07) 30))
	
	(sound_impulse_start sound\dialog\x50\sgt18 johnson 1)
	(print "johnson: god damn it, jenkins! fire your weapon!")
	(sleep (sound_impulse_time sound\dialog\x50\sgt18))
	
	(sound_impulse_start sound\dialog\x50\men16 mendoza 1)
	(print "mendoza: there are too many of 'em!")
	(sleep (- (sound_impulse_time sound\dialog\x50\men16) 30))
	
	(sound_impulse_start sound\dialog\x50\sgt19 johnson 1)
	(print "johnson: don't even think about it, marine!")
	(sleep (sound_impulse_time sound\dialog\x50\sgt19))
	(sleep 60)
	
	(object_cannot_take_damage jenkins)
	(object_cannot_take_damage johnson)
	(object_cannot_take_damage keyes_pistol)
	
	(infection_awake)
	
	(custom_animation mendoza cinematics\animations\marines\x50\x50 x50_4110mendoza false)

	(sleep 30)
	(sound_impulse_start sound\dialog\x50\men17 mendoza 1)
	(print "mendoza: aw, this is loco!")
	(sleep (sound_impulse_time sound\dialog\x50\men17))
	
	(wake the_horror)
	
	(sound_impulse_start sound\dialog\x50\key08 keyes 1)
	(print "keyes: get back here, marine! that's an order!")
	
	(sleep (unit_get_custom_animation_time mendoza))
	(object_destroy mendoza)
	
	(sleep (- (sound_impulse_time sound\dialog\x50\key08) 15))
	
	(sound_impulse_start sound\dialog\x50\sgt20 johnson 1)
	(print "johnson: jenkins!")
	(sleep (sound_impulse_time sound\dialog\x50\sgt20))
	
	(sleep 30)

	(fade_out 0 0 0 0)
	
	(print "jenkins dead")
	
	(ai_erase infection)
	
	(object_destroy lockpick)
	(object_destroy infection_jenkins)
	
	(object_destroy mendoza_dead)
	(object_destroy chief)
	(object_destroy jenkins_helmet)
	(object_destroy shotgun)
	(object_destroy jenkins_chip)
	
	(object_destroy keyes)
	(object_destroy marine_1)
	(object_destroy marine_3)
	(object_destroy johnson)
	(object_destroy mendoza)
	(object_destroy bisenti)
	(object_destroy jenkins)
	(object_destroy marine_2)
	(object_destroy infection_1)
	(object_destroy_containing jenkins_infection)
	
	(cinematic_screen_effect_stop)
	
	(sound_class_set_gain unit_dialog 0 0)
	(sound_class_set_gain weapon_fire 0 0)
	(sound_class_set_gain projectile_detonation 0 0)
	(sound_class_set_gain projectile_impact 0 0)
	(sound_class_set_gain unit_footsteps 0 0)
	(sound_class_set_gain ambient_nature 0 0)
	(sound_class_set_gain ambient_machinery 0 0)
	
	)
	
(script static void flood
	(custom_animation infection_1 cinematics\animations\flood_infection\x50\x50 x50_4110flood true)
	(custom_animation marine_2 cinematics\animations\marines\x50_normal\x50_normal x50_4110mar2 true)
	(custom_animation bisenti cinematics\animations\marines\x50\x50 x50_4110bisenti true)
	(sleep 100)
	(object_teleport bisenti bisenti_flood)
)

(script static void mendoza_unlock
	(custom_animation mendoza cinematics\animations\marines\x50\x50 x50_3310bisenti true)
	)
	
(script static void mendoza_flee
	(custom_animation mendoza cinematics\animations\marines\x50\x50 x50_4110mendoza true)
	(custom_animation keyes cinematics\animations\marines\x50\x50 x50_4110captain true)
	)
	
(script static void final

	(sound_looping_start sound\sinomatixx_music\x50_music03 none 1)

	(cinematic_set_near_clip_distance .01)

	(object_create_anew chief)
	(object_create_anew jenkins_chip)
	(object_create_anew shotgun)
	
	(objects_attach chief "right hand" shotgun "")
	(object_beautify chief true)
	
	(object_pvs_activate chief)
	
	(object_teleport chief player0_playon_base)
	
	(objects_attach chief "left hand" jenkins_chip "chip in hand")
	
	(camera_set chief_final_1a 0)
	(camera_set chief_final_1b 60)
	
	(sound_impulse_start sound\sinomatixx_foley\x50_throw_chip none 1)
	(custom_animation chief cinematics\animations\chief\x50\x50 x50_4710 true)

	(fade_in 1 1 1 15)
	
	(sound_class_set_gain weapon_fire 1 3)
	(sound_class_set_gain projectile_detonation 1 3)
	(sound_class_set_gain projectile_impact 1 3)
	(sound_class_set_gain unit_footsteps 1 3)
	(sound_class_set_gain unit_dialog 1 3)
	(sound_class_set_gain ambient_nature 1 3)
	(sound_class_set_gain ambient_machinery 1 3)
	(sound_class_set_gain vehicle_engine 1 3)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_convolution 3 2 10 .25 1)
	
	(sleep 150)
	
	(objects_detach chief jenkins_chip)
	(object_destroy jenkins_chip)
	
	(camera_set final_2a 0)
	(camera_set final_2b 120)
	
	(sleep (- (unit_get_custom_animation_time chief) 15))
	
	(fade_out 1 1 1 15)
	
	(sleep 15)
	
	(object_destroy chief)
	(object_destroy shotgun)
	(object_destroy mendoza_dead)
	
	(cinematic_set_near_clip_distance .0625)
)
	
;	MAIN SCRIPT

(script static void x50

	(fade_out 1 1 1 30)

	(sound_looping_start sound\sinomatixx_foley\x50_foley1 none 1)

	(sleep 20)

	(sound_looping_start sound\sinomatixx_music\x50_music01 none 1)
	(sound_class_set_gain ambient .5 0)
	
	(sleep 30)
	
	(switch_bsp 2)
	
	(object_teleport (player0) player0_int_base)
	(object_teleport (player1) player1_int_base) 
	
	(unit_suspended (player0) true)
	(unit_suspended (player1) true)
 
	(camera_control on)
	(cinematic_start)
	
;	BEGIN "SETUP" SCENE
	(setup)
	
;	BEGIN "INTRO" SCENE
	(intro)
	
	(fade_out 0 0 0 0)
	
	(switch_bsp 0)
	
	(object_teleport (player0) player0_ext_base)
	(object_teleport (player1) player1_ext_base)
	
	(cinematic_screen_effect_stop)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_video 2 2)
	
	(set weather off)
	
	(sound_class_set_gain device_door 0 0)
	
; 	BEGIN "PELICAN" SCENE
	(pelican)
	
	(fade_out 0 0 0 0)
	
	(set test_play_flash false)
	(set test_ffw_flash true)
	(sound_impulse_start sound\sinomatixx_foley\x50_ffw_play none 1)
	(sleep 120)
	(set test_ffw_flash false)
	(set test_play_flash true)
	(sleep 30)
	
	(set weather on)
	
	(sound_class_set_gain device_door 1 0)
	
;	BEGIN "DOOR" SCENE
	(door)
	
	(switch_bsp 2)
	
	(object_teleport (player0) player0_int_base)
	(object_teleport (player1) player1_int_base) 

	(set test_play_flash false)
	(set test_ffw_flash true)
	(sound_impulse_start sound\sinomatixx_foley\x50_ffw_play none 1)
	(sleep 120)
	(set test_ffw_flash false)
	(set test_play_flash true)
	(sleep 30)
	
	(cinematic_screen_effect_stop)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_video 1 2) 
	
;	BEGIN "CHECK" SCENE
	(check)
	
	(fade_out 0 0 0 0)
	
	(set test_play_flash false)
	(set test_ffw_flash true)
	(sound_impulse_start sound\sinomatixx_foley\x50_ffw_play none 1)
	(sleep 120)
	(set test_ffw_flash false)
	(set test_play_flash true)
	(sleep 30)
	
	(cinematic_screen_effect_stop)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_video 1 2) 
	
;	BEGIN "LAB" SCENE
	(lab)	
	
	(device_set_position control_door_a 0)
	
	(set test_play_flash false)
	(sleep 30)
	(cinematic_set_title halt)
	(cinematic_set_title incapacitation_red)
	(sleep 150)
	(cinematic_set_title terminated)
	(sleep 90)
	
	(cinematic_screen_effect_stop)
	(cinematic_show_letterbox on)

;	BEGIN "FINAL" SCENE
	(final)
	
;	(object_teleport (player0) player0_playon_base)
;	(object_teleport (player1) player1_playon_base)
	
	(unit_suspended (player0) false)
	(unit_suspended (player1) false)
	
	(object_destroy chief)
	(object_destroy keyes_pistol)
	(object_destroy keyes)
	(object_destroy johnson)
	(object_destroy mendoza)
	(object_destroy mendoza_dead)
	(object_destroy jenkins)
	(object_destroy bisenti)
	(object_destroy marine_1)
	(object_destroy marine_2)
	(object_destroy marine_3)
	(object_create_anew_containing blood)
	(object_create_anew_containing ar_)
	
	(object_pvs_activate none)
	
;	(fade_in 1 1 1 15)
	(sleep 30)
	(camera_control off)
;
; Joe, I commented this out so that I don't have to move my chapter titles into your scenario
; and manage them in two different locations.
;	(cinematic_stop)
)


; Joe, I did this because when you skip the cinema this door doesn't get destroyed and it borks everything up for me
(script static void destroy_door_a
	(object_destroy control_door_a)
)

(script dormant extraction_music
	(sleep 150)
	(sound_looping_start sound\sinomatixx_music\c10_extraction_music none 1)
)

(script static void cutscene_extraction

	(wake extraction_music)

	(fade_out 1 1 1 15)

	(camera_control on)
	(cinematic_start)

	(switch_bsp 5)

	(object_teleport (player0) player0_extract_base)
	(object_teleport (player1) player1_extract_base)

	(unit_suspended (player0) true)
	(unit_suspended (player1) true)

	(sleep 15)

	(object_create_anew chief_extraction)
	(object_create_anew monitor_cine)
	(object_create_anew rifle)
	
	(object_beautify chief true)
	(object_pvs_activate monitor_cine)

	(object_set_scale chief .1 0)
	
	(objects_attach chief_extraction "right hand" rifle "")	

	(object_teleport monitor_cine monitor_teleport_base)
	
	(camera_set chief_teleport_1a 0)
	(camera_set chief_teleport_1b 60)
	
	(fade_in 1 1 1 15)
	
	(object_create_anew chief_teleport_short)
	(device_set_position chief_teleport_short 1)
	(sleep 15)
	(object_teleport chief_extraction chief_teleport_base)
	(object_set_scale chief 1 15)
	
	(ai_attach_free monitor_cine characters\monitor\monitor)
	(ai_command_list_by_unit monitor_cine look_at_chief)

	(custom_animation chief_extraction cinematics\animations\chief\level_specific\c10\c10 c10SeeMonitor false)
	(sleep 90)

	(camera_set monitor_close_1a 0)
	(camera_set monitor_close_1b 180)

	(sound_impulse_start sound\dialog\c10\C10_extract_010_monitor monitor_cine 1)
	(print "monitor: Greetings. I am the Monitor of Installation Zero Four. I am 342 Guilty Spark.")

	(sleep (- (sound_impulse_time sound\dialog\c10\C10_extract_010_monitor) 30))
	
	(object_teleport chief_extraction chief_stand_base)
	(custom_animation chief_extraction cinematics\animations\chief\level_specific\c10\c10 c10InspectMonitor false)
	
	(sleep (sound_impulse_time sound\dialog\c10\C10_extract_010_monitor))
	
	(camera_set chief_rev_1a 0)
	(camera_set chief_rev_1b 200)

	(sleep 30)

	(sound_impulse_start sound\dialog\c10\C10_extract_020_monitor monitor_cine 1)
	(print "monitor: Unfortunate. Someone has released the Flood. It will be necessary for us to activate the Installation's containment measures. Please come with me.")
	(sleep (sound_impulse_time sound\dialog\c10\C10_extract_020_monitor))
	
	(sleep 30)
	
	(camera_set nature_of_flood_1a 0)
	(camera_set nature_of_flood_1b 180)

	(sound_impulse_start sound\dialog\c10\C10_extract_030_monitor monitor_cine 1)
	(print "monitor: It is the nature of the Flood to spread. My function is to prevent it from leaving this installation, but I require your assistance.")
	(sleep (sound_impulse_time sound\dialog\c10\C10_extract_030_monitor))

	(sound_impulse_start sound\dialog\c10\C10_extract_040_monitor monitor_cine 1)
	(print "monitor: Come. This way.")
	(sleep (sound_impulse_time sound\dialog\c10\C10_extract_040_monitor))

	(camera_set two_shot_1a 0)
	(camera_set two_shot_1b 60)
	
;	(sleep 30)

;	(custom_animation chief_extraction cinematics\animations\chief\level_specific\c10\c10 c10chiefteleport false)
	(unit_stop_custom_animation chief)
	
	(object_create_anew chief_teleport)
	(device_set_position chief_teleport 1)
	
	(sleep 30)
	
	(object_set_scale chief_extraction .1 15)
	(object_set_scale rifle .1 15)

	(sleep 15)
	
	(object_destroy chief_extraction)
	(object_destroy rifle)
	
	(sleep (camera_time))
	
	(object_create_anew monitor_teleport)
	(device_set_position monitor_teleport 1)
	(object_set_scale monitor_cine .1 15)
	
	(camera_set dead_air_1a 0)
	(camera_set dead_air_1b 300)
	
	(sleep 15)
	(object_destroy chief_extraction)
	(object_destroy monitor_cine)
	
	(sleep 60)
	
	(sound_impulse_start sound\dialog\c10\C10_extract_050_pilot none 1)
	(print "pilot: [Radio] Chief!  I've lost your signal, where'd you go!?! Chief! Chief!")
;	(sleep (sound_impulse_time sound\dialog\c10\C10_extract_050_pilot))
	
	(sleep 185)
	
	(fade_out 0 0 0 30)
	(sleep 45)

;	(game_win)
)
