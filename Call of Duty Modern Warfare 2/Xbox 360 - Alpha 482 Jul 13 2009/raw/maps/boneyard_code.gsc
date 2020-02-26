#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#using_animtree( "generic_human" );

/**** ride stuff ****/
ride_uaz_mount()
{
	flag_wait( "wait_for_player" );

	trigger = spawn( "trigger_radius", self gettagorigin( "tag_passenger" ) + (0,0,-48), 0, 72, 72);
	trigger enablelinkto();
	trigger linkto( self );
	trigger waittill( "trigger" );

	flag_set( "uaz_mounted" );
	trigger delete();
}

uaz_control()
{
	level.player endon( "death" );

	level endon( "c130_takeoff_missed" );
	level endon( "uaz_park_crash" );

	flag_wait( "uaz_mounted" );

	level.player EnableInvulnerability();

	level.player allowProne( false );
	level.player allowCrouch( false );
	level.player allowStand( true );

	enablePlayerWeapons( false );
	level.player.rig = spawn_anim_model( "player_rig" );
	level.player.rig hide();

	level.player.rig linkto( self, "tag_body" );
	self thread anim_single_solo( level.player.rig, "boneyard_uaz_mount" , "tag_body" );
	self thread ride_uaz_door();

	level.player PlayerLinkToBlend( level.player.rig, "tag_player", 0.5 );
	wait 0.5;
	level.player.rig show();
	level.player PlayerLinkToDelta( level.player.rig, "tag_player", 0.75, 180, 180, 75, 25, true );

	level.player DisableInvulnerability();

	self waittill( "boneyard_uaz_mount" );

	self thread player_rig_adjust_height();

	level.player.rig hide();
	enablePlayerWeapons( true );
	level.player LerpViewAngleClamp( 0.5, 0.5, 0, 180, 180, 75, 35 );

	flag_wait( "uaz_player_control" );
	flag_set( "uaz_player_in_control" );

	level.player LerpViewAngleClamp( 0.5, 0.5, 0, 15, 15, 75, 5 );
	wait 0.5;
	enablePlayerWeapons( false );
	level.player.rig show();
	self anim_single_solo( level.player.rig, "grab_wheel" , "tag_body" );

	self thread uaz_steer();

	flag_wait( "uaz_park" );
	wait 0.25;

	self playsound( "scn_bone_uaz_hits_ramp" );
	Earthquake( .5, 2, level.player.origin, 1024 );

	self thread park_uaz();
}

player_rig_adjust_height()
{
	level endon( "uaz_player_control" );

	stand = false;

	while( true )
	{
		player_angle = level.player.angles[1];
		uaz_angle = self.angles[1];
		dif_angle = abs( int( uaz_angle - player_angle ) % 360 );

		if ( dif_angle > 130 && dif_angle < 300 )
		{
			if ( !stand )
			{
				self anim_single_solo( level.player.rig, "boneyard_uaz_stand" , "tag_body" );
				stand = true;
			}
		}
		else if ( stand )
		{
			self anim_single_solo( level.player.rig, "boneyard_uaz_sit" , "tag_body" );
			stand = false;
		}
		wait 0.05;
	}
}

uaz_steer()
{
	level endon( "uaz_park" );
	level endon( "uaz_park_crash" );
	self notify( "newpath" );

	level.player setstance( "stand" );
	level.player allowProne( false );
	level.player allowCrouch( false );
	level.player allowStand( true );
	enablePlayerWeapons( false );

	self thread uaz_steer_viewmodel();

	lookahead = 200;
	input_multiplier = 8; //5

	//calculate initial goal_offset
	angle1 = vectortoangles( level.c130.origin - self.origin )[1];
	angle2 = self.angles[1];
	angle = angle1 - angle2;
	goal_offset = tan( angle ) * lookahead;

	speed = 50; //35
	goal_speed = 95;
	time = 8.0; //9.5
	accel = ( goal_speed - speed ) / ( time * 20 );

	self VehPhys_EnableCrashing();

	while( true )
	{
		input = level.player GetNormalizedMovement()[1];
		straight = vectornormalize( level.c130.origin - self.origin );
		goal_offset += input * input_multiplier;
		right = anglestoright( vectortoangles( straight ) );
		goal = 	self.origin + straight * lookahead + right * goal_offset;

		self vehicleDriveTo( goal, speed );
		speed = clamp( speed + accel, 0, goal_speed );

		wait 0.05;
		println( "speed: " + self vehicle_getspeed() );
	}
}

uaz_steer_viewmodel()
{
	level endon( "uaz_park" );
	level endon( "uaz_park_crash" );

	steering = 0;

	while( true )
	{
		input = level.player GetNormalizedMovement()[1] * -1;
		input += ( self Vehicle_GetSteering() * 0.25 );
		input = clamp( input, -1, 1 );

		steering += input * 0.1; // ( 1.1 - abs( input ) );
		if ( abs( steering ) > abs( input ) )
			steering = input; 

		fraction = abs( steering );

		level.player.rig SetAnim( level.scr_anim[ "player_rig" ][ "steer_straight" ], 1-fraction, 0.1, 1 );

		level.uaz SetAnim( level.scr_anim[ "generic" ][ "steer_straight" ], 1 - (fraction/2), 0.1, 1 );
		level.uaz ClearAnim( level.scr_anim[ "generic" ][ "old_steering" ], 0 );

		if ( steering < 0 )
		{
			level.player.rig SetAnim( level.scr_anim[ "player_rig" ][ "steer_right" ], fraction, 0.1, 1 );
			level.player.rig SetAnim( level.scr_anim[ "player_rig" ][ "steer_left" ], 0, 0.1, 1 );

			level.uaz SetAnim( level.scr_anim[ "generic" ][ "steer_right" ], fraction/2, 0.1, 1 );
			level.uaz SetAnim( level.scr_anim[ "generic" ][ "steer_left" ], 0, 0.1, 1 );
		}
		else
		{
			level.player.rig SetAnim( level.scr_anim[ "player_rig" ][ "steer_right" ], 0, 0.1, 1 );
			level.player.rig SetAnim( level.scr_anim[ "player_rig" ][ "steer_left" ], fraction, 0.1, 1 );

			level.uaz SetAnim( level.scr_anim[ "generic" ][ "steer_right" ], 0, 0.1, 1 );
			level.uaz SetAnim( level.scr_anim[ "generic" ][ "steer_left" ], fraction/2, 0.1, 1 );
		}
		wait 0.05;
	}
}

ride_uaz_fake_price_fire()
{
	self endon( "death" );
	while( true )
	{
		axis = getaiarray( "axis" );
		if ( axis.size == 0 )
			break;

		axis = array_randomize( axis );
		burst = randomintrange( 5, 15 );
		target_origin = axis[0] geteye();
		for ( i = 0; i<burst; i++ )
		{
			if ( isalive( axis[0] ) )
				target_origin = axis[0] geteye();
			MagicBullet( self.weapon, level.price geteye() + (0,0,16), target_origin );
			wait 0.1;
		}
		wait RandomFloatRange( 1.5, 3 );
	}
}

#using_animtree( "vehicles" );
ride_uaz_door()
{
	anim_model = self maps\_vehicle_aianim::getanimatemodel();
//	anim_model setflaggedanimknob( "uaz_door_anim", level.scr_anim[ "generic" ][ "boneyard_UAZ_door" ], 1, .2, 1 );
	anim_model setflaggedanim( "uaz_door_anim", level.scr_anim[ "generic" ][ "boneyard_UAZ_door" ], 1, .2, 1 );
	anim_model waittillmatch( "uaz_door_anim", "end" );
	anim_model ClearAnim( level.scr_anim[ "generic" ][ "boneyard_UAZ_door" ], 0 );
	
/*
	flag_wait( "wait_for_player" );
	anim_model = self maps\_vehicle_aianim::getanimatemodel();
	anim_model maps\_vehicle_aianim::setanimrestart_once( %uaz_passenger_exit_into_stand_door, false );

	flag_wait( "uaz_mounted" );
	anim_model ClearAnim( %uaz_passenger_exit_into_stand_door, 0 );
	anim_model maps\_vehicle_aianim::setanimrestart_once( %uaz_passenger_enter_from_huntedrun_door, true );
*/
}

park_uaz()
{
	park_goal = getent( "uaz_park", "script_noteworthy" ); // use uaz_park for the final animation
	park_goal setmodel( "tag_origin" );

	tag_origin = park_goal spawn_tag_origin();
	tag_origin linkto( park_goal, "tag_origin", (0,0,0), (0,0,0) );

	forward = anglestoforward( park_goal.angles );
	goal = 	self.origin + forward * 500;
	self vehicleDriveTo( goal, 60 );

	// re add rook so that he stays attached to the truck
	self.riders = array_add( self.riders, level.rook );

	dummy = self maps\_vehicle::vehicle_to_dummy();
	dummy HidePart( "tag_glass_front_d" );
	dummy HidePart( "tag_mirror_left" );
	dummy HidePart( "tag_mirror_right" );

	self.dummy = dummy;

	level.player.rig linkto( dummy, "tag_body" );
	dummy linkto( tag_origin, "tag_origin", (0,0,0), (0,0,0) );
	dummy animscripted( "uaz_parked", tag_origin.origin, tag_origin.angles, level.scr_anim[ "generic" ][ "boneyard_jeep_evac" ] );

	level.player.rig SetAnimKnob( level.scr_anim[ "player_rig" ][ "boneyard_player_evac" ], 1, 0.2, 1 );
}

#using_animtree( "generic_human" );
ride_bump()
{
	self endon( "death" );

	array_thread( getvehiclenodearray( "jolt_node", "script_noteworthy" ), ::ride_bump_node );

	self.max_jolt 	= 0.1;
	max_speed		= 80;

	offset = [];
	offset[0] = ( 23, 33, 64 );
	offset[1] = ( -23, -33, 64 );

	while( true )
	{
		speed = min( self.veh_speed, max_speed );
		jolt_scale = self.max_jolt / max_speed;
		if ( speed > 0 && self.max_jolt > 0 )
		{
			jolt = speed * jolt_scale;
			self joltbody( self.origin + offset[ randomint(2) ], jolt );
		}

		max_random = ( ( max_speed - speed ) / 100 ) + 0.1; // range 0.1 to 0.9
		wait 0.2 + randomfloat( max_random );
	}
}

ride_bump_node()
{
	self waittill( "trigger", vehicle );
	vehicle.max_jolt = self.script_physicsjolt / 1000; // script_physicsjolt is a int so have to / 1000
}

vehicle_event_node_setup()
{
	vnode_arr = getvehiclenodearray( "vehicle_event", "script_noteworthy" );
	array_thread( vnode_arr, ::vehicle_event_node );

	vnode_arr = getvehiclenodearray( "vehicle_dialogue", "script_noteworthy" );
	array_thread( vnode_arr, ::vehicle_dialogue_node );
}

vehicle_dialogue_node()
{
	self waittill( "trigger" );

	// don't player this one line if the flag is set. Yes it's ugly, but so be it.
	if ( flag( "ride_minigun_gunner_dead" ) && self.script_soundalias == "byard_pri_thedrivers" )
		return;

	level.price dialogue_queue( self.script_soundalias );
}

vehicle_event_node()
{
	// doing the handling of vehicle nodes here since the global script isn't working right now.
	// besides it lets me do more stuff to.
	while( true )
	{
		self waittill( "trigger", vehicle );
		assert( isdefined( vehicle ) );

		vehicle notify( "event", self.script_parameters );

		if ( isdefined( self.script_vehicleaianim ) )
		{
			vehicle Maps\_vehicle::vehicle_ai_event( self.script_vehicleaianim );
			/#
				println( self.script_vehicleaianim );
			#/
		}
	}
}

vehicle_event_handler()
{
	self endon( "death" );
	vehicle = self;

	while( true )
	{
		self waittill( "event", event );

		if ( !isdefined( event ) )
			continue;

		switch( event )
		{
			case "enable_crashing":
				vehicle VehPhys_EnableCrashing();
				break;
			case "disable_crashing":
				vehicle VehPhys_DisableCrashing();
				break;
			case "allow_frontal":
				vehicle VehPhys_EnableCrashing();
				vehicle thread vehicle_track_frontal();
				break;
			case "end_induced_death":
				vehicle notify( "end_induced_death" );
				break;
			case "start_induced_death":
				vehicle thread vehicle_player_induced_death();
				break;
			case "frontal":
				vehicle notify( "dying" );
				vehicle.dontunloadonend = true;
				array_thread( vehicle.riders, ::vehicle_frontal_guy, vehicle );
				vector = rotate_vector( ( 0, 0, 50 ), vehicle.angles );
				vehicle VehPhys_launch( vector, false );
				wait randomfloatrange( 0, 0.2 );
				vehicle maps\_vehicle::godoff();
				vehicle maps\_vehicle::force_kill();
				break;
			case "crash":
				vehicle notify( "dying" );
				vehicle.dontunloadonend = true;

				if ( issubstr( vehicle.classname, "pickup" ) )
				{
					array_thread( vehicle.riders, ::vehicle_crash_guy, vehicle );
					vehicle thread vehicle_crash_launch_guys();
				}
				else
					vehicle Maps\_vehicle::vehicle_ai_event( "idle" );

				vehicle VehPhys_EnableCrashing();
				vector = rotate_vector( ( 64, -256, 0 ), vehicle.angles );
				vehicle VehPhys_launch( vector, false );

				vehicle waittill_still( 4, 200 );
				vehicle maps\_vehicle::godoff();
				vehicle maps\_vehicle::force_kill();
				break;
		}
	}
}

vehicle_crash_guy( vehicle )
{
	if ( self.vehicle_position == 0 )
		return;
	
	self.deathanim = undefined;
	self.noragdoll = undefined;
	vehicle.riders = array_remove( vehicle.riders, self );

	self.ragdoll_immediate = true;
	self kill();
}

vehicle_crash_launch_guys()
{
	wait 0.1;  // .1 longer wait then the one in vehicle_crash_guy
	expl_origin = self gettagorigin( "tag_guy1" );
	PhysicsExplosionCylinder( expl_origin, 300, 300, 2 );
}

vehicle_frontal_guy( vehicle )
{
	if ( self.vehicle_position == 0 )
		return;

	self.deathanim = undefined;
	self.noragdoll = undefined;
	vehicle.riders = array_remove( vehicle.riders, self );
	vehicle waittill( "death" );

	wait 0.05;
	self unlink();
	if ( isalive( self ) )
		self kill( level.player.origin, level.player ); 
}

vehicle_player_induced_death()
{
	self endon( "death" );
	self endon( "dying" );
	self endon( "end_induced_death" );

	// we don't wan't them to crash.
	damage_limit_arr = [];
	damage_limit_arr[0] = 2500;
	damage_limit_arr[1] = 2500;
	damage_limit_arr[2] = 3000;
	damage_limit_arr[3] = 3500;

	difficulty = level.gameskill;

	damage_limit = damage_limit_arr[ difficulty ];
	total_damage = 0;

	while( total_damage < damage_limit )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
		if ( attacker != level.player )
			continue;
		if ( type == "MOD_PROJECTILE" ) // always crash from direct hit rpgs.
			break;
		total_damage += damage;
	}

	self thread vehicle_crash_turn();
}

vehicle_track_frontal()
{
	self endon( "death" );
	self endon( "dying" );

	crash_limit = 5000;
	while( true )
	{
		self waittill( "veh_jolt", vector );
		force = abs( vector[0] ) + abs( vector[1] ) + abs( vector[2] );
		if ( force > crash_limit )
			self notify( "event", "frontal" );
	}
}

vehicle_crash_turn( left_turn, wait_time )
{
	// right turn
	offset = ( 64, -256, 16 );
	vector = ( 64, 256, 0 );

	if ( isdefined( left_turn ) )
	{
		// left turn default
		offset = ( 64, 256, 16 );
		vector = ( 64, -256, 0 );
	}

	offset = rotate_vector( offset, self.angles );
	goal_origin = self.origin + offset;

	self notify( "newpath" );
	self notify( "dying" );

	self.dontunloadonend = true;

	if ( issubstr( self.classname, "pickup" ) )
	{
		array_thread( self.riders, ::vehicle_crash_guy, self );
		self thread vehicle_crash_launch_guys();
	}
	else
		self Maps\_vehicle::vehicle_ai_event( "idle" );

	self VehPhys_EnableCrashing();
	self vehicleDriveTo( goal_origin, self.veh_speed );

	while( abs( self Vehicle_GetSteering() ) < 1 )
		wait 0.05;

	vector = rotate_vector( vector, self.angles );
	self VehPhys_launch( vector, false );

	if ( !isdefined( wait_time ) )
		wait_time = 4;

	self waittill_still( wait_time, 200 );
	self maps\_vehicle::godoff();
	self maps\_vehicle::force_kill();
}

waittill_still( timeout, still_point )
{
	mytimeOutEnt( timeout ) endon ( "timeout" );

	if ( !isdefined( still_point ) )
		still_point = 50;

	velocity = self Vehicle_GetVelocity();
	velocity = abs( velocity[0] ) + abs( velocity[1] ) + abs( velocity[2] );

	while( velocity > still_point )
	{
		velocity = self Vehicle_GetVelocity();
		velocity = abs( velocity[0] ) + abs( velocity[1] ) + abs( velocity[2] );
		wait 0.05;
	}
}

launch_object_setup()
{
	array_thread( getentarray( "launch_object", "targetname" ), ::launch_object );
}

launch_object()
{
	obj_array = getentarray( self.target, "targetname" );
	self waittill( "trigger", vehicle );

	force_multiplier_arr = [];
	force_multiplier_arr[ "com_parkingcone01" ] = 2;
	force_multiplier_arr[ "bc_military_tire04" ] = 25;
	force_multiplier_arr[ "bc_military_tire05" ] = 25;
	force_multiplier_arr[ "com_junktire" ] = 25;
	force_multiplier_arr[ "road_barrier_post" ] = 4; // old 22

	foreach( obj in obj_array )
	{
		velocity = vehicle vehicle_getvelocity();
		angles1 = vectortoangles( ( obj.origin + (0,0,6) ) - vehicle.origin );
		angles2 = vectortoangles( velocity );

		// add a slight random angle so that the stacks don't look bad.
		if ( obj_array.size > 2 )
		{
			random_angels = (0, randomint( 30 ) -15, 0 );
			angles1 += random_angels;
		}

		rotation = ( angles1 - angles2 );
		velocity = rotate_vector( velocity, rotation );

		force_multiplier = 2;
		if ( isdefined( force_multiplier_arr[ obj.model ] ) )
			force_multiplier = force_multiplier_arr[ obj.model ];

		// lets me overide if needed.
		if ( isdefined( obj.script_accel ) )
			force_multiplier = force_multiplier * obj.script_accel;

		//play sound from hit
		if ( isdefined( obj.script_soundalias ) )
			level thread play_sound_in_space( obj.script_soundalias, obj.origin );

		velocity *= force_multiplier;

		direction = vectornormalize( velocity * -1 );
		contact_point = obj.origin + direction * 16;
		obj PhysicsLaunchClient( contact_point, velocity );


		dir = vectornormalize( velocity );
		// line( contact_point, contact_point + 100 * dir, (1,0,0), 1, 0, 100 );
	}
}

mytimeOutEnt( timeOut )
{
	ent = spawnstruct();
	ent delaythread( timeOut, ::send_notify, "timeout" );
	return ent;
}

collapse_wing()
{
	flag_wait( "wing_fall" );
	exploder( "wing_fall" );

	wing = getent( "wing", "targetname" );
	pivot_1 = getent( "pivot_1", "targetname" );
	pivot_2 = getent( "pivot_2", "targetname" );

	pivot_1.angles = vectortoangles( pivot_2.origin - pivot_1.origin );
	pivot_2.angles = vectortoangles( pivot_1.origin - pivot_2.origin );

	wing linkto( pivot_1 );
	pivot_2 linkto( pivot_1 );

	ground_1 = PhysicsTrace( pivot_2.origin + (0,0,-64), pivot_2.origin + (0,0,-256) );
	ground_2 = PhysicsTrace( pivot_1.origin + (0,0,-65), pivot_1.origin + (0,0,-256) );

	angles = vectortoangles( ground_1 - pivot_1.origin );
	pivot_1 rotateto( angles, .4, .3, 0 );
	pivot_1 waittill( "rotatedone" );
	angles = vectortoangles( (ground_1 + (0,0,40) ) - pivot_1.origin );
	pivot_1 rotateto( angles, .25, 0, .25 );
	pivot_1 waittill( "rotatedone" );
	angles = vectortoangles( ground_1 - pivot_1.origin );
	pivot_1 rotateto( angles, .25, .25, 0 );
	pivot_1 waittill( "rotatedone" );
	angles = vectortoangles( (ground_1 + (0,0,10) ) - pivot_1.origin );
	pivot_1 rotateto( angles, .1, 0, .1 );
	pivot_1 waittill( "rotatedone" );
	angles = vectortoangles( ground_1 - pivot_1.origin );
	pivot_1 rotateto( angles, .1, .1, 0 );
	pivot_1 waittill( "rotatedone" );

	wing unlink();
	pivot_2 unlink();
	wing linkto( pivot_2 );

	angles = vectortoangles( ground_2 - pivot_2.origin );
	pivot_2 rotateto( angles, .3, .2, 0 );
	pivot_2 waittill( "rotatedone" );
	angles = vectortoangles( (ground_2 + (0,0,20) ) - pivot_2.origin );
	pivot_2 rotateto( angles, .2, 0, .2 );
	pivot_2 waittill( "rotatedone" );
	angles = vectortoangles( ground_2 - pivot_2.origin );
	pivot_2 rotateto( angles, .2, .2, 0 );
	pivot_2 waittill( "rotatedone" );
	angles = vectortoangles( (ground_2 + (0,0,5) ) - pivot_2.origin );
	pivot_2 rotateto( angles, .1, 0, .1 );
	pivot_2 waittill( "rotatedone" );
	angles = vectortoangles( ground_2 - pivot_2.origin );
	pivot_2 rotateto( angles, .1, .1, 0 );
	pivot_2 waittill( "rotatedone" );
}

/**** C130 STUFF ****/
assemble_c130()
{
	c130 = getent( "c130_flight", "targetname" );
	lower_hatch = getent( "lower_hatch", "targetname" );
	upper_hatch = getent( "upper_hatch", "targetname" );
	hinge_arr = getentarray( "hinge", "targetname" );

	lower_hatch_origin = getent( "lower_hatch_origin", "targetname" );
	upper_hatch_origin = getent( "upper_hatch_origin", "targetname" );
	hinge_origin_arr = getentarray( "hinge_origin", "targetname" );

	array_call( getentarray( c130.target, "targetname" ), ::linkto, c130 );
	array_call( getentarray( lower_hatch.target, "targetname" ), ::linkto, lower_hatch );
	array_call( getentarray( upper_hatch.target, "targetname" ), ::linkto, upper_hatch );
	array_call( getentarray( hinge_arr[0].target, "targetname" ), ::linkto, hinge_arr[0] );
	array_call( getentarray( hinge_arr[1].target, "targetname" ), ::linkto, hinge_arr[1] );

	array_thread( getentarray( "c130_spark_origin", "script_noteworthy" ), ::c130_sparks );

	hinge_arr[0].angles = ( 175, 90, 0 );
	hinge_arr[1].angles = ( 170, 90, 0 );

	lower_hatch thread c130_rotate_hatch( hinge_arr[0], hinge_origin_arr[0].origin, 0.25, 1.85, 9.6 );
	lower_hatch thread c130_rotate_hatch( hinge_arr[1], hinge_origin_arr[1].origin, 0.3, 1.5, 9 );

	c130 thread c130_rotate_hatch( lower_hatch, lower_hatch_origin.origin, 0.015, 5.9, 3 );
	c130 thread c130_rotate_hatch( upper_hatch, upper_hatch_origin.origin, 0.01, 4.9);

	c130.ramp_trigger = getent( "ramp_trigger", "targetname" );
	c130.ramp_trigger enablelinkto();
	c130.ramp_trigger LinkTo( c130 );

	array_thread( getentarray( "ramp_death_trigger", "targetname" ), ::ramp_death_trigger, c130 );

	array_thread( getentarray( "c130_propeller", "script_noteworthy" ), ::c130_propeller );

	return c130;
}

ramp_death_trigger( c130 )
{
	level endon( "uaz_park" );

	self enablelinkto();
	self LinkTo( c130 );

	flag_wait( "uaz_player_in_control" );

	while( true )
	{
		self waittill( "trigger", vehicle );
		if ( vehicle == level.uaz )
			break;
	}

	level notify( "uaz_park_crash" );

	level.uaz vehicle_crash_turn( self.script_parameters, 1.5 );

	level.player kill();
//	missionfailedwrapper();
}

ride_uaz_player_launch()
{
	throw = ( -300,600,500 );
	enablePlayerWeapons( false );
	level.player.rig unlink();
	level.player.rig RotateVelocity( ( 300, 300, 300 ), 10 );
	level.player.rig MoveGravity( throw, 1);
}

c130_rotate_hatch( hatch, hinge_origin, rate, stop_time, delay )
{
	hinge = spawn( "script_model", hinge_origin );
	hinge.angles = ( 0, 0, 0 );
	hinge setmodel( "tag_origin" );
	hinge linkto( self );
	hatch.origin = hinge_origin;
	hatch linkto( hinge );

	flag_wait( "c130_hatch_open" );
	wait 5;

	if ( isdefined( delay ) )
		wait delay;

	hinge.animname = "c130_propeller";
	hinge assign_animtree();

	hinge_anim = level.scr_anim[ "c130_propeller" ][ "rotate" ][0];

	hinge AnimScripted( "rotate_hatch", hinge.origin, hinge.angles, hinge_anim );
	hinge SetFlaggedAnim( "rotate_hatch", hinge_anim, 1, 0, rate );
	wait stop_time;
	hinge SetFlaggedAnim( "rotate_hatch", hinge_anim, 1, 0, 0 );
}

c130_propeller()
{
	wait randomfloat( 2 );
	self.animname = "c130_propeller";
	self assign_animtree();
	self anim_loop_solo( self, "rotate" );
}

c130_sparks()
{
	flag_wait( "c130_hatch_open" );
	wait 5;
	wait 12;

	ent = self spawn_tag_origin();
	ent.origin += ( 0, -32, 0 );
	ent.angles = ( -90, 0, 0 );
	ent linkto( self );
	//ent thread maps\_debug::drawtagforever( "tag_origin" );

	while( true )
	{
		//forward = anglestoforward( self.angles + ( 0, randomintrange( 160, 200 ), 0 ) );
		//up 		= anglestoup( self.angles );
		PlayFXOnTag( getfx( "scrape_sparks" ) , ent, "tag_origin");
		wait randomfloatrange( 0.1, 0.3 );
	}
}

/**** FLYBY STUFF ****/
flyby_rumble()
{
	level.player PlayRumbleOnEntity( "c130_flyby" );
	level thread screenshake( .2, 5, 1, 4 );

	wait 1.5;
	level.player thread blend_movespeedscale( 0.1, 1.5 );

	loops = int( 0.75 * 20 );
	up_target_angle = -8;
	for ( i = 0; i < loops; i++ )
	{
		player_angles = level.player getplayerangles();
		up_angle = player_angles[0];

		angle_step = ( up_target_angle - up_angle ) / ( loops - (i) ); 
		angle_step = cap_value( angle_step, -1.5, 1.5 );

		level.player setplayerangles( player_angles + ( angle_step, 0, 0 ) );
		wait 0.05;
	}

	level.player thread blend_movespeedscale( 1, 1 );
}

RUMBLE_FRAMES_PER_SEC = 10;
screenshake( scale, duration, fade_in, fade_out)
{
	if ( !isdefined( fade_in ) )
		fade_in = 0;
	if ( !isdefined( fade_out ) )
		fade_out = 0;

	assert( ( fade_in + fade_out ) <= duration );

	frame_count = duration * RUMBLE_FRAMES_PER_SEC;
	fade_in_frame_count = fade_in * RUMBLE_FRAMES_PER_SEC;
	if ( fade_in_frame_count > 0 )
		fade_in_scale_step = scale / fade_in_frame_count;
	else
		fade_in_scale_step = scale;

	fade_out_frame_count = fade_out * RUMBLE_FRAMES_PER_SEC;
	fade_out_start_frame = frame_count - fade_out_frame_count;
	if ( fade_out_frame_count > 0 )
		fade_out_scale_step = scale / fade_out_frame_count;
	else
		fade_out_scale_step = scale;

	delay = 1/RUMBLE_FRAMES_PER_SEC;
	scale = 0;
	for ( i = 0; i < frame_count; i++ )
	{
		if ( i <= fade_in_frame_count )
			scale += fade_in_scale_step;

		if ( i > fade_out_start_frame )
			scale -= fade_out_scale_step;

		earthquake( scale, delay, level.player.origin, 500 );
		wait delay;
	}
}

angel_flare_burst( flare_count )
{
	// Angel Flare Swirl
	PlayFXOnTag( getfx( "angel_flare_swirl" ), self, "tag_flash_flares" );

	self PlaySound( "ac130_flare_burst" );

	// Angel Flare Trails
	for( i=0; i<flare_count; i++ )
	{
		self thread angel_flare();
		wait randomfloatrange( 0.1, 0.25 );
	}
}

angel_flare()
{
	if ( !isdefined( level.anim_index ) )
		level.anim_index = 0;

	rig = spawn_anim_model( "angel_flare_rig" );

	rig.origin = self gettagorigin( "tag_flash_flares" );
	rig.angles = self gettagangles( "tag_flash_flares" );

	fx_id = level._effect[ "angel_flare_geotrail" ];


	anim_count = level.scr_anim[ "angel_flare_rig" ][ "ac130_angel_flares" ].size;
	animation = level.scr_anim[ "angel_flare_rig" ][ "ac130_angel_flares" ][ level.anim_index % anim_count ];
	level.anim_index++;


//	animation = random( level.scr_anim[ "angel_flare_rig" ][ "ac130_angel_flares" ] );

	rig SetFlaggedAnim( "flare_anim", animation, 1, 0, 1 );

	wait 0.1;
	PlayFXOnTag( fx_id, rig, "flare_left_top" );
	PlayFXOnTag( fx_id, rig, "flare_right_top" );
	wait 0.05;
	PlayFXOnTag( fx_id, rig, "flare_left_bot" );
	PlayFXOnTag( fx_id, rig, "flare_right_bot" );

	rig waittillmatch( "flare_anim", "end" );

	StopFXOnTag( fx_id, rig, "flare_left_top" );
	StopFXOnTag( fx_id, rig, "flare_right_top" );
	StopFXOnTag( fx_id, rig, "flare_left_bot" );
	StopFXOnTag( fx_id, rig, "flare_right_bot" );
}

/***** THREE WAY FIGHTING STUFF *****/

threewayfight_setup()
{
	add_global_spawn_function( "axis" , ::threewayfight_threads );
	add_global_spawn_function( "team3" , ::threewayfight_threads );
	level.delete_nodes = getnodearray( "delete_node", "targetname" );

	// doesn't count ai waiting to be deleted. Won't affect ai riding vehicles or ai with valid script_noteworthy
	level.ai_cap[ "axis" ] = 15;
	level.ai_cap[ "team3" ] = 15;
	level.ai_cap[ "axis_alive" ] = 0;
	level.ai_cap[ "team3_alive" ] = 0;

	level thread switch_colors();
}

threewayfight_threads()
{
	// don't do this on vehicles or other non sentient ents
	if ( !issentient( self ) )
		return;

	state = "default";
	if ( isdefined( self.script_noteworthy ) )
		state = self.script_noteworthy;

	difficulty = level.gameskill;
	if ( difficulty == 0 )
		difficulty = 1;

//	might work to work around the self.ridingvehicle issue.
	waittillframeend;

	switch( state )
	{
		case "scripted_guy":
			break;
		case "enemy_dog":
			self thread enemy_dog();
			break;
		case "struggle_guy":
			self thread struggle_guy();
			break;
		case "rpg_guy":
			self thread rpg_guy();
			break;
		case "spray_guy":
			self thread spray_guy();
			break;
		case "minigun_guy": // NO BREAK PAST THIS POINT!!!
			self.health *= difficulty;
			self setthreatbiasgroup( "aware_of_player" );
		default:
			// delete generic guys that would push the count above the limit
			// there is probably a better way to do this.
			if ( level.ai_cap[ self.team ] < level.ai_cap[ self.team + "_alive" ] && !isdefined( self.ridingvehicle ) )
			{
				/#
					println( "^2didn't spawn " + self.team + " guy because of ai_cap." );
				#/
				self waittill( "finished spawning" );
				self delete();
			}
			else
			{
				self thread ai_cap_count();
				self threewayfight_threads_defaults();
			}
	}
}

threewayfight_threads_defaults()
{
	self bad_aim(); // returns
	self thread react_to_player();
	self thread player_enemy();
	self thread delay_awareness();

	if ( self.team == "team3" && randomint( 4 ) == 0 )
		self enable_heat_behavior( true );
}

ai_cap_count()
{
	ai_team = self.team;
	level.ai_cap[ ai_team + "_alive" ]++;
	self waittill_any( "death", "tobedeleted", "long_death" );
	level.ai_cap[ ai_team + "_alive" ]--;

	assertEx( level.ai_cap[ ai_team + "_alive" ] >= 0, "How did this get to be less then 0?" );
}

enemy_dog()
{
	//???
}

delay_awareness()
{
	self endon( "death" );
	self endon( "tobedeleted" );

	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "delay_awareness" )
	{
		if ( isdefined( self.ridingvehicle ) )
		{
			self setthreatbiasgroup( "ignore_player" );
			self waittill( "jumpedout" );
			wait 2;
			self setthreatbiasgroup( self.team );
		}
		else
		{
			self setthreatbiasgroup( "ignore_player" );
			self waittill_any_timeout( 3, "damage", "goal" );
			self setthreatbiasgroup( self.team );
		}
	}
}

react_to_player()
{
	// if the player shoots at an AI the threatbias for that AI will be switched
	// to one that doesn't make the player less of a threat.

	self endon( "death" );
	self endon( "tobedeleted" );

	while( true )
	{
		self waittill_stack_add( "bulletwhizby" );
		self waittill_stack_add( "damage" );

		self waittill( "waittill_stack", msg );

		if (
			 ( msg == "bulletwhizby" && self.waittill_stack.a == level.player )
				 ||
			 ( msg == "damage" && self.waittill_stack.b == level.player )
			)
			break;
	}

	self waittill_stack_clear(); // removes variables used by waittill_stack.
	self setthreatbiasgroup( "aware_of_player" );
}

player_enemy()
{
//	default values are 30000 and 3.
	level.advanceToEnemyInterval = 120000; // less often.
//	level.advanceToEnemyGroupMax = 1;

	default_MaxDist = self.engagemaxdist;
	default_FalloffDist = self.engagemaxfalloffdist;

	// Change engagement dist when fighting the player.
	self endon( "death" );
	self endon( "tobedeleted" );

	while( true )
	{
		self waittill( "enemy" );

		if ( Isplayer( self.enemy ) )
		{
			// reset dists
			self SetEngagementMaxDist( default_MaxDist, default_FalloffDist );
		}
		else
		{
			// lets the ai fight from further away. This stops them from moving around when they are not fighting the player.
			self SetEngagementMaxDist( default_MaxDist * 2, default_FalloffDist * 2 );
		}
	}
}

bad_aim()
{
	// makes the ai less likely to kill each other, but still attack the player with full Accuracy.

	self endon( "death" );
	self.attackerAccuracy = 0.1;
}

struggle_guy()
{
	// Is supposed to spawn close to an enemy struggle guy and then do a melee sequence.
	// will eventually forced what melee animations to use.

	self endon( "death" );
	old_sightdist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 96*96;
	self.dontEverShoot = true;
	wait 1;
	self.maxsightdistsqrd = old_sightdist;
	self.dontEverShoot = undefined;
	self threewayfight_threads_defaults();
}

turret_track_target( turret, heli )
{
	heli thread fake_target();

	mg_guy = turret getturretowner();
	assert( isdefined( mg_guy ) );
	mg_guy endon( "death" );
	heli endon( "death" );
	self endon( "death" );

	while( true )
	{
		etarget = random( heli.fake_target );
		turret animscripts\hummer_turret\common::set_manual_target( etarget, 3, 5 );
		mg_guy.ignoreall = true;
		turret animscripts\hummer_turret\common::set_manual_target( etarget, 1, 3 );
		mg_guy.ignoreall = false;
	}
}

fake_target()
{
	self.fake_target = [];

	right = anglestoright( self.angles );

	offset = right * 320;
	self.fake_target[0] = spawn( "script_origin", self.origin + offset );
	self.fake_target[0] linkto( self );
	offset = right * -320;
	self.fake_target[1] = spawn( "script_origin", self.origin + offset );
	self.fake_target[1] linkto( self );

	self waittill( "death" );
	self.fake_target[0] delete();
	self.fake_target[1] delete();
}

littlebird_reaction( path_name )
{
	self endon( "death" );
	self endon( "reaction_end" );

	paths = getentarray( path_name, "script_noteworthy" );
	total_damage = 0;

	index = 0;

	while( true )
	{
		flag_wait( "littlebird_react" );

		self waittill_stack_add( "damage" );
		self waittill_stack_add( "reached_dynamic_path_end" );
		self waittill_stack_add( "react" );

		self waittill( "waittill_stack" , msg );

		if ( msg == "damage" )
		{
			amount = self.waittill_stack.a;
			damager = self.waittill_stack.b;
	
			if ( !flag( "littlebird_react" ) ) // || damager != level.player ) - let heli react to  any damage
				continue;
	
			total_damage +=  amount;
			if ( total_damage < 400 )
				continue;
		}

		total_damage = 0;

		current_path = paths[ index ];
		index++;
		if ( index > paths.size )
		{
			paths = array_randomize( paths );
			index = 0;
		}

		/#
		// debug shit
		level thread mark_heli_path( current_path );
		#/

		self SetMaxPitchRoll( 25, 25 );
//		self maps\_vehicle::set_heli_move( "faster" );
		self Vehicle_SetSpeed( 65, 25, 25 );

		self thread maps\_vehicle::vehicle_paths( current_path );

		self waittill_either( "goal", "near_goal" );
		wait 2;
//		self maps\_vehicle::set_heli_move( "fast" );
//		self SetMaxPitchRoll( 25, 25 );
		self thread littlebird_notarget_timeout();
	}
}

littlebird_notarget_timeout()
{
	self endon( "reaction_end" );
	self endon( "react" );
	self endon( "death" );

	wait 3;

	timeout = 5000;
	start_time = gettime();

	while ( true )

	{
		wait 0.05;
		if ( isdefined( self.mgturret[0] getturrettarget(0) ) || isdefined( self.mgturret[1] getturrettarget(0) ) )
		{
			start_time = gettime();
			continue;
		}
		if ( start_time + timeout < gettime() )
			break;
	}

	self notify( "react" );
}

road_rocket_guys_clear()
{
	self endon( "death" );
	self waittill( "rpg_guy_done" );
	self.ignoreme = false;
	self.health = 25;
	self thread move_and_delete();
}

rpg_guy()
{
	// rpg guy will show up and fire one rgp at a random target and then become a normal guy.
	// target node needs to target atleast one script_origin, or the ai have a self.rocket_target

	assertEX( issubstr( ToLower( self.classname ), "rpg" ), "Actor with export: " + self.export + " doesn't have an RPG!" );

	self endon( "death" );

	self disable_ai_color();
	self set_ignoreme( true );
	self.combatmode = "no_cover";

	goal = getnode( self.target, "targetname" );
	if ( isdefined( goal ) )
	{
		self setgoalnode( goal );
	}
	else
	{
		goal = getent( self.target, "targetname" );
		self setgoalpos( goal.origin );
	}

	if ( isdefined( goal.radius ) )
		self.goalradius = goal.radius;
	else
		self.goalradius = 32;

	timeout = 10;

	if ( !isdefined( goal.script_shotcount ) || goal.script_shotcount == 0 )
		goal.script_shotcount = 1;

	self.a.rockets = goal.script_shotcount;

	for ( i=0; i<goal.script_shotcount; i++ )
	{
		if ( isdefined( goal.target ) )
		{
			target_arr = getentarray( goal.target, "targetname" );
			etarget = random( target_arr );
		}
		else if ( isdefined( self.rocket_target ) )
		{
			etarget = self.rocket_target;
			timeout = 30;
		}
		else
		{
			assertMsg( "rpg guy didn't get a target" );
			return;
		}

		if ( isdefined( etarget.script_parameters ) && etarget.script_parameters == "straight" )
			self SetStableMissile( true );

		if ( issentient( etarget ) )
		{
			ent = spawn( "script_origin", etarget.origin );
			ent linkto( etarget );
			self SetEntityTarget( ent, 1 );
		}
		else
			self SetEntityTarget( etarget, 1 );

		self waittill_notify_or_timeout( "missile_fire", timeout );
		etarget notify( "rpg_fired" );
	}

	wait 2;

	self ClearEntityTarget();
	self enable_ai_color();
	self set_ignoreme( false );
	self.combatmode = "cover";

	self threewayfight_threads_defaults();
	self notify( "rpg_guy_done" );
}

spray_guy()
{
	// spray guy will show up and fire for a few seconds and then become a normal guy.
	// target node needs to target atleast two script_origins.
	// set script_wait on the spawner to control how long he will spray.

	self endon( "death" );
	self disable_ai_color();

	node = getnode( self.target, "targetname" );
	if ( isdefined( node.radius ) )
		self.goalradius = node.radius;
	else
		self.goalradius = 32;
	self setgoalnode( node );

	self.no_pistol_switch  				= true;
	self.ignoresuppression 				= true;
//	self.maxFaceEnemyDist  				= 0;
	self.noRunReload 					= true;
//	self.ammoCheatInterval 				= 2000;
	self.disableBulletWhizbyReaction 	= true;
	self.combatmode						= "no_cover";
	self SetThreatBiasGroup( "lowthreat" );

	target_arr = getentarray( node.target, "targetname" );
	assert( isdefined( target_arr ) && target_arr.size > 1 );
	target_arr = array_randomize( target_arr );

	self SetEntityTarget( target_arr[0], 1 );
	if ( isdefined( self.script_wait ) )
		move_time = self.script_wait;
	else
		move_time = randomfloatrange( 1, 2.5 );
	self waittill( "goal" );

	assert( move_time >= 1 );
	target_arr[0] MoveTo( target_arr[1].origin, move_time, move_time/2, move_time/4 );
	wait move_time;

	self ClearEntityTarget();
	self enable_ai_color();

	self.no_pistol_switch 				= undefined;
	self.ignoresuppression 				= false;
//	self.maxFaceEnemyDist 				= 512;
	self.noRunReload 					= undefined;
	self.disableBulletWhizbyReaction 	= undefined;
	self.combatmode						= "cover";
	self SetThreatBiasGroup( self.team );

	self threewayfight_threads_defaults();
}

smoke()
{
	target_arr = getentarray( self.target, "targetname" );
	target_ent = random( target_arr );

	vec = target_ent.origin - self.origin + ( 0,0,200 );
	MagicGrenademanual( "smoke_grenade_american", self.origin + (0,0,80), vec, 1.5 );
}

delete_excess_setup()
{
	array_thread( getentarray( "delete_excess", "targetname" ), ::delete_excess_trigger );
	level thread delete_excess();
}

delete_excess_trigger()
{
	self waittill( "trigger" );
	level.delete_excess_safe_volume = undefined;

	if ( isdefined( self.target ) )
		level.delete_excess_safe_volume = getent( self.target, "targetname" );

	flag_set( "delete_excess" );
	waittillframeend;	// lets everyone that waits for the flag continue their thread.
	flag_clear( "delete_excess" );
}

delete_excess_exeption( guy )
{
	if ( isdefined( guy.ridingvehicle ) )
		return true;

	return false;
}

delete_excess()
{
	// Delete enemies that are far away because new ones will be spawned in.

	while( true )
	{
		flag_wait( "delete_excess" );

		safe_volume = level.delete_excess_safe_volume;
		ai_arr = getaiarray( "axis", "team3" );
		dist = 1600*1600;

		foreach ( guy in ai_arr )
		{
			if ( delete_excess_exeption( guy ) )
				continue;
			if ( isdefined( safe_volume ) && guy istouching( safe_volume ) )
				continue;
			else if ( !isdefined( safe_volume ) && DistanceSquared( guy.origin, level.player.origin ) < dist )
				continue;

			guy thread move_and_delete( true );
		}

		flag_waitopen( "delete_excess" );
	}
}

higround_littlebird_hunt_btr80( node_name )
{
	self endon( "stop_hunt" );
	self endon( "death" );
	level.btr80 endon( "death" );

	self SetLookAtEnt( level.btr80 );

	goal_arr = getentarray( node_name, "targetname" );
	old_goal = undefined;

	while( true )
	{
		btr80_vect = VectorNormalize( level.btr80.origin - level.player.origin);
		goal = undefined;
		hi_dot = -1;

		foreach ( ent in goal_arr )
		{
			goal_vect = VectorNormalize( ent.origin - level.player.origin);
			dot = VectorDot( btr80_vect, goal_vect );
			if ( dot > hi_dot )
			{
				hi_dot = dot;
				goal = ent;
			}
		}

		assert( isdefined( goal ) );

		if ( !isdefined(old_goal) || goal != old_goal )
		{
			self Vehicle_SetSpeed( 50, 20, 20 );
//			self maps\_vehicle::set_heli_move( "faster" );
			self SetMaxPitchRoll( 25, 25 );

			old_goal = goal;
			flag_clear( "littlebird_at_goal" );
			self thread maps\_vehicle::vehicle_paths( goal );
			self thread littlebird_at_goal();
//			self maps\_vehicle::set_heli_move( "fast" );
//			self SetMaxPitchRoll( 25, 25 );
		}
		wait 0.1;
	}
}

littlebird_at_goal()
{
	level endon( "littlebird_at_goal" );

	while( self.veh_speed > 15 )
	{
		self waittill_either( "goal", "near_goal" );
	}

	flag_set( "littlebird_at_goal" );
}

higround_littlebird_aligned()
{
	self endon( "death" );

	while( true )
	{
		flag_wait( "littlebird_at_goal" );
		btr80_origin = level.btr80.origin + ( 0, 0, 128 );
		heli_origin = self.origin + ( 0, 0, -56 );
		if ( player_looking_at( heli_origin, 0.85, undefined, self ) && player_looking_at( btr80_origin, 0.70, true, level.btr80 ) )
			break;
		wait .5;

		if ( flag( "no_align" ) )
			break;
	}
}

higround_littlebird_failed_attack()
{
	self endon( "death" );

	center_ent = getent( "btr80_miss_target", "targetname" );
	temp_miss_target_arr = getentarray( center_ent.target, "targetname" );
	temp_miss_target_arr = array_index_by_script_index( temp_miss_target_arr );

	miss_target_arr = [];
	for ( i=0; i<temp_miss_target_arr.size; i++ )
	{
		ent = spawn( "script_origin", temp_miss_target_arr[i].origin );
		miss_target_arr[i] = ent;
	}

	rotation = VectorToAngles( self.origin - level.btr80.origin );
	goal_offset = level.btr80.origin - center_ent.origin;

	foreach ( ent in miss_target_arr )
	{
		ent rotate_with_offset( rotation, center_ent.origin, goal_offset );
	}

	self fire_missile( miss_target_arr, 3 );

	// delete target ents
	delayThread( 2, ::array_call, miss_target_arr, ::delete );
}

/*******************************/
/*******************************/
/*** Vehicle ai anim threads ***/
/*******************************/
/*******************************/

uaz_unload_groups()
{
	unload_groups = [];
	unload_groups[ "driver" ] = [];
	unload_groups[ "all" ] = [];

	group = "driver";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;

	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;

	unload_groups[ "default" ] = unload_groups[ "all" ];

	return unload_groups;
}

// Copied from Jeepride, get rid of the once I don't need, when I know which that is
vehicle_aianimthread_setup()
{
	level.vehicle_aianimthread[ "hide_attack_forward" ] =		::guy_hide_attack_forward;
	level.vehicle_aianimcheck[ "hide_attack_forward" ] =		::guy_hide_attack_forward_check;

	level.vehicle_aianimthread[ "hidetoback_attack" ] = 		::guy_hidetoback_startingback;
	level.vehicle_aianimcheck[ "hidetoback_attack" ] = 			::guy_hidetoback_check;

	level.vehicle_aianimthread[ "back_attack" ] = 			 	::guy_back_attack;
	level.vehicle_aianimcheck[ "back_attack" ] = 				::guy_hidetoback_check;

	level.vehicle_aianimthread[ "hide_attack_left" ] = 			::guy_hide_attack_left;
	level.vehicle_aianimcheck[ "hide_attack_left" ] = 			::guy_hide_attack_left_check;

	level.vehicle_aianimthread[ "hide_attack_left_standing" ] = ::guy_hide_attack_left_standing;
	level.vehicle_aianimcheck[ "hide_attack_left_standing" ] = 	::guy_hidetoback_check;

	level.vehicle_aianimthread[ "hide_attack_back" ] = 			::guy_hide_attack_back;
	level.vehicle_aianimcheck[ "hide_attack_back" ] = 			::guy_hide_attack_back_check;

	level.vehicle_aianimthread[ "hide_starting_back" ] = 		::guy_hide_starting_back;
	level.vehicle_aianimcheck[ "hide_starting_back" ] = 		::guy_hidetoback_check;

	level.vehicle_aianimthread[ "hide_starting_left" ] = 		::guy_hide_startingleft;
	level.vehicle_aianimcheck[ "hide_starting_left" ] = 		::guy_backtohide_check;

	level.vehicle_aianimthread[ "backtohide" ] = 				::guy_backtohide;
	level.vehicle_aianimcheck[ "backtohide" ] = 				::guy_backtohide_check;

	level.vehicle_aianimthread[ "react" ] = 					::guy_react;
	level.vehicle_aianimcheck[ "react" ] = 						::guy_react_check;

	level.vehicle_aianimthread[ "free_attack" ] =				::guy_free_attack;
	level.vehicle_aianimcheck[ "free_attack" ] =				::guy_free_attack_check;

	// suburban
	level.vehicle_aianimthread[ "hide_attack_right" ] = 		::guy_hide_attack_right;
	level.vehicle_aianimcheck[ "hide_attack_right" ] = 			::guy_hide_attack_right_check;


}

guy_free_attack( guy, pos )
{
	// free guy to attack.
	guy endon( "newanim" );
	guy endon( "death" );
	guy notify( "animontag_thread" );
	guy StopAnimScripted();

	guy.noragdoll = true;

	self thread guy_free_attack_cleanup( guy );
	guy.deathanim = %covercrouch_death_3;

	old_stance = "";

	fov = level.cosine[ "20" ]; // only do standing when player is clearly infront of the pickup.
	while( true )
	{
		if ( within_fov( self.origin, self.angles, level.player.origin, fov ) )
			stance = "stand";
		else
			stance = "crouch";

		if ( stance != old_stance )
		{
			old_stance = stance;
			guy allowedstances( stance );

			/#
				guy thread debug_stance( stance );
			#/
		}

		wait 1;
	}
}

guy_free_attack_cleanup( guy )
{
	guy endon( "death" );
	guy waittill( "animontag_thread" );
	guy allowedstances( "stand", "crouch", "prone" );
}

guy_free_attack_check( guy, pos )
{
	return ( self.vehicletype == "truck_physics" && pos >= 1 );
}

guy_hidetoback_check( guy, pos )
{
	return isdefined( 	maps\_vehicle_aianim::anim_pos( self, pos ).hidetoback );
}

guy_hidetoback_startingback( guy, pos )
{
	animpos = maps\_vehicle_aianim::anim_pos( self, pos );

	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	assert( isdefined( animpos.hidetoback ) );
	maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.hidetoback );
	thread guy_back_attack( guy, pos );
}


guy_back_attack( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = maps\_vehicle_aianim::anim_pos( self, pos );
	assert( isdefined( animpos.back_attack ) );
	while ( 1 )
		maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.back_attack );
}

guy_backtohide_check( guy, pos )
{
	return isdefined( 	maps\_vehicle_aianim::anim_pos( self, pos ).backtohide );
}


guy_hide_starting_back( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = maps\_vehicle_aianim::anim_pos( self, pos );

	assert( isdefined( animpos.backtohide ) );

	maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.backtohide );
	thread guy_hide_attack_back( guy, pos );
}

guy_hide_startingleft( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = maps\_vehicle_aianim::anim_pos( self, pos );
	if ( !isdefined( animpos.backtohide ) )
		return maps\_vehicle_aianim::guy_idle( guy, pos );

	maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.backtohide );
	thread guy_hide_attack_left( guy, pos );

}

guy_backtohide( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = maps\_vehicle_aianim::anim_pos( self, pos );
	assert( isdefined( animpos.backtohide ) );
	maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.backtohide );
	thread maps\_vehicle_aianim::guy_idle( guy, pos );
}


guy_react( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = maps\_vehicle_aianim::anim_pos( self, pos );
	assert( isdefined( animpos.react ) );
	maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.react );
	thread maps\_vehicle_aianim::guy_idle( guy, pos );
}

guy_react_check( guy, pos )
{
	return isdefined( maps\_vehicle_aianim::anim_pos( self, pos ).react );
}


guy_hide_attack_back_check( guy, pos )
{
	return isdefined( maps\_vehicle_aianim::anim_pos( self, pos ).hide_attack_back );
}

guy_hide_attack_back( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = maps\_vehicle_aianim::anim_pos( self, pos );
	assert( isdefined( animpos.hide_attack_back ) );

	while ( 1 )
	{
		if ( isdefined( animpos.hide_attack_back_occurrence ) )
		{
			theanim = maps\_vehicle_aianim::randomoccurrance( guy, animpos.hide_attack_back_occurrence );
			maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.hide_attack_back[ theanim ] );
		}
		else
			maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.hide_attack_back );
	}
}

guy_hide_attack_forward_check( guy, pos )
{
	return isdefined( maps\_vehicle_aianim::anim_pos( self, pos ).hide_attack_forward );
}

guy_hide_attack_forward( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = maps\_vehicle_aianim::anim_pos( self, pos );

	assert( isdefined( animpos.hide_attack_forward ) );

	while ( 1 )
		maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.hide_attack_forward );
}

guy_hide_attack_left_check( guy, pos )
{
	return isdefined( maps\_vehicle_aianim::anim_pos( self, pos ).hide_attack_left );
}

guy_hide_attack_left( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = maps\_vehicle_aianim::anim_pos( self, pos );

	assert( isdefined( animpos.hide_attack_left ) );

	while ( 1 )
	{
		if ( isdefined( animpos.hide_attack_left_occurrence ) )
		{
			theanim = maps\_vehicle_aianim::randomoccurrance( guy, animpos.hide_attack_left_occurrence );
			maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.hide_attack_left[ theanim ] );
		}
		else
			maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.hide_attack_left );
	}
}

guy_hide_attack_left_standing( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = maps\_vehicle_aianim::anim_pos( self, pos );

	assert( isdefined( animpos.hide_attack_left_standing ) );
	while ( 1 )
	{
		if ( isdefined( animpos.hide_attack_left_standing_occurrence ) )
		{
			theanim = maps\_vehicle_aianim::randomoccurrance( guy, animpos.hide_attack_left_standing_occurrence );
			maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.hide_attack_left_standing[ theanim ] );
		}
		else
			maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.hide_attack_left_standing );
	}
}

guy_hide_attack_right_check( guy, pos )
{
	return isdefined( maps\_vehicle_aianim::anim_pos( self, pos ).hide_attack_left );
}

guy_hide_attack_right( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = maps\_vehicle_aianim::anim_pos( self, pos );

	assert( isdefined( animpos.hide_attack_right ) );

	while ( 1 )
	{
		maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.hide_attack_left );
	}
}

killer_bird_setup()
{
	array_thread( getentarray( "player_stray_trigger" ,"targetname" ), ::killer_bird );
}

killer_bird()
{
	level.player endon( "death" );

	ent_arr = getentarray( self.target, "targetname" );

	timer = 0;
	while ( true )
	{
		self waittill( "trigger" );
		if ( timer > 8 )
			break;
		timer++;
		wait 1;
	}

	start_ent = ent_arr[0];
	end_ent = ent_arr[1];

	fov = level.cosine[ "60" ];
	if ( within_fov( level.player.origin, level.player.angles, start_ent.origin, fov ) )
	{
		start_ent = ent_arr[1];
		end_ent = ent_arr[0];
	}

	heli_spawner = getent( "killer_bird", "targetname" );

	heli_spawner.origin = start_ent.origin;
	heli_spawner.angles = start_ent.angles;

	killer_bird = heli_spawner spawn_vehicle();

	killer_bird SetVehGoalPos( end_ent.origin, true );
	killer_bird Vehicle_SetSpeedImmediate( 100, 40, 30 );
	killer_bird SetNearGoalNotifyDist( 4000 );

	killer_bird thread killer_bird_goal( end_ent.origin );

	killer_bird waittill_either( "goal", "near_goal" );
	killer_bird SetLookAtEnt( level.player );

	killer_bird waittill( "goal" );

	fov = level.cosine[ "20" ];
	while ( !within_fov( killer_bird.origin, killer_bird.angles, level.player.origin, fov ) )
		wait 0.05;

	killer_bird notify( "killing_player" );

	target_arr = [];
	target_arr[0] = level.player;
	killer_bird thread fire_missile( target_arr, 5 );

	wait 2;
	level.player kill();
}

killer_bird_goal( goal_origin )
{
	self endon( "killing_player" );

	dist = distance2d( level.player.origin, goal_origin );
	height = goal_origin[2];

	while( true )
	{
		vector = AnglesToForward( level.player.angles );
		new_origin = level.player.origin + (dist * vector) + ( 0, 0, height );
		vector = VectorNormalize( new_origin - level.player.origin );

		if ( SightTracePassed( level.player geteye(), new_origin, false, self ) )
			self SetVehGoalPos( new_origin, true );

		wait 2;
	}
}

/***** MISC STUFF *****/
/***** MISC STUFF *****/
/***** MISC STUFF *****/
/***** MISC STUFF *****/
/***** MISC STUFF *****/
/***** MISC STUFF *****/
/***** MISC STUFF *****/
/***** MISC STUFF *****/
/***** MISC STUFF *****/
/***** MISC STUFF *****/
/***** MISC STUFF *****/
/***** MISC STUFF *****/

ramp_sunsample_over_time( samplesize, time )
{
	current_samplesize = getdvarfloat( "sm_sunSampleSizeNear" );
	range = current_samplesize - samplesize; // min sample size is 0.25

	frames = time * 20;
	for ( i = 0; i <= frames; i++ )
	{
		dif = i / frames;
		dif = 1 - dif;
		current_range = dif * range;
		current_sample_size = samplesize + current_range;
		setsaveddvar( "sm_sunSampleSizeNear", current_sample_size );
		wait( 0.05 );
	}	
}

makesentient( team )
{
	self MakeEntitySentient( team );
	self waittill( "death" );

	if ( isdefined( self ) )
		self FreeEntitySentient();
}

waittill_damage( damage_types, attacker_ent, endon_death, timeout )
{
	if ( isdefined( timeout ) )
		mytimeOutEnt( timeout ) endon ( "timeout" );

	if ( isstring( damage_types ) )
	{
		tmp = [];
		tmp[ tolower( damage_types ) ] = true;
		damage_types = tmp;
	}

	if ( isdefined( endon_death ) && endon_death )
		self endon( "death" );

	state = false;
	while ( !state )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );

		if ( isdefined( damage_types ) )
			state = isdefined( damage_types[ tolower( type ) ] );
		if ( state && isdefined( attacker_ent ) )
			state = ( attacker_ent == attacker );
	}
}


fade_out_level( fadeOutTime )
{
	setSavedDvar( "compass", 0 );
	setSavedDvar( "hud_showStance", 0 );
	
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	
	overlay.alpha = 0;
	overlay fadeOverTime( fadeOutTime );
	overlay.alpha = 1;
	
	wait fadeOutTime;

	level.player freezeControls( true );
	enablePlayerWeapons( false );
}

sp_objective_onentity( id, entity )
{
	level endon( "release_objective" );
	while ( true )
	{
		objective_position( id, entity.origin );
		wait 0.05;
	}
}

set_flag_on_notify( flag_str, msg_str )
{
	self waittill( msg_str );
	flag_set( flag_str );
}

rotate_with_offset( rotation, center_origin, goal_offset )
{
	test_origin = TransformMove( level.btr80.origin, level.btr80.angles, center_origin, (0,0,0), self.origin, (0,0,0) );

	offset = self.origin - center_origin;
	right = anglestoright( rotation ) * -1;
	forward = anglestoforward( rotation );
	up = anglestoup( rotation );
	new_offset = forward * offset[ 0 ] + right * offset[ 1 ] + up * offset[ 2 ];
	self.origin = center_origin + new_offset + goal_offset;
}

rotate_vector( vector, rotation )
{
	right = anglestoright( rotation ) * -1;
	forward = anglestoforward( rotation );
	up = anglestoup( rotation );
	new_vector = forward * vector[ 0 ] + right * vector[ 1 ] + up * vector[ 2 ];
	return new_vector;
}

flag_set_on_notify( flag_str, msg )
{
	level endon( flag_str );
	self waittill( msg );
	flag_set( flag_str );
}

main_turret_init()
{
	self ent_flag_init( "hold_fire" );
	self ent_flag_init( "have_target" );
	self ent_flag_init( "allow_stop" );
	self ent_flag_set( "allow_stop" );
	self.main_turret_enemies = [];
	self.fire_on_ai = false;
}

main_turret_think( target_ai )
{
	self endon( "death" );

	old_target_ent = undefined;

	while( true )
	{
		enemies = self.main_turret_enemies;
		enemies = array_combine( enemies, self get_ai_enemies() );

		target_ent = undefined;
		foreach( ent in enemies )
		{
			if ( issentient( ent ) && !isalive( ent ) )
				continue;

			if ( isdefined( ent.ridingvehicle ) )
				continue;
			if ( self Vehicle_CanTurretTargetPoint( ent.origin + (0,0,20), 1, ent ) )
			{
				if ( isplayer( ent ) || ( IsAI( ent ) && !self.fire_on_ai ) )
				{
					ent_flag_set( "hold_fire" );
					self maps\_vehicle::mgon();
				}
				else
				{
					ent_flag_clear( "hold_fire" );
					self maps\_vehicle::mgoff();
				}
				target_ent = ent;
				break;
			}
		}

		if ( !isdefined( target_ent ) ) // never mind the old target stuff ->> || ( isdefined( old_target_ent ) && target_ent == old_target_ent ) )
		{
			wait 0.5;
			continue;
		}

		old_target_ent = target_ent;

		/#
			println( "btr80 aquired a new target" );
		#/

		self ent_flag_set( "have_target" );
		self main_turret_attack( target_ent, (0,0,20), false, 5 );
		self ent_flag_clear( "have_target" );
	}
}

main_turret_attack( target_ent, offset, no_vis, timeout )
{
	self endon( "death" );

	self notify( "clear_turret_target" );
	self endon( "clear_turret_target" );

	if ( isalive( target_ent ) )
		self thread main_turret_attack_target_death( target_ent );

	if ( !isdefined( target_ent.fake_target ) )
		self SetTurretTargetEnt( target_ent, offset );
	else
		self SetTurretTargetEnt( target_ent.fake_target, offset );

	self waittill( "turret_on_target" );

	if ( isdefined( timeout ) )
		mytimeOutEnt( timeout ) endon ( "timeout" );

	if ( !isdefined( no_vis ) )
		self thread main_turret_target_lost( target_ent, offset );

	starttime = gettime();
	while( true )
	{
		self ent_flag_waitopen( "hold_fire" ); // lets me pause firing while still aiming at the target.
		self FireWeapon();
		wait 0.2;
	}
}

main_turret_attack_target_death( target_ent )
{
	self endon( "clear_turret_target" );

	if ( isdefined( target_ent.fake_target ) )
		target_ent.fake_target add_wait( ::waittill_msg, "death" );
	target_ent add_wait( ::waittill_either, "death", "pain_death" );
	do_wait_any();

	wait randomfloat( 1 );

	// remove the target if it's in the special enemy list unless it's alive.
	if ( is_in_array( self.main_turret_enemies, target_ent ) && !isalive( target_ent ) )
		self.main_turret_enemies = array_remove( self.main_turret_enemies, target_ent );
	self notify( "clear_turret_target" );

}

main_turret_target_lost( target_ent, offset )
{
	self endon( "death" );
	self endon( "clear_turret_target" );

	timelimit = randomfloatrange( 1000, 2000 );
	start_time = undefined;

	while( true )
	{
		msg = self waittill_any_return( "turret_no_vis", "turret_on_vistarget" );
		if ( msg == "turret_no_vis" )
		{
			if ( self Vehicle_CanTurretTargetPoint( target_ent.origin + offset, 1, target_ent ) )
				continue;
			if( !isdefined( start_time ) )
				start_time = gettime();
			if ( start_time + timelimit < gettime() )
				break;
		}
		else
			start_time = undefined;
	}

	self main_turret_aim_straight();
	self notify( "clear_turret_target" );
}

main_turret_aim_straight()
{
	self endon( "death" );
	self ent_flag_set( "hold_fire" );

	ent = spawn( "script_origin", (0,0,0) );
	ent linkto( self, "tag_origin", (500,0,100), (0,0,0) );
	self setTurretTargetEnt( ent );

	self waittill_either( "turret_on_target", "death" );
	if ( isalive( self ) )
		self ClearTurretTarget();
	ent delete();
	self ent_flag_clear( "hold_fire" );
}

slowdown_on_target( speedmin, speedmax )
{
	self endon( "death" );

	while( true )
	{
		self ent_flag_wait( "have_target" );
		self ent_flag_wait( "allow_stop" );

		speed = randomintrange( speedmin, speedmax );	


		self vehicle_setspeed( speed, 10 );

		self ent_flag_waitopen_either( "have_target", "allow_stop" );
		self resumespeed( 10 );
	}
}

get_ai_enemies()
{
	enemies = [];
	team = "";
	if ( isdefined( self.team ) )
		team = self.team;
	else if ( isdefined( self.script_team ) )
		team = self.script_team;
	else
		assertmsg( "get_ai_enemies used on entity with no team" );

	switch( team )
	{
		case "axis":
			enemies = sortbydistance( getaiarray( "allies", "team3" ), self.origin );
		case "team3":
			enemies = sortbydistance( getaiarray( "allies", "axis" ), self.origin );
			break;
		case "allies":
			enemies = sortbydistance( getaiarray( "team3", "axis" ), self.origin );
			break;
	}

	if ( team != "allies" )
	{
		if ( enemies.size > 0 )
			enemies = array_insert( enemies, level.player, 0 );
		else
			enemies[0] = level.player;
	}

	return enemies;	
}

vehicle_set_health( health )
{
	self.health = health + self.healthbuffer;
	self.currenthealth = self.health;
}

flyby_magic_rocket( delete_time )
{
	flag_wait( "flyby_rockets" );
	while( !flag( "flyby_c130" ) )
	{
		wait 2;
		self magic_rocket( delete_time );
		wait randomfloatrange( 3, 4 );
	}
}

magic_rocket( delete_time )
{
	wait self.script_delay;
	target = getent( self.target, "targetname" );
	rocket = MagicBullet( "rpg_distant", self.origin, target.origin );

	if ( isdefined( delete_time ) )
	{
		wait delete_time;
		if( isdefined( rocket ) )
			rocket delete();
	}
}

set_flag_on_player_damage( flag_str )
{
	level endon( flag_str );
	self endon( "death" );

	while( true )
	{
		self waittill( "damage", amount, damager );
		assert( isdefined(damager) );
		if ( isplayer( damager ) )
			break;
	}

	flag_set( flag_str );
}

random_delayed_kill( min_delay, max_delay )
{
	enemy_team = [];
	enemy_team[ "team3" ] = "axis";
	enemy_team[ "axis" ] = "team3";

	self endon( "death" );
	wait randomfloatrange( min_delay, max_delay );

	enemies = getaiarray( enemy_team[ self.team ] );
	enemies = SortByDistance( enemies, self.origin );
	guy = enemies[0];

	if ( isdefined( guy ) )
		self Kill( guy geteye(), guy );
	else
		self Kill( self geteye() );
}

move_and_delete( add_delay )
{
	self endon( "death" );
	self notify( "tobedeleted" );

	self disable_ai_color();

	// just kill them after a random time isntead of crazy move stuff.
	random_delayed_kill( 3, 7 );

/*
	if ( isdefined( add_delay ) )
		wait randomfloat( 2 );

	goal_node = undefined;
	timer = 0;

	while ( player_looking_at( self.origin, 0.70, true ) )
	{
		if ( isdefined( self.enemy ) && self.enemy == level.player )
		{
			self.radius = 1024;
			wait 1;
			continue;
		}

		if ( timer > 0 )
		{
			timer--;
			wait 1;
			continue;
		}

		// will wait 10 seconds at each goal before trying to go to the next one.
		timer = 10;

		if ( isdefined( goal_node ) )
			goal_node.aionnode--;

		node_arr = SortByDistance( level.delete_nodes, self.origin );
		goal_node = node_arr[0];

		for ( i = 1; i<node_arr.size; i++ )
		{
			if ( self origin_is_behind( node_arr[i].origin ) )
			{
				if ( !isdefined( node_arr[i].aionnode ) || node_arr[i].aionnode < 2 )
				{
					goal_node = node_arr[i];
					break;
				}
			}
		}
		assert( isdefined( goal_node ) );

		if ( !isdefined( goal_node.aionnode ) )
			goal_node.aionnode = 0;

		goal_node.aionnode++;

		self setgoalnode( goal_node );
		self.goalradius = 128;
		self waittill( "goal" );
	}

	if ( isdefined( goal_node ) )
		goal_node.aionnode--;

	self delete();
*/
}

origin_is_behind( node_origin )
{
	forward = anglestoforward( (0,0,0) ); // we are heading north in this level.
	vector = VectorNormalize( node_origin - self.origin );
	dot = VectorDot( forward, vector );
	return ( dot < -0.2 );
}

switch_colors()
{
	while( true )
	{
		flag_wait( "switch_color" );

		guys = getaiarray( "axis", "team3" );
		foreach ( guy in guys )
		{
			// if not a base color switch to one that is.
			color = guy.script_forcecolor;
			colorCodes = strtok( level.base_colors[ guy.team ], " " );
			if ( isdefined( color ) && !is_in_array( colorCodes, color ) || isdefined( guy.old_forcecolor ) )
			{
				guy set_force_color( colorCodes[0] );
			}
		}
		flag_clear( "switch_color" );
	}
}

waittill_stack_add( msg, ent )
{
	/*
		Used to wait on multiple messages and/or entities and get the message and triggering ent and variables passed through the notify

		msg: message to wait for.
		ent: optional ent to waittill on instead of self.

		level waittill_stack_add( "damage", ai1 ); // waits for damage on ai1
		level waittill_stack_add( "damage", ai2 ); // waits for damage on ai2
		level waittill( "waittill_stack", msg, ent ); // returns messge and ai1 or ai2 on damage to either
		damager = level.waittill_stack.b;	// gets the second variable passes by the notify.
		level waittill_stack_clear(); // cleans up any variables.
	*/

	if ( !isdefined( self.waittill_stack ) )
		self.waittill_stack = spawnstruct();

	self thread waittill_stack_thread( msg, ent);
}

waittill_stack_clear()
{
	self notify( "waittill_stack" );
	self.waittill_stack = undefined;
}

waittill_stack_thread( msg, ent )
{
	self endon( "waittill_stack" );
	self endon( "death" );

	if ( !isdefined( ent ) )
		ent = self;

	ent waittill( msg, a, b, c, d, e, f );

	if ( isdefined( a ) )
		self.waittill_stack.a = a;
	if ( isdefined( b ) )
		self.waittill_stack.b = b;
	if ( isdefined( c ) )
		self.waittill_stack.c = c;
	if ( isdefined( d ) )
		self.waittill_stack.d = d;
	if ( isdefined( e ) )
		self.waittill_stack.e = e;
	if ( isdefined( f ) )
		self.waittill_stack.f = f;

	self notify( "waittill_stack", msg, ent );
}

fire_missile_setup()
{
	run_thread_on_noteworthy( "fire_missile", maps\_attack_heli::boneyard_style_heli_missile_attack );
}

fire_missile( target_arr, number )
{
	tags = [];
	tags[0] = "tag_missile_right";
	tags[1] = "tag_missile_left";

	self SetVehWeapon( "littlebird_FFAR" );

	for ( i=0; i<number; i++ )
	{
		assertex( isdefined( target_arr[ i % target_arr.size ] ), "fire_missile requires indexes to start at 0 and not have any gaps." );

		target_ent = target_arr[ i % target_arr.size ];
		self SetTurretTargetEnt( target_ent );
		missile = self FireWeapon( tags[ i % tags.size ], target_ent );
		missile delaycall( 1, ::Missile_ClearTarget );

		if ( isdefined( target_ent.script_delay ) )
			wait target_ent.script_delay;
		else
			wait randomfloatrange( 0.2, 0.3 );
	}
}

move_spawn_and_go( path_ent )
{
	self.origin = path_ent.origin;
	if ( isdefined( path_ent.angles ) )
		self.angles = path_ent.angles;

	// changes targetname of ai so that they to can spawn
	other_ents = getentarray( self.target, "targetname" );
	foreach( ent in other_ents )
	{
		if ( isspawner( ent ) )
			ent.targetname = path_ent.targetname;
	}

	self.target = path_ent.targetname;

	vehicle = self thread maps\_vehicle::spawn_vehicle_and_gopath();

	/#
	// debug shit
	if ( vehicle maps\_vehicle::ishelicopter() )
		level thread mark_heli_path( path_ent );
	#/

	return vehicle;
}

new_vehicle_path( path_start )
{
	if ( !self maps\_vehicle::ishelicopter() )
		self StartPath( path_start );
	self thread maps\_vehicle::vehicle_paths( path_start );
}

turret_fire_control( mg_guy )
{
	mg_guy endon( "death" );

	while( true )
	{
		mg_guy.ignoreall = !flag( "minigun_fire" );

		if ( flag( "minigun_fire" ) )
			flag_waitopen( "minigun_fire" );
		else
			flag_wait( "minigun_fire" );
	}
}

start_at( start_point )
{
	if ( self == level.player )
	{
		self setOrigin( start_point.origin );
		self setPlayerAngles( start_point.angles );
	}
	else
	{
		self.origin = start_point.origin;
		self.angles = start_point.angles;
	}
}

delete_not_touching_setup()
{
	array_thread( getentarray( "delete_not_touching", "targetname" ), ::delete_not_touching );
}

delete_not_touching()
{
	self waittill( "trigger" );
	while ( level.player istouching( self ) )
		wait 0.5;
	self trigger_off();
}


/* temp */

drawpath()
{
	self endon( "death" );

/#
	if ( getdvar( "debug_heli" ) == "" )
		return;
#/

	while( true )
	{
		if ( self Vehicle_GetSpeed() < 5 )
		{
			wait 0.1;
			continue;
		}
		old_origin = self.origin;
		wait 0.1;
			
		Line( old_origin, self.origin, ( 1, 1, 1), 1, false, 500 );

		vector = AnglesToForward( self.angles );
		origin1 = self.origin + ( vector * 100 );
		vector = AnglesToRight( self.angles );
		origin2 = self.origin - ( vector * 30 );
		origin3 = self.origin + ( vector * 30 );

		draw_tri( origin1, origin2, origin3 );
	}
}



mark_heli_path( ent )
{
/#
	if ( getdvar( "debug_heli" ) == "" )
		return;

	old_ent = ent;
	while( true )
	{
		draw_cross( ent.origin );
		if ( !isdefined( ent.target ) )
			break;
		ent = getent( ent.target, "targetname" );
		Line( ent.origin, old_ent.origin, ( 0.7,0,0 ), 1, false, 500 );
		old_ent = ent;
	}
#/
}

draw_tri( origin1, origin2, origin3 )
{
	Line( origin1, origin2, ( 0,0,0 ), 1, false, 500 );
	Line( origin2, origin3, ( 0,0,0 ), 1, false, 500 );
	Line( origin3, origin1, ( 0,0,0 ), 1, false, 500 );
}

draw_cross( origin, col )
{
	if ( !isdefined( col ) )
	{
		Line( origin + ( 10,0,0 ), origin + ( -10,0,0 ), ( .5, .5, .5 ), 1, false, 500 );
		Line( origin + ( 0,10,10 ), origin + ( 0,-10,0 ), ( .5, .5, .5 ), 1, false, 500 );
		Line( origin, origin + ( 0,0,100 ), ( 1, 1, 1 ), 1, false, 50 );
	}
	else
	{
		Line( origin + ( 10,0,0 ), origin + ( -10,0,0 ), col, 1, false, 500 );
		Line( origin + ( 0,10,10 ), origin + ( 0,-10,0 ), col, 1, false, 500 );
		Line( origin, origin + ( 0,0,100 ), col, 1, false, 500 );
	}
}

cc( text )
{
	if ( !isdefined( level.cc ) )
	{
		level.cc = spawnstruct();
		level.cc.line = 0;
	}

	subtitle = newHudElem();
	subtitle.x = 0;
	subtitle.y = -80 + ( level.cc.line * 14 );
	subtitle settext( text );
	subtitle.fontScale = 1.46;
	subtitle.alignX = "center";
	subtitle.alignY = "middle";
	subtitle.horzAlign = "center";
	subtitle.vertAlign = "bottom";
	subtitle.sort = 1;
	subtitle.dbtext = text;

	my_line = level.cc.line;
	subtitle thread cc_move( my_line );

	level.cc.line++;
	waittime = ( ( text.size + 1 )/ 50) + 1;
	wait waittime;

	subtitle FadeOverTime( .5 );
	subtitle.alpha = 0;
	level.cc.line--;
	wait .5;

	level.cc notify( "move", my_line );
	subtitle notify( "destoyed" );
	subtitle destroy();

}

cc_move( my_line )
{
	self endon( "destoyed" );
	while( true )
	{
		level.cc waittill( "move", line );
		if ( line > my_line || my_line == 0 )
			continue;
		self MoveOverTime(.5);
		self.y = self.y - 14;
		my_line--;
	}
}

draw_vehicle_paths()
{
	vnode_arr = GetAllVehicleNodes();
	start_vnodes = [];
	foreach( vnode in vnode_arr )
	{
		if ( isdefined( vnode.spawnflags ) && vnode.spawnflags & 1 )
			start_vnodes[ start_vnodes.size ] = vnode;
	}

	foreach( vnode in start_vnodes )
	{
		level draw_vehicle_paths_traverse( vnode );
	}
}

draw_vehicle_paths_traverse( vnode )
{
	random_color = ( randomfloatrange( 0, 1 ), randomfloatrange( 0, 1 ), randomfloatrange( 0, 1 ) );

	while ( isdefined( vnode.target ) )
	{
		start = vnode.origin;
		vnode = getvehiclenode( vnode.target, "targetname" );
		end = vnode.origin;
		Line( start, end, random_color, 1, false, 1000 );
	}
}

debug_stance( stance )
{
	self notify( "new_debug" );
	self endon( "new_debug" );
	self endon( "death" );

	while( 1 )
	{
		wait 0.05;
		if ( getdvarint( "debug_stance", 0 ) )
		{
			if ( stance == "stand" )
				Print3d( self.origin + (0,0,80), "S" );
			else
				Print3d( self.origin + (0,0,80), "C" );
		}
	}
}