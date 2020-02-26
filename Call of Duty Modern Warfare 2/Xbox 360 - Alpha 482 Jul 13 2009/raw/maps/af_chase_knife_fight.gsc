#include maps\_utility;
#include common_scripts\utility;
#include animscripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\af_chase_code;
#include maps\af_chase_zodiac;
#include maps\_hud_util;

BACK_TURN_MELEE_DIST = 50;

knife_fight_main()
{
	init_animset_pistol_stand();
	level.shepherd_spawn_ring = SpawnStruct();
	level.shepherd_spawn_ring.origin = getstruct( "price_spawns_after_waterfall", "targetname" ).origin;// todo make unique;
	level.shepherd_spawn_ring.radius = 1500;
	level.player_speed = .8;// sneaky player.
	level.shepherd_attack_forward_dist = 440;
	level.shepherd_attack_periphery_dist = 300;
//	level.node_distance_outside_of_fog_min = ( level.shepherd_attack_forward_dist + 100 ) * ( level.shepherd_attack_forward_dist + 100 );
	level.node_distance_outside_of_fog_min = 450 * 450;
	level.node_distance_outside_of_fog_max = 800 * 800;
	level.shepherd_sneaks_around_max = 3;
	level.shepherd_sneaks_around = 0;
	level.shepherd_clang_reset_time = GetTime();
	level.shepherd_dialog_ent = spawn( "script_origin", ( 1,1,1 ) );
	level.fx_visibilty_debug_array = [];
	precacheitem( "ending_knife" );
	PreCacheModel( "viewhands_player_sas_woodland" );
	PreCacheShader( "splatter_alt_sp" );
}


knife_fight_setup()
{
	setsaveddvar("cg_fov", 65 );
	fog_set_changes( "afch_fog_dunes_far", 0 );
	level.player.dontMelee = true;
	remove_extra_autosave_check( "boat_check_trailing" );
	remove_extra_autosave_check( "boat_check_player_speeding_along" );
	autosave_by_name( "wakeup" );
	array_call( GetAIArray(), ::Delete );
	level.player_speed = .8;// sneaky player.
	level.player SetMoveSpeedScale( level.player_speed );
	MusicStop();
	thread MusicPlayWrapper( "af_chase_approach_derick" );
	set_wind( 100, .7, .4 );	
}

transition_to_knife_fight_from_shore()
{
	level.player FreezeControls( true );
	level.player TakeAllWeapons();

	if ( !flag( "player_standing" ) )
		thread wakeup();
		
	flag_wait( "player_standing" );
	thread shepherd_first_contact();
	wait 2;
	give_knife_fight_weapon();
	wait 5;
	thread maps\af_chase_fx::sand_storm_rolls_in();
	flag_wait( "sandstorm_fully_masked" );
	thread sneaky_shephard_in_sandstorm();
	thread dialog_shepherd();	
}

sneaky_shephard_in_sandstorm()
{
	MusicStop();
	thread MusicPlayWrapper( "af_chase_sneak_music" );
	flag_set( "goodtime_for_fog_blast" );
	thread fog_pulses();
	level.player.ignoreme = true;
	thread shepherd_kills_player_when_close();
	thread set_flag_for_recently_moved_player();
	thread sneaky_shepherd();
	flag_wait( "dialog_all_finished" );
}

give_knife_fight_weapon()
{
	weapon = "ending_knife";
	level.player GiveWeapon( weapon );
	level.player SetWeaponAmmoStock( weapon, 0 );
	level.player SetWeaponAmmoClip( weapon, 0 );
	level.player SwitchToWeapon( weapon );
	level.player FreezeControls( false );
}

sneaky_shepherd()
{
	level.all_sneaky_nodes = getstructarray( "shepherd_moment_spot", "targetname" );
	level.all_recently_used_sneaky_nodes = [];
	last_sneaky_spot_array = [];
	invalid_sneakyspots = 3;

	thread shepherd_clangy_objective_handle();
	level endon( "shepherd_stabbed" );

	moment_time = GetTime();
	while ( 1 )
	{
//		if ( GetTime() > moment_time && flag( "fog_pulse_window_for_spawn" ) && ! flag( "shepherd_dialog_playing" ) )
		if ( GetTime() > moment_time && flag( "fog_pulse_window_for_spawn" ) )
		{
			node = find_best_sneaky_node();
			if ( IsDefined( node ) && do_sneaky_moment( node ) )
			{
					moment_time = GetTime() + RandomIntRange( 1000, 2000 );
					down_stack_used_sticky_nodes( node );
			}
		}
		wait .05;
	}
}

down_stack_used_sticky_nodes( node )
{
	level.all_recently_used_sneaky_nodes[ level.all_recently_used_sneaky_nodes.size ] = node;
	if ( level.all_recently_used_sneaky_nodes.size < 2 )
		return;
	level.all_recently_used_sneaky_nodes = array_remove( level.all_recently_used_sneaky_nodes, level.all_recently_used_sneaky_nodes[ 0 ] );
}

find_sneaky_dir( node )
{
//	target_nodes = getstructarray( node.target, "targetname" );

	if ( IsDefined( level.shepherd ) )
	{
		distance_to_player = shepherd_distance_to_player();
	}
	else
	{
		distance_to_player = Distance( node.origin, level.player.origin );
	}
	distance_to_player -= 32;

	if ( flag( "dialog_all_finished" ) )
		target_nodes = sort_by_distance( getstructarray( "price_patrol_path", "script_noteworthy" ), node.origin );
	else
		target_nodes = GetNodesInRadiusSorted( node.origin, distance_to_player, 150, 2000, "path" );

	player_forward = VectorNormalize( node.origin - level.player.origin );

	the_node = undefined;
	compare_dot = -.866;
	dir = 0;
	if ( flag( "dialog_all_finished" ) && flag( "player_moved_recently" ) )
	{
		compare_dot *= -1;
		dir = 1;
	}

	foreach ( targ_node in target_nodes )
	{
		if ( targ_node == node )
			continue;
		normalvec = VectorNormalize( targ_node.origin - node.origin );
		dot = VectorDot( player_forward, normalvec );
		if ( dir )
		{
			// looking for nodes going away from the player
			if ( dot > compare_dot )
			{
			 compare_dot = dot;
			 the_node = targ_node;
			 return the_node;
			}
		}
		else
		{

			if ( dot < compare_dot )
			{
				compare_dot = dot;
				if ( ! BulletTracePassed( level.player GetEye(), targ_node.origin + ( 0, 0, 32 ), false, undefined ) )
					continue;// try to get a node that's visible to the player.
				the_node = targ_node;
				return the_node;
			}
		}
	}

	if( ! flag( "dialog_all_finished" ) )
		return;
	// ok nothing good is found so find something less good. closest direct to the player

	Assert( distance_to_player > 32 );

	target_nodes = GetNodesInRadiusSorted( node.origin, distance_to_player, 0, 2000, "path" );

	//get something when there's nothing.
	new_dist = distance_to_player + 1000;
	compare_dot = 0; // he can walk to the side
	while ( !target_nodes.size && new_dist < 6000 )
	{
		new_dist += 100;
		target_nodes = GetNodesInRadiusSorted( node.origin, new_dist, 0, 2000, "path" );
	}

	foreach ( targ_node in target_nodes )
	{
		if ( targ_node == node )
			continue;
		normalvec = VectorNormalize( targ_node.origin - node.origin );
		dot = VectorDot( player_forward, normalvec );
		if ( dot < compare_dot )
		{
			compare_dot = dot;
			the_node = targ_node;
			return the_node;
		}
	}
	
	return random( target_nodes );// bleh.
}

//expensive but with one guy in the level I don't care.
sort_by_distance( nodes, org )
{
	array = [];
	while ( nodes.size )
	{
		closer_node = getClosest( org, nodes );
		array[ array.size ] = closer_node;
		nodes = array_remove( nodes, closer_node );
	}
	return array;
}


do_sneaky_moment( node )
{
	sneaky_dir = find_sneaky_dir( node );
	if ( !isdefined( sneaky_dir ) )
		return false;
	spawn_shepherd( node, sneaky_dir );
	return true;
}

#using_animtree( "generic_human" );

init_animset_pistol_stand()
{
	anim.initAnimSet = anim.animsets.pistolStand;
	anim.initAnimSet[ "semi" ] = array( %pistol_stand_fire_A );
	anim.initAnimSet[ "semi2" ] = %pistol_stand_fire_A;
	anim.initAnimSet[ "semi3" ] = %pistol_stand_fire_A;
	anim.initAnimSet[ "semi4" ] = %pistol_stand_fire_A;
	anim.initAnimSet[ "semi5" ] = %pistol_stand_fire_A;

	anim.animsets.pistolStand = anim.initAnimSet;
}

shepherd_first_contact()
{
	// till we get some animated mocap moment of him shooting at the player just have him hobble off.
	Assert( !isdefined( GetEnt( "spawned_shepard", "targetname" ) ) );

	node = getstruct( "shepherd_first_encounter", "targetname" );
	walktodest = getstruct( "price_spawns_after_waterfall", "targetname" ) ;
	shepherd_spawner = GetEnt( "shepard", "targetname" );
	shepherd_spawner.origin = node.origin;
	shepherd_spawner.angles = flat_angle( VectorToAngles( walktodest.origin - node.origin ) );
	node.angles = shepherd_spawner.angles;


	shepherd = shepherd_spawner StalingradSpawn( 0, "spawned_shepherd" );
	spawn_fail = spawn_failed( shepherd );
	level.shepherd = shepherd;
	Assert( !spawn_fail );

	shepherd_spawner.count = 1;
	shepherd set_goal_pos( walktodest.origin );
	shepherd.goalradius = 128;
	shepherd disable_sprint();
//	self set_generic_run_anim_array( walkanim, twitch_weights );
	self.moveplaybackrate = .5;// temp. pending intro anim.
	flag_wait( "blinder_effect" );
	wait 2.5;
	shepherd Delete();
}

spawn_shepherd( node, sneaky_dir )
{
	Assert( !isdefined( GetEnt( "spawned_shepard", "targetname" ) ) );
	shepherd_spawner = GetEnt( "shepard", "targetname" );
	shepherd_spawner.origin = node.origin;
	shepherd_spawner.angles = flat_angle( VectorToAngles( sneaky_dir.origin - node.origin ) );
	node.angles = shepherd_spawner.angles;

	shepherd = shepherd_spawner StalingradSpawn( 0, "spawned_shepherd" );
	spawn_fail = spawn_failed( shepherd );
	level.shepherd = shepherd;
	Assert( !spawn_fail );
	flag_set( "shepherd_spawned" );
	shepherd_spawner.count = 1;
//	shepherd.maxsightdistsqrd = level.shepherd_attack_forward_dist*level.shepherd_attack_forward_dist;
	shepherd.maxsightdistsqrd = 900 * 900;
	shepherd animscripts\animset::init_animset_complete_custom_stand( anim.animsets.pistolStand );
	shepherd AllowedStances( "stand" );
	
	shepherd shepherd_attach_knife();
	
	if( !flag( "dialog_all_finished" ) )
		shepherd magic_bullet_shield();
		
	shepherd.ignoreme = true;
	shepherd.deathanim = %exposed_death_neckgrab;
	shepherd.fixednode = 0;
	shepherd.animname = "shepherd";
	shepherd disable_surprise();
	shepherd disable_arrivals();
	shepherd disable_exits();
//	shepherd gun_remove();
	shepherd disable_sprint();
	shepherd.shootRateOverride = 1.5;

	shepherd.allowdeath = true;

	shepherd thread shepherd_magically_shoots_nearby_player();
	shepherd thread shepherd_patrol( sneaky_dir );
	shepherd thread shepherd_attack_player();
	shepherd thread shepherd_kill();
	shepherd thread shepherd_accuracy_scaler();
	shepherd thread shepherd_cheats_aim_when_close();
	shepherd thread shepherd_runs_away_when_sand_rolls_in();
	
//	shepherd thread draw_my_sight_to_player();

	level.shepherd_clang_reset_time = GetTime();

	level.shepherd_sneaks_around++;

	wait_for_pulse( shepherd );

	if ( !isalive( shepherd ) )
		return;

	if ( IsDefined( shepherd.magic_bullet_shield ) )
		shepherd stop_magic_bullet_shield();
	PlayFX( getfx( "vanishing_shepherd" ), shepherd.origin );
	level notify( "shepherd_delete" );
	thread spawn_ring_for_shepherd( shepherd.origin );
	flag_clear( "shepherd_spawned" );
	shepherd Delete();
}

spawn_ring_for_shepherd( destorigin )
{
	//keep him from getting too crazy with how far out he spawns from where he was last "seen".
	level notify( "new_spawn_ring_for_shepherd" );
	level endon( "new_spawn_ring_for_shepherd" );

	start_radius = 500;
	end_radius = 2500;
	increments = 10 * 20;// ten seconds of 20 frames

	level.shepherd_spawn_ring.origin = destorigin;
	level.shepherd_spawn_ring.radius = start_radius;

	difference = end_radius - start_radius;
	rad_inc = difference / increments;
	for ( i = 0; i < increments; i++ )
	{
		level.shepherd_spawn_ring.radius += rad_inc;
		wait .05;
	}
}

wait_for_pulse( shepherd )
{
	shepherd endon( "death" );
	start_time = GetTime();
	fx_fraction = 0;
	while ( 1 )
	{
		wait_for_buffer_time_to_pass( start_time, 3 );
		flag_wait( "fog_pulse_window_for_spawn" );
		distance_to_player = Distance( level.player.origin, shepherd.origin );
		if ( level.player ent_flag( "player_has_red_flashing_overlay" ) )
			return;
		
		fx_fraction = getmyfxvisibilty_to_player( shepherd geteye() );
		if( !fx_fraction )
			return;
			
		if( ! level.player SightConeTrace( shepherd geteye() ) )
			return;
		
// this isn't working. he's clearly visible but something that I can't see is blocking the sighttrace
//		if ( ! SightTracePassed( shepherd GetEye(), level.player GetEye(), false, level.player ) )
//			return;
		
		wait .05;
	}
}


//walk a trace down the body of both
getmyfxvisibilty_to_player( trace_pos )
{
	right = vectornormalize( anglestoright( vectortoangles( level.player.origin-trace_pos) ) ) * 12;
	trace_pos_player = level.player geteye();
	trace_count = 24;
	half_right_all = right*trace_count/2;
	trace_pos_player-=half_right_all;
	trace_pos-=half_right_all;
	trace_offset = right + ( 0,0,-3);
	fx_visibility = 0;
	local_fx_visibility = 0;
	
	for ( i = 0; i < trace_count; i++ )
	{
		local_fx_visibility = getfxvisibility( trace_pos, trace_pos_player );
		level.fx_visibilty_debug_array[i] = local_fx_visibility;
		fx_visibility+= local_fx_visibility;
		trace_pos+=trace_offset;
		trace_pos_player+=trace_offset;
//		if( local_fx_visibility > .2 )
//			line( trace_pos, trace_pos_player, (0,0,1 ) );
//		else
//			line( trace_pos, trace_pos_player, (0,1,1 ) );
		
	}
	if( fx_visibility == 0 )
		return 0;
	
	return fx_visibility / trace_count;
}


isplayergoingfast_towards_shepherd()
{
	if ( !isdefined( level.shepherd ) )
		return false;
	player_velocity = level.player GetVelocity();

	normal = VectorNormalize( level.shepherd.origin - level.player.origin );
	forward = VectorNormalize( player_velocity );
	if ( !( VectorDot( forward, normal ) > Cos( 10 ) ) )
		return false;
	player_speed = Distance( ( 0, 0, 0 ), player_velocity );
	return( player_speed > 166 );
}


fog_pulses( transition_time )
{
	level notify( "fog_pulses" );
	level endon( "fog_pulses" );
	if ( !isdefined( transition_time ) )
		transition_time = RandomFloatRange( 1, 2 );

	next_window_time = GetTime();
	while ( 1 )
	{
		flag_wait_or_timeout( "goodtime_for_fog_blast", transition_time );
		if ( flag( "goodtime_for_fog_blast" ) )
		{
			next_window_time = GetTime() - 100;
			flag_clear( "goodtime_for_fog_blast" );
		}

		if ( GetTime() > next_window_time )
		{
			transition_time = 2.5;// timed how long it took to blind
			//fog_set_changes( "afch_fog_dunes_pulse_fog", transition_time );
			flag_set( "blinder_effect" );
			wait transition_time;
			minimum_window_time = .5;
			window_time = RandomFloatRange( minimum_window_time, 1.2 );
			start_time = GetTime();
			delaythread( window_time - .2, ::flag_set, "fog_pulse_window_for_spawn" );
			wait window_time;
						
			flag_clear( "fog_pulse_window_for_spawn" );
			flag_clear( "goodtime_for_fog_blast" );
			flag_clear( "blinder_effect" );

			if ( IsDefined( level.shepherd ) )
			{
				if ( ! flag( "player_moved_recently" ) )
					next_window_time = GetTime() + RandomIntRange( 8000, 10000 );// give him time to kill the idle players.
				else
					next_window_time = GetTime() + RandomIntRange( 7000, 9000 );// finding the window to be too short
			}
			else
			{
				next_window_time = GetTime() + RandomIntRange( 2000, 4000 );
			}
		}

		wait .05;
		transition_time = RandomFloatRange( .75, 1.2 );
	}
}

NODE_COS = 0.9;// ~cos( 25 )

find_best_sneaky_node()
{
	valid_nodes = [];

	start_origin = level.player.origin;
	start_angles = level.player.angles;
	thenode = undefined;

	greatest_dot = NODE_COS;

	if ( !flag( "player_moved_recently" ) )
	{
		greatest_dot = -1;// ok to spawn shepherd anywhere.
	}

	Assert( level.node_distance_outside_of_fog_min < level.node_distance_outside_of_fog_max );

	foreach ( node in level.all_sneaky_nodes )
	{
		if ( is_in_array( level.all_recently_used_sneaky_nodes, node ) )
			continue;

		if ( Distance( node.origin, level.shepherd_spawn_ring.origin ) > level.shepherd_spawn_ring.radius )
			continue;

		dot = get_dot( start_origin, start_angles, node.origin );
		distsqrd = DistanceSquared( start_origin, node.origin );

		outside_fog_dist_min = level.node_distance_outside_of_fog_min;
		outside_fog_dist_max = level.node_distance_outside_of_fog_max;

		if ( !flag( "player_moved_recently" ) )
		{
			outside_fog_dist_min = outside_fog_dist_min / 4;
			outside_fog_dist_max = outside_fog_dist_max / 2;
		}

		if ( distsqrd < outside_fog_dist_min )
			continue;
		if ( distsqrd > outside_fog_dist_max )
			continue;


		start = level.player GetEye();
		end = groundpos( node.origin ) + ( 0, 0, 32 );
		
		fx_visibility = getmyfxvisibilty_to_player( node.origin+(0,0,60) );
		if( ! fx_visibility )
		{
			fx_visibility = getmyfxvisibilty_to_player( node.origin+(0,0,60) );
			continue;
		}
		
//		if ( ! BulletTracePassed( level.player GetEye(), end, false, undefined ) )
//			continue;// only want him to show up in places that will be clear once the sand fades.

		if ( dot > greatest_dot )
		{
			greatest_dot = dot;
			thenode = node;
			if( RandomInt( 4 ) == 0 )
				return thenode;
		}
	}
	return thenode;
}





downstack_sneakyspot( array, object )
{
	array = array_insert( array, object, 0 );
	return array_remove( array[ array.size - 1 ] );
}

knife_fight_objective_handle( objective_id )
{
		// Locate Shepherd.
		Objective_Add( objective_id, "current", &"AF_CHASE_LOCATE_SHEPHERD" );
		player_in_end_volume = getent( "player_in_end_volume", "targetname" );
		
		while( 1 )
		{
			Objective_Position( objective_id, getstruct( "price_spawns_after_waterfall", "targetname" ).origin );
			player_in_end_volume waittill ("trigger");
			Objective_Position( objective_id, (0,0,0) );
			while( level.player istouching( player_in_end_volume ) )
				wait .05;
		}
}

wakeup_overlay( black_overlay )
{
	wait 2;
	SetBlur( 5, 0 );
	black_overlay thread exp_fade_overlay( 0.25, 4 );
	wait 0.5;
	level.player play_sound_on_entity( "breathing_better" );
	wait 1.5;
	SetBlur( 0, 2 );
}



shepherd_radio_dialogue( dialog,between_timer )
{
	if( !isdefined( between_timer ) )
		between_timer = 3.5;
	thread shepherd_dialogue_location_handle();
	flag_waitopen( "shepherd_spawned" );
	flag_set( "shepherd_dialog_playing" );
	wait RandomFloatRange( .5, 2 );
	level.shepherd_dialog_ent play_sound_on_entity( level.scr_radio[ dialog ] );
//	radio_dialogue( dialog );
	flag_clear( "shepherd_dialog_playing" );
	flag_wait_or_timeout( "shepherd_spawned", between_timer );// wait for the next encounter
}

shepherd_dialogue_location_handle()
{
	level notify ("shepherd_dialogue_location_handle" );
	level endon ("shepherd_dialogue_location_handle" );
//	childthread shepherd_dialogue_location_draw();
	while( 1)
	{
		while(!isdefined( level.shepherd ) )
			wait .05;
			
		project_vector = VectorNormalize( level.shepherd.origin-level.player.origin ) * 3000;
		start_origin = level.shepherd.origin + project_vector;
		level.shepherd_dialog_ent.origin = start_origin; // put the origin behind shepherd and blend it in.
		level.shepherd_dialog_ent moveto( level.shepherd geteye(), 1, 0, 0 );
		wait 1.05;
		if( isdefined( level.shepherd ) )
		{
			level.shepherd_dialog_ent.origin = level.shepherd geteye();
			level.shepherd_dialog_ent linkto ( level.shepherd );
		}
		while( isdefined( level.shepherd ) )
			wait .05;
		level.shepherd_dialog_ent.origin+=( 0,0,3000 );
	}
}

shepherd_dialogue_location_draw()
{
	while( 1 )
	{
		line( level.shepherd_dialog_ent.origin , level.player.origin, (1,0,0) );
		wait .05;
	}
}

dialog_shepherd()
{
	level waittill( "shepherd_shot" );
	shepherd_radio_dialogue( "afchase_shp_stillalive", 1.4 );
	shepherd_radio_dialogue( "afchase_shp_doesntmatter",1.5 );
	shepherd_radio_dialogue( "afchase_shp_tooambitious" );
	shepherd_radio_dialogue( "afchase_shp_winawar" );
	shepherd_radio_dialogue( "afchase_shp_weakerthanever" );
	shepherd_radio_dialogue( "afchase_shp_sealthedeal" );
	shepherd_radio_dialogue( "afchase_shp_wargoeson" );

	autosave_by_name( "knife_fight" );
	shepherd_radio_dialogue( "afchase_shp_tellaboutme" );
	
	flag_set( "dialog_all_finished" );
	if( isdefined( level.shepherd.magic_bullet_shield ) )
	{
		level.shepherd stop_magic_bullet_shield();
	}

	//bring him in closer
	level.node_distance_outside_of_fog_min = 350 * 350;
	level.node_distance_outside_of_fog_max = 650 * 650;

}

#using_animtree( "player" );
wakeup()
{
	anim_ent = GetEnt( "end_on_foot", "targetname" );
	targ_ent = GetEnt( anim_ent.target, "targetname" );
	view_ent = PlayerView_Spawn( anim_ent.origin, anim_ent.angles );
	level.player PlayerLinkToDelta( view_ent, "tag_player", 1, 0, 0, 0, 0, true );
	level.player PlayerSetGroundReferenceEnt( view_ent );


//	red_overlay = create_client_overlay( "splatter_alt_sp", 0, level.player );
	black_overlay = create_client_overlay( "black", 1, level.player );
	black_overlay.sort = 1;
	black_overlay.foreground = false;

	delayThread( 1, ::wakeup_overlay, black_overlay );

	wait 3.4;
	delayThread( 4.5, ::flag_set, "player_standing" );

	rotate_time = 2;
	view_ent RotateTo( targ_ent.angles, rotate_time, .5, .5 );
	view_ent MoveTo( targ_ent.origin, rotate_time, .5, .5 );
	wait rotate_time;
	level.player Unlink();
	level.player PlayerSetGroundReferenceEnt( undefined );
	level.player SetPlayerAngles( view_ent.angles );
}

PlayerView_Spawn( start_origin, start_angles )
{
	playerView = Spawn( "script_model", start_origin );
	playerView.angles = start_angles;
	playerView SetModel( "tag_origin" );
	playerView UseAnimTree( #animtree );
	playerView Hide();
	return playerView;
}

handicap_player()
{
	level.player AllowSprint( false );
}


cleanup_animanimnode( shepherd )
{
	shepherd waittill ( "death" );
	self delete();
}


draw_my_angles_for_while()
{
	self endon ( "death" );
	forward = AnglesToForward( self.angles );
	point1 = self.origin;
	point2 = point1+ ( forward*32 );
	while( 1 )
	{
		self draw_arrow( point1, point2, (0,1,0) );
		wait .05;
	}
		
}

draw_my_sight_to_player()
{
	self endon ( "death" );
	good_color = (0,1,0);
	bad_color = (1,0,0);

	while( 1 )
	{
		point1 = self geteye();
		point2 = level.player geteye();
		fx_visibility = 		GetFXVisibility( point1, point2 );

		if( fx_visibility )
			Line( point1, point2+(0,0,-32), good_color );		
		else
			Line( point1, point2+(0,0,-32), bad_color );		

		if( level.player SightConeTrace( self geteye() ) )
			self draw_arrow( point1, point2, good_color );
		else
			self draw_arrow( point1, point2, bad_color );
			
			
		wait .05;
	}
		
}

angle_to_player()
{
	self endon ( "goodtime_for_fog_blast" );
	self endon ( "death" );
	angles = self.angles;
	while( 1 )
	{
		angles = vectortoangles( level.player.origin- self.origin );
		self Teleport( self.origin, angles );
		wait .05;
	}
}

shepherd_patrol( node )
{
	self endon( "death" );
	self endon( "stop_patroling" );

	walk_anims = [];
	walk_anims[ 0 ] = "shepherd_search";
	walk_anims[ 1 ] = "shepherd_search_spin";

	animnode = Spawn( "script_origin", self.origin );
	animnode thread cleanup_animanimnode( self );
//	self set_generic_run_anim_array( "walk_CQB_F" );
	self.moveplaybackrate = .4;
	
	nextgoal = node;

	while ( 1 )
	{

		self.goalradius = 128;
		self set_goal_ent( nextgoal );

		while ( 1 )
		{
			animnode.origin = self.origin;
			animnode.angles = VectorToAngles( nextgoal.origin - self.origin );
			select_animation = random( walk_anims );                                                                                              

			if ( ! flag( "dialog_all_finished" ) )
			{
				select_animation = "shepherd_search";// spinning reveals back to player training them that it's not possible to stab.
				self thread angle_to_player();  // homing missile tech.
			}
			animdelta = GetMoveDelta( getGenericAnim( select_animation ) );
			endPoint = self LocalToWorldCoords( animdelta );
			movedist = Distance( ( 0, 0, 0 ), animdelta );

			if( self MayMoveToPoint( endPoint ) )
			{
				animnode.angles = self.angles;
					thread allowdeath();
					
//				animnode thread draw_my_angles_for_while();
//				self delaycall( .1, ::OrientMode, "face enemy" );
				animnode anim_generic_custom_animmode( self, "gravity", select_animation );
			}
			else if ( Distance( self.origin, nextgoal.origin ) > movedist )
			{
				org = nextgoal.origin;

				if ( self MayMoveToPoint( org ) )
				{
					thread allowdeath();
//					self delaycall( .1, ::OrientMode, "face enemy" );
					animnode anim_generic_custom_animmode( self, "gravity", select_animation );
				}
				else
					wait .05;
			}
			else
				break;
		}

		if ( ! flag( "dialog_all_finished" ) )
		{
			flag_set( "goodtime_for_fog_blast" );
			return;// this point he's played the sneaky animation and hasn't seen the player to start shooting and I don't have a smart thing for him to do but disappear
		}

		self waittill( "goal" );

		if ( IsDefined( node.target ) )
			nextgoal = getstruct( node.target, "targetname" );
		else
			nextgoal = undefined;

		while ( !isdefined( nextgoal ) )
		{
			nextgoal = find_sneaky_dir( node );
			wait .05;
		}
	}
}

allowdeath()
{
	waittillframeend;
	if( !isdefined( self ) )
		return;
	self.allowdeath = true;
	self.allowpain = true;
}


draw_arrow_out_of_tag()
{
	while(1)
	{
		point1 = self gettagorigin( "tag_eye" );
		vector = VectorNormalize( anglestoforward( self gettagangles( "tag_eye" ) ) );
		
		point2 = point1 + ( vector * 32 );
		
		draw_arrow( point1, point2, (1,0,0));
		wait .05;
	}
}

shepherd_attack_player()
{
	self endon( "death" );
//	self childthread draw_arrow_out_of_tag();
	while ( 1 )
	{
		doattack = true;
		attack_forward = true;
		attack_periphery = true;
		distance_to_player = Distance( self.origin, level.player.origin );

		test_tag = "tag_eye";
		test_org = flat_origin( self GetTagOrigin( test_tag ) );
		test_ang = flat_angle( self GetTagAngles( test_tag ) );
		flat_playerorg = flat_origin( level.player.origin );

		yawToPlayer = AngleClamp180( test_ang[ 1 ] - GetYaw2d( flat_playerorg ) );

		dot = get_dot( test_org, test_ang, flat_playerorg );
		if( dot < .766 )
			attack_forward = false;
		if ( dot < .5 )
			attack_periphery = false;

		if ( ! self CanSee( level.player ) )
			doattack = false;

		fraction_visibility = GetFXVisibility( self GetEye(), level.player GetEye() );

		attack_forward_dist = level.shepherd_attack_forward_dist * fraction_visibility;
		attack_backward_dist = level.shepherd_attack_periphery_dist * fraction_visibility;

		if ( attack_forward_dist < 200 )
			attack_forward_dist = 200;

		if ( attack_backward_dist < 100 )
			attack_backward_dist = 100;

		if ( attack_forward )
		{
			if ( distance_to_player > ( level.shepherd_attack_forward_dist * fraction_visibility ) )
				doattack = false;
		}
		else if ( attack_periphery )
		{
			if ( distance_to_player > ( level.shepherd_attack_periphery_dist * fraction_visibility ) )
				doattack = false;
		}
		else
		{
			if ( distance_to_player > ( BACK_TURN_MELEE_DIST * fraction_visibility ) )
				doattack = false;
			else if( flag( "dialog_all_finished" ) )
				doattack = false; // no backattacks to guy at this point.
		}

		if( ! flag( "dialog_all_finished" ) )
		if ( isplayergoingfast_towards_shepherd() && distance_to_player < 400 )
		{
				doattack = true;
		}

		

		if ( doattack )
			return sheperd_attack_player_doattack();
		wait .05;
	}
}

sheperd_attack_player_doattack()
{

	level.shepherd_clang_reset_time = GetTime();
	level.shepherd shepherd_detach_knife();

	self clear_run_anim();
	self notify( "stop_patroling" );

	self.moveplaybackrate = 1;
	level.player.ignoreme = false;
	self.ignoreall = false;
	self.favoriteenemy = level.player;

	self notify( "stop_animmode" );
	self notify( "stop_patroling" );
	self StopAnimScripted();
	self OrientMode( "face default" ) ;
	

	self thread shepherd_turns_to_player();
}

shepherd_turns_to_player()
{
	self endon( "death" );
	self notify( "shepherds_goalradius_grows" );
	self endon( "shepherds_goalradius_grows" );
	self.goalradius = 18;
	ofsettoplayerdist = 64;

	offsettoplayer = VectorNormalize( level.player.origin - self.origin ) * ( ofsettoplayerdist );
	self SetGoalPos( self.origin + offsettoplayer );
	self.goalradius = 18;

	// turn around damnit.. 
	while ( 1 )
	{
		offsettoplayer = VectorNormalize( level.player.origin - self.origin ) * ( ofsettoplayerdist );
		if ( self MayMoveToPoint( self.origin + offsettoplayer, false, true ) )
		{
			self SetGoalPos( self.origin + offsettoplayer );
			self.goalradius = 18;
			self waittill( "goal" );
		}
		else
		{
			wait .05;
			ofsettoplayerdist -= 8;
			if ( ofsettoplayerdist < 16 )
				ofsettoplayerdist = 16;
		}
		if ( within_fov( self.origin, self.angles, level.player.origin, .766 ) )
			break;
	}
	radius = self.goalradius;
	while ( radius < 3000 )
	{
		wait 1.5;
		self.goalradius = radius;
		radius += 6;
	}
}

shepherd_kill()
{
	level endon( "shepherd_delete" );
	level.shepherd waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
	assert( flag( "dialog_all_finished" ) );
	if( attacker == level.player )
	{
		level.shepherd kill();
	}
	level notify( "shepherd_stabbed" );
	level.shepherd shepherd_detach_knife();
	level.shepherd play_sound_in_space( "shepherd_death" );
	wait 2;
	MusicStop();
	MusicPlayWrapper( "af_chase_killed_thebadguy" );
	wait 3;
	IPrintLnBold( "insert special player seeing knife in self sequence.." );
	wait 3;
	nextmission();
}

shepherd_clangy_objective_handle()
{
	// make clangy sounds and ping the objective to help the player find him.
	nextclangtime = GetTime() + RandomIntRange( 3000, 6000 );
	while ( 1 )
	{
		if ( !isdefined( level.shepherd ) )
		{
			wait .05;
			continue;
		}
		doclang = true;
		if ( GetTime() < nextclangtime )
			doclang = false;
		if ( Distance( level.shepherd.origin, level.player.origin ) < 900 && level.player SightConeTrace( level.shepherd GetEye(), level.shepherd ) )
			doclang = false;
		if ( level.shepherd.a.lastShootTime > GetTime() - 3000 )
			doclang = false;
		if ( level.shepherd_clang_reset_time > GetTime() - 2000 )
			doclang = false;

		if ( doclang )
		{
			thread play_sound_in_space( "shepard_rusty_oil_derick_noise", level.shepherd.origin );
			level notify( "do_objective_ping" );
			nextclangtime = GetTime() + RandomIntRange( 5000, 12000 );
		}
		wait .05;
	}
}

scale_back_move_speed( time )
{
	oldspeed = level.player_speed;
	level notify( "stop_limp" );
	level.player blend_movespeedscale( .2, .2 );
	wait 2.5;
	level.player blend_movespeedscale( oldspeed, 2 );
}


fog_set_changes_player_dist_from_ent_can_break( fog_set, transition_time, ent, break_dist )
{
	self notify( "fog_set_changes_player_dist_can_break" );
	self endon( "fog_set_changes_player_dist_can_break" );
	thread fog_set_changes_interuptable( fog_set, transition_time );
	msec_transition_time = GetTime() + ( transition_time * 1000 );
	if ( IsDefined( ent ) )
		while ( Distance( level.player.origin, ent.origin ) > break_dist )
		{
			if ( GetTime() > msec_transition_time )
				return;
			wait .05;
		}
	fogset_fast_time = .2;
	fog_set_changes_interuptable( fog_set, fogset_fast_time );
	wait fogset_fast_time;
}

fog_set_changes_interuptable( fog_set, transition_time )
{
	if ( !isdefined( level.fog_transition_ent ) )
	{
		level.fog_transition_ent = SpawnStruct();
		level.fog_transition_ent.fogset = "";
		level.fog_transition_ent.time = 0;
	}

	if ( !isdefined( level.fog_set ) )
		level.fog_set = [];

	ent = level.fog_set[ fog_set ];
	if ( !isdefined( ent ) )
	{
		AssertEx( IsDefined( level.vision_set_fog ), "Fog set:" + fog_set + " does not exist, use create_fog( " + fog_set + " ) or create_vision_set_fog( " + fog_set + " ); in your /createart/level_fog.gsc" );
		ent = level.vision_set_fog[ fog_set ];
	}

	AssertEx( IsDefined( ent ), "Fog set:" + fog_set + " does not exist, use create_fog( " + fog_set + " ) or create_vision_set_fog( " + fog_set + " ); in your /createart/level_fog.gsc" );

	if ( !isdefined( transition_time ) )
		transition_time = ent.transitiontime;

	AssertEx( IsDefined( transition_time ), "Fog set: " + fog_set + " does not have a transition_time defined and a time was not specified in the function call." );

	if ( IsDefined( ent.sunRed ) )
	{
		SetExpFog(
		ent.startDist,
		ent.halfwayDist,
		ent.red,
		ent.green,
		ent.blue,
		ent.maxOpacity,
		transition_time,
		ent.sunRed,
		ent.sunGreen,
		ent.sunBlue,
		ent.sunDir,
		ent.sunBeginFadeAngle,
		ent.sunEndFadeAngle,
		ent.normalFogScale );
	}
	else
	{
		SetExpFog(
		ent.startDist,
		ent.halfwayDist,
		ent.red,
		ent.green,
		ent.blue,
		ent.maxOpacity,
		transition_time );
	}

	level.fog_transition_ent.fogset = fog_set;
	level.fog_transition_ent.time = transition_time;
}

shepherd_accuracy_scaler()
{
	//there's probably some variable I can change that would do the same damn thing. 
	self endon( "death" );
	base_lousy_accuracy_distance = 350;
	lousy_accuracy_distance = base_lousy_accuracy_distance;
	lousy_accuracy = 0;

	good_accuracy_distance = 50;
	good_accuracy = 4;


	while ( 1 )
	{
		lousy_accuracy_distance = base_lousy_accuracy_distance;
		distance_diff = good_accuracy_distance - lousy_accuracy_distance;
		accuracy_diff = good_accuracy - lousy_accuracy;
		distance_to_player_after_goodaccuracy = Distance( self.origin, level.player.origin ) - good_accuracy_distance;
		distace_fraction_to_lousy_accuracy = -1 * ( distance_to_player_after_goodaccuracy / distance_diff );
		if ( distace_fraction_to_lousy_accuracy > 1 )
			distace_fraction_to_lousy_accuracy = 1;

		if ( flag( "player_moved_recently" ) )
		{
			self.baseaccuracy = good_accuracy - ( accuracy_diff * distace_fraction_to_lousy_accuracy );
		}
		else
		{
			self.baseaccuracy = 10;
		}
		wait .05;
	}
}


shepherd_kills_player_when_close()
{

	level.player endon( "death" );
	while ( 1 )
	{
		level.player waittill( "damage", damage, attacker );
		if ( !isdefined( level.shepherd ) )
			continue;
		if ( attacker != level.shepherd )
			continue;

		thread player_damage_flag();

		distance_to_player = shepherd_distance_to_player();
//		if ( distance_to_player < 150 || ( distance_to_player < 400 && isplayergoingfast_towards_shepherd() && SightTracePassed( level.player GetEye(), level.shepherd GetEye(), false, true ) ) )
//			level.player Kill();
//		else
			thread reduce_players_speed_a_bit();
	}
}

player_damage_flag()
{
	level notify( "player_damage_flag" );
	level endon( "player_damage_flag" );
	flag_set( "player_damaged" );
	wait .2;
	flag_clear( "player_damaged" );
}

shepherd_cheats_aim_when_close()
{
	self endon( "death" );
	self.shootingatplayercount = 0;
	while ( 1 )
	{
		self waittill( "shooting" );
		level notify( "shepherd_shot" );
//		self.bulletsinclip = WeaponClipSize( self.weapon );
		self.shootingatplayercount++;
		if ( shepherd_distance_to_player() < 100 )
		{
			MagicBullet( "coltanaconda", self GetEye(), level.player GetEye() );// bendy bullets.
			level.player Kill();
		}
//		if ( self.shootingatplayercount > 2 && flag( "player_moved_recently" ) )
		if ( self.bulletsinclip < 3 && flag( "player_moved_recently" ) )
			flag_set( "goodtime_for_fog_blast" );
			
		self.shootRateOverride+= randomfloatrange (.1, .3);
	}

}

reduce_players_speed_a_bit()
{
	level notify( "reduce_players_speed_a_bit" );
	level endon( "reduce_players_speed_a_bit" );
	if ( isplayergoingfast_towards_shepherd() )
		level.player SetMoveSpeedScale( .3 );
	else
		return;
	wait .6;
	blend_movespeedscale( level.player_speed, 1.6 );
}

shepherd_distance_to_player()
{
	return Distance( level.player.origin, level.shepherd.origin );
}

set_flag_for_recently_moved_player()
{
	last_player_org = level.player.origin;
	recently_moved_timer = 5000;
	next_clear_time = GetTime();

	while ( 1 )
	{
		if ( level.player.origin != last_player_org && ! flag( "player_damaged" ) )
		{
			flag_set( "player_moved_recently" );
			next_clear_time = GetTime() + recently_moved_timer;
		}
		else if ( GetTime() > next_clear_time )
		{
			flag_clear( "player_moved_recently" );
		}
		last_player_org = level.player.origin;
		wait .05;
	}
}

shepherd_runs_away_when_sand_rolls_in()
{
	self endon( "death" );
	flag_wait( "goodtime_for_fog_blast" );
	self.moveplaybackrate = 1.3;
	nodes = 	GetNodesInRadiusSorted( self.origin, 3000, 200, 1000, "path" );
	farthest_good_node = undefined;
	foreach ( node in nodes )
	{
		dot = get_dot( self.origin, VectorToAngles( self.origin - level.player.origin ), node.origin );
		if ( dot < .766 )
			continue;
		if ( self MayMoveToPoint( node.origin, false, false ) )
			farthest_good_node = node;
	}

	if ( !isdefined( farthest_good_node ) )
		return;

	self set_goal_pos( farthest_good_node.origin );
	self.goalradius = 32;

}

shepherd_magically_shoots_nearby_player()
{
	self endon( "death" );
	while ( 1 )
	{
		distance_to_player = shepherd_distance_to_player();
		if ( distance_to_player < 76 )
		{
			self Shoot();
			self notify( "shooting" );
			return;
		}
		if ( flag( "dialog_all_finished" ) )
			return;
		wait .05;
	}
}

shepherd_detach_knife()
{
	if( isdefined( self.knife_attached) )
	{
		self detach( "weapon_parabolic_knife", "tag_inhand" );
		self.knife_attached = undefined;
	}
	
}

shepherd_attach_knife()
{
	if( !isdefined( self.knife_attached ) )
	{
		self attach( "weapon_parabolic_knife", "tag_inhand" );
		self.knife_attached = true;
	}
}