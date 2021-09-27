#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_specialops_code;
#include maps\_audio;
#include maps\_audio_music;
#include maps\_audio_zone_manager;
#include maps\_helicopter_globals;
#include maps\_shg_common;

main()
{
	level.primary_weapon = "mp7_reflex";
	level.secondary_weapon = "aa12";
	
	setsaveddvar("sm_sunshadowscale",.85);
	level.old_shadow_scale = getdvarfloat("sm_sunshadowscale");
	
	maps\_shg_common::so_vfx_entity_fixup( "msg_vfx" );
	maps\_shg_common::so_mark_class( "trigger_multiple_audio" );
	//maps\_shg_common::so_mark_class( "trigger_multiple_visionset" );


	so_delete_all_triggers();
	so_delete_all_spawners();
	so_delete_all_vehicles();

	flag_init( "hatch_player_using_ladder" );
	flag_init( "outside_above_water" );
	flag_init( "so_zodiac2_ny_harbor_complete" );
	flag_init( "so_zodiac2_ny_harbor_start" );
	flag_init( "players_in_reactor_room");
	flag_init( "stop_missile_launch");
	flag_init( "times_up" );
	flag_init( "hatch_open" );
	flag_init( "times_up_reactor" );
	flag_init( "bombs_defused_missile_room" );
	flag_init( "bombs_defused_reactor_room" );
	flag_init( "reactor_thermite_start");
	flag_init( "detonate_sub");
	flag_init( "submine_planted" );
	flag_init( "sub_breach_started" );
	flag_init( "entering_water" );
	flag_init( "launch_missiles" );
	flag_init( "player_on_boat" );
	flag_init( "msg_vfx_sub_interior_red_light_pulse" );
	flag_init( "laststand_downed" );
	flag_init( "a_thing_is_being_defused" );
	flag_init( "russian_sub_spawned" );
	flag_init( "reactor_saved" );
	flag_init( "close_hatch" );
	flag_init( "switch_chinook" );
	flag_init( "door_3_is_open");
	flag_init( "been_hit" );

	precacheitem( "mp7_reflex" );
	
	PreCacheModel( "weapon_thermite_device_obj" );
	PreCacheModel( "ny_harbor_sub_pipe_valve_02_obj" );
	
	precacheshader("nightvision_overlay_goggles");
	
	precachestring( "SCRIPT_MISSIONFAIL_KILLTEAM_AMERICAN" );
	add_hint_string ( "hint_friendly", &"SCRIPT_MISSIONFAIL_KILLTEAM_AMERICAN", ::if_not_bleedut );


	precacheAnims();
	preFX();
	preVO();
	PrecacheMinimapSentryCodeAssets();

	maps\so_zodiac2_ny_harbor_precache::main();
	maps\ny_harbor_precache::main();
	maps\ny_harbor_aud::main();
	maps\_load::main();
	maps\so_aud::main();
	maps\_compass::setupMiniMap("compass_map_ny_harbor");

	level.so_zodiac2_ny_harbor = true;
	maps\ny_harbor_fx::main();
	
	set_stringtable_mapname("shg");
	
	setup();
	gameplay();
}

setup()
{
	thread enable_challenge_timer( "so_zodiac2_ny_harbor_start", "so_zodiac2_ny_harbor_complete" );
	thread fade_challenge_in();
	thread fade_challenge_out( "so_zodiac2_ny_harbor_complete" );
	thread enable_escape_warning();
	thread enable_escape_failure();
	
	thread AZM_start_zone("nyhb_surface_battle");

	setup_players();
	thread objectives();
	//thread debug();
	
	
		// Custom end of game logic
	handle_end_of_game_bonuses();
	array_thread ( level.players, ::enable_challenge_counter, 3, &"SO_ZODIAC2_NY_HARBOR_BONUS_CLOSE_SMALL", "bonus1_count" );
	level.so_mission_worst_time = 600000;
	level.so_mission_min_time = 104000;
	maps\_shg_common::so_eog_summary( "@SO_ZODIAC2_NY_HARBOR_BONUS_CLOSE", 250, undefined);
}

gameplay()
{
	globals();
	setup_ocean();
	
	thread dialogue();
	thread setup_intro();
	thread sub_interior();
	difficulty_specific_items();
}
//----------------------------------------------------------------------------------------------------------------------------


debug()
{
	wait 3;
	//iprintlnbold("end_time= " + level.challenge_end_time);
	iprintlnbold("start_time= " + level.challenge_start_time);

}
globals()
{
	add_global_spawn_function( "axis", ::monitor_damage_type );
	array_thread(level.players, ::halt_if_downed);
	thread fail_mission_friendly_fire();
	
	level.maars_interface_fontscale = 1.5;
	level.turn_time = 7;
	
	level.pipesDamage = false;
	
	if (level.single_player)
	{
		level.time_to_disarm_each_thermite = 14;
		level.num_explosives = 4;
	}
	else
	{
		level.time_to_disarm_each_thermite = 9;
		level.num_explosives = 8;
	}
}
fail_mission_friendly_fire()
{
	level waittill ( "friendlyfire_mission_fail" );
	
	foreach (p in level.players)
		p thread display_hint_timeout( "hint_friendly", 2 );
}

if_not_bleedut()
{
	if (flag( "laststand_downed" ))
		return true;
	else
		return false;
}
	

halt_if_downed()
{
	while (1)
	{
		self waittill( "player_downed" );
		flag_set( "laststand_downed" );
		self waittill( "revived" );
		flag_clear( "laststand_downed" );
	}
}


setup_players()
{
	level.single_player = true;
	
	if ( isdefined( level.players[1]) )
		level.single_player = false;


	foreach (p in level.players)
	{
		p takeallweapons();
		p GiveWeapon( level.primary_weapon );
		p GiveWeapon( level.secondary_weapon);
		p GiveWeapon( "fraggrenade" );
		p GiveWeapon( "flash_grenade" );
		p SetOffhandSecondaryClass( "flash" );
		p switchToWeapon( level.primary_weapon  );
		//enableinvulnerability();
	}
}

so_objective_create(name, obj_string, obj_loc, offset)
{
	if (!isdefined(offset))
		offset = 0;
		
	Objective_Add( obj( name ), "active", obj_string );
	Objective_Current( obj( name ) );
	Objective_position( obj( name ), (obj_loc.origin[0], obj_loc.origin[1], obj_loc.origin[2] + offset)  );
}

so_objective_complete(name)
{
	objective_clearAdditionalPositions( name );
	objective_complete( obj( name ) );
}

objectives()
{
	wait 10; // pause a little so the dot does not show up until you are facing it
	
	objective_1_GetInSub();
	objective_2_GetToReactor();
	objective_3_GetOutOfSub();
	objective_4_GetToExtraction();
}

objective_1_GetInSub()
{
	obj_sub = GetEnt( "obj_get_in_sub", "targetname" );
	so_objective_create( 1, &"SO_ZODIAC2_NY_HARBOR_OBJ_GET_IN_SUB" , obj_sub);
	Objective_SetPointerTextOverride( 1, &"SO_ZODIAC2_NY_HARBOR_HINT_DISARM" );
		
	flag_wait("hatch_open");
	Objective_position( obj( 1 ), (0,0,0)  );
	objective_complete( obj( 1 ) );
}

objective_2_GetToReactor()
{
	Objective_Add( obj( 2 ), "active", &"SO_ZODIAC2_NY_HARBOR_OBJ_REACTOR" );
	Objective_Current( obj( 2 ) );
	obj_reactor = GetEnt( "obj_reactor2", "targetname" );
	Objective_Position( obj( 2 ), obj_reactor.origin );

	flag_wait( "bombs_defused_missile_room" );
	wait 5.5;
	Objective_Position( obj( 2 ), (0,0,0) );
	wait .5;
	exit_hint = [];
	
	if( level.single_player )
	{
		if ( isdefined( level.players[0].upper_floor ) && level.players[0].upper_floor)
			exit_hint = GetEntArray( "exit_hint_single", "targetname" );
		else
			exit_hint = GetEntArray( "exit_hint_single_bottom", "targetname" );
			
	}
	if( !level.single_player)
		exit_hint = GetEntArray( "exit_hint_multi", "targetname" );
	
	position_array = [];
	foreach(i, org in exit_hint)
	{
		Objective_additionalposition( obj(2), i + 1, org.origin );
		Objective_SetPointerTextOverride( 2, &"SO_ZODIAC2_NY_HARBOR_HINT_EXIT" );
		position_array[i] = i+1;
	}
	
	wait 7;
	foreach(pos in position_array)
		Objective_additionalposition( obj(2), pos, (0,0,0));
	
	wait 0.5;
	Objective_SetPointerTextOverride( 2, "" );
	
	obj_reactor = GetEnt( "obj_reactor2", "targetname" );
	Objective_Position( obj( 2 ), obj_reactor.origin );
	
	flag_wait("reactor_saved");
	so_objective_complete( 2 );
}

objective_3_GetOutOfSub()
{
	Objective_Add( obj( 3 ), "active", &"SO_ZODIAC2_NY_HARBOR_OBJ_GET_OUT" );
	Objective_Current( obj( 3 ) );
	
	array_thread( level.players, ::obj_crumb_logic);
	
	flag_wait ("obj_zod_crumb_flag");
	so_objective_complete( 3 );
	wait .1;
}

obj_crumb_logic(num, ent)
{
	self wait_till_player_is_close( 3, "obj_escape_bc1");
	self wait_till_player_is_close( 3, "obj_escape_bc2");
	self wait_till_player_is_close( 3, "obj_get_to_zodiac_crumb1", 1);
	self wait_till_player_is_close( 3, "obj_get_to_zodiac_crumb2");
}

wait_till_player_is_close(num, ent, exit)
{
	org = GetEnt( ent, "targetname" );	
	Objective_Position( obj( num ), org.origin );
	
	if( isdefined( exit ))
		Objective_SetPointerTextOverride( 3, &"SO_ZODIAC2_NY_HARBOR_HINT_EXIT" );
	
	while ( distance( self.origin, org.origin ) > 96)
		wait 0.05;
}

objective_4_GetToExtraction()
{
	Objective_Add( obj( 4 ), "active", &"SO_ZODIAC2_NY_HARBOR_OBJ_AWAIT_CHOPPER" );
	Objective_Current( obj( 4 ) );
	
	wait 2; //wait for chopper to get created
	obj_extraction = GetEnt( "obj_extraction", "targetname" );
	Objective_Position( obj( 4 ), obj_extraction.origin );
	
	flag_wait("so_zodiac2_ny_harbor_complete");
	objective_complete( obj( 4 ) );
}

//---------------------------------------------------------------------------------------------------------
//                           GAMEPLAY
//---------------------------------------------------------------------------------------------------------

dialogue()
{
	flag_wait( "vo_nuclear" );
	radio_dialogue( "so_zodiac2_hqr_riggedsub" );
	
	flag_wait( "vo_reactor" );
	radio_dialogue( "so_zodiac2_hqr_nearingreactor" );
	
	flag_wait( "start_reactor_countdown" );
	radio_dialogue( "so_zodiac2_hqr_raditionlevels" );
	
	flag_wait( "reactor_saved" );
	radio_dialogue( "so_zodiac2_hqr_rendezvous" );
	
	flag_wait( "kill_spawners_4" );
	radio_dialogue( "so_zodiac2_hqr_areaishot" );
	
	flag_wait( "open_rear_hatch" );
	radio_dialogue( "so_zodiac2_hqr_onisr" );
	
	flag_wait( "shoot_at_stragglers" );
	radio_dialogue( "so_zodiac2_hqr_readywhen" );
}

setup_intro()
{
	flag_set( "so_zodiac2_ny_harbor_start" );

	thread play_music_and_effects();
	thread silo_doors_and_missiles();
	array_thread (level.players, ::setup_thermal_vision);

	thread setup_hind();
	thread setup_ally_helis();
	thread setup_deck();
	thread spawner_cleanup();
	
	//required for ny_harbor_fx
	level.sandman = GetEnt( "sandman", "targetname" );
	wait 0.05;
	level.sandman kill();

}

sub_interior()
{
	thread visions();
	
	thread setup_ai_sub();
	thread make_sub_look_like_old_sub();
	thread setup_missile_room();
	thread handle_reactor_setup();
	thread handle_exit();
	thread intro_jets();
	
	array_thread (level.players,:: RockingSub);
}


//---------------------------------------------------------------------------------------------------------
//                           GAMEPLAY
//---------------------------------------------------------------------------------------------------------

setup_thermal_vision()
{
	self notifyOnPlayerCommand( "use_thermal", "+actionslot 4" );
	self setWeaponHudIconOverride( "actionslot4", "hud_icon_nvg" );
	self.thermal = false;
	
	while (1)
	{
		self waittill ("use_thermal");
		
		self turn_on_thermal_vision();
	
		self waittill ("use_thermal");
		
		self turn_off_thermal_vision();
	}
}

turn_on_thermal_vision()
{
	self maps\_load::thermal_EffectsOn();
	self ThermalVisionOn();
	self VisionSetThermalForPlayer( "so_sniper_hamburg_thermal", 0 );//uav_flir_Thermal
	self playsound( "item_nightvision_on");
	self.thermal = true;
	self gasmask_on_player_so();
	wait 0.5; //avoid colliding audio
}

turn_off_thermal_vision()
{
	self maps\_load::thermal_EffectsOff();
	self ThermalVisionOff();
	self playsound( "item_nightvision_off");
	self.thermal = false;
	self gasmask_off_player_so();
	wait 0.5; //avoid colliding audio
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

play_music_and_effects()
{
	thread play_random_creepy_audio();
	thread cosmetic_fx_and_geo_for_harbor();
	
	flag_wait("hind_ready_for_land");
	MUS_play("so_harb_board_sub", 4);
	
	flag_wait("in_missile_room");
	MUS_play("so_harb_sub_combat2", 0.2, 3);
	
	level waittill ("trigger_missile_bombs");
	MUS_play("so_harb_sub_combat1", 0.2, 3);

	level notify( "msg_vfx_sub_interior_b_deactivating" );
	flag_clear("msg_vfx_sub_interior_b");
	
	//flag_wait( "bombs_defused_missile_room" );
	//MUS_play("harb_board_sub", 4);
	
	level waittill ("in_missile_room2");
	MUS_play("so_harb_sub_combat2", 0.2, 3);
	
	level waittill ("reactor_area_clear");
	MUS_play("so_harb_board_sub", 4);
	
	flag_wait("start_reactor_countdown");
	MUS_play("so_harb_sub_combat1", 0.2, 3);
	
	flag_wait("kill_spawners_4");
	MUS_play("so_harb_finale", 4);
}

play_random_creepy_audio()
{
	flag_wait ("stop_missile_launch");
	ambient_sound = GetStructArray( "ambient_sound", "targetname" );
	sound_array = ["harb_battleship_stress", "harb_battleship_sink", "harb_sub_stress", "harb_sub_stress_sub_by", "russian_sub_missile_door"];
	sound_tag = spawn_tag_origin();
	
	while (1)
	{
		wait ( randomfloatrange( 5.0, 15.0 ));
		struct = getclosest(level.players[0].origin, ambient_sound );
		sound_tag.origin = struct.origin;
		sound_tag playsound( sound_array[ randomint(sound_array.size) ], "sound_done");
		sound_tag waittill ("sound_done");
	}
	
}
cosmetic_fx_and_geo_for_harbor()
{
	fx_oil_fire = Getstruct( "fx_oil_fire", "targetname" );
	playfx( getfx( "burning_oil_slick_1" ), fx_oil_fire.origin );
	
	sinking_ship = GetEnt( "sinking_ship", "targetname" );
	sinking_ship delete();
	
	flag_wait("turn_off_fire");
	flag_clear("msg_vfx_sub_interior_a");
	
	for_fire = GetEnt( "for_fire", "targetname" );
	playfx( getfx( "fire_gen" ), for_fire.origin );
	
	for_fire_steam = GetEnt( "for_fire_steam", "targetname" );
	tag1 = spawn_tag_to_loc( for_fire_steam );
	playFXOnTag( getfx( "steam_jet1" ), tag1, "tag_origin" );
	
	for_fire_jet = GetEnt( "for_fire_jet", "targetname" );
	tag2 = spawn_tag_to_loc( for_fire_jet );
	playFXOnTag( getfx( "fire_steam" ), tag2, "tag_origin" );
	
}

setup_ai_sub()
{
	while (1)
	{
		guys = getaiarray("axis");
		array_thread(guys, ::enemy_ai_for_sub);
		
		wait 2;
	}
}

spawn_missile_room_1_guys( tname, spawn_func )
{
	spawners = getentarray( tname, "targetname" );

	assert(spawners.size > 0);
	
	array = [];
	foreach(s in spawners)
	{
		guy = s spawn_ai(true);
		array[array.size] = guy;
	}
	
	return array;
}

make_sub_look_like_old_sub()
{
	snode = getent("bridge_breach_loc","targetname");	
	
	captain = GetEnt( "captain_dead", "targetname" );
	dead_captain = captain spawn_ai( true );
	dead_captain.animname = "generic";
	
	snode anim_generic( dead_captain, "ny_harbor_paried_takedown_captain_die" );
	dead_captain = dead_captain dummy_keep_pose( snode, "ny_harbor_paried_takedown_captain_dead_1" );
	
	array_thread (level.players, ::no_prone_on_back_of_sub);
}

no_prone_on_back_of_sub()
{
	no_prone_vol = GetEnt( "no_prone_vol", "targetname" );
	
	while (1)
	{
		if( no_prone_vol istouching ( self ))
		{
			self allowprone( false );
			
			while( no_prone_vol istouching ( self ))
				wait 0.05;
			
			self allowprone( true );
		}
		wait 0.05;
	}
}

remove_silho_door_geo()
{
	ladder_trigger = GetEntarray( "ladder_trigger", "targetname" );
	ladder_trigger_2 = GetEntarray( "ladder_trigger_2", "targetname" );
	missile_silo_door = GetEntArray( "missile_silo_door", "targetname" );
	
	//array_thread (level.players, ::hide_silho_geo, ladder_trigger, ladder_trigger_2, missile_silo_door);
}

hide_silho_geo(vol_1, vol_2, geo)
{
	while (1)
	{
		wait_for_both_players_to_enter(vol_2, vol_1);
		array_call (geo, ::hide);
		
		wait_for_both_players_to_enter(vol_1, vol_2);
		array_call (geo, ::show);
	}
}

wait_for_both_players_to_enter(first_vol, second_vol)
{
	level.in_sub = 0;
	
	while (1)
	{
		first_vol waittill ( "trigger", guy );
		if ( guy == self )
		{
			second_vol waittill ( "trigger", guy );
			
			if( guy == self )
				level.in_sub ++;
		}
			if( level.in_sub >= level.players.size )
				break;
	}
}

dummy_keep_pose( anim_ent, anim_pose )
{
 dummy = maps\_vehicle_aianim::convert_guy_to_drone( self );
 dummy startUsingHeroOnlyLighting();
 if (isarray(getGenericAnim(anim_pose)))
 	anim_pose = anim_pose + "_nl";	// expects there to be an _nl flavor for looping flavors
 anim_ent anim_generic_first_frame( dummy, anim_pose );
 dummy notsolid();
 return dummy;
}

spawner_cleanup()
{
	kill_spawners_noteworthy( "kill_spawners_1", 6901 ); 
	kill_spawners_noteworthy( "kill_spawners_2", 6902 );
	kill_spawners_noteworthy( "kill_spawners_3", 6903 );
	kill_spawners_noteworthy( "kill_spawners_4", 6904 );
}

kill_spawners_noteworthy(flg, num)
{
	flag_wait(flg);
	maps\_spawner::kill_spawnerNum( num );
}


setup_deck()
{
	thread open_hatch_rear();
	thread spawn_ladder_if_downed(); 
	thread get_ladder_use_trigger_and_handle();
	
	if (level.gameskill > 1 )
		add_global_spawn_function( "axis", ::lessen_accuracy_on_deck );
		
	level.thermite_entrance = thermite_setup( undefined, "thermite_entrance", undefined, 75 );
	level.thermite_entrance arm_thermite_and_monitor( "hatch_open" );
	
	flag_wait( "start_jet_strafe" );
	
	if (level.gameskill > 1 )
		remove_global_spawn_function( "axis", ::lessen_accuracy_on_deck );
	
}

lessen_accuracy_on_deck()
{
	self endon ("deah");
	
	if (isdefined(self))
		self.ignoreall = true;
	
	flag_wait( "start_jet_strafe" );
	
	wait 1.25; //waiting for players to get oriented
	
	if (isdefined(self))
		self.ignoreall = false;
}

get_ladder_use_trigger_and_handle()
{
	sight_trigger_front_hatch = GetEnt( "sight_trigger_front_hatch", "targetname" );
	sight_trig_org = sight_trigger_front_hatch.origin;
	sight_trigger_front_hatch.origin = (50, 50, 50);
	sight_trigger_front_hatch.moved = true;
	
	flag_wait("hatch_open");
	wait 2;
	sight_trigger_front_hatch.origin = sight_trig_org;
	sight_trigger_front_hatch.moved = false;
	
	
	array_thread(level.players, ::hide_trigger_when_ladder_in_use_front, sight_trigger_front_hatch, "check_for_player_front_hatch");
	
	hatch_player_slide("sight_trigger_front_hatch", "rear_ladder_pos1", "rear_ladder_pos2" );
}



spawn_ladder_if_downed()
{
	ladder_brush = GetEnt( "ladder_brush", "targetname" );
	ladder_org = ladder_brush.origin;
	ladder_brush.origin = ( 50, 50, 50 );

	rear_hatch_cap = GetEnt( "rear_hatch_cap", "targetname" );

	downed_vol_deck = GetEnt( "downed_vol_deck", "targetname" );
	
	while (1)
	{
		flag_wait( "laststand_downed" );
		
		if( player_on_deck( downed_vol_deck ))
		{
			ladder_brush.origin = ladder_org;
			rear_hatch_cap.origin = ( 50, 50, 50 );
		}
		
		while (flag("laststand_downed"))
			wait 0.05;
		
		ladder_brush.origin = ( 50, 50, 50 );
	}
}

player_on_deck(vol)
{
	foreach( p in level.players )
	{
		if( vol istouching( p ) && p ent_flag_exist( "laststand_downed" ) && p ent_flag( "laststand_downed" ) )
			return true;
	}
	return false;
}

arm_thermite_and_monitor( flg, dist )
{
	if(!isdefined(dist))
		dist = 75;
	
	level.thermite = self[0];
	level.thermite.shiny = [];
	
	foreach (p in level.players)
	{
		p thread force_player_look_to_defuse( level.thermite, 100, dist ); 
		p thread end_messages_if_both_disarm();
	}
	
	monitor_remaining_bombs( flg, self );
}

end_messages_if_both_disarm()
{
	level.thermite waittill ("im_defused");
	self forceusehintoff( );
	foreach(item in level.thermite.shiny)
	{
		if(isdefined(item))
			item delete();
	}
}


difficulty_specific_items()
{
	is_hard = false;
	
	if (level.single_player)
		array = GetEntArray( "multi_player", "script_noteworthy" );
	else
		array = GetEntArray( "single_player", "script_noteworthy" );

	foreach (item in array)
		item delete();
}

kill_helis( array)
{
	flag_wait("hatch_open");
	aud_send_msg("so_harbor_kill_helis", array);
	foreach(h in array)
	{
		foreach (r in h.riders)
			r kill();
		h delete();
	}
}

setup_ally_helis()
{
	
	heli_arr = GetEntArray("ally_helis", "targetname");
	aud_send_msg("so_harbor_ally_helis", heli_arr);
	array_thread( heli_arr, ::gopath );
	array_thread( heli_arr, ::get_allies );
	thread kill_helis( heli_arr );

	level notify ("missiles_spawned");
}
get_allies()
{
	foreach (r in self.riders)
		r.script_godmode = true;
}



intro_jets()
{
	level waittill ("spawn_exit_chopper");
	heli = spawn_vehicle_from_targetname_and_drive( "end_enemy_chopper" );
	aud_send_msg("so_harbor_enemy_chopper_flyover", heli);
	exit_ladder_pos1 = GetEnt( "exit_ladder_pos1", "targetname" );
	
	wait 20;

	f15_1 = make_jet_and_go("f15_enemy_intro");
	wait 1;
	
	f15_2 = make_jet_and_go("f15_enemy_intro2");
	exit_ladder_pos1 playsound( "f15_final_flyby_fronts", "sound_done");
}

make_jet_and_go(jet_name)
{
	jet = spawn_vehicle_from_targetname_and_drive( jet_name );
	jet thread kill_jets_when_done();
	return jet;
}


kill_jets_when_done()
{
	flag_wait("remove_intro_f15");
	self delete();
}

inaccurate_magicbullet(gun, offset_range, target_pos, shooter_ent)
{
	xx = (target_pos[0] + randomfloatrange(offset_range * -1, offset_range));
	yy = (target_pos[1] + randomfloatrange(offset_range * -1, offset_range));
	zz = (target_pos[2] + randomfloatrange(offset_range * -1, offset_range));
	
	magicbullet( gun, shooter_ent.origin, (xx, yy, zz));
}

//-------------------------------------------------------------------------------------------------------------
//                                 Reactor
//-------------------------------------------------------------------------------------------------------------

one_item_at_time(item)
{
	item waittill ("im_defused");
	
	if (isdefined (self.item) && self.item == item)
		self.item = undefined;

}

ok_to_disarm(item)
{
	if ( flag( "times_up" ))
		return false;
	else if ( flag( "laststand_downed" ))
		return false;
	else if (!isdefined(self.item))
	{
		self.item = item;
		return true;
	}
	else if ( self.item == item)
		return true;
	else if ( self.item != item)
		return false;

	else
		return true;
}


end_if_timesup()
{
	flag_wait("times_up");
	self notify ("times_up");
}

force_player_look_to_defuse( item, dist, distx )
{
	level.thermite endon ("im_defused");
	//item endon ("times_up");
	
	level.thermite thread end_if_timesup();
	self thread one_item_at_time(level.thermite);
		
	assert( isplayer(self));
	assert( isdefined(level.thermite));
	
	level.thermite.hidden = false;
	level.thermite.defused = false;
	thermite = undefined;
	self.message_on = false;
	level.thermite.in_use = false;
	
	if(!isdefined(distx))
		distx = 50;
	
	while (!level.thermite.defused)
	{
		wait 0.05;
		player_pos = self geteye();
		
		self hint_text_logic(player_pos, distx);

		
		if ( isdefined(level.thermite) && !level.thermite.hidden && (distance(player_pos, level.thermite.origin) < distx))
		{
			level.thermite.shiny[level.thermite.shiny.size] = make_shiny_thermite(level.thermite);
			level.thermite remove();
		}
		else if(  isdefined( level.thermite ) && level.thermite.hidden && (distance( player_pos, level.thermite.origin) < distx) && (!isdefined(level.thermite.inUse) || !level.thermite.inUse))
		{
			while( !flag("laststand_downed") && self usebuttonpressed() )
			{
				self forceusehintoff( );
				if (self ok_to_disarm(level.thermite) && level.thermite progress_bar( self, undefined, 2, &"SO_ZODIAC2_NY_HARBOR_HINT_DEFUSING", &"SO_ZODIAC2_NY_HARBOR_HINT_DISARM_SUCCESS", undefined, &"SO_ZODIAC2_NY_HARBOR_HINT_DISARM_FAIL")) //, undefined, "damage"
				{
					level.thermite.defused = true;
					level.thermite kill_fx_on_thermite();
					
					remove_all_thermites(thermite);

					level.thermite notify ( "im_defused" );
				}
				else
				{
					self forceusehinton( &"SO_ZODIAC2_NY_HARBOR_HINT_DEFUSE" );
					self.item = undefined;
				}    
				wait 0.05;
			}
		}
		else if (  isdefined(level.thermite) && level.thermite.hidden && isdefined(thermite) && (distance( player_pos, level.thermite.origin) > distx))
		{
			self delete_thermite_and_message(thermite);
			level.thermite display();
		}
		else if(!isdefined(level.thermite))
		{
			self delete_thermite_and_message(thermite);
			break;
		}
		else if (flag("laststand_downed"))
			self wait_for_laststand(thermite);
	}
}

remove_all_thermites(thermite)
{
	if (isdefined(thermite))
		thermite delete();
		
	if (isdefined(level.thermite))
		level.thermite hide();
}

delete_thermite_and_message(thermite)
{
	if (isdefined(thermite))
		thermite delete();
	self forceusehintoff( );
}

wait_for_laststand(thermite)
{
	if (isdefined(thermite))
			thermite delete();

	level.thermite display();
	self forceusehintoff(  );
			
	while (flag("laststand_downed"))
		wait 0.05;
}

hint_text_logic( player_pos, distx )
{
	if (!level.thermite.in_use && !self.message_on && distance(player_pos, level.thermite.origin) < distx)
	{
		self forceusehinton( &"SO_ZODIAC2_NY_HARBOR_HINT_DEFUSE" );
		self.message_on = true;
	}
	else if(level.thermite.in_use && !self.message_on && distance(player_pos, level.thermite.origin) < distx)
	{
		self forceusehintoff();
		self.message_on = false;
	}
	else if( distance(player_pos, level.thermite.origin) > distx)
	{
		self forceusehintoff();
		self.message_on = false;
	}
}

display()
{
	self show();
	self.hidden = false;
}

remove()
{
	self hide();
	self.hidden = true;

}

make_shiny_thermite(item)
{
	model = "weapon_thermite_device_obj";
	thermite = spawn( "script_model", item.origin );
	thermite setmodel( model );
	thermite angles_and_origin( item );
	return thermite;
}

kill_fx_on_thermite()
{
	stopfxontag( getfx( "red_dot"  ), self.tag_light, "tag_origin" );
	stopfxontag( getfx( "red_dot"  ),  self, "tag_fx" );
	stopfxontag( getfx( "light_c4_blink"  ), self, "tag_fx" );
	stopfXontag( getfx( "white_light" ), self, "tag_fx" );
}



setup_hind()
{
	level.player_hind = spawn_vehicle_from_targetname_and_drive( "player_hind" );
	aud_send_msg("so_start_harbor_player_hind", level.player_hind);
	assert(isdefined(level.player_hind));
	
	thread heli_fail_safe_on_death();
	
	level.player_hind.bow = make_custom_tag_from_struct("hind_bow", level.player_hind);
	
	level.players[0].heli_pos[0] = make_custom_tag_from_targetname("player_position1", level.player_hind);
	level.players[0].heli_pos[1] = make_custom_tag_from_targetname("player_position1b", level.player_hind);
	level.players[0].heli_pos[2] = make_custom_tag_from_targetname("player_position1c", level.player_hind);


	level.players[0] thread heli_unload();

	if( !level.single_player )
	{
		level.players[1].heli_pos[0] = make_custom_tag_from_targetname("player_position2", level.player_hind);
		level.players[1].heli_pos[1] = make_custom_tag_from_targetname("player_position2b", level.player_hind);
		level.players[1].heli_pos[2] = make_custom_tag_from_targetname("player_position2c", level.player_hind);
		level.players[1] thread heli_unload();
	}
	
	foreach (p in level.players)
	{
		p teleport_and_clamp_view(p.heli_pos[0]);
		p allowstand(false);
		p allowprone(false);
	}
	
	level.player_hind thread make_invulnerable();

	level.player_hind fix_hind_doors_so();
}

make_invulnerable()
{
	while (!flag("hind_ready_for_land"))
	{
		self.health = 30000;
		wait 0.05;
	}
	wait 1;

}

heli_unload()
{
	flag_clear( "laststand_on" );

	flag_wait( "start_jet_strafe" );
	flag_set( "laststand_on" );

	tag1 = spawn_tag_to_loc(self.heli_pos[1]);
	self playerlinktoblend( self.heli_pos[1] , "tag_origin", .25);
	wait 0.25;
	self playerlinktoblend( self.heli_pos[2] , "tag_origin", .25);
	wait .25;

	self unlink();
	wait 1;
	self disableinvulnerability();
	self enableweapons();
	self allowstand(true);
	self allowprone(true);

}

fix_hind_doors_so()
{
	wait 0.05;	// let things get started
	guys = [];
	guys[0] = self;
	self anim_single( guys, "open_door_idle", undefined, undefined, "ny_harbor_hind" ); 
}
	
handle_reactor_setup()
{
	thread setup_timer();
	thread setup_valve();
	thread setup_steam();
	thread setup_lights();
	thread setup_sounds();
	thread monitor_steam_shutoff();
	
	foreach(p in level.players)
		p thread missing_objective_warning("so_missed_reactor_objective", &"SO_ZODIAC2_NY_HARBOR_HINT_OBJ_MISSED", "reactor_saved");
	
	level waittill ("rotation_counter");

	thread OpenDoor("door_reactor2", "org_door_reactor2", 100, "reactor_clip2");
	thread OpenDoor("door_reactor3", "org_door_reactor3", 100, "reactor_clip3");
	activate_trigger_with_noteworthy ( "reactor_spawner" );
}

missing_objective_warning(vol_noteworthy, obj_string, not_flag)
{
	level endon( "special_op_terminated" );

	if (!flag(not_flag))
	{
		level.objective_warning_triggers = getentarray( vol_noteworthy, "script_noteworthy" );
		assertex( level.objective_warning_triggers.size > 0, "missing_objective_warning() requires at least one trigger" );

		while (!flag( not_flag ))
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


setup_timer()
{
	flag_wait("hatch_open");
	//level waittill ("in_missile_room2");
	thread thermite_timer_reactor_room();
}

setup_sounds()
{
	level waittill ("in_missile_room2");
	alarm_location = GetEnt( "camera_reactor", "targetname" );
	alarm_location playloopsound ("sub_emt_alarm_01");
	
	level.reactor_valve play_valve_sounds();
	
	
	flag_wait("reactor_saved");
	alarm_location stoploopsound ();
}

setup_lights()
{
	ambient_light = GetStructarray( "ambient_light", "targetname" );
	array_thread ( ambient_light, ::make_lights );
}

make_lights()
{
	light_tag = spawn_tag_to_loc(self);
	//PlayFXontag( level._effect[ "red_light" ],light_tag, "tag_origin" );
	
	flag_wait ("reactor_saved");
	//stopFXontag( level._effect[ "red_light" ], light_tag, "tag_origin" );
}

sync_with(anchor)
{
	while (1)
	{
		self angles_and_origin(anchor);
		wait 0.05;
	}
}

setup_valve()
{
	level.reactor_valve = GetEnt( "reactor_valve", "targetname" );
	shiny_reactor_valve = make_shiny_valve( level.reactor_valve );
	shiny_reactor_valve thread sync_with( level.reactor_valve );
	level.valve_in_use = false;

	tag_for_progress = undefined;
	level.reactor_valve.rotation = 0;
	
	while(!flag("reactor_saved")) 
	{
		show_shiny_valve( shiny_reactor_valve );
		
		reset_valve_interaction( tag_for_progress );

		shiny_reactor_valve waittill ( "trigger", guy );
		
		level.reactor_valve thread turning( guy );
		
		hide_shiny_valve( shiny_reactor_valve );
					
		tag_for_progress = spawn_tag_to_loc(level.reactor_valve);
			
		if ( tag_for_progress progress( 6, guy ))
		{
			flag_set("reactor_saved");
			shiny_reactor_valve hide();
			level.reactor_valve show();
			break;
		}
	}
}

reset_valve_interaction(tag_for_progress)
{
	if(isdefined(tag_for_progress))
		tag_for_progress delete();
			
	if (level.reactor_valve.rotation > 0) 
		level.reactor_valve thread reverse_turning();
}

show_shiny_valve(shiny_reactor_valve)
{
	shiny_reactor_valve makeusable();
	level.reactor_valve hide();
	shiny_reactor_valve show();
}

hide_shiny_valve(shiny_reactor_valve)
{
	shiny_reactor_valve makeUnusable();
	shiny_reactor_valve hide();
	level.reactor_valve show();
}

turning(user)
{
	angle = 10;
	
	while ( user usebuttonpressed() )
	{
		level.valve_in_use = true;
		angles = self.angles;
		self rotateto((angles[0], angles[1], angles[2] - angle), 0.1);
		self.rotation = self.rotation + angle;
		level.turn_time = level.turn_time - 0.1;
		
		wait 0.1;

		if ( user.laststand == true )
			break;
		
		if ( flag( "reactor_saved" ))
			break;
	}
	
	level.valve_in_use = false;
}

play_valve_sounds()
{
	while ( !level.valve_in_use )
		wait 0.05;
		
	self playloopsound ( "sub_emt_vent_steamy" );
	sound_tag = spawn_tag_to_loc(self);
	
	//sound_tag playsound( "bh_wheel_turn" );
	
	flag_wait( "reactor_saved" );
	self stoploopsound ();
	
	//sound_tag playsound( "bh_russian_wheel_turn", "sound_done" );
	sound_tag waittill ( "sound_done" );
	sound_tag delete();
}

reverse_turning(user)
{
	self endon ("trigger");	
	angle = 5;
	
	while (!players_use_button() && !self.rotation <= 0 && !flag("reactor_saved"))
	{
		angles = self.angles;
		self rotateto((angles[0], angles[1], angles[2] + angle), 0.1);
		self.rotation = self.rotation - angle;
		level.turn_time = level.turn_time + 0.05;
		
		wait 0.1;
	}
}

players_use_button()
{
	level.pressed = 0;
	foreach(player in level.players)
	{
		if (player usebuttonpressed())
			level.pressed ++;
	}
	if (level.pressed > 0)
		return true;
	else
		return false;
}

monitor_steam_shutoff()
{
	compare = level.reactor_valve.rotation;
	
	while (!flag("reactor_saved"))
	{
		if ((compare < level.reactor_valve.rotation - (10)) || (compare > level.reactor_valve.rotation + (10)) )
		{
			level notify ("rotation_counter");
			compare = level.reactor_valve.rotation;
		}
		wait 0.05;
	}
}

progress(time, user)
{
	//progress_bar( player_user, success_cb, total_time, using_str, success_str, failure_cb, failure_str )
	if (self progress_bar( user, undefined, level.turn_time, &"SO_ZODIAC2_NY_HARBOR_HINT_VALVE_TURNING", &"SO_ZODIAC2_NY_HARBOR_HINT_DISARM_SUCCESS", undefined, undefined ))
		return true;
	else
		return false;
}

make_shiny_valve(item)
{
	model = "ny_harbor_sub_pipe_valve_02_obj";
	thermite = spawn( "script_model", item.origin );
	thermite setmodel( model );
	thermite angles_and_origin( item );
	thermite sethintstring( &"SO_ZODIAC2_NY_HARBOR_HINT_VALVE" );
	return thermite;
}

setup_steam()
{
	reactor_steam = GetEntArray( "reactor_steam", "targetname" );
	steam_jets = make_steam(reactor_steam);
	steam_jets = array_randomize(steam_jets);
	
	i = 0;

	while(!flag("reactor_saved")) 
	{
		current_rotation = level.reactor_valve.rotation;
		
		level waittill ( "rotation_counter" );
		
		if (current_rotation < level.reactor_valve.rotation)
		{
			if (isdefined(steam_jets[i]))
			{
				stopFXOnTag( getfx("steam_jet1"), steam_jets[i], "tag_origin" );
				steam_jets[i] stoploopsound();
			}
			i++;
		}
		else
		{
			if (isdefined(steam_jets[i]))
			{
				playFXOnTag( getfx("steam_jet1"), steam_jets[i], "tag_origin" );
				steam_jets[i] playloopsound("sub_emt_steam_lp_01");
			}
			i--;
		}
	}
	
	flag_wait ("reactor_saved");
	
	foreach(jet in steam_jets)
		stopFXOnTag( getfx("steam_jet1"), jet, "tag_origin" );
		
}

make_steam(org_array)
{
	jets = [];
	foreach(i, org in org_array)
	{
		jets[i] = spawn_tag_to_loc(org);
		PlayFXOnTag( getfx("steam_jet1"), jets[i], "tag_origin" );
		jets[i] playloopsound("sub_emt_steam_lp_01");
	}
	return jets;
}

setup_missile_room()
{
	door_blockers();

	thread thermite_hunt();
	thread combat_missile_room1();
	thread combat_after_thermite();

}

combat_missile_room1()
{
	thread open_doors_with_animations();
		
	flag_wait ("kill_spawners_1");
	guys = spawn_missile_room_1_guys( "spawner_mis1_1", ::add_enemy_flashlight );

	array_thread (level.players, ::thermal_reminder_on, "thermal_reminder_trig");
	array_thread (level.players, ::thermal_reminder_off, "exit_missile_room_1");
	
	flag_wait ("in_missile_room");
	array_thread (level.players, ::put_light_on_players);
	
	waittill_guys_are_dead( guys );
	
	flag_set("bombs_defused_missile_room");

	thread play_alarm_missile_room();
}

timer (num, note)
{
	wait(num);
	self notify (note);
}

thermal_reminder_on( trigger )
{
	while (1)
	{
		guy = get_and_wait_for_trigger( trigger );
		if (guy == self && !self.thermal )
		{
			self forceusehinton( &"SO_ZODIAC2_NY_HARBOR_HINT_THERMAL_ON" );
			self thread timer( 3.5, "timer_up" );
			self waittill_either("thermal_on", "timer_up");
			self forceusehintoff();
			break;
		}
	}
}

thermal_reminder_off( trigger )
{
	while (1)
	{
		guy = get_and_wait_for_trigger( trigger );
		if (guy == self && self.thermal )
		{
			self forceusehinton( &"SO_ZODIAC2_NY_HARBOR_HINT_THERMAL_ON" );
			self thread timer( 3.5, "timer_up" );
			self waittill_either("thermal_off", "timer_up");
			self forceusehintoff();
			break;
		}
	}
}

get_and_wait_for_trigger(trigger)
{
	thermal_reminder_trig = GetEnt( trigger, "targetname" );
	thermal_reminder_trig waittill ("trigger", guy);
	return guy;
}

play_alarm_missile_room()
{
	camera1 = GetEnt( "camera1", "targetname" );
	camera2 = GetEnt( "camera2", "targetname" );
	
	camera2 playloopsound("sub_emt_alarm_01");
	camera1 playloopsound("sub_emt_alarm_01");
	
	wait 1;
	
	level notify ("trigger_missile_bombs");
}

open_doors_with_animations()
{
	thread move_big_block();
	flag_wait( "bombs_defused_missile_room" );
	spawners_door_guys = GetEnt( "spawners_door_guys", "targetname" );
	assert (isdefined(spawners_door_guys));
	
	if (level.single_player)
	{
		upper_vol = GetEnt( "upper_vol", "targetname" );
		
		big_coll_block1_b = GetEnt( "big_coll_block1_b", "targetname" );
		big_coll_block1_b notsolid();
		
		big_coll_block2_b = GetEnt( "big_coll_block2_b", "targetname" );
		big_coll_block2_b notsolid();
		
		big_coll_block1 = GetEnt( "big_coll_block1", "targetname" );
		big_coll_block1 notsolid();
		
		big_coll_block2 = GetEnt( "big_coll_block2", "targetname" );
		big_coll_block2 notsolid();
	
		
		if( upper_vol istouching( level.players[0]))
		{
			thread anim_open_door( spawners_door_guys, "door_open_north_top_org", "door_missile_room_1_1", "door_clip_top_north" );
			level.players[0].upper_floor = true;
		}
		else
			thread anim_open_door( spawners_door_guys, "door_open_north_org", "door_missile_room_1_2", "door_clip_bottom_north" );
	}
	else
	{
		thread anim_open_door_special(spawners_door_guys, "door_open_south_org", "door_missile_room_1_3", "door_clip_top_south", "door_exit_1_3_origin", "door_exit_1_3_coll2");
		wait .5;
		thread anim_open_door(spawners_door_guys, "door_open_north_org", "door_missile_room_1_2", "door_clip_bottom_north" );
	}
}

coll_not_solid_if_player_is_near(coll)
{
	door_coll = Getent( coll, "targetname" );
	vol_coll_issue = GetEnt( "vol_for_door_coll_issue", "targetname" );
	
	while(1)
	{
		wait 0.05;
		if(players_touching(vol_coll_issue))
			door_coll notsolid();
		else 
			door_coll solid();
		if( flag ("door_3_is_open") && !players_touching(vol_coll_issue))
		{
			door_coll solid();
			break;
		}
	}
}

players_touching(vol)
{
	foreach(p in level.players)
	{
		if(vol istouching(p))	
			return true;
	}
	return false;
	
}

anim_open_door_special(spawner, guy_origin, door_model, door_coll, pivot, door_coll2)
{
	guy_org   = GetEnt( guy_origin, "targetname" );
	door_clip = GetEnt( door_coll,  "targetname" );
	old_door  = GetEnt( door_model, "targetname" );
	door_clip2 = GetEnt( door_coll2,  "targetname" );
	path_blocker = GetEnt( "path_blocker", "targetname" );
	
	door_clip2 notsolid();
	path_blocker notsolid();
	
	vol_for_door_coll_issue = GetEnt( "vol_for_door_coll_issue", "targetname" );

	guy_org spawn_guy_and_start_door_anim(spawner);
	
	wait 205/30;

	pivot_org = GetEnt( pivot, "targetname" );
	doortag = spawn_tag_to_loc( pivot_org );
	door_clip2 linkto(doortag, "tag_origin");
	old_door linkto(doortag, "tag_origin");
	doortag rotateto((0, 80, 0 ), 1);
	wait 1;
	doortag rotateto((0, 120, 0 ), 1.1);
	wait 1;
	door_clip.origin = (0,0,0);
	
	wait (205 - 30)/30;
	
	
	flag_set ("door_3_is_open");
	
	door_clip connectpaths();
	
	path_blocker solid();
	path_blocker connectpaths();
	
	//door_clip2 solid();
	door_clip2 connectpaths();
}

move_big_block()
{
	big_coll_block2 = GetEnt( "big_coll_block2", "targetname" );
	big_coll_block1 = GetEnt( "big_coll_block1", "targetname" );
	big_coll_block1 notsolid();
	
	big_coll_block2_b = GetEnt( "big_coll_block2_b", "targetname" );
	big_coll_block1_b = GetEnt( "big_coll_block1_b", "targetname" );
	big_coll_block1_b notsolid();
	
	start_org = big_coll_block2.origin;
	end_org = big_coll_block1.origin;
	end_org_b = big_coll_block1_b.origin;
	
	flag_wait( "bombs_defused_missile_room" );
	wait 205/30;
	big_coll_block2 moveto(end_org, 1.5);
	big_coll_block2_b moveto(end_org_b, 1.5);
	wait 1.5;
	
	//flag_wait ("door_3_is_open");

	big_coll_block2 connectpaths();
	big_coll_block2_b connectpaths();
	big_coll_block1 connectpaths();
	big_coll_block1_b connectpaths();
	big_coll_block2 delete();
}

spawn_guy_and_start_door_anim(spawner)
{
	wait (randomfloatrange(0.5, 1.2));
	
	guy = spawner stalingradspawn();

	if (isdefined(guy))	
	{
		guy_anime = self.animation;
		guy.animname = "generic";
		self thread anim_generic(guy, guy_anime);
		guy thread stop_anim_if_dead();
	}
	
}

anim_open_door(spawner, guy_origin, door_model, door_coll, angle)
{
	guy_org   = GetEnt( guy_origin, "targetname" );
	door_clip = GetEnt( door_coll,  "targetname" );
	old_door  = GetEnt( door_model, "targetname" );
	old_door.origin = (0,0,0);
	
	door = spawn_anim_model( "door", guy_org.origin );
	door_anime = "open_with_wheel" ;
	guy_org anim_first_frame_solo( door, door_anime );	
	
	guy_org spawn_guy_and_start_door_anim(spawner);
	
	door.animname = "door";
	door setanimtree();
	guy_org thread anim_single_solo(door, door_anime);

	wait 235/30;
	door_clip.origin = (0,0,0);
	door_clip connectpaths();
}

stop_anim_if_dead()
{
	while (isdefined(self) && self.health > 10)
		wait 0.05;
	
	if (isdefined(self))
		self stopanimscripted();
}

waittill_guys_are_dead(array_of_guys)
{
	dudes = array_of_guys.size - 2;
		
	compare = array_of_guys.size - dudes;
	
	while (array_of_guys.size > compare)
	{
		array_of_guys = array_removedead(array_of_guys);
		wait 0.05;
	}
}

add_enemy_flashlight()
{
	//PlayFXOnTag( getfx("flashlight_ai"), self, "tag_flash" );
	//self.have_flashlight = true;
}


thermite_hunt()
{
	bombs = GetEntArray( "therm_mis1", "targetname" );
	array_call (bombs, ::delete);
}


thermite_setup(num_explosives, targetname, note, distx)
{
	new_array = [];
	bombs = [];
	bombs = GetEntArray( targetname, "targetname" );
	bombs = array_randomize(bombs);

	if (!isdefined(num_explosives))
		num_explosives = bombs.size;
		
	foreach(item in bombs)
			item hide();
			
	for(i = 0; i < num_explosives; i++)
	{
		bombs[i] show();
		new_array[new_array.size] = bombs[i];
		bombs[i] thread create_bomb_lights(note);
	}

	return new_array;
}

create_bomb_lights(note)
{
	if (isdefined(note))
		level waittill (note);
	
	angles = self GetTagAngles( "tag_fx" );
	forward = anglestoup( angles );
	offset = self.origin + ( forward * 5 );
	
	self.tag_light = spawn_tag_origin();
	self.tag_light.origin = offset;

	wait (randomfloatrange(0.1, 0.6));
	PlayFXontag( level._effect[ "red_dot" ],self.tag_light, "tag_origin" );
	PlayFXontag( level._effect[ "light_c4_blink" ], self, "tag_fx" );
	PlayFXontag( level._effect[ "light_c4_blink" ], self, "tag_fx" );
	PlayFXontag( level._effect[ "red_dot" ],self, "tag_fx" );
	PlayFXontag( level._effect[ "white_light" ], self, "tag_fx" );
	
	self thread beep_cycle();
}

beep_cycle()
{
	if (!isdefined(self.defused))
		self.defused = false;
		
	while (!self.defused)
	{
		if(isdefined(self))
			self thread play_sound_on_entity( "veh_mine_beep" );
		else 
			break;
		wait 1;
	}
}

monitor_remaining_bombs(flg, bombs)
{
	level.bombs = bombs.size +1;
	while (!flag(flg))
	{
		if (bombs.size < 1)
			flag_set(flg);
		else 
		{
			foreach (bomb in bombs )
			{
				if(isdefined(bomb.defused) && bomb.defused)
				{
					bombs = array_remove(bombs, bomb);
					level.bombs--;
					
					if (level.bombs == 1)
						level notify ("one_bomb_left");
					if (level.bombs == bombs.size)
						level notify ("one_bomb_defused");
				}
			}
		}
		wait 0.05;
	}
}


OpenDoor(targetname, org_name, angle, coll)
{
	time = 3;
	door = getent( targetname, "targetname" );
	org = getent( org_name, "targetname" );
	tag = spawn_tag_to_loc( org );
	
	door linkto ( tag, "tag_origin" );
	tag rotateto(( 0, angle, 0 ), time);
	
	wait (time/2);
	if (isdefined(coll))
	{
		clip = getent(coll, "targetname");
		clip.origin = (0,0,0);
		clip connectpaths();
	}
}

get_index_in_array( array, value )
{
	Assert( IsDefined( array ) );
	Assert( IsDefined( value ) );
	
	index = -1;
	
	foreach ( i, item in array )
		if ( item == value )
			index = i;
	return index;
}

//----------------------------------------------------------------------------------------camera logic start
//---------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------camera logic end
//---------------------------------------------------------------------------------------------------------


thermite_timer_reactor_room()
{
	time = 300;
	
	thread start_countdown( time, &"SO_ZODIAC2_NY_HARBOR_HINT_MELTDOWN", "times_up_reactor" );
	
	thread thermite_fail( "times_up_reactor", "reactor_saved");
	
	thread timer_hud_remove_if_valve_in_use();
	
	flag_wait( "reactor_saved" );
	
	foreach (hud in level.elements)
	{
		if (isdefined(hud)) // in case it is being disarmed during and after the end of the timer
			hud destroy();
	}
}

timer_hud_remove_if_valve_in_use()
{
	while ( !flag( "reactor_saved" ))
	{
		if ( level.valve_in_use )
			level.elements hud_alpha( 0 );
		else
			level.elements hud_alpha( 1 );
		
		wait 0.05;
	}
}

hud_alpha( opacity )
{
	foreach ( hud in self )
	{
		if( isdefined( hud ))
			hud.alpha = opacity;
	}
}

thermite_fail(flg1, flg2)
{
	flag_wait( flg1 );
	nuke_view = GetEntArray( "nuke_view", "targetname" );
	wait 0.25;
	
	while (level.valve_in_use)
		wait 0.5;
	
	if (!flag(flg2 ))
	{
		overlay = blackOut(&"SO_ZODIAC2_NY_HARBOR_HINT_FAIL");
		overlay thread fadeBlackOut(.25 );
		
		wait .5;
		end_mission_fail();
	}
}

end_mission_fail()
{
	level.challenge_end_time = gettime();

	so_force_deadquote( "@DEADQUOTE_SO_TRY_NEW_DIFFICULTY" );
	maps\_utility::missionFailedWrapper();
}

teleport_and_clamp_view(location)
{
	self teleport_player_so(location);
	self PlayerLinkToDelta(location, "tag_origin", 1);
	self LerpViewAngleClamp( 0, 0.5, 0, 110, 110, 90, 90 );	
}

teleport_player_so( object )
{
	self SetOrigin( object.origin );
	if ( IsDefined( object.angles ) )
  	self SetPlayerAngles( object.angles );
}

put_light_on_players()
{
	exit_missile_room_1 = GetEnt( "exit_missile_room_1", "targetname" );
	//wait 1;
	//self.light = spawn( "script_model", self getEye() );
	//self.light setmodel( "tag_origin" );
	//self.light linkto( self );
	//PlayFXontag( level._effect[ "Dlight" ], self.light, "tag_origin" );

	while (1)
	{
		exit_missile_room_1 waittill ("trigger", guy);
		level notify ("in_missile_room2");
		if (guy == self)
			break;
	}

	//StopFXontag( level._effect[ "Dlight" ], self.light, "tag_origin" );
}

combat_after_thermite()
{
	flag_wait( "bombs_defused_missile_room" );
	activate_trigger_with_noteworthy("f_spawner_mis2");
}

enemy_ai_for_sub()
{
	acc = 0.7;
	acc_mod = 1;
	
	
	self enable_cqbwalk();
	self.accuracy = acc;
	self.baseAccuracy = self.baseAccuracy * acc_mod;
	if (cointoss())
		self.ignoreSuppression = true;
	else
		self.ignoreSuppression = false;
}

door_blockers()
{
	pressure_door_model = GetEntArray( "pressure_door_model", "targetname" );
	array_call(pressure_door_model, ::delete);
	
	pressure_door_coll = GetEntArray( "pressure_door_coll", "targetname" );
	array_call(pressure_door_coll, ::delete);
	
	sub_pressuredoor_rocker_opposite = GetEntArray( "sub_pressuredoor_rocker_opposite", "targetname" );
	array_call(sub_pressuredoor_rocker_opposite, ::delete);
	
	sub_pressuredoor_rocker = GetEntArray( "sub_pressuredoor_rocker", "targetname" );
	array_call(sub_pressuredoor_rocker, ::delete);
	
	ladder_coll_bridge_exit = GetEntArray( "ladder_coll_bridge_exit", "targetname" );
	array_call(ladder_coll_bridge_exit, ::delete);
	
	
	delete_this( "barracks_door_coll_01", 1 );
	delete_this( "breach_door_col" );
	delete_this( "brush_missile_room_door", 1 );
	delete_this( "clip_reactor_room_hall_door", 1 );
	delete_this( "clip_barracks_exit", 1 );
	delete_this( "barracks_open_door_col", 1 );
	delete_this( "barracks_open_door_right_col", 1 );
	delete_this( "sub_graph_blocker", 1 );

	level.frag = getent( "frag_grenade", "targetname" );
	level.frag hide();
}

delete_this(name, connect)
{
	brush = GetEnt( name, "targetname" );
	
	if(isdefined( brush ))
	{
		brush.origin = ( 0,0,0 );
		
		if(isdefined( connect ))
			brush connectpaths();
	}
}

open_hatch()
{
	foreach(p in level.players)
		p.ladder = false;
	//sub_rear_ladder_col = GetEnt( "sub_rear_ladder_col", "targetname" );
	//sub_rear_ladder_col delete();
	
	flag_wait("open_rear_hatch");
	maps\_compass::setupMiniMap("compass_map_ny_harbor");
	
	rear_hatch_collision = GetEntArray( "rear_hatch_collision", "targetname" );
	assert (rear_hatch_collision.size > 0);
	array_call (rear_hatch_collision, ::delete);

	hatchA = getent("hatch_component1", "targetname");
	hatchB = getent("hatch_component2", "targetname");

	org3 = getent("hatch_org", "targetname");
	org = spawn_tag_to_loc(org3);
	
	hatchA linkto (org, "tag_origin");
	hatchB linkto (org, "tag_origin");
	
	org rotateto((154,0,180), 1.35);
	
	level notify ("spawn_exit_chopper");
}

handle_exit_movement()
{
	thread open_hatch();
	thread handle_ladder_up_down("hatch_player_slide", "exit_trigger_sub", "check_for_player_using_ladder");
}

handle_ladder_up_down(sight_trig, move_trig, inside_trig)
{
	thread hatch_player_slide(sight_trig, "exit_ladder_pos1", "exit_ladder_pos0");
		
	trigger = GetEnt( sight_trig, "targetname" );//exit_trigger_sub

	trigger.moved = false;
	
	array_thread(level.players, ::hide_trigger_when_ladder_in_use, trigger, inside_trig);
	
	initiate_movememnt_trigger = GetEnt( move_trig, "targetname" );
	
	while (1)
	{
		initiate_movememnt_trigger waittill ("trigger", guy);
		guy move_guy_up();
	}
}

hide_trigger_when_ladder_in_use( trigger, inside_trigger )
{
	vol = GetEnt( inside_trigger, "targetname" );
	trigger_org = trigger.origin;
	
	while (1)
	{
		wait 0.05;
		
		if ( vol istouching( self ) && !trigger.moved )
		{
			trigger.moved = true;
			trigger.origin = (50,50,50);
		}
		else if( !vol istouching( self ) && trigger.moved )
		{
			//wait 2;
			trigger.origin = trigger_org;
			trigger.moved = false;
		}
	}
}

hide_trigger_when_ladder_in_use_front( trigger, inside_trigger )
{
	vol = GetEnt( inside_trigger, "targetname" );
	trigger_org = trigger.origin;

	
	while (1)
	{
		wait 0.05;
		
		if ( vol istouching( self ) && !trigger.moved )
		{
			trigger.moved = true;
			trigger.origin = (50,50,50);
		}
		else if( !vol istouching( self ) && trigger.moved && IsOkToUseLadder(self ) )
		{
			//wait 2;
			trigger.origin = trigger_org;
			trigger.moved = false;
		}
	}
}

IsOkToUseLadder(dude)
{
		
	ladder_clip_vol = GetEnt( "ladder_safety_clip_vol", "targetname" );

	
	if(!level.single_player)
	{
		foreach (p in level.players)
		{
			if (ladder_clip_vol istouching (p))
				return false;
		}
		return true;
	}
	else
		return true;
}

hatch_player_slide(trig_name, pos1, pos2)
{
	//player_enter_sub_rear = GetEnt( "player_enter_sub_rear", "targetname" );
	use_trigger = getent( trig_name, "targetname" );
	dont_allow_ladder = GetEnt( "dont_allow_ladder", "targetname" );
	while (1)
	{
		use_trigger SetHintString( &"NY_HARBOR_HINT_USE_TO_ENTER" );
		use_trigger UseTriggerRequireLookAt();
		use_trigger waittill( "trigger", guy );
		if (!dont_allow_ladder istouching(guy))
			guy move_guy_down(pos1, pos2);
	}
}

player_using_ladder()
{
	check_for_player_using_ladder = GetEnt( "check_for_player_using_ladder", "targetname" );
	
	foreach ( p in level.players )
	{
		if ( check_for_player_using_ladder istouching( p ))
			return true;
	}
	return false;
}

	
move_guy_down(pos1, pos2)
{
	exit_ladder_pos1 = GetEnt( pos1, "targetname" );
	exit_ladder_pos0 = GetEnt( pos2, "targetname" );

	if (!self.ladder && !player_using_ladder())
	{
		exit_tag = spawn_tag_to_loc( self );
		
		self.ladder = true;
		
		self playerlinkto( exit_tag, "tag_origin", 1);
	
		exit_tag moveto ( exit_ladder_pos1.origin, .25);
		wait .25;
	
		exit_tag moveto ( exit_ladder_pos0.origin, .75);
		exit_tag rotateto ( exit_ladder_pos0.angles, .75);
		wait .8;
		
		self unlink();

		self.ladder = false;
		
		exit_tag delete();
	}
}


move_guy_up()
{
	exit_ladder_pos1 = GetEnt( "exit_ladder_pos1", "targetname" );
	exit_ladder_pos2_p0 = GetEnt( "exit_ladder_pos2_p0", "targetname" );
	exit_ladder_pos2_p1 = GetEnt( "exit_ladder_pos2_p1", "targetname" );
	
	if (!self.ladder)
	{
		exit_tag = spawn_tag_to_loc(self);
		
		self.ladder = true;
		
		self playerlinkto( exit_tag, "tag_origin", 1 );
		exit_tag moveto ( exit_ladder_pos1.origin, 1 );
		wait 1;
		
		if (self == level.players[0])
		{
			exit_tag moveto ( exit_ladder_pos2_p0.origin, 1 );
			exit_tag rotateto ( exit_ladder_pos2_p0.angles, 1 );
		}
		else
		{
			exit_tag moveto ( exit_ladder_pos2_p1.origin, 1 );
			exit_tag rotateto ( exit_ladder_pos2_p1.angles, 1 );
		}
			
		wait 1;
		self unlink();
		self.ladder = false;
	}

}


handle_exit()
{
	thread handle_exit_chopper();
	thread remove_end_mission_triggers();
	thread handle_enemy_choppers();
	thread handle_exit_movement();
	thread close_hatch_rear();
	
	flag_wait( "reactor_saved" );
	flag_init( "so_exit_volume");
	enable_triggered_complete( "so_exit_volume", "so_zodiac2_ny_harbor_complete", "all" );
	
	flag_wait("so_zodiac2_ny_harbor_complete");
	
	guys = getaiarray("axis");
	array_call(guys, ::kill);
}

remove_end_mission_triggers()
{
	level waittill ("spawn_exit_chopper");
	player_trying_to_escape = GetEntArray( "player_trying_to_escape", "targetname" );
	
	foreach( t in player_trying_to_escape )
		t.origin = (0,0,0);
}

handle_enemy_choppers()
{
	flag_wait("spawn_enemy_chopper2");
	enemy2 = spawn_vehicle_from_targetname_and_drive( "end_enemy_chopper2" );

}

handle_exit_chopper()
{
	flag_wait("spawn_exit_chopper");

	so_exit_volume = GetEnt( "so_exit_volume", "script_noteworthy" );
	//level.exit_hind = spawn_vehicle_from_targetname_and_drive( "player_hind_exit" );
	aud_send_msg("so_start_harbor_exit_hind", level.player_hind);
	
	//ally_fire_points = GetStructArray( "ally_fire_points", "targetname" );
	
	//level.exit_hind.fire_tags = [];
	//foreach(i, point in ally_fire_points)
		//level.exit_hind.fire_tags[i] = make_custom_tag_from_ent(point, level.exit_hind);

	so_exit_volume thread move_vol_with_veh( level.player_hind );
	//level.exit_hind thread fire_at_enemies_when_close();
}

fire_at_enemies_when_close()
{
	flag_wait( "shoot_at_stragglers" );

	while (1)
	{
		wait 0.05;
		dude = get_closest_ai( self.origin, "axis" );
		shooter = self.fire_tags[randomint(self.fire_tags.size)];
		if (isdefined(dude))
			shooter shoot_dude( dude );
	}
	
}

shoot_dude( dude )
{
	//inaccurate_magicbullet(gun, offset_range, target_pos, shooter_pos)
	num = randomintrange(5,12);
	for (i = 0; i < num; i++)
	{
		if (isdefined(dude))
			inaccurate_magicbullet("mp7_reflex", 15, dude.origin, self);
		wait 0.05;
	}
}

move_vol_with_veh(veh)
{
	while (1)
	{
		self.origin = veh.origin;
		wait 0.05;
	}
}


open_hatch_rear()
{
	col = getent( "rear_hatch_col", "targetname" );
	col notsolid();
	
	flag_wait("hatch_open");
	org = create_hatch_movable();
	maps\_compass::setupMiniMap("compass_map_ny_harbor_sub", "sub_minimap_corner");
	setsaveddvar( "compassmaxrange", 1000 );

	org rotateto((89, org.angles[1], org.angles[2]) , 3);
}

close_hatch_rear()
{
	exit_missile_room_1 = GetEnt( "exit_missile_room_1", "targetname" );
	array_thread (level.players, ::verify_player_in_sub, exit_missile_room_1);

	ladder_brush_bridge = GetEnt( "ladder_brush_bridge", "targetname" );
	ladder_org = ladder_brush_bridge.origin;
	ladder_brush_bridge.origin = (50,50,50);

	flag_wait("spawn_enemy_chopper2");
	sight_trigger_front_hatch = GetEnt( "sight_trigger_front_hatch", "targetname" );
	sight_trigger_front_hatch.origin = (50,50,50);
	
	if (flag ("close_hatch"))
	{
		org = create_hatch_movable();
		org rotateto((-89, org.angles[1], org.angles[2]) , 3);
	}
	else
		ladder_brush_bridge.origin = ladder_org;
}

verify_player_in_sub(trigger)
{
	level.is_in_sub = 0;
	
	while ( 1 )
	{
		trigger waittill ( "trigger", guy );
		if ( guy == self )
		{
			level.is_in_sub++;
			
			if( level.is_in_sub == level.players.size )
				flag_set ("close_hatch");
			
			break;
		}
	}
}

create_hatch_movable()
{
	hatchA = getent("rear_hatch_component1", "targetname");
	hatchB = getent("rear_hatch_component2", "targetname");
	hatch_col_top = getent( "rear_hatch_col_top", "targetname" );
	hatch_col_top notsolid();
	
	org3 = getent("rear_hatch_org", "targetname");
	org = spawn_tag_to_loc( org3 );

	hatchA linkto (org, "tag_origin");
	hatchB linkto (org, "tag_origin");
	hatch_col_top linkto (org, "tag_origin");
	
	hatch_col = getent( "rear_hatch_col_interior", "targetname" );
	hatch_col notsolid();
	
	return org;
}

make_custom_tag_from_structarray(targetname, ent)
{
	array = [];
	orgs = GetStructArray( targetname, "targetname" );
	foreach(s in orgs)
	{
		tag = make_tag_with_origin(s, ent);	
		array[array.size] = tag;
	}
	return array;
}

make_custom_tag_from_struct(targetname, ent)
{
	org = Getstruct( targetname, "targetname" );
	tag = make_tag_with_origin(org, ent);
	return tag;
}

make_custom_tag_from_targetname(targetname, ent)
{
	org = GetEnt( targetname, "targetname" );
	assert (isdefined(org));
	tag = make_tag_with_origin(org, ent);
	return tag;
}

make_custom_tag_from_ent(org, ent)
{
	assert (isdefined(org));
	tag = make_tag_with_origin(org, ent);
	return tag;
}

make_tag_with_origin(org, ent)
{
	tag = spawn_tag_to_loc( org );
	tag linkto (ent, "tag_origin");
	return tag;
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


silo_doors_and_missiles()
{
	thread play_smoke_for_missiles();
	missile_right_8 = [ "missile_hatch_r_8", "missiles_r_8", "missle_silo_r_5" ];
	missile_right_7 = [ "missile_hatch_r_7", "missiles_r_7", "missle_silo_r_4", "missle_silo_r_3" ];
	missile_right_6 = [ "missile_hatch_r_6", "missiles_r_6", "missle_silo_r_3" ];
	missile_right_5 = [ "missile_hatch_r_5", "missiles_r_5", "missle_silo_r_3" ];
	missile_right_4 = [ "missile_hatch_r_4", "missiles_r_4", "missle_silo_r_2" ];
	missile_right_3 = [ "missile_hatch_r_3", "missiles_r_3", "missle_silo_r_2" ];
	missile_right_2 = [ "missile_hatch_r_2", "missiles_r_2", "missle_silo_r_1" ];
	missile_right_1 = [ "missile_hatch_r_1", "missiles_r_1", "missle_silo_r_1", "missle_silo_r_0" ];
	missile_right_0 = [ "missile_hatch_r_1", "missiles_r_1", "missle_silo_r_0" ];
	
	missile_left_8 = [ "missile_hatch_l_8", "missiles_l_8", "missle_silo_l_5" ];
	missile_left_7 = [ "missile_hatch_l_7", "missiles_l_7", "missle_silo_l_4", "missle_silo_l_3" ];
	missile_left_6 = [ "missile_hatch_l_6", "missiles_l_6", "missle_silo_l_3" ];
	missile_left_5 = [ "missile_hatch_l_5", "missiles_l_5", "missle_silo_l_3" ];
	missile_left_4 = [ "missile_hatch_l_4", "missiles_l_4", "missle_silo_l_2" ];
	missile_left_3 = [ "missile_hatch_l_3", "missiles_l_3", "missle_silo_l_2" ];
	missile_left_2 = [ "missile_hatch_l_2", "missiles_l_2", "missle_silo_l_1" ];
	missile_left_1 = [ "missile_hatch_l_1", "missiles_l_1", "missle_silo_l_1", "missle_silo_l_0" ];
	missile_left_0 = [ "missile_hatch_l_1", "missiles_l_1", "missle_silo_l_0" ];
	
	level.right_missile_groups = [];
	//level.right_missile_groups[0] = missile_right_0;
	//level.right_missile_groups[1] = missile_right_1;
	//level.right_missile_groups[2] = missile_right_2;
	//level.right_missile_groups[3] = missile_right_3;
	//level.right_missile_groups[4] = missile_right_4;
	//level.right_missile_groups[5] = missile_right_5;
	//level.right_missile_groups[6] = missile_right_6;
	//level.right_missile_groups[7] = missile_right_7;
	//level.right_missile_groups[8] = missile_right_8;
	level.right_missile_groups[0] = missile_right_8;
	level.right_missile_groups[1] = missile_right_0;
	
	level.left_missile_groups = [];
	//level.left_missile_groups[0] = missile_left_0;
	//level.left_missile_groups[1] = missile_left_1;
	//level.left_missile_groups[2] = missile_left_2;
	//level.left_missile_groups[3] = missile_left_3;
	//level.left_missile_groups[4] = missile_left_4;
	//level.left_missile_groups[5] = missile_left_5;
	//level.left_missile_groups[6] = missile_left_6;
	//level.left_missile_groups[7] = missile_left_7;
	//level.left_missile_groups[8] = missile_left_8;
	level.left_missile_groups[0] = missile_left_8;
	level.left_missile_groups[1] = missile_left_0;
	
	flag_wait("hind_ready_for_land");
	close_doors_and_delete();
	//thread random_missile_launch(level.right_missile_groups);
	//thread random_missile_launch(level.left_missile_groups);
}

random_missile_launch( missile_array )
{
	door_array = [];
	hatch_array = [];
	array = [];
	wait randomfloatrange(1.0, 4.0);
	
	while (!flag("in_missile_room"))
	{
		i = randomint(missile_array.size);
		if(!isdefined(array[i]))
		{
			door_array[door_array.size] = open_missile_silo( missile_array[ i ][ 2 ], i );
			array[i] = 1;
		}
		else 
			wait 4;
		hatch_array[hatch_array.size] = open_missile_hatch( missile_array[ i ] [ 0 ]);
		launch_ssn19( missile_array[ i ] [ 1 ]);
		wait (randomfloatrange(0.05, 0.5));
	}
}

close_doors_and_delete(hatch_array, door_array)
{
	missile_silo_door = GetEntArray( "missile_silo_door", "targetname" );
	array_call (missile_silo_door, ::hide);
	
	missle_silo_pocket_middle = GetEntArray( "missle_silo_pocket_middle", "targetname" );
	array_call (missle_silo_pocket_middle, ::hide);
	
	missle_silo_pocket = GetEntarray( "missle_silo_pocket", "targetname" );
	array_call (missle_silo_pocket, ::hide);
	
	missle_silo_pocket_rear = GetEntArray( "missle_silo_pocket_rear", "targetname" );
	array_call (missle_silo_pocket_rear, ::hide);
}

open_missile_hatch( hatch )
{
	ents = getentarray( hatch,"script_noteworthy" );
	animated = undefined;
	foreach(ent in ents)
	{
		if (!isdefined(ent.targetname))
			continue;
		if (ent.targetname == "missile_hatch")
		{
			animated = ent;
			break;
		}
	}
	assert(isdefined(animated));
	animated.animname = "missile_hatch";
	animated SetAnimTree();
	dummy = spawn_tag_origin();
	dummy.origin = animated.origin;
	dummy.angles = (270,0,0);// animated.angles;
	playfxontag(getfx("steam_missile_tube"), dummy, "tag_origin");
	animated anim_single_solo( animated, "open");
	life = randomfloat(3) + 2;
	wait (life);
	stopfxontag(getfx("steam_missile_tube"), dummy, "tag_origin");
	dummy delete();
	
	return animated;
}

open_missile_silo( name, index )
{
	ents = getentarray( name,"script_noteworthy" );
	// out of the ents, find the one with the correct targetname
	animated = undefined;
	foreach(ent in ents)
	{
		if (!isdefined(ent.targetname))
			continue;
		if (ent.targetname == "missile_silo_door")
		{
			animated = ent;
			break;
		}
	}
	assert(isdefined(animated));
	assert(isdefined(animated.target));
	target = undefined;
	foreach(ent in ents)
	{
		if (!isdefined(ent.targetname))
			continue;
		if (ent.targetname == animated.target)
		{
			target = ent;
			break;
		}
	}
	assert(isdefined(target));
	animated.animname = "missile_door";
	animated SetAnimTree();
	target linkto(animated,"door");
	aud_send_msg("sub_missile_door_open", target);
	
	target playsound("russian_sub_missile_door");
	
	animated anim_single_solo( animated, "open");
	
	return animated;
}

play_ssn19fx( name )
{
	wait(0.95);
	PlayFXOnTag( getfx( "ssn12_launch_smoke12" ), self, "tag_tail" );
	wait(.5);
	ent_flag_waitopen( "contrails" );
	stopfxontag(getfx( "ssn12_launch_smoke12" ), self, "tag_tail");
}

play_ssn19fx_alt( name )
{
	wait(.5);
	PlayFXOnTag( getfx( "ssn12_launch_smoke" ), self, "tag_tail" );

	wait(.5);
	PlayFXOnTag( getfx( "ssn12_init" ), self, "tag_tail" );
}

open_ssn19_wings()
{
	self endon("death");
	wait 0.5;
	self setanim( level.scr_anim["ss_n_12_missile"]["open"], 1, 0 );
}

launch_ssn19( ssn19)
{
	// use the hatch to determine the starting point for the missile
	missile = spawn_vehicle_from_targetname( ssn19 );
	missile.animname = "ss_n_12_missile";
	missile SetAnimTree();
	missile setanim( missile getanim("close_idle"), 1, 0 );
	missile.script_vehicle_selfremove = true;
	missile thread play_ssn19fx( ssn19 );//seperate thread to sequence fx off the missiles
	aud_send_msg("so_sub_missile_launch", missile);


	wait 0.75;
	missile thread open_ssn19_wings();
	thread gopath( missile );
	aud_send_msg("so_sub_missile_launch", missile);
}

StopRocking( ref2 )
{
	flag_wait( "so_zodiac2_ny_harbor_complete" );
	level notify("stop_rocking");
	level.player playerSetGroundReferenceEnt( undefined );
	self Delete();
	if (isdefined(ref2))
		ref2 Delete();
}

OnOutsideOfSub()
{
	level.rocking_mag[0] = 0.5;
	level.rocking_mag[1] = 1.5;
	flag_set("outside_above_water");
}

OnInsideOfSub()
{
	level.rocking_mag[0] = 1.0;
	level.rocking_mag[1] = 2.5;
	flag_clear("outside_above_water");
}

//borrowed verbatim from sp
RockingSub()
{
	level endon("stop_rocking");
	refposent = getent("rocking_reference", "targetname");
	refent = spawn_tag_origin();
	refent2 = undefined;
	if (!isdefined(refposent))
	{
		refent.angles = (0, 0, 0);
	}
	else
	{
		refent.origin = refposent.origin;
		refent.angles = refposent.angles;
	}
	refent thread StopRocking( refent2 );
	sgn = 1;
	level.rocking_mag[0] = 1.0;
	level.rocking_mag[1] = 2.5;
	rocking_waters = getentarray( "rocking_water", "targetname" );
	debris = getentarray( "bobbing_small", "script_noteworthy" );
	foreach (ent in debris)
	{
		ent.start_origin = ent.origin;
		ent.start_angles = ent.angles;
		
		x = cos(ent.angles[1]);
		y = sin(ent.angles[1]);
		ent.rock_ang = (x, 0, y);
	}
	if (isdefined(refent2))
	{
		foreach (ent in rocking_waters)
		{
			ent linkto( refent2, "tag_origin" );
		}
	}
	thread setup_ent_rockers();
	self playerSetGroundReferenceEnt( refent );
	thread set_grav( refent );
	while (true)
	{
		t = RandomFloatRange( 2.0, 3.0 );
		angle = sgn * RandomFloatRange( level.rocking_mag[0], level.rocking_mag[1] );
		sgn = -1 * sgn;
		angles = ( 0, 0, angle );
		refent.targetangles = angles;
		refent.targettime = gettime() + 1000*t;
		aud_send_msg("if_the_sub_is_a_rocking_dont_come_a_knocking");
		refent rotateto( angles, t, t/3, t/3 );
		if (isdefined(refent2))
		{
			angles = (0, 0, 0.5*angle );
			refent2 rotateto( angles, t, t/3, t/3 );
		}
		wait t;
	}
}


setup_ent_rockers()
{
	level.rockers = [];
	level.rockers_opp = [];
	level.rocker_hangers = [];
	
	doors = getentarray( "sub_pressuredoor_rocker", "targetname" );
	foreach( door in doors )
	{
		org = getent( door.target, "targetname" );
		door linkto( org );
		level.rockers[level.rockers.size] = org;
	}
	
	doors = getentarray( "sub_pressuredoor_rocker_opposite", "targetname" );
	foreach( door in doors )
	{
		org = getent( door.target, "targetname" );
		door linkto( org );
		level.rockers_opp[level.rockers_opp.size] = org;
	}
	
	hangers01 = getentarray( "dyn_hanger", "targetname" );
	foreach( ent in hangers01 )
	{
		org = getent( ent.target, "targetname" );
		ent linkto( org );
		level.rocker_hangers[level.rocker_hangers.size] = org;
	}
}


rock_ents( sig, time, accel, decel )
{
	angle = 3 * ( level.rocking_mag[1] * sig );
	
	foreach( org in level.rockers ) 
	{
		org rotateto( ( org.angles[0], org.angles[1] + ( angle ) , org.angles[0] ), time, accel, decel );
	}
	
	foreach( org in level.rockers_opp ) 
	{
		org rotateto( ( org.angles[0], org.angles[1] + ( -1 * angle ) , org.angles[0] ), time, accel, decel );
	}
	
	foreach( org in level.rocker_hangers ) 
	{
		switch( org.script_noteworthy )
		{
			case "x":
				org rotateto( ( org.angles[0] + ( angle ), org.angles[1]  , org.angles[0] ), time, accel, decel );
			break;	
			case "x_neg":
				org rotateto( ( org.angles[0] + ( -1 * angle ), org.angles[1]  , org.angles[0] ), time, accel, decel );
			break;	
			case "y":
				org rotateto( ( org.angles[0] , org.angles[1] + ( angle )  , org.angles[0] ), time, accel, decel );
			break;	
			case "y_neg":
				org rotateto( ( org.angles[0] , org.angles[1] + ( -1 * angle )  , org.angles[0] ), time, accel, decel );
			break;
			case "z":
				org rotateto( ( org.angles[0] , org.angles[1], org.angles[0] + ( angle ) ), time, accel, decel );
			break;
			case "z_neg":
				org rotateto( ( org.angles[0] , org.angles[1], org.angles[0] + ( -1 * angle ) ), time, accel, decel );
			break;
			default:
			break;
		}
	}
}

rock_debris( debris, angles, t, accel, deccel )
{
	movedir = (0,1,0);
	roll = angles[2];
	offset = roll/2.5;	// we normalize the offset to the biggest amount of roll for tuning ease
	
	foreach (ent in debris)
	{
		mag = RandomFloatRange(4, 12);
		target = ent.start_origin + mag*offset*movedir;
	//	displacement = randomFloatRange( -4, 4 );
	//	target = (target[0], target[1], target[2] +  displacement);
		ent moveto( target, t, accel, deccel );
		angmag = randomFloatRange(3*level.rocking_mag[0], 3*level.rocking_mag[1]);
		ang = angmag*offset;
		dAngles = ( ent.rock_ang[0] * ang, ent.rock_ang[1] * ang, ent.rock_ang[2] * ang );
		angles = ent.start_angles + dAngles;
		ent rotateto( angles, t, accel, deccel );
	}
}

set_grav( view_angle_controller_entity )
{
	level endon( "stop_rocking" );
	thread reset_grav();
	count = 0;
	jolt_org = getstruct( "jolter", "targetname" );
	flag_wait( "hatch_player_using_ladder" );
	while( 1 )
	{ 
		toup = anglestoup( view_angle_controller_entity.angles );
		grav_dir = -1 * toup ;
		grav_ampped = grav_dir * ( 1, 10, .75 ); //changing the amplitude so we get more movement
		grav = vectorNormalize( grav_ampped );

		SetPhysicsGravityDir( grav );
		
		count++;
		if( count > 10 )
		{
			//jittering to get phy obj to move a bit
			PhysicsJitter(jolt_org.origin, 1000, 800, .01, .1 );
			count = 0;
		}
		wait( .05 );
	}
}

reset_grav()
{
	level waittill( "stop_rocking" );
	wait( .05 );
	SetPhysicsGravityDir( ( 0, 0, -1 ) );
}



visions()
{
	ent = maps\_utility::create_vision_set_fog( "so_zodiac2_ny_harbor_sub_1" );
	ent.startDist = 163.765;
	ent.halfwayDist = 624.903;
	ent.red = 0.311765;
	ent.green = 0.311765;
	ent.blue = 0.321765;
	ent.maxOpacity = 0.332562;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
	ent.sunRed = 0.75853;
	ent.sunGreen = 0.747528;
	ent.sunBlue = 0.658636;
	ent.sunDir = (-0.506012, 0.588929, 0.630171);
	ent.sunBeginFadeAngle = 0;
	ent.sunEndFadeAngle = 17.001;
	ent.normalFogScale = 3.83587;
	
	ent = maps\_utility::create_vision_set_fog( "so_zodiac2_ny_harbor_sub_2" );
	ent.startDist = 263.765;
	ent.halfwayDist = 624.903;
	ent.red = 0.311765;
	ent.green = 0.311765;
	ent.blue = 0.321765;
	ent.maxOpacity = 0.232562;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
	ent.sunRed = 0.75853;
	ent.sunGreen = 0.747528;
	ent.sunBlue = 0.658636;
	ent.sunDir = (-0.506012, 0.588929, 0.630171);
	ent.sunBeginFadeAngle = 0;
	ent.sunEndFadeAngle = 17.001;
	ent.normalFogScale = 3.83587;
	
	flag_wait("in_missile_room");
	thread vision_set_fog_changes("so_zodiac2_ny_harbor_sub_1",1);
	
	level waittill ("in_missile_room2");
	thread vision_set_fog_changes("so_zodiac2_ny_harbor_sub_2",2);
}


ping_objective_warning(obj_string, trigger, flg)
{
	if ( isdefined( self.ping_objective_splash ) )
		return;
	if (!self istouching(trigger))
		return;
	if (flag(flg))
		return;

	self endon( "death" );
	
	self.ping_objective_splash = self maps\_shg_common::create_splitscreen_safe_hud_item( 3.5, 0, obj_string );
	self.ping_objective_splash.alignx = "center";
	self.ping_objective_splash.horzAlign = "center";

	while ( self istouching (trigger) )
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

harbor_create_hud_item( yLine, xOffset, message, player, always_draw )
{
	if ( isdefined( player ) )
		assertex( isplayer( player ), "so_create_hud_item() received a value for player that did not pass the isplayer() check." );
		
	if ( !isdefined( yLine ) )
		yLine = 0;
	if ( !isdefined( xOffset ) )
		xOffset = 0;

	// This is to globally shift all the SOs down by two lines to help with overlap with the objective and help text.
	yLine += 2;

	hudelem = undefined;		
	if ( isdefined( player ) )
		hudelem = maps\_hud_util::get_countdown_hud( -60, undefined, player, true );
	else
		hudelem = maps\_hud_util::get_countdown_hud( -60, undefined, undefined, true );
		//hudelem = newHudElem();
	hudelem.alignX = "center";
	hudelem.alignY = "top";
	hudelem.horzAlign = "center";
	hudelem.vertAlign = "middle";
	hudelem.x = xOffset;
	hudelem.y = -160 + ( 15 * yLine );
	hudelem.font = "hudsmall";
	hudelem.foreground = 1;
	hudelem.hidewheninmenu = true;
	hudelem.hidewhendead = true;
	hudelem.sort = 2;
	hudelem.color = ( .9, .9, 1 );
	hudelem.fontscale = 1.15;
	//hudelem set_hud_white();

	if ( isdefined( message ) )
		hudelem.label = message;

	if ( !isdefined( always_draw ) || !always_draw )
	{
		if ( isdefined( player ) )
		{
			if ( !player so_hud_can_show() )
				player thread so_create_hud_item_delay_draw( hudelem );
		}
	}
					
	return hudelem;
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
	overlay.sort = 2;
	return overlay;

}

//---------------------------fx text and hud----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------
play_smoke_for_missiles()
{
	org = getstructarray( "missile_smoke", "targetname" );
	
	foreach (o in org)
		playFX( getfx( "smokescreen" ), o.origin );
	wait 1;
		
	while (1)
		org play_smoke();

}

play_smoke()
{
	foreach (o in self)
		playFX( getfx( "smokescreen" ), o.origin );
	
	wait 30;
	
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


so_enable_countdown_timer( time_wait, set_start_time, message, timer_draw_delay, only_me )
{
	level endon( "special_op_terminated" );
	
	if ( !isdefined( message ) )
		message = &"SPECIAL_OPS_STARTING_IN";
	
	hudelem = harbor_create_hud_item( 0, -60, message, only_me );
	hudelem SetPulseFX( 50, time_wait * 1000, 500 );

	//hudelem_timer = so_create_hud_item( 0, so_hud_ypos(), undefined, only_me );
	hudelem_timer = harbor_create_hud_item( 0, 115, undefined, only_me );
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

setup_ocean_params( params, _uscale, _vscale, _amplitude, _uvscrollrate )
{
	uscale[0] = 3;
	vscale[0] = 3;
	amplitude[0] = 30;
	uvscrollrate[0] = 4;
	uvscrollangle[0] = 0;
	
	uscale[1] = 8;
	vscale[1] = 8;
	amplitude[1] = 10;
	uvscrollrate[1] = 1.75;
	uvscrollangle[1] = 45;

	uscale[2] = 2;
	vscale[2] = 2;
	amplitude[2] = 0;
	uvscrollrate[2] = 2;
	uvscrollangle[2] = 315;
	
	maps\ocean_perlin::setup_ocean_perlin(params);
	for (i=0; i<3; i++)
	{
		params.uscale[i] = 0.0001 * _uscale * uscale[i];
		params.vscale[i] = 0.0001 * _vscale * vscale[i];
		params.amplitude[i] = _amplitude * amplitude[i];
		params.uscrollrate[i] = cos(uvscrollangle[i]) * _uvscrollrate * uvscrollrate[i];
		params.vscrollrate[i] = sin(uvscrollangle[i]) * _uvscrollrate * uvscrollrate[i];
	}
	params.uoff = -0.5;
	params.voff = -0.5;
	params.gameTimeOffset = 0.0;
	params.displacement_uvscale = 1.0;
	
	maps\ny_harbor_code_sub::ShowWater( 0 );

}

setup_ocean()
{
	// copied from ny_harbor_ocean mtl
	_uscale = 1;
	_vscale = 1;
	_amplitude = 1;
	_uvscrollrate = 0.025;
	
	level.oceantextures["water_patch"] = spawnstruct();
	setup_ocean_params( level.oceantextures["water_patch"], _uscale, _vscale, _amplitude, _uvscrollrate );
	level.oceantextures["water_patch_med"] = spawnstruct();
	setup_ocean_params( level.oceantextures["water_patch_med"], _uscale, _vscale, 0.5*_amplitude, _uvscrollrate );
	level.oceantextures["water_patch_calm"] = spawnstruct();
	setup_ocean_params( level.oceantextures["water_patch_calm"], _uscale, _vscale, 0, _uvscrollrate );
}


//---------------------------------------------------------------ANIMATIONS-----------------------------

precacheAnims()
{
	//player_anims();
	hind_anims();
	script_model_anims();
	building_destruction();
	//ss_n_12_anims();
	body_anims();
	door();

}

#using_animtree( "player" );
player_anims()
{
	//the animtree to use with the invisible model with animname "player_rig"
	//level.scr_animtree[ "player_rig" ]						= #animtree;
	//level.scr_animtree[ "player_legs" ]						= #animtree;
	//level.scr_model[ "player_sdv_legs" ]						= "viewlegs_generic";
	//the invisible model with the animname "player_rig" that the anims will be played on
	//level.scr_model[ "player_sdv_rig" ]							= "viewhands_player_udt";
}
	
#using_animtree( "vehicles" );
ss_n_12_anims()
{
	//level.scr_animtree["ss_n_12_missile"] = #animtree;
	//level.scr_anim[ "ss_n_12_missile" ][ "open" ]		 = %ss_n_12_missile_open;
	//level.scr_anim[ "ss_n_12_missile" ][ "open_idle" ]	 = %ss_n_12_missile_open_idle;
	//level.scr_anim[ "ss_n_12_missile" ][ "close_idle" ] = %ss_n_12_missile_close_idle;
}

hind_anims()
{
	level.scr_animtree["ny_harbor_hind"] = #animtree;
	level.scr_anim[ "ny_harbor_hind" ][ "open_door" ]		 = %ny_harbor_hind_open_door;
	level.scr_anim[ "ny_harbor_hind" ][ "open_door_idle" ]	 = %ny_harbor_hind_open_door_idle;
}

#using_animtree( "script_model" );
script_model_anims()
{
	//breach actors and props
	level.scr_animtree[ "door_charge" ] = #animtree;
	level.scr_model[ "door_charge" ] = "weapon_frame_charge_iw5";
	level.scr_anim[ "door_charge" ][ "ny_harbor_door_breach" ]							= %ny_harbor_door_breach_player_charge2;
	level.scr_animtree[ "breach_door" ] = #animtree;
	level.scr_model[ "breach_door" ] = "ny_harbor_sub_pressuredoor_bridge";
	level.scr_anim[ "breach_door" ][ "ny_harbor_door_breach" ]							= %ny_harbor_door_breach_pressure_door;
	level.scr_animtree["smoke_column"] = #animtree;
	level.scr_anim[ "smoke_column" ][ "fire" ]				= %fx_ny_smoke_column_anim;
	level.scr_anim[ "smoke_column" ][ "rot" ]				= %fx_ny_smoke_column_rot_anim;
	level.scr_animtree["missile_door"] = #animtree;
	level.scr_anim[ "missile_door" ][ "open" ]				= %ny_harbor_sub_missile_door_open;
	level.scr_animtree["missile_hatch"] = #animtree;
	level.scr_anim[ "missile_hatch" ][ "open" ]				= %ny_harbor_sub_missile_hatch_open;
		level.scr_animtree["wave_front"] = #animtree;
	level.scr_anim[ "wave_front" ][ "wave" ]				= %fx_nyharbor_wave_front_anim;

	level.scr_animtree["wave_crashing"] = #animtree;
	level.scr_anim[ "wave_crashing" ][ "wave" ]				= %fx_nyharbor_wave_crashing_anim;
	
	level.scr_animtree["wave_side"] = #animtree;
	level.scr_anim[ "wave_side" ][ "wave" ]				= %fx_nyharbor_wave_side_anim;
	level.scr_animtree["explosion_wave"] = #animtree;
	level.scr_anim[ "explosion_wave" ][ "wave" ]				= %fx_nyharbor_explosion_wave_anim;
	level.scr_animtree["wave_displace"] = #animtree;
	level.scr_anim[ "wave_displace" ][ "wave" ]				= %fx_nyharbor_wave_displace_anim;

}

building_destruction()
{
	level.scr_animtree["building_des"] = #animtree;
	level.scr_anim[ "building_des" ][ "ny_manhattan_building_exchange_01_facade_des_anim" ]		 = %ny_manhattan_building_exchange_01_facade_des_anim;
}

door()
{
	level.scr_animtree["door"] = #animtree;
	level.scr_model[ "door" ] = "ny_harbor_sub_pressuredoor_rigged";
	level.scr_anim [ "door" ][ "open_with_wheel" ]						= %ny_harbor_delta_bulkhead_open_door_v2;
	//level.scr_anim [ "door" ][ "slam_door" ]		 					  	= %ny_harbor_slams_bulkhead_door_shut_door;
	//level.scr_anim [ "door" ][ "barracks_sandman_exit" ]		 	= %ny_harbor_door_open_door;
}



#using_animtree( "generic_human" );
body_anims()
{
	level.scr_animtree["floating_body"] = #animtree;
	//level.scr_anim[ "generic" ][ "ny_harbor_ssbn_coughing_recovery_guy1" ] 			= 			%ny_harbor_ssbn_coughing_recovery_guy1;
	//level.scr_anim[ "generic" ][ "ny_harbor_ssbn_coughing_recovery_guy2" ] 			= 			%ny_harbor_ssbn_coughing_recovery_guy2;
	//level.scr_anim[ "generic" ][ "ny_harbor_captain_search_flip_over" ] 			= 			%ny_harbor_paried_takedown_captain_flip_over;

		//control room control panel
	//level.scr_anim[ "generic" ][ "ny_harbor_paried_takedown_captain_start" ] 		= 			%ny_harbor_paried_takedown_captain_start;
	level.scr_anim[ "generic" ][ "ny_harbor_paried_takedown_captain_dead_1"  ] 		= 			%Ny_Harbor_Paried_Takedown_Captain_Dead_1;
	level.scr_anim[ "generic" ][ "ny_harbor_paried_takedown_captain_die"  ]		 	= 			%ny_harbor_paried_takedown_captain_die;
	//level.scr_anim[ "generic" ][ "ny_harbor_captain_search_flip_over" ] 			= 			%ny_harbor_paried_takedown_captain_flip_over;

	level.scr_anim[ "generic" ][ "ny_harbor_delta_bulkhead_open_guy1_v2" ]				= %ny_harbor_delta_bulkhead_open_guy1_v2;



}

	preFX()
	{
	//so
	level._effect[ "smokescreen" ]     		= LoadFX( "smoke/smoke_grenade_low" );
	//level._effect[ "Dlight" ]  						= loadfx( "misc/NV_dlight" );
	level._effect[ "red_dot" ]  					= loadfx( "misc/aircraft_light_cockpit_red" );
	level._effect[ "light_c4_blink" ] 		= loadfx( "misc/light_c4_blink" );
	level._effect[ "white_light" ] 				= loadfx( "misc/aircraft_light_white_blink" );
	level._effect[ "red_light" ] 			    = loadfx( "lights/hijack_fxlight_red_blink" );
	//level._effect[ "m60_flash_view" ] 		= loadfx( "muzzleflashes/m60_flash_view" );
	
	level._effect[ "steam_jet1" ] 		= loadfx( "smoke/steam_jet_loop_cheap" );
	level._effect[ "steam_jet2" ] 		= loadfx( "smoke/steam_jet_med_loop_harbor" );
	level._effect[ "fire_gen" ] 	   	= loadfx( "fire/cpu_fire" );
	level._effect[ "fire_steam" ] 		= loadfx( "impacts/pipe_fire_looping" );
}

PreVO()
{
	level.scr_radio[ "so_zodiac2_hqr_oncamera" ]	    	= "so_zodiac2_hqr_oncamera";				     //We have you on camera Trident - 1 you're on your own. proceed with the mission
	level.scr_radio[ "so_zodiac2_hqr_riggedsub" ]		    = "so_zodiac2_hqr_riggedsub";				     //The russians have rigged the sub to go nuclear. find and render safe the charges
	level.scr_radio[ "so_zodiac2_hqr_nearingreactor" ]	= "so_zodiac2_hqr_nearingreactor";	  	 //You're nearing the reactor, watch your back
	level.scr_radio[ "so_zodiac2_hqr_raditionlevels" ]	= "so_zodiac2_hqr_raditionlevels";			 //Your radiation dose levels are high, time is critical
	level.scr_radio[ "so_zodiac2_hqr_rendezvous" ]	  	= "so_zodiac2_hqr_rendezvous";			  	 //Good work Trident-1, rendezvous with your teammates and get outa there
	level.scr_radio[ "so_zodiac2_hqr_areaishot" ]	    	= "so_zodiac2_hqr_areaishot";			    	 //your area is hot Trident-1, move
	level.scr_radio[ "so_zodiac2_hqr_readywhen" ]	    	= "so_zodiac2_hqr_readywhen";			    	 //We have you on camera Trident - 1 you're on your own. proceed with the mission
	level.scr_radio[ "so_zodiac2_hqr_onisr" ]	         	= "so_zodiac2_hqr_onisr";				         //We have you on camera Trident - 1 you're on your own. proceed with the mission
	//level.scr_radio[ "so_zodiac2_hqr_oncamera" ]		= "so_zodiac2_hqr_oncamera";				 //We have you on camera Trident - 1 you're on your own. proceed with the mission
	//level.scr_radio[ "so_zodiac2_hqr_oncamera" ]		= "so_zodiac2_hqr_oncamera";				 //We have you on camera Trident - 1 you're on your own. proceed with the mission
	//level.scr_radio[ "so_zodiac2_hqr_oncamera" ]		= "so_zodiac2_hqr_oncamera";				 //We have you on camera Trident - 1 you're on your own. proceed with the mission
	//level.scr_radio[ "so_zodiac2_hqr_oncamera" ]		= "so_zodiac2_hqr_oncamera";				 //We have you on camera Trident - 1 you're on your own. proceed with the mission
	//level.scr_radio[ "so_zodiac2_hqr_oncamera" ]		= "so_zodiac2_hqr_oncamera";				 //We have you on camera Trident - 1 you're on your own. proceed with the missions
}

CONST_LEVEL_TIME = 300; //seconds (5 minutes)

handle_end_of_game_bonuses()
{
	foreach (p in level.players)	
	{
		p.bonus_1 = 0;
		p.bonus_2 = 1;
	}
	
	thread level_complete_under_time();
}

monitor_damage_type()
{
	smoke_kills_vol = GetEnt( "smoke_kills_vol", "targetname" );
	self waittill ( "death", attacker, type, weaponName  );
	
	if ( isplayer( attacker ) && smoke_kills_vol istouching(self))
	{
		attacker.bonus_1++;
		attacker notify ("bonus1_count", attacker.bonus_1);
}
}

is_bonus_weapon( type, weapon_name )
{
	if(!isdefined(type))
		return false;
		
	if(!isdefined(weapon_name))
		return false;
		
		
	if (type == "MOD_MELEE")
		return true;
	else
		return false;
}

level_complete_under_time()
{
	array_thread (level.players, ::fail_if_missionfail);
	array_thread (level.players, ::fail_if_friendlyfail);
	
	wait CONST_LEVEL_TIME;
	
	foreach (p in level.players)	
		p.bonus_2 = 0;
}

fail_if_missionfail()
{
self waittill( "death" );

	foreach (p in level.players)	
	{
		p.bonus_2 = 0;
	}
}

fail_if_friendlyfail()
{
level waittill( "friendlyfire_mission_fail" );

	foreach (p in level.players)	
	{
		p.bonus_2 = 0;
	}
}



//===========================================
//                   heli_fail_safe_on_death
//===========================================
heli_fail_safe_on_death()
{
    level endon( "so_zodiac2_ny_harbor_complete" );    
    
    flag_set("special_op_no_unlink");
    
    level waittill( "missionfailed" );
    
    
    if( !IsDefined( level.player_hind ) )
    {
        return;
    }
    
    level.player_hind Vehicle_SetSpeedImmediate( 0, 60, 60 );
    
    foreach (p in level.players)
    	p takeallweapons();
}