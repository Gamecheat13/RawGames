/*
	MONSOON!
	
	SCRIPTERS: Kevin Drew, Damoun Shabestari, Sky Silcox
	BUILDERS: Gavin Goslin, Susan Arnold
	PROD: Brent Toda, John Dehart
*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\monsoon_util;
#include maps\_scene;
#include maps\_vehicle;
#include maps\_dialog;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

skipto_celerium()
{
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	level.crosby = init_hero( "crosby" );
//	level.isaac = init_hero( "isaac" );
	
	skipto_teleport( "player_skipto_celerium", get_heroes() );
	
	maps\monsoon_lab::temp_lab_dialogue();
}

init_celerium_flags()
{
	flag_init( "set_celerium_door_obj" );
	flag_init( "player_triggered_celerium_door" );	
	
	flag_init( "player_at_celerium_door" );
	
	flag_init( "player_at_celerium" );
	flag_init( "set_celerium_chip_obj" );
}

celerium_chamber_main()
{
	//wait until defend is over
	flag_wait( "lab_defend_done" );
	
	autosave_by_name( "defend_end" );	
	
	level thread celerium_entrance_doors();
	
	level thread isaac_celerium();
	
	level thread harper_celerium();
	
	level.salazar thread salazar_celerium();
	
	level thread crosby_celerium();
	
	level thread player_celerium();
}

celerium_entrance_doors()
{
	flag_wait( "player_triggered_celerium_door" );
	
	//front doors
	bm_celerium_door_front_l = GetEnt( "celerium_door_front_l", "targetname" );
	bm_celerium_door_front_r = GetEnt( "celerium_door_front_r", "targetname" );
	
	//rear doors
	bm_celerium_door_rear_l = GetEnt( "celerium_door_rear_l", "targetname" );
	bm_celerium_door_rear_r = GetEnt( "celerium_door_rear_r", "targetname" );
	
		
	//SOUND - Shawn J
	//iprintlnbold ("celerium_doors");
	bm_celerium_door_front_l playsound("evt_celerium_doors");
	
	bm_celerium_door_front_l MoveY( -90, 5, 1 );
	bm_celerium_door_front_r MoveY( 90, 5, 1 );
	
	wait 1.5;
	
	bm_celerium_door_rear_l MoveY( -83, 5, 1 );
	bm_celerium_door_rear_r MoveY( 83, 5, 1 );
	
	s_front_celerium_door_rumble_dist = getstruct( "front_celerium_door_rumble_dist", "targetname" );
	s_front_celerium_door_rumble_dist.is_moving = true;
	s_front_celerium_door_rumble_dist.is_big_door = true;
	s_front_celerium_door_rumble_dist thread player_door_rumble();
	
	s_back_celerium_door_rumble_dist = getstruct( "back_celerium_door_rumble_dist", "targetname" );
	s_back_celerium_door_rumble_dist.is_moving = true;
	s_back_celerium_door_rumble_dist.is_big_door = true;
	s_back_celerium_door_rumble_dist thread player_door_rumble();
	
	bm_celerium_door_front_l waittill( "movedone" ); //front
	s_front_celerium_door_rumble_dist.is_moving = false;
	
	n_distance = Distance2D( s_front_celerium_door_rumble_dist.origin, level.player.origin );
	if ( n_distance < 500 )
	{
		level.player PlayRumbleOnEntity( "damage_heavy" );
	}	
	
	bm_celerium_door_rear_l waittill( "movedone" ); //rear
	s_back_celerium_door_rumble_dist.is_moving = false;
	
	n_distance = Distance2D( s_back_celerium_door_rumble_dist.origin, level.player.origin );
	if ( n_distance < 500 )
	{
		level.player PlayRumbleOnEntity( "damage_heavy" );
	}	
	
	bm_celerium_door_front_l ConnectPaths();
	bm_celerium_door_front_r ConnectPaths();
	
	bm_celerium_door_rear_l ConnectPaths();
	bm_celerium_door_rear_r ConnectPaths();
	
	level.harper thread say_dialog( "harper_pre_celerium_chip" );
}

player_celerium()
{
	//wait until isaac or salazar reaches the celerium doors
	flag_wait( "set_celerium_door_obj" );

	run_scene_first_frame( "salazar_celerium_chip_init" );
	
	trig_player_celerium_door = GetEnt( "trig_player_celerium_door", "targetname" );
	trig_player_celerium_door trigger_on();
	trig_player_celerium_door SetHintString( &"MONSOON_LIFT_PROMPT" );
	trig_player_celerium_door waittill( "trigger" );
	trig_player_celerium_door Delete();
	
	flag_set( "player_at_celerium_door" );
	
		
	//SOUND - Shawn J
	//iprintlnbold ("eye_scan_3");
	PlaySoundAtPosition ("evt_eye_scanner_03", (6672, 55968, -1197));
	
	a_defend_asds = GetEntArray( "defend_asds", "script_noteworthy" );
	foreach( asd in a_defend_asds ) 
	{
		if ( IsSentient( asd ) )
		{
			asd notify( "death" );
		}
	}
		
	ai_axis = GetAiArray( "axis" );
	foreach( ai in ai_axis ) 
	{
		if ( IsDefined( ai ) && IsAlive( ai ) )
		{
			ai Die();
		}
	}
	
	run_scene( "player_celerium_door_open" );	
	
	//waits until isaac or salazar gets to the celerium chip
	flag_wait( "set_celerium_chip_obj" );
	
	trig_player_celerium = GetEnt( "trig_player_celerium", "targetname" );
	trig_player_celerium trigger_on();
	trig_player_celerium SetHintString( &"MONSOON_LIFT_PROMPT" );	
	trig_player_celerium waittill( "trigger" );
	trig_player_celerium Delete();
	
	flag_set( "player_at_celerium" );
	run_scene( "player_celerium_chip_end" );
	
//	if ( !flag( "isaac_is_killed" ) )
//	{
//		/#
//			IPrintLn( "playing isaac player anim" );
//		#/
//		
//		//if Isaac Lives, Isaac animates, duh
//		run_scene( "player_celerium_chip_end_isaac" );
//	}
//	else
//	{
//		/#
//			IPrintLn( "playing salazar player anim" );	
//		#/
//			
//		//if Isaac Dies, Salazar animates
//		run_scene( "player_celerium_chip_end_salazar" );
//	}

	level.player notify( "mission_finished" );
	
	screen_fade_out( 3 );
	
	nextmission();
}

isaac_celerium()
{
	if ( flag( "isaac_is_killed" ) )
	{
		return;
	}
	
	//run_scene_first_frame( "isaac_celerium_chip_end" );
	
	end_scene( "isaac_hack_loop" );
	
	run_scene( "isaac_celerium_door_approach" );
	
	level thread run_scene( "isaac_celerium_door_loop" );
		
	level thread isaac_celerium_door_nag();	
	flag_set( "set_celerium_door_obj" );

	//wait until player opens the door
	flag_wait( "player_triggered_celerium_door" );
	
	run_scene( "isaac_celerium_door_open" );
	
	run_scene( "isaac_celerium_approach" );
	
	level thread run_scene( "isaac_celerium_loop" );
	
	level thread isaac_celerium_chip_nag();
	
	flag_set( "set_celerium_chip_obj" );
	
	flag_wait( "player_at_celerium" );
	
	level.isaac thread say_dialog( "isaac_celerium_chip" );
	level.isaac thread say_dialog( "isaac_player_perk" );

	//level thread run_scene( "isaac_celerium_chip_end" );
	run_scene( "isaac_celerium_end" );
}

isaac_celerium_door_nag()
{
	n_nag_line_frequency = RandomIntRange( 4, 6 );
	
	while ( !flag( "player_at_celerium_door") )
	{
		n_index = RandomIntRange( 1, 4 );
		
		level.isaac thread say_dialog( "isaac_door_nag_" + n_index );
		
		wait n_nag_line_frequency;
	}
}

isaac_celerium_chip_nag()
{
	n_nag_line_frequency = RandomIntRange( 4, 6 );
	
	while ( !flag( "player_at_celerium") )
	{
		n_index = RandomIntRange( 1, 4 );
		
		level.isaac thread say_dialog( "isaac_chip_nag_" + n_index );
		
		wait n_nag_line_frequency;
	}
}

harper_celerium()
{
	level.harper.goalradius = 32;
	
	nd_harper_celerium_door = GetNode( "nd_harper_celerium_door", "targetname" );
	level.harper SetGoalNode( nd_harper_celerium_door );
	level.harper waittill( "goal" );
	
	flag_wait( "player_triggered_celerium_door" );
	
	run_scene( "harper_celerium_approach" );
	
	level thread run_scene( "harper_celerium_loop" );
	
	flag_wait( "player_at_celerium" );
	
	level.harper thread say_dialog( "harper_celerium_chip" );
	
	run_scene( "harper_celerium_end" );
}

salazar_celerium()
{
	if ( !flag( "isaac_is_killed" ) ) //ISAAC ALIVE
	{
		self.goalradius = 32;
		
		nd_salazar_defend = GetNode( "nd_salazar_defend", "targetname" );
		self SetGoalNode( nd_salazar_defend );
		self waittill( "goal" );
		
		flag_wait( "player_triggered_celerium_door" );
	
		run_scene( "salazar_celerium_approach" );
		
		level thread run_scene( "salazar_celerium_loop" );
		
		flag_set( "set_celerium_chip_obj" );

		flag_wait( "player_at_celerium" );
		
		run_scene( "salazar_celerium_end" );
	}
	else //ISAAC DEAD
	{
		//run_scene_first_frame( "salazar_celerium_chip_end_alt" );
		
		end_scene( "salazar_hack_loop" );
		
		run_scene( "salazar_celerium_door_approach" );
		
		level thread run_scene( "salazar_celerium_door_loop" );
		
		level thread salazar_celerium_door_nag();
	
		flag_set( "set_celerium_door_obj" );
		
		flag_wait( "player_triggered_celerium_door" );
		
		run_scene( "salazar_celerium_door_open" );
		
		flag_wait( "player_triggered_celerium_door" );
	
		run_scene( "salazar_celerium_approach_alt" );
		
		level thread run_scene( "salazar_celerium_loop_alt" );
		
		level thread salazar_celerium_chip_nag();
		
		flag_set( "set_celerium_chip_obj" );
		
		flag_wait( "player_at_celerium" );
		
		level.salazar thread say_dialog( "salazar_celerium_chip" );
	
		//level thread run_scene( "salazar_celerium_chip_end_alt" );
		run_scene( "salazar_celerium_end_alt" );
	}
}

salazar_celerium_door_nag()
{
	n_nag_line_frequency = RandomIntRange( 4, 6 );
	
	while ( !flag( "player_at_celerium_door") )
	{
		n_index = RandomIntRange( 1, 4 );
		
		level.salazar thread say_dialog( "salazar_door_nag_" + n_index );
		
		wait n_nag_line_frequency;
	}		
}

salazar_celerium_chip_nag()
{
	n_nag_line_frequency = RandomIntRange( 4, 6 );
	
	while ( !flag( "player_at_celerium" ) )
	{
		n_index = RandomIntRange( 1, 4 );
		
		level.salazar thread say_dialog( "salazar_chip_nag_" + n_index );
		
		wait n_nag_line_frequency;
	}
}

crosby_celerium()
{
	level.crosby.goalradius = 32;
	
	nd_crosby_celerium_door = GetNode( "nd_crosby_celerium_door", "targetname" );
	level.crosby SetGoalNode( nd_crosby_celerium_door );
	level.crosby waittill( "goal" );
	
	flag_wait( "player_triggered_celerium_door" );	
	
	run_scene( "crosby_celerium_approach" );
	
	level thread run_scene( "crosby_celerium_loop" );
	
	flag_wait( "player_at_celerium" );
	
	run_scene( "crosby_celerium_approach" );
}