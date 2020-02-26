--## SERVER

--	343	//		  												
--	343	//						Skew
--	343	//		composition name: pelican_squadron																							


--//=========//	Startup Scripts	//=========////
function startup.d_skew_script()
	CreateThread (pelican_squadron);
	CreateThread (breaching_whale);
	CreateThread (fans_comp);
	CreateThread (cable_comp);
end

--//=========//	Vignette Scripts	//=========////

function pelican_squadron():void
--	pup_vignette_enable(false);
-- print("starting timer");
	repeat																-- will call every 10 seconds, forever
		Sleep(60 * 10);
		f_play_show("pelican_squadron");
	until(false);
end

function fans_comp():void

	composer_play_show("fans_composition");
end

function cable_comp():void

	composer_play_show("environment_cables");
end


function breaching_whale():void
--	pup_vignette_enable(false);
-- print("starting timer");
	repeat																-- will call every 10 seconds, forever
		Sleep(60 * 10);
		f_play_show("breaching_whale");
	until(false);
end

--## CLIENT

function startupClient.SkewRemixMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_mp_skewremix.sound'), nil, 1)
end