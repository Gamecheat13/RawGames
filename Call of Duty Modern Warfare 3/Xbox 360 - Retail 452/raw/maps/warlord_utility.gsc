#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_anim;
#include maps\_audio;

// general functions
debug_draw_point( pos, draw_color )
{
	cross_half_length = 24;
	
	for ( i = 0; i < 3; i++ )
	{
		pos_x = pos[0];
		pos_y = pos[1];
		pos_z = pos[2];
		
		pos_x_end = pos[0];
		pos_y_end = pos[1];
		pos_z_end = pos[2];
		
		// wow, why can't i assign to a vector?  sigh.
		if ( i == 0 )
		{
			pos_x = pos_x - cross_half_length;
			pos_x_end = pos_x_end + cross_half_length;
		}
		else if ( i == 1 )
		{
			pos_y = pos_y - cross_half_length;
			pos_y_end = pos_y_end + cross_half_length;
		}
		else if ( i == 2 )
		{
			pos_z = pos_z - cross_half_length;
			pos_z_end = pos_z_end + cross_half_length;
		}
		
		line_start = ( pos_x, pos_y, pos_z );
		line_end = (pos_x_end, pos_y_end, pos_z_end );
		line ( line_start, line_end, draw_color );
	}
}

create_exploder_id( group_id, index_id )
{
	return group_id + " - " + index_id;
}

adjust_exploders()
{
	new_exploder_list = [];
	
	foreach ( key,exploder_group in level.createFXexploders )
	{
		// check special warlord exploders set up properly
		exploder_is_grouped = undefined;
		
		foreach ( exploder_ent in exploder_group )
		{
			assert_message = "script group not on all parts of exploder: " + key + ", at: " + exploder_ent.v[ "origin" ];
			
			if ( !IsDefined( exploder_ent.model ) || !IsDefined( exploder_ent.model.script_group ) )
			{
				AssertEx( !IsDefined( exploder_is_grouped ) || !exploder_is_grouped, assert_message );
				exploder_is_grouped = false;
				
				if ( !IsDefined( new_exploder_list[ key ] ) )
					new_exploder_list[ key ] = [];
			
				new_exploder_list[ key ][ new_exploder_list[ key ].size ] = exploder_ent;
				continue;
			}

			AssertEx( !IsDefined( exploder_is_grouped ) || exploder_is_grouped, assert_message );
			exploder_is_grouped = true;
			
			new_exploder_id = create_exploder_id( exploder_ent.model.script_group, exploder_ent.model.script_exploder );
			exploder_ent.v[ "exploder" ] = new_exploder_id;
			
			if ( !IsDefined( new_exploder_list[ new_exploder_id ] ) )
				new_exploder_list[ new_exploder_id ] = [];
			
			new_exploder_list[ new_exploder_id ][ new_exploder_list[ new_exploder_id ].size ] = exploder_ent;
		}
	}
	
	level.createFXexploders = new_exploder_list;
	
	// adjust any triggers
	for ( p = 0;p < 6;p ++ )
	{
		switch( p )
		{
			case 0:
				triggertype = "trigger_multiple";
				break;

			case 1:
				triggertype = "trigger_once";
				break;

			case 2:
				triggertype = "trigger_use";
				break;
				
			case 3:	
				triggertype = "trigger_radius";
				break;
			
			case 4:	
				triggertype = "trigger_lookat";
				break;

			default:
				assert( p == 5 );
				triggertype = "trigger_damage";
				break;
		}

		triggers = getentarray( triggertype, "classname" );
		
		for ( i = 0;i < triggers.size;i ++ )
		{
			if( isdefined( triggers[ i ].script_prefab_exploder) )
				triggers[i].script_exploder = triggers[ i ].script_prefab_exploder;

			if( isdefined( triggers[ i ].script_exploder) )
			{
				if ( IsDefined( triggers[ i ].script_group ) )
				{
					level notify( "killexplodertridgers" + triggers[ i ].script_exploder );
					triggers[ i ].script_exploder = create_exploder_id( triggers[ i ].script_group, triggers[ i ].script_exploder );
					level thread warlord_exploder_load( triggers[ i ] );
				}
				
				// link trigger to every exploder with the same id
				exploder_group = level.createFXexploders[ triggers[ i ].script_exploder ];
				foreach ( exploder_ent in exploder_group )
				{
					if ( !IsDefined( exploder_ent.v[ "trigger" ] ) )
					{
						exploder_ent.v[ "trigger" ] = [];
					}
					exploder_ent.v[ "trigger" ][ exploder_ent.v[ "trigger" ].size ] = triggers[ i ];
				}
			}
		}
	}
}

warlord_exploder_load( trigger )
{
	level endon( "killexplodertridgers" + trigger.script_exploder );
	trigger waittill( "trigger", triggered_entity );
	
	if ( IsDefined( triggered_entity ) )
	{
		if ( ( IsAI( triggered_entity ) && triggered_entity IsBadGuy() ) || 
		     ( IsDefined( triggered_entity.script_team ) && triggered_entity.script_team == "axis" ) )
		{
			level thread warlord_exploder_load( trigger );
			return;
		}
	}
	
	if ( IsDefined( trigger.script_chance ) && RandomFloat( 1 ) > trigger.script_chance )
	{
		if ( !trigger script_delay() )
			wait 4;

		level thread warlord_exploder_load( trigger );
		return;
	}

	if ( !trigger script_delay() && IsDefined( trigger.script_exploder_delay ) )
	{
		wait( trigger.script_exploder_delay );
	}

	exploder( trigger.script_exploder );
	level notify( "killexplodertridgers" + trigger.script_exploder );
}

warlord_technical_exploder( num )
{
	AssertEx( IsDefined( level.createFXexploders ), "Warlord should use optimized exploders." );
	
	num += "";

	//here's a hook so you can know when a certain number of an exploder is going off
	level notify( "exploding_" + num );
	
	if ( IsDefined(level.createFXexploders) && !level.createFX_enabled )
	{	// do optimized form if available
		exploders = level.createFXexploders[ num ];
		if ( IsDefined( exploders ) )
		{
			foreach (ent in exploders)
			{
				if ( ( ent.v[ "exploder_type" ] == "exploderchunk" ) || ( ent.v[ "exploder_type" ] == "exploderchunk visible" ) )
				{
					if ( IsDefined( ent.model ) )
					{
						ent.model NotSolid();
					}
				}
				
				ent activate_individual_exploder();
			}
		}
	}
	else
	{
		activate_exploder( num );
	}
}

// critically dampened smoothing
SmoothCD( from, to, vel_struct, smooth_time )
{
	omega = ( 2 / smooth_time );
	x = omega * 0.05;
	exponent = 1 / ( 1 + x + 0.48 * x * x + 0.235 * x * x * x );
	change = from - to;
	temp = (vel_struct.vel + omega * change) * 0.05;
	vel_struct.vel = (vel_struct.vel - omega*temp) * exponent;
	return to + ( change + temp ) * exponent;
}

// show a warning indicator.
//   danger_pos: a world position
//   timer: time in seconds to show the indicator
show_warning_indicator( danger_pos, timer )
{
	warning_icon = level.player createIcon( "hud_grenadeicon", 20, 20 );
	warning_icon.alpha = 1;
	warning_icon.archived = true;
	warning_icon.sort = 1;
	warning_icon.foreground = true;
	
	warning_icon SetPoint( "CENTER", undefined, 0, 0 );
	warning_icon.hud_radius = 50;
	warning_icon.old_angle = 0;
	warning_icon.angle_vel = 0;
	warning_icon.angle_accel = 1;
	
	vel_struct = SpawnStruct();
	vel_struct.vel = 0;
	
	current_time = 0;
	while ( current_time < timer )
	{
		player_angles = level.player GetPlayerAngles();
		player_forward = AnglesToForward( player_angles );
		player_forward = (player_forward[0], player_forward[1], 0 );
		player_forward = VectorNormalize( player_forward );
		player_right = AnglesToRight( player_angles );
		player_right = (player_right[0], player_right[1], 0 );
		player_right = VectorNormalize( player_right );
		
		to_danger_pos = danger_pos - level.player.origin;
		to_danger_pos = ( to_danger_pos[0], to_danger_pos[1], 0 );
		to_danger_pos = VectorNormalize( to_danger_pos );
		
		forward_dot = VectorDot( to_danger_pos, player_forward );
		right_dot = VectorDot( to_danger_pos, player_right );
		
		new_angle = acos( forward_dot );
		if ( right_dot < 0 )
		{
			new_angle = new_angle * -1;
		}
		
		if ( abs( AngleClamp180( new_angle - warning_icon.old_angle ) ) < 0.01 )
		{
		}
		else
		{
			//new_angle = LerpValue( self.old_angle, new_angle );
			angle_delta = AngleClamp180( new_angle - warning_icon.old_angle );
			new_angle = warning_icon.old_angle + angle_delta;
			
			new_angle = SmoothCD( warning_icon.old_angle, new_angle, vel_struct, 0.25 );
			warning_icon.old_angle = new_angle;
	
			warning_icon.x = warning_icon.hud_radius * sin( new_angle );
			warning_icon.y = warning_icon.hud_radius * cos( new_angle ) * -1;
			warning_icon MoveOverTime( 0.05 );
		}
		
		current_time = current_time + 0.05;
		wait 0.05;
	}
	
	warning_icon Destroy();
	
	/*
	magic_grenade = MagicGrenadeManual( "fraggrenade", grenade_pos, (0,0,0), timer + 1 );
	//magic_grenade Hide();

	current_time = 0;
	while ( current_time < timer )
	{
		player_angles = level.player GetPlayerAngles();
		player_forward = AnglesToForward( player_angles );
		player_forward = (player_forward[0], player_forward[1], 0 );
		player_forward = VectorNormalize( player_forward );
		player_right = AnglesToRight( player_angles );
		player_right = (player_right[0], player_right[1], 0 );
		player_right = VectorNormalize( player_right );
		
		to_grenade_pos = grenade_pos - level.player.origin;
		to_grenade_pos = ( to_grenade_pos[0], to_grenade_pos[1], 0 );
		to_grenade_pos = VectorNormalize( to_grenade_pos );
		to_grenade_pos = to_grenade_pos * 100;
		
		magic_grenade.origin = level.player.origin + to_grenade_pos;
		
		current_time = current_time + 0.05;
		wait 0.05;
	}
	
	magic_grenade Delete();
	*/
}

show_warning_waypoint( danger_pos, timer )
{
	warning_icon = NewHudElem();
	warning_icon SetShader( "hud_grenadeicon", 5, 5 );
	warning_icon.alpha = 1;
	warning_icon.color = ( 1, 1, 1 );
	warning_icon.x = danger_pos[ 0 ];
	warning_icon.y = danger_pos[ 1 ];
	warning_icon.z = danger_pos[ 2 ];
	warning_icon SetWayPoint( true, true );
	wait( timer );
	warning_icon Destroy();
}

move_entity_to_start( start_name )
{
	start_point = getstruct( start_name, "targetname" );
	self forceTeleport( start_point.origin, start_point.angles );
}

wait_use_button_up()
{
	while ( level.player useButtonPressed() )
	{
		wait 0.05;
	}
}

wait_use_button_down()
{
	while ( !level.player useButtonPressed() )
	{
		wait 0.05;
	}
}

kill_no_react()
{
	if ( !isalive( self ) )
		return;
	self.allowDeath = true;
	self.a.nodeath = true;
	self thread set_battlechatter( false );

	self kill();
}

warlord_waterfx( endflag )
{
// currently using these devraw fx:
//	level._effect[ "water_stop" ]						= LoadFX( "misc/parabolic_water_stand" );
//	level._effect[ "water_movement" ]					= LoadFX( "misc/parabolic_water_movement" );

	self endon( "death" );

	if ( IsDefined( endflag ) )
	{
		flag_assert( endflag );
		level endon( endflag );
	}
	for ( ;; )
	{
		wait( RandomFloatRange( 0.15, 0.3 ) );
		start = self.origin + ( 0, 0, 150 );
		end = self.origin - ( 0, 0, 150 );
		trace = BulletTrace( start, end, false, undefined );
		if ( trace[ "surfacetype" ] != "water" )
			continue;

		fx = "warlord_water_movement";
		if ( IsPlayer( self ) )
		{
			if ( Distance( self GetVelocity(), ( 0, 0, 0 ) ) < 5 )
			{
				fx = "water_stop";
			}
		}
		else
		if ( IsDefined( level._effect[ "water_" + self.a.movement ] ) )
		{
			fx = "water_" + self.a.movement;
		}

		water_fx = getfx( fx );
		start = trace[ "position" ];
		//angles = vectortoangles( trace[ "normal" ] );
		angles = (0,self.angles[1],0);
		forward = anglestoforward( angles );
		up = anglestoup( angles );
		PlayFX( water_fx, start, up, forward );
	}
}

// ---- door kicker guys ----
// spawns AIs in a house and has one of them kick the door open
door_kick_housespawn( spawners, door, animRef, physicsRef )
{
	door endon( "death" );
	
	spawners = array_randomize( spawners );
	
	kickerSpawner = undefined;
	
	// if one of them has script_parameters set to "kicker" then he should kick the door
	foreach( spawner in spawners )
	{
		if( IsDefined( spawner.script_parameters ) && spawner.script_parameters == "kicker" )
		{
			kickerSpawner = spawner;
			break;
		}
	}
	
	if( !IsDefined( kickerSpawner ) )
	{
		kickerSpawner = spawners[ 0 ];
	}
	
	spawners = array_remove( spawners, kickerSpawner );
	kicker = kickerSpawner spawn_ai( true );
	kicker.allowdeath = true;

	// spawn the other guys after the kicker has started his anim
	if( spawners.size )
	{
		delaythread( 0.15, ::spawn_ai_group, spawners );
	}
	
	kickAnime = "door_kick_in";
	kickNotetrack = "kick";
	if( IsDefined( animRef.script_noteworthy ) )
	{
		switch( animRef.script_noteworthy )
		{
			case "wave":
				kickAnime = "doorburst_wave";
				kickNotetrack = "door_kick";
				break;
				
			case "search":
				kickAnime = "doorburst_search";
				kickNotetrack = "door_kick";
				break;
			
			case "fall":
				kickAnime = "doorburst_fall";
				kickNotetrack = "door_kick";
				break;
		}
	}
	
	animRef thread anim_generic( kicker, kickAnime );
	kicker waittillmatch( "single anim", kickNotetrack );
	thread play_sound_in_space( "door_wood_double_kick", door.origin );
	door thread sbmodel_rotate( 0.25, true );
	
	// optionally push some stuff out of the way when the door opens
	if( IsDefined( physicsRef ) )
	{
		PhysicsExplosionCylinder( physicsRef.origin, physicsRef.radius, ( physicsRef.radius / 2 ), 1.0 );
	}
	
	kicker waittillmatch( "single anim", "end" );
	
	if( IsAlive( kicker ) )
	{
		if( IsDefined( kickerSpawner.script_playerseek ) && kickerSpawner.script_playerseek > 0 )
		{
			kicker playerseek();
		}
		else
		{
			if( IsDefined( kickerSpawner.target ) )
			{
				node = GetNode( kickerSpawner.target, "targetname" );
				if( IsDefined( node ) )
				{
					kicker set_temp_goalradius( 96 );
					kicker SetGoalNode( node );
				
					kicker waittill_notify_or_timeout( "goal", 5 );
					
					if( IsAlive( kicker ) )
					{
						kicker restore_goalradius();
					}
				}
			}
		}
	}
}

// -----------------
// -- UTIL STUFF --
// -----------------
sbmodel_rotate( rotateTime, makeNotSolid )
{
	self endon( "death" );
	
	if( !IsDefined( makeNotSolid ) )
	{
		makeNotSolid = false;
	}
	
	linker = GetEnt( self.target, "targetname" );
	ASSERTEX( IsDefined( linker ), "sbmodel_rotate(): sbmodel at origin " + self.origin + " doesn't have a linker entity targeted. Did you make it a script_struct instead of a script_origin by mistake?" );
	
	self LinkTo( linker );
	
	self ConnectPaths();
	
	ASSERTEX( IsDefined( linker.script_angles ), "sbmodel rotate linker script_origin at origin " + linker.origin + " needs script_angles set." );
	
	linker.og_angles = linker.angles;
	
	linker RotateTo( linker.script_angles, rotateTime );
	linker waittill( "rotatedone" );
	
	self DisconnectPaths();
	
	self Unlink();
	
	if( makeNotSolid )
	{
		self NotSolid();
		self thread make_solid_again_when_player_isnt_touching();
	}
	
	self notify( "sbmodel_rotatedone" );
}

make_solid_again_when_player_isnt_touching()
{
	while( level.player IsTouching( self ) )
	{
		wait( 0.05 );
	}
	
	self Solid();
}

sbmodel_rotate_back( rotateTime )
{
	linker = GetEnt( self.target, "targetname" );
	ASSERTEX( IsDefined( linker.og_angles ) );
	
	self LinkTo( linker );
	
	self ConnectPaths();
	
	ASSERTEX( IsDefined( linker.script_angles ), "sbmodel rotate linker script_origin at origin " + linker.origin + " needs script_angles set." );
	
	linker RotateTo( linker.og_angles, rotateTime );
	linker waittill( "rotatedone" );
	
	self DisconnectPaths();
	
	self Unlink();
	
	self notify( "sbmodel_rotatedone" );
}

restore_goalradius()
{
	if( IsDefined( self.og_goalradius ) )
	{
		self.goalradius = self.og_goalradius;
	}
}

set_temp_goalradius( newRadius )
{
	if( !IsDefined( self.og_goalradius ) )
	{
		self.og_goalradius = self.goalradius;
	}
	
	self.goalradius = newRadius;
}

playerseek()
{
	self SetGoalEntity( level.player );
}

//in favela this is called spawn_group but this is taken by _vehicle already so renamed it here.
spawn_ai_group( aSpawners, doSafe, doStaggered )
{
	ASSERTEX( ( aSpawners.size > 0 ), "The array passed to array_spawn function is empty" );
	
	if( !IsDefined( doSafe ) )
	{
		doSafe = false;
	}
	
	if( !IsDefined( doStaggered ) )
	{
		doStaggered = false;
	}
	
	aSpawners = array_randomize( aSpawners );
	
	spawnedGuys = [];
	foreach( index, spawner in aSpawners )
	{
		guy = spawner spawn_ai();
		spawnedGuys[ spawnedGuys.size ] = guy;
		
		if( doStaggered )
		{
			if( index != ( aSpawners.size - 1 ) )
			{
				wait( randomfloatrange( .25, 1 ) );
			}
		}
	}
	
	if( doSafe )
	{
		//check to ensure all the guys were spawned
		ASSERTEX( ( aSpawners.size == spawnedGuys.size ), "Not all guys were spawned successfully from array_spawn" );
	}

	return spawnedGuys;
}

take_player_weapon( weapon )
{
	AssertEx( IsPlayer( self ), "can only be called on a player" );
	
	self TakeWeapon( weapon );
	wait 0.1;
	
	if ( level.player GetCurrentWeapon() == "none" )
	{
		primary_weapons = level.player GetWeaponsListPrimaries();
		switch_to_weapon = undefined;
		foreach ( primary_weapon in primary_weapons )
		{
			AssertEx( primary_weapon != weapon, weapon + " still equipped?" );
			switch_to_weapon = primary_weapon;
			break;
		}
	
		if ( !IsDefined( switch_to_weapon ) )
		{
			offhand_weapons = level.player GetWeaponsListOffhands();
			foreach ( offhand_weapon in offhand_weapons )
			{
				AssertEx( offhand_weapon != weapon, weapon + " still equipped?" );
				switch_to_weapon = offhand_weapon;
				break;
			}
		}
		
		if ( IsDefined( switch_to_weapon ) )
		{
			level.player SwitchToWeapon( switch_to_weapon );
		}
	}
}

switch_player_weapon( from_weapon, to_weapon )
{
	AssertEx( IsPlayer( self ), "can only be called on a player" );
	
	primary_weapons = level.player GetWeaponsListPrimaries();
	switch_to_weapon = undefined;
	foreach ( primary_weapon in primary_weapons )
	{
		if ( primary_weapon != from_weapon )
		{
			if ( !IsDefined( to_weapon ) || ( to_weapon == from_weapon || to_weapon == primary_weapon ) )
			{
				switch_to_weapon = primary_weapon;
				break;
			}
		}
	}
	
	if ( !IsDefined( switch_to_weapon ) )
	{
		offhand_weapons = level.player GetWeaponsListOffhands();
		foreach ( offhand_weapon in offhand_weapons )
		{
			if ( offhand_weapon != from_weapon )
			{
				if ( !IsDefined( to_weapon ) || ( to_weapon == from_weapon || to_weapon == offhand_weapon ) )
				{
					switch_to_weapon = offhand_weapon;
					break;
				}
			}
		}
	}
		
	if ( IsDefined( switch_to_weapon ) )
	{
		level.player SwitchToWeaponImmediate( switch_to_weapon );
	}
}

delayed_door_open_slow( wait_time, soundalias )
{
	if ( IsDefined( wait_time ) && wait_time > 0 )
	{
		wait wait_time;
	}
	
	params = [self, soundalias];
	aud_send_msg("door_open_slow", params);

	self RotateTo( self.angles + ( 0, 70, 0 ), 2, .5, 0 );
	self ConnectPaths();
	self waittill( "rotatedone" );
	self RotateTo( self.angles + ( 0, 40, 0 ), 2, 0, 2 );
}

delayed_door_open_slow_wide( wait_time, soundalias )
{
	if ( IsDefined( wait_time ) && wait_time > 0 )
	{
		wait wait_time;
	}
	
	params = [self, soundalias];
	aud_send_msg("door_open_slow_wide", params);

	self RotateTo( self.angles + ( 0, 70, 0 ), 2, .5, 0 );
	self ConnectPaths();
	self waittill( "rotatedone" );
	self RotateTo( self.angles + ( 0, 100, 0 ), 2, 0, 2 );
}

shut_open_door_wide()
{
	self RotateTo( self.angles - ( 0, 170, 0 ), 0.1 );
	self waittill( "rotatedone" );
	self DisconnectPaths();
}

guys_kill_targets( guys, targets, kill_delay )
{
	random_guy_starts = randomint( guys.size );
	for ( i = 0; i < guys.size; i++ )
	{
		guy_index = ( i + random_guy_starts ) % guys.size;
		killer = guys[ guy_index ];
		if ( !IsAlive( killer ) )
			continue;
			
		killer thread guy_kills_targets( targets, kill_delay );
	}
	
	level waittill( "all_targets_killed" );
}

guy_kills_targets( targets, kill_delay )
{
	self endon( "death" );
	level endon( "all_targets_killed" );
		
	target_alive = true;
	while ( target_alive )
	{
		killer_target = undefined;
		target_alive = false;
		
		random_target_start = randomint( targets.size );
		for ( i = 0; i < targets.size; i++ )
		{
			target_index = ( i + random_target_start ) % targets.size;
			target = targets[ target_index ];
			if ( IsAlive( target ) )
			{
				// if no target, just choose first guy alive so u have at least one target
				target_alive = true;
				if ( !IsDefined( killer_target ) )
				{
					killer_target = target;
				}
						
				// ... but if u can, look for one that hasn't already been marked by someone else
				if ( !IsDefined( target.marked_for_death ) )
				{
					killer_target = target;
					break;
				}
			}
		}
		
		if ( IsDefined( killer_target ) )
		{
			killer_target.marked_for_death = true;
			self.a.lastShootTime = 0;
			self shoot_guy( killer_target );
			
			if ( IsDefined( kill_delay ) && kill_delay > 0 )
			{
				wait kill_delay;
			}
		}
	}
	
	level notify( "all_targets_killed" );
}

shoot_guy( guy )
{
	if ( isAlive( guy ) )
	{
		/*
		if ( !self CanSee( guy ) )
		{
			IPrintLn( "can't see target!" );
		}
		*/
		
		self.alertlevel = "combat";
		old_accuracy = self.baseaccuracy;
		guy.dontattackme = undefined;
		self unset_shared_field_value( "dontevershoot" );
		self unset_shared_field_value( "ignoreall" );
		self.baseaccuracy = 5000;
 		self.favoriteenemy = guy;
 		guy waittill ("death");
 		self.baseaccuracy = old_accuracy;
 		self.favoriteenemy = undefined;
 		self set_shared_field_value( "ignoreall" );
 		self set_shared_field_value( "dontevershoot" );
	}
}

/*
  Sets a field on an entity but keeps a count of the number of
    sets/unsets so the variable can be shared across functions.
*/
set_shared_field_value( field )
{
	if ( !IsDefined( self.field_count ) )
	{
		self.field_count = [];
	}
	
	if ( !IsDefined( self.field_count[ field ] ) )
	{
		self.field_count[ field ] = 1;
	}
	else
	{
		self.field_count[ field ]++;
	}

	enforce_shared_field_value( field );
}

unset_shared_field_value( field )
{
	if ( !IsDefined( self.field_count ) )
	{
		self.field_count = [];
	}
	
	if ( !IsDefined( self.field_count[ field ] ) )
	{
		self.field_count[ field ] = -1;
	}
	else
	{
		self.field_count[ field ]--;
	}
	
	enforce_shared_field_value( field );
}

/* this is so we can set different fields to what they should be,
     in case other, shared older scripts set the value.
     (I'm looking at you, pain anim script */
enforce_shared_field_value( field )
{
	if ( !IsDefined( self.field_count ) )
	{
		self.field_count = [];
	}
	
	if ( !IsDefined( self.field_count[ field ] ) )
	{
		self.field_count[ field ] = 0;
	}
	
	if ( self.field_count[ field ] > 0 )
	{
		switch ( field )
		{
			case "dontevershoot":
				self.dontEverShoot = true;
				break;
				
			case "ignoreall":
				self.ignoreall = true;
				break;
				
			case "no_pistol_switch":
				self.no_pistol_switch = true;
				break;
				
			case "ignoreme":
			{
				// if "pain" script needs ignoreme, make sure it doesn't turn it off
				if ( IsDefined( self.damageShieldPain ) )
				{
					self.preDamageShieldIgnoreMe = true;
				}
				
				self.ignoreme = true;
			}
			break;
				
			case "TurretFireDisable":
				self TurretFireDisable();
				break;
				
			default:
				AssertEx( false, "unrecognized field value: " + field );
				break;
		}
	}
	else
	{
		switch ( field )
		{
			case "dontevershoot":
				self.dontEverShoot = undefined;
				break;
				
			case "ignoreall":
				self.ignoreall = false;
				break;
				
			case "no_pistol_switch":
				self.no_pistol_switch = undefined;
				break;
				
			case "ignoreme":
			{
				// if "pain" script needs ignoreme, make sure it turns it off when done
				if ( IsDefined( self.damageShieldPain ) )
				{
					self.preDamageShieldIgnoreMe = undefined;
				}
				else
				{
					self.ignoreme = false;
				}
			}
			break;
				
			case "TurretFireDisable":
				self TurretFireEnable();
				break;
			
			default:
				AssertEx( false, "unrecognized field value: " + field );
				break;
		}
	}
}

ally_move_dynamic_speed()
{
	self notify( "start_dynamic_run_speed" );

	self endon( "death" );
	self endon( "stop_dynamic_run_speed" );
	self endon( "start_dynamic_run_speed" );

	if ( self ent_flag_exist( "_stealth_custom_anim" ) )
		self ent_flag_waitopen( "_stealth_custom_anim" );

	self.run_speed_state = "";

	self ally_reset_dynamic_speed();
	
	inches_sq = 12 * 12;
	
	// possible run sets, much match up with ones in ally_dynamic_run_set.
	//   must be ordered from fastest to slowest.
	speed_states = [ "sprint", "run" ];
	
	// distance from player before entering different run states (squared).
	//   the ranges change based on the speed of the player
	//  [0] is distance from player until the ally goes into the run state, 
	//  [1] is when the ally gets far enough to stop a particular run state
	speed_ranges = [];
	speed_ranges[ "player_sprint" ][ "sprint" ][0] = ( 15 * 15 * inches_sq );
	speed_ranges[ "player_sprint" ][ "sprint" ][1] = ( 30 * 30 * inches_sq );
	speed_ranges[ "player_sprint" ][ "run" ][0] = ( 30 * 30 * inches_sq );
	speed_ranges[ "player_sprint" ][ "run" ][1] = ( 30 * 30 * inches_sq );
	
	speed_ranges[ "player_run" ][ "sprint" ][0] = ( 15 * 15 * inches_sq );
	speed_ranges[ "player_run" ][ "sprint" ][1] = ( 20 * 20 * inches_sq );
	speed_ranges[ "player_run" ][ "run" ][0] = ( 20 * 20 * inches_sq );
	speed_ranges[ "player_run" ][ "run" ][1] = ( 25 * 25 * inches_sq );
	
	speed_ranges[ "player_crouch" ][ "run" ][0] = ( 2 * 2 * inches_sq );
	speed_ranges[ "player_crouch" ][ "run" ][1] = ( 10 * 10 * inches_sq );

	// approximate player max speeds, at 100%
	// crouch speed ~ 123
	// run speed ~ 189
	// sprint speed ~ 283

	max_player_crouch_speed = 123;
	max_player_run_speed = 189;
	max_player_sprint_speed = 283;

	while ( 1 )
	{
		wait .2;
		
		if ( IsDefined( self.force_run_speed_state ) )
		{
			ally_dynamic_run_set( self.force_run_speed_state );
			continue;
		}

		look_vector = VectorNormalize( AnglesToForward( self.angles ) );
		player_to_self = VectorNormalize( ( self.origin - level.player.origin ) );
		look_dot = VectorDot( look_vector, player_to_self );

		//how far is the player
		dist2rd = DistanceSquared( self.origin, level.player.origin );

		if ( IsDefined( self.cqbwalking ) && self.cqbwalking )
			self.moveplaybackrate = 1;

		// normal running around if you're spotted
		if ( flag_exist( "_stealth_spotted" ) && flag( "_stealth_spotted" ) )
		{
			ally_dynamic_run_set( "run" );
			continue;
		}
		
		// ~15 degrees
		if ( look_dot < -0.25 && dist2rd > ( 15 * 15 * inches_sq ) )
		{
			ally_dynamic_run_set( "sprint" );
			continue;
		}
		
		/*
		player_velocity = level.player GetVelocity();
		player_speed = Length( player_velocity );
		
		player_speed_state = "";
		if ( player_speed < max_player_crouch_speed )
		{
			player_speed_state = "player_crouch";
		}
		else if ( player_speed < max_player_run_speed )
		{
			player_speed_state = "player_run";
		}
		else
		{
			player_speed_state = "player_sprint";
		}
		
		speed_range = speed_ranges[ player_speed_state ];
		
		speed_set = false;
		foreach ( speed_state in speed_states )
		{
			if ( IsDefined( speed_range[ speed_state ] ) )
			{
				if ( ( dist2rd < speed_range[ speed_state ][0] ) ||
					 ( self.run_speed_state == speed_state && dist2rd < speed_range[ speed_state ][1] ) )
				{
					ally_dynamic_run_set( speed_state );
					speed_set = true;
					break;
				}
			}
		}
		
		if ( speed_set )
		{
			continue;
		}
		*/

		// otherwise cqb
		ally_dynamic_run_set( "cqb" );
	}
}

ally_stop_dynamic_speed()
{
	self endon( "death" );
	
	self notify( "stop_dynamic_run_speed" );
	ally_reset_dynamic_speed();
}

ally_reset_dynamic_speed()
{
	self endon( "death" );

	self disable_cqbwalk();
	self.moveplaybackrate = 1;
	self clear_run_anim();
	self notify( "stop_loop" );
}

ally_dynamic_run_set( speed )
{
	if ( self.run_speed_state == speed )
		return;

	self.run_speed_state = speed;

	switch( speed )
	{
		case "sprint":
			if ( IsDefined( self.cqbwalking ) && self.cqbwalking )
				self.moveplaybackrate = 1;
			else
				self.moveplaybackrate = 1.15;
			self set_generic_run_anim( "DRS_sprint" );
			self disable_cqbwalk();
			self notify( "stop_loop" );
			break;
		case "run":
			self.moveplaybackrate = 1;
			self clear_run_anim();
			self disable_cqbwalk();
			self notify( "stop_loop" );
			break;
		case "jog":
			self.moveplaybackrate = 1;
			self set_generic_run_anim( "DRS_combat_jog" );
			self disable_cqbwalk();
			self notify( "stop_loop" );
			break;
		case "cqb":
			self.moveplaybackrate = 1;
			self enable_cqbwalk();
			self notify( "stop_loop" );
			break;
	}
}

check_anim_reached( guy, anime, tag, animname_override )
{
	if ( IsArray( guy ) )
	{
		anim_reached = true;
		foreach( solo_guy in guy )
		{
			anim_reached = anim_reached && self check_anim_reached_solo( solo_guy, anime, tag, animname_override );
		}
		
		return anim_reached;
	}
	else
	{
		return self check_anim_reached_solo( guy, anime, tag, animname_override );
	}
}

check_anim_reached_solo( guy, anime, tag, animname_override )
{
	pos = get_anim_position( tag );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];
	
	if ( IsDefined( animname_override ) )
		animname = animname_override;
	else
		animname = guy.animname;

	if ( IsDefined( level.scr_anim[ animname ][ anime ] ) )
	{
		if ( IsArray( level.scr_anim[ animname ][ anime ] ) )
			startorg = GetStartOrigin( org, angles, level.scr_anim[ animname ][ anime ][ 0 ] );
		else
			startorg = GetStartOrigin( org, angles, level.scr_anim[ animname ][ anime ] );
	}
	else
	{
		startorg = org;
	}
	
	within_distance = 4.5 * 12;
	distance_delta = DistanceSquared( guy.origin, startorg );
	if ( distance_delta > ( within_distance * within_distance ) )
	{
		return false;
	}
		
	return true;
}

disable_awareness()
{
	self.ignoreall = true;
	self.dontmelee = true;
	//self.ignoreSuppression = true;
	assert(!isdefined(self.suppressionwait_old));
	self.suppressionwait_old = self.suppressionwait;
	self.suppressionwait = 0;
	self disable_surprise();
	self.IgnoreRandomBulletDamage = true;
	self disable_bulletwhizbyreaction();
	self disable_pain();
	self disable_danger_react();
	self.grenadeawareness = 0;
	self.ignoreme = 1;
	self enable_dontevershoot();
	self.disableFriendlyFireReaction = true;
}

has_awareness()
{
	return self.awareness;
}

enable_awareness()
{
	self.ignoreall = false;
	self.dontmelee = undefined;
	//self.ignoreSuppression = false;
	assert(isdefined(self.suppressionwait_old));
	self.suppressionwait = self.suppressionwait_old;
	self.suppressionwait_old = undefined;
	self enable_surprise();
	self.IgnoreRandomBulletDamage = false;
	self enable_bulletwhizbyreaction();
	self enable_pain();
	self.grenadeawareness = 1;
	self.ignoreme = 0;
	self disable_dontevershoot();
	self.disableFriendlyFireReaction = undefined;
}

get_driver()
{
	foreach ( guy in self.riders )
	{
		if ( guy.vehicle_position == 0 )
		{
			return guy;
		}
	}
	
	return undefined;
}

safe_force_use_weapon( weapon_name, weapon_slot )
{
	player_distance = Distance( level.player.origin, self.origin );
	
	// have to wait until not using a sidearm,
	//   else lastweapon will be the sidearm and causes problems later
	while ( self animscripts\utility::usingSidearm() ||
			( player_distance < 1024 && 
			  within_fov( level.player.origin, level.player getplayerangles(), self.origin, level.cosine[ "45" ] ) ) )
	{
		wait 0.5;
	}
	
	self thread forceUseWeapon( weapon_name, weapon_slot );
}

manage_bullet_penetrate_triggers()
{
	triggers = GetEntArray( "trigger_bullet_penetrate", "targetname" );
	if ( IsDefined( triggers ) )
	{
		foreach ( trigger in triggers )
		{
			trigger thread handle_bullet_penetrate_trigger();
		}
	}
}

handle_bullet_penetrate_trigger()
{
	start_dir = GetStruct( self.target, "targetname" );
	end_dir = GetStruct( start_dir.target, "targetname" );
	
	trigger_dir = end_dir.origin - start_dir.origin;
	trigger_width = Length( trigger_dir );
	trigger_normal = VectorNormalize( trigger_dir );
	
	while ( true )
	{
		// argh! position is origin.
		self waittill( "damage", amount, attacker, direction, position, mod_type );
		if ( mod_type == "MOD_PISTOL_BULLET" || mod_type == "MOD_RIFLE_BULLET" )
		{
			if ( !IsDefined( attacker ) )
				continue;
			
			shoot_pos = attacker GetEye();
			trigger_side = VectorDot( direction, trigger_normal );
			
			// figure out where bullet hits trigger plane (use eye position as bullet pos),
			//   and where it would hit the other side of the trigger as well.
			end_pos = undefined;
			new_bullet_pos = undefined;
			if ( trigger_side > 0 )
			{
				end_pos = line_and_plane_intersection( start_dir.origin, trigger_normal, shoot_pos, direction );
				if ( IsDefined( end_pos ) )
				{
					new_bullet_pos = line_and_plane_intersection( end_dir.origin, trigger_normal, end_pos, direction );
				}
			}
			else
			{
				trigger_normal_dir = trigger_normal * -1;
				
				end_pos = line_and_plane_intersection( end_dir.origin, trigger_normal_dir, shoot_pos, direction );
				if ( IsDefined( end_pos ) )
				{
					new_bullet_pos = line_and_plane_intersection( start_dir.origin, trigger_normal_dir, end_pos, direction );
				}
			}
			
			if ( IsDefined( new_bullet_pos ) )
			{
				new_end_pos = new_bullet_pos + ( direction * 1024 );
				
				/*
				line( shoot_pos, end_pos, (0,0,1), 1, false, 20 );
				line( end_pos, new_bullet_pos, (1,0,0), 1, false, 20 );
				line( new_bullet_pos, new_end_pos, (0,1,0), 1, false, 20 );
				*/
				
				bullet_owner = undefined;
				bullet_weapon = "ak47";
				if ( attacker == level.player )
				{
					bullet_owner = level.player;
				}
					
				if ( IsDefined( attacker.weapon ) )
				{
					bullet_weapon = attacker.weapon;
				}
				
				if ( IsDefined( bullet_owner ) )
				{
					MagicBullet( bullet_weapon, new_bullet_pos, new_end_pos, bullet_owner );
				}
				else
				{
					MagicBullet( bullet_weapon, new_bullet_pos, new_end_pos );
				}
			}
		}
	}
}

line_and_plane_intersection( plane_point, plane_normal, line_point, line_dir )
{
	to_plane_point = plane_point - line_point;
	to_plane_dot = VectorDot( to_plane_point, plane_normal );
	line_dot = VectorDot( line_dir, plane_normal );
	
	if ( line_dot != 0 )
	{
		line_ratio = to_plane_dot / line_dot;
		plane_intersect = line_point + ( line_dir * line_ratio );
		return plane_intersect;
	}
	
	return undefined;
}

bloody_death( delay )
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
	tags[0] = "j_head";

	
	self thread bloody_death_fx( tags[0], undefined );
	self DoDamage( self.health + 50, self.origin );
}

bloody_death_fx( tag, fxName )
{
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["bodyshot"];
	}

	PlayFxOnTag( fxName, self, tag );
}

dialog_prime( msg )
{
	assert( isdefined(self.animname) && isdefined( level.scr_sound[self.animname][msg] ) );
	alias = level.scr_sound[self.animname][msg];
	self aud_prime_stream( alias );
}

dialog_is_primed( msg )
{
	assert( isdefined(self.animname) && isdefined( level.scr_sound[self.animname][msg] ) );
	alias = level.scr_sound[self.animname][msg];
	return aud_is_stream_primed( alias );
}

// set a the in_flag to be true while player is in a trigger with trigger_targetname.
//   supports multiple, overlapping triggers
manage_overlapping_flag_trigger( trigger_targetname, in_flag, end_msg )
{
	level endon( end_msg );
	
	if ( !IsDefined( level.flag_trigger_count ) )
	{
		level.flag_trigger_count = [];
	}
	
	flag_trigger_index = level.flag_trigger_count.size;
	level.flag_trigger_count[ flag_trigger_index ] = 0;
	
	in_flag_triggers = GetEntArray( trigger_targetname, "targetname" );
	foreach ( flag_trigger in in_flag_triggers )
	{
		flag_trigger thread monitor_flag_trigger( flag_trigger_index, end_msg );
	}
	
	while ( true )
	{
		// wait for count notify
		level waittill( "flag_trigger_count_update", flag_trigger_index );
		// wait until all the triggers have run
		waittillframeend;
		if ( level.flag_trigger_count[ flag_trigger_index ] > 0 )
		{
			flag_set( in_flag );
		}
		else
		{
			flag_clear( in_flag );
		}
	}
}

monitor_flag_trigger( flag_trigger_index, end_msg )
{
	level endon( end_msg );

	while ( true )
	{
		self waittill( "trigger" );
		level.flag_trigger_count[ flag_trigger_index ]++;
		level notify( "flag_trigger_count_update", flag_trigger_index );
		while ( level.player IsTouching( self ) )
		{
			wait 0.1;
		}
		
		level.flag_trigger_count[ flag_trigger_index ]--;
		level notify( "flag_trigger_count_update", flag_trigger_index );
	}
}

fall_rumble()
{
	time = 0.25;
	counter = 0;
	while( counter < time )
	{
		level.player PlayRumbleOnEntity( "falling_land" );
		wait( 0.05 );
		counter += 0.05;
	}
	StopAllRumbles();
}
