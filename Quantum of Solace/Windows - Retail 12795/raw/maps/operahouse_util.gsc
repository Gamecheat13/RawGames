#include animscripts\shared;
#include common_scripts\utility;
#include maps\_utility;
#include maps\_spawner;
//#include maps\mp\_utility;
#include maps\_anim;
#using_animtree("generic_human");


//############################################################################*
//	Add something to an array, it can either be a single thing or an array of stuff
//		old_array - must be an array.
//
array_add_Ex( old_array, adds )
{
	if ( IsArray(adds) )
	{
		for(i=0;i<adds.size;i++)
		{
			old_array[old_array.size] = adds[i];
		}
	}
	else
	{
		old_array[ old_array.size ] = adds;
	}

	return old_array;
}




//############################################################################*
//	Function called from pt_ongoal on patrol nodes
//	This function exists so that the action can play, but the pt_wait value will still be in effect
//
cmdaction_fidget()
{
	cmdaction_ongoal( "Fidget" );
}
cmdaction_listen()
{
	cmdaction_ongoal( "Listen" );
}
cmdaction_lookaround()
{
	cmdaction_ongoal( "LookAround" );
}
cmdaction_scan()
{
	cmdaction_ongoal( "Scan" );
}


// Do some action for a short amount of time.
cmdaction_ongoal( action )
{
	self endon( "death" );

	wait( RandomFloatRange(1.5,2.0) );

	self cmdaction( action );
	wait( 5.0 );

	// this is needed to stop looping animations
	self StopCmd();
}


//############################################################################*
//	Play lookover command.  Used for patrols
//
cmdaction_talk( )
{
	self endon( "death" );

	wait( RandomFloatRange(0.5,1.0) );

	if ( RandomInt(2) == 1 )
	{
		self CmdPlayAnim( "Gen_Civs_StandConversation" );
	}
	else
	{
		self CmdPlayAnim( "Gen_Civs_StandConversationV2" );
	}
}


//############################################################################
//	This is meant to be used as a runthread function, so all arguments must be strings
//
door_kick( )
{
	self endon( "death" );

	door = undefined;
	for ( i=0; i<level.doors.size; i++ )
	{
		dist =  Distance( self.origin, level.doors[i].origin );
		if ( dist <= 95 )
		{
			door = level.doors[i];
			break;
		}
	}

	// Hopefully there's a door nearby...
	if ( IsDefined( door ) )
	{
		self SetEnableSense( false );
		self CmdPlayAnim( "Thug_Alrt_Frontkick", false );
		wait( 0.8 );
		node = maps\_doors::get_closest_door_node(self, door);
		if ( IsDefined( node ) )
		{
			node maps\_doors::open_door();
		}

		self SetEnableSense( true );

		// get clear of the door
		self SetCombatRole( "rusher" );
		wait( 4.0 );

		self SetCombatRole( "elite" );
	}
}


// 
// //############################################################################*
// // cover_lock - keep player stuck in cover while touching the trigger
// cover_lock()
// {
// 	level.player endon( "damaged_on_ledge" );	// stop the death thread
// 
// 	in_cover = false;
// 	camera_id = undefined;	// higher scope declaration 
// 	while( 1 )
// 	{
// 		self waittill( "trigger" );
// 
// //iprintln("force cover");
// 		level.player notify( "on_ledge" );	// stop the death thread
// 		wait(0.4);
// 		holster_weapons();
// //		level.player AllowCrouch( false );
// 		push_vector = ( 0.0, 0.0, 0.0 );
// 		if ( IsDefined(self.script_int) )
// 		{
// 			push_vector = AnglesToForward( (0.0, self.script_int, 0.0) );
// 		}
// 		level.player thread cover_ledge_hurt( push_vector );
// 
// 		// setup the cameras
// // 		if ( IsDefined(self.script_noteworthy) )
// // 		{
// // 			if ( self.script_noteworthy == "e2_outside" )
// // 			{
// // 				level.camera_id = level.player customCamera_push(
// // 						"offset_abs",		// <required string, see camera types below>
// // //						level.player,		//<required only by "entity" and "entity_abs" cameras>
// // 						( 138.47,  -31.54,  119.11),	// <optional positional vector offset, default (0,0,0)>
// // 						(  29.82,   55.29,    0.00),	// <optional angle vector offset, default (0,0,0)>
// // 						1.0 );		// <optional time to 'tween/lerp' to the camera, default 0.5>
// // 			}
// // 		}
// 
// 		while( level.player IsTouching(self) )
// 		{
// 			level.player playerSetForceCover( true );
// 			wait(0.1);
// 		}
// 
// //iprintln("unforce cover");
// 		level.player notify( "off_ledge" );	// stop the death thread
// 		level.player playerSetForceCover( false );
// //		level.player AllowCrouch( true);
// 		unholster_weapons();
// // 		if ( IsDefined(level.camera_id) )
// // 		{
// // 			level.player customCamera_pop( 
// // 						level.camera_id,	// <required ID returned from customCameraPush>
// // 						1.0,	// <optional time to 'tween/lerp' to the previous camera, default prev camera>
// // 						0.5,	// <optional time used to accel/'ease in', default prev camera> 
// // 						0.5 );	// <optional time used to decel/'ease out', default prev camera>
// //			level.camera_id = undefined;
// // 		}
// 	}
// }
// 
// 
// //############################################################################*
// //	Check to see if you get hurt while in cover.  If so, then unlock the player and push them off
// //	Run this thread on the player
// cover_ledge_hurt( push_vector )
// {
// 	self endon( "off_ledge" );
// 
// 	self waittill( "damage" );
// 
// 	self notify( "damaged_on_ledge" );
// 	wait(0.05);
// 	self playerSetForceCover( false );
// 	iPrintLnBold( "Bond Shot - get pushed off the ledge and DIE  0.4" );
// 
// 	wait(0.5);
// //	level.player freezeControls(true);
// 	level.player knockback( 9000, (level.player.origin+(push_vector*10)) );
// 
// 	// Failsafe
// 	wait( 2.0 );
// 	level.player DoDamage( 10000, self.origin );
// 	if ( IsDefined(level.camera_id) )
// 	{
// 		level.player customCamera_pop( 
// 					level.camera_id,	// <required ID returned from customCameraPush>
// 					1.0,	// <optional time to 'tween/lerp' to the previous camera, default prev camera>
// 					0.5,	// <optional time used to accel/'ease in', default prev camera> 
// 					0.5 );	// <optional time used to decel/'ease out', default prev camera>
// 		level.camera_id = undefined;
// 	}
// }
// 
// 
// //############################################################################
// //	Ping damage until told to stop.
// //
// damage_ping( radius, damage, zoffset, opt_endon )
// {
// 	if ( IsDefined( opt_endon ) )
// 	{
// 		self endon( opt_endon );
// 	}
// 	else
// 	{
// 		self endon( "stop_damage_ping" );
// 	}
// 
// 	while (1)
// 	{
// 		radiusdamage( self.origin+(0,0,zoffset), radius, damage, damage );
// //		iprintlnbold( "radius = " + radius + "   damage = " + damage  );
// 		wait( 0.05 );
// 	}
// }


//############################################################################*
//	A clean-up function that deletes guys belonging to groupname.
//
delete_group( groupname )
{
	ents = GetAIArray();
	for ( i=0; i<ents.size; i++ )
	{
		if ( IsDefined(ents[i].groupname) && ents[i].groupname == groupname )
		{
			ents[i] delete();
		}
	}
}


//############################################################################*
// when you reach your goal, delete yourself
//
delete_on_goal()
{
	self endon( "death" );
	self waittill( "goal" );

	self delete();
}


//############################################################################*
//	made to be a patrol node callback, but not limited to that.
//
cb_patrol_node_reached()
{
	self notify("patrol_node_reached");
}


//############################################################################*
//	Follow a path until the end.
//
follow_path( start_nodename )
{
	self endon( "death" );

	// Move to the node until you reach the end.
	node = GetNode( start_nodename, "targetname" );
	while ( IsDefined(node) )
	{
		self SetGoalNode(node);
		self waittill( "goal" );

		if ( IsDefined(node.target) )
		{
			node = GetNode( node.target, "targetname" );
		}
	}

	self notify( "follow_path_reached_end" );
}


//############################################################################
//	For temporary refined control in sending someone
//
goto_spot( nodename, radius, opt_endon_msg )
{
	self endon("damage");
	self endon("death");

	if ( IsDefined(opt_endon_msg) )
	{
		self endon( opt_endon_msg );
	}

	old_radius = self.goalradius;
	if ( !IsAlive( self ) )
	{
		return;
	}


	if ( !IsDefined( radius ) )
	{
		radius = 36;
	}

	node = GetNode( nodename, "targetname" );
	if ( IsDefined( node ) )
	{
		self.goalradius = radius;
		self SetGoalNode( node );
		self waittill ( "goal" );

		//return to normal
		if ( IsDefined( radius ) )
		{
			self.goalradius = old_radius;
		}
	}
}


//############################################################################
//	For temporary refined control in sending someone
//	node = node to move to
//	radius = to use to get there
//
goto_node( node, radius )
{
	old_radius = self.goalradius;

	if ( IsDefined( node ) )
	{
		if ( !IsDefined( radius ) )
		{
			radius = 32;
		}
		self.goalradius = radius;
		self SetGoalNode( node );
		self waittill ( "goal" );

		//return to normal
		if ( IsDefined( radius ) )
		{
			self.goalradius = old_radius;
		}
	}
}


//############################################################################
//	LinkEx functions are meant to supercede LinkTo and also to handle Move and Rotate functions for
//		LinkEx entities.
//	entity LinkEx( parent ) will link an entity to a parent entity.
linkEx( parent )
{
	start_thread = false;
	if ( IsDefined(parent) )
	{
		if ( !IsDefined(parent.linkEx_child) )
		{
			parent.linkEx_child = [];
			start_thread = true;
		}
		parent.linkEx_child[parent.linkEx_child.size] = self;

		self.linkEx_parent			= parent;
		self.linkEx_parent_offset	= self.origin - parent.origin;
		self.linkEx_parent_angles	= parent.angles;
	}

	// run this thread aftrer all has been processed.
	if ( start_thread )
	{
		// kill any LinkEx_update threads being run by the children
		for ( i=0; i<parent.linkEx_child.size; i++ )
		{
			parent.linkEx_child[i] notify( "parent_exists" );
		}

		parent thread linkEx_update();
	}
}
// Sever the link
unlinkEx()
{
	if ( IsDefined(self.linkEx_parent) )
	{
		self.linkEx_parent = undefined;
		array_remove (self.linkEx_parent.linkEx_child, self);
	}
}

// Update runs every frame.  Will recursively update all children, so we need to make
//	sure the children aren't running their own update threads.
linkEx_update()
{
	self endon("parent_exists");

	while( IsDefined(self.linkEx_child) )
	{
		self.linkEx_nextpos = self.origin;
		self linkEx_update_child();
		wait(0.033);
	}
}


// Update runs every frame.  Will recursively update all children in order to 
//	reduce jitter caused by asynchronous propagation of next positions,
//	so we need to make sure the children aren't running their own update threads.
linkEx_update_child()
{
	for ( i=0; i<self.linkEx_child.size; i++ )
	{
		child = self.linkEx_child[i];
		angles = ( 0-self.angles[0], self.angles[1], self.angles[2] );
		// calculate the new position
		x = vectorDot(child.linkEx_parent_offset, AnglesToForward(angles) );
		y = vectorDot(child.linkEx_parent_offset, AnglesToRight(angles) );
		z = vectorDot(child.linkEx_parent_offset, AnglesToUp(angles) );

		child.linkEx_nextpos = self.linkEx_nextpos + (x,y,z);
//		child MoveTo( child.linkEx_nextpos, 0.05 );	// this causes a weird oscillation when I try to move things.  might be too short a timespan
		child.origin = child.linkEx_nextpos;

		if ( IsDefined(child.linkEx_child) )
		{
			child linkEx_update_child();
		}
	}
}


//############################################################################
//	Set vision set.  This thread runs on a trigger_multiple	
//	Make sure curr_visionset is initialized.
map_change( new_area )
{
	if ( !IsDefined( level.map_area ) )
	{
		level.map_area = "";
	}

	while ( 1 )
	{
		self waittill( "trigger" );

		if ( level.map_area != new_area )
		{
			setSavedDvar( "sf_compassmaplevel",  new_area );
		}
	}
}


//############################################################################
//	Play music based on combat or stealth mode
//
music_package( end_msg )
{
	if ( IsDefined(end_msg) )
	{
		level endon(end_msg);
	}

	level waittill( "start_propagation" );

	level notify("playmusicpackage_combat");
	while (1)
	{
		enemies = GetAIArray();
		
		if ( enemies.size == 0 )
		{
			wait( 2.0 );

			enemies = GetAIArray();
			if ( enemies.size == 0 )
			{
				level notify("playmusicpackage_stealth");
			}
		}
		wait( 1.0 );
	}
}


// 
// //############################################################################
// //	Constantly print a message on someone.  The message can be updated by changing the .message
// //
// play_dialog_temp( dialog, time, face, color, scale )
// {
// 	self endon( "death" );
// 
// 	frames = time * 20;
// 	if ( !IsDefined(face) )
// 	{
// 		face = ":^o";
// 	}
// 	if ( !IsDefined( color ) )
// 	{
// 		color = (1,0,0);
// 	}
// 	if ( !IsDefined( scale ) )
// 	{
// 		scale = 1;
// 	}
// 
// 	iPrintLnBold( dialog );
// 	print3d( self.origin+(0,0,72), face, color, scale, 1, frames );
// 	wait( time );
// }
// 
// play_dialog( sound_alias )
// {
// 	self endon( "death" );
// 
// 	self playsound( sound_alias, "play_dialog_done", true );
// 	self waittill( "play_dialog_done" );
// }


//
//
play_dialog_monitor( end_msg )
{
	self endon( end_msg );
	if ( self GetAlertState() == "alert_green" )
	{
		self waittill( "death" );

		CreateDistraction( "obvious", "", 0, 10, "", "", self.origin, 30, "");
	}
}

/#
//############################################################################
//	Constantly print a message on someone.  The message can be updated by changing the .message
//
print3d_info( info, offset, color, alpha, scale )
{
	self endon( "death" );
	self endon( "print3d_info_stop" );

	self.print3d_info = info;
	if ( !IsDefined( offset ) )
	{
		offset = (0,0,72);
	}
	if ( !IsDefined( color) )
	{
		color = (1,1,1);
	}
	if ( !IsDefined( alpha ) )
	{
		alpha = 1.0;
	}
	if (!IsDefined( scale ) )
	{
		scale = 1.0;
	}

	while (1)
	{
		Print3d( self.origin+offset, self.print3d_info, color, alpha, scale, 2 );
		wait(0.1);
	}
}
#/


//############################################################################*
//	Start up the "process" thread on an entity
//	In order to use this function, you must define an array of functions called "level.runthread_func".  For example:
//		level.runthread_func[ "patrol" ]				= ::patrol;					// in casino_util
//		level.runthread_func[ "wait_then_move" ]		= ::wait_then_move;			// in casino_util
//
//	Note that the function name cannot have a path in it, such as "maps\casino_floor1::func".  So you will need
//	to #include those gsc files in order to use them.
//
runthread_start()
{
	// if script_parameters is defined, then try to automagically spawn a thread
	if ( !IsDefined(self.script_parameters) )
	{
		return;
	}

	// tokenize the line (ie, separate it into individual variables)
	tokens = strtok( self.script_parameters, "," );
	// need to use the customized lookup array to figure out which thread to spawn
	func = level.runthread_func[ tokens[0] ];
	if ( !IsDefined( func ) )
	{
		iPrintLn( "WARNING!  Couldn't find a matching thread for a function called "+tokens[0] );
		return;
	}

	// Spawn the thread
	switch ( tokens.size )
	{
	case 1:
		self thread [[func]]( );
		break;
	case 2:
		self thread [[func]]( tokens[1] );
		break;
	case 3:
		self thread [[func]]( tokens[1], tokens[2] );
		break;
	case 4:
		self thread [[func]]( tokens[1], tokens[2], tokens[3] );
		break;
	case 5:
		self thread [[func]]( tokens[1], tokens[2], tokens[3], tokens[4] );
		break;
	case 6:
		self thread [[func]]( tokens[1], tokens[2], tokens[3], tokens[4], tokens[5] );
		break;
	case 7:
		self thread [[func]]( tokens[1], tokens[2], tokens[3], tokens[4], tokens[5], tokens[6] );
		break;
	case 8:
		self thread [[func]]( tokens[1], tokens[2], tokens[3], tokens[4], tokens[5], tokens[6], tokens[7] );
		break;
	case 9:
		self thread [[func]]( tokens[1], tokens[2], tokens[3], tokens[4], tokens[5], tokens[6], tokens[7], tokens[8] );
		break;
	}
}


//this plays radio chatter on AI every 45 seconds to 1 min 30 seconds.
radio_chatter()
{
	thread radio_chatter_cleanup();

	self.radio_origin = spawn( "script_origin", self.origin + ( 0, 0, 0 ) );
	self.radio_origin linkto( self, "tag_origin", (0, 0, 40), (0, 0, 0) );

	self endon ( "death" );
	while ( 1 )
	{
		wait( 45.0 + randomfloat(45.0) );
		if ( isdefined ( self ))
		{
//			  self.radio_origin playsound ( "Walkie_Chatter", "radio_chatter_done" );
		}
	}
}
radio_chatter_cleanup()
{
	self waittill( "death" );

	radio = self.radio_origin;
	radio Unlink();
	if ( radio iswaitingonsound() )
	{
		radio waittill( "radio_chatter_done" );
	}

	radio delete();
}



//########################################################################
//  Scamble an array
//	
randomize_array( array1 )
{
	for ( i=0; i<array1.size; i++ )
	{
		rand_index = RandomInt( array1.size );
		temp					= array1[ rand_index ];
		array1[ rand_index ]	= array1[ i ];
		array1[ i ]				= temp;
	}
	return array1;
}


//########################################################################
//  Wait for a reinforcement message, then spawn reinforcements at the appropriate location.
//	Uses the following level variables:
//		reinforcement_targetname = targetname of spawners to activate
//		reinforcement_groupname = groupname the spawned AI should belong to
//		reinforcement_activated = boolean to control spawning.  You can set it to false to reset spawning.
//	To stop this, you can send an endon message ("reinforcement_stop")
//
reinforcement_controller( reinforcement_spawner, reinforcement_group )
{
	level endon( "reinforcement_stop" );

	if ( IsDefined( reinforcement_spawner ) )
	{
		level.reinforcement_targetname = reinforcement_spawner;
		spawners = GetEntArray( level.reinforcement_targetname, "targetname" );
	}
	else
	{
		level.reinforcement_targetname = "";
	}

	if ( IsDefined( reinforcement_group ) )
	{
		level.reinforcement_groupname = reinforcement_group;
	}
	else
	{
		level.reinforcement_groupname = "";
	}

	level.reinforcement_activated = false;

	last_activated = "";
	while (1)
	{
		level waittill_any( "reinforcement_spawn", "start_camera_spawner" );
//	iPrintLn( "reinforcements called for: " + level.reinforcement_targetname );

		level.reinforcement_activated = true;
		// Start up the flood spawners if they haven't already been activated
		if ( level.reinforcement_targetname != "" && level.reinforcement_targetname != "none" && 
			 last_activated != level.reinforcement_targetname )
		{
			if ( IsDefined( level.reinforcement_spawners ) )
			{
				for ( i=0; i<level.reinforcement_spawners.size; i++ )
				{
//					iPrintLn( "reinforcement "+i+" spawned" );
					level.reinforcement_spawners[i] thread reinforcement_spawner_think();
//					guys[i] thread reinforcement_pursue( i*RandomFloatRange(2.0, 3.0) );
				}
			}
			last_activated = level.reinforcement_targetname;
		}
	}
}


//############################################################################
// Keep checking to see if you've been alerted
//	Send messages when you change alert states
//
reinforcement_monitor( )
{
	self endon( "death" );

	self waittill( "start_propagation" );

//	wait(0.5);	// how long to wait before giving the alert shout

	if ( self.health > 0 )
	{
		level notify( "reinforcement_spawn" );
	}
}


//############################################################################
//  Let the controller know there's a new place to spawn reinforcements.
//
//	opt_activate_reinforcements = override to de/activate reinforcements
//		if false, it will shutoff reinforcements until activated/spotted again
//		if true, reinforcements will always spawn
//		if unspecified, the previous setting will carry over.
reinforcement_update( spawner_targetname, groupname, opt_activate_reinforcements )
{
	// If there were previously activated spawners, then shut them down.
	if ( IsDefined( level.reinforcement_spawners ) )
	{
		for ( i=0; i<level.reinforcement_spawners.size; i++ )
		{
			level.reinforcement_spawners[i] notify ("stop current floodspawner");
		}
	}

	// Assign the new information
	level.reinforcement_targetname = spawner_targetname;
	level.reinforcement_spawners = GetEntArray( level.reinforcement_targetname, "targetname" );
	level.reinforcement_groupname = groupname;
	if ( IsDefined(opt_activate_reinforcements) )
	{
		level.reinforcement_activated = opt_activate_reinforcements;
	}

	// If the spawners should be active, kick out a new spawn
	if ( level.reinforcement_activated )
	{
		level notify( "reinforcement_spawn" );
	}
//iPrintLn("Reinforcement location updated");
}


//############################################################################
//  runthread version
trig_reinforcement_update( spawner_targetname, groupname, opt_activate_reinforcements )
{
	self waittill( "trigger" );

	reinforcement_update( spawner_targetname, groupname, opt_activate_reinforcements );
}


//############################################################################
//  this is a copy of flood_spawner with minor modifications
//	adds groupname so they can be deleted later
//
reinforcement_spawner_think( trigger )
{
	self.active = true;	// flag this spawner so we don't try spawning from it again (like in flag_spawn).
	self endon("death");
	self notify ("stop current floodspawner");
	self endon ("stop current floodspawner");

	// pyramid spawner is a spawner that targets another spawner or spawners
	// First the targetted spawners spawn, then when they die, the reinforcement spawns from
	// the spawner this initial spawner
	if ( is_pyramid_spawner() )
	{
		pyramid_spawn( trigger );
		return;
	}
		
	requires_player = trigger_requires_player( trigger );

	script_delay();
	
	while ( self.count > 0 )
	{
		while ( requires_player && !level.player isTouching( trigger ) )
			wait (0.5);


		if ( isDefined( self.script_forcespawn ) )
			soldier = self stalingradSpawn();
		else
			soldier = self doSpawn();

		if ( spawn_failed( soldier ) )
		{
				wait (2);
				continue;
		}

		soldier.groupname = level.reinforcement_groupname;	// added for cleanup
		soldier SetAlertStateMin("alert_red");

		soldier thread reincrement_count_if_deleted( self );
		soldier thread expand_goalradius( trigger );
//		soldier thread reinforcement_awareness();	// don't do the slow reaction to seeing Bond
		soldier SetPerfectSense( true );		// Just keep them in perfect sense because they will revert to green on restart

		// if a script_parameters is defined, then try to automagically spawn a thread
		if ( IsDefined(soldier.script_parameters) )
		{
			soldier runthread_start();
		}

		soldier waittill ("death");

		// soldier was deleted, not killed
		if ( !isDefined( soldier ) )
			continue;

		if ( !script_wait() )
			wait (randomFloatRange( 3, 5 ));
	}
}


//
//	Setup AIs at start
//
reinforcement_awareness( opt_duration )
{
	self endon( "death" );

	if ( !IsDefined( opt_duration ) )
	{
		opt_duration = 3.0;
	}

	self SetPerfectSense( true );
	wait( opt_duration );

	self SetPerfectSense( false );
}


//############################################################################
//  Head towards the player for now
//	
//	TODO: slowly shrinking goal radius when can't see player
//
reinforcement_pursue( delay )
{
	self endon( "death" );

	self LockAlertState("alert_red");
	wait( 1 );
	self UnLockAlertState();
	self.goalradius = 64;
	last_known_pos = level.player.origin;

	wait( delay );	// delay before moving out
	// keep looking for Bond
	while ( 1 )
	{
		while ( !self CanSee(level.player) )
		{
			self.goalradius = 64;
			self SetGoalPos( last_known_pos );
			wait(0.1);
		}

		// We see Bond, stop and engage
		while ( self CanSee(level.player) )
		{
			self.goalradius = 768;
			last_known_pos = level.player.origin;
			self SetGoalPos( last_known_pos );
			wait( 0.5 );
		}

		// Okay we lost him, wait a bit before trying to pursue.
		wait( RandomIntRange( 5, 15) );
	}

//	self SetTetherRadius( 1024 );
}


//############################################################################
//	Save current origin and angles.
//		
save_orientation()
{
	self.saved_origin = self.origin;
	self.saved_angles = self.angles;
}


//############################################################################
//	sniper behavior
//		search_time = initial search time (before player is spotted)
//		target_origin = initial search location
//		sInterrupt = is this interruptable?  (string)
//
sniper( search_time, start_targetname, sInterrupt )
{
	self endon( "end_sniper" );
	self endon( "death" );

	interruptable = false;
	if ( IsDefined(sInterrupt) && sInterrupt == "true" )
	{
		interruptable = true;
	}

	if ( IsDefined(self.target) )
	{
		self StopAllCmds();	// clear away any previous actions
		self thread goto_spot( self.target, 32 );
		self waittill( "goal" );
	}

	// How long you have to search initially before you can try to lock on.
	if ( !IsDefined(search_time) )
	{
		search_time = 0;
	}
	else
	{
		search_time = int(search_time);	// convert ascii to integer
	}

	self.sniper_mode = "";	// Init to empty so we can switch to scan mode at the start

	if ( IsDefined( start_targetname ) )
	{
		start_target = GetEnt( start_targetname, "targetname" );
		if ( IsDefined( start_target ) )
		{
			self.fake_target = Spawn("script_origin", start_target.origin );
		}
	}
	if ( !IsDefined( self.fake_target ) )
	{
		self.fake_target = Spawn("script_origin", level.player.origin );
	}

//	self.sniper_target = self.fake_target;
	timer = 0;
	self thread sniper_aim();

	acquire_time	= 1.0;		// How long it takes to start a lock from the time LOS is achieved
	lockon_time		= 2.0;		// How long you have to have a lock in order to fire
	lock_loss_time	= 3.0;		// How long you have to wait to lose the lockon if you lose LOS
	timeout			= 0;		// Timer for losing lockon
	fire_timer		= 0;		// Timer for shooting
	first_time		= true;		// initial time through the loop - simulate delayed scanning
	while (1)
	{
		// Scan until target found (timer expires or shot at)
		if ( self.sniper_mode != "scan" )
		{
//			print3d( self.origin+(0,0,-72), "SCAN", (0,1,0), 1, 3, 20 );
			self.sniper_mode = "scan";
//			self.sniper_target = self.fake_target;
			self.fake_target_base_pos = self.fake_target.origin;
			self StopAllCmds();
			self CmdAimAtEntity( self.fake_target, interruptable, -1 );

			timer = gettime()+(search_time*1000);
			while( gettime() < timer )
			{
				// okay stop scanning
				if ( first_time && self GetAlertState() != "alert_green" )
				{
					break;
				}
				wait( 0.05 );
			}
			first_time = false;
		}

		// Enter tracking mode - if track target for more than X time, shoot, else scan until found again.
		if ( self CanSee( level.player ) )
		{
			if ( self.sniper_mode == "scan" )
			{
				wait( acquire_time );	// simulate delayed reaction to seeing player

//				print3d( self.origin+(0,0,0), "LOCK", (1,1,0), 1, 3, 20 );
				self.sniper_mode = "target_sighted";
//				self.sniper_target = level.player;
				search_time = 1.0;	// lower the search time

				self StopAllCmds();	// stop aiming at the fake target
				self CmdAimAtEntity( self.fake_target, interruptable, -1 );
			}

			lost_lock = false;
			while ( !lost_lock )
			{
				if ( !self CanSee( level.player ) )
				{
					if ( timeout == 0)
					{
						self.sniper_mode = "target_no_LOS";
						self.fake_target_base_pos = level.player.origin;
						timeout = gettime() + (3.0 * 1000);  // milliseconds, boys and girls
						fire_timer = 0;
					}
					if ( gettime() >= timeout )
					{
						lost_lock = true;
//						self.sniper_mode = "scan";
						continue;	// this will cause us to pop out of this loop, then reinitialize "scan" mode in the outer loop
					}
				}
				else	// cansee the player
				{
					self.sniper_mode = "target_sighted";
					if ( fire_timer == 0 )
					{
						fire_timer = gettime()+((lockon_time+RandomFloatRange(0.0,2.0))*1000);	// set lock-on time before shooting, bonus of half the time required
						timeout = 0;
					}
					if ( gettime()>fire_timer )
					{
						// SHOOT!
//						print3d( self.origin+(0,0,72), "BANG!", (1,0,0), 1, 3, 20 );
//						fire_timer = 0;
						self StopAllCmds();	// stop aiming at the fake target
//						self CmdShootAtEntity( level.player, false, 1.0, 1000 );
						self CmdShootAtEntityXTimes( level.player, false, 1, 5000 );
						if ( Distance( level.player.origin, self.origin ) < 2000 )
						{
							self CmdAimAtEntity( level.player, interruptable, -1 );
						}
						else
						{
							self CmdAimAtEntity( self.fake_target, interruptable, -1 );
						}
						// delay before being able to fire again
						timer = gettime() + ( RandomFloatRange(1.0,2.0)*1000);
						while(gettime()<timer)
						{
							wait( 0.05 );
						}
					}
				}
				wait( 0.05 );

			}
		}
		wait( 0.05 );

	}
}


//
sniper_aim( )
{
	self endon("stop_laser");
	self endon("death");

	rand_min = -100;
	rand_max = 100;
	r = 0.6;
	g = 0.1;
	b = 0.1;
	move_aimpoint = true;
	timer = 0;
	height = 0.0;
	
	while (1)
	{
		if ( self.sniper_mode == "scan" )
		{
			if ( move_aimpoint )
			{
				if ( Distance( self.origin, self.fake_target_base_pos ) > 1000 )
				{
					height = RandomFloatRange(90, 100);
				}
				else
				{
					height = RandomFloatRange(48, 96);
				}
				new_pos = self.fake_target_base_pos + ( RandomFloatRange(rand_min, rand_max), RandomFloatRange(rand_min, rand_max), height );
				time = RandomFloatRange( 2.0, 4.0 );
				self.fake_target MoveTo( new_pos, time, time/4.0, time/4.0 );
				timer = gettime() + ( (time+RandomFloatRange( 1.0, 2.0 ) )* 1000);	// rand == hold position for a small amount of time too!
				move_aimpoint = false;
			}
			else
			{
				if ( gettime() >= timer )
				{
					move_aimpoint = true;
				}
			}
		}
		else if ( self.sniper_mode == "target_sighted" )
		{
			// Calculate aimpoint
			height = level.player getPlayerViewHeight() + 4.9;	// approximate camera height
			// Distance adjustment - aim is a bit off so make it go over the players head to give a better illusion
// 			if ( distance( self.origin, self.sniper_target.origin ) > 1000 )
// 			{
// 				height = height + 160.0;	
// 			}
			// origin + height adjustment + eye adjustment (camera isn't cenetered)
			self.fake_target.origin = level.player.origin + (0,0,height);
//			self.fake_target.origin = level.player.origin + (0,0,height) + (AnglesToRight((0.0, level.player.angles[1], 0.0))*2.0);
		}
//	 	print3d( self.fake_target.origin, "+", (1,0,0), 1.0, 1, 1 );
		wait( 0.05 );
	}
}


//############################################################################*
// when you reach your goal, delete yourself
//
tether_on_goal( radius )
{
	self endon( "death" );
	self waittill( "goal" );

	if ( !IsDefined(radius) )
	{
		radius = 256;
	}
	else
	{
		radius = int( radius );
	}

	if ( self IsOnPatrol() )
	{
		self StopPatrolRoute();
	}
	wait(0.05);

	self.tetherpt = self.origin;
	self.tetherradius =  radius;
}


//############################################################################
//	Depending on the action, wait for a trigger or notify, then perform some action
trig_tutorial_message( msg, waittime )
{
	self waittill( "trigger" );

	tutorial_block( msg, waittime );
}


//############################################################################
//	Depending on the action, wait for a trigger or notify, then perform some action
//	Thread on an AI
//	spawnername = targetname of the AI's spawner
//
//	actions:
//		trig_patrol - wait for trigger then start a patrol.  if there is no route specified (param), then
//			check to see if a target is used and pause that.
//
wait_action( action, waitname, param )
{
	self endon( "death" );

	wait(0.1);

	if ( action == "trig_goalnode" )
	{
		// Don't do anything until the trigger is hit
		trigger = GetEnt( waitname, "targetname" );
		if ( IsDefined(trigger) )
		{
			trigger waittill( "trigger" );

			// creates a bit of randomness so a group of guys don't look robotic
			wait( randomfloat(1.0) );

			// This kills the automatic go_to_node thread in _spawner
//			self notify ("stop_going_to_node");
			self thread follow_path( param );
		}
	}
	else if ( action == "trig_patrol" )
	{
		pause = false;
		if ( !IsDefined( param ) )
		{
			if ( IsDefined( self.target ) )
			{				
				pause = true;
				self pausepatrolroute();
			}
		}
		// Don't do anything until the trigger is hit
		trigger = GetEnt( waitname, "targetname" );
		if ( IsDefined(trigger) )
		{
			trigger waittill( "trigger" );

			// creates a bit of randomness so a group of guys don't look robotic
			wait( randomfloat(0.5) );

			if ( pause )
			{
				self resumepatrolroute();
//				self startpatrolroute( self.target );
			}
			self startpatrolroute( param );
		}
	}
	else if ( action == "notify_patrol" )
	{
		level waittill( waitname );

		// creates a bit of randomness so a group of guys don't look robotic
		wait( randomfloat(1.0) );

		self startpatrolroute( param );
	}
}


//############################################################################
// 
//	
set_tether( nodename )
{
	if ( self IsOnPatrol() )
	{
		self StopPatrolRoute();
		wait(0.05);
	}
	self.tetherpt = self.origin;
	if ( IsDefined( self.script_int ) )
	{
		self.tetherradius = self.script_int;
	}
	else	
	{
		self.tetherradius = 150;
	}
}


//############################################################################
//	Set vision set.  This thread runs on a trigger_multiple	
//	Make sure curr_visionset is initialized.
set_visionset( new_set, time )
{
	if ( !IsDefined( level.curr_visionset ) )
	{
		level.curr_visionset = "";
	}

	while ( 1 )
	{
		self waittill( "trigger" );

		if ( level.curr_visionset != new_set )
		{
			level.curr_visionset = new_set;

			// Set transition time (overrides value from trigger)
			switch ( new_set )
			{
			case "Operahouse":
				time = "2";
				break;
			case "Operahouse_int_01":
				time = "2";
				break;
			case "Operahouse_sunset":
				time = "4";
				break;
			case "Operahouse_sunset_02":
				time = "2";
				break;
			case "Operahouse_sunset_03":
				time = "300";
				break;
			case "Operahouse_water":
				time = "2";
				break;
			default:
				time = "2";
			}
			// godray settings
			if ( new_set == "Operahouse_water" )
			{
				SetSavedDvar( "r_godraysPosX2", "-0.213099" );
				SetSavedDvar( "r_godraysPosY2", "1.17579" );
			}
			else
			{
				SetSavedDvar( "r_godraysPosX2", "0.0" );
				SetSavedDvar( "r_godraysPosY2", "0.0" );
			}
			VisionSetNaked( new_set, int(time) );
			//SetQKVisionSet( new_set+"_qk" );	//temp commented out for demo -jc
		}
	}
}


//############################################################################
//	runthread version of spawn_guys
//		Main point is to use groupnames to make deletion easier
//
trigger_spawn_guys( groupname )
{
	self waittill("trigger");

	spawn_guys( self.target, false, groupname );
}

//############################################################################
//	Looks for entities with targetname and spawns them
//		targetname = base targetname of spawners.  E.g. "guy" for "guy1", "guy2", etc.
//	OPTIONAL ARGUMENTS:
//		force_spawn = force the spawn with StalingradSpawn?  Default false
//		ai_type = string.  Patrol type: "civ"=civilian patroller, "thug"=enemy patroller. default(none)
//		assign_name = optionally assign each spawned AI a unique targetname starting with (targetname + "0")
//	Returns the group of spawned AI in an array for reference later
//
spawn_guys( targetname, force_spawn, groupname, ai_type, assign_name )
{
	if ( !IsDefined(force_spawn) )
	{
		force_spawn		= false;
	}
	if ( !IsDefined(ai_type) )
	{
		ai_type		= "";
	}
	if ( !IsDefined(assign_name) )
	{
		assign_name		= false;
	}

	guys = [];
	spawners = GetEntArray( targetname, "targetname" );
	if ( IsDefined(spawners) )
	{
		for (i=0; i<spawners.size; i++)
		{
			// Normal spawn or Force spawn
			if ( force_spawn )
			{
				new_guy = spawners[i] StalingradSpawn();
			}
			else
			{
				new_guy = spawners[i] DoSpawn();
			}

			if ( spawn_failed(new_guy) )
			{
				print( "spawn_group failed: i="+i+", targetname="+targetname );
				break;
			}

			// Assign Groupname if necessary
			if ( IsDefined( groupname ) && groupname != "" )
			{
				new_guy.groupname = groupname;
			}

			// Figure out the new name if applicable
			if ( assign_name )
			{
				new_guy.targetname = targetname + "_ai";
			}

			// Patrol type
			//	1 is a civilian, get very close to where you're going and don't carry a weapon
			if ( ai_type == "civ" )
			{
				new_guy.goalradius = 12;

				//xxx temp hacks to indicate civilian
//				new_guy SetEngageRule( "Never" );
				new_guy animscripts\shared::placeWeaponOn( new_guy.primaryweapon, "none" );	//xxx haxxor to remove weapon
//				new_guy thread print3d_info( "civilian", undefined, (0,1,0) );
				new_guy lockalertstate( "alert_green" );
			}
			// 2 is an enemy patroller
			else if ( ai_type == "thug" )
			{
				new_guy.goalradius = 12;
				new_guy thread reinforcement_monitor();
				new_guy thread radio_chatter();
			}
			// 3 is an (yellow) alert enemy patroller
			else if ( ai_type == "thug_yellow" )
			{
				new_guy.goalradius = 32;
				new_guy SetAlertStateMin("alert_yellow");
				new_guy thread reinforcement_monitor();
			}

			// 3 is an (red) alert enemy patroller
			else if ( ai_type == "thug_red" )
			{
				new_guy.goalradius = 64;
				new_guy SetAlertStateMin("alert_red");
//				new_guy thread reinforcement_monitor();	// don't need 
			}

			// if a script_parameters is defined, then try to automagically spawn a thread
			if ( IsDefined(new_guy.script_parameters) )
			{
				new_guy runthread_start();
			}

			guys[guys.size] = new_guy;
		}
	}

	// If there's only one, return the entity, otherwise return the array.
	if ( guys.size == 1 )
	{
		return guys[0];
	}
	else
	{
		return guys;
	}
}


//############################################################################
//	Looks for entities starting with (targetname + number) and spawns them
//	Returns the group of spawned AI in an array for reference later
//		targetname = targetname prefix
//  OPTIONAL:
//		startnum = optional starting number after targetname.  Defaults to 1
//		force_spawn = force the spawn with StalingradSpawn?  Default false
//		ai_type = int.  Patrol type: 1=civilian patroller, 2=enemy patroller, 3=follow path. default 0 (none)
//		assign_name = optionally assign each spawned AI a unique targetname starting with (targetname + "0")
//
spawn_guys_ordinal( targetname, startnum, force_spawn, groupname, ai_type, assign_name )
{
	if ( !IsDefined( startnum ) )
	{
		num = 1;
	}
	else
	{
		num = startnum;
	}

	guy_array = [];

	// Keep trying to spawn guys and stop when you don't get one
	guy = spawn_guys( targetname+num, force_spawn, groupname, ai_type, assign_name );
	while ( IsDefined(guy) && IsAlive(guy) )
	{
		guy_array[guy_array.size] = guy;

		num++;
		guy = spawn_guys( targetname+num, force_spawn, groupname, ai_type, assign_name );
	}

	if ( guy_array.size == 1 )
	{
		return guy_array[0];
	}
	else
	{
		return guy_array;
	}
}


//############################################################################
//  Time limit counter, stolen from construction site util create_time_limit
time_limit_init( time_left )
{
	level endon("time_limit_stop");

	level.timer_hud = newHudElem();
//	level.timer_hud.alignX = "center";
//	level.timer_hud.alignY = "top";
//	level.timer_hud.fontScale = 3.0;
//	level.timer_hud.x = 0;
//	level.timer_hud.y = 50;
//	level.timer_hud.horzAlign = "center";
//	level.timer_hud.vertAlign = "fullscreen";
//	level.timer_hud setText( time_left );
	level.timer_hud.alpha = 0;

	level thread time_limit_end();
	level thread time_limit_fail();
	level.clock_running = true;

	while ( time_left >= 0.0 )
	{
//		level.timer_hud settext( time_left );
		level.timer_hud.time = time_left;
		wait(1.0);

		time_left = time_left - 1.0;
	}
	
//	level.timer_hud settext( 0.0 );
	level.timer_hud.time = 0.0;

	level.clock_running = false;
	level notify("time_limit_reached");
}
time_limit_end()
{
	level waittill("time_limit_stop");

	level.clock_running = false;
	level.timer_hud destroy();

	//// turn off pip.
//	SetDVar("r_pipMainMode", 0);
	SetDVar("r_pipSecondaryMode", 0);
}
time_limit_fail()
{
	level waittill("time_limit_reached");
	
	//// turn off pip.
//	SetDVar("r_pipMainMode", 0);
	SetDVar("r_pipSecondaryMode", 0);

	//MissionFailedWrapper();
	level notify( "time_limit_expired" );
	level.timer_hud destroy();
}



//############################################################################
//  Triggered runthread version of holster_weapons
//
trig_holster_weapons( end_on )
{
	if ( IsDefined( end_on ) )
	{
		level endon( end_on );
	}

	while( true )
	{
		self waittill( "trigger" );

		holster_weapons();
	}
}


//############################################################################
//  Triggered runthread version of unholster_weapons
//
trig_unholster_weapons( end_on )
{
	if ( IsDefined( end_on ) )
	{
		level endon( end_on );
	}

	while( true )
	{
		self waittill( "trigger" );

		unholster_weapons();
	}
}


//############################################################################
//  Triggered runthread version of unholster_weapons
//
tutorial_block( msg, waittime, distance )
{
	level endon( "tutorial_end" );

	if ( !IsDefined( distance ) )
	{
		distance = 256;
	}
	if ( !IsDefined(waittime) )
	{
		waittime = 10.0;
	}

	level thread tutorial_skip( msg, distance );

	tutorial_message( msg );
	wait( waittime );

	tutorial_message( "" );
	level notify( "tutorial_end" );
}


//############################################################################
//  Triggered runthread version of unholster_weapons
//
tutorial_skip( msg, distance )
{
	level endon( "tutorial_end" );

	start_pos = level.player.origin;
	while ( Distance( level.player.origin, start_pos ) < distance )
	{
		wait( 0.1 );
	}

	// end tutorial
	tutorial_message( "" );
	level notify( "tutorial_end" );
}


//############################################################################
//  split screen
//
split_screen()
{
	//turn off weapon icon - hud will negate border
  setdvar("ui_hud_showstanceicon", "0"); 
  setsaveddvar ( "ammocounterhide", "1" );
	
	//crop and move down
	level thread main_crop();
	level thread main_move();
	
	//PIP
	level thread second_move();
		
}


main_crop()
{
	//set border size and color
	setdvar("cg_pipmain_border", 2);
	setdvar("cg_pipmain_border_color", "0 0 0.2 1");
	
	//set main window
	SetDVar("r_pipMainMode", 1);	//set window
	SetDVar("r_pip1Anchor", 4);		// use top middle anchor point

	//crop window
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, -1, 1, 0.5, 0, 0);
	level.player waittill( "animatepip_done" );
	//wait(0.6);
		
	level notify( "main_crop" );
		
	level waittill( "main_up" );

	//uncrop
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, -1, 1, 1, 0, 0);
	level.player waittill( "animatepip_done" );
	//wait(0.55);
	
	//reset back to default
	SetDVar("r_pip1Scale", "1 1 1 1");		// default
	SetDVar("r_pipMainMode", 0);	//so aiming not messed up
	
	//hud
	setdvar("ui_hud_showstanceicon", "1"); 
  setsaveddvar ( "ammocounterhide", "0" );
}

//
main_move()
{
	
	level waittill( "main_crop" );
		
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, 0.16 );
	level.player waittill( "animatepip_done" );
	//wait(0.6);
	
	level notify( "main_down" );
	
	level waittill( "pip_offscreen" );
	
	level.player animatepip( 500, 1, -1, 0 );
	level.player waittill( "animatepip_done" );
	//wait(0.8);
	
	level notify( "main_up" );
}


//pip
second_move()
{
	//moved earlier. will crash unless set up right away - bug?
	//setup pip camera
	level.player setsecuritycameraparams( 45, 3/4 );

	SetDVar( "r_lodBias", -5500 );	// Force people to LOD0

	//setup PIP
	//SetDVar("r_pipSecondaryX", .6 );						// start off screen
	//SetDVar("r_pipSecondaryY", -.3);						// place top right corner of display safe zone
	//SetDVar("r_pipSecondaryAnchor", 4);						// use top left anchor point
	//SetDVar("r_pipSecondaryScale", ".36, .5, .35, .5");		// scale image, without cropping
	//SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio
	SetDVar("r_pipSecondaryX", -0.2 );						// start off screen
	SetDVar("r_pipSecondaryY", -0.13);						// place top left corner of display safe zone
	SetDVar("r_pipSecondaryAnchor", 4);						// use top left anchor point
	SetDVar("r_pipSecondaryScale", "1 0.55 1.0 0");		// scale image, without cropping
	SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio

	wait(0.05);	//need this or it will crash
// 	cameraID_ledge = level.player securityCustomCamera_Push( 
// 		"entity",
// 		level.player,
// 		( -1250, 65, 450),
// 		( 20, 0, 0),
// 		0.1);
	if ( level.xenon )	// Xenon
	{
		cameraID_ledge = level.player securityCustomCamera_Push( 
				"world",
				level.player,
				( 898, -376, 929),	// Xenon
				( 4, 0, 0),
				0.1);
		level.player SecurityCustomCamera_setFoV(
			cameraID_ledge,		// <required ID returned from customCameraPush>
			40.0,				// <required the fov (in degrees) of the camera>
			0.0,				// <optional time to 'tween/lerp' to the camera, default same as camera>
			0.0,				// <optional time used to accel/'ease in', default same as camera> 
			0.1					// <optional time used to decel/'ease out', default same as camera>
			);
	}
	else
	{
		cameraID_ledge = level.player securityCustomCamera_Push( 
			"world",
			level.player,
			( 3102.61, -1611.46, -185.02 ),	// Low angle
//			( 3283.76, -1160.91, 449.481 ),	// high angle
			( 0, 0, 0),
			0.1);
		level.player SecurityCustomCamera_setFoV(
			cameraID_ledge,		// <required ID returned from customCameraPush>
			30.0,				// <required the fov (in degrees) of the camera>
			0.0,				// <optional time to 'tween/lerp' to the camera, default same as camera>
			0.0,				// <optional time used to accel/'ease in', default same as camera> 
			0.1					// <optional time used to decel/'ease out', default same as camera>
			);
	}
	//set border and color
	setdvar("cg_pipsecondary_border", 2);
	setdvar("cg_pipsecondary_border_color", "0 0 0.2 1");
		
	//set up the pip	
	//start offscreen
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	//level.player animatepip( 100, 0, -0.2, -0.13, 1.0, 0.55, 1.0, 0);

	//level thread second_anim();
	level waittill( "main_down" );

	SetDVar("r_pipSecondaryMode", 5);		// enable video camera display with highest priority 		

	//move pip onscreen
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 0, 0.25, -1 );
	level.player waittill( "animatepip_done" );
	//wait(0.5);

	//level.player animatepip( 3000, 0, 0.6, .3);

	//notify or trigger
	trig = GetEnt( "trig_e2_off_ledge", "targetname" );
	trig waittill( "trigger" );

	//move pip offscreen
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 0, 1, -1 );
	level.player waittill( "animatepip_done" );

	//wait(0.5);
		
	SetDVar( "r_lodBias", 0 );	// Return to normal

	level notify( "pip_offscreen" );
	
	//reset
	SetDVar("r_pipSecondaryMode", 0);	
	level.player securitycustomcamera_pop( cameraID_ledge );
}

//bond anim during pip
second_anim()
{
	level endon("pip_off_screen");

	while (true)
	{
		level.player PlayerAnimScriptEvent("pb_security_lock");
		wait .05;
	}
	
}

//08/15/08
// jeremyl

slow_time(val, tim, out_tim)
{
	self endon("stop_timescale");

	//thread check_for_death();
	SetSavedDVar( "timescale", val);

	wait(tim - out_tim);

	change = (1-val) / (out_tim*30);
	while(val < 1)
	{
		val += change;
		SetSavedDVar( "timescale", val);
		wait(0.05);
	}

	SetSavedDVar("timescale", 1);

	level notify("timescale_stopped");
}
