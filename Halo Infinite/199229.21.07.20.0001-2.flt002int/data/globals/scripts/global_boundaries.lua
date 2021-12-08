--## SERVER

-- Note that the constructor args for mp_object_boundary are:
-- mp_object_boundary(widthOrRadius, boxLength, positiveHeight, negativeHeight, shape), where
-- 		float widthOrRadius := r/x direction, world units
-- 		float boxLength := y direction, world units
-- 		float positiveHeight := above boundary origin, +z direction, world units
-- 		float negativeHeight := below boundary origin, -z direction, world units
-- 		shape:= BOUNDARY_TYPE

function CreateExpandedBoundary(originalBoundary:mp_object_boundary, horizontalExpansion:number, verticalExpansion:number):mp_object_boundary
	local boundaryType:boundary_type = Boundary_GetType(originalBoundary);

	if (boundaryType == BOUNDARY_TYPE.Sphere) then
		local radius:number = originalBoundary.widthOrRadius + horizontalExpansion;

		return mp_object_boundary(radius, 0, 0, 0, BOUNDARY_TYPE.Sphere);

	elseif (boundaryType == BOUNDARY_TYPE.Cylinder) then
		local radius:number = originalBoundary.widthOrRadius + horizontalExpansion;
		local positiveHeight:number = originalBoundary.positiveHeight + verticalExpansion / 2;
		local negativeHeight:number = originalBoundary.negativeHeight + verticalExpansion / 2;

		return mp_object_boundary(radius, 0, positiveHeight, negativeHeight, BOUNDARY_TYPE.Cylinder);

	elseif (boundaryType == BOUNDARY_TYPE.Box) then
		local width:number = originalBoundary.widthOrRadius + horizontalExpansion;
		local length:number = originalBoundary.boxLength + horizontalExpansion;
		local positiveHeight:number = originalBoundary.positiveHeight + verticalExpansion / 2;
		local negativeHeight:number = originalBoundary.negativeHeight + verticalExpansion / 2;

		return mp_object_boundary(width, length, positiveHeight, negativeHeight, BOUNDARY_TYPE.Box);

	elseif (boundaryType == BOUNDARY_TYPE.None) then
		-- if the boundaryType is None for whatever reason then we'll just return the originalBoundary unmodified since we don't know what to do with it
		return originalBoundary;
	else
		assert(false, "unknown BOUNDARY_TYPE encountered in global_boundaries:CreateExpandedBoundary(). Please add handling for this new enum type!");
		-- just return the originalBoundary so we don't blow up in non-Assert builds
		return originalBoundary;
	end
end

-- Similar to CreateNewExplicitBoundary, this allows passing the full set of possible params (even if a subset will only ever be used) to allow
-- expanding a boundary with a type unknown to the callsite
function CreateExpandedBoundaryAllParams(originalBoundary:mp_object_boundary, radiusExpansion:number, heightExpansion:number, widthExpansion:number, lengthExpansion:number):mp_object_boundary
	local boundaryType:boundary_type = Boundary_GetType(originalBoundary);

	if (boundaryType == BOUNDARY_TYPE.Sphere) then
		local radius:number = originalBoundary.widthOrRadius + (radiusExpansion or 0);

		return mp_object_boundary(radius, 0, 0, 0, BOUNDARY_TYPE.Sphere);

	elseif (boundaryType == BOUNDARY_TYPE.Cylinder) then
		local radius:number = originalBoundary.widthOrRadius + (radiusExpansion or 0);
		local halfHeightExpansion:number = (heightExpansion or 0) / 2;
		local positiveHeight:number = originalBoundary.positiveHeight + halfHeightExpansion;
		local negativeHeight:number = originalBoundary.negativeHeight + halfHeightExpansion;

		return mp_object_boundary(radius, 0, positiveHeight, negativeHeight, BOUNDARY_TYPE.Cylinder);

	elseif (boundaryType == BOUNDARY_TYPE.Box) then
		local width:number = originalBoundary.widthOrRadius + (widthExpansion or 0);
		local length:number = originalBoundary.boxLength + (lengthExpansion or 0);
		local halfHeightExpansion:number = (heightExpansion or 0) / 2;
		local positiveHeight:number = originalBoundary.positiveHeight + halfHeightExpansion;
		local negativeHeight:number = originalBoundary.negativeHeight + halfHeightExpansion;

		return mp_object_boundary(width, length, positiveHeight, negativeHeight, BOUNDARY_TYPE.Box);

	elseif (boundaryType == BOUNDARY_TYPE.None) then
		-- if the boundaryType is None for whatever reason then we'll just return the originalBoundary unmodified since we don't know what to do with it
		return originalBoundary;
	else
		assert(false, "unknown BOUNDARY_TYPE encountered in global_boundaries:CreateExpandedBoundaryAllParams(). Please add handling for this new enum type!");
		-- just return the originalBoundary so we don't blow up in non-Assert builds
		return originalBoundary;
	end
end

function CreateNewBoundary(boundaryType:boundary_type, horizontalSize:number, verticalSize:number):mp_object_boundary
	if (boundaryType == BOUNDARY_TYPE.Sphere) then
		local radius:number = horizontalSize / 2;
		
		return mp_object_boundary(radius, 0, 0, 0, boundaryType);

	elseif (boundaryType == BOUNDARY_TYPE.Cylinder) then
		local radius:number = horizontalSize / 2;
		local positiveHeight:number = verticalSize / 2;
		local negativeHeight:number = verticalSize / 2;

		return mp_object_boundary(radius, 0, positiveHeight, negativeHeight, boundaryType);

	elseif (boundaryType == BOUNDARY_TYPE.Box) then
		local positiveHeight:number = verticalSize / 2;
		local negativeHeight:number = verticalSize / 2;

		return mp_object_boundary(horizontalSize, horizontalSize, positiveHeight, negativeHeight, boundaryType);	-- we could change to provide a width AND length if needed

	elseif (boundaryType == BOUNDARY_TYPE.None) then
		return nil;
	else
		assert(false, "unknown BOUNDARY_TYPE encountered in global_boundaries:CreateNewBoundary(). Please add handling for this new enum type!");
		return nil;
	end
end

-- A helper that encapsulates some of the logic for agnostically creating a boundary from the set of all possible params
--    e.g., one of the constructor params for mp_object_boundary is "widthOrRadius"; this function accepts both and decides the appropriate one to use
function CreateNewExplicitBoundary(boundaryType:boundary_type, radius:number, height:number, width:number, length:number):mp_object_boundary
	if (boundaryType == BOUNDARY_TYPE.Sphere) then
		return mp_object_boundary(radius, 0, 0, 0, boundaryType);

	elseif (boundaryType == BOUNDARY_TYPE.Cylinder) then
		local halfHeight:number = height / 2;
		return mp_object_boundary(radius, 0, halfHeight, halfHeight, boundaryType);

	elseif (boundaryType == BOUNDARY_TYPE.Box) then
		local halfHeight:number = height / 2;
		return mp_object_boundary(width, length, halfHeight, halfHeight, boundaryType);	-- we could change to provide a width AND length if needed

	elseif (boundaryType == BOUNDARY_TYPE.None) then
		return nil;
	else
		assert(false, "unknown BOUNDARY_TYPE encountered in global_boundaries:CreateNewExplicitBoundary(). Please add handling for this new enum type!");
		return nil;
	end
end