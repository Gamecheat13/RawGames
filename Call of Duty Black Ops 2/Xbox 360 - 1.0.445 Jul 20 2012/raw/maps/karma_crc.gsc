#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_objectives;
#include maps\_glasses;
#include maps\_dialog;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_glasses.gsh;
#insert raw\maps\karma.gsh;

/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
init_flags()
{
	flag_init( "crc_karma_identified" );
	flag_init( "crc_flash_out" );
}

init_spawn_funcs()
{
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_crc()
{
	/#
		IPrintLn( "crc" );
	#/
	
	//Disable color triggers for use during construction battle after the CRC room
	add_global_spawn_function( "axis", ::change_movemode, "cqb_run" );
	trigger_off( "construction_battle_color_triggers", "script_noteworthy" );
}

/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
main()
{	
	spiderbot_transition();
	crc_breach_event();
	crc_terminal_event();
	
	cleanup_ents( "cleanup_crc" );
}

crc_objectives()
{
	set_objective( level.OBJ_ENTER_CRC, level.ai_salazar, "follow" );
	level.ai_salazar waittill( "goal" );
	
	set_objective( level.OBJ_ENTER_CRC, GetStruct( "struct_obj_crc_door" ), "breadcrumb" );
	trigger_wait( "t_eye_scan_crc" );
	
	set_objective( level.OBJ_ENTER_CRC, undefined, "done" );
	set_objective( level.OBJ_ID_KARMA, undefined, "active" );
	waittill_ai_group_cleared( "crc_interior_guards" );
	
	set_objective( level.OBJ_ID_KARMA, GetStruct( "struct_obj_computer" ), "breadcrumb" );
	flag_wait( "crc_karma_identified" );
	
	set_objective( level.OBJ_ID_KARMA, undefined, "done" );
}

init_door_clip()
{
	foreach( door in GetEntArray( "script_doors", "script_noteworthy" ) )
	{
		GetEnt( door.target, "targetname" ) LinkTo( door );
	}
}

init_crc_glass_monster_clip()
{	
	a_clip_brushes = GetEntArray( "crc_glass_clip", "targetname" );
	
	foreach( e_brush in a_clip_brushes )
	{
		e_brush thread crc_glass_monster_clip_think();
	}
}

init_tarp_clip()
{
	for( i = 1; i <= 12; i++ )
	{
		if( i < 10 )
		{
			m_tarp = GetEnt( "fxanim_tarp_shootdown_0" + i, "targetname" );
			e_clip = GetEnt( "tarp_collision_0" + i, "targetname" );
		}
		else
		{
			m_tarp = GetEnt( "fxanim_tarp_shootdown_" + i, "targetname" );
			e_clip = GetEnt( "tarp_collision_" + i, "targetname" );
		}
		
		if( IsDefined( m_tarp ) && IsDefined( e_clip ) )
		{
			m_tarp thread tarp_clip_think( e_clip );
		}
	}
}

tarp_clip_think( e_clip )
{
	level endon( "offices_cleared" );
	
	self waittill( "damage" );
	
	//Wait for fxanim to finish playing roughly
	wait 3.0;
	
	e_clip NotSolid();
	e_clip ConnectPaths();
	e_clip Delete();
}

init_use_trigger_hints()
{
	GetEnt( "destroyed_spider_bot_trigger", "targetname" ) SetHintString( &"KARMA_PICKUP_SPIDERBOT_HINT" );
	GetEnt( "trespasser_reward_interact_trigger", "targetname" ) SetHintString( &"KARMA_TRESPASSER_HINT" );
}

crc_glass_monster_clip_think()
{
	level endon( "offices_cleared" );
	
	s_start_point = GetStruct( self.target, "targetname" );
	v_endpoint = s_start_point.origin + (AnglesToForward( s_start_point.angles ) * 18);
	
	while( IsDefined( self ) )
	{
		level waittill( "glass_smash" );
		wait 0.05;
		
		if( BulletTrace( s_start_point.origin, v_endpoint, false, level.player, true, false, level.ai_salazar )["position"] == v_endpoint )
		{
			self NotSolid();
			self ConnectPaths();
			self Delete();
		}
	}
}

spiderbot_transition()
{	
	//Init anims for this area
	maps\karma_anim::construction_anims();
	
	init_door_clip();
	init_use_trigger_hints();
	init_crc_glass_monster_clip();
	init_tarp_clip();
	level thread trespasser_perk();
	
	//Reinit Salazar (was deleted at start of spiderbot event)
	level.ai_salazar = init_hero( "salazar" );
	
	//SOUND - Shawn J
	level.player playsound("evt_spiderbot_outro");
	
	level.player thread say_dialog( "sect_harper_you_were_ri_0", 1.0 );
	
	//Put spiderbot gear away
	run_scene_and_delete( "scene_p_gear_away" );

	level.player thread say_dialog( "sect_let_s_go_0", 0.5 );	
}

crc_breach_event()
{
	m_crc_door = GetEnt( "crc_door", "targetname" );
	
	//TODO: Get a loop for Salazar at the door
	level.ai_salazar thread force_goal( GetNode("n_salazar_crc_enter", "targetname"), 8 );
	
	level thread crc_objectives();
	level.ai_salazar waittill( "goal" );
	
	//Wait for player to approach door
	trigger_wait( "t_eye_scan_crc" );
	
	//Set checkpoint for door breach
	thread autosave_by_name( "crc" );
	
	a_enemies = simple_spawn("crc_breach_guards");
	
	//Run CRC eye scan
	crc_eye_scan();
	
	//Open CRC door
	m_crc_door MoveY( 63, 1.5 );
	
	level thread crc_breach_enemy_fire();
	scene_wait( "scene_p_eye_scan" );
	
	GetEnt( m_crc_door.target, "targetname" ) ConnectPaths();
	level thread crc_breach_flash();
	run_scene_and_delete( "scene_p_eye_scan_breach" );
	
	foreach( ai_enemy in a_enemies )
	{
		if( IsAlive( ai_enemy ) )
		{
			ai_enemy set_goalradius( 1024 );
		}
	}
	
	waittill_ai_group_cleared( "crc_interior_guards" );
	
	level thread crc_salazar_terminal_idle();
}

crc_salazar_terminal_idle()
{
	level.ai_salazar say_dialog( "sala_clear_0", 1.0 );
	
	setmusicstate ("KARMA_1_CRC");
	
	// Salazar approaches computer terminal and starts searching for enemy activity.
	run_scene_and_delete( "scene_sal_intro_comp" );
	level thread run_scene_and_delete( "scene_sal_loop_comp" );
}

crc_breach_enemy_fire()
{
	a_shooters = GetEntArray( "crc_breach_guards_ai", "targetname" );
	e_shoot_target = GetEnt( "crc_breach_fire_target", "targetname" );
	
	level.player EnableInvulnerability();
	
	foreach( ai_shooter in a_shooters )
	{
		if ( IsDefined( ai_shooter.script_string ) && ai_shooter.script_string == "crc_breach_shooters" )
		{
			ai_shooter thread shoot_at_target( e_shoot_target, undefined, 0.0, 10.0 );
		}
	}
	
	wait 14.0;

	level.player DisableInvulnerability();
}

crc_breach_flash()
{
	s_flash_target = GetStruct( "crc_breach_flash_target", "targetname" );
	flag_wait( "crc_flash_out" );
	
	level.ai_salazar MagicGrenadeType( "flash_grenade_sp", s_flash_target.origin, (0, 0, 0), 0.05 );
	exploder( 540 );
	
	level thread maps\_audio::switch_music_wait("KARMA_1_ENTER_CRC", 2);
}

// CRC door opening and closing function.
crc_eye_scan()
{
	level thread run_scene_and_delete( "scene_p_eye_scan" );
	
	//TODO: Notetrack the start of the eye scan
	wait 1.15;
	
	//Play blue scan effect
	exploder( 480 );
	
	//SOUND - Shawn J
	level.player playsound ("evt_eye_scanner");	
	play_bink_on_hud( "eye_v5", BINK_IS_LOOPING, !BINK_IN_MEMORY );
	
	//Scanning time
	wait 3.0;
	
	stop_exploder( 480 );
	stop_bink_on_hud();
}

crc_terminal_event()
{	
	trigger_wait( "t_minority_report" );
	
	//Play LobbyShootout Bink shot.
	level thread lobby_shootout();
	
	//SOUND - Shawn J
	level.player playsound ("evt_ui_wall");	

	//Close CRC door
	m_crc_door = GetEnt( "crc_door", "targetname" );
	m_crc_door MoveY( -63, 1.5 );
	m_crc_door DisconnectPaths();
	
	//Delete construction vision set triggers
	level thread construction_vision_trigger_cleanup();
	
	crc_interact();
	flag_set( "crc_karma_identified" );
	
	// Ends that animation of Salazar accessing another computer.
	end_scene( "scene_sal_loop_comp" );
}

construction_vision_trigger_cleanup()
{
	foreach( e_trigger in GetEntArray( "construction_vision_triggers", "script_noteworthy" ) )
	{
		e_trigger trigger_off();
	}
	
	foreach( e_trigger in GetEntArray( "lowlight_trigger", "targetname" ) )
	{
		e_trigger trigger_on();
		e_trigger thread low_light_vision_trigger_think();
	}
}

low_light_vision_trigger_think()
{
	level endon( "offices_cleared" );
	
	while( true )
	{
		self waittill( "trigger" );
	
		VisionSetNaked( "sp_karma_low_light_warm", 2.0 );
		level.karma_vision = "sp_karma_low_light_warm";
		level clientNotify( "lowlight_on" );
	
		wait 0.05;
	}
}

// Lobby shootout BINK
lobby_shootout()
{
	s_e3_left_open = getstruct( "e3_left_side_open", "targetname" );
	s_e3_right_open = getstruct( "e3_right_side_open", "targetname" );
	s_e3_left_close = getstruct( "e3_left_side_close", "targetname" );
	s_e3_right_close = getstruct( "e3_right_side_close", "targetname" );	
	e_e3_left_door = GetEnt( "e3_left_side_top", "targetname" );
	e_e3_right_door = GetEnt( "e3_right_side_top", "targetname" );		
	
	wait 14.0;
	
	e_e3_left_door MoveTo( (e_e3_left_door.origin[0], s_e3_left_open.origin[1], e_e3_left_door.origin[2]), 1.5 );
	e_e3_right_door MoveTo( (e_e3_right_door.origin[0], s_e3_right_open.origin[1], e_e3_right_door.origin[2]), 1.5 );
	
	wait 1.5;
	
	run_scene_and_delete( "scene_lobby_shootout" );
	
	e_e3_left_door MoveTo( (e_e3_left_door.origin[0], s_e3_left_close.origin[1], e_e3_left_door.origin[2]), 1.5 );
	e_e3_right_door MoveTo( (e_e3_right_door.origin[0], s_e3_right_close.origin[1], e_e3_right_door.origin[2]), 1.5 );
}

//	Player interacts with the CRC. The Minority Report moment.
crc_interact()
{	
	maps\createart\karma_art::vision_set_change( "sp_karma_crc_screens" );
	
	cin_id = Start3DCinematic("crc_part01", false, false);
	run_scene( "crc1" );
	Stop3DCinematic( cin_id );
	cin_id = Start3DCinematic("crc_part01_loop", true, false);
	level thread run_scene( "crc1_idle" );
	wait_for_input( "zoom" );
	
	Stop3DCinematic( cin_id );
	cin_id = Start3DCinematic("crc_part02", false, false);
	run_scene( "crc2" );
	Stop3DCinematic( cin_id );
	cin_id = Start3DCinematic("crc_part02_loop", true, false);
	level thread run_scene( "crc2_idle" );
	wait_for_input( "move_up" );
	
	Stop3DCinematic( cin_id );
	cin_id = Start3DCinematic("crc_part03", false, false);
	run_scene( "crc3" );
	Stop3DCinematic( cin_id );
	cin_id = Start3DCinematic("crc_part03_loop", true, false);
	level thread run_scene( "crc3_idle" );
	wait_for_input( "move_left" );
	
	Stop3DCinematic( cin_id );
	cin_id = Start3DCinematic("crc_part04", false, false);
	run_scene( "crc4" );
	Stop3DCinematic( cin_id );
	cin_id = Start3DCinematic("crc_part04_loop", true, false);
	level thread run_scene( "crc4_idle" );
	wait_for_input( "zoom" );
	
	Stop3DCinematic( cin_id );
	cin_id = Start3DCinematic("crc_part05", false, false);
	run_scene( "crc5" );
	Stop3DCinematic( cin_id );
	
	level thread crc_interact_cleanup();
	
	maps\createart\karma_art::vision_set_change( "sp_karma_crc" );
}

crc_interact_cleanup()
{
	delete_scene( "crc1", true );
	delete_scene( "crc1_idle", true );
	delete_scene( "crc2", true );
	delete_scene( "crc2_idle", true );
	delete_scene( "crc3", true );
	delete_scene( "crc3_idle", true );
	delete_scene( "crc4", true );
	delete_scene( "crc4_idle", true );
	delete_scene( "crc5", true );
	delete_scene( "crc5_idle", true );
	delete_scene( "crc6", true );
	delete_scene( "crc6_idle", true );
	delete_scene( "crc7", true );
}

//	Loop until the player presses the appropriate input
wait_for_input( str_input )
{
	// throw up the hint string
	switch( str_input )
	{
		case "attack":
			str_msg = &"KARMA_HINT_ATTACK";
			break;
		case "melee":
			str_msg = &"KARMA_HINT_MELEE";
			break;
		case "look_down":
			str_msg = &"KARMA_HINT_LOOK_DOWN";
				break;
		case "look_left":
			str_msg = &"KARMA_HINT_LOOK_LEFT";
				break;
		case "look_right":
			str_msg = &"KARMA_HINT_LOOK_RIGHT";
				break;
		case "look_up":
			str_msg = &"KARMA_HINT_LOOK_UP";
				break;
		case "move_down":
			str_msg = &"KARMA_HINT_MOVE_DOWN";
				break;
		case "move_left":
			str_msg = &"KARMA_HINT_MOVE_LEFT";
				break;
		case "move_right":
			str_msg = &"KARMA_HINT_MOVE_RIGHT";
				break;
		case "move_up":
			str_msg = &"KARMA_HINT_MOVE_UP";
				break;
		case "sprint":
			str_msg = &"KARMA_HINT_SPRINT";
			break;
		case "use":
			str_msg = &"KARMA_HINT_USE";
			break;
		case "zoom":
			str_msg = &"KARMA_HINT_ZOOM";
			break;
	}
	thread screen_message_create( str_msg, undefined, undefined, 128 );

	b_got_input = false;
	while ( !b_got_input )
	{
		v_lstick = level.player GetNormalizedMovement();		// left stick
		v_rstick = level.player GetNormalizedCameraMovement();	// right stick

		switch( str_input )
		{
			case "attack":
				if ( level.player AttackButtonPressed() )
			    {
			    	b_got_input = true;
			    }
				break;
			case "melee":
				if ( level.player MeleeButtonPressed() )
			    {
			    	b_got_input = true;
			    }
				break;
			case "look_down":
				if ( v_rstick[0] < -0.8 )
			    {
			    	b_got_input = true;
			    }
				break;
			case "look_left":
				if ( v_rstick[1] < -0.8 )
			    {
			    	b_got_input = true;
			    }
				break;
			case "look_right":
				if ( v_rstick[1] > 0.8 )
			    {
			    	b_got_input = true;
			    }
				break;
			case "look_up":
				if ( v_rstick[0] > 0.8 )
			    {
			    	b_got_input = true;
			    }
				break;
			case "move_down":
				if ( v_lstick[0] < -0.8 )
			    {
			    	b_got_input = true;
			    }
				break;
			case "move_left":
				if ( v_lstick[1] < -0.8 )
			    {
			    	b_got_input = true;
			    }
				break;
			case "move_right":
				if ( v_lstick[1] > 0.8 )
			    {
			    	b_got_input = true;
			    }
				break;
			case "move_up":
				if ( v_lstick[0] > 0.8 )
			    {
			    	b_got_input = true;
			    }
				break;
			case "sprint":
				if ( level.player SprintButtonPressed() )
			    {
			    	b_got_input = true;
			    }
				break;
			case "use":
				if ( level.player UseButtonPressed() )
			    {
			    	b_got_input = true;
			    }
				break;
			case "zoom":
				if ( v_lstick[1] < -0.6  && v_rstick[1] > 0.6 )
				{
			    	b_got_input = true;
				}
				break;
		}

		wait( 0.05 );
	}
	
	screen_message_delete();
}

//-----------------------------------------------------------------------------------------------
//-----------------------------------SPECIALTY PERK---------------------------------
//-----------------------------------------------------------------------------------------------
trespasser_perk()
{	
	if( !level.player HasPerk( "specialty_trespasser" ) )
	{
		trigger_off( "trespasser_reward_interact_trigger", "targetname" );
		return;
	}
	
	set_objective( level.OBJ_INTERACT, GetStruct( "trespasser_obj_marker", "targetname"), "interact" );
	trigger_wait( "trespasser_reward_interact_trigger" );
	
	set_objective( level.OBJ_INTERACT, undefined, "remove" );
	run_scene_and_delete( "trespasser" );
	flag_set( "trespasser_reward_enabled" );
	
	// Now enemies have highlight shaders
	level.player set_temp_stat( TEMP_STAT_ENEMY_ID, 1 );
}