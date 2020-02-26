#include maps\mp\animscripts\utility;
#include maps\mp\_utility;
#include common_scripts\utility; 

// All "Begin" nodes get passed in here through _load.gsc
init_traverse()
{
	point = GetEnt(self.target, "targetname");
	if (IsDefined(point))
	{
		self.traverse_height = point.origin[2];
		point Delete();
	}
 	else
 	{
 		point = getstruct(self.target, "targetname");
 		if (IsDefined(point))
 		{
 			self.traverse_height = point.origin[2];
 		}
 	}
}

teleportThread( verticalOffset )
{
	self endon ("killanimscript");
	self notify("endTeleportThread");
	self endon("endTeleportThread");

	reps = 5;
	offset = ( 0, 0, verticalOffset / reps);

	for ( i = 0; i < reps; i++ )
	{
		self teleport( self.origin + offset );
		wait .05;
	}
}

teleportThreadEx( verticalOffset, delay, frames )
{
	self endon ("killanimscript");
	self notify("endTeleportThread");
	self endon("endTeleportThread");

	if ( verticalOffset == 0 )
		return;

	wait delay;

	amount = verticalOffset / frames;
	if ( amount > 10.0 )
		amount = 10.0;
	else if ( amount < -10.0 )
		amount = -10.0;

	offset = ( 0, 0, amount );

	for ( i = 0; i < frames; i++ )
	{
		self teleport( self.origin + offset );
		wait .05;
	}
}

handleTraverseAlignment()
{
	self traverseMode( "nogravity" );
	self traverseMode( "noclip" );

	if ( IsDefined( self.traverseHeight ) && IsDefined( self.traverseStartNode.traverse_height ) )
	{
		currentHeight = self.traverseStartNode.traverse_height - self.traverseStartZ;
		self thread teleportThread( currentHeight - self.traverseHeight );
	}
}

DoSimpleTraverse( traverseAlias )
{
	traverseState = "zm_traverse";

	if ( !self.has_legs )
	{
		traverseState = "zm_traverse_crawl";
		traverseAlias = traverseAlias + "_crawl";
	}

	self DoTraverse( traverseState, traverseAlias );
}


DoTraverse( traverseState, traverseAlias )
{
	self endon("killanimscript");

	self traverseMode("nogravity");
	self traverseMode("noclip");

	self.is_traversing = true;
	self notify("zombie_start_traverse");

	self.traverseStartNode = self GetNegotiationStartNode();
    assert( IsDefined( self.traverseStartNode ) );

	// orient to the Negotiation start node
	self OrientMode( "face angle", self.traverseStartNode.angles[1] );
	self.traverseStartZ = self.origin[2];

	self SetAnimStateFromASD( traverseState, traverseAlias );
	self maps\mp\animscripts\zm_shared::DoNoteTracks( "traverse_anim" );

	self traverseMode("gravity");

	self.a.nodeath = false;

	self.needs_run_update = true;
	if( !self.isdog )
		self maps\mp\animscripts\zm_run::MoveRun();

	self.is_traversing = false;
	self notify("zombie_end_traverse");
}
