;*
(script continuous dune_shroud_remove
	(if (> (list_count ramps) 0)
		(begin
			(object_destroy tele_switch)
; old			(device_set_position_immediate shroud_01 1)
; old			(device_set_position_immediate shroud_02 1)
			(object_destroy shroud_01)
			(object_destroy shroud_02)
		)
	)
	(sleep 30)
;	(if (= (list_count ramps) 0)
;		(sleep_forever)
;	)
;	(sleep 30)
;	(if (= (device_get_position shroud_02) 1)
;		(sleep_forever)
;	)
)
*;