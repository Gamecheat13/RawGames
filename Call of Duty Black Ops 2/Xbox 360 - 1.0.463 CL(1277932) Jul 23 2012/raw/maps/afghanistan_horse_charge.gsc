#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_horse;
#include maps\_dialog;
#include maps\_turret;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


init_flags()
{
	flag_init("horse_charge_finished");
	flag_init("player_pushed_off_horse");
	flag_init( "second_base_visit" );
	flag_init( "kravchenko_time_scale_punch" );
	flag_init( "start_kravchenko_tank_earthquake" );
}


init_spawn_funcs()
{
	sp_rider_spawner = GetEnt( "extra_rider", "targetname" );
	sp_rider_spawner add_spawn_function( ::set_horse_anim );
}


skipto_horse_charge()
{
	skipto_setup();
	
	level.woods = init_hero("woods");
	level.zhao = init_hero("zhao");
	
	level.skip_to_charge_used = 1;
	
	skipto_cleanup();
	
	skipto_teleport( "skipto_horse_charge", level.heroes );
	
	remove_woods_facemask_util();
	
	flag_wait( "afghanistan_gump_arena" );
}


skipto_krav_tank()
{
	skipto_setup();
	
	level.woods = init_hero("woods");
	
	skipto_cleanup();
	level.player thread lerp_fov_overtime( 0.05, 65 );
	
	maps\afghanistan_anim::init_afghan_anims_part2();
		
	skipto_teleport( "skipto_horse_charge", level.heroes );
	
	remove_woods_facemask_util();
	
	flag_wait( "afghanistan_gump_arena" );
}


skipto_cleanup()
{
	delete_scene("intruder");
	delete_scene("intruder_box_and_mine");
	delete_scene("lockbreaker");
	delete_scene("e1_s1_pulwar");
	delete_scene("e1_s1_pulwar_single");
	delete_scene("e1_player_wood_greeting");
	
	delete_scene("e1_zhao_horse_charge_player");
	delete_scene("e1_zhao_horse_charge");
	//delete_scene("e1_horse_charge_muj_endloop");
	delete_scene("e1_horse_charge_muj1_endloop");
	delete_scene("e1_horse_charge_muj2_endloop");
	delete_scene("e1_horse_charge_muj3_endloop");
	delete_scene("e1_horse_charge_muj4_endloop");
	//delete_scene("e1_s5_vulture_shoot_woods");
	//delete_scene("e1_s5_vulture_shoot_zhao");
	
	delete_scene("e1_zhao_horse_charge_woods");
}


main()
{
	screen_fade_out( 2 );
	
	if ( IsDefined( level.mason_horse ) && level.player is_on_horseback() )
	{
		level.mason_horse use_horse( level.player );
		
		level.mason_horse waittill( "no_driver" );
		
		level.mason_horse MakeVehicleUnusable();
	}
	
	else if ( IsDefined( level.player.viewlockedentity ) )
	{
		level.player.viewlockedentity UseBy( level.player );
	}
	
	level thread maps\createart\afghanistan_art::turn_down_fog();
	maps\createart\afghanistan_art::open_area();
	
	maps\afghanistan_anim::init_afghan_anims_part2();
	
	// Old man woods video and VO //////////////////////////////////////
	level thread old_man_woods( "old_woods_1" );
	
	level.player thread say_dialog( "old_we_chased_those_fuck_0" );
	level.player thread say_dialog( "old_but_if_there_s_one_t_0", 2 );
	level.player thread say_dialog( "old_it_s_that_it_doesn_t_0", 4 );
		
	clean_up_tower_defense_section();
	
	autosave_by_name( "horse_charge" );
	
	level waittill( "movie_done" );
	
	level thread struct_cleanup_wave3();
	level thread struct_cleanup_blocking_done();
	
	level thread screen_fade_in( 4 );
	
	full_playthrough_set_up_charge();
}


/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/
clean_up_tower_defense_section()
{
	flag_set( "stop_arena_explosions" );
	
	if( IsDefined( level.horse_zhao ) && IsDefined( level.horse_zhao.rider ) )
	{
		level.zhao ai_ride_stop_riding();
		level.horse_zhao Delete();
	}
    
	level.player get_player_off_horse();
	
	axis_array = getaiarray( "axis" );
	
	array_delete ( axis_array );
	
	a_vh_cleanup = GetVehicleArray();
	
	foreach( vh_cleanup in a_vh_cleanup )
	{
		VEHICLE_DELETE( vh_cleanup );
	}
	
	corpses = GetEntArray( "script_vehicle_corpse", "classname" );
	
	array_delete(corpses);
}


get_player_off_horse()  //self = level.player
{
	if ( IsDefined( self.viewlockedentity ) )
	{
		horse = 	self.viewlockedentity;
		
		level clientNotify( "cease_aiming" );
		
		wait 0.1;
		
		horse.disable_mount_anim = true;
		horse maps\_horse::use_horse( self );
		horse waittill( "no_driver" );

		horse MakeVehicleUnusable();
		
		VEHICLE_DELETE( horse );
	}
}


delete_player_horse() // self = horse
{
	wait 0.25;
	
	if ( IsDefined( self ) )
	{
		VEHICLE_DELETE( self );
	}
}


full_playthrough_set_up_charge()
{
	level thread spawn_horse_charge();
		
	wait 0.05; // horses need 0.05 between being spawned and anything being done to them
	
	horse_charge_event();
}


set_horse_anim() // self = rider of the horse
{
	self endon("charge_done");
	
	self endon("death");
	self.ignoreme = true;
	while(1)
	{
		self waittill( "enter_vehicle", vehicle );
	 	vehicle notify( "groupedanimevent", "ride" );
	 	
	 	if(self != level.woods)
	 	{
	 		vehicle thread delete_dead_horse_after_charge();
	 	}
	 	
	 	self notify( "ride" );
		self maps\_horse_rider::ride_and_shoot( vehicle );
	}
}


#define BINOC_FADE_OUT 0.15
#define BINOC_FADE_IN 0.5
#define DEFAULT_FADE 2.0
#define BINOC_SCENE_TIME 5

horse_charge_line_up_event()
{
	level.player FreezeControls( false );
	level.player EnableInvulnerability();
	
	//TUEY - switch out the music
	level thread maps\_audio::switch_music_wait( "AFGHAN_BINOCULARS", 1 );
	
	self endon("charge_done");
	
	exploder(700); // exploder for the tank gas
	
	level thread run_scene( "e4_s1_return_base_lineup" );
	
	level thread horse_fidget_sounds();

	// give the binocs to the player for the scene
	body = get_model_or_models_from_scene("e4_s1_return_base_lineup", "player_body");
	body attach("viewmodel_binoculars", "tag_weapon1");
	n_anim_time = GetAnimLength( %player::p_af_04_01_return_base_player_lineup );
	
	//TODO: get a notetrack for when the binocular is in mason's hand
	wait(5);
	body setviewmodelrenderflag( true ); //-- keep the binoculars from clipping
	
	wait ( n_anim_time - 5 - BINOC_FADE_OUT );
	//scene_wait( "e4_s1_return_base_lineup" );
	
	screen_fade_out( BINOC_FADE_OUT );
	
	wait 0.75; // duration of the full blackness
	
	// turns on the overlay for the binocs
	level.player StartBinocs();
	level clientNotify( "binoc_on" );
	
	default_fov = getdvarfloat( "cg_fov" );
	
	// starts the tank and btrs
	level.krav_tank thread go_path();
	level.krav_tank thread stop_tank_at_end_node();
	level.charge_btrs[0] thread go_path();
	level.charge_btrs[1] thread go_path();
	
	level.player thread lerp_fov_overtime( 0.05, 23 );
	level.player thread lerp_dof_over_time( 2.0 );
			
	level thread screen_fade_in( BINOC_FADE_IN );
	
	level thread hind_hover();
	
	level thread run_scene( "e4_s1_binoc" ); // Start the scene before the fade is finished
	
	// Spawn running drones down the center that will be in front of the player, wont be able to see them spawning durring the binocs
	//maps\_drones::drones_start( "center_muj_drones_1" );
	
	wait 2; // timing for the tank to shoot gas as it comes over the hill
	
	level.krav_tank thread krav_tank_fire();
	
	wait 2; // timing for the tank as it moves over the hill and fires
	
	n_anim_time = GetAnimLength( %vehicles::v_af_04_03_through_binoculars_tank );
	wait ( n_anim_time - ( BINOC_FADE_OUT + 6) ); // timing for the tank to fall and displace gas when it does with exploder 710
	
	exploder(710);
	
	// start spawning muj drones on the side to ride past
	//maps\_drones::drones_start( "left_muj_drones_1" );
	
	wait 1.0; // timing to stop spawning drones down the center so they are not spawning in front of the player
	//maps\_drones::drones_delete( "center_muj_drones_1" );
	
	wait 0.9; // timing for the scene to finish
	
	screen_fade_out( BINOC_FADE_OUT );
	
	wait 0.25; // turn off the binocs overlay
	
	clientNotify( "binoc_off" );
	
	level.player StopBinocs();
	
	// fix the dof and fov from the last scene
	const Default_Near_Start = 0;
	const Default_Near_End = 1;
	const Default_Far_Start = 8000;
	const Default_Far_End = 10000;
	const Default_Near_Blur = 6;
	const Default_Far_Blur = 0;
	
	level.player SetDepthOfField( Default_Near_Start, Default_Near_End, Default_Far_Start, Default_Far_End, Default_Near_Blur, Default_Far_Blur );
	level.player thread lerp_fov_overtime( 0.05, default_fov );
	
	//-- Start next scene before the darkness finishes
	//level thread run_scene( "e4_s1_return_base_charge" );
	
	// makes the tank fire in the horse charge
	//level thread krav_tank_fire();
	
	VEHICLE_DELETE( level.woods.vh_horse );
	VEHICLE_DELETE( level.zhao.vh_horse );
	VEHICLE_DELETE( level.player.vh_horse );
	
	//TODO
	scene_wait( "e4_s1_binoc" );
	
	flag_clear( "end_arena_migs" );
	
	level thread maps\afghanistan_firehorse::migs_flyover_arena();
	level thread maps\afghanistan_firehorse::fire_guns_base();
	
	flag_set( "arena_overlook" ); // Make sure this is set to play ambient migs and gun fire
	
	get_player_on_horse();
	get_ai_on_horse();
	
	autosave_by_name( "start_charge" );
	
	wait 0.25; // fade wait time
	
	//TUEY - switch out the music
	level thread maps\_audio::switch_music_wait( "AFGHAN_HORSE_CHARGE", 3 );
	
	//level thread screen_fade_in( BINOC_FADE_IN );
	screen_fade_in( BINOC_FADE_IN );
	
	// hind pops out behind the rocks and starts firing
	//level thread handle_horse_charge_intro_hind();
	
	// hold until the scene finishes before you start the horse charge
	//scene_wait("e4_s1_return_base_charge");
}


// controls the tank firing
krav_tank_fire()
{
	level endon("horse_done");
	
	while( 1 )
	{
		level.krav_tank fire_turret( 0 );
		
		wait RandomFloatRange( 0.2, 0.3 );
		
		level.krav_tank fire_turret( 1 );
		
		wait RandomFloatRange( 0.1, 0.3 );
		
		level.krav_tank fire_turret( 2 );
		
		wait RandomFloatRange( 1.0, 2.0 );
	}
}


get_player_on_horse()
{
	//level.player EnableInvulnerability();
	
	s_mason_horse_spawnpt = getstruct( "mason_horse_charge_spawnpt", "targetname" );
	
	level.player.vh_horse = spawn_vehicle_from_targetname( "mason_horse" );
	level.player.vh_horse.origin = s_mason_horse_spawnpt.origin;
	level.player.vh_horse.angles = s_mason_horse_spawnpt.angles;
	level.player.vh_horse.disable_mount_anim = true;
	level.player.vh_horse.disable_make_useable = true;
	level.player.vh_horse veh_magic_bullet_shield( true );
	level.player.vh_horse SetBrake( true );
	level.player.vh_horse use_horse( level.player );
	level.player.vh_horse MakeVehicleUnusable();
	
	s_mason_horse_spawnpt structdelete();
	s_mason_horse_spawnpt = undefined;
}


get_ai_on_horse()
{
	self endon("charge_done");
	
	s_woods_horse_spawnpt = getstruct( "woods_horse_charge_spawnpt", "targetname" );
	s_zhao_horse_spawnpt = getstruct( "zhao_horse_charge_spawnpt", "targetname" );
	
	level.woods.vh_horse = spawn_vehicle_from_targetname( "woods_horse" );
	level.woods.vh_horse.origin = s_woods_horse_spawnpt.origin;
	level.woods.vh_horse.angles = s_woods_horse_spawnpt.angles;
	level.woods ai_horse_ride( level.woods.vh_horse );
	level.woods.vh_horse AttachPath( GetVehicleNode( "woods_horse_path", "targetname" ) );
	level.woods.vh_horse StartPath();
	level.woods.vh_horse SetSpeedImmediate( 0 );
	level.woods.vh_horse MakeVehicleUnusable();
	level.woods.vh_horse horse_panic();
	level.woods.vh_horse thread woods_after_charge();
	
	level.zhao.vh_horse = spawn_vehicle_from_targetname( "zhao_horse" );
	level.zhao.vh_horse.origin = s_zhao_horse_spawnpt.origin;
	level.zhao.vh_horse.angles = s_zhao_horse_spawnpt.angles;
	level.zhao ai_horse_ride( level.zhao.vh_horse );
	level.zhao.vh_horse AttachPath( GetVehicleNode( "zhao_horse_path", "targetname" ) );
	level.zhao.vh_horse StartPath();
	level.zhao.vh_horse SetSpeedImmediate( 0 );
	level.zhao.vh_horse MakeVehicleUnusable();
	level.zhao.vh_horse horse_panic();
	
//	level.woods thread set_horse_anim();
//	level.woods enter_vehicle(level.woods.vh_horse);
//	
//	level.zhao thread set_horse_anim();
//	level.zhao enter_vehicle(level.zhao.vh_horse);
//	
//	level.player.vh_horse.disable_mount_anim = true;
//	level.player.vh_horse.disable_make_useable = true;
//	level.player.vh_horse use_horse(level.player);
	
	level.player.ignoreme = false;
	level.zhao.ignoreme = false;
	level.woods.ignoreme = false;
	level.zhao.ignoreall = false;
	level.woods.ignoreall = false;
	
	level.zhao thread magic_bullet_shield();
	level.woods thread magic_bullet_shield();
	
	level.zhao.vh_horse thread veh_magic_bullet_shield( 1 );
	level.woods.vh_horse thread veh_magic_bullet_shield( 1 );
	
//	for(i = 0; i < level.muj_riders.size; i++)
//	{
//		level.muj_riders[i] enter_vehicle(level.muj_riders[i].vh_my_horse);
//		level.muj_riders[i].ignoreme = false;
//		level.muj_riders[i].ignoreall = false;
//	}
	
	// makes sure that woods and zhao don't die
	level thread give_zhao_and_woods_health();
	
	// makes the BTRs fire in the horse charge
	level.charge_btrs[0] thread btr_attack();
	level.charge_btrs[1] thread btr_attack();
	
	//level.player.vh_horse MakeVehicleUnusable();
	
	s_woods_horse_spawnpt structdelete();
	s_woods_horse_spawnpt = undefined;
	
	s_zhao_horse_spawnpt structdelete();
	s_zhao_horse_spawnpt = undefined;
}


woods_after_charge()
{
	self waittill( "reached_end_node" );
	
	if ( IsDefined( self get_driver() ) )
	{
		level.woods ai_dismount_horse( self );
	}	
}


give_zhao_and_woods_health()
{
	self endon("charge_done");
	
	while(1)
	{
		if( level.zhao.health < 1000 )
		{
			level.zhao.health += 2000;
		}
		
		if( level.woods.health < 1000 )
		{
			level.woods.health += 2000;
		}
		
		wait 0.1;
	}
}

// this is to control the hind that pops out behind the rocks
handle_horse_charge_intro_hind()
{
	self endon("charge_done");
	
	hind  = spawn_vehicle_from_targetname( "hind_soviet" );
	
	hind thread  go_path(GetVehicleNode("hind_attack_muj_path_start", "targetname"));

	hind_look_at = GetEnt("hind_look_at", "targetname");	
	
	// makes the hind strafe from out behind the rocks
	hind setLookAtEnt( hind_look_at );
	
	hind thread hind_strafe( );
	
	level waittill("stop_look_at");
	
	hind ClearLookAtEnt();
	
	hind waittill("reached_end_node");
	
	VEHICLE_DELETE( hind );
}


// spawns the horses that run up next to the player on the right
handle_horse_charge_extra_horses()
{	
	self endon("charge_done");
	
	level waittill("kill_horses");
	
	level.extra_muj_riders[0].vh_my_horse vehicle_go_path_on_node( "extra_horse_path_0" );
	level.extra_muj_riders[1].vh_my_horse vehicle_go_path_on_node( "extra_horse_path_1" );
	
	level.extra_muj_riders[0].vh_my_horse MakeVehicleUnusable();
	level.extra_muj_riders[1].vh_my_horse MakeVehicleUnusable();
	
	level waittill("start_2nd_set_of_extra_horses");
	
	rider1 = simple_spawn_single("extra_rider");
	rider2 = simple_spawn_single("extra_rider");
	
	horse1 = spawn_vehicle_from_targetname( "horse_afghan" );
	horse2 = spawn_vehicle_from_targetname( "horse_afghan" );
	
	rider1 enter_vehicle(horse1);
	rider2 enter_vehicle(horse2);
	
	horse1 MakeVehicleUnusable();
	horse2 MakeVehicleUnusable();
	
	horse1 vehicle_go_path_on_node( "extra_horse_path_2" );
	horse2 vehicle_go_path_on_node( "extra_horse_path_3" );
	
	level waittill("fire_rpg_at_btr");
	
	//level play_mortar_fx( "mortar_extra_horses_struct", "wpn_rocket_explode" );

	wait 0.1;
	if( IsAlive( horse1 ))
	{
		RadiusDamage(horse1.origin, 64, horse1.health * 2, horse1.health * 2);
	}
	if( IsAlive( horse2 ))
	{
		RadiusDamage(horse2.origin, 64, horse2.health * 2, horse2.health * 2);
	}
	
}


// has the horses that run next to the payer and woods on the left run and get blown up by mortars
handle_horse_charge_blow_up_horses()
{
	self endon("charge_done");
	
	level waittill( "start_blow_up_horses" );
	
	wait 2;
	
	ai_muj = GetEnt( "muj_rider_shot", "targetname" );
	

	if ( IsDefined( ai_muj ) )
	{
		ai_muj stop_magic_bullet_shield();
		
		wait 0.1;
		
		PlayFX( level._effect[ "sniper_impact" ], ai_muj GetTagOrigin( "J_Head" ) );
		
		ai_muj playsound ("evt_horse_death_1");
		
		ai_muj Die();
		
		wait 2;
		
		level.a_vh_horses[ 3 ] SetSpeed( 0, 10, 5 );
		
		wait 5;
		
		VEHICLE_DELETE( level.a_vh_horses[ 3 ] );
	}
	
//	level.extra_muj_riders[2].vh_my_horse MakeVehicleUnusable();
//	level.extra_muj_riders[3].vh_my_horse MakeVehicleUnusable();
//	
//	level.extra_muj_riders[2].vh_my_horse vehicle_go_path_on_node( "blow_up_horse_path_1" );
//	level.extra_muj_riders[3].vh_my_horse vehicle_go_path_on_node( "blow_up_horse_path_2" );
//	
//	horse1 = level.extra_muj_riders[2].vh_my_horse;
//	horse2 = level.extra_muj_riders[3].vh_my_horse;
	
	//level waittill("kill_horses");
	
	//play_mortar_fx( "blow_up_horse_morter", "exp_mortar" );
	
//	wait 0.1; // does the damage after the FX starts
//	
//	if( IsAlive( horse1 ))
//	{
//		RadiusDamage(horse1.origin, 64, horse1.health *2, horse1.health *2);
//	}
//	if( IsAlive( horse2 ))
//	{
//		RadiusDamage(horse2.origin, 64, horse2.health *2, horse2.health *2);
//	}
}


hind_hover()
{
	s_spawnpt = getstruct( "hind_hover_spawnpt", "targetname" );
	s_goal1 = getstruct( "hind_hover_goal1", "targetname" );
	s_goal2 = getstruct( "hind_hover_goal2", "targetname" );
		
	vh_hind = spawn_vehicle_from_targetname( "hind_soviet" );
	vh_hind.origin = s_spawnpt.origin;
	vh_hind.angles = s_spawnpt.angles;
	
	vh_hind SetForceNoCull();
			
	vh_hind SetNearGoalNotifyDist( 300 );
	vh_hind SetSpeed( 20, 15, 5 );
	
	vh_hind SetVehGoalPos( s_goal1.origin, 1 );
	vh_hind waittill_any( "goal", "near_goal" );
	
	wait 3;
	
	vh_hind SetSpeed( 50, 25, 15 );
	
	vh_hind SetVehGoalPos( s_goal2.origin, 0 );
	vh_hind waittill_any( "goal", "near_goal" );
	
	VEHICLE_DELETE( vh_hind );
	
	s_spawnpt structdelete();
	s_spawnpt = undefined;
	s_goal1 structdelete();
	s_goal1 = undefined;
	s_goal2 structdelete();
	s_goal2 = undefined;
}


fxanim_rock_slide()
{
	level waittill( "mig_fly_over" );
	
	wait 1;
	
	play_mortar_fx( "mortar_rock_slide", "exp_rocket_rocks"  );

	level notify( "fxanim_rock_slide_start" );	
}


hind_charge_shoot()
{
	level waittill( "rpg_shot_at_uaz" );
	
	s_spawnpt = getstruct( "hind_charge_spawnpt", "targetname" );
		
	vh_hind = spawn_vehicle_from_targetname( "hind_soviet" );
	vh_hind.origin = s_spawnpt.origin;
	vh_hind.angles = s_spawnpt.angles;
	
	vh_hind thread hind_charge_logic();
	
	s_spawnpt structdelete();
	s_spawnpt = undefined;
}


hind_charge_logic()
{
	self endon( "death" );
	
	self SetForceNoCull();
	Target_Set( self, ( -50, 0, -32 ) );
	
	s_goal1 = getstruct( "hind_charge_goal1", "targetname" );
	s_goal2 = getstruct( "hind_charge_goal2", "targetname" );
	s_goal3 = getstruct( "hind_charge_goal3", "targetname" );
	
	self SetNearGoalNotifyDist( 400 );
	self SetSpeed( 90, 50, 25 );
	
	self SetVehGoalPos( s_goal1.origin );
	self waittill_any( "goal", "near_goal" );
	self SetVehGoalPos( s_goal2.origin );
	self waittill_any( "goal", "near_goal" );
	
	s_stinger = getstruct( "hind_charge_stinger", "targetname" );
	
	MagicBullet( "afghanstinger_ff_sp", s_stinger.origin, self.origin + ( 0, 0, -20 ), undefined, self, ( 0, 0, -30 ) );
	
	self thread waitfordeath();
	
	self SetVehGoalPos( s_goal3.origin );
	self waittill_any( "goal", "near_goal" );
	
	VEHICLE_DELETE( self );
	
	s_goal1 structdelete();
	s_goal1 = undefined;
	s_goal2 structdelete();
	s_goal2 = undefined;
	s_goal3 structdelete();
	s_goal3 = undefined;
	s_stinger structdelete();
	s_stinger = undefined;
}
waitfordeath()
{
	self waittill( "death" );
	
	level.player playsound( "evt_horse_charge_heli_flyover" );
}

// Guy on the clif shoots an RPG at the UAZ that drives in the horse charge
handle_horse_charge_rpg_shot_at_uaz()
{
	self endon("charge_done");
	
	level waittill("rpg_shot_at_uaz");
	
	if( IsAlive( level.vh_before_charge_uaz ))
	{
		if ( IsDefined( level.ai_rpg_muj ) )
		{
			MagicBullet("rpg_magic_bullet_sp", (level.ai_rpg_muj.origin - (10,10,-60)), level.vh_before_charge_uaz.origin + (550,-50,0));
		}
	}
	
	wait 0.7; // time it takes for the uaz to be hit
	
	if( IsAlive( level.vh_before_charge_uaz ))
	{
		RadiusDamage(level.vh_before_charge_uaz.origin, 100, level.vh_before_charge_uaz.health *2, level.vh_before_charge_uaz.health *2);
	}
}


// plays the migs that fly over int he horse charge
handle_horse_charge_mig_fly_overs()
{
	level endon( "horse_charge_finished" );
	level endon( "end_arena_migs" );
	self endon("charge_done");
		
	level waittill("mig_fly_over");
	
	mig = level vehicle_go_path_on_node( "mig23_start", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	mig = level vehicle_go_path_on_node( "mig23_start_12", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	mig = level vehicle_go_path_on_node( "mig23_start_13", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	level waittill("mig_fly_over_2");
	
	mig = level vehicle_go_path_on_node( "horse_charge_mig_2_start", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	mig thread mig_gun_strafe();
}

// plays the hind that flys over the player and blows up the horses on the left
handle_horse_charge_hind()
{
	self endon( "charge_done" );

	level waittill( "start_hind" );
	
	level.vh_charge_hind = vehicle_go_path_on_node( "hind_start_node", "hind_soviet" );
	level.vh_charge_hind thread hind_fire_missiles();
	level.vh_charge_hind thread delete_vehicle_at_end_of_node();
}


hind_fire_missiles()
{
	self endon( "death" );
	
	while( 1 )
	{
		self fire_turret( 1 );
		
		wait RandomFloatRange( 0.3, 0.5 );
		
		self fire_turret( 2 );
		
		wait RandomFloatRange( 0.8, 1.2 );
	}
}


// plays the mortars in the horse charge
handle_horse_charge_mortars()
{
	self endon("charge_done");
	
//	horse1 = level.muj_riders[5].vh_my_horse;
		
	for(i = 1; i < 4; i++) // 1 == index to start at and 4 == index to stop at
	{
		level waittill("mig_morter_" + i);
		//level play_mortar_fx( "mortar_drop" + i + "_sec3", "exp_mortar" );

	}
	
	level waittill("mortar_4_explo");
	
	//level play_mortar_fx( "mortar_drop10_sec3", "wpn_rocket_explode" );

	
//	wait 0.25; // durration to wait for the horses to react to being blown up
//	if( IsAlive( horse1 ))
//	{
//		RadiusDamage(horse1.origin, 128, horse1.health *2, horse1.health *2);
//	}
	
	level waittill("mig_morter_4");
	
	//level play_mortar_fx( "mortar_drop4_sec3", "exp_mortar" );
}


// plays the horses that run up from the right infrot on the player before the player gets knocked off
handle_horse_charge_new_horses()
{	
	self endon("charge_done");
	
	level waittill( "release_new_horses" );
	
	a_s_horse_spawnpts = [];
	
	for ( i = 0; i < 3; i++ )
	{
		a_s_horse_spawnpts[ i ] = GetVehicleNode( "new_horse_node_" + i, "targetname" );
	}
	
	level.a_vh_newhorses = [];
	
	for ( i = 0; i < a_s_horse_spawnpts.size; i++ )
	{
		wait 0.05;
		
		level.a_vh_newhorses[ i ] = spawn_vehicle_from_targetname( "horse_afghan" );
		level.a_vh_newhorses[ i ].origin = a_s_horse_spawnpts[ i ].origin;
		level.a_vh_newhorses[ i ].angles = a_s_horse_spawnpts[ i ].angles;
		
		level.a_vh_newhorses[ i ] AttachPath( GetVehicleNode( "new_horse_node_" + i, "targetname" ) );
				
		level.a_vh_newhorses[ i ] MakeVehicleUnusable();
		level.a_vh_newhorses[ i ] horse_panic();
		level.a_vh_newhorses[ i ].ai_rider = get_muj_ai();
		
		if ( IsDefined( level.a_vh_newhorses[ i ].ai_rider ) )
		{
			level.a_vh_newhorses[ i ].ai_rider ai_horse_ride( level.a_vh_newhorses[ i ] );
		}
		
		level.a_vh_newhorses[ i ] StartPath();
			
		level.a_vh_newhorses[ i ] thread delete_vehicle_at_end_of_node();
	}
	
	cache5_dmg = GetEnt( "ammo_cache_arena_5_damaged", "targetname" );
	cache5_dest = GetEnt( "ammo_cache_arena_5_destroyed", "targetname" );

	level waittill( "mig_fly_over_2" );
	
	s_cache = getstruct( "cache5_explosion", "targetname" );
	
	PlayFX( level._effect[ "cache_dest" ], s_cache.origin );

	wait 0.1; // duration to wait for the horses to react to being blown up
	
	cache5_dest playsound ("evt_horse_death_2");
	
	if ( IsAlive( level.a_vh_newhorses[ 0 ] ) )
	{
		RadiusDamage( level.a_vh_newhorses[ 0 ].origin, 32, level.a_vh_newhorses[ 0 ].health *2, level.a_vh_newhorses[ 0 ].health *2 );
	}
	
	if ( IsAlive( level.a_vh_newhorses[ 1 ] ) )
	{
		RadiusDamage( level.a_vh_newhorses[ 1 ].origin, 32, level.a_vh_newhorses[ 1 ].health *2, level.a_vh_newhorses[ 1 ].health *2 );
		
		Earthquake( 0.3, 0.6, level.a_vh_newhorses[ 1 ].origin, 400 );
	}
	
	if ( IsAlive( level.a_vh_newhorses[ 2 ] ) )
	{
		RadiusDamage( level.a_vh_newhorses[ 2 ].origin, 32, level.a_vh_newhorses[ 2 ].health *2, level.a_vh_newhorses[ 2 ].health *2 );
	}
	
	s_cache structdelete();
	s_cache = undefined;
}


// shoots an RPG that flys past the player and hits the BTR 
handle_horse_charge_rpg_shot_at_btr()
{
	self endon( "charge_done" );
	
	level waittill( "fire_rpg_at_btr" );
	
	if ( IsAlive( level.charge_btrs[ 0 ] ) )
	{
		fire_magic_bullet_rpg( "fire_magic_rpg_at_btr", level.charge_btrs[ 0 ].origin, ( 0,0, 50 ) );
	}
	
	play_mortar_fx( "mortar_left_explosion", "exp_mortar" );

	playsoundatposition ("evt_horse_death_3", (2416, -11355, -50) );
	
	s_exp = getstruct( "mortar_left_explosion", "targetname" );
	
	RadiusDamage( s_exp.origin, 500, 2500, 2000 );
	
	s_exp structdelete();
	s_exp = undefined;
}


// handles the player getting knocked off the horse durring the horse charge
handle_horse_charge_ending()
{
	self endon("charge_done");
	
	level.player.vh_horse waittill("reached_end_node");
	
	// tells the function giving woods and zhao health so they don't die that the horse charge is done
	level notify("horse_done");
	
	level.player.body notify( "stop_dust" );
	
	// makes sure that the horse when getting off doesn't enable the player to use weapons durring animation
	level.player.vh_horse.disable_weapon_changes = true;
	
	if( IsAlive( level.charge_btrs[0] ) )
	{
		level.charge_btrs[0] notify( "stop_attack" );
	}
	
	if( IsAlive( level.charge_btrs[1] ) )
	{
		level.charge_btrs[1] notify( "stop_attack" );
	}
	
	// plays the effect that kills the horse
	s_blow_up_horse_loc = level play_mortar_fx( "blow_up_horse" );
	level.player playsound ("evt_horsecharge_imp");
	level.player playsound ("evt_plr_horse_death");
	
	wait 0.1; // time to wait for the player to react to the explosion
	Earthquake( 0.7, 2, s_blow_up_horse_loc.origin, 800 );
	
	s_blow_up_horse_loc = undefined;
	
	level.player shellshock( "afghan_horsefall", 10);
	level.player dodamage(level.player.health - 1, level.player.origin);

	// gets the player off the horse instantly and makes sure thet player doesnt get a use option, also hides the horse
	level.player.vh_horse use_horse(level.player);
	level.player.vh_horse MakeVehicleUnusable();
	level.player DisableWeapons();
	level.player.vh_horse Hide();
	
	delete_ents( level.CONTENTS_CORPSE, level.player.body.origin, 1000 );
	
	level thread run_scene_first_frame( "e4_s5_tank_path_horsepush" );
	level run_scene( "e4_s5_player_horse_fall" );
	
	level notify("horse_fallen");
	
	level thread run_scene("e4_s5_tank_path_horsepush");
	level thread run_scene("e4_s5_player_horse_pushloop");
	
	level thread handle_horse_charge_push_off_migs_and_mortars();
	
	VEHICLE_DELETE( level.player.vh_horse );

	if( level.console )
		screen_message_create(&"AFGHANISTAN_PUSH_OFF_HORSE");
	else
		screen_message_create(&"AFGHANISTAN_PUSH_OFF_HORSE_MOUSE");
	
	push_horse_off_logic();
}



// plays the migs and mortars that happen while you're pushing off the horse
handle_horse_charge_push_off_migs_and_mortars()
{
	level endon( "horse_charge_finished" );
	level endon( "end_arena_migs" );
	self endon("charge_done");
	
	mig = level vehicle_go_path_on_node( "mig23_start", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	mig = level vehicle_go_path_on_node( "mig23_start_12", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	mig = level vehicle_go_path_on_node( "mig23_start_13", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	
	wait 2;
	
	s_mortar_drop = level play_mortar_fx( "push_off_mortars_1","exp_mortar" );
	
	wait 0.1;
	
	Earthquake( 0.4, 1, s_mortar_drop.origin, 800 );
	
	wait 0.15;
	
	s_mortar_drop = undefined;

	s_mortar_drop = level play_mortar_fx( "push_off_mortars_2","exp_mortar" );

	
	wait 0.1;
		
	Earthquake( 0.4, 1, s_mortar_drop.origin, 800 );
	
	s_mortar_drop = undefined;
}


// calls all the functions for the horse charge event
horse_charge_event()
{	
	horse_charge_line_up_event();
	
	start_horse_charge_vehicles();
		
	//TODO
	//level thread handle_horse_charge_extra_horses();
	level thread fxanim_rock_slide();
	level thread hind_charge_shoot();
	level thread handle_horse_charge_mig_fly_overs();
	level thread handle_horse_charge_blow_up_horses();
	level thread handle_horse_charge_hind();
	level thread handle_horse_charge_mortars();
	level thread handle_horse_charge_rpg_shot_at_btr();
	level thread handle_horse_charge_rpg_shot_at_uaz();
	level thread handle_horse_charge_new_horses();
	
	handle_horse_charge_ending();
}

// cleans up the charge so animations after work properly
clean_up_charge()
{
	self endon("charge_done");
	
	screen_message_delete();
	
	level.kravchenko = init_hero( "kravchenko" );
	
	if (  level.skipto_point != "krav_tank" )
	{
		for( i = 0; i < 6; i++ )
		{
			if ( IsDefined( level.a_vh_horses[ i ] ) )
			{
				VEHICLE_DELETE( level.a_vh_horses[ i ] );
				
				if ( IsDefined( level.a_vh_horses[ i ].ai_rider ) )
				{
					level.a_vh_horses[ i ].ai_rider delete();
				}
			}
		}
	
		if ( IsDefined( level.vh_charge_hind ) )
		{
			VEHICLE_DELETE( level.vh_charge_hind );
		}
	}
}

// stop the tank so it doesn't get too far down it's path durring the charge
stop_tank_at_end_node()
{
	self endon("charge_done");
	
	self waittill("tank_pause_pos");
	self notify( "tank_stop_attack" );
	
	self SetSpeed(0, 1);
	self SetCanDamage(false);
	
	level waittill("horse_fallen");
	self ResumeSpeed(3);
	self SetCanDamage(true);
}

// handles pushing off the horse mechanic
push_horse_off_logic()  // blocking call; success/failure conditions evaluated here also
{
	self endon("charge_done");
		
	b_success = false;
	
	const n_timer_max = 5.5;
	n_time_remaining = n_timer_max;
	const n_check_time = 0.05;
	n_pushed_counter = 0; // counter variable; almost a frame counter
	const n_pushing_hard = 1.90; // max = 2.0
	const n_pushing_normal = 1.2;  // max = 2.0
	const n_pushing_weak = 0.6;  // max = 2.0
	
	// set up sounds
	vox_ent = spawn("script_origin", level.player.origin);
	vox_ent thread play_push_vox();
	level thread fake_mortar_sounds();	
	
	// set up anims
	anim_horse_push_loop = level.scr_anim[ "prop_horse" ][ "e4_s5_horse_horse_push_loop" ];
	anim_player_push_loop = level.scr_anim[ "player_body" ][ "e4_s5_player_horse_push_loop" ];
	anim_horse_push = level.scr_anim[ "prop_horse" ][ "e4_s5_horse_horse_push" ];
	anim_player_push = level.scr_anim[ "player_body" ][ "e4_s5_player_horse_push" ];
	
	n_push_time_total = GetAnimLength( anim_player_push );
	n_push_frames_total = n_push_time_total * 20;
	
	// get models since they exist already
	m_player_hands = get_model_or_models_from_scene( "e4_s5_player_horse_pushloop", "player_body" );
	m_horse = get_model_or_models_from_scene( "e4_s5_player_horse_pushloop", "prop_horse" );
	
	while ( ( n_time_remaining > 0 ) && !b_success )
	{
		n_push_strength = level.player _get_horse_push_strength();
		
		// pushing hard
		if ( n_push_strength > n_pushing_hard )
		{
			n_pushed_counter += 1.00;
			n_playback_rate = 1.00;
			vox_ent notify ("plr_pushing");
		}
		else if ( ( n_push_strength > n_pushing_normal ) && ( n_push_strength < n_pushing_hard ) )
		{
			// pushing medium
			n_pushed_counter += 0.8;
			n_playback_rate = 1.0;
		}
		else if ( ( n_push_strength > n_pushing_weak ) && ( n_push_strength < n_pushing_normal ) )
		{
			// pushing weak, don't increment... decrement!
			n_pushed_counter -= 1;
			n_playback_rate = 1.0;
		}
		else 
		{		
			// if not pushing, drop fast
			n_pushed_counter -= 10;			
			n_playback_rate = 1.0;
			vox_ent notify ("plr_stopped");
		}
		
		// cap at zero
		if ( n_pushed_counter < 0 )
		{
			n_pushed_counter = 0;
		}		

		n_weight_push = clamp( ( n_pushed_counter / n_push_frames_total ), 0, 1 );
		n_weight_idle = clamp( ( 1 - n_weight_push ), 0, 1 );
		
		m_player_hands SetAnim( anim_player_push, n_weight_push, n_check_time, n_playback_rate );
		m_horse SetAnim( anim_horse_push, n_weight_push, n_check_time, n_playback_rate );
		
		m_player_hands SetAnim( anim_player_push_loop, n_weight_idle, n_check_time, n_playback_rate );
		m_horse SetAnim( anim_horse_push_loop, n_weight_idle, n_check_time, n_playback_rate );
		
	//	iprintln( n_pushed_counter + " / " + n_push_frames_total );
		
		if ( n_pushed_counter > n_push_frames_total )
		{
			b_success = true;
		}
			
		n_time_remaining -= n_check_time;
		wait n_check_time;
	}
	
	// success/failure conditons
	if ( b_success )
	{
		level thread play_sound_vox_push_last( vox_ent );
		
		flag_set("player_pushed_off_horse");
		
		end_scene("e4_s5_player_horse_pushloop");		
		delay_thread( 6.75, ::_delete_pushed_horse, m_horse );  // delete horse; switch to notetrack if possible
		run_scene( "e4_s5_player_horse_push_success" );
		
		autosave_by_name( "horse_pushoff" );
	}
	else 
	{
		vox_ent stoploopsound (.4);
		vox_ent playsound("vox_push_fail");

		screen_message_delete();  // remove hint prompt since we've failed
		
		// force arms down for failure condition
		n_weight_idle = 1;
		const n_drop_time = 1;
		
		// clear hand anims to allow drop
		m_player_hands ClearAnim( anim_player_push, n_drop_time );
		m_horse ClearAnim( anim_horse_push, n_drop_time );
		
		// force idle position
		m_player_hands SetAnim( anim_player_push_loop, n_weight_idle, n_drop_time, n_playback_rate );
		m_horse SetAnim( anim_horse_push_loop, n_weight_idle, n_drop_time, n_playback_rate );
		
		wait 1;  // let hands drop before screen turns blurry
	
		missionfailed();
		
		wait 1;  // one second more and tank looks like it's hitting player, so fill screen with blood
		level.player DoDamage( 120, level.player.origin );  // make screen bloody since there's no fail anim right now		
		
		wait 5;	
	}
}

_delete_pushed_horse( m_horse )
{
	m_horse Delete();
}

_get_horse_push_strength()  // self = player
{	
	v_stick_left = self GetNormalizedMovement();
	v_stick_right = self GetNormalizedCameraMovement();
	c_stick_right_strength = 0;

	if( level.console )
		c_stick_right_strength = ( v_stick_right[ 0 ] );
	else
		if( v_stick_right[ 0 ] || v_stick_right[ 1 ] )
			c_stick_right_strength = 1;
	
	return ( ( v_stick_left[ 0 ] ) + ( c_stick_right_strength ) );
}

play_sound_vox_push_last( vox_ent )
{
	vox_ent stoploopsound (1);
	vox_ent playsound ("vox_push_last");
	wait(4);
	vox_ent delete();
}

play_push_vox()
{
	while(1)
	{
		self waittill("plr_pushing");
		self playloopsound ("vox_push_loop", .7);
		self waittill("plr_stopped");
		self stoploopsound(.4);
		self playsound ("vox_push_stop");
		wait (.05);
	}
}


fake_mortar_sounds()
{			
	wait(.2);
	playsoundatposition( "exp_mortar", (2988,-9207,-7));
	wait(1);
	playsoundatposition( "exp_mortar", (2004,-6118,142));
	wait(2.7);
	playsoundatposition( "exp_mortar", (3100,-8089,-10));
	wait(1.8);
	playsoundatposition( "exp_mortar", (2549,-7109,-11));
	wait(1.2);
	playsoundatposition( "exp_mortar", (1890,-8062,-20));
	wait(1);
	playsoundatposition( "exp_mortar", (1890,-5062,-20));
}


//-- NOTETRACK DRIVEN
tank_path_anims()
{
	flag_wait( "start_runtowoods_tank" );
	level thread run_scene( "e4_s5_tank_path_runtowoods" );
	
	flag_wait("start_tankbattle_tank");
	level thread run_scene( "e4_s5_tank_path_tankbattle" );
}


after_button_mash_scene()
{
	if (  level.skipto_point == "krav_tank" )
	{
		run_scene("e4_s5_player_horse_fall");
		
		level notify("horse_fallen");
		
		level thread run_scene("e4_s5_player_horse_pushloop");
		//level thread run_scene("e4_s5_tank_path_horsepush");
		
		//level thread handle_horse_charge_push_off_migs_and_mortars();
		
		//VEHICLE_DELETE(level.player.vh_horse);
	
		if( level.console )
			screen_message_create(&"AFGHANISTAN_PUSH_OFF_HORSE");
		else
			screen_message_create(&"AFGHANISTAN_PUSH_OFF_HORSE_MOUSE");
		
		push_horse_off_logic();
		
		level.krav_tank = getent( "krav_tank", "targetname" );
	}
	
	level thread clean_up_charge();
	
	level clientnotify( "strt_tf" );
	
	level thread run_scene( "e4_s6_player_grabs_on_tank" );
	level thread tank_path_anims(); //-- broken into multiple anims and driven by notetracks

	// makes sure any AI is not shooting the player while on the tank
	level.player.ignoreme = true;
	
	level.player thread lerp_fov_overtime( 0.05, 65 );
	
	//level handle_tank_climb_setup_horses();
	
	// spawns the btr on a skipto and tells it to go it's path
	if ( !isDefined( level.charge_btrs ) )
	{
		level.charge_btrs = spawn_vehicles_from_targetname( "horse_charge_btr" );
		level.charge_btrs[1] AttachPath(GetVehicleNode( "btr_skipto", "targetname" ) );
		level.charge_btrs[1] StartPath();
	}
	
	level thread handle_tank_earthquake();
	level thread handle_tank_roll_over_mortars();
	
	anim_length = GetAnimLength(%player::p_af_04_06_reunion_player_run2tank);
	wait anim_length - 3.5; // wait till the BTR is in view durring the animation to blow it up
	
	level thread fire_magic_bullet_rpg( "fire_magic_rpg_at_btr_2", level.charge_btrs[1].origin, (0,0,20) );
	
	ai_soviet = get_soviet_ai();
	
	if ( IsDefined( ai_soviet ) )
	{
		ai_soviet.animname = "soviet_guard";	
	}

	scene_wait( "e4_s6_player_grabs_on_tank" );
	
	level thread run_scene( "e4_s6_tank_fight" );
			
	level thread handle_punch_timescale();
	
	level.kravchenko.ignoreme = true; // make sure nothing is trying to kill Krav
	
	/// These functions need notetracks
	
	// Happens after 0.7 sec of e4_s6_tank_fight /////////////
	//level thread handle_tank_climb_setup_axis();
	//level thread handle_tank_fight_run_horses();  //these guys don't seem to exist
	level thread handle_tank_fight_run_migs();
	//////////////////////////////////////////////////////////

	// Happens after 3.7 sec of e4_s6_tank_fight /////////////
	level thread handle_tank_fight_mortars();
	//////////////////////////////////////////////////////////
	
	// Needs timing still
	level thread handle_pickup_btr_chase();
	
	// Happens after 9.85 sec of e4_s6_tank_fight ////////////
	level thread handle_tank_climb_hind(); 
	//////////////////////////////////////////////////////////
	
	// Happens after 11.15 sec of e4_s6_tank_fight ///////////
	level thread handle_tank_climb_migs_and_mortars();
	//level thread handle_krav_strangle_setup_horses();
	//////////////////////////////////////////////////////////
	
	anim_length = GetAnimLength(%player::p_af_04_06_reunion_player_tankfight);
	wait anim_length - 2;

	scene_wait( "e4_s6_tank_fight" );
	
	level clientnotify( "end_tf" );
	level clientnotify ( "tank_explode" );
	
	level.kravchenko unlink();
	level.player unlink();
	
	wait 0.1;
	
	level.player shellshock( "death", 5);
	
	// player gets launched and takes dmg
	level.player dodamage(50, level.player.origin);

	level thread run_scene("e4_s6_strangle");
	
	anim_length = GetAnimLength( %player::p_af_04_09_reunion_player_strangle );
		
	level thread handle_krav_tank_falling_out_of_the_world();
	level thread horses_after_krav_down();
	
	//TODO - get notetrack
	wait 1.8; // player lands and takes dmg
	
	level.player dodamage(50, level.player.origin);
	
	// show woods and his horse for final scene of horse charge
	
	//level.woods.vh_horse Show();
	//level.woods Show();
	
	//TODO - get notetrack
	wait anim_length - 13.8; // krav gets hit by woods
	
	level.player notify("stop_numbers");
	
	flag_set( "end_arena_migs" );
	
	level notify( "charge_done" );
	level notify( "stop_guns_base" );
	level notify( "stop_stingers_base" );
	
	flag_set( "horse_charge_finished" );
	
	autosave_by_name( "horse_charge_finished" );
	
	wait 10.75; // wait till right before animation finishes and start old man woods
	
	//level thread old_man_woods( "old_woods_1" );
	//level.player say_dialog("we_dragged_the_rot_001"); // temp
	
	// make sure the screen is black after old man woods
	level screen_fade_out( .3 );
	
	if( IsDefined(level.zhao) )
	{
		level.zhao Show();
	}
	
	end_scene("e4_s6_strangle");
	// delete left overs
	vehicle_array = GetEntArray("script_vehicle", "classname");
	for ( i = 0; i < vehicle_array.size; i++ )
	{
		if ( IsDefined( vehicle_array[ i ] ) )
		{
			VEHICLE_DELETE( vehicle_array[ i ] );
		}
	}
	
	wait .15;
	
	corpses = GetEntArray( "script_vehicle_corpse", "classname" );
	
	for ( i = 0; i < corpses.size; i++ )
	{
		if ( IsDefined( corpses[ i ] ) )
		{
			corpses[ i ] Delete();
		}
	}

	//level.player say_dialog("for_interrogation_002"); // temp
	wait .15;
	load_gump( "afghanistan_gump_ending" );
}
audioCutSound( guy )
{
	level clientnotify( "cut_tf" );
}

delete_rider_and_horse_at_end_of_node()
{
	self endon("death");
	self endon("delete");
	self endon("charge_done");
		
	self.vh_my_horse waittill("reached_end_node");
	
	VEHICLE_DELETE( self.vh_my_horse );
	
	self delete();
}


delete_vehicle_at_end_of_node()
{
	self endon( "death" );
		
	self waittill( "reached_end_node" );
	
	if ( IsDefined( self.riders[ 0 ] ) )
	{
		self.riders[ 0 ] Delete();
	}
	
	wait 0.1;
	
	VEHICLE_DELETE( self );
}


handle_krav_tank_falling_out_of_the_world()
{
	level endon("charge_done");
	scene_wait("e4_s6_strangle");
}


handle_tank_climb_setup_horses()
{
	level endon("charge_done");
	
	level.tank_climb_muj = [];
	
	for(i = 0; i < 4; i++)
	{
		level.tank_climb_muj[i] = simple_spawn_single("extra_rider");
		
		level.tank_climb_muj[i].vh_my_horse = spawn_vehicle_from_targetname( "horse_afghan" );
		level.tank_climb_muj[i] thread delete_rider_and_horse_at_end_of_node();
		
		level.tank_climb_muj[i] enter_vehicle(level.tank_climb_muj[i].vh_my_horse);
	}
}


handle_tank_climb_migs_and_mortars()
{
	level endon( "horse_charge_finished" );
	level endon( "end_arena_migs" );
	level endon("charge_done");
	
	wait 22.75; //11.15; 
	
	mig = level vehicle_go_path_on_node( "mig23_start", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	mig = level vehicle_go_path_on_node( "mig23_start_12", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	mig = level vehicle_go_path_on_node( "mig23_start_13", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	
	wait 1;
	level play_mortar_fx( "tank_climb_mortar_0","exp_mortar" );
	
	wait 0.3;
	level play_mortar_fx( "tank_climb_mortar_1","exp_mortar" );

	wait 0.2;
	level play_mortar_fx( "tank_climb_mortar_2","exp_mortar" );
}

handle_tank_climb_setup_axis()
{
	level endon("charge_done");
	
	wait 0.7;
	
	for( i = 0; i < 3; i++ )
	{
		axis = simple_spawn_single("russian_charging_base_spawner");
		axis_origin_struct = getstruct("tank_climb_axis_" + i, "targetname");
		vol = getent( "tank_climb_axis_volume", "targetname" );
		axis SetGoalVolumeAuto( vol );
		axis disable_tactical_walk();
		axis.ignoreme = true;
		axis forceteleport(axis_origin_struct.origin, axis_origin_struct.angles);
	}
	
	axis_origin = [];
		
	for( i = 0; i < 3; i++ )
	{
		axis_origin[ i ] = getstruct("tank_climb_axis_" + i, "targetname");
		axis_origin[ i ] structdelete();
		axis_origin[ i ] = undefined;
	}
}

handle_krav_strangle_setup_horses()
{
	level endon("charge_done");
	
	wait 11.15;
	
	level.krav_strangle_muj = [];
	
	for(i = 0; i < 16; i++)
	{
		level.krav_strangle_muj[i] = simple_spawn_single("extra_rider");
		
		level.krav_strangle_muj[i].vh_my_horse = spawn_vehicle_from_targetname( "horse_afghan" );
		level.krav_strangle_muj[i] thread delete_rider_and_horse_at_end_of_node();
		
		level.krav_strangle_muj[i] enter_vehicle(level.krav_strangle_muj[i].vh_my_horse);
	}
}

handle_tank_climb_hind()
{
	level endon("charge_done");
	
	wait 16.2;	//9.85;
	
	hind = spawn_vehicle_from_targetname( "hind_soviet" );
	hind thread go_path( GetVehicleNode("tank_climb_hind_path", "targetname") );
	
	level waittill("fire_rpgs_at_hind");
	
	for(i = 0; i < 3; i++)
	{
		level fire_magic_bullet_huey_rocket( "tank_climb_hind_rpg_" + i , hind.origin );
		wait 0.4;
	}
}

handle_tank_fight_mortars()
{
	level endon("charge_done");
	
	wait 3.7;
	
	s_mortar_drop = level play_mortar_fx( "push_off_mortars_3","exp_mortar" );
	//RadiusDamage(s_mortar_drop.origin, 512, 1000, 1000);
	
	wait 0.25;
	
	s_mortar_drop = undefined;
	
	s_mortar_drop = level play_mortar_fx( "push_off_mortars_4","exp_mortar" );
	//RadiusDamage(s_mortar_drop.origin, 512, 1000, 1000);
	
	s_mortar_drop = undefined;
}

handle_tank_fight_run_migs()
{
	level endon( "horse_charge_finished" );
	level endon( "end_arena_migs" );
	level endon("charge_done");
	
	wait 1; // 0.7
	
	mig = level vehicle_go_path_on_node( "mig23_start", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
		
	mig = level vehicle_go_path_on_node( "mig23_start_12", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
}

handle_tank_fight_run_horses()
{
	level endon("charge_done");
	
	wait 0.7;

	level.tank_climb_muj[0].vh_my_horse vehicle_go_path_on_node( "tank_climb_horse_path_0" );
	level.tank_climb_muj[1].vh_my_horse vehicle_go_path_on_node( "tank_climb_horse_path_1" );
	level.tank_climb_muj[2].vh_my_horse vehicle_go_path_on_node( "tank_climb_horse_path_2" );
	level.tank_climb_muj[3].vh_my_horse vehicle_go_path_on_node( "tank_climb_horse_path_3" );
}

handle_tank_strangle_run_horses()
{
	level endon("charge_done");
	
	level.krav_strangle_muj[0].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_0" );
	level.krav_strangle_muj[1].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_1" );
	level.krav_strangle_muj[2].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_2" );
	level.krav_strangle_muj[3].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_3" );
	level.krav_strangle_muj[4].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_4" );

	wait 4.5;


	level.krav_strangle_muj[5].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_5" );
	level.krav_strangle_muj[6].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_6" );
	level.krav_strangle_muj[7].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_7" );
	
	wait 1;

	level.krav_strangle_muj[8].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_8" );
	level.krav_strangle_muj[9].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_9" );
	level.krav_strangle_muj[10].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_10" );

	wait 6.5;

	level.krav_strangle_muj[11].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_11" );
	level.krav_strangle_muj[12].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_12" );
	level.krav_strangle_muj[13].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_13" );
	level.krav_strangle_muj[14].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_14" );
	level.krav_strangle_muj[15].vh_my_horse vehicle_go_path_on_node( "krav_stangle_horse_path_15" );
}

handle_tank_earthquake()
{
	level endon("charge_done");
	
	flag_wait("start_kravchenko_tank_earthquake");
	Earthquake( 0.3, 5, level.player.origin, 800 );
	
	
}

handle_pickup_btr_chase()
{
	wait 2;
	
	sp_rider = GetEnt( "muj_assault", "targetname" );
	
	pickup_1 = vehicle_go_path_on_node( "pick_up_btr_path_1", "truck_afghan" );
	pickup_1 thread delete_vehicle_at_end_of_node();
	pickup_1.driver = sp_rider spawn_ai( true );
	pickup_1.driver.script_startingposition = 0;
	pickup_1.driver enter_vehicle( pickup_1 );
	
	wait 0.25;
	
	pickup_1.gunner = sp_rider spawn_ai( true );
	pickup_1.gunner.script_startingposition = 2;
	pickup_1.gunner enter_vehicle( pickup_1 );
	
	pickup_2 = vehicle_go_path_on_node( "pick_up_btr_path_2", "truck_afghan" );
	pickup_2 thread delete_vehicle_at_end_of_node();
	pickup_2.driver = sp_rider spawn_ai( true );
	pickup_2.driver.script_startingposition = 0;
	pickup_2.driver enter_vehicle( pickup_2 );
	
	wait 0.1;
	
	pickup_2.gunner = sp_rider spawn_ai( true );
	pickup_2.gunner.script_startingposition = 2;
	pickup_2.gunner enter_vehicle( pickup_2 );
	
	wait 1.2;
	
	btr = vehicle_go_path_on_node( "pick_up_btr_path_1", "btr_soviet" );
	btr thread delete_vehicle_at_end_of_node();
	
	wait 1;
	
	btr thread btr_chase_logic( pickup_1 );
	
	pickup_1 thread truck_chase_logic( btr );
	pickup_2 thread truck_chase_logic( btr );
}

truck_chase_logic( vh_btr )
{
	self endon( "death" );

	wait 0.5;
	
	//vh_btr = getent( "btr_chaser", "targetname" );
	
	if ( IsAlive( vh_btr ) )
	{
		self set_turret_target( vh_btr, ( 0, -100, -32 ), 1 );
		self shoot_turret_at_target( vh_btr, 7, ( 0, 0, 0 ), 1 );
	}
}

btr_chase_logic( pickup_1 )
{
	self endon( "death" );
	
	wait 1.5;
	
	//vh_truck = GetEntArray( "run_away_pickup", "targetname" );
	
	if ( IsAlive( pickup_1 ) )
	{
		self set_turret_target( pickup_1, ( 0, 0, 0 ), 1 );
		self shoot_turret_at_target( pickup_1, 7, ( 0, 0, 0 ), 1 );
	}
}

handle_punch_timescale()
{
	level endon("charge_done");
	
	flag_wait("kravchenko_time_scale_punch");
	level clientnotify ( "punch_timescale_on" );
	SetTimeScale(0.15); // .35
	
	level.player play_fx( "numbers_base", level.player.origin, level.player.angles, "stop_numbers", true);
	level.player play_fx( "numbers_center", level.player.origin, level.player.angles, "stop_numbers", true);
	level.player play_fx( "numbers_mid", level.player.origin, level.player.angles, "stop_numbers", true);
	
	level.player thread say_dialog("dragovich_kravche_005");
	
	timescale_tween(0.15, 1.0, 2.0);
	level clientnotify ( "punch_timescale_off" );
	wait(3);
}

handle_numbers( m_player_body )
{
	level endon("charge_done");
	
	level.player play_fx( "tank_numbers_base", level.player.origin, level.player.angles, "stop_numbers", true);
	level.player play_fx( "tank_numbers_center", level.player.origin, level.player.angles, "stop_numbers", true);
	level.player play_fx( "tank_numbers_mid", level.player.origin, level.player.angles, "stop_numbers", true);
	
	level.player thread say_dialog("dragovich_kravche_005");
	
	level.player thread playNumbersAudio();
}


playNumbersAudio()
{
	self endon( "stop_numbers" );
	
	a = 0;
	b = 0;
	c = 0;
	
	while(1)
	{
		a = randomintrange( -250, 250 );
		b = randomintrange( -250, 250 );
		c = randomintrange( -250, 250 );
		playsoundatposition( "evt_numbers_flux", self.origin + (a,b,c) );
		
		wait(randomfloatrange(1,3));
	}
}


handle_tank_explosion( m_player_body )
{
	// FX for the tank exploding
	krav_tank = get_model_or_models_from_scene( "e4_s5_tank_path_tankbattle", "krav_tank" );

	krav_tank play_fx( "fx_afgh_explo_krav_tank", krav_tank GetTagOrigin( "tag_origin" ), krav_tank GetTagAngles( "tag_origin" ), undefined, false, undefined, true );
	
	krav_tank play_fx( "krav_tank_fire", krav_tank GetTagOrigin( "tag_origin" ), krav_tank GetTagAngles( "tag_origin" ), undefined, false, undefined, true );
}


handle_tank_roll_over_mortars()
{
	level endon( "horse_charge_finished" );
	level endon( "end_arena_migs" );
	level endon("charge_done");
	
	wait 7;
	
	mig = level vehicle_go_path_on_node( "mig23_start", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	mig = level vehicle_go_path_on_node( "mig23_start_12", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	mig = level vehicle_go_path_on_node( "mig23_start_13", "mig23_spawner" );
	mig thread delete_vehicle_at_end_of_node();
	mig setanim( %vehicles::veh_anim_mig23_wings_open, 1, 0, 1);
	
	wait 1.5;
	
	for( i = 1; i < 7; i++)
	{
		level play_mortar_fx( "roll_over mortar_" + i,"exp_mortar" );
		
		wait( RandomFloatRange( 0.5, 0.7) );
	}
}


delete_dead_horse_after_charge()
{
	level endon("charge_done");
	
	self endon("delete");
	self waittill("death");
	
	if( IsDefined( self ) )
	{
		wait 5;
		
		if( IsDefined( self ) )
		{
			VEHICLE_DELETE( self );
		}
	}
}


horse_fidget_sounds()
{
	horse_fidget_1 = spawn ( "script_origin" , (11429, -9734, 239));
	horse_fidget_2 = spawn ( "script_origin" , (11462, -9398, 254));
	
	horse_fidget_1 PlayLoopSound ( "evt_horse_fidget_00" );
	horse_fidget_2 PlayLoopSound ( "evt_horse_fidget_01" );
	
	wait(200);
		
	horse_fidget_1 delete();
	horse_fidget_2 delete();
}


spawn_horse_charge()
{
	level.charge_btrs = spawn_vehicles_from_targetname("horse_charge_btr");
		
	level.krav_tank = spawn_vehicle_from_targetname("krav_tank");
	level.krav_tank SetCanDamage(false);
	level.krav_tank thread detach_from_path();
	
	level.vh_before_charge_uaz = spawn_vehicle_from_targetname( "uaz_soviet" );
	level.ai_rpg_muj = simple_spawn_single("rpg_muj");
	
	level.ai_rpg_muj.ignoreme = true;
	level.ai_rpg_muj.ignoreall = true;
	
	level.woods.vh_horse = spawn_vehicle_from_targetname( "woods_horse" );
	level.zhao.vh_horse = spawn_vehicle_from_targetname( "zhao_horse" );
	level.player.vh_horse = spawn_rideable_horse( "mason_horse" );
	
	a_s_horse_spawnpts = [];
	
	for ( i = 0; i < 6; i++ )
	{
		a_s_horse_spawnpts[ i ] = getstruct( "muj_horse_charge_spawnpt" + i, "targetname" );
	}
	
	level.a_vh_horses = [];
	
	for ( i = 0; i < a_s_horse_spawnpts.size; i++ )
	{
		wait 0.05;
		
		level.a_vh_horses[ i ] = spawn_vehicle_from_targetname( "horse_afghan" );
		level.a_vh_horses[ i ].origin = a_s_horse_spawnpts[ i ].origin;
		level.a_vh_horses[ i ].angles = a_s_horse_spawnpts[ i ].angles;
				
		level.a_vh_horses[ i ] MakeVehicleUnusable();
		level.a_vh_horses[ i ] horse_panic();
		level.a_vh_horses[ i ].ai_rider = get_muj_ai();
		
		if ( IsDefined( level.a_vh_horses[ i ].ai_rider ) )
		{
			level.a_vh_horses[ i ].ai_rider ai_horse_ride( level.a_vh_horses[ i ] );
		}
		
		level.a_vh_horses[ i ] thread go_path( GetVehicleNode( "horse_path_" + i, "targetname" ) );
		
		if ( i >= 3 )
		{
			level.a_vh_horses[ i ] thread walk_into_position( i );
			
			if ( i == 3 )
			{
				level.a_vh_horses[ i ] veh_magic_bullet_shield( true );
				level.a_vh_horses[ i ].ai_rider.targetname = "muj_rider_shot";
				level.a_vh_horses[ i ].ai_rider magic_bullet_shield();
			}
			
			if ( i == 5 )
			{
				level.a_vh_horses[ i ] thread additional_walkin_horses();
			}
		}
		
		else
		{
			level.a_vh_horses[ i ] SetSpeedImmediate( 0 );
		}
		
		level.a_vh_horses[ i ] thread delete_vehicle_at_end_of_node();
	}
	
	for ( i = 0; i < 6; i++ )
	{
		a_s_horse_spawnpts[ i ] structdelete();
		a_s_horse_spawnpts[ i ] = undefined;
	}
}


walk_into_position( i )
{
	self endon( "death" );
	
	nd_wait = GetVehicleNode( "path_wait" + i, "targetname" );
	nd_wait waittill( "trigger" );
	
	self SetSpeedImmediate( 0 );
}


additional_walkin_horses()
{
	self endon( "death" );
	
	wait 1.5;
	
	level.a_vh_walkin_horses = [];
	
	n_offset = -44;
	
	nd_spawnpt = GetVehicleNode( "horse_path_5", "targetname" );
	
	for ( i = 1; i < 3; i++ )
	{
		wait 0.05;
		
		level.a_vh_walkin_horses[ i ] = spawn_vehicle_from_targetname( "horse_afghan" );
		level.a_vh_walkin_horses[ i ].origin = nd_spawnpt.origin + ( 0, i * n_offset, 0 );
		level.a_vh_walkin_horses[ i ].angles = nd_spawnpt.angles;
		
		level.a_vh_walkin_horses[ i ] MakeVehicleUnusable();
		level.a_vh_walkin_horses[ i ] horse_panic();
		level.a_vh_walkin_horses[ i ].ai_rider = get_muj_ai();
		
		if ( IsDefined( level.a_vh_walkin_horses[ i ].ai_rider ) )
		{
			level.a_vh_walkin_horses[ i ].ai_rider ai_horse_ride( level.a_vh_walkin_horses[ i ] );
		}
		
		level.a_vh_walkin_horses[ i ] thread horse_walk_lineup();
	}
}


horse_walk_lineup()
{
	self endon( "death" );
	
	self SetSpeed( 2, 1, 0.5 );
	
	self SetVehGoalPos( self.origin + ( RandomIntRange( -265, -240 ), 0, 0 ), 1 );
	
	level waittill( "mig_fly_over" );
	
	if ( IsDefined( self.riders[ 0 ] ) )
	{
		self.riders[ 0 ] Delete();
	}
	
	wait 0.1;
	
	VEHICLE_DELETE( self );
}


detach_from_path()
{
	flag_wait( "e4_s5_player_horse_fall_started" );
	
	self vehicle_detachfrompath();	
}


start_horse_charge_vehicles()
{
	level.woods SetCanDamage( false );
	level.zhao SetCanDamage( false );
	
//	while( !level.player UseButtonPressed() )
//	{
//		wait 0.05;	
//	}
	
	wait 0.5;
	
	level.player.vh_horse thread player_start_charge();

		
	level.woods.vh_horse thread ai_start_charge();
	level.zhao.vh_horse thread ai_start_charge();
	
	for ( i = 0; i < level.a_vh_horses.size; i++ )
	{
		level.a_vh_horses[ i ] thread ai_start_charge();
	}
	
	level thread supplemental_horses_go();
	level thread extra_horses_left();
	level thread charge_ambient_explosions();
	
	level.charge_btrs[ 0 ] thread btr_attack();
	level.charge_btrs[ 1 ] thread btr_attack();
}


charge_ambient_explosions()
{
	wait 3.5;
	
	play_mortar_fx( "charge_ambient_explosion0", "exp_mortar" );
	
	wait 1.5;
	
	play_mortar_fx( "charge_ambient_explosion1", "exp_mortar" );
	
	level waittill( "start_hind" );
	
	play_mortar_fx( "charge_ambient_explosion4", "exp_mortar" );
	
	level waittill( "release_new_horses" );
	
	play_mortar_fx( "charge_ambient_explosion5", "exp_mortar" );
	
	level waittill( "start_2nd_set_of_extra_horses" );
	
	play_mortar_fx( "charge_ambient_explosion2", "exp_mortar" );
	
	wait 0.5;
	
	play_mortar_fx( "charge_ambient_explosion3", "exp_mortar" );
}


player_start_charge()
{
	level.player.vh_horse SetBrake( false );
	//level.player.vh_horse thread horse_strafe_controls();
	level.player.vh_horse horse_rearback();
	
	//wait 2.6;
	level.player playsound ("evt_horse_charge");
	level.player.vh_horse thread vehicle_go_path_on_node( "mason_horse_path" );
	
	tag_origin = level.player.body GetTagOrigin( "tag_camera" );
	tag_angles =  level.player.body GetTagAngles( "tag_camera" );
	
	level.player.body play_fx( "fx_afgh_horse_charge_clouds", tag_origin - (36,0,0), tag_angles, "stop_dust", true, "tag_camera");
}


#define STRAFE_AIM_FREE_LOOK 1	
#define MPH_TO_INCHES_PER_SEC 17.6
#define STRAFE_DT 0.05
#define STRAFE_CLAMP_Y 50
#define STRAFE_CLAMP_Z 0
#define STRAFE_MAX_VEL 15
#define STRAFE_ACCEL 2
	
horse_strafe_controls()
{
	level endon( "horse_fallen" );
	
	offset = ( 0, 0, 0 );
	strafe_vel = ( 0, 0, 0 );
	max_strafe_vel = ( 0, STRAFE_MAX_VEL * MPH_TO_INCHES_PER_SEC, STRAFE_MAX_VEL * MPH_TO_INCHES_PER_SEC );
	
	while ( 1 )
	{
		stick = level.player GetNormalizedMovement();
		
		// Get strafe velocity
		desired_vel_y = ( Abs( offset[1] ) >= STRAFE_CLAMP_Y && ( offset[1] * stick[1] >= 0 ) ? 0 : stick[1] * max_strafe_vel[1] );
		desired_vel_z = ( Abs( offset[2] ) >= STRAFE_CLAMP_Z && ( offset[2] * stick[0] >= 0 ) ? 0 : stick[0] * max_strafe_vel[2] );
		
		strafe_vel_y = DiffTrack( desired_vel_y, strafe_vel[1], STRAFE_ACCEL, STRAFE_DT );
		strafe_vel_z = DiffTrack( desired_vel_z, strafe_vel[2], STRAFE_ACCEL, STRAFE_DT );
	
		strafe_vel = ( 0, strafe_vel_y, strafe_vel_z );

		if ( !STRAFE_AIM_FREE_LOOK )
		{
			a = AngleClamp180( level.player.angles[1] );
			path_a = self.pathlookpos - self.pathpos;
			path_a = vectoangles( path_a );
			
			delta = AngleClamp180( path_a - a );
			
			a = ( 0, delta, 0 );
			
			// Get Axis
			forward = AnglesToForward( a );
			right = AnglesToRight( a );
		
			v = forward * strafe_vel[2] - right * strafe_vel[1];
		}
		else
		{
			v = strafe_vel;
		}
		
		// Integrate velocity	
		offset += v * STRAFE_DT;
	
		// Set offset
		self PathFixedOffset( offset );			
		
		wait( STRAFE_DT );
	}
}


ai_start_charge()
{
	if ( self == level.woods.vh_horse )
	{
		wait 2.3;
	}
	
	else if ( self == level.zhao.vh_horse )
	{
		wait 2.6;
	}
	
	else
	{
		wait 2.75;
	}
	
	self ResumeSpeed( 5 );
}


supplemental_horses_go()
{
	n_animlength = GetAnimLength( level.horse_anims[level.REARBACK] );  //n_animlength = 2.6667
	
	wait ( n_animlength + 0.25 );
	
	a_s_spawnpts = [];
	
	for ( i = 0; i < 6; i++ )
	{
		a_s_spawnpts[ i ] = getstruct( "horse_supplement_spawnpt" + i, "targetname" );
	}
	
	level.a_vh_supphorses = [];
	
	for ( i = 0; i < a_s_spawnpts.size; i++ )
	{
		wait 0.05;
		
		level.a_vh_supphorses[ i ] = spawn_vehicle_from_targetname( "horse_afghan" );
		level.a_vh_supphorses[ i ].origin = a_s_spawnpts[ i ].origin;
		level.a_vh_supphorses[ i ].angles = a_s_spawnpts[ i ].angles;
		level.a_vh_supphorses[ i ] MakeVehicleUnusable();
		level.a_vh_supphorses[ i ] thread delete_vehicle_at_end_of_node();
		level.a_vh_supphorses[ i ].ai_rider = get_muj_ai();
				
		if ( IsDefined( level.a_vh_supphorses[ i ].ai_rider ) )
		{
			level.a_vh_supphorses[ i ].ai_rider ai_horse_ride( level.a_vh_supphorses[ i ] );
		}
		
		level.a_vh_supphorses[ i ] thread go_path( GetVehicleNode( "horse_suppath_" + i, "targetname" ) );
	}
	
	for ( i = 0; i < 6; i++ )
	{
		a_s_spawnpts[ i ] structdelete();
		a_s_spawnpts[ i ] = undefined;
	}
	
	level waittill( "release_new_horses" );
	
	wait 1;
	
	a_s_spawnpts = [];
	
	for ( i = 0; i < 4; i++ )
	{
		a_s_spawnpts[ i ] = GetVehicleNode( "left_horse_path_" + i, "targetname" );
	}
	
	level.a_vh_extrahorses = [];
	
	for ( i = 0; i < a_s_spawnpts.size; i++ )
	{
		wait 0.05;
		
		level.a_vh_extrahorses[ i ] = spawn_vehicle_from_targetname( "horse_afghan" );
		level.a_vh_extrahorses[ i ].origin = a_s_spawnpts[ i ].origin;
		level.a_vh_extrahorses[ i ].angles = a_s_spawnpts[ i ].angles;
		level.a_vh_extrahorses[ i ] MakeVehicleUnusable();
		level.a_vh_extrahorses[ i ] thread delete_vehicle_at_end_of_node();
		level.a_vh_extrahorses[ i ].ai_rider = get_muj_ai();
		
		if ( IsDefined( level.a_vh_extrahorses[ i ].ai_rider ) )
		{
			level.a_vh_extrahorses[ i ].ai_rider ai_horse_ride( level.a_vh_extrahorses[ i ] );
		}
		
		level.a_vh_extrahorses[ i ] thread go_path( GetVehicleNode( "left_horse_path_" + i, "targetname" ) );
	}
	
	wait 4.5;
	
	a_s_spawnpts = [];
	
	for ( i = 0; i < 5; i++ )
	{
		a_s_spawnpts[ i ] = GetVehicleNode( "last_horse_" + i, "targetname" );
	}
	
	level.a_vh_lasthorses = [];
	
	for ( i = 0; i < a_s_spawnpts.size; i++ )
	{
		wait 0.05;
		
		level.a_vh_lasthorses[ i ] = spawn_vehicle_from_targetname( "horse_afghan" );
		level.a_vh_lasthorses[ i ].origin = a_s_spawnpts[ i ].origin;
		level.a_vh_lasthorses[ i ].angles = a_s_spawnpts[ i ].angles;
		level.a_vh_lasthorses[ i ] MakeVehicleUnusable();
		level.a_vh_lasthorses[ i ] thread delete_vehicle_at_end_of_node();
		level.a_vh_lasthorses[ i ].ai_rider = get_muj_ai();
		
		if ( IsDefined( level.a_vh_lasthorses[ i ].ai_rider ) )
		{
			level.a_vh_lasthorses[ i ].ai_rider ai_horse_ride( level.a_vh_lasthorses[ i ] );
		}
		
		level.a_vh_lasthorses[ i ] thread go_path( GetVehicleNode( "last_horse_" + i, "targetname" ) );
	}
	
	a_s_spawnpts = undefined;
}


extra_horses_left()
{
	level waittill( "mig_fly_over" );
	
	s_spawnpt = GetVehicleNode( "horse_extra_left", "targetname" );
	
	level.a_vh_extralefthorses = [];
	
	n_pathoffset = -40;
	
	for ( i = 0; i < 4; i++ )
	{
		wait 0.05;
		
		level.a_vh_extralefthorses[ i ] = spawn_vehicle_from_targetname( "horse_afghan" );
		level.a_vh_extralefthorses[ i ].origin = s_spawnpt.origin;
		level.a_vh_extralefthorses[ i ].angles = s_spawnpt.angles;
		level.a_vh_extralefthorses[ i ] PathFixedOffset( ( 0, i * n_pathoffset, 0 ) );
		level.a_vh_extralefthorses[ i ] MakeVehicleUnusable();
		level.a_vh_extralefthorses[ i ] thread delete_vehicle_at_end_of_node();
		level.a_vh_extralefthorses[ i ].ai_rider = get_muj_ai();
		
		if ( IsDefined( level.a_vh_extralefthorses[ i ].ai_rider ) )
		{
			level.a_vh_extralefthorses[ i ].ai_rider ai_horse_ride( level.a_vh_extralefthorses[ i ] );
		}
		
		level.a_vh_extralefthorses[ i ] thread go_path( GetVehicleNode( "horse_extra_left", "targetname" ) );
	}
	
	a_s_spawnpts = undefined;
}


horses_after_krav_down()
{
	level endon( "charge_done" );
	
	s_spawnpt = getstruct( "reinforcement_spawnpt", "targetname" );
	
	level.a_vh_krav_horses = [];
	
	const krav_horse_max = 10;
	
	while( level.a_vh_krav_horses.size < krav_horse_max )//Let's cap this so we have enough time to cleanup
	{
		n_group = RandomIntRange( 3, 6 );
		
		for ( i = 0; i < n_group; i++ )
		{
			if( level.a_vh_krav_horses.size >= krav_horse_max )
			{
				return;//Exit out if we hit the max while spawning a group
			}
			current_index = level.a_vh_krav_horses.size;
			level.a_vh_krav_horses[ current_index ] = spawn_vehicle_from_targetname( "horse_afghan" );
			level.a_vh_krav_horses[ current_index ].origin = s_spawnpt.origin;
			level.a_vh_krav_horses[ current_index ].angles = s_spawnpt.angles;
			level.a_vh_krav_horses[ current_index ].ai_rider = get_muj_ai();
				
			if ( IsDefined( level.a_vh_krav_horses[ current_index ].ai_rider ) )
			{
				level.a_vh_krav_horses[ current_index ].ai_rider ai_horse_ride( level.a_vh_krav_horses[ current_index ] );
			}
			
			level.a_vh_krav_horses[ current_index ] thread horses_after_krav_behavior();
			
			wait  RandomFloatRange( 0.3, 1.3 );
		}
		
		wait RandomIntRange( 6, 8 );
	}
	
	s_spawnpt structdelete();
	s_spawnpt = undefined;
}


horses_after_krav_behavior()
{
	self endon( "death" );
	
	self thread delete_vehicle_at_end_of_node();
	
	nd_start = GetVehicleNode( "start_krav_down1", "targetname" );
	
	if ( cointoss() )
	{
		nd_start = GetVehicleNode( "start_krav_down2", "targetname" );
	}
	
	self PathFixedOffset( ( 0, RandomIntRange( -50, 50 ), 0 ) );
	self MakeVehicleUnusable();
	
	self thread go_path( nd_start );
}
