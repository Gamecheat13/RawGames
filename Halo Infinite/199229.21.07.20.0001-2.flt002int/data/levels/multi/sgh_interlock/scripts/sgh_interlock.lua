-- Copyright (C) Microsoft. All rights reserved.

REQUIRES('globals/scripts/global_multiplayer_init.lua')

--## SERVER

global skipTutorialCinematics = false;

function GetIntelMapArgs():IntelMapArgs
	local intelMapArgs = hmake IntelMapArgs
		{
			cameraLookX = 10,
			cameraLookY = 32,
			cameraLookAdjust = 0,
			cameraYaw = 270,
			cameraYawRotation = 30,
			cameraRestingPitch = 45,
			cameraDistance = 55,
			settingsTag = TAG('levels/multi/sgh_interlock/intel_map/sgh_interlock.InGameMapSettings'),
			displayAssets = {
				--TAG('levels/multi/sgh_interlock/intel_map/landmark/landmark.crate'),
				--TAG('levels/multi/sgh_interlock/intel_map/sgh_interlock_rightside_building/sgh_interlock_rightside_building.crate'),
				--TAG('levels/multi/sgh_interlock/intel_map/sgh_interlock_rightside_building/sgh_interlock_rightside_building_geo32.crate'),
				--TAG('levels/multi/sgh_interlock/intel_map/sniper_tower/sniper_tower.crate'),
				--TAG('levels/multi/sgh_interlock/intel_map/sniper_tower/sniper_tower_geo32.crate'),
				--TAG('levels/multi/sgh_interlock/intel_map/top_mid/top_mid.crate'),
				--TAG('levels/multi/sgh_interlock/intel_map/top_mid/top_mid_geo32.crate'),
				--TAG('levels/multi/sgh_interlock/intel_map/containers/containers.crate'),
				--TAG('levels/multi/sgh_interlock/intel_map/containers/containers_geo32.crate'),
				TAG('levels/assets/shiva/lookdev/vbrlysy/sgh_interlock_floors/sgh_interlock_floors.crate'),
				TAG('levels/assets/shiva/lookdev/vbrlysy/sgh_interlock_buildings/sgh_interlock_buildings.crate'),
			},
		};
		
	return intelMapArgs
end

--## CLIENT

function startupClient.SetIntelMapData():void
	-- Postprocess settings
	IntelMapExposureStops = -5;
	InGameMapPostMinDepth = 25

	InGameMapPostMaxDepth = 2000
	InGameMapPostAOArea = 0.0001
	InGameMapPostAOFalloff = 0.002
	InGameMapPostLineDetectIntensity = .25

	InGameMapsLegacyPipeline = true;

	if (InGameMapsLegacyPipeline) then
		InGameMapPostColorMultiplier = 4;
	end
end

function startupClient.InterlockMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_global\031_st_global_levelloaded\031_st_global_levelloaded_mp_interlock.sound'), nil, 1)
end

