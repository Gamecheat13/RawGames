-- Copyright (c) Microsoft. All rights reserved. 
-- This script contains a group of functions used for debug visualization of complex data.
-- Use the global debug_render_script_duration variable to control the duration of these debug draws.
-- All debug drawing will do nothing in release.

-- Debug draw a ray cast. If result is provided, it will also show 
function DebugDrawRayCast(castStart:vector, castEnd:vector, result:table):void
	RenderDebugArrow(castStart,castEnd,.5,1,0,0);
	if result then
		RenderDebugPoint(result.position,.1,.5,0,0,1)
		local endNormal = result.position.vector + result.normal * 0.3;
		RenderDebugArrow(result.position.vector,ToLocation(endNormal),.5,0,0,1)
	end
end

function DebugDrawSphereCast(castStart:vector, castEnd:vector, radius:number, result:table):void
	RenderDebugArrow(castStart,castEnd,.5,1,0,0);
	RenderDebugSphereFilled(castStart,radius,.5,1,0,0);
	RenderDebugSphereFilled(castEnd,radius,.5,1,0,0);
	if result then
		RenderDebugPoint(result.position,.1,.5,0,0,1)
		local endNormal = result.position.vector + result.normal * 0.3;
		RenderDebugArrow(result.position.vector,ToLocation(endNormal),.5,0,0,1)
	end
end

function DebugDrawCapsuleCast(castStart:vector, castEnd:vector, posB:vector, radius:number, result:table):void
	RenderDebugArrow(castStart,castEnd,.5,1,0,0);
	RenderDebugPill(castStart,castStart+posB,radius,.5,1,0,0);
	RenderDebugPill(castEnd,castEnd+posB,radius,.5,1,0,0);
	if result then
		RenderDebugPoint(result.position,.1,.5,0,0,1)
		local endNormal = result.position.vector + result.normal * 0.3;
		RenderDebugArrow(result.position.vector,ToLocation(endNormal),.5,0,0,1)
	end
end