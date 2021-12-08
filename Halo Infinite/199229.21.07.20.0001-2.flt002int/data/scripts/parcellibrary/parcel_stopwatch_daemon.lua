-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

global StopwatchDaemon = Parcel.MakeParcel
{
	instanceName = "StopwatchDaemon",
	complete = false,

	nextStopwatchIndex = 1,
	stopwatches = {},

	CONFIG =
	{
		enableDebugPrint = false,

		timePointAssertsEnabled = true,		-- Whether or not we will assert against expected Sleep durations and observed time drift in the stat update routine
		totalDurationAssertEnabled = false, -- Temporarily disabling this assert because CONST.totalEmissionTimeErrorToleranceSec needs to be a percentage tolerance rather than a constant epsilon

		assertOnDoubleStarts = true,
		assertOnDoubleStops = true,
	},

	CONST =
	{
		minDiscreteInterval = 0.1,
		sleepEpsilonSec = .001,						-- The epsilon that is added to SleepSeconds() durations to ensure we sleep for long enough
		totalEmissionTimeErrorToleranceSec = .01,	-- The acceptable error tolerance for accurately reported total emitted duration
	},
};

hstructure StopwatchTargetState
	timeLastEmitted 		:time_point;
	updateThread 			:thread;

	startTime 				:time_point;
	totalTimeEmitted		:number;
end

function StopwatchDaemon:New():table
	return self:CreateParcelInstance();
end

function StopwatchDaemon:Run():void

end

function StopwatchDaemon:EndShutdown():void
	for stopwatchIndex, stopwatch in hpairs(self.stopwatches) do
		assert(type(stopwatch) == "struct", "Unexpected type encountered in self.stopwatches!");
		local structName:string = struct.name(stopwatch);

		if (structName == "DiscreteIntervalStopwatch") then
			self:DisposeDiscreteIntervalEmitter(stopwatchIndex);
		else
			assert(false, "Encountered an unhandled hstruct type (" .. structName .. ") in StopwatchDaemon:EndShutdown()!");
		end
	end

	self.stopwatches = {};
end

function StopwatchDaemon:shouldEnd():boolean
	return self.complete;
end

--|-----------------------------------------------------------------|--
--|=================== Discrete Interval Stopwatch ===================|--
--|-----------------------------------------------------------------|--


hstructure DiscreteIntervalStopwatch
	debugName 				:string;
	ownerParcel 			:table;		-- optional param for owning parcel of this stopwatch; will be passed as first arg to intervalCallback if non-nil
	discreteIntervalSec 	:number;
	intervalCallback 		:ifunction; -- function that will be invoked upon each elapsed interval with the call signature:  func(target:any, intervalElapsedSec:number, totalTimeEmitted:number)
	emitForRemainderOnStop 	:boolean;   -- whether or not the intervalCallback will be invoked when StopDiscreteIntervalStopwatchForTarget() is called with the remaining unemitted time

	targetStates 	:table;		-- table of StopwatchTargetState
end

-- Returns a "handle" to this stopwatch
function StopwatchDaemon:CreateDiscreteIntervalStopwatch(ownerParcel:table, discreteIntervalSec:number, intervalCallback:ifunction, emitForRemainderOnStop:boolean, stopwatchDebugName:string):number
	-- Validate inputs
	assert(discreteIntervalSec ~= nil and discreteIntervalSec > 0, "Invalid discreteIntervalSec supplied!");
	discreteIntervalSec = math.max(discreteIntervalSec, self.CONST.minDiscreteInterval);

	assert(intervalCallback ~= nil, "A nil intervalCallback was supplied when attempting to create a new DiscreteIntervalStopwatch!");

	local newStopwatchIndex:number = self.nextStopwatchIndex;
	if (stopwatchDebugName == nil or stopwatchDebugName == "") then
		stopwatchDebugName = "DiscreteIntervalStopwatch_" .. tostring(newStopwatchIndex);
	end

	-- Create a shim that passes the ownerParcel as the first arg if supplied (to facilitate the self:FunctionName declaration syntax)
	local intervalCallbackThunk:ifunction = intervalCallback;
	if (ownerParcel ~= nil) then
		intervalCallbackThunk = function(target, timeToEmit, totalTimeEmitted) intervalCallback(ownerParcel, target, timeToEmit, totalTimeEmitted) end
	end

	-- Create the new stopwatch
	self.stopwatches[newStopwatchIndex] =
		hmake DiscreteIntervalStopwatch
		{
			debugName = stopwatchDebugName,
			ownerParcel = ownerParcel,
			discreteIntervalSec = discreteIntervalSec,
			intervalCallback = intervalCallbackThunk,
			emitForRemainderOnStop = emitForRemainderOnStop or false,

			targetStates = {},
		};

	self.nextStopwatchIndex = self.nextStopwatchIndex + 1;
	return newStopwatchIndex;
end

function StopwatchDaemon:DisposeDiscreteIntervalStopwatch(stopwatchIndex:number):void
	assert(stopwatchIndex ~= nil);
	local stopwatch:DiscreteIntervalStopwatch = self.stopwatches[stopwatchIndex];
	assert(stopwatch ~= nil);

	for target, targetState in hpairs(stopwatch.targetStates) do
		self:StopDiscreteIntervalStopwatchForTarget_Internal(target, stopwatch, targetState);
	end

	-- Nil out reference-type members to ensure proper GC
	stopwatch.targetStates = nil;
	stopwatch.ownerParcel = nil;
	stopwatch.intervalCallback = nil;

	self.stopwatches[stopwatchIndex] = nil;
end

function StopwatchDaemon:StartDiscreteIntervalStopwatchForTarget(target:any, stopwatchIndex:number):void
	assert(target ~= nil and stopwatchIndex ~= nil);

	local stopwatch:DiscreteIntervalStopwatch = self.stopwatches[stopwatchIndex];
	assert(stopwatch ~= nil);

	if (stopwatch.targetStates[target] == nil) then
		local currentTime:time_point = Game_TimeGet();

		local newTargetState:StopwatchTargetState =
			hmake StopwatchTargetState
			{
				timeLastEmitted = currentTime,
				updateThread = nil,

				startTime = currentTime,
				totalTimeEmitted = 0,
			};

		newTargetState.updateThread = self:CreateThread(self.DiscreteIntervalRoutine, target, newTargetState, stopwatch.discreteIntervalSec, stopwatch.intervalCallback, stopwatch.debugName);

		stopwatch.targetStates[target] = newTargetState;

	elseif (self.CONFIG.assertOnDoubleStarts) then
		debug_assert(false, "Attempted to call StartDiscreteIntervalStopwatchForTarget on an stopwatch that was already running (" .. stopwatch.debugName .. ")");
	end
end

function StopwatchDaemon:StopDiscreteIntervalStopwatchForTarget(target:any, stopwatchIndex:number):void
	assert(target ~= nil and stopwatchIndex ~= nil);

	local stopwatch:DiscreteIntervalStopwatch = self.stopwatches[stopwatchIndex];
	assert(stopwatch ~= nil);

	local targetState:StopwatchTargetState = stopwatch.targetStates[target];
	if (targetState ~= nil) then
		self:StopDiscreteIntervalStopwatchForTarget_Internal(target, stopwatch, targetState);
	elseif (self.CONFIG.assertOnDoubleStops) then
		debug_assert(false, "Attempted to call StopDiscreteIntervalStopwatchForTarget on an stopwatch that was not running (" .. stopwatch.debugName .. ")");
	end
end

function StopwatchDaemon:StopDiscreteIntervalStopwatchForTarget_Internal(target:any, stopwatch:DiscreteIntervalStopwatch, targetState:StopwatchTargetState):void
	-- Since this function is also called from EndShutdown(), we guard here so we only attempt to kill the update threads for non-shutdown calls
	if (targetState.updateThread ~= nil and ParcelIsActive(self)) then
		self:KillThread(targetState.updateThread);
		targetState.updateThread = nil;
	end

	local currentTime:time_point = Game_TimeGet();

	-- Flush whatever remaining unlogged time there is for this target if configured to do so
	if (stopwatch.emitForRemainderOnStop == true) then
		local remainderTimeToEmit:number = currentTime:ElapsedTime(targetState.timeLastEmitted);
		self:DebugPrint(stopwatch.debugName, "emitting remainder time of", remainderTimeToEmit, "sec for target", target);

		targetState.totalTimeEmitted = targetState.totalTimeEmitted + remainderTimeToEmit;
		stopwatch.intervalCallback(target, remainderTimeToEmit, targetState.totalTimeEmitted);

		targetState.timeLastEmitted = nil;
	end

	if (self.CONFIG.totalDurationAssertEnabled == true) then
		-- targetState.timeLastEmitted is cleared above if we emit the remainder; if that is nil then we assume we just emitted and calculate using currentTime
		local timeDurationEmitted:number = (targetState.timeLastEmitted or currentTime):ElapsedTime(targetState.startTime);
		debug_assert(math.abs(timeDurationEmitted - targetState.totalTimeEmitted) <= self.CONST.totalEmissionTimeErrorToleranceSec,
			"Total duration of tracking (" .. tostring(timeDurationEmitted) .. ") was not within tolerable range (+/- " .. tostring(self.CONST.totalEmissionTimeErrorToleranceSec) .. ") of the total time emitted (" .. tostring(targetState.totalTimeEmitted) .. ")!");
	end

	-- Clear the StopwatchTargetState for this target since it's now been disposed
	stopwatch.targetStates[target] = nil;
end

-- This routine will emit callbacks for time elapsed in discrete "chunks" of size [param:discreteUpdateInterval]
function StopwatchDaemon:DiscreteIntervalRoutine(target:any, targetState:StopwatchTargetState, discreteUpdateInterval:number, intervalCallback:ifunction, stopwatchDebugName:string):void
	-- Since this routine was spun up as a separate thread, we already have started accumulating drift from the discrete interval timeline
	local currentTime:time_point = Game_TimeGet();
	local accumulatedDriftSec:number = currentTime:ElapsedTime(targetState.timeLastEmitted);

	local updateSleepDurationSec:number = discreteUpdateInterval - accumulatedDriftSec;
	local prevLocalUpdateTime:time_point = currentTime;

	-- Now we'll emit every interval until this thread is killed or the parcel ends (we will do a final flush on shutdown)
	repeat
		-- Guaranteed to almost always sleep at LEAST the specified number of seconds; we add an epsilon to be safe (sleeping slightly too long is ok because we account for arbitrary drift)
		SleepSeconds(updateSleepDurationSec + self.CONST.sleepEpsilonSec);
		currentTime = Game_TimeGet();

		if (self.CONFIG.timePointAssertsEnabled) then
			-- Verify that we slept long enough as a result of the SleepSeconds call
			local elapsedTimeSinceLastLocalUpdate:number = currentTime:ElapsedTime(prevLocalUpdateTime);
			debug_assert(elapsedTimeSinceLastLocalUpdate >= updateSleepDurationSec,
				"SleepSeconds(" .. tostring(updateSleepDurationSec + self.CONST.sleepEpsilonSec) .. ") failed to sleep for the minimum tolerable duration of " .. tostring(updateSleepDurationSec) .. "s! Only " .. tostring(elapsedTimeSinceLastLocalUpdate) .. " seconds have elapsed!");

			-- If our math is right, at least one discrete update interval should now have elapsed since we last emitted
			local elapsedTimeSinceLastStatUpdate:number = currentTime:ElapsedTime(targetState.timeLastEmitted);
			debug_assert(elapsedTimeSinceLastStatUpdate >= discreteUpdateInterval,
				"Only " .. tostring(elapsedTimeSinceLastStatUpdate) .. " sec have elapsed since we last emitted; we should have been asleep longer!");
		end

		-- Emit for one elapsed discrete interval, marking the timestamp for timeLastEmitted precisely one interval ahead of the previous value
		self:DebugPrint(stopwatchDebugName, "emitting discrete time block of", discreteUpdateInterval, "sec for target", target);
		targetState.totalTimeEmitted = targetState.totalTimeEmitted + discreteUpdateInterval;
		intervalCallback(target, discreteUpdateInterval, targetState.totalTimeEmitted);

		targetState.timeLastEmitted = targetState.timeLastEmitted:Offset(discreteUpdateInterval);
		prevLocalUpdateTime = currentTime;
		accumulatedDriftSec = prevLocalUpdateTime:ElapsedTime(targetState.timeLastEmitted);

		updateSleepDurationSec = discreteUpdateInterval - accumulatedDriftSec;
	until self:shouldEnd();
end


--
-- DEBUG 
--

function StopwatchDaemon:DebugPrint(...):void
	if (self.CONFIG.enableDebugPrint) then
		print(unpack(arg));
	end	
end

function StopwatchDaemon:EnableDebugPrint(enable:boolean):void
	self.CONFIG.enableDebugPrint = enable;
end

-- Return how much time remains in a discrete interval. This should NOT be used for polling in place of subscribing to the events
function StopwatchDaemon:GetElapsedTimeForTarget(target:any, stopwatchIndex:number):number
	assert(target ~= nil and stopwatchIndex ~= nil);

	local stopwatch:DiscreteIntervalStopwatch = self.stopwatches[stopwatchIndex];
	assert(stopwatch ~= nil);

	local targetState:StopwatchTargetState = stopwatch.targetStates[target];
	if (targetState ~= nil) then
		return Game_TimeGet():ElapsedTime(targetState.timeLastEmitted);
	else
		return -1;
	end
end
