-- Copyright (c) Microsoft. All rights reserved.


--## SERVER

-- FEATURE FLAGS
-- Academy_GenericFlag1 skips the opening dialogue

-- number of seconds we will wait to prompt the player to do something if they haven't
global tutorialPromptDelaySeconds:number = 20;

-- number of seconds to display quick tips
global tutorialTipDisplaySeconds:number = 10;

global bufferTime = 1;
global countdownAmmount = 5;

-- boolean to track whether the player has hacked the weapon range entrance
global weaponRangeDoorOpen = false;

global timedMovementDrill = false;
global dismissibleDialogDisplaying = false;

global aiHackingTimeSeconds:number = 2;

--navpoint values

global defaultNavpointType = "campaign_waypoint";
global aiTerminalNavpointType = "generic_objective";
global targetNavpointType = "attack";
global hackNavpointText = "academy_insert_AI";
global insertChipNavpointText = "academy_insert_chip";
global pickupObjectNavpointText = "academy_pickup";
global targetNavpointText = "generic_kill";
global spawnerNavpoint = nil;
global grenadeSpawnerNavpoint = nil;

--objective banner messages

global LookMessage:string = "training_camera";
global MoveMessage:string = "training_movement";
global pickAIMessage:string = "training_chooseai";
global hackTutorialMessage:string = "training_deployai";
global interlockExitMessage:string = "academy_exit";
global weaponPickUpMessage:string = "training_weaponpickup";
global weaponFireMessage:string = "training_shoot";
global weaponZoomMessage:string = "training_zoom";
global weaponZoomHoldMessage:string = "training_zoom_hold";
global meleeMessage:string = "training_melee";
global weaponMessage:string = "training_weaponpickup";
global sprintMessage:string = "training_sprint";
global sprintHoldMessage:string = "training_sprint_hold";
global crouchMessage:string = "training_crouch";
global crouchHoldMessage:string = "training_crouch_hold";
global jumpMessage:string = "training_jump";
global reloadMessage:string = "training_reload";
global weaponSwapMessage:string = "training_switch_weapons";
global countdownString:string = "countdown_text";
global countdownStartString = "academy_volume_start";
global countdownBanner = nil;
global movementYardThreadIndex = nil;

-- telemetry values

global telemetryMissionNameId:telemetry_string = nil;
global lastMissionStatus = nil;
global missionStatusStartedOn:time_point = nil;
global activityIndex = nil;
global progressionStartedOn:time_point = nil;

--invisible collision object around the commander puppet in the intro
global pelicanIdleCollisionObject = nil;

-- function to show full screen tutorial prompts
global dismissibleDialogueWithStringIdFunc = nil;

-- Inits

function InitTutorial()
	-- Ensure we start on a black screen
	Composer_FadeOut(0, 0, 0, 0);
    CreateThread(InitTutorialThread);
end

function StartStreamingThread()
	SleepUntil([|volume_test_players(VOLUMES.streaming_volume) == true], 1);

	Device_SetDesiredPosition(OBJECTS.armory_entrance_door_machine, 0);
	SleepUntil([| Device_GetPosition(OBJECTS.armory_entrance_door_machine) == 0], 1);
	-- Teleport any player on the wrong side of the door to a flag on the correct side 
	if volume_test_players(VOLUMES.ooa_zoneset_switch) == true then
		object_teleport(PLAYERS.player0, FLAGS.fl_unallowed_volume_teleport);
	end
	Sleep(1);
	prepare_to_switch_to_zone_set(ZONE_SETS.academy_end);
	-- Actually make sure we're looming
	Sleep(1);
	SleepUntil([| PreparingToSwitchZoneSet() == false], 1);
	switch_zone_set(ZONE_SETS.academy_end);
	SleepUntil([|current_zone_set() == ZONE_SETS.academy_end], 1);
	StartTutorialGrenadeDispenser();
end

function Tutorial_SetInitialSpawnPoint():void
	for _, spawn in ipairs(Spawn_GetAllInitialSpawnPoints()) do
		if Object_GetName(spawn) ~= OBJECT_NAMES.tutorial_spawn_point then
			Spawn_InitialSpawnPointSetEnabled(spawn, false);
		else
			break;
		end
	end
end

function InitTutorialThread()
	EnablePersonalAIVoices(false);
	PersonalAI_SetOrientationMode(PERSONAL_AI_ORIENTATION_MODE.AlwaysGaze);
	PersonalAI_SetAvatarType(PLAYERS.player0, PERSONAL_AI_AVATAR_TYPE.Prism);
	PersonalAI_SetColorPresetName(PLAYERS.player0, "default");
	PersonalAI_SetTetherDistanceLimit(-1);
	PersonalAI_SetScale(PLAYERS.player0, 0.65);
	TableRepository.GetOrRegisterTable("AcademyNarrative").MovieDone = false;
	TableRepository.GetOrRegisterTable("AcademyNarrative").LookBannerCall = function():void CreateThread(HandleLookBannerInstructionThread); end;
	CreateObjectiveBanner();
	SleepUntil([|Player_GetUnit(PLAYERS.player0) ~= nil], 1);
	PlayerControlFadeOutAllInputForPlayer(PLAYERS.player0, 0);

	CreateThread(SuspendTimerThread);
	
	if(Academy_PlayCinematic == true) then
		local compdata:table = {};
		compdata.StartScript = function(state)
        if (state and state.moviePath) then
		        video_play_movie(state.moviePath);
		    end
		end
		compdata.SkipScript = function(state)
		    if (video_is_playing()) then
		        video_cancel_movie();
		    end
		end

		local intro_show_ID = composer_play_show("mp_cinematic_intro", compdata);
		-- Sleeping for 3 seconds to give the video enough opportunity to start playing, but if it can't start after
		-- that long, likely something horrible has happened and we should just bail.
		SleepUntilSeconds([|composer_show_is_playing(intro_show_ID) == true], 1, 3);
		
		if(composer_show_is_playing(intro_show_ID) == true) then
			-- The movie is about 2:30, so if we've been playing for much longer than that, we should just bail.
			SleepUntilSeconds([| not composer_show_is_playing(intro_show_ID)], 1, 160);
			if(composer_show_is_playing(intro_show_ID) == true) then
				print("mp_cinematic_intro never ended, bailing out.");
				composer_stop_show(intro_show_ID);
			else
				print("mp_cinematic_intro ended successfully!");
			end
		else
			print("mp_cinematic_intro failed to play, skipping.");
		end
		
	else
		print("Skipping fullscreen video due to Academy_GenericFlag20 being false");
	end
	TableRepository.GetOrRegisterTable("AcademyNarrative").MovieDone = true;

	-- assign a name for our mission 
	telemetryMissionNameId = Telemetry_RegisterHashString("Multiplayer_Tutorial");
	lastMissionStatus = Telemetry.Enums.MissionStatus.unknown;

	Tutorial_SetInitialSpawnPoint();
	
	NarrativeInterface.PlayNarrativeSequence("TUTORIAL_LANDING_PAD_AMBIENT_MARINES");

	SetPlayerStartState();

	if skipTutorialCinematics == false then
		Tutorial_PlayIntro();
	else
		-- Normally the intro would fade us in, but if we aren't playing it, we should do that real quick.
		Composer_FadeIn(0, 0, 0, 1);
	end

	PlayerControlFadeInAllInputForPlayer(PLAYERS.player0, 0);

	CreateThread(Tutorial_StartUpThread);
	CreateThread(Tutorial_TransitThread);
	CreateThread(Tutorial_PickAIThread);
	CreateThread(Tutorial_MovementIntroductionThread);
	CreateThread(Tutorial_MovementJumpThread);
	CreateThread(Tutorial_MovementClamberThread);
	CreateThread(Tutorial_MovementCrouchThread);
	CreateThread(Tutorial_GruntTransitionThread);
	CreateThread(Tutorial_MovementSprintThread);
	CreateThread(Tutorial_WeaponStorageThread);
	CreateThread(Tutorial_MovementYardExitThread);
	CreateThread(Tutorial_MovementTransitionToArmoryThread);
	CreateThread(Tutorial_InterlockTransitionThread);
	CreateThread(StartStreamingThread);
end


function HandleLookBannerInstructionThread()
	CreateAndShowObjectiveMessage(LookMessage);
	-- endLookUp is a bool set in the composition_narrative script file when the player looks.
	SleepUntil([|(TableRepository.GetOrRegisterTable("AcademyNarrative").endLookUp == true)], 1);
	DisableObjectiveMessage();
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_controls_title", "academy_tip_settings", tutorialTipDisplaySeconds);
end

function Tutorial_PlayIntro():void
	SleepUntil([|NarrativeInterface.SequenceIsCompleted("TUTORIAL_INTRO")], 1);
end

-- function  called as the end script for the pelican track in nar_mp_academy_pelican_intro_01 in the narrative layer of sgh_interlock.
function ReplaceCinematicPelican():void
	object_create("intro_pelican");
	Object_SetObjectCannotTakeDamage(OBJECTS.intro_pelican, true);
	object_set_function_variable(OBJECTS.intro_pelican, "fx_pelican_exhaust_steam", 1, 1)
end

function lookpelicanflightpath():void	
	local actorUnit = ai_get_unit(ai_current_actor);
	local actorUnitVehicle = Unit_GetVehicle(actorUnit);
	ai_cannot_die(ai_current_actor, true);
	cs_fly_to(ai_current_actor, true, POINTS.look_pelican_pointset.land_air);
	cs_fly_to(ai_current_actor, true, POINTS.look_pelican_pointset.land_air_01);
	cs_fly_to(ai_current_actor, true, POINTS.look_pelican_pointset.land_ground, .1);
	object_destroy(actorUnitVehicle);
end

global SuspendTimerThreadIndex = nil;
function SuspendTimerThread()
	repeat
		RoundTimer_SetSecondsLeft(1800);
		Sleep(1);
	until Engine_GetRoundIndex() == 1 or timedMovementDrill == true;
end
-- Linear scripting threads

function Tutorial_StartUpThread()
	SleepUntil([|Player_GetUnit(PLAYERS.player0) ~= nil], 1);
	--send the telemetry event that the mission is now in progress
	CreateThread(Tutorial_BeginMissionTelemetryThread);

	--start the opening thread 
	CreateThread(Tutorial_EntranceThread);
end

function Tutorial_EntranceThread()
	MPLuaCall("__OnTutorialStart");
	RegisterGlobalEvent(g_eventTypes.playerSpawnEvent, HandlePlayerArmorOnRespawn);
	pelicanIdleCollisionObject = object_create("commander_pelican_idle_collision");
	SetProtectedObjects();
	if Academy_GenericFlag1 == false then
		handleFlocks();
		CreateObjectiveBanner();
		createAmbientPelican();
		NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_pelican_exit_2");
		NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_pelican_exit_3");
		local facilityEntranceNavpoint = CreateObjectNavpoint(OBJECTS.facility_entrance_navpoint, defaultNavpointType, nil);
		--handle move instruction banner and quick tip in a thread so we don't sleep past the player entering the facility
		CreateThread(HandleMoveBannerInstructionThread);
		SleepUntil([|volume_test_players(VOLUMES.facilityentrance) == true], 1);
		NarrativeInterface.PlayNarrativeSequence("TUTORIAL_INTRO_HALLWAY_AMBIENT_MARINES");
		Device_SetDesiredPosition(OBJECTS.facility_entrance_door_machine, 1);
		Navpoint_Delete(facilityEntranceNavpoint);
		CreateThread(HandleAIRoomNavpoint);
	end
end

function HandleMoveBannerInstructionThread()
	CreateAndShowObjectiveMessage(MoveMessage);
	SleepSeconds(5);
	DisableObjectiveMessage();
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_controls_title", "academy_tip_settings", tutorialTipDisplaySeconds);
end

function SetProtectedObjects()
	--add any objects we want to protect from player damage here
	object_cannot_take_damage(OBJECTS.unsc_prop_door_keypad_a__cr04);
end

function hudIntroAnimation():void
	-- animates the HUD into the position like campaign.
	SendBroadcastCuiEvent("hud_transition_on_start");
	hud_show_crosshair(false);
	hud_show_shield(false);
	hud_show_radar(false);
	hud_show(true);
	--necessary right now to showcase the animation as it's not blocking.
	SleepSeconds(2);
end

function createIntroFlocks(flockstring:string):void
	flock_start(flockstring);
	SleepUntil([|flock_start(flockstring) == true], 1);
	flock_stop(flockstring);
end

function handleFlocks():void
	local introFlocksTable = {
		"pelican_flock",
		"pelican_flock_01",
		"pelican_flock_02"};
	for _, flock in hpairs(introFlocksTable) do
		createIntroFlocks(flock);
	end
	
end

function createAmbientPelican():void
	ai_place(AI.pelican_look);
end

--function that handles all of the hud, ammo, and weapon state settings we want to set 
function SetPlayerStartState()
	local playerUnit = Player_GetUnit(PLAYERS.player0);
	object_cannot_die_except_kill_volumes(playerUnit, true);
	hud_show_shield(false);
	hud_show_radar(false);
	hud_show_ability(false);
	hud_show_weapon(false);
	CreateAndPlaceUnarmedWeapon(PLAYERS.player0);
	hud_show_weapon_messaging(false);
	player_disable_weapon_pickup(true);
	Unit_EmptyAmmo(playerUnit);
	Unit_EmptyGrenadeInventory(playerUnit);
	Player_SetFirstPersonHandsOverride("multi_tutorial_player");
	object_set_variant(playerUnit, "multi_tutorial_player");
end

-- Hacky workaround because the weapon doesn't get added correctly via loadouts so sandbox can fix that issue and review the animations.
function CreateAndPlaceUnarmedWeapon(participant:player):void
	local placedunarmedweapon = Object_CreateFromTag(WeaponTags.unarmed);
	Unit_GiveWeapon(participant, placedunarmedweapon, WEAPON_ADDITION_METHOD.PrimaryWeapon);
end

function HandlePlayerArmorOnRespawn(eventArgs:PlayerSpawnEventStruct):void
	if eventArgs.player == PLAYERS.player0 then
		CreateThread(ResetPlayerArmorVariantThread);
	end
end

function ResetPlayerArmorVariantThread()
	local playerUnit = Player_GetUnit(PLAYERS.player0);
	object_set_variant(playerUnit, "multi_tutorial_player");
	Player_SetFirstPersonHandsOverride("multi_tutorial_player");
end

global wakeUpExitVolume:volume = VOLUMES.wakeupexitvolume;
function Tutorial_TransitThread()
	SleepUntil([|volume_test_players(wakeUpExitVolume) == true], 1);
	
	--close the door to the landing pad to prevent backtracking
	Device_SetDesiredPosition(OBJECTS.facility_entrance_door_machine, 0);

	-- delete the player's initial spawnpoint to avoid spawning there later
	Object_Delete(OBJECTS.tutorial_spawn_point);
end

function HandleAIRoomNavpoint():void
	SleepUntilSeconds([|TableRepository.GetOrRegisterTable("AcademyNarrative").DoorGreetComplete == true], 1);
	local aiRoomNavpoint = CreateObjectNavpoint(OBJECTS.ai_room_navpoint, defaultNavpointType, nil);
	SleepUntil([|volume_test_players(spawnAIVolume) == true], 1);
	CreateThread(CreateAIRoomMarines);
	Navpoint_Delete(aiRoomNavpoint);
end

function CreateAIRoomMarines():void
	NarrativeInterface.PlayNarrativeSequence("TUTORIAL_AI_ROOM_AMBIENT_MARINES");
end

global spawnAIVolume:volume = VOLUMES.spawnaivolume;
global pickAIVolume:volume = VOLUMES.pickai;
global aiSelectNavpoint = nil;

function Tutorial_PickAIThread()
	SleepUntil([|volume_test_players(spawnAIVolume) == true], 1);
	RegisterEvent(g_eventTypes.objectInteractEvent, TutorialPickAIInteract, OBJECTS.personal_ai_control);
	CreateEffectGroup(EFFECTS.academy_airoom_fog_door);
	Device_SetDesiredPosition(OBJECTS.ai_selection_entrance_door_machine, 1);
	Device_SetPower(OBJECTS.personal_ai_control, 0);
	Device_SetPower(OBJECTS.movement_course_unlock_terminal, 0);
	SleepUntil([|volume_test_players(VOLUMES.begin_ai_dialogue) == true], 1);
	aiSelectNavpoint = CreateObjectNavpoint(OBJECTS.ai_terminal_navpoint, defaultNavpointType, nil);
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_ai_intro_4");
	SleepUntil([|(volume_test_players(VOLUMES.create_ai_volume) == true) or (TableRepository.GetOrRegisterTable("AcademyNarrative").AIDescriptionComplete == true)], 1);
	Navpoint_Delete(aiSelectNavpoint);
	CreateAI();
	SleepUntil([|volume_test_players(VOLUMES.forcemoveaivolume) == true], 1);
	Player_ControlMoveToPoint(PLAYERS.player0, OBJECTS.ai_select_lock_position, 1, 0.1, 2);
	SleepUntil([|player_control_move_to_active(PLAYERS.player0) == false], 1);
	player_disable_movement(true, PLAYERS.player0);
	--close the door behind the player because we know they can't move
	Device_SetDesiredPosition(OBJECTS.ai_selection_entrance_door_machine, 0);
	MPLuaCall("__OnAIRoomEnter");
	SleepUntilSeconds([|TableRepository.GetOrRegisterTable("AcademyNarrative").AIDescriptionComplete == true], 1);
	PersonalAI_PlayAnimationList(PLAYERS.player0, PERSONAL_AI_ANIMATION_TYPE.EmoteGreeting, PERSONAL_AI_ANIMATION_TYPE.EmotePositive, PERSONAL_AI_ANIMATION_TYPE.Idle);
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_ai_shields_1");
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_ai_intro_4_alt");
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_ai_select_2");
	player_disable_movement(false, PLAYERS.player0);
	CreateAndShowObjectiveMessage(pickAIMessage);
	Device_SetPower(OBJECTS.personal_ai_control, 1);
	Device_SetPrimaryActionStringOverride(OBJECTS.personal_ai_control, "tutorial_select_ai");
end

function AIBootShieldsThread()
	MPLuaCall("__OnSpartanAIMergeComplete");
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("TUTORIAL_AI_MOMENT");
	--block the player's movement when they exit the composition
	PlayerControlFadeOutAllInputForPlayer(PLAYERS.player0, 0);
	Tutorial_DismissibleDialogueEvent("PERSONALAI_TITLE", "PERSONALAI_TEXT");
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_ai_shields_2");
	local playerUnit = Player_GetUnit(PLAYERS.player0);
	Object_SetShieldStun(playerUnit, .5);
	--sleep for pacing
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_ai_shields_3");
	Object_SetFunctionValue(OBJECTS.unsc_mp_academy_airoom_terminal_rotating_platform_a, "is_enter", 1, 0);
	SleepUntil([|object_get_function_value(OBJECTS.unsc_mp_academy_airoom_terminal_rotating_platform_a, "is_enter") == 1], 1);

	--sleep for pacing
	SleepSeconds(0.5);
	--return movement to the player now that the machine has moved and dialogue is complete
	PlayerControlFadeInAllInputForPlayer(PLAYERS.player0, 0);
	--NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_ai_door_hack_1");
	--NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_ai_door_hack_2");
	NarrativeInterface.PlayNarrativeSequence("TUTORIAL_AI_OUTRO");
	NarrativeInterface.PlayNarrativeSequence("TUTORIAL_AI_HACK_REMINDER");
	CreateThread(HackTutorialThread);
end

function Tutorial_DismissibleDialogueEvent(screentitle:string, text:string)
	--guard to make sure we're running the game variant	
	dismissibleDialogueWithStringIdFunc = _G["DismissibleDialogueWithStringId"];
	
	if dismissibleDialogueWithStringIdFunc ~= nil then
		dismissibleDialogDisplaying = true;
		dismissibleDialogueWithStringIdFunc(screentitle, text,
		function() 
			dismissibleDialogDisplaying = false; 
		end);
	end
	--sleep to block other functions until the player dismisses the screen.
	SleepUntil([|dismissibleDialogDisplaying == false], 1);
end

function CreateAI():void
	CreateEffectGroup(EFFECTS.academy_hologram_bigplinth_glowsheet_rampup);
	--sleep for effect timing
	SleepSeconds(1);
	PersonalAI_ForcePlaceAtObject(PLAYERS.player0, OBJECTS.unsc_mp_academy_airoom_terminal_rotating_platform_a);
	MPLuaCall("__OnSpartanAISpawn", OBJECTS.unsc_mp_academy_airoom_terminal_rotating_platform_a);
	CreateEffectGroup(EFFECTS.academy_hologram_bigplinth_glowsheet);
	CreateEffectGroup(EFFECTS.academy_hologram_bigplinth);
	PersonalAI_PlayAnimation(PLAYERS.player0, PERSONAL_AI_ANIMATION_TYPE.Idle);
end

function TutorialPickAIInteract()
	UnregisterEvent(g_eventTypes.objectInteractEvent, TutorialPickAIInteract, OBJECTS.personal_ai_control);
	player_disable_movement(true, PLAYERS.player0);
	Device_SetPower(OBJECTS.personal_ai_control, 0);
	MPLuaCall("__OnSpartanAIMergeStart");
	DisableObjectiveMessage();
	RegisterGlobalEventOnce(g_eventTypes.personalAIAnimationCompleted, StartAINarrativeMoment);
	KillEffectGroup(EFFECTS.academy_hologram_bigplinth_glowsheet);
	KillEffectGroup(EFFECTS.academy_hologram_bigplinth);
	CreateEffectGroup(EFFECTS.academy_hologram_bigplinth_glowsheet_resolve);
	PersonalAI_Despawn(PLAYERS.player0, PERSONAL_AI_ANIMATION_TYPE.Despawn);
end

function StartAINarrativeMoment()
	CreateThread(AIBootShieldsThread);
end

global hackBuddy:object = nil;
global weaponRangeDoorDeviceMachine:object = OBJECTS.hack_tutorial_door_machine;
global hackBuddyNavpoint = nil;

function HackTutorialThread()
	RegisterEvent(g_eventTypes.objectInteractEvent, HackTutorialDoorInteract, OBJECTS.movement_course_unlock_terminal);
	RegisterEvent(g_eventTypes.deviceInteractionReleasedEvent, HackTutorialDoorInterrupt, OBJECTS.movement_course_unlock_terminal);
	RegisterEvent(g_eventTypes.deviceInteractionStartedEvent, HackTutorialDoorStart, OBJECTS.movement_course_unlock_terminal);
	hackBuddyNavpoint = CreateObjectNavpoint(OBJECTS.movement_course_unlock_terminal, aiTerminalNavpointType, hackNavpointText);
	Navpoint_SetPositionOffset(hackBuddyNavpoint, vector(0,0,0.5));
	Device_SetPrimaryActionStringOverride(OBJECTS.movement_course_unlock_terminal, "tutorial_generic_ai");
	Device_SetPower(OBJECTS.movement_course_unlock_terminal, 1);
end

function HackTutorialDoorStart()
	TableRepository.GetOrRegisterTable("AcademyNarrative").MovementDoorOpen = true;
	Navpoint_Delete(hackBuddyNavpoint);
	if NarrativeInterface.ConversationIsActive("mpacademynarrative_academy_ai_door_hack_1") then
		NarrativeInterface.KillConversation("mpacademynarrative_academy_ai_door_hack_1");
	end
	MPLuaCall("__OnTutorialPlinthInteractStart");
end

global shouldPlayHackVO:boolean = true;
function HackTutorialVO():void
	if shouldPlayHackVO == true then
		NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_ai_door_hack_3");
		shouldPlayHackVO = false;
	end
end

function ManageHackBuddy():void
	PersonalAI_PlayAnimation(PLAYERS.player0, PERSONAL_AI_ANIMATION_TYPE.HackingEnter);
	PersonalAI_PlayAnimation(PLAYERS.player0, PERSONAL_AI_ANIMATION_TYPE.HackingLoop);
end

function HackTutorialDoorInterrupt()
	hackBuddyNavpoint = CreateObjectNavpoint(OBJECTS.movement_course_unlock_terminal, aiTerminalNavpointType, hackNavpointText);
	Navpoint_SetPositionOffset(hackBuddyNavpoint, vector(0,0,0.5));
	MPLuaCall("__OnTutorialPlinthInteractInterrupt");
end

function HackTutorialDoorInteract()
	Device_SetPower(OBJECTS.movement_course_unlock_terminal, 0);
	DisableObjectiveMessage();
	UnregisterEvent(g_eventTypes.objectInteractEvent, HackTutorialDoorInteract, OBJECTS.movement_course_unlock_terminal);
	UnregisterEvent(g_eventTypes.deviceInteractionReleasedEvent, HackTutorialDoorInterrupt, OBJECTS.movement_course_unlock_terminal);
	UnregisterEvent(g_eventTypes.deviceInteractionStartedEvent, HackTutorialDoorStart, OBJECTS.movement_course_unlock_terminal);
	CreateThread(HackTutorialDoorCompleteThread);
end

function HackTutorialDoorCompleteThread()
	Navpoint_Delete(hackBuddyNavpoint);
	CreateEffectGroup(EFFECTS.academy_hologram_smallplinth_ai_lab);
	PersonalAI_ForcePlaceAtObject(PLAYERS.player0, OBJECTS.movement_course_unlock_terminal);
	MPLuaCall("__OnSpartanAISpawn", OBJECTS.movement_course_unlock_terminal);
	ManageHackBuddy();
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_ai_door_hack_3");
	SleepSeconds(aiHackingTimeSeconds);
	object_set_variant(OBJECTS.unsc_prop_door_keypad_a__cr04, "default");
	CreateEffectGroup(EFFECTS.academy_airoom_fog_door_02);
	Device_SetDesiredPosition(OBJECTS.hack_tutorial_door_machine, 1);
	StopEffectGroup(EFFECTS.academy_hologram_smallplinth_ai_lab);
	MPLuaCall("__OnTutorialPlinthInteractComplete");
	PersonalAI_Despawn(PLAYERS.player0, PERSONAL_AI_ANIMATION_TYPE.Despawn);
	-- the player has hacked the door into the movement gym, so send the telemetry event that the mission has progressed
	Tutorial_UpdateMissionProgress("Multiplayer_Tutorial_AISelection");
	NarrativeInterface.PlayNarrativeSequence("TUTORIAL_MOVEMENT_YARD_AMBIENT_MARINES");
	aiRoomHacked = true;
end

global swPickedUp:boolean = false;
global arPickedUp:boolean = false;

global weaponRangeVolume:volume = VOLUMES.weaponrange;
global weaponRangeExitVolume:volume = VOLUMES.weaponrangeexit;
global ARTarget:ai = AI.ar_target;
global CRTarget:ai = AI.cr_target;
global weaponRangeExitDoor:object = OBJECTS.weapon_range_exit_door_machine;
global sidearmPistol = nil;


global weaponStorageVolume = VOLUMES.weaponstorage;
global weaponPickupNavpoint = nil;
global weaponRangeNavpoint = nil;
global weaponRangeMessage = "academy_range";
global initialPrimary = nil;
global armoryWeaponPickedUp:boolean = false;

function CleanUpCourseAnimations()
	-- all composer show variables defined in sgh_interlock_tutorial_composition_narrative.lua
	if console_marines_show ~= nil and composer_show_is_playing(console_marines_show) then
		composer_stop_show(console_marines_show);
		DeactivateKitHandleAsync(console_marines_show_kit);
	end
	if course_marines_show ~= nil and composer_show_is_playing(course_marines_show) then 
		composer_stop_show(course_marines_show);
		DeactivateKitHandleAsync(course_marines_show_kit);
	end
	if news_marines_show ~= nil and composer_show_is_playing(news_marines_show) then
		composer_stop_show(news_marines_show);
		DeactivateKitHandleAsync(news_marines_show_kit);
	end
end

function Tutorial_WeaponStorageThread()
	SleepUntil([|volume_test_players(VOLUMES.weaponstorage) == true], 1);
	UnregisterTimedMovementEvents();
	KillThread(movementYardThreadIndex);
	local playerUnit = Player_GetUnit(PLAYERS.player0);
	initialPrimary = Object_GetDefinition(Unit_GetPrimaryWeapon(Player_GetUnit(PLAYERS.player0)));
	RunClientScript("SendUIEvent_Client", "academy_widget_hide");
	AcademyHUD_TimerOnly = false;
	RegisterGlobalEvent(g_eventTypes.weaponPickupForAmmoRefillEvent, HandleArmoryPickupForAmmo);
	RegisterGlobalEvent(g_eventTypes.weaponPickupForAmmoRefillEvent, ClearArmoryAmmo);
	RegisterGlobalEvent(g_eventTypes.weaponPickupEvent, HandleArmoryPickup);
	Device_SetDesiredPosition(OBJECTS.armory_entrance_door_machine, 1);
	Device_SetPower(OBJECTS.weapon_range_unlock_control, 0);
	-- close the door to the movement yard to prevent backtracking
	Device_SetDesiredPosition(OBJECTS.yard_exit_door_machine, 0);
	CleanUpCourseAnimations();
	SleepUntil([|volume_test_players(VOLUMES.armoryintro) == true], 1);
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_armory_1");
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_armory_2");
	player_disable_weapon_pickup(false);
	-- if the player has already picked up the weapon, don't tell them to do it again
	if armoryWeaponPickedUp == false then
		handlePlayerAssaultRifle();
		weaponPickupNavpoint = CreateObjectNavpoint(OBJECTS.ar_pickup_navpoint, exploreNavpoint, pickupObjectNavpointText);
	end
	CreateThread(WeaponPickupReminderVOThread);
end

function handlePlayerAssaultRifle():void
	SpawnLockerAssaultRifle();
end

function ClearArmoryAmmo():void
	Unit_EmptyAmmo(PLAYERS.player0);
end

function Tutorial_ArmoryPickupHelper(weapon)
	if armoryWeaponPickedUp == false then
		CreateThread(WeaponRangeSpinUp, weapon);
	end
	armoryWeaponPickedUp = true;
end

function HandleArmoryPickupForAmmo(eventArgs:WeaponPickupForAmmoRefillEventStruct):void
	Tutorial_ArmoryPickupHelper(eventArgs.weapon);
end

function HandleArmoryPickup(eventArgs:WeaponPickupEventStruct):void
	Tutorial_ArmoryPickupHelper(eventArgs.weapon);
end

function WeaponPickupReminderVOThread()
	SleepSeconds(tutorialPromptDelaySeconds);
	if armoryWeaponPickedUp == false then
		NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_armory_idle_1");
		if weaponPickupNavpoint ~= nil then
			Navpoint_SetEnabled(weaponPickupNavpoint, false);
			Sleep(1);
			Navpoint_SetEnabled(weaponPickupNavpoint, true);
		end
	end
end

function WeaponDropThread()
	local isDone = false;
	repeat
		if(Object_GetDefinition(Unit_GetPrimaryWeapon(Player_GetUnit(PLAYERS.player0))) == initialPrimary) then
			Object_RequestWeaponSwitchAction(Player_GetUnit(PLAYERS.player0));
		else
            Unit_DropWeapon(Player_GetUnit(PLAYERS.player0), Unit_GetBackpackWeapon(Player_GetUnit(PLAYERS.player0)));
            isDone = true;
		end
		Sleep(1);
	until isDone == true;
end

function WeaponRangeSpinUp(pickedUpWeapon:object):void
	player_disable_weapon_pickup(true);
	UnregisterGlobalEvent(g_eventTypes.weaponPickupForAmmoRefillEvent, HandleArmoryPickupForAmmo);
	UnregisterGlobalEvent(g_eventTypes.weaponPickupEvent, HandleArmoryPickup);
	local playerUnit = Player_GetUnit(PLAYERS.player0);
	hud_show_weapon(true);
	DisableObjectiveMessage();
	CreateThread(WeaponDropThread);
	Navpoint_Delete(weaponPickupNavpoint);
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_armory_pickup_1");
	CreateThread(WeaponRangeHackTip);
	if weaponRangeNavpoint == nil then
		weaponRangeNavpoint = CreateObjectNavpoint(OBJECTS.weapon_range_unlock_control, aiTerminalNavpointType, hackNavpointText);
	end
	RegisterEvent(g_eventTypes.objectInteractEvent, WeaponRangeUnlockInteract, OBJECTS.weapon_range_unlock_control);
	RegisterEvent(g_eventTypes.deviceInteractionStartedEvent, WeaponRangeUnlockStarted, OBJECTS.weapon_range_unlock_control);
	RegisterEvent(g_eventTypes.deviceInteractionReleasedEvent, WeaponRangeUnlockInterrupt, OBJECTS.weapon_range_unlock_control);
	Navpoint_SetPositionOffset(weaponRangeNavpoint, vector(0,0,0.5));
	Device_SetPrimaryActionStringOverride(OBJECTS.weapon_range_unlock_control, "tutorial_generic_ai");
	Device_SetPower(OBJECTS.weapon_range_unlock_control, 1);
end

function WeaponRangeHackTip():void	
	SleepSeconds(tutorialPromptDelaySeconds);
	if(weaponRangeDoorOpen == false) then
		TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_personalai_title", "training_deployai", tutorialTipDisplaySeconds);
	end
end

function WeaponRangeUnlockStarted()
	MPLuaCall("__OnTutorialPlinthInteractStart");
	Navpoint_Delete(weaponRangeNavpoint);
end

function WeaponRangeUnlockInterrupt()
	weaponRangeNavpoint = CreateObjectNavpoint(OBJECTS.weapon_range_unlock_control, aiTerminalNavpointType, hackNavpointText);
	Navpoint_SetPositionOffset(weaponRangeNavpoint, vector(0,0,0.5));
	MPLuaCall("__OnTutorialPlinthInteractInterrupt");
end

function WeaponRangeUnlockInteract()
	CreateThread(WeaponRangeUnlockThread);
end

function WeaponRangeUnlockThread()
	Device_SetPower(OBJECTS.weapon_range_unlock_control, 0);
	UnregisterEvent(g_eventTypes.objectInteractEvent, WeaponRangeUnlockInteract, OBJECTS.weapon_range_unlock_control);
	UnregisterEvent(g_eventTypes.deviceInteractionStartedEvent, WeaponRangeUnlockStarted, OBJECTS.weapon_range_unlock_control);
	UnregisterEvent(g_eventTypes.deviceInteractionReleasedEvent, WeaponRangeUnlockInterrupt, OBJECTS.weapon_range_unlock_control);
	Navpoint_Delete(weaponRangeNavpoint);
	PlayerControlFadeOutAllInputForPlayer(PLAYERS.player0);
	CreateEffectGroup(EFFECTS.academy_hologram_smallplinth_weapon_range);
	PersonalAI_ForcePlaceAtObject(PLAYERS.player0, OBJECTS.weapon_range_unlock_control);
	MPLuaCall("__OnSpartanAISpawn", OBJECTS.weapon_range_unlock_control);
	ManageHackBuddy();
	player_control_lock_gaze(PLAYERS.player0, Object_GetPosition(OBJECTS.weaponrange_navpoint), 60);
	SleepSeconds(2);
	PersonalAI_Despawn(PLAYERS.player0, PERSONAL_AI_ANIMATION_TYPE.Despawn);
	player_control_unlock_gaze(PLAYERS.player0);
	MPLuaCall("__OnTutorialPlinthInteractComplete");
	StopEffectGroup(EFFECTS.academy_hologram_smallplinth_weapon_range);
	Device_SetDesiredPosition(OBJECTS.weapon_range_unlock_control, 1);
	weaponRangeDoorOpen = true;
	CreateThread(Tutorial_WeaponRangeThread);
end

global movementYardNavpoint = nil;
global crouchNavpoint = nil;
global jumpNavpoint = nil;
global gruntTransitionNavpoint = nil;
global sprintNavpoint = nil;

global jumpReminderVOThreadIndex = nil;
global courseExitReminderVOThreadIndex = nil;
global crouchReminderVOThreadIndex = nil;

global sprintVolume:volume = VOLUMES.sprinttutorial;

function ClearMovementCourseContent()
	if jumpNavpoint ~= nil then
		Navpoint_Delete(jumpNavpoint);
	end
	if clamberNavpoint ~= nil then
		Navpoint_Delete(clamberNavpoint);
	end
	if crouchNavpoint ~= nil then
		Navpoint_Delete(crouchNavpoint);
	end
	if gruntTransitionNavpoint ~= nil then
		Navpoint_Delete(gruntTransitionNavpoint);
	end
	if jumpReminderVOThreadIndex ~= nil then
		KillThread(jumpReminderVOThreadIndex);
	end
	if courseExitReminderVOThreadIndex ~= nil then
		KillThread(courseExitReminderVOThreadIndex);
	end
	if crouchReminderVOThreadIndex ~= nil then
		KillThread(crouchReminderVOThreadIndex);
	end
end

function Tutorial_MovementSprintThread()
	SleepUntil([|volume_test_players(sprintVolume) == true], 1);
	CreateThread(Tutorial_SlideTutorialThread);
	RunClientScript("DisplaySprintMessage", sprintHoldMessage, sprintMessage);
	SleepUntil([|volume_test_players(sprintVolume) == false], 1);
	DisableObjectiveMessage();
	
end

function Tutorial_SlideTutorialThread()
	SleepUntil([|volume_test_players(VOLUMES.slidetutorial) == true], 1);
	-- Temporarily removing this until we can change quick tip text depending on a player's local toggle/hold settings.
	-- RunClientScript("DisplaySlideQuickTip", "academy_tip_slide_on_hold", "academy_tip_slide");
end

function remoteServer.TutorialSlideQuickTip(slide:string)
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_slide_title", slide, tutorialTipDisplaySeconds);
end

global crouchVolume:volume = VOLUMES.crouchtutorial;
global crouchConfirm:volume = VOLUMES.crouchconfirm;

function Tutorial_MovementCrouchThread()
	SleepUntil([|volume_test_players(crouchVolume) == true], 1);
	crouchReminderVOThreadIndex = CreateThread(DialogueReminderThread, crouchConfirm, "mpacademynarrative_academy_obstacle_crouch_1", OBJECTS.crouch_navpoint, crouchNavpoint, crouchConfirm);
	--delete any previous navpoints if they have been skipped by the player
	if jumpNavpoint ~= nil then
		Navpoint_Delete(jumpNavpoint);
	end
	if clamberNavpoint ~= nil then
		Navpoint_Delete(clamberNavpoint);
	end
	crouchNavpoint = CreateObjectNavpoint(OBJECTS.crouch_navpoint, defaultNavpointType, nil);   
	Navpoint_SetVisibleOffscreen(crouchNavpoint, false);
	RunClientScript("DisplayCrouchMessage", crouchHoldMessage, crouchMessage);
	SleepUntil([|volume_test_players(crouchVolume) == false], 1);
	DisableObjectiveMessage();
	Navpoint_Delete(crouchNavpoint);
	CreateThread(Tutorial_MeleeThread);
end

function Tutorial_GruntTransitionThread():void
	SleepUntil([|volume_test_players(crouchConfirm) == true], 1);
	--delete any previous navpoints if they have been skipped by the player
	if jumpNavpoint ~= nil then
		Navpoint_Delete(jumpNavpoint);
	end
	if clamberNavpoint ~= nil then
		Navpoint_Delete(clamberNavpoint);
	end
	if crouchNavpoint ~= nil then
		Navpoint_Delete(crouchNavpoint);
	end
	if gruntTransitionNavpoint == nil then
		gruntTransitionNavpoint = CreateObjectNavpoint(OBJECTS.grunt_transition_navpoint, defaultNavpointType, nil);
	end
	SleepUntil([|volume_test_players(crouchConfirm) == false], 1);
	Navpoint_Delete(gruntTransitionNavpoint);
end

function CleanUpIntroAnimations()
	-- all composition show variables defined in sgh_interlock_tutorial_composition_narrative.lua
	if pelican_commander_idle_show ~= nil and composer_show_is_playing(pelican_commander_idle_show) then
		composer_stop_show(pelican_commander_idle_show);
		DeactivateKitHandleAsync(pelican_commander_idle_show_kit);
		DeactivateKitHandleAsync(pelican_intro_camera_idle_show_kit);
		DeactivateKitHandleAsync(pelican_commander_idle_show_kit);
	end
	if guard_marines_show ~= nil and composer_show_is_playing(guard_marines_show) then
		composer_stop_show(guard_marines_show);
		DeactivateKitHandleAsync(guard_marines_show_kit);
	end
	if war_stories_marines_show ~= nil and composer_show_is_playing(war_stories_marines_show) then
		composer_stop_show(war_stories_marines_show);
		DeactivateKitHandleAsync(war_stories_marines_show_kit);
	end
	if teaching_marines_show ~= nil and composer_show_is_playing(teaching_marines_show) then
		composer_stop_show(teaching_marines_show);
		DeactivateKitHandleAsync(teaching_marines_show_kit);
	end
	if desk_marine_show ~= nil and composer_show_is_playing(desk_marine_show) then
		composer_stop_show(desk_marine_show);
		DeactivateKitHandleAsync(desk_marine_show_kit);
	end
	if tired_marines_show ~= nil and composer_show_is_playing(tired_marines_show) then
		composer_stop_show(tired_marines_show);
		DeactivateKitHandleAsync(tired_marines_show_kit);
	end

	--remove the collision object we had around the commander puppet
	Object_Delete(pelicanIdleCollisionObject);
end

function TimedMovementYardInteract():void
	Device_SetPrimaryActionStringOverride(OBJECTS.timed_movement_course_unlock_terminal, "tutorial_generic_ai");
	Device_SetInteractionHoldTime(OBJECTS.timed_movement_course_unlock_terminal, 2);
	RegisterTimedMovementEvents();
end

function PowerUpTimedYardPlinth(eventStruct:VolumeEventStruct):void
	Device_SetPower(OBJECTS.timed_movement_course_unlock_terminal, 1);
end

function PowerDownTimedYardPlinth(eventStruct:VolumeEventStruct):void
	Device_SetPower(OBJECTS.timed_movement_course_unlock_terminal, 0);
end

function CloseMovementYardEntrance():void
	MPLuaCall("__OnTutorialPlinthInteractStart");
	Device_SetDesiredPosition(OBJECTS.ai_selection_exit_machine, 0);
end

function OpenMovementYardEntrance():void
	MPLuaCall("__OnTutorialPlinthInteractInterrupt");
	if Device_GetPosition(OBJECTS.timed_movement_course_unlock_terminal) == 0 then
		Device_SetDesiredPosition(OBJECTS.ai_selection_exit_machine, 1);
	end
end

global timedMovementEventActivated = false;

function RegisterTimedMovementEvents():void	
	RegisterVolumeOnEnterEvent(VOLUMES.timed_movement_yard_volume, PowerUpTimedYardPlinth, PLAYERS.player0);
	RegisterVolumeOnExitEvent(VOLUMES.timed_movement_yard_volume, PowerDownTimedYardPlinth, PLAYERS.player0);
	RegisterEventOnce(g_eventTypes.deviceInteractionFinishedEvent, TimedMovementModeThread, OBJECTS.timed_movement_course_unlock_terminal);
	RegisterEvent(g_eventTypes.deviceInteractionStartedEvent, CloseMovementYardEntrance, OBJECTS.timed_movement_course_unlock_terminal);
	RegisterEvent(g_eventTypes.deviceInteractionReleasedEvent, OpenMovementYardEntrance, OBJECTS.timed_movement_course_unlock_terminal);
	timedMovementEventActivated = true;
end

function UnregisterTimedMovementEvents():void
	if timedMovementEventActivated == true then
		UnregisterEvent(g_eventTypes.deviceInteractionStartedEvent, OpenMovementYardEntrance, OBJECTS.timed_movement_course_unlock_terminal);
		UnregisterEvent(g_eventTypes.deviceInteractionInterruptedEvent, CloseMovementYardEntrance, OBJECTS.timed_movement_course_unlock_terminal);
		UnregisterVolumeOnEnterEvent(VOLUMES.timed_movement_yard_volume, PowerUpTimedYardPlinth, PLAYERS.player0);
		UnregisterVolumeOnExitEvent(VOLUMES.timed_movement_yard_volume, PowerDownTimedYardPlinth, PLAYERS.player0);
		timedMovementEventActivated = false;
	end
end

global aiRoomHacked = false;
global BruteJumpFallBreadcrumbThreadIndex = nil;
global bruteJumpNavpointThreadIndex = nil;
global bruteJumpNavpoint01ThreadIndex = nil;
global bruteJumpNavpoint02ThreadIndex = nil;
global bruteJumpNavpoint03ThreadIndex = nil;
global bruteJumpNavpoint04ThreadIndex = nil;
global bruteJumpNavpoint = nil;
global bruteJumpNavpoint01 = nil;
global bruteJumpNavpoint02 = nil;
global bruteJumpNavpoint03 = nil;
global bruteJumpNavpoint04 = nil;

function Tutorial_MovementIntroductionThread()
	SleepUntil([|aiRoomHacked == true], 1);
	movementYardThreadIndex = CreateThread(TimedMovementYardInteract);
	CleanUpIntroAnimations();
	CreateThread(CloseAIRoomDoorThread);
	RegisterEvent(g_eventTypes.objectDamagedEvent, HandleMeleeComplete, OBJECTS.grunt_melee_target_01);
	RegisterEvent(g_eventTypes.objectDamagedEvent, HandleMeleeComplete, OBJECTS.grunt_melee_target_02);
	RegisterEvent(g_eventTypes.objectDamagedEvent, HandleMeleeComplete, OBJECTS.grunt_melee_target_03);
	RegisterEvent(g_eventTypes.objectDamagedEvent, HandleMeleeComplete, OBJECTS.grunt_melee_target_04);
	Device_SetDesiredPosition(OBJECTS.ai_selection_exit_machine, 1);
	SleepUntil([|volume_test_players(VOLUMES.movementcourseintro) == true], 1);
	MPLuaCall("__OnMovementCourseStart");
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_obstacle_training_intro_1");
	if movementYardNavpoint == nil then
		movementYardNavpoint = CreateObjectNavpoint(OBJECTS.movement_yard_intro, defaultNavpointType, nil);
	end
	SleepUntil([|volume_test_players(VOLUMES.timedmovement) == true], 1);
	Navpoint_Delete(movementYardNavpoint);
	if jumpNavpoint == nil then
		jumpNavpoint = CreateObjectNavpoint(OBJECTS.jump_navpoint, defaultNavpointType, nil);
	end
	BruteJumpFallBreadcrumbThreadIndex = CreateThread(BruteJumpFallBreadcrumb);
end

function HandleMeleeComplete()
	UnregisterEvent(g_eventTypes.objectDamagedEvent, HandleMeleeComplete, OBJECTS.grunt_melee_target_01);
	UnregisterEvent(g_eventTypes.objectDamagedEvent, HandleMeleeComplete, OBJECTS.grunt_melee_target_02);
	UnregisterEvent(g_eventTypes.objectDamagedEvent, HandleMeleeComplete, OBJECTS.grunt_melee_target_03);
	UnregisterEvent(g_eventTypes.objectDamagedEvent, HandleMeleeComplete, OBJECTS.grunt_melee_target_04);
	CreateThread(PlayMeleeVOThread);
end

function PlayMeleeVOThread()
	--sleep for VO timing
	SleepSeconds(0.5);
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_obstacle_melee_1");
end

function CloseAIRoomDoorThread()
	SleepUntil([|volume_test_players(VOLUMES.closeaidoorvolume) == true], 1);
	Device_SetDesiredPosition(OBJECTS.hack_tutorial_door_machine, 0);
end

function BruteJumpFallBreadcrumb():void
	SleepUntil([|volume_test_players(VOLUMES.brutefallresetvolume) == true], 1);
	if bruteJumpNavpointThreadIndex == nil then
		bruteJumpNavpointThreadIndex = CreateThread(HandleBreadcrumbNavpoints, VOLUMES.brutefallresetvolume, bruteJumpNavpoint, OBJECTS.brute_jump_return_nav, VOLUMES.brutebreadcrumbvolume);
	end
	if bruteJumpNavpoint01ThreadIndex == nil then
		bruteJumpNavpoint01ThreadIndex = CreateThread(HandleBreadcrumbNavpoints, VOLUMES.brutebreadcrumbvolume, bruteJumpNavpoint01, OBJECTS.brute_jump_return_nav_01, VOLUMES.brutebreadcrumbvolume1);
	end
	if bruteJumpNavpoint03ThreadIndex == nil then
		bruteJumpNavpoint03ThreadIndex = CreateThread(HandleBreadcrumbNavpoints, VOLUMES.brutebreadcrumbvolume1, bruteJumpNavpoint03, OBJECTS.brute_jump_return_nav_03, VOLUMES.brutefallvolume);
		CreateThread(DisplayMoveJumpQuickTip);
	end
	if bruteJumpNavpoint04ThreadIndex == nil then
		bruteJumpNavpoint04ThreadIndex = CreateThread(HandleBreadcrumbNavpoints, VOLUMES.brutefallvolume, bruteJumpNavpoint04, OBJECTS.brute_jump_return_nav_04, VOLUMES.brutejumpendvolume);		
	end
end

function DisplayMoveJumpQuickTip():void
	SleepUntil([|volume_test_players(VOLUMES.brutebreadcrumbvol2) == true], 1);
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_move_jump_title", "academy_tip_move_jump", tutorialTipDisplaySeconds);
end

function HandleBreadcrumbNavpoints(createNavVolume:volume, nav:navpoint, navLocation:object, removeNavVolume:volume):void
	SleepUntil([|volume_test_players(createNavVolume) == true], 1);
	if nav == nil then
		nav = CreateObjectNavpoint(navLocation, defaultNavpointType, nil);
		SleepUntil([|volume_test_players(removeNavVolume) == true or volume_test_players(VOLUMES.yardcatwalk) == true], 1);
		Navpoint_Delete(nav);
	end
end

global movementTimedModeFound:boolean = false;

function TimedMovementModeThread():void
	CreateThread(Tutorial_MovementTimedMode);
end
function Tutorial_MovementTimedMode():void
	Device_SetDesiredPosition(OBJECTS.ai_selection_exit_machine, 0);
	Device_SetPower(OBJECTS.timed_movement_course_unlock_terminal, 0);
	UnregisterTimedMovementEvents();
	CreateEffectGroup(EFFECTS.academy_hologram_smallplinth_movement_course);
	PersonalAI_ForcePlaceAtObject(PLAYERS.player0, OBJECTS.timed_movement_course_unlock_terminal);
	PersonalAI_PlayAnimation(PLAYERS.player0, PERSONAL_AI_ANIMATION_TYPE.HackingEnter);
	PersonalAI_PlayAnimation(PLAYERS.player0, PERSONAL_AI_ANIMATION_TYPE.HackingLoop);
	SleepSeconds(1);
	PersonalAI_Despawn(PLAYERS.player0, PERSONAL_AI_ANIMATION_TYPE.Despawn);
	StopEffectGroup(EFFECTS.academy_hologram_smallplinth_movement_course);
	MPLuaCall("__OnTutorialPlinthInteractComplete");
	if movementTimedModeFound == false then
		NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_obstacle_movement_course_timer_1");
		movementTimedModeFound = true;
	end
	timedMovementDrill = true;
	AcademyHUD_TimerOnly = true;
	Tutorial_CreateCountdownUI();
	Tutorial_HandleCountdownTimer(countdownAmmount);
	Device_SetDesiredPosition(OBJECTS.ai_selection_exit_machine, 1);
	SleepUntil([|volume_test_players(VOLUMES.timedmovement) == true], 1);
	local engineTimer = Engine_GetRoundTimer();
	Timer_Stop(engineTimer);
	Timer_SetSecondsLeft(engineTimer, 0);
	RunClientScript("SendUIEvent_Client", "academy_widget_show");
	Timer_StartWithRate(engineTimer, -1.0);
	CreateThread(MovementTimedModeRestartThread, engineTimer);
end

function MovementTimedModeRestartThread(timedMode:timer)
	SleepUntil([|volume_test_players(VOLUMES.timed_course_finish_volume) == true], 1);
	Timer_Stop(timedMode);
	KillThread(movementYardThreadIndex);
	movementYardThreadIndex = CreateThread(TimedMovementYardInteract);
end

function Tutorial_CreateCountdownUI():void
	countdownBanner = Engine_CreateObjective("objective_message");
	Objective_Filter_SetPlayersAll(countdownBanner,Objective_Filter_CreatePlayerMaskFilter(countdownBanner), true);
end

function Tutorial_HandleCountdownTimer(countdownSeconds:number):void
	Objective_SetEnabled(countdownBanner, true);
	Objective_SetFormattedText(countdownBanner, countdownString, countdownSeconds);
	MPLuaCall("__OnChallengeCountdown");
	repeat
		if countdownSeconds > 0 then
			SleepSeconds (bufferTime);
			countdownSeconds = countdownSeconds - 1;
			if countdownSeconds > 0 and countdownSeconds <= 3 then
				MPLuaCall("__OnChallengeCountdown");
				Objective_SetFormattedText(countdownBanner, countdownString, countdownSeconds);
			elseif countdownSeconds == 0 then
				MPLuaCall("__OnChallengeCountdownComplete");
			end
		end
	until countdownSeconds <= 0;

	if countdownSeconds == 0 then
		Objective_SetFormattedText(countdownBanner, countdownStartString);
	end

	SleepSeconds (bufferTime);
	Objective_Delete(countdownBanner)
end

global jumpVolume:volume = VOLUMES.jumptutorial;
global jumpConfirm:volume = VOLUMES.jumpconfirm;

function Tutorial_MovementJumpThread()
	SleepUntil([|volume_test_players(jumpVolume) == true], 1);
	jumpReminderVOThreadIndex = CreateThread(DialogueReminderThread, jumpConfirm, "mpacademynarrative_academy_obstacle_training_intro_pickup_1", OBJECTS.jump_navpoint, jumpNavpoint, jumpConfirm);
	if jumpNavpoint == nil then
		jumpNavpoint = CreateObjectNavpoint(OBJECTS.jump_navpoint, defaultNavpointType, nil);
	end
	Navpoint_SetVisibleOffscreen(jumpNavpoint, false);
	CreateAndShowObjectiveMessage(jumpMessage);
	SleepUntil([|volume_test_players(jumpConfirm) == true], 1);
	DisableObjectiveMessage();
	Navpoint_Delete(jumpNavpoint);
	CreateThread(DisplayHelperQuickTipThread, VOLUMES.clambersuccess, "academy_tip_clamber_title", "academy_tip_clamber");
end

global clamberNavpoint = nil;

function Tutorial_MovementClamberThread()
	SleepUntil([|volume_test_players(VOLUMES.clambertutorial) == true], 1);
	--delete the previous navpoint if it hasn't already been deleted
	if jumpNavpoint ~= nil then
		Navpoint_Delete(jumpNavpoint);
	end
	if clamberNavpoint == nil then
		clamberNavpoint = CreateObjectNavpoint(OBJECTS.clamber_navpoint, defaultNavpointType, nil);
	end
	Navpoint_SetVisibleOffscreen(clamberNavpoint, false);
	SleepUntil([|volume_test_players(VOLUMES.clambersuccess) == true], 1);
	Navpoint_Delete(clamberNavpoint);
end

function Tutorial_MeleeThread()
	SleepUntil([|volume_test_players(VOLUMES.meleetutorial) == true], 1);
	CreateAndShowObjectiveMessage(meleeMessage);
	SleepUntil([|(volume_test_players(VOLUMES.meleetutorial) == false) or (player_action_test_melee() == true)], 1);
	DisableObjectiveMessage();
end

function Tutorial_MovementYardExitThread()
	SleepUntil([|volume_test_players(VOLUMES.yardcatwalk) == true or volume_test_players(VOLUMES.yardexit) == true], 1);
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_obstacle_outro_1");
	CreateThread(HandleNavpoint, OBJECTS.yard_exit_navpoint, VOLUMES.yardexit);
	MPLuaCall("__OnMovementCourseStop");
	courseExitReminderVOThreadIndex = CreateThread(DialogueReminderThread, VOLUMES.yardexit, "mpacademynarrative_academy_obstacle_wait", OBJECTS.yard_exit_navpoint, nil, VOLUMES.timed_course_finish_volume);
	Device_SetDesiredPosition(OBJECTS.yard_exit_door_machine, 1);
	SleepUntil([|volume_test_players(VOLUMES.timed_course_finish_volume) == true], 1);
	movementYardThreadIndex = CreateThread(TimedMovementYardInteract);
	if BruteJumpFallBreadcrumbThreadIndex ~= nil then
		KillThread(BruteJumpFallBreadcrumbThreadIndex);
	end	

	--activate the weapons in the armory
	SpawnLockerWeapons();

	-- the player has completed the movement yard, so fire a telemetry event that the mission should progress
	Tutorial_UpdateMissionProgress("Multiplayer_Tutorial_MovementGym");
end

function HandleNavpoint(navobject:object, vol:volume)
	local newNavpoint = CreateObjectNavpoint(navobject, defaultNavpointType, nil);
	SleepUntil([|volume_test_players(vol) == true], 1);
	Navpoint_Delete(newNavpoint);
end

function Tutorial_MovementTransitionToArmoryThread():void
	SleepUntil([|volume_test_players(VOLUMES.timed_course_finish_volume) == true], 1);

	--clear any remaining movement course navpoints or reminder VO if the player has skipped over it
	ClearMovementCourseContent();
	HandleNavpoint(OBJECTS.overlook_armory_navpoint, VOLUMES.overlook_armory_volume);
	HandleNavpoint(OBJECTS.armory_door_navpoint, VOLUMES.weaponstorage);
end

function CleanUpArmoryVO()
	if NarrativeInterface.SequenceIsActive("mpacademynarrative_academy_armory_pickup_1") then
		NarrativeInterface.KillConversation("mpacademynarrative_academy_armory_pickup_1");
	end
	if NarrativeInterface.SequenceIsActive("mpacademynarrative_academy_armory_idle_1") then
		NarrativeInterface.KillConversation("mpacademynarrative_academy_armory_idle_1");
	end
end

-- we start this thread once the player has interacted with the door unlock
global playerWeaponDropProperty = nil;

function Tutorial_WeaponRangeThread()
	CleanUpArmoryVO();
	
	if skipTutorialCinematics == false then
		Tutorial_PlayWeaponRangeIntro();
	end
	SleepUntil([|volume_test_players(VOLUMES.weaponrange) == true], 1);
	UnregisterGlobalEvent(g_eventTypes.weaponPickupForAmmoRefillEvent, ClearArmoryAmmo);
	NonScopedWeaponInstruction();
	ScopedWeaponInstruction(); 
	HeadshotShieldInstruction();
	GrenadeInstruction();
	Device_SetDesiredPosition(OBJECTS.weapon_range_door_machine, 1);
	--open all of the slidelocker gates
	CreateThread(OpenLockerGatesThread);
	RegisterGlobalEventOnce(g_eventTypes.weaponPickupEvent, HandleLockerReturnPickup);
	--sleep for VO timing
	SleepSeconds(1);
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_range_outro_1");
	MPLuaCall("__OnWeaponRangeStop");
	local weaponRangeExitNavpoint = CreateObjectNavpoint(OBJECTS.weaponrange_exit_navpoint, defaultNavpointType, interlockExitMessage);
	Device_SetDesiredPosition(OBJECTS.weapon_range_exit_door_machine, 1);
	CreateThread(ManageTargetSpawnerThread);
	CreateThread(RangeExitReminderVOThread);
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_weapon_drills_title", "academy_tip_weapon_drills", tutorialTipDisplaySeconds);
	SleepUntil([|volume_test_players(VOLUMES.interlocktransition) == true], 1);
	Navpoint_Delete(weaponRangeExitNavpoint);
	-- the player has successfully grabbed a weapon from the weapon storage area, so fire a telemetry event that the mission should progress
	Tutorial_UpdateMissionProgress("Multiplayer_Tutorial_WeaponStorage");
end

function CheckTargetShieldLevels(damageEvent):void
	if Unit_GetActor(Object_TryAndGetUnit(damageEvent.defender)) ~= nil and unit_get_shield(Object_TryAndGetUnit(damageEvent.defender)) <= 0 then
		TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_shields_title", "academy_tip_shields", tutorialTipDisplaySeconds);
		UnregisterEvent(g_eventTypes.objectDamagedEvent, CheckTargetShieldLevels, ARTarget);
	end
end

function Tutorial_PlayWeaponRangeIntro():void
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("TUTORIAL_WEAPON_RANGE_INTRO");
end

-- this function should be called prior to switching zonesets to academy_end
function SpawnLockerWeapons():void
	--store off the variant function to ensure we're in game
	local getAllWeaponPlacementsFunc = _G["GetAllWeaponPlacements"];

	if getAllWeaponPlacementsFunc ~= nil then
		local allWeaponSpawners:table = getAllWeaponPlacementsFunc();
		for i, placement in ipairs(allWeaponSpawners) do
			if placement ~= KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance then
				placement:TriggerItemSpawn();
			end
		end
	end
end

function SpawnLockerAssaultRifle():void
	KITS.player_assault_rifle_gate:HandleSlideLockerGateOpen();
	KITS.player_assault_rifle.mpWeaponPlacementInstance:TriggerItemSpawn();
end

function OpenLockerGatesThread()
	SleepUntil([|volume_test_players(VOLUMES.armory_return_volume) == true], 1);
	local openAllSlideLockerGatesFunc = _G["OpenAllSlideLockerGates"];
	if openAllSlideLockerGatesFunc ~= nil then
		openAllSlideLockerGatesFunc();
	end
end

global NonScopedWeapon = nil;
global ScopedWeapon = nil;

function NonScopedWeaponInstruction()
	ai_place(ARTarget);
	PlayTargetSpawnEffectOnSquad(ARTarget);
	RegisterEvent(g_eventTypes.objectDamagedEvent, CheckTargetShieldLevels, ARTarget);
	player_disable_movement(true, PLAYERS.player0);
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("ACADEMY_WEAPON_RANGE_2");
	ApplyRangeTargetNavpoint(ARTarget);
	MPLuaCall("__OnWeaponRangeStart");
	hud_show_weapon_messaging(true);
	player_disable_movement(false, PLAYERS.player0);
	Narrative_SetMomentControlParam(NARRATIVE_MOMENTS.stowweapon, "weaponup");
	Unit_ReadyWeapon(PLAYERS.player0, true, false, true);
	CreateThread(GivePlayerARAmmo);
	CreateAndShowObjectiveMessage(weaponFireMessage);
	SleepUntil([|Object_GetHealth(ARTarget) <= 0], 1);
	arAmmoComplete = true;
	DisableObjectiveMessage();
	--sleeps for VO timing
	SleepSeconds(1);
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_range_new_weapon_1");
end

function ApplyRangeTargetNavpoint(targetsquad:ai)
	for _, target in hpairs(Squad_GetActors(targetsquad)) do
		NavpointShowAI(target, "enemy", color_rgba(1, 0, 0, 1), nil);
	end	
end

global arAmmoComplete = false;

function GivePlayerARAmmo()
	local playerUnit = Player_GetUnit(PLAYERS.player0);
	repeat
		-- spawn a weapon for the player to use if they have no ammo
		SleepUntil([|(weapon_get_rounds_total(Unit_GetPrimaryWeapon(playerUnit), 0) == 0)], 1);
		if arAmmoComplete == false then
			if weapon_get_rounds_total(Unit_GetPrimaryWeapon(playerUnit), 0) == 0 then
				KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance.itemTag = (WeaponTags.assault_rifle);
				KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance:TriggerItemSpawn();
				if KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance.spawnedItemObject ~= nil then
					scopedNavpoint = CreateObjectNavpoint(KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance.spawnedItemObject, exploreNavpoint, pickupObjectNavpointText);
				end
				--sleep until the player has ammo
				SleepUntil([|(weapon_get_rounds_total(Unit_GetPrimaryWeapon(playerUnit), 0) ~= 0)], 1);
			end
			SleepSeconds(1);
		end
	until arAmmoComplete == true;
end

global disableRefillAmmo = false;
global scopedNavpoint = nil;

function ScopedWeaponInstruction()
	playerWeaponDropProperty = AddPlayerTimedMalleablePropertyModifierBool("biped_inventory_manual_weapon_drop_enabled", 0, false, PLAYERS.player0);
	player_disable_weapon_pickup(true);
	-- Ensuring the trunk places a Commando Rifle in case the player needed ammo for their AR earlier.
	KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance.itemTag = (WeaponTags.commando_rifle);
	KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance:TriggerItemSpawn();
	RegisterGlobalEventOnce(g_eventTypes.weaponPickupEvent, StartWeaponPickedup);
	SleepUntil([| NarrativeInterface.ConversationHasFinished("mpacademynarrative_academy_range_new_weapon_1") ], 1);
	if KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance.spawnedItemObject ~= nil then
		scopedNavpoint = CreateObjectNavpoint(KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance.spawnedItemObject, exploreNavpoint, pickupObjectNavpointText);
	end
	MPLuaCall("__OnObjectNavAppear", KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance.containerObject);
	player_disable_weapon_pickup(false);
	SleepUntil([|swPickedUp == true], 1);
	CreateThread(SpawnRangeWeaponForAmmoThread);
	Navpoint_Delete(scopedNavpoint);
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_range_scope_1");
	TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_weapon_zoom_title", "academy_tip_zoom", tutorialTipDisplaySeconds);
	RunClientScript("DisplayWeaponZoomMessage", weaponZoomHoldMessage, weaponZoomMessage);
	ai_place(CRTarget.cr_target_spawn_04);
	PlayTargetSpawnEffectOnSquad(CRTarget);
	ApplyRangeTargetNavpoint(CRTarget);
	SleepUntil([|Object_GetHealth(CRTarget) <= 0], 1);
	DisableObjectiveMessage();
end

function PlayTargetSpawnEffectOnSquad(targetSquad:ai)
	for _, target in hpairs(Squad_GetActors(targetSquad)) do
		RunClientScript("cl_CreateSpawnEffect", ai_get_unit(target));
	end
end

function HeadshotShieldInstruction()
	--sleep for VO timing
	SleepSeconds(1);
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_range_shields_1");
	ai_place(CRTarget.cr_target_spawn_02);
	PlayTargetSpawnEffectOnSquad(CRTarget);
	SleepUntil([|Object_GetHealth(CRTarget) <= 0], 1);
	--sleep for VO timing
	SleepSeconds(1);
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_range_pickup_1");
	ai_place(CRTarget.cr_target_spawn);
	ai_place(CRTarget.cr_target_spawn_01);
	ai_place(CRTarget.cr_target_spawn_03);
	PlayTargetSpawnEffectOnSquad(CRTarget);
	ApplyRangeTargetNavpoint(CRTarget);
	SleepUntil([|Object_GetHealth(CRTarget) <= 0], 1);
	disableRefillAmmo = true;
end

function GrenadeInstruction()
	-- restrict player grenade pickups
	AddPlayerTimedMalleablePropertyModifierBool("biped_inventory_grenade_pickup_allowed", 0, false, PLAYERS.player0);
	Unit_EmptyAmmo(PLAYERS.player0);
	--sleep for VO timing
	SleepSeconds(1);
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_range_pickup_2");
	-- Spawn grenade targets behind cover piece
	ai_place(AI.grenadetargets);
	PlayTargetSpawnEffectOnSquad(AI.grenadetargets);
	-- have the target crouch
	grenadetutorialcrouch = true;
	-- tell the player about grenades
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_range_grenades_pickup");
	-- mark the grenade location
	GrenadeTutorialNavpoint();
	RegisterGlobalEvent(g_eventTypes.grenadePickupEvent, PickupGrenadeStart);
	RegisterGlobalEventOnce(g_eventTypes.grenadeThrowEvent, OnGrenadeThrow);
	-- then give the player grenades
	PlaceTutorialGrenades();
	-- allow the player to pickup grenades
	AddPlayerTimedMalleablePropertyModifierBool("biped_inventory_grenade_pickup_allowed", 0, true, PLAYERS.player0);
	-- wait until the targets are dead
	SleepUntil([|ai_living_count(AI.grenadetargets) <= 0], 1);
	UnregisterGlobalEvent(g_eventTypes.grenadeThrowEvent, OnGrenadeThrow);
	NarrativeInterface.SleepUntil.PlayNarrativeSequence("mpacademynarrative_academy_range_grenades_pickup_2");
	playerWeaponDropProperty = AddPlayerTimedMalleablePropertyModifierBool("biped_inventory_manual_weapon_drop_enabled", 0, true, PLAYERS.player0);
	disableRefillAmmo = false;
end

global grenadePickedUp = false;

function PickupGrenadeStart(eventArgs:GrenadePickupEventStruct)
	ApplyRangeTargetNavpoint(AI.grenadetargets);
	UnregisterGlobalEvent(g_eventTypes.grenadePickupEvent, PickupGrenadeStart);
	grenadePickedUp = true;
	hud_show_ability(true);
	CreateThread(HandleGrenadePickup);
end

function HandleGrenadePickup():void
	Navpoint_Delete(grenadeSpawnerNavpoint);
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_range_grenades_pickup_1");
	if ShouldApplyOutlinesInAcademy == true then
		for _, target in hpairs(Squad_GetActors(AI.grenadetargets)) do
			RunClientScript("cl_CreateTargetOutline", ai_get_unit(target));
		end
	end
	CreateAndShowObjectiveMessage(grenadeThrowMessage);
	CreateThread(HandleRangeGrenadeAmmo);
end

function PlaceTutorialGrenades():void
	KITS.grenade_tutorial_dispenser.mpGrenadePlacementInstance:TriggerItemSpawn();
end

function StartTutorialGrenadeDispenser():void
	-- Starts the grenade dispenser kit script after zone set switch
	KITS.grenade_tutorial_dispenser:StartPlacementParcel();
end

function GrenadeTutorialNavpoint():void
	grenadeSpawnerNavpoint = CreateObjectNavpoint(KITS.grenade_tutorial_dispenser.mpGrenadePlacementInstance.containerObject, exploreNavpoint, pickupObjectNavpointText);
	Navpoint_SetPositionOffset(grenadeSpawnerNavpoint, vector(0,0,0.5));
end

function OnGrenadeThrow(eventArgs:GrenadeThrowEventStruct):void
	DisableObjectiveMessage();
end

-- events for the target spawner in the weapon range

global playerInteractedWithTargetSpawner:boolean = false;
global initialAmmoRefillGranted:boolean = false;

function SpawnRangeTargetsInteractStart()
	MPLuaCall("__OnTutorialPlinthInteractStart");
	Navpoint_Delete(spawnerNavpoint);
end

function SpawnRangeTargetsInteractInterrupt()
	MPLuaCall("__OnTutorialPlinthInteractInterrupt");
	spawnerNavpoint = CreateObjectNavpoint(OBJECTS.target_spawner_navpoint, aiTerminalNavpointType, "academy_target_spawn");
	Navpoint_SetVisibleOffscreen(spawnerNavpoint, false);
	Navpoint_SetColor(spawnerNavpoint, color_rgba(1,1,0,1));
end

function SpawnRangeTargetsInteractComplete(eventArgs:InteractEventStruct)
	CreateThread(HandleTargetSpawner);
end

function ManageTargetSpawnerThread()
	SleepSeconds(2);
	spawnerNavpoint = CreateObjectNavpoint(OBJECTS.target_spawner_navpoint, aiTerminalNavpointType, "academy_target_spawn");
	Device_SetPrimaryActionStringOverride(OBJECTS.spawn_target_control, "tutorial_spawn_targets");
	playerInteractedWithTargetSpawner = false;
	Device_SetPower(OBJECTS.spawn_target_control, 1);
	Navpoint_SetVisibleOffscreen(spawnerNavpoint, false);
	Navpoint_SetColor(spawnerNavpoint, color_rgba(1,1,0,1));	
	RegisterEvent(g_eventTypes.deviceInteractionStartedEvent, SpawnRangeTargetsInteractStart, OBJECTS.spawn_target_control);
	RegisterEvent(g_eventTypes.deviceInteractionReleasedEvent, SpawnRangeTargetsInteractInterrupt, OBJECTS.spawn_target_control);
	RegisterEvent(g_eventTypes.objectInteractEvent, SpawnRangeTargetsInteractComplete, OBJECTS.spawn_target_control);
	SleepUntil([|volume_test_players(weaponRangeExitVolume) == true], 1);	
	UnregisterEvent(g_eventTypes.deviceInteractionStartedEvent, SpawnRangeTargetsInteractStart, OBJECTS.spawn_target_control);
	UnregisterEvent(g_eventTypes.deviceInteractionReleasedEvent, SpawnRangeTargetsInteractInterrupt, OBJECTS.spawn_target_control);
	UnregisterEvent(g_eventTypes.objectInteractEvent, SpawnRangeTargetsInteractComplete, OBJECTS.spawn_target_control);
	Device_SetPower(OBJECTS.spawn_target_control, 0);
	Navpoint_Delete(spawnerNavpoint);

	-- the player has completed and exited the weapon range, so fire a telemetry event that the mission should progress
	Tutorial_UpdateMissionProgress("Multiplayer_Tutorial_WeaponRange");
end

function HandleLockerReturnPickup(eventArgs:WeaponPickupEventStruct)
	CreateThread(PlayArmoryLockerVOThread);
end

function PlayArmoryLockerVOThread()
	NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_armory_return_1");
end


function StartWeaponPickedup(eventArgs:WeaponPickupEventStruct)
	if eventArgs.player == PLAYERS.player0 then
		swPickedUp = true;
	end
end

global spawnerTarget = AI.spawner_target;
function HandleTargetSpawner()
	Device_SetPower(OBJECTS.spawn_target_control, 0);
	Bot_EnablePlayfighting = true;
	Navpoint_SetEnabled(spawnerNavpoint, false);
	CreateEffectGroup(EFFECTS.academy_hologram_smallplinth_target_reset);
	PersonalAI_ForcePlaceAtObject(PLAYERS.player0, OBJECTS.spawn_target_control);
	MPLuaCall("__OnSpartanAISpawn", OBJECTS.spawn_target_control);
	ManageHackBuddy();
	SleepSeconds(1);
	PersonalAI_Despawn(PLAYERS.player0, PERSONAL_AI_ANIMATION_TYPE.Despawn);
	StopEffectGroup(EFFECTS.academy_hologram_smallplinth_target_reset);
	MPLuaCall("__OnTutorialPlinthInteractComplete");
	if playerInteractedWithTargetSpawner == false then
		--create the ammo monitoring thread and say the VO line once
		CreateThread(SpawnRangeWeaponForAmmoThread);
		NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_range_startover_1");
		playerInteractedWithTargetSpawner = true;
	end

	PlaceTutorialGrenades();
	ai_place(spawnerTarget);
	PlayTargetSpawnEffectOnSquad(spawnerTarget);
	for _, target in hpairs(Squad_GetActors(spawnerTarget)) do
		NavpointShowAI(target, "enemy", color_rgba(1, 0, 0, 1), nil);
		if ShouldApplyOutlinesInAcademy == true then
			RunClientScript("cl_CreateTargetOutline", ai_get_unit(target));
		end
	end

	SleepUntil([|ai_living_count(spawnerTarget) <= 0], 1);
	SleepSeconds(1);
	Device_SetPower(OBJECTS.spawn_target_control, 1);
	Navpoint_SetEnabled(spawnerNavpoint, true);
end

global disableGrenadeRefillAmmo = false;

function HandleRangeGrenadeAmmo()
	local playerUnit = Player_GetUnit(PLAYERS.player0);

	repeat
		SleepUntil([|(unit_get_total_grenade_count(playerUnit) == 0)], 1);
		-- spawn a grenade for the player to use if they have none
		if unit_get_total_grenade_count(playerUnit) == 0 and disableGrenadeRefillAmmo == false then
			GrenadeTutorialNavpoint();
			PlaceTutorialGrenades();

			--sleep until the player has ammo
			SleepUntil([|(unit_get_total_grenade_count(playerUnit) ~= 0)], 1);
			Navpoint_Delete(grenadeSpawnerNavpoint);
		end
		SleepSeconds(1);
	until volume_test_players(VOLUMES.interlocktransition) == true;
end

function SpawnRangeWeaponForAmmoThread()

	local playerUnit = Player_GetUnit(PLAYERS.player0);

	repeat
		-- spawn a weapon for the player to use if they have no ammo
		if weapon_get_rounds_total(Unit_GetPrimaryWeapon(playerUnit), 0) == 0 and weapon_get_rounds_total(Unit_GetBackpackWeapon(playerUnit), 0) == 0 then
			KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance:TriggerItemSpawn();
			if KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance.spawnedItemObject ~= nil then
				scopedNavpoint = CreateObjectNavpoint(KITS.weapon_trunk_tutorial_dispenser.mpWeaponPlacementInstance.spawnedItemObject, exploreNavpoint, pickupObjectNavpointText);
			end
			--sleep until the player has ammo
			SleepUntil([|(weapon_get_rounds_total(Unit_GetPrimaryWeapon(playerUnit), 0) ~= 0) or (weapon_get_rounds_total(Unit_GetBackpackWeapon(playerUnit), 0) ~= 0)], 1);
		end
		SleepSeconds(1);
	until disableRefillAmmo == true or volume_test_players(VOLUMES.interlocktransition) == true;
end

global shouldPlayRangeExitReminderVO:boolean = true;

-- allow players plenty of time to get distracted by the armory lockers, but eventually prompt them to continue
function RangeExitReminderVOThread()
	SleepSeconds(120);
	if shouldPlayRangeExitReminderVO == true then
		NarrativeInterface.PlayNarrativeSequence("mpacademynarrative_academy_range_reminder_1");
	end
end

function Tutorial_InterlockTransitionThread()
	SleepUntil([|volume_test_players(VOLUMES.interlocktransition) == true], 1);
	disableGrenadeRefillAmmo = true;
	Navpoint_Delete(grenadeSpawnerNavpoint);
	if ai_living_count(spawnerTarget) > 0 then
		ai_erase(spawnerTarget);
	end
	UnregisterGlobalEvent(g_eventTypes.weaponPickupEvent, HandleLockerReturnPickup);
	Bot_EnablePlayfighting = false;
	shouldPlayRangeExitReminderVO = false;
	--close the door to the weapon range to prevent backtracking
	Device_SetDesiredPosition(OBJECTS.weapon_range_exit_door_machine, 0);	
	MPLuaCall("__OnInterlockTransition");
	-- kick off the academyLiveFireRun function from sgh_interlock_tutorial_livefire.lua
	academyLiveFireRun();	
end

-- weapon range command scripts

function applytargettreatment()
	if ShouldApplyOutlinesInAcademy == true then
		RunClientScript("cl_CreateTargetOutline", ai_get_unit(ai_current_actor));
	end
end

function maketargetcrouch()
	Unit_EmptyAmmo(ai_current_actor);
	Unit_EmptyGrenadeInventory(ai_current_actor);	
	cs_suppress_activity_termination(ai_current_actor, true);
	repeat
		local crouchInterval = random_range(.5, 1);
		cs_crouch(ai_current_actor, true);
		SleepSeconds(crouchInterval);
		cs_crouch(ai_current_actor, false);
		SleepSeconds(crouchInterval);
	until unit_get_health(ai_current_actor) <= 0;	
end

function staycrouched()
	Unit_EmptyAmmo(ai_current_actor);
	Unit_EmptyGrenadeInventory(ai_current_actor);	
	cs_suppress_activity_termination(ai_current_actor, true);
	cs_go_to_and_face(ai_current_actor, true, POINTS.grenadepoint.p01, Object_GetPosition(PLAYERS.player0));
	repeat
		if(grenadetutorialcrouch == false) then
			cs_pause(ai_current_actor, true, 1);
			Sleep(1);
		end
	until grenadetutorialcrouch == true;
	repeat
		local targetHealth = unit_get_health(ai_current_actor);
		if(targetHealth > 0) then
			local crouchInterval = random_range(.5, 1);
			cs_crouch(ai_current_actor, true);
			SleepSeconds(crouchInterval);
			cs_crouch(ai_current_actor, false);
			SleepSeconds(crouchInterval);
		end
	until unit_get_health(ai_current_actor) <= 0;	
end

function makezoombraindead()
	if ShouldApplyOutlinesInAcademy == true then
		RunClientScript("cl_CreateTargetOutline", ai_get_unit(ai_current_actor));
	end
	Unit_EmptyAmmo(ai_current_actor);
	Unit_EmptyGrenadeInventory(ai_current_actor);	
	ai_braindead(ai_current_actor, true);
end

function makebraindead()
	Unit_EmptyAmmo(ai_current_actor);
	Unit_EmptyGrenadeInventory(ai_current_actor);	
	ai_braindead(ai_current_actor, true);
end

global grenadetutorialcrouch = false;

function maketargetpatrol(targetFlag, returnFlag)
	if ShouldApplyOutlinesInAcademy == true then
		RunClientScript("cl_CreateTargetOutline", ai_get_unit(ai_current_actor));
	end
	Unit_EmptyAmmo(ai_current_actor);
	Unit_EmptyGrenadeInventory(ai_current_actor);	
	cs_suppress_activity_termination(ai_current_actor, true);
	repeat
		cs_go_to(ai_current_actor, true, targetFlag, 0);
		SleepSeconds(1);
		cs_go_to(ai_current_actor, true, returnFlag, 0);
		SleepSeconds(1);
	until unit_get_health(ai_current_actor) <= 0;
end

function targetsetupcommandscript(targetFlag)
	if ShouldApplyOutlinesInAcademy == true then
		RunClientScript("cl_CreateTargetOutline", ai_get_unit(ai_current_actor));
	end
	Unit_EmptyAmmo(ai_current_actor);
	Unit_EmptyGrenadeInventory(ai_current_actor);	
	cs_suppress_activity_termination(ai_current_actor, true);
	cs_go_to(ai_current_actor, true, targetFlag, 0);
	cs_face_player(ai_current_actor, true);
	SleepSeconds(.1);
	ai_braindead(ai_current_actor, true);
end

function midartarget()
	RunCommandScript(AI.ar_target.ar_target_spawn, targetsetupcommandscript, FLAGS.ar_mid);
end

function leftartarget()
	RunCommandScript(AI.ar_target.ar_target_spawn_05, targetsetupcommandscript, FLAGS.ar_left);
end

function rightartarget()
	RunCommandScript(AI.ar_target.ar_target_spawn_06, targetsetupcommandscript, FLAGS.ar_right);
end

function crtarget01()
	RunCommandScript(AI.cr_target.cr_target_spawn_04, targetsetupcommandscript, FLAGS.cr_target_01);
end

function crtarget02()
	RunCommandScript(AI.cr_target.cr_target_spawn_02, targetsetupcommandscript, FLAGS.cr_target_02);
end

function crtarget03()
	RunCommandScript(AI.cr_target.cr_target_spawn_03, targetsetupcommandscript, FLAGS.cr_target_03);
end

function frontpatroltarget()
	RunCommandScript(AI.patroling_target.ar_target_spawn_02, maketargetpatrol, FLAGS.front_target, Object_GetPosition(AI.patroling_target.ar_target_spawn_02));
end

function midpatroltarget()
	RunCommandScript(AI.patroling_target.ar_target_spawn, maketargetpatrol, FLAGS.mid_target, Object_GetPosition(AI.patroling_target.ar_target_spawn));
end

function rearpatroltarget()
	RunCommandScript(AI.patroling_target.ar_target_spawn_01, maketargetpatrol, FLAGS.rear_target, Object_GetPosition(AI.patroling_target.ar_target_spawn_01));
end

function zoomrightpatroltarget()
	RunCommandScript(AI.cr_target.cr_target_spawn, maketargetpatrol, FLAGS.right_target, Object_GetPosition(AI.cr_target.cr_target_spawn));
end

function zoomleftpatroltarget()
	RunCommandScript(AI.cr_target.cr_target_spawn_01, maketargetpatrol, FLAGS.left_target, Object_GetPosition(AI.cr_target.cr_target_spawn_01));
end

-- Telemetry functions

function Tutorial_BeginMissionTelemetryThread()
	lastMissionStatus = Telemetry.Enums.MissionStatus.inProgress;
	missionStatusStartedOn = Game_TimeGet();

	Sleep(3);

	local elapsedMs = math.floor(Game_TimeGet():ElapsedTime(missionStatusStartedOn) * 1000);
	activityIndex = Telemetry.Mission.MissionStatusChanged(telemetryMissionNameId, PLAYERS.player0, lastMissionStatus, Telemetry.Enums.MissionStatus.inProgress, elapsedMs);
	progressionStartedOn = Game_TimeGet();
	missionStatusStartedOn = progressionStartedOn;
end

function Tutorial_UpdateMissionProgress(subsectionName)
	local elapsedMs = math.floor(Game_TimeGet():ElapsedTime(missionStatusStartedOn) * 1000);
	activityIndex = Telemetry.Mission.MissionProgressed(telemetryMissionNameId, PLAYERS.player0, false, 0.15, Telemetry_RegisterHashString(subsectionName), elapsedMs);
end

function Tutorial_TutorialTelemetryComplete()
	local elapsedMs = math.floor(Game_TimeGet():ElapsedTime(missionStatusStartedOn) * 1000);
	activityIndex = Telemetry.Mission.MissionProgressed(telemetryMissionNameId, PLAYERS.player0, false, 1.0, Telemetry_RegisterHashString("Multiplayer_Tutorial_Complete"), elapsedMs);
	activityIndex = Telemetry.Mission.MissionStatusChanged(telemetryMissionNameId, PLAYERS.player0, lastMissionStatus, Telemetry.Enums.MissionStatus.completed, elapsedMs); 
	lastMissionStatus = Telemetry.Enums.MissionStatus.completed; 
end


-- Blinks
function BlinkHelper()
	player_disable_movement(false, PLAYERS.player0);

	--clear all navpoints to avoid noise after blink
	Navpoint_DeleteAll();

	--Stop the reminder thread that starts after the intro sequence
	NarrativeInterface.KillConversation("ACADEMY_EXIT_PICKUP_1");

	--delete the player's spawn point to avoid spawning there later
	Object_Delete(OBJECTS.tutorial_spawn_point);
	
	--stop and clean up any existing music
	music_event(TAG('sound\120_music_campaign\global\120_mus_global_blink_stopall.music_control'));
end

function BlinkAISequence()
	BlinkHelper();
	object_teleport(PLAYERS.player0, FLAGS.blink_ai_sequence_flag);
end

function BlinkWeaponRangeSequence()
	BlinkHelper();
	switch_zone_set(ZONE_SETS.academy_end);
	SpawnLockerWeapons();
	player_disable_weapon_pickup(false);
	object_teleport(PLAYERS.player0, FLAGS.blink_weapon_range_sequence_flag);
	hud_show_shield(true);
	local blinkweapon = Object_CreateFromTag(WeaponTags.assault_rifle);
	Unit_GiveWeapon(Player_GetUnit(PLAYERS.player0), blinkweapon, WEAPON_ADDITION_METHOD.PrimaryWeapon);
	armoryWeaponPickedUp = true;
	CreateThread(WeaponRangeSpinUp);
end

function BlinkPlayOutroSequence()
	BlinkHelper();
	CleanUpIntroAnimations();
	switch_zone_set(ZONE_SETS.academy_end);
	player_disable_weapon_pickup(false);
	--clear navpoints again to account for blinking in the middle of threads
	Navpoint_DeleteAll();
	Composer_FadeOut(0,0,0,1);
	Object_Delete(OBJECTS.intro_pelican);
	SleepSeconds(3);
	Tutorial_PlayOutro(); --defined in sgh_interlock_tutorial_livefire.lua
end

function BlinkMovementCourse()
	BlinkHelper();
	object_teleport(PLAYERS.player0, FLAGS.blink_movement_yard_flag);
end

function BlinkWeaponStorage()
	BlinkHelper();
	SpawnLockerWeapons();
	object_teleport(PLAYERS.player0, FLAGS.blink_weapon_storage_flag);
end

function BlinkInterlockTransition()
	BlinkHelper();
	switch_zone_set(ZONE_SETS.academy_end);
	player_disable_weapon_pickup(false);
	object_teleport(PLAYERS.player0, FLAGS.blink_interlock_transition_flag);
end

global tutorialObjective = nil;
global tutorialObjectiveFilter = nil;
global objectiveMessage = "objective_message";

-- Utilities

-- play a reminder dialogue line if a player has not made it to a particular volume
function DialogueReminderThread(forwardVolume:volume, sequence:string, targetObject:object, targetlocation:navpoint, targetVolume:volume):void
	local skipReminderDialogue:boolean = false; 
	skipReminderDialogue = SleepUntilReturnSeconds([|volume_test_players(forwardVolume) == true], 1, tutorialPromptDelaySeconds);
	if skipReminderDialogue == false then
		NarrativeInterface.PlayNarrativeSequence(sequence);
		CreateThread(HandleReminderNavpoint, targetObject, targetlocation, targetVolume);
	end
end

function HandleReminderNavpoint(targetObject:object, targetNav:navpoint, targetVolume:volume):void
	if targetNav == nil then
		targetNav = CreateObjectNavpoint(targetObject, defaultNavpointType, nil);
		SleepUntil([|volume_test_players(targetVolume) == true], 1);
		Navpoint_Delete(targetNav);
	end
end

function DisplayHelperQuickTipThread(forwardVolume:volume, tipTitle:string, tipDesc:string)
	local playerReachedVolume:boolean = false;
	playerReachedVolume = SleepUntilReturnSeconds([|volume_test_players(forwardVolume) == true], 1, tutorialPromptDelaySeconds);
	
	-- check to see if the player has reached the forward trigger volume (we can assume they figured out what to do if they did)
	if playerReachedVolume == false then
		TutorialQuickTipHandler(PLAYERS.player0, tipTitle, tipDesc, tutorialTipDisplaySeconds);
	end
end

function CreateObjectiveBanner()
	tutorialObjective = Engine_CreateObjective(objectiveMessage);
	tutorialObjectiveFilter = Objective_Filter_CreatePlayerMaskFilter(tutorialObjective);
end

function CreateAndShowObjectiveMessage(message:string)
	Objective_SetFormattedText(tutorialObjective, message);
	Objective_Filter_SetPlayersAll(tutorialObjective, tutorialObjectiveFilter, true );
	Objective_SetEnabled(tutorialObjective, true);
	MPLuaCall("__OnObjectiveBannerMessage");
end

function DisableObjectiveMessage()
	Objective_Filter_SetPlayersAll(tutorialObjective, tutorialObjectiveFilter, false);
	Objective_SetEnabled(tutorialObjective, false);
end

function CreateObjectNavpoint(navpointObject:object, navpointType:string, navpointText:string)
	local newNavpoint = Navpoint_Create(navpointType);
	--wrapper to check that our navpoint didn't fail to create
	if newNavpoint ~= nil then
		Navpoint_SetObjectParent(newNavpoint, navpointObject);
		Navpoint_SetDisplayText(newNavpoint, navpointText);
		Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(newNavpoint, true);
		Navpoint_SetVisibleWithNoObjectParent(newNavpoint, true);
		Navpoint_SetVisibleOffscreen(newNavpoint, true);
		Navpoint_SetCanBeOccluded(newNavpoint, false);
		Navpoint_SetVisibilityParams(newNavpoint, -1, true);
		local navpointObjectPosition = Object_GetPositionVector(navpointObject);

		--play the correct sound response depending on what type of navpoint we created
		if navpointType == defaultNavpointType then
			MPLuaCall("__OnWaypointNavAppear", navpointObjectPosition);
		elseif navpointType == exploreNavpoint then
			MPLuaCall("__OnObjectNavAppear", navpointObjectPosition);
		elseif navpointType == aiTerminalNavpointType then
			MPLuaCall("__OnPersonalAINavAppear", navpointObjectPosition);
		elseif navpointType == commanderNavpoint then
			MPLuaCall("__OnCommanderNavAppear", navpointObjectPosition);
		end

		return newNavpoint;
	else 
		return nil; 
	end
end

function HandlePlayersWhoHurtOtherHumans(puppetString:string_id, show:number, teleportLocation:flag):void
	local puppetObject = composer_get_puppet_from_show(puppetString, show);
	local playerTeam = Player_GetMultiplayerTeam(PLAYERS.player0);
	Object_SetMultiplayerTeam(puppetObject, playerTeam);
	RegisterEvent(g_eventTypes.objectDamagedEvent, PuppetDamageNotification, puppetObject, teleportLocation);
	SleepUntil([|composer_show_is_playing(show) == false], 1);
	UnregisterEvent(g_eventTypes.objectDamagedEvent, PuppetDamageNotification, puppetObject);
end

global friendlyDamageThreadIndex = nil;

function PuppetDamageNotification(damageEvent, teleportLocation):void
	if friendlyDamageThreadIndex == nil then
		friendlyDamageThreadIndex = CreateThread(ResetPlayerPostFriendlyDamage, damageEvent.attacker, teleportLocation);
	end
end

function ResetPlayerPostFriendlyDamage(baddy:player, startLocation:flag):void
	if biped_is_alive(baddy) == true and playerReachedLiveFire == false then
		PlayerControlFadeOutAllInputForPlayer(baddy, 0);
		fade_out_for_player(baddy);
		SleepSeconds(.5);
		object_teleport(baddy, startLocation);
		SleepSeconds(.5);
		fade_in_for_player(baddy);
		PlayerControlFadeInAllInputForPlayer(baddy, 0);
		TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_friendly_fire_title", "academy_tip_friendly_fire", tutorialTipDisplaySeconds);
	end
	friendlyDamageThreadIndex = nil;
end

function TutorialQuickTipHandler(student:player, tipTitle:string, tipText:string, tipLength:number):void
	MPLuaCall("__OnSetQuickTip", student, tipTitle, tipText, tipLength);
	MPLuaCall("__OnQuickTipShow");
end

function remoteServer.CreateAndShowObjectiveMessage(message:string)
	CreateAndShowObjectiveMessage(message);
end

--## CLIENT

function remoteClient.cl_CreateTargetOutline(unit:object)
	Outline_AssignTagToObject(unit, MPAcademyOutlineTags.defaultHostile);

	SleepUntil([| unit_get_health(unit) <= 0 ], 1);
	Outline_RemoveFromObject(unit);
end

function remoteClient.SendUIEvent_Client(eventName:string):void
	SendHuiEvent(eventName);
end

 
function remoteClient.DisplayWeaponZoomMessage(zoomHoldMessage:string, zoomMessage:string):void
	-- false is hold button to zoom
	if Academy_IsZoomControlToggle(Player_GetLocal(0)) then
		RunServerScript("CreateAndShowObjectiveMessage", zoomMessage);
	else
		RunServerScript("CreateAndShowObjectiveMessage", zoomHoldMessage);
	end
end

function remoteClient.DisplayCrouchMessage(crouchHoldMessage:string, crouchMessage:string):void
	-- false is hold button to crouch
	if Academy_IsCrouchControlToggle(Player_GetLocal(0)) then
		RunServerScript("CreateAndShowObjectiveMessage", crouchMessage);
	else
		RunServerScript("CreateAndShowObjectiveMessage", crouchHoldMessage);
	end
end

function remoteClient.DisplaySprintMessage(sprintHoldMessage:string, sprintMessage:string):void
	-- false is hold button to sprint
	if Academy_IsSprintControlToggle(Player_GetLocal(0)) then
		RunServerScript("CreateAndShowObjectiveMessage", sprintMessage);
	else
		RunServerScript("CreateAndShowObjectiveMessage", sprintHoldMessage);
	end
end

function remoteClient.DisplaySlideQuickTip(slideHoldMessage:string, slideMessage:string):void
	-- false is hold button to crouch
	if Academy_IsCrouchControlToggle(Player_GetLocal(0)) then
		RunServerScript("TutorialSlideQuickTip", slideMessage);
	else
		RunServerScript("TutorialSlideQuickTip", slideHoldMessage);
	end
end

function remoteClient.cl_CreateSpawnEffect(unit:object)
	effect_new_on_object_marker(MPAcademyTargetSpawnTags.targetSpawnEffect, unit, "");
end