
-- =================================================================================================
-- =================================================================================================
--DEVICE MACHINES
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------

-- == PLAY OVERLAY ANIMATIONS

--play simple animation in frames per second

function PlayAnimation (device:object, layer:number, name:string, rate:number):void
	print ("Play animation",name, "of device",device);
	DeviceSetLayerAnimation (device, layer, name);
	
	rate = rate or 30;
	
	DeviceSetLayerPlaybackStop(device, layer);
  DeviceSetLayerDest(device, layer, 1);
  DeviceSetLayerPos(device, layer, 0);
end


--Play simple looping animation in frames per second
--function PlayLoopingAnimation (device:object, layer:number, name:string, rate:number):void
--	print ("Play animation",name, "of device",device);
--	DeviceSetLayerAnimation (device, layer, name);
--	DeviceSetLayerPlaybackLoop (device, layer);
--	DeviceSetLayerRate(deviceMachine, layer, rate);
--  DeviceSetLayerDest(deviceMachine, layer, 2);
--  DeviceSetLayerPos(deviceMachine, layer, 0);
--end
--
--
----Play simple bouncing animation in frames per second
--function PlayBouncingAnimation (device:object, layer:number, name:string, rate:number):void
--	print ("Play animation",name, "of device",device);
--	DeviceSetLayerAnimation (device, layer, name);
--	DeviceSetLayerPlaybackBounce (device, layer);
--	DeviceSetLayerRate(deviceMachine, layer, rate);
--  DeviceSetLayerDest(deviceMachine, layer, 2);
--  DeviceSetLayerPos(deviceMachine, layer, 0);
--end

--play animation in frames per second
function DeviceLayerPlayAnimation( deviceMachine:object, layer:number, name:string, rate:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackStop(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 1);
	DeviceSetLayerPos(deviceMachine, layer, 0);
end
function DeviceLayerPlayAnimationBackward( deviceMachine:object, layer:number, name:string, rate:number):void	-- using this to close hangar doors -tjp
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackStop(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 0);
	DeviceSetLayerPos(deviceMachine, layer, 1);
end
--Play looping animation in frames per second
function DeviceLayerPlayLoopingAnimation( deviceMachine:object, layer:number, name:string, rate:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackLoop(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 2);
	DeviceSetLayerPos(deviceMachine, layer, 0);
end

--Play bouncing animation in frames per second
function DeviceLayerPlayBouncingAnimation( deviceMachine:object, layer:number, name:string, rate:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackBounce(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 2);
	DeviceSetLayerPos(deviceMachine, layer, 0);
end

function DeviceLayerFadeInAnimation( deviceMachine:object, layer:number, name:string, rate:number, fadeInTime:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackStop(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 1);
	DeviceSetLayerPos(deviceMachine, layer, 0);
	DeviceSetLayerBlend(deviceMachine, layer, 0.0, 0);
	DeviceSetLayerBlend(deviceMachine, layer, 1.0, fadeInTime);
end

function DeviceLayerFadeInLoopingAnimation( deviceMachine:object, layer:number, name:string, rate:number, fadeInTime:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackLoop(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 1);
	DeviceSetLayerPos(deviceMachine, layer, 0);
	DeviceSetLayerBlend(deviceMachine, layer, 0.0, 0);
	DeviceSetLayerBlend(deviceMachine, layer, 1.0, fadeInTime);
end

function DeviceLayerFadeInBouncingAnimation( deviceMachine:object, layer:number, name:string, rate:number, fadeInTime:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackBounce(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	
	DeviceSetLayerDest(deviceMachine, layer, 1);
	DeviceSetLayerPos(deviceMachine, layer, 0);
	DeviceSetLayerBlend(deviceMachine, layer, 0.0, 0);
	DeviceSetLayerBlend(deviceMachine, layer, 1.0, fadeInTime);
end

--play animation in frames per second
function DeviceLayerPlayAnimationDestination( deviceMachine:object, layer:number, name:string, rate:number, dest:number):void
	DeviceSetLayerAnimation(deviceMachine, layer, name);
	DeviceSetLayerPlaybackStop(deviceMachine, layer);
	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);
	print("destination ", dest );
	DeviceSetLayerDest( deviceMachine, layer, dest );
	DeviceSetLayerPos(deviceMachine, layer, 0);
end

function DeviceLayerPlayAnimationDestinationContinue( deviceMachine:object, layer:number, name:string, rate:number, dest:number):void	
	rate = rate or 30;
	DeviceSetLayerRate(deviceMachine, layer, rate);	
	DeviceSetLayerDest( deviceMachine, layer, dest );
end

--USE THIS FUNCTION AS A TEMPLATE
--function anim_test ():void
--	print ("device test");
--	
--	--PlayAnimation (OBJECTS.dm_crane, 1, "any:turn", 20);
--	--PlayLoopingAnimation (OBJECTS.dm_crane, 1, "any:turn");
--	--PlayBouncingAnimation (OBJECTS.dm_crane, 1, "any:turn");
--	--PlayBouncingAnimation (OBJECTS.dm_crane, 1, "any:gears");
--	--OBJECTS.dm_crane:crane_do();
--end