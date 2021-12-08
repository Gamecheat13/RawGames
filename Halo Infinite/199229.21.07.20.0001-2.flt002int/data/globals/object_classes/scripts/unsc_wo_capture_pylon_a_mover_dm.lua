-- object unsc_wo_capture_pylon_a_dm

--## SERVER
hstructure unsc_wo_capture_pylon_a_dm
	meta : table
	instance : luserdata

	startingPosition:string;					--$$ METADATA {"prettyName": "Initial Position", "source": ["Sky", "Ground"],  "tooltip": "Choose if the Pylon falls from the sky or starts on the ground."}
	debugFall:boolean;							--$$ METADATA {"prettyName": "Debug Fall", "tooltip": "Check this to have the device machine auto activate on load."}
	impactRange:number;
end


function unsc_wo_capture_pylon_a_dm:init()
	self.impactRange = 0.9;

	RunClientScript("SetPylonVisibilityWakeManagerSleepLocking", self, true);

	if self.startingPosition == "Ground" then
		Device_SetPosition(self, 1);
	elseif self.startingPosition == "Sky" then
		if not editor_mode() then
			object_hide (self, true);
		end
		RunClientScript("EnablePylonVisibilityWakeManager", self, false);
		RunClientScript("SetImpactEffect", TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_catpure_pylon_a_mover_dm\unsc_wo_capture_pylon_a_impact.effect'));
	end

	--Debug for testing the drop sequence.
	if self.debugFall then
		RunClientScript("SetImpactEffect", TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_catpure_pylon_a_mover_dm\unsc_wo_capture_pylon_a_impact.effect'));
		self:CreateThread(self.DebugDrop, self);
	end
end

function unsc_wo_capture_pylon_a_dm:DebugDrop()
	repeat
		self:Drop();

		SleepSeconds(10);
		Device_SetPosition(self, 0);

	until self.debugFall == false;
end

function unsc_wo_capture_pylon_a_dm:Drop()
	--If the Pylon is already on the ground, exit out of drop sequence.
	if device_get_position(self) == 1 then
		return;
	end

	local dropPodVehicle = object_at_marker(self, "attach_mkr");
	local currentPosition:location = ToLocation(self);
	local startSpot:location = location(currentPosition.vector + vector(0,0, 1));
	local endSpot:location = location(currentPosition.vector - vector(0,0, 45));
	
	object_hide (self, false);
	local materialType:number = GetPhysicsMaterialTypeHit(startSpot, endSpot);

	Device_SetDesiredPosition(self, 1);
    RunClientScript("EntryDropPodClientEffect", self);

	SleepUntil([|device_get_position(self) > self.impactRange], 1);

	if (materialType ~= PhysicsMaterialType.None) then
		RunClientScript("ImpactDropPodClientEffect", self, self:GetMaterialImpactEffect(materialType));
	end

	RunClientScript("EnablePylonVisibilityWakeManager", self, true);
end

function unsc_wo_capture_pylon_a_dm:GetMaterialImpactEffect(materialType:number):tag
	if (materialType == PhysicsMaterialType.Dirt or
			materialType == PhysicsMaterialType.Mud or
			materialType == PhysicsMaterialType.Sand or
			materialType == PhysicsMaterialType.Vegetation) then
		return TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_capture_pylon_a\fx\capture_pylon_a_impact_soft.effect');
	elseif (materialType == PhysicsMaterialType.Metal or
			materialType == PhysicsMaterialType.Rock or
			materialType == PhysicsMaterialType.Concrete) then
		return TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_capture_pylon_a\fx\capture_pylon_a_impact_hard.effect');
	elseif (materialType == PhysicsMaterialType.ShallowWater or 
			materialType == PhysicsMaterialType.DeepWater) then
		return TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_capture_pylon_a\fx\capture_pylon_a_impact_water.effect');
	end

	return TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_capture_pylon_a\fx\capture_pylon_a_impact_generic.effect');
end

--## CLIENT

function remoteClient.ImpactDropPodClientEffect(self:object, impactEffect:tag)
	if (impactEffect ~= nil) then
		effect_new_on_object_marker(impactEffect, self, "fx_marker");
	end
end

function remoteClient.EntryDropPodClientEffect(self:object)
    local effect:tag = TAG('levels\assets\shiva\unsc\worldobjects\unsc_wo_capture_pylon_a\fx\capture_pylon_a_entry.effect');
    if (effect ~= nil) then
		effect_new_on_object_marker(effect, self, "fx_marker");
	end
end

function remoteClient.SetPylonVisibilityWakeManagerSleepLocking(pylon:object, enable:boolean)
	Object_SetVisibilityWakeManagerSleepLocking(pylon, enable);
end

function remoteClient.EnablePylonVisibilityWakeManager(pylon:object, enable:boolean)
	Object_SetVisibilityWakeManagerEnabled(pylon, enable);
end
