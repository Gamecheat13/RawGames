-- Copyright (c) Microsoft. All rights reserved.

--[[***************************************************************************************************************************************************
___________________________________________________________________________________________________________________________________________________
    _____                                                 __                                 __                                                    
    /    )   ,         /                                /    )                             /    )                   /   ,        ,                 
---/----/--------__---/----__----__-----------__--------\------_/_----__--_/_----__-------/---------__----__----__-/------_/_--------__----__---__-
  /    /   /   /   ) /   /   ) /   ) /   /  /___)        \     /    /   ) /    /___)     /        /   ) /   ) /   /   /   /    /   /   ) /   ) (_ `
_/____/___/___(___(_/___(___/_(___/_(___(__(___ _____(____/___(_ __(___(_(_ __(___ _____(____/___(___/_/___/_(___/___/___(_ __/___(___/_/___/_(__)_
                                 /                                                                                                                 
                             (_ /                                                                                                                  

****************************************************************************************************************************************************]]--

--## SERVER

--[[***************************************************************************************************************************************************
A Collection of Functions checking specified single or combinations of World Persistence System Keys, and setting Dialog State Table Keys as a result
*******************************************************************************************************************************************************
]]--

function DialogueStateConditionsCheck()
	if DialogueState_debug == 1 then
		print ("World Persistence Keys Updated- Refreshing Dialogue State Conditions Check!");
	end

--CURRENTLY NOT USING DUE TO CAMPAIGN UPDATES
--	ProgressPlayerThreat() --Player Threat based on overall Open World Content Completion

--CURRENTLY NOT USING DUE TO CAMPAIGN/WORLD STRUCTURE UPDATES
--	ProgressDominionEngagement() --Current-Dominion Progress based on completed content within each individual Dominion

--CURRENTLY NOT USING DUE TO CAMPAIGN UPDATES
--	ProgressCampaign() --Overall Campaign Progress based on completion of Major campaign milestones across all Dominions

	ProgressLocalMissions() --Local Progress within specific missions, based on mission objective keys, to drive filtering Bespoke AIVO lines requested by Narrative

end


--[[
 ,ggggggggggg,                                                ,ggggggggggggggg                                            
dP"""88""""""Y8,dPYb,                                        dP""""""88"""""",dPYb,                                  I8   
Yb,  88      `8IP'`Yb                                        Yb,_    88      IP'`Yb                                  I8   
 `"  88      ,8I8  8I                                         `""    88      I8  8I                               88888888
     88aaaad8P"I8  8'                                                88      I8  8'                                  I8   
     88"""""   I8 dP   ,gggg,gg gg     gg  ,ggg,   ,gggggg,          88      I8 dPgg,   ,gggggg,  ,ggg,    ,gggg,gg  I8   
     88        I8dP   dP"  "Y8I I8     8I i8" "8i  dP""""8I          88      I8dP" "8I  dP""""8I i8" "8i  dP"  "Y8I  I8   
     88        I8P   i8'    ,8I I8,   ,8I I8, ,8I ,8'    8I    gg,   88      I8P    I8 ,8'    8I I8, ,8I i8'    ,8I ,I8,  
     88       ,d8b,_,d8,   ,d8b,d8b, ,d8I `YbadP',dP     Y8,    "Yb,,8P     ,d8     I8,dP     Y8,`YbadP',d8,   ,d8b,d88b, 
     88       8P'"Y8P"Y8888P"`YP""Y88P"88888P"Y888P      `Y8      "Y8P'     88P     `Y8P      `Y888P"Y88P"Y8888P"`Y8P""Y8 
                                     ,d8I'                                                                                
                                   ,dP'8I                                                                                 
                                  ,8"  8I                                                                                 
                                  I8   8I                                                                                 
                                  `8, ,8I                                                                                 
                                   `Y8P"                                                                                                                                 ]]--
function ProgressPlayerThreat()
	if DialogueState_debug == 1 then
		print("  - running 'player threat' Dialogue State Condition tests...");
	end
	--GLOBAL PLAYER CONTENT ENGAGEMENT CONDITION CHECKS TO SET DIALOGUE STATE TABLE VALUES
	--	!!!Condition Tests Incoming!!!
end


--[[
 ,gggggggggggg,                                                                                ,ggggggggggg,                                                               
dP"""88""""""Y8b,                                                                             dP"""88""""""Y8,                                                             
Yb,  88       `8b,                                                                            Yb,  88      `8b                                                             
 `"  88        `8b                             gg                gg                            `"  88      ,8P                                                             
     88         Y8                             ""                ""                                88aaaad8P"                                                              
     88         d8 ,ggggg,   ,ggg,,ggg,,ggg,   gg   ,ggg,,ggg,   gg    ,ggggg,   ,ggg,,ggg,        88"""",gggggg,   ,ggggg,   ,gggg,gg  ,gggggg,  ,ggg,    ,g,      ,g,    
     88        ,8PdP"  "Y8gg,8" "8P" "8P" "8,  88  ,8" "8P" "8,  88   dP"  "Y8gg,8" "8P" "8,       88    dP""""8I  dP"  "Y8ggdP"  "Y8I  dP""""8I i8" "8i  ,8'8,    ,8'8,   
     88       ,8Pi8'    ,8I I8   8I   8I   8I  88  I8   8I   8I  88  i8'    ,8I I8   8I   8I       88   ,8'    8I i8'    ,8Ii8'    ,8I ,8'    8I I8, ,8I ,8'  Yb  ,8'  Yb  
     88______,dP,d8,   ,d8',dP   8I   8I   Yb_,88,,dP   8I   Yb_,88,,d8,   ,d8',dP   8I   Yb,      88  ,dP     Y8,d8,   ,d8,d8,   ,d8I,dP     Y8,`YbadP',8'_   8),8'_   8) 
    888888888P" P"Y8888P"  8P'   8I   8I   `Y8P""Y8P'   8I   `Y8P""YP"Y8888P"  8P'   8I   `Y8      88  8P      `YP"Y8888P" P"Y8888P"888P      `Y888P"Y88P' "YY8P8P' "YY8P8P
                                                                                                                                  ,d8I'                                    
                                                                                                                                ,dP'8I                                     
                                                                                                                               ,8"  8I                                     
                                                                                                                               I8   8I                                     
                                                                                                                               `8, ,8I                                     
                                                                                                                                `Y8P"                                    ]]--
function ProgressDominionEngagement()
	DominionGreen();
	DominionYellow();
	DominionRed();
end

function DominionGreen()
	if DialogueState_debug == 1 then
		print("  - running 'Dominion Progress' Dialogue State Condition tests: GREEN dominion...");
	end
	--GREEN DOMINION PROGRESS CONDITION CHECKS TO SET DIALOGUE STATE TABLE VALUES
	--	!!!Condition Tests Incoming!!!
end

function DominionYellow()
	if DialogueState_debug == 1 then
		print("  - running 'Dominion Progress' Dialogue State Condition tests: YELLOW dominion...");
	end
	--YELLOW DOMINION PROGRESS CONDITION CHECKS TO SET DIALOGUE STATE TABLE VALUES
	--	!!!Condition Tests Incoming!!!
end

function DominionRed()
	if DialogueState_debug == 1 then
		print("  - running 'Dominion Progress' Dialogue State Condition tests: RED dominion...");
	end
	--RED DOMINION PROGRESS CONDITION CHECKS TO SET DIALOGUE STATE TABLE VALUES
	--	!!!Condition Tests Incoming!!!
end


--[[
--     ,gggg,                                                                                   ,ggggggggggg,                                                               
--   ,88"""Y8b,                                                                                dP"""88""""""Y8,                                                             
--  d8"     `Y8                                                                                Yb,  88      `8b                                                             
-- d8'   8b  d8                                                   gg                            `"  88      ,8P                                                             
--,8I    "Y88P'                                                   ""                                88aaaad8P"                                                              
--I8'           ,gggg,gg  ,ggg,,ggg,,ggg,  gg,gggg,     ,gggg,gg  gg    ,gggg,gg  ,ggg,,ggg,        88"""",gggggg,   ,ggggg,   ,gggg,gg  ,gggggg,  ,ggg,    ,g,      ,g,    
--d8           dP"  "Y8I ,8" "8P" "8P" "8, I8P"  "Yb   dP"  "Y8I  88   dP"  "Y8I ,8" "8P" "8,       88    dP""""8I  dP"  "Y8ggdP"  "Y8I  dP""""8I i8" "8i  ,8'8,    ,8'8,   
--Y8,         i8'    ,8I I8   8I   8I   8I I8'    ,8i i8'    ,8I  88  i8'    ,8I I8   8I   8I       88   ,8'    8I i8'    ,8Ii8'    ,8I ,8'    8I I8, ,8I ,8'  Yb  ,8'  Yb  
--`Yba,,_____,d8,   ,d8b,dP   8I   8I   Yb,I8 _  ,d8',d8,   ,d8b_,88,,d8,   ,d8I,dP   8I   Yb,      88  ,dP     Y8,d8,   ,d8,d8,   ,d8I,dP     Y8,`YbadP',8'_   8),8'_   8) 
--  `"Y888888P"Y8888P"`Y8P'   8I   8I   `YPI8 YY88888P"Y8888P"`Y8P""YP"Y8888P"888P'   8I   `Y8      88  8P      `YP"Y8888P" P"Y8888P"888P      `Y888P"Y88P' "YY8P8P' "YY8P8P
--                                         I8                               ,d8I'                                                  ,d8I'                                    
--                                         I8                             ,dP'8I                                                 ,dP'8I                                     
--                                         I8                            ,8"  8I                                                ,8"  8I                                     
--                                         I8                            I8   8I                                                I8   8I                                     
--                                         I8                            `8, ,8I                                                `8, ,8I                                     
--                                         I8                             `Y8P"                                                  `Y8P"                                     ]]--
function ProgressCampaign()
	if DialogueState_debug == 1 then
		print("  - running 'Campaign Progress' Dialogue State Condition tests...");
	end
	--OVERALL NARRATIVE CAMPAIGN PROGRESS CONDITION CHECKS TO SET DIALOGUE STATE TABLE VALUES
	--	!!!Condition Tests Incoming!!!

end

function ProgressLocalMissions()
	if DialogueState_debug == 1 then
		print("  - running 'Local Mission Progress' Dialogue State Condition tests...");
	end
	--LOCAL MISSION PROGRESS CHECKS TO SET DIALOGUE STATE TABLE VALUES
	--Progress within individual specific missions, based on mission objective keys, to drive filtering of Bespoke AIVO lines requested by Narrative

	local local_mission_progress_map_linear:table = {
		["Dungeon-BanishedShip"]	 = {'banishedship_DeactivateCannon', 'banishedship_OverloadEngines', 'banishedship_EscapeToPelican',},
		["Dungeon-Underbelly"]		 = {'underbelly_get_index', 'underbelly_temple_terminal', 'underbelly_defeat_tremonious',},
		["poi_green_pilot_base"]	 = {'pilotbase_terminal', 'pilotbase_murdergate', 'pilotbase_dock_terminal',},
		["poi_green_prison"]		 = {'pris_locate_signal_1', 'pris_end_lockdown', 'pris_enter_prison', 'pris_defeat_chak_lok', 'pris_rescue_spartan',},
		["poi_green_refinery"]		 = {'refine_descend', 'refine_com_room_return', 'refine_defeat_bassman',},
--		["poi_forerunner_dallas"]	 = {'dallas_retrieve_weapon',},
--		["poi_green_spire"]			 = {'green_spire_shutdown',},
--		["poi_forerunner_houston"]	 = {'houston_nexus_terminal_end',},
--		["poi_yellow_spire"]		 = {'yellow_spire_enter',},
		["poi_forerunner_austin"]	 = {'austin_invisible_chapel_split', 'austin_activate_lift', 'austin_invisible_gravlift_b_plinth', 'austin_escape_dungeon',},
		["poi_boss_hq_interior"]	 = {'boss_hq_interior_challenge_01', 'boss_hq_interior_challenge_02', 'boss_hq_interior_reach_03', 'boss_hq_interior_freedom',},
		["poi_cortana_palace"]		 = {'cortana_palace_dropsite_terminal', 'cortana_palace_atrium_exitdoor', 'cortana_palace_retrieve_weapon', 'cortana_palace_get_to_boss', 'cortana_palace_stop_boss',},
		["poi_outpost_bonobo"]		 = {'bonobo_ClearPath', 'bonobo_switch_hack', 'bonobo_destroy_power',},
	}

	local local_mission_progress_map_nonlinear:table = {
		["poi_base_aa_island"]		 = {['aa_island_gun_north'] = 1, ['aa_island_gun_east'] = 1, ['aa_island_gun_west'] = 1,},
		["poi_forerunner_tower_main_mission"] = {['tower_forerunner_north'] = 1, ['tower_forerunner_south'] = 1, ['tower_forerunner_east'] = 1, ['tower_forerunner_west'] = 1,},
		["poi_outpost_mandrill"]	 = {['mandrill_Investigate'] = 1, ['mandrill_DisableCrane'] = 1, ['mandrill_TransportDestroy'] = 1, ['mandrill_Silo01'] = 1, ['mandrill_Silo02'] = 1,},
		["poi_outpost_silverback"]	 = {['silverback_Silo01'] = 1, ['silverback_Silo02'] = 1, ['silverback_Silo03'] = 1, ['silverback_Silo04'] = 1, ['silverback_RepairBay01'] = 1, ['silverback_RepairBay02'] = 1,},
		["poi_outpost_baboon"]		 = {['baboon_generator01'] = 1, ['baboon_generator02'] = 1, ['baboon_generator03'] = 1, ['baboon_generator04'] = 1,},
		["poi_outpost_marmoset"]	 = {['marmoset_AmmoDump01'] = 1, ['marmoset_AmmoDump02'] = 1, ['marmoset_AmmoDump03'] = 1,},
		["poi_outpost_gibbon"]		 = {['gibbon_Silo01'] = 0.5, ['gibbon_Silo02'] = 0.5, ['gibbon_Silo03'] = 0.5, ['gibbon_Silo04'] = 0.5, ['gibbon_Silo05'] = 0.5, ['gibbon_RepairBay01'] = 0.5, ['gibbon_RepairBay02'] = 0.5, ['gibbon_RepairBay03'] = 0.5, ['gibbon_RepairBay04'] = 1,},
		["poi_outpost_howler"]		 = {['howler_FreeMarine01'] = 1, ['howler_FreeMarine02'] = 1, ['howler_FreeMarine03'] = 1, ['howler_FreeVIP'] = 1,},

		--FOBs tracked as progress towards all captured (14)
		["poi_unsc_fob"]			 = {['poi_fob_aspen_capture'] = 1, ['poi_fob_birch_capture'] = 1, ['poi_fob_cherry_capture'] = 1, ['poi_fob_dogwood_capture'] = 1, ['poi_fob_elm_capture'] = 1, ['poi_fob_maple_capture'] = 1, ['poi_fob_oak_capture'] = 1, ['poi_fob_palm_capture'] = 1, ['poi_fob_pecan_capture'] = 1, ['poi_fob_pine_capture'] = 1, ['poi_fob_redwood_capture'] = 1, ['poi_fob_sequoia_capture'] = 1, ['poi_fob_spruce_capture'] = 1, ['poi_fob_willow_capture'] = 1,},
	}

	--Iterate over the list of tracked objectives for each LINEAR Mission, to check which are completed and store the highest valid value of any completed objectives
	for poi_context, objectiveChecks in hpairs(local_mission_progress_map_linear) do
		local poi_context_string = poi_context
		if type(poi_context) == "ui64" then
			poi_context_string = Persistence_GetStringIdFromKey(poi_context)
		end
		
		local progressKey = nil;

		if ow_poi_dialogue_context_map[poi_context] ~= nil then
			progressKey = ow_poi_dialogue_context_map[poi_context].progress;
		elseif ow_poi_dialogue_context_persKey_aliases[poi_context] ~= nil then
			local progressKeyAlias = ow_poi_dialogue_context_persKey_aliases[poi_context];
			progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
		elseif ow_poi_dialogue_context_aliases[poi_context] ~= nil then
			local progressKeyAlias = ow_poi_dialogue_context_aliases[poi_context];
			progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
		end

		if progressKey == nil then
			if DialogueState_debug == 1 then
				print ("No Dialogue State Key defined for POI/Mission '",poi_context,"'.  Not updating POI Dialogue Local Progress Keys.");
			end
		else
			local progressValue = GetDialogueState(progressKey);
			local highestValidValue = 0
			local highestValidObjective = 0
			for value, objective in hpairs(objectiveChecks) do
				if MissionIsObjectiveComplete(Persistence_TryCreateKeyFromString(objective)) == true then
					if DialogueState_debug == 1 then
					--	print("* ",poi_context_string,": Objective '",objective,"' COMPLETE! Key",progressKey," valid value of ",value," *") --comment out when not testing
					end
					if value > highestValidValue then
						highestValidValue = value
					end
				else
					if DialogueState_debug == 1 then
					--	print("- ",poi_context_string,": Objective '",objective,"' incomplete (",StateKeyCheck(objective),"). Value ",value," invalid for Key ",progressKey,".") --comment out when not testing
					end
				end
			end
			
		--This is just for reporting the highest value and which objective it belongs to after the above crawl
			highestValidObjective = objectiveChecks[highestValidValue];
			if highestValidValue > 0 then
				if DialogueState_debug == 1 then
				--	print("# "poi_context_string,": Furthest complete objective: '",highestValidObjective,"'. Value for ",progressKey," is ",highestValidValue,".") --comment out when not testing
				end
			else
				if DialogueState_debug == 1 then
				--	print("o ",poi_context_string,": No tracked objectives completed. No Valid value for Key '",progressKey,"'.") --comment out when not testing
				end
			end
	
		--Now compare current value of the relevant Progress Key to what is appropriate based on the highest value complete objective from above.
			--If objectives completed are not reflected in progress, then update it to the highest value objective!
			if progressValue < highestValidValue then
				if DialogueState_debug == 1 then
					print("* ",poi_context_string,": Objective '",highestValidObjective,"' COMPLETE! Highest value for '",progressKey,"' is",highestValidValue,".")
				--	print("Setting Key '",progressKey,"' from ",progressValue," to ",highestValidValue,".") --comment out when not testing
				end
				if type(poi_context) == "ui64" then
					SetPoiDialogueProgress_from_Key_Absolute(poi_context, highestValidValue, "conditions_check");
				else
					SetPoiDialogueProgress_Absolute(poi_context, highestValidValue, "conditions_check");
				end
			--If it's already set appropriately then leave it silently alone!
			elseif progressValue == highestValidValue then
				if DialogueState_debug == 1 then
				--	print(poi_context_string,": Key",progressKey," value:",progressValue,", MATCHES ",highestValidValue,". '",highestValidObjective,"' already tracked!") --comment out when not testing
				end
			--It might be higher than is appropriate, because objectives could have changed or they were done and are now reset for a replay, so set them to the highest valid value or reset
			elseif progressValue > highestValidValue then
				if highestValidValue > 0 then
					if DialogueState_debug == 1 then
						print("! ",poi_context_string,": Objective '",highestValidObjective,"' complete. Value",progressValue,"for '",progressKey,"' above valid ",highestValidValue,".")
					--	print("Setting Key '",progressKey,"' from ",progressValue," to ",highestValidValue,".") --comment out when not testing
					end
					if type(poi_context) == "ui64" then						
						SetPoiDialogueProgress_from_Key_Absolute(poi_context, highestValidValue, "conditions_check");
					else
						SetPoiDialogueProgress_Absolute(poi_context, highestValidValue, "conditions_check");
					end
				else
					if DialogueState_debug == 1 then
						print("! ",poi_context_string,": All tracked objectives incomplete. Value",progressValue,"for '",progressKey,"' above valid ",highestValidValue,".")
					end
					if type(poi_context) == "ui64" then						
						SetPoiDialogueProgress_from_Key_Reset(poi_context, "conditions_check");
					else
						SetPoiDialogueProgress_Reset(poi_context, "conditions_check");
					end
				end
			end
		end
	end

	--Now, Iterate over the list of tracked objectives for each NON-LINEAR Mission, to check which are completed and store the combined value of any completed objectives
	for poi_context, objectiveChecks in hpairs(local_mission_progress_map_nonlinear) do
		local poi_context_string = poi_context
		if type(poi_context) == "ui64" then
			poi_context_string = Persistence_GetStringIdFromKey(poi_context)
		end
		
		local progressKey = nil;

		if ow_poi_dialogue_context_map[poi_context] ~= nil then
			progressKey = ow_poi_dialogue_context_map[poi_context].progress;
		elseif ow_poi_dialogue_context_persKey_aliases[poi_context] ~= nil then
			local progressKeyAlias = ow_poi_dialogue_context_persKey_aliases[poi_context];
			progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
		elseif ow_poi_dialogue_context_aliases[poi_context] ~= nil then
			local progressKeyAlias = ow_poi_dialogue_context_aliases[poi_context];
			progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
		end

		if progressKey == nil then
			if DialogueState_debug == 1 then
				print ("No Dialogue State Key defined for POI/Mission '",poi_context,"'.  Not updating POI Dialogue Local Progress Keys.");
			end
		else
			local progressValue = GetDialogueState(progressKey);
			local totalValidObjectives = 0
			local totalValidValue = 0
			for objective, value in hpairs(objectiveChecks) do
				if MissionIsObjectiveComplete(Persistence_TryCreateKeyFromString(objective)) == true then
					totalValidObjectives = (totalValidObjectives+1)
					totalValidValue = (totalValidValue+value)
					if DialogueState_debug == 1 then
					--	print("* ",poi_context_string,": Objective '",objective,"' COMPLETE! Adding",value," to '",progressKey,"' valid value.) --comment out when not testing
					end
				else
					if DialogueState_debug == 1 then
					--	print("- ",poi_context_string,": Objective '",objective,"' incomplete (",StateKeyCheck(objective),"). No valid '",progressKey,"' value.) --comment out when not testing
					end
				end
			end
	
		--This is just for reporting the total completed Objectives and Total value after the above crawl
			if totalValidObjectives > 0 then
				if DialogueState_debug == 1 then
				--	print("# ",poi_context_string,": Total completed objectives:",totalValidObjectives,". Value for ",progressKey," is ",totalValidValue,".") --comment out when not testing
				end
			else
				if DialogueState_debug == 1 then
				--	print("o ",poi_context_string,":",totalValidObjectives," tracked objectives completed. No Valid value for Key '",progressKey,"'.") --comment out when not testing
				end
			end
	
		--Now compare current value of the relevant Progress Key to what is appropriate based on the total value of all completed objectives from above.
			--If objectives completed are not reflected in progress, then update it to the total value of all objectives!
			if progressValue < totalValidValue then
				if DialogueState_debug == 1 then
					print("* ",poi_context_string,":",totalValidObjectives," tracked objectives COMPLETE! Valid value for '",progressKey,"' is",totalValidValue,".")
				--	print("Setting Key '",progressKey,"' from ",progressValue," to ",totalValidValue,".") --comment out when not testing
				end
				if type(poi_context) == "ui64" then
					SetPoiDialogueProgress_from_Key_Absolute(poi_context, totalValidValue, "conditions_check");
				else
					SetPoiDialogueProgress_Absolute(poi_context, totalValidValue, "conditions_check");
				end
			--If it's already set appropriately then leave it silently alone!
			elseif progressValue == totalValidValue then
				if DialogueState_debug == 1 then
				--	print(poi_context_string,": Key",progressKey," value:",progressValue,", MATCHES ",totalValidValue,". Objectives already tracked!") --comment out when not testing
				end
			--It might be higher than is appropriate, because objectives could have changed or they were done and are now reset for a replay, so set them to the new total value or reset
			elseif progressValue > totalValidValue then
				if totalValidValue > 0 then
					if DialogueState_debug == 1 then
						print("! ",poi_context_string,":",totalValidObjectives," tracked objectives complete. Value",progressValue,"for '",progressKey,"' above valid ",totalValidValue,".")
					--	print("Setting Key '",progressKey,"' from ",progressValue," to ",totalValidValue,".") --comment out when not testing
					end
					if type(poi_context) == "ui64" then
						SetPoiDialogueProgress_from_Key_Absolute(poi_context, totalValidValue, "conditions_check");
					else
						SetPoiDialogueProgress_Absolute(poi_context, totalValidValue, "conditions_check");
					end
				else
					if DialogueState_debug == 1 then
						print("! ",poi_context_string,": All tracked objectives incomplete. Value",progressValue,"for '",progressKey,"' above valid ",totalValidValue,".")
					end
					if type(poi_context) == "ui64" then						
						SetPoiDialogueProgress_from_Key_Reset(poi_context, "conditions_check");
					else
						SetPoiDialogueProgress_Reset(poi_context, "conditions_check");
					end
				end
			end
		end
	end
end
--
--********************************************************************************************