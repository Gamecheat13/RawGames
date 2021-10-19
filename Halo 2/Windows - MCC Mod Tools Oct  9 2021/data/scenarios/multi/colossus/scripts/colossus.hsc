;Colossus
;-------------------------------------------------------------------------------

;Temp variables for controlling conveyors
(global short launch_time 400)


(script continuous recycling_can_spawner_R
;sleep to stagger Right and Left lines
	(sleep 200)
	
	(if (= (list_count hanger_can_01) 0)
		(begin
			(object_create hanger_can_01)
			(sleep launch_time)
		)
	)
	(if (= (list_count hanger_can_02) 0)
		(begin
			(object_create hanger_can_02)
			(sleep launch_time)
		)
	)
		(if (= (list_count hanger_can_03) 0)
		(begin
			(object_create hanger_can_03)
			(sleep launch_time)
		)
	)
	(if (= (list_count hanger_can_04) 0)
		(begin
			(object_create hanger_can_04)
			(sleep launch_time)
		)
	)
		(if (= (list_count hanger_can_05) 0)
		(begin
			(object_create hanger_can_05)
			(sleep launch_time)
		)
	)
	(if (= (list_count hanger_can_06) 0)
		(begin
			(object_create hanger_can_06)
			(sleep launch_time)
		)
	)

)

(script continuous recycling_can_spawner_L

	(if (= (list_count hanger_can_07) 0)
		(begin
			(object_create hanger_can_07)
			(sleep launch_time)
		)
	)
	(if (= (list_count hanger_can_08) 0)
		(begin
			(object_create hanger_can_08)
			(sleep launch_time)
		)
	)
		(if (= (list_count hanger_can_09) 0)
		(begin
			(object_create hanger_can_09)
			(sleep launch_time)
		)
	)
	(if (= (list_count hanger_can_10) 0)
		(begin
			(object_create hanger_can_10)
			(sleep launch_time)
		)
	)
		(if (= (list_count hanger_can_11) 0)
		(begin
			(object_create hanger_can_11)
			(sleep launch_time)
		)
	)
	(if (= (list_count hanger_can_12) 0)
		(begin
			(object_create hanger_can_12)
			(sleep launch_time)
		)
	)

)

(script continuous hanger_can_killer
	(object_destroy (list_get (volume_return_objects can_kill_volume) 0))
)
