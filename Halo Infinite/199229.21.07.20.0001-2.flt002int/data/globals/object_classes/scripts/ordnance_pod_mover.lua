-- object ordnance_pod_mover
-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

function ordnance_pod_mover:init():void
end

function ordnance_pod_mover:AttachObject(weapon:object):void
	local pod:object = self:PodObject();
	local weaponAttachMarker:string = "fx_weapon";
	objects_attach(pod, weaponAttachMarker, weapon, "");
end

function ordnance_pod_mover:Drop(weaponTag:tag, landingEffect:number):boolean
	-- Ensure the device is at the top of the animation
	if device_get_position(self) ~= 0 then
		device_set_position_immediate(self, 0);
	end	
	local pod:object = self:PodObject();
	object_set_scale(pod, 0.01, 0);
	object_hide(self, false);
	object_set_scale(pod, 1, 5);
	local sleepTimeout:number = n_fps() * 10;
	local attachedWeapon:object = self:WeaponInPod(pod);
	if not SleepUntilReturn([| object_index_valid(attachedWeapon)], 1, sleepTimeout) then
		-- Spawn the weapon and attach to drop pod
		local weapon:object = Object_CreateFromTag(weaponTag);
		if not SleepUntilReturn([| object_index_valid(weapon)], 1, sleepTimeout) then
			print("not valid");
			return false;
		end

		local weaponAttachMarker:string = "fx_weapon";
		objects_attach(pod, weaponAttachMarker, weapon, "");
	end
	-- Drop the pod and wait for it to land
	device_set_position(self, 1);
	if not SleepUntilReturn([| device_get_position(self) == 1], 2, sleepTimeout) then
		return false;
	end
	-- Create the landing effect
	landingEffect = landingEffect or 1;
	self:EffectNewOrdnanceDropPod(landingEffect);
	self:Open(.05);
	return true;
end

function ordnance_pod_mover:Open(dropPodDoorPause:number):void
	dropPodDoorPause = dropPodDoorPause or 0.2;
	sleep_s(dropPodDoorPause);
	local pod:object = self:PodObject();
	local weapon:object = self:WeaponInPod(pod);

	object_damage_damage_section(pod, "default", 36);
end

function ordnance_pod_mover:SelfDestruct(dropPodSelfDestructPause:number):void
	dropPodSelfDestructPause = dropPodSelfDestructPause or 5;
	sleep_s(dropPodSelfDestructPause);

	local pod:object = self:PodObject();
	local weapon:object = self:WeaponInPod(pod);
	if object_index_valid(weapon) then
		objects_detach(pod, weapon);
	end
	RunClientScript("DestroyOrdnanceDropPodClientEffect", self);
	local justLongEnoughForTheEffectToStart:number = 0.2;
	sleep_s(justLongEnoughForTheEffectToStart);
	object_destroy(self);
end

function ordnance_pod_mover:PodObject():object
	local podAttachMarker = "attach_mkr";
	local pod:object = object_at_marker(self, podAttachMarker);
	return pod;
end

function ordnance_pod_mover:WeaponInPod(pod:object):object
	local weaponAttachMarker:string = "fx_weapon";
	local weapon:object = object_at_marker(pod, weaponAttachMarker);
	return weapon;
end

function ordnance_pod_mover:EffectNewOrdnanceDropPod(effect:number)
	RunClientScript("EffectNewOrdnanceDropPodClient", self, effect);
end

--## CLIENT
global OrdnanceDropPodLandingEffectMap =
{
	[0] = TAG('objects\vehicles\covenant\cov_drop_pod_single\fx\dp_small_impact.effect'),						-- OrdnanceDropPodLandingImpactEffect.Normal
	[1] = TAG('objects\vehicles\covenant\cov_drop_pod_single\fx\dp_small_water_impact.effect'),					-- OrdnanceDropPodLandingImpactEffect.Water
	[2] = TAG('fx\library\sandbox\material_effects\weapons\impact_explosion_large\soft_terrain_snow.effect'),	-- OrdnanceDropPodLandingImpactEffect.Snow
};

table.makeTableReadOnly(OrdnanceDropPodLandingEffectMap);

function remoteClient.EffectNewOrdnanceDropPodClient(self:object, effect:number)
	local podAttachMarker:string = "attach_mkr";
	local effectTag:tag = OrdnanceDropPodLandingEffectMap[effect];

	if effectTag ~= nil then
		effect_new_on_object_marker(effectTag, self, podAttachMarker);
	end
end

function remoteClient.DestroyOrdnanceDropPodClientEffect(self:object)
	effect_new(TAG('fx\library\sandbox\explosions\covenant_explosion_large\covenant_explosion_large.effect'), self);
end
