-- DEBUG
--## SERVER

function remoteServer.Debug_SetLocalPlayerRepresentationServer(thePlayer:player, representationName:string)
	PlayerSetRepresentation(thePlayer, representationName);
end

function Debug_SetLocalPlayerRepresentation(thePlayer:player, representationName:string)
	if (thePlayer ~= nil) then
		PlayerSetRepresentation(thePlayer, representationName)
	end
end

--## CLIENT
function Debug_SetLocalPlayerRepresentation(thePlayer:player, representationName:string)
	if (not IsServer()) then
		RunServerScript("Debug_SetLocalPlayerRepresentationServer", thePlayer, representationName);
	end
end
