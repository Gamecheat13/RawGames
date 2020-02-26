
#include common_scripts\utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;


//******************************************************************************************************
//******************************************************************************************************
// NOTES:	Entities that have linked dynamic nodes store the nodes in the array self.a_dynamic_nodes
//
//			TO Attach Cover Nodes to Vehicles or Script Models:
//
//			(1) The function entity_grab_attached_dynamic_nodes() is called once on startup to store all
//				the dynamic nodes that are parented to the entity in the array self.a_dynamic_nodes
//
//			(2) If the entity is a vehicle the nodes will automatically connect to the navgation path
//				when the vehicle stops and disconect when it starts moving again.
//
//			(3) If the entity is not a vehicle the scripter can use the functions:-
//				 - entity_connect_dynamic_nodes_to_navigation_mesh();
//				 - entity_disconnect_dynamic_nodes_from_navigation_mesh();
//				This allows you to manually connect or disconnect dynamic nodes to the path
//******************************************************************************************************
//******************************************************************************************************



/@
"Name: node_connect_to_path()"
"Summary: Connects a dynamic node to the navigation path nodes based on the DIRECTION it is pointing."
"Module: Dynamic Nodes"
"Example: nd_node node_connect_to_path();"
"SPMP: singleplayer"
@/

node_connect_to_path()
{
	// Initialization
	const dp_connect = 0.3;
	const radius = 240;

	// If this node is already connected, break the connection
	if ( isdefined(self.a_node_path_connections) )
	{
		self node_disconnect_from_path();
	}
	
	// An array of all the nodes we can connect to
	a_connection_nodes = [];

	// Search through the path data for any possible connections
	a_near_nodes = GetAnyNodeArray( self.origin, radius );
	if ( isdefined( a_near_nodes ) )
	{
		v_forward = AnglesToForward( self.angles );
	
		for ( nn=0; nn<a_near_nodes.size; nn++ )
		{
			nd_test = a_near_nodes[ nn ];

			// Don't try and connect to yourself
			if ( nd_test != self )
			{
				v_dir = VectorNormalize( nd_test.origin - self.origin );
				dot = VectorDot( v_forward, v_dir );
				if( dot >= dp_connect )
				{
					// Do a ray cast to make sure we are not trying to connect through geometry
					
					const height_offset = 42; // 42 = 1 meter
					trace = BulletTrace( (self.origin[0], self.origin[1], self.origin[2] + height_offset), 
					                     (nd_test.origin[0], nd_test.origin[1], nd_test.origin[2] + height_offset),
					                     0, undefined, 1, 1 );
					if( trace["fraction"] >= 1 )
					{
						a_connection_nodes[ a_connection_nodes.size ] = nd_test;
					}
				}
			}
		}
	}
	
	// Do we have any nodes in the navugation path that can connect to this node?
	if( a_connection_nodes.size )
	{
		for( i=0; i<a_connection_nodes.size; i++ )
		{
			self node_add_connection( a_connection_nodes[i] );
		}
	}
	
	return a_connection_nodes.size;
}


/*===============================================================================================
SELF: node
PURPOSE:	The function connects a node to the navigation path and locally stores the connection
RETURNS:
CREATOR: MikeA
================================================================================================*/

node_add_connection( nd_node )
{
	//check in case it's trying to connect to another node on the moving platform again
	if( !NodesAreLinked( self, nd_node ) )
	{
		if( !IsDefined( self.a_node_path_connections ) )
		{
			self.a_node_path_connections = [];
		}
		
		LinkNodes( self, nd_node );
		LinkNodes( nd_node, self );
	
		self.a_node_path_connections[ self.a_node_path_connections.size ] = nd_node;
	}
}


/@
"Name: node_disconnect_from_path()"
"Summary: Disconnects all the links this node has to the navigation path."
"Module: Dynamic Nodes"
"Example: nd_node node_disconnect_from_path();"
"SPMP: singleplayer"
@/

node_disconnect_from_path()
{
	if( isdefined(self.a_node_path_connections) )
	{
		for( i=0; i<self.a_node_path_connections.size; i++ )
		{
			nd_node = self.a_node_path_connections[ i ];
			UnLinkNodes( self, nd_node );
			UnLinkNodes( nd_node, self);
		}
	}
	self.a_node_path_connections = undefined;
}


/@
"Name: entity_grab_attached_dynamic_nodes( <connect_nodes_to_path> )"
"Summary: Gets an array of all dynamic nodes that are linked to this entity (via targetname)."
"Module: Dynamic Nodes"
"MandatoryArg: <connect_nodes_to_path>: Do you want the nodes to connect to the path as part of the call"
"Example: e_vehicle entity_grab_attached_dynamic_nodes( 1 );"
"SPMP: singleplayer"
@/

entity_grab_attached_dynamic_nodes( connect_nodes_to_path )
{
	if ( !isdefined( connect_nodes_to_path ) )
	{
		connect_nodes_to_path = true;
	}
	
	if ( isdefined( self.targetname ) )
	{
		a_nodes = GetNodeArray( self.targetname, "target" );
		foreach ( node in a_nodes )
		{
			if ( !isdefined( self.a_dynamic_nodes ) )
			{
				self.a_dynamic_nodes = [];
			}
			
			if ( node has_spawnflag( SPAWNFLAG_PATH_CAN_PARENT ) )
			{
				self.a_dynamic_nodes[ self.a_dynamic_nodes.size ] = node;
			}
		}
	
		// Do we want to connect the nodes to the navigation path?
		if ( connect_nodes_to_path )
		{
			self thread maps\_dynamic_nodes::entity_connect_dynamic_nodes_to_navigation_mesh();
		}	
	}
}


/@
"Name: entity_connect_dynamic_nodes_to_navigation_mesh()"
"Summary: Drops all the nodes connected to the entity to ground level, then links the nodes to the naviagtion mesh."
"Module: Dynamic Nodes"
"Example: e_ent entity_connect_dynamic_nodes_to_navigation_mesh();"
"SPMP: singleplayer"
@/

entity_connect_dynamic_nodes_to_navigation_mesh()
{
	self endon( "death" );

	if ( isdefined( self.a_dynamic_nodes ) )
	{
		self entity_connect_nodes();
		
		wait .05;
		
		foreach ( node in self.a_dynamic_nodes )
		{
			DropNodeToFloor( node );
		}
	}
}

	
/*=========================================================================
SELF: vehicle
PURPOSE: TBD
RETURNS: ONLY CALL THIS ONCE THE NODES HAVE BEEN DROPPED TO THE GROUND BY:-
		 entity_connect_nodes_to_navigation_mesh().
		 Links the entities nodes to the main games naviagtion mesh.
CREATOR: MikeA
==========================================================================*/

entity_connect_nodes()
{
	self endon( "death" );

	// Does the vehicle have any dynamic nodes attached?
	if( !isdefined( self.a_dynamic_nodes ) )
	{
		return;
	}
	
	//************************************************************
	// For each dynamic node attached to the vehicle
	// Build an array of navigation mesh nodes that can link to it
	//************************************************************

	foreach ( nd_dynamic in self.a_dynamic_nodes )
	{
		if ( !isdefined( nd_dynamic.a_linked_nodes ) )
		{
			nd_dynamic.a_linked_nodes = [];
		}

		a_near_nodes = GetAnyNodeArray( nd_dynamic.origin, 256 );
		
		foreach ( nd_test in a_near_nodes )
		{		
			reject = 0;
			
			/* Can't link to self */
			
			if ( nd_test == nd_dynamic )
			{
				reject = 1;
			}
			
			/* Don't link to other dynamic nodes on the entity. Fixes potentially linking nodes that are already linked */
			
			if ( IsInArray( self.a_dynamic_nodes, nd_test ) )
			{
				reject = 1;
			}
			
			/* Test for these nodes already being linked to each other */
			
			if ( IsInArray( nd_dynamic.a_linked_nodes, nd_test ) )
			{
				reject = 1;
			}
			
//			if ( isdefined( nd_test.a_linked_nodes ) && IsInArray( nd_test.a_linked_nodes, nd_dynamic ) )
//			{
//				reject = 1;
//			}
			
			/* only link to nodes behind the dynamic node */
			
			if ( !reject )
			{
				v_forward = AnglesToForward( nd_dynamic.angles );
				v_dir = VectorNormalize( nd_test.origin - nd_dynamic.origin );
				dot = VectorDot( v_forward, v_dir );
				
				const reject_angle = 0.05;
				if ( dot > reject_angle )
				{
					reject = 1;
				}
			}
			
			/* Trace to see if we should connect these nodes */
			
			if ( !reject )
			{
				trace = BulletTrace( nd_dynamic.origin, nd_test.origin, 0, undefined, 1, 1 );
				if ( trace["fraction"] < 1 )
				{
					reject = 1;
				}
			}

			// dont link negotiation_begin nodes
			if ( IsDefined( nd_dynamic.type ) && ( nd_dynamic.type == "Begin" ) )
			{
				reject = 1;
			}

			if ( IsDefined( nd_test.type ) && ( nd_test.type == "Begin" ) )
			{
				reject = 1;
			}
			
			/* Finally link the nodes */
			
			if ( !reject )
			{


				LinkNodes( nd_dynamic, nd_test );
				LinkNodes( nd_test,  nd_dynamic );
				
				nd_dynamic.a_linked_nodes[ nd_dynamic.a_linked_nodes.size ] = nd_test;
			}
		}
	}
}


/@
"Name: entity_disconnect_dynamic_nodes_to_navigation_mesh()"
"Summary: Disconnect the entities linked nodes from the navigation path."
"Module: Dynamic Nodes"
"Example: e_ent entity_disconnect_dynamic_nodes_to_navigation_mesh();"
"SPMP: singleplayer"
@/

entity_disconnect_dynamic_nodes_from_navigation_mesh()
{
	if ( isdefined( self.a_dynamic_nodes ) )
	{
		foreach ( nd_dynamic in self.a_dynamic_nodes )
		{
			if ( isdefined( nd_dynamic.a_linked_nodes ) )
			{
				foreach ( nd_linked in nd_dynamic.a_linked_nodes )
				{
					UnLinkNodes( nd_dynamic, nd_linked );
					UnLinkNodes( nd_linked,  nd_dynamic );
				}
			}
			
			nd_dynamic.a_linked_nodes = [];
		}
	}
}