-- Copyright (C) Microsoft. All rights reserved.

REQUIRES('globals/scripts/global_multiplayer_init.lua')

--## SERVER

function GetIntelMapArgs():IntelMapArgs
	local intelMapArgs = hmake IntelMapArgs
		{
			cameraLookX = 0,
			cameraLookY = -1,
			cameraYaw = 90,
			cameraDistance = 55,
			settingsTag = TAG('levels/multi/ctf_bazaar/intel_map/ctf_bazaar.InGameMapSettings'),
			displayAssets = {
				TAG('levels/multi/ctf_bazaar/intel_map/ceilings/ceilings.crate'),
				TAG('levels/multi/ctf_bazaar/intel_map/central_market_building/central_market_building.crate'),
				TAG('levels/multi/ctf_bazaar/intel_map/marketplace_floor/marketplace_floor.crate'),
				TAG('levels/multi/ctf_bazaar/intel_map/respawn_buildings/respawn_buildings.crate'),
				TAG('levels/multi/ctf_bazaar/intel_map/stalls/stalls.crate'),
				TAG('levels/multi/ctf_bazaar/intel_map/walls_marketplace/walls_marketplace.crate'),
			},
		};
		
	return intelMapArgs
end

--## CLIENT



function startupClient.SetIntelMapData():void
	IntelMapExposureStops = -1
	InGameMapPostLineDetectIntensity = 30
	InGameMapPostMaxDepth = 1000
	InGameMapPostAOFalloff = 0.0001

	InGameMapsLegacyPipeline = true;
end

function startupClient.BazaarMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_global\031_st_global_levelloaded\031_st_global_levelloaded_mp_bazaar.sound'), nil, 1)
end