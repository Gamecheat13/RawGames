-- ===============================================================================================================================================
-- GLOBAL SCRIPTS ================================================================================================================================
-- ===============================================================================================================================================

-- =================================================================================================
-- Seconds vs Frames
-- =================================================================================================
function seconds_to_frames( r_seconds:number ):number
	return math.floor(r_seconds * n_fps());
end

function frames_to_seconds( l_frames:number ):number
	return (l_frames) / n_fps();
end

function n_fps( ):number
	return game_seconds_to_ticks(1);
end

-- =================================================================================================
-- Sleep seconds
-- =================================================================================================
function sleep_s( r_time:number ):void
	r_time = r_time or 0;
	Sleep(seconds_to_frames(r_time));
end

function sleep_rand_s( r_min:number, r_max:number ):void
	sleep_s(real_random_range(r_min, r_max));
end

-- =================================================================================================
-- =================================================================================================
-- CHANCE
-- =================================================================================================
-- =================================================================================================
function f_chance( r_percent:number ):boolean
	return real_random_range(0.0, 100.0) <= r_percent;
end

function f_chance_player_sees( r_percent_default:number, r_percent_seen:number, obj_target:object, r_angle:number ):boolean
	if objects_can_see_object(players(), obj_target, r_angle) then
		return f_chance(r_percent_seen);
	else
		return f_chance(r_percent_default);
	end
end





-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- TIMER
--	NOTE:  Initializing your timer to -1 (or anything less than 0) will make it so when testing the timer it will not expire until has been stamped
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
-- === timer_stamp: Starts a timer
--			r_time [real] = [optional] Time to stamp on the timer
--			r_time_min [real] = [optional] Minimum random time to stamp on the timer
--			r_time_max [real] = [optional] Minimum random time to stamp on the timer
--	RETURNS:  [long] Returns a timer value for when you start the timer

--return in seconds how long a mission has been run
function time_in_game()
		print(string.format("%.2f",game_tick_get()/n_fps()));
end

function time_duration()
	local time = game_tick_get()/n_fps();
	local hours = string.format("%02.f", math.floor(time/3600));
	local mins = string.format("%02.f", math.floor(time/60 - (hours*60)));
	local secs = string.format("%02.f", math.floor(time - hours*3600 - mins *60));
	
	if time == 0 then
		print ("00:00:00");
	else
		print ( hours..":"..mins..":"..secs );
	end
end

function timer_stamp( r_time_min:number, r_time_max:number ):number

	if ( (r_time_min ~= nil) and (r_time_max ~= nil) ) then
		r_time_min = seconds_to_frames( real_random_range(r_time_min, r_time_max) );
	elseif ( r_time_min ~= nil ) then
		r_time_min = seconds_to_frames( r_time_min );
	elseif ( r_time_max ~= nil ) then
		r_time_min = seconds_to_frames( r_time_max );
	else
		r_time_min = 0;
	end

	return game_tick_get() + r_time_min;
end

-- === timer_expired: Checks if a timer has expired
--			l_timer [long] = Timer variable you called timer_stamp() and returned into
--			r_time [real] = [optional] Time that has passed since the timer was stamped
--	RETURNS:  [long] Returns a timer value for when you start the timer
function timer_expired( l_timer:number, r_time:number ):boolean

	if ( r_time ~= nil ) then
		r_time = seconds_to_frames( r_time );
	else
		r_time = 0;
	end
	
	return ( l_timer >= 0 ) and ( ((l_timer + r_time) - game_tick_get()) <= 0.0 );
end

-- === timer_active: Checks if a timer is still active
--			l_timer [long] = Timer variable you called timer_stamp() and returned into
--			r_time [real] = [optional] Time that has passed since the timer was stamped
--	RETURNS:  [long] TRUE; timer is ative and was started
function timer_active( l_timer:number ):boolean
	return game_tick_get() <= l_timer and l_timer >= 0;
end

-- === timer_elapsed: Returns how much time has elapsed on a timer
--			l_timer [long] = Timer variable you called timer_stamp() and returned into
--	RETURNS:  [real] Number of seconds that has elapsed since the itmer started
function timer_elapsed( l_timer:number, r_time:number  ):number

	if l_timer > 0 then
	
		if ( r_time ~= nil ) then
			l_timer = l_timer + seconds_to_frames( r_time );
		end
		return frames_to_seconds( game_tick_get() - l_timer );
		
	else
		return 0;
	end
	
end

-- === timer_remaining: Returns how much time is remaining on the timer
--			l_timer [long] = Timer variable you called timer_stamp() and returned into
--	RETURNS:  [real] Number of seconds that has elapsed since the itmer started
function timer_remaining( l_timer:number, r_time:number  ):number

	if l_timer > 0 then
	
		if ( r_time ~= nil ) then
			l_timer = l_timer + seconds_to_frames( r_time );
		end
		return frames_to_seconds( l_timer - game_tick_get() );
		
	else
		return 0;
	end
	
end


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- param_default
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- === param_default: allows the user to pass in a list of "default" values, the first non-nil value will be returned
-- RETURN: the first non nil value in the arguement list
  	function param_default( ... )
  	
  		if ( type(arg) == "table" ) then
  			for key, value in ipairs(arg) do
  				return value;
  			end
  			for key, value in pairs(arg) do
  				return value;
  			end
  		end
  		return arg;
  	
		end

function sleep_real_seconds_NOT_QUITE_RELEASE(sleepTime:number)
	local sleepStartTime:number = get_total_game_time_seconds_NOT_QUITE_RELEASE();
	repeat
		Sleep(1);
		local curTime:number = get_total_game_time_seconds_NOT_QUITE_RELEASE();
	until(curTime - sleepStartTime >= sleepTime);
end




-- Testing feature, remove later: HAX
--global toggle_drops:boolean=false;
--global b_debug_globals:boolean=false;
--global s_md_play_time:number=0;
global s_camera_shake_loop_on:boolean=false;

-- Testing feature, remove later: HAX
--function toggle_drops_set( value:boolean ):void
--	toggle_drops = value;
--end



--********************************************
--probably SERVER from this point on UNTIL THE VERY BOTTOM


-- =================================================================================================
-- DPRINT
-- =================================================================================================
global b_dprint:boolean=true;

function dprint( s:string ):void
	if b_dprint then
		print(s);
	end
end

function dprint_if( b_if:boolean, s:string ):void
	if b_if then
		dprint(s);
	end
end

function dprint_if_else( b_if:boolean, s_true:string, s_false:string ):void
	if b_if then
		dprint(s_true);
	else
		dprint(s_false);
	end
end

function dprint_enable( b_enable:boolean ):void
	b_dprint = b_enable;
	dprint_if(b_enable, "dprint_enable");
end

-- === Shows temp text -- useful if there's not TTS or narrative
--			content = a string of text you want to show
--			n_time = the amount of time you want the text to show (nil is 2)
--			color = the color of the text:
--				red, blue, green, white, black - default is green
--	RETURNS:  void
function ShowTempText (content:string, n_time:number, color:string)
	n_time = n_time or 2;
	if color == "red" then
		sys_temp_text_defaults(1, 0, 0);
	elseif color == "blue" then
		sys_temp_text_defaults(0, 1, 0);
	elseif color == "green" then
		sys_temp_text_defaults(0, 0, 1);
	elseif color == "white" then
		sys_temp_text_defaults(1, 1, 1);
	elseif color == "black" then
		sys_temp_text_defaults(0, 0, 0);
	elseif color == nil then
		sys_temp_text_defaults();
	else
		sys_temp_text_defaults();
	end
	
	sys_temp_text (content, n_time);
end

function sys_temp_text_defaults(red:number, green:number, blue:number):void
	
	red = red or 0.22;
	green = green or 0.0;
	blue = blue or 0.77;
	set_text_defaults();
	-- color, scale, life, font
	set_text_color(1, red, blue, green);
	--set_text_color(1, 0.22, 0.77, 0.0);
	
	set_text_font(FONT_ID.terminal);
	set_text_scale(1.5);
	-- alignments
	set_text_alignment(TEXT_ALIGNMENT.bottom);
	set_text_margins(0.05, 0.0, 0.05, 0.1);
	set_text_indents(0, 0);
	set_text_justification(TEXT_JUSTIFICATION.center);
	set_text_wrap(true, true);
	-- shadow
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	set_text_shadow_color(1, 0, 0, 0);
end

global temp_text_index:number = 0;
function sys_temp_text( content:string, r_time:number ):void
	-- display the text!
	set_text_lifespan(seconds_to_frames(r_time));
	--show_text(content);
	temp_text_index = show_text_index(temp_text_index, content);
end

--## SERVER

function PauseGame()
	print ("PAUSING THE GAME");
--	if GlobalVar then
--		ScriptPause()
--	end
end


--- == Warp all valid players to a flag
function warpto( warp_point:flag ):void

	for i, val in ipairs (players()) do
		teleport_player_to_flag(val, warp_point, true);
	end
	
	
end


function print_difficulty():void
	if game_difficulty_get_real() == DIFFICULTY.easy then
		dprint("easy");
	end
	if game_difficulty_get_real() == DIFFICULTY.normal then
		dprint("normal");
	end
	if game_difficulty_get_real() == DIFFICULTY.heroic then
		dprint("heroic");
	end
	if game_difficulty_get_real() == DIFFICULTY.legendary then
		dprint("legendary");
	end
end
-- Globals 
global data_mine_mission_segment:string="";

-- Difficulty level scripts 
function difficulty_legendary():boolean
	return game_difficulty_get_real() == DIFFICULTY.legendary;
end

function difficulty_heroic():boolean
	return game_difficulty_get_real() == DIFFICULTY.heroic;
end

function difficulty_normal():boolean
	return game_difficulty_get_real() <= DIFFICULTY.normal;
end

--fades the vehicle out over 5 seconds and then erases it
function f_vehicle_scale_destroy( vehicle_variable:object ):void
	object_set_scale(vehicle_variable, 0.01, n_fps() * 5);
	--Sleep(30 * 5);
	sleep_s (5);
	object_destroy(vehicle_variable);
end

--for placing pelicans and falcons etc that are critial and cannot die
function f_ai_place_vehicle_deathless( squad:ai ):void
	print("f_ai_place_vehicle_deathless");
	ai_place(squad);
	ai_cannot_die(object_get_ai(vehicle_driver(ai_vehicle_get_from_squad(squad, 0))), true);
	object_cannot_die(ai_vehicle_get_from_squad(squad, 0), true);
end

function f_ai_place_vehicle_deathless_no_emp( squad:ai ):void
	ai_place(squad);
	ai_cannot_die(object_get_ai(vehicle_driver(ai_vehicle_get_from_squad(squad, 0))), true);
	object_cannot_die(ai_vehicle_get_from_squad(squad, 0), true);
	object_ignores_emp(ai_vehicle_get_from_squad(squad, 0), true);
end

--to get the number of ai passengers in a vehicle
function f_vehicle_rider_number( v:object ):number
	return list_count(vehicle_riders(v));
end

--to determine if first squad is riding in vehicle of second squad
--note: not sure if this is returning the intended result cf 3/30/11
function f_all_squad_in_vehicle( inf_squad:ai, vehicle_squad:ai ):boolean
	return ai_living_count(inf_squad) == 0 and ai_living_count(vehicle_squad) == f_vehicle_rider_number(ai_vehicle_get_from_squad(vehicle_squad, 0));
end

--return the driver of a vehicle assuming only one vehicle in squad
function f_ai_get_vehicle_driver( squad:ai ):ai
	return object_get_ai(vehicle_driver(ai_vehicle_get_from_squad(squad, 0)));
end

-- =======================================================
-- =======================================================
function objects_are_within_distance_of_object(testObjects:object_list, distance:number, targetObject:object):boolean
	local actualDistance:number = objects_distance_to_point(testObjects, targetObject);

	return (actualDistance >= 0 and actualDistance < distance);
end





-- =================================================================================================
-- =================================================================================================
-- FIRE DAMAGE
-- =================================================================================================
-- =================================================================================================
--function f_do_fire_damage_on_trigger( the_trig:volume ):void
--	--thread( f_do_fire_damage_per_player(the_trig, player0) );
--	--thread( f_do_fire_damage_per_player(the_trig, player1) );
--	--thread( f_do_fire_damage_per_player(the_trig, player2) );
--	--thread( f_do_fire_damage_per_player(the_trig, player3) );
--	f_damage_volume_players(the_trig, -1, -1, 1, 1, s_damage_type_fire, -1, -1, -1, -1);
--end

--[[
script static void f_do_fire_damage_per_player(trigger_volume the_trig, player the_player)
	if ( player_is_in_game(the_player) ) then
		repeat
			sleep_until (volume_test_object (the_trig, the_player), 1);
			damage_object_with_fire_from_trigger_volume (the_player, the_trig, "body", 10);
			dprint("Player took fire damage!");
			sleep (random_range(12, 22));
		until (FALSE, 1);
	end
end
]]
-- =================================================================================================
-- =================================================================================================
-- RECENT DAMAGE
-- =================================================================================================
-- =================================================================================================
function object_get_recent_damage_total( obj_object:object ):number
	return object_get_recent_body_damage(obj_object) + object_get_recent_shield_damage(obj_object);
end




-- ===============================================================================================================================================
-- Threads =======================================================================================================================================
-- ===============================================================================================================================================
-- f_thread_cleanup - A simple function for using a single variable to keep track of a thread; it takes the old thread and makes sure it's shut
--										down and returns the new thread index if it's still valid
function f_thread_cleanup( l_thread_old:thread, l_thread_new:thread ):thread
	if l_thread_old~=nil and l_thread_old~=GetCurrentThreadId() then
		KillThread(l_thread_old);
		l_thread_old = nil;
	end
	if  not IsThreadValid(l_thread_new) then
		l_thread_new = nil;
	end
	return l_thread_new;
end


-- ===== DO NOT DELETE THIS EVER ===================
function startup.beginning_mission_segment()
	data_mine_set_mission_segment("mission_start");
end

-- =================================================================================================
-- OBJECTIVES
-- =================================================================================================
function f_hud_obj_new( string_hud:string, string_start:string ):void
	f_hud_start_menu_obj(string_start);
	-- chud_show_screen_objective(string_hud);
	Sleep(160);
	-- chud_show_screen_objective("");
end

function f_hud_obj_repeat( string_hud:string ):void
	-- chud_show_screen_objective(string_hud);
	Sleep(160);
	-- chud_show_screen_objective("");
end

function f_hud_start_menu_obj( reference:string ):void
	objectives_clear();
	objectives_set_string(0, reference);
	objectives_show_string(reference);
end

-- =================================================================================================
-- CHAPTER TITLES
-- =================================================================================================
--function f_hud_chapter( string_hud:string ):void
--	chud_cinematic_fade(0, game_seconds_to_ticks(1));
--	Sleep(10);
--	chud_show_screen_chapter_title(string_hud);
--	chud_fade_chapter_title_for_player(PLAYERS.player0, 1, 30);
--	chud_fade_chapter_title_for_player(PLAYERS.player1, 1, 30);
--	chud_fade_chapter_title_for_player(PLAYERS.player2, 1, 30);
--	chud_fade_chapter_title_for_player(PLAYERS.player3, 1, 30);
--	Sleep(120);
--	chud_fade_chapter_title_for_player(PLAYERS.player0, 0, 30);
--	chud_fade_chapter_title_for_player(PLAYERS.player1, 0, 30);
--	chud_fade_chapter_title_for_player(PLAYERS.player2, 0, 30);
--	chud_fade_chapter_title_for_player(PLAYERS.player3, 0, 30);
--	chud_show_screen_chapter_title("");
--	Sleep(10);
--	chud_cinematic_fade(1, 30);
--end
global r_chapter_title_fade_in_default:number=1.5;
global r_chapter_title_display_default:number=6.5;
global r_chapter_title_fade_out_default:number=1.5;

-- === Letterboxes the screen, hides HUD (optionally), shows chapter titles, un-hides HUD (optional), un-letterboxes the screen
--			ct_title = chapter title to show
--			b_hud_hide = hide the hud during the letterbox
--			r_title_display_time = how long the chapter title is up
--			r_title_fade_in_time = how long the fade is for the HUD hiding
--			r_title_fade_out_time = how long the fade is for the HUD hiding
--	RETURNS:  void
function f_chapter_title( ct_title:title, b_hud_hide:boolean, r_title_display_time:number, r_title_fade_in_time:number, r_title_fade_out_time:number ):void
	r_title_display_time = r_title_display_time or r_chapter_title_display_default;
	r_title_fade_in_time = r_title_fade_in_time or r_chapter_title_fade_in_default;
	r_title_fade_out_time = r_title_fade_out_time or r_chapter_title_fade_out_default;
	-- show letterbox
	cinematic_show_letterbox(true);
	-- hide hud
	
	--global hide the hud
	--gmu 8/25/2015
	RunClientScript ("HudShowClient",false);
	--hud_show (false);
		
	if b_hud_hide then
		hud_play_global_animtion("screen_fade_out");
	end
	sleep_s(r_title_fade_in_time);
	if b_hud_hide then
		hud_stop_global_animtion("screen_fade_out");
	end
	cinematic_set_title(ct_title);
	sleep_s(r_title_display_time);
	-- hide letterbox	
	cinematic_show_letterbox(false);
	
	if b_hud_hide then
		hud_play_global_animtion("screen_fade_in");
	end
	sleep_s(r_title_fade_out_time);
	
	-- show hud
	--global show the hud
	--gmu 8/25/2015
	RunClientScript ("HudShowClient",true);
	--hud_show (true);
		
	if b_hud_hide then
		hud_stop_global_animtion("screen_fade_in");
	end
end



-- =================================================================================================
-- Navpoints (SERVER)
-- =================================================================================================
-- === object: the object to attach the navpoint
-- === blip_type: the type of navpoint to attach ("ally" or "enemy")

function NavpointShowAllServer(squad, blip_type)
	--should we check to see if the squad table has items in it?
	local squad_list = GetTableFromSquad(squad);
	for _, actor in pairs (squad_list) do
		navpoint_track_object_named (actor, blip_type);
	end
	--RunClientScript("NavpointShowAllClient", squad_list, blip_type);
end

function NavpointStopAllServer(squad)
	local squad_list = GetTableFromSquad(squad);
	for _, actor in pairs (squad_list) do
		navpoint_track_object(actor, false);
	end
	--RunClientScript("NavpointStopAllClient", GetTableFromSquad(squad) );
end

function GetTableFromSquad (squad):table
	local squad_count = ai_squad_group_get_squad_count(squad);
	local t_actorList = {};
	
	if squad_count == 0 then
		for _, actor in pairs (ai_actors (squad)) do
			t_actorList[#t_actorList + 1] = actor;
			--print ("actor added ", actor);
		end
	else
		for i = 0, (squad_count - 1) do
			local group_squad = ai_squad_group_get_squad(squad, i);
			for _, actor in pairs (ai_actors (group_squad)) do
				t_actorList[#t_actorList + 1] = actor;
				--print ("actor added ", actor);
			end
		end
	end
	--table.dprint (t_actorList);
	return t_actorList;
end

--## CLIENT

-- =================================================================================================
-- Navpoints (CLIENT)
-- =================================================================================================

function remoteClient.NavpointShowAllClient(squad:table, blip_type:string)
		
	for _, actor in pairs (squad) do
		navpoint_track_object_named (actor, blip_type);
	end
	
end

function remoteClient.NavpointStopAllClient(squad)
	for _, actor in pairs (squad) do
		navpoint_track_object(actor, false);
	end
end

function remoteClient.NavpointShowClient(player, object, blip_type)
	if player == PLAYERS.local0 then
		navpoint_track_object_named (object, blip_type);
	end
end

-- =================================================================================================
-- SHOW/HIDE HUD (CLIENT)
-- =================================================================================================


function remoteClient.HudShowClient (bool:boolean)
	hud_show (bool);
end


--## SERVER
-- =================================================================================================
-- Flash object
-- =================================================================================================
function f_hud_flash_object_fov( hud_object_highlight:object ):void
	SleepUntil([| objects_can_see_object(PLAYERS.player0, hud_object_highlight, 25)
						or objects_can_see_object(PLAYERS.player1, hud_object_highlight, 25)
						or objects_can_see_object(PLAYERS.player2, hud_object_highlight, 25)
						or objects_can_see_object(PLAYERS.player3, hud_object_highlight, 25) ], 1);
	chud_debug_highlight_object_color_red = 1;
	chud_debug_highlight_object_color_green = 1;
	chud_debug_highlight_object_color_blue = 0;
	f_hud_flash_single(hud_object_highlight);
	f_hud_flash_single(hud_object_highlight);
	f_hud_flash_single(hud_object_highlight);
	object_destroy(hud_object_highlight);
end

function f_hud_flash_object( hud_object_highlight:object ):void
	chud_debug_highlight_object_color_red = 1;
	chud_debug_highlight_object_color_green = 1;
	chud_debug_highlight_object_color_blue = 0;
	f_hud_flash_single(hud_object_highlight);
	f_hud_flash_single(hud_object_highlight);
	f_hud_flash_single(hud_object_highlight);
	object_destroy(hud_object_highlight);
end

function f_hud_flash_single( hud_object_highlight:object ):void
	object_hide(hud_object_highlight, false);
	chud_debug_highlight_object = hud_object_highlight;
	Sleep(4);
	object_hide(hud_object_highlight, true);
	Sleep(5);
end

function f_hud_flash_single_nodestroy( hud_object_highlight:object ):void
	chud_debug_highlight_object = hud_object_highlight;
	Sleep(4);
	chud_debug_highlight_object = nil;
	Sleep(5);
end
-- =================================================================================================
-- BLIPS and DOTS
-- =================================================================================================
--global sfx_blip:tag=TAG('sound\002_ui\002_ui_in_game\play_002_ui_in_game_objective_complete.sound');
global l_blip_list:object_list=players();
global b_blip_list_locked:boolean=false;
global s_blip_list_index:number=0;

-- =================================================================================================
-- low-level blip functions -- do not call directly!
--function f_blip_internal( obj:object, icon_disappear_time:number, final_delay:number ):void
--	navpoint_track_object(obj, true);
--	sound_impulse_start(sfx_blip, nil, 1);
--	Sleep(icon_disappear_time);
--	navpoint_track_object(obj, false);
--	Sleep(final_delay);
--end
--
--function f_blip_flag_internal( f:flag, icon_disappear_time:number, final_delay:number ):void
--	navpoint_track_flag(f, true);
--	sound_impulse_start(sfx_blip, nil, 1);
--	Sleep(icon_disappear_time);
--	navpoint_track_flag(f, false);
--	Sleep(final_delay);
--end
-- -------------------------------------------------------------------------------------------------
-- BLIPS
-- -------------------------------------------------------------------------------------------------
--[[
	navpoint_default
	navpoint_player
	navpoint_player_battle_awareness
	navpoint_battle_awareness
	navpoint_hologram
	navpoint_ghost_lock_on
	navpoint_locking
	navpoint_lock_on
	navpoint_airstrike
	navpoint_airstrike_locked
	navpoint_megalo_default
	navpoint_driver
	navpoint_passenger
	navpoint_passenger_gunner
	navpoint_enemy
	navpoint_enemy_group
	navpoint_enemy_vehicle
	navpoint_generic
	navpoint_activate
	navpoint_ammo
	navpoint_goto
	navpoint_healthbar
	navpoint_neutralize
	navpoint_driver
	navpoint_passenger
	navpoint_passenger_gunner
	navpoint_ordnance_drop
	navpoint_healthbar_neutralize
	navpoint_healthbar_defend
	reticule_tracking_default
	reticule_locked_on_default
	navpoint_random_ordnance_drop
	navpoint_defend
	navpoint_healthbar_destroy
	navpoint_sports_equipment
	navpoint_jetpack
	navpoint_xray
	sticky_detonator_motion_sensor
--]]
global blip_neutralize:number=0;
global blip_defend:number=1;
global blip_ordnance:number=2;
global blip_interface:number=3;
global blip_recon:number=4;
global blip_recover:number=5;
global blip_structure:number=6;
global blip_neutralize_alpha:number=7;
global blip_neutralize_bravo:number=8;
global blip_neutralize_charlie:number=9;
global blip_ammo:number=13;
global blip_hostile_vehicle:number=14;
global blip_hostile:number=15;
global blip_default_a:number=17;
global blip_default_b:number=18;
global blip_default_c:number=19;
global blip_default_d:number=20;
global blip_default:number=21;
global blip_destination:number=21;
global blip_type_id:number=21;
-- AA's
global blip_jetpack:number=41;
global blip_thruster:number=42;
global blip_shield:number=43;
global blip_pat:number=44;
global blip_regen:number=45;
global blip_hologram:number=46;
global blip_camo:number=47;
global blip_vision:number=48;

-- returns the type of blip, based on a string input
-- numbers are out of order, because the terrible string system
-- thinks that "ammo" and "a" are the same thing, it doesn't do
-- real string comparisons. First come, first serve!



function f_return_blip_type_cui( type:string ):string

	if type == "neutralize" then
		cui_string_blip = "navpoint_neutralize";
	end

	if type == "a" then
		cui_string_blip = "navpoint_goto";
	end
	if type == "b" then
		cui_string_blip = "navpoint_goto";
	end
	if type == "c" then
		cui_string_blip = "navpoint_goto";
	end
	if type == "d" then
		cui_string_blip = "navpoint_goto";
	end
	if type == "defend" then
		cui_string_blip = "navpoint_defend";
	end
	if type == "destroy" then
		cui_string_blip = "navpoint_destroy";
	end
	
	if type == "ordnance" then
		cui_string_blip = "navpoint_ammo";
	end
	if type == "activate" then
		cui_string_blip = "navpoint_activate";
	end
	
	if type == "recon" then
		cui_string_blip = "navpoint_goto";
	end
	
	if type == "recover" then
		cui_string_blip = "navpoint_generic";
	end
	
	if type == "neutralize_a" then
		cui_string_blip = "navpoint_neutralize";
	end
	if type == "neutralize_b" then
		cui_string_blip = "navpoint_neutralize";
	end
	if type == "neutralize_c" then
		cui_string_blip = "navpoint_neutralize";
	end
	if type == "ammo" then
		cui_string_blip = "navpoint_ammo";
	end
	if type == "enemy" then
		cui_string_blip = "navpoint_enemy";
	end
	if type == "order_attack" then
		cui_string_blip = "order_attack";
	end
	if type == "enemy_vehicle" then
		cui_string_blip = "navpoint_enemy_vehicle";
	end
	if type == "ally" then
		cui_string_blip = "navpoint_ally";
	end
	if type == "ally_group" then
		cui_string_blip = "navpoint_ally_group";
	end
	if type == "default" then
		cui_string_blip = "navpoint_goto";
	end
	return cui_string_blip;
end
global cui_string_blip:string="navpoint_goto";

-- blip a cinematic flag
--put in nil for parameters you don't want to use
-- === Blips a flag
--			f = the flag name
--			type = blip type (see above)
--			offset = how much vertical offset in WU
--			title = what string to show with the blip (only some of the blips support this)
--	RETURNS:  void
function f_blip_flag( f:flag, type:string, offset:number, title:string ):void
	
	if type == nil then
		type = "navpoint_generic";
	else
		type = f_return_blip_type_cui(type);
	end
	
	offset = offset or 0;
	
	if title == nil then
		navpoint_track_flag_named(f, type);
	else
		navpoint_track_flag_named_with_string(f, type, title);
	end
	
	navpoint_cutscene_flag_set_vertical_offset (f, offset);
	--sound_impulse_start(sfx_blip, nil, 1);
end

-- unblip a cinematic flag
function f_unblip_flag( f:flag ):void
	if navpoint_is_tracking_flag(f) then
		navpoint_track_flag(f, false);
		--sound_impulse_start(sfx_blip, nil, 1);
	end
end


-- blip an object
--put in nil for parameters you don't want to use
-- === Blips a flag
--			obj = the object name
--			type = blip type (see above)
--			offset = how much vertical offset in WU
--			title = what string to show with the blip (only some of the blips support this)
--	RETURNS:  void
function f_blip_object( obj:object, type:string, offset:number, title:string ):void
	
	if type == nil then
		type = "navpoint_generic"
	else
		type = f_return_blip_type_cui(type);
	end
	
	offset = offset or 0;

	if title == nil then
		navpoint_track_object_named(obj, type);
	else
		navpoint_track_object_named_with_string(obj, type, title);
	end
	
	navpoint_object_set_vertical_offset (obj, offset);
	--sound_impulse_start(sfx_blip, nil, 1);

end


-- turn off a blip on an object that was blipped forever
function f_unblip_object( obj:object ):void
	if navpoint_is_tracking_object(obj) then
		navpoint_track_object(obj, false);
		--sound_impulse_start(sfx_blip, nil, 1);
	end
end



-- blip ai actors (single or multiple)
-- === Blips AI
--			ai = the ai, group, squad or actor
--			type = blip type (see above)
--			offset = how much vertical offset in WU
--			title = what string to show with the blip (only some of the blips support this)
--	RETURNS:  void
function f_blip_ai( group:ai, blip_type:string, offset:number, title:string ):void
	SleepUntil([| b_blip_list_locked == false ], 1);
	print("blipping ai with blip", blip_type);
	b_blip_list_locked = true;

	for i, val in ipairs (ai_actors(group)) do
		f_blip_object(val, blip_type, offset, title);
	end

	b_blip_list_locked = false;
end

-- put a blip over AI until dead	


function f_unblip_ai( group:ai ):void
	SleepUntil([| b_blip_list_locked == false ], 1);
	print ("unblipping AI");
	b_blip_list_locked = true;
	
	for i, val in ipairs (ai_actors(group)) do
		f_unblip_object(val);
	end
	
	b_blip_list_locked = false;
end


--THIS IS AN EXAMPLE OF BLIPPING PER PLAYER BASED ON A TRIGGER VOLUME
--script static void f_e8_m1_navpoint_player (trigger_volume tv, player p_player, device dc, object target)
--	print ("navpoint to portal 2 started");
--	
--	//if players are in the cave then put up a goto waypoint to the end of the cave, else tell the players to go to the switch
--	repeat
--		sleep_until (volume_test_object (tv, p_player) or device_get_position (dc) > 0, 1);
--		print ("player in the trigger volume");
--		navpoint_track_object_for_player (p_player, dc, false);
--		if device_get_position (dc) == 0 then
--			sleep_until (b_wait_for_narrative_hud == false, 1);
--			navpoint_track_object_for_player_named (p_player, target, "navpoint_goto");
--		end
--		sleep_until (not volume_test_object (tv, p_player) or device_get_position (dc) > 0, 1);
--		print ("player NOT in the trigger volume");
--		navpoint_track_object_for_player (p_player, target, false);
--		if device_get_position (dc) == 0 then
--			sleep_until (b_wait_for_narrative_hud == false, 1);
--			navpoint_track_object_for_player_named (p_player, dc, "navpoint_deactivate");
--		end
--	until (device_get_position (dc) > 0, 1);
--	//clear the navpoints no matter what
--	print ("navpoint thread done");
--	//navpoint_track_object_for_player (player, area_3, false);
--	navpoint_track_object_for_player (p_player, dc, false);
--end



-- blip a flag, but unblip it when you get close
--put in nil for parameters you don't want to use
-- === Blips a flag by distance
--			p_player = the player
--			t_flags = the table of flags 
--			distance = the distance from the flag where it will turn off
--			
--	RETURNS:  void
function f_blip_flags_by_distance (p_player:player, t_flags:table, distance:number)
	print ("start blip by distance");
	
	distance = distance or 5;
	--print ("distance is", distance);
	for key,val in hpairs(t_flags) do
		CreateThread (sys_blip_tracker, p_player, t_flags, key, val, distance);
		--print (key, "is", val);
	end
		--print ("blipping target");
end

function f_blip_track_flags_all_players(t_flags:table, distance:number)
	for key,player in hpairs(players()) do
		CreateThread (f_blip_flags_by_distance, player, t_flags, distance);
		--print (key, "is", val);
	end
end

function sys_blip_tracker(p_player:player, t_flags:table, key:number, target:flag, distance:number)
	while t_flags[key] do
		navpoint_track_flag_for_player(p_player, target, true);
		--print ("blipping", target);

		SleepUntil ([|(objects_distance_to_point (p_player, target) <= distance and objects_distance_to_point (p_player, target) > 0) or t_flags[key]==nil], 5);

		--print ("player within distance unblipping", target);
		navpoint_track_flag_for_player(p_player, target, false);
		SleepUntil ([|objects_distance_to_point (p_player, target) > distance or t_flags[key]==nil], 5);
	end
	--print (t_flags[key], "is nil, no longer tracking it");	
end



function f_blip_flags_all_players(t_flags:table, distance:number)
	for key,val in hpairs(players()) do
		CreateThread (f_blip_flags_all_by_distance, val, t_flags, distance);
		--print (key, "is", val);
		Sleep (1);
	end
end

function f_blip_flags_all_by_distance (p_player:player, t_flags:table, distance:number)
	print ("start blip by distance");
	
	distance = distance or 5;
	--print ("distance is", distance);
	for key,val in hpairs(t_flags) do
		CreateThread (sys_blip_tracker_all, p_player, t_flags, key, val, distance);
		--print (key, "is", val);
	end
		
end



function sys_blip_tracker_all(p_player:player, t_flags:table, key:number, target:flag, distance:number)
	while t_flags[key] do
		navpoint_track_flag_for_player(p_player, target, true);
		--print ("blipping", target);
		SleepUntil ([|(objects_distance_to_point (p_player, target) <= distance and objects_distance_to_point (p_player, target) > 0) or t_flags[key]==nil], 5);
		--print ("player within distance unblipping", target);
			
		if t_flags[key] ~= nil then
			--unblip all flags
			for key,val in hpairs(t_flags) do
				navpoint_track_flag_for_player(p_player, val, false);
			end
			SleepUntil ([|objects_distance_to_point (p_player, target) > distance or t_flags[key]==nil], 5);
			
			--blip all flags
			for key,val in hpairs(t_flags) do
			--print (key, val);
				navpoint_track_flag_for_player(p_player, val, true);
			end
		else
			--the key is nil, only unblip the nils keys flag
			navpoint_track_flag_for_player(p_player, target, false);
		end
		--print ("blipping again");
	end
	--print (t_flags[key], "is nil, no longer tracking it");	
end

-- =================================================================================================
-- CALLOUT SCRIPTS
-- =================================================================================================


-- === Blip an object for a limited time
--			obj = the object name
--			blip_type = blip type (see above)
--			time = the time the blip is active
--			offset = how much vertical offset in WU
--			postdelay = sleeptime after the blip is gone
--	RETURNS:  void
function f_callout_object( obj:object, blip_type:string, time:number, offset:number, postdelay:number ):void
	
	if blip_type == nil then
		blip_type = "navpoint_generic"
	else
		blip_type = f_return_blip_type_cui(blip_type);
	end
	
	if time == nil then
		time = 3;
	end
	
	if offset == nil then
		offset = 0;
	end

	navpoint_track_object_named(obj, blip_type);
		
	navpoint_object_set_vertical_offset (obj, offset);
	--sound_impulse_start(sfx_blip, nil, 1);
	
	sleep_s(time);
	f_unblip_object(obj);
	
	if postdelay ~= nil then
		Sleep(postdelay);
	end
	
end


-- === Blip flag for a limited time
--			f = the flag name
--			blip_type = blip type (see above)
--			time = the time the blip is active
--			offset = how much vertical offset in WU
--			postdelay = sleeptime after the blip is gone
--	RETURNS:  void
function f_callout_flag( f:flag, blip_type:string, time:number, offset:number, postdelay:number ):void
	
	if blip_type == nil then
		blip_type = "navpoint_generic"
	else
		blip_type = f_return_blip_type_cui(blip_type);
	end
	
	if time == nil then
		time = 3;
	end
	
	if offset == nil then
		offset = 0;
	end

	navpoint_track_flag_named(f, blip_type);
		
	navpoint_cutscene_flag_set_vertical_offset (f, offset);
	--sound_impulse_start(sfx_blip, nil, 1);
	
	sleep_s(time);
	f_unblip_flag(f);
	
	if postdelay ~= nil then
		Sleep(postdelay);
	end
end

-- === Blip AI for a limited time
--			ai = the AI name
--			blip_type = blip type (see above)
--			time = the time the blip is active
--			offset = how much vertical offset in WU
--			postdelay = sleeptime after the blip is gone
--	RETURNS:  void
function f_callout_ai( group:ai, blip_type:string, time:number, offset:number, postdelay:number ):void
	SleepUntil([| b_blip_list_locked == false ], 1);
	print("blipping ai with blip", blip_type);
	b_blip_list_locked = true;

	for i, val in ipairs (ai_actors(group)) do
		f_callout_object(val, blip_type, time, offset, postdelay);
	end

	b_blip_list_locked = false;
end





--navpoint_cutscene_flag_set_color(cutscene, long)
--
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- DOTS
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

--this needs to be client
--sound_impulse_start <sound> <object> <real>
--sound_impulse_time <sound>
--script dot object Sound
--global b_undot_sound_playing:boolean=false;
--
--function undot_sound_play():void
--	if  not b_undot_sound_playing then
--		b_undot_sound_playing = true;
--		
--		for i, val in ipairs (players()) do
--			sound_impulse_start(TAG('sound\002_ui\002_ui_in_game\play_002_ui_in_game_objective_complete.sound'), val, 1);
--		end
----		sound_impulse_start(TAG('sound\002_ui\002_ui_in_game\play_002_ui_in_game_objective_complete.sound'), PLAYERS.player0, 1);
----		sound_impulse_start(TAG('sound\002_ui\002_ui_in_game\play_002_ui_in_game_objective_complete.sound'), PLAYERS.player1, 1);
----		sound_impulse_start(TAG('sound\002_ui\002_ui_in_game\play_002_ui_in_game_objective_complete.sound'), PLAYERS.player2, 1);
----		sound_impulse_start(TAG('sound\002_ui\002_ui_in_game\play_002_ui_in_game_objective_complete.sound'), PLAYERS.player3, 1);
--		sleep_s(2.5);
--		b_undot_sound_playing = false;
--	end
--end

--DOT OBJECT=============================================================
--default dot function, places dot, blips for 6 seconds and has sound
function dot_object( object:object, symbol:string, color:string ):void
	dot_object_control(object, symbol, color, true, 6, true);
end

--dot function with permanent blip that needs to be cleared with undot_object
function dot_object_blip( object:object, symbol:string, color:string ):void
	--dot_object_control(object, symbol, color, TRUE, -1,  TRUE );
	dot_object_control(object, symbol, color, true, 6, true);
end

--defualt dot function, places dot, blips for 6 seconds and has sound
function dot_smash_pot( object:object, symbol:string, color:string ):void
	dot_object_control(object, symbol, color, false, 0, false);
end

--Function that clears dot and blip from an object
function undot_object( object:object ):void
	radar_track_object(object, -1);
	navpoint_track_object(object, false);
	--CreateThread(undot_sound_play);
end

--Master dot object function that allows for unique doting situations
function dot_object_control( object:object, symbol:string, color:string, b_blip:boolean, r_blip_length:number, b_sound:boolean ):void
	--blip
	if b_blip then
		navpoint_track_object_named(object, "navpoint_goto_color");
		navpoint_object_set_color(object, dots_color(color));
	end
	--sound
	if b_sound then
		print("sound");
	end
	--insert sound stuff here
	--dot
	radar_track_object(object, 0);
	radar_object_set_icon(object, dots_symbol(symbol));
	radar_object_set_color(object, dots_color(color));
	radar_object_set_ignore_range(object, true);
	navpoint_object_set_color(object, dots_color(color));
	--unblip
	if b_blip and r_blip_length > 0 then
		CreateThread(dot_object_unblip, object, r_blip_length);
	end
end

--unblip object
function dot_object_unblip( object:object, blip_time:number ):void
	sleep_s(blip_time);
	navpoint_track_object(object, false);
end

--DOT FLAG=============================================================
--defualt dot function, places dot, blips for 6 seconds and has sound
function dot_flag( flag:flag, symbol:string, color:string ):void
	dot_flag_control(flag, symbol, color, true, 6, true);
end

--dot function with permanent blip that needs to be cleared with undot_flag
function dot_flag_blip( flag:flag, symbol:string, color:string ):void
	--dot_flag_control(flag, symbol, color, TRUE, -1, TRUE);
	dot_flag_control(flag, symbol, color, true, 6, true);
end

--Function that clears dot and blip from an flag
function undot_flag( flag:flag ):void
	radar_track_flag(flag, -1);
	navpoint_track_flag(flag, false);
	--CreateThread(undot_sound_play);
end

--Master dot flag function that allows for unique doting situations
function dot_flag_control( flag:flag, symbol:string, color:string, b_blip:boolean, r_blip_length:number, b_sound:boolean ):void
	--blip
	if b_blip then
		navpoint_track_flag_named(flag, "navpoint_goto_color");
		navpoint_cutscene_flag_set_color(flag, dots_color(color));
	end
	--sound
	if b_sound then
		print("sound");
		--insert sound stuff here
		for i, val in ipairs (players()) do
--			sound_impulse_start(TAG('sound\002_ui\002_ui_in_game\play_002_ui_in_game_objective_complete.sound'), val, 1);
		end

	end
	--dot
	radar_track_flag(flag, 0);
	radar_flag_set_icon(flag, dots_symbol(symbol));
	radar_flag_set_color(flag, dots_color(color));
	radar_flag_set_ignore_range(flag, true);
	--unblip
	if b_blip and r_blip_length > 0 then
		CreateThread(dot_flag_unblip, flag, r_blip_length);
	end
end

--unblip
function dot_flag_unblip( flag:flag, r_blip_length:number ):void
	sleep_s(r_blip_length);
	navpoint_track_flag(flag, false);
end

--DOT AI GROUP=============================================================
--dots a squad or squad group (current limitation is 10 guys)
function dot_guys( guys:ai, symbol:string, color:string ):void
	local ol_guys:object_list=ai_actors(guys);
	local s_guys_total:number=list_count(ol_guys);
	local s_guy_current:number=0;
	--REMOVE WHEN FIXED
	if s_guys_total > 10 then
		print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		print("WARNING DOT_GUYS IS CURRENTLY LIMITED TO 10 DOTS PER CALL");
		print("WARNING DOT_GUYS IS CURRENTLY LIMITED TO 10 DOTS PER CALL");
		print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
	end
	repeat
		Sleep(1);
		--XXX
		s_guy_current = s_guy_current + 1;
		CreateThread(dot_guy, list_get(ol_guys, s_guy_current), symbol, color);
	until s_guy_current >= s_guys_total;
end

function undot_guys( guys:ai ):void
	local ol_guys:object_list=ai_actors(guys);
	local s_guys_total:number=list_count(ol_guys);
	local s_guy_current:number=0;
	--REMOVE WHEN FIXED
	if s_guys_total > 10 then
		print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		print("WARNING DOT_GUYS IS CURRENTLY LIMITED TO 10 DOTS PER CALL");
		print("WARNING DOT_GUYS IS CURRENTLY LIMITED TO 10 DOTS PER CALL");
		print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
	end
	repeat
		Sleep(1);
		--XXX
		s_guy_current = s_guy_current + 1;
		undot_guy(list_get(ol_guys, s_guy_current));
	until s_guy_current >= s_guys_total;
	--CreateThread(undot_sound_play);
end

--AI GUY=============================================================
function dot_guy( guy:object, symbol:string, color:string ):void
	dot_object_control(guy, symbol, color, true, 6, true);
end

function dot_guy_blip( guy:object, symbol:string, color:string ):void
	dot_object_control(guy, symbol, color, true, -1, true);
end

--undot
function undot_guy( guy:object ):void
	radar_track_object(guy, -1);
	navpoint_track_object(guy, false);
end

--DOT UTILITY=============================================================
function dots_symbol( symbol:string ):number
	local l_symbol_id:number=1;
	if symbol == "dot" then
		l_symbol_id = 1;
	end
	if symbol == "diamond" then
		l_symbol_id = 1;
	end
	if symbol == "nothing" then
		l_symbol_id = 1;
	end
	if symbol == "diamond2" then
		l_symbol_id = 1;
	end
	if symbol == "x" then
		l_symbol_id = 1;
	end
	if symbol == "triangle" then
		l_symbol_id = 1;
	end
	if symbol == "skull" then
		l_symbol_id = 1;
	end
	if symbol == "target" then
		l_symbol_id = 1;
	end
	if symbol == "star" then
		l_symbol_id = 1;
	end
	if symbol == "flag" then
		l_symbol_id = 1;
	end
	if symbol == "ammo" then
		l_symbol_id = 1;
	end
	if symbol == "lightning" then
		l_symbol_id = 1;
	end
	if symbol == "shield" then
		l_symbol_id = 1;
	end
	if symbol == "arrow" then
		l_symbol_id = 1;
	end
	if symbol == "iamkingmode" then
		l_symbol_id = 1;
	end
	--vehicles
	if symbol == "warthog" then
		l_symbol_id = 0;
	end
	if symbol == "ghost" then
		l_symbol_id = 1;
	end
	if symbol == "scorpion" then
		l_symbol_id = 2;
	end
	if symbol == "wraith" then
		l_symbol_id = 3;
	end
	if symbol == "banshee" then
		l_symbol_id = 4;
	end
	if symbol == "mongoose" then
		l_symbol_id = 5;
	end
	if symbol == "pelican" then
		l_symbol_id = 11;
	end
	if symbol == "plasma_turret" then
		l_symbol_id = 13;
	end
	if symbol == "shade_turret" then
		l_symbol_id = 13;
	end
	if symbol == "mech" then
		l_symbol_id = 15;
	end
	return l_symbol_id;
end

function dots_color( color:string ):number
	local l_colo_id:number=0;
	if color == "yellow" then
		l_colo_id = 0;
	end
	if color == "red" then
		l_colo_id = 1;
	end
	if color == "blue" then
		l_colo_id = 2;
	end
	if color == "purple" then
		l_colo_id = 3;
	end
	if color == "pink" then
		l_colo_id = 4;
	end
	if color == "green" then
		l_colo_id = 5;
	end
	if color == "orange" then
		l_colo_id = 6;
	end
	if color == "white" then
		l_colo_id = 7;
	end
	--just for ray star == purple
	if color == "star" then
		l_colo_id = 3;
	end
	return l_colo_id;
end

function dotlisttype():void
	print("LIST OF VALID SYMBOLS");
	print("=============================");
	print("dot");
	print("diamond");
	print("nothing");
	print("diamond2");
	print("x");
	print("triangle");
	print("skull");
	print("target");
	print("star");
	print("flag");
	print("ammo");
	print("lightning");
	print("shield");
	print("arrow");
	print("iamkingmode");
end

function dotlistcolor():void
	print("LIST OF VALID SYMBOLS");
	print("=============================");
	print("yellow");
	print("red");
	print("blue");
	print("purple");
	print("pink");
	print("green");
	print("orange");
	print("white");
end

-- new blip===========================================================
function blip_flag_color( flag:flag, str_type:string, str_color:string ):void
	navpoint_track_flag_named(flag, navpoint_color_type(str_type));
	navpoint_cutscene_flag_set_color(flag, dots_color(str_color));
	--sound_impulse_start(sfx_blip, nil, 1);
end

function blip_object_color( object:object, str_type:string, str_color:string ):void
	navpoint_track_object_named(object, navpoint_color_type(str_type));
	navpoint_object_set_color(object, dots_color(str_color));
	--sound_impulse_start(sfx_blip, nil, 1);
end

function navpoint_color_type( str_type:string ):string
	local cui_string:string="navpoint_goto_color";
	if str_type == "recon" then
		cui_string = "navpoint_goto_color";
	elseif str_type == "chevron" then
		cui_string = "navpoint_generic_color";
	else
		cui_string = "navpoint_goto_color";
	end
	return cui_string;
end


--[[
; =================================================================================================
; DEBUG RENDERING OF PATHFINDING STUFF
; =================================================================================================

;(script static void debug_toggle_cookie_cutters
;	(if (= debug_instanced_geometry 0)
;		(begin
;			(set debug_objects_collision_models 0)
;			(set debug_objects_physics_models 0)
;			(set debug_objects_bounding_spheres 0)
;			(set debug_objects_cookie_cutters 1)
;			(set debug_objects 1)
;
;			(set debug_instanced_geometry_collision_geometry 0)
;			(set debug_instanced_geometry_cookie_cutters 1)
;			(set debug_instanced_geometry 1)
;		)
;		(begin
;			(set debug_objects_cookie_cutters 0)
;			(set debug_objects 0)
;
;			(set debug_instanced_geometry_cookie_cutters 0)
;			(set debug_instanced_geometry 0)
;		)
;	)
;)
]]





--function f_hud_training_timed_players( string_hud:string, r_time:number ):void
----	if player_valid(PLAYERS.player0) then
----		CreateThread(f_hud_training_timed, PLAYERS.player0, string_hud, r_time);
----	end
----	if player_valid(PLAYERS.player1) then
----		CreateThread(f_hud_training_timed, PLAYERS.player1, string_hud, r_time);
----	end
----	if player_valid(PLAYERS.player2) then
----		CreateThread(f_hud_training_timed, PLAYERS.player2, string_hud, r_time);
----	end
----	if player_valid(PLAYERS.player3) then
----		CreateThread(f_hud_training_timed, PLAYERS.player3, string_hud, r_time);
----	end
--	
--	for i, val in ipairs(players()) do
--		CreateThread(f_hud_training_timed, val, string_hud, r_time);
--	end
--end
--
--function f_hud_training_timed( player_num:player, string_hud:string, r_time:number ):void
--	chud_show_screen_training(player_num, string_hud);
--	if r_time >= 0.0 then
--		sleep_s(r_time);
--		f_hud_training_clear(player_num);
--	end
--end
--
--function f_hud_training( player_num:player, string_hud:string ):void
--	f_hud_training_timed(player_num, string_hud, 4.0);
--end
--
--function f_hud_training_forever( player_num:player, string_hud:string ):void
--	f_hud_training_timed(player_num, string_hud, -1);
--end
--
--function f_hud_training_clear( player_num:player ):void
--	chud_show_screen_training(player_num, "");
--end


--=============================================================================================================================================== 
-- MESSAGE CONFIRMATION SCRIPTS ================================================================================================================== 
--=============================================================================================================================================== 

-- don't think these are necessary anymore -- gmu
--global sfx_a_button:tag=TAG('sound\midnight\ui\omaha_ui\a_button.sound');
--global sfx_b_button:tag=TAG('sound\midnight\ui\omaha_ui\b_button.sound');
----global sfx_hud_in:tag=TAG('sound\game_sfx\ui\hud_ui\hud_in.sound');
----global sfx_hud_out:tag=TAG('sound\game_sfx\ui\hud_ui\hud_out.sound');
--global sfx_objective:tag=TAG('sound\002_ui\002_ui_in_game\play_002_ui_in_game_objective_complete.sound');
--global sfx_tutorial_complete:tag=TAG('sound\midnight\ui\play_ui_character_spawn_v2.sound');
--
--function f_sfx_a_button( player_short:number ):void
--	sound_impulse_start(sfx_a_button, player_get(player_short), 1);
--end
--
--function f_sfx_b_button( player_short:number ):void
--	sound_impulse_start(sfx_b_button, player_get(player_short), 1);
--end
--
--function f_sfx_blip( player_short:number ):void
--	sound_impulse_start(sfx_blip, player_get(player_short), 1);
--end
--
----function f_sfx_hud_in( player_short:number ):void
----	sound_impulse_start(sfx_hud_in, player_get(player_short), 1);
----end
----
----function f_sfx_hud_out( player_short:number ):void
----	sound_impulse_start(sfx_hud_out, player_get(player_short), 1);
----end
--
--function f_sfx_objective( player_short:number ):void
--	sound_impulse_start(sfx_objective, player_get(player_short), 1);
--end
--
--function f_sfx_complete( player_short:number ):void
--	sound_impulse_start(sfx_tutorial_complete, player_get(player_short), 1);
--end
--
--function f_sfx_hud_tutorial_complete( player_to_train:player ):void
--	sound_impulse_start(sfx_tutorial_complete, player_to_train, 1);
--end
--
---- TIMEOUT 
--function f_display_message( player_short:number, display_title:title ):void
--	chud_show_cinematic_title(player_get(player_short), display_title);
--	Sleep(5);
--end

--need to move these to Client and rewrite -- gmu
--function f_tutorial_begin( player_to_train:player, display_title:string ):void
--	--(chud_show_cinematic_title (player_get player_short) display_title)
--	f_hud_training_forever(player_to_train, display_title);
--	Sleep(5);
--	unit_action_test_reset(player_to_train);
--	Sleep(5);
--end
--
--function f_tutorial_end( player_to_train:player ):void
--	f_sfx_hud_tutorial_complete(player_to_train);
--	f_hud_training_clear(player_to_train);
--	--Sleep(30);
--	sleep_s(1);
--end
--
--function f_tutorial_right_bumper( player_variable:player, display_title:string ):void
--	f_tutorial_begin(player_variable, display_title);
--	SleepUntil([| unit_action_test_melee(player_variable) ], 1);
--	sleep_s(1);
--	f_tutorial_end(player_variable);
--end
--
--function f_tutorial_left_bumper( player_variable:player, display_title:string ):void
--	f_tutorial_begin(player_variable, display_title);
--	SleepUntil([| unit_action_test_equipment(player_variable) ], 1);
--	sleep_s(1);
--	f_tutorial_end(player_variable);
--end
--
---- BOOST
--function f_tutorial_boost( player_variable:player, display_title:string ):void
--	f_tutorial_begin(player_variable, display_title);
--	SleepUntil([| unit_action_test_grenade_trigger(player_variable) ], 1);
--	sleep_s(1);
--	f_tutorial_end(player_variable);
--end
--
---- SWITCH WEAPONS
--function f_tutorial_rotate_weapons( player_variable:player, display_title:string ):void
--	f_tutorial_begin(player_variable, display_title);
--	SleepUntil([| unit_action_test_rotate_weapons(player_variable) ], 1);
--	sleep_s(1);
--	f_tutorial_end(player_variable);
--end
--
---- SWITCH WEAPONS
--function f_tutorial_fire_weapon( player_variable:player, display_title:string ):void
--	f_tutorial_begin(player_variable, display_title);
--	SleepUntil([| unit_action_test_primary_trigger(player_variable) ], 1);
--	sleep_s(1);
--	f_tutorial_end(player_variable);
--end
--
--function f_tutorial_turn( player_variable:player, display_title:string ):void
--	f_tutorial_begin(player_variable, display_title);
--	Sleep(20);
--	SleepUntil([| unit_action_test_look_relative_all_directions(player_variable) ], 1);
--	sleep_s(1);
--	f_tutorial_end(player_variable);
--end
--
--function f_tutorial_throttle( player_variable:player, display_title:string ):void
--	f_tutorial_begin(player_variable, display_title);
--	Sleep(20);
--	SleepUntil([| unit_action_test_move_relative_all_directions(player_variable) ], 1);
--	sleep_s(1);
--	f_tutorial_end(player_variable);
--end
--
--function f_tutorial_tricks( player_variable:player, display_title:string ):void
--	f_tutorial_begin(player_variable, display_title);
--	SleepUntil([| unit_action_test_vehicle_trick_secondary(player_variable) ], 1);
--	sleep_s(1);
--	f_tutorial_end(player_variable);
--end


--clean out CHUD references
-- =================================================================================================
-- TRAINING
-- =================================================================================================

--need to make these client scripts if necessary
--function f_hud_training_timed_players( string_hud:string, r_time:number ):void
----	if player_valid(PLAYERS.player0) then
----		CreateThread(f_hud_training_timed, PLAYERS.player0, string_hud, r_time);
----	end
----	if player_valid(PLAYERS.player1) then
----		CreateThread(f_hud_training_timed, PLAYERS.player1, string_hud, r_time);
----	end
----	if player_valid(PLAYERS.player2) then
----		CreateThread(f_hud_training_timed, PLAYERS.player2, string_hud, r_time);
----	end
----	if player_valid(PLAYERS.player3) then
----		CreateThread(f_hud_training_timed, PLAYERS.player3, string_hud, r_time);
----	end
--	
--	for i, val in ipairs(players()) do
--		CreateThread(f_hud_training_timed, val, string_hud, r_time);
--	end
--end
--
--function f_hud_training_timed( player_num:player, string_hud:string, r_time:number ):void
--	chud_show_screen_training(player_num, string_hud);
--	if r_time >= 0.0 then
--		sleep_s(r_time);
--		f_hud_training_clear(player_num);
--	end
--end
--
--function f_hud_training( player_num:player, string_hud:string ):void
--	f_hud_training_timed(player_num, string_hud, 4.0);
--end
--
--function f_hud_training_forever( player_num:player, string_hud:string ):void
--	f_hud_training_timed(player_num, string_hud, -1);
--end
--
--function f_hud_training_clear( player_num:player ):void
--	chud_show_screen_training(player_num, "");
--end
--
--function f_hud_training_new_weapon():void
--	-- chud_set_static_hs_variable(PLAYERS.player0, 0, 1);
--	-- chud_set_static_hs_variable(PLAYERS.player1, 0, 1);
--	-- chud_set_static_hs_variable(PLAYERS.player2, 0, 1);
--	-- chud_set_static_hs_variable(PLAYERS.player3, 0, 1);
--	Sleep(200);
--	-- chud_clear_hs_variable(PLAYERS.player0, 0);
--	-- chud_clear_hs_variable(PLAYERS.player1, 0);
--	-- chud_clear_hs_variable(PLAYERS.player2, 0);
--	-- chud_clear_hs_variable(PLAYERS.player3, 0);
--end
--
--function f_hud_training_new_weapon_player( p:player ):void
--	-- chud_set_static_hs_variable(p, 0, 1);
--	Sleep(200);
--	-- chud_clear_hs_variable(p, 0);
--end
--
--function f_hud_training_new_weapon_player_clear( p:player ):void
--	-- chud_clear_hs_variable(p, 0);
--end


-- MISSION DIALOGUE
-- =================================================================================================
-- Play the specified line, then delay afterwards for a specified amount of time.
-- added if statement to check if character exists so we don't get into bad situations- dmiller 5/25

--removing because this is redundant with global_dialog -- gmu aug 14 2014
--function f_md_ai_play( delay:number, character:ai, line:string ):void
--	b_is_dialogue_playing = true;
--	if ai_living_count(character) >= 1 then
--		s_md_play_time = ai_play_line(character, line);
--		Sleep(s_md_play_time);
--		Sleep(delay);
--	else
--		print("THIS ACTOR DOES NOT EXIST TO PLAY F_MD_AI_PLAY");
--	end
--	b_is_dialogue_playing = false;
--end
--
---- Play the specified line, then delay afterwards for a specified amount of time.
--function f_md_object_play( delay:number, obj:object, line:string ):void
--	b_is_dialogue_playing = true;
--	s_md_play_time = ai_play_line_on_object(obj, line);
--	Sleep(s_md_play_time);
--	Sleep(delay);
--	b_is_dialogue_playing = false;
--end
--
---- Play the specified line, then cutoff afterwards for a specified amount of time.
--function f_md_ai_play_cutoff( cutoff_time:number, character:ai, line:string ):void
--	b_is_dialogue_playing = true;
--	s_md_play_time = ai_play_line(character, line) - cutoff_time;
--	Sleep(s_md_play_time);
--	b_is_dialogue_playing = false;
--end
--
---- Play the specified line, then cutoff afterwards for a specified amount of time.
--function f_md_object_play_cutoff( cutoff_time:number, obj:object, line:string ):void
--	b_is_dialogue_playing = true;
--	s_md_play_time = ai_play_line_on_object(obj, line) - cutoff_time;
--	Sleep(s_md_play_time);
--	b_is_dialogue_playing = false;
--end
--
---- For branching scipts in dialog
--function f_md_abort():void
--	Sleep(s_md_play_time);
--	print("DIALOG SCRIPT ABORTED!");
--	b_is_dialogue_playing = false;
--	ai_dialogue_enable(true);
--end
--
--function f_md_abort_no_combat_dialog():void
--	f_md_abort();
--	Sleep(1);
--	ai_dialogue_enable(false);
--end
---- Play the specified line, then delay afterwards for a specified amount of time.
--global b_is_dialogue_playing:boolean=false;
--
--function f_md_play( delay:number, line:tag ):void
--	b_is_dialogue_playing = true;
--	s_md_play_time = sound_impulse_language_time(line);
--	sound_impulse_start(line, nil, 1);
--	Sleep(sound_impulse_language_time(line));
--	Sleep(delay);
--	s_md_play_time = 0;
--	b_is_dialogue_playing = false;
--end
--
--function f_is_dialogue_playing():boolean
--	return b_is_dialogue_playing;
--end




--343 DO NOT USE -- ONLY IN HERE TO KEEP COMPATIBILITY WITH M90
-- USE f_return_blip_type_cui INSTEAD
--function f_return_blip_type( type:string ):number
--	blip_type_id = 21;
--	if type == "neutralize" then
--		blip_type_id = blip_neutralize;
--	end
--	if type == "a" then
--		blip_type_id = blip_default_a;
--	end
--	if type == "b" then
--		blip_type_id = blip_default_b;
--	end
--	if type == "c" then
--		blip_type_id = blip_default_c;
--	end
--	if type == "d" then
--		blip_type_id = blip_default_d;
--	end
--	if type == "defend" then
--		blip_type_id = blip_defend;
--	end
--	if type == "ordnance" then
--		blip_type_id = blip_ordnance;
--	end
--	if type == "activate" then
--		blip_type_id = blip_interface;
--	end
--	if type == "recon" then
--		blip_type_id = blip_recon;
--	end
--	if type == "recover" then
--		blip_type_id = blip_recover;
--	end
--	if type == "neutralize_a" then
--		blip_type_id = blip_neutralize_alpha;
--	end
--	if type == "neutralize_b" then
--		blip_type_id = blip_neutralize_bravo;
--	end
--	if type == "neutralize_c" then
--		blip_type_id = blip_neutralize_charlie;
--	end
--	if type == "ammo" then
--		blip_type_id = blip_ammo;
--	end
--	if type == "enemy" then
--		blip_type_id = blip_hostile;
--	end
--	if type == "enemy_vehicle" then
--		blip_type_id = blip_hostile_vehicle;
--	end
--	if type == "default" then
--		blip_type_id = blip_type_id;
--	end
--	-- AA's
--	if type == "jetpack" then
--		blip_type_id = blip_jetpack;
--	end
--	if type == "thruster" then
--		blip_type_id = blip_thruster;
--	end
--	if type == "shield" then
--		blip_type_id = blip_shield;
--	end
--	if type == "PAT" then
--		blip_type_id = blip_pat;
--	end
--	if type == "regen" then
--		blip_type_id = blip_regen;
--	end
--	if type == "hologram" then
--		blip_type_id = blip_hologram;
--	end
--	if type == "camo" then
--		blip_type_id = blip_camo;
--	end
--	if type == "vision" then
--		blip_type_id = blip_vision;
--	end
--	return blip_type_id;
--end



-- return
-- ===============================================================================================================================================
-- COOP RESUME MESSAGING =========================================================================================================================
-- ===============================================================================================================================================

--don't think we need this - gmu 
--function f_coop_resume_unlocked( resume_title:title, insertion_point:number ):void
--	if game_is_cooperative() then
--		--sound_impulse_start(sfx_hud_in, nil, 1);
--		cinematic_set_chud_objective(resume_title);
--		game_insertion_point_unlock(insertion_point);
--	end
--end

--don't think this is necessary anymore, using cinematic fades to take care of this mostly
-- ===============================================================================================================================================
-- INSERTION FADE ================================================================================================================================
-- ===============================================================================================================================================
--function insertion_snap_to_black():void
--	print("insertion snap to black started");
--	insertion_fade_out (0,0,0,0);
--	print("insertion snap to black done");
--
--end
---- ===insertion fade out: fades out all players over time
----			seconds = number of seconds to fade
----			r1 = the red value of the fade
----			g1 = the green value of the fade
----			b1 = the blue value of the fade
----			
----	RETURNS:  void
--function insertion_fade_out(seconds:number, r1:number, g1:number, b1:number):void
--	print("insertion fade out started");
--	local r:number = r1 or 0;
--	local g:number = g1 or 0;
--	local b:number = b1 or 0;
--	local ticks:number = seconds or 3;
--	
--	fade_out(r, g, b, seconds_to_frames(ticks));
--	sleep_s (ticks);
--	-- ai ignores players
--	ai_disregard(players(), true);
--	-- players cannot take damage 
--	object_cannot_take_damage(players());
--	-- scale player input to zero 
--	player_control_fade_out_all_input(1);
--	-- lower the player's weapon
--	players_weapon_down(-1, 0.0, true);
--
--	-- pause the meta-game timer 
--	campaign_metagame_time_pause(true);
--	-- fade out the chud 
--	-- chud_cinematic_fade(0, 0);
--	-- hide players 
--
--	players_hide(-1, true);
--
--	print("insertion fade out done");
--
--end
--
---- ============================
---- INSERTION FADE IN===========
---- ============================
--
--function insertion_fade_to_gameplay():void
--	designer_fade_in("fade_from_black", true);
--end
--
----might need to change this from accepting a string to accepting a number so it is friendly to client scripts
--function designer_fade_in( fade_type:string, weapon_starts_lowered:boolean ):void
--	print("designer fade in started");
--	fade_type = fade_type or "fade_from_black";
--		
--	cinematic_stop();
--	camera_control(false);
--	-- unhide players 
--	players_hide(-1, false);
--
--	-- raise weapon 
--	if weapon_starts_lowered then
--		if b_debug_globals then
--			print("snapping weapon to lowered state...");
--		end
--		players_weapon_down(-1, 1.0 / game_seconds_to_ticks(1), true);
--
--		Sleep(1);
--	end
--	-- unlock the players gaze 
--	
--	for i, val in ipairs(players()) do
--		player_control_unlock_gaze(val);
--	end
--
--	Sleep(1);
--	-- fade or snap screen back
--	if fade_type == "fade_from_black" then
--		if b_debug_globals then
--			print("fading from black...");
--		end
--		fade_in(0, 0, 0, game_seconds_to_ticks(1));
--		Sleep(20);
--	end
--	if fade_type == "fade_from_white" then
--		if b_debug_globals then
--			print("fading from white...");
--		end
--		fade_in(1, 1, 1, game_seconds_to_ticks(1));
--		Sleep(20);
--	end
--	if fade_type == "snap_from_black" then
--		if b_debug_globals then
--			print("snapping from black...");
--		end
--		fade_in(0, 0, 0, 5);
--		Sleep(5);
--	end
--	if fade_type == "snap_from_white" then
--		if b_debug_globals then
--			print("snapping from white...");
--		end
--		fade_in(1, 1, 1, 5);
--		Sleep(5);
--	end
--	if fade_type == "no_fade" then
--		fade_in(1, 1, 1, 0);
--		Sleep(5);
--	end
--
--	--end				
--	cinematic_show_letterbox(false);
--	-- raise weapon 
--	if weapon_starts_lowered then
--		if b_debug_globals then
--			print("raising player weapons slowly...");
--		end
--		players_weapon_down(-1, 1.0, false);
--
--		--Sleep(10);
--	end
--	-- fade in the chud 
--	-- chud_cinematic_fade(1, 1);
--	Sleep(1);
--	-- enable player input 
--	player_enable_input(true);
--	-- scale player input to one 
--	player_control_fade_in_all_input(1);
--	-- pause the meta-game timer 
--	campaign_metagame_time_pause(false);
--	-- the ai will disregard all players 
--	ai_disregard(players(), false);
--	-- players can now take damage 
--	object_can_take_damage(players());
--	-- player can now move 
--	player_disable_movement(false);
--	print("designer fade in done");
--end

-- ===============================================================================================================================================
-- END MISSION ===================================================================================================================================
-- ===============================================================================================================================================
--function end_mission():void
--	print("343 End of mission! 343");
--	game_won();
--end
