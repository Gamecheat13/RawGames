#include maps\mp\agents\_scriptedAgents;

main()
{
	self endon( "killanimscript" );

	startNode = self GetNegotiationStartNode();
	endNode = self GetNegotiationEndNode();
	assert( IsDefined( startNode ) && IsDefined( endNode ) );

	animState = undefined;

	if ( IsSubStr( startNode.animscript, "stepup" ) || IsSubStr( startNode.animscript, "step_up" ) )
	{
		animState = "traverse_jump_up_40";
	}
	else if ( IsSubStr( startNode.animscript, "jumpdown" ) || IsSubStr( startNode.animscript, "step_down" ) )
	{
		animState = "traverse_jump_down_40";
	}

	if ( !IsDefined( animState ) )
	{
		assertmsg( "no animation for this traverse." );
		return;
	}

	startToEnd = ( endNode.origin[0] - startNode.origin[0], endNode.origin[1] - startNode.origin[1], 0 );
	anglesToEnd = VectorToAngles( startToEnd );

	self ScrAgentSetOrientMode( "face angle abs", anglesToEnd );
	self ScrAgentSetAnimMode( "anim deltas" );

	traverseAnim = self GetAnimEntry( animState, 0 );
	moveDelta = GetMoveDelta( traverseAnim, 0, 1 );

	xyMoveDist = Distance2D( startNode.origin, endNode.origin );
	zMoveDist = endNode.origin[2] - startNode.origin[2];

	xyAnimDist = sqrt( moveDelta[0] * moveDelta[0] + moveDelta[1] * moveDelta[1] );
	self ScrAgentSetAnimScale( abs( xyMoveDist / xyAnimDist ), abs( zMoveDist / moveDelta[2] ) );

	self PlayAnimUntilNotetrack( animState, "traverse" );

	self ScrAgentSetAnimScale( 1, 1 );
}