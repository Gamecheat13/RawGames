#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_hud_util;

main()
{
	level.so_compass_zoom = "close";

	precache_strings();
	
	//level.eog_summary_callback = ::custom_eog_summary;
	maps\trainer::main();

	// setup custom eog summary
	flag_init( "so_killspree_trainer_initialized" );
	flag_init( "challenge_done" );
	
	flag_set( "so_killspree_trainer_initialized" );
}

precache_strings()
{
	// Dead Quotes
	PrecacheString( "@SO_KILLSPREE_TRAINER_DEADQUOTE_FU_AND_MISSED" );
	PrecacheString( "@SO_KILLSPREE_TRAINER_DEADQUOTE_FRIENDLIES1" );
	PrecacheString( "@SO_KILLSPREE_TRAINER_DEADQUOTE_FRIENDLIES2" );
	PrecacheString( "@SO_KILLSPREE_TRAINER_DEADQUOTE_MISSED1" );
	PrecacheString( "@SO_KILLSPREE_TRAINER_DEADQUOTE_MISSED2" );
}


custom_eog_summary()
{
	
	seconds = 0;
	m_seconds = ( level.challenge_end_time - level.challenge_start_time );

	if ( IsDefined( level.challenge_end_time ) && IsDefined( level.challenge_start_time ) )
		seconds = int( m_seconds / 1000 );
		
	minutes = 0;
	while ( seconds >= 60 )
	{
		minutes++ ;
		seconds -= 60;
	}
	if ( seconds < 10 )
		seconds = "0" + seconds;
	
	foreach( player in level.players )
	{
		test_var = "Player 1";
		if ( IsDefined( level.player2 ) && player == level.player2 )
			test_var = "Player 2";
		
		player set_custom_eog_summary( 1, 1, "@SPECIAL_OPS_UI_TIME" );		
		player set_custom_eog_summary( 1, 2, minutes + ":" + seconds );
		                                                        	
		player set_custom_eog_summary( 2, 1, "Test:" );
		player set_custom_eog_summary( 2, 2, test_var );
		
		player set_custom_eog_summary( 3, 1, "Test:" );					
		player set_custom_eog_summary( 3, 2, test_var );
		
		player set_custom_eog_summary( 4, 1, "Test:" );					
		player set_custom_eog_summary( 4, 2, test_var );
		
		player set_custom_eog_summary( 5, 1, "Test:" );					
		player set_custom_eog_summary( 5, 2, test_var );
		
		player set_custom_eog_summary( 6, 1, "Test:" );					
		player set_custom_eog_summary( 6, 2, test_var );
	}
}

start_map()
{
	flag_wait( "so_killspree_trainer_initialized" );

	/*-----------------------
	INITIALIZATION
	-------------------------*/	
	thread fade_challenge_in();
	level.challenge_civililans_killed = 0;
	level.missed_enemies_penalty = 0;
	level.killed_civvies_penalty = 0;

	assert( IsDefined( level.gameskill ) );
	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1: gameskill_Regular();	break;	// Regular
		case 2:	gameskill_hardened();	break;	// Hardened
		case 3:	gameskill_veteran();	break;	// Veteran
	}

	if ( IsDefined( level.challenge_time_limit ) )
	{
		level.challenge_time_nudge = int( level.challenge_time_limit / 3 );
		level.challenge_time_hurry = int( level.challenge_time_limit / 6 );
	}
	
	// replaced pawlows with blackhawks to get rid of helicopter in the minimap.
	so_ambient_vehicles();
	array_thread( getstructarray( "delete_heli_node", "script_noteworthy" ), ::delete_heli_node );
	array_call( GetEntArray( "ai_ambient", "script_noteworthy" ), ::Delete );
	array_call( GetEntArray( "translator", "script_noteworthy" ), ::Delete );
	array_call( GetEntArray( "trainee_01", "script_noteworthy" ), ::Delete );
	array_call( GetAiArray( "allies" ), ::Delete );

//	level.pitguy delete();

	// reveal pit weapons
	level thread so_pit_start_sequence();
	
	music_loop( "airlift_deploy_music", 100 );

	/*-----------------------
	COURSE LOOP
	-------------------------*/	
	thread so_course_loop_think();

	flag_wait( "challenge_done" );

	level.challenge_end_time = gettime();
	fade_challenge_out();
}

//so_pit_sequence_timeout()
//{
//	level.challenge_end_time = gettime();
//	thread so_dialog_mission_failed_generic();
//
//	if ( is_coop() )
//	{
//		if ( level.gameskill == 3 )
//			SetDvar( "ui_deadquote", "@SO_KILLSPREE_TRAINER_DEADQUOTE_VETERAN" );
//		else
//			SetDvar( "ui_deadquote", "@SO_KILLSPREE_TRAINER_DEADQUOTE_HARDENED" );
//	}
//	else
//	{
//		if ( level.gameskill == 3 )
//			SetDvar( "ui_deadquote", "@SO_KILLSPREE_TRAINER_DEADQUOTE_VETERAN_SP" );
//		else
//			SetDvar( "ui_deadquote", "@SO_KILLSPREE_TRAINER_DEADQUOTE_HARDENED_SP" );
//	}
//
//	maps\_utility::missionFailedWrapper();
//}

so_pit_start_sequence()
{
	level thread pit_cases_and_door();

	level.pitguy.animnode anim_first_frame( level.pitcases, "training_pit_open_case" );

	foreach( pitcase in level.pitcases )
	{
		animation = pitcase getanim( "training_pit_open_case" );
		pitcase SetAnimknob( animation, 1, 0 );
		pitcase SetAnimTime( animation, 1 );
	}
}

pit_cases_and_door()
{
	/*-----------------------
	PIT GUY OPENS CASE AND SHOWS MORE WEAPONRY
	-------------------------*/	
	level.pit_case_01 playsound( "scn_trainer_case_open1" );	
	pit_weapons_case_01 = getentarray( "pit_weapons_case_01", "script_noteworthy" );
	array_thread( pit_weapons_case_01, maps\trainer::weapons_show );
	
	level.pit_case_02 playsound( "scn_trainer_case_open2" );
	pit_weapons_case_02 = getentarray( "pit_weapons_case_02", "script_noteworthy" );
	array_thread( pit_weapons_case_02, maps\trainer::weapons_show );
	
	level.gate_cqb_enter thread maps\trainer::door_open();
}

so_ambient_vehicles()
{
	path_arr = getstructarray( "blackhawk_path", "script_noteworthy" );
	heli_arr = getentarray( "heli_group_01", "targetname" );
	
	blackhawk = undefined;
	foreach( heli in heli_arr )
	{
		if ( heli.classname == "script_vehicle_blackhawk_low" )
		{
			blackhawk = heli;
			break;
		}
	}

	foreach( path in path_arr )
	{
		// move, spawn and go one heli per path
		blackhawk move_spawn_and_go( path );
		wait 0.15; // to awoid spawning from the same spawner on the same frame.
	}
}

so_course_loop_think()
{
	level endon( "clear_course" );
	level endon( "mission failed" );
	level endon( "special_op_terminated" );
	setdvar( "killhouse_too_slow", "0" );
	level.first_time = true;
	maps\trainer::clear_hints();

	/*-----------------------
	COURSE LOOPS
	-------------------------*/	
	
	/*-----------------------
	COURSE OBJECTIVE
	-------------------------*/	
	if( level.first_time )
	{
		maps\trainer::registerObjective( "obj_course", &"TRAINER_OBJ_COURSE", getEnt( "origin_course_01", "targetname" ) );
		maps\trainer::setObjectiveState( "obj_course", "current" );
	}
	
	/*-----------------------
	RESET CQB COURSE AND OPEN DOOR
	-------------------------*/
	course_triggers_01 = getentarray( "course_triggers_01", "script_noteworthy" );
	array_notify( course_triggers_01, "activate" );

	/*-----------------------
	COURSE START
	-------------------------*/
	enable_challenge_timer( "player_has_started_course" , "so_player_course_end" );
	array_thread( level.players, ::display_counters );
	flag_wait( "player_has_started_course" );

	flag_clear( "melee_target_hit" );
	level.targets_hit_with_melee = 0;

	thread maps\trainer::target_flag_management();
	if( level.first_time )
	{
		thread maps\trainer::dialogue_course_civilian_killed();	
		delaythread ( 3, maps\trainer::dialogue_ambient_pit_course );
	}
	level.recommendedDifficulty = undefined;
	
	thread maps\trainer::dialogue_course();

	conversation_orgs_pit = getentarray( "conversation_orgs_pit", "targetname" );
	org = getclosest( level.player.origin, conversation_orgs_pit );
	
	if ( cointoss() )
	{
		//Ranger 3   Come on. Get some, Allen!	
		org delaythread( 3,::play_sound_in_space, "train_ar3_getsome" );
	}
	else if ( cointoss() )
	{
		//Ranger 4   Bring it, bitch!	
		org delaythread( 3,::play_sound_in_space, "train_ar4_bringit" );
	}
	else
	{
		//Ranger 5   Come on! Get some!	
		org delaythread( 3,::play_sound_in_space, "train_ar5_comeon" );
	}
	
	/*-----------------------
	TOP OFF PLAYER WEAPONS
	-------------------------*/
	foreach( player in level.players )
	{
		playerPrimaryWeapons = player GetWeaponsListPrimaries();
		if ( playerPrimaryWeapons.size > 0 )
		{
			foreach ( weapon in playerPrimaryWeapons )
				player givemaxammo( weapon );
		}
	}

	level.targets_hit = 0;
	level.friendlies_hit = 0;
	level.missed_targets = 0;

	thread maps\trainer::accuracy_bonus();

	maps\trainer::setObjectiveLocation( "obj_course", getEnt( "origin_course_02", "targetname" ) );

	flag_wait( "player_course_03a" );
	maps\trainer::setObjectiveLocation( "obj_course", getEnt( "origin_course_03", "targetname" ) );
	
	/*-----------------------
	MELEE TARGET
	-------------------------*/	
	flag_wait( "player_course_stairs2" );

//	thread maps\trainer::key_hint_till_flag_set( "melee", "melee_target_hit" );
	so_melee_hint();
	
	flag_wait( "player_course_upstairs" );

	thread course_gate_controll();
	maps\trainer::setObjectiveLocation( "obj_course", getEnt( "origin_course_03a", "targetname" ) );
	
	flag_wait( "player_course_jumping_down" );
	maps\trainer::setObjectiveLocation( "obj_course", getEnt( "origin_course_05", "targetname" ) );

	level.gate_cqb_enter thread maps\trainer::door_open();

	/*-----------------------
	COURSE END
	-------------------------*/	
	flag_wait( "so_player_course_end" );
	maps\trainer::clear_hints();

	thread maps\trainer::reset_course_targets();
	level.gate_cqb_exit thread maps\trainer::door_close();

	maps\trainer::clear_hints();

	level notify ( "test_cleared" );

	maps\trainer::setObjectiveState( "obj_course", "done" );
		
	maps\trainer::clear_timer_elems();

	flag_set( "challenge_done" );
}

so_melee_hint()
{
	foreach ( player in level.players )
	{
		player thread so_melee_hint_thread();
	}
}

add_client_hint_background( double_line )
{
	if ( IsDefined( double_line ) )
	{
		self.hintbackground = self createClientIcon( "popmenu_bg", 650, 50 );
	}
	else
	{
		self.hintbackground = self createClientIcon( "popmenu_bg", 650, 30 );
	}

	self.hintbackground.hidewheninmenu = true;
	self.hintbackground setPoint( "TOP", undefined, 0, 105 );
	self.hintbackground.alpha = 1;
	self.hintbackground.sort = 0;
}

so_melee_hint_thread()
{
	maps\trainer::clear_hints();
	self add_client_hint_background();
	self.hintbackground.alpha = 0;

	self.hintElem = self createClientFontString( "objective", level.hint_text_size );
	self.hintElem.hidewheninmenu = true;
	self.hintElem setPoint( "TOP", undefined, 0, 110 );
	self.hintElem.sort = 0.5;
	self.hintElem.alpha = 0;
	self.hintElem setText( &"TRAINER_HINT_MELEE_CLICK" );

	trigger = GetEnt( "so_player_melee_trigger", "targetname" );
	while ( !flag( "melee_target_hit" ) )
	{
		if ( self IsTouching( trigger ) )
		{
			self.hintElem.alpha = 1;
			self.hintbackground.alpha = 0.5;
		}
		else
		{
			self.hintElem FadeOverTime( 0.5 );
			self.hintElem.alpha = 0;

			self.hintbackground FadeOverTime( 0.5 );
			self.hintbackground.alpha = 0;
		}

		wait( 0.25 );
	}

	self.hintElem FadeOverTime( 0.5 );
	self.hintElem.alpha = 0;
	wait ( 0.5 );

	self clear_client_hints();
}

clear_client_hints()
{
	if ( IsDefined( self.hintElem ) )
	{
		self.hintElem destroyElem();
	}

	if ( IsDefined( self.iconElem ) )
	{
		self.iconElem destroyElem();
	}

	if ( IsDefined( self.iconElem2 ) )
	{
		self.iconElem2 destroyElem();
	}

	if ( IsDefined( self.iconElem3 ) )
	{
		self.iconElem3 destroyElem();
	}

	if ( IsDefined( self.hintbackground ) )
	{
		self.hintbackground destroyElem();
	}

	self notify( "clearing_hints" );
}

course_gate_controll()
{
	// open gate after both players passed the middle of the course.
	flag_wait( "so_player_course_jumped_down" );
	level.gate_cqb_enter thread maps\trainer::door_close();
	level.gate_cqb_exit thread maps\trainer::door_open();
}

display_counters()
{
	ypos = so_hud_ypos();
	
	self.HUDenemies = so_create_hud_item( 3, ypos, &"SO_KILLSPREE_TRAINER_ENEMIES", self );	
	self.HUDcivvies = so_create_hud_item( 4, ypos, &"SO_KILLSPREE_TRAINER_CIVVIES", self );	

	self.HUDenemiesKilled = so_create_hud_item( 3, ypos, "&&1/24", self );	
	self.HUDenemiesKilled setValue( level.targets_hit );
	self.HUDenemiesKilled.alignx = "left";
	
	self.HUDcivviesKilled = so_create_hud_item( 4, ypos, "&&1/11", self );	
	self.HUDcivviesKilled setValue( level.friendlies_hit );
	self.HUDcivviesKilled.alignx = "left";

	self thread info_hud_handle_fade( self.HUDenemies );
	self thread info_hud_handle_fade( self.HUDcivvies );
	self thread info_hud_handle_fade( self.HUDenemiesKilled );
	self thread info_hud_handle_fade( self.HUDcivviesKilled );
	
	level waittill( "special_op_terminated" );

	set_failure_message_override();
	
	self.HUDenemies thread so_remove_hud_item();
	self.HUDcivvies thread so_remove_hud_item();
	self.HUDenemiesKilled thread so_remove_hud_item();
	self.HUDcivviesKilled thread so_remove_hud_item();
}

set_failure_message_override()
{
	if ( IsDefined( level.so_failure_message_override ) )
	{
		return;
	}

	if ( flag( "challenge_timer_expired" ) )
	{
		quotes = [];
		if ( level.friendlies_hit > 0 || level.missed_targets > 0 )
		{
			// On veteran and missed 1 target
			if ( getDifficulty() == "fu" && level.missed_targets > 0 )
			{
				quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_FU_AND_MISSED";
				quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_MISSED2";
			}

			// Too many Friendly hits
			if ( quotes.size == 0 && level.friendlies_hit > level.missed_targets )
			{
				quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_FRIENDLIES1";
				quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_FRIENDLIES2";
			}
	
			// Too many missed targets	
			if ( quotes.size == 0 && level.missed_targets > level.friendlies_hit )
			{
				quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_MISSED1";
				quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_MISSED2";
			}
		}
		else
		{
			if ( getDifficulty() == "fu" )
			{
				quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_COUPLE_SHOTS";
			}
		}

		if ( quotes.size > 0 )
		{
			so_force_deadquote_array( quotes );
		}
	}
}

move_spawn_and_go( path_ent )
{
	self.origin = path_ent.origin;
	if ( IsDefined( path_ent.angles ) )
		self.angles = path_ent.angles;

	// changes targetname of ai so that they to can spawn
	other_ents = getentarray( self.target, "targetname" );
	foreach( ent in other_ents )
	{
		if ( isspawner( ent ) )
			ent.targetname = path_ent.targetname;
	}

	self.target = path_ent.targetname;

	vehicle = self thread maps\_vehicle::spawn_vehicle_and_gopath();

	return vehicle;
}

delete_heli_node()
{
	self waittill( "trigger", heli );
	heli delete();
}

gameskill_regular()
{
	level.so_missed_target_deduction = 5;
	level.so_civ_deduction = 5;
	level.challenge_time_limit = 90;
	if ( is_coop() )
	{
		level.challenge_time_limit = 60;
	}

	target_triggers = getentarray( "target_trigger", "targetname" );
	array_thread( target_triggers, ::target_triggers_timeout );
}

gameskill_hardened()
{
	level.so_missed_target_deduction = 6;
	level.so_civ_deduction = 7;
	level.challenge_time_limit = 60;
	if ( is_coop() )
	{
		level.challenge_time_limit = 45;
	}

	// targets reset after a certain time
	delay_array = [];
	delay_array[0] = 5;
	delay_array[1] = 5;
	delay_array[2] = 6;
	delay_array[3] = 8;
	delay_array[4] = 6;
	delay_array[5] = 4;
	delay_array[6] = 8;
	delay_array[7] = 7;
	delay_array[8] = 6;

	struct = spawnstruct();
	struct.target_index = 0;
	
	target_triggers = getentarray( "target_trigger", "targetname" );
	array_thread( target_triggers, ::target_triggers_timeout, delay_array, struct );
}

gameskill_veteran()
{
	level.so_missed_target_deduction = 100;
	level.so_civ_deduction = 10;
	level.challenge_time_limit = 60;
	if ( is_coop() )
	{
		level.challenge_time_limit = 45;	
	}

	// targets move faster - see maps\trainer::target_think( targetType )
	// targets take multiple hit before going down.
	// MikeD 7/10: It's not intuitive to the enduser to keep this
//	level.target_fall_health = -150;

	// targets reset after a certain time
	delay_array = [];
	delay_array[0] = 3;
	delay_array[1] = 3;
	delay_array[2] = 4;
	delay_array[3] = 6;
	delay_array[4] = 4;
	delay_array[5] = 2;
	delay_array[6] = 6;
	delay_array[7] = 5;
	delay_array[8] = 4;

	struct = spawnstruct();
	struct.target_index = 0;

	target_triggers = getentarray( "target_trigger", "targetname" );
	array_thread( target_triggers, ::target_triggers_timeout, delay_array, struct );
}

target_triggers_timeout( delay_array, struct )
{
	// variables below set in maps\trainer::target_triggers_think
	// self.targets
	// self.targetsFriendly
	// self.targetsEnemy

	self waittill( "trigger" );

	if ( IsDefined( struct ) )
	{
		struct.target_index++;
		wait( delay_array[ struct.target_index - 1 ] );
	}
}