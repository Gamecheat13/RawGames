#include maps\_utility;
#include maps\_utility_code;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\hamburg_code;
#include maps\hamburg_hovercraft_code;
#include animscripts\hummer_turret\common;
#include maps\hamburg_tank_ai;
#include maps\hamburg_landing_zone;

//---------------------------------------------------------
// Init
//---------------------------------------------------------
init_intro()
{
	if ( IsDefined( level.init_intro ) )
	{
		return;
	}

	level.init_intro = true;
	//level.only_one_heli_fire = false;
	level.respawn_friendlies_force_vision_check = true;

	add_global_spawn_function( "allies", ::enable_replace_on_death );

	rockets = GetEntArray( "intro_rocket", "script_noteworthy" );
	array_thread( rockets, ::intro_rocket_thread );

	triggers = GetEntArray( "activate_on_vehiclenode_trigger", "script_noteworthy" );
	array_thread( triggers, ::activeate_on_vehiclenode_trigger );

	array_spawn_function_noteworthy( "intro_rocket", ::postspawn_rocket_vehicle );
	array_spawn_function_noteworthy( "nearby_hovercraft", ::postspawn_nearby_hovercraft );
	array_spawn_function_noteworthy( "distant_hovercraft", ::postspawn_distant_hovercraft );

	PrecacheRumble( "damage_heavy" );
	PrecacheRumble( "damage_light" );
	PrecacheRumble( "grenade_rumble" );
	
	thread do_rockety_dodge();
//	thread enable_friendly_reinforcements();

}

do_rockety_dodge()
{
	rockety_dodges = getstruct( "rockety_dodge" , "script_noteworthy" );
	rockety_dodges waittill ( "trigger", other  );
	other thread rockety_flarey_dodge();
	rockets = spawn_vehicles_from_targetname_and_drive( "dodgy_rocket" );
	array_thread( rockets, ::postspawn_rocket_vehicle );
}

rockety_flarey_dodge()
{
	wait 0.5;
	for ( i = 0 ; i < 14 ; i++ )
	{
		PlayFXOnTag( getfx( "flares_rockety_dodge" ), self, "tag_light_belly" );
		//playfxontag( getfx( "flares_rockety_dodge" ), self getTagOrigin( "tag_light_belly" ), (0,0,1) );
		wait 0.05;
	}
}
enable_replace_on_death()
{
	if ( !IsDefined( self.script_forcecolor ) )
	{
		return;
	}

	self replace_on_death();

//	wait( 1 );
//	guys = get_force_color_guys( "allies", "r" );
//	array_thread( guys, ::replace_on_death );

//	guys = get_force_color_guys( "allies", "y" );
//	array_thread( guys, ::replace_on_death );

//	guys = get_force_color_guys( "allies", "o" );
//	array_thread( guys, ::replace_on_death );
}

intro_cleanup()
{
	flag_set( "intro_complete" );

	level notify( "kill_color_replacements" );
	level.respawn_spawner_org = undefined;
	level.only_one_heli_fire = undefined;
	level.respawn_friendlies_force_vision_check = undefined;
}

#using_animtree( "vehicles" );
intro_setup()
{
	// Override the hovercraft geo trail
//	level._effect[ "hovercraft_wake_geotrail" ]	= LoadFX( "treadfx/hovercraft_wake_trail_hamburg" );

	SetSavedDvar( "sm_sunsamplesizenear", 1.0 );
	hovercraft_exit_node = GetVehicleNode( "hover_craft_one_exit", "targetname" );
	players_tank = level.player_tank;

	players_tank_end_path = GetVehicleNode( "tank_track_e1_a_pre", "targetname" );
	if ( IsDefined( players_tank_end_path ) )
	{
		players_tank.attachedpath = players_tank_end_path;
		players_tank AttachPath( players_tank_end_path );
	}
	
	other_tank = spawn_vehicle_from_targetname( "craft_2_tank2" );
	add_cleanup_ent( other_tank,  "craft_2_tank2" );
	
	hovercraft = spawn_vehicle_from_targetname_and_drive( "hover_craft_one" );
	hovercraft hovercraft_init();
	
	level.players_hover_craft = hovercraft;
	
	hovercraft Vehicle_SetSpeed( 0, 100 );
	hovercraft SetAnim( %hovercraft_rocking );
	
	hovercraft godon();
	
	other_tank godon();
	players_tank godon();
	
	hovercraft reference_vehicles_to_hovercraft( players_tank, other_tank );
	
	dummy = players_tank get_dummy();
	
//	linkoffset = spawn_tag_origin();
//	linkoffset LinkTo( dummy, "tag_guy0", ( 0, 0, -34 ), ( 0, 0, 0 ) );
}

//---------------------------------------------------------
// Spawn Functions
//---------------------------------------------------------
postspawn_nearby_hovercraft()
{
	waittillframeend;

	self.nearby_hovercraft = true;
	self.use_big_splash = true;
	info = self.water_splash_info;

	info.water_fx[ "water_big" ] = getfx( "hovercraft_side_spray" );

	self add_hovercraft();
}

postspawn_distant_hovercraft()
{
	self add_hovercraft();
}

add_hovercraft()
{
	if ( !IsDefined( level.hovercrafts ) )
	{
		level.hovercrafts = [];
	}

	level.hovercrafts[ level.hovercrafts.size ] = self;
}

postspawn_rocket_vehicle()
{
	self SetModel( "projectile_rpg7" );
	fx = getfx( "rpg_trail" );
	PlayFXOnTag( fx, self, "tag_origin" );

//	fx = getfx( "rpg_muzzle" );
//	PlayFXOnTag( fx, self, "tag_origin" );
//	self PlaySound( "weap_rpg_fire_npc" );

	if ( IsDefined( self.script_sound ) )
	{
		if ( IsDefined( self.script_wait ) )
		{
			self delaycall( self.script_wait, ::PlaySound, self.script_sound );
		}
		else
		{
			self PlaySound( self.script_sound );
		}
	}
	else
	{
		self PlayLoopSound( "weap_rpg_loop" );
	}

	if ( IsDefined( self.groupname ) )
	{
		if ( self.groupname == "near_player" )
		{
			self add_rocket_detection();
		}
	}

	self waittill( "reached_end_node" );

	if ( IsDefined( self.script_exploder ) )
	{
		exploder( self.script_exploder );
	}
	else if ( IsDefined( self.script_fxid ) )
	{
		PlayFx( getfx( self.script_fxid ), self.origin, AnglesToForward( self.angles ) );
	}
	else if ( IsDefined( self.script_parameters ) )
	{
		if ( self.script_parameters == "flak_burst" )
		{
			flak_burst( self.origin );
		}
	}

	self Delete();
}

add_rocket_detection()
{
	if ( !IsDefined( level.detected_rockets ) )
	{
		level.detected_rockets = [];
	}

	level.detected_rockets = array_removeundefined( level.detected_rockets );
	level.detected_rockets[ level.detected_rockets.size ] = self;
}

incoming_rocket_detector()
{
	alias = "missile_lock_alarm";
	sound_playing = false;

	while ( !flag( "intro_complete" ) )
	{
		if ( !IsDefined( level.detected_rockets ) )
		{
			wait( 0.5 );
			continue;
		}

		level.detected_rockets = array_removeundefined( level.detected_rockets );

		if ( level.detected_rockets.size > 0 && !sound_playing )
		{
			sound_playing = true;
			self thread play_loop_sound_on_entity( alias );
		}
		else if ( level.detected_rockets.size == 0 && sound_playing )
		{
			wait( 2 );
			sound_playing = false;			
			self notify( "stop sound" + alias );
		}

		wait( 0.5 );
	}
}

// Reinforcement spawning/flyin
reinforcement_flyin()
{
	trigger = GetEnt( "beach_reinforcement_counter", "targetname" );

	last_time = GetTime();
	while ( !flag( "intro_complete" ) )
	{
		guys = GetAiArray( "allies" );

		guys_touching = [];
		foreach ( guy in guys )
		{
			if ( guy IsTouching( trigger ) )
			{
				guys_touching[ guys_touching.size ] = guy;
			}
		}

		if ( guys_touching.size >=3 || GetTime() > ( last_time + 10000 ) )
		{
			if ( guys_touching.size > 0 )
			{
				do_reinforcement_flyin( guys_touching );
				last_time = GetTime();
			}
		}

		wait( 1 );
	}

	guys = GetAiArray( "allies" );
	foreach ( guy in guys )
	{
		if ( guy IsTouching( trigger ) )
		{
			guy Delete();
		}
	}

	trigger Delete();

	trigger = GetEnt( "beach_reinforcement_trigger", "script_noteworthy" );
	trigger Delete();
}

do_reinforcement_flyin( guys )
{
	chopper = spawn_vehicle_from_targetname_and_drive( "beach_reinforcement_blackhawk" );

	foreach ( idx, guy in guys )
	{
		if ( idx > 5 )
		{
			break;
		}

		chopper thread maps\_vehicle_aianim::guy_enter( guy );
	}

	chopper waittill( "unloaded" );
}


//---------------------------------------------------------
// Ride in
//---------------------------------------------------------
intro_ride_in()
{
	init_intro();
	intro_setup();

	maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
	SetSavedDvar( "ui_hideMap", "1" );
	
	structs = getstructarray( "fire_at_random_targets" , "script_noteworthy" );
	array_thread( structs, ::apache_fire_at_random_targets );

	thread osprey_landing();
	thread ride_in_dialogue();
	
	level.player DisableWeapons();
	
	level.mortar_min_dist = 1;
	level.noMaxMortarDist = true;
	level.playerMortarFovOffset = ( 0, 50, 0 );
	thread delaythread( 0, maps\_mortar::bog_style_mortar_on, 1 );
	thread delaythread( 15, maps\_mortar::bog_style_mortar_on, 2 );

	thread spawn_aircraft();
	thread hover_craft_drive_by();
	thread hovercraft_mortars();
	thread aircraft_flak();

	level.players_hover_craft SetAnim( %hovercraft_rocking );
	
	thread hovercraft_do_other_tank( "hover_craft_four", "craft_4_tank1", "craft_4_tank2" );
	thread hovercraft_do_other_tank_friend( "hover_craft_two" );

	level.players_hover_craft SetAnim( %hovercraft_rocking );
	level.players_hover_craft ResumeSpeed( 100 );
		
	delayThread( 6, ::ambient_flak_at_player );
	

//	ac130_volley = GetVehicleNode( "ac130_volley", "script_noteworthy" );
//	ac130_volley waittill ( "trigger" );
	
//	level.players_hover_craft waittill ( "reached_end_node" );
//	level.players_hover_craft ClearAnim( %hovercraft_rocking, 1 );
	
//	level.players_hover_craft SetAnim( %lcac_deflate );
	
//	timer = gettime();
//	waittime = GetAnimLength( %lcac_deflate );
	
	level.player_tank waittill( "exited_hovercraft" );
	
	maps\_mortar::bog_style_mortar_off( 1 );
	
	delaythread( 2, ::music_stop, 2 );
//	thread exit_player_hovercraft( timer, waittime );
}

spawn_close_chopper( name )
{
	chopper = spawn_vehicle_from_targetname_and_drive( name );
	chopper SetMaxPitchRoll( 30, 60 );
	chopper SetYawSpeedByName( "slow" );
	chopper.path_gobbler = true;
	chopper.script_vehicle_selfremove = true;

	chopper add_intro_aircraft();

	if ( name == "intro_crash_blackhawk" )
	{
		chopper thread crash_blackhawk_think();
	}

	chopper thread bullet_spray( "dropoff_osprey_go", ( -300, 0, -200 ), ( 300, 0, 200 ) );
//	chopper thread bullet_spray( "dropoff_osprey_go", ( -300, 0, -300 ), ( 300, 0, 300 ) );
}

crash_blackhawk_think()
{
	struct = getstruct( "intro_crash_blackhawk_death_spot", "targetname" );
	self.perferred_crash_location = struct;
	self.heli_crash_indirect_zoff = -800;
	self.preferred_crash_style = 0;
	self.no_rider_death = true;

	self ent_flag_init( "do_fake_death" );
	self ent_flag_wait( "do_fake_death" );

	PlayFXOnTag( getfx( "blackhawk_explosion" ), self, "tag_engine_left" );
	self DoDamage( self.health, self.origin );

	level.player PlayRumbleOnEntity( "grenade_rumble" );
	
	
	riders = self.riders;
	
	foreach( rider in self.riders )
	{
		self thread  maps\_vehicle_aianim::guy_idle( rider, rider.vehicle_position, true );
	}	

	wait( 0.3 );
	thread radio_dialog_add_and_go( "tank_bhp2_imhit" );
	flag_set( "helix_three_two_hit" );
	
	riders = array_randomize( riders );
	
	foreach ( rider in riders )
	{
		if ( !IsDefined( rider ) )
			continue;
		if ( !IsAlive( rider ) )
			continue;
			
		if ( rider.vehicle_position == 0 || rider.vehicle_position == 1 )
		{
			rider Delete();
			continue;
		}
			
		rider unlink();
		rider notify ( "newanim" );
		rider StopAnimScripted();
		rider.skipDeathAnim = true;
		rider Kill();
		rider StartRagdoll();
		wait( RandomFloatRange( 0.1, 0.4 ) );
	}
}

spawn_aircraft()
{
	thread player_blackhawk_spawn_think();

	spawn_close_chopper( "intro_crash_blackhawk" );
	spawn_close_chopper( "intro_extra_blackhawk" );

	apache_spawners = GetEntArray( "intro_apache", "script_noteworthy" );
	spawn_array_aircraft( apache_spawners );

	flag_wait( "ospreys_go" );
	
	wait 1;
	
	thread radio_dialog_add_and_go( "tank_op1_eta30sec" );
	thread radio_dialog_add_and_go( "hamburg_op2_raptorinbound" );
	thread radio_dialog_add_and_go( "tank_op1_onthedeck" );
	
	delaythread( 12, ::do_f15s );
	
	osprey = spawn_vehicle_from_targetname_and_drive( "extra_osprey" );
	osprey thread osprey_crash();

	osprey_spawners = GetEntArray( "intro_osprey", "script_noteworthy" );
	spawn_array_aircraft( osprey_spawners );
}

do_f15s()
{
	f15s = spawn_vehicles_from_targetname_and_drive( "intro_f15" );
	array_thread( f15s, ::postspawn_f15 );	
	radio_dialog_add_and_go( "tank_f16_egressingnorth" );
	delaythread( 4, ::radio_dialog_add_and_go, "tank_f16_impact" );

}

postspawn_f15()
{
	self endon( "death" );
	self waittill( "f15_shoot" );

	for ( i = 0; i < 2; i++ )
	{
		self thread f15_rocket();

		wait( RandomFloatRange( 0.25, 0.5 ) );
	}
}

f15_rocket()
{
	model = spawn_tag_origin();
	model.origin = self.origin + ( 0, 0, -180 );

	speed = 14000;
	dist = 30000;
	time = dist / speed;

	fx = getfx( "f15_missile_trail" );
	PlayFXOnTag( fx, model, "tag_origin" );

	model MoveTo( model.origin + ( 0, dist, 0 ), time );
	model waittill( "movedone" );
	model Delete();

}

spawn_array_aircraft( spawners )
{
	foreach ( spawner in spawners )
	{
		if ( !IsSpawner( spawner ) )
		{
			continue;
		}

		vehicle = spawner spawn_vehicle_and_gopath();
		vehicle.path_gobbler = true;

		vehicle add_intro_aircraft();
	}
}

add_intro_aircraft()
{
	if ( !IsDefined( level.intro_aircraft ) )
	{
		level.intro_aircraft = [];
	}

	level.intro_aircraft[ level.intro_aircraft.size ] = self;
}

hover_craft_drive_by() 
{
	all_crafts =[ "hover_craft_five", "hover_craft_seven", "hover_craft_nine" ];
	spawned_crafts = [];
	foreach( craftname in all_crafts )
		thread spawn_vehicles_from_targetname_and_drive( craftname );
}


osprey_crash()
{
	self endon( "death" );

	self ent_flag_init( "hit" );
//	self ent_flag_wait( "hit" );
	
	self waittill( "damage", amount, attacker, direction_vec, point, type );
	tag = "J_Pivot_RI";
	trail_fx = getfx( "osprey_trail" );
	explosion_fx = getfx( "osprey_explosion" );
	PlayFx( explosion_fx, point );

	PlayFXOnTag( getfx( "blackhawk_explosion" ), self, tag );

	level.player PlayRumbleOnEntity( "grenade_rumble" );

	self thread osprey_splash();

	time = GetTime();

	count = 0;
	delays[ 0 ] = time + 1500;
	delays[ 1 ] = time + 2500;
	delays[ 2 ] = time + 2700;
	delays[ 3 ] = time + 4000;
	delays[ 4 ] = time + 5000;

	while ( 1 )
	{
		PlayFxOnTag( trail_fx, self, tag );
		wait( 0.05 );

		if ( count > delays.size - 1 )
		{
			continue;
		}

		if ( GetTime() > delays[ count ] )
		{
			count++;
			PlayFxOnTag( explosion_fx, self, tag );
			self PlaySound( "blackhawk_helicopter_secondary_exp" );
		}
	}
}

osprey_splash()
{
	self waittill( "splash" );
	fx = getfx( "osprey_splash" );
	z = -178;

	PlayFx( fx, ( self.origin[ 0 ], self.origin[ 1 ], z ) );
	thread play_sound_in_space( "scn_hamburg_osprey_water_splash1", ( self.origin[ 0 ], self.origin[ 1 ], z ) );
}

osprey_landing()
{
	flag_wait( "dropoff_osprey_go" );

	osprey = spawn_vehicle_from_targetname_and_drive( "intro_heli_drop_off" );
	osprey ent_flag_init( "guys_unloaded" );
	osprey add_intro_aircraft();

	osprey waittill ( "unloaded" );
	osprey ent_flag_set( "guys_unloaded" );
	
	osprey.script_vehicle_selfremove = true;

//	lift_off_path = GetVehicleNode( "lift_off_path", "targetname" );
//	intro_heli_drop_off AttachPath( lift_off_path );
//	intro_heli_drop_off thread vehicle_paths( lift_off_path );
}

ambient_flak_at_player()
{
	for ( i = 0; i < 5; i++ )
	{
		wait( RandomFloatRange( 0.5, 1 ) );
		exploder( "intro_flak_at_player" );
	}
}


player_blackhawk_spawn_think()
{
	chopper = Spawn_Vehicle_From_targetname_and_drive( "player_blackhawk" );
	chopper.path_gobbler = true;
	chopper godon();
	chopper SetMaxPitchRoll( 20, 60 );
	chopper.script_vehicle_selfremove = true;
//	chopper SetYawSpeedByName( "slow" );
//	chopper SetTurningAbility( 0.0001 );
	level.player_blackhawk = chopper;

	chopper vehicleusealtblendedaudio( true );

	chopper thread incoming_rocket_detector();
	chopper add_intro_aircraft();
	chopper put_sandman_on_heli();	
	
	thread turn_on_vehicle_sounds();

	chopper.player_link_ent = spawn_tag_origin();
	chopper.player_link_ent LinkTo( chopper, "tag_player", ( 23, 0, -10 ), ( 0, -60, 0 ) );
	
	level.player allowcrouch( false );

	level.player PlayerLInkToDelta( chopper.player_link_ent, "tag_player", 0.8, 35, 20, 30, 20, false );
	level.player SetPlayerAngles( ( 0, chopper.angles[ 1 ] - 60, 0 ) );

	level thread player_ride_shake();
	chopper thread bullet_spray( "dropoff_osprey_go", ( 100, 0, -50 ), ( 300, 0, 50 ) );
	chopper thread bullet_spray( "dropoff_osprey_go", ( 100, 0, -100 ), ( 300, 0, 100 ) );
	
	all_vehicles = Vehicle_GetArray();
	all_vehicles = array_remove( all_vehicles, chopper );
	foreach( v in all_vehicles )
	{
		v Vehicle_TurnEngineOff();
	}
	
	chopper waittill( "unloaded" );	
	chopper vehicleusealtblendedaudio( false );

	all_vehicles = Vehicle_GetArray();
	all_vehicles = array_remove( all_vehicles, chopper );
	foreach( v in all_vehicles )
	{
		if ( !v isCheap() && Distance( v.origin, level.player.origin ) < 5000 )
		{
			v Vehicle_TurnEngineOn();
		}
	}
	
	lerp_out_sunsample( 4, GetDvarFloat( "sm_sunsamplesizenear" ), 0.25 );
	
	set_ambient( "hamburg_beach" );

	thread do_crane_event();

	flag_set( "player_unloading" );
	level.player lerp_player_view_to_position_oldstyle( (1608.04, -4347.19, -139.875), (0, 17.5388, 0), 1 );

	//chopper delete();
	level.player AllowStand( true );
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	level.player AllowJump( true );

	flag_set( "player_unloaded" );
}

turn_on_vehicle_sounds()
{
	getstruct( "turn_on_vehicle_sounds", "script_noteworthy" ) waittill ( "trigger" );
	
	flag_set( "over_hovercrafts" );
	
	hovercrafts = GetEntArray( "script_vehicle_hovercraft", "classname" );
	foreach( craft in hovercrafts )
	{
		if( IsSpawner( craft ) )
			continue;
		craft Vehicle_TurnEngineOn();
	}
	
}

player_ride_shake()
{
	level endon( "player_unloading" );
	
	while ( 1 )
	{
		power = RandomFloatRange( 0.05, 0.1 );
		Earthquake( power, 0.5, level.player.origin, 200 );
		wait( 0.2 );
	}
}

unload_blackhawk()
{
	player_blackhawk = get_vehicle( "player_blackhawk", "targetname" );
	if( !isdefined( player_blackhawk ) )
		return;
	player_blackhawk vehicle_unload();
}

//exit_player_hovercraft( timer, waittime )
//{
//	wait_for_buffer_time_to_pass( timer, waittime );
//	hovercraft_exit_node = GetVehicleNode( "hover_craft_one_exit", "targetname" );
//	level.players_hover_craft AttachPath( hovercraft_exit_node );
//	level.players_hover_craft thread vehicle_paths( hovercraft_exit_node );
//	level.players_hover_craft.script_vehicle_selfremove = true;
//}

do_crane_event()
{
	apache = get_vehicle( "crane_apache", "targetname" );
	
	apache notify( "stop_apache_fire_at_targets" );
	apache thread missile_chain( "missile_chain_crane", 5, "hot_buildings_destroyed", "apache_zippy" );
	
	exploding_crane_trigger = GetEnt( "exploding_crane_trigger", "targetname" );
	exploding_crane_trigger waittill ( "trigger" );
	
	exploding_crane = GetEnt( "exploding_crane", "targetname" );
	
	exploding_crane.animname = "crane";
	exploding_crane SetAnimTree();
	exploding_crane anim_single_solo( exploding_crane, "crash" );
}

apache_fire_at_random_targets()
{
	self waittill ( "trigger", attack_heli );
	targets = array_randomize( getstructarray( "event1_ac130_targets", "targetname" ) );
	do_this_many = 4;
	
	new_targets = [];
	Assert( do_this_many <= targets.size );
	for ( i = 0; i < do_this_many; i++ )
	{
		new_targets[ i ] = targets[ i ];
	}

	targets = new_targets;
	lookat_ent = spawn_tag_origin();
	attack_heli thread apache_fire_at_targets( lookat_ent, targets );
}

apache_fire_at_targets( lookat_ent, targets )
{
	self endon( "death" );
	self endon( "stop_apache_fire_at_targets" );
	lookat_ent thread call_on_thread_end( thisthread, ::delete );

	self SetLookAtEnt( lookat_ent );
	foreach( target in targets )
	{
		lookat_ent.origin = target.origin;
		wait RandomFloatRange( 2, 3 );
		
		if( self.vehicletype == "apache" )
		{
			if ( IsDefined( level.only_one_heli_fire ) )
			{
				if ( !level.only_one_heli_fire )
				{
					level.only_one_heli_fire = true;
					self maps\_helicopter_globals::fire_missile( "apache_zippy", 4, lookat_ent, 0.1 );
					level thread reset_only_one_heli_fire();
				}
			}
			else
			{
				self maps\_helicopter_globals::fire_missile( "apache_zippy", 4, lookat_ent, 0.1 );
			}
		}
		else
		{
			self maps\_helicopter_globals::fire_missile( "mi28_zippy", 5, lookat_ent, 0.3 );
		}
	}
	
	thread heli_attacks_all_enemies();
}

//---------------------------------------------------------
// Beach Defense Section
//---------------------------------------------------------
bullet_spray( flag_str, min_vec, max_vec )
{
	self endon( "death" );

	if ( flag_exist( "start_beach_defense" ) )
	{
		flag_wait( "start_beach_defense" );
	}

	bullet_time = get_bullet_time();

	// Start far away from self
	target_origin = self.origin + ( max_vec[ 0 ], 0, min_vec[ 2 ] );
	prev_target_offset = undefined;
	while ( !flag( flag_str ) )
	{
		bullet_spray_delay();
		origin = self.origin;
	
		target_offset = vec_random_range( min_vec, max_vec );
		if ( !IsDefined( prev_target_offset ) )
		{
			prev_target_offset = target_offset;
			continue;
		}

		dist = Distance( prev_target_offset, target_offset );
//		speed = RandomFloatRange( 600, 1200 );
		speed = 100;
		time = dist / speed;

		steps = int( time * 20 );
		steps = Max( steps, 1 );

		vec_inc = ( target_offset - prev_target_offset ) / steps;
		offset = prev_target_offset;

		for ( i = 0; i < steps; i++ )
		{
			offset += vec_inc;
			target_origin = self.origin + offset;
			target_origin = ( target_origin[ 0 ], self.origin[ 1 ], target_origin[ 2 ] );

			forward = AnglesToForward( ( 0, self.angles[ 1 ], 0 ) );

			start = target_origin + ( forward * 2000 );
			end = target_origin + ( forward * -1 * 2000 );

			if ( GetTime() > bullet_time )
			{
				bullet_time = get_bullet_time();
		
				MagicBullet( "ak47_acog", start, end );
				BulletTracer( start, end, true );
			}

//			Line( start, end );

			wait( 0.05 );
		}

		prev_target_origin_offset = target_offset;
	}
}

hovercraft_mortars()
{
	if ( flag_exist( "start_beach_defense" ) )
	{
		flag_wait( "start_beach_defense" );
	}

	level endon( "player_unloaded" );

	num = 0;
	while ( 1 )
	{
		mortar_delay();		

		if ( num == level.hovercrafts.size )
		{
			num = 0;
			level.hovercrafts = array_randomize( level.hovercrafts );
		}

		hovercraft = level.hovercrafts[ num ];
		num++;

		if ( !IsDefined( hovercraft ) )
		{
			continue;
		}

		while ( IsDefined( hovercraft ) )
		{
			range = RandomFloatRange( 700, 4000 );
			yaw = RandomFloatRange( 30, 330 );

			forward = AnglesToForward( hovercraft.angles + ( 0, yaw, 0 ) );
			origin = hovercraft.origin + ( forward * range );

			if ( can_hovercraft_mortar( origin, hovercraft ) )
			{
				mortar_explosion( origin, hovercraft );
				break;
			}
			
			wait( 0.05 );
		}
	}
}

aircraft_flak()
{
	if ( flag_exist( "start_beach_defense" ) )
	{
		flag_wait( "start_beach_defense" );
	}

	num = 0;
	while ( !flag( "player_unloaded" ) )
	{
		flak_delay();

		if ( num == level.intro_aircraft.size )
		{
			num = 0;
			level.intro_aircraft = array_randomize( level.intro_aircraft );
		}

		aircraft = level.intro_aircraft[ num ];
		num++;

		if ( !IsDefined( aircraft ) )
		{
			continue;
		}

		while ( IsDefined( aircraft ) )
		{
			range = RandomFloatRange( 1500, 4000 );
			dir = AnglesToForward( vec_random_range( ( 0, 0, 0 ), ( 360, 360, 360 ) ) );
			origin = aircraft.origin + ( dir * range );

			origin = ( origin[ 0 ], origin[ 1 ], Max( origin[ 2 ], 500 ) );

			if ( aircraft can_aircraft_flak( origin ) )
			{
				flak_burst( origin );
				break;
			}

			wait( 0.05 );
		}
	}
}

beach_defense_simple()
{
	min_vec = ( -9000, -29000, 1000 );
	max_vec = ( 23000, -6700, 5000 );

	water_z = -178;

	mortar_time = get_mortar_time();
	flak_time = get_flak_time();

	while ( !flag( "glory_tank_ready_for_death" ) )
	{
		time = GetTime();

		if ( time > mortar_time )
		{
			origin = vec_random_range( min_vec, max_vec );
			origin = ( origin[ 0 ], origin[ 1 ], water_z );

			mortar_explosion( origin );
			mortar_time = get_mortar_time();
		}

		if ( time > flak_time )
		{
			origin = vec_random_range( min_vec, max_vec );

			flak_burst( origin );
			flak_time = get_flak_time();
		}

		wait( 0.05 );
	}
}

get_mortar_time()
{
	return GetTime() + RandomFloatRange( 1000, 3000 );
}

get_flak_time()
{
	return GetTime() + RandomFloatRange( 500, 1300 );
}

mortar_explosion( origin, ent )
{
	type = "water";

	if ( IsDefineD( ent ) )
	{
		if ( IsDefined( ent.nearby_hovercraft ) )
		{
			start = origin + ( 0, 0, 150 );
			end = origin - ( 0, 0, 300 );
	
			trace = BulletTrace( start, end, false, ent );
			if ( IsDefined( level._effect[ "mortar" ][ trace[ "surfacetype" ] ] ) )
			{
				type = trace[ "surfacetype" ];
			}
		}
	}

	fx = level._effect[ "mortar" ][ type ];
	PlayFX( fx, origin );

	dist = DistanceSquared( level.player.origin, origin );
	if ( dist < 3000 * 3000 )
	{
		sound = level.scr_sound[ "mortar" ][ type ];
		thread play_sound_in_space( sound, origin );

		EarthQuake( 0.5, 0.5, origin, 2000 );
	}

}

flak_burst( origin )
{
	fx = getfx( "ride_in_near_aa_explose" );

	PlayFX( fx, origin );

	dist = DistanceSquared( level.player.origin, origin );
	if ( dist < 3000 * 3000 )
	{
//		sound = level.scr_sound[ "mortar" ][ type ];
		thread play_sound_in_space( "aagun_skyburst_close", origin );

		EarthQuake( 0.75, 0.5, origin, 3000 );
	}
}

flak_delay()
{
	percent = fly_in_percent();

	min_delay = get_delay_percent( 0.1, 0.3, percent );
	max_delay = get_delay_percent( 0.5, 0.75, percent );

	wait( RandomFloatRange( min_delay, max_delay ) );
}

can_aircraft_flak( origin )
{
	foreach ( aircraft in level.intro_aircraft )
	{
		if ( !IsDefined( aircraft ) )
		{
			continue;
		}

		if ( DistanceSquared( aircraft.origin, origin ) < 1500 * 1500 )
		{
			return false;
		}
	}

	return true;
}

can_hovercraft_mortar( origin, hovercraft )
{
	foreach ( vehicle in level.hovercrafts )
	{
		if ( !IsDefined( vehicle ) )
		{
			continue;
		}

		if ( !vehicle can_mortar_front( origin ) )
		{
			return false;
		}		
	}

	return true;
}

can_mortar_front( mortar_origin )
{
	zone_length = 80000;
	zone_half_width = 700;
	zone_half_width = zone_half_width * zone_half_width;

	dir = AnglesToForward( self.angles );
	origin = self.origin + ( dir * ( 1000 * -1 ) );

	vec = mortar_origin - origin;

	l = VectorDot( dir, vec );

	if ( l < 0 )
	{
		return true;
	}

 	if ( l > zone_length )
	{
		return true;
	}

	vec_length = Length( vec );
	distsqr = abs( ( vec_length * vec_length ) - ( l * l ) );

	if ( distsqr > zone_half_width )
	{
		return true;
	}

	return false;
}

round_to( val, mult )
{
	val = int( val * mult ) / mult;
	return val;
}

get_bullet_time()
{
	percent = fly_in_percent();

	min_delay = get_delay_percent( 0.05, 1, percent );
	max_delay = get_delay_percent( 0.3, 1.5, percent );	

	return ( GetTime() + ( RandomFloatRange( min_delay, max_delay ) * 1000 ) );
}

fly_in_percent()
{
	min_y = -49500; // near the node that sets the "start_beach_defense"
	max_y = -12000; // closer to the beach

	diff = max_y - min_y;
	player_diff = max_y - level.player.origin[ 1 ];
	percent = player_diff / diff;
	percent = Clamp( percent, 0, 1 );

	return percent;
}

bullet_spray_delay()
{
	percent = fly_in_percent();

	min_delay = get_delay_percent( 0.5, 2, percent );
	max_delay = get_delay_percent( 2, 5, percent );

	wait( RandomFloatRange( min_delay, max_delay ) );
}

mortar_delay()
{
	percent = fly_in_percent();

	min_delay = get_delay_percent( 0.3, 0.75, percent );
	max_delay = get_delay_percent( 0.7, 2.5, percent );

	wait( RandomFloatRange( min_delay, max_delay ) );
//	wait( 0.2 );
}

get_delay_percent( a, b, percent )
{
	return a + ( ( b - a ) * percent );
}

vec_random_range( min_vec, max_vec )
{
	x = safe_RandomFloatRange( min_vec[ 0 ], max_vec[ 0 ] );
	y = safe_RandomFloatRange( min_vec[ 1 ], max_vec[ 1 ] );
	z = safe_RandomFloatRange( min_vec[ 2 ], max_vec[ 2 ] );

	return ( x, y, z );
}

safe_RandomFloatRange( a, b )
{
	if ( a == b )
	{
		return a;
	}

	return RandomFloatRange( a, b );
}

intro_rocket_thread()
{
	node = getstruct( self.targetname, "target" );
	node waittill( "trigger" );

	self script_delay();
	self spawn_vehicle_and_gopath();
}

activeate_on_vehiclenode_trigger()
{
	level endon( "halfway_up_beach" ); // flag trigger on beach

	node = GetVehicleNode( self.targetname, "target" );
	node waittill( "trigger" );	

	self activate_trigger();
}

//---------------------------------------------------------
// Beach Run
//---------------------------------------------------------
tank_path_beach()
{
	init_intro();

	beach_color_triggers();
	thread reinforcement_flyin();
	thread beach_defense_simple();
	thread tank_stop_moving_bug_fix();

	tank_delay_thoughts( 7000 );
	craft_4_tank1 = get_vehicle( "craft_4_tank1", "targetname" );
	if ( !IsDefined( craft_4_tank1 ) ) // doesn't exist in start point and I don't care.
	{
		craft_4_tank1 = spawn_vehicle_from_targetname_and_drive( "craft_4_tank1" );
		craft_4_tank2 = spawn_vehicle_from_targetname_and_drive( "craft_4_tank2" );
		craft_4_tank1 godon();
		craft_4_tank2 godon();
		
		tank2 = level.hero_tank;
		other_tank_end_path = GetVehicleNode( "friend_path_off_hovercraft", "targetname" );
		tank2.attachedpath = other_tank_end_path;
		tank2 AttachPath( other_tank_end_path );
		tank2 thread vehicle_paths( other_tank_end_path );
		tank2 ResumeSpeed( 15 );
	}
	else
	{
		craft_4_tank1 riders_godoff();
		craft_4_tank1 godoff();
	}
	
	delaythread( 0.25, ::autosave_by_name, "landing_to_get_orders" );	

	if( is_after_start( "ride_in" ) )
	{
		level.hero_tank do_path_section( "friend_path_off_hovercraft" );
		level.glory_tank do_path_section( "craft_2_tank1_path_one" );
		level.player_tank do_path_section( "tank_track_e1_a_pre" );
//		delaythread( 1, ::unload_blackhawk );		
		
	}
	
	thread player_on_beach();
	thread tank_shoots_building_left();
	
	friend_smoke_beach = getstruct( "friend_smoke_beach", "targetname" );
	level.hero_tank.default_target_vec = friend_smoke_beach.origin;
	
	tank_path_move_up_beach();
	tank_path_assault_over_mound();

	flag_wait( "end_of_beach" );
	
	maps\_mortar::bog_style_mortar_off( 2 );

	intro_cleanup();
}

// Fixes Bug# 170130, player able to go around trigger that moves up tanks.
tank_stop_moving_bug_fix()
{
	level.player endon( "death" );
	while ( level.player.origin[ 1 ] < 1760 )
	{
		wait( 0.5 );
	}

	if ( !flag( "two_tanks_in_alley" ) )
	{
		activate_trigger_with_targetname( "two_tanks_in_alley" );
	}
}

tank_shoots_building_left()
{
	tank_shoots_building_left = GetVehicleNode( "tank_shoots_building_left", "script_noteworthy" );
	tank_shoots_building_left waittill ( "trigger", tank );
	tank vehicle_setspeed( 0, 15, 15 );	
	tank vehicle_stop_named( "tank_shoots_building_left", 10, 10 );
	tank_shoots_building_left_targ = getstruct( tank_shoots_building_left.targetname, "target" );
	tank stop_turret_attack_think_hamburg();
	tank setturrettargetvec( tank_shoots_building_left_targ.origin );
	tank waittill( "turret_on_target" );
	tank FireWeapon();
	exploder( "tank_blows_up_building_left_exploder" );
	tank thread turret_attack_think_hamburg();
	tank riders_godoff();
	tank godoff();
	tank vehicle_resume_named( "tank_shoots_building_left" );
}

player_on_beach()
{
	flag_wait( "player_on_beach" );
	
	//Blackhawk Pilot 1: Helix Two Three, chalk deployed, going in to cover pattern.
	radio_dialog_add_and_go( "tank_bhp1_chalkdeployed" );

	flag_set( "pause_sentry_turrets" );
	
	thread beach_flavor_dialog();

	thread helis_duke_it_out();
	thread flood_pool_spawners();

	maps\_spawner::trigger_pool_spawners( "post_beach_pool_spawner" );
}

beach_flavor_dialog()
{
	thread rhino_dialog();
	

	wait 2;

	flag_wait( "tank_out_of_left" );
	
	//Sandman: Rhino One, you've got a T90 on the left side!
	radio_dialog_add_and_go( "hamburg_snd_t90rightside" );
	
	tank_out_of_left = get_vehicle( "tank_out_of_left", "script_noteworthy" ) godoff();
	
	flag_wait( "hind_hind" );
	
	//Rhino 2 Gunner: HIND!  HIND!
	radio_dialog_add_and_go( "hamburg_rhg_hind" );
	
	//Sandman: Move with the tanks!  Keep going!
	radio_dialog_add_and_go( "hamburg_snd_movewithtanks" );
	
	//Army Grunt 2: MORTARS!!!!
	radio_dialog_add_and_go( "tank_ag2_mortars" );
	
	//Army Grunt 3: Shit man!  We're getting pinned down with mortars!
	radio_dialog_add_and_go( "tank_ag3_pinneddown" );
	
	//Sandman: Keep moving!  Use whatever cover you can find!
	radio_dialog_add_and_go( "hamburg_snd_whatevercover" );

	//Army Grunt 2: Take cover behind the rocks!  
	radio_dialog_add_and_go( "tank_ag2_behindrocks" );
	
	//Sandman: Don't stop!  Get off this beach!
	radio_dialog_add_and_go( "hamburg_snd_getoffbeach" );
	
	radio_dialog_add_and_go( "tank_ag3_offthebeach" );
	
	//Sandman: Don't slow down!
	radio_dialog_add_and_go( "hamburg_snd_dontslowdown" );
	
	//Army Grunt 1: Just get to the wall!  That's where the rally point is
	radio_dialog_add_and_go( "tank_ag1_rallypoint" );
	
	//Sandman: Move!  Move!
	radio_dialog_add_and_go( "hamburg_snd_movemove" );

	
}

rhino_dialog()
{
	while( true )
	{
		level.player_tank waittill( "weapon_fired" ); 
		
		if ( RandomInt( 100 ) > 25 )
			continue;
		wait 1;
		radio_dialog_add_and_go( "hamburg_rhg_loading", 0.3 );
		wait 4;
		radio_dialog_add_and_go( "hamburg_rhg_up", 0.3 );
		
		if( cointoss() )
			radio_dialog_add_and_go( "hamburg_rhg_aquiring", 0.3 );
		
	}
}


flood_pool_spawners()
{
	structs = getstructarray( "beach_flood_spawners", "targetname" );

	timer = GetTime() + 5000;
	while ( GetTime() < timer )
	{
		spawners = array_randomize( structs );
		foreach ( struct in structs )
		{
			if ( !struct.count )
			{
				continue;
			}

			if ( IsDefined( struct.spawned_guy ) )
			{
				if ( IsAlive( struct.spawned_guy ) && !struct.spawned_guy doinglongdeath() )
				{
					continue;
				}
			}
	
			spawner = maps\_spawner::get_spawner_from_pool( struct, 1 );

			spawner.count = 1;
			guy = spawner spawn_ai();

			if ( !spawn_failed( guy ) )
			{
				struct.spawned_guy = guy;
				struct.count--;
			}

			wait( RandomFloatRange( 1, 3 ) );
		}

		if ( !flag( "halfway_up_beach" ) )
		{
			timer = GetTime() + 5000;
		}

		wait( 0.1 );
	}
}

helis_duke_it_out()
{
	spawn_vehicle_from_targetname_and_drive( "heli_enemy_beach_right" );
	
	flag_set( "hind_hind" );

	wait 5.5;
	thread heli_dukes_it_out_with( "event1_forward_heli_nine",[ "heli_enemy_beach_right" ], undefined, true  );
	wait 2;
	thread heli_dukes_it_out_with( "event1_forward_heli_one", [ "heli_enemy_beach_right" ], undefined, true );
	wait 2;
	thread heli_dukes_it_out_with( "crane_apache",[ "heli_enemy_beach_right" ], undefined, true );
	thread heli_dukes_it_out_with( "heli_enemy_beach_right", [ "event1_forward_heli_nine","crane_apache","event1_forward_heli_one" ], undefined, true );
}

tank_path_move_up_beach()
{	
	thread do_beach_smoke();
	thread delaythread( 0, maps\_mortar::bog_style_mortar_off, 1 );
	level.hero_tank thread turret_attack_think_hamburg();
	level.player_tank thread turret_attack_think_hamburg();
	delaythread( 1, ::autosave_by_name, "beach_landed" );	
}

tank_path_assault_over_mound()
{
	delaythread( 1, ::autosave_by_name, "over_mound" );
}

beach_color_triggers()
{
	triggers = GetEntArray( "beach_color_trigger", "targetname" );
	array_thread( triggers, ::beach_color_trigger_think );
}

beach_color_trigger_think()
{
	triggers = GetEntArray( self.target, "targetname" );
	beach_color_triggers_touch( triggers );

	self activate_trigger();
	array_delete( triggers );
}

beach_color_triggers_touch( triggers )
{
	delay_trigger = undefined;
	instant_trigger = undefined;

	foreach ( trigger in triggers )
	{
		if ( IsDefined( trigger.script_delay ) )
		{
			delay_trigger = trigger;
		}
		else
		{
			instant_trigger = trigger;
		}
	}

	instant_trigger endon( "trigger" );

	while ( 1 )
	{
		delay_trigger waittill( "trigger" );

		timer = GetTime() + ( delay_trigger.script_delay * 1000 );
		while ( level.player IsTouching( delay_trigger ) )
		{
			if ( GetTime() > timer )
			{
				return;
			}

			wait( 0.05 );
		}
	}
}
