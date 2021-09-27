#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_anim;
#include maps\_audio;
#include maps\_audio_music;
#include maps\_audio_zone_manager;
#include maps\_vehicle;
#include maps\ny_hind;
#include maps\_specialops;
#include maps\_shg_common;
//#include maps\_stinger;


main()
{
	level.primary_weapon = "scar_h_acog";
	level.secondary_weapon = "mp5";
	level.tertiary_weapon = "mp5_silenced_thermal";
	level.quandry_weapon = "m79";
	//level.pentacular_weapon = "stinger";
	level.pentacular_weapon = "iw5_smaw_so";
	level.sextant_weapon = "mp5_silenced_thermal";
	
	level.right_back = 1;
	level.right_front = 3;
	level.right_middle = 5;
	level.left_back = 2;
	level.left_front = 6;
	level.left_middle = 4;
	level.right_back_facing = 7;
	level.right_front_facing = 8;
	level.left_back_facing = 9;
	level.left_front_facing = 10;
	
	PrecacheMinimapSentryCodeAssets();
	maps\_shg_common::so_vfx_entity_fixup( "msg_vfx_zone" );

	flag_init( "player_landed_loc1" );
	flag_init( "obj_meet_at_bank_complete" );
	flag_init( "last_stand" );
	flag_init( "obj_meet_at_bank_vo_done"); 
	flag_init( "timer_start" ); 
	flag_init( "timer_complete" ); 
	flag_init( "trigger_rappel_guys" );
	flag_init( "obj_arm_bomb_complete" );
	flag_init( "tanks_dead" );
	flag_init( "exit_flight" );
	flag_init( "bomb_timer_done" );
	flag_init( "player2_got_off" );
	flag_init( "buliding_destroyed" );
	flag_init( "all_clear" );
	flag_init( "heli_landed_at_lz" );
	flag_init( "stop_thermal" );
	flag_init( "players_on_their_way" );
	flag_init( "player_left_area" );
	flag_init( "player_unloaded_from_intro_flight" );
	flag_init( "rus_all_tanks_dead" );
	flag_init( "player_teleport_after_collapse" );
	flag_init( "player_teleport_after_collapse_complete" ); 
	flag_init( "reverse_breach_start" );
	flag_init( "vo_come_aboard" );
	flag_init( "laststand_downed" );
	flag_init( "change_from_stinger" );
	
	
	maps\so_heliswitch_berlin_precache::main();
	so_delete_all_vehicles();
	maps\_load::main();
	//maps\_stinger::init();
	maps\berlin_aud::main();
	maps\so_aud::main();
	maps\_compass::setupMiniMap( "compass_map_berlin" );
	maps\berlin_fx::main();
	
	add_hint_string( "objective_missed", &"SO_HELISWITCH_BERLIN_HINT_MISS_OBJ", ::disable_objective_warning );

	PreCacheString( &"SO_HELISWITCH_BERLIN_HINT_USE_TO_BOARD" );
	
	PrecacheModel( "prop_suitcase_bomb" );
	PrecacheModel( "viewmodel_briefcase_bomb_mp_obj" );
	
	PreCacheItem( "flash_grenade" );
	PreCacheItem( "rpg_straight" );
	PreCacheItem( "smoke_grenade_american" );
	PrecacheItem( "briefcase_bomb_defuse_sp" );
	PrecacheItem( "scar_h_thermal_silencer" );
	//PreCacheItem( "stinger" );
	PreCacheItem( "iw5_smaw_so" );
	
	precacheshader( "hud_icon_nvg" );
	precacheshader( "gasmask_overlay_delta2" );
	precacheshader( "nightvision_overlay_goggles" );
	precacheshader( "hud_white_box" );
	
	
	//Animation fx and vo
	fx_setup();
	vo_setup();
	generic_human();
	script_model_anims();
	script_prop_anims();
	
	setup();
	gameplay_logic();
}

setup()
{
	so_delete_all_triggers();
	so_delete_all_spawners();
	
	thread AZM_start_zone("berlin_street_bridge_tanks");

	resolve_usable_object_conflicts();
	setup_players();
	setup_heli();
	thread setup_difficulty_settings();
	
	thread vision_set_fog_changes("berlin_emerge",0);
	thread enable_escape_warning();
	thread enable_escape_failure();
	thread handle_script_brushes();
	foreach (p in level.players)
		p thread missing_objective_warning("missed_objective_bomb", &"SO_HELISWITCH_BERLIN_HINT_MISS_OBJ", "obj_arm_bomb_complete");
		

	thread enable_challenge_timer( "timer_start", "so_heliswitch_berlin_complete" );
	thread fade_challenge_in();
	thread fade_challenge_out( "so_heliswitch_berlin_complete" );
	
		// Custom end of game logic
	handle_end_of_game_bonuses();
	level.so_mission_worst_time = 560000;
	level.so_mission_min_time = 148000;
	array_thread ( level.players, ::enable_challenge_counter, 3, &"SO_HELISWITCH_BERLIN_BONUS_SKILL_SHOT_SMALL", "bonus1_count" );
	array_thread ( level.players, ::enable_challenge_counter, 4, &"SO_HELISWITCH_BERLIN_BONUS_LEAVE_EM_SMALL", "bonus2_count" );
	maps\_shg_common::so_eog_summary( "@SO_HELISWITCH_BERLIN_BONUS_1_SKILL_SHOT", 150, undefined, "@SO_HELISWITCH_BERLIN_BONUS_2_LEAVE_EM", 125, undefined);
}

gameplay_logic()
{
	thread music();
	thread dialogue();
	thread setup_bombs();
	thread setup_rappel_guys();
	thread setup_tank();
	thread spawner_cleanup();
	thread objectives();
	thread handle_various_exploits();
	thread setup_biased_groups();
	//thread debug();
	array_thread (level.players, ::thermal_vision);

	setup_location0_start();
	setup_location1_street();
	setup_location2_aa_building();
	setup_location3_roof2();
}
//-------------------------------------------------------------------------------------------------

debug()
{
	//no bugs
}

resolve_usable_object_conflicts()
{
	vols = getentarray("destructible_mask", "targetname");
  mask_interactives_in_volumes( vols );
}

setup_players()
{
	assert( isdefined(level.players[0] ));
	
	level.air_guy = undefined;
	level.ground_guy = level.players[0];
	level.single_player = true;	
	
	if ( is_coop() )
	{
		// Role select text: 	"Select air support." 
		// dvar coop_start: 	value "so_char_host" from menus sets host as the defuser
		// dvar coop_start: 	value "so_char_client" from menus sets client as defuser
		
		if ( GetDvar( "coop_start" ) == "so_char_host" )
		{
			level.ground_guy = level.players[1];
			level.air_guy = level.players[0];
		}
		else
		{
			level.ground_guy = level.players[0];
			level.air_guy = level.players[1];
		}
	}

	if ( isdefined( level.players[1] ))
	{
		level.single_player = false;
		level.air_guy.lilbros = make_level_vars( 80, 100, 15, 80, level.left_middle );
		level.air_guy.lilbros["is_on_heli"] = true;
	}
	
	level.ground_guy.lilbros = make_level_vars( 90, 90, 15, 80, level.right_back );
	level.ground_guy.lilbros[ "is_on_heli" ] = false;

	thread end_mission_if_downed();
}

make_level_vars(r_arc, l_arc, t_arc, b_arc, seat)
{
	array = [];
	array["limit_right_arc"] = r_arc;
	array["limit_left_arc"] = l_arc;
	array["limit_top_arc"] = t_arc;
	array["limit_bottom_arc"] = b_arc;
	array["seat_id"] = seat;
	array["cheater"] = false;
	return array;
}

setup_biased_groups()
{
	createthreatbiasgroup("player1");
	createthreatbiasgroup("player2");
	createthreatbiasgroup("dudes_for_player1");
	createthreatbiasgroup("dudes_for_player2");
	
	setthreatbias("dudes_for_player1", "player1", 200);
	setthreatbias("dudes_for_player2", "player2", 200);
	
	if( !level.single_player )
		level.players[1] setthreatbiasgroup("player2");
	else
		add_global_spawn_function( "axis", ::vary_targets_if_single );
		
	level.players[0] setthreatbiasgroup("player1");

	flag_wait("start_smoke_ambush");
	add_global_spawn_function( "axis", ::respect_threatbiases );
}

respect_threatbiases()
{
	if(cointoss()) 
		group = "dudes_for_player1";
	else 
		group = "dudes_for_player2";
	
	self setthreatbiasgroup(group);
	flag_wait("bread_crumb_bomb_2");
	
	if (isdefined(self))
		self setthreatbiasgroup(group);
}

vary_targets_if_single()
{
	self endon ("death");
	
	while (1)
	{
		wait 0.05;
		
		if( isdefined ( self.enemy ) && self.enemy != level.players[ 0 ] )
		{
			wait 5;									//this function clears the enemy's target every once in a while. otherwise will shoot all his ammo at an invulnerable ai and look dumb
			self clearenemy();
		}
	}
	
}

end_mission_if_downed()
{
	array_thread( level.players, ::if_player_jumps_off_building );

	flag_clear( "laststand_on" );
	
	flag_wait( "player2_got_off" );
	flag_set( "laststand_on" );
	
	flag_wait_either( "exit_flight", "buliding_destroyed");
	flag_clear( "laststand_on" );
}

if_player_jumps_off_building()
{
	is_outside_play_area = GetEnt( "is_outside_play_area", "targetname" );
	
	flag_wait( "player2_got_off" );
	
	while ( !is_outside_play_area istouching( self ))
		wait 0.05;

	flag_clear( "laststand_on" );
}


end_mission_fail()
{
	level.challenge_end_time = gettime();

	so_force_deadquote( "@DEADQUOTE_SO_TRY_NEW_DIFFICULTY" );
	maps\_utility::missionFailedWrapper();
}

handle_script_brushes()
{
	brushes = GetEntArray( "rappel_blockers", "targetname" );
	array_call (brushes, ::hide);
		
	flag_wait( "rappel_blockers_show" );
	array_call (brushes, ::show);
		
	office_floor_blocker = GetEntArray( "office_floor_blocker", "targetname" );
	array_call(office_floor_blocker, ::delete);
}


so_objective_handler(name, obj_string, obj_loc, flag_end, crumb, end_crumb)
{
	Objective_Add( obj( name ), "active", obj_string );
	Objective_Current( obj( name ) );
	
	if ( isdefined( crumb ) )
	{
		Objective_position( obj( name ), crumb.origin );
		flag_wait (end_crumb);
		Objective_position( obj( name ), (0,0,0) );
	}
	Objective_position( obj( name ), obj_loc.origin );
	
	flag_wait (flag_end);
	Objective_position( obj( name ), (0,0,0) );
	objective_complete( obj( name ) );
}

objectives()
{

	obj_location_bank = GetEnt( "obj_location_bank", "targetname" );
	Objective_Add( obj( 1 ), "active", &"SO_HELISWITCH_BERLIN_OBJ_GETON_HELI" );
	Objective_Current( obj( 1 ) );
	flag_wait ( "give_obj_1_meet_at_bank" );
	Objective_position( obj( 1 ), obj_location_bank.origin );
	//so_objective_handler( 1, &"SO_HELISWITCH_BERLIN_OBJ_GETON_HELI", obj_location_bank, "littlebird_arrived_bank");
	
	flag_wait ( "littlebird_arrived_bank" );
	Objective_position( obj( 1 ), (0,0,0));
	objective_onentity(obj( 1 ), level.heli);
	
	flag_wait ( "obj_meet_at_bank_vo_done" );
	Objective_position( obj( 1 ), (0,0,0) );
	objective_complete( obj( 1 ) );

	//so_objective_handler( 2, &"SO_HELISWITCH_BERLIN_OBJ_CLEAR_LZ", obj_location_bank, "all_clear");
	
	flag_wait("obj_meet_at_bank_vo_done");
	bread_crumb = GetStruct( "obj_bomb_bread_crumb_1", "targetname" );
	so_objective_handler( 3, &"SO_HELISWITCH_BERLIN_OBJ_INFILTRATE", bread_crumb, "objective_bread_crumb_flag");
	
	bread_crumb_2 = GetStruct( "obj_bomb_bread_crumb_2", "targetname" );
	Objective_Add( obj( 4 ), "active", &"SO_HELISWITCH_BERLIN_OBJ_PROTECT" );
	Objective_Current( obj( 4 ) );
	Objective_position( obj( 4 ), bread_crumb_2.origin );
	flag_wait("bread_crumb_bomb_2");
	Objective_position( obj( 4 ), level.briefcase_bomb.origin );
	flag_wait("obj_arm_bomb_complete");
	Objective_position( obj( 4 ), (0,0,0) );
	objective_complete( obj( 4 ) );
	//so_objective_handler( 4, &"SO_HELISWITCH_BERLIN_OBJ_PROTECT", level.briefcase_bomb, "obj_arm_bomb_complete", bread_crumb_2, "bread_crumb_bomb_2");
	
	obj_origin = GetEnt( "obj_extraction", "targetname" );
	so_objective_handler( 5, &"SO_HELISWITCH_BERLIN_OBJ_EXTRACTION", obj_origin, "littlebird_land_at_extraction");
}

spawner_cleanup()
{
	kill_spawners_noteworthy( "ground_guy_progress4", 899 );
	kill_spawners_noteworthy( "ground_guy_progress3", 900 );
	kill_spawners_noteworthy( "upper_roof_switch_path2", 901 );
	kill_spawners_noteworthy( "start_smoke_ambush", 902 );
	kill_spawners_noteworthy( "move_heli_to_pos6", 903 );
	kill_spawners_noteworthy( "move_heli_to_loc8", 904 );
}

kill_spawners_noteworthy(flg, num)
{
	flag_wait(flg);
	maps\_spawner::kill_spawnerNum( num );
}

handle_various_exploits()
{
	if( !level.single_player )
		thread if_heli_player_is_doing_all_the_work();

	array_thread ( level.players, ::handle_damage_on_heli );
}

handle_damage_on_heli()
{
	while(1)
	{
		self waittill ( "heli_switch" );
		
		if( self.lilbros["is_on_heli"] )
			thread modify_damage_for_air_player();
		else
			self SetViewKickScale( 1 );
	}
}

setup_difficulty_settings()
{
	level.ground_guy endon ("death");
	
	assert( isdefined( level.gameskill ) );
	//add_global_spawn_function( "axis", ::modify_accuracy_basedOnDist );
	
	while ( level.gameskill > 1 )
	{
		level.ground_guy SetViewKickScale( .65 );
		wait 1;
	}
}

modify_damage_for_air_player()
{

	if ( level.gameskill == 0 || level.gameskill == 1 )
			level.health_reduction = .93;
	else
		level.health_reduction = .97;
	
	self endon ("heli_switch");
	self endon ("death");
		
	self SetViewKickScale( 0.05 );
	
	thread every_x_seconds_full_health(4);
		
	while (1)
	{
		self waittill ( "damage", amount, attacker, direction_vec, point, type );
		
		if( amount < 50 && !self.lilbros[ "cheater" ] )
			self.health = self.health + int (amount * level.health_reduction);
	}
}

every_x_seconds_full_health(time)
{
	self endon ("heli_switch");
	self endon ("death");
	
	while(!self.lilbros["cheater"])
	{
		wait time;
		self.health = 100;
	}
}

if_heli_player_is_doing_all_the_work()
{
	while (1)
	{
		wait 0.05;
		ground_kills = level.ground_guy.stats[ "kills" ];
		air_kills = level.air_guy.stats[ "kills" ];
		
		if (( air_kills > 9 ) && ( air_kills /3 > ( ground_kills )))
		{
			level.air_guy.lilbros["cheater"] = true;
			
			wait_for_stats_to_even_out();
			
			level.air_guy.lilbros["cheater"] = false;
		}
	}
}

wait_for_stats_to_even_out()
{
	while (( level.air_guy.stats[ "kills" ] > 9 ) && ( (level.air_guy.stats[ "kills" ]/ 2) > ( level.ground_guy.stats[ "kills" ] )))
		wait 0.05;
}

thermal_vision()
{
	self endon ("end_thermal");
	self notifyOnPlayerCommand( "use_thermal", "+actionslot 4" );
	self setWeaponHudIconOverride( "actionslot4", "hud_icon_nvg" );
	self.thermal = false;
	
	while (1)
	{
		wait 0.05; 
		
		self waittill ("use_thermal");
		self turn_on_thermal_vision();
	
		self waittill ("use_thermal");
		self turn_off_thermal_vision();
	}
}

gasmask_on_player_so()
{
	Assert(IsPlayer(self));	

	SetHUDLighting( true );

	self.gasmask_hud_elem = NewClientHudElem( self ); 
	self.gasmask_hud_elem.x = 0;
	self.gasmask_hud_elem.y = 0;
	self.gasmask_hud_elem.alignX = "left";
	self.gasmask_hud_elem.alignY = "top";
	self.gasmask_hud_elem.horzAlign = "fullscreen";
	self.gasmask_hud_elem.vertAlign = "fullscreen";
	self.gasmask_hud_elem.foreground = false;
	self.gasmask_hud_elem.sort = -10; // trying to be behind introscreen_generic_black_fade_in	
	self.gasmask_hud_elem SetShader("nightvision_overlay_goggles", 650, 490);
	self.gasmask_hud_elem.archived = true;
	self.gasmask_hud_elem.hidein3rdperson = true;
	self.gasmask_hud_elem.alpha = 1.0;
	
}

gasmask_off_player_so()
{
	if(isdefined( self.gasmask_hud_elem ))
	{
		self.gasmask_hud_elem destroy();
		SetHUDLighting( false );
	}
}

thermal_vision_remove()
{
	self setWeaponHudIconOverride( "actionslot4", "none" );
	self turn_off_thermal_vision();
	self notify ("end_thermal");
}

turn_on_thermal_vision()
{
	self maps\_load::thermal_EffectsOn();
	
	self ThermalVisionOn();
	self VisionSetThermalForPlayer( "so_sniper_hamburg_thermal", 0 );//uav_flir_Thermal //so_sniper_hamburg_thermal
	self playsound("item_nightvision_on");
	
	self.thermal = true;
	self gasmask_on_player_so();
	wait 0.5;//to avoid audio collision
}

turn_off_thermal_vision()
{
	self maps\_load::thermal_EffectsOff();
	
	self ThermalVisionOff();
	self playsound("item_nightvision_off");
	
	self.thermal = false;
	self gasmask_off_player_so();
	wait 0.5;//to avoid audio collision
}

wait_till_guys_in_lz_are_cleared()
{
	vol = GetEnt( "landing_zone", "targetname" );
	guys = vol get_ai_touching_volume( "axis" );
	
	while (guys.size > 2)
	{
		guys = find_guys_and_remove_dead( vol, guys );
		wait 1;
	}
		
	while (guys.size > 0)
	{
		guys = find_guys_and_remove_dead( vol, guys );
		array_thread( guys, ::set_goal_to_player);

		wait 0.05;
	}
	
	flag_wait("tanks_dead");
	flag_set( "all_clear" );
}

set_goal_to_player()
{
	if (isdefined(self))
	{
		self cleargoalvolume();
		self SetGoalPos(level.ground_guy.origin);
		self.goalradius = 400;
	}
}

find_guys_and_remove_dead( vol, group )
{
	group = vol get_ai_touching_volume( "axis" );
	group array_removedead( group );
	
	return group;
}

kill_all_close_enemies( targetname )
{
	volume = GetEnt( targetname, "targetname" ); 
	guys = volume get_ai_touching_volume( "axis" );
	
	array_call (guys, ::kill);
}

playfx_then_stop(effect, org, flg, rot)
{
	tag1 = spawn_tag_to_loc(org);
	tag1 rotateto((180,180,0), 0.1); //because this function is used for the green smoke and the roatation is necessary
		
	playFXontag( getfx( effect ), tag1, ( "tag_origin" ) );
	
	flag_wait(flg);
	stopFXontag( getfx( effect ), tag1, ( "tag_origin" ) );
}

get_rider_off_heli()
{
	flag_wait ( "player2_get_off" );
	thread timer(10, "force_player_off");
	
	level.air_guy thread force_player_off_heli();
	level.air_guy disableinvulnerability();
	
	level.air_guy monitor_player_get_on_heli(undefined, 1);
	flag_set ( "player2_got_off" );

}

force_player_off_heli()
{
	level waittill ("force_player_off");
	
	if ( self.lilbros[ "is_on_heli" ] )
		self get_guy_off_heli();
	
	flag_set ( "player2_got_off" );

}

//--------------------------------------------------------------------------------------------------------------

setup_location0_start()
{
	flag_set("timer_start");
	

		
	//flying along the river----------
	heli_change_path("start_takeoff");

	//start countdown timer 
	thread start_countdown( 30, &"SO_HELISWITCH_BERLIN_HINT_HELP_ARRIVING", "timer_complete", level.ground_guy );
	
	if ( isdefined( level.air_guy ))
		level.air_guy get_guy_on_heli( level.left_middle );
}

setup_location1_street()
{
	
	level.players[0] endon ("death");
	
	if(is_coop())
		level.players[1] endon ("death");
	
	level.heli.rider_shoot_dist = 1000;

	play_green_smoke( "give_obj_1_meet_at_bank", "green_smoke_bank_origin", "obj_meet_at_bank_complete" );

	flag_wait( "littlebird_arrived_bank" );
	thread wait_till_guys_in_lz_are_cleared();
	
	if (!flag( "all_clear" ))
	{
		heli_change_path( "hover_path_to_clear_lz" );
		flag_wait ( "all_clear");
		heli_change_path( "coming_in_for_landing", "all_clear" );
	}

	//landing at the LZ----------
	heli_land( "land_node_bank", "littlebird_land_bank" );
	
	if ( !level.single_player  )
	{
		level.air_guy thread player_linkto_offset_position( level.left_back_facing, 2 );
		delaythread ( 2.1, ::lock_view );
	}
		
	kill_all_close_enemies("bank_volume");
	
	level.ground_guy monitor_player_get_on_heli( level.right_back_facing );
	flag_set ("vo_come_aboard");

	wait_till_all_onboard( );
	
	//array_call(level.players, ::enableinvulnerability);
	
	array_thread (level.players, ::reduce_kick);
	
	level.ground_guy LerpViewAngleClamp( 0.5, 0.5, 0, 75, 75, 25, 75 );	

	switch_roles( );
	
	//taking off to the top of the building----------
	add_global_spawn_function( "axis", ::monitor_attacker );
	
	activate_trigger_with_noteworthy( "onslaught_at_bank" );	

	heli_takeoff( 64 );
	flag_set("obj_meet_at_bank_complete");

	heli_change_path( "bank_exit_path" );
	
	//when objective complete kill remaining guys----------
	thread kill_bonus_function();

	thread kill_stragglers("bank_volume", "drop_off_upper_roof", "bank_spawners");
}

kill_bonus_function()
{
	flag_wait("switch_player_positions3");
	remove_global_spawn_function( "axis", ::monitor_attacker );
}

play_green_smoke(flg1, struct, flg2)
{
	flag_wait(flg1);
	org = GetStruct( struct, "targetname" );
	thread playfx_then_stop( "extraction_smoke", org, flg2, 1);
}

lock_view()
{
	level.air_guy LerpViewAngleClamp( 0.5, 0.5, 0, 75, 75, 25, 75 );	
}

reduce_kick()
{
	self SetViewKickScale( 0.0 );
	level.health_reduction = 1;
	
	self waittill( "damage", amount, attacker, direction_vec, point, type, modelname, tagName, partName, dflags, weapon );
	
	if ( attacker == self )
		self kill();
}

setup_location2_aa_building()
{
	level.players[0] endon ("death");
	
	if(is_coop())
		level.players[1] endon ("death");
	
	level.heli.rider_shoot_dist = 500;
	
	thread onslaught( "reserve_for_doorway", "trigger_stairway_guys", "move_heli_to_loc4", 100 );
	
	thread kill_second_floor_guys( "start_upper_floor_circle", "start_smoke_ambush" );
	
	thread stop_heli_from_flying_through_geo();	

	handle_switching_heli_seats();

	heli_change_path( "upper_roof_begin_loop" );
	
	heli_change_path( "loc2_path_around_building", "upper_roof_switch_path2", 20, 20, 45 );
	
	smoke_grenade_ambush();
	
	player2_branch_handler();
}

setup_location3_roof2()
{
	level endon( "missionfailed" );
	level.players[0] endon ("death");
	
	if(is_coop())
		level.players[1] endon ("death");
	
	level.heli.rider_shoot_dist = 500;
	
	thread kill_stragglers( "second_floor_volume", "kill_second_floor_stragglers");
	
	if_bleedout_when_on_heli();
	
	play_green_smoke("obj_arm_bomb_complete", "green_smoke_lower_roof_origin", "littlebird_land_at_extraction" );
	
	heli_land("landed_node_extraction", "littlebird_arrived_at_extraction");

 	if ( !level.single_player )
 	{
 		level.players[0].lilbros["seat_id"] = level.right_back;
 		level.players[1].lilbros["seat_id"] = level.right_front;
 		
 	  level.players[0] thread monitor_player_get_on_heli( level.players[0].lilbros["seat_id"], undefined, 1 );
 		level.players[1] thread monitor_player_get_on_heli( level.players[1].lilbros["seat_id"], undefined, 1 );
  }
  else
 	 level.players[0] thread monitor_player_get_on_heli( level.right_front, undefined, 1 );
  
	wait_till_all_onboard();
	
	switch_roles();
	flag_set("exit_flight");
	
	level notify ("bomb_sequence");
	
	heli_takeoff( 64 );
	
	heli_change_path( "exit_path" );
}
//---------------------------------------------------------------------------------------------------------


modify_accuracy_basedOnDist()
{
	default_Bacc = self.baseaccuracy;
	default_acc = self.accuracy;
	
	combat_dist = 700;
	
	if ( level.gameskill < 2 )
		combat_dist = 800;
	
	while( isalive( self ) )
	{
		dist = distance( level.ground_guy.origin, self.origin);
		
		if (dist > combat_dist)
		{
			self.baseaccuracy = ( combat_dist / dist ) * default_Bacc;
			self.accuracy = ( combat_dist / dist ) * default_acc;
		}
		wait 0.05;
	}
}

if_bleedout_when_on_heli()
{
	if (!level.single_player)
		array_thread(level.players,:: monitor_buddy_bleedout);
}

monitor_buddy_bleedout()
{
	buddy = get_other_player(self);
	while (1)
	{
		wait 0.05;
		
		if (buddy.laststand)
		{
			foreach (p in level.players)
			{
				if (p.lilbros[ "is_on_heli" ] && !p.laststand)	
				{
					p monitor_player_get_on_heli();
					
					buddy waittill( "revived" );
					wait 0.5;										//in case the players are right on top of the chopper when downed, wait a bit to allow the prompt to appear
					p monitor_player_get_on_heli(p.lilbros["seat_id"]);
				}
			}
		}
	}
}

handle_switching_heli_seats()
{
	//flag_wait( "ready_to_land_upper_roof" );
	flag_wait( "switch_player_positions3" );
	wait 1;
	
	level notify ("end_bonus_parkway");
	
	
	//flag_set("goal_yaw_norm");
	
	level.heli SetHoverParams( 32, 20, 35 );
	
	level.ground_guy disableinvulnerability();
	
	if (!level.single_player)
		level.air_guy disableinvulnerability();

	level.ground_guy monitor_player_get_on_heli();
	
	//flag_clear("goal_yaw_norm");
	flag_set ( "drop_off_upper_roof" );
	
	
	if (!level.single_player)
		level.air_guy thread player_linkto_offset_position( level.right_middle, .5 );
	
	wait .75;
}


player2_branch_handler()
{
	if (level.single_player)
		heli_change_path( "final_heli_path", "player2_path_option" );
	else
	{
		heli_change_path( "path_for_player2_getoff", "player2_path_option");
		
		thread get_rider_off_heli();

		flag_wait ("player2_got_off");

		
		level.air_guy notify ("end_monitor");
		heli_change_path( "final_heli_path_player2", "player2_path_end" );
	}
}

start_countdown(time, text, flg, only_me)
{
	thread so_enable_countdown_timer( time, false, text, undefined, only_me );
	wait time;
	
	if (isdefined (flg))
		flag_set(flg);
	else
		return true;
}

start_bomb_countdown()
{
	time = 60; 
	
	thread so_enable_countdown_timer( time, false, &"SO_HELISWITCH_BERLIN_HINT_DETONATION" );
	thread so_destroy_countdown_timer (level.elements[0], level.elements[1], "exit_flight" );
	thread timer(time, "bomb_sequence" );
	
	level waittill ("bomb_sequence");
}

timer(time, note)
{
	wait time;
	level notify (note);
}


//----------------------------------------------------------------------------------------------------------------------------
//																BRIEFCASE BOMB
//                     NOTE: THE BOMB IS BEING ARMED NOT DEFUSED
//----------------------------------------------------------------------------------------------------------------------------

setup_bombs()
{
	//gather master briefcase bomb and get possible locations
	level.briefcase_bomb = GetEnt( "intel_master", "targetname" );

	level.briefcase_bomb thread defuse_c4_light (level.briefcase_bomb);
	level.briefcase_bomb thread make_bomb_usable();
	
	intel_locs = GetEntArray( "intel_locs", "targetname" );
	place_bomb_in_random_location(intel_locs, level.briefcase_bomb);
	
	level.shiny_bomb = make_shiny_bomb(level.briefcase_bomb);
	
	level.briefcase_bomb hide();
	
	level waittill ( "bomb_armed_success" );

	flag_set("obj_arm_bomb_complete");
	thread blow_up_building();
	
	//level.briefcase_bomb hide();
}

make_shiny_bomb(item)
{
	model = "viewmodel_briefcase_bomb_mp_obj";
	bomb = spawn( "script_model", item.origin );
	bomb setmodel( model );
	bomb angles_and_origin( item );
	return bomb;
}

blow_up_building()
{
	start_bomb_countdown();
	
	if (!flag( "exit_flight" ))
		wait .25;
	else
	  wait 7.5;

	explosion_sound = GetEnt( "building_explosion_sound", "targetname" );
	explosion_sound Playsound ( "blin_building_collapse_main", "sound_played" );
	explosion_locs = GetEntArray( "building_splode", "targetname" );
	
	foreach(loc in explosion_locs)
	{
		etag = spawn_tag_to_loc( loc );
		playFXontag( getfx( "building_explosion2" ),etag, "tag_origin" );
		loc Playsound ( "sam_detonate", "sound_played" );
		
		wait (randomfloatrange(0.05, 0.1));
	}
	
	foreach (p in level.players)
		earthquake( 0.4, 2, p.origin, 1000 );
	
	kill_all_near_building();
	
	flag_set( "buliding_destroyed" );
}

kill_all_near_building()
{
	kill_volumes = getentarray("building_splode_vol", "script_noteworthy");
	
	foreach (vol in kill_volumes)
	{
		guys = vol get_ai_touching_volume( "all" );
		
		foreach (guy in guys)
		{
			if (isalive(guy))
			{
				guy kill();
				
				//-------------------------
				//  for level bonuses
				//-------------------------
				level.bonus2_num ++;
				
				foreach (p in level.players)
				{
					p.bonus_2 ++;
				}
			}
		}
		foreach (p in level.players)
			p notify ("bonus2_count", p.bonus_2);
	}
	
	thread keep_killing_guys(kill_volumes);
	
	if (!flag("exit_flight"))
	{
		foreach (p in level.players)
		{
			if (!p.lilbros[ "is_on_heli" ])
				p thread white_out();
		}
		end_mission_fail();
	}
}

keep_killing_guys(kill_volumes)
{
	while (1)
	{
		wait 0.05;
		foreach (vol in kill_volumes)
		{
			guys = vol get_ai_touching_volume( "all" );
			array_call (guys, ::kill);
		}
	}
}

white_out()
{
	white_overlay = create_client_overlay( "white", 0, self );
	
	white_overlay fadeOverTime( .12 );
	white_overlay.alpha = 1;

	wait( .3 );
}

make_bomb_usable()
{
	self ent_flag_init( "briefcase_bomb_defused" );

	while( !self ent_flag( "briefcase_bomb_defused" )  )
	{
		self makeusable();
		self sethintstring( &"SO_HELISWITCH_BERLIN_HINT_DEFUSE_BOMB" );
			
		self waittill( "trigger", player );
			
		stance = player getstance();
		if (stance == "prone")
			player thread show_message_noprone(1.5);
		else
		{
			if (isdefined(player.noprone) && player.noprone)
					player forceusehintoff();
						
			self MakeUnusable();
			player briefcase_arm( self ); ///player used to be ground_guy
			wait 1.5;//buffer time between tries
		}
	}
}

show_message_noprone(time)
{
	self forceusehintoff();
	self forceusehinton(&"SO_HELISWITCH_BERLIN_HINT_NOPRONE");
	
	self.noprone = true;
	wait time;
	
	self forceusehintoff();
	self.noprone = false;
}


briefcase_arm( briefcase )
{
	stance = self getstance();
	root = spawn_tag_to_loc(self);
	self playerlinkto (root);
	
	level endon( "special_op_terminated" );
	
	// get current weapon and save for later
	lastWeapon = self getCurrentWeapon();

	self give_briefcase_and_handle_weapons();

	level.shiny_bomb hide();

	self thread Downed_While_Defusing( lastWeapon, briefcase );
	self thread Leave_Area_While_Defusing( lastWeapon, briefcase );

	self waittill_either( "laststand_downed", "weapon_change" );
	
	thread show_bomb_on_success();

	if ( self isonground() && stance != "prone" && !self ent_flag_exist( "laststand_downed" ) || !self ent_flag( "laststand_downed" ) || !flag("player_left_area"))
	{
		// Add 3D Person Briefcase
		self attach_briefcase_model();

		if ( stance != "prone" && !self ent_flag_exist( "laststand_downed" ) || !self ent_flag( "laststand_downed" ) || !flag("player_left_area") )
		{
			// display usebar
			if ( self defuse_use_bar( 4.5, briefcase ) )
			{
				briefcase ent_flag_set( "briefcase_bomb_defused" );
				level notify ( "bomb_armed_success" );
			}
			else
			{
				level.shiny_bomb delaycall ( 0.5, ::show );
			}
		}
	}
	self detach_briefcase_model();
	
	self thread return_regular_controls( lastweapon, stance, root );

}

give_briefcase_and_handle_weapons()
{
	self giveWeapon( "briefcase_bomb_defuse_sp" );
	self setWeaponAmmoStock( "briefcase_bomb_defuse_sp", 0 );
	self setWeaponAmmoClip( "briefcase_bomb_defuse_sp", 0 );
	self switchToWeapon( "briefcase_bomb_defuse_sp" );
	self DisableWeaponSwitch();
	self DisableOffhandWeapons();
	self AllowMelee( false );
}

return_regular_controls(lastweapon, stance, root)
{
	if (stance != "stand")
		self setstance( stance);
		
	self unlink();
	root delete();
	
	while (self.laststand)
		wait 0.05;

	primary_weapons = self GetWeaponsListPrimaries();

	if ( !is_in_array( self GetWeaponsListPrimaries(), lastWeapon ) )
		lastWeapon = primary_weapons[0];

	self switchToWeapon( lastWeapon );

	wait 1; // buffer time between tries.

  self thread enable_weapons_after_last_stand();
}

enable_weapons_after_last_stand()
{
	while(self.laststand)
		wait 0.05;
	
	self AllowMelee( true );
	self EnableOffhandWeapons();
	self EnableWeaponSwitch();	
	
}

show_bomb_on_success()
{
	level waittill ( "bomb_armed_success" );
	wait .5;
	level.briefcase_bomb show();
	tag = spawn_tag_origin();
	tag.origin = ( level.briefcase_bomb.origin[0], level.briefcase_bomb.origin[1], level.briefcase_bomb.origin[2] +2 );
	PlayFXontag( level._effect[ "light_c4_blink" ], tag, "tag_origin" );
	PlayFXontag( level._effect[ "light_c4_blink_nodlight" ], tag, "tag_origin" );
}

downed_while_defusing( lastWeapon, briefcase )
{
	if ( self ent_flag_exist( "laststand_downed" ) )
	{
		briefcase endon( "briefcase_bomb_defused" );
		self ent_flag_wait( "laststand_downed" );

		self SwitchToWeaponImmediate( lastWeapon );
	}
}

Leave_Area_While_Defusing( lastWeapon, briefcase )
{
	briefcase endon( "briefcase_bomb_defused" );
	
	while (1)
	{
		if (flag("player_left_area"))
			flag_clear ("player_left_area");

		if (self getcurrentweapon() == "briefcase_bomb_defuse_sp" )
		{

			while (distance(self.origin, briefcase.origin) < 128)
				wait 0.05;
		
			self SwitchToWeaponImmediate( lastWeapon );
			flag_set ("player_left_area");
			wait 0.5;
		}
		wait 0.05;
	}
}

attach_briefcase_model()
{
	wait ( 0.6 );
	self attach( "prop_suitcase_bomb", "tag_inhand", true );
}

detach_briefcase_model()
{
	self endon ("death");
	wait ( 0.1 );
	if(isalive(self) && !self ent_flag_exist( "laststand_downed" ) || !self ent_flag( "laststand_downed" ))
		self detach( "prop_suitcase_bomb", "tag_inhand", true );
}

use_active()
{
	if ( !self UseButtonPressed() )
		return false;
	if ( flag( "special_op_failed" ) )
		return false;
	if ( self ent_flag_exist( "laststand_downed" ) && self ent_flag( "laststand_downed" ))
		return false;
	if ( flag( "player_left_area" ) )
		return false;

	return true;
}

defuse_use_bar( fill_time, briefcase )
{
	briefcase.defuse_time = 0;

	buttonTime = briefcase.defuse_time;
	totalTime = fill_time;
	bar = self createClientProgressBar( self, 57 );

  text = self createClientFontString( "default", 1.2 );
  text setPoint( "CENTER", undefined, 0, 45 ); // old 20
	text settext( &"SO_HELISWITCH_BERLIN_HINT_DEFUSING" );

	while ( self use_active() )
	{
		bar updateBar( buttonTime / totalTime );
		wait( 0.05 );
		buttonTime += 0.05;
		if ( buttonTime > totalTime )
		{
			text destroyElem();
			bar destroyElem();
			return true;
		}
	}

	briefcase.defuse_time = buttonTime;
	text destroyElem();
	bar destroyElem();

	return false;
}

defuse_c4_light( briefcase )
{
	if ( self.model == "weapon_c4" )
	{
		wait randomfloat( 0.5 );
		fx = PlayLoopedFX( getfx( "light_c4_blink_nodlight" ), 1, self gettagorigin( "tag_fx" ) );
		briefcase ent_flag_wait( "briefcase_bomb_defused" );
		fx delete();
	}
}

place_bomb_in_random_location(intel_locs, intel_tag)
{
	num = randomint(intel_locs.size);
	intel_tag angles_and_origin(intel_locs[num]);
}

//----------------------------------------------------------------------------------------------------------------------------
//																BRIEFCASE BOMB END
//----------------------------------------------------------------------------------------------------------------------------

dialogue()
{
	if (!level.single_player)
	{
		vo_with_flag( "vo_tanks1", "so_heliswitch_plt_11oclock");
		
		flag_wait("vo_tanks2");
		if( !flag( "tanks_dead" ))
			radio_dialogue( "so_heliswitch_plt_illstaybehind" );
	}
	thread vo_with_flag( "hover_over_lz", "so_heliswitch_plt_gotenemies" );
	thread vo_with_flag( "player2_path_end", "so_heliswitch_plt_extractionpoint" );

	vo_with_flag( "give_obj_1_meet_at_bank", "so_heliswitch_plt_takeitslow" );
	vo_with_flag( "ground_guy_progress1", "so_heliswitch_plt_movingahead" );
	vo_with_flag( "all_clear", "so_heliswitch_plt_lzclear");
	vo_with_flag( "vo_come_aboard", "so_heliswitch_plt_gottaliftoff" );
	vo_with_flag( "obj_meet_at_bank_complete", "so_heliswitch_plt_herewego" );
	vo_with_flag( "obj_meet_at_bank_complete", "so_manhattan_hqr_newdirective" );
	flag_set( "obj_meet_at_bank_vo_done" ); 
	
	vo_with_flag( "switch_player_positions2", "so_heliswitch_plt_dropoff");
	vo_with_flag( "ready_to_land_upper_roof", "so_heliswitch_plt_jumpoff");
	vo_with_flag( "vo_goodluck", "so_heliswitch_plt_goodluck");
	vo_with_flag( "vo_another_pass", "so_heliswitch_plt_comingaround");
	vo_with_flag( "vo_changing_positions", "so_heliswitch_plt_changingpositions");
	vo_with_flag( "trigger_stairway_guys", "so_heliswitch_plt_eyeson");
	vo_with_flag( "start_upper_floor_circle", "so_heliswitch_plt_movingahead2");
	
	flag_wait("start_smoke_ambush");
	wait 2;
	radio_dialogue( "so_heliswitch_plt_droppedsmoke" );
	
	if (level.single_player)
		radio_dialogue( "so_heliswitch_plt_thermal" );
	else
		radio_dialogue( "so_heliswitch_plt_tothermal" );

	vo_with_flag( "bread_crumb_bomb_2", "so_heliswitch_plt_onthisfloor");
	vo_with_flag( "kill_second_floor_stragglers", "so_heliswitch_plt_findbriefcase");
	vo_with_flag( "obj_arm_bomb_complete", "so_heliswitch_plt_bombisarmed");
	vo_with_flag( "littlebird_arrived_at_extraction", "so_heliswitch_plt_atrendezvous");
}

vo_with_flag(flg, vo)
{
		flag_wait(flg);  	
		radio_dialogue( vo);
}

music()
{
	MUS_play ( "so_bln_player_unloaded_from_intro_flight", 2 );
	
	flag_wait ("give_obj_1_meet_at_bank");
	MUS_play("so_bln_enter_aa_building_combat");
	
	flag_wait("drop_off_upper_roof");
	MUS_play ( "so_bln_bridge_battle_all_tanks_dead", 2 );
	
	flag_wait("start_smoke_ambush");
	MUS_play ( "so_bln_player_unloaded_from_intro_flight", 2 );
	
	flag_wait("obj_arm_bomb_complete");
	MUS_play ( "so_bln_player_unloaded_from_intro_flight", 2 );
}


spawn_tag_to_loc(move_to)
{
	tag1 = spawn_tag_origin();
	tag1 angles_and_origin(move_to);
	return tag1;
}
	
angles_and_origin(move_to)
{
	self.origin = move_to.origin;
	
	if (isdefined(move_to.angles))
		self.angles = move_to.angles;
}

smoke_grenade_ambush()
{
	flag_wait("start_smoke_ambush");
	
	array_thread (level.players, ::switch_to_thermal_reminder);
	
	smoke_origin = GetStructarray( "smoke_origin", "targetname" );
	smoke_grenades = GetEntArray( "smoke_grenade_ambush", "targetname" );
		
	flag_set( "trigger_rappel_guys" );
	
	i = 0;
	foreach( struct in smoke_origin)
	{
		playFX( getfx( "smokescreen" ), struct.origin );
		smoke_grenades[i] Playsound ( "exp_9_bang", "sound_played" );
		i++ ;
		wait .34;
	}
}

switch_to_thermal_reminder()
{
	wait 3; //the flag is a bit imprecise
	i = 0;
	if (!level.single_player)
	{
  	if ( !self.thermal )
  	{
  		self forceusehinton( &"SO_HELISWITCH_BERLIN_HINT_SWITCH_THERMAL");
  		stop_thermal_reminder();
  		
  		if(!self.thermal)
  		{
  			self text_effects( &"SO_HELISWITCH_BERLIN_HINT_THERMAL_NAG", "stop_thermal", 3);
  			stop_thermal_reminder();
  		}
  	}

 		self forceusehintoff( );
	}
}

stop_thermal_reminder()
{
	level endon ("stop_thermal" );

	if(!ent_flag_exist("stop_thermal"))
		self ent_flag_init("stop_thermal");
	
	thread timer(4, "stop_thermal");
	
	while (1)
	{
		wait 0.05;
		 
		if (self.thermal)
		{
			ent_flag_set("stop_thermal");
			break;
		}
  }
}

text_effects(text_string, end_flag, time)
{
	if(!isdefined(time))
		time = 10;
	
	self.thermal_nag = self maps\_shg_common::create_splitscreen_safe_hud_item( 3.5, 0, text_string );
	self.thermal_nag.alignx = "center";
	self.thermal_nag.horzAlign = "center";
	
	for(i = 0; i < time; i++)
	{
		if(!ent_flag(end_flag))
		{
			self.thermal_nag.alpha = 1;
			self.thermal_nag FadeOverTime( 1 ) ;
			self.thermal_nag.alpha = 0.5;
			
			self.thermal_nag.fontscale = 1.25;
			self.thermal_nag ChangeFontScaleOverTime( 1 );
			self.thermal_nag.fontscale = .75;
			
			wait 1;
		}
	}
		
	foreach(p in level.players)
	{
		if(isdefined(p.thermal_nag))
			p.thermal_nag Destroy();
	}
}



//---------------------------------------------------------------------------------------------
//										RAPPEL LOGIC
//---------------------------------------------------------------------------------------------

setup_rappel_guys()
{
	rappel_rope = getentarray("rappel_rope", "targetname");
	assert (rappel_rope.size > 0);
	
	foreach (rope in rappel_rope)
		rope hide();
	
	flag_wait("trigger_rappel_guys");
	rappel_guy_org = getentarray("rappel_guy_origin", "targetname");
	rappel_spawners = getentarray("rappel_spawners", "script_noteworthy");

	number_of_rappelers = 4;
	if (level.single_player)
		number_of_rappelers = 2;
		
	n = 0;
	for (i = 0; i < number_of_rappelers; i++)
	{
		guy = rappel_spawners[n] spawn_ai(true);
		if (isdefined(guy) && isdefined(rappel_guy_org[n]) && isdefined(rappel_rope[n]))
		{
			guy thread rappel_from_roof(rappel_guy_org[n], rappel_rope[n]);
		}
		if (n < (rappel_spawners.size -1))
			n++;
		else
			n = 0;
			
		time = randomfloatrange(.75, 1.25);
		wait time;
	}
	
	flag_wait("player2_path_option");
		
	foreach (rope in rappel_rope)
		rope hide();
}

roof_ai_rappel_death()
{
	self endon( "over_solid_ground" );
	if ( !isdefined( self ) )
		return;
	self set_deathanim( "fastrope_fall" );
	self waittill( "death" );
//	self thread play_sound_in_space( "generic_death_falling" );
}


rappel_from_roof(org, rope)
{
	self endon( "death" );
	self.animname = "generic";
	
	anime = org.animation;
	rope_anim = "rope_over_rail_R";
	
	rope.animname = "rope";
	rope setanimtree();
	
	org anim_generic_reach(self, anime);
	rope show();
	
	self.oldhealth = self.health;
	self.health = 3;
	self.allowdeath = true;
	self thread roof_ai_rappel_death();
	
	if (isdefined(self))
		org thread anim_single_solo(rope, rope_anim);
	if (isdefined(self))
		org anim_generic(self, anime);
}

//---------------------------------------------------------------------------------------------
//										RAPPEL LOGIC END
//---------------------------------------------------------------------------------------------


onslaught(targetname, flg_start, flg_end, target_radius)
{
	if(isdefined(flg_start))
		flag_wait(flg_start);
		
	volume = GetEntArray( targetname, "targetname" );

	while (!flag(flg_end))
	{
		wait 0.5;
		foreach (vol in volume)
		{
			guys = vol get_ai_touching_volume( "axis" );

			foreach (guy in guys)
			{
				guy cleargoalvolume();
				guy SetGoalPos(level.ground_guy.origin);
				guy.goalradius = target_radius;
			}
		}
	}
}

kill_stragglers(vol_targetname, flg, noteworthy )
{
	if (isdefined(flg))
		flag_wait(flg);
		
	volume = GetEnt( vol_targetname, "targetname" );
	
	if ( isdefined( noteworthy ))
	{
		spawners = getentarray(noteworthy, "script_noteworthy");
		array_call( spawners, ::delete );
	}
	
	while (1)
	{
		guys = volume get_ai_touching_volume( "all" );
		array_call( guys, ::kill );

		wait 1;
	}
}

kill_second_floor_guys(flg, flg_end)
{
	flag_wait(flg);
	volume = GetEnt( "upper_roof_volume", "targetname" );
	
	while (!flag(flg_end))
	{
		guys = volume get_ai_touching_volume( "axis" );
		foreach (guy in guys)
		{	
			if (isdefined(guy))
				guy Kill();
			wait (randomfloatRange( 0.05, 0.15 ));
		}
		wait 1;
	}
}

switch_roles()
{
	//swap the level variables for their role. if it's single player, then the player is always ground_guy
	if (level.single_player == false)
	{
		air = level.air_guy;
		level.air_guy = level.ground_guy;
		level.ground_guy = air;
	}
}

handle_equipment()
{
	my_weapon = self getCurrentWeapon();
	
	if (my_weapon == "none")
		my_weapon = level.primary_weapon;
	

	if ( !flag( "tanks_dead" ) && !level.single_player) //if the tanks are NOT dead then this is the opening of the level. in which case give the player the a4
	{
		self takeallweapons();
		primary_weapon = level.pentacular_weapon;
		
		self thread handle_infinite_ammo_during_intro();

		self GiveWeapon( primary_weapon );
		self SwitchToWeapon( primary_weapon );
		self GiveWeapon( "fraggrenade" );
		self SetOffhandSecondaryClass( "flash" );
		self GiveWeapon( "flash_grenade" );
	}
}

heli_change_path(node_to_switch_to, flg_wait, speed, accel, decel )
{
	if ( isdefined( flg_wait ))
		flag_wait(flg_wait);
		
	node = getstruct(node_to_switch_to, "targetname");
	if (!isdefined(speed))
		speed = 10;
	if (!isdefined(accel))
		accel = 5;
	if (!isdefined(decel))
		decel = 15;
		
	level.heli thread maps\_vehicle::vehicle_paths_helicopter ( node );
	level.heli Vehicle_SetSpeed( speed, accel, decel );
}
	
heli_land( targetname, flg )
{
	if ( isdefined( flg ) )
		flag_wait (flg);
		
	node = getstruct( targetname, "targetname" );
	level.heli vehicle_land_beneath_node(32, node, 0);
}

heli_takeoff( height )
{
	level.heli vehicle_liftoffvehicle( height );
}


stop_heli_from_flying_through_geo()
{
	flag_wait("upper_roof_switch_path1");
	
	while (1)
	{
		if (!flag("no_heli_transfer"))
		{
			heli_change_path( "upper_roof_loop" );
			break;
		}
		if (flag("no_heli_transfer") && flag("vo_another_pass"))
		{
			flag_clear("no_heli_transfer");
			flag_clear("vo_another_pass");
		}
		wait 0.05;
	}
}

setup_heli()
{
	level.heli = spawn_vehicle_from_targetname("playerbird_spec");
	
	repulsor = Missile_CreateRepulsorEnt( level.heli, 10000, 1000 );

	level.heli.dont_crush_player = 1;

	setup_player_models_on_heli();
	
	if(level.single_player)
		thread setup_heli_shooter_fakery();

	thread monitor_goal_yaw_for_heli();
	level.heli thread lock_health_at( 30000);
	
	aud_send_msg("so_berlin_intro_littlebird_spawn", level.heli);
	
	thread heli_fail_safe_on_death();
	thread heli_fail_safe_on_success();
	thread heli_set_hover_params();
	array_thread ( level.players, ::resolve_heli_last_stand_conflict );


}


heli_set_hover_params()
{
	flag_wait( "switch_player_positions2" );
	flag_set( "goal_yaw_low" );
}

//===========================================
//                   heli_fail_safe_on_death
//===========================================
heli_fail_safe_on_death()
{
    level endon( "so_heliswitch_berlin_complete" );    
    
    flag_set("special_op_no_unlink");
    
    level waittill( "special_op_terminated" );
    
    if( !IsDefined( level.heli ) )
    {
        return;
    }
    
    level.heli Vehicle_SetSpeedImmediate( 0, 60, 60 );
    
    foreach (p in level.players)
    	p takeallweapons();
}


//===========================================
//                   heli_fail_safe_on_success
//===========================================
heli_fail_safe_on_success()
{
    flag_wait( "so_heliswitch_berlin_complete" );    
    
    foreach (p in level.players)
    	p takeallweapons();
    
    flag_set("special_op_no_unlink");
    
    if( !IsDefined( level.heli ) )
    {
        return;
    }
    
    level.heli Vehicle_SetSpeedImmediate( 0, 60, 60 );
    
    overlay = blackOut();
		overlay thread fadeBlackOut(.5 );
}

//===========================================
//             resolve_heli_last_stand_conflict
//===========================================
resolve_heli_last_stand_conflict()
{
	while( 1 )
	{
		if( self.lilbros[ "is_on_heli" ])
		{
			if( is_player_down( self ))
			{
				waittillframeend;
				self SetStance( "crouch" );
				self.laststand = false;
				self get_guy_off_heli();
				self.laststand = true;
				self SetStance( "prone" );
				self waittill( "revived" );
				self monitor_player_get_on_heli(self.lilbros["seat_id"]);
			}
		}
		
		waitframe();
	}
}

monitor_player_get_on_heli(position, special_case, fix_view)
{
	Assert( IsPlayer( self ) );
	self endon ("end_monitor");
	level endon( "special_op_terminated" );
	
	self thread end_messages( );
	
	while (1)
	{
		if (distance (self.origin, level.heli.origin) < 200 )
		{
			if ( self.lilbros[ "is_on_heli" ] )
			{
				self.p_weapon = self getcurrentweapon();
				self disableweapons();
				self forceusehinton(&"SO_HELISWITCH_BERLIN_HINT_GET_OFF_HELI");
				if (self usebuttonpressed())
				{
					get_guy_off_heli(special_case);
					break;
				}
			}
			else if (!flag("laststand_downed"))
			{
				self forceusehinton(&"SO_HELISWITCH_BERLIN_HINT_USE_TO_BOARD");
				if (self usebuttonpressed())
				{
					get_guy_on_heli( position, fix_view );
					break;
				}
			}
		}
		else
			self forceusehintoff();
		
		wait 0.05;
	}
	self notify ("end_monitor");
}

end_messages()
{
	self waittill ("end_monitor");
	self forceusehintoff();
}

lock_health_at( health_val )
{
	level endon ( "tanks_not_killed" );
	self thread kill_attached_player_if_heli_dies();
	self endon ( "death" );
	self.health = health_val;

	while(1)
	{
		wait(0.05);		
		if (self.health != health_val)
			self notify("so_heli_dmg");
		self.health = health_val;
	}
}

kill_attached_player_if_heli_dies()
{
	self waittill ( "deathspin" ); 
	wait .75;

	foreach (p in level.players)
	{
		if (p.lilbros[ "is_on_heli" ])
		{
			p Unlink();
			p DisableInvulnerability();
			p kill();
		}
	}
}

setup_player_models_on_heli()
{
	level.heli.modelseats = [];
	level.heli.modelseats[0] = 0; 			//pilot
	level.heli.modelseats[1] = 1; 			//right back --player 2 position for exit and player 2 position for flight from bank
	level.heli.modelseats[3] = 3;				//right_front -- player position for exit and ai/player 1 position for building path
	level.heli.modelseats[5] = 5;				//right_middle --confirmed --not used
	level.heli.modelseats[2] = 2; 			//left_back --confirmed --not used
	level.heli.modelseats[4] = 4;				//left_middle //player 2 and ally fake ai
	level.heli.modelseats[6] = 6;				//left_front --confirmed --not used
	
	level.heli.player_seats = [];
	level.heli.player_seats[ level.right_back ] = setup_playerlink_location("heli_org_right_back");  //RIGHT SIDE
	level.heli.player_seats[ level.right_front ] = setup_playerlink_location("heli_org_right_front");  
	level.heli.player_seats[ level.right_middle ] = setup_playerlink_location("heli_org_right_middle");  
	level.heli.player_seats[ level.left_middle ] = setup_playerlink_location("heli_org_left_middle"); //LEFT SIDE
	level.heli.player_seats[ level.right_back_facing ] = setup_playerlink_location("heli_org_right_back_facing"); //for 2 player exit
	level.heli.player_seats[ level.right_front_facing ] = setup_playerlink_location("heli_org_right_front_facing"); //for 2 player landing
	level.heli.player_seats[ level.left_back_facing ] = setup_playerlink_location("heli_org_left_back_facing"); //for 2 player landing
	level.heli.player_seats[ level.left_front_facing ] = setup_playerlink_location("heli_org_left_front_facing"); //for 2 player landing
	
	level.heli.player_seats_jump = [];
	level.heli.player_seats_jump[ level.right_back ] = setup_playerlink_location("heli_org_right_back_jump");  //RIGHT SIDE
	level.heli.player_seats_jump[ level.right_front ] = setup_playerlink_location("heli_org_right_front_jump");  
	level.heli.player_seats_jump[ level.right_middle ] = setup_playerlink_location("heli_org_right_middle_jump");  
	level.heli.player_seats_jump[ level.left_middle ] = setup_playerlink_location("heli_org_left_middle_jump"); //LEFT SIDE
	level.heli.player_seats_jump[ level.right_back_facing ] = setup_playerlink_location("heli_org_right_back_facing_jump"); //for 2 player exit
	level.heli.player_seats_jump[ level.right_front_facing ] = setup_playerlink_location("heli_org_right_front_facing_jump"); //for 2 player landing
	level.heli.player_seats_jump[ level.left_back_facing ] = setup_playerlink_location("heli_org_left_back_facing_jump"); //for 2 player landing
	level.heli.player_seats_jump[ level.left_front_facing ] = setup_playerlink_location("heli_org_left_front_facing_jump"); //for 2 player landing
	
	foreach (guy in level.heli.riders)
	{
		if (level.single_player)
		{
			guy hide();
			guy.name = " ";
		}
		else if( guy != level.heli.riders[0])
			guy delete();
	}
	 
	level.heli.riders[0] show(); //show pilot
	level.heli.riders[0].name = "Col. Munson";
}


setup_heli_shooter_fakery()
{
	level endon( "special_op_terminated" );
	thread create_ai_gun_position( level.left_middle );
	
	if ( !isdefined( level.heli.rider_shoot_dist ))
		level.heli.rider_shoot_dist = 1000;

	while ( level.single_player )
	{
		wait 0.1;
		bad_guys = getaiarray( "axis" );
		if (bad_guys.size > 0)
		{
			if ( randomint(100) > 50 )
				target = choose_target(level.ai_seat, bad_guys, level.heli.rider_shoot_dist); //old level.ai_seat
			else
				target = choose_target(level.ground_guy, bad_guys, level.heli.rider_shoot_dist); //old level.ai_seat
			
			shots = randomintrange( 6,12 );
			
			if ( isdefined( target ) )
			{
				head = target geteye();
				for(i = 0; i < shots; i++)
				{
					gun_pos = level.ai_seat.origin;
					inaccurate_magicbullet( "scar_h_acog", 20, head, gun_pos);
					wait 0.1;
				}
				wait 2.25;
			}
		}
	}
}

choose_target(closest_to, guy_array, range)
{
	shooter = (level.ai_seat.origin[0], level.ai_seat.origin[1], level.ai_seat.origin[2] +50);

	target_array = get_array_of_closest( closest_to.origin, guy_array, undefined, range );
	target = check_against_sight( shooter, target_array );
	return target;
}

check_against_sight(shooter_org, target_array)
{
	foreach (dude in target_array)
	{
		head = dude geteye();
		if ( sightTracePassed( shooter_org, head, false, undefined))
			return dude;
	}
	return undefined;
}


create_ai_gun_position( position )
{
	level.ai_seat = level.heli.riders[ position ];
	level.heli.riders[ position ] show();
	level.heli.riders[ position ].name = "Sgt. Hammer";
	
	// a one time switch to get the ai guy on the correct side of the heli
	flag_wait ( "drop_off_upper_roof" );
	level.ai_seat = level.heli.riders[ level.right_back ];
	level.heli.riders[ level.right_back ] show();
	level.heli.riders[ level.right_back ].name = "Sgt. Hammer";
	level.heli.riders[ position ] hide();
	level.heli.riders[ position ].name = " ";
}

inaccurate_magicbullet(gun, offset_range, target_pos, shooter_pos)
{
	if (all_isdefined(gun, offset_range, target_pos, shooter_pos))
	{
		xx = (target_pos[0] + randomfloatrange(offset_range * -1, offset_range));
		yy = (target_pos[1] + randomfloatrange(offset_range * -1, offset_range));
		zz = (target_pos[2] + randomfloatrange(offset_range * -1, offset_range));
		
		shooter = (shooter_pos[0], shooter_pos[1], (shooter_pos[2] + 50));
		target = (xx, yy, zz);
		
		if (sightTracePassed(shooter, target, false, undefined))
			magicbullet( gun, shooter, target);
	}
}

all_isdefined(item1, item2, item3, item4 )
{
	if (isdefined(item1))
	{
		if (isdefined(item2))
		{
			if (isdefined(item3))
			{
				if (isdefined(item4))
					return true;
				else
					return false;
			}
			else
				return false;
		}
		else
			return false;
	}
	else
		return false;
}

setup_playerlink_location(org_targetname)
{
	seat_position = getent(org_targetname, "targetname");

	tag_for_heli = spawn_tag_to_loc(seat_position);
	tag_for_heli linkto(level.heli, "tag_origin");
	
	return tag_for_heli;
}

monitor_goal_yaw_for_heli()
{
	while ( level.single_player == false )
	{
		wait 0.05;
		if (flag("goal_yaw_norm"))
		{
			level.heli SetMaxPitchRoll(30, 30);
			flag_clear("goal_yaw_norm");
		}
		
		if (flag("goal_yaw_low"))
		{
			level.heli SetMaxPitchRoll(0, 0);
			level.heli SetHoverParams( 32, 20, 35 );
			flag_clear("goal_yaw_low");
		}
	}
}

player_linkto_offset_position(position, time, fix_view)
{
	if (!isdefined ( time ))
		time = 0.1;
	self PlayerLinkToblend(level.heli.player_seats[position], "tag_origin", time);
	wait time;
	
	if (isdefined(fix_view))
	{
		//self LerpViewAngleClamp( 0.5, 0.5, 0.1, 5, 5, 5, 5 );	
		wait 0.5;
	}
	
	assert( isdefined(self.lilbros["limit_right_arc"]  ) );
	assert( isdefined(self.lilbros["limit_left_arc"]   ) );
	assert( isdefined(self.lilbros["limit_top_arc"]    ) );
	assert( isdefined(self.lilbros["limit_bottom_arc"] ) );
	
	self PlayerLinkToDelta(level.heli.player_seats[position], "tag_origin", 0, self.lilbros["limit_right_arc"], self.lilbros["limit_left_arc"], self.lilbros["limit_top_arc"], self.lilbros["limit_bottom_arc"], true);
	self.lilbros["seat_id"] = position;
}

player_jump_offset_position(position, time)
{
	if (!isdefined ( time ))
		time = 0.1;
	self PlayerLinkToblend(level.heli.player_seats_jump[position], "tag_origin", time);
	wait time;
}

player_movement_limits( enforced )
{
	self allowstand(enforced);

	if (enforced == true)
	{
		wait 1;
		self allowcrouch (false);
		wait 0.1;
		self allowcrouch (true);
	}
	
	self allowprone(enforced);
	self allowmelee(enforced);
	self allowsprint(enforced);
}

get_guy_on_heli(position, fix_view)
{
	assert( isdefined(self) );
	player_linkto_offset_position(position, undefined, fix_view);
	self.lilbros[ "is_on_heli" ] = true;
	self.lilbros["seat_id"] = position;
	//self EnableInvulnerability();
	self thread player_movement_limits(false);
	self thread handle_equipment();
	self notify ("heli_switch");
}

get_guy_off_heli(special_case)
{
	assert( isdefined(self) );
	self enableinvulnerability(); //just in case the player jumps off when the heli isn't stationary
	player_jump_offset_position(self.lilbros["seat_id"], .5);
	self thread player_movement_limits(true);
	//self DisableInvulnerability();
	self.lilbros[ "is_on_heli" ] = false;
	self unlink();
	self delaycall(1, ::disableinvulnerability);
	
	if ( !isdefined( special_case ))
		self notify ("get_off_heli");
	self enableweapons();
	
	self notify ("heli_switch");
}

wait_till_all_onboard()
{
	onboard = 0;
	while ( onboard < level.players.size )
	{
		wait 0.05;
		onboard = 0;
		foreach( p in level.players )
		{
			if( p.lilbros[ "is_on_heli" ] == true )
				onboard++;
		}
	}
}


//------------------------------------------------------------------------------------------
setup_tank()
{
	level.tanks = 0;

	level.tank1 = GetEnt( "tank1", "targetname" );
	level.tank2 = GetEnt( "tank2", "targetname" );
	level.tank3 = GetEnt( "tank3", "targetname" );
	tanks = [ level.tank1, level.tank2, level.tank3 ];

	//hide the 50 cal turret
	foreach (tank in tanks)
	{
		turret = tank.mgturret[1];
		turret SetMode( "manual" );
		turret hide();
	}
	
	tank_coll = getentarray("tank_coll1", "targetname");
	if (!level.single_player)
	{
		//spawn dummy target
		spawner = GetEnt( "ally_for_tank", "script_noteworthy" );
		target = spawner spawn_ai(true);
		target thread deletable_magic_bullet_shield();
		target thread delete_when_tanks_are_dead();
		target hide();
		
		i = 0;
		foreach (tank in tanks)
		{
			tank thread create_target_on_tank();
			tank thread hs_tank_fire_at_enemies("ally_for_tank");
			tank thread tanks_target_players_when(target);
			tank thread monitor_tank_is_dead(tank_coll[i]);
			tank gopath();
			i++;
		}
		
	wait_until_tanks_dead(tanks);
		
	}
	else
	{
		foreach(tank in tanks)
			tank delete();
	}
	
	flag_set ( "tanks_dead" );
}

delete_when_tanks_are_dead()	
{
	flag_wait("tanks_dead");
	
	if ( isdefined( self ))
		self delete();
}
	

create_target_on_tank()
{
	Target_Set ( self, (0, 0, 16 ) );
	Target_SetShader( self, "veh_hud_target" );
	Target_HideFromPlayer ( self, level.ground_guy );
	
	self waittill ("im_dead");
	Target_Remove ( self );
}

monitor_tank_is_dead(coll)
{
	while (self.health > 0)
		wait 0.05;
		
	coll angles_and_origin( self );
	self notify ("im_dead");
	level.tanks++;
}

wait_until_tanks_dead(tanks)
{
	while (level.tanks < tanks.size)
		wait 0.05;
}

tanks_target_players_when(target)
{
	flag_wait( "give_obj_1_meet_at_bank" );

	if (!flag( "tanks_dead" ) && self.health > 0)
	{
		self notify ("stop_random_tank_fire");
		level notify ( "tanks_not_killed" );
		wait 1;
		self thread hs_tank_fire_at_enemies(undefined, level.players);
	}
}

//-----------------------------------------------------------------------------------------

fx_setup()
{
		level._effect[ "light_c4_blink_nodlight" ] 				= loadfx( "misc/light_c4_blink_nodlight" );
		level._effect[ "light_c4_blink" ] 								= loadfx( "misc/light_c4_blink" );
		level._effect[ "extraction_smoke" ]								= LoadFX( "smoke/signal_smoke_green" );
		level._effect[ "smokescreen" ]     								= LoadFX( "smoke/smoke_grenade_low" );
		level._effect[ "building_explosion" ]     				= LoadFX( "explosions/building_explosion_gulag" );
		level._effect[ "building_explosion2" ]     				= LoadFX( "explosions/bridge_explode" );
		level._effect[ "building_fire" ]     							= LoadFX( "fire/fire_tree_slow_london" );
}

#using_animtree( "generic_human" );
generic_human()
{
	level.scr_anim[ "generic" ][ "fastrope_fall" ]			 		= %fastrope_fall;
	level.scr_anim[ "generic" ][ "oilrig_rappel_2_crouch" ]	= %oilrig_rappel_2_crouch;
	level.scr_anim[ "generic" ][ "oilrig_rappel_over_rail_R" ]	= %oilrig_rappel_over_rail_R;
	
	addNotetrack_customFunction( "generic", "over_solid", ::ai_rappel_over_ground_death_anim, "oilrig_rappel_over_rail_R" );
	addNotetrack_customFunction( "generic", "feet_on_ground", ::ai_rappel_reset_death_anim, "oilrig_rappel_over_rail_R" );
}

#using_animtree( "script_model" );
script_model_anims()
{
	//RAPPEL ROPES
	level.scr_animtree[ "rope" ] 									= #animtree;	
	level.scr_anim[ "rope" ][ "rope_2_crouch" ]	 	= %oilrig_rappelrope_2_crouch;
	level.scr_anim[ "rope" ][ "rope_over_rail_R" ]	 	= %oilrig_rappelrope_over_rail_R;
}

#using_animtree( "animated_props" );
script_prop_anims()
{
	model = "fence_tarp_108x76";
	level.anim_prop_models[ model ][ "wind" ] = %fence_tarp_108x76_med_01;
}


vo_setup()
{
	level.scr_radio[ "so_manhattan_hqr_newdirective" ] = "so_manhattan_hqr_newdirective";   //overlord:   Metal Zero-One, standby for new mission directive, over.
	level.scr_radio["so_manhattan_hp1_anotherpass"] ="so_manhattan_hp1_anotherpass";   //chopper pilot:  Coming around for another pass.
	level.scr_radio["so_manhattan_hp1_flash9oclock"] ="so_manhattan_hp1_flash9oclock";   //chopper pilot:  Enemy personnel, flash, 9 o'clock!
	
	level.scr_radio["so_heliswitch_plt_eyeson"] =  "so_heliswitch_plt_eyeson";   //I have eyes on.
	level.scr_radio["so_heliswitch_plt_takeitslow"] =  "so_heliswitch_plt_takeitslow";   //I see you, take it slow.
	level.scr_radio["so_heliswitch_plt_movingahead"] =  "so_heliswitch_plt_movingahead";   //Moving ahead.
	level.scr_radio["so_heliswitch_plt_changingpositions"] =  "so_heliswitch_plt_changingpositions";   //Changing positions.
	level.scr_radio["so_heliswitch_plt_thermal"] =  "so_heliswitch_plt_thermal";   //Switching to thermal.
	level.scr_radio["so_heliswitch_plt_tothermal"] =  "so_heliswitch_plt_tothermal";   //Switch to thermal.
	level.scr_radio["so_heliswitch_plt_droppedsmoke"] =  "so_heliswitch_plt_droppedsmoke";   //They dropped smoke, looks like they know we're here.
	level.scr_radio["so_heliswitch_plt_gotyoursix"] =  "so_heliswitch_plt_gotyoursix";   //I got your six.
	level.scr_radio["so_heliswitch_plt_gotyourback"] =  "so_heliswitch_plt_gotyourback";   //I got your back, you're clear to proceed.
	level.scr_radio["so_heliswitch_plt_lzclear"] =  "so_heliswitch_plt_lzclear";   //LZ clear, landing.
	level.scr_radio["so_heliswitch_plt_gotenemies"] =  "so_heliswitch_plt_gotenemies";   //I still got enemies in the area.
	level.scr_radio["so_heliswitch_plt_comingaround"] ="so_heliswitch_plt_comingaround";   //Coming around for a better view.
	level.scr_radio["so_heliswitch_plt_movingahead2"] ="so_heliswitch_plt_movingahead2";   //c
	level.scr_radio["so_heliswitch_plt_11oclock"] ="so_heliswitch_plt_11oclock";   //c
	level.scr_radio["so_heliswitch_plt_illstaybehind"] ="so_heliswitch_plt_illstaybehind";   //c
	level.scr_radio["so_heliswitch_plt_comeaboard"] ="so_heliswitch_plt_comeaboard";   //c
	level.scr_radio["so_heliswitch_plt_hopon"] ="so_heliswitch_plt_hopon";   //c
	level.scr_radio["so_heliswitch_plt_gottaliftoff"] ="so_heliswitch_plt_gottaliftoff";   //c
	level.scr_radio["so_heliswitch_plt_hopoff"] ="so_heliswitch_plt_hopoff";   //c
	level.scr_radio["so_heliswitch_plt_jumpoff"] ="so_heliswitch_plt_jumpoff";   //c
	level.scr_radio["so_heliswitch_plt_dropoff"] ="so_heliswitch_plt_dropoff";   //c
	level.scr_radio["so_heliswitch_plt_goodluck"] ="so_heliswitch_plt_goodluck";   //c
	level.scr_radio["so_heliswitch_plt_hangon"] ="so_heliswitch_plt_hangon";   //c
	level.scr_radio["so_heliswitch_plt_herewego"] ="so_heliswitch_plt_herewego";   //c
	level.scr_radio["so_heliswitch_plt_strapin"] ="so_heliswitch_plt_strapin";   //c
	level.scr_radio["so_heliswitch_plt_nicejob"] ="so_heliswitch_plt_nicejob";   //c
	level.scr_radio["so_heliswitch_plt_onthisfloor"] ="so_heliswitch_plt_onthisfloor";   //c
	level.scr_radio["so_heliswitch_plt_findbriefcase"] ="so_heliswitch_plt_findbriefcase";   //c
	level.scr_radio["so_heliswitch_plt_armthebomb"] ="so_heliswitch_plt_armthebomb";   //c
	level.scr_radio["so_heliswitch_plt_bombisarmed"] ="so_heliswitch_plt_bombisarmed";   //c
	level.scr_radio["so_heliswitch_plt_extractionpoint"] ="so_heliswitch_plt_extractionpoint";   //c
	level.scr_radio["so_heliswitch_plt_atrendezvous"] ="so_heliswitch_plt_atrendezvous";   //c
	level.scr_radio["so_heliswitch_plt_runningout"] ="so_heliswitch_plt_runningout";   //c
	level.scr_radio["so_heliswitch_plt_pickuppace"] ="so_heliswitch_plt_pickuppace";   //c
	level.scr_radio["so_heliswitch_plt_20seconds"] ="so_heliswitch_plt_20seconds";   //c

	
	


}

ai_rappel_over_ground_death_anim( guy )
{
	guy endon( "death" );
	guy notify( "over_solid_ground" );
	guy clear_deathanim();
}

ai_rappel_reset_death_anim( guy )
{
	guy endon( "death" );
	guy clear_deathanim();
}


//------------------------------------------------------------------------------------------------------------------------------------------------

handle_infinite_ammo_during_intro()
{
	self endon( "death" );
	
	while ( !flag ( "tanks_dead" ) )
	{
		self GiveMaxAmmo( level.pentacular_weapon);
		wait 0.05;
	}
	
	self GiveWeapon( level.primary_weapon );
	
	self delaythread (2, ::switch_weapon_reminder);
	
	self waittill ("weapon_change");

	if ( self hasweapon( level.pentacular_weapon ))
		self takeweapon( level.pentacular_weapon );
		
	self GiveWeapon( level.secondary_weapon );
	
	self waittill ("heli_switch");
	wait .5;
	
	if ( self getcurrentweapon() == "none" )
		self switchtoweapon( level.primary_weapon );
	
	self.no_pentacular = true;
}

switch_weapon_reminder()
{
	self ent_flag_init("change_from_stinger");
	
	self thread end_text_message();
	
	while( !self AttackButtonPressed() )
		wait 0.05;
	
	weapon = self getcurrentweapon();
	
	if (weapon == "stinger")
		self text_effects( &"SO_HELISWITCH_BERLIN_HINT_SWITCH_WEAPON", "change_from_stinger", 3);
}

end_text_message()
{
	self waittill ("weapon_change");
	self ent_flag_set ("change_from_stinger");
}

hs_tank_fire_at_enemies(noteworthy_enemy_name, targets)
{
	self endon("death");
	self endon("stop_random_tank_fire");
	
	if (isdefined (targets))
		target = level.ground_guy;
	else
		target = undefined;
	
	while(1)
	{		
		if(isdefined(target)&& target.health > 0 && self.health > 0)
		{
			self setturrettargetent( target , (randomintrange(-64, 64),randomintrange(-64, 64),randomintrange(-16, 100)));
			
			if(SightTracePassed(self.origin + (0,0,100), target.origin + (0,0,40), false, self ))
			{	
				self.tank_think_fire_count++;
				self fireweapon();
				if(self.tank_think_fire_count >= 3)
				{
					wait 0.5;
				}
				wait(randomintrange(4,10));//short timer so we can just see the tanks firing
			}
			else
			{
				target = undefined;
				wait(1);
			}	
		}
		else
		{	
			if(!isAlive(self))
				break;
				if ( !isdefined( targets ))
					target = self get_tank_target_by_script_noteworthy(noteworthy_enemy_name);
				else
				{
					if (randomint( 100 ) > 50)
						target = level.air_guy;
					else
						target = level.ground_guy;
				}
			self.tank_think_fire_count = 0;
			wait(1);
		}
		wait(RandomFloatRange(0.05, .5));
	}
}

so_enable_countdown_timer( time_wait, set_start_time, message, timer_draw_delay, only_me )
{
	level endon( "special_op_terminated" );
	
	if ( !isdefined( message ) )
		message = &"SPECIAL_OPS_STARTING_IN";
	
	func = maps\_shg_common::create_splitscreen_safe_hud_item;
	if(!isdefined( only_me ) )
	{
		func = ::so_create_hud_item;
		only_me = level;
	}
	hudelem = only_me [[func]]( 0, so_hud_ypos(), message );
	hudelem SetPulseFX( 50, time_wait * 1000, 500 );

	hudelem_timer = only_me [[func]]( 0, so_hud_ypos(), undefined );
	hudelem_timer thread show_countdown_timer_time( time_wait, timer_draw_delay );
	
	level.elements = [hudelem, hudelem_timer];
	
	wait time_wait;
	level.player PlaySound( "arcademode_zerodeaths" );
	
	if ( isdefined( set_start_time ) && set_start_time )
		level.challenge_start_time = gettime();

	thread so_destroy_countdown_timer( hudelem, hudelem_timer );
}

so_destroy_countdown_timer( hudelem, hudelem_timer, flg )
{
	if ( isdefined( flg ))
		flag_wait(flg);
		
	wait 1;		
	if ( isdefined( hudelem ) && isdefined ( hudelem_timer ) )
	{
		hudelem Destroy();
		hudelem_timer Destroy();
	}
}

missing_objective_warning(vol_noteworthy, obj_string, not_flag)
{
	level endon( "special_op_terminated" );

	if (!flag(not_flag))
	{
		level.objective_warning_triggers = getentarray( vol_noteworthy, "script_noteworthy" );
		assertex( level.objective_warning_triggers.size > 0, "missing_objective_warning() requires at least one trigger" );

		while( true )
		{
			wait 0.05;
			foreach ( trigger in level.objective_warning_triggers )
			{
				if ( !isdefined( self.obj_missed_active ) )
				{
					if ( self istouching( trigger ) )
					{
						self.obj_missed_active = true;
						self thread ping_objective_warning( obj_string, trigger, not_flag );
					}
				}
				else
				{
					if ( !isdefined( self.ping_objective_splash ) )
						self thread ping_objective_warning( obj_string, trigger, not_flag );
				}
			}
		}
	}
}

disable_objective_warning(triggers)
{
	if ( self istouching( level.objective_warning_triggers[0] ) )
	{
		return false;
	}
	return true;
}

ping_objective_warning(obj_string, trigger, flg)
{
	if ( isdefined( self.ping_objective_splash ) )
		return;
	if (!self istouching(trigger))
		return;
	if (self.lilbros[ "is_on_heli" ])
		return;
	if (flag(flg))
		return;

	self endon( "death" );
	
	self.ping_objective_splash = self maps\_shg_common::create_splitscreen_safe_hud_item( 3.5, 0, obj_string );
	self.ping_objective_splash.alignx = "center";
	self.ping_objective_splash.horzAlign = "center";

	while ( self istouching (trigger) && !flag(flg))
	{
		self.ping_objective_splash.alpha = 1;
		self.ping_objective_splash FadeOverTime( 1 ) ;
		self.ping_objective_splash.alpha = 0.5;
		
		self.ping_objective_splash.fontscale = 1.5;
		self.ping_objective_splash ChangeFontScaleOverTime( 1 );
		self.ping_objective_splash.fontscale = 1;
		
		wait 1;
	}
	
	self.ping_objective_splash.alpha = 0.5;
	self.ping_objective_splash FadeOverTime( 0.25 );
	self.ping_objective_splash.alpha = 0;
	wait 0.25;

	self.escape_hint_active = undefined;
	
	if ( isdefined( self.ping_objective_splash ) )
		self.ping_objective_splash Destroy();
}

fadeBlackOut( time)
{ 
	self fadeOverTime( time);
	self.alpha = 1;
}

blackOut(message)
{
	overlay = NewHudElem( );
	overlay setshader( "black", 640, 480 );
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	overlay.sort = 10;
	return overlay;

}
//================================================
//        End of Game Stats
//
//================================================



handle_end_of_game_bonuses()
{
	level.bonus_1_shader = "award_positive";
	level.bonus_2_shader = "award_positive";
	
	level.bonus2_num = 0;
	level.bonus1_num = 0;
	
	foreach( p in level.players )
	{
		p.bonus_1 = 0;
		p.bonus_2 = 0;
	}
}


monitor_attacker()
{
	level endon ("end_bonus_parkway");
	
	level.bonus1_num++;
	
	self waittill( "death", attacker, cause );
	
	if (isplayer(attacker))
	{
		attacker.bonus_1++;
		attacker notify ("bonus1_count", attacker.bonus_1);
	}
}

