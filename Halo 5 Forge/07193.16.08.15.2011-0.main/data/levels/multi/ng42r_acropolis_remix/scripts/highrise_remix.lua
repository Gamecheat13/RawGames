
-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- *_*_*_*_*_*_*_ ARENA MP : HIGH RISE REMIX *_*_*_*_*_*_*_*
-- *_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*



---------------------------------------------------------------
---------------------------------------------------------------
--FX Scripts
---------------------------------------------------------------
---------------------------------------------------------------



--## SERVER

--## CLIENT

function rainStart()
                print ("starting rain");
		--		effect_attached_to_camera_new(TAG('fx\library\weather\rain_light.effect'));
			repeat
                      SleepUntil ([| volume_test_object(VOLUMES.fx_volume_norain_01, PLAYERS.local0) or volume_test_object(VOLUMES.fx_volume_norain_02, PLAYERS.local0) or volume_test_object(VOLUMES.fx_volume_norain_03, PLAYERS.local0) or volume_test_object(VOLUMES.fx_volume_norain_04, PLAYERS.local0) or volume_test_object(VOLUMES.fx_volume_norain_05, PLAYERS.local0) or volume_test_object(VOLUMES.fx_volume_norain_06, PLAYERS.local0) or volume_test_object(VOLUMES.fx_volume_norain_07, PLAYERS.local0) or volume_test_object(VOLUMES.fx_volume_norain_08, PLAYERS.local0) or volume_test_object(VOLUMES.fx_volume_norain_09, PLAYERS.local0) or volume_test_object(VOLUMES.fx_volume_norain_10, PLAYERS.local0) or volume_test_object(VOLUMES.fx_volume_norain_11, PLAYERS.local0) or volume_test_object(VOLUMES.fx_volume_norain_12, PLAYERS.local0)], 1);
                      effect_attached_to_camera_new (TAG('fx\library\weather\rain_light.effect'));
					--	print ("turning on rain for local player in middlefan");
                      SleepUntil ([| not volume_test_object(VOLUMES.fx_volume_norain_01, PLAYERS.local0) or not volume_test_object(VOLUMES.fx_volume_norain_02, PLAYERS.local0) or not volume_test_object(VOLUMES.fx_volume_norain_03, PLAYERS.local0) or not volume_test_object(VOLUMES.fx_volume_norain_04, PLAYERS.local0) or not volume_test_object(VOLUMES.fx_volume_norain_05, PLAYERS.local0) or not volume_test_object(VOLUMES.fx_volume_norain_06, PLAYERS.local0) or not volume_test_object(VOLUMES.fx_volume_norain_07, PLAYERS.local0) or not volume_test_object(VOLUMES.fx_volume_norain_08, PLAYERS.local0) or not volume_test_object(VOLUMES.fx_volume_norain_09, PLAYERS.local0) or not volume_test_object(VOLUMES.fx_volume_norain_10, PLAYERS.local0) or not volume_test_object(VOLUMES.fx_volume_norain_11, PLAYERS.local0) or not volume_test_object(VOLUMES.fx_volume_norain_12, PLAYERS.local0)], 1);
                      effect_attached_to_camera_stop (TAG('fx\library\weather\rain_light.effect'));			                              
          until false;
		  
end

function startupClient.lightning_strike()

		repeat
			sleep_s (70);
			print ("LIGHTINGING!!!!!");
			effect_new(TAG('levels\multi\ng42r_acropolis_remix\fx\lightning\lightning.effect'),EFFECTS.lightning_main);
			interpolator_start ("strike_on");
			
		

			
			
		until false;	
end
		
--function lensRain()
--			print ("enabling rain on lens");
--			
--			enable_camera_lens_dirt=true;
--			
--end

function startupClient.AcropolisRemixMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_mp_acropolisremix.sound'), nil, 1)
end