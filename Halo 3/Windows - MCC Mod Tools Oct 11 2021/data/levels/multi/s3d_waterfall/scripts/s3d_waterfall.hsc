(script startup waterfall
	(mp_wake_script WaterfallSfx)
	(mp_wake_script HideLongswords)
	(mp_wake_script HidePelicans)
	(mp_wake_script StartLongsword)
	(mp_wake_script StartPelicans)
	(mp_wake_script StartPelicanCave)
	(mp_wake_script StartHornet)
)

(script dormant StartLongsword
	(sleep_until
		(begin
			(print "Longswordrandom")
			(LongswordAnimSelect (random_range 1 3))
			(sleep 500)
		0)
	)
)

(script dormant StartPelicans
	(sleep_until
		(begin
			(print "Pelicanrandom")
			(PelicanAnimSelect (random_range 1 2))
			(sleep 150)
		0)
	)
)

(script dormant HideLongswords
	(object_hide longsword_01 true)
	(object_hide longsword_02 true)
	(object_hide longsword_03 true)
	(object_hide longsword_04 true)
	(object_hide longsword_05 true)
	(object_set_scale longsword_01 1.8 1)
	(object_set_scale longsword_02 1.8 1)
	(object_set_scale longsword_03 1.8 1)
	(object_set_scale longsword_04 1.8 1)
	(object_set_scale longsword_05 1.8 1)
)

(script dormant HidePelicans
	(object_hide pelican_01 true)
	(object_hide pelican_cave true)
	(object_hide pelican_02 true)
	(object_hide hornet_01 true)
	(object_hide hornet_02 true)
	(object_hide hornet_03 true)
)

(script dormant WaterfallSfx
	(sleep_until
		(begin
			(print "waterfall on")
			
			(sleep_until
				(volume_test_players splash)
			0)
			
			(effect_new "\levels\multi\s3d_waterfall\fx\collision_wtf_splash_01.effect" splash_sfx_01)
			(effect_new "fx\material_effects\objects\vehicles\contact\collision\collision_water_enourmous.effect" splash_sfx_02)
			
		0)
	)
)




(script static void (LongswordAnimSelect (short long_num))
	(if (= long_num 1)
		(LongswordAnimSelect_1)
	)
	(if (= long_num 2)
		(LongswordAnimSelect_2)
	)
	(if (= long_num 3)
		(LongswordAnimSelect_3)
	)
	
)

(script static void (PelicanAnimSelect (short pel_num))
	(if (= pel_num 1)
		(PelicanAnim_1)
	)
	
)


(script static void LongswordAnimSelect_1
	(sleep_until
		(begin
		(print "anim_1")
		(object_hide longsword_01 false)
		(object_hide longsword_02 false)
		(object_hide longsword_03 false)
		(object_cinematic_visibility longsword_01 true)
		(object_cinematic_visibility longsword_02 true)
		(object_cinematic_visibility longsword_03 true)
(scenery_animation_start longsword_01 objects/levels/multi/s3d_waterfall/longsword_waterfall/longsword_waterfall "longsword_fly1")
(object_set_custom_animation_speed longsword_01 (real_random_range 0.25 0.35))
(scenery_animation_start longsword_02 objects/levels/multi/s3d_waterfall/longsword_waterfall/longsword_waterfall "longsword_fly1")
(object_set_custom_animation_speed longsword_02 (real_random_range 0.25 0.35))
(scenery_animation_start longsword_03 objects/levels/multi/s3d_waterfall/longsword_waterfall/longsword_waterfall "longsword_fly1")
(object_set_custom_animation_speed longsword_03 (real_random_range 0.25 0.35))
(sleep_until 
		(= (scenery_get_animation_time longsword_01) 0)
	)
(object_hide longsword_01 true)
(object_hide longsword_02 true)
(object_hide longsword_03 true)
	(sleep (random_range 700 800))
		0)
	)
)


(script static void LongswordAnimSelect_2
		(sleep_until
			(begin
				(print "anim_2")
				(object_hide longsword_04 false)
				(object_hide longsword_05 false)
				(object_cinematic_visibility longsword_04 true)
				(object_cinematic_visibility longsword_05 true)
		(scenery_animation_start longsword_04 objects/levels/multi/s3d_waterfall/longsword_waterfall/longsword_waterfall "longsword_fly1")
			(object_set_custom_animation_speed longsword_04 (real_random_range 0.25 0.35))
		(scenery_animation_start longsword_05 objects/levels/multi/s3d_waterfall/longsword_waterfall/longsword_waterfall "longsword_fly1")
			(object_set_custom_animation_speed longsword_05 (real_random_range 0.25 0.35))
			(sleep_until 
				(= (scenery_get_animation_time longsword_04) 0)
				)
			(object_hide longsword_04 true)
			(object_hide longsword_05 true)
			(sleep (random_range 700 800))
		0)
	)	
)

(script static void LongswordAnimSelect_3
		(sleep_until
			(begin
				(print "anim_2")
				(object_hide longsword_04 false)
				(object_hide longsword_05 false)
				(object_cinematic_visibility longsword_04 true)
				(object_cinematic_visibility longsword_05 true)
		(scenery_animation_start longsword_04 objects/levels/multi/s3d_waterfall/longsword_waterfall/longsword_waterfall "longsword_fly1")
			(object_set_custom_animation_speed longsword_04 (real_random_range 0.25 0.35))
		(scenery_animation_start longsword_05 objects/levels/multi/s3d_waterfall/longsword_waterfall/longsword_waterfall "longsword_fly1")
			(object_set_custom_animation_speed longsword_05 (real_random_range 0.25 0.35))
			(sleep_until 
				(= (scenery_get_animation_time longsword_04) 0)
				)
			(object_hide longsword_04 true)
			(object_hide longsword_05 true)
			(sleep (random_range 700 800))
		0)
	)	
)


(script static void PelicanAnim_1
	(sleep_until
	(begin
	(print "pelican_anime1")
	(sleep (random_range 500 900))
	(object_hide pelican_01 false)
	(object_set_function_variable pelican_01 scripted_object_function_a 1 1)
	(object_set_function_variable pelican_01 scripted_object_function_b 1 1)
	(object_set_function_variable pelican_01 scripted_object_function_d 1 1)
	(object_cinematic_visibility pelican_01 true)
	(scenery_animation_start pelican_01 objects/vehicles/pelican/s3d_waterfall/s3d_waterfall "pelican_landing")
	(print "end pelican")
	(object_set_custom_animation_speed pelican_01 0.2)
	(sleep_until 
		(= (scenery_get_animation_time pelican_01) 0)
	)
	(print "pelican back")
	(object_set_function_variable pelican_01 scripted_object_function_a 0 0)
	(object_set_function_variable pelican_01 scripted_object_function_b 0 0)
	(object_set_function_variable pelican_01 scripted_object_function_d 0 0)
	(sleep (random_range 1400 1900))
	(object_set_function_variable pelican_01 scripted_object_function_a 1 1)
	(object_set_function_variable pelican_01 scripted_object_function_b 1 1)
	(object_set_function_variable pelican_01 scripted_object_function_d 1 1)
	(sleep 100)
	(scenery_animation_start pelican_01 objects/vehicles/pelican/s3d_waterfall/s3d_waterfall "pelican_starting")
	(object_set_custom_animation_speed pelican_01 0.25 )
	(sleep_until 
		(= (scenery_get_animation_time pelican_01) 0)
	)
	(sleep (random_range 2000 2300))
		0)
	)
)






(script dormant StartPelicanCave
(sleep_until
			(begin
		(sleep (random_range 300 500))
		(print "pelican come cave")
		(object_hide pelican_cave false)
		(object_cinematic_visibility pelican_cave true)
		(scenery_animation_start pelican_cave objects/vehicles/pelican/s3d_waterfall/s3d_waterfall "pelican_cave_landing")
		(object_set_function_variable pelican_cave scripted_object_function_a 1 1)
	(object_set_function_variable pelican_cave scripted_object_function_b 1 1)
	(object_set_function_variable pelican_cave scripted_object_function_d 1 1)
		(object_set_custom_animation_speed pelican_cave 0.2)
	(sleep_until 
		(= (scenery_get_animation_time pelican_cave) 0)
	)
		(object_set_function_variable pelican_cave scripted_object_function_a 0 1)
		(object_set_function_variable pelican_cave scripted_object_function_b 0 1)
		(object_set_function_variable pelican_cave scripted_object_function_d 0 1)
		(sleep (random_range 400 900))
		(object_set_function_variable pelican_cave scripted_object_function_a 1 1)
		(object_set_function_variable pelican_cave scripted_object_function_b 1 1)
		(object_set_function_variable pelican_cave scripted_object_function_d 1 1)
		(sleep 100)
		(print "end cave")
(scenery_animation_start pelican_cave objects/vehicles/pelican/s3d_waterfall/s3d_waterfall "pelican_cave_starting")
		
		(object_set_custom_animation_speed pelican_cave 0.2)
		(sleep (random_range 2500 3000))
		0)
	)
)

(script dormant StartHornet
(sleep_until
		(begin
		(sleep (random_range 100 200))
		(object_hide hornet_01 false)
		(print "hornet start fly")
		(object_cinematic_visibility hornet_01 true)
		(object_cinematic_visibility hornet_02 true)
		(object_cinematic_visibility hornet_03 true)
		(object_set_function_variable hornet_01 one 1 1)
		(object_set_function_variable hornet_02 one 1 1)
		(object_set_function_variable hornet_03 one 1 1)
		(object_set_function_variable hornet_01 scripted_object_function_a 1 1)
		(object_set_function_variable hornet_01 scripted_object_function_c 1 1)
		(object_set_function_variable hornet_01 scripted_object_function_b 1 1)
		(scenery_animation_start hornet_01 objects/vehicles/hornet/s3d_waterfall/s3d_waterfall "hornet1_landing")
		(object_set_custom_animation_speed hornet_01 0.3)
(sleep_until
				(= (scenery_get_animation_time hornet_01) 0)
			)
		(object_set_function_variable hornet_01 scripted_object_function_a 0 0)
		(object_set_function_variable hornet_01 scripted_object_function_c 0 0)
		(object_set_function_variable hornet_01 scripted_object_function_b 0 0)
		(object_set_function_variable hornet_01 one 0 0)
		(sleep (random_range 100 200))
		(object_hide hornet_02 false)
		(object_set_function_variable hornet_02 scripted_object_function_a 1 1)
		(object_set_function_variable hornet_02 scripted_object_function_c 1 1)
		(object_set_function_variable hornet_02 scripted_object_function_b 1 1)
		(scenery_animation_start hornet_02 objects/vehicles/hornet/s3d_waterfall/s3d_waterfall "hornet2_landing")
		(object_set_custom_animation_speed hornet_02 0.3)
(sleep_until
				(= (scenery_get_animation_time hornet_02) 0)
			)
		(object_set_function_variable hornet_02 scripted_object_function_a 0 0)
		(object_set_function_variable hornet_02 scripted_object_function_c 0 0)
		(object_set_function_variable hornet_02 scripted_object_function_b 0 0)
		(object_set_function_variable hornet_02 one 0 0)
		(sleep (random_range 50 150))
		(object_hide hornet_03 false)
		(object_set_function_variable hornet_03 scripted_object_function_a 1 1)
		(object_set_function_variable hornet_03 scripted_object_function_c 1 1)
		(object_set_function_variable hornet_03 scripted_object_function_b 1 1)
		(scenery_animation_start hornet_03 objects/vehicles/hornet/s3d_waterfall/s3d_waterfall "hornet3_landing")
		(object_set_custom_animation_speed hornet_03 0.3)
(sleep_until
				(= (scenery_get_animation_time hornet_03) 0)
			)
		(object_set_function_variable hornet_03 scripted_object_function_a 0 0)
		(object_set_function_variable hornet_03 scripted_object_function_c 0 0)
		(object_set_function_variable hornet_03 scripted_object_function_b 0 0)
		(object_set_function_variable hornet_03 one 0 0)
		(sleep (random_range 500 900))
		(object_set_function_variable hornet_02 scripted_object_function_b 1 1)
		(object_set_function_variable hornet_02 scripted_object_function_c 1 1)
		(object_set_function_variable hornet_02 scripted_object_function_a 1 1)
		(object_set_function_variable hornet_02 one 1 1)
		(scenery_animation_start hornet_02 objects/vehicles/hornet/s3d_waterfall/s3d_waterfall "hornet2_starting")
		(object_set_custom_animation_speed hornet_02 0.3)
		(sleep (random_range 50 100))
		(object_set_function_variable hornet_01 scripted_object_function_b 1 1)
		(object_set_function_variable hornet_01 scripted_object_function_c 1 1)
		(object_set_function_variable hornet_01 scripted_object_function_a 1 1)
		(object_set_function_variable hornet_01 one 1 1)
		(scenery_animation_start hornet_01 objects/vehicles/hornet/s3d_waterfall/s3d_waterfall "hornet1_starting")
		(object_set_custom_animation_speed hornet_01 0.3)
		(sleep (random_range 50 150))
		(object_set_function_variable hornet_03 scripted_object_function_b 1 1)
		(object_set_function_variable hornet_03 scripted_object_function_c 1 1)
		(object_set_function_variable hornet_03 scripted_object_function_a 1 1)
		(object_set_function_variable hornet_03 one 1 1)
		(scenery_animation_start hornet_03 objects/vehicles/hornet/s3d_waterfall/s3d_waterfall "hornet3_starting")
		(object_set_custom_animation_speed hornet_03 0.3)
		(print "end hornet")
		(sleep (random_range 1200 1600))
		0)
	)
)

