-- Copyright (c) Microsoft. All rights reserved.
--## SERVER
--[[

sgh_interlock AcademyRace
               
I am a: (pick one)
		[ ] GLOBAL PVE SCRIPT	
		[ ] GAMETYPE SCRIPT		
		[*] LOCAL SCRIPT		- I CONTAIN LEVEL-SPECIFIC DATA FOR A GAMETYPE

--	====================================================================================
--	==								Interlock:
--	==								AcademyWeaponMapTrainer
--  ==
--  ==						see also: academy_weapon_map_trainer.lua
--	====================================================================================
--]] 

--[[
 ______     ______     ______   __  __     ______  
/\  ___\   /\  ___\   /\__  _\ /\ \/\ \   /\  == \ 
\ \___  \  \ \  __\   \/_/\ \/ \ \ \_\ \  \ \  _-/ 
 \/\_____\  \ \_____\    \ \_\  \ \_____\  \ \_\   
  \/_____/   \/_____/     \/_/   \/_____/   \/_/   
                                                   
--]]
function GetLocalAcademyWeaponMapTrainerInitArgs():AcademyWeaponMapTrainerInitArgs
	return hmake AcademyWeaponMapTrainerInitArgs
	{
		instanceName	= GetLocalAcademyWeaponMapTrainerName(),
		weaponTrainerUITAG	= TAG('ui\wpf\anubisui\hud\scripted\prototype\label.cui_screen'),
		enemyTargetTag	= TAG('objects\characters\spartans\ai\bot_prototype.character'),
	}
end

function GetLocalAcademyWeaponMapTrainerName()
	return "sgh_interlock_AcademyWeaponMapTrainer";
end

--## CLIENT

-- outline setup - here so that TagDaemon can include the tags in the module for this level
global weaponMapTrainerOutlineTypes = {
	hostile = TAG('globals\outlines\vehicle_slayer_hostile.outlinetypedefinition'),
	weapon	= TAG('globals\outlines\academy_trainer_weapon_outline.outlinetypedefinition'),
}

