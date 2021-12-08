-- object tooltip_popup
-- Copyright (c) Microsoft. All rights reserved.
--## SERVER
--
REQUIRES('scripts\Helpers\QuickTipsStartup.lua');

hstructure tooltip_popup
	meta:table; -- required, must be first
	instance:luserdata; -- required, must be second
	components:userdata; --required slot for kits

	--exposed variables

	triggerType:string;					--$$ METADATA { "prettyName": "Trigger Type", "source": ["Volume", "Persistence Key Active", "Persistence Key Completed", "External Script", "Activation Function"] }
	delayedTrigger:number;				--$$ METADATA { "prettyName": "Delayed Trigger", "tooltip": "How long should it delay in seconds after getting activated.", "min": 0, "max": 20 }
	persistentTrigger:persistence_key;	--$$ METADATA { "prettyName": "Persistence Trigger Key", "tooltip": "If Persistence Key Active or Persistence Key Completed are the trigger type.  Put the key to listen to here."  }
	stringId:string;					--$$ METADATA { "prettyName": "Tooltip String ID", "tooltip": "Make sure the string ID exists in campaign_tips_widget.txt." }
	titleID:string;						--$$ METADATA { "prettyName": "Tooltip Title ID", "tooltip": "Make sure the string ID exists in campaign_tips_widget.txt." }
	tipTime:number;						--$$ METADATA { "prettyName": "Tooltip Display Time", "tooltip": "Display the tip for this long, in seconds." }
	activationFunction:string;			--$$ METADATA { "prettyName": "Activation Function", "tooltip": "If the Activation Function trigger type is used, put the name of the function here.  Think of it like a placement script."  }
	activationCountTotal:number;		--$$ METADATA { "prettyName": "Activation Count", "tooltip": "0 - infinite times, 1+ that many times.  If the Activation Count is set to 1 or another finite number, ANY of the tips triggering that share that string ID will count towards it."  }
	persistentFlag:persistence_key		--$$ METADATA { "prettyName": "Persistence Key", "tooltip": "A bool key, if marked true, will not show tip.  Will auto complete once activation count total is reached."  }
	debugPrint:boolean					--$$ METADATA { "prettyName": "Debug print", "tooltip": "."  }
	triggerCounts:number;

	keyFunction:ifunction;
	enabled:boolean;
end

global g_tooltip_triggers = {};

function tooltip_popup:init()
	if QuickTipsInstance == nil then
		startup.QuickTipsStartup();
	end

	self.enabled = true;
	
	if self.triggerType == "Volume" then
		--check early activation
		local tableOfActivationVolumes = self:GetComponentsRecursive("activation_volume");
		local earlyCheck = nil;
		for _, vol in ipairs(tableOfActivationVolumes) do
			if #ActivationVolume_GetPlayers(vol) > 0 then
				self:TriggerTooltip();
				break;
			end
		end
	elseif self.triggerType == "Persistence Key Active" or self.triggerType == "Persistence Key Completed" then
		-- Register on persistence key change.
		local keyType = Persistence_GetKeyType(self.persistentTrigger);
		self.keyFunction = function(eventArgs) -- to stop double-registers.  Kind of weird, but whatever.
			self:TooltipPersistenceTrigger(eventArgs);
		end
		if keyType == PERSISTENCE_KEY_TYPE.Bool then
			self:RegisterEventOnSelf(g_eventTypes.playerBoolStateChanged, self.keyFunction, Persistence_GetStringIdFromKey(self.persistentTrigger));
		elseif keyType == PERSISTENCE_KEY_TYPE.Byte then
			self:RegisterEventOnSelf(g_eventTypes.playerShortStateChanged, self.keyFunction, Persistence_GetStringIdFromKey(self.persistentTrigger));
		end
	elseif self.triggerType == "Activation Function" then
		-- Look up the activation function and run it.
		if not stringIsNullOrEmpty(self.activationFunction) then
			if _G[self.activationFunction] ~= nil then
				self:CreateThread(_G[self.activationFunction], self);
			end
		end
	end
	self.triggerCounts = 0;
	self.activationCountTotal = self.activationCountTotal or 0;
	self.delayedTrigger = self.delayedTrigger or 0;
	if g_tooltip_triggers[self.stringId] == nil then
		g_tooltip_triggers[self.stringId] = 0;
	end
end

function tooltip_popup:ActivationVolumeEntered()
	if self.triggerType == "Volume" then
		self:TriggerTooltip();
	end
end

function tooltip_popup:TooltipPersistenceTrigger(eventArgs)
	if self.triggerType == "Persistence Key Completed" and MissionIsObjectiveComplete(self.persistentTrigger) then
		self:TriggerTooltip();
	elseif self.triggerType == "Persistence Key Active" and MissionIsObjectiveActive(self.persistentTrigger) then
		self:TriggerTooltip();
	end
end

function tooltip_popup:TriggerTooltip()
	if not self.enabled then
		return;
	end

	if self.persistentFlag ~= nil then
		if Persistence_GetBoolKey(self.persistentFlag) == true then
			self:DebugPrint("Tooltip Kit: Persistence key for kit is true, don't show tooltip for kit:", self, self.persistentFlag);
			return; -- if the persistence key for this is already true, just don't do anything.
		end
	end

	if self.activationCountTotal == 0 or g_tooltip_triggers[self.stringId] < self.activationCountTotal then
		g_tooltip_triggers[self.stringId] = g_tooltip_triggers[self.stringId] + 1;
		self:CreateThread(self.DelayedTooltip);
	else
		self:DebugPrint("Tooltip Kit: Activation count total (", self.activationCountTotal, ") has been hit for kit:", self, self.stringId);
	end
end

function tooltip_popup:DelayedTooltip()
	if self.delayedTrigger > 0 then
		SleepSeconds(self.delayedTrigger);
	end

	-- tooltips don't currently show in faber, so turn this option on for testing.
	self:DebugPrint("Tooltip showing now: " .. self.stringId);

	-- default to just show the tooltip for everyone.  Special cases can happen later if needed.
	for _, activePlayer in ipairs(PLAYERS.active) do
		QuickTipsInstance:QueueQuickTipsData(activePlayer, self.titleID, self.stringId, self.tipTime);
	end

	if self.persistentFlag ~= nil and self.activationCountTotal == g_tooltip_triggers[self.stringId] then
		Persistence_SetBoolKey(self.persistentFlag, true); -- auto complete the persistence key if you have one.
	end

end

function tooltip_popup:Disable():void
	self.enabled = false;
end

function tooltip_popup:DebugPrint(...)
	if self.debugPrint then -- tooltips don't currently show in faber, so turn this option on for testing.
		print(...);
	end
end

-- activationFunction example

function testTooltipPlacement(tooltip)
	SleepSeconds(10)
	tooltip:TriggerTooltip();
end