;	X30 CINEMATIC SCRIPT
;	...component scripts up top, 
;	the whole she-bang at the bottom...

(script static void lifeboat_docked_load

	(object_create_anew lifeboat_x30_docked)
	(object_create_anew pilot_x30)
	(object_create_anew_containing marine_x30)
	
	(object_beautify lifeboat_x30_docked true)
	(object_beautify pilot_x30 true)
	(object_beautify marine_x30_1 true)
	(object_beautify marine_x30_2 true)
	(object_beautify marine_x30_3 true)
	(object_beautify marine_x30_4 true)
	(object_beautify marine_x30_5 true)
	(object_beautify marine_x30_6 true)
	(object_beautify marine_x30_7 true)
	(object_beautify marine_x30_8 true)

	(objects_attach lifeboat_x30_docked "driver" pilot_x30 "") 
	(objects_attach lifeboat_x30_docked "rider right a" marine_x30_2 "") 
	(objects_attach lifeboat_x30_docked "rider right b" marine_x30_3 "") 
	(objects_attach lifeboat_x30_docked "rider right c" marine_x30_4 "") 
	(objects_attach lifeboat_x30_docked "rider right d" marine_x30_5 "") 
	(objects_attach lifeboat_x30_docked "rider left a" marine_x30_6 "") 
	(objects_attach lifeboat_x30_docked "rider left b" marine_x30_7 "") 
	(objects_attach lifeboat_x30_docked "rider left d" marine_x30_8 "") 
	
	(custom_animation pilot_x30 cinematics\animations\pilot\x30\x30 idle true)
	(custom_animation marine_x30_2 cinematics\animations\marines\x30\x30 idle_hold_harness true)
	(custom_animation marine_x30_3 cinematics\animations\marines\x30\x30 idle_passed_out true)
	(custom_animation marine_x30_4 cinematics\animations\marines\x30\x30 idle_hold_harness true)
	(custom_animation marine_x30_5 cinematics\animations\marines\x30\x30 idle_relaxed true)
	(custom_animation marine_x30_6 cinematics\animations\marines\x30\x30 idle_hold_harness true)
	(custom_animation marine_x30_7 cinematics\animations\marines\x30\x30 idle_relaxed true)
	(custom_animation marine_x30_8 cinematics\animations\marines\x30\x30 idle_passed_out true)

)

(script static void lifeboat_space_load

	(object_create_anew chief_x30)
	(object_create_anew lifeboat_x30_space)
	(object_create_anew pilot_x30)
	(object_create_anew_containing marine_x30)
	
	(object_beautify chief_x30 true)
	(object_beautify pilot_x30 true)
	(object_beautify lifeboat_x30_space true)
	(object_beautify marine_x30_1 true)
	(object_beautify marine_x30_2 true)
	(object_beautify marine_x30_3 true)
	(object_beautify marine_x30_4 true)
	(object_beautify marine_x30_5 true)
	(object_beautify marine_x30_6 true)
	(object_beautify marine_x30_7 true)
	(object_beautify marine_x30_8 true)

	(object_teleport chief_x30 chief_x30_space_base) 
	(objects_attach lifeboat_x30_space "driver" pilot_x30 "") 
	(objects_attach lifeboat_x30_space "rider left a" marine_x30_1 "") 
	(objects_attach lifeboat_x30_space "rider right a" marine_x30_2 "") 
	(objects_attach lifeboat_x30_space "rider right b" marine_x30_3 "") 
	(objects_attach lifeboat_x30_space "rider right c" marine_x30_4 "") 
	(objects_attach lifeboat_x30_space "rider right d" marine_x30_5 "") 
	(objects_attach lifeboat_x30_space "rider left b" marine_x30_6 "") 
	(objects_attach lifeboat_x30_space "rider left c" marine_x30_7 "") 
	(objects_attach lifeboat_x30_space "rider left d" marine_x30_8 "") 
	
	(custom_animation pilot_x30 cinematics\animations\pilot\x30\x30 idle true)
	(custom_animation chief_x30 cinematics\animations\chief\x30\x30 escapepod_idle2hand true)
	(custom_animation marine_x30_1 cinematics\animations\marines\x30\x30 idle_hold_harness true)
	(custom_animation marine_x30_2 cinematics\animations\marines\x30\x30 idle_hold_harness true)
	(custom_animation marine_x30_3 cinematics\animations\marines\x30\x30 idle_passed_out true)
	(custom_animation marine_x30_4 cinematics\animations\marines\x30\x30 idle_hold_harness true)
	(custom_animation marine_x30_5 cinematics\animations\marines\x30\x30 idle_relaxed true)
	(custom_animation marine_x30_6 cinematics\animations\marines\x30\x30 idle_hold_harness true)
	(custom_animation marine_x30_7 cinematics\animations\marines\x30\x30 idle_relaxed true)
	(custom_animation marine_x30_8 cinematics\animations\marines\x30\x30 idle_passed_out true)
)


(script static void into_the_breach

	(sound_looping_start sound\sinomatixx_foley\x30_foley1 none 1)

	(unit_open lifeboat_x30_docked)

	(object_create_anew chief_x30)
	(object_create_anew marine_x30_1)
	(object_create_anew x30_rifle)
	(object_create_anew x30_rifle_2)
	
	(object_beautify chief_x30 true)
	(object_beautify marine_x30_1 true)
	
	(object_pvs_activate chief_x30)
	
	(objects_attach chief_x30 "right hand" x30_rifle "")
	(objects_attach marine_x30_1 "right hand" x30_rifle_2 "")
	(object_teleport marine_x30_1 marine_x30_1_base)
	
	(camera_set breach_1a 0)
	(camera_set breach_1c 60)
	
	(fade_in 1 1 1 15)
	
	(custom_animation marine_x30_1 cinematics\animations\marines\x30\x30 clip01-runandjump true)
	
	(player_effect_set_max_translation 0 0 0)
	(player_effect_set_max_rotation 0 0 0)
	(player_effect_set_max_vibrate 0 0)
	
	(effect_new "effects\explosions\medium explosion cinematic" explosion_x30_1)
	
	(player_effect_set_max_translation 0 0 0)
	(player_effect_set_max_rotation 0 0 0)
	(player_effect_set_max_vibrate 0 0)
	
	(player_effect_set_max_rotation 0 .25 .25)
	(player_effect_start 1 0)	
	
	(sleep 30)
	
	(sound_impulse_start sound\dialog\x30\mar1_01 marine_x30_1 1)
;	(print "marine#1: Oh no, oh no!")
	
	(player_effect_stop 2)
	
	(sleep (unit_get_custom_animation_time marine_x30_1)) 
	
	(camera_set chief_grab_1a 0)
	(object_teleport chief_x30 chief_x30_dock_base)
	
	(camera_set breach_2a 0)
	(camera_set breach_2b 30)
	
	(unit_stop_custom_animation marine_x30_1)
	(custom_animation marine_x30_1 cinematics\animations\marines\x30\x30 clip02-grabedandthrown false)
	(custom_animation chief_x30 cinematics\animations\chief\x30\x30 clip01-throwandshoot false)
	
	(sleep 30)

	(camera_set throw_3a 0)
	(camera_set chief_throw_1b 30)
	
	(sound_impulse_start sound\dialog\x30\mar1_02 marine_x30_1 1)
;	(print "marine: gah!")
	(sleep (sound_impulse_time sound\dialog\x30\mar1_02))
	
	(sound_impulse_start sound\dialog\x30\cor_01 none 1)
;	(print "cortana: now would be a very good time to leave")
	
	(sleep 30)
	(camera_set chief_throw_1c 60)
	(sleep 60)
	
	(camera_set punch_it_1a 0)
	(camera_set punch_it_1b 90)
	
	(sound_looping_start sound\sinomatixx\x30_music none 1)
	
	(objects_detach marine_x30_1 x30_rifle_2)
	(object_destroy x30_rifle_2)
	
	(sound_impulse_start sound\sfx\impulse\doors\lifepod_door none 1)
	(unit_close lifeboat_x30_docked)
	
;	(custom_animation lifeboat_x30_docked vehicles\lifepod_docked\lifepod_docked "stand closing" true)
	(sleep 30)
;	(custom_animation lifeboat_x30_docked vehicles\lifepod_docked\lifepod_docked "safety_belt" true)
	
	(sleep (- (camera_time) 15))
	
	(sound_impulse_start sound\dialog\x30\che_01 chief_x30 1)
;	(print "chief: punch_it")
	(sleep (sound_impulse_time sound\dialog\x30\che_01))
	
	(camera_set x30_aye_aye_1a 0)

	(custom_animation pilot_x30 cinematics\animations\pilot\x30\x30 aye_aye_sir true)
	(sound_impulse_start sound\dialog\x30\lif_01 pilot_x30 1)
;	(print "pilot: aye-aye, sir!")
	(sleep (- (sound_impulse_time sound\dialog\x30\lif_01) 15))
	(camera_set x30_aye_aye_1b 30)

	(sleep (unit_get_custom_animation_time pilot_x30))
)

(script static void launch

;	(object_destroy lifeboat_x30_docked)
	(object_destroy chief_x30)
	(object_destroy pilot_x30)
	(object_destroy marine_x30_1)
	(object_destroy marine_x30_2)
	(object_destroy marine_x30_3)
	(object_destroy marine_x30_4)
	(object_destroy marine_x30_5)
	(object_destroy marine_x30_6)
	(object_destroy marine_x30_7)
	(object_destroy marine_x30_8)
	
	(object_create_anew lifeboat_x30_docked)
	(object_pvs_activate lifeboat_x30_docked)
	(unit_close lifeboat_x30_docked)
	
	(object_teleport lifeboat_x30_docked lifeboat_launch_base)
	(effect_new "levels\a10\devices\lifepod device\effects\explosion" explosion_x30_2)
	(custom_animation lifeboat_x30_docked cinematics\animations\lifeboat\x30\x30 takeoff true)

	(camera_set takeoff_1a 0)
	(camera_set takeoff_1b 30)
	
	(sleep 30)
	
	(player_effect_set_max_translation 0 0 0)
	(player_effect_set_max_rotation 0 0 0)
	(player_effect_set_max_vibrate 0 0)
	
	(player_effect_set_max_translation 0 0 0)
	(player_effect_set_max_rotation 0 0 0)
	(player_effect_set_max_vibrate 0 0)
	
	(player_effect_set_max_rotation 0 .25 .25)
	(player_effect_start 1 0)
	(player_effect_stop 4)
	
	(sleep 30)
	
	(objects_detach chief_x30 x30_rifle)
	(object_destroy x30_rifle)
)

(script static void animation_test

	(object_create_anew lifeboat_x30_double)
	
	(object_beautify lifeboat_x30_double true)

	(object_teleport lifeboat_x30_double flight1_base) 
;	(scenery_animation_start lifeboat_x30_double cinematics\animations\lifeboat\x30\x30 takeoff)
;	(scenery_animation_start lifeboat_x30_double cinematics\animations\lifeboat\x30\x30 flight1)
	(custom_animation lifeboat_x30_double cinematics\animations\lifeboat\x30\x30 flight2 true)

;	(camera_set_relative fall_away_1a 0 lifeboat_x30_double)
;	(camera_set_relative fall_away_1b 90 lifeboat_x30_double)
	(sleep 90)
;	(camera_set_relative fall_away_1c 90 lifeboat_x30_double)

)

(script dormant safe_pyro

	(object_create_anew main_cannon_fire)
	(object_create_anew engine_fire)
	(object_create_anew spot_fire_1)
	(object_create_anew spot_fire_2)
	(object_create_anew spot_fire_3)

	(effect_new "effects\explosions\large explosion" safe_pyro_1a)
	(effect_new "effects\explosions\medium explosion" safe_pyro_1b)
	(sleep 30)
	(effect_new "effects\explosions\medium explosion" safe_pyro_1i)
	(effect_new "effects\explosions\large explosion" safe_pyro_1d)
	(effect_new "effects\explosions\medium explosion" safe_pyro_1c)
	(sleep 45)
	(effect_new "effects\explosions\large explosion" safe_pyro_1e)
	(effect_new "effects\explosions\medium explosion" safe_pyro_1f)
	(sleep 40)
	(effect_new "effects\explosions\medium explosion" safe_pyro_1g)	
	(effect_new "effects\explosions\large explosion" safe_pyro_1h)
)

(script static void minimum_safe_distance

	(wake safe_pyro)

	(object_create_anew lifeboat_x30_double)
	
	(object_pvs_activate lifeboat_x30_double)
	
	(object_beautify lifeboat_x30_double true)
	(object_teleport lifeboat_x30_double flight1_base) 
	
	(object_set_scale lifeboat_x30_double .5 0)
	
	(camera_set_relative fall_away_1a 0 lifeboat_x30_double)

	(effect_new "effects\explosions\medium explosion no objects cinematic" explosion_x30_3)

	(custom_animation lifeboat_x30_double cinematics\animations\lifeboat\x30\x30 flight1 true)
	
	(sound_impulse_start sound\dialog\x30\lif_02 none 1)
;	(print "pilot: We're disengaged. Going for minimum safe distance!")
	
	(camera_set_relative safe_distance_1a 180 lifeboat_x30_double)
	
	(sleep (sound_impulse_time sound\dialog\x30\lif_02))
	
;	(camera_set_relative fall_away_1c 90 lifeboat_x30_double)
	(sleep 60)
)

(script dormant approach_setup
	(object_create_anew lifeboat_approach)
	(object_beautify lifeboat_approach true)
	(unit_close lifeboat_approach)
)

(script static void buck_up

	(sound_looping_start sound\sinomatixx_foley\x30_foley2 none 1)

	(object_pvs_activate chief_x30)
	
	(player_effect_set_max_translation 0 0 0)
	(player_effect_set_max_rotation 0 0 0)
	(player_effect_set_max_vibrate 0 0)

	(player_effect_set_max_rotation 0 .25 .25)
	(player_effect_start 1 0)	

	(camera_set gonna_make_it_1a 0)
	(camera_set gonna_make_it_1b 90)

	(custom_animation chief_x30 cinematics\animations\chief\x30\x30 hand_on_shoulder true)
	(custom_animation marine_x30_1 cinematics\animations\marines\x30\x30 hand_on_shoulder true)
	
	(sleep 1)

	(sound_impulse_start sound\dialog\x30\mar1_03 marine_x30_1 1)
;	(print "marine: We're gonna make it, aren't we Sir? I don't wanna die out here!")
	(sleep (sound_impulse_time sound\dialog\x30\mar1_03))
	
	(unit_stop_custom_animation marine_x30_1)
	(custom_animation marine_x30_1 cinematics\animations\marines\x30\x30 idle_hold_harness true)
	
	(camera_set shoulder_1a 0)
	(camera_set shoulder_1b 60)
	
	(sleep (- (unit_get_custom_animation_time chief_x30) 60))
	
	(camera_set chief_walk_forward_1a 0)
	
	(sound_impulse_start sound\dialog\x30\cor_02 none 1)
;	(print "cortana: look!")
	
	(sleep 30)
	
	(camera_set chief_walk_forward_1b 90)
	
	(sleep 30)
	
;	(object_teleport chief_x30 chief_x30_space_base)

	(object_destroy halo_x30_1)
	(object_create halo_x30_1)

	(object_teleport chief_x30 chief_halo_look_base)

	(unit_stop_custom_animation chief_x30)
	(custom_animation chief_x30 cinematics\animations\chief\x30\x30 escapepod_checkpilot false)
	
	(sleep 6)

	(camera_set chief_halo_look_1a 0)
	(camera_set chief_halo_look_1b 180)
	
	(object_set_scale halo_x30_1 2 1000)
	
	(wake approach_setup)
	
	(sleep 220)
)

(script static void halo_look
	
	(camera_set chief_halo_look_1a 0)
	(object_set_scale halo_x30_1 2 1000)
	
	(object_teleport chief_x30 chief_halo_look_base)
	(custom_animation chief_x30 cinematics\animations\chief\x30\x30 escapepod_checkpilot true)
	(camera_set chief_halo_look_1b 180)
	(sleep 250)
)

(script static void approach

	(sound_looping_stop sound\sinomatixx_foley\x30_foley2)

	(object_destroy halo_x30_1)	
	(object_create_anew halo_x30_2)
	
;	(object_create_anew lifeboat_approach)
;	(object_beautify lifeboat_approach true)
;	(unit_close lifeboat_approach)

	(object_set_scale lifeboat_approach .25 0)
	(object_set_scale halo_x30_2 2 0)
	
	(object_pvs_activate lifeboat_approach)
	
	(object_teleport lifeboat_approach halo_approach_base)
	
	(camera_set halo_approach_1a 0)
	(camera_set halo_approach_1b 240)
	
	(object_set_scale lifeboat_approach .02 200)
	(object_set_scale halo_x30_2 3 2000)
	(sleep 200)
)

;(script static void approach_build
;	(object_create_anew lifeboat_x30_double)
;	(object_teleport lifeboat_x30_double halo_approach_base)
;
;	(object_set_scale lifeboat_x30_double .05 300)
;	(object_set_scale halo_x30_2 2 2000)
;	(sleep 300)
;)

;(script static void approach_reset
;	(object_set_scale lifeboat_x30_double 1 0)
;	(object_set_scale halo_x30_2 1 0)
;)

(script static void autumn_int

	(sound_looping_start sound\sinomatixx_foley\x30_foley3 none 1)

	(object_pvs_activate chief_x30)
	
	(player_effect_set_max_translation 0 0 0)
	(player_effect_set_max_rotation 0 0 0)
	(player_effect_set_max_vibrate 0 0)

	(player_effect_set_max_rotation 0 .4 .4)
	
	(object_destroy halo_x30_2)
	(object_destroy lifeboat_x30_double)
	
	(camera_set what_is_1d 0)
	(camera_set what_is_1a 60)	

	(sound_impulse_start sound\dialog\x30\mar2_01 marine_x30_1 1)
;	(print "marine#2: What...what is that thing?")
	(sleep (sound_impulse_time sound\dialog\x30\mar2_01))
	
	(camera_set what_is_1b 0)
	(camera_set what_is_1c 90)
	
	(custom_animation pilot_x30 cinematics\animations\pilot\x30\x30 hell_if_I_know true)
	
	(sound_impulse_start sound\dialog\x30\lif_04 pilot_x30 1)
;	(print "pilot: Hell if I know. But we're landing on it!")
	(sleep (sound_impulse_time sound\dialog\x30\lif_04))
	
	(camera_set the_autumn_1a 0)
	(camera_set the_autumn_1b 30)
	
	(unit_close lifeboat_x30_space)
	
	(object_teleport chief_x30 chief_autumn_look_base)
	
	(sound_impulse_start sound\dialog\x30\mar1_04 marine_x30_2 1)
;	(print "marine#1: The Autumn, she's been hit!")
	(sleep (sound_impulse_time sound\dialog\x30\mar1_04))

	(custom_animation chief_x30 cinematics\animations\chief\x30\x30 look_out_hatch false)
	
	(camera_set autumn_hit_1c 0)
	(camera_set autumn_hit_1b 60)
	
	(sound_impulse_start sound\dialog\x30\cor_03 none 1)
;	(print "cortana: I knew it. The Autumn's accelerating. He's going in manual.")
	(sleep (- (sound_impulse_time sound\dialog\x30\cor_03) 60))
)

(script static void autumn_int_build
	(object_teleport chief_x30 chief_autumn_look_base)
	(custom_animation chief_x30 cinematics\animations\chief\x30\x30 look_out_hatch false)
)

(script dormant pass_pyro
	(effect_new "effects\explosions\large explosion" pass_pyro_1a)
	(effect_new "effects\explosions\medium explosion" safe_pyro_1b)
	(sleep 30)
	(effect_new "effects\explosions\medium explosion" safe_pyro_1g)
	(effect_new "effects\explosions\large explosion" safe_pyro_1h)
	(sleep 45)
	(effect_new "effects\explosions\large explosion" safe_pyro_1c)
	(sleep 15)
	(effect_new "effects\explosions\medium explosion" safe_pyro_1d)
	(sleep 15)
	(effect_new "effects\explosions\medium explosion" safe_pyro_1e)
	(sleep 15)	
	(effect_new "effects\explosions\large explosion" safe_pyro_1f)
)

(script dormant heavy_fire_1
	(effect_new "effects\bursts\space beam large" heavy_fire_1a)
	(sleep 30)
	(effect_new "effects\bursts\space beam large" heavy_fire_1b)
	(sleep 15)
;	(effect_new "effects\bursts\space beam large" heavy_fire_1c)
	(sleep 30)
	(effect_new "effects\bursts\space beam large" heavy_fire_1d)
	(sleep 15)
;	(effect_new "effects\bursts\space beam large" heavy_fire_1b)
	(sleep 30)
	(effect_new "effects\bursts\space beam large" heavy_fire_1c)
)

(script dormant heavy_fire_2
	(effect_new "effects\bursts\space beam large" heavy_fire_2a)
	(sleep 30)
	(effect_new "effects\bursts\space beam large" heavy_fire_2b)
	(sleep 15)
	(effect_new "effects\bursts\space beam large" heavy_fire_2c)
	(sleep 30)
	(effect_new "effects\bursts\space beam large" heavy_fire_2d)
	(sleep 15)
	(effect_new "effects\bursts\space beam large" heavy_fire_2c)
	(sleep 30)
	(effect_new "effects\bursts\space beam large" heavy_fire_2d)
)

(script static void autumn_ext

	(object_create_anew lifeboat_x30_double)
	
	(object_pvs_activate lifeboat_x30_double)
	
	(object_create_anew_containing poa_fire)
	
	(object_beautify lifeboat_x30_double true)
	(object_teleport lifeboat_x30_double flight2_base) 
	
	(object_set_scale lifeboat_x30_double .25 0)
	(custom_animation lifeboat_x30_double cinematics\animations\lifeboat\x30\x30 flight2 false)
	
	(camera_set_relative pull_back_1a 0 lifeboat_x30_double)
	(camera_set_relative pull_back_1b 120 lifeboat_x30_double)
	(sleep 60)
	
	(wake heavy_fire_1)
	(wake pass_pyro)
	
	(camera_set_relative pull_back_1c 120 lifeboat_x30_double)
	(sleep 60)
	
	(wake heavy_fire_2)
	
	(camera_set_relative pull_back_1d 120 lifeboat_x30_double)
	(sleep 120)
)

(script static void flight2_test
	(object_teleport lifeboat_x30_double flight2_base) 
	(custom_animation lifeboat_x30_double cinematics\animations\lifeboat\x30\x30 flight2 true)
)

(script static void atmos_int_1

	(object_destroy lifeboat_approach)

	(sound_looping_start sound\sinomatixx_foley\x30_foley4 none 1)

	(object_pvs_activate chief_x30)

	(object_destroy lifeboat_burn)
	(object_create lifeboat_burn)
	
	(custom_animation pilot_x30 cinematics\animations\pilot\x30\x30 heads_up false)
	
	(camera_set heads_up_1b 0)
	(camera_set heads_up_1a 120)
	
	(sleep 1)
	
	(sound_impulse_start sound\dialog\x30\lif_05 pilot_x30 1)
;	(print "pilot: Heads-up everyone. This is it! We're entering the ring's atmosphere in 5!")
	(sleep (sound_impulse_time sound\dialog\x30\lif_05))
)

(script static void atmos_ext

	(object_teleport chief_x30 chief_impact_base)
	(unit_stop_custom_animation chief_x30)
	(custom_animation chief_x30 cinematics\animations\chief\x30\x30 escapepod_idle2hand false)

	(custom_animation lifeboat_burn scenery\vehicles\lifepod_atmosphere_entry\lifepod_atmosphere_entry idle_fall false)
	
	(camera_set_relative burn_3a 0 lifeboat_burn)
	(camera_set_relative burn_3b 120 lifeboat_burn)
	(sleep 90)
)

(script static void burn_test
	(object_create_anew halo_closeup)
	(object_create_anew lifeboat_burn)
	
	(object_destroy halo_x30_1)
	(object_destroy halo_x30_2)
	
	(object_set_scale halo_closeup 8.25 0)
	
	(object_teleport lifeboat_burn entry_base)
	
	(custom_animation lifeboat_burn scenery\vehicles\lifepod_atmosphere_entry\lifepod_atmosphere_entry idle_fall false)
	
	(camera_set_relative final_burn_1a 0 lifeboat_burn)
	
	(sleep 1)
	(game_speed 0)
)


(script static void atmos_int_2
	
	(camera_set chief_impact_1a 0)

	(sound_impulse_start sound\dialog\x30\cor_04 none 1)
	(print "cortana: You sure you wouldn't rather take a seat?")
	(sleep (sound_impulse_time sound\dialog\x30\cor_04))
	
	(object_create_anew halo_closeup)
	(object_create_anew lifeboat_burn)
	
	(object_destroy halo_x30_1)
	(object_destroy halo_x30_2)
	
	(object_set_scale halo_closeup 8.25 0)
	
	(object_teleport lifeboat_burn entry_base)
	
	(custom_animation lifeboat_burn scenery\vehicles\lifepod_atmosphere_entry\lifepod_atmosphere_entry idle_fall true)
	
	(camera_set_relative final_burn_1a 0 lifeboat_burn)
	
	(player_effect_set_max_translation 0 0 0)
	(player_effect_set_max_rotation 0 0 0)
	(player_effect_set_max_vibrate 0 0)
	
	(player_effect_set_max_rotation 0 .5 .5)
		
	(sleep 5)
	(sound_impulse_start sound\dialog\x30\che_02 none 1)
	(print "chief: We'll be fine.")
;	(sleep (sound_impulse_time sound\dialog\x30\che_02))
	
	(sleep 120)
	
	(camera_set chief_impact_1b 0)
	(unit_stop_custom_animation chief_x30)
	(custom_animation chief_x30 cinematics\animations\chief\x30\x30 brace true)
	
	(object_create_anew halo_closeup_2)
	
	(camera_set chief_impact_1c 120)
	
	(player_effect_set_max_rotation 0 .6 .6)
	
	(sound_impulse_start sound\dialog\x30\cor_05 none 1)
;	(print "cortana: If I still had fingers, they'd be crossed.")
	
	(sleep (- (camera_time) 90))
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_filter_desaturation_tint 1 1 1)
	(cinematic_screen_effect_set_filter 0 1 0 1 true 2)
	(cinematic_screen_effect_set_convolution 1 2 .001 10 2)
	
	(sleep 30)
	(fade_out 1 1 1 30)
	(sleep 60)
)

(script static void atmos_build
	(object_teleport chief_x30 chief_impact_base)
	(unit_stop_custom_animation chief_x30)
	(custom_animation chief_x30 cinematics\animations\chief\x30\x30 escapepod_idle2hand true)
)

(script static void x30

	(object_destroy_all)

	(player_effect_set_max_translation 0 0 0)
	(player_effect_set_max_rotation 0 0 0)
	(player_effect_set_max_vibrate 0 0)
	
	(fade_out 1 1 1 0)
	
	(cinematic_start)
	(camera_control on)
	
	(object_teleport (player0) player0_x30_base)
	(object_teleport (player1) player1_x30_base)
	
	(unit_suspended (player0) true)
	(unit_suspended (player1) true)
	
	(switch_bsp 6)
	
	(lifeboat_docked_load)
	
;	BEGIN "INTO_THE_BREACH" SCENE
	(into_the_breach)

;	BEGIN "LAUNCH" SCENE
	(launch)

	(fade_out 0 0 0 0)
	(switch_bsp 7)
	
	(lifeboat_space_load)
	
	(fade_in 0 0 0 0)
	
;	BEGIN "MINIMUM_SAFE_DISTANCE" SCENE
	(minimum_safe_distance)

;	BEGIN "BUCK_UP" SCENE
	(buck_up)

;	BEGIN "APPROACH" SCENE
	(approach)

;	BEGIN "AUTUMN_INT" SCENE
	(autumn_int)
	
;	BEGIN "AUTUMN_EXT" SCENE
	(autumn_ext)
	
;	BEGIN "ATMOS_INT_1" SCENE
	(atmos_int_1)
	
;	BEGIN "ATMOS_EXT" SCENE
	(atmos_ext)
	
;	BEGIN "ATMOS_INT_2" SCENE
	(atmos_int_2)
	
	(cinematic_screen_effect_stop)
	
	(sleep 210)
	
;	(game_win)
)
