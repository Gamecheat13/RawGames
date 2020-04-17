#include animscripts\shared;
#include maps\_utility;
#include maps\_spawner;
//#include maps\mp\_utility;
#include maps\_anim;
#using_animtree("generic_human");


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
		iPrintLnBold( "WARNING!  Couldn't find a matching thread for a function called "+tokens[0] );
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


//############################################################################*
//	Add something to an array, it can either be a single thing or an array of stuff
//		array - must be an array.
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
//	Special autosave check function - don't save if an enemy is on alert or you will
//	most likely die
//
check_no_enemies_alerted()
{
	nme = GetAIArray( "axis" );
	for ( i=0; i<nme.size; i++ )
	{
		if ( nme[i] GetAlertState() != "alert_green" )
		{
			return false;
		}
	}

	return true;	// all clear
}

//############################################################################*
//	Play lookover command.  Used for patrols
//
cmdaction_lookover( )
{
	wait( 0.5 );
	self cmdaction( "lookover" );
}


//############################################################################*
//	Play lookover command.  Used for patrols
//
cmdaction_fidget( )
{
	wait( 0.5 );
	self cmdaction( "fidget" );
}


//############################################################################*
// cover_lock - keep player stuck in cover while touching the trigger
cover_lock()
{
	level.player endon( "damaged_on_ledge" );	// stop the death thread

	in_cover = false;
	camera_id = undefined;	// higher scope declaration 
	while( 1 )
	{
		self waittill( "trigger" );

//iprintln("force cover");
		level.player notify( "on_ledge" );	// stop the death thread
		wait(0.4);
		holster_weapons();
//		level.player AllowCrouch( false );
		push_vector = ( 0.0, 0.0, 0.0 );
		if ( IsDefined(self.script_int) )
		{
			push_vector = AnglesToForward( (0.0, self.script_int, 0.0) );
		}
		level.player thread cover_ledge_hurt( push_vector );

		// setup the cameras
// 		if ( IsDefined(self.script_noteworthy) )
// 		{
// 			if ( self.script_noteworthy == "e2_outside" )
// 			{
// 				level.camera_id = level.player customCamera_push(
// 						"offset_abs",		// <required string, see camera types below>
// //						level.player,		//<required only by "entity" and "entity_abs" cameras>
// 						( 138.47,  -31.54,  119.11),	// <optional positional vector offset, default (0,0,0)>
// 						(  29.82,   55.29,    0.00),	// <optional angle vector offset, default (0,0,0)>
// 						1.0 );		// <optional time to 'tween/lerp' to the camera, default 0.5>
// 			}
// 		}

		while( level.player IsTouching(self) )
		{
			level.player playerSetForceCover( true );
			wait(0.1);
		}

//iprintln("unforce cover");
		level.player notify( "off_ledge" );	// stop the death thread
		level.player playerSetForceCover( false );
//		level.player AllowCrouch( true);
		unholster_weapons();
// 		if ( IsDefined(level.camera_id) )
// 		{
// 			level.player customCamera_pop( 
// 						level.camera_id,	// <required ID returned from customCameraPush>
// 						1.0,	// <optional time to 'tween/lerp' to the previous camera, default prev camera>
// 						0.5,	// <optional time used to accel/'ease in', default prev camera> 
// 						0.5 );	// <optional time used to decel/'ease out', default prev camera>
//			level.camera_id = undefined;
// 		}
	}
}


//############################################################################*
//	Check to see if you get hurt while in cover.  If so, then unlock the player and push them off
//	Run this thread on the player
cover_ledge_hurt( push_vector )
{
	self endon( "off_ledge" );

	self waittill( "damage" );

	self notify( "damaged_on_ledge" );
	wait(0.05);
	self playerSetForceCover( false );
	iPrintLnBold( "Bond Shot - get pushed off the ledge and DIE  0.4" );

	wait(0.5);
//	level.player freezeControls(true);
	level.player knockback( 9000, (level.player.origin+(push_vector*10)) );

	// Failsafe
	wait( 2.0 );
	level.player DoDamage( 10000, self.origin );
	if ( IsDefined(level.camera_id) )
	{
		level.player customCamera_pop( 
					level.camera_id,	// <required ID returned from customCameraPush>
					1.0,	// <optional time to 'tween/lerp' to the previous camera, default prev camera>
					0.5,	// <optional time used to accel/'ease in', default prev camera> 
					0.5 );	// <optional time used to decel/'ease out', default prev camera>
		level.camera_id = undefined;
	}
}


//
//	used for Challenge Achievement monitoring
//
death_monitor()
{
	self waittill( "death", strAttacker, strType, strWeapon );

	pk = false;
	if ( IsDefined(strAttacker) )
	{
		if ( strAttacker == level.player )
		{
			pk = true;
		}
	}
	if ( IsDefined( strType ) )
	{
		if ( strType == "MOD_MELEE" )
		{
			pk = true;
		}
	}

	if ( pk )
	{
		level.guy_killed = true;
	}
}

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
//	Listen for door opening messages then play sound.
//
door_slam( )
{
	self endon( "death" );

	while (1)
	{
		self waittill("opening_door");	

		if ( self GetAlertState() == "alert_red" )
		{
			if ( RandomInt(100) < 50 )
			{
				self PlaySound( "CAS_big_door_01" );
				level.player PlaySound( "CAS_big_door_01" );	//xxx play on player so he hears it for now.
			}
			else
			{
				self PlaySound( "CAS_big_door_02" );
				level.player PlaySound( "CAS_big_door_02" );	//xxx play on player so he hears it for now.
			}
		}
	}
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
		else
		{
			break;	//otherwise guy stands around looping -jc
		}
	}

	self notify( "follow_path_reached_end" );
}



//############################################################################
//	Spawn cars and have them drive through the street.
//
driveway_vehicles( endon_msg )
{
	level endon( endon_msg );

	// list the types of vehicles that we'll spawn
	vmodels	= [];

	vmodels[0]		  = spawnstruct();
	vmodels[0].model = "v_sedan_silver_radiant";
	vmodels[0].vtype = "sedan";

	vmodels[1]		  = spawnstruct();
	vmodels[1].model = "v_sedan_blue_radiant";
	vmodels[1].vtype = "sedan";

	// Get a list of nodes that we'll spawn from
	vnodes[0] = GetVehicleNode( "vn_driveway1", "targetname" );
	vnodes[1] = GetVehicleNode( "vn_driveway2", "targetname" );


	// "Pause_driveway1" stops spawning cars on driveway1 so we can activate our special drive-in car.
	flag_init( "pause_driveway1" );	
	
	// Now create a random vmodels to drive on a random path 
	while ( 1 )
	{
		vmodel	= vmodels[ RandomInt( vmodels.size ) ];

		if ( level.flag[ "pause_driveway1" ] )
		{
			vnode	= vnodes[ 1 ];
		}
		else
		{
			vnode	= vnodes[ RandomInt( vnodes.size ) ];
		}

		vehicle = spawnVehicle( vmodel.model, "driveby_vee", vmodel.vtype, vnode.origin, vnode.angles );

		vehicle attachpath( vnode );
		vehicle startpath();
		vehicle thread delete_at_end();

		//CG - attaching vechicle light effects		
		vehicle thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight02"], "tag_light_l_front" );
		vehicle thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight02"], "tag_light_r_front" );
		vehicle thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_l_back" );
		vehicle thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_r_back" );

		wait ( RandomFloatRange( 6.0, 12.0 ) );
	}
}


//############################################################################
// For vehicles, delete yourself when you reach the end of your nodes.
//
delete_at_end()
{
	self waittill( "reached_end_node" );

	self delete();
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

Ai_SetPerfectSenseUntillThreatIsPlayer(timeAfter)
{
	self endon("death");

	self SetPerfectSense(true);

	while( !self IsMainThreat(level.player) )
	{		
		wait(randomfloat(0.1,0.3));	//Use random to avoid every AI being in sync
	}
	
	//Give at least 1 seconds to make sure we acquire the player properly
	wait(timeAfter);
	
	self SetPerfectSense(false);
}

//############################################################################

Ai_SetEveryAiAccuracy(ents, acc)
{
	for ( i=0; i<ents.size; i++ )
	{
		if( IsDefined(ents[i]) )
		{
			ents[i].accuracy = acc;		
		}
	}
}

//############################################################################

Ai_AutoDisableSenseThread( oddDisable, time0, time1 )
{
	self endon("death");
	self endon("StopAutoDisableSense");

	while(IsDefined(self))
	{
		if( randomfloatrange(0,1) < oddDisable )
		{
			self SetShootAllowed(false);	
		}
		else
		{
			self SetShootAllowed(true);	
		}
		
		wait( randomfloatrange( time0, time1) );
	}
}

//############################################################################

Ai_StartAutoDisableSense(ents, oddDisable, time0, time1)
{
	for ( i=0; i<ents.size; i++ )
	{
		if( IsDefined(ents[i]) )
		{
			ents[i] thread Ai_AutoDisableSenseThread(oddDisable, time0, time1);		
		}
	}
}

//############################################################################

Ai_StopAutoDisableSense(ents)
{
	for ( i=0; i<ents.size; i++ )
	{
		ents[i] notify("StopAutoDisableSense");	
	}
	
	wait(0.2);

	for ( i=0; i<ents.size; i++ )
	{
		if( IsDefined(ents[i]) )
		{
			ents[i] SetShootAllowed(true);	
		}
	}

	
}

//############################################################################
//	Sets up shot-activated falling mousetraps.
//	Radiant setup:
//		1. Create a script_model, which will be the base.  Name it "mousetrap_falling" with script_parameters = "[damage_radius],[damage_per_frame],[damage_zoffset]"
//
//	Script setup
//		1. Add a call to player awareness that uses this function on Damage.
//
falling_mousetrap( object )
{
	trig = object.primaryEntity;
	mousetrap = undefined;
	if ( IsDefined(trig.target) )
	{
		mousetrap = GetEnt( trig.target, "targetname" );
	}
	// If there's no target, then use the base entity
	if ( !IsDefined(mousetrap) )
	{
		mousetrap = trig;
	}

//xxx	This is a temp hack until I can get a physics GDT set up
	// Fall straight downwards, until you reach -2000
	mousetrap thread maps\casino_util::ballistic_move( (0,0,-1), 0, -2000 );

	// Parameters should be: 
	//		0="falling_mousetrap"
	//		1=(damage radius)
	//		2=(damage per frame)
//	crash_fx = "";		// 0
	dmg_radius = 32;	// 1 - how big a damage radius to use
	dmg_amount = 100;	// 2 - how much damage to deal
	dmg_zoffset = 0;	// 3 - how far to adjust the damage pulse relative to the object's origin
	parameters = strtok( mousetrap.script_parameters, "," );
//	if ( IsDefined(parameters[1]) )
//	{
//		crash_fx = parameters[1];
//	}
	if ( IsDefined(parameters[0]) )
	{
		dmg_radius = int(parameters[0]);
	}
	if ( IsDefined(parameters[1]) )
	{
		dmg_amount = int(parameters[1]);
	}
	if ( IsDefined(parameters[2]) )
	{
		dmg_zoffset = int(parameters[2]);
	}

	mousetrap thread damage_ping( dmg_radius, dmg_amount, dmg_zoffset, "ballistic_move_done" );
	mousetrap waittill( "ballistic_move_done" );

//	play_fx("bell_dust",damage_origin.origin);
//	Print3d( mousetrap.origin, "CRASH!", (0,1,0), 1.0, 2.0, 60 );
}


//############################################################################
//	Ping damage until told to stop.
//
damage_ping( radius, damage, zoffset, opt_endon )
{
	if ( IsDefined( opt_endon ) )
	{
		self endon( opt_endon );
	}
	else
	{
		self endon( "stop_damage_ping" );
	}

	while (1)
	{
		radiusdamage( self.origin+(0,0,zoffset), radius, damage, damage );
//		iprintlnbold( "radius = " + radius + "   damage = " + damage  );
		wait( 0.05 );
	}
}



//############################################################################
//	Constantly print a message on someone.  The message can be updated by changing the .message
//

play_dialog_monitor( end_msg )
{
	//self endon( end_msg );
	self endon( "death" );
	
	//Start Propgating right away == very unforgiving
	self SetPropagationDelay(0.00);

	self waittill(end_msg);
	
	self SetPropagationDelay(0.75);
}

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


//############################################################################
//
//	closetlight
casino_light_flicker()
{
	while (1)
	{
		// stay on long
		iterations = RandomIntRange(10,30);
		for ( i = 0; i<iterations; i++ )
		{
			self setlightintensity(0.1);
			wait( 0.05 );
			self setlightintensity(0.15);
			wait( 0.05 );
		}
		
		// flicker
		self playsound("CAS_light_glitch");
		iterations = RandomIntRange(5,8);
		for ( i = 0; i<iterations; i++ )
		{
			self setlightintensity (0.1);
			wait( .05 + randomfloat( .1) );

			self setlightintensity (1.0);
			wait( .05 + randomfloat( .1) );
		}
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
			  self.radio_origin playsound ( "Walkie_Chatter", "radio_chatter_done" );
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
		level waittill("reinforcement_spawn");
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
//	if ( self.health > 0 ) //Propagation handle guy dying
	{
		level notify( "reinforcement_spawn" );
		level.broke_stealth = true;		// for achievement purposes
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
		soldier thread reinforcement_awareness();	// don't do the slow reaction to seeing Bond

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
reinforcement_awareness()
{
	self endon( "death" );

	self SetPerfectSense( true );
	wait( 5.0 );

	self SetPerfectSense( false );
}

//############################################################################

SetPerfectSenseTimerThread(timer)
{
	self endon( "death" );

	self SetPerfectSense(true);

	wait(timer);
	
	self SetPerfectSense(false);
}

//############################################################################

SetPerfectSenseTimer(timer)
{
	self thread SetPerfectSenseTimerThread(timer);
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

//This is a callback... 
intro_speaker()
{
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
// Move along a patrol path.  When you get to the end, start over.
//	nodename is the pt_routeid
patrol( nodename )
{
	self startpatrolroute( nodename );
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
spawn_guys( targetname, force_spawn, groupname, ai_type, assign_name, tether_pt, tether_radius)
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
				//print( "spawn_group failed: i="+i+", targetname="+targetname );
				//break;
				continue;
			}

			// Assign Groupname if necessary
			if ( IsDefined( groupname ) && groupname != "" )
			{
				new_guy.groupname = groupname;
			}

			new_guy thread DebugShowName(targetname);

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
				new_guy thread death_monitor();
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

			if (IsDefined(tether_pt))
			{
				new_guy.tetherpt = tether_pt;

				if (IsDefined(tether_radius))
				{
					new_guy SetTetherRadius(tether_radius);
				}
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

DebugShowName(targetname)
{
/*
	self endon("death");

	while( IsDefined(self) )
	{		
		if( isdefined(self.targetname) )
		{
			Print3d( self.origin, self.targetname, (0,1,0) );
		}
		else
		{		
			Print3d( self.origin, targetname, (1,0,0) );
		}

		wait( 0.05 );
	}
*/
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
spawn_guys_ordinal( targetname, startnum, force_spawn, groupname, ai_type, assign_name, spawn_wait )
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

		if( isdefined(spawn_wait) && spawn_wait > 0 )
		{
			wait(spawn_wait);
		}

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
// Move object ballistically starting at a vector which points at a target
//		target = self will be shot towards this object
//		speed_mph = speed to launch self (in miles per hour)
//		opt_stop_height = height at which to stop moving (since we're not doing collision detection)
ballistic_target( target, speed_mph, opt_stop_height )
{
	vec = target.origin - self.origin;
//	vec = AnglesToForward( vec );
	self ballistic_move( VectorNormalize( vec ), speed_mph, opt_stop_height);
}


//############################################################################
//	Move self in a ballistic trajectory, starting in the given direction
// 		direction = self will be shot towards the given direction vector
//		speed_mph = speed to launch self (in miles per hour)
//		opt_stop_height = height at which to stop moving (since we're not doing collision detection)
ballistic_move( direction, speed_mph, opt_stop_height )
{
	self endon( "ballistic_move_stop" );

	if ( !IsDefined( opt_stop_height) )
	{
		opt_stop_height = -10000;
	}

	gravity = 386.0886; // inches / second squared, or 9.8m/s*s  or 32.17405 ft/s*s

	interval	= 0.05;	// calculation interval in seconds

	// convert to inches per second
	//	(miles / hour) * (5280 feet * 12 inches) / (60 minutes * 60 seconds)
	speed = speed_mph * 63360 / 3600;

	// velocity is a direction and a speed (or the length of the vector which points in the direction)
	velocity = maps\_utility::vector_multiply( direction, speed );

	while ( 1 )
	{
		destination = self.origin + velocity;
		if ( destination[2] < opt_stop_height )
		{
			destination = (destination[0], destination[1], opt_stop_height);
			self MoveTo( destination, interval );
			self notify( "ballistic_move_done" );
			return;
		}
		self MoveTo( destination, interval );
		wait( interval );

		// add gravity!
		velocity = ( velocity[0], velocity[1], velocity[2]-(gravity*interval*interval) );
	}
}

/*
ballistic_test()
{
	bullet = GetEnt("ball", "targetname");
	target = GetEnt("ball_target", "targetname");
	
	start_spot = bullet.origin;
	wait(5.0);
	while (1)
	{
		bullet.origin = start_spot;
		wait(0.5);
		bullet ballistic_target( target, 10, 0 );

		wait( 1.0 );
	}
}
*/


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
			VisionSetNaked( new_set, int(time) );
			//SetQKVisionSet( new_set+"_qk" );	//temp commented out for demo -jc

			// Set Fog Values
			//if (new_set == "casino_01")
			//{
			//	// Inside
			//	setExpFog(0.0,2000.0,0.09,0.095,0.5,0);
			//}
			//else if (new_set == "casino_02")
			//{
			//	// Inside the air duct
			//	setExpFog(0.0,2000.0,0.09,0.095,0.5,0);
			//}
			//else if (new_set == "casino_03")
			//{
			//	// begining of spa
			//	setExpFog(0.0,1750.0,0.55,0.56,0.59,0);
			//}
			//else if (new_set == "casino_04")
			//{
			//	// second balcony, after spa
			//	setExpFog(0.0,1750.0,0.55,0.56,0.59,0);
			//}
			//else if (new_set == "casino_05")
			//{
			//	// hallway between second balcony and ballroom
			//	setExpFog(0.0,2000.0,0.09,0.095,0.5,0);
			//}
			//else if (new_set == "casino_06")
			//{
			//	// ballroom
			//	setExpFog(0.0,2700.0,0.35,0.35,0.35,0);
			//}
			//else if (new_set == "casino_07")
			//{
			//	// Outside (first balcony)
			//	setExpFog(0.0,12000.0,0.09,0.095,0.5,2.0);
			//}
		}
	}
}
