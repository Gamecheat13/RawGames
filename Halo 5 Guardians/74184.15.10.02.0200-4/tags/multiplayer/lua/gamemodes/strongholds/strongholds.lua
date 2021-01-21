--
-- Strongholds event definitions
--

--
-- Strongholds Location Names
--

local locationNames = 
{
	{'alpha',				ResolveString('named_location_alpha')},
	{'arbase',				ResolveString('named_location_ar_base')},
	{'arch', 				ResolveString('named_location_arch')},
	{'basement',			ResolveString('named_location_basement')},
	{'bluebase',			ResolveString('named_location_blue_base')},
	{'bluebasement',		ResolveString('named_location_blue_basement')},
	{'bluebend',			ResolveString('named_location_blue_bend')},
	{'bluebridge',			ResolveString('named_location_blue_bridge')},
	{'bluecatwalk',			ResolveString('named_location_blue_catwalk')},
	{'blueledge',			ResolveString('named_location_blue_ledge')},
	{'bluenest',			ResolveString('named_location_blue_nest')},
	{'blueone',				ResolveString('named_location_blue_one')},
	{'blueoutside',			ResolveString('named_location_blue_outside')},
	{'blueplatform',		ResolveString('named_location_blue_platform')},
	{'blueramp',			ResolveString('named_location_blue_ramp')},
	{'blueslide',			ResolveString('named_location_blue_slide')},
	{'bluestreet',			ResolveString('named_location_blue_street')},
	{'bluetower',			ResolveString('named_location_blue_tower')},
	{'bluetrench',			ResolveString('named_location_blue_trench')},
	{'bluetwo',				ResolveString('named_location_blue_two')},
	{'blueyard',			ResolveString('named_location_blue_yard')},
	{'bottombase',			ResolveString('named_location_bottom_base')},
	{'bottommid',			ResolveString('named_location_bottom_mid')},
	{'brbase',				ResolveString('named_location_br_base')},
	{'bravo',				ResolveString('named_location_bravo')},
	{'bridge',				ResolveString('named_location_bridge')},
	{'bunker',				ResolveString('named_location_bunker')},
	{'cafe',				ResolveString('named_location_cafe')},
	{'camobase',			ResolveString('named_location_camo_base')},
	{'carbine',				ResolveString('named_location_carbine')},
	{'carbinebase',			ResolveString('named_location_carbine_base')},
	{'casterbase',			ResolveString('named_location_caster_base')},
	{'catwalk',				ResolveString('named_location_catwalk')},
	{'cave',				ResolveString('named_location_cave')},
	{'charlie',				ResolveString('named_location_charlie')},
	{'delta',				ResolveString('named_location_delta')},
	{'dock',				ResolveString('named_location_dock')},
	{'drill',				ResolveString('named_location_drill')},
	{'echo',				ResolveString('named_location_echo')},
	{'foxtrot',				ResolveString('named_location_foxtrot')},
	{'garbagetruck',		ResolveString('named_location_garbage_truck')},
	{'golf',				ResolveString('named_location_golf')},
	{'greentower',			ResolveString('named_location_green_tower')},
	{'highcatwalk',			ResolveString('named_location_high_catwalk')},
	{'hill',				ResolveString('named_location_hill')},
	{'hotel',				ResolveString('named_location_hotel')},
	{'india',				ResolveString('named_location_india')},
	{'juliet',				ResolveString('named_location_juliet')},
	{'junction',			ResolveString('named_location_junction')},
	{'lift',				ResolveString('named_location_lift')},
	{'longhall',			ResolveString('named_location_long_hall')},
	{'lowcatwalk',			ResolveString('named_location_low_catwalk')},
	{'mid',					ResolveString('named_location_mid')},
	{'nest',				ResolveString('named_location_nest')},
	{'osbase',				ResolveString('named_location_os_base')},
	{'outside',				ResolveString('named_location_outside')},
	{'overhang',			ResolveString('named_location_overhang')},
	{'park',				ResolveString('named_location_park')},
	{'pink',				ResolveString('named_location_pink')},
	{'pit',					ResolveString('named_location_pit')},
	{'plasmabase',			ResolveString('named_location_plasma_base')},
	{'platform',			ResolveString('named_location_platform')},
	{'powerupbase',			ResolveString('named_location_powerup_base')},
	{'ramp',				ResolveString('named_location_ramp')},
	{'redbase',				ResolveString('named_location_red_base')},
	{'redbasement',			ResolveString('named_location_red_basement')},
	{'redbend',				ResolveString('named_location_red_bend')},
	{'redbridge',			ResolveString('named_location_red_bridge')},
	{'redcatwalk',			ResolveString('named_location_red_catwalk')},
	{'redledge',			ResolveString('named_location_red_ledge')},
	{'rednest',				ResolveString('named_location_red_nest')},
	{'redone',				ResolveString('named_location_red_one')},
	{'redoutside',			ResolveString('named_location_red_outside')},
	{'redplatform',			ResolveString('named_location_red_platform')},
	{'redramp',				ResolveString('named_location_red_ramp')},
	{'redslide',			ResolveString('named_location_red_slide')},
	{'redstreet',			ResolveString('named_location_red_street')},
	{'redtower',			ResolveString('named_location_red_tower')},
	{'redtrench',			ResolveString('named_location_red_trench')},
	{'redtwo',				ResolveString('named_location_red_two')},
	{'redyard',				ResolveString('named_location_red_yard')},
	{'river',				ResolveString('named_location_river')},
	{'rocketbase',			ResolveString('named_location_rocket_base')},
	{'rocks',				ResolveString('named_location_rocks')},
	{'scattershotbase',		ResolveString('named_location_scattershot_base')},
	{'security',			ResolveString('named_location_security')},
	{'shotgunbase',			ResolveString('named_location_shotgun_base')},
	{'slide',				ResolveString('named_location_slide')},
	{'sniperbase',			ResolveString('named_location_sniper_base')},
	{'street',				ResolveString('named_location_street')},
	{'swordbase',			ResolveString('named_location_sword_base')},
	{'topbase',				ResolveString('named_location_top_base')},
	{'topmid',				ResolveString('named_location_top_mid')},
	{'tower',				ResolveString('named_location_tower')},
	{'towerone',			ResolveString('named_location_tower_one')},
	{'towerthree',			ResolveString('named_location_tower_three')},
	{'towertwo',			ResolveString('named_location_tower_two')},
	{'trench',				ResolveString('named_location_trench')},
	{'turbine',				ResolveString('named_location_turbine')},
	{'yard',				ResolveString('named_location_yard')},
	{'yellowtower',			ResolveString('named_location_yellow_tower')}
};

--
-- Intro Events
--

__OnModeIntro = Delegate:new();

onModeIntro = root:AddCallback(
	__OnModeIntro
	);

modeIntroResponse = onModeIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_strongholds'
	});

--
-- Scoring Events
--

-- Scoring Team Changed

__OnScoringStart = Delegate:new();

onScoringStart = root:AddCallback(
	__OnScoringStart,
	function(context, scoringPlayers, scoringTeamNearingVictory)
		context.ScoringPlayers = scoringPlayers;
		context.MatchingPlayers = scoringPlayers;
		context.ScoringTeamIsNearingVictory = scoringTeamNearingVictory;
		local firstPlayer = table.first(scoringPlayers,
			function(player)
				return player ~= nil;
			end
			);
		if(firstPlayer ~= nil) then
			context.Designator = firstPlayer:GetTeamDesignator();
		end
	end
	);

onScoringStartFriendlyResponse = onScoringStart:Target(ScoringPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'strong_scoring',
		TeamDesignator = DesignatorProperty
	}):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_yourteamscoring'
	});

onScoringStartHostileResponse = onScoringStart:Target(PlayersHostileToScoringPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'strong_scoring',
		TeamDesignator = DesignatorProperty
	}):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_enemyteamscoring'
	});

-- Neutral Responses

function BuildScoringStartNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "ScoringStartNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_stronghold_' .. teamName .. 'teamscoring'
		});
end

scoringStartNeutralSelect = onScoringStart:Select();

GenerateTeamSpecificNeutralResponses(scoringStartNeutralSelect, BuildScoringStartNeutralResponse)

--
-- Scoring Spree
--
__OnScoringTicked = Delegate:new();

onScoringTicked = root:AddCallback(
	__OnScoringTicked,
	function(context, scoringPlayers, points)
		context.ScoringPlayers = scoringPlayers;
		context.Points = points;
	end
	);

scoringSpreeAccumulator = root:CreatePlayerAccumulator();

onScoringSpree = onScoringTicked:PlayerAccumulator(
	scoringSpreeAccumulator,
	function (context)
		return context.ScoringPlayers, context.Points;
	end
	);

onScoringStart:ResetPlayerAccumulator(
	scoringSpreeAccumulator,
	 function (context)
		return context.ScoringPlayers;
	 end
	 );
	
--
-- 20 points
--

onTwentyPointRun = onScoringSpree:Filter(
	function (context)
		return table.any(context.ScoringPlayers,
			function(player)
				local playerValue = scoringSpreeAccumulator:GetValue(player)
				return playerValue - context.Points < 20 and playerValue >= 20 ;
			end
		);
	end
	);

onTwentyPointRunResponse = onTwentyPointRun:Target(ScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_20pointrun'
	});
	
onTwentyPointRunHostileResponse = onTwentyPointRun:Target(PlayersHostileToScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_enemy20pointrun'
	});

-- Neutral Responses

function BuildTwentyPointRunNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "TwentyPointRunNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_stronghold_' .. teamName .. 'team20pointrun'
		});
end

onTwentyPointRunNeutralSelect = onTwentyPointRun:Select();

GenerateTeamSpecificNeutralResponses(onTwentyPointRunNeutralSelect, BuildTwentyPointRunNeutralResponse)

--
-- 40 points
--

onFortyPointRun = onScoringSpree:Filter(
	function (context)
		return table.any(context.ScoringPlayers,
			function(player)
				local playerValue = scoringSpreeAccumulator:GetValue(player)
				return playerValue - context.Points < 40 and playerValue >= 40;
			end
		);
	end
	);

onFortyPointRunResponse = onFortyPointRun:Target(ScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_40pointrun'
	});
	
onFortyPointRunHostileResponse = onFortyPointRun:Target(PlayersHostileToScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_enemy40pointrun'
	});
	
-- Neutral Responses

function BuildFortyPointRunNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "FortyPointRunNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_stronghold_' .. teamName .. 'team40pointrun'
		});
end

onFortyPointRunNeutralSelect = onFortyPointRun:Select();

GenerateTeamSpecificNeutralResponses(onFortyPointRunNeutralSelect, BuildFortyPointRunNeutralResponse)

--
-- 60 points
--

onSixtyPointRun = onScoringSpree:Filter(
	function (context)
		return table.any(context.ScoringPlayers,
			function(player)
				local playerValue = scoringSpreeAccumulator:GetValue(player)
				return playerValue - context.Points < 60 and playerValue >= 60;
			end
		);
	end
	);

onSixtyPointRunResponse = onSixtyPointRun:Target(ScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_60pointrun'
	});
	
onSixtyPointRunHostileResponse = onSixtyPointRun:Target(PlayersHostileToScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_enemy60pointrun'
	});
	
-- Neutral Responses

function BuildSixtyPointRunNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "SixtyPointRunNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_stronghold_' .. teamName .. 'team60pointrun'
		});
end

onSixtyPointRunNeutralSelect = onSixtyPointRun:Select();

GenerateTeamSpecificNeutralResponses(onSixtyPointRunNeutralSelect, BuildSixtyPointRunNeutralResponse)

--
-- 80 points
--

onEightyPointRun = onScoringSpree:Filter(
	function (context)
		return table.any(context.ScoringPlayers,
			function(player)
				local playerValue = scoringSpreeAccumulator:GetValue(player)
				return playerValue - context.Points < 80 and playerValue >= 80;
			end
		);
	end
	);

onEightyPointRunResponse = onEightyPointRun:Target(ScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_80pointrun'
	});
	
onEightyPointRunHostileResponse = onEightyPointRun:Target(PlayersHostileToScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_enemy80pointrun'
	});

-- Neutral Responses

function BuildEightyPointRunNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "EightyPointRunNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_stronghold_' .. teamName .. 'team40pointrun'
		});
end

onEightyPointRunNeutralSelect = onEightyPointRun:Select();

GenerateTeamSpecificNeutralResponses(onEightyPointRunNeutralSelect, BuildEightyPointRunNeutralResponse)


-- Gained lead

__OnGainedLead = Delegate:new();

onGainedLead = root:AddCallback(
	__OnGainedLead,
	function(context, scoringPlayers)
		context.ScoringPlayers = scoringPlayers;
		context.MatchingPlayers = scoringPlayers;
	end
	);

onGainedLeadFriendlyResponse = onGainedLead:Target(ScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scoregainedleadself'
	});

onGainedLeadHostileResponse = onGainedLead:Target(PlayersHostileToScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_slayer_scorelostlead'
	});

-- Neutral Responses

function BuildGainedLeadNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "GainedLeadNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamgainedlead'
		});
end

gainedLeadNeutralSelect = onGainedLead:Select();

GenerateTeamSpecificNeutralResponses(gainedLeadNeutralSelect, BuildGainedLeadNeutralResponse)

--Halfway to Victory

__OnHalfwayToVictory = Delegate:new();

onHalfwayToVictory = root:AddCallback(
	__OnHalfwayToVictory,
	function(context, scoringPlayers)
		context.ScoringPlayers = scoringPlayers;
		context.MatchingPlayers = scoringPlayers;
	end
	);

onHalfwayToVictoryWinningResonse = onHalfwayToVictory:Target(ScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_score50percentself'
	});

onHalfwayToVictoryLosingResponse = onHalfwayToVictory:Target(PlayersHostileToScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_scorehalfwayenemy'
	});

-- Halfway to victory neutral responses

function BuildHalfwayVictoryNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "NearingVictoryNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamscorehalfway'
		});
end

halfwayToVictoryNeutralSelect = onHalfwayToVictory:Select();

GenerateTeamSpecificNeutralResponses(halfwayToVictoryNeutralSelect, BuildHalfwayVictoryNeutralResponse)

-- Three Quarters to Victory

__OnThreeQuartersToVictory = Delegate:new();

onThreeQuartersToVictory = root:AddCallback(
	__OnThreeQuartersToVictory,
	function(context, scoringPlayers)
		context.ScoringPlayers = scoringPlayers;
		context.MatchingPlayers = scoringPlayers;
	end
	);

onThreeQuartersToVictoryWinningResponse = onThreeQuartersToVictory:Target(ScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_nearingvictory'
	});

onThreeQuartersToVictoryLosingResponse = onThreeQuartersToVictory:Target(PlayersHostileToScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_shared_scorenearingvictoryenemy'
	});


-- Three quarters victory neutral response

function BuildThreeQuartersVictoryNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "NearingVictoryNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_shared_' .. teamName .. 'teamscorenearingvictory'
		});
end

threeQuartersVictoryNeutralSelect = onThreeQuartersToVictory:Select();

GenerateTeamSpecificNeutralResponses(threeQuartersVictoryNeutralSelect, BuildThreeQuartersVictoryNeutralResponse)


-- Victory Imminent

__OnSevenEighthsVictory = Delegate:new();

onSevenEighthsVictory = root:AddCallback(
	__OnSevenEighthsVictory,
	function(context, scoringPlayers)
		context.ScoringPlayers = scoringPlayers;
	end
	);

onSevenEighthsVictoryWinningResponse = onSevenEighthsVictory:Target(ScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_victoryimminent'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_points_winning_loop'
	});

onSevenEighthsVictoryLosingResponse = onSevenEighthsVictory:Target(PlayersHostileToScoringPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_enemyvictoryimminent'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_global\music_mp_global_roundending_points_losing_loop'
	});

--
-- Base Activate, Depleted, Incoming
--

__OnStrongholdsIncoming = Delegate:new();

onStrongholdsIncoming = root:AddCallback(
	__OnStrongholdsIncoming
	);

strongholdsIncomingResponse = onStrongholdsIncoming:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_newstrongholdsin10seconds'
	});

__OnStrongholdsOnline = Delegate:new();

onStrongholdsOnline = root:AddCallback(
	__OnStrongholdsOnline
	);

strongholdsOnlineResponse = onStrongholdsOnline:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_baseonline'
	});

--
-- Stronghold Contested
--

__OnStrongholdContested = Delegate:new();

onStrongholdContested = root:AddCallback(
	__OnStrongholdContested,
	function(context, zone, players)
		context.Zone = zone;
		context.MatchingPlayers = players;
	end
	);

strongholdContestedResponse = onStrongholdContested:Target(MatchingPlayers):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecaptureinterrupted'
	});

--
-- Player Entered Stronghold
--

__OnPlayerEnteredStronghold = Delegate:new();

onPlayerEnteredStronghold = root:AddCallback(
	__OnPlayerEnteredStronghold,
	function(context, player)
		context.TargetPlayer = player;
	end
	);

playerCapturingStronghold = onPlayerEnteredStronghold:Filter(
	function(context)
		return context.TargetPlayer:IsCapturingStronghold();
	end
	);

playerCapturingStrongholdResponse = playerCapturingStronghold:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecapturestartloop'
	});

--
-- Player Left Stronghold
--

__OnPlayerLeftStronghold = Delegate:new();

onPlayerLeftStronghold = root:AddCallback(
	__OnPlayerLeftStronghold,
	function(context, player)
		context.TargetPlayer = player;
	end
	);

playerLeftStrongholdResponse = onPlayerLeftStronghold:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecapturestoploop'
	});


--
-- Strongholds Capture Events
--

-- Start Capture

__OnCaptureStarted = Delegate:new();

onCaptureStarted = root:AddCallback(
	__OnCaptureStarted,
	function(context, capturingPlayers, zone)
		context.CapturingPlayers = capturingPlayers;
		context.Zone = zone;
	end
	);

function FirstCapturingPlayer(context)

	return table.first(context.CapturingPlayers,
		function (player)
			return player;
		end
	);
end

captureStartedCapturingPlayersResponse = onCaptureStarted:Target(CapturingPlayers):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecaptureinitiated'
	}):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecapturestartloop'
	});

captureStartedFirstPlayerResponse = onCaptureStarted:Target(FirstCapturingPlayer):Response(
	{
		DialogueEvent = function (context)
							local firstCapturingPlayerUnit = FirstCapturingPlayer(context):GetUnit();

							if firstCapturingPlayerUnit ~= nil then
								return
									{
										EventStringId = ResolveString("capturing_started"),
										SubjectUnit = firstCapturingPlayerUnit
									}
							end

							return nil;
						end		
	});
	
--Standard Capture 

__OnStrongholdCapture = Delegate:new();

onStrongholdCapture = root:AddCallback(
	__OnStrongholdCapture,
	function (context, capturingPlayers, assistingPlayers, zone)
		local indexedCapturingPlayers = table.filtervalues(capturingPlayers,
			function(player)
				return player;
			end
			);

		context.CapturingPlayers = indexedCapturingPlayers;
		context.AssistingPlayers = assistingPlayers;
		context.Zone = zone;
	end
	);

--music

CapturerMusicResponse = onStrongholdCapture:Target(CapturingPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_strongholds\music_mp_strongholds_basecaptured_player'		
	}):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecapturestoploop'
	});


DominationStopMusicResponse = onStrongholdCapture:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_strongholds\music_mp_strongholds_domination_loop_stop'
	});

-- Capturer medal

strongholdCapturedMedalResponse = onStrongholdCapture:Target(CapturingPlayers):Response(
	{
		Medal = 'strong_capture',
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_strongholdcaptured'
	}):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecapturecompleted'
	});

-- Zone specific capture events
strongholdCapturedZoneSelect = onStrongholdCapture:Select();

function BuildZoneCapturedResponses(name, sourceEvent)

	local globals = _G;

	globals[name .. "StrongholdCapturedFriendlyMultiplePlayerResponse"] = sourceEvent:Target(FriendlyToCapturingPlayers):Response(
		{
			Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_strongholds_shfriendlycapture' .. name
		});

	globals[name .. "StrongholdCapturedHostileResponse"] = sourceEvent:Target(PlayersHostileToCapturingPlayers):Response(
		{
			Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_strongholds_shhostilecapture' .. name
		});

end

for index, namedLocation in ipairs(locationNames) do

	local zoneIndex = namedLocation[2];

	local sourceEvent = strongholdCapturedZoneSelect:Add(
		function(context)
			return context.Zone == zoneIndex;
		end
		);

	BuildZoneCapturedResponses(namedLocation[1], sourceEvent);
end


--Numerical Stronghold Capture

numberStrongholdsControlledSelect = onStrongholdCapture:Select();

onOneStrongholdsControlled = numberStrongholdsControlledSelect:Add(
	function(context)
		local firstCapturingPlayer = table.first(context.CapturingPlayers,
			function(player)
				return player;
			end
			);

		return firstCapturingPlayer:GetNumberOfControlledStrongholds() == 1
	end
	);

onThreeStrongholdsControlled = numberStrongholdsControlledSelect:Add(
	function(context)
		local firstCapturingPlayer = table.first(context.CapturingPlayers,
			function(player)
				return player;
			end
			);

		return firstCapturingPlayer:GetNumberOfControlledStrongholds() == 3
	end
	);

strongholdsDominationFriendlyResponse = onThreeStrongholdsControlled:Target(PlayersFriendlyToCapturingTeam):Response(
	{
		Medal = 'strong_domination'
	}):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_totalcontrol'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_strongholds\music_mp_strongholds_dominating_loop'
	});

strongholdsDominationHostileResponse = onThreeStrongholdsControlled:Target(PlayersHostileToCapturingPlayers):Response(
	{
		Perspective = GameEventPerspective.Personal,
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_enemytotalcontrol'
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_strongholds\music_mp_strongholds_dominated_loop'
	});

dominationChatterResponse = onThreeStrongholdsControlled:Target(FirstCapturingPlayer):Response(
	{
		DialogueEvent = function (context)
							local firstCapturingPlayerUnit = FirstCapturingPlayer(context):GetUnit();

							if firstCapturingPlayerUnit ~= nil then
								return
									{
									 EventStringId = ResolveString("captured_last"),
									 SubjectUnit = firstCapturingPlayerUnit;
									}
							end
						end			
	});

-- Three strongholds controlled neutral response

function BuildTotalControlNeutralResponse(teamName, sourceEvent)
	local globals = _G;

	globals[teamName .. "TotalControlNeutralResponse"] = sourceEvent:Target(TargetAllPlayers):Response(
		{
			Perspective = GameEventPerspective.NeutralPerspective,
			Sound = 'multiplayer\audio\announcer\announcer_stronghold_' .. teamName .. 'teamallstrongholdscontrolled'
		});
end

onThreeStrongholdsControlledNeutralSelect = onThreeStrongholdsControlled:Select();

GenerateTeamSpecificNeutralResponses(onThreeStrongholdsControlledNeutralSelect, BuildTotalControlNeutralResponse)

-- Capture Assist
captureAssistResponse = onStrongholdCapture:Target(AssistingPlayers):Response(
	{
		Medal = 'strong_capture_assist',
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_strongholds\music_mp_strongholds_basecaptured_player'
	});

--
-- Capturing Spree
--

capturesSinceDeathAccumulator = root:CreatePlayerAccumulator();

onCapturesSinceDeath = onStrongholdCapture:PlayerAccumulator(
	capturesSinceDeathAccumulator,
	function (context)
		return context.CapturingPlayers;
	end
);

onPlayerDeath:ResetPlayerAccumulator(
	capturesSinceDeathAccumulator,
	 function (context)
	 	return context.DeadPlayer;
	 end
);

onRoundStart:ResetAccumulator(capturesSinceDeathAccumulator);

function CapturingPlayersWithCaptureSpree(context)
	return table.filter(context.CapturingPlayers,
		function (player)
			return capturesSinceDeathAccumulator:GetValue(player) % 3 == 0;
		end
		);
end

onEveryThreeCapturesSinceDeath = onCapturesSinceDeath:Target(CapturingPlayersWithCaptureSpree):Response(
	{
		Medal = 'strong_capture_spree',
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_capturespree'
	});

--
-- Stronghold Stat Kills
--

__OnEnemyCaptureProgressErased = Delegate:new();

onStrongholdSecured = root:AddCallback(
	__OnEnemyCaptureProgressErased,
	function(context, players, zone)
		context.CapturingPlayers = players;
		context.Zone = zone;
	end
	); 

-- TODO: v-magro 5/11/15: Robbie needs to change out the sound that is played to be a unique Base Defense sound effect.
strongholdSecuredResponse = onStrongholdSecured:Target(CapturingPlayers):Response(
	{
		Medal = 'strong_secured',
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_basedefense'
	}):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecaptureinterrupted'
	}):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecapturecontestedstop'
	});

-- Defense spree

defendsSinceDeathAccumulator = root:CreatePlayerAccumulator();

onDefendsSinceDeath = onStrongholdSecured:PlayerAccumulator(
	defendsSinceDeathAccumulator,
	function (context)
		return context.CapturingPlayers;
	end
	);

onPlayerDeath:ResetPlayerAccumulator(
	defendsSinceDeathAccumulator,
	function (context)
		return context.DeadPlayer;
	end
	);

onRoundStart:ResetAccumulator(defendsSinceDeathAccumulator);

defendsSinceDeathBucket = onDefendsSinceDeath:Bucket(
	CapturingPlayers,
	function(context, players)
		context.MatchingPlayers = players;
	end
	);

onThreeDefendsBucket = defendsSinceDeathBucket:Add(
	function(context, player)
		return defendsSinceDeathAccumulator:GetValue(player) % 3 == 0;
	end
	);

defenseSpreeResponse = onThreeDefendsBucket:Target(MatchingPlayers):Response(
	{
		Medal = 'strong_secure_spree',
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_lockdown'
	});

--
-- Stronghold defense
--

onStrongholdDefense = onEnemyPlayerKill:Filter(
	function(context)
		return context.DeadPlayer:InHostileStronghold()
	end
	):Target(KillingPlayer):Response(
	{
		Medal = 'strong_defense'
	});