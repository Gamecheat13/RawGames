
-- =================================================================================================
-- =================================================================================================
--DEVICE MACHINES
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------

-- == PLAY OVERLAY ANIMATIONS

--play simple animation in frames per second

function PlayAnimation (device:object, layer:number, name:string, rate:number):void
	print ("Play animation",name, "of device",device);
	DeviceSetLayerAnimation (device, layer, name);
	
	rate = rate or 30;
	
	DeviceSetLayerPlaybackStop(device, layer);
  DeviceSetLayerDest(device, layer, 1);
  DeviceSetLayerPos(device, layer, 0);
end


--Play simple looping animation in frames per second
--function PlayLoopingAnimation (device:object, layer:number, name:string, rate:number):void
--	print ("Play animation",name, "of device",device);
--	DeviceSetLayerAnimation (device, layer, name);
--	DeviceSetLayerPlaybackLoop (device, layer);
--	DeviceSetLayerRate(deviceMachine, layer, rate);
--  DeviceSetLayerDest(deviceMachine, layer, 2);
--  DeviceSetLayerPos(deviceMachine, layer, 0);
--end
--
--
----Play simple bouncing animation in frames per second
--function PlayBouncingAnimation (device:object, layer:number, name:string, rate:number):void
--	print ("Play animation",name, "of device",device);
--	DeviceSetLayerAnimation (device, layer, name);
--	DeviceSetLayerPlaybackBounce (device, layer);
--	DeviceSetLayerRate(deviceMachine, layer, rate);
--  DeviceSetLayerDest(deviceMachine, layer, 2);
--  DeviceSetLayerPos(deviceMachine, layer, 0);
--end

--play animation in frames per second
function DeviceLayerPlayAnimation( deviceMachine:object, layer:number, name:string, rate:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackStop(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 1);
	DeviceSetLayerPos(deviceMachine, layer, 0);
end
function DeviceLayerPlayAnimationBackward( deviceMachine:object, layer:number, name:string, rate:number):void	-- using this to close hangar doors -tjp
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackStop(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 0);
	DeviceSetLayerPos(deviceMachine, layer, 1);
end
--Play looping animation in frames per second
function DeviceLayerPlayLoopingAnimation( deviceMachine:object, layer:number, name:string, rate:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackLoop(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 2);
	DeviceSetLayerPos(deviceMachine, layer, 0);
end

--Play bouncing animation in frames per second
function DeviceLayerPlayBouncingAnimation( deviceMachine:object, layer:number, name:string, rate:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackBounce(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 2);
	DeviceSetLayerPos(deviceMachine, layer, 0);
end

function DeviceLayerFadeInAnimation( deviceMachine:object, layer:number, name:string, rate:number, fadeInTime:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackStop(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 1);
	DeviceSetLayerPos(deviceMachine, layer, 0);
	DeviceSetLayerBlend(deviceMachine, layer, 0.0, 0);
	DeviceSetLayerBlend(deviceMachine, layer, 1.0, fadeInTime);
end

function DeviceLayerFadeInLoopingAnimation( deviceMachine:object, layer:number, name:string, rate:number, fadeInTime:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackLoop(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 1);
	DeviceSetLayerPos(deviceMachine, layer, 0);
	DeviceSetLayerBlend(deviceMachine, layer, 0.0, 0);
	DeviceSetLayerBlend(deviceMachine, layer, 1.0, fadeInTime);
end

function DeviceLayerFadeInBouncingAnimation( deviceMachine:object, layer:number, name:string, rate:number, fadeInTime:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackBounce(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 1);
	DeviceSetLayerPos(deviceMachine, layer, 0);
	DeviceSetLayerBlend(deviceMachine, layer, 0.0, 0);
	DeviceSetLayerBlend(deviceMachine, layer, 1.0, fadeInTime);
end

--play animation in frames per second
function DeviceLayerPlayAnimationDestination( deviceMachine:object, layer:number, name:string, rate:number, dest:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackStop(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	print("destination ", dest );
	DeviceSetLayerDest( deviceMachine, layer, dest );
	DeviceSetLayerPos(deviceMachine, layer, 0);
end

function DeviceLayerPlayAnimationDestinationContinue( deviceMachine:object, layer:number, name:string, rate:number, dest:number):void	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);	
	DeviceSetLayerDest( deviceMachine, layer, dest );
end

--USE THIS FUNCTION AS A TEMPLATE
--function anim_test ():void
--	print ("device test");
--	
--	--PlayAnimation (OBJECTS.dm_crane, 1, "any:turn", 20);
--	--PlayLoopingAnimation (OBJECTS.dm_crane, 1, "any:turn");
--	--PlayBouncingAnimation (OBJECTS.dm_crane, 1, "any:turn");
--	--PlayBouncingAnimation (OBJECTS.dm_crane, 1, "any:gears");
--	--OBJECTS.dm_crane:crane_do();
--end



--=========================HALO4 FUNCTIONS=======================

-- POSITION
-- -------------------------------------------------------------------------------------------------
-- === f_check_device_position: Check if a device has passed the position
--		dm_device [device machine] 	- Device machine to test
--		r_frames_check [real] 			- Frame to check
--			NOTE: Is a real so that you can check for even interpolated between frame positions
--		l_frames_total [long]				- Total number of frames in the animation
function f_check_device_position( dm_device:object, r_frames_check:number, l_frames_total:number ):boolean
	return device_get_position(dm_device) >= r_frames_check / l_frames_total;
end

function device_check_range( dm_device:object, r_min:number, r_max:number ):boolean
	return range_check(device_get_position(dm_device), r_min, r_max);
end

-- -------------------------------------------------------------------------------------------------
-- RELATIVE
-- -------------------------------------------------------------------------------------------------
-- === device_animate_position_relative: Plays an time based on the devices relative position to it's start and end position
--			r_pos_end [real] = Ending position of the animation sequence
--			[parameters] see: device_animate_position
function device_animate_position_relative( dm_device:object, r_position:number, r_time:number, r_blend_in:number, r_blend_out:number, b_blend_apply:boolean ):void
	local r_pos_scale:number=1.0;
	-- calculate the relative scale
	r_pos_scale = abs_r(r_position - device_get_position(dm_device));
	device_animate_position(dm_device, r_position, r_time * r_pos_scale, r_blend_in * r_pos_scale, r_blend_out * r_pos_scale, b_blend_apply);
end
-- -------------------------------------------------------------------------------------------------
-- VARIABLE SPEED
-- -------------------------------------------------------------------------------------------------
-- variables
global r_device_machine_scale:number=1.0;

-- functions
-- === device_animate_position_variable: Plays a device machine animation but allows speed scaling while the animation is playing
--			[parameters] see: device_animate_position
function device_animate_position_variable( dm_device:object, r_pos:number, r_time:number, r_blend_in:number, r_blend_out:number, b_blend_apply:boolean ):void
	local r_current_scale:number=1.0;
	local r_starting_pos:number=device_get_position(dm_device);
	local r_scale_pos:number=1.0;
	repeat
		Sleep(1);
		--r_time * r_current_scale * (1.0 - device_get_position(dm_vehiclebay_hull))
		if dm_device~=nil then
			r_current_scale = r_device_machine_scale;
			r_scale_pos = 1.0;
			if r_starting_pos < r_pos then
				r_scale_pos = 1.0 - (device_get_position(dm_device) - r_starting_pos) / (r_pos - r_starting_pos);
			end
			if r_starting_pos > r_pos then
				r_scale_pos = 1.0 - (r_starting_pos - device_get_position(dm_device)) / (r_starting_pos - r_pos);
			end
			print(r_scale_pos);
			device_animate_position(dm_device, r_pos, r_time * r_current_scale * r_scale_pos, r_blend_in, r_blend_out, b_blend_apply);
		end
		SleepUntil([| dm_device == nil or device_get_position(dm_device) == r_pos or r_current_scale~=r_device_machine_scale ], 1);
	until dm_device == nil or device_get_position(dm_device) == r_pos;
end

-- === transition_device_scale: Transitions device animation scale over time
--			r_scale_start = starting scale value
--				[r_scale_start < 0] = current scale
--			r_scale_end = final scale target
--				[r_scale_end < 0] = 1.0 (normal)
--			r_seconds = number of seconds the scale to change
--			s_refresh = refresh rate of the gravity change; 0 will update as often as possible
--				[r_refresh < 0] = 1;
--	RETURNS:  void
function transition_device_scale( r_scale_start:number, r_scale_end:number, r_seconds:number, s_refresh:number ):void
	if l_sys_transition_device_scale_ba953da5~=nil then
		KillThread(l_sys_transition_device_scale_ba953da5);
	end
	l_sys_transition_device_scale_ba953da5 = CreateThread(sys_transition_device_scale, r_scale_start, r_scale_end, r_seconds, s_refresh);
end
global l_sys_transition_device_scale_ba953da5:thread=nil;

-- === sys_transition_device_scale: System function for transition_device_scale
--			NOTE: DO NOT USE THIS FUNCTION
function sys_transition_device_scale( r_scale_start:number, r_scale_end:number, r_seconds:number, s_refresh:number ):void
	-- defaults
	if r_scale_start < 0 then
		r_scale_start = r_device_machine_scale;
	end
	if r_scale_end < 0 then
		r_scale_end = 1.0;
	end
	if s_refresh < 0 then
		s_refresh = 1;
	end
	-- get start time	
	l_time_start_cc1bacc4 = game_tick_get();
	-- get end time	
	l_time_end_cc1bacc4 = l_time_start_cc1bacc4 + seconds_to_frames(r_seconds);
	-- setup variables
	r_scale_range_cc1bacc4 = r_scale_end - r_scale_start;
	r_time_range_cc1bacc4 = l_time_end_cc1bacc4 - l_time_start_cc1bacc4;
	if r_scale_range_cc1bacc4 > 0.001 and r_time_range_cc1bacc4 > 0.001 then
		repeat
			Sleep(s_refresh);
			r_scale_delta_cc1bacc4 = (game_tick_get() - l_time_start_cc1bacc4) / r_time_range_cc1bacc4;
			-- set gravity to the current % of time progress
			r_device_machine_scale = r_scale_start + r_scale_range_cc1bacc4 * r_scale_delta_cc1bacc4;
		until game_tick_get() >= l_time_end_cc1bacc4;
	end
	r_device_machine_scale = r_scale_end;
end
global l_time_start_cc1bacc4:number=0;
global l_time_end_cc1bacc4:number=0;
global r_scale_range_cc1bacc4:number=0.0;
global r_scale_delta_cc1bacc4:number=0.0;
global r_time_range_cc1bacc4:number=0.0;
