--	343	//		  												
--	343	//						Towers
--	343	//		

global var_dot_volume_sleep:number=0.15;

--## SERVER

--//=========//	Gameplay Scripts	//=========////

function startup.gameplay_rig_init()
	CreateThread (dot_volume_lava_01);
	CreateThread (dot_volume_lava_02);
	CreateThread (dot_volume_lava_03);
	CreateThread (dot_volume_lava_04);
	CreateThread (dot_volume_lava_05);
	CreateThread (dot_volume_lava_06);
	CreateThread (dot_volume_lava_07);
	CreateThread (dot_volume_lava_08);
	
	print ("START LAVA DoTs");
end


--//=========//	Vignette Scripts	//=========////


function dot_volume_lava_01():void
	while (true) do
		for _, obj in ipairs (volume_return_players(VOLUMES.lava_01)) do
			damage_object_effect_with_suicide(TAG('globals\damage_effects\hs_fire_damage.damage_effect'), obj);
			print ("lava_01");
		end
		sleep_s(var_dot_volume_sleep);
	end
end

 function dot_volume_lava_02():void
	 while (true) do
		 for _, obj in ipairs (volume_return_players(VOLUMES.lava_02)) do
			 damage_object_effect_with_suicide(TAG('globals\damage_effects\hs_fire_damage.damage_effect'), obj);
			 print ("lava_02");
		 end
		 sleep_s(var_dot_volume_sleep);
	 end
 end
 
 
 function dot_volume_lava_03():void
	 while (true) do
		 for _, obj in ipairs (volume_return_players(VOLUMES.lava_03)) do
			 damage_object_effect_with_suicide(TAG('globals\damage_effects\hs_fire_damage.damage_effect'), obj);
			 print ("lava_03");
		 end
		 sleep_s(var_dot_volume_sleep);
	 end
 end
 
 function dot_volume_lava_04():void
	 while (true) do
		 for _, obj in ipairs (volume_return_players(VOLUMES.lava_04)) do
			 damage_object_effect_with_suicide(TAG('globals\damage_effects\hs_fire_damage.damage_effect'), obj);
			 print ("lava_04");
		 end
		 sleep_s(var_dot_volume_sleep);
	 end
 end
 
 function dot_volume_lava_05():void
	 while (true) do
		 for _, obj in ipairs (volume_return_players(VOLUMES.lava_05)) do
			 damage_object_effect_with_suicide(TAG('globals\damage_effects\hs_fire_damage.damage_effect'), obj);
			 print ("lava_05");
		 end
		 sleep_s(var_dot_volume_sleep);
	 end
end	 
	 
	  function dot_volume_lava_06():void
	 while (true) do
		 for _, obj in ipairs (volume_return_players(VOLUMES.lava_06)) do
			 damage_object_effect_with_suicide(TAG('globals\damage_effects\hs_fire_damage.damage_effect'), obj);
			 print ("lava_06");
		 end
		 sleep_s(var_dot_volume_sleep);
	 end
end	 

 function dot_volume_lava_07():void
	 while (true) do
		 for _, obj in ipairs (volume_return_players(VOLUMES.lava_07)) do
			 damage_object_effect_with_suicide(TAG('globals\damage_effects\hs_fire_damage.damage_effect'), obj);
			 print ("lava_07");
		 end
		 sleep_s(var_dot_volume_sleep);
	 end
end	 

 function dot_volume_lava_08():void
	 while (true) do
		 for _, obj in ipairs (volume_return_players(VOLUMES.lava_08)) do
			 damage_object_effect_with_suicide(TAG('globals\damage_effects\hs_fire_damage.damage_effect'), obj);
			 print ("lava_00");
		 end
		 sleep_s(var_dot_volume_sleep);
	 end
end	 



--//=========//	FX Scripts	//=========////

function startup.callClient()
                print ("calling callClient");
                --RunClientScript ("towersLavaStart");
end


--## CLIENT


function startupClient.towersLavaStart()
                print ("starting camera fx");
				effect_attached_to_camera_new(TAG('levels\multi\ng20r_sa_towers_remix\fx\camera\embers_lava_camera.effect'));
end

function startupClient.TowersRemixMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_mp_towersremix.sound'), nil, 1)
end

--//=========// Dynamic Scenarios  //=========////

function startupClient.vin_towers_lava():void

    composer_play_show("lava_loop");
    print ("start lava");
end

function startupClient.vin_towers():void

    composer_play_show("falling_lava_rocks");
    print ("start rocks");
end
