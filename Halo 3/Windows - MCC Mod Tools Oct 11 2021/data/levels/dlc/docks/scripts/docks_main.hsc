(script startup docks_main
	; Set up the cameras
	(vehicle_auto_turret camera0 tv_camera0 0.0 0.0 0.0)
	(vehicle_auto_turret camera1 tv_camera1 0.0 0.0 0.0)
	(vehicle_auto_turret camera2 tv_camera2 0.0 0.0 0.0)
	(vehicle_auto_turret camera3 tv_camera3 0.0 0.0 0.0)
	(vehicle_auto_turret camera4 tv_camera4 0.0 0.0 0.0)
	(vehicle_auto_turret camera5 tv_camera5 0.0 0.0 0.0)
	(vehicle_auto_turret camera6 tv_camera6 0.0 0.0 0.0)
	(vehicle_auto_turret camera7 tv_camera7 0.0 0.0 0.0)
)
(script continuous docks_all
	(add_recycling_volume garbage 30 30)
	(sleep 900)
)
