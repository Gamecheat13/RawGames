--## SERVER

global b_looping_save_check_on:boolean=false;
global l_looping_save_thread_id:thread=nil;
global l_checkpoint_timer:number=0;
global r_checkpoint_ignore_time_default:number=10.0;

global b_combat_checkpoint_paused:boolean=false;
global l_combat_checkpoint_thread_id:thread=nil;

global l_save_thread_c62d03c8:thread=nil;

global l_time_delay_529da0a0:number=0;
global l_time_out_529da0a0:number=0;
-- =================================================================================================
-- AUTO CHECKPOINTING FOR GOALS
-- =================================================================================================

--Checkpoint the game with a point set
function CheckpointSet(points:point_set)

	local tab = {points[1], points[2], points [3], points [4]};
	--table.dprint (tab);
	sys_Checkpoint (tab);

end

--Checkpoint the game with 4 location points
--function CheckpointLoc(loc1:location, loc2:location, loc3:location, loc4:location)
--
--	local tab:table = {loc1, loc2, loc3, loc4};
--	sys_Checkpoint (tab);
--	
--end


--the base checkpoint function (most likely call one of the specific functions above)
--function sys_GoalCheckpoint (goal:table)
--	
--	local tab:table = {goal.checkPoints[1], goal.checkPoints[2], goal.checkPoints[3], goal.checkPoints[4]};
--	sys_Checkpoint (tab);
--	
--	
--end


function sys_Checkpoint (checkpoints:table)
	
	--make sure this isn't called on the client
	if not IsServer() then
		return print ("game save called on client, returning because checkpoints shouldn't run on client");
	end
	print ("game save called");

	game_save_no_timeout();

	
end



-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- CHECKPOINT HELPERS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------
-- CHECKPOINT: GENERAL
--	Combat checkpoints manage saving during combat.
-- -------------------------------------------------------------------------------------------------
-- Simple checkpoint system


function checkpoint_ignore_time_default():number
	return r_checkpoint_ignore_time_default;
end

--[[
script static void checkpoint_ignore_time_default( real r_delay )
	R_checkpoint_ignore_time_default = r_delay;
end
]]
function checkpoint_looping_begin( time_to_check:number ):void
	l_looping_save_thread_id = CreateThread(checkpoint_looping_think, time_to_check);
end

function checkpoint_looping_think( time_to_check:number ):void
	repeat
		Sleep(1);
		game_save_no_timeout();
		dprint("auto checkpoint attempted");
		sleep_s(time_to_check);
	until 1 == 0;
end

function checkpoint_looping_end():void
	dprint("auto checkpoint system ended");
	KillThread(l_looping_save_thread_id);
end

function checkpoint_timeout( b_auto_cancel:boolean, r_time:number, str_debug:string, r_checkpoint_time_min:number ):thread
	r_checkpoint_time_min = r_checkpoint_time_min or checkpoint_ignore_time_default();
	if game_safe_to_save() then
		checkpoint_immediate(str_debug, r_checkpoint_time_min);
		return nil;
	else
		return CreateThread(sys_checkpoint, b_auto_cancel, r_time, str_debug, r_checkpoint_time_min);
	end
end

--[[
script static long checkpoint_timeout( boolean b_auto_cancel, real r_time, string str_debug )
	checkpoint_timeout( b_auto_cancel, r_time, str_debug, checkpoint_ignore_time_default() );
end
script static long checkpoint_timeout( boolean b_auto_cancel, real r_time )
	checkpoint_timeout( b_auto_cancel, r_time, "", checkpoint_ignore_time_default() );
end
script static long checkpoint_timeout( boolean b_auto_cancel )
	checkpoint_timeout( b_auto_cancel, 0.0, "", checkpoint_ignore_time_default() );
end
script static long checkpoint_timeout()
	checkpoint_timeout( TRUE, 0.0, "", checkpoint_ignore_time_default() );
end
]]
function checkpoint_no_timeout( b_auto_cancel:boolean, str_debug:string, r_checkpoint_time_min:number ):thread
	r_checkpoint_time_min = r_checkpoint_time_min or checkpoint_ignore_time_default();
	if game_safe_to_save() then
		checkpoint_immediate(str_debug, r_checkpoint_time_min);
		return nil;
	else
		return CreateThread(sys_checkpoint, b_auto_cancel, -1, str_debug, r_checkpoint_time_min);
	end
end

--[[
script static long checkpoint_no_timeout( boolean b_auto_cancel, string str_debug )
	checkpoint_no_timeout( b_auto_cancel, str_debug, checkpoint_ignore_time_default() );
end
script static long checkpoint_no_timeout( boolean b_auto_cancel )
	checkpoint_no_timeout( b_auto_cancel, "", checkpoint_ignore_time_default() );
end
script static long checkpoint_no_timeout()
	checkpoint_no_timeout( TRUE, "", checkpoint_ignore_time_default() );
end
]]
function checkpoint_immediate( str_debug:string, r_checkpoint_time_min:number ):void
	local l_timer:number=l_checkpoint_timer;
	dprint("CHECKPOINT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
	if timer_expired(l_checkpoint_timer, r_checkpoint_time_min) or l_checkpoint_timer <= 0 then
		game_save_cancel();
		game_save_no_timeout();
		l_checkpoint_timer = timer_stamp();
	else
		dprint("SKIPPED: MIN TIME BETWEEN CHECKPOINTS TOO SHORT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
	end
	if str_debug~="" then
		dprint(str_debug);
	end
	print(timer_elapsed(l_timer));
	dprint("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
end

--[[
script static void checkpoint_immediate( string str_debug )
	checkpoint_immediate( str_debug, 0.0 );
end
]]
function sys_checkpoint( b_auto_cancel:boolean, r_time:number, str_debug:string, r_checkpoint_time_min:number ):void
	local l_timer:number=-1;
	dprint("CHECKPOINT WAIT START $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
	dprint(str_debug);
	if current_zone_set_fully_active() == nil then
		dprint("NOTE: CHECKPOINT ATTEMPTED WHILE STREAMING $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
	end
	-- store the current save thread
	l_save_thread_c62d03c8 = GetCurrentThreadId();
	-- start the timer
	if r_time >= 0 then
		l_timer = timer_stamp(r_time);
	end
	-- wait for safe save, thread disabled, or timer expires
	SleepUntil([| game_safe_to_save() or (b_auto_cancel and l_save_thread_c62d03c8~=GetCurrentThreadId()) or timer_expired(l_timer) ], 1);
	-- check if it's valid to save
	if game_safe_to_save() then
		checkpoint_immediate(str_debug, r_checkpoint_time_min);
	elseif l_save_thread_c62d03c8 == GetCurrentThreadId() then
		dprint("CHECKPOINT FAILED TO SAVE $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		dprint(str_debug);
		print(game_safe_to_save());
		print(timer_expired(l_timer));
	end
end

--dprint( "SAVE WAITING END $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" );
-- -------------------------------------------------------------------------------------------------
-- CHECKPOINT: COMBAT
--	Combat checkpoints manage saving during combat.
-- -------------------------------------------------------------------------------------------------
-- variables


-- functions
-- === f_combat_checkpoint_start: Starts a combat checkpoint.  Combat checkpoints wait for safe 
--																times in the combat encounter to checkpoint. There are options 
--																for managing the frequency of checkpoints.  When the squad is 
--																completely dead it will automatically shut down.
--		ai_watch [ai] 						- AI (single ai, squad, etc.) the AI the combat checkpoint watches
--		s_ai_state_start [short] 	- Minimum ai state to start combat checkpoint
--																[s_ai_state_start < 0] = DEFAULT; AI must be in a combat state
--		b_safe_toggled [boolean]	- Will not start the watch check until the game_safe_to_save() has
--																has toggled false.
--		s_checkpoint_max [short]	- Maximum number of checkpoints allowed in this combat checkpoint
--																-1 = Unlimited
--		r_time_delay [real]				- Minimum seconds between checkpoints
--		r_time_out [real]					- Maximum time the combat checkpoint will run for
--																< 0 = Unlimited
--	NOTE: Currently there can only be one combat checkpoint active at a time
--				Starting a new combat checkpoint will automatically kill the previous combat checkpoint thread
function f_combat_checkpoint_add( ai_watch:ai, s_ai_state_start:number, b_safe_toggled:boolean, s_checkpoint_max:number, r_time_delay:number, r_time_out:number ):thread
	-- defaults
	if s_ai_state_start < 0 then
		s_ai_state_start = ai_combat_status_uninspected;
	end
	-- make sure there's no thread to active
	f_combat_checkpoint_remove(nil);
	-- start the loop
	l_combat_checkpoint_thread_id = CreateThread(sys_combat_checkpoint, ai_watch, s_ai_state_start, b_safe_toggled, s_checkpoint_max, r_time_delay, r_time_out);
	return l_combat_checkpoint_thread_id;
end

-- return
-- === f_combat_checkpoint_kill: Kills the current running combat checkpoint thread
--		l_checkpoint_ID [long]- ID for the checkpoint to pause
--																0 = Any checkpoint
function f_combat_checkpoint_remove( l_checkpoint_id:thread ):void
	if f_combat_checkpoint_check(l_checkpoint_id) then
		KillThread(l_combat_checkpoint_thread_id);
		l_combat_checkpoint_thread_id = nil;
	end
end

-- === f_combat_checkpoint_pause: Pauses the combat checkpoint system from saving
--		l_checkpoint_ID [long]- ID for the checkpoint to pause
--																0 = Any checkpoint
--		b_pause [boolean] 				- Is the combat checkpoint system paused or not
--	NOTE: The purpose for this is if you want to prevent the player from saving during an event or
--				They are in a risky area, you can use this to manage the safety of the checkpoint
function f_combat_checkpoint_pause( l_checkpoint_id:thread, b_pause:boolean ):void
	if l_checkpoint_id == nil or l_checkpoint_id == l_combat_checkpoint_thread_id then
		b_combat_checkpoint_paused = b_pause;
	end
end

-- === f_combat_checkpoint_check: Checks if this is the current combat checkpoint ID
--		l_checkpoint_ID [long]- ID for the checkpoint to pause
--																0 = Any checkpoint
function f_combat_checkpoint_check( l_checkpoint_id:thread ):boolean
	return l_combat_checkpoint_thread_id~=nil and (l_checkpoint_id == nil or l_checkpoint_id == l_combat_checkpoint_thread_id);
end

-- === sys_combat_checkpoint: This handles the logic for the combat checkpoint, etc.
--	NOTE: DO NOT USE THIS FUNCTION
function sys_combat_checkpoint( ai_watch:ai, s_ai_state_start:number, b_safe_toggled:boolean, s_checkpoint_max:number, r_time_delay:number, r_time_out:number ):void
	-- wait for at least one to spawn
	SleepUntil([| ai_spawn_count(ai_watch) > 0 ], 1);
	-- wait for AI to reach it's starting state
	SleepUntil([| ai_combat_status(ai_watch) >= s_ai_state_start ], 1);
	-- start the time out timer
	l_time_out_529da0a0 = 0;
	if r_time_out >= 0.0 then
		l_time_out_529da0a0 = game_tick_get() + seconds_to_frames(r_time_out);
	end
	repeat
		Sleep(1);
		-- set delay
		l_time_delay_529da0a0 = 0;
		if r_time_delay >= 0.0 then
			l_time_delay_529da0a0 = game_tick_get() + seconds_to_frames(r_time_delay);
		end
		if b_safe_toggled then
			SleepUntil([|  not game_safe_to_save() or ai_living_count(ai_watch) <= 0 or l_time_out_529da0a0 < game_tick_get() ], 1);
		end
		SleepUntil([| ( not b_combat_checkpoint_paused and game_safe_to_save() and (ai_living_count(ai_watch) <= 0 or r_time_delay < 0.0 or l_time_delay_529da0a0 <= game_tick_get())) or (r_time_out >= 0.0 and l_time_out_529da0a0 < game_tick_get()) ], 1);
		-- try to save		
		if game_safe_to_save() and  not b_combat_checkpoint_paused and l_time_out_529da0a0 >= game_tick_get() then
			checkpoint_no_timeout(false, "sys_combat_checkpoint", checkpoint_ignore_time_default());
			s_checkpoint_max = s_checkpoint_max - 1;
		end
	until s_checkpoint_max == 0 or ai_living_count(ai_watch) <= 0 or l_time_out_529da0a0 < game_tick_get();
	dprint(">>>>>>>>>> COMBAT CHECKPOINT EXIT!!! >>>>>>>>>>");
	-- kill the thread identity
	l_combat_checkpoint_thread_id = nil;
end

