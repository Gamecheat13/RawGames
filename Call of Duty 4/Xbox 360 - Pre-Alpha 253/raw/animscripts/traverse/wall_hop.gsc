// Fence_climb.gsc
// Makes the character climb a 48 unit fence
// TEMP - copied wall dive until we get an animation
// Makes the character dive over a low wall

#include animscripts\traverse\shared;

main()
{
	if ( self.type == "human" )
		wall_hop_human();
	else if ( self.type == "dog" )
		wall_hop_dog();
}

#using_animtree ("generic_human");

wall_hop_human()
{
	if (randomint(100) < 30)
		self advancedTraverse(%traverse_wallhop_3, 39.875);
	else
		self advancedTraverse(%traverse_wallhop, 39.875);
}


#using_animtree ("dog");

wall_hop_dog()
{
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	realHeight = startnode.traverse_height - startnode.origin[2];
	self thread teleportThread(realHeight - 39.875);
		
	self clearanim(%root, 0.2);
	self setflaggedanimrestart( "wallhop", anim.dogTraverseAnims["wallhop"], 1, 0.2, 1);
	
	self animscripts\shared::DoNoteTracks( "wallhop" );
	
	self.traverseComplete = true;
}
