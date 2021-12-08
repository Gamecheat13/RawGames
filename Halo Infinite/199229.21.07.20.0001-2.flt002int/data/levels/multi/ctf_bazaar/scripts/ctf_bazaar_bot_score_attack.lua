-- Copyright (c) Microsoft. All rights reserved.
--## SERVER
--[[

ctf_bazaar Bot Score Attack
               
I am a: (pick one)
		[ ] GLOBAL PVE SCRIPT	
		[ ] GAMETYPE SCRIPT		
		[*] LOCAL SCRIPT		- I CONTAIN LEVEL-SPECIFIC DATA FOR A GAMETYPE

--	====================================================================================
--	==								Bazaar:
--	==								AcademyBotScoreAttack
--  ==
--  ==						see also: academy_bot_score_attack.lua
--	====================================================================================
--]] 

--[[
 ______     ______     ______   __  __     ______  
/\  ___\   /\  ___\   /\__  _\ /\ \/\ \   /\  == \ 
\ \___  \  \ \  __\   \/_/\ \/ \ \ \_\ \  \ \  _-/ 
 \/\_____\  \ \_____\    \ \_\  \ \_____\  \ \_\   
  \/_____/   \/_____/     \/_/   \/_____/   \/_/   
                                                   
--]]
function GetLocalAcademyBotScoreAttackInitArgs():AcademyBotScoreAttackInitArgs
	return hmake AcademyBotScoreAttackInitArgs
	{
		instanceName	= GetLocalAcademyBotScoreAttackName(),	
		academyUITag = TAG('ui\wpf\anubisui\hud\scripted\prototype\label.cui_screen'),	
	}
end

function GetLocalAcademyBotScoreAttackName()
	return "ctf_bazaar_AcademyBotScoreAttack";
end

--## CLIENT