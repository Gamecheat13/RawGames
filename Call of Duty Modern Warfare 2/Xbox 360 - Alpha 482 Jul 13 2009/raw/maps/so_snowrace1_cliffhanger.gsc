#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_specialops_code;
#include maps\_hud_util;
#include maps\so_snowrace_code;
#include maps\_vehicle_spline;

main()
{
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_RACE_WINNER" );
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_SPECOP_TIMER" );
	precacheString( &"SPECIAL_OPS_WAITING_OTHER_PLAYER" );
	
	precacheShader( "difficulty_star" );
	
	init_snow_race();
	
	flag_init( "individual_timers" );
	flag_init( "race_has_winner" );
	
	// This makes it so that all players have individual timers. When one player finishes the other timers keep running.
	flag_set( "individual_timers" );
	
	array_thread( level.players, ::ent_flag_init, "finish_line" );
	
	level.raceWinner = undefined;
	
	thread start_race();
	thread finishline();
	thread speed_balance();
	thread enemies();
	
	if ( !is_coop() )
	{
		// in SP you try to get a fast time
		level.no_snowmobile_attack_hint = true;
	}

	level.challenge_time_force_on = true;
	thread star_challenge( 70, 90 );
	thread enable_challenge_timer( "race_started", "finish_line" );
}

finishline()
{
	playersRequired = level.players.size;
	trigger = getent( "finishline", "targetname" );
	assert( isdefined( trigger ) );
	
	// wait for all players to cross the finish line
	for(;;)
	{
		trigger waittill( "trigger", player );
		assert( isplayer( player ) );
		
		// a player crossed the finish line
		if ( isdefined( player.crossed_finish_line ) )
			continue;
		player.crossed_finish_line = true;
		
		// stop the players timer
		player ent_flag_set( "finish_line" );
		
		// freeze player
		player EnableInvulnerability();
		player FreezeControls( true );
		player.ignoreme = true;
		player setBlurForPlayer( 6, 1 );
		assert( isdefined( player.vehicle ) );
		player.vehicle thread stop_vehicle();
		
		// this player is the winner
		if ( !isdefined( level.raceWinner ) )
		{
			level.raceWinner = player;
			flag_set( "race_has_winner" );	// makes all other players lose all but one of their stars on the HUD
			if ( is_coop() )
			{
				assert( isdefined( player.playername ) );
				iprintlnbold( &"SO_SNOWRACE1_CLIFFHANGER_RACE_WINNER", player.playername );
			}
		}
		
		playersRequired--;
		if ( playersRequired <= 0 )
			break;
		
		// print message on screen that we're waiting for other players
		player thread finishline_waiting_for_players_message();
	}
	
	// wait for level.winnerGameSkill to get updated
	waittillframeend;
	
	// winner gets stars but everyone else gets only 1
	assert( isdefined( level.raceWinner ) );
	player = undefined;
	foreach( player in level.players )
	{
		if ( player == level.raceWinner )
			player.forcedGameSkill = level.winnerGameSkill;
		else
			player.forcedGameSkill = 1;
	}
	
	
	end_race_cleanup();
	flag_set( "finish_line" );
	waittillframeend;
	flag_set( "so_snowrace_complete" );
}

finishline_waiting_for_players_message()
{
	waiting_hud = create_waiting_message( self, &"SPECIAL_OPS_WAITING_OTHER_PLAYER" );
	flag_wait( "finish_line" );
	waiting_hud destroy();
}

stop_vehicle()
{
	speed = int( self vehicle_GetSpeed() );
	while( isdefined( self ) )
	{
		speed -= 2;
		if ( speed < 0 )
			break;
		
		self VehPhys_SetSpeed( speed );
		wait 0.05;
	}
	if ( isdefined( self ) )
		self VehPhys_SetSpeed( 0 );
}

enemies()
{
	skill = getDifficulty();
	switch( skill )
	{
		case "easy":
		case "medium":
			return;
		case "hard":
			level.enemy_snowmobiles_max = 6;
			break;
		case "fu":
			level.enemy_snowmobiles_max = 12;
			break;
	}
	
	level.track_player_positions = true;
	level.DODGE_DISTANCE = 500;
	level.POS_LOOKAHEAD_DIST = 200;
	
	level.moto_drive = false;
	if ( getdvar( "moto_drive" ) == "" )
		setdvar( "moto_drive", "0" );
	
	thread maps\cliffhanger_code::enemy_init();
	init_vehicle_splines();
	
	flag_set( "reached_top" );
	
	foreach( player in level.players )
	{
		player thread track_player_progress( player.snowmobile.origin );
		player.baseIgnoreRandomBulletDamage = true;
	}
	
	level.ignoreRandomBulletDamage = true;
	setsaveddvar( "sm_sunSampleSizeNear", 1 );
	level.bike_score = 0;
	wait( 2.4 );
	thread enemy_snowmobiles_spawn_and_attack();
}

enemy_snowmobiles_spawn_and_attack()
{
	level endon( "snowmobile_jump" );
	level endon( "enemy_snowmobiles_wipe_out" );
	wait_time = 2;

	for ( ;; )
	{
		thread spawn_enemy_bike_snowrace();
		wait( wait_time );
		wait_time -= 0.5;
		if ( wait_time < 0.5 )
			wait_time = 0.5;
	}
}

within_fov_allplayers( pos )
{
	in_fov = false;
	foreach( player in level.players )
	{
		if ( within_fov( player.origin, player.angles, pos, 0 ) )
			return true;
	}
	return false;
}

spawn_enemy_bike_snowrace()
{
	assertex( isdefined( level.enemy_snowmobiles ), "Please add maps\_vehicle_spline::init_vehicle_splines(); to the beginning of your script" );
	
	/#
	debug_enemy_vehicles();
	#/
	
	if ( level.enemy_snowmobiles.size >= level.enemy_snowmobiles_max )
		return;

	player_targ = get_player_targ();
	player_progress = get_player_progress();
	my_direction = "forward";
	
	spawn_array = get_spawn_position( player_targ, player_progress - 1000 - level.POS_LOOKAHEAD_DIST );
	spawn_pos = spawn_array["spawn_pos"];
	
	player_sees_me_spawn = within_fov_allplayers( spawn_pos );
	
	if ( player_sees_me_spawn )
	{ 
		// player could see us so try spawning in front of the player and drive backwards
		spawn_array = get_spawn_position( player_targ, player_progress + 1000 );
		spawn_pos = spawn_array["spawn_pos"];
		my_direction = "backward";
		player_sees_me_spawn = within_fov_allplayers( spawn_pos );
		if ( player_sees_me_spawn )
		{
			return;
		}
	}
	
	// found a safe spawn pos
	spawn_pos = drop_to_ground( spawn_pos );
	
	snowmobile_spawner = getent( "snowmobile_spawner", "targetname" );
	assertEx( isdefined( snowmobile_spawner ), "Need a snowmobile spawner with targetname snowmobile_spawner in the level" );
	targ = spawn_array["targ"];

	snowmobile_spawner.origin = spawn_pos;
	
	//snowmobile_spawner.angles = vectortoangles( snowmobile_path_node.next_node.midpoint - snowmobile_path_node.midpoint );
	snowmobile_spawner.angles = vectortoangles( targ.next_node.midpoint - targ.midpoint );
	/*
	if ( isalive( level.player ) && isdefined( level.player.vehicle ) )
		snowmobile_spawner.angles = level.player.vehicle.angles;
	*/
	
	ai_spawners = snowmobile_spawner get_vehicle_ai_spawners();
	foreach ( spawner in ai_spawners )
	{
		spawner.origin = snowmobile_spawner.origin;
	}

	bike = vehicle_spawn( snowmobile_spawner );
	bike.offset_percent = spawn_array["offset"];
	bike VehPhys_SetSpeed( 95 );
	
	bike thread crash_detection();
	bike.left_spline_path_time = gettime() - 3000;
	waittillframeend; // for bike.riders to get defined
	if ( !isalive( bike ) )
		return;
	
	targ bike_drives_path( bike );
}

star_challenge( three_star_time, two_star_time )
{
	level.winnerGameSkill = 3;
	
	foreach( player in level.players )
	{
		player thread star_challenge_hud( 2, three_star_time );
		player thread star_challenge_hud( 1, two_star_time );
		player thread star_challenge_hud( 0 );
	}
	
	three_star_time *= 1000;
	two_star_time *= 1000;
	
	flag_wait( "race_started" );
	start_time = gettime();
	flag_wait( "race_has_winner" );
	
	elapsedTime = gettime() - start_time;
	if ( elapsedTime <= three_star_time )
		level.winnerGameSkill = 3;
	else if ( elapsedTime <= two_star_time )
		level.winnerGameSkill = 2;
	else
		level.winnerGameSkill = 1;
}

star_challenge_hud( x_pos_offset, removeTimer )
{
	star_width = 25;
	ypos = maps\_specialops::so_hud_ypos();
	
	star = maps\_specialops::so_create_hud_item( 3, ypos, undefined, self );
	star.x = -10 - ( x_pos_offset * star_width );
	star setShader( "difficulty_star", 25, 25 );
	
	if ( !isdefined( removeTimer ) )
		return;
	
	flag_wait( "race_started" );
	
	self thread star_challenge_sound( removeTimer );
	level waittill_any_timeout( removeTimer, "race_has_winner" );
	
	if ( isdefined( level.raceWinner ) && self == level.raceWinner )
		return;
	
	star destroy();
}

star_challenge_sound( removeTimer )
{
	level endon( "race_has_winner" );
	
	secondsToTick = 5;
	timeToWait = removeTimer - secondsToTick;
	assert( timeToWait > 0 );
	
	wait timeToWait;
	
	for( i = 0 ; i < secondsToTick ; i++ )
	{
		self PlayLocalSound( "so_snowrace_star_tick" );
		wait 1;
	}
	self PlayLocalSound( "so_snowrace_star_lost" );
}