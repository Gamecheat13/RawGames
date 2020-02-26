#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_objectives;
//#include maps\_stealth_logic;
#include maps\_dynamic_nodes;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "event_56_start" );
//	flag_init( "high_alert" );	
	flag_init( "sal_at_door" );
	flag_init( "crc_door_open" );
	flag_init( "victim_down" );
	flag_init( "group_a_alert" );
	flag_init( "spawn_creepers" );
	flag_init( "player_alert_group_a" );
	flag_init( "engage_player" );	
	flag_init( "room_clear" );	
	flag_init( "group_c_spawn" );
	flag_init( "group_d_spawn" );
	flag_init( "group_e_spawn" );	
	flag_init( "sal_at_elevator" );	
	flag_init( "player_near_elevator" );
	flag_init( "sal_in_elevator" );
	flag_init( "player_in_elevator" );	
	flag_init( "enemy_visible" );
	
}

//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
	run_thread_on_targetname( "ai_con_site_group_a", ::add_spawn_function, ::ai_group_a_think );
	run_thread_on_targetname( "ai_con_site_group_b", ::add_spawn_function, ::spawn_group_c );	
	run_thread_on_noteworthy( "enemy_visible", ::add_spawn_function, ::ai_visible );
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_construction()
{
	level.ai_salazar = init_hero( "salazar" );

	start_teleport( "skipto_construction", array(level.ai_salazar) );
	
	level thread maps\createart\karma_art::karma_fog_atrium();
	maps\karma_anim::construction_anims();
}


/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{
	/#
		IPrintLn( "construction_site" );
	#/

//	maps\_stealth_logic::stealth_init();		
//	maps\_stealth_behavior::main();
	
	trigger_off( "t_crc", "script_noteworthy" );
	trigger_on( "t_constructions", "script_noteworthy" );
	
	level thread contruction_objectives();
//	level thread set_high_alert();	
	level thread player_ready();
//	level thread construction_stealth();
	
	level.ai_salazar thread sal_think();
	
	level.player.team = "allies";
//	wait 2;
//	level.player thread stealth_ai();

	level.group_a_kill_count = 0;	
	level.group_b_kill_count = 0;
	
	flag_set( "draw_weapons" );		
	
	// Wait until the gump is loaded before proceeding to outer solar
	flag_wait( "karma_gump_club" );
}

//-------------------------------------------------------------------------------------------
// Contruction objectives all the way to Elevator 3.
//-------------------------------------------------------------------------------------------

contruction_objectives()
{	
	objective_breadcrumb( level.OBJ_EVENT_5_6, "t_event_56_start" );
	
	flag_wait( "player_in_elevator" );
	
	set_objective( level.OBJ_EVENT_5_6, undefined, "done" );
	set_objective( level.OBJ_EVENT_5_6, undefined, "delete" );	
	
	flag_set( "event_56_start" );
}

//-------------------------------------------------------------------------------------------
// Salazar opening CRC exit door to construction site.
//-------------------------------------------------------------------------------------------
player_ready()
{
	flag_wait( "sal_at_door" );

	trigger_wait( "t_sal_crc_door" );	

	//-------------------------------------------------------------------------------------------
	// End animation of Salazar waiting next to CRC exit door.
	//-------------------------------------------------------------------------------------------
	end_scene( "scene_sal_loop_crc_door" );
	
	flag_set( "crc_door_open" );

	level.ai_sal_victim_01 = simple_spawn_single( "victim_01", ::sal_victim_think );
	level.ai_sal_victim_02 = simple_spawn_single( "victim_02", ::sal_victim_think );
	a_ai_group_a = simple_spawn( "ai_con_site_group_a" );
	//-------------------------------------------------------------------------------------------
	// Animation of salazar pressing button to exit CRC room.
	//-------------------------------------------------------------------------------------------
	level thread run_scene_and_delete( "scene_guard_reaction_crc_door" );
	level thread run_scene_and_delete( "scene_sal_exit_crc_door" );
	
	if( flag( "trespasser_reward_enabled" ) && level.player HasPerk( "specialty_trespasser" ) )
	{
		foreach( ai_group_a in a_ai_group_a )
		{
			if( isAlive( ai_group_a ) )
			{
				Target_Set( ai_group_a );
			}
		}
	}
	
	// temp fix for a bug where the timescale would never go away - MM 10/6/11
	//timescale_tween( 1.0, 0.25, 0.05, 4.25, 0.05 ); // 0.125 == 8 second, 0.25 == 4 second to headshot

	flag_wait( "victim_down" );
	
	end_scene( "scene_sal_exit_crc_door" );

	//scene_wait( "scene_sal_exit_crc_door" );
	if ( IsAlive( level.ai_sal_victim_02 ) )
	{
		level.ai_sal_victim_02 waittill_notify_or_timeout( "damage", 2.5 );
	}
	else
	{
		wait ( 2.5 );
	}
		
	//level thread timescale_tween( 0.5, 1.0, 0.05, 0.0 );
	
	//wait 1.2;
	
	//MagicBullet( level.ai_salazar.primaryweapon, level.ai_salazar gettagorigin( "tag_flash" ), ai_sal_victim_02 getShootAtPos() );		
	
	flag_set( "engage_player" );
	level thread battlechatter_on();
	
	level thread escalator_doors_open();	
}

//-------------------------------------------------------------------------------------------
// CRC door open.
//-------------------------------------------------------------------------------------------
salazar_crc_door()
{
	s_door_open = GetStruct( "crc_door_open", "targetname" );
	crc_door = GetEnt( "crc_door", "targetname" );
	
	flag_wait( "crc_door_open" );
	
	wait 4.0;
	
	crc_door moveto( s_door_open.origin, 0.5 );
	
	crc_door connectpaths();
}

//-------------------------------------------------------------------------------------------
// Salazar stabbing victim in the throat.
//-------------------------------------------------------------------------------------------
sal_victim_think()
{
	self.ignoreall = true;
	self.ignoreme = true;
	self change_movemode( "cqb_walk" );
	
	self waittill( "damage" );
	
	flag_set( "victim_down" );
	self dodamage( self.health+ 100, self.origin );
}


//
//	Bring weapon back up during breach in.  Should reconsider how this is written.
show_weapon_func( e_guy )
{
	level.player EnableWeapons();
	
	wait 0.5;
	
	if( isAlive( level.ai_sal_victim_01 ) )
	{
		MagicBullet( level.ai_salazar.primaryweapon, level.ai_salazar gettagorigin( "tag_flash" ), level.ai_sal_victim_01 getShootAtPos() );
	}	
	
	wait 1;
	
	if( isAlive( level.ai_sal_victim_02 ) )
	{
		MagicBullet( level.ai_salazar.primaryweapon, level.ai_salazar gettagorigin( "tag_flash" ), level.ai_sal_victim_02 getShootAtPos() );
	}	
}


//-------------------------------------------------------------------------------------------
// First spawner encounter think.  Set up stealth and waits to see if AI is alerted.
//-------------------------------------------------------------------------------------------
ai_group_a_think()
{
	self thread group_a_kill_count();
	self thread group_a_hurt();

	self endon( "death" );
	
	if( isAlive( self ) )
	{
		self.ignoreme = true;
		self.ignoreall = true;
		self.goalradius = 8;
		//self change_movemode( "cqb_walk" );
	}

	while( true )
	{
		if( flag( "victim_down" ) || flag( "group_a_alert") || flag( "player_alert_group_a" ) || level.player AttackButtonPressed() )
		{
			if( isDefined( self ) )
			{
				self.ignoreme = false;
				self.ignoreall = false;
			}
		}
		
		wait 0.05;
	}
}

group_a_kill_count()
{
	if( isAlive( self ) )
	{
		self waittill( "death" );
				
		level.group_a_kill_count++;		
	}		
}

group_a_hurt()
{
	if( isAlive( self ) )
	{
		self waittill( "damage" );
		
		flag_set( "group_a_alert" );	
	}
}
	
//-------------------------------------------------------------------------------------------
// Second spawner encounter think.  Set up stealth and waits to see if AI is alerted.
//-------------------------------------------------------------------------------------------
ai_group_b_c_think()
{
	self endon( "death" );
	
	self.goalradius = 8;
	self change_movemode( "cqb_walk" );
}

get_random( array )
{
	return array[ RandomInt( array.size ) ]; 
}

//-------------------------------------------------------------------------------------------
// Opening of escalator doors.
//-------------------------------------------------------------------------------------------
escalator_doors_open()
{	
	e_left_door = GetEnt( "escalator_door_left", "targetname" );
	e_right_door = GetEnt( "escalator_door_right", "targetname" );
	s_left_door_open = GetStruct( "escalator_door_left_open", "targetname" );
	s_right_door_open = GetStruct( "escalator_door_right_open", "targetname" );

	while( true )
	{
		//-------------------------------------------------------------------------------------------
		// Checks to see if player is near the escalator doors or have alerted AI.
		//-------------------------------------------------------------------------------------------
		if(  level.group_a_kill_count >= 4 )
		{
			a_ai_group_b = simple_spawn( "ai_con_site_group_b", ::ai_group_b_c_think );	
			
			if( flag( "trespasser_reward_enabled" ) && level.player HasPerk( "specialty_trespasser" ) )
			{
				foreach( ai_group_b in a_ai_group_b )
				{
					if( isAlive( ai_group_b ) )
					{
						Target_Set( ai_group_b );
					}
				}
			}
			
			wait( 0.5 );	
		
			e_left_door moveto( s_left_door_open.origin, 1.5 );
			e_right_door moveto( s_right_door_open.origin, 1.5 );
			
			e_left_door connectpaths();
			e_right_door connectpaths();
			
			if( level.group_a_kill_count >= 3 )
			{
				flag_set( "room_clear" );
			}
			
		}
	
		wait 0.05;
		
	}
}

//-------------------------------------------------------------------------------------------
// Spawn group c bad guys based on group b deaths
//-------------------------------------------------------------------------------------------
spawn_group_c()
{
	level endon( "group_c_spawn" );
	
	self waittill( "death" );	
	
	level.group_b_kill_count++;
	if ( level.group_b_kill_count  >= 2 )
	{	
		a_ai_group_c = simple_spawn( "ai_con_site_group_c", ::ai_group_b_c_think );
		
		if( flag( "trespasser_reward_enabled" ) && level.player HasPerk( "specialty_trespasser" ) )
		{
			foreach( ai_group_c in a_ai_group_c )
			{
				if( isAlive( ai_group_c ) )
				{
					Target_Set( ai_group_c );
				}
			}
		}
		
		flag_set( "group_c_spawn" );		
	}
}

//-------------------------------------------------------------------------------------------
// To ensure continuity off stealth gameplay, Sal ignores AI before double doors open.  If AI is alerted, then he can go crazy.
//-------------------------------------------------------------------------------------------
sal_ignore()
{
	self.ignoreall = true;
	self.ignoreme = true;
	self change_movemode( "cqb_walk" );		
	
	while( !level.group_b_kill_count >= 1 ) // || !flag( "high_alert" ) )
	{
		wait 1;		
	}

	self change_movemode( "cqb_sprint" );			
	self.ignoreall = false;
	self.ignoreme = false;		
}

//-------------------------------------------------------------------------------------------
// Salazar doing things in this area.
//-------------------------------------------------------------------------------------------
sal_think()
{
	self.ignoreme = true;
	self.goalradius = 8;
	self reset_movemode();
	self change_movemode( "cqb_sprint" );
	
	nd_00_sal = GetNode( "nd_00_sal_event_56", "targetname" );
	self SetGoalNode( nd_00_sal );
	self waittill( "goal");
	
	autosave_by_name("construction_site");			

//	trigger_wait( "t_sal_moveout" );
	
	//-------------------------------------------------------------------------------------------
	// Salazar moves to CRC door.
	//-------------------------------------------------------------------------------------------
	run_scene_and_delete( "scene_sal_ready_crc_door" );
	
	flag_set( "sal_at_door" );
	
	//-------------------------------------------------------------------------------------------
	// Thread that opens door.
	//-------------------------------------------------------------------------------------------
	level thread salazar_crc_door();	
	
	//-------------------------------------------------------------------------------------------
	// Animation of Salazar waiting next to CRC exit door incase player doesnt go to it right away. 
	//-------------------------------------------------------------------------------------------
	level thread run_scene_and_delete( "scene_sal_loop_crc_door" );
	
	//-------------------------------------------------------------------------------------------
	// Waits till Salazar stabs the guy.
	//-------------------------------------------------------------------------------------------
	scene_wait( "scene_sal_exit_crc_door" );
	
	self.ignoreme = false;	
	
	nd_02_sal = GetNode( "nd_02_sal_event_56", "targetname" );
	self SetGoalNode( nd_02_sal );
	
	//-------------------------------------------------------------------------------------------
	// Salazar waits till all 3 guys are dead.
	//-------------------------------------------------------------------------------------------
	flag_wait( "room_clear" );	
	
	nd_03_sal = GetNode( "nd_03_sal_event_56", "targetname" );
	self SetGoalNode( nd_03_sal );
	
//	self set_force_color( "r" );	
	
	//-------------------------------------------------------------------------------------------
	// Waits for player near the escalator doors ( double doors )
	//-------------------------------------------------------------------------------------------
	trigger_wait( "t_sal_escalator_door" );
	
//	self clear_force_color();
//	self reset_movemode();
	
	nd_04_sal = GetNode( "nd_04_sal_event_56", "targetname" );
	self SetGoalNode( nd_04_sal );
	
	level thread smoke_grenade_guy_01();
	level thread creeper();

	//-------------------------------------------------------------------------------------------
	// Waits for double doors to open.
	//-------------------------------------------------------------------------------------------
	flag_wait( "group_c_spawn" );
	
	nd_05_sal = GetNode( "nd_05_sal_event_56", "targetname" );
	self force_goal( nd_05_sal, 8 );
	
	self set_force_color( "o" );
	
	level thread elevator_03_doors();
	level thread player_by_elevator();	
	level thread sal_wait_elevator();
	level thread player_in_elevator();
	level thread play_elevator_03_anim();	
	
	trigger_wait( "t_sal_escalator_03_move" );
	
	self clear_force_color();
	
	
	
	nd_12_sal = GetNode( "nd_12_sal_event_56", "targetname" );
	level.ai_salazar SetGoalNode( nd_12_sal );
	level.ai_salazar.goalradius = 32;
	level.ai_salazar waittill( "goal" );
	self reset_movemode();
	flag_set( "sal_at_elevator" );	
}

creeper()
{
	flag_wait( "spawn_creepers" );
	level thread run_scene_and_delete("e5_guards_cover_fire");
	//simple_spawn( "creepers" );
}

smoke_grenade_guy_01()
{
	nd_smoke_guy01 = GetNode( "smoke_guy_01_node", "targetname" );	
	s_smoke_target01 = GetStruct( "smoke_grenade_01_target", "targetname" );
	
	trigger_wait( "t_spawn_c" );
	
	ai_smoke_guy_01 = simple_spawn_single( "smoke_grenade_guy_01" );
	ai_smoke_guy_01 force_goal( nd_smoke_guy01, 16 );
	
	wait 0.05;
	
	ai_smoke_guy_01 MagicGrenadeType( "concussion_grenade_sp", s_smoke_target01.origin, ( 0, -200, 100 ), 1 );	
	wait(1);
	if(Distance2DSquared(level.player.origin, s_smoke_target01.origin) <= (200 * 200) )
	{
		level.player shellShock( "concussion_grenade_mp", 2 );
	}
}

	
//-------------------------------------------------------------------------------------------
// Elevator 03 doors open when player makes it to the lobby.
//-------------------------------------------------------------------------------------------
elevator_03_doors()
{
	s_e3_left_open = getstruct( "e3_left_side_open", "targetname" );
	s_e3_right_open = getstruct( "e3_right_side_open", "targetname" );
	e_e3_left_door = GetEnt( "e3_left_side", "targetname" );
	e_e3_right_door = GetEnt( "e3_right_side", "targetname" );
	s_smoke_target02 = getstruct( "smoke_grenade_02_target", "targetname" );
	trigger_wait( "t_spawn_balcony_guy" );
	
	//ai_smoke_guy_02 = simple_spawn_single( "smoke_grenade_guy_02" );
	run_scene("e5_balcony_guard_death");
	///scene_wait("e5_balcony_guard_death");
	dead_guard = get_ais_from_scene("e5_balcony_guard_death");
	while(1)
	{
		if( !isalive( dead_guard[0] ))
		{
			break;	
		}
		
		wait(0.05);
	}
	delete_scene("e5_balcony_guard_death");
	
	level thread run_scene_and_delete("e5_elevator_guard_flash_exit");
	wait 0.1;
	
	e_e3_left_door moveto( s_e3_left_open.origin, 1.5 );
	e_e3_right_door moveto( s_e3_right_open.origin, 1.5 );
	
	e_e3_left_door connectpaths();
	e_e3_right_door connectpaths();
	
	
//	wait(1);
//	if(isalive(ai_smoke_guy_02))
//	{
//		ai_smoke_guy_02 MagicGrenadeType( "flash_grenade_sp", s_smoke_target02.origin, ( 0, -200, 100 ), 1 );
//	}
	
}

//-------------------------------------------------------------------------------------------
// Changing threat so that player is not shot right away as soon as he enters this room.  All threat goes to Salazar for 7 seconds.
//-------------------------------------------------------------------------------------------
threat_bias_grouping()
{	
	CreateThreatBiasGroup( "enemies" );
	CreateThreatBiasGroup( "salazar" );
	CreateThreatBiasGroup( "player" );

	guys = get_ai_group_ai( "group_c" );
	
	for( i=0; i < guys[i].size; i++ )
	{
		if( guys[i].team == "axis" )
		{
			guys[i] SetThreatBiasGroup( "enemies" );
		}
	}

	level.player SetThreatBiasGroup( "player" );
	level.ai_salazar SetThreatBiasGroup( "salazar" );
	
	SetThreatBias( "salazar", "enemies", 10000 );
	SetThreatBias( "player", "enemies", 100 );
	
	wait 7;
	
	SetThreatBias( "salazar", "enemies", 5000 );
	SetThreatBias( "player", "enemies", 5000 );
}

//-------------------------------------------------------------------------------------------
// Checks to see if player is near Elevator 3.
//-------------------------------------------------------------------------------------------
player_by_elevator()
{
	trigger_wait( "t_sal_escalator_03_in" );
	
	autosave_by_name("elevator_03");		
	
	flag_set( "player_near_elevator" );
}

//-------------------------------------------------------------------------------------------
// Salazar enters elevator.
//-------------------------------------------------------------------------------------------
sal_wait_elevator()
{
	flag_wait_all( "sal_at_elevator", "player_near_elevator" );
	
	run_scene_and_delete( "scene_sal_elevator_enter" );
	
	flag_set( "sal_in_elevator" );
	
	run_scene_and_delete( "scene_sal_elevator_wait" );		
}

//-------------------------------------------------------------------------------------------
// Player walking into elevator.
//-------------------------------------------------------------------------------------------
player_in_elevator()
{
	trigger_wait( "t_elevator_3_anims" );
	
	run_scene_and_delete( "scene_p_elevator_03" );

	e_elevator = GetEnt( "club_elevator", "targetname" );	
	level.player PlayerLinkTo( e_elevator );	
	
	//-------------------------------------------------------------------------------------------
	// Need to hold player into position and can only look around.
	//-------------------------------------------------------------------------------------------
	
	flag_set( "player_in_elevator" );
}

//-------------------------------------------------------------------------------------------
// Elevator 3 animation scene.
//-------------------------------------------------------------------------------------------
play_elevator_03_anim()
{
	e_p_align = GetEnt( "align_elevator_last", "targetname" );
	e_elevator = GetEnt( "club_elevator", "targetname" );
	nd_elevator_node = GetNode( "elevator_03_node", "targetname" );
	nd_elevator_exit_node	= GetNode( "elevator_exit_node", "targetname" );
	
	//SOUND - Shawn J
	level.sound_elevator2_ent_1 = spawn( "script_origin", level.player.origin );	
	
	//-------------------------------------------------------------------------------------------
	// There are two steps to getting the elevator to its destination.  It has to go to transfer origin then to club floor origin.  This is because we made drastic geo changes.
	//-------------------------------------------------------------------------------------------
	s_club_origin = GetStruct( "club_floor_origin", "targetname" );

	m_tag_origin = Spawn( "script_model", e_p_align.origin );
	m_tag_origin SetModel( "tag_origin" );
	m_tag_origin.angles = e_p_align.angles;
	m_tag_origin linkto( e_elevator );
	
	//-------------------------------------------------------------------------------------------
	// Keeps players and AI on platform stable.
	//-------------------------------------------------------------------------------------------
	e_elevator SetMovingPlatformEnabled();	
	
	//-------------------------------------------------------------------------------------------
	// Make sure that player and sal is in elevator.
	//-------------------------------------------------------------------------------------------
	flag_wait_all( "player_in_elevator", "sal_in_elevator" );
	
	e_elevator disconnectpaths();
		
	//SOUND: Shawn J
	playsoundatposition ("amb_elevator_2_button", (275, -5282, -4263));	
	level.sound_elevator2_ent_1 playloopsound( "amb_elevator_2_loop", 1 );
	
	run_scene_and_delete( "scene_sal_elevator_button" );
	
	run_scene_and_delete( "scene_sal_elevator_pack" );

	flag_set( "holster_weapons" );
	
	level thread battlechatter_off();
	
	level.ai_salazar gun_remove();
	
	level thread run_scene_and_delete( "scene_sal_elevator_idle" );
	
	e_p_align linkto( e_elevator );

	level.ai_salazar linkto( m_tag_origin, "tag_origin" );

	//-------------------------------------------------------------------------------------------
	// Elevator moves.
	//-------------------------------------------------------------------------------------------
	e_elevator moveto( s_club_origin.origin, 10.0 );	

	level thread load_gump( "karma_gump_club" );
	
	wait 3;
	// run advertisement (thread it)
	level thread run_scene_and_delete( "scene_sal_elevator_comment" );
	
	//SOUND: Shawn J
	level thread elevator_stop_loop();
	level.player playsound ("amb_elevator_2_stop");	
	
	wait 7;

	// Make sure gump is loaded before opening doors	
	flag_wait( "karma_gump_club" );

	level.player unlink();
	level.ai_salazar unlink();
	
	//SOUND - Shawn J - deleting temp elevator ent
	wait 8;
	
	if ( IsDefined( level.sound_elevator_ent_1 ) )
	{
		level.sound_elevator_ent_1 delete();
	}
	
//	level thread run_scene_and_delete( "scene_sal_elevator_exit" );
}

elevator_stop_loop()
{
	wait 4.5;
	level.player playsound ("amb_elevator_2_bell");		
	level.sound_elevator2_ent_1 stoploopsound (1);
}


construction_stealth()
{
	// these values represent the BASE huristic for max visible distance base meaning 
	// when the character is completely still and not turning or moving
	// HIDDEN is self explanatory
	hidden = [];
	hidden[ "prone" ]	 = 40;
	hidden[ "crouch" ]	 = 80; //260;
	hidden[ "stand" ]	 = 160; //380;
	
	// ALERT levels are when the same AI has sighted the same enemy twice OR found a body	
	alert = [];
	alert[ "prone" ]	 = 80;
	alert[ "crouch" ]	 = 160; //900;
	alert[ "stand" ]	 = 320; //1500;

	// SPOTTED is when they are completely aware and go into NORMAL COD AI mode...however, the
	// distance they can see you is still limited by these numbers because of the assumption that
	// you're wearing a ghillie suit in woodsy areas
	spotted = [];
	spotted[ "prone" ]	= 512; //512;
	spotted[ "crouch" ]	= 5000; //5000;
	spotted[ "stand" ]	= 8000; //8000;
	
	//stealth_detect_ranges_set( hidden, alert, spotted );
	IPrintLn( "Default Gameplay:  Stealth, turns off when shot fired or body found." );
}

custom_stealth_ai()
{
	awareness_functions = [ ];

	alert_functions = [ ];	
}

set_high_alert()
{
	level endon( "_stealth_stop_stealth_logic" );	
	
	for ( ;; )
	{
		level add_wait( ::flag_wait, "_stealth_spotted" );	

		do_wait_any();
	
		flag_set( "high_alert" );
		
		thread alert_on();
		for ( ;; )
		{
			ai = getaiarray( "axis" );
			if ( !ai.size )
				break;
			
			has_enemy = false;
			for ( i = 0; i < ai.size; i++ )
			{
				if ( !isalive( ai[ i ].enemy ) )
					continue;
				has_enemy = true;
				break;
			}
			if ( !has_enemy )
				break;
			wait( 0.05 );
		}
		flag_clear( "high_alert" );
		wait( 0.05 );
	}	
}

alert_on()
{
//	iprintlnbold("Team Spotted!!!");
	
	level notify( "_stealth_stop_stealth_logic" );	
}

//notetrack for flashbang guys
throw_flash_bang( guy )
{
	s_smoke_target02 = getstruct( "smoke_grenade_02_target", "targetname" );	
	guy MagicGrenadeType( "flash_grenade_sp", s_smoke_target02.origin, ( 0, -200, 100 ), 1 );	
		
}