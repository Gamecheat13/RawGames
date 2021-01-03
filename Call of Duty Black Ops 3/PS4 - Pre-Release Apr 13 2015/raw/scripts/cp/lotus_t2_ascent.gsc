#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_ammo_cache;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\lotus_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       









#precache( "lui_menu", "TmpMobileShopRideIGC" );//TODO - remove once we get the anims

#precache( "model", "c_54i_robot_4_body" );
#precache( "model", "c_54i_robot_4_head" );
#precache( "model", "p7_fxanim_cp_sgen_charging_station_doors_mod" );

#precache( "string", "cairotroops" );

function tower_2_ascent_main( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		
		skipto::teleport_ai( str_objective );
		
		level flag::wait_till( "first_player_spawned" );
	}
	
	spawner::add_spawn_function_group( "shooter_group", "script_noteworthy", &shooter_group_func );
	spawner::add_spawn_function_group( "rpg_group", "script_noteworthy", &rpg_group_func );
	spawner::add_spawn_function_group( "raps_group", "script_noteworthy", &raps_group_func );
	spawner::add_spawn_function_group( "wasp_group", "script_noteworthy", &wasp_group_func );
	spawner::add_spawn_function_group( "zombie_group", "script_noteworthy", &zombie_group_func );
	spawner::add_spawn_function_group( "zombie_runner_group", "script_noteworthy", &zombie_group_func, true );
	spawner::add_spawn_function_group( "zombie_flaming_group", "script_noteworthy", &zombie_flaming_group_func );
	spawner::add_spawn_function_group( "leaper_group", "script_noteworthy", &leaper_group_func );
	spawner::add_spawn_function_group( "climber_group", "script_noteworthy", &climber_group_func );
	spawner::add_spawn_function_group( "mobile_shop_shooter_spawners", "script_noteworthy", &mobile_shop_spawn_func, 1 );
	spawner::add_spawn_function_group( "mobile_shop_melee_spawners", "script_noteworthy", &mobile_shop_spawn_func, 0 );	
	spawner::add_spawn_function_group( "mobile_shop_suicide_spawners", "script_noteworthy", &mobile_shop_spawn_func, 0 );	
	spawner::add_spawn_function_group( "mobile_shop_jumper_spawners", "script_noteworthy", &mobile_shop_spawn_jumper_func );

	exploder::exploder( "fx_interior_ambient_falling_debris_tower2" );
	
	level thread lui::play_movie( "cairotroops", "pip" );
	
	level thread skybridge_cleanup();
	
	level thread falling_mobile_shops();
	setup_kool_aid_man_robots();
	level thread clear_fallen_mobile_shop_02();
	level thread intro_area_battle();
	level thread room_01_battle();
	level thread room_02_battle();
	level thread atrium_battle_01();
	level thread setup_prometheus_rising();
	
	level thread sgen_style_spawn_pods();
	
	trigger::wait_till( "tower_2_ascent_complete" );
	
	a_remaining_enemies = GetAITeamArray( "team3" );
	array::run_all( a_remaining_enemies, &Kill );
	
	// START: Temp placeholder UI MENU//TODO - remove once we get the anims
	foreach ( player in level.players )
	{
		player.temp_menu = player OpenLUIMenu( "TmpMobileShopRideIGC" );
	}			
	wait 6;//Allow enough time to see temp intro igc card
	foreach ( player in level.players )
	{
		if( IsDefined( player.temp_menu ) )
		{
			player CloseLUIMenu( player.temp_menu );
		}
	}
	// END: Temp placeholder UI MENU//TODO - remove once we get the anims
	
	
	level.ai_hendricks Delete();	// TODO: Hendricks doesn't currently exist in the Boss Battle so there are no teleport spawns.  Remove this once that's set up 
	skipto::objective_completed( "tower_2_ascent" );
}

function tower_2_ascent_done( str_objective, b_starting, b_direct, player )
{
}


//===========================================
// SPAWN FUNCS
//
//===========================================
function zombie_group_func( force_runner = false )	// self == spawned robot
{
	self DisableAimAssist();

	self lotus_util::enemy_on_fire( true );
	
	self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
	if( !force_runner )
	{	
		if( RandomInt( 10 ) < 5 )
		{
			self thread be_creepy_walker_robot();
		}
		else
		{
			self ai::set_behavior_attribute( "rogue_control_speed", "sprint" );	// "run" );
		}
	}
}

function shooter_group_func()	// self == spawned robot
{
	self ai::set_behavior_attribute( "rogue_control", "forced_level_1" );
	self ai::set_behavior_attribute( "move_mode", "rusher" );
}

function rpg_group_func()	// self == spawned robot
{
	self ai::set_behavior_attribute( "rogue_control", "forced_level_1" );
}

function raps_group_func()	// self == spawned RAP
{
	self.team = "team3";
}

function wasp_group_func()	// self == spawned wasp
{
	self.team = "team3";
}

function leaper_group_func()	// self == spawned robot
{
	self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );

	a_aligners = struct::get_array( self.targetname + "_leaper_align", "targetname" );
	n_randy = RandomInt( a_aligners.size );
	Assert( IsDefined( a_aligners[ n_randy ].script_noteworthy ), "Aligner does not have script_noteworthy info!" );
	if( a_aligners[ n_randy ].script_noteworthy == "jump_left" )
	{
		a_aligners[ n_randy ] scene::play( "cin_lot_12_01_minigun_vign_invadetop_robot01", self );
	}
	else if( a_aligners[ n_randy ].script_noteworthy == "jump_right" )
	{
		a_aligners[ n_randy ] scene::play( "cin_lot_12_01_minigun_vign_invadetop_robot02", self );
	}
	else
	{
		Assert( "Aligner's script_noteworthy set to weird value!" );
	}
}

function zombie_flaming_group_func()	// self == spawned robot
{
	self DisableAimAssist();
	self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
	self lotus_util::enemy_on_fire( true );
}

function climber_group_func()	// self == spawned robot
{
	self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
	
	self lotus_util::enemy_on_fire( true );

	a_aligners = struct::get_array( self.targetname + "_climber_align", "targetname" );
	n_randy = RandomInt( a_aligners.size );
	self animation::play( "ch_lot_12_01_minigun_vign_invade_robot01", a_aligners[ n_randy ] );
}

function mobile_shop_spawn_func( spawn_type )	// self == spawned robot
{
	self endon( "death" );
	
	self DisableAimAssist();
	self.goalradius = 32;
	
	a_me_and_my_clique = GetEntArray( self.targetname, "targetname" );
	n_clique_count = a_me_and_my_clique.size - 1;
	e_spot = level.a_ms_teleport_spot_names[ self.targetname + n_clique_count ];
	Assert( IsDefined( e_spot ), "Couldn't find my teleport spot!" );
	self thread brute_force_teleport( e_spot );	// because forceteleport() fails sometimes

	self ai::set_behavior_attribute( "rogue_control", "forced_level_1" );// melee robots will be set to level2/3 after mobile shop stops to prevent pathfind errors
	self waittill( "brute_force_teleported" );
	self SetGoal( GetNode( "atrium01_mobile_shop_node", "targetname" ) );
}

function brute_force_teleport( e_telly )	// self == spawned robot
{
	self endon( "death" );
	if( IsDefined( self.groupname ) )
	{
		level endon( "enemy_" + self.groupname + "_disabled" );
	}
	
	while( DistanceSquared( self.origin, e_telly.origin ) > 90000 )
	{
		/#iPrintLn( "TELLYWHACKER! " + self.targetname );#/
		self forceteleport( e_telly.origin, e_telly.angles );
		wait 0.2;
	}
	
	self notify( "brute_force_teleported" );
}

function mobile_shop_spawn_jumper_func()	// self == spawned robot
{
	self DisableAimAssist();
	if( math::cointoss() )
	{
		if( math::cointoss() )
		{
			self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
		}
		else
		{		
			self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
		}
	}
	else
	{
		self ai::set_behavior_attribute( "rogue_control", "forced_level_1" );
		self ai::set_behavior_attribute( "move_mode", "rusher" );
	}
}


//===========================================
// SKYBRIDGE CLEANUP
//
//===========================================
function skybridge_cleanup()
{
	trigger::wait_till( "skybridge_cleanup_trigger" );
	array::run_all( GetEntArray( "skybridge_cleanup", "script_string" ), &Delete );
}


//===========================================
// PHYSICS FALLING MOBILE SHOPS
//
//===========================================
function falling_mobile_shops()
{
	t_starter = GetEnt( "t2_atrium_intro_trigger", "targetname" );
	t_starter waittill( "trigger" );

	level thread falling_mobile_shop( 1 );
	
	wait 1.2;
	
	a_crushed = GetEntArray( "poor_crushed_bastards", "targetname" );
	a_ai_crushed = [];
	foreach( sp_crushed in a_crushed )
	{
		a_ai_crushed[ a_ai_crushed.size ] = spawner::simple_spawn_single( sp_crushed );
	}
	
	wait 1.3;

	level thread falling_mobile_shop( 2 );

	wait 1.8;
	
	a_crushed = GetEntArray( "poor_crushed_bastards", "targetname" );
	foreach( ai_crushed in a_ai_crushed )
	{
		ai_crushed Kill();
	}
}

function falling_mobile_shop( n_shop )
{
	e_mobile_shop_base = undefined;
	a_mobile_shop_parts = GetEntArray( "falling_mobile_shop_0" + n_shop, "targetname" );
	for( i = 0; i < a_mobile_shop_parts.size; i++ )
	{
		if( a_mobile_shop_parts[ i ].classname == "script_brushmodel" )
		{
			e_mobile_shop_base = a_mobile_shop_parts[ i ];
			a_mobile_shop_parts = array::Remove_Index( a_mobile_shop_parts, i );
		}
	}
	
	if( !IsDefined( e_mobile_shop_base ) )
	{
		AssertMsg( "Mobile shop base falling_mobile_shop_0" + n_shop + " not found");
	}
		
	foreach( e_part in a_mobile_shop_parts )
	{
		e_part LinkTo( e_mobile_shop_base );
	}
	
	s_explo_spot_a = struct::get( "falling_mobile_shop_explosion_0" + n_shop + "a" );
	s_explo_spot_b = struct::get( "falling_mobile_shop_explosion_0" + n_shop + "b" );
	e_mobile_shop_base thread fx::play( "mobile_shop_fall_explosion", s_explo_spot_a.origin, ( 90, 0, 0 )  );
	wait 0.3;
	e_mobile_shop_base thread fx::play( "mobile_shop_fall_explosion", s_explo_spot_b.origin, ( 90, 0, 0 )  );
	e_mobile_shop_base PhysicsLaunch( e_mobile_shop_base.origin + ( 0, 0, 0 ), ( 0, 0, 0 ) );
}

function delete_falling_mobile_shop( str_name )
{
	a_mobile_shop_parts = GetEntArray( str_name, "targetname" );
	foreach( part in a_mobile_shop_parts )
	{
		part Delete();
	}
}


//===========================================
// HEY, KOOL AID MAN
// Robots bust through walls & ceilings
//===========================================
function setup_kool_aid_man_robots()
{
	level thread kool_aid_man_robots( "flaming_wall_hole_01", "p7_fxanim_cp_lotus_wall_hole_break_through_bundle", &flaming_wall_hole_01_func );
	level thread kool_aid_man_robots( "ceiling_hole_01", "p7_fxanim_cp_lotus_t2_ceiling_collapse_bundle" );
	//level thread kool_aid_man_robots( "wall_hole_01", "p7_fxanim_cp_lotus_t2_wall_destruction_bundle" );
}

function kool_aid_man_robots( str_name, str_fx_anim, support_func = undefined )
{
	trigger::wait_till( str_name + "_trigger" );
	level thread scene::play( str_fx_anim );
	spawn_manager::enable( "sm_" + str_name );
	if( IsDefined( support_func ) )
	{
		[[ support_func ]]();
	}
}

function flaming_wall_hole_01_func()
{
	array::run_all( GetEntArray( "ascent_wall_break", "targetname" ), &Delete );
}


//===========================================
// CLEAR FALLEN MOBILE SHOP
// In case it's blocking player/AI path
//===========================================
function clear_fallen_mobile_shop_02()
{
	level waittill( "clear_fallen_mobile_shop_02" );
	
	delete_falling_mobile_shop( "falling_mobile_shop_02" );
}


//===========================================
// INTRO AREA BATTLE
//
//===========================================
function intro_area_battle()
{
	util::waittill_any_ents( 	GetEnt( "intro_spawn_pod_control_trigger_03", "targetname" ), "trigger",
								GetEnt( "intro_area_exit", "targetname" ), "trigger" );
	spawn_manager::enable( "sm_mobile_shop_ramp_raps" );	
}


//===========================================
// ROOM 01 BATTLE
//
//===========================================
function room_01_battle()
{
	trigger::wait_till( "room_01_spawn_pods" );
	
	// only care about the spawn pod groups that will always spawn, don't wait for 01b and 02b if they were spawned
	util::waittill_multiple_ents( 	GetEnt( "room_01_spawn_pod_control_trigger_01a", "targetname" ), "trigger",
									GetEnt( "room_01_spawn_pod_control_trigger_02a", "targetname" ), "trigger" );

	if( !spawn_manager::is_enabled( "sm_room_01_raps" ) )
	{
		spawn_manager::enable( "sm_room_01_raps" );
	}
}


//===========================================
// ROOM 02 BATTLE
//
//===========================================
function room_02_battle()
{
	trigger::wait_till( "room_02_spawn_pods" );
	
	// only care about the spawn pod groups that will always spawn, don't wait for 01b and 02b if they were spawned
	util::waittill_multiple_ents( 	GetEnt( "room_02_spawn_pod_control_trigger_01a", "targetname" ), "trigger",
									GetEnt( "room_02_spawn_pod_control_trigger_02a", "targetname" ), "trigger" );

	trigger::use( "room_02_spawn_pods_continue", "targetname", undefined, false );
}


//===========================================
// ATRIUM BATTLE 01
//
// enemy_group_01 - zombie + shooters that jump down after pod spawns
// enemy_group_02 - zombies that either jump down or leap from wall
// enemy_group_03 - 2 shooters
// enemy_group_04 - jumpers and climbers at top of mobile shop bridge
// enemy_group_05 - shooters & RPG guys on bridge
//
//===========================================
function atrium_battle_01()
{
	level thread spawn_manager::run_func_when_cleared( "sm_atrium01_enemy_group_01", &atrium01_sm_cleared_counter );
	level thread spawn_manager::run_func_when_cleared( "sm_atrium01_enemy_group_02", &atrium01_sm_cleared_counter );
	level thread spawn_manager::run_func_when_cleared( "sm_atrium01_enemy_group_03", &atrium01_sm_cleared_counter );

	level thread atrium_finale_groups_01();
	level thread atrium_finale_groups_failsafe();
	
	level thread atrium01_mobile_shop_logic();

	util::waittill_any_ents( 	level, "atrium01_enemy_group_01_started", 
								GetEnt( "room_02_spawn_pod_control_trigger_03a", "targetname" ), "trigger" );
	
	if( !spawn_manager::is_enabled( "sm_atrium01_enemy_group_01" ) )
	{
		/#iPrintLn( "Pod Spawns CLEARED, so starting GROUP 01" );#/
		spawn_manager::enable( "sm_atrium01_enemy_group_01" );
	}
	else
	{
		/#iPrintLn( "TRIGGER HIT, so starting GROUP 01" );#/
	}
	
	level thread atrium01_enemy_group_02_starter();		// starts enemy_group_02 when enemy_group_01 is cleared
	trigger::wait_or_timeout( 36, "atrium01_main_area" );	// this trigger also starts enemy_group_02

	spawn_manager::enable( "sm_atrium01_enemy_group_03" );	// enemy_group_03 starts after timeout or player hits main_area trigger
	/#if( !spawn_manager::is_enabled( "sm_atrium01_enemy_group_02" ) )
	{
		iPrintLn( "TIMEOUT FINISHED, so starting GROUP 03" );
	}#/
}

function atrium01_enemy_group_02_starter()
{
	/#level thread debug_group_02_message();#/
	level endon( "atrium01_enemy_group_02_started" );
	
	while( !spawn_manager::is_cleared( "sm_atrium01_enemy_group_01" ) )
	{
		wait 0.2;
	}
	
	/#iPrintLn( "GROUP 01 KILLED, so starting GROUP 02" );#/
	
	spawn_manager::enable( "sm_atrium01_enemy_group_02" );
}

/#function debug_group_02_message()
{
	level waittill( "atrium01_enemy_group_02_started" );
	if( !spawn_manager::is_enabled( "sm_atrium01_enemy_group_02" ) )
	{
		iPrintLn( "TRIGGER HIT, so starting GROPU 02" );
	}
}#/

function atrium_finale_groups_01()
{
	level waittill( "atrium01_sm_cleared" );
	level thread atrium_finale_groups_02();
	while( !spawn_manager::is_enabled( "sm_atrium01_enemy_group_03" ) )
	{
		wait 0.2;
	}
	spawn_manager::enable( "sm_atrium01_wasps" );
	spawn_manager::enable( "sm_atrium01_raps_group_01" );
	/#iPrintLn( "1st SM CLEARED, so starting WASPS & RAPS 01" );#/
}

function atrium_finale_groups_02()
{
	level waittill( "atrium01_sm_cleared" );
	level thread atrium_finale_groups_03();
	while( !spawn_manager::is_enabled( "sm_atrium01_enemy_group_03" ) )
	{
		wait 0.2;
	}
	spawn_manager::enable( "sm_atrium01_raps_group_02" );
	spawn_manager::enable( "sm_atrium01_enemy_group_04" );
	spawn_manager::enable( "sm_atrium01_enemy_group_05" );	
	/#iPrintLn( "1st SM CLEARED, so starting RAPS 02 & ENEMY GROUPS 04 & 05" );#/
}
 
function atrium_finale_groups_03()
{ 	
	level waittill( "atrium01_sm_cleared" );
	array::thread_all( GetEntArray( "atrium01_wasps_ai", "targetname" ), &change_wasp_goal_vol ); 	
	/#iPrintLn( "2nd SM CLEARED, so WASPS move closer" );#/
}

function atrium01_sm_cleared_counter()
{
	level notify( "atrium01_sm_cleared" );
}

function change_wasp_goal_vol()	// self == wasp
{
	self SetGoalVolume( GetEnt( "atrium01_close_wasps_goal_vol", "targetname" ) );
}

function atrium_finale_groups_failsafe()
{
	level waittill( "atrium01_start_groups_failsafe" );
	spawn_manager::enable( "sm_atrium01_raps_group_02" );
	spawn_manager::enable( "sm_atrium01_enemy_group_04" );
	spawn_manager::enable( "sm_atrium01_enemy_group_05" );
}


//===========================================
// ATRIUM01 MOBILE SHOP
//
//===========================================
function atrium01_mobile_shop_logic()
{
	level.a_ms_teleport_spot_names = [];
	
	o_vehicle_platform = new cVehiclePlatform();
	[[ o_vehicle_platform ]]->init( "atrium01_mobile_shop", "atrium01_moblie_shop_path" );
	vh_atrium01_mobile_shop = [[ o_vehicle_platform ]]->get_platform_vehicle();
	t_atrium01_mobile_shop_entered = GetEnt( "tower_2_ascent_complete", "targetname" );
	t_atrium01_mobile_shop_entered EnableLinkTo();
	t_atrium01_mobile_shop_entered LinkTo( vh_atrium01_mobile_shop );
	//t_atrium01_mobile_shop_entered thread require_hendricks_for_mobile_shop(); TODO: Hendricks is too unreliable, enable this when he's behaving better
	
	// set up teleport spots because spawners can't be moved
	a_ms_spawners = GetEntArray( "atrium01_mobile_shop", "groupname" );
	foreach( n_index, ms_spawner in a_ms_spawners )
	{
		teleport_spot = spawn( "script_origin", ms_spawner.origin + ( 0, 0, 20 ) );
		teleport_spot.angles = ms_spawner.angles;
		teleport_spot.targetname = ms_spawner.targetname + "_telly";
		teleport_spot SetInvisibleToAll();
		level.a_ms_teleport_spot_names[ ms_spawner.targetname + "_ai" + n_index ] = teleport_spot;
		teleport_spot LinkTo( vh_atrium01_mobile_shop );
	}
	
	trigger::wait_till( "atrium01_mobile_shop_move" );
	trigger::use( "atrium01_mobile_shop_trigger" );
	
	spawn_manager::enable( "sm_atrium01_mobile_shop_enemies" );	
	
	level waittill( "vehicle_platform_atrium01_mobile_shop_stop" );
	array::thread_all( GetNodeArray( "atrium01_mobile_shop_traversal", "targetname" ), &atrium01_mobile_shop_traversals );
	array::thread_all( spawn_manager::get_ai( "sm_atrium01_mobile_shop_enemies" ), &atrium01_mobile_shop_enemies_go );
	spawn_manager::enable( "sm_atrium01_mobile_shop_jumpers" );
}

function atrium01_mobile_shop_traversals()	// self == custom traversal node
{
	LinkTraversal( self );
}

function atrium01_mobile_shop_enemies_go()	// self == mobile shop enemy
{
	switch( self.script_noteworthy )
	{
		case "mobile_shop_shooter_spawners":
			self SetGoal( GetNode( self.target, "targetname" ) );
		break;
		case "mobile_shop_melee_spawners":
			self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
		break;
		case "mobile_shop_suicide_spawners":
			self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
		break;
		default:
			Assert( "Invalid value for mobile shop enemy's script_noteworthy KVP" );
		break;
	}
}

function require_hendricks_for_mobile_shop()	// self == mobile shop trigger
{
	self endon( "trigger" );	// just in case?
	self TriggerEnable( false );
	while ( ( !IsAlive( level.ai_hendricks ) || !level.ai_hendricks IsTouching( self ) ) && level.ai_hendricks.origin[ 2 ] > 16300 )
	{
		wait .2;
	}
	self TriggerEnable( true );
}


//===========================================
// PROMETHEUS RISING
//
//===========================================
function setup_prometheus_rising()
{
	e_prometheus_mobile_shop = undefined;
	a_clamp_open = [];
	a_clamp_closed = [];

	a_ms_parts = GetEntArray( "prometheus_mobile_shop", "targetname" );

		// process every part that's in the mobile shop prefab
	foreach( part in a_ms_parts )
	{
		if( part.classname == "script_brushmodel" )
		{
			if( !IsDefined( part.script_noteworthy ) )
			{
				e_prometheus_mobile_shop = part;
			}
			else if( part.script_noteworthy == "clamp_open" )
			{
				a_clamp_open[ a_clamp_open.size ] = part;
			}
			else if( part.script_noteworthy == "clamp_closed" )
			{
				a_clamp_closed[ a_clamp_closed.size ] = part;
			}
			else
			{
				Assert( "enemy_mobile_shop_setup() found weird script_noteworthy value!" );
			}
		}
	}
		// set up the mobile shop clamps
	for( i = 0; i < a_clamp_open.size; i++ )
	{
		e_clamp_opened = a_clamp_open[ i ];
		e_clamp_closed = a_clamp_closed[ i ];
		e_clamp_opened LinkTo( e_prometheus_mobile_shop );
		e_clamp_closed LinkTo( e_prometheus_mobile_shop );
	}

	anim_bundle = struct::get( "prometheus_rise_idle" );
	e_aligner = util::spawn_model( "tag_origin", anim_bundle.origin, anim_bundle.angles );	// TODO: replace with struct or script_origin to save on network traffic?
	//e_aligner = spawn( "script_origin", anim_bundle.origin );
	//e_aligner.angles = anim_bundle.angles;
	e_aligner LinkTo( e_prometheus_mobile_shop );
	
	level thread prometheus_rising_scene( e_aligner );
}

function prometheus_rising_scene( e_aligner )
{
	trigger::wait_till( "atrium01_mobile_shop_move", "targetname" );
	
	sp_prometheus = GetEnt( "prometheus_for_scene", "targetname" );
	e_prometheus = spawner::simple_spawn_single( sp_prometheus );
	
	t_prometheus_mobile_shop = GetEnt( "prometheus_mobile_shop_trigger", "script_noteworthy" );
	t_prometheus_mobile_shop notify( "trigger" );
	e_prometheus thread animation::play( "ch_lot_11_03_tower2_vign_rise", e_aligner, "tag_origin" );
}


//===========================================
// SPAWN PODS
//
//===========================================
function sgen_style_spawn_pods()
{
	level flag::wait_till( "all_players_connected" );
	
	a_t_spawn_control = GetEntArray( "spawn_pod_control_trigger", "script_noteworthy" );
	array::thread_all( a_t_spawn_control, &spawn_pod_control_trigger_init );
	a_s_spawn_point = struct::get_array( "charging_station_spawn_point" );	// spawn_point structs are part of spawn pod prefabs in geo layer
	a_s_spawn_point = array::randomize( a_s_spawn_point );
	array::thread_all( a_s_spawn_point, &spawn_pod_think );
}

function spawn_pod_control_trigger_init()	// self == spawn pod control trigger
{
	self.n_robot_count = 0;
	self.n_spawn_pod_count = 0;
	self SetInvisibleToAll();
}

function spawn_pod_think()	// self == spawn_point in prefab
{
	sp_general_spawn_pod = GetEnt( "spawn_pod_general_spawner", "targetname" );
	// create models for resting robot body & head, and also spawn pod doors	
	mdl_robot = util::spawn_model( "c_54i_robot_4_body", self.origin, self.angles );


/*	TODO: robot chamber prefab was changed for SGEN & the script_struct for the head was removed because they're just using AI
	robots in the chambers now.  We may want to create a Lotus version of the prefab since we wouldn't want all those AI to be
	spawned into the world from the start?  Or maybe new scripting needs to be done.

	s_head = struct::get( self.target );
	mdl_head = util::spawn_model( "c_54i_robot_4_head", s_head.origin, s_head.angles );
	mdl_head.targetname = "head_track_model";

	s_chamber = struct::get( s_head.target );*/
	s_chamber = struct::get( self.target );
	mdl_test_pod_doors = util::spawn_model( "p7_fxanim_cp_sgen_charging_station_doors_mod", s_chamber.origin, s_chamber.angles );

	spawn_control_trigger_used = false;
	spawn_control_shooter_option = 0;
	spawn_control_on_fire = false;

	// radius trigger is the default for spawning
	use_radius_trigger = true;
	n_trigger_radius = 192;

	// but if a spawn pod control trigger surrounds us, wait for activation trigger
	a_t_spawn_control = GetEntArray( "spawn_pod_control_trigger", "script_noteworthy" );
	a_t_spawn_control = array::randomize( a_t_spawn_control );
	foreach( t_spawn_control in a_t_spawn_control )
	{
		if( mdl_robot IsTouching( t_spawn_control ) )
		{
			// spawn control triggers w/o a target are used to disable auto spawning
			if( !IsDefined( t_spawn_control.target ) )
			{
				// we want an empty spawn pod
				mdl_robot Delete();
				//mdl_head Delete();
				return;
			}

			// spawn pods with control triggers have an associated spawner that has some coop KVPs set
			sp_specific_spawn_pod = GetEnt( t_spawn_control.targetname + "_spawner", "targetname" );
			Assert( IsDefined( sp_specific_spawn_pod ), "Spawner: " + t_spawn_control.targetname + "_spawner NOT FOUND" );

			t_spawn_control.n_spawn_pod_count++;

			// check if we're over the number specified in script_int, & also check coop count KVPs on our specific spawner
			if( ( IsDefined( t_spawn_control.script_int ) && t_spawn_control.n_spawn_pod_count > t_spawn_control.script_int )
			||	( IsDefined( sp_specific_spawn_pod.script_minplayers ) && ( sp_specific_spawn_pod.script_minplayers > level.players.size ) )
		    || 	( IsDefined( sp_specific_spawn_pod.script_maxplayers ) && ( sp_specific_spawn_pod.script_maxplayers < level.players.size ) ) )
			{
				// we want an empty spawn pod if we're over the robot limit or co-op count KVPs tell us to not spawn
				mdl_robot Delete();
				//mdl_head Delete();
				t_spawn_control.n_spawn_pod_count--;	// adjust the spawn pod count since I'm removing myself as a spawner
				return;
			}
			
			trigger::wait_till( t_spawn_control.target );	// spawn pod control triggers target another trigger which controls activation eligibility
			use_radius_trigger = false;	// by default, skip the radius trigger
			n_trigger_radius = t_spawn_control.script_radius;
			if( IsDefined( n_trigger_radius ) )
			{
				use_radius_trigger = true;	// but if the activation trigger has a script_radius KVP, use radius trigger
			}
			spawn_control_trigger_used = true;
			break;
		}
	}
	
	// radius trigger for spawning
	if( use_radius_trigger )
	{
		t_test_pod = spawn( "trigger_radius", self.origin, 0, n_trigger_radius, 128 );
		t_test_pod waittill( "trigger" );
	}
	
	if( spawn_control_trigger_used )
	{
		if( IsDefined( t_spawn_control.script_string ) )
		{
			a_control_string = StrTok( t_spawn_control.script_string, "," );

			foreach( control_string in a_control_string )
			{
				switch( control_string )
				{
					case "no_shooters":
						spawn_control_shooter_option = 1;
					break;
					case "only_shooters":
						spawn_control_shooter_option = 2;
					break;
					case "on_fire":
						spawn_control_on_fire = true;
					break;
					default:
						Assert( "Unsupported string in script_string KVP" );
					break;
				}
			}
		}
		t_spawn_control util::script_delay();	// wait if script_delay is defined		
		wait( RandomFloatRange( 0.1, 0.6 ) * t_spawn_control.n_spawn_pod_count );	// additional wait to create separation in group spawn
	}
	
	// spawn a robot and teleport it into position
	ai_robot = sp_general_spawn_pod spawner::spawn( true );
	if( !IsDefined( ai_robot ) )
	{
		return;
	}
	ai_robot ForceTeleport( self.origin, self.angles );

	// robot setup (melee, shooter, on fire, all that junk)
	if( spawn_control_shooter_option == 0 )
	{
		if( RandomInt( 100 ) > 10 )
		{
			spawn_control_shooter_option = 1;
		}
		else
		{
			spawn_control_shooter_option = 2;
		}
	}
	switch( spawn_control_shooter_option )
	{
		case 1:
			ai_robot ai::set_behavior_attribute( "rogue_allow_pregib", false );
			ai_robot ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
			if( RandomInt( 10 ) < 7 )
			{
				ai_robot thread be_creepy_walker_robot();
			}
		break;
		case 2:
			ai_robot ai::set_behavior_attribute( "rogue_control", "forced_level_1" );
			ai_robot ai::set_behavior_attribute( "move_mode", "rusher" );		
		break;
	}
	if( spawn_control_on_fire )
	{
		ai_robot lotus_util::enemy_on_fire( true );	
	}

	if( spawn_control_trigger_used )
	{
		t_spawn_control.n_robot_count++;
		ai_robot thread death_watcher( t_spawn_control );
	}
	
	mdl_robot Delete();
	//mdl_head Delete();

	mdl_test_pod_doors thread scene::play( "p7_fxanim_cp_sgen_charging_station_break_01_bundle", mdl_test_pod_doors );
	ai_robot scene::play( "cin_sgen_16_01_charging_station_aie_awaken_robot0" + RandomIntRange( 1, 5 ), ai_robot );
	
}

function death_watcher( t_spawn_control )	// self == spawned robot
{
	t_spawn_control endon( "death" );
	self waittill( "death" );
	
	t_spawn_control.n_robot_count--;
	if( t_spawn_control.n_robot_count <= 0 )
	{
		t_spawn_control trigger::use();
	}
}


//===========================================
// UTILITIES
//
//===========================================
function be_creepy_walker_robot()
{
	self endon( "death" );
	n_closest_2d_dist_sq = ( 768 * 768 ) + 100;
	while( n_closest_2d_dist_sq > ( 768 * 768 ) )
	{
		wait 1;
		closest_player = array::get_closest( self.origin, level.players );
		n_closest_2d_dist_sq = Distance2DSquared( self.origin, closest_player.origin );
	}
	self ai::set_behavior_attribute( "rogue_control_speed", "walk" );
	self thread robot_run_when_hurt();
}

function robot_run_when_hurt()
{
	self endon( "death" );
	self waittill( "damage" );
	self ai::set_behavior_attribute( "rogue_control_speed", "sprint" );	// "run" );
}




