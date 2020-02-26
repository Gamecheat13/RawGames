--## SERVER

--	343	//		  												
--	343	//						Skew
--	343	//		composition name: ambient_whales																							


--//=========//	Startup Scripts	//=========////


--## CLIENT

--//=========//	Startup Scripts	//=========////
function startupClient.d_skew_script()
--//=========//	Vignette Scripts	//=========////
--	pup_vignette_enable(false);
-- print("starting timer");
	repeat																-- will call every 10 seconds, forever
		Sleep(60 * 10);
		f_play_show("ambient_whales");
	until(false);
end

function startupClient.SkewMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_mp_skew.sound'), nil, 1)
end
