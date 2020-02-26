#include maps\mp\_utility;
#include common_scripts\utility;

#define CLAW_Z_DIST			318
#define CRATE_Z_DIST		181
#define ARM_Y_DIST			15
#define ARM_Z_DIST			33

init()
{
	PrecacheModel( "p6_dockside_container_lrg_white" );

	crane_dvar_init();

	level.crate_models = [];
	level.crate_models[0] = "p6_dockside_container_lrg_red";
	level.crate_models[1] = "p6_dockside_container_lrg_blue";
	level.crate_models[2] = "p6_dockside_container_lrg_white";
	level.crate_models[3] = "p6_dockside_container_lrg_orange";
	
		
	claw = GetEnt( "claw_base", "targetname" );
	claw.z_upper = claw.origin[2];
	claw thread sound_wires_move();

	arms_y = GetEntArray( "claw_arm_y", "targetname" );
	arms_z = GetEntArray( "claw_arm_z", "targetname" );

	claw.arms = ArrayCombine( arms_y, arms_z, true, false );

	foreach( arm_z in arms_z )
	{
		arm_y = GetClosest( arm_z.origin, arms_y );
		arm_z.parent = arm_y;
		//arm_z.origin = ( arm_z.origin[0], arm_z.origin[1], arm_z.origin[2] + ARM_Z_START_OFFSET );
	}

	foreach( arm_y in arms_y )
	{
		arm_y.parent = claw;
	}

	claw claw_link_arms( "claw_arm_y" );
	claw claw_link_arms( "claw_arm_z" );
	//claw.origin = ( claw.origin[0], claw.origin[1], claw.z_upper );

	crates = GetEntArray( "crate", "targetname" );
	//Eckert - Plays the crates raise/lower out of ground, plays off wrong crate currently
	array_thread(crates, ::sound_pit_move);
	crate_data = [];

	for ( i = 0; i < crates.size; i++ )
	{
		crates[i] DisconnectPaths();

		
		data = SpawnStruct();
		data.origin = crates[i].origin;
		data.angles = crates[i].angles;

		crate_data[i] = data;
	}

	rail = GetEnt( "crane_rail", "targetname" );
	rail thread sound_ring_move();
	rail.roller = GetEnt( "crane_roller", "targetname" );
	rail.roller.wheel = GetEnt( "crane_wheel", "targetname" );

	claw.wires = GetEntArray( "crane_wire", "targetname" );
	claw.z_wire_max = rail.roller.wheel.origin[2] - 50;

	foreach( wire in claw.wires )
	{
		wire LinkTo( claw );

		if ( wire.origin[2] > claw.z_wire_max )
		{
			wire Ghost();
		}
	}

	placements = GetEntArray( "crate_placement", "targetname" );

	foreach( placement in placements )
	{
		placement.angles = placement.angles + ( 0, 90, 0 );
		crates[ crates.size ] = Spawn( "script_model", placement.origin );
	}

	triggers = GetEntArray( "crate_kill_trigger", "targetname" );

	foreach( crate in crates )
	{
		crate.kill_trigger = GetClosest( crate.origin, triggers );
		crate.kill_trigger.origin = crate.origin - ( 0, 0, 5 );
		crate.kill_trigger EnableLinkTo();
		crate.kill_trigger LinkTo( crate );
	}

	placements = array_randomize( placements );

	level thread crane_think( claw, rail, crates, crate_data, placements );
}

crane_dvar_init()
{
	set_dvar_float_if_unset( "scr_crane_claw_move_time",		"5" );
	set_dvar_float_if_unset( "scr_crane_crate_lower_time",		"5" );
	set_dvar_float_if_unset( "scr_crane_crate_raise_time",		"5" );
	set_dvar_float_if_unset( "scr_crane_arm_y_move_time",		"3" );
	set_dvar_float_if_unset( "scr_crane_arm_z_move_time",		"3" );
	set_dvar_float_if_unset( "scr_crane_claw_drop_speed", 		"25" );
	set_dvar_float_if_unset( "scr_crane_claw_drop_time_min",	"5" );
}

wire_render()
{
	self endon( "movedone" );

	for ( ;; )
	{
		wait( 0.05 );

		foreach( wire in self.wires )
		{
			if ( wire.origin[2] > self.z_wire_max )
			{
				wire Ghost();
			}
			else
			{
				wire Show();
			}
		}
	}
}

crane_think( claw, rail, crates, crate_data, placements )
{
	wait( 1 );
	claw arms_open();
		
	for ( ;; )
	{
		for ( i = 0; i < ( crates.size - placements.size ); i++ )
		{
			crate = GetClosest( crate_data[i].origin, crates );
			rail crane_move( claw, crate_data[i], -CLAW_Z_DIST );
			//iprintlnbold ( "wires lowering" );
			level notify ( "wires_move" );

			claw claw_crate_grab( crate, CLAW_Z_DIST );
			lower = true;

			target = ( i + 1 ) % ( crates.size - placements.size );
			target_crate = GetClosest( crate_data[target].origin, crates );

			if ( cointoss() )
			{
				for ( placement_index = 0; placement_index < placements.size; placement_index++ )
				{
					placement = placements[ placement_index ];

					if ( !IsDefined( placement.crate ) )
					{
						lower = false;
						break;
					}
				}
			}

			if ( !lower )
			{
				z_dist = crate.origin[2] - placement.origin[2] - ARM_Z_DIST;
				rail crane_move( claw, placement, -z_dist );
				//iprintlnbold ( "NEW wires_lowering" );
				level notify ( "wires_move" );
				placement.crate = crate;
			}
			else
			{
				rail crane_move( claw, crate_data[target], -CRATE_Z_DIST );
				//iprintlnbold ( "wires_lowering" );
				level notify ( "wires_move" );
			
			}

			claw claw_crate_move( crate );

			if ( lower )
			{
				crate crate_lower( target_crate, crate_data[target] );
			}
			
			crate = target_crate;

			target = ( i + 2 ) % ( crates.size - placements.size );
			target_crate = GetClosest( crate_data[target].origin, crates );

			
			if ( !lower )
			{
				crate = crates[ 3 + placement_index ];
				crate.origin = target_crate.origin - ( 0, 0, 137 );
				crate.angles = target_crate.angles;
				wait( 0.25 );
				claw waittill( "movedone" );
			}

			crate crate_raise( target_crate, crate_data[target] );
			rail crane_move( claw, crate_data[target], -CRATE_Z_DIST );
			//iprintlnbold ( "wires_lowering" );
			level notify ( "wires_move" );

			claw claw_crate_grab( target_crate, CRATE_Z_DIST );
			
			crate = target_crate;

			target = ( i + 3 ) % ( crates.size - placements.size );
			rail crane_move( claw, crate_data[target], -CLAW_Z_DIST );
			//iprintlnbold ( "wires_lowering" );
			level notify ( "wires_move" );
			
			claw claw_crate_drop( crate, crate_data[target] );
		}
	}
}


crane_move( claw, desired, z_dist )
{
	self.roller	LinkTo( self );
	self.roller.wheel LinkTo( self.roller );
	claw LinkTo( self.roller.wheel );

	goal = ( desired.origin[0], desired.origin[1], self.origin[2] );

	dir = VectorNormalize( goal - self.origin );
	angles = VectorToAngles( dir );
	angles = ( self.angles[0], angles[1] + 90, self.angles[2] );

	yawDiff = AbsAngleClamp360( self.angles[1] - angles[1] );

	time = yawDiff / 25;

	self RotateTo( angles, time, time * .35, time * .45 );
	//self thread sound_ring_move();
	//iprintlnbold ( "ring rotate" );
	level notify ( "wires_stop" );
	level notify ( "ring_move");
	self waittill( "rotatedone" );

	self.roller UnLink();

	goal = ( desired.origin[0], desired.origin[1], self.roller.origin[2] );

	diff = Distance2D( goal, self.roller.origin );

	speed = GetDvarFloat( "scr_crane_claw_drop_speed" );
	time = diff / speed;

	if ( time < GetDvarFloat( "scr_crane_claw_drop_time_min" ) )
	{
		time = GetDvarFloat( "scr_crane_claw_drop_time_min" );
	}

	self.roller MoveTo( goal, time, time * .25, time * .25 );
	//iprintlnbold ( "roller strafing" );

	goal = ( desired.origin[0], desired.origin[1], self.roller.wheel.origin[2] );

	self.roller.wheel UnLink();
	self.roller.wheel MoveTo( goal, time, time * .25, time * .25 );	
	//iprintlnbold ( "roller strafing" );
	self.roller.wheel RotateTo( desired.angles + ( 0, 90, 0 ), time, time * .25, time * .25 );
//	self.roller.wheel waittill( "rotatedone" );

	claw.z_initial = claw.origin[2];
	claw UnLink();

	claw RotateTo( desired.angles, time, time * .25, time * .25 );

	claw.goal = ( goal[0], goal[1], claw.origin[2] + z_dist );
	claw.time = time;
	claw MoveTo( claw.goal, time, time * .25, time * .25 );
	//iprintlnbold ( "ring stop" );
	level notify ( "ring_stop");
}

claw_crate_grab( crate, z_dist )
{
	self thread wire_render();
	//iprintlnbold ( "MISSING ARM" );
	self waittill ( "movedone" );
	//iprintlnbold ( "crane down move done" );
	level notify ( "wires_stop" );
	self playsound ( "amb_crane_arms_b" );
	self claw_z_arms( -ARM_Z_DIST );
	//iprintlnbold ( "arms_closing" );
	self playsound ( "amb_crane_arms" );
	self arms_close( crate );
	//iprintlnbold ( "arms closed" );
	
	crate MoveZ( ARM_Z_DIST, GetDvarFloat( "scr_crane_arm_z_move_time" ) );
	self claw_z_arms( ARM_Z_DIST );
	crate LinkTo( self );
	self MoveZ( z_dist, GetDvarFloat( "scr_crane_claw_move_time" ) );
	//iprintlnbold ( "crate raising" );
	self thread wire_render();
	//iprintlnbold ( "crate grabbed" );
	level notify ( "wires_move" );
	
	self waittill( "movedone" );
	//iprintlnbold ( "crane up move done" );
	self playsound ( "amb_crane_arms" );
}

sound_wires_move()
{
	while (1)
	{
		level waittill ( "wires_move");
		self playsound ( "amb_crane_wire_start" );
		self playloopsound ( "amb_crane_wire_lp" );
		level waittill( "wires_stop" );
		self playsound( "amb_crane_wire_end");
		wait (.1);
		self stoploopsound (.2);
	}
}


sound_ring_move()
{
	while (1)
	{
		level waittill ( "ring_move");
		self playsound ( "amb_crane_ring_start" );
		self playloopsound ( "amb_crane_ring_lp" );
		level waittill( "ring_stop" );
		self playsound( "amb_crane_ring_end");
		wait (.1);
		self stoploopsound (.2);
	}
}

sound_pit_move()
{
	while (1)
	{
		level waittill ( "pit_move");
		self playsound ( "amb_crane_pit_start" );
		self playloopsound ( "amb_crane_pit_lp" );
		level waittill( "pit_stop" );
		self playsound( "amb_crane_pit_end");
		self stoploopsound (.2);
		wait (.2);
	}
}	
	

claw_crate_move( crate, claw )
{
	self thread wire_render();
	self waittill ( "movedone" );
	crate UnLink();
	//iprintlnbold ( "crate drop" );
	self playsound ("amb_crane_arms_b");
	level notify ( "wires_stop" );

	crate MoveZ( -ARM_Z_DIST, GetDvarFloat( "scr_crane_arm_z_move_time" ) );
	self claw_z_arms( -ARM_Z_DIST );
	self playsound ("amb_crane_arms_b");	
	PlayFXOnTag( level._effect["crane_dust"], crate, "tag_origin" );
	//iprintlnbold ( "V-DROPPED" );
	crate playsound ( "amb_crate_drop" );
	self arms_open();
	//iprintlnbold ( "GRAB-arm_opening" );
	level notify ( "wires_move" );
	self claw_z_arms( ARM_Z_DIST );


	z_dist = self.z_initial - self.origin[2];

	self MoveZ( z_dist, GetDvarFloat( "scr_crane_claw_move_time" ) );
	//iprintlnbold ( "GRAB-arm_opened" );
	self thread wire_render();
	//self waittill ( "movedone" );
}

claw_crate_drop( target, data )
{
	target thread crate_drop_think( self );
	self thread wire_render();
	//level notify ( "wires_stop" );
	self waittill ( "claw_movedone" );

	target UnLink();
	level notify ( "wires_stop" );
	self playsound ("amb_crane_arms_b");
	target MoveZ( -ARM_Z_DIST, GetDvarFloat( "scr_crane_arm_z_move_time" ) );
	self claw_z_arms( -ARM_Z_DIST );
	//iprintlnbold ( "Dropping_crate" );
	PlayFXOnTag( level._effect["crane_dust"], target, "tag_origin" );
	self playsound ( "amb_crate_drop" );

	target notify( "claw_done" );
	self playsound ("amb_crane_arms");
	self arms_open();
	//iprintlnbold ( "GRAB-arm_opening" );
	level notify ( "wires_move" );
	target.origin = data.origin;
	
	self claw_z_arms( ARM_Z_DIST );
	self playsound ("amb_crane_arms");
	self MoveZ( CLAW_Z_DIST, GetDvarFloat( "scr_crane_claw_move_time" ) );
	self thread wire_render();
	self waittill ( "movedone" );
}

crate_lower( lower, data )
{
	z_dist = Abs( self.origin[2] - lower.origin[2] );
	
	self MoveZ( -z_dist, GetDvarFloat( "scr_crane_crate_lower_time" ) );
	//self thread sound_pit_move();
	lower MoveZ( -z_dist, GetDvarFloat( "scr_crane_crate_lower_time" ) );
	//iprintlnbold ( "pit lower" );
	level notify ( "pit_move");
	lower waittill( "movedone" );
	//iprintlnbold ( "pit lowered" );
	level notify ( "pit_stop");
	lower Ghost();
	
	self.origin = data.origin; 
	wait( 0.25 );
}

crate_raise( upper, data )
{
	self crate_set_random_model( upper );

	self.origin = ( data.origin[0], data.origin[1], self.origin[2] ); 
	self.angles = data.angles;
	wait( 0.2 );

	self Show();
		
	z_dist = Abs( upper.origin[2] - self.origin[2] );

	self MoveZ( z_dist, GetDvarFloat( "scr_crane_crate_raise_time" ) );
	//self thread sound_pit_move();
	upper MoveZ( z_dist, GetDvarFloat( "scr_crane_crate_raise_time" ) );
	//iprintlnbold ( "pit raise" );
	level notify ( "wires_stop" );
	level notify ( "pit_move");
	upper thread raise_think();
	//upper waittill( "movedone" );
	//iprintlnbold ( "pit raised" );
	//level notify ( "pit_stop");
	//self.origin = data.origin; 
}

raise_think()
{
	self waittill( "movedone" );
	level notify ( "pit_stop");
}

crate_set_random_model( other )
{
	models = array_randomize( level.crate_models );
	
	foreach( model in models )
	{
		if ( model == other.model )
		{
			continue;
		}

		self SetModel( model );
		return;
	}
}

arms_open()
{
	self claw_move_arms( -ARM_Y_DIST );
	self playsound ( "amb_crane_arms");
	//iprintlnbold ( "GEN - Arms open" );
}

arms_close( crate )
{
	self claw_move_arms( ARM_Y_DIST, crate );
	//iprintlnbold ( "GEN - Arms close" );
	self playsound ( "amb_crane_arms");
}

claw_link_arms( name )
{
	foreach( arm in self.arms )
	{
		if ( arm.targetname == name )
		{
			arm LinkTo( arm.parent );
		}
	}
}

claw_unlink_arms( name )
{
	foreach( arm in self.arms )
	{
		if ( arm.targetname == name )
		{
			arm UnLink();
		}
	}
}

claw_move_arms( dist, crate )
{
	claw_unlink_arms( "claw_arm_y" );
	arms = [];

	foreach( arm in self.arms )
	{
		if ( arm.targetname == "claw_arm_y" )
		{
			arms[ arms.size ] = arm;

			forward = AnglesToForward( arm.angles );
			arm.goal = arm.origin + VectorScale( forward, dist );

			arm MoveTo( arm.goal, GetDvarFloat( "scr_crane_arm_y_move_time" ) );
		}
	}

	if ( dist > 0 )
	{
		wait( GetDvarFloat( "scr_crane_arm_y_move_time" ) / 2 );

		foreach( arm in self.arms )
		{
			if ( arm.targetname == "claw_arm_y" )
			{
				arm MoveTo( arm.goal, 0.1 );
				//iprintlnbold ( "im am missing" );
				self playsound ("amb_crane_arms_b");
			}
		}

		wait( 0.05 );
		PlayFXOnTag( level._effect["crane_spark"], crate, "tag_origin" );
		self playsound ("amb_arms_latch");
	}

	assert( arms.size == 4 );
	waittill_multiple_ents( arms[0], "movedone", arms[1], "movedone", arms[2], "movedone", arms[3], "movedone" );

	self claw_link_arms( "claw_arm_y" );
}

claw_z_arms( z )
{
	claw_unlink_arms( "claw_arm_z" );
	arms = [];

	foreach( arm in self.arms )
	{
		if ( arm.targetname == "claw_arm_z" )
		{
			arms[ arms.size ] = arm;
			arm MoveZ( z, GetDvarFloat( "scr_crane_arm_z_move_time" ) );
		}
	}

	assert( arms.size == 4 );
	waittill_multiple_ents( arms[0], "movedone", arms[1], "movedone", arms[2], "movedone", arms[3], "movedone" );

	self claw_link_arms( "claw_arm_z" );
}

crate_drop_think( claw )
{
	self endon( "claw_done" );

	self.kill_trigger thread kill_trigger_think( self, claw );
	claw thread claw_drop_think();

	for ( ;; )
	{
		wait( 0.2 );

		self destroy_tactical_insertions();
		self destroy_equipment();
		self destroy_supply_crates();
		self destroy_corpses();
		self destroy_dogs();
		self destroy_turrets();
		self destroy_tanks();
		self destroy_rccars();
		self destroy_qrdrones();
	}
}

claw_drop_think()
{
	self endon( "claw_pause" );

	self waittill( "movedone" );
	self notify( "claw_movedone" );
}

claw_drop_pause()
{
	self notify( "claw_pause" );
	self endon( "claw_pause" );

	z_diff = Abs( self.goal[2] - self.origin[2] );
	frac = ( z_diff / CLAW_Z_DIST );

	time = self.time * frac;

	if ( time <= 0 )
	{
		// claw is already at it's goal
		return;
	}
	
	self MoveTo( self.origin, 0.01 );

	wait( 3 );

	self thread claw_drop_think();
	self MoveTo( self.goal, time );
}

kill_trigger_think( crate, claw )
{
	crate endon( "claw_done" );

	for ( ;; )
	{
		self waittill( "trigger", entity );

		if( IsPlayer( entity ) && IsAlive( entity ) )
		{
			claw thread claw_drop_pause();
		}

		entity DoDamage( entity.health * 2, self.origin + ( 0, 0, 1 ), crate, crate, 0, "MOD_CRUSH" );
	}
}

destroy_dogs()
{
	dogs = maps\mp\killstreaks\_dogs::dog_manager_get_dogs();

	foreach( dog in dogs )
	{
		if ( dog IsTouching( self.kill_trigger ) )
		{
			self.kill_trigger notify( "trigger", dog );
		}
	}
}

destroy_turrets()
{
	turrets = GetEntArray( "auto_turret", "classname" );

	foreach( turret in turrets )
	{
		if ( turret IsTouching( self.kill_trigger ) )
		{
			self.kill_trigger notify( "trigger", turret );
		}
	}
}

destroy_equipment()
{
	grenades = GetEntArray( "grenade", "classname" );

	for( i = 0; i < grenades.size; i++ )
	{
		item = grenades[i];

		if( !IsDefined( item.name ) )
		{
			continue;
		}

		if( !IsDefined( item.owner ) )
		{
			continue;
		}

		if( !IsWeaponEquipment( item.name ) )
		{
			continue;
		}

		if( !item IsTouching( self.kill_trigger ) ) 
		{
			continue;
		}

		watcher = item.owner getWatcherForWeapon( item.name );

		if( !IsDefined( watcher ) )
		{
			continue;
		}

		watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate( item, 0.0, undefined );
	}
}

destroy_tactical_insertions()
{
	players = GET_PLAYERS();

	foreach( player in players )
	{
		if ( !IsDefined( player.tacticalInsertion ) )
		{
			continue;
		}

		if ( player.tacticalInsertion IsTouching( self.kill_trigger ) )
		{
			player.tacticalInsertion maps\mp\_tacticalinsertion::destroy_tactical_insertion();
		}
	}
}

destroy_supply_crates()
{
	crates = GetEntArray( "care_package", "script_noteworthy" );

	foreach( crate in crates )
	{
		if( crate IsTouching( self.kill_trigger ) ) 
		{
			PlayFX( level._supply_drop_explosion_fx, crate.origin );
			PlaySoundAtPosition( "wpn_grenade_explode", crate.origin );
			wait ( 0.1 );
			crate maps\mp\killstreaks\_supplydrop::crateDelete();
		}
	}
}

destroy_tanks()
{
	tanks = GetEntArray( "talon", "targetname" );

	foreach( tank in tanks )
	{
		if ( tank IsTouching( self.kill_trigger ) )
		{
			tank notify( "death" );
		}
	}
}

destroy_rccars()
{
	cars = GetEntArray( "rcbomb", "targetname" );

	foreach( car in cars )
	{
		if ( car IsTouching( self.kill_trigger ) )
		{
			car maps\mp\killstreaks\_rcbomb::rcbomb_force_explode(); 
		}
	}
}

destroy_qrdrones()
{
	ents = GetEntArray( "script_vehicle", "classname" );

	foreach( ent in ents )
	{
		if ( IsDefined( ent.helitype ) && ent.helitype == "qrdrone" )
		{
			if ( ent IsTouching( self.kill_trigger ) )
			{
				watcher = ent.owner maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "qrdrone" );
				watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate( ent, 0.0, undefined );
			}
		}
	}
}

destroy_corpses()
{
	corpses = GetCorpseArray();
	origin1 = self GetPointInBounds( 0.5, 0.0, -1.0 );
	origin2 = self GetPointInBounds( 0.5, 1.0, -1.0 );
	origin3 = self GetPointInBounds( 0.5, -1.0, -1.0 );

	for ( i = 0; i < corpses.size; i++ )
	{
		if( corpses[i] IsTouching( self.kill_trigger ) ) 
		{
			corpses[i] delete();
		}
		else if ( DistanceSquared( corpses[i].origin, origin1 ) < 64 * 64 )
		{
			corpses[i] delete();
		}
		else if ( DistanceSquared( corpses[i].origin, origin2 ) < 64 * 64 )
		{
			corpses[i] delete();
		}
		else if ( DistanceSquared( corpses[i].origin, origin3 ) < 64 * 64 )
		{
			corpses[i] delete();
		}
	}
}

getWatcherForWeapon( weapname )
{
	if ( !IsDefined( self ) )
	{
		return undefined;
	}

	if ( !IsPlayer( self ) )
	{
		return undefined;
	}

	for ( i = 0; i < self.weaponObjectWatcherArray.size; i++ )
	{
		if ( self.weaponObjectWatcherArray[i].weapon != weapname )
		{ 
			continue;
		}

		return ( self.weaponObjectWatcherArray[i] );
	}

	return undefined;
}