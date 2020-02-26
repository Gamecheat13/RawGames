--## SERVER

-- ==========================================================================================================================================================
-- ==========================================================================================================================================================
-- ==========================================================================================================================================================
-- global_audio
-- ==========================================================================================================================================================
-- ==========================================================================================================================================================
-- ==========================================================================================================================================================
function AudioNewObjectiveBeep():void
	SoundImpulseStartServer(TAG('sound\002_ui\002_ui_hud\002_ui_hud_ingame\002_ui_hud_2d_ingame_newobjective.sound'), nil, 1);
end

function startup.InitGlobalAudio()
	RegisterMusketeerOrderEvent(AudioMusketeerOrdered);
	end

function AudioMusketeerOrdered()
	RunClientScript("PlayOrderSoundPlayer");
	--SoundImpulseStartServer(TAG('sound\002_ui\002_ui_hud\002_ui_hud_ingame\002_ui_hud_2d_ingame_musketeerorder.sound'), nil, 1);
end


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- global_audio: DYNAMIC MUSIC
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

--INSTRUCTIONS
--to create dynamic music or impulse sounds tied to trigger volumes
--create tables named with the zoneset
--fill the table with all the volumes and associated music or sound tags
--(SEE EXAMPLE TABLES BELOW)

--run AudioMissionStart at the beginning of missions to check for music
--run AudioMissionSoundStart at the beginning of missions to check for impulses
--the script will handle the rest 


--A global table that is populated with 1) the volume and 2) the music tag to play when entering the volume
global t_audioLevelDynamicMusicTable:table = {};
global t_audioLevelOneoffMusicTable:table = {};
global t_audioOneoffPositionalSoundTable:table = {};
global t_audioOneoffStaticSoundTable:table = {};
global t_audioLevelOneoffMusicTableLookAt:table = {};
--example of an audio music table
--put the name of the zoneset in the title
--fill the table with volumes = music tags
--[[

--EXAMPLE MUSIC TABLES
t_audioLevelDynamicMusicTable[ZONE_SETS.zone_default] =
	{
		default = TAG('sound\120_music_campaign\plateau\120_mus_plateau_start.music_control'),
		[VOLUMES.tv_crater_01] = TAG('sound\120_music_campaign\plateau\120_mus_plateau_start.music_control'),
	};

t_audioLevelOneoffMusicTable[ZONE_SETS.zone_default] =
	{
		default = TAG('sound\120_music_campaign\plateau\120_mus_plateau_start.music_control'),
		[VOLUMES.tv_crater_01] = TAG('sound\120_music_campaign\plateau\120_mus_plateau_start.music_control'),
	};

t_audioLevelOneoffMusicTableLookAt[ZONE_SETS.zone_default] =
	{
		default = TAG('sound\120_music_campaign\plateau\120_mus_plateau_start.music_control'),
		[VOLUMES.tv_crater_01] = TAG('sound\120_music_campaign\plateau\120_mus_plateau_start.music_control'),
	};

--EXAMPLE SOUND TABLES
t_audioOneoffPositionalSoundTable[ZONE_SETS.zone_default] =
{
	inside =
	{
		[VOLUMES.tv_crater_01] = 
			{
				soundtag = TAG('sound\002_ui\002_ui_in_game\002_hud_3d_respawn_nonplayer.sound'),
				object = "crate",
				marker = "garbage_bl",
			},
		[VOLUMES.tv_crater_01] = 
			{
				soundtag = TAG('sound\002_ui\002_ui_in_game\002_hud_3d_respawn_nonplayer.sound'),
				object = "crate",
			},
	},
	lookat =
	{
		[VOLUMES.tv_crater_01] = 
			{
				soundtag = TAG('sound\002_ui\002_ui_in_game\002_hud_3d_respawn_nonplayer.sound'),
				object = "crate",
				marker = "garbage_bl",
			},
	}
	
};

t_audioOneoffStaticSoundTable[ZONE_SETS.zone_default] =
{
	
	lookat =
	{
		[VOLUMES.tv_crater_01] = TAG('sound\002_ui\002_ui_in_game\002_hud_2d_respawn_player.sound'),
		[VOLUMES.tv_crater_01] = TAG('sound\002_ui\002_ui_in_game\002_hud_2d_respawn_player.sound'),
	},
	
	inside =
	{
		[VOLUMES.tv_crater_01] = TAG('sound\002_ui\002_ui_in_game\002_hud_2d_respawn_player.sound'),

	}
};
--]]


------------------START THIS AT THE BEGINNING OF MISSIONS TO CHECK FOR DYNAMIC MUSIC---------------
--if there is a valid audio table then check every active player in the volumes in the table and play the associated music tag

function AudioMissionStart()
	local currentZoneSet = nil;
	repeat
		--print ("zoneset changed");
		currentZoneSet = current_zone_set();
		--print (currentZoneSet);
		
		--if there is a valid table, check if the active players are in any of the listed volumes
		if t_audioLevelDynamicMusicTable[currentZoneSet] ~= nil then
			AudioMusicCheck (t_audioLevelDynamicMusicTable[currentZoneSet]);
		end
		
		if t_audioLevelOneoffMusicTable[currentZoneSet] ~= nil then
			AudioMusicCheck (t_audioLevelOneoffMusicTable[currentZoneSet], true);
			--print ("music oneoff table is valid");
		end
		
		if t_audioLevelOneoffMusicTableLookAt[currentZoneSet] ~= nil then
			--print ("music lookat table is valid");
			AudioMusicCheck (t_audioLevelOneoffMusicTableLookAt[currentZoneSet], true, true);
		end
		
		if t_audioLevelDynamicMusicTable[currentZoneSet] == nil and t_audioLevelOneoffMusicTable[currentZoneSet] == nil and t_audioLevelOneoffMusicTableLookAt[currentZoneSet] == nil then
			--if there is no valid table then wait until the zoneset switches				
			--print ("No valid audio music table found, no dynamic music started");
			SleepUntil([| currentZoneSet ~= current_zone_set() ], 3);
		end
		--print ("done checking volumes");
		--sleep_s (1);
		Sleep (1);
	until false;
end


	--checks every living player if they are in any of the trigger volumes listed in the master table
	--iterates over all the active players and then calls a function to iterate over all the volumes in the table
function AudioMusicCheck(volumetable:table, oneoff:boolean, lookat:boolean)
	for _,player in ipairs (players()) do
		--print (player, "is alive");
		if not sys_AudioMusicCheck(volumetable, player, oneoff, lookat) then
			--print ("player not in volume");
			if not oneoff and volumetable.default ~= nil then
				music_event_player (player, volumetable.default);
				--print ("player not in volume, playing default music");
				--print ("playing ", volumetable.default, " on player ", player);
--			else
--				print ("no default music");
			end
		end
		Sleep (1);
		--sleep_s (1);
	end	

end

--checks if the player is in the volume, if it is then play the associated music tag and return true
function sys_AudioMusicCheck (volumetable:table, player:player, oneoff:boolean, lookat):boolean
	--volumetable.default = nil;
	for volume, music in pairs (volumetable) do	
		--print (volume);
		--table.dprint (volumetable);
		if GetEngineType (volume) == "volume" then
			--print (volume);
			if oneoff then
				if volumetable[player] == nil then
					--volumetable.player = {};
					volumetable[player] = {};
					--table.dprint (volumetable);
				end
				--print ("table player is volume", volumetable[player]);
				if volumetable[player][volume] == nil then
					--print ("volume table player is nil");
					if sys_AudioVolumeCheck (volume, player, lookat) then
						volumetable[player][volume] = true;
						--print ("music event playing with ", volumetable[player][volume], " on ", volume, " with this tag ", music);
						music_event_player (player, music);
						return true;
					end
				end
			else
				if volume_test_object(volume, player) then
					--print ("dynamic", player, "is in", volume, "and is playing", music);
					music_event_player (player, music);
					return true;
				end
			end
		end
		--sleep_s (0.5);
		Sleep (1);
	end
end



-- global_audio: Impulse Audio Check
------------------START THIS AT THE BEGINNING OF MISSIONS TO CHECK FOR IMPULSE AUDIO---------------
--if there is a valid audio table then check every active player in the volumes in the table and play the associated music tag
function AudioMissionSoundStart()
	local currentZoneSet = nil;
	repeat
		--print ("zoneset changed");
		currentZoneSet = current_zone_set();
		--print (currentZoneSet);
		
		--if there is a valid table, check if the active players are in any of the listed volumes
		if t_audioOneoffPositionalSoundTable[currentZoneSet] ~= nil then
			--print ("positional table is valid");
			AudioImpulseCheck (t_audioOneoffPositionalSoundTable[currentZoneSet], true);
		end
		
		if t_audioOneoffStaticSoundTable[currentZoneSet] ~= nil then
			--print ("static table is valid");
			AudioImpulseCheck (t_audioOneoffStaticSoundTable[currentZoneSet]);
		end
		--print ("done checking volumes");
		--sleep_s (1);
		Sleep (1);
	until false;
end


	--checks every living player if they are in any of the trigger volumes listed in the master table
	--iterates over all the active players and then calls a function to iterate over all the volumes in the table
function AudioImpulseCheck(volumetable:table, positional:boolean)
	for _,player in ipairs (players()) do
		--print (player, "is alive");

		--checks for players in the lookup table, if nothing in the lookat table, or the player isn't in the volume then
		--check the inside table		
		if not (sys_AudioImpulseCheck (volumetable.lookat, player, true, positional) or
			sys_AudioImpulseCheck (volumetable.inside, player, false, positional)) then
		end

		Sleep (1);

	end

end

--checks if the player is in (or looking at)the volume
function sys_AudioVolumeCheck (volume:volume, player:player, lookat:boolean):boolean
	if lookat then
		--print ("checking to see if lookat is true");
		if volume_test_player_lookat (volume, player, 100, 15) then
			--print ("lookat is true");
			return true;
		end
	else
		if volume_test_object (volume, player) then
			print ("player is in volume ", player);
			return true;
		end
	end
	--print ("nobody in volume ", volume);
end

--checks if the player is in (or looking at)the volume,
-- if it is then remove the volume from being checked for the player
-- play the associated sound tag and return true 
function sys_AudioImpulseCheck (volumetable:table, player:player, lookat:boolean, positional:boolean):boolean
	if volumetable == nil then
		--print ("volumetable is false");
		return false;
	end
	
	for volume, sound in pairs (volumetable) do	
		--print (volume);
		if GetEngineType (volume) == "volume" then
			--print (volume);
			if volumetable[player] == nil then
				volumetable[player] = {};
			end
			--print (volumetable.player);
			--print ("player volume table is ",volumetable[player][volume]);
			--table.dprint (volumetable);
			if volumetable[player][volume] == nil then
				if sys_AudioVolumeCheck (volume, player, lookat) then
					
					local look:string = "inside";
					if lookat then look = "lookat";
					end
					if positional then
--					table.dprint (volumetable);
--					print (volumetable[volume].soundtag);
--					print (OBJECTS[volumetable[volume].object]);
						
						SoundImpulseStartMarkerServer(volumetable[volume].soundtag, OBJECTS[volumetable[volume].object], volumetable[volume].marker, 1);
						--RunClientScript ("SoundImpulseStartMarkerClient", volumetable[volume].soundtag, volumetable[volume].object, volumetable[volume].marker, 1);
						print (look, " positional on ", player, "is looking at ", volume, "and is playing", volumetable[volume].soundtag);
						--print ("on object ", volumetable[volume].object, " and marker ", volumetable[volume].marker);
					else
--					print (sound);
--					print (volume);
						RunClientScript ("SoundImpulseStartClient", sound);
						--print (look " 2d on ", player, "is looking at ", volume, "and is playing", sound);
					end
					volumetable[player][volume] = true;
					return true;
				end
			end
		end

		Sleep (1);
	end
end


--checks all players if they are in a volume,
-- if a player is then play the associated sound tag on the client of the player 
function SoundImpulseStartServerVolume(vol:volume, music:tag)
	--print ("playing audio per player");
	for _,player in ipairs (players()) do
		if volume_test_object (vol, player) then
			--print ("play audio on player ", player);
			music_event_player (player, music);
			--RunClientScript("SoundImpulseStartClientPlayer", unit_get_player(player), soundTag, theObject, theScale);
		end
	end
end



--===================================================================================================
--DEBUG TRIGGERS FOR NARRATIVE MIX STATES =========================================================
--======================================================================================================

function audiomix_vo_2d_plus_6():void
	SoundImpulseStartServer(TAG('sound\030_global\030_global_mix_2d_vo_plus_6.sound'), nil, 1);
end

function audiomix_vo_3d_plus_6():void
	SoundImpulseStartServer(TAG('sound\030_global\030_global_mix_3d_vo_plus_6.sound'), nil, 1);
end

function audiomix_vo_all_plus_6():void
	SoundImpulseStartServer(TAG('sound\030_global\030_global_mix_all_vo_plus_6.sound'), nil, 1);
end

function audiomix_sfx_minus_12():void
	SoundImpulseStartServer(TAG('sound\030_global\030_global_mix_all_sfx_minus_12.sound'), nil, 1);
end

function audiomix_sfx_minus_6():void
	SoundImpulseStartServer(TAG('sound\030_global\030_global_mix_all_sfx_minus_6.sound'), nil, 1);
end

function audiomix_sfx_mute():void
	SoundImpulseStartServer(TAG('sound\030_global\030_global_mix_all_sfx_mute.sound'), nil, 1);
end

function audiomix_sfx_reset_volume():void
	SoundImpulseStartServer(TAG('sound\030_global\030_global_mix_all_sounds_reset_volume.sound'), nil, 1);
end

--## COMMON
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- global_audio: CINEMATICS
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
function sfx_cinematic_enter():void
	--sound_impulse_start(TAG('sound\cinematics\states\c_set_state_cinematic_playing.sound'), nil, 1);
	print ("play cinematic playing sound");
end

function sfx_cinematic_exit():void
	--sound_impulse_start(TAG('sound\cinematics\states\c_set_state_cinematic_not_playing.sound'), nil, 1);
	print ("play cinematic exit sound");
end

--## SERVER

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- global_audio: CAMPAIGN
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
function remoteServer.sfx_campaign_enter():void
	--sound_impulse_start(TAG('sound\storm\states\campaign\set_state_in_campaign.sound'), nil, 1);
	print ("play sfx campaign enter sound");
end

function remoteServer.sfx_campaign_exit():void
	--sound_impulse_start(TAG('sound\storm\states\campaign\set_state_out_of_campaign.sound'), nil, 1);
	print ("play sfx campaign exit sound");
end

--checks a group of AI until there are only "num" left and then plays a function
function AudioCheckEnemyCount (group:ai, num:number, func:ifunction, ...)
	SleepUntil([|ai_living_count(group) > 0], 1);
	SleepUntil([|ai_living_count(group) < num], 1);
	print("AUDIO: enemy count for ", GetEngineString(group), "is less than ", num, "…changing the music" );
	func(...);
end


-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- ONLY CLIENT/SERVER CODE BEYOND THIS POINT, thanks in advance.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function SoundImpulseStartMarkerServer(soundTag:tag, theObject:object, theMarker:string, theScale:number):void
	theMarker = theMarker or "";
	--print ("the marker is ", theMarker);
	RunClientScript("SoundImpulseStartMarkerClient", soundTag, theObject, theMarker, theScale);
end

function SoundImpulseStartServer(soundTag:tag, theObject:object, theScale:number):void
	RunClientScript("SoundImpulseStartClient", soundTag, theObject, theScale);
end


--## CLIENT

function remoteClient.SoundImpulseStartMarkerClient(soundTag:tag, theObject:object, theMarker:string, theScale:number)
	--theMarker = theMarker or "";
	--print ("the client marker is ", theMarker);
	--print ("soundtag is ", soundTag);
	sound_impulse_start_marker(soundTag, theObject, theMarker, theScale);
end

function remoteClient.SoundImpulseStartClient(soundTag:tag, theObject:object, theScale:number)

	--print ("soundtag is ", soundTag);
	sound_impulse_start(soundTag, theObject, theScale);
end

--plays a sound impulse on the specific client
function remoteClient.SoundImpulseStartClientPlayer(player:player, soundTag:tag, theObject:object, theScale:number)
	if player == PLAYERS.local0 then
		print ("playing sound impulse on local player");
		sound_impulse_start(soundTag, theObject, theScale);
	end
	
end
	
function remoteClient.PlayOrderSoundPlayer()
	if(SPARTANS.locke == player_get_unit(PLAYERS.local0)) then
		sound_impulse_start(TAG('sound\002_ui\002_ui_hud\002_ui_hud_ingame\002_ui_hud_2d_ingame_musketeerorder.sound'), nil, 1);
		--print ("Robbie 3 (sound played!)");
	end
	
end