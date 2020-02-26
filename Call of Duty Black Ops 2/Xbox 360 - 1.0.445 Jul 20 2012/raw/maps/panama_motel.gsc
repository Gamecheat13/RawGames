#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\panama_utility;
#include maps\_objectives;
#include maps\_anim;
#include maps\_music;

skipto_motel()
{
	skipto_setup();
	
	level.mason = init_hero( "mason" );

	a_hero[0] = level.mason;
	skipto_teleport( "skipto_motel_player", a_hero );	

	flag_set( "trig_mason_to_motel" );
	
	maps\createart\panama_art::set_water_dvar();
	
	// TODO: uncomment this if you want to test the nightingale
//	level.player GiveWeapon( "nightingale_dpad_sp" );
//	level.player SetActionSlot(2, "weapon", "nightingale_dpad_sp");
//	
//	level.player thread nightingale_watch();
//	
//	simple_spawn( "nightingale_test_dummy" );
}

init_motel_flags()
{
	flag_init( "mason_at_motel" );
	flag_init( "motel_scene_end" );
	flag_init( "start_intro_anims" );
	flag_init( "trig_mason_to_motel" );
	flag_init( "player_pull_pin" );
	flag_init( "motel_room_cleared" );
	flag_init( "breach_gun_raised" );
}

main()
{	
	level thread maps\createart\panama_art::motel();
	motel_breach_main();
	
//	flag_wait( "motel_scene_end" );
}

motel_breach_main()
{
	
	//setmusicstate ("PANAMA_HOTEL_RUN");
	
	m_motel_tv_broken = GetEnt( "m_motel_tv_broken", "targetname" );
	m_motel_tv_broken Hide();
	
//	wait 5;
//	level thread pool_guy1_death();	
//	level thread pool_guy2_death();

	level thread motel_fail_condition();
	
	trig_player_motel_door = GetEnt( "trig_player_motel_door", "targetname" );
	trig_player_motel_door trigger_off();
	
	run_scene_first_frame( "motel_chair" );
	run_scene_first_frame( "motel_door" );
	
	flag_wait( "trig_mason_to_motel" );
	
	run_scene( "motel_approach" );
	level thread run_scene( "motel_approach_loop" );
	
	flag_set( "mason_at_motel" );
	
	trig_player_motel_door trigger_on();
	trig_player_motel_door waittill( "trigger" );
	
	
	clean_up_enemy_ai();
	
	autosave_by_name( "motel" );
	
	level clientnotify( "mute_amb" );
	
	flag_set( "start_intro_anims" );
	
	level thread run_scene( "motel_door" );
	level thread run_scene( "motel_breach" );
	
	flag_wait( "motel_breach_started" );
	
	str_weapon_model = GetWeaponModel( "m16_sp" );
	m_player_body = get_model_or_models_from_scene( "motel_breach", "player_body" );
	m_player_body Attach( str_weapon_model, "tag_weapon" );
	
	scene_wait( "motel_breach" );
	
	flag_set( "motel_room_cleared" );
	
	level thread run_scene( "motel_chair" );
	run_scene( "motel_scene" );
	
	flag_set( "motel_scene_end" );
	
/////////////////////	
//	level thread mason_breach();
//	
//	level thread thug_1_breach(); //guy by table w/noriega
//	level thread thug_2_breach(); //guy sitting on couch, mason takes this guy out
//	level thread thug_3_breach(); //bathroom guy
//	level thread thug_4_breach(); //surprise guy, mason takes this guy out
//	
//	trig_player_motel_door = GetEnt( "trig_player_motel_door", "targetname" );
//	trig_player_motel_door trigger_off();
//	
//	flag_wait( "mason_at_motel" );
//	
//	autosave_by_name( "motel_pre_breach" );
//	
//	trig_player_motel_door trigger_on();	
//	trig_player_motel_door waittill( "trigger" );
//	
//	trig_player_motel_door Delete();
//	
//	m_motel_door_clip = GetEnt( "motel_door_clip", "targetname" );
//	m_motel_door_clip Delete();
//
//	level thread run_scene( "noriega_intro_loop" );
//	level thread run_scene( "player_breach_intro_loop" );
//	
//	level thread player_breach_button_press();
//	
//	flag_wait( "player_pull_pin" );
//	
//	level clientnotify( "mute_amb" );
//	
//	flag_set( "start_intro_anims" );
//	
//	level thread player_breach_fake_fire();
//	
//	run_scene( "player_breach_intro" );
//	
//	flag_set( "motel_room_cleared" );
//	
//	level thread run_scene_and_delete( "guys_breach_xcool" );
//	run_scene_and_delete( "player_breach_xcool" );
//	
//	clean_up_motel();
//	
//	flag_set( "motel_scene_end" );
}

clean_up_enemy_ai()
{
	enemies = GetAIArray("axis");
	for(i = 0; i < enemies.size; i++)
	{
		enemies[i] delete();
	}
	
}

gun_raise( m_player_body )
{
	m_player_body Hide();
	
	level.player EnableWeapons();
	level.player ShowViewModel();
	level.player DisableWeaponFire();
}

gun_lower( m_player_body )
{
	m_player_body Show();
	
	level.player DisableWeapons();
	level.player HideViewModel();
}

motel_vo_afghanistan( m_player_body )
{
	if ( level.player get_story_stat( "KRAVCHENKO_INTERROGATED" ) )
	{
		level.player say_dialog( "wood_remember_what_kravch_0" );
	}
}

motel_vo_nicaragua( ai_mason )
{
	if ( level.player get_story_stat( "FOUND_NICARAGUA_EASTEREGG" ) )
	{
		ai_mason say_dialog( "maso_there_was_the_cia_me_0" );
	}
}

next_mission( m_player_body )
{
	screen_fade_out( 0.5 );
	
	nextmission();
}

player_breach_fake_fire()
{
	//iprintlnbold( "starting fake fire func now" );
	
	while ( flag( "breach_gun_raised" ) )
	{
		//player waittill_any( "weapon_fired", "grenade_fire" );
		
		if ( level.player AttackButtonPressed() )
		{	
			//iprintlnbold( "fire" );
			level.player PlayRumbleOnEntity( "damage_heavy" );
			
			//play fx on weapon tag_flash on surprise guys gun
			PlayFXOnTag( getfx( "maginified_muzzle_flash" ), level.ai_thug_4, "tag_flash" );
		}

		wait 0.05;
	}	
}

set_breach_gun_raised( guy )
{
	flag_set( "breach_gun_raised" );
}

clear_breach_gun_raised( guy )
{
	flag_clear( "breach_gun_raised" );
}

motel_tv_swap( guy )
{
	m_motel_tv_pristine = GetEnt( "m_motel_tv_pristine", "targetname" );
	m_motel_tv_pristine Hide();
	
	m_motel_tv_broken = GetEnt( "m_motel_tv_broken", "targetname" );
	m_motel_tv_broken Show();
}

notetrack_motel_nextmission( guy )
{
	//set_screen_fade_timer( 0.05 );
	screen_fade_out( 0.05 );
	
	nextmission();
}

test_print( guy )
{
	//iprintlnbold( "notetrack hit" );
}

head_shot_bathroom_guy( guy )
{
	
}

player_breach_button_press()
{
	screen_message_create( &"PANAMA_MOTEL_BREACH" );
	
	while ( 1 )
	{
		if ( level.player UseButtonPressed() || level.player SecondaryOffhandButtonPressed() )
		{
			screen_message_delete();
			flag_set( "player_pull_pin" );
			
			level clientnotify( "aS_off" );
	
			break;
		}
		wait 0.05;
	}		
}

clean_up_motel()
{
//	end_scene( "player_breach_xcool" );
//	delete_scene( "player_breach_xcool" );
//	delete_ais_from_scene( "player_breach_xcool" );
//	
//	end_scene( "thug_1_death_loop" );
//	delete_scene( "thug_1_death_loop" );
//	delete_ais_from_scene( "thug_1_death_loop" );
//	
//	end_scene( "thug_2_death_loop" );
//	delete_scene( "thug_2_death_loop" );
//	delete_ais_from_scene( "thug_2_death_loop" );
//	
//	end_scene( "thug_3_death_loop" );
//	delete_scene( "thug_3_death_loop" );	
//	delete_ais_from_scene( "thug_3_death_loop" );
//	
//	end_scene( "thug_4_death_loop" );
//	delete_scene( "thug_4_death_loop" );		
//	delete_ais_from_scene( "thug_4_death_loop" );
	
	airfield_gump_vehicles = GetEntArray( "airfield_gump_vehicles", "script_noteworthy" );
	foreach( vehicle in airfield_gump_vehicles )
	{
		if ( IsDefined( vehicle ) )
		{
			vehicle Delete();
		}
	}
}

motel_fade_out()
{
	set_screen_fade_timer( 2 );	
	screen_fade_out();	
}

open_motel_door()
{
	m_motel_door = GetEnt( "motel_door", "targetname" );
	m_motel_door RotateYaw( 120, 0.3, 0.3, 0 ); 		
	
	//setmusicstate("PANAMA_NORIEGA");
	
	PlayFx( getfx( "door_breach" ), m_motel_door.origin );		
}

mason_breach()
{
	flag_wait( "trig_mason_to_motel" );

	//run_scene( "mason_door_approach" );
	level.mason.goalradius = 32;
	nd_motel_door = GetNode( "nd_motel_door", "targetname" );
	level.mason SetGoalNode( nd_motel_door );
	level.mason waittill( "goal" );

	//TODO: Mason Nag Lines here, end on player using trigger
	
	level thread run_scene( "mason_door_loop" );
	
	flag_set( "mason_at_motel" );
}

motel_fail_condition()
{
	trig_motel_fail = GetEnt( "trig_motel_fail", "targetname" );
	trig_motel_fail trigger_off();	
	
	flag_wait( "trig_mason_to_motel" );
	
	trig_motel_fail trigger_on();
	trig_motel_fail waittill( "trigger" );
	
	SetDvar( "ui_deadquote", &"PANAMA_HANGAR_FAIL" );

	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();	
}

thug_1_breach()
{
	flag_wait( "start_intro_anims" );
	
	ai_thug_1 = simple_spawn_single( "thug_1" );
	ai_thug_1.animname = "thug_1";
	
	run_scene( "thug_1_intro" );
	
	ai_thug_1 Die();
	
	//level thread run_scene( "thug_1_death_loop" );
}

thug_2_breach()
{
	flag_wait( "start_intro_anims" );
	
	ai_thug_2 = simple_spawn_single( "thug_2" );
	ai_thug_2.animname = "thug_2";
	ai_thug_2 set_ignoreall( true );
	
	run_scene( "thug_2_intro" );

	run_scene( "thug_2_shot" );

	level thread run_scene( "thug_2_death_loop" );
}

thug_3_breach()
{
	flag_wait( "start_intro_anims" );
	
	ai_thug_3 = simple_spawn_single( "thug_3" );
	ai_thug_3.animname = "thug_3";
	
	run_scene( "thug_3_intro" );
	
	level thread run_scene( "thug_3_death_loop" );
}

thug_4_breach()
{
	flag_wait( "start_intro_anims" );
	
	level.ai_thug_4 = simple_spawn_single( "thug_4" );
	level.ai_thug_4.animname = "thug_4";
	
	run_scene( "thug_4_intro" );	
	
	level thread run_scene( "thug_4_death_loop" );
}