-- object cov_drop_pod

--## SERVER

global dropPodDoorPause = 0.2;
global dropPodAiExit = 0.2;

function cov_drop_pod:init()
	object_hide (self, true);
end

function cov_drop_pod:start(elite:ai, effect:number)
	--print ("cov drop pod start");

	--ensure the device is at the top of the animation
	if device_get_position (self) ~= 0 then
		device_set_position (self, 0);
	end

	--the object needs a few ticks before the drop pod creates
	sleep_s (0.2);
	local obj:object = object_at_marker (self, "attach_mkr");

	object_set_scale (obj, 0.01, 0);
	unit_close (obj);
	object_hide (self, false);
	object_set_scale (obj, 1, 5);

	device_set_position (self, 1);
	--effect_new_on_object_marker_loop( TAG ('objects\vehicles\covenant\storm_drop_pod_small\fx\drop_pod_small_trail.effect'), obj, "fx_contrail");

	SleepUntil ([|device_get_position (self) == 1], 2);
	--print ("landed");

	--effect calls
	--effect_stop_object_marker( TAG ('objects\vehicles\covenant\storm_drop_pod_small\fx\drop_pod_small_trail.effect'), obj, "fx_contrail");
	--effect_new_on_object_marker( TAG ('objects\vehicles\covenant\storm_drop_pod_small\fx\dp_small_impact.effect'), obj, "fx_impact");
	effect = effect or 1;
	print (effect);
	cov_drop_pod:EffectNewDropPod (self, effect);

	ai_place(elite);
	ai_vehicle_enter_immediate (elite, obj);

	sleep_s (dropPodDoorPause);
	unit_open (obj);
	sleep_s (dropPodAiExit);
	ai_vehicle_exit  (elite);
end

function cov_drop_pod:EffectNewDropPod(self:object, effect:number)
	--print (self);
	RunClientScript("EffectNewDropPodClient", self, effect);
end

--## CLIENT

function remoteClient.EffectNewDropPodClient(self:object, effect:number)
	print ("self is ", self, " effect is ", effect);
	if effect == 1 then
		effect_new_on_object_marker( TAG ('objects\vehicles\covenant\cov_drop_pod_single\fx\dp_small_impact.effect'), self, "attach_mkr");
	elseif effect == 2 then
		effect_new_on_object_marker( TAG ('objects\vehicles\covenant\cov_drop_pod_single\fx\dp_small_water_impact.effect'), self, "attach_mkr");
	elseif effect == 3 then
		effect_new_on_object_marker( TAG ('fx\library\sandbox\material_effects\weapons\impact_explosion_large\soft_terrain_snow.effect'), self, "attach_mkr");
	end
end