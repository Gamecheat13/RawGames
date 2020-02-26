#include common_scripts\utility;
#include maps\_utility;

#using_animtree ("generic_human");

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
	
	const reps = 5;
	offset = ( 0, 0, verticalOffset / reps);
	
	for ( i = 0; i < reps; i++ )
	{
		self Teleport( self.origin + offset );
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
		self Teleport( self.origin + offset );
		wait .05;
	}
}

PrepareForTraverse()
{
	self.a.prevPose = "stand";
	self.a.pose 	= "stand";

	movement = "move";

	if (IsDefined(self.force_traversal_movement))
		movement = self.force_traversal_movement;

	return movement;
}

DoTraverse( traverseData )
{
	self endon( "killanimscript" );

	// for shooting anims
	self.a.script = "move";

	/#
	self animscripts\debug::debugClearState();
	self animscripts\debug::debugPushState( self.a.script );
	self animscripts\debug::debugPushState( "traverse" );
	#/

	self.traverseAnimIsSequence = (
			IsDefined(traverseData[ "traverseAnimType" ])
			&& (traverseData[ "traverseAnimType" ] == "sequence")
		);

	self.traverseAnim =			traverseData[ "traverseAnim" ];
	self.traverseAnimTransIn =	traverseData[ "traverseAnimTransIn" ];
	self.traverseAnimTransOut =	traverseData[ "traverseAnimTransOut" ];

	self.traverseSound =		traverseData[ "traverseSound" ];
	self.traverseAlertness =	traverseData[ "traverseAlertness" ];
	self.traverseStance =		traverseData[ "traverseStance" ];
	self.traverseHeight =		traverseData[ "traverseHeight" ];
	self.traverseMovement =		traverseData[ "traverseMovement" ];
	self.traverseToCoverAnim =	traverseData[ "traverseToCoverAnim" ];
	self.traverseToCoverSound =	traverseData[ "traverseToCoverSound" ];
	self.traverseDeathAnim =	traverseData[ "interruptDeathAnim" ];

	self.traverseDeathIndex = 0;

	self.traverseAllowAiming = false;
	if( IsDefined( traverseData[ "traverseAllowAiming" ] ) )
	{
		self.traverseAllowAiming = traverseData[ "traverseAllowAiming" ];

		self.traverseAimAnims = [];
		self.traverseAimAnims["up"]		= traverseData[ "traverseAimUp" ];
		self.traverseAimAnims["down"]	= traverseData[ "traverseAimDown" ];
		self.traverseAimAnims["left"]	= traverseData[ "traverseAimLeft" ];
		self.traverseAimAnims["right"]	= traverseData[ "traverseAimRight" ];
	}

	self.traverseRagdollDeath = false;
	if( IsDefined( traverseData[ "traverseRagdollDeath" ] ) )
	{
		self.traverseRagdollDeath = traverseData[ "traverseRagdollDeath" ];

		if( self.traverseRagdollDeath )
		{
			self TraverseStartRagdollDeath();
		}
	}

	self.traverseAnimRate = 1.0;
	if( IsDefined( traverseData[ "traverseAnimRate" ] ) )
	{
		self.traverseAnimRate = traverseData[ "traverseAnimRate" ];
	}

	self traverseMode( "nogravity" );
	self traverseMode( "noclip" );
 	
	if (!IsDefined(self.traverseStance))
	{
		// assume stand
		self.desired_anim_pose = "stand";
	}
	else
	{
		self.desired_anim_pose = self.traverseStance;
	}

	animscripts\utility::UpdateAnimPose();

	self.traverseStartNode = self GetNegotiationStartNode();
 	self.traverseEndNode = self GetNegotiationEndNode();
 	
    assert( IsDefined( self.traverseStartNode ) );
    assert( IsDefined( self.traverseEndNode ) );
    
    // orient to the Negotiation start node
	self OrientMode( "face angle", self.traverseStartNode.angles[1] );
	
	self.traverseStartZ = self.origin[2];
	
	toCover = false;
	if ( IsDefined( self.traverseToCoverAnim ) && IsDefined( self.node ) && self.node.type == traverseData[ "coverType" ] && DistanceSquared( self.node.origin, self.traverseEndNode.origin ) < 25 * 25 )
	{
		if ( AbsAngleClamp180( self.node.angles[1] - self.traverseEndNode.angles[1] ) > 160 )
		{
			toCover = true;
			self.traverseAnim = self.traverseToCoverAnim;
		}
	}

	if (IsArray(self.traverseAnim) && !self.traverseAnimIsSequence)
	{
		self.traverseAnim = random(self.traverseAnim);
	} 

	if (toCover)
	{	
		if (IsDefined(self.traverseToCoverSound))
		{
			self thread play_sound_on_entity(self.traverseToCoverSound);
		}
	}
	else
	{
		if (IsDefined(self.traverseSound))
		{
			self thread play_sound_on_entity(self.traverseSound);
		}
	}

	self DoTraverse_Animation();
	self traverseMode("gravity");

	if( self.traverseRagdollDeath )
	{
		self TraverseStopRagdollDeath();
	}
	
	if (self.delayedDeath)
	{
		/#
		self animscripts\debug::debugPopState( "traverse", "delayedDeath" );
		#/

		return;
	}
	
	self.a.nodeath = false;
	if (toCover && IsDefined(self.node) && DistanceSquared(self.origin, self.node.origin) < 16 * 16)
	{
		// if we're traversing into cover, align to the cover node
		self.a.movement = "stop";
		self Teleport( self.node.origin );	// TODO: this should probably lerp
	}
	else
	{
		if (IsDefined(self.traverseMovement))
		{
			self.a.movement = self.traverseMovement;
		}

		if (self.a.movement != "stop")
		{
			self SetAnimKnobAllRestart( animscripts\run::GetRunAnim(), %body, 1, .2, 1 );
		}
	}

	/#
	self animscripts\debug::debugPopState( "traverse" );
	#/

	// so that prevScript gets set correctly
	waittillframeend;
	self.a.script = "traverse";
}

DoTraverse_Animation()
{
	traverseAnim = self.traverseAnim;
	if (!IsArray(traverseAnim))
	{
		// make array
		traverseAnim = add_to_array(undefined, traverseAnim);
	}

	// clear root animation before playing the traverse animation, workaround for the network problem.
	self ClearAnim(%body, 0.2);

	played_trans_in = false;
	if (IsDefined(self.traverseAnimTransIn))
	{
		played_trans_in = true;

		self thread DoMainTraverse_AnimationAiming( self.traverseAnimTransIn, "traverseAnim" );

		self SetFlaggedAnimKnobRestart( "traverseAnim", self.traverseAnimTransIn, 1, 0.2, self.traverseAnimRate );

		if (traverseAnim.size || IsDefined(self.traverseAnimTransOut))
		{
			// don't blend into sequence anims
			self DoMainTraverse_Notetracks("traverseAnim");
		}
		else
		{
			// blend out if done with traversal
			self thread DoMainTraverse_Notetracks("traverseAnim");
			wait_anim_length(self.traverseAnimTransIn, .2, self.traverseAnimRate);
		}
	}

	const blend = .2;
	first = true;
	last = true;
	for (i = 0; i < traverseAnim.size; i++)
	{
		if (played_trans_in || i > 0 )
		{
			first = false; // start aiming on the first traverse anim
		}

		if (i < traverseAnim.size - 1)
		{
			last = false;
		}

		DoMainTraverse_Animation(traverseAnim[i], first, last);
	}

	if (IsDefined(self.traverseAnimTransOut))
	{
		self SetFlaggedAnimKnobRestart( "traverseAnim", self.traverseAnimTransOut, 1, 0, self.traverseAnimRate );
		self thread DoMainTraverse_Notetracks("traverseAnim");
		wait_anim_length(self.traverseAnimTransOut, .1, self.traverseAnimRate);
	}

	// make sure we kill any DoNotetrack threads still running because the anim is being blended out and won't send its own
	self notify( "traverseAnim", "end" );

	self animscripts\shared::stopTracking();
	self animscripts\run::stopShootWhileMovingThreads();
	self animscripts\weaponList::RefillClip();
}

DoMainTraverse_Animation(animation, first, last)
{
	if( first )
	{
		self thread DoMainTraverse_AnimationAiming( animation, "traverseAnim" );
		self SetFlaggedAnimKnobRestart( "traverseAnim", animation, 1, .2, self.traverseAnimRate );
	}
	else
	{
		self SetFlaggedAnimKnobRestart( "traverseAnim", animation, 1, 0, self.traverseAnimRate );
	}

	self thread TraverseRagdollDeath(animation);

	if( last && !IsDefined(self.traverseAnimTransOut) )
	{
		self thread DoMainTraverse_Notetracks("traverseAnim");
		wait_anim_length(animation, .2, self.traverseAnimRate);
	}
	else
	{
		self animscripts\shared::DoNoteTracks("traverseAnim");
	}
}

DoMainTraverse_AnimationAiming(animation, flag)
{
	self endon( "killanimscript" );
	self endon( "death" );
	self endon( "stop tracking" );

	if( self.traverseAllowAiming )
	{
		if( animHasNotetrack( animation, "start_aim" ) )
		{
			self waittillmatch( flag, "start_aim" );
		}

		self.a.isAiming = true;
		assert( IsDefined( self.traverseAimAnims ) );

		self SetAnimKnobLimited( self.traverseAimAnims["up"],		1, 0.2 );
		self SetAnimKnobLimited( self.traverseAimAnims["down"],		1, 0.2 );
		self SetAnimKnobLimited( self.traverseAimAnims["left"],		1, 0.2 );
		self SetAnimKnobLimited( self.traverseAimAnims["right"],	1, 0.2 );

		self.rightAimLimit	= 50;
		self.leftAimLimit	= -50;
		self.upAimLimit		= 50;
		self.downAimLimit	= -50;

		self animscripts\shared::setAimingAnims( %traverse_aim_2, %traverse_aim_4, %traverse_aim_6, %traverse_aim_8 );
		self animscripts\shared::trackLoopStart();

		self animscripts\weaponList::RefillClip();

		self.shoot_while_moving_thread = undefined;
		self thread animscripts\run::runShootWhileMovingThreads();
	}
}

DoMainTraverse_Notetracks( flagName )
{
	self notify("stop_DoNotetracks");

	self endon("killanimscript");
	self endon("stop_DoNotetracks");

	self animscripts\shared::DoNoteTracks( flagName, ::handleTraverseNotetracks );
}

wait_anim_length(animation, blend, rate)
{
	len = (GetAnimLength(animation) / rate) - blend;

	if (len > 0)
	{
		wait len;
	}
}

handleTraverseNotetracks( note )
{
	if ( note == "traverse_death" )
	{
		return handleTraverseDeathNotetrack();
	}
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

	if ( IsDefined( self.traverseHeight ) && IsDefined( self.traverseStartNode.traverse_height ) )
	{
		currentHeight = self.traverseStartNode.traverse_height - self.traverseStartZ;
		self thread teleportThread( currentHeight - self.traverseHeight );
	}
}

doNothingFunc()
{
	self AnimMode( "zonly_physics" );
	self waittill ( "killanimscript" );
}

traverseDeath()
{
	self notify("traverse_death");
	
	if ( !IsDefined( self.triedTraverseRagdoll ) )
		self animscripts\death::PlayDeathSound();
	
	deathAnimArray = self.traverseDeathAnim[ self.traverseDeathIndex ];
	deathAnim = deathAnimArray[ RandomInt( deathAnimArray.size ) ];

	assert( IsDefined(deathAnim), "Trying to do custom traverse death, but no death anim was specified" );

	if( IsDefined(deathAnim) )
	{
		animscripts\death::play_death_anim( deathAnim );
	}
	
	self DoDamage( self.health + 5, self.origin );
}


TraverseStartRagdollDeath()
{
	self.prevDelayedDeath = self.delayedDeath;
	self.prevAllowDeath = self.allowDeath;
	self.prevDeathFunction = self.deathFunction;
	
	self.delayedDeath = false;
	self.allowDeath = true;
	self.deathFunction = ::TraverseRagdollDeathSimple;
}

TraverseStopRagdollDeath()
{
	self.delayedDeath = self.prevDelayedDeath;
	self.allowDeath = self.prevAllowDeath;
	self.deathFunction = self.prevDeathFunction;

	self.prevDelayedDeath = undefined;
	self.prevAllowDeath = undefined;
	self.prevDeathFunction = undefined;
}

TraverseRagdollDeathSimple()
{
	assert(!IS_TRUE(self.magic_bullet_shield), "Cannot ragdoll death on guy with magic bullet shield.");
	
	self Unlink();
	self StartRagdoll();
	
	self animscripts\shared::DropAllAIWeapons();
	
	return true;
}

TraverseRagdollDeath( traverseAnim )
{
	self notify("TraverseRagdollDeath");
	self endon("TraverseRagdollDeath");

	self endon("traverse_death");
	self endon("killanimscript");
	
	while(1)
	{
		self waittill("damage");
		
		if ( !self.delayedDeath )
			continue;
		
		scriptedDeathTimes = GetNotetrackTimes( traverseAnim, "traverse_death" );
		currentTime = self GetAnimTime( traverseAnim );
		scriptedDeathTimes[ scriptedDeathTimes.size ] = 1.0;
		
		/#
		if ( getDebugDvarInt( "scr_forcetraverseragdoll" ) == 1 )
			scriptedDeathTimes = [];
		#/
		
		for ( i = 0; i < scriptedDeathTimes.size; i++ )
		{
			if ( scriptedDeathTimes[i] > currentTime )
			{
				animLength = GetAnimLength( traverseAnim );
				timeUntilScriptedDeath = (scriptedDeathTimes[i] - currentTime) * animLength;
				
				if ( timeUntilScriptedDeath < 0.5 )
				{
					return;
				}

				break;
			}
		}
		
		self.deathFunction = ::postTraverseDeathAnim;
		self.exception["move"] = ::doNothingFunc;
				
		self ragdoll_death();
		
		self.a.triedTraverseRagdoll = true;
		break;
	}
}

postTraverseDeathAnim()
{
	self endon( "killanimscript" );
	if ( !IsDefined( self ) )
		return;
	// in case the ragdoll failed
	deathAnim = animscripts\death::get_death_anim();
	self SetFlaggedAnimKnobAllRestart( "deathanim", deathAnim, %body, 1, .1 );

	if( animHasNoteTrack( deathAnim, "death_neckgrab_spurt" ) )
	{
		PlayFXOnTag( level._effects[ "death_neckgrab_spurt" ], self, "j_neck" );
	}
}

#using_animtree ("dog");

dog_wall_and_window_hop( traverseName, height )
{
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self GetNegotiationStartNode();
	assert( IsDefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	if (IsDefined(startnode.traverse_height))
	{
		realHeight = startnode.traverse_height - startnode.origin[2];
		self thread teleportThread( realHeight - height );
	}
		
	self ClearAnim(%root, 0.2);
	self SetFlaggedAnimRestart( "dog_traverse", anim.dogTraverseAnims[ traverseName ], 1, 0.2, 1);
	
	self animscripts\shared::DoNoteTracks( "dog_traverse" );
	
	self.traverseComplete = true;
}

dog_jump_down( height, frames )
{
	self endon("killanimscript");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self GetNegotiationStartNode();
	assert( IsDefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	self thread teleportThreadEx( 40.0 - height, 0.1, frames );

	self ClearAnim(%root, 0.2);
	self SetFlaggedAnimRestart( "traverse", anim.dogTraverseAnims["jump_down_40"], 1, 0.2, 1);
	self animscripts\shared::DoNoteTracks( "traverse" );
	
	self ClearAnim(anim.dogTraverseAnims["jump_down_40"], 0);	// start run immediately
	self traverseMode("gravity");
	self.traverseComplete = true;
}

dog_jump_up( height, frames )
{
	self endon("killanimscript");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self GetNegotiationStartNode();
	assert( IsDefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	self thread teleportThreadEx( height - 40.0, 0.2, frames );

	self ClearAnim(%root, 0.25);
	self SetFlaggedAnimRestart( "traverse", anim.dogTraverseAnims["jump_up_40"], 1, 0.2, 1);
	self animscripts\shared::DoNoteTracks( "traverse" );
	
	self ClearAnim(anim.dogTraverseAnims["jump_up_40"], 0);	// start run immediately
	self traverseMode("gravity");
	self.traverseComplete = true;
}