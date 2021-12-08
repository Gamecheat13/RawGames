-- object fo_audio

--## SERVER 
hstructure fo_audio
    meta : table;
    instance: luserdata;
     
    script_property_friendly_sound_tag_category : string --$$ METADATA { "prettyName": "Friendly Sound Category", "tooltip": "Friendly Sound Category tooltip" }
    script_property_friendly_sound_tag_name : string --$$ METADATA { "prettyName": "Friendly Sound Name", "tooltip": "Friendly Sound Name tooltip" }
    script_property_enemy_sound_tag_category : string --$$ METADATA { "prettyName": "Enemy Sound Category", "tooltip": "Enemy Sound Category tooltip" }
    script_property_enemy_sound_tag_name : string --$$ METADATA { "prettyName": "Enemy Sound Name", "tooltip": "Enemy Sound Name tooltip" }
end

function fo_audio:init()
	local friendlySoundTagCategoryValue = Object_GetScriptPropertyStringIdValue(self, "script_property_friendly_sound_tag_category") or "forge_looping_sound_category_alarms";
	local friendlySoundTagNameValue = Object_GetScriptPropertyStringIdValue(self, "script_property_friendly_sound_tag_name") or "fo_ls_alarm_factory";
	local enemySoundTagCategoryValue = Object_GetScriptPropertyStringIdValue(self, "script_property_enemy_sound_tag_category") or "forge_looping_sound_category_alarms";
	local enemySoundTagNameValue = Object_GetScriptPropertyStringIdValue(self, "script_property_enemy_sound_tag_name") or "fo_ls_alarm_factory";

	Object_SetEnemyLoopingSoundCategoryAndName(self, friendlySoundTagCategoryValue, friendlySoundTagNameValue);
	Object_SetFriendlyLoopingSoundCategoryAndName(self, enemySoundTagCategoryValue, enemySoundTagNameValue);
end
