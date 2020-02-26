--## SERVER

--	343	//		  												
--	343	//						Midship_Remix
--	343	//		composition name: ambient_vista																							


--//=========//	Startup Scripts	//=========////
function startup.d_midship_remix_script()
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

function startupClient.crashedDustStart()
                print ("starting dust start");
				effect_attached_to_camera_new(TAG('levels\multi\ng43r_midship_remix\fx\camera_dust_motes.effect'));
end

function startupClient.MidshipRemixMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_mp_midshipremix.sound'), nil, 1)
end