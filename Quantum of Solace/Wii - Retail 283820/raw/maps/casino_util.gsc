#include animscripts\shared;
#include maps\_utility;
#include maps\_spawner;

#include maps\_anim;
#using_animtree("generic_human");











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
		iPrintLnBold( "WARNING!  Couldn't find a matching thread for a function called "+tokens[0] );
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

	return true;	
}




cmdaction_lookover( )
{
	wait( 0.5 );
	self cmdaction( "lookover" );
}





cmdaction_fidget( )
{
	wait( 0.5 );
	self cmdaction( "fidget" );
}




cover_lock()
{
	level.player endon( "damaged_on_ledge" );	

	in_cover = false;
	camera_id = undefined;	
	while( 1 )
	{
		self waittill( "trigger" );


		level.player notify( "on_ledge" );	
		wait(0.4);
		holster_weapons();

		push_vector = ( 0.0, 0.0, 0.0 );
		if ( IsDefined(self.script_int) )
		{
			push_vector = AnglesToForward( (0.0, self.script_int, 0.0) );
		}
		level.player thread cover_ledge_hurt( push_vector );

		













		while( level.player IsTouching(self) )
		{
			level.player playerSetForceCover( true );
			wait(0.1);
		}


		level.player notify( "off_ledge" );	
		level.player playerSetForceCover( false );

		unholster_weapons();









	}
}





cover_ledge_hurt( push_vector )
{
	self endon( "off_ledge" );

	self waittill( "damage" );

	self notify( "damaged_on_ledge" );
	wait(0.05);
	self playerSetForceCover( false );
	iPrintLnBold( "Bond Shot - get pushed off the ledge and DIE  0.4" );

	wait(0.5);

	level.player knockback( 9000, (level.player.origin+(push_vector*10)) );

	
	wait( 2.0 );
	level.player DoDamage( 10000, self.origin );
	if ( IsDefined(level.camera_id) )
	{
		level.player customCamera_pop( 
					level.camera_id,	
					1.0,	
					0.5,	
					0.5 );	
		level.camera_id = undefined;
	}
}





death_monitor()
{
	self waittill( "death", strAttacker, strType, strWeapon );

	if ( IsDefined(strAttacker) && strAttacker == level.player )
	{
		level.guy_killed = true;
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
				level.player PlaySound( "CAS_big_door_01" );	
			}
			else
			{
				self PlaySound( "CAS_big_door_02" );
				level.player PlaySound( "CAS_big_door_02" );	
			}
		}
	}
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
		else
		{
			break;	
		}
	}

	self notify( "follow_path_reached_end" );
}






driveway_vehicles( endon_msg )
{
	level endon( endon_msg );

	
	vmodels	= [];

	vmodels[0]		  = spawnstruct();
	vmodels[0].model = "v_sedan_silver_radiant";
	vmodels[0].vtype = "sedan";

	vmodels[1]		  = spawnstruct();
	vmodels[1].model = "v_sedan_blue_radiant";
	vmodels[1].vtype = "sedan";

	
	vnodes[0] = GetVehicleNode( "vn_driveway1", "targetname" );
	vnodes[1] = GetVehicleNode( "vn_driveway2", "targetname" );


	
	flag_init( "pause_driveway1" );	
	
	
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

		
		vehicle thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight02"], "tag_light_l_front" );
		vehicle thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight02"], "tag_light_r_front" );
		vehicle thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_l_back" );
		vehicle thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_r_back" );
		
		wait(0.5);		

		wait ( RandomFloatRange( 6.0, 12.0 ) );
	}
}





delete_at_end()
{
	self waittill( "reached_end_node" );

	self delete();
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









falling_mousetrap( object )
{
	trig = object.primaryEntity;
	mousetrap = undefined;
	if ( IsDefined(trig.target) )
	{
		mousetrap = GetEnt( trig.target, "targetname" );
	}
	
	if ( !IsDefined(mousetrap) )
	{
		mousetrap = trig;
	}


	
	mousetrap thread maps\casino_util::ballistic_move( (0,0,-1), 0, -2000 );

	
	
	
	

	dmg_radius = 32;	
	dmg_amount = 100;	
	dmg_zoffset = 0;	
	parameters = strtok( mousetrap.script_parameters, "," );




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



}





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

		wait( 0.05 );
	}
}






play_dialog( sound_alias )
{
	self endon( "death" );

	self playsound( sound_alias, "play_dialog_done", true );
	self waittill( "play_dialog_done" );
}

play_dialog_monitor( end_msg )
{
	
	self endon( "death" );
	
	
	self SetPropagationDelay(0.00);

	self waittill(end_msg);
	
	self SetPropagationDelay(0.75);
}




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





casino_light_flicker()
{
	while (1)
	{
		
		iterations = RandomIntRange(10,30);
		for ( i = 0; i<iterations; i++ )
		{
			self setlightintensity(0.1);
			wait( 0.05 );
			self setlightintensity(0.15);
			wait( 0.05 );
		}
		
		
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



	
		level notify( "reinforcement_spawn" );
		level.broke_stealth = true;		
	
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

		soldier waittill ("death");

		
		if ( !isDefined( soldier ) )
			continue;

		if ( !script_wait() )
			wait (randomFloatRange( 3, 5 ));
	}
}





reinforcement_awareness()
{
	self endon( "death" );

	self SetPerfectSense( true );
	wait( 1.0 );

	self SetPerfectSense( false );
}



SetPerfectSenseTimerThread(timer)
{
	self endon( "death" );

	self SetPerfectSense(true);

	wait(timer);
	
	self SetPerfectSense(false);
}



SetPerfectSenseTimer(timer)
{
	self thread SetPerfectSenseTimerThread(timer);
}






reinforcement_pursue( delay )
{
	self endon( "death" );

	self LockAlertState("alert_red");
	wait( 1 );
	
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

	
	wait(0.05);

	self.tetherpt = self.origin;
	self.tetherradius =  radius;
}




intro_speaker()
{
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





patrol( nodename )
{
	self startpatrolroute( nodename );
}





set_tether( nodename )
{
	if ( self IsOnPatrol() )
	{
		
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






trigger_spawn_guys( groupname )
{
	self waittill("trigger");

	spawn_guys( self.target, false, groupname );
}










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
				
				
				continue;
			}

			
			if ( IsDefined( groupname ) && groupname != "" )
			{
				new_guy.groupname = groupname;
			}

			new_guy thread DebugShowName(targetname);

			
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
				new_guy thread death_monitor();
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

			if (IsDefined(tether_pt))
			{
				new_guy.tetherpt = tether_pt;

				if (IsDefined(tether_radius))
				{
					new_guy SetTetherRadius(tether_radius);
				}
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




DebugShowName(targetname)
{

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






ballistic_target( target, speed_mph, opt_stop_height )
{
	vec = target.origin - self.origin;

	self ballistic_move( VectorNormalize( vec ), speed_mph, opt_stop_height);
}







ballistic_move( direction, speed_mph, opt_stop_height )
{
	self endon( "ballistic_move_stop" );

	if ( !IsDefined( opt_stop_height) )
	{
		opt_stop_height = -10000;
	}

	gravity = 386.0886; 

	interval	= 0.05;	

	
	
	speed = speed_mph * 63360 / 3600;

	
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

		
		velocity = ( velocity[0], velocity[1], velocity[2]-(gravity*interval*interval) );
	}
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
		}
	}
}




Ai_SetPerfectSenseUntillThreatIsPlayer(timeAfter)
{
	self endon("death");

	self SetPerfectSense(true);

	while( !self IsMainThreat(level.player) )
	{		
		wait(randomfloat(0.1,0.3));	
	}
	
	
	wait(timeAfter);
	
	self SetPerfectSense(false);
}



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