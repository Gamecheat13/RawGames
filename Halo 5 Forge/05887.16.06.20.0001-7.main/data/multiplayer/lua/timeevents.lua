--
-- TIME EVENTS
--


--
-- Time remaining
--

timeRemaining = onUpdate:Filter(
	function (context)
		-- $TODO [milltin: 2015/4/16]
		-- Remove check for IsOvertimeTimerCountingDown ~= nil once that binding has made its way into all the branches.
		return context.Engine:InRound() and
			(context.Engine:IsRoundTimerCountingDown() or
				(context.Engine.IsOvertimeTimerCountingDown ~= nil and context.Engine:IsOvertimeTimerCountingDown()));
	end
	):Emit(
	function (context)
		if context.Engine:IsRoundTimerCountingDown() then
			context.TimeRemaining = context.Engine:GetRoundTimeRemaining();
		else
			-- $TODO [milltin: 2015/4/16]
			-- Remove check for GetOvertimeTimeRemaining ~= nil once that binding has made its way into all the branches.
			if context.Engine.GetOvertimeTimeRemaining ~= nil then
				context.TimeRemaining = context.Engine:GetOvertimeTimeRemaining();
			end
		end
	end	
	);

--
-- 5 minutes remaining
--

fiveMinutesRemaining = timeRemaining:ChangedTo(
	true,
	function (context) 
		return context.TimeRemaining <= 300; 
	end
	);
	
fiveMinutesRemainingWinningResponse = fiveMinutesRemaining:Target(WinnersTarget):Response(	
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit5min'
	});

fiveMinutesRemainingNeutralResponse = fiveMinutesRemaining:Target(NotWinnersTarget):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit5min'
	});

fiveMinutesSpectatorResponse = fiveMinutesRemaining:Target(TargetAllPlayers):Response(	
	{
		Perspective = GameEventPerspective.NeutralPerspective,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit5min'
	});
	

--
-- 2 minutes remaining
--

if (disable2MinutesRemaining == nil or disable2MinutesRemaining == false) then
	twoMinutesRemaining = timeRemaining:ChangedTo(
		true,
		function (context) 
			return context.TimeRemaining <= 120; 
		end
		);

	twoMinutesRemainWinningResponse = twoMinutesRemaining:Target(WinnersTarget):Response(
		{
			Perspective = GameEventPerspective.Personal,
			Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit2min'
		});
	
	twoMinutesRemainLosersResponse = twoMinutesRemaining:Target(NotWinnersTarget):Response(
		{
			Perspective = GameEventPerspective.Personal,
			Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit2min'
		});

	twoMinutesRemainSpectatorResponse = twoMinutesRemaining:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit2min'
		});
end
		
--
-- 60 seconds remaining
--

sixtySecondsRemaining = timeRemaining:ChangedTo(
	true,
	function (context) 
		return context.TimeRemaining <= 60; 
	end
	);

sixtySecondsRemainWinningResponse = sixtySecondsRemaining:Target(WinnersTarget):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit1min'
	});	
	
sixtySecondsRemainLosersResponse = sixtySecondsRemaining:Target(LosersTarget):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit1min'
	});

sixtySecondsRemainTiedResponse = sixtySecondsRemaining:Target(TiedTarget):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit1min'
	});

sixtySecondsRemainSpectatorResponse = sixtySecondsRemaining:Target(TargetAllPlayers):Response(
	{
		Perspective = GameEventPerspective.NeutralPerspective,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit1min'
	});

-- 1 minute remaining music is disabled for breakout
if (disable1MinuteRemainingMusic == nil or disable1MinuteRemainingMusic == false) then 

	sixtySecondsRemainWinningMusicResponse = sixtySecondsRemaining:Target(WinnersTarget):Response(
		{
			Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_time_60sec_winning'
		});	
		
	sixtySecondsRemainLosersMusicResponse = sixtySecondsRemaining:Target(LosersTarget):Response(
		{
			Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_time_60sec_losing'
		});

	sixtySecondsRemainTiedMusicResponse = sixtySecondsRemaining:Target(TiedTarget):Response(
		{
			Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_time_60sec_neutral'
		});
	
end
		
	
--
-- 30 seconds remaining
--

thirtySecondsRemaining = timeRemaining:ChangedTo(
	true,
	function (context)
		return context.TimeRemaining <= 30;
	end
	);

thirtySecondsRemainWinningResponse = thirtySecondsRemaining:Target(WinnersTarget):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit30s'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_time_30sec_winning'
	});	

thirtySecondsRemainLosersResponse = thirtySecondsRemaining:Target(LosersTarget):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit30s'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_time_30sec_losing'
	});

thirtySecondsRemainTiedResponse = thirtySecondsRemaining:Target(TiedTarget):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit30s'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_time_30sec_neutral'
	});

thirtySecondsRemainSpectatorResponse = thirtySecondsRemaining:Target(TargetAllPlayers):Response(
	{
		Perspective = GameEventPerspective.NeutralPerspective,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit30s'
	})
	
--
-- 10 seconds remaining
--

tenSecondsRemaining = timeRemaining:ChangedTo(
	true,
	function (context)
		return context.TimeRemaining <= 10;
	end
	);

tenSecondsRemainWinningResponse = tenSecondsRemaining:Target(TargetAllPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit10s'
	});

tenSecondsRemainSpectatorResponse = tenSecondsRemaining:Target(TargetAllPlayers):Response(
	{
		Perspective = GameEventPerspective.NeutralPerspective,
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit10s'
	});

--
-- Overtime
--

__OnOvertimeStart = Delegate:new();

onOvertimeStart = root:AddCallback(__OnOvertimeStart);

overtimeStartResponse = onOvertimeStart:Target(TargetAllPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_overtime'
	}):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_overtimestart'
	});

overtimeStartSpectatorResponse = onOvertimeStart:Target(TargetAllPlayers):Response(
	{
		Perspective = GameEventPerspective.NeutralPerspective,
		Sound = 'multiplayer\audio\announcer\announcer_shared_overtime'
	}):Response(
	{
		Perspective = GameEventPerspective.NeutralPerspective,
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_overtimestart'
	});