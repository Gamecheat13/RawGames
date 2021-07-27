; NOTE bug 3624 FIX

(global boolean trench_scene_allow_continue true)
(script static void trench_attack_pelican
;	(object_destroy v_trench_pelican)
	(object_create v_trench_pelican)
	(object_teleport v_trench_pelican v_trench_pelican_flag)
	(recording_play v_trench_pelican v_rec_trench_pelican_crash)

	; Explosions
	(if trench_scene_allow_continue 
	(begin
	(sleep 295)
	(effect_new "effects\explosions\large explosion no objects" pelican_bang_1)
	(sleep 30)
	(if trench_scene_allow_continue (sound_impulse_start "sound\dialog\d40\D40_411_Pilot" none 1)) (sleep 15)
	(if trench_scene_allow_continue (sound_impulse_stop sound\dialog\d40\D40_400_Cortana))
	(sleep 81)
	(effect_new "effects\explosions\large explosion no objects" pelican_bang_2)
	(sleep 139)
	(effect_new "effects\explosions\large explosion no objects" pelican_bang_3)
	(sleep 20)
	(if trench_scene_allow_continue (sound_impulse_stop sound\dialog\d40\D40_420_Pilot))

	(sleep (max 0 (- (recording_time v_trench_pelican) 15)))
	
	(sound_impulse_start sound\sfx\ambience\d40\burn_pel_out v_trench_pelican 1)
	(sleep 15)
	(object_destroy v_trench_pelican)
	)
	)
)

(script static void trench_attack_banshee_1
;	(object_destroy v_trench_banshee_1)
	(object_create v_trench_banshee_1)
	(object_teleport v_trench_banshee_1 v_trench_banshee_1_flag)

	(recording_play v_trench_banshee_1 v_rec_trench_banshee_1_in)
	(sleep (max 0 (- (recording_time v_trench_banshee_1) 450)))
	
	; Create the pilot, braindeadificate him, stuff him in the trunk
	(ai_place trench_banshee_pilots/pilot1)
	(vehicle_load_magic v_trench_banshee_1 "B-driver" (list_get (ai_actors trench_banshee_pilots/pilot1) 0))
	(ai_vehicle_encounter v_trench_banshee_1 trench_banshees/banshees)
)

(script static void trench_attack_banshee_2
;	(object_destroy v_trench_banshee_2)
	(object_create v_trench_banshee_2)
	(object_teleport v_trench_banshee_2 v_trench_banshee_2_flag)

	(recording_play v_trench_banshee_2 v_rec_trench_banshee_2_in)
	(sleep (max 0 (- (recording_time v_trench_banshee_2) 450)))

	; Create the pilot, braindeadificate him, stuff him in the trunk
	(ai_place trench_banshee_pilots/pilot2)
	(vehicle_load_magic v_trench_banshee_2 "B-driver" (list_get (ai_actors trench_banshee_pilots/pilot2) 0))
	(ai_vehicle_encounter v_trench_banshee_2 trench_banshees/banshees)
)

(script dormant trench_banshee1_thread
	(trench_attack_banshee_1)
)

(script dormant trench_banshee2_thread
	(trench_attack_banshee_2)
)

(script dormant trench_pelican_thread
	(trench_attack_pelican)
)

(script static void trench_scene
	(ai_magically_see_players trench_banshee_pilots)
	(ai_magically_see_players trench_banshees)
	(wake trench_pelican_thread)
	(sleep 60)
	(wake trench_banshee1_thread)
	(wake trench_banshee2_thread)
	(sleep 70)
	(sound_impulse_start sound\dialog\d40\D40_400_Cortana "none" 1)
)

(script static void kill_trench_scene
;	(sleep -1 trench_attack_pelican)
	(set trench_scene_allow_continue false)
	(sound_impulse_stop sound\dialog\d40\D40_411_Pilot)
	(sound_impulse_stop sound\dialog\d40\D40_400_Cortana)
)
