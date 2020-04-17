#include animscripts\shared;
#include common_scripts\utility;
#include maps\_utility;
#include maps\_spawner;

#include maps\_anim;
#using_animtree("generic_human");






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



cmdaction_ongoal( action )
{
	self endon( "death" );

	wait( RandomFloatRange(1.5,2.0) );

	self cmdaction( action );
	wait( 5.0 );

	
	self StopCmd();
}





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

		
		self SetCombatRole( "rusher" );
		wait( 4.0 );

		self SetCombatRole( "elite" );
	}
}




























































































































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





delete_on_goal()
{
	self endon( "death" );
	self waittill( "goal" );

	self delete();
}





cb_patrol_node_reached()
{
	self notify("patrol_node_reached");
}





follow_path( start_nodename )
{
	self endon( "death" );

	
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

		
		if ( IsDefined( radius ) )
		{
			self.goalradius = old_radius;
		}
	}
}







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

		
		if ( IsDefined( radius ) )
		{
			self.goalradius = old_radius;
		}
	}
}






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

	
	if ( start_thread )
	{
		
		for ( i=0; i<parent.linkEx_child.size; i++ )
		{
			parent.linkEx_child[i] notify( "parent_exists" );
		}

		parent thread linkEx_update();
	}
}

unlinkEx()
{
	if ( IsDefined(self.linkEx_parent) )
	{
		self.linkEx_parent = undefined;
		array_remove (self.linkEx_parent.linkEx_child, self);
	}
}



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





linkEx_update_child()
{
	for ( i=0; i<self.linkEx_child.size; i++ )
	{
		child = self.linkEx_child[i];
		angles = ( 0-self.angles[0], self.angles[1], self.angles[2] );
		
		x = vectorDot(child.linkEx_parent_offset, AnglesToForward(angles) );
		y = vectorDot(child.linkEx_parent_offset, AnglesToRight(angles) );
		z = vectorDot(child.linkEx_parent_offset, AnglesToUp(angles) );

		child.linkEx_nextpos = self.linkEx_nextpos + (x,y,z);

		child.origin = child.linkEx_nextpos;

		if ( IsDefined(child.linkEx_child) )
		{
			child linkEx_update_child();
		}
	}
}




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











runthread_start()
{
	
	if ( !IsDefined(self.script_parameters) )
	{
		return;
	}

	
	tokens = strtok( self.script_parameters, "," );
	
	func = level.runthread_func[ tokens[0] ];
	if ( !IsDefined( func ) )
	{
		iPrintLn( "WARNING!  Couldn't find a matching thread for a function called "+tokens[0] );
		return;
	}

	
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


		level.reinforcement_activated = true;
		
		if ( level.reinforcement_targetname != "" && level.reinforcement_targetname != "none" && 
			 last_activated != level.reinforcement_targetname )
		{
			if ( IsDefined( level.reinforcement_spawners ) )
			{
				for ( i=0; i<level.reinforcement_spawners.size; i++ )
				{

					level.reinforcement_spawners[i] thread reinforcement_spawner_think();

				}
			}
			last_activated = level.reinforcement_targetname;
		}
	}
}






reinforcement_monitor( )
{
	self endon( "death" );

	self waittill( "start_propagation" );



	if ( self.health > 0 )
	{
		level notify( "reinforcement_spawn" );
	}
}









reinforcement_update( spawner_targetname, groupname, opt_activate_reinforcements )
{
	
	if ( IsDefined( level.reinforcement_spawners ) )
	{
		for ( i=0; i<level.reinforcement_spawners.size; i++ )
		{
			level.reinforcement_spawners[i] notify ("stop current floodspawner");
		}
	}

	
	level.reinforcement_targetname = spawner_targetname;
	level.reinforcement_spawners = GetEntArray( level.reinforcement_targetname, "targetname" );
	level.reinforcement_groupname = groupname;
	if ( IsDefined(opt_activate_reinforcements) )
	{
		level.reinforcement_activated = opt_activate_reinforcements;
	}

	
	if ( level.reinforcement_activated )
	{
		level notify( "reinforcement_spawn" );
	}

}




trig_reinforcement_update( spawner_targetname, groupname, opt_activate_reinforcements )
{
	self waittill( "trigger" );

	reinforcement_update( spawner_targetname, groupname, opt_activate_reinforcements );
}






reinforcement_spawner_think( trigger )
{
	self.active = true;	
	self endon("death");
	self notify ("stop current floodspawner");
	self endon ("stop current floodspawner");

	
	
	
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

		soldier.groupname = level.reinforcement_groupname;	
		soldier SetAlertStateMin("alert_red");

		soldier thread reincrement_count_if_deleted( self );
		soldier thread expand_goalradius( trigger );
		soldier thread reinforcement_awareness();	

		
		if ( IsDefined(soldier.script_parameters) )
		{
			soldier runthread_start();
		}

		soldier waittill ("death");

		
		if ( !isDefined( soldier ) )
			continue;

		if ( !script_wait() )
			wait (randomFloatRange( 3, 5 ));
	}
}





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







reinforcement_pursue( delay )
{
	self endon( "death" );

	self LockAlertState("alert_red");
	wait( 1 );
	self UnLockAlertState();
	self.goalradius = 64;
	last_known_pos = level.player.origin;

	wait( delay );	
	
	while ( 1 )
	{
		while ( !self CanSee(level.player) )
		{
			self.goalradius = 64;
			self SetGoalPos( last_known_pos );
			wait(0.1);
		}

		
		while ( self CanSee(level.player) )
		{
			self.goalradius = 768;
			last_known_pos = level.player.origin;
			self SetGoalPos( last_known_pos );
			wait( 0.5 );
		}

		
		wait( RandomIntRange( 5, 15) );
	}


}





save_orientation()
{
	self.saved_origin = self.origin;
	self.saved_angles = self.angles;
}








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
		self StopAllCmds();	
		self thread goto_spot( self.target, 32 );
		self waittill( "goal" );
	}

	
	if ( !IsDefined(search_time) )
	{
		search_time = 0;
	}
	else
	{
		search_time = int(search_time);	
	}

	self.sniper_mode = "";	

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


	timer = 0;
	self thread sniper_aim();

	acquire_time	= 1.0;		
	lockon_time		= 2.0;		
	lock_loss_time	= 3.0;		
	timeout			= 0;		
	fire_timer		= 0;		
	first_time		= true;		
	while (1)
	{
		
		if ( self.sniper_mode != "scan" )
		{

			self.sniper_mode = "scan";

			self.fake_target_base_pos = self.fake_target.origin;
			self StopAllCmds();
			self CmdAimAtEntity( self.fake_target, interruptable, -1 );

			timer = gettime()+(search_time*1000);
			while( gettime() < timer )
			{
				
				if ( first_time && self GetAlertState() != "alert_green" )
				{
					break;
				}
				wait( 0.05 );
			}
			first_time = false;
		}

		
		if ( self CanSee( level.player ) )
		{
			if ( self.sniper_mode == "scan" )
			{
				wait( acquire_time );	


				self.sniper_mode = "target_sighted";

				search_time = 1.0;	

				self StopAllCmds();	
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
						timeout = gettime() + (3.0 * 1000);  
						fire_timer = 0;
					}
					if ( gettime() >= timeout )
					{
						lost_lock = true;
						self.sniper_mode = "scan";
					}
				}
				else	
				{
					if ( fire_timer == 0 )
					{
						fire_timer = gettime()+((lockon_time+RandomFloatRange(0.0,2.0))*1000);	
						timeout = 0;
					}
					if ( gettime()>fire_timer )
					{
						


						self StopAllCmds();	

						self CmdShootAtEntityXTimes( level.player, false, 1, 5000 );
						if ( Distance( level.player.origin, self.origin ) < 1500 )
						{
							self CmdAimAtEntity( level.player, interruptable, -1 );
						}
						else
						{
							self CmdAimAtEntity( self.fake_target, interruptable, -1 );
						}
						
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
					height = RandomFloatRange(70, 100);
				}
				else
				{
					height = RandomFloatRange(48, 96);
				}
				new_pos = self.fake_target_base_pos + ( RandomFloatRange(rand_min, rand_max), RandomFloatRange(rand_min, rand_max), height );
				time = RandomFloatRange( 2.0, 4.0 );
				self.fake_target MoveTo( new_pos, time, time/4.0, time/4.0 );
				timer = gettime() + ( (time+RandomFloatRange( 1.0, 2.0 ) )* 1000);	
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
			
			height = level.player getPlayerViewHeight() + 4.9;	
			




			
			self.fake_target.origin = level.player.origin + (0,0,height) + (AnglesToRight((0.0, level.player.angles[1], 0.0))*2.0);
		}

		wait( 0.05 );
	}
}





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




trig_tutorial_message( msg, waittime )
{
	self waittill( "trigger" );

	tutorial_block( msg, waittime );
}











wait_action( action, waitname, param )
{
	self endon( "death" );

	wait(0.1);

	if ( action == "trig_goalnode" )
	{
		
		trigger = GetEnt( waitname, "targetname" );
		if ( IsDefined(trigger) )
		{
			trigger waittill( "trigger" );

			
			wait( randomfloat(1.0) );

			

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
		
		trigger = GetEnt( waitname, "targetname" );
		if ( IsDefined(trigger) )
		{
			trigger waittill( "trigger" );

			
			wait( randomfloat(0.5) );

			if ( pause )
			{
				self resumepatrolroute();

			}
			self startpatrolroute( param );
		}
	}
	else if ( action == "notify_patrol" )
	{
		level waittill( waitname );

		
		wait( randomfloat(1.0) );

		self startpatrolroute( param );
	}
}





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
			
		}
	}
}






trigger_spawn_guys( groupname )
{
	self waittill("trigger");

	spawn_guys( self.target, false, groupname );
}










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

			
			if ( IsDefined( groupname ) && groupname != "" )
			{
				new_guy.groupname = groupname;
			}

			
			if ( assign_name )
			{
				new_guy.targetname = targetname + "_ai";
			}

			
			
			if ( ai_type == "civ" )
			{
				new_guy.goalradius = 12;

				

				new_guy animscripts\shared::placeWeaponOn( new_guy.primaryweapon, "none" );	

				new_guy lockalertstate( "alert_green" );
			}
			
			else if ( ai_type == "thug" )
			{
				new_guy.goalradius = 12;
				new_guy thread reinforcement_monitor();
				new_guy thread radio_chatter();
			}
			
			else if ( ai_type == "thug_yellow" )
			{
				new_guy.goalradius = 32;
				new_guy SetAlertStateMin("alert_yellow");
				new_guy thread reinforcement_monitor();
			}

			
			else if ( ai_type == "thug_red" )
			{
				new_guy.goalradius = 64;
				new_guy SetAlertStateMin("alert_red");

			}

			
			if ( IsDefined(new_guy.script_parameters) )
			{
				new_guy runthread_start();
			}

			guys[guys.size] = new_guy;
		}
	}

	
	if ( guys.size == 1 )
	{
		return guys[0];
	}
	else
	{
		return guys;
	}
}












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




time_limit_init( time_left )
{
	level endon("time_limit_stop");

	level.timer_hud = newHudElem();










	level thread time_limit_end();
	level thread time_limit_fail();
	level.clock_running = true;

	while ( time_left >= 0.0 )
	{
		level.timer_hud settext( time_left );
		level.timer_hud.time = time_left;
		wait(1.0);

		time_left = time_left - 1.0;
	}
	
	level.timer_hud settext( 0.0 );
	level.timer_hud.time = 0.0;

	level.clock_running = false;
	level notify("time_limit_reached");
}
time_limit_end()
{
	level waittill("time_limit_stop");

	level.clock_running = false;
	level.timer_hud destroy();

	

	SetDVar("r_pipSecondaryMode", 0);
}
time_limit_fail()
{
	level waittill("time_limit_reached");
	
	

	SetDVar("r_pipSecondaryMode", 0);

	
	level notify( "time_limit_expired" );
	level.timer_hud destroy();
}






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





tutorial_skip( msg, distance )
{
	level endon( "tutorial_end" );

	start_pos = level.player.origin;
	while ( Distance( level.player.origin, start_pos ) < distance )
	{
		wait( 0.1 );
	}

	
	tutorial_message( "" );
	level notify( "tutorial_end" );
}





split_screen()
{
	
  setdvar("ui_hud_showstanceicon", "0"); 
  setsaveddvar ( "ammocounterhide", "1" );
	
	
	level thread main_crop();
	level thread main_move();
	
	
	level thread second_move();
		
}


main_crop()
{
	
	setdvar("cg_pipmain_border", 2);
	setdvar("cg_pipmain_border_color", "0.2156 0.3294 0.4 1");
	
	
	SetDVar("r_pipMainMode", 1);	
	SetDVar("r_pip1Anchor", 4);		

	
	
	level.player animatepip( 500, 1, -1, -1, 1, 0.5, 0, 0);
	level.player waittill( "animatepip_done" );
	
		
	level notify( "main_crop" );
		
	level waittill( "main_up" );

	
	
	level.player animatepip( 500, 1, -1, -1, 1, 1, 0, 0);
	level.player waittill( "animatepip_done" );
	
	
	
	SetDVar("r_pip1Scale", "1 1 1 1");		
	SetDVar("r_pipMainMode", 0);	
	
	
	setdvar("ui_hud_showstanceicon", "1"); 
  setsaveddvar ( "ammocounterhide", "0" );
}


main_move()
{
	
	level waittill( "main_crop" );
		
	
	level.player animatepip( 500, 1, -1, 0.16 );
	level.player waittill( "animatepip_done" );
	
	
	level notify( "main_down" );
	
	level waittill( "pip_offscreen" );
	
	level.player animatepip( 500, 1, -1, 0 );
	level.player waittill( "animatepip_done" );
	
	
	level notify( "main_up" );
}



second_move()
{
	
	
	level.player setsecuritycameraparams( 45, 3/4 );

	
	
	
	
	
	
	SetDVar("r_pipSecondaryX", -0.2 );						
	SetDVar("r_pipSecondaryY", -0.13);						
	SetDVar("r_pipSecondaryAnchor", 4);						
	SetDVar("r_pipSecondaryScale", "1 0.55 1.0 0");		
	SetDVar("r_pipSecondaryAspect", false);					

	wait(0.05);	






	cameraID_ledge = level.player securityCustomCamera_Push( 
			"world",
			level.player,

			( 898, -376, 929),
			( 4, 0, 0),
			0.1);
	level.player SecurityCustomCamera_setFoV(
			cameraID_ledge,		
			40.0,				
			0.0,				
			0.0,				
			0.1					
		);

	
	setdvar("cg_pipsecondary_border", 2);
	setdvar("cg_pipsecondary_border_color", "0.2156 0.3294 0.4 1");
		
	
	
	
	
	
	
	level waittill( "main_down" );

	SetDVar("r_pipSecondaryMode", 5);		
	
	
	
	level.player animatepip( 500, 0, 0.25, -1 );
	level.player waittill( "animatepip_done" );
	
	
	

	
	trig = GetEnt( "trig_e2_off_ledge", "targetname" );
	trig waittill( "trigger" );
		
	
	
	level.player animatepip( 500, 0, 1, -1 );
	level.player waittill( "animatepip_done" );

	
		
	level notify( "pip_offscreen" );
	
	
	SetDVar("r_pipSecondaryMode", 0);	
	level.player securitycustomcamera_pop( cameraID_ledge );
					
}


second_anim()
{
	level endon("pip_off_screen");

	while (true)
	{
		level.player PlayerAnimScriptEvent("pb_security_lock");
		wait .05;
	}
	
}




slow_time(val, tim, out_tim)
{
	self endon("stop_timescale");

	
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
