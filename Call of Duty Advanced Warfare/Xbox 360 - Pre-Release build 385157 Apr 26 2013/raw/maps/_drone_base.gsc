#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );

drone_give_soul()
{
	// Tell drone which animtree to use
	self useAnimTree( #animtree );

	// Tell drone to use hero-only lighting so they look like AI
	self startUsingHeroOnlyLighting();

	if ( isdefined( self.script_moveplaybackrate ) )
		self.moveplaybackrate = self.script_moveplaybackrate;
	else
		self.moveplaybackrate = 1;

	// Put a friendly name on the drone so they look like AI
	if ( self.team == "allies" )
	{
		// asign name
		self maps\_names::get_name();
		// string not found for 
		self setlookattext( self.name, &"" );
	}

	if ( isdefined( level.droneCallbackThread ) )
		self thread [[ level.droneCallbackThread ]]();

	// Run the friendly fire thread on this drone so the mission can be failed for killing friendly drones
	// Runs on all teams since friendly fire script also keeps track of enemies killed, etc.
	if ( !IsDefined( self.script_friendly_fire_disable ) )
		level thread maps\_friendlyfire::friendly_fire_think( self );
	
	//dont call this if you dont want AI guy to glow when the player uses thermal vision. Ai only glow when player is in thermal.
	if( !isdefined( level.ai_dont_glow_in_thermal ) )
		self ThermalDrawEnable();	
}

drone_init_path()
{
	if ( !isdefined( self.target ) )
		return;
	if ( isdefined( level.drone_paths[ self.target ] ) )
		return;
	
	// don't process a path more than once
	level.drone_paths[ self.target ] = true;

	target = self.target;
	node = getstruct( target, "targetname" );
	if ( !isdefined( node ) )
		return;

	vectors = [];
	
	completed_nodes = [];
	original_node = node;

	for ( ;; )
	{
		node = original_node;
		found_new_node = false;
		
		for ( ;; )
		{
			if ( !isdefined( node.target ) )
				break;
			
			nextNodes = getstructarray( node.target, "targetname" );
			if ( nextNodes.size )
				break;
			
			nextNode = undefined;
			foreach ( newNode in nextNodes )
			{
				// origin should be unique per node
				if ( isdefined( completed_nodes[ newNode.origin + "" ] ) )
					continue;
				
				nextNode = newNode;
				break;
			}
			if ( !isdefined( nextNode ) )
				break;
			
			completed_nodes[ nextNode.origin + "" ] = true;
			
			//Line( node.origin, nextNode.origin, (1,1,1), 1, 0, 5000 );
			vectors[ node.targetname ] = nextNode.origin - node.origin;
			node.angles = vectortoangles( vectors[ node.targetname ] );
				
			node = nextNode;
			found_new_node = true;
		}
		
		if ( !found_new_node )
			break;
	}

	// now average the angles so they take corners properly
	target = self.target;
	node = getstruct( target, "targetname" );
	prevNode = node;
	completed_nodes = [];

	for ( ;; )
	{
		node = original_node;
		found_new_node = false;

		for ( ;; )
		{
			if ( !isdefined( node.target ) )
				return;
			
			if ( !isdefined( vectors[ node.targetname ] ) )
				return;

			nextNodes = getstructarray( node.target, "targetname" );
			if ( nextNodes.size )
				break;
			
			nextNode = undefined;
			foreach ( newNode in nextNodes )
			{
				// origin should be unique per node
				if ( isdefined( completed_nodes[ newNode.origin + "" ] ) )
					continue;
				
				nextNode = newNode;
				break;
			}
			if ( !isdefined( nextNode ) )
				break;
	
			
			if ( isdefined( node.radius ) )
			{
				vec1 = vectors[ prevNode.targetname ];
				vec2 = vectors[ node.targetname ];
				vec = ( vec1 + vec2 ) * 0.5;
				node.angles = vectorToAngles( vec );
				
				/*
				Line( node.origin, node.origin + vec1, (1,0,0), 1, 1, 1000 );
				Line( node.origin, node.origin + vec2, (0,0,1), 1, 1, 1000 );
				Line( node.origin, node.origin + vec, (0,1,0), 1, 1, 1000 );
				
				/#
				#/
				*/
			}
				
			found_new_node = true;
			prevNode = node;
			node = nextNode;
		}

		if ( !found_new_node )
			break;
	}
}