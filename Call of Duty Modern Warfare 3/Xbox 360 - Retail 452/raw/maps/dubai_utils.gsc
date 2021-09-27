#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\dubai_fx;
#include maps\_audio;

///////////////////////////////////////////////
//------------------ UTILS ------------------//
///////////////////////////////////////////////
get_black_overlay()
{
	if ( !isdefined( level.black_overlay ) )
		level.black_overlay = create_client_overlay( "black", 0, level.player );
	level.black_overlay.sort = -1;
	level.black_overlay.foreground = true;
	return level.black_overlay;
}

exp_fade_overlay( target_alpha, fade_time )
{
	self notify( "exp_fade_overlay" );
	self endon( "exp_fade_overlay" );

	fade_steps = 4;
	step_angle = 90 / fade_steps;
	current_angle = 0;
	step_time = fade_time / fade_steps;

	current_alpha = self.alpha;
	alpha_dif = current_alpha - target_alpha;

	for ( i = 0; i < fade_steps; i++ )
	{
		current_angle += step_angle;

		self FadeOverTime( step_time );
		if ( target_alpha > current_alpha )
		{
			fraction = 1 - Cos( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}
		else
		{
			fraction = Sin( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}

		wait step_time;
	}
}

player_DMS_get_plane()
{
	P = level.player.origin;
	A = self.origin + ( 200, -5000, 0 );
	B = self.origin + ( 200, 5000, 0 );
	/#
	if ( GetDvarInt( "debug_playerDMS" ) )
		Line( A, B, ( 0, 0, 1 ), 1 );
	#/
	return PointOnSegmentNearestToPoint( A, B, P );
}

player_DMS_ahead_test()
{
	ahead = false;
	//this is a test to see if we're closer to their goal than they are
	/*if ( IsDefined( self.last_set_goalent ) )
		ahead = self [[ level.drs_ahead_test ]]( self.last_set_goalent, 50 );
	else if ( IsDefined( self.last_set_goalnode ) )
		ahead = self [[ level.drs_ahead_test ]]( self.last_set_goalnode, 50 );*/
	
	if( level.player.origin[0] < self.origin[0] + 200 )
	{
		ahead = true;
	}

	return ahead;
}

get_elevator( name )
{
	struct = getstruct( name, "targetname" );

	elevator = level.elevators[ 0 ];
	dist = Distance( elevator.e[ "housing" ][ "mainframe" ][ 0 ] GetOrigin(), struct.origin );

	foreach ( obj in level.elevators )
	{
		newdist = Distance( obj.e[ "housing" ][ "mainframe" ][ 0 ] GetOrigin(), struct.origin );
		if ( newdist < dist )
		{
			elevator = obj;
			dist = newdist;
		}
	}

	return elevator;
}

move_elevator(delta_vec, moveTime, acceleration, deceleration)
{
	mainframe = self common_scripts\_elevator::get_housing_mainframe();
	
	//mainframe moveTo( mainframe.origin + delta_vec, moveTime, acceleration, deceleration );
	
	foreach( part in self.e[ "housing" ][ "mainframe" ])
	{
		moveto_pos = part.origin + delta_vec;
		
		part moveTo( moveto_pos, moveTime, acceleration, deceleration);
	}
	

	// move doors and triggers and other script models
	foreach ( part in self common_scripts\_elevator::get_housing_children() )
	{
		moveto_pos = part.origin + delta_vec;

		if ( !issubstr( part.classname, "trigger_" ) )
			part moveTo( moveto_pos, moveTime, acceleration, deceleration);
		else
			part.origin = moveto_pos;
	}
}

drop_elevator( fallTime, fallDistance )
{
	//if fallDistance is defined, fall that amount
	if( isdefined( fallDistance ) )
	{
		foreach( part in self.e[ "housing" ][ "mainframe" ])
		{
			part MoveTo( ( part.origin[0], part.origin[1], part.origin[2] - fallDistance ), fallTime, falltime, 0 );
		}
	
		foreach ( part in self common_scripts\_elevator::get_housing_children() )
		{
			if ( !issubstr( part.classname, "trigger_" ) )
				part MoveTo( ( part.origin[0], part.origin[1], part.origin[2] - fallDistance ), fallTime, falltime, 0 );
		}
	}
	else
	{
		foreach( part in self.e[ "housing" ][ "mainframe" ])
		{
			part MoveGravity( ( 0, 0, 0 ), fallTime );
		}
	
		foreach ( part in self common_scripts\_elevator::get_housing_children() )
		{
			if ( !issubstr( part.classname, "trigger_" ) )
				part MoveGravity( ( 0, 0, 0 ), fallTime );
		}
	}
	
	wait fallTime;
}

trigger_activate_targetname( trigTN )
{
	trig = GetEnt( trigTN, "targetname" );
	
	//it's possible the trigger has already been hit
	if( IsDefined( trig ) )
	{
		trig notify( "trigger" );
		return true;
	}
	else
	{
		return false;
	}
}

clear_grenades_until_flag( _flag )
{
	Assert( IsDefined( _flag ) && flag_exist( _flag ) );
	
	while ( !flag( _flag ) )
	{
		grenades = GetEntArray( "grenade", "classname" );
		
		foreach( grenade in grenades )
		{
			grenade delete();
		}
		wait 0.25;
	}
}

littlebird_handle_spotlight( delay, follow_player, offset, variance )
{
	self ent_flag_init( "spotlight_on" );

	self.spotlight = SpawnTurret( "misc_turret", self GetTagOrigin( "tag_flash" ), "heli_spotlight" );
	
	self.spotlight SetMode( "manual" );
	self.spotlight SetModel( "com_blackhawk_spotlight_on_mg_setup" );
	self.spotlight LinkTo( self, "tag_flash", (0, 0, -7), (-20, 0, 0) );

	self thread littlebird_spotlight_think( delay, follow_player, offset, variance );
	self thread littlebird_spotlight_death();
	
}

littlebird_spotlight_death()
{
    spotlight = self.spotlight;
    self waittill ( "death" );
    spotlight delete();
    
}

littlebird_spotlight_on()
{
  PlayFXonTag( getfx( "spotlight" ), self.spotlight, "tag_flash" );
}

littlebird_spotlight_off()
{
	StopFXonTag( getfx( "spotlight" ), self.spotlight, "tag_flash" );
}

littlebird_spotlight_think( delay, follow_player, offset, variance )
{
  self endon ( "death" );

	self notify( "stop_littlebird_spotlight" );
	self endon( "stop_littlebird_spotlight" );

	if( !isdefined( delay ) )
	{
		delay = 0;
	}
	
	if( !IsDefined( offset ) )
	{
		offset = (0, 0, 0);
	}
	
	if( !IsDefined( variance) )
	{
		variance = 0;
	}

	if ( delay > 0 )
	{
		//allow time for spotlight to orient
		self delaythread( delay, ::littlebird_spotlight_on );
	}
	else
	{
		self littlebird_spotlight_on();
	}

	if( IsDefined( follow_player ) && follow_player )
	{
		while( 1 )
		{
			self.spotlight SetTargetEntity( level.player, offset + randomvector( variance ) );
	
			wait( RandomFloatRange( 2, 3 ) );
		}
	}
	else 
	{
		forward = AnglesToForward( self.spotlight.angles );
		spot_target = spawn( "script_origin", self.spotlight.origin + forward * 500 + ( 0, 0, -500 ) );
		spot_target linkto( self );
		
		self.spotlight SetTargetEntity( spot_target, offset + randomvector( variance ) );
		
		time = 1;
		
		while( 1 )
		{
			//new_target = spot_target.origin + (randomvector( 250 ) );
			
			//spot_target moveTo( new_target, time );
			
			self.spotlight SetTargetEntity( spot_target, offset + randomvector( variance ) );
			
			wait( RandomFloatRange( 2, 3 ) );
			
			
		}
	}
}

chopper_loop_path_think( loop_noteworthy, end_on, speed_min, speed_max )
{
	assert( isdefined( loop_noteworthy ) );
	
	if( IsDefined( end_on ) )
	{
		level endon( end_on );
	}
	
	if( !IsDefined( speed_min ) )
	{
		speed_min = 30;
	}
	
	if( !IsDefined( speed_max ) )
	{
		speed_max = 60;
	}
	
	self SetHoverParams( 512, 20, 5 );
	
	chopper_loop = getstructarray( loop_noteworthy, "script_noteworthy" );
	loop = chopper_loop;
	
	//self vehicle_setspeed( 50, 15, 15 );
	
	index = 0;
	
	while( 1 )
	{
//loop[index] notify( "kill_debug_axis" );		
		loop = array_remove( chopper_loop, loop[index] );
		index = randomintrange( 0, loop.size );
//loop[index] thread maps\dubai_code::draw_label( "heli node", 24 );
		
		time_towards_node = randomfloatrange( 1, 4 );
		
		self vehicle_setspeed( randomintrange( speed_min, speed_max), 15, 15 );
		
		delay = 0.05;
		
		for( i = 0; i < time_towards_node; i = i + delay )
		{
			new_path = loop[ index ];
			self SetVehGoalPos( new_path.origin, 0 );
			
			wait delay;
		}
	}
}

littlebird_fire_missile( target_arr, number, cleartime, rumble )
{
	tags = [];
	tags[0] = "tag_missile_right";
	tags[1] = "tag_missile_left";
	if (!isdefined(cleartime))
		cleartime = 1.0;

	self SetVehWeapon( "littlebird_FFAR" );

	for ( i=0; i<number; i++ )
	{
		assertex( isdefined( target_arr[ i % target_arr.size ] ), "fire_missile requires indexes to start at 0 and not have any gaps." );

		target_ent = target_arr[ i % target_arr.size ];
		self SetTurretTargetEnt( target_ent );
		missile = self FireWeapon( tags[ i % tags.size ], target_ent );
		
		rumble = true;
		if( IsDefined( rumble ) && rumble )
		{
			missile thread littlebird_missile_rumble_think();
		}
		aud_send_msg("littlebird_missile_ent_fired", missile);
		if (cleartime >= 0)
			missile delaycall( cleartime, ::Missile_ClearTarget );

		if ( isdefined( target_ent.script_delay ) )
			wait target_ent.script_delay;
		else
			wait randomfloatrange( 0.2, 0.3 );
	}
}

littlebird_missile_rumble_think()
{
	self waittill( "death" );
	
	//test if explosion was close to player to play rumble
	level.player PlayRumbleOnEntity( "damage_light" );
}

// fake death
bloody_death( delay, source )
{
	self endon( "death" );

	if( !IsSentient( self ) || !IsAlive( self ) )
	{
		return;
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";

	fov = GetDvarInt( "cg_fov" );

	for( i = 0; i < 3 + RandomInt( 5 ); i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
		
		//if player is not looking at the source
		if( IsDefined( source ) && isai( source ) && IsAlive( source ) )
		{
			if( !level.player WorldPointInReticle_Circle( source.origin, fov, 500 ) )
			{
				source shootblank();
			}
		}
	}

	self DoDamage( self.health + 50, self.origin );
}

bloody_death_fx( tag, fxName )
{
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}

glass_within_volume( glass, volume )
{
	// offset the goalpos vertically a bit to compensate for volume not touching ground
	if ( origin_within_volume( GetGlassOrigin( glass ), volume ) )
	{
		return true;
	}

	return false;
}

origin_within_volume( origin, volume )
{
	testOrg = Spawn( "script_origin", origin );
	returnVal = false;

	if ( testOrg IsTouching( volume ) )
	{
		returnVal = true;;
	}

	testOrg Delete();
	return returnVal;
}

player_leaps( trig, jump_forward, goodDot, checkIsOnGround )
{
	if( !IsDefined( goodDot ) )
	{
		goodDot = 0.965;
	}
	
	if( !IsDefined( checkIsOnGround ) )
	{
		checkIsOnGround = true;
	}
	
	if( !level.player IsTouching( trig ) )
	{
		return false;
	}
	
	if ( level.player GetStance() != "stand" )
	{
		return false;
	}
	
	if( checkIsOnGround && level.player IsOnGround() )
	{
		return false;
	}

	// gotta jump straight
	player_angles = level.player GetPlayerAngles();
	player_angles = ( 0, player_angles[ 1 ], 0 );
	player_forward = anglestoforward( player_angles );
	dot = vectordot( player_forward, jump_forward );
	if ( dot < goodDot )
	{
		return false;
	}

	vel = level.player GetVelocity();
	// figure out the length of the vector to get the speed (distance from world center = length)
	velocity = Distance( ( vel[ 0 ], vel[ 1 ], 0 ), ( 0, 0, 0 ) );  // don't care about Z velocity
	if ( velocity < 162 )
	{
		return false;
	}

	//level.player setVelocity( ( vel[ 0 ] * 1.5, vel[ 1 ] * 1.5, vel[ 2 ] ) );
	return true;
}

player_jump_watcher()
{
	level endon( "player_jump_watcher_stop" );
	
	jumpflag = "player_jumping";
	if( !flag_exist( jumpflag ) )
	{
		flag_init( jumpflag );
	}
	else
	{
		flag_clear( jumpflag );
	}
	
	NotifyOnCommand( "playerjump", "+gostand" );
	NotifyOnCommand( "playerjump", "+moveup" );
	
	while( 1 )
	{
		level.player waittill( "playerjump" );
		wait( 0.1 );  // jumps don't happen immediately
		
		if( !level.player IsOnGround() )
		{
			flag_set( jumpflag );
			println( "jumping" );
		}
		
		while( !level.player IsOnGround() )
		{
			wait( 0.05 );
		}
		flag_clear( jumpflag );
		println( "not jumping" );
	}
}

player_falling_kill_logic( fall_time )
{
	deadQuoteSize = ( Int( TableLookup( "sp/deathQuoteTable.csv", 1, "size", 0 ) ) );
	deadQuoteIndex = randomInt( deadQuoteSize );
	SetDvar( "ui_deadquote", maps\_quotes::lookupDeathQuote( deadQuoteIndex ) );
	
	flagstr = "player_falling_kill_in_progress";

	if ( flag( flagstr ) )
	{
		return;
	}
	else
	{
		flag_set( flagstr );
	}
	
	if( !isdefined( fall_time ) )
	{
		fall_time = 3;
	}
	
	flag_clear( "can_save" );	//don't allow saving if we are falling/sliding to death
	
	endTime = GetTime() + (fall_time * 1000);
	while( !level.player IsOnGround() && GetTime() < endTime )
	{
		wait( 0.05 );
	}
	
	if( level.player IsOnGround() )
	{
		level.player Kill();
	}
	else
	{
		maps\_utility::missionFailedWrapper();
	}
}

elevator_glass_think()
{
	if (self.classname != "script_model")
		return;
	
	if(!isdefined(level.precachemodeltype["dubai_elevator_glass"]))
	{
		level.precachemodeltype["dubai_elevator_glass"] = true;
		precacheModel("dub_bldg_elevator_glass_shattered");
		precacheModel("dub_bldg_elevator_glass_broken01");	
	}
	
	self.damageTaken = 0;
	self setcandamage(true);
	
	self endon ("destroyed");
	
	for (;;)
	{
		self waittill("damage", amount ,attacker, direction_vec, P, type);
		if( type == "MOD_IMPACT" )
			self thread elevator_glass_destroy();
		
		self.damagetype = type;
		
		self.damageOwner = attacker;
			
		self.damageTaken += amount;
		if (self.damageTaken == amount)
			self thread elevator_glass_shatter();
		else if( self.damagetaken >= level.elevatorGlassHealth )
			self thread elevator_glass_destroy();
	}
}

elevator_glass_shatter()
{
	self setmodel( "dub_bldg_elevator_glass_shattered" );
	
	count = 0;
	
	if( self.damagetype == "MOD_GRENADE_SLASH" || self.damagetype == "MOD_GRENADE" || self.damagetaken > level.elevatorGlassHealth )
	{
		self thread elevator_glass_destroy();
	}
	else
	{
		aud_send_msg("aud_elevator_glass_shatter", self);
	}

}

elevator_glass_destroy()
{
	self notify( "destroyed" );
	aud_send_msg("aud_elevator_glass_destroy", self);
	PlayFX( level._effect[ "dubai_elevator_glass" ], self.origin , anglestoforward(self.angles),anglestoup(self.angles));
	self setmodel( "dub_bldg_elevator_glass_broken01" );
	self setCanDamage( false );
}

elevator_glass_attach()
{
	glassmodels = getentarray( "elevator_glass", "targetname" );
	
	mainframe = self common_scripts\_elevator::get_housing_mainframe();
	
	foreach( glass in glassmodels )
	{
		if( distance( glass.origin, mainframe.origin ) < 1000 )
		{
			glass linkto( mainframe );
		}
	}
}

get_group_origin()
{
	foreach( piece in self )
	{
		if( piece.classname == "script_brushmodel" )
		{
			return piece.origin;
		}
	}
}

juggernaut_yuri_anim_setup()
{
	saved_damage_functions = self.damage_functions;
	self.damage_functions = [];
	
	self waittill( "anim_complete" );
	
	self.damage_functions = saved_damage_functions;
}

#using_animtree( "generic_human" );
civilian_drone_runners_think()
{
	self endon( "death" );
	
	if ( isdefined( self.script_parameters ) )
	{
		self.script_noteworthy = self.script_parameters;	
	}
	
	//random running death animation
	self.deathanim = array_randomize(	level.drone_deaths_r )[0];
	
	runAnims = [];
	runAnims[runAnims.size] = "civilian_run_upright_relative";
	runAnims[runAnims.size] = "civilian_run_hunched_A_relative";
	runAnims[runAnims.size] = "civilian_run_hunched_C_relative";
	
	runAnims = array_randomize( runAnims );
	
	
	self.runAnim = getgenericanim( runAnims[0] );
	if ( self.weapon != "none"  )
		self gun_remove();
	self.idleAnim = %civilain_crouch_hide_idle_loop;
	
	self thread civilian_drone_runner_collision();
		
	self waittill( "goal" );
	
	self delete();
}

civilian_drone_runner_collision()
{
	self endon( "goal" );
	self endon( "death" );
	
	while( isdefined( self ) )
	{
		while( distance( self.origin, level.player.origin ) > 100 )
		{
			//too_close = true;
			//iprintln( "too close" );
			wait 0.1;
		}
		
		contents = self setcontents( 0 );
		
		while( distance( self.origin, level.player.origin ) <= 100 )
		{
			wait 0.1;
		}
		
		self setcontents( contents );
	}
}

civilian_drone_stationary_think( delete_on_flag )
{
	self endon( "death" );
	
	//random stationary death animation
	self.deathanim = array_randomize(	level.drone_deaths_s )[0];
	
	if ( isdefined( self.script_parameters ) )
	{
		self.script_noteworthy = self.script_parameters;	
	}
	
	if ( self.weapon != "none"  )
			self gun_remove();
	
	if ( isdefined( self.animation ) )
		self.idleAnim = self.animation;
	else
		self.idleAnim = %civilain_crouch_hide_idle_loop;
	
	self.spawner thread anim_generic_loop( self, self.idleAnim );
	
	flag_wait( delete_on_flag );
	
	self delete();
}

civilian_drone_elevator_think()
{
	self endon( "death" );
	
	//random running death animation
	self.deathanim = array_randomize(	level.drone_deaths_r )[0];
	
	if( isdefined( self.script_delay ) )
	{
		self thread notify_delay( "pause", self.script_delay );
	}
	
	if ( isdefined( self.script_parameters ) )
	{
		self.script_noteworthy = self.script_parameters;	
	}
	
	if ( isdefined( self.animation ) )
	{
		self.runAnim = getgenericanim( self.animation );
		if ( self.weapon != "none"  )
			self gun_remove();
		self.idleAnim = %civilain_crouch_hide_idle_loop;
	}
	
	self waittill( "pause" );
	
	//random stationary death animation
	self.deathanim = array_randomize(	level.drone_deaths_s )[0];
	
	//loop animation
	self thread anim_generic_loop( self, "civilain_crouch_hide_idle_loop", "move" );
	
	flag_wait( "elevator_drones_flee" );
	
	wait RandomFloatRange( 0.5, 1 );
	
	//random running death animation
	self.deathanim = array_randomize(	level.drone_deaths_r )[0];
	
	self.target = self.cur_node["target"];
	self thread maps\_drone::drone_move();
	//self notify( "move" );
	
	flag_wait( "elevator_doors_closed" );
	self delete();
}

civilian_drone_run_and_hide_think( flag_remove )
{
	self endon( "death" );
	
	self.noragdoll = true;
	
	//random running death animation
	self.deathanim = array_randomize(	level.drone_deaths_r )[0];
	
	if ( isdefined( self.script_parameters ) )
	{
		self.script_noteworthy = self.script_parameters;	
	}
	
	if ( isdefined( self.animation ) )
	{
		self.runAnim = getgenericanim( self.animation );
		if ( self.weapon != "none"  )
			self gun_remove();
		self.idleAnim = %civilain_crouch_hide_idle_loop;
	}
	
	thread civilian_drone_run_and_hide_kill_if_player_hit();
	
	self waittill( "goal" );
	
	//random stationary death animation
	self.deathanim = array_randomize(	level.drone_deaths_s )[0];
	
	flag_wait( flag_remove );
	self delete();
}

civilian_drone_run_and_hide_kill_if_player_hit()
{
	self endon( "goal" );
	self endon( "death" );
	
	while( isdefined( self ) )
	{	
		if( distance( self.origin, level.player.origin ) <= 100 )
		{
			self setcontents( 0 );
			self kill();
			break;
		}
		wait 0.05;
	}
}

elevator_floor_numbers( noteworthy, flag_end )
{
	elevator = getent( noteworthy, "script_noteworthy" );
	
	//elevator moveto( elevator.origin + (0, 0, 200), 5 );
	
	tag_origin1 = spawn_tag_origin();
	tag_origin1.origin = elevator.origin + ( 78.5, -51, 82.5 );
	tag_origin1.angles = (0, 180, 0);
	tag_origin1 linkto( elevator );
	
	tag_origin2 = spawn_tag_origin();
	tag_origin2.origin = elevator.origin + ( 78.5, -53, 82.5 );
	tag_origin2.angles = (0, 180, 0);
	tag_origin2 linkto( elevator );

	fx1 = level._effect[ "dubai_elevator_num_9" ];
	fx2 = level._effect[ "dubai_elevator_num_9" ];
	
	fx1_prev = level._effect[ "dubai_elevator_num_0" ];
	fx2_prev = level._effect[ "dubai_elevator_num_0" ];
	
	fx1_num_prev = 0;
	fx2_num_prev = 0;
	
	fx1_first_pass = true;
	fx2_first_pass = true;
	
	floor_num_prev = 0;
	
	while( !flag( flag_end ) )
	{
		floor_num = int(floor(elevator.origin[2] / 288) + 1);
		
		if( floor_num != floor_num_prev )
		{
			floor_num_prev = floor_num;
			aud_send_msg("elevator_floor_change", tag_origin1);
			
			fx1_num = floor( floor_num / 10 );
	//		iprintln( "fx1_num = " + fx1_num );
			
			fx2_num = floor_num % 10;
	//		iprintln( "fx2_num = " + fx2_num );
			
			if( floor_num > 0 )
			{
				if( fx1_num != fx1_num_prev )
				{
					fx1_prev = fx1;
					fx1 = level._effect[ "dubai_elevator_num_" + fx1_num ];
					
					stopfxontag( fx1_prev, tag_origin1, "tag_origin" );
					
					if( fx1_num == 2 && fx2_num == 8 )
					{
						// do nothing
					}
					else if( fx1_num > 0 )
						PlayFXOnTag( fx1, tag_origin1, "tag_origin" );
					
					fx1_num_prev = fx1_num;
				}
					
				if( fx2_num != fx2_num_prev )
				{
					fx2_prev = fx2;
					
					//special case for lobby
					if( fx1_num == 0 && fx2_num == 2 )
						fx2 = level._effect[ "dubai_elevator_num_l" ];
					else if( fx1_num == 2 && fx2_num == 8 )
					{
						stopfxontag( fx1, tag_origin1, "tag_origin" );
						fx2 = level._effect[ "dubai_elevator_num_g" ];
					}
					else
						fx2 = level._effect[ "dubai_elevator_num_" + fx2_num ];
					
					stopfxontag( fx2_prev, tag_origin2, "tag_origin" );
					PlayFXOnTag( fx2, tag_origin2, "tag_origin" );
					fx2_num_prev = fx2_num;
				}
			}
		}
		wait 0.05;
	}
	
	stopfxontag( fx1, tag_origin1, "tag_origin" );
	stopfxontag( fx2, tag_origin2, "tag_origin" );
}

minimap_update( num )
{
	switch( num )
	{
		case 1:
			maps\_compass::setupMiniMap( "compass_map_dubai", "minimap_corner" );
			setsaveddvar( "compassMaxRange", "3500" ); // default
			break;
		case 2:
			maps\_compass::setupMiniMap( "compass_map_dubai_2", "minimap_corner_2" );
			setsaveddvar( "compassMaxRange", "2000" ); // zoom in
			break;
		case 3:
			maps\_compass::setupMiniMap( "compass_map_dubai_3", "minimap_corner_2" );
			setsaveddvar( "compassMaxRange", "2000" ); // zoom in
			break;
	}
}

destroy_finale_func_glass()
{
	//destroy func_glass
	lounge_glass = GetGlassArray( "muntaha_glass_destroy" );	
	foreach( glass in lounge_glass )
	{
		DestroyGlass( glass );
	}
}

//****************************************//
// VISION SET UTILS
//****************************************//

blackOut( duration, blur )
{
	//wait duration;
	self fadeOverlay( duration, 1, blur );
}

grayOut( duration, blur )
{
	//wait duration;
	self fadeOverlay( duration, 0.6, blur );
}

restoreVision( duration, blur )
{
	//wait duration;
	self fadeOverlay( duration, 0, blur );
}

fadeOverlay( duration, alpha, blur )
{
	self fadeOverTime( duration );
	self.alpha = alpha;
	setblur( blur, duration );
	wait duration;
}