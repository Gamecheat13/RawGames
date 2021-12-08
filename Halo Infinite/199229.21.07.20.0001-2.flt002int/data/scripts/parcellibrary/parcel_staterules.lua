-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

global StateRules:table = table.makePermanent
{
	rules = nil
};

function StateRules:New(initArgs:StateRulesInitArgs):table
	local newStateRules:table = ParcelParent(self);
	newStateRules.permanentTableFlag = false;
	newStateRules.rules = initArgs.rules;
	return newStateRules;
end

function StateRules:shouldStart():boolean return true; end
function StateRules:shouldStop():boolean return false; end
function StateRules:shouldEnd():boolean return false; end
function StateRules:Run():void end

function StateRules:Initialize():void

	-- Register each rule in the collection
	for _, rule:StateRule in hpairs(self.rules) do
		local triggerAt:number = 0;
		if rule.stateConditions ~= nil then
			triggerAt = triggerAt + #rule.stateConditions;
			for _, condition:StateCondition in hpairs(rule.stateConditions) do
				ParcelRegisterEvent(self, condition.event, condition.callback, condition.state,

					function(conditionMet:boolean):void
						if conditionMet == true then

							if condition.counted == false then
								rule.counter = rule.counter + 1;
								condition.counted = true;

								if rule.counter == triggerAt then
									rule.action();
								end
							end
						else

							if condition.counted == true then
								rule.counter = rule.counter - 1;
								condition.counted = false;
							end

						end
					end
				);
			end
		end
		if rule.volumeConditions ~= nil then
			triggerAt = triggerAt + #rule.volumeConditions;
			for _, condition:VolumeCondition in hpairs(rule.volumeConditions) do
				for _, player:player in ipairs(PLAYERS.active) do

					local fnCallback:ifunction = function(conditionMet:boolean):void
						if conditionMet == true then

							if condition.counted == false then
								rule.counter = rule.counter + 1;
								condition.counted = true;

								if rule.counter == triggerAt then
									rule.action();
								end
							end
						else

							if condition.counted == true then
								rule.counter = rule.counter - 1;
								condition.counted = false;
							end

						end
					end

					ParcelRegisterVolumeOnEnterEvent(self, condition.volume, condition.enteredCallback, player, fnCallback);
					ParcelRegisterVolumeOnExitEvent(self, condition.volume, condition.exitedCallback, player, fnCallback);
				end
			end
		end
	end
end
