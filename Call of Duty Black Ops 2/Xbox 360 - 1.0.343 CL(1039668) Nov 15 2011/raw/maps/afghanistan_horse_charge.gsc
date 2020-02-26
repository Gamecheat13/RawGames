#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_horse;

/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//
//	Declare event-specific flags here
init_flags()
{
//	flag_init( "event_flag" );
	flag_init("horse_charge_finished");
	flag_init("pushed_off_horse");
	flag_init( "second_base_visit" );
	flag_init( "time_scale_punch" );
	flag_init( "start_tank_shake" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//	add_spawn_function( "intro_drone", ::intro_drone );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions	(you may have more than one skipto in this file)
-------------------------------------------------------------------------------------------*/

//
//	This is run before your main function is executed.  Put any skipto-only initialization here.
skipto_horse_charge()
{
	skipto_setup();
	
	level.woods = init_hero("woods");
	level.zhao = init_hero("zhao");
	
	//level thread spawn_horse_charge();
	
	level.skip_to_charge_used = 1;
	
	start_teleport( "skipto_horse_charge", level.heroes );
}

skipto_krav_tank()
{
	skipto_setup();
	
	level.woods = init_hero("woods");
	level.zhao = init_hero("zhao");
	
	//level thread spawn_horse_charge();
	
	start_teleport( "skipto_horse_charge", level.heroes );
}


main()
{
	level thread turn_down_fog();
	
	screen_fade_out();
	
//	if(isDefined(level.player.viewlockedentity))
//	{
//		level.player.viewlockedentity.disable_mount_anim = true;
//		level.player.viewlockedentity UseBy(level.player);
//	}
	
	flag_set( "stop_arena_explosions" );    
    spawn_manager_disable( "manager_troops_exit" );
    spawn_manager_disable( "manager_hip3_troops" );
    spawn_manager_disable( "manager_hip4_troops" );

	
	level.player get_player_off_horse();
	
	axis_array = get_ai_array("axis");
	//if(axis_array.size > 0)
	//{
	array_delete (axis_array);
	//}
	horse_array = GetEntArray("script_vehicle", "classname");
	if(horse_array.size > 0)
	{
		size = horse_array.size;
		for( i = 0; i < size; i++)
		{
			if(horse_array[i].vehicletype == "horse" )
			{
				horse_array[i] delete();
			}
			else if( horse_array[i].vehicletype == "horse_player" )
			{
				horse_array[i] thread delete_player_horse();
			}
		}
	}
	
	autosave_by_name("hourse_charge");
	//screen_fade_in();
	
	if(!flag("pushed_off_horse"))
	{
		level thread full_playthrough_set_up_charge();
	}
	
	level thread after_button_mash_scene();
}


/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/
get_player_off_horse()  //self = level.player
{
	if ( IsDefined( self.viewlockedentity ) )
	{
		horse = 	self.viewlockedentity;
		
		level clientnotify( "cease_aiming" );
		
		wait 0.1;
		
		horse maps\_horse::use_horse( self );
		
		horse MakeVehicleUnusable();
		
		horse Delete();
		self.body Delete();
		level.zhao ai_ride_stop_riding();
		level.horse_zhao Delete();
	}
}

delete_player_horse()
{
	wait 0.25;
	self delete();
}

full_playthrough_set_up_charge()
{
	spawn_horse_charge();
	
	wait 0.05;
	
	level thread horse_charge_event();
	
	screen_fade_in();
}

set_horse_anim()
{
	self.ignoreme = true;
	while(1)
	{
		self waittill( "enter_vehicle", vehicle );
	 	vehicle notify( "groupedanimevent", "ride" );
	 	self notify( "ride" );
		self maps\_horse_rider::ride_and_shoot( vehicle );
	}
}

spawn_horse_charge()
{
	level.charge_btrs = spawn_vehicles_from_targetname("horse_charge_btr");
	level.krav_tank = spawn_vehicle_from_targetname("krav_tank");
	
	level.krav_tank SetCanDamage(false);
	
	level.vh_before_charge_uaz = spawn_vehicle_from_targetname("before_charge_uaz");
	level.ai_rpg_muj = simple_spawn_single("rpg_muj");
	level.ai_rpg_muj2 = simple_spawn_single("rpg_muj2");
	level.ai_rpg_muj3 = simple_spawn_single("rpg_muj3");	
	
	level.a_vh_horses_for_charge = [];
	level.muj_riders = [];

	for(i = 0; i < 6; i++)
	{
		muj_rider = getent("muj_rider_" + i, "targetname");
		muj_rider add_spawn_function( ::set_horse_anim );
		level.a_vh_horses_for_charge[i] = spawn_vehicle_from_targetname("horse_for_charge_" + i);
	}
	
	level.woods = init_hero("woods");
	level.zhao = init_hero("zhao");
	
	level.zhao.ignoreme = true;
	level.woods.ignoreme = true;
		
	level.vh_woods_horse = spawn_vehicle_from_targetname("horse_for_charge_woods");
	level.vh_zhao_horse = spawn_vehicle_from_targetname("horse_for_charge_zhao");
	level.vh_player_horse = spawn_rideable_horse("players_horse_for_charge");
}

charge_offset_controls()
{
	level.vh_player_horse endon("death");
	level.n_offset = 0;
	
	while(1)
	{
		player_input = level.player GetNormalizedMovement();
		level.n_offset += player_input[1];
		
		if( level.n_offset > 500)
		{
			level.n_offset = 500;
		}
		else if( level.n_offset < -500)
		{
			level.n_offset = -500;
		}
		
		level.vh_player_horse PathFixedOffset( (level.n_offset, 0, 0) );
		wait 0.05;
	}
}

move_player_then_point_at_tank()
{
	//-- move the player in front of his horse
	vn_tank_lookat = GetVehicleNode( "tank_hill_lookat", "targetname" );
	
	e_linkto_point = Spawn("script_model", level.vh_player_horse.origin + ( 0,0, 50 ));
	e_linkto_point SetModel("tag_origin");
	e_linkto_point.angles = VectorToAngles( vn_tank_lookat.origin - e_linkto_point.origin );
	
	level.player PlayerLinkToAbsolute(e_linkto_point, "tag_origin");
	
	level waittill("unlink_player_from_binocs");
	level.player Unlink();
	e_linkto_point Delete();
}

#define BINOC_FADE_OUT 0.15
#define BINOC_FADE_IN 0.15
#define BINOC_SCENE_TIME 5

horse_charge_event()
{	
	//level.vh_player_horse MakeVehicleUnusable();
	level thread run_scene("e4_s1_return_base_lineup");
	
	for(i = 0; i < 6; i++)
	{
		muj_rider_ai = getent("muj_rider_" + i + "_ai", "targetname");
	
		if(IsDefined(muj_rider_ai))
		{
			muj_rider_ai SetCanDamage(false);
		}
	}
	
	if(IsDefined(level.woods))
	{
		level.woods SetCanDamage(false);
	}
	if(IsDefined(level.zhao))
	{
		level.zhao SetCanDamage(false);
	}
	
	
	stop_exploder( 1000 );	// reduce the sandstorm amount so you can see
	n_anim_time = GetAnimLength( %player::p_af_04_01_return_base_player_lineup );
		
	wait ( n_anim_time - BINOC_FADE_OUT );
	set_screen_fade_timer(BINOC_FADE_OUT);
	level thread screen_fade_out();
	
	level.scene_sys waittill("e4_s1_return_base_lineup_done");
	
	level.vh_player_horse.disable_mount_anim = true;
	
	level.player FreezeControls(true);
	//level thread debug_get_player_pos();
	wait 0.05;
	
	//level thread run_scene("e4_s1_binoc");
	run_scene_first_frame("e4_s1_return_base_charge_freeze");
	wait 0.05;
	
	for(i = 0; i < 6; i++)
	{
		muj_rider_ai = getent("muj_rider_" + i + "_ai", "targetname");
	
		if(IsDefined(muj_rider_ai))
		{
			muj_rider_ai SetCanDamage(false);
		}
	}
	
	if(IsDefined(level.woods))
	{
		level.woods SetCanDamage(false);
	}
	if(IsDefined(level.zhao))
	{
		level.zhao SetCanDamage(false);
	}
	
	level.player StartBinocs();
	level clientNotify( "toggle_binoculars" );
	level.player hideviewmodel();
	
	default_fov = getdvarfloat( "cg_fov" );
	
	//-- point the player at the top of the hill	
	level thread move_player_then_point_at_tank();
	level.krav_tank thread go_path();
	
	level.krav_tank thread stop_tank_at_end_node();
	level.charge_btrs[0] StartPath();
	level.charge_btrs[1] StartPath();
	
	level.player thread lerp_fov_overtime( 0.05, 15 );
	level.player thread lerp_dof_over_time( 2.0 );
	
	wait 0.05; //-- get rid of minor pop
	
	set_screen_fade_timer(BINOC_FADE_IN);
	level thread screen_fade_in();
	
	//level.krav_tank thread krav_tank_targetting();
	
	//-- zoom in more on the tank and see it run over some guys
	wait 3;
	
	set_screen_fade_timer(BINOC_FADE_OUT);
	level screen_fade_out();
	level.player thread lerp_fov_overtime( 0.05, 2 );
	wait 0.25;
	
	//level thread run_scene( "e4_s3_tank_squash" );
	
	set_screen_fade_timer(BINOC_FADE_IN);
	level screen_fade_in();
	
	
	wait 6;
	
	set_screen_fade_timer(BINOC_FADE_OUT);
	screen_fade_out();

	exploder( 1000 );	// reduce the sandstorm amount so you can see
	level notify("unlink_player_from_binocs");
	level.player FreezeControls(false);
	level.player showviewmodel();
	
	level.player thread lerp_fov_overtime( 0.05, 90 );
	
	//level thread clean_up_binoc_scene();
	
	const Default_Near_Start = 0;
	const Default_Near_End = 1;
	const Default_Far_Start = 8000;
	const Default_Far_End = 10000;
	const Default_Near_Blur = 6;
	const Default_Far_Blur = 0;

	level.player SetDepthOfField( Default_Near_Start, Default_Near_End, Default_Far_Start, Default_Far_End, Default_Near_Blur, Default_Far_Blur );
	
	
	//-- Start next scene
	level thread run_scene("e4_s1_return_base_charge");
	
	for(i = 0; i < 6; i++)
	{
		muj_rider_ai = getent("muj_rider_" + i + "_ai", "targetname");
	
		if(IsDefined(muj_rider_ai))
		{
			muj_rider_ai SetCanDamage(false);
		}
	}
	
	if(IsDefined(level.woods))
	{
		level.woods SetCanDamage(false);
	}
	if(IsDefined(level.zhao))
	{
		level.zhao SetCanDamage(false);
	}
	
	wait 0.25;
	set_screen_fade_timer(BINOC_FADE_IN);
	level thread screen_fade_in();
	level.scene_sys waittill("e4_s1_return_base_charge_done");
	
	
	if(IsDefined(level.woods))
	{
		level.woods thread set_horse_anim();
		level.woods enter_vehicle(level.vh_woods_horse);
		level.vh_woods_horse AttachPath(GetVehicleNode("woods_horse_path", "targetname"));
		level.woods SetCanDamage(false);
	}
	if(IsDefined(level.zhao))
	{
		level.zhao SetCanDamage(false);
	}
	
	
	
	if(IsDefined(level.woods))
	{
		level.woods SetCanDamage(false);
	}
	if(IsDefined(level.zhao))
	{
		level.zhao thread set_horse_anim();
		level.zhao enter_vehicle(level.vh_zhao_horse);
		level.vh_zhao_horse AttachPath(GetVehicleNode("zhao_horse_path", "targetname"));
		level.zhao SetCanDamage(false);
	}
	
	//level.vh_player_horse MakeVehicleUsable();
	
	if ( !IsDefined( level.b_player_on_horse ) )
	{
		level.vh_player_horse = GetEnt("players_horse_for_charge", "targetname");
		level.vh_player_horse maps\_horse::use_horse( level.player );
	}
	
	//level.vh_player_horse MakeVehicleUnusable();
	nd_player_horse_node = GetVehicleNode("player_horse_path", "targetname");
	
	for(i = 0; i < 6; i++)
	{
		muj_rider_ai = getent("muj_rider_" + i + "_ai", "targetname");
		
		if(IsDefined(muj_rider_ai))
		{
		
			muj_rider_ai enter_vehicle(level.a_vh_horses_for_charge[i]);
			
			level.a_vh_horses_for_charge[i] AttachPath(GetVehicleNode("horse_path_" + i, "targetname"));
			muj_rider_ai thread set_horse_anim();
		}
	}
	
	level.vh_before_charge_uaz StartPath();	
	level.vh_player_horse thread go_path(nd_player_horse_node);
	//level thread charge_offset_controls();
	
	level.vh_woods_horse StartPath();
	
	level.vh_zhao_horse StartPath();
	
	for(i = 0; i < level.a_vh_horses_for_charge.size; i++)
	{
		level.a_vh_horses_for_charge[i] StartPath();
	}
	
	//level.krav_tank StartPath();
	//level.charge_btrs[0] StartPath();
	//level.charge_btrs[1] StartPath();
	
	// FROM HERE ON BELOW < NEEDS TO BE CONVERTED
	
	//wait 1;
	
	level waittill("mig_fly_over");
	
	level.vh_fly_over_mig = spawn_vehicle_from_targetname("horse_charge_mig23_1");
	nd_start_mig = GetVehicleNode("mig23_start", "targetname");
	level.vh_fly_over_mig DrivePath(nd_start_mig);
	
	level waittill("rpg_shot_at_uaz");

	MagicBullet("rpg_magic_bullet_sp", (level.ai_rpg_muj.origin - (10,10,-60)), level.vh_before_charge_uaz.origin + (550,-50,0));	
	
	s_mortar_drop = getstruct("mortar_drop2_sec3", "targetname");
	PlayFX( level._effect[ "explode_mortar_sand" ], s_mortar_drop.origin );
	
	wait 0.5;
	
	s_mortar_drop = getstruct("mortar_drop1_sec3", "targetname");
	PlayFX( level._effect[ "explode_mortar_sand" ], s_mortar_drop.origin );
	
	level.vh_charge_hind = spawn_vehicle_from_targetname("horse_charge_hind");
	nd_start_hind = GetVehicleNode("hind_start_node", "targetname");
	level.vh_charge_hind DrivePath(nd_start_hind);
	
	wait 0.2;
	// TURN THIS BACK ON WHEN VEHICLES ARE FIXED
	RadiusDamage(level.vh_before_charge_uaz.origin, 100, level.vh_before_charge_uaz.health *2, level.vh_before_charge_uaz.health *2);
	
	wait 1.8;
	
	s_mortar_drop = getstruct("mortar_drop3_sec3", "targetname");
	PlayFX( level._effect[ "explode_mortar_sand" ], s_mortar_drop.origin );
	
	wait 0.3;
	RadiusDamage(level.a_vh_horses_for_charge[5].origin, 128, level.a_vh_horses_for_charge[5].health *2 , level.a_vh_horses_for_charge[5].health *2);
	Earthquake( 0.5, 1, s_mortar_drop.origin, 800 );
	
	wait 0.7;
	s_rpg_loc = getstruct("horse_charge_rpg_loc", "targetname");
	MagicBullet("rpg_magic_bullet_sp", (level.vh_charge_hind.origin - (0,0,200)), s_rpg_loc.origin);
	
	a_vh_new_horses = [];
	for(i = 0; i < 3; i++)
	{
		muj_rider = getent("new_horse_rider_" + i, "targetname");
		muj_rider add_spawn_function( ::set_horse_anim );
		
		a_vh_new_horses[i] = spawn_vehicle_from_targetname("new_horse_" + i);
		a_vh_new_horses[i] StartPath();
	}
	wait 3.0;
	//MagicBullet("rpg_magic_bullet_sp", (level.ai_rpg_muj2.origin - (15,15,-60)), level.krav_tank.origin);
	
	wait 0.4;
	
	PlayFX( level._effect[ "explode_mortar_sand" ], s_rpg_loc.origin );
	
	a_ai_muj_riders = [];
	
	a_ai_muj_riders [0] = getent("muj_rider_0", "targetname");
	a_ai_muj_riders [1] = getent("muj_rider_1", "targetname");
	a_ai_muj_riders [2] = getent("muj_rider_2", "targetname");
	
	wait 0.15;
	
	RadiusDamage(level.a_vh_horses_for_charge[0].origin, 256, level.a_vh_horses_for_charge[0].health *2, level.a_vh_horses_for_charge[0].health *2);
		
	wait 1;
	if(IsDefined(level.ai_rpg_muj3.origin) && IsAlive(level.ai_rpg_muj3.origin))
	{
		//MagicBullet("rpg_magic_bullet_sp", (level.ai_rpg_muj3.origin - (15,15,-60)), level.krav_tank.origin + (500, 20, 0));
	}
	
	level.vh_fly_over_mig2 = spawn_vehicle_from_targetname("horse_charge_mig23_2");
	nd_start_mig = GetVehicleNode("horse_charge_mig_2_start", "targetname");
	level.vh_fly_over_mig2 DrivePath(nd_start_mig);
		
	wait 2;
	
	s_mortar_drop = getstruct("mortar_drop4_sec3", "targetname");
	PlayFX( level._effect[ "explode_grenade_sand" ], s_mortar_drop.origin );
	
	wait 1.2;
	s_mortar_drop = getstruct("mortar_drop5_sec3", "targetname");
	PlayFX( level._effect[ "explode_mortar_sand" ], s_mortar_drop.origin );
	
	s_rpg_loc = getstruct("fire_magic_rpg_at_btr", "targetname");
	
	wait 0.2;
	//MagicBullet("rpg_magic_bullet_sp", s_rpg_loc.origin, level.charge_btrs[0].origin + (0,0, 20));
	
	RadiusDamage(a_vh_new_horses[2].origin, 256, a_vh_new_horses[2].health *2, a_vh_new_horses[2].health *2);
	Earthquake( 0.3, 0.6, level.a_vh_horses_for_charge[3].origin, 400 );	
	
	wait 0.8;
	s_mortar_drop = getstruct("mortar_drop6_sec3", "targetname");
	PlayFX( level._effect[ "explode_mortar_sand" ], s_mortar_drop.origin );
	
	wait 0.2;
	//RadiusDamage(level.a_vh_horses_for_charge[3].origin, 16, level.a_vh_horses_for_charge[3].health, level.a_vh_horses_for_charge[3].health);
	Earthquake( 0.5, 0.8, level.a_vh_horses_for_charge[3].origin, 400 );
	
	// Fires one barrel on the tank, need to get it so it can fire both barrels.
	//level.krav_tank thread maps\_turret::fire_turret_for_time( 4, 0 );
	//level.krav_tank thread maps\_turret::fire_turret_for_time( 4, 1 );
	//level thread debug_get_player_pos();
	level.vh_player_horse waittill("reached_end_node");
	
	
	s_blow_up_horse_loc = getstruct("blow_up_horse", "targetname");
	PlayFX( level._effect[ "explode_mortar_sand" ], s_blow_up_horse_loc.origin );
	
	
	wait 0.1;
	//Earthquake( 0.7, 2, s_blow_up_horse_loc.origin, 800 );
	/*
	level.player shellshock( "death", 10);
	level.player dodamage(level.player.health - 1, level.player.origin);

	level.vh_player_horse useby(level.player);
	*/
	
	level.player DisableWeapons();
	level.vh_player_horse maps\_horse::use_horse( level.player );
	level.vh_player_horse MakeVehicleUnusable();
	
	
	run_scene("e4_s5_player_horse_fall");
	level notify("horse_fallen");
	level thread run_scene("e4_s5_player_horse_pushloop");
	
	wait 0.05;
	level.vh_player_horse Delete();
		
	/*
	level.player PlayerLinkToAbsolute(getent("knocked_off_horse", "targetname"));
	*/	
	
	wait .25;
	screen_message_create(&"AFGHANISTAN_PUSH_OFF_HORSE");
	level thread push_horse_off_logic();
	
	level.zhao notify("stop_riding");
	level.woods notify("stop_riding");
	level.vh_woods_horse thread vehicle_unload(0.05);
	level.vh_zhao_horse thread vehicle_unload(0.05);
	
	level.vh_zhao_horse waittill("unloaded");
	
	e_zhao_pos = GetEnt("krav_interrogation_zhao_pos", "targetname");
	e_woods_pos = GetEnt("krav_interrogation_woods_pos", "targetname");
	
	level.zhao forceteleport(e_zhao_pos.origin, e_zhao_pos.angles);
	level.woods forceteleport(e_woods_pos.origin, e_woods_pos.angles);
	
	level.vh_woods_horse Hide();
	level.vh_zhao_horse Hide();
}


stop_tank_at_end_node()
{
	self waittill("tank_pause_pos");
	self notify( "tank_stop_attack" );
	
	self SetSpeed(0, 1);
	self SetCanDamage(false);
	//IPrintLnBold("tank_pausing");
	
	
	level waittill("horse_fallen");
	//IPrintLnBold("tank_starting");
	self ResumeSpeed(1);
	self SetCanDamage(true);
}

krav_tank_targetting()
{
	self endon( "death" );
	self endon( "attack_cache" );
	self endon( "tank_stop_attack" );
	
	level.krav_tank thread maps\_turret::enable_turret( 0 );
	level.krav_tank thread maps\_turret::fire_turret_for_time( 5, 0 );
	wait(5);
	level.krav_tank thread maps\_turret::stop_turret( 0 );
	/*
	while(1)
	{
		level.krav_tank FireGunnerWeapon(1);
		wait RandomFloatRange(1.5, 3.0);
	}
	*/
}

clean_up_binoc_scene()
{
	for(i = 1; i < 6; i++)
	{
		temp_horse = GetEnt("battle_horse" + i, "targetname");
		temp_horse delete();
		
		temp_muj = GetEnt("battle_muj" + i + "_ai", "targetname");
		if(IsDefined(temp_muj))
		{
			temp_muj delete();
		}
	}
	
	//temp_muj = GetEnt("battle_russian_ai", "targetname");
	//temp_muj delete();
}

debug_get_player_pos()
{
	while(1)
	{
		iprintlnbold("x = " + level.vh_player_horse.origin[0] + " y = " + level.vh_player_horse.origin[1] + " z = " + level.vh_player_horse.origin[2]);
		wait 0.5;
	}
}

push_horse_off_logic()
{
	n_button_pressed_count = 0;
	n_timer = 3.0;
	has_released_use_button = true;
	
	while(n_timer > 0)
	{
		if(level.player UseButtonPressed() && has_released_use_button)
		{
			n_button_pressed_count += 1;
			has_released_use_button = false;
		}
		else if( !( level.player UseButtonPressed() ) && !has_released_use_button )
		{
			has_released_use_button = true;
		}
		
		wait 0.05;
		n_timer -= 0.05;
	}
	
	if( n_button_pressed_count >= 1)
	{
		//iprintlnbold("success");
		//level.player unlink();
		flag_set("pushed_off_horse");
		end_scene("e4_s5_player_horse_pushloop");
	}
	else
	{
		missionfailed();
	}
}

clean_up_charge()
{
	screen_message_delete();
	
	if(!isDefined(level.kravchenko))
	{
		level.kravchenko = init_hero("kravchenko");
	}
	
	if(!isDefined(level.woods))
	{
		level.woods = init_hero("woods");
	}
	
	if(!isDefined(level.vh_woods_horse))
	{
		level.vh_woods_horse = spawn_vehicle_from_targetname("horse_for_charge_woods");
	}
	

	
	if(isDefined(level.a_vh_horses_for_charge))
	{
		for(i = 0; i < 6; i++)
		{
			level.a_vh_horses_for_charge[i] delete();
		}
	}

	if(isDefined(level.vh_charge_hind))
	{
		level.vh_charge_hind delete();
	}
}

after_button_mash_scene()
{
	flag_wait("pushed_off_horse");
	level.player.ignoreme = true;
	
	if(!isDefined(level.charge_btrs))
	{
		level.charge_btrs = spawn_vehicles_from_targetname("horse_charge_btr");
		level.charge_btrs[1] AttachPath(GetVehicleNode("btr_skipto", "targetname"));
		level.charge_btrs[1] StartPath();
	}
	
	level thread handle_tank_earthquake();
	level thread clean_up_charge();
	
	level thread handle_activity_durring_tank_climb();
	
	//IPrintLnBold("evt_reunion_start");
	level.player playsound("evt_reunion_start");
	run_scene("e4_s6_player_grabs_on_tank");
	
	thread run_scene("e4_s6_tank_fight_tank");
	
	level thread handle_punch_timescale();
	
	
	thread run_scene("e4_s6_tank_fight");
	wait 0.3;
		
	mig_3 = spawn_vehicle_from_targetname("horse_charge_mig23_3");
	mig_3 StartPath();
	
	wait 3.5;
	
	s_mortar_drop = getstruct("mortar_drop8_sec3", "targetname");
	PlayFX( level._effect[ "explode_mortar_sand" ], s_mortar_drop.origin );
	
	wait 0.2;
	Earthquake( 0.5, 1.5, s_mortar_drop.origin, 1000 );
	
	wait 1.7;
	
	s_mortar_drop = getstruct("mortar_drop9_sec3", "targetname");
	PlayFX( level._effect[ "explode_mortar_sand" ], s_mortar_drop.origin );
	
	wait 12.5;
	
	if(!isDefined(level.krav_tank))
	{
		level.krav_tank = getent("krav_tank", "targetname");
	}
	
	//IPrintLnBold("explo");
	level.player PlaySound("evt_reunion_tank_explo");
	PlayFX( level._effect[ "explode_mortar_sand" ], level.krav_tank.origin );
	
	
	level.scene_sys waittill("e4_s6_tank_fight_done");
	
	//iprintlnbold("success");
	
	level.kravchenko unlink();
	level.player unlink();
	
	wait 0.1;
	
	level.player shellshock( "death", 5);
	
	//IPrintLnBold("evt_reunion_wake_up");
	level.player PlaySound("evt_reunion_wake_up");
	level thread run_scene("e4_s6_strangle");
	n_anim_time = GetAnimLength( %player::p_af_04_09_reunion_player_strangle );
	n_wait_time = n_anim_time - level.fade_screen.fadeTimer - .1;
	wait n_wait_time;		// Wait anim length minus the length of the fade timer (and a few frames for buffer)
	screen_fade_out();
	
	wait 4;
	
	if(!isDefined(level.hudson))
	{
		level.hudson = init_hero("hudson");
	}
	if(!isDefined(level.rebel_leader))
	{
		level.rebel_leader = init_hero("rebel_leader");
	}

	e_rebel_leader_pos = GetEnt("krav_interrogation_leader_pos", "targetname");
	level.rebel_leader forceteleport(e_rebel_leader_pos.origin, e_rebel_leader_pos.angles);
	
	level.player enableweapons();
	
	flag_set( "second_base_visit" );
}

handle_tank_earthquake()
{
	flag_wait("start_tank_shake");
	Earthquake( 0.3, 5, level.player.origin, 800 );
}

handle_punch_timescale()
{
	flag_wait("time_scale_punch");
	SetTimeScale(0.35);
	
	flag_wait("time_scale_punch_end");
	timescale_tween(0.35, 1.0, 2.0);
}

handle_activity_durring_tank_climb()
{
	test = simple_spawn("test");
	test_horse = spawn_vehicles_from_targetname("test_horse");
	
	for(i = 0; i < 4; i++)
	{
		test[i] forceteleport(test_horse[i].origin + (0,0,20), test_horse[i].angles);
		test[i] linkto(test_horse[i]);
	}
	
	wait 3.5;
	vh_after_charge_uaz = spawn_vehicle_from_targetname("after_charge_uaz");
	vh_after_charge_uaz StartPath();
	
	wait 5.0;
	
	for(i = 0; i < 4; i++)
	{
		test_horse[i] StartPath();
	}
	
	s_mortar_drop = getstruct("mortar_drop7_sec3", "targetname");
	PlayFX( level._effect[ "explode_mortar_sand" ], s_mortar_drop.origin );
	
	wait 1.0;
	
	vh_after_charge_uaz do_unload(0);
	
	s_rpg_loc = getstruct("fire_magic_rpg_at_btr_2", "targetname");
	MagicBullet("rpg_magic_bullet_sp", s_rpg_loc.origin, level.charge_btrs[1].origin + (0,0, 20));
}
