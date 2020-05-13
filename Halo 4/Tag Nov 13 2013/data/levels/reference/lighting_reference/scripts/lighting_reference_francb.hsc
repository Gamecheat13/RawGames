(global boolean debug 0)

(script dormant weapon_blur
	(render_depth_of_field_enable 1)
	(sleep_until
		(begin
			(print "Reload in 5...")
			(sleep 30)
			(print "Reload in 4...")
			(sleep 30)
			(print "Reload in 3...")
			(sleep 30)
			(print "Reload in 2...")
			(sleep 30)
			(print "Reload in 1...")
			(sleep 30)
			(print "Reload!!")
			(render_depth_of_field 0 0.5 1 30)
			(sleep 30)
			
			(sleep 15)
			
			(render_depth_of_field 0 0.5 30 10)
			(sleep 30)
		0)
	)
)

(script dormant vehicle_blur
	(motion_blur 1)
	(sleep_until
		(begin
			(print "Boost in 5...")
			(sleep 30)
			(print "Boost in 4...")
			(sleep 30)
			(print "Boost in 3...")
			(sleep 30)
			(print "Boost in 2...")
			(sleep 30)
			(print "Boost in 1...")
			(sleep 30)
			(print "Boost!!")
			(set motion_blur_scale_x (* 0.045 15))
			(set motion_blur_scale_y (* 0.08 15))
			(set motion_blur_max_x (* 0.0135 2))
			(set motion_blur_max_y (* 0.024 2))
			;(set camera_fov_scale 1.4)
			
			(sleep 60)
			
			(sleep 15)
			
			(set motion_blur_scale_x 0.045)
			(set motion_blur_scale_y 0.08)
			(set motion_blur_max_x 0.0135)
			(set motion_blur_max_y 0.024)
			(set camera_fov_scale 1)
			
			(sleep 30)
		0)
	)
)

(script command_script cs_shoot_object
	(sleep 15)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	;(cs_shoot true test_object)
	(cs_shoot true (player0))
	(sleep_forever)
)

(script dormant place_ennemies
	(ai_place squads_1)
)

(script dormant guilty_weld
	(ai_place guilty_spark)
	(sleep 1)
	(unit_add_equipment (unit guilty_spark) prof_monitor_beam TRUE TRUE)
)

(script dormant emit_sentinels
	(sleep_until
		(begin
			(ai_place sentinels)
			(sleep 60)
			(unit_close emitter)
			(sleep 90)
			(ai_erase sentinels)
		0)
	)
)

(script startup manage_lightbridge
	(sleep_until
		(begin			
			(sleep_until (<= (device_get_position lightbridge_switch) 0.8) 5)
			(object_create 020_lightbridge)
			(device_set_position 020_lightbridge 1)
			(object_create 110_lightbridge)
			(device_set_position 110_lightbridge 1)
			(object_create 150_lightbridge)
			(device_set_position 150_lightbridge 1)
			
			(interpolator_start test_interpolator 1 1)
			
			(sleep_until (> (device_get_position lightbridge_switch) 0.8) 5)
			(object_destroy 020_lightbridge)
			(device_set_position 020_lightbridge 0)
			(object_destroy 110_lightbridge)
			(device_set_position 110_lightbridge 0)
			(object_destroy 150_lightbridge)
			(device_set_position 150_lightbridge 0)
			
			(interpolator_stop test_interpolator)
		0)
	5)
)