-- object fo_tutorial_launcher

--## SERVER

function fo_tutorial_launcher:init()

	while (not AllClientViewsActiveAndStable()) do
		Sleep(1);
	end
	
	RunClientScript ("fo_tutorial_launcher");
	
end

--## CLIENT

function remoteClient.fo_tutorial_launcher()

	FT_AssignObjectName(FT_FindClosestObject(-1097.12, 961.90, -123.45, 1), "Blockade_1")
	FT_AssignObjectName(FT_FindClosestObject(-1097.12, 961.90, -137.01, 1), "Blockade_2")
	FT_AssignObjectName(FT_FindClosestObject(-1549.96, 1490.24, -124.09, 1), "CameraModel")

	FT_Clear()

	;-- Beat 1
	FT_LinearGroupBegin("Beat1_Group")

		FT_CreateTutorialInitializeAction("TutorialInit")
		
		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)

		FT_CreateForgeUIVisibleAction("HideBudgetMeter", "BudgetMeter", false)
		FT_CreateForgeUIVisibleAction("HideOptionButtons", "OptionButtons", false)
		FT_CreateForgeUIVisibleAction("HideMenuButtons", "MenuButtons", false)
		FT_CreateForgeUIVisibleAction("HideControlsHelper", "ControlsHelper", false)

		FT_CreateTimerAction("Beat01_StartTimer", 2.0)
		FT_CreateModalPopupAction("TutorialStartPopup", "ft_beat01_00", 0, "ft_beat01_01", "", 0, 0)
		FT_SetEndSoundEffect(FT_FindAction("TutorialStartPopup"), "SubobjectiveComplete")
		
		FT_CreatePlayMusicAction("IntroMusic",TAG('sound\130_music_multiplayer\130_mus_mp_sustain\forge_tutorial\130_mus_mp_forge_tutorial_intro.sound'))

		FT_CreateCameraAction("CameraInit", -1233, 1046, -20, -1146, 908, -24, 0.25)
	;--    FT_CreateDebugMessageAction("Welcome", "WELCOME TO THE FORGE TUTORIAL...", true, true)

		FT_CreateCameraAction("FlyThrough_01", -1428, 137, -21, 33, -330, 1.0, 2.0)
		FT_CameraActionSetParameters(FT_FindAction("FlyThrough_01"), true, false, 30.0)
		FT_SetSoundData(FT_FindAction("FlyThrough_01"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeintroduction1_00100.sound'),false)

		FT_ParallelGroupBegin("Group1")
			FT_CreateDebugMessageAction("Welcome", "WE'LL START WITH A FLY THROUGH OF OUR WORLD...", false, false)
			FT_CreateCameraAction("FlyThrough_02", -983, -326, -39, 33, -330, 1.0, 2.0)
			FT_SetSoundData(FT_FindAction("FlyThrough_02"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeintroduction2_00100.sound'),false)
			FT_CameraActionSetParameters(FT_FindAction("FlyThrough_02"), false, false, 30.0)
			FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_02"), FT_FindAction("FlyThrough_01"))
		FT_GroupEnd()

		FT_CreateCameraAction("FlyThrough_03", -270, -1106, 6, 33, -330, 1.0, 2.0)
		FT_CameraActionSetParameters(FT_FindAction("FlyThrough_03"), false, false, 30.0)
		FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_03"), FT_FindAction("FlyThrough_02"))

		FT_ParallelGroupBegin("Group1")
			FT_CreateDebugMessageAction("Welcome", "EVERYTHING IS SO SHINY...", false, false)
			FT_CreateCameraAction("FlyThrough_04", 386, -424, 6, 33, -330, 1.0, 2.0)
			FT_SetSoundData(FT_FindAction("FlyThrough_04"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeintroduction3_00100.sound'),false)
			FT_CameraActionSetParameters(FT_FindAction("FlyThrough_04"), false, false, 30.0)
			FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_04"), FT_FindAction("FlyThrough_03"))
		FT_GroupEnd()

		FT_CreateCameraAction("FlyThrough_05", 631, 314, 6, 33, -330, 1.0, 2.0)
		FT_CameraActionSetParameters(FT_FindAction("FlyThrough_05"), false, false, 30.0)
			FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_05"), FT_FindAction("FlyThrough_04"))

		FT_ParallelGroupBegin("Group1")
			FT_CreateCameraAction("FlyThrough_06", -289, 1233, 6, 33, -330, 1.0, 2.0)
			FT_CameraActionSetParameters(FT_FindAction("FlyThrough_06"), false, false, 35.0)
			FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_06"), FT_FindAction("FlyThrough_05"))
		FT_GroupEnd()

		FT_CreateCameraAction("FlyThrough_07", -972, 1456, -108, -1550, 1491, -121, 2.0)
		FT_SetSoundData(FT_FindAction("FlyThrough_07"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeintroduction5_00100.sound'),false)
		FT_CameraActionSetParameters(FT_FindAction("FlyThrough_07"), false, false, 18.0)
			FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_07"), FT_FindAction("FlyThrough_06"))

		FT_ParallelGroupBegin("Group1")
			FT_CreateCameraAction("FlyThrough_08", -1537.12, 1490.87, -122.31, -1635.95, 1484.61, -136.19, 3.0)
			FT_SetSoundData(FT_FindAction("FlyThrough_08"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgemonitormode1_00100.sound'),false)
			FT_CameraActionSetParameters(FT_FindAction("FlyThrough_08"), false, true, 16.0)
			FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_08"), FT_FindAction("FlyThrough_07"))
		FT_GroupEnd()

		FT_CreateTimerAction("Beat01_EndTimer", 0.0)
		
	FT_GroupEnd()

	;-- Beat 2
	FT_LinearGroupBegin("Beat2_Group")

		FT_SetOnSuccessAction(FT_FindAction("Beat1_Group"), FT_FindAction("Beat2_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		
		FT_CreateTimerAction("Beat02_VOPause1", 8.0)
		FT_SetSoundData(FT_FindAction("Beat02_VOPause1"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgemonitormode2_00100.sound'),false)

		FT_CreateDebugMessageAction("Beat2", "Let's mount the camera so you can being to fly...", false, false)
		FT_CreateCameraAction("Beat02_FlyToCamera", -1547.77, 1483.41, -118.5, -1518.69, 1434.24, -122.8, 2.0)
		FT_CameraActionSetParameters(FT_FindAction("Beat02_FlyToCamera"), true, false, 8.0)
		FT_SetSoundData(FT_FindAction("Beat02_FlyToCamera"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeintroduction6_00100.sound'),false)
		FT_SetHideObjectivePrompt(FT_FindAction("Beat02_FlyToCamera"), true)

		FT_CreateObjectSetTransformAction("HideFakeCamera", FT_FindNamedObject("CameraModel"), -1549.96, 1490.24, -144.09, 0, 0, 0, 1.0)
		FT_CreateObjectToggleGrabAction("UngrabFakeCamera", FT_FindNamedObject("CameraModel"), false)

		FT_CreateCameraAction("FlyToCamera_02", -1547.77, 1483.41, -118.5, -1518.69, 1434.24, -122.8, 2.0)
		FT_CameraActionSetParameters(FT_FindAction("FlyToCamera_02"), false, true, 10.0)

		FT_CreateTimerAction("Beat02_EndTimer", 0.0)
		
	FT_GroupEnd()

	;-- Beat 3
	FT_LinearGroupBegin("Beat3_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat2_Group"), FT_FindAction("Beat3_Group"))
		FT_SetObjectivePrompt(FT_FindAction("Beat3_Group"), "title", "firstbody", "")
		
		FT_CreateForgeUIVisibleAction("ShowControlsHelper", "ControlsHelper", true)

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableFreeCamInput", "FreeCam", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightWASD", "MoveCamera", "EnterMovementMode", "RotateCamera", "MonitorUp", "MonitorDown", "", "", "")

		FT_ParallelGroupBegin("EnterTube_Group")
			FT_CreateLocationNavPointAction("TubeEntrance", "ft_navpoint_start_of_tube", -1510.8, 1421.9, -122.1)
			FT_SetBeginSoundEffect(FT_FindAction("TubeEntrance"), "WaypointAppear")
			FT_CreateDebugMessageAction("TubeEntranceMessage", "Enter the tube...", true, false)
			FT_CreateCameraLocationAction("CameraEnterTube", -1510.73, 1424.71, -121.72, 20.0, 20.0)
			FT_SetObjectivePrompt(FT_FindAction("CameraEnterTube"), "ft_beat03_00", "ft_beat03_01", "ft_beat03_01_controller")
			FT_SetBeginSoundEffect(FT_FindAction("CameraEnterTube"), "TextboxAppear")
			FT_SetSoundData(FT_FindAction("CameraEnterTube"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgemonitormode3_00100.sound'),false)
			FT_SetParentGroupComplete(FT_FindAction("CameraEnterTube"))
		FT_GroupEnd()

		FT_ParallelGroupBegin("ExitTube_Group")
			FT_CreateLocationNavPointAction("TubeExit", "ft_navpoint_end_of_tube", -1136.5, 1007.5, -131.0)
			FT_CreateDebugMessageAction("TubeEntranceMessage", "Follow the tube to the end...", true, false)
			FT_CreateCameraLocationAction("CameraExitTube",  -1136.5, 1007.5, -131.0, 10.0, 10.0)
			FT_SetObjectivePrompt(FT_FindAction("CameraExitTube"), "ft_beat03_00", "ft_beat03_02", "")
			FT_SetBeginSoundEffect(FT_FindAction("CameraExitTube"), "TextboxChange")
			FT_SetEndSoundEffect(FT_FindAction("CameraExitTube"), "ObjectiveComplete")
			FT_SetHideObjectivePrompt(FT_FindAction("CameraExitTube"), true)
			FT_SetParentGroupComplete(FT_FindAction("CameraExitTube"))
		FT_GroupEnd()
		
		FT_CreateForgeInputEnabledAction("ForceStopCamera", "FreeCam", false, "", false)
		FT_CreateTimerAction("Beat03_VOPause1", 0.0)
		FT_SetSoundData(FT_FindAction("Beat03_VOPause1"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeselectingdeleting1_00100.sound'),false)
		FT_CreateCameraAction("CameraInit", -1126.87, 996.02, -132.09, -1063.37, 918.83, -129.21, 1.0)

		FT_CreateControlsHelperHighlightAction("HelperHighlightWASD", "", "", "", "", "", "", "", "")

		FT_CreateTimerAction("Beat03_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 4
	FT_LinearGroupBegin("Beat4_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat3_Group"), FT_FindAction("Beat4_Group"))
		
		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		
		FT_CreateTimerAction("Beat04_VOPause1", 2.0)

		FT_CreateForgeInputEnabledAction("EnableObjectSelectionInput", "ObjectSelection", true, "", false)
		FT_CreateForgeInputEnabledAction("EnableObjectDrop", "ObjectDrop", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightObjectSelect", "GrabHighlightedItem", "UngrabHighlightedItem", "", "", "", "", "", "")

		FT_LinearGroupBegin("Delete1_Group")
		
			FT_ParallelGroupBegin("TestSelectedObjectGroup")
			FT_CreateDebugMessageAction("DeleteMsg1", "Select the two objects blocking the exit...", false, false)
			FT_CreateObjectSelectedAction("SelectObject1", FT_FindNamedObject("Blockade_1"))
			FT_AddSelectionObjectIndex(FT_FindAction("SelectObject1"), FT_FindNamedObject("Blockade_2"))
			FT_SetObjectivePrompt(FT_FindAction("SelectObject1"), "ft_beat04_00", "ft_beat04_01", "ft_beat04_01_controller")
			FT_SetBeginSoundEffect(FT_FindAction("SelectObject1"), "TextboxAppear")
			FT_SetEndSoundEffect(FT_FindAction("SelectObject1"), "SubobjectiveComplete")
			FT_SetSoundData(FT_FindAction("SelectObject1"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeselectingdeleting2_00100.sound'),true)
				FT_CreateObjectNavPointAction("SelectObject2NavPoint", "ft_navpoint_object_selection", FT_FindNamedObject("Blockade_2"))
				FT_CreateObjectNavPointAction("SelectObject1NavPoint", "ft_navpoint_object_selection", FT_FindNamedObject("Blockade_1"))
				FT_SetParentGroupComplete(FT_FindAction("SelectObject1"))
			FT_GroupEnd()

			FT_CreateDebugMessageAction("DeleteMsg1", "Now delete or move the object2...", false, false)

			FT_CreateForgeInputEnabledAction("DisableObjectSelectionInput", "ObjectSelection", false, "", false)
			FT_CreateForgeInputEnabledAction("DisableObjectDrop", "ObjectDrop", false, "", false)
			FT_CreateForgeInputEnabledAction("EnsableObjectActionsInput", "ObjectDelete", true, "", false)
			FT_CreateControlsHelperHighlightAction("HelperHighlightDelete", "DeleteSelectedItems", "", "", "", "", "", "", "")

			FT_ParallelGroupBegin("TestDeletedObjectGroup")
				FT_CreateObjectLocationAction("DeleteObject1", FT_FindNamedObject("Blockade_1"), -1096.84, 961.28, -129.55, 30.0, 30.0, true)
				FT_CreateObjectLocationAction("DeleteObject2", FT_FindNamedObject("Blockade_2"), -1096.84, 961.28, -130.71, 30.0, 30.0, true)
			FT_GroupEnd()
			
			FT_SetObjectivePrompt(FT_FindAction("TestDeletedObjectGroup"), "ft_beat04_00", "ft_beat04_02", "ft_beat04_02_controller")
			FT_SetBeginSoundEffect(FT_FindAction("TestDeletedObjectGroup"), "TextboxChange")
			FT_SetEndSoundEffect(FT_FindAction("TestDeletedObjectGroup"), "ObjectiveComplete")
			FT_SetSoundData(FT_FindAction("DeleteObject2"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeselectingdeleting5_00100.sound'),true)
		FT_GroupEnd()

	FT_GroupEnd()	

	;-- Beat 4b
	FT_LinearGroupBegin("Beat4b_Group")

		FT_SetOnSuccessAction(FT_FindAction("Beat4_Group"), FT_FindAction("Beat4b_Group"))
		FT_SetOnFailAction(FT_FindAction("Beat4_Group"), FT_FindAction("Beat4b_Group"))
		
		FT_CreateTimerAction("Beat04b_VOPause1", 2.5)
		FT_SetSoundData(FT_FindAction("Beat04b_VOPause1"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeselectingdeleting6_00100.sound'),false)
		
		FT_CreateForgeUIVisibleAction("ShowOptionButtons", "OptionButtons", true)

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableForgeInput", "FreeCam", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightWASD", "MoveCamera", "EnterMovementMode", "RotateCamera", "EnterBoost", "MonitorUp", "MonitorDown", "", "")

		FT_ParallelGroupBegin("MoveToRing_Group")
			FT_CreateLocationNavPointAction("RingNavPoint", "ft_navpoint_approach_ring", -65.6, -416.2, -73.5)
			FT_SetBeginSoundEffect(FT_FindAction("RingNavPoint"), "WaypointAppear")
			FT_CreateDebugMessageAction("MoveToRingMsg", "Fly over the hill to the next waypoint...", true, false)
			FT_CreateCameraLocationAction("CameraRingLocation", -65.6, -416.2, -73.5, 10.0, 15.0)
			FT_SetObjectivePrompt(FT_FindAction("CameraRingLocation"), "ft_beat04_03", "ft_beat04_04", "ft_beat04_04_controller")
			FT_SetEndSoundEffect(FT_FindAction("CameraRingLocation"), "ObjectiveComplete")
			FT_SetSoundData(FT_FindAction("CameraRingLocation"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeboost_00100.sound'),true)
			FT_SetHideObjectivePrompt(FT_FindAction("CameraRingLocation"), true)
			FT_SetParentGroupComplete(FT_FindAction("CameraRingLocation"))
		FT_GroupEnd()

		FT_CreateControlsHelperHighlightAction("HelperHighlightWASD", "", "", "", "", "", "", "", "")

		FT_CreateTimerAction("Beat04_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 5
	FT_LinearGroupBegin("Beat5_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat4b_Group"), FT_FindAction("Beat5_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)

		FT_CreateDebugMessageAction("Beat5_Message", "We're going to learn to spawn an object...", false, false)
		FT_CreateCameraAction("CameraPrepareSpawn", -69.5, -462.5, -88.0, -127.0, -532.0, -130.0, 2.0)
		FT_SetSoundData(FT_FindAction("CameraPrepareSpawn"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeobjectlibrary1_00100.sound'),false)
		
		FT_CreateTimerAction("Beat05_VOPause1", 2.0)
		
		FT_CreateForgeUIVisibleAction("ShowMenuButtons", "MenuButtons", true)
		
		FT_CreateTimerAction("Beat05_VOPause2", 3.0)
		FT_SetSoundData(FT_FindAction("Beat05_VOPause2"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeobjectlibrary2_00100.sound'),false)
		
		FT_CreateForgeInputEnabledAction("MenuSpawn", "MenuSpawn", true, "", false)

		FT_CreateDebugMessageAction("Beat5_Message", "Press 'O' and use the Spawn Menu to create a 'Man Cannon'...", false, false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightSpawn", "OpenSpawnObjectMenu", "", "", "", "", "", "", "")
		FT_CreateMenuTrailAction("OpenSpawnMenu", "SpawnObject", false)
		FT_SetObjectivePrompt(FT_FindAction("OpenSpawnMenu"), "ft_beat05_00", "ft_beat05_01", "ft_beat05_01_controller")
		FT_SetSoundData(FT_FindAction("OpenSpawnMenu"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeobjectlibrary3_00100.sound'),false)
		FT_SetEndSoundEffect(FT_FindAction("OpenSpawnMenu"), "SubobjectiveComplete")
		
		FT_CreateControlsHelperHighlightAction("ClearHelperHighlightSpawn", "", "", "", "", "", "", "", "")
		FT_ParallelGroupBegin("SpawnObjectGroup")
			FT_CreateMenuTrailAction("MenuSpawnAction", "SpawnManCannon", true)
			FT_CreateObjectCreatedAction("ObjectCreatedAction", "ManCannon")
			FT_SetObjectivePrompt(FT_FindAction("ObjectCreatedAction"), "ft_beat05_00", "ft_beat05_02", "")
			FT_SetBeginSoundEffect(FT_FindAction("ObjectCreatedAction"), "TextboxChange")
			FT_SetEndSoundEffect(FT_FindAction("ObjectCreatedAction"), "ObjectiveComplete")
			FT_SetHideObjectivePrompt(FT_FindAction("ObjectCreatedAction"), true)
			FT_SetParentGroupComplete(FT_FindAction("ObjectCreatedAction"))
		FT_GroupEnd()

		FT_CreateTimerAction("Beat05_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 6
	FT_LinearGroupBegin("Beat6_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat5_Group"), FT_FindAction("Beat6_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableObjectSelectionInput", "ObjectSelection", true, "", false)
		
		FT_CreateModalPopupAction("WidgetsPopup", "ft_beat06_popup_00", 1, "ft_beat06_popup_01", "", 0, 0)
		
		FT_CreateForgeInputEnabledAction("EnableFreeCamInput", "FreeCam", true, "", false)
		FT_CreateForgeInputEnabledAction("EnableTranslateModeInput", "TranslateMode", true, "", false)
		FT_CreateForgeInputEnabledAction("EnableTranslateInput", "Translate", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightTranslate", "TranslateGrabbedItems", "EndTranslateGrabbedItems", "MoveObject", "MoveCamera", "EnterMovementMode", "RotateCamera", "MonitorUp", "MonitorDown")

		FT_ParallelGroupBegin("MoveObjectGroup")
			FT_CreateObjectTranslationRestrictionCylinderAction("MoveObjectRestrictionVolume", -163.57, -572.16, -147.0, 30.0, 60.0);
			FT_CreateObjectTranslationRestrictionPlanesAction("MoveObjectRestrictionPlanes", -183, -621, -149, -19, -289, 126);
			FT_CreateLocationNavPointAction("MoveLocator", "ft_navpoint_move_object_here", -163.57, -572.16, -147.0)
			FT_SetBeginSoundEffect(FT_FindAction("MoveLocator"), "WaypointAppear")
			FT_CreateEditModeHighlightAction("TranslateButtonHighlight", "Translate")
			FT_CurrentObjectLocationAction("Beat06_MoveObjectAction", -163.57, -572.16, -147.0, 12.0, 6.0)
			FT_SetObjectivePrompt(FT_FindAction("Beat06_MoveObjectAction"), "ft_beat06_00", "ft_beat06_01", "ft_beat06_01_controller")
			FT_SetEndSoundEffect(FT_FindAction("Beat06_MoveObjectAction"), "ObjectiveComplete")
			FT_CreateTimerAction("TranslateObjectVO", 5.0)
			FT_SetSoundData(FT_FindAction("TranslateObjectVO"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgemovingobjects2_00100.sound'),true)
			FT_SetHideObjectivePrompt(FT_FindAction("Beat06_MoveObjectAction"), true)
			FT_SetParentGroupComplete(FT_FindAction("Beat06_MoveObjectAction"))
		FT_GroupEnd()

		FT_CreateForgeInputEnabledAction("DisableTranslateInput", "Translate", false, "", false)

		FT_CreateTimerAction("Beat06_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 7
	FT_LinearGroupBegin("Beat7_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat6_Group"), FT_FindAction("Beat7_Group"))
		
		FT_CreateCameraAction("CameraWaterfall1", -125.0, -578.8, -90.9, -40.1, -626.7, -68.5, 2.0)
		FT_SetSoundData(FT_FindAction("CameraWaterfall1"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgerotatingobject1_00100.sound'),false)

		FT_CurrentObjectSetTransformAction("AdjustObjectPosition", -163.57, -572.16, -147.0, 0, 0, 0, 0.5)

		FT_CreateTimerAction("Beat07_VOPause1", 2.0)
		FT_CreateCameraAction("CameraWaterfall3", -241.91, -513.34, -111.29, -153.7, -560.45, -110.41, 4.0)
		FT_SetSoundData(FT_FindAction("CameraWaterfall3"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgerotatingobject2_00100.sound'),false)
		FT_CreateTimerAction("Beat07_VOPause2", 1.0)
		
		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableFreeCamInput", "FreeCam", true, "", false)
		FT_CreateForgeInputEnabledAction("EnableRotationModeInput", "RotationMode", true, "", false)
		FT_CreateForgeInputEnabledAction("EnableRotationInput", "Rotate", true, "", false)
		FT_CreateForgeInputEnabledAction("EnableRotationInputZ", "RotateZ", true, "", false)
		FT_CreateForgeInputEnabledAction("EnableObjectSelectionInput", "ObjectSelection", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightRotate", "RotateGrabbedItems", "EndRotateGrabbedItems", "RotateObjectHorizontalAxis", "ChangeEditModeToRotation", "", "", "", "")

		FT_ParallelGroupBegin("RotateObjectGroup")
			FT_CreateLocationNavPointAction("RotateLocator", "ft_navpoint_rotate_object_here", -131.7, -589.5, -145.6)
			FT_SetBeginSoundEffect(FT_FindAction("RotateLocator"), "WaypointAppear")
			FT_CreateEditModeHighlightAction("RotateButtonHighlight", "Rotate")
			FT_CurrentObjectRotationAction("Beat07_RotateObjectAction", -131.7, -589.5, -145.6, 2.0, 0.0)
			FT_SetObjectivePrompt(FT_FindAction("Beat07_RotateObjectAction"), "ft_beat07_00", "ft_beat07_01", "ft_beat07_01_controller")
			FT_SetBeginSoundEffect(FT_FindAction("Beat07_RotateObjectAction"), "TextboxAppear")
			FT_SetEndSoundEffect(FT_FindAction("Beat07_RotateObjectAction"), "ObjectiveComplete")
			FT_CreateTimerAction("RotateObjectVO", 5.0)
			FT_SetSoundData(FT_FindAction("RotateObjectVO"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgerotatingobject3_00100.sound'),true)
			FT_SetHideObjectivePrompt(FT_FindAction("Beat07_RotateObjectAction"), true)
			FT_SetParentGroupComplete(FT_FindAction("Beat07_RotateObjectAction"))
		FT_GroupEnd()

		FT_CreateForgeInputEnabledAction("DisableRotateInput", "Rotate", false, "", false)

		FT_ParallelGroupBegin("AdjustObjectGroup")
			FT_CurrentObjectSetTransformAction("AdjustObject", -163.57, -572.16, -147.0, -131.7, -589.5, -145.6, 0.5)
			FT_CreateCameraAction("CameraWaterfall2", -186.9, -548.3, -140.4, -96.9, -592.8, -119.8, 4.0)
			FT_SetSoundData(FT_FindAction("CameraWaterfall2"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeobjectproperties1_00100.sound'),false)
			FT_SetParentGroupComplete(FT_FindAction("CameraWaterfall2"))
		FT_GroupEnd()
		FT_CreateTimerAction("Beat07_VOPause3", 1.0)

		FT_CreateTimerAction("Beat07_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 8
	FT_LinearGroupBegin("Beat8_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat7_Group"), FT_FindAction("Beat8_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableFreeCamInput", "FreeCam", true, "", false)
		FT_CreateForgeInputEnabledAction("MenuProperties", "MenuProperties", true, "", false)
		FT_CreateForgeInputEnabledAction("EnableObjectSelectionInput", "ObjectSelection", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightPropertiesMenu", "OpenObjectPropertiesMenu", "", "", "", "", "", "", "")

		FT_CreateDebugMessageAction("Beat8_OpenMenu", "Press 'P' to edit the cannon values...", false, false)
		FT_CreateDebugMessageAction("Beat8_Values", "Forward: 1000, Vertical:147.5, height: 0", false, false)
		
		FT_CreateMenuTrailAction("OpenProperties", "ObjectProperties", false)
		FT_SetObjectivePrompt(FT_FindAction("OpenProperties"), "ft_beat08_00", "ft_beat08_01", "ft_beat08_01_controller")
		FT_SetSoundData(FT_FindAction("OpenProperties"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeobjectproperties2_00100.sound'),true)
		FT_SetBeginSoundEffect(FT_FindAction("OpenProperties"), "TextboxAppear")
		FT_SetEndSoundEffect(FT_FindAction("OpenProperties"), "SubobjectiveComplete")
		
		FT_CreateControlsHelperHighlightAction("ClearHelperHighlightPropertiesMenu", "", "", "", "", "", "", "", "")
		
		FT_CreateMenuTrailAction("EditCannonForward", "EditCannonValue_Forward", false)
		FT_SetObjectivePrompt(FT_FindAction("EditCannonForward"), "ft_beat08_00", "ft_beat08_02", "")
		FT_SetSoundData(FT_FindAction("EditCannonForward"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeobjectproperties3_00100.sound'),false)
		FT_SetBeginSoundEffect(FT_FindAction("EditCannonForward"), "TextboxChange")
		FT_SetEndSoundEffect(FT_FindAction("EditCannonForward"), "SubobjectiveComplete")
		
		FT_CreateMenuTrailAction("EditCannonVertical", "EditCannonValue_Vertical", false)
		FT_SetObjectivePrompt(FT_FindAction("EditCannonVertical"), "ft_beat08_00", "ft_beat08_03", "")
		FT_SetEndSoundEffect(FT_FindAction("EditCannonVertical"), "SubobjectiveComplete")
		
		FT_CreateMenuTrailAction("EditCannonArcHeight", "EditCannonValue_ArcHeight", true)
		FT_SetObjectivePrompt(FT_FindAction("EditCannonArcHeight"), "ft_beat08_00", "ft_beat08_04", "")
		FT_SetHideObjectivePrompt(FT_FindAction("EditCannonArcHeight"), true)
		FT_SetEndSoundEffect(FT_FindAction("EditCannonArcHeight"), "ObjectiveComplete")

		FT_CreateTimerAction("Beat08_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 9
	FT_LinearGroupBegin("Beat9_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat8_Group"), FT_FindAction("Beat9_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableFreeCamInput", "FreeCam", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightWASD", "MoveCamera", "EnterMovementMode", "RotateCamera", "", "", "", "", "")
		
		FT_ParallelGroupBegin("MoveCameraToCannon")
			FT_CreateDebugMessageAction("Beat9_Launch", "Fly down to the waypoint...", false, false)
			FT_CreateLocationNavPointAction("CannonEntry", "ft_navpoint_approach_mancannon", -180.34, -555.91, -145.63)
			FT_CreateCameraLocationAction("Beat09_CannonEntryLocation", -180.34, -555.91, -145.63, 10.0, 10.0)
			FT_SetObjectivePrompt(FT_FindAction("Beat09_CannonEntryLocation"), "ft_beat09_00", "ft_beat09_01", "")
			FT_SetBeginSoundEffect(FT_FindAction("Beat09_CannonEntryLocation"), "TextboxAppear")
			FT_SetEndSoundEffect(FT_FindAction("Beat09_CannonEntryLocation"), "SubobjectiveComplete")
			FT_SetParentGroupComplete(FT_FindAction("Beat09_CannonEntryLocation"))
		FT_GroupEnd()

		FT_CreateForgeInputEnabledAction("DisableFreeCamInput", "FreeCam", false, "", false)
		
		FT_CreateTimerAction("SpartanModeVO", 1.5)
		FT_SetSoundData(FT_FindAction("SpartanModeVO"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgespartanmode2_00100.sound'),false)
		
		FT_CreateForgeInputEnabledAction("EnableFreeCamInput", "SpartanMode", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightSpartanMode", "EnterSpartanModeNoLightBake", "", "", "", "", "", "", "")

		FT_CreateNotifyForgeInputAction("EnterSpartanMode", "SpartanMode")
		FT_SetObjectivePrompt(FT_FindAction("EnterSpartanMode"), "ft_beat09_00", "ft_beat09_02", "ft_beat09_02_controller")
		FT_SetHideObjectivePrompt(FT_FindAction("EnterSpartanMode"), true)
		FT_SetBeginSoundEffect(FT_FindAction("EnterSpartanMode"), "TextboxChange")
		FT_SetEndSoundEffect(FT_FindAction("EnterSpartanMode"), "ObjectiveComplete")

		FT_CreateTimerAction("Beat09_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 10
	FT_LinearGroupBegin("Beat10_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat9_Group"), FT_FindAction("Beat10_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateControlsHelperHighlightAction("HelperHighlightClear", "", "", "", "", "", "", "", "")

		FT_ParallelGroupBegin("EnterCannonGroup")
			FT_CreateDebugMessageAction("Beat10_Enter", "Now use the Man Cannon, to jump up to the waypoint...", false, false)
			FT_CreateLocationNavPointAction("CannonWaypoint", "ft_navpoint_use_mancannon", -167, -570, -145)
			FT_CreatePlayerLocationAction("CannonTestEntry", -167, -570, -145, 6.0, 10.0)
			FT_SetObjectivePrompt(FT_FindAction("CannonWaypoint"), "ft_beat10_00", "ft_beat10_01", "ft_beat10_01_controller")
			FT_SetBeginSoundEffect(FT_FindAction("CannonWaypoint"), "TextboxAppear")
			FT_SetSoundData(FT_FindAction("CannonWaypoint"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgetestmancannon_00100.sound'),false)
			FT_SetHideObjectivePrompt(FT_FindAction("CannonWaypoint"), true)
			FT_SetParentGroupComplete(FT_FindAction("CannonTestEntry"))
		FT_GroupEnd()

		FT_ParallelGroupBegin("JumpToWaypoint")
			FT_CreateLocationNavPointAction("FlyWaypoint", "ft_navpoint_end_landing", 576.14, -961.03, 99.47)
			FT_CreatePlayerLocationAction("PlayerAtWaypoint", 576.14, -961.03, 99.47, 60.0, 10.0)
			FT_SetEndSoundEffect(FT_FindAction("PlayerAtWaypoint"), "ObjectiveComplete")
			FT_SetParentGroupComplete(FT_FindAction("PlayerAtWaypoint"))
		FT_GroupEnd()
		
		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		
		FT_CreateTimerAction("Beat10_VOPause1", 5.0)
		FT_SetSoundData(FT_FindAction("Beat10_VOPause1"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeconclusion3_00100.sound'),true)
		
		FT_CreateTimerAction("Beat10_VOPause2", 7.5)
		FT_SetSoundData(FT_FindAction("Beat10_VOPause2"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeconclusion5_00100.sound'),true)
		
		FT_CreateTimerAction("Beat10_VOPause3", 2.5)
		FT_SetSoundData(FT_FindAction("Beat10_VOPause3"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeconclusion8_00100.sound'),true)
		
		FT_CreateTimerAction("Beat10_VOPause4", 6.0)
		FT_SetSoundData(FT_FindAction("Beat10_VOPause4"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeconclusion11_00100.sound'),true)
		
		FT_CreateTimerAction("Beat10_VOPause5", 2.0)
		FT_SetSoundData(FT_FindAction("Beat10_VOPause5"),TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_wzcmndrsustain\001_vo_mul_mp_wzcmndrsustain_warzonepve_forgeconclusion13_00100.sound'),true)
		
		FT_CreateForgeInputEnabledAction("EnableForgeInput", "all", true, "", false)
		FT_CreateForgeInputEnabledAction("DisableSpartanModeInput", "SpartanMode", false, "", false)
		
		FT_CreatePlayMusicAction("EndMusic",TAG('sound\130_music_multiplayer\130_mus_mp_sustain\forge_tutorial\130_mus_mp_forge_tutorial_over.sound'))
		FT_CreateForgeUIVisibleAction("ShowBudgetMeter", "BudgetMeter", true)

		FT_CreateModalPopupAction("TutorialCompletePopup", "ft_beat11_00", 0, "ft_beat11_01", "ft_beat11_02", 2, 2)
		FT_SetEndSoundEffect(FT_FindAction("TutorialCompletePopup"), "SubobjectiveComplete")
		FT_CreateLaunchUriAction("LaunchTutorialVideoUri", "ft_tutorial_video_uri")
		
		FT_CreateTutorialShutdownAction("TutorialComplete")
		FT_SetOnFailAction(FT_FindAction("TutorialCompletePopup"), FT_FindAction("TutorialComplete"))

	FT_GroupEnd()

	FT_BeginAction(FT_FindAction("Beat1_Group"))
				
end