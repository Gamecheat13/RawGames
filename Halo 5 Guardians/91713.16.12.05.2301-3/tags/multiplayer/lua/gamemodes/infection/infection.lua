function SurvivingHumans(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return player:IsHuman();
		end
	);
end
function InfectedPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return player:IsInfected();
		end
		);
end
function OtherInfectedPlayers(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return player:IsInfected()
			and context.KillingPlayer ~= player
			and context.DeadPlayer ~= player
		end
		);
end
function OtherSurvivors(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return player:IsHuman()
			and context.KillingPlayer ~= player
			and context.DeadPlayer ~= player
		end
		);
end
infectionIntroResponse = onModeIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_intro'	
	});
__OnPlayerInfected = Delegate:new();
onPlayerInfected = root:AddCallback(
	__OnPlayerInfected,
	function(context, players)
		context.MatchingPlayers = players;
	end
	);
playerInfectedResponse = onPlayerInfected:Target(MatchingPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_infection_infected_loop', 
		Sound2 = 'multiplayer\audio\announcersustain\announcersustain_infection_infected',
	});
__OnLastManStanding = Delegate:new();
onLastManStanding = root:AddCallback(
	__OnLastManStanding,
	function(context, players)
		context.MatchingPlayers = players;
	end
	);
lastManStandingResponse = onLastManStanding:Target(MatchingPlayers):Response(
	{
		Medal = 'infection_last_man_standing',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_lastmanstanding'
	});
lastManStandingMusicResponse = onLastManStanding:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_infection_lastmanstanding_loop'
	});
lastSpartanStandingResponse = onLastManStanding:Target(InfectedPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_lastspartanstanding'
	});
onSurvivorsWinResponse = onRoundEnd:Target(SurvivingHumans):Response(
	{
		Medal = 'infection_survived',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_survived'
	});
onNonLastRoundEnd = onRoundEnd:Filter(
	function(context)
		return (context.Engine:GetRound() + 1) < context.Engine:GetRoundLimit();
	end
	);
onInfectionRoundEndResponse = onNonLastRoundEnd:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_infection_roundover_neutral',
	});
nonLastRoundEndSelect = onNonLastRoundEnd:Select();
onRoundEndSurvivorsEliminated = nonLastRoundEndSelect:Add(
	function(context)
		return GetRemainingSurvivorCount(context) == 0;
	end
	);
onRoundEndSurvivorsEliminatedResponse = onRoundEndSurvivorsEliminated:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_zombieswin'
	});
onRoundEndSurvivorsSurvived = nonLastRoundEndSelect:Add(
	function(context)
		return GetRemainingSurvivorCount(context) > 0;
	end
	);
onRoundEndSurvivorsResponse = onRoundEndSurvivorsSurvived:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_survivorswin'
	});
function AncientOnePlayers(context)
	return context.AncientOnePlayers;
end
totalDeathsAccumulator = root:CreatePlayerAccumulator();
onRoundStart:ResetPlayerAccumulator(
	totalDeathsAccumulator,
	function (context)
		return context:GetAllPlayers();
	end
	);
onPlayerDeathAccumulator = onPlayerDeath:PlayerAccumulator(
	totalDeathsAccumulator,
	function (context)
		return context.DeadPlayer;
	end
	);
onAncientOne = onRoundEnd:Emit(
	function(context)
		context.AncientOnePlayers = table.filter(context:GetAllPlayers(),
			function(player)
				return player:IsInfectedAlpha() 
				and totalDeathsAccumulator:GetValue(player) == 0 
				and survivorKillsSinceDeathAccumulator:GetValue(player) > 0;
			end
			);
	end
	);
ancientOneResponse = onAncientOne:Target(AncientOnePlayers):Response(
	{
		Medal = 'infection_ancient_one',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_ancientone',
	});
__OnHumanSurvivedForOneSecond = Delegate:new();
onHumanSurvivedForOneSecond = root:AddCallback(
	__OnHumanSurvivedForOneSecond,
	function (context, targetPlayer)
		context.TargetPlayer = targetPlayer;
	end
	);
onHumanSurvivedForOneSecondImpulse = onHumanSurvivedForOneSecond:Target(TargetPlayer):Response(
	{
		ImpulseEvent = 'human_survived_for_one_second'
	});
__OnSurvivalKill = Delegate:new();
onSurvivalKill = root:AddCallback(
	__OnSurvivalKill,
	function (context, targetPlayer)
		context.TargetPlayer = targetPlayer;
	end
	);
onSurvivalKillImpulse = onSurvivalKill:Target(TargetPlayer):Response(
	{
		ImpulseEvent = 'infection_survival_kill'
	});
__OnKillAsLastManStanding = Delegate:new();
onKillAsLastManStanding = root:AddCallback(
	__OnKillAsLastManStanding,
	function (context, targetPlayer)
		context.TargetPlayer = targetPlayer;
	end
	);
onKillAsLastManStandingImpulse = onKillAsLastManStanding:Target(TargetPlayer):Response(
	{
		ImpulseEvent = 'infection_last_man_standing_kill'
	});
__OnInfectionKill = Delegate:new();
onInfectionKill = root:AddCallback(
	__OnInfectionKill,
	function (context, targetPlayer)
		context.TargetPlayer = targetPlayer;
	end
	);
onInfectionKillImpulse = onInfectionKill:Target(TargetPlayer):Response(
	{
		ImpulseEvent = 'infection_conversion_kill'
	});
__OnKillAsAlpha = Delegate:new();
onKillAsAlpha = root:AddCallback(
	__OnKillAsAlpha,
	function (context, targetPlayer)
		context.TargetPlayer = targetPlayer;
	end
	);
onKillAsAlphaImpulse = onKillAsAlpha:Target(TargetPlayer):Response(
	{
		ImpulseEvent = 'infection_kill_as_alpha'
	});
infectedKill = onEnemyPlayerKill:Filter(
	function(context)
		return context.KillingPlayer:IsInfected() and context.DeadPlayer:IsHuman();
	end
	);
infectedKillSelect = infectedKill:Select();
onLastManKilled = infectedKillSelect:Add(
	function(context)
		return context.KillingPlayer:IsInfected() and context.DeadPlayer:IsHuman() and context.DeadPlayer:IsLastManStanding();
	end
	);
onInfectedKilledSurvivor = infectedKillSelect:Add();
infectedKilledSurvivorInfectedResponse = infectedKill:Target(OtherInfectedPlayers):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_infection_floodexpand'
	});
infectedKilledSurvivorSurvivorResponse = infectedKill:Target(OtherSurvivors):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_infection_spartandie'
	});
lastManKilledResponse = onLastManKilled:Target(KillingPlayer):Response(
	{
		Medal = 'infection_last_man_killed',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_flatline'
	});
infectedKilledSurvivorResponse = onInfectedKilledSurvivor:Target(KillingPlayer):Response(
	{	
		Medal = 'infection_conversion',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_conversion'
	});
survivorCountSelect = infectedKill:Select();
function GetRemainingSurvivorCount(context)
	local allPlayers = context:GetAllPlayers();
	local humanCount = 0;
	for i=1, #allPlayers do
		if allPlayers[i]:IsHuman() then
			humanCount = humanCount + 1;
		end
	end
	return humanCount;
end
onThreeSurvivorsRemain = survivorCountSelect:Add(
	function(context)
		return GetRemainingSurvivorCount(context) == 4; -- n+1 since the recently killed is still considered human
	end
	);
onTwoSurvivorsRemain = survivorCountSelect:Add(
	function(context)
		return GetRemainingSurvivorCount(context) == 3; -- n+1 since the recently killed is still considered human
	end
	);
threeSurvivorsRemainResponse = onThreeSurvivorsRemain:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_threesurvivors'
	});
twoSurvivorsRemainResponse = onTwoSurvivorsRemain:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_twosurvivors'
	});
onSurvivorKilledInfected = onEnemyPlayerKill:Filter(
	function(context)
		return context.KillingPlayer:IsHuman() and context.DeadPlayer:IsInfected();
	end
	);
onResourcefulKill = onSurvivorKilledInfected:Filter(
	function(context)
		local killingPlayerUnit = context.KillingPlayer:GetUnit();
		if killingPlayerUnit == nil then
			return false;
		end
		if killingPlayerUnit:HasAnyGrenadesRemaining() then
			return false;
		end
		local killingPlayerPrimaryWeapon = killingPlayerUnit:GetPrimaryWeapon();
		local killingPlayerSecondaryWeapon = killingPlayerUnit:GetBackpackWeapon();
		if killingPlayerPrimaryWeapon ~= nil and not killingPlayerPrimaryWeapon:GetWeaponIsOutOfAmmo() then
			return false;
		end
		if killingPlayerSecondaryWeapon ~= nil and not killingPlayerSecondaryWeapon:GetWeaponIsOutOfAmmo() then
			return false;
		end
		return true;
	end
	);
onResourcefulKillResponse = onResourcefulKill:Target(KillingPlayer):Response(
	{
		Medal = 'infection_resourceful',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_resourceful'
	});
onStalkerKillResponse = onStalkerKill:Target(KillingPlayer):Response(
	{
		Medal = 'infection_stalker',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_stalker'
	});
zombieKillsSinceDeathAccumulator = root:CreatePlayerAccumulator();
onZombieKillsSinceDeath = onSurvivorKilledInfected:PlayerAccumulator(
	zombieKillsSinceDeathAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);
onPlayerDeath:ResetPlayerAccumulator(
	zombieKillsSinceDeathAccumulator,
	function (context)
		return context.DeadPlayer;
	end
	);
onFiveZombieKillsSinceDeath = onZombieKillsSinceDeath:Filter(
	function (context)
		return zombieKillsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 5;
	end
	);
onTenZombieKillsSinceDeath = onZombieKillsSinceDeath:Filter(
	function (context)
		return zombieKillsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 10;
	end
	);
onFifteenZombieKillsSinceDeath = onZombieKillsSinceDeath:Filter(
	function (context)
		return zombieKillsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 15;
	end
	);
onTwentyZombieKillsSinceDeath = onZombieKillsSinceDeath:Filter(
	function (context)
		return zombieKillsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 20;
	end
	);
onTwentyFiveZombieKillsSinceDeath = onZombieKillsSinceDeath:Filter(
	function (context)
		return zombieKillsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 25;
	end
	);
onThirtyZombieKillsSinceDeath = onZombieKillsSinceDeath:Filter(
	function (context)
		return zombieKillsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 30;
	end
	);
zombieHunterResponse = onFiveZombieKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'infection_zombie_hunter',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_zombiehunter'
	});
zombieSlayerResponse = onTenZombieKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'infection_zombie_slayer',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_zombieslayer'
	});
hellsJanitorResponse = onFifteenZombieKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'infection_hells_janitor',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_hellsjanitor'
	});
hellJumperResponse = onTwentyZombieKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'infection_helljumper',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_helljumper'
	});
zombicideResponse = onTwentyFiveZombieKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'infection_zombicide',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_zombicide'
	});
theCureResponse = onThirtyZombieKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'infection_the_cure',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_thecure'
	});
survivorKillsSinceDeathAccumulator = root:CreatePlayerAccumulator();
onSurvivorKillsSinceDeath = infectedKill:PlayerAccumulator(
	survivorKillsSinceDeathAccumulator,
	function (context)
		return context.KillingPlayer;
	end
	);
onPlayerDeath:ResetPlayerAccumulator(
	survivorKillsSinceDeathAccumulator,
	 function (context)
		return context.DeadPlayer;
	 end
	 );
onTwoSurvivorKillsSinceDeath = onSurvivorKillsSinceDeath:Filter(
	function (context)
		return survivorKillsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 2;
	end
	);
onThreeSurvivorKillsSinceDeath = onSurvivorKillsSinceDeath:Filter(
	function (context)
		return survivorKillsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 3;
	end
	);
onFourSurvivorKillsSinceDeath = onSurvivorKillsSinceDeath:Filter(
	function (context)
		return survivorKillsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 4;
	end
	);
onFiveSurvivorKillsSinceDeath = onSurvivorKillsSinceDeath:Filter(
	function (context)
		return survivorKillsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 5;
	end
	);
onSixSurvivorKillsSinceDeath = onSurvivorKillsSinceDeath:Filter(
	function (context)
		return survivorKillsSinceDeathAccumulator:GetValue(context.KillingPlayer) == 6;
	end
	);
infectorResponse = onTwoSurvivorKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'infection_infector',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_infector'
	});
carrierResponse = onThreeSurvivorKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'infection_carrier',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_carrier'
	});
ravagerResponse = onFourSurvivorKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'infection_ravager',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_ravager'
	});
plagueBearerResponse = onFiveSurvivorKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'infection_plague_bearer',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_plaguebearer'
	});
lordOfTheFliesResponse = onSixSurvivorKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'infection_lord_of_the_flies',
		Sound = 'multiplayer\audio\announcersustain\announcersustain_infection_lordoftheflies'
	});
playerDesignatorTable = { };
onPlayerSpawn:Filter(
	function(context)
		local spawnedPlayerPreviousDesignator = playerDesignatorTable[context.TargetPlayer];
		playerDesignatorTable[context.TargetPlayer] = context.TargetPlayer:GetTeamDesignator();
		return spawnedPlayerPreviousDesignator ~= playerDesignatorTable[context.TargetPlayer] and context.TargetPlayer:IsInfected();
	end
	):Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_infection_playerspawn'
	});
onRoundStart:Emit(
	function(context)
		playerDesignatorTable = { };
	end
	);
