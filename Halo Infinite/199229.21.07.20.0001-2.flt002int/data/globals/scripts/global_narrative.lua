--## SERVER

REQUIRES('globals\scripts\global_dialog_interface.lua');
REQUIRES('globals\scripts\global_fast_travel.lua');
REQUIRES('scripts\AirDrop\AirDrop.lua')
REQUIRES('scripts\AirDrop\RouteRequest.lua')
REQUIRES('scripts\AirDrop\Flight.lua')

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
--	NARRATIVE
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================

-- temp objective text
-- =================================================================================================
-- Displays cut_scene titles for objectives (takes them away after some seconds as a failsafe)
-- if no cutscene titles are called, then it displays temp text for objectives for 5 seconds
-- str_text = string that displays temp text
-- ch_text = cutscene title that displays real text
-- -------------------------------------------------------------------------------------------------
--
--

function ObjectiveText(str_text:string, ch_text:title)
	print ("Objective Text Display");
	if ch_text == nil then
		CreateThread(ObjectiveTextTemp, str_text);
	else
		CreateThread(ObjectiveTextTitle, ch_text);
	end
end


-- TEMP objective text
-- =================================================================================================
-- Displays temp text for objectives for 5 seconds
-- str_text = string that displays temp text
-- -------------------------------------------------------------------------------------------------
--
--

function ObjectiveTextTemp (str_text:string):void

	if (str_text == nil) then
		print ("no mission objective text");
		return;
	end

	print ("faux temp text called, will not display on release_internal");
	set_text_defaults();
	set_text_color(1, 0.9764706, 0.9764706, 0.9764706);
	set_text_lifespan(210);
	set_text_font(FONT_ID.terminal);
	set_text_justification(TEXT_JUSTIFICATION.center);
	set_text_alignment(TEXT_ALIGNMENT.top);
	set_text_scale(1);
	set_text_margins(0, 0.25, 0, 0);
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	show_text(str_text);

	CreateThread(AudioNewObjectiveBeep);		--play new objective sfx
	sleep_s (5);
	clear_all_text();

end



-- objective text
-- =================================================================================================
-- Displays cut_scene titles for objectives (takes them away after some seconds as a failsafe)
-- ch_text = cutscene title that displays real text
-- -------------------------------------------------------------------------------------------------
--
function ObjectiveTextTitle (ch_text:title):void

	if (ch_text == nil) then
		print ("no mission objective text");
		return;
	end

	cinematic_set_title(ch_text);
	CreateThread(AudioNewObjectiveBeep);		--play new objective sfx

	--this is a failsafe to turn off the title just in case
	sleep_s (8);
	cinematic_clear_title (ch_text);

end

-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- TEMPORARY STORY BLURB DISPLAYS
-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- ct_title = The name of the Chapter Title you want to appear.
-- r_time = The time you want the message to be displayed (in seconds).  This is usually the Fade In Time, Display Time and Fade Out Time of the Chapter Title added together.
-- b_cinematicstart = set this to TRUE if you want to take control away from the player and have cinematic bars come down on the screen.
-- b_cinematicend = set this to TRUE if you want to return control to the player and remove the cinematic bars from the screen.
-- -------------------------------------------------------------------------------------------------
-- Example use displaying three sequential chapter headings while the player can't move:
--
-- script dormant storybyte01()
--		sleep_until(volume_test_players (trigger_volume_name), 1);
--		storyblurb_display (ct_title01, 7, TRUE, FALSE);
--		storyblurb_display (ct_title02, 9, FALSE, FALSE);
--		storyblurb_display (ct_title03, 5, FALSE, TRUE);
-- end
-- -------------------------------------------------------------------------------------------------
function story_blurb_title( ct_title:title, r_time:number, b_cinematicstart:boolean, b_cinematicend:boolean ):void
	if b_cinematicstart then
		-- chud_cinematic_fade(0, 30);
		player_disable_movement(true);
		cinematic_show_letterbox(true);
	end
	cinematic_set_title(ct_title);
	r_time = r_time or 4;
	sleep_s(r_time);
	if b_cinematicend then
		-- chud_cinematic_fade(1, 30);
		cinematic_show_letterbox(false);
		player_disable_movement(false);
	end
	cinematic_clear_title(ct_title);
end

-- =================================================================================================
-- =================================================================================================
-- Story Blurbs
-- =================================================================================================
-- =================================================================================================
function story_blurb_add( type:string, content:string ):void
	if type == "cutscene" then
		CreateThread(story_blurb_add_cutscene, content);
	end
	if type == "vo" then
		CreateThread(story_blurb_add_vo, content);
	end
	if type == "domain" then
		CreateThread(story_blurb_add_domain, content);
	end
	if type == "other" then
		CreateThread(story_blurb_add_other, content);
	end
end

function story_blurb_clear():void
	clear_all_text();
end

function story_blurb_add_vo( content:string ):void
	-- Fonts:
	-- Assign the font to use. Valid options are: terminal, body, title, super_large,
	-- large_body, split_screen_hud, full_screen_hud, English_body,
	-- hud_number, subtitle, main_menu. Default is “subtitle”
	set_text_defaults();
	-- color, scale, life, font
	set_text_lifespan(30 * 5);
	set_text_color(1, 0.22, 0.77, 0.0);
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
	-- display the text!
	show_text(content);
end

function story_blurb_add_cutscene( content:string ):void
	-- Fonts:
	-- Assign the font to use. Valid options are: terminal, body, title, super_large,
	-- large_body, split_screen_hud, full_screen_hud, English_body,
	-- hud_number, subtitle, main_menu. Default is “subtitle”
	set_text_defaults();
	-- color, scale, life, font
	set_text_lifespan(30 * 5);
	set_text_color(1, 1, 0.745, 0.137);
	set_text_font(FONT_ID.terminal);
	set_text_scale(1.3);
	-- alignments
	set_text_alignment(TEXT_ALIGNMENT.bottom);
	set_text_margins(0.05, 0.0, 0.05, 0.05);
	set_text_indents(0, 0);
	set_text_justification(TEXT_JUSTIFICATION.center);
	set_text_wrap(true, true);
	-- shadow
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	set_text_shadow_color(1, 0, 0, 0);
	-- display the text!
	show_text(content);
end

function story_blurb_add_domain( content:string ):void
	-- Fonts:
	-- Assign the font to use. Valid options are: terminal, body, title, super_large,
	-- large_body, split_screen_hud, full_screen_hud, English_body,
	-- hud_number, subtitle, main_menu. Default is “subtitle”
	set_text_defaults();
	-- color, scale, life, font
	set_text_lifespan(30 * 5);
	set_text_color(1, 0.9, 0.0, 0.9);
	set_text_font(FONT_ID.terminal);
	set_text_scale(1.5);
	-- alignments
	set_text_alignment(TEXT_ALIGNMENT.bottom);
	set_text_margins(0.05, 0.0, 0.05, 0.2);
	set_text_indents(0, 0);
	set_text_justification(TEXT_JUSTIFICATION.center);
	set_text_wrap(true, true);
	-- shadow
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	set_text_shadow_color(1, 0, 0, 0);
	-- display the text!
	show_text(content);
end

function story_blurb_add_other( content:string ):void
	-- Fonts:
	-- Assign the font to use. Valid options are: terminal, body, title, super_large,
	-- large_body, split_screen_hud, full_screen_hud, English_body,
	-- hud_number, subtitle, main_menu. Default is “subtitle”
	set_text_defaults();
	-- color, scale, life, font
	set_text_lifespan(30 * 5);
	set_text_color(1, 1, 1, 1);
	set_text_font(FONT_ID.terminal);
	set_text_scale(1.2);
	-- alignments
	set_text_alignment(TEXT_ALIGNMENT.bottom);
	set_text_margins(0.05, 0.0, 0.05, 0.25);
	set_text_indents(0, 0);
	set_text_justification(TEXT_JUSTIFICATION.center);
	set_text_wrap(true, true);
	-- shadow
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	set_text_shadow_color(1, 0, 0, 0);
	-- display the text!
	show_text(content);
end

-- =================================================================================================
-- =================================================================================================
-- Picture in Picture
-- =================================================================================================
-- =================================================================================================
function pip_on():void
	set_text_defaults();
	-- color, scale, life, font
	set_text_lifespan(30 * 20);
	set_text_color(1, 0, .78, .89);
	set_text_font(FONT_ID.terminal);
	set_text_scale(3.0);
	-- alignments
	set_text_alignment(TEXT_ALIGNMENT.bottom);
	set_text_indents(0, 0);
	set_text_justification(TEXT_JUSTIFICATION.right);
	set_text_wrap(true, true);
	-- shadow
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	set_text_shadow_color(0, 0, 0, 0);
	-- faked PIP for now
	set_text_margins(0, 0, 0.02, 0.26);
	show_text("**************");
	set_text_margins(0, 0, 0.02, 0.22);
	show_text("*----++++----*");
	set_text_margins(0, 0, 0.02, 0.18);
	show_text("*---++++++---*");
	set_text_margins(0, 0, 0.02, 0.14);
	show_text("*---++++++---*");
	set_text_margins(0, 0, 0.02, 0.10);
	show_text("*---++++++---*");
	set_text_margins(0, 0, 0.02, 0.06);
	show_text("*----++++----*");
	set_text_margins(0, 0, 0.02, 0.02);
	show_text("**************");
end

function pip_off():void
	clear_all_text();
end
-- =================================================================================================
-- =================================================================================================
-- Play temp BINK Cutscene
-- =================================================================================================
-- =================================================================================================
global play_temp_bink_cutscene_bool:boolean=false;

function play_temp_bink_cutscene( cutscene_name:string, time_to_wait:number ):void
	fade_out_for_player(PLAYERS.player0);
	fade_out_for_player(PLAYERS.player1);
	fade_out_for_player(PLAYERS.player2);
	fade_out_for_player(PLAYERS.player3);
	player_action_test_reset();
	player_enable_input(false);
	camera_control(true);
	CreateThread(play_temp_bink_cutscene_wait_length, time_to_wait);
	play_bink_movie(cutscene_name);
	SleepUntil([| play_temp_bink_cutscene_bool or player_action_test_primary_trigger() or player_action_test_jump() or player_action_test_melee() or player_action_test_start() or player_action_test_context_primary() or player_action_test_equipment() or player_action_test_back() or player_action_test_rotate_weapons() or player_action_test_cancel() or player_action_test_grenade_trigger() ], 1);
	play_temp_bink_cutscene_bool = false;
	player_enable_input(true);
	camera_control(false);
	fade_in_for_player(PLAYERS.player0);
	fade_in_for_player(PLAYERS.player1);
	fade_in_for_player(PLAYERS.player2);
	fade_in_for_player(PLAYERS.player3);
end

function play_temp_bink_cutscene_wait_length( time_to_wait:number ):void
	sleep_s(time_to_wait);
	play_temp_bink_cutscene_bool = true;
end

-- =================================================================================================
-- =================================================================================================
-- Cinematic Text
-- =================================================================================================
-- =================================================================================================
function cinematic_text( content:string, time_to_display:number ):void
	-- Fonts:
	-- Assign the font to use. Valid options are: terminal, body, title, super_large,
	-- large_body, split_screen_hud, full_screen_hud, English_body,
	-- hud_number, subtitle, main_menu. Default is “subtitle”
	set_text_defaults();
	-- color, scale, life, font
	set_text_lifespan(30 * time_to_display);
	set_text_color(1, 1, 1, 1);
	set_text_font(FONT_ID.terminal);
	set_text_scale(1.0);
	-- alignments
	set_text_alignment(TEXT_ALIGNMENT.center);
	set_text_margins(0.05, 0.0, 0.05, 0.0);
	set_text_indents(0, 0);
	set_text_justification(TEXT_JUSTIFICATION.center);
	set_text_wrap(true, true);
	-- shadow
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	set_text_shadow_color(1, 0, 0, 0);
	-- display the text!
	show_text(content);
end

-- =================================================================================================
-- =================================================================================================
-- Playing Cinematics
-- =================================================================================================
-- =================================================================================================
function f_cinematic_play( st_cinematic_name:string, zoneset_id:zone_set, s_cinematic_ins:zone_set, s_play_ins:number ):void
	dprint("*** INSERTION POINT: CINEMATIC ***");
	-- cinematic_enter(st_cinematic_name, true);
	-- if s_cinematic_ins~=nil then
		-- cinematic_suppress_bsp_object_creation(true);
		-- switch_zone_set(zoneset_id);
		-- Sleep(1);
		-- SleepUntil([| current_zone_set_fully_active() == s_cinematic_ins ], 1);
		-- Sleep(1);
		-- cinematic_suppress_bsp_object_creation(false);
	-- end
	-- f_start_mission(st_cinematic_name);
	-- cinematic_exit_no_fade(st_cinematic_name, true);
	-- dprint("Cinematic exited!");
	-- if s_play_ins~=-1 then
		-- game_insertion_point_set(s_play_ins);
	-- end
end

-- =================================================================================================
-- =================================================================================================
-- Armor Abilities
-- =================================================================================================
-- =================================================================================================
function dormant.f_waypoint_global_equipment_unlock()
	dprint("WAYPOINT CHECK THREADED");
end

-- =================================================================================================
-- =================================================================================================
-- Debug text for Narrative function
-- =================================================================================================
-- =================================================================================================
-- In order to track the triggers of Narrative functions, and not to spam other's people log when working, that function allows to choose to display or log text.
-- The name of the boolean is: display_narrative_debug_info
-- TRUE, the log text will appear
-- FALSE, the log text will not appear
--
-- Instead of logging text with the function print(), use that function PrintNarrative()
--
-- Ex:       PrintNarrative("Narrative LOAD Breach Scenes")
--
--	To be able to print a number, use lua function to convert.

-- Ex:       PrintNarrative(tostring(NumberVariable))




global g_display_narrative_debug_info:boolean=false;


function PrintNarrative(narrative_debug_text:string)

	if g_display_narrative_debug_info then
		print("NARRATIVE: ", narrative_debug_text);
	end

end

remoteServer["PrintNarrative"] = PrintNarrative


-- =================================================================================================
-- =================================================================================================
-- Temp text for Narrative Beats
-- =================================================================================================
-- =================================================================================================

-- === Shows temp text Narrative -- useful if there's not TTS or narrative
--			content = a string of text you want to show
--			n_time = the amount of time you want the text to show (nil is 2)
--			color = the color of the text:
--				red, blue, green, white, black - default is green
--	RETURNS:  void


function ShowTempTextNarrative (content:string, n_time:number)

	if n_time == nil then
		 n_time = 2;
	end

	print(n_time);
--	red = red or 0.22;
--	green = green or 0.0;
--	blue = blue or 0.77;
	set_text_defaults();
	-- color, scale, life, font
	--	set_text_color(1, red, blue, green);
	set_text_color(1, 1, 0, 0);
	--set_text_color(1, 0.22, 0.77, 0.0);
--	set_text_color(1, 0.9764706, 0.9764706, 0.9764706);

	set_text_font(FONT_ID.terminal);
	set_text_scale(1.3);
	-- alignments
	set_text_alignment(TEXT_ALIGNMENT.bottom);
	set_text_margins(0.05, 0.5, 0.05, 0.2);
	set_text_indents(0, 0);
	set_text_justification(TEXT_JUSTIFICATION.center);
	set_text_wrap(true, true);
	-- shadow
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	set_text_shadow_color(1, 0, 0, 0);


	-- display the text!
	set_text_lifespan(seconds_to_frames(n_time));
--	content = "[Narrative] " .. content ;
	show_text_index( 0, content);
	--temp_text_index = show_text_index(0, content);
	sleep_s(n_time);

end



function ShowTempTextRobbie (content:string, n_time:number)

	if n_time == nil then
		 n_time = 2;
	end

	print(n_time);
--	red = red or 0.22;
--	green = green or 0.0;
--	blue = blue or 0.77;
	set_text_defaults();
	-- color, scale, life, font
	--	set_text_color(1, red, blue, green);
	set_text_color(1, 1, 0, 0);
	--set_text_color(1, 0.22, 0.77, 0.0);
--	set_text_color(1, 0.9764706, 0.9764706, 0.9764706);

	set_text_font(FONT_ID.terminal);
	set_text_scale(1.3);
	-- alignments
	set_text_alignment(TEXT_ALIGNMENT.bottom);
	set_text_margins(0.05, 0.5, 0.05, 0.2);
	set_text_indents(0, 0);
	set_text_justification(TEXT_JUSTIFICATION.center);
	set_text_wrap(true, true);
	-- shadow
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	set_text_shadow_color(1, 0, 0, 0);


	-- display the text!
	set_text_lifespan(seconds_to_frames(n_time));
--	content = "[Narrative] " .. content ;
	show_text_index( 0, content);
	--temp_text_index = show_text_index(0, content);
	sleep_s(n_time);

end

--	PUT that line below under your SleepUntil enter volume. And put there the same Volume that the one is your sleepuntil.
--	ShowTempTextwithvolume("test string", 10, VOLUMES.tv_narrative_soldier_room_entrance)

function ShowTempTextwithvolume (content:string, n_time:number, volumetotest:volume)

	repeat
		SleepUntil([|	volume_test_players( volumetotest ) ], 10);

		ShowTempTextRobbie(content,10);

	until list_count(players()) == 0					--	Will keep showing the text everytime you enter the Volume until player is dead. (so will always repeat)

end


-- =================================================================================================
-- =================================================================================================
-- Temp PIP
-- =================================================================================================
--	Prints temp text to the screen to simulate a pip
--	won't show on Release executable
--	Name will be displayed under the hacky pip
--	Lifespan is set in seconds
-- =================================================================================================

function ShowMissionTempPip(name: string, lifespan:number)

                name = name or "NAME";
				name = "PIP: " .. name;
                lifespan = lifespan or 5;

                --this is the character that makes up the pip
                local content:string = "*";
                local line:string = "";

                --these control the height and width of the pip and the margins between the lines
                local width:number = 40;
                local height:number = 10;
                local margin:number = 0.025;

                for i = 1, width do
                                line = line .. content;
                end

                line = line .. "\n";

                set_text_defaults();
                set_text_color(1, 0, 1, 1);
                set_text_font(FONT_ID.terminal);
                set_text_justification(TEXT_JUSTIFICATION.left);
                set_text_alignment(TEXT_ALIGNMENT.top);
                set_text_scale(1.5);
                set_text_shadow_style(TEXT_DROP_SHADOW.drop);
                set_text_margins(0.1, 0.1, 0.0, 0.0);
                set_text_lifespan (seconds_to_frames(lifespan));
                local index:number = 0;

                for i = 0, height do
                                show_text_index(index, line);
                                index = index + 1;
                                set_text_margins(0.1, 0.1 + (margin * i), 0.0, 0.0);
                end

                show_text_index (index, name);



--[[
--	repeat
--		SleepUntil ([| b_CancelTestRunning or objects_distance_to_object (PLAYERS.local0, control) > 5 ], 10);
--		if not b_CancelTestRunning then
			uip_window_create ("giverPiP0");
			print("TEMP PIP: Display Temp PIP for ", displaytime, " seconds");
			--temp text
			pipname = "PiP: ".. pipname;
			uip_textblock_add ("giverPiP0", "textBlock0", pipname);
			uip_elem_set_x ("giverPiP0", "textBlock0", 100);
			uip_elem_set_y ("giverPiP0", "textBlock0", 230);
			uip_textblock_set_color ("giverPiP0", "textBlock0", "Red");
			uip_textblock_set_size ("giverPiP0", "textBlock0", 25);

			--temp rectangle
			uip_rectangle_add ("giverPiP0", "rectangle0", 200, 130);
			uip_shape_set_fill ("giverPiP0", "rectangle0", "Blue");
			uip_elem_set_x ("giverPiP0", "rectangle0", 100);
			uip_elem_set_y ("giverPiP0", "rectangle0", 100);
--			SleepUntil ([| b_CancelTestRunning or objects_distance_to_object (PLAYERS.local0, control) < 5 ], 10);

			sleep_s (displaytime);
			print("TEMP PIP: Remove Temp PIP");
			uip_window_remove ("giverPiP0");
--		end
--	until b_CancelTestRunning;
	--sleep_s (5);
	--redundant
--	uip_window_remove ("giverPiP0");
]]
end


-- =================================================================================================

-- =================================================================================================
--	NARRATIVE TEXTSCREEN				*			TEXT SETUP
-- =================================================================================================

function ShowTempTextNarrativeUR( content:string, n_time:number, line:number ):void

			n_time = n_time or 2;
			line = line or 0.20;

	local lineheight:number = 0.6 - (0.10 * line);

--	print(lineheight);
	set_text_defaults();

--	set_text_color(1, 0.9764706, 0.9764706, 0.9764706);
--	set_text_color(1, 0, 0, 0);
	set_text_color(1, 0.9764706, 0.9764706, 0.9764706);

	set_text_font(FONT_ID.terminal);
	set_text_scale(1);
	-- alignments
	set_text_alignment(TEXT_ALIGNMENT.bottom);
	set_text_margins(0.05, 0.0, 0.1, lineheight);
	set_text_indents(0, 0);
	set_text_justification(TEXT_JUSTIFICATION.center);
	set_text_wrap(true, true);
	-- shadow
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	set_text_shadow_color(1, 0, 0, 0);


	-- display the text!
	set_text_lifespan(60*n_time);
--	content = "[Narrative] " .. content ;
	show_text(content);
--	temp_text_index = show_text_index(0, content);
	sleep_s(n_time);

end



-- =================================================================================================
--	IS SPARTAN IN COMBAT				*
-- =================================================================================================
--	If no Object is specified, it will return a result for the whole SPARTAN SQUAD


function IsSpartanInCombat(spartan:object):boolean


                local are_they_in_combat:boolean = false;

--             PrintNarrative("IsSpartanInCombat: Is any member of the Spartan Squad in combat?");

                if spartan == nil then
                                --print("No Spartan specified, return result for the whole Spartan team");
                                for _,spartan in ipairs (players()) do
                                                if object_get_shield (spartan) < 1 then
                                                                are_they_in_combat = true;
                                                end
                                end

                else
                                --print("Return result for:", spartan);
                                if object_get_shield( spartan) < 1 then
                                                are_they_in_combat = true;
                                end
                end
                if are_they_in_combat then
                                --PrintNarrative("IsSpartanInCombat: In combat");
                end
                return are_they_in_combat;

end

function IsPlayerInCombat(player:player):boolean
    if (player) then
        if (object_get_shield(player)) then
            return true;
        end
    end

    return false;
end




-- =================================================================================================
--	IS SPARTAN ABLE TO SPEAK				*
-- =================================================================================================
--	If no Object is specified, it will return a result for the whole SPARTAN SQUAD


function IsSpartanAbleToSpeak(spartan:object):boolean

local can_they_speak:boolean = false;

			if spartan == nil then
					if (unit_get_health( SPARTANS[1]) > 0)
						and (unit_get_health( SPARTANS[2]) > 0 )
						and (unit_get_health( SPARTANS[3]) > 0 )
						and (unit_get_health( SPARTANS[4]) > 0 ) then
						can_they_speak = true;
						--print("IsSpartanAbleToSpeak: No Spartan specified, return result for the whole Spartan team: YES");

					elseif (unit_get_health( SPARTANS[1]) <= 0 )
						or (unit_get_health( SPARTANS[2]) <= 0 )
						or (unit_get_health( SPARTANS[3]) <= 0 )
						or (unit_get_health( SPARTANS[4]) <= 0 ) then
						can_they_speak = false;
						--print("IsSpartanAbleToSpeak: NO, At least 1 Spartan is Dead or Down ");

					end
			else
					if	unit_get_health( spartan) > 0 then
						can_they_speak = true;
						--print("IsSpartanAbleToSpeak: Return result for:", spartan , " = YES");
					else
						can_they_speak = false;
						--print("IsSpartanAbleToSpeak: Return result for:", spartan , " = NO, Down or Dead");
					end
			end
return can_they_speak;

end




-- =================================================================================================
--	GET CLOSEST SPARTAN				*
-- =================================================================================================
--	Will return the closest Musketeer, not Dead, not Down, to the specified Spartan.
--	If no Spartan is specified, it will return the closest musketeer to Locke.
--	If there is no musketeer available, it will return the specified Spartan.
-- =================================================================================================
--		local closest_spartan_name:object;
--		local closest_spartan_distance:number;
--		closest_spartan_name, closest_spartan_distance = get_closest_spartan(SPARTANS.locke);



function GetClosestMusketeer(spartan:object, m_dist:number, all_team:number)

	--	0 = test only musketeers
	--	1 = test only players
	--	2 = test all spartans

	return nil;

end


-- =================================================================================================
--	GET FARTHEST SPARTAN				*
-- =================================================================================================
--	Will return the closest Musketeer, not Dead, to the specified Spartan.
--	If no Spartan is specified, it will return the closest musketeer to Locke.
--	If there is no musketeer available, it will return the specified Spartan.
-- =================================================================================================

function GetfarthestMusketeer(spartan:object, m_dist:number, all_team:number, request_distance:string)

	--	0 = test only musketeers
	--	1 = test only players
	--	2 = test all spartans

	-- If we want the distance, we add "distance" at the end and it will return the distance, but not the object.

	return nil;


end
-- =================================================================================================
--	ALTERNATE SPEAKER WHEN ENTERING VOLUME				*
-- =================================================================================================
--	Will return the closest Musketeer, not Dead, not Down, to the Spartan in the specified VOLUME, within the specified distance. (using GetClosestMusketeer()).
--	If no VOLUME is specified (nil), it will return the closest musketeer to Locke, within the specified distance.
--	If there is no musketeer available in the specified distance, it will return the Spartan in the VOLUME (or Locke).
-- =================================================================================================
--	This is used when the Player leading the way is triggering an event (VO) but I want someone else to talk. ("There is the door!")
--	If the player leading the way is not looking at the door, I'm having a musketeer speaking instead, if available.



function AlternateSpeakerWhenEnteringVolume(vol:volume, m_dist:number,  all_team:number)

	--	0 = test only musketeers
	--	1 = test only players
	--	2 = test all spartans

local spartan:object = nil;

	m_dist = m_dist or 10;

	if vol == nil then
				spartan = SPARTANS.locke;
				print("AlternateSpeakerWhenEnteringVolume: No volume specified, using locke as a reference");
	else
				if volume_return_players (vol)[1] == nil then
					spartan = SPARTANS.locke;
					print("AlternateSpeakerWhenEnteringVolume: No Player in volume specified, using locke as a reference");
				else
					spartan = volume_return_players (vol)[1];
				end
	end

	return GetClosestMusketeer (volume_return_players (vol)[1], m_dist, all_team);

end








-- =================================================================================================
--	ARE ANY PLAYER IN A VEHICLE		*
-- =================================================================================================
--		TESTING IF ANY PLAYER IS IN A VEHICLE--
-- =================================================================================================



function AreAnyPlayersInVehicle():boolean

			for _,pl in ipairs (players()) do

					if unit_in_vehicle (pl) then
								return true;
					end

            end

			return false;

end



-- =================================================================================================
--	Get Closest enemy (To play VO on him	*
-- =================================================================================================
--	Need a Object list of AI to choose from (All Grunts or all Elites)
-- =================================================================================================
--	That funciton will go through the players and the enemies and will return a couple (player/enemy) that are close enough to play a VO on the enemy.

--GetClosestEnemy(ai_actors(AI.sq_ward_scouts), 10)

function GetClosestEnemy(ai_group:object_list, m_dist:number, specific_spartan:object)
	--PrintNarrative("GetClosestEnemy: Get closest enemy")

	local closestEnemy:object;
	local closestPlayer:object;

	if (list_count(ai_group) >= 1) then

		m_dist = m_dist or 1000;

		if specific_spartan == nil then
			for _,spartan in pairs (players()) do
				--for _,enemy in pairs (ai_group) do
				for i = 0, (list_count(ai_group) - 1) do
					local enemy = list_get( ai_group, i );
					local dist:number = objects_distance_to_object (spartan, enemy);
					--print("GetClosestEnemy - spartan :", spartan);
					--print("GetClosestEnemy - enemy :", enemy);

					--print("Distance for ", enemy, " to ", spartan, "  : ", dist);
					if dist < m_dist and dist >= 0 then
						m_dist = dist;
						closestEnemy = enemy;
						closestPlayer = spartan;
					end

					Sleep(1);
				end
			end
		else
			for i = 0, (list_count(ai_group) - 1) do
				local enemy = list_get( ai_group, i );
				local dist:number = objects_distance_to_object (specific_spartan, enemy);
				--print("GetClosestEnemy - spartan :", spartan);
				--print("GetClosestEnemy - enemy :", enemy);

				--print("Distance for ", enemy, " to ", spartan, "  : ", dist);
				if dist < m_dist and dist >= 0 then
					m_dist = dist;
					closestEnemy = enemy;
					closestPlayer = specific_spartan;
				end

				Sleep(1);
			end
		end
	end

	return closestEnemy, closestPlayer;
end



function GetClosestEnemyDistance(ai_group:object_list, specific_spartan:object)

local m_dist:number = 1000;

		if (list_count(ai_group) >= 1) then

				if specific_spartan == nil then

					for _,spartan in pairs (players()) do

							for i = 0, (list_count(ai_group) - 1)	do

							local enemy = list_get( ai_group, i );
							--print("list_get( ", ai_group," , ", i, " )" );
							local dist:number = objects_distance_to_object (spartan, enemy);
							--print("objects_distance_to_object ( ", spartan, " , ", enemy, " )" );

											if dist < m_dist and dist >= 0 then
															m_dist = dist;
											end

											Sleep(1);
							end

					end
				else
							for i = 0, (list_count(ai_group) - 1)	do

							local enemy = list_get( ai_group, i );
							--print("list_get( ", ai_group," , ", i, " )" );
							local dist:number = objects_distance_to_object (specific_spartan, enemy);
							--print("objects_distance_to_object ( ", spartan, " , ", enemy, " )" );

											if dist < m_dist and dist >= 0 then
															m_dist = dist;
											end

											Sleep(1);
							end
				end
		end

		return m_dist

end



function TestClosestEnemyDistance(ai_group:object_list, max_distance:number, specific_spartan:object)

local m_dist:number = 1000;

max_distance = max_distance or 30;

		if (list_count(ai_group) >= 1) then

				if specific_spartan == nil then

					for _,spartan in pairs (players()) do

							for i = 0, (list_count(ai_group) - 1) do

							local enemy = list_get( ai_group, i );
							--print("list_get( ", ai_group," , ", i, " )" );
							local dist:number = objects_distance_to_object (spartan, enemy);
							--print("objects_distance_to_object ( ", spartan, " , ", enemy, " )" );

											if dist < m_dist and dist >= 0 then
															m_dist = dist;
											end

											if m_dist <= max_distance then
												return true
											end

											Sleep(1);
							end
					end
				else
							for i = 0, (list_count(ai_group) - 1)	do

							local enemy = list_get( ai_group, i );
							--print("list_get( ", ai_group," , ", i, " )" );
							local dist:number = objects_distance_to_object (specific_spartan, enemy);
							--print("objects_distance_to_object ( ", spartan, " , ", enemy, " )" );

											if dist < m_dist and dist >= 0 then
															m_dist = dist;
											end

											if m_dist <= max_distance then
												return true
											end

											Sleep(1);
							end
				end
		end

		return false


end


function GetClosestEnemyInEnemyGroup(ai_group:object_list, m_dist:number)

	--PrintNarrative("GetClosestEnemyInEnemyGroup: Get closest enemy")

	local closestEnemy:object = nil;
	local closestPlayer:object = nil;

	if (list_count(ai_group) >= 1) then
		m_dist = m_dist or 1000;

		for _,spartan in ipairs (players()) do
			for _,enemy in ipairs (ai_group) do
				Sleep(1);

				local dist:number = objects_distance_to_object(spartan, enemy);

				--print("Distance for ", enemy, " to ", spartan, "  : ", dist);
				if dist < m_dist and dist >= 0 then
					m_dist = dist;
					closestEnemy = enemy;
					closestPlayer = spartan;
				end
			end
		end
	end

	--print("GetClosestEnemyInEnemyGroup: ", closestEnemy, closestPlayer);
	return closestEnemy, closestPlayer;
end




function MergeEnemyTables(t1, t2)
	if (t1 and t2) then
	   for k,v in ipairs(t2) do
		  table.insert(t1, v);
	   end
	end
	return t1;
end

-- =================================================================================================
--	Get Closest enemy (To play VO on him	*
-- =================================================================================================
--	Need a Object list of AI to choose from (All Grunts or all Elites)
-- =================================================================================================
--	That function will go through the players and the enemies and will return a couple (player/enemy) that are close enough to play a VO on the enemy.

global ActorTypeGroups:table = {
	banished = {
		ACTOR_TYPE.brute,
--		ACTOR_TYPE.crusher,	-- Cut from R1
		ACTOR_TYPE.elite,
		ACTOR_TYPE.grunt,
		ACTOR_TYPE.hoverer,
		ACTOR_TYPE.jackal,
		ACTOR_TYPE.hunter,
		ACTOR_TYPE.sentinel,	-- Banished faction for R1
	},

	covenant = {
		-- No covenant faction in R1, though in engine, enemy group is still labeled "covenant"
	},

	forerunner = {
		-- No forerunner faction in R1
	},

	human = {
		ACTOR_TYPE.marine,
		ACTOR_TYPE.crew,
		ACTOR_TYPE.spartan,
	},

	neutral = {
		ACTOR_TYPE.wildlife,
	},
};

function GetNearbyAiInGroupToPoint(aiGroup, maxDistance:number, point:location)
	local nearbyAi = {};

	if (#aiGroup > 0) then
		local aiDistances = {};

		-- We'll be doing comparisons in square-units to avoid the sqrt operation
		maxDistance = (maxDistance and (maxDistance * maxDistance)) or 1000;

		for aiIndex,aiObject in ipairs(aiGroup) do
			local distSquared = Object_GetDistanceSquaredToPosition(aiObject, point);

			-- Valid match
			if (distSquared <= maxDistance) then
				local insertIndex = 1;

				-- Maintain ordered list
				for index,distCompare in ipairs(aiDistances) do
					if (distCompare > distSquared) then
						break;
					else
						insertIndex = index + 1;
					end
				end
				table.insert(nearbyAi, insertIndex, aiObject);
				table.insert(aiDistances, insertIndex, distSquared);	-- Temp list for sorting ai by distance
			end
		end
	end

	return nearbyAi;
end

function GetAllEnemiesOfTypeNearPoint(enemyGroup, actorType:actor_type, point:location, maxDistance:number, biggerGroup:string)
	local currentEnemyList = nil;
	local nearbyEnemies:table = nil;

	-- Default distance of 1000 units
	maxDistance = maxDistance or 1000;
	biggerGroup = (biggerGroup and string.lower(biggerGroup)) or nil;

	local enemyList:table = EnemyListUpdate(enemyGroup);

	if (biggerGroup and ActorTypeGroups[biggerGroup]) then
		local enemyCollection = {};
		for _,type in pairs(ActorTypeGroups[biggerGroup]) do
			MergeEnemyTables(enemyCollection, enemyList[type]);
		end
		currentEnemyList = enemyCollection;
	else
		currentEnemyList = enemyList[actorType];
	end

	if currentEnemyList and (#currentEnemyList > 0) then
		nearbyEnemies = GetNearbyAiInGroupToPoint(currentEnemyList, maxDistance, point);
	else
		nearbyEnemies = {};
	end

	return nearbyEnemies;
end

function GetNEnemiesOfTypeNearPoint(enemyGroup, numberOfEnemies:number, actorType:actor_type, point:location, maxDistance:number, biggerGroup:string)
	local nearbyEnemies = GetAllEnemiesOfTypeNearPoint(enemyGroup, actorType, point, maxDistance, biggerGroup);
	local results = {};

	if (nearbyEnemies) then
		local count = 0;
		for _,enemyData in ipairs(nearbyEnemies) do
			count = count + 1;
			table.insert(results, enemyData);

			if (count >= numberOfEnemies) then
				break;
			end
		end
	end

	return results;
end

function IsThereAnEnemyInRange(enemyGroup:object_list, actorType:actor_type, maxDistance:number, biggerGroup:string)
	local currentEnemyList:object_list = nil;
	local closestPlayer:object = nil;
	local closestEnemy:object = nil;

	-- Default distance of 10 units
	maxDistance = maxDistance or 10;
	biggerGroup = (biggerGroup and string.lower(biggerGroup)) or nil;

	local enemyList:table = EnemyListUpdate(enemyGroup);

	if biggerGroup and ActorTypeGroups[biggerGroup] then
		local enemyCollection = {};
		for _,type in pairs(ActorTypeGroups[biggerGroup]) do
			MergeEnemyTables(enemyCollection, enemyList[type]);
		end
		currentEnemyList = enemyCollection;
	else
		currentEnemyList = enemyList[actorType];
	end
	--print("IsThereAnEnemyInRange: enemyList", actorType, " - Contains : ", list_count(currentEnemyList) );

	if list_count(currentEnemyList) > 0 then
		--PrintNarrative("IsThereAnEnemyInRange: Enemies are present, getting closest:");

		closestEnemy, closestPlayer = GetClosestEnemyInEnemyGroup(currentEnemyList, maxDistance);
		--print("IsThereAnEnemyInRange:  ", closestEnemy, " , close to: ", closestPlayer);
	end

	return closestEnemy;

end

-----------------------------------------------------------------------------------------
--	UPDATE THE ENEMY LIST BY GOING THROUGH THE Enemy Squad Group given.
----------------------------------------------------------------------------------------

function EnemyListUpdate(enemyGroup)
	local results = {};

	for index,obj in ipairs(enemyGroup) do
		local type = ai_get_actor_type( object_get_ai( obj ) );

		results[type] = results[type] or {};
		table.insert(results[type], obj);
	end

	return results;
end

--------------------------------------------

function EnemyListPrint(EnemyGroup:object_list)

	--print(EnemyGroup, " : ");

	if list_count(EnemyGroup) > 0 then
		for i = 1, list_count(EnemyGroup)
			do
				if g_display_narrative_debug_info then
					--print(list_get(EnemyGroup, (i - 1)));
				end
		end
	else
		PrintNarrative("EnemyListPrint: Enemy group is empty");
	end

end

------------------------------------------------------------------------------------------------------------------------------------
--	LAUNCHER THAT WILL QUEUE A CONVERSATION WHEN IT FOUND AN SPEAKER FOR THE CONVERSATION
------------------------------------------------------------------------------------------------------------------------------------

function IsThereAnEnemyInRangeLauncher(s_conversation:table, s_ai_squad:ai, s_actor_type:actor_type, s_convos_local_variable:string, s_valid_goal:table, distance:number, overlap:boolean )
	print("IsThereAnEnemyInRangeLauncher is now deprecated.  Use a Narrative Sequence or a Narrative Moment instead.");
end



-- =================================================================================================
--	Object at distance and looking in direction of something.
-- =================================================================================================
-- =================================================================================================

--Returns True or False

function object_at_distance_and_can_see_object(object_source:object_list, object_target:object, distance:number, degree:number, in_volume:volume)
local ObjectSourceIsValid:boolean = false

		for i = 1, list_count(object_source) do
		local playerObj = list_get(object_source, (i - 1));

					if  objects_can_see_object( playerObj, object_target, degree)
						 and objects_distance_to_object( playerObj, object_target ) < distance
						 and (in_volume == nil or volume_test_object( in_volume, playerObj )) then

							ObjectSourceIsValid = true;
							break;
					end
		end

	return ObjectSourceIsValid

end


--Returns True or False


-- =================================================================================================
--	Object (like the Player) is "voluntarily" Looking at something at a certain distance
-- =================================================================================================
-- =================================================================================================


--	delay:	time in second needed for the player to look at the object_target to be valid
--	speed:	0 means player needs to be still (no walking or running)
--	speed:	1 means player can be walking
--	speed:	2 means player can be running

-- Returns: Object name (Which object from the list is succesfully looking at the target)

function spartan_look_at_object(object_source:object_list, object_target:object, distance:number, degree:number, delay:number, speed:number)

local spartanIsLooking:object = nil;

		delay = delay or 0;
		--delay = 0;
		speed = speed or 0;
			if speed == 0 then speed = 1;
			elseif speed == 1 then speed = 3;
			elseif speed == 2 then speed = 5;
			else print("spartan_look_at_object: speed value not Valid")
			end

		for i = 1, list_count(object_source) do

				--print(ObjectGetSpeed( list_get(object_source, (i - 1)) ));

				--Sleep(1);

				if ObjectGetSpeed( list_get(object_source, (i - 1)) ) <= speed then

						if IsPlayer(list_get(object_source, (i - 1)) ) then


							if objects_distance_to_object( list_get(object_source, (i - 1)), object_target ) <= distance and objects_can_see_object( list_get(object_source, (i - 1)), object_target, degree) then

								if delay > 0 then
									--PrintNarrative("spartan_look_at_object - delay: "..delay);
									sleep_s(delay);
								end

								if objects_distance_to_object( list_get(object_source, (i - 1)), object_target ) <= distance and objects_can_see_object( list_get(object_source, (i - 1)), object_target, degree) then
									spartanIsLooking = list_get(object_source, (i - 1));
									distance = objects_distance_to_object( list_get(object_source, (i - 1)), object_target );
								else
									spartanIsLooking = nil;
								end
							end
						else
							spartanIsLooking = nil;
						end
				else
					--print("spartan_look_at_object: Player too fast");
				end
		end

	return spartanIsLooking

end



--	delay:	time in second needed for the player to look at the object_target to be valid
--	speed:	0 means player needs to be still (no walking or running)
--	speed:	1 means player can be walking
--	speed:	2 means player can be running

-- Returns: Object name (Which object from the list is succesfully looking at the target)

function spartan_look_at_object_no_delay(object_source:object_list, object_target:object, distance:number, degree:number, delay:number, speed:number)

local spartanIsLooking:object = nil;

		--delay = 0;
		speed = speed or 0;
			if speed == 0 then speed = 1;
			elseif speed == 1 then speed = 3;
			elseif speed == 2 then speed = 5;
			else print("spartan_look_at_object: speed value not Valid")
			end

		for i = 1, list_count(object_source) do

				--print(ObjectGetSpeed( list_get(object_source, (i - 1)) ));

				--Sleep(1);

				if ObjectGetSpeed( list_get(object_source, (i - 1)) ) <= speed then

						if IsPlayer(list_get(object_source, (i - 1)) ) then


							if objects_distance_to_object( list_get(object_source, (i - 1)), object_target ) <= distance and objects_can_see_object( list_get(object_source, (i - 1)), object_target, degree) then

								if objects_distance_to_object( list_get(object_source, (i - 1)), object_target ) <= distance and objects_can_see_object( list_get(object_source, (i - 1)), object_target, degree) then
									spartanIsLooking = list_get(object_source, (i - 1));
									distance = objects_distance_to_object( list_get(object_source, (i - 1)), object_target );
								else
									spartanIsLooking = nil;
								end
							end
						else
							spartanIsLooking = nil;
						end
				else
					--print("spartan_look_at_object: Player too fast");
				end
		end

	return spartanIsLooking

end
-------------------------------

global b_narrative_player_speed_movement:number = 0;

function playersMovementSpeed(spartan:object)
local s_speed:number = 0;

if spartan == nil then

			for i = 1, list_count(players()) do
					--print("speed : Loop");
					--print("i= ", i);

						if PLAYERS[i-1] then
							--print("ObjectGetSpeed ", ObjectGetSpeed( list_get(players(), (i - 1)) ));
							s_speed = s_speed + ObjectGetSpeed( list_get(players(), (i - 1)) );

							--print("speed : if IsPlayer", s_speed );
						end

			end

			s_speed = (b_narrative_player_speed_movement + (s_speed/list_count(players())))/2;

else
			s_speed = s_speed + ObjectGetSpeed( spartan );
end

	b_narrative_player_speed_movement = s_speed * 0.95;

	return s_speed

end


-- =================================================================================================
--	Collectibles
-- =================================================================================================
-- =================================================================================================

function CollectibleListener(collectible:object, conversation:table)

	sleep_s(2);

	SleepUntil([| object_index_valid( collectible ) ], 60);

	device_set_power (collectible, 1);

	print("COLLECTIBLES - LISTENER - ", collectible );

	RegisterEvent(g_eventTypes.objectInteractEvent, CollectibleLauncher, collectible, conversation);

end

function CollectibleLauncher(eventStruct, conversation:table) --:InteractEventStruct
	print("CollectibleLauncher is now deprecated.  Please use a Narrative Sequence or a Narrative Moment instead.");
end

-- Used for when we were waiting to transition out of a composition manually post-dialog text pop up
function OnDismissedDialogPostComposition(playerToUpdate:player, compToEnd, pKey):void
	-- Transition out manually now
	Narrative_TriggerTransitionOut(playerToUpdate, compToEnd);

	-- [Extra transition calls] This is due to delay from dialog popup text. Can be removed if dialog text appears instantly after comp.
	-- Right now all players will have movement/camera disabled at the end of the composition.
	player_disable_movement(false);
	player_camera_control(true);

	-- Re-show HUD for all clients
	RunClientScript("SetHUDForCompositionWithPostDialog", true);
	
	-- Sleep for HUD to fully transition back in before updating objective
	SleepSeconds(2);

	-- Complete Investigate Dead Spartan objective
	MissionObjectiveComplete(pKey);
end

-- =================================================================================================
--	Push Forward
-- =================================================================================================
-- =================================================================================================


global b_push_forward_vo_timer_default:number = 100;
global b_push_forward_vo_timer:number = 60;
global b_push_forward_vo_active:boolean = false;
global b_push_forward_test_combat:boolean = true;
global b_push_forward_test_speed:boolean = true;
global b_push_forward_vo_counrdown_on:number = 0;


function PushForwardVO(ExitGoal:table)

	local EnCondition:boolean = false;

	PrintNarrative("WAKE - PushForwardVO");

	PrintNarrative("START - PushForwardVO");

	sleep_s(1);

	if b_push_forward_vo_active == false then

			repeat


				b_push_forward_vo_active = true;

				SleepUntil([| b_push_forward_vo_timer > 0 and not IsSpartanInCombat() and playersMovementSpeed() <= 3.2], 120);

				--print("after SleepUntil = ", playersMovementSpeed());

				PrintNarrative("TIMER STARTED - PushForwardVO - "..tostring(b_push_forward_vo_timer));

				repeat

						sleep_s(1);

						if b_push_forward_vo_timer > 0 then
							b_push_forward_vo_timer = b_push_forward_vo_timer - 1;
							b_push_forward_vo_counrdown_on = b_push_forward_vo_counrdown_on + 1;
						end

						--print("in the loop = ", playersMovementSpeed());

						SleepUntil([| not b_collectible_used ], 1);


				until b_push_forward_vo_timer <= 0 or (b_push_forward_test_combat and IsSpartanInCombat()) or (b_push_forward_test_speed and playersMovementSpeed() > 3.2)

				b_push_forward_vo_counrdown_on = 0;

				if b_push_forward_vo_timer == 0 then
					PrintNarrative("TIMER END - PushForwardVO");
				elseif b_push_forward_vo_timer < 0 then
					PrintNarrative("TIMER STOPPED - PushForwardVO -   -1");
				elseif b_push_forward_test_combat and IsSpartanInCombat() then
					PrintNarrative("TIMER RESET - PushForwardVO - in combat");
					PushForwardVOReset();
				elseif b_push_forward_test_speed and playersMovementSpeed() > 3.2 then
					PushForwardVOReset();
				else
					PrintNarrative("TIMER RESET - PushForwardVO - unknown");
				end

				if ExitGoal ~= nil then
					EnCondition = not b_push_forward_vo_active;
				end

			until EnCondition

	else
		PrintNarrative("TIMER ALREADY STARTED - PushForwardVO");
	end

	PrintNarrative("TIMER STOPPED - PushForwardVO - Reached end Goal");

	b_push_forward_vo_active = false;

	PrintNarrative("END - PushForwardVO");

end


function PushForwardVOStandBy()

			b_push_forward_vo_timer = -1;
			b_push_forward_vo_counrdown_on = 0;
			PrintNarrative("TIMER STAND BY - PushForwardVO");
end


function PushForwardVOReset(timer:number)

			timer = timer or b_push_forward_vo_timer_default;
			b_push_forward_vo_timer = timer;
			b_push_forward_vo_counrdown_on = 0;
			PrintNarrative("TIMER RESET - PushForwardVO");
			print("Timer: ", b_push_forward_vo_timer);

end


function PushForwardVOAdd(timer:number)

			timer = timer or 10;
			if b_push_forward_vo_timer ~= -1 then
				b_push_forward_vo_timer = b_push_forward_vo_timer + timer;
				b_push_forward_vo_counrdown_on = b_push_forward_vo_counrdown_on - timer;
				if b_push_forward_vo_counrdown_on < 0 then b_push_forward_vo_counrdown_on = 0 end
				PrintNarrative("TIMER ADD - PushForwardVO");
				print("Timer: ", b_push_forward_vo_timer);
			else
				PrintNarrative("TIMER ADD - PushForward = -1. Can't add time");
			end
end


function PushForwardVOShowTimer()

		print("Push Forward VO line TIMER: ", b_push_forward_vo_timer);
		print("Push Forward VO line COUNTDWON: ", b_push_forward_vo_counrdown_on);

end


function PushForwardVOShowTimer_Live()
	repeat
			sleep_s(1);
			print("Push Forward VO line TIMER: ", b_push_forward_vo_timer);
			print("Push Forward VO line COUNTDWON: ", b_push_forward_vo_counrdown_on);

	until b_push_forward_vo_active == false
end



--[[
-- =================================================================================================
-- =================================================================================================
ADD IN EACH LINE OF A CONVO:

			OnPlay = function (thisLine, thisConvo, queue, lineNumber) -- VOID
                    radio_tag_start(thisLine.moniker);
			end,


If a Moniker is specified, it will take priority on the CHARACTER Object.
If no Monilker is specified, the CHARACTER object will be used.

TO ADD A MONIKER:
	Ex:		moniker = "CortanaHelmet",

	List of Moniker strings recognized:

		Cortana in Helmet		-->		"CortanaHelmet"
		Exuberant Witness		-->		"ExuberantWitness"
		Sarah Palmer			-->		"SarahPalmer"
		Doc Halsey				-->		"Halsey"
		locke					-->		"locke"
		buck					-->		"buck"
		tanaka					-->		"tanaka"
		vale					-->		"vale"
		Master Chief			-->		"MasterChief"
		Fred					-->		"Fred"
		Linda					-->		"Linda"
		Kelly					-->		"Kelly"
		Arbiter					-->		"Arbiter"
		Makhee					-->		"Makhee"
		UNKNOWN					-->		"Unknown"
		Warden Eternal			-->		"WardenEternal"

		Flight Leader			-->		"FlightLeader"		(elitefriend01)
		Wing Lar One			-->		"WingLarOne"		(elitefriend03)
		Wing Lar Two			-->		"WingLarTwo"		(elitefriend01) bis
		Wing Lar Three			-->		"WingLarThree"		(elitefriend03) crashed
		Wing Siqtar One			-->		"WingSiqtarOne"		(elitefriend02)
		Wing Siqtar Two			-->		"WingSiqtarTwo"		(elitefriend05)
		Wing Jardam One			-->		"WingJardamOne"		(elitefriend04)
		Wing Jardam Two			-->		"WingJardamTwo"		(elitefriend03)
		Wing Jardam Three		-->		"WingJardamThree"	(elitefriend01)



]]


function radio_tag_start(speaker)

		-- OSIRIS
		if speaker == "Locke" then
			hud_set_radio_transmission_team_string_id("osiristeam_transmission_name");
			hud_set_radio_transmission_portrait_index(0);
			hud_show_radio_transmission_hud("locke_transmission_name");
		elseif	speaker == "Buck" then
			hud_set_radio_transmission_team_string_id("osiristeam_transmission_name");
			hud_set_radio_transmission_portrait_index(2);
			hud_show_radio_transmission_hud("buck_transmission_name");
		elseif	speaker == "Tanaka" then
			hud_set_radio_transmission_team_string_id("osiristeam_transmission_name");
			hud_set_radio_transmission_portrait_index(3);
			hud_show_radio_transmission_hud("tanaka_transmission_name");
		elseif	speaker == "Vale" then
			hud_set_radio_transmission_team_string_id("osiristeam_transmission_name");
			hud_set_radio_transmission_portrait_index(1);
			hud_show_radio_transmission_hud("vale_transmission_name");
		--	BLUE TEAM
		elseif speaker == "MasterChief" then
			hud_set_radio_transmission_team_string_id("blueteam_transmission_name");
			hud_set_radio_transmission_portrait_index(4);
			hud_show_radio_transmission_hud("chief_transmission_name");
		elseif speaker == "Fred" then
			hud_set_radio_transmission_team_string_id("blueteam_transmission_name");
			hud_set_radio_transmission_portrait_index(6);
			hud_show_radio_transmission_hud("fred_transmission_name");
		elseif speaker == "Linda" then
			hud_set_radio_transmission_team_string_id("blueteam_transmission_name");
			hud_set_radio_transmission_portrait_index(5);
			hud_show_radio_transmission_hud("linda_transmission_name");
		elseif speaker == "Kelly" then
			hud_set_radio_transmission_team_string_id("blueteam_transmission_name");
			hud_set_radio_transmission_portrait_index(7);
			hud_show_radio_transmission_hud("kelly_transmission_name");
		--	EXUBERANT WITNESS
		elseif speaker == "ExuberantWitness" then
			hud_set_radio_transmission_team_string_id("exuberantteam_transmission_name");
			hud_set_radio_transmission_portrait_index(14);
			hud_show_radio_transmission_hud("exuberant_transmission_name");
		--	CORTANA
		elseif speaker == "CortanaHelmet" then
			hud_set_radio_transmission_team_string_id("cortanateam_transmission_name");
			hud_set_radio_transmission_portrait_index(16);
			hud_show_radio_transmission_hud("cortana_transmission_name");
		--	SARAH PALMER
		elseif speaker == "SarahPalmer" then
			hud_set_radio_transmission_team_string_id("unscspartansteam_transmission_name");
			hud_set_radio_transmission_portrait_index(10);
			hud_show_radio_transmission_hud("palmer_transmission_name");
		--	HALSEY
		elseif speaker == "Halsey" then
			hud_set_radio_transmission_team_string_id("unscteam_transmission_name");
			hud_set_radio_transmission_portrait_index(8);
			hud_show_radio_transmission_hud("halsey_transmission_name");
		--	WARDEN
		elseif speaker == "WardenEternal" then
			hud_set_radio_transmission_team_string_id("wardenteam_transmission_name");
			hud_set_radio_transmission_portrait_index(17);
			hud_show_radio_transmission_hud("warden_transmission_name");
		--	UNKNOWN
		elseif speaker == "Unknown" then
			hud_set_radio_transmission_team_string_id("unknownteam_transmission_name");
			hud_set_radio_transmission_portrait_index(12);
			hud_show_radio_transmission_hud("unidentified_transmission_name");
		--	SWORD OF SANGHELIOS
		elseif speaker == "Arbiter" then
			hud_set_radio_transmission_team_string_id("swordofsangheliosteam_transmission_name");
			hud_set_radio_transmission_portrait_index(11);
			hud_show_radio_transmission_hud("arbiter_transmission_name");
		elseif speaker == "Makhee" then
			hud_set_radio_transmission_team_string_id("swordofsangheliosteam_transmission_name");
			hud_set_radio_transmission_portrait_index(13);
			hud_show_radio_transmission_hud("makhee_transmission_name");
		elseif speaker == "FlightLeader" then
			hud_set_radio_transmission_team_string_id("swordofsangheliosteam_transmission_name");
			hud_set_radio_transmission_portrait_index(13);
			hud_show_radio_transmission_hud("sos_flightleader_transmission_name");
		elseif speaker == "WingLarOne" then
			hud_set_radio_transmission_team_string_id("swordofsangheliosteam_transmission_name");
			hud_set_radio_transmission_portrait_index(13);
			hud_show_radio_transmission_hud("sos_lar1_transmission_name");
		elseif speaker == "WingLarTwo" then
			hud_set_radio_transmission_team_string_id("swordofsangheliosteam_transmission_name");
			hud_set_radio_transmission_portrait_index(13);
			hud_show_radio_transmission_hud("sos_lar2_transmission_name");
		elseif speaker == "WingLarThree" then
			hud_set_radio_transmission_team_string_id("swordofsangheliosteam_transmission_name");
			hud_set_radio_transmission_portrait_index(13);
			hud_show_radio_transmission_hud("sos_lar3_transmission_name");
		elseif speaker == "WingSiqtarOne" then
			hud_set_radio_transmission_team_string_id("swordofsangheliosteam_transmission_name");
			hud_set_radio_transmission_portrait_index(13);
			hud_show_radio_transmission_hud("sos_siqtar1_transmission_name");
		elseif speaker == "WingSiqtarTwo" then
			hud_set_radio_transmission_team_string_id("swordofsangheliosteam_transmission_name");
			hud_set_radio_transmission_portrait_index(13);
			hud_show_radio_transmission_hud("sos_siqtar2_transmission_name");
		elseif speaker == "WingSiqtarThree" then
			hud_set_radio_transmission_team_string_id("swordofsangheliosteam_transmission_name");
			hud_set_radio_transmission_portrait_index(13);
			hud_show_radio_transmission_hud("sos_siqtar3_transmission_name");
		elseif speaker == "WingJardamOne" then
			hud_set_radio_transmission_team_string_id("swordofsangheliosteam_transmission_name");
			hud_set_radio_transmission_portrait_index(13);
			hud_show_radio_transmission_hud("sos_jardam1_transmission_name");
		elseif speaker == "WingJardamTwo" then
			hud_set_radio_transmission_team_string_id("swordofsangheliosteam_transmission_name");
			hud_set_radio_transmission_portrait_index(13);
			hud_show_radio_transmission_hud("sos_jardam2_transmission_name");
		elseif speaker == "WingJardamThree" then
			hud_set_radio_transmission_team_string_id("swordofsangheliosteam_transmission_name");
			hud_set_radio_transmission_portrait_index(13);
			hud_show_radio_transmission_hud("sos_jardam3_transmission_name")
		else
			print("RADIOTAG: Moniker not found!!!!!!  --  ", speaker);
		end

end

-- If the same player enters multiple narrative moments,
global g_playerBipedsInNarrativeMode = {};

-- Puts the player in narrative mode, potentially slowing it down and switching to the 'unarmed' weapon.
-- Please note that if a player enters a new narrative moment before finishing the previous one, this function
-- will make sure that nothing crazy happens (like slowing down the player twice), and the player will finally
-- exit narrative mode when we are fully done, however the configuration for the "reentrant" narrative moment
-- will be ignored.
function PlayerUnitEnterNarrativeMode(
	pl : player,
	switchToUnarmed : boolean,
	movementSpeedMultiplier : number) : void

	if g_playerBipedsInNarrativeMode[pl] ~= nil then
		g_playerBipedsInNarrativeMode[pl].depth = g_playerBipedsInNarrativeMode[pl].depth + 1;
		return;
	end

	-- Lower the weapons, this disables shooting and other things.
	PlayerWeaponDown(pl, 0, true);

	-- This equips the biped with the "neutral" weapon containing the right animations, if switchToNeutralAnimations is passed in.
	-- This weapon automatically disables crouching and a few other things due to missing animations, but we shouldn't rely too much
	-- on this functionality because we may want to have a similar narrative moment with the weapon at hand.
	local unarmedWeapon : object = nil
	if switchToUnarmed then
		local neutralWeaponTag : tag = TAG('objects\weapons\proto\proto_neutral\proto_neutral.weapon');
		unarmedWeapon = Object_CreateFromTag(neutralWeaponTag);
		unit_add_weapon(pl, unarmedWeapon, WEAPON_ADDITION_METHOD.PrimaryWeapon);
	end

	-- Slow down the player and disable sprinting.
	local moveSpeedModifier : number = AddObjectTimedMalleablePropertyModifier("biped_movement_speed_scalar", 0, movementSpeedMultiplier, pl);
	local sprintModifier : number = AddObjectTimedMalleablePropertyModifierBool("biped_sprint_enabled", 0, false, pl);

	local ret : table = {
		unarmedWep = unarmedWeapon,
		sprintMod = sprintModifier,
		moveSpeedMod = moveSpeedModifier,
		depth = 1,
	};

	g_playerBipedsInNarrativeMode[pl] = ret;
end

function PlayerUnitExitNarrativeMode(pl : player) : void
	local t : table = g_playerBipedsInNarrativeMode[pl];

	if not t then
		return;
	end

	t.depth = t.depth - 1;

	if t.depth ~= 0 then
		-- We are nested, wait for the last narrative moment to finish.
		return;
	end

	g_playerBipedsInNarrativeMode[pl] = nil;

	-- Remove slowdown modifiers.
	RemoveMalleablePropertyModifier(t.sprintMod);
	RemoveMalleablePropertyModifier(t.moveSpeedMod);

	-- Remove the unarmed weapon if we switched.
	-- This weapon will delete itself on drop.
	if t.unarmedWep then
		Unit_DropWeapon(pl, t.unarmedWep);
	end

	-- Weapons ready.
	PlayerWeaponDown(pl, 0, false);
end

function FastTravelOnSkip(destination:location, destinationZoneSet:zone_set)

	if (destination) then
		FastTravel.NarrativeTravelOnSkip(destination, destinationZoneSet);
	else
		print("Invalid cinematic skip destination!");
	end
end

local function BuildFlySettingsFromSpline(splineName:string, flyIn:boolean):table
	local flySettings:table = nil;
	if (splineName ~= nil and splineName ~= "") then
		local spline:spline_placement = SPLINE_PLACEMENTS[splineName];

		if (spline ~= nil) then
			print("Using spline: ", splineName);
			flySettings = AirDrop.FlightSettings:MakeCustomFromLevelSpline(spline);
		else
			print("Could not find spline: ", splineName);
		end
	end
	-- Use default path when spline is not provided / not found
	if (flySettings == nil) then
		flySettings = AirDrop.FlightSettings:MakeFast();
	end

	if (flySettings.travelType == AIRDROP_FLIGHT_TRAVEL_TYPE.Custom) then
		if flyIn == true then
			local transitionType:airdrop_flight_transition_type = AIRDROP_FLIGHT_TRANSITION_TYPE.None;
			flySettings:SetTransitionData(transitionType, 0);
		else
			local transitionType:airdrop_flight_transition_type = AIRDROP_FLIGHT_TRANSITION_TYPE.Warp;
			flySettings:SetTransitionData(transitionType, 3);
		end
	end

	return flySettings;
end

local function BuildPelicanRoute(pelicanConfig:table, dropLocation:location, flyOutSpline:string, flyInSpline:string)

	local routeRequest:table = AirDrop.RouteRequest:New(get_string_id_from_string("Nar_pelican_route"));
	routeRequest:UseExactDropLocation(ToLocation(dropLocation).matrix);
	routeRequest:SetDropShip(hmake AirDropShip
	{
		vehicleDefinition = pelicanConfig.vehicleDef;
		vehicleConfiguration = pelicanConfig.vehicleConfig;
		pilotDefinition = pelicanConfig.pilotDef;
	});

	local flyInSettings = BuildFlySettingsFromSpline(flyInSpline, true);
	local flyOutSettings = BuildFlySettingsFromSpline(flyOutSpline, false);
	
	routeRequest:SetFlyInSettings(flyInSettings);
	routeRequest:SetFlyOutSettings(flyOutSettings);

	local cargoDeliveryItem:table = AirDrop.DeliveryItem:CreateFromRadius(1, 1, CARGO_TYPE.Passengers);
	routeRequest:AddDeliveryItem(cargoDeliveryItem);

	return routeRequest;
end

-- Starts a pelican fly-out (intended to be used after a narrative sequence drops MC somewhere).
-- Params:
-- flyOutStartLocation: start location for the flyout.
-- flyOutSpline: name of spline placed in level (fly-out path for the pelican to follow).
-- flyInSpline(Optional): name of spline placed in level (fly-in path towards flyOutStartLocation).
-- pelicanToUse(Optional): pelican object assigned if we don't wish to spawn a new pelican.
-- overridePelicanPhysics(Optional): pelicanToUse's physics will be frozen in place while we setup the route and then returned to normal after.
-- If this has already happened previously I would avoid setting this bool, as repeated usage of object_override_physics_motion_type can cause issues I've found. 
function NarrativePelicanFlyOut(pelicanConfig:table, flyOutStartLocation:location, flyOutSpline:string, flyInSpline:string, pelicanToUse:object, overridePelicanPhysics:boolean):boolean
	local overridePhysics:boolean = overridePelicanPhysics or false;

	if (pelicanConfig == nil or flyOutStartLocation == nil) then
		print("Invalid pelican fly-out configuration");
		return false;
	end

	local useAssignedPelican:boolean = object_index_valid(pelicanToUse);
	if (useAssignedPelican and overridePhysics) then
		-- Prevent pelican from falling in between composition's ending and waiting on the spline path route to be generated. This is reset right before flight:TakeOff()
		object_override_physics_motion_type(pelicanToUse, 1); -- 1 = Fixed
		print("[NarrativePelicanFlyOut] Pelican frozen, waiting for spline path flight");
	end

	print("Requesting Pelican flight route");

	local routeRequest:table = BuildPelicanRoute(pelicanConfig, flyOutStartLocation, flyOutSpline, flyInSpline);
	local queryHandle:handle = AirDrop_RequestRoute(routeRequest);
	if (queryHandle == nil) then
		print("Failed to get Pelican flight query handle");
		return false;
	end

	SleepUntil([| AirDrop_IsRouteQueryComplete(queryHandle) ]);

	local routeResult:table = AirDrop_GetRouteQueryResult(queryHandle);
	if (routeResult == nil) then
		print("Failed to get Pelican flight route");
		return false;
	end

	local cargoDestination:table = AirDrop.FlightDestination:MakeFlyToDestination(flyOutStartLocation.matrix);
	cargoDestination:SetShipLocationForDrop(flyOutStartLocation.matrix);

	-- Generate Route Query based on if we're using an already spawned pelican or spawning our own
	local flight:table;
	if (useAssignedPelican) then
		flight = AirDrop.Flight:CreateFromRouteQueryWithExistingShip(queryHandle, vehicle_driver(pelicanToUse), pelicanToUse, get_string_id_from_string("Nar_pelican_route"));
	else
		flight = AirDrop.Flight:CreateFromRouteQuery(queryHandle, get_string_id_from_string("Nar_pelican_route"));
	end

	flight:AddDestination(cargoDestination);

	if (useAssignedPelican and overridePhysics) then
		-- Reset pelican to normal physics now that our spline path has been generated and is about to be used.
		object_override_physics_motion_type(pelicanToUse, 0); -- 0 = default
		print("[NarrativePelicanFlyOut] Pelican physics resumed, following spline path flight");
	end

	flight:TakeOff();

	AirDrop_ReleaseRouteQuery(queryHandle);

	local dropship:object = flight:GetDropShip();
	if (dropship ~= nil) then
		Object_SetCampaignTeam(dropship, Player_GetCampaignTeam(GetFireTeamLeader()));
		object_cannot_take_damage(dropship);
	end

	SleepUntilSeconds([| flight:IsValid() == false or (useAssignedPelican and object_index_valid(pelicanToUse) == false) ], 0.5);

	return true;
end

-- =================================================================================================

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================

--DEPRECATED FUNCTIONS



-- =================================================================================================
-- =================================================================================================
-- DOMAIN TERMINALS
-- =================================================================================================
-- =================================================================================================
global obj_narrative_pup_player:object=nil;
global obj_narrative_pup_terminal:object=nil;



-- === f_narrative_domain_terminal_pressed: Call back when the button is pressed in the ICS
--			[object] obj_terminal = Terminal crate object
--	RETURNS:  [void]
function f_narrative_domain_terminal_pressed( obj_terminal:object ):void
	dprint("f_narrative_domain_terminal_pressed");
end

-- === f_narrative_domain_terminal_sphere: Gets the sphere object off of a terminal
--			[object] obj_terminal = Terminal crate object
--	RETURNS:  [object]
function f_narrative_domain_terminal_sphere( obj_terminal:object ):object
	return object_at_marker(obj_terminal, "dissolve");
end

function f_narrative_domain_terminal_sphere_phase( obj_terminal:object, b_phase_in:boolean, b_destroy:boolean ):void
	local obj_sphere:object=f_narrative_domain_terminal_sphere(obj_terminal);
	-- play fx
	if obj_sphere~=nil then
		if b_phase_in then
			object_dissolve_from_marker(obj_sphere, "phase_in", "fx_dissolve_back");
		else
			object_dissolve_from_marker(obj_sphere, "phase_out", "fx_dissolve_back");
		end
	end
	-- wait for fx to finish
	if obj_sphere~=nil then
		sleep_s(1.75);
	end
	-- destroy
	if b_destroy and obj_sphere~=nil then
		object_destroy(obj_sphere);
	end
end

-- DEBUG

-- Blink Helpers

function NarrativeBlinkToLocation(loc:location, zoneSet: zone_set, name: string)

	print("Blinking to narrative location: '", name, "'");

	if (loc) then
		FastTravel.BlinkToLocation(loc, zoneSet);
	else
		print("Attempted to blink to an invalid location: '", name, "'");
	end
end

function NarrativeBlinkThread(blink: table, autoPlaySeq: boolean, musicEventTag)
	if (blink and blink.locationId and FLAGS[blink.locationId]) then

		PlayersSetControlEnabled(false);

		if (blink.poiKey) then
			DiscoverPoi(blink.poiKey);
		end

		local zoneSet : zone_set = nil;
		if (blink.zoneSet) then
			zoneSet = ZONE_SETS[blink.zoneSet];
		end

		if not blink.doNotBlink then
			NarrativeBlinkToLocation(ToLocation(FLAGS[blink.locationId]), zoneSet, blink.locationId);
		end

		if (musicEventTag) then
			music_event(TAG('sound\120_music_campaign\global\120_mus_global_blink_stopall.music_control'));
			music_event(musicEventTag);
		end

		local delay:number = blink.callbackDelay or 2;
		SleepSeconds(delay);

		if (blink.callback) then
			blink.callback(blink, autoPlaySeq);
		else
			NarrativeBlinkCallback(blink, autoPlaySeq);
		end

		PlayersSetControlEnabled(true);
	else
		print("Attempted to blink to invalid narrative location");
	end
end

function NarrativeBlinkCallback(blinkEntry:table, autoPlaySeq:boolean)

	ai_kill_all();
	ai_erase_all();

	if (autoPlaySeq == true) then
		if (blinkEntry and blinkEntry.narSeqName and blinkEntry.narSeqName ~= "") then
			NarrativeInterface.PlayNarrativeSequence(blinkEntry.narSeqName, { poiKey = blinkEntry.poiKey });
		else
			print("Attempted to play invalid narrative sequence...");
		end
	end
end

function NarrativeBlinkNoCallback(blinkEntry:table, autoPlaySeq:boolean)
	-- Used to specify no callback since NarrativeBlinkCallback is the default in case of nil but not always preferred.
end

function NarrativeBlinkToHelper(blinkOnly:boolean, blocking:boolean, narrativeBlinkTableEntry:table, musicEventTag)
	if blocking then
		NarrativeBlinkThread(narrativeBlinkTableEntry, not blinkOnly, musicEventTag);
	else
		CreateThread(NarrativeBlinkThread, narrativeBlinkTableEntry, not blinkOnly, musicEventTag);
	end

	return true;
end

function AssignAllAiVoCharacters(convo:table, nearestAi:table):boolean
	if (not convo or not nearestAi) then return false; end

	local monikerMapping = {};
	local nextIndex = 1;
	local failedToPopulateAtLeastOneLine = false;
	for lineId,line in hpairs(convo.lines) do
		if (not line.character) then
			if (not monikerMapping[line.moniker]) then
				monikerMapping[line.moniker] = nearestAi[nextIndex];
				nextIndex = nextIndex + 1;
				failedToPopulateAtLeastOneLine = failedToPopulateAtLeastOneLine or not monikerMapping[line.moniker];
			end

			line.character = monikerMapping[line.moniker];
		end
	end

	return (not failedToPopulateAtLeastOneLine);
end

function AssignSortedAiVoCharacters(convo:table, nearestAi:table, monikerTypeMap:table):boolean
	if (not convo or not nearestAi) then return false; end

	if (not monikerTypeMap) then
		for aiType,aiList in hpairs(nearestAi) do	-- Not a real loop ; just using this to get the first item in a non-integer-key list
			return AssignAllAiVoCharacters(convo, aiList);
		end
	end

	local monikerMapping = {};
	local nextIndex = {};
	local failedToPopulateAtLeastOneLine = false;
	for lineId,line in hpairs(convo.lines) do
		if (not line.character and monikerTypeMap[line.moniker]) then
			if (not monikerMapping[line.moniker]) then
				local currentType = monikerTypeMap[line.moniker];
				monikerMapping[line.moniker] = nearestAi[currentType][nextIndex[currentType] or 1];
				nextIndex[currentType] = (nextIndex[currentType] or 1) + 1;
				failedToPopulateAtLeastOneLine = failedToPopulateAtLeastOneLine or not monikerMapping[line.moniker];
				print("AssignSortedAiVoCharacters: We tried to fill line", lineId, "with object", (monikerMapping[line.moniker] or "-NIL-"));
			end

			print("AssignSortedAiVoCharacters: Assigning line", lineId, "with object", (monikerMapping[line.moniker] or "-NIL-")); 
			line.character = monikerMapping[line.moniker];
		else
			print("AssignSortedAiVoCharacters: Skipping line", lineId);
		end
	end

	print("AssignSortedAiVoCharacters: All lines attempted");
	return (not failedToPopulateAtLeastOneLine);
end


function AiObjectIsInCombatOrDead(aiObject:object, combatStausLevel:actor_combat_status):boolean
    local objType:string, objSubType:string = GetEngineType(aiObject, true);
    local isDead:boolean = (
                   (aiObject == nil)
                or (objSubType == "biped" and not biped_is_alive(aiObject))
                or (objSubType == "vehicle" and object_get_health(aiObject) <= 0)
            );

    return isDead or (combatStausLevel and ai_combat_status_a_greater_or_equal_b( ai_combat_status( object_get_ai( aiObject ) ), combatStausLevel ));
end


function LaunchAIVOWatcherThread(convoId:string, convo:table, combatStatusLevel:actor_combat_status):void
	--Thread for killing convo early if the grunts spot the player
	CreateThread(
		function()
			SleepUntil([| NarrativeInterface.ConversationIsActive(convoId) ], 1);

			local check:boolean = true;
			local convoEnded:boolean = false;

			while (check) do
				-- Check combat status level or death
				for lineId,line in ipairs(convo.lines) do
					check = check and not AiObjectIsInCombatOrDead(line.character, combatStatusLevel);
				end

				convoEnded = NarrativeInterface.ConversationHasFinished(convoId);
				check = check and not convoEnded;

				Sleep(1);
			end

			if (not convoEnded) then
				NarrativeInterface.KillConversation(convoId);
			end
		end
	);
end


function FuseSquadSpawnerLists(...):table
	local fusedSpawnersList = {};

	for i,v in ipairs(arg) do
		local result,value = table.GetDescendant(unpack(v));

		if (result) and (GetEngineType(value) == "squad_spawner") then
			MergeEnemyTables(fusedSpawnersList, ai_actors( AI_GetAISquadFromSquadInstance( AI_GetSquadInstanceFromSquadSpawner( value ) ) ));
		else
			print("Bad data passed to FuseSquadSpawnerLists", value, GetEngineType(value));
		end
	end

	return fusedSpawnersList;
end

--## CLIENT

-- Used generically for starting a comp where we want to show the splash banner (e.g. when collecting a collectible).
-- Can also be used post-dialog dismissed to return to previous HUD state pre-composition.
-- Currently called at the start of each dead spartan composition.
function remoteClient.SetHUDForCompositionWithPostDialog(postDialog:boolean):void
	-- These 2 should always be true as we want to show the "collected <equipment>" banner during the composition
	hud_show(true);
	hud_show_splash_banner(true);

	-- Extra UI to show/hide depending on comp progress
	hud_show_ability(postDialog);
	hud_show_crosshair(postDialog);
	hud_show_fanfares(postDialog);
	hud_show_hud_wires(postDialog);
	hud_show_messages(postDialog);
	hud_show_radar(postDialog);
	hud_show_shield(postDialog);
	hud_show_weapon(postDialog);
end