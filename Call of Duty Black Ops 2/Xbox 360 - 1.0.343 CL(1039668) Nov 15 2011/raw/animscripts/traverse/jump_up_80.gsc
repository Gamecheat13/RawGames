#include common_scripts\utility;
#include animscripts\traverse\shared;

#using_animtree( "dog" );

main()
{
	assert( self.isdog, "Only dogs can do this traverse currently." );
	self endon( "killanimscript" );
	self traverseMode( "nogravity" );
	self traverseMode( "noclip" );

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( IsDefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[ 1 ] );
	
	realHeight = startnode.traverse_height - startnode.origin[ 2 ];
	self thread teleportThread( realHeight - 80 );
		
	self ClearAnim( %root, 0.2 );
	self SetFlaggedAnimRestart( "jump_up_80", anim.dogTraverseAnims[ "jump_up_80" ], 1, 0.2, 1 );
	
	self animscripts\shared::DoNoteTracks( "jump_up_80" );
	
	self.traverseComplete = true;
}
