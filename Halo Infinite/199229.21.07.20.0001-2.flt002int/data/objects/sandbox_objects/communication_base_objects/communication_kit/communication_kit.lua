-- object communication_kit
-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

hstructure communication_kit
	meta:table; -- required, must be first
	instance:luserdata; -- required, must be second
	components:userdata; -- required slot for kits
end

function communication_kit:init():void
	-- link objects on their assigned channels
	for _, comp in kit_pairs(self) do
		if type(comp) == "struct" then
			if comp.SetReceivingChannel ~= nil then -- base comm object
				if comp.assignedChannels == nil then
					comp.assignedChannels = {};
				end
				comp.parentKit = self;

				self:LinkOnChannel(comp.powerChannel, commObjectChannelsEnum.power, comp);
				self:LinkOnChannel(comp.controlChannel, commObjectChannelsEnum.control, comp);
				self:LinkOnChannel(comp.ownershipChannel, commObjectChannelsEnum.ownership, comp);
				self:LinkOnChannel(comp.objectRelayChannel, commObjectChannelsEnum.relayObject, comp);
				
			elseif comp.LinkObjectsToParentKit ~= nil then -- comm group
				comp:LinkObjectsToParentKit(self);
			end
		end
	end
end

function communication_kit:LinkOnChannel(channelName:string, channel:number, downstreamObject:any):void
	if self.IsValidChannel(channelName) == true then
		local upstreamObject:any = self.components[channelName];

		if upstreamObject ~= nil then
			downstreamObject:SetReceivingChannel(channel, upstreamObject);
		else
			print("Comm Kit: there is no upstream object in the kit that matches the object name ", channelName, self);
		end
	end
end

function communication_kit.IsValidChannel(channelName:string):boolean
	return channelName ~= nil and channelName ~= "";
end