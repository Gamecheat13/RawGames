#include maps\_hud_util;
#include maps\_utility;
#include animscripts\utility;
#include maps\_vehicle;
#include maps\sniperescape;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_stealth_logic;

move_in()
{
	assertex( isdefined( self.target ), "Move in trigger didn't have target" );
	level endon( "movein_trigger" + self.target );

	if ( !isdefined( level.move_in_trigger_used[ self.target ] ) )
	{
		level.move_in_trigger_used[ self.target ] = true;
		ai = spawn_guys_from_targetname( self.target );
		array_thread( ai, ::stay_put );
		array_thread( ai, ::set_ignoreall, true );
		level.move_in_trigger_used[ self.target ] = ai;
	}
	
	self waittill( "trigger" );
	ai = level.move_in_trigger_used[ self.target ];
	for ( i = 0; i < ai.size; i++ )
	{
		if ( !isalive( ai[ i ] ) )
			continue;

		if ( ai[ i ] isdog() )
			ai[ i ] delete();
	}
	ai = remove_dead_from_array( ai );
	
	array_thread( ai, ::set_ignoreall, false );
	array_thread( ai, ::ai_move_in );
	self notify( "movein_trigger" + self.target );
}

spawn_guys_from_targetname( targetname )
{
	guys = [];
	spawners = getentarray( targetname, "targetname" );
	for ( i = 0; i < spawners.size; i++ )
	{
		spawner = spawners[ i ];
		spawner.count = 1;
		guy = spawner spawn_ai();
		spawn_failed( guy );
		if ( isalive( guy ) )
		{
			guys[ guys.size ] = guy;
		}
		
		if ( 1 ) 
			continue;
		assertEx( isalive( guy ), "Guy from spawner with targetname " + targetname + " at origin " + spawner.origin + " failed to spawn" );
		
		guys[ guys.size ] = guy;
	}
	
	return guys;
}


chase_chopper_guys_land()
{
	self endon( "death" );
	self waittill( "jumpedout" );

	if ( flag( "enter_burnt" ) )
	{
		// player is already in the apartment
		nodes = getnodearray( "park_delete_node", "targetname" );
		thread fall_back_and_delete( nodes );
		return;
	}

	// player went back outside so the chase begins anew
	thread ai_move_in();
}

chopper_guys_land()
{
	self endon( "death" );
	self waittill( "jumpedout" );

	if ( flag( "player_defends_heat_area" ) )
	{
		self delete();
		return;
	}
	
	thread ai_move_in();
}

not_move_in_guy()
{
	if ( isdefined( self.dontmovein ) )
		return true;
	if ( !isdefined( self.script_noteworthy ) )
		return false;
		
	return self.script_noteworthy == "apartment_hunter";
}

ai_move_in()
{
	// guy could be dead because we did a getent not a getai
	if ( !isalive( self ) )
		return;

	if ( not_move_in_guy() )
		return;
			
	self endon( "death" );
	self notify( "stop_going_to_node" );
	
	if ( isdefined( self.target ) )
		self maps\_spawner::go_to_node();

	thread reacquire_player_pos();
}	

stop_moving_in()
{
	self.dontmovein = true;
	self notify( "stop_moving_in" );
}

reacquire_player_pos()
{
		
	// so guys that get threaded to move in kill their old move in thread
	self notify( "stop_moving_in" );
	self endon( "stop_moving_in" );

	self endon( "death" );
	for ( ;; )
	{
		self setgoalpos( level.player.origin );
		self.goalradius = 1500;
		wait( 5 );
	}
}

stay_put()
{
	self setgoalpos( self.origin );
	self.goalradius = 64;
}

debounce_think()
{
// 	assertex( isdefined( self.script_linkto ), "Trigger at " + self.origin + " had no script_linkto" );
	if ( !isdefined( self.script_linkto ) )
		return;
		
	links = strtok( self.script_linkto, " " );
	assertex( links.size > 0, "Trigger at " + self.origin + " had no script_linktos" );
	array_levelthread( links, ::add_trigger_to_debounce_list, self );
	
	self waittill( "trigger" );
	// only delete triggers on the first touch because its redundant to do it mulitple times.
	array_levelthread( links, ::delete_trigger_with_linkname );
	array_levelthread( links, ::turn_off_triggers_from_links, 3 );
	
	for ( ;; )
	{
		self waittill( "trigger" );
		array_levelthread( links, ::turn_off_triggers_from_links, 3 );
		wait( 1 );
	}
}

turn_off_triggers_from_links( link, timer )
{
	array_thread( level.debounce_triggers[ link ], ::turn_off_trigger_for_time, timer );
}

turn_off_trigger_for_time( timer )
{
	self notify( "new_debouce" );
	self endon( "new_debouce" );
	self endon( "death" );
	self trigger_off();
	wait( timer );
	self trigger_on();
}

delete_trigger_with_linkname( link )
{
	trigger = getent( link, "script_linkname" );
	if ( !isdefined( trigger ) )
		return;
		
	// debounce triggers arent required to have a script_linkto
	if ( isdefined( trigger.script_linkto ) )
	{
		links = strtok( trigger.script_linkto, " " );
		array_levelthread( links, ::remove_trigger_from_debounce_lists, trigger );
		trigger trigger_off();
	}
}

add_trigger_to_debounce_list( link, trigger )
{
	if ( !isdefined( level.debounce_triggers[ link ] ) )
		level.debounce_triggers[ link ] = [];
		
	level.debounce_triggers[ link ][ level.debounce_triggers[ link ].size ] = trigger;
}

remove_trigger_from_debounce_lists( link, trigger )
{
	// use getarraykeys because we set indicies of the array to undefined
	keys = getarraykeys( level.debounce_triggers[ link ] );
	for ( i = 0; i < keys.size; i++ )
	{
		key = keys[ i ];
		if ( level.debounce_triggers[ link ][ key ] != trigger )
			continue;
		
		level.debounce_triggers[ link ][ key ] = undefined;
		return;
	}
}

enemy_override()
{
	self.accuracy = 0.2;
	
	start_min_dist = self.engagemindist;
	start_min_falloff = self.engageminfalloffdist;
	start_max_dist = self.engagemaxdist;
	start_max_falloff = self.engagemaxfalloffdist;
	// start farther out then move in
	if ( isdefined( level.engagement_dist_func[ self.classname ] ) )
	{
		[[ level.engagement_dist_func[ self.classname ] ]]();
	}
	else
	{
		return;
	}

	self endon( "death" );
	// got an enemy yet?
	self waittill( "enemy" );
	for ( ;; )
	{
		wait( randomfloat( 5, 8 ) );
		if ( !isdefined( self.node ) )
			continue;
			
		if ( !isdefined( self.enemy ) )
			continue;

		if ( distance( self.origin, self.node.origin ) > 128 )
			continue;

		new_min_dist = self.engagemindist - 150;
		new_min_falloff = self.engageminfalloffdist - 150;
		new_max_dist = self.engagemaxdist - 150;
		new_max_falloff = self.engagemaxfalloffdist - 150;
		
		if ( new_min_dist < start_min_dist )
			new_min_dist = start_min_dist;
		if ( new_min_falloff < start_min_falloff )
			new_min_falloff = start_min_falloff;
		if ( new_max_dist < start_max_dist )
			new_max_dist = start_max_dist;
		if ( new_max_falloff < start_max_falloff )
			new_max_falloff = start_max_falloff;
			
		self setengagementmindist( new_min_dist, new_min_falloff );
		self setengagementmaxdist( new_max_dist, new_max_falloff );
		wait( 12 );
	}
}

engagement_shotgun()
{
	self setEngagementMinDist( 900, 700 );
	self setEngagementMaxDist( 1000, 1200 );
}

engagement_rifle()
{
	self setEngagementMinDist( 1200, 1000 );
	self setEngagementMaxDist( 1400, 2000 );
}

engagement_sniper()
{
	self setEngagementMinDist( 1600, 1200 );
	self setEngagementMaxDist( 1800, 2000 );
}

engagement_smg()
{
	self setEngagementMinDist( 900, 700 );
	self setEngagementMaxDist( 1000, 1200 );
}

engagement_gun()
{
	self setEngagementMinDist( 1600, 1200 );
	self setEngagementMaxDist( 1800, 2000 );
}


gilli_leaves()
{
	bones = [];
	bones[ bones.size ] = "J_MainRoot";
	bones[ bones.size ] = "J_CoatFront_LE";
	bones[ bones.size ] = "J_Hip_LE";
	bones[ bones.size ] = "J_CoatRear_RI";
	bones[ bones.size ] = "J_CoatRear_LE";
	bones[ bones.size ] = "J_CoatFront_RI";
	bones[ bones.size ] = "J_Cheek_RI";
	bones[ bones.size ] = "J_Brow_LE";
	bones[ bones.size ] = "J_Shoulder_RI";
	bones[ bones.size ] = "J_Head";
	bones[ bones.size ] = "J_ShoulderRaise_LE";
	bones[ bones.size ] = "J_Neck";
	bones[ bones.size ] = "J_Clavicle_RI";
	bones[ bones.size ] = "J_Ball_LE";
	bones[ bones.size ] = "J_Knee_Bulge_LE";
	bones[ bones.size ] = "J_Ankle_RI";
	bones[ bones.size ] = "J_Ankle_LE";
	bones[ bones.size ] = "J_SpineUpper";
	bones[ bones.size ] = "J_Knee_RI";
	bones[ bones.size ] = "J_Knee_LE";
	bones[ bones.size ] = "J_HipTwist_RI";
	bones[ bones.size ] = "J_HipTwist_LE";
	bones[ bones.size ] = "J_SpineLower";
	bones[ bones.size ] = "J_Hip_RI";
	bones[ bones.size ] = "J_Elbow_LE";
	bones[ bones.size ] = "J_Wrist_RI";

	self endon( "death" );
	for ( ;; )
	{	
		while ( self.movemode != "run" )
		{
			wait( 0.2 );
			continue;
		}

		playfxontag( level._effect[ "gilli_leaves" ], self, random( bones ) );
		wait( randomfloatrange( 0.1, 2.5 ) );
	}
}

group1_enemies_think( ent )
{
	ent.count++ ;
	self waittill( "death" );
	ent.count -- ;
	
	if ( ent.count <= 1 )
	{
		activate_trigger_with_noteworthy( "group2_movein" );
	}
}

increment_count_and_spawn()
{
	self.count = 1;
	self spawn_ai();
}

heat_spawners_attack( spawners, start_flag, stop_flag )
{
	if ( !isdefined( level.flag[ start_flag ] ) )
	{
		flag_init( start_flag );
	}

	if ( !isdefined( level.flag[ stop_flag ] ) )
	{
		flag_init( stop_flag );
	}
	
	array_thread( spawners, ::add_spawn_function, ::chase_friendlies );
	
	// spawn guys if the enemy count gets too low and the right flags are set
	for ( ;; )
	{
		flag_waitopen( stop_flag );

		count = getaiarray( "axis" ).size;
		if ( count > 14 )
		{
			// random wait to vary which spawners are used
			wait( randomfloatrange( 1, 2 ) );
			continue;
		}
		
		flag_wait( start_flag );

		if ( flag( stop_flag ) )
			continue;

		// vary up the guys that actually spawn			
		new_spawners = array_randomize( spawners );
		spawn_limited_number_from_spawners( new_spawners, new_spawners, 3, 1 );
		/* 
		total_dogs = getaiSpeciesArray( "axis", "dog" ).size;
		for ( i = 0; i < new_spawners.size * 0.75; i++ )
		{
			spawners[ i ] thread increment_count_and_spawn();
		}
		*/ 
		
		// if the spawners fail, then at least we can tell why instead of having an infinite loop
		wait( 0.05 );
	}
}

leave_one_think()
{
	// delete all but one of the targets 
	targs = getentarray( self.target, "targetname" );
	self waittill( "trigger" );
	selected = random( targs );
	for ( i = 0; i < targs.size; i++ )
	{
		if ( targs[ i ] == selected )
			continue;
		targs[ i ] delete();
	}
}

objective_position_update( num )
{
	level endon( "stop_updating_objective" );
	for ( ;; )
	{
		objective_position( num, self.origin );
		wait( 0.05 );
	}
}

add_engagement_func( msg, func )
{
	level.engagement_dist_func[ msg ] = func;
}

enemy_accuracy_assignment()
{
	level.last_callout_direction = "";
	level.next_enemy_call_out = 0;
	level endon( "stop_adjusting_enemy_accuracy" );
	level.callout_near_dist = 250;
	
	for ( ;; )
	{
		wait( 0.05 );
		ai = getaiarray( "axis" );
		dot_ai = [];
		
		// close guys get high accuracy
		for ( i = 0; i < ai.size; i++ )
		{
			if ( distance( level.player.origin, ai[ i ].origin ) < 500 )
			{
				// even the accurate guys get close accuracy
				ai[ i ].baseaccuracy = 1;
				continue;
			}
			
			dot_ai[ dot_ai.size ] = ai[ i ];
		}

	    player_angles = level.player GetPlayerAngles();
	    player_forward = anglesToForward( player_angles );

		if ( !dot_ai.size )
		{
			continue;
		}
			
		ai = dot_ai;
		// farther guys can't hit unless they're the guy you're looking at

		// put them into either the get accuracy or dont get accuracy array
		GET_ACCURACY = true;
		LOSE_ACCURACY = false;
		guys = [];
		guys[ GET_ACCURACY ] = [];
		guys[ LOSE_ACCURACY ] = [];
		high_accuracy_guys = [];		
		lowest_dot = 1;
		lowest_dot_guy = undefined;

		for ( i = 0; i < ai.size; i++ )
		{
			guy = ai[ i ];
			normal = vectorNormalize( guy.origin - level.player.origin );
			dot = vectorDot( player_forward, normal );
// 			print3d( guy.origin + ( 0, 0, 64 ), dot + " " + guy.finalaccuracy, ( 1, 1, 0.3 ), 1 );

			guy.dot = dot;
			get_accuracy_result = dot > 0.8;
			guys[ get_accuracy_result ][ guys[ get_accuracy_result ].size ] = guy;
			if ( dot < lowest_dot )
			{
				lowest_dot = dot;
				lowest_dot_guy = guy;
			}
		}
		
		for ( i = 0; i < guys[ GET_ACCURACY ].size; i++ )
		{
			// guys you're looking at get a little accuracy
			guys[ GET_ACCURACY ][ i ].baseAccuracy = 0.7;
		}

		for ( i = 0; i < guys[ LOSE_ACCURACY ].size; i++ )
		{
			guys[ LOSE_ACCURACY ][ i ].baseAccuracy = 0.2;
			guys[ LOSE_ACCURACY ][ i ].threatbias = 0;
		}
		
		if ( isdefined( lowest_dot_guy ) )
		{
// 			lowest_dot_guy.threatbias = 10000;
		}
		

		// disabling enemy call outs for this area
//		level notify( "price_sees_enemy" );

//		thread new_enemy_callout( ai );
	
// 		angles = vectorToAngles( target_origin - other.origin );
// 	    forward = anglesToForward( angles );
// 		draw_arrow( level.player.origin, level.player.origin + vectorscale( forward, 150 ), ( 1, 0.5, 0 ) );
// 		draw_arrow( level.player.origin, level.player.origin + vectorscale( player_forward, 150 ), ( 0, 0.5, 1 ) );


	}
}

ai_is_near_teammates( dist )
{
	ai = getaiarray( self.team );
	for ( i = 0; i < ai.size; i++ )
	{
		if ( ai[ i ] == self )
			continue;
		if ( distance( self.origin, ai[ i ].origin ) <= dist )
			return true;
	}
	return false;
}

new_enemy_callout( ai )
{
	if ( !flag( "price_calls_out_enemy_location" ) )
		return;
		
	if ( gettime() < level.next_enemy_call_out )
		return;
	
	if ( !isalive( level.price ) )
		return;
	
	near_dist = level.callout_near_dist;

	// first try to find a guy outside the fov
	for ( i = 0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if ( !( guy cansee( level.player ) ) )
			continue;
		
		if ( guy.dot >= 0.2 ) 
			continue;
		
		if ( !( guy ai_is_near_teammates( near_dist ) ) )
			continue;

		price_calls_out_guy( guy );
		return;
	}

	// ok just call out whoever then
	for ( i = 0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if ( !( guy cansee( level.player ) ) )
			continue;

		if ( !( guy ai_is_near_teammates( near_dist ) ) )
			continue;

		guy = ai[ i ];
		price_calls_out_guy( guy );
		return;
	}
}

price_calls_out_guy( guy )
{
	if ( !flag( "price_cuts_to_woods" ) )
		return;
		
	
	triggers = getentarray( "incoming_trigger", "targetname" );
	enemy_location = "enemies";
	for ( i = 0; i < triggers.size; i++ )
	{
		if ( guy istouching( triggers[ i ] ) )
		{
			enemy_location = triggers[ i ].script_area;
			break;
		}
	}

	direction = animscripts\battlechatter::getDirectionCompass( level.player.origin, guy.origin );

	if ( direction == level.last_callout_direction )
		return;

	level.last_callout_direction = direction;
	
	level.next_enemy_call_out = gettime() + randomfloatrange( 4500, 6500 );
		
	// calls out enemy position
	level.price anim_single_queue( level.price, enemy_location + "_" + direction );
		
}

player_hit_debug()
{
	level.player endon( "death" );
	for ( ;; )
	{
		level.player waittill( "damage", amount, attacker, three, four, five, six, seven );
		if ( !isdefined( attacker ) )
			continue;
		 /#
		println( "Attacked by " + attacker getentnum() + " at distance " + distance( level.player.origin, attacker.origin ) + " with base accuracy  " + attacker.baseaccuracy + " and final accuracy " + attacker.finalaccuracy );
		#/ 
	}
}

delete_living()
{
	if ( isalive( self ) )
		self delete();
}

heli_attacks_start()
{
	heli = spawn_vehicle_from_targetname_and_drive( "heli_attacks_start" );
	heli helipath( heli.target, 70, 70 );
}

heli_trigger()
{
	helis = [];
	if ( isdefined( self.target ) )
	{
		self waittill( "trigger" );
	
		heli = spawn_vehicle_from_targetname_and_drive( self.target );
		helis[ helis.size ] = heli;
	}
	else
	{
		assertEx( isdefined( self.script_vehiclespawngroup ), "heli_trigger had no target or script_vehiclespawngroup" );
		level waittill( "vehiclegroup spawned" + self.script_vehiclespawngroup, spawnedVehicles );
		helis = spawnedVehicles;
	}

	for ( i = 0; i < helis.size; i++ )
	{
		heli = helis[ i ];
		heli helipath( heli.target, 30, 30 );
	}
}

block_path()
{
	// makes a blocker appear and block the path, then reconnect the path and disappear.
	// this lets you force an AI to pause before going into an area.
	assertex( isdefined( self.target ), "block_path at " + self.origin + " had no target" );
	blocker = getent( self.target, "targetname" );
	assertex( isdefined( blocker ), "block_path at " + self.origin + " had no target" );	
	
	blocker connectpaths();
	blocker notsolid();

	self waittill( "trigger" );
	blocker solid();
	blocker disconnectpaths();
	timer = 0.25;
	if ( isdefined( self.script_delay ) )
	{
		timer = self.script_delay;
	}
	
	wait( timer );
	blocker connectpaths();
	blocker delete();
}

get_patrol_anims()
{
	patrol_anims = [];
	patrol_anims[ 1 ] = "patrol_look_up_once";
	patrol_anims[ 2 ] = "patrol_360_once";
	patrol_anims[ 3 ] = "patrol_jog_once";
	patrol_anims[ 4 ] = "patrol_orders_once";
	return patrol_anims;
}

get_patrol_run_anims()
{
	patrol_anims = [];
	patrol_anims[ 1 ] = "patrol_look_up";
	patrol_anims[ 2 ] = "patrol_360";
	patrol_anims[ 3 ] = "patrol_jog";
	patrol_anims[ 4 ] = "patrol_orders";
	return patrol_anims;
}

patrol_guy()
{
	patrol_anims = get_patrol_anims();
	self.allowdeath = true;
	self set_generic_run_anim( "patrol_jog" );
	goalpos = getent( self.target, "targetname" );
	
	// start off with a start animation
	goalpos anim_generic_reach( self, patrol_anims[ self.script_index ] );
	self anim_generic( self, patrol_anims[ self.script_index ] );

	self.disableArrivals = true;

	targetent = getent( goalpos.target, "targetname" );
	self thread maps\_spawner::go_to_node( targetent, 1 );


	self endon( "death" );

	while ( !isdefined( self.enemy ) )
	{
		wait( 0.05 );
	}

	self.disableArrivals = false;

	delete_wounding_sight_blocker();
	
	animscripts\init::set_anim_playback_rate();
	self clear_run_anim();
	self.walkdist = 16;
	self.goalradius = 512;

	for ( ;; )
	{
		if ( isalive( self.enemy ) )
			self setgoalpos( self.enemy.origin );
		wait( 5 );
	}
}



delete_wounding_sight_blocker()
{
	if ( flag( "wounding_sight_blocker_deleted" ) )
		return;
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();
	flag_set( "wounding_sight_blocker_deleted" );
}

player_touches_wounded_blocker()
{
	if ( flag( "wounding_sight_blocker_deleted" ) )
		return;

	level endon( "wounding_sight_blocker_deleted" );		
	flag_wait( "player_touches_wounding_clip" );
	delete_wounding_sight_blocker();
}

countdown( timer )
{
	hudelem = createFontString( "default", 2 );
	hudelem.location = 0;
	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.foreground = 1;
	hudelem.sort = 20;
	hudelem.alpha = 1;
	hudelem.x = 40;
	hudelem.y = 40;
	
	
	countdown = 20 * 60;
	if ( isdefined( timer ) )
		countdown = timer * 60;
	
	hudelem.label = "Time Remaining: ";// + minutes + ":" + seconds
	hudelem settenthstimer( countdown );

	flag_wait_or_timeout( "beacon_placed", countdown );
	if ( !flag( "beacon_placed" ) )
	{
		setdvar( "ui_deadquote", "You failed to reach the evac point in time" );
		maps\_utility::missionFailedWrapper();
		return;
	}
	
	hudelem destroy();

// 	countdown = 4 * 60;
// 	hudelem settenthstimer( countdown );
}


defend_heat_area_until_enemies_leave()
{
	level endon( "heat_area_cleared" );
	price_death_org = getent( "price_death_org", "targetname" ).origin;
	flee_node = getnode( "enemy_flee_node", "targetname" );
	fight_distance = 1250;

	for ( ;; )
	{
		flag_set( "player_defends_heat_area" );
		thread defend_heat_area_until_player_goes_back( price_death_org, flee_node, fight_distance );

		// wait for the player to run back into the main heat area
		flag_waitopen( "stop_heat_spawners" );
		
		flag_clear( "player_defends_heat_area" );
		
		level notify( "player_goes_back_to_heat_area" );
		ai = getaiSpeciesArray( "axis", "all" );
		array_thread( ai, ::reacquire_player_pos );

		// wait for player to run back into the defend area
		wait_for_targetname_trigger( "heat_enemies_back_off" );
	}
}

defend_heat_area_until_player_goes_back( price_death_org, flee_node, fight_distance )
{
	level endon( "heat_area_cleared" );
	for ( ;; )
	{
		// price dies if left unattended before its time to move on
		thread price_heat_death();
		
		ai = getaiSpeciesArray( "axis", "all" );
		ai = get_array_of_closest( price_death_org, ai );

		max_fighters = 5;
		if ( ai.size < max_fighters )
			max_fighters = ai.size;
			
		// send all but the 5 closest that are within fight_distance fleeing
		for ( i = 0; i < max_fighters; i++ )
		{
			if ( distance( ai[ i ].origin, price_death_org ) > fight_distance )
			{
				ai[ i ] thread flee_heat_area( flee_node );
			}
		}
		
		for ( i = max_fighters; i < ai.size; i++ )
		{
			ai[ i ] thread flee_heat_area( flee_node );
		}
		
		/* 
		ai = get_outside_range( price_death_org.origin, ai, fight_distance );
		array_thread( ai, ::flee_heat_area, flee_node );
		for ( i = 5; i < ai.size; i++ )
		{
			// make only 5 of the 
			ai[ i ] thread flee_heat_area( flee_node );
		}
		*/ 
	
		wait_until_the_heat_defend_area_is_clear( price_death_org, fight_distance );
	}
}

wait_until_the_heat_defend_area_is_clear( price_death_org, fight_distance )
{
	for ( ;; )
	{
		wait( 1 );
		if ( distance( level.price.origin, price_death_org ) > 200 )
			continue;
		
		ai = getaiSpeciesArray( "axis", "all" );
		guy = get_closest_living( price_death_org, ai );
		if ( !isalive( guy ) )
		{
			flag_set( "heat_area_cleared" );
			return;
		}			
			
		if ( distance( guy.origin, price_death_org ) > fight_distance )
		{
			flag_set( "heat_area_cleared" );

			flee_node = getnode( "enemy_flee_node", "targetname" );
			array_thread( ai, ::flee_heat_area, flee_node );
			return;
		}
	}
}


flee_heat_area( flee_node )
{
	level endon( "player_goes_back_to_heat_area" );
	self notify( "stop_moving_in" );
	self notify( "stop_going_to_node" );
	self setgoalnode( flee_node );
	self.goalradius = 64;
	self endon( "death" );
	self waittill( "goal" );
	self delete();
}

price_heat_death()
{
	level endon( "heat_area_cleared" );
	 /#
	flag_assert( "heat_area_cleared" );
	#/ 

	trigger = getent( "price_aparment_death_trigger", "targetname" );
	for ( ;; )
	{
		flag_wait( "price_dies_unattended" );
		
		if ( !( level.price istouching( trigger ) ) )
		{
			kill_shielded_price();
			return;
		}
		flag_clear( "price_dies_unattended" );
	}
}

kill_shielded_price()
{
	level notify( "stop_updating_objective" );
	level.price stop_magic_bullet_shield();
	price_dies();
}

price_dies()
{
	if ( isalive( level.price ) )
		level.price dodamage( level.price.health + 150, ( 0, 0, 0 ) );
		
	setdvar( "ui_deadquote", "Cpt. MacMillan died!" );
	
	maps\_utility::missionFailedWrapper();
}

price_wounding_kill_trigger()
{
	level endon( "price_is_safe_after_wounding" );
	 /#
	flag_assert( "price_is_safe_after_wounding" );
	#/ 

	flag_wait( "player_leaves_price_wounding" );
	kill_shielded_price();
}

heli_shoots_rockets_at_price()
{
	target = getent( "wounding_target", "targetname" );
	attractor = missile_createAttractorEnt( target, 100000, 60000 );
// 	wait( 2 );
	self maps\_helicopter_globals::fire_missile( "mi28_seeker", 3, target, .75 );
	wait( 5 );
	missile_deleteAttractor( attractor );
	/* 
	self setVehWeapon( "cobra_seeker" );
	offset = ( 0, 0, 0 );
	self fireWeapon( "tag_store_L_2_a", target, offset );// tag_light_L_wing
	wait( 0.2 );
	self fireWeapon( "tag_store_L_2_b", target, offset );// tag_light_L_wing
	wait( 0.2 );
	self fireWeapon( "tag_store_L_2_c", target, offset );// tag_light_L_wing
	*/ 
}

kills_enemies_then_wounds_price_then_leaves()
{
	level endon( "price_was_hit_by_heli" );
	level.price thread price_heli_hit_detection();
	kill_all_visible_enemies();
	flag_set( "price_heli_moves_on" );

	self setturrettargetent( level.price );
// 	heli startfiring();
	heli_fires();
// 	wait_for_script_noteworthy_trigger( "price_exits_apartment" );
// 	wait( 2 );
// 	flag_set( "heli_attacks_price" );
}

heli_fires()
{
	self endon( "stop_firing_weapon" );
	for ( ;; )
	{
		self fireweapon();
		wait( 0.10 );
	}
}

price_heli_hit_detection()
{
	for ( ;; )
	{
		level.price waittill( "damage", amt, attacker );
		if ( isdefined( attacker ) && attacker == level.price_heli )
			break;
	}
	
	flag_set( "price_was_hit_by_heli" );
}

can_see_from_array( array )
{
	for ( i = 0; i < array.size; i++ )
	{
		if ( bullettracepassed( self.origin, array[ i ].origin + ( 0, 0, 64 ), false, self ) )
			return array[ i ];
	}
	
	return undefined;
}

remove_drivers_from_array( ai )
{
	array = [];
	for ( i = 0; i < ai.size; i++ )
	{
		if ( !isdefined( ai[ i ].drivingVehicle ) )
			array[ array.size ] = ai[ i ];
	}
	return array;
}

kill_all_enemies()
{
	ai = getaiarray( "axis" );
	array_thread( ai, ::die_soon );
}

kill_all_visible_enemies()
{
	for ( ;; )
	{
		ai = getaiarray( "axis" );
		ai = remove_drivers_from_array( ai );
		guy = can_see_from_array( ai );
		if ( !isalive( guy ) )
			return;

		guy thread die_soon();
		while ( isalive( guy ) )
		{
			self setturrettargetent( guy, randomvector( 15 ) + ( 0, 0, 16 ) );
			self fireweapon();
			wait( 0.15 );
		}
	}
}

kill_all_visible_enemies_forever()
{
	self endon( "stop_killing_enemies" );
	self endon( "death" );
	for ( ;; )
	{
		kill_all_visible_enemies();
		wait( 1 );
	}
}

die_soon()
{
	self endon( "death" );
	wait( 1.5 );
	self dodamage( self.health + 150, ( 0, 0, 0 ) );
}

array_remove_without_model( array, model )
{
	newarray = [];
	
	for ( i = 0; i < array.size; i++ )
	{
		if ( array[ i ].model == model )
			newarray[ newarray.size ] = array[ i ];
	}
	
	return newarray;
}

price_flees_grenades()
{
	grenades = getentarray( "grenade", "classname" );
	grenades = array_remove_without_model( grenades, "projectile_m67fraggrenade" );
	
	if ( !grenades.size )
		return;
		
	grenade = getClosest( level.price.origin, grenades );
	grenade_dist = 450;
	if ( distance( grenade.origin, level.price.origin ) > grenade_dist )
		return;

	old_org = ( 0, 0, 0 );
	
	// wait for the grenade to come to rest
	for ( ;; )
	{
		old_org = grenade.origin;
		wait( 0.05 );

		if ( !isdefined( grenade ) )
			return;
			
		if ( distance( grenade.origin, level.price.origin ) > grenade_dist )
			return;

		if ( grenade.origin == old_org )
			break;
			
		old_org = grenade.origin;
	}
	
	
	level.price notify( "stop_loop" );
	didanim = false;
	for ( ;; )
	{
		if ( !isdefined( grenade ) )
			break;
			
		forward = anglestoforward( level.price.angles );
		normal = vectorNormalize( grenade.origin - level.price.origin );
		dot = vectorDot( forward, normal );
		
		if ( dot > 0.2 )
			break;

		
		if ( level.price should_turn_right( grenade ) )
			thread price_turns_right(); // needs to be threaded for the wait
		else
			thread price_turns_left(); // needs to be threaded for the wait
			
		wait( 1 );
		
		didanim = true;
	}
	
	if ( isdefined( grenade ) )
	{
// 		level.price anim_single_solo( level.price, "wounded_crawl_start" );
		for ( ;; )
		{
			if ( !isdefined( grenade ) )
				break;
			
			if ( distance( grenade.origin, level.price.origin ) > grenade_dist )
				break;
				
			didanim = true;
			level.price anim_custom_animmode_solo( level.price, "gravity", "wounded_crawl" );
			insure_crawler_is_above_ground();
		}
		
// 		level.price anim_single_solo( level.price, "wounded_crawl_end" );
	}
	
	assertex( didanim, "Had to have done an anim by now!" );
	level.price thread anim_loop_solo( level.price, "wounded_idle" );
}

price_teleports()
{
	ent = spawn( "script_origin", level.price.origin );
	level.price linkto( ent );

	ent movez( 200, 10 );
	for ( ;; )
	{
		wait( 0.05 );
		if ( !should_teleport() )
			break;
	}
	ent delete();
}


insure_crawler_is_above_ground()
{
	if ( 1 )
		return;
		
	if ( should_teleport() )
	{
		level.price thread anim_loop_solo( level.price, "wounded_idle" );
		price_teleports();
	}
	else
	{
		return;
	}

	while ( should_teleport() )
	{
		price_teleports();
	}
	
	level.price notify( "stop_loop" );
	waittillframeend; // for the loop end
}



price_picks_target()
{
	if ( flag( "fair_hold_fire" ) )
		return false;
		
	level.callout_near_dist = 50000;
	
	// in case we're using a start point
	flag_set( "price_cuts_to_woods" );
	
	price_flees_grenades();
	
	/* 
	// put in better indexed array so we don't have to do a bunch of ifs later
	ai_array = [];
	for ( i = 0; i < ai.size; i++ )
	{
		ai_array[ ai[ i ].ai_number ] = ai[ i ];
	}
	*/ 

    price_forward = anglesToForward( ( 0, level.price.angles[ 1 ], 0 ) );

// 		ai = get_not_in_pain( ai );
	ai = getaiSpeciesArray( "axis", "all" );
	array = get_array_within_fov( level.price.origin, price_forward, ai, 0.707 );

	ai = array[ true ];
	outside_fov_ai = array[ false ];

	
	if ( !ai.size )
	{
		if ( outside_fov_ai.size > 0 )	
		{
			thread new_enemy_callout( outside_fov_ai );
			guy = outside_fov_ai[ 0 ];// the guy with the highest dot
			level.price notify( "stop_loop" );
			price_turns_towards_guy( guy );
			level.price thread anim_loop_solo( level.price, "wounded_idle", undefined, "stop_loop" );
		}
		return false;
	}

	ai = level.price get_cantrace_array( ai );
	
	if ( outside_fov_ai.size > 0 )
	{	
		thread new_enemy_callout( outside_fov_ai );
	}

	if ( !ai.size )
	{
		// price continues to aim at guys that are currently not in line of sight
		return false;
	}
		
	guy = getClosest( level.price.origin, ai );
	
	/* 
	ai_array[ guy.ai_number ] = undefined;
	keys = getarraykeys( ai_array );
	for ( i = 0; i < keys.size; i++ )
	{
		ai_array[ keys[ i ] ].ignoreme = true;
	}

	guy.ignoreme = false;
	*/ 


	thread price_targets_guy( guy );	
	return true;
}

price_targets_guy( guy )
{
	if ( isdefined( level.price.targetorg ) )
		level.price.targetorg delete();
	
	ent = spawn( "script_origin", ( 0, 0, 0 ) );
	ent linkto( guy, "TAG_EYE", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	level.price.targetorg = ent;
	level.price setentitytarget( ent );
//	level.price_target_point = guy geteye();
	ent endon( "death" );
	
	// cleanup on pickup / placement of price
	level.price waittill( "death" );
	ent delete();
}

price_turns_towards_guy( guy )
{
	/* 
	org = spawn( "script_origin", level.price.origin );
	angles = vectortoangles( guy.origin - level.price.origin );
	org.angles = ( 0, angles[ 1 ], 0 );
	org thread anim_loop_solo( level.price, "wounded_idle", undefined, "stop_loop" );
	wait( 0.5 );
	org notify( "stop_loop" );
	waittillframeend;
	org delete();
	*/ 
	
	if ( level.price should_turn_right( guy ) )
	{
		// turns_right
		price_turns_right();
	}
	else
	{
		// turns_left
		price_turns_left();
	}
}

should_turn_right( guy )
{
    right = anglesToright( ( 0, self.angles[ 1 ], 0 ) );
	normal = vectorNormalize( guy.origin - self.origin );
	return vectorDot( right, normal ) > 0;
}

get_not_in_pain( ai )
{
	guys = [];
	for ( i = 0; i < ai.size; i++ )
	{
		if ( ai[ i ] isdog() )
			guys[ guys.size ] = ai[ i ];
		else
		if ( ai[ i ].a.script != "pain" )
			guys[ guys.size ] = ai[ i ];
	}
	
	return guys;
}

greater_dot( guy, other )
{
	return guy.dot > other.dot;
}

lesser_dot( guy, other )
{
	return guy.dot < other.dot;
}

insert_in_array( array, guy, compare_func )
{
	newarray = [];
	
	inserted = false;
	for ( i = 0; i < array.size; i++ )
	{
		if ( !inserted )
		{
			if ( [[ compare_func ]]( array[ i ], guy ) )
			{
				newarray[ newarray.size ] = guy;
				inserted = true;
			}
		}
		
		newarray[ newarray.size ] = array[ i ];
	}
	
	if ( !inserted )
	{
		newarray[ newarray.size ] = guy;
	}
	
	return newarray;
}

get_array_within_fov( org, forward, ai, dot_range )
{
	guys = [];
	guys[ true ] = [];
	guys[ false ] = [];
	
	compare_dots[ true ] = ::lesser_dot;
	compare_dots[ false ] = ::lesser_dot;
	
	
	for ( i = 0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		normal = vectorNormalize( guy.origin - org );
		dot = vectorDot( forward, normal );
		
		guy.dot = dot;
		in_range = dot >= dot_range;
		
		guys[ in_range ] = insert_in_array( guys[ in_range ], guy, compare_dots[ in_range ] );
	}
		
	return guys;
}

line_for_time( pos1, pos2, color, timer )
{
	timer = timer * 20;
	
	for ( i = 0; i < timer; i++ )	
	{
		line( pos1, pos2, color );
		wait( 0.05 );
	}
}

get_cantrace_array( ai )
{
	guys = [];
	eyepos = self geteye();
	for ( i = 0; i < ai.size; i++ )
	{
		if ( !( bullettracepassed( eyepos, ai[ i ] geteye(), false, undefined ) ) )
		{
// 			thread line_for_time( eyepos, ai[ i ] geteye(), ( 1, 0, 0 ), 0.5 );
			continue;
		}
			
// 		thread line_for_time( eyepos, ai[ i ] geteye(), ( 0, 1, 0 ), 0.5 );
		guys[ guys.size ] = ai[ i ];
	}

	return guys;		
}

get_canshoot_array( ai )
{
	guys = [];
	myGunPos = self GetTagOrigin( "tag_flash" );
	myEyeOffset = ( self getShootAtPos() - myGunPos );
	
	for ( i = 0; i < ai.size; i++ )
	{
		if ( !( self canshoot( ai[ i ], myEyeOffset ) ) )
		{
// 			thread line_for_time( eyepos, ai[ i ] geteye(), ( 1, 0, 0 ), 0.5 );
			continue;
		}
			
// 		thread line_for_time( eyepos, ai[ i ] geteye(), ( 0, 1, 0 ), 0.5 );
		guys[ guys.size ] = ai[ i ];
	}

	return guys;		
}

get_cansee_array( ai )
{
	guys = [];
	for ( i = 0; i < ai.size; i++ )
	{
		if ( !( self cansee( ai[ i ] ) ) )
			continue;
			         
		guys[ guys.size ] = ai[ i ];
	}

	return guys;		
}

price_moves_to_sniping_position()
{
	price_gnoll = getent( "price_gnoll", "targetname" );
	org = price_gnoll.origin;

	level.price notify( "stop_loop" );
	
	for ( ;; )
	{			
		forward = anglestoforward( level.price.angles );
		normal = vectorNormalize( org - level.price.origin );
		dot = vectorDot( forward, normal );
		
		if ( dot > -0.7 )
		{
			if ( level.price should_turn_right( price_gnoll ) )
				price_turns_left();
			else
				price_turns_right();
		}
		else
		{
			if ( distance( level.price.origin, org ) > 32 )
			{
				level.price anim_custom_animmode_solo( level.price, "gravity", "wounded_crawl" );
				insure_crawler_is_above_ground();
			}
			else
				break;
		}
	}	

	park_reinforce = getent( "park_reinforce", "targetname" );
	price_aims_at( park_reinforce.origin );

	for ( ;; )
	{
		forward = anglestoforward( level.price.angles );
		normal = vectorNormalize( park_reinforce.origin - level.price.origin );
		dot = vectorDot( forward, normal );
		
		if ( dot < 0.7 )
		{
			if ( level.price should_turn_right( park_reinforce ) )
				price_turns_right();
			else
				price_turns_left();
		}
		else
			break;
	}

	forward = anglestoforward( level.price.angles );
	normal = vectorNormalize( park_reinforce.origin - level.price.origin );
	dot = vectorDot( forward, normal );
//	thread line_for_time( park_reinforce.origin, level.price.origin, ( 1, 0, 0.5 ), 3 );
	
	// can't do loop stop loop, which may happen if he's put on the right spot at the right angle
	waittillframeend;
	
	level.price thread anim_loop_solo( level.price, "wounded_idle", undefined, "stop_loop" );
	flag_clear( "price_moves_to_position" );
}

price_aims_at( org )
{
	if ( !isdefined( level.price.targetorg ) )
	{
		ent = spawn( "script_origin", ( 0, 0, 0 ) );
		level.price.targetorg = ent;
	}
	
	level.price.targetorg.origin = org;
}

price_turns_right()
{
	level.price anim_custom_animmode_solo( level.price, "gravity", "wounded_turn_right" );
//	level.price anim_single_solo( level.price, "wounded_turn_right" );
}

price_turns_left()
{
	level.price anim_custom_animmode_solo( level.price, "gravity", "wounded_turn_left" );
//	level.price anim_single_solo( level.price, "wounded_turn_left" );
}
		
idle_until_price_has_target()
{
	level.price endon( "death" );
	level.price notify( "stop_loop" );
	// he may be looping from turning during the pick - target phase, so we need to make sure that loop has stopped before we start a new one
	waittillframeend;
	
	level.price thread anim_loop_solo( level.price, "wounded_idle", undefined, "stop_loop" );
	
//	price_floats_up_out_of_solid();

	for ( ;; )
	{
		if ( price_picks_target() )
			break;
		
		if ( flag( "price_moves_to_position" ) )
		{
			price_moves_to_sniping_position();
			continue;
		}
		wait( 0.1 );
	}
}

should_teleport()
{
	org = physicstrace( level.price.origin + ( 0, 0, 2 ), level.price.origin + ( 0, 0, -20 ) );
	return org[ 2 ] > level.price.origin[ 2 ];
}

price_floats_up_out_of_solid()
{
	level.price endon( "death" );
	level.price endon( "pickup" );
	
	teleported = false;
	for ( ;; )
	{
		if ( !should_teleport() )
			break;
			
		teleported = true;
		price_teleports();
	}

	// one more time just to be sure	
	if ( teleported )
		price_teleports();
}


fight_until_price_has_no_target()
{
	level.price endon( "death" );
	level.price endon( "no_enemies" );
	for ( ;; )
	{
		thread price_fights_enemies();
		level.price waittill( "damage", amount, enemy, dir1, dir2, damage_type );
		
		level.price notify( "stop_loop" );
		if ( enemy.team == "axis" && damage_type == "MOD_RIFLE_BULLET" )
		{
			price_fends_off_attacker( enemy );
		}

		
		level.price notify( "stop_loop" ); // can endon enemy death above
		waittillframeend;
		level.price thread anim_loop_solo( level.price, "wounded_idle", undefined, "stop_loop" );
	}
}

line_to_guy( enemy )
{
	level.price endon( "death" );
	enemy endon( "death" );
	
	for ( ;; )
	{
		line( level.price geteye(), enemy geteye(), ( 1, 0, 1 ) );
		wait( 0.05 );
	}
}

price_fends_off_attacker( enemy )
{
	if ( !isalive( enemy ) )
		return;
	enemy endon( "death" );
//	thread line_to_guy( enemy );

	for ( ;; )
	{	
		forward = anglestoforward( level.price.angles );
		normal = vectorNormalize( enemy.origin - level.price.origin );
		dot = vectorDot( forward, normal );
		
		if ( dot < 0.8 )
		{
			if ( level.price should_turn_right( enemy ) )
				thread price_turns_right();
			else
				thread price_turns_left();
			wait( 1.2 );
			continue;
		}
		
		thread price_targets_guy( enemy );


		if ( !level.price.on_target )
		{
			waittillframeend;
			level.price thread anim_loop_solo( level.price, "wounded_idle", undefined, "stop_loop" );
			level.price waittill_notify_or_timeout( "on_target", 0.5 );
			level.price notify( "stop_loop" );
		}
		
		if ( level.price.on_target )
		{
			myGunPos = level.price GetTagOrigin( "tag_flash" );
			myEyeOffset = ( level.price getShootAtPos() - myGunPos );
			
			if ( level.price canshoot( level.price.targetorg.origin, myEyeOffset ) )
			{
				level.price anim_single_solo( level.price, "wounded_fire" );
			}
			else
			{
				level.price anim_custom_animmode_solo( level.price, "gravity", "wounded_crawl" );
				insure_crawler_is_above_ground();
			}
		}
	}	
}

price_fights_enemies()
{
	level.price endon( "death" );
	level.price endon( "damage" );
	level.price endon( "pickup" );

	for ( ;; )
	{
		// keep shooting as long as we can acquire a target
		level.price waittill_notify_or_timeout( "on_target", 2 );

		timer = distance( level.price.targetorg.origin, level.price.origin );
		timer -= 400;
		timer *= 0.004;
		if ( timer < 0.15 )
			timer = 0.15;

		if ( !level.price.fastfire )
		{
			wait( randomfloatrange( timer * 0.75, timer ) );
		}
		level.price.fastfire = false;
		
		if ( gettime() < level.price.first_shot_time )
		{
			// wait until we're allowed to shoot
			wait( ( level.price.first_shot_time - gettime() ) * 0.001 );
		}
		
		if ( level.price.on_target )
		{
			myGunPos = level.price GetTagOrigin( "tag_flash" );
			myEyeOffset = ( level.price getShootAtPos() - myGunPos );
			
			if ( level.price canshoot( level.price.targetorg.origin, myEyeOffset ) )
			{
				// dont hit guys you cant shoot
				level.price notify( "stop_loop" );
		
				level.price anim_single_solo( level.price, "wounded_fire" );
		
				level.price thread anim_loop_solo( level.price, "wounded_idle", undefined, "stop_loop" );
			}
		}

		if ( !price_picks_target() )
			break;
	}
	
	level.price notify( "no_enemies" );
}



area_is_clear( org, debug_lines )
{
	steps = 6;
	chunks = 360 / steps;
	for ( i = 0; i < steps; i++ )
	{
		angles = ( - 25, i * chunks, 0 );
		forward = anglestoforward( angles );
		endpos = org + vectorscale( forward, 25 );
		if ( PhysicsTrace( org, endpos ) != endpos )
		{
			 /#
			if ( debug_lines )
				line( org, endpos, ( 1, 0, 0 ) );
			#/ 
			return false;
		}
		 /#
		if ( debug_lines )
			line( org, endpos, ( 0, 1, 0 ) );
		#/ 
	}
	return true;
}

upwards_normal( normal )
{
	range = 0.25;
	if ( abs( normal[ 0 ] ) > range )
		return false;
	if ( abs( normal[ 1 ] ) > range )
		return false;
	return( normal[ 2 ] >= 1 - range );
}


wait_for_player_to_drop_price( trigger )
{
	for ( ;; )
	{
		wait_for_player_to_drop_price_func( trigger );
		return;
	}
}

wait_for_player_to_drop_price_func( trigger )
{
	trigger endon( "trigger" );
	price_gnoll = getent( "price_gnoll", "targetname" );
		
	for ( ;; )
	{
		debug_lines = false;
		 /#
		debug_lines = getdebugdvar( "debug_drop_price" ) == "on";
		#/ 
		trigger.origin = ( 0, 0, -1500 );
		
		
		eyepos = level.player geteye();
		angles = level.player getplayerangles();
		pitch = angles[ 0 ] + 15;
		if ( pitch > 54 )
			pitch = 54;
		if ( pitch < 40 )
			pitch = 40;
		level.pitch = pitch;
		angles = ( pitch, angles[ 1 ], 0 );
		forward = anglestoforward( angles );
		endpos = eyepos + vectorscale( forward, 500 );
		
		trace = bullettrace( eyepos, endpos, true, level.player );
		p_trace = physicsTrace( eyepos, endpos );
		level.price_trace = p_trace;

		if ( p_trace != trace[ "position" ] )
		{
			 /#
			if ( debug_lines )
				print3d( trace[ "position" ], ".", ( 0.8, 0.6, 0 ), 1, 2 );
			#/ 
				
			wait( 0.05 );
			continue;
		}

		if ( distance( level.player.origin, p_trace ) > 100 )
		{
			 /#
			if ( debug_lines )
				print3d( p_trace, ".", ( 1, 0.5, 0 ), 1, 2 );
			#/ 
				
			wait( 0.05 );
			continue;
		}
		
		if ( !upwards_normal( trace[ "normal" ] ) )
		{
			 /#
			if ( debug_lines )
				print3d( p_trace, ".", ( 1, 0, 0 ), 1, 2 );
			#/ 
			wait( 0.05 );
			continue;
		}
		
		if ( !area_is_clear( p_trace, debug_lines ) )
		{
			 /#
			if ( debug_lines )
				print3d( p_trace, ".", ( 1, 1, 0 ), 1, 2 );
			#/ 
			wait( 0.05 );
			continue;
		}

/*
		if ( flag( "to_the_pool" ) )
		{
			if ( distance( level.player.origin, price_gnoll.origin ) > level.price_gnoll_dist )
			{
				// too far from the place where we put him down
				wait( 0.05 );
				continue;
			}
		}
*/
		level.price_drop_point = p_trace;
		trigger.origin = level.player.origin;

		 /#
		if ( debug_lines )
			print3d( trace[ "position" ], ".", ( 0, 1, 0 ), 1, 2 );
		#/ 
		wait( 0.05 );
	}
}



price_wounded_logic()
{
	level.price stop_magic_bullet_shield();
	level.price thread wounded_setup();

	for ( ;; )
	{
		price_defends_his_spot_until_he_is_picked_up();
		player_carries_price_until_he_drops_him();
	}
}

price_updates_objective_pos()
{
	level.price endon( "death" );
	
	if ( !flag( "beacon_ready" ) )
		objective_position( 1, level.price.origin );
}


price_defends_his_spot_until_he_is_picked_up()
{
	thread price_updates_objective_pos();
	thread price_dies_if_player_goes_too_far();
	thread player_loses_if_price_dies();
//	thread price_calls_out_kills();
	thread price_decides_if_he_can_be_picked_up();
	level.price thread price_aims_at_his_enemy();
	
	level.price endon( "pickup" );
	level.price endon( "death" );
	
	price_slides_into_proper_putdown_position();
	
	for ( ;; )
	{
		idle_until_price_has_target();
		fight_until_price_has_no_target();
	}
}

price_slides_into_proper_putdown_position()
{
	if ( !isdefined( level.price_drop_point ) )
		return;
		
	ent = spawn( "script_origin", (0,0,0) );
	ent.origin = level.price.origin;
	level.price linkto( ent );
	
	level.price thread anim_first_frame_solo( level.price, "wounded_idle_reach" );
	
	ent moveto( level.price_drop_point, 0.5, 0.2, 0.2 );
	level.price_drop_point = undefined;
	wait( 0.5 );
	ent delete();
	level.price notify( "stop_first_frame" );
}

price_decides_if_he_can_be_picked_up()
{
	level.price endon( "death" );
	next_dialogue = 0;
	
	for ( ;; )
	{
		level.price waittill( "trigger" );
		if ( flag( "price_wants_apartment_cleared" ) && !flag( "apartment_cleared" ) )
		{
			if ( gettime() > next_dialogue )
			{
				next_dialogue = gettime() + 5000;
				thread add_dialogue_line( "MacMillan", "Wait, make sure these rooms are clear first." );
			}
			continue;
		}
		break;
	}
	
	level.price notify( "pickup" );
}

price_aims_at_his_enemy()
{
	level endon( "price_picked_up" );
	level.price endon( "death" );
	left = level.price getanim( "wounded_aim_left" );
	right = level.price getanim( "wounded_aim_right" );
	wounded = level.price getanim( "wounded_base" );
	self setanim( wounded, 1, 0, 1 );

	prevyaw = 0;
	/* 
	for ( ;; )
	{
		for ( i = 0; i < 1; i += 0.05 )
		{
			self setAnim( left, i, .05 );
			self setAnim( right, 1 - i, .05 );
			wait( 0.05 );
		}
		for ( i = 0; i < 1; i += 0.05 )
		{
			self setAnim( right, i, .05 );
			self setAnim( left, 1 - i, .05 );
			wait( 0.05 );
		}
	}
	*/ 
	for ( ;; )
	{
// 		if ( !isalive( self.enemy ) )
		if ( !isdefined( level.price.targetorg ) )
		{
			wait( 0.05 );
			continue;
		}
	
// 		pos = level.player.origin;	
		pos = level.price.targetorg.origin;
// 		aimyaw = self getYawToEnemy();
		aimyaw = GetYawToSpot( pos );
		
		diff = AngleClamp180( aimyaw - prevyaw );
		level.price.on_target = abs( diff ) <= 3;
		
		if ( level.price.on_target )
		{
			level.price notify( "on_target" );
		}
		else
		{
			diff = sign( diff ) * 3;
		}
		
		aimyaw = AngleClamp180( prevyaw + diff );

		// the animations cover from - 45 to 45 degrees		
		if ( aimyaw < - 45.0 )
			aimyaw = -45.0;
		if ( aimyaw > 45.0 )
			aimyaw = 45.0;

// 		level.aimyaw = aimyaw;

		weight = aimyaw / 90;

		// now the weight is 0 to 1
		weight += 0.5;

// 		level.weight = weight;	
		self setAnim( left, 1 - weight, 0.05 );
		self setAnim( right, weight, 0.05 );
		
		prevyaw = aimyaw;
		
		wait .05;
	}
	
}

price_calls_out_kills()
{
	level.price endon( "death" );
	level.price endon( "pickup" );
	for ( ;; )
	{
		if ( isalive( level.price.enemy ) )
		{
			enemy = level.price.enemy;
			price_waits_for_enemy_death_or_new_enemy();
			
			price_calls_out_kill_if_he_should( enemy );
		}
		else
		{
			level.price waittill( "enemy" );
		}
	}
}

price_waits_for_enemy_death_or_new_enemy()
{
	level.price endon( "enemy" );
	level.price.enemy waittill( "death", one, two, three, four );
	arg = 23;
}

price_calls_out_kill_if_he_should( enemy )
{
	// must've got a new enemy, old one is still alive
	if ( isalive( enemy ) )
		return;
		
	// he's already talking about something else so skip the kill call out
	if ( isdefined( level.price._anim_solo_queue ) )
		return;
	
	// dont call out deleted guys
	if ( !isdefined( enemy ) )
		return;
	price_calls_out_a_kill();
	wait( 2 );
}

price_calls_out_a_kill()
{
	if ( !isalive( level.price ) )
		return;
		
	lines = [];
	
	// got one
	lines[ lines.size ] = "got_one";

	// tango down
	lines[ lines.size ] = "tango_down";
	
	// he's down
	lines[ lines.size ] = "he_is_down";
	
	if ( level.last_price_kill + 10000 > gettime() )
	{	
		// got another one
		lines[ lines.size ] = "got_another";
	}
	
	// Target neutralized.	
	lines[ lines.size ] = "target_neutralized";
	
	// got him
	lines[ lines.size ] = "got_him";

	the_line = random( lines );
	level.last_price_kill = gettime();
	level.price thread anim_single_queue( level.price, the_line );
}

player_loses_if_price_dies()
{
	level.price endon( "pickup" );
	level.price waittill( "death" );
	price_dies();
}

price_dies_if_player_goes_too_far()
{
	if ( flag( "price_can_be_left" ) )
		return;
		
	flag_wait( "first_pickup" );

	level endon( "price_can_be_left" );
	
	level.price endon( "death" );
	level.price endon( "pickup" );
	
	for ( ;; )
	{
		if ( distance( level.player.origin, level.price.origin ) > 1000 )
		{
			break;
		}
		wait( 1 );
	}

	// Leftenant Price! Don't get too far ahead.	
	level.price anim_single_queue( level.price, "dont_go_far" );
	
	for ( ;; )
	{
		if ( distance( level.player.origin, level.price.origin ) > 1500 )
		{
			price_dies();
			return;
		}
		wait( 1 );
	}
	

}

draw_player_viewtag()
{
	for ( ;; )
	{
		maps\_debug::drawArrow( level.player.origin, level.player getplayerangles() );
		wait( 0.05 );
	}
}

drop_to_floor()
{
	trace = bullettrace( self.origin + ( 0, 0, 32 ), self.origin, false, undefined );
	self.origin = trace[ "position" ];
}

player_picks_up_price()
{
	level notify( "price_stops_thinking" );
	
	if ( !flag( "first_pickup" ) )
	{
		// If we run into trouble, you’ll have to find a good spot to put me down so I can cover you.
		thread radio_dialogue_queue( "find_good_spot" );
			
		// We've got to head for the extraction point! Move!	
		thread radio_dialogue_queue( "head_for_extract" );
	}

	
	level.price notify( "stop_loop" );
	org = spawn( "script_origin", ( 0, 0, 0 ) );
	org.origin = level.price.origin;
	org.angles = level.price.angles;
	
	org drop_to_floor();
	
	// this is the player's rig for the sequence
	model = spawn_anim_model( "player_carry" );
	model hide();

	// price idles while he waits to be picked up
	org thread anim_loop_solo( level.price, "pickup_idle", undefined, "stop_idle" );

	// put the model in the first frame so the tags are in the right place
	org anim_first_frame_solo( model, "wounded_pickup" );

	wait( 0.1 );// wait for the models tags to actually get in position	

	// move the animation up if it would put the player in the ground
	tag_player_origin = model getTagOrigin( "tag_player" );
	trace = bullettrace( tag_player_origin + ( 0, 0, 32 ), tag_player_origin, false, undefined );
	if ( trace[ "fraction" ] < 1 )
	{
		org.origin += trace[ "position" ] - tag_player_origin;
	
		// change the model's position to the new, not stuck in ground position
		model set_start_pos( "wounded_pickup", org.origin, org.angles );
	}
	
	// this smoothly hooks the player up to the animating tag
	model lerp_player_view_to_tag_and_hit_geo( "tag_player", 0.4, 1.0, 0, 0, 0, 0 );

	original_player_org = level.player.origin;

	// move the model arms and price's scene org to compensate for the distance the player is from where he should be	
	dif = level.player.origin - model gettagorigin( "tag_player" );
	model.origin += dif;
	org.origin += dif;

	// link the player without hit_geo, so he can duck down to pick up price
	level.player playerlinkto( model, "tag_player", 0.5, 1.0, 0, 0, 0, 0 );

	model show();
	
	org notify( "stop_idle" );

	price_pickup_elements = [];
	price_pickup_elements[ price_pickup_elements.size ] = model;
	price_pickup_elements[ price_pickup_elements.size ] = level.price;
	
	if ( !flag( "first_pickup" ) )
	{
		flag_set( "first_pickup" );
	}
	else
	{
		thread price_talks_as_he_is_picked_up();
	}
//	timer = gettime();
	org thread anim_single( price_pickup_elements, "wounded_pickup" );
	wait( 2.0 );
	org notify( "wounded_pickup" );
//	println( "result " + ( gettime() - timer ) );

	trace = bullettrace( level.player.origin + ( 0, 0, 32 ), level.player.origin, false, undefined );
	if ( trace[ "fraction" ] < 1 )
	{
		model moveto( model.origin + ( trace[ "position" ] - level.player.origin ), 0.1 );
		wait( 0.1 );
	}
	
	level.player unlink();
	org delete();
	model delete();
	
	level.player setorigin( original_player_org );

}

player_puts_down_price()
{
	
	level.price notify( "stop_loop" );
	org = spawn( "script_origin", ( 0, 0, 0 ) );
// 	price_spawner.origin = level.price_trace[ "position" ];
//	org.origin = level.price_trace;
	org.origin = level.player.origin;
	org.angles = level.player.angles;
	
	org drop_to_floor();	
	
	// this is the player's rig for the sequence
	model = spawn_anim_model( "player_carry" );
	model hide();

	// put the model in the first frame so the tags are in the right place
	org anim_first_frame_solo( model, "wounded_putdown" );

	wait( 0.1 );// wait for the models tags to actually get in position	

	// move the animation up if it would put the player in the ground
	tag_player_origin = model getTagOrigin( "tag_player" );
	trace = bullettrace( tag_player_origin + ( 0, 0, 32 ), tag_player_origin, false, undefined );
	if ( trace[ "fraction" ] < 1 )
	{
		org.origin += trace[ "position" ] - tag_player_origin;
	
		// change the model's position to the new, not stuck in ground position
		model set_start_pos( "wounded_putdown", org.origin, org.angles );
	}
	
	// this smoothly hooks the player up to the animating tag
	model lerp_player_view_to_tag_and_hit_geo( "tag_player", 0.25, 1.0, 0, 0, 0, 0 );
	model show();
	

	original_player_org = level.player.origin;

	price_spawner = getent( "price_spawner", "targetname" );

	price_spawner.animname = "price";
	price_spawner set_start_pos( "wounded_putdown", org.origin, org.angles );
	
	price_spawner.count = 1;

	level.price = price_spawner stalingradspawn();
	spawn_failed( level.price );
	level.price.animname = "price";
	level.price thread wounded_setup();
	

	price_pickup_elements = [];
	price_pickup_elements[ price_pickup_elements.size ] = model;
	price_pickup_elements[ price_pickup_elements.size ] = level.price;
	
	thread price_talks_as_he_is_picked_up();


	// link the player without hit_geo, so he can duck down to put down price
	level.player playerlinkto( model, "tag_player", 0.5, 1.0, 0, 0, 0, 0 );
	
	org anim_single( price_pickup_elements, "wounded_putdown" );

	/* 
	trace = bullettrace( level.player.origin + ( 0, 0, 32 ), level.player.origin, false, undefined );
	if ( trace[ "fraction" ] < 1 )
	{
		// push the player up if he's in the ground
		model moveto( model.origin + ( trace[ "position" ] - level.player.origin ), 0.1 );
		wait( 0.1 );
	}
	*/ 
	
	level.player unlink();
	org delete();
	model delete();

	level.player allowCrouch( true );
	level.player allowProne( true );
	level.player allowsprint( true );
	level.player allowjump( true );

	level.player setorigin( original_player_org );

	flag_clear( "price_picked_up" );
	level notify( "price_dropped" );
	
	thread price_asks_to_be_picked_up_when_its_safe();
}

getHealthyEnemies()
{
	ai = getaiSpeciesArray( "axis", "all" );
	
	healthy_enemies = [];
	for ( i = 0; i < ai.size; i++ )
	{
		if ( isdefined( ai[ i ].drivingVehicle ) )
			continue;
		
		if ( !ai[ i ].ignoreForFixedNodeSafeCheck )
		{
			healthy_enemies[ healthy_enemies.size ] = ai[ i ];
			break;
		}
	}
	
	return healthy_enemies;
}

price_asks_to_be_picked_up_when_its_safe()
{
	level endon( "price_picked_up" );
	level endon( "price_wants_apartment_cleared" );
	
	// wait until there are enemies, otherwise assume the player
	// dropped us for a reason
	for ( ;; )
	{
		ai = getHealthyEnemies();
		if ( ai.size )
		{
			break;
		}
		
		wait( 1 );
	}
	
	wait( 3 );
	
	for ( ;; )
	{
		ai = getHealthyEnemies();
		if ( !ai.size )
		{
			break;
		}

		wait( 1 );
	}
	
	wait( 2 );
	price_asks_to_be_picked_up();
}

price_talks_as_he_is_picked_up()
{
	// Easy does it…	
	// Easy now…	
	// Careful…	
	if ( randomint( 100 ) > 10 )
		return;
		
	putdown_line = "put_down_" + ( randomint( 3 ) + 1 );
	if ( isalive( level.price ) )
	{
		level.price anim_single_queue( level.price, putdown_line );
	}
}

price_talks_if_player_takes_damage()
{
	level endon( "price_dropped" );
	for ( ;; )
	{
		level.player waittill( "damage" );

		// You'd better put me down quick so I can fight back…	
		radio_dialogue_queue( "put_me_down_quick" );
		wait( 4 );
	}

}

price_talks_if_enemies_get_near()
{
	level endon( "price_dropped" );
	
	for ( ;; )
	{
		ai = getaispeciesarray( "axis", "all" );
		for ( i = 0; i < ai.size; i++ )
		{
			guy = ai[ i ];
			if ( !isalive( guy ) )
				continue;

			if ( !isalive( guy.enemy ) )
				continue;
			
			if ( guy cansee( level.player ) )
			{
				price_asks_to_be_put_down();
			}
			
			wait( 0.05 );
		}
		
		wait( 0.05 );
	}
}

price_talks_if_enemies_are_near()
{
	level endon( "price_dropped" );
	for ( ;; )
	{
		level waittill( "an_enemy_shot", guy );
		if ( !isalive( guy ) )
			continue;
		if ( guy cansee( level.player ) )
		{
			price_asks_to_be_put_down();
		}
	}
}

price_asks_to_be_put_down()
{
	if ( isalive( level.price ) )
		return;
		
	// Price! Put me down where I can cover you!	
	// Oi! Sit me down where I can cover your back!	
	// put_me_down_1, put_me_down_2
	// " + randomint( 2 ) + 1
	
	
	lines = [];
	// Tangos moving in! Find a spot where I can cover you and put me down!
	lines[ lines.size ] = "new_put_me_down_1" ;

	// Enemy troops approaching. Find a spot where I can cover you and put me down.
	lines[ lines.size ] = "new_put_me_down_2" ;
	
	// Enemies closing in. Put me in a good spot where I can cover you.
	lines[ lines.size ] = "new_put_me_down_3" ;
	
	// Tangos closing fast! Put me in a good spot to cover you!
	lines[ lines.size ] = "new_put_me_down_4" ;

	if ( !isdefined( level.lastputdownline ) )
		level.lastputdownline = 0;

	dialogue_line = randomint( lines.size );
	if ( dialogue_line == level.lastputdownline )
		dialogue_line++;
	if ( dialogue_line >= lines.size )
		dialogue_line = 0;
		
	level.lastputdownline = dialogue_line;
	radio_dialogue_queue( lines[ dialogue_line ] );
	
/*	
	// old dialogue
	if ( cointoss() )
		radio_dialogue_queue( "put_me_down_1" );
	else
		radio_dialogue_queue( "put_me_down_2" );
*/
		
	wait( 6 );
}

wounded_combat_trigger()
{
	self waittill( "trigger" );
	targets = getentarray( self.target, "targetname" );
	
	if ( !targets.size )
		return;
	
	wait( 1.35 );
// 	price_asks_to_be_put_down();
	price_talks_if_enemies_get_near();

}

player_carries_price_until_he_drops_him()
{
	level.player.dogs_dont_instant_kill = true;
	level.price notify( "price_stops_aiming" );
	set_objective_pos_to_extraction_point();
	level.player SetMoveSpeedScale( 0.85 );

	if ( !isalive( level.price ) )
	{
		// we can get here by price dying
		level waittill( "forever and ever" );
	}
	
		
	level.player thread take_weapons();

	level.player allowCrouch( false );
	level.player allowProne( false );
	level.player allowsprint( false );
	level.player allowjump( false );

	 /#
	if ( getdvar( "devtest" ) == "1" )
	{
		// so boring without! hmmmm
		level.player allowsprint( true );
		level.player allowjump( true );
	}
	#/ 

		
	player_picks_up_price();// relative
	flag_set( "price_picked_up" );

	// poof!
	level.price delete();
	
// 	thread price_talks_if_player_takes_damage();
// 	thread price_talks_if_enemies_are_near();
	
// 	level.player thread take_away_player_ammo();
// 	level.player hideviewmodel();
	
	trigger = getent( "price_drop_trigger", "targetname" );
	trigger sethintstring( "Hold &&1 to put Cpt. MacMillan down." );
	wait_for_player_to_drop_price( trigger );
	trigger.origin = ( 0, 0, -1500 );


// 	level.player give_back_player_ammo();
// 	level.player showviewmodel();

	player_puts_down_price();

	
	if ( !isalive( level.price ) )
	{
		price_dies();
		level waittill( "foreverevervever" );
	}
	 
	level.player give_back_weapons();
	level.player SetMoveSpeedScale( 1 );
	level.player.dogs_dont_instant_kill = undefined;
}    
     
give_back_weapons()
{
	self enableweapons();
	if ( 1 ) return;
	level.player notify( "stop_taking_away_ammo" );
	weapons = self.heldweapons;
	for ( i = 0; i < weapons.size; i++ )
	{
		weapon = weapons[ i ];
		self giveweapon( weapon );
		self SetWeaponAmmoClip( weapon, self.stored_ammo[ weapon ] );
	}
}

take_weapons()
{
	self disableweapons();
	if ( 1 ) return;
	self endon( "stop_taking_away_ammo" );	
	self.heldweapons = self getweaponslist();
	self.stored_ammo = [];
	for ( i = 0; i < self.heldweapons.size; i++ )
	{
		weapon = self.heldweapons[ i ];
		self.stored_ammo[ weapon ] = self getWeaponAmmoClip( weapon );
	}

	for ( ;; )
	{
		self takeallweapons();
		wait( 0.05 );
	}
}

take_away_player_ammo()
{
	self endon( "stop_taking_away_ammo" );	
	for ( ;; )
	{
		weapons = self getweaponslistprimaries();
		for ( i = 0; i < weapons.size; i++ )
		{
			self setweaponammoclip( weapons[ i ], 0 );
		}
		wait( 0.05 );
	}
}

give_back_player_ammo()
{
	weapons = self getweaponslistprimaries();
	for ( i = 0; i < weapons.size; i++ )
	{
		self givestartammo( weapons[ i ] );
	}
}


wounded_setup()
{
	level.last_callout_direction = "";
	level.next_enemy_call_out = 0;
// 	level.price.threatbias = 50000;
	level.price.allowpain = false;
//	level.price setcandamage( false );
	
	level.price.first_shot_time = gettime() + 2200;

	level.price.deathanim = level.price getanim( "wounded_death" );
	level.price.baseaccuracy = 1000;
	level.price animscripts\shared::placeWeaponOn( "m14_scoped", "right" );
	
	// so he doesn't shoot straight down the gun
	level.price.dontShootStraight = true;
	level.price.health = 134123;// 750;
	level.price.allowdeath = true;
	level.price thread regen();

	level.price sethintstring( "Hold &&1 to pick up Cpt. MacMillan" );
	
	level.price setthreatbiasgroup( "price" );
	level.price setgoalpos( level.price.origin );
	
	level.price.fastfire = false;
	
	if ( flag( "faiground_battle_begins" ) )
		thread fairground_price_adjustment();

	level.price endon( "death" );
	for ( ;; )
	{
		flag_wait( "can_manage_price" );
		level.price.useable = true;
		flag_waitopen( "can_manage_price" );
		level.price.useable = false;
	}
		
}

fairground_price_adjustment()
{
	level.price endon( "death" );
//	level.price thread stealth_ai();
	level.price thread maps\_stealth_logic::friendly_logic();
	flag_wait( "fairbattle_high_intensity" );
	level.price.threatbias = -15000;
	level.price.ignoreme = false;
}


regen()
{
	self endon( "death" );
	for ( ;; )
	{
		self waittill( "damage" );
		thread regenner();
	}
}

regenner()
{
	self endon( "death" );
	self endon( "damage" );
	wait( 5 );
	self.health = 134123;// 750;
}

price_fires( price )
{
	// price calls this function from a notetrack when he shoots
// 	MagicBullet( level.price.weapon, level.price gettagorigin( "tag_flash" ), level.price_target_point );
	
// 	animscripts\utility::shootEnemyWrapper_normal();

	self.a.lastShootTime = gettime();
	self shoot( 0.25, level.price.targetorg.origin ); // + randomvector( 7 ) );
}

enemy_spawn_zone()
{
	assertex( isdefined( self.script_linkto ), "Zone trigger at " + self.origin + " had no script linkto" );
	targets = strtok( self.script_linkto, " " );
	array = [];
	for ( i = 0; i < targets.size; i++ )
	{
		spawner = getent( targets[ i ], "script_linkname" );
		if ( isdefined( spawner ) )
		{
			array[ array.size ] = spawner;
		}
	}
	
	self.zone_spawners = array;
	
	// figure out which zone is the correct zone
	for ( ;; )
	{
		self waittill( "trigger" );
		if ( isdefined( level.zone_trigger ) )
			continue;
		
		level.zone_trigger = self;
		while ( level.player istouching( self ) )
		{
			wait( 0.05 );
		}
		level.zone_trigger = undefined;
	}
}

dog_check()
{
	if ( isdog() )
		self setthreatbiasgroup( "dog" );
}

chase_friendlies()
{
	if ( isdog() )
		self setthreatbiasgroup( "dog" );
	ai_move_in();
}

enemy_zone_spawner()
{
	// spawn guys from the current enemy zone
	level.on_the_run_progress = level.player.origin;
	
	// now AI will notify "shoot" when they shoot, so price can tell us the right time to put him down
	anim.shootEnemyWrapper_func = animscripts\utility::ShootEnemyWrapper_shootNotify;


	spawners = getentarray( "zone_spawner", "targetname" );
	for ( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ].script_grenades = 0;
	}
// 	array_thread( spawners, ::add_spawn_function, ::chase_friendlies );
	index = 0;
	
	// give some time before the first wave spawns
	waittill_either_function( ::player_moves, 600, ::timer, 15 );
	
	for ( ;; )
	{
		// stop spawning if the player is in the burnt building
		
		flag_waitopen( "enter_burnt" );
		waittillframeend;// wait for the global spawn function to be reenabled
		if ( getaiSpeciesArray( "all", "all" ).size >= 26 )
		{
			wait( 1 );
			continue;
		}
			
		if ( !isdefined( level.zone_trigger ) )
		{
			wait( 1 );
			continue;
		}

// 		iprintlnbold( "spawning wave" );
		// spawn 2 waves
		for ( i = 0; i < 2; i++ )
		{
			spawners = array_randomize( spawners );
			index -- ;
			if ( index < 0 || index >= level.zone_trigger.zone_spawners.size )
			{
				index = level.zone_trigger.zone_spawners.size - 1;
			}
			zone_spawner = level.zone_trigger.zone_spawners[ index ];
			spawn_targets = getentarray( zone_spawner.target, "targetname" );
			
			spawn_limited_number_from_spawners( spawners, spawn_targets, 4, 1 );
		}

		wait_until_its_time_to_spawn_another_wave();	
	}
}

price_asks_to_be_picked_up()
{
	the_line = "lets_get_moving_" + ( randomint( 2 ) + 1 );
	// Looks like we're in the clear, we should get moving.	
	// It's time to move, give me a lift.	
	
	if ( flag( "price_wants_apartment_cleared" ) )
		flag_wait( "apartment_cleared" );

	wait( 1.5 );	
	level.price anim_single_queue( level.price, the_line );
}

wait_until_its_time_to_spawn_another_wave()
{
	// spawn a new wave if there have been no enemies for a certain amount of time, or if the player brings price to a new area
	
	level endon( "time_to_spawn_a_new_wave" );
	thread spawn_wave_if_player_moves_far_with_price();
	waittill_dead_or_dying( "axis" );
	org = getent( "apartment_battle_org", "targetname" );
	if ( distance( org.origin, level.player.origin ) < distance( org.origin, level.on_the_run_progress ) )
	{
		// have we gotten closer to the destination?
		autosave_by_name( "on_the_run" );
		level.on_the_run_progress = level.player.origin;
	}

	if ( isalive( level.price ) )
	{
		price_asks_to_be_picked_up();
	}
	wait( 14 );
}

spawn_wave_if_player_moves_far_with_price()
{
	level endon( "time_to_spawn_a_new_wave" );
	// if the player makes enough spatial progress, spawn a new wave
	for ( ;; )
	{
		if ( isalive( level.price ) )
		{
			flag_assert( "price_picked_up" );
			flag_wait( "price_picked_up" );
		}
		
		wait_until_price_is_dropped_or_player_goes_far( level.player.origin );
	}
}

wait_until_price_is_dropped_or_player_goes_far( start_org )
{
	level endon( "price_dropped" );
	for ( ;; )
	{
		if ( distance( start_org, level.player.origin ) > 1050 )
		{
			level notify( "time_to_spawn_a_new_wave" );
			return;
		}
			
		wait( 1 );
	}
}

isdog()
{
	return self.classname == "actor_enemy_dog";	
}

// only spawn total_to_spawn from the spawners
spawn_limited_number_from_spawners( spawners, spawn_targets, total_to_spawn, max_dogs_allowed_in_level )
{
	spawned = 0;
	for ( i = 0; i < spawners.size; i++ )
	{
		total_dogs = getaiSpeciesArray( "axis", "dog" ).size;
		if ( spawned >= total_to_spawn )
			break;

		// only 1 dog at a time
		if ( spawners[ i ] isdog() && total_dogs >= max_dogs_allowed_in_level )
			continue;
		spawners[ i ].origin = spawn_targets[ spawned ].origin;
		spawners[ i ].count = 1;
		spawners[ i ].script_grenades = 0;
		spawners[ i ] dospawn();
		spawned++ ;
	}
}

dog_attacks_fence()
{
	node = getnode( "dog_fence_node", "targetname" );
	dog_spawner = getent( "fence_dog_spawner", "targetname" );
	
	dog = dog_spawner stalingradspawn();
	if ( spawn_failed( dog ) )
		return;
		
	dog.animname = "dog";
	dog.health = 5;
	dog.allowdeath = true;
	dog endon( "death" );

// 	node anim_reach_solo( dog, "fence_attack" );
	dog.ignoreme = true;
	node anim_single_solo( dog, "fence_attack" );
	dog.ignoreme = false;
	dog.health = 50;
	dog ai_move_in();
}

price_followup_line()
{
	level endon( "price_picked_up" );
	flag_assert( "price_picked_up" );
	
	wait( 3 );

	for ( ;; )
	{	
		// Sorry mate, you're gonna have to carry me!	
		level.price anim_single_queue( level.price, "carry_me" );
		wait( randomfloatrange( 8, 12 ) );
	}
	
}

set_objective_pos_to_extraction_point()
{
	org = extraction_point();
	objective_position( 1, org );
}

extraction_point()
{
	return getent( "enemy_fair_dest", "targetname" ).origin;
}

on_the_run_enemies()
{
	self notify( "stop_old_on_the_run_enemies" );
	self endon( "stop_old_on_the_run_enemies" );
	
	self endon( "death" );
	if ( isdefined( self.ridingvehicle ) )
	{
		self waittill( "jumpedout" );
	}

	thread ai_move_in();
}

fairground_enemies()
{
	self endon( "death" );
	if ( isdefined( self.ridingvehicle ) )
	{
		self waittill( "jumpedout" );
	}

	thread ai_move_in();
}

tracks_ent( target_ent )
{
	self endon( "stop_tracking_weapon" );

	trigger = getent( "pool_trigger", "targetname" );
		
	for ( ;; )
	{
// 		if ( distance( level.player.origin, target_ent.origin ) < 200 )
// 		if ( sighttracepassed( self gettagorigin( "tag_barrel" ), level.player geteye(), false, undefined ) )
		if ( level.player istouching( trigger ) || sighttracepassed( self gettagorigin( "tag_barrel" ), level.player geteye(), false, undefined ) )
		{
			self setturrettargetent( level.player, ( 0, 0, 24 ) );
		}	
		else
		{
			self setturrettargetent( target_ent );
		}
		
		angles = vectortoangles( target_ent.origin - self.origin );
		self setGoalyaw( angles[ 1 ] );
		wait( 0.1 );
	}		
}

shoot_at_entity_chain( ent )
{
	target_ent = spawn( "script_model", ent.origin );
// 	target_ent setmodel( "temp" );
	self setturrettargetent( target_ent );

	thread heli_fires();
	thread tracks_ent( target_ent );
	
	for ( ;; )
	{
		if ( !isdefined( ent.target ) )
			break;
			
		nextent = getent( ent.target, "targetname" );
		timer = distance( nextent.origin, ent.origin ) * 0.0035;
		if ( timer < 0.05 )
			timer = 0.05;
			
		target_ent moveto( nextent.origin, timer );
		wait( timer );

		ent = nextent;
	}
	
	target_ent delete();
	
	self notify( "stop_firing_weapon" );
	self notify( "stop_tracking_weapon" );
}

/* 
shoot_at_entity_chain( ent )
{
	thread heli_fires();
	lastent = ent;
	for ( ;; )
	{
		self setturrettargetent( ent );
		angles = vectortoangles( ent.origin - self.origin );
		self setGoalyaw( angles[ 1 ] );
		
		for ( ;; )
		{
			forward = anglestoforward( ( 0, self.angles[ 1 ], 0 ) );
			normal = vectorNormalize( ( ent.origin[ 0 ], ent.origin[ 1 ], 0 ) - ( self.origin[ 0 ], self.origin[ 1 ], 0 ) );
			dot = vectorDot( forward, normal );
			if ( dot > 0.95 )
				break;
				
			normal = vectorNormalize( ent.origin - lastent.origin );
			progress = vectorDot( forward, normal );
				
			wait( 0.1 );
		}
		
		if ( !isdefined( ent.target ) )
			break;

		lastent = ent;
		ent = getent( ent.target, "targetname" );
	}		
	
	self notify( "stop_firing_weapon" );
}
*/ 



incoming_heli_exists()
{
	helis = getentarray( "script_vehicle", "classname" );
	for ( i = 0; i < helis.size; i++ )
	{
		heli = helis[ i ];
		if ( !issubstr( heli.model, "mi17" ) )
			continue;
		
		if ( heli.unload_group == "default" )
		{
			// hasnt dropped off his troops yet
			return true;
		}
	}
	
	return false;
}

seaknight_badplace()
{
	seaknight_badplace = getent( "seaknight_badplace", "targetname" );
	for ( ;; )
	{
		if ( distance( self.origin, seaknight_badplace.origin ) < 800 )
			break;
		wait( 0.05 );
	}
	
	badplace_cylinder( "seaknight_badplace", 0, seaknight_badplace.origin, seaknight_badplace.radius, 512, "axis" );
	wait( 10 );
// 	iprintlnbold( "End of currently scripted level" );
}

player_navigates_burnt_apartment()
{
	nodes = getnodearray( "park_delete_node", "targetname" );
	level endon( "to_the_pool" );
	flag_assert( "to_the_pool" );
	
	for ( ;; )
	{
		flag_wait( "enter_burnt" );
		flag_clear( "price_calls_out_enemy_location" );
		remove_global_spawn_function( "axis", ::on_the_run_enemies );
		ai = getaispeciesarray( "axis", "all" );
		array_thread( ai, ::fall_back_and_delete, nodes );

		flag_waitopen( "enter_burnt" );
		flag_set( "price_calls_out_enemy_location" );
		add_global_spawn_function( "axis", ::on_the_run_enemies );
		level notify( "restarting_on_the_run" );
		
		// player went back outside so the chase begins anew
		ai = getaispeciesarray( "axis", "all" );
		array_thread( ai, ::on_the_run_enemies );
	}
}

apartment_hunters()
{
	flag_wait( "apartment_hunters_start" );
	spawners = getentarray( "apartment_hunter", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::apartment_hunter_think );
	array_thread( spawners, ::spawn_ai );
}

apartment_hunter_think()
{
	node = getnode( "apartment_hunter_delete", "targetname" );
	self endon( "death" );
	self setgoalnode( node );
	self.goalradius = 32;
	self.interval = 0;
	self.ignoreall = true;
	self waittill( "goal" );
	self delete();
}

fall_back_and_delete( nodes )
{
	if ( isdefined( self.script_noteworthy ) && ( self.script_noteworthy == "apartment_hunter" ) )
		return;

	self endon( "death" );
	level endon( "restarting_on_the_run" );
	

	if ( isdefined( self.ridingvehicle ) )
	{
		self waittill( "jumpedout" );
	}
	
	waittillframeend;// make sure reacquire player pos has started before we kill it
	self notify( "stop_moving_in" );
	node = random( nodes );
	self setgoalnode( node );
	self.goalradius = 64;
	self waittill( "goal" );
	assert( flag( "enter_burnt" ) );
	// player is still in the apartment so delete
	self delete();
}

deleteme()
{
	self delete();
}

curtain( side )
{
	self assign_animtree( "curtain" );
	self anim_loop_solo( self, side );
}


update_seaknight_objective_pos()
{
	for ( ;; )
	{
		objective_position( 4, level.seaknight.origin );
		wait( 0.05 );
	}
}

spawn_vehicle_from_targetname_and_create_ref( name )
{
	vehicle = spawn_vehicle_from_targetname_and_drive( name );
	level.ending_vehicles[ name ] = vehicle;
}

fairground_air_war()
{
	flag_wait( "seaknight_flies_in" );
// 	flag_waitopen( "enemy_choppers_incoming" );
	level.ending_vehicles = [];
	
	delayThread( 0, ::spawn_vehicle_from_targetname_and_create_ref, "ending_bad_heli_1" );
	delayThread( 10, ::spawn_vehicle_from_targetname_and_create_ref, "ending_bad_heli_2" );
	delayThread( 12, ::spawn_vehicle_from_targetname_and_create_ref, "ending_bad_heli_3" );
	delayThread( 16, ::spawn_vehicle_from_targetname_and_create_ref, "ending_bad_heli_4" );

	delayThread( 15.5, ::spawn_vehicle_from_targetname_and_create_ref, "ending_good_heli_1" );
	delayThread( 18, ::spawn_vehicle_from_targetname_and_create_ref, "ending_good_heli_2" );

	wait( 20 );
// 	ending_good_heli_1 thread kill_all_visible_enemies_forever();
// 	ending_good_heli_2 thread kill_all_visible_enemies_forever();
	wait( 3.5 );

	ending_bad_heli_1 = level.ending_vehicles[ "ending_bad_heli_1" ];
	ending_bad_heli_2 = level.ending_vehicles[ "ending_bad_heli_2" ];
	ending_bad_heli_3 = level.ending_vehicles[ "ending_bad_heli_3" ];
	ending_bad_heli_4 = level.ending_vehicles[ "ending_bad_heli_4" ];
	ending_good_heli_1 = level.ending_vehicles[ "ending_good_heli_1" ];
	ending_good_heli_2 = level.ending_vehicles[ "ending_good_heli_2" ];
	
	// wait until the first bad heli starts to leave	
	ending_good_heli_1 vehicle_flag_arrived( "ending_good_helis_leave" );
	ending_good_heli_1 notify( "stop_killing_enemies" );
	ending_good_heli_1 shoots_down( ending_bad_heli_1 );
	wait( 2 );
	// go back to shooting any remaining infantry
	ending_good_heli_1 thread kill_all_visible_enemies_forever();

	wait( 5 );
	
	ending_good_heli_2 vehicle_flag_arrived( "ending_good_helis_leave" );
	ending_good_heli_2 notify( "stop_killing_enemies" );
	flag_set( "ending_bad_heli2_leaves" );
	ending_good_heli_2 shoots_down( ending_bad_heli_2 );
	flag_set( "ending_bad_heli4_leaves" );
	wait( 2 );
	
	
	// go back to shooting any remaining infantry
	ending_good_heli_2 thread kill_all_visible_enemies_forever();
	
	ending_good_heli_1 notify( "stop_killing_enemies" );
	ending_good_heli_1 shoots_down( ending_bad_heli_4 );
	flag_set( "ending_bad_heli3_leaves" );
	wait( 2 );
	// go back to shooting any remaining infantry
	ending_good_heli_1 thread kill_all_visible_enemies_forever();

	wait( 1 );
		
	ending_good_heli_2 notify( "stop_killing_enemies" );
	ending_good_heli_2 shoots_down( ending_bad_heli_3 );
	wait( 2 );
	// go back to shooting any remaining infantry
	ending_good_heli_2 thread kill_all_visible_enemies_forever();
	



// 	ending_good_heli_1 setturrettargetent( ending_bad_heli_1 );
// 	ending_good_heli_1 thread heli_fires();

// 	ending_good_heli_2 setturrettargetent( ending_bad_heli_2 );
// 	ending_good_heli_2 thread heli_fires();
	
	wait( 1200 );


// 	ending_good_heli_2 setturrettargetent( ending_bad_heli_3 );
// 	ending_good_heli_1 setturrettargetent( ending_bad_heli_4 );
}

shoots_down( target )
{
	self setVehWeapon( "cobra_seeker" );
	offset = ( 0, 0, -50 );
	self fireWeapon( "tag_store_L_2_a", target, offset );// tag_light_L_wing
	wait( 0.2 );
	self fireWeapon( "tag_store_L_2_b", target, offset );// tag_light_L_wing
	wait( 0.2 );
	self fireWeapon( "tag_store_L_2_c", target, offset );// tag_light_L_wing

	self setVehWeapon( "cobra_20mm" );
}

create_apartment_badplace()
{
	// stop enemies from running into the apartment like mad apes
	ent = getent( "apartment_bad_place", "targetname" );
	badplace_cylinder( "apartment_badplace", 0, ent.origin, ent.radius, 200, "axis" );
}

delete_apartment_badplace()
{
	badplace_delete( "apartment_badplace" );
}

seaknight_squashes_stuff()
{
	self endon( "death" );
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( isalive( other ) )
		{
			if ( other.team == "allies" )
				continue;
			other dodamage( other.health + 150, ( 0, 0, 0 ) );
		}
	}
}

more_plant_claymores()
{
	flag_wait( "plant_claymore" );
	flag_clear( "plant_claymore" );

	if ( isalive( level.price ) )
	{
		// Quickly - plant a claymore in case they come this way!	
		level.price thread anim_single_queue( level.price, "place_claymore" );
	}
	else
	{
		// Quickly - plant a claymore in case they come this way!	
		level.player play_sound_on_entity( "sniperescape_mcm_plantclaymore" );
	}
}

burnt_spawners()
{
	burnt_spawners = getentarray( "burnt_spawner", "targetname" );
	
	next_spawn = 0;

	for ( ;; )
	{
		flag_wait( "deep_inside_burnt" );
		if ( gettime() < next_spawn )
		{
			wait( ( next_spawn - gettime() ) * 0.001 );
		}

		array_thread( burnt_spawners, ::increment_count_and_spawn );
		next_spawn = gettime() + 15000;
	}	
}

spooky_dog()
{
	spooky_dog_spawner = getent( "spooky_dog_spawner", "targetname" );
	flag_wait( "spawn_spooky_dog" );
	
	if ( getdvar( "player_hasnt_been_spooked" ) == "" )
	{
		setdvar( "player_hasnt_been_spooked", "1" );
		spooky_dog_spawner thread add_spawn_function( ::spooky_dog_spawns );
	}
	else
	{
		dog_tele = getent( "dog_tele", "targetname" );
		spooky_dog_spawner.origin = dog_tele.origin;
		spooky_dog_spawner.script_moveoverride = true;
		spooky_dog_spawner thread add_spawn_function( ::spooky_dog_spawns_hidden );
	}
	
	spooky_dog_spawner spawn_ai();
}

spooky_dog_spawns_hidden()
{
	trigger = getent( "spooky_dog_trigger", "targetname" );
	self.goalradius = 64;

	dog_end_goal = getent( "dog_end_goal", "script_noteworthy" );
	self.favoriteenemy = level.player;
	thread maps\_spawner::go_to_node( dog_end_goal, 1  );
	
	// dog only comes once
	spooky_deletes_on_trigger( trigger );
}

spooky_dog_spawns()
{
	self endon( "death" );
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 0;
	
	trigger = getent( "spooky_dog_trigger", "targetname" );
	
	flag_wait( "spooky_waits" );
	flag_set( "price_wants_apartment_cleared" );
	if ( flag( "price_picked_up" ) )
	{
		// if price is being carried, then the dog waits until price is put down, or waits some time
		level waittill_notify_or_timeout( "price_picked_up", 2.0 );
		if ( !flag( "price_picked_up" ) )
		{
			// price was put down, so wait a smidgen then go
			wait( 0.25 );
		}
	
		flag_set( "spooky_goes" );
		
		if ( !isalive( level.price ) )
		{
			// You'd better put me down and sweep the rooms, I'll cover the entrance.	
			thread radio_dialogue_queue( "sweep_the_rooms" );
		}

		self waittill( "reached_path_end" );
	
		spooky_deletes_on_trigger( trigger );
		return;
	}
	
	radio_dialogue_queue( "sweep_the_rooms" );
	
	// if the player isn't carrying price, then just charge the player
	self notify( "stop_going_to_node" );
	self.goalradius = 2048;
	set_default_pathenemy_settings();
}

spooky_deletes_on_trigger( trigger, timer )
{
	self endon( "death" );
	if ( !isdefined( timer ) )
		timer = 5;
		
	// is the player touching the trigger that keeps the dog in action?
	if ( level.player istouching( trigger ) )
	{
		self setgoalpos( level.player.origin );
		self.goalradius = 1024;
		return;
	}

	// bark for awhile then disappear.. mysteriously	
	trigger wait_for_trigger_or_timeout( 5 );
	self delete();
}

spooky_sighting()
{
	spooky_dog_spawner = getent( "spooky_sighting", "targetname" );
	spooky_dog_spawner thread add_spawn_function( ::spooky_dog_is_sighted );
}

spooky_dog_is_sighted()
{
	self endon( "death" );
	self waittill( "reached_path_end" );
	self setgoalpos( self.origin );
	self.goalradius = 32;
	trigger = getent( "spooky_dog_trigger", "targetname" );
	spooky_deletes_on_trigger( trigger, 0.1 );
}

second_apartment_line()
{
	for ( ;; )
	{
		flag_wait( "lets_go_that_way" );
		if ( isalive( level.price ) )
		{
			// player isn't carrying price if he's alive
			flag_waitopen( "lets_go_that_way" );
			continue;
		}
		
		radio_dialogue_queue( "head_for_apartment" );
		return;
	}
}

set_go_line()
{
	assertex( isdefined( self.script_noteworthy ), "Set_go_line trigger at " + self.origin + " has no script_noteworthy" );
	self waittill( "trigger", other );
	if ( isalive( other ) )
	{
		// he will say this line the next time _colors makes him move
		other._colors_go_line = self.script_noteworthy;
	}
}

waittill_noteworthy_dies( msg )
{
	guys = getentarray( msg, "script_noteworthy" );
	
	for ( i = 0; i < guys.size; i++ )
	{
		if ( isalive( guys[ i ] ) )
			guys[ i ] waittill( "death" );
	}
}

door_opens( mod )
{
	self playsound( "wood_door_kick" );
	rotation = -140;
	if ( isdefined( mod ) )
		rotation *= mod;
	self rotateyaw( rotation, .3, 0, .3 );
	self connectpaths();
}

flee_guy_runs()
{
	self endon( "death" );
	self.ignoreall = true;
	stop_moving_in();
	
	for ( ;; )
	{
		if ( self cansee( level.player ) )
			break;
		wait( 0.05 );
	}
	
	wait( 1.5 );
	
	node = getnode( self.script_linkto, "script_linkname" );
	self setgoalnode( node );
	self.goalradius = 64;
	self waittill( "goal" );
	self.ignoreall = false;
	self setgoalpos( level.player.origin );
	self.goalradius = 1024;
}

force_patrol_think()
{
	stop_moving_in();
	self endon( "death" );

	if ( !isalive( level.price ) )
	{
		self.allowdeath = true;
		self.disablearrivals = true;
		patrol_anims = get_patrol_anims();
		goalpos = getent( self.target, "targetname" );
		
		// start off with a start animation
		goalpos anim_generic_reach( self, patrol_anims[ self.script_index ] );
	
		self.a.movement = "run";// needs to be in the animation
		self anim_generic( self, patrol_anims[ self.script_index ] );
		/* 
		if ( isdefined( goalpos.target ) )
		{
			goalpos = getent( goalpos.target, "targetname" );
			self setgoalpos( goalpos.origin );
			wait( 1 );
		}
		*/ 
		self.disablearrivals = false;
	}	

	thread reacquire_player_pos();	
}

flicker_light()
{
	maps\_lights::burning_trash_fire();
}

price_fair_defendspot()
{
	price_gnoll = getent( "price_gnoll", "targetname" );
	return price_gnoll.origin;
}

enemy_door_trigger()
{
	self waittill( "trigger" );
	doors = getentarray( self.target, "targetname" );
	
	for ( i = 0; i < doors.size; i++ )
	{
		if ( doors[ i ].script_noteworthy == "enemy_door_right" )
			doors[ i ] thread door_opens( - 1 );
		else
			doors[ i ] thread door_opens();
	}
}

spawn_classname( spawners, class, num )
{
	correct_spawners = [];
	
	for ( i = 0; i < spawners.size; i++ )
	{
		spawner = spawners[ i ];
		if ( issubstr( spawner.classname, class ) )
		{
			correct_spawners[ correct_spawners.size ] = spawner;
		}
	}

	assertex( correct_spawners.size >= num, "Tried to spawn " + num + " guys from " + correct_spawners.size + " spawners of class " + class );
	
	for ( i = 0; i < num; i++ )
	{
		spawner = correct_spawners[ i ];
		spawner.count = 1;
		spawner dospawn();
	}
}


best_fair_path( alt )
{
	array = level.fair_paths;
	if ( alt )
	{
		array = level.fair_paths_alt;
	}

	lowest = array[ 0 ];
	
	for ( i = 1; i < array.size; i++ )
	{
		path = array[ i ];
		
		if ( path.uses < lowest.uses )
			lowest = path;
	}
	
	return lowest;
}

price_opens_fire()
{
	flag_wait_either( "open_fire", "fairbattle_high_intensity" );

	// Open fire.
	radio_dialogue_queue( "open_fire" );

	// macmillan opens fire if somebody reaches their run point or dies
	flag_clear( "fair_hold_fire" );
	level.price.first_shot_time = gettime();
	level.price.fastfire = true;
}

fair_guy_sets_high_intensity()
{
	fair_guy_waits_for_run_or_death();
	level.fair_runners++;
	
	if ( level.fair_runners >= 4 )
	{
		flag_set( "fairbattle_high_intensity" );
	}
}

fair_guy_waits_for_run_or_death()
{
	self endon( "death" );
	self endon( "damage" );
	ent_flag_wait( "reached_run_point" );
}

fairground_force_high_intensity()
{
	level endon( "fairbattle_high_intensity" );
	flag_wait( "fairbattle_detected" );
	wait( 18 );
	flag_set( "fairbattle_high_intensity" );
}

stealth_break_detection()
{
	self waittill_either( "alerted_once", "alerted_again" );
	flag_set( "fairbattle_detected" );
	flag_set( "fairbattle_detected" );
	println( "stealth broken" );
}

faiground_stealth_detection()
{
	flag_wait( "_stealth_spotted" );
	flag_set( "fairbattle_gunshot" );
	flag_set( "fairbattle_detected" );
	println( "stealth3" );
}

fair_guy_pre_battle_behavior( alt )
{
	alert_functions = [];
	/*
	alert_functions[1] = ::stealth_got_enemy1;
	alert_functions[2] = ::stealth_got_enemy2;
	alert_functions[3] = ::stealth_got_enemy3;
	*/
	thread stealth_break_detection();
	thread stealth_ai( undefined, alert_functions );

	level endon( "fairbattle_high_intensity" );
	thread patrol_fairgrounds_for_player( alt );
	flag_wait( "fairbattle_detected" );
	
	self.disableArrivals = false;
	self.favoriteEnemy = level.player;
//	self.ignoreall = true;
}
	
	
fair_guy_responds_to_invisible_attack()
{
	// already close to cover
	if ( ent_flag( "reached_run_point" ) )
		return;
		
	// somebody saw him
//	if ( !flag( "fairbattle_gunshot" ) )
//		return;

	if ( flag( "fairbattle_high_intensity" ) )
		return;
	
	level endon( "fairbattle_high_intensity" );
		
	// the shot has rung out!
	wait( randomfloatrange( 0.1, 0.8 ) );
	
	self anim_generic_custom_animmode( self, "gravity", "prone_dive" );
	
	self thread anim_generic_loop( self, "prone_idle", undefined, "stop_loop" );
	self allowedstances( "prone" );
	wait( randomfloatrange( 1, 12 ) );
	self notify( "stop_loop" );
	
	self ent_flag_wait( "reached_run_point" );
}

fair_stop_path_if_near_player()
{
	self endon( "death" );
	for ( ;; )
	{
		if ( distance( self.origin, level.player.origin ) < 500 )
		{
			self notify( "stop_going_to_node" );
			return;
		}
		wait( 1 );
	}
}

fair_alt_spawner_think()
{
	fair_guy_moves_in( true );
}

fair_spawner_think()
{
	fair_guy_moves_in( false );
}

fair_guy_moves_in( alt )
{
	// alt guys take a different path
	
	// dogs just do their own thing
	if ( self isdog() )
	{
		self setthreatbiasgroup( "dog" );
		// player hasnt been detected yet
		path = best_fair_path( alt );
		path.uses++ ;
		
		self thread fair_stop_path_if_near_player();
		self.disableArrivals = true;
		maps\_spawner::go_to_node( path, 1  );
		self.disableArrivals = false;
		
		thread reacquire_player_pos();
		return;
	}

	ent_flag_init( "reached_run_point" );
	thread fairground_guy_modify_attack_based_on_player();
	
	self endon( "death" );
	self.dontshootwhilemoving = true;
	thread fair_guy_sets_high_intensity();
	// can only blindfire
	self.a.forced_cover = "hide";
	

	if ( !flag( "fairbattle_detected" ) )
	{
		fair_guy_pre_battle_behavior( alt );
		
		// enemy must not be detected, so go prone
//		if ( !self.canFight )
		if ( !fairground_should_skip_prone_moment() )
			fair_guy_responds_to_invisible_attack();

		wait( randomfloatrange( 0.2, 2 ) );
		self notify( "stop_animmode" );
	}
	else
	{
		path = best_fair_path( alt );
		path.uses++ ;
		self.disableArrivals = true;
		thread maps\_spawner::go_to_node( path, 1 );
		
		// run path for a few seconds just to spread out
		wait_until_near_player_or_run_point();
		self.disableArrivals = false;

		park_reinforce = getent( "park_reinforce", "targetname" );
		self setgoalpos( park_reinforce.origin );
	}

	self fairground_attack_logic();
}

wait_until_near_player_or_run_point()
{
	self endon( "reached_path_end" );
	self endon( "reached_run_point" );
	
	for ( ;; )
	{
		if ( distance( self.origin, level.player.origin ) < 1024 )
			return;
		wait( 1 );
	}
}

found_good_cover_spot()
{
	if ( !isdefined( self.goalpos ) )
		return false;
		
	if ( !isdefined( self.node ) )
		return false;
	
	if ( !issubstr( self.node.type, "over" ) )
		return false;
	
	return true;
}

fairground_should_skip_prone_moment()
{
	if ( level.player getstance() != "stand" )
		return false;
		
	if ( !( self cansee( level.player ) ) )
		return false;
		

	return distance( self.origin, level.player.origin ) < 750;
}

fairground_guy_modify_attack_based_on_player()
{
	self endon( "death" );
	for ( ;; )
	{
		fairguy_cant_fight();

		if ( level.player getstance() == "stand" )
		{
			if ( self cansee( level.player ) )
			{
				fairguy_can_fight();
				wait( 5 );
			}
			else
				wait( 1 );
				
			continue;
		}
		
		// prone can see dists
		can_see_dist = 200;
		must_hide_dist = 256;
		must_nothide_dist = 128;
		
		if ( level.player getstance() == "crouch" )
		{
			can_see_dist = 750;
			must_hide_dist = 900;
			must_nothide_dist = 600;
		}
	
		player_dist = distance( self.origin, level.player.origin );
		
		if ( player_dist > must_hide_dist )
		{
			fairguy_cant_fight();
			wait( 5 );
			continue;
		}
		
		if ( player_dist < must_nothide_dist )
		{
			fairguy_can_fight();
			wait( 1 );
			continue;
		}
		
		if ( player_dist < can_see_dist )
		{
			if ( self cansee( level.player ) )
			{
				fairguy_can_fight();
				wait( 5 );
				continue;
			}
		}
		wait( 1 );
	}
}

rpgGuy()
{
	return issubstr( self.classname, "RPG" );
}

fairguy_cant_fight()
{
	if ( !flag( "player_plays_nice" ) )
	{
		fairguy_can_fight();
		return;
	}
	
	self.canFight = false;
	if ( rpgGuy() )
		return;
		
	self.a.forced_cover = "hide";
	self.dontshootwhilemoving = true;
}

fairguy_can_fight()
{
	self.canFight = true;
	self.a.forced_cover = "none";
	self.dontshootwhilemoving = undefined;
}

fairground_attack_logic()
{
	self notify( "stop_going_to_node" );
	self endon( "death" );
	
	self set_generic_run_anim( "sprint" );
	self.ignoreall = false;
	self allowedstances( "stand", "prone", "crouch" );


	park_reinforce = getent( "park_reinforce", "targetname" );
	self setgoalpos( park_reinforce.origin );
	
	if ( rpgGuy() )
	{
		self setengagementmindist( 500, 500 );
		self setengagementmaxdist( 800, 800 );
	}
	
	// the guy picks a node near then hangs out there awhile
	for ( ;; )
	{
		if ( !isalive( self.enemy ) )
		{
			wait( 1 );
			continue;
		}	
		
		enemy_dist = distance( self.origin, self.enemy.origin );

		if ( !rpgGuy() )
		{
			// get a little closer
			self setengagementmindist( enemy_dist * 0.75, enemy_dist * 0.75 );
			self setengagementmaxdist( enemy_dist * 0.85, enemy_dist );
		}
		// time to find a new place to go
		self setgoalpos( level.player.origin );
		self.goalradius = 2000;
		
		for ( ;; )
		{
			if ( !flag( "player_plays_nice" ) )
				fairground_kill_mean_player_until_he_plays_nice();
				
			if ( found_good_cover_spot() )
			{
				// found a new place?
				if ( distance( self.node.origin, self.origin ) > 128 )
					break;
			}
			wait( 1 );
		}

		// hide at this node for awhile		
		self setgoalpos( self.node.origin );
		self.goalradius = 64;
		if ( flag( "player_plays_nice" ) )
		{
			// player is playing nice so we'll take cover nice
			level waittill_notify_or_timeout( "player_plays_nice", randomfloatrange( 20, 30 ) );
		}
		else
		{
			fairground_kill_mean_player_until_he_plays_nice();
		}
	}
}

fairground_kill_mean_player_until_he_plays_nice()
{
	self.goalradius = 1024;
	for ( ;; )
	{
		self setgoalpos( level.player.origin );
		wait( 5 );
	}
}

fairground_detect_activity_and_set_flag()
{
	self waittill_either( "death", "damage" );
	flag_set( "fairbattle_gunshot" );
	flag_set( "fairbattle_detected" );
}
	
patrol_fairgrounds_for_player( alt )
{
	self endon( "death" );
	thread fairground_detect_activity_and_set_flag();
	
	// player hasnt been detected yet
	path = best_fair_path( alt );
	path.uses++ ;
	
	self set_generic_run_anim( "patrol_jog" );
	self.disableArrivals = true;
//	self.ignoreall = true;
	thread maps\_spawner::go_to_node( path, 1, ::do_patrol_anim_at_org );
}

do_patrol_anim_at_org( ent )
{
	thread do_patrol_anim_at_org_thread( ent );
}

print3d_forever( org, text, color, alpha, scale )
{
	for ( ;; )
	{
		print3d( org, text, color, alpha, scale );
		wait( 0.05 );
	}
}

do_patrol_anim_at_org_thread( ent )
{
	if ( isdefined( ent.script_noteworthy ) && ent.script_noteworthy == "run_point" )
	{
		// now the AI is in the open so they cant crawl
		self ent_flag_set( "reached_run_point" );
	}
		
	if ( flag( "fairbattle_detected" ) )
		return;
		
	if ( !isdefined( ent.target ) )
		return;
		
	if ( !isdefined( ent.marker ) )
	{
		ent.marker = true;
		if ( !isdefined( level.gmarker ) )
			level.gmarker = 0;
			
		level.gmarker++ ;
	
// 		thread print3d_forever( ent.origin, level.gmarker, ( 1, 1, 1 ), 1, 1 );
	}

	self endon( "death" );

	if ( !isdefined( ent.script_index ) )
		return;
		
	/* 
	targs = getentarray( ent.target, "targetname" );
	// do a special anim at specified ents
	if ( !isdefined( ent.script_index ) )
	{
		thread line_for_time( ent.origin, targ.origin, ( 0, 0, 0.5 ), 3 );
		return;
	}
	
	thread line_for_time( ent.origin, targ.origin, ( 0, 1, 1 ), 3 );
	*/ 

	self.allowdeath = true;
	self.a.movement = "run";// add to notetrack!
	patrol_anims = get_patrol_anims();
	thread delayed_patrol_anim( patrol_anims[ ent.script_index ] );
	ent.script_index = undefined;
}

delayed_patrol_anim( anime )
{
	self endon( "stop_animmode" );
	self endon( "death" );
	wait( 0.5 );
	anim_generic_custom_animmode( self, "gravity", anime );
}

remove_cant_see_player( array )
{
	guys = [];
	for ( i = 0; i < array.size; i++ )
	{
		guy = array[ i ];
		if ( guy cansee( level.player ) )
			guys[ guys.size ] = guy;
	}
	return guys;
}

	
fairground_price_dialogue()
{
	level endon( "fairbattle_high_intensity" );
	
	flag_wait( "enemies_in_sight" );
	
	// Tangos in sight. Let them get closer.
	radio_dialogue_queue( "let_them_get_closer" );
	
	flag_wait( "get_ready_to_fire" );
	
	// Standby to engage…
	radio_dialogue_queue( "standby_to_engage" );
}



fairground_battle()
{
	if ( isalive( level.price ) )
	{
		thread fairground_price_adjustment();
		thread price_opens_fire();
	}
		
	setsaveddvar( "ai_eventDistGunShot", 4500 );
	thread faiground_stealth_detection();
	thread fairground_keep_player_out_of_pool();
	
	thread fairground_price_dialogue();

	level._stealth.logic.detect_range[ "hidden" ][ "stand" ]	= 2048;

// 	thread fairground_enemy_helis();
	level.player thread stealth_ai();

	flag_set( "faiground_battle_begins" );
	
	remove_global_spawn_function( "axis", ::enemy_override );
	
	secondary_paths = getentarray( "secondary_path", "script_noteworthy" );
	array_thread( secondary_paths, ::secondary_path_think );
	thread fairground_force_high_intensity();
	
	level.fair_paths = getentarray( "fair_path", "targetname" );
	level.fair_paths_alt = getentarray( "fair_path_alt", "targetname" );
	field_ref_spot = getent( "field_ref_spot", "targetname" );
	
	// so they're used in a certain order
	level.fair_paths = get_array_of_closest( field_ref_spot.origin, level.fair_paths );
	
	for ( i = 0; i < level.fair_paths.size; i++ )
	{
		level.fair_paths[ i ].uses = 0;
	}
	
	// so they're used in a certain order
	level.fair_paths_alt = get_array_of_closest( field_ref_spot.origin, level.fair_paths_alt );
	
	for ( i = 0; i < level.fair_paths_alt.size; i++ )
	{
		level.fair_paths_alt[ i ].uses = 0;
	}
	
	level.fair_runners = 0;

	fair_spawners = getentarray( "fair_spawner", "targetname" );
	array_thread( fair_spawners, ::add_spawn_function, ::fair_spawner_think );
	
	alt_spawners = getentarray( "fair_spawner_alt", "targetname" );
	array_thread( alt_spawners, ::add_spawn_function, ::fair_alt_spawner_think );

	// player is ignored until he does something to alert the enemy
	level.player.ignoreme = true;
	
	// "ak47", "rpd", "g3", "mp5", "RPG"
	
	fairground_pre_detection();
	
	level.player.ignoreme = false;
	level.player.threatbias = 500;
	
	flag_wait( "fairbattle_detected" );
	flag_wait( "fairbattle_high_intensity" );
	flag_clear( "fair_hold_fire" );
	
 	fairground_post_detection();
}

fairground_pre_detection()
{
	// first spawn in a wave of guys that will patrol jog in
	level endon( "fairbattle_detected" );
	fair_spawners = get_fair_spawners();
	spawn_classname( fair_spawners, "ak47", 2 );
	spawn_classname( fair_spawners, "g3", 2 );
	spawn_classname( fair_spawners, "mp5", 2 );
	wait( 4 );
	fair_spawners = get_fair_spawners();
	spawn_classname( fair_spawners, "ak47", 2 );
	spawn_classname( fair_spawners, "g3", 2 );
	spawn_classname( fair_spawners, "mp5", 2 );
	wait( 4 );
// 	level.fair_paths = array_randomize( level.fair_paths );
}

get_fair_spawners()
{
	alt_fair_trigger = getent( "alt_fair_trigger", "targetname" );
	
	if ( level.player istouching( alt_fair_trigger ) )
	{
		// ai originate elsewhere if this trigger is touched
		return getentarray( "fair_spawner_alt", "targetname" );
	}
	else
	{
		return getentarray( "fair_spawner", "targetname" );
	}
}

spawn_lowbie_mixed()
{
	fair_spawners = get_fair_spawners();
	spawn_classname( fair_spawners, "ak47", 2 );
	spawn_classname( fair_spawners, "g3", 2 );
	spawn_classname( fair_spawners, "mp5", 2 );
}

spawn_sniper_mixed()
{
	fair_spawners = get_fair_spawners();
	spawn_classname( fair_spawners, "ak47", 1 );
	spawn_classname( fair_spawners, "g3", 1 );
	spawn_classname( fair_spawners, "mp5", 1 );
	spawn_classname( fair_spawners, "drag", 3 );
}

spawn_saw_support()
{
	fair_spawners = get_fair_spawners();
	spawn_classname( fair_spawners, "rpd", 3 );
}

spawn_rpg_support()
{
	fair_spawners = get_fair_spawners();
	spawn_classname( fair_spawners, "RPG", 3 );
}

spawn_dog_support()
{
	fair_spawners = get_fair_spawners();
	spawn_classname( fair_spawners, "dog", 3 );
}

spawn_heli_pod_1()
{
	spawn_vehicle_from_targetname_and_drive( "fairground_heli1" );
	spawn_vehicle_from_targetname_and_drive( "fairground_heli2" );
}

spawn_heli_pod_2()
{
	spawn_vehicle_from_targetname_and_drive( "fairground_heli3" );
	spawn_vehicle_from_targetname_and_drive( "fairground_heli4" );
}

fairground_post_detection()
{
	groups = [];
	groups[ "lowbie_mixed" ] = ::spawn_lowbie_mixed;
	groups[ "heli_pod_1" ] = ::spawn_heli_pod_1;
	groups[ "heli_pod_2" ] = ::spawn_heli_pod_2;
	groups[ "saw_support" ] = ::spawn_saw_support;
	groups[ "rpg_support" ] = ::spawn_rpg_support;
	groups[ "dog_support" ] = ::spawn_dog_support;
	groups[ "sniper_mixed" ] = ::spawn_sniper_mixed;
	

	counts = [];
	counts[ "lowbie_mixed" ] = 6;
	counts[ "heli_pod_1" ] = 10;
	counts[ "heli_pod_2" ] = 10;
	counts[ "saw_support" ] = 3;
	counts[ "rpg_support" ] = 3;
	counts[ "dog_support" ] = 3;
	counts[ "sniper_mixed" ] = 6;

	schedule = spawnstruct();
	schedule.timer = gettime();
	schedule.events = [];
	schedule = add_to_schedule( schedule, "lowbie_mixed", 12 );
	schedule = add_to_schedule( schedule, "saw_support", 5 );
	schedule = add_to_schedule( schedule, "rpg_support", 7 );
	schedule = add_to_schedule( schedule, "dog_support", 3 );
	schedule = add_to_schedule( schedule, "sniper_mixed", 12 );
	schedule = add_to_schedule( schedule, "saw_support", 5 );
	schedule = add_to_schedule( schedule, "rpg_support", 4 );
	schedule = add_to_schedule( schedule, "heli_pod_1", 4 );
	schedule = add_to_schedule( schedule, "dog_support", 9 );
	schedule = add_to_schedule( schedule, "heli_pod_2", 4 );
	schedule = add_to_schedule( schedule, "sniper_mixed", 1 );
	schedule = add_to_schedule( schedule, "saw_support", 6 );
	schedule = add_to_schedule( schedule, "lowbie_mixed", 6 );
	schedule = add_to_schedule( schedule, "saw_support", 6 );
	schedule = add_to_schedule( schedule, "sniper_mixed", 6 );
	schedule = add_to_schedule( schedule, "saw_support", 6 );
	schedule = add_to_schedule( schedule, "lowbie_mixed", 6 );
	schedule = add_to_schedule( schedule, "saw_support", 6 );
	schedule = add_to_schedule( schedule, "sniper_mixed", 6 );
	schedule = add_to_schedule( schedule, "saw_support", 6 );
	schedule = add_to_schedule( schedule, "lowbie_mixed", 6 );
	schedule = add_to_schedule( schedule, "saw_support", 6 );
	schedule = add_to_schedule( schedule, "lowbie_mixed", 6 );
	
	index = 0;
	for ( ;; )
	{
		event = schedule.events[ index ];
		current_time = gettime();
		if ( event[ "timer" ] > current_time )
		{
			// wait until its time for this event
			wait( ( event[ "timer" ] - current_time ) * 0.001 );
		}
		
		wait_until_enough_ai_headroom( counts[ event[ "event" ] ] );

		if ( getaispeciesarray( "axis", "all" ).size <= 8 )
		{
			thread autosave_or_timeout( "autosave_for_good_behavior", 10 );
		}
		
		// spawn the group
		[[ groups[ event[ "event" ] ] ]]();
		
		index++;
		
		if ( index >= schedule.events.size )
			break;
	}
}

wait_until_enough_ai_headroom( num )
{
	for ( ;; )
	{
		if ( getaispeciesarray( "all" ).size + num <= 32 )
			break;
		wait( 1 );
	}
}


add_to_schedule( schedule, event, timer )
{
	timer *= 1000;
	schedule.timer += timer;

	array = [];
	array[ "event" ] = event;
	array[ "timer" ] = schedule.timer;
	
	schedule.events[ schedule.events.size ] = array;
	return schedule;
}

	
fairground_enemy_helis()
{
	level endon( "seaknight_flies_in" );
	flag_assert( "seaknight_flies_in" );
	wait( 5 );
	
	fairground_helinames = [];
	fairground_helinames[ fairground_helinames.size ] = "fairground_heli1";
	fairground_helinames[ fairground_helinames.size ] = "fairground_heli2";
	fairground_helinames[ fairground_helinames.size ] = "fairground_heli3";
	fairground_helinames[ fairground_helinames.size ] = "fairground_heli4";
	fairground_helinames[ fairground_helinames.size ] = "fairground_heli5";

	timer = 26;
	for ( ;; )
	{	
		fairground_helinames = array_randomize( fairground_helinames );
		
		for ( i = 0; i < fairground_helinames.size; i++ )
		{
			while ( getaispeciesarray( "all", "all" ).size >= 31 )
			{
				wait( 1 );
			}
			
			name = fairground_helinames[ i ];
			
			// thread off so we can track if there are still helis moving in to the site
			thread heli_drops_off_guys_at_fairground( name );
			wait( timer );
			timer -= 2;
			if ( timer < 8 )
				timer = 8;
		}
	}
}

heli_drops_off_guys_at_fairground( name )
{
	flag_set( "enemy_choppers_incoming" );
	heli = spawn_vehicle_from_targetname_and_drive( name );
	heli waittill( "unload" );
	waittillframeend;// wait for our .unload_group to get set, since _vehicle is reliant on waits and notifies
	
	wait( 6 );// give the guys a chance to get outa there
	
	if ( !incoming_heli_exists() )
	{
		flag_clear( "enemy_choppers_incoming" );
	}
}

price_says_this_is_fine()
{
	level endon( "price_picked_up" );
	for ( ;; )
	{
		if ( distance( level.player.origin, price_fair_defendspot() ) < level.price_gnoll_dist )
		{
			thread add_dialogue_line( "MacMillan", "This'll be fine." );
			flag_set( "can_manage_price" );
			return;
		}
		wait( 0.5 );
	}
}

secondary_path_think()
{
	// make guys running this path choose this one as a secondary pick.
// 	print3d_forever( self.origin, self.gtn_uses, ( 1, 1, 1 ), 1, 1 );

	array = getentarray( self.targetname, "targetname" );
	array = array_remove( array, self );
	array[ array.size ] = self;
	
	level.go_to_node_arrays[ self.targetname ] = array;
}


fairgrounds_wait_until_player_is_ready()
{
	player_snipe_spot = getent( "player_snipe_spot", "targetname" );
	
	for ( ;; )
	{
		if ( distance( level.player.origin, player_snipe_spot.origin ) < player_snipe_spot.radius )
		{
			display_hint( "prone_at_fair" );
		}
		else
		{
			wait( 0.05 );
			continue;
		}

		for ( ;; )
		{
			if ( distance( level.player.origin, player_snipe_spot.origin ) >= player_snipe_spot.radius )
				break;
			if ( level.player getstance() == "prone" )
				return;
			wait( 0.05 );
		}
	}
}


should_halt()
{
	if ( !isalive( level.price.enemy ) )
		return true;
		
	return distance( level.price.enemy.origin, level.price.origin ) > 1024;
}

price_kill_check()
{
	self waittill( "death", other );
	if ( !isalive( other ) )
		return;
	if ( !isalive( level.price ) )
		return;
	if ( other != level.price )
		return;
	
	wait( 1.0 );
	price_calls_out_a_kill();
}

heat_progression_summons_kill_heli()
{
	level.kill_heli_progression++;
	self.index = level.kill_heli_progression;

	level.kill_heli_progression_triggers[ self.index ] = 0;
	level.kill_heli_progression_warnings[ self.index ] = 0;
	
	level endon( "break_for_apartment" );
	
	// now all progression indices are defined
	
	waittillframeend;
	
	array = [];
	triggers = getentarray( "heat_progression", "targetname" );
	
	// lower indexed triggers get added here
	for ( i = 0; i < triggers.size; i++ )
	{
		if ( triggers[ i ].script_index < self.script_index )
			array[ array.size ] = triggers[ i ];
	}
	
	for ( ;; )
	{
		self waittill( "trigger" );
		level.kill_heli_index = self.index;
		level.kill_heli_triggers = array;
	}
}

kill_heli_logic()
{
	heli_kill_timer = 75;
	heli_kill_previous_zone_time = 68;
	
	current_warning = 1;
	warnings = [];
	warnings[ warnings.size ] = 20;
	warnings[ warnings.size ] = 40;
	warnings[ warnings.size ] = 60;
//	level waittill( "price_sees_enemy" );
	flag_wait( "start_heat_spawners" );
	

	last_warning_time = 0;
	// heli comes and kills the player if he spends too much time in a zone
	for ( ;; )
	{
		for ( i = 0; i < level.kill_heli_triggers.size; i++ )
		{
			index = level.kill_heli_triggers[ i ].index;
			// raise previous zones to 35 seconds, so you cant go backtracking far
			if ( level.kill_heli_progression_triggers[ index ] < heli_kill_previous_zone_time )
				level.kill_heli_progression_triggers[ index ]++;
		}

		level.kill_heli_progression_triggers[ level.kill_heli_index ]++;
		wait( 1 );
		if ( flag( "break_for_apartment" ) )
			return;
		
		cumlative_time = level.kill_heli_progression_triggers[ level.kill_heli_index ];
		if ( flag( "price_calls_out_kills" ) )
		{
			if ( cumlative_time > warnings[ 0 ] )
				flag_clear( "price_calls_out_kills" );
		}
		else
		{
			if ( cumlative_time < warnings[ 0 ] )
				flag_set( "price_calls_out_kills" );
		}
		

		if ( gettime() > last_warning_time + 15000 )
		{
			// issue a warning if we've hung out here too long, or backtracked.		
			if ( cumlative_time > warnings[ level.kill_heli_progression_warnings[ level.kill_heli_index ] ] )
			{
				level.kill_heli_progression_warnings[ level.kill_heli_index ]++;
				if ( level.kill_heli_progression_warnings[ level.kill_heli_index ] >= warnings.size )
				{
					level.kill_heli_progression_warnings[ level.kill_heli_index ] = warnings.size - 1;
				}
					
				level.price thread anim_single_queue( level.price, "gotta_go_" + current_warning );
				current_warning++;
				if ( current_warning > 10 )
					current_warning = 1;
					
				last_warning_time = gettime();
			}
		}

		// spent too long in this zone! time to die.		
		if ( cumlative_time > heli_kill_timer )
			break;
	}
	
	if ( flag( "break_for_apartment" ) )
		return;
	
	thread bring_out_the_hounds();
	heli = spawn_vehicle_from_targetname_and_drive( "kill_heli" );
	heli waittill( "reached_dynamic_path_end" );
	
	points = getentarray( "kill_heli_spot", "targetname" );
	
	for ( ;; )
	{
		org = getclosest( level.player.origin, points );
		
		heli setSpeed( 40, 10, 10 );
		heli setNearGoalNotifyDist( 100 );
		heli setvehgoalpos( org.origin, 1 );
		heli waittill( "near_goal" );

		if ( flag( "break_for_apartment" ) )
			return;

		for ( i = 0; i < 30; i++ )
		{
			angles = vectortoangles( level.player.origin - heli.origin );
			heli setgoalyaw( angles[ 1 ] );
			heli setturrettargetent( level.player, randomvector( 15 ) + ( 0, 0, 16 ) );
			heli fireweapon();
			wait( 0.05 );
		}
		wait( randomfloatrange( 0.8, 1.3 ) );
	}
}

bring_out_the_hounds()
{
	level endon( "break_for_apartment" );
	wait( 20 );
	
	kill_dog_spawners = getentarray( "kill_dog_spawner", "targetname" );
	array_thread( kill_dog_spawners, ::add_spawn_function, ::seek_player );
	
	for ( ;; )
	{
		if ( getaispeciesarray( "all", "all" ).size >= 24 )
		{
			wait( 1 );
			continue;
		}
		
		spawners = get_array_of_closest( level.player.origin, kill_dog_spawners );
		count = 0;
		
		for ( i = spawners.size - 1; i >= 0; i-- )
		{
			spawner = spawners[ i ];
			if ( bullettracepassed( level.player.origin + (0,0,32), spawner.origin + (0,0,32), false, level.player ) )
				continue;
			
			count++;
			spawner.count = 1;
			spawner dospawn();
			
			if ( count >= 8 )
				break;
		}
		
		wait( 3 );
	}
}

seek_player()
{
	self endon( "death" );
	for ( ;; )
	{
		self setgoalpos( level.player.origin );
		self.goalradius = 512;
		wait( 1 );
	}
}

pool_dog_think()
{
	self endon( "death" );
	ent = getent( self.target, "targetname" );
	
	ent thread anim_generic_loop( self, "dog_food" );
	wait( 0.05 );
	self setanimtime( getanim_generic( "dog_food_nonidle" ), randomfloat( 1 ) );
	
	thread dog_attacks_player_if_he_feels_threatened( ent );
	
	flag_wait( "fairbattle_high_intensity" );
	if ( !flag( "player_looked_in_pool" ) )
	{
		self delete();
	}
		
	wait( 3 );
	ent notify( "stop_loop" );
	self stopanimscripted();
	self.goalradius = 1500;
	park_reinforce = getent( "park_reinforce", "targetname" );
	self setgoalpos( park_reinforce.origin );
	self.team = "allies"; // go getem!
	
//	self delete(); // gotta wait until the op force tag_sync is in
}

wait_for_angry_dog()
{
	level endon( "dog_attack_trigger" );
	for ( ;; )
	{
		flag_waitopen( "price_picked_up" );
		flag_wait( "pool_lookat" );
		
		// is price dropped?
		if ( !flag( "price_picked_up" ) )
			break;
	}
}

dog_attacks_player_if_he_feels_threatened( ent )
{
	self endon( "death" );
	level endon( "fairbattle_high_intensity" );

	wait_for_angry_dog();	
	
	ent notify( "stop_loop" );
	self stopanimscripted();
	
//	self.goalradius = 4;
//	wait( randomfloatrange( 2, 3 ) );
//	wait( 151);
	thread reacquire_player_pos();
}

go_prone_line_check()
{
	if ( flag( "price_told_player_to_go_prone" ) )
		return;
		
	claymoreCount = getPlayerClaymores();
	if ( claymoreCount > 0 )
		return;

	// Find a good spot to snipe from and go prone.
	thread radio_dialogue_queue( "find_spot_go_prone" );
	flag_set( "price_told_player_to_go_prone" );
}

wait_for_player_to_place_claymores()
{
	bonus = 0;

	oldClaymoreCount = getPlayerClaymores();
	for ( i = 0; i < 30; i++ )
	{
		newClaymoreCount = getPlayerClaymores();
		
		if ( newClaymoreCount < oldClaymoreCount )
		{
			bonus += 3.5;
		}
		oldClaymoreCount = newClaymoreCount;
		
		if ( level.player getstance() == "prone" && newClaymoreCount == 0 )
			return;
			
		go_prone_line_check();
		wait( 1 );
	}

	if ( bonus > 0 )
	
	for ( i = 0; i < bonus; i++ )
	{
		newClaymoreCount = getPlayerClaymores();
		if ( level.player getstance() == "prone" && newClaymoreCount == 0 )
			return;
			
		go_prone_line_check();
		wait( 1 );
	}
}

autosave_on_good_claymore_placement( claymoreCount )
{
	alt_fair_trigger = getent( "alt_fair_trigger", "targetname" );
	
	for ( i = 0; i < 5; i++ )
	{
		if ( level.player istouching( alt_fair_trigger ) )
			wait( 1 );
		else
			break;
	}
	
	if ( level.player istouching( alt_fair_trigger ) )
		return false;
		
	claymore_spots = getentarray( "claymore_spot", "targetname" );
	
	if ( claymoreCount <= 0 )
		return true;
		
	// gotta place
	required = claymoreCount * 0.40;
	required = int( required ); // rounds down!
	
	grenades = getentarray( "grenade", "classname" );
	claymores = remove_without_model( grenades, "claymore" );
	
	count = 0;
	for ( i = 0; i < claymores.size; i++ )
	{
		for ( p = 0; p < claymore_spots.size; p++ )
		{
			if ( distance( claymores[ i ].origin, claymore_spots[ p ].origin ) < claymore_spots[ p ].radius )
			{
				// found a claymore that is close to a spot that would be smart to put one near
				
				count++;
				break;
			}
		}
		
		if ( count >= required )
			return true;
	}
	
	return false;
}

no_grenades()
{
	self.grenadeammo = 0;
}



getPlayerClaymores()
{
	heldweapons = level.player getweaponslist();
	stored_ammo = [];
	for ( i = 0; i < heldweapons.size; i++ )
	{
		weapon = heldweapons[ i ];
		stored_ammo[ weapon ] = level.player getWeaponAmmoClip( weapon );
	}
			
// 	thread add_dialogue_line( "MacMillan", "Once I see you're set, I'll send the signal." );
// 	thread add_dialogue_line( "MacMillan", "Find a good sniping position, the enemy is sure to check this area." );
	
	
	claymoreCount = 0;
	if ( isdefined( stored_ammo[ "claymore" ] ) && stored_ammo[ "claymore" ] > 0 )
	{
		claymoreCount = stored_ammo[ "claymore" ];
	}
	return claymoreCount;
}

price_says_a_bit_farther()
{
	price_putdown_hint_trigger = getent( "price_putdown_hint_trigger", "targetname" );
	
	lines = [];
	index = 0;
	lines[ lines.size ] = "A bit farther to the north.";
	lines[ lines.size ] = "Put me where I marked on your compass";
	
	for ( ;; )
	{
		price_putdown_hint_trigger waittill( "trigger" );
		if ( flag( "price_picked_up" ) )
		{
			add_dialogue_line( "MacMillan", lines[ index ] );
			index++;
			if ( index >= lines.size )
				index = 0;
			wait( randomfloatrange( 6, 8 ) );
		}
	}
}


fairground_keep_player_out_of_pool()
{

	// anti cheap the sequence by going into a non fighting area
	for ( ;; )
	{
		flag_wait( "player_goes_to_pool" );
		flag_clear( "can_save" );
		wait( randomfloat( 4, 6 ) );

		if ( !flag( "player_goes_to_pool" ) )
		{
			if ( !flag( "seaknight_lands" ) )
			{
				flag_set( "can_save" );
			}
			
			continue;
		}

		price_dies();
		flag_waitopen( "player_goes_to_pool" );
	}
}

player_abandons_seaknight_protection()
{
	flag_wait( "price_picked_up" );
//	flag_wait( "player_abandon_protection" );
	level waittill( "foawerawer" ); // recompling
	
	flag_set( "seaknight_leaves_prematurely" );
}

wait_for_seaknight_to_take_off()
{
	level endon( "seaknight_leaves_prematurely" );
	flag_wait( "player_made_it_to_seaknight" );
}

player_boards_seaknight( seaknight, trigger )
{
	asked_for_macmillan = false;
	for ( ;; )
	{
		if ( isalive( level.price ) )
			objective_position( 5, level.price.origin );
		else
			objective_position( 5, trigger.origin );
		
		wait( 0.05 );

		if ( distance( level.player.origin, trigger.origin ) >= trigger.radius )
			continue;
		
		// player has to carry price to chopper
		if ( !isalive( level.price ) )
			break;
			
		if ( !asked_for_macmillan )
		{
			// WHERE'S MACMILLAAAN?!!!
			thread radio_dialogue_queue( "where_is_he" );
			asked_for_macmillan = true;
		}
	}

	// already left?
	if ( flag( "seaknight_leaves" ) )
		return;
	
	flag_set( "player_made_it_to_seaknight" );
	
	// player flies off into the sunset
	level.player disableweapons();
	// this is the model the player will attach to for the pullout sequence
	ePlayerview = spawn_anim_model( "player_carry" );
	ePlayerview hide();

	// put the ePlayerview in the first frame so the tags are in the right place
	seaknight anim_first_frame_solo( ePlayerview, "wounded_seaknight_putdown", "tag_detach" );
	

	// this smoothly hooks the player up to the animating tag
	ePlayerview lerp_player_view_to_tag( "tag_player", 0.5, 0.9, 35, 35, 45, 0 );

	// now animate the tag and then unlink the player when the animation ends
// 	level.cobrapilot show();
	
	price_spawner = getent( "price_spawner", "targetname" );
	price_spawner.animname = "price";
// 	price_spawner set_start_pos( "wounded_seaknight_putdown", org.origin, org.angles );
	price_spawner.origin = level.player.origin;
	price_spawner.count = 1;

	level.price = price_spawner stalingradspawn();
	spawn_failed( level.price );
	level.price.animname = "price";
	
	guys_animating = [];
	guys_animating[ guys_animating.size ] = ePlayerview;
	guys_animating[ guys_animating.size ] = level.price;
	
	seaknight anim_single( guys_animating, "wounded_seaknight_putdown", "tag_detach" );
	level.price delete();

	/* -- -- -- -- -- -- -- -- -- -- -- - 
	LINK PLAYER TO CURRENT POS TO SEE NUKE
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
	level.player enableweapons();
										// < viewpercentag fraction> , <right arc> , <left arc> , <top arc> , <bottom arc> )
	ePlayerview linkto( seaknight );
	level.player playerlinktodelta( ePlayerview, "tag_player", 1, 20, 45, 5, 25 );
// 	level.player playerlinktodelta( seaknight, "", 1, 20, 45, 5, 25 );
	
}

seaknight_leaving_warning( hangout_time )
{
	level endon( "player_made_it_to_seaknight" );
	wait( hangout_time - 30 );

	// Alpha Team, we're at bingo fuel! You got thirty seconds!
	thread radio_dialogue_queue( "heli_got_thirty_seconds" );
	wait( 30 );
	
	//* Alpha Team, we are too low on fuel. We're outta here.
	thread radio_dialogue_queue( "heli_goodbye" );
	
}


update_objective_position_for_fairground()
{
	level endon( "price_moves_to_position" );
	last_not_here = 0;
	
	for ( ;; )
	{
		flag_waitopen( "price_picked_up" );
		objective_position( 2, level.price.origin );
		thread price_complains_until_he_is_picked_up();
		
		flag_wait( "price_picked_up" );
		objective_position( 2, price_fair_defendspot() );
	}
}

price_complains_until_he_is_picked_up()
{
	level endon( "price_picked_up" );
	level endon( "price_moves_to_position" );
	wait( 0.5 );
	price_putdown_hint_trigger = getent( "price_putdown_hint_trigger", "targetname" );
	
	for ( ;; )
	{
		if ( level.price istouching( price_putdown_hint_trigger ) )
		{
			add_dialogue_line( "MacMillan", "Pick me up and move me a bit farther to the north." );
		}
		else
		{
			add_dialogue_line( "MacMillan", "Pick me up and take me to the hill behind the Ferris wheel." );
		}
		wait( randomfloat( 3, 4 ) );

		if ( level.price istouching( price_putdown_hint_trigger ) )
		{
			add_dialogue_line( "MacMillan", "A bit farther to the north lad, so I can get a clear shot." );
		}
		else
		{
			add_dialogue_line( "MacMillan", "Take me over to the hill so I can get a good shot." );
		}
		wait( randomfloat( 3.5, 5 ) );
	}
}

plant_price()
{
	endpos = physicstrace( level.price.origin + (0,0,2), level.price.origin + (0,0,-100 ), true, level.price );
	level.price teleport( endpos );
}


player_gets_on_barret()
{
	turret2 = getent( "turret2", "targetname" );
	for ( ;; )
	{
		if ( isdefined( turret2 getturretowner() ) )
			break;
		wait( 0.05 );
	}
	
	flag_set( "player_on_barret" );
}

get_ent_with_key_from_array( array, msg, type )
{
	ents = getentarray( msg, type );
	
	for ( i = 0; i < array.size; i++ )
	{
		for ( p = 0; p < ents.size; p++ )
		{
			if ( ents[ p ] == array[ i ] )
				return ents[ p ];
		}
	}
}

go_axis()
{
	self.team = "axis";
}