-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

   --____        _      _      _______ _           
  --/ __ \      (_)    | |    |__   __(_)          
 --| |  | |_   _ _  ___| | __    | |   _ _ __  ___ 
 --| |  | | | | | |/ __| |/ /    | |  | | '_ \/ __|
 --| |__| | |_| | | (__|   <     | |  | | |_) \__ \
  --\___\_\\__,_|_|\___|_|\_\    |_|  |_| .__/|___/
                                      --| |        
                                      --|_|

global QuickTips = Parcel.MakeParcel
{
	-- General
	instanceName = "QuickTips", 
	eventManager = nil,
	complete = false,

	-- CONFIG variables are Tuning Variables meant to be an easy way to tweak behavoir of the parcels and not
	-- changed durring runtime.
	CONFIG = 
	{
		--How long will each QuickTip be displayed, in seconds.
		displayTime = 
		{
			generalTip = 8, 
			academyTip = 10,
		},
	},
	
	CONST =
	{	
		default_title = "tip_default_title",
	},

	EVENTS =
	{
		
	},
};

function QuickTips:New():table
	local newQuickTips = self:CreateParcelInstance();
	return newQuickTips;
end

function QuickTips:Initialize():void
end

function QuickTips:Run():void
end

function QuickTips:SetQuickTipsData(playerParam:player, titleParam:string, textParam:string, timeParam:number):void
	if playerParam ~= nil then 
		MPLuaCall("__OnSetQuickTip",
			playerParam,
			titleParam,  
			textParam, 
			self.CONFIG.displayTime.generalTip);
	end
end

function QuickTips:SetQuickTipsDataWithStringID(playerParam:player, titleParam:string_id, textParam:string_id, timeParam:number):void
	if playerParam ~= nil then 
		MPLuaCall("__OnSetQuickTip",
			playerParam,
			titleParam,  
			textParam, 
			timeParam);
	end
end

function QuickTips:SetQuickTipsDataWithImage(playerParam:player, titleParam:string, textParam:string, timeParam:number, frame:number):void
	if playerParam ~= nil then 
		MPLuaCall("__OnSetQuickTipWithImage",
			playerParam,
			titleParam,  
			textParam, 
			timeParam,
			frame);
	end
end

function QuickTips:SetQuickTipsDataWithInteraction(
		playerParam:player, 
		titleParam:string_id,
		textParam:string_id,
		timeParam:number,
		persistenceKey:string_id,
		codexCategory:number,
		collectibleType:number):void

	if playerParam ~= nil then 
		MPLuaCall("__OnSetQuickTipWithInteraction",
			playerParam,
			titleParam,
			textParam,
			timeParam,
			persistenceKey,
			codexCategory,
			collectibleType);
	end
end

function QuickTips:QueueQuickTipsData(playerParam:player, titleParam:string, textParam:string, timeParam:number):void
	if playerParam ~= nil then 
		MPLuaCall("__OnQueueQuickTip",
			playerParam,
			titleParam,  
			textParam, 
			timeParam);
	end
end

function QuickTips:QueueQuickTipsDataWithImage(playerParam:player, titleParam:string, textParam:string, timeParam:number, frame:number):void
	if playerParam ~= nil then 
		MPLuaCall("__OnQueueQuickTipWithImage",
			playerParam,
			titleParam, 
			textParam, 
			timeParam,
			frame);
	end
end

--example Setting Random Academy Tip
function QuickTips:DisplayAcademyTipToPlayer(playerParam:player, tipTable:table):void

	if tipTable == nil then
		return
	end

	self:SetQuickTipsData(playerParam, 
		self.CONST.default_title, 
		table.randomEntryInArray(tipTable),
		self.CONFIG.displayTime.academyTip);
end

function QuickTips:DisplayCollectibleUnlock(playerParam:player, codexTitle:string_id, codexText:string_id):void
	self:SetQuickTipsDataWithStringID(playerParam, 
		codexTitle, 
		codexText, 
		self.CONFIG.displayTime.generalTip);
end

function QuickTips:DisplayCodexUnlock(
			playerParam:player,
			codexTitle:string_id,
			codexText:string_id,
			persistenceKey:string_id,
			codexCategory:number,
			collectibleType:number):void

	self:SetQuickTipsDataWithInteraction(
		playerParam,
		codexTitle,
		codexText,
		self.CONFIG.displayTime.generalTip,
		persistenceKey,
		codexCategory,
		collectibleType);
end

function QuickTips:DisplayValorPoints(playerParam:player, amount:number, persistenceKey:string_id, collectibleType:number):void
	local valor_text = "valor_text_"
	self:SetQuickTipsDataWithInteraction(
		playerParam,
		"valor_title",
		valor_text..tostring(amount),
		self.CONFIG.displayTime.generalTip,
		persistenceKey,
		nil,
		collectibleType);
end

function QuickTips:shouldEnd():boolean
	return self.complete;
end

function QuickTips:EndShutdown():void
end

function QuickTips:Complete():void
	self.complete = true;
end

function QuickTips:ClearForAllPlayers():void
	MPLuaCall("__OnClearQuickTips", PLAYERS.active);
end

function QuickTips:ClearQuickTipDataForPlayer(playerParam:player):void
	if playerParam ~= nil then 
		MPLuaCall("__OnClearQuickTips",
			playerParam);
	end
end