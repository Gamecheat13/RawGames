
local locationNames = 
{
	{'generic',				ResolveString('named_location_alley')},
	{'alpha',				ResolveString('named_location_alpha')},
	{'arbase',				ResolveString('named_location_ar_base')},
	{'arch', 				ResolveString('named_location_arch')},
	{'generic',				ResolveString('named_location_armory')},
	{'generic',				ResolveString('named_location_back_rail')},
	{'generic',				ResolveString('named_location_balcony')},
	{'basement',			ResolveString('named_location_basement')},
	{'generic',				ResolveString('named_location_bat_ledge')},
	{'generic',				ResolveString('named_location_bay_doors')},
	{'generic',				ResolveString('named_location_beacon')},
	{'generic',				ResolveString('named_location_big_rock')},
	{'generic',				ResolveString('named_location_big_rocks')},
	{'generic',				ResolveString('named_location_big_tower')},
	{'generic',				ResolveString('named_location_blue_alley')},
	{'generic',				ResolveString('named_location_blue_back_alley')},
	{'generic',				ResolveString('named_location_blue_backroom')},
	{'bluebase',			ResolveString('named_location_blue_base')},
	{'bluebasement',		ResolveString('named_location_blue_basement')},
	{'bluebend',			ResolveString('named_location_blue_bend')},
	{'bluebridge',			ResolveString('named_location_blue_bridge')},
	{'bluecatwalk',			ResolveString('named_location_blue_catwalk')},
	{'generic',				ResolveString('named_location_blue_cave')},
	{'generic',				ResolveString('named_location_blue_closet')},
	{'generic',				ResolveString('named_location_blue_courtyard')},
	{'generic',				ResolveString('named_location_blue_cross')},
	{'generic',				ResolveString('named_location_blue_deck')},
	{'generic',				ResolveString('named_location_blue_door')},
	{'generic',				ResolveString('named_location_blue_elbow')},
	{'generic',				ResolveString('named_location_blue_island')},
	{'blueledge',			ResolveString('named_location_blue_ledge')},
	{'generic',				ResolveString('named_location_blue_lift')},
	{'generic',				ResolveString('named_location_blue_lookout')},
	{'bluenest',			ResolveString('named_location_blue_nest')},
	{'generic',				ResolveString('named_location_blue_nook')},
	{'blueone',				ResolveString('named_location_blue_one')},
	{'blueoutside',			ResolveString('named_location_blue_outside')},
	{'generic',				ResolveString('named_location_blue_perch')},
	{'generic',				ResolveString('named_location_blue_pillar')},
	{'blueplatform',		ResolveString('named_location_blue_platform')},
	{'generic',				ResolveString('named_location_blue_porch')},
	{'generic',				ResolveString('named_location_blue_pyramid')},
	{'blueramp',			ResolveString('named_location_blue_ramp')},
	{'generic',				ResolveString('named_location_blue_rampart')},
	{'generic',				ResolveString('named_location_blue_room')},
	{'blueslide',			ResolveString('named_location_blue_slide')},
	{'generic',				ResolveString('named_location_blue_sneaky')},
	{'generic',				ResolveString('named_location_blue_spawn')},
	{'bluestreet',			ResolveString('named_location_blue_street')},
	{'bluestreet',			ResolveString('named_location_blue_streets')},
	{'bluetower',			ResolveString('named_location_blue_tower')},
	{'generic',				ResolveString('named_location_blue_treehouse')},
	{'bluetrench',			ResolveString('named_location_blue_trench')},
	{'generic',				ResolveString('named_location_blue_tunnel')},
	{'bluetwo',				ResolveString('named_location_blue_two')},
	{'generic',				ResolveString('named_location_blue_vat')},
	{'generic',				ResolveString('named_location_blue_window')},
	{'generic',				ResolveString('named_location_blue_wing')},
	{'blueyard',			ResolveString('named_location_blue_yard')},
	{'generic',				ResolveString('named_location_bog')},
	{'bottombase',			ResolveString('named_location_bottom_base')},
	{'generic',				ResolveString('named_location_blue_bottom')},
	{'bottommid',			ResolveString('named_location_bottom_mid')},
	{'brbase',				ResolveString('named_location_br_base')},
	{'generic',				ResolveString('named_location_bottom_nest')},
	{'generic',				ResolveString('named_location_red_bottom')},
	{'bravo',				ResolveString('named_location_bravo')},
	{'bridge',				ResolveString('named_location_bridge')},
	{'generic',				ResolveString('named_location_bridge_wing')},
	{'bunker',				ResolveString('named_location_bunker')},
	{'cafe',				ResolveString('named_location_cafe')},
	{'camobase',			ResolveString('named_location_camo_base')},
	{'generic',				ResolveString('named_location_cafe_ramp')},
	{'generic',				ResolveString('named_location_cafe_sneaky')},
	{'generic',				ResolveString('named_location_cafe_window')},
	{'generic',				ResolveString('named_location_cage')},
	{'generic',				ResolveString('named_location_carbine_one')},
	{'generic',				ResolveString('named_location_carbine_two')},
	{'carbine',				ResolveString('named_location_carbine')},
	{'carbinebase',			ResolveString('named_location_carbine_base')},
	{'casterbase',			ResolveString('named_location_caster_base')},
	{'generic',				ResolveString('named_location_cargo')},
	{'catwalk',				ResolveString('named_location_catwalk')},
	{'cave',				ResolveString('named_location_cave')},
	{'charlie',				ResolveString('named_location_charlie')},
	{'generic',				ResolveString('named_location_cinema')},
	{'generic',				ResolveString('named_location_cinema_loft')},
	{'generic',				ResolveString('named_location_cinema_platform')},
	{'generic',				ResolveString('named_location_cinema_stairs')},
	{'generic',				ResolveString('named_location_control')},
	{'generic',				ResolveString('named_location_courtyard')},
	{'generic',				ResolveString('named_location_cove')},
	{'generic',				ResolveString('named_location_crack')},
	{'generic',				ResolveString('named_location_crossroads')},
	{'generic',				ResolveString('named_location_deck')},
	{'delta',				ResolveString('named_location_delta')},
	{'generic',				ResolveString('named_location_depot')},
	{'dock',				ResolveString('named_location_dock')},
	{'generic',				ResolveString('named_location_docking')},
	{'generic',				ResolveString('named_location_docking_stairs')},
	{'drill',				ResolveString('named_location_drill')},
	{'generic',				ResolveString('named_location_drill_platform')},
	{'generic',				ResolveString('named_location_eastgate')},
	{'echo',				ResolveString('named_location_echo')},
	{'generic',				ResolveString('named_location_elevator')},
	{'generic',				ResolveString('named_location_engine_one')},
	{'generic',				ResolveString('named_location_engine_two')},
	{'generic',				ResolveString('named_location_flank_steak')},
	{'generic',				ResolveString('named_location_flowers')},
	{'foxtrot',				ResolveString('named_location_foxtrot')},
	{'generic',				ResolveString('named_location_fridge')},
	{'generic',				ResolveString('named_location_fridge_ramp')},
	{'generic',				ResolveString('named_location_fridge_steps')},
	{'garbagetruck',		ResolveString('named_location_garbage_truck')},
	{'generic',				ResolveString('named_location_garden')},
	{'golf',				ResolveString('named_location_golf')},
	{'generic',				ResolveString('named_location_green_soda')},
	{'greentower',			ResolveString('named_location_green_tower')},
	{'highcatwalk',			ResolveString('named_location_gulch')},
	{'hill',				ResolveString('named_location_hatch')},
	{'highcatwalk',			ResolveString('named_location_high_catwalk')},
	{'hill',				ResolveString('named_location_hill')},
	{'hill',				ResolveString('named_location_hill_')},
	{'hotel',				ResolveString('named_location_hotel')},
	{'generic',				ResolveString('named_location_hotel_platform')},
	{'generic',				ResolveString('named_location_house')},
	{'india',				ResolveString('named_location_india')},
	{'juliet',				ResolveString('named_location_juliet')},
	{'junction',			ResolveString('named_location_junction')},
	{'lift',				ResolveString('named_location_lift')},
	{'generic',				ResolveString('named_location_load_zone')},
	{'longhall',			ResolveString('named_location_long_hall')},
	{'generic',				ResolveString('named_location_long_stairs')},
	{'generic',				ResolveString('named_location_lookout')},
	{'lowcatwalk',			ResolveString('named_location_low_catwalk')},
	{'generic',				ResolveString('named_location_lower_courtyard')},
	{'generic',				ResolveString('named_location_lower_shelter')},
	{'mid',					ResolveString('named_location_mid')},
	{'generic',				ResolveString('named_location_mid_lift')},
	{'generic',				ResolveString('named_location_mid_platform')},
	{'generic',				ResolveString('named_location_mid_room')},
	{'generic',				ResolveString('named_location_mid_yard')},
	{'generic',				ResolveString('named_location_monolith')},
	{'nest',				ResolveString('named_location_nest')},
	{'osbase',				ResolveString('named_location_os_base')},
	{'generic',				ResolveString('named_location_open_deck')},
	{'generic',				ResolveString('named_location_orange_bridge')},
	{'generic',				ResolveString('named_location_orange_hall')},
	{'generic',				ResolveString('named_location_orange_platform')},
	{'generic',				ResolveString('named_location_orange_ramp')},
	{'generic',				ResolveString('named_location_orange_room')},
	{'generic',				ResolveString('named_location_oscar_house')},
	{'generic',				ResolveString('named_location_outlook')},
	{'generic',				ResolveString('named_location_outpost')},
	{'outside',				ResolveString('named_location_outside')},
	{'generic',				ResolveString('named_location_oven')},
	{'generic',				ResolveString('named_location_oven_ramp')},
	{'generic',				ResolveString('named_location_oven_steps')},
	{'overhang',			ResolveString('named_location_overhang')},
	{'generic',				ResolveString('named_location_overlook')},
	{'generic',				ResolveString('named_location_overpass')},
	{'generic',				ResolveString('named_location_overwatch')},
	{'park',				ResolveString('named_location_park')},
	{'generic',				ResolveString('named_location_perch')},
	{'generic',				ResolveString('named_location_pillar')},
	{'pink',				ResolveString('named_location_pink')},
	{'generic',				ResolveString('named_location_pink_one')},
	{'generic',				ResolveString('named_location_pink_three')},
	{'generic',				ResolveString('named_location_pink_tower')},
	{'generic',				ResolveString('named_location_pink_tower_one')},
	{'generic',				ResolveString('named_location_pink_tower_three')},
	{'generic',				ResolveString('named_location_pink_tower_two')},
	{'generic',				ResolveString('named_location_pink_two')},
	{'generic',				ResolveString('named_location_pipes')},
	{'generic',				ResolveString('named_location_piston')},
	{'pit',					ResolveString('named_location_pit')},
	{'generic',				ResolveString('named_location_pit_door')},
	{'plasmabase',			ResolveString('named_location_plasma_base')},
	{'platform',			ResolveString('named_location_platform')},
	{'generic',				ResolveString('named_location_plaza')},
	{'powerupbase',			ResolveString('named_location_powerup_base')},
	{'generic',				ResolveString('named_location_plaza_loop')},
	{'generic',				ResolveString('named_location_plaza_sneaky')},
	{'ramp',				ResolveString('named_location_ramp')},
	{'generic',				ResolveString('named_location_red_alley')},
	{'generic',				ResolveString('named_location_red_back_alley')},
	{'redbase',				ResolveString('named_location_red_base')},
	{'redbasement',			ResolveString('named_location_red_basement')},
	{'redbend',				ResolveString('named_location_red_bend')},
	{'redbridge',			ResolveString('named_location_red_bridge')},
	{'redcatwalk',			ResolveString('named_location_red_catwalk')},
	{'generic',				ResolveString('named_location_red_cave')},
	{'generic',				ResolveString('named_location_red_closet')},
	{'generic',				ResolveString('named_location_red_cross')},
	{'generic',				ResolveString('named_location_red_deck')},
	{'generic',				ResolveString('named_location_red_door')},
	{'generic',				ResolveString('named_location_red_elbow')},
	{'generic',				ResolveString('named_location_red_island')},
	{'redledge',			ResolveString('named_location_red_ledge')},
	{'generic',				ResolveString('named_location_red_lift')},
	{'generic',				ResolveString('named_location_red_lookout')},
	{'rednest',				ResolveString('named_location_red_nest')},
	{'generic',				ResolveString('named_location_red_nook')},
	{'redone',				ResolveString('named_location_red_one')},
	{'redoutside',			ResolveString('named_location_red_outside')},
	{'generic',				ResolveString('named_location_red_pillar')},
	{'redplatform',			ResolveString('named_location_red_platform')},
	{'generic',				ResolveString('named_location_red_porch')},
	{'generic',				ResolveString('named_location_red_pyramid')},
	{'redramp',				ResolveString('named_location_red_ramp')},
	{'generic',				ResolveString('named_location_red_rampart')},
	{'generic',				ResolveString('named_location_red_room')},
	{'redslide',			ResolveString('named_location_red_slide')},
	{'generic',				ResolveString('named_location_red_sneaky')},
	{'generic',				ResolveString('named_location_red_spawn')},
	{'redstreet',			ResolveString('named_location_red_street')},
	{'redstreet',			ResolveString('named_location_red_streets')},
	{'redtower',			ResolveString('named_location_red_tower')},
	{'generic',				ResolveString('named_location_red_treehouse')},
	{'redtrench',			ResolveString('named_location_red_trench')},
	{'generic',				ResolveString('named_location_red_tunnel')},
	{'redtwo',				ResolveString('named_location_red_two')},
	{'generic',				ResolveString('named_location_red_vat')},
	{'generic',				ResolveString('named_location_red_window')},
	{'generic',				ResolveString('named_location_red_wing')},
	{'redyard',				ResolveString('named_location_red_yard')},
	{'river',				ResolveString('named_location_river')},
	{'river',				ResolveString('named_location_river_')},
	{'rocketbase',			ResolveString('named_location_rocket_base')},
	{'generic',				ResolveString('named_location_rock')},
	{'rocks',				ResolveString('named_location_rocks')},
	{'scattershotbase',		ResolveString('named_location_scattershot_base')},
	{'security',			ResolveString('named_location_security')},
	{'shotgunbase',			ResolveString('named_location_shotgun_base')},
	{'generic',				ResolveString('named_location_shelter')},
	{'generic',				ResolveString('named_location_side_ramp')},
	{'slide',				ResolveString('named_location_slide')},
	{'sniperbase',			ResolveString('named_location_sniper_base')},
	{'generic',				ResolveString('named_location_small_rock')},
	{'generic',				ResolveString('named_location_small_rocks')},
	{'generic',				ResolveString('named_location_sneaky_path')},
	{'generic',				ResolveString('named_location_stage')},
	{'generic',				ResolveString('named_location_stair_top')},
	{'generic',				ResolveString('named_location_station')},
	{'street',				ResolveString('named_location_street')},
	{'swordbase',			ResolveString('named_location_sword_base')},
	{'generic',				ResolveString('named_location_taxi')},
	{'generic',				ResolveString('named_location_terminal')},
	{'topbase',				ResolveString('named_location_top_base')},
	{'generic',				ResolveString('named_location_top_catwalk')},
	{'topmid',				ResolveString('named_location_top_mid')},
	{'generic',				ResolveString('named_location_top_nest')},
	{'tower',				ResolveString('named_location_tower')},
	{'towerone',			ResolveString('named_location_tower_one')},
	{'generic',				ResolveString('named_location_tower_stairs')},
	{'towerthree',			ResolveString('named_location_tower_three')},
	{'towertwo',			ResolveString('named_location_tower_two')},
	{'generic',				ResolveString('named_location_tower_wall')},
	{'generic',				ResolveString('named_location_tram')},
	{'generic',				ResolveString('named_location_tram_sneaky')},
	{'generic',				ResolveString('named_location_tram_street')},
	{'generic',				ResolveString('named_location_treehouse')},
	{'trench',				ResolveString('named_location_trench')},
	{'generic',				ResolveString('named_location_truck')},
	{'generic',				ResolveString('named_location_tunnel')},
	{'turbine',				ResolveString('named_location_turbine')},
	{'generic',				ResolveString('named_location_underbridge')},
	{'generic',				ResolveString('named_location_underpass')},
	{'generic',				ResolveString('named_location_upper_courtyard')},
	{'generic',				ResolveString('named_location_upper_shelter')},
	{'generic',				ResolveString('named_location_weapon_platform')},
	{'generic',				ResolveString('named_location_west_ramp')},
	{'yard',				ResolveString('named_location_yard')},
	{'generic',				ResolveString('named_location_yellow_corner')},
	{'generic',				ResolveString('named_location_yellow_pipes')},
	{'yellowtower',			ResolveString('named_location_yellow_tower')},
};
modeIntroResponse = onModeIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_strongholds'
	});
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
		Sound = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecaptureinitiated', 
		Sound2 = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecapturestartloop'
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
CapturerMusicResponse = onStrongholdCapture:Target(CapturingPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_strongholds\music_mp_strongholds_basecaptured_player', 
		Sound2 = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecapturestoploop'
	});
DominationStopMusicResponse = onStrongholdCapture:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_strongholds\music_mp_strongholds_domination_loop_stop'
	});
strongholdCapturedMedalResponse = onStrongholdCapture:Target(CapturingPlayers):Response(
	{
		Medal = 'strong_capture',
		Sound = 'multiplayer\audio\announcer\announcer_stronghold_strongholdcaptured'
	}):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_strongholds_basecapturecompleted'
	});
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
captureAssistResponse = onStrongholdCapture:Target(AssistingPlayers):Response(
	{
		Medal = 'strong_capture_assist',
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_strongholds\music_mp_strongholds_basecaptured_player'
	});
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
__OnEnemyCaptureProgressErased = Delegate:new();
onStrongholdSecured = root:AddCallback(
	__OnEnemyCaptureProgressErased,
	function(context, players, zone)
		context.CapturingPlayers = players;
		context.Zone = zone;
	end
	); 
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
onStrongholdDefense = onEnemyPlayerKill:Filter(
	function(context)
		return context.DeadPlayer:InHostileStronghold()
	end
	):Target(KillingPlayer):Response(
	{
		Medal = 'strong_defense'
	});