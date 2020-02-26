--## SERVER

--	343	//		  												
--	343	//						Pistons
--	343	//		composition name: ambient_machines																							


--//=========//	Startup Scripts	//=========////
function startup.d_pistons_script()
	CreateThread (ambient_machines);
	--CreateThread (small_pistons_loop);
	--kill_volume_disable(VOLUMES.kill_red_door_large_triggervolume);
	--kill_volume_disable(VOLUMES.kill_red_door_small_triggervolume);
	--kill_volume_disable(VOLUMES.kill_blue_door_large_triggervolume);
	--kill_volume_disable(VOLUMES.kill_blue_door_small_triggervolume);
end

--//=========//	Vignette Scripts	//=========////

function ambient_machines():void
--	pup_vignette_enable(false);
-- print("starting timer");
	composer_play_show("ambient_machines");
end


--function small_pistons_loop():void
--	pup_vignette_enable(false);
 --print("small pistons loop");
	--composer_play_show("vin_static_pistons");
--end


--## CLIENT

function startupClient.PistonsMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_mp_pistons.sound'), nil, 1)
end


