#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\_blizzard;
#include maps\_vehicle_spline;

VEH_SPEED_MIN = 75;
VEH_SPEED_NORMAL = 100;
VEH_SPEED_MAX = 120;

VEH_SLOWDOWN_AMOUNT = 8;
VEH_SLOWDOWN_AMOUNT_MIN = VEH_SLOWDOWN_AMOUNT * 5;

SPEED_BALANCE_DIST_MIN = 500;	// no cheating when within this range
SPEED_BALANCE_DIST_MAX = 5000;	// full cheat when you are this far behind
SPEED_BALANCE_INTERVAL = 0.1;
SPEED_BALANCE_MAX_HELP = VEH_SPEED_MAX - VEH_SPEED_NORMAL;

init_snow_race()
{
	battlechatter_off( "axis" );
	battlechatter_off( "allies" );
	
	global_init();
	
	flag_init( "so_snowrace_complete" );
	flag_init( "race_started" );
	flag_init( "finish_line" );
	
	// disable revive so we can shoot each other during the race without killing each other
	if ( is_coop() )
	{
		level.vehicle_crash_func = ::player_snowmobile_downed;
		flag_clear( "coop_revive" );
		flag_clear( "player_can_die_on_snowmobile" );
	}
	
	players_on_snowmobiles();
	init_slope_trees();
	
	array_thread( getentarray( "player_reset_trigger", "targetname" ), ::player_reset_position_tracking );
	
	thread fade_challenge_in();
	thread fade_challenge_out( "so_snowrace_complete" );
	
	if ( is_coop() )
	{
		foreach( player in level.players )
			player thread maps\_coop::createFriendlyHudIcon_Normal();
	}
	
	finish_line_origin = getent( "finish_line_origin", "targetname" );
	objective_add( 1, "current", &"SO_SNOWRACE1_CLIFFHANGER_OBJ_FINISHLINE", finish_line_origin.origin );
	objective_setpointertextoverride( 1, &"SO_SNOWRACE1_CLIFFHANGER_FINISHLINE" );
}

global_init()
{
	level.so_compass_zoom = "far";
	
	maps\cliffhanger_precache::main();
	
	maps\_load::set_player_viewhand_model( "viewhands_player_arctic_wind" );
	maps\_snowmobile_drive::snowmobile_preLoad( "viewhands_player_arctic_wind", "vehicle_snowmobile_player" );

	PreCacheItem( "hind_turret_penetration" );
	PreCacheItem( "hind_FFAR" );
	PreCacheItem( "zippy_rockets" );
	PreCacheItem( "c4" );
	
	PreCacheModel( "com_computer_keyboard_obj" );
	
	PreCacheShader( "overhead_obj_icon_world" );
	
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_OBJ_FINISHLINE" );
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_FINISHLINE" );
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_RACE_READY" );
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_RACE_3" );
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_RACE_2" );
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_RACE_1" );
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_RACE_GO" );
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_PERFECT_TIMING" );
	
	maps\createart\cliffhanger_art::main();
	maps\cliffhanger_fx::main();
	maps\createfx\cliffhanger_audio::main();
	
	maps\_load::main();
	
	setsaveddvar( "ui_hidemap", "1" );
	//maps\_compass::setupMiniMap( "compass_map_cliffhanger" );
	
	thread blizzard_level_transition_snowmobile ( 1 );
}

players_on_snowmobiles()
{
	vehSpawners = getvehiclespawnerarray( "player_snowmobile_spawner_specops" );
	assert( vehSpawners.size >= level.players.size );
	foreach( i, player in level.players )
	{
		player enableHealthShield( true );
		player enableDeathShield( true );
		player.snowmobile_spawner = vehSpawners[ i ];
		player.snowmobile = player spawn_new_snowmobile_and_drive();
		player thread slow_player_on_damage();
	}
}

spawn_new_snowmobile_and_drive( optionalTeleportOrg, optionalTeleportAng )
{
	assert( isdefined( self.snowmobile_spawner ) );
	
	self.snowmobile_spawner.count = 1;
	snowmobile = self.snowmobile_spawner spawn_vehicle();
	assert( isdefined( snowmobile ) );
	
	if ( isdefined( optionalTeleportOrg ) && isdefined( optionalTeleportOrg ) )
		snowmobile vehicle_Teleport( optionalTeleportOrg, optionalTeleportAng ) ;
	
	snowmobile thread maps\_snowmobile_drive::drive_vehicle();
	self mountVehicle( snowmobile );
	snowmobile.veh_topspeed = VEH_SPEED_NORMAL;
	snowmobile.damage_slowdown = 0;
	
	snowmobile.resetPos = snowmobile.origin;
	snowmobile.resetAng = snowmobile.angles;
	
	return snowmobile;
}

slow_player_on_damage()
{
	self endon( "death" );
	for(;;)
	{
		self waittill( "damage", damage, attacker );
		
		if ( !isplayer( attacker ) )
			continue;
		
		self.snowmobile thread slow_down_vehicle();
	}
}

slow_down_vehicle()
{	
	// slow vehicle by a percentage, and cap it so we don't crawl to a stop
	self.damage_slowdown += VEH_SLOWDOWN_AMOUNT;
	if ( self.damage_slowdown > VEH_SLOWDOWN_AMOUNT_MIN )
		self.damage_slowdown = VEH_SLOWDOWN_AMOUNT_MIN;
	
	wait 1.5;
	
	self.damage_slowdown -= VEH_SLOWDOWN_AMOUNT;
	if ( self.damage_slowdown < 0 )
		self.damage_slowdown = 0;
}

start_race()
{
	foreach( player in level.players )
		player freezeControls( true );
	
	wait 1;
	
	text = createFontString( "default", 3.0 );
	text.hidewheninmenu = true;
	text setPoint( "TOP", undefined, 0, 30 );
	text.sort = 0.5;
	
	text settext( &"SO_SNOWRACE1_CLIFFHANGER_RACE_READY" );
	wait 2;
	text settext( &"SO_SNOWRACE1_CLIFFHANGER_RACE_3" );
	wait 1;
	text settext( &"SO_SNOWRACE1_CLIFFHANGER_RACE_2" );
	wait 1;
	text settext( &"SO_SNOWRACE1_CLIFFHANGER_RACE_1" );
	wait 1;
	text settext( &"SO_SNOWRACE1_CLIFFHANGER_RACE_GO" );
	
	foreach( player in level.players )
	{
		player freezeControls( false );
		player thread start_race_boost();
	}
	
	flag_set( "race_started" );
	
	thread race_music();
	
	wait 1;
	
	text destroyElem();
}

start_race_boost()
{
	BOOST_WINDOW = 0.2;
	
	// gassed it too soon
	if ( self attackButtonPressed() )
		return;
	
	// window of opportunity
	while( !self attackButtonPressed() )
	{
		wait 0.05;
		BOOST_WINDOW -= 0.05;
		if ( BOOST_WINDOW <= 0 )
			return;
	}
	
	// player gets a boost
	assert( isdefined( self.vehicle ) );
	self.vehicle thread give_vehicle_boost( 50 );
	
	text = self createClientFontString( "default", 3.0 );
	text.hidewheninmenu = true;
	text setPoint( "TOP", undefined, 0, 80 );
	text.sort = 0.5;
	
	text settext( &"SO_SNOWRACE1_CLIFFHANGER_PERFECT_TIMING" );
	wait 2;
	text destroyElem();
}

give_vehicle_boost( boostToSpeed )
{
	speed = int( self vehicle_GetSpeed() );
	if ( speed >= boostToSpeed )
		return;
	
	while( isdefined( self ) )
	{
		speed += 5;
		if ( speed > boostToSpeed )
			break;
		
		self VehPhys_SetSpeed( speed );
		wait 0.05;
	}
	if ( isdefined( self ) )
		self VehPhys_SetSpeed( boostToSpeed );
}

end_race_cleanup()
{
	if ( !is_coop() )
		return;
	foreach( player in level.players )
	{
		array_thread( player.snowmobile.riders, ::stop_magic_bullet_shield );
	}
}

speed_balance()
{
	// no speed balancing for only one player
	if ( !is_coop() )
		return;
	
	// assuming only 2 players ever
	assert( isdefined( level.player ) );
	assert( isdefined( level.player.snowmobile ) );
	assert( isdefined( level.player2 ) );
	assert( isdefined( level.player2.snowmobile ) );
	
	level.speed_balance_location = getent( "speed_balance_origin", "targetname" );
	assert( isdefined( level.speed_balance_location ) );
	level.speed_balance_location = level.speed_balance_location.origin;
	
	array_thread( getentarray( "speed_balance_trigger", "targetname" ), ::speed_balance_trigger );
	
	flag_wait( "race_started" );
	
	for(;;)
	{
		player1_dist = distance( level.player.snowmobile.origin, level.speed_balance_location );
		player2_dist = distance( level.player2.snowmobile.origin, level.speed_balance_location );
		
		playerWinning = level.player;
		playerLosing = level.player2;
		if ( player1_dist > player2_dist )
		{
			playerWinning = level.player2;
			playerLosing = level.player;
		}
		gap = abs( player1_dist - player2_dist );
		
		// players go normal speed by default
		playerWinning.snowmobile.veh_topspeed = VEH_SPEED_NORMAL - playerWinning.snowmobile.damage_slowdown;
		playerLosing.snowmobile.veh_topspeed = VEH_SPEED_NORMAL - playerLosing.snowmobile.damage_slowdown;
		
		if ( gap <= SPEED_BALANCE_DIST_MIN )
		{
			wait SPEED_BALANCE_INTERVAL;
			continue;
		}
		
		// get a percentage how far behind the player is between min and max
		distanceFraction = abs( ( gap - SPEED_BALANCE_DIST_MIN ) / ( SPEED_BALANCE_DIST_MIN - SPEED_BALANCE_DIST_MAX ) );
		distanceFraction = cap_value( distanceFraction, 0.0, 1.0 );
		
		CHEATED_VEH_TOPSPEED = VEH_SPEED_NORMAL + ( SPEED_BALANCE_MAX_HELP * distanceFraction );
		
		playerLosing.snowmobile.veh_topspeed = CHEATED_VEH_TOPSPEED - playerLosing.snowmobile.damage_slowdown;
		
		wait SPEED_BALANCE_INTERVAL;
	}
}

speed_balance_trigger()
{
	assert( isdefined( self.target ) );
	org = getent( self.target, "targetname" );
	assert( isdefined( org ) );
	
	self waittill( "trigger" );
	
	level.speed_balance_location = org.origin;
}

race_music()
{
	while ( 1 )
	{
		musicPlayWrapper( "cliffhanger_snowmobile" );
		wait 212;
	}
}

player_snowmobile_downed( vehicle )
{
	self.ignoreRandomBulletDamage = true;
	self EnableInvulnerability();
	self.health = 2;
	self.maxhealth = self.original_maxhealth;
	self.ignoreme = true;
	
	wait 1.5;
	
	self put_player_back_on_snowmobile( vehicle );
	
	self.ignoreRandomBulletDamage = false;
	self.health = self.maxhealth;
	self.ignoreme = false;
	self DisableInvulnerability();
}

put_player_back_on_snowmobile( vehicle )
{
	assert( isplayer( self ) );
	assert( isdefined( vehicle ) );
	assert( isdefined( vehicle.resetPos ) );
	assert( isdefined( vehicle.resetAng ) );
	
	array_thread( vehicle.riders, ::stop_magic_bullet_shield );
	vehicle.coop_model delete();
	vehicle delete();
	
	self endSliding();
	self.snowmobile = self spawn_new_snowmobile_and_drive( vehicle.resetPos, vehicle.resetAng );
	
	if ( isdefined( level.track_player_positions ) )
		self thread track_player_progress( self.snowmobile.origin );
	
	//self thread maps\_snowmobile_drive::drive_crash_detection( vehicle );
	//self mountVehicle( vehicle );
}


player_reset_position_tracking()
{
	assert( isdefined( self.target ) );
	ent = getent( self.target, "targetname" );
	assert( isdefined( ent ) );
	
	for(;;)
	{
		self waittill( "trigger", vehicle );
		
		if ( !isdefined( vehicle ) )
			continue;
		
		vehicle.resetPos = ent.origin;
		vehicle.resetAng = ent.angles;
	}
}

init_slope_trees()
{
	slope_trees = GetEntArray( "slope_tree", "targetname" );
	top_of_hill = getstruct( "top_of_hill", "targetname" );

	slope_trees = get_array_of_closest( top_of_hill.origin, slope_trees );

	if ( level.gameskill == 0 )
	{
		slope_trees = array_delete_evenly( slope_trees, 2, 3 );
	}
	else
	if ( level.gameskill == 1 )
	{
		slope_trees = array_delete_evenly( slope_trees, 1, 2 );
	}

	slope_tree_clip = GetEntArray( "slope_tree_clip", "targetname" );
	foreach ( index, slope_tree in slope_trees )
	{
		AssertEx( IsDefined( slope_tree_clip[ index ] ), "Not enough slope_tree_clip placed in the map" );
		slope_tree.clip = slope_tree_clip[ index ];
		slope_tree_clip[ index ] = undefined;
	}

	// delete the excess clip
	foreach ( clip in slope_tree_clip )
	{
		clip Delete();
	}

	array_thread( slope_trees, ::slope_tree_think );
}

slope_tree_think()
{
	//foliage_tree_pine_snow_lg_b
	yaw = randomint( 360 );
	self.angles = ( 0, yaw, 0 );
	range = 64;
	offset = randomint( range * 2 ) - range;

	//Line( self.origin, self.origin + ( offset, 0, 0 ), (1,0,0), 1, 0, 5000 );
	self.origin += ( offset, 0, 0 );
	trace = BulletTrace( self.origin + (0,0,64), self.origin + (0,0,-64), false, undefined );
	self.origin = trace[ "position" ] + (0,0,-8);
	// self hide();
	self.clip hide();
	self.clip.origin = self.origin;
	//Line( self.origin, self.clip.origin + ( offset, 0, 0 ), (0,1,0), 1, 0, 5000 );
	
	ent = common_scripts\_createfx::createLoopSound();
	ent.v[ "origin" ] = self.origin;
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "soundalias" ] = "velocity_whitenoise_loop";
}