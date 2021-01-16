--
-- TIME EVENTS
--


--
-- Time remaining
--

timeRemaining = onUpdate:Filter(
	function (context)
		return context.Engine:InRound() and context.Engine:IsRoundTimerCountingDown();
	end
	):Emit(
	function (context)
		context.TimeRemaining = context.Engine:GetRoundTimeRemaining();
	end	
	);

--
-- 5 minutes remaining
--

fiveMinutesRemaining = timeRemaining:ChangedTo(
	true,
	function (context) 
		return context.TimeRemaining < 300; 
	end
	);
	
fiveMinutesRemainingWinningResponse = fiveMinutesRemaining:Target(WinnersTarget):Response(	
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit5min'
	});

fiveMinutesRemainingNeutralResponse = fiveMinutesRemaining:Target(NotWinnersTarget):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit5min'
	});
	

--
-- 2 minutes remaining
--

if (disable2MinutesRemaining == nil or disable2MinutesRemaining == false) then
	twoMinutesRemaining = timeRemaining:ChangedTo(
		true,
		function (context) 
			return context.TimeRemaining < 120; 
		end
		);

	twoMinutesRemainWinningResponse = twoMinutesRemaining:Target(WinnersTarget):Response(
		{
			Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit2min'
		});
	
	twoMinutesRemainLosersResponse = twoMinutesRemaining:Target(NotWinnersTarget):Response(
		{
			Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit2min'
		});
end
		
--
-- 60 seconds remaining
--

sixtySecondsRemaining = timeRemaining:ChangedTo(
	true,
	function (context) 
		return context.TimeRemaining < 60; 
	end
	);

sixtySecondsRemainWinningResponse = sixtySecondsRemaining:Target(WinnersTarget):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit1min'
	});	
	
sixtySecondsRemainLosersResponse = sixtySecondsRemaining:Target(LosersTarget):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit1min'
	});

sixtySecondsRemainTiedResponse = sixtySecondsRemaining:Target(TiedTarget):Response(
	{
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
		return context.TimeRemaining < 30;
	end
	);

thirtySecondsRemainWinningResponse = thirtySecondsRemaining:Target(WinnersTarget):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit30s'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_time_30sec_winning'
	});	

thirtySecondsRemainLosersResponse = thirtySecondsRemaining:Target(LosersTarget):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit30s'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_time_30sec_losing'
	});

thirtySecondsRemainTiedResponse = thirtySecondsRemaining:Target(TiedTarget):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit30s'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_time_30sec_neutral'
	});
	
--
-- 10 seconds remaining
--

tenSecondsRemaining = timeRemaining:ChangedTo(
	true,
	function (context)
		return context.TimeRemaining < 10;
	end
	);

tenSecondsRemainWinningResponse = tenSecondsRemaining:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_timelimit10s'
	});
