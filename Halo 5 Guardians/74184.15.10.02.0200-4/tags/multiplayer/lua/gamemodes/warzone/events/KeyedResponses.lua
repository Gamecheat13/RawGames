-- Copyright (c) Microsoft. All rights reserved.

keyedResponseConfigs = 
{
	countdownResponse = 
	{
		select = OnMiniBossGroupCountdown:Select(),
		predicate = function(squadId, secondsRemaining) return CountdownResponsePredicate(squadId, secondsRemaining) end,
		target = ProximityPlayers,
	},
}

function StoreKeyedResponse(miniBossDefinition, emitDefinition, responseType, responseGroupKey, responseKey, response)

	local responseDefinition = emitDefinition:Response(response);

	if (responseGroupKey ~= nil) then
		if (responseKey ~= nil) then
			_G[miniBossDefinition.label .. '_' .. responseType .. '_' .. tostring(responseGroupKey) .. '_' .. tostring(responseKey)] = responseDefinition;
		else
			_G[miniBossDefinition.label .. '_' .. responseType .. '_' .. tostring(responseGroupKey)] = responseDefinition;
		end
	else
		_G[miniBossDefinition.label .. '_' .. responseType] = responseDefinition;
	end

end

function ProcessKeyedResponse(miniBossDefinition, responseConfig, responseGroupKey)

	local selectDefinition = responseConfig.select:Add(responseConfig.predicate(miniBossDefinition.label, responseGroupKey));
	return selectDefinition:Target(responseConfig.target);

end

function ProcessKeyedDefinition(miniBossDefinition, key, value)

	local responseConfig = keyedResponseConfigs[key];

	if (responseConfig == nil) then
		return;
	end

	if IsResponse(value) then

		local emitDefinition = ProcessKeyedResponse(miniBossDefinition, responseConfig, nil);
		StoreKeyedResponse(miniBossDefinition, emitDefinition, key, nil, nil, value);
			
	else

		for responseGroupKey, subValue in pairs(value) do

			local emitDefinition = ProcessKeyedResponse(miniBossDefinition, responseConfig, responseGroupKey);

			if IsResponse(subValue) then

				StoreKeyedResponse(miniBossDefinition, emitDefinition, key, responseGroupKey, nil, subValue);

			else

				for responseKey, response in ipairs(subValue) do
					StoreKeyedResponse(miniBossDefinition, emitDefinition, key, responseGroupKey, responseKey, response);
				end

			end
		end
	end
end

if minibossDefinitions ~= nil then
	for _, definition in ipairs(minibossDefinitions) do

		local responseTable = definition["responses"];
		if responseTable ~= nil then
			for key, value in pairs(responseTable) do
				ProcessKeyedDefinition(definition, key, value);
			end
		end

	end
end
