#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include animscripts\hummer_turret\common;

turret_guy_in_near_humvee()
{
	wait( 0.2 );// let _vehicle stuff put him on the turret

	vehicle = self.ridingVehicle;
	angles = vehicle.angles;
	angles = ( 0, angles[ 1 ], 0 );
	forward = AnglesToForward( angles );

	ent = spawn_tag_origin();
	ent.origin = vehicle.origin + forward * 250 + ( 0, 0, 120 );
	ent LinkTo( vehicle );
	self.ignoreall = true;

	turret = self GetTurret();
	turret SetMode( "manual" );
	turret SetTargetEntity( ent );

	/*
	for ( ;; )
	{
		Line( ent.origin, self.origin );
		wait( 0.05 );
	}
	*/
}

aim_ahead_until_you_get_enemy()
{
	self endon( "death" );

	for ( ;; )
	{
		if ( IsDefined( self.ridingVehicle ) )
			break;
		wait( 0.05 );
	}


	vehicle = self.ridingVehicle;
	
	// this guy aims at other targets
	if ( vehicle.script_index == 0 )
		vehicle.target_override = "turret_aim_target_first";
		
	angles = vehicle.angles;
	angles = ( 0, angles[ 1 ], 0 );
	forward = AnglesToForward( angles );

	ent = spawn_tag_origin();
	ent.origin = vehicle.origin + forward * 250 + ( 0, 0, 120 );
	ent LinkTo( vehicle );

	turret = undefined;
	for ( ;; )
	{
		turret = self GetTurret();
		if ( IsDefined( turret ) )
			break;
		if ( !isdefined( self.ridingvehicle ) )
			return;
		wait( 0.05 );
	}

	turret SetMode( "manual" );
	turret SetTargetEntity( ent );

	oldmaxsight = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 0;
	turret.dontshoot = true;

	turret thread gunner_aims_at_targets( ent, self.ridingVehicle );
	
//	flag_wait( "shot_rings_out" );
	
	//flag_wait( "ambush_spawner_angry" );
	/*
	for ( ;; )
	{
		if ( IsAlive( self.enemy ) )
			break;
		wait( 0.05 );
	}
	wait( 2 );
	*/
	flag_wait( "humvees_spin_up" );
	wait( randomfloat( 1.5 ) );
	turret StartBarrelSpin();
	turret startfiring();

	vehicle ent_flag_wait( "start_aiming_at_badguys" );
	
	turret notify( "stop_aiming_at_targets" );
	self.maxsightdistsqrd = oldmaxsight;

	/*
	if ( isalive( level.ambusher ) )
	{
		self SetEntityTarget( level.ambusher, 1.0 );
		//turret SetTargetEntity( level.ambusher );
		wait( 1.5 );
	}
	*/


	turret SetMode( "auto_ai" );
	turret ClearTargetEntity();
	
	vehicle ent_flag_wait( "can_shoot_the_baddies" );
	
	turret.dontshoot = undefined;
}

gunner_aims_at_targets( default_target, vehicle )
{
	self endon( "stop_aiming_at_targets" );
	self endon( "death" );
	
	targetname = "turret_aim_target";
	if ( isdefined( vehicle.target_override ) )
		targetname = vehicle.target_override;
	
	targets = GetEntArray( targetname, "targetname" );
	foreach ( target in targets )
	{
		if ( !isdefined( target.script_noteworthy ) )
			target.script_noteworthy = "";
	}

	level.toffset++;

	for ( ;; )
	{
		ents = get_array_of_closest( self.origin, targets, undefined, 5, 2000, 500 );

		next_target = default_target;

		angles = vehicle.angles;

		priority_target = undefined;		
		foreach ( ent in ents )
		{
			if ( ent.script_noteworthy == "priority" )
			{
				dot = get_dot( self.origin, angles, ent.origin );
				//Print3d( ent.origin + (0,0,level.toffset*16), dot, (1,1,1), 1, 1.2, 100 );
				if ( dot > 0.7 )
				{
					priority_target = ent;
					break;
				}
			}
		}
		
		if ( isdefined( priority_target ) )
		{
			next_target = priority_target;
		}
		else
		{
			for ( i = 0; i < ents.size; i++ )
			{
				ent = ents[ i ];
				dot = get_dot( self.origin, angles, ent.origin );
				//Print3d( ent.origin + (0,0,level.toffset*16), dot, (1,1,1), 1, 1.2, 100 );
				if ( dot > 0.8 )
				{
					next_target = ent;
					break;
				}
			}
		}
		
		if ( vehicle == level.crazy_ride_convoy[ "detour" ] )
		{
			// detour guy does custom aiming once the shot rings out
			if ( flag ( "shot_rings_out" ) )
				return;
		}
		
		//thread linder( next_target );
		self SetTargetEntity( next_target );
		if ( next_target == default_target )
		{
			wait( 0.15 );
		}
		else
		{
			for ( ;; )
			{
				angles = vehicle.angles;
				dot = get_dot( self.origin, angles, next_target.origin );
				if ( dot < 0 )
					break;
				wait( 0.1 );
			}
		}
	}
}

linder( ent )
{
	self notify( "stop" );
	self endon( "stop" );
	for ( ;; )
	{
		Line( self.origin, ent.origin );
		wait( 0.05 );
	}
}

hargrove_spawner()
{
	self.animname = "hargrove";
	self gun_remove();
}

protect_player_while_scene_is_active()
{
	timeoutEnt = SpawnStruct();
	timeoutEnt thread notify_delay( "timeout", 10 );
	timeoutEnt endon( "timeout" );
	
	for ( ;; )
	{
		flag_wait( "player_hangs_with_commanders" );
		set_player_attacker_accuracy( 0 );
		level.player.ignorerandombulletdamage = true;

		flag_waitopen( "player_hangs_with_commanders" );
		maps\_gameskill::updateAllDifficulty();
		level.player.ignorerandombulletdamage = false;
	}
}

player_is_protected_near_commanders()
{
	protect_player_while_scene_is_active();
	maps\_gameskill::updateAllDifficulty();
	level.player.ignorerandombulletdamage = false;
}

roadkill_foley_shepherd_intro()
{
	waittillframeend; // for heroes to get defined
	level.shepherd thread shepherd_roams_battlefield( "shepherd_path" );
	thread player_is_protected_near_commanders();
	struct = getstruct( "roadkill_shepherd_scene", "targetname" );
	
	guys = [];
	guys[ "foley" ] = level.foley;
	//guys[ "shepherd" ] = level.shepherd;
	
	/*
	struct thread anim_loop_solo( level.foley, "intro_idle" );
	struct thread anim_loop_solo( level.shepherd, "intro_idle" );
	//flag_wait( "player_enters_riverbank" );
	wait( 1 );
	if ( !is_default_start() )
		return;
	
	struct notify( "stop_loop" );
	*/
	struct thread anim_single_solo_run( level.foley, "roadkill_riverbank_intro" );
	//struct thread anim_single_solo_run( level.shepherd, "roadkill_riverbank_intro" );
	wait( 0.05 );
	
	offset_start = 2;
	animation = level.foley getanim( "roadkill_riverbank_intro" );
	anim_time = getanimlength( animation );
	start_time = offset_start / anim_time;
	level.foley setanimtime( animation, start_time );
	
	//animation = level.shepherd getanim( "roadkill_riverbank_intro" );
	//anim_time = getanimlength( animation );
	//start_time = offset_start / anim_time;
	//level.shepherd setanimtime( animation, start_time );
	
	
	
	//node = getnode( "shepherd_walk_node", "targetname" );
	//level.shepherd.a.movement = "run";
	//level.shepherd setgoalnode( node );
	//level.shepherd.goalradius = 16;
	//level.shepherd set_run_anim( "walk" );
	//level.shepherd thread shepherd_roams_battlefield( "shepherd_path" );
	
	node = getnode( "foley_walk_node", "targetname" );
	level.foley.a.movement = "run";
	level.foley setgoalnode( node );
	level.foley.goalradius = 16;
	level.foley add_to_allied_riverbank_ai(); // makes him move out with convoy
	
	for ( ;; )
	{
		time = level.foley GetAnimTime( animation );
		if ( time >= 0.975 )
			break;
		wait( 0.05 );
	}

	level.foley anim_stopanimscripted();
}   

ent_flag_set_trigger()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !first_touch( other ) )
			continue;
		other ent_flag_set( self.script_flag );
	}
}
    
foley_spawner()
{
	assertex( !isdefined( level.foley ), "Multiple Foleys!" );
	level.foley = self;
	self.animname = "foley";
	self make_hero();
	
	if ( !flag( "player_rolls_into_town" ) )
	{
		flag_wait( "player_rolls_into_town" );
		self safe_delete();
	}

//	self gun_remove();
}

safe_delete()
{
	if ( !isalive( self ) )
		return;
		
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	self delete();
}

dunn_spawner()
{
	assertex( !isdefined( level.dunn ), "Multiple Dunns!" );
	level.dunn = self;
	self.animname = "dunn";
//	self gun_remove();
}

shepherd_spawner()
{
	assertex( !isdefined( level.shepherd ), "Multiple Shepherds!" );
	level.shepherd = self;
	self.animname = "shepherd";
	self make_hero();

	if ( !flag( "player_rolls_into_town" ) )
	{
		flag_wait( "player_rolls_into_town" );
		self safe_delete();
	}
//	self gun_remove();
}

player_humvee()
{
	self.dontdisconnectpaths = true;
	level.player_humvee = self;
	level.player_humvee.animname = "player_humvee";

	if ( level.start_point == "intro" || level.start_point == "getout" )
	{
		org = self player_rides_shotgun_in_humvee( 170, 170, 45, 15 );

		flag_wait( "slam_hood" );
		wait( 1.5 );

		org player_leaves_humvee();
		level.player AllowCrouch( true );
		level.player AllowProne( true );
	}

	/*
	level.player PlayerLinkTo( self, "tag_player", 0 );
	turret = self.mgturret[ 0 ];
	turret MakeUsable();
	turret SetMode( "manual" );
	turret UseBy( level.player );
	turret MakeUnusable();
	
//	thread player_viewhands_minigun( level.suburbans[ 2 ].mgturret[ 0 ] );
	level.player DisableTurretDismount();
	*/
}

player_turret_humvee()
{
	self.dontdisconnectpaths = true;
	level.player_humvee = self;
	level.player_humvee.animname = "player_humvee";

	self player_gets_on_turret();
}

player_gets_on_turret()
{
	thread warn_if_player_shoots_prematurely();

	level.player AllowCrouch( true );
	level.player AllowProne( true );

	//level.player PlayerLinkTo( self, "tag_player", 0 );
	level.player PlayerLinkToDelta( self, "tag_player", 0.35, 360, 360, 90, 45, true );
	turret = self.mgturret[ 0 ];
	turret setmodel( "weapon_suburban_minigun_viewmodel" );
	turret MakeUsable();
	turret SetMode( "manual" );
	turret UseBy( level.player );
	turret MakeUnusable();
	//turret Hide();
	level.player_turret = turret;
	level.player SetPlayerAngles( ( 0, level.player_humvee.angles[ 1 ], 0 ) );

//	thread player_viewhands_minigun( level.suburbans[ 2 ].mgturret[ 0 ] );
	level.player DisableTurretDismount();
	
	thread maps\_minigun_viewmodel::player_viewhands_minigun( turret );
}

front_vehicle()
{
	self.dontdisconnectpaths = true;
	if ( is_first_start() )
	{
		flag_wait( "player_humvee_stops_for_officers" );
		wait( 3 );
		self Vehicle_SetSpeed( 0, 10, 10 );

	}

	flag_wait( "slam_hood" );
	wait( 1.5 );
	self vehicle_unload( "passengers" );
}

ending_vehicle()
{
	self.dontunloadonend = true;
	self.dontdisconnectpaths = true;
	self waittill( "reached_end_node" );
	level.ending_vehicles[ level.ending_vehicles.size ] = self;
}

shepherd_ending_vehicle()
{
	self.dontunloadonend = true;
	self.dontdisconnectpaths = true;
	self waittill( "reached_end_node" );
	self vehicle_unload( "rear_driver_side" );
}

near_vehicle()
{
	level.near_vehicle = self;
	self.dontunloadonend = true;
	self.dontdisconnectpaths = true;
	// the humvee right in front of the player

	if ( is_first_start() )
	{
		flag_wait( "player_humvee_stops_for_officers" );
		wait( 3 );
	}
	flag_wait( "slam_hood" );
	wait( 1.5 );
	self vehicle_unload( "passengers" );

//	self Vehicle_SetSpeed( 0, 1, 1 );
}

rear_vehicle()
{
	self.dontdisconnectpaths = true;

	if ( is_first_start() )
	{
		flag_wait( "player_humvee_stops_for_officers" );
		// the vehicles behind you slow down
		for ( ;; )
		{
			speed = level.player_humvee.veh_speed;
			accel = speed;
			if ( accel <= 5 )
			{
				accel = 5;
			}

			self Vehicle_SetSpeed( speed, accel, accel );
			if ( flag( "slam_hood" ) )
				break;
			wait( 0.05 );
		}
	}

	wait( 1.5 );
	self vehicle_unload( "passengers" );
}


intro_convoy()
{
	self ent_flag_init( "convoy_stops_for_bridge" );
}


roadkill_bridge_layer( bridge_model )
{
	spawner = GetEnt( "bridge_layer_spawner", "targetname" );
	spawner.animname = "bridge_layer";

	if ( before_bridge_start() )
	{
		org = getstruct( "bridge_layer_org", "targetname" );
		org anim_teleport_solo( spawner, "bridge_driveup" );
	}
	else
	{
		org = getstruct( "bridge_layer_org", "targetname" );
		org anim_teleport_solo( spawner, "bridge_cross" );
		node = GetVehicleNode( "bridge_layer_path_1", "targetname" );
		spawner.origin = node.origin;
	}

	spawner add_spawn_function( ::bridge_layer_think );
	spawner spawn_vehicle();
}

intro_rundown_friendly_spawner()
{
	self.pathrandompercent = 200;
}

before_bridge_start()
{
	if ( level.start_point == "intro" )
		return true;
	return level.start_point == "riverbank";
}

bridge_layer_think()
{
	self.dontDisconnectPaths = true;
	level.bridge_layer = self;
	self.animname = "bridge_layer";

	org = getstruct( "bridge_layer_org", "targetname" );

	self assign_animtree();
	bridge_model = self.bridge_model;// comes with the vehicle
	bridge_model.animname = "bridge_layer_bridge";
	bridge_model assign_animtree();

	bridge_clip = GetEnt( "bridge_clip", "targetname" );
	bridge_clip add_target_pivot();
	bridge_clip.pivot LinkTo( bridge_model, "origin_animate_jnt", ( 0, 0, 0 ), ( 0, 0, 180 ) );
	bridge_clip Hide();

	thread bridge_layer_is_threatened_by_baddies( bridge_model );

	guys = [];
	guys[ "vehicle" ] = self;
	guys[ "bridge" ] = bridge_model;

	if ( before_bridge_start() )
	{
		bridge_model Unlink();
		arm_animation = self getanim( "bridge_arm_lower" );
		
		array_thread( guys, ::slow_down_bridge );
//		org anim_first_frame( guys, "bridge_lower" );
		org thread anim_single( guys, "bridge_lower" );
		wait( 0.05 );
		foreach ( guy in guys )
		{
			animation = guy getanim( "bridge_lower" );
			guy setanim( animation, 1, 0, 0 );
		}
		
		//self SetAnim( arm_animation, 1, 0, 0 );

		flag_wait( "bridgelayer_starts" );		
		
		org thread anim_single( guys, "bridge_lower" );

		bridge_anim_rate = 0.62;
		self SetAnim( arm_animation, 1, 0, 1 );
		wait( 0.05 );
		self SetAnim( arm_animation, 1, 0, bridge_anim_rate );

		// slow down bridgelayer
		foreach ( guy in guys )
		{
			animation = guy getanim( "bridge_lower" );
			guy setanim( animation, 1, 0, bridge_anim_rate );
		}

		//47
		
		bridge_animation = bridge_model getanim( "bridge_lower" );
		for ( ;; )
		{
			if ( bridge_model getanimtime( bridge_animation ) >= 0.47 )
				break;
			wait ( 0.05 );
		}

		self SetAnim( arm_animation, 1, 0, 0 );
		foreach ( guy in guys )
		{
			animation = guy getanim( "bridge_lower" );
			guy setanim( animation, 1, 0, 0 );
		}
		
		wait( 25 );
		flag_set( "bridge_layer_attacked_by_bridge_baddies" );
		flag_wait( "bridge_baddies_retreat" );


		foreach ( guy in guys )
		{
			animation = guy getanim( "bridge_lower" );
			guy setanim( animation, 1, 0, 1 );
		}
		
		// get the arm going full speed again
		self setanim( arm_animation, 1, 0, 1 );

		
		
		bridge_animation = bridge_model getanim( "bridge_lower" );
		for ( ;; )
		{
			if ( bridge_model getanimtime( bridge_animation ) >= 0.68 )
				break;
			wait ( 0.05 );
		}

		flag_set( "riverbank_baddies_retreat" ); // controls the guys in the windows
		flag_set( "leaving_riverbank" ); // controls the guys in the windows
		level notify( "tanks_stop_firing" );

		for ( ;; )
		{
			if ( bridge_model getanimtime( bridge_animation ) >= 0.98 )
				break;
			wait ( 0.05 );
		}

	}
	else
	{
		org thread anim_single( guys, "bridge_lower" );

		bridge_model Unlink();
//		org thread anim_single_solo( bridge_model, "bridge_lower" );
		wait( 0.05 );
		animation = bridge_model getanim( "bridge_lower" );
		bridge_model SetAnimTime( animation, 0.99 );
		wait( 1 );
	}
	
	//player_bridge_clip = getent( "player_bridge_clip", "targetname" );
	//player_bridge_clip delete();
	
	flag_set( "bridgelayer_complete" );
	delaythread( 4, ::flag_set, "bridgelayer_crosses" );
	
	
	animation = getanim( "bridge_lower" );

	//self ClearAnim( animation, 0 );
	self StopAnimScripted();

	node = GetVehicleNode( "bridge_layer_path_1", "targetname" );
	self StartPath( node );
	
//	self.veh_pathtype = "constrained";
	self thread vehicle_paths( node );

	if ( !before_bridge_start() )
	{			
		// speed boost
		self Vehicle_SetSpeedImmediate( 30, 5, 5 );
		wait( 1 );
		self resumespeed( 5 );
	}

	self waittill( "reached_end_node" );
	flag_wait( "player_gets_in" );
	spawn_vehicles_from_targetname_and_drive( "lead_vehicle_spawner" );


//	self vehicleDriveTo( node.origin, 30 );


//	org anim_single_solo( self, "bridge_cross" );

}

slow_down_bridge()
{
	wait( 0.05 );
	animation = self getanim( "bridge_lower" );
//	self SetAnim( animation, 1, 0, 2.5 );
}


enemy_bridge_spawner()
{
	startpos = self.origin;
	self endon( "death" );
	
	self.attackeraccuracy = 0.05;
	self.ignorerandombulletdamage = true;
	flag_wait( "bridge_baddies_retreat" );
		
	wait( randomfloat( 1.5 ) );
	node = getnode( self.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = node.radius;
	self waittill( "goal" );
	
	self setgoalpos( startpos );
	self.goalradius = 16;
	self waittill( "goal" );
	self delete();
}

enemy_bridge_vehicle_spawner()
{
	flag_wait( "bridge_truck_waits" );
	
	wait_until_player_ads_on_truck();
	
	flag_set( "bridge_truck_leaves" );
}

wait_until_player_ads_on_truck()
{
	/#
	flag_assert( "bridge_baddies_retreat" );
	#/
	
	level endon( "bridge_baddies_retreat" );
	
	for ( ;; )
	{
		dot = get_dot( level.player geteye(), level.player getplayerangles(), self.origin );
		if ( dot > 0.998 && level.player PlayerAds() >= 1.0 )
			break;
		wait( 0.05 );
	}
	
	wait( 2.5 );
}

bridge_layer_is_threatened_by_baddies( bridge_model )
{
	if ( !is_default_start() )
		return;

	flag_wait( "bridge_layer_attacked_by_bridge_baddies" );
	/*
	animation = bridge_model getanim( "bridge_lower" );
	for ( ;; )
	{
		animtime = bridge_model getanimtime( animation );
		if ( animtime > 0.43 )
			break;
		wait( 0.05 );
	}
	*/

	array_spawn_function_targetname( "enemy_bridge_vehicle_spawner", ::enemy_bridge_vehicle_spawner );
	spawn_vehicles_from_targetname_and_drive( "enemy_bridge_vehicle_spawner" );

	wait( 1 );	
	// Up there! They're making a push for the bridgelayer! Beat 'em back!	
	delaythread( 3, ::foley_line, "roadkill_fly_makingapush" );
	
	array_spawn_function_targetname( "bridge_defender_spawner", ::bridge_defender_spawner );
	delaythread( 2, ::array_spawn_targetname, "bridge_defender_spawner" );
		
	guys = array_spawn_targetname( "enemy_bridge_spawner" );
	add_wait( ::waittill_dead, guys, 3 );
	add_wait( ::bridge_almost_done, bridge_model );
	do_wait_any();
		
	flag_set( "bridge_baddies_retreat" );

	wait( 2.5 );
	// They're retreating, keep hitting 'em!	
	level.foley thread play_sound_on_entity( "roadkill_fly_keephitting" );
//	foley_line( "roadkill_fly_keephitting" );
}

bridge_defender_spawner()
{
	self endon( "death" );
	self.attackeraccuracy = 0;
	self.ignorerandombulletdamage = 1;
	flag_wait( "player_climbs_stairs" );
	self delete();
}

bridge_almost_done( bridge_model )
{
	animation = bridge_model getanim( "bridge_lower" );
	for ( ;; )
	{
		animtime = bridge_model getanimtime( animation );
		if ( animtime > 0.75 )
			break;
		wait( 0.05 );
	}
}

fluorescentFlicker()
{
	for ( ;; )
	{
		self SetLightIntensity( .8 );
		wait( RandomFloatRange( 0.1, 1.5 ) );

		self SetLightIntensity( RandomFloatRange( 0.6, .9 ) * .8 );
		wait( RandomFloatRange( .05, .1 ) );
	}
}

lights()
{
	lights = GetEntArray( "flickerlight1", "targetname" );
	foreach ( light in lights )
		light thread fluorescentFlicker();
}

get_orgs_from_ents( ents, dontDelete )
{
	orgs = [];
	foreach ( ent in ents )
	{
		struct = SpawnStruct();
		struct.origin = ent.origin;
		struct.radius = ent.radius;
		orgs[ orgs.size ] = struct;
		if ( !isdefined( dontDelete ) )
			ent Delete();
	}
	return orgs;
}

riverbank_tank()
{
	self endon( "death" );
	level endon( "tanks_stop_firing" );
	
	if ( !is_default_start() )
		return;

	ents = get_linked_ents();
	orgs = get_orgs_from_ents( ents );

	ent = Spawn( "script_origin", ( 0, 0, 0 ) );
	ent.origin = orgs[ 0 ].origin;
	self SetTurretTargetEnt( ent );
	self.target_ent = ent;

	wait( RandomFloat( 4 ) );

	firelink = self.script_firelink;
	firelink_funcs = [];
	firelink_funcs[ "fire_often" ] = ::tank_fires_often;
	firelink_funcs[ "fire_rarely" ] = ::tank_fires_rarely;
	firelink_funcs[ "fire_never" ] = ::tank_fires_never;
	firelink_funcs[ "stryker_fire" ] = ::tank_stryker_fire;
	

	func = firelink_funcs[ firelink ];
	[[ func ]]( orgs );
}

tank_fires_never( orgs )
{
	ent = self.target_ent;

	for ( ;; )
	{
		orgs = array_randomize( orgs );
		foreach ( org in orgs )
		{
			ent.origin = org.origin;
			if ( IsDefined( org.radius ) )
			{
				ent.origin += randomvector( org.radius );
			}

			if ( self Vehicle_CanTurretTargetPoint( ent.origin ) )
			{
				self waittill( "turret_on_target" );
				wait( RandomFloatRange( 2, 3 ) );
			}
			else
			{
				wait( RandomFloatRange( 3, 5 ) );
			}
		}
	}
}

set_target_org_close( ent )
{
	// make the target position be close to where we are but on the same line
	my_org = self.origin + ( 0, 0, 60 );
	angles = VectorToAngles( ent.origin - my_org );
	forward = AnglesToForward( angles );
	ent.origin = my_org + forward * 400;
}

tank_fires_rarely( orgs )
{
	ent = self.target_ent;
	wait( randomfloat( 10 ) );

	for ( ;; )
	{
		orgs = array_randomize( orgs );
		foreach ( org in orgs )
		{
			ent.origin = org.origin;
			if ( IsDefined( org.radius ) )
			{
				ent.origin += randomvector( org.radius );
			}

			set_target_org_close( ent );

			if ( self Vehicle_CanTurretTargetPoint( ent.origin ) )
			{
				self waittill( "turret_on_target" );
				wait( RandomFloatRange( 0.5, 2 ) );

				// 0, 0, 1, or 2 shots
				shots = RandomInt( 4 ) - 1;
				for ( i = 0; i < shots; i++ )
				{
					self FireWeapon();
					//Line( self.origin, ent.origin, (1,0,0), 1, 0, 500 );
					wait( RandomFloatRange( 5, 8 ) );
				}
				wait( 15 );
			}
			else
			{
				wait( RandomFloatRange( 3, 5 ) );
			}
		}
	}
}

tank_stryker_fire( orgs )
{
	if ( !is_default_start() )
	{
		RadiusDamage( level.riverside_bmp.origin, 128, 5000, 5000 );
		return;
	}
		
	thread tank_fires_often( orgs );
	//flag_wait( "player_enters_riverbank" );
	wait( 18 );

	// 20 second timeout	
	level.riverside_bmp waittill_player_lookat( 0.98, 0.1, true, 20 );

	self notify( "stop_tank_fire" );

	stryker_blows_up_riverside_bmp();
	
	// go back to firing at random targets
	tank_fires_often( orgs );	
}

stryker_blows_up_riverside_bmp()
{
	// self SetTurretTargetEnt( self.target_ent );
	
	self.target_ent.origin = level.riverside_bmp.origin + (0,0,32);
	self waittill( "turret_on_target" );
	wait( 0.25 );

	// 0, 0, 1, or 2 shots
	shots = RandomInt( 4 ) - 1;
	for ( ;; )
	{
		if ( !isalive( level.riverside_bmp ) )
			break;
		self FireWeapon();
		wait( RandomFloatRange( 1, 1.5 ) );
	}
}

tank_fires_often( orgs )
{
	self endon( "stop_tank_fire" );
	ent = self.target_ent;

	for ( ;; )
	{
		orgs = array_randomize( orgs );
		foreach ( org in orgs )
		{
			ent.origin = org.origin;
			if ( IsDefined( org.radius ) )
			{
				ent.origin += randomvector( org.radius );
			}

			set_target_org_close( ent );

			if ( self Vehicle_CanTurretTargetPoint( ent.origin ) )
			{
				self waittill( "turret_on_target" );
				wait( RandomFloatRange( 0.5, 2 ) );

				// 0, 0, 1, or 2 shots
				shots = RandomInt( 4 ) - 1;
				for ( i = 0; i < shots; i++ )
				{
					self FireWeapon();
					//Line( self.origin, ent.origin, (1,0,0), 1, 0, 500 );
					wait( RandomFloatRange( 1, 3 ) );
				}
				wait( 3 );
			}
			else
			{
				wait( 0.5 );
				//wait( RandomFloatRange( 3, 5 ) );
			}
		}
	}
}

roadkill_officers_walk_up()
{
	struct = getstruct( "intro_orders", "targetname" );
	guys = get_guys_with_targetname_from_spawner( "intro_friendly_spawner" );
	level.roadkill_officers = guys;

	foreach ( guy in guys )
	{
		guy set_run_anim( "walk" );
		guy.pathrandompercent = 0;
		guy.moveplaybackrate = 1;
		guy.goalradius = 8;
		guy.walkdist = 0;
		guy.disablearrivals = true;
	}

	if ( is_first_start() )
	{
		wait( 8 );


		// start walking with proper separation
		foreach ( guy in guys )
		{

			target = getstruct( guy.target, "targetname" );
			guy thread maps\_spawner::go_to_node( target, "struct" );
		}

		wait( 5 );
		struct anim_reach_together( guys, "roadkill_intro_orders" );
		delayThread( 2.950, ::exploder, "intro_boom" );
		delayThread( 0.5, ::spawn_vehicle_from_targetname_and_drive, "early_f15_flyby" );
	}

	struct anim_single( guys, "roadkill_intro_orders" );
}

detach_binocs()
{
	if ( isdefined( self.binoc ) )
		self detach( "weapon_binocular", "tag_inhand" );
	self.binoc = undefined;
}

binoc_scene()
{
	struct = getstruct( "binoc_scene", "targetname" );
	struct thread do_binoc_scene();

	struct = getstruct( "binoc_scene_spotter", "targetname" );
	struct thread do_binoc_scene();
}

do_binoc_scene()
{
	binoc_scene_spawners = GetEntArray( self.target, "targetname" );
	guys = array_spawn( binoc_scene_spawners );
	guy = guys[ 0 ];

	guy.animname = guy.script_noteworthy;

	if ( guy.animname == "spotter" )
	{
		guy Attach( "weapon_binocular", "tag_inhand" );
		guy.binoc = true;
		guy.convoy_func = ::detach_binocs;
	}
	
	guy.doing_looping_anim = true;
	guy add_to_allied_riverbank_ai();
	self thread play_binoc_scene( guy );
}

play_binoc_scene( guy )
{
	self anim_first_frame_solo( guy, "binoc_scene" );
	flag_wait( "player_enters_riverbank" );
	wait( 0.75 );
	self anim_single_solo( guy, "binoc_scene" );
	if ( !flag( "player_gets_in" ) )
	{
		self thread anim_loop_solo( guy, "idle" );
	}
	
	flag_wait( "player_gets_in" );
	self notify( "stop_loop" );
}

candy_bar_scene()
{
	flag_wait( "time_to_go" );
	spawners = GetEntArray( self.target, "targetname" );
	guys = array_spawn( spawners );
	guys[ 0 ].animname = "cover_radio3";
	candyMan = guys[ 0 ];
	candy = "mil_mre_chocolate01";
	candyMan Attach( candy, "tag_inhand" );
	
	foreach ( guy in guys )
	{
		guy.allowdeath = true;
	}

	self thread anim_loop( guys, "idle" );
	flag_wait( "player_gets_in" );
	if ( isalive( candyMan ) )
		candyMan delete();
}

cover_scene()
{
	spawners = GetEntArray( self.target, "targetname" );
	guys = array_spawn( spawners );
	waittillframeend; // for auto spawn logic

	// remove the ai from the array, only shepherd is an AI
	newguys = [];
	foreach ( guy in guys )
	{
		if ( issentient( guy ) )
			continue;
		newguys[ newguys.size ] = guy;
	}
	guys = newguys;

	guys[ 0 ].animname = "cover_attack2";
	guys[ 1 ].animname = "cover_attack3";
		
	if ( isdefined( guys[ 2 ] ) )
		guys[ 2 ].animname = "cover_attack1";
	
	foreach ( guy in guys )
	{
		//guy thread player_line();
		guy.allowdeath = true;
	}

	self.g = 5;
	self thread anim_loop( guys, "idle" );
	wait( 0.05 );

	foreach ( guy in guys )
	{
		//guy thread player_line();
		guy.allowdeath = true;
		animation = guy getanim( "idle" )[0];
		guy SetAnimTime( animation, 0.35 );	
	}
	
	flag_wait( "player_gets_in" );
	wait( 3.2 );
	foreach ( guy in guys )
	{
		if ( isdefined( guy ) )
			guy delete();
	}
}

player_line()
{
	for ( ;; )
	{
		Line( self.origin, level.player.origin );
		wait(0.05 );
	}
}

radio_scene()
{
	spawners = GetEntArray( self.target, "targetname" );
	guys = array_spawn( spawners );

	guys = get_array_of_closest( self.origin, guys );

	guys[ 0 ].animname = "cover_radio1";
	guys[ 1 ].animname = "cover_radio2";
	guys[ 2 ].animname = "cover_radio3";
	
	candyMan = guys[ 2 ];
	candy = "mil_mre_chocolate01";
	candyMan Attach( candy, "tag_inhand" );
	candyMan.convoy_func = ::detach_candy;
	candyMan.candy = candy;
	candyMan.doing_looping_anim = true;
	candyMan add_to_allied_riverbank_ai();
	
	non_candy = [];
	non_candy[ 0 ] = guys[ 0 ];
	non_candy[ 1 ] = guys[ 1 ];
	
	/*
	foreach ( guy in guys )
	{
		guy.doing_looping_anim = true;
		guy add_to_allied_riverbank_ai();
	}
	*/

	guys[ 1 ] gun_remove();


	self thread anim_loop( guys, "idle" );
	
	flag_wait( "player_gets_in" );
	self notify( "stop_loop" );
	
	foreach ( guy in non_candy )
	{
		if ( isdefined( guy.magic_bullet_shield ) )
			guy stop_magic_bullet_shield();
		
		guy delete();
	}
	
	/*
	flag_wait( "time_to_go" );
	
	candyMan.convoy_func = ::detach_candy;
	candyMan.candy = candy;

	self notify( "stop_loop" );
	candyMan Detach( candy, "tag_inhand" );
	
	foreach ( guy in guys )
	{
		guy thread run_to_convoy_if_player_looks_at_me();
	}
	*/

	/*
	index = level.ally_convoy_trigger.index;
	node = level.guy_gets_in_vehicle_targets[ index ];
	level.ally_convoy_trigger.index++;
	guy thread guy_gets_in_convoy( node );
	*/
}

detach_candy()
{
	self Detach( self.candy, "tag_inhand" );
}

set_dontshootwhilemoving( val )
{
	self.dontshootwhilemoving = val;
}

guys_film_explosion()
{
	spawner = GetEnt( self.target, "targetname" );
	guy = spawner spawn_ai();
	guy endon( "death" );
	
	// film1, film2, film3, film4
	guy.animname = self.script_noteworthy;
	
	model = level.scr_model[ guy.animname ];
	guy Attach( model, "tag_inhand" );
	
	if ( isdefined( guy.script_delay ) )
	{
		self anim_first_frame_solo( guy, "video_film_start" );
		guy script_delay();
	}
		
	self anim_single_solo( guy, "video_film_start" );
	
	if ( guy.animname == "film1" )
	{
		//animation = guy getanim( "video_film_idle_custom" );
		array = [];
		array[ 0 ] = guy;
		guy thread anim_custom_animmode_loop( array, "gravity", "video_film_idle" );
	}
	else
	{
		self thread anim_loop_solo( guy, "video_film_idle" );
	}
	flag_wait( "video_tapers_react" );
	self notify( "stop_loop" );
	//self anim_single_solo( guy, "video_film_react" );
	self anim_custom_animmode_solo( guy, "gravity", "video_film_react" );
	

	if ( guy hasanim( "video_film_end" ) )
	{
		guy.anim_blend_time_override = 1;
		guy anim_custom_animmode_solo( guy, "gravity", "video_film_end" );
	}

	if ( IsDefined( guy.magic_bullet_shield ) )
		guy stop_magic_bullet_shield();
	
	node = getnode( "bridge_delete_node", "targetname" );
	guy setgoalnode( node );
	guy.goalradius = 8;
	guy waittill( "goal" );	
	guy delete();
}


enemy_riverbank_rpg_spawner()
{
	self endon( "death" );
	bridge_targets = getentarray( "bridge_target", "targetname" );
	//thread rpgguy();

	for ( ;; )
	{
		target = random( bridge_targets );
		target.health = 1;
		self SetEntityTarget( target );
		timer = randomfloatrange( 1, 3 );
		wait( timer );
	}
}
	
rpgguy()
{
	self endon( "death" );

	for ( ;; )
	{
		print3d( self.origin + (0,0,64), "RPG" );
		wait( 0.05 );
	}
}


riverside_house_manager( spawners )
{
	if ( flag( "riverbank_baddies_retreat" ) )
		return;
	level endon( "riverbank_baddies_retreat" );

	for ( ;; )
	{
		spawners = array_randomize( spawners );
		foreach ( spawner in spawners )
		{
			for ( ;; )
			{
				axis = GetAIArray( "axis" );
				if ( axis.size < 6 )
				{
					spawner.count = 1;
					spawner spawn_ai();
					wait( 2 );
					break;
				}
				wait( 2 );
			}
		}
	}
}

riverside_flood_manager( spawners )
{
	if ( flag( "riverbank_baddies_retreat" ) )
		return;
	level endon( "riverbank_baddies_retreat" );

	for ( ;; )
	{
		spawners = array_randomize( spawners );
		foreach ( spawner in spawners )
		{
			for ( ;; )
			{
				ai = GetAIArray();
				if ( ai.size < 31 )
				{
					spawner.count = 1;
					spawner spawn_ai();
					wait( 1 );
					break;
				}
				wait( 1 );
			}
		}
	}
}

riverside_flood_think( delay_min, delay_max )
{
	if ( flag( "riverbank_baddies_retreat" ) )
		return;
	level endon( "riverbank_baddies_retreat" );

	self endon( "death" );
	wait( RandomFloat( 1 ) );

	for ( ;; )
	{
		self.count = 1;
		guy = self spawn_ai();
		if ( !isalive( guy ) )
		{
			wait( 1 );
			continue;
		}

		guy waittill( "death" );
		timer = RandomFloatRange( delay_min, delay_max );
		wait( timer );
	}
}

hide_helper_model()
{
	self hide_notsolid();
}

show_helper_model()
{
	self show_solid();
}

riverbank_guy_dies_on_retreat()
{
	self endon( "death" );
	flag_wait( "riverbank_baddies_retreat" );
	timer = RandomFloat( 3 );
	wait( timer );
	self kill();
}

riverbank_spawner_retreat_think()
{
	self endon( "death" );
	self.startpos = self.origin;
	flag_wait( "riverbank_baddies_retreat" );
	timer = RandomFloat( 6 );
	wait( timer );
	self SetGoalPos( self.startpos );
	self.goalradius = 8;
	self waittill( "goal" );
	self Delete();
}

disable_all_vehicle_mgs()
{
	vehicles = GetEntArray( "script_vehicle", "code_classname" );
	array_thread( vehicles, ::mgoff );
	/*
	foreach ( vehicle in vehicles )
	{
		if ( !isdefined( vehicle.mgturret ) )
			continue;
			
		foreach ( turret in vehicle.mgturret )
		{
			turret mgoff();
		}
	}
	*/
}

guy_gets_in_player_humvee()
{
	if ( !isdefined( self.magic_bullet_shield ) )
		self magic_bullet_shield();
	//self disable_arrivals();

	flag_wait( "convoy_moment" );


	// this origin is based on where the vehicle stops, not known until after it stops so we have to manually save it off
	// so the guy can run early
	wait( 3.9 );

	//org = ( -2492, -3826, 178 );
	//org = ( -2481, -3786, 178 );// ( -2509, -3742, 176 );
	//org = (-2476.36, -3766.86, 178.319);
	//org = (-2473.52, -3787.51, 178.106);
	//org = ( -2488, -3755, 182 );

	//org = ( -2483, -3749, 176 );
	org = ( -2474, -3765, 178 );
	self SetGoalPos( org );
	self.goalradius = 8;
	self waittill( "goal" );

	//flag_wait( "player_humvee_stops" );


	thread guy_runtovehicle_load( self, level.player_humvee );
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();

	wait( 0.4 );
	PrintLn( "goalpos " + self.goalpos );
}

jeep_rider_spawner_think()
{
	self.qSetGoalPos = false;
	guy_runtovehicle_load( self, level.friendly_open_humvee );
}

humvee_rider_spawner()
{
	spawner = getent( "humvee_rider_spawner", "script_noteworthy" );
		
	spawner waittill( "drone_spawned", guy );
	spawner delete();
	assertex( isalive( guy ), "No waver!" );
	guy thread humvee_rider_waver();
}

humvee_rider_waver()
{
	self endon( "death" );
	wait( 0.05 );
	self.ridingVehicle anim_generic_first_frame( self, "help_player_getin", "tag_guy0" );
	flag_wait( "convoy_moment" );
	wait( 1.3 );
	self.ridingVehicle anim_generic( self, "help_player_getin", "tag_guy0" );
	self notify( "animontagdone", "end" );
	
	flag_wait( "player_gets_in" );
	wait( 3 );
	if ( IsDefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	
	self delete();
}

player_ride_vehicle()
{
	level.player_humvee = self;
	self.dontdisconnectpaths = true;
	chairModel = "vehicle_hummer_seat_rb_obj";
	self hidePart( "tag_seat_rb_hide" );
	
	chair = spawn( "script_model", (0,0,0) );
	level.chair = chair;
	chair setmodel( chairModel );
	chair linkto( self, "tag_seat_rb_attach", (0,0,0), (0,0,0) );
	chair MakeUsable();
	chair SetHintString( &"ROADKILL_HOLD_TO_BOARD" );

	flag_wait( "convoy_moment" );
	self thread gopath();

//	self MakeUsable();
	//time = gettime();
	//self waittill( "speed_zero_path_disconnect" );
	//println( gettime() - time );
	wait( 1.3 );
	
	self.animname = "player_humvee";
	door_open_animation = self getanim( "roadkill_player_door_open" );
	self setanim( door_open_animation, 1, 0, 1 );


	/*	
	Glowing seat model:
	     Use model => ( vehicle_hummer_seat_rb_obj ) as glowing seat.  
	     I didn't set any glowing attributes for it yet, you'll have to set that
	up.
	
	To hide regular seat:
	     Use ( tag_seat_rb_hide ).
	
	To attach glowing seat to regular:  
	     Attach ( tag_seat_rb , from vehicle_hummer_seat_rb_obj) to (
	tag_seat_rb_attach )
	*/
	//self Attach( chairModel, "tag_seat_rb_attach" );

	player_rig = spawn_anim_model( "player_hummer_getin" );
	player_rig linkto( self, "tag_body", (0,0,0), (0,0,0) );
	player_rig hide();
	
	self anim_first_frame_solo( player_rig, "player_getin", "tag_body" );
	
	flag_set( "player_humvee_stops" );
	chair waittill( "trigger" );
	level.player disableweapons();

	thread player_fov_zooms_in_for_turret();
	/*
	for ( ;; )
	{
		self waittill( "touch", other );
		if ( !isalive( other ) )
			continue;
		if ( other == level.player )
			break;
	}
	*/


	self ShowPart( "tag_seat_rb_hide" );
	chair delete();
	//self Detach( chairModel, "tag_seat_rb_attach" );

	flag_set( "player_gets_in" );
	

	turret = self.mgturret[ 0 ];
	turret.animname = "turret";
	turret assign_animtree();
	guys = [];
	guys[ "player" ] = player_rig;
	guys[ "turret" ] = turret;
	
	level.player setstance( "stand" );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.4, 0.2, 0.2 );
	player_rig delaycall( 0.2, ::show );
	
	turret delaythread( 1, ::lerp_out_drop_pitch, 1.5 );
	self anim_single( guys, "player_getin", "tag_body" );
	player_rig delete();

	
	self clearanim( door_open_animation, 1, 0, 1 );
//	level.player PlayerLinkTo( self, "tag_player", 0 );

	
	level.player enableweapons();
	player_gets_on_turret();
	
	// reset the fov
	wait( 0.1 );
	SetSavedDvar( "cg_fov", 65 );

	/*
	turret = self.mgturret[ 0 ];
	turret MakeUsable();
	turret SetMode( "manual" );
	turret UseBy( level.player );
	turret MakeUnusable();
	
//	thread player_viewhands_minigun( level.suburbans[ 2 ].mgturret[ 0 ] );
	level.player DisableTurretDismount();
	*/
}


player_fov_zooms_in_for_turret()
{
	wait( 1 );
	lerp_fov_overtime( 2, 55 );
}

ride_vehicle()
{
	self.dontdisconnectpaths = true;
	flag_wait( "player_gets_in" );
	self thread gopath();
}

ride_vehicle_starts_moving()
{
	thread ride_parameters_check();
	thread common_ride_vehicle_init();
	flag_wait( "convoy_moment" );
	self thread gopath();
}

common_ride_vehicle_init()
{
	self.dontdisconnectpaths = true;
}

ride_parameters_check()
{
	if ( !isdefined( self.script_parameters ) )
		return;

	switch ( self.script_parameters )
	{
		case "picks_up_riders":
			level.npc_ride_vehicles[ level.npc_ride_vehicles.size ] = self;
			break;
	}
}

get_vehicle_from_spawner()
{
	if ( !isdefined( self.target ) )
		return;
		
	// get the vehicle spawner so we'll know the vehicle after it spawns
	node = GetNode( self.target, "targetname" );
	spawner = GetEnt( node.script_linkto, "script_linkname" );
	spawner waittill( "spawned", vehicle );

	node.vehicle = vehicle;
}

best_friendly_to_run( array )
{
	// player sees the scope glint if the dot is within a certain range
	player_angles = level.player GetPlayerAngles();
	player_forward = AnglesToForward( player_angles );
	end = level.player GetEye();
	
	foreach ( guy in array )
	{
		start = guy geteye();
		angles = VectorToAngles( start - end );
		forward = AnglesToForward( angles );
	
		dot = VectorDot( forward, player_forward );
		if ( dot < 0.75 )
			continue;
			
		if ( dot >= 0.85 )
			continue;
		
		return guy;
	}
	return undefined;
}

allies_leave_riverbank()
{
	if ( flag( "player_gets_in" ) )
		return;
	level endon( "player_gets_in" );

	array = [];
	foreach ( guy in level.allied_riverbank_ai )
	{
		array[ guy.unique_id ] = guy;
	}
	
	for ( ;; )
	{
		foreach ( guy in array )
		{
			if ( !isalive( guy ) )
				array[ guy.unique_id ] = undefined;
		}
		
		//guy = get_closest_to_player_view( array, level.player, true, 0.85 );
		guy = best_friendly_to_run( array );
		
		if ( isalive( guy ) )
		{
			array[ guy.unique_id ] = undefined;
			
			guy thread run_to_convoy();

			if ( level.runnings_to_convoy_count >= level.guy_gets_in_vehicle_targets.size )
				return;

			wait( 4 );
		}
		
		
		if ( !array.size )
			break;
		wait( 0.15 );
	}

//	staircase_org = getstruct( "staircase_org", "targetname" );
//	array = get_array_of_closest( staircase_org.origin, level.allied_riverbank_ai );

	/*
	wait( 3 );// let the car guys go first

	count = 0;
	got_in = 0;
	for ( i = array.size - 1; ; i-- )
	{
		if ( got_in >= level.guy_gets_in_vehicle_targets.size )
			break;
		if ( i < 0 )
			break;

		guy = array[ i ];
		AssertEx( IsAlive( guy ), "Dead, but how?" );

		guy ent_flag_set( "go_to_convoy" );
		wait( 0.75 );
		count++;
		got_in++;
		while ( count >= 3 )
		{
			count -= 3;
			wait( 0.5 );
		}
	}
	*/
}

get_in_moving_vehicle()
{
	self.get_in_moving_vehicle = true;
}

add_to_allied_riverbank_ai()
{
	level.allied_riverbank_ai[ level.allied_riverbank_ai.size ] = self;
	
	add_riverbank_flags();
}

add_riverbank_flags()
{
	ent_flag_init( "go_to_convoy" );
	ent_flag_init( "got_in_vehicle" );
}

allied_riverbank_spawner()
{
	self endon( "death" );

	add_to_allied_riverbank_ai();
	flag_wait( "time_to_go" );
	self.ignoreall = true;
	//ent_flag_wait( "go_to_convoy" );
	//self.ignoreall = false;


	/*
	while ( index >= 3 )
	{
		index -= 3;
		wait( 2.0 );
	}
	
	wait( index * 0.15 );
	*/
	/*
	flag_wait( "time_to_go" );
	if ( self.script_index >= 7 )
		run_to_convoy();
	*/
}

run_to_convoy()
{
	level.runnings_to_convoy_count++;
	/*
	assertex( isdefined( self.script_index ), "Guy with export " + self.export + " had no script_index" );
	
	wait_table = [];
	wait_table[ 0 ] = 0.05; // 2 guys to the front right
	wait_table[ 1 ] = 0.25; // 2 guys to the front right
	wait_table[ 2 ] = 2.8; // 3 guys doing radio scene
	wait_table[ 3 ] = 0.5; // 3 guys doing radio scene
	wait_table[ 4 ] = 0.4; // 3 guys doing radio scene
	wait_table[ 5 ] = 1.8; // guy forward left
	wait_table[ 6 ] = 1.9; // 2 doing binoc scene
	wait_table[ 7 ] = 0.4; // 2 doing binoc scene
	wait_table[ 8 ] = 1.5; // guy in the hut
	wait_table[ 9 ] = 0.5; // guy on the truck
	
	timer = 0;
	for ( i = 0; i <= self.script_index; i++ )
	{
		timer += wait_table[ i ];
	}
	wait( timer );
	*/
	
	self anim_stopanimscripted();
	if ( isdefined( self.doing_looping_anim ) )
	{
		self.remove_from_animloop = true;
	}
	
	if ( isdefined( self.convoy_func ) )
	{
		// a one time cleanup func a few guys runself.convoy_func = getent( "self.convoy_func", "targetname" );
		self thread [[ self.convoy_func ]]();
		self.convoy_func = undefined;
	}
	
	//self.dontavoidplayer = true;
	//self PushPlayer( true );
	
	self.moveplaybackrate = 1;
	self.pathrandompercent = 0;
	riverbank_run_node = GetNode( "riverbank_run_node", "targetname" );
	self.fixednode = false;
	self SetGoalNode( riverbank_run_node );
	self.goalradius = 16;
}

trigger_guy_gets_in_vehicle()
{
	level.ally_convoy_trigger = self;

	// target a bunch of structs that target nodes that ai will run to	
	level.guy_gets_in_vehicle_targets = GetNodeArray( self.target, "targetname" );
	foreach ( node in level.guy_gets_in_vehicle_targets )
	{
		node thread get_vehicle_from_spawner();
	}

	/#
	used = [];
	foreach ( node in level.guy_gets_in_vehicle_targets )
	{
		assertex( isdefined( node.script_index ), "Node at " + node.origin + " has no script_index" );
		assertex( !isdefined( used[ node.script_index ] ), "Reused script_index " + node.script_index + " at " + node.origin );
		used[ node.script_index ] = true;
	}
	#/
	level.guy_gets_in_vehicle_targets = array_index_by_script_index( level.guy_gets_in_vehicle_targets );
	self.index = 0;

	trigger_handles_guys_running_up_stairs_to_get_in_vehicles();

	level.allied_riverbank_ai = remove_dead_from_array( level.allied_riverbank_ai );

	// catch up for the guys that didn't get in fast enough
	foreach ( guy in level.allied_riverbank_ai )
	{
		guy thread goalspam();

		if ( IsDefined( guy.gets_in_vehicle ) )
			continue;

		// delete extra guys
		if ( self.index >= level.guy_gets_in_vehicle_targets.size )
		{
			if ( IsDefined( guy.magic_bullet_shield ) )
				guy stop_magic_bullet_shield();
			guy Delete();
			continue;
		}

		struct = level.guy_gets_in_vehicle_targets[ self.index ];
		self.index++;
		guy thread guy_gets_in_convoy( struct );
	}
}

goalspam()
{
	self endon( "death" );
	for ( i = 0; i < 5; i++ )
	{
		self notify( "goal" );
		wait( 0.05 );
	}
}

trigger_handles_guys_running_up_stairs_to_get_in_vehicles()
{
	if ( flag( "player_gets_in" ) )
		return;
	level endon( "player_gets_in" );

	touched = [];
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;

		if ( IsDefined( touched[ other.unique_id ] ) )
			continue;

		touched[ other.unique_id ] = true;
		struct = level.guy_gets_in_vehicle_targets[ self.index ];
		self.index++;
		AssertEx( self.index <= level.guy_gets_in_vehicle_targets.size, "Too many guys!" );

		other thread guy_gets_in_convoy( struct );

		/*
		foreach ( vehicle in level.npc_ride_vehicles )
		{
			if ( vehicle.riders.size >= 3 )
				continue;
			thread guy_runtovehicle_load( other, vehicle );
				
			break;
		}
		*/
	}
}

guy_gets_in_convoy( mynode )
{
	/*
	mynode = undefined;
	foreach ( struct in level.guy_gets_in_vehicle_targets )
	{
		if ( IsDefined( struct.taken ) )
			continue;
		mynode = struct;
		mynode.taken = true;
		level.ride_nodes_taken++;
		break;
	}

	if ( !isdefined( mynode ) )
		return;
	*/

	self.fixednode = true;
	self.gets_in_vehicle = true;
	self.attackeraccuracy = 0;
	if ( !isdefined( self.magic_bullet_shield ) )
		self magic_bullet_shield();
	self SetGoalNode( mynode );
	self.goalradius = 16;

	if ( !flag( "convoy_moment" ) )
	{
		level add_wait( ::waittill_msg, "player_got_in" );
		self add_wait( ::waittill_msg, "goal" );
		level add_endon( "convoy_moment" );
		do_wait_any();

		flag_wait( "convoy_moment" );
	}

	if ( !flag( "guys_get_in_convoy_vehicles" ) )
	{
		flag_wait( "guys_get_in_convoy_vehicles" );

		wait_for_index( mynode.script_index );
	}

	if ( !isdefined( mynode.target ) )
		return;
		
	node = GetNode( mynode.target, "targetname" );
	self SetGoalNode( node );
	self.disablearrivals = true;

	level add_wait( ::waittill_msg, "player_got_in" );
	self add_wait( ::waittill_msg, "goal" );
	do_wait_any();

	self.script_startingposition = node.script_startingposition;

	thread guy_runtovehicle_load( self, node.vehicle );

	self waittill( "boarding_vehicle" );
	self ent_flag_set( "got_in_vehicle" );
	if ( self.script_startingposition == 4 )
		self thread convoy_gunner_think();

//			thread guy_runtovehicle_load( other, vehicle );
}

wait_for_index( index )
{
	if ( flag( "player_gets_in" ) )
		return;
	level endon( "player_gets_in" );

	wait( index * 0.35 );
}

/*
airstrike_spawner()
{
	if ( !isdefined( self.magic_bullet_shield ) )
		self magic_bullet_shield();
	self.dontavoidplayer = true;
	self.interval = 0;
	self.disableexits = true;
	flag_wait( "convoy_moment" );
	ent = getstruct( self.target, "targetname" );
	self maps\_spawner::go_to_node( ent, "struct" );

	if ( !isdefined( self.script_noteworthy ) )
		return;

	switch( self.script_noteworthy )
	{
		case "croucher":
			self waittill( "goal" );
			self AllowedStances( "crouch" );
			break;

		case "get_in_car_guy":
			flag_wait( "time_to_pull_out" );
			wait( 1 );
			guy_runtovehicle_load( self, level.friendly_open_humvee );
			break;
	}
}
*/

friendly_open_humvee()
{
	level.friendly_open_humvee = self;
	self waittill( "reached_end_node" );
	house_node = GetNode( "house_node", "targetname" );

	foreach ( guy in self.riders )
	{
		if ( !isalive( guy ) )
			continue;
		if ( !isai( guy ) )
			continue;
			
		guy SetGoalPos( house_node.origin );
	}
}

vehicle_break()
{
	touched = [];
	brake_time = self.script_timer;
	if ( !isdefined( brake_time ) )
		brake_time = 0.3;

	brake_amount = self.script_brake;
	if ( !isdefined( brake_amount ) )
		brake_amount = 0.3;


	for ( ;; )
	{
		self waittill( "trigger", other );

		if ( IsDefined( touched[ other.unique_id ] ) )
			continue;

		touched[ other.unique_id ] = true;
		other thread break_awhile ( brake_time, brake_amount );
	}
}

break_awhile ( brake_time, brake_amount )
{
	self.veh_brake = brake_amount;
	wait( brake_time );
	self.veh_brake = 0;
}

spark_preset()
{
	target = getstruct( self.target, "targetname" );
	angles = VectorToAngles( target.origin - self.origin );
	level.spark_presets[ self.script_parameters ] = angles;
}

vehicle_spark_trigger()
{
	targ = GetEnt( self.target, "targetname" );
	targ_targ = GetEnt( targ.target, "targetname" );
	
	
	/*
	// move it forward to compensate for high speed	
	angles = vectortoangles( targ_targ.origin - targ.origin );
	forward = AnglesToForward( angles );
	vec = forward * -250;
	self.origin += vec;
	targ.origin += vec;
	targ_targ.origin += vec;
	*/



	org1 = targ.origin;
	org2 = targ_targ.origin;

	targ Delete();
	targ_targ Delete();

	touched = [];

	technical_only = false;
	if ( IsDefined( self.script_noteworthy ) )
	{
		switch( self.script_noteworthy )
		{
			case "technical_only":
			technical_only = true;
			break;
		}
	}

	preset = undefined;
	if ( IsDefined( self.script_parameters ) )
	{
		preset = level.spark_presets[ self.script_parameters ];
	}

	for ( ;; )
	{
		self waittill( "trigger", other );

		if ( IsDefined( touched[ other.unique_id ] ) )
			continue;

		if ( technical_only )
		{
			if ( IsDefined( level.traffic_jam_truck ) )
			{
				if ( other != level.traffic_jam_truck )
					continue;
			}
			else
				continue;
		}

		touched[ other.unique_id ] = true;
		other thread vehicle_sparks( org1, org2, preset );
	}
}

vehicle_sparks( org1, org2, preset )
{
	fx = getfx( "vehicle_scrape_sparks" );
	no_spark_frame = RandomInt( 4 );

	technical = IsDefined( level.traffic_jam_truck ) && self == level.traffic_jam_truck;
	angles = preset;

	for ( ;; )
	{
		my_org = self.origin;
		if ( IsDefined( self.spark_offset ) )
		{
			my_org += self.spark_offset;
		}
		spark_org = PointOnSegmentNearestToPoint( org1, org2, my_org );
		if ( spark_org == org2 )
			return;

		no_spark_frame--;

		if ( no_spark_frame && spark_org != org1 )
		{
			angle_range = RandomFloatRange( -85, -55 );

			if ( !isdefined( preset ) )
			{
				angles = VectorToAngles( spark_org - self.origin );
				angles = ( angle_range, angles[ 1 ], 0 );
			}

			//Line( spark_org, self.origin, (1,0,0), 1, 1, 500 );
			up = AnglesToUp( angles );
			forward = AnglesToForward( angles );

			fast_enough = technical || self.veh_speed > 2;

			if ( fast_enough )
			{
				//Line( spark_org, spark_org + forward * 100, (1,0,0), 1, 1, 500 );
				PlayFX( fx, spark_org, forward, up );
			}
		}

		if ( !no_spark_frame )
			no_spark_frame = RandomInt( 2 ) + 3;

		wait( 0.05 );
	}
}

humvee_gunner_idle_until_player_gets_in( owner, turret )
{
	level endon( "player_gets_in" );
	anims = [];
	anims[ "humvee_turret_bounce" ] 				= true;
//	anims[ "humvee_turret_idle_lookback" ]		= %humvee_turret_idle_lookback;
	anims[ "humvee_turret_idle_lookbackB" ]			= true;
	anims[ "humvee_turret_idle_signal_forward" ]	= true;
	anims[ "humvee_turret_idle_signal_side" ]		= true;
	anims[ "humvee_turret_radio" ]					= true;
	anims[ "humvee_turret_flinchA" ]				= true;
	anims[ "humvee_turret_flinchB" ]				= true;
	//anims[ "humvee_turret_rechamber" ]			= %humvee_turret_rechamber;
	
	foreach ( anime, _ in anims )
	{
		wait( 2 );
		level.anime = anime;
		owner turret_gunner_custom_anim( turret, anime );
		if ( flag( "shot_rings_out" ) )
			return;
	}	
}

detour_vehicle_driver_animates()
{
	owner = undefined;
	turret = undefined;

	turret = self.mgturret[0];
	for ( ;; )
	{
		owner = turret getturretowner();
		if ( isalive( owner ) )
			break;
		wait( 0.05 );
	}
	
	owner endon( "death" );
	level.detour_gunner = owner;

	if ( !isdefined( owner.magic_bullet_shield ) )
	{
		owner magic_bullet_shield();
	}

	if ( !flag( "player_gets_in" ) )
	{
		humvee_gunner_idle_until_player_gets_in( owner, turret );
		wait( 1.5 );
	}
	
	if ( !flag( "100ton_bomb_goes_off" ) )
	{
		owner thread turret_gunner_custom_anim( turret, "humvee_turret_rechamber" );
		flag_wait( "100ton_bomb_goes_off" );
		wait( 3.5 );
		owner notify( "special_anim", "end" );
		owner turret_gunner_custom_anim( turret, "humvee_turret_flinchA" );
	}
	
	thread turret_gunner_cycles_custom_anims( owner, turret );
	flag_wait( "shot_rings_out" );
	
	struct = getstruct( "frantic_look_target_struct", "targetname" );
	ent = spawn( "script_origin", struct.origin );
	turret SetTargetEntity( ent );
	/#
	if ( getdebugdvarint( "showline" ) )
		turret thread entline( ent );
	#/
	
	count = 0;
	/*
	times = [];
	times[ 0 ] = 0.5;
	times[ 1 ] = 3.25;
	times[ 2 ] = 2.55;
	times[ 3 ] = 2.75;
	times[ 4 ] = 3.15;
	times[ 5 ] = 2.55;
	times[ 6 ] = 1.75;
	times[ 7 ] = 1.75;
	*/
	
	for ( ;; )
	{
		owner notify( "special_anim", "end" );
		//self notify( "do_custom_anim" );
		struct = getstruct( struct.target, "targetname" );
		
		dist = distance( ent.origin, struct.origin );
		time = dist / 5000;
		
		movetime = gettime();
		ent MoveTo( struct.origin, time, time * 0.2, time * 0.2 );
		
//		Line( turret.origin, struct.origin, (0,1,0), 1, 1, 1000 );
//		wait( times[ count ] );
//		count++;
		
		if ( !isdefined( struct.target ) )
			break;
	
		level waittill_notify_or_timeout( "shot_rings_out", 1.5 );
		wait_for_buffer_time_to_pass( movetime, 2 );
		
		wait( 0.1 );
	}
	
	ent delete();
}

entline( ent )
{
	ent endon( "death" );
	for ( ;; )
	{
		Line( ent.origin, self.origin );
		wait( 0.05 );
	}
}
	
turret_gunner_cycles_custom_anims( owner, turret )
{
//	level endon( "shot_rings_out" );
	anims = [];
	anims[ "humvee_turret_bounce" ] 				= true;
//	anims[ "humvee_turret_idle_lookback" ]		= %humvee_turret_idle_lookback;
	anims[ "humvee_turret_idle_lookbackB" ]			= true;
	anims[ "humvee_turret_idle_signal_forward" ]	= true;
	anims[ "humvee_turret_idle_signal_side" ]		= true;
	anims[ "humvee_turret_radio" ]					= true;
	anims[ "humvee_turret_flinchA" ]				= true;
	anims[ "humvee_turret_flinchB" ]				= true;
	//anims[ "humvee_turret_rechamber" ]			= %humvee_turret_rechamber;
	
	foreach ( anime, _ in anims )
	{
		wait( 2 );
		level.anime = anime;
		owner turret_gunner_custom_anim( turret, anime );
		if ( flag ( "shot_rings_out" ) )
			return;
	}	
}


// gets the turret doing a looping anim in anticipation of an AI getting on it later
turret_preload_animate()
{
	turret = self.mgturret[ 0 ];
	
	turret SetDefaultDropPitch( 0 );
	turret animscripts\hummer_turret\minigun_stand::setup_turret_anims();
	turret animscripts\hummer_turret\common::turret_animfirstframe( turret.passenger2turret_anime );
}

player_personal_convoy()
{
	switch( self.script_index )
	{
		case 0:
			level.crazy_ride_convoy[ "lead" ] = self;
			break;
		case 1:
			level.crazy_ride_convoy[ "player" ] = self;
			break;
		case 2:
			level.crazy_ride_convoy[ "rear" ] = self;
			self thread turret_preload_animate();
			break;
		case 3:
			level.crazy_ride_convoy[ "detour" ] = self;
			self thread turret_preload_animate();
			thread detour_vehicle_driver_animates();
			thread gunner_becomes_invul();
			break;
		default:
			AssertMsg( "err err!" );
			break;
	}
	
	
	self ent_flag_init( "can_shoot_the_baddies" );
	self ent_flag_init( "start_aiming_at_badguys" );
	

	level.crazy_ride_convoy[ self.script_index ] = self;
	waittillframeend;// wait for the array to fill in

	flag_wait( "player_gets_in" );

	/*
	node = GetVehicleNode( self.target, "targetname" );
	self Vehicle_SetSpeedImmediate( node.speed, 2, 2 );
	wait( 0.05 );
	self ResumeSpeed( 5 );
	*/

//	flag_wait( "player_rolls_into_town" );
	flag_wait( "start_runner" );
	if ( level.crazy_ride_convoy[ "player" ] == self )
	{
		self vehicle_setspeed( 8.79, 1, 1 );
	}
	if ( level.crazy_ride_convoy[ "rear" ] == self )
	{
		self vehicle_setspeed( 8.79, 1, 1 );
	}
	/*
	if ( level.crazy_ride_convoy[ "lead" ] == self )
	{
		self vehicle_setspeed( 8, 1, 1 );
	}
	if ( level.crazy_ride_convoy[ "detour" ] == self )
	{
		self vehicle_setspeed( 8, 1, 1 );
	}
	*/

	flag_wait( "player_closes_gap" );

	
	self ResumeSpeed( 5 );
		


	flag_wait( "ambush_auto_adjust_speed" );
		
	self ResumeSpeed( 5 );

	if ( self != level.crazy_ride_convoy[ "rear" ] )
		return;
		
	in_front_index = self.script_index - 1;
	near_car = level.crazy_ride_convoy[ in_front_index ];
	vehicles_maintain_distance_until_traffic( near_car );

	/*
	for ( ;; )
	{
		if ( Distance( near_car.origin, self.origin ) < 280 )
		{
			self.veh_brake = 0.5;
			break;
		}
	
		wait( 0.05 );
	}	
	*/
}

vehicles_maintain_distance_until_traffic( near_car )
{
	following = false;
//	level endon( "traffic_jam" );
	for ( ;; )
	{
		/*
		if ( flag( "lead_vehicle_speeds_up" ) && self == level.crazy_ride_convoy[ "player" ] )
		{
			self Vehicle_SetSpeed( 11, 5, 5 );
			wait( 3 );
			self ResumeSpeed( 5 );
			flag_clear( "lead_vehicle_speeds_up" );
		}
	
		*/
		if ( Distance( near_car.origin, self.origin ) < 300 )
		{
			self Vehicle_SetSpeed( near_car.veh_speed, 5, 5 );
			following = true;
		}
		else
		if ( following )
		{
			following = false;
			self ResumeSpeed( 5 );
		}
		wait( 0.05 );
	}
}

/*
lead_vehicle_func()
{
	level.lead_vehicle = self;
}

vehicle_ride_think()
{
	if ( self == level.lead_vehicle )
		return;
	for ( ;; )
	{
		lead_speed = level.lead_vehicle.veh_speed;
//		if ( self.veh_speed > lead_speed )
		if ( Distance( self.origin, level.lead_vehicle.origin ) < 200 )
			self Vehicle_SetSpeed( lead_speed, 5, 5 );
		wait( 0.05 );
	}
}
*/

convoy_gunner_think()
{
	level.convoy_gunners[ self.unique_id ] = self;
	thread aim_ahead_until_you_get_enemy();
}


convoy_gunners_pick_targets()
{
	array_thread( level.convoy_gunners, ::convoy_gunner_shoot_protection );
}

convoy_gunner_shoot_protection()
{
	if ( !isalive( self ) )
		return;

	self endon( "death" );
	for ( ;; )
	{
		self cant_die_unless_player_sees_me();
		self avoid_shooting_through_player();
		wait( 0.05 );
	}
}

cant_die_unless_player_sees_me()
{
	in_danger = within_fov_2d( level.player GetEye(), level.player GetPlayerAngles(), self.origin, 0.85 );

	if ( in_danger )
	{
		self.IgnoreRandomBulletDamage = false;
		self.attackeraccuracy = 1;
		if ( self.health > 100 )
			self.health = 100;
	}
	else
	{
		self.IgnoreRandomBulletDamage = true;
		self.attackeraccuracy = 0;
		self.health = 5000;
	}
}

avoid_shooting_through_player()
{
	// adjust the threatbias on the convoy gunners target so he doesn't shoot through the player excessively	
	enemy = self.enemy;
	if ( !isalive( enemy ) )
		return;

	if ( enemy.ignoreme )
		return;

	angles = VectorToAngles( level.player.origin - self.origin );
	if ( enemy within_fov_2d( level.player.origin, angles, enemy.origin, 0.85 ) )
	{
		enemy.ignoreme = true;
		enemy delayThread( 1, ::set_ignoreme, 0 );
	}
}

ent_line( ent1, ent2 )
{
	ent1 endon( "death" );
	ent2 endon( "death" );

	timer = 5;
	frames = timer * 20;
	for ( i = 0; i < frames; i++ )
	{
		Line( ent1.origin, ent2.origin );
		wait( 0.05 );
	}
}

enemy_ai_accuracy_effected_by_player_humvee()
{
	level endon( "player_knocked_down" );
	for ( ;; )
	{
		ai = GetAIArray( "axis" );
		foreach ( guy in ai )
		{
			if ( !isalive( guy ) )
				continue;

			if ( guy.weapon == "rpg" )
				continue;

			if ( within_fov_2d( level.player.origin, level.player_humvee.angles, guy.origin, 0.8 ) )
			{
				guy.baseaccuracy = 0.2;
			}
			else
			{
				guy.baseaccuracy = 0;
			}
			wait( 0.02 );
		}
		wait( 0.05 );
	}
}

traffic_jam_truck()
{
	level.traffic_jam_truck = self;
	self.vehicle_keeps_going_after_driver_dies = true;
	self.dontunloadonend = true;
	self.spark_offset = ( -64, 0, 0 );
	self godon();
	self.vehicle_stays_alive = true;
}

setup_ride_path_targets( noteworthy )
{
	spawners = GetEntArray( "ride_vehicle_spawner", "targetname" );
	foreach ( spawner in spawners )
	{
		nodes = spawner getLinkedVehicleNodes();
		found_node = false;
		foreach ( node in nodes )
		{
			if ( node.script_noteworthy != noteworthy )
				continue;

			found_node = true;

			// remap target to this node so we still spawn our riders
			remap_targets( spawner.target, node.targetname );
			spawner.target = node.targetname;
			break;
		}
		
		//AssertEx( found_node, "Didn't find a node with noteworthy " + noteworthy );
	}
}

remap_targets( ent_targetname, new_targetname )
{
	// remap them so the guys riding in the vehicle come along too
	ents = GetEntArray( ent_targetname, "targetname" );
	foreach ( ent in ents )
	{
		ent.targetname = new_targetname;
	}
}

spawn_more_street_baddies()
{
	spawners = level.more_street_spawners;
	wait( 7.5 );
	foreach ( spawner in spawners )
	{
		spawner.count = 1;
		spawner spawn_ai();
	}
}

ride_killer()
{
	level.ride_killer = self;
	self disable_pain();
	self.ignoreme = true;
	self magic_bullet_shield();
	/*
	player_vehicle = level.crazy_ride_convoy[ 1 ];
	//eye = spawn_tag_origin();
	//eye.origin = level.player GetEye();
	//eye LinkTo( level.player );
	//self SetEntityTarget( level.player );
	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
		guy.ignoreme = true;
	*/

	missile_target = GetEnt( "missile_target", "targetname" );
	self SetEntityTarget( missile_target );

	flag_wait( "player_knocked_down" );
	self stop_magic_bullet_shield();

	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		if ( IsDefined( guy.magic_bullet_shield ) )
			guy stop_magic_bullet_shield();
			
		if ( !isdefined( guy.dont_ride_kill ) )
			guy Kill();
	}

}

friendly_crash_think()
{
//	self.flashEndTime = GetTime() + 2500;
	//timer = RandomFloatRange( 2, 3 );
	//self flashBangStart( timer );
	level.crash_friendly[ level.crash_friendly.size ] = self;

	self magic_bullet_shield();
	self SetThreatBiasGroup( "ally_with_player" );

	self disable_pain();
	self endon( "death" );
	self.animname = self.animation;
	self thread anim_custom_animmode_solo( self, "gravity", "flashed" );
	wait( 0.05 );

	animtimes = [];
	animtimes[ "exposed_flashbang_v2" ] = 0.245;
	animtimes[ "exposed_flashbang_v3" ] = 0.36;
	animtimes[ "exposed_flashbang_v5" ] = 0.13;

	animlimits = [];
	animlimits[ "exposed_flashbang_v2" ] = 0.72;
	animlimits[ "exposed_flashbang_v3" ] = 0.79;
	animlimits[ "exposed_flashbang_v4" ] = 0.65;
	animlimits[ "exposed_flashbang_v5" ] = 0.65;

	animation = self getanim( "flashed" );
	animtime = animtimes[ self.animation ];
	if ( IsDefined( animtime ) )
	{
		self SetAnimTime( animation, animtime );
	}

	limit = animlimits[ self.animation ];
	if ( IsDefined( limit ) )
	{
		for ( ;; )
		{
			if ( self GetAnimTime( animation ) >= limit )
				break;
			wait( 0.05 );
		}
		self notify( "killanimscript" );
	}

	wait( 3 );
	flag_wait( "player_enters_ambush_house" );
	self enable_pain();

	// green guys can get killed and are replaced by cyan guys
	if ( self.script_forcecolor == "g" )
	{
		self stop_magic_bullet_shield();
		self thread replace_on_death();
		AssertEx( !self is_hero(), "A hero? No!" );
	}
}

move_flashed_spawner_and_spawn()
{
	if ( IsDefined( self.script_linkTo ) )
	{
		struct = getstruct( self.script_linkto, "script_linkname" );
		self.origin = struct.origin;
		self.angles = struct.angles;
	}

	wait( 0.25 );
	self spawn_ai();
}

/*
0.36	exposed_flashbang_v3
0.245	exposed_flashbang_v2
0.2		exposed_flashbang_v5
*/

blocker_driver()
{
	level.blocker_driver = self;
}

roadkill_ride_kill_drones()
{
	flag_wait( "kill_drones" );
	angry_drones = GetEntArray( "angry_drone", "script_noteworthy" );
	foreach ( drone in angry_drones )
	{
		if ( IsAlive( drone ) )
			drone Kill();
		else
			drone Delete();
	}

}

die_after_awhile ()
{
	self endon( "death" );
	timer = RandomFloatRange( 25, 35 );
	wait( timer );
	self Kill();
}


resumeslowly()
{
	self endon( "death" );
	time = 1.0;
	frames = time * 20;

	speed = 1;
	for ( i = 0; i < frames; i++ )
	{
		self Vehicle_SetSpeedImmediate( speed, 2, 2 );
		speed += 0.6;
		wait( 0.05 );
	}
	self ResumeSpeed( 1 );
}

crash_physics_explosion()
{
	struct = getstruct( "crash_physics_struct", "targetname" );
	physics_spawner = getstruct( "physics_spawner", "targetname" );
	targ = getstruct( physics_spawner.target, "targetname" );

	index = 0;
	models = [];
	models[ 0 ] = "com_soup_can";
	models[ 1 ] = "com_bottle1";
	models[ 2 ] = "com_soup_can";
	models[ 3 ] = "com_bottle1";
	models[ 4 ] = "me_plastic_crate1";

	angles = VectorToAngles( targ.origin - physics_spawner.origin );
	right = AnglesToRight( angles );

	for ( i = 0; i < 14; i++ )
	{

		org = targ.origin + randomvector( 200 );
		angles = VectorToAngles( org - physics_spawner.origin );
		forward = AnglesToForward( angles );

		force = forward * RandomFloatRange( 4000, 8500 );
//		force = randomvector( 160000 );

		model = models[ index ];
		index++;
		if ( index >= models.size )
			index = 0;

		ent = Spawn( "script_model", physics_spawner.origin );
		ent.origin += right * RandomFloatRange( -40, 40 );;
		ent SetModel( model );
		ent PhysicsLaunchClient( ent.origin, force );
	}

	PhysicsExplosionSphere( struct.origin, struct.radius, struct.radius, 0.4 );
}

goes_to_hell( vehicle_hell )
{
	self AttachPath( vehicle_hell );
	wait( 0.1 );
	self godoff();
	foreach ( rider in self.riders )
	{
		if ( IsAlive( rider ) && IsDefined( rider.magic_bullet_shield ) )
		{
			rider stop_magic_bullet_shield();
		}
	}
	RadiusDamage( self.origin, 128, 5000, 5000 );
}

run_away_die()
{
	self endon( "death" );
	self waittill( "goal" );
	wait( 3 );

	struct = getstruct( self.script_linkto, "script_linkname" );
	self SetGoalPos( struct.origin );
	self.goalradius = 4;
	self waittill( "goal" );
	self Kill();
}

player_doesnt_die_in_red_flashing()
{
	level endon( "ride_ends" );
	for ( ;; )
	{
		// a reasonable amount of spammity-spam, it's for a good cause.
		if ( level.player ent_flag( "player_has_red_flashing_overlay" ) )
			level.player.attackeraccuracy = 0;
		wait( 0.05 );
	}
}

school_guy_targets_school()
{
	if ( flag( "shepherd_moves_out" ) )
		return;
	level endon ( "shepherd_moves_out" );

	targets = getentarray( "school_target", "targetname" );

	for ( ;; )
	{
		targets = array_randomize( targets );
		foreach ( target in targets )
		{
			self SetEntityTarget( target );
			timer = randomfloatrange( 3, 6 );
			wait( timer );			
		}
	}
}

ambush_ally_spawner_think()
{
	level.ambush_allies_outside_vehicle++;
	self endon( "death" );
	//self.threatbias = 750; // they really want to shoot these guys more.
	self SetThreatBiasGroup( "ally_outside_school" );

	self magic_bullet_shield();
	flag_wait( "friendlies_suppress_school" );
	self.suppressionwait = 0;
	thread school_guy_targets_school();
	
	flag_wait( "shepherd_moves_out" );
	
	vehicle = getClosest( self.origin, level.ambushed_hummers );
	
	guy_runtovehicle_load( self, vehicle );
	self stop_magic_bullet_shield();
	level.ambush_allies_outside_vehicle--;
	if ( !level.ambush_allies_outside_vehicle )
		flag_set( "shepherd_vehicles_leave" );
			
	flag_wait( "the_end" );
	safe_delete();
	//flag_wait( "ambush_house_player_goes_upstairs" );
	//self stop_magic_bullet_shield();
}

join_school_threatbias_group_and_damage_func()
{
	unreachable = false;
	if ( isdefined( self.script_noteworthy ) )
	{
		unreachable = self.script_noteworthy == "school_unreachable_spawner";
	}
	
	if ( unreachable )
	{
		self SetThreatBiasGroup( "axis_school_unreachable" );
	}
	else
	{
		self SetThreatBiasGroup( "axis_school" );
	}
	self add_damage_function( ::remove_player_from_threatbias_group );
}

remove_player_from_threatbias_group( amt, attacker, force, b, c, d, e )
{
	if ( !isalive( attacker ) )
		return;
	if ( attacker != level.player )
		return;

	wait( 3 );

	// player shot me, put him in a threatbias group that I can fight him in
	level.player SetThreatBiasGroup( "allies" );
}

ambush_house_spawner_think()
{
	self SetThreatBiasGroup( "axis_ambush_house" );
}

friendlies_traverse_school()
{
	for ( i = 1; i <= 20; i++ )
	{
		// "roadkill_school_1", "roadkill_school_2", "roadkill_school_3", 
		// "roadkill_school_4", "roadkill_school_5", "roadkill_school_6"
		msg = "roadkill_school_" + i;
		trigger = GetEnt( msg, "targetname" );
		if ( flag_exist( msg ) )
		{
			flag_wait( msg );
			
			if ( msg == "roadkill_school_10" )
			{
				//flag_wait( "backend_baddies_spawned" );
				flag_wait_either( "school_back_baddies_dead", "roadkill_near_crossroads" );
			}
			
			volume = trigger get_color_volume_from_trigger();
			if ( IsDefined( volume ) )
				volume waittill_volume_dead_or_dying();

			trigger activate_trigger();
		}
	}
}

hidden_room_spawner()
{
	self endon( "death" );
	self set_force_cover( true );
	
	add_wait( ::can_see_player );
	add_wait( ::flag_wait, "hidden_guy_opens_fire" );
	do_wait_any();

	self set_force_cover( false );
}

can_see_player()
{
	self endon( "death" );
	for ( ;; )
	{
		if ( self cansee( level.player ) )
			return;
		wait( 0.05 );
	}
}

cutting_history_class_dialogue()
{
	flag_wait( "cutting_through_history" );
	
	// I'm cutting through history class.	
	dunn_line( "roadkill_cpd_historyclass" );
	
	// Roger that.	
	foley_line( "roadkill_fly_rogerthat" );
}


ambush_house_slowbie()
{
	self.moveplaybackrate = 0.76;
	self.attackeraccuracy = 1000;
}

player_impact_earthquake()
{
	Earthquake( 0.25, 0.8, level.player.origin, 5000 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	
	level.player PlayRumbleLoopOnEntity( "damage_light" );
	flag_wait( "player_goes_in_reverse" );
	level.player stoprumble( "damage_light" );
}

traffic_truck_pushed()
{
	struct = getstruct( "truck_contact_point", "targetname" );
	targ = getstruct( struct.target, "targetname" );
	
	vec = vectornormalize( targ.origin - struct.origin );
	vec *= 2;
	
	level.traffic_jam_truck VehPhys_Launch( vec, (0,0,0), targ.origin );
}


force_player_vehicle_speed( speed )
{
	level notify( "new_force_player_speed" );
	level endon( "new_force_player_speed" );
	player_vehicle = level.crazy_ride_convoy[ 1 ];
	level endon( "stop_updating_player_vehicle_speed" );
	for ( ;; )
	{
		player_vehicle Vehicle_SetSpeedImmediate( speed, 2, 2 );
		wait( 0.05 );
	}
}

radius_damage_in_front()
{
	level endon( "stop_updating_player_vehicle_speed" );
	flag_wait( "push_hurts_technical" );
	level.traffic_jam_truck godoff();

	damage = 60;
	for ( ;; )
	{
//		forward = AnglesToForward( self.angles );
//		org = self.origin + forward * 140 + (0,0,40);
//		Print3d( level.traffic_jam_truck.origin, "x", (1,0,0), 1, 2 );
		RadiusDamage( level.traffic_jam_truck.origin, 25, damage, damage, level.player );
		if ( level.traffic_jam_truck.health < 18000 )
		{
			level.traffic_jam_truck.health = 18000;
		}

		wait( 0.05 );
	}
}

lead_vehicle_starts_going_again()
{
	wait( 0.75 );
	self Vehicle_SetSpeed( 16, 2, 2 );
	self.veh_brake = 0;
}

player_pushes_truck_down_alley()
{
	player_vehicle = level.crazy_ride_convoy[ 1 ];
	rear_vehicle = level.crazy_ride_convoy[ 2 ];
	lead_vehicle = level.crazy_ride_convoy[ 0 ];
	
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isdefined( level.traffic_jam_truck ) )
			continue;
		if ( other == level.traffic_jam_truck )
			break;
	}

	flag_set( "we're cut off" );
	queue = GetTime();

	player_vehicle.veh_brake = 1.0;
	player_vehicle vehicle_setspeed( 8, 1, 1 );

	wait( 0.25 );
	rear_vehicle.veh_brake = 0.5;
	lead_vehicle delaythread( 2, ::set_brakes, 0.5 );
	
	level.traffic_jam_truck.veh_brake = 0.5;
	
	//wait( 2 );

	// 0.8 dot
	// 0.5 time spent looking at it
	// 10 seconds until timeout	
	level.traffic_jam_truck waittill_player_lookat( 0.6, 0.5, undefined, 8 );
	delaythread( 0, ::technical_pushed_animation );
	wait( 0.2 );
	
	flag_set( "push_through" );
	//level.traffic_jam_truck thread dump_vehicle_bones();
	wait( 0.5 );
	player_vehicle.veh_brake = 0;
	player_vehicle vehicle_setspeed( 24, 10, 10 );
	rear_vehicle.veh_brake = 0;	
	
	lead_vehicle thread lead_vehicle_starts_driving_again();
	
	wait( 0.65 );

	flag_set( "resume_the_path" );
// brakes cleared by main thread
//	level.traffic_jam_truck.veh_brake = 0;

	tech_target_org = getstruct( "tech_target_org", "targetname" );

	level.traffic_jam_truck vehicleDriveTo( tech_target_org.origin, 25 );
	level.traffic_jam_truck.veh_brake = 0;

	wait( 1.1 );

	timer = 3;
	frames = timer * 20;

	for ( ;; )
	{
		level.traffic_jam_truck Vehicle_SetSpeedImmediate( 6, 1, 1 );
		frames -= 1;
		if ( frames <= 0 )
			break;
		wait( 0.05 );
	}

	level.traffic_jam_truck Vehicle_SetSpeedImmediate( 0, 1, 1 );
	level.traffic_jam_truck.veh_brake = 1.0;// 0.1;

	wait_for_buffer_time_to_pass( queue, 5.5 );
	level.traffic_jam_truck.vehicle_stays_alive = undefined;
}

lead_vehicle_starts_driving_again()
{
	wait( 3.5 );
	self.veh_brake = 0;
	self vehicle_setspeed( 12, 1, 1 );
	//lead_vehicle delaythread( 3.5, ::set_brakes, 0.0 );
}

dump_vehicle_bones()
{
	start_time = gettime();
	for ( ;; )
	{
		tag_origin_pos = self gettagorigin( "tag_origin" );
		tag_origin_ang = self gettagangles( "tag_origin" );
		
		tag_body_pos = self gettagorigin( "tag_body" );
		tag_body_ang = self gettagangles( "tag_body" );
		
		time = gettime() - start_time;
		println( "Time: " + time + " tag_origin: " + tag_origin_pos + " " + tag_origin_ang + " tag_body:" + tag_body_pos + " " + tag_body_ang );
		wait( 0.05 );
	}
}


/*
axis_flee_riverbank()
{
	flag_set( "riverbank_baddies_retreat" ); // controls the guys in the windows
	volumes = getentarray( "riverbank_building_volume", "script_noteworthy" );
	nodes = getnodearray( "enemy_riverbank_flee_node", "targetname" );
	index = 0;
	
	ai = getaiarray( "axis" );
	foreach ( guy in ai )
	{
		if ( !isalive( guy ) )
			continue;
		
		touching_house = false;
		foreach ( vol in volumes )
		{
			if ( guy istouching( vol ) )
			{
				touching_house = true;
				break;
			}	
		}

		if ( touching_house )
		{
			timer = randomfloat( 3.2 );
			guy delaycall( timer, ::kill );
		}
		else
		{
			node = nodes[ index ];
			index++;
			index %= nodes.size;
			
			guy setgoalnode( node );
			guy.goalradius = 64;
			guy.ignoreall = true;
			guy thread delete_on_goal();
			timer = randomfloat( 1.2 );
			wait( timer );
		}
	}	
}
*/

delete_on_goal()
{
	self endon( "death" );
	self waittill( "goal" );
	self delete();
}

player_learned_javelin()
{
	return level.player GetCurrentWeapon() == "javelin";
}
	
detect_player_switched_to_javelin()
{
	for ( ;; )
	{
		if ( level.player GetCurrentWeapon() == "javelin" )
			break;
		wait( 0.05 );
	}
	
	flag_set( "player_switched_to_javelin" );
}

remind_player_to_switch_to_javelin()
{
	lines = [];
	// Brodsky, switch to your Javelin!	
	lines[ 0 ] = "roadkill_fly_switchtojavelin";
	// Brodsky, use your Javelin to take out the armor!	
	lines[ 1 ] = "roadkill_fly_takeoutarmor";

	index = 0;
	for ( ;; )
	{
		timer = 9 + randomintrange( 2, 5 );
		frames = timer * 20;
		for ( i = 0; i < frames; i++ )
		{
			if ( level.player getCurrentWeapon() == "javelin" )
				return;
			wait( 0.05 );
		}
	
		theLine = lines[ index ];
		index++;
		index %= lines.size;

		// wait until everybody stops talking		
		while ( level.dialogue_function_stack_struct.function_stack.size )
			wait( 0.05 );
			
		if ( level.player getCurrentWeapon() == "javelin" )
			return;
		foley_line( theLine );
	}
}	

/*
foley_javelin_reminders()
{
	remind_player_to_switch_to_javelin();

	remind_player_to_shoot_targets();
}
*/

/*
detect_player_missile_fire()
{
	level endon( "bmps_destroyed" );
	level.last_missile_fire_time = gettime() - 5000; // bias the time he starts complaining if you dont shoot
	
	count = 0;
	
	for ( ;; )
	{
		level.player waittill( "missile_fire" );
		count++;
		// missile_fire_1 missile_fire_2 missile_fire_3
		flag_set( "missile_fire_" + count );
		level.last_missile_fire_time = gettime();	
		if ( count >= 3 )
			return;
	}
}

remind_player_to_shoot_targets()
{
	if ( flag( "bmps_destroyed" ) )
		return;
	level endon( "bmps_destroyed" );

	level.last_missile_fire_time = gettime() - 5000; // bias the time he starts complaining if you dont shoot
	
	lines = [];
	// Target that armored vehicle with your Javelin!	
	lines[ 0 ] = "roadkill_fly_targetvehicle";
	// Engage that armored vehicle across the river! 	
	lines[ 1 ] = "roadkill_fly_acrossriver";
	// Brodsky, use your Javelin to take out the armor!	
	lines[ 2 ] = "roadkill_fly_takeoutarmor";
	
	index = 0;
	for ( ;; )
	{
		// wait until everybody stops talking		
		if ( foley_should_talk() )
		{
			theLine = lines[ index ];
			index++;
			index %= lines.size;
			
			foley_line( theLine );
			level.last_missile_fire_time = gettime();
		}
		wait( 0.05 );
	}
}
*/

foley_should_talk()
{
	if ( gettime() <= level.last_missile_fire_time + 19000 )
		return false;
		
	return !level.dialogue_function_stack_struct.function_stack.size;
}

enter_riverbank_foley_shepherd_dialogue()
{
	wait( 14 );
	
	// Hunter Two! Keep up the pressure on those RPG teams! If that bridgelayer gets hit, we're swimming, huah?	
	foley_line( "roadkill_fly_wereswimming" );
	wait( 1 );
	flag_set( "intro_lines_complete" );
}

introlines_delay()
{
	flag_wait( "intro_lines_complete" );
}

airstrike_call_in_dialogue()
{
	if ( !is_default_start() )
		return;
		
	wait( 0.74 );
	// Warlord, Warlord, this is Hunter 2-1, requesting air strike at grid 2-5-2, 1-7-1! Target is a white, 
	// twelve story apartment building occupied by hostile forces, over!
	
	//	Warlord, Warlord, this is 
	//
	shepherd_line( "roadkill_cpd_airstrike" );

	// Hunter 2-1, this is Warlord, solid copy, uh, I have Devil 1-1, flight of two F-15s, on the line, standby for relay.	
	radio_line( "roadkill_auc_ontheline" );

	wait( 0.9 );

	// Hunter 2-1 this is Devil 1-1, flight of two F-15s, time on station, one-five mikes, 
	// holding at three-Sierra, northwest, holding area Knife, carrying two JDAMs and two HARMs, over.	
	radio_line( "roadkill_fp1_devil11" );

	// Devil 1-1, this is Hunter 2-1, solid copy on check-in, standby.	
//	dunn_line( "roadkill_cpd_checkin" );

	// Standing by.	
	radio_line( "roadkill_fp1_standingby" );

	// Devil 1-1, target is a white, twelve story apartment building at grid 2-5-2, 1-7-1. I need you to 
	// level that building, how copy over?	
	shepherd_line( "roadkill_cpd_levelbuilding" );

	// Solid copy Hunter 2-1. Rolling in now... Target acquired.	
	radio_line( "roadkill_fp1_targetacquired" );

}

ambushed_hummer()
{
	level.ambushed_hummers[ level.ambushed_hummers.size ] = self;
	self VehPhys_DisableCrashing();
	self.dontDisconnectPaths = true;
	flag_wait( "shepherd_vehicles_leave" );
	node = getvehiclenode( self.target, "targetname" );
	dist = distance( self.origin, node.origin );
	time = dist * 0.005;
	wait( time );
	self gopath();
}

put_noteworthy_in_magic_chatter()
{
	level.convoy_dialogue_guy[ self.script_noteworthy ] = self;
}

get_convoy_dialogue_guy( name )
{
	if ( isalive( level.convoy_dialogue_guy[ name ] ) )
		return level.convoy_dialogue_guy[ name ];

	index = 0;
	ai = getaiarray( "allies" );
	guys = [];
	
	foreach ( guy in ai )
	{
		if ( !isalive( guy ) )
			continue;

		if ( guy is_hero() )
			continue;

		if ( isdefined( guy.convoy_guy ) )
			continue;

		guy.convoy_guy = true;
		level.convoy_dialogue_guy[ name ] = guy;
		return guy;
	}
}

magic_dialogue_queue( msg, name )
{
	guy = get_convoy_dialogue_guy( name );
	
	assertex( isalive( guy ), "Couldn't find a guy to do line " + msg );

	//guy thread printer();
	guy generic_dialogue_queue( msg );	
	wait( 0.25 );
}

printer()
{
	frames = int(2.5*20);
	for ( i = 0; i < frames; i++ )
	{
		Print3d( self geteye(), "*" );
		wait( 0.05 );
	}
}

south( dist )
{
	return level.player.origin + ( 0, dist * -1, 0 );
}

charpos( guy )
{
	org = level.player.origin;
	if ( flag( "100ton_bomb_goes_off" ) )
		org = level.locked_player_position;
		
	unit = 128;
	switch( guy )
	{
		case "ar1":
			return org + (unit,0,0);
		case "ar2":
			return org + (unit,unit,0);
		case "ar3":
			return org + (unit * -1,0,0);
		case "ar4":
			return org + (unit * -1,unit * -0.5,0);
		case "ar5":
			return org + (unit,unit * -0.5,0);
		case "farguy":
			return org + ( unit * 15, unit * 15, 0 );

		case "left":
			return org + ( unit * -2, 0, 0 );
		case "left_back":
			return org + ( unit * -2, -1000, 0 );
		case "left_back_more":
			return org + ( unit * -2, -3000, 0 );

		case "right_forward":
			return org + ( unit * 2, 1000, 0 );

		case "right_forward_more":
			return org + ( unit * 2, 1500, 0 );


		case "right_rear_back":
			return org + ( unit * 2, -5200, 0 );
			
		case "cpd":
			return org + (unit * 0.5,unit * 0.5,unit * -0.2);
		default:
			return org + (0,0,0);
	}
}

airstrike_completion_dialogue_and_exploder()
{
	time = 2.5;
	
	// Which building is it sir?	
	delaythread( time, ::play_sound_in_space, "roadkill_ar1_whichbuilding", charpos( "ar1" ) );
	time += 1.8;
	
	// The tall one at 1 o'clock.	
	delaythread( time, ::play_sound_in_space, "roadkill_ar2_tallone", charpos( "ar2" ) );
	time += 2.5;


	// Hey dawg, which building?	
	delaythread( time, ::play_sound_in_space, "roadkill_ar3_heydawg", charpos( "left" ) );
	time += 1.7;

	////////////////////////////////
	// How long will it record for?	
	delaythread( time + 2, ::play_sound_in_space, "roadkill_ar1_howlong", charpos( "right_rear_back" ) );
	
	// I dunno, till it runs out man.	
	delaythread( time + 3.75, ::play_sound_in_space, "roadkill_ar2_runsout", charpos( "right_rear_back" ) );
	////////////////////////////////

	// The one at 1 o'clock, the tall - hey Dave, which one is it? Is it the one of the left or the right?	
	delaythread( time, ::play_sound_in_space, "roadkill_ar4_whichone", charpos( "left_back" ) );
	time += 4.6;

	// The one on the left.	
	delaythread( time, ::play_sound_in_space, "roadkill_ar5_oneonleft", charpos( "left_back_more" ) );
	time += 2.5;



	// You gonna tape this one? You got enough memory left?	
	delaythread( time, ::play_sound_in_space, "roadkill_ar4_memoryleft", charpos( "right_forward" ) );
	time += 2.5;
	
	// Huah, should be good.	
	delaythread( time, ::play_sound_in_space, "roadkill_ar5_shouldbegood", charpos( "right_forward_more" ) );
	time += 1.5;


	// 10 seconds!! 	
	delaythread( time, ::play_sound_in_space, "roadkill_ar1_10seconds", south( 5000 ) );
	time += 1.1;

	// 10 seconds!! 	
	delaythread( time, ::play_sound_in_space, "roadkill_ar2_10seconds", south( 3500 ) );
	time += 0.8;

	// 10 seconds!! 	
	delaythread( time, ::play_sound_in_space, "roadkill_ar3_10seconds", south( 1200 ) );
	time += 3.3;


	// What's goin' on.	
	// What's the hold up?	
	//roadkill_ar4_goinon broken
	delaythread( time, ::play_sound_in_space, "roadkill_ar3_holup", charpos( "right_rear_back" ) );
	time += 1.5;
	
	// Shepherd called in a major fire mission.	
	delaythread( time, ::play_sound_in_space, "roadkill_ar5_majorfire", charpos( "right_rear_back" ) );
	time += 3.5;
	
	/*
	// Hey isn't this danger close for the task force?	
	delaythread( time, ::magic_dialogue_queue, "roadkill_ar3_dangerclose", "ar3" );
	level.scr_sound[ "generic" ][ "roadkill_ar3_dangerclose" ] = "roadkill_ar3_dangerclose";
	
	// Since when does Shepherd care about danger close?	
	level.scr_sound[ "generic" ][ "roadkill_cpd_sincewhen" ] = "roadkill_cpd_sincewhen";

	
	

	// Cleared hot!	
//	delaythread( time + 2, ::dunn_line, "roadkill_cpd_clearedhot" );
	
	// Devil 1-1 off safe. Bombs away bombs away.	
	delaythread( time + 5.5, ::radio_line, "roadkill_fp1_offsafe" );

	time += 2;
	
	// What's the hold up?	
	delaythread( time, ::magic_dialogue_queue, "roadkill_ar3_holup", "ar3" );
	time += 1.5;
	
	// Shepherd called in a major fire mission!	
	delaythread( time, ::magic_dialogue_queue, "roadkill_cpd_majorfiremission", "cpd" );
	time += 2.5;
	*/
	
	// Hey isn't this danger close for the task force?	
	delaythread( time, ::play_sound_in_space, "roadkill_ar3_dangerclose", charpos( "ar3" ) );
	time += 2.4;

	// Since when does Shepherd care about danger close?	
	delaythread( time, ::play_sound_in_space, "roadkill_cpd_sincewhen", charpos( "cpd" ) );
	time += 1;
		
	video_taper_offset = 0.75;
	wait( time - video_taper_offset );
	
	flag_set( "video_tapers_react" );
		
	wait( video_taper_offset );
	//exploder( "town_bombed" );
	//exploder( "white_bomb" );
	exploder( "100ton_bomb" );
	thread roadkill_bomb_physics_explosion();
	thread collapsing_building();
	thread collapse_earthquake();
	thread fence_rattle();

	level.player delaythread( 3.6, maps\_gameskill::grenade_dirt_on_screen, "left" );
	level.locked_player_position = level.player.origin;
	flag_set( "100ton_bomb_goes_off" );
	start_time = gettime();
	wait( 0.25 );
		
	/*
	// Huah!! Get some!	
	delaythread( 0.9, ::magic_dialogue_queue, "roadkill_cpd_getsome", "cpd" );

	// Huah! Hell yea!	
	delaythread( 0.95, ::magic_dialogue_queue, "roadkill_ar1_huahyeah", "ar1" );
	
	// Yeah! 	
	delaythread( 1.0, ::magic_dialogue_queue, "roadkill_ar1_yeah", "ar3" );
	
	// Woo! Yeah!	
//	delaythread( 1.25, ::magic_dialogue_queue, "roadkill_ar2_wooyeah", "ar2" );
	
	// Whoa!	
	delaythread( 1.8, ::magic_dialogue_queue, "roadkill_ar1_whoa", "dunn" );
	*/
	
		
	time = 0.9;
	// BOOM!	
	delaythread( time, ::play_sound_in_space, "roadkill_ar1_boom", charpos( "ar1" ) );
	delaythread( time, ::play_sound_in_space, "roadkill_ar2_wooyeah", charpos( "ar1" ) );	
	delaythread( time, ::play_sound_in_space, "roadkill_ar1_yeah", charpos( "ar4" ) );
	time += 0.2;
	
	// --ck yeah!	
	delaythread( time, ::play_sound_in_space, "roadkill_ar2_catcalls", charpos( "ar2" ) );
	time += 1.1;
	delaythread( time, ::play_sound_in_space, "roadkill_ar3_catcalls", charpos( "ar3" ) );
	time += 0.9;
	delaythread( time, ::play_sound_in_space, "roadkill_cpd_getsome", charpos( "cpd" ) );
	time += 0.2;
	delaythread( time, ::play_sound_in_space, "roadkill_ar2_yeah", charpos( "ar2" ) );
	time += 0.8;
	
	delaythread( time, ::play_sound_in_space, "roadkill_ar1_huahyeah", charpos( "ar5" ) );
	time += 0.2;
	
	// Wooo!!!	
	//delaythread( time, ::play_sound_in_space, "roadkill_ar3_woo", charpos( "ar3" ) );
	//time += 0.2;
	
	// Yeah!!!	
//	delaythread( time, ::play_sound_in_space, "roadkill_ar4_yeah", charpos( "ar4" ) );
	time += 0.5;

	// You don't get this on the 4th of July!	
	delaythread( time, ::play_sound_in_space, "roadkill_ar1_4thofjuly", charpos( "ar1" ) );
	time += 1.65;


	// Battalion is oscar mike!!!	// roadkill_ar1_battalionom is misspronounced!
	delaythread( time, ::play_sound_in_space, "roadkill_ar4_oscarmike", charpos( "ar1" ) );
	time += 1.0;
	
	delaythread( time, ::flag_set, "convoy_oscar_mike_after_explosion" );
	
	// All right, we're oscar miiike!!!	
	delaythread( time, ::play_sound_in_space, "roadkill_cpd_oscarmike", charpos( "cpd" ) );
	time += 0.9;
	
	// We're on the move!!!	
	delaythread( time, ::play_sound_in_space, "roadkill_ar3_onthemove", charpos( "ar3" ) );
	time += 1.4;
	
	// Roger that!!	
	delaythread( time, ::play_sound_in_space, "roadkill_ar4_rogerthat", charpos( "ar4" ) );
	time += 2.0;

	// That was hot man...	
	delaythread( time, ::play_sound_in_space, "roadkill_ar5_hotman", charpos( "ar5" ) );
	time += 2.0;

	// The networks are gonna pay big for this one!	
	delaythread( time, ::play_sound_in_space, "roadkill_cpd_paybig", charpos( "cpd" ) );
	time += 2.2;
	// Keep dreamin video boy!	
	delaythread( time, ::play_sound_in_space, "roadkill_ar2_keepdreamin", charpos( "ar2" ) );
	time += 1.8;
	// No man, seriously, that was extreme!	
	delaythread( time, ::play_sound_in_space, "roadkill_cpd_extreme", charpos( "cpd" ) );



	
	
	// Whoa!	
//	delaythread( 2.4, ::magic_dialogue_queue, "roadkill_ar2_yeahcough", "fly" );
	
	// cough
//	delaythread( 3, ::magic_dialogue_queue, "roadkill_gar_cough1", "ar1" );
	
//	allies = getaiarray( "allies" );
//	get_array_of_closest( level.player.origin, allies );
//	origins = [];
//	for ( i = 0; i < allies.size; i++ )
//	{
//		origins[ i ] = allies[ i ].origin;
//	}
//
//	delaythread( 3.1, ::play_sound_in_space, "roadkill_gar_cough1", origins[ 0 ] );
//	delaythread( 3.3, ::play_sound_in_space, "roadkill_gar_cough2", origins[ 1 ] );
//	delaythread( 3.5, ::play_sound_in_space, "roadkill_gar_cough3", origins[ 2 ] );
//	delaythread( 3.8, ::play_sound_in_space, "roadkill_gar_cough4", origins[ 3 ] );
//	delaythread( 4.1, ::play_sound_in_space, "roadkill_gar_cough5", origins[ 4 ] );
//	delaythread( 4.5, ::play_sound_in_space, "roadkill_gar_cough6", origins[ 5 ] );
	

	/*

	// Huah!	
	delaythread( time, ::magic_dialogue_queue, "roadkill_ar2_huah", "ar2" );
	time += 0.3;
	*/
	
	//roadkill_ar1_whoa
	
	wait_for_buffer_time_to_pass( start_time, 7.15 );
	
	
	/*
	// The networks are gonna pay big for this one!	
	magic_dialogue_queue( "roadkill_cpd_paybig", "network_chatter_spawner1" );
	
	// Keep dreamin video boy!	
	magic_dialogue_queue( "roadkill_ar2_keepdreamin", "network_chatter_spawner2" );
	
	// No man, seriously, that was extreme!	
	magic_dialogue_queue( "roadkill_cpd_extreme", "network_chatter_spawner1" );
	*/	
}

convoy_moves_out_dialogue()
{
	if ( !is_default_start() )
		return;
		
	// Hunter Two! Bridge complete, we're oscar mike! Move out!!	
	foley_line( "roadkill_fly_bridgecomplete" );
		
	// We're movin' out!!	
	dunn_line( "roadkill_cpd_movinout" );
	
	// Get your ass back in the vehicle!	
	time = 0.05;
	delaythread( time, ::magic_dialogue_queue, "roadkill_ar3_backinvehicle", "ar3" );
	time += 1.3;
	
	// Battalion is oscar mike!!!	
	delaythread( time, ::magic_dialogue_queue, "roadkill_ar4_oscarmike", "ar4" );
	time += 1.2;

	wait( time );
	
	/*
	// Hu-ahh!! What was that, a 1000 pounder?	
	guys[ "chat_ar3" ] generic_dialogue_queue( "roadkill_ar3_whatwasthat" );
	
	time = 0.05;
	// I dunno but damn that was kick ass, huah?	
	guys[ "chat_ar4" ] delaythread( time, ::generic_dialogue_queue, "roadkill_ar4_idunno" );
	time += 1.2;
	*/
	
	// We're oscar mike, move it!	
	delaythread( time, ::magic_dialogue_queue, "roadkill_fly_oscarmike", "fly" );
	time += 0.6;
	
	// We're oscar mike!	
	delaythread( time, ::magic_dialogue_queue, "roadkill_ar2_oscarmike", "ar2" );
	time += 0.6;
	
	// If you have to do #2 go now because once I start the car I am not stoppin', huah?	
	delaythread( time, ::magic_dialogue_queue, "roadkill_cpd_notstoppin", "cpd" );
	time += 3.2;
	
	wait( time );	

	if ( flag( "player_gets_in" ) )
		return;
	level endon( "player_gets_in" );
		
	// We're moving out now!	
	thread magic_dialogue_queue( "roadkill_fly_movingout", "fly" );
	wait( 1.2 );
	
	// Mount up!	
	thread magic_dialogue_queue( "roadkill_fly_mountup", "fly" );
	wait( 0.5 );

	// We're oscar mike!	
	thread magic_dialogue_queue( "roadkill_ar2_oscarmike", "ar2" );
}


random_ai_line( msg )
{
	ai = getaiarray( "allies" );
	ai = get_array_of_closest( level.player.origin, ai, undefined, 5 );
	guy = random( ai );
	if ( !isalive( guy ) )
		return;
	guy generic_dialogue_queue( msg );
}

warn_if_player_shoots_prematurely()
{
	if ( flag( "ambush_spawn" ) )
		return;
		
	level endon( "ambush_spawn" );
	
	
	lines = [];
	// Allen, what are you shooting at, there's nothing there! Cease fire!
	lines[ 0 ] = "roadkill_fly_nothingthere";
	// Allen, stand down! The ROE dictates we can’t fire unless fired upon!
	lines[ 1 ] = "roadkill_fly_standdown";
	// Allen! Cease fire!
	lines[ 2 ] = "roadkill_fly_ceasefire";
	
	index = 0;
	
	//thread fail_player_for_excessive_firing();	
	for ( ;; )
	{
		if ( player_shoots_at_non_enemy() )
		{
			wait( 1.5 );
		}
					
		if ( player_shoots_at_non_enemy() )
		{
			theLine = lines[ index ];
			index++;
			index %= lines.size;
			foley_line( theLine );
			wait( 1 );
		}
		wait( 0.05 );
	}
}

player_shoots_at_non_enemy()
{
	if ( !level.player attackbuttonpressed() )
		return false;
	
	ai = getaiarray( "axis" );
	angles = level.player getplayerangles();
	dotforward = AnglesToForward( angles );
	start = level.player geteye();

	foreach ( guy in ai )
	{
		angles = VectorToAngles( guy.origin - start );
		forward = AnglesToForward( angles );

		dot = VectorDot( dotforward, forward );
		if ( dot > 0.86 )
			return false;
	}

	return true;
}

	
fail_player_for_excessive_firing()
{
	if ( flag( "ambush_spawn" ) )
		return;
		
	level endon( "ambush_spawn" );

	count = 0;
	time = 5;
	sustained_firing_frames = time * 20;
	for ( ;; )
	{
		if ( level.player attackbuttonpressed() )
		{
			count += 1;
		}
		else
		{
			// penality wears off slower than it gains so you can't just fire little bursts overand over
			count -= 0.25;
		}
		if ( count <= 0 )
			count = 0;
		
		if ( count > sustained_firing_frames )
			break;
		
		wait( 0.05 );
	}

	setdvar( "ui_deadquote", &"ROADKILL_SHOT_TOO_MUCH" );
	missionFailedWrapper();	

}

stryker_think()
{
	self.veh_pathtype = "constrained";
	flag_wait( "player_gets_in" );
	self.veh_pathtype = "follow";
}

fence_rattle()
{
	
	
	pivot = getent( "animated_bridge_fence_pivot", "targetname" );
	//pivot thread maps\_debug::drawOrgForever();

	wait( 3.25 );
	animated_bridge_fences = getentarray( "animated_bridge_fence", "targetname" );
	
	foreach ( piece in animated_bridge_fences )
	{
		piece notsolid();
		piece setcontents( 0 );
		piece linkto( pivot );
	}

	start_angles = pivot.angles;

	amount = -25;
	for ( ;; )
	{
		time = abs( amount ) * 0.0475;
		if ( time < 0.75 )
			time = 0.75;
		pivot rotateto( (0,90,amount), time, time * 0.5, time * 0.5 );
		amount *= -0.65;
		wait( time );
		if ( abs( amount ) <= 2 )
			break;
	}
	pivot rotateto( start_angles, 0.2 );	
	wait( 0.5 );
	pivot delete();
}

collapse_earthquake()
{

	wait( 1.1 );
	level.player PlayRumbleOnEntity( "collapsing_building" );	
	Earthquake( 0.3, 2, ( -2556.2, -702.2, 1446 ), 15000 );
	wait( 2.4 );
	Earthquake( 0.15, 0.6, ( -2556.2, -702.2, 1446 ), 15000 );
}

collapsing_building()
{
	building = getent( "collapsing_building", "targetname" );
	wait( 7.5 );
	time = 10;

	ent = spawn( "script_origin", building.origin );
	ent.angles = building.angles;
	ent addpitch( -30 );
	ent addyaw( 60 );
	ent.origin += (0,0,-2000);
	
	building moveto( ent.origin, time, 6, 0 );
	building rotateto( ent.angles, time, 6, 0 );
	
	building thread play_sound_on_entity( "scn_roadkill_building_collapse" );	
	exploder( "building_collapse" );
}

roadkill_bomb_physics_explosion()
{
	wait( 1.3 );
	start = getent( "physics_explosion_line", "targetname" );
	end = getstruct( start.target, "targetname" );
	
	dest = getstruct( end.target, "targetname" );
	
	radius = start.radius;
	
	dist = distance( start.origin, end.origin );
	segments = dist / radius;
	
	
	time = 3;
	start moveto( dest.origin, time, 2, 0 );
	end_time = gettime() + time * 1000;
	
	segment_vec = end.origin - start.origin;
	segment_vec /= segments;
	
	force_vec = ( -45, -55, 72 );
	angles = vectortoangles( force_vec );
	forward = anglestoforward( angles );
	force_vec = forward * 0.14;
	
	count = 0;
	for ( ;; )
	{
		if ( gettime() > end_time )
			break;
		
		org = start.origin;
		for ( i = 0; i < segments; i++ )
		{
			count++;
			if ( count <= 3 )
			{
				PhysicsExplosionCylinder( org, radius, radius, 0.3 );
//				Print3d( org, "x", (0,0,1), 1, 2, 150 );
			}
			else
			{
				PhysicsJolt( org, radius, radius, force_vec );
//				Print3d( org, "x", (1,0,0), 1, 2, 150 );
				count = 0;
			}
			org += segment_vec;
		}
		
		wait( 0.05 );
	}
	
}

street_walk_scene()
{
	array_spawn_function_targetname( "street_walk_scene", ::street_walk_guy );
//	flag_wait( "100ton_bomb_goes_off" );
	flag_wait( "convoy_oscar_mike_after_explosion" );
	wait( 12.5 - 4 );
	array_spawn_targetname( "street_walk_scene" );
}

street_walk_guy()
{
	self endon( "death" );
	self.ignoreall = true;
	self.ignoreme = true;
	self setgoalpos( self.origin );
	self.moveplaybackrate = 1;
	self.pathrandompercent = 0;
	struct = getstruct( self.script_linkto, "script_linkname" );

	delays = [];
	delays[ "street_walk_scene1" ] = 1.7;
	delays[ "street_walk_scene2" ] = 0.9;
	delays[ "street_walk_scene3" ] = 0;
		
	delay = delays[ struct.targetname ];
	delay *= 1.3;
	wait( delay );
	

//	flag_wait( "building_face_falloff" );
	
	self enable_cqbwalk();
//	struct anim_generic_first_frame( self, "combat_walk" );

	struct anim_generic_reach( self, "combat_walk" );
		
	struct thread anim_generic_gravity( self, "combat_walk" );
	animation = self getgenericanim( "combat_walk" );
	for ( ;; )
	{
		if ( self getanimtime( animation ) >= 0.96 )
			break;
		wait( 0.05 );
	}
	self notify( "killanimscript" );

	node = getnode( self.target, "targetname" );
	self setgoalnode( node );
	self.fixednode = false;
	
	self.goalradius = 8;
	self waittill( "goal" );
	self safe_delete();
}

broken_wall()
{
	// this wall breaks/slides a bit
	
	models = getentarray( self.target, "targetname" );
	foreach ( model in models )
	{
		model linkto( self );
	}
	pivot = getent( self.script_linkto, "script_linkname" );
	self add_target_pivot( pivot );
	
	start_ent = getent( "broken_wall_start_org", "targetname" );
	
	end_origin = pivot.origin;
	end_angles = pivot.angles;
	pivot.origin = start_ent.origin;
	pivot.angles = start_ent.angles;
	
	//flag_wait( "100ton_bomb_goes_off" );
	flag_wait( "building_face_falloff" );
	pivot thread play_sound_on_entity( "scn_roadkill_building_crumble" );
	
	
	//wait( 1.5 );
		
	moveTime = 4;
	pivot rotateto( end_angles, moveTime, 3, 1 );
	pivot moveto( end_origin, moveTime, 3, 1 );
	
	exploder( "building_crumble" );	
}

roadkill_riverbank_objective()
{
	thread detect_player_switched_to_javelin();
	/*
	idle_commanders = GetEntArray( "idle_commander", "targetname" );
	commander = idle_commanders[ 0 ];
	origin = commander.origin;
	radio_scene = getstruct( "radio_scene", "targetname" );
	origin = radio_scene.origin;	
	*/
	
	// Protect the bridge layer.
	waittillframeend;
	Objective_Add( 1, "current", &"ROADKILL_OBJECTIVE_BRIDGELAYER", (0,0,0) );
	Objective_Current( 1 );
	objective_onentity( 1, level.foley );

	flag_wait( "riverbank_scene_starts" );
	flag_wait( "bridgelayer_crosses" );
	objective_complete( 1 );

	wait( 1.5 );

	origin = ( -2488, -3755, 182 );
	
	
	// Get in your Humvee.
	Objective_Add( 3, "current", &"ROADKILL_OBJECTIVE_HUMVEE", origin );
	Objective_Current( 3 );
	
	for ( ;; )
	{
		if ( isdefined( level.chair ) )
			break;
		wait( 0.05 );
	}
	
	Objective_OnEntity( 3, level.chair );
	flag_wait( "player_gets_in" );
	objective_complete( 3 );
}

roadkill_ride_objective()
{
	// Destroy targets of opportunity.
	Objective_Add( 4, "current", &"ROADKILL_OBJECTIVE_TARGETS", ( 0, 0, 0 ) );
	Objective_Current( 4 );

	flag_wait( "player_knocked_down" );
}

roadkill_school_objective()
{
	trigger = getEntWithFlag( "roadkill_school_14" );

	if ( !is_default_start() )
	{
		// Exfiltrate to the link up point.
		Objective_Add( 4, "current", &"ROADKILL_OBJECTIVE_SCHOOL", trigger.origin );
	}

	// Exfiltrate to the link up point.
	Objective_String( 4, &"ROADKILL_OBJECTIVE_SCHOOL" );
	Objective_Position( 4, trigger.origin );
	flag_wait( "roadkill_school_14" );
}

roadkill_exfil_objective()
{
	objective_complete( 4 );
	node = GetNode( "outside_node", "targetname" );

	// Terminate the enemy presence in the school.
	Objective_Add( 5, "current", &"ROADKILL_OBJECTIVE_EXFIL", node.origin );
	Objective_Current( 5 );
}

roadkill_mortars()
{
	level endon( "time_to_go" );
	mortar = self;

	mortars = [];
	mortars[ mortars.size ] = mortar;
	for ( ;; )
	{
		if ( !isdefined( mortar.target ) )
			break;
		mortar = getstruct( mortar.target, "targetname" );
		mortars[ mortars.size ] = mortar;
	}

	waits = [];
	waits[ 0 ] = 0.3;
	waits[ 1 ] = 1.1;
	waits[ 2 ] = 0.5;
	waits[ 3 ] = 0.0;
	waits[ 4 ] = 1.3;
	waits[ 5 ] = 2.3;
	waits[ 6 ] = 1.6;
	waits[ 7 ] = 0.0;
	wait( 2.85 - 2.5 );

	foreach ( mortar in mortars )
	{
		mortar.water = IsDefined( mortar.script_noteworthy ) && mortar.script_noteworthy == "water";
	}


	mortar_fx = getfx( "mortar_large" );
	water_fx = getfx( "mortar_water" );
	
	building_mortars = get_exploder_array( "building_mortar" );

	for ( i = 0; ; i++ )
	{
		i %= mortars.size;

		building_mortar = random( building_mortars );
		mortar = mortars[ i ];

		if ( mortar.water )
		{
			mortar.fx = water_fx;
			mortar.sound = "mortar_explosion_water";
		}
		else
		{
			mortar.fx = mortar_fx;			
			mortar.sound = "mortar_explosion_dirt";
		}
		

		thread roadkill_mortar_goes_off( building_mortar, mortar );

		mod = i % waits.size;
		wait( waits[ mod ] );
		
		waits[ mod ] += 0.75; // next time we do this one, wait longer
	}
}

roadkill_mortar_goes_off( building_mortar, mortar )
{
	building_mortar activate_individual_exploder();
	wait( 2 );
	thread play_sound_in_space( "artillery_incoming", mortar.origin );
	wait( 0.5 );
	
	PlayFX( mortar.fx, mortar.origin );

	RadiusDamage( mortar.origin, 200, 300, 50 );
	thread play_sound_in_space( mortar.sound, mortar.origin );
}


detect_if_player_tries_to_cross_bridge()
{
	level endon( "player_gets_in" );
	flag_wait( "player_tries_to_cross_bridge" );
	thread player_dies_to_attackers();
}

player_dies_to_attackers()
{
	wait( 2 );
	level.player endon( "death" );
	level.player delayCall( 3, ::EnableHealthShield, false );
	eyepos = level.player GetEye();
	org = undefined;

	// try to find an org that could see the player
	foreach ( org in level.player_killer_orgs )
	{
		if ( BulletTracePassed( eyepos, org, true, undefined ) )
			break;
	}

	for ( ;; )
	{
		level.player DoDamage( 75, org );
		timer = RandomFloatRange( 0.4, 0.7 );
		wait( timer );
	}
}

setup_player_killer_orgs()
{
	level.player_killer_orgs = [];
	orgs = GetEntArray( "attack_point", "script_noteworthy" );
	foreach ( org in orgs )
	{
		level.player_killer_orgs[ level.player_killer_orgs.size ] = org.origin;
	}
}

bmp_becomes_javelin_targettable()
{
	if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "delayed_targeting" )
	{
		if ( level.start_point != "move_out" )
			wait( 10 );
	}
	wait( 1 );
	OFFSET = ( 0, 0, 60 );
	Target_Set( self, OFFSET );
	Target_SetAttackMode( self, "top" );
	Target_SetJavelinOnly( self, true );
	self thread set_javelin_targettable_var();

	self.health = 20000;
	self godon();
	self riverbank_bmp_is_shot_at();
	if ( IsDefined( self ) )
	{
		Target_Remove( self );
	}
}

set_javelin_targettable_var()
{
	self endon( "death" );
	wait( 1.5 );
	// used for start points
	self.javelin_targettable = true;
}

bmp_gets_killed()
{
	level.riverside_bmp = self;
}

riverbank_bmp()
{
	bmp_destroyed = GetEnt( "bmp_destroyed", "targetname" );
	bmp_destroyed thread bmp_destroyed();
	
	//array_spawn_function_targetname( "riverbank_bmp", ::bmp_becomes_javelin_targettable );
	array_spawn_function_targetname( "riverbank_bmp", ::bmp_gets_killed );
	bmp = spawn_vehicle_from_targetname( "riverbank_bmp" );

	bmp waittill( "death" );


	exploder( "bmp_explosion" );
	wait( 0.5 );
	bmp_destroyed notify( "destroyed" );
	bmp Delete();
	exploder( "bmp" );
}

riverbank_bmp_is_shot_at()
{
	self endon( "death" );
	for ( ;; )
	{
		if ( !isalive( self ) )
		{
			break;
		}

		oldHealth = self.health;
		self waittill( "damage", dmg, attacker, one, two, weapType );
		if ( IsDefined( attacker.classname ) && !isplayer( attacker ) )
		{
			self.health = oldHealth;
			continue;
		}

		if ( weapType != "MOD_PROJECTILE" )
			continue;

		if ( dmg < 800 )
			continue;
//		if ( !player_has_javelin() )
//			continue;

//		level.javelin_helper delayThread( 1, ::anim_single_queue, level.javelin_helper, "hit_target_" + level.bmps_killed_by_player );

		self godoff();
		RadiusDamage( self.origin, 150, self.health + 500, self.health + 500 );
	}
}

bmp_destroyed()
{
	self Hide();
	targ = GetEnt( self.target, "targetname" );
	angles = targ.angles;
	origin = targ.origin;
	targ Delete();

	self waittill( "destroyed" );
	self Show();
	wait( 5 );
	movetime = 8;
	self MoveTo( origin, movetime, 0, 2 );
	self RotateTo( angles, movetime, 0, 2 );
}

intro_orders()
{
	spawners = GetEntArray( self.target, "targetname" );
	guys = array_spawn( spawners );

	guys[ 0 ].animname = "hargrove";
	guys[ 1 ].animname = "foley";

	self thread anim_single( guys, "roadkill_intro_orders" );
	wait( 0.05 );
	guy = undefined;
	foreach ( guy in guys )
	{
		animation = guy getanim( "roadkill_intro_orders" );
		guy SetAnim( animation, 1, 0, 0 );
		guy SetAnimTime( animation, 0.25 );
	}
	flag_wait( "player_climbs_stairs" );
	foreach ( guy in guys )
	{
		animation = guy getanim( "roadkill_intro_orders" );
		guy SetAnim( animation, 1, 0, 1 );
	}

	for ( ;; )
	{
		animation = guy getanim( "roadkill_intro_orders" );
		if ( guy GetAnimTime( animation ) >= 0.78 )
			break;
		wait( 0.05 );
	}

	foreach ( guy in guys )
	{
		guy anim_stopanimscripted();
	}
}

ai_invulnerable()
{
	if ( IsDefined( self.script_drone ) )
		return;

	if ( isdefined( self.script_godmode ) )
		return;

	if ( !isdefined( self.magic_bullet_shield ) )
		self magic_bullet_shield();

	self.attackeraccuracy = 0;
	self.IgnoreRandomBulletDamage = true;
}

extra_bmp_blows_up()
{
//	wait( 12.15 );
	flag_wait( "100ton_bomb_goes_off" );
	wait( 1 );
	RadiusDamage( self.origin, 128, 5000, 5000 );
}

player_fights_bmps()
{
	bridge_targets = GetEntArray( "bridge_target", "targetname" );
	orgs = get_orgs_from_ents( bridge_targets, true );

//	array_spawn_function_targetname( "extra_bmp", ::bmp_targets_bridge, orgs );
//	spawn_vehicles_from_targetname_and_drive( "extra_bmp" );
//	flag_wait( "missile_fire_3" );
	
	
	flag_wait( "leaving_riverbank" );
	flag_wait( "bridgelayer_crosses" );

	/*
	foreach ( guy in level.stair_block_guys )
	{
		guy delete();
	}
	*/
	foreach ( guy in level.stair_block_guys )
	{
		guy thread run_to_convoy();
	}
	
	player_stair_blocker = getent( "player_stair_blocker", "targetname" );
	player_stair_blocker delete();
	flag_clear( "player_climbs_stairs" );
}

bmp_targets_bridge( orgs )
{
	self endon( "death" );
	self waittill( "reached_end_node" );

	self endon( "death" );

	ent = Spawn( "script_origin", ( 0, 0, 0 ) );
	ent.origin = orgs[ 0 ].origin;
	self SetTurretTargetEnt( ent );
	self.target_ent = ent;

	self tank_fires_often( orgs );
}

idle_commander()
{
	self magic_bullet_shield();
//	self.ignoreall = true;
//	self.team = "neutral";
//	self disable_pain();
//	self.grenadeawareness = 0;
//	self.disableBulletWhizbyReaction = true;
}

dismount_foley()
{
	level.foley = self;
	self make_hero();
}

dismount_dunn()
{
	level.dunn = self;
	self make_hero();
}

foley_line( msg )
{
	level.dialogue_function_stack_struct function_stack( ::foley_line_proc, msg );
}

foley_line_proc( msg )
{
	if ( !flag( "player_gets_in" ) )
	{
		level.foley generic_dialogue_queue( msg );
		return;
	}

	if ( !flag( "player_enters_ambush_house" ) )
	{
		if ( isdefined( level.crazy_ride_convoy[ "lead" ] ) && !flag( "player_is_dismounted" ) )
		{
			level.crazy_ride_convoy[ "lead" ] generic_dialogue_queue( msg );
		}
		else
		{
			if ( isalive( level.foley ) )
			{
				level.foley generic_dialogue_queue( msg );
			}
			else
			{
				level.player generic_dialogue_queue( msg );
			}
		}
		return;
	}

	level.foley generic_dialogue_queue( msg );
}

driver_line( msg )
{
	level.dialogue_function_stack_struct function_stack( ::driver_line_proc, msg );
}

driver_line_proc( alias )
{
	play_line_at_offset_on_player_vehicle( alias, (-100,100,-80) );
}

passenger_line( msg )
{
	level.dialogue_function_stack_struct function_stack( ::passenger_line_proc, msg );
}

passenger_line_proc( alias )
{
	play_line_at_offset_on_player_vehicle( alias, (-100,0,-80) );
}

play_line_at_offset_on_player_vehicle( alias, offset )
{
	player_vehicle_angles = level.crazy_ride_convoy[ "player" ].angles;
	angles = ( 0, player_vehicle_angles[ 1 ], 0 );
	
	ent = spawn( "script_origin", (0,0,0) );
	ent linkto( level.crazy_ride_convoy[ "player" ], "tag_body", offset, (0,0,0) );
	
	ent play_sound_on_entity( alias );
	ent delete();
}

dunn_line( msg )
{
	level.dialogue_function_stack_struct function_stack( ::dunn_line_proc, msg );
}

dunn_line_proc( msg )
{
	if ( !flag( "player_gets_in" ) )
	{
		level.dunn generic_dialogue_queue( msg );
		return;
	}
	
	if ( !flag( "player_enters_ambush_house" ) )
	{
		if ( isdefined( level.crazy_ride_convoy[ "player" ] ) && !flag( "player_is_dismounted" ) )
		{
			level.crazy_ride_convoy[ "player" ] generic_dialogue_queue( msg );
		}
		else
		{
			if ( isalive( level.dunn ) )
			{
				level.dunn generic_dialogue_queue( msg );
			}
			else
			{
				level.player generic_dialogue_queue( msg );
			}
		}
		return;
	}

	level.dunn generic_dialogue_queue( msg );
}

shepherd_line( msg )
{
	level.dialogue_function_stack_struct function_stack( ::shepherd_line_proc, msg );
}

shepherd_line_proc( msg )
{
	if ( isalive( level.shepherd ) )
	{
		level.shepherd generic_dialogue_queue( msg );
	}
	else
	{
		if ( !isdefined( level.scr_radio[ msg ] ) )
			level.scr_radio[ msg ] = level.scr_sound[ "generic" ][ msg ];
		radio_dialogue( msg );
	}
}

player_is_safe()
{
	for ( ;; )
	{
		axis = getaiarray( "axis" );
		guy = getClosest( level.player.origin, axis, 600 );
		if ( !isalive( guy ) )
			break;
		wait( 0.2 );		
	}
	wait( 0.75 );
}

respawn_dead_school_window_guys()
{
	// find which guys are currently alive, respawn the spawners that aren't currently alive
	used_exports = [];
	ai = getaiarray( "axis" );
	foreach ( guy in ai )
	{
		used_exports[ guy.export ] = true;
	}
	
	foreach ( spawner in level.school_ambush_spawners )
	{
		if ( !isdefined( used_exports[ spawner.export ] ) )
		{
			spawner.count = 1;
			spawner spawn_ai();
		}
	}
}

radio_line( msg )
{
	level.dialogue_function_stack_struct function_stack( ::radio_dialogue, msg );
}

pistol_killer_spawner()
{
	level.pistol_killer = self;
	self endon( "death" );
	self magic_bullet_shield();
	node = GetNode( self.target, "targetname" );
	node thread anim_generic( self, "exposed_reload" );
	wait( 0.05 );
	animation = getGenericAnim( "exposed_reload" );
	self SetAnim( animation, 1, 0, 0 );
	self SetAnimTime( animation, 0.3 );
	flag_wait( "player_rounds_end_corner" );
	self SetAnim( animation, 1, 0, 1 );
	self.a.pose = "crouch";

	for ( ;; )
	{
		if ( self GetAnimTime( animation ) > 0.90 )
			break;
		wait( 0.05 );
	}
	self.a.pose = "stand";
	self notify( "killanimscript" );

	/*
	self.bulletsinclip = 0;
	wait( 2.7 );
	*/
	node = GetNode( "outside_node", "targetname" );
	self SetGoalNode( node );
	self disable_cqbwalk();
}

roadkill_pistol_guy()
{
	self.ignoreall = true;
	self.ignoreme = true;
	self endon( "death" );
	//self.allowdeath = true;
	self disable_pain();
	self.health = 10000;

	self forceUseWeapon( "glock", "primary" );
	self add_damage_function( ::bloody_pain_reverse );
	thread shoot_randomly();

	struct = getstruct( "backwards_struct", "targetname" );
	struct thread anim_generic_custom_animmode( self, "gravity", "pistol_walk_back" );
	self set_generic_deathanim( "pistol_death" );
	waittill_notify_or_timeout( "damage", 1.5 );

	thread fire_bullets_at_guy();
	wait( 0.15 );
	self thread anim_generic_custom_animmode( self, "gravity", "pistol_death" );
	animation = self getGenericAnim( "pistol_death" );
	time = GetAnimLength( animation );
	self delayThread( 0.5, animscripts\shared::DropAIWeapon );
	//wait( time - 0.05 );
	wait( 0.9 );
	self.a.nodeath = true;
	self Kill();
}

shoot_randomly()
{
	self endon( "death" );
	self.baseaccuracy = 0;
	wait( 0.4 );
	self shoot();
	wait( 0.8 );
	self shoot();
	wait( 0.2 );
	self shoot();
	wait( 0.45 );
	self shoot();
	wait( 2 );
	self shoot();
}

bloody_pain_reverse( damage, attacker, direction_vec, point, type, modelName, tagName )
{
	angles = direction_vec + ( 0, 180, 0 );
	forward = AnglesToForward( angles );
	up = AnglesToUp( angles );

	fx = getfx( "headshot" );
	PlayFX( fx, point, forward, up );
	//Line( point, point + forward * 500, (1,0,0), 1, 1, 5000 );
}

fire_bullets_at_guy()
{
	struct = getstruct( "pistol_bullet_spawner", "targetname" );
	targ = getstruct( struct.target, "targetname" );

	vector = struct.origin - targ.origin;

	waits = [];
	waits[ 0 ] = 0.1;
	waits[ 1 ] = 0.1;
	waits[ 2 ] = 0.1;
	waits[ 3 ] = 0.2;
	waits[ 4 ] = 0.1;
	waits[ 5 ] = 0.1;
	waits[ 6 ] = 0.1;
	waits[ 7 ] = 0.25;

	count = 12;
	for ( i = 0; i < count; i++ )
	{
		dest_org = targ.origin + randomvector( 40 );
		MagicBullet( "m4m203_eotech", struct.origin, dest_org, level.player );
		if ( IsDefined( waits[ i ] ) )
		{
			wait( waits[ i ] );
		}
		else
		{
			wait( 0.1 );
		}
	}
}

player_shoot_detection_trigger()
{
	wait_for_player_to_force_flee();

	flag_set( "retreaters_run" );
	level.player.threatbias = 5000;
	wait( 2 );
	level.player.threatbias = 150;
}

wait_for_player_to_force_flee()
{
	if ( flag( "roadkill_school_9" ) )
		return;
	level endon( "roadkill_school_9" );

	add_wait( ::flag_wait, "player_forces_enemy_to_flee" ); // means player can see down the hall
	add_wait( ::player_shoots_at_enemies_in_school );
	do_wait();
}
	
player_shoots_at_enemies_in_school()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		if ( other == level.player )
			break;
	}
}

retreat_spawner()
{
	self endon( "death" );
	self.neverEnableCQB = true;
	flag_wait( "retreaters_run" );
	
	// look at the player then make a break for it
	self setlookatentity( level.player );
	time = RandomFloatRange( 0.3, 0.9 );
	wait( time );
	
	
	self delaycall( 3, ::setlookatentity );
	
	school_flee_struct = getstruct( "school_flee_struct", "targetname" );
	
	self maps\_spawner::go_to_node( school_flee_struct, "struct" );
}

school_spawner_think()
{
	self disable_cqbwalk();
	self.neverEnableCQB = true;
	
	if ( !flag( "detour_convoy_slows_down" ) )
	{
		self endon( "death" );
		self.ignoreall = true;
		self.ignoreme = true;
		flag_wait( "detour_convoy_slows_down" );
		self.ignoreall = false;
		self.ignoreme = false;
		return;
	}

	self.attackeraccuracy = 0.2;
	level.school_baddies[ level.school_baddies.size ] = self;
	
	// used the second time these guys spawn
	self waittill( "death" );
	level notify( "school_spawner_death" );
}

school_spawner_flee_node()
{
	level waittill( "school_spawner_death" );
	guys = level.school_baddies;
	guys = array_removedead( guys );
	
	node = getnode( "class_flee_node", "targetname" );
	guy = getClosest( node.origin, guys );
	if ( isalive( guy ) )
	{
		guy.combatmode = "cover";
		guy endon( "death" );
		guy setgoalnode( node );
		guy.goalradius = 64;
		guy waittill( "goal" );
		guy.goalradius = 2000;
	}
}

fleeing_baddie_spawner()
{
	self endon( "death" );
	self.attackeraccuracy = 0;
	self.IgnoreRandomBulletDamage = true;
	old_dist = self.pathenemyfightdist;
	old_look = self.pathenemylookahead;
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 0;
	self.maxfaceenemydist = 32;
	self enable_sprint();
	self waittill( "goal" );
	wait( 1.5 );
	self.attackeraccuracy = 1;
	self.IgnoreRandomBulletDamage = false;
	self.pathenemyfightdist = old_dist;
	self.pathenemylookahead = old_look;
}

stop_sprinting_trigger()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		if ( first_touch( other ) )
		{
			other delayThread( 1.4, ::disable_sprint );
		}
	}
}

damage_targ_trigger_think()
{
	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		if ( !isalive( attacker ) )
			continue;
//		if ( attacker != level.player )
//			continue;
		if ( Distance( attacker.origin, self.origin ) > 940 )
			continue;

		targ = getstruct( self.target, "targetname" );
		RadiusDamage( targ.origin, 30, 5000, 5000 );
	}

	self Delete();
}

extra_retreat_spawner()
{
//	if ( !isdefined( self.target ) )
//		thread retreat_spawner();
	self.neverEnableCQB = true;
	
	level.forced_bcs_callouts++;
	if ( level.forced_bcs_callouts == 1 )
	{
		self play_sound_on_entity( "SC_0_threat_rpg" );
	}
	else
	if ( level.forced_bcs_callouts == 2 )
	{
		wait( 0.15 );
		self play_sound_on_entity( "SC_2_threat_rpg" );
	}	
}

wave_right_trigger()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		if ( other == level.foley )
			break;
	}


	// I think I saw one run into that classroom.	
	thread foley_line( "roadkill_fly_sawone" );
	
	if ( flag( "roadkill_near_crossroads" ) )
	{
		add_wait( ::flag, "school_back_baddies_dead" );
		add_wait( ::flag, "roadkill_school_12" );
		do_wait_any();
		if ( flag( "roadkill_school_12" ) )
		{
			flag_set( "roadkill_school_11" );
			return;
		}
	}

	
//	other endon( "death" );
	targ = getstruct( self.target, "targetname" );
	targ anim_generic_reach( other, "cqb_wave" );
	if ( isalive( other ) )
		targ thread anim_generic( other, "cqb_wave" );
	wait( 0.9 );
	other enable_ai_color();
	flag_set( "roadkill_school_11" );

	// switches tracks so he doesn't go into the room he signaled
	/*
	if ( isalive( other ) )
		other set_force_color( "b" );
	
	// turn the green guy to a purple guy
	ai = getaiarray( "allies" );
	foreach ( guy in ai )
	{
		if ( !isdefined( guy.script_forcecolor ) )
			continue;
		if ( guy.script_forcecolor != "g" )
			continue;
		guy set_force_color( "p" );
		break;
	}
	*/
}

staircase_grenade()
{
	flag_wait( "staircase_grenade" );
	
	trigger = getEntWithFlag( "staircase_grenade" );
	start = getstruct( trigger.target, "targetname" );
	end = getstruct( start.target, "targetname" );
	
	vector = end.origin - start.origin;
	angles = vectortoangles( vector );
	forward = anglestoforward( angles );
	velocity = forward * 450;
	MagicGrenadeManual( "fraggrenade", start.origin, velocity, 5 );
}

detach_my_scr_model()
{
	self detach( level.scr_model[ self.animname ], "tag_inhand" );
}

stair_block_guy()
{
	level.stair_block_guys[ level.stair_block_guys.size ] = self;
	
	self add_riverbank_flags();
	
	self endon( "death" );
	struct = getstruct( self.script_linkto, "script_linkname" );
	self.animname = struct.targetname;
	self gun_remove();
	self.doing_looping_anim = true;

	// electronics_pda
	if ( isdefined( level.scr_model[ self.animname ] ) )
	{
		self Attach( level.scr_model[ self.animname ], "tag_inhand" );
		self.convoy_func = ::detach_my_scr_model;
	}
	
	struct thread anim_loop_solo( self, "sit_around" );
	flag_wait( "time_to_go" );
	struct notify( "stop_loop" );
}

rooftop_drone()
{
	struct = getstruct( self.script_linkto, "script_linkname" );
	self.animname = "generic";
	offset = (0,0,100);
	struct.origin -= offset;
	ent = spawn_tag_origin();
	ent.origin = struct.origin;
	ent.angles = struct.angles;
	self linkto( ent, "tag_origin", (0,0,0), (0,0,0) );
	ent moveto( ent.origin + offset, 1, 0.5, 0.5 );
	struct anim_generic( self, "rooftop_turn" );
	ent delete();
	self delete();
}

wobbly_fans()
{
	fans = getentarray( "destructible_toy", "targetname" );
	foreach ( fan in fans )
	{
		if ( fan.destructible_type == "toy_ceiling_fan" )
			fan thread fan_wobbles();	
	}
}

fan_wobbles()
{
	self endon( "death" );
	//self endon( "exploded" );
	action_v = level.destructible_type[ self.destuctableInfo ].parts[ 0 ][ 0 ].v;
	animation = action_v[ "animation" ][ 0 ][ "anim" ];
	
	for ( ;; )
	{
		rate = randomfloatrange( 0.01, 0.04 ); // go slow for awhile
		self SetAnim( animation, 1, 0, rate );
		timer = randomfloatrange( 1.0, 2.5 );
		wait( timer );

		rate = randomfloatrange( 0.01, 0.15 ); // go a random speed
		self SetAnim( animation, 1, 0, rate );
		timer = randomfloatrange( 1.0, 3 );
		wait( timer );

		rate = randomfloatrange( 0.05, 0.2 ); // go a random speed
		self SetAnim( animation, 1, 0, rate );
		timer = randomfloatrange( 1.0, 3 );
		wait( timer );
	}
}

friendlies_get_on_exit_convoy_trigger()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		if ( !first_touch( other ) )
			continue;
			
		if ( !isdefined( other.running_loader ) )
			continue;

		other thread friendly_gets_on_vehicle();
	}
}

friendly_gets_on_vehicle()
{
	self endon( "death" );

	vehicle = undefined;
	level.ending_vehicles = array_randomize( level.ending_vehicles );
	foreach ( ending_vehicle in level.ending_vehicles )
	{
		used_positions = 0;
		foreach ( pos in ending_vehicle.usedpositions )
		{
			if ( !pos )
				used_positions++;
		}
		
		if ( used_positions )
		{
			vehicle = ending_vehicle;
			break;
		}
	}
	
	if ( !isdefined( vehicle ) )
		return;
		
	thread guy_runtovehicle_load( self, vehicle );
}


friendly_ending_runner_spawner()
{
	self.running_loader = true;
	self.fixednode = false;
	node = getnode( "friendly_exit_node", "targetname" );
	self setgoalnode( node );	
	self.goalradius = 64;
}

shepherd_ending_spawner()
{
	// Transport the wounded directly to the shock trauma unit! Use my helicopter! I'll take the next one out!	
	thread shepherd_line( "roadkill_shp_shocktrauma" );
	self.animname = "shepherd";
	
	struct = getstruct( "roadkill_shepherd_ending_scene", "targetname" );
	struct anim_first_frame_solo( self, "ending" );
	
	flag_wait( "start_shepherd_end" );	
//	flag_wait( "the_end" );	
	thread roadkill_ending_dialogue();
	//thread maps\roadkill_anim::point_start( self );
	struct anim_single_solo( self, "ending" );
}

roadkill_ending_dialogue()
{
	wait( 8 );

	// Battalion is oscar mike!!!	
	thread random_ai_line( "roadkill_ar4_oscarmike" );
	wait( 0.4 );

	// Anybody got a spare MRE?	
	thread random_ai_line( "roadkill_ar1_sparemre" );
	wait( 0.3 );
}


ending_hangout_spawner()
{
	self set_generic_run_anim( "walk" );
}

ride_adjust_convoy_speed_trigger()
{
	/*
	// give the lead vehicle some distance
	trigger = getent( "ride_adjust_convoy_speed_trigger", "targetname" );
	trigger waittill( "trigger", other );
	other Vehicle_SetSpeed( 10, 1, 1 );
	wait( 12 );
	other ResumeSpeed( 1 );	
	*/
}

ignore_and_delete()
{
	self endon( "death" );
	self.ignoreme = true;
	self.ignoreall = true;
	self waittill( "goal" );
	wait( 0.5 );
	self waittill( "goal" );
	self delete();
}

wait_for_empty_queue()
{
	if ( !isdefined( self.function_stack ) )
		return;
		
	while ( self.function_stack.size > 0 )
	{
		wait( 0.05 );
	}
}

dunn_credits_player_with_kill( max_time )
{
	level endon( "dunn_no_commento" );	
	wait( max_time + 0.1 );
	level.dialogue_function_stack_struct wait_for_empty_queue();

	if ( !flag( "jumper_died" ) )
		return;
		
	// Nevermind, Allen handled it	
	dunn_line( "roadkill_cpd_handledit" );
}

look_forward_nag()
{
	if ( flag( "ride_looking_forward" ) )
		return;
		
	level endon( "ride_looking_forward" );

	wait( 3 );
	// Eyes forward, Allen. Look alive.	
	foley_line( "roadkill_fly_eyesforward" );
}

gunner_becomes_invul()
{
	turret = self.mgturret[0];
	for ( ;; )
	{
		gunner = turret getturretowner();
		if ( isalive( gunner ) )
		{
			if ( !isdefined( gunner.magic_bullet_shield ) )
				gunner magic_bullet_shield();
			return;
		}
		wait( 0.05 );
	}
}

get_gunner_from_vehicle()
{
	foreach ( guy in self.riders )
	{
		if ( !isalive( guy ) )
			continue;
		if ( !issentient( guy ) )
			continue;
		if ( isdefined( guy getturret() ) )
			return guy;
	}
}


structorama()
{
	for ( ;; )
	{
		struct = getstruct( "mortar_school_chain", "targetname" );
		struct delaythread( 1, ::struct_mortar );
		struct = getstruct( struct.target, "targetname" );
		struct delaythread( 1.3, ::struct_mortar );
		struct = getstruct( struct.target, "targetname" );
		struct delaythread( 1.6, ::struct_mortar );
		wait( 5 );
	}
}

struct_mortar()
{
	thread play_sound_in_space( "artillery_incoming_loud", self.origin );
	wait( 1 );
	mortar_fx = getfx( "mortar_large" );
	PlayFX( mortar_fx, self.origin );
	RadiusDamage( self.origin, 100, 500, 500, level.player );
	thread play_sound_in_space( "mortar_explosion_dirt", self.origin );
	
	PhysicsExplosionSphere( self.origin, 100, 100, 2 );
}

smoke_degrades()
{
	wait( 2.5 );
	self.degrade_time += 0.05;
	wait( 1 );
	self.degrade_time += 0.05;
	wait( 1 );
	self.degrade_time += 0.05;
	wait( 1 );
	//self.degrade_time += 0.05;
	self notify( "done" );
}

turret_burns_out()
{
//	ent delaythread( 4.5, ::send_notify, "done" );
	ent = spawnstruct();
	ent endon( "done" );
	ent.degrade_time = 0;
	ent thread smoke_degrades();

	level endon( "kaboom_to_detour_vehicle" );
	fx = getfx( "minigun_burnout" );
	for ( ;; )
	{
		PlayFXOnTag( fx, self, "j_spin" );
		
		timer = 0;
		if ( ent.degrade_time > 0 )
		{
			timer += randomfloat( ent.degrade_time );
		}
		timer += 0.035;
		wait( timer );
	}
}

vehicle_resumespeed_trigger()
{
	if ( flag( "convoy_slows_down_again" ) )
		return;
	level endon( "convoy_slows_down_again" );
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !first_touch( other ) )
			continue;
			
		other vehicle_setspeed( 8.2, 5, 5 );
	}
}

player_convoy_encounters_baddies()
{
	trigger = getent( "vehicle_resumespeed_trigger", "targetname" );
	trigger thread vehicle_resumespeed_trigger();
	
	player_vehicle = level.crazy_ride_convoy[ "player" ];
	detour_vehicle = level.crazy_ride_convoy[ "detour" ];
	lead_vehicle = level.crazy_ride_convoy[ "lead" ];
	rear_vehicle = level.crazy_ride_convoy[ "rear" ];

	gunner = detour_vehicle get_gunner_from_vehicle();


	flag_wait( "shot_rings_out" );
	wait( 1.5 );

	faster = 10.2;
	lead_vehicle delaycall( 0, ::Vehicle_SetSpeed, faster, 10, 10 );
	detour_vehicle delaycall( 0.45, ::Vehicle_SetSpeed, faster, 10, 10 );
	rear_vehicle delaycall( 0.8, ::Vehicle_SetSpeed, faster, 10, 10 );
	player_vehicle delaycall( 1.2, ::Vehicle_SetSpeed, faster, 10, 10 );


	flag_wait( "haggerty_rechambers" );	
	level.timer = gettime();
	delaythread( 1.1, ::rpg_hits_hydrant );
	

	vehicle = detour_vehicle;
	
	node = getvehiclenode( "detour_vehicle_path", "targetname" );
	// veers off to the left	
	vehicle thread vehicle_paths( node );
	vehicle startpath( node );

	node = getvehiclenode( "player_detour_vehicle_path", "targetname" );
	player_vehicle thread vehicle_paths( node );
	player_vehicle startpath( node );	
	

	
	level notify( "convoy_continues_to_ambush" );
	

	flag_wait( "trappers_run" );
	array_spawn_function_noteworthy( "rpg_ambush_spawner", ::rpg_ambush_spawner );
	array_spawn_noteworthy( "rpg_ambush_spawner" );
	
	flag_wait( "detour_convoy_slows_down" );
	rear_vehicle delaycall( 2.5, ::Vehicle_SetSpeed, 0, 10, 10 );
	lead_vehicle delaycall( 2.5, ::Vehicle_SetSpeed, 0, 10, 10 );
	
	attractor = Missile_CreateAttractorEnt( level.crazy_ride_convoy[ "detour" ], 25000, 1024 );
	
	
	slower = 6;
	
	// threadoff() <- and threadoff was born
	detour_vehicle Vehicle_SetSpeed( slower, 10, 10 );
	wait( 0.1 );
	player_vehicle Vehicle_SetSpeed( slower, 10, 10 );
	
//	flag_wait( "rpg_ambush" );

	flag_wait( "gunner_dies" );
	if ( isalive( gunner ) )
	{
		gunner stop_magic_bullet_shield();
		eye = gunner geteye();
		MagicBullet( "ak47", eye + (0,0,35), eye + (0,0,-35) );
	}


	flag_wait( "rpg_super_ambush" );
	
	ai = getaiarray( "axis" );
	foreach ( guy in ai )
	{
		// no more rpgs fire like crazy
		guy.a.rockets = 0;
	}
	
	trigger = getentwithflag( "rpg_ambush" );
	start = getent( trigger.target, "targetname" );
	end = getent( start.target, "targetname" );

	//array_spawn_function_targetname( "rpg_vehicle", ::rpg_vehicle );
	//spawn_vehicle_from_targetname_and_drive( "rpg_vehicle" );
	//detour_vehicle Vehicle_SetSpeed( 9, 10, 10 );

	timer = gettime();
	//wait( 0.5 );
	
	rear_vehicle.veh_brake = 0.1;
	rear_vehicle delaythread( 1.5, ::set_brakes, 1 );

	angles = detour_vehicle.angles;
	forward = anglestoforward( angles );
	right = anglestoright( angles );
	
	struct = getstruct( "ambush_impact_vector", "targetname" );
	target = getstruct( struct.target, "targetname" );
	
	velocity_angles = vectortoangles( target.origin - struct.origin );
	velocity_forward = anglestoforward( velocity_angles );
	velocity = velocity_forward * 1;

	

	// LOTS OF EXPLOSIONS
	contact_point = right * -30 + forward * -30 + (0,0,-10);
	//Print3d( detour_vehicle.origin + contact_point, "x", (1,0,0), 1, 1.2, 500 );
	//detour_vehicle VehPhys_Launch( velocity, (0,0,0), contact_point );
	PhysicsExplosionSphere( detour_vehicle.origin + contact_point, 48, 32, 3 );
	level notify( "kaboom_to_detour_vehicle" );
	
	mortar_fx = getfx( "mortar_large" );
	PlayFX( mortar_fx, detour_vehicle.origin + contact_point );
	//detour_vehicle Vehicle_SetSpeed( 0, 10, 10 );
	detour_vehicle godoff();
	radiusdamage( detour_vehicle.origin, 64, 50000, 50000 );
	
	Earthquake( 0.7, 1.2, level.player.origin, 5000 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	
	
		
	level.player shellshock( "default", 5 );
	


	detour_vehicle.veh_brake = 0.15;
	
	
	thread vision_set_fog_changes( "roadkill_ambush", 0.8 );
	trapper_clip = getent( "trapper_clip", "targetname" );
	trapper_clip connectpaths();
	trapper_clip delete();

	flag_set( "ambush" );
	
	Missile_DeleteAttractor( attractor );	
	
	// keep other missiles away
	repulsor = Missile_CreateRepulsorEnt( level.player, 700, 1500 );
	
	wait( 0.7 );
	player_vehicle.veh_brake = 0.05; //player starts to brake
	
	wait( 0.5 );
	//rear_vehicle Vehicle_SetSpeed( 0, 10, 10 );
	//rear_vehicle.veh_brake = 1;


	// player brakes
	player_vehicle delaythread( 0.7, ::set_brakes, 1 );

	wait_around_time = 3.2;

	// rpg flies by
	delaythread( 2.00 + wait_around_time, ::rpg_flies_by_view );

	lead_vehicle delaycall( 5.0, ::resumespeed, 5 );
	
	wait( 1.25 + wait_around_time );


	player_vehicle.veh_transmission = "reverse";
	player_vehicle.veh_pathdir = "reverse";
	player_vehicle vehicle_setspeed( 16, 5, 5 );
	player_vehicle.veh_brake = 0;
	wait( 1.8 );
	player_vehicle.veh_brake = 1;


	wait( 0.7 );
	player_vehicle.veh_brake = 0;
	
	player_vehicle.veh_transmission = "forward";
	player_vehicle.veh_pathdir = "forward";
	
	
	// player gets back on path
	node = getvehiclenode( "player_gets_back_on_path", "targetname" );
	player_vehicle thread vehicle_paths( node );
	player_vehicle startpath( node );	
	player_vehicle resumespeed( 5 );
//	rear_vehicle delaycall( 0.65, ::resumespeed, 5 );
	rear_vehicle resumespeed( 5 );
	
//	player_vehicle Vehicle_SetSpeed( 24, 5, 5 );
	noself_delaycall( 2, ::Missile_DeleteAttractor, repulsor );

	wait( 0.8 );
//	rear_vehicle Vehicle_SetSpeed( 24, 5, 5 );
	rear_vehicle.veh_brake = 0;
	

}

rpg_hits_hydrant()
{
	array_spawn_function_targetname( "window_rpg_hydrant", ::rpg_vehicle );
	vehicle = spawn_vehicle_from_targetname_and_drive( "window_rpg_hydrant" );
	vehicle waittill( "death" );
	thread hydrant_hit();
}

rpg_flies_by_view()
{
	array_spawn_function_targetname( "window_rpg_vehicle", ::rpg_vehicle );
	vehicle = spawn_vehicle_from_targetname_and_drive( "window_rpg_vehicle" );
	vehicle waittill( "death" );
	
	struct = getstruct( "dyn_explosion_struct", "targetname" );
//	PhysicsExplosionSphere( struct.origin, 350, 350, 3 );
	level.player delaythread( 3, maps\_gameskill::grenade_dirt_on_screen, "left" );

	struct = getstruct( "dyn_spawner_struct", "targetname" );
	targ = getstruct( struct.target, "targetname" );
		
	models = [];
	models[ 0 ] = "me_woodcrateclosed";
	models[ 1 ] = "com_cardboardboxshortclosed_2";
	
	offsets = [];
	offsets[ 0 ] = (0,0,8);
	offsets[ 1 ] = (0,0,4.5);
	
	forcemult = [];
	forcemult[ 0 ] = 4;
	forcemult[ 1 ] = 1;
	
	fx = getfx( "rocket_explode" );
	PlayFX( fx, struct.origin );
	thread play_sound_in_space( "rocket_explode_dirt", struct.origin, true );
	PhysicsExplosionSphere( struct.origin, 320, 280, 4 );
	RadiusDamage( struct.origin, 320, 50, 50 );
	
	for ( i = 0; i < 14; i++ )
	{
		end = targ.origin + randomvector( 128 );
		vec = end - struct.origin;
		angles = vectortoangles( vec );
		forward = anglestoforward( angles );
		
		index = randomint( models.size );
		ent = Spawn( "script_model", struct.origin );
		ent SetModel( models[ index ] );

		force = forward;
		force *= 18000;
		force *= forcemult[ index ];
		force *= randomfloatrange( 0.9, 1.6 );
		offset = offsets[ index ] + randomvector( 1.2 );
		
		ent PhysicsLaunchClient( ent.origin + offset, force );
	}	
}

vehicle_physics_explosion()
{
	
	rpg_physics = getent( "rpg_physics", "targetname" );
	targ = getent( rpg_physics.target, "targetname" );
	
	rpg_physics_dest = getent( "rpg_physics_dest", "targetname" );
	targ_dest = getent( rpg_physics_dest.target, "targetname" );
	

	time = 0.3;
	rpg_physics moveto( rpg_physics_dest.origin, time );
	targ moveto( targ_dest.origin, time );
	
	start_time = gettime();

	time *= 1000;
	power = 6.25;

	vec = targ.origin - rpg_physics.origin;
	angles = vectortoangles( vec );
	forward = anglestoforward( angles );
	vec = forward * power;
	
	power *= 0.35;
	level.crazy_ride_convoy[ "detour" ] VehPhys_Launch( vec, 1.0 );
	/*
	
	delaythread( 0.25, ::reverse_force );
	for ( ;; )
	{	
		vec = targ.origin - rpg_physics.origin;
		angles = vectortoangles( vec );
		forward = anglestoforward( angles );
		vec = forward * power;
		
		power *= 0.35;
	
	//	PhysicsExplosionSphere( rpg_physics.origin, rpg_physics.radius, rpg_physics.radius, 30 );
		PhysicsJolt( rpg_physics.origin, rpg_physics.radius, rpg_physics.radius, vec );
		Line( rpg_physics.origin, targ.origin, (1,0,0), 1, 0, 50 );
		
		
		wait( 0.05 );
		if ( gettime() > start_time + time )
			break;
	}
	*/
//		PhysicsExplosionCylinder( rpg_physics.origin, rpg_physics.radius, rpg_physics.radius, 30 );
		//Print3d( rpg_physics.origin, "30" );
		//wait( 0.05 );
	//}
}

reverse_force()
{
	reverse_force = getent( "reverse_force", "targetname" );
	targ = getent( reverse_force.target, "targetname" );
	vec = targ.origin - reverse_force.origin;
	angles = vectortoangles( vec );
	forward = anglestoforward( angles );
	vec = forward * 3.5;
	

	PhysicsJolt( reverse_force.origin, 350, 350, vec );
	Line( reverse_force.origin, targ.origin, (0,0,1), 1, 0, 500 );
}

rpg_vehicle()
{
	self setmodel( "projectile_rpg7" );
	fx = getfx( "rpg_trail" );
	PlayFXOnTag( fx, self, "tag_origin" );

	fx = getfx( "rpg_muzzle" );
	PlayFXOnTag( fx, self, "tag_origin" );
	
	self waittill( "reached_end_node" );
	flag_set( "rpg_end" );
	self delete();
}

ride_scenes()
{
	//thread street_runner_scene();
	thread favela_flee_alley();
	thread roof_backup_scene();
	thread civ_balcony();
	thread garage_scene();
	thread window_waver();

	thread alley_runners();
	
	//thread corner_hider();
	
	array_spawn_function_noteworthy( "flee_if_seen", ::flee_if_seen );
	array_spawn_function_noteworthy( "run_and_delete", ::run_and_delete );
	
}

run_and_delete()
{
	self.ignoreme = true;
	self.ignoreall = true;
	self endon( "death" );
	
	if ( isdefined( self.script_delay ) )
	{
		self setgoalpos( self.origin );
		self.goalradius = 8;
		script_delay();
		self thread maps\_spawner::go_to_node();
	}

	self waittill( "reached_path_end" );
	self delete();
}

flee_if_seen()
{
	self.ignoreme = true;
	self.ignoreall = true;
	self endon( "death" );
	
	start_pos = self.origin;
	self waittill( "goal" );
	wait( 0.5 );
	
	add_wait( ::player_looks_at_me );
	add_wait( ::_wait, 4 );
	do_wait_any();
	
	self setgoalpos( start_pos );
	self.goalradius = 8;
	self waittill( "goal" );
	self delete();
}

player_looks_at_me()
{
	self endon( "death" );

	for ( ;; )
	{
		if ( within_fov_of_players( self.origin, 0.75 ) )
			return;
		wait( 0.05 );
	}
}


corner_hider()
{
	array_spawn_function_noteworthy( "corner_hider_spawner", ::corner_hider_spawner );
	//array_spawn_noteworthy( "corner_hider_spawner" );
}

bloody_pain( amount, attacker, dir, point, type, a, b )
{
	fx = getfx( "headshot" );
	forward = anglestoforward( dir );
	up = anglestoup( dir );
	PlayFX( fx, point, forward, up );	
	//Line( point, point + forward * 500, (1,0,0), 1, 1, 5000 );
}

corner_hider_spawner()
{
	self endon( "death" );
	self set_generic_deathanim( "facedown_death" );
	self add_damage_function( ::bloody_pain_reverse );
	self.health = 5000;
	// targets this guy so he is looking back
	//turret_alley_target = getent( "turret_alley_target", "targetname" );
	
	turret = level.crazy_ride_convoy[ "detour" ].mgturret[0];
	turret setmode( "manual" );
	turret SetTargetEntity( self );
	turret.dontshoot = true;
	owner = turret getturretowner();
	if ( isalive( owner ) )
		owner.ignoreall = true;
	
	trigger = getent( "detour_shoots_alley_guy_trigger", "targetname" );
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		if ( other == level.crazy_ride_convoy[ "detour" ] )
			break;
		wait( 0.05 );
	}
	
	//wait( 1.35 );

	flag_set( "trapper_spawners_ignoreme" );


	turret.dontshoot = undefined;
	wait( 0.5 );
	//self waittill( "damage" );
	struct = getstruct( "run_death_facedown", "targetname" );

	struct thread anim_generic_gravity( self, "facedown_death" );
	wait( 1 );

	self.a.nodeath = true;
	self kill();
	
	
	
	
	
	/*

	node = getnode( self.script_linkto, "script_linkname" );
	struct = getstruct( self.target, "targetname" ); 
	
	self.ignoreme = true;
	self.ignoreall = true;
	self endon( "death" );
	
	self.animname = "flee_alley";
	self.favoriteenemy = level.player;
	self.goalradius = 8;
	self setgoalnode( node );
	self setlookatentity( level.player );
	self disable_long_death();
	

	//wait( 2.34 );
	flag_wait( "ambush_guy_attacks" );
		
	// next node
	node = getnode( node.script_linkto, "script_linkname" );
	self setgoalnode( node );
	self.goalradius = 8;
	self.a.pose = "stand";
	self.a.movement = "run";

	// increase the time over which he blends in anim custom animmode
	self.anim_blend_time_override = 1;

	thread jumper_shoots_car_fx();
	struct anim_custom_animmode_solo( self, "gravity", "flee_shooting" );
	self setlookatentity();
	self waittill( "goal" );
	level notify( "jumper_reached_goal" );

	self delete();
	*/
}

jumper_shoots_car_fx()
{
	self endon( "death" );
	
	struct = getstruct( "jumper_fx", "targetname" );
	dirt_fx = getfx( "car_dirt" );
	spark_fx = getfx( "car_spark" );
	
	count = 0;
	
	for ( ;; )
	{
		self waittillmatch( "custom_animmode", "fire_spray" ); //whatever
		count++;
		
		link = getstruct( struct.script_linkto, "script_linkname" );
		angles = vectortoangles( link.origin - struct.origin );
		forward = anglestoforward( angles );
		
		fx = dirt_fx;
		alias = "bullet_large_dirt";
		if ( count > 6 )
		{
			fx = spark_fx;
			alias = "bullet_large_metal";
			//Line( struct.origin, struct.origin + forward * 50, (1,1,0), 1, 0, 150 );
		}
		else
		{
			//Line( struct.origin, struct.origin + forward * 50, (1,0,0.5), 1, 0, 150 );
		}

		thread play_sound_in_space( alias, struct.origin );
		PlayFX( fx, struct.origin, forward );
		if ( !isdefined( struct.target ) )
			break;
		struct = getstruct( struct.target, "targetname" );

		if ( count > 9 )
			level.player DoDamage( 20 / level.player.damageMultiplier, self.origin, self, self );
	}
	
	for ( ;; )
	{
		level.player DoDamage( 20 / level.player.damageMultiplier, self.origin, self, self );
		self waittillmatch( "custom_animmode", "fire_spray" ); //whatever
	}
}

alley_runners()
{
	array_spawn_function_noteworthy( "alley_runner_spawner_first", ::alley_runner_spawner_first );
	array_spawn_function_noteworthy( "alley_runner_spawner", ::alley_runner_spawner );

//	array_spawn_noteworthy( "alley_runner_spawner_first" );
//	array_spawn_noteworthy( "alley_runner_spawner" );
}

alley_runner_spawner_first()
{
	self endon( "death" );
	self.ignoreme = true;
	self.ignoreall = true;
	
	struct = getstruct( self.target, "targetname" );
	scene = struct.animation;
	
	struct anim_generic( self, scene );	
	
	self delete();	
}

wall_climber_ragdolls_on_pain( amt, attacker, force, b, c, d, e )
{
	if ( attacker != level.player )
		return;

	//self.allowdeath = true;
	//self kill();	
	self startragdoll();
	self remove_damage_function( ::wall_climber_ragdolls_on_pain );
}

alley_runner_spawner()
{
	self endon( "death" );
	self add_damage_function( ::wall_climber_ragdolls_on_pain );
	self disable_pain();
//	self magic_bullet_shield();
	self.ignoreall = true;
	self.ignoreme = true;
	self.disableBulletWhizbyReaction = true;
	self.ignoresuppression = true;
	
	self.ignoreall = true;
	
	pauses = [];
	pauses[ "unarmed_climb_wall" ]		= 1.2;
	pauses[ "unarmed_climb_wall_v2" ]	= 0;
	
	struct = getstruct( self.target, "targetname" );
	scene = struct.animation;
	pause = pauses[ scene ];
	wait( pause );
	
	struct anim_generic_reach( self, scene );	
	struct anim_generic( self, scene );	
	
	node = getnode( "alley_runner_node", "targetname" );
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
//	self stop_magic_bullet_shield();
	self delete();	
}

favela_flee_alley()
{
	// rounds a corner
	array_spawn_function_targetname( "favela_hide_spawner", ::favela_hide_spawner );
	flag_wait( "start_runner" );
	array_spawn_targetname( "favela_hide_spawner" );
}

favela_hide_spawner()
{
	self endon( "death" );
	self.animname = "flee_alley";
	struct = getstruct( self.target, "targetname" );
	struct thread anim_loop_solo( self, "idle" );
	wait( 5 );
	struct notify( "stop_loop" );
	struct thread anim_custom_animmode_solo( self, "gravity", "round_corner" );

	animation = self getanim( "round_corner" );
	for ( ;; )
	{
		if ( self getanimtime( animation ) > 0.8 )
			break;

		wait( 0.05 );
	}
	
	self setlookatentity( level.player );
	struct = getstruct( "hide_house_scene", "targetname" );
	struct anim_first_frame_solo( self, "hands_up" );
	wait( 1.7 );
	struct anim_single_solo( self, "hands_up" );
	self safe_delete();
	
}

window_waver()
{
	flag_wait( "garage_door_scene" );
	wait( 10 );
	
	spawner = getent( "window_wave_loop_spawner", "targetname" );
	spawner.script_drone_override = true;
	
	array_spawn_function_targetname( "window_wave_loop_spawner", ::window_wave_loop );
	array_spawn_targetname(	"window_wave_loop_spawner" );
}

window_wave_loop()
{
	self endon( "death" );
	self setlookatentity( level.player );
	start = self.origin;
	scene = self.script_noteworthy;
	struct = getstruct( self.target, "targetname" );
	struct thread anim_generic_loop( self, scene );
	wait( 13.4 );
	struct notify( "stop_loop" );
	self anim_stopanimscripted();
	self setgoalpos( start );
	self.goalradius = 5;
	wait( 5 );
	self delete ();
}

garage_scene()
{
// garage_door_scene_left
// garage_door_scene

	flag_wait( "garage_door_scene" );
	run_thread_on_targetname( "garage_pull_struct", ::garage_pull_struct );
	array_spawn_function_targetname( "garage_spawner", ::garage_spawner );
	
	garage_spawner_right            = getent( "garage_spawner_right", "script_noteworthy" );
	garage_spawner_left 			= getent( "garage_spawner_left", "script_noteworthy" );
//	garage_window_shouter_spawner 	= getent( "garage_window_shouter_spawner", "script_noteworthy" );
	garage_spawner 					= getent( "garage_spawner", "script_noteworthy" );
	
	garage_spawner_right delaythread( 0, ::spawn_ai );
	//garage_window_shouter_spawner delaythread( 0, ::spawn_ai );
	garage_spawner delaythread( 6.4, ::spawn_ai );
	garage_spawner_left delaythread( 3.4, ::spawn_ai );
}

garage_spawner()
{
	self endon( "death" );
	scene = self.script_noteworthy;
	start_org = self.origin;
	
	structs = [];
	structs[ "garage_spawner_right" ] = "garage_door_scene";
	structs[ "garage_spawner_left" ] = "garage_door_scene_left";
	structs[ "garage_spawner" ] = "garage_door_scene";
	structs[ "garage_window_shouter_spawner" ] = self.target;
	
	self.moveplaybackrate = 1;
	
	if ( scene == "garage_spawner_right" )
	{
		self.force_civilian_hunched_run = true;
	}
	else
	if ( scene == "garage_spawner_left" )
	{
		self.force_civilian_stand_run = true;
	}
	
	if ( isdefined( level.scr_anim[ "generic" ][ scene + "_run" ] ) )
	{
		self set_generic_run_anim( scene + "_run", false );
	}
	
	struct_name = structs[ scene ];
	                    
	struct = getstruct( struct_name, "targetname" );
	struct anim_generic_reach( self, scene );
	
	if ( scene == "garage_spawner" )
	{
		level.garage_puller = self;
		self disable_pain();
		self magic_bullet_shield();
		delaythread( 1.75, ::flag_set, "pull_garage" );
	}
	
	struct anim_generic( self, scene );
	
	return_to_goal = [];
	return_to_goal[ "garage_spawner_right" ] = false;
	return_to_goal[ "garage_spawner_left" ] = false;
	return_to_goal[ "garage_window_shouter_spawner" ] = true;
	return_to_goal[ "garage_spawner" ] = false;
	
	if ( !return_to_goal[ scene ] )
	{
		self setgoalpos( self.origin );
		wait( 5 );
		self safe_delete();
		return;
	}
	
	self setgoalpos( start_org );
	self.goalradius = 4;
	self waittill( "goal" );
	self safe_delete();
}

garage_pull_struct()
{
	// get the structs that control the height of the garage door
	lower_struct = self;
	mid_struct = getstruct( lower_struct.target, "targetname" );
	top_struct = getstruct( mid_struct.target, "targetname" );
	
	top_struct.origin += (0,0,10); //buffer
	
	// get the brushes that make up the door
	brushes = [];
	brush = top_struct;
	for ( ;; )
	{
		newbrush = getent( brush.target, "targetname" );
		brushes[ brushes.size ] = newbrush;
		if ( !isdefined( newbrush.target ) )
			break;
		brush = newbrush;
	}
	
	start_height = mid_struct.origin[ 2 ] - lower_struct.origin[ 2 ];

	// move the brushes up the start height
	foreach ( brush in brushes )
	{
		brush.start_origin = brush.origin;
		brush.origin += (0,0,start_height);

		if ( brush.origin[ 2 ] > top_struct.origin[ 2 ] )
			brush hide_notsolid();
	}
	
	flag_wait( "pull_garage" );
	thread play_sound_in_space( "scn_roadkill_garage_close", brushes[0].origin );
	
	level delaythread( 0.95, ::send_notify, "stop_pulling" );

	origins = [];
	origins[ origins.size ] = ( 0, 0, 420.637 );
	origins[ origins.size ] = ( 0, 0, 420.62 );
	origins[ origins.size ] = ( 0, 0, 419.686 );
	origins[ origins.size ] = ( 0, 0, 418.499 );
	origins[ origins.size ] = ( 0, 0, 415.63 );
	origins[ origins.size ] = ( 0, 0, 413.791 );
	origins[ origins.size ] = ( 0, 0, 412.708 );
	origins[ origins.size ] = ( 0, 0, 411.595 );
	origins[ origins.size ] = ( 0, 0, 411.204 );
	origins[ origins.size ] = ( 0, 0, 410.838 );
	origins[ origins.size ] = ( 0, 0, 411.314 );
	origins[ origins.size ] = ( 0, 0, 411.756 );
	origins[ origins.size ] = ( 0, 0, 412.38 );
	origins[ origins.size ] = ( 0, 0, 412.633 );
	origins[ origins.size ] = ( 0, 0, 409.838 );
	origins[ origins.size ] = ( 0, 0, 401.405 );
	origins[ origins.size ] = ( 0, 0, 388.418 );
//	origins[ origins.size ] = ( 0, 0, 369.622 );
//	origins[ origins.size ] = ( 0, 0, 369.832 );
//	origins[ origins.size ] = ( 0, 0, 369.826 );	
			
	thread garage_brushes_move( brushes, lower_struct, origins );
	
	for ( ;; )
	{
		if ( !brushes.size )
			break;
			
		foreach ( index, brush in brushes )
		{
			if ( brush.origin[ 2 ] < top_struct.origin[ 2 ] )
			{
				brush show_solid();
				brushes[ index ] = undefined;
			}
		}
		wait( 0.05 );
	}	
}

garage_brushes_move( brushes, lower_struct, origins )
{
	
	level endon( "stop_pulling" );
	println( "	origins = [];" );
	index = 0;
	for ( ;; )
	{
		//hand_org = level.garage_puller gettagorigin( "tag_inhand" );
		hand_org = origins[ index ];
		index++;
		//println( "	origins[ origins.size ] = ( 0, 0, " + hand_org[ 2 ] + " );" );
		
		difference = hand_org[ 2 ] - lower_struct.origin[ 2 ];
		foreach ( brush in brushes )
		{
			brush moveto( brush.start_origin + (0,0,difference), 0.1, 0, 0 );
		}

		if ( index >= origins.size )
			break;
		wait( 0.05 );
	}
	
	foreach ( brush in brushes )
	{
		brush moveto( brush.start_origin, 0.2, 0.1, 0.1 );
	}
}

street_runner_scene()
{
	flag_wait( "start_runner" );
	
	struct = getstruct( "street_runner_scene", "targetname" );
	spawner = getent( struct.target, "targetname" );
	guy = spawner spawn_ai();
	if ( spawn_failed( guy ) )
		return;

	guy.animname = "street_runner";
	animation = guy getanim( "scene" );
		
	struct thread anim_custom_animmode_solo( guy, "gravity", "scene" );	

	wait( 0.05 );
	guy SetAnimTime( animation, 0.18 );
	
	guy endon( "death" );
	guy.allowpain = true;
	guy.allowdeath = true;
	
	for ( ;; )
	{
		if ( guy getanimtime( animation ) > 0.95 )
			break;
		wait( 0.05 );
	}
	
	goalnode = getnode( guy.target, "targetname" );
	guy setgoalnode( goalnode );
	guy.goalradius = 8;
	guy waittill( "goal" );
	guy delete();
}

roof_backup_scene()
{
	flag_wait( "start_runner" );
	wait( 4 );
	
	struct = getstruct( "roof_backup_scene", "targetname" );
	spawner = getent( struct.target, "targetname" );
	guy = spawner spawn_ai();
	if ( spawn_failed( guy ) )
		return;

	guy.animname = "roof_backup";
	animation = guy getanim( "scene" );

	struct thread anim_single_solo( guy, "scene" );	

	wait( 0.05 );
	guy SetAnimTime( animation, 0.2 );
	guy endon( "death" );
	guy.allowpain = true;
	guy.allowdeath = true;
	
	for ( ;; )
	{
		if ( guy getanimtime( animation ) > 0.59 )
			break;
		wait( 0.05 );
	}
	
	guy delete();
}

civ_balcony()
{
	flag_wait( "start_balcony" );

	door = getent( "civ_run_door", "targetname" );
	trigger = getent( "civ_door_trigger", "targetname" );
	spawner = getent( "civ_balcony_spawner", "targetname" );
	struct = getstruct( "civ_balcony_physics", "targetname" );
	
//	wait( 10.00 );
	
	// open the door
	door connectpaths();
	//door notsolid();
	door RotateYaw( -90, 1, 0.5, 0.5 );
	guy = spawner spawn_ai();
	if ( spawn_failed( guy ) )
		return;
	
	
	
	
	node = getnode( guy.target, "targetname" );
	startpos = guy.origin;
	guy endon( "death" );
	
	guy waittill( "goal" );	
	guy.goalradius = 8;
	wait( 0.35 );
	
	// knock the cans off the balcony
	forward = anglestoforward( struct.angles );
	vec = forward * 0.15;
	PhysicsJolt( struct.origin, 32, 32, vec );
	
	wait( 1.8 );
	guy setgoalpos( startpos );

	// wait until he runs back inside
	trigger waittill( "trigger" );

	// time to close the door behind him
	door RotateYaw( 90, 1, 0.5, 0.5 );	
}

grenade_barrage_if_you_delay()
{
	// the time before you get grenades on you
	time = 10;
	frames = time * 20;
	
	count = 0;
	

	structs = getstructarray( "grenade_dismount_spawner", "targetname" );
	structs = array_randomize( structs );
	index = 0;
	
	wait_times = [];
	wait_times[ 0 ] = 3.2;
	wait_times[ 1 ] = 1.8;
	wait_times[ 2 ] = 0.5;
	wait_times[ 3 ] = 3.7;
	wait_times[ 4 ] = 1.3;
	wait_index = 0;
	
	for ( ;; )
	{
		if ( flag( "player_inside_ambush_house" ) )
		{
			if ( count > frames - 35 )
				count = frames - 35;
		}
		else
		{
			count++;
		}
		
		if ( count >= frames )
		{
			struct = random( structs );
			struct throw_grenade();
			index++;
			index %= structs.size;
			
			wait( wait_times[ wait_index ] );
			wait_index++;
			wait_index %= wait_times.size;
		}
		wait( 0.05 );
	}
}

dismount_enemy_spawner()
{
	self setthreatbiasgroup( "axis_dismount_attackers" );
	self.dont_ride_kill = true;
}

throw_grenade()
{
	target = getstruct( self.target, "targetname" );
	time = randomfloatrange( 3, 5 );
	MagicGrenade( "fraggrenade", self.origin, target.origin, time );
}

modify_dismount_spawner_threatbias()
{
	for ( ;; )
	{
		flag_wait( "player_inside_ambush_house" );
		setignoremegroup( "axis_dismount_attackers", "ally_with_player" );
		setignoremegroup( "ally_with_player", "axis_dismount_attackers" );

		flag_waitopen( "player_inside_ambush_house" );
		SetThreatBias( "axis_dismount_attackers", "ally_with_player", 0 );
		SetThreatBias( "ally_with_player", "axis_dismount_attackers", 0 );
	}
}

handle_player_exposing_himself_in_front_of_school()
{
	flag_wait( "player_exposes_on_street" );
	level.player SetThreatBiasGroup( "allies" );
	
	thread player_dies_if_he_goes_too_far();

	for ( ;; )
	{
		flag_wait( "player_exposes_on_street" );
		set_player_attacker_accuracy( 1000 );
		level.player.noPlayerInvul = true;
		level.player.threatbias = 50000;
		level.player EnableHealthShield( false );

		flag_waitopen( "player_exposes_on_street" );
		maps\_gameskill::updateAllDifficulty();
		level.player.noPlayerInvul = undefined;
		level.player.threatbias = 150;
		level.player EnableHealthShield( true );
	}
}

player_dies_if_he_goes_too_far()
{
	flag_clear( "player_dies_on_street" );
	flag_wait( "player_dies_on_street" );
	for ( ;; )
	{
		ai = getaiarray( "axis" );
		guy = random( ai );
		origin = (0,0,0);
		attacker = level.player;
		
		if ( isalive( guy ) )
		{
			origin = guy geteye();
			attacker = guy;
		}
			
		level.player DoDamage( 25, origin );
		delay = randomfloatrange( 0.1, 0.3 );
		wait( delay );
	}
}

handle_start_points_for_detour_humvee()
{
	switch( level.start_point )
	{
		case "default":
		case "intro":
		case "riverbank":
		case "move_out":
		case "convoy":
		case "ride":
		case "ambush":
			return;
	}	
		
	ride_vehicle_spawners = getentarray( "ride_vehicle_spawner", "targetname" );
	foreach ( spawner in ride_vehicle_spawners )
	{
		if ( spawner.script_index == 3 )
			spawner delete();
	}
}

player_gets_max_health_for_dismount()
{
	level.player endon( "death" );
	time = 4;
	frames = time * 20;
	for ( i = 0; i < frames; i++ )
	{
		level.player.health = level.player.maxhealth;
		wait( 0.05 );
	}		
}

intro_shepherd()
{
	shepherd_roamer_spawner = getent( "shepherd_roamer_spawner", "targetname" );
	shepherd_roamer_spawner add_spawn_function( ::intro_shepherd_think );
	shepherd_roamer_spawner spawn_ai();	
}

intro_shepherd_think()
{
	thread shepherd_roams_battlefield( self.target );
}

shepherd_roams_battlefield( target )
{
	self endon( "death" );
	self.animname = "shepherd";
	self.ignoreall = true;
	self gun_remove();
	self.disablearrivals = true;
	self.disableexits = true;
	self set_run_anim( "angry_walk" );
	self notify( "stop_going_to_node" );
	
	//self setlookatentity( level.player );
	struct = getstruct( "shepherd_intro_active", "targetname" );
	struct anim_first_frame_solo( self, "roadkill_cover_active_leader" );
	//wait( 1 );
	wait( 0.2 );
	struct thread anim_single_solo( self, "roadkill_cover_active_leader" );
	//wait( 7 );
	//self setlookatentity();
	self waittillmatch( "single anim", "end" );
	
	//struct thread anim_loop_solo( self, "shepherd_cover" );
	//wait( 3 );
	struct notify( "stop_loop" );
	self anim_stopanimscripted();
	
	self Attach( "com_hand_radio", "tag_inhand" );	

	self waittill( "goal" );
	shepherd_walk_struct = getstruct( "shepherd_walk_struct", "targetname" );
	self setgoalpos( shepherd_walk_struct.origin );
	self.goalradius = 16;
	self waittill( "goal" );
	
//	wander_battlefield_until_time_to_stop( target );
	struct = getstruct( "shepherd_riverside_wander_struct", "targetname" );
	struct anim_reach_solo( self, "angry_wander" );
	struct thread anim_custom_animmode_solo( self, "gravity", "angry_wander" );
	
	flag_wait( "bridgelayer_complete" );
	/*
	
	// stop scenes in progress
	for ( ;; )
	{
		if ( !isdefined( target ) )
			break;
			
		struct = getstruct( target, "targetname" );
		struct notify( "stop_loop" );
		target = struct.target;
	}
	*/
	
	self anim_stopanimscripted();
	self notify( "killanimscript" );
	
	struct = getstruct( "shepherd_wander_struct", "targetname" );
	struct anim_reach_solo( self, "stair_approach" );
	struct anim_single_solo( self, "stair_approach" );
	struct anim_loop_solo( self, "stair_idle" );
}

wander_battlefield_until_time_to_stop( target )
{
	if ( flag( "bridgelayer_complete" ) )
		return;
	level endon( "bridgelayer_complete" );

	first_target = target;
	for ( ;; )
	{
		if ( !isdefined( target ) )
			target = first_target;
			
		struct = getstruct( target, "targetname" );
		if ( isdefined( struct.script_delay ) )
		{
			struct anim_reach_solo( self, "idle_reach" );
			struct thread anim_loop_solo( self, "idle" );
			wait ( struct.script_delay );
			struct notify( "stop_loop" );
			self anim_stopanimscripted();
		}
		else
		{
			self setgoalpos( struct.origin );
			self.goalradius = struct.radius;
			self waittill( "goal" );
		}
		target = struct.target;
	}
}

intro_runner_path_breaker()
{
	brush = getent( "intro_runner_path_breaker", "targetname" );
	brush disconnectpaths();
	brush notsolid();
	
	wait( 5 );
	brush solid();
	brush connectpaths();
	brush delete();
}

school_unreachable_spawner()
{
	self endon( "death" );
	flag_wait( "roadkill_school_14" );
	self delete();
}

ambusher_spawner()
{
	level.ambusher = self;
	self.ignoreall = true;
	self.ignoreme = true;
	flag_wait( "ambush_spawner_angry" );
	self.ignoreme = false;
	if ( isalive( self ) )
	{
		self.threatbias = 50000;
		self.ignoreall = false;
		//self.ignoreme = true;
		
		link = getent( self.script_linkto, "script_linkname" );
		self SetEntityTarget( link );
		wait( 3 );
		self ClearEntityTarget();
	}
	
	if ( isalive( self ) )
	{
		self waittill( "death" );
		// yay ignoreme after death!
		wait( 2 );
		if ( isdefined( self ) )
			self.ignoreme = true;		
	}
}

ignore_until_attack()
{
	self endon( "death" );
	self.ignoreme = true;
	self waittill( "shooting" );
	wait( 0.5 );
	self.ignoreme = false;
}

trapper_spawner()
{
	// so other friendly doesn't crossfire
	self endon( "death" );
	flag_wait( "trapper_spawners_ignoreme" );
	self.ignoreme = true;
}

trapper_killer_trigger()
{
	trigger = getent( "trapper_killer_trigger", "targetname" );
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		other delete();
	}
}

no_grenades()
{
	self.grenadeAmmo = 0;
}

gaz_balcony_guys()
{
	run_thread_on_targetname( "gaz_balcony", ::gaz_balcony );
}

gaz_balcony()
{
	spawner = getent( self.target, "targetname" );
	spawner.script_drone_override = true;
	spawner add_spawn_function( ::gaz_balcony_think, self );
	spawner spawn_ai();	
}

gaz_balcony_think( struct )
{
	self endon( "death" );
	self setlookatentity( level.player );
	self gun_remove();
	self.allowdeath = true;
	self.health = 1;
	self.ignoreall = true;
	self.ignoresuppression = true;
//	self.ignoreme = true;
	self.custom_scene = struct.animation;
	self.price_idle = struct.animation == "killhouse_sas_price_idle";
	self.first_scene = "killhouse_gaz_idleB";
	if ( self.price_idle )
		self.first_scene = "killhouse_sas_price_idle";

	if ( self.custom_scene == "killhouse_gaz_idleB" )
	{
		// offset anim
		wait( 2.5 );
	}
	else
	{
		wait( randomfloat( 1.5 ) );
	}
	
	struct thread anim_generic_loop( self, self.first_scene );
	flag_wait( "garage_door_scene" );
	//wait( 3 );

	idle_until_tired_of_idling_or_shot_at( struct );
	timer = randomfloat( 0.65 );
	wait( timer );
	struct notify( "stop_loop" );
	self anim_stopanimscripted();
	self waittill( "goal" );
	wait( 90 );
	self delete();
}

idle_until_tired_of_idling_or_shot_at( struct )
{		
	self endon( "bulletwhizby" );
	if ( !self.price_idle )
	{
		struct notify( "stop_loop" );
		struct anim_generic( self, self.custom_scene + "_solo" );
		struct anim_generic( self, self.custom_scene + "_solo" );
		struct thread anim_generic_loop( self, self.first_scene );
	}
	
	wait( 60 );
}

player_vehicle_catches_up()
{
	flag_wait( "start_runner" );
	for ( ;; )
	{
		if ( distance( level.crazy_ride_convoy[ "player" ].origin, level.crazy_ride_convoy[ "detour" ].origin ) <= 320 )
			break;
		wait( 0.05 );
	}
	
	flag_set( "player_closes_gap" );
}

slow_down_to_speed_when_you_get_dist_from_ent( speed, ent, dist )
{
	for ( ;; )
	{
		if ( distance( self.origin, ent.origin ) <= dist )
		{
			self vehicle_setspeed( speed, 5, 5 );
			break;
		}
		wait( 0.05 );
	}
}

riverbank_mg()
{
	self delete();

	/*
	self setmode( "manual" );
	self settargetentity( level.player );
	for ( ;; )
	{
		bursts = randomintrange( 4, 7 );
		for ( i = 0; i < bursts; i++ )
		{
			self startfiring();
			burst_time = randomfloatrange( 0.5, 1 );
			wait( burst_time );
			self stopfiring();
			
			timeout_time = randomfloatrange( 0.2, 0.8 );
			wait( timeout_time );
		}		

		timeout_time = randomfloatrange( 1.0, 1.5 );
		wait( timeout_time );
	}
	*/
}

radio_dialogue_generic( alias )
{
	if ( !isdefined( level.scr_radio[ alias ] ) )
	{
		level.scr_radio[ alias ] = level.scr_sound[ "generic" ][ alias ];
	}
	radio_dialogue( alias );
}

ahead_line( alias )
{
	play_line_at_offset_on_player_vehicle( alias, (0,2500,0) );	
}

way_ahead_line( alias )
{
	play_line_at_offset_on_player_vehicle( alias, (0,4000,0) );	
}

shot_fired_trigger()
{
	self waittill( "trigger" );
	struct_end = getstruct( self.target, "targetname" );
	struct_start = getstruct( struct_end.target, "targetname" );
	
	end = struct_end.origin;
	original_end = end;
	start = struct_start.origin;
	
	angles = vectortoangles( start - end );
	forward = anglestoforward( angles );
	dist = distance( end, start );

	
	end += forward * -1000;
	
	flag_set( "shot_rings_out" );
//	Print3d( start, "bullet", (1,0,0), 1, 2, 1000 );
	//Print3d( start, "sound", (0,1,0.5), 1, 2, 1000 );
	thread play_sound_in_space( "weap_dragunovsniper_fire_plr", start );
	
	units_per_second = 9000;
	time = dist / units_per_second;
	wait( time * 0.6 );
	
	thread play_sound_in_space( "whizby_triggered", end );

	wait ( time * 0.4 );

//	Line( start, original_end, (0.5,0.5,0), 1, 1, 1000 );
//MagicBullet( "scripted_silent", start, end );
	
	trace = BulletTrace( start, end, true, undefined );
	pos = trace[ "position" ];
	
	fx = getfx( "car_dirt" );
	sound = "concrete";
	if ( trace[ "surfacetype" ] != "concrete" )
	{
		fx = getfx( "car_spark" );
		sound = "metal";
	}
	
	PlayFX( fx, pos, forward );
	PlayFX( fx, pos, forward );


	brick_sounds = [];	
	brick_sounds[ brick_sounds.size ] = "ride_bullet_brick_1";
	brick_sounds[ brick_sounds.size ] = "ride_bullet_brick_2";

	metal_sounds = [];
	metal_sounds[ metal_sounds.size ] = "ride_bullet_metal_1";
	metal_sounds[ metal_sounds.size ] = "ride_bullet_metal_3";
	metal_sounds[ metal_sounds.size ] = "ride_bullet_metal_2";
	metal_sounds[ metal_sounds.size ] = "ride_bullet_metal_4";
	metal_sounds[ metal_sounds.size ] = "ride_bullet_metal_5";

	sounds = [];
	sounds[ "concrete" ] = brick_sounds;
	sounds[ "metal" ] = metal_sounds;

	if ( !isdefined( level.magic_sound_index ) )
		level.magic_sound_index = [];
	
	if ( !isdefined( level.magic_sound_index[ sound ] ) )
	{
		level.magic_sound_index[ sound ] = 0;
	}
	
	index = level.magic_sound_index[ sound ];
	alias = sounds[ sound ][ index ];
	thread play_sound_in_space( alias, pos, true );
	
	level.magic_sound_index[ sound ]++;
	level.magic_sound_index[ sound ] %= sounds[ sound ].size;
	
		
//	Line( start, end, (1,0,0), 1, 1, 1000 );
//	Print3d( trace[ "position" ], "HIT", (1,0,0), 1, 2, 1000 );
	
}


rpg_ambush_spawner()
{
//	self.ignoreall = true;
	self setentitytarget( level.crazy_ride_convoy[ "detour" ] );
	self.interval = 0;
	
	if ( !isdefined( self.script_delay ) )
		return;

	self setgoalpos( self.origin );
	script_delay();
	self maps\_spawner::go_to_node();
}

hydrant_hit()
{
	hydrant_struct = getstruct( "hydrant_struct", "targetname" );
	RadiusDamage( hydrant_struct.origin, hydrant_struct.radius, 5000, 5000, level.player );	
}

technical_pushed_animation()
{
	technical = level.traffic_jam_truck;
	technical.animname = "technical";

	struct = spawnstruct();
	struct.origin = (0,0,0);
	struct.angles = (0,0,0);
	struct thread anim_single_solo( technical, "technical_pushed" );
	wait( 0.05 );
	animation = technical getanim( "technical_pushed" );
	technical SetAnim( animation, 1, 0, 1.07 );
}