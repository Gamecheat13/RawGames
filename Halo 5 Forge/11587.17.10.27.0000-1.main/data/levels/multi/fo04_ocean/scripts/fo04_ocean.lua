
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


function startupClient.lightning_strike()
print ("lightning go")
		repeat
			sleep_rand_s (6,20);
			print ("LIGHTINGING!!!!!");
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