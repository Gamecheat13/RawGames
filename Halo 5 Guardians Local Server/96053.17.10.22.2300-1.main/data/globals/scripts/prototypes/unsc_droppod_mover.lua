-- object unsc_droppod_mover

--## SERVER



function unsc_droppod_mover:init()
	object_hide (self, true);
end

function unsc_droppod_mover:start(ai:ai)
	--print ("cov drop pod start");
	local dropPodDoorPause = 0.2;
	local dropPodAiExit = 0.5;
	local obj:object = object_at_marker (self, "attach_mkr");
	
	--ensure the device is at the top of the animation
	if device_get_position (self) ~= 0 then
		device_set_position_immediate (self, 0);
	end
	
	--the object needs a few ticks before the drop pod creates
	sleep_s (0.2);
	object_set_scale (obj, 0.1, 10);
	sleep_s (0.2);
	--ai_place(ai);
	unit_close (obj);
	--ai_vehicle_enter_immediate (elite, obj);
	vehicle_load_magic (obj, "", ai);
	object_hide (self, false);
	object_set_scale (obj, 1, 3*60);
	
	device_set_position (self, 1);
	--effect_new_on_object_marker_loop( TAG ('objects\vehicles\covenant\storm_drop_pod_small\fx\drop_pod_small_trail.effect'), obj, "fx_contrail");
	
	SleepUntil ([|device_get_position (self) == 1], 2);
	--print ("landed");
	
	--effect_stop_object_marker( TAG ('objects\vehicles\covenant\storm_drop_pod_small\fx\drop_pod_small_trail.effect'), obj, "fx_contrail");
	--effect_new_on_object_marker( TAG ('objects\vehicles\covenant\storm_drop_pod_small\fx\dp_small_impact.effect'), obj, "fx_impact");
	sleep_s (dropPodDoorPause);
	unit_open (obj);
	sleep_s (dropPodAiExit);
	vehicle_unload (self, "");
end