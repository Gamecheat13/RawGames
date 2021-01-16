local multipleWeaponPadEventSeconds = 3.0;

--
-- Weapon Pad States
--
onWeaponPadSlotStateChanged = root:AddCallback(
	__OnWeaponPadSlotStateChanged,
	function (context, dispenserObject,  slotState, timeRemainingSeconds, object)
		context.DispenserObject = dispenserObject;
		context.SlotState = slotState;
		context.TimeRemaining = timeRemainingSeconds;
		context.Object = object;
	end
	);

--
-- 
--
function GenerateResponses( weaponPadSelect, BuildResponseFunction)
	for index, weapon in ipairs(weaponNames) do
		local weaponStringIdName = weapon[2];

		local sourceEvent = weaponPadSelect:Add(
			function (context)
				return context.Object:GetName() == weaponStringIdName;
			end
		);

		BuildResponseFunction(weapon[1], sourceEvent);
	end
end

--
-- INCOMING
--
onWeaponPadIncoming = onWeaponPadSlotStateChanged:Filter(
	function (context)
		return context.SlotState == ObjectDispenserSlotState.Incoming;
	end
	);
	
weaponPadIncomingSelect = onWeaponPadIncoming:Select();

function BuildWeaponIncomingResponses(name, source)
	local globals = _G;

	globals[name .. "IncomingResponse"] = source:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'weapon_pad_' .. name .. '_incoming',
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_shared_weaponpad30swarning' ..name
	});
end

GenerateResponses(weaponPadIncomingSelect, BuildWeaponIncomingResponses);

-- Multiple Weapons Incoming
weaponPadIncomingAccumulator = root:CreateAccumulator(multipleWeaponPadEventSeconds);

onWeaponPadIncomingInARow = onWeaponPadIncoming:Accumulator(weaponPadIncomingAccumulator);

onRoundStart:ResetAccumulator(weaponPadIncomingAccumulator);

onMultipleWeaponsIncoming = onWeaponPadIncomingInARow:Filter(
	function (context)
		return weaponPadIncomingAccumulator:GetValue() == 2
	end
	);

MultipleWeaponsIncomingResponse = onMultipleWeaponsIncoming:Target(TargetAllPlayers):Response(
{
	Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_slayer_multiweaponpad30swarning'
});
	
--
-- Constructing
--
onWeaponPadConstructing = onWeaponPadSlotStateChanged:Filter(
	function (context)
		return context.SlotState == ObjectDispenserSlotState.Constructing;
	end
	);
	
weaponPadConstructingSelect = onWeaponPadConstructing:Select();

function BuildWeaponConstructingResponses(name, source)
	local globals = _G;

	globals[name .. "ConstructingResponse"] = source:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'weapon_pad_' .. name .. '_constructing',
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_shared_weaponpad10swarning' ..name
	});
end

GenerateResponses(weaponPadConstructingSelect, BuildWeaponConstructingResponses);

-- Multiple Weapons Constructing
weaponPadConstructingAccumulator = root:CreateAccumulator(multipleWeaponPadEventSeconds);

onWeaponPadConstructingInARow = onWeaponPadConstructing:Accumulator(weaponPadConstructingAccumulator);

onRoundStart:ResetAccumulator(weaponPadConstructingAccumulator);

onMultipleWeaponsConstructing = onWeaponPadConstructingInARow:Filter(
	function (context)
		return weaponPadConstructingAccumulator:GetValue() == 2
	end
	);

MultipleWeaponsConstructingResponse = onMultipleWeaponsConstructing:Target(TargetAllPlayers):Response(
{
	Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_slayer_multiweaponpad10swarning'
});

--
-- READY
--
onWeaponPadReady = onWeaponPadSlotStateChanged:Filter(
	function (context)
		return context.SlotState == ObjectDispenserSlotState.Ready and GetGameTime() > 1;
	end
	);
	
weaponPadReadySelect = onWeaponPadReady:Select();

function BuildWeaponReadyResponses(name, source)
	local globals = _G;

	globals[name .. "ReadyResponse"] = source:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'weapon_pad_' .. name .. '_ready',
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_shared_weaponpadready' ..name
	});
end

GenerateResponses(weaponPadReadySelect, BuildWeaponReadyResponses);

-- Multiple Weapons Ready
weaponPadReadyAccumulator = root:CreateAccumulator(multipleWeaponPadEventSeconds);

onWeaponPadReadyInARow = onWeaponPadReady:Accumulator(weaponPadReadyAccumulator);

onRoundStart:ResetAccumulator(weaponPadReadyAccumulator);

onMultipleWeaponsReady = onWeaponPadReadyInARow:Filter(
	function (context)
		return weaponPadReadyAccumulator:GetValue() == 2
	end
	);

MultipleWeaponsReadyResponse = onMultipleWeaponsReady:Target(TargetAllPlayers):Response(
{
	Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_slayer_multiweaponpadready'
});


--
-- TAKEN
--
onWeaponTaken = root:AddCallback(
	__OnPlayerPickedUpWeaponFromWeaponPad,
	function (context, player, object)
		context.TargetPlayer = player;
		context.Object = object;
	end
	);

function BuildWeaponTakenResponses(name, source)
	local globals = _G;

	globals[name .. "TakenTargetResponse"] = source:Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'weapon_pad_' .. name .. '_taking_player',
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_shared_weaponpadpickup' ..name
	});
	
	globals[name .. "TakenFriendlyResponse"] = source:Target(FriendlyToTargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.GameState,
		FanfareText = 'weapon_pad_' .. name .. '_taken',
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_shared_weaponpadpickup' ..name
	});
end

weaponTakenSelect = onWeaponTaken:Select();

GenerateResponses(weaponTakenSelect, BuildWeaponTakenResponses);

--
-- Weapon Detached with damage
--

playerDetachedWeaponTable = {};

onWeaponDetachedWithDamage = root:AddCallback(
	__OnPlayerDetachedWeaponFromDispenserWithDamage,
	function(context, player, object)
		context.TargetPlayer = player;
		context.Object = object;

		local eventData = {object, player, GetGameTime()};
		table.insert(playerDetachedWeaponTable, eventData);
	end
	);

onPlayerPickedUpWeapon = root:AddCallback(
	__OnPlayerPickedUpWeapon,
	function(context, player, object)
		context.TargetPlayer = player;
		context.Object = object;
	end
	);

function BlastedWeaponPickedUpInTime(context, time)

	local blastedWeaponData = nil;
	local blastedWeaponKey = nil;

	for key , data in pairs(playerDetachedWeaponTable) do

		if data[1] == context.Object then
			blastedWeaponKey = key;
			blastedWeaponData = data;
		end

	end

	if blastedWeaponData == nil then
		return nil;
	end

	if GetGameTime() - blastedWeaponData[3] > time then
		table.remove(playerDetachedWeaponTable, blastedWeaponKey);
		return nil;
	end

	return blastedWeaponData;
end

local timeToPickupBlastedWeapon = 8.0;

onSamePlayerPickedUpBlastedWeapon = onPlayerPickedUpWeapon:Filter(
	function(context)

		local blastedWeaponData = BlastedWeaponPickedUpInTime(context, timeToPickupBlastedWeapon);

		if blastedWeaponData == nil then
			return false;
		end

		if blastedWeaponData[2] == nil or blastedWeaponData[2] ~= context.TargetPlayer then
			return false;
		end

		return true;
	end
	);

samePlayerPickedUpBlastedWeaponResponse = onSamePlayerPickedUpBlastedWeapon:Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_combat_evolved',
		Sound = 'multiplayer\audio\announcer\announcer_shared_weaponpadcombatevolved',
		Medal = 'combat_evolved'
	});

onFriendlyPlayerPickedUpBlastedWeapon = onPlayerPickedUpWeapon:Filter(
	function(context)

		local blastedWeaponData = BlastedWeaponPickedUpInTime(context, timeToPickupBlastedWeapon);

		if blastedWeaponData == nil then
			return false;
		end

		if blastedWeaponData[2]:IsHostile(context.TargetPlayer) or blastedWeaponData[2] == context.TargetPlayer then
			return false;
		end

		return true;
	end
	);

onAlleyOop = onFriendlyPlayerPickedUpBlastedWeapon:Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_alley_oop',
		Sound = 'multiplayer\audio\announcer\announcer_shared_weaponpadalleyoop',
		Medal = 'alley_oop'
	});

--
-- Big Gun Runner
--

local bigGunRunnerWeaponsTaken = 5;

bigGunRunnerAccumulator = root:CreatePlayerAccumulator();

onPowerWeaponTaken= onWeaponTaken:Filter(
	function(context)
		return table.any(powerWeaponNames, 
			function(weaponName)
				return context.Object:GetName() == weaponName;
			end
			);
	end
	);

bigGunRunnerCounter = onPowerWeaponTaken:PlayerAccumulator(
	bigGunRunnerAccumulator,
	function(context)
		return context.TargetPlayer;
	end
	);

onBigRunRunner = bigGunRunnerCounter:Filter(
	function(context)
		return bigGunRunnerAccumulator:GetValue(context.TargetPlayer) % bigGunRunnerWeaponsTaken == 0;
	end
	);

bigGunRunnerResponse = onBigRunRunner:Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_big_gun_runner',
		Sound = 'multiplayer\audio\announcer\announcer_slayer_biggunrunner',
		Medal = 'big_gun_runner'
	});
