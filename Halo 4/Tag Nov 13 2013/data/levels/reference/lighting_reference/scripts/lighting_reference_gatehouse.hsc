(script startup gatehouse

	(print "tim williams has the eyes of a soldier")

	(wake f_gatehouse_door_return)

)




(global boolean b_gatehouse_door_return_open FALSE)
(global boolean b_gatehouse_door_switch_prepare FALSE)
(global boolean b_gatehouse_door_switch_power FALSE)
(script dormant f_gatehouse_door_return

	(wake f_gatehouse_door_return_switch)
	(wake f_gatehouse_door_timer)


	(sleep_until (and b_gatehouse_door_timer_done (= (device_get_position dc_return_door_switch) 1) ) 1)
	(device_set_position dm_valley_door_large .99)
	(device_set_position dm_valley_door_small .99)
	(print "door open")


)

(script dormant f_gatehouse_door_return_switch

	(sleep_until (volume_test_players tv_valley_gatehouse_door) 1)
	(f_blip_object dc_return_door_switch blip_interface)
	(set b_gatehouse_door_timer TRUE)

	(sleep_until (>= (device_get_position dc_return_door_switch) 1) 1)
	(device_set_position dc_return_door_switch 0)
	(sleep 1)
	(device_set_power dc_return_door_switch 0)
	(f_unblip_object dc_return_door_switch)

)

(global boolean b_gatehouse_door_timer FALSE)
(global boolean b_gatehouse_door_timer_done FALSE)
(script dormant f_gatehouse_door_timer

	(sleep_until
		(begin
			(sleep_until b_gatehouse_door_timer 1)
			(set b_gatehouse_door_timer_done FALSE)
			(sleep (* 30 15))
			(set b_gatehouse_door_timer_done TRUE)
			(sleep 30)
			(set b_gatehouse_door_timer FALSE)
		FALSE)
	1)

)