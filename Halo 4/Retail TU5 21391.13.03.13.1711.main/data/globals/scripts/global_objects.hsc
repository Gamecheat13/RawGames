//---------------------------------------------
//	Global Enumerations - Should be constants
//---------------------------------------------

//	Object Event Types
global long ON_BIRTH = 0;
global long ON_DEATH = 1;
global long ON_INTERACT = 2;
global long ON_INIT_SPAWNER_SHARD = 3;
global long ON_INIT_KNIGHT_TAINT = 4;


//	Filter Types (Dynamic Tasks)
global long FT_COMPANION = 0;
global long FT_PROTECTOR = 1;
global long FT_SPAWNER = 2;
global long FT_BIRTHER = 3;


//	Task Types (Dynamic Tasks)
global long TT_INTERACT = 0;
global long TT_PROTECT = 1;
global long TT_SHIELD = 2;
global long TT_RESURRECT = 3;
global long TT_SPAWN = 4;
global long TT_SUPPRESS = 5;
global long TT_SHARD_SPAWN = 6;


//	Task Team Filters (Dynamic Tasks)
global long TF_FRIENDLY = 0;
global long	TF_HOSTILE = 1;
global long TF_ANY = 2;


//	Command Event Types
global long CMD_INTERACT = 0;


//	For use as an invalid task callback.
script static void NOOP_Callback(long taskIndex, long taskType, long taskTarget)
	print("");
end


//------------------------------------
//	Per-Object variable unique IDs.
//------------------------------------

global long VAR_MOVE_AMOUNT = 1;
global long VAR_COVER_STATUS = 2;
global long VAR_MOVE_TIME = 3;
global long VAR_SHARD_SPAWN_DELAY = 4;
global long VAR_TURRET_ACTIVE = 5;
global long VAR_TURRET_HIJACKED = 6;

//	These per-object variables automatically connect to object functions of the same names.
global long VAR_OBJ_LOCAL_A = 253;
global long VAR_OBJ_LOCAL_B = 254;
global long VAR_OBJ_LOCAL_C = 255;


//-------------------------------
//		Command Event Helpers
//-------------------------------

script static void object_interact(object target, object user)
	SendCommandEvent(target, CMD_INTERACT, user, 0.0);
end


//--------------------------
//		Dynamic Cover
//--------------------------

//	'Local' variables used inside functions.
global real dynamicCoverEvent_moveAmount = 0;
global real dynamicCoverEvent_moveTime = 0;
global long dynamicCover_status = 0;


//	Cover status
global long CS_MOVING_UP = 0;
global long CS_UP = 1;
global long CS_MOVING_DOWN = 2;
global long CS_DOWN = 3;


script static void InitializeDynamicCover(object coverObject, real moveAmount, real moveTime)
	//	We want to know when we've been interacted with by the bishop beam.
	SetObjectRealVariable(coverObject, VAR_MOVE_AMOUNT, moveAmount);
	SetObjectRealVariable(coverObject, VAR_MOVE_TIME, moveTime);
	SetObjectLongVariable(coverObject, VAR_COVER_STATUS, CS_DOWN);
	RegisterForObjectEvent(coverObject, ON_INTERACT);
	SetObjectEventCallback(coverObject, OnDynamicCoverEvent_Callback);
end

script static void RequestInteractDynamicCover(object coverObject)
	CreateDynamicTask(TT_INTERACT, FT_COMPANION, coverObject, NOOP_Callback, 0);
end


script static void SetDynamicCoverStatus(object coverObject, boolean setRaised)
	thread(SetDynamicCoverStatusBlocking(coverObject, setRaised));
end


script static void SetDynamicCoverStatusBlocking(object coverObject, boolean setRaised)
	dynamicCover_status = GetObjectLongVariable(coverObject, VAR_COVER_STATUS);
	dynamicCoverEvent_moveTime = GetObjectRealVariable(coverObject, VAR_MOVE_TIME);
	
	if dynamicCover_status == CS_DOWN and setRaised == true then
		//	Raise the cover.
		dynamicCoverEvent_moveAmount = GetObjectRealVariable(coverObject, VAR_MOVE_AMOUNT);
		SetObjectLongVariable(coverObject, VAR_COVER_STATUS, CS_MOVING_UP);
		object_move_by_offset(coverObject, dynamicCoverEvent_moveTime, 0, 0, dynamicCoverEvent_moveAmount);
		SetObjectLongVariable(coverObject, VAR_COVER_STATUS, CS_UP);
	elseif dynamicCover_status == CS_UP and setRaised == false then
		//	Lower the cover
		dynamicCoverEvent_moveAmount = -1.0 * GetObjectRealVariable(coverObject, VAR_MOVE_AMOUNT);
		SetObjectLongVariable(coverObject, VAR_COVER_STATUS, CS_MOVING_DOWN);
		object_move_by_offset(coverObject, dynamicCoverEvent_moveTime, 0, 0, dynamicCoverEvent_moveAmount);
		SetObjectLongVariable(coverObject, VAR_COVER_STATUS, CS_DOWN);
	end
end


script static boolean IsDynamicCoverRaised(object coverObject)
	dynamicCover_status = GetObjectLongVariable(coverObject, VAR_COVER_STATUS);
	dynamicCover_status == CS_MOVING_UP or dynamicCover_status == CS_UP;
end


script static boolean IsDynamicCoverBusy(object coverObject)
	dynamicCover_status = GetObjectLongVariable(coverObject, VAR_COVER_STATUS);
	dynamicCover_status == CS_MOVING_UP or dynamicCover_status == CS_MOVING_DOWN;
end


script static void OnDynamicCoverEvent_Callback(object coverObject, long eventType, object userObject)
	OnDynamicCoverEvent(coverObject, eventType);
end


script static void OnDynamicCoverEvent(object coverObject, long eventType)
	if eventType == ON_INTERACT then
		
		//	Don't want to initiate another interact call while we are busy with this one.
		UnregisterForObjectEvent(coverObject, ON_INTERACT);
		
		dynamicCover_status = GetObjectLongVariable(coverObject, VAR_COVER_STATUS);
		dynamicCoverEvent_moveTime = GetObjectRealVariable(coverObject, VAR_MOVE_TIME);
		
		//	Toggle position, but only if it currently isn't moving.
		if dynamicCover_status == CS_DOWN then
			SetDynamicCoverStatusBlocking(coverObject, true);
		elseif dynamicCover_status == CS_UP then
			SetDynamicCoverStatusBlocking(coverObject, false);
		end
		
		RegisterForObjectEvent(coverObject, ON_INTERACT);
	end
end


//---------------------
//		Shard Spawn
//---------------------

script static void InitializeShardSpawn(object shardObject)
	//	Wait for shard init data from code.
	RegisterForObjectEvent(shardObject, ON_INIT_SPAWNER_SHARD);
	SetObjectEventCallback(shardObject, OnShardSpawnEvent_Callback);
end

script static void OnShardSpawnEvent_Callback(object shardObject, long eventType, long placeTarget, long spawnDelay)
	if eventType == ON_INIT_SPAWNER_SHARD then
		//	Wait and then place actor.
		sleep(spawnDelay);
		//	Make sure we didn't die during the countdown.
		ai_place(placeTarget);	//	Commented out until new build is ready.
		object_dissolve_from_marker(ai_get_object(placeTarget), "resurrect", "phase_in");
		object_dissolve_from_marker(ai_vehicle_get(placeTarget), "resurrect", "phase_in");
		sleep(5); // little bit of time to start the dissolve
		ai_internal_query_clump_for_target(placeTarget); // Ask if there is anyone we should be interested in.
		//	Clean ourselves up.
		object_destroy(shardObject);
	end
end


//-----------------------
//		Knight Taint
//-----------------------

script static void InitializeKnightTaint(object taintObj)
	//	Wait for taint init data from code.
	RegisterForObjectEvent(taintObj, ON_INIT_KNIGHT_TAINT);
	SetObjectEventCallback(taintObj, OnKnightTaintEvent_Callback);
end

script static void OnKnightTaintEvent_Callback(object taintObject, long eventType, long resTaskIndex)
	if eventType == ON_INIT_KNIGHT_TAINT then
		sleep_until(IsDynamicTaskValid(resTaskIndex) == false);
		object_destroy(taintObject);
	end
end


//-----------------------------------------------------
//		CapturableAI
// Interact on one of these objects
// captures it's squad for the team of the captor
//-----------------------------------------------------

script static void InitializeCapturableUnit(object captiveObject)
	RegisterForObjectEvent(captiveObject, ON_INTERACT);
	SetObjectEventCallback(captiveObject, OnCapturableObjectEvent_Callback);
end

script static void OnCapturableObjectEvent_Callback(object captiveObject, long eventType, long arg1, long arg2)
	if eventType == ON_INTERACT then
		//	for interact events, the first argument is the interacting user
		
		ai_capture_allegiance(captiveObject,arg1);	
	end
end


//---------------------------
//		Automated Turret
//---------------------------


script static void InitializeAutomatedTurret(vehicle turret, boolean startsActive)
	SetObjectLongVariable(turret, VAR_TURRET_HIJACKED, 0);
	
	RegisterForObjectEvent(turret, ON_INTERACT);
	SetObjectEventCallback(turret, OnAutomatedTurretEvent_Callback);
end


script static void AutomatedTurretActivate(vehicle turret)
		print("Activating automated turret: OLD FUNCTION. Change to the correct placement of the turrets. MFindley");

end


script static void AutomatedTurretSwitchTeams(object turret, object newTeamObj)
	ai_capture_allegiance(turret, newTeamObj);
	
	//	Only create automatic use task when we have been hijacked.
	if GetObjectLongVariable(turret, VAR_TURRET_HIJACKED) == 0 then
		SetObjectLongVariable(turret, VAR_TURRET_HIJACKED, 1);
		//	We've been hijacked.  Request a bishop to unhijack us.
		RequestAutomatedTurretSwitchTeams(turret);
	end
end


script static void OnAutomatedTurretEvent_Callback(vehicle turret, long eventType, long arg1)
	if eventType == ON_INTERACT then
				//	Switch team of active turret.
			AutomatedTurretSwitchTeams(turret, arg1);
	end	
end


script static void RequestAutomatedTurretActivation(object turret)
	CreateDynamicTask(TT_INTERACT, FT_COMPANION, turret, NOOP_Callback, 0);
end


global long g_taskIndex = -1;
script static void RequestAutomatedTurretSwitchTeams(object turret)
	g_taskIndex = CreateDynamicTask(TT_INTERACT, FT_COMPANION, turret, NOOP_Callback, 0);
	SetDynamicTaskTeamFilter(g_taskIndex, TF_HOSTILE);	//	Because turret has been hijacked.
end
