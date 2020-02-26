--## SERVER

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
                                for _,spartan in ipairs (musketeers()) do
                                                if ai_combat_status (object_get_ai(spartan)) > 4 then
                                                                are_they_in_combat = true;
                                                end
                                end
                                
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

	local test_team = nil;
                spartan = spartan or SPARTANS[1];
                m_dist = m_dist or 1000;
				all_team = all_team or 0;

				if all_team == 0 then 
					test_team = musketeers();
				elseif all_team == 1 then 
					test_team = players();
				elseif all_team == 2 then 
					test_team = spartans();
				end

                local cl_spartan:object = spartan;
                for _,sp in ipairs (test_team) do

                                local dist:number = objects_distance_to_object (spartan, sp);
								--print("Distance for ", sp, " : ", dist);
                                if (sp ~= spartan) and dist < m_dist and IsSpartanAbleToSpeak(sp) then
                                                m_dist = dist;
                                                cl_spartan = sp;
                                end
                end
                --print ("closest spartan is", cl_spartan );
                return cl_spartan


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

	local test_team = nil;
                --spartan = spartan or SPARTANS[1];
                m_dist = m_dist or 1;
				all_team = all_team or 0;

				if all_team == 0 then 
					test_team = musketeers();
				elseif all_team == 1 then 
					test_team = players();
				elseif all_team == 2 then 
					test_team = spartans();
				end

                local cl_spartan:object = nil;
                for _,sp in ipairs (test_team) do

                                local dist:number = objects_distance_to_object (spartan, sp);
								--print("Distance for ", sp, " : ", dist);
                                if (sp ~= spartan) and dist > m_dist and IsSpartanAbleToSpeak(sp) then
                                                m_dist = dist;
                                                cl_spartan = sp;
                                end
                end
                --print ("closest spartan is", cl_spartan );
				if request_distance == "distance" then
					return m_dist;
				else
					return cl_spartan;
				end

				
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

						--		for _,enemy in pairs (ai_group) do
								for i = 0, (list_count(ai_group) - 1)	do
						
								local enemy = list_get( ai_group, i );
								local dist:number = objects_distance_to_object (spartan, enemy);
								--print("GetClosestEnemy - spartan :", spartan);
								--print("GetClosestEnemy - enemy :", enemy);
								
												if g_display_narrative_debug_info then
														--print("Distance for ", enemy, " to ", spartan, "  : ", dist);
												end
								
												if dist < m_dist and dist >= 0 then
																m_dist = dist;
																closestEnemy = enemy;
																closestPlayer = spartan;
												end

												Sleep(1);
								end
						end
				else
								for i = 0, (list_count(ai_group) - 1)	do
						
								local enemy = list_get( ai_group, i );
								local dist:number = objects_distance_to_object (specific_spartan, enemy);
								--print("GetClosestEnemy - spartan :", spartan);
								--print("GetClosestEnemy - enemy :", enemy);
								
												if g_display_narrative_debug_info then
														--print("Distance for ", enemy, " to ", spartan, "  : ", dist);
												end
								
												if dist < m_dist and dist >= 0 then
																m_dist = dist;
																closestEnemy = enemy;
																closestPlayer = specific_spartan;
												end

												Sleep(1);
								end

				end

		end

		return closestEnemy, closestPlayer

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

local closestEnemy:object;
local closestPlayer:object;

                
		if (list_count(ai_group) >= 1) then

				m_dist = m_dist or 1000;

				for _,spartan in ipairs (players()) do

						for _,enemy in ipairs (ai_group) do

										Sleep(1);
																			
										local dist:number = objects_distance_to_object (spartan, enemy);
								
										if g_display_narrative_debug_info then
												--print("Distance for ", enemy, " to ", spartan, "  : ", dist);
										end
								
										if dist < m_dist and dist >= 0 then
														m_dist = dist;
														closestEnemy = enemy;
														closestPlayer = spartan;
										end
						end
				end
		end

		if g_display_narrative_debug_info then
			--print("GetClosestEnemyInEnemyGroup: ", closestEnemy, closestPlayer);
		end

		return closestEnemy, closestPlayer

end




function MergeEnemyTables(t1, t2)
 
   for k,v in ipairs(t2) do
      table.insert(t1, v)
   end 
 
   return t1
end

-- =================================================================================================
--	Get Closest enemy (To play VO on him	*			
-- =================================================================================================
--	Need a Object list of AI to choose from (All Grunts or all Elites)
-- =================================================================================================
--	That function will go through the players and the enemies and will return a couple (player/enemy) that are close enough to play a VO on the enemy.


global enemy_list_grunt = {};
global enemy_list_elite = {};
global enemy_list_jackal = {};
global enemy_list_covenant = {};

global enemy_list_closeplayer:object = nil
global enemy_list_closeenemy:object = nil



function IsThereAnEnemyInRange(EnemyGroup:object_list, type:actor_type, distance:number, bigger_group:string)

	local EnemyListtype:object_list = nil;

	enemy_list_closeplayer = nil;
	enemy_list_closeenemy = nil;

	distance = distance or 10;

	EnemyListUpdate(EnemyGroup);
	
	if type == ACTOR_TYPE.grunt then
		EnemyListtype = enemy_list_grunt;
	elseif type == ACTOR_TYPE.elite then
		EnemyListtype = enemy_list_elite;
	elseif type == ACTOR_TYPE.jackal then
		EnemyListtype = enemy_list_jackal;
	elseif bigger_group == "covenant" then
		enemy_list_covenant = {};
		MergeEnemyTables(enemy_list_covenant, enemy_list_grunt);
		MergeEnemyTables(enemy_list_covenant, enemy_list_elite);
		MergeEnemyTables(enemy_list_covenant, enemy_list_jackal);
		EnemyListtype = enemy_list_covenant;
	end

	if g_display_narrative_debug_info then
		--print("IsThereAnEnemyInRange: enemy_list_", type, " - Contains : ", list_count(EnemyListtype) );
	end

			if list_count(EnemyListtype) > 0 then

				--PrintNarrative("IsThereAnEnemyInRange: Enemies are present, getting closest:");
				enemy_list_closeenemy, enemy_list_closeplayer = GetClosestEnemyInEnemyGroup(EnemyListtype, distance);
				if g_display_narrative_debug_info then
					--print("IsThereAnEnemyInRange:  ", enemy_list_closeenemy, " , close to: ", enemy_list_closeplayer);
				end
		
			end
	
	return enemy_list_closeenemy

end

-----------------------------------------------------------------------------------------
--	UPDATE THE ENEMY LIST BY GOING THROUGH THE Enemy Squad Group given.
----------------------------------------------------------------------------------------
function EnemyListUpdate(EnemyGroup:object_list)

enemy_list_grunt = {};
enemy_list_elite = {};
enemy_list_jackal = {};

if g_display_narrative_debug_info then
	--print("EnemyListUpdate: Update ", EnemyGroup);
end


		for i = 1,  list_count(EnemyGroup)
			
				do			
					
					if ai_get_actor_type(object_get_ai( list_get(EnemyGroup, (i - 1)))) == ACTOR_TYPE.grunt then

						table.insert(enemy_list_grunt,list_get(EnemyGroup, (i - 1)));
						--print(i, "EnemyListUpdate :", list_get(EnemyGroup, (i - 1)))

					elseif ai_get_actor_type(object_get_ai(list_get(EnemyGroup, (i - 1)))) == ACTOR_TYPE.elite then

						table.insert(enemy_list_elite,list_get(EnemyGroup, (i - 1)));
						--print(i, "EnemyListUpdate :", list_get(EnemyGroup, (i - 1)))

					elseif ai_get_actor_type(object_get_ai(list_get(EnemyGroup, (i - 1)))) == ACTOR_TYPE.jackal then

						table.insert(enemy_list_jackal,list_get(EnemyGroup, (i - 1)));
						--print(i, "EnemyListUpdate :", list_get(EnemyGroup, (i - 1)))

					end

					if g_display_narrative_debug_info then
						--print(i, "EnemyListUpdate :", list_get(EnemyGroup, (i - 1)))
					end

					Sleep(1);
		end
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

local s_enemy_vo_is_playing:boolean = false;

	

	PrintNarrative("START - IsThereAnEnemyInRangeLauncher - "..s_conversation.name);

	distance = distance or 15;
	overlap = overlap or false;

	repeat

		sleep_s(0.5);

		if ((NarrativeQueue.ConversationsPlayingCount() == 0 and not overlap and not s_enemy_vo_is_playing) or overlap ) then
			s_conversation.localVariables[s_convos_local_variable] = IsThereAnEnemyInRange(s_ai_squad, s_actor_type, distance);
		end
	
	until (((NarrativeQueue.ConversationsPlayingCount() == 0 and not overlap and not s_enemy_vo_is_playing) or overlap ) and s_conversation.localVariables[s_convos_local_variable] ~= nil)
			 or (not IsGoalActive(s_valid_goal)) or ai_living_count(s_ai_squad) == 0
			
	
	s_conversation.lines[1].character = s_conversation.localVariables[s_convos_local_variable];

	if s_conversation.localVariables[s_convos_local_variable] ~= nil then 
		
		s_enemy_vo_is_playing = true;

		PrintNarrative("IsThereAnEnemyInRangeLauncher - Found Speaker");
		PrintNarrative("QUEUE - "..s_conversation.name);
		NarrativeQueue.QueueConversation(s_conversation);

		SleepUntil([| NarrativeQueue.HasConversationFinished(s_conversation) ]);

		s_enemy_vo_is_playing = false;

	elseif not IsGoalActive(s_valid_goal) then
		PrintNarrative("IsThereAnEnemyInRangeLauncher - Reached EndGoal");
	elseif ai_living_count(s_ai_squad) == 0 then
		PrintNarrative("IsThereAnEnemyInRangeLauncher - Squad all dead or empty");
	end
	PrintNarrative("END - IsThereAnEnemyInRangeLauncher - "..s_conversation.name);

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

	CreateThread(RegisterInteractEvent, CollectibleLauncher, collectible, conversation);
	
end

function CollectibleLauncher(collectible:object, player_interacted:object, conversation:table)

	print("LAUNCHER - ", collectible);

	print(player_interacted, " has interacted with ", collectible);

	device_set_power (collectible, 0);
		
	conversation.localVariables.activatingPlayer = player_interacted;
	NarrativeQueue.QueueConversation(conversation);
	
	print("end");
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
		
			until EnCondition or IsGoalActive(ExitGoal)

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
                    radio_tag_start(thisLine.moniker or NarrativeQueue.ResolveLineCharacter(thisLine, thisConvo, queue, lineNumber));
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




-- =================================================================================================

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================

--DEPRECATED FUNCTIONS

-- === IsNarrativeFlagSetOnAllPlayer: Checks if a narrative flag has been set on all players matching a state
--			[short] s_narrative_flag_index = Flag index
--			[boolean] b_state = State to test
--						[optional] DEFAULT == TRUE
--	RETURNS:  [boolean] TRUE; if all valid players flags match that state
function isnarrativeflagsetonallplayer( s_narrative_flag_index:number, b_state:boolean ):boolean
	return ( not player_is_in_game(PLAYERS.player0) or GetNarrativeFlag(PLAYERS.player0, s_narrative_flag_index) == b_state) and ( not player_is_in_game(PLAYERS.player1) or GetNarrativeFlag(PLAYERS.player1, s_narrative_flag_index) == b_state) and ( not player_is_in_game(PLAYERS.player2) or GetNarrativeFlag(PLAYERS.player2, s_narrative_flag_index) == b_state) and ( not player_is_in_game(PLAYERS.player3) or GetNarrativeFlag(PLAYERS.player3, s_narrative_flag_index) == b_state);
end
--[[
script static boolean IsNarrativeFlagSetOnAllPlayer( short s_narrative_flag_index )
	IsNarrativeFlagSetOnAllPlayer( s_narrative_flag_index, TRUE );
end
]]


-- [used in m40 and m90]
-- === f_narrative_domain_terminal_setup: Sets up and manages a domain terminal
--			[short] s_terminal_id = Domain terminal index
--			[object_name] obj_terminal = Terminal crate object
--			[object_name] obj_button = button (device control) that the player interacts with
--	RETURNS:  [void]
function f_narrative_domain_terminal_setup( s_terminal_id:number, obj_terminal:object_name, obj_button:object_name ):void
	local b_active:boolean=false;
	if editor_mode() then
		SetNarrativeFlagOnLocalPlayers(s_terminal_id, false);
	end
	repeat
		Sleep(1);
		-- wait for the object to become valid
		SleepUntil([| object_valid(obj_terminal) and object_valid(obj_button) ], 1);
		-- check if it should be active
		b_active = f_narrative_domain_terminal_active(s_terminal_id);
		-- setup
		if b_active and f_narrative_domain_terminal_sphere(ObjectFromName(obj_terminal))~=nil then
			--dprint( "f_narrative_domain_terminal_setup: ACTIVATE!!!!!!!" );
			f_narrative_domain_terminal_sphere_phase(ObjectFromName(obj_terminal), true, false);
			device_set_power(ObjectFromName(obj_button), 1.0);
		else
			--dprint( "f_narrative_domain_terminal_setup: DEACTIVATE!!!!!!!" );
			device_set_power(ObjectFromName(obj_button), 0.0);
			f_narrative_domain_terminal_sphere_phase(ObjectFromName(obj_terminal), false, false);
		end
		--dprint( "f_narrative_domain_terminal_setup!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
		-- wait to reset checks
		SleepUntil([|  not object_valid(obj_terminal) or  not object_valid(obj_button) or (f_narrative_domain_terminal_sphere(ObjectFromName(obj_terminal))~=nil and b_active~=f_narrative_domain_terminal_active(s_terminal_id)) ], 1);
	until false;
end


-- =================================================================================================
-- =================================================================================================
-- DOMAIN TERMINALS
-- =================================================================================================
-- =================================================================================================
global obj_narrative_pup_player:object=nil;
global obj_narrative_pup_terminal:object=nil;



--dprint( "f_narrative_domain_terminal_setup: EXIT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
-- === f_narrative_domain_terminal_interact: Sets up and manages a domain terminal
--			[short] s_terminal_id = Domain terminal index
--			[object] obj_terminal = Terminal crate object
--			[device] dc_button = button (device control) that the player interacts with
--			[unit] u_activator = player who pressed the button
--			[u_activator] sid_pup = name of the puppeteer
--	RETURNS:  [void]
function f_narrative_domain_terminal_interact( s_terminal_id:number, obj_terminal:object, dc_button:object, u_activator:object, sid_pup:string ):void
	local l_pup_id:number=-1;
	-- wait for input
	device_set_power(dc_button, 0.0);
	-- set user
	obj_narrative_pup_player = u_activator;
	obj_narrative_pup_terminal = obj_terminal;
	-- prep player
	object_cannot_die(u_activator, true);
	-- play the pup
	l_pup_id = pup_play_show(sid_pup);
	SleepUntil([|  not pup_is_playing(l_pup_id) ], 1);
	-- reset player
	object_cannot_die(u_activator, false);
	-- phase out the terminal sphere
	sleep_s(0.125);
	CreateThread(f_narrative_domain_terminal_sphere_phase, obj_terminal, false, true);
	-- wait for terminal to vanish
	SleepUntil([| f_narrative_domain_terminal_sphere(obj_terminal) == nil ], 1);
	-- check for first domain
	if f_narrative_domain_terminal_first() then
		Wake(dormant.f_dialog_global_my_first_domain);
	end
	-- set the variable
	SetNarrativeFlagWithFanfareMessageForAllPlayers(s_terminal_id, true);
end

-- === f_narrative_domain_terminal_pressed: Call back when the button is pressed in the ICS
--			[object] obj_terminal = Terminal crate object
--	RETURNS:  [void]
function f_narrative_domain_terminal_pressed( obj_terminal:object ):void
	dprint("f_narrative_domain_terminal_pressed");
end

-- === f_narrative_domain_terminal_active: Checks to see if a terminal should be active
--			[short] s_terminal_id = ID for the terminal
--	RETURNS:  [boolean] TRUE; the terminal should be active, FALSE; the terminal should not be active
function f_narrative_domain_terminal_active( s_terminal_id:number ):boolean
	return (player_is_in_game(PLAYERS.player0) and GetNarrativeFlag(PLAYERS.player0, s_terminal_id) == false) or (player_is_in_game(PLAYERS.player1) and GetNarrativeFlag(PLAYERS.player1, s_terminal_id) == false) or (player_is_in_game(PLAYERS.player2) and GetNarrativeFlag(PLAYERS.player2, s_terminal_id) == false) or (player_is_in_game(PLAYERS.player3) and GetNarrativeFlag(PLAYERS.player3, s_terminal_id) == false);
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

function f_narrative_domain_terminal_first():boolean
	return (player_is_in_game(PLAYERS.player0) and GetNarrativeFlag(PLAYERS.player0, 0) == false and GetNarrativeFlag(PLAYERS.player0, 1) == false and GetNarrativeFlag(PLAYERS.player0, 2) == false and GetNarrativeFlag(PLAYERS.player0, 3) == false and GetNarrativeFlag(PLAYERS.player0, 4) == false and GetNarrativeFlag(PLAYERS.player0, 5) == false and GetNarrativeFlag(PLAYERS.player0, 6) == false) or (player_is_in_game(PLAYERS.player1) and GetNarrativeFlag(PLAYERS.player1, 0) == false and GetNarrativeFlag(PLAYERS.player1, 1) == false and GetNarrativeFlag(PLAYERS.player1, 2) == false and GetNarrativeFlag(PLAYERS.player1, 3) == false and GetNarrativeFlag(PLAYERS.player1, 4) == false and GetNarrativeFlag(PLAYERS.player1, 5) == false and GetNarrativeFlag(PLAYERS.player1, 6) == false) or (player_is_in_game(PLAYERS.player2) and GetNarrativeFlag(PLAYERS.player2, 0) == false and GetNarrativeFlag(PLAYERS.player2, 1) == false and GetNarrativeFlag(PLAYERS.player2, 2) == false and GetNarrativeFlag(PLAYERS.player2, 3) == false and GetNarrativeFlag(PLAYERS.player2, 4) == false and GetNarrativeFlag(PLAYERS.player2, 5) == false and GetNarrativeFlag(PLAYERS.player2, 6) == false) or (player_is_in_game(PLAYERS.player3) and GetNarrativeFlag(PLAYERS.player3, 0) == false and GetNarrativeFlag(PLAYERS.player3, 1) == false and GetNarrativeFlag(PLAYERS.player3, 2) == false and GetNarrativeFlag(PLAYERS.player3, 3) == false and GetNarrativeFlag(PLAYERS.player3, 4) == false and GetNarrativeFlag(PLAYERS.player3, 5) == false and GetNarrativeFlag(PLAYERS.player3, 6) == false);
end


