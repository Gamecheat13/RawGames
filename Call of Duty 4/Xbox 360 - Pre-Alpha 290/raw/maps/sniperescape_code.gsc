#include maps\_utility;
#include animscripts\utility;
#include maps\_vehicle;
#include maps\sniperescape;
#include common_scripts\utility;
#include maps\_anim;

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
	for ( i=0; i < spawners.size; i++ )
	{
		spawner = spawners[i];
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
	thread ai_move_in();
}

chopper_guys_land()
{
	self endon( "death" );
	self waittill( "jumpedout" );

	if( flag( "player_defends_heat_area" ) )
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
	if( !isalive( self ) )
		return;

	if ( not_move_in_guy() )
		return;
			
	self endon( "death" );
	self notify( "stop_going_to_node" );
	
	if( isdefined( self.target ) )
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
	for( ;; )
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
//	assertex( isdefined( self.script_linkto ), "Trigger at " + self.origin + " had no script_linkto" );
	if( !isdefined( self.script_linkto ) )
		return;
		
	links = strtok( self.script_linkto, " " );
	assertex( links.size > 0, "Trigger at " + self.origin + " had no script_linktos" );
	array_levelthread( links, ::add_trigger_to_debounce_list, self );
	
	self waittill( "trigger" );
	// only delete triggers on the first touch because its redundant to do it mulitple times.
	array_levelthread( links, ::delete_trigger_with_linkname );
	array_levelthread( links, ::turn_off_triggers_from_links, 3 );
	
	for( ;; )
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
	if( !isdefined( trigger ) )
		return;
		
	// debounce triggers arent required to have a script_linkto
	if( isdefined( trigger.script_linkto ) )
	{
		links = strtok( trigger.script_linkto, " " );
		array_levelthread( links, ::remove_trigger_from_debounce_lists, trigger );
		trigger trigger_off();
	}
}

add_trigger_to_debounce_list( link, trigger )
{
	if( !isdefined( level.debounce_triggers[ link ] ) )
		level.debounce_triggers[ link ] = [];
		
	level.debounce_triggers[ link ][ level.debounce_triggers[ link ].size ] = trigger;
}

remove_trigger_from_debounce_lists( link, trigger )
{
	// use getarraykeys because we set indicies of the array to undefined
	keys = getarraykeys( level.debounce_triggers[ link ] );
	for( i = 0; i < keys.size; i++ )
	{
		key = keys[ i ];
		if( level.debounce_triggers[ link ][ key ] != trigger )
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
	if( isdefined( level.engagement_dist_func[ self.classname ] ) )
	{
		[ [ level.engagement_dist_func[ self.classname ] ] ]();
	}
	else
	{
		return;
	}

	self endon( "death" );
	// got an enemy yet?
	self waittill( "enemy" );
	for( ;; )
	{
		wait( randomfloat( 5, 8 ) );
		if( !isdefined( self.node ) )
			continue;
			
		if( !isdefined( self.enemy ) )
			continue;

		if( distance( self.origin, self.node.origin ) > 128 )
			continue;

		new_min_dist = self.engagemindist - 150;
		new_min_falloff = self.engageminfalloffdist - 150;
		new_max_dist = self.engagemaxdist - 150;
		new_max_falloff = self.engagemaxfalloffdist - 150;
		
		if( new_min_dist < start_min_dist )
			new_min_dist = start_min_dist;
		if( new_min_falloff < start_min_falloff )
			new_min_falloff = start_min_falloff;
		if( new_max_dist < start_max_dist )
			new_max_dist = start_max_dist;
		if( new_max_falloff < start_max_falloff )
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
	for( ;; )
	{	
		while( self.movemode != "run" )
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
	ent.count++;
	self waittill( "death" );
	ent.count--;
	
	if( ent.count <= 1 )
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
	if( !isdefined( level.flag[ start_flag ] ) )
	{
		flag_init( start_flag );
	}

	if( !isdefined( level.flag[ stop_flag ] ) )
	{
		flag_init( stop_flag );
	}
	
	array_thread( spawners, ::add_spawn_function, ::chase_friendlies );
	
	// spawn guys if the enemy count gets too low and the right flags are set
	for( ;; )
	{
		flag_waitopen( stop_flag );

		count = getaiarray( "axis" ).size;
		if( count > 14 )
		{
			// random wait to vary which spawners are used
			wait( randomfloatrange( 1, 2 ) );
			continue;
		}
		
		flag_wait( start_flag );

		if( flag( stop_flag ) )
			continue;

		// vary up the guys that actually spawn			
		new_spawners = array_randomize( spawners );
		spawn_limited_number_from_spawners( new_spawners, new_spawners, 4, 1 );
		/*
		total_dogs = getaiSpeciesArray( "axis", "dog" ).size;
		for( i=0; i < new_spawners.size * 0.75; i++ )
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
	for( i=0; i < targs.size; i++ )
	{
		if( targs[ i ] == selected )
			continue;
		targs[ i ] delete();
	}
}

objective_position_update( num )
{
	level endon( "stop_updating_objective" );
	for( ;; )
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
	
	for( ;; )
	{
		wait( 0.05 );
		ai = getaiarray( "axis" );
		dot_ai = [];
		
		// close guys get high accuracy
		for( i=0; i < ai.size; i++ )
		{
			if( distance( level.player.origin, ai[ i ].origin ) < 500 )
			{
				// even the accurate guys get close accuracy
				ai[ i ].baseaccuracy = 0.2;
				continue;
			}
			
			dot_ai[ dot_ai.size ] = ai[ i ];
		}

	    player_angles = level.player GetPlayerAngles();
	    player_forward = anglesToForward( player_angles );

		if( !dot_ai.size )
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

		for( i=0; i < ai.size; i++ )
		{
			guy = ai[ i ];
			normal = vectorNormalize( guy.origin - level.player.origin );
			dot = vectorDot( player_forward, normal );
//			print3d( guy.origin +( 0, 0, 64 ), dot + " " + guy.finalaccuracy, ( 1, 1, 0.3 ), 1 );

			guy.dot = dot;
			get_accuracy_result = dot > 0.8;
			guys[ get_accuracy_result ][ guys[ get_accuracy_result ].size ] = guy;
			if( dot < lowest_dot )
			{
				lowest_dot = dot;
				lowest_dot_guy = guy;
			}
		}
		
		for( i=0; i < guys[ GET_ACCURACY ].size; i++ )
		{
			// guys you're looking at get a little accuracy
			guys[ GET_ACCURACY ][ i ].baseAccuracy = 0.4;
		}

		for( i=0; i < guys[ LOSE_ACCURACY ].size; i++ )
		{
			guys[ LOSE_ACCURACY ][ i ].baseAccuracy = 0;
			guys[ LOSE_ACCURACY ][ i ].threatbias = 0;
		}
		
		if( isdefined( lowest_dot_guy ) )
		{
//			lowest_dot_guy.threatbias = 10000;
		}
		

		thread new_enemy_callout( ai );
	
//		angles = vectorToAngles( target_origin - other.origin );
//	    forward = anglesToForward( angles );
//		draw_arrow( level.player.origin, level.player.origin + vectorscale( forward, 150 ), ( 1, 0.5, 0 ) );
//		draw_arrow( level.player.origin, level.player.origin + vectorscale( player_forward, 150 ), ( 0, 0.5, 1 ) );


	}
}

ai_is_near_teammates( dist )
{
	ai = getaiarray( self.team );
	for( i=0; i < ai.size; i++ )
	{
		if( ai[ i ] == self )
			continue;
		if( distance( self.origin, ai[ i ].origin ) <= dist )
			return true;
	}
	return false;
}

new_enemy_callout( ai )
{
	if( gettime() < level.next_enemy_call_out )
		return;
	
	if( !isalive( level.price ) )
		return;
	
	near_dist = level.callout_near_dist;

	// first try to find a guy outside the fov
	for( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if( !( guy cansee( level.player ) ) )
			continue;
		
		if( guy.dot >= 0.2 ) 
			continue;
		
		if( !( guy ai_is_near_teammates( near_dist ) ) )
			continue;

		price_calls_out_guy( guy );
		return;
	}

	// ok just call out whoever then
	for( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if( !( guy cansee( level.player ) ) )
			continue;

		if( !( guy ai_is_near_teammates( near_dist ) ) )
			continue;

		guy = ai[ i ];
		price_calls_out_guy( guy );
		return;
	}
}

price_calls_out_guy( guy )
{
	level notify( "price_sees_enemy" );
	if ( !flag( "price_cuts_to_woods" ) )
		return;
		
	
	triggers = getentarray( "incoming_trigger", "targetname" );
	enemy_location = "enemies";
	for( i=0; i < triggers.size; i++ )
	{
		if( guy istouching( triggers[ i ] ) )
		{
			enemy_location = triggers[ i ].script_area;
			break;
		}
	}

	direction = animscripts\battlechatter::getDirectionCompass( level.player.origin, guy.origin );

	if( direction == level.last_callout_direction )
		return;

	level.last_callout_direction = direction;
	
	level.next_enemy_call_out = gettime() + randomfloatrange( 4500, 6500 );
		
	// calls out enemy position
	level.price anim_single_queue( level.price, enemy_location + "_" + direction );
		
}

player_hit_debug()
{
	level.player endon( "death" );
	for( ;; )
	{
		level.player waittill( "damage", amount, attacker, three, four, five, six, seven );
		if( !isdefined( attacker ) )
			continue;
		/#
		println( "Attacked by " + attacker getentnum() + " at distance " + distance( level.player.origin, attacker.origin ) + " with base accuracy  " + attacker.baseaccuracy + " and final accuracy " + attacker.finalaccuracy );
		#/
	}
}

delete_living()
{
	if( isalive( self ) )
		self delete();
}

run_thread_on_targetname( msg, func, param1, param2, param3 )
{
	array = getentarray( msg, "targetname" );
	array_thread( array, func, param1, param2, param3 );
}

run_thread_on_noteworthy( msg, func, param1, param2, param3 )
{
	array = getentarray( msg, "script_noteworthy" );
	
	array_thread( array, func, param1, param2, param3 );
}

heli_attacks_start()
{
	heli = spawn_vehicle_from_targetname_and_drive( "heli_attacks_start" );
	heli helipath( heli.target, 70, 70 );
}

heli_trigger()
{
	helis = [];
	if( isdefined( self.target ) )
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

	for( i=0; i < helis.size; i++ )
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
	if( isdefined( self.script_delay ) )
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

	while( !isdefined( self.enemy ) )
	{
		wait( 0.05 );
	}

	self.disableArrivals = false;

	delete_wounding_sight_blocker();
	
	animscripts\init::set_anim_playback_rate();
	self clear_run_anim();
	self.walkdist = 16;
	self.goalradius = 512;

	for( ;; )
	{
		if( isalive( self.enemy ) )
			self setgoalpos( self.enemy.origin );
		wait( 5 );
	}
}



delete_wounding_sight_blocker()
{
	if( flag( "wounding_sight_blocker_deleted" ) )
		return;
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();
	flag_set( "wounding_sight_blocker_deleted" );
}

player_touches_wounded_blocker()
{
	if( flag( "wounding_sight_blocker_deleted" ) )
		return;

	level endon( "wounding_sight_blocker_deleted" );		
	flag_wait( "player_touches_wounding_clip" );
	delete_wounding_sight_blocker();
}

countdown( timer )
{
	hudelem = newHudElem();
	hudelem.location = 0;
	hudelem.alignX = "center";
	hudelem.alignY = "middle";
	hudelem.foreground = 1;
	hudelem.fontScale = 2;
	hudelem.sort = 20;
	hudelem.alpha = 1;
	hudelem.x = 100;
	hudelem.y = 50;
	
	countdown = 20*60;
	if( isdefined( timer ) )
		countdown = timer * 60;
	
	hudelem.label = "Time Remaining: "; // + minutes + ":" + seconds
	hudelem settenthstimer( countdown );

	flag_wait_or_timeout( "beacon_placed", countdown );
	if ( !flag( "beacon_placed" ) )
	{
		setdvar( "ui_deadquote", "You failed to reach the evac point in time" );
		maps\_utility::missionFailedWrapper();
		return;
	}
	
	hudelem destroy();

//	countdown = 4*60;
//	hudelem settenthstimer( countdown );
}


defend_heat_area_until_enemies_leave()
{
	level endon( "heat_area_cleared" );
	price_death_org = getent( "price_death_org", "targetname" ).origin;
	flee_node = getnode( "enemy_flee_node", "targetname" );
	fight_distance = 1250;

	for( ;; )
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
	for( ;; )
	{
		// price dies if left unattended before its time to move on
		thread price_heat_death();
		
		ai = getaiSpeciesArray( "axis", "all" );
		ai = get_array_of_closest( price_death_org, ai );

		max_fighters = 5;
		if( ai.size < max_fighters )
			max_fighters = ai.size;
			
		// send all but the 5 closest that are within fight_distance fleeing
		for( i=0; i < max_fighters; i++ )
		{
			if( distance( ai[ i ].origin, price_death_org ) > fight_distance )
			{
				ai[ i ] thread flee_heat_area( flee_node );
			}
		}
		
		for( i = max_fighters; i < ai.size; i++ )
		{
			ai[ i ] thread flee_heat_area( flee_node );
		}
		
		/*
		ai = get_outside_range( price_death_org.origin, ai, fight_distance );
		array_thread( ai, ::flee_heat_area, flee_node );
		for( i = 5; i < ai.size; i++ )
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
	for( ;; )
	{
		wait( 1 );
		if( distance( level.price.origin, price_death_org ) > 200 )
			continue;
		
		ai = getaiSpeciesArray( "axis", "all" );
		guy = get_closest_living( price_death_org, ai );
		if( !isalive( guy ) )
		{
			flag_set( "heat_area_cleared" );
			return;
		}			
			
		if( distance( guy.origin, price_death_org ) > fight_distance )
		{
			flag_set( "heat_area_cleared" );
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
	for( ;; )
	{
		flag_wait( "price_dies_unattended" );
		
		if( !( level.price istouching( trigger ) ) )
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
	if( isalive( level.price ) )
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
//	wait( 2 );
	self maps\_helicopter_globals::fire_missile( "seeker", 3, target, .75);
	wait( 5 );
	missile_deleteAttractor(attractor);
	/*
	self setVehWeapon( "cobra_seeker" );
	offset = ( 0, 0, 0 );
	self fireWeapon( "tag_store_L_2_a", target, offset ); // tag_light_L_wing
	wait( 0.2 );
	self fireWeapon( "tag_store_L_2_b", target, offset ); // tag_light_L_wing
	wait( 0.2 );
	self fireWeapon( "tag_store_L_2_c", target, offset ); // tag_light_L_wing
	*/
}

kills_enemies_then_wounds_price_then_leaves()
{
	level endon( "price_was_hit_by_heli" );
	level.price thread price_heli_hit_detection();
	kill_all_visible_enemies();
	flag_set( "price_heli_moves_on" );

	self setturrettargetent( level.price );
//	heli startfiring();
	heli_fires();
//	wait_for_script_noteworthy_trigger( "price_exits_apartment" );
//	wait( 2 );
//	flag_set( "heli_attacks_price" );
}

heli_fires()
{
	self endon( "stop_firing_weapon" );
	for( ;; )
	{
		self fireweapon();
		wait( 0.10 );
	}
}

price_heli_hit_detection()
{
	for( ;; )
	{
		level.price waittill( "damage", amt, attacker );
		if( isdefined( attacker ) && attacker == level.price_heli )
			break;
	}
	
	flag_set( "price_was_hit_by_heli" );
}

can_see_from_array( array )
{
	for( i=0; i < array.size; i++ )
	{
		if( bullettracepassed( self.origin, array[ i ].origin +( 0, 0, 64 ), false, self ) )
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

kill_all_visible_enemies()
{
	for( ;; )
	{
		ai = getaiarray( "axis" );
		ai = remove_drivers_from_array( ai );
		guy = can_see_from_array( ai );
		if( !isalive( guy ) )
			return;

		guy thread die_soon();
		while( isalive( guy ) )
		{
			self setturrettargetent( guy, randomvector( 15 ) +( 0, 0, 16 ) );
			self fireweapon();
			wait( 0.15 );
		}
	}
}

kill_all_visible_enemies_forever()
{
	self endon( "stop_killing_enemies" );
	self endon( "death" );
	for( ;; )
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
	
	for ( i = 0; i < array.size; i ++ )
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

	old_org = (0,0,0);
	
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
			level.price thread anim_single_solo( level.price, "wounded_turn_right" );
		else
			level.price thread anim_single_solo( level.price, "wounded_turn_left" );
		wait( 1 );
		
		didanim = true;
	}
	
	if ( isdefined( grenade ) )
	{
//		level.price anim_single_solo( level.price, "wounded_crawl_start" );
		for ( ;; )
		{
			if ( !isdefined( grenade ) )
				break;
			
			if ( distance( grenade.origin, level.price.origin ) > grenade_dist )
				break;
				
			didanim = true;
			level.price anim_custom_animmode_solo( level.price, "gravity", "wounded_crawl" );
		}
		
//		level.price anim_single_solo( level.price, "wounded_crawl_end" );
	}
	
	assertex( didanim, "Had to have done an anim by now!" );
	level.price thread anim_loop_solo( level.price, "wounded_idle", undefined, "stop_loop" );
}


price_picks_target()
{
	level.callout_near_dist = 50000;
	
	// in case we're using a start point
	flag_set( "price_cuts_to_woods" );
	
	price_flees_grenades();
	
	/*
	// put in better indexed array so we don't have to do a bunch of ifs later
	ai_array = [];
	for( i=0; i < ai.size; i++ )
	{
		ai_array[ ai[ i ].ai_number ] = ai[ i ];
	}
	*/

    price_forward = anglesToForward( ( 0, level.price.angles[ 1 ], 0 ) );

//		ai = get_not_in_pain( ai );
	ai = getaiSpeciesArray( "axis", "all" );
	array = get_array_within_fov( level.price.origin, price_forward, ai, 0.707 );

	ai = array[ true ];
	outside_fov_ai = array[ false ];

	
	if ( !ai.size )
	{
		if ( outside_fov_ai.size > 0 )	
		{
			thread new_enemy_callout( outside_fov_ai );
			guy = outside_fov_ai[ 0 ]; // the guy with the highest dot
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
	for( i = 0; i < keys.size; i++ )
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
	
	ent = spawn( "script_origin", (0,0,0) );
	ent linkto( guy, "TAG_EYE", (0,0,0), (0,0,0) );

	level.price.targetorg = ent;
	level.price setentitytarget( ent );
	level.price_target_point = guy geteye();
	ent endon( "death" );
	
	// cleanup on pickup/placement of price
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
		level.price anim_single_solo( level.price, "wounded_turn_right" );
	}
	else
	{
		// turns_left
		level.price anim_single_solo( level.price, "wounded_turn_left" );
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
	for( i=0; i < ai.size; i++ )
	{
		if( ai[ i ] isdog() )
			guys[ guys.size ] = ai[ i ];
		else
		if( ai[ i ].a.script != "pain" )
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
	for ( i = 0; i < array.size; i ++ )
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
	
	
	for( i=0; i < ai.size; i++ )
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
	
	for ( i = 0; i < timer; i ++ )	
	{
		line( pos1, pos2, color );
		wait( 0.05 );
	}
}

get_cantrace_array( ai )
{
	guys = [];
	eyepos = self geteye();
	for( i=0; i < ai.size; i++ )
	{
		if( !( bullettracepassed( eyepos, ai[ i ] geteye(), false, undefined ) ) )
		{
//			thread line_for_time( eyepos, ai[ i ] geteye(), ( 1, 0, 0 ), 0.5 );
			continue;
		}
			
//		thread line_for_time( eyepos, ai[ i ] geteye(), ( 0, 1, 0 ), 0.5 );
		guys[ guys.size ] = ai[ i ];
	}

	return guys;		
}

get_canshoot_array( ai )
{
	guys = [];
	myGunPos = self GetTagOrigin( "tag_flash" );
	myEyeOffset = ( self getShootAtPos() - myGunPos );
	
	for( i=0; i < ai.size; i++ )
	{
		if ( !( self canshoot( ai[ i ], myEyeOffset ) ) )
		{
//			thread line_for_time( eyepos, ai[ i ] geteye(), ( 1, 0, 0 ), 0.5 );
			continue;
		}
			
//		thread line_for_time( eyepos, ai[ i ] geteye(), ( 0, 1, 0 ), 0.5 );
		guys[ guys.size ] = ai[ i ];
	}

	return guys;		
}

get_cansee_array( ai )
{
	guys = [];
	for( i=0; i < ai.size; i++ )
	{
		if( !( self cansee( ai[ i ] ) ) )
			continue;
			
		guys[ guys.size ] = ai[ i ];
	}

	return guys;		
}

		
idle_until_price_has_target()
{
	level.price endon( "death" );
	level.price notify( "stop_loop" );
	// he may be looping from turning during the pick-target phase, so we need to make sure that loop has stopped before we start a new one
	waittillframeend;
	
	level.price thread anim_loop_solo( level.price, "wounded_idle", undefined, "stop_loop" );
	for( ;; )
	{
		if( price_picks_target() )
			break;
		
		wait( 0.1 );
	}
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
		line ( level.price geteye(), enemy geteye(), ( 1, 0, 1 ) );
		wait( 0.05 );
	}
}

price_fends_off_attacker( enemy )
{
	if ( !isalive( enemy ) )
		return;
	enemy endon( "death" );
	thread line_to_guy( enemy );

	for ( ;; )
	{	
		forward = anglestoforward( level.price.angles );
		normal = vectorNormalize( enemy.origin - level.price.origin );
		dot = vectorDot( forward, normal );
		
		if ( dot < 0.8 )
		{
			if ( level.price should_turn_right( enemy ) )
				level.price thread anim_single_solo( level.price, "wounded_turn_right" );
			else
				level.price thread anim_single_solo( level.price, "wounded_turn_left" );
			wait( 1.2 );
			continue;
		}
		
		thread price_targets_guy( enemy );


		if ( !level.price.on_target )
		{
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
				level.price anim_custom_animmode_solo( level.price, "gravity", "wounded_crawl" );
		}
	}	
}

price_fights_enemies()
{
	level.price endon( "death" );
	level.price endon( "damage" );

	for ( ;; )
	{
		// keep shooting as long as we can acquire a target
		level.price waittill_notify_or_timeout( "on_target", 2 );

		timer = distance( level.price_target_point, level.price.origin );
		timer -= 400;
		timer *= 0.004;
		if ( timer < 0.15 )
			timer = 0.15;
		wait( randomfloatrange( 0.1, timer ) );
		
		if ( gettime() < level.price.first_shot_time )
		{
			// wait until we're allowed to shoot
			wait ( ( level.price.first_shot_time - gettime() ) * 0.001 );
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
	for( i=0; i < steps; i++ )
	{
		angles =( -25, i * chunks, 0 );
		forward = anglestoforward( angles );
		endpos = org + vectorscale( forward, 25 );
		if( !bullettracepassed( org, endpos, true, undefined ) )
		{
			/#
			if( debug_lines )
				line( org, endpos, ( 1, 0, 0 ) );
			#/
			return false;
		}
		/#
		if( debug_lines )
			line( org, endpos, ( 0, 1, 0 ) );
		#/
	}
	return true;
}

upwards_normal( normal )
{
	if( abs( normal[ 0 ] ) > 0.1 )
		return false;
	if( abs( normal[ 1 ] ) > 0.1 )
		return false;
	return( normal[ 2 ] >= 0.9 );
}


wait_for_player_to_drop_price( trigger )
{
	trigger endon( "trigger" );
	for( ;; )
	{
		debug_lines = false;
		/#
		debug_lines = getdebugdvar( "debug_drop_price" ) == "on";
		#/
		trigger.origin =( 0, 0, -1500 );
		eyepos = level.player geteye();
		angles = level.player getplayerangles();
		pitch = angles[ 0 ] + 15;
		if( pitch > 54 )
			pitch = 54;
		if( pitch < 40 )
			pitch = 40;
		level.pitch = pitch;
		angles =( pitch, angles[ 1 ], 0 );
		forward = anglestoforward( angles );
		endpos = eyepos + vectorscale( forward, 500 );
		
		trace = bullettrace( eyepos, endpos, true, level.player );
		level.price_trace = trace;
		if( distance( level.player.origin, trace[ "position" ] ) > 100 )
		{
			/#
			if( debug_lines )
				print3d( trace[ "position" ], ".", ( 1, 0.5, 0 ), 1, 2 );
			#/
				
			wait( 0.05 );
			continue;
		}
		
		if( !upwards_normal( trace[ "normal" ] ) )
		{
			/#
			if( debug_lines )
				print3d( trace[ "position" ], ".", ( 1, 0, 0 ), 1, 2 );
			#/
			wait( 0.05 );
			continue;
		}
		
		if( !area_is_clear( trace[ "position" ], debug_lines ) )
		{
			/#
			if( debug_lines )
				print3d( trace[ "position" ], ".", ( 1, 1, 0 ), 1, 2 );
			#/
			wait( 0.05 );
			continue;
		}

		trigger.origin = level.player.origin;

		/#
		if( debug_lines )
			print3d( trace[ "position" ], ".", ( 0, 1, 0 ), 1, 2 );
		#/
		wait( 0.05 );
	}
}



price_wounded_logic()
{
	level.player endon( "dog_attacks_player" );
	level.price stop_magic_bullet_shield();
	level.price wounded_setup();

	for( ;; )
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
	thread price_calls_out_kills();
	level.price thread price_aims_at_his_enemy();
	
	level.price endon( "trigger" );
	level.price endon( "death" );
	for( ;; )
	{
		idle_until_price_has_target();
		fight_until_price_has_no_target();
	}
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
		for ( i=0; i<1; i+=0.05 )
		{
			self setAnim( left, i, .05 );
			self setAnim( right, 1-i, .05 );
			wait( 0.05 );
		}
		for ( i=0; i<1; i+=0.05 )
		{
			self setAnim( right, i, .05 );
			self setAnim( left, 1-i, .05 );
			wait( 0.05 );
		}
	}
	*/
	for ( ;; )
	{
//		if ( !isalive( self.enemy ) )
		if ( !isdefined( level.price_target_point ) )
		{
			wait( 0.05 );
			continue;
		}
	
//		pos = level.player.origin;	
		pos = level.price_target_point;
//		aimyaw = self getYawToEnemy();
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

		// the animations cover from -45 to 45 degrees		
		if ( aimyaw < -45.0 )
			aimyaw = -45.0;
		if ( aimyaw > 45.0 )
			aimyaw = 45.0;

//		level.aimyaw = aimyaw;

		weight = aimyaw / 90;

		// now the weight is 0 to 1
		weight += 0.5;

//		level.weight = weight;	
		self setAnim( left, 1 - weight, 0.05 );
		self setAnim( right, weight, 0.05 );
		
		prevyaw = aimyaw;
		
		wait .05;
	}
	
}

price_calls_out_kills()
{
	level.price endon( "death" );
	level.price endon( "trigger" );
	for( ;; )
	{
		if( isalive( level.price.enemy ) )
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
	if( isalive( enemy ) )
		return;
		
	// he's already talking about something else so skip the kill call out
	if( isdefined( level.price._anim_solo_queue ) )
		return;
	
	// dont call out deleted guys
	if ( !isdefined( enemy ) )
		return;
	price_calls_out_a_kill();
	wait( 2 );
}

price_calls_out_a_kill()
{
	lines = [];
	
	// got one
	lines[ lines.size ] = "got_one";

	// tango down
	lines[ lines.size ] = "tango_down";
	
	// he's down
	lines[ lines.size ] = "he_is_down";
	
	// got another
	lines[ lines.size ] = "got_another";

	// Target neutralized.	
	lines[ lines.size ] = "target_neutralized";
	
	// got him
	lines[ lines.size ] = "got_him";

	the_line = random( lines );
	level.price thread anim_single_queue( level.price, the_line );
}

player_loses_if_price_dies()
{
	level.price endon( "trigger" );
	level.price waittill( "death" );
	price_dies();
}

price_dies_if_player_goes_too_far()
{
	if ( flag( "price_can_be_left" ) )
		return;

	level endon( "price_can_be_left" );
	
	level.price endon( "death" );
	level.price endon( "trigger" );
	
	for( ;; )
	{
		if( distance( level.player.origin, level.price.origin ) > 1000 )
		{
			break;
		}
		wait( 1 );
	}

	// Leftenant Price! Don't get too far ahead.	
	level.price anim_single_queue( level.price, "dont_go_far" );
	
	for( ;; )
	{
		if( distance( level.player.origin, level.price.origin ) > 1500 )
		{
			price_dies();
			return;
		}
		wait( 1 );
	}
	

}

draw_player_viewtag()
{
	for( ;; )
	{
		maps\_debug::drawArrow( level.player.origin, level.player getplayerangles() );
		wait( 0.05 );
	}
}

drop_to_floor()
{
	trace = bullettrace( self.origin +( 0, 0, 32 ), self.origin, false, undefined );
	self.origin = trace[ "position" ];
}

player_picks_up_price()
{
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

	wait( 0.1 ); // wait for the models tags to actually get in position	

	// move the animation up if it would put the player in the ground
	tag_player_origin = model getTagOrigin( "tag_player" );
	trace = bullettrace( tag_player_origin +( 0, 0, 32 ), tag_player_origin, false, undefined );
	if ( trace[ "fraction" ] < 1 )
	{
		org.origin += trace[ "position" ] - tag_player_origin;
	
		// change the model's position to the new, not stuck in ground position
		model set_start_pos( "wounded_pickup", org.origin, org.angles );
	}
	
	// this smoothly hooks the player up to the animating tag
	model lerp_player_view_to_tag_and_hit_geo( "tag_player", 0.5, 1.0, 0, 0, 0, 0 );

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
	
	thread price_talks_as_he_is_picked_up();
	org anim_single( price_pickup_elements, "wounded_pickup" );

	trace = bullettrace( level.player.origin +( 0, 0, 32 ), level.player.origin, false, undefined );
	if( trace[ "fraction" ] < 1 )
	{
		model moveto( model.origin +( trace[ "position" ] - level.player.origin ), 0.1 );
		wait( 0.1 );
	}
	
	level.player unlink();
	org delete();
	model delete();
	
	level.player setorigin( original_player_org );

}

player_puts_down_price()
{
	
	level.player endon( "dog_attacks_player" );
	level.price notify( "stop_loop" );
	org = spawn( "script_origin", ( 0, 0, 0 ) );
//	price_spawner.origin = level.price_trace[ "position" ];
	org.origin = level.price_trace[ "position" ];
	org.angles = level.player.angles;
	
	org drop_to_floor();	
	
	// this is the player's rig for the sequence
	model = spawn_anim_model( "player_carry" );
	model hide();

	// put the model in the first frame so the tags are in the right place
	org anim_first_frame_solo( model, "wounded_putdown" );

	wait( 0.1 ); // wait for the models tags to actually get in position	

	// move the animation up if it would put the player in the ground
	tag_player_origin = model getTagOrigin( "tag_player" );
	trace = bullettrace( tag_player_origin +( 0, 0, 32 ), tag_player_origin, false, undefined );
	if ( trace[ "fraction" ] < 1 )
	{
		org.origin += trace[ "position" ] - tag_player_origin;
	
		// change the model's position to the new, not stuck in ground position
		model set_start_pos( "wounded_putdown", org.origin, org.angles );
	}
	
	// this smoothly hooks the player up to the animating tag
	model lerp_player_view_to_tag_and_hit_geo( "tag_player", 0.5, 1.0, 0, 0, 0, 0 );
	model show();

	original_player_org = level.player.origin;

	price_spawner = getent( "price_spawner", "targetname" );

	price_spawner.animname = "price";
	price_spawner set_start_pos( "wounded_putdown", org.origin, org.angles );
	
	price_spawner.count = 1;

	level.price = price_spawner stalingradspawn();
	spawn_failed( level.price );
	level.price.animname = "price";
	level.price wounded_setup();
	

	price_pickup_elements = [];
	price_pickup_elements[ price_pickup_elements.size ] = model;
	price_pickup_elements[ price_pickup_elements.size ] = level.price;
	
	thread price_talks_as_he_is_picked_up();
	
	org anim_single( price_pickup_elements, "wounded_putdown" );

	/*
	trace = bullettrace( level.player.origin +( 0, 0, 32 ), level.player.origin, false, undefined );
	if( trace[ "fraction" ] < 1 )
	{
		// push the player up if he's in the ground
		model moveto( model.origin +( trace[ "position" ] - level.player.origin ), 0.1 );
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
	
	thread price_asks_to_be_picked_up_when_its_safe();
}

getHealthyEnemies()
{
	ai = getaiSpeciesArray( "axis", "all" );
	
	healthy_enemies = [];
	for( i=0; i < ai.size; i++ )
	{
		if ( isdefined( ai[ i ].drivingVehicle ) )
			continue;
		
		if( !ai[ i ].ignoreForFixedNodeSafeCheck )
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
	putdown_line = "put_down_" + ( randomint( 3 ) + 1 );
	if ( isalive( level.price ) )
	{
		level.price anim_single_queue( level.price, putdown_line );
	}
}

price_talks_if_player_takes_damage()
{
	level endon( "price_dropped" );
	for( ;; )
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
	
	for( ;; )
	{
		ai = getaispeciesarray( "axis", "all" );
		for( i=0; i < ai.size; i++ )
		{
			guy = ai[ i ];
			if( !isalive( guy ) )
				continue;

			if ( !isalive( guy.enemy ) )
				continue;
			
			if( guy cansee( level.player ) )
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
	for( ;; )
	{
		level waittill( "an_enemy_shot", guy );
		if( !isalive( guy ) )
			continue;
		if( guy cansee( level.player ) )
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
	if( cointoss() )
		radio_dialogue_queue( "put_me_down_1" );
	else
		radio_dialogue_queue( "put_me_down_2" );
		
	wait( 6 );
}

player_unlinks_if_dogged()
{
	level endon( "price_dropped" );
	level.player waittill( "dog_attacks_player" );
	level.player unlink();
}

wounded_combat_trigger()
{
	self waittill( "trigger" );
	targets = getentarray( self.target, "targetname" );
	
	if ( !targets.size )
		return;
	
	wait( 1.35 );
//	price_asks_to_be_put_down();
	price_talks_if_enemies_get_near();

}

player_carries_price_until_he_drops_him()
{
	level.price notify( "price_stops_aiming" );
	level.player endon( "dog_attacks_player" );
	thread player_unlinks_if_dogged();
	set_objective_pos_to_extraction_point();

	if( !isalive( level.price ) )
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
	// so boring without! hmmmm
	level.player allowsprint( true );
	level.player allowjump( true );
	#/
	
	player_picks_up_price(); // relative
	flag_set( "price_picked_up" );

	// poof!
	level.price delete();
	
//	thread price_talks_if_player_takes_damage();
//	thread price_talks_if_enemies_are_near();
	
//	level.player thread take_away_player_ammo();
//	level.player hideviewmodel();
	
	trigger = getent( "price_drop_trigger", "targetname" );
	trigger sethintstring( "Hold &&1 to put Cpt. MacMillan down." );
	wait_for_player_to_drop_price( trigger );
	trigger.origin =( 0, 0, -1500 );

	flag_clear( "price_picked_up" );
	level notify( "price_dropped" );

//	level.player give_back_player_ammo();
//	level.player showviewmodel();

	player_puts_down_price();
	
	if ( !isalive( level.price ) )
	{
		price_dies();
		level waittill( "foreverevervever" );
	}
	
	level.player give_back_weapons();
}

give_back_weapons()
{
	self enableweapons();
	if( 1 ) return;
	level.player notify( "stop_taking_away_ammo" );
	weapons = self.heldweapons;
	for( i=0; i < weapons.size; i++ )
	{
		weapon = weapons[ i ];
		self giveweapon( weapon );
		self SetWeaponAmmoClip( weapon, self.stored_ammo[ weapon ] );
	}
}

take_weapons()
{
	self disableweapons();
	if( 1 ) return;
	self endon( "stop_taking_away_ammo" );	
	self.heldweapons = self getweaponslist();
	self.stored_ammo = [];
	for( i=0; i < self.heldweapons.size; i++ )
	{
		weapon = self.heldweapons[ i ];
		self.stored_ammo[ weapon ] = self getWeaponAmmoClip( weapon );
	}

	for( ;; )
	{
		self takeallweapons();
		wait( 0.05 );
	}
}

take_away_player_ammo()
{
	self endon( "stop_taking_away_ammo" );	
	for( ;; )
	{
		weapons = self getweaponslistprimaries();
		for( i=0; i < weapons.size; i++ )
		{
			self setweaponammoclip( weapons[ i ], 0 );
		}
		wait( 0.05 );
	}
}

give_back_player_ammo()
{
	weapons = self getweaponslistprimaries();
	for( i=0; i < weapons.size; i++ )
	{
		self givestartammo( weapons[ i ] );
	}
}


wounded_setup()
{
	level.last_callout_direction = "";
	level.next_enemy_call_out = 0;
//	level.price.threatbias = 50000;
	level.price setcandamage( false );
	
	level.price.first_shot_time = gettime() + 2200;

	level.price.deathanim = level.price getanim( "wounded_death" );
	level.price.useable = true;
	level.price.baseaccuracy = 1000;
	level.price animscripts\shared::placeWeaponOn( "m14_scoped", "right" );
	
	// so he doesn't shoot straight down the gun
	level.price.dontShootStraight = true;
	level.price.health = 134123; // 750;
	level.price.allowdeath = true;
	level.price thread regen();

	level.price sethintstring( "Hold &&1 to pick up Cpt. MacMillan" );
	
	level.price setthreatbiasgroup( "price" );
}

regen()
{
	self endon( "death" );
	for( ;; )
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
	self.health = 134123; // 750;
}

price_fires( price )
{
	// price calls this function from a notetrack when he shoots
//	MagicBullet( level.price.weapon, level.price gettagorigin( "tag_flash" ), level.price_target_point );
	
//	animscripts\utility::shootEnemyWrapper_normal();

	self.a.lastShootTime = gettime();
	self shoot( 0.25, level.price_target_point + randomvector( 7 ) );
}

enemy_spawn_zone()
{
	assertex( isdefined( self.script_linkto ), "Zone trigger at " + self.origin + " had no script linkto" );
	targets = strtok( self.script_linkto, " " );
	array = [];
	for( i=0; i < targets.size; i++ )
	{
		spawner = getent( targets[ i ], "script_linkname" );
		if( isdefined( spawner ) )
		{
			array[ array.size ] = spawner;
		}
	}
	
	self.zone_spawners = array;
	
	// figure out which zone is the correct zone
	for( ;; )
	{
		self waittill( "trigger" );
		if( isdefined( level.zone_trigger ) )
			continue;
		
		level.zone_trigger = self;
		while( level.player istouching( self ) )
		{
			wait( 0.05 );
		}
		level.zone_trigger = undefined;
	}
}

chase_friendlies()
{
	if( isdog() )
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
	for ( i=0; i < spawners.size; i++ )
	{
		spawners[ i ].script_grenades = 0;
	}
//	array_thread( spawners, ::add_spawn_function, ::chase_friendlies );
	index = 0;
	
	// give some time before the first wave spawns
	waittill_either_function( ::player_moves, 600, ::timer, 15 );
	
	for( ;; )
	{
		// stop spawning if the player is in the burnt building
		
		flag_waitopen( "enter_burnt" );
		waittillframeend; // wait for the global spawn function to be reenabled
		if( getaiSpeciesArray( "all", "all" ).size >= 26 )
		{
			wait( 1 );
			continue;
		}
			
		if( !isdefined( level.zone_trigger ) )
		{
			wait( 1 );
			continue;
		}

//		iprintlnbold( "spawning wave" );
		// spawn 2 waves
		for( i=0; i < 2; i++ )
		{
			spawners = array_randomize( spawners );
			index--;
			if( index < 0 || index >= level.zone_trigger.zone_spawners.size )
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
	level.price anim_single_queue( level.price, the_line );
}

wait_until_its_time_to_spawn_another_wave()
{
	// spawn a new wave if there have been no enemies for a certain amount of time, or if the player brings price to a new area
	
	level endon( "time_to_spawn_a_new_wave" );
	thread spawn_wave_if_player_moves_far_with_price();
	waittill_dead_or_dying( "axis" );
	org = getent( "apartment_battle_org", "targetname" );
	if( distance( org.origin, level.player.origin ) < distance( org.origin, level.on_the_run_progress ) )
	{
		// have we gotten closer to the destination?
		autosave_by_name( "on_the_run" );
		level.on_the_run_progress = level.player.origin;
	}

	if( isalive( level.price ) )
	{
		price_asks_to_be_picked_up();
	}
	wait( 14 );
}

spawn_wave_if_player_moves_far_with_price()
{
	level endon( "time_to_spawn_a_new_wave" );
	// if the player makes enough spatial progress, spawn a new wave
	for( ;; )
	{
		if( isalive( level.price ) )
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
	for( ;; )
	{
		if( distance( start_org, level.player.origin ) > 1050 )
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
	for( i=0; i < spawners.size; i++ )
	{
		total_dogs = getaiSpeciesArray( "axis", "dog" ).size;
		if( spawned >= total_to_spawn )
			break;

		// only 1 dog at a time
		if( spawners[ i ] isdog() && total_dogs >= max_dogs_allowed_in_level )
			continue;
		spawners[ i ].origin = spawn_targets[ spawned ].origin;
		spawners[ i ].count = 1;
		spawners[ i ].script_grenades = 0;
		spawners[ i ] dospawn();
		spawned++;
	}
}

dog_attacks_fence()
{
	node = getnode( "dog_fence_node", "targetname" );
	dog_spawner = getent( "fence_dog_spawner", "targetname" );
	
	dog = dog_spawner stalingradspawn();
	if( spawn_failed( dog ) )
		return;
		
	dog.animname = "dog";
	dog.health = 1;
	dog.allowdeath = true;
	dog endon( "death" );

//	node anim_reach_solo( dog, "fence_attack" );
	dog.ignoreme = true;
	node anim_single_solo( dog, "fence_attack" );
	dog.ignoreme = false;
	dog ai_move_in();
}

price_followup_line()
{
	level endon( "price_picked_up" );
	flag_assert( "price_picked_up" );
	
	wait( 3 );

	for( ;; )
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
	return getent( "transponder", "targetname" ).origin;
}

on_the_run_enemies()
{
	self notify( "stop_old_on_the_run_enemies" );
	self endon( "stop_old_on_the_run_enemies" );
	
	self endon( "death" );
	if( isdefined( self.ridingvehicle ) )
	{
		self waittill( "jumpedout" );
	}

	thread ai_move_in();
}

fairground_enemies()
{
	self endon( "death" );
	if( isdefined( self.ridingvehicle ) )
	{
		self waittill( "jumpedout" );
	}

	thread ai_move_in();
}

tracks_ent( target_ent )
{
	self endon( "stop_tracking_weapon" );

	trigger = getent( "pool_trigger", "targetname" );
		
	for( ;; )
	{
//		if( distance( level.player.origin, target_ent.origin ) < 200 )
//		if ( sighttracepassed( self gettagorigin( "tag_barrel" ), level.player geteye(), false, undefined ) )
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
//	target_ent setmodel( "temp" );
	self setturrettargetent( target_ent );

	thread heli_fires();
	thread tracks_ent( target_ent );
	
	for( ;; )
	{
		if( !isdefined( ent.target ) )
			break;
			
		nextent = getent( ent.target, "targetname" );
		timer = distance( nextent.origin, ent.origin ) * 0.0035;
		if( timer < 0.05 )
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
	for( ;; )
	{
		self setturrettargetent( ent );
		angles = vectortoangles( ent.origin - self.origin );
		self setGoalyaw( angles[ 1 ] );
		
		for( ;; )
		{
			forward = anglestoforward(( 0, self.angles[ 1 ], 0 ) );
			normal = vectorNormalize(( ent.origin[ 0 ], ent.origin[ 1 ], 0 ) -( self.origin[ 0 ], self.origin[ 1 ], 0 ) );
			dot = vectorDot( forward, normal );
			if( dot > 0.95 )
				break;
				
			normal = vectorNormalize( ent.origin - lastent.origin );
			progress = vectorDot( forward, normal );
				
			wait( 0.1 );
		}
		
		if( !isdefined( ent.target ) )
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
	for( i = 0; i < helis.size; i++ )
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
//	iprintlnbold( "End of currently scripted level" );
}

player_navigates_burnt_apartment()
{
	nodes = getnodearray( "park_delete_node", "targetname" );
	level endon( "to_the_pool" );
	flag_assert( "to_the_pool" );
	
	for ( ;; )
	{
		flag_wait( "enter_burnt" );
		remove_global_spawn_function( "axis", ::on_the_run_enemies );
		ai = getaispeciesarray( "axis", "all" );
		array_thread( ai, ::fall_back_and_delete, nodes );

		flag_waitopen( "enter_burnt" );
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
	

	if( isdefined( self.ridingvehicle ) )
	{
		self waittill( "jumpedout" );
	}
	
	waittillframeend; // make sure reacquire player pos has started before we kill it
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
//	flag_waitopen( "enemy_choppers_incoming" );
	level.ending_vehicles = [];
	
	delayThread( 0, ::spawn_vehicle_from_targetname_and_create_ref, "ending_bad_heli_1" );
	delayThread( 10, ::spawn_vehicle_from_targetname_and_create_ref, "ending_bad_heli_2" );
	delayThread( 12, ::spawn_vehicle_from_targetname_and_create_ref, "ending_bad_heli_3" );
	delayThread( 16, ::spawn_vehicle_from_targetname_and_create_ref, "ending_bad_heli_4" );

	delayThread( 15.5, ::spawn_vehicle_from_targetname_and_create_ref, "ending_good_heli_1" );
	delayThread( 18, ::spawn_vehicle_from_targetname_and_create_ref, "ending_good_heli_2" );

	wait( 20 );
//	ending_good_heli_1 thread kill_all_visible_enemies_forever();
//	ending_good_heli_2 thread kill_all_visible_enemies_forever();
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
	



//	ending_good_heli_1 setturrettargetent( ending_bad_heli_1 );
//	ending_good_heli_1 thread heli_fires();

//	ending_good_heli_2 setturrettargetent( ending_bad_heli_2 );
//	ending_good_heli_2 thread heli_fires();
	
	wait( 1200 );


//	ending_good_heli_2 setturrettargetent( ending_bad_heli_3 );
//	ending_good_heli_1 setturrettargetent( ending_bad_heli_4 );
}

shoots_down( target )
{
	self setVehWeapon( "cobra_seeker" );
	offset = ( 0, 0, -50 );
	self fireWeapon( "tag_store_L_2_a", target, offset ); // tag_light_L_wing
	wait( 0.2 );
	self fireWeapon( "tag_store_L_2_b", target, offset ); // tag_light_L_wing
	wait( 0.2 );
	self fireWeapon( "tag_store_L_2_c", target, offset ); // tag_light_L_wing

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
	for( ;; )
	{
		self waittill( "trigger", other );
		{
			if ( isalive( other ) )
				other dodamage( other.health + 150, (0,0,0) );
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
	spooky_dog_spawner thread add_spawn_function( ::spooky_dog_spawns );
}

spooky_dog_spawns()
{
	self endon( "death" );
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 0;
	
	trigger = getent( "spooky_dog_trigger", "targetname" );
	
	if ( getdvar( "player_hasnt_been_spooked" ) == "" )
	{
		setdvar( "player_hasnt_been_spooked", "1" );
	}
	else
	{
		self notify( "stop_going_to_node" );
		self.goalradius = 64;
		org = getent( "spooky_haunt", "targetname" ).origin;
		self teleport( org );
		self setgoalpos( org );	
		// dog only comes once
		spooky_deletes_on_trigger( trigger );
		return;
	}
	
	flag_wait( "spooky_waits" );
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
			radio_dialogue_queue( "sweep_the_rooms" );
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
	
	for ( i = 0; i < guys.size; i ++ )
	{
		if ( isalive( guys[ i ] ) )
			guys[ i ] waittill( "death" );
	}
}

door_opens( mod )
{
	self playsound ("wood_door_kick");
	rotation = -140;
	if ( isdefined( mod ) )
		rotation *= mod;
	self rotateyaw( rotation, .3, 0, .3);
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
	
		self.a.movement = "run"; // needs to be in the animation
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
			doors[ i ] thread door_opens( -1 );
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


best_fair_path()
{
	level.fair_paths = array_randomize( level.fair_paths );
	lowest = level.fair_paths[ 0 ];
	
	for ( i = 1; i < level.fair_paths.size; i++ )
	{
		path = level.fair_paths[ i ];
		
		if ( path.uses < lowest.uses )
			lowest = path;
	}
	
	return lowest;
}

fair_spawner_think()
{
	self endon( "death" );
	if ( !flag( "fairbattle_detected" ) )
	{
		patrol_fairgrounds_for_player();
		self.disableArrivals = false;
	}
	
	self allowedstances( "prone" );
}

fairground_detect_activity()
{
	self waittill_either( "death", "damage" );
	flag_set( "fairbattle_detected" );
}
	
patrol_fairgrounds_for_player()
{
	level endon( "fairbattle_detected" );
	thread fairground_detect_activity();
	
	// player hasnt been detected yet
	path = best_fair_path();
	path.uses++;
	
	self set_generic_run_anim( "patrol_jog" );
	self.disableArrivals = true;
	maps\_spawner::go_to_node( path, 1 );
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

fairground_player_detection()
{
	level endon( "fairbattle_detected" );

	for ( ;; )
	{
		wait( 0.5 );
		ai = getaiarray( "axis" );
		ai = remove_cant_see_player( ai );
		guy = getclosest( level.player.origin, ai );
		
		if ( !isalive( guy ) )
			continue;
			
		if ( level.player getstance() == "prone" )
		{
			if ( distance( guy.origin, level.player.origin ) < 128 )
				break;
			continue;
		}
		
		if ( level.player getstance() == "crouch" )
		{
			if ( distance( guy.origin, level.player.origin ) < 350 )
				break;
			continue;
		}
		
		if ( level.player getstance() == "stand" )
		{
			if ( distance( guy.origin, level.player.origin ) < 1400 )
				break;
			continue;
		}
	}

	flag_set( "fairbattle_detected" );
}

fairground_battle()
{
//	thread fairground_enemy_helis();
//	thread fairground_player_detection();
	
	level.fair_paths = getentarray( "fair_path", "targetname" );
	for ( i = 0; i < level.fair_paths.size; i++ )
	{
		level.fair_paths[ i ].uses = 0;
	}
	
	fair_spawners = getentarray( "fair_spawner", "targetname" );
	array_thread( fair_spawners, ::add_spawn_function, ::fair_spawner_think );
	
	// player is ignored until he does something to alert the enemy
	level.player.ignoreme = true;
	
	// "ak47", "rpd", "g3", "mp5", "RPG"
	
	fairground_pre_detection();
//	fairground_post_detection();
}

fairground_pre_detection()
{
	// first spawn in a wave of guys that will patrol jog in
	level endon( "fair_detection" );
	fair_spawners = getentarray( "fair_spawner", "targetname" );
	spawn_classname( fair_spawners, "ak47", 2 );
	spawn_classname( fair_spawners, "g3", 2 );
	spawn_classname( fair_spawners, "mp5", 2 );
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
		
		for ( i=0; i < fairground_helinames.size; i++ )
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
	waittillframeend; // wait for our .unload_group to get set, since _vehicle is reliant on waits and notifies
	
	wait( 6 ); // give the guys a chance to get outa there
	
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
		if ( distance( level.player.origin, price_fair_defendspot() ) < 300 )
		{
			iprintlnbold( "<MacMillan> This'll be fine" );
			return;
		}
		wait( 0.5 );
	}
}