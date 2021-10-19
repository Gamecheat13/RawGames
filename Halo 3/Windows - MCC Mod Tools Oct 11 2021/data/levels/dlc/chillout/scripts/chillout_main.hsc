(script startup chillout_main
	; Set up the cameras
	(vehicle_auto_turret camera0 tv_camera0 0.0 0.0 0.0)
)
(script continuous chillout_all
	(add_recycling_volume garbage 30 30)
	(sleep 900)
)
