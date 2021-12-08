-- Copyright (C) Microsoft. All rights reserved.

REQUIRES('globals/scripts/global_multiplayer_init.lua')

--## SERVER

function GetIntelMapArgs():IntelMapArgs
	local intelMapArgs = hmake IntelMapArgs
		{
			cameraLookX = 15,
			cameraLookY = 0,
			cameraLookAdjust = 2,
			cameraYaw = 90,
			cameraDistance = 55,
			settingsTag = TAG('levels/multi/sgh_blueprint/intel_map/sgh_blueprint.InGameMapSettings'),
			displayAssets = {
				TAG('levels/multi/sgh_blueprint/intel_map/blueprint_bigmachine/blueprint_bigmachine.crate'),
				TAG('levels/multi/sgh_blueprint/intel_map/blueprint_bigmachine/_geo32/blueprint_bigmachine_geo32.crate'),
				TAG('levels/multi/sgh_blueprint/intel_map/blueprint_exchanger/blueprint_exchanger.crate'),
				TAG('levels/multi/sgh_blueprint/intel_map/blueprint_exchanger/_geo32/blueprint_exchanger_geo32.crate'),
				TAG('levels/multi/sgh_blueprint/intel_map/blueprint_overlook/blueprint_overlook.crate'),
				TAG('levels/multi/sgh_blueprint/intel_map/blueprint_overlook/_geo32/blueprint_overlook_geo32.crate'),
				TAG('levels/multi/sgh_blueprint/intel_map/blueprint_pipemother/blueprint_pipemother.crate'),
				TAG('levels/multi/sgh_blueprint/intel_map/blueprint_pipemother/_geo32/blueprint_pipemother_geo32.crate'),
				TAG('levels/multi/sgh_blueprint/intel_map/blueprint_storage/blueprint_storage.crate'),
				TAG('levels/multi/sgh_blueprint/intel_map/blueprint_storage/_geo32/blueprint_storage_geo32.crate'),
				TAG('levels/multi/sgh_blueprint/intel_map/blueprint_underhalls/blueprint_underhalls.crate'),
				TAG('levels/multi/sgh_blueprint/intel_map/blueprint_underhalls/_geo32/blueprint_underhalls_geo32.crate'),
			},
		};
		
	return intelMapArgs
end

--## CLIENT

function startupClient.SetIntelMapData():void
	-- Postprocess settings
	IntelMapExposureStops = -5;
	InGameMapPostAOArea = 0.002
	InGameMapPostAOFalloff = 0.0001
	InGameMapPostMaxDepth = 1000
	InGameMapPostLineDetectIntensity = 30
	
	InGameMapsLegacyPipeline = true;

	if (InGameMapsLegacyPipeline) then
		InGameMapPostColorMultiplier = 4;
	end
end

function startupClient.BluePrintMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_global\031_st_global_levelloaded\031_st_global_levelloaded_mp_blueprint.sound'), nil, 1)
end

