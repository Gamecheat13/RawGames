#include maps\mp\animscripts\utility;

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


dog_wall_and_window_hop( traverseName, height )
{
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	realHeight = startnode.traverse_height - startnode.origin[2];
	self thread teleportThread( realHeight - height );
		
	debug_anim_print("traverse::dog_wall_and_window_hop() - Setting " + traverseName);
	self setanimstate( traverseName );
	maps\mp\animscripts\shared::DoNoteTracksForTime(1.0, "done");
	debug_anim_print("traverse::dog_wall_and_window_hop() - " + traverseName );
	
	self.traverseComplete = true;
}


dog_jump_down( height, frames, time )
{
	self endon("killanimscript");
	self traverseMode("noclip");

	if ( !isdefined( time ) )
	{
		time = 0.3;
	}
	
	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	self thread teleportThreadEx( 40.0 - height, 0.1, frames );

	debug_anim_print("traverse::dog_jump_down() - Setting traverse_jump_down_40" );
	self setanimstate( "traverse_jump_down_40" );
	maps\mp\animscripts\shared::DoNoteTracksForTime(time, "done");
	debug_anim_print("traverse::dog_jump_down() - traverse_jump_down_40 " );
	self traverseMode("gravity");
	self.traverseComplete = true;
}


dog_jump_down_far( height, frames, time )
{
	self endon("killanimscript");
	self traverseMode("noclip");

	if ( !isdefined( time ) )
	{
		time = 0.3;
	}
	
	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	self thread teleportThreadEx( 80.0 - height, 0.1, frames );

	debug_anim_print("traverse::dog_jump_down() - Setting traverse_jump_down_80" );
	self setanimstate( "traverse_jump_down_80" );
	maps\mp\animscripts\shared::DoNoteTracksForTime(time, "done");
	debug_anim_print("traverse::dog_jump_down() - traverse_jump_down_80 " );
	self traverseMode("gravity");
	self.traverseComplete = true;
}

dog_jump_up( height, frames )
{
	self endon("killanimscript");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	self thread teleportThreadEx( height - 40.0, 0.2, frames );

	debug_anim_print("traverse::dog_jump_up() - Setting traverse_jump_up_40" );
	self setanimstate( "traverse_jump_up_40" );
	maps\mp\animscripts\shared::DoNoteTracksForTime(0.5, "done");
	debug_anim_print("traverse::dog_jump_up() - traverse_jump_up_40  " );

	self traverseMode("gravity");
	self.traverseComplete = true;
}

dog_jump_up_high( height, frames )
{
	assertex( self.type == "dog", "Only dogs can do this traverse currently." );
	self endon( "killanimscript" );
	self traverseMode( "nogravity" );
	self traverseMode( "noclip" );

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[ 1 ] );
	
	realHeight = startnode.traverse_height - startnode.origin[ 2 ];
	self thread teleportThreadEx( height - 80, 0.2, frames );
		
	debug_anim_print("traverse::dog_jump_up_80() - Setting traverse_jump_up_80" );
	self setanimstate( "traverse_jump_up_80" );
	maps\mp\animscripts\shared::DoNoteTracksForTime(0.6, "done");
	debug_anim_print("traverse::dog_jump_up_80() - traverse_jump_up_80 " );
	
	self traverseMode("gravity");
	self.traverseComplete = true;
}
