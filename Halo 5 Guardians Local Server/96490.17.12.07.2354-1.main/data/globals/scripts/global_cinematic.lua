
-- ===============================================================================================================================================
-- COMPOSER GLOBALS ==============================================================================================================================
-- ===============================================================================================================================================
global composer_random_num:number = 0;

-- ===============================================================================================================================================
-- COMPOSER FUNCTIONS ============================================================================================================================
-- ===============================================================================================================================================
function f_play_show (show_name:string):void
	local show:number = composer_play_show(show_name);
	SleepUntil([| not composer_show_is_playing(show) ], 1);
end

function f_play_show_chain (shows:table, letterboxon:boolean):void
	-- play a list of compositions in a row
	for _, show in ipairs(shows) do
		f_play_show(show);
		if letterboxon == true then
			cinematic_show_letterbox_immediate(true);
		end
	end
end

-- ===============================================================================================================================================
--## SERVER
-- ===============================================================================================================================================

-- ===============================================================================================================================================
-- CINEMATIC FUNCTIONS ===========================================================================================================================
-- ===============================================================================================================================================
function CinematicForcePlay (cinematic_name:string)
	CinematicPlay (cinematic_name, true);
end

function CinematicPlay (cinematic_name:string, forceplay)
	campaign_metagame_time_pause(true);
	
	if (isOsirisCampaignVS or campaign_metagame_enabled()) then
		SoundImpulseStartServer(TAG('sound\031_states\031_st_osiris_campaign_cinematics\031_st_osiris_campaign_cinematic_black_screen_off.sound'), nil, 1);
		print ("skipping cinematic");
		--Temporarily removing debug fade out as it is theoretically no longer necessary
		--fade_in (0,0,0,0);
		if(campaign_metagame_enabled() and cinematic_name == "cin_040_vision") then
			-- cin_040 is the only cinematic that does not fade in from script, it relies on the cinematic to do the fade in. If we're skipping cinematics,
			-- we need to handle the fade in here.
			fade_in(1,1,1,0.5 * n_fps());
		end
		
		if(campaign_metagame_enabled() and cinematic_name == "cin_135_arbiter") then
			-- cin 135 handles the zone set transition, so if we skip cinematics, we need to make sure we load the right zone set.
			switch_zone_set(ZONE_SETS.w2_campsite);
		end
		
		if(campaign_metagame_enabled() and cinematic_name == "cin_115_warden") then
			TeleportNoFX(10);
			object_teleport (SPARTANS.chief, FLAGS.fl_cutscene_cav_lookat);
			object_teleport (SPARTANS.kelly, FLAGS.fl_cutscene_cav_lookat);
			object_teleport (SPARTANS.linda, FLAGS.fl_cutscene_cav_lookat);
			object_teleport (SPARTANS.fred, FLAGS.fl_cutscene_cav_lookat);
			Sleep(1);
			object_teleport (SPARTANS.chief, FLAGS.fl_cutscene_cav_lookat);
			object_teleport (SPARTANS.kelly, FLAGS.fl_cutscene_cav_lookat);
			object_teleport (SPARTANS.linda, FLAGS.fl_cutscene_cav_lookat);
			object_teleport (SPARTANS.fred, FLAGS.fl_cutscene_cav_lookat);
			switch_zone_set(ZONE_SETS.zn_to_docks);
			Sleep(1);
			object_teleport (SPARTANS.chief, FLAGS.fl_cutscene_cav_lookat);
			object_teleport (SPARTANS.kelly, FLAGS.fl_cutscene_cav_lookat);
			object_teleport (SPARTANS.linda, FLAGS.fl_cutscene_cav_lookat);
			object_teleport (SPARTANS.fred, FLAGS.fl_cutscene_cav_lookat);
			CreateThread(BuilderCin115SafetyHack);
			Sleep(1);
			
		end
	elseif not editor_mode() or forceplay then
		--CinematicEnter(cinematic_name);
		SoundImpulseStartServer(TAG('sound\031_states\031_st_osiris_campaign_cinematics\031_st_osiris_campaign_cinematic_black_screen_off.sound'), nil, 1);
		f_play_show(cinematic_name);
		-- Fix for OSR-158595, wait a tick to prevent race condition between cinematics and potential ICS post-cinematic during a protagonist DIP.
		Sleep(1);
		--CinematicExit(cinematic_name);
	else
		print ("NOT playing cinematic '", cinematic_name, "' because it's in editor");
		print ("use CinematicForcePlay to run in editor");
	end
	
	campaign_metagame_time_pause(false);
end

function BuilderCin115SafetyHack()
	repeat
		if(current_zone_set_fully_active() ~= ZONE_SETS.zn_docks) then
			object_teleport (SPARTANS.chief, FLAGS.fl_cutscene_cav_lookat);
			object_teleport (SPARTANS.kelly, FLAGS.fl_cutscene_cav_lookat);
			object_teleport (SPARTANS.linda, FLAGS.fl_cutscene_cav_lookat);
			object_teleport (SPARTANS.fred, FLAGS.fl_cutscene_cav_lookat);
			Sleep(1);
		end
	until (current_zone_set_fully_active() == ZONE_SETS.zn_docks)
	
	object_teleport (SPARTANS.chief, FLAGS.fl_caves_tele_chief);
	object_teleport (SPARTANS.kelly, FLAGS.fl_caves_tele_kelly);
	object_teleport (SPARTANS.linda, FLAGS.fl_caves_tele_linda);
	object_teleport (SPARTANS.fred, FLAGS.fl_caves_tele_fred);
end

function CinematicEnter (cinematic_name:string):void
	-- called before cinematic starts
	print ("playing cinematic '", cinematic_name, "'");
end

function CinematicExit (cinematic_name:string):void
	-- called after cinematic ends
	print ("cinematic '", cinematic_name, "' has ended");
end


-- ===============================================================================================================================================
-- INFINITY CINEMATIC FUNCTIONS ===========================================================================================================================
-- =================================================================

function InfinityCinematicStart (cinematic:string, octopus:object)
	fade_out (0,0,0,0);
	print ("starting infinity cinematic");
	SleepUntil ([| PlayersAreAlive()], 1);
	for _,spartan in ipairs (spartans()) do
		objects_attach (octopus, "", spartan, "");
	end
	
	--start looming the next mission into memory
	LoomNextCampaignMission();
	
	CinematicPlay(cinematic, true);
	print ("cinematic ", cinematic, " done playing. loading next level");
	
end


--## CLIENT

-- ===============================================================================================================================================
-- FX FUNCTIONS ==================================================================================================================================
-- ===============================================================================================================================================

function remoteClient.cin_100_camera_fx()
  
	print ("starting screen fx");
	
    effect_attached_to_camera_new(TAG('levels\campaignworld010\w1_unconfirmed_reports\fx\cine100\distortion\lava_camera_fx.effect'));			                              

end

function remoteClient.cin_115_camera_fx()

	print ("stopping screen fx");

	effect_attached_to_camera_stop(TAG('levels\campaignworld030\w3_builder\fx\ambient_life\builder_amb_bugs.effect'));

end