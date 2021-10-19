(script startup s3d_turf_main	
    (sleep 30)
    (mp_wake_script TrainMoveLoop)
	(mp_wake_script HornetAnimControl)
)

(global boolean canMoveTrain TRUE)
(global real minTrainDelay 450)
(global real maxTrainDelay 600)

(script dormant TrainMoveLoop        
    (sleep_until
        (begin                                                
            (scenery_animation_start turf_train \objects\levels\multi\s3d_turf\turf_train\turf_train turf_train)                                                        
            (sleep (random_range minTrainDelay maxTrainDelay))
            (= canMoveTrain FALSE)
        )
    )
)

(script dormant HornetAnimControl
	(sleep_until
		(begin
			(print "new start")
			(sleep (random_range 1200 1500))
			(HornetAnimSelect (random_range 1 2))
			(sleep (* 360 30))
		0)
	)
)

(script static void (HornetAnimSelect (short anim_num))
	
	(object_set_function_variable hornet_01 scripted_object_function_c 1 1)
	(object_set_function_variable hornet_01 scripted_object_function_a 1 1)
	(object_set_function_variable hornet_01 scripted_object_function_b 1 1)
	
	
	(if (= anim_num 1)
		(begin
			(scenery_animation_start hornet_01 objects\levels\multi\s3d_turf\turf_hornet\s3d_turf\s3d_turf "hornet1")
			(object_set_custom_animation_speed hornet_01 0.35)
			(sleep 190)
			(object_set_function_variable hornet_01 scripted_object_function_d 1 1)
			(sleep_until
				(= (scenery_get_animation_time hornet_01) 0)
			)
		)
	)
	(if (= anim_num 2)
		(begin
			(scenery_animation_start hornet_01 objects\levels\multi\s3d_turf\turf_hornet\s3d_turf\s3d_turf "hornet2")
			(object_set_custom_animation_speed hornet_01 0.35)
			(sleep 250)
			(object_set_function_variable hornet_01 scripted_object_function_d 1 1)
			(sleep_until
				(= (scenery_get_animation_time hornet_01) 0)
			)
		)
	)
	(object_set_function_variable hornet_01 scripted_object_function_c 0 1)
	(object_set_function_variable hornet_01 scripted_object_function_a 0 1)
	(object_set_function_variable hornet_01 scripted_object_function_b 0 1)
	(object_set_function_variable hornet_01 scripted_object_function_d 0 1)
)

;///////////////////////
;//// PODIUM SCRIPT ////
;///////////////////////



