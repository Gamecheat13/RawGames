global r_fov_default:number=78.0; -- constant

--## SERVER
-- -------------------------------------------------------------------------------------------------
-- CAMERA SHAKE -- server
-- -------------------------------------------------------------------------------------------------
-- === rumble scripts: Screenshake and rumble for a fixed time for all players
--		simple screenshake and rumble function
--			numSeconds = number of seconds to shake
--	RETURNS:  void; when the screenshake is complete

function rumble_shake_small(numSeconds:number)
	RunClientScript ("start_global_rumble_shake_small", numSeconds);
end

function rumble_shake_medium(numSeconds:number)
	RunClientScript ("start_global_rumble_shake_medium", numSeconds);
end

function rumble_shake_large(numSeconds:number)
	RunClientScript ("start_global_rumble_shake_large", numSeconds);
end

function rumble_shake_small_noaudio(numSeconds:number)
	RunClientScript ("start_global_rumble_shake_small_noaudio", numSeconds);
end

function rumble_shake_medium_noaudio(numSeconds:number)
	RunClientScript ("start_global_rumble_shake_medium_noaudio", numSeconds);
end

function rumble_shake_large_noaudio(numSeconds:number)
	RunClientScript ("start_global_rumble_shake_large_noaudio", numSeconds);
end

function rumble_shake(numSeconds:number, rumble_shake:tag)
	RunClientScript ("start_rumble_shake_client", numSeconds, rumble_shake);
end


-- === rumble scripts: Screenshake and rumble for a fixed time for a player
--		simple screenshake and rumble function
--			numSeconds = number of seconds to shake
--	RETURNS:  void; when the screenshake is complete
function RumbleShakePlayerSmall(player:player, numSeconds:number)
	RunClientScript ("RumbleShakePlayerSmall", player, numSeconds);
end

function RumbleShakePlayerMedium(player:player, numSeconds:number)
	RunClientScript ("RumbleShakePlayerMedium", player, numSeconds);
end

function RumbleShakePlayerLarge(player:player, numSeconds:number)
	RunClientScript ("RumbleShakePlayerLarge", player, numSeconds);
end

function RumbleShakePlayerSmall_noaudio(player:player, numSeconds:number)
	RunClientScript ("RumbleShakePlayerSmall_noaudio", player, numSeconds);
end

function RumbleShakePlayerMedium_noaudio(player:player, numSeconds:number)
	RunClientScript ("RumbleShakePlayerMedium_noaudio", player, numSeconds);
end

function RumbleShakePlayerLarge_noaudio(player:player, numSeconds:number)
	RunClientScript ("RumbleShakePlayerLarge_noaudio", player, numSeconds);
end

function RumbleShakePlayer(player:player, numSeconds:number, rumble_shake:tag)
	RunClientScript ("RumbleShakePlayer", player, numSeconds, rumble_shake);
end



-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- CAMERA HELPERS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------
-- GAZE
-- -------------------------------------------------------------------------------------------------

-- === GazeLockPlayers: Lock/unlock gaze of active players on a point reference
--			loc = point reference to lock gaze on
--			velocity = max velocity degrees/second camera transition
function GazeLockPlayers(loc, velocity:number)
	for _, pl in ipairs (PLAYERS.active) do
		player_control_lock_gaze (pl, loc, velocity);
	end
end

--function GazeLockPlayers_trigger( s_player:number, pr_point:point, r_velocity:number, b_lock:boolean, tv_volume:volume, b_inside:boolean ):boolean
--this should have 1 thread on the volume that checks all the players then locks the gaze


-- === GazeClampPlayers: Lock/unlock gaze of players on a point reference
--			loc = point reference to lock gaze on
--			angle = angle of look control
function GazeClampPlayers(loc, angle:number)
	for _, pl in ipairs (PLAYERS.active) do
		player_control_clamp_gaze (pl, loc, angle);
	end
end



-- === GazeUnlockPlayers: Unlocks players gaze
function GazeUnlockPlayers()
	for _, pl in ipairs (PLAYERS.active) do
		player_control_unlock_gaze(PLAYERS.player0);
	end
end



--------------------------------------
------ GLOBAL TELEPORT FUNCTIONS ------
--------------------------------------
global b_TeleportFX:boolean = true;
global n_TeleportSleepTimer:number = 0;

-- Gets called from C++ when a player is teleported
--playerUnit is the unit of the player that got teleported.
function OnPlayerTeleported(playerUnit:object)
	if b_TeleportFX then
		RunClientScript("TeleportPlayerEffect", playerUnit);
	end
end

function TeleportNoFX(timer:number)
	print ("SETTING TELEPORT TO NOT PLAY TELEPORT EFFECT FOR 2 SECONDS");
	if b_TeleportFX then
		b_TeleportFX = false;
		CreateThread (TeleportTimeOut, timer);
	else
		n_TeleportSleepTimer = timer or 2;
	end
end

function TeleportTimeOut(timer:number)
	n_TeleportSleepTimer = timer or 2;
	repeat
		sleep_s (1);
		n_TeleportSleepTimer = n_TeleportSleepTimer - 1;
	until n_TeleportSleepTimer <= 0
	
	b_TeleportFX = true;
end


--## CLIENT
-- camera shakes are for clients only


-- -------------------------------------------------------------------------------------------------
-- CAMERA SHAKE
-- -------------------------------------------------------------------------------------------------

-- === rumble scripts: Screenshake and rumble for a fixed time
--		simple screenshake and rumble function
--			numSeconds = number of seconds to shake
--	RETURNS:  void; when the screenshake is complete
function remoteClient.start_global_rumble_shake_small(numSeconds:number):void
	start_global_rumble_shake(numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_small.effect'));
end

function remoteClient.start_global_rumble_shake_medium(numSeconds:number):void
	start_global_rumble_shake(numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_medium.effect'));
end

function remoteClient.start_global_rumble_shake_large(numSeconds:number):void
	start_global_rumble_shake(numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_large.effect'));
end

function remoteClient.start_global_rumble_shake_small_noaudio(numSeconds:number):void
	start_global_rumble_shake(numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_small_noaudio.effect'));
end

function remoteClient.start_global_rumble_shake_medium_noaudio(numSeconds:number):void
	start_global_rumble_shake(numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_medium_noaudio.effect'));
end

function remoteClient.start_global_rumble_shake_large_noaudio(numSeconds:number):void
	start_global_rumble_shake(numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_large_noaudio.effect'));
end

function remoteClient.start_rumble_shake_client(numSeconds:number, rumble_shake:tag)
	start_global_rumble_shake(numSeconds, rumble_shake);
end



-- === rumble scripts: Screenshake and rumble for a fixed time for a specific player
--		simple screenshake and rumble function
--			player = the specific player that will have the screen shake
--			numSeconds = number of seconds to shake
--			rumble_shake (tag of the screen effec)
--	RETURNS:  void; when the screenshake is complete
function remoteClient.RumbleShakePlayerSmall(player:player, numSeconds:number):void
	if PlayerIsLocal(player) then
		RumbleShakePlayer(player, numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_small.effect'));
	end
end

function remoteClient.RumbleShakePlayerMedium(player:player, numSeconds:number):void
	if PlayerIsLocal(player) then
		RumbleShakePlayer(player, numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_medium.effect'));
	end
end

function remoteClient.RumbleShakePlayerLarge(player:player, numSeconds:number):void
	if PlayerIsLocal(player) then
		RumbleShakePlayer(player, numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_large.effect'));
	end
end

function remoteClient.RumbleShakePlayerSmall_noaudio(player:player, numSeconds:number):void
	if PlayerIsLocal(player) then
		RumbleShakePlayer(player, numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_small_noaudio.effect'));
	end
end

function remoteClient.RumbleShakePlayerMedium_noaudio(player:player, numSeconds:number):void
	if PlayerIsLocal(player) then
		RumbleShakePlayer(player, numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_medium_noaudio.effect'));
	end
end

function remoteClient.RumbleShakePlayerLarge_noaudio(player:player, numSeconds:number):void
	if PlayerIsLocal(player) then
		RumbleShakePlayer(player, numSeconds, TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_large_noaudio.effect'));
	end
end

function remoteClient.RumbleShakePlayer(player:player, numSeconds:number, rumble_shake:tag)
	if PlayerIsLocal(player) then
		RumbleShakePlayer(player, numSeconds, rumble_shake);
	end
end


-- === rumble scripts: Screenshake and rumble for a fixed time
--		simple screenshake and rumble functionRumbleShakePlayerSmall
--			numSeconds = number of seconds to shake
--			rumble_shake = the rumble effect tag to play
--	RETURNS:  void; when the screenshake is complete
function start_global_rumble_shake(numSeconds:number, rumble_shake:tag)
	local pls = local_players();
	for _, pl in ipairs (pls) do
		RumbleShakePlayer(pl, numSeconds, rumble_shake);
	end
end

function RumbleShakePlayer(player:player, numSeconds:number, rumble_shake:tag)
	numSeconds = numSeconds or 1.5;
	rumble_shake = rumble_shake or TAG('levels\assets\osiris\effects\rumble_shakes\global_rumble_shake_medium.effect');
	local sleepTime = 0.9;
	repeat
		effect_new(rumble_shake, player);
		sleep_s(sleepTime);
		numSeconds = numSeconds - sleepTime;
	until numSeconds <= 0.0
end

--This is called from a server function which is called through code whenever a player is teleported
--if the player is the one that was teleported, play a teleport effect.
function remoteClient.TeleportPlayerEffect(playerUnit:object)
	--print (playerUnit);
	--print (Player_GetUnit(Player_GetLocal(0)));
	--OSR-149881 - gmu -- having this only play on the local client no matter what
	--if PlayerIsLocal(unit_get_player(playerUnit)) then
	--	effect_new_on_object_marker(TAG('REMOVED'), playerUnit,"head");
	--end
end




-- -------------------------------------------------------------------------------------------------
-- FOV
-- -------------------------------------------------------------------------------------------------

--changing the fov on the camera is done with a C variable
--camera_fov
