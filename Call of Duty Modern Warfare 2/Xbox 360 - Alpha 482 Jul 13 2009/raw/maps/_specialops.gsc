#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_specialops_code;

specialops_init()
{
	if ( !isdefined( level.so_override ) )
		level.so_override = [];

	// End game summaries
	precachemenu( "sp_eog_summary" );
	precachemenu( "coop_eog_summary" );
	precachemenu( "coop_eog_summary2" );

	// Timer and screen info
	precacheShader( "hud_show_timer" );
	foreach ( player in level.players )
	{
		player.so_hud_show_time = gettime() + ( so_standard_wait() * 1000 );
		player ent_flag_init( "so_hud_can_toggle" );
	}
		
	// Default timer settings
	level.challenge_time_nudge = 30;	// Yellow warning at 30 seconds
	level.challenge_time_hurry = 15;	// Red Hurry Up at 15 seconds
	
	// Default friendly fire scaler.
	setsaveddvar( "g_friendlyfireDamageScale", 2 );
	
	if ( isdefined( level.so_compass_zoom ) )
	{
		compass_dist = 0;
		switch ( level.so_compass_zoom )
		{
			case "close":	compass_dist = 1500; break;
			case "far":		compass_dist = 6000; break;
			default:		compass_dist = 3000; break;
		}
		if ( !issplitscreen() )
			compass_dist += ( compass_dist * 0.1 );	// Additional 10% in non-splitscreen.
		setsaveddvar( "compassmaxrange", compass_dist );
	}
	
	// Flag Inits
	flag_init( "challenge_timer_passed" );
	flag_init( "challenge_timer_expired" );
	flag_init( "special_op_succeeded" );
	flag_init( "special_op_failed" );

	// Savegames
	thread disable_saving();
	thread specialops_detect_death();

	// Dialog
	specialops_dialog_init();
	if ( is_coop() )
	{
		maps\_specialops_battlechatter::init();
	}
	else
	{
		// a little easier/different in solo play
		set_custom_gameskill_func( maps\_gameskill::solo_player_in_special_ops );
	}
		
	// Clear out the deadquote.
	level.so_deadquotes_chance = 0.5;	// 50/50 chance of using level specific deadquotes.
	setdvar( "ui_deadquote", "" );
	thread so_special_failure_hint();
	
	// For no longer opening level selection in spec ops after returning from a splitscreen game
	setdvar( "ui_skip_level_select", "1" );
	
	pick_starting_location_so();
}

// Call this to get whatever the standard time before we turn the hud on is.
so_standard_wait()
{
	return 4;
}

specialops_remove_unused()
{
	entarray = getentarray();
	if ( !isdefined( entarray ) )
		return;

	special_op_state = is_specialop();
	foreach ( ent in entarray )
	{
		if ( ent specialops_remove_entity_check( special_op_state ) )
			ent Delete();
	}
}

/*
=============
///ScriptDocBegin
"Name: enable_triggered_start( <challenge_id_start> )"
"Summary: Waits until the specified trigger is triggered, and then sets the flag which is used to kick off challenges."
"Module: Utility"
"MandatoryArg: <challenge_id_start>: Name of the flag *and* trigger that is used to start off the challenge."
"Example: enable_triggered_start( "challenge_start" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
enable_triggered_start( challenge_id_start )
{
	level endon( "challenge_timer_expired" );

	trigger_ent = getent( challenge_id_start, "script_noteworthy" );
	AssertEx( isdefined( trigger_ent ), "challenge_id (" + challenge_id_start + ") was unable to match with a valid trigger." );
	
	trigger_ent waittill( "trigger" );
	flag_set( challenge_id_start );
}

/*
=============
///ScriptDocBegin
"Name: enable_triggered_complete( <challenge_id> , <challenge_id_complete> , <touch_style> )"
"Summary: Waits for all players in the game to be touching the trigger, then sets the challenge complete flag."
"MandatoryArg: <challenge_id>: Name of the trigger all players need to be touching. A matching flag will be set to true to enable any additional needed entities."
"MandatoryArg: <challenge_id_complete>: Flag to set once all players are touching the trigger."
"OptionalArg: <touch_style>: Method of touching to test. "all" = all players must be touching at the same time. "any" = all players must have touched it at some point, but don't need to currently. "freeze" = when a player touches the trigger freeze them and wait for the others."
"Module: Utility"
"Example: enable_triggered_complete( "challenge_trigger", "challenge_complete", "freeze" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
enable_triggered_complete( challenge_id, challenge_id_complete, touch_style )
{
	level endon( "challenge_timer_expired" );

	flag_set( challenge_id );
	
	if ( !isdefined( touch_style ) )
		touch_style = "freeze";

	trigger_ent = getent( challenge_id, "script_noteworthy" );
	AssertEx( isdefined( trigger_ent ), "challenge_id (" + challenge_id + ") was unable to match with a valid trigger." );
		
	switch ( touch_style )
	{
		case "all"		: wait_all_players_are_touching( trigger_ent ); break;
		case "any"		: wait_all_players_have_touched( trigger_ent, touch_style ); break;
		case "freeze"	: wait_all_players_have_touched( trigger_ent, touch_style ); break;
	}

	level.challenge_end_time = gettime();
	flag_set( challenge_id_complete );
}

/*
=============
///ScriptDocBegin
"Name: fade_challenge_in( <wait_time>, <doDialogue> )"
"Summary: Simple fade in for use at the start of challenges without anything special for their intro."
"Module: Utility"
"OptionalArg: <wait_time>: If defined will wait on black for specified time."
"OptionalArg: <doDialogue>: Sets whether the 'ready up' dialogue will play after fading the screen up."
"Example: fade_challenge_in();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
fade_challenge_in( wait_time, doDialogue )
{
	if ( !isdefined( wait_time ) )
		wait_time = 0.5;
		
	screen_fade = create_client_overlay( "black", 1 );
	wait wait_time;

	screen_fade thread fade_over_time( 0, 1 );
	wait 0.75;
	
	if( !IsDefined( doDialogue ) || ( IsDefined( doDialogue ) && doDialogue ) )
	{
		thread so_dialog_ready_up();
	}
}

/*
=============
///ScriptDocBegin
"Name: fade_challenge_out( <challenge_id> )"
"Summary: Freezes players, fades out music, fades out the scene, and if requested posts an end of game summary."
"Module: Utility"
"OptionalArg: <challenge_id>: Flag to wait to be set before completing the challenge."
"Example: fade_challenge_out( true, "challenge_complete" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
fade_challenge_out( challenge_id )
{
	if ( isdefined( challenge_id ) )
		flag_wait( challenge_id );
	
//	radio_dialogue_stop();
	thread so_dialog_mission_success();	

	specialops_mission_over_setup( true );
	
	setdvar( "ui_mission_success", 1 );
	maps\_endmission::coop_eog_summary();

	specialops_summary_player_choice();
}

/*
=============
///ScriptDocBegin
"Name: enable_countdown_timer( <time_wait>, <set_start_time>, <message>, <timer_draw_delay> )"
"Summary: Creates a timer on the screen that countsdown and marks the start of the challenge time when the timer has expired."
"Module: Utility"
"MandatoryArg: <time_wait>: The amount of time to count down from and wait."
"OptionalArg: <set_start_time>: If true, then will set level.challenge_start_time once the timer completes."
"OptionalArg: <message>: Optional message to display."
"OptionalArg: <timer_draw_delay>: When set, will pause for this long before drawing the timer after the message."
"Example: enable_start_countdown( 10 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
enable_countdown_timer( time_wait, set_start_time, message, timer_draw_delay )
{
	level endon( "special_op_terminated" );
	
	if ( !isdefined( message ) )
		message = &"SPECIAL_OPS_STARTING_IN";
	
	hudelem = so_create_hud_item( 0, so_hud_ypos(), message );
	hudelem SetPulseFX( 50, time_wait * 1000, 500 );

	hudelem_timer = so_create_hud_item( 0, so_hud_ypos() );
	hudelem_timer thread show_countdown_timer_time( time_wait, timer_draw_delay );
	
	wait time_wait;
	level.player PlaySound( "arcademode_zerodeaths" );
	
	if ( isdefined( set_start_time ) && set_start_time )
		level.challenge_start_time = gettime();

	thread destroy_countdown_timer( hudelem, hudelem_timer );
}

destroy_countdown_timer( hudelem, hudelem_timer )
{
	wait 1;		
	hudelem Destroy();
	hudelem_timer Destroy();
}

show_countdown_timer_time( time_wait, delay )
{
	self.alignX = "left";
	self settenthstimer( time_wait );
	self.alpha = 0;

	if ( !isdefined( delay ) )
		delay = 0.625;
	wait delay;
	time_wait = int( ( time_wait - delay ) * 1000 );

	self SetPulseFX( 50, time_wait, 500 );
	self.alpha = 1;
}

/*
=============
///ScriptDocBegin
"Name: enable_challenge_timer( <start_flag> , <passed_flag> , <message> )"
"Summary: Will put up an on screen timer that counts down if level.challenge_time_limit is set, otherwise counts up from 0:00.0."
"Module: Utility"
"MandatoryArg: <start_flag>: Flag that the script will wait for before starting the timer."
"MandatoryArg: <passed_flag>: Flag that the script will wait for to determine challenge success and stop the timer."
"OptionalArg: <message>: Custom message you want displayed in front of the timer."
"Example: enable_challenge_timer( "player_reached_start", "player_reached_end", "Time remaining: " );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
enable_challenge_timer( start_flag, passed_flag, message )
{
	assertex( isdefined( passed_flag ), "display_challenge_timer_down() needs a valid passed_flag." );

	if ( isdefined( start_flag ) )
	{	
		if ( !flag_exist( start_flag ) )
			flag_init( start_flag );
		level.start_flag = start_flag;
	}
	
	if ( isdefined( passed_flag ) )
	{	
		if ( !flag_exist( passed_flag ) )
			flag_init( passed_flag );
		level.passed_flag = passed_flag;
	}
	
	if ( !isdefined( message ) )
		message = &"SPECIAL_OPS_TIME";

	if ( !isdefined( level.challenge_time_beep_start ) )
		level.challenge_time_beep_start = 5;
	level.so_challenge_time_beep = level.challenge_time_beep_start + 1;

	foreach ( player in level.players )
		player thread challenge_timer_player_setup( start_flag, passed_flag, message );
}

/*
=============
///ScriptDocBegin
"Name: attacker_is_p1( <attacker> )"
"Summary: Returns true if the attacker was player 1."
"Module: Utility"
"MandatoryArg: <attacker>: Entity to test against player 1."
"Example: credit_player_1 = attacker_is_p1( attacker );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
attacker_is_p1( attacker )
{
	if ( !isdefined( attacker ) )
		return false;
	
	return attacker == level.player;
}

/*
=============
///ScriptDocBegin
"Name: attacker_is_p2( <attacker> )"
"Summary: Returns true if the attacker was player 2 in a co-op game."
"Module: Utility"
"MandatoryArg: <attacker>: Entity to test against player 2."
"Example: credit_player_2 = attacker_is_p2( attacker );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
attacker_is_p2( attacker )
{
	if ( !is_coop() )
		return false;

	if ( !isdefined( attacker ) )
		return false;
		
	return attacker == level.player2;
}

/*
=============
///ScriptDocBegin
"Name: enable_escape_warning( <enable_escape_warning> )"
"Summary: Waits for the flag 'player_trying_to_escape' to be set, then displays a hint to any players touching a trigger with script_noteworthy matching 'player_trying_to_escape'. Removes the hint when no longer touching the trigger. Does not currently support more than one potential exit point"
"Module: Utility"
"Example: enable_escape_warning()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
enable_escape_warning()
{
	level.escape_warning_triggers = getentarray( "player_trying_to_escape", "script_noteworthy" );
	assertex( level.escape_warning_triggers.size > 0, "enable_escape_warning() requires at least one trigger with script_noteworthy = player_trying_to_escape" );

	add_hint_string( "player_escape_warning", &"SPECIAL_OPS_ESCAPE_WARNING", ::disable_escape_warning );
	while( true )
	{
		wait 0.05;
		foreach ( trigger in level.escape_warning_triggers )
		{
			foreach ( player in level.players )
			{
				if ( !isdefined( player.escape_hint_active ) )
				{
					if ( player istouching( trigger ) )
					{
						player.escape_hint_active = true;
						player display_hint_timeout( "player_escape_warning" );
					}
				}
			}
		}
	}
}

/*
=============
///ScriptDocBegin
"Name: enable_escape_failure( <enable_escape_failure> )"
"Summary: Waits for the flag 'player_has_escaped' to be set, and when hit displays the deadquote indicating mission failure and ends the mission."
"Example: enable_escape_failure()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
enable_escape_failure()
{
	flag_wait( "player_has_escaped" );

	level.challenge_end_time = gettime();

	so_force_deadquote( "@DEADQUOTE_SO_LEFT_PLAY_AREA" );
	maps\_utility::missionFailedWrapper();
}


/*
=============
///ScriptDocBegin
"Name: so_delete_all_by_type( <function pointer 1>, <function pointer 2>, ... , <function pointer 5> )"
"Summary: Run this in first frame. Deletes level entities that do not have the key 'script_specialops 1', that are defined by function pointer passed in. This function can delete 5 types of entities at once."
"Module: Utility"
"MandatoryArg: <function pointer 1> These functions passed in must return a boolean. Example type_vehicle() will return isSubStr( self.code_classname, "script_vehicle" );"
"Example: so_delete_all_by_type( ::type_spawn_trigger, ::type_vehicle, ::type_spawners );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
// type definition function is called on the entity, it must return boolean without sleep
so_delete_all_by_type( type1_def_func, type2_def_func, type3_def_func, type4_def_func, type5_def_func )
{
	all_ents = getentarray();
	foreach( ent in all_ents )
	{
		if ( !isdefined( ent.code_classname ) )
			continue;

		isSpecialOpEnt = ( isdefined( ent.script_specialops ) && ent.script_specialops == 1 );
		if( isSpecialOpEnt )
			continue;
			
		if (  ent [[ type1_def_func ]]() )
			ent delete();
			
		if ( isdefined( type2_def_func ) &&  ent [[ type2_def_func ]]() )
			ent delete();
			
		if ( isdefined( type3_def_func ) &&  ent [[ type3_def_func ]]() )
			ent delete();
			
		if ( isdefined( type4_def_func ) &&  ent [[ type4_def_func ]]() )
			ent delete();
		
		if ( isdefined( type5_def_func ) &&  ent [[ type5_def_func ]]() )
			ent delete();
	}	
}

//============= some entity type function definitions ================
// ENTITY TYPE DEFINITION FUNCTIONS RETURN BOOLEAN TEST ON SELF
type_spawners()
{
	if ( !isdefined( self.code_classname ) )
		return false;
		
	return isSubStr( self.code_classname, "actor_" );	
}

type_vehicle()
{
	if ( !isdefined( self.code_classname ) )
		return false;
		
	return isSubStr( self.code_classname, "script_vehicle" );
}

type_spawn_trigger()
{
	if ( !isdefined( self.classname ) )
		return false;

	if ( self.classname == "trigger_multiple_spawn" ) 
		return true;

	if ( self.classname == "trigger_multiple_spawn_reinforcement" )
		return true;

	if ( self.classname == "trigger_multiple_friendly_respawn" )
		return true;

	if ( isdefined( self.targetname ) && self.targetname == "flood_spawner" )
		return true;

	if ( isdefined( self.targetname ) && self.targetname == "friendly_respawn_trigger" )
		return true;

	if ( isdefined( self.spawnflags ) && self.spawnflags & 32 )
		return true;

	return false;
}

type_trigger()
{
	if ( !isdefined( self.code_classname ) )
		return false;
		
	array = [];
	array[ "trigger_multiple" ]	= 1;
	array[ "trigger_once" ]		= 1;
	array[ "trigger_use" ]		= 1;
	array[ "trigger_radius" ]	= 1;
	array[ "trigger_lookat" ]	= 1;
	array[ "trigger_disk" ]		= 1;
	array[ "trigger_damage" ]	= 1;
	
	return isdefined( array[ self.code_classname ] );
}

type_flag_trigger()
{
	if ( !IsDefined( self.classname ) )
	{
		return false;
	}
		
	array = [];
	array[ "trigger_multiple_flag_set" ]			= 1;
	array[ "trigger_multiple_flag_set_touching" ]	= 1;
	array[ "trigger_multiple_flag_clear" ]			= 1;
	array[ "trigger_multiple_flag_looking" ]		= 1;
	array[ "trigger_multiple_flag_lookat" ]			= 1;
	
	return IsDefined( array[ self.classname ] );
}

type_killspawner_trigger()
{
	if( !self type_trigger() )
	{
		return false;
	}
	
	if( IsDefined( self.script_killspawner ) )
	{
		return true;
	}
	
	return false;
}

type_goalvolume()
{
	if( !IsDefined( self.classname ) )
	{
		return false;
	}
	
	if( self.classname == "info_volume" && IsDefined( self.script_goalvolume ) )
	{
		return true;
	}
	
	return false;
}

/*
=============
///ScriptDocBegin
"Name: so_delete_all_spawntriggers()"
"Summary: Deletes all spawn triggers without the key 'script_specialops 1'."
"Example: so_delete_all_spawntriggers();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_delete_all_spawntriggers()
{
	so_delete_all_by_type( ::type_spawn_trigger );
}

/*
=============
///ScriptDocBegin
"Name: so_delete_all_triggers()"
"Summary: Deletes all triggers without the key 'script_specialops 1'."
"Example: so_delete_all_triggers();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_delete_all_triggers()
{
	so_delete_all_by_type( ::type_trigger );
}

/*
=============
///ScriptDocBegin
"Name: so_delete_all_vehicles()"
"Summary: Deletes all script vehicles without the key 'script_specialops 1'."
"Example: so_delete_all_vehicles();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_delete_all_vehicles()
{
	so_delete_all_by_type( ::type_vehicle );
}

/*
=============
///ScriptDocBegin
"Name: so_delete_all_spawners()"
"Summary: Deletes all spawners without the key 'script_specialops 1'."
"Example: so_delete_all_spawners();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_delete_all_spawners()
{
	so_delete_all_by_type( ::type_spawners );
}

so_delete_breach_ents()
{
	breach_solids = getentarray( "breach_solid", "targetname" );
	foreach( ent in breach_solids )
	{
		ent connectPaths();
		ent delete();
	}
}

/*
=============
///ScriptDocBegin
"Name: so_force_deadquote( <quote> )"
"Summary: Utility function to easily force the game to use a specific Special Ops deadquote."
"Module: Utility"
"MandatoryArg: <quote>: Message you want displayed on the Mission Failed summary."
"Example: so_force_deadquote( &"SPECIAL_OPS_YOU_SUCK" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_force_deadquote( quote )
{
	assertex( isdefined( quote ), "so_force_deadquote() requires a valid quote to be passed in." );

	level.so_deadquotes = [];
	level.so_deadquotes[ 0 ] = quote;
	level.so_deadquotes_chance = 1.0;
}

/*
=============
///ScriptDocBegin
"Name: so_force_deadquote_array( <quotes> )"
"Summary: Utility function to easily force the game to use a specific list of Special Ops deadquotes."
"Module: Utility"
"MandatoryArg: <quotes>: Messages you want displayed on the Mission Failed summary."
"Example: so_include_deadquote_array( special_quotes );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_force_deadquote_array( quotes )
{
	assertex( isdefined( quotes ), "so_force_deadquote_array() requires a valid quote array to be passed in." );

	level.so_deadquotes = quotes;
	level.so_deadquotes_chance = 1.0;
}

/*
=============
///ScriptDocBegin
"Name: so_include_deadquote_array( <quotes> )"
"Summary: Utility function to easily add new custom deadquotes to Special Ops deadquotes Merges with any existing ones."
"Module: Utility"
"MandatoryArg: <quotes>: Messages you want added to the list being displayed on the Mission Failed summary."
"Example: so_include_deadquote_array( special_quotes );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_include_deadquote_array( quotes )
{
	assertex( isdefined( quotes ), "so_include_deadquote_array() requires a valid quote array to be passed in." );

	if ( !isdefined( level.so_deadquotes ) )
		level.so_deadquotes = [];
	level.so_deadquotes = array_merge( level.so_deadquotes , quotes );
}

/*
=============
///ScriptDocBegin
"Name: so_create_hud_item( <yLine>, <xOffset> , <message>, <player> )"
"Summary: Useful for creating the hud items that line up on the right side of the screen for typical Special Ops information."
"Module: Hud"
"OptionalArg: <yLine>: Line # to draw the element on. Start with 0 meaning top of the screen in split screen within the safe area."
"OptionalArg: <xOffset>: Offset for the X position."
"OptionalArg: <message>: Optional message to apply to the hudelem.label."
"OptionalArg: <player>: If a player is passed in, it will create a ClientHudElem for that player specifically."
"Example: so_create_hud_item( 1, 0, &"SPECIAL_OPS_TIME_NULL", level.player2 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_create_hud_item( yLine, xOffset, message, player )
{
	if ( isdefined( player ) )
		assertex( isplayer( player ), "so_create_hud_item() received a value for player that did not pass the isplayer() check." );
		
	if ( !isdefined( yLine ) )
		yLine = 0;
	if ( !isdefined( xOffset ) )
		xOffset = 0;

	// This is to globally shift all the SOs down by two lines to help with overlap with the objective and help text.
	yLine += 2;

	hudelem = undefined;		
	if ( isdefined( player ) )
		hudelem = newClientHudElem( player );
	else
		hudelem = newHudElem();
	hudelem.alignX = "right";
	hudelem.alignY = "middle";
	hudelem.horzAlign = "right";
	hudelem.vertAlign = "middle";
	hudelem.x = xOffset;
	hudelem.y = -100 + ( 15 * yLine );
	hudelem.font = "hudsmall";
	hudelem.foreground = 1;
	hudelem.hidewheninmenu = true;
	hudelem.hidewhendead = true;
	hudelem.sort = 2;
	hudelem set_hud_white();

	if ( isdefined( message ) )
		hudelem.label = message;

	if ( isdefined( player ) )
	{
		if ( !player so_hud_can_show() )
			player thread so_create_hud_item_delay_draw( hudelem );
	}
				
	return hudelem;
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_create( <new_value> )"
"Summary: Pulses the hud item and updates the label to the new value."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <new_value>: When set to a value, will be set on the .label parameter of the hud element."
"Example: hudelem thread so_hud_pulse_create( 0 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_hud_pulse_create( new_value )
{
	if ( !so_hud_pulse_init() )
		return;
	
	self notify( "update_hud_pulse" );
	self endon( "update_hud_pulse" );
	self endon( "destroying" );

	if ( isdefined( self.pulse_sound ) )
		level.player PlaySound( self.pulse_sound );
		
	if ( isdefined( new_value ) )
		self.label = new_value;

	if ( isdefined( self.pulse_loop ) && self.pulse_loop )
		so_hud_pulse_loop();
	else
		so_hud_pulse_single( self.pulse_scale_big, self.pulse_scale_normal, self.pulse_time );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_loop_default( <color> )"
"Summary: Sets the default standard values for a pulsing hud item, and optionally can start the pulse immediately."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <color>: Gives the ability to override the color the element will be when pulsing."
"OptionalArg: <start_immediately>: If true, then the pulse will start right away, rather than waiting for some other part of script to initiate the pulse."
"OptionalArg: <new_value>: When start_immediately, will pass this through to be applied to the hud element's label."
"Example: hudelem thread so_hud_pulse_loop_default( "red" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_hud_pulse_loop_default( color, start_immediately, new_value )
{
	if ( !so_hud_pulse_init() )
		return;

	self notify( "update_hud_pulse" );
	self endon( "update_hud_pulse" );
	self endon( "destroying" );
	
	self.pulse_loop = true;
	if ( isdefined( color ) )
	{	
		switch( color )
		{
			case "yellow":	set_hud_yellow(); break;
			case "green":	set_hud_green(); break;
			case "blue":	set_hud_blue(); break;
			case "red":		set_hud_red(); break;
			default:		set_hud_red(); break;
		}
	}
		
	if ( isdefined( start_immediately ) && start_immediately )
		so_hud_pulse_create( new_value );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_pulse_stop( <so_stop_hud_pulse> )"
"Summary: Call to take whatever current status a hud element pulse is in, and return it to normal."
"Module: Hud"
"CallOn: A hud element"
"Example: hudelem thread so_hud_pulse_stop();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_hud_pulse_stop()
{
	self notify( "update_hud_pulse" );
	self endon( "update_hud_pulse" );
	self endon( "destroying" );
	
	if ( !so_hud_pulse_init() )
		return;
	
	self.pulse_loop = false;
	so_hud_pulse_single( self.fontscale, self.pulse_scale_normal, self.pulse_time );
}

/*
=============
///ScriptDocBegin
"Name: so_hud_ypos( <so_hud_ypos> )"
"Summary: Returns the default value for SO HUD element Y positions. This is generally the split between the Text and the Value. When used allows simple adjustment of the hud to move it around in all SOs rather than hand updating each hud element."
"Module: Hud"
"CallOn: A hud element"
"Example: so_create_hud_item( 1, so_hud_ypos(), &"SPECIAL_OPS_TIME_NULL", level.player2 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_hud_ypos()
{
	return -62;
}

/*
=============
///ScriptDocBegin
"Name: so_remove_hud_item( <destroy_immediately> )"
"Summary: Default behavior for removing an SO HUD item. Pulses out by default, but can be told to be removed immediately."
"Module: Hud"
"CallOn: A hud element"
"OptionalArg: <destroy_immediately>: When set to true, will just remove the item immediately."
"Example: hudelem so_remove_hud_item();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
so_remove_hud_item( destroy_immediately )
{
	if ( isdefined( destroy_immediately ) && destroy_immediately )
	{
		self Destroy();
		return;
	}

	self thread so_hud_pulse_stop();
	self SetPulseFX( 0, 1500, 500 );

	wait( 2 );
	
	self notify( "destroying" );
	self Destroy();
}

/*
=============
///ScriptDocBegin
"Name: set_hud_white( <new_alpha> )"
"Summary: Sets properties on a hud element to be a standard white color."
"Module: Hud"
"OptionalArg: <new_alpha>: Alpha to optionally set the hud element to."
"CallOn: A hud element"
"Example: hudelem set_hud_white();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
set_hud_white( new_alpha )
{
	if ( isdefined( new_alpha ) )
	{
		self.alpha = new_alpha;
		self.glowAlpha = new_alpha;
	}

	self.color = ( 1, 1, 1 );
	self.glowcolor = ( 0.6, 0.6, 0.6 );
}

/*
=============
///ScriptDocBegin
"Name: set_hud_blue( <new_alpha> )"
"Summary: Sets properties on a hud element to be a standard blue color."
"Module: Hud"
"OptionalArg: <new_alpha>: Alpha to optionally set the hud element to."
"CallOn: A hud element"
"Example: hudelem set_hud_blue();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
set_hud_blue( new_alpha )
{
	if ( isdefined( new_alpha ) )
	{
		self.alpha = new_alpha;
		self.glowAlpha = new_alpha;
	}

	self.color = ( 0.8, 0.8, 1 );
	self.glowcolor = ( 0.301961, 0.301961, 0.6 );
}

/*
=============
///ScriptDocBegin
"Name: set_hud_green( <new_alpha> )"
"Summary: Sets properties on a hud element to be a standard green color."
"Module: Hud"
"OptionalArg: <new_alpha>: Alpha to optionally set the hud element to."
"CallOn: A hud element"
"Example: hudelem set_hud_green();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
set_hud_green( new_alpha )
{
	if ( isdefined( new_alpha ) )
	{
		self.alpha = new_alpha;
		self.glowAlpha = new_alpha;
	}

	self.color = ( 0.8, 1, 0.8 );
	self.glowcolor = ( 0.301961, 0.6, 0.301961 );
}

/*
=============
///ScriptDocBegin
"Name: set_hud_yellow( <new_alpha> )"
"Summary: Sets properties on a hud element to be a standard yellow color."
"Module: Hud"
"OptionalArg: <new_alpha>: Alpha to optionally set the hud element to."
"CallOn: A hud element"
"Example: hudelem set_hud_yellow();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
set_hud_yellow( new_alpha )
{
	if ( isdefined( new_alpha ) )
	{
		self.alpha = new_alpha;
		self.glowAlpha = new_alpha;
	}

	self.color = ( 1, 1, 0.5 );
	self.glowcolor = ( 0.7, 0.7, 0.2 );
}

/*
=============
///ScriptDocBegin
"Name: set_hud_red( <new_alpha> )"
"Summary: Sets properties on a hud element to be a standard red color."
"Module: Hud"
"OptionalArg: <new_alpha>: Alpha to optionally set the hud element to."
"CallOn: A hud element"
"Example: hudelem set_hud_red();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
set_hud_red( new_alpha )
{
	if ( isdefined( new_alpha ) )
	{
		self.alpha = new_alpha;
		self.glowAlpha = new_alpha;
	}
	
	self.color = ( 1, 0.4, 0.4 );
	self.glowcolor = ( 0.7, 0.2, 0.2 );
}

/*
=============
///ScriptDocBegin
"Name: info_hud_wait_for_player( <info_hud_wait_for_player> )"
"Summary: When run on a player, waits for them to press the appropriate key and sends a notify that will allow certain hud elements to become visible for a while before fading them back out."
"Module: Hud"
"CallOn: A player"
"OptionalArg: <endon_notify>: If a value is passed in, will create a level endon( endon_notify ) to terminate the function."
"Example: level.player info_hud_wait_for_player( "special_op_complete" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
info_hud_wait_for_player( endon_notify )
{
	assertex( isplayer( self ), "info_hud_wait_for_player() must be called on a player." );

	// Prevent thread from being initiated multiple times.
	if ( isdefined( self.so_infohud_toggle_state ) )
		return;
			
	level endon( "challenge_timer_expired" );
	level endon( "challenge_timer_passed" );
	level endon( "special_op_terminated" );
	self endon( "death" );
	if ( isdefined( endon_notify ) )
		level endon( endon_notify );

	self setWeaponHudIconOverride( "actionslot1", "hud_show_timer" );
	notifyoncommand( "toggle_challenge_timer", "+actionslot 1" );
	self.so_infohud_toggle_state = info_hud_start_state();

	if ( !so_hud_can_show() )
	{
		thread info_hud_wait_force_on();
		self ent_flag_wait( "so_hud_can_toggle" );
	}

	self notify( "so_hud_toggle_available" );
	while ( 1 )
	{
		self waittill( "toggle_challenge_timer" );
		switch( self.so_infohud_toggle_state )
		{
			case "on":
				self.so_infohud_toggle_state = "off";
				setdvar( "so_ophud_" + self.unique_id, "0" );
				break;
			case "off":
				self.so_infohud_toggle_state = "on";
				setdvar( "so_ophud_" + self.unique_id, "1" );
				break;
		}
		self notify( "update_challenge_timer" );
	}
}

info_hud_wait_force_on()
{
	self endon( "so_hud_toggle_available" );
	
	notifyoncommand( "force_challenge_timer", "+actionslot 1" );
	self waittill( "force_challenge_timer" );
	self.so_hud_show_time = gettime();
	self.so_infohud_toggle_state = "on";
	setdvar( "so_ophud_" + self.unique_id, "1" );
}

info_hud_start_state()
{
	if ( getdvarint( "so_ophud_" + self.unique_id ) == 1 )
	{
		self.so_hud_show_time = gettime() + 1000;
		return "on";
	}

	if ( isdefined( level.challenge_time_limit ) )
		return "on";

	if ( isdefined( level.challenge_time_force_on ) && level.challenge_time_force_on )
		return "on";
		
	return "off";
}

/*
=============
///ScriptDocBegin
"Name: info_hud_handle_fade( <hudelem>, <endon_notify> )"
"Summary: When called on a player and a hudelement is passed in, it will wait for the notifies from info_hud_wait_for_player() and fade the item in or out as needed."
"Module: Hud"
"CallOn: A player"
"MandatoryArg: <hudelem>: Hud element to fade in and out."
"OptionalArg: <endon_notify>: If a value is passed in, will create a level endon( endon_notify ) to terminate the function."
"Example: level.player info_hud_handle_fad( timer_hud, "special_op_complete" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
info_hud_handle_fade( hudelem, endon_notify )
{
	assertex( isplayer( self ), "info_hud_handle_fade() must be called on a player." );
	assertex( isdefined( hudelem ), "info_hud_handle_fade() requires a valid hudelem to be passed in." );
	
	level endon( "new_challenge_timer" );
	level endon( "challenge_timer_expired" );
	level endon( "challenge_timer_passed" );
	level endon( "special_op_terminated" );
	self endon( "death" );
	if ( isdefined( endon_notify ) )
		level endon( endon_notify );
	
	hudelem.so_can_toggle = true;

	self ent_flag_wait( "so_hud_can_toggle" );
	info_hud_update_alpha( hudelem );

	while( 1 )
	{
		self waittill( "update_challenge_timer" );
		hudelem FadeOverTime( 0.25 );
		info_hud_update_alpha( hudelem );
	}
}

info_hud_update_alpha( hudelem )
{
	switch( self.so_infohud_toggle_state )
	{
		case "on":	hudelem.alpha = 1;	break;
		case "off":	hudelem.alpha = 0;	break;
	}
}

/*
=============
///ScriptDocBegin
"Name: info_hud_decrement_timer( <time> )"
"Summary: Modifies the global challenge timer to subract the specified time from the current time."
"Module: Hud"
"MandatoryArg: <time>: The amount to subtract from the global time."
"Example: info_hud_decrement_timer( level.so_missed_target_deduction )"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
info_hud_decrement_timer( time )
{
	if ( !IsDefined( level.challenge_time_limit  ) )
	{
		return;
	}

	if ( flag( "challenge_timer_expired" ) || flag( "challenge_timer_passed" ) )
	{
		return;
	}

	level.so_challenge_time_left -= time;

	if ( level.so_challenge_time_left < 0 )
	{
		level.so_challenge_time_left = 0.01;
	}

	red = ( 0.6, 0.2, 0.2 );
	red_glow = ( 0.4, 0.1, 0.1 );
	foreach ( player in level.players )
	{
		player.hud_so_timer_time SetTenthsTimer( level.so_challenge_time_left );

// We need to support the hurry/nudge if we really want to change the color
// Probably store an extra variable on the hud time and msg to keep track.
//		old_color 		= player.hud_so_timer_time.color;
//		old_glow  		= player.hud_so_timer_time.glowcolor;
//		old_title_color = player.hud_so_timer_msg.color;
//		old_title_glow 	= player.hud_so_timer_msg.glowcolor;
//
//		player.hud_so_timer_time.color 		= red;
//		player.hud_so_timer_time.glowcolor 	= red_glow;
//		player.hud_so_timer_msg.color 		= red;
//		player.hud_so_timer_msg.glowcolor 	= red_glow;
//		
//		player.hud_so_timer_time FadeOverTime( 0.5 );
//		player.hud_so_timer_msg FadeOverTime( 0.5 );
//		
//		player.hud_so_timer_time.color 	= old_color;
//		player.hud_so_timer_time.glowcolor 	= old_glow;
//		player.hud_so_timer_msg.color 		= old_title_color;
//		player.hud_so_timer_msg.glowcolor 	= old_title_glow;
	}

	// Restart the challenge_timer_thread
	thread challenge_timer_thread();
}

/*
=============
///ScriptDocBegin
"Name: is_dvar_character_switcher( <dvar> )"
"Summary: Tests the specified dvar to see whether the player positions have switched (for vehicle SOs)."
"Module: Utility"
"MandatoryArg: <dvar>: The dvar to test."
"Example: is_dvar_character_switcher( "specops_character_switched" )"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
is_dvar_character_switcher( dvar )
{
	val = getdvar( dvar );
	return val == "so_char_client" || val == "so_char_host";
}

// ---------------------------------------------------------------------------------
//	Special Ops common dialog.
// ---------------------------------------------------------------------------------

so_dialog_ready_up()
{
	so_dialog_play( "so_tf_1_plyr_prep" );
}

so_dialog_mission_success()
{
	wait 0.5;
	
	// Check for best time.
	assertex( isdefined( level.challenge_end_time ), "so_dialog_mission_successf() was called before level.challenge_end_time is called." );
	m_seconds = int( min( ( level.challenge_end_time - level.challenge_start_time ), 86400000 ) );
	best_time_name = tablelookup( "sp/specOpsTable.csv", 1, level.script, 9 );
	best_time = false;
	if ( best_time_name != "" )
	{
		foreach( player in level.players )
		{
			current_best_time = player GetLocalPlayerProfileData( best_time_name );
	
			if ( !isdefined( current_best_time ) )
				continue;	// non local player
				
			never_played = current_best_time == 0;
			best_time = m_seconds < current_best_time;
			if ( !never_played && best_time )
				so_dialog_play( "so_tf_1_success_best" );
		}
	}
	
	// Normal time.
	if ( !best_time )
	{
		// Hardened and lower only get supportive success messages. Veteran has 50/50 chance to get a sarcastic.
		sarcasm_chance = 0.0;
		if ( level.gameSkill >= 3 )
			sarcasm_chance = 0.5;
		if ( randomfloat( 1.0 ) < sarcasm_chance )
			so_dialog_play( "so_tf_1_success_jerk" );
		else
			so_dialog_play( "so_tf_1_success_generic" );
	}
}

so_dialog_mission_failed_generic()
{
	level.failed_dialog_played = true;
	so_dialog_play( "so_tf_1_fail_generic", 0.5 );
}

so_dialog_mission_failed_time()
{
	level.failed_dialog_played = true;
	so_dialog_play( "so_tf_1_fail_time", 0.5 );
}

so_dialog_mission_failed_bleedout()
{
	level.failed_dialog_played = true;
	so_dialog_play( "so_tf_1_fail_bleedout", 0.5 );
}

so_dialog_time_low_normal()
{
	so_dialog_play( "so_tf_1_time_generic" );
}

so_dialog_time_low_hurry()
{
	so_dialog_play( "so_tf_1_time_hurry" );
}

so_dialog_killing_civilians()
{
	if ( !isdefined( level.civilian_warning_time ) )
	{
		level.civilian_warning_time = gettime();
		if ( !isdefined( level.civilian_warning_throttle ) )
			level.civilian_warning_throttle = 5000;
	}
	else
	{
		if ( ( gettime() - level.civilian_warning_time ) < level.civilian_warning_throttle )
			return;
	}
	
	wait_time = 0.5;
	level.civilian_warning_time = gettime() + ( wait_time * 1000 );
	so_dialog_play( "so_tf_1_civ_kill_warning", 0.5 );
}

// ---------------------------------------------------------------------------------
