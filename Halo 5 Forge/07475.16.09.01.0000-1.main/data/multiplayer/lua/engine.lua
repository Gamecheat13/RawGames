--
-- Engine event callbacks
--

__OnUpdate = Delegate:new();

__OnPlayerAdded = Delegate:new();
__OnPlayerDeleted = Delegate:new();

__OnPlayerLeft = Delegate:new();
__OnPlayerRejoined = Delegate:new();

__OnPlayerActivated = Delegate:new();

__OnPlayerSpawn = Delegate:new();
__OnRespawnTick = Delegate:new();

__OnRoundStart = Delegate:new();
__OnRoundEnd = Delegate:new();

__OnMatchEnd = Delegate:new();

__OnKill = Delegate:new();

--use the assisting players that are passed through the kill event for assist events
__OnAssist = Delegate:new();

__OnEngineClientEvent = Delegate:new();

__OnPlayerGrenadeThrown = Delegate:new();
__OnUnitRevivedUnit = Delegate:new();
__OnPlayerPickedUpWeapon = Delegate:new();
__OnPlayerDroppedWeapon = Delegate:new();
__OnPlayerDetachedWeaponFromDispenserWithDamage = Delegate:new();
__OnPlayerPickedUpWeaponFromWeaponPad = Delegate:new();

__OnPlayerOutOfAmmo = Delegate:new();
__OnPlayerTookAmmo = Delegate:new();

__OnPlayerRegeneratedShields = Delegate:new();
__OnPlayerStartingShieldRegeneration = Delegate:new();

__OnPlayerFinishedRunningStart = Delegate:new();

__OnVehicleJacked = Delegate:new();
__OnPlayerBoardedVehicle = Delegate:new();
__OnVehicleLandedOnGround = Delegate:new();

__OnWeaponPadSlotStateChanged = Delegate:new();

--
-- Combat heartbeats
--

__OnPlayerEnterCombat = Delegate:new();
__OnPlayerExitCombat = Delegate:new();

__OnGameLoadedCheckpoint = Delegate:new();
