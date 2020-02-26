#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\so_snowrace_code;

FLAG_TIME_VALUE = 4.0;

USE_FLARES = false;

main()
{
	level._effect[ "flare_red" ] = loadfx( "misc/flare_ambient" );
	level._effect[ "flare_green" ] = loadfx( "misc/flare_ambient_green" );
	
	init_snow_race();
	
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	so_delete_all_spawners();
	
	flag_gates();
	
	thread start_race();
	thread finishline();
	
	time_limit[ "easy" ] = 30;
	time_limit[ "medium" ] = 15;
	time_limit[ "hard" ] = 10;
	time_limit[ "fu" ] = 5;
	
	difficulty = getDifficulty();
	assert( isdefined( time_limit[ difficulty ] ) );
	level.challenge_time_limit = time_limit[ difficulty ];
	level.challenge_time_silent = true;
	
	level.no_snowmobile_attack_hint = true;
	level.challenge_time_nudge = 6;
	level.challenge_time_hurry = 3;
	thread manage_timer();
	level.challenge_time_force_on = true;
	thread enable_challenge_timer( "race_started", "finish_line", &"SO_SNOWRACE1_CLIFFHANGER_SPECOP_TIMER" );
}

manage_timer()
{
	flag_wait( "race_started" );
	
	timer = 0.1;
	
	for(;;)
	{
		level.challenge_time_limit -= timer;
		wait timer;
	}
}

flag_gates()
{
	// allow for different flags to be used for different difficulties or sp/coop
	array_thread( getentarray( "flag_trigger", "targetname" ), ::gate_think );
}

gate_think()
{
	assert( isdefined( self.target ) );
	flags = getentarray( self.target, "targetname" );
	assert( flags.size == 2 );
	
	if ( USE_FLARES )
	{
		fxEnts = [];
		foreach( i, pole in flags )
		{
			trace = bulletTrace( pole.origin + ( 0, 0, 30 ), pole.origin - ( 0, 0, 30 ), false, pole );
			fxEnts[ i ] = spawn( "script_model", trace[ "position" ] );
			fxEnts[ i ] setModel( "tag_origin" );
			fxEnts[ i ].angles = vectorToAngles( trace[ "normal" ] );
		}
		
		foreach( ent in fxEnts )
			playFXOnTag( getfx( "flare_red" ), ent, "tag_origin" );
		
		//getfx( "flare_green" )
	}
	
	level endon( "special_op_terminated" );
	self waittill( "trigger" );
	level thread play_sound_in_space( "snowrace_flag_capture", self.origin + ( 0, 0, 40 ) );
	self delete();
	array_call( flags, ::delete );
	
	level notify( "new_challenge_timer" );
	level.challenge_time_limit += FLAG_TIME_VALUE;
	thread enable_challenge_timer( "race_started", "finish_line", &"SO_SNOWRACE1_CLIFFHANGER_SPECOP_TIMER" );
}

finishline()
{
	trigger = getent( "finishline", "targetname" );
	assert( isdefined( trigger ) );
	
	trigger waittill( "trigger", player );
	
	assert( isplayer( player ) );
	assert( isdefined( player.playername ) );
	
	end_race_cleanup();
	
	flag_set( "finish_line" );
	flag_set( "so_snowrace_complete" );
}