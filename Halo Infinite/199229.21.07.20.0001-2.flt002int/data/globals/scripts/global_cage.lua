REQUIRES('globals/scripts/callbacks/GlobalCallbacks.lua')

--## SERVER

-- ====================================================================================================== --
-- CAGE INTERFACE SERVER API
-- ====================================================================================================== --
global CageInterface = {
	printDebug = false, -- check-in as false
};

function startup.CageInterfaceStartup():void
	RegisterGlobalEvent(g_eventTypes.roundEndEvent, CageInterface.TearDownOnRoundEnd);
end

function CageInterface.SwitchToCageCamera(player:player):void
	RunClientScript("CageInterface_SwitchToCageCamera", player);
end

function CageInterface.SwitchToGameplayCamera(player:player, blendTime:number):void
	RunClientScript("CageInterface_SwitchToGameplayCamera", player, blendTime);
end

function CageInterface.ResetStack(player:player, blendTime:number):void
	RunClientScript("CageInterface_ResetStack", player, blendTime);
end

function CageInterface.AddPlayerStack(player:player):void
	RunClientScript("CageInterface_AddPlayerStack", player);
end

function CageInterface.RemovePlayerStack(player:player):void
	RunClientScript("CageInterface_RemovePlayerStack", player);
end

function CageInterface.OnAddPlayerEvent(event:PlayerAddedEventStruct):void
	CageInterface.AddPlayerStack(event.player);
end

function CageInterface.OnRemovePlayerEvent(event:PlayerRemovedEventStruct):void
	CageInterface.RemovePlayerStack(event.player);
end

function CageInterface.OnBlendEnter(player:player):void
	RunClientScript("CageInterface_OnBlendEnter", player);
end

function CageInterface.OnBlendExit(player:player):void
	RunClientScript("CageInterface_OnBlendExit", player);
end

function CageInterface.TearDown():void
	RunClientScript("CageInterface_TearDown");
end

-- called on server side will set BOTH client and server
function CageInterface.SetDebugPrint(set:boolean):void
	CageInterface.printDebug = set;
	RunClientScript("CageInterface_SetDebugPrint", set);
end

-- TODO -- move to narrative base kit global
function CageInterface.DebugPrint(...)
	if CageInterface.printDebug == true then
		print(...);
	end
end

function CageInterface.TearDownOnRoundEnd():void
	CageInterface.TearDown();
end

-- meant to be less discoverable and used only internally
global CageInterfaceInternal = {
	printDebug = false, -- check-in as false
};

--## CLIENT

-- ====================================================================================================== --
-- CAGE INTERFACE REMOTE CLIENT WRAPPER
-- ====================================================================================================== --
function remoteClient.CageInterface_SwitchToCageCamera(player:player):void
	CageInterface.SwitchToCageCamera(player);
end

function remoteClient.CageInterface_SwitchToGameplayCamera(player:player, blendTime:number):void
	CageInterface.SwitchToGameplayCamera(player, blendTime);
end

function remoteClient.CageInterface_ResetStack(player:player, blendTime:number):void
	CageInterface.ResetStack(player, blendTime);
end

function remoteClient.CageInterface_AddPlayerStack(player:player):void
	CageInterface.AddPlayerStack(player);
end

function remoteClient.CageInterface_RemovePlayerStack(player:player):void
	CageInterface.RemovePlayerStack(player);
end

function remoteClient.CageInterface_OnBlendEnter(player:player):void
	CageInterface.OnBlendEnter(player);
end

function remoteClient.CageInterface_OnBlendExit(player:player):void
	CageInterface.OnBlendExit(player);
end

function remoteClient.CageInterface_TearDown():void
	CageInterface.TearDown();
end

function remoteClient.CageInterface_SetDebugPrint(set:boolean):void
	CageInterface.SetDebugPrint(set);
end

-- ====================================================================================================== --
-- CAGE INTERFACE DEFINITIONS
-- ====================================================================================================== --
hstructure CageManager
	-- created once per player
	playerCams: table;
end

hstructure CagePlayerCam
	stack: cage_stack;

	-- associated player
	player: player;
	playerObject: object;

	-- temp storage so we don't pass from server to client
	transform: cage_transform_provider;

	-- set to true to manually avoid a first person camera reset (ex. adding a pitch to entering a warthog)
	-- (meant to be set externally)
	enforceCameraOnStack: boolean;

	-- number of cage blends the player is currently processing
	numCageBlends: number;

	-- if using cage camera
	inUse: boolean;
end

-- ====================================================================================================== --
-- CAGE INTERFACE CLIENT API
-- ====================================================================================================== --
global CageInterface = {
	-- Singleton, should only ever have one entry in table, and will be instantiated ONCE the first time GetCageManager is called
	-- do not call directly! Call GetCageManager to ensure you are getting something valid
	cageManager = nil,
};

function CageInterface.GetCageManager(player: player):CageManager
	if CageInterface.cageManager == nil then
		CageInterface.cageManager = hmake CageManager
		{
			playerCams = {},
		};

		CageInterface.DebugPrint("Cage Manager created");
		assert(CageInterface.cageManager ~= nil, "Cage manager did not create successfully.");
	end

	if (player ~= nil) and (CageInterface.cageManager.playerCams[player] == nil) then
		CageInterface.AddPlayerStack(player);
	end

	return CageInterface.cageManager;
end

function CageInterface.SwitchToCageCamera(player:player):void
	CageInterface.DebugPrint("Switching to Cage Camera");
	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
	-- exit early if:
	if CageInterfaceInternal.VerifyPlayerCam(player) == false then
		return;
	end

	CageInterface.OnBlendEnter(player);

	Cage_SwitchToCageCamera(playerCam.playerObject, playerCam.stack);
	playerCam.inUse = true;
end

-- This manages cage transitions (no control over enter/exit calls for volume so might miss a call and prematurely blend when two volumes are right next to each other)
function CageInterface.SwitchToGameplayCamera(player:player, blendTime:number):void
	CageInterface.DebugPrint("Switching to Gameplay Camera");

	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);

	CageInterface.OnBlendExit(player);

	-- exit early if:
	local exitEarly:boolean = false;
	if CageInterfaceInternal.VerifyPlayerCam(player) == false then
		exitEarly = true;
	elseif playerCam.inUse == false then
		print(player, "doesn't have a cage cam in use.");
		exitEarly = true;
	end

	if exitEarly == true then
		CageInterface.DebugPrint("Switching to Gameplay Camera exited early -- won't blend to gameplay");
		return;
	end

	-- if user provided an explicit back to gameplay blend then use it
	if playerCam.enforceCameraOnStack == true then
		local transform:cage_transform_provider = Cage_StackGetTransformProviderTop(playerCam.stack);
		Cage_TransformReturnToGameplayCameraPlayer(transform, player);
	else
		-- otherwise use topmost blend time
		if blendTime == nil then
			print("nil");
			local depth: number = Cage_StackGetDepth(playerCam.stack);
			blendTime = 0;

			for i = depth, 1, -1 do
				local entry: cage_stack_entry = Cage_StackGetEntryIndex(playerCam.stack, i - 1);
				blendTime = math.max(blendTime, Cage_StackEntryGetBlendTime(entry));
				if blendTime > 0 then
					break;
				end
			end
		end

		-- then reset stack and blend back to gameplay camera
		local transform:cage_transform_provider = Cage_TransformCreateDirectorProvider(playerCam.playerObject, false, false);
		local properties:cage_properties_provider = Cage_PropertiesCreateDirectorCameraProvider(Cage_TransformGetDirectorIndex(transform));

		Cage_TransformReturnToGameplayCameraPlayer(transform, player);
		Cage_StackBlendTo(playerCam.stack, transform, properties, blendTime);
	end

	playerCam.enforceCameraOnStack = false;
	playerCam.inUse = false;
end

function CageInterface.ResetStack(player:player, blendTime:number):void
	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
	if CageInterfaceInternal.VerifyPlayerCam(player) == false then
		return;
	end

	local transform:cage_transform_provider = Cage_TransformCreateDirectorProvider(playerCam.playerObject, false, false);
	local properties:cage_properties_provider = Cage_PropertiesCreateDirectorCameraProvider(Cage_TransformGetDirectorIndex(transform));
	Cage_StackBlendTo(playerCam.stack, transform, properties, blendTime);
end

-- ------------------------------------------------------------------------------------------------------ --
-- PLAYER MANAGEMENT
-- ------------------------------------------------------------------------------------------------------ --
function CageInterface.GetPlayerCam(player:player):CagePlayerCam
	local cageManager:CageManager = CageInterface.GetCageManager(player);
	return cageManager.playerCams[player];
end

function CageInterface.AddPlayerStack(player:player):void
	local playerObject:object = Player_GetUnit(player);
	local playerCam:CagePlayerCam = hmake CagePlayerCam
	{
		stack = Cage_StackGetOrCreatePlayer(player),
		player = player,
		playerObject = playerObject,

		transform = nil,
		numCageBlends = 0,
		enforceCameraOnStack = false,
		inUse = false,
	};

	local cageManager:CageManager = CageInterface.GetCageManager();
	cageManager.playerCams[player] = playerCam;

	if Cage_StackGetDepth(playerCam.stack) == 0 then
		CageInterface.ResetStack(player, 0);
	end
end

function CageInterface.RemovePlayerStack(player:player):void
	if CageInterfaceInternal.VerifyPlayerCam(player) == false then
		return;
	end

	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
	Cage_StackRemove(playerCam.stack);

	local cageManager:CageManager = CageInterface.GetCageManager(player);
	cageManager.playerCams[player] = nil;
end

-- ------------------------------------------------------------------------------------------------------ --
-- BLEND MANAGEMENT
-- ------------------------------------------------------------------------------------------------------ --
function CageInterface.OnBlendEnter(player:player):void
	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
	if CageInterfaceInternal.VerifyPlayerCam(player) == false then
		return;
	end

	playerCam.numCageBlends = playerCam.numCageBlends + 1;
end

function CageInterface.OnBlendExit(player:player):void
	local playerCam:CagePlayerCam = CageInterface.GetPlayerCam(player);
	if CageInterfaceInternal.VerifyPlayerCam(player) == true and playerCam.numCageBlends > 0 then
		playerCam.numCageBlends = playerCam.numCageBlends - 1;
	end
end

-- ------------------------------------------------------------------------------------------------------ --
-- TEARDOWN
-- ------------------------------------------------------------------------------------------------------ --
function CageInterface.TearDown():void
	local cageManager = CageInterface.GetCageManager();

	for player,_ in hpairs(cageManager.playerCams) do
		CageInterface.RemovePlayerStack(player);
	end

	CageInterface.cageManager = nil;
end

-- called on client side will affect ONLY client and NOT server
function CageInterface.SetDebugPrint(set:boolean):void
	CageInterfaceInternal.printDebug = set;
end

function CageInterface.DebugPrint(...):void
	if CageInterfaceInternal.printDebug == true then
		print(...);
	end
end

-- ====================================================================================================== --
-- PRIVATE HELPERS (not meant for external use)
-- ====================================================================================================== --
global CageInterfaceInternal = {
	printDebug = false, -- check-in as false
};

function CageInterfaceInternal.VerifyPlayerCam(player):boolean
	if CageInterface.cageManager.playerCams[player] == nil then
		if player == nil then
			print("player was nil, so can't verify player cam.");
		else
			print(player, "doesn't have a player cam or one was never created.");
		end
		print(debug.traceback());
		return false;
	end

	return true;
end