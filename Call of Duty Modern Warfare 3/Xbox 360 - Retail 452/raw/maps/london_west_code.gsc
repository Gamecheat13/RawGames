#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_hud_util;
#include maps\london_code;
#include maps\london_uav;

//---------------------------------------------------------
// SUBWAY STATION
//---------------------------------------------------------
sas_movement()
{
	node = GetNode( "sas_leave_train", "targetname" );
	flag_wait( "start_west_station" );
	node anim_reach_solo( level.sas_leader, "westminster_stop" );

	if ( !flag( "start_station_music" ) )
	{
		node anim_single_solo( level.sas_leader, "westminster_stop" );
	}
}

melee_scene()
{
	trigger_wait_targetname( "exiting_terminal" );
	blocker = GetEntArray( "lower_station_blocker", "targetname" );
	foreach (b in blocker)
	{
		b notsolid();
		b connectpaths();
		b Delete();
	}
	cspawn = getent( "melee_chump", "targetname" );
	melee_node = getStruct( "station_melee_node", "targetname" );
	level.sas_leader disable_ai_color();
	level.sas_leader setGoalPos( level.sas_leader.origin );

	chump = cspawn spawn_ai( true );
	chump addAIEventListener( "bulletwhizby" );
	chump thread melee_scene_recover( melee_node );
	chump thread melee_scene_see_player();
	chump endon( "death" );
	chump endon( "interrupt_melee" );
	
	melee_node thread anim_generic_first_frame( chump, "station_melee_scene_chump" );
	melee_node anim_generic_reach( level.sas_leader, "station_melee_scene_sas" );
	chump notify( "started_melee" );
	melee_node thread anim_generic( level.sas_leader, "station_melee_scene_sas" );
	melee_node thread anim_generic( chump, "station_melee_scene_chump" );
	
	chump waittillmatch( "single anim", "melee_interact" );
	chump.allowDeath = true;
	chump.a.nodeath = true;
	chump kill();
}

melee_scene_recover( node )
{
	self waittill_any( "damage", "death", "see_player", "bulletwhizby" );
	
	if ( IsAlive( self ) )
	{
		self notify( "stop_first_frame" );
		self notify( "interrupt_melee" );
		self StopAnimScripted();
		self.ignoreAll = false;
		self.ignoreMe = false;
		self.favoriteenemy = level.player;
	}
	node = getNode( node.target, "targetname" );
	level.sas_leader SetGoalNode( node );
	level.sas_leader enable_ai_color();
	activate_trigger_with_targetname( "exiting_terminal" );
}

melee_scene_see_player()
{
	self endon( "damage" );
	self endon( "death" );
	self endon( "started_melee" );
	flag_wait( "entering_open_area" );
	self notify( "see_player" );
}

melee_scene_stab( guy )
{	
	guy playsound( "melee_knife_hit_body" );
	playfxontag( getfx( "melee_knife_ai" ), guy, "TAG_KNIFE_FX" );
}

crawler_call_for_reinforcements()
{
	guys = array_spawn_targetname( "station_1" );
	flag_wait( "station_reinforcements" );
	
	level.sas_leader disable_surprise();
	
	flag_set( "start_station_music" );
	guy = guys[0];
	foreach( g in guys )
	{
		g.ignoreSuppression = true;
		g disable_surprise();
		if ( IsDefined( g.script_noteworthy ) )
			guy = g;
		else
		{
			node = g get_target_ent();
			g SetGoalNode( node );
		}
	}
	
	guy.animname = "russian_soldier";
	
	//Russian 2: Don't let them get to the trucks!
	node = guy get_target_ent();
	guy thread dialogue_queue( "london_ru2_gettotrucks" );	
	guy.ignoreAll = true;
	guy thread guy_checks_crawler_failsafe( node );
	guy guy_checks_crawler( node );
	guy.ignoreAll = false;
	wait( 1.0 );
	
	level.sas_leader disable_cqbwalk();
	level.sas_leader disable_sprint();
	player_speed_percent( 100 );
	wait( 1.0 );
	level.sas_leader enable_ai_color();
	activate_trigger_with_targetname( "sas_kickoff_west_station" );
	autosave_by_name( "start_west_station_combat" );
	level.sas_leader enable_surprise();
}

guy_checks_crawler( node )
{
	self endon( "death" );
	self endon( "damage" );
	self endon( "engage" );
	self disable_surprise();
	node anim_reach_solo( self, "check_body_surprise" );
	node thread anim_single_solo( self, "check_body_surprise" );
}

guy_checks_crawler_failsafe( node )
{
	self endon( "death" );
	trigger_wait_targetname_multiple( "station_too_close" );
	self notify( "engage" );
	self anim_stopanimscripted();
	self SetGoalNode( node );
}

crawling_badguy()
{
	player_speed_percent( 70 );
	flag_wait( "start_west_station" );
	spawner = GetEnt( "crawling_badguy", "targetname" );
	badguy = spawner spawn_ai( true );
	badguy.deathanim = level.scr_anim[ "generic" ][ "dying_crawl_death_v2" ];
	
	badguy thread crawling_badguy_failsafe();
	badguy thread crawler_call_for_reinforcements();
	badguy endon( "death" );
	badguy gun_remove();
	badguy.ignoreme = true;
	badguy.ignoreall = true;
	badguy.animname = "russian_soldier";
	
	badguy anim_generic( badguy, "dying_crawl" );
	badguy anim_generic_first_frame( badguy, "dying_crawl_death_v2" );
	//Russian 1: Hostiles are after us!
	badguy anim_single_solo( badguy, "london_ru1_gettotrucks" );
	
	badguy.noragdoll = true;
	waittillframeend;
	badguy Kill();
}

crawling_badguy_failsafe()
{
	self waittill( "death" );
	self StopAnimScripted();
	flag_set( "station_reinforcements" );
}

tunnel_doors_think()
{
	doors = GetEnt( "tunnel_doors", "targetname" );
	halfway = GetEnt( "tunnel_doors_halfway", "targetname" );
	closed = GetEnt( "tunnel_doors_closed", "targetname" );
	
	flag_wait( "tunnel_doors_close_slow" );	
	
	doors MoveTo( ( doors.origin[ 0 ], doors.origin[ 1 ], halfway.origin[ 2 ] ), 10.0 );
	
	flag_wait( "tunnel_doors_close_fast" );	
	doors MoveTo( ( doors.origin[ 0 ], doors.origin[ 1 ], closed.origin[ 2 ] ), 2.0 );
	
}

subway_think()
{
	subway = spawn_vehicles_from_targetname( "reinforcement_subway" );
	flag_wait( "subway_go" );
	foreach ( s in subway )
	{
		s gopath();
		s delayCall( 12, ::Delete );
	}
}

//enemy_push_cones()
//{
//	trigger_wait_targetname( "stairs_guys_trigger" );
//	
//	pushers = getStructarray( "enemy_push_cone", "targetname" );
//	foreach ( p in pushers )
//	{
//		targets = getStructarray( p.target, "targetname" );
//		foreach ( t in targets )
//		{
//			MagicBullet( level.sas_leader.weapon, p.origin, t.origin );
//		}
//	}
//}

sas_turnstile()
{
	level endon( "dumb_sprinter" );

	trigger_wait_targetname( "cleared_station_exit" );
	level.sas_leader disable_ai_color();
	node = getstruct( "turnstile_anim_node", "targetname" );
	node anim_generic_reach( level.sas_leader, "london_turnstile_traverse" );
	node anim_generic_run( level.sas_leader, "london_turnstile_traverse" );
	level.sas_leader enable_ai_color();
	level.sas_leader ent_flag_set( "turnstile" );
	activate_trigger_with_targetname( "cleared_station_exit" );
}

//---------------------------------------------------------
// Billboard Bink Section 
//---------------------------------------------------------
poster_bink()
{
	SetSavedDvar( "cg_cinematicFullScreen", "0" );

	while ( 1 )
	{
		CinematicInGameLoop( "london_posters" );
		wait( 5 );

		while ( IsCinematicPlaying() )
		{
			wait( 0.5 );
		}
	}
}

//---------------------------------------------------------
// Take Down Scene
//---------------------------------------------------------
postspawn_takedown_ai()
{
	self magic_bullet_shield();

	if ( !IsDefined( level.takedown_ai ) )
	{
		level.takedown_ai = [];
	}

	level.takedown_ai[ level.takedown_ai.size ] = self;

	if ( self.team == "allies" )
	{
		self AllowedStances( "stand" );

		// Ideal situation would be to have the AI always use pistols, but there are a lot of animations
		// with notetracks that call the primary weapon back, so it's not really 100%.
		self gun_remove();
		self forceuseweapon( self.sidearm, "sidearm" );
		self thread watch_take_down_targets();
	}

	if ( IsDefined( self.script_parameters ) )
	{
		level.bravo_leader = self;
	}
}

takedown_sequence( targetname )
{
	node = getstruct( targetname, "targetname" );
	spawners = GetEntArray( node.targetname, "target" );
	
	friendlynode = GetNode( node.targetname , "target" );

	ais = array_spawn( spawners, true );

	takedown_ender = "stop_takedown_enemy" + node.script_index;

    level endon ( takedown_ender );	
    thread takedown_sequence_ender( node, ais, takedown_ender );
    
	foreach ( ai in ais )
	{
		ai PushPlayer( true );
	    ai.takedown_node = node;
	    ai.takedown_ender = takedown_ender;
	    ai endon ( "death" );
	    ai enable_cqbwalk();
	    ai disable_arrivals();
		ai set_battlechatter( false );
    	ai.pathenemyfightdist = 0;
	    ai.pathenemylookahead = 0;
	    ai.maxfaceenemydist = 32;
	    ai.fixednode = true;
		ai.a.disableLongDeath = true;
    	ai.disablefriendlyfirereaction = true;
    	ai.dontmelee = true;
	    ai delaythread( 0.5, ::set_ignoreall, true );
	    ai delaythread( 0.5, ::set_ignoreme, true );

		if ( ai.team == "axis" )
		{
    		ai.DisableLongPain = true;
		    ai.health = 100000;
			ai.animname = "takedown_enemy" + node.script_index;
			ai add_damage_function( ::takedown_sequence_damage );
			ai takedown_ent_on_ai();
		}
		else
		{
        	ai magic_bullet_shield();
        	ai.disableDamageShieldPain = true;
//			ai SetCanDamage( false );
			ai.animname = "takedown_friendly" + node.script_index;
			ai.takedown_index = node.script_index;
			ai.friendlynode = friendlynode;
		}
	}

	node anim_reach( ais, "takedown" );


	foreach ( ai in ais )
	{
	    ai endon ( "death" );
		ai notify( "killanimscript" );
		ai disable_pain();
		ai.ignoreme = true;
		ai.ignoreall = true;

		if ( ai.team == "allies" )
		{
			ai gun_remove();
			ai.wantShotgun = false;
			ai place_weapon_on( ai.sidearm, "right" );
		}
	}

	foreach( ai in ais )
	{
    	delaythread( 3, ::flag_count_decrement, "take_down_finished" ); // delay since animation is long
	}

	node anim_single( ais, "takedown" );
	node thread anim_loop( ais, "idle", "takedown_ender" );
	
}

watch_take_down_targets()
{
	self endon ( "death" );
	
	self notify ( "new_watch_take_down_targets" );
	self endon ( "new_watch_take_down_targets" );
	
	self.cqb_wide_target_track = true;
	self enable_cqbwalk();
	while( true )
	{
		wait 0.5;
		if ( IsDefined( level.take_down_ents ) && level.take_down_ents.size == 0 )
		{
			self PushPlayer( false );
//			self SetLookAtEntity( level.player );
			if( self.weapon != self.primaryweapon )
			{
				self.wantShotgun = true;
				self waittill( "switched_to_lastweapon" );
			}

			friendlynode = spawn_tag_origin();
			friendlynode.origin = self.origin;
			friendlynode.angles = self.angles;
//			friendlynode thread anim_generic_loop( self, "all_dead_idle" );
			return;
		}

		ent = take_down_get_target();

		if ( !IsDefined( ent ) )
		{
			continue;
		}
		
		self cqb_aim( ent );
		self SetLookAtEntity( ent );
		ent waittill( "death" );
	}
}

take_down_get_target()
{
	if ( !IsDefined( level.take_down_ents ) || level.take_down_ents.size == 0 )
		return undefined;
	excluders = [];

	foreach( ent in level.take_down_ents )
	{
		if( ent.targetting_guys > 0 )
			excluders = array_add( excluders, ent );
	}
		
	the_target =  level.take_down_ents[0];
			
	test = get_array_of_closest( self.origin, level.take_down_ents,excluders  );
	
	if( test.size > 0 )
	{
		the_target = test[0];
		the_target.targetting_guys++;
		return the_target;
	}
	
	test = get_array_of_closest( self.origin, level.take_down_ents );
	
	lesser = 3;

	the_target = test[0];
	
	foreach( ent in test )
	{
		if( ent.targetting_guys > lesser )
			continue;
		lesser = ent.targetting_guys;
		the_target = ent;
	}
	
	the_target.targetting_guys++;
	return the_target;
	
}

takedown_ent_on_ai()
{
	org = spawn_tag_origin();
    org LinkTo ( self, "tag_eye", ( 0, 0, 0 ), ( 0, 0, 0 ) );
    org.targetting_guys = 0;
    org.takedown_hostage = self;
    org thread takedown_ent_on_ai_death();
	if ( !IsDefined( level.take_down_ents ) )
		level.take_down_ents = [];
    level.take_down_ents = array_add( level.take_down_ents, org );
}

takedown_ent_on_ai_death()
{
    self.takedown_hostage waittill ("death" );
    level.take_down_ents = array_remove( level.take_down_ents, self );
    self delete();
}

takedown_sequence_ender( node, ais, takedown_ender )
{
    level waittill ( takedown_ender );
    ais = array_removeDead_or_dying( ais );
    thread array_thread( ais, ::takedown_end_individual );
}

takedown_sequence_damage( damage, attacker, direction_vec, point, type, modelName, tagName )
{
    if( attacker != level.player )
    {
        self.health = 100000;
        return;
    }
    takedown_end_individual();
    self kill();
}

takedown_end_individual()
{
	self.fixednode = true;
	
	if ( IsDefined( self.friendlynode ) )
	{
		self set_goal_node( self.friendlynode );
		self thread reset_track_on_goal();
	}
    flag_count_decrement( "take_down_finished" );
    level notify ( self.takedown_ender );	
    self.takedown_node notify ( self.takedown_ender );	
    self notify ( "single anim", "end" );
    self StopAnimScripted();
    self notify ( "killanimscript" );
    self remove_damage_function( ::takedown_sequence_damage );
    if ( self hasanim( "takedown_ended_on_ground" ) && IsDefined( self.takedown_node.on_the_ground ) )
    {
		if ( self.takedown_index == 4 )
		{
        	thread animscripts\notetracks::noteTrackPoseStand();
			temp = SpawnStruct();
			temp.origin = self.origin;
			temp.angles = self.angles;
			temp anim_single_solo( self, "crouch_to_stand" );
		}
		else
		{
        	thread animscripts\notetracks::noteTrackPoseStand();
        	self.takedown_node anim_single_solo( self, "takedown_ended_on_ground" );
		}
    }

    if ( self.team == "allies" )
	{
    	self thread watch_take_down_targets();
	}
}

reset_track_on_goal()
{
	self waittill ( "goal" );
	self thread watch_take_down_targets();
	
}

//---------------------------------------------------------
// Ending
//---------------------------------------------------------
street_traffic()
{
	start_points = getstructarray( "traffic_start_point", "targetname" );
	ent_models = GetEntArray( "traffic_model", "targetname" );

	foreach ( start in start_points )
	{
		start.vehicles = [];
	}

	models = [];
	foreach ( ent in ent_models )
	{
		struct = SpawnStruct();
		struct.model = ent.model;
		struct.angles = ent.angles;
		struct.radius = ent.radius;
		models[ models.size ] = struct;
		ent Delete();
	}

	counter = SpawnStruct();
	counter.max = 20;
	counter.count = 0;
	while ( 1 )
	{
		if ( counter.count == counter.max )
		{
			wait( 1 );
			continue;
		}

		start = start_points[ RandomInt( start_points.size ) ];
		counter street_traffic_spawn( start, models );

		wait( RandomFloatRange( 3, 6 ) );
	}
}

street_traffic_spawn( start, models )
{
	end = getstruct( start.target, "targetname" );
	model = models[ Randomint( models.size ) ];

	vehicle = Spawn( "script_model", start.origin );
	vehicle SetModel( model.model );
	vehicle.angles = VectorToAngles( end.origin - start.origin ) + ( 0, model.angles[ 1 ], 0 );
	vehicle.radius = model.radius;
	vehicle thread street_vehicle_movement( start, end, self );

	self.count++;
}

street_vehicle_movement( start, end, counter )
{
	ahead_vehicle = undefined;
	bump_dist = undefined;
	if ( start.vehicles.size > 0 )
	{
		ahead_vehicle = start.vehicles[ start.vehicles.size - 1 ];
		bump_dist = ( self.radius * self.radius ) + ( ahead_vehicle.radius * ahead_vehicle.radius );
	}

	start.vehicles[ start.vehicles.size ] = self;
	speed = RandomIntRange( 348, 609 ); // 20-35mph
	dist = Distance( self.origin, end.origin );
	time = dist / speed;
	self.speed = speed;

	self MoveTo( end.origin, time );
	timer = GetTime() + ( time * 1000 );

	while ( GetTime() < timer )
	{
		if ( IsDefined( ahead_vehicle ) )
		{
			if ( DistanceSquared( self.origin, ahead_vehicle.origin ) < bump_dist )
			{
				bump_dist = Distance( self.origin, ahead_vehicle.origin );
				bump_dist *= bump_dist;

				speed = ahead_vehicle.speed;
				self.speed = speed;
				dist = Distance( self.origin, end.origin );
				time = dist / speed;
				self MoveTo( end.origin, time );
				timer = GetTime() + ( time * 1000 );
			}
		}

		wait( 0.05 );
	}

	start.vehicles = array_remove( start.vehicles, self );
	self Delete();
	counter.count--;
}

//---------------------------------------------------------
// TRUCK EXPLOSION
//---------------------------------------------------------
print3d_on_ent( msg )
{
	self endon( "death" );
	while ( 1 )
	{
		wait( 0.05 );
		print3d( self.origin, msg );
	}
}

truck_crash()
{
	org = GetStruct( "player_explosion_node", "targetname" );;
	truck = spawn_anim_model( "delivery_truck" );

	truck thread spawn_truck_driver();

	level.ending_truck = truck;
	truck truck_targets();

	trigger = GetEnt( "ending_shooter_trigger", "targetname" );
	shooters = trigger get_ai_touching_volume( "allies" );

//	org thread anim_first_frame_solo( truck, "truck_crash" );

	start_org = GetStartOrigin( org.origin, org.angles, truck getanim( "truck_crash" ) );
	start_ang = GetStartAngles( org.origin, org.angles, truck getanim( "truck_crash" ) );

	// Fake movement
	truck.origin = start_org + ( 1000, 0, 0 );
	truck.angles = start_ang;

	time = 2;
	truck MoveTo( start_org, time );
	wait( time - 0.05 );

	flag_set( "truck_spawned" );
	level thread truck_shoot_start( shooters, truck );
//	wait( 1 );
	
	animtime = GetAnimLength( truck getanim( "truck_crash" ) );
	time = 5.20;

	vehicles = spawn_vehicles_from_targetname_and_drive( "ending_chase_vehicles" );
	org thread anim_single_solo( truck, "truck_crash" );
	truck thread play_sound_on_entity( "scn_london_truck_crash_approach" );

/#
//	if ( level.start_point == "west_ending_explosion" )
//	{
//		wait( 0.05 );
//		animation = truck getanim( "truck_crash" );
//		animtime = animtime - ( animtime * 0.8 );
//		truck SetAnimTime( animation, 0.8 );
//		time = 1.2;
//	}
#/

	delaythread( time - 1, ::flag_set, "truck_hit" );
	delaythread( time - 1, ::truck_shoot_stop, shooters );
	level.sas_leader delaythread( time, ::dialogue_queue, "london_ldr_holdyourfire" );

	wait( time );
	truck thread play_sound_on_entity( "scn_london_truck_crash_impact" );
	truck thread truck_sparks();

	Earthquake( 0.4, 0.8, truck.origin - ( 0, 0, 32 ), 2048 );

	wait( animtime - time );
	truck notify( "stop_sparks" );

//	gas_player_dizzy();

	flag_set( "truck_stopped" );

	truck.driver Delete();
	spawner = GetEnt( "end_truck_body", "targetname" );
	spawner spawn_ai( true );

	clip = GetEnt( "blockade_blocker", "targetname" );
	clip Delete();
}

spawn_truck_driver()
{
	spawner = GetEnt( "end_truck_driver", "targetname" );

	driver = spawner spawn_ai( true );
	self.driver = driver;
    driver endon( "death" );

	tag = "tag_driver";
	driver LinkTo( self, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	driver gun_remove();

	animpos = level.vehicle_aianims[ "script_vehicle_uk_delivery_truck_physics" ][ 0 ];
	// hack since this truck model has the driver/passenger on the wrong sides
	animpos.sittag = "tag_passenger";
	driver.vehicle_idle = animpos.idle;

	wait( 0.1 );

    while ( 1 )
    {
        driver notify( "idle" );
        self maps\_vehicle_aianim::play_new_idle( driver, animpos );
    }
}

truck_targets()
{
	offsets = [];
	offsets[ offsets.size ] = ( 200, -20, 80 );
	offsets[ offsets.size ] = ( 200, 20, 80 );
	offsets[ offsets.size ] = ( 200, 40, 20 );

	self.target_orgs = [];
	
	foreach ( offset in offsets )
	{
		origin = get_world_relative_offset( self.origin, self.angles, offset );
		org = Spawn( "script_origin", origin );
		org LinkTo( self );
		self.target_orgs[ self.target_orgs.size ] = org;
//		org thread print3d_on_ent( "*" );
	}
}

truck_shoot_start( shooters, truck )
{
	wait( 0.5 );
	shooters = SortByDistance( shooters, level.player.origin );
	shooters = array_reverse( shooters );

	foreach ( shooter in shooters )
	{
		shooter.ignoreall = false;
		org = truck.target_orgs[ RandomInt( truck.target_orgs.size ) ];
		shooter SetEntityTarget( org );
		wait( RandomFloat( 0.2 ) );
	}
}

truck_shoot_stop( shooters )
{
	flag_wait( "truck_stopped" );

	foreach ( shooter in shooters )
	{
		shooter delaythread( RandomFloatRange( 0.1, 0.5 ), ::truck_shoot_stop_internal );
	}
}

truck_shoot_stop_internal()
{
	self ClearEnemy();
	self ClearEntityTarget();	
}

truck_sparks()
{
	self endon( "stop_sparks" );
	while ( true )
	{
		if ( cointoss() )
			PlayFXOnTag( getfx( "sparks_car_scrape_point" ), self, "tag_fx1" );
		if ( cointoss() )
			PlayFXOnTag( getfx( "sparks_car_scrape_point" ), self, "tag_fx2" );
		if ( cointoss() )
			PlayFXOnTag( getfx( "sparks_car_scrape_point" ), self, "tag_fx3" );
		PlayFXOnTag( getfx( "sparks_car_scrape_line" ), self, "tag_fx4" );
		PlayFXOnTag( getfx( "sparks_car_scrape_line" ), self, "tag_fx5" );
		wait( 0.05 );
	}
}

secure_truck()
{
	flag_wait( "truck_stopped" );

	level.sas_leader dialogue_queue( "london_ldr_allclear" );
	level.bravo_two dialogue_queue( "london_b21_clear" );

	node = GetNode( "walcroft_final_spot", "targetname" );
	node anim_reach_and_approach_node_solo( level.sas_leader, "alley_comm_check" );
	thread secure_truck_walcroft( node );

	level.sas_leader dialogue_queue( "london_ldr_lorries" );

	level thread transition_siren();
	level.sas_leader thread dialogue_queue( "london_ldr_wherearetrucks" );

	if ( do_truck_explosion() )
	{
		level waittill( "forever" );
		return;
	}

	wait( 3.6 );
	flag_set( "do_innocent" );
//	nextmission();

	// OLD EXPLODING TRUCK ENDING!
//	level.sas_leader delaythread( RandomFloatRange( 2, 4 ), ::dialogue_queue, "london_ldr_watchmovement" );
//
//	struct = getstruct( "inspect_truck_node", "targetname" );
//	struct thread anim_generic( self, "inspect_truck" );
//
//	animation = self getgenericanim( "inspect_truck" );
//	self wait_for_animtime_percent( animation, 0.95 );
//	level thread truck_explosion();	
}

transition_siren()
{
	ent = Spawn( "script_origin", level.player.origin );
	ent PlaySound( "scn_london_police_car_final_approach" );

	// Fake linkto()
	while ( 1 )
	{
		ent.origin = level.player.origin;
		wait( 0.05 );
	}
}

secure_truck_walcroft( node )
{
	node anim_single_solo( level.sas_leader, "alley_comm_check" );
	node thread anim_loop_solo( level.sas_leader, "alley_comm_idle" );	
}

//---------------------------------------------------------
// Truck Explosion Section
//---------------------------------------------------------
//init_player_explosion()
//{
//	rig = spawn_anim_model( "player_rig" );	
//	animation = rig getanim( "player_explosion" );
//	rig Animscripted( "empty", ( 0, 0, 0 ), ( 0, 0, 0 ), animation );
//	wait( 0.05 );
//	rig SetAnimTime( animation, 0.8 );
//	wait( 0.05 );
//	level.player_explosion_dist = Length( rig GetTagOrigin( "tag_player" ) );
//
//	rig Delete();
//}

do_truck_explosion()
{
	if ( GetDvarInt( "iw_kleenex" ) )
	{
		return false;
	}

	if ( !GetDvarInt( "ui_skip_graphic_material" ) )
	{
		return false;
	}

	wait( 2 );

	exploder( 21 ); // burning tree
	exploder( "4_bomb" ); // truck explodes

	delaythread( 0.2, ::exploder, "ending_building" );
	level.ending_truck SetModel( "vehicle_uk_delivery_truck_destroyed" );

	thread play_sound_in_space( "walla_london_west_street_scream_l", ( -760, -376, 108 ) );
	thread Play_sound_in_space( "walla_london_west_street_scream_r", ( 48, -328, 108 ) );

	level.player DisableWeapons();
	level.player SetStance( "stand" );

	level.player vision_set_fog_changes( "london_westminster_explosion", 0.2 );
	SetPlayerIgnoreRadiusDamage( true );

	trigger = GetEnt( "ending_shooter_trigger", "targetname" );
	guys = trigger get_ai_touching_volume( "allies" );

	array1[ "anim" ] = getgenericanim( "death_explosion1" );
	array1[ "time" ] = GetAnimLength( array1[ "anim" ] ) * RandomFloatRange( 0.75, 0.8 );
	array2[ "anim" ] = getgenericanim( "death_explosion2" );
	array2[ "time" ] = GetAnimLength( array2[ "anim" ] ) * RandomFloatRange( 0.75, 0.8 );

	foreach ( guy in guys )
	{
		if ( RandomInt( 100 ) > 60 )
		{
			choice = array1;
		}
		else
		{
			choice = array2;
		}

		guy.deathanim 	= choice[ "anim" ];
		guy.ragdolltime = choice[ "time" ];
		guy.skipBloodPool = true;
	}

	explosion_struct = getstruct( "truck_explosion", "targetname" );
	RadiusDamage( explosion_struct.origin, explosion_struct.radius, 1000, 100 );
	Earthquake( 0.8, 1.0, explosion_struct.origin, 1500 );

	level.player delaythread( 5, ::vision_set_fog_changes, "london_westminster_post_explosion", 20 );

	thread truck_explosion_player();

	SetSlowMotion( 1, 0.2, 0.2 );

	wait( 0.5 );
	nextmission();

	return true;
}

truck_explosion_player()
{
	wait( 0.2 );

	player_rig = get_player_rig();

	truck_point = getstruct( "truck_explosion_point", "targetname" );
	player_rig.angles = VectorToAngles( level.player.origin - ( truck_point.origin + ( 100, 0, 0 ) ) );
	player_rig.angles = ( 0, player_rig.angles[ 1 ], 0 );
	player_rig.origin = level.player.origin;
	player_rig Hide();
	level.player_rig = player_rig;
	level.player_rig.anim_origin = player_rig.origin;
	level.player_rig.anim_angles = player_rig.angles;

	blendtime = 0.2;
	level.player PlayerLinkToBlend( player_rig, "tag_player", blendtime );
	player_rig delayCall( blendtime, ::Show );

	level thread player_view_unlock( player_rig );

	level.player EnableSlowAim();
	level.player AllowSprint( false );
	player_speed_percent( 30 );

	level.player ShellShock( "london_explosion", 5 );

	struct = SpawnStruct();
	struct.angles = level.player_rig.anim_angles;
	struct.origin = level.player_rig.anim_origin;

	player_explosion_clamp_yaw( struct );

	struct anim_single_solo( player_rig, "player_explosion" );

	player_rig Hide();
}

player_explosion_clamp_yaw( struct )
{
	yaw = AngleClamp( struct.angles[ 1 ] );
	min_struct = getstruct( "explosion_angle_clamp_min", "targetname" );
	max_struct = getstruct( "explosion_angle_clamp_max", "targetname" );

	angles = VectorToAngles( min_struct.origin - struct.origin );
	min_yaw = AngleClamp( angles[ 1 ] );

	angles = VectorToAngles( max_struct.origin - struct.origin );
	max_yaw = AngleClamp( angles[ 1 ] );

	yaw = Clamp( yaw, min_yaw, max_yaw );

	struct.angles = ( struct.angles[ 0 ], yaw, struct.angles[ 2 ] );
}

player_view_unlock( player_rig )
{
	wait( 2 );
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 0, true );
	level.player thread view_cone_open( 3, 10, 10, 10, 10 );
}

// --------------------------------------------------------
// UTILITIES
// --------------------------------------------------------
big_ben_chime( times )
{
	level endon( "stop_big_ben_chimes" );
	if ( !IsDefined( times ) )
		times = 1;
		
	for ( i = 0; i < times; i++ )
	{
		big_ben_chime_single();
		wait( 4.5 );
	}
}

big_ben_chime_single()
{
	if ( !IsDefined( level.big_ben ) )
	{
		level.big_ben = GetEnt( "big_ben_sound_source", "targetname" );
	}
	
	level.big_ben StopSounds();
	level.big_ben PlaySound( "emt_london_bigben_chime" );
}

remove_all_guns()
{
	guns = GetEntArray();
	for ( i = 0; i < guns.size; i++ )
	{
		if ( IsDefined( guns[ i ].classname ) )
			if ( GetSubStr( guns[ i ].classname, 0, 7 ) == "weapon_" )
				guns[ i ] Delete();
	}
}

#using_animtree( "generic_human" );
convert_guy_to_model( guy, node, animation )
{
	model = Spawn( "script_model", guy.origin );
	model.angles = guy.angles;
	model SetModel( guy.model );
	size = guy GetAttachSize();
	for ( i = 0; i < size; i++ )
	{
		model Attach( guy GetAttachModelName( i ), guy GetAttachTagName( i ) );
// 		struct.attachedtags[ i ] = guy GetAttachTagName( i );
	}

	model UseAnimTree( #animtree );

	if ( IsDefined( guy.team ) )
	{
		model.team = guy.team;
	}

	if ( IsDefined( guy.script_parameters ) )
	{
		if ( guy.script_parameters == "can_die" )
		{
			model.can_die = true;
			model MakeFakeAi();
			model SetCanDamage( true );
			model thread model_die_when_shot( node, animation );
		}
	}

	model.weapon = guy.weapon;
	model.a = SpawnStruct();
	guy Delete();
	return model;
}

model_die_when_shot( node, animation )
{
	self endon( "natural_death" );
	self waittill( "damage" );
	self startRagDoll();
	self SetContents( 0 );
}

custom_array_spawn_targetname( target, drone_function )
{
    structs = getStructarray( target, "targetname" );
    foreach( struct in structs )
        thread spawn_and_do_drone_function( struct, drone_function );
    
    spawners = GetEntArray( target, "targetname" );
	foreach ( spawner in spawners )
		spawner thread spawn_ai();
    

}

wait_move_fight()
{
	self endon( "death" );
	self.ignoreme = false;
	self.ignoreall = false;
	self.fixednode = false;
	self AllowedStances( "crouch", "prone" );
	self.fixednode = true;
	self waittill( "move" );
//	self flashBangStop();
	self.ignoreme = true;
	self.ignoreall = true;
	self AllowedStances( "stand", "crouch", "prone" );
	node = GetNode( self.target, "targetname" );
	self.goalradius = 64;
	self SetGoalPos( node.origin );
	self waittill( "goal" );
	self.ignoreme = false;
	self.ignoreall = false;
	/* wait( RandomFloatRange(5, 10) );
	self.fixednode = false; */ 
	while ( player_can_see_ai( self ) )
	{
		wait( 0.3 );
	}
	self Kill();
}

time_to_move()
{
	delay = 0.4;
	if ( IsDefined( self.script_delay ) )
	{
		delay = self.script_delay;
	}

	self waittill( "trigger" );

	movers = GetEntArray( "wait_move_fight", "script_noteworthy" );
	foreach ( m in movers )
	{
		m notify( "move" );
		if ( delay > 0 )
			wait( RandomFloatRange( 0, delay ) );
	}

	movers = GetEntArray( "remove_fixednode", "script_noteworthy" );
	foreach ( m in movers )
	{
		m notify( "move" );
	}
}

remove_fixednode()
{
	self endon( "death" );
	wait( RandomFloatRange( 10, 15 ) );
	self.fixednode = false;
}

Delete_enemies_in_volume()
{
	self waittill( "trigger" );
	
	volume = GetEnt( self.target, "targetname" );
	enemies = GetAiArray( "axis" );
	count = 0;
	foreach ( e in enemies )
	{
		if ( e IsTouching( volume ) )
		{
			count++;
		}
	}
	
	if ( count > 3 )
	{
		return;
	}
	
	foreach ( e in enemies )
	{
		if ( e IsTouching( volume ) && ( Distance2D( e.origin, level.player.origin ) > 128 ) && ( !player_can_see_ai( e ) ) )
		{
			e notify( "killanimscript" );
			e Delete();
		}
	}
}

grenade_throw_trigger()
{
	level endon( "escalator_grenade_thrown" );

	self waittill( "trigger" );
	
	src = GetStruct( self.target, "targetname" );
	dest = GetStruct( src.target, "targetname" );
	
	MagicGrenade( "fraggrenade", src.origin, dest.origin, 4.8 );

	flag_set( "escalator_grenade_thrown" );
}

flag_set_when_volume_cleared()
{
	flag_init( self.script_flag );
	volume = GetEnt( self.target, "targetname" );
	
	self waittill( "trigger" );	
	while ( !volume_cleared( volume ) )
	{
		wait( 0.1 );
	}
	
	flag_set( self.script_flag );
}

volume_cleared( volume )
{
	enemies = GetAiArray( "axis" );
	foreach ( e in enemies )
	{
		if ( e IsTouching( volume ) )
		{
			return false;
		}
	}
	return true;
}

convert_to_model_and_animate( guy, animation, noragdoll, node, forceAnimTime, addToDyingGuys )
{
	if ( !IsDefined( noragdoll ) )
		noragdoll = true;

	if ( !IsDefined( guy ) )
	{
		return;
	}

	model = convert_guy_to_model( guy, node, animation );

	if ( !IsDefined( node ) )
	{
		node = model;
	}

	model.noragdoll = noragdoll;
	model.dontdonotetracks = true;
	node thread anim_generic( model, animation );

	if ( IsDefined( forceAnimtime ) )
	{
		model SetAnimTime( getgenericanim( animation ), forceAnimTime );
	}

	if ( IsDefined( addToDyingGuys ) )
	{
		model.animation = animation;
		level.dying_guys[ level.dying_guys.size ] = model;
	}

	if ( IsDefined( model.can_die ) )
	{
		node waittill( animation );
		if ( model.health == 0 )
		{
			model notify( "natural_death" );
			model SetContents( 0 );
		}
	}

	flag_wait( "reached_station_exit" );
	model Delete();
}

lerp_timescale_over_time( to, time )
{
	if ( !IsDefined( level._current_timescale ) )
		level._current_timescale = 1.0;
		
	from = level._current_timescale;
	incs = Int( time / 0.05 );
	rate = ( to - from ) / incs;
	
	t = from;
	count = 0;
	while ( count < incs )
	{
		SetTimeScale( t );
		level._current_timescale = t;
		t += rate;
		count++;
		wait( 0.05 );
	}
	SetTimeScale( to );
	level._current_timescale = to;
}

ai_to_animated_model_spawnfunc()
{
	self safe_gun_remove();
	self.animname = "generic";
	if ( IsDefined( self.target ) )
		targetnode = GetStruct( self.target, "targetname" );
	else
		targetnode = self;
	animation = self.animation;
	waittillframeend;
	if ( IsDefined( targetnode.script_noteworthy ) && targetnode.script_noteworthy == "loop" )
	{
		targetnode thread anim_generic_loop( self, animation );
		level waittill( "level_cleanup" );
		targetnode notify( "stop_loop" );
		if ( IsAlive( self ) )
			self Delete();
	}
	else
		thread convert_to_model_and_animate( self, animation, false, targetnode );
}

trigger_wait_targetname_multiple( trigTN )
{
	trigs = GetEntArray( trigTN, "targetname" );
	if ( !trigs.size )
	{
		AssertMsg( "no triggers found with targetname: " + trigTN );
		return;
	}
	
	other = undefined;
	
	if( trigs.size > 1 )
	{
		array_thread( trigs, ::trigger_wait_multiple_think, trigTN );
		level waittill( trigTN, other );
	}
	else
	{
		trigs[ 0 ] waittill( "trigger", other );
	}
	
	return other;
}

trigger_wait_multiple_think( trigTN )
{
	self endon( trigTN );
	
	self waittill( "trigger", other );
	level notify( trigTN, other );
}

get_player_rig()
{
	if ( !IsDefined( level.player_rig ) )
	{
		level.player_rig = spawn_anim_model( "player_rig" );
	}

	return level.player_rig;
}

//get_player_legs()
//{
//	if ( !IsDefined( level.player_legs ) )
//	{
//		level.player_legs = spawn_anim_model( "player_legs" );
//	}
//
//	level.player_legs.origin = level.player_rig.origin;
//	level.player_legs.angles = level.player_rig.angles;
//
//	return level.player_legs;
//}

link_player_to_arms( tag )
{
	if ( !IsDefined( tag ) )
	{
		tag = "tag_player";
	}

	player_rig = get_player_rig();
	player_rig Show();
	level.player PlayerLinkToDelta( player_rig, tag, 1, 15, 15, 0, 0, true );
}

blend_player_to_arms( time )
{
	if ( !IsDefined( time ) )
	{
		time = 0.7;
	}

	player_rig = get_player_rig();
	player_rig Show();
	level.player PlayerLinkToBlend( player_rig, "tag_player", time );
}

//---------------------------------------------------------
// Hud Section
//---------------------------------------------------------
// (string) primary_light is targetname 
// (int) movement is shaking offset for flickering effect 
// note: primary light must have parameter "maxmove" in radiant and it must not be smaller than "movement"
primary_light_flicker( primary_light, movement )
{
	level endon( "level_cleanup" );
	fire_light           = getent( primary_light, "targetname" );
	old_org             = fire_light.origin;
	
	while( 1 )
	{
		waittime = 0.05 + randomint( 4 )/10;
		fire_light MoveTo( old_org - ( randomint( movement ), randomint( movement ), randomint( movement ) ), waittime );
		wait waittime;
	}
}

vending_trigger()
{
	node = getStruct( self.target, "targetname" );
	ents = GetEntArray( node.target, "targetname" );
	anim_ents = [];
	brushmodels = [];
	guys = [];
	nodes = getnodearray( node.target, "targetname" );
	numguys = 1;
	machine = undefined;
	foreach ( ent in ents )
	{
		switch( ent.classname )
		{
			case "script_model":
				vending_machine = ent;
				ent.animname = "vending_machine";
				ent setAnimTree();
				anim_ents = array_add( anim_ents, ent );
				node thread anim_first_frame_solo( ent, "vending_scene" );
				machine = ent;
			break;
			case "actor_enemy_docks_SMG":
				guy = ent spawn_ai( true );
				spawn_failed();
				guy.dontDelete = true;
				guy.animname = "vending_dude_" + numguys;
				numguys++;
				anim_ents = array_add( anim_ents, guy );
				guys = array_add( guys, guy );
				node thread anim_first_frame_solo( guy, "vending_scene" );
				guy thread interrupt_anim_if_shot();
			break;
			case "script_brushmodel":
				ent.origin -= ( 0, 0, 512 );
				brushmodels = array_add( brushmodels, ent );
			break;
		}
	}

	self waittill( "trigger" );
	if ( !IsDefined( level.num_machines_crashed ) )
	{
		level.num_machines_crashed = 1;
	}

	do_animation = false;
	foreach ( guy in guys )
	{
		if ( !IsDefined( guy ) || !IsAlive( guy ) )
		{
			anim_ents = array_remove( anim_ents, guy );
			guys = array_remove( guys, guy );
		}
	}

	if ( guys.size > 0 )
	{
		machine thread play_sound_on_entity( "scn_london_vending_crash" + level.num_machines_crashed );
		node anim_single( anim_ents, "vending_scene" );

		foreach ( b in brushmodels )
		{
			b.origin += ( 0, 0, 512 );
		}
	
		foreach ( guy in guys )
		{
			if ( IsAlive( guy ) )
			{
				n = SortByDistance( nodes, guy.origin );
				guy.goalradius = 8; 
				guy SetGoalNode( n[ 0 ] );
			}
		}
	}

	level.num_machines_crashed++;
}

interrupt_anim_if_shot()
{
	self waittill_either( "death", "damage" );
	if ( IsAlive(self) )
		self StopAnimScripted();
}

should_break_flashbang_hint()
{
	return flag( "player_has_flashed" );
}

flag_on_flash()
{
	notifyOnCommand( "player_flash", "-smoke" );
	level.player waittill( "player_flash" );
	flag_set( "player_has_flashed" );
}

stairs_guys()
{
	if ( cointoss() )
		self.deathanim = %death_rooftop_C;
	else
		self.deathanim = %death_rooftop_D;
}

station_runners()
{
	self thread magic_bullet_shield();
	self endon( "death" );
	if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "cop_runner" ) 
	{
		self thread watch_take_down_targets();
	}
	else if ( IsDefined( self.script_noteworthy ) )
	{
		node = getStruct( "sas_wave_entrance", "targetname" );
		self.animname = "sas";
		node anim_reach_solo( self, "sas_wave" );
		self thread anim_single_solo( self, "london_sas2_ladstaketruck" );
		node anim_single_solo( self, "sas_wave" );
		level notify( "sas_move" );
	}
	else
	{
		self allowedStances( "crouch" );
		level waittill( "sas_move" );
		self allowedStances( "stand" );
	}
	self setGoalVolumeAuto( getent( self.target, "targetname" ) );
	wait( 30.0 );
	while( player_can_see_ai( self ) )
	{
		wait( 1.0 );
	}
	self stop_magic_bullet_shield();
	self Delete();
}

get_drone_spawner_from_pool( struct )
{
    Assert( IsDefined( struct.script_modelname ) );
    dronepool = GetEntArray( "london_west_drone_pool", "targetname" );

	struct set_script_modelname();
    
    foreach( spawner in dronepool )
    {
        if( spawner.script_modelname != struct.script_modelname )
		{
            continue;
		}

        spawner.count = 1;
        spawner.origin = struct.origin;
        spawner.angles = struct.angles;
        return spawner;
    }
}

set_script_modelname()
{
	modelnames = undefined;
	if ( self.script_modelname == "civilian" )
	{
		modelnames = [ "body_london_female_a", "body_london_male_a" ];
	}
	else if ( self.script_modelname == "civilian_drone" )
	{
		modelnames = [ "body_london_female_a_drone", "body_london_male_a_drone" ];
	}

	if ( IsDefined( modelnames ) )
	{
		modelnames = array_randomize( modelnames );
		self.script_modelname = modelnames[ 0 ];
	}
}

//---------------------------------------------------------
// Spawn Functions
//---------------------------------------------------------
postspawn_ending_police_driver()
{
	self.ignoreall = true;
	self disable_arrivals();
	self disable_exits();
	self gun_remove();
	self.name = "";
	self.no_vehicle_getoutanim = true;
	if ( IsDefined( self.script_parameters ) )
	{
		if ( self.script_parameters == "front_exit" )
		{
			self.get_out_override = getanim_generic( "front_exit_anim" );
		}
	}

	if ( IsDefined( self.script_avoidplayer ) )
	{
		self PushPlayer( true );
		self.nododgemove = true;
		self.dontavoidplayer = true;
	}

	self postspawn_police();
}

postspawn_ending_police_car()
{
	if ( IsDefined( self.script_sound ) )
	{
		self Vehicle_TurnEngineOff();
		self PlaySound( self.script_sound );
	}

	if ( IsDefined( self.script_index ) )
	{
		if ( self.script_index == 4 || self.script_index == 5 || self.script_index == 1 )
		{
			self.dontunloadonend = true;
		}
	}

	if ( !IsDefined( level.ending_police_cars ) )
	{
		level.ending_police_cars = [];
	}

	level.ending_police_cars[ level.ending_police_cars.size ] = self;
}

postspawn_police()
{
	self.ignoreall = true;
	self.name = "";
	self.disable_gun_recall = true;
	self gun_remove();
	self set_generic_run_anim( "jog" );

	self add_ending_ai();
	self thread ending_police_anim();
}

ending_police_anim()
{
	if ( !IsDefined( self.script_moveoverride ) )
	{
		return;
	}

	if ( IsDefined( self.target ) )
	{
		ent = self get_target_ent();
	}
	else
	{
		ent = self;
	}

	if ( IsDefined( ent.script_animation ) )
	{
		animation = ent.script_animation;		
	}
	else
	{
		animation = ent.animation;
	}

	if ( IsDefined( self.ridingvehicle ) )
	{
		self waittill( "jumpedout" );
		wait( 0.1 );
	}
	
	ent anim_generic_reach( self, animation );
	ent thread anim_generic_loop( self, animation );	
}

postspawn_man_stackers()
{
	self.dontavoidplayer = true;
	self.ignoreall = true;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0; 

	self add_ending_ai();
}

postspawn_sas_blockade_talk()
{
	self enable_readystand();
	self add_ending_ai();
	self.animname = "generic";
	level.bravo_two = self;

	self magic_bullet_shield();
	self waittill( "jumpedout" );

	self thread dialogue_queue( "setup_blockade1" );

	self waittill( "goal" );
	wait( 1 );

	struct = getstruct( "sas_blockade_talk_spot", "targetname" );
	guys = [ level.sas_leader, self ];

	level.sas_leader ent_flag_wait( "turnstile" );

	struct anim_reach( guys, "setup_blockade" );

	delaythread( 3, ::dialogue_queue, "setup_blockade2" );

	delay = GetAnimLength( level.sas_leader getanim( "setup_blockade" ) );
	delay *= 0.6;
	delaythread( delay, ::flag_set, "setup_blockade" );
	level thread blockade_truck_react( self );

	struct anim_single( guys, "setup_blockade" );

	nodes = GetNodeArray( "sas_talker_blockade_spots", "targetname" );
	foreach ( idx, guy in guys )
	{
		guy PushPlayer( true );
//		guy.nododgemove = true;
		guy.dontavoidplayer = true;
		guy.goalradius = 32;
		guy SetGoalNode( nodes[ idx ] );
	}

	if ( !flag( "truck_spawned" ) )
	{
		level.sas_leader thread dialogue_queue( "london_ldr_atblockade" );
	}
}

blockade_truck_react( guy )
{
	flag_wait( "truck_spawned" );

	if ( IsDefineD( guy ) )
	{
		guy thread dialogue_queue( "london_b21_weaponsfree" );
	}

	level.sas_leader delaythread( 2, ::dialogue_queue, "london_ldr_aimfordriver" );
}


postspawn_sas_blockade_guy()
{
	self add_ending_ai();

	self waittill( "unload" );

	wait( RandomFloatRange( 1, 1.5 ) );

	node = GetNode( self.target, "targetname" );
	self follow_path( node );
}

postspawn_injured_gassed()
{
	self.ignoreall = true;
	self.nododgemove = true;
	self.dontavoidplayer = true;
	self disable_exits();
	self disable_arrivals();

	if ( IsDefined( self.script_moveplaybackrate ) )
	{
		self.movePlaybackRate = self.script_moveplaybackrate;
	}

	self set_generic_run_anim( self.animation );

	self thread postspawn_injured_movement();
}

postspawn_injured_movement()
{
	level endon( "stop_injured_movement" );

	self.goalradius = 4;
	self gun_remove();

	goal = getstruct( self.target, "targetname" );
	while ( 1 )
	{
		self SetGoalPos( goal.origin );
		self waittill( "goal" );

		if ( IsDefined( goal.animation ) )
		{
			self thread postspawn_injured_gas_anim( goal.animation, goal );
			return;
		}

		if ( !IsDefined( goal.target ) )
		{
			break;
		}

		goal = getstruct( goal.target, "targetname" );
	}
}

postspawn_injured_gas_anim( animation, goal )
{
	theanim = getgenericanim( animation );
	time = GetAnimLength( theanim );
	
	goal thread anim_generic( self, animation );

	wait( time * 0.9 );

	self.allowDeath = true;
	self.a.nodeath = true;

	self Kill();
}

//---------------------------------------------------------
// Utility Section
//---------------------------------------------------------
drone_think()
{
	self endon( "death" );
	animation = self.animation;
		
	if ( IsDefined( self.target ) )
	{
//		node = self get_target_ent();
		nodes = getstructarray( self.target, "targetname" );
		nodes = array_randomize( nodes );
		node = nodes[ 0 ];
	}
	else
	{
		node = SpawnStruct();
		node.angles = self.angles;
		node.origin = self.origin;
	}

	if ( !IsDefined( node.angles ) )
	{
		node.angles = ( 0, 0, 0 );
	}

	self.targetname = "drone";
	
	if ( IsDefined( self.script_animation ) )
	{
		animation = self.script_animation;		
	}
	else
	{
		animation = self.animation;
	}

	if ( !IsSubStr( self.model, "civ" ) )
	{
		self safe_gun_remove();
	}

	if ( IsDefined( self.script_parameters ) )
	{
		if ( self.script_parameters == "cop" )
		{
			if ( !IsDefined( level.crowd_cop_speakers ) )
			{
				level.crowd_cop_speakers = [];
			}

			level.crowd_cop_speakers[ level.crowd_cop_speakers.size ] = self;
		}
		else if ( self.script_parameters == "civ" )
		{
			if ( !IsDefined( level.crowd_civ_speakers ) )
			{
				level.crowd_civ_speakers = [];
			}

			level.crowd_civ_speakers[ level.crowd_civ_speakers.size ] = self;
		}
	}

	if ( IsDefined( self.script_noteworthy ) )
	{
		if ( self.script_noteworthy == "walker" )
		{
			node = SpawnStruct();
			node.angles = self.angles;
			node.origin = self.origin;

			self drone_assign_script_noteworthy();
			
			if ( IsDefined( level.scr_anim[ "drone" ][ animation ] ) )
			{
				self drone_idle_before_move( node, animation );
			}

			self notify( "move" );
		
			self.drone_run_speed = 80;
			self.script_drone_override = true;
			self.drone_move = "hurried_walk";
			self.drone_move_callback = ::drone_move_anim;
			self waittill( "goal" );
			self Delete();
		}
	}
	else
	{
		self drone_assign_script_noteworthy();
		self thread drone_ending_idle( node, animation );
	}
}

drone_assign_script_noteworthy()
{
	if ( IsDefined( self.groupname ) )
	{
		self.script_noteworthy = self.groupname;
	}
}

drone_idle_before_move( node, animation )
{
	do_idle = false;
	if ( IsDefined( self.script_flag_wait ) )
	{
		do_idle = true;
	}
	else if ( IsDefined( self.script_delay ) )
	{
		do_idle = true;		
	}
	else if ( IsDefined( self.script_delay_min ) && IsDefined( self.script_delay_max ) )
	{
		do_idle = true;
	}

	if ( do_idle )
	{
		self thread drone_ending_idle( node, animation );

		if ( IsDefined( self.script_flag_wait ) )
		{
			flag_wait( self.script_flag_wait );
		}

		self script_delay();

		self notify( "stop_drone_ending_idle" );
	}
}

#using_animtree( "generic_human" );
drone_ending_idle( node, anime )
{
	self endon( "death" );
	self endon( "stop_drone_ending_idle" );

	anim_string = "drone_anim";

	self.animname = "drone";
	animname = self.animname;

	if ( !IsDefined( anime ) )
	{
		anime = "standing";
	}

	anims = level.scr_anim[ animname ][ anime ];

	wait( 0.05 );

	self.origin = drop_to_ground( self.origin, 32 );

//	if ( IsDefined( self.script_parameters ) && self.script_parameters == "cop" )
//	{
//		self thread draw_line_from_ent_to_ent_for_time( self, node, 1, 1, 1, 99999 );
//		self thread drone_drawtag( "tag_origin" );
//	}

	prop_name = undefined;
	tag = undefined;
	while ( 1 )
	{
		rate = RandomFloatRange( 0.9, 1.1 );

		if ( IsArray( anims ) )
		{
//			num = RandomInt( anims.size );
			num = maps\_anim::anim_weight( animname, anime );
			animation = level.scr_anim[ animname ][ anime ][ num ];

			if ( IsDefined( level.scr_anim[ animname ][ anime + " model" ] ) )
			{
				if ( IsDefined( level.scr_anim[ animname ][ anime + " model" ][ num ] ) )
				{
					prop_index = level.scr_anim[ animname ][ anime + " model" ][ num ];
					prop_name =	getmodel( prop_index );
					tag = "tag_inhand";

					if ( GetDvar( "debug_tag" ) != "" )
					{
						tag = GetDvar( "debug_tag" );
					}

//					self thread drone_drawtag( tag );
					self Attach( prop_name, tag );
				}
			}
		}
		else
		{
			animation = level.scr_anim[ animname ][ anime ];
		}

		anim_time = GetAnimLength( animation );

//		self.origin = node.origin;
		temp = Spawn( "script_origin", self.origin );
		self LinkTo( temp );
		temp MoveTo( node.origin, 0.4, 0.2, 0.2 );
		wait( 0.4 );
		self Unlink();
		temp Delete();

		self SetFlaggedAnimKnobAllRestart( anim_string, animation, %body, 1, 0.5, rate );

		node thread maps\_anim::start_notetrack_wait( self, anim_string, anime, self.animname );
		node thread maps\_anim::animscriptDoNoteTracksThread( self, anim_string, anime );
		node thread maps\_anim::anim_animationEndNotify( self, anime, anim_time, 0.25 );

//		wait( anim_time - 0.5 );
//		wait( 0.5 );
		wait( anim_time );

		if ( IsDefined( prop_name ) )
		{
			self Detach( prop_name, tag );
			prop_name = undefined;
//			self notify( "stop_drone_drawtag" );
		}
	}
}

drone_speakers_thread( type )
{
	sound_array = [];
	if ( type == "civ" )
	{
		min_delay = 5;
		max_delay = 10;

		sound_array[ sound_array.size ] = "london_bf1_becareful";
		sound_array[ sound_array.size ] = "london_bf1_bosspissed";
		sound_array[ sound_array.size ] = "london_bf1_camera";
		sound_array[ sound_array.size ] = "london_bf1_cantsee";
//		sound_array[ sound_array.size ] = "london_bf1_canttalk";
		sound_array[ sound_array.size ] = "london_bf1_goingon";
		sound_array[ sound_array.size ] = "london_bf1_gonnabelate";
		sound_array[ sound_array.size ] = "london_bf1_greatonline";
		sound_array[ sound_array.size ] = "london_bf1_inbed";
//		sound_array[ sound_array.size ] = "london_bf1_jumpsuits";
		sound_array[ sound_array.size ] = "london_bf1_meeting";
		sound_array[ sound_array.size ] = "london_bf1_seethat";
		sound_array[ sound_array.size ] = "london_bf1_soldiers";
		sound_array[ sound_array.size ] = "london_bf1_tellsteve";
		sound_array[ sound_array.size ] = "london_bf1_weird";
		sound_array[ sound_array.size ] = "london_bm10_proposals";
		sound_array[ sound_array.size ] = "london_bm11_seethat";
		sound_array[ sound_array.size ] = "london_bm12_camera";
		sound_array[ sound_array.size ] = "london_bm1_battery";
//		sound_array[ sound_array.size ] = "london_bm1_bigben";
		sound_array[ sound_array.size ] = "london_bm1_goingon";
		sound_array[ sound_array.size ] = "london_bm1_online";
		sound_array[ sound_array.size ] = "london_bm1_short";
		sound_array[ sound_array.size ] = "london_bm1_startshooting";
		sound_array[ sound_array.size ] = "london_bm2_lateforwork";
		sound_array[ sound_array.size ] = "london_bm3_sassoldiers";
//		sound_array[ sound_array.size ] = "london_bm6_meeting";
//		sound_array[ sound_array.size ] = "london_bm7_jumpsuits";
		sound_array[ sound_array.size ] = "london_bm8_myboss";
		sound_array[ sound_array.size ] = "london_bm9_weird";
	}
	else // cop
	{
		min_delay = 5;
		max_delay = 15;

		sound_array[ sound_array.size ] = "london_bp1_movealong";
		sound_array[ sound_array.size ] = "london_bp1_anotherway";
		sound_array[ sound_array.size ] = "london_bp2_nopictures";
		sound_array[ sound_array.size ] = "london_bp2_standback";
	}

	level endon( "truck_spawned" );

	sound_num = 0;
	while ( 1 )
	{
		wait( RandomFloatRange( min_delay, max_delay ) );
		
		if ( type == "civ" )
		{
			if ( !IsDefined( level.crowd_civ_speakers ) )
			{
				continue;
			}

			speakers = level.crowd_civ_speakers;
		}
		else
		{
			if ( !IsDefined( level.crowd_cop_speakers ) )
			{
				continue;
			}

			speakers = level.crowd_cop_speakers;
		}

		if ( speakers.size == 0 )
		{
			continue;
		}

		speakers = array_removeundefined( speakers );
		speakers = SortByDistance( speakers, level.player.origin );

		count = 3;
		count = int( min( speakers.size, count ) );

		speaker = speakers[ RandomInt( count ) ];
		thread play_sound_in_space( sound_array[ sound_num ], speaker.origin + ( 0, 0, 60 ) );

		sound_num++;

		if ( sound_num > sound_array.size - 1 )
		{
			sound_num = 0;
			sound_array = array_randomize( sound_array );
		}
	}
}

drone_drawtag( tag )
{
	self notify( "stop_drone_drawtag" );
	self endon( "stop_drone_drawtag" );

	while ( 1 )
	{
		self maps\_debug::drawTag( tag );
		wait( 0.05 );
	}
}

drone_move_anim()
{
	struct = undefined;

	if ( !IsDefined( self.drone_move_time ) )
	{
		self.drone_move_time = -1000;
	}
	
	if ( GetTime() > self.drone_move_time )
	{
		struct = SpawnStruct();
		anims = level.scr_anim[ "drone" ][ self.drone_move ];

		if ( !IsDefined( anims ) )
		{
			anims = level.scr_anim[ "generic" ][ self.drone_move ];
		}

		if ( IsArray( anims ) )
		{
			anims = array_randomize( anims );
			struct.runanim = anims[ 0 ];
		}
		else
		{
			// anims is not an array so assume it's just 1 anim;
			struct.runanim = anims;
		}
	
		animdata = maps\_drone::get_anim_data( struct.runanim );
		struct.anim_relative = animdata.anim_relative;
		struct.run_speed = animdata.run_speed;

		self.drone_move_time = GetTime() + ( ( animdata.anim_time / self.moveplaybackrate )* 1000 );
	}

	return struct;
}

add_ending_ai()
{
	if ( !IsDefined( level.ending_ai ) )
	{
		level.ending_ai = [];
	}

	level.ending_ai[ level.ending_ai.size ] = self;
}

trigger_with_target_makes_drones_do_this( target, drone_function )
{
    trigger = GetEnt( target, "target" );
    Assert( IsDefined( trigger ) );
	trigger.drone_function = drone_function;
	trigger add_trigger_function( ::make_my_targeted_drones_do_this_function );
}

trigger_with_targetname_dronespawn( targetname, drone_function )
{
    trigger = GetEnt( targetname, "targetname" );
    Assert( IsDefined( trigger ) );
	trigger.drone_function = drone_function;
	trigger add_trigger_function( ::make_my_targeted_drones_do_this_function );
}

trigger_dronespawn( drone_function )
{
	self.drone_function = drone_function;
	self add_trigger_function( ::make_my_targeted_drones_do_this_function );
}

make_my_targeted_drones_do_this_function( triggerer )
{
    structs = getStructarray( self.target, "targetname" );
    foreach( struct in structs )
    {
        thread spawn_and_do_drone_function( struct, self.drone_function  );
    }
}

self_spawn_and_do_drone_function( drone_function )
{
	self thread spawn_and_do_drone_function( self, drone_function );
}

spawn_and_do_drone_function( struct, drone_function )
{
    if ( IsDefined( struct.script_delay_spawn  ) )
	{
        wait( struct.script_delay_spawn );
	}

    spawner = get_drone_spawner_from_pool( struct );

    spawner.script_moveoverride = undefined;
    if( IsDefined( struct.script_moveoverride ) )
	{
        spawner.script_moveoverride = struct.script_moveoverride;
	}

    spawner.animation = undefined;
    if ( IsDefined( struct.animation ) )
	{
        spawner.animation = struct.animation;
	}

	spawner.script_animation = undefined;
    if ( IsDefined( struct.script_animation ) )
	{
        spawner.script_animation = struct.script_animation;
	}

    spawner.target = undefined;
    if( IsDefined( struct.target ) )
	{
        spawner.target = struct.target;
	}
	
	if ( IsDefined( struct.script_flag ) )
	{
		flag_wait( struct.script_flag );
	}

    guy = dronespawn( spawner );
	guy.struct = struct;

	if ( guy.model == "body_london_cop" )
	{
		guy.name = "";
		guy SetLookAtText( guy.name, &"" );
	}

    if( IsDefined( struct.script_noteworthy ) )
	{
        guy.script_noteworthy = struct.script_noteworthy;
	}

    if( IsDefined( struct.script_parameters ) )
	{
        guy.script_parameters = struct.script_parameters;
	}

	if ( IsDefined( struct.script_flag_wait ) )
	{
		guy.script_flag_wait = struct.script_flag_wait;
	}

	if ( IsDefined( struct.groupname ) )
	{
		guy.groupname = struct.groupname;
	}

	if ( IsDefined( struct.script_delete ) )
	{
		guy.script_delete = struct.script_delete;
	}

	if ( IsDefined( struct.script_delay ) )
	{
		guy.script_delay = struct.script_delay;
	}

	if ( IsDefined( struct.script_delay_min ) )
	{
		guy.script_delay_min = struct.script_delay_min;
	}

	if ( IsDefined( struct.script_delay_max ) )
	{
		guy.script_delay_max = struct.script_delay_max;
	}

    guy thread [[ drone_function ]]();
}

//hide_dead_bodies()
//{
//	bodies = GetEntArray( "civilian_dead_bodies", "targetname" );
//	array_call( bodies, ::Hide );
//}

//show_dead_bodies()
//{
//	bodies = GetEntArray( "civilian_dead_bodies", "targetname" );
//	array_call( bodies, ::Show );
//}

safe_gun_remove()
{
	if ( self.weapon == "none" )
	{
		return;
	}

	self gun_remove();
}

tube_announcer()
{
	flag_wait( "tube_announcer_start" );

	loop = [];
	// "The next station is Westminster Station. Upon arrival, the last set of doors will not open. Passengers in the last carriage, please move towards the front doors to leave the train."
	loop[ loop.size ] = "london_anc_movetowardsfront";
	// "Please move all baggage away from the doors and stand clear. The train is now departing."
	loop[ loop.size ] = "london_anc_movebaggage";
	// "Ladies and gentlemen, please use all doors available on the train, including the doors located at the front of the train."
	loop[ loop.size ] = "london_anc_alldoors";
	// "Stand clear of the doors."
	loop[ loop.size ] = "london_anc_standclear";

	loop = array_randomize( loop );

	// "Please mind the gap."
	loop = array_insert( loop, "london_anc_mindthegap", 0 );

	level thread tube_announcer_thread( "trainstop_speaker_path", loop );

	loop = [];
	// "Ladies and gentlemen, we apologize for the delay but there is a security alert at Westminster Station."
	loop[ loop.size ] = "london_anc_securityalert";
	// "This is a reminder to all passengers that there is strictly no smoking allowed on any part of the Underground."
	loop[ loop.size ] = "london_anc_nosmoking";
	// "Westminster Station is closed. Please find alternate transportation."
	loop[ loop.size ] = "london_anc_alternatetransport";
	// "This is a Picadilly Line service to Cockfusters."
	loop[ loop.size ] = "london_anc_cockfusters";
	// "This is a Jubilee Line train via Westminster Station."
	loop[ loop.size ] = "london_anc_viawestminster";
	// "In the interests of safety, flash photography is not permitted on any part of the Jubilee Line."
	loop[ loop.size ] = "london_anc_flashphotography";

	loop = array_randomize( loop );

	level thread tube_announcer_thread( "tube_speaker_path", loop );
}

tube_announcer_thread( path_targetname, snd_array )
{
	path_start = getstruct( path_targetname, "targetname" );
	max_dist = 700;
	max_dist *= max_dist;

	speakers = [];

	delay_struct = SpawnStruct();
	delay_struct.delay = 0;
	delay_struct.waiting_for_sound = false;

	for ( i = 0; i < 2; i++ )
	{
		speakers[ i ] = Spawn( "script_origin", ( 0, 0, 0 ) );
		speakers[ i ].id = i + 1;
	}
	
	index = 0;
	while ( 1 )
	{
		nodes = get_closest_speaker_nodes( path_start );

		foreach ( i, speaker in speakers )
		{
			speaker.origin = nodes[ i ].origin;
//			print3d( speaker.origin, "speaker" + speaker.id, ( 1, 1, 0 ), 1, 1, 4 );
		}
	
		if ( GetTime() > delay_struct.delay && !delay_struct.waiting_for_sound )
		{
			if ( DistanceSquared( level.player.origin, nodes[ 0 ].origin ) > max_dist )
			{
				wait( 0.1 );
				continue;
			}

			mod = index % snd_array.size;
			index++;
			if ( mod == 0 )
			{
				snd_array = array_randomize( snd_array );
			}

			delay_struct thread speaker_playsound( speakers, snd_array[ mod ] );
		}

		wait( 0.1 );
	}
}

speaker_playsound( speakers, sound )
{
	self.waiting_for_sound = true;

	foreach ( speaker in speakers )
	{
		speaker PlaySound( sound, "sounddone" );
	}

	speakers[ 0 ] waittill( "sounddone" );

	self.waiting_for_sound = false;
	self.delay = GetTime() + ( RandomFloatRange( 5, 8 ) * 1000 );
}

get_closest_speaker_nodes( node )
{
	dist = DistanceSquared( level.player.origin, node.origin );
	closest = node;
	while ( IsDefined( node.target ) )
	{
		node = getstruct( node.target, "targetname" );

		test_dist = DistanceSquared( level.player.origin, node.origin );
		if ( test_dist < dist )
		{
			dist = test_dist;
			closest = node;
		}
	}

	// Now get the next closest for stereo feel
	prev = undefined;
	prev = getstruct( closest.targetname, "target" );

	next = undefined;
	if ( IsDefined( closest.target ) )
	{
		next = getstruct( closest.target, "targetname" );
	}

//	dist = 2147483647; // Largest number in script
	dist = 8000 * 8000;
	nodes = [ closest ];
	closest_2nd = undefined;

	nodes2 = [];

	if ( IsDefined( prev ) )
	{
		nodes2[ nodes2.size ] = prev;
	}

	if ( IsDefined( next ) )
	{
		nodes2[ nodes2.size ] = next;
	}

	if ( nodes2.size > 0 )
	{
		dist = DistanceSquared( level.player.origin, nodes2[ 0 ].origin );
		closest_2nd = nodes2[ 0 ];
	}

	foreach ( n in nodes2 )
	{
		test_dist = DistanceSquared( level.player.origin, n.origin );

		if ( test_dist < dist )
		{
			dist = test_dist;
			closest_2nd = n;
		}
	}

	if ( IsDefined( closest_2nd ) )
	{
		nodes[ nodes.size ] = closest_2nd;
	}

	return nodes;
}

lit_posters()
{
	ents = GetEntArray( "lit_poster", "targetname" );
	array_thread( ents, ::lit_poster_think );
}

lit_poster_think()
{
	origin = self GetCentroid();
	health = 250;
	self SetCanDamage( true );
	while ( health > 0 )
	{
		self waittill( "damage", dmg );
		health -= dmg;
	}

	level thread Play_sound_in_space( "lit_poster_shot", origin );
	PlayFX( getfx( "lit_poster" ), origin );
	self Delete();
}

//---------------------------------------------------------
// Debug Section 
//---------------------------------------------------------
vehicles_print_stopped_positions( vehicle )
{
	vehicle endon( "death" );
	vehicle script_delay();

	wait( 0.5 );
	while ( vehicle.veh_speed > 0 )
	{
		wait( 0.5 );
	}

	println( "STOPPED POSITION" );
	println( "MODEL  = " + vehicle.model );
	println( "ORIGIN = " + vehicle.origin );
	println( "ANGLES = " + vehicle.angles );
	println( "-------" );
}