setupMiniMap(material)
{
	// use 0 for no required map aspect ratio.
	requiredMapAspectRatio = level.requiredMapAspectRatio;

	corners = getentarray("minimap_corner", "targetname");
	if (corners.size != 2)
	{
		println("^1Error: There are not exactly two \"minimap_corner\" entities in the map. Could not set up minimap.");
		return;
	}
	
	corner0 = (corners[0].origin[0], corners[0].origin[1], 0);
	corner1 = (corners[1].origin[0], corners[1].origin[1], 0);
	
	cornerdiff = corner1 - corner0;
	
	north = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
	west = (0 - north[1], north[0], 0);
	
	// we need the northwest and southeast corners. all we know is that corner0 is opposite of corner1.
	if (vectordot(cornerdiff, west) > 0) {
		// corner1 is further west than corner0
		if (vectordot(cornerdiff, north) > 0) {
			// corner1 is northwest, corner0 is southeast
			northwest = corner1;
			southeast = corner0;
		}
		else {
			// corner1 is southwest, corner0 is northeast
			side = vecscale(north, vectordot(cornerdiff, north));
			northwest = corner1 - side;
			southeast = corner0 + side;
		}
	}
	else {
		// corner1 is further east than corner0
		if (vectordot(cornerdiff, north) > 0) {
			// corner1 is northeast, corner0 is southwest
			side = vecscale(north, vectordot(cornerdiff, north));
			northwest = corner0 + side;
			southeast = corner1 - side;
		}
		else {
			// corner1 is southeast, corner0 is northwest
			northwest = corner0;
			southeast = corner1;
		}
	}
	
	// expand map area to fit required aspect ratio
	if ( requiredMapAspectRatio > 0 )
	{
		northportion = vectordot(northwest - southeast, north);
		westportion = vectordot(northwest - southeast, west);
		mapAspectRatio = westportion / northportion;
		if ( mapAspectRatio < requiredMapAspectRatio )
		{
			incr = requiredMapAspectRatio / mapAspectRatio;
			addvec = vecscale( west, westportion * (incr - 1) * 0.5 );
		}
		else
		{
			incr = mapAspectRatio / requiredMapAspectRatio;
			addvec = vecscale( north, northportion * (incr - 1) * 0.5 );
		}
		northwest += addvec;
		southeast -= addvec;
	}
	
	level.mapSize = vectordot(northwest - southeast, north);
	
	/#
	precacheShader( material );	// needed if we're going to use this in a hudelem
	level.minimapspawndebug_marker = "compassping_friendly_mp";
	precacheShader( level.minimapspawndebug_marker );
	level.minimapspawndebug_axis = "compassping_enemy";
	precacheShader( level.minimapspawndebug_axis );
	level.minimapspawndebug_allies = "cb_compassping_friendly_party_mp";
	precacheShader( level.minimapspawndebug_allies );
	level.minimapspawndebug_last = "compassping_explosion";
	precacheShader( level.minimapspawndebug_last );
	level.minimap_material = material;
	level.minimap_nw = northwest;
	level.minimap_se = southeast;
	level.minimap_north = north;
	level.minimap_west = west;
	#/
	setMiniMap(material, northwest[0], northwest[1], southeast[0], southeast[1]);
}

vecscale(vec, scalar)
{
	return (vec[0]*scalar, vec[1]*scalar, vec[2]*scalar);
}
