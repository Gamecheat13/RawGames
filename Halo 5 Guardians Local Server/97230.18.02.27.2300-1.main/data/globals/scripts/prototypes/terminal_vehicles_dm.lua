-- object terminal_vehicles_dm

--## SERVER


function terminal_vehicles_dm:activate_station(station:object)

	print ("activating terminal");
	device_set_position(self, 1);
	sleep_s (1);
	object_set_function_variable(self, "station_active", 1, 1.5);

end

function terminal_vehicles_dm:deactivate_station(station:object)

	print ("deactivating terminal");
	device_set_position(self, 0);
	object_set_function_variable(self, "station_active", 0, 1.5);

end