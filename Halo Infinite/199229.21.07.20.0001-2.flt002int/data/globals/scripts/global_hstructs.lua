-- Copyright (C) Microsoft. All rights reserved.
-- =============================================================================================================================
-- ============================================ GLOBAL HSTRUCTS ========================================================
-- =============================================================================================================================
-- declare hstructs here to use them in non-global scripts
--
--	GLOBAL
--

hstructure MPItemTableEntry
	tag						:tag
	faction					:mp_item_faction
	containerScale			:number
	navpointStringId		:string
	navpointOffset			:number
	legendaryVariants		:table
end

hstructure MPWeaponTableEntry:MPItemTableEntry
	config					:tag
	identifier				:mp_weapon_identifier
	tier					:mp_weapon_tier
	class					:mp_weapon_class
	antivehicle				:boolean
	hologramIconPos			:number
end

hstructure MPEquipmentTableEntry:MPItemTableEntry
	attachmentTag				:tag
	frameAttachmentTag			:tag
	identifier					:mp_equipment_identifier
	class						:mp_equipment_class
	legendaryVariantAttachments	:table
end

hstructure MPVehicleTableEntry:MPItemTableEntry
	config					:tag
	identifier				:mp_vehicle_identifier
	class					:mp_vehicle_class
	terrain					:mp_vehicle_terrain_type
	clearance				:number
	hologramScale			:number
	verticalOffset			:number
end

--## SERVER

hstructure PassengerSeatData
	unit						:object;
	player						:player;
	seatName					:string;
end

hstructure WeaponSpawnAssistsInitArgs
	instanceName				:string;
end

hstructure GameModeManagerInitArgs
	-- Mandatory; a reference to the primary game mode parcel (i.e. 'self' for the game mode)
	gameModeParcelReference					:table;

	-- Mandatory for LastChance modes; predicate function that returns trust if conditions for triggering Last Chance are met
	lastChancePredicateFunc					:ifunction;
	-- Optional; an alternate predicate function that will be called during Overtime Last Chance
	overtimeLastChancePredicateFunc			:ifunction;

	-- Optional; a function that will be called on Last Chance begin instead of the standard MP Lua Response
	lastChanceBeginResponseOverrideFunc		:ifunction;
	-- Optional; a function that will be called on Last Chance end instead of the standard MP Lua Response
	lastChanceEndResponseOverrideFunc		:ifunction;
	-- Optional; while last chance is active a respawn penalty of this many seconds will be added to all players.
	lastChanceRespawnPenaltySeconds			:number;

	-- Optional; a function that will be called at the end of all regulation rounds to determine whether or not an Overtime Bonus Round should be triggered (if enabled).
	-- If not specified, we will just check if the number of RoundsWon is tied between the top two teams
	shouldTriggerOTRoundOverridePredicateFunc		:ifunction;

	-- Optional; a function that will be called on Round End by the Mode Manager parcel; if this function returns true then the Mode Manager parcel will end the game as well as the round.
	shouldEndGameOnRoundEndPredicateFunc			:ifunction;

	-- Mandatory for modes with OvertimeMode::OvertimeBonusRound specified; predicate function that returns true if Overtime victory has been achieved, and the Overtime Round should end
	overtimeVictoryConditionsMetPredicateFunc		:ifunction;
end

-- << parcel_area_monitor.lua Args >>
hstructure AreaMonitorObjectEnteredEventArgs
	enteringObject 				:object; 	-- the object that entered the Area Monitor
	objectMultiplayerTeam 		:mp_team;	-- the MP Team of the object, i.e. the value returned by Object_GetMultiplayerTeam()
	unitPlayer 					:player;	-- the current living Player of the object (if the object is a unit, and a player is attached), i.e. the value returned by Unit_GetPlayer()
	unitLastPlayer 				:player; 	-- the last Player that was attached to the unit, i.e. the value returned by Unit_GetLastPlayer(); only defined if unitPlayer is nil
end

-- NOTE: If objectExists == false, then the remaining values in this struct are 'stale', and represent the last cached values that we were able to store off from the object the last time it was detected in the Area
--			In the event that the object no longer exists and our data cache had a valid value for unitPlayer, then note that we will instead populate the unitLastPlayer field with this value when forwarding state,
--			since that player is no longer attached to the object, given that it no longer exists
hstructure AreaMonitorObjectExitedEventArgs
	exitingObject 				:object;	-- the object that exited the Area Monitor; more specifically, the object index of an object that was previously contained in the Area Monitor, and is no longer
	objectExists				:boolean;	-- whether or not the object still exists; more specifically, whether ObjectHandle::TryAndGet() returns a valid object (true) or nullptr (false)
	objectMultiplayerTeam		:mp_team;	-- the MP Team of the object; can possibly be a last-known-good cached off value if objectExists == false
	unitPlayer 					:player;	-- the current living Player of the object (if the object is a unit, and a player is attached), i.e. the value returned by Unit_GetPlayer(); will always be nil if objectExists == false
	unitLastPlayer 				:player; 	-- can be one of several values, in this order of preference:
											--		1) if objectExists == true: the current value returned by Unit_GetLastPlayer()
											--		2) if objectExists == false: the cached off value of what was previously returned by Unit_GetPlayer(), i.e. AreaMonitorObjectEnteredEventArgs.unitPlayer
											--		3) if objectExists == false: the cached off value of what was previously returned by Unit_GetLastPlayer(), i.e. AreaMonitorObjectEnteredEventArgs.unitLastPlayer; this case is only possible if self.CONFIG.includeDeadObjects == true
end

--
--	GAMEMODE
--

hstructure AcademyInitArgs
	challengeId					:number; -- required, and manually generated. This is what is sent back for telemetry.
	mapVariant					:string;
	mapVariantAssetId			:string; 
	challengeName				:string;
	challengeDesc				:string;
	startFlag					:flag;
	pickupStartItem				:tag;
	pickupStartFlag				:flag;
	pickupStartIsWeapon			:boolean;
	pickupStartIsGrenade		:boolean;
	challengeObjects			:table;
	startShield					:object_name;
	startBlocker				:object_name;
	ghostBipedTag				:tag;
	ghostRecordingString		:string;
	abilityName					:string;
	startVolume					:volume;
	goalVolume					:volume;
	scoringType					:number;
	targetIDs					:table;
	startButton					:object_name;
	academyUITag				:tag;
	endFlag						:flag;
	starScoreRegistration		:table;
	pickupStartCrateTag			:tag;
	challengeStartIntro			:any;
end

hstructure AcademyRaceInitArgs
	instanceName				:string;
	raceObjects					:table;
	raceLaps					:number;
	raceCourseTag				:tag;
	raceTimerUITAG				:tag;
	playerRespawnTag			:tag;
	checkpointTargetTag			:tag;
end

hstructure AcademyWeaponMapTrainerInitArgs
	instanceName				:string;
	weaponTrainerUITAG			:tag;
	enemyTargetTag				:tag;
end

hstructure AcademyBotScoreAttackInitArgs
	instanceName				:string;
	academyUITag				:tag;
end

hstructure AcademyPracticeInitArgs
	instanceName				:string;
end

hstructure QuickTipsInitArgs
	instanceName				:string;
end

hstructure AcademyBotGarrisonInitArgs
	instanceName				:string;
	garrisonLocationObjectNames	:table;
end

hstructure WarzoneInitArgs
	instanceName				:string;
	initialSpawns				:folder; 
	respawns					:folder;
	vehicleRespawns				:table;
	reqStations					:folder;
	healthStations				:folder;
	levelSpecificSetupCallback	:ifunction;
end

hstructure TOWInitArgs
	instanceName				:string;
	splinePoints				:point_set; 
	towObjectName				:object_name;
	towBarTag					:tag;
	-- of type TOW.CONFIG.ScoringTypeEnum; optional override value
	scoringType					:number;
	enableZonedSpawning			:boolean;
	towSpawnLocationName		:object_name;
	highTeamCheckpointOneZones	:table;
	highTeamCheckpointTwoZones	:table;
	lowTeamCheckpointOneZones	:table;
	lowTeamCheckpointTwoZones	:table;
	checkpointScreenFlash		:tag;
	checkpointSparks			:tag;
	checkpointLightFlash		:tag;
end

hstructure CarryAndCapInitArgs
	instanceName				:string;
	ObjectTag					:tag;
	ObjectSpawnLocation			:object_name;
	ObjectSpawnMarker			:string;
	HomeTeamGoals				:table;
	AwayTeamGoals				:table;
	armingTag					:tag;
	PlantedTag					:tag;
	carryAndCapBarTag			:tag;
	radarNavTag					:tag;
end

hstructure OddballInitArgs
	instanceName				:string;
	objectTag					:tag;
	objectSpawnLocation			:ifunction;  -- should return an object_name when called with no params
	objectSpawnMarker			:string;
end

hstructure LastVehicleStandingInitArgs
	instanceName				:string;
	vehicles					:table;
	captainVehicle				:table;
	vehicleCountIndicatorTag	:tag;
end

hstructure SlayerInitArgs
	instanceName				:string;
end

hstructure VehicleSlayerInitArgs
	instanceName				:string;
	vehicleTag					:tag;
	vehicleVariant				:string;
	vehicleDriverSeat			:string;
	vehicleGunnerSeat			:string;
end

hstructure CTFInitArgs
	instanceName				:string;
	flagObjectTag				:tag;

	flagSpawns					:table; -- flag spawn locations
	flagDeliveryStands			:table; -- delivery locations

	flagStandScreenFlash		:tag;
	flagStandSparks				:tag;
	flagStandLightFlash			:tag;
end

hstructure CTFFlagStand
	-- ifunction objectName because we want to lazy load. OBJECT_NAMES involves iterating over the placements in a level, and it doesn't make sense to pay that cost repeatedly in mp_global_inits
	objectName					:ifunction;
	owningTeam					:mp_team;    -- (MP_TEAM.yellow is used for Neutral)
	isNeutralStand 				:boolean;    -- Neutral Stands can only be used to spawn flags, never to deliver
end

hstructure DestroyInitArgs
	instanceName				:string;
	corebreakerObjectTag		:tag;
	coreObjectArgs				:table;
	objectSpawnLocation			:ifunction;
	objectSpawnMarker			:string;
	coreSegmentExplosionFX		:tag;
	coreFinalExplosionFX		:tag;
end

hstructure DestroyCoreObjectArgs
	objectName					:object_name;
	owningTeam					:mp_team;
end

hstructure JuggernautInitArgs
	instanceName				:string;
	juggernautEffectTag			:tag;
end

-- initArgs for the "old" version of Strongholds (HSStrongholds.lua)
hstructure DeprecatedStrongholdsInitArgs
	instanceName						:string;
	strongHoldObjectNames				:table;
	strongHoldPlateNames				:table;
	preferredStartingStrongholdIndices	:table;
	randomStrongholdOrder				:boolean;
end

hstructure KingOfTheHillInitArgs
	instanceName					:string;
	kingOfTheHillObjectNames		:table;
	hillContestedAnnouncerVOTag		:tag;
	hillMovedAnnouncerVOTag			:tag;
end

hstructure ExtractionInitArgs
	instanceName				:string;
	extractionZones				:ifunction;
	extractionFloodPods			:ifunction;
	extractionWeaponTag 		:tag;
	initializationDeviceTag		:tag;
	conversionDeviceTag			:tag;
	useNetworkProperties		:boolean;
	extractionPulseEffect       :tag;
end

hstructure EliminationInitArgs
	instanceName				:string;
	tokenTag					:tag;
end

hstructure EliminationParcelInitArgs
	instanceName				:string;
end

hstructure JailBreakInitArgs
	instanceName				:string;
	jailAtkDoors				:table;
	jailDefDoors				:table;
	jailAtkHackingTerminal		:object_name;
	jailDefHackingTerminal		:object_name;
	jailNeutralHackingTerminal	:object_name;
	jailVolumeAtk				:string;
	jailVolumeDef				:string;
end

hstructure StockpileInitArgs
	instanceName				:string;
	capacitorLocations			:table;
	redSockets					:table; -- stockpileSocket
	blueSockets					:table; --stockpileSocket
	redNavpointParent			:object_name;
	blueNavpointParent			:object_name;
end

hstructure StockpileSocket
	channel						:string;
	object						:object;
end

hstructure InfectionInitArgs
	instanceName				:string;
end

hstructure MPRaceInitArgs
	instanceName				:string;
	checkpoints					:table;
end

hstructure EscortInitArgs
	instanceName				:string;
	checkpoints					:table;
end

hstructure VipManagerInitArgs
	instanceName				:string;
	groupedPlayers				:table;
end

hstructure VipKillInitArgs
	instanceName				:string;
end

--
--	UTILITY
--

hstructure ArmzoneInitArgs
	instanceName				:string;
	zoneName					:object_name;
	controlTag					:tag;
	plantedTag					:tag;
	trackPlayer					:boolean
	navID						:string;
	timerLength					:number;
	initialTeam					:mp_team;
	useIncomingTimer			:boolean;
	addDenyZone					:boolean;
	spawnZoneTag				:tag;
	endOnSuccess				:boolean;
	deleteZoneOnArmSuccess		:boolean; 			-- Default to true (optional)
	armedPlayerDeathResetsZone	:boolean;
	persistentArmZone			:boolean;
end

hstructure ActivationZoneInitArgs
	instanceName							:string;
	zoneObjectName							:object_name;
	owningTeam								:mp_team;		-- [optional] if supplied, then this team can't Initialize, and will see Friendly navpoints when a zone is inactive, and Hostile navpoints when Activating
	animationWeaponTag						:tag;			-- the tag definition for the AnimationWeapon which is used for interacting with zone devices (e.g. for Assault this is the bomb tag)
	
	incomingDurationSec						:number;  		-- If 0 or nil, there is no Incoming state
	activationTimeSec						:number;
	
	initializationDeviceControlTag			:tag;
	initializationTimeOverrideSec			:number;		-- [optional] override value for Initialization interact time (must be non-zero); default value from tags will be used if unset.
	deactivationDeviceControlTag			:tag;
	deactivationTimeOverrideSec				:number;		-- [optional] override value for Deactivation interact time (must be non-zero); default value from tags will be used if unset.

	useSmartDistanceNavpoint 				:boolean;
	friendlyZoneNavpointTextId				:string;
	hostileZoneNavpointTextId				:string;
	--addDenyZone					:boolean;  TODO: spawn zone stuff later
	--spawnZoneTag					:tag;      TODO: spawn zone stuff later
end

-- Helper hstruct used for ActivationZone parcel device interaction events
hstructure ActivationZoneInteractInfo
	interactingPlayer 		:player;		-- the player interacting with the device
	interactingTeam 		:mp_team; 		-- the MP team of the interacting player
	interactWeapon 			:object;		-- the animWeaponInstance being used for the interact; can be nil if the weapon was deleted as a result of the event,
											--														in which case the old reference will live in prevInteractWeapon
	prevInteractWeapon 		:object;		-- if self.animWeaponInstance was deleted and interactWeapon is nil, then the now-invalid object handle will be passed here for reference
	interactDevice 			:object;		-- the device instance being touched
	zoneObject 				:object;		-- the object instance for the zone object; shouldn't be used for FX, only for correlating which zone this is
	zoneObjectName 			:object_name;	-- the object_name of the zoneObject; similarly, should not be used for FX.
	fxAnchorObject 			:object;		-- the object instance that all looping sounds, SFX, and VFX should be attached to; can be nil if the object was deleted as a result of this event,
											--																					in which case the old reference will live in prevFxAnchorObject
	prevFxAnchorObject 		:object;		-- if the fxAnchorObject was deleted and is nil, then the now-invalid object handle will be passed here for reference
	normalizedInteractionProgress 		:number;  -- valid only for Interrupt events; represents the progress on the interaction when it was interrupted
end

hstructure CaptureAreaInitArgs
	instanceName				:string;
	navPointMarkerName			:object_name;
	captureVolumes				:table;				-- The trigger volumes that the capture area will be anchored to (2nd priority if non-nil)
	owningTeam					:mp_team;
	userFacingName				:string;
	attFacingName				:string;
	defFacingName				:string;
	captureDecay				:boolean;
	MPBoundaryObjectName		:object_name;		-- The MP Boundary Object (object_name) that the capture area will be anchored to (3rd priority if non-nil)
	MPBoundaryObject			:object;			-- The MP Boundary Object (actual object) that the capture area will be anchored to (4th priority if non-nil)
	sphereLocation				:location;			-- The location for the sphere that the capture area will be anchored to (1st priority if non-nil)
	sphereRadius				:number;			-- The radius for the sphere that the capture area will be anchored to (1st priority if non-nil)
	restrictAreaMonitorToParticipants	:boolean;	-- Default for the CaptureArea parcel is true; this param is optional and will override whatever is set inside the parcel
end

hstructure BastionAreaArgs
	-- NOTE: We treat this groupIndex like the spawnOrder field; when we first process the args we sort them by index,
	-- and then the Bastion zone sequence is constructed by concatening copies of this sorted argset, with individual groups uniquely permuted for each repitition of the args
	groupIndex					:number;
	strongholdObjectName 		:object_name;
	telemetryObjectName 		:string;				-- string that will identify this zone in the MPObjectStatusChanged Telemetry Event
	plateObjectName 			:object_name;
	-- no owning team because Bastion areas always start neutral
	overrideSpawnInfluencerObjects		:table;			-- table of object_names that will be used as the set of MP Boundaries for spawn influencing; if nil/empty, a default will be created
end

hstructure LandGrabAreaArgs
	-- NOTE: We treat this groupIndex like the spawnOrder field; when we first process the args we sort them by index,
	-- and then the Bastion zone sequence is constructed by concatening copies of this sorted argset, with individual groups uniquely permuted for each repitition of the args
	groupIndex					:number;
	strongholdObjectName 		:object_name;
	telemetryObjectName 		:string;				-- string that will identify this zone in the MPObjectStatusChanged Telemetry Event
	plateObjectName 			:object_name;
	-- no owning team because Bastion areas always start neutral
	overrideSpawnInfluencerObjects		:table;			-- table of object_names that will be used as the set of MP Boundaries for spawn influencing; if nil/empty, a default will be created
end

hstructure BastionInitArgs
	instanceName 				:string;
	bastionAreaArgs 			:table 		-- Table of BastionAreaArgs
end

hstructure LandGrabInitArgs
	instanceName 				:string;
	landGrabAreaArgs 			:table 		-- Table of LandGrabInitArgs
end

hstructure StrongholdAreaArgs
	-- NOTE: We treat this groupIndex like the spawnOrder field; when we first process the args we sort them by index,
	-- from there we can assign contiguous, unique indices for them at runtime
	groupIndex 					:number;
	strongholdObjectName		:object_name;
	telemetryObjectName 		:string;				-- string that will identify this zone in the MPObjectStatusChanged Telemetry Event
	plateObjectName 			:object_name;
	owningTeam			 		:mp_team;
	overrideSpawnInfluencerObjects		:table;			-- table of object_names that will be used as the set of MP Boundaries for spawn influencing; if nil/empty, a default will be created
end

hstructure StrongholdsInitArgs
	instanceName				:string;
	strongholdAreaArgs			:table; 				-- table of StrongholdAreaArgs
end

-- initArgs for parcel_stronghold.lua; used by Bastion, Strongholds, and Total Control modes
hstructure SingleStrongholdInitArgs
	instanceName 					:string;
	telemetryObjectName				:string;			-- string that will identify this zone in the MPObjectStatusChanged Telemetry Event
	controlAreaParcelSubclass		:table;				-- the Subclass of ControlArea that should be instantiated for capturing

	navpointIndex 					:number;
	strongholdObjectName			:object_name;		-- By default we should specify an objectName, but if this is nil, the value of strongholdObject will be considered
	strongholdObject				:object;
	initialControllingTeam 			:mp_team;
	plateObjectName 				:object_name;
	denySpawningWithinStronghold	:boolean;

	spawnInfluencerParams			:table;				-- table of SpawnInfluencerParam, which define the influencers that will be tied to the Stronghold area
end

hstructure ControlAreaInitArgs
	instanceName				:string;
	telemetryObjectName			:string;			-- string that will identify this zone in the MPObjectStatusChanged Telemetry Event
	areaObjectName				:object_name;		-- The MP boundary object (object_name) that the control area will be anchored to (1st priority if non-nil)
	areaObject					:object;			-- The MP boundary object (actual object) that the control area will be anchored to (2nd priority)
	initialControllingTeam 		:mp_team;
	areaIncomingTimeSec 		:number;
	areaLifetimeSec 			:number;
	areaNavpointsEnabled 		:boolean;			-- If not specified, the ControlArea parcel will have navpoints enabled by default (if false, areaNavpointIndex has no effect)
	areaNavpointIndex 			:number;			-- Index into [A, B, C] navpoint icon params (indices will wrap around automatically); if nil, non-lettered navs are used
end

hstructure ControlAreaNavpointInitArgs
	instanceName				:string;
	controlAreaParcel 			:table;
	initialControllingTeam		:mp_team;
	areaNavpointIndex			:number;
end

hstructure ElimNavpointInitArgs
	instanceName				:string;
	reviveParcel 				:table;
	owningPlayer				:player;
	owningTeam					:mp_team;
	parentObject				:object;
	executeEnabled              :boolean;
	bleedoutTimer               :timer;
end

hstructure DeliverLocationNavpointInitArgs
	instanceName				:string;
	ownerTeam					:mp_team;
	locationObject				:object;
	locationPosition			:vector;
end

hstructure ForwardBaseInitArgs
	instanceName				:string;
	zoneObjectName				:object_name;
	deviceControlTag			:tag;				-- The device control tag that allows players to capture the base while inside the volume
	spawnedObjectTag			:tag;				-- The device control that spawns inside the volume that allows other teams to reset capture progress
	subobjectiveTeam			:mp_team;			-- The team that's allowed to complete this sub-objective (other teams can only reset)
	captureTimerLength			:number;			-- The amount of time required for the base to be captured by a deployed AI
	nextSubobjectives			:table;				-- Table containing the names of any sub-objectives to be STARTED when this base is captured
	parcelsToEnableOnComplete	:table;				-- Table containing the names of any parcels to be ENABLED when this base is captured
	parcelsToDisableOnComplete	:table;				-- Table containing the names of any parcels to be DISABLED when this base is captured
	activeOnRoundStart			:boolean;			-- Whether this sub-objective is active at the start of a round, or is activated later
end

hstructure OrdnanceDeliveryZoneInitArgs
	instanceName				:string;
	zoneObjectName				:object_name;
	controlTag					:tag;
	timeToDropSeconds			:number;		-- optional; defaults to config value
	deliveryService 			:table;
end

hstructure OrdnanceDeliveryPointInitArgs
	location					:location;
	maxDrops					:number;		-- Max number of drops at this location (optional; default 1)
end

hstructure OrdnanceDeliveryInitArgs
	instanceName				:string;
	timeToDropSeconds			:number;
	deliveryService 			:table;			-- Delivery service will fill this in with a reference to themselves (optional; default nil)
	selectOrdnanceFunction		:ifunction;		-- (deliveryService:table, ordnanceOverride:string_id):string_id
	getOrdnanceTableFunction	:ifunction;		-- ():table
	location					:location;		-- location of predetermined delivery point to drop ordnance at (optional; default random)
	recipient					:object;		-- This is set to the player who called in the ordnance for Personal Ordnance (optional; default nil)
	weaponOverride				:string_id;		-- Predetermined weapon to drop (optional; string must be as it appears in munition table)
	showMessaging				:boolean;		-- Show navpoints & MP Lua messaging at the location where the delivery will arrive (optional; default true)
	brTierDeliveriesEnabled		:boolean;		-- Drop BR-Tier deliveries near supply drop deliveries
end

hstructure OrdnanceDeliveryZoneData
	mapZone						:map_zone;
	mapZoneConfig				:map_zone_configuration;
	deliveryZones				:table;						-- Zones to activate (array of object_names)
	eventName					:string;					-- Name of event at which to start countdown to delivery zone activation (optional; timers start at round start by default)
	eventObjectName				:object_name;				-- Name of the target object for the event (optional)
	timeDelaySeconds			:number;
end

hstructure OrdnanceDeliveryServiceInitArgs
	instanceName				:string;
	ordnanceDropPodTag			:tag;
	flareTag					:tag;
	deliveryZoneControlTag		:tag;
	tempUIBarTag				:tag;
	tempUILabelTag				:tag;
	zoneTimeToDropSeconds		:number;		-- optional; defaults to config value in delivery zone
	customWeaponWeights			:table;			-- Weapon name (string, as it appears in the global table) -> weight (number)
	deliveryZoneData			:table;			-- Array of OrdnanceDeliveryZoneData
end

hstructure OrdnanceDeliveryPointZoneData
	mapZone						:map_zone;
	mapZoneConfig				:map_zone_configuration;
	deliveryPoints				:table;						-- Array of OrdnanceDeliveryPointInitArgs
end

hstructure SupplyDropDeliveryScheduleData
	mapZone						:map_zone;
	mapZoneConfig				:map_zone_configuration;
	deliveries					:table;						-- Array of OrdnanceDeliveryInitArgs
	eventName					:string;					-- Name of event at which to start countdown to deliveries (optional; timers start at round start by default)
	eventObjectName				:object_name;				-- Name of the target object (optional)
	brTierDeliveriesEnabled		:boolean;					-- Drop BR-Tier deliveries near supply drop deliveries
end

hstructure SupplyDropDeliveryServiceInitArgs
	instanceName				:string;
	ordnanceDropPodTag			:tag;
	customOrdnanceWeights		:table;			-- Ordnance name (string, as it appears in the global table) -> weight (number)
	deliveryPointData			:table;			-- Array of OrdnanceDeliveryPointZoneData
	scheduleData				:table;			-- Array of SupplyDropDeliveryScheduleData
	brTierDeliveriesEnabled		:boolean;		-- Drop BR-Tier deliveries near supply drop deliveries
end

hstructure PushObjectInitArgs
	instanceName				:string;
	splinePoints				:point_set; 
	splineObjectName			:object_name;
	-- of type PushObject.CONFIG.PushObjectMovementType
	movementType				:number;
	towSpawnLocationName		:object_name;
	lowTeam						:mp_team;
	highTeam					:mp_team;
	-- optional; override value
	checkPointsPerSide			:number;
end

hstructure SpawnRoomInitArgs
	instanceName				:string;
	respawnInfluencerObjectName	:object_name;
	activatedByCheckpoints		:table;
	deactivatedByCheckpoints	:table;
	activatedByVolumeNames		:table;
	deactivatedByVolumeNames	:table;
	aiPlinths					:table;
	doors						:table;
	doorShields					:table;
	aiVolume					:table;
	isActive					:boolean;
end

hstructure VehicleGarageInitArgs
	instanceName				:string;
	movingPlatformName			:object_name;
	externalDoorName			:object_name;
	internalDoorName			:object_name;
	variantString				:string;
	vehicleTag					:tag;
	aiPlinth					:object_name;
	activatedByCheckpoint		:object_name;
	safeVolume					:volume;
	isActive					:boolean;
end

hstructure DynamicObjectEventInitArgs
	instanceName				:string;
	activatedByCheckpoints		:table;
	dynamicObjects				:table;
-- of type DOEMAnimTypeEnum;
	eventType					:string;
	animationType				:number;
end

hstructure TriggerableEffectInitArgs
	instanceName				:string;
	effectPlacements			:table;
	followupSound				:table;
end

hstructure SledBombLoaderInitArgs
	instanceName				:string;
	activatedByCheckpoints		:table;
	bombTag						:tag;
	sledObject					:object_name;
	craneObject					:object_name;
end

hstructure CoreShieldExternalInitArgs
	instanceName				:string;
	activatedByCheckpoint		:object_name;
	sledObject					:object_name;
end

hstructure CoreShieldInternalInitArgs
	hackingterminal				:object;
	safeVolume					:volume;
	energyShield				:object;
end

hstructure PelicanDropInternalInitArgs
	aiPlinth					:object;
	deliveryLocation			:location; 
	coinSlotObject				:object;
	coinSlotInstance			:table;
end

hstructure PelicanDropExternalInitArgs
	instanceName				:string;
	pilotTag					:tag;
	vehicleTag					:tag;
	pelicanTag					:tag;
end

hstructure CollectableObjectInitArgs
	instanceName				:string;
	tokenTag					:tag;
	owningPlayer				:player;
	depositBoxes				:table;
end

hstructure DeliverObjectInitArgs
	instanceName				:string;
	objectWeaponTag				:tag;
	spawnLocationName			:object_name;
	spawnLocationObject 		:object; --either you pass an object_name or object
	spawnLocationMarker			:string;
	delaySpawn					:boolean;
	visType						:number;
	objectShouldHavePickupPriority	:boolean; -- whether or not the spawned object will be set to have pickup priority on it
	backpackObjectEnabled		:boolean;
end

hstructure FlagInitArgs
	instanceName				:string;
	telemetryObjectName 		:string;		-- string that will identify this Flag in the MPObjectStatusChanged Telemetry Event
	objectWeaponTag				:tag;
	spawnLocationName			:object_name;
	spawnLocationMarker			:string;
	delaySpawn					:boolean;
	visType						:number;
	owningTeam					:mp_team;
	returnTimer					:number;
	touchReturnEnabled			:boolean;
	friendlyNavpointParamsOverride		:string;
	hostileNavpointParamsOverride		:string;
end

hstructure BombInitArgs
	instanceName				:string;
	objectWeaponTag				:tag;
	spawnLocationName			:object_name;
	spawnLocationMarker			:string;
	delaySpawn					:boolean;
	autoPickupBombEnabled		:boolean;
	backpackBombEnabled			:boolean;
	visType						:number;
	owningTeam					:mp_team;
	returnTimer					:number;
	friendlyNavpointParamsOverride		:string;
	hostileNavpointParamsOverride		:string;
end

hstructure AIPushControlInitArgs
	instanceName				:string;
	pushObject					:object_name;
	pushAI						:ai;			-- DEPRECATED
	checkPoints					:table;
	goals						:table;
	hackDevice					:tag;			--Used for Hacking Interaction Type
	plantedTag					:tag;
	controlType					:number;
	asymmetrical				:boolean;		-- Optional; AI PushControl defaults to Symmetrical mode unless specified otherwise
	asymAttackingTeam			:mp_team;		-- Required for Asymmetrical mode
	asymDefendingTeam			:mp_team;		-- Required for Asymmetrical mode
end

hstructure CargoDeliveryInitArgs
	instanceName				:string;
	cargoObjectName				:object_name;
	hackDevice					:tag;
	checkpointNames				:table;			-- Standard Objective checkpoints
	silentCheckpointNames		:table;			-- "Silent" checkpoints that fire the "SilentCheckpointReached" global event when hit; not ordered
	silentTriggerVolumeNames	:table;			-- "Silent" trigger volumes that fire the "SilentTriggerVolumeReached" global event when hit; not ordered
	bombArmzoneTag				:tag;
	bombPlantedTag				:tag;
	useNetworkProperties		:boolean;
end

hstructure OperateObjectInitArgs
	instanceName				:string;
	movingObjectName			:object_name;
	attackingTeam				:mp_team;
	defendingTeam				:mp_team;
	pushAI						:ai;
	hackDevice					:tag;
	useNetworkProperties		:boolean;
end

hstructure BTSInitArgs
	instanceName				:string;
	flyingBasesIds				:table;
	outpostIds					:table;
	bombArmsiteTag				:tag;
	bombPlantedTag				:tag;
	bombTag						:tag;
	beamFXTag					:tag;
	explosionEffect				:tag;
	internalWeakpointTag		:tag;
	weakpointTag				:tag;
end

hstructure BTSCoinSlotInitArgs
	instanceName			:string
	tierType				:string
	cost					:number
	coinSlotObject			:object
	coinTag					:tag
	initialLevel			:number
end

hstructure BTSMainObjectiveTimeoutInitArgs
	instanceName			:string;
	timeoutDurationSec		:number;
end

hstructure BTSTrackerInfoChangeArgs
	globalTitle					:string_id;
	globalDescription			:string_id;
	globalIconSubtype			:string_id;
	localTitle					:string_id;
	localDescription			:string_id;
	localIconSubtype			:string_id;
end

hstructure SupplyLinesCatalogManagerInitArgs
	addAllItemsToRandomPool		:boolean;
	unlockEventsEnabled			:boolean;
	squadUnlocksEnabled			:boolean;
end

hstructure VehicleResupplyManagerInitArgs
	instanceName				:string;
	spawnPoints 				:point_set; -- [agleeson, 04.27.2020] This should be removed, but I'm leaving it in for now to prevent the entire studio from needing to clear their caches. (Bug 361394)
	selectiveChannel			:string;
	minVehicleCount				:number;
	maxVehicleCount				:number;
	minRespawnTimerSeconds		:number;
	maxRespawnTimerSeconds		:number;
	initialSpawnDelaySeconds	:number;
end

hstructure PelicanVehicleDropInitArgs
	instanceName				:string;
	spawnPoint					:object;
	selectedVehicle				:tag;
	selectedVehicleConfig		:tag;
end

hstructure ObjectGoalInitArgs
	instanceName				:string;
	goalObject					:object;
	deliverObject				:object;		--Object to check against Goal
	owningTeam					:mp_team
end

hstructure FrameworkStartupData
	parcelTypeName					:string;
	parcelName						:string;
	initArgs						:any;
	roundScoreToWinOverride			:number;	-- Optional; used to override the variant-set ScoreToWinRound for the given round
	disableScoreDisplayForRound		:boolean;	-- Optional; if true, the Score in the mini-scoreboard will be replaced with "--"
	miniScoreboardShouldDisplayTotalScoreForRound	:boolean;   -- Optional; if set, this will override the behavior for the miniscoreboard that's specified by the variant
	roundStartUIEvents				:table;		-- Optional; UI events to broadcast to SLAMS and HUI when a round begins
	roundEndUIEvents				:table;		-- Optional; UI events to broadcast to SLAMS and HUI when a round ends
	configFunc						:ifunction;
	useMatchScoring					:boolean;
end

hstructure GenericParcelInitArgs
	parcelTypeName					:string;	-- Name of the parcel type to create
	parcelInitArgs					:any;		-- Init args to be passed into the parcel
end

hstructure DeathVolumeInitArgs
	instanceName					:string;
	deathVolume						:object;
	shrinkBeginDelay				:number;
	startShowingTimerAtSeconds      :number;
	manualStart                     :boolean;
	dynamicShrinkTime               :boolean;
end


------------------ Sandbox Object Hstructs --------------

hstructure HackingPointOverrides
	name					: string
	killfeedString			: string
	splashBannerStringIds	: table
	navpointPassiveLabels	: table
	navpointProgressLabels	: table
	hackingSkillRequirement	: string
	hackDuration			: number
	boundaryVisible			: boolean
	interruptOnDeparture	: boolean
	ownerTeamDesignator		: mp_team_designator
	bannerDisabled			: boolean
	progressBarDisabled		: boolean
	mpAiEnabled				: boolean
end

hstructure CommNodeStates
	isActive				: boolean
	isPowered				: boolean
	ownerTeamDesignator		: any
end

hstructure CommNodeObjectGovernorArgs
	instanceName			: string
	governedObject			: object
	upstreamCommNodeKit		: any
	broadcastChannel		: string
	receivingChannel		: string
end

hstructure CommunicationNodeArgs
	instanceName			: string
	upstreamCommNodeParcel	: table
	managedObject			: object
	broadcastChannel		: string
	receivingChannel		: string

	ShouldReceiveState		: ifunction
	--[[  This function should be formatted like this
	local ShouldReceiveState = function(newStateType) return newStateType ~= commNodeStateTypes.isPowered end;
	]]

	ShouldSendState			: ifunction
	--[[  This function should be formatted like this
	local ShouldSendState = function(outgoingStateType) return outgoingStateType ~= commNodeStateTypes.ownerTeam end;
	]]

	IsAllowed				: ifunction
	--[[  This function should be formatted like this. This is the default, if none is given.
	local IsAllowed = 
		function(commNodeParcel)
			local IfCommNode = function(stringName) return commNodeParcel.internalStates[ commNodeStateTypes[stringName] ] end
	
			return IfCommNode("isIntact") and IfCommNode("isPowered") and not IfCommNode("isScriptLocked") and not IfCommNode("isUnderEMP")
		end;
	]]

	startingStates			: table
	--[[  This table should be formatted like this
	local startingStates = {
			[types.isPowered]		= true,
			[types.isIntact]		= true,
			[types.isScriptLocked]	= false,
			[types.isUnderEMP]		= false,
			[types.ownerTeam]		= self.ownerTeam,
	};
	]]
end

-------------------------------------------------------------------------

hstructure DeliverLocationArgs
	instanceName			: string
	areaVolumeName			: object_name
	owningTeam				: mp_team
	attackingTeam			: mp_team
end

hstructure HackableObjectInitArgs
	instanceName			: string
	hackableObject			: object
	navpointParam			: string
	interactType			: number
	interactString			: string
	secondaryString			: string
	overrideInteractString	:boolean
	initialTeam				:mp_team

end

hstructure BTSGunbaseMainObjectiveInitArgs
	instanceName			:string
	hackingTerminal			:object
	hackingTime				:number
end

hstructure BTSOutpostInitArgs
	instanceName			:string
	captureAreaObject		:object
	navMarkerObject			:object
	currencyDeliverArea		:object
	soundEmitter			:object
	chargeTimerLength		:number
	cooldownTimerLength		:number
	useAreaCapture			:boolean
	useCurrency				:boolean
	resetCaptureOnCooldown	:boolean
	hackableObject			:object
	gunbaseActivatedSound	:tag
	useAsSpawn				:boolean
	spawnZoneObject			:object
	coinSlotObject			:object
	coinSlotTierType		:string
	coinTag					:tag
	level2Cost				:number
	level3Cost				:number
end

hstructure BTSObjectiveAreaInitArgs
	parentKitId				:string
	instanceName			:string
	navMarkerObject			:object
	capacitorDeliverObject	:object
	capacitorTag			:tag
	capacitorSpawns			:point_set
	flagStand				:object
	flagTag					:tag
	extractionObjects		:table
	hackableObject			:object
	areaTriggerVolume		:volume
	bombSpawn				:object
	assaultShipSpawns		:point_set
	gunbaseActivatedSound	:tag
	weakpointTag			:tag
	waspSpawns 				:point_set
	rallyNodesSpawns 		:point_set
	scoutNodesSpawns 		:point_set
	rallyStartingArea 		:object
	supplyDropPoints		:point_set
end

hstructure BTSFlyingShipInitArgs
	instanceName			:string
	deliverLocations		:table
	flyingShip				:object
	owningTeam				:mp_team
	useAsSpawn				:boolean
	spawnZoneObject			:object
	damageFX				:tag
	smallExplosionFX		:tag
	finalExplosionFX		:tag
	weakpointExt			:tag
	weakpointInt			:tag
	shieldDownSound			:tag
	shieldDownFriendly		:tag
	shieldDownHostile		:tag
	shieldRestored			:tag
end

hstructure BTSDeliverableObjectSpawner
	instanceName			:string
	ordnancePod				:object
	deliverObjectTag		:tag
	beamFX					:tag
end

hstructure BTSScavengeActivityInitArgs
	instanceName					:string
	availablePoints					:point_set
	desiredSpawnAmount				:number
	availableCaches					:table
	amountToWin						:number
	atkTeamZoneObject				:object
	defTeamZoneObject				:object
	objectTag						:tag
	outpostTV						:volume
end

hstructure BTSIntelActivityInitArgs
	instanceName					:string
	hackingTerminals				:table
	hackingTime						:number
	hackingAudioPos					:tag
	hackingAudioNeg					:tag
	hackedAudioPos					:tag
	hackedAudioNeg					:tag
	outpostTV						:volume
end

hstructure BTSStrongholdsActivityInitArgs
	instanceName					:string
	strongholdObjects				:table
	outpostTV						:volume
	timeToCaptureSeconds			:number
	minStrongholdAmountToWin		:number
	zoneIncomingEffect					:tag;
	zoneReadyEffect						:tag;
	zoneDespawnEffect					:tag;
	zoneContestedEffect					:tag;
	zoneContestLostEffect				:tag;
	zoneContestWonEffect				:tag;
	zoneCapturedNegativeEffect			:tag;
	zoneCapturedPositiveEffect			:tag;
	zoneCapturingPositiveEffect			:tag;
	zoneCapturingNegativeEffect			:tag;
end

hstructure BTSBombMainObjectiveInitArgs
	instanceName				:string
	overrideTimeAllowed			:number
	deliverLocations			:table
	bombArmsiteTag				:object
	bombPlantedTag				:tag
	bombSpawnLocations			:table
	bombTag						:tag
	explosionEffect				:tag
	attackingTeam				:mp_team
	defendingTeam				:mp_team
	beamFXTag					:tag
end

hstructure BTSWeakpointsMainObjectiveInitArgs
	instanceName				:string
	overrideTimeAllowed			:number
	weakpointTag				:tag
	internalWeakpointTag		:tag
	flyingShipParcel			:table
	attackingTeam				:mp_team
	defendingTeam				:mp_team
	numDestroyedToWin			:number
	tankSpawnPoints				:point_set
end

hstructure BTSDestroyActivityInitArgs
    instanceName					:string
    spawnPoints						:point_set
	weakpointTag					:tag
	internalWeakpointTag			:tag
	flyingShip						:table
	attackingTeam					:mp_team
	owningTeam						:mp_team
	outpostTV						:volume
	desiredSpawnCount				:number
	numDestroyedToWin				:number
	tankSpawnPoints					:point_set
end

hstructure BTSVehicleRunActivityInitArgs
    instanceName					:string
	spawnPoints						:point_set
    vehicleSpawnPoints				:point_set
	spawnNodesAmount				:number
	minNodesFoundToWin				:number
	activityType					:number
	startAreaLocation				:object
	vehicleTag						:tag
	outpostTV						:volume
end

hstructure BTSHeadhunterActivityInitArgs
    instanceName					:string
	skullsToWin						:number
	startAreaLocation				:object
	outpostTV						:volume
end

hstructure BTSStockpileActivityInitArgs
	instanceName					:string
	spawnPoints						:point_set
	team1DeliverArea				:object
	team2DeliverArea				:object
	flagTag							:tag
	flagsToWin						:number
	flagsToSpawn					:number
	outpostTV						:volume
end

hstructure BTSRoamingKingActivityInitArgs
    instanceName					:string
	splinePoints					:point_set
	hillObject						:object
	pointsToWin						:number
	outpostTV						:volume
	scoringAudioPos					:tag
	scoringAudioNeg					:tag
	completeAudioPos				:tag
	completeAudioNeg				:tag
end

hstructure RoamingHillInitArgs
    instanceName					:string
	splinePoints					:point_set
	hillObject						:object
	pointsToWin						:number
end

hstructure MPVehiclePelicanDropInitArgs
    instanceName        :string
	vehicleTag          :tag
	pilotTag            :tag
	pelicanTag          :tag
	deliveryLocation    :point
	respawnTime			:number
	attachmentTag		:tag
	usePelican			:boolean
	useCapacitorLoad	:boolean
	vehicleConfiguration :tag
end

hstructure AssaultInitArgs
	instanceName			:string
	bombRespawnPointArgs	:table    -- table of BombRespawnPointArgs
	bombSpawnArgs			:table    -- table of BombSpawnArgs
	armzoneArgs 			:table    -- table of ArmzoneArgs
	bombTag					:tag
	armingDeviceTag			:tag
	defuseDeviceTag			:tag
	explosionEffect			:tag	  -- DEPRECATED REMOVE SOON
	smokeEffect				:tag
	LoopArmTeam				:tag
	LoopArmEnemy			:tag
	LoopDisarm				:tag
	LoopPlanted				:tag
	LoopResetting			:tag
end

hstructure GrifballInitArgs
	instanceName			:string
	bombRespawnPointArgs	:table    -- table of BombRespawnPointArgs
	bombSpawnArgs			:table    -- table of BombSpawnArgs
	armzoneArgs 			:table    -- table of ArmzoneArgs
	bombTag					:tag
	outlineTag				:tag
	goalScreenFlash			:tag
	goalPlate               :tag
end

hstructure BombRespawnPointArgs
	objectName 				:ifunction
	owningTeam 				:mp_team
end

hstructure BombSpawnArgs
	objectName 				:ifunction
	owningTeam				:mp_team    -- the team that is allowed to pick up the bomb; use nil for a Neutral bomb
end

hstructure ArmzoneArgs
	objectName				:ifunction
	owningTeam				:mp_team    -- the team who is NOT allowed to arm in this zone (nil will eventually mean a Neutral site and anyone can arm here.. not supported yet though and a nil value will assert)
end

hstructure TerritoriesInitArgs
	instanceName					:string
	redZones						:table 		-- table of object_names of zone objects
	blueZones						:table 		-- table of object_names of zone objects
	centerZones						:table 		-- table of object_names of zone objects
	zoneSetsKit						:string		-- id for kit containing the zone kit objects
end

hstructure ParticipantAttributesInitArgs
	playerTraits			:table			-- player trait values indexed by the g_playerTraits enum
	weaponOverrides			:table			-- weapon tags indexed by respawn_weapon_slot
	allowAbility0			:boolean		-- allow ability slot 0 when these attributes are applied? (slot 0 is currently suit ability)
	allowAbility1			:boolean		-- allow ability slot 1 when these attributes are applied? (slot 1 is currently equipment/grenade)
end

hstructure ItemPlacementBaseInitArgs
	instanceName			:string			-- name of the placed instance of the parcel
	containerObject			:object			-- the device machine or crate that is the physical representation of the spawner
	stockAnimDelay			:number			-- amount of time after spawning begins before any animation occurs. for example, on weapon racks, weapon should spawn in slightly before doors open
	hasInvisibleDispenser	:boolean		-- if true, item will just spawn with no physical representation, i.e. classic spawners
	itemShouldRotate		:boolean		-- determines if the item should slowly rotate while on the pad
end

hstructure CampaignWeaponDispenserInitArgs:ItemPlacementBaseInitArgs
	weaponTag				:tag			-- the weapon definition tag to spawn
	weaponConfig			:tag			-- the weapon configuration tag to spawn
end

hstructure MPItemPlacementInitArgs:ItemPlacementBaseInitArgs
	spawnProperties			:string			-- if "Custom", use settings specified in kit, if "Default", use presets based on class
	staticSelection			:string			-- if Enabled, the static item will be used instead of selecting random from categories
	spawnLogic				:string			-- will items spawn based on usage, or on a fixed time interval, or manually
	symmetricalChannel		:string			-- name of symmetrical channel (alpha, bravo, etc). forces same item to spawn for all on channel
	symmetricalChannelId	:string			-- id of symmetrical channel. based on channel name, class and exclusions. forces same item to spawn for all on channel
	selectiveChannel		:string			-- name of selective channel (alpha, bravo, etc). allows subset of spawners to be turned on or off or be controlled externally (air drop)
	initialSpawnDelay		:number			-- amount of time before spawning first item on round start
	respawnTime				:number			-- amount of time between each spawn, either as fixed interval, or after pickup/exhaustion		
	respawnType				:string			-- determines how often the item to spawn is randomized (each time/round/game)
	isMessagingVisible		:boolean		-- if true, a navpoint is displayed
	pingMessaging			:boolean		-- if true, nearby navpoints will appear for a short duration when user requests
	incomingDuration		:number			-- amount of time incoming indication should appear before spawn (unless navpoint is displayed in which case its timer will govern duration)
	maxDeployedItemCount	:number			-- maximum amount of items from this spawner that can be active at one time
	classFilters			:table			-- UNUSED - this is being left in to avoid the ARK bug where obsolete lua can be pulled down that would still be looking for this field. should delete after a few weeks (12/2/20)
	factionFilters			:table			-- table of booleans that filter the items based on their faction (UNSC, Forerunner, Banished)
	classWeightOverrides	:table			-- optional table of weights governing likelyhood of each class being chosen when "Random" class is selected. if nil, global weights are used
	incomingParticleFX		:tag			-- optional tag for a particle FX to play in the incoming state
	altIncomingParticleFX	:tag			-- optional alternate tag for a particle FX to play in the incoming state (for use when power spawners are spawning basic items)
	spawnedParticleFX		:tag			-- optional tag for a particle FX to play in the spawned state
	altSpawnedParticleFX	:tag			-- optional alternate tag for a particle FX to play in the spawned state (for use when power spawners are spawning basic items)
	restrictedParticleFX	:tag			-- optional tag for a particle FX to play in the restricted state
	previewAsHologram		:boolean		-- determines if the item should "materialize" as a hologram before really spawning
	broadcastChannelPower	:string			-- power broadcast channel that spawner will listen to toggle itself on/off
	broadcastChannelControl	:string			-- control broadcast channel that spawner will listen to custom spawn an item
	legendaryItemUsage		:string			-- determines if legendary variants can be used (exclude/include/preferred)
	seedSequenceKey			:string			-- the key to use for getting the random seed sequence information
end

hstructure MPWeaponPlacementInitArgs:MPItemPlacementInitArgs
	weapon					:string			-- an explicitly specified weapon to spawn
	weaponClass				:string			-- class of the weapon, i.e. Pistol, Launcher, etc
	weaponTier				:string			-- tier of the weapon, i.e. Base, Power
	ammoModifier			:string			-- percentage of the default ammunition a weapon should start with
	plasmaExplosionDetach	:boolean		-- plasma explosions will blow weapons off the container (pads/pods only)
	plasmaForceModHorz		:number			-- multiplier to apply to the explosive force when knocking a weapon off the container in the horizontal directions
	plasmaForceModVert		:number			-- multiplier to apply to the explosive force when knocking a weapon off the container in the vertical direction
end

hstructure MPWeaponPodPlacementInitArgs:MPWeaponPlacementInitArgs
	detonationProximity		:number			-- distance from weapon pod a player must be for it to detonate open
end

hstructure MPEquipmentPlacementInitArgs:MPItemPlacementInitArgs
	equipmentType			:string			-- type of the equipment, i.e. Grenade, Power Equipment, etc
	equipment				:string			-- explicitly specified equipment to spawn
	energyModifier			:string			-- percentage of the default energy equipment should start with
end

hstructure MPGrenadePlacementInitArgs:MPEquipmentPlacementInitArgs
	groupCount				:number			-- number of grenades that can exist on a pad at once (1-3)
	spawnCyclically			:boolean		-- if true, grenades will spawn one per interval until group count is hit, otherwise all will spawn simulataneously
end

hstructure MPEquipmentPodPlacementInitArgs:MPEquipmentPlacementInitArgs
	detonationProximity		:number			-- distance from equipment pod a player must be for it to detonate open
end

hstructure MPVehiclePlacementInitArgs:MPItemPlacementInitArgs
	terrainFilters			:table			-- table of booleans governing whether certain terrain types of vehicles (land, air) are allowed to spawn 
	vehicleClass			:string			-- class of the weapon, i.e. Assault, Support, etc
	vehicle					:string 		-- an explicitly specified vehicle to spawn
end

hstructure MPVehicleAirdropPlacementInitArgs:MPVehiclePlacementInitArgs
	useDropZone				:boolean		-- if true, Drop Zone checks for the area around the drop point and checks to see if it can drop. otherwise ignores check and takes rotation of the point with how the Pelican will face 
	acceptanceRadius		:number 		-- checks in a circle around drop point with given range. used only when useDropZone is true 
end

hstructure MPOrdnanceDropInitArgs
	ordnanceType			:number			-- enum specifying what type of crate to drop (weapon, equipment)
	deletionDelay			:number			-- amount of time after item is removed from crate to delete the parcel
end

hstructure MPItemPropertyPreset
	spawnLogic				:mp_spawn_logic
	randomizeFreq			:mp_randomize_frequency
	faction					:mp_item_faction
	initialSpawnDelay		:number
	respawnTime				:number
	maxDeployedItemCount	:number
	isMessagingVisible		:boolean
end

hstructure MPWeaponPropertyPreset:MPItemPropertyPreset
	ammoModifier			:number
end

hstructure MPEquipmentPropertyPreset:MPItemPropertyPreset
	energyModifier			:number
	spawnGrenadesCyclically	:boolean
end

hstructure MPVehiclePropertyPreset:MPItemPropertyPreset
	terrainType				:mp_vehicle_terrain_type
end

hstructure MPItemOverrideData
	spawnLogic				:mp_spawn_logic
	randomizeFrequency		:mp_randomize_frequency
	maxDeployCount			:number
	factionFilters			:table
	navpoint				:number
	initialSpawnDelay		:number
	respawnTime				:number
	forceRandomItem			:boolean
	legendaryItemUsage		:mp_legendary_item_usage
	seedSequenceKey			:string
	staticSelection			:number
end

hstructure MPWeaponOverrideData:MPItemOverrideData
	weapon					:mp_weapon_identifier
	initialAmmoLevel		:number
	class					:mp_weapon_class
	tier					:mp_weapon_tier
end

hstructure MPEquipmentOverrideData:MPItemOverrideData
	equipment				:mp_equipment_identifier
	initialEnergyCharge		:number
	grenadeCount			:number
	cyclicalSpawn			:number
	class					:mp_equipment_class
end

hstructure MPVehicleOverrideData:MPItemOverrideData
	vehicle					:mp_vehicle_identifier
	terrainFilters			:table
	class					:mp_vehicle_class
end

hstructure MPItemSpawnerPendingVOData
	responseName			:string
	itemName				:string
	itemType				:number
	voType					:number
	matchingPlayers			:table
end

hstructure MPItemGameVariantSeedSequenceKeyArgs
	instanceName			:string
	seed					:string
	roundReset				:boolean
end

hstructure TimerManagerInitArgs
	instanceName				:string
	timerlength					:number
	powerType					:number
	controlType					:number
end

---
--- BACKFILL MANAGER
---

hstructure BackfillManagerInitArgs
	backfillDisabledInOvertimeRounds	:boolean; -- Whether or not backfill will be forcibly disabled in Overtime rounds (nil/false -> false)

	-- NOTE: All of these params should either be nil, or normalized percentages: [0.0, 1.0];
	--       nil indicates that the parameter will not be considered when deciding if backfill should be disabled.

	scoreToVictoryMaxThreshold		:number; -- Percentage of score to win that, when exceeded by the winning team, will cause Backfill to be disabled.
	scoreDeltaMaxThreshold			:number; -- When the score delta between two teams is greater than this percentage of the score to win, Backfill is disabled.
	roundTimeRemainingMinThreshold	:number; -- When the percentage of the match remaining drops below this threshold, backfill will be disabled.
	roundsToVictoryMaxThreshold		:number; -- Percentage of the Early Victory Round Count that, when exceeded by the winning team, will cause backfill to be disabled.
	roundsWonDeltaMaxThreshold		:number; -- When the Rounds Won delta between two players/teams exceeds this percentage of the Early Victory Round Count, Backfill is disabled.
	roundsTiedMaxThreshold			:number; -- The percentage of the tied rounds imit that have occured that, when reached, will cause backfill to be disabled.
end

--
--	STATE RULES
--

hstructure StateCondition
	event		:number;
	callback	:ifunction;
	state		:string_id;
	counted		:boolean;
end

hstructure VolumeCondition
	volume			:volume;
	enteredCallback	:ifunction;
	exitedCallback	:ifunction;
	counted			:boolean;
end

hstructure StateRule
	action			:ifunction;
	stateConditions	:table;
	-- The table should be formatted like this:
	--	{
	--		hmake StateCondition
	--		{
	--			...
	--		},
	--		hmake StateCondition
	--		{
	--			...
	--		}
	--	}
	volumeConditions	:table;
	-- The table should be formatted like this:
	--	{
	--		hmake VolumeCondition
	--		{
	--			...
	--		},
	--		hmake VolumeCondition
	--		{
	--			...
	--		}
	--	}
	counter	:number;
end

hstructure StateRulesInitArgs
	rules:table;
	-- The table should be formatted like this:
	--	{
	--		hmake StateRule
	--		{
	--			...
	--		},
	--		hmake StateRule
	--		{
	--			...
	--		}
	--	}
end

--
--	CAMPAIGN
--

hstructure OutpostInitArgs_deprecated
	instanceName				:string;
	completionStrategy			:number;  -- Use OutpostCompletionStrategy
	repetitiveEncounter			:boolean;
	tabCratesToLoad				:table;
	tabCratesToUnload			:table;
	activationVolume			:volume;
	deactivationVolume			:volume;
	activationPointName			:string;
	activationDistance			:number;
	deactivationDistance		:number;
	tabEncounters				:table;
	tabGenerators				:table;
	tabRewards					:table;
	tabPlacedFX					:table;
end

hstructure OutpostInitArgs
	instanceName				:string;
	activationVolume			:volume;
	deactivationVolume			:volume;
	cratesToCreate				:table; -- this is a table of modules
	encounterZoneArray			:table; -- this is a table of encounter zones
	numLivingThreshold			:number;
	intensityDefault			:number;
	startupFunc					:ifunction;
	mainFunc					:ifunction;
	markerLimit					:number;
	persistenceKey				:string;
end

hstructure BackButtonMapArgs
	mapExtent1					:any;					--these are not typed because these can be anything that can be turned into a location (an object, a vector, a flag, etc)
	mapExtent2					:any;
	
	image						:tag; -- the image of the map as a bitmap tag
	mapBitmapLength				:number; -- the length or x of the bitmap in pixels, if we had a binding for getting this we wouldn't need this slot
	mapBitmapHeight				:number; -- the height or y of the bitmap in pixels, if we had a binding for getting this we wouldn't need this slot
end

hstructure IntelMapCameraTimings
	prePanTimePercentage		:number;
	panTimePercentage			:number;	-- Values for what percentage of the total IntelMap intro camera pan is spent in each phase (should add up to 1)
	postPanTimePercentage		:number;						
end

hstructure IntelMapArgs
	cameraLookX					:number;
	cameraLookY					:number;
	cameraLookZ					:number;
	cameraLookAdjust			:number;	-- Amount along the X or Y axis the cameraLook value will adjust during the camera pan
	cameraPitch					:number;
	cameraRestingPitch			:number;	-- Pitch value for camera at the end of camera pan
	cameraYaw					:number;
	cameraYawRotation			:number;	-- How many degrees the Yaw will rotate toward the end of the camera pan
	cameraDistance				:number;	-- Distance camera sits from look point
	cameraZoomAmount			:number;	-- Percentage 0-1 for how much distance value will zoom toward the end of the camera pan
	cameraPanReset				:boolean;	-- Does the camera reset to initial values after pan completes
	backgroundColor				:color_rgba;
	cameraFxSettings			:tag;  -- DEPRECATED
	displayAssets				:table;
	settingsTag 				:tag; -- ingame map settings including rendering information: lighting, post-process knobs, lightmap
	useRenderPass 				:boolean;
end

hstructure CampaignMapArgs
	mapScale					:number; -- scale factor of the map display assets
	initialZoom					:number; -- camera's initial Z position
	pitch						:number; -- angle between the camera position and the look position. Should be between 0 and 90. 90 degrees means camera is right above look position. 
	yaw							:number; -- camera yaw
	iconLodThresholdArray		:table; -- array of threshold distances for icon LOD filtering
	minPanPosition				:vector; -- the minimum position the map can pan to
	maxPanPosition				:vector; -- the max position the map can pan to
	minZoom						:number; -- how much the map can zoom in
	maxZoom						:number; -- how much the map can zoom out
	tiltPoint					:number; -- the Z position at which the camera position will descend straight down when zooming in which increases the pitch and creates a camera tilt effect, rather than moving toward the look position
	tiltWidth					:number; -- the Z at which the camera position blends between vertical descent and forward movement
	-- the below parameters will likely be the same for all levels
	panAccelDuration			:number; -- seconds it takes for pan speed to reach max after you start panning
	panDecelDuration			:number; -- seconds it takes for pan speed to reach 0 after you stop panning
	minPanSpeed					:number; -- pan speed at minimum zoom
	maxPanSpeed					:number; -- pan speed at maximum zoom
	highlightDistance 			:number; -- how far the cursor must be from a point of interest to highlight it
	maxZoomFactor				:number; -- how much the zoom affects the highlightDistance and pan speed
	zoomAccelDuration 			:number; -- seconds it takes for zoom speed to reach max zoom speed after you start zooming
	zoomDecelDuration			:number; -- seconds it takes for zoom speed to reach 0 after you stop zooming
	maxZoomSpeed				:number;
	missionPanSpeed				:number; -- speed of map pan to the selected mission/subMission location
	waypointTag					:tag; -- object that will be spawned in the location where the player places the custom waypoint
	cameraFxSettings			:tag;  -- DEPRECATED
	terrainGeometryTagsArray	:table; -- array of objects that will replace the terrain system when loaded and displayed when tac map is opened
	settingsTag 				:tag; -- ingame map settings including rendering information: lighting, post-process knobs, lightmap
	cameraLight					:string_id; -- light that follows the camera
	cameraLightOffset			:vector; -- offset for the light that follows the camera
end

hstructure CampaignMapSubMissionLinkArgs
	parentMissionLocation		:vector;	-- override for the parent mission's location
	subMissionLocation			:vector;	-- override for the subMission's location
	color						:color_rgba;-- link color if we don't want to use the default
	enabled						:boolean	-- does the link initially appear for the player
end

hstructure CampaignMapMission
	title						:string_id; -- mission title
	category					:string_id; -- mission category
	parentMissionId				:string_id;	-- parent mission id
	position					:vector;	-- (optional) position of the mission on the map
	objectives					:table;		-- (optional) table of CampaignMapObjective associated with mission
	sublink						:CampaignMapSubMissionLinkArgs; -- (optional) data for if it's a submission with a link to a parent mission
end

hstructure CampaignMapObjective
	objectiveId					:string_id; -- objective id
	parentMissionId				:string_id; -- parent mission id
	title						:string_id; -- objective title string
	maxNumber					:number;	-- maximum number for the objective goal (example: kill 5 grunts - this variable will have value of 5)
end

hstructure CampaignMapIcon
	bitmapId					:string_id;	-- id of the bitmap to use
	title						:string_id; -- title of the icon shown on campaign map, will also be used for description's title if not specified
	lodMin						:number;	-- minimum levels of zoom where this icon is visible.  LODs are specified on Map configuration properties
	lodMax						:number;	-- maximum levels of zoom where this icon is visible.  LODs are specified on Map configuration properties
	position					:vector;	-- specify a position in 3D space for the icon. (specify either position or objectTracked, not both)
	objectTracked				:object;	-- specify an object which the icon will follow (specify either position or objectTracked, not both)
	color						:marker_type; -- color tint to apply to the bitmap
	iconOffset					:vector;	-- (optional) offset of the 2D icon in relation to the POI origin (e.g. floating above the 3D model)
end

hstructure CampaignMapPoIDescription
	label						:string_id; -- title of the details panel
	description					:string_id; -- description of the details panel. Icon's title will be used if this is empty
	largeBitmap					:tag;		-- bitmap tag of icon in the description panel
end

hstructure CampaignMap3dModel
	modelTag					:tag;		-- crate tag for the model
	position					:vector;	-- position of the model on the map
	orientation					:vector;	-- (optional) orientation of model on the map (in degrees), default is with no rotation
	scale						:vector;	-- (optional) scale of the model on the map, default is with no scaling
end

hstructure CampaignMapAreaOfInterest
	position					:vector;		-- position to place area of interest
	radius						:number;		-- radius of the area of interest
	color						:marker_type;	-- color of the area of interest (marker_type: MAP_MARKER.critical_path, MAP_MARKER.enemy, MAP_MARKER.friendly or MAP_MARKER.equipment_upgrade)
	areaOffsetPercentage		:number;		-- (optional) percentage value (0-1) of radius to randomly offset area from position
end

hstructure CampaignMapPointOfInterestGroup
	id							:string_id;
	mission						:CampaignMapMission;
	icon						:CampaignMapIcon;
	description					:CampaignMapPoIDescription;
	model						:CampaignMap3dModel;
	area						:CampaignMapAreaOfInterest;
end

hstructure SquadSpawningInitArgs
	spawnZones					:string; -- these are spawn zones that are created in Faber
	aiObjective					:string; -- these are AI objectives that are created in Faber
	buildArmyFunc				:ifunction; -- this is a function that returns a nodegraph that can generate a squad
	intensity					:number;
end

hstructure DropPointsArgs
	points						:point_set;
	dropPoint					:point;
end

hstructure SquadInitArgs
	squad						:any; -- this should be a function from the squad library
	loc							:location; -- the location where the squad will spawn
	intensity					:number;
	objective					:any; -- this should be a function from the objective library 
	objectiveLocation			:location; -- the location of where the objective should be created
	parameters					:any;
	dropPoints					:DropPointsArgs; -- if there are dropPoints then spawn enemy with phantom
end

hstructure VolumeAIListArgs:SquadInitArgs
	volume						:volume;
end

hstructure MonsterClosetInitArgs:SquadInitArgs
	encounterInst				:table -- the encounter instance of the encounter that called in the reinforcement
end

hstructure PhantomReinforcementArgs:MonsterClosetInitArgs

end

hstructure DropPodSquadInitArgs:VolumeAIListArgs
	dropLoc						:location;
end

hstructure DropshipInitArgs
	instanceName				:string;
	squadStruct					:any;  --temp fix for inheritence error
	pointStruct					:DropPointsArgs;
	shrinkSeconds				:number;
	encounterInst				:table; -- the encounter instance of the encounter that called in the dropship
end



hstructure PropKitInitArgs
	propKit						:tag;
	loc							:location;
end

hstructure VolumePropKitListArgs:PropKitInitArgs
	volume						:volume;
end

hstructure EnemiesParcelArgs
	encounterObjective			:any;
	encounterObjectiveLocation	:location;
	encounterObjectiveParams	:any;
	encounterLocation			:location;
	initialAIList						:table;
	--the table should be formatted like this
	--{
	--	hmake SquadInitArgs
	--	{
	--		squad = Build_EliteMediumRoom_1,
	--		loc = FLAGS.fl_loc,
	--	},
	--};
	volumeAIList						:table;
	--the table should be formatted like this
	--{
	--	hmake VolumeAIListArgs
	--	{
	--		volume = VOLUMES.triggervolume01,
	--		squad = Build_EliteMediumRoom_1,
	--		loc = FLAGS.fl_loc,
	--	},
	--};
	dropPoints							:table; -- this table determines phantom dropship points for reinforcements
	--the table should be formatted like this
	--	{
	--		hmake DropPointsArgs
	--		{	
	--			points = POINTS.PointSet01,
	--			dropPoint = POINTS.PointSet01.p2,
	--		},
	--		hmake DropPointsArgs
	--		{	
	--			points = POINTS.PointSet02,
	--			dropPoint = POINTS.PointSet02.p2,
	--		},
	--	},
	monsterClosets						:table; --this is a table of locations where AI reinforcements will spawn
	phantomReinforcementPoints			:table; -- this is a table of PhantomReinforcementArgs
	reinforcementAIType					:ifunction;--enum of reinforcement squad types
	volumePropKitList					:table;
	--the table should be formatted like this
	--{
	--	hmake VolumePropKitListArgs
	--	{
	--		volume = self.spawnvolume,
	--		propKit = TAG('ai\encounter\PropTemplates\test_camp01.PropSpawnTemplateTag'),
	--		loc = self.kit_origin_object,
	--	},
	--};
	percentSquadsRemainingToBeSpawned	:number; -- this should be a percent like 0.25
	totalReinforcements					:number;
	reinforceAtActorNum					:number; -- the number of actors before reinforcements will be called in
end

hstructure RandomItemsStruct
	container		:object -- any way to genericize this??
	itemTable		:table;
	markers			:table;
	biasTable		:table;
	biasMultiplier	:number;
end

hstructure EncounterSpawnStruct
	squad			:handle;
	objective		:any; -- this is any because it could be a string (for old objectives)
	encounter		:any;
end

hstructure CortanaParcelArgs
	parcelName		:string;
	parcelToRun		:table;
end

hstructure CortanaObjectChange
	objectToChange	:any;
	locationToSpawn	:location; --Only required for kit tages
end

hstructure CortanaDungeonArgs
	parcels				:table;
	startupObjects		:table;
	escapeObjects		:table;
	escapeDevice		:object;
	finalMemory			:string;
	finalMemoryVolume	:volume;
end

hstructure LifePoolInitArgs
	instanceName				:string;
	lifePoolSizePerTeam			:number;
	overtimeZoneName			:ifunction;
end

hstructure AttritionInitArgs
	instanceName 				:string;
	overtimeZoneObject 			:ifunction;
end

hstructure HudEventsParcelInitArgs
	instanceName				:string;
	roundStartEvents 			:table; -- table of strings
	roundEndEvents 				:table; -- table of strings
end

hstructure PilotBaseInitArgs
	entranceSpawners			:table;
	midAreaSpawners				:table;
	gateSpawners				:table;
	gateObj						:object;
	schematicObj				:object;
	pilotComp					:object;
	compVolume					:volume;
	mapComp						:object;
	mapGazeKit					:object;
	schematicGazeKit			:object;
	pipTable					:table;
	sandboxConnections			:table;
	spartanComp					:object;
end

hstructure PrisonBaseInitArgs
	cryoDevice					:object;
	persistenceKey				:string;
end

hstructure ScoringModuleEndRoundResults
	winningTeam					:mp_team;
	-- Table of scores in case we want to keep individual round results
	teamScore					:table;
end

hstructure ScoringModuleInitArgs
	scoreModuleMode					:number;
	scoreModuleType					:number;
	roundWinByThreshold				:number;
	roundLimit						:number;
	earlyVictoryRoundCount			:number;
	allowOT							:boolean;
	earlyVictoryOTIncrement			:number;
	roundsPerOT						:number;
	timeLimitPerOT					:number;
	scoreToWinRoundOT				:number;
end

hstructure HowlerObjFreeMarineInitArgs
	kit_CaptiveMarineCage		:object;
	persistenceKey				:persistence_key;
end

hstructure HowlerObjFreeVIPInitArgs
	VIPCage						:object;
	VIPSquad					:object;
	VIPTerminal					:object;
	kit_InterrogationRoomDoor	:object;
	kit_InterrRoomJailer		:squad_spawner;
	kit_tv_InterrogationRoom	:volume;
	persistenceKey				:persistence_key;
end

hstructure HowlerObjSecureExitInitArgs
	Reinforcements				:object;
	persistenceKey				:persistence_key;
end

hstructure EpoiCombatInitArgs
	kitOfSquads					:object;
	reinforcementSquadsKit		:object;
	persistenceKey				:persistence_key;
	isSubObjective				:boolean
end

hstructure EpoiGalliumInitArgs
	combatPersistenceKey		:persistence_key;
	kitOfSquads					:object;
	marinesPersistenceKey		:persistence_key;
	marine01PersistenceKey		:persistence_key;
	marine02PersistenceKey		:persistence_key;
	marine03PersistenceKey		:persistence_key;
	kitOfMarines				:object;
	epoiPersistenceKey			:persistence_key;
	relayChannelName			:string;
	marineCages					:object;
	cageControlChannel			:string;
end

--
--	DUNGEONS
--

hstructure DungeonInitArgs
	internalName			:string;
	telemetryId				:telemetry_string;
	openWorldMode			:boolean; -- if true this parcel instance is in the open world, so e.g. don't try to create a redundant tac map
	kit						:folder; -- if not nil, points to the kit instance that owns this parcel
	state					:table; -- level-specific state, this table is for level-wide state vars that multiple rooms need to be aware of
	active_mission_on_entry	:persistence_key; -- the mission that is active when players first enter the dungeon (usually the previous mission)
	mission_persistence_key	:persistence_key; -- the primary mission of the dungeon
end

hstructure DungeonCheckpoint
	vol					:volume; -- for checkpoints triggered by volumes
	scriptId			:string; -- for checkpoints triggered by script
	name				:string; -- name used in telemetry
	backtrack			:boolean; -- volume should not be enabled until backtracking condition occurs
	noSave				:boolean; -- if true, this checkpoint is only for telemetry and not saving player progress
	optional			:boolean; -- if true, won't count towards progress percentage calculations
	ignoreNearbyEnemies :boolean; -- if true will save even if enemies are nearby as long as they aren't endagering the player.
end

hstructure CampfireInitArgs
	kit_campfire		:object;
	persistenceKey		:persistence_key;
end

hstructure FOBHologramSpawnDetails
	kitName: string; -- the name of hologram kit placement
	isUnlockedFunc: ifunction; -- return true if this weapon is unlocked
	children: table; -- nil or a table of FOBHologramSpawnDetails hstruct that will be scrolled up/down in the same slot.
end