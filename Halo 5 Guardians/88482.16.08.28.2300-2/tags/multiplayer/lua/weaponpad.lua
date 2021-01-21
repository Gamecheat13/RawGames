
eventToActivate = nil;
activeEvent = nil;
local eventObjectNameIndex = 1;
local eventTimeIndex = 2;
local eventSlotStateIndex = 3;
local weaponPadEventConsiderationTime = 0.1;
onWeaponPadSlotStateChanged = root:AddCallback(
	__OnWeaponPadSlotStateChanged,
	function (context, dispenserObject,  slotState, timeRemainingSeconds, object)
		context.DispenserObject = dispenserObject;
		context.SlotState = slotState;
		context.TimeRemaining = timeRemainingSeconds;
		context.Object = object;
		context.TimeOfEvent = GetGameTime();
	end
	);
function UpdateWeaponPadEventTable(context)
	if context.SlotState ~= ObjectDispenserSlotState.Constructing and context.SlotState ~= ObjectDispenserSlotState.Ready then
		return;
	end
	local newWeaponPadEventData = { context.Object:GetName(), context.TimeOfEvent, context.SlotState };
	if eventToActivate == nil then
		eventToActivate = newWeaponPadEventData;
		return;
	else
		eventToActivate[eventObjectNameIndex] = GenericObjectName;
		if newWeaponPadEventData[eventSlotStateIndex] == ObjectDispenserSlotState.Constructing then
			eventToActivate[eventSlotStateIndex] = ObjectDispenserSlotState.Constructing;
		end
	end
end
function CheckForWeaponPadEvents(context)
	if eventToActivate == nil then
		return false;
	end
	if GetGameTime() - eventToActivate[eventTimeIndex] > weaponPadEventConsiderationTime then
		activeEvent = eventToActivate;
		eventToActivate = nil;
		return true;
	end
end
onEventTableUpdated = onWeaponPadSlotStateChanged:Emit(UpdateWeaponPadEventTable)
activateWeaponEvent = onUpdate:Filter(CheckForWeaponPadEvents);
weaponPadEventTypeSelect = activateWeaponEvent:Select();
weaponPadConstructing = weaponPadEventTypeSelect:Add(	
	function (context)
		return activeEvent[eventSlotStateIndex] == ObjectDispenserSlotState.Constructing;
	end
	);
weaponPadConstructingSelect = weaponPadConstructing:Select();
weaponPadReady = weaponPadEventTypeSelect:Add(
	function (context)
		return activeEvent[eventSlotStateIndex] == ObjectDispenserSlotState.Ready and GetGameTime() > 1;
	end
	);
weaponPadReadySelect = weaponPadReady:Select();
function GenerateResponses( weaponPadSelect, BuildResponseFunction)
	for index, object in ipairs(WeaponPadObjectNames) do
		local objectStringIdName = object[WeaponPadObjectName_objectNameIndex];
		local sourceEvent = weaponPadSelect:Add(
			function (context)
				return activeEvent[eventObjectNameIndex] == objectStringIdName;
			end
		);
		BuildResponseFunction(object[WeaponPadObjectName_stringIndex], sourceEvent);
	end
end
function GetNextNameMaybeWithExtraNumberThatIsntInTable(name, table)
    if table[name] == nil then
        return name
    end
    for i = 1, 99 do
        local newName = name .. '_' .. tostring(i);
        if table[newName] == nil then
            return newName
        end
    end
    return name
end
function BuildWeaponPadConstructingResponses(name, source)
	local globals = _G;
	local globalsKey = GetNextNameMaybeWithExtraNumberThatIsntInTable(name .. "ConstructingResponse", globals);
	globals[globalsKey] = source:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'weapon_pad_' .. name .. '_constructing',
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_shared_weaponpad10swarning' ..name
	});
end
GenerateResponses(weaponPadConstructingSelect, BuildWeaponPadConstructingResponses);
function BuildWeaponReadyResponses(name, source)
	local globals = _G;
	local globalsKey = GetNextNameMaybeWithExtraNumberThatIsntInTable(name .. "ReadyResponse", globals);
	globals[globalsKey] = source:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'weapon_pad_' .. name .. '_ready',
		Sound = 'multiplayer\audio\teamleadermale01\teamleadermale01_shared_weaponpadready' ..name
	});
end
GenerateResponses(weaponPadReadySelect, BuildWeaponReadyResponses);
onObjectTaken = root:AddCallback(
	__OnPlayerPickedUpWeaponFromWeaponPad,
	function (context, player, object)
		context.TargetPlayer = player;
		context.Object = object;
	end
	);
playerDetachedObjectTable = {};
onObjectDetachedWithDamage = root:AddCallback(
	__OnPlayerDetachedWeaponFromDispenserWithDamage,
	function(context, player, object)
		context.TargetPlayer = player;
		context.Object = object;
		local eventData = {object, player, GetGameTime()};
		table.insert(playerDetachedObjectTable, eventData);
	end
	);
onPlayerPickedUpObject = root:AddCallback(
	__OnPlayerPickedUpWeapon,
	function(context, player, object)
		context.TargetPlayer = player;
		context.Object = object;
	end
	);
onPlayerPickedUpAmmo = root:AddCallback(
	__OnPlayerTookAmmo,
	function(context, player, object)
		context.TargetPlayer = player;
		context.Object = object;
	end
	);
local weaponBlastData_objectIndex = 1;
local weaponBlastData_playerIndex = 2;
local weaponBlastData_timeIndex = 3;
function PlayerBlastedWeapon(context)
	if context.PickedUpWeaponData ~= nil then
		return context.PickedUpWeaponData[weaponBlastData_playerIndex];
	else
		return nil;
	end
end 
local timeToPickupBlastedObject = 7.0;
function FindPickedUpWeaponData(context)
	local pickedUpWeaponData = nil;
	local pickedUpWeaponKey = nil;
	for key , data in pairs(playerDetachedObjectTable) do
		if data[weaponBlastData_objectIndex] == context.Object and GetGameTime() - data[weaponBlastData_timeIndex] < timeToPickupBlastedObject then
			pickedUpWeaponKey = key;
			pickedUpWeaponData = data;
		end
	end
	if pickedUpWeaponKey ~= nil then
		table.remove(playerDetachedObjectTable, pickedUpWeaponKey);
	end
	context.PickedUpWeaponData = pickedUpWeaponData;
end
function IsCombatEvolved(context)
	if context.PickedUpWeaponData == nil then
		return false;
	end
	if context.PickedUpWeaponData[weaponBlastData_playerIndex] == nil or context.PickedUpWeaponData[weaponBlastData_playerIndex]:IsHostile(context.TargetPlayer) then
		return false;
	end
	return true;
end
function IsAlleyOop(context)
	return context.PickedUpWeaponData[weaponBlastData_playerIndex] ~= context.TargetPlayer;
end
onPlayerPickedUpBlastedObject = onPlayerPickedUpObject:Emit(FindPickedUpWeaponData):Filter(IsCombatEvolved);
onFriendlyPlayerPickedUpBlastedObject = onPlayerPickedUpBlastedObject:Filter(IsAlleyOop);
onPlayerPickedUpAmmoFromBlastedObject = onPlayerPickedUpAmmo:Emit(FindPickedUpWeaponData):Filter(IsCombatEvolved);
onFriendlyPlayerPickedUpAmmoFromBlastedObject = onPlayerPickedUpAmmoFromBlastedObject:Filter(IsAlleyOop);
combatEvolvedResponse = onPlayerPickedUpBlastedObject:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_weaponpadcombatevolved',
		Medal = 'combat_evolved'
	});
alleyOopResponse = onFriendlyPlayerPickedUpBlastedObject:Target(PlayerBlastedWeapon):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_weaponpadalleyoop',
		Medal = 'alley_oop'
	});
combatEvolvedAmmoResponse = onPlayerPickedUpAmmoFromBlastedObject:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_weaponpadcombatevolved',
		Medal = 'combat_evolved'
	});
alleyOopAmmoResponse = onFriendlyPlayerPickedUpAmmoFromBlastedObject:Target(PlayerBlastedWeapon):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_weaponpadalleyoop',
		Medal = 'alley_oop'
	});
local bigGunRunnerWeaponsTaken = 3;
bigGunRunnerAccumulator = root:CreatePlayerAccumulator();
onPowerWeaponTaken = onObjectTaken:Filter(
	function(context)
		return table.any(PowerWeaponNames, 
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
		Sound = 'multiplayer\audio\announcer\announcer_slayer_biggunrunner',
		Medal = 'big_gun_runner'
	});
