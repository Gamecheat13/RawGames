#include maps\mp\animscripts\traverse\shared;
#include maps\mp\animscripts\utility;


main()
{
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	if (IsDefined(startnode.traverse_height))
	{
		realHeight = startnode.traverse_height - startnode.origin[2];
		self thread teleportThread( realHeight );
	}
		
	debug_anim_print("traverse::through_hole()");
	self setanimstate( "traverse_through_hole_42" );
	maps\mp\animscripts\shared::DoNoteTracksForTime(1.0, "done");
	debug_anim_print("traverse::through_hole()" );
	
	self.traverseComplete = true;
}
