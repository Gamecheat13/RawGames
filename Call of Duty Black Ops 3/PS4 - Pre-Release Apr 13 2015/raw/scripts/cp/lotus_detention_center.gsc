#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\ai\robot_phalanx;

#using scripts\cp\_dialog;
#using scripts\cp\_elevator;
#using scripts\cp\_objectives;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\lotus_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	           	              	           	                                                                                                                                                                                                                                                                                             

#precache( "objective", "cp_level_lotus_to_detention_center" );
#precache( "objective", "cp_level_lotus_find_prometheus" );




/////////////////////////////////////////////////////////////////////////////////////////////////
// SKIPTO: vtol_hallway
/////////////////////////////////////////////////////////////////////////////////////////////////
function vtol_hallway_main( str_objective, b_starting )
{
	spawner::add_spawn_function_group( "zipline_guy", "script_noteworthy", &zipline_guy_spawn_func );
	spawner::add_spawn_function_group( "vtol_hallway_near_spawns", "targetname", &vtol_hallway_near_spawns_func );
	vehicle::add_spawn_function( "detention_center_vtol_shooter", &vtol_shooting_spawn_func );
	
	if ( b_starting )
	{
		level flag::wait_till( "all_players_spawned" );
		level.ai_hendricks = util::get_hero( "hendricks" );
		
		//re-setup security station battle
		scene::skipto_end( "p7_fxanim_cp_lotus_security_station_door_bundle" );
		scene::skipto_end( "p7_fxanim_cp_lotus_monitor_security_bundle" );
		scene::skipto_end_noai( "cin_lot_04_09_security_1st_kickgrate" );
		scene::skipto_end_noai( "cin_lot_04_09_security_vign_flee" );
		e_blocker = GetEnt( "reverse_breach_coll", "targetname" );
		e_blocker Delete();		
		
		skipto::teleport_ai( str_objective );
	}
	
	level thread vtol_hallway_objectives( b_starting );
	
	t_vtol_hallway_door = GetEnt( "vtol_hallway_open_door", "targetname" );
	t_vtol_hallway_door TriggerEnable( false );
	scene::add_scene_func( "cin_lot_07_02_detcenter_vign_hendrickskick_run", &set_hendricks_in_position_by_door, "done" );
	
	level thread scene::play( "to_detention_center1_initial_bodies", "targetname" );
	
	// this scene plays the hacking_loop scene after it finishes
	level.ai_hendricks thread scene::play( "cin_lot_07_02_detcenter_vign_hendrickskick_run" );
	
	trigger::wait_till( "vtol_hallway_starting_scene" ); // at least one player must enter the viewing-room before we play the vista scene	
	exploder::exploder( "fx_vista_read1a" );
	
	trigger::wait_till( "vtol_hallway_open_door" );
	spawn_manager::enable( "sm_vtol_hallway_distant_spawns" ); // spawn these dudes just before the door opens, so we see them run into place
	spawn_manager::enable( "sm_vtol_hallway_near_spawns" ); // set of enemies near the player, that the Egyptian Army soldiers slide in and attack
	spawn_manager::enable( "sm_vtol_hallway_innocent_runners" ); // civs running away from sm_vtol_hallway_near_spawns
	level thread vtol_zipline(); // start the vtol zipline event slightly before the door opens, so they slide into view right after
	
	level.ai_hendricks thread scene::play( "cin_lot_07_02_detcenter_vign_hendrickskick_fight" );
	trigger::use( "hendricks_start_vtol_hallway_color_trigger" );
	
	wait 1;	// pause to match Hendricks' anim
	// open the door to the VTOL hallway
	mdl_door_left = GetEnt( "vtol_hallway_door_left", "targetname" );
	mdl_door_right = GetEnt( "vtol_hallway_door_right", "targetname" );
	mdl_door_left MoveY( 100, 1 );
	mdl_door_right MoveY( -100, 1 );	

	//level thread vtol_shooting();
	level thread vtol_defenders_gate();
	
	trigger::wait_till( "vtol_hallway_done" );
	
	// TODO: this notify can probably be deleted because it didn't fix the SRE in the color system reinforcement that occurs in detention_center3
	level notify( "kill_color_replacements" );
	
	skipto::objective_completed( "vtol_hallway" );
}

function vtol_hallway_objectives( b_starting )
{
	if( b_starting )
	{
		objectives::set( "cp_level_lotus_to_detention_center" );
	}
	objectives::breadcrumb( "cp_breadcrumb", "vtol_hallway_obj_breadcrumb" );
	objectives::complete( "cp_breadcrumb" );
}	

function set_hendricks_in_position_by_door()	// called as scene func when cin_lot_07_02_detcenter_vign_hendrickskick_run is done
{
	t_vtol_hallway_door = GetEnt( "vtol_hallway_open_door", "targetname" );
	t_vtol_hallway_door TriggerEnable( true );
}

function vtol_zipline()
{
	level thread vtol_zipline_break_glass();
	level scene::init( "cin_lot_07_02_detcenter_vign_zipline" );
	// wait for notetrack notfy when idle starts AND for player to reach trigger
	level waittill( "zipline_ready" );

	level thread kill_enemies_helper();
	level scene::play( "cin_lot_07_02_detcenter_vign_zipline" );
	trigger::use( "zipline_guys_color_chain_start" );	// y0
	
	e_scene_vtol = GetEnt( "zipline_vtol", "targetname" );
	e_scene_vtol MoveTo( ( -5190, 4038, 6536 ), 8 );
	e_scene_vtol waittill( "movedone" );	// wait for MoveTo to finish
	e_scene_vtol Delete();
}

function vtol_hallway_near_spawns_func()	// self == spawned AI
{
	self SetGoal( GetNode( self.target, "targetname" ), true );	// force spawned guy to go to his targeted exposed node
//	a_targets = GetAIArray( "vtol_hallway_innocent_runners", "targetname" );
//	e_target = array::random( a_targets );
//	self ai::shoot_at_target( "shoot_until_target_dead", e_target );
}

function zipline_guy_spawn_func()	// self == spawned enemy
{
	self util::magic_bullet_shield();
	
	//trigger::wait_till( "zipline_guys_post_up" );
	//s_goto = struct::get( "vtol_hallway_helpers_post_up", "targetname" );
	//self SetGoal( s_goto.origin, true, 128 );
}

function vtol_zipline_break_glass()
{
	s_break = struct::get( "vtol_zipline_break_glass_struct" );
	level waittill( "glass_break_zipline_07_02" ); // notetrack
	GlassRadiusDamage( s_break.origin, 200, 1000, 1000 );
}

function kill_enemies_helper()
{
	wait 2.6;	// allow zipline allies to crash through window before auto-killing enemies
	
	a_zipline_victims = util::get_ai_array( "sm_zipline_victims" );
	while( a_zipline_victims.size )
	{
		e_zipline_victim = array::random( a_zipline_victims );
		e_zipline_victim Kill();
		wait RandomFloatRange( 0.1, 0.2 );
		a_zipline_victims = util::get_ai_array( "sm_zipline_victims" );
	}
}




function vtol_shooting_spawn_func()	// self == VTOL shooting in VTOL hallway
{
	self turret::disable( 0 );	// turn off vtol turret to begin with
	self waittill( "reached_end_node" );

	wait 1; // pause in the air for a beat before shooting
	self turret::enable( 0 );	// turn on vtol turret
	level thread vtol_shooting_thread();
	
	wait 8 / 2;
	// stop spawning new victims at this point
	sm_victims = GetEnt( "sm_vtol_shooting_victims", "targetname" );
	if( IsDefined( sm_victims ) )	// spawn manager might've deleted itself if spawning is finished and all AI were killed?
	{
		spawn_manager::disable( "sm_vtol_shooting_victims" );
	}
	wait 8 / 2;

	self vehicle::get_on_path( "vtol_fly_away_after_shooting" );
	
	level waittill( "vtol_finish_firing_position" );	// keep firing and rake shots across the far ledge, until hitting the "vtol_finish_firing_position" node
	self turret::disable( 0 );	// turn off vtol turret
	
	trigger::use( "post_vtol_ally_moveup" );	// allies move up once VTOL's done firing
}

function vtol_shooting_thread()
{
	level endon( "vtol_stop_shooting" );

	n_times = 8 / 0.4;
	
	for( i = 0; i < n_times; i++ )
	{
		wait 0.4;
		// kill all AI within the VTOL shooting aoe
		a_ai = GetAIArray();
		a_e_vtol_shooting_aoe_victims	= array::filter( a_ai, false, &filter_istouching, "vtol_shooting_aoe" );
		foreach ( ai_victim in a_e_vtol_shooting_aoe_victims )
		{
			if ( IsAlive( ai_victim ) && ai_victim != level.ai_hendricks )
			{
				if ( ( isdefined( ai_victim.magic_bullet_shield ) && ai_victim.magic_bullet_shield ) )
				{
					ai_victim util::stop_magic_bullet_shield();
				}
				
				ai_victim Kill();
				break;	// kill 1 target at a time
			}
		}
	}
}

function filter_istouching( e_entity, str_name )
{
	a_e_volumes = GetEntArray( str_name, "targetname" );
	foreach( e_volume in a_e_volumes )
	{
		if( e_entity IsTouching( e_volume ) )
		{
			return true;
		}
	}

	return false;
}

// spawn defenders for the end of the VTOL hall, move them into position, and close the gate
function vtol_defenders_gate()
{
	e_door = GetEnt( "vtol_hallway_gate01", "targetname" );
	e_door ConnectPaths();
	e_door MoveTo( e_door.origin + ( 0, 0, 128 ), 1, .3, .3 );

	level flag::wait_till( "close_spawn_gate_vtol_hallway" );
	
	e_door MoveTo( e_door.origin - ( 0, 0, 128 ), 1, .3, .3 );
	e_door waittill( "movedone" );
	e_door DisconnectPaths();
}

function vtol_hallway_done( str_objective, b_starting, b_direct, player )
{
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// SKIPTO: mobile_shop_ride2 (mobile shop)
/////////////////////////////////////////////////////////////////////////////////////////////////
function mobile_shop_ride2_main( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		
		skipto::teleport_ai( str_objective );
		
		exploder::exploder( "fx_vista_read1a" );
		
		objectives::set( "cp_level_lotus_to_detention_center" );
	}
	
	// send Hendricks to the correct node depending on the number of players
	// if 1-player, we want Hendricks to join in the fight, so he'll go to his column cover node
	// if 2+ player, we want Hendricks out of the way, so he'll go to his corner (vertical aiming doesn't work on cover nodes, so he won't contribute to the fight)
	players = GetPlayers();
	if( players.size < 2 )
	{
		nd_hendricks_goto = GetNode( "hendricks_mobile_shop_node", "targetname" );
	}
	else
	{
		nd_hendricks_goto = GetNode( "mobile_shop_2_hendricks_hideaway", "targetname" );
	}
	level.ai_hendricks SetGoal( nd_hendricks_goto, true );
	
	// wasps can follow the mobile shop
	a_m_mobile_shop_2 = GetEntArray( "mobile_shop_2", "targetname" ); // have a model and script_brushmodel inside the prefab, so we'll get an array and just use index 0
	foreach ( goal in GetEntArray( "mobile_shop_2_wasp_goals", "script_noteworthy" ) )
	{
		goal LinkTo( a_m_mobile_shop_2[ 0 ] );
	}
	
	remove_gates_for_spawning();
	
	// wait for Hendricks to get into the shop
	trigger::wait_till( "mobile_shop_2_start_trigger", "script_noteworthy", level.ai_hendricks );
	
	// make sure and create the mobile shop object and get it started
	if ( !isdefined( level.o_mobile_shop_2 ) )
	{
		level.o_mobile_shop_2 = new cVehiclePlatform();
		[[ level.o_mobile_shop_2 ]]->init( "mobile_shop_2", "mobile_shop_2_path" );
	}
	
	e_mobile_shop_2_anchor = GetEnt( "mobile_shop_2_anchor", "targetname" );
	e_mobile_shop_2_anchor EnableLinkTo();
	e_mobile_shop_2_anchor LinkTo( a_m_mobile_shop_2[ 0 ] );
	
	level thread enemy_shops();
	
	trigger::wait_till( "mobile_shop_ride2_done" );
	objectives::complete( "cp_breadcrumb" );
	skipto::objective_completed( "mobile_shop_ride2" );
}

function mobile_shop_ride2_done( str_objective, b_starting, b_direct, player )
{

}

function remove_gates_for_spawning()
{
	mdl_gate = GetEnt( "hallway_gate_06", "targetname" );
	mdl_gate ConnectPaths();
	mdl_gate Delete();
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// SKIPTO: bridge_battle (top of mobile shop)
/////////////////////////////////////////////////////////////////////////////////////////////////
function bridge_battle_main( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		
		skipto::teleport_ai( str_objective );
		
		objectives::set( "cp_level_lotus_to_detention_center" );
	}
	
	level thread friendly_sacrifice();
	level thread dc3_close_bridge_gate( true );
	level thread dc3_slide();
	level thread open_police_station( true );
	level thread dc3_rollunder();
	level thread transition_to_dc4();
	
	sp_enemy = GetEnt( "dc4_enemy_sponge", "script_noteworthy" );
	sp_enemy spawner::add_spawn_function( &dc4_enemy_sponge );
	
	level flag::wait_till( "bridge_battle_done" );
	
	skipto::objective_completed( "bridge_battle" );
}

function transition_to_dc4()
{
	a_flags = array( "wall_run_enemies_cleared", "bridge_battle_done" );
	level flag::wait_till_any( a_flags );
	
	level thread hendricks_to_detention_center_wallrun();
}

function friendly_sacrifice()
{
	ai_friendly = spawner::simple_spawn_single( "dc3_friendly_scarifice" );
	util::magic_bullet_shield( ai_friendly );
	
	trigger::wait_till( "trig_friendly_sacrifice" );
	
	nd_sacrifice = GetNode( "scarifice_goal", "targetname" );
	ai_friendly thread ai::force_goal( nd_sacrifice, 64, undefined, undefined, undefined, undefined );
	ai_friendly ai::set_ignoreall( true );
	
	trigger::wait_till( "trig_sacrifice_death" );
	
	ai_friendly ai::set_ignoreall( false );
	util::stop_magic_bullet_shield( ai_friendly );
	
	// grab all enemies to shoot at this one friendly
	a_enemies = GetAITeamArray( "axis" );
	array::thread_all( a_enemies, &ai::shoot_at_target, "kill_within_time", ai_friendly, undefined, 0.05 );
}

function dc3_close_bridge_gate( b_trigger_wait )
{
	if ( ( isdefined( b_trigger_wait ) && b_trigger_wait ) )
	{
		trigger::wait_till( "trig_floor_90_bridge_gate_on" );
	}
	
	mdl_door = GetEnt( "floor_90_bridge_gate_01", "targetname" );
	mdl_door MoveTo( mdl_door.origin + ( 0, 0, -144 ), 1 );
	mdl_door waittill( "movedone" );
	mdl_door DisconnectPaths();
}

function open_police_station( b_trigger_wait )
{
	if ( ( isdefined( b_trigger_wait ) && b_trigger_wait ) )
	{
		trigger::wait_till( "trig_open_police_station" );
		
		wait 0.15; // let the emergency light start spinning before lower the doors
	}
	else
	{
		level thread scene::play( "dc4_emergency_lights", "targetname" );
	}
	
	mdl_door = GetEnt( "police_door_01", "targetname" );
	mdl_door MoveTo( mdl_door.origin + ( 0, 0, -144 ), 3 );
	
	mdl_door = GetEnt( "police_door_02", "targetname" );
	mdl_door MoveTo( mdl_door.origin + ( 0, 0, -144 ), 3 );
	
	if ( ( isdefined( b_trigger_wait ) && b_trigger_wait ) )
	{
		trigger::wait_till( "trig_kill_sniper" );
	
		a_snipers = GetAIArray( "dc3_police_sniper", "script_noteworthy" );
		foreach ( ai_sniper in a_snipers )
		{
			level.ai_hendricks ai::shoot_at_target( "kill_within_time", ai_sniper, undefined, 0.05 );
		}
	}
}

function dc3_rollunder()
{
	trigger::wait_till( "trig_rollunder" );
	
	level thread closing_rollunder_door();
	
	ai_rollunder = spawner::simple_spawn_single( "rollunder_smg" );
	level thread scene::play( "detention_center3_rollunder", "targetname", ai_rollunder );
	
	ai_rollunder ai::force_goal( undefined, undefined, false, undefined, undefined, true );
}

function dc3_slide()
{
	trigger::wait_till( "trig_slide" );
	
	ai_slide = spawner::simple_spawn_single( "slide_smg" );
	level thread scene::play( "detention_center3_slide", "targetname", ai_slide );
	
	ai_slide ai::force_goal( undefined, undefined, false, undefined, undefined, true );
}

function closing_rollunder_door()
{
	mdl_door = GetEnt( "spawn_door7_5_1", "targetname" );
	mdl_door MoveTo( mdl_door.origin + ( 0, 0, -136 ), 6 );
	mdl_door waittill( "movedone" );
	mdl_door DisconnectPaths();
}

function bridge_battle_done( str_objective, b_starting, b_direct, player )
{
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// SKIPTO: up_to_detention_center (Right before actual detention center)
/////////////////////////////////////////////////////////////////////////////////////////////////
function up_to_detention_center_main( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		
		skipto::teleport_ai( str_objective );
		
		objectives::set( "cp_level_lotus_to_detention_center" );
		
		sp_enemy = GetEnt( "dc4_enemy_sponge", "script_noteworthy" );
		sp_enemy spawner::add_spawn_function( &dc4_enemy_sponge );
		
		level thread dc3_close_bridge_gate();
		level thread open_police_station();
		level thread closing_rollunder_door();
		level thread hendricks_to_detention_center_wallrun();
	}
	
	level thread dc4_friendly_sacrifice();
	level thread dc4_fleeing_enemy();
	level thread dc4_jump_out();
	level thread dc4_closing_gate();
	level thread dc4_upper_gate();
	//level thread spawn_corpses( "detention_center" );
	
	trigger::wait_till( "up_to_detention_center_done" );
	skipto::objective_completed( "up_to_detention_center" );
}

function up_to_detention_center_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_lotus_to_detention_center" );
}

function dc4_jump_out()
{
	ai_enemy = spawner::simple_spawn_single( "dc4_jump_out" );
	ai_enemy ai::set_ignoreall( true );
	
	trigger::wait_till( "trig_fleeing_enemy" );
	
	ai_enemy ai::set_ignoreall( false );
	
	nd_jump_out = GetNode( "jump_out_dest", "targetname" );
	ai_enemy ai::force_goal( nd_jump_out, 64 );
}

function hendricks_to_detention_center_wallrun()
{	
	level thread scene::play( "cin_lot_07_05_detcenter_vign_wallrun_hendricks" );
	level.ai_hendricks waittill( "goal" );
	
	t_up_to_detention = GetEnt( "trig_dc4_hendricks", "targetname" );
	if ( IsDefined( t_up_to_detention ) )
	{
		t_up_to_detention trigger::use();
	}
}

// self == enemy AI
function dc4_enemy_sponge()
{
	self.overrideActorDamage = &dc4_enemy_sponge_override;
}

// self == enemy AI
function dc4_enemy_sponge_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, weapon, v_point, v_dir, str_hit_loc, psOffsetTime, boneIndex, n_model_index )
{
	if ( !IsPlayer( e_attacker ) )
	{
		n_damage = 0;
	}
	
	return n_damage;
}

function dc4_friendly_sacrifice()
{

	ai_friendly = spawner::simple_spawn_single( "dc4_friendly_sacrifice" );
	ai_friendly.overrideActorDamage = &dc4_friendly_damage_override;
	
	trigger::wait_till( "trig_dc4_friendly_sacrifice" );

	nd_sacrifice = GetNode( "dc4_sacrifice_goal", "targetname" );

	ai_friendly ai::force_goal( nd_sacrifice, 128 );
	scene::play("cin_lot_07_05_detcenter_vign_rapsdeath");
	ai_rap = GetEnt ("dc4_deadly_rap_ai", "targetname");
	ai_rap DoDamage( ai_rap.health, ai_rap.origin );
	
}

// self == friendly AI who gets killed by rap
function dc4_friendly_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, weapon, v_point, v_dir, str_hit_loc, psOffsetTime, boneIndex, n_model_index )
{
	if ( IsDefined( e_attacker.archetype ) && e_attacker.archetype == "raps" )
	{
		n_damage = 100;
	}
	else
	{
		n_damage = 0;
	}
	
	return n_damage;
}

// self == raps
function rap_proximity_explosion( ai_friendly )
{
	self endon( "death" );
	
	const n_dist_2d_sq_max = 4096;
	
	while ( true )
	{
		if( isdefined(ai_friendly) )
		{
			n_dist_2d_sq = Distance2dSquared( ai_friendly.origin, self.origin );
			if ( n_dist_2d_sq < n_dist_2d_sq_max )
			{
				self DoDamage( self.health, self.origin );
			}
		}
		
		wait 0.05;
	}
}

// self == rap
function rap_damage_override( e_inflictor, e_attacker, n_damage, n_idflags, str_means_of_death, weapon, v_point, v_dir, str_hit_loc, v_damage_origin, n_psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name, v_surface_normal )
{
	if ( IsDefined( str_means_of_death ) && str_means_of_death == "MOD_UNKNOWN" )
	{
		n_damage = n_damage;
	}
	else if ( IsPlayer( e_attacker ) )
	{
		n_damage = n_damage * 0.09;
	}
	else
	{
		n_damage = 0;
	}
	
	return n_damage;
}

function dc4_fleeing_enemy()
{
	trigger::wait_till( "trig_fleeing_enemy" );
	
	ai_enemy = spawner::simple_spawn_single( "dc4_fleeing_enemy" );
	ai_enemy endon( "death" );
	
	nd_fleeing = GetNode( "fleeing_enemy_path", "targetname" );
	ai_enemy ai::force_goal( nd_fleeing, 64, false, undefined, undefined, true );
	
	ai_enemy waittill( "goal" );
	
	nd_fleeing = GetNode( "fleeing_enemy_node", "targetname" );
	ai_enemy ai::force_goal( nd_fleeing, 64, false, undefined, undefined, true );
}

function dc4_closing_gate()
{
	trigger::wait_till( "trig_dc4_door" );
	
	mdl_door = GetEnt( "spawn_door7_5_2", "targetname" );
	mdl_door MoveTo( mdl_door.origin + ( 0, 0, -144 ), 11 );
	mdl_door waittill( "movedone" );
	mdl_door DisconnectPaths();
}

function dc4_upper_gate()
{
	mdl_door = GetEnt( "hosp_hall_gate_10", "targetname" );
	mdl_door MoveTo( mdl_door.origin + ( 0, 0, 145 ), 1 );
	
	trigger::wait_till( "trig_upper_gate" );
	
	mdl_door MoveTo( mdl_door.origin + ( 0, 0, -145 ), 3 );
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// SKIPTO: detention_center (actual detention center)
/////////////////////////////////////////////////////////////////////////////////////////////////
function detention_center_main( str_objective, b_starting )
{	
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		
		skipto::teleport_ai( str_objective );
		
		//level thread spawn_corpses( "detention_center" );
	}
	
	objectives::set( "cp_level_lotus_find_prometheus", struct::get( "align_prometheus_standdown" ) );
	
	spawner::add_spawn_function_group( "dc_upper_spawner", "script_noteworthy", &check_spawn_closet_clear );
	
	// open airlock door
	mdl_door = GetEnt( "det_door_prometheus_01", "targetname" );
	mdl_door MoveTo( mdl_door.origin + ( 0, 0, 90 ), 1, 0.25, 0.25 );
	
	level thread lotus_util::juiced_shotgun_trigger_setup();
	level thread detention_center_fallback( "dc_fallback_0" );
	level thread detention_center_fallback( "dc_fallback_1" );
	level thread detention_center_fallback( "dc_fallback_2" );
	level thread detention_center_force_stairs();
	level thread detention_center_pamws();
	level thread detention_center_phalanx();
	level thread detention_center_spawn_closet_door_close();
	
//  TODO: put back dialog late
//	trigger::wait_till( "detention_center_vo_1" );
//	level.players[0] dialog::say( "kane_looks_like_the_nrc_h_0" );
//	trigger::wait_till( "detention_center_vo_2" );
//	level.players[0] dialog::say( "kane_almost_done_0" );

	trigger::wait_till( "trig_stand_down_start", "targetname", level.ai_hendricks );
	
	// shut airlock door (only do this when progressing from "detention_center", not when loading into "stand_down")
	mdl_door = GetEnt( "det_door_prometheus_01", "targetname" );
	mdl_door MoveTo( mdl_door.origin - ( 0, 0, 90 ), 1, 0.25, 0.25 );
	
	skipto::objective_completed( "detention_center" );
}

// [RY] 04.02.15 Made reusable so we can put corpses in other parts of the level with the same function. Slated for removal once we replace these corpses with non-entity versions.
/*
function spawn_corpses(str_area)
{

	a_drops = struct::get_array( str_area + "_corpse_drop" );
	foreach( s_drop in a_drops )
	{
		//mdl_corpse = spawner::simple_spawn_single( "detention_center_corpse" );
		mdl_corpse = spawner::simple_spawn_single( str_area + "_corpse" );
		
		v_angles = ( 0, RandomInt( 360 ), 0 );
		mdl_corpse ForceTeleport( s_drop.origin, v_angles );
		mdl_corpse StartRagdoll();
		mdl_corpse Kill();
	}
}
*/

function detention_center_fallback( str_trigger )
{
	t_fallback = GetEnt( str_trigger, "targetname" );
	t_fallback waittill( "trigger" );
	
	e_goal_volume = GetEnt( t_fallback.target, "targetname" );
	a_enemies = GetAIArray( "dc_bottom", "script_noteworthy" );
	foreach ( ai_enemy in a_enemies )
	{
		ai_enemy SetGoal( e_goal_volume, true );
	}
}

function detention_center_force_stairs()
{
	trigger::wait_till( "trig_dc_pamws_enemies" );
	
	wait 2; // wait until the enemies move up the stairs before removing the clip
	
	mdl_clip = GetEnt( "dc_stair_2_monster_clip", "targetname" );
	mdl_clip ConnectPaths();
	mdl_clip Delete();
}

function detention_center_pamws()
{
	trigger::wait_till( "trig_dc_pamws" );
	
	mdl_door = GetEnt( "detention_security_door_01", "targetname" );
	mdl_door MoveTo( mdl_door.origin + ( 0, 0, 90 ), 3 );
}

function detention_center_phalanx()
{
	trigger::wait_till( "trig_dc_phalanx" );
	
	v_start = struct::get( "dc_phalanx_wedge_start" ).origin;
	v_end = struct::get( "dc_phalanx_wedge_end" ).origin;
	
	n_phalanx = 3;
	
	if ( level.players.size > 2 )
	{
		n_phalanx = 5;
	}
	
	phalanx_left = new RobotPhalanx();
	[[ phalanx_left ]]->Initialize( "phanalx_wedge", v_start, v_end, 1, n_phalanx );
}

function detention_center_spawn_closet_door_close()
{
	level waittill( "dc_upper_spawn_closet_cleared" );
	
	mdl_door = GetEnt( "det_door_robot_spawn_A", "targetname" );
	mdl_door MoveTo( mdl_door.origin - ( 0, 0, 90 ), 1, 0.25, 0.25 );
}

// self == enemy
function check_spawn_closet_clear()
{
	self endon( "death" );
	
	const n_spawners_in_closet_total = 4; // needs to be updated if more spawners or spawn counts get added
	
	e_volume = GetEnt( "vol_dc_upper_spawn_closet", "targetname" );
	while ( self IsTouching( e_volume ) )
	{
		wait 0.05;
	}
	
	if ( !IsDefined( level.n_spawners_in_closet ) )
	{
		level.n_spawners_in_closet = 1;
	}
	else
	{
		level.n_spawners_in_closet++;
	}
	
	if ( level.n_spawners_in_closet == n_spawners_in_closet_total )
	{
		level notify( "dc_upper_spawn_closet_cleared" );
	}
}

function detention_center_control_panel_guy()
{
	self endon( "death" );
	
	self.goalradius = 16;
	
	self waittill( "goal" );
	
	// play anim here
	wait 1;
	
	// open door
	e_detention_center_robot_door = GetEnt( "detention_security_door_01", "targetname" );
	e_detention_center_robot_door MoveTo( ( e_detention_center_robot_door GetOrigin() ) - ( 0, 0, 128 ), 1.0 );
	e_detention_center_robot_door ConnectPaths();
	
	// spawn robot
	spawn_manager::enable( "sm_detention_center_control_panel_cobra" );
}

function detention_center_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_lotus_find_prometheus" );
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

function init()
{
	vehicle::add_spawn_function( "detention_center_vtol", &detention_center_vtol );
	
	spawner::add_spawn_function_group( "auto_delete", "script_string", &auto_delete );
	spawner::add_spawn_function_group( "enemy_mobile_inside_spawner", "script_noteworthy", &enemy_mobile_spawn_func, "inside" );
	spawner::add_spawn_function_group( "enemy_mobile_goto_roof_spawner", "script_noteworthy", &enemy_mobile_spawn_func, "roof" );	
	spawner::add_spawn_function_group( "mobile_shop_2_rpg_guy", "targetname", &mobile_shop_2_rpg_guy_func );
	
	
	level thread player_shop();
}

function detention_center_vtol()	// self == spawned VTOL
{
	self turret::set_ignore_line_of_sight( true, 0 );
	level.vh_shooting_vtol = self;
}

/#
function debug_kill_trigger()	// self == "kill_trigger"
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "trigger", ent );
	}
}
#/

function player_shop()
{
	LinkTraversal( GetNode( "mobile_shop_2_traversal", "script_noteworthy" ) );
	              
	level thread enable_shop_trigger_when_hendricks_is_touching();
	
	a_mdl_shop = GetEntArray( "mobile_shop_2", "targetname" );
	mdl_hatch = GetEnt( "mobile_shop_hatchdoor", "targetname" );
	mdl_hatch LinkTo( a_mdl_shop[ 0 ] ); // just get anything that's part of the mobile shop, so the hatch moves with it
	veh_shop = GetEnt( "mobile_shop_2_vehicle", "targetname" );
	
	a_dyn_cover = GetEntArray( "mobile_shop_2_dynamic_cover", "targetname" );
	foreach( e_dyn_cover in a_dyn_cover )
	{
		e_dyn_cover thread mobile_shop_2_dynamic_cover_damage_watcher();
	}
	
	level waittill( "vehicle_platform_mobile_shop_2_move" );
	
	[[  level.o_mobile_shop_2 ]]->set_speed( 10, 100 );	
	
	n_saved_goalradius = level.ai_hendricks.goalradius;
	level.ai_hendricks.goalradius = 64;
	
	//link kill trigger to shop
	t_kill = GetEnt( "kill_trigger", "targetname" );
	t_kill EnableLinkTo();
	t_kill LinkTo( a_mdl_shop[ 0 ] );
	t_kill TriggerEnable( true );
	
	/#
	t_kill thread debug_kill_trigger();
	#/
	
	// delete start spawns so only "respawns" are used
	// this will only matter in debug when a player might be
	// in god mode and get closer to the start spawns that
	// the respawns that are in the shop
	skipto::delete_start_spawns( "mobile_shop_ride2" );
	
	UnLinkTraversal( GetNode( "mobile_shop_2_traversal", "script_noteworthy" ) );
	
	level waittill( "vehicle_platform_mobile_shop_2_stop" );
	
	LinkTraversal( GetNode( "mobile_shop_2_traversal2", "script_noteworthy" ) );
	LinkTraversal( GetNode( "mobile_shop_2_traversal3", "script_noteworthy" ) );
	
	self thread fx::play( "mobile_shop_fall_explosion", mdl_hatch.origin, ( 0, 0, 0 )  );
	wait 0.3;	// timing
	self thread fx::play( "mobile_shop_fall_explosion", mdl_hatch.origin - ( 0, 200, 0 ) , ( 0, 0, 0 )  );
	Earthquake( 0.5, 1.3, veh_shop.origin, 1000 );
	
	array::run_all( level.players, &PlayRumbleOnEntity, "damage_heavy" );
	array::run_all( level.players, &PlayRumbleOnEntity, "damage_heavy" );
	array::run_all( level.players, &PlayRumbleOnEntity, "damage_heavy" );
	array::run_all( level.players, &PlayRumbleOnEntity, "damage_heavy" );
	array::run_all( level.players, &PlayRumbleOnEntity, "damage_heavy" );
	array::run_all( level.players, &PlayRumbleOnEntity, "damage_heavy" );
	
	objectives::set( "cp_breadcrumb", struct::get( "mobile_shop_ride2_last_objective" ) );
	
	// TODO: remove this once Hendricks isn't dumb as a rock anymore
	nd_roof_warp = GetNode( "hendricks_bridge_battle_warp_node", "targetname" );
	level.ai_hendricks ForceTeleport( nd_roof_warp.origin, nd_roof_warp.angles );	
	
	mdl_hatch Delete();
	
	level.ai_hendricks.goalradius = n_saved_goalradius;
}

function enable_shop_trigger_when_hendricks_is_touching()
{
	t_shop = GetEnt( "mobile_shop_2_start_trigger", "script_noteworthy" );
	t_shop TriggerEnable( false );
	
	while ( !IsAlive( level.ai_hendricks ) || ( isdefined( t_shop ) && !level.ai_hendricks IsTouching( t_shop ) ) ) // need this check since the trigger is getting cleaned up eventually
	{
		wait .2;
		if( !isdefined( t_shop ) )
		{
			return;
		}
	}
	
	t_shop TriggerEnable( true );
}



function enemy_shops()
{
	level flag::wait_till( "long_mobile_shop_start" );

	level thread enemy_shop( "enemy_mobile5", 10, undefined, 2.0, true, 3.0 ); // 1st shop - moves right & then up with players' shop
	level thread enemy_shop( "enemy_mobile1", 9, "mobile_shop_2_turn_1", 6.6 );// 2nd shop - moves up with players' shop
	level thread enemy_shop( "enemy_mobile3", 10, "mobile_shop_2_turn_2", 6.6 );// 3rd shop - moves up after 1st shop stops
	level thread enemy_shop( "enemy_mobile2", 9.5, "mobile_shop_2_turn_2", 16.0 );// 4th shop - Moves in from left after mobile1 stops
	level thread enemy_shop( "enemy_mobile6", 7.7, "mobile_shop_2_turn_2", 24.8 );// 5th shop - Moves in from left to join mobile2
}

function enemy_shop( str_shop_name, n_shop_speed, str_waittill, n_wait_amount, b_hop_on = false, n_after_spawn_wait_amount = 0 )
{
	o_enemy_shop_platform = new cVehiclePlatform();
	[[  o_enemy_shop_platform ]]->init( str_shop_name, str_shop_name + "_path" );
	vh_enemy_shop = [[ o_enemy_shop_platform ]]->get_platform_vehicle();
	vh_enemy_shop.takedamage = false;
	
	a_hop_on_nodes = GetNodeArray( str_shop_name + "_traversal", "targetname" );
	foreach( nd_traversal in a_hop_on_nodes )
	{
		LinkTraversal( nd_traversal );
	}
	if( b_hop_on )
	{
		a_hop_on_nodes = GetNodeArray( str_shop_name + "_hop_on_traversal", "targetname" );
		foreach( nd_traversal in a_hop_on_nodes )
		{
			LinkTraversal( nd_traversal );
		}
	}
	
	if( IsDefined( str_waittill ) )
	{
		level waittill( str_waittill );
	}
	wait n_wait_amount;	// custom wait time after str_waittill notify is fired

	// guys inside mobile shop
	spawn_manager::enable( "sm_" + str_shop_name + "_inside" );
	spawn_manager::enable( "sm_" + str_shop_name + "_goto_roof" );
	
	wait n_after_spawn_wait_amount;	// custom wait time after enemies are spawned before mobile shop moves
	
	trigger::use( str_shop_name, "target" );	
	[[  o_enemy_shop_platform ]]->set_speed( n_shop_speed, 100 );
	
	if( b_hop_on )
	{
		foreach( nd_traversal in a_hop_on_nodes )
		{
			UnlinkTraversal( nd_traversal );
		}
	}
	
	level waittill( "vehicle_platform_" + str_shop_name + "_stop" );

	// kill any remainging enemies after mobile shop path ends (for now)
	wait 3;
	a_inside_enemies = spawn_manager::get_ai( "sm_" + str_shop_name + "_inside" );
	a_roof_enemies = spawn_manager::get_ai( "sm_" + str_shop_name + "_goto_roof" );
	a_all_shop_enemies = ArrayCombine( a_inside_enemies, a_roof_enemies, false, false );
	a_all_shop_enemies = array::remove_dead( a_all_shop_enemies );
	a_all_shop_enemies = array::remove_undefined( a_all_shop_enemies );
	array::run_all( a_all_shop_enemies, &Kill );
}



// ripped from _skipto but needed some modifications for auto deleting AI in this event
function auto_delete()	// self == spawned from spawner w/ "auto_delete" in script_string KVP
{
	self endon( "death" );
	
	self notify( "__auto_delete__" );
	self endon( "__auto_delete__" );
		
	level flag::wait_till( "all_players_spawned" );
	
	n_test_count = 0;
	
	wait 5; // make sure the guy is alive for at least 10 seconds
	
	while ( true )
	{
		wait randomfloatrange(1-1/3,1+1/3);
		
		n_tests_passed = 0;
					
		foreach ( player in level.players )
		{
			b_in_front = false;
			b_can_see = false;
			
			v_eye = player GetEye();
			v_facing = AnglesToForward( player GetPlayerAngles() );
			
			v_to_ent = VectorNormalize( self.origin - v_eye );
			n_dot = VectorDot( v_facing, v_to_ent );
			
			if ( n_dot > 0.67 )
			{
				b_in_front = true;
			}
			else
			{
				b_can_see = self SightConeTrace( v_eye, player );
			}
			
			if ( !b_can_see && !b_in_front )
			{
				n_tests_passed++;
			}
		}
		
		if ( n_tests_passed == level.players.size )
		{
			n_test_count++;				
			if ( n_test_count < 5 )
			{
				continue;
			}
			
			self notify( "_disable_reinforcement" );
			self Delete();
		}
		else
		{
			n_test_count = 0;
		}
	}
}

function enemy_mobile_spawn_func( str_type )	// self == spawned enemy
{
	self endon( "death" );
	self.goalradius = 64;
	n_dist_thresh = 64 * 64;
	a_nd_goto = GetNodeArray( self.groupname + "_" + str_type + "_node", "targetname" );
	nd_goto = array::random( a_nd_goto );
	self SetGoal( nd_goto );
	
	self DisableAimAssist();
	
	while( true )
	{
		wait( 7 + RandomFloat( 5 ) );
		nd_goto = array::random( a_nd_goto );
		self SetGoal( nd_goto );
	}
}

function mobile_shop_2_rpg_guy_func()
{
	// on spawn, fire rpg at target that gives a good view of the smoke trail to players in the store
	s_target = struct::get( "mobile_shop_2_rpg_guy_target", "targetname" );
	e_target = util::spawn_model( "tag_origin", s_target.origin, s_target.angles );
	self ai::shoot_at_target( "normal", e_target );
}

function mobile_shop_2_dynamic_cover_damage_watcher()
{
	veh_shop = GetEnt( "mobile_shop_2_vehicle", "targetname" );
	self LinkTo( veh_shop );
		
	self SetCanDamage( true );
	self.health = 100;
	
	self waittill( "death" );
	self Hide();
}
