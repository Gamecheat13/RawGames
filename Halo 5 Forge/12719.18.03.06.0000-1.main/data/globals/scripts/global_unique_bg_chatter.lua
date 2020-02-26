--## SERVER


--[========[
-- EXAMPLE INPUT TABLE FORMAT:

bankData = {
    {	-- Sequence 1
		name = "",
		OnStart = function() end,
		lines = {
			{		-- Sequence 1, Line 1
				character = 0,
				tag = TAG(''),
				text = "",
				OnStart = function() end,
				OnPlay = function() end,
				OnFinish = function() end,
			},
			{	-- Sequence 1, Line 2
				character = 0,
				tag = TAG(''),
				text = "",
				OnStart = function() end,
				OnPlay = function() end,
				OnFinish = function() end,
			},
		},
		OnFinish = function() end,
	},
    {	-- Sequence 2
		name = "",
		OnStart = function() end,
		lines = {
			{		-- Sequence 2, Line 1
				character = 0,
				tag = TAG(''),
				text = "",
				OnStart = function() end,
				OnPlay = function() end,
				OnFinish = function() end,
			},
		},
		OnFinish = function() end,
	},
};


-- etc...
--]========]

--[===[
-- HOW TO USE:

-- To CREATE A BANK object:

	local yourBank = NarrativeLoopBank.Create( yourTable );

-- To PLAY the NEXT sequence:

	NarrativeLoopBank.PlayNext( yourBank );

-- or if you need to define a specific character for universal lines:

	NarrativeLoopBank.PlayNext( yourBank, specificCharacter );

--]===]
		

global NarrativeLoopBank = {};

function NarrativeLoopBank.ForceSkipNext(loopBank:table):void
	loopBank.timesToSkip = (loopBank.timesToSkip == 0 and 1) or loopBank.timesToSkip;
end

function NarrativeLoopBank.OnFinish(loopBank:table):void
	loopBank.currentlyPlaying = false;
end

function NarrativeLoopBank.CalculateRandomSkip(loopBank:table):void
	local chance = math.random();

	if (chance <= loopBank.skipChance and chance > 0) then
		loopBank.timesToSkip = math.random(loopBank.maxSkippedInARow);
	end
end

function NarrativeLoopBank.PlayNext(loopBank:table, characterToReplaceNil:object):boolean
	if (loopBank.currentlyPlaying) then
		print("NarrativeLoopBank.PlayNext() : Fired while previous play was still running.  Call ignored.");
		return nil;
	elseif (loopBank.timesToSkip > 0) then
		--print ("loopbank is skipping");
		
		loopBank.timesToSkip = loopBank.timesToSkip - 1;
		--print ("times to skip is ", loopBank.timesToSkip);
		return false;
	else
		local nextSequence = loopBank.randomBank.GetNext();
		local sequenceIsValid = true;
		local sequenceFailedMessage = "";

		-- Load conversation-level data from next sequence
		loopBank.conversation.name = nextSequence.name;
		loopBank.conversation.localVariables.OnStart = nextSequence.OnStart;
		loopBank.conversation.localVariables.OnFinish = nextSequence.OnFinish;
		loopBank.conversation.lines = {};
	
		-- Load line-level data from next sequence
		for index,lineData in pairs(nextSequence.lines) do
			local character = (lineData.character or characterToReplaceNil);

			if (not character) then
				sequenceIsValid = false;
				sequenceFailedMessage = "NarrativeLoopBank.PlayNext() : Sequence name '" .. nextSequence.name .. "' line [" .. index .. "] had no 'character' defined, and an override was not passed to PlayNext()";
				break;
			end

			local newLine = {
				character = character,
				text = lineData.text,
				tag = lineData.tag,
				localVariables = {},
			};

			if (lineData.OnStart) then
				newLine.localVariables.OnStart = lineData.OnStart;
				newLine.OnStart = function(thisLine, thisConvo, queue, lineNumber)
					thisLine.localVariables.OnStart();
				end
			end

			if (lineData.OnPlay) then
				newLine.localVariables.OnPlay = lineData.OnPlay;
				newLine.OnPlay = function(thisLine, thisConvo, queue, lineNumber)
					thisLine.localVariables.OnPlay();
				end
			end

			if (lineData.OnFinish) then
				newLine.localVariables.OnFinish = lineData.OnFinish;
				newLine.AfterFailed = function(thisLine, thisConvo, queue, lineNumber, characterWasDead)
					thisLine.localVariables.OnFinish();

					return lineNumber + 1;
				end

				newLine.AfterPlayed = newLine.AfterFailed;
			end

			table.insert(loopBank.conversation.lines, newLine);
		end
		
		if (sequenceIsValid) then
			loopBank.currentlyPlaying = true;

			-- Play it!
			NarrativeQueue.QueueConversation(loopBank.conversation);

			-- Determine skip behavior for NEXT time PlayNext() is called
			NarrativeLoopBank.CalculateRandomSkip(loopBank);
		else
			print("NarrativeLoopBank.PlayNext() : Failed to play sequence : ", sequenceFailedMessage);
		end
	return true;
	end
end
		
function NarrativeLoopBank.Create(narrativeSequencesBank:table,
								priority:number,
								skipChance:number,
								maxSkippedInARow:number):table
	local loopBank = NarrativeLoopBank.CreateSharedBank(nil, priority, skipChance, maxSkippedInARow)
	
	loopBank.randomBank = CreateRandomizedBank(narrativeSequencesBank);
			
	return loopBank;
end



function NarrativeLoopBank.CreateSharedBank(randombank:table,
								priority:number,
								skipChance:number,
								maxSkippedInARow:number):table
	local loopBank = {
		randomBank = randombank,
		
		currentlyPlaying = false,

		skipChance = skipChance,
		maxSkippedInARow = maxSkippedInARow,
		timesToSkip = 0,
				
		conversation = {
			name = "NarrativeLoopBank.Create() : INVALID CONVO",
			Priority = function(thisConvo, queue) return priority; end,
			OnStart = function(thisConvo, queue)
				print("Narrative Bank - ", thisConvo.name);
				if (thisConvo.localVariables.OnStart) then thisConvo.localVariables.OnStart(); end
			end,
			lines = {},
			OnFinish = function(thisConvo, queue)
				if (thisConvo.localVariables.OnFinish) then thisConvo.localVariables.OnFinish(); end
				NarrativeLoopBank.OnFinish(thisConvo.localVariables.loopBank);
			end,
		},
	};

	loopBank.conversation.localVariables = { loopBank = loopBank, };
	
	--

	NarrativeLoopBank.CalculateRandomSkip(loopBank);
	
	return loopBank;
end