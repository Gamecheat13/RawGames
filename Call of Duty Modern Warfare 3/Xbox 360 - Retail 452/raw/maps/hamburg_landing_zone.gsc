#include maps\_utility;
#include maps\_utility_code;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\hamburg_code;
#include maps\hamburg_hovercraft_code;
#include animscripts\hummer_turret\common;
#include maps\hamburg_tank_ai;

pre_load()
{
	PreCacheShellShock( "hamburg_blackout" );
	PreCacheShellShock( "hamburg_garage_crash" );
	PreCacheItem( "rpg_straight" );
	PreCacheItem( "rpg_distant" );
	PreCacheItem( "rpg_straight_distant" );
	PreCacheItem( "m1a1_turret_blank" );
	PreCacheItem( "zippy_rockets_apache_cheap" );
	
	maps\hamburg_landing_zone_anim::main();
	
	add_earthquake( "tank_quake", 1, 0.7, 400 );
	
	thread post_load();
	
	mask_destructibles_in_volumes_noteworthy( "strafe_building_1_fx_volume" );
	mask_destructibles_in_volumes_noteworthy( "strafe_building_2_fx_volume" );
	mask_destructibles_in_volumes_noteworthy( "hamburg_b_area" );
	mask_destructibles_in_volumes_noteworthy( "garage_area" );
	mask_destructibles_in_volumes_noteworthy( "bridge_and_before_garage_area" );
	mask_destructibles_in_volumes_noteworthy( "parking_lot_area" );
	
	flag_init( "tank_out_of_left" );

}

post_load()
{	
	level waittill ( "load_finished" );
		
	move_hangout_helis = GetEntArray( "move_hangout_heli" , "targetname" );
	array_thread( move_hangout_helis, ::move_hangout_helithink );

	level.struct = undefined;

	thread maps\_mortar::bog_style_mortar();
		
	array_spawn_function_noteworthy( "sprints_to_goal", ::sprints_to_goal );
	
	array_spawn_function_noteworthy( "tank_out_of_left" , ::flag_set, "tank_out_of_left" );
	
	spawn_mask_tank_rides = GetEntArray( "spawn_mask_tank_ride" , "targetname" );
	array_thread( spawn_mask_tank_rides, ::trigger_off );
	spawn_mask_tank_rides = GetEntArray( "spawn_mask_tank_ride", "script_noteworthy" );
	array_thread( spawn_mask_tank_rides, ::trigger_off );
	spawn_mask_tank_rides = GetEntArray( "spawn_mask_tank_ride_2" , "script_noteworthy" );
	array_thread( spawn_mask_tank_rides, ::trigger_off );
	spawn_mask_tank_rides = GetEntArray( "spawn_mask_tank_ride_2" , "targetname" );
	array_thread( spawn_mask_tank_rides, ::trigger_off );
	spawn_mask_tank_ride_backup = GetEntArray( "spawn_mask_tank_ride_backup" , "targetname" );
	array_thread( spawn_mask_tank_ride_backup, ::trigger_off );
	
	catchup_allies_helper = GetEnt( "catchup_allies_helper", "targetname" );
	catchup_allies_helper thread catchup_allies_helper_think();
	
	thread street_dialogue_callouts();
}

sprints_to_goal()
{
	self endon ( "death" );
	self enable_sprint();
	self set_ignoreme( true );
	delayThread( 5, ::set_ignoreme, false );
	self waittill ( "goal" );
	self disable_sprint();
}

heli_dukes_it_out_with( attacker, recievers, do_player, one_fire_at_a_time )
{
	attacker = get_vehicle( attacker, "targetname" );
	if ( !IsAlive( attacker ) )
	{
		return;
	}

	attacker endon ( "death" );
	enemys = [];
	
	foreach ( reciever in recievers )
	{
		enemys[ enemys.size ] = get_vehicle( reciever, "targetname" );
	}
		
	if ( IsDefined( do_player ) && do_player )
	{
		enemys[ enemys.size ] = level.player;
	}
		
	foreach ( enemy in enemys )
	{
		while ( IsAlive( enemy ) && !enemy vehicle_is_crashing()  && !self vehicle_is_crashing() )
		{
			enemy godoff();
			enemy.enableRocketDeath = true;
			attacker SetLookAtEnt( enemy );
			if( enemy == level.player )
			{
				level.player endon ( "death" );
				wait 6;
			}

			if( attacker.vehicletype == "apache" )
			{
				do_fire = true;
				if ( IsDefined( level.only_one_heli_fire ) )
				{
					if ( !level.only_one_heli_fire )
					{
						//level.only_one_heli_fire = true;
						attacker maps\_helicopter_globals::fire_missile( "apache_zippy", 3, enemy, 0.4, 0.75 );
						//level thread reset_only_one_heli_fire();
					}
				}
				else
				{
					attacker maps\_helicopter_globals::fire_missile( "apache_zippy", 3, enemy, 0.4, 0.75 );
				}
			}
			else
			{
				attacker maps\_helicopter_globals::fire_missile( "mi28_zippy", 3, enemy, 0.4, 0.75 );
			}

			wait( RandomFloatRange( 1.3, 2 ) );
		}
	}

	attacker ClearLookAtEnt();
}

reset_only_one_heli_fire()
{
	wait( 4 );

	if ( !IsDefined( level.only_one_heli_fire ) )
	{
		return;
	}

	level.only_one_heli_fire = false;
}

do_beach_smoke()
{
	
	//lock away in Mikes sections.. working around.
	friend_smoke_beach = getstruct( "friend_smoke_beach", "targetname" );
	trigger = GetEnt( friend_smoke_beach.target, "targetname" );
	trigger waittill( "trigger" );
	
	//Rhino 1: Deploying smoke.
	radio_dialog_add_and_go( "tank_rh1_deployingsmoke" );

	// new target. location of exploder
	friend_smoke_beach = getstruct( "beach_smoke_org", "targetname" );
	vector = VectorNormalize( friend_smoke_beach.origin - level.hero_tank GetCentroid() );
	
	new_destination = friend_smoke_beach.origin + ( vector * 500 ); // need to shoot the trails through the smoke center a bit
	
	wait 0.15;
	level.hero_tank ent_flag_init( "fired_smoke_screen" );
	destination = level.hero_tank vehicle_scripts\_m1a1_player_control::launch_smoke( new_destination );
	level.hero_tank ent_flag_wait( "fired_smoke_screen" );
	

	thread play_sound_in_space( "flashbang_explode_default",destination );
	exploder( "shore_smoke" );
	delaythread( 0.25, ::event1_encounter2 );

	//Rhino 1: We're gonna need you boys to sweep the forward area - make sure we're good to move up.
	thread radio_dialog_add_and_go( "tank_rh1_youboys" );

	//Sandman: Copy, we'll clear you a path!
	level.sandman thread radio_dialog_add_and_go( "hamburg_snd_clearapath" );
	
	beach_smoke_color = GetEnt( "beach_smoke_color", "script_noteworthy" );
	if ( IsDefined( beach_smoke_color ) )
	{
		target = GetEnt( beach_smoke_color.target, "targetname" );
		
		move_right_delay = 17;
		if ( IsDefined( target ) )
			target thread notify_delay( "trigger" , move_right_delay);
		beach_smoke_color thread notify_delay( "trigger", 0.5 );
		delaythread( move_right_delay-8, ::nag_flank_right  );
	}
	
	delaythread( 9 ,::do_objective_walk );
}

do_objective_walk()
{
	current_trigger = GetEnt( "objective_walker_moveright", "targetname" );
	
	marker = spawn_tag_origin();
	while( IsDefined( current_trigger ) )
	{
		target_struct = getstruct( current_trigger.target, "targetname" );
		do_objective_walk_chain( current_trigger, target_struct, marker );
		if ( !IsDefined( target_struct.target ) )
			return; // end of the line.
		current_trigger = GetEnt( target_struct.target, "targetname" );
	}
	marker Delete();
}

street_dialogue_callouts()
{
	trigger = GetEnt( "allies_to_hot_building_color", "script_noteworthy");
	trigger waittill ( "trigger" );
	
	wait( 8 );
	
	radio_dialog_add_and_go( "hamburg_snd_movemove" );
	
	flag_wait( "two_tanks_in_alley" );
	//	sandman
	//	Got two more T90's!  Left side!	
	radio_dialog_add_and_go( "tank_rh2_2moret90s" );
	
	// rhino
	// Alright, stand clear.  We're gonna get some rounds in that 
    // direction.
	radio_dialog_add_and_go( "tank_rh1_standclear" );
	radio_dialog_add_and_go( "tank_rh2_rightbehindyou" );

	wait( 5 );
    radio_dialog_add_and_go( "hamburg_snd_movemove" ); 
  
 	flag_wait( "bridge_spawn_trigger" );
    
    radio_dialog_add_and_go( "hamburg_snd_movemove" ); 	
}

do_objective_walk_chain( current_trigger, target_struct, marker )
{
	Objective_Position( obj( "scout_for_tanks" ), target_struct.origin );
	if( isdefined( current_trigger.script_parameters ) )
	{
		if( flag( current_trigger.script_parameters )  )
			return;
		level endon ( current_trigger.script_parameters ); // flag 
	}
  	current_trigger waittill ( "trigger" );
}

nag_flank_right()
{
	// not really nag since I don't have the trigger setup. might not need it.
	level endon ( "stop_nag_flank_right" );
	base_rand = [ 
			"hamburg_snd_rightflank",
			"hamburg_snd_goinright",
			"hamburg_snd_sticktoright"
			];
	new_rand = base_rand;	
	
	foreach( select in new_rand )
	{
		level.sandman dialogue_queue( select );	
		wait RandomFloatRange( 4, 6 );
	}
}

glory_tank_death()
{
	waittillframeend; // let spawn function finishe adding bullet shield.  
	flag_wait( "glory_tank_ready_for_death" );

	flag_wait( "player_ready_for_hot_buildings" );

	//clear out guys who are running about on the roof tops.
	level notify ( "goal_think_triggered_new" );
	
	putout_fires_stop_badplaces();
	
	glory_tank_missile_struct = getstruct_delete( "glory_tank_missile_struct", "targetname" );
	
	newMissile = MagicBullet( "javelin_no_explode", glory_tank_missile_struct.origin, level.glory_tank GetCentroid() + (0,0,16) );
	newmissile Missile_SetFlightmodeDirect();
	newMissile Missile_SetTargetEnt( level.glory_tank );
	
	thread radio_dialog_add_and_go( "hamburg_rhg_incoming", 0.5 );

	hangout_heli = get_hangout_heli( "heli_ally_hangout1" );
	hangout_heli delaythread( 1, ::missile_chain, "missile_chain_group_a" );
	
	array_spawn_targetname( "event1_encounter2B_floodspawners", false, true );
	
	level.glory_tank riders_godoff();
	level.glory_tank godoff();
	level.glory_tank waittill_notify_or_timeout( "death", 1.55 );
	level.glory_tank JoltBody ( level.glory_tank.origin, 9 );
	if ( IsAlive( level.glory_tank ) )
		level.glory_tank kill();
	
	
	thread drones_run_away();

	
	Earthquake( 1.3, 0.8, level.player_tank.origin, 400 );
	
	music_play( "hamburg_glory_tank_dies" );
	delaythread( 70, ::music_stop, 10 );
	
	thread hot_buildings_one();

}

hot_buildings_one()
{

	level.player_tank vehicle_stop_named( "hot_buildings_one", 15, 15 );
	thread hot_buildings_hangout_heli_one();
	//thread hot_buildings_hot_help_heli();

	thread hot_buildings_hero_tank();
	thread hot_buildings_player_tank();

	exploder( "strafe_building_1_pre" );
	
	color_trigger = GetEnt( "allies_to_hot_building_color", "script_noteworthy");
	if ( IsDefined( color_trigger ) )
		color_trigger notify ( "trigger" );

	wait 7;
	array_spawn_targetname( "building_drones_floor_one", true, undefined, false );

	wait 5;

	flag_set( "hot_buildings_destroyed" );
	//exploder( "strafe_building_1" );
	
}


hot_buildings_two()
{
	javelin_to_hot_help_helis = getstructarray_delete( "javelin_to_hot_help_heli" , "targetname" );
	
	hot_help_helis = [];
	hot_help_heli = get_vehicle( "event1_forward_heli_one", "targetname" );
	hot_help_heli.enableRocketDeath = true;
	hot_help_heli godoff();
	
	hot_help_helis[ hot_help_helis.size ] = hot_help_heli;

	hot_help_heli = get_vehicle( "event1_forward_heli_nine", "targetname" );
	if( isdefined( hot_help_heli ) )
	{
		hot_help_heli.enableRocketDeath = true;
		hot_help_heli godoff();
		hot_help_helis[ hot_help_helis.size ] = hot_help_heli;
	}
	
	current_hot_help = 0;
	foreach( spot in javelin_to_hot_help_helis )
	{
		hot_help_heli = hot_help_helis[ current_hot_help ];
		current_hot_help++;
		if ( !IsAlive( hot_help_heli ) )
			continue;
		newMissile = MagicBullet( "javelin_no_explode", spot.origin, hot_help_heli GetCentroid() );
		newmissile Missile_SetFlightmodeDirect();
		newMissile Missile_SetTargetEnt( hot_help_heli );
		newMissile delaycall( 22, ::Missile_ClearTarget );
	}
	
	level.player_tank vehicle_stop_named( "hot_buildings_two", 5, 5 );
	level.hero_tank vehicle_stop_named( "hot_buildings_two", 5, 5 );
	
	thread hot_buildings_hangout_heli_two();
	thread hot_buildings_hero_tank_two();
	thread hot_buildings_player_tank_two();

	exploder( "strafe_building_2_pre" );
	
	wait 6;

	level.player_tank vehicle_resume_named( "hot_buildings_two"  );
	level.hero_tank vehicle_resume_named( "hot_buildings_two"  );


}

hot_buildings_hero_tank()
{
	level.hero_tank stop_turret_attack_think_hamburg();
	level.hero_tank SetVehWeapon( "m1a1_turret_blank" );
	level.hero_tank vehicle_attacks_chain( "missile_chain_group_a", "hot_buildings_destroyed" );
	level.hero_tank vehicle_attacks_chain( "missile_chain_group_c", "hot_buildings_destroyed" );
	level.hero_tank vehicle_turret_restore_old_mode();
	level.hero_tank thread turret_attack_think_hamburg();
}

hot_buildings_player_tank()
{
	level.player_tank SetVehWeapon( "m1a1_turret_blank" );
	level.player_tank stop_turret_attack_think_hamburg();
	level.player_tank vehicle_attacks_chain( "missile_chain_group_c", "hot_buildings_destroyed" );
	level.player_tank vehicle_attacks_chain( "missile_chain_group_a", "hot_buildings_destroyed" );
	level.player_tank vehicle_turret_restore_old_mode();
	level.player_tank thread turret_attack_think_hamburg();
}

hot_buildings_hero_tank_two()
{
	level.hero_tank stop_turret_attack_think_hamburg();
	level.hero_tank SetVehWeapon( "m1a1_turret_blank" );
	level.hero_tank vehicle_attacks_chain( "missile_chain_group_d", "hot_buildings_destroyed_2" );
	level.hero_tank vehicle_attacks_chain( "missile_chain_group_c", "hot_buildings_destroyed_2" );
	level.hero_tank vehicle_turret_restore_old_mode();
	level.hero_tank thread turret_attack_think_hamburg();
}

hot_buildings_player_tank_two()
{
	level.player_tank SetVehWeapon( "m1a1_turret_blank" );
	level.player_tank stop_turret_attack_think_hamburg();
	level.player_tank vehicle_attacks_chain( "missile_chain_group_c", "hot_buildings_destroyed_2" );
	level.player_tank vehicle_attacks_chain( "missile_chain_group_d", "hot_buildings_destroyed_2" );
	level.player_tank vehicle_turret_restore_old_mode();
	level.player_tank thread turret_attack_think_hamburg();
}
//
//hot_buildings_hot_help_heli()
//{
//	hot_help_heli = spawn_vehicle_from_targetname_and_drive( "hot_help_heli" );
//	hot_help_heli endon ( "death" );
//	hot_help_heli tank_mgs_stop_targeting_drones();
//	missile_array = hot_help_heli get_four_missiles();
//	hot_help_heli thread vehicle_attacks_chain( "missile_chain_group_a", "hot_buildings_destroyed" );
//	hot_help_heli missile_chain( "missile_chain_group_b", 10, "hot_buildings_destroyed", "apache_zippy_nd",missile_array );
//	hot_help_heli tank_mgs_target_drones();
//	hot_help_heli thread heli_attacks_all_enemies();
//}

hot_buildings_hangout_heli_one()
{
	hangout_heli = get_hangout_heli( "heli_ally_hangout1" );
	
	if ( !IsAlive( hangout_heli ) )
		return;
		
	hangout_heli endon ( "death" );	
	missile_array = hangout_heli get_four_missiles();
	hangout_heli missile_chain( "missile_chain_group_a", 10, "hot_buildings_destroyed", "apache_zippy_nd",missile_array  );
	hangout_heli thread heli_attacks_all_enemies();
}

hot_buildings_hangout_heli_two()
{
	hangout_heli = get_hangout_heli( "heli_ally_hangout1" );
	
	if ( !IsAlive( hangout_heli ) )
		return;
		
	hangout_heli endon ( "death" );	
	missile_array = hangout_heli get_four_missiles();
	hangout_heli missile_chain( "missile_chain_group_a", 10, "hot_buildings_destroyed_2", "apache_zippy_nd",missile_array  );
	hangout_heli thread heli_attacks_all_enemies();

}


get_four_missiles()
{
	default_missile_array = get_default_missile_chain_array();
	return[ default_missile_array[ 0 ], default_missile_array[ 1 ], default_missile_array[ 2 ], default_missile_array[ 3 ] ];
	
}

tank_path_hot_buildings()
{
	thread glory_tank_death();
	thread hot_buidlings_get_attacked();

	flag_wait( "hot_buildings_destroyed" );
	delaythread( 1, ::autosave_by_name, "down_street" );
	thread bridge_guys();
	flag_wait( "player_ready_to_cross_street" );
	
	flag_wait( "two_tanks_in_alley" );
	two_tanks_in_alley = GetEnt( "two_tanks_in_alley", "targetname" ); // really three!
	two_tanks_in_alley delete();
	
	hangout_heli = get_hangout_heli( "heli_ally_hangout1" );
	autosave_by_name( "Down_street_two" );
	tank_out_of_left2 = spawn_vehicle_from_targetname_and_drive( "tank_out_of_left2" );
}

tank_path_pre_bridge()
{
}

nag_player_get_on_tank()
{
	level endon ( "stop_nag_player_get_on_tank" );
	
	base_rand = [ 
			"hamburg_snd_onminigun",
			"hamburg_snd_upyougo",
			"hamburg_snd_getongun"
			];
	new_rand = base_rand;	
	while( true )
	{
		select = new_rand[0];
		new_rand = array_remove( new_rand, select );
		if( ! new_rand.size )
		{
			new_rand = array_randomize( base_rand );
			if( new_rand[0] == select )
			{
				new_rand = array_remove( new_rand, select );
				new_rand[ new_rand.size ] = select;
			}
		}
		level.sandman dialogue_queue( select );	
		wait RandomFloatRange( 4, 6 );
	}
}

tank_path_bridge()
{
	flag_set( "tank_path_bridge" );

	maps\hamburg_minigun_death::main();

	while( level.player_tank Vehicle_GetSpeed() > 1 )
		wait 0.05;
	level.player_tank stop_turret_attack_think_hamburg();
	
	array_delete( GetEntArray( "glowy_tank_destroys_no_mans_land" , "script_noteworthy" ) );
	
	level.player_in_nomans_land  = false;
	
	level.player_tank ClearTurretTarget();
	level.player_tank SetTurretTargetVec( level.player_tank tag_project( "tag_body", 100000 ) );
	level.player_tank SetModel( "vehicle_m1a1_abrams_minigun_shiny_objective" );
	level.player_tank HidePart( "tag_not_shiny_part" );
	shinybit = level.player_tank spawn_tag_origin();
	shinybit SetModel ( "vehicle_m1a1_abrams_minigun_shiny_part" );
	shinybit Show();
	shinybit LinkTo( level.player_tank, "tag_shiny_part_attach", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
    trigger = GetEnt( "mount_tank_trigger", "targetname" );
    trigger UseTriggerRequireLookAt();
	//Man the minigun on the tank.
	objective_state( obj( "scout_for_tanks" ), "done" ); 
	Objective_Add( obj( "hop_on_the_tank" ), "active", &"HAMBURG_OBJECTIVE_HOP_ON_THE_TANK", trigger GetCentroid() + (0,0,28) );
	Objective_Current( obj( "hop_on_the_tank" ) );

	trigger SetCursorHint( "HINT_ACTIVATE" );
    //Hold &&1 to use
    trigger SetHintString( &"PLATFORM_HOLD_TO_USE" );

	array_delete( GetEntArray( "no_mans_land" , "targetname" ) );
	
	thread nag_player_get_on_tank();
    
    trigger waittill ( "trigger" );
    level.player_tank ShowPart( "tag_not_shiny_part" );
    shinybit Delete();
    
    let_the_friends_through = GetEnt( "let_the_friends_through", "targetname" );
    let_the_friends_through connectpaths();
    let_the_friends_through delete();
    
    level notify ( "stop_nag_player_get_on_tank" );
    
	
	spawn_mask_tank_ride_backup = GetEntArray( "spawn_mask_tank_ride_backup" , "targetname" );
	delaythread( 2,::array_thread, spawn_mask_tank_ride_backup, ::trigger_on );
	
    objective_complete( obj( "hop_on_the_tank" ) );
     
    pauseeffectsByID( "thin_black_smoke_M_HELICOPTER" );
    
	do_tank_mount();
	
	level.player_tank ClearTurretTarget();
	level.player_tank thread turret_attack_think_hamburg();
	
	put_player_on_tank();
	flag_set( "player_in_tank" );
	delaythread( 1, ::autosave_by_name, "passed_bridge" );

	level.player_tank thread do_path_section_without_the_hassle( "tank_player_just_mounted" );
	
	delaythread( 2, ::garage_cleanup_beach_area );

	helis_come_out = GetVehicleNode( "helis_come_out", "script_noteworthy" );	
	helis_come_out waittill_triggered_current();	
	
	hind_chase_two = spawn_vehicle_from_targetname_and_drive( "heli_chase_two" );
	add_cleanup_ent( hind_chase_two, "pre_garage_vehicles" );
	hind_chase_two godon();
	
	hind_chase_two delaythread( 1.5, ::missile_chain_delay_custom, "heli_chase_two_missile_chain" );
	hind_chase_two delaythread( 3, ::godoff );
	hind_chase_two SetLookAtEnt( level.hero_tank );
	
	
	wait 0.05;

	heli = spawn_vehicle_from_targetname_and_drive( "heli_chase_one" );
	add_cleanup_ent( heli, "pre_garage_vehicles" );
	heli delaythread( 2.5, ::missile_chain_delay_custom, "heli_chase_two_missile_chain_other" );
	heli delaythread( 8, ::godoff );
	heli godon();
	heli SetLookAtEnt( level.player_tank );
	
	
	//Rhino 2 Gunner: HIND!  HIND!
	thread radio_dialog_add_and_go( "hamburg_rhg_hind" );
	//Rhino 1: Back it up!  NOW!
	thread radio_dialog_add_and_go( "tank_rh1_backitup" );
	//Rhino 2 Gunner: Trophy system online!
	delaythread( 4, ::radio_dialog_add_and_go,  "hamburg_rhg_trophysys" );
	//Rhino 2: Get down!
	delaythread( 5, ::radio_dialog_add_and_go,  "tank_rh2_getdown" );


	
	thread friend_tank_blasts_at_helis( hind_chase_two, heli );
	
	level.player_tank waittill ( "reached_end_node" );

	level.hero_tank ClearTurretTarget();
	level.hero_tank.mgturret[ 0 ] ClearTargetEntity();
	level.hero_tank.mgturret[ 1 ] ClearTargetEntity();
	
	// running away from heli attack.
	level.player_tank.veh_transmission = "reverse";
	level.player_tank.script_transmission  = "reverse";
	level.player_tank thread do_path_section_without_the_hassle( "tank_track_e1_to_e2_e" );
	
	
	
	GetVehicleNode( "veh_node_player_gets_smashed", "script_noteworthy" ) waittill ( "trigger" );
	
	
	heli heli_shots_before_shock();
}

missile_chain_delay_custom( targetname )
{
	missile_chain( targetname, undefined, undefined, "mi28_zippy_cheap" );
}

do_tank_mount()
{
	minigun = spawn_anim_model( "minigun_m1a1" );
	player_rig = spawn_anim_model( "player_rig" );
	player_rig_legs = spawn_anim_model( "player_rig_legs" );

	level.player_tank SetModel( "vehicle_m1a1_abrams_viewmodel" );
	level.player_tank thread kill_the_minigun_guy();

	level.player_tank maps\_vehicle_aianim::delete_corpses_around_vehicle();

	level.player_tank get_rid_of_tanks_mg();
	level.player_tank vehicle_scripts\_m1a1_player_control::tank_spawn_crew();
	
	guys = [];
	guys[ guys.size ] = player_rig;
	guys[ guys.size ] = player_rig_legs;
	
	set_stance_for_tank_mount();
	
	level.player LerpFOV( 55, 3.15 );
	
	//hacking 90 degree offset
	intermediate = level.player_tank spawn_tag_origin();
	minigun LinkTo( intermediate, "tag_origin", (0,0,0), (0,0,0));
	intermediate LinkTo( level.player_tank , "tag_turret_mg_r", (0,0,0), (0,0,0));
	intermediate thread anim_single_solo( minigun, "mount_tank", "tag_origin" );	
	
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.3 );
	foreach( guy in guys )
		guy LinkTo( level.player_tank, "tag_guy0" );
	level.player_tank anim_single( guys, "mount_tank", "tag_guy0" );	
	array_delete( guys );
	minigun delete();
	intermediate delete();
	

}
set_stance_for_tank_mount()
{
	level.player DisableWeapons();
	level.player DontInterpolate();
	level.player allowstand( true );
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player SetStance( "stand" );
}

friend_tank_blasts_at_helis( heli1,heli2 )
{
	level.hero_tank stop_turret_attack_think_hamburg();
	level.player_tank endon ( "reached_end_node" );
	level.hero_tank turret_attacks_heli( heli1 );
	level.hero_tank turret_attacks_heli( heli2 );
	level.hero_tank ClearTurretTarget();
}

turret_attacks_heli( heli )
{
	if( !isalive( heli ) )
		return;
	self SetTurretTargetEnt( heli );
	self.mgturret[ 0 ] SetTargetEntity( heli, ( 0, 0, 0 ) );
	self.mgturret[ 1 ] SetTargetEntity( heli, ( 0, 0, 0 ) );
	heli waittill ( "death" );	
}

vehicle_attacks_chain( targetname, endon_flag )
{
	self notify ( "new_tank_chain" );
	self endon ( "new_tank_chain" );
	
	if ( IsDefined( endon_flag ) )
	{
		if( flag( endon_flag ) )
			return;
		self endon ( endon_flag );
	}
	
	target = spawn_tag_origin();
	target thread call_on_thread_end( thisthread, ::delete );
	
	self thread turret_attacks_target( target );
	
	foreach( turret in self.mgturret )
	{
		turret.OldMode = turret GetMode();
		if( turret is_turret_type_ai_mounted() )
		{
			turret SetTargetEntity( target );
			continue;
		}
				
		if( IsDefined( turret GetTurretOwner() ) )
			turret SetMode( "manual_ai" );
		else
			turret SetMode( "manual" );
			
		turret SetTargetEntity( target, ( 0, 0, 0 ) );
		turret StartFiring();
	}
	
	struct = getstruct( targetname, "targetname" );
	target.origin = struct.origin;
	targetname = struct.target;
	
	while ( IsDefined( targetname ) )
	{
		struct = getstruct( targetname, "targetname" );
		target move_with_rate( struct.origin, (0,0,0), 900 );
		targetname = struct.target;
	}
}



tank_path_blackout()
{

	level.player_tank endon ( "death" );
	array_delete( Getentarray( "bridge_spawn_triggers","targetname" ) );
	if ( is_after_start( "tank_path_bridge" ) )
	{
		node = GetVehicleNode( "tank_avoid_part_2", "targetname" );
		level.player_tank.teleported_to_path_section = true;
		level.player_tank Vehicle_Teleport( node.origin, CombineAngles( node.angles, ( 0, 180, 0 ) ) ); // going in reverse.
		level.player_tank riders_godoff();
		
		level.hero_tank do_path_teleport( "h_for_blackout" );
		level.hero_tank do_path_section_without_the_hassle( "h_for_blackout" );
		
		spawn_vehicle_from_targetname_and_drive( "heli_chase_two" );
		spawn_vehicles_from_targetname_and_drive( "heli_chase_one" );
		
		force_gate_open_for_start( "force_gate_open_for_start" );
	}
	
	spawn_mask_tank_rides = GetEntArray( "spawn_mask_tank_ride" , "targetname" );
	array_thread( spawn_mask_tank_rides, ::trigger_on );
	spawn_mask_tank_rides = GetEntArray( "spawn_mask_tank_ride" , "script_noteworthy" );
	array_thread( spawn_mask_tank_rides, ::trigger_on );

	wait 1.3;
	player_on_minigun_gets_shot_down(); 
	tank_path_after_blackout();
	
	flag_wait( "tanks_entered_garage" );
	
	level.player_tank turn_badplace_backon();
	level.hero_tank turn_badplace_backon();
}

force_gate_open_for_start( noteworthy )
{
	node = GetVehicleNode( noteworthy, "script_noteworthy" );
	node notify ( "forced_open" );
}

tank_path_after_blackout()
{
	spawn_mask_tank_rides = GetEntArray( "spawn_mask_tank_ride_2" , "script_noteworthy" );
	array_thread( spawn_mask_tank_rides, ::trigger_on );
	spawn_mask_tank_rides = GetEntArray( "spawn_mask_tank_ride_2" , "targetname" );
	array_thread( spawn_mask_tank_rides, ::trigger_on );
	
	//Rhino 1: Got more inbound!  Twelve o' clock!
	radio_dialog_add_and_go( "tank_rh1_moreinbound" );
	//Sandman: Another T90 is pulling up in front!
	radio_dialog_add_and_go( "hamburg_snd_anothert90" );
	
	wait 5;
	
	//Rhino 2: They're falling back to the garage.
	delaythread( 20, ::radio_dialog_add_and_go, "tank_rh2_fallingback" );
	
	//Rhino 1: Yeah, they're scared shitless.
	delaythread( 21, ::radio_dialog_add_and_go, "tank_rh1_theyrescared" );


	level.player_tank.script_transmission = "forward";
	level.player_tank.veh_transmission = "forward";
	level.player_tank do_path_section_without_the_hassle( "tank_avoid_part_2" );
}

event1_encounter2()
{
	array_spawn_targetname( "event1_encounter2_floodspawners", true, undefined, true );
	thread event1_encounter2_new_tanks();
	array_spawn_targetname( "event1_encounter2_flow_floodspawners", true, undefined, true );
	thread event1_encounter2_getaway();
}

event1_encounter2_getaway()
{
	wait( 0.3 );
	level.enemy_ai = Get_living_Ai_Array( "event1_ecounter1_enemy", "script_noteworthy" );
	level thread maps\hamburg_code::enemies_getaway( "event1_encounter2_getaway_trigger" ); 
	
	wait( 0.3 );
	level.enemy_ai = Get_living_Ai_Array( "event1_ecounter2_enemy", "script_noteworthy" );
	level thread maps\hamburg_code::enemies_getaway( "event1_encounter2_getaway_trigger" ); 
	level thread maps\hamburg_code::enemies_getaway( "event1_encounter2_getaway_trigger" ); 
}

event1_encounter2_new_tanks() 
{
	thread afterdust_setup_wounded();
	wait( 1.5 );
	spawn_vehicle_from_targetname_and_drive( "event1_t90" );

}

hot_buidlings_get_attacked()
{
	flag_wait( "hot_buildings_destroyed" );
	level.hero_tank notify ( "new_tank_chain" );
	level.player_tank notify ( "new_tank_chain" );
	wait( 3 );
	level.player_tank vehicle_resume_named( "hot_buildings_one" );
	hangout_heli = get_hangout_heli( "heli_ally_hangout1" );
	hangout_heli thread heli_attacks_all_enemies();
	thread hot_buildings_two();
	wait( 6 );
	spawn_vehicle_from_targetname_and_drive( "event2_tank_test_one" );
	radio_dialog_add_and_go( "tank_rh1_tanks"  );
}

bridge_guys()
{
	flag_wait( "bridge_spawn_trigger" );
	guys = array_spawn_targetname( "event2_bridge_combat_floodspawners", true );
}

heli_attacks_all_enemies( ender )
{
	self notify ( "heli_attacks_all_enemies" );
	self endon ( "heli_attacks_all_enemies" );
	
	if ( IsDefined( ender ) )
		level endon ( ender );
		
	self endon ( "death" );
	
	while( true )
	{
		enemies = GetAIArray( "axis" );
		enemies = array_combine( enemies, level.drones[ "axis" ].array );
		enemies = array_reverse( SortByDistance( enemies, level.player geteye() ) );
		if( !enemies.size ) 
			break;
			
		foreach( enemy in enemies )
		{
			
			if( ! heli_attacks_all_enemies_valid_target( enemy ) )
				continue;
			
			//missiles coming down on tanks looks bad, kills cool threatening mg that player should be trying to kill
			if ( IsDefined( enemy.ridingvehicle ) )
				continue;
				
			self SetLookAtEnt( enemy );
			
			waittill_yawed_to_target( enemy, 7 );
			
			wait RandomFloatRange( 1, 2 );
			
			if( ! heli_attacks_all_enemies_valid_target( enemy ) )
				continue;
				
			maps\_helicopter_globals::fire_missile( "apache_zippy", RandomIntRange( 2, 3 ), enemy, 0.1 );
			
			wait RandomFloatRange( 8, 15 );

		}
		
		wait 1;
	}
}

heli_attacks_all_enemies_valid_target( enemy )
{
	if ( !IsAlive( enemy ) )
		return false;
	friend = get_closest_ai( enemy.origin, "allies");
	if( DistanceSquared( friend.origin, enemy.origin ) <  2250000 )
		return false;
	if( DistanceSquared( level.player.origin, enemy.origin ) <  2250000 )
		return false;
	return true;
}


#using_animtree ( "generic_human" );
event2_axis_run_away_left()
{
	axis_ai_run = getstruct_delete( "event2_axis_drone_spawner", "targetname" );
	axis_ai_run_three = getstruct_delete( "event2_axis_drone_spawner_three", "targetname" );
	axis_ai_run spawn_struct_drone_pool( true );
	axis_ai_run_three spawn_struct_drone_pool( true );
}

spawn_struct_drone_pool( forcespawn )
{
	spawner = maps\_spawner::get_spawner_from_pool( self, 1 );
	spawner spawn_ai( forcespawn);
}


drones_run_away() // pass in target name and path here
{
	level endon( "three_tanks_dead" );
	
	childthread event2_axis_run_away_left();
}

get_black_overlay()
{
	if ( IsDefined( level.black_overlay ) )
		return level.black_overlay;
		
	level.black_overlay = maps\_hud_util::create_client_overlay( "black", 1, level.player );
	level.black_overlay.sort = -1;
}

do_dragger( Dragger_Node, Dragger, Draggee )
{
   	Dragger_Node thread anim_generic( Dragger, Dragger.animation );
   	Dragger_Node anim_generic( Draggee, Draggee.animation );
}


afterdust_setup_wounded_draggers()
{
   	spawner = GetEnt( "wounded_guy_a", "targetname" );
   	Dragger = spawner StalingradSpawn();
   	spawner Delete();
   	spawn_failed( Dragger );
   	
    Dragger.ignoreall = true;
   	Dragger gun_remove();
   	
   	Draggee = GetEnt( "wounded_guy_b", "targetname" );
   	Draggee = Draggee StalingradSpawn();
   	spawn_failed( Draggee );

    Draggee.ignoreall = true;
   	Draggee gun_remove();
   	
   	Dragger.deathanim = GetGenericAnim( "airport_civ_dying_groupB_pull_death" );
   	Draggee.deathanim = GetGenericAnim( "airport_civ_dying_groupB_wounded_death" );
   	
   	Dragger_Node = GetNode( "Dragger_node", "targetname" );
   	
   	Dragger.animation = "airport_civ_dying_groupB_pull";
   	Draggee.animation = "airport_civ_dying_groupB_wounded";
   		
	thread do_dragger( Dragger_Node, Dragger, Draggee );

   	Dragger_Node thread interrupt_anim_on_alert_or_damage( Dragger, Draggee );
   	Dragger_Node thread interrupt_anim_on_alert_or_damage( Draggee, Dragger );
	
}

afterdust_setup_wounded()
{
	thread afterdust_setup_wounded_draggers();
	array_spawn_targetname( "right_sprinters", true, true, true );
 	thread stumble_ai_common( "stumble_1", "payback_pmc_sandstorm_stumble_3" );
 	thread stumble_ai_common( "stumble_2", "hunted_dazed_walk_C_limp" );
 	thread stumble_ai_common( "stumble_3", "hunted_dazed_walk_A_zombie" );
 	thread stumble_ai_common( "stumble_4", "hunted_dazed_walk_C_limp" );
 	thread stumble_ai_common( "stumble_5", "hunted_dazed_walk_C_limp" );
}

stumble_ai_common( targetname, animname)
{
	spawner = GetEnt( targetname, "targetname" );
	guy = spawner spawn_ai( true );
	spawner Delete();
	guy endon ( "death" );
   	guy.ignoreall = true;
   	guy.fixednode = true;
   	guy.animname = "generic";
   	guy.health = 20;
   	guy set_run_anim_if_alive( animname );
   	wait RandomFloatRange( 1, 3 );
   	guy clear_run_anim();
   	wait RandomFloatRange( 2, 4 );
   	guy.ignoreall = false;
   	guy.fixednode = false;
   	
   	
}

set_run_anim_if_alive( anime, alwaysRunForward )
{
	if ( !IsAlive( self ) )
		return;
	set_run_anim( anime, alwaysRunForward );
}

interrupt_anim_on_alert_or_damage( guy, otherguy )
{
	guy endon ( "death" );
	guy waittill_any( "damage", "_stealth_bad_event_listener", "enemy" );
	if ( IsAlive( otherguy ) )
		otherguy kill();
	guy StopAnimScripted();
	self notify( "stop_loop" );
	guy kill();
}

//---------------------------------------------------------
// start bridge scene                 
//---------------------------------------------------------
heli_shots_before_shock()
{
	level.player EnableInvulnerability();
}

player_on_minigun_gets_shot_down()
{
	clean_ai();
	level.player_tank ent_flag_set( "stunned_tank" );
	level.hero_tank ent_flag_set( "stunned_tank" );
	
	thread vision_set_fog_changes( "hamburg_garage_inside_tank", 0);
	level.player_tank thread turn_on_interior_light();

	level.player EnableInvulnerability();
	level.player.stayinvulnerable = true; // tell player protection hack to not disableinvulnerability
	
	hangout_heli = get_hangout_heli( "heli_hangout_before_chase_heli" );

	Earthquake( 1, 3, level.player_tank.origin, 400 );
	PlayFX( getfx( "slamraam_explosion" ), level.player_tank.origin + ( 0, 0, 100 ) );
	level.player ShellShock( "hamburg_blackout", 9 );
	level.player LerpFOV( 65, 1 );
	
	set_ambient( "hamburg_tankbelly" );
	
	minigun = level.player_tank.turret_mini;
	
	level.player_tank vehicle_scripts\_m1a1_player_control::tank_unmount_player();
//	level.player_tank stop_turret_attack_think_hamburg();
	pause_all_tanks();
	level.player Unlink();
	
	exploder( "behind_bus_fire" );
	
	blackout_aimer = getstruct( "blackout_aimer", "targetname" );
	
	level.player_tank SetTurretTargetVec( blackout_aimer.origin );
	
	level.player DisableWeapons();
	
	ais = array_combine( get_force_color_guys( "allies", "r" ), get_force_color_guys( "allies", "o" ) );
	structs = getstructarray_delete( "teliport_friends_after_tank_smash", "targetname" );
	teleport_ai_toarray( ais, structs );
	retriet_from_helis_color_trigger = GetEnt( "retriet_from_helis_color_trigger", "script_noteworthy" );
	retriet_from_helis_color_trigger_target = GetEnt( retriet_from_helis_color_trigger.target, "targetname" );
	retriet_from_helis_color_trigger notify ( "trigger" );
	
	thread play_sound_in_space( "exp_armor_vehicle", level.player_tank.origin );
	
	player_rig = spawn_anim_model( "player_rig" );
	
	fast_forward_time = 0.47;

	guys = [];
	guys[ "player" ] = player_rig;
	guys[ "turret" ] = minigun;

	intermediate = spawn_tag_origin();
	
	offset = ( 10, 2, 0 );
	intermediate.origin = level.player_tank GetTagOrigin( "tag_guy0" );
	intermediate.angles = level.player_tank GetTagAngles( "tag_guy0" );
	intermediate LinkTo( level.player_tank, "tag_guy0", offset, ( 0, 0, 0 ) );
	
	player_rig LinkTo( intermediate, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	intermediate anim_teleport( guys, "player_getin", "tag_origin" );
	player_rig Hide();

	
	intermediate thread start_the_recover_anim( guys, "player_getin", "tag_origin" );
	wait 0.05;
	intermediate anim_set_time( guys, "player_getin", fast_forward_time );
	intermediate anim_set_rate( guys, "player_getin", 0 );
	
	level.player allowprone( false );
	level.player AllowCrouch( true );
	level.player AllowStand( false );
	level.player SetStance( "crouch" );
	wait 0.5;
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, -5, 55, 30, 32, false );
	
	level.player delaycall( 0.44, ::PlayerLinkToDelta, player_rig, "tag_player", 1, 25, 15, 30, 32, false );
	level.player LerpFOV( 55, 2.15 );

	wait 0.5;
	
	thread dialog_inside_tank();
	thread player_tank_reloads_while_in_shock();
	level.player_tank.regen_rate_override = 0.5;
	
	delaythread( 0.5, ::autosave_by_name, "blackout" );
	wait 1;
	level.player LerpFOV( 55, 2 );

	thread 	maps\_utility::vision_set_fog_changes( "hamburg", 2 );
	
//	level.black_overlay FadeOverTime( 1.0 );
//	level.black_overlay.alpha = 0;
	
	
	player_rig Hide();
	wait 0.4;
	
	wait 1;
	spawn_vehicle_from_targetname_and_drive( "event3_tank_three" );
	wait 2;
	thread event3_ai();
	wait 1;
	
	player_rig delayCall( 1.2, ::Show );

	minigun delayThread( 0.2, ::lerp_out_drop_pitch, 1.5 );
	level.player AllowStand( true );
	level.player SetStance( "stand" );
	level.player AllowCrouch( false );
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.4, 0.2, 0.2 );

	intermediate anim_set_rate( guys, "player_getin", 1 );
	retriet_from_helis_color_trigger_target notify ( "trigger" );
	set_ambient( "hamburg_tankgun_city" );

	a = spawn_vehicle_from_targetname_and_drive( "apaches_take_out_enemy_1" );
	
	a delayCall( 1, ::SetHoverParams, 50, 20, 10 );
	a delayThread( 2, ::heli_attacks_all_enemies );
	
	add_cleanup_ent( a, "pre_garage_vehicles" );
	
	a = spawn_vehicle_from_targetname_and_drive( "apaches_take_out_enemy_2" );
	a delayThread( 2, ::heli_attacks_all_enemies );
	a delayCall( 1, ::SetHoverParams, 50, 20, 10 );
	add_cleanup_ent( a, "pre_garage_vehicles" );
	
	delaythread(2, ::heli_dukes_it_out_with, "event1_forward_heli_one", [ "heli_chase_two", "heli_chase_one" ], false );
	delaythread(2, ::heli_dukes_it_out_with, "apaches_take_out_enemy_1", [ "heli_chase_two", "heli_chase_one" ], false );
	delaythread(2, ::heli_dukes_it_out_with, "apaches_take_out_enemy_2", [ "heli_chase_one", "heli_chase_two" ], false );
	delaythread(2, ::heli_dukes_it_out_with, "heli_chase_two", [ "apaches_take_out_enemy_1", "apaches_take_out_enemy_2", "event1_forward_heli_one" ], false );
	delaythread(2, ::heli_dukes_it_out_with, "heli_chase_one", [ "apaches_take_out_enemy_2", "apaches_take_out_enemy_1", "event1_forward_heli_one" ], false );
	
	level.player_tank delaythread( 1.2, ::turn_off_the_tanks_lights ); 
	
	level waittill ( "finished_recover_anim" );
	
	level.player_tank.regen_rate_override = undefined;
	
	player_rig Delete();
	
	level.player.stayinvulnerable = false; // resume player protection hacks
	level.player DisableInvulnerability();
	level.player EnableUsability();
	
	put_player_on_tank();
	
	level.player_tank thread maps\hamburg_tank_ai::turret_attack_think_hamburg();
	level.hero_tank thread maps\hamburg_tank_ai::turret_attack_think_hamburg();
	
	level.player_tank ent_flag_clear( "stunned_tank" );
	level.hero_tank ent_flag_clear( "stunned_tank" );

	unpause_all_tanks();

}

dialog_inside_tank()
{
	//Rhino 1: Everyone OK?!
	radio_dialog_add_and_go( "tank_rh1_everyoneok" );
	//Rhino 1: Talk to me, Two Two!
	radio_dialog_add_and_go( "tank_rh1_talktome" );
	//Rhino 2: We're good!
	radio_dialog_add_and_go( "tank_rh2_weregood" );
	//Rhino 1: Alright, let's roll!
	radio_dialog_add_and_go( "tank_rh1_alrightletsroll" );
}

player_tank_reloads_while_in_shock()
{
	wait 0.5;
	level.player_tank FireWeapon();
	level.player_tank vehicle_ai_event( "turret_fire" );
}

start_the_recover_anim( guys, anime, tag )
{
	self anim_single( guys, anime, tag );
	level notify ( "finished_recover_anim" );
}

event3_ai()
{
	axis_ai = array_spawn_targetname( "event3_encounter1_floodspawners", true );
	array_thread( axis_ai, ::set_ignoreall, true );
	array_thread( axis_ai, ::set_ignoreme, true );
	array_thread( axis_ai, ::delaythread, 6.5, ::set_ignoreall, false );
	array_thread( axis_ai, ::delaythread, 6.5, ::set_ignoreme, false );
}

ride_in_dialogue()
{
	thread landing_enableweapon();
	flag_wait( "introscreen_complete" );
	wait 4.4;
	
	//Blackhawk Pilot 1: This is Helix Two Three.  We're one minute out.
	radio_dialog_add_and_go( "tank_bhp1_1minuteout" );
	//HQ Radio: Copy that, Two Three.
	radio_dialog_add_and_go( "tank_hq_copythat" );
	
	flag_wait( "helix_three_two_hit" );
	//HQ Radio: Helix Three Two is hit.  He's goin' down.
	radio_dialog_add_and_go( "tank_hq_hesgoindown" );
	//Blackhawk Pilot 1: Stay with it!
	radio_dialog_add_and_go( "tank_bhp1_staywithit" );
	
	//HQ Radio: Send in a SAR bird and get an MH-6 on site - check for survivors.
	radio_dialog_add_and_go( "tank_hq_sarbird" );

	//HQ Radio: Helix Three Three, recommend you change your approach - East side of the LZ.  Minimize your signature.
	radio_dialog_add_and_go( "tank_hq_yoursignature" );

	//Blackhawk Pilot 3: Copy that.  Three three movin'.
	radio_dialog_add_and_go( "tank_bhp3_movin" );

	//Apache Pilot 1: Mizer One is inbound.
	radio_dialog_add_and_go( "tank_app1_mizerone" );
	//Apache Pilot 2: Roger.  Adjusting heading West for run-in.
	radio_dialog_add_and_go( "tank_app2_adjustheading" );
	//Apache Pilot 1: Copy.  We're cleared hot.
	radio_dialog_add_and_go( "tank_app1_clearedhot" );
//	wait 1;
	
	//radio_dialog_add_and_go( "tank_op1_eta30sec" );
	
	
	//F-16 Pilot 2: Nice hit.  Good secondaries.
	//radio_dialog_add_and_go( "tank_fp2_nicehit" );

	//LCAC Driver 1: Slider Three One approaching staging area.
	radio_dialog_add_and_go( "tank_lcd1_stagingarea" );
	//LCAC Driver 2: Three Two on the deck.  Droppin' off Rhinos.
	radio_dialog_add_and_go( "tank_lcd2_ondeck" );
	//LCAC Driver 1: Slider Three One approaching staging area.
	radio_dialog_add_and_go( "tank_lcd1_stagingarea" );
	
	flag_wait( "over_hovercrafts" );
	
	//Sandman: The convoy never made it to the extraction point.
	radio_dialog_add_and_go( "hamburg_snd_nevermadeit" );
	//Sandman: Let's find it and get these guys home.
	radio_dialog_add_and_go( "hamburg_snd_guyshome" );
	
	//Grinch: We're already on foot.  Good hunting.
	//radio_dialog_add_and_go( "hamburg_rno_goodhuntin" );
	//Sandman: Likewise.  We'll catch you on the other side.
	//radio_dialog_add_and_go( "hamburg_snd_likewise" );
	
	//Rhino 1: Rhino One One, rollin' out.
	radio_dialog_add_and_go( "tank_rh1_rollinout" );	
	//Rhino 2: Rhino Two movin' up.
	radio_dialog_add_and_go( "tank_rh2_rh2movin" );	
	//Rhino 3: This is Rhino Three, we're movin.
	radio_dialog_add_and_go( "tank_rh3_weremovin" );	
	
	flag_wait( "player_unloaded" );
	
	wait 0.05;
	thread autosave_by_name( "player_unloaded" );

}

landing_enableweapon()
{
	flag_wait( "over_hovercrafts" );

	delaythread( 0.1, ::autosave_by_name, "pre_landing_autosave" );
	level.player EnableWeapons();
}

get_hangout_heli( hangout_struct_targetname, override_targetname )
{
	if ( !IsDefined( override_targetname ) )
		override_targetname = "event1_forward_heli_one";
		
	heli = get_vehicle( override_targetname , "targetname" );
	if ( !IsDefined( heli ) )
		heli = spawn_vehicle_from_targetname( override_targetname );
	struct_org = getstruct( hangout_struct_targetname, "targetname" );

	if ( !IsDefined( struct_org.angles ) )
	{
		//doh! over optimization I need to point these better.
		struct_org.angles = ( 0, 90, 0 );
	}
	
	if( is_after_start( "ride_in" ) )
		heli Vehicle_Teleport( struct_org.origin + ( 0, 0, -32 ),  struct_org.angles );
		
	heli SetVehGoalPos( struct_org.origin, 1 );
	
	if ( IsDefined( struct_org.angles ) )
		heli SetTargetYaw( struct_org.angles[ 1 ] );
		
	return heli;
}

get_default_missile_chain_array( missile_override )
{
	array = [];
	if( self.vehicletype == "apache" )
		waits = [ 0.1, 0.1, 0.1, 0.1, 0.1, 0.1 ];
	else
		waits = [ 0.2, 0.3, 0.2 ];


	for ( i = 0; i < waits.size; i++ )
	{
		struct = SpawnStruct();
		struct.waittime = waits[ i ];
		
		if( isdefined( missile_override ) )
			struct.missile = missile_override;
		else if ( self.vehicletype == "apache" )
			struct.missile = "apache_zippy";
		else
			struct.missile = "mi28_zippy";
		array[ i ] = struct;
		
	}
	return array;
}

missile_chain( missile_chain_targetname, yaw, endon_flag, missile_override, missile_array  )
{
	self ClearTargetYaw();
	self endon ("death" );
	self notify ( "new_missile_chain" );
	self endon ( "new_missile_chain" );
	
	if ( IsDefined( endon_flag ) )
	{
		if ( flag( endon_flag ) )
			return;
		self endon ( endon_flag );
	}
	
	if ( !IsDefined( missile_array ) )
	{
		missile_array = get_default_missile_chain_array( missile_override );
	}


	while ( IsDefined( missile_chain_targetname ) )
	{
		target = spawn_tag_origin();
		target thread missile_chain_clean( self );
		struct = getstruct( missile_chain_targetname, "targetname" );
		target.origin = struct.origin;
		self SetLookAtEnt( target );
		waittill_yawed_to_target( target, yaw );
		wait 0.5;
		target.origin += ( 0, 0, -150 );
		target MoveTo( target.origin + ( 0, 0, 150 ), 0.7, 0, 0 );
		foreach ( missile_struct in missile_array )
		{
			if ( IsDefined( level.only_one_heli_fire ) )
			{
				while ( IsDefined( level.only_one_heli_fire ) && level.only_one_heli_fire )
				{
					wait( 0.05 );
				}

				//level.only_one_heli_fire = true;
				maps\_helicopter_globals::fire_missile( missilE_struct.missile, 1, target, undefined );
				//level thread reset_only_one_heli_fire();
			}
			else
			{
				maps\_helicopter_globals::fire_missile( missile_struct.missile, 1, target, undefined );
			}

			wait missile_struct.waittime;
		}
		missile_chain_targetname = struct.target;
		target Delete();
	}
	self ClearLookAtEnt();
}

waittill_yawed_to_target( target, yaw )
{
	if ( !IsDefined( yaw ) )
		yaw = 5;
	target endon ( "death" );
	while( true )
	{
		targetyaw = VectorToYaw( target.origin - self.origin );
		targetyaw = AngleClamp180( targetyaw );
		self_yaw = AngleClamp180( self.angles[ 1 ] );
		yaw_diff =  targetyaw - self_yaw;
		if ( abs( yaw_diff ) < yaw )
			return;
		wait 0.05;
	}
	
}

missile_chain_clean( vehicle )
{
	self endon ( "death" );
	vehicle waittill ( "new_missile_chain" );
	self delete();
}

put_sandman_on_heli()
{
	get_sandman();
	level.sandman.script_startingposition = 2;
	guy_enter_vehicle( level.sandman );
}

lerp_out_sunsample( time, start, dest )
{
	blend = self create_blend( ::blend_sm_sunsamplesizenear, start, dest );
	blend.time = time;
}

blend_sm_sunsamplesizenear( progress, start, end )
{
	val = start * ( 1 - progress ) + end * progress;
	SetSavedDvar( "sm_sunsamplesizenear", val );
}

do_on_foot_start( start )
{
//	vehicle_scripts\_m1a1_player_control::init_tankcommander_code( level.players_tank, false );
	maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
	if ( !IsDefined( start ) )
	{
		start = get_on_foot_start_struct();
	}

	friendly_positions = getstructarray_delete( start.target, "targetname" );
	spawner = GetEnt( "start_on_foot_guy", "targetname" );
	
	teleport_player( start );
	
	real_friends = [];
	for ( i = 0; i < friendly_positions.size; i++ )
	{
		if ( do_on_foot_start_heli_tele( friendly_positions[i] ) )
			continue;
		real_friends[ real_friends.size ] = friendly_positions[ i ];	
	}
	
	friendly_positions = real_friends;
	
	for ( i = 0; i < friendly_positions.size; i++ )
	{
		friend = spawner;
		if( i == 0 )
			friend = GetEnt( "sandman_spawner", "targetname" );
		friend.origin = drop_to_ground( friendly_positions[ i ].origin, 32 );
			
		if( IsDefined( friendly_positions[ i ].angles ) )
			friend.angles = friendly_positions[ i ].angles;

		friend on_foot_start_spawn_ai( true, friendly_positions[ i ] );
		wait 0.05;
	}
	
	thread on_foot_start_vehicles( start );
}

on_foot_start_vehicles( start )
{
	waittillframeend; // let hamburg_code do vehicle spawn after _load.
	friend_vehicle_nodes = GetVehicleNodeArray( start.target, "targetname" );
	
	foreach( node in friend_vehicle_nodes )
	{
		tank = undefined;
		switch( node.script_noteworthy )
		{
			case "h":
				tank = level.hero_tank;
				break;
			case "p":
				tank = level.player_tank;
				break;
			case "g":
				tank = level.glory_tank;
				break;
			default:
				Assert();
				break;
		}
		tank thread do_path_section( node.target, true );
	}
	
}

on_foot_start_spawn_ai( forcespawn, friendly_position )
{
	self.count++;
	friend = spawn_ai( true );
	if ( IsDefined( friendly_position.script_forceColor ) )
		friend set_force_color( friendly_position.script_forceColor );
}

do_on_foot_start_heli_tele( struct )
{
	if( !IsDefined( struct.script_noteworthy ) )
		return false;
	if( struct.script_noteworthy != "heli_spawn_move_here" )
		return false;
		
	spawner = getvehiclespawner( struct.target );
	Assert( IsSpawner( spawner ) );
	
	spawner.origin = struct.origin;
	spawner.angles = struct.angles;
	spawner.target = undefined;
	vehicle = vehicle_spawn( spawner );
	return true;
}

move_hangout_helithink()
{
	Assert( IsDefined( self.target ) );
	self waittill ( "trigger" );
	heli = get_hangout_heli( self.target, self.script_noteworthy );
	heli Vehicle_TurnEngineOn();
	heli heli_attacks_all_enemies();
	if ( IsDefined( self ) )
		self delete();
}

catchup_allies_helper_think()
{
	self waittill( "trigger" );
	ais= GetAIArray( "allies" );
	level.hero_tank.script_badplace = false;
	level.player_tank.script_badplace = false;
	array_thread( ais , ::enable_sprint );
	array_thread( ais, ::delaythread, 25, ::disable_sprint );
	ais = GetAIArray( "axis" );
	array_thread( ais, ::delaycall, RandomFloatRange( 0, 2 ), ::Kill );
}

turn_badplace_backon()
{
	self.script_badplace = true;
}


