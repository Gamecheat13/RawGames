--\\ ===========================================================================================================================
-- ============================================ fo02_glacier SCRIPTS ===================================================
-- =============================================================================================================================
--## SERVER

--## CLIENT

function startupClient.GlacierMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_fg_glacier.sound'), nil, 1)
	streamer_pin_tag(TAG('\levels\multi\fo02_glacier\fo02_glacier_terrain\terrain\texturechunks\terrainmacro_norm_control\chunk_x000_y005_terrainmacro_norm_control.bitmap'));
	streamer_pin_tag(TAG('\levels\multi\fo02_glacier\fo02_glacier_terrain\terrain\texturechunks\terrainmacro_norm_control\chunk_x000_y004_terrainmacro_norm_control.bitmap'));
	streamer_pin_tag(TAG('\levels\multi\fo02_glacier\fo02_glacier_terrain\terrain\texturechunks\terrainmacro_norm_control\chunk_x005_y003_terrainmacro_norm_control.bitmap'));
	streamer_pin_tag(TAG('\levels\multi\fo02_glacier\fo02_glacier_terrain\terrain\texturechunks\terrainmacro_norm_control\chunk_x004_y002_terrainmacro_norm_control.bitmap'));
	streamer_pin_tag(TAG('\levels\multi\fo02_glacier\fo02_glacier_terrain\terrain\texturechunks\terrainmacro_norm_control\chunk_x004_y003_terrainmacro_norm_control.bitmap'));
	streamer_pin_tag(TAG('\levels\multi\fo02_glacier\fo02_glacier_terrain\terrain\texturechunks\terrainmacro_norm_control\chunk_x004_y001_terrainmacro_norm_control.bitmap'));
	streamer_pin_tag(TAG('\levels\multi\fo02_glacier\fo02_glacier_terrain\terrain\texturechunks\terrainmacro_norm_control\chunk_x005_y001_terrainmacro_norm_control.bitmap'));
end