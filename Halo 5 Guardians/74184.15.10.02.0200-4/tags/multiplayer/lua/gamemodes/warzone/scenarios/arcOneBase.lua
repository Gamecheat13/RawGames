


--
-- Arc-Specific Warzone Intro
--

__OnWarzoneIntro = Delegate:new();

onWarzoneIntro = root:AddCallback(
	__OnWarzoneIntro
	);
	
__OnWarzoneBaseIntro = Delegate:new();

onWarzoneBaseIntro = root:AddCallback(
	__OnWarzoneBaseIntro
	);

--
-- Arc One Base Intro
--

__OnWarzoneOneBaseIntro = Delegate:new();
onWarzoneOneBaseIntro = root:AddCallback(
	__OnWarzoneOneBaseIntro
	);

warzoneOneBaseIntroResponseAtt = onWarzoneOneBaseIntro:Target(PlayersOnAttackingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearcintroatt'
	});

warzoneOneBaseIntroResponseDef = onWarzoneOneBaseIntro:Target(PlayersOnDefendingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearcintrodef'
	});


--
-- Initial Spawn
--

__OnWarzoneSpawned = Delegate:new();

onWarzoneSpawned = root:AddCallback(
	__OnWarzoneSpawned
	);

warzoneBaseIntroSpawnedResponseAtt = onWarzoneSpawned:Target(PlayersOnAttackingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearcstartatt'
	});


warzoneBaseIntroSpawnedResponseDef = onWarzoneSpawned:Target(PlayersOnDefendingTeam):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearcstartdef'
	});


--
-- Arc Base Captured Events
--
	
onBaseCapturedSelect = onBaseCaptured:Select();



--
-- Arc One-Base Captured Events
--

-- The Garage

onArcOneBaseGarageBaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_onebase_garage'));


onArcOneBaseGarageBaseCapturedCapturing = onArcOneBaseGarageBaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_onebase_garage_captured_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_arcgaragecapturedfriendly'
	}):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasenextcapturearmoryatt'
	});

onArcOneBaseGarageBaseCapturedFriendly = onArcOneBaseGarageBaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_onebase_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_arcgaragecapturedfriendly'
	}):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasenextcapturearmoryatt'
	});

onArcOneBaseGarageBaseCapturedHostile = onArcOneBaseGarageBaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_onebase_garage_captured_enemy_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasegaragelost'
	}):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasenextcapturearmorydef'
	});

-- The Armory

onArcOneBaseArmoryCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_onebase_armory'));

onArcOneBaseArmoryCapturedCapturing = onArcOneBaseArmoryCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_onebase_armory_captured_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_armorycapturedfriendly'
	});

onArcOneBaseArmoryCapturedFriendly = onArcOneBaseArmoryCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_onebase_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_armorycapturedfriendly'
	});

onArcOneBaseArmoryCapturedHostile = onArcOneBaseArmoryCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_onebase_armory_captured_enemy_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_onebasearmorylost'
	});



--
-- Defend
--

defendResponses =
{	
	-- Blue Home Base
	{
		name = "attacker_homebase",

		responses = 
		{
			beginResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackhomebase'
			},

			successResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackdefendedhomebase'
			},
		},
	},
	
	-- Red Home Base
	{
		name = "defender_homebase",

		responses = 
		{
			beginResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackhomebase'
			},

			successResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackdefendedhomebase'
			},
		},
	},
}
	