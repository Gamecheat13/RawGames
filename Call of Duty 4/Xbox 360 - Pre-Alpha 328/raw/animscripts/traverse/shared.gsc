#include animscripts\utility;
#using_animtree ("generic_human");

// Deprecated. only used for old traverses that will be deleted.
advancedTraverse(traverseAnim, normalHeight)
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self.old_anim_movement = self.a.movement;
	self.old_anim_alertness = self.a.alertness;
	
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip"); // So he doesn't get stuck if the wall is a little too high
	
	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	realHeight = startnode.traverse_height - startnode.origin[2];
	
	self thread teleportThread( realHeight - normalHeight );
	
	blendTime = 0.15;
	
	self clearAnim( %body, blendTime );
	self setFlaggedAnimKnoballRestart( "traverse", traverseAnim, %root, 1, blendTime, 1 );
	
	gravityToBlendTime = 0.2;
	endBlendTime = 0.2;
	
	self thread animscripts\shared::DoNoteTracksForever( "traverse", "no clear" );
	if ( !animHasNotetrack( traverseAnim, "gravity on" ) )
	{
		magicWhateverTime_WhereTheHeckDidWeGetThisNumberAnyway = 1.23;
		wait ( magicWhateverTime_WhereTheHeckDidWeGetThisNumberAnyway - gravityToBlendTime );
		self traverseMode( "gravity" );
		wait ( gravityToBlendTime );
	}
	else
	{
		self waittillmatch( "traverse", "gravity on" );
		self traverseMode( "gravity" );
		if ( !animHasNotetrack( traverseAnim, "blend" ) )
			wait ( gravityToBlendTime );
		else
			self waittillmatch( "traverse", "blend" );
	}

	self.a.movement = self.old_anim_movement;
	self.a.alertness = self.old_anim_alertness;
	
	runAnim = animscripts\run::GetRunAnim();
	
	self setAnimKnobAllRestart( runAnim, %body, 1, endBlendTime, 1 );
	wait (endBlendTime);
	thread animscripts\run::MakeRunSounds ( "killSoundThread" );

	/*
	for (;;)
	{
		self waittill ("traverse",notetrack);
		println ("notetrack ", notetrack);
	}
	*/
}

teleportThread( verticalOffset )
{
	self endon ("killanimscript");
	reps = 5;
	offset = ( 0, 0, verticalOffset / reps);
	
	for ( i = 0; i < reps; i++ )
	{
		self teleport( self.origin + offset );
		wait .05;
	}
}


DoTraverse( traverseData )
{
 	self endon( "killanimscript" );
	
	// do not do code prone in this script
	self.desired_anim_pose = "stand";
	animscripts\utility::UpdateAnimPose();
	
	// orient to the Negotiation start node
    startnode = self getNegotiationStartNode();
 	endNode = self getNegotiationEndNode();
 	
    assert( isDefined( startnode ) );
    assert( isDefined( endNode ) );
    
    self OrientMode( "face angle", startnode.angles[1] );
	
	self.traverseHeight = traverseData[ "traverseHeight" ];
	self.traverseStartNode = startnode;
	
	traverseAnim = traverseData[ "traverseAnim" ];
	traverseToCoverAnim = traverseData[ "traverseToCoverAnim" ];
	
	/*
	if ( !animHasNotetrack( traverseAnim, "traverse_align" ) )
	{
		/# println( "^1Warning: animation ", traverseAnim, " has no traverse_align notetrack" ); #/
		self handleTraverseAlignment();
	}
	*/
	self handleTraverseAlignment();
	
	toCover = false;
	if ( isDefined( traverseToCoverAnim ) && isDefined( self.node ) && self.node.type == traverseData[ "coverType" ] && distanceSquared( self.node.origin, endNode.origin ) < 25 * 25 )
	{
		if ( AbsAngleClamp180( self.node.angles[1] - endNode.angles[1] ) > 160 )
		{
			toCover = true;
			traverseAnim = traverseToCoverAnim;
		}
	}
	
	self thread TraverseRagdollDeath( traverseAnim );
	
	self setFlaggedAnimKnoballRestart( "traverseAnim", traverseAnim, %body, 1, .2, 1 );
	//self thread animscripts\utility::ragdollDeath( traverseAnim );
	
	self.traverseDeathIndex = 0;
	self.traverseDeathAnim = traverseData[ "interruptDeathAnim" ];
	self animscripts\shared::DoNoteTracks( "traverseAnim", ::handleTraverseNotetracks );
	self traverseMode( "gravity" );
	
	if ( self.delayedDeath )
		return;
	
	self.a.nodeath = false;
	if ( toCover && isDefined( self.node ) && distanceSquared( self.origin, self.node.origin ) < 16 * 16 )
	{
		self.a.movement = "stop";
		self teleport( self.node.origin );
	}
	else
	{
		self.a.movement = "run";
		self.a.alertness = "casual";
		self setAnimKnobAllRestart( animscripts\run::GetRunAnim(), %body, 1, 0.0, 1 );
	}
}

handleTraverseNotetracks( note )
{
	if ( note == "traverse_death" )
		return handleTraverseDeathNotetrack();
	//else if ( note == "traverse_align" )
	//	return handleTraverseAlignment();
}

handleTraverseDeathNotetrack()
{
	self endon( "killanimscript" );
	
	if ( self.delayedDeath )
	{
		self.a.noDeath = true;
		self.exception["move"] = ::doNothingFunc;
		self traverseDeath();
		return true;
	}
	self.traverseDeathIndex++;
}

handleTraverseAlignment()
{
	self traverseMode( "nogravity" );
	self traverseMode( "noclip" );
	if ( isDefined( self.traverseHeight ) && isDefined( self.traverseStartNode.traverse_height ) )
	{
		realHeight = self.traverseStartNode.traverse_height - self.origin[2];
		self thread teleportThread( realHeight - self.traverseHeight );
	}
}

doNothingFunc()
{
	self animMode( "zonly_physics" );
	self waittill ( "killanimscript" );
}

traverseDeath()
{
	self notify("traverse_death");
	
	if ( !isDefined( self.triedTraverseRagdoll ) )
		self animscripts\death::PlayDeathSound();
	
	deathAnimArray = self.traverseDeathAnim[ self.traverseDeathIndex ];
	deathAnim = deathAnimArray[ randomint( deathAnimArray.size ) ];
	
	animscripts\death::playDeathAnim( deathAnim );
	self doDamage( self.health + 5, self.origin );
}

TraverseRagdollDeath( traverseAnim )
{
	self endon("traverse_death");
	self endon("killanimscript");
	
	while(1)
	{
		self waittill("damage");
		if ( !self.delayedDeath )
			continue;

		scriptedDeathTimes = getNotetrackTimes( traverseAnim, "traverse_death" );
		currentTime = self getAnimTime( traverseAnim );
		scriptedDeathTimes[ scriptedDeathTimes.size ] = 1.0;
		
		/#
		if ( getDebugDvarInt( "scr_forcetraverseragdoll" ) == 1 )
			scriptedDeathTimes = [];
		#/
		
		for ( i = 0; i < scriptedDeathTimes.size; i++ )
		{
			if ( scriptedDeathTimes[i] > currentTime )
			{
				animLength = getAnimLength( traverseAnim );
				timeUntilScriptedDeath = (scriptedDeathTimes[i] - currentTime) * animLength;
				if ( timeUntilScriptedDeath < 0.5 )
					return;
				break;
			}
		}
		
		self.deathFunction = ::postTraverseDeathAnim;
		self.exception["move"] = ::doNothingFunc;
		
		self animscripts\death::PlayDeathSound();
		
		self animscripts\shared::DropAllAIWeapons();
		
		behindMe = self.origin + (0,0,30) - anglesToForward( self.angles ) * 20;
		self startRagdoll();
		thread physExplosionForRagdoll( behindMe );
		
		self.a.triedTraverseRagdoll = true;
		break;
	}
}

physExplosionForRagdoll( pos )
{
	wait .1;
	physicsExplosionSphere( pos, 55, 35, 1 );
}

postTraverseDeathAnim()
{
	self endon( "killanimscript" );
	if ( !isdefined( self ) )
		return;
	// in case the ragdoll failed
	deathAnim = animscripts\death::getDeathAnim();
	self setFlaggedAnimKnobAllRestart( "deathanim", deathAnim, %body, 1, .1 );
}

deathWait()
{
	self endon("killanimscript");
	wait 2;
}

#using_animtree ("dog");

dog_wall_and_window_hop()
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

