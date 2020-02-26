
-------------------------------------
--		UI Animation Prototype
-------------------------------------

-- Animation play modes.
global SUI_PLAY_MODE = {Once = 0, Looping = 1, PingPong = 2 };

-- Channel curve type
global SUI_CURVE_TYPE = {Linear = 0, Smooth = 1, Constant = 3};

global g_activeAnimations = {}
global g_animationUpdateActive:boolean = false;

local function GetCurrentChannelValue(channel, time:number)				
	local result = 0;
	for keyIndex,key in ipairs (channel.keyframes) do
		if key.time > time then
			if keyIndex > 1 then
				local prevKey = channel.keyframes[keyIndex - 1];
					
				if channel.curveType == SUI_CURVE_TYPE.Constant then
					-- Keep using the previous key value.  Don't interpolate.
					result = prevKey.value;
					break;
				else
					-- Interpolate between the two keys.
					local percent = (time - prevKey.time) / (key.time - prevKey.time);
					
					-- Apply ease in/out function (3x^2 - 2x^3) for smoothing if requests.
					if (channel.curveType == SUI_CURVE_TYPE.Smooth) then
						percent = (3 * percent * percent) - (2 * percent * percent * percent);
					end
					
					-- Interpolate value.
					local delta = key.value - prevKey.value;
					result = (delta * percent) + prevKey.value;
									
					break;
				end
			else
				-- This is the first key.  Just use its value.
				result = key.value;
				break;
			end
		elseif key.time == time then
			result = key.value;
			break;
		elseif keyIndex == #channel.keyframes then
			-- Extrapolate last keyframe.
			result = key.value;
			break;
		end
	end
		
	return result;
end


local function ApplyChannelValue(elementID, channelType, channelValue):void
	if (channelValue ~= nil) then
		ScriptUI_SetAnimatedParameter(elementID, channelType, channelValue);
	end
end


local function ApplyChannelsToElement(elementID:number, channels, time:number):number
	local channelsApplied = 0;
	for channelType, channel in pairs (channels) do
		local channelValue = GetCurrentChannelValue(channel, time);
		ApplyChannelValue(elementID, channelType, channelValue);
		channelsApplied = channelsApplied + 1;
	end
	
	return channelsApplied;
end


local function UpdateAnimations():void
	g_animationUpdateActive = true;

	local k_maxChannelUpdateCount = 80;
	local k_minElapsedTime = 1/60;

	repeat
		local channelUpdateCount = 0; -- Only update a few channels per tick to limit cost.
		for elementID, activeAnim in pairs (g_activeAnimations) do
			if ScriptUI_IsValid(elementID) then
				local elapsedTime = (game_tick_get() - activeAnim.lastUpdateTick) / game_seconds_to_ticks(1);	
				if elapsedTime > k_minElapsedTime then 		-- Don't bother updating animations faster than framerate.			
					activeAnim.time = activeAnim.time + elapsedTime;
					local time = activeAnim.time;
					if activeAnim.playReverse then
						time = activeAnim.animation.length - activeAnim.time;
					end
					
					-- Don't overrun length.
					time = math.min(time, activeAnim.animation.length);
					
					local channelsApplied = ApplyChannelsToElement(elementID, activeAnim.animation.channels, time);
					channelUpdateCount = channelUpdateCount + channelsApplied;
					
					--activeAnim.time = activeAnim.time + elapsedTime;
					activeAnim.lastUpdateTick = game_tick_get();
					
					if (activeAnim.time > activeAnim.animation.length) then
						if activeAnim.animation.playMode == SUI_PLAY_MODE.Looping then
							activeAnim.time = 0;
						elseif activeAnim.animation.playMode == SUI_PLAY_MODE.PingPong then
							activeAnim.playReverse = not activeAnim.playReverse;
							activeAnim.time = 0;
						else
							-- Stop playing this animation.
							g_activeAnimations[elementID] = nil;
						end
					end
				end
			else
				-- Target element has been deleted.  Stop playing the animation.
				g_activeAnimations[elementID] = nil;
			end
			
			-- Too many channels!  Sleep and then keep going later.
			if channelUpdateCount > k_maxChannelUpdateCount then
				Sleep(0);
				channelUpdateCount = 0;
			end			
		end
		
		Sleep(0);
		
	until next(g_activeAnimations) == nil -- Keep updating as long as we have active, playing animations.
	g_animationUpdateActive = false;
end

function ScriptUI_CreateAnimation()
	local animation = {};
	animation.length = 0;
	animation.channels = {};
	animation.playMode = SUI_PLAY_MODE.Once;
	animation.playReverse = false;
	
	return animation;
end


function ScriptUI_SetCurveType(animation, channelType, curveType):void
	if (animation.channels[channelType] ~= nil) then
		animation.channels[channelType].curveType = curveType;
	else
		-- This animation doesn't have any data in this channel, so we must create it.
		animation.channels[channelType] = {};
		animation.channels[channelType].keyframes = {};
		animation.channels[channelType].curveType = curveType;
	end
end


function ScriptUI_SetPlayMode(animation, playMode):void
	animation.playMode = playMode;
end


function ScriptUI_AddKeyframe(animation, channelType, time:number, value):void
	if (time > animation.length) then
		animation.length = time;
	end
	
	local keyframe = {};
	keyframe.time = time;
	keyframe.value = value;
	
	if (animation.channels[channelType] ~= nil) then
		if #animation.channels[channelType].keyframes == 0 then
			-- Channel but no keyframes.  This can happen if the channel's 
			-- curve type was set before any keyframes were added.
			animation.channels[channelType].keyframes = {keyframe};
		else
			-- Find location in the channel to insert the keyframe.
			for i,key in ipairs (animation.channels[channelType].keyframes) do
				if key.time == time then
					-- Replace existing value at this time.
					key = keyframe;
					break;
				elseif key.time > time then
					table.insert(animation.channels[channelType].keyframes, i, keyframe);
					break;
				elseif i == #animation.channels[channelType].keyframes then
					table.insert(animation.channels[channelType].keyframes, keyframe);
					break;
				end
			end
		end
	else
		-- This animation doesn't have any data in this channel, so we must create it.
		animation.channels[channelType] = {};
		animation.channels[channelType].keyframes = {keyframe};
		animation.channels[channelType].curveType = SUI_CURVE_TYPE.Linear;
	end
end


function ScriptUI_PlayAnimation(elementID, animation):void
	g_activeAnimations[elementID] = {};
	g_activeAnimations[elementID].animation = animation;
	g_activeAnimations[elementID].time = 0;
	g_activeAnimations[elementID].lastUpdateTick = game_tick_get();
	
	-- Apply first frame of animation immediately so that element renders correctly this frame.
	ApplyChannelsToElement(elementID, animation.channels, 0);
		
	if not g_animationUpdateActive then
		g_animationUpdateActive = true;
		CreateThread(UpdateAnimations);
	end
end


function ScriptUI_StopAnimation(elementID):void
	g_activeAnimations[elementID] = nil;
end
