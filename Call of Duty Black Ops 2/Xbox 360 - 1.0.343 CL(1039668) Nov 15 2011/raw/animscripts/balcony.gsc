#include common_scripts\utility;
#include animscripts\utility;
#include animscripts\anims;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;

#using_animtree("generic_human");

//PARAMETER CLEANUP - removed shitloc as unused, one caller affected
balconyDamage(iDamage, /*sHitLoc,*/ sMeansOfDeath)
{
	if (IS_TRUE(self.a.doingBalconyDeath))
	{
		self.health = iDamage + 1;	// keep alive while doing balcony anim
	}
	else if (self.health <= iDamage) // should die
	{
		if (canDoBalcony(sMeansOfDeath))
		{
			self.do_balcony_death_now = true;
			self.health = iDamage + 1;	// so we don't actually die, but do go into pain
		}

		return true;
	}

	return false;
}

canDoBalcony(sMeansOfDeath)
{
	if (IS_TRUE(self.a.doingBalconyDeath))
	{
		/#debug_balcony("not doing balcony death: already doing it.");#/
		return false;
	}

	self.balcony_node = getBalconyNode();
	if (!IsDefined(self.balcony_node))
	{
		return false;
	}
	else if( IsDefined(self.balcony_node.balconyDeathCounter) && self.balcony_node.balconyDeathCounter > 0 ) // don't play consecutive balcony deaths off the same node
	{
		/#debug_balcony("not doing balcony death: balconyDeathCounter is at " + self.balcony_node.balconyDeathCounter);#/
		self.balcony_node.balconyDeathCounter--;
		return false;
	}

	if (is_false(self.allowPain))
	{
		/#debug_balcony("not doing balcony death: pain is disabled.");#/
		return false;
	}

	if( call_overloaded_func( "animscripts\pain", "isExplosiveDamageMOD", sMeansOfDeath ) )
	{
		/#debug_balcony("explosive damage");#/
		return false;
	}

	if( self.a.pose != "stand" )
	{
		if( self.a.pose == "crouch" && !isBalconyNodeNoRailing(self.balcony_node) )
		{
			/#debug_balcony("crouching and at railing");#/
			return false;
		}
		else if( self.a.pose != "crouch" )
		{
			/#debug_balcony("not standing or crouching");#/
			return false;
		}
	}

	if( IsDefined(self.balcony_node.script_balconydeathchance) )
	{
		if( RandomFloat(1) > self.balcony_node.script_balconydeathchance )
			return false;
	}

	return true;
}

getBalconyNode()
{
	balcony_node = undefined;

	if (self.a.movement == "stop")
	{
		if (IsDefined(self.node) && isBalconyNode(self.node))
		{
			if (check_ang_and_dist_to_node(self.node))
			{
				balcony_node = self.node;
				/#debug_balcony("on a balcony node (self.node).");#/
			}
		}
		else if (IsDefined(self.covernode) && isBalconyNode(self.covernode))
		{
			if (check_ang_and_dist_to_node(self.covernode))
			{
				balcony_node = self.covernode;
				/#debug_balcony("on a balcony node (self.covernode).");#/
			}
		}
	}	
	
	if (!IsDefined(balcony_node))
	{
		nodes = anim.balcony_nodes;

		for (i = 0; i < nodes.size; i++)
		{
			node = nodes[i];
			if (check_ang_and_dist_to_node(node))
			{
				balcony_node = node;
				break;
			}
		}

// 		/# // causing infinite loop in release in one special situation
// 		
// 			if (!IsDefined(balcony_node))
// 			{
// 				node = getClosest(self.origin, anim.balcony_nodes);
// 				if (IsDefined(node))
// 				{
// 					node_angle = AbsAngleClamp180(node.angles[1]);
// 					ai_angle = AbsAngleClamp180(self.angles[1]);
// 
// 					ang_diff = abs(node_angle - ai_angle);
// 
// 					debug_balcony("Closest balcony node dist: " + Distance2D(node.origin, self.origin) + " angle: " + ang_diff);
// 				}
// 			}
// 
// 		#/
	}

	return balcony_node;
}

check_ang_and_dist_to_node(node)
{
	const MAX_DIST = 30 * 30;
	const MAX_DIST_BEHIND_NODE = 30 * 30;
	const MAX_ANGLE = 75;

	dist = DistanceSquared(self.origin, node.origin);

	if (dist <= MAX_DIST)
	{
		node_angle = AbsAngleClamp180(node.angles[1]);
		ai_angle = AbsAngleClamp180(self.angles[1]);

		ang_diff = abs(node_angle - ai_angle);

		if (ang_diff <= MAX_ANGLE)
		{
			vec = self.origin - node.origin;
			dot = VectorDot(VectorNormalize(vec), AnglesToForward(node.angles));

			/#debug_balcony_line( node.origin, self.origin, (1, 1, 0));#/

			if (dot >= -.1)
			{
				/#debug_balcony("In front of balcony node. dot = " + dot);#/
				return true;
			}
			else
			{
				/#debug_balcony("Behind balcony node. dot = " + dot);#/

				if ( dist <= MAX_DIST_BEHIND_NODE )
				{
					return true;
				}
			}
		}
	}

	return false;
}

/* -------------------------------------------------------------------------------
Called from pain script
-------------------------------------------------------------------------------- */
tryBalcony()
{
	if (IS_TRUE(self.a.doingBalconyDeath))
	{
		return true;	// block any further pain
	}

	if (IS_TRUE(self.do_balcony_death_now))
	{
		self AnimCustom(::doBalcony);
		return true;
	}
	else
	{
		return false;
	}
}

doBalcony()
{
	self.a.doingBalconyDeath = true;

	self thread kill_animscript();

	assert( IsDefined(self.balcony_node) );

	if( !IsDefined(self.balcony_node) )
	{
		return;
	}

	balconyNodeType = "balcony_norailing";
	if (!isBalconyNodeNoRailing(self.balcony_node))
	{
		balconyNodeType = "balcony";
	}

	// these prevent breaking out of animcustom
	disable_pain();
	disable_react();

	// no animation support for crouch balcony deaths, so use ragdoll instead
	if (self.a.pose == "crouch" && balconyNodeType == "balcony_norailing")
	{
		forward = AnglesToForward( self.angles );
		if( IsDefined(self.balcony_node) )
		{
			forward = AnglesToForward( self.balcony_node.angles );
		}

		// start ragdoll and do a little forward push
		self StartRagdoll();
		self LaunchRagdoll( VectorScale( forward, RandomIntRange(25,35) ), "tag_eye" );

		// make sure the AI gets killed
		self do_ragdoll_death();

		return;
	}

	// don't do consecuitve balcony deaths from the same node
	self.balcony_node.balconyDeathCounter = RandomIntRange(1,3);

	// slowly teleport towards the node origin
	self thread getCloserToBalconyNode( self.balcony_node.origin, self.balcony_node.angles, 0.2 );
	
	animation = animArrayPickRandom(balconyNodeType, "combat");
	if (IsDefined(animation))
	{
		self.a.nodeath = true;
		self AnimMode("noclip");
		self SetFlaggedAnimKnobAll( "balcony", animation, %body, 1, 0.1, 1 );
		self animscripts\shared::DoNoteTracks( "balcony" );
	}
}

// bring the AI closer to the node origin since it can actually start playing the animation when it's quite a few units away
// and we want to make sure that it doesn't fall into the geo
getCloserToBalconyNode( origin, angles, moveTime )
{
	self endon("death");
	self endon("killanimscript");

	/#debug_balcony("Teleporting to balcony node.");#/

	startAngles = self.angles;

	moveVector = VectorScale( origin - self.origin, 0.05 / moveTime );

	timer = 0;
	while( timer < moveTime )
	{
		timer += 0.05;
		lerpVar = timer / moveTime;

		newOrigin = self.origin + moveVector;
		newAngles = ( AngleLerp(startAngles[0], angles[0], lerpVar), AngleLerp(startAngles[1], angles[1], lerpVar), AngleLerp(startAngles[2], angles[2], lerpVar) );

		self ForceTeleport( newOrigin, newAngles );

		wait(0.05);
	}
}

kill_animscript()
{
	// Fail-safe to die if something else tries to interrupt balcony death
	self endon("death");
	self waittill("killanimscript");
	self do_ragdoll_death();
}

/#
debug_balcony( msg )
{
	PrintLn( msg );
	recordEntText( msg, self, level.color_debug["white"], "Cover" );
}

debug_balcony_line( start, end, color )
{
	recordLine( start, end, color, "Cover", self );
}
#/