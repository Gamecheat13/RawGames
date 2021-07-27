;		A50 Cinematics Script

;========== Cutscene Scripts ==========

; Joe, I changed this so it doesn't take as much time.

(script dormant dialog_insertion
	(sound_impulse_start sound\dialog\a50\a50_insert_010_cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a50\a50_insert_010_cortana))
	(sleep 1)
	(sound_impulse_start sound\dialog\a50\a50_insert_020_bisenti none 1)
		(sleep (sound_impulse_time sound\dialog\a50\a50_insert_020_bisenti))
	(sleep 1)
	(sound_impulse_start sound\dialog\a50\a50_insert_030_sarge none 1)
		(sleep (sound_impulse_time sound\dialog\a50\a50_insert_030_sarge))
	(sleep 1)
;	(sound_impulse_start sound\dialog\a50\a50_insert_040_pilot none 1)
;		(sleep (sound_impulse_time sound\dialog\a50\a50_insert_040_pilot))
;	(sleep 1)
	(sound_impulse_start sound\dialog\a50\a50_insert_050_cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a50\a50_insert_050_cortana))
;	(sleep 1)
;	(sound_impulse_start sound\dialog\a50\a50_insert_060_cortana none 1)
;		(sleep (sound_impulse_time sound\dialog\a50\a50_insert_060_cortana))
;	(sleep 1)
;	(sound_impulse_start sound\dialog\a50\a50_insert_070_pilot none 1)
;		(sleep (sound_impulse_time sound\dialog\a50\a50_insert_070_pilot))
;	(sleep 1)
;	(sound_impulse_start sound\dialog\a50\a50_insert_080_sarge none 1)
;		(sleep (sound_impulse_time sound\dialog\a50\a50_insert_080_sarge))
;	(sleep 1)
	)

(script static void cutscene_insertion
;	(object_destroy insertion_pelican)
	(object_create_anew insertion_pelican)
	(object_teleport insertion_pelican insertion_pelican_1)
	(recording_play insertion_pelican insertion_pelican_in)
	
	(objects_predict insertion_pelican)
	
;	(fade_out 0 0 0 0)
	(cinematic_start)
	(show_hud 0)
	(camera_control on)
	
;	(ai_place marines_initial)
	(object_create ini_marine_1)
	(object_create ini_marine_2)
;	(object_create ini_marine_3)
	(object_create ini_marine_4)
	(object_create ini_marine_5)
;	(object_create ini_marine_6)
	(object_create ini_marine_7)

	(ai_attach ini_marine_1 marines_initial/marines_ini_left)
	(ai_attach ini_marine_2 marines_initial/marines_ini_left)
	(ai_attach ini_marine_3 marines_initial/marines_ini_left)
	(ai_attach ini_marine_4 marines_initial/marines_ini_right)
	(ai_attach ini_marine_5 marines_initial/marines_ini_right)
	(ai_attach ini_marine_6 marines_initial/marines_ini_right)
	(ai_attach ini_marine_7 marines_initial/marines_ini_right)
	(sleep 1)
	(objects_predict (ai_actors marines_initial))
	(objects_predict insertion_pelican)
	
	(unit_enter_vehicle (player0) insertion_pelican "P-riderLF")
	(unit_enter_vehicle (player1) insertion_pelican "P-riderRF")

	(vehicle_load_magic insertion_pelican "riderL" (ai_actors marines_initial/marines_ini_right))
	(vehicle_load_magic insertion_pelican "riderR" (ai_actors marines_initial/marines_ini_left))

	(camera_set insertion_1 0)
	(fade_in 0 0 0 60)
	(camera_set insertion_3 300)
	
	(sound_class_set_gain vehicle 0 0)
	
	(sound_looping_start sound\sinomatixx\a50_insertion_foley none 1)
	(sound_looping_start sound\sinomatixx\a50_insertion_music none 1)

	(wake dialog_insertion)
;	(ai_conversation insertion)
	
	(sleep 300)
	(player_effect_set_max_rotation 0 .15 .15)
	(player_effect_start 1 0 )
	(sleep 120)
	(camera_set insertion_4 210)
	(cinematic_set_title mission_start)
	(sleep 210)
	(fade_in 1 1 1 30)
	(camera_control off)
	
	(sound_class_set_gain vehicle 1 1)
	
	(object_set_facing (player0) initial_facing)
	(object_set_facing (player1) initial_facing)
	
	(player_effect_stop 0)
	(sleep (recording_time insertion_pelican))
	(vehicle_hover insertion_pelican 1)
	(unit_exit_vehicle (player0))
	(unit_exit_vehicle (player1))
	(sleep 60)
	(game_save_totally_unsafe)
	(unit_set_enterable_by_player insertion_pelican false)
	
	(cinematic_stop)
	(show_hud 1)
	(sleep 30)

	(unit_exit_vehicle ini_marine_1)
	(ai_command_list_by_unit ini_marine_1 forward_4s)
	(ai_command_list_by_unit ini_marine_1 ini_marine_c)
	(sleep 10)
	
	(unit_exit_vehicle ini_marine_4)
	(ai_command_list_by_unit ini_marine_4 forward_4s)
	(ai_command_list_by_unit ini_marine_4 ini_marine_d)
	(sleep 10)
	
	(unit_exit_vehicle ini_marine_2)
	(ai_command_list_by_unit ini_marine_2 forward_4s)
	(ai_command_list_by_unit ini_marine_2 ini_marine_b)
	(sleep 10)
	
	
	(unit_exit_vehicle ini_marine_5)
	(ai_command_list_by_unit ini_marine_5 forward_4s)
	(ai_command_list_by_unit ini_marine_5 ini_marine_e)
	(sleep 10)
	
	(unit_exit_vehicle ini_marine_3)
	(ai_command_list_by_unit ini_marine_3 forward_4s)
	(ai_command_list_by_unit ini_marine_3 ini_marine_a)
	(sleep 10)
	
	(unit_exit_vehicle ini_marine_7)
	(ai_command_list_by_unit ini_marine_7 forward_4s)
	(ai_command_list_by_unit ini_marine_7 ini_marine_g)
	(sleep 10)
	
	(sound_impulse_start sound\dialog\a50\a50_insert_080_sarge none 1)

	(unit_exit_vehicle ini_marine_6)
	(ai_command_list_by_unit ini_marine_6 forward_4s)
	(ai_command_list_by_unit ini_marine_6 ini_marine_f)
	(sleep 30)
	

;	(unit_set_desired_flashlight_state ini_marine_1 1)
;	(unit_set_desired_flashlight_state ini_marine_2 1)
;	(unit_set_desired_flashlight_state ini_marine_3 1)
;	(unit_set_desired_flashlight_state ini_marine_4 1)
;	(unit_set_desired_flashlight_state ini_marine_5 1)
;	(unit_set_desired_flashlight_state ini_marine_6 1)
;	(unit_set_desired_flashlight_state ini_marine_7 1)

;	(sleep_until (not (volume_test_objects mission_start (players))))
	(vehicle_hover insertion_pelican 0)
	(recording_play_and_delete insertion_pelican insertion_pelican_out)
	(ai_conversation initial_orders)
	(sleep 90)
	(units_set_desired_flashlight_state (ai_actors marines_initial) 1)
)

(script static void cutscene_energy_lift
	(ai_allegiance human player)
	(ai_allegiance player human)
	
	(sound_looping_start sound\sinomatixx\a50_lift_foley none 1)
	(sound_looping_start sound\sinomatixx\a50_lift_music none 1)
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(ai_erase_all)
	(sleep 15)
	(volume_teleport_players_not_inside null area5_teleport_flag)

;	(ai_erase marines_area5/gravity_pad_fodder)
	(cinematic_start)
	(camera_control on)
;	Paul, you need to kill the encounter marines that enter the lift here. I create 6 cinematic ones.
	
	(object_create_anew chief_lift)
	(object_create_anew rifle)
	(object_create_anew_containing lift_marine)
;	(object_create_anew lift_marine_2)
;	(object_create_anew lift_marine_3)
;	(object_create_anew lift_marine_4)
;	(object_create_anew lift_marine_5)
;	(object_create_anew lift_marine_6)
	
	(object_teleport chief_lift chief_lift_base)
	(objects_attach chief_lift "right hand" rifle "")
	(object_beautify chief_lift true)
	(recording_play chief_lift chief_lift_watch)
	
	(object_teleport (player0) player0_lift_safe)
	(object_teleport (player1) player1_lift_safe)
	
	(object_teleport lift_marine_1 lift_marine_1_base)
	(object_teleport lift_marine_2 lift_marine_2_base)
	(object_teleport lift_marine_3 lift_marine_3_base)
	(object_teleport lift_marine_4 lift_marine_4_base)
	(object_teleport lift_marine_5 lift_marine_5_base)
	(object_teleport lift_marine_6 lift_marine_6_base)
	
	(unit_set_seat lift_marine_1 alert)
	(unit_set_seat lift_marine_2 alert)
	(unit_set_seat lift_marine_3 alert)
	(unit_set_seat lift_marine_4 alert)
	(unit_set_seat lift_marine_5 alert)
	(unit_set_seat lift_marine_6 alert)
	
	(sleep 30)
	
	(camera_set lift_marine_1_1 0)
	(camera_set lift_marine_1_2 60)
	
	(cinematic_set_title gravity_lift)
	
	(fade_in 1 1 1 15)
	
	(sleep 15)
	
	(custom_animation lift_marine_1 cinematics\animations\marines\level_specific\a50\a50 a50energylift true)
	
	(sleep 30)
	
	(custom_animation lift_marine_3 cinematics\animations\marines\level_specific\a50\a50 a50energylift true)
	(custom_animation lift_marine_6 cinematics\animations\marines\level_specific\a50\a50 a50energylift true)
	
	(camera_set lift_marine_1_3 60)
	(sleep 60)

	(custom_animation lift_marine_2 cinematics\animations\marines\level_specific\a50\a50 a50energylift true)
	
	(camera_set chief_lift_1a 0)
	(camera_set chief_lift_1b 110)

	(sleep 30)
	(custom_animation lift_marine_4 cinematics\animations\marines\level_specific\a50\a50 a50energylift true)
	(sleep 20)
	(custom_animation lift_marine_5 cinematics\animations\marines\level_specific\a50\a50 a50energylift true)

	(sleep_until (camera_time))
	
	(camera_set chief_lift_1c 0)
	(camera_set chief_lift_1d 60)
	
	(sleep 60)
	
	(object_destroy_containing lift_marine)
;	(object_destroy lift_marine_2)
;	(object_destroy lift_marine_3)
;	(object_destroy lift_marine_4)
;	(object_destroy lift_marine_5)
;	(object_destroy lift_marine_6)
	
	(recording_kill chief_lift)
	(custom_animation chief_lift cinematics\animations\chief\level_specific\a50\a50 a50energylift true)
	
	(camera_set_relative chief_lift_2a 0 chief_lift)
	(sleep 60)
	(camera_set_relative chief_lift_2b 60 chief_lift)
	(sleep 30)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_convolution 3 2 .001 10 1)
	(cinematic_screen_effect_set_filter_desaturation_tint .8 0 1)
	(cinematic_screen_effect_set_filter 0 1 0 1 true 1)
	
	(camera_set_relative chief_lift_2c 30 chief_lift)
	
	(sleep 15)
	
	(fade_out .8 0 1 15)
	
	(sleep 15)

	(camera_control off)

	(unit_stop_custom_animation chief_lift)
	(object_destroy chief_lift)
	(object_destroy rifle)

	(sleep (* 30 1))

; Joe, I took control of this to make the cinematic skipable
;	(switch_bsp 1)
;	(volume_teleport_players_not_inside gravity_trigger gravity_teleport_flag)
;	(ai_detach (player0))
)
