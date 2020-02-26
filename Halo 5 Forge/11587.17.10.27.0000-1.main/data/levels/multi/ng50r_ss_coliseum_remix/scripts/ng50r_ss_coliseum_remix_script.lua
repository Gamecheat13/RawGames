--## SERVER

--	343	//		  												
--	343	//						Coliseum
--	343	//		composition name: ambient_vista																							


--//=========//	Startup Scripts	//=========////
function startup.d_coliseum_script()
    print ("INIT!!!");
    --CreateThread (ambient_vista);
end

--//=========//	Vignette Scripts	//=========////

--function ambient_vista():void
--	pup_vignette_enable(false);
-- print("starting timer");
--	composer_play_show("ambient_vista");
--end


--//=========//	FX Scripts	//=========////

function startup.callClient()
                print ("calling callClient");
end

--## CLIENT


function startupClient.coliseumRemixDustStart()
                print ("start space dust");
				effect_attached_to_camera_new(TAG('levels\multi\ng50r_ss_coliseum_remix\fx\camera_space_dust.effect'));
end

function startupClient.ColiseumRemixMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_mp_coliseumremix.sound'), nil, 1)
end

--//=========// Dynamic Scenarios  //=========////

function startupClient.vin_asteroids():void
                composer_play_show("vin_coliseum_remix_asteroids");
                print ("start vignette asteroids");
end


function startupClient.asteroid_loop():void
                composer_play_show("asteroid_loop");
                print ("start dynamics asteroids");
end
