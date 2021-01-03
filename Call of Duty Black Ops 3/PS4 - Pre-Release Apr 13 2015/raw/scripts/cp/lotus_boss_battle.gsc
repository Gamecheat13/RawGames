#using scripts\codescripts\struct;

#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_vehicle_platform;
#using scripts\cp\lotus_util;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       



	
// if the numbering for these changes, please update the script_int in Radiant also




	
#precache( "objective", "cp_level_lotus_minigun" );
#precache( "string", "tag_target_fan_right_outer" );
#precache( "string", "tag_target_fan_right_inner" );
#precache( "string", "tag_target_fan_left_inner" );
#precache( "string", "tag_target_fan_left_outer" );

//*****************************************************************************
// PROMETHEUS INTRO
//*****************************************************************************
function prometheus_intro_main( str_objective, b_starting )
{
	level flag::wait_till( "all_players_spawned" );
	
	foreach ( players in level.players )
	{
		players util::freeze_player_controls( true );
	}
	
	level scene::play( "cin_lot_15_prometheusintro_3rd_pre100" );
	
	foreach ( players in level.players )
	{
		players util::freeze_player_controls( false );
	}
	
	skipto::objective_completed( "prometheus_intro" );
}

function prometheus_intro_done( str_objective, b_starting, b_direct, player )
{
}

//*****************************************************************************
// OLD FRIEND
//*****************************************************************************
function old_friend_main( str_objective, b_starting )
{
	level flag::wait_till( "all_players_spawned" );
	
	foreach ( players in level.players )
	{
		players util::freeze_player_controls( true );
	}
	
	level scene::play( "cin_lot_17_oldfriend_3rd_pre200" );
	
	skipto::objective_completed( "old_friend" );
}

function old_friend_done( str_objective, b_starting, b_direct, player )
{
}

//*****************************************************************************
// BOSS BATTLE
//*****************************************************************************
function boss_battle_main( str_objective, b_starting )
{
	if ( !b_starting )
	{
		skipto::teleport( str_objective );
	}
	
	AllowOneHitProjectileKills( true );
	boss_battle_inits();
	
	setup_boss_mobile_shop();
	
	//grab the player hunters and do some initialization
	init_player_hunters();
	
	str_armory = "ms_r4";
	level thread call_first_armory( str_armory );
	level thread mobile_shop_logic();
	
	vh_gunship = vehicle::simple_spawn_single( "gunship" );
	vh_gunship thread gunship_logic();
//	vh_gunship thread debug_gunship();
	
//	mdl_gunship = util::spawn_model( "veh_t7_mil_gunship_dest", ( 0, 0, 33408 ) );
//	mdl_gunship clientfield::set( "weakpoint", 1 );
	
	exploder::exploder( "fx_boss_battle_ambients" );
	
	level thread destructible_cover();
	
	level waittill( "gunship_almost_dead" );
	skipto::objective_completed( "boss_battle" );
}

function boss_battle_inits()
{
	level flag::init( "call_next_mobile_shop" );
	level flag::init( "call_next_mobile_armory" );
	level flag::init( "gunship_in_transition" );
	
	level.n_times_without_reward = 0;
}

//*****************************************************************************
// DESTRUCTIBLE COVER
//*****************************************************************************
function destructible_cover()
{
	a_destructible_pieces = GetEntArray( "roof_shed_piece", "targetname" );
	
	foreach ( mdl_destructible_piece in a_destructible_pieces )
	{
		mdl_destructible_piece thread lotus_util::destructible_watch();
	}
}


//*****************************************************************************
// PLAYER HUNTERS
//*****************************************************************************

function init_player_hunters()
{
	player_hunters = GetEntArray( "boss_player_hunter" , "targetname" );
	
	//increase the range that the player-driven hunters can fly
	SetDvar( "scr_security_breach_lost_contact_distance", 15000 );
	SetDvar( "scr_security_breach_lose_contact_distance", 7000 );
	
	foreach ( hunter in player_hunters )
	{
		hunter.team = level.players[0].team;
		
		hunter ai::set_ignoreme( true );
		
		hunter thread reactivate_after_hijack();
	}
}

// self = hunter
function reactivate_after_hijack()
{
	self endon( "death" );
	
	do
	{
		self waittill( "change_state" );
	} while( self vehicle_ai::get_current_state() != "driving" );
	
	self ai::set_ignoreme( false );
}

//*****************************************************************************
// MOBILE SHOP/ARMORY
//*****************************************************************************
function setup_boss_mobile_shop()
{
	level.a_ms_info = [];
	setup_boss_mobile_shop_info( "ms_l1", 0 );
	setup_boss_mobile_shop_info( "ms_l2", 1 );
	setup_boss_mobile_shop_info( "ms_l3", 5 );
	setup_boss_mobile_shop_info( "ms_l4", 3 );
	setup_boss_mobile_shop_info( "ms_r1", 3 );
	setup_boss_mobile_shop_info( "ms_r2", 2 );
	setup_boss_mobile_shop_info( "ms_r3", 4 );
	setup_boss_mobile_shop_info( "ms_r4", 0 );
	
	level.a_o_mobile_platform = [];
	level.a_mobile_shops = [];
	setup_moving_platform( "ms_l1" );
	setup_moving_platform( "ms_l2" );
	setup_moving_platform( "ms_l3" );
	setup_moving_platform( "ms_l4" );
	setup_moving_platform( "ms_r1" );
	setup_moving_platform( "ms_r2" );
	setup_moving_platform( "ms_r3" );
	setup_moving_platform( "ms_r4" );
	
	a_raps_slow = GetEntArray( "raps_slow", "targetname" );
	foreach ( t_raps_slow in a_raps_slow )
	{
		t_raps_slow TriggerEnable( false );
	}
}

function setup_moving_platform( str_name )
{
	level.a_mobile_shops[ str_name ] = lotus_util::mobile_shop_setup( str_name + "_group", true, false, true, undefined, true );
	
	o_mobile_shop = new cVehiclePlatform();
	[[ o_mobile_shop ]]->init( str_name, str_name + "_start_up" );
	level.a_o_mobile_platform[ str_name ] = o_mobile_shop;
}

function setup_boss_mobile_shop_info( str_name, n_gunship_index, str_location )
{
	level.a_ms_info[ str_name ] = SpawnStruct();
	level.a_ms_info[ str_name ].b_was_normal = false;
	level.a_ms_info[ str_name ].b_was_armory = false;
	level.a_ms_info[ str_name ].n_gunship_index = n_gunship_index;
		
	s_ms_end = struct::get( str_name + "_1", "targetname" );
	level.a_ms_info[ str_name ].v_origin = s_ms_end.origin;
}

function call_first_armory( str_armory )
{
	level thread move_mobile_shop( str_armory, "minigun" );
}

// self == gunship
function gunship_first_missile_target()
{
	self.e_override_missile_target = GetEnt( "gunship_first_missile_target", "targetname" );
	
	mdl_weapon_clip = GetEnt( "bb_start_weapon_clip", "targetname" );
	mdl_weapon_clip SetCanDamage( true );
	mdl_weapon_clip.health = 10000;
	mdl_weapon_clip endon( "death" );
	
	while ( true )
	{
		mdl_weapon_clip waittill( "damage", n_damage, e_attacker, v_vector, v_point, str_means_of_death, str_string_1, str_string_2, str_string_3, w_weapon );
		
		// can only be blown up by missiles or raps
		if ( e_attacker.vehicletype === "veh_bo3_mil_gunship_nrc" && ( str_means_of_death == "MOD_PROJECTILE" || str_means_of_death == "MOD_PROJECTILE_SPLASH" ) )
		{
			self.e_override_missile_target Delete();
			self.e_override_missile_target = undefined;
			mdl_weapon_clip Delete();
		}
		
		mdl_weapon_clip.health = 10000;
		
		wait 0.05;
	}
}

function mobile_shop_logic()
{
	const n_dist_sq_max = 1048576; // 1024 * 1024
	const n_possibility = 2;
	
	while ( true )
	{
		level flag::wait_till( "call_next_mobile_shop" );
		
		level flag::clear( "call_next_mobile_shop" );
		
		a_ms_possible = [];
		a_ms_reference = [];
		while ( a_ms_possible.size == 0 )
		{
			foreach ( str_name, s_ms_info in level.a_ms_info )
			{
				// find mobile shops that have not been used yet
				if ( !IsDefined( s_ms_info.str_state ) && !s_ms_info.b_was_normal )
				{
					n_dist_sq = Distance2DSquared( s_ms_info.v_origin, level.s_mobile_shop.v_origin );
					a_ms_possible[ a_ms_possible.size ] = n_dist_sq;
					a_ms_reference[ str_name ] = n_dist_sq;
				}
			}
			
			if ( a_ms_possible.size == 0 )
			{
				// all mobile shops have already been used once, so reset
				foreach ( str_name, s_ms_info in level.a_ms_info )
				{
					level.a_ms_info[ str_name ].b_was_normal = false;
				}
			}
		}
		
		if ( a_ms_possible.size > 1 )
		{
			// sort the mobile shop distance from furthest to closest
			a_ms_possible_sorted = array::sort_by_value( a_ms_possible );
		}
		
		// narrow the number of mobie shop that we will be checking against later
		if ( a_ms_possible.size > n_possibility )
		{
			n_possible_armory = 0;
			a_ms_possible = [];
			
			// find the furthest mobile shop that in the given range
			foreach ( n_dist_sq in a_ms_possible_sorted )
			{
				if ( n_dist_sq <= n_dist_sq_max )
				{
					a_ms_possible[ n_possible_armory ] = n_dist_sq;
					n_possible_armory++;
					if ( n_possible_armory == n_possibility )
					{
						break;
					}
				}
			}
		}
		
		if ( a_ms_possible.size == 0 )
		{
			n_possible_armory = 0;
			
			// sort the mobile shop distance from closest to furthest
			a_ms_possible_reversed = array::reverse( a_ms_possible_sorted );
			foreach ( n_dist_sq in a_ms_possible_reversed )
			{
				a_ms_possible[ n_possible_armory ] = n_dist_sq;
				n_possible_armory++;
				if ( n_possible_armory == n_possibility )
				{
					break;
				}
			}
		}
		
		for ( i = 0; i < a_ms_possible.size; i ++ )
		{
			// find the correct mobile shop name from the sorted list
			foreach ( str_name, n_dist_ref in a_ms_reference )
			{
				if ( a_ms_possible[i] == n_dist_ref )
				{
					a_ms_possible[i] = str_name;
					break;
				}
			}
		}
		
		a_closest_dist_sq_info = [];
		for ( i = 0; i < a_ms_possible.size; i++ )
		{
			a_closest_dist_sq_info[i] = find_mobile_shop_distance_closest_to_a_player( a_ms_possible[i] );
		}
		
		str_name_farthest = a_closest_dist_sq_info[0].str_name;
		n_dist_sq_farthest = a_closest_dist_sq_info[0].n_dist_sq;
		for ( i = 1; i < a_closest_dist_sq_info.size; i++ )
		{
			// pick the mobile shop that has the longest distance
			if ( a_closest_dist_sq_info[i].n_dist_sq > n_dist_sq_farthest )
			{
				str_name_farthest = a_closest_dist_sq_info[i].str_name;
				n_dist_sq_farthest = a_closest_dist_sq_info[i].n_dist_sq;
			}
		}

		str_armory_type = mobile_armory_type();
		level thread move_mobile_shop( str_name_farthest, str_armory_type );
		
		wait 0.05;
	}
}

function move_mobile_shop( str_name, str_armory_type )
{
	level.a_ms_info[ str_name ].str_state = "normal";
	level.a_ms_info[ str_name ].b_was_normal = true;
	level.s_mobile_shop = level.a_ms_info[ str_name ];
	
	str_groupname = str_name + "_group";
	
	b_armory = false;
	if ( str_armory_type == "minigun" )
	{
		b_armory = true;
	}
	
	e_mobile_shop = level.a_mobile_shops[ str_name ];
	if ( str_armory_type == "minigun" )
	{
		foreach ( e_minigun_auto in e_mobile_shop.a_miniguns )
		{
			t_minigun_auto = e_minigun_auto lotus_util::minigun_usable( true, true );
			t_minigun_auto LinkTo( e_mobile_shop );
		}
	}
	else
	{
		foreach ( e_weapon in e_mobile_shop.a_weapons )
		{
			t_weapon = e_weapon lotus_util::mobile_weapon_usable( e_weapon.script_string );
			t_weapon LinkTo( e_mobile_shop );
		}
	}
	
	o_mobile_platform = level.a_o_mobile_platform[ str_name ];
	vh_mobile = [[o_mobile_platform]]->get_platform_vehicle();
	vh_mobile ClearVehGoalPos();
	[[o_mobile_platform]]->set_node_start( str_name + "_start_up" );
	
	// start moving the mobile shop up
	trigger::use( "trig_" + str_name, "script_noteworthy" );
	
	level waittill( "vehicle_platform_" + str_name + "_stop" );
	
	a_traversals = [];
	if ( !isdefined( a_traversals ) ) a_traversals = []; else if ( !IsArray( a_traversals ) ) a_traversals = array( a_traversals ); a_traversals[a_traversals.size]=GetNode( str_name + "_in_begin", "targetname" );;
	if ( !isdefined( a_traversals ) ) a_traversals = []; else if ( !IsArray( a_traversals ) ) a_traversals = array( a_traversals ); a_traversals[a_traversals.size]=GetNode( str_name + "_out_begin", "targetname" );;
	foreach ( nd_traversal in a_traversals )
	{
		if ( IsDefined( nd_traversal ) )
		{
			LinkTraversal( nd_traversal );
		}
	}
	
	t_raps_slow = GetEnt( "trig_slow_" + str_name, "script_noteworthy" );
	t_raps_slow TriggerEnable( true );
	
	level notify( "new_mobile_shop_arrived" );
	
	if ( str_armory_type == "minigun" )
	{
		// display the minigun objective once the mobile shop arrives on the roof
		foreach ( e_minigun_auto in e_mobile_shop.a_miniguns )
		{
			objectives::set( "cp_level_lotus_minigun", e_minigun_auto );
		}
		
		// hide the hack minigun objective if the player already have a minigun from a new mobile shop
		w_minigun = GetWeapon( "minigun_lotus" );
		foreach ( player in level.players )
		{
			if ( player HasWeapon( w_minigun ) )
			{
				objectives::hide( "cp_level_lotus_minigun", player );
			}
		}
	}
	
	n_wait_time = 15;
	if ( str_armory_type == "minigun" )
	{
		n_wait_time = 30;
	}
	
	wait n_wait_time; // time in which the mobile shop will wait on top of the roof before going away
	
	level flag::set( "call_next_mobile_shop" );
	
	level waittill( "new_mobile_shop_arrived" );
	
	waittill_mobile_shop_empty( str_name );
	
	vh_mobile ClearVehGoalPos();
	[[o_mobile_platform]]->set_node_start( str_name + "_start_down" );
	
	// move the shop down
	trigger::use( "trig_" + str_name, "script_noteworthy" );
	
	t_raps_slow = GetEnt( "trig_slow_" + str_name, "script_noteworthy" );
	t_raps_slow TriggerEnable( false );
	
	if ( str_armory_type == "minigun" )
	{
		foreach ( e_minigun_auto in e_mobile_shop.a_miniguns )
		{
			if ( isdefined( e_minigun_auto ) )
			{
				if ( isdefined( e_minigun_auto.t_minigun_auto ) )
				{
					e_minigun_auto.t_minigun_auto Delete();
				}
				
				objectives::complete( "cp_level_lotus_minigun", e_minigun_auto );
			}
		}
	}
	
	foreach ( nd_traversal in a_traversals )
	{
		if ( IsDefined( nd_traversal ) )
		{
			UnlinkTraversal( nd_traversal );
		}
	}
	
	level waittill( "vehicle_platform_" + str_name + "_stop" );
	
	if ( str_armory_type == "minigun" )
	{
		foreach ( e_minigun_auto in e_mobile_shop.a_miniguns )
		{
			if ( IsDefined( e_minigun_auto ) )
			{
				e_minigun_auto notify( "minigun_turret_cleanup" );
			}
		}
	}
	
	foreach ( mdl_destructible in e_mobile_shop.a_destructibles )
	{
		mdl_destructible Show();
		mdl_destructible Solid();
	}
	
	foreach ( e_weapon in e_mobile_shop.a_weapons )
	{
		e_weapon Hide();
	}
	
	self notify( "mobile_shop_ready" );
	
	level.a_ms_info[ str_name ].str_state = undefined;
}

function mobile_armory_type()
{
	const n_times_without_reward_max = 2;
	
	a_possible_types = array( "none", "none", "minigun" );
	w_minigun = GetWeapon( "minigun_lotus" );
	n_player_with_minigun = 0;
	
	foreach ( player in level.players )
	{
		if ( player HasWeapon( w_minigun ) )
		{
			n_player_with_minigun++;
		}
	}
	
	// a player or more does not have a minigun, so increase the chance of getting one
	if ( n_player_with_minigun != level.players.size )
	{
		if ( !isdefined( a_possible_types ) ) a_possible_types = []; else if ( !IsArray( a_possible_types ) ) a_possible_types = array( a_possible_types ); a_possible_types[a_possible_types.size]="minigun";;
	}
	
	str_armory_type = array::random( a_possible_types );
	if ( str_armory_type != "none" )
	{
		level.n_times_without_reward = 0;
	}
	else
	{
		level.n_times_without_reward++;
		if ( level.n_times_without_reward > n_times_without_reward_max )
		{
			// guarantee the mobile shop will have more than just ammo caches
			ArrayRemoveValue( a_possible_types, "none" );
			str_armory_type = array::random( a_possible_types );
		}
	}
	
	return str_armory_type;
}

function find_mobile_shop_distance_closest_to_a_player( str_name )
{
	n_dist_sq_closest = Distance2DSquared( level.players[0].origin, level.a_ms_info[ str_name ].v_origin );
	// figure out which mobile shop closest to the mobile armory is the closest to a player
	foreach ( player in level.players )
	{
		n_dist_sq = Distance2DSquared( player.origin, level.a_ms_info[ str_name ].v_origin );
		if ( n_dist_sq < n_dist_sq_closest )
		{
			n_dist_sq_closest = n_dist_sq;
		}
	}
	
	a_closest_dist_sq_info = SpawnStruct();
	a_closest_dist_sq_info.str_name = str_name;
	a_closest_dist_sq_info.n_dist_sq = n_dist_sq_closest;
	
	return a_closest_dist_sq_info;
}

function waittill_mobile_shop_empty( str_name )
{
	e_volume = GetEnt( "vol_" + str_name, "targetname" );
	b_someone_in_mobile = true;
	
	while ( ( isdefined( b_someone_in_mobile ) && b_someone_in_mobile ) )
	{
		n_checked = 0;
		a_checks = GetEntArray( "gunship_raps_ai", "targetname" );
		a_checks = ArrayCombine( a_checks, level.players, false, false );
		
		foreach ( e_check in a_checks )
		{
			if ( e_check IsTouching( e_volume ) )
			{
				break;
			}
			
			n_checked++;
		}
		
		// if it looped through all the entities, it means none of the entities are inside the mobile shop
		if ( n_checked == a_checks.size )
		{
			b_someone_in_mobile = false;
		}
		
		wait 0.05;
	}
}

//*****************************************************************************
// GUNSHIP
//*****************************************************************************
// self == gunship
function gunship_logic()
{	
	self endon( "death" );
	
	SetSavedDvar( "vehicle_selfCollision", 1 ); // allows the vehicle to shoot itself
	
	self turret::enable( 0 );
	self turret::set_target_flags( 1 | 2, 0 );
	
	self.n_health_min = self.health * 0.01;
	self.n_index_prev = 0;
	self.n_index_current = 0;
	self.n_index_next = 0;
	self.n_index_goal = level.s_mobile_shop.n_gunship_index;
	self.overrideVehicleDamage = &gunship_damage_override;
	self SetNearGoalNotifyDist( 2368 );
	
	self.gunship_targets = [];
	
	self flag::init( "gunship_can_shoot" );
	self flag::init( "missiles_not_firing" );
	self flag::init( "gunship_over_roof" );
	
	self flag::set( "gunship_can_shoot" );
	self flag::set( "missiles_not_firing" );
	
	t_gunship_body = GetEnt( "gunship_body", "targetname" );
	t_gunship_body EnableLinkTo();
	t_gunship_body LinkTo( self );
	t_gunship_body thread gunship_shooting_at_body( self );
	
	self thread gunship_first_missile_target();
	self thread gunship_target_logic();
	self thread gunship_missile_attack_logic();
	self thread gunship_health_watch();
	self thread gunship_health_half_watch();
//	self thread gunship_wasp_logic();
	self thread gunship_raps_logic();
	self thread gunship_weakpoint();
	self thread gunship_almost_dead();
	
	level waittill( "minigun_turret_picked_up" );
	
	wait 10; // give some time before the gunship can possibly move across the rooftop
	
	self gunship_brain();
}

// self == gunship
function gunship_brain()
{
	self endon( "death" );
	self endon( "prepare_to_die" );
	
	const n_switch_times_max = 3;
	const n_times_without_raps_max = 2;
	
	s_armory_old = level.s_mobile_shop;
	n_switch_times = 0;
	n_times_without_raps = 0;
	
	while ( true )
	{				
		if ( IsDefined( level.s_mobile_shop ) )
		{	
			self util::waittill_any( "gunship_health_decreased", "gunship_go_over_roof" );
			
			self flag::wait_till( "missiles_not_firing" );
			
			self flag::clear( "gunship_can_shoot" );
			self notify( "end_previous_path_logic" );
			
			n_switch_times++;
			if ( n_switch_times == n_switch_times_max || level.s_mobile_shop != s_armory_old )
			{
				n_switch_times = 0;
				s_armory_old = level.s_mobile_shop;
			}
			
			n_index_goal = gunship_roof_transition( n_switch_times, true );
			
			self thread gunship_path_logic( n_index_goal );
			
			waittill_raps_left_alive();
			
			self flag::set( "gunship_can_shoot" );
			
			wait 15; // give some time before the gunship can possibly move across the rooftop 
		}
		
		wait 0.05;
	}
}

function waittill_raps_left_alive()
{
	const n_raps_alive = 2;
	
	a_raps = GetEntArray( "gunship_raps_ai", "targetname" );
	while ( a_raps.size > n_raps_alive )
	{
		wait 0.05;
		
		a_raps = GetEntArray( "gunship_raps_ai", "targetname" );
	}
}

// self == gunship
function gunship_weakpoint()
{
	level flag::wait_till( "first_player_spawned" );
	
	LUINotifyEvent( &"weakpoint_update", 3, 1, self getEntityNumber(), &"tag_target_fan_right_outer" );
	LUINotifyEvent( &"weakpoint_update", 3, 1, self getEntityNumber(), &"tag_target_fan_right_inner" );
	LUINotifyEvent( &"weakpoint_update", 3, 1, self getEntityNumber(), &"tag_target_fan_left_inner" );
	LUINotifyEvent( &"weakpoint_update", 3, 1, self getEntityNumber(), &"tag_target_fan_left_outer" );
	
	a_weakpoints = GetEntArray( "gunship_weakpoint", "targetname" );
	self.a_weakpoints = a_weakpoints;
	foreach ( e_weakpoint in a_weakpoints )
	{
		e_weakpoint LinkTo( self );
		Target_set( e_weakpoint );
		
		self thread gunship_weakpoint_remove( e_weakpoint );
	}
}

// self == gunship
function gunship_weakpoint_remove( e_weakpoint )
{
	e_weakpoint endon( "death" );
	
	str_weakpoint_break_notify = "fan_" + e_weakpoint.script_noteworthy + "_destroyed";
	
	while ( true )
	{
		self waittill( "broken", str_break_notify );
	
		if ( str_break_notify == str_weakpoint_break_notify )
		{
			self gunship_weakpoint_remove_ui( e_weakpoint.script_int );
			e_weakpoint Delete();
		}
	}
}

// self == gunship
function gunship_weakpoint_remove_ui( n_id )
{
	switch ( n_id )
	{
		case 1:
			LUINotifyEvent( &"weakpoint_update", 3, 0, self getEntityNumber(), &"tag_target_fan_right_outer" );
			break;
		
		case 2:
			LUINotifyEvent( &"weakpoint_update", 3, 0, self getEntityNumber(), &"tag_target_fan_right_inner" );
			break;
			
		case 3:
			LUINotifyEvent( &"weakpoint_update", 3, 0, self getEntityNumber(), &"tag_target_fan_left_inner" );
			break;
			
		case 4:
			LUINotifyEvent( &"weakpoint_update", 3, 0, self getEntityNumber(), &"tag_target_fan_left_outer" );
			break;
			
		default:
			break;
	}
}

// self == gunship
function gunship_almost_dead()
{
	const n_index_final = 0;
	
	while ( self.health > self.n_health_min )
	{
		wait 0.05;
	}
	
	a_flags = [];
	if ( !isdefined( a_flags ) ) a_flags = []; else if ( !IsArray( a_flags ) ) a_flags = array( a_flags ); a_flags[a_flags.size]="gunship_can_shoot";;
	if ( !isdefined( a_flags ) ) a_flags = []; else if ( !IsArray( a_flags ) ) a_flags = array( a_flags ); a_flags[a_flags.size]="missiles_not_firing";;
	
	self flag::wait_till_all( a_flags );
	
	self notify( "end_dropping_raps" );
	self notify( "end_missile_attack" );
	self notify( "prepare_to_die" );
	self turret::disable( 0 );
	
	a_weakpoints = GetEntArray( "gunship_weakpoint", "targetname" );
	foreach ( e_weakpoint in a_weakpoints )
	{
		self gunship_weakpoint_remove_ui( e_weakpoint.script_int );
	}
	
	if ( self.n_index_goal != n_index_final )
	{
		self thread gunship_path_logic( n_index_final );
	
		self waittill( "gunship_in_position" );
	}
	
	self notify( "end_previous_path_logic" );
	self SetSpeed( 50 );
	
	s_position = struct::get( "gunship_pos_0", "targetname" );
	self set_veh_goal_pos( s_position.origin, false, true );
	self waittill( "near_goal" );
	
	wait 3; // time before playing the ending cutscene
	
	level notify( "gunship_almost_dead" );
	
	a_raps = GetEntArray( "gunship_raps_ai", "targetname" );
	foreach ( ai_rap in a_raps )
	{
		ai_rap Delete();
	}
}

// self == trigger for the gunship body
function gunship_shooting_at_body( vh_gunship )
{
	vh_gunship endon( "gunship_health_less_than_half" );
	
	while ( true )
	{
		self waittill( "trigger" );
		
		util::screen_message_create( "Shoot the fans on the Gunship!", undefined, undefined, 0, 3 );
		
		wait 30;
	}
}

// self == gunship
function gunship_health_watch()
{
	self endon( "death" );
	
	n_health_percent = self.n_health_min;
	n_health_checkpoint = self.health - n_health_percent;
	n_health_half = self.health / 2;
	
	while ( true )
	{
		if ( self.health < n_health_checkpoint )
		{
			self notify( "gunship_health_decreased" );
			n_health_checkpoint = self.health - n_health_percent;
		}
		
		if ( self.health < n_health_half )
		{
			self notify( "gunship_health_less_than_half" );
		}
		
		wait 0.05;
	}
}

// self == gunship
function gunship_health_half_watch()
{
	self endon( "death" );

	self.n_acceleration = 30;
	
	self waittill( "gunship_health_less_than_half" );
	
	self.n_acceleration = 54;
	self thread gunship_roof_transistion_increase();
}

// self == gunship
function gunship_roof_transistion_increase()
{
	self endon( "death" );
	
	while ( true )
	{
		self notify( "gunship_go_over_roof" );
		
		wait 15;
	}
}

// self == gunship
function gunship_roof_transition( n_switch_times, b_spawn_raps )
{
	const n_positions = 6; // number of positions that the gunship can go to
	const n_wait_over_roof = 2;
	const n_wait_before_spawning = 1;
	
	level flag::set( "gunship_in_transition" );
	
	str_pos_start = "gunship_pos_" + self.n_index_goal;
	if ( ( isdefined( b_spawn_raps ) && b_spawn_raps ) )
	{
		// get to a position so it can move through the middle of the rooftop
		s_position_current = struct::get( "gunship_pos_" + self.n_index_current, "targetname" );	
		if ( s_position_current.targetname == "gunship_pos_0" || s_position_current.targetname == "gunship_pos_3" )
		{
			str_pos_start = s_position_current.targetname;
		}
		else if ( s_position_current.target == "gunship_pos_0" || s_position_current.target == "gunship_pos_3" )
		{
			str_pos_start = s_position_current.target;
		}
		else if ( s_position_current.script_string == "gunship_pos_0" || s_position_current.script_string == "gunship_pos_3" )
		{
			str_pos_start = s_position_current.script_string;
		}
	}
	
	// move to the current pivot position
	s_position = struct::get( str_pos_start, "targetname" );	
	self set_veh_goal_pos( s_position.origin, false, true );
	self waittill( "near_goal" );
	
	self.n_index_goal = s_position.script_int;
	self.n_index_current = s_position.script_int;
	
	self SetSpeed( 117, 55 );
	
	// move to the middle of the roof
	s_position_center = struct::get( "gunship_pos_center", "targetname" );
	self set_veh_goal_pos( s_position_center.origin, false, true );
	self waittill( "near_goal" );
	
	// slow down to drop enemies
	self SetSpeed( 0 );
	
	if ( ( isdefined( b_spawn_raps ) && b_spawn_raps ) )
	{
//		level notify( "spawn_boss_raps" );
		level thread raps_spawning_timer( n_wait_before_spawning * level.players.size );
	}
	
	self thread gunship_over_roof_rumble();
	
	n_wait = n_wait_over_roof * level.players.size;
	wait n_wait;
	
	self SetSpeed( 117 );
	
	self thread gunship_stop_rumble();
	
	level flag::clear( "gunship_in_transition" );

	// move to the position that is opposite to the current pivot location
	n_index_goto = ( self.n_index_goal + 3 ) % n_positions;
	s_position_goto = struct::get( "gunship_pos_" + n_index_goto, "targetname" );
	self set_veh_goal_pos( s_position_goto.origin, false, true );
	self waittill( "near_goal" );
	
	self.n_index_current = s_position_goto.script_int;
	
	if ( !b_spawn_raps )
	{
		level notify( "spawn_boss_wasp" );
	}
	
	self SetAcceleration( self.n_acceleration );
	n_speed_max = self GetMaxSpeed() / 17.6;
	self SetSpeed( n_speed_max );
	
	// determine what is next pivot location
	s_position_next = struct::get( "gunship_pos_" + level.s_mobile_shop.n_gunship_index, "targetname" );
	s_position_left = struct::get( s_position_next.target, "targetname" );
	s_position_right = struct::get( s_position_next.script_string, "targetname" );
	a_gunship_index = array( s_position_next.script_int, s_position_left.script_int, s_position_right.script_int );
	
	n_index_goal = a_gunship_index[ n_switch_times ];
	
	return n_index_goal;
}

// self == gunship
function gunship_over_roof_rumble()
{	
	self flag::set( "gunship_over_roof" );
	
	array::run_all( level.players, &PlayRumbleOnEntity, "damage_light" );
	
	wait 0.25; // wait before doing a heavier rumble
	
	while ( self flag::get( "gunship_over_roof" ) )
	{
		array::run_all( level.players, &PlayRumbleOnEntity, "damage_heavy" );
		
		foreach ( player in level.players )
		{
			Earthquake( 0.5, 0.15, player.origin, 64 );
		}
		
		wait 0.15; // wait before rumbling again
	}
	
	array::run_all( level.players, &PlayRumbleOnEntity, "damage_light" );
}

// self == gunship
function gunship_stop_rumble()
{
	wait 2; // wait before stopping the rumble
	
	self flag::clear( "gunship_over_roof" );
}

// self == gunship
function slightly_opposite_position()
{
	const n_positions = 6; // number of positions that the gunship can go to
	const n_position_1 = 0;
	
	n_index_opp = ( self.n_index_goal + 3 ) % n_positions;
	if ( n_index_opp == n_position_1 )
	{
		n_index_goto = 1;
	}
	else
	{
		n_index_goto = 2;
	}
	
	return n_index_goto;
}

function raps_spawning_timer( n_wait )
{
	wait n_wait; // time before notifying to release the raps
	
	level notify( "spawn_boss_raps" );
}

// self == gunship
function debug_gunship()
{
	self endon( "death" );
	
	while ( true )
	{
		//IPrintLnBold( self.n_index_goal + " " + self.n_index_prev + " " + self.n_index_current + " " + self.n_index_next );
//		IPrintLnBold( self GetSpeedMPH() );
//		IPrintLnBold( self.health );
		
//		v_origin_1 = self GetTagOrigin( "tag_gunner_turret1" );
//		v_angles_1 = self GetTagAngles( "tag_gunner_turret1" );
//		v_forward_1 = AnglesToForward( v_angles_1 );
//		v_target_pos_1 = v_origin_1 + ( v_forward_1 * 1024 );
//		util::debug_line( v_origin_1, v_target_pos_1, (0, 0, 1), 0.8, false, 1 );
//		
//		v_origin_2 = self GetTagOrigin( "tag_gunner_turret2" );
//		v_angles_2 = self GetTagAngles( "tag_gunner_turret2" );
//		v_forward_2 = AnglesToForward( v_angles_2 );
//		v_target_pos_2 = v_origin_2 + ( v_forward_2 * 1024 );
//		util::debug_line( v_origin_2, v_target_pos_2, (0, 0, 1), 0.8, false, 1 );
		
		v_tag_origin = self GetTagOrigin( "tag_rocket1" );
		a_trace_1 = BulletTrace( v_tag_origin, level.players[0].origin, false, self );
		util::debug_line( v_tag_origin, level.players[0].origin, ( 1, 0, 0 ), 0.8, false, 1 );
		
		v_tag_origin = self GetTagOrigin( "tag_rocket2" );
		a_trace_2 = BulletTrace( v_tag_origin, level.players[0].origin, false, self );
		util::debug_line( v_tag_origin, level.players[0].origin, ( 1, 0, 0 ), 0.8, false, 1 );
		
		if ( a_trace_1[ "fraction" ] < 0.59 || a_trace_2[ "fraction" ] < 0.59 )
		{
			IPrintLnBold( "don't shoot" );
		}
		
		wait 0.05;
	}
}

// self == gunship
function gunship_wasp_logic()
{
	self endon( "death" );
	
	const n_wasp_per_player = 4;
	a_wasp = GetEntArray( "boss_wasp", "targetname" );
	a_wasp_alive = [];
	
//	level waittill( "start_spawning_wasp" );
	
	while ( true )
	{	
		level waittill( "spawn_boss_wasp" );
		
		if ( IsDefined( self.e_target ) && self.e_target.sessionstate == "playing" )
		{
			a_wasp_alive = array::remove_undefined( a_wasp_alive );
			n_wasps_max = n_wasp_per_player * level.players.size;
			
//			if ( a_wasp_alive.size < n_wasps_max )
//			{
				a_wasp_targets = level.players;
				foreach ( e_player in level.players )
				{
					// try to weigh/spawn more of the wasp near players that are NOT the target
					if ( e_player != self.e_target )
					{
						if ( !isdefined( a_wasp_targets ) ) a_wasp_targets = []; else if ( !IsArray( a_wasp_targets ) ) a_wasp_targets = array( a_wasp_targets ); a_wasp_targets[a_wasp_targets.size]=e_player;;
					}
				}
				
				n_target_index = 0;
				for ( i = 0; i < n_wasps_max; i++ ) // only spawn more wasps if the max has not been reached
				{
					a_wasp_closest = ArraySortClosest( a_wasp, a_wasp_targets[ n_target_index ].origin );
					ai_wasp = spawner::simple_spawn_single( a_wasp_closest[0] );
					ai_wasp.origin = self GetTagOrigin( "tag_bomb" );
					ai_wasp.angles = self GetTagAngles( "tag_bomb" );
					
					n_x_offset = ( RandomInt( 2 ) ? 256 : -256 );
					n_y_offset = ( RandomInt( 2 ) ? 256 : -256 );
					v_goal_pos = a_wasp_targets[ n_target_index ].origin + ( n_x_offset, n_y_offset, 64 );
					b_found_goal = ai_wasp SetGoal( v_goal_pos, true );
					ai_wasp thread wait_to_cleargoal();
					
					if ( !isdefined( a_wasp_alive ) ) a_wasp_alive = []; else if ( !IsArray( a_wasp_alive ) ) a_wasp_alive = array( a_wasp_alive ); a_wasp_alive[a_wasp_alive.size]=ai_wasp;;
					
					n_target_index++;
					if ( n_target_index == a_wasp_targets.size )
					{
						n_target_index = 0;
					}
				}
				
				wait 15; // wait a bit before spawning more wasp
//			}
		}
		
		wait 0.05;
	}
}

// self == AI
function wait_to_cleargoal()
{
	self endon( "death" );
	
	self waittill( "goal" );
	
	self ClearForcedGoal();
}

// self == gunship
function gunship_raps_logic()
{
	self endon( "death" );
	self endon( "end_dropping_raps" );
	
	const n_spawn_per_position_max = 2;
	const n_scale_min = 1024;
	const n_scale_max = 2048;
	a_raps_alive = [];
	a_raps_spawn_pos = GetEntArray( "raps_aim_pos", "targetname" );
	
	while ( true )
	{	
		level waittill( "spawn_boss_raps" );
		
		if ( IsDefined( self.e_target ) && self.e_target.sessionstate == "playing" )
		{
			a_raps_alive = array::remove_undefined( a_raps_alive );
			
			// reset all the counts
			foreach ( s_spawn_pos in a_raps_spawn_pos )
			{
				s_spawn_pos.n_spawns_count = 0;
			}
			
			foreach ( player in level.players )
			{
				str_side = "left";
				str_side_next = "right";
				if ( RandomInt( 2 ) ) // randomize which side to pick first
				{
					str_side = "right";
					str_side_next = "left";
				}
				
				a_spawn_pos_closest = ArraySortClosest( a_raps_spawn_pos, player.origin );
				n_pos_index_prev = 0;
				n_raps_per_player = get_raps_per_player();
				for ( j = 0; j < n_raps_per_player; j++ )
				{
					// continue looping down the array from where it was last left off
					for ( i = n_pos_index_prev; i < a_spawn_pos_closest.size; i++ )
					{
						 s_spawn_pos = a_spawn_pos_closest[i];
						 if ( s_spawn_pos.n_spawns_count < n_spawn_per_position_max && n_pos_index_prev != s_spawn_pos.script_int )
						 {
						 	if ( j % 2 ) // interchange between the two sides for each raps
						 	{
						 		if ( str_side == s_spawn_pos.script_string )
						 		{
						 			s_spawn_pos.n_spawns_count++;
									n_pos_index_prev = s_spawn_pos.script_int;
									break;
						 		}
						 	}
						 	else
						 	{
						 		if ( str_side_next == s_spawn_pos.script_string )
						 		{
						 			s_spawn_pos.n_spawns_count++;
									n_pos_index_prev = s_spawn_pos.script_int;
									break;
						 		}
						 	}
						 }
					}
				}
			}
			
			a_spawn_pos_closest = ArraySortClosest( a_raps_spawn_pos, self.origin );
			foreach ( s_spawn_pos in a_spawn_pos_closest )
			{
				for ( i = 0; i < s_spawn_pos.n_spawns_count; i++ )
				{				
					ai_raps = spawner::simple_spawn_single( "gunship_raps" );
					ai_raps.origin = self GetTagOrigin( "tag_bomb" );
					ai_raps.angles = self GetTagAngles( "tag_bomb" );
					ai_raps thread play_raps_fx();
					v_dir = s_spawn_pos.origin - ai_raps.origin;
					v_dir = ( v_dir[0], v_dir[1], 0 );
					v_dir_normal = VectorNormalize( v_dir );
					
					n_scale = Abs( v_dir[0] );
					n_scale = Int( n_scale );
					if (n_scale < n_scale_min) {     n_scale = n_scale_min;    }    else if (n_scale > n_scale_max) {     n_scale = n_scale_max;    };
					n_scale = n_scale * 0.15; // the raps mass got changed to only 15% of what it originally was
					
					v_force = v_dir_normal * n_scale;
					//change this call back to LaunchVehicle if results are not good
					ai_raps ApplyBallisticTarget( s_spawn_pos.origin );
					
					if ( !isdefined( a_raps_alive ) ) a_raps_alive = []; else if ( !IsArray( a_raps_alive ) ) a_raps_alive = array( a_raps_alive ); a_raps_alive[a_raps_alive.size]=ai_raps;;
					
					wait 0.15; // wait before spawning another raps
				}
			}
			
			wait 15; // wait a bit before spawning more raps
		}
		
		wait 0.05;
	}
}

// self == raps
function play_raps_fx()
{
	self endon( "death" );
	
	wait 0.05; // HACK: need to wait a frame before putting FX on tag in order for it to work
	
	PlayFxOnTag( level._effect[ "gunship_raps" ], self, "tag_origin" );
}

function get_raps_per_player()
{
	const n_one_player_count = 3;
	const n_two_players_count = 2;
	const n_three_players_count = 2;
	const n_four_players_count = 2;
	
	switch ( level.players.size )
	{
		case 1:
			n_count = n_one_player_count;
			break;
			
		case 2:
			n_count = n_two_players_count;
			break;
		
		case 3:
			n_count = n_three_players_count;
			break;
			
		case 4:
			n_count = n_four_players_count;
			break;
			
		default:
			break;
	}
	
	return n_count;
}

// self == gunship
function gunship_missile_attack_logic()
{
	self endon( "death" );
	self endon( "end_missile_attack" );
	
	const n_missile_set_max = 3;
	
	self SetGunnerTurretOnTargetRange( 0, 1 );
	self SetGunnerTurretOnTargetRange( 1, 1 );
	
//	level waittill( "start_spawning_wasp" );
	
//	wait 0.15; // wait a bit before attacking the players with missiles
	
	n_missile_set_count = 0;
	self.n_missiles_launched = 0;
	
	while ( true )
	{
		self flag::wait_till( "gunship_can_shoot" );
		
		if ( IsDefined( self.e_target ) )
		{			
			self flag::clear( "missiles_not_firing" );
			
			self gunship_wait_to_fire_missiles();
			
			n_pivot_current = self.n_index_goal;
			self notify( "end_previous_path_logic" );
			
			// the position of the goal
			s_gunship_position = struct::get( "gunship_pos_" + self.n_index_current, "targetname" );
			self set_veh_goal_pos( s_gunship_position.origin, true, true );
			self waittill( "near_goal" );
			
			self.n_index_current = s_gunship_position.script_int;
			
			self SetSpeed( 1 );
			
			PlaySoundAtPosition( "evt_boss_rocket_prime" , self.origin );//prime sound before charge
			
			wait 3; // give time for the gunship to stop before shooting the missiles
			
			PlaySoundAtPosition( "evt_boss_rocket_charge" , self.origin );//charge sound
			
			// make the gunship go up a bit before firing the missiles
			n_speed_max = self GetMaxSpeed() / 17.6;
			self SetSpeed( n_speed_max );
			self set_veh_goal_pos( self.origin + ( 0, 0, 128 ), true, true );
			self waittill( "goal" );
			
			self SetSpeed( 1 );
			
			v_forward = AnglesToForward( self.angles );
	
			// tag_gunner_turret1
			v_origin_1 = self GetTagOrigin( "tag_gunner_turret1" );
			v_target_pos_1 = v_origin_1 + ( v_forward * 1024 );
			self SetGunnerTargetVec( v_target_pos_1, 0 );
			
			// tag_gunner_turret2
			v_origin_2 = self GetTagOrigin( "tag_gunner_turret2" );
			v_target_pos_2 = v_origin_2 + ( v_forward * 1024 );
			self SetGunnerTargetVec( v_target_pos_2, 1 );
			
			self waittill( "gunner_turret_on_target" );
			
			level thread util::screen_message_create( "MISSILES INBOUND", undefined, undefined, 0, 9 );
			
			for ( i = 0; i < n_missile_set_max; i++ )
			{	
				//wait .1; //sound trying staggered shot
				self gunship_fire_missile( 0 );
				//wait .1; //sound trying staggered shot
				self gunship_fire_missile( 1 );
			}
			
			wait 0.15; // amount of time that the missiles will be following the player
			foreach ( e_player in level.players )
			{
				if ( isdefined( e_player.e_fake ) )
				{
					e_player.e_fake Unlink();
				}
			}
			
			self util::waittill_notify_or_timeout( "all_missiles_destroyed", 6.45 );
			
			self flag::set( "missiles_not_firing" );
			self SetSpeed( n_speed_max );
			self thread gunship_path_logic( n_pivot_current );
			
			n_missile_set_count = 0;
			foreach ( e_player in level.players )
			{
				if ( isdefined( e_player.e_fake ) )
				{
					e_player.e_fake Delete();
				}
			}
			
			wait 17; // time before the next wave of missiles
		}
		
		wait 0.05;
	}
}

// self == gunship
function gunship_wait_to_fire_missiles()
{
	const n_faction_acceptable = 0.59;
	
	v_tag_origin = self GetTagOrigin( "tag_rocket1" );
	a_trace_1 = BulletTrace( v_tag_origin, self.e_target.origin, false, self );
	
	v_tag_origin = self GetTagOrigin( "tag_rocket2" );
	a_trace_2 = BulletTrace( v_tag_origin, self.e_target.origin, false, self );
	
	// wiat if there is something in front of the gunship that is close to it that can prevent it to fire its missiles at the player
	while ( a_trace_1[ "fraction" ] < n_faction_acceptable || a_trace_2[ "fraction" ] < n_faction_acceptable )
	{
		wait 0.05;
		
		v_tag_origin = self GetTagOrigin( "tag_rocket1" );
		a_trace_1 = BulletTrace( v_tag_origin, self.e_target.origin, false, self );
		
		v_tag_origin = self GetTagOrigin( "tag_rocket2" );
		a_trace_2 = BulletTrace( v_tag_origin, self.e_target.origin, false, self );
	}
}

// self == gunship
function gunship_fire_missile( n_gunner_index )
{
	e_target = self gunship_missile_target();
//	self SetGunnerTargetEnt( e_target, (0, 0, 32), n_gunner_index );
//	e_missile = self FireWeapon( n_gunner_index + 1 );

	n_tag_id = n_gunner_index + 1;
	str_tag = "tag_rocket" + n_tag_id;
	v_tag_origin = self GetTagOrigin( str_tag );
	w_gunship_cannon = GetWeapon( "gunship_cannon" );
	e_missile = MagicBullet( w_gunship_cannon, v_tag_origin, v_tag_origin + ( 0, 0, 1024 ), self, e_target );
	
	e_missile thread gunship_missile_death_logic( self );
//	self ClearGunnerTarget( n_gunner_index );
}

// self == gunship
function gunship_missile_target()
{
	e_missile_target = undefined;
	
	if ( isdefined( self.e_override_missile_target ) )
	{
		e_missile_target = self.e_override_missile_target;
	}
	else
	{
		a_targets = ArraySortClosest( self.gunship_targets, level.s_mobile_shop.v_origin );
		n_mod = self.n_missiles_launched % a_targets.size;
		e_target = a_targets[ n_mod ];
		
		if ( !IsDefined( e_target.e_fake ) )
		{
			e_target.e_fake = Spawn( "script_model", e_target.origin, 0 );
			e_target.e_fake LinkTo( e_target );
		}
		
		e_missile_target = e_target.e_fake;
	}
	
	self.n_missiles_launched++;
	
	return e_missile_target;
}

// self == missile
function gunship_missile_death_logic( vh_gunship )
{
	self waittill( "death" );
	
	vh_gunship.n_missiles_launched--;
	
	if ( vh_gunship.n_missiles_launched == 0 )
	{
		vh_gunship notify( "all_missiles_destroyed" );
	}
}

// self == gunship
function set_veh_goal_pos( v_origin, b_stop, b_navigation )
{
	n_goal_found = self SetVehGoalPos( v_origin, b_stop );
	
	/#
	if ( !( isdefined( n_goal_found ) && n_goal_found ) )
	{
		IPrintLnBold( "didn't find goal" );
	}
	#/
}

// self == gunship
function gunship_path_logic( n_index_goal )
{
	self endon ( "death" );
	
	self notify( "end_previous_path_logic" );
	self endon( "end_previous_path_logic" );
	
	const n_half_positions = 3; // total positions == 6
	
	self.n_index_goal = n_index_goal;
	str_goal_name = "gunship_pos_" + self.n_index_goal;
	str_target_name = str_goal_name;
	str_traverse = "clockwise";
	s_gunship_position = struct::get( "gunship_pos_" + self.n_index_current, "targetname" );
	
	// check to see if the gunship is already there
	if ( self.n_index_current != self.n_index_goal )
	{
		self flag::clear( "gunship_can_shoot" );
		
		// find if it is faster to travel clockwise or counterclockwise to the goal
		str_traverse = self gunship_traverse_path();
		
		// force the gunship to traverse around the play space and not through it to get to its goal
		if ( str_traverse == "counterclockwise" )
		{
			str_target_name = self gunship_path_counterclockwise( s_gunship_position, str_goal_name );
		}
		else
		{
			str_target_name = self gunship_path_clockwise( s_gunship_position, str_goal_name );
		}
		
		self flag::set( "gunship_can_shoot" );
	}
	
	s_position = struct::get( str_target_name, "targetname" );
	s_position_left = struct::get( s_position.target, "targetname" );
	s_position_right = struct::get( s_position.script_string, "targetname" );
	
	// hang around the area near the targeted player
	while ( true )
	{
		self notify( "gunship_in_position" );
		
		// the position of the goal
		self.n_index_next = s_position.script_int;
		self set_veh_goal_pos( s_position.origin, false, true );
		self waittill( "near_goal" );
		
		self.n_index_prev = self.n_index_current;
		self.n_index_current = s_position.script_int;
		
		if ( str_traverse == "counterclockwise" )
		{
			// the position to right of the goal
			self.n_index_next = s_position_right.script_int;
			self set_veh_goal_pos( s_position_right.origin, true, true );
			self waittill( "near_goal" );
			
			self.n_index_prev = self.n_index_current;
			self.n_index_current = s_position_right.script_int;
			str_traverse = "clockwise";
		}
		else
		{
			// the position to the left of the goal
			self.n_index_next = s_position_left.script_int;
			self set_veh_goal_pos( s_position_left.origin, true, true );
			self waittill( "near_goal" );
			
			self.n_index_prev = self.n_index_current;
			self.n_index_current = s_position_left.script_int;
			str_traverse = "counterclockwise";
		}
		
		wait 0.05;
	}
}

// self == gunship
function gunship_traverse_path()
{
	const n_index_max = 5;
	const n_gunship_positions = 6;
		
	// find how many designated positions the gunship must get through in order to reach its goal by going clockwise
	n_clockwise = n_index_max - self.n_index_current;
	if ( self.n_index_current > self.n_index_goal )
	{
		n_clockwise += self.n_index_goal + 1; // +1 to include the starting index 0
	}
	
	// find how many designated positions the gunship must get through in order to reach its goal by going counterclockwise
	n_counterclockwise = self.n_index_current - self.n_index_goal;
	if ( self.n_index_current < self.n_index_goal )
	{
		n_counterclockwise += n_gunship_positions;
	}
	
	// determine if going clockwise or counterclockwise faster for the gunship
	if ( n_counterclockwise < n_clockwise )
	{
		str_traverse = "counterclockwise";
	}
	else
	{
		str_traverse = "clockwise";
	}
	
	return str_traverse;
}

// self == gunship
function gunship_path_clockwise( s_gunship_position, str_goal_name )
{
	str_target_name = s_gunship_position.target;
	
	// keep going clockwise until the next position is the goal	
	while ( str_target_name != str_goal_name )
	{
		s_position = struct::get( str_target_name, "targetname" );
		self.n_index_next = s_position.script_int;
		self set_veh_goal_pos( s_position.origin, false, true );
		self waittill( "near_goal" );
		
		self.n_index_prev = self.n_index_current;
		self.n_index_current = s_position.script_int;
		str_target_name = s_position.target;
	}
	
	return str_target_name;
}

// self == gunship
function gunship_path_counterclockwise( s_gunship_position, str_goal_name )
{
	str_target_name = s_gunship_position.script_string;
		
	// keep going counterclockwise until the next position is the goal	
	while ( str_target_name != str_goal_name )
	{
		s_position = struct::get( str_target_name, "targetname" );
		self.n_index_next = s_position.script_int;
		self set_veh_goal_pos( s_position.origin, false, true );
		self waittill( "near_goal" );
		
		self.n_index_prev = self.n_index_current;
		self.n_index_current = s_position.script_int;
		str_target_name = s_position.script_string;
	}
	
	return str_target_name;
}

function private is_gunship_target_valid( target )
{
	if( !IsDefined( target ) ) 
	{
		return false; 
	}

	if( !IsAlive( target ) )
	{
		return false; 
	} 
	
	if( IsPlayer( target ) && target.sessionstate == "spectator" )
	{
		return false; 
	}

	if( IsPlayer( target ) && target.sessionstate == "intermission" )
	{
		return false; 
	}
	
	if( ( isdefined( self.intermission ) && self.intermission ) )
	{
		return false;
	}
	
	if( ( isdefined( target.ignoreme ) && target.ignoreme ) )
	{
		return false;
	}

	if( target IsNoTarget() )
	{
		return false;
	}

	if( self.team == target.team )
	{
		return false;
	}
	
	return true; 
}

//self == gunship
function update_gunship_targets()
{
	self endon( "death" );
	
	pruned_target_list = [];
	do
	{
		target_list = ArrayCombine( level.players, GetAITeamArray( "allies" ), false, false );
		
		if( target_list.size > 0 )
		{
			foreach( gunship_target in target_list )
			{
				if( is_gunship_target_valid( gunship_target ) )
				{
					pruned_target_list[pruned_target_list.size] = gunship_target;
				}
			}
		}
		
		wait 0.05;
		
	} while( pruned_target_list.size == 0 );
		
	self.gunship_targets = pruned_target_list;
}

// self == gunship
function gunship_target_logic()
{
	self endon( "death" );
	
	const n_positions = 6; // number of positions that the gunship can go to
	
	self update_gunship_targets();
	
	self.e_target = self.gunship_targets[0];
	self SetLookAtEnt( self.e_target );
	
	// can't determine the gunship to focus on if there is no armory for it to protect
	while ( !IsDefined( level.s_mobile_shop ) )
	{
		wait 0.05;
	}
	
	while ( true )
	{
		self update_gunship_targets();
		
		if ( !level flag::get( "gunship_in_transition" ) )
		{
			e_gunship_target = self.gunship_targets[0];
			n_dist_sq_min = Distance2DSquared( e_gunship_target.origin, level.s_mobile_shop.v_origin );
			
			// determine which target is closest to the mobile armory
			foreach ( target in self.gunship_targets )
			{
				n_dist_sq = Distance2DSquared( target.origin, level.s_mobile_shop.v_origin );
				if ( n_dist_sq < n_dist_sq_min )
				{
					e_gunship_target = target;
					n_dist_sq_min = n_dist_sq;
				}
			}
			
			if ( e_gunship_target != self.e_target )
			{
				// found a new target to attack
				// switch target if it is only different from the previous
				self.e_target = e_gunship_target;
			}
		}
		else
		{
			while ( self.n_index_goal != 0 && self.n_index_goal != 3 )
			{
				wait 0.05;
			}
			
			n_index_goto = ( self.n_index_goal + 3 ) % n_positions;
			e_look_at = GetEnt( "bb_look_at_pos_" + n_index_goto, "targetname" );
			self SetLookAtEnt( e_look_at );
			
			level flag::wait_till_clear( "gunship_in_transition" );
			
			self SetLookAtEnt( self.e_target );
		}
		
		wait 0.05;
	}
}

// self == gunship
function gunship_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	const n_one_player_multiplier = 3.1;
	const n_two_players_multiplier = 2.3;
	const n_three_players_multiplier = 1.7;
	const n_four_players_multiplier = 1.2;
	
	switch ( level.players.size )
	{
		case 1:
			n_damage = Int( n_damage * n_one_player_multiplier );
			break;
			
		case 2:
			n_damage = Int( n_damage * n_two_players_multiplier );
			break;
		
		case 3:
			n_damage = Int( n_damage * n_three_players_multiplier );
			break;
			
		case 4:
			n_damage = Int( n_damage * n_four_players_multiplier );
			break;
			
		default:
			break;
	}
	
	n_health_after_damage = self.health - n_damage;
	if ( self.health < self.n_health_min )
	{
		n_damage = 0;
	}
	else if ( n_health_after_damage < self.n_health_min )
	{
		n_damage = self.health - self.n_health_min + 1;
	}
	
	return n_damage;
}

function boss_battle_done( str_objective, b_starting, b_direct, player )
{
}
