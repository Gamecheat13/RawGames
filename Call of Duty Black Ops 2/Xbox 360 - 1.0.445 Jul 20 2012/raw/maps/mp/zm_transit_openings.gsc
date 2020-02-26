#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_utility;

#include maps\mp\zm_transit_utility;

#insert raw\common_scripts\utility.gsh;

#define EXIT_BUS_DIST		( 3 * 3 )


/////////////////////////////////////////////////////////////////////////////////
// Zombie Bus Openings
//
// This file handles all the "openings" on the bus: doors, windows, etc.
//
// Each opening is possibly a location where a zombie can climb through and a
// set of repairable wooden boards can be placed.
/////////////////////////////////////////////////////////////////////////////////
	
main()
{
	// setup the list of tags and their positions
	self _busInitTags();

	self _setupNumAttachTable();

	self.openings = [];
	entryPoints = GetEntArray("bus_entry_point", "targetname");
	if(IsDefined(entryPoints))
	{
		for(i = 0; i < entryPoints.size; i++)
		{
			// Exclude Bus Driver Window
			//--------------------------
			if ( IsDefined( entryPoints[ i ].target ) &&
					entryPoints[ i ].target == "bus_attach_front_right" )
			{
				entryPoints[i] Delete();
				GetEnt( "bus_attach_front_right", "targetname" ) Delete();
				
				continue;
			}			
			
			self busAddOpening(entryPoints[i]);
		}
	}
	
	self busSetupRoofOpening();
	self busInitMantle();
}
   
busAddOpening( ent )
{
	index = self.openings.size;
	self.openings[index] = spawnstruct();

	opening 				= self.openings[index];
	opening.name			= ent.script_noteworthy;
	opening.enabled 		= true;				// TODO: delete this, and instead just delete the trigger to "disable" zombies from climbing in
	opening.zombie 			= undefined;
	opening.boards			= [];
	opening.boardsNum		= 0;
	opening.blockerTrigger	= undefined;
	opening.zombieTrigger	= undefined;
	opening.rebuildTrigger	= undefined;

	opening.bindTag = _busFindClosestTag(ent.origin);
	Assert(IsDefined(opening.bindTag));
	opening.jumpTag = _busGetJumpTagFromBindTag(opening.bindTag);
	opening.jumpEnt = ent;
	opening.roofJoint = _busGetRoofJointFromBindTag(opening.bindTag);
	opening.origin = level.the_bus GetTagOrigin(opening.bindTag);
	self busAttachJumpEnt(ent, opening);

	if (!IsDefined(ent.target))
	{
		assert(0);	// an entry point with no zombie trigger...  something is busted here
		return;
	}
	
	targets = GetEntArray(ent.target, "targetname");
	if (!IsDefined(targets))
	{
		assert(0);
		return;
	}
	
	if(!is_Classic())
	{
		for(i = 0; i < targets.size; i ++)
		{
			if(targets[i] IsZBarrier())
			{
				targets[i] delete();
			}
		}
		return;
	}
	
	for (i=0; i<targets.size; i++)
	{
		target = targets[i];
		
		// Add The Blocking Trigger (Player Placable Window Blocker)
		//-----------------------------------------------------------
		if(target IsZBarrier())
		{
			opening.zbarrier = target;
			opening.zbarrier.chunk_health = [];
			
			maps\mp\zombies\_zm_powerups::register_carpenter_node(opening, ::post_carpenter_callback);
			
			for( j = 0; j < opening.zbarrier GetNumZBarrierPieces(); j ++)
			{
				opening.zbarrier.chunk_health[j] = 0;
			}
			
			target.origin = level.the_bus GetTagOrigin(opening.bindTag);
		}
		else if (target.script_noteworthy == "blocker")
		{
			opening.blockerTrigger 	= target;
			opening.blockerTrigger 	enableLinkTo();
			opening.blockerTrigger LinkTo( self );
			opening.blockerTrigger 	SetCursorHint( "HINT_NOICON" );
			opening.blockerTrigger 	SetHintString( "Hold [{+activate}] To Place The Barricade Here" );
			opening.blockerTrigger 	SetInvisibleToAll();
			opening.blockerTrigger SetMovingPlatformEnabled( true );
			
			self thread busOpeningBlockerThink( opening );
			//opening.blockerTrigger Delete();
			continue;
		}

		// Add The Rebuild Trigger (For Players Rebulding Barriers)
		//-----------------------------------------------------------
		else if (target.script_noteworthy == "rebuild")
		{
			opening.rebuildTrigger 	= target;
			opening.rebuildTrigger 	enableLinkTo();
			opening.rebuildTrigger LinkTo( self );
			opening.rebuildTrigger 	SetCursorHint( "HINT_NOICON" );
			opening.rebuildTrigger 	set_hint_string( self, "default_reward_barrier_piece" );
			opening.rebuildTrigger 	SetInvisibleToAll();
			opening.rebuildTrigger SetMovingPlatformEnabled( true );
			
			self thread busOpeningRebuildThink( opening );
			//opening.rebuildTrigger Delete();
			continue;
		}
		
		// Add The Zombie Trigger (For Zombies Climbing Through)
		//-----------------------------------------------------------	
		else if (target.script_noteworthy == "zombie")
		{
			opening.zombieTrigger 	= target;
			opening.zombieTrigger 	enableLinkTo();
			opening.zombieTrigger LinkTo( self );
			opening.zombieTrigger SetMovingPlatformEnabled( true );
			self thread busOpeningZombieThink( opening );
		}

		target linkTo( self, "", self worldtolocalcoords(target.origin), target.angles - self.angles);
	}

	if(isdefined(opening.zbarrier))
	{
		opening blocker_attack_spots();
	}
	
	assert( opening.boardsNum==0 || opening.boardsNum==opening.boards.size );
}

post_carpenter_callback()
{
	if(isdefined(self.rebuildTrigger))
	{
		self.rebuildTrigger SetInvisibleToAll();
	}
}

busInitMantle()
{
	mantleBrush = GetEntArray("window_mantle", "targetname");
	
	if( IsDefined(mantleBrush) && mantleBrush.size > 0 )
	{
		for( i = 0; i < mantleBrush.size; i++)
		{
			mantleBrush[i] Delete(); //*T6 TEMP Delete
			//mantleBrush[i] linkto( self, "", self worldToLocalCoords(mantleBrush[i].origin), (0,0,0) );
			//mantleBrush[i] SetMovingPlatformEnabled( true );
		}
	}
}

// attaches the jump entity exactly at the openings jump_origin
busAttachJumpEnt(ent, opening)
{
	jump_origin = self gettagorigin( opening.jumpTag );
	jump_angles = self gettagangles( opening.jumpTag );
	ent.origin = jump_origin;
	ent.angles = jump_angles;
	ent linkto(self, "", self worldtolocalcoords(ent.origin), ent.angles - self.angles);
}

busOpeningSetEnabled(name, enabled)
{
	for (i=0; i<self.openings.size; i++)
	{
		opening = self.openings[i];
		if (IsDefined(opening.name) && opening.name == name)
		{
			opening.enabled = enabled;
		}
	}	
}


_busInitTags()
{
	self.openingTags = [];

	self.openingTags[self.openingTags.size] = "window_right_front_jnt";
	self.openingTags[self.openingTags.size] = "window_left_front_jnt";
	self.openingTags[self.openingTags.size] = "door_front_jnt";
	self.openingTags[self.openingTags.size] = "door_rear_jnt";
	self.openingTags[self.openingTags.size] = "window_right_1_jnt";
	self.openingTags[self.openingTags.size] = "window_right_2_jnt";		
	self.openingTags[self.openingTags.size] = "window_right_3_jnt";
	self.openingTags[self.openingTags.size] = "window_right_4_jnt";
	self.openingTags[self.openingTags.size] = "window_right_rear_jnt";
	self.openingTags[self.openingTags.size] = "window_left_rear_jnt";
	self.openingTags[self.openingTags.size] = "window_left_1_jnt";
	self.openingTags[self.openingTags.size] = "window_left_2_jnt";
	self.openingTags[self.openingTags.size] = "window_left_3_jnt";
	self.openingTags[self.openingTags.size] = "window_left_4_jnt";
	self.openingTags[self.openingTags.size] = "window_left_5_jnt";

	/#
	for ( i = 0; i < self.openingTags.size; i++ )
	{
		AddDebugCommand( "devgui_cmd \"Zombies:1/Bus:14/Window Openings:3/Select Tag:1/" + self.openingTags[i] + ":" + self.openingTags.size + "\" \"zombie_devgui attach_tag " + self.openingTags[i] + "\"\n" );
	}
	#/

}

_busFindClosestTag(checkPos)
{
	closest = undefined;
	closestDist = -1.0;

	Assert( IsDefined(self.openingTags) );

	for ( i = 0; i < self.openingTags.size; i++ )
	{
		tag = self.openingTags[i];
		pos = self GetTagOrigin(tag);

		dist2 = DistanceSquared(checkPos, pos);
		if ( !IsDefined(closest) || dist2 < closestDist )
		{
			closest = tag;
			closestDist = dist2;
		}
	}

	return closest;
}

// mapping function that returns the appropriate jump tag for the opening based on the bing tag (joint of opening)
_busGetJumpTagFromBindTag(tag)
{
	jump_tag = undefined;
	switch( tag )
	{
		case "window_right_1_jnt":
			jump_tag = "window_right_1_jmp_jnt";
			break;
		case "window_right_2_jnt":
			jump_tag = "window_right_2_jmp_jnt";
			break;
		case "window_right_3_jnt":
			jump_tag = "window_right_3_jmp_jnt";
			break;
		case "window_right_4_jnt":
			jump_tag = "window_right_4_jmp_jnt";
			break;
		case "window_left_1_jnt":
			jump_tag = "window_left_1_jmp_jnt";
			break;
		case "window_left_2_jnt":
			jump_tag = "window_left_2_jmp_jnt";
			break;
		case "window_left_3_jnt":
			jump_tag = "window_left_3_jmp_jnt";
			break;
		case "window_left_4_jnt":
			jump_tag = "window_left_4_jmp_jnt";
			break;
		case "window_left_5_jnt":
			jump_tag = "window_left_5_jmp_jnt";
			break;
		case "window_right_rear_jnt":
			jump_tag = "window_right_rear_jmp_jnt";
			break;
		case "window_left_rear_jnt":
			jump_tag = "window_left_rear_jmp_jnt";
			break;
		case "window_right_front_jnt":
			jump_tag = "window_right_front_jmp_jnt";
			break;
		case "window_left_front_jnt":
			jump_tag = "window_left_front_jmp_jnt";
			break;
		case "door_rear_jnt":
			jump_tag = "door_rear_jmp_jnt";
			break;
		case "door_front_jnt":
			jump_tag = "door_front_jmp_jnt";
			break;
		default:
			break;
	}
	
	return jump_tag;
}

// mapping function that returns the appropriate roof bind joint based on the bing tag of the opening (joint of opening)
_busGetRoofJointFromBindTag(tag)
{
	roofJoint = undefined;
	switch( tag )
	{
		case "window_left_front_jnt":
		case "window_right_front_jnt":
		case "window_right_1_jnt":
		case "window_left_1_jnt":
			roofJoint = "window_roof_1_jnt";
			break;
		case "window_right_2_jnt":
		case "window_right_3_jnt":
		case "window_right_4_jnt":
		case "window_left_2_jnt":
		case "window_left_3_jnt":
		case "window_left_4_jnt":
		case "window_left_5_jnt":
		case "window_right_rear_jnt":
		case "window_left_rear_jnt":
			roofJoint = "window_roof_2_jnt";
		default:
			break;
	}
	
	return roofJoint;
}

_setupNumAttachTable()
{
	// -1 means no limit
	level.numAttachTable = [];
	level.numAttachTable[0] = -1;
	level.numAttachTable[1] = 6;
	level.numAttachTable[2] = 8;
	level.numAttachTable[3] = 10;
	level.numAttachTable[4] = -1;
}

busGetOpeningForTag(tagName)
{
	for ( i = 0; i < self.openings.size; i++ )
	{
		if ( self.openings[i].bindTag == tagName )
		{
			return self.openings[i];
		}
	}

	return undefined;
}

zombieAnimNotetrackThink(notifyString, chunk, node)
{
	self endon("death");
	
	while ( 1 ) 
	{
		self waittill( notifyString, notetrack );
		if ( notetrack == "end" )
		{
			return;
		}
		else if (notetrack=="board"  || notetrack == "destroy_piece")
		{

			node.zbarrier SetZBarrierPieceState(chunk, "opening");
			
			if (IsDefined(node.rebuildTrigger))
			{
				node.rebuildTrigger SetVisibleToAll();
			}					
		}	
		else if (notetrack == "fire")
		{
			attackPlayers = self zombieGetPlayersToAttack();
			if ( attackPlayers.size )
			{
				for ( i = 0; i < attackPlayers.size; i++ )
				{
					attackPlayers[i] DoDamage( self.meleeDamage, self.origin, self, self, "none", "MOD_MELEE" );
				}
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////
// Zombie Bus Openings Threads
/////////////////////////////////////////////////////////////////////////////////
busOpeningBlockerThink( opening )
{
	self endon("intermission");
	// THREAD NOTES:
	// SELF == the bus
	//
	// This thread waits for a player to activate a blocker trigger
	// on a bus opening.  
	//
	while (1)
	{
		opening.blockerTrigger waittill("trigger", player);
		if (IsDefined(opening.zombie))
		{
			continue;	// Player tried to place a board on an opening while a zombie was in it (or at least still registered to it)...
						// TODO: Handle this case better - maybe kill the zombie first?
		}
		break;
	}
	self notify("OnBlockerPlaced", opening);
}

busOpeningRebuildThink( opening )
{
	self endon("intermission");
	// THREAD NOTES:
	// SELF == the bus
	//
	// This thread waits for a player to activate a rebuild trigger
	// on a bus opening.  
	//

	cost = 10;
	if( IsDefined( opening.rebuildTrigger.zombie_cost ) )
	{
		cost = opening.rebuildTrigger.zombie_cost; 
	}
	
	while (1)
	{
		opening.rebuildTrigger waittill("trigger", player);
		
		players = GET_PLAYERS();
		
		has_perk = player has_blocker_affecting_perk();

		while (1)
		{
			if(player_fails_blocker_repair_trigger_preamble(player, players, opening.rebuildTrigger))
			{
				break;
				
			}
			
			if( all_chunks_intact( opening ) ) // barrier chunks are all the pieces targeted from the exterior_goal
			{
				break;
			}
	
			if( no_valid_repairable_boards( opening ) ) // barrier chunks are all the pieces targeted from the exterior_goal
			{
				break;
			}			
		
			chunk = get_random_destroyed_chunk(opening );
			
			self thread replace_chunk( opening , chunk, has_perk, is_true( player.pers_upgrades_awarded["board"] ) ); // writing out			
			
			if(no_valid_repairable_boards( opening ))
			{
				opening.rebuildTrigger SetInvisibleToAll();
			}
			
			opening do_post_chunk_repair_delay(has_perk);

			if( !is_player_valid( player ) )
			{
				break;
			}

			player handle_post_board_repair_rewards(cost);
		}
	}
}

// returns the position of the tag from which the zombie will need to jump from (either door or window)
_determineJumpFromOrigin(opening)
{
	return level.the_bus gettagorigin( opening.jumpTag );
}

// return the side of the bus as a string that the opening is on
// possible returns: undefined, "right", "left", "front", "back"
_getSideOfBusOpeningIsOn(opening_tag)
{
	side = undefined;
	switch ( opening_tag )
	{
		case "door_front_jnt":
		case "door_rear_jnt":
		case "window_right_1_jnt":
		case "window_right_2_jnt":
		case "window_right_3_jnt":
		case "window_right_4_jnt":
			side = "right";
			break;
		case "window_left_1_jnt":
		case "window_left_2_jnt":
		case "window_left_3_jnt":
		case "window_left_4_jnt":
		case "window_left_5_jnt":
			side = "left";
			break;
		case "window_left_front_jnt":
		case "window_right_front_jnt":
			side = "front";
			break;
		case "window_right_rear_jnt":
		case "window_left_rear_jnt":
			side = "back";
			break;
	}
	return side;
}

busOpeningZombieThink( opening )
{
	self endon("intermission");
	// THREAD NOTES:
	// SELF == the bus	
	//
	// This thread handles attaching zombies to openings
	//

	while (1)
	{
		wait(0.1);
		opening.zombieTrigger waittill("trigger", zombie);

		if( zombie.isdog )
		{
			continue;
		}

		if( isdefined(zombie.isscreecher) && zombie.isscreecher )
		{
			continue;
		}

		if ( !IsAlive(zombie) )
		{
			continue;
		}
		
		// we want the zombies to jump on the bus if a player is clinging while it is moving
		if ( level.the_bus.isMoving  && self.numAlivePlayersRidingBus == 0 )
		{
			continue;
		}
		
		// we don't want the zombies to consider players on the bus if it is moving (for jumping on purposes)
		num_players_clinging = maps\mp\zm_transit_cling::_getNumPlayersClinging();	
		num_players_on_bus_not_clinging = self.numAlivePlayersRidingBus - num_players_clinging;
		if ( !level.the_bus.isMoving && num_players_on_bus_not_clinging == 0 )
		{
			continue;
		}

		if ( !opening.enabled )
		{
			continue;
		}

		if ( is_true( zombie.isOnBus )  )
		{
			continue;
		}

		if ( IsDefined(zombie.opening) )
		{
			continue;
		}

		if ( IsDefined(opening.zombie) )
		{
			continue;
		}

		if ( IsDefined(zombie.cannotAttachToBus) && zombie.cannotAttachToBus )
		{
			continue;
		}

		canAttach = level.the_bus _busCanZombieAttach(zombie);
		if ( !canAttach )
		{
			continue;
		}

		if ( !level.the_bus.isMoving )
		{
			// get the origin the zombie will need to jump from for this opening
			jump_origin = _determineJumpFromOrigin( opening );
			// make sure the zombie is close to the jump point or else he will noticely pop (the bus isn't moving)
			distance_from_jump_origin2 = distance2DSquared(jump_origin, zombie.origin);
			//thread debugLine(jump_origin, (0,0,1), 200);
			//thread debugLine(zombie.origin, (0,1,1), 200);
			// the smaller this is the better, but it sometimes causes them to not have a path and go into combat
			if ( distance_from_jump_origin2 > 3*3 )
			{
				continue;
			}
		}


		zombie thread zombieAttachToBus(self, opening);
	}
}

// self == bus
_busCanZombieAttach(zombie)
{

	currentlyAttached = 0;
	for ( i = 0; i < self.openings.size; i++ )
	{
		if ( IsDefined(self.openings[i].zombie) )
		{
			currentlyAttached++;
		}
	}

	players = Get_Players();
	maxAttach = level.numAttachTable[players.size];

	return maxAttach < 0 || currentlyAttached < maxAttach;
}



/////////////////////////////////////////////////////////////////////////////////
// Zombie Bus Openings Utility Functions
/////////////////////////////////////////////////////////////////////////////////
zombiePlayAttachedAnim( animName )
{
	self endon("death");

	anim_index		= self GetAnimSubStateFromASD( "zm_bus_attached", animName );
	animationID		= self GetAnimFromASD( "zm_bus_attached", anim_index );
	tag_origin 		= self.attachEnt gettagorigin( self.attachTag );
	tag_angles 		= self.attachEnt gettagangles( self.attachTag );
	start_origin 	= getstartorigin( tag_origin, tag_angles, animationID );
	start_angles 	= getstartangles( tag_origin, tag_angles, animationID );

	self AnimScripted( start_origin, start_angles, "zm_bus_attached", anim_index );
	self zombieAnimNotetrackThink( "bus_attached_anim" );
}

debugLine(fromPoint, color, durationFrames)
{
	/#
	for (i=0;i<durationFrames;i++)
	{
		line (fromPoint, (fromPoint[0], fromPoint[1], fromPoint[2] + 50), color);
		wait (0.05);
	}
	#/
}

debugBox(fromPoint, color, durationFrames)
{
	/#
	for (i=0;i<durationFrames;i++)
	{
		Box ( fromPoint, (-1,-1,-1), (1, 1, 1), 0, color );
		wait (0.05);
	}
	#/
}

// returns true if the opening is a door
_isOpeningDoor(opening_tag)
{
	is_door = false;
	switch ( opening_tag )
	{
		case "door_front_jnt":
		case "door_rear_jnt":
			is_door = true;
			break;
		default:
			break;
	}
	return is_door;
}

teleportThreadEx( verticalOffset, delay, frames )
{
//	self endon ("killanimscript");
//	self notify("endTeleportThread");
//	self endon("endTeleportThread");

//	if ( verticalOffset == 0 )
//		return;

//	wait delay;
	
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


/*moveIntoBus( time )
{
	self endon("death");
	self endon("removed");
	self endon("sonicBoom");
	level endon( "intermission" );
	self notify("stop_find_flesh");
	self notify("zombie_acquire_enemy");
	self endon("detach_on_window");

	pos_offset = ( 0.0, 0.0, 0.0 );
	ang_offset = ( 0.0, 0.0, 0.0 );

	//while( 1 )
	{
		pos_offset = pos_offset + ( 30.0, 0.0, 0.0 );		
		self.attachScriptOrigin LinkToUpdateOffset( pos_offset, ang_offset );
		wait( 0.05 );
		self teleport( self.attachScriptOrigin.origin );
		
	//	wait( 0.1 );
	}
}*/


zombieAttachToBus( theBus, opening, removeAfterDone )
{
// Setup Override Conditions
//---------------------------
	self endon("death");
	self endon("removed");
	self endon("sonicBoom");
	level endon( "intermission" );
	self notify("stop_find_flesh");
	self notify("zombie_acquire_enemy");
	self endon("detach_on_window");
//-----------------



// Init Attachment
//-----------------
	opening.zombie 	= self;

	//self DisableAimAssist();
	self.forceMovementScriptState = true;
	self TraverseMode( "noclip");

	//make sure we clean up opening triggers on death
	self.opening 		= opening;
	self.isOnBus 		= true;
	self.isOnBusRoof 	= false;
//-----------------



// Jump To The Bus
//-----------------
	self.attachEnt		= opening.jumpEnt; //level.the_bus;
	self.attachTag		= "tag_origin"; //self.opening.jumpTag;

	left_or_right = "_l";
	
	// TODO - Random, or based off of zombie's gib status.
	// TODO - Disable gibbing on zombie here.
	
	if(randomintrange(0,10) >= 5)
	{
		left_or_right = "_r";
	}

	self LinkTo(self.attachEnt, self.attachTag, (0,0,0), (0,0,0));
	wait_network_frame();
	
	from_front = false;
	from_rear = false;
	
	if ( opening.bindTag == "door_front_jnt" || opening.bindTag == "door_rear_jnt" )
	{
		self AnimScripted( self.origin, self.angles, "zm_jump_on_bus", 0 ); 
		
		if(opening.bindTag == "door_front_jnt")
		{
			from_front = true;
		}
		else
		{
			from_rear = true;
		}
	}
	else
	{
		self AnimScripted( opening.zbarrier.origin, opening.zbarrier.angles, "zm_zbarrier_jump_on_bus", "jump_window" + left_or_right ); 
	}

	self zombieAnimNotetrackThink( "jump_on_bus_anim" );
	
	self Unlink();

	//-----------------



// Alert The Players That A Zombie Has Attached To The Bus
//---------------------------------------------------------
	if (true)// TODO: put this in a thread and wait for the notify from the anim at the exact moment he latches on
	{
		// Push The Bus
		hitpos 		= self.attachEnt GetTagOrigin(self.attachTag);
		hitposInBus = PointOnSegmentNearestToPoint(theBus.frontWorld, theBus.backWorld, hitpos);
		hitdir 		= vectornormalize(hitposInBus - hitpos);
		hitforce	= VectorScale(hitdir, 100.0);
		hitpos		+= (0,0,50);								// put it up more at eye hight so that it tips the bus more than slides it
//		theBus launchVehicle(hitforce, hitpos, false, false);

		// Shake The Camera
		EarthQuake( RandomFloatRange( 0.3, 0.4 ), RandomFloatRange(0.2, 0.4), hitpos, 150 );
	
		// Play A Sound
		play_sound_at_pos( "grab_metal_bar", hitpos );
	}
//-----------------	



// Attach to window position
//--------------------------
	self.attachEnt 	= level.the_bus;
	self.attachTag	= self.opening.bindTag;
	
	self LinkTo(self.attachEnt, self.attachTag, (0,0,0), (0,0,0));
	wait_network_frame();
	
	animRate = self zombieGetWindowAnimRate();

	if ( self zombieCanJumpOnRoof(opening) )
	{
// Jump to the Roof
// ----------------
		// Have a zombie jump up to the roof on a timer instead of ripping off boards
		self zombieJumpOnRoof( theBus, opening, removeAfterDone, left_or_right );
		self zombieSetNextTimeToJumpOnRoof();
	}
	else
	{
		
		while(1)
		{
			if( !isdefined(opening.zbarrier) || maps\mp\zombies\_zm_spawner::get_attack_spot( opening ) )
			{
				break;
			}		
		/#	println("Zombie failed to get bus attack spot");	#/
			wait( 0.5 );
			continue;
		}
// Rip Off Any Boards
//--------------------
		while(!all_chunks_destroyed( opening ))
		{	
			// check to see if we should detach
			if ( zombieShouldDetachFromWindow() )
			{
				zombieDetachFromBus();
				return;
			}
			self.onBusWindow = true;

			chunk = get_closest_non_destroyed_chunk( self.origin, opening );			
			
			if(IsDefined(chunk))
			{
				opening.zbarrier SetZBarrierPieceState(chunk, "targetted_by_zombie");
				opening thread check_zbarrier_piece_for_zombie_death(chunk, opening.zbarrier, self);
				
				self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "teardown", self.animname );
				
				animStateBase = opening.zbarrier GetZBarrierPieceAnimState(chunk);
				animSubState = "spot_" + self.attacking_spot_index + left_or_right + "_piece_" + opening.zbarrier GetZBarrierPieceAnimSubState(chunk);
				
				anim_sub_index	= self GetAnimSubStateFromASD( animStateBase + "_in", animSubState );				
	
				tag_origin = self.attachEnt gettagorigin( self.attachTag );
				tag_angles = self.attachEnt gettagangles( self.attachTag );				
				
	            self AnimScripted( tag_origin, tag_angles, maps\mp\animscripts\zm_utility::append_missing_legs_suffix( animStateBase + "_in" ), anim_sub_index );
				self zombieAnimNotetrackThink( "board_tear_bus_anim", chunk, opening );
				
				while(0 < opening.zbarrier.chunk_health[chunk])
				{
					
					tag_origin 	= self.attachEnt gettagorigin( self.attachTag );
					tag_angles 	= self.attachEnt gettagangles( self.attachTag );		
				
					self AnimScripted( tag_origin, tag_angles, maps\mp\animscripts\zm_utility::append_missing_legs_suffix( animStateBase + "_loop" ), anim_sub_index );
					self zombieAnimNotetrackThink( "board_tear_bus_anim", chunk, opening );

            		opening.zbarrier.chunk_health[chunk]--;
				}	

				tag_origin = self.attachEnt gettagorigin( self.attachTag );
				tag_angles = self.attachEnt gettagangles( self.attachTag );						
				
	            self AnimScripted( tag_origin, tag_angles, maps\mp\animscripts\zm_utility::append_missing_legs_suffix( animStateBase + "_out" ), anim_sub_index );
	            self zombieAnimNotetrackThink( "board_tear_bus_anim", chunk, opening );				
			}
			
			self zombieTryAttackThroughWindow(true, left_or_right);
		}

		self.onBusWindow = undefined;
		self notify( "off_window" );
		
		if ( !_isOpeningDoor( opening.bindTag ) )
		{
			// do not jump through if a player is standing in the way
			self zombieKeepAttackingThroughWindow(left_or_right);

// Climb Through
//---------------

			anim_state = "window_climbin";

			if(from_front)
			{
				anim_state += "_front";
			}
			else if(from_rear)
			{
				anim_state += "_back";
			}
			else
			{
				anim_state += left_or_right;
			}
			
			// Fast or slow mantle.
			
			min_chance_at_round = 5;
			max_chance_at_round = 12;
			
			if(level.round_number >= min_chance_at_round)
			{
				
				round = min(level.round_number, max_chance_at_round);
				
				range = max_chance_at_round - min_chance_at_round;
				
				chance = (100 / range) * (round - min_chance_at_round);
				
				if(randomintrange(0, 100) <= chance)
				{
					anim_state += "_fast";
				}
			}
			
			
			
			
			anim_index			= self GetAnimSubStateFromASD( "zm_zbarrier_climbin_bus", anim_state );
			enter_anim			= self GetAnimFromASD( "zm_zbarrier_climbin_bus", anim_index );
			tag_origin 			= self.attachEnt gettagorigin( self.attachTag );
			tag_angles 			= self.attachEnt gettagangles( self.attachTag );
			//start_origin 		= getstartorigin( tag_origin, tag_angles, enter_anim );
			//start_angles 		= getstartangles( tag_origin, tag_angles, enter_anim );

			self AnimScripted( tag_origin, tag_angles, "zm_zbarrier_climbin_bus", anim_index );
			self zombieAnimNotetrackThink( "climbin_bus_anim" );
		}

		wait_network_frame();
		opening.zombie 	= undefined;
		self.opening 	= undefined ;
		self UnLink();
	}

	//todo t6:
	//self SetAnimKnobAllRestart( maps\mp\animscripts\zm_run::GetRunAnim(), %body, 1, .2, 1 );

	self reset_attack_spot();
	
	// TODO : Re-enable zombie's gibbing here.
	
	if ( IsDefined(removeAfterDone) && removeAfterDone )
	{
		self Delete();
		return;
	}

	self thread zombieMoveOnBus();

}

// the anim rate is scaled by round number and 
zombieGetWindowAnimRate()
{
	animRate = 1.0;
	animRateRoundScalar = 0.0;
	players = get_Players();
	// don't make it any harder in solo
	if ( players.size > 1 )
	{
		// the animRate will scale up to target_rate at max of target_round for target_num_players
		// the default is a target rate of 1.5 at round 25 for 4 players
		target_rate = 1.5;
		target_round = 25;
		target_num_players = 4;
		rate = ( ( ( target_rate - 1.0 ) / target_round ) / target_num_players );
		
		animRateRoundScalar = rate * players.size;
		animRate = 1.0 + animRateRoundScalar * level.round_number;
		
		if ( animRate > target_rate )
		{
			animRate = target_rate;
		}
	}
	
	//Check for barbed wire upgrade
	//-----------------------------
/*	isOnRightSide = vectorDot(anglestoright(level.the_bus.angles), self.origin - level.the_bus.origin) > 0;
	if ( (isOnRightSide && level.the_bus.upgrades["BarbedWireR"].installed)
		|| (!isOnRightSide && level.the_bus.upgrades["BarbedWireL"].installed) )
	{
		animRate *= 0.75; //Slow down zombies 
	}*/
	return animRate;
}

zombieDetachFromBus()
{
	// Ensure the zombie has an assigned opening
	if( !IsDefined( self.opening ) )
	{
		return;
	}
	
	if( IsDefined( self.opening.zombie ) && self.opening.zombie == self )
	{
		self.opening.zombie = undefined;
	}
	
	self.opening 		= undefined;
	self.isOnBus 		= false;
	self.isOnBusRoof 	= false;
	self.onBusWindow 	= undefined;
	
	//todo t6:
	//self anim_stopanimscripted();
	self UnLink();
	self TraverseMode( "gravity" );
	self.forceMovementScriptState = false;
	self thread maps\mp\zombies\_zm_ai_basic::find_flesh();
	
	self notify( "off_window" );
	self notify( "detach_on_window" );
}

zombieShouldDetachFromWindow()
{
	return ( level.the_bus.numAlivePlayersRidingBus == 0 );
}


// will return true if it is ok for the zombie to jump on the roof (time has passed and there is no one else up there)
// also checks the opening to make sure it is a valid climb up point
zombieCanJumpOnRoof(opening)
{
	if (level.the_bus.numPlayersOnRoof == 0)
	{
		if (all_chunks_destroyed( opening ) )
		{
			return false;
		}
		if (IsDefined( level.bus_zombie_on_roof ))
		{
			return false;
		}
		if (level.bus_roof_next_time > gettime())
		{
			return false;
		}
	}
	
	percentChance = 0;
	if ( level.round_number <= 5 )
	{
		percentChance = 5;
	}
	else if ( level.round_number <= 10 )
	{
		percentChance = 20;
	}
	else if (level.round_number <= 20 )
	{
		percentChance = 30;
	}
	else if (level.round_number <= 25 )
	{
		percentChance = 40;
	}
	else
	{
		percentChance = 50;
	}
	
	percentOfPlayersOnRoof = level.the_bus.numPlayersOnRoof / level.the_bus.numPlayersNear;
	percentOfPlayersOnRoof *= 100.0;
	if (percentChance < percentOfPlayersOnRoof)
	{
		percentChance = percentOfPlayersOnRoof;
	}
	
	if (randomInt(100) < percentChance)
	{
		return true;
	}
	return false;
}

// set the next valid time for the zombies to jump on the roof
zombieSetNextTimeToJumpOnRoof()
{
	level.bus_roof_next_time = 
		gettime() + level.bus_roof_min_interval_time + randomInt( level.bus_roof_max_interval_time - level.bus_roof_min_interval_time );
}

// function that handles getting the zombie on the roof
// self = zombie
zombieJumpOnRoof(theBus, opening, removeAfterDone, postfix)
{
	// declare this zombie on the roof
	level.bus_zombie_on_roof = self;
	
	// climb up to the roof
	
	self AnimScripted( self.opening.zbarrier.origin, self.opening.zbarrier.angles, "zm_zbarrier_window_climbup", "window_climbup" + postfix );
	self zombieAnimNotetrackThink( "bus_window_climbup" );

	
	// play a sound to indicate there is a zombie on the roof
	play_sound_at_pos( "grab_metal_bar", self.origin );
	
	// make sure the zombie is not associated with the opening
	opening.zombie 	= undefined;
	self.opening 	= undefined;
	
	// need to unlink and then reset his attach tag
	self UnLink();
	
	self.isOnBusRoof = true;
	if (level.the_bus.numPlayersOnRoof > 0)
	{	
		level.bus_zombie_on_roof = undefined;
	}
	
	if ( self zombiePathToRoofOpening() )
	{
		self zombieJumpIntoBus();
		self.isOnBusRoof = false;
	}
}

// link up the thing that will be the roof hole
busSetupRoofOpening()
{
	level.bus_roof						= getEnt( "bus_roof", "targetname" );	// the actual model covering the roof hole
	level.bus_roof_open					= false;								// has the roof hole been ripped open yet
	level.bus_zombie_on_roof 			= undefined; 							// the zombie on the roof if defined
	level.bus_roof_next_time 			= 0;		 							// the next valid time for a zombie to jump on the roof
	level.bus_roof_min_interval_time 	= 10000;								// the min time to wait between zombies on the roof
	level.bus_roof_max_interval_time 	= 20000;								// the max time to wait between zombies on the roof
	
	// link up the roof covering to the bus
	level.bus_roof linkto(level.the_bus, "", level.the_bus worldtolocalcoords(level.bus_roof.origin), level.bus_roof.angles - level.the_bus.angles);

	// setup the player clip that blocks the hole until the hatch is player traversable
	clipBrush = GetEntArray("hatch_clip", "targetname");
	
	if( IsDefined(clipBrush) && clipBrush.size > 0 )
	{
		for( i = 0; i < clipBrush.size; i++)
		{
			self thread busInitHatchClip(clipBrush[i]);
		}
	}

	// setup the player mantle brush that fills the hole once the hatch is player traversable
	mantleBrush = GetEntArray("hatch_mantle", "targetname");
	
	if( IsDefined(mantleBrush) && mantleBrush.size > 0 )
	{
		for( i = 0; i < mantleBrush.size; i++)
		{
			self thread busDeferredInitHatchMantle(mantleBrush[i]);
		}
	}

	/#
	// devgui option to open the hatch
	AddDebugCommand( "devgui_cmd \"Zombies:1/Bus:14/Hatch:4/Allow Traverse:1\" \"zombie_devgui hatch_available\"\n" );
	self thread wait_open_sesame();
	#/
}

wait_open_sesame()
{
	level waittill("open_sesame");
	self notify("hatch_mantle_allowed");
}

busInitHatchClip( clip )
{
	origin = self worldToLocalCoords(clip.origin);
	clip linkto( self, "", origin, (0,0,0) );
	clip SetMovingPlatformEnabled( true );
	self waittill( "hatch_mantle_allowed" );
	clip Delete();
}

busDeferredInitHatchMantle( mantle )
{
	origin = self worldToLocalCoords(mantle.origin);
	mantle.origin = (0,0,-100); // move it to limbo until it is actually needed
	self waittill( "hatch_mantle_allowed" );
	mantle linkto( self, "", origin, (0,0,0) );
	mantle SetMovingPlatformEnabled( true );
}

	

zombieMoveOnBus()
{
	self endon("death");
	self endon("removed");
	level endon( "intermission" );
	self notify("stop_find_flesh");
	self notify("zombie_acquire_enemy");
	
	wait_network_frame();
	
	// Start Walking Toward The Enemy
	//--------------------------------
	self TraverseMode("gravity");
	self AnimMode( "gravity" );
	self OrientMode( "face enemy" );
	
	self.goalradius = 32;

	self set_zombie_run_cycle( "walk" );	//zombies on the bus all walk!

	attacking_player_on_turret = false;

	while (1)
	{
		if ( !IsDefined(self.favoriteenemy) )
		{
			break;
		}
		
		enemies_on_bus 		= ( level.the_bus.numAlivePlayersRidingBus>0 );
		self_on_bus 		= ( isDefined(self.isOnBus) && self.isOnBus );
		self_is_on_bus_roof	= ( isDefined( self.isOnBusRoof ) && self.isOnBusRoof );
		
		// if another thread determined that the zombie is off of the bus break out of this
		if ( !self_on_bus )
		{
			break;
		}
		
		// spam a bee line to the enemy
		if ( self.forceMovementScriptState )
		{
			self AnimMode( "gravity" );
			self OrientMode( "face enemy" );
			self SetGoalPos( self.favoriteenemy.origin );
		}
		
		enemy				= ( self.favoriteenemy );
		enemy_on_bus		= ( isDefined( enemy ) && enemy.isOnBus );
		enemy_on_roof		= ( enemy_on_bus && isDefined( enemy.isOnBusRoof ) && enemy.isOnBusRoof );
		enemy_on_turret		= ( isDefined( enemy.onBusTurret ) && isDefined( enemy.busTurret ) && enemy.onBusTurret );
		enemy_clinging		= ( enemy maps\mp\zm_transit_cling::playerIsClingingToBus() );
		
		// get off of the bus if there are no enemies on it
		if ( ( !enemy_on_bus && !self_is_on_bus_roof ) || !enemies_on_bus )
		{
			self thread zombieExitBus();
			return;
		}
		// if my enemy is on the roof and i am not or vice versa
		else if ( enemy_on_bus && self_is_on_bus_roof != enemy_on_roof )
		{
			self thread zombieHeightTraverse();
			return;	
		}
		else if ( self_is_on_bus_roof && !enemy_on_bus )
		{
			self thread zombieJumpOffRoof();
			return;
		}
		// handle the case specially if the enemy is on a turret
		else if ( self_is_on_bus_roof && enemy_on_turret )
		{
			//todo t6:
			//self zombieAttackPlayerOnTurret(enemy);
		}
		// handle the case specially if the enemy is on a cling point
		else if ( !self_is_on_bus_roof && enemy_clinging )
		{
			self zombieAttackPlayerClinging(enemy);
		}
		else
		{
			// determine if we are close enough to melee, if so turn off the anim scripted state to allow the code to
			// put the zombie in the combat state
			distToEnemy = Distance2D(self.origin, self.favoriteenemy.origin);
			shouldBeInForceMovement = distToEnemy > 32.0;
			
			if (!shouldBeInForceMovement && self.forceMovementScriptState)
			{
				self.forceMovementScriptState = false;
				self AnimMode( "normal" );
				self OrientMode( "face enemy" );
			}
			
			if (shouldBeInForceMovement && !self.forceMovementScriptState)
			{
				self.forceMovementScriptState = true;
				self AnimMode( "gravity" );
				self OrientMode( "face enemy" );
			}
		}
		wait (0.1);
	}	

	self AnimMode( "normal" );
	self OrientMode( "face enemy" );
	self.forceMovementScriptState = false;
	self thread maps\mp\zombies\_zm_ai_basic::find_flesh();
}

// go to and attack the clinging player from inside of the bus
// special case attack script since the zombie needs to be in a good spot for the player to 
zombieAttackPlayerClinging(player)
{
	self endon("death");
	level endon("intermission");
	self.goalradius = 15;
	enemy_clinging = true;
	
	while ( enemy_clinging )
	{
		// the zombie needs to stand at the back window and not way in the corner
		best_attack_pos = maps\mp\zm_transit_cling::_getBusAttackPosition(player);
		//thread debugline(best_attack_pos, (0,1,0), 200);
		dist_from_pos2 = distance2dsquared( best_attack_pos, self.origin );
		
		enemy_origin = player _playerGetOrigin();
		direction = enemy_origin - self.origin;
		direction_angles = vectorToAngles(direction);
		direction_angles = (direction_angles[0], direction_angles[1], 0);
		
		//iprintlnbold("dist: " + sqrt(dist_from_pos2));
		
		if ( dist_from_pos2 > ( 20 * 20 ) )
		{
			// path to the turret and face it
			self OrientMode( "face point", best_attack_pos );
			self SetGoalPos( best_attack_pos );
		}
		else
		{
			// attack the player
			self zombieScriptedAttack(player, direction_angles, ::zombieDamagePlayerCling);
		}
		enemy_clinging = player maps\mp\zm_transit_cling::playerIsClingingToBus();
		wait( 0.1 );
	}
	self.goalradius = 32;
}

// go to and attack the player on the bus roof
// assumes the passed player is on a turret
// TODO: right now the players origin is on the bus's origin when on the turret so this function makes the zombie path to the 
// turret, play an attack anim, and damage the player if they are on the turret
zombieAttackPlayerOnTurret(player)
{
	self endon("death");
	level endon("intermission");
	enemy_on_turret = true;
	
	while ( enemy_on_turret )
	{
		// determine the enemy's origin and direction
		enemy_origin = self.favoriteenemy _playerGetOrigin();
		dist_from_turret2 = distance2dsquared( enemy_origin, self.origin );
		direction = enemy_origin - self.origin;
		direction_angles = vectorToAngles(direction);
		direction_angles = (direction_angles[0], direction_angles[1], 0);
		
		if ( dist_from_turret2 > ( 32 * 32 ) )
		{
			// path to the turret and face it
			self SetGoalPos( enemy_origin, direction_angles );
		}
		else
		{
			// attack the player
			self zombieScriptedAttack(player, direction_angles, ::zombieDamagePlayerTurret);
		}
		wait( 0.1 );
		enemy_on_turret = isDefined( self.favoriteenemy.onBusTurret ) && isDefined( self.favoriteenemy.busTurret ) && self.favoriteenemy.onBusTurret;
	}
}

// face the passed direction and attack the passed player, it will damage them
// the damage function expects the zombie will call it and the player is passed to damage
zombieScriptedAttack(player, direction_angles, damage_func)
{
	self OrientMode( "face angle", direction_angles[1] );
	zombie_attack_anim = self zombiePickUnMovingAttackAnim();
	self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "attack", self.animname );
	//todo t6:
	//self SetFlaggedAnimKnobAllRestart("meleeanim", zombie_attack_anim, %body, 1, .2, 1);
	
	while ( 1 )
	{
		self waittill("meleeanim", note);
		if ( note == "end" || note == "stop" )
		{
			break;
		}
		else if ( note == "fire" )
		{
			if ( IsDefined( damage_func ) )
			{
				[ [ damage_func ] ](player);
			}
			
		}
	}
}

// damage the player only if they are still on the turret
zombieDamagePlayerTurret(player)
{
	if ( player.onBusTurret )
	{
		player DoDamage(self.meleeDamage, self.origin, self );
	}
}

// damage the player only if they are still clinging
zombieDamagePlayerCling(player)
{
	if ( player maps\mp\zm_transit_cling::playerIsClingingToBus() )
	{
		player DoDamage(self.meleeDamage, self.origin, self );
	}
}

// determine where the player is on the bus (right now when the player is on the turret his origin is on the origin
// of the bus so this accounts for that)
_playerGetOrigin()
{
	if ( isDefined( self.onBusTurret ) && isDefined( self.busTurret ) && self.onBusTurret )
	{
		turret = self.busTurret;
		turret_exit = getEnt(turret.target, "targetname");
		return turret_exit.origin;
	}
	return self.origin;
}

// we don't want to play a walking anim so we can't use animscripts\zm_melee::pick_zombie_melee_anim
zombiePickUnMovingAttackAnim()
{
	melee_anim = undefined;
	if ( self.has_legs )
	{
		rand_num = randomint(4); // only want the first 4 anims since they don't move the zombie
		melee_anim = level._zombie_melee[self.animname][rand_num];
	}
	else if(self.a.gib_ref == "no_legs")
	{
		// if zombie have no legs whatsoever.
		melee_anim = random(level._zombie_stumpy_melee[self.animname]);

	}
	else
	{
 		melee_anim = level._zombie_melee_crawl[self.animname][0];
	}

	return melee_anim;
}

zombieExitBus()
{
	self endon("death");
	level endon( "intermission" );

	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );
	
	// Start Walking Toward The Exit
	//--------------------------------
	self TraverseMode("gravity");
	self AnimMode( "gravity" );
	self OrientMode( "face goal" );

	while (1)
	{
		if ( level.the_bus.numAlivePlayersRidingBus > 0 )
		{
			// stay on the bus
			self thread zombieMoveOnBus();
			return;
		}
		
		closest_door_tag = self zombieGetClosestDoorTag();
		goal_pos = level.the_bus GetTagOrigin( closest_door_tag );
		
		self.goalradius = 2;
			
		// Reached?
		if( Distance2DSquared( self.origin, goal_pos ) <= EXIT_BUS_DIST )
		{
			// Ensure the doors are open
			if( level.the_bus.doorsClosed )
			{
				level.the_bus maps\mp\zm_transit_bus::busDoorsOpen();
			}
				
			break;
		}
		
		// Move towards the goal point
		//line( goal_pos, goal_pos + (0,0,100), (1,0,0), 1, 0, 2 );
		self SetGoalPos( goal_pos );
		self OrientMode( "face point", goal_pos );

		wait_network_frame();
	}

	out_angles = level.the_bus.angles + ( 0, -90, 0 );

	self AnimScripted( self.origin, out_angles, "zm_jump_off_bus", 0 );
	self zombieAnimNotetrackThink( "jump_off_bus_anim" );

	// Off of the bus
	self.isOnBus = false;
	self.isOnBusRoof = false;

	self AnimMode( "normal" );
	self OrientMode( "face enemy" );
	self.forceMovementScriptState = false;
	self thread maps\mp\zombies\_zm_ai_basic::find_flesh();
}

// handles the zombie jumping off of the roof of the bus
zombieJumpOffRoof()
{
	self endon("death");
	self endon("removed");
	level endon( "intermission" );
	
	// Start Walking Toward The Exit
	//--------------------------------
	self TraverseMode("gravity");
	self AnimMode( "gravity" );
	self OrientMode( "face goal" );
	
	in_dist 			= 50.0;
	in_reached_dist 	= 32.0;
	
	while (1)
	{
		enemiesOnBus 	= (level.the_bus.numAlivePlayersRidingBus>0);
		selfIsOnBus 	= IsDefined(self.isOnBus) && self.isOnBus;
		
		if ( enemiesOnBus )
		{
			// stay on the bus
			self thread zombieMoveOnBus();
			return;
		}
		
		if ( !selfIsOnBus )
		{
			break;
		}
		
		closest_jump_ent = self zombieGetClosestRoofJumpEnt();
		goal_pos = closest_jump_ent GetTagOrigin( "tag_origin" );		
		
		// Reached?
		if( distance2DSquared( self.origin, goal_pos ) <= (32*32) )
		{
			// do the jump off	
			self.attachEnt		= closest_jump_ent;
			self.attachTag		= "tag_origin";
			
			//self DisableAimAssist();			
			self TraverseMode( "noclip");
			self LinkTo(self.attachEnt, self.attachTag, (0,0,0), (0,0,0));

			wait_network_frame();
			
			// Jump Off of The Bus
			//-----------------
			self zombieplayattachedanim( "jump_down_127" );
			
			self Unlink();

			//todo t6:
			//self SetAnimKnobAllRestart( maps\mp\animscripts\zm_run::GetRunAnim(), %body, 1, .2, 1 );
			
			self.isOnBusRoof = false;
			self.isOnBus = false;
			break;
		}
		
		// Move towards the goal point
		//line( goal_pos, goal_pos + (0,0,100), (1,0,0), 1, 0, 2 );
		self SetGoalPos( goal_pos );
		self OrientMode( "face point", goal_pos );
		
		wait (0.1);
	}	

	self AnimMode( "normal" );
	self OrientMode( "face enemy" );
	self.forceMovementScriptState = false;
	self thread maps\mp\zombies\_zm_ai_basic::find_flesh();
}

// zombie will climb the ladder if in the bus or the zombie will jump through the hole if on the roof and there are no
// players near him
zombieHeightTraverse()
{
	level endon( "intermission" );
	self endon("death");
	self endon("removed");
	self TraverseMode("gravity");
	self AnimMode( "gravity" );
	self OrientMode( "face goal" );

	self.zombie_ladder_stage = 1;
	
	self.goal_local_offset = level.the_bus.ladder_local_offset;
	self.goal_local_offset = (self.goal_local_offset[0], self.goal_local_offset[1], level.the_bus.floor );
	self.goal_local_angles = (0,-90,0);

	if ( !self.isOnBusRoof )
	{
		if ( self zombiePathToLadder() )
		{
			self zombieClimbToRoof();
			self.isOnBusRoof = true;
		}
	}
	else
	{
		if ( self zombiePathToRoofOpening() )
		{
			self zombieJumpIntoBus();
			self.isOnBusRoof = false;
		}
	}
	
	self thread zombieMoveOnBus();
}

// zombie will path to the ladder and climb up
// return true if successfully got there and no players interrupted him
zombiePathToLadder()
{
	self.goalradius = 2;
	while ( level.the_bus.numPlayersInsideBus == 0 && level.the_bus.numPlayersOnRoof > 0 )
	{
		if ( !self.isOnBus )
		{
			self.goalradius = 32;
			return false;
		}
		
		goal_dir = AnglesToForward(level.the_bus.angles + self.goal_local_angles);
		goal_pos = level.the_bus LocalToWorldCoords((120, -32, 48));
			
		if( Distance2D( self.origin, goal_pos ) <= 40.0 )
		{
			self.goalradius = 32;
			return true;
		}
		
		// Move towards the goal point
		//line( goal_pos, goal_pos + (0,0,100), (1,0,0), 1, 0, 2 );
		self SetGoalPos( goal_pos );
		self OrientMode( "face point", goal_pos );
		
		wait (0.1);
	}
	self.goalradius = 32;
	return false;
}

// zombie will path to the hole in the roof
// return true if successfully got there and no players interrupted him
zombiePathToRoofOpening()
{	
	self.goalradius = 2;
	goal_tag = self zombieGetClosestRoofOpeningJumpTag();
	while ( level.the_bus.numPlayersOnRoof == 0 )
	{
		if ( !self.isOnBus )
		{
			self.goalradius = 32;
			return false;
		}
		
		goal_dir = level.the_bus getTagAngles(goal_tag);
		goal_pos = level.the_bus getTagOrigin(goal_tag);
			
		if( Distance2D( self.origin, goal_pos ) <= 40.0 )
		{
			self.goalradius = 32;
			return true;
		}
		
		// Move towards the goal point
		//line( goal_pos, goal_pos + (0,0,100), (1,0,0), 1, 0, 2 );
		self SetGoalPos( goal_pos );
		self OrientMode( "face point", goal_pos );
		
		wait (0.1);
	}
	self.goalradius = 32;
	return false;
}

// zombie will attach himself to the bus and play a jump through the closest roof tag near the opening
zombieJumpIntoBus()
{
	self.attachTag	= self zombieGetClosestRoofOpeningJumpTag();//opening.roofJoint;
	
	// link the zombie to the roof hole
	self LinkTo(self.attachEnt, self.attachTag, (0,0,0), (0,0,0));
	
	// need to wait a frame before playing animations when you link an already linked zombie
    wait_network_frame();
	
	// if the bus roof hole is still open, have the first zombie tear it open
	if ( !level.bus_roof_open )
	{
		//playsoundatposition( "evt_bus_hatch_ripped", self.origin );
		level.bus_roof_open = true;
		self zombiePlayAttachedAnim( "bus_hatch_tear" );
		level.bus_roof Hide();
		level.bus_roof Delete();
		level.bus_roof = undefined;

		// TAKE THIS OUT
		//   Once the hatch buildable is working this should be removed
		//   It allows the player to traverse the hatch after a zombie has ripped it open
		level.the_bus notify("hatch_mantle_allowed");
	}
	
	// have the zombie stick his head through the hole
	self zombiePlayAttachedAnim( "bus_hatch_attack" );
	
	// jump down into the bus
	self zombiePlayAttachedAnim( "bus_hatch_jump_down" );
	self Unlink();
	
	// declare this zombie off of the roof
	level.bus_zombie_on_roof = undefined;
}

// zombie will climb the ladder to the roof
zombieClimbToRoof()
{
	// TODO: replace teleport with anim
	self ForceTeleport( self.origin + (0,0,100), self.angles );
}

// gets script_model of the closest jump position when on the roof
zombieGetClosestRoofJumpEnt()
{
	jump_positions 	= GetEntArray("roof_jump_off_positions", "targetname");
	best 			= jump_positions[0];
	best_pos 		= best getTagOrigin("tag_origin");
	best_pos_dist2 	= distance2DSquared(self.origin, best_pos);
	
	for ( i = 1; i < jump_positions.size; i++ )
	{
		next_pos = jump_positions[i] getTagOrigin("tag_origin");
		next_pos_dist2 = distance2DSquared(self.origin, next_pos);
		if ( next_pos_dist2 < best_pos_dist2 )
		{
			best 			= jump_positions[i];
			best_pos 		= next_pos;
			best_pos_dist2 	= next_pos_dist2;
		}
	}
	
	return best;
}

// gets string of the closest jump position when on the roof
zombieGetClosestRoofOpeningJumpTag()
{
	pos1 = level.the_bus getTagOrigin("window_roof_1_jnt");
	pos2 = level.the_bus getTagOrigin("window_roof_2_jnt");
	
	closest = "window_roof_1_jnt";
	pos1_dist2 = distance2DSquared(self.origin, pos1);
	pos2_dist2 = distance2DSquared(self.origin, pos2);
	
	if ( pos2_dist2 < pos1_dist2 )
	{
		closest = "window_roof_2_jnt";
	}

	return closest;
}

// gets the string of the closest door to the zombie
zombieGetClosestDoorTag()
{
	pos1 = level.the_bus getTagOrigin("door_rear_jnt");
	pos2 = level.the_bus getTagOrigin("door_front_jnt");
	
	closest = "door_rear_jnt";
	pos1_dist2 = distance2DSquared(self.origin, pos1);
	pos2_dist2 = distance2DSquared(self.origin, pos2);
	
	if ( pos2_dist2 < pos1_dist2 )
	{
		closest = "door_front_jnt";
	}

	return closest;
}

// function that will keep the zombie at the window attacking the player until they move out of the way
zombieKeepAttackingThroughWindow(left_or_right)
{
	while ( self zombieTryAttackThroughWindow(false, left_or_right) )
	{
		tag_origin = self.attachEnt gettagorigin( self.attachTag );
		tag_angles = self.attachEnt gettagangles( self.attachTag );	
		
		self AnimScripted( tag_origin, tag_angles, "zm_zbarrier_window_idle", "window_idle" + left_or_right );
		self zombieAnimNotetrackThink( "bus_window_idle" );
	}
}

// zombie will attack players next to the window they are on
// return true if there was an attack
zombieTryAttackThroughWindow(is_random, postfix)
{
	attackPlayers = self zombieGetPlayersToAttack();
	if ( attackPlayers.size == 0 )
	{
		return false;
	}
	
	if(GetDvar( "zombie_reachin_freq") == "")
	{
		SetDvar("zombie_reachin_freq","50");
	}
	
	should_attack = true;
	if ( is_random )
	{
		freq = 80; //GetDvarInt( "zombie_reachin_freq");
		rand = randomInt(100);
		should_attack = freq >= rand;
	}

	if ( should_attack )
	{
		self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "attack", self.animname );
		
		tag_origin = self.attachEnt gettagorigin( self.attachTag );
		tag_angles = self.attachEnt gettagangles( self.attachTag );	
		
		self AnimScripted( tag_origin, tag_angles, "zm_zbarrier_window_attack", "window_attack" + postfix );
		self zombieAnimNotetrackThink( "bus_window_attack" );
		return true;
	}
	return false;
}

zombieGetPlayersToAttack()
{
	playersToAttack = [];

	players = GET_PLAYERS();
	attackRange = 72;
	attackRange = attackRange * attackRange;
	attackHeight = 37;
	attackHeight = attackHeight * attackHeight;

	for( i=0; i<players.size; i++)
	{
		xyDist = distance2dSquared(self.origin,players[i].origin);
		zDist = self.origin[2] - players[i].origin[2];
		zDist2 = zDist * zDist;
		if(xyDist <= attackRange && zDist2 <= attackHeight)
		{
			playersToAttack[playersToAttack.size] = players[i];
		}
	}

	return playersToAttack;

}
