
REQUIRES('globals\scripts\global_dialog.lua');

--## SERVER


-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::: Narrative Queue Public Interface :::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

-- NarrativeQueue Management
---------------------------------------------------------------------------
global NarrativeQueue:table = {
	-- Data
	instance = NarrativeQueueInstance,

	-- User Macros
	NoCharacter = NarrativeQueueInstance.NoCharacterValue,
};

-- Methods
function NarrativeQueue.Initialize():table	-- Returns handle to the NarrativeQueueInstance
	NarrativeQueue.instance:DebugPrint("NarrativeQueue.Initialize()");

	if (NarrativeQueue.locked) then
		NarrativeQueue.instance:DebugPrint("NarrativeQueue is locked.  Ignoring Initialize() call.");
		return nil;
	end

	if (NarrativeQueue.instance.updateIsRunning) then
		error("ERROR - NarrativeQueueInstance:Update() is already running.  Attempted to double-initialize the queue.");
	end

	NarrativeQueue.instance:Initialize();
	CreateThread(NarrativeQueue.instance.Update, NarrativeQueue.instance);

	return NarrativeQueue.instance;
end

function NarrativeQueue.AutoInitialize():void
	if (not NarrativeQueue.instance.isActive) then
		dprint("Auto Initializing Narrative Queue");
		NarrativeQueue.Initialize();
	end
end

function NarrativeQueue.Kill():void
	if (not NarrativeQueue.instance) then
		return;
	end

	NarrativeQueue.instance:DebugPrint("NarrativeQueue.Kill()"); 

	NarrativeQueue.instance:Kill();
end

function NarrativeQueue.GameOver():void
	NarrativeQueue.locked = true;
	NarrativeQueue.Kill();
end

-- Conversation Actions - Start/Stop
---------------------------------------------------------------------------

function NarrativeQueue.QueueConversation(conversation:table):void
	NarrativeQueue.AutoInitialize();
	NarrativeQueue.instance:DebugPrint("Attempt ::: NarrativeQueue.QueueConversation( " .. conversation.name .. " )");
	NarrativeQueue.instance:DebugPrint("NarrativeQueue.QueueConversation( " .. conversation.name .. " )");
	
	if (NarrativeQueuePrivates.ConvoHasPrivateData(conversation) and conversation.privateData.DEBUG_CONVO_QUEUED) then
		error("ERROR : attempting to queue conversation " .. (conversation.name or "<NAME WAS NIL>") .. " when it is already marked as 'queued'!");
	end

	NarrativeQueuePrivates.LateRegisterTableAsConvo(conversation);
	NarrativeQueue.instance:QueueConversation(conversation);
end

function NarrativeQueue.EndConversationEarly(conversation:table):void
	if (not NarrativeQueue.instance) then
		return;
	end

	NarrativeQueue.instance:DebugPrint("NarrativeQueue.EndConversationEarly( " .. conversation.name .. " )");

	NarrativeQueue.instance:EndConversationEarly(conversation);
end

function NarrativeQueue.InterruptConversation(conversation:table, interruptOverlapDurationSeconds:number):void
	if (not NarrativeQueue.instance) then
		return;
	end

	NarrativeQueue.instance:DebugPrint("NarrativeQueue.InterruptConversation( " .. conversation.name .. " )");

	NarrativeQueue.instance:InterruptConversation(conversation, interruptOverlapDurationSeconds);
end

function NarrativeQueue.KillConversation(conversation:table):void
	if (not NarrativeQueue.instance) then
		return;
	end

	NarrativeQueue.instance:DebugPrint("NarrativeQueue.KillConversation( " .. conversation.name .. " )");

	NarrativeQueue.instance:KillConversation(conversation);
end

function NarrativeQueue.KillAllConversationsOfType(convoType):void
	if (not NarrativeQueue.instance) then
		return;
	end

	--NarrativeQueue.instance:DebugPrint("NarrativeQueue.KillAllConversationsOfType( " .. convoType .. " )");

	NarrativeQueue.instance:KillAllConversationsOfType(convoType);
end

function NarrativeQueue.HaltAllLinesOnEmitter(conversation:table, emitter:any):void
	if (not NarrativeQueue.instance) then
		return;
	end

	NarrativeQueue.instance:HaltAllLinesOnEmitter(conversation, emitter);
end

-- Conversation Actions - Event-Based
---------------------------------------------------------------------------

function NarrativeQueue.PlayEventBasedLine(conversation:table, lineId):void
	NarrativeQueue.AutoInitialize();
	NarrativeQueue.instance:DebugPrint("Attempt ::: NarrativeQueue.PlayEventBasedLine( " .. conversation.name .. ", " .. lineId .. " )");	
	NarrativeQueue.instance:DebugPrint("NarrativeQueue.PlayEventBasedLine( " .. conversation.name .. ", " .. lineId .. " )");

	-- Just-in-time queue convo if necessary
	if (not NarrativeQueuePrivates.ConvoHasPrivateData(conversation)) then
		NarrativeQueue.QueueConversation(conversation);
	end

	NarrativeQueue.instance:PlayEventBasedLine(conversation, lineId);
end

function NarrativeQueue.EndEventBasedConversation(conversation:table):void
	NarrativeQueue.AutoInitialize();
	NarrativeQueue.instance:DebugPrint("Attempt ::: NarrativeQueue.EndEventBasedConversation( " .. conversation.name .. " )");	
	NarrativeQueue.instance:DebugPrint("NarrativeQueue.EndEventBasedConversation( " .. conversation.name .. " )");

	-- Just-in-time queue convo if necessary
	if (NarrativeQueuePrivates.ConvoHasPrivateData(conversation)) then
		NarrativeQueue.instance:EndEventBasedConversation(conversation);
	else
		NarrativeQueue.instance:DebugPrint("NarrativeQueue.EndEventBasedConversation( " .. conversation.name .. " ) - Attempted to mark a conversation as 'ending', but conversation was not queued.");
	end
end

-- Conversation Status
---------------------------------------------------------------------------

function NarrativeQueue.IsConversationValid(conversation:table):boolean
	return (conversation
		and conversation.name		and type(conversation.name) == "string"
		and conversation.Priority	and type(conversation.Priority) == "function"
		and conversation.lines		and type(conversation.lines) == "table"
		and true) or false;
end

function NarrativeQueue.HasConversationFinished(conversation:table):boolean
	return NarrativeQueuePrivates.ConvoHasCompleted(conversation);
end

function NarrativeQueue.IsConversationQueued(conversation:table):boolean
	return NarrativeQueuePrivates.ConvoHasPrivateData(conversation);
end

-- Conversation Utilities
---------------------------------------------------------------------------

function NarrativeQueue.ResolveLineCharacter(thisLine:table, thisConvo:table, queue:table, lineId)
	return (type(thisLine.character) == "function" and thisLine.character(thisLine, thisConvo, queue, lineId)) or thisLine.character;
end

function NarrativeQueue.ConversationsPlayingCount():number
	return (NarrativeQueue.instance and NarrativeQueue.instance.isActive and #NarrativeQueue.instance.playingConversations) or 0;
end

function NarrativeQueue.SetInterruptOverlapDuration(durationSeconds:number):void
	if (not NarrativeQueue.instance) then
		return;
	end

	NarrativeQueue.instance.interruptOverlapDurationSeconds = durationSeconds;
end

function NarrativeQueue.GetInterruptOverlapDuration():number
	if (not NarrativeQueue.instance) then
		print("ERROR :: GetInterruptOverlapDuration() was called while NarrativeQueue was not initialized!");
		return 0;
	end

	return NarrativeQueue.instance.interruptOverlapDurationSeconds;
end

function NarrativeQueue.PreventConversations(shouldPrevent:boolean):void
	if (not NarrativeQueue.instance) then
		return;
	end
	
	NarrativeQueue.instance.preventConversations = shouldPrevent;
end

function NarrativeQueue.IsPreventingConversations():boolean
	if (not NarrativeQueue.instance) then
		return false;
	end
	
	return NarrativeQueue.instance.preventConversations;
end

function NarrativeQueue.ForceFullCompositionPlayback(shouldForce:boolean):void
	if (not NarrativeQueue.instance) then
		return;
	end
	
	NarrativeQueue.instance.playFullCompositions = shouldForce;
end

function NarrativeQueue.IsForcingFullCompositionPlayback():boolean
	if (not NarrativeQueue.instance) then
		return false;
	end
	
	return NarrativeQueue.instance.shouldForce;
end



-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Network to Client :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

function PlayDialogFromMarkerOnSpecificClients(soundTag:tag, emitterObject:object, targetPlayer:player, markerName:string, noSubtitles:boolean, subPriority:number):void
	if(emitterObject ~= nil) then
		if (targetPlayer) then
			RunClientScript("ClientPlayDialogPlayerAtMarker", soundTag, emitterObject, targetPlayer, markerName, noSubtitles, subPriority);
		else
			RunClientScript("ClientPlayDialogAtMarker", soundTag, emitterObject, markerName, noSubtitles, subPriority);
		end
	else
		print("Invalid object passed to PlayDialogFromMarkerOnSpecificClients");
	end
end

function PlayDialogOnSpecificClients(soundTag:tag, emitterObject:object, targetPlayer:player, noSubtitles:boolean, subPriority:number):void
	if(emitterObject ~= nil) then
		if (targetPlayer) then
			RunClientScript("ClientPlayDialogPlayer", soundTag, emitterObject, targetPlayer, noSubtitles, subPriority);
		else
			RunClientScript("ClientPlayDialog", soundTag, emitterObject, noSubtitles, subPriority);
		end
	else
		if (targetPlayer) then
			RunClientScript("ClientPlayDialogNilPlayer", soundTag, targetPlayer, noSubtitles, subPriority);
		else
			RunClientScript("ClientPlayDialogNil", soundTag, noSubtitles, subPriority);
		end
	end
end


function StopDialogOnSpecificClients(soundTag:tag, emitterObject:object, targetPlayer:player):void
	if(emitterObject ~= nil) then
		if (targetPlayer) then
			print("-<|>- -<|>- ClientStopDialogPlayer()");
			RunClientScript("ClientStopDialogPlayer", soundTag, emitterObject, targetPlayer);
		else
			print("-<|>- -<|>- ClientStopDialog()");
			RunClientScript("ClientStopDialog", soundTag, emitterObject);
		end
	else
		if (targetPlayer) then
			print("-<|>- -<|>- ClientStopDialogNilPlayer()");
			RunClientScript("ClientStopDialogNilPlayer", soundTag, targetPlayer);
		else
			print("-<|>- -<|>- ClientStopDialogNil()");
			RunClientScript("ClientStopDialogNil", soundTag);
		end
	end
end


function PlayDialogFromMarkerOnClients(soundTag:tag, emitterObject:object, markerName:string, noSubtitles:boolean):void
	PlayDialogFromMarkerOnSpecificClients(soundTag, emitterObject, nil, markerName, noSubtitles);
end


function PlayDialogOnClients(soundTag:tag, emitterObject:object, noSubtitles:boolean):void
	PlayDialogOnSpecificClients(soundTag, emitterObject, nil, noSubtitles);
end

function StopDialogOnClients(soundTag:tag, emitterObject:object):void
	print("-<|>- -<|>- StopDialogOnClients()");
	StopDialogOnSpecificClients(soundTag, emitterObject, nil);
end



-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Client -side Functionality :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

--## CLIENT

-- Play Object Dialog
---------------------------------------------------------------------------

function ClientSetWwiseRtpcTo3d(emitterObject:object):void
	if (not emitterObject) then return; end

	SetObjectRTPC(emitterObject, "vo_positioning_type", 1);
end

function ClientPlayDialogObject(soundTag:tag, emitterObject:object, noSubtitles:boolean, subPriority:number):void
	ClientSetWwiseRtpcTo3d(emitterObject);

	--print("NARRATIVE CLIENT :: Playing dialog on object");
	--print("  tag:", soundTag);
	if (noSubtitles) then
		-- TODO : Replace with binding call for impulse call that does not fire subtitles
		sound_impulse_start_dialogue(soundTag, emitterObject, 1.0, subPriority);
	else
		sound_impulse_start_dialogue(soundTag, emitterObject, 1.0, subPriority);
	end
end

function remoteClient.ClientPlayDialogPlayer(soundTag:tag, emitterObject:object, targetPlayer:player, noSubtitles:boolean, subPriority:number):void
	if (Player_IsLocal(targetPlayer)) then
		--print("NARRATIVE CLIENT :: Playing dialog on client for player", targetPlayer);
		--print("  tag:", soundTag);

		-- DEBUG CODE ONLY - v-jamcro
		-- NOT_QUITE_RELEASE
		RegisterSoundRequestReceived(soundTag);
		-- DEBUG CODE ONLY - v-jamcro

		ClientPlayDialogObject(soundTag, emitterObject, noSubtitles, subPriority);
	end
end

function remoteClient.ClientPlayDialog(soundTag:tag, emitterObject:object, noSubtitles:boolean, subPriority:number):void

	-- DEBUG CODE ONLY - v-jamcro
	-- NOT_QUITE_RELEASE
	RegisterSoundRequestReceived(soundTag);
	-- DEBUG CODE ONLY - v-jamcro

	ClientPlayDialogObject(soundTag, emitterObject, noSubtitles, subPriority);
end


function remoteClient.ClientPlayDialogNilPlayer(soundTag:tag, targetPlayer:player, noSubtitles:boolean, subPriority:number):void
	if (Player_IsLocal(targetPlayer)) then
		--print("NARRATIVE CLIENT :: Playing nil-object dialog on client for player", targetPlayer);
		--print("  tag:", soundTag);
		
		-- DEBUG CODE ONLY - v-jamcro
		-- NOT_QUITE_RELEASE
		RegisterSoundRequestReceived(soundTag);
		-- DEBUG CODE ONLY - v-jamcro

		ClientPlayDialogObject(soundTag, nil, noSubtitles, subPriority);
	end
end


function remoteClient.ClientPlayDialogNil(soundTag:tag, noSubtitles:boolean, subPriority:number):void

	-- DEBUG CODE ONLY - v-jamcro
	-- NOT_QUITE_RELEASE
	RegisterSoundRequestReceived(soundTag);
	-- DEBUG CODE ONLY - v-jamcro

	ClientPlayDialogObject(soundTag, nil, noSubtitles, subPriority);
end

-- Play Marker Dialog
---------------------------------------------------------------------------

function ClientPlayDialogMarker(soundTag:tag, emitterObject:object, markerName:string, noSubtitles:boolean, subPriority:number):void
	ClientSetWwiseRtpcTo3d(emitterObject);
	
	--print("NARRATIVE CLIENT :: Playing marker dialog");
	--print("  tag:", soundTag);
	if (noSubtitles) then
		-- TODO : Replace with binding call for impulse call that does not fire subtitles
		sound_impulse_start_marker(soundTag, emitterObject, markerName, 1.0, subPriority);
	else
		sound_impulse_start_marker(soundTag, emitterObject, markerName, 1.0, subPriority);
	end
end

function remoteClient.ClientPlayDialogPlayerAtMarker(soundTag:tag, emitterObject:object, targetPlayer:player, markerName:string, noSubtitles:boolean, subPriority:number):void
	if (Player_IsLocal(targetPlayer)) then
		--print("NARRATIVE CLIENT :: Playing marker dialog on client for player", targetPlayer);
		--print("  tag:", soundTag);
	
		-- DEBUG CODE ONLY - v-jamcro
		-- NOT_QUITE_RELEASE
		RegisterSoundRequestReceived(soundTag);
		-- DEBUG CODE ONLY - v-jamcro

		ClientPlayDialogMarker(soundTag, emitterObject, markerName, noSubtitles, subPriority);
	end
end


function remoteClient.ClientPlayDialogAtMarker(soundTag:tag, emitterObject:object, markerName:string, noSubtitles:boolean, subPriority:number):void

	-- DEBUG CODE ONLY - v-jamcro
	-- NOT_QUITE_RELEASE
	RegisterSoundRequestReceived(soundTag);
	-- DEBUG CODE ONLY - v-jamcro

	ClientPlayDialogMarker(soundTag, emitterObject, markerName, noSubtitles, subPriority);
end

-- Stop Dialog
---------------------------------------------------------------------------

function remoteClient.ClientStopDialogPlayer(soundTag:tag, emitterObject:object, targetPlayer:player):void
	if (Player_IsLocal(targetPlayer)) then
		--print("NARRATIVE CLIENT :: Stopping dialog on client for player", targetPlayer);
		--print("  tag:", soundTag);
		sound_impulse_stop_object(soundTag, emitterObject);
		halt_dialog_subtitle(soundTag);
	end
end

function remoteClient.ClientStopDialog(soundTag:tag, emitterObject:object):void
		--print("NARRATIVE CLIENT :: Stopping dialog");
		--print("  tag:", soundTag);
	sound_impulse_stop_object(soundTag, emitterObject);
	halt_dialog_subtitle(soundTag);
end

function remoteClient.ClientStopDialogNilPlayer(soundTag:tag, targetPlayer:player):void
	if (Player_IsLocal(targetPlayer)) then
		--print("NARRATIVE CLIENT :: stopping nil-object dialog on client for player", targetPlayer);
		--print("  tag:", soundTag);
		sound_impulse_stop(soundTag);
		halt_dialog_subtitle(soundTag);
	end
end

function remoteClient.ClientStopDialogNil(soundTag:tag):void
		--print("NARRATIVE CLIENT :: Stopping nil-object dialog");
		--print("  tag:", soundTag);
	--print("client sound_impulse_stop");
	sound_impulse_stop(soundTag);
	halt_dialog_subtitle(soundTag);
end
