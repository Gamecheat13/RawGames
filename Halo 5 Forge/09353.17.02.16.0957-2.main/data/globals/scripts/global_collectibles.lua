--## SERVER

-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- *_*_*_*_*_*_*_ GLOBAL COLLECTIBLES SCRIPT *_*_*_*_*_*_*_*_*
-- *_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*
-- =================================================================================================
-- *** GLOBALS ***
-- =================================================================================================		

	global b_collectible_used:boolean=false;

--Collectibles Device function

global t_numCollectibles:table = {
	player0 = 0,
	player1 = 0,
	player2 = 0,
	player3 = 0,

};

function GlobalCollectibleActivate(device:object, p_player:object)
	print ("collectible activated");
	local pl:player = unit_get_player (p_player);
	local num:number = nil;
	if pl == PLAYERS.player0 then
		t_numCollectibles.player0 = t_numCollectibles.player0 + 1;
		num = t_numCollectibles.player0;
	elseif pl == PLAYERS.player1 then
		t_numCollectibles.player1 = t_numCollectibles.player1 + 1;
		num = t_numCollectibles.player1;
	elseif pl == PLAYERS.player2 then
		t_numCollectibles.player2 = t_numCollectibles.player2 + 1;
		num = t_numCollectibles.player2;
	elseif pl == PLAYERS.player3 then
		t_numCollectibles.player3 = t_numCollectibles.player3 + 1;
		num = t_numCollectibles.player3;
	end
	print ("player", pl," picked up collectible");
	print ("number of collectibles picked up by", pl," is", num);

	-- Fire and AI Chatter event for starting the Collectible pickup animation
	-- TODO : v-jamcro - Uncomment line below after code makes it into Main build
--	chatter_event_collectible_pickup(pl);
	CreateThread (GlobalCollectiblePlay, device, pl);
	
end

function GlobalCollectiblePlay(device:object, p_player)
	--print ("play collectible vignette");
	local show:number = composer_play_show ("collectible", {scanner = p_player});
	--object_destroy (device);
	
	ObjectSetSpartanTrackingEnabled(device, false);

	UnlockCollectible(device);	
	CreateThread (GlobalCollectibleReturnPower, device);
	SleepUntil ([| not composer_show_is_playing(show) ], 1);
	--print ("collectible vignette no longer playing");
	RunClientScript ("ScanComplete");
end

function GlobalCollectibleReturnPower(device:object)
b_collectible_used = true;
	Sleep (7);
	device_set_power (device, 0);
	sleep_s (40);
	device_set_power (device, 1);
	b_collectible_used = false;
end

function GlobalSkull(device:object, p_player:object)
	print("Skull", device, "unlocked");
	SoundImpulseStartServer(TAG('sound\002_ui\002_ui_hud\002_ui_hud_2d_ingame_skullpickup.sound') , p_player);
	UnlockCollectible(device)
	object_destroy (device);
end

-- Unlocks a collectible (notifies the profile and displays toast)
function UnlockCollectible(collectibleObject:object)

	-- Do we have a mission running and got passed in a valid collectibleObject?
	if g_currentMission ~= nil and collectibleObject ~= nil then

		-- Is collectibleObject in the mission's table?
		for _,collectible in ipairs(g_currentMission.collectibles) do
			--print (collectible);
			-- Acquire it.
			if collectibleObject == OBJECTS[collectible.objectName] then
				--print ("collectible ", collectibleObject);
				acquire_collectible(collectible.collectibleName, collectibleObject);
				break;
			end
		end
	end
end

--## CLIENT

global b_scanComplete:boolean = false;

function play_collectible_unlocked_sound(soundTag, collectibleObject:object)
	print ("play the collectible unlocked sound");
	CreateThread(wait_and_play_collectible_unlocked_sound, soundTag, collectibleObject);
end

function wait_and_play_collectible_unlocked_sound(soundTag, collectibleObject:object)
	--print ("wait and play the collectible sound");
	sleep_s(2);
	SleepUntil ([| b_scanComplete ], 1, seconds_to_frames (10));
	sleep_s (1);
	sound_impulse_start(soundTag, collectibleObject, 1.0);
	b_scanComplete = false;
	print ("the collectible sound should be playing");
end
	
function remoteClient.ScanComplete()
	b_scanComplete = true;
end
