--## SERVER
-- =================================================================================================
-- Tutorial (SERVER)
-- =================================================================================================
-- === TutorialShow: Shows the tutorial string on a specific player for an OPTIONAL number of seconds
--		pl - player
--		text - the stringID to show
-- 		max_time - OPTIONAL the number of seconds to show the tutorial string unless stopped by another script or another tutorial overwrites it
--  Example: TutorialShow (PLAYERS.player0, "example", 10) -- shows the stringID of Example for 10 seconds to player0

function TutorialShow (pl:player, text:string, max_time:number)
	RunClientScript ("TutorialShowClient", pl, get_string_id_from_string(text), max_time);
end

-- === TutorialShowStartDelayed: Shows the tutorial the first time a player encounters the tutorial.
--			If the tutorial has been completed, do not show it again unless the player is stuck.
--		pl - player
--		text - the stringID to show
--		blocking_id - the stringID of the tutorial, located in global_tutorial_table.lua
-- 		max_time - OPTIONAL the number of seconds to show the tutorial string unless stopped by another script or another tutorial overwrites it
--		time_to_show_again - OPTIONAL the number of seconds to wait until showing the tutorial if the player has already completed the tutorial
--  Example: TutorialShowStartDelayed (PLAYERS.player0, "example", "mechanic_level_01", 10, 5)
--			 shows the stringID of Example for 10 seconds to player0, waiting 5 seconds to display if the player has completed the tutorial 
function TutorialShowStartDelayed (pl:player, text:string, blocking_id:string, max_time:number, time_to_show_again:number)
	RunClientScript ("TutorialShowClientDelayedTutorial", pl, text, blocking_id, max_time, time_to_show_again);
end

-- === TutorialShowIfNotPerformed: Shows the tutorial unless the player has completed that mechanic.
--		pl - player
--		text - the stringID to show
--		mechanic_id - mechanic enum to check if completed
-- 		max_time - OPTIONAL the number of seconds to show the tutorial string unless stopped by another script or another tutorial overwrites it
--  Example: TutorialShowIfNotPerformed (PLAYERS.player0, "example", TUTORIAL.example, 10) shows the stringID of Example for 10 seconds to player0 
function TutorialShowIfNotPerformed (pl:player, text:string, mechanic_id:tutorial, max_time:number)
	RunClientScript ("TutorialShowClientIfNotPerformed", pl, text, mechanic_id, max_time);
end

function TutorialShowAll (text:string, max_time:number)
	RunClientScript ("TutorialShowClientLocal", get_string_id_from_string(text), max_time);
end

function TutorialShowAllDelayed (text:string, blocking_id:string, max_time:number, time_to_show_again:number)
	RunClientScript ("TutorialShowClientLocalDelayed", text, blocking_id, max_time, time_to_show_again);
end

function TutorialShowAllIfNotPerformed (text:string, mechanic_id:tutorial, max_time:number)
	RunClientScript ("TutorialShowClientLocalIfNotPerformed", text, mechanic_id, max_time);
end

function TutorialStop(player:player)
	RunClientScript ("TutorialStopClient", player);
end

-- === TutorialStopAndMark: Stops the current tutorial and marks it as completed.
--		pl - player
--		text - the stringID to show
-- 		max_time - OPTIONAL the number of seconds to show the tutorial string unless stopped by another script or another tutorial overwrites it
--  Example: TutorialShow (PLAYERS.player0, "example", 10) -- shows the stringID of Example for 10 seconds to player0
function TutorialStopAndMark(player:player, blocking_id:string)
	RunClientScript ("TutorialStopClientAndMark", player, blocking_id);
end

function TutorialStopAll()
	RunClientScript ("TutorialStopClientLocal");
end

function TutorialStopAllAndMark(player:player, blocking_id:string)
	RunClientScript ("TutorialStopClientAndMarkLocal", player, blocking_id);
end

-- =================================================================================================
-- Objective Text (SERVER)
-- =================================================================================================
-- === ObjectiveShow: Shows an objective in the objective space on the HUD and adds the objective to the pause menu
--		obj -- chapter title -- it stays up for the amount of seconds set in the "seconds up" in the chapter title properties in the .scenario file

function ObjectiveShow (obj:title)
	RunClientScript ("ObjectiveShowClient", obj);
	ObjectivePauseMenuShow (obj);
end

-- =================================================================================================
-- Pause Text (SERVER)
-- =================================================================================================
-- === ObjectivePauseMenuShow: Shows the string in the Pause Menu in the objective space
--		obj -- chapter title --

function ObjectivePauseMenuShow (obj:title)
	print ("pause menu objective added");
	clear_pause_menu_objective()
	Sleep (1);
	set_pause_menu_objective (obj);
end




--## CLIENT

-- =================================================================================================
-- Tutorial (CLIENT)
-- =================================================================================================
global th_tutorialThread:thread = nil;
global th_collectibleNotificationThread:thread = nil;

--OSR-158934 -- adding a function to stop the onscreen training before killing the tutorial thread
function TutorialCleanup()
	chud_show_screen_training (PLAYERS.local0, "");
	KillThread (th_tutorialThread);
end

--OSR-158934 -- adding a check for local player before doing anything to stop your buddy from killing your training thread
function remoteClient.TutorialShowClient (player:player, text, max_time:number)
	if player == PLAYERS.local0 then
		TutorialCleanup();
		th_tutorialThread = CreateThread (sys_TutorialShow, player, text, max_time);
	end
end

function remoteClient.TutorialShowClientIfNotPerformed (player:player, text, mechanic_id:tutorial, max_time:number)
	if player == PLAYERS.local0 then
		TutorialCleanup();
		th_tutorialThread = CreateThread (sys_TutorialShowIfNotPerformed, player, text, mechanic_id, max_time);
	end
end

function remoteClient.TutorialShowClientDelayedTutorial (player:player, text:string, blocking_id:string, max_time:number, min_time:number)
	if player == PLAYERS.local0 then
		TutorialCleanup();
		th_tutorialThread = CreateThread (sys_TutorialShowDelayedTutorial, player, text, blocking_id, max_time, min_time);
	end
end

function sys_TutorialShow(player:player, text, max_time:number)
	if player == PLAYERS.local0 then
		max_time = max_time or 60;
		
		-- Wait until the collectible notification is over before showing the training.
		SleepUntil([|th_collectibleNotificationThread == nil], 1);

		sound_impulse_start( TAG('sound\002_ui\002_ui_hud\002_ui_hud_ingame\002_ui_hud_2d_ingame_textpopup.sound'), nil, 1 );
		chud_show_screen_training (player, text);
		sleep_s (max_time);
		chud_show_screen_training (player, "");
	end
	th_tutorialThread = nil;
end

function sys_TutorialShowDelayedTutorial(player:player, text:string, blocking_id:string, max_time:number, min_time:number)
	local text_id = get_string_id_from_string(text);
	local tutorial_index = getTutorialIndex(blocking_id);

	if player == PLAYERS.local0 then
		max_time = max_time or 60;
		min_time = min_time or 10;
		
		if check_training(player, convert_blocking_index(tutorial_index)) then
			sleep_s (min_time);
		end

		-- Wait until the collectible notification is over before showing the training.
		SleepUntil([|th_collectibleNotificationThread == nil], 1);

		sound_impulse_start( TAG('sound\002_ui\002_ui_hud\002_ui_hud_ingame\002_ui_hud_2d_ingame_textpopup.sound'), nil, 1 );
		chud_show_screen_training (player, text_id);
		sleep_s (max_time);
		chud_show_screen_training (player, "");
	end
	th_tutorialThread = nil;
end

function sys_TutorialShowIfNotPerformed(player:player, text:string, mechanic_id:tutorial, max_time:number)
	local text_id = get_string_id_from_string(text);
	local tutorial_index = convert_mechanic_index(mechanic_id);

	if player == PLAYERS.local0 and not check_training(player, tutorial_index) then
		max_time = max_time or 60;

		-- Wait until the collectible notification is over before showing the training.
		SleepUntil([|th_collectibleNotificationThread == nil], 1);
		
		sound_impulse_start( TAG('sound\002_ui\002_ui_hud\002_ui_hud_ingame\002_ui_hud_2d_ingame_textpopup.sound'), nil, 1 );
		chud_show_screen_training (player, text_id);
		SleepUntil([| check_training(player, tutorial_index)], 1, game_seconds_to_ticks(max_time));
		chud_show_screen_training (player, "");
	end
	th_tutorialThread = nil;
end

-- Called from C++
-- Handles showing and clearing the notification that we just picked up a collectible
function CollectibleNotificationShow(collectibleType:number, collectibleIndex:number, wasUnlocked:boolean)
	
	-- Immediately overwrite any training.
	TutorialCleanup();
	th_collectibleNotificationThread = CreateThread (sys_CollectibleNotificationShow, collectibleType, collectibleIndex, wasUnlocked);
end

function sys_CollectibleNotificationShow(collectibleType:number, collectibleIndex:number, wasUnlocked:boolean)
	show_collectible_unlocked_message(collectibleType, collectibleIndex, wasUnlocked);
	sleep_s(7);
	hide_collectible_unlocked_message();
	th_collectibleNotificationThread = nil;
end

function remoteClient.TutorialShowClientLocal (text, max_time:number)
	remoteClient.TutorialShowClient(PLAYERS.local0, text, max_time);
end

function remoteClient.TutorialShowClientLocalDelayed (text:string, blocking_id:string, max_time:number, time_to_show_again:number)
	remoteClient.TutorialShowClientDelayedTutorial(PLAYERS.local0, text, blocking_id, max_time, time_to_show_again);
end

function remoteClient.TutorialShowClientLocalIfNotPerformed (text:string, mechanic_id:tutorial, max_time:number)
	remoteClient.TutorialShowClientIfNotPerformed(PLAYERS.local0, text, mechanic_id, max_time);
end

function remoteClient.TutorialStopClient (player:player)
	if player == PLAYERS.local0 then
		chud_show_screen_training (player, "");
		KillThread (th_tutorialThread);
	end
end

function remoteClient.TutorialStopClientAndMark (player:player, blocking_id:string)
	if player == PLAYERS.local0 then
		chud_show_screen_training (player, "");
		complete_training(player, convert_blocking_index(getTutorialIndex(blocking_id)));
		KillThread (th_tutorialThread);
	end
end

function remoteClient.TutorialStopClientLocal ()
	chud_show_screen_training (PLAYERS.local0, "");
	KillThread (th_tutorialThread);
end

function remoteClient.TutorialStopClientAndMarkLocal (player:player, blocking_id:string)
	chud_show_screen_training (player, "");
	complete_training(player, convert_blocking_index(getTutorialIndex(blocking_id)));
	KillThread (th_tutorialThread);
end


-- objective showing on the client
function remoteClient.ObjectiveShowClient(obj:title)
	cinematic_set_chud_objective(obj);
	sound_impulse_start( TAG('sound\002_ui\002_ui_hud\002_ui_hud_ingame\002_ui_hud_2d_ingame_textpopup.sound'), nil, 1 );
end