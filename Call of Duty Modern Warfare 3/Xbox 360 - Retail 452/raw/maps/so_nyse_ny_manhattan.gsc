#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\_audio_music;
#include maps\_audio;
#include maps\ss_util;
#include maps\_shg_common;
#include maps\_audio_zone_manager;

main()
{	
	maps\so_nyse_ny_manhattan_precache::main();
	maps\ny_manhattan_precache::main();
	maps\so_nyse_ny_manhattan_fx::main();
	maps\createart\ny_manhattan_art::main();
	maps\so_nyse_ny_manhattan_anim::main();
	so_delete_all_vehicles(); //so the vehicles dont exist and cause precache problems
	PrecacheMinimapSentryCodeAssets();
	maps\_shg_common::so_vfx_entity_fixup( "msg_fx_zone" );
	maps\_shg_common::so_mark_class( "trigger_multiple_audio" );
	maps\_shg_common::so_mark_class( "trigger_multiple_visionset" );
	maps\_load::main();
	maps\ny_manhattan_aud::main();
	maps\so_aud::main("so_nyse_ny_manhattan");
	maps\_compass::setupMiniMap( "compass_map_so_manhattan" );
	maps\_xm25::init();	
	//precache
	PreCacheItem ( "fraggrenade" );
	PreCacheItem ( "rpg_straight" );

	PreCacheString ( &"SO_NYSE_NY_MANHATTAN_HINT_PICKUP_LAPTOP" );
	PreCacheString ( &"SO_NYSE_NY_MANHATTAN_HINT_UPLOAD" );
	PrecacheString ( &"SO_NYSE_NY_MANHATTAN_PICKUP_FAIL" );
	PrecacheString ( &"SO_NYSE_NY_MANHATTAN_HINT_WAITING" );
	PreCacheString ( &"SO_NYSE_NY_MANHATTAN_XM25_KILLS" );
	
	//init flags
	flag_init ( "give_predator" );
	flag_init ( "rooftop_hind_deadly" );
	flag_init ( "data_collected" );
	flag_init ( "upload_first_time" );
	flag_init ( "upload_interrupted_first_time" );
	flag_init ( "upload_running" );
	flag_init ( "allow_chem_grenade" );
	flag_init ( "upload_complete" );
	flag_init ( "flag_conversation_in_progress" );
	flag_init ( "upload_25_percent" );
	flag_init ( "upload_50_percent" );
	flag_init ( "upload_75_percent" );
	flag_init ( "flag_conversation_in_progress" );
	flag_init ( "so_nyse_ny_manhattan_start" );
	flag_init ( "rooftop_wave1_done" );
	
	//init flags from sp so vfx script works
	flag_init ( "entering_hind" );
	flag_init ( "obj_capturehind_given" );
	flag_init ( "thermite_detonated" );
	flag_init ( "level_started_fx" );
	
	add_hint_string ( "hint_waiting", &"SO_NYSE_NY_MANHATTAN_HINT_WAITING", ::playersatjammer );
	add_hint_string( "hint_heli_dmg", &"SO_NYSE_NY_MANHATTAN_HINT_HELI_DMG", ::should_break_heli_dmg_hint );
	maps\ny_manhattan_fx::main();
	
	thread setup();
	thread gameplay_logic();
	thread setup_vo();

}



should_break_heli_dmg_hint()
{
	if ( isdefined ( level.high_priority_hint ) && level.high_priority_hint )
		return true;
	return false;
	
}

drawLinesForever()
{
	while(1)
	{
		wait_time = .25;
		if(isdefined(level.uavrig))
		{
			forward = AnglesToForward( level.player GetPlayerAngles() );
			DLine( level.uavrig.origin, level.uavrig.origin + (forward * 2048), wait_time );
		}
		wait(wait_time);	
	}	
}

DLine( start, end, seconds, color_override )
{
	if(!isdefined(start) || !isdefined(end))
		return; 
		
	if(!isdefined(color_override))
		color_override = (1,0,1);
	if(!isdefined(seconds))
		seconds = 3;
	frames_to_show = 60 * seconds;
	count = 0;
	while(count < frames_to_show)
	{
		line( start, end, color_override );
		wait( 0.05 );
		count++;
	}
}


setup()
{
	thread vision_set_fog_changes("ny_manhattan",0);
	
	so_delete_all_triggers();
	so_delete_all_spawners();
	
	thread enable_escape_warning();
	thread enable_escape_failure();
	
	//jamming tower setup
	
	jammer = getent ( "jamming_tower", "targetname" );
	jammer.animname = "tower";
	jammer SetAnimTree();
	
	jammer_destroyed = getent ( "jamming_tower_destroyed", "targetname" );
	jammer_destroyed hide();
	jammer_destroyed notsolid();
		
	jammer_destroyed_collision = getent ( "tower_destroyed_collision", "targetname" );
	jammer_destroyed_static = getent ( "jammer_destroyed_static", "targetname" );
		
	jammer_destroyed_collision notsolid();
	if( isdefined( jammer_destroyed_static ))
	jammer_destroyed_static hide();
	jammer_destroyed_static notsolid();
	
	org = getent ( "org_tower_collapse", "targetname" );
	org anim_first_frame_solo ( jammer, "idle" );
	
	thermite = getent ( "thermite_jammer", "targetname" );
	thermite hide();
	
	//setup nyse barrier
	barrier_col = getentarray ( "nyse_barrier_col", "targetname" );
	barrier_objects = getentarray ( "nyse_barrier", "targetname" );
	
	array_call ( barrier_col, ::connectpaths );
	array_call ( barrier_col, ::notsolid );
	array_call ( barrier_objects, ::hide );
	array_call ( barrier_objects, ::notsolid );
	
	//little hack to knock the dyn objects around that were sitting on top of some of the containers so they are not floating.
	barrier_impulse_points = getentarray ( "nyse_barrier_impulse", "targetname" );
	foreach ( impulse in barrier_impulse_points )
		magicgrenade ( "fraggrenade", impulse.origin, impulse.origin + ( 0, 0, -1 ), 0.5 );
	
	level.rooftop_playerclip = getent ( "rooftop_playerclip", "targetname" );
	if( isdefined( level.rooftop_playerclip ))
	level.rooftop_playerclip notsolid();	
	
	foreach ( player in level.players )
		player switchtoweaponimmediate ( "alt_m4_hybrid_grunt_optim" );
	
	//dog stuff
	animscripts\dog\dog_init::initDogAnimations();
	maps\_load::set_player_viewhand_model( "viewhands_player_delta" );
	
	AZM_start_zone("nymn_back_alley");

}

gameplay_logic()
{
	//init variables	
	level.VISION_UAV = "ny_manhattan_predator";
	level.uav_missile_tag_for_camera = "tag_camera";
	//level.uav_missile_override = "remote_missile_ny";
	
	if ( level.players.size == 1 )
	{
		level.total_laptops = 3;
		level.laptops_left = 3;
	}
	else
	{
		level.total_laptops = 5;
		level.laptops_left = 5;
	}

	level.codes_uploaded = 0;
	
	level.upload_trigger = getent ( "start_upload", "targetname" );
	level.upload_trigger sethintstring ( &"SO_NYSE_NY_MANHATTAN_HINT_UPLOAD" ); 
	
	level.vol_trading_floor = getent ( "volume_trading_guys03", "targetname" );
	level.vol_rooftop = getent ( "volume_mi17_rooftop", "targetname" );
	
	level.high_priority_hint = false;
	
	flag_set ( "allow_chem_grenade" );		
	
	foreach ( player in level.players )
		player.num_laptops_in_inventory = 0;
	
	//spawn functions
	add_global_spawn_function( "axis", ::grenade_monitor );
	add_global_spawn_function( "axis", ::monitor_xm25_kill );
	array_spawn_function_noteworthy ( "nyse_from_street", ::nyse_from_street_think );
	
	thread enable_challenge_timer( "so_nyse_ny_manhattan_start", "so_nyse_ny_manhattan_complete" );
	thread fade_challenge_in(0, false);
	thread fade_challenge_out( "so_nyse_ny_manhattan_complete", true );
	
	thread objectives();
	thread encryption_codes();
	thread upload();
	thread upload_success();
	thread wall_combat();
	thread rooftop_combat();
	//thread gaz_switch_mode();
	//thread setup_uav();
	thread laptop_setup();
	thread music();
	//thread setup_ieds();
	//thread wall_smoke();
		//custom EOG summary
	level.so_mission_worst_time = 720000;
	level.so_mission_min_time = 225000;
	maps\_shg_common::so_eog_summary( "@SO_NYSE_NY_MANHATTAN_EOG_XM25_KILLS", 5, 50 );
	array_thread ( level.players, ::enable_challenge_counter, 3, &"SO_NYSE_NY_MANHATTAN_XM25_KILLS", "bonus1_count" );
	
}

objectives()
{
	thread obj_nyse();
	thread obj_upload();
}

obj_nyse()
{
	marker_lobby = getent ( "marker_lobby", "targetname" );
	marker_upstairs = getent ( "marker_upstairs", "targetname" );
	escape_triggers = getentarray ( "roof_escape", "targetname" );
	
	wait 5;	// wait to be sure the server is running before
	objective_add( obj( "obj_pick_up_laptops" ), "active", &"SO_NYSE_NY_MANHATTAN_OBJ_LAPTOPS", marker_lobby.origin );
	objective_string_nomessage( obj( "obj_pick_up_laptops" ), &"SO_NYSE_NY_MANHATTAN_OBJ_LAPTOPS_REMAINING", level.laptops_left );
	objective_current( obj( "obj_pick_up_laptops" ) );
	
	flag_wait ( "at_nyse" );
	
	objective_position( obj( "obj_pick_up_laptops" ), marker_upstairs.origin );
	
	flag_wait ( "nyse_upstairs" );
	
	objective_position( obj( "obj_pick_up_laptops" ), (0, 0, 0) );
	
	for ( i = 0; i < level.laptops_left; i++ )
	{
		objective_additionalposition ( obj("obj_pick_up_laptops" ), i, level.triggers[i].origin );
	}

	while ( true )
	{
		
		level waittill ( "laptop_pickedup" );
		
		thread so_dialog_counter_update( level.laptops_left, level.total_laptops );
		
		wait 0.1;
		
		if ( level.laptops_left > 0 )
		{
			objective_delete ( obj("obj_pick_up_laptops" ) );
			objective_add( obj( "obj_pick_up_laptops" ), "active", &"SO_NYSE_NY_MANHATTAN_OBJ_LAPTOPS" );
			objective_string_nomessage( obj( "obj_pick_up_laptops" ), &"SO_NYSE_NY_MANHATTAN_OBJ_LAPTOPS_REMAINING", level.laptops_left );
			objective_current( obj( "obj_pick_up_laptops" ) );
			
			for ( i = 0; i < level.laptops_left; i++ )
			{
				objective_additionalposition ( obj("obj_pick_up_laptops" ), i, level.triggers[i].origin );
			}
		
			wait 0.05;
		}
		
		else 
		{
			objective_string_nomessage( obj( "obj_pick_up_laptops" ), &"SO_NYSE_NY_MANHATTAN_OBJ_LAPTOPS" );
			objective_complete ( obj("obj_pick_up_laptops" ) );
			flag_set ( "data_collected" );
			foreach ( trigger in escape_triggers )
				trigger trigger_off();			
			
		}
	}
	
}

obj_upload()
{
	marker_stair = getent ( "marker_nyse_stairs", "targetname" );
	marker_ladder = getent ( "marker_ladder", "targetname" );
	marker_roof = getent ( "marker_roof", "targetname" );
	marker_jammer = getent ( "thermite_jammer", "targetname" );
	
	level endon ( "so_nyse_ny_manhattan_complete" );
	
	flag_wait ( "data_collected" );
	
	objective_add( obj( "obj_upload" ), "active", &"SO_NYSE_NY_MANHATTAN_OBJ_UPLOAD", marker_stair.origin );
	objective_current( obj( "obj_upload" ) );
	
	flag_wait ( "so_stairs_reached" );
	
	objective_position( obj( "obj_upload" ), marker_ladder.origin );
	
	flag_wait ( "so_ladder_reached" );
	
	objective_position( obj( "obj_upload" ), marker_roof.origin );
	
	flag_wait ( "so_roof_reached" );
	
	objective_position( obj( "obj_upload" ), marker_jammer.origin );
	
	flag_wait ( "upload_running" );
	
	while ( true )
	{
		objective_delete( obj( "obj_upload" ) );
		objective_add( obj( "obj_upload" ), "active", &"SO_NYSE_NY_MANHATTAN_OBJ_UPLOAD_DEFEND" );
		objective_current( obj( "obj_upload" ) );
		
		flag_waitopen ( "upload_running" );
		
		objective_add( obj( "obj_upload" ), "active", &"SO_NYSE_NY_MANHATTAN_OBJ_UPLOAD_RESTART", marker_jammer.origin );
		objective_current( obj( "obj_upload" ) );
		
		flag_wait ( "upload_running" );
		
		wait 0.05;
	}
	
}

wait_for_turret_owner_change( vehicle )
{
	guy = self GetTurretOwner();
	
	if( isdefined( guy ))
		guy endon("death");
		
	self endon("death");
	self waittill( "turretownerchange");
	
	if( isdefined( guy ))
		guy notify( "dismount" );
		
	vehicle thread vehicle_unload( "gunner" );
}

wall_combat()
{
	level.wall_gaz = getentarray ( "wall_gaz", "targetname" );
	array_thread ( level.wall_gaz, ::gaz_switch_mode );
	
	gaz_guys = getentarray ( "wall_gaz_guy", "targetname" );
	
	array_thread ( level.wall_gaz, ::gaz_turret_disable );
	
	foreach ( guy in gaz_guys )
	{
		guy.ignoreall = true;
	}
	
	flag_wait ( "start_combat" );

	enemies_wall_01 = getentarray ( "enemies_wall_01", "script_noteworthy" );
	thread maps\_spawner::flood_spawner_scripted ( enemies_wall_01 );
	
	flag_wait ( "spawn_wall_mi17" );

	mi17 = spawn_vehicle_from_targetname_and_drive ( "mi17" );
	mi17.godmode = true;
	mi17 thread helo_dmg_hint_bullet();
	mi17 thread helo_dmg_hint_other();

	flag_wait ( "gaz_ignore_off" );
	
	foreach ( guy in gaz_guys )
	{
		guy.ignoreall = false;
	}
	
	foreach ( gaz in level.wall_gaz )
	{
		if ( isdefined ( gaz ) && isdefined ( gaz.mgturret ) && isdefined ( gaz.mgturret[0] ) )
			gaz.mgturret[0] TurretFireEnable();
		
	}
	
	thread chem_mortar ( 2, "chem_mortar_locs_01" );
	
	wait randomintrange ( 5, 15 );
	thread spawn_so_warlord_dog( "dogs", "dog_fallback" );
	
	outside_guy_spawners = getentarray ( "nyse_from_street", "targetname" );
	
	flag_wait ( "spawn_outside_guys" );
	
	flag_waitopen ( "outside_guys_hold" );
	
	thread maps\_spawner::flood_spawner_scripted ( outside_guy_spawners );
	
}

gaz_switch_mode()
{	
	self endon ( "death" );
	level endon ( "special_op_terminated" );
	
	flag_wait ( "gaz_switch_turret_mode" );
	
	if ( maps\ny_manhattan_code_hind::isvehiclealive ( self ) )
	{
		turret = self.mgturret[0];
		turret SetMode( "auto_ai" );
		turret SetTurretCanAIDetach( true );
		turret thread wait_for_turret_owner_change( self );
		self vehicle_turret_scan_on();
	}
	
	
}

gaz_turret_disable()
{
	level endon ( "gaz_ignore_off" );
	level endon ( "special_op_terminated" );
	self endon ( "death" );
	
	while ( true )
	{
		if ( isdefined ( self ) && isdefined ( self.mgturret ) && isdefined ( self.mgturret[0] ) )
			self.mgturret[0] TurretFireDisable();
		
		wait 0.05;
		
	}

}

rooftop_combat()
{
	flag_wait ( "mi17_rooftop_dropoff_01" );
	
	mi17_rooftop_01 = spawn_vehicle_from_targetname_and_drive ( "mi17_rooftop_dropoff_01" );
	mi17_rooftop_01.godmode = true;
	mi17_rooftop_01 thread helo_dmg_hint_bullet();
	mi17_rooftop_01 thread helo_dmg_hint_other();
	mi17_riders = mi17_rooftop_01.riders;
	
	flag_wait ( "at_rooftop" );
	
	nyse_from_street_guys = getentarray ( "nyse_from_street", "script_noteworthy" );
	array_setgoalvolume ( nyse_from_street_guys, "volume_mi17_rooftop" );
	
	trading_guys = getentarray ( "trading_guys", "script_noteworthy" );
	array_setgoalvolume ( trading_guys, "volume_mi17_rooftop" );
	
	rooftop_wave1_spawners = getentarray ( "enemy_rooftops_wave1", "targetname" );
	rooftop_wave1_guys = array_spawn ( rooftop_wave1_spawners, true );
	rooftop_wave1_guys = array_combine ( rooftop_wave1_guys, mi17_riders );
	
	thread rooftop_wave1_monitor( rooftop_wave1_guys );
	thread rooftop_littlebird();
	thread rooftop_mi17();
		
}

rooftop_littlebird()
{
	flag_wait ( "upload_running" );
	array_thread ( level.players, ::rooftop_mortar_campers );
	wait randomintrange ( 10, 30 );
	
	littlebird = spawn_vehicle_from_targetname_and_drive ( "littlebird01" );
	littlebird thread littlebird_think();
	
	aud_send_msg("so_nyse_littlebird_spawn", littlebird);
	
	foreach ( mg in littlebird.mgturret )
		mg setconvergencetime ( 2 );
	
	flag_wait_or_timeout ( "littlebird_dead", 30 );
	
	thread chem_mortar ( 1, "chem_mortar_locs_rooftop_jammer" );
	thread chem_mortar ( 2, "chem_mortar_locs_rooftop" );
	
	wait randomintrange ( 60, 90 );
	
	thread chem_mortar ( 3, "chem_mortar_locs_rooftop" );

}

littlebird_think()
{
	self endon( "death" );
	level endon( "so_nyse_ny_manhattan_complete" );
	level endon ( "missionfailed" );
	level endon ( "players_down" );
	
	self sethoverparams( 200, 5, 5 );
	
	last_path = undefined;
	path_good = false;
	
	//get loop nodes
	hover_nodes = getstructarray( "littlebird_hover_node", "script_noteworthy" );
	current_path = random ( hover_nodes);
	
	flag_wait ( "lb_start_lookat" );
	player = get_closest_player_healthy( self.origin );
	self SetLookAtEnt( player );
	
	//wait until we arrive at the loop start
	flag_wait( "littlebird_arrive" );
	
	//patrol chopper around the area
	while( true )
	{
		//look at closest player
		player = get_closest_player_healthy( self.origin );
		self SetLookAtEnt( player );
		
		//make sure we don't choose the current path
		while ( !path_good )
		{
			current_path = random ( hover_nodes );
			
			if ( isdefined ( last_path ) && last_path == current_path )
				continue;
			else
			{
				last_path = current_path;
				path_good = true;
			}
			
			wait 0.05;
		}

	
		path_good = false;
		
		//figure out how fast to move based on distance to travel
		dist = distance ( self.origin, current_path.origin );
		dist_in_miles = inches_to_miles( dist );
		time = seconds_to_hours( 5 );
		velocity = dist_in_miles / time;
		self vehicle_setspeed( velocity, velocity / 2 );
		
		//move to new path node
		self thread vehicle_paths( current_path );
		
		//wait until we arrive
		self waittill ( "reached_dynamic_path_end" );
		
		//wait a little more so player can shoot a stationary target
		wait randomfloatrange( 2, 4 );
	}
}

inches_to_miles( inches )
{
	return inches * 0.000015782;
}

seconds_to_hours( seconds )
{
	return seconds * 0.000277777778;
}

rooftop_wave1_monitor( rooftop_guys )
{
	level endon ( "rooftop_wave1_done" );
	
	while ( true )
	{
		rooftop_guys =  array_removeUndefined ( rooftop_guys );
		if ( rooftop_guys.size < 3 )
			flag_set ( "rooftop_wave1_done" );
		wait 0.05;
	}
	
}

rooftop_mortar_campers()
{
	self endon ( "death" );
	level endon ( "so_nyse_ny_manhattan_complete" );
	
	org = spawn ( "script_origin", self.origin );
	
	while ( true )
	{
		org.origin = self.origin;
		wait 20;
		if ( distance ( self.origin, org.origin ) <= 128 )
			self thread chem_mortar( 1 );
				
	}
}
		
		
laptop_setup()
{	
	level.triggers = getentarray ( "trigger_laptop", "targetname" );
	
	for ( i = 0; i < level.laptops_left; i++ )
	{
		locs = getentarray ( "laptop_loc_" + i, "targetname" );
		locs = array_randomize ( locs );
		laptop = getent ( level.triggers [ i ].target, "targetname" );
		level.triggers [ i ] enablelinkto();
		level.triggers [ i ] sethintstring ( &"SO_NYSE_NY_MANHATTAN_HINT_PICKUP_LAPTOP" ); 
		level.triggers [ i ] thread laptop_monitor( laptop );
		laptop.origin = locs [ 0 ].origin;
		laptop.angles = locs [ 0 ].angles;
		level.triggers [ i ].origin = laptop.origin + ( 0, 0, 8 );
	}
	
}

laptop_monitor( laptop )
{
	self waittill ( "trigger", player );
	
	if ( player.num_laptops_in_inventory >= 3 )
	{
		self thread too_many_laptops( player );
		self thread laptop_monitor( laptop );
	}
	else
	{
		player.num_laptops_in_inventory ++;
		laptop Playsound ( "arcademode_2x", "sound_played" );
		
		laptop delete();
		self trigger_off();
		
		level.laptops_left --;
		
		level.triggers = array_remove ( level.triggers, self );
		
		level notify ( "laptop_pickedup" );
		//thread so_dialog_counter_update( level.laptops_left, 3 );
		
		if ( level.laptops_left > 0 )
		{
			//iprintlnbold ( "Data Collected; " + ( level.laptops_left ) + " to go" );
		}
		
		else 
			//iprintlnbold ( "All codes collected: Upload the codes from the roof" );
		
		if ( level.laptops_left == 0 )
			level notify ( "all_laptops_pickedup" );
	}
}
	
too_many_laptops( player )
{
	self Playsound ( "arcademode_2x", "sound_played", true );
	
	text = newClientHudElem( player );
	
	text.alignX = "center";
	text.alignY = "middle";
	text.horzAlign = "center";
	text.vertAlign = "middle";
	text.font = "hudsmall";
	text.foreground = 1;
	text.hidewheninmenu = true;
	text.hidewhendead = true;
	text.sort = 2;
	text.label = &"SO_NYSE_NY_MANHATTAN_PICKUP_FAIL";
	
	text set_hud_red();
	text thread hud_blink();
	
	wait 2;
	text notify ( "stop_blink" );
	wait 0.05;
	text destroy();	
	
}
	
encryption_codes()
{
	flag_wait ( "nyse_upstairs" );
	
	level.codes_title = so_create_hud_item( -1, so_hud_ypos(), &"SO_NYSE_NY_MANHATTAN_DATA_TITLE" );
	level.codes_count = so_create_hud_item( -1, so_hud_ypos(), undefined );
	level.codes_count.alignx = "left";
	level.codes_count SetValue( level.laptops_left );
	level.vehicles_max = level.laptops_left;
	
	while( true )
	{
		level waittill( "laptop_pickedup" );
		if ( level.laptops_left <= 0 )
			break;
		
		level.codes_title thread so_hud_pulse_success();
		level.codes_count thread so_hud_pulse_success();
		
		level.codes_count SetValue( level.laptops_left );
		
	}

	if( isdefined( level.codes_count ))
	level.codes_count so_remove_hud_item( true );
		
	level.codes_count = so_create_hud_item( -8, so_hud_ypos(), &"SPECIAL_OPS_DASHDASH" );
	level.codes_count.alignx = "left";

	level.codes_title thread so_hud_pulse_success();
	level.codes_count thread so_hud_pulse_success();

	if( isdefined( level.codes_title ))
	level.codes_title thread so_remove_hud_item();
	if( isdefined( level.codes_count ))
	level.codes_count thread so_remove_hud_item();
}

rooftop_mi17()
{
	flag_wait_or_timeout ( "rooftop_wave1_done", 90 );
		
	mi17_rooftop_02 = spawn_vehicle_from_targetname_and_drive ( "mi17_rooftop" );
	mi17_rooftop_02.godmode = true;
	mi17_rooftop_02 thread helo_dmg_hint_bullet();
	mi17_rooftop_02 thread helo_dmg_hint_other();
	
	wait 0.05;
	
	mi17_rooftop_02 waittill ( "unloaded" );
	
	wait 5;
	
	thread mi17_goal();
	
	flag_wait_or_timeout ( "mi17_guys_dead", 60 );
	
	rooftop_wave2_spawners = getentarray ( "enemy_rooftops_02", "script_noteworthy" );
	rooftop_wave2_guys = maps\_spawner::flood_spawner_scripted ( rooftop_wave2_spawners );
	
}

mi17_goal()
{
	guys = getentarray ( "mi17_guys", "script_noteworthy" );
	
	goalvolume = getent ( "volume_mi17_rooftop", "targetname" );
	wait 5;
	wait 0.05;
	
	foreach ( guy in guys )
	{
		if ( isdefined ( guy ) && isai ( guy ) && isalive ( guy ) )
		{
			guy cleargoalvolume();
			guy setgoalvolumeauto ( goalvolume );
		}
	}
}
	
upload()
{
	
	while ( true )
	{
		level.upload_trigger waittill ( "trigger", player );
		
		if ( !flag ( "upload_first_time" ) )
		{
			if ( playersatjammer() )
			{
				level.rooftop_playerclip solid();
				thread upload_interrupt_monitor();	
				break;
			}
			else
			{
				level.upload_trigger trigger_off();
				player thread display_hint_timeout ( "hint_waiting", 3 );
				level.high_priority_hint = true;
				wait 3;
				level.high_priority_hint = false;
				level.upload_trigger trigger_on();
			}
			
			wait 0.05;
		}
		
		else
			break;
			
	}
		
		level.upload_trigger Playsound ( "arcademode_2x" );
		
		if ( isdefined ( level.upload_interrupted_title ) )
		{
			level.upload_interrupted_title notify ( "stop_blink" );
			level.upload_interrupted_title.alpha = 0;
		}
		
		level.upload_trigger trigger_off();
		flag_set ( "upload_running" );
		
		thread upload_hud();
	
}

upload_success()
{
	level endon ( "missionfailed" );
	level endon ( "special_op_terminated" );
	
	flag_wait ( "upload_complete" );
	thread radio_dialogue_queue_single ( "so_manhat_hqr_greatwork" );
	Objective_String_NoMessage ( obj( "obj_upload" ), &"SO_NYSE_NY_MANHATTAN_OBJ_UPLOAD" );
	objective_complete ( obj("obj_upload" ) );
	
	wait 6;
	
	flag_set ( "so_nyse_ny_manhattan_complete" );
}

upload_hud()
{
	level endon ( "upload_interrupted" );
	level endon ( "players_down" );
	level endon ( "missionfailed" );
	
	if ( !flag ( "upload_first_time" ) )
	{
		level.upload_title = so_create_hud_item( -1, -110, &"SO_NYSE_NY_MANHATTAN_UPLOAD_TITLE" );
		level.upload_count = so_create_hud_item( -1, -105, undefined );
		level.upload_count_max = so_create_hud_item( -1, 0, &"SO_NYSE_NY_MANHATTAN_UPLOAD_TITLE_MAX" );
		level.upload_count.alignx = "left";
		level.upload_count SetValue( level.codes_uploaded );
	
		level.upload_title set_hud_green();
		level.upload_count set_hud_green();
		level.upload_count_max set_hud_green();
		
		flag_set ( "upload_first_time" );
	}
	
	else
	{
		level.upload_title.alpha = 1;
		level.upload_count.alpha = 1;
		level.upload_count_max.alpha = 1;
	}
	
	
//	level.vehicles_max = level.laptops_left;
//	
	while( true )
	{
		wait 0.2;
		level.codes_uploaded = level.codes_uploaded + randomintrange ( 7, 19 );
		
		if ( level.codes_uploaded >= 9276 )
			break;
		
		if ( level.codes_uploaded >= 6957 )
			flag_set ( "upload_75_percent" );
		else if ( level.codes_uploaded >= 4638 )
			flag_set ( "upload_50_percent" );
		else if ( level.codes_uploaded >= 2319 )
			flag_set ( "upload_25_percent" );		
		
		level.upload_count SetValue( level.codes_uploaded );
		
	}
	
	level.upload_count SetValue ( 9276 );
	array_call ( level.players, ::EnableDeathShield, true );
	flag_set ( "upload_complete" );

	level.upload_title thread so_hud_pulse_success();
	level.upload_count thread so_hud_pulse_success();
	level.upload_count_max thread so_hud_pulse_success();

	if ( isdefined ( level.upload_title ) )
	{
		level.upload_title FadeOverTime( 1 );
		level.upload_title.alpha = 0;
	}

	if ( isdefined ( level.upload_count ) )
	{
		level.upload_count FadeOverTime( 1 );
		level.upload_count.alpha = 0;
	}
	
	if ( isdefined ( level.upload_count_max ) )
	{
		level.upload_count_max FadeOverTime( 1 );
		level.upload_count_max.alpha = 0;
	}
		


//		level.upload_count_max thread so_remove_hud_item();
//		level.upload_count thread so_remove_hud_item();
//		level.upload_title thread so_remove_hud_item();
}

upload_interrupt_monitor()
{
	level endon ( "upload_complete" );
	level endon ( "missionfailed" );
	
	while ( true )
	{
		level waittill( "upload_area_occupied" );
		if( !flag( "upload_area_occupied" ) )
			thread upload_interrupt();
	}	
}

upload_interrupt()
{
	level notify( "enter_upload_interrupt" );
	level endon ( "enter_upload_interrupt" );
	
	level endon ( "upload_area_occupied" );
	level endon ( "upload_complete" );
	level endon ( "missionfailed" );
	
	wait 5;
	
	level notify ( "upload_interrupted" );
	flag_clear ( "upload_running" );
	
	level.upload_trigger trigger_on();
	thread upload();
	
	level.upload_title.alpha = 0;
	level.upload_count.alpha = 0;
	level.upload_count_max.alpha = 0;
//	
//	level.upload_title thread so_remove_hud_item();
//	level.upload_count thread so_remove_hud_item();
//	level.upload_count_max thread so_remove_hud_item();
	
	//first time only
	if ( !flag ( "upload_interrupted_first_time" ) )
	{
		level.upload_interrupted_title = so_create_hud_item( -1, so_hud_ypos(), &"SO_NYSE_NY_MANHATTAN_UPLOAD_INTERRUPTED" );
		level.upload_interrupted_title set_hud_red();
		flag_set ( "upload_interrupted_first_time" );
	}
	
	else
	{
		level.upload_interrupted_title.alpha = 1;
	}
	
	level.upload_interrupted_title thread hud_blink();
	
	thread radio_dialogue_queue_single ( "so_manhat_hqr_restartupload" );
	lines = [];
  lines [ lines.size ] = "so_manhat_hqr_interrupted";
  lines [ lines.size ] = "so_manhat_hqr_irepeat";	
  delaythread ( 5, ::dialogue_reminder, "radio", "upload_running", lines );

}

playersatjammer()
{
	foreach(player in level.players)
	{
		if(!player IsTouching ( getent ( "upload_area", "targetname" ) ) )
			return false;	
	}
	return true;
	
}

music()
{
	mus_play ( "so_nymh_broad_stairwell", 2 );
	flag_wait ( "start_combat" );
	wait 2;
	mus_play ( "so_nymh_broad_enemy_humvees", 1 );
	flag_wait ( "entering_nyse" );
	mus_play ( "so_nymh_broad_stairwell", 2 );
	flag_wait ( "start_trading_floor" );
	mus_play ( "so_nymh_broad_enemy_humvees", 1 );
	flag_wait ( "so_nyse_ny_manhattan_complete" );
	mus_play ( "so_so_victory_delta", 1 );
	
	
}

rooftop_guys_respawn()
{
	self waittill ( "death" );
	if ( isdefined ( self ) && isdefined ( self.script_noteworthy ) )
	{
		new_spawner = getentarray ( self.script_noteworthy, "targetname" );
		thread maps\_spawner::flood_spawner_scripted ( new_spawner );
	}
}

wall_smoke()
{
	flag_wait ( "start_combat" );
	org = getent ( "org_smoke_grenade", "targetname" );
	dest = getent ( "dest_smoke_grenade", "targetname" );
	
	magicgrenade ( "smoke_grenade_american", org.origin, dest.origin );
}

nyse_from_street_think()
{
	if ( !flag ( "at_rooftop" ) )
		self setgoalvolumeauto ( level.vol_trading_floor );
	else
		self setgoalvolumeauto ( level.vol_rooftop );
		
}	

//===========================================
// 			chemical grenade
//===========================================
grenade_monitor()
{
	self endon ( "death" );
	
	while ( true )
	{
		self waittill ( "grenade_fire", grenade );
		if ( flag ( "allow_chem_grenade" ) )
			grenade thread chem_grenade();
	}
}

chem_grenade()
{
	org = spawn ( "script_origin", ( 0, 0, 0 ) );
	
	while ( isdefined ( self ) )
	{
		org.origin = self.origin;
		wait 0.05;
	}
	
	playfx( level._effect[ "chem_grenade" ], org.origin );
	
	wait 2;
	
	dmg_trig = Spawn ( "trigger_radius", org.origin, 0, 128, 96 );
	dmg_trig thread chem_grenade_dmg();
	
	wait 32;
	
	dmg_trig notify ( "stop_dmg" );
	wait 0.05;
	dmg_trig delete();
	
}

chem_grenade_dmg()
{	
	self endon ( "stop_dmg" );
	while ( isdefined ( self ) )
	{
		self waittill ( "trigger", player );
		
		while ( player istouching ( self ) && isdefined ( self ) )
		{
			player DoDamage(20, self.origin);
			player play_sound_on_entity( "breathing_hurt_start" );
			player PlayRumbleOnEntity( "damage_light" );
			//player setblurforplayer ( 10, 1 );

			wait 1;
		}
	}
	
}

//===========================================
// 			checmical mortar
//===========================================
chem_mortar ( num, locations )
{	
	impact_sounds = [];
	impact_sounds [ impact_sounds.size ] = "street_exploder_big_01";
	impact_sounds [ impact_sounds.size ] = "street_exploder_big_02";
	
	//array of locations passed in as a string
	if ( isdefined ( locations ) )
	{
		positions = getentarray ( locations, "targetname" );
		positions = array_randomize ( positions );
	}
	
	//you can run this on an entity (a player, or other ent) and have that as self, leaving locations undefined
	else
	{
		positions = [];
		positions [ positions.size ] = self;
	}
	
	for ( i = 0; i < num; i++ )
	{
		impact_sound = random ( impact_sounds );
		
		wait randomfloatrange ( 1, 3 );
		// Play missile incoming sound and wait a bit.
		positions[i] playsound ( "nymn_mortar_incoming" );
		wait 0.9;	
		// Play missile explosion sound & VFX.
		positions[i] playsound ( impact_sound );
		RadiusDamage ( positions[i].origin, 128, 50, 30 );
		playfx ( getfx( "ny_mortarexp_dud" ), positions[i].origin );
		playfx ( level._effect[ "chem_rpg" ], positions[i].origin );
		
		dmg_trig = Spawn ( "trigger_radius",  positions[i].origin, 0, 128, 96 );
		dmg_trig thread chem_grenade_dmg();
		dmg_trig thread chem_mortar_stop_dmg();
	}

		
}

monitor_xm25_kill()
{
	level endon ( "so_nyse_ny_manhattan_complete" );
	
	self waittill ( "death", attacker, cause, weapon );
	if ( isdefined ( attacker ) && isplayer ( attacker ) && isdefined ( weapon ) && IsSubStr ( weapon, "xm25" ) )
	{
		attacker.bonus_1++;
		attacker notify ( "bonus1_count", attacker.bonus_1 );
	}
	
}
	
chem_mortar_stop_dmg()
{
	wait 32;
	
	self notify ( "stop_dmg" );
	wait 0.05;
	self delete();
}

helo_dmg_hint_bullet()
{
	self endon ( "death" );
	
	while ( true )
	{
		self waittill ( "bullethit", player ); //waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, dFlags, weaponName );
			player display_hint_timeout ( "hint_heli_dmg", 3 );
	
	}
}

helo_dmg_hint_other()
{
	self endon ( "death" );
	
	while ( true )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, dFlags, weaponName );
		if ( ( isdefined ( type ) && ( type == "MOD_EXPLOSIVE" || type == "MOD_EXPLOSIVE_SPLASH" || type == "MOD_IMPACT" || type == "MOD_GRENADE_SPLASH" || type == "MOD_PROJECTILE_SPLASH" ) ) || ( isdefined ( weaponname) && issubstr ( weaponname, "rpg" ) ) )
			attacker display_hint_timeout ( "hint_heli_dmg", 3 );
	
	}
}

setup_vo()
{
	//overlord
	add_radio([
		"so_manhat_hqr_likeabird",		//Metal 0-4, the high value detainee is singing like a bird. He says the Russian encryption codes are located somewhere in the stock exchange trading floor.  Proceed to check-point alpha.
		"so_manhat_hqr_tradingfloor",				//The encryption codes are located somewhere in the trading floor.  Find them and get them to the rooftop.
		"so_manhat_hqr_twomore",		//Two more.
		"so_manhat_hqr_onemore",			//One more to go.
		"so_manhat_hqr_inhand",			//Metal 0-4, all encryption codes are in hand, move to the rooftop, over.
		"so_manhat_hqr_proceed",		//Proceed to the rooftop and upload the codes to cent-com through the comm-tower. 
		"so_manhat_hqr_sayagain",		//Metal 0-4, I say again, proceed to the communications tower and upload those encryption codes.
		"so_manhat_hqr_gettotheroof",	//Get to the rooftop Metal 0-4.  
		"so_manhat_hqr_restartupload",		//Metal 0-4, the upload has timed out.  Restart the upload sequence immediately.
		"so_manhat_hqr_interrupted",	//The upload has been interrupted.  Get to the tower and resume the upload Metal 0-4. 
		"so_manhat_hqr_irepeat",		//Signal is dead Metal 0-4.  I repeat, we have no signal.  Resume the upload ASAP.
		"so_manhat_hqr_enemyhelos",			//Enemy helos entering your air space.
		"so_manhat_hqr_enemyhind",			//Enemy hind incoming metal 0-4. 
		"so_manhat_hqr_enemytroops",			//Metal 0-4 you've got enemy troops on the adjacent rooftops.  Hunker down and hold that sector.
		"so_manhat_hqr_twentyfivepercent",			//Upload 25% complete
		"so_manhat_hqr_fiftypercent",			//50% complete.
		"so_manhat_hqr_seventyfivepercent",			//Upload is 75% complete Metal 0-1.  
		"so_manhat_hqr_greatwork"			//Metal 0-4, upload is complete.  Great work team, you have a black hawk inbound for exfil.  ETA 2 minutes.
	]);
	thread vo();
	thread vo_upload();
	thread stop_vo();
}

stop_vo()
{
	level waittill ("missionfailed");
	
	if( !flag( "upload_running" ))
		flag_set( "upload_running" );
	
	while (1)
	{
		level notify ( "stop_reminders" ); //there are thread delays on some of the reminders. if the player dies before the delay the reminders will not be aware the mission has failed
		wait 0.05;
	}
}

vo()
{
	wait 1;

	thread radio_dialogue_queue_single ( "so_manhat_hqr_likeabird" );
	flag_wait ( "at_nyse" );
	thread radio_dialogue_queue_single ( "so_manhat_hqr_tradingfloor" );
	level waittill ( "all_laptops_pickedup" );
	thread radio_dialogue_queue_single ( "so_manhat_hqr_inhand");
	lines = [];
  	lines [ lines.size ] = "so_manhat_hqr_sayagain";
  	lines [ lines.size ] = "so_manhat_hqr_gettotheroof";
  	lines [ lines.size ] = "so_manhat_hqr_gettotheroof";	
	thread dialogue_reminder ( "radio", "at_rooftop", lines );
	flag_wait ( "at_rooftop" );
	delaythread ( 5, ::radio_dialogue_queue_single, "so_manhat_hqr_enemytroops" );

}

vo_upload()
{
	flag_wait ( "upload_25_percent" );
	thread radio_dialogue_queue_single ( "so_manhat_hqr_twentyfivepercent" );
	flag_wait ( "upload_50_percent" );
	thread radio_dialogue_queue_single ( "so_manhat_hqr_fiftypercent" );
	flag_wait ( "upload_75_percent" );
	thread radio_dialogue_queue_single ( "so_manhat_hqr_seventyfivepercent" );
}
	

add_radio(lines)
{
	foreach(line in lines)
	{
		level.scr_radio[line] = line;	
	}	
}
	
//===========================================
// 			spawn_so_warlord_dog
//===========================================
spawn_so_warlord_dog( spawner_targetname, exit_targetname )
{
	dog_spawners = GetEntArray( spawner_targetname, "targetname" );
	
	for( i = 0; i < dog_spawners.size; i++)
	{
		dog = dog_spawners[i] spawn_ai( true );
		
		victim = level.player;
		
		// chance to set coop player as the inital target
		if( is_coop() && cointoss() )
		{
			victim = level.player2;
		}
		
		dog SetGoalEntity( victim );
		dog set_favoriteenemy( victim );
		
		exit_point = GetEnt( exit_targetname, "targetname" );
		dog thread dog_monitor_goal_ent( victim, exit_point );
	}
}

//
//grenade_airburst()
//{	
//	org = undefined;
//	
//	while ( isdefined ( self ) )
//	{
//		org = self getorigin();
//		wait 0.05;
//	}
//	
//	airburst = magicgrenade ( "fraggrenade_cluster_airburst", org, org + ( 0, 0, 256 ) );
//	airburst thread grenade_cluster();
//	
//	//physicsexplosionsphere ( org, 200, 1, 1 );
//	
//}

//grenade_cluster()
//{	
//	org = undefined;
//	
//	while ( isdefined ( self ) )
//	{
//		org = self getorigin();
//		wait 0.05;
//	}
//	
//	for ( i = 0; i < 5; i++ )
//	{
//		//wait randomfloatrange ( 0.1, 0.15 );
//		x = RandomFloatRange ( -300, 300 );
//		y = RandomFloatRange ( -300, 300 );
//		z = randomfloatrange ( 128, 256 );
//		airburst = magicgrenade ( "fraggrenade_cluster_children", org, org + ( x, y, z ) );
//	}
//	
//	physicsexplosionsphere ( org, 200, 1, 1 );
//	
//}
