--## SERVER

--	343	//		  												
--	343	//						Towers
--	343	//		








--//=========//	FX Scripts	//=========////


--## CLIENT


function startupClient.towersSandStart()
                print ("starting dust");
				effect_attached_to_camera_new(TAG('levels\multi\ng20_sa_towers\fx\camera\camera_dust_sand.effect'));
end

function startupClient.TowersMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_mp_towers.sound'), nil, 1)
end
