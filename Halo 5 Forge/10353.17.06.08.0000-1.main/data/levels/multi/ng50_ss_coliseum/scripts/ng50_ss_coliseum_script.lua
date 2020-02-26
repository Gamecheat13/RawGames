--## SERVER

--	343	//		  												
--	343	//						Coliseum
--	343	//		composition name: ambient_vista																							


--//=========//	Startup Scripts	//=========////
function startup.d_coliseum_script()
	CreateThread (ambient_vista);
end

--//=========//	Vignette Scripts	//=========////

function ambient_vista():void
--	pup_vignette_enable(false);
-- print("starting timer");
	composer_play_show("ambient_vista");
end

--//=========//	FX Scripts	//=========////

--## CLIENT

function startupClient.coliseumDustStart()
                print ("starting dust");
				effect_attached_to_camera_new(TAG('levels\multi\ng50_ss_coliseum\fx\camera_glow_motes.effect'));
end

function startupClient.ColiseumMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_mp_coliseum.sound'), nil, 1)
end