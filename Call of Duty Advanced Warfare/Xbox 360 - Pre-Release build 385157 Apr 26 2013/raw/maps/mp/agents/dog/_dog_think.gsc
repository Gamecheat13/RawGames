#include common_scripts\utility;

main()
{
	self.bLockGoalPos = false;

	self.ownerRadiusSq = 144 * 144;
	self.meleeRadiusSq = 64 * 64;
	self.targetRadiusSq = 350 * 350;
	self.attackRadiusSq = 512 * 512;
	self.preferredOffsetFromOwner = 76;
	self.minOffsetFromOwner = 42;

	self thread think();
/#
	self thread debug_dog();
#/
}

init()
{
	self.animCBs = SpawnStruct();
	self.animCBs.OnEnter = [];
	self.animCBs.OnEnter[ "idle" ] = maps\mp\agents\dog\_dog_idle::main;
	self.animCBs.OnEnter[ "move" ] = maps\mp\agents\dog\_dog_move::main;
	self.animCBs.OnEnter[ "traverse" ] = maps\mp\agents\dog\_dog_traverse::main;
	self.animCBs.OnEnter[ "melee" ] = maps\mp\agents\dog\_dog_melee::main;

	self.animCBs.OnExit = [];
	self.animCBs.OnExit[ "move" ] = maps\mp\agents\dog\_dog_move::end_script;
}

onEnterAnimState( prevState, nextState )
{
	self notify( "killanimscript" );

	if ( !IsDefined( self.animCBs.OnEnter[ nextState ] ) )
		return;

	if ( prevState == nextState )
		return;

	if ( IsDefined( self.animCBs.OnExit[ prevState ] ) )
		self [[ self.animCBs.OnExit[ prevState ] ]] ();

	self.aiState = nextState;

	self [[ self.animCBs.OnEnter[ nextState ] ]]();
}

think()
{
	self endon( "death" );
	if ( IsDefined( self.owner ) )
	{
		self endon( "owner_disconnect" );
		self thread destroyOnOwnerDisconnect( self.owner );
	}

	self.aiState = "idle";

	// self.aiState comes from code, so we need something to tell us what attack state we're in
	self.attackState = "idle";
	self thread watchAttackState();

	while ( true )
	{
		if ( self.aiState != "melee" && self readyToMeleeTarget() )
			self enterAIState( "melee" );

		switch ( self.aiState )
		{
		case "idle":
			self updateIdle();
			break;
		case "move":
			self updateMove();
			break;
		case "melee":
			self updateMelee();
			break;
		}
		wait( 0.05 );
	}
}

enterAIState( state )
{
	self ExitAIState( self.aiState );
	self.aiState = state;

	switch ( state )
	{
	case "melee":
		self ScrAgentBeginMelee( self.curMeleeTarget );
		break;
	default:
		break;
	}
}

ExitAIState( state )
{
}


updateIdle()
{
	self updateMoveToPos();
}

updateMove()
{
	self updateMoveToPos();
}

updateMelee()
{
}


updateMoveToPos()
{
	if ( self.bLockGoalPos )
		return;

	if ( IsDefined( self.owner ) )
	{
		if ( self wantsToContinueRunningToTarget() )
		{
			self ScrAgentSetGoalPos( self getAttackPoint( self.curMeleeTarget ) );
		}
		else if ( self wantsToAttackTarget() )
		{
			self ScrAgentSetGoalPos( self getAttackPoint( self.enemy ) );
			self.curMeleeTarget = self.enemy;
		}
		else
		{
			myPos = self GetPathGoalPos();
			if ( !IsDefined( myPos ) )
				myPos = self.origin;

			distFromOwnerSq = DistanceSquared( myPos, self.owner.origin );
			if ( distFromOwnerSq > self.ownerRadiusSq )
			{
				self ScrAgentSetGoalPos( self findPointNearOwner() );
				self.curMeleeTarget = undefined;
			}
		}
	}
}

readyToMeleeTarget()
{
	if ( !IsDefined( self.curMeleeTarget ) )
		return false;

	if ( DistanceSquared( self.origin, self.curMeleeTarget.origin ) > self.meleeRadiusSq )
		return false;

	return true;
}

wantsToContinueRunningToTarget()
{
	if ( !IsDefined( self.curMeleeTarget ) || !IsDefined( self.enemy ) )
		return false;

	if ( self.curMeleeTarget != self.enemy )
		return false;

	if ( DistanceSquared( self.origin, self.curMeleeTarget.origin ) > self.attackRadiusSq )
		return false;

	return true;
}

wantsToAttackTarget()
{
	if ( !IsDefined( self.enemy ) )
		return false;

	if ( DistanceSquared( self.origin, self.enemy.origin ) > self.targetRadiusSq )
		return false;

	return true;
}

wantsToGrowlAtTarget()
{
	if ( !IsDefined( self.enemy ) )
		return false;

	distSq = DistanceSquared( self.origin, self.enemy.origin );
	if ( distSq < self.attackRadiusSq && distSq > self.targetRadiusSq )
		return true;

	return false;
}

getAttackPoint( enemy )
{
	return enemy.origin;	// <- obviously not a good idea.
}

// > 0 right
cross2D( a, b )
{
	return a[0] * b[1] - b[0] * a[1];
}

// finds a valid point near the owner with two traces (nearest node and ground trace) by finding
// a point on the pathgraph somewhere.  nodes and points on node links are pre-determined to be valid.
// except i might get in trouble if the player's closest node is a negotation begin node...
findPointNearOwner()
{
	assert( IsDefined( self.owner ) );

	meToOwner = VectorNormalize( self.owner.origin - self.origin );
	ownerForward = AnglesToForward( self.owner.angles );
	ownerForward = ( ownerForward[0], ownerForward[1], 0 );
	ownerForward = VectorNormalize( ownerForward );
	currentDirFromOwner = cross2D( meToOwner, ownerForward );

	nodeClosestToOwner = GetClosestNodeInSight( self.owner.origin );
	if ( !IsDefined( nodeClosestToOwner ) )
		return self.origin;

	links = GetLinkedNodes( nodeClosestToOwner );

	distanceWeight = 10;
	angleWeight = 20;

	// prefer nodes to side which i'm already on (and slightly behind).  else behind owner.  else in front of.
	bestScore = 0;
	bestLink = 0;

	links[ links.size ] = nodeClosestToOwner;
	foreach ( link in links )
	{
		score = 0;

		ownerToLink = link.origin - self.owner.origin;
		ownerToLinkDist = Length( ownerToLink );
		if ( ownerToLinkDist >= self.preferredOffsetFromOwner )
			score += distanceWeight;
		else if ( ownerToLinkDist < self.minOffsetFromOwner )
		{
			scale = 1 - ( self.minOffsetFromOwner - ownerToLinkDist ) / self.minOffsetFromOwner;
			score += distanceWeight * scale * scale;
		}
		else
			score += distanceWeight * ownerToLinkDist / self.preferredOffsetFromOwner;

		ownerToLink = ownerToLink / ownerToLinkDist;
		angleCos = VectorDot( ownerForward, ownerToLink );
		if ( -0.707 < angleCos && angleCos < 0 )
		{
			dirFromOwner = cross2D( ownerToLink, ownerForward );
			if ( dirFromOwner * currentDirFromOwner > 0 )		// i.e. both the same sign
				score += angleWeight;
			else
				score += angleWeight * 0.75;
		}

		if ( score > bestScore )
		{
			bestScore = score;
			bestLink = link;
		}
	}

	if ( !IsDefined( bestLink ) )
		return self.origin;

	ownerToNode = bestLink.origin - nodeClosestToOwner.origin;
	ownerToNodeDist = Length( ownerToNode );
	if ( ownerToNodeDist > self.preferredOffsetFromOwner )
	{
		ownerToNode = ownerToNode / ownerToNodeDist;
		resultPos = nodeClosestToOwner.origin + ownerToNode * self.preferredOffsetFromOwner;
	}
	else
	{
		resultPos = bestLink.origin;
	}

	resultPos = GetGroundPosition( resultPos, 15, 64, 64 );

	return resultPos;
}

destroyOnOwnerDisconnect( owner )
{
	self endon( "death" );
	owner waittill_any( "disconnect", "joined_team" );

	self notify( "killanimscript" );
	if ( IsDefined( self.animCBs.OnExit[ self.aiState ] ) )
		self [[ self.animCBs.OnExit[ self.aiState ] ]] ();

	self notify( "owner_disconnect" );
	self Suicide();
}

watchAttackState() // self == dog
{
	self endon( "death" );
	
	while( true )
	{
		if( self.aiState == "melee" )
		{
			if( self.attackState != "melee" )
			{
				self.attackState = "melee";
				self thread playGrowlEating( "melee" );
			}
		}
		else if( self wantsToAttackTarget() )
		{
			if( self.attackState != "attacking" )
			{
				self.attackState = "attacking";
				self thread playBark( "attacking" );
			}
		}
		else if( !self wantsToAttackTarget() )
		{
			if( self.attackState != "warning" )
			{
				if( self wantsToGrowlAtTarget() )
				{
					self.attackState = "warning";
					self thread playGrowl( "warning" );
				}
				else
				{
					self.attackState = self.aiState;
				}
			}
			else
			{
				if( !self wantsToGrowlAtTarget() )
				{
					self.attackState = self.aiState;
				}
			}
		}

		wait( 0.05 );
	}
}

playBark( state ) // self == dog
{
	self endon( "death" );

	// while the dog is in this state randomly play bark and growl
	while( self.attackState == state )
	{
		self PlaySound( "anml_dog_bark" );
		wait( RandomIntRange( 1, 3 ) );
	}
}

playGrowl( state ) // self == dog
{
	self endon( "death" );

	// while the dog is in this state randomly play bark and growl
	while( self.attackState == state )
	{
		self PlaySound( "anml_dog_growl" );
		wait( RandomIntRange( 1, 3 ) );
		self PlaySound( "anml_dog_bark" );
		wait( RandomIntRange( 1, 3 ) );
	}
}

playGrowlEating( state ) // self == dog
{
	self endon( "death" );

	// while the dog is in this state randomly play growl eating
	while( self.attackState == state )
	{
		self PlaySound( "anml_dog_growl_eating" );
		wait( RandomIntRange( 1, 3 ) );
	}
}

/#
debug_dog() // self == dog
{
	self endon( "death" );

	while( true )
	{
		if( GetDvarInt( "scr_debugdog" ) > 0 )
		{
			start = self.origin;
			end = self.origin;
			if( IsDefined( self.enemy ) )
				end = self.enemy.origin;
			color = [ 1, 1, 1 ];

			switch( self.attackState )
			{
			case "idle":
				color = [ 1, 1, 1 ];
				break;
			case "move":
				color = [ 0, 1, 0 ];
				break;
			case "traverse":
				color = [ 0, 1, 0 ];
				break;
			case "melee":
			case "attacking":
				color = [ 1, 0, 0 ];
				break;
			case "warning":
				color = [ 0.8, 0.8, 0 ];
				break;
			default:
				break;
			}
			
			Print3d( self.origin + ( 0, 0, 10 ), self.attackState, ( color[0], color[1], color[2] ) );
			Line( start, end, ( color[0], color[1], color[2] ) );
		}

		wait( 0.05 );
	}
}
#/