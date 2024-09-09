#include maps\_utility;
#include animscripts\utility;

#using_animtree( "generic_human" );

main()
{
	if ( !IsDefined( self.cover ) )
		self.cover = SpawnStruct();

	self.cover.state = "none";			// "right" | "left" | "stand" | "crouch"
	//self.cover.pose = self.a.pose;
	self.cover.lastStateChangeTime = 0;
	self.cover.iStateChange = 0;
	self.cover.hideState = CoverMulti_ChooseHideState();	// "forward" | "back"

	self.cover.fnOverlord = ::CoverMulti_Think;

	CoverMulti_Think();
}

end_script()
{
	CoverMulti_ExitState( self.cover.state );

	//self.cover.state = undefined;			// let's keep these fields around, which will then represent previous state/hidestate.
	//self.cover.hideState = undefined;		// so as we exit our node, we know what position we're exiting from.

	self.cover.fnOverlord = undefined;
	self.cover.lastStateChangeTime = undefined;
	self.cover.iStateChange = undefined;

	animscripts\corner::end_script_corner();
	animscripts\cover_behavior::end_script( "multi" );
}

CoverMulti_Think()
{
	if ( !IsDefined( self.node ) )
		return;

	validDirs = self.node GetValidCoverPeekOuts();
	assert( validDirs.size > 0 );

	if ( IsDefined( self.cover.arrivalNodeType ) )
	{	// cover_arrival had to decide how to approach, so let's make sure we match up.
		// it may not have been a good direction, though, with respect to where my target is.
		if ( CoverMulti_IsValidDir( self.cover.arrivalNodeType, validDirs ) )
		{
			bSuccess = self CoverMulti_SetDir( self.cover.arrivalNodeType );
			assert( bSuccess );
			self.cover.arrivalNodeType = undefined;
			return;
		}
	}

	if ( !IsDefined( self.enemy ) )
	{
		CoverMulti_SetDir( CoverMulti_GetRandomValidDir( validDirs ) );
		return;
	}

	// re-evaluate target's position, see if I need to change cover position.
	myPos = self.node.origin;
	targetPos = self.enemy.origin;
	meToTarget = targetPos - myPos;

	meToTargetAngles = VectorToAngles( meToTarget );
	meToTargetAngle = AngleClamp180( meToTargetAngles[1] - self.node.angles[1] );

	minTime = undefined;

	// not elegant, but it gets the job done.
	if ( meToTargetAngle > 12 )
	{	// counter-clockwise / left
		goodDirs = [ "left", "over", "right" ];
	}
	else if ( meToTargetAngle < -12 )
	{	// clockwise / right
		goodDirs = [ "right", "over", "left" ];
	}
	else if ( meToTargetAngle > 5 )
	{
		goodDirs = [ [ "left", "over" ], "right" ];
		minTime = 15000;
	}
	else if ( meToTargetAngle < -5 )
	{
		goodDirs = [ [ "right", "over" ], "left" ];
		minTime = 15000;
	}
	else
	{	// in front of me
		goodDirs = [ "over", [ "right", "left" ] ];
		minTime = 15000;
	}

	//self.cover.lastMeToTargetAngle = meToTargetAngle;

	bestDir = CoverMulti_GetBestValidDir( goodDirs, validDirs );
	bSuccess = self CoverMulti_SetDir( bestDir, minTime );
	assert( bSuccess );
}

CoverMulti_IsValidDir( dir, validDirs )
{
	if ( !IsDefined( validDirs ) )
		validDirs = self.node GetValidCoverPeekOuts();

	for ( i = 0; i < validDirs.size; i++ )
	{
		if ( validDirs[i] == dir )
			return true;
	}
	return false;
}

CoverMulti_GetBestValidDir( dirs, validDirs )
{
	if ( !IsDefined( validDirs ) )
		validDirs = self.node GetValidCoverPeekOuts();

	myDirs = [];
	for ( i = 0; i < dirs.size; i++ )
	{
		dir = dirs[i];
		if ( !IsArray( dir ) )
		{
			myDirs[ myDirs.size ] = dir;
		}
		else
		{
			dir = common_scripts\utility::array_randomize( dir );
			for ( j = 0; j < dir.size; j++ )
				myDirs[ myDirs.size ] = dir[j];
		}
	}

	for ( i = 0; i < myDirs.size; i++ )
	{
		if ( CoverMulti_IsValidDir( myDirs[i], validDirs ) )
			return myDirs[i];
	}
}

CoverMulti_GetRandomValidDir( validDirs )
{
	if ( !IsDefined( validDirs ) )
		validDirs = self.node GetValidCoverPeekOuts();

	randIdx = randomint( validDirs.size );
	return validDirs[ randIdx ];
}

// self == node
CoverMulti_GetNonRandomValidDir( validDirs )
{
	if ( !IsDefined( validDirs ) )
		validDirs = self GetValidCoverPeekOuts();
	if ( validDirs[ 0 ] == "over" )
	{
		if ( self DoesNodeAllowStance( "stand" ) )
			return "stand";
		else
			return "crouch";
	}
	return validDirs[ 0 ];
}

CoverMulti_SetDir( dir, minTimeElapsed )
{
	if ( dir == "over" )
	{
		bAllowsStand = self.node DoesNodeAllowStance( "stand" );
		bAllowsCrouch = self.node DoesNodeAllowStance( "crouch" );

		if ( bAllowsStand )
		{	// don't stand if crouch is still a valid state.
			if ( self.cover.state != "crouch" || !bAllowsCrouch )
				CoverMulti_SetState( "stand", minTimeElapsed );
			return true;
		}
		else if ( bAllowsCrouch )
		{	// don't crouch if stand is still a valid state.
			if ( self.cover.state != "stand" || !bAllowsStand )
				CoverMulti_SetState( "crouch", minTimeElapsed );
			return true;
		}
		else
		{
			assertex( false, "cover_multi does not support prone-only nodes." );
		}
	}
	else
	{
		CoverMulti_SetState( dir, minTimeElapsed );
		return true;
	}

	return false;
}

CoverMulti_SetState( nextState, minTimeElapsed )
{
	if ( self.cover.state == nextState )
		return false;

	if ( !IsDefined( minTimeElapsed ) || minTimeElapsed < 0 )
		minTimeElapsed = 5000;

	curTime = gettime();
	if ( self.cover.lastStateChangeTime > 0 && curTime - self.cover.lastStateChangeTime < minTimeElapsed )
		return false;

	self.cover.lastStateChangeTime = curTime;

	// fork this off so we don't end ourselves.
	self thread CoverMulti_SetStateInternal( nextState );
	return true;
}

CoverMulti_SetStateInternal( nextState )
{
	//self notify( "covermulti_setstate_" + self.cover.iStateChange );
	//self.cover.iStateChange++;

	self notify( "killanimscript" );

	nextHideState = CoverMulti_ChooseHideState();

	CoverMulti_DoTransition( self.cover.state, self.a.pose, self.cover.hideState, nextState, self.a.pose, nextHideState );

	CoverMulti_ExitState( self.cover.state );

	self.cover.state = nextState;
	self.cover.hideState = nextHideState;

	CoverMulti_EnterState( self.cover.state );
}

CoverMulti_EnterState( state )
{
	if ( state == "left" )
	{
		animscripts\cover_left::main();
	}
	else if ( state == "right" )
	{
		animscripts\cover_right::main();
	}
	else if ( state == "stand" )
	{
		animscripts\cover_stand::main();
	}
	else if ( state == "crouch" )
	{
		animscripts\cover_crouch::main();
	}
	else
	{
		assert(false);	// unsupported!
	}
}

CoverMulti_ExitState( state )
{
	switch ( state )
	{
	case "left":
		animscripts\cover_left::end_script();
		break;
	case "right":
		animscripts\cover_right::end_script();
		break;
	case "stand":
		animscripts\cover_stand::end_script();
		break;
	case "crouch":
		animscripts\cover_crouch::end_script();
		break;
	}
}

CoverMulti_DoTransition( prevState, prevPose, prevFacing, nextState, nextPose, nextFacing )
{
	self endon( "killanimscript" );

	if ( prevState == "none" || nextState == "none" )
		return;

	animTransition = CoverMulti_GetAnimTransition( prevState, prevPose, prevFacing, nextState, nextPose, nextFacing );
	if ( !IsDefined( animTransition ) )
		return;

	self SetFlaggedAnimKnobAll( "cover_multi_trans", animTransition, %body, 1, 0.2, 1 );
	self animscripts\shared::DoNoteTracks( "cover_multi_trans" );
}

CoverMulti_ChooseHideState( )
{
	if ( !IsDefined( self.a.array ) || !IsDefined( self.a.array[ "alert_idle_back" ] ) )
	{
		return "forward";
	}
	
	if ( common_scripts\utility::CoinToss() )
		return "forward";
	else
		return "back";
}

CoverMulti_GetStateFromDir( node, dir )
{
	if ( dir == "left" || dir == "right" )
		return dir;
	assert( dir == "over" );
	if ( node DoesNodeAllowStance( "stand" ) )
		return "stand";
	assert( node DoesNodeAllowStance( "crouch" ) );
	return "crouch";
}

// ah, my kingdom for some consistency!
CoverMulti_GetAnimTransition( prevState, prevPose, prevFacing, nextState, nextPose, nextFacing )
{
	if ( prevFacing == "back" )
	{	// stand_back, crouch_back
		animName = prevPose + "_back";
	}
	else if ( prevState == "stand" || prevState == "crouch" )
	{	// stand_forward, crouch_forward
		assert( prevFacing == "forward" );
		animName = prevState + "_forward";
	}
	else
	{	// left_stand, left_crouch, right_stand, right_crouch
		animName = prevState + "_" + prevPose;
	}

	animName += "_to_";

	if ( nextFacing == "back" )
	{
		animName += nextPose + "_back";
	}
	else if ( nextState == "stand" || nextState == "crouch" )
	{
		assert( nextFacing == "forward" );
		animName += nextState + "_forward";
	}
	else
	{
		animName += nextState + "_" + nextPose;
	}

	archetype = self.animArchetype;
	if ( !IsDefined( archetype ) || !IsDefined( anim.archetypes[ archetype ][ "cover_multi" ] ) )
		archetype = "soldier";
	return anim.archetypes[ archetype ][ "cover_multi" ][ animName ];
}

init_animset_cover_multi()
{
	coverAnims = [];
	coverAnims[ "stand" ] = [];
	//coverAnims[ "stand" ][ "idle" ] = [];
	//coverAnims[ "stand" ][ "idle" ][ "front" ] = lookupAnim( "cover_stand", "hide_idle" );
	//coverAnims[ "stand" ][ "idle" ][ "right" ] = lookupAnim( "cover_right_stand", "alert_idle" );
	//coverAnims[ "stand" ][ "idle" ][ "left" ] = lookupAnim( "cover_left_stand", "alert_idle" );
	//coverAnims[ "stand" ][ "idle" ][ "back" ] =
	coverAnims[ "stand" ][ "trans" ] = [];
	coverAnims[ "stand" ][ "trans" ][ "left_stand" ] = [];
	//coverAnims[ "stand" ][ "trans" ][ "left" ][ "right" ] =
	//coverAnims[ "stand" ][ "trans" ][ "left" ][ "stand" ] =
	//coverAnims[ "stand" ][ "trans" ][ "left" ][ "crouch" ] =
	coverAnims[ "stand" ][ "trans" ][ "left_crouch" ] = [];
	coverAnims[ "stand" ][ "trans" ][ "right_stand" ] = [];
	//coverAnims[ "stand" ][ "trans" ][ "right" ][ "left" ] =
	//coverAnims[ "stand" ][ "trans" ][ "right" ][ "front" ] =
	//coverAnims[ "stand" ][ "trans" ][ "right" ][ "back" ] =
	coverAnims[ "stand" ][ "trans" ][ "right_crouch" ] = [];
	coverAnims[ "stand" ][ "trans" ][ "front_stand" ] = [];
	//coverAnims[ "stand" ][ "trans" ][ "front" ][ "left" ] =
	//coverAnims[ "stand" ][ "trans" ][ "front" ][ "right" ] =
	//coverAnims[ "stand" ][ "trans" ][ "front" ][ "back" ] =
	coverAnims[ "stand" ][ "trans" ][ "front_crouch" ] = [];
	coverAnims[ "stand" ][ "trans" ][ "back_stand" ] = [];
	//coverAnims[ "stand" ][ "trans" ][ "back" ][ "left" ] =
	//coverAnims[ "stand" ][ "trans" ][ "back" ][ "right" ] =
	//coverAnims[ "stand" ][ "trans" ][ "back" ][ "front" ] =
	coverAnims[ "stand" ][ "trans" ][ "back_crouch" ] = [];
	coverAnims[ "left_stand_to_right_stand" ] = undefined;
	coverAnims[ "left_stand_to_right_crouch" ] = undefined;
	coverAnims[ "left_stand_to_stand_back" ] = undefined;
	coverAnims[ "left_stand_to_stand_forward" ] = undefined;
	coverAnims[ "left_stand_to_crouch_back" ] = undefined;
	coverAnims[ "left_stand_to_crouch_forward" ] = undefined;
	coverAnims[ "left_crouch_to_right_stand" ] = undefined;
	coverAnims[ "left_crouch_to_right_crouch" ] = undefined;	// exposed_crouch_turn_180 covers this.
	coverAnims[ "left_crouch_to_stand_back" ] = undefined;
	coverAnims[ "left_crouch_to_stand_forward" ] = undefined;
	coverAnims[ "left_crouch_to_crouch_back" ] = undefined;
	coverAnims[ "left_crouch_to_crouch_forward" ] = undefined;

	//coverAnims[ "left_to_right" ] = [];
	//coverAnims[ "left_to_right" ][ "stand_to_stand" ] = undefined;
	//coverAnims[ "left_to_right" ][ "crouch_to_crouch" ] = undefined;
	//coverAnims[ "left_to_right" ][ "stand_to_crouch" ] = undefined;
	//coverAnims[ "left_to_right" ][ "crouch_to_stand" ] = undefined;
	//coverAnims[ "left_to_right" ][ "stand_to_back" ] = undefined;
	//coverAnims[ "left_to_right" ][ "back_to_stand" ] = undefined;
	//coverAnims[ "left_to_right" ][ "crouch_to_back" ] = undefined;
	//coverAnims[ "left_to_right" ][ "back_to_crouch" ] = undefined;

	coverAnims[ "crouch" ] = [];
	//coverAnims[ "crouch" ][ "idle_left" ] =
	//coverAnims[ "crouch" ][ "idle_right" ] =
	//coverAnims[ "crouch" ][ "idle_neutral" ] =
	//coverAnims[ "crouch" ][ "left_to_right" ] = 
	//coverAnims[ "crouch" ][ "right_to_left" ] = 
	//coverAnims[ "crouch" ][ "left_to_neutral" ] =
	//coverAnims[ "crouch" ][ "neutral_to_left" ] =
	//coverAnims[ "crouch" ][ "right_to_neutral" ] =
	//coverAnims[ "crouch" ][ "neutral_to_right" ] =

	assert( !IsDefined( anim.archetypes["soldier"]["cover_multi"] ) );
	anim.archetypes[ "soldier" ][ "cover_multi" ] = coverAnims;
}