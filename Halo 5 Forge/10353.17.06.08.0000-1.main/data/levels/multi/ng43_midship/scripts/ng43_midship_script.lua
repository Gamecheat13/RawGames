--## SERVER

--	343	//		  												
--	343	//						Midship
--	343	//		composition name: ambient_vista																							


--//=========//	Startup Scripts	//=========////
function startup.d_midship_script()
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

function startupClient.spaceDustStart()
                print ("starting snow start");
				effect_attached_to_camera_new(TAG('levels\multi\ng43_midship\fx\atmosphere\hanging_space_bits.effect'));
end

function startupClient.MidshipMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_mp_midship.sound'), nil, 1)
end