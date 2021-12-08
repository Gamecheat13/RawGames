-- Copyright (C) Microsoft. All rights reserved.

--## SERVER

function SendGameEvent(obj:object, event:string_id):void
	RunClientScript('ObjectNodeGraph_OnGameEvent', obj, event);
end

function SetGameFloatValue(obj:object, name:string_id, value:number):void
	RunClientScript('ObjectNodeGraph_OnGameFloatValue', obj, name, value);
end


--## CLIENT

function SendGameEvent(obj:object, event:string_id):void
	remoteClient.ObjectNodeGraph_OnGameEvent(obj, event);
end

function SetGameFloatValue(obj:object, name:string_id, value:number):void
	remoteClient.ObjectNodeGraph_OnGameFloatValue(obj, name, value);
end


function remoteClient.ObjectNodeGraph_OnGameEvent(obj:object, event:string_id):void
	ObjectNodeGraph_NotifyGetGameEventNode(obj, event);
end


function remoteClient.ObjectNodeGraph_OnGameFloatValue(obj:object, name:string_id, value:number):void
	ObjectNodeGraph_NotifyGetGameFloatValueNode(obj, name, value);
end


