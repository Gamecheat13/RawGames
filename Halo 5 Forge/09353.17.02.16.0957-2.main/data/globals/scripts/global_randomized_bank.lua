
-- Creates a special table that allows user to randomly pull values from it without repeating any values until all have been used

function CreateRandomizedBank(inputTable:table):table
	local outputTable = {
		banks = {
			{},
			{},
		},
		
		activeBank = 1,
		bankCount = 2,
		
		sequenceCount = 0,
		usedCount = 0,
	};
		
	for key,value in pairs(inputTable) do
		table.insert(outputTable.banks[outputTable.activeBank], value);
		outputTable.sequenceCount = outputTable.sequenceCount + 1;
	end
	
	outputTable.InactiveBankIndex = function()
		return (outputTable.bankCount - outputTable.activeBank) + 1;
	end;
		
	outputTable.GetNext = function()
		local randomIndex = math.random(outputTable.sequenceCount - outputTable.usedCount);
		local nextSequence = outputTable.banks[outputTable.activeBank][randomIndex];
		
		table.insert(outputTable.banks[outputTable.InactiveBankIndex()], nextSequence);
		table.remove(outputTable.banks[outputTable.activeBank], randomIndex);
		
		outputTable.usedCount = outputTable.usedCount + 1;
		
		if (outputTable.sequenceCount == outputTable.usedCount) then
			outputTable.activeBank = outputTable.InactiveBankIndex();
			outputTable.usedCount = 0;
		end
		
		return nextSequence;
	end;
		
	math.random();
	
	return outputTable;
end
