
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- MATH/NUMBER/LOGIC HELPERS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================

--## COMMON

-- -------------------------------------------------------------------------------------------------
-- creates a copy of a matrix
-- -------------------------------------------------------------------------------------------------
function MatrixCopy(m:matrix):matrix
	return m * matrix();
end

-- -------------------------------------------------------------------------------------------------
-- create a matrix when you already have vectors
-- -------------------------------------------------------------------------------------------------
function MatrixFromVectors(pos:vector,angles:vector,scale:number):matrix
	local m = matrix();
	m.pos = pos or vector(0,0,0);
	m.angles = angles or vector(0,0,0);
	m.scale = scale or 1;
	return m;
end

-- -------------------------------------------------------------------------------------------------
-- blend between two transform matrixes
-- lerp should be a value from 0 to 1
-- -------------------------------------------------------------------------------------------------
function MatrixLerp(m1:matrix,m2:matrix,lerp:number):matrix
	lerp = math.Bound(lerp, 0, 1);
	local m = matrix();
	m.pos = m1.pos * (1-lerp) + m2.pos * lerp;
	--TODO: verify that the result here matches the way it will be rotated with Object_RotateToTransform
	m.angles = m1.angles * (1-lerp) + m2.angles * lerp;
	m.scale = m1.scale * (1-lerp) + m2.scale * lerp;
	return m;
end

-- -------------------------------------------------------------------------------------------------
-- returns the shortest angle between two direction vectors
-- output in degrees from 0 to 180, input does not need to be normalized
-- -------------------------------------------------------------------------------------------------
function AngleBetweenVectors(vec1:vector, vec2:vector):number
	vec1 = vec1 / vec1.length;
	vec2 = vec2 / vec2.length;
	return math.deg(math.acos(math.Bound(vec1 ^ vec2, -1, 1)));		-- floating point errors can cause this to slightly exceed bounds and produce NaNs, so let's clamp
end

-- -------------------------------------------------------------------------------------------------
-- convert a vector that represents rotation into a vector that represents direction
-- roll,pitch,yaw --> forward,left,up
-- input in degrees, output is normalized
-- -------------------------------------------------------------------------------------------------
function AnglesToVector(angles:vector):vector
	local pitch = math.rad(angles.y);
	local yaw = math.rad(angles.z);
	local xylen = math.cos(pitch);
	local x = xylen * math.cos(yaw);
	local y = xylen * math.sin(yaw);
	local z = math.sin(pitch);
	return vector(x,y,z);
end

-- -------------------------------------------------------------------------------------------------
-- convert a vector that represents direction into a vector that represents rotation
-- forward,left,up --> roll,pitch,yaw
-- output in degrees, input does not need to be normalized
-- -------------------------------------------------------------------------------------------------
function VectorToAngles(vec:vector):vector
	if vec.length == 0 then
		return vector(0,0,0);
	else
		vec = vec / vec.length;
		local r = 0;
		local a = math.sqrt(vec.x*vec.x+vec.y*vec.y);
		local p = math.deg(math.atan2(vec.z,a));
		local y = math.deg(math.atan2(vec.y,vec.x));
		return vector(r,p,y);
	end
end

-- -------------------------------------------------------------------------------------------------
-- bound - returns the value bounded by a min and max
--	val = value you want to bound
--	min = minimum value it can be
--	max = maximum value it can be
-- -------------------------------------------------------------------------------------------------
function math.Bound(val:number, min:number, max:number):number
	return math.min(math.max(val, min), max);
end

-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
function math.Round(n:number, mult:number)
    mult = mult or 1;
    return math.floor((n + mult/2) / mult) * mult;
end

function InRangeInclusive(num:number, endpointA:number, endpointB:number):boolean
	return (num >= math.min(endpointA, endpointB)) and (num <= math.max(endpointA, endpointB));
end

function InRangeExclusive(num:number, endpointA:number, endpointB:number):boolean
	return (num > math.min(endpointA, endpointB)) and (num < math.max(endpointA, endpointB));
end

-- -------------------------------------------------------------------------------------------------
-- Returns the next index in an array, wrapping back around to index 1 if we exceed count;
-- useful as a helper method for encapsulating the somewhat confusing 1-based modulo logic
--    currentIndex = current (valid) index into the array
--    arrayElemCount = number of elements in the array (e.g. #array)
-- -------------------------------------------------------------------------------------------------
function GetNextWrapAroundArrayIndex(currentIndex:number, arrayElemCount:number):number
	assert(currentIndex > 0 and currentIndex <= arrayElemCount,
		"currentIndex [" .. tostring(currentIndex) .. "] passed to GetNextWrapAroundArrayIndex was invalid for the supplied elemCount [" .. tostring(arrayElemCount) .. "]!");

	-- If the currentIndex is < arrayElemCount, then (currentIndex % arrayElemCount) == currentIndex, and we can safely increment by 1
	-- If the current index was already the last valid index (i.e. == count), then taking %count and adding 1 will reset us to index 1
	return (currentIndex % arrayElemCount) + 1;
end

-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
function DescendingNumericalOrderPred(a:number, b:number):boolean
	return a > b;
end

function GetRandomPointInCircle(centerPoint:vector, radius:number):vector
	local randomXOffset:number = 0;
	local randomYOffset:number = 0;

	repeat
		randomXOffset = real_random_range(-1,1) * radius;
		randomYOffset = real_random_range(-1,1) * radius;
	-- Make sure random point is within the circle, retry if not
	until (randomXOffset^2 + randomYOffset^2 <= radius^2);

	return vector(centerPoint.x + randomXOffset, centerPoint.y + randomYOffset, centerPoint.z);
end

function GetMinMajorityOfCount(count:number):number
	if (count <= 2) then
		return count;
	end

	if ((count % 2) == 0) then
		return ((count / 2) + 1);
	else
		return math.ceil(count / 2);
	end
end

-- -------------------------------------------------------------------------------------------------
--  Returns an eased value between startVal and endVal based on a basic cosine curve
--  Useful to call from a script loop with an iterating step value
--
--  startVal = starting value
--  endVal = ending value
--  duration = length of the ease (equal to half the curve period)
--  step = position in the ease to get your value from (typically between 0 and duration)
function CosineEaseValue(startVal:number, endVal:number, duration:number, step:number):number
	local direction:number = 0;
	
	if endVal > startVal then 
		direction = 1; 
	end

	return (math.abs(endVal - startVal) / 2) * math.cos((math.pi / duration) * step - math.pi * direction) + ((startVal + endVal) / 2);
end
