--## SERVER

--	343	//		  												
--	343	//						Pistons Remix
--	343	//		composition name: ambient_machines																							


--//=========//	Startup Scripts	//=========////


--//=========//	Vignette Scripts	//=========////


--//=========//	FX Scripts	//=========////


function startup.ForFunOrForGlory()

	if (ForFunPrototype == true) then

		print ("Playing for Fun");
		
		fx_fire_hazard();
		fx_electrical_hazard();		
	
	else

		print ("Playing for Glory");
	
	end

end


function fx_fire_hazard()

	repeat

		sleep_s (15);

		RunClientScript ("fx_fire_jet_start");
		
		sleep_s (10);
	
		RunClientScript ("fx_fire_jet_end");
	
	until false;

end

global electrical_middle_active:number=0;

function fx_electrical_hazard()

	print ("electrical stuff");

	repeat
		
		electrical_middle_active=75;
		RunClientScript ("fx_electrical_start");
		
			while (electrical_middle_active >= 1) do
				for _, obj in ipairs (volume_return_players(VOLUMES.fx_electrical_damage_mid)) do
					 damage_object_effect(TAG('levels\multi\ng25r_ss_pistons_remixed\fx\parts\electrical_damage.damage_effect'), obj);
					 print ("electrocuting middle");
				end
				electrical_middle_active = electrical_middle_active - 1
				sleep_s (0.2);
			end	
		
		--sleep_s (15);
		
		electrical_middle_active=0;
		RunClientScript ("fx_electrical_end");
		
		sleep_s (10);
	
	until false;
		
end



--## CLIENT



--//=========//	FX Scripts	//=========////



function startupClient.pistonsRemixIce()

    print ("starting camera fx");
	effect_attached_to_camera_new(TAG('levels\multi\ng25r_ss_pistons_remixed\fx\camera\camera_ice.effect'));
	
end


function remoteClient.fx_fire_jet_start()

	print ("Starting Fire Jets");

		CreateEffectGroup(EFFECTS.fx_fun_fire_jet_01);
		CreateEffectGroup(EFFECTS.fx_fun_fire_jet_02);
		CreateEffectGroup(EFFECTS.fx_fun_fire_jet_03);
		CreateEffectGroup(EFFECTS.fx_fun_fire_jet_04);
		CreateEffectGroup(EFFECTS.fx_fun_fire_jet_05);
		CreateEffectGroup(EFFECTS.fx_fun_fire_jet_06);
		CreateEffectGroup(EFFECTS.fx_fun_fire_jet_07);

end

function remoteClient.fx_fire_jet_end()

	print ("Ending Fire Jets");
	
		StopEffectGroup(EFFECTS.fx_fun_fire_jet_01);
		StopEffectGroup(EFFECTS.fx_fun_fire_jet_02);
		StopEffectGroup(EFFECTS.fx_fun_fire_jet_03);
		StopEffectGroup(EFFECTS.fx_fun_fire_jet_04);
		StopEffectGroup(EFFECTS.fx_fun_fire_jet_05);
		StopEffectGroup(EFFECTS.fx_fun_fire_jet_06);
		StopEffectGroup(EFFECTS.fx_fun_fire_jet_07);
	
end

function remoteClient.fx_electrical_start()

		print ("starting electric death");
		CreateEffectGroup(EFFECTS.fx_electrical_middle);	
		
end

function remoteClient.fx_electrical_end()

		print ("ending electric death");
		StopEffectGroup(EFFECTS.fx_electrical_middle);		
		
end

--//=========// Dynamic Scenarios  //=========////

function startupClient.vin_iceberg_calve():void

    composer_play_show("iceberg_calve");
    print ("start iceberg calve");
	
end