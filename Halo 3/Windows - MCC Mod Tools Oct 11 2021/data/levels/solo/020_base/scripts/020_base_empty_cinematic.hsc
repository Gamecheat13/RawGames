(global boolean start0 FALSE)
(global boolean start1 FALSE)
(global boolean start2 FALSE)
(global boolean start3 FALSE)
(global boolean start4 FALSE)

(script static void test_elevator_explosion

	(print "switching zone sets...")
	(switch_zone_set 020_01_03_exit_encounter)
	(sleep 1)

	; teleporting players... to the proper location 
	(print "teleporting players...")
	(object_teleport (player0) hangar_a_highway_explosion02)
	;(object_teleport (player1) hangar_a_return_player1)
	;(object_teleport (player2) hangar_a_return_player2)
	;(object_teleport (player3) hangar_a_return_player3)
	;(sleep 1)

    (device_set_position_immediate exit_elev_switch02 0)
	(device_set_position hangar_a_exit_door 1)
	(device_set_position_immediate exit_elev_top 1)
	(device_set_position_immediate exit_elev_front 1)
	(device_set_position_immediate elevator_exit 0)
	
	(set start0 TRUE)
	(wake 020_12_hangar_a_return)
	;(objects_attach elevator_exit "front" exit_elev_front "")

)

(script static void test_elevator_explosion_switch
    (device_set_position exit_elev_switch02 1)
)


(script continuous Exit01_Elevator_Activate
	(sleep_until (> (device_get_position exit_elev_switch02) 0)1)
;		(device_set_position exit_elev_top 0)
;		(device_set_position exit_elev_front 0)
    (set start4 FALSE)

)

(script dormant 020_12_hangar_a_return
    (wake cortana_moment_e)
	(wake cortana_moment_f) ; base blows up here
	(device_set_power sec_light03 1)			
	(object_destroy_containing hangar_a_return_object)
	(device_set_position door_highway_hangar01 1)	
	(sleep 60)
	(sleep_until (volume_test_players hangar_a_entrance_trig) 5)
	(device_set_position cave_a_door_command 0)

)

(script static void exit_door_break
	(device_set_position exit_elev_front 0)
	(device_set_position exit_elev_top	0.4)
		(sleep (random_range 5 10))
	(device_set_position exit_elev_top	0.45)
		(sleep (random_range 5 10))
	(device_set_position exit_elev_top	0.35)
		(sleep (random_range 5 10))
	(device_set_position exit_elev_top	0.4)
		(sleep (random_range 5 10))
)

(global boolean cortana_talking false)
(global boolean static_end FALSE)

(script dormant cortana_moment_e
	(sleep_until (volume_test_players hangar_a_entrance_trig) 1)
	(set cortana_talking true)	
	(wake 020cg_become)
	(set cortana_talking false)
	
)

(script dormant cortana_moment_f
	(sleep_until (> (device_get_position exit_elev_switch02) 0)1)
		(device_set_position exit_elev_top 0)
		(device_set_position exit_elev_front 0)
		;(set g_music_020_13 FALSE)	
	(sleep_until (= (device_get_position exit_elev_front) 0)1)
	(exit_door_break)
	(volume_teleport_players_not_inside blow_up_safe_zone exit_navpoint01)
	
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)
	
	(object_create_anew door_flames)
	(player_effect_start 0.60 0.25)

	(sleep 60)
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl1.sound" NONE 1)
	
	(sleep 60)
	(set cortana_talking true)	
	(wake 020cf_your_tomb)	
	(set cortana_talking false)
	;(damage_players levels\solo\020_base\fx\base_destruction\base_destruction)
	(sleep 30)
	(device_set_position elevator_exit 1)

;	(wake explosion_death)
	(sleep 145)
	(sound_impulse_start "sound\levels\020_base\sound_scenery\base_blowed_up.sound" NONE 1)	
	(sound_class_set_gain device_door 0 240)
	(sleep 95)
	
	(effect_new levels\solo\020_base\fx\bombing\bombing_end.effect exit_navpoint01)			
	(player_effect_stop 0.25)					

	(object_create_anew shaft_explosion_side)
	(object_create_anew shaft_explosion_down)
	
	
	(player_effect_set_max_rotation 0 1 0.25)
	(player_effect_set_max_rumble 1 1)
	(player_effect_start 0.75 0)
	

	(sleep 60)
	(fade_out 0 0 0 5)
	
	(player_effect_stop 5)	
	(sleep 240)
	(sound_class_set_gain ambient 0 15)
	(set cortana_talking true)	
	(sound_impulse_start sound\dialog\020_base\cortana\020cx_045_cor NONE 1)
		(sleep (sound_impulse_language_time sound\dialog\020_base\cortana\020cx_045_cor))
	
	(player_effect_stop 0.5)	
	
	
	;(sound_class_set_gain ambient 1 15)
	(sleep 180)
	;(game_award_level_complete_achievements)	
	(cinematic_snap_to_black)
	;(end_mission)	

)


(script static void hud_flicker_out
	(chud_cinematic_fade 0 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.05))
)
(script dormant cor_pa_static
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
	(set static_end TRUE)
	
)