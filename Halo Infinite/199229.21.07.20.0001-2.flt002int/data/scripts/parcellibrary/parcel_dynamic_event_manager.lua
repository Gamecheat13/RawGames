--## SERVER

--------------------------------------------------
-- 
--	parcel_dynamic_event_manager:
--	tracks player state globally for use by dynamic event locations
--
-------------------------------------------------- 

--------------------------------------------------
-- GLOBAL DATA
-------------------------------------------------- 

hstructure DEPersistentData
	vehicleData:table
	playerData:table
	deLocationData:table
	islandLoadedTimeStamp:time_point
	lastSpawnedTimeStamp:time_point
end				

hstructure DEVehicleData
	acquired:time_point
	lastEntered:time_point
	lastExited:time_point
	totalTimeOccupied:number
	vehicleType:campaign_metagame_bucket_type
	isGroundVehicle:boolean
end					

hstructure DEPlayerData
	lastEnteredVehicle:time_point
	lastExitedVehicle:time_point
	deathTimeStamps:table
end

global DynamicEventManager:table = 
{
	isGroundVehicle = 
	{
		[CAMPAIGN_METAGAME_BUCKET_TYPE.mongoose] = true,
		[CAMPAIGN_METAGAME_BUCKET_TYPE.warthog] = true,
		[CAMPAIGN_METAGAME_BUCKET_TYPE.scorpion] = true,
		[CAMPAIGN_METAGAME_BUCKET_TYPE.wasp] = false,
		[CAMPAIGN_METAGAME_BUCKET_TYPE.ghost] = true,
		[CAMPAIGN_METAGAME_BUCKET_TYPE.wraith] = true,
		[CAMPAIGN_METAGAME_BUCKET_TYPE.banshee] = false,
		[CAMPAIGN_METAGAME_BUCKET_TYPE.chopper] = true,
	},

	persistentData = hmake DEPersistentData
	{
		vehicleData = MapClass:New(),
		playerData = MapClass:New(),
		islandLoadedTimeStamp = Game_TimeGet();
	};
}

global DEKeywordsEnum = table.makeAutoEnum
{
	"CombatRating",
	"AntiVehicle",
	"AntiAircraft",
	"RewardWeapons",
	"RewardVehicle",
	"NightTime",
	"Wildlife",
};

--------------------------------------------------
-- INITIALIZATION FUNCTIONS
-------------------------------------------------- 

function startup.DynamicEventManagerInit():void
	DynamicEventManager.RegisterForEvents();
end

function DynamicEventManager.RegisterForEvents():void
	RegisterGlobalEvent(g_eventTypes.mountEnteredEvent, DynamicEventManager.OnVehicleEntered);
	RegisterGlobalEvent(g_eventTypes.mountExitedEvent, DynamicEventManager.OnVehicleExited);
	RegisterGlobalEvent(g_eventTypes.playerAddedEvent, DynamicEventManager.OnPlayerAdded);

	for _, player in hpairs(PLAYERS.active) do
		DynamicEventManager.BeginTrackingPlayer(player);
	end
end

function DynamicEventManager.StartEventManager():void
	DynamicEventManager.events = EventManager:New("Dynamic Events", nil);
	DynamicEventManager.events:RegisterEvent("DE_Location_Loaded");
	DynamicEventManager.events:RegisterEvent("DE_Location_VolumeEntered");
	DynamicEventManager.events:RegisterEvent("DE_Location_VolumeExited");
	DynamicEventManager.events:RegisterEvent("DE_Location_ContainersScored");
	DynamicEventManager.events:RegisterEvent("DE_Container_Activated");
	DynamicEventManager.events:RegisterEvent("DE_Container_Deactivated");
end
DynamicEventManager.StartEventManager();

--------------------------------------------------
-- PERSISTENT DATA FUNCTIONS
--------------------------------------------------

function DynamicEventManager.GetPersistentData():DEPersistentData
	return DynamicEventManager.persistentData;
end

--------------------------------------------------
-- PLAYER EVENT CALLBACKS
--------------------------------------------------

function DynamicEventManager.OnPlayerAdded(eventArgs:PlayerAddedEventStruct):void
	if DynamicEventManager.persistentData.playerData:Contains(eventArgs.player) == false then
		DynamicEventManager.BeginTrackingPlayer(eventArgs.player);
	end
end

function DynamicEventManager.OnPlayerDeath(eventArgs:DeathEventStruct):void
	DynamicEventManager.TrackPlayerDeath(eventArgs.deadObject);
end

--------------------------------------------------
-- VEHICLE EVENT CALLBACKS
--------------------------------------------------

function DynamicEventManager.OnVehicleEntered(eventArgs:MountEnteredEventStruct):void
	if Object_IsPlayer(eventArgs.instigator) == true then
		DynamicEventManager.TrackEnteredVehicle(eventArgs.mount);
		DynamicEventManager.TrackPlayerEnteredVehicle(eventArgs.instigator);
	end
end

function DynamicEventManager.OnVehicleExited(eventArgs:MountExitedEventStruct):void
	if Object_IsPlayer(eventArgs.instigator) == true then
		DynamicEventManager.TrackExitedVehicle(eventArgs.mount);
		DynamicEventManager.TrackPlayerExitedVehicle(eventArgs.instigator);
	end
end

function DynamicEventManager.OnTrackedVehicleDeleted(eventArgs:ObjectDeletedStruct):void
	DynamicEventManager.RemoveTrackedVehicle(eventArgs.deletedObject);
end

function DynamicEventManager.OnTrackedVehicleDestroyed(eventArgs:DeathEventStruct):void
	DynamicEventManager.RemoveTrackedVehicle(eventArgs.deadObject);
end

--------------------------------------------------
-- PLAYER DATA FUNCTIONS
--------------------------------------------------

function DynamicEventManager.BeginTrackingPlayer(player:player):void
	local playerData:DEPlayerData = hmake DEPlayerData
	{
		lastEnteredVehicle = nil,
		lastExitedVehicle = nil,
		deathTimeStamps = QueueClass:New(),
	};

	DynamicEventManager.persistentData.playerData:Insert(player, playerData);

	RegisterEvent(g_eventTypes.deathEvent, DynamicEventManager.OnPlayerDeath, player);
end

function DynamicEventManager.TrackPlayerDeath(playerUnit:object):void
	local playerData:DEPlayerData = DynamicEventManager.persistentData.playerData:Get(Unit_GetPlayer(playerUnit));

	playerData.lastEnteredVehicle = nil;
	playerData.lastExitedVehicle = nil;
	playerData.deathTimeStamps:Push(Game_TimeGet());
end

function DynamicEventManager.TrackPlayerEnteredVehicle(playerUnit:object):void
	local playerData:DEPlayerData = DynamicEventManager.persistentData.playerData:Get(Unit_GetPlayer(playerUnit));

	playerData.lastEnteredVehicle = Game_TimeGet();
	playerData.lastExitedVehicle = nil;
end

function DynamicEventManager.TrackPlayerExitedVehicle(playerUnit:object):void
	local playerData:DEPlayerData = DynamicEventManager.persistentData.playerData:Get(Unit_GetPlayer(playerUnit));

	if playerData.lastEnteredVehicle ~= nil then
		playerData.lastEnteredVehicle = nil;
		playerData.lastExitedVehicle = Game_TimeGet();
	end
end

--------------------------------------------------
-- VEHICLE DATA FUNCTIONS
--------------------------------------------------

function DynamicEventManager.TrackEnteredVehicle(vehicle:object):void
	if DynamicEventManager.IsTrackableVehicleType(vehicle) == true then
		-- see if this is the first time we've seen this vehicle
		if DynamicEventManager.persistentData.vehicleData:Contains(vehicle) == false then
			local metagameBucket:campaign_metagame_bucket_type = Object_GetCampaignMetagameBucketType(vehicle);

			local details:DEVehicleData = hmake DEVehicleData
			{
				acquired = Game_TimeGet(),
				lastEntered = Game_TimeGet(),
				lastExited = nil,
				totalTimeOccupied = 0,
				vehicleType = metagameBucket,
				isGroundVehicle = DynamicEventManager.isGroundVehicle[metagameBucket],			
			};

			DynamicEventManager.persistentData.vehicleData:Insert(vehicle, details);

			RegisterEvent(g_eventTypes.objectDeletedEvent, DynamicEventManager.OnTrackedVehicleDeleted, vehicle);
			RegisterEvent(g_eventTypes.deathEvent, DynamicEventManager.OnTrackedVehicleDestroyed, vehicle);

		-- otherwise see if the vehicle was empty, but is now being re-occupied
		else
			local shouldUpdateTimeStamp:boolean = false;

			-- vehicle was empty
			if Vehicle_GetPassengerCount(vehicle, "", VEHICLE_SEAT.Any) == 1 then
				shouldUpdateTimeStamp = true;
			else
				-- check if the vehicle is being hijacked
				local passengers:table = Vehicle_GetPassengers(vehicle);
				local playerTeam:team = Player_GetCampaignTeam(GetFireTeamLeader());

				for _, passenger in hpairs(passengers) do
					local passengerTeam:team = Object_GetCampaignTeam(passenger);

					if passengerTeam ~= nil and passengerTeam ~= playerTeam then
						shouldUpdateTimeStamp = true;
						break;
					end
				end
			end

			if shouldUpdateTimeStamp == true then
				local details:DEVehicleData = DynamicEventManager.persistentData.vehicleData:Get(vehicle);
				details.lastEntered = Game_TimeGet();
				details.lastExited = nil;
			end
		end
	end
end

function DynamicEventManager.TrackExitedVehicle(vehicle:object):void
	if DynamicEventManager.persistentData.vehicleData:Contains(vehicle) == true then
		-- only update the time stamps if all players have exited the vehicle
		if player_in_vehicle(vehicle) == false then
			local details:DEVehicleData = DynamicEventManager.persistentData.vehicleData:Get(vehicle);

			details.lastExited = Game_TimeGet();
			if details.lastEntered ~= nil then
				details.totalTimeOccupied = details.totalTimeOccupied + details.lastExited:ElapsedTime(details.lastEntered);
			end
			details.lastEntered = nil;
		end
	end
end

function DynamicEventManager.RemoveTrackedVehicle(vehicle:object):void
	DynamicEventManager.persistentData.vehicleData:Remove(vehicle);

	UnregisterEvent(g_eventTypes.objectDeletedEvent, DynamicEventManager.OnTrackedVehicleDeleted, vehicle);
	UnregisterEvent(g_eventTypes.deathEvent, DynamicEventManager.OnTrackedVehicleDestroyed, vehicle);
end

function DynamicEventManager.IsTrackableVehicleType(vehicle:object):boolean
	local metagameBucket:campaign_metagame_bucket_type = Object_GetCampaignMetagameBucketType(vehicle);
	local result:boolean = false;

	for type, _ in hpairs(DynamicEventManager.isGroundVehicle) do
		if type == metagameBucket then
			result = true;
			break;
		end
	end

	return result;
end
