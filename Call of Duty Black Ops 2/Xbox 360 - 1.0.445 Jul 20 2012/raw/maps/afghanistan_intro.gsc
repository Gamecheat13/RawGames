#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_vehicle;
#include maps\_objectives;
#include maps\_dialog;
#include maps\_horse;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


init_flags()
{
	flag_init( "e1_woods_arrived_at_wall" );
	flag_init( "e1_zhao_finished" );
	flag_init( "e1_woods_finished" );
	flag_init( "e1_begin_charge" );
}


skipto_intro()
{
	skipto_setup();
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/
main()
{
	exploder( 100 );	
		
	temp_move = get_struct( "special_delivery_start", "targetname", true );
	////temp_move.origin = ( -256, 400, -102 );
	
	init_flags();
	spawn_heroes();
	
	woods_zhao_trigger = getent( "wood_zhao_wait_canyon_wait_trigger", "targetname" );
	woods_zhao_trigger triggeroff();
	post_intro_blocker_trigger = getent( "post_intro_blocker_trigger", "script_noteworthy" );
	post_intro_blocker_trigger triggeroff();
	insta_fail_trigger = GetEnt( "e1_intro_insta_fail_trigger", "targetname" );
	insta_fail_trigger thread insta_fail_trigger();
	
	//TUEY - setting intro music
	setmusicstate("AFGHAN_INTRO");
	
	level thread too_far_fail_managment();
	
	e1_start();
}


spawn_heroes()
{
	woods = getent("woods", "targetname");
	woods add_spawn_function( ::set_horse_anim );
	level.woods = init_hero("woods");
	
	level.woods SetGoalPos( level.woods.origin );
	
	s_player_horse = getstruct( "horse_player_pos", "targetname" );
	
	level.mason_horse = spawn_vehicle_from_targetname( "mason_horse" );
	level.mason_horse.origin = s_player_horse.origin;
	level.mason_horse.angles = s_player_horse.angles;
	level.mason_horse MakeVehicleUnusable();
		
	level.woods.vh_my_horse = spawn_vehicle_from_targetname( "woods_horse" );
	level.woods.vh_my_horse.animname = "woods_horse";
	level.woods.vh_my_horse MakeVehicleUnusable();
	level.woods.vh_my_horse hide();
	
	wait 0.5;
	
	level.mason_horse Hide();
	
	s_player_horse structdelete();
	s_player_horse = undefined;	
}


/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/
e1_start()
{
	level thread spawn_horses();
	level thread spawn_far_loop_entities();
	level thread unhide_riders();
	level thread start_woods_horse();
		
	level.woods attach( "t5_weapon_static_binoculars", "tag_weapon1" );
	
	run_scene_first_frame("e1_player_wood_greeting");
	
	//level.woods thread spotlight_on_woods();
	
	flag_wait("starting final intro screen fadeout");
	
	level.player SetDepthOfField( 0, 10, 8000, 8000, 4, 0 );
	level.player SetViewModelDepthOfField( 0.5, 8 );

	level notify ( "fxanim_rappel_rope_start" );
	
	level thread run_scene( "e1_player_wood_greeting" );
	level thread run_scene( "e1_zhao_horse_approach_spread" );
		
	wrap_body = get_model_or_models_from_scene("e1_player_wood_greeting", "player_body");
	wrap_body setmodel("c_usa_mason_afgan_wrap_viewbody");
	wrap_body SetViewModelRenderFlag( true );
	
	scene_wait( "e1_player_wood_greeting" );
	
	level.woods detach( "t5_weapon_static_binoculars", "tag_weapon1" );
	
	level thread remove_woods_facemask_util();  //wait until scene is over before removing scarf
	
	level.player thread depth_of_field_off( .5 );
	
	rappel_rope = getent ("rappel_rope", "targetname");
	rappel_rope delete();
	
	//level play_woods_idle();
	
	//horse = GetEnt( "woods_horse", "targetname" );
	//horse MakeVehicleUnusable();
	
	//level thread play_far_loop();
	

	//wood_dest_node = getnode("e1_woods_wall_crouch", "targetname");
	//level.woods SetGoalNode(wood_dest_node);

	//obj_trigger = getent("e1_base_camp_obj_2_trigger", "targetname");
	//set_objective( level.OBJ_AFGHAN_BC2, obj_trigger);
	//flag_wait( "e1_woods_arrived_at_wall" );
	//trigger_wait_for_player_touch("e1_base_camp_obj_2_trigger");
	
	flag_set("e1_begin_charge");
	level.player EnableInvulnerability();
	//level thread end_far_loop();
	level thread run_scene( "e1_zhao_horse_charge_player" );
	m_body = get_model_or_models_from_scene( "e1_zhao_horse_charge_player", "player_body" );
	m_body attach ("t6_wpn_ar_ak47_world", "tag_weapon");	
		
	level thread run_scene( "e1_zhao_horse_charge_woods_intro" );
	
	//TUEY - setting the low wall music
	setmusicstate("AFGHAN_LOW_WALL");
		
	level thread manage_anim_timescale();
	
	level thread zhao_horse_charge();
	level thread horse_charge_muj1();
	level thread horse_charge_muj2();
	level thread horse_charge_muj3();
	level thread horse_charge_muj4();
	level.player SetStance( "stand" );
	//level thread run_scene("e1_horse_charge_muj_endloop");
	
	level thread wait_and_play_woods_end_idle();
	level thread wait_and_play_zhao_end_idle();
	
	//level waittill_any( "e1_zhao_finished", "e1_woods_finished" );
	scene_wait ( "e1_zhao_horse_charge_player" );
	
	autosave_by_name("e1_intro");
	
	level.mason_horse MakeVehicleUsable();
	level.player DisableInvulnerability();
	autosave_by_name("e1_horse_charge");
	level thread maps\afghanistan_horse_intro::play_ride_dialog();
	
	//level.player SetLowReady( true );
}


spotlight_on_woods()
{
	e_spotlight = spawn( "script_model", ( self GetTagOrigin( "tag_eye" ) ) +  (AnglesToForward( self GetTagAngles( "tag_eye" ) ) * 16 ) );
	e_spotlight.angles = ( self GetTagAngles( "tag_eye" ) ) * ( -1 );
	
	//e_spotlight SetModel( "t5_weapon_static_binoculars" );
	e_spotlight SetModel( "tag_origin" );
	
	e_spotlight LinkTo( self, "tag_eye" );
	
	PlayFXOnTag( level._effect[ "spotlight_intro" ], e_spotlight, "tag_origin" );
	
	scene_wait( "e1_player_wood_greeting" );
	
	e_spotlight Delete();
}


start_woods_horse()
{
	flag_wait( "start_woods_horse" );
	level.woods.vh_my_horse show();
	level thread run_scene( "e1_zhao_horse_charge_woods_horse_intro" );
}

zhao_horse_charge()
{
	level thread run_scene( "e1_zhao_horse_charge" );
}
horse_charge_muj1()
{
	level run_scene("e1_horse_charge_muj1");
	level thread run_scene("e1_horse_charge_muj1_endloop");
}

horse_charge_muj2()
{
	level run_scene("e1_horse_charge_muj2");
	level thread run_scene("e1_horse_charge_muj2_endloop");
}

horse_charge_muj3()
{
	level run_scene("e1_horse_charge_muj3");
	level thread run_scene("e1_horse_charge_muj3_endloop");
}

horse_charge_muj4()
{
	level run_scene("e1_horse_charge_muj4");
	level thread run_scene("e1_horse_charge_muj4_endloop");
}

/*play_far_loop()
{
	level endon("e1_begin_charge");
	level thread run_scene( "e1_zhao_horse_approach_far_loop" );
	wait 3;
	end_scene( "e1_zhao_horse_approach_far_loop" );
	level run_scene( "e1_zhao_horse_approach_spread" );
	level run_scene( "e1_zhao_horse_approach_spread_loop" );
}*/

/*end_far_loop()
{
	end_scene("e1_zhao_horse_approach_far_loop");
	end_scene("e1_zhao_horse_approach_spread");
	end_scene("e1_zhao_horse_approach_spread_loop");
}*/

wait_and_play_zhao_end_idle()
{
	level endon ( "player_mounted_horse");
	
	level scene_wait("e1_zhao_horse_charge");
	level notify( "e1_zhao_finished" );
	//level end_scene("e1_zhao_horse_charge");
	level thread run_scene( "e1_zhao_horse_charge_idle" );
}

wait_and_play_woods_end_idle()
{
	level endon ( "player_mounted_horse");
	
	level scene_wait("e1_zhao_horse_charge_woods_intro");
	level notify( "e1_woods_finished" );
	//level end_scene("e1_zhao_horse_charge_woods_intro");
	if ( isdefined( level.woods.vh_my_horse ) )
	{
		level thread run_scene( "e1_zhao_horse_charge_woods_intro_idle" );
	}
}

play_woods_idle()
{
	//level endon( "flag_e1_player_at_goal" );
	
	len = GetAnimLength( %generic_human::ch_af_01_01_intro_woods_start );
	wait( len - 29 );
	flag_set( "e1_woods_arrived_at_wall" );
	level thread run_scene("e1_player_wood_idle");	
}


spawn_horses()
{	
	zhao = getent( "zhao", "targetname" );
	zhao add_spawn_function( ::set_horse_anim );
	
	level.zhao = init_hero("zhao");
	level.zhao.vh_my_horse = spawn_vehicle_from_targetname( "zhao_approach_horse" );
	
	level.zhao.vh_my_horse.animname = "zhao_horse";
	level.zhao hide();
	level.zhao.vh_my_horse hide();
	
	level.zhao SetGoalPos( level.zhao.origin );
	
	horse_colors = [];
	horse_colors[ 0 ] = "anim_horse1_light_brown_fb";
	horse_colors[ 1 ] = "anim_horse1_brown_spots_fb";
	horse_colors[ 2 ] = "anim_horse1_brown_black_fb";
	horse_colors[ 3 ] = "anim_horse1_brown_black_fb";
	
	level.muj_horses = [];
	
	for ( i = 0; i < 4; i++ )
	{
		level.muj_horses[ i ] = spawn_vehicle_from_targetname( "horse_afghan" );
		level.muj_horses[ i ] setmodel( horse_colors[ i ] );
	}
		
	muj_spawner = getent("e1_zhao_horseman_spawner", "targetname");
	muj_spawner add_spawn_function( ::set_horse_anim );
	
	level.intro_horsemen = [];
	level.intro_horsemen[ level.intro_horsemen.size ] = simple_spawn_single("e1_zhao_horseman_spawner");
	level.intro_horsemen[ level.intro_horsemen.size ] = simple_spawn_single("e1_zhao_horseman_spawner");
	level.intro_horsemen[ level.intro_horsemen.size ] = simple_spawn_single("e1_zhao_horseman_spawner");
	level.intro_horsemen[ level.intro_horsemen.size ] = simple_spawn_single("e1_zhao_horseman_spawner");

	
	for(i = 0; i < level.muj_horses.size; i++)
	{
		//horsemen[i] enter_vehicle( level.muj_horses[i] );
		level.intro_horsemen[i].animname = "horse_muj_" + (i + 1);
		level.intro_horsemen[i] hide();
		level.muj_horses[i].animname = "muj_horse_" + (i + 1);
		level.muj_horses[i] hide();
	}
	
	level waittill("start_horse_event");
	
	for(i = 0; i < level.muj_horses.size; i++)
	{
		level.muj_horses[i].cleanup_time = "e3_clean_up";

	}

	horse_colors = undefined;
}


unhide_riders()
{
	flag_wait( "unhide_riders" );
	
	level.zhao show();
	level.zhao.vh_my_horse show();
	
	for(i = 0; i < level.muj_horses.size; i++)
	{
		level.intro_horsemen[i] show();
		level.muj_horses[i] show();
	}
}

spawn_far_loop_entities()
{
	muj_men = [];
	for(x = 0; x < 5;x++)
	{
		muj_men[x] = spawn_model( "c_usa_jungmar_assault_fb" );
		muj_men[x].animname = "muj_horse_" + x + 1;
		wait .05;
	}
	
	muj_horse = [];
	for(x = 0; x < 5;x++)
	{
		muj_horse[x] = spawn_model( "anim_horse1_fb" );
		muj_horse[x].animname = "horse_muj_" + x + 1;
		wait .05;
	}	
	
	flag_wait( "e1_begin_charge" );

	for(x = 0; x < muj_men.size;x++)
	{
		muj_men[x] delete();
	}
	
	for(x = 0; x < muj_horse.size;x++)
	{
		muj_horse[x] delete();
	}
	
	muj_men = undefined;
	muj_horse = undefined;
}

horse_jump( node_number )
{
	zhao_node = GetVehicleNode("e1_zhao_node", "targetname");
	self waittill("reached_end_node");
	
	if(self == level.zhao.vh_my_horse)
	{
		self go_path(zhao_node);
	}
	else
	{
		self go_path(level.muj_encircling_node[node_number]);
	}
	
}

set_horse_anim()
{
	self waittill( "enter_vehicle", vehicle );
	
	vehicle notify( "groupedanimevent", "ride" );
	
	self notify( "ride" );
	
	self maps\_horse_rider::ride_and_shoot( vehicle );
}

manage_anim_timescale()
{
	flag_wait("time_scale_horse");
	
	stop_exploder( 100 );
	//SetTimeScale(0.35);
	
	//--TODO: figure out if we really need this anim, if we do then it should be notetracked
	delay_thread( 0.6, ::manage_wall_fxanim );
	//flag_wait("time_scale_horse_end");
	
	//SetTimeScale(1.0);
	
	level.mason_horse Show();
}

manage_wall_fxanim()
{
	level notify("fxanim_horse_wall_break_start");
	exploder(10150);
}

send_player_horse()
{
	level.mason_horse AttachPath(GetVehicleNode("start_horse_path", "targetname"));
	level.mason_horse StartPath();
	level.mason_horse waittill("reached_end_node");
	level.mason_horse vehicle_detachfrompath();
}
