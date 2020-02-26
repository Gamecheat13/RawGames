#include common_scripts\utility;
#include maps\_utility;
#include maps\la_utility;
#include maps\_scene;
#include maps\_vehicle;
#include maps\_dialog;
#include maps\_objectives;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
AUTOEXEC
-------------------------------------------------------------------------------------------*/
autoexec event_funcs()
{
	if ( !level.createFX_enabled )
	{
		add_spawn_function_group( "low_road_choke_group2_rpg", "script_noteworthy", ::low_road_first_rpg );
		add_spawn_function_ai_group( "low_road_snipers", ::spawn_func_low_road_sniper );
		//add_spawn_function_group( "g20_group1_guy1", "targetname", ::spawn_func_friendly_sniped );
		add_spawn_function_group( "low_road_launcher_spawner", "targetname", ::spawn_func_launcher );
		add_spawn_function_group( "g20_group1_ss1", "script_noteworthy", ::g20_group1_ss1 );
		
		//add_spawn_function_veh( "g20_group1_cougar", ::player_cougar );
		add_spawn_function_veh( "g20_group1_cougar2", ::g20_cougar );
	}
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_sniper_rappel()
{
	init_heroes( array( "harper", "hillary", "bill", "jones", "ss1" ) );
	start_teleport( "skipto_sniper_rappel", "squad" );
}

skipto_g20()
{
	level.harper	= init_hero( "harper",	::harper_think );
	level.hillary	= init_hero( "hillary",	::hillary_think );
	level.bill		= init_hero( "bill",	::bill_think );
	level.jones		= init_hero( "jones",	::jones_think );
	level.ss1		= init_hero( "ss1",		::ss1_think );
	
	start_teleport( "skipto_g20_group1", "squad" );
	
	get_player_cougar();
	
	spawn_vehicle_from_targetname( "g20_group1_cougar2" );
	spawn_vehicles_from_targetname( "low_road_vehicles" );
	
	simple_spawn( "g20_group1_ss" );
	
	kill_spawnernum( 101 );
	flag_set( "rappel_option" );
	
	flag_set( "low_road_choke_group2_cleared" );
	flag_set( "low_road_snipers_cleared" );
	flag_set( "start_last_stand" );
	
	level thread cover_convoy();

	a_av_allies_spawner_targetnames = array( "f35_fast" );
	a_av_axis_spawner_targetnames = array( "avenger_fast" );
	
	level thread spawn_aerial_vehicles( 10, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
	
	level thread load_gump( "la_1_gump_1c" );
}

/* ------------------------------------------------------------------------------------------
MAIN
-------------------------------------------------------------------------------------------*/
main()
{
	//load_gump( "la_1_gump_1b" );
	
	spawn_vehicle_from_targetname( "g20_group1_cougar2" );
	spawn_vehicles_from_targetname( "low_road_vehicles" );
	
	level thread simple_spawn( "g20_group1_ss" );
	
	init_player_cougar();
	
	level.harper	= init_hero( "harper",	::harper_think );
	level.hillary	= init_hero( "hillary",	::hillary_think );
	level.bill		= init_hero( "bill",	::bill_think );
	level.jones		= init_hero( "jones",	::jones_think );
	level.ss1		= init_hero( "ss1",		::ss1_think );
	
	level thread remove_sight_blocker();
	level thread battle_flow();
	
	level thread autosave_by_name( "after_sam" );
	ClientNotify("dl");

	a_av_allies_spawner_targetnames = array( "f35_fast" );
	a_av_axis_spawner_targetnames = array( "avenger_fast" );
	
	level thread spawn_aerial_vehicles( 10, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
	
	level thread regroup();
	
	spawn_manager_enable( "sm_g20_attackers" );
	
	flag_wait( "player_reached_sniper_rappel" );
	level thread attack_convoy();
	
	level.player say_dialog( "harper_h_sitrep_002" );
	level.harper say_dialog( "the_president_is_s_003" );
	level.player say_dialog( "ready_up_h_we_have_004" );
	level.harper say_dialog( "that_may_be_a_prob_005" );
	level.player say_dialog( "the_president_is_o_006" );
	level.harper say_dialog( "yeah__well_h_wer_007" );
	level.player say_dialog( "okay_the_air_fo_008" );
	level.harper say_dialog( "whats_the_call_s_001" );
	level.player say_dialog( "their_vehicles_are_002" );
	level.player say_dialog( "we_need_to_get_dow_003" );
	
	level thread sniper_rappel_options();
	
	// Goes to last_stand_main()
}

regroup()
{
	level endon( "rappel_option" );
	level endon( "sniper_option" );
	
	run_scene_first_frame( "squad_rappel_approach" );
	set_objective( level.OBJ_REGROUP, level.harper, "regroup" );
	
	flag_wait( "player_reached_sniper_rappel" );
	
	run_scene_and_delete( "squad_rappel_approach" );
	run_scene_and_delete( "squad_rappel_cover" );
}

init_player_cougar()
{
	veh = get_player_cougar();
	
	animation = %vehicles::v_la_03_12_meetconvoy_cougar_loop;
	
	s_align = get_struct( "cougar_entrance" );
	//veh.origin = GetStartOrigin( s_align.origin, (0, 0, 0), animation );
	//veh.angles = GetStartAngles( s_align.origin, (0, 0, 0), animation );
}

g20_group1_ss1()
{
	level.ai_g20_ss1 = self;
}

remove_sight_blocker()
{
	flag_wait_any( "rappel_option", "sniper_option" );
	m_blocker = GetEnt( "sniper_rappel_sight_blocker", "targetname" );
	m_blocker Delete();
}

last_stand_main()
{
	init_player_cougar();
	
	level.harper = init_hero( "harper" );
	
	trigger_wait( "start_last_stand" );
	
	level thread help_kill_dudes();
	
	level.harper thread say_dialog( "we_got_rpgs_on_the_003", 4 );
	level.player thread say_dialog( "take_cover_by_the_010", 3 );
	level.player thread say_dialog( "keep_them_off_the_007", 6 );
	
	set_objective( level.OBJ_POTUS, undefined, "done" );
	
	spawn_manager_enable( "sm_low_road_launcher" );
	
	waittill_ai_group_cleared( "low_road_last_stand" );
	
	array_thread( GetAIArray( "axis" ), ::bloody_death );
	
	level.harper thread say_dialog( "clear_006" );
	
	flag_wait( "la_1_gump_1c" );
	
	level thread g20_group_meetup();
	
	wait 8; // waits until Harper finishes talking to g20 guy
	
	enter_cougar();
	freeway_cleanup();
	
	set_objective( level.OBJ_DRIVE );
	
	spawn_manager_kill( "sm_g20_attackers" );
}

last_stand_green_light()
{
	init_player_cougar();
	level.harper = init_hero( "harper" );
	
	spawn_manager_enable( "sm_low_road_launcher" );
	
	level thread fade_from_black( 2 );
	
	flag_wait( "la_1_gump_1c" );
	
	level thread g20_group_meetup();
	
	wait 8; // waits until Harper finishes talking to g20 guy
	
	enter_cougar();
	freeway_cleanup();
	
	set_objective( level.OBJ_DRIVE );
	
	spawn_manager_kill( "sm_g20_attackers" );
}

help_kill_dudes()
{
	level.ai_g20_ss1.perfectaim = true;
	level.harper.perfectaim = true;
	
	wait 20;
	
	level.ai_g20_ss1.perfectaim = false;
	level.harper.perfectaim = false;
}

spawn_func_launcher()
{
	self endon( "death" );
	self waittill( "goal" );
	
	veh_player_cougar = GetEnt( "g20_group1_cougar2", "targetname" );
	
	while ( !flag( "g20_group1_dead" ) )
	{
		self thread shoot_at_target( veh_player_cougar, undefined, 10, -1 );
		self waittill( "shoot" );
		wait 2;
	}
	
	stop_shoot_at_target();
}

freeway_cleanup()
{
	//array_func( GetAIArray( "axis" ), ::self_delete );
	
	cleanup_array( level.heroes );
	cleanup( level.ai_g20_ss1 );
	
	// delete all drones to make sure we have room for civ cars on freeway durring drive
	
	level notify( "spawn_aerial_vehicles" ); // stop additional planes from spawning
	
	a_vehicles = GetVehicleArray();
	foreach ( veh in a_vehicles )
	{
		if ( IsSubStr( veh.model, "drone" ) || IsSubStr( veh.model, "f35" ) )
		{
			VEHICLE_DELETE( veh );
		}
	}
}

enter_cougar()
{
	autosave_by_name( "drive" );
	
	set_objective( level.OBJ_HIGHWAY, undefined, "done" );
	set_objective( level.OBJ_DRIVE, level.veh_player_cougar GetTagOrigin( "tag_player" ), &"LA_SHARED_OBJ_DRIVE" );
	get_player_cougar() Attach( "veh_t6_mil_cougar_interior_obj", "tag_body_animate_jnt" );
	
	ENTER_DIST = 100 * 100;
	
	v_tag_pos = level.veh_player_cougar GetTagOrigin( "tag_enter_driver" );
	v_tag_ang = level.veh_player_cougar GetTagAngles( "tag_enter_driver" );
	v_enter = AnglesToRight( v_tag_ang );
	
	b_entering = false;
	
	while ( !b_entering )
	{
		n_dist = Distance2DSquared( v_tag_pos, level.player.origin );
		if ( n_dist <= ENTER_DIST )
		{
			n_dot = VectorDot( v_enter, AnglesToForward( level.player.angles ) );
			if ( n_dot > .8 )
			{
				b_entering = true;
			}
		}
		
		wait .05;
	}
	

	level.player PlaySound ("evt_cougar_enter");
	
	get_player_cougar() Detach( "veh_t6_mil_cougar_interior_obj", "tag_body_animate_jnt" );
	
	level.veh_player_cougar SetAnim( %vehicles::v_la_03_12_entercougar_cougar, 1, 0, 1 );
	
	level.player thread say_dialog( "everyone_h_on_my_l_003" );
	run_scene_and_delete( "enter_cougar" );	
	flag_set( "player_in_cougar" );
}

low_road_first_rpg()
{
	self endon( "death" );
	
	if ( IsDefined( self.script_string ) )
	{
		self custom_ai_weapon_loadout( "rpg_magic_bullet_sp" );
		self waittill( "goal" );
		e_target = get_ent( self.script_string );
		self shoot_at_target( e_target );
		self.a.allow_shooting = false;
		self custom_ai_weapon_loadout( "rpg_sp" );
		wait 5;
		self.a.allow_shooting = true;
	}
}

spawn_func_low_road_sniper()
{
	self endon( "death" );
	trigger_wait( "tirg_player_approaches_convoy" );
	self Delete();
}

spawn_func_rappel()
{
	// Clear Goal Volumes when player chooses rappel option so the AI can move around wherever they need to
	self ClearGoalVolume();
}

harper_think()
{
	self endon( "death" );
	
	scene_wait( "squad_rappel" );
	run_scene_and_delete( "jack_low_road_van" );
}

hillary_think()
{
	self endon( "death" );
	
	CreateThreatBiasGroup( "potus_rushers" );
	
	CreateThreatBiasGroup( "potus" );
	self SetThreatBiasGroup( "potus" );
	
	self set_ignoreme( true );
	
	scene_wait( "group_cover_go1" );
	
	self set_ignoreme( false );
	self.allowdeath = true;
	
	self thread potus_fail();
	
	while ( true )
	{
		if ( IsGodMode( level.player ) )
		{
			self magic_bullet_shield();
		}
		else
		{
			self stop_magic_bullet_shield();
		}
		
		wait 1;
	}
}

potus_fail()
{
	level endon( "group_to_convoy_started" );
	self waittill( "death" );
	missionfailedwrapper( &"LA_SHARED_PROTECT_FAIL" );
}

bill_think()
{
	self endon( "death" );
	self set_ignoreme( true );
}

jones_think()
{
	self endon( "death" );
	self set_ignoreme( true );
}

ss1_think()
{
	self endon( "death" );
	flag_wait( "squad_rappel_done" );
	self stop_magic_bullet_shield();
}

battle_flow()
{
	set_ai_group_cleared_count( "low_road_choke_group1", 1 );
	set_ai_group_cleared_count( "low_road_choke_group2", 0 );
	
	str_option = level waittill_any_return( "sniper_option", "rappel_option" );
	
	array_thread( GetEntArray( "freeway_bigrig_entry_guys", "script_noteworthy" ), ::bloody_death );
	
	if ( str_option == "sniper_option" )
	{
		level.player thread maps\_dialog::say_dialog( "get_the_president_004" );
		level.player thread say_dialog( "protect_the_presid_001", 8 );
		
		trigger_use( "low_road_high_right" );
		//a_close_guys = get_ai_group_ai( "low_road_close_guys" );
		//array_thread( a_close_guys, ::bloody_death );
	}
	else
	{
		level.player thread maps\_dialog::say_dialog( "rappel_down__go_001" );
		level.player thread say_dialog( "protect_the_presid_001", 15 );
		
		trigger_use( "low_road_high_right_rappel" );
		
		//spawn_manager_enable( "sm_low_road_close_guys" );
		
		//level thread squad_kills_close_enemies();
		//level thread force_rappel();
	}
	
	delay_thread( 10, ::trigger_use, "low_road_move_up_1" );	// spawn RPG guys
	
	run_scene_and_delete( "squad_rappel" );
	flag_set( "squad_rappel_done" );
	
	level thread potus_cover();
	
	level.harper thread maps\_dialog::say_dialog( "take_out_those_dam_004", 6 );
	
	trigger_use( "veh_low_road_left_side" );
	
	delay_thread( 25, ::rush_potus );
	
	level thread autosave_by_name( "choke_1" );
	
//	if ( str_option == "sniper_option" )
//	{
//		waittill_ai_group_cleared( "low_road_high_right" );
//	}
	
	waittill_ai_group_cleared( "low_road_choke_group1" );
	
	trigger_use( "low_road_move_up_2" );
	trigger_use( "trig_left_side_sniper" );
	
	spawn_vehicle_from_targetname_and_drive( "sniper_van" );
	
	array_func( array( level.hillary, level.bill ), ::set_goal_to_current_pos );
	
	run_scene( "terrorist_rappel" );
	
	trigger_use( "low_road_move_up_3" );
	
	level thread push_through_vo();
		
	delay_thread( 25, ::rush_potus );
	
	level thread autosave_by_name( "choke_2" );
	
	waittill_ai_group_cleared( "low_road_choke_group2" );
	waittill_ai_group_cleared( "low_road_snipers" );
	
	flag_set( "low_road_move_up_4" );
	
	level.player say_dialog( "good_work_people_012" );
	level.harper say_dialog( "more_up_ahead_009", .5 );
	level.harper thread say_dialog( "everyone_h_get_to_013", 1 );
	
	level thread autosave_by_name( "low_road_cleared" );	
	set_objective( level.OBJ_POTUS, undefined, "delete" );
	
	wait 2;
	
	flag_set( "start_last_stand" );
}

push_through_vo()
{
	wait 4;
	
	if ( !flag( "low_road_choke_group2_cleared" ) )
	{
		level.player thread say_dialog( "push_through_they_004" );
	}
}

potus_cover()
{
	cover_1();
	flag_wait( "low_road_move_up_2" );
	cover_2();
	flag_wait( "low_road_move_up_3" );
	cover_3();
	flag_wait( "low_road_move_up_4" );
	cover_convoy();
	
	level thread load_gump( "la_1_gump_1c" );
}

cover_1()
{
	level.hillary.ignoreme = true;
	run_scene_and_delete( "group_cover_go1" );
	level thread run_scene_and_delete( "group_cover_idle1" );
	level.hillary.ignoreme = false;
	
	level.player thread maps\_dialog::say_dialog( "stay_in_cover_003" );
}

cover_2()
{
	level.hillary.ignoreme = true;
	level.harper say_dialog( "jones_you_ready_t_007" );
	level.harper thread say_dialog( "okay__go_008", .5 );
	
	run_scene_and_delete( "group_cover_go2" );
	level thread run_scene_and_delete( "group_cover_idle2" );
	level.hillary.ignoreme = false;
}

cover_3()
{
	level.hillary.ignoreme = true;
	level.harper say_dialog( "snipers__12_?o_c_005", 1 );
	level.player thread say_dialog( "stay_down_011", 1 );
	
	run_scene_and_delete( "group_cover_go3" );
	level thread run_scene_and_delete( "group_cover_idle3" );
	level.hillary.ignoreme = false;
	
	level thread cover_3_optional_vo();
}

cover_3_optional_vo()
{
	level endon( "low_road_choke_group2_cleared" );
	level.player say_dialog( "keep_covering_the_002", 1.5 );
}

cover_convoy()
{
	level.hillary.ignoreme = true;
	run_scene_and_delete( "group_to_convoy" );	
	level thread run_scene_and_delete( "group_convoy_loop" );
}

rush_potus()
{
	SetThreatBias( "potus", "potus_rushers", 90000 );
	
	a_rush_goal_nodes = GetNodeArray( "low_road_rush_node", "targetname" );
	nd_goal = getclosest( level.hillary.origin, a_rush_goal_nodes );
	
	a_enemies = get_rush_enemies();
	while ( a_enemies.size > 0 )
	{
		a_enemies = remove_dead_from_array( a_enemies );
		if ( a_enemies.size > 0 )
		{
			enemy = random( a_enemies );
			
			enemy ClearGoalVolume();
			enemy SetThreatBiasGroup( "potus_rushers" );
				
			enemy.goalradius = 500;
			enemy SetGoalNode( nd_goal );
				
			wait RandomFloatRange( 4, 4 + a_enemies.size * 2 );
		}
	}
}

get_rush_enemies()
{
	e_volume1 = level.goalVolumes[ "goal_volume_left_side" ];
	e_volume2 = level.goalVolumes[ "goal_volume_right_side" ];
	
	a_rush_enemies = [];
	a_enemies = GetAIArray( "axis" );
	foreach ( enemy in a_enemies )
	{
		if ( enemy IsTouching( e_volume1 ) || enemy IsTouching( e_volume2 ) )
		{
			a_rush_enemies[ a_rush_enemies.size ] = enemy;
		}
	}
	
	return a_rush_enemies;
}

g20_group_meetup()
{
	level endon( "player_in_cougar" );
	
	if ( !flag( "g20_group1_dead" ) )
	{
		level thread run_scene_and_delete( "g20_group1_greet" );
		
		level.veh_player_cougar SetAnim( %vehicles::v_la_03_12_meetconvoy_cougar, 1, 0, 1 ); // open the door for harper
		
		run_scene_and_delete( "g20_group1_greet_harper" );
		run_scene_and_delete( "harper_wait_in_cougar" );
	}
}

kill_g20_ss()
{
	if ( IsAlive( level.ai_g20_ss1 ) )
	{
		level.ai_g20_ss1 stop_magic_bullet_shield();
		level.ai_g20_ss1 bloody_death();
	}
}

sniper_rappel_options()
{
	set_objective( level.OBJ_REGROUP, undefined, "delete" );
	
	level thread rappel_option();
	level thread sniper_option();
	
	flag_wait_any( "rappel_option", "sniper_option" );
	
	set_objective( level.OBJ_SNIPE, undefined, "delete" );
	set_objective( level.OBJ_RAPPEL, undefined, "delete" );
	
	set_objective( level.OBJ_HIGHWAY );
	set_objective( level.OBJ_POTUS, level.hillary, "protect" );
}

//spawn_func_friendly_sniped()
//{
//	self endon( "death" );
//	flag_wait_any( "sniper_option", "rappel_option" );
//	wait 5;
//	run_scene( "friendly_sniped" );
//}

sniper_option()
{
	level endon( "rappel_option" );
	
	level.player waittill_player_has_sniper_weapon();
	
	s_sniper_obj = get_struct( "sniper_obj_org", "targetname", true );
	set_objective( level.OBJ_SNIPE, s_sniper_obj, &"LA_SHARED_OBJ_SNIPE" );
	
	//trigger_wait( "sniper_trigger" );
	sniper_trigger = GetEnt( "sniper_trigger", "targetname" );
	while( !level.player IsTouching( sniper_trigger ) || !level.player is_player_looking_at( sniper_trigger.origin + (0,0,20), 0.85 ))
	{
		wait(0.05);
	}
	
	flag_set( "sniper_option" );
	
	waittill_ai_group_cleared( "low_road_choke_group2" );
	waittill_ai_group_cleared( "low_road_snipers" );
	wait 2;
	
	s_fastrope_obj = get_struct( "sniper_fastrope_org", "targetname", true );
	set_objective( level.OBJ_RAPPEL2, s_fastrope_obj, "rappel" );
	
	//trigger_wait( "sniper_fastrope_trigger" );
	sniper_fastrope_trigger = GetEnt( "sniper_fastrope_trigger", "targetname" );
	while( !level.player IsTouching( sniper_fastrope_trigger ) || !level.player is_player_looking_at( sniper_fastrope_trigger.origin + (0,0,20), 0.85 ))
	{
		wait(0.05);
	}
	
	exploder( 311 ); // dust fall
	
	run_scene_and_delete( "player_fast_rope" );
	
	flag_set( "done_rappelling" );
	
	set_objective( level.OBJ_RAPPEL2, undefined, "delete" );
}

rappel_option()
{
	level endon( "sniper_option" );
	
	s_align = get_struct( "align_rappel", "targetname", true );
	s_align.angles = (0, 0, 0);
	
	trig_rappel = GetEnt( "rappel_trigger", "targetname" );
	set_objective( level.OBJ_RAPPEL, trig_rappel.origin, &"LA_SHARED_OBJ_RAPPEL" );
	
	//trigger_wait( "rappel_trigger" );
	//TODO: replace this with a real lookat trigger
	while( !level.player IsTouching( trig_rappel ) || !level.player is_player_looking_at( trig_rappel.origin + (0,0,20), 0.85 ))
	{
		wait(0.05);
	}
	
	flag_set( "rappel_option" );
	set_objective( level.OBJ_RAPPEL );
	
	level.player delay_thread( 3, ::switch_player_scene_to_delta );
	
	exploder( 310 ); // dust fall
	run_scene_and_delete( "player_rappel" );
	flag_set( "done_rappelling" );
}

switch_player_to_delta()
{
	wait 4;
	level.player switch_player_scene_to_delta();
}

attack_convoy()
{
	//level thread run_scene( "low_road_enemy_group1_loop" );
	level thread run_scene_and_delete( "freeway_bigrig_entry" );
	
	flag_wait_any( "sniper_option", "rappel_option" );
	
	//run_scene( "low_road_enemy_group1_react" );
}

g20_cougar()
{
	self.health = 5000;
	self.overrideVehicleDamage = ::g20_cougar_damage;
	
	self waittill( "death" );
	
	exploder( 205 );	// cougar explodes
	
	kill_g20_ss();
	
	flag_set( "g20_group1_dead" );
}

g20_cougar_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, damageFromUnderneath, modelIndex, partName )
{
	/#
		//IPrintln( "cougar took damage: " + sMeansOfDeath + " : " + self.health );
		#/
		
		if ( sMeansOfDeath == "MOD_PROJECTILE" )
	{
		return iDamage;
	}
	
	return 0;
}

return_true()
{
	return true;
}

squad_kills_close_enemies()
{
	a_squad_with_guns = array( level.harper, level.ss1 );
	trig_kill_zone = GetEnt( "trig_low_road_rappel_left_enemies", "targetname" );
	
	while ( !flag( "squad_rappel_done" ) )
	{
		a_enemies = trig_kill_zone get_ai_touching();
		
		if ( a_enemies.size > 0 )
		{
			foreach ( ai_squad in a_squad_with_guns )
			{
				ai_target = random( a_enemies );
				ai_squad thread rappel_fake_shoot( ai_target );
			}
		}
		
		wait 1;
	}
}

rappel_fake_shoot( ai_target )
{
	self endon( "death" );
	
	self notify( "rappel_fake_shoot" );
	self waittill( "rappel_fake_shoot" );
	
	level endon( "squad_rappel_done" );
	
	while ( IsAlive( ai_target ) )
	{
		v_offset = random_vector( 50 );
		v_start = self GetTagOrigin( "tag_flash" );
		if ( IsDefined( v_start ) )
		{
			MagicBullet( self.primaryweapon, v_start, ai_target.origin + v_offset, self );
		}
		
		wait .1;
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////
// CHALLENGES
/////////////////////////////////////////////////////////////////////////////////////////////
challenge_rescuefirst( str_notify )
{
	trigger_wait( "tirg_player_approaches_convoy" );
	
	if ( !flag( "g20_group1_dead" ) )
	{
		self notify( str_notify );
	}
}

challenge_snipekills( str_notify )
{
	level endon( "rappel_option" );
	flag_wait( "sniper_option" );
	
	add_global_spawn_function( "axis", ::snipekill_death_listener, str_notify );
	
	a_enemy_ai = GetAIArray( "axis" );
	array_thread( a_enemy_ai, ::snipekill_death_listener, str_notify );
	
	flag_wait( "done_rappelling" );
	
	remove_global_spawn_function( "axis", ::snipekill_death_listener );
}

snipekill_death_listener( str_notify )
{
	self waittill( "death", attacker );
	
	if ( IsPlayer( attacker ) && level.player player_has_sniper_weapon() )
	{
		level.player notify( str_notify );
	}
}
