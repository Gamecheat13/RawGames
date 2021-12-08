-- DEBUG
-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

global screenshotsFolder:string = "Screenshots\\";
global screenshotsDebugFolder:string = screenshotsFolder .. "Debug\\";
global maxRetryCount:number = 10;

function DebugScreenshotsAll(screenshotSeed:string):void
	local cachedTerminalRender:boolean = terminal_render;
	terminal_render = false;

	local time:string= os.date("%m.%d.%H.%M");
	local seedWithTime = screenshotSeed .. "-" .. time;

	TakeRenderModeScreenshots(seedWithTime);
	TakeLightingVariantScreenshots(seedWithTime);
	terminal_render = cachedTerminalRender;
	print("All screenshots taken.");
end

function TakeRenderModeScreenshots(screenshotSeed:string):void
	local modeMap:table =
	{
		{ name = "lambert", 	id = 1, },
		{ name = "albedo", 	id = 3, },
		{ name = "albedotest", 	id = 4, },
		{ name = "normal", 	id = 7, },
		{ name = "roughness", 	id = 9, },
		{ name = "cavity", 	id = 11, },
		{ name = "metallic", 	id = 10, },
		{ name = "ior", 	id = 12, },
	};

	print("Taking screenshots in various render modes");
	for _, mode in hpairs(modeMap) do
		print("Taking screenshot for render mode: ", mode.name);
		local fullName:string = screenshotSeed .. "_" .. mode.name;
		ToggleLightMapTexaccumAndVerify(mode.name, mode.id);
		TakeScreenshot(screenshotsDebugFolder .. fullName);
	end

	-- reset to default
	render_debug_toggle_default_lightmaps_texaccum = 0;
end

function TakeLightingVariantScreenshots(screenshotSeed:string):void
	print("Taking screenshots in different lighting variants");
	local originalLightingVariant:string = get_string_from_string_id(getLightingVariant());
	local loadedMap:string = mantini_get_loaded_map_name();

	local availableVariants:table = GetSupportedLightingVariantsForMap(loadedMap);
	if (availableVariants == nil) then
		print("Map '" , loadedMap, "' was not found in global_asset_screenshot_debug.lua, taking screenshot with only the current lighting variant.")
		local fullName:string = screenshotSeed .. "_lit-" .. originalLightingVariant;
		TakeScreenshot(screenshotsFolder .. fullName);
		TakeScreenshot(screenshotsDebugFolder .. fullName);
	else
		for _, value in hpairs(availableVariants) do
			local variantName:string = value;
			print("Taking screenshot for lighting variant: ", variantName);
			SetLightingVariantAndVerify(originalLightingVariant, variantName);
			local fullName:string = screenshotSeed .. "_lit-" .. variantName;
			TakeScreenshot(screenshotsFolder .. fullName);
			TakeScreenshot(screenshotsDebugFolder .. fullName);
		end

		-- reset
		setLightingVariant (originalLightingVariant);
	end
end

function ToggleLightMapTexaccumAndVerify(modeName:string, modeId:number):void
	local index:number = 0;
	local currentValue:number = -1;
	while currentValue ~= modeId do
		assert(index <= maxRetryCount, "Unable to set render mode to '" .. modeName .. "' after " .. maxRetryCount .. " attempts");
		print("Setting render mode to '", modeName, "'. Attempt: ", index);
		index = index + 1;
		render_debug_toggle_default_lightmaps_texaccum = modeId;
		-- wait for rendering mode to turn on.
		sleep_s(0.5);
		currentValue = render_debug_toggle_default_lightmaps_texaccum;
	end
end

function SetLightingVariantAndVerify(original:string, variantName:string):void
	local index:number = 0;
	local currentLighting:string = original;
	while currentLighting ~= variantName do
		assert(index <= maxRetryCount, "Unable to set lighting variant to '" .. variantName .. "' after " .. maxRetryCount .. " attempts");
		print("Setting lighting variant to '", variantName, "'. Attempt: ", index);
		index = index + 1;
		setLightingVariant(variantName);
		--give time for the reload to happen.
		sleep_s(5);
		currentLighting = get_string_from_string_id(getLightingVariant());
	end
end

function TakeScreenshot(screenshotFullName:string)
	screenshot_simple(screenshotFullName);

	-- wait for screenshot to finish writing to disk.
	sleep_s(3);
end

function GetSupportedLightingVariantsForMap(mapName: string):table
	local lightingVariants:table = 
	{
		["levels\\test\\asset_viewer_test\\asset_viewer_test"] = {"default", "cloudy", "nightfall"},
	};

	return lightingVariants[mapName];
end