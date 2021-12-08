-- Copyright (C) Microsoft. All rights reserved.

REQUIRES('globals/scripts/global_multiplayer_init.lua')

--## SERVER

--[[
global vehiclePadParcels = {};



function startup.vehicle_pads():void

	RegisterGlobalEvent(g_eventTypes.roundStartEvent, VPOnRoundStart);
	RegisterGlobalEvent(g_eventTypes.roundEndEvent, VPOnRoundEnd);

end

function VPOnRoundStart():void
	vehiclePadParcels.warthog1 = VehiclePad:New("warthog_pad1", OBJECT_NAMES.vehicle_dispenser_warthog1, "warthog", TAG('objects\vehicles\human\warthog\warthog.vehicle'), TAG('objects\vehicles\human\warthog\configurations\default_warthog.vehicleconfiguration'));
	vehiclePadParcels.ghost1 = VehiclePad:New("ghost_pad_1", OBJECT_NAMES.vehicle_dispenser_ghost_1, "ghost", TAG('objects\vehicles\covenant\ghost\ghost.vehicle'), TAG('objects\vehicles\covenant\ghost\configurations\banished_ghost.vehicleconfiguration'));
	vehiclePadParcels.ghost2 = VehiclePad:New("ghost_pad_2", OBJECT_NAMES.vehicle_dispenser_ghost_2, "ghost", TAG('objects\vehicles\covenant\ghost\ghost.vehicle'), TAG('objects\vehicles\covenant\ghost\configurations\banished_ghost.vehicleconfiguration'));
	
	for type, vehicleParcel in hpairs(vehiclePadParcels) do
		ParcelAddAndStart(vehicleParcel, tostring(type));
	end

end

function VPOnRoundEnd():void
	for _, vehicleParcel in hpairs(vehiclePadParcels) do
		ParcelEnd(vehicleParcel);
	end
end
]]--

function GetIntelMapArgs():IntelMapArgs
	local intelMapArgs = hmake IntelMapArgs
		{
			cameraLookX = 0,
			cameraLookY = -7,
			cameraYaw = 270,
			cameraDistance = 95,
			settingsTag = TAG('levels/multi/va_launchsite/intel_map/va_launchsite.InGameMapSettings'),
			displayAssets = {
				--TAG('levels/multi/va_launchsite/intel_map/biome/biome.crate'),
				TAG('levels/multi/va_launchsite/intel_map/biome/biome_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/comms_tower/comms_tower.crate'),
				TAG('levels/multi/va_launchsite/intel_map/comms_tower/comms_tower_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/infrastructure/infrastructure.crate'),
				TAG('levels/multi/va_launchsite/intel_map/infrastructure/infrastructure_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_pad/launch_pad.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_pad/launch_pad_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower/launch_tower.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower/launch_tower_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower_climate_control/launch_tower_climate_control.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower_climate_control/launch_tower_climate_control_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower_entrance/launch_tower_entrance.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower_entrance/launch_tower_entrance_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower_muster_room/launch_tower_muster_room.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower_muster_room/launch_tower_muster_room_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower_service_bridge/launch_tower_service_bridge.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower_service_bridge/launch_tower_service_bridge_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower_service_lift/launch_tower_service_lift.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower_service_lift/launch_tower_service_lift_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower_spawn_room/launch_tower_spawn_room.crate'),
				TAG('levels/multi/va_launchsite/intel_map/launch_tower_spawn_room/launch_tower_spawn_room_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/operations/operations.crate'),
				TAG('levels/multi/va_launchsite/intel_map/operations/operations_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/sabre_bunker/sabre_bunker.crate'),
				TAG('levels/multi/va_launchsite/intel_map/sabre_bunker/sabre_bunker_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/sabre_bunker/sabre_rail.crate'),
				TAG('levels/multi/va_launchsite/intel_map/sabre_bunker/sabre_rail_geo32.crate'),
				TAG('levels/multi/va_launchsite/intel_map/terrain/terrain.crate'),
			},
		};
		
	return intelMapArgs
end

--## CLIENT


function startupClient.SetIntelMapData():void
	-- Postprocess settings
	InGameMapPostAOFalloff = 0.0001
	InGameMapPostMaxDepth = 1000
	InGameMapPostLineDetectIntensity = 20
	IntelMapExposureStops = -5


	InGameMapsLegacyPipeline = true;

	if (InGameMapsLegacyPipeline) then
		InGameMapPostColorMultiplier = 10
	end
end

function startupClient.LaunchSiteMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_global\031_st_global_levelloaded\031_st_global_levelloaded_mp_launchsite.sound'), nil, 1)
end